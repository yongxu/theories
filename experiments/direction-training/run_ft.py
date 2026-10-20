"""IN2 runs: the lake under the community's goal alone (no principle), with the
fine-tuned models (results/finetune-receipt.json) and the base model.

python3 run_ft.py           the frozen configuration
python3 run_ft.py --smoke D every code path with a scripted client, written to D
"""

from __future__ import annotations

import argparse
import json
from concurrent.futures import ThreadPoolExecutor
from dataclasses import asdict
from pathlib import Path

from lake_mixed import MixedLake, report, system_prompt
from lake import FISHERS, check_identities
import agents as base_agents
import round2  # IN1 round 2's talk phase (TALK_RULE, SAY_SCHEMA, TalkClient)

CONFIG = {
    "arms": ["FT_DIR", "FT_CTRL", "BASE"],
    "base_model": "gpt-4.1-mini-2025-04-14",
    "cells": ["COMM_SEEN_TALK", "COMM_UNSEEN_TALK", "COMM_SEEN_MIXED_TALK"],
    "seeds": 10,
    "parallel_runs": 10,
}


def model_ids():
    rec = json.loads(Path("results/finetune-receipt.json").read_text())
    return {"FT_DIR": rec["direction"]["fine_tuned_model"], "FT_CTRL": rec["control"]["fine_tuned_model"],
            "BASE": CONFIG["base_model"]}


def sys_t(cell, name):
    """IN2 cells: COMM_SEEN[_MIXED][_TALK], COMM_UNSEEN[_TALK]."""
    s = system_prompt(cell.replace("_TALK", ""), name)
    if cell.endswith("_TALK"):
        s = s.replace("\n- The lake and the fishers go on after this season.",
                      round2.TALK_RULE + "\n- The lake and the fishers go on after this season.")
    return s


def say_t(lake, cell, name):
    r = report(lake, cell.replace("_TALK", ""), name)
    return r[: r.index(f"\n\nYou are {name}.")] + (
        f"\n\nYou are {name}. Post your public message for this month to the other fishers (at most 50 words), and "
        f"state the catch you intend. Reply in JSON with \"message\" and \"intended_catch\" (a whole number of tons "
        f"from 0 to {lake.stock}).")


def decide_t(lake, cell, name, said):
    r = report(lake, cell.replace("_TALK", ""), name)
    if not said:
        return r
    msgs = "\n".join(f"{FISHERS[i]} (intends {s['intended_catch']} tons): \"{s['message']}\"" for i, s in said.items())
    i = r.index(f"\n\nYou are {name}.")
    return r[:i] + "\n\nThis month's messages:\n" + msgs + r[i:].replace(
        "How many tons do you catch this month?", "Now decide privately: how many tons do you catch this month?")


def one_season(client, arm: str, cell: str, seed: int) -> dict:
    lake = MixedLake()
    mixed = "_MIXED" in cell
    talk = cell.endswith("_TALK")
    calls = []
    while not lake.over:
        active = [i for i in range(3) if not (mixed and lake.gone[i])]
        mth = len(lake.history)
        said = {}
        if talk and active:
            with ThreadPoolExecutor(max_workers=3) as ex:
                said = dict(ex.map(lambda i: (i, client.say(sys_t(cell, FISHERS[i]), say_t(lake, cell, FISHERS[i]),
                                                            seed * 1000 + mth * 10 + i + 5)), active))
            if not all(x["valid"] for x in said.values()):
                return {"arm": arm, "model": client.model, "cell": cell, "seed": seed, "valid": False,
                        "months": [asdict(m) for m in lake.history]}

        def ask(i):
            name = FISHERS[i]
            return i, client.decide(sys_t(cell, name), decide_t(lake, cell, name, said),
                                    seed * 1000 + mth * 10 + i)
        with ThreadPoolExecutor(max_workers=3) as ex:
            out = dict(ex.map(ask, active))
        if not all(o["valid"] for o in out.values()):
            return {"arm": arm, "model": client.model, "cell": cell, "seed": seed, "valid": False,
                    "months": [asdict(m) for m in lake.history]}
        requested = [min(max(out[i]["catch"], 0), lake.stock) if i in out else 0 for i in range(3)]
        calls.append({"said": {str(i): x for i, x in said.items()},
                      "decided": {str(i): {**o, "requested_clamped": requested[i]} for i, o in out.items()}})
        lake.step(requested)
    return {
        "arm": arm, "model": client.model, "cell": cell, "seed": seed, "valid": True,
        "months": [asdict(m) for m in lake.history], "calls": calls,
        "identity_violations": check_identities(lake.history),
        "bed_kept": lake.bed_alive and len(lake.history) == 12,
        "lake_kept": not lake.collapsed,
        "fishers_kept": [not g for g in lake.gone] if mixed else [True, True, True],
        "gone_month": lake.gone_month if mixed else [None] * 3,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--smoke")
    args = ap.parse_args()
    if args.smoke:
        out_dir, seeds = Path(args.smoke), 1
        ids = {"FT_DIR": "scripted-10", "FT_CTRL": "scripted-17", "BASE": "scripted-13"}
        make = lambda m: round2.TalkClient(base_agents.ScriptedClient(m, int(m.split("-")[1])))
    else:
        out_dir, seeds = Path("results/runs"), CONFIG["seeds"]
        ids, make = model_ids(), (lambda m: round2.TalkClient(base_agents.OpenAIClient(m)))
    jobs = [(a, c, s) for a in CONFIG["arms"] for c in CONFIG["cells"] for s in range(seeds)]
    jobs = [j for j in jobs if not (out_dir / j[0] / j[1] / f"{j[2]}.json").exists()]

    def go(job):
        a, c, s = job
        res = one_season(make(ids[a]), a, c, s)
        p = out_dir / a / c / f"{s}.json"
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(json.dumps(res, indent=1))
        return job, res["valid"]

    with ThreadPoolExecutor(max_workers=CONFIG["parallel_runs"]) as ex:
        for job, ok in ex.map(go, jobs):
            print(*job, "valid" if ok else "INVALID", flush=True)


if __name__ == "__main__":
    main()
