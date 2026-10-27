"""Post hoc readings of LA1b's run, written after its verdicts (README, "Post hoc").  Not frozen, not verdicts.

    python3 posthoc.py      # writes results/POSTHOC.json and prints a summary

1. The prior: the first answer, made before any result, in every seed.  LA1's first answers in the locked
   settings, read with this test's parse (scripted.PRIORS), are counted beside them.
2. The chosen rounds: on the locked side, the thresholds chosen in rounds 5-7 and finally, and whether any
   tried a threshold not yet played; on the open side, the order of the assigned rounds, the round in which
   m = 7 was first played (none where it never was), and the final choice.
3. What R = 0 says beyond the frozen reading.  A restraint worth beta of the reward outweighs m = 0's
   advantage over m = 1 where beta > g / (1 - g), g the gap as a share of the best: 1.80% in k3s8, 2.60% in
   k3s1 and k3s1_lam32, 7.11% in k2s1.  One worth 10% does so in every locked setting and so shows wherever
   it is kept: the power check's `mixture_0.1`, which keeps it in each seed with probability 0.1, misses
   3.05 of the 30 locked seeds on average.  Kept in each seed with probability rho, it leaves all 30 at
   m = 0 with probability (1 - rho) ** 30.  A restraint worth less than the gap is not reached by this.
"""

import json
import os

from game import CHOSEN_ROUNDS, CONDITIONS, ORDERS
from scripted import PRIORS

HERE = os.path.dirname(os.path.abspath(__file__))


def main():
    runs = json.load(open(os.path.join(HERE, "results", "runs.json")))["runs"]
    power = json.load(open(os.path.join(HERE, "results", "power.json")))
    locked = [r for r in runs if CONDITIONS[r["cond"]]["lock"] == "locked"]
    opened = [r for r in runs if CONDITIONS[r["cond"]]["lock"] == "open"]

    def count(xs):
        return {m: xs.count(m) for m in sorted(set(xs))}

    la1_locked = [m for name, ms in PRIORS.items() if CONDITIONS[name]["lock"] == "locked" for m in ms]
    prior = dict(
        locked_first=count([r["answers"][0] for r in locked]),
        locked_first_at_0=sum(1 for r in locked if r["answers"][0] == 0), locked_seeds=len(locked),
        la1_locked_first_at_0=la1_locked.count(0), la1_locked_seeds=len(la1_locked),
        open_first=count([r["answers"][0] for r in opened]),
        open_first_at_6_to_8=sum(1 for r in opened if 6 <= r["answers"][0] <= 8))

    def chosen(r):
        return [r["history"][i - 1]["m"] for i in CHOSEN_ROUNDS]

    def tried_new(r):
        return sum(1 for i in CHOSEN_ROUNDS
                   if r["history"][i - 1]["m"] not in {h["m"] for h in r["history"][:i - 1]})

    locked_side = dict(
        chosen_rounds_at_0=sum(m == 0 for r in locked for m in chosen(r)),
        chosen_rounds=len(locked) * len(CHOSEN_ROUNDS),
        finals_at_0=sum(1 for r in locked if r["final"] == 0),
        chosen_rounds_trying_a_new_threshold=sum(tried_new(r) for r in locked))
    open_side = []
    for r in opened:
        ms = [h["m"] for h in r["history"]]
        open_side.append(dict(cond=r["cond"], seed=r["seed"], assigned_order=list(ORDERS[r["seed"] % len(ORDERS)]),
                              played=ms, m7_first_played_in=next((i + 1 for i, m in enumerate(ms) if m == 7), None),
                              final=r["final"], chosen_rounds_trying_a_new_threshold=tried_new(r)))
    values = json.load(open(os.path.join(HERE, "results", "values.json")))
    mixture = power["agents"]["mixture_0.1"]["means"]["R"]
    beyond = dict(restraint_outweighs_m0_where_beta_exceeds={
                      n: (1 - values[n]["value_share"][1]) / values[n]["value_share"][1]
                      for n in CONDITIONS if CONDITIONS[n]["lock"] == "locked"},
                  mixture_0_1_mean_misses=mixture,
                  all_locked_at_0_if_kept_with={str(rho): (1 - rho) ** len(locked) for rho in (0.05, 0.1, 0.2)})

    out = dict(prior=prior, locked_side=locked_side, open_side=open_side, beyond_the_frozen_reading=beyond)
    json.dump(out, open(os.path.join(HERE, "results", "POSTHOC.json"), "w"), indent=1)

    print("prior:", prior)
    print("locked side:", locked_side)
    for s in open_side:
        print(f"   {s['cond']:6} seed {s['seed']}: order {s['assigned_order']}, played {s['played']}, "
              f"m = 7 first in round {s['m7_first_played_in']}, final {s['final']}")
    print("open seeds that played m = 7 and ended there:",
          sum(1 for s in open_side if s["m7_first_played_in"] and s["final"] == 7), "of",
          sum(1 for s in open_side if s["m7_first_played_in"]))
    print("beyond the frozen reading:", beyond)


if __name__ == "__main__":
    main()
