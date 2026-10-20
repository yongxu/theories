"""The model client of VD1 (OpenAI chat completions, strict JSON schema) and the scripted
valuers used only for the dry runs of the analysis."""

from __future__ import annotations

import json
import math
import os
import random
import time
import urllib.error
import urllib.request

from frames import schema


def valid(parsed: dict, labels: list[str]) -> bool:
    return (parsed.get("better") in ("1", "2", "equal")
            and all(isinstance(parsed.get(k), list) and all(x in labels for x in parsed[k])
                    for k in ("continue_1", "continue_2"))
            and isinstance(parsed.get("reason"), str))


class OpenAIClient:
    url = "https://api.openai.com/v1/chat/completions"

    def __init__(self, model: str):
        self.model = model
        self.key = os.environ["OPENAI_API_KEY"]

    def body(self, item: dict, seed: int) -> dict:
        b = {
            "model": self.model,
            "messages": [{"role": "system", "content": item["system"]}, {"role": "user", "content": item["user"]}],
            "response_format": {"type": "json_schema", "json_schema": schema(item["labels"])},
            "seed": seed,
        }
        if self.model.startswith("gpt-5"):
            b["reasoning_effort"] = "low"
            b["max_completion_tokens"] = 4000
        else:
            b["max_completion_tokens"] = 500
        return b

    def judge(self, item: dict, seed: int) -> dict:
        data = json.dumps(self.body(item, seed)).encode()
        delay = 2.0
        for attempt in range(8):
            req = urllib.request.Request(self.url, data=data, headers={
                "Authorization": "Bearer " + self.key, "Content-Type": "application/json"})
            try:
                with urllib.request.urlopen(req, timeout=180) as r:
                    d = json.load(r)
                msg = d["choices"][0]["message"]
                parsed = json.loads(msg.get("content") or "")
                if not valid(parsed, item["labels"]):
                    raise ValueError("invalid")
                return {**parsed, "usage": d.get("usage", {}), "model_returned": d.get("model"),
                        "attempts": attempt + 1, "valid": True}
            except urllib.error.HTTPError as e:
                if e.code in (429, 500, 502, 503, 504):
                    time.sleep(delay)
                    delay = min(60.0, delay * 2)
                    continue
                raise
            except (urllib.error.URLError, TimeoutError, json.JSONDecodeError, KeyError, ValueError, TypeError):
                time.sleep(delay)
                delay = min(60.0, delay * 2)
                continue
        return {"better": None, "reason": "", "continue_1": [], "continue_2": [], "usage": {},
                "model_returned": None, "attempts": 8, "valid": False}


class ScriptedValuer:
    """Dry runs only, no model. Each standpoint draws weights on the six of each frame.

    kind 'weigher': a positive weighting per standpoint (log-normal, sigma 1); ranks by weighed sum.
    kind 'counter': one weight for every formation; ranks by number.
    kind 'random': a uniform choice among 1, 2 and equal.
    misread: the chance that the reading lists drop one item from plan 1's set (the choice is made
    on the misread sets).
    """

    def __init__(self, model: str, kind: str, misread: float = 0.0):
        self.model, self.kind, self.misread = model, kind, misread

    def judge(self, item: dict, seed: int) -> dict:
        rng = random.Random(f"{self.model}-{item['standpoint']}-{item['frame']}")
        w = {x: math.exp(rng.gauss(0, 1)) for x in item["labels"]}
        r = random.Random(seed)
        s1, s2 = list(item["admits_1"]), list(item["admits_2"])
        if self.misread and r.random() < self.misread and s1:
            s1 = s1[:-1]
        if self.kind == "random":
            better = r.choice(["1", "2", "equal"])
        else:
            score = (lambda s: sum(w[x] for x in s)) if self.kind == "weigher" else len
            v1, v2 = score(s1), score(s2)
            better = "1" if v1 > v2 else "2" if v2 > v1 else "equal"
        return {"better": better, "reason": self.kind, "continue_1": s1, "continue_2": s2, "usage": {},
                "model_returned": self.model, "attempts": 1, "valid": True}
