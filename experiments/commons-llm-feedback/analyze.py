"""Verdicts of LA1 by the rules frozen in PREDICTIONS-2026-10-22.md.

    python3 analyze.py      # writes results/VERDICTS.json and prints a table
"""

import json
import os

from values import CONDITIONS

HERE = os.path.dirname(os.path.abspath(__file__))


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    vals = json.load(open(os.path.join(HERE, "results", "values.json")))
    out = dict(conditions={}, contrasts={})
    for name, c in CONDITIONS.items():
        rs = [r for r in runs if r["cond"] == name]
        final = [r["choices"][-1] for r in rs]
        first = [r["choices"][0] for r in rs]
        if c["lock"] == "locked":
            hits = sum(1 for m in final if m == 0)
            predicted = "m = 0"
        else:
            hits = sum(1 for m in final if m is not None and m >= 1)
            predicted = "m >= 1"
        v = vals[name]["values"]
        out["conditions"][name] = dict(
            cls=c["lock"], predicted=predicted, final=final, first=first, hits=hits, seeds=len(rs),
            verdict="passed" if hits >= 4 else "failed",
            final_value_share=[(v[m] / vals[name]["best_value"]) if m is not None else None for m in final])
    V = {n: d["verdict"] == "passed" for n, d in out["conditions"].items()}
    out["contrasts"] = dict(
        L1_locked_side=all(V[n] for n, c in CONDITIONS.items() if c["lock"] == "locked"),
        L2_open_side=all(V[n] for n, c in CONDITIONS.items() if c["lock"] == "open"),
        L3_end_weight_does_not_open=V["k3s1"] and V["k3s1_lam32"],
        L4_boundary_is_the_rest=V["k3s8"] and V["k2s8"])
    json.dump(out, open(os.path.join(HERE, "results", "VERDICTS.json"), "w"), indent=1)
    for n, d in out["conditions"].items():
        print(f"{n:12} {d['cls']:7} {d['predicted']:7} first {d['first']} final {d['final']} -> {d['verdict']}")
    for k, v in out["contrasts"].items():
        print(k, "passed" if v else "failed")


if __name__ == "__main__":
    main()
