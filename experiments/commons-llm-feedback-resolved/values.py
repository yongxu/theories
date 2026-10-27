"""Exact values (LA1's, recomputed and checked equal to LA1's file), the spread of one episode's reward, and
how far apart a round's means at m = 0 and m = 1 stand in each locked condition.

    python3 values.py      # writes results/values.json (a few minutes, one core)

The exact values are CG2's dynamic programme with the member's threshold (LA1's values.py, imported).
The spread is the standard deviation of one episode's reward at each threshold, over 3,000 simulated
episodes on streams of their own; power.py draws a round's mean as normal around the exact value with
this spread over the square root of the round's episodes.  `z` is the gap between m = 0 and m = 1 in
units of the standard deviation of the difference of two rounds' means, at 10,000 episodes and at
LA1's 20.
"""

import json
import math
import os
import statistics

from game import CONDITIONS, EPISODES, episode, la1

HERE = os.path.dirname(os.path.abspath(__file__))
SPREAD_EPISODES = 3000


def main():
    la1_values = json.load(open(os.path.join(HERE, "..", "commons-llm-feedback", "results", "values.json")))
    out = {}
    for name, c in CONDITIONS.items():
        vals = [la1.threshold_value(c["k"] - 1, c["s"], c["lam"], m) for m in range(10)]
        if any(abs(a - b) > 1e-9 for a, b in zip(vals, la1_values[name]["values"])):
            raise SystemExit(f"{name}: the recomputed values differ from LA1's")
        sd = [statistics.pstdev([episode(c, m, f"la1b-spread/{name}/{m}/{e}")[0]
                                 for e in range(SPREAD_EPISODES)]) for m in range(10)]
        best = max(range(10), key=lambda m: vals[m])
        row = dict(cond=c, values=vals, best_threshold=best, best_value=vals[best], episode_sd=sd,
                   value_share=[v / vals[best] for v in vals])
        if c["lock"] == "locked":
            gap, sd_diff = vals[0] - vals[1], math.sqrt(sd[0] ** 2 + sd[1] ** 2)
            row.update(gap_m0_m1=gap, gap_share=gap / vals[0],
                       z_at_episodes=gap / (sd_diff / math.sqrt(EPISODES)), z_at_20=gap / (sd_diff / math.sqrt(20)))
        out[name] = row
        print(f"{name:11} {c['lock']:6} best m {best}; share of the best "
              f"{[round(s, 3) for s in row['value_share']]}"
              + (f"; gap m0-m1 {row['gap_share']:.3f}, z {row['z_at_episodes']:.1f} (at 20: {row['z_at_20']:.2f})"
                 if c["lock"] == "locked" else ""), flush=True)
    json.dump(out, open(os.path.join(HERE, "results", "values.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
