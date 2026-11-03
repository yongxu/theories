"""The call and the classification of a response, for TR8 and TR-RR.

OpenRouterClient makes one chat completion per call, as VD1 and VD2 did: the key is read from
OPENROUTER_API_KEY in Ren's interactive shell and never printed or logged; strict JSON schema; the
pinned model only (the provider must take every parameter sent); low reasoning effort; a seed per
call; default sampling. A body carrying an error, or no choice, is a failed attempt and is retried. A
moderation rejection, OpenRouter's moderation error (code 403 with its moderation metadata, flagged
input or reasons, whether as the HTTP status, in the body or in a choice), is returned as the
provider's refusal of the call; any other 403 is fatal. StubClient answers from a simulated chooser
for the dry run, in the same shape, and never touches the network. classify() reads a response
exactly, with no reading of free text: the schema's own values and the model's refusal field are the
system's answer, even under a content filter's stop where the answer is complete; a moderation
rejection, or a filter's stop that leaves no complete answer, is the provider's, FILTERED.
This is the one module an addendum may change (FREEZE-1.md, section 8): the request mechanics, the
parser and the reading of a provider's response shapes. The catalog read, the spend guard, the
filtered pause and the served check are in run.py, which no addendum changes. A changed client is
read by an independent reader for what the code cannot check: it imports nothing new and assigns
nothing in another module; it sends exactly the request it built from the frozen prompt and returns
the provider's response unaltered; and its schema and request fields add no words a model reads.
"""

import json
import math
import os
import time
import urllib.error
import urllib.request

from conditions import DECLINE
from rule import FILTERED, INVALID

URL = "https://openrouter.ai/api/v1/chat/completions"
MAX_TOKENS = 4000
REASONING = {"effort": "low"}
RETRY_STATUS = {408, 409, 425, 429, 500, 502, 503, 504, 520, 522, 524, 529}


def moderation(err):
    """OpenRouter's moderation error: code 403 with its moderation metadata (flagged input or reasons)."""
    if not isinstance(err, dict) or str(err.get("code")) != "403":
        return False
    md = err.get("metadata")
    return isinstance(md, dict) and ("flagged_input" in md or "reasons" in md)


def body(model, prompt, seed):
    return {"model": model,
            "messages": [{"role": "user", "content": prompt["user"]}],
            "response_format": {"type": "json_schema",
                                "json_schema": {"name": "answer", "strict": True, "schema": prompt["schema"]}},
            "seed": seed, "max_tokens": MAX_TOKENS, "reasoning": REASONING,
            "provider": {"require_parameters": True, "allow_fallbacks": True},
            "usage": {"include": True}}


class OpenRouterClient:
    live = True

    def __init__(self):
        if not os.environ.get("OPENROUTER_API_KEY"):
            raise SystemExit("OPENROUTER_API_KEY is not set in this shell (Ren's key; it is never printed)")
        self._key = os.environ["OPENROUTER_API_KEY"]

    def call(self, request, meta):
        data = json.dumps(request).encode()
        delay, errors = 2.0, []
        for attempt in range(10):
            req = urllib.request.Request(URL, data=data, headers={
                "Authorization": "Bearer " + self._key, "Content-Type": "application/json",
                "X-Title": "theories RFZ freeze 1"})
            try:
                with urllib.request.urlopen(req, timeout=300) as r:
                    got = json.load(r)
                err = got.get("error") if isinstance(got, dict) else None
                ch = (got.get("choices") or [None])[0] if isinstance(got, dict) else None
                cerr = ch.get("error") if isinstance(ch, dict) else None
                if moderation(err) or moderation(cerr):
                    return {"response": {"rejected": {"status": 403, "body": json.dumps(got)[:500]}},
                            "attempts": attempt + 1, "errors": errors}
                if str((err or {}).get("code") if isinstance(err, dict) else "") == "403" or \
                        str((cerr or {}).get("code") if isinstance(cerr, dict) else "") == "403":
                    errors.append({"status": 200, "body": json.dumps(got)[:500]})
                    return {"response": None, "attempts": attempt + 1, "errors": errors, "fatal": True}
                if err is not None or not isinstance(ch, dict) or ch.get("finish_reason") == "error" or cerr:
                    errors.append({"status": 200, "body": json.dumps(got)[:500]})   # a failed attempt
                else:
                    return {"response": got, "attempts": attempt + 1, "errors": errors}
            except urllib.error.HTTPError as e:
                raw = e.read()
                text = raw[:500].decode(errors="replace")
                errors.append({"status": e.code, "body": text})
                if e.code == 403:
                    try:
                        body = json.loads(raw)
                    except (ValueError, UnicodeDecodeError):
                        body = None
                    if moderation((body or {}).get("error") if isinstance(body, dict) else None):
                        return {"response": {"rejected": {"status": 403, "body": text}},
                                "attempts": attempt + 1, "errors": errors}
                    return {"response": None, "attempts": attempt + 1, "errors": errors, "fatal": True}
                if e.code not in RETRY_STATUS:
                    return {"response": None, "attempts": attempt + 1, "errors": errors, "fatal": True}
            except (urllib.error.URLError, TimeoutError, ConnectionError, json.JSONDecodeError) as e:
                errors.append({"error": type(e).__name__, "text": str(e)[:200]})
            time.sleep(delay)
            delay = min(delay * 2, 120.0)
        return {"response": None, "attempts": 10, "errors": errors, "fatal": False}


