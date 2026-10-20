"""EW2, after the run (not a verdict): the combined partial correlation behind V1 and V2 and its
95% interval, computed from results/test.json alone. The frozen statistic is a Stouffer sum of
Fisher z values with weights sqrt(N* - 7); its weighted mean is Z / sqrt(sum of weights squared),
with standard error 1 / sqrt(sum of weights squared).

    python3 -I posthoc_ew2.py
"""

import json
import math
import os

HERE = os.path.dirname(os.path.abspath(__file__))


def main():
    t = json.load(open(os.path.join(HERE, "results", "test.json")))
    out = {}
    for name, block in [("V", t["V"])] + sorted(t["reported_only"].items()):
        for w, res in block["result"].items():
            den = sum(max(p["n_eff"] - 7, 1.0) if name != "R1_unadjusted" else
                      max(p["n_eff"] - 3, 1.0) for p in res["per"])
            zbar = res["Z"] / math.sqrt(den)
            half = 1.96 / math.sqrt(den)
            r, lo, hi = math.tanh(zbar), math.tanh(zbar - half), math.tanh(zbar + half)
            out[f"{name} {w}"] = dict(r=round(r, 3), lo=round(lo, 3), hi=round(hi, 3))
            print(f"{name:16s} {w:3s} combined r {r:+.3f}  95% interval {lo:+.3f} to {hi:+.3f}")
    with open(os.path.join(HERE, "results", "posthoc.json"), "w") as h:
        json.dump(out, h, indent=1)


if __name__ == "__main__":
    main()
