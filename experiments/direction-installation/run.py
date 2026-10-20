"""Runs IN1: every model x cell x seed, one season each (results/runs/...).

python3 run.py            the frozen configuration (OpenAI API)
python3 run.py --smoke D  every code path with a scripted client, written to D
"""

from __future__ import annotations

import argparse
import json
from concurrent.futures import ThreadPoolExecutor
from dataclasses import asdict
from pathlib import Path

from agents import CELLS, OpenAIClient, ScriptedClient, report, system_prompt
from lake import FISHERS, Lake, check_identities

CONFIG = {
    "models": ["gpt-5.4-mini", "gpt-4.1-mini"],
    "cells": list(CELLS),
    "seeds": 10,
    "parallel_runs": 10,
}


def one_season(client, cell: str, seed: int) -> dict:
    lake = Lake()
    calls = []
    while not lake.over:
        def ask(i):
            name = FISHERS[i]
            return client.decide(system_prompt(cell, name), report(lake, cell, name),
                                 seed * 1000 + len(lake.history) * 10 + i)
        with ThreadPoolExecutor(max_workers=3) as ex:
            out = list(ex.map(ask, range(3)))
        if not all(o["valid"] for o in out):
            return {"model": client.model, "cell": cell, "seed": seed, "valid": False, "calls": calls + [out],
                    "months": [asdict(m) for m in lake.history]}
        requested = [min(max(o["catch"], 0), lake.stock) for o in out]
        calls.append([{**o, "requested_clamped": r} for o, r in zip(out, requested)])
        lake.step(requested)
    return {
        "model": client.model, "cell": cell, "seed": seed, "valid": True,
        "months": [asdict(m) for m in lake.history],
        "calls": calls,
        "identity_violations": check_identities(lake.history),
        "bed_kept": lake.bed_alive and len(lake.history) == 12,
        "lake_kept": not lake.collapsed,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--smoke")
    args = ap.parse_args()
    if args.smoke:
        out_dir, seeds = Path(args.smoke), 1
        make = lambda m: ScriptedClient(m, 10 if m.endswith("a") else 17)
        models = ["scripted-a", "scripted-b"]
    else:
        out_dir, seeds = Path("results/runs"), CONFIG["seeds"]
        make, models = OpenAIClient, CONFIG["models"]
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
