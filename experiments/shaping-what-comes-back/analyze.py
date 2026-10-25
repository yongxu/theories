"""Verdicts of LA3 by the rules frozen in PREDICTIONS-2026-10-25.md.

    python3 analyze.py      # writes results/VERDICTS.json and prints a table

A condition passes if the final choice is the predicted policy in at least 4 of its 5 seeds (an invalid
final choice counts against it); a contrast passes if all its conditions pass.  The bridge H1-LA3 is
reported, not counted: in how many seeds the agent played both policies and ended on the one with the
higher mean of the scores it saw, and in how many it played only one.  H1-LA3 holds in a condition
where at least 4 of its 5 seeds played both policies and ended on the better seen; otherwise it is low.
"""

import json
import os

from game import CONDITIONS

HERE = os.path.dirname(os.path.abspath(__file__))

CONTRASTS = {
    "K1_split_same_total_kept_or_shared": ["s2p3", "s0p5"],
    "K2_kept_covering_the_cost_whatever_shared": ["s2p0", "s2p3"],
    "K3_nothing_back_whatever_shared": ["s0p0", "s0p5"],
    "K4_shared_part_turns_a_stretch": ["m2n1_p0", "m2n1_p5"],
}


def predicted():
    vals = json.load(open(os.path.join(HERE, "results", "values.json")))
    return {n: vals["conditions"][n]["predicted"] for n in CONDITIONS}


def bridge(r):
    seen = {}
    for h in r["history"]:
        seen.setdefault(h["policy"], []).append(h["score"])
    if len(seen) < 2:
        return None
    better = "S" if sum(seen["S"]) / len(seen["S"]) > sum(seen["N"]) / len(seen["N"]) else "N"
    return r["choices"][-1] == better


def verdicts(runs, pred):
    out = dict(conditions={}, contrasts={})
    for name in CONDITIONS:
        rs = [r for r in runs if r["cond"] == name]
        final = [r["choices"][-1] for r in rs]
        hits = sum(1 for f in final if f == pred[name])
        b = [bridge(r) for r in rs]
        better = sum(1 for x in b if x)
        out["conditions"][name] = dict(
            predicted=pred[name], final=final, first=[r["choices"][0] for r in rs], hits=hits, seeds=len(rs),
            verdict="passed" if hits >= 4 else "failed",
            played_both=sum(1 for x in b if x is not None), played_one=sum(1 for x in b if x is None),
            final_is_better_seen=better, H1_holds=better >= 4)
    for k, names in CONTRASTS.items():
        out["contrasts"][k] = all(out["conditions"][n]["verdict"] == "passed" for n in names)
    return out


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    out = verdicts(runs, predicted())
    json.dump(out, open(os.path.join(HERE, "results", "VERDICTS.json"), "w"), indent=1)
    for n, d in out["conditions"].items():
        print(f"{n:8} predicted {d['predicted']} first {d['first']} final {d['final']} -> {d['verdict']} "
              f"(H1-LA3 {'holds' if d['H1_holds'] else 'low'}: final = better seen in {d['final_is_better_seen']} "
              f"of {d['played_both']} seeds that played both; {d['played_one']} played one)")
    for k, v in out["contrasts"].items():
        print(k, "passed" if v else "failed")


if __name__ == "__main__":
    main()
