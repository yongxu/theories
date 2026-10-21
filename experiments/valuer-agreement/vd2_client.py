"""The clients of VD2: VD1's OpenRouter client (client.py) with each task's own schema and check, and
the scripted valuers and judges of the dry runs.

The key is read from OPENROUTER_API_KEY and sent only in the Authorization header; it is never
printed, logged or written (client.OpenRouterClient)."""

from __future__ import annotations

import json
import math
import random
import time
import urllib.error
import urllib.request

from client import LimitReached, NoReply, OpenRouterClient
from frames import schema as rank_schema
from vd2_frames import GAIN, LEVELS, LOSS, sign_schema

JUDGE_KEYS = ("explanation", "verdict")


def judge_schema() -> dict:
    return {
        "name": "check",
        "strict": True,
        "schema": {
            "type": "object",
            "properties": {"explanation": {"type": "string"},
                           "verdict": {"type": "string", "enum": ["consistent", "inconsistent"]}},
            "required": list(JUDGE_KEYS),
            "additionalProperties": False,
        },
    }


def task_schema(item: dict) -> dict:
    return {"sign": lambda: sign_schema(item["levels"]), "rank": lambda: rank_schema(item["labels"]),
            "judge": judge_schema}[item["task"]]()


def task_keys(item: dict) -> tuple:
    return {"sign": ("reason", "ending"), "rank": ("reason", "better", "continue_1", "continue_2"),
            "judge": JUDGE_KEYS}[item["task"]]


def task_valid(item: dict, parsed) -> bool:
    if not isinstance(parsed, dict):
        return False
    if item["task"] == "sign":
        return parsed.get("ending") in LEVELS and isinstance(parsed.get("reason"), str)
    if item["task"] == "judge":
        return parsed.get("verdict") in ("consistent", "inconsistent") and isinstance(parsed.get("explanation"), str)
    labels = item["labels"]
    return (parsed.get("better") in ("1", "2", "equal")
            and all(isinstance(parsed.get(k), list) and all(x in labels for x in parsed[k])
                    for k in ("continue_1", "continue_2"))
            and isinstance(parsed.get("reason"), str))


class OpenRouterTask(OpenRouterClient):
    """VD1's OpenRouter client, settings and retries unchanged, with the item's own schema and check."""

    def body(self, item: dict, seed: int) -> dict:
        b = super().body({**item, "labels": item.get("labels", [])}, seed)
        if "response_format" in b and b["response_format"].get("type") == "json_schema":
            b["response_format"] = {"type": "json_schema", "json_schema": task_schema(item)}
        return b

    def judge(self, item: dict, seed: int) -> dict:
        data = json.dumps(self.body(item, seed)).encode()
        delay = 5.0
        replied = False
        for attempt in range(8):
            self.pacer.wait()
            req = urllib.request.Request(self.url, data=data, headers={
                "Authorization": "Bearer " + self.key, "Content-Type": "application/json"})
            try:
                with urllib.request.urlopen(req, timeout=300) as r:
                    d = json.load(r)
                if "error" in d and "choices" not in d:
                    raise ValueError("error body")
                replied = True
                parsed = self.parse(d["choices"][0]["message"].get("content") or "")
                if not task_valid(item, parsed):
                    raise ValueError("invalid")
                return {**{k: parsed[k] for k in task_keys(item)},
                        "usage": d.get("usage", {}), "model_returned": d.get("model"),
                        "provider": d.get("provider"), "attempts": attempt + 1, "valid": True}
            except urllib.error.HTTPError as e:
                text = e.read().decode(errors="replace")[:500]
                if e.code == 429 and "per-day" in text.lower().replace(" ", "-"):
                    raise LimitReached(f"{self.model}: daily cap")
                if e.code in (408, 429, 500, 502, 503, 504):
                    time.sleep(delay)
                    delay = min(120.0, delay * 2)
                    continue
                raise RuntimeError(f"{self.model}: HTTP {e.code}: {text[:300]}")
            except (urllib.error.URLError, TimeoutError, json.JSONDecodeError, KeyError, IndexError,
                    ValueError, TypeError):
                time.sleep(delay)
                delay = min(120.0, delay * 2)
                continue
        if not replied:
            raise NoReply(f"{self.model}: no reply in 8 attempts")
        return {**{k: None for k in task_keys(item)}, "usage": {}, "model_returned": None, "attempts": 8,
                "valid": False}


