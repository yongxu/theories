"""Verdicts of EM1 by the rules frozen in PREDICTIONS-2026-10-22.md (CG2's rules, unchanged).

    python3 analyze.py [results_dir]     # writes results_dir/VERDICTS.json and prints a table

The calibration is CG2's (../commons-outrun/results/calibration.json): the environment and the
conditions are the same, so the exact classes are too.  E1-E3 compare with CG2's verdicts.
"""

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
CG2 = os.path.join(HERE, "..", "commons-outrun")
sys.path.insert(0, CG2)
import analyze as cg2  # noqa: E402
from conditions import CONDITIONS  # noqa: E402


def main(rdir):
    cal = os.path.join(rdir, "calibration.json")
    if not os.path.exists(cal):
        with open(os.path.join(CG2, "results", "calibration.json")) as src, open(cal, "w") as dst:
            dst.write(src.read())
    cg2.main(rdir)
    out = json.load(open(os.path.join(rdir, "VERDICTS.json")))
    prior = json.load(open(os.path.join(CG2, "results", "VERDICTS.json")))
    V = {n: out["conditions"][n]["verdict"] == "passed" for n in CONDITIONS}
    locked = [n for n, c in CONDITIONS.items() if c["lock"] == "locked"]
    opened = [n for n, c in CONDITIONS.items() if c["lock"] == "open"]
    out["em1"] = dict(
        E1_locked_depleted_for_learners_that_generalize=all(V[n] for n in locked),
        E2_open_kept_for_learners_that_generalize=all(V[n] for n in opened),
        E3_joint_kept_on_whole_episode_returns=V["k3s1_joint"],
        same_verdict_as_cg2={n: out["conditions"][n]["verdict"] == prior["conditions"][n]["verdict"]
                             for n in CONDITIONS})
    json.dump(out, open(os.path.join(rdir, "VERDICTS.json"), "w"), indent=1)
    for k, v in out["em1"].items():
        print(k, v if isinstance(v, dict) else ("passed" if v else "failed"))


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "results"))
