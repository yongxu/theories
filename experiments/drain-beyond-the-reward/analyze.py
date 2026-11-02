"""LA4 Stage A's reading (design §6, §8): applies the frozen verdict rules (verdicts.py) to the run's results
and writes results/VERDICTS.json. It first checks every frozen file against results/FROZEN-AT, as run.py
does, and refuses to read if one differs, or if any family, arm or seed 0 to 19 is missing, extra, a smoke
run, or made from another commit or at another length.

Beside the verdicts it reports what the design says is reported, not counted: each arm's values at the end
and at fixed numbers of updates (each measure's mean and each head's gradient norm at every checkpoint), P4
at every level both arms reach, the plateau arm (A4), the uniform start's site check (A1 against C1u),
the head gradient norms beside each comparison against C1, the seeds whose ending choice's advantage was
never resolved, and, for the recurrent family, the sampled evaluations' precision.

Usage: python3 -B analyze.py
       python3 -B analyze.py --unfrozen --sub power-runs --out DIR   (no pin check; reads another folder of
       results/ and writes outside results/, for dry runs)
"""

import argparse
import glob
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import run
import verdicts as V

L_FAMILIES = ("separable", "feedforward", "recurrent")


def load(sub="runs"):
    arms = {}
    for f in sorted(glob.glob(os.path.join(HERE, "results", sub, "*.json"))):
        r = json.load(open(f))
        arms.setdefault(r["family"], {}).setdefault(r["arm"], {})[r["seed"]] = r
    return arms


def summary(recs):
    keys = ("nearness", "ground_nearness", "bay_left", "kept", "disturbance", "ending_choice", "sensitivity_bay")
    out = {}
    for k in keys:
        v = [r["checkpoints"][-1].get(k) for r in recs.values()]
        v = [x for x in v if x is not None]
        out[k] = V.interval(v) if v else None
    caps = [c.get("plateau_capped") for r in recs.values() for c in r["checkpoints"][-3:] if c.get("plateau_capped") is not None]
    out["plateau_capped_late"] = float(np.mean(caps)) if caps else None
    out["capped_evaluations"] = sum(bool(c.get("capped")) for r in recs.values() for c in r["checkpoints"])
    return out


def complete(data, pin):
    """Every family, every arm and exactly the seeds 0 to 19, each run made from the pinned commit at the
    calibrated length and not a smoke run."""
    out = []
    settings = run.settings()
    for fam in L_FAMILIES:
        for arm in run.ARMS:
            seeds = sorted(data.get(fam, {}).get(arm, {}))
            if seeds != list(run.SEEDS):
                out.append(f"{fam} {arm} has seeds {seeds[:3]}… ({len(seeds)}), not 0 to 19")
                continue
            for r in data[fam][arm].values():
                if r.get("pin") != pin or r.get("smoke") or r["settings"]["length"] != settings[fam]["length"] \
                        or r["checkpoints"][-1]["update"] != settings[fam]["length"]:
                    out.append(f"{fam} {arm} seed {r['seed']} was not made from {pin} at the calibrated length")
    extra = set(data) - set(L_FAMILIES)
    if extra:
        out.append(f"unexpected families {sorted(extra)}")
    return out


def by_update(recs):
    """Each measure's mean over seeds at each checkpoint: the comparisons at fixed numbers of updates."""
    keys = ("nearness", "ground_nearness", "bay_left", "kept", "disturbance", "movement")
    n = min(len(r["checkpoints"]) for r in recs.values())
    return [dict(update=next(iter(recs.values()))["checkpoints"][i]["update"],
                 **{k: float(np.mean([r["checkpoints"][i][k] for r in recs.values()])) for k in keys},
                 head_norms={h: float(np.mean([r["checkpoints"][i]["head_norms"][h] or 0 for r in recs.values()]))
                             for h in ("ground", "bay", "site")})
            for i in range(n)]


def p4_levels(arms):
    """P4 at every level both arms reach (design §6: reported, not counted)."""
    return [dict(level=lv, difference=V.interval(V.paired_at_level(arms["A5"], arms["A2"], lv, "bay_left")))
            for lv in V.LEVELS if V.testable([arms["A5"], arms["A2"]], lv)]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--unfrozen", action="store_true")
    ap.add_argument("--sub", default="runs")
    ap.add_argument("--out", help="with --unfrozen, the folder to write into (never results/)")
    args = ap.parse_args()
    pin = None
    if not args.unfrozen:
        pin, bad = run.frozen_ok()
        if bad:
            sys.exit(f"refusing, against the frozen commit {pin}: {'; '.join(bad)}")
    data = load(args.sub)
    if not args.unfrozen:
        problems = complete(data, pin)
        if problems:
            sys.exit("refusing, the run is not the frozen run: " + "; ".join(problems[:10]))
    reads = {fam: V.read_family(arms) for fam, arms in data.items() if set(run.ARMS) <= set(arms)}
    out = dict(outcomes=V.outcomes(reads), reads=reads,
               summaries={fam: {a: summary(r) for a, r in arms.items()} for fam, arms in data.items()},
               by_update={fam: {a: by_update(r) for a, r in arms.items()} for fam, arms in data.items()},
               p4_levels={fam: p4_levels(arms) for fam, arms in data.items() if {"A5", "A2"} <= set(arms)},
               seeds={fam: {a: len(r) for a, r in arms.items()} for fam, arms in data.items()})
    text = json.dumps(out, indent=1, default=float)
    name = "VERDICTS.json" if args.sub == "runs" and not args.unfrozen else f"VERDICTS-{args.sub}-unfrozen.json"
    open(os.path.join(HERE, "results", name) if not args.unfrozen else os.path.join(args.out or ".", name), "w").write(text + "\n")
    for fam, o in out["outcomes"].items():
        print(fam, {p: r["outcome"] for p, r in o.items()})


if __name__ == "__main__":
    main()
