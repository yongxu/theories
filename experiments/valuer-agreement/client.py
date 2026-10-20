"""The model clients of VD1 and the scripted valuers used only for the dry runs of the analysis.

OpenAIClient is the client of the original freeze (OpenAI chat completions, strict JSON schema);
the account had no credit, so it made no experimental call. ClaudeCLIClient is the client of the
addendum (PREDICTIONS-ADDENDUM-2026-10-21.md): one headless Claude Code call per judgment, with the
standpoint as the whole system prompt, no tools, no MCP servers, no CLAUDE.md, skills, plugins or
hooks (--safe-mode), no session saved, run from an empty directory."""

from __future__ import annotations

import json
import math
import os
import random
import subprocess
import tempfile
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


class LimitReached(Exception):
    """The plan's usage limit stopped the run: no further call is made."""


# Variables that tie a child process to the desktop host's session messaging; the valuer gets none.
_HOST_VARS = ("CLAUDE_CODE_MESSAGING_SOCKET", "CLAUDE_CODE_MESSAGING_TOKEN", "CLAUDE_CODE_HOST_SESSION_ID",
              "CLAUDE_CODE_SESSION_ID", "CLAUDE_CODE_CHILD_SESSION")


class ClaudeCLIClient:
    def __init__(self, model: str, exe: str | None = None):
        self.model = model
        self.exe = exe or os.environ.get("VD1_CLAUDE") or os.environ["CLAUDE_CODE_EXECPATH"]
        self.workdir = tempfile.mkdtemp(prefix="vd1-valuer-")
        self.env = {k: v for k, v in os.environ.items() if k not in _HOST_VARS}

    def command(self, item: dict) -> list[str]:
        return [self.exe, "-p", "--model", self.model, "--system-prompt", item["system"], "--safe-mode",
                "--tools", "", "--strict-mcp-config", "--no-session-persistence", "--effort", "low",
                "--json-schema", json.dumps(schema(item["labels"])["schema"]), "--output-format", "json"]

    @staticmethod
    def parse(d: dict):
        out = d.get("structured_output")
        if isinstance(out, dict):
            return out
        text = (d.get("result") or "").strip()
        if text.startswith("```"):
            text = text.strip("`").split("\n", 1)[-1]
        return json.loads(text)

    def judge(self, item: dict, seed: int) -> dict:
        delay = 5.0
        for attempt in range(6):
            try:
                proc = subprocess.run(self.command(item), input=item["user"], capture_output=True, text=True,
                                      cwd=self.workdir, env=self.env, timeout=600)
                d = json.loads(proc.stdout)
            except (subprocess.TimeoutExpired, json.JSONDecodeError):
                time.sleep(delay)
                delay = min(120.0, delay * 2)
                continue
            if d.get("is_error"):
                if d.get("api_error_status") == 429 and "limit" in (d.get("result") or "").lower():
                    raise LimitReached(d.get("result"))
                time.sleep(delay)
                delay = min(120.0, delay * 2)
                continue
            try:
                parsed = self.parse(d)
            except (json.JSONDecodeError, TypeError, ValueError):
                parsed = None
            if isinstance(parsed, dict) and valid(parsed, item["labels"]):
                return {**{k: parsed[k] for k in ("reason", "better", "continue_1", "continue_2")},
                        "usage": d.get("usage", {}), "model_returned": sorted(d.get("modelUsage", {}).keys()),
                        "cost_usd": d.get("total_cost_usd"), "attempts": attempt + 1, "valid": True}
            time.sleep(delay)
            delay = min(120.0, delay * 2)
        return {"better": None, "reason": "", "continue_1": [], "continue_2": [], "usage": {},
                "model_returned": None, "attempts": 6, "valid": False}


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
