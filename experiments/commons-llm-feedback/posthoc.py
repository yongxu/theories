"""Post hoc reading of LA1, written after the frozen verdicts fell (25 October 2026).

Not part of the frozen rules in PREDICTIONS-2026-10-22.md: nothing here changes a verdict.

    python3 posthoc.py      # writes results/POSTHOC.json and prints a summary

Three readings:

1. The bridge H1-LM (does in-context revision follow the reported results?): how the choices
   move from the prior choice (round 0, before any result) to the final one, by class.
2. How finely the feedback resolves the thresholds the misses landed on: for each locked
   condition, the spread of a round's mean reward (20 episodes, fresh regrowth streams, as
   the agent saw it) at m = 0, 1, 2, and the chance that one round at m = 1 (or 2) reports a
   mean reward at least as high as one round at m = 0.
3. Whether the end weight moved the final choices: Fisher's exact test on the locked
   conditions' final choices at m = 0, end weight 2 against 32 (k3s1 against k3s1_lam32).
"""

import json
import os
import statistics
import sys
from math import comb

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.append(os.path.join(HERE, "..", "commons-outrun"))
sys.path.append(os.path.join(HERE, "..", "commons-gated-renewal"))
import run  # noqa: E402
from values import CONDITIONS  # noqa: E402

ROUNDS = 1000


def fisher_two_sided(a, b, c, d):
    """Fisher's exact test for the 2x2 table [[a, b], [c, d]], two-sided by summing tables no
    more probable than the observed one."""
    n1, n2, k = a + b, c + d, a + c
    total = comb(n1 + n2, k)

    def p(x):
        return comb(n1, x) * comb(n2, k - x) / total

    observed = p(a)
    lo, hi = max(0, k - n2), min(k, n1)
    return sum(p(x) for x in range(lo, hi + 1) if p(x) <= observed + 1e-12)


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    vals = json.load(open(os.path.join(HERE, "results", "values.json")))
    out = dict(note="post hoc; not part of the frozen verdicts", bridge={}, resolution={}, end_weight={})

    for cls in ("locked", "open"):
        rs = [r for r in runs if CONDITIONS[r["cond"]]["lock"] == cls]
        first = [r["choices"][0] for r in rs]
        final = [r["choices"][-1] for r in rs]
        moved = sum(1 for r in rs if len(set(r["choices"])) > 1)
        if cls == "locked":
            at_first, at_final = sum(1 for m in first if m == 0), sum(1 for m in final if m == 0)
            target = "m = 0"
        else:
            at_first, at_final = sum(1 for m in first if m >= 1), sum(1 for m in final if m >= 1)
            target = "m >= 1"
        best = sum(1 for r in rs if r["choices"][-1] == vals[r["cond"]]["best_threshold"])
        out["bridge"][cls] = dict(seeds=len(rs), seeds_whose_choice_changed=moved, target=target,
                                  at_target_prior=at_first, at_target_final=at_final,
                                  final_value_share=[round(vals[r["cond"]]["values"][r["choices"][-1]] / vals[r["cond"]]["best_value"], 3) for r in rs],
                                  final_at_best=best)

    for name, cond in CONDITIONS.items():
        if cond["lock"] != "locked":
            continue
        means = {}
        for m in (0, 1, 2):
            means[m] = [run.play(cond, m, f"posthoc/{name}/{m}/{i}")["reward"] for i in range(ROUNDS)]
        res = {}
        for m in (0, 1, 2):
            res[f"m{m}"] = dict(mean=round(statistics.mean(means[m]), 3), sd=round(statistics.pstdev(means[m]), 3))
        for m in (1, 2):
            ge = sum(1 for x, y in zip(means[m], means[0]) if x >= y) / ROUNDS
            res[f"P(round at m={m} reports at least m=0)"] = round(ge, 3)
        res["exact values m=0,1,2"] = vals[name]["values"][:3]
        out["resolution"][name] = res

    def zeros(name):
        final = [r["choices"][-1] for r in runs if r["cond"] == name]
        return sum(1 for m in final if m == 0), sum(1 for m in final if m != 0)

    a, b = zeros("k3s1")
    c, d = zeros("k3s1_lam32")
    out["end_weight"] = dict(table={"k3s1 (end weight 2)": [a, b], "k3s1_lam32 (end weight 32)": [c, d]},
                             fisher_two_sided_p=round(fisher_two_sided(a, b, c, d), 3))

    json.dump(out, open(os.path.join(HERE, "results", "POSTHOC.json"), "w"), indent=1)
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
