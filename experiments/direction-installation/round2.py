"""IN1 round 2: one round of talk before each month's decisions.

Each month, first every fisher posts one public message with the catch it
intends (simultaneously); then each sees the three messages and decides
privately (nothing binds). Cells: COMM_SEEN_TALK, DIR_SEEN_TALK,
DIR_UNSEEN_TALK; same lake, instructions, models and seeds as round 1.

python3 round2.py           the frozen configuration (results/runs-round2/...)
python3 round2.py --smoke D every code path with a scripted client, written to D
"""

from __future__ import annotations

import argparse
import json
from concurrent.futures import ThreadPoolExecutor
from dataclasses import asdict
from pathlib import Path

from agents import OpenAIClient, ScriptedClient, report, system_prompt
from lake import FISHERS, Lake, check_identities

CONFIG = {
    "models": ["gpt-5.4-mini", "gpt-4.1-mini"],
    "cells": ["COMM_SEEN_TALK", "DIR_SEEN_TALK", "DIR_UNSEEN_TALK"],
    "seeds": 10,
    "parallel_runs": 10,
}

TALK_RULE = ("\n- Each month, before anyone fishes, every fisher posts one public message to the other two, "
             "which all three read before deciding. Messages bind no one.")

SAY_SCHEMA = {
    "name": "message",
    "strict": True,
    "schema": {
        "type": "object",
        "properties": {"message": {"type": "string"}, "intended_catch": {"type": "integer"}},
        "required": ["message", "intended_catch"],
        "additionalProperties": False,
    },
}


def talk_system(cell: str, name: str) -> str:
    s = system_prompt(cell.replace("_TALK", ""), name)
    return s.replace("\n- The lake and the fishers go on after this season.",
                     TALK_RULE + "\n- The lake and the fishers go on after this season.")


def say_prompt(lake, cell, name):
    r = report(lake, cell.replace("_TALK", ""), name)
    head = r[: r.index(f"\n\nYou are {name}.")]
    return head + (f"\n\nYou are {name}. Post your public message for this month to the other two fishers (at most "
                   f"50 words), and state the catch you intend. Reply in JSON with \"message\" and "
                   f"\"intended_catch\" (a whole number of tons from 0 to {lake.stock}).")


def decide_prompt(lake, cell, name, said):
    r = report(lake, cell.replace("_TALK", ""), name)
    msgs = "\n".join(f"{FISHERS[i]} (intends {s['intended_catch']} tons): \"{s['message']}\"" for i, s in enumerate(said))
    i = r.index(f"\n\nYou are {name}.")
    return r[:i] + "\n\nThis month's messages:\n" + msgs + r[i:].replace("How many tons do you catch this month?",
                                                                       "Now decide privately: how many tons do you catch this month?")


class TalkClient:
    """Wraps a client: say() uses the message schema, decide() the decision schema."""

    def __init__(self, client):
        self.c = client
        self.model = client.model

    def say(self, system, user, seed):
        if isinstance(self.c, ScriptedClient):
            return {"message": "scripted", "intended_catch": self.c.catch, "valid": True, "usage": {}}
        body = self.c.body(system, user, seed)
        body["response_format"] = {"type": "json_schema", "json_schema": SAY_SCHEMA}
        return _post(self.c, body, ("message", "intended_catch"))

    def decide(self, system, user, seed):
        return self.c.decide(system, user, seed)


def _post(client, body, keys):
    import time
    import urllib.error
    import urllib.request
    data = json.dumps(body).encode()
    delay = 2.0
    for attempt in range(8):
        req = urllib.request.Request(client.url, data=data, headers={
            "Authorization": "Bearer " + client.key, "Content-Type": "application/json"})
        try:
            with urllib.request.urlopen(req, timeout=180) as r:
                d = json.load(r)
            p = json.loads(d["choices"][0]["message"].get("content") or "")
            return {"message": str(p[keys[0]]), "intended_catch": int(p[keys[1]]), "usage": d.get("usage", {}),
                    "valid": True, "attempts": attempt + 1}
        except urllib.error.HTTPError as e:
            if e.code in (429, 500, 502, 503, 504):
                time.sleep(delay)
                delay = min(60.0, delay * 2)
                continue
            raise
        except (urllib.error.URLError, TimeoutError, json.JSONDecodeError, KeyError, ValueError, TypeError):
            time.sleep(delay)
            delay = min(60.0, delay * 2)
    return {"message": "", "intended_catch": None, "usage": {}, "valid": False, "attempts": 8}


def one_season(client, cell, seed):
    lake = Lake()
    calls = []
    while not lake.over:
        mth = len(lake.history)
        with ThreadPoolExecutor(max_workers=3) as ex:
            said = list(ex.map(lambda i: client.say(talk_system(cell, FISHERS[i]), say_prompt(lake, cell, FISHERS[i]),
                                                    seed * 1000 + mth * 10 + i + 5), range(3)))
        if not all(s["valid"] for s in said):
            return {"model": client.model, "cell": cell, "seed": seed, "valid": False, "months": [asdict(m) for m in lake.history]}
        with ThreadPoolExecutor(max_workers=3) as ex:
            out = list(ex.map(lambda i: client.decide(talk_system(cell, FISHERS[i]),
                                                      decide_prompt(lake, cell, FISHERS[i], said),
                                                      seed * 1000 + mth * 10 + i), range(3)))
        if not all(o["valid"] for o in out):
            return {"model": client.model, "cell": cell, "seed": seed, "valid": False, "months": [asdict(m) for m in lake.history]}
        requested = [min(max(o["catch"], 0), lake.stock) for o in out]
        calls.append({"said": said, "decided": [{**o, "requested_clamped": r} for o, r in zip(out, requested)]})
        lake.step(requested)
    return {"model": client.model, "cell": cell, "seed": seed, "valid": True,
            "months": [asdict(m) for m in lake.history], "calls": calls,
            "identity_violations": check_identities(lake.history),
            "bed_kept": lake.bed_alive and len(lake.history) == 12, "lake_kept": not lake.collapsed}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--smoke")
    args = ap.parse_args()
    if args.smoke:
        out_dir, seeds, models = Path(args.smoke), 1, ["scripted-a", "scripted-b"]
        make = lambda m: TalkClient(ScriptedClient(m, 10 if m.endswith("a") else 17))
    else:
        out_dir, seeds, models = Path("results/runs-round2"), CONFIG["seeds"], CONFIG["models"]
        make = lambda m: TalkClient(OpenAIClient(m))
    jobs = [(m, c, s) for m in models for c in CONFIG["cells"] for s in range(seeds)]
    jobs = [j for j in jobs if not (out_dir / j[0] / j[1] / f"{j[2]}.json").exists()]

    def go(job):
        m, c, s = job
        res = one_season(make(m), c, s)
        p = out_dir / m / c / f"{s}.json"
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(json.dumps(res, indent=1))
        return job, res["valid"]

    with ThreadPoolExecutor(max_workers=CONFIG["parallel_runs"]) as ex:
        for job, ok in ex.map(go, jobs):
            print(*job, "valid" if ok else "INVALID", flush=True)


if __name__ == "__main__":
    main()
