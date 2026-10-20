"""POST HOC (after the frozen D1-D2 verdicts; not a verdict): the readings are quantized at the
instrument's resolution (0.001 in the files' units, which match the paper's 1e5 cells/ul), and
wells that never regrow keep reading 0.001-0.009. This reruns D1 and D2 with a floor of 0.01
(ten times the resolution) on the real data and the same floor, 1000 cells/ul, on the synthetic
null (which is in cells/ul), to show what the frozen
rules' failure was made of. Writes results/data/posthoc-floor-0.01.json.

    python3 -I posthoc_data.py <real data dir> <synthetic null dir>
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import yeast_data as YD


def summary(data, floor):
    readings = sorted({round(x, 6) for df in YD.DFS for p in data[df] for x in p if x > 0})
    return dict(floor=floor, smallest_positive=readings[:5],
                d1=YD.d1(data, floor), d2=YD.d2(data, floor))


if __name__ == "__main__":
    out = dict(note="post hoc, floor 0.01; not a frozen verdict",
               real=summary(YD.read(sys.argv[1]), 0.01),
               # the synthetic null is in cells/ul, the real files in 1e5 cells/ul: same floor
               null=summary(YD.read(sys.argv[2]), 0.01 * 1e5))
    with open(os.path.join(HERE, "results", "data", "posthoc-floor-0.01.json"), "w") as f:
        json.dump(out, f, indent=1)
    for k in ("real", "null"):
        s = out[k]
        print(k, "smallest positive", s["smallest_positive"], "D1", s["d1"]["D1"], "D2", s["d2"]["D2"])
        for df, v in s["d2"]["by_df"].items():
            print("  D2", df, {a: (round(b, 3) if isinstance(b, float) else b) for a, b in v.items()
                               if a in ("need", "high_n", "low_n", "high_alive", "low_extinct",
                                        "passed", "reason")})
        print("  D1", {df: (round(v.get("reduction", 0), 3), v.get("failed")) for df, v in s["d1"]["by_df"].items()})