class StubClient:
    """The dry run's client: answer(meta) gives the simulated chooser's answer for the call (a label,
    DECLINE, INVALID, FILTERED, or for a probe a dict of numbers by label, or None), in OpenRouter's
    shape; `served` the model the response names (the pin's own by default). No network."""
    live = False

    def __init__(self, answer, served=None):
        self.answer, self.served = answer, served

    def call(self, request, meta):
        a = self.answer(meta)
        by_letter = {lab: L for L, lab in meta["letters"].items()}
        finish = "stop"
        if a == FILTERED:
            content, finish = None, "content_filter"
        elif meta["kind"] == "probe":
            content = None if a is None else json.dumps(
                {"working": "simulated", **{by_letter[lab]: x for lab, x in a.items()}})
        elif a == INVALID:
            content = "no json here"
        else:
            content = json.dumps({"reason": "simulated", "choice": DECLINE if a == DECLINE else by_letter[a]})
        resp = {"model": self.served or request["model"],
                "choices": [{"message": {"content": content}, "finish_reason": finish}],
                "usage": {"prompt_tokens": 0, "completion_tokens": 0, "cost": 0.0}}
        return {"response": resp, "attempts": 1, "errors": []}


def classify(response, kind, letters):
    """A choice: (label | DECLINE | FILTERED | INVALID, None). A probe: (None, {label: number} or None).
    letters maps each shown letter to its option's label. A moderation rejection is FILTERED (no
    numbers for a probe). Otherwise the system's answer is read where it is complete: the schema's
    letter or "decline", or, for a probe, a finite number for every option, even under a content
    filter's stop. Where it is not complete, a content filter's stop is FILTERED (no numbers for a
    probe); else the model's own refusal field is a decline; else INVALID. A response of any other
    shape (a message or a choice that is not of the schema's types) is INVALID, never an error."""
    if isinstance(response, dict) and "rejected" in response:
        return (FILTERED, None) if kind == "choice" else (None, None)
    try:
        ch = response["choices"][0]
        msg = ch.get("message") or {}
    except (TypeError, KeyError, IndexError, AttributeError):
        return (INVALID, None) if kind == "choice" else (None, None)
    if not isinstance(msg, dict):
        msg = {}
    filtered = ch.get("finish_reason") == "content_filter"
    try:
        parsed = json.loads(msg.get("content") or "")
    except (TypeError, json.JSONDecodeError):
        parsed = None
    if kind == "choice":
        said = parsed.get("choice") if isinstance(parsed, dict) else None
        said = said if isinstance(said, str) else None
        if said == DECLINE:
            return DECLINE, None
        if said in letters:
            return letters[said], None
        if filtered:
            return FILTERED, None
        return (DECLINE if msg.get("refusal") else INVALID), None
    if isinstance(parsed, dict) and all(isinstance(parsed.get(L), (int, float)) and not isinstance(parsed.get(L), bool)
                                        and math.isfinite(parsed[L]) for L in letters):
        return None, {letters[L]: float(parsed[L]) for L in letters}
    return None, None