NEGATIVE = (10, 15)   # the standpoints the dry runs' scripted valuers weigh below zero


class ScriptedValuer:
    """Dry runs only, no model. Each (model, standpoint, frame) draws a weight on each of the six:
    log-normal (sigma 1), and at the standpoints NEGATIVE each weight is negated with chance 0.35.

    kind 'signed': the sign task reports the weight's sign (|w| < 0.1 neither; |w| >= 1 serious),
      replaced by "neither" with chance `noise`; the ranking is by weighed sum on the plans' sets.
    kind 'pressure': the same sign answers; the ranking weighs every formation positively, but at the
      standpoints NEGATIVE chooses the narrower plan with chance 0.35 whatever the signs.
    kind 'counter': every sign a loss; the ranking counts.
    kind 'random': uniform answers in both tasks.
    misread: the chance that the ranking's lists drop one item from plan 1's set (the choice is made
    on the misread sets).
    sd: per-call noise; every call (each elicitation, each ranking) reads each weight as w + N(0, sd),
    so a weight near zero is signed and ranked inconsistently across calls.
    """

    def __init__(self, model: str, kind: str, misread: float = 0.0, noise: float = 0.05, sd: float = 0.0):
        self.model, self.kind, self.misread, self.noise, self.sd = model, kind, misread, noise, sd

    def weights(self, item: dict) -> dict:
        from frames import FRAMES
        rng = random.Random(f"{self.model}-{item['standpoint']}-{item['frame']}")
        labels = [f[0] for f in FRAMES[item["frame_index"]]["formations"]]
        w = {x: math.exp(rng.gauss(0, 1)) for x in labels}
        if item["standpoint"] in NEGATIVE:
            w = {x: (-v if rng.random() < 0.35 else v) for x, v in w.items()}
        return w

    def judge(self, item: dict, seed: int) -> dict:
        r = random.Random(f"{self.model}-{seed}-{item['key']}")
        base = {"usage": {}, "model_returned": self.model, "attempts": 1, "valid": True}
        if item["task"] == "sign":
            if self.kind == "random":
                level = r.choice(LEVELS)
            elif self.kind == "counter":
                level = r.choice(LOSS)
            else:
                v = self.weights(item)[item["formation"]] + (r.gauss(0, self.sd) if self.sd else 0.0)
                level = ("neither" if abs(v) < 0.1 else
                         (LOSS[0] if v >= 1 else LOSS[1]) if v > 0 else (GAIN[1] if v <= -1 else GAIN[0]))
                if r.random() < self.noise:
                    level = "neither"
            return {"reason": self.kind, "ending": level, **base}
        s1, s2 = list(item["admits_1"]), list(item["admits_2"])
        if self.misread and r.random() < self.misread and s1:
            s1 = s1[:-1]
        if self.kind == "random":
            better = r.choice(["1", "2", "equal"])
        elif self.kind == "counter":
            better = "1" if len(s1) > len(s2) else "2" if len(s2) > len(s1) else "equal"
        else:
            w = {x: v + (r.gauss(0, self.sd) if self.sd else 0.0) for x, v in self.weights(item).items()}
            if self.kind == "pressure":
                w = {x: abs(v) for x, v in w.items()}
            v1, v2 = sum(w[x] for x in s1), sum(w[x] for x in s2)
            better = "1" if v1 > v2 else "2" if v2 > v1 else "equal"
            if self.kind == "pressure" and item["standpoint"] in NEGATIVE and r.random() < 0.35:
                better = "1" if len(s1) < len(s2) else "2"
        return {"reason": self.kind, "better": better, "continue_1": s1, "continue_2": s2, **base}


class ScriptedJudge:
    """Dry runs only: calls every reason consistent."""

    def __init__(self, model: str):
        self.model = model

    def judge(self, item: dict, seed: int) -> dict:
        return {"explanation": "scripted", "verdict": "consistent", "usage": {}, "model_returned": self.model,
                "attempts": 1, "valid": True}
