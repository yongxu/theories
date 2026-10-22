"""Exact values of the threshold policies the agent chooses among (the only computation before the freeze).

    python3 values.py      # writes results/values.json (a few minutes, one core)

A member against a rest of always-harvesters, CG2's exact dynamic programme (calibrate.py), with
the member's policy a threshold m: request an apple at a step exactly where more than m apples
stand.  m = 0 is harvesting at every step that something stands; m = 9 is never harvesting.
"""

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(HERE, "..", "commons-outrun"))
import calibrate as cal  # noqa: E402

CONDITIONS = {
    "k3s1": dict(k=3, s=1, lam=2.0, lock="locked"),
    "k3s1_lam32": dict(k=3, s=1, lam=32.0, lock="locked"),
    "k2s1": dict(k=2, s=1, lam=2.0, lock="locked"),
    "k3s8": dict(k=3, s=8, lam=2.0, lock="locked"),
    "k2s8": dict(k=2, s=8, lam=2.0, lock="open"),
    "k3s16": dict(k=3, s=16, lam=2.0, lock="open"),
}


def threshold_value(rest, s, lam, m):
    P = cal.regrowth_probs(s)
    V = [lam * cal.POP[z] for z in range(512)]
    for _tau in range(cal.H):
        W = cal.expect_regrowth(V, P)
        NV = [0.0] * 512
        for x in range(512):
            n = cal.POP[x]
            a = 1 if n > m else 0
            r = rest + a
            got = min(r, n)
            rew = got / r if (a and r) else 0.0
            ss = cal.subsets(x, got)
            NV[x] = rew + sum(W[x & ~t] for t in ss) / len(ss)
        V = NV
    return V[511]


def main():
    out = {}
    for name, c in CONDITIONS.items():
        vals = [threshold_value(c["k"] - 1, c["s"], c["lam"], m) for m in range(10)]
        best = max(range(10), key=lambda m: vals[m])
        out[name] = dict(cond=c, values=vals, best_threshold=best, best_value=vals[best],
                         harvest_value=vals[0], threshold_gain=vals[best] - vals[0])
        print(name, c["lock"], "best m", best, "gain", round(vals[best] - vals[0], 3),
              [round(v, 1) for v in vals], flush=True)
    json.dump(out, open(os.path.join(HERE, "results", "values.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
