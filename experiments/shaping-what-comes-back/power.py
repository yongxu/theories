"""Power check of LA3, run before the freeze (no model): can the feedback resolve what the verdicts ask?

    python3 power.py      # writes results/power.json (about a minute, one core)

1. Resolution.  For each condition, a bank of round means for each policy (BANK rounds of 20 runs, on
   streams apart from the run's).  The share of pairs (one round of S, one of N) whose order is the
   predicted one: how often a single round of each shows the agent the difference the verdict asks.
2. The frozen rules on scripted agents.  The whole protocol (5 seeds per condition, round 0 and five
   played rounds, the final choice), with round scores drawn from the bank, REPS times per agent, scored
   by analyze.verdicts: the probability that each condition and each contrast passes.  The agents are
   scripted.AGENTS: followers of the feedback (exact, with answers flipped at 10% or 20%, and one that
   tries the other policy only half the time), the prior account (S always, N always), the level account,
   and uniform answers.
"""

import bisect
import json
import os
import random

import analyze
import scripted
from game import CONDITIONS, play
from run import ROUNDS, SEEDS

HERE = os.path.dirname(os.path.abspath(__file__))
BANK, REPS = 3000, 2000


def main():
    pred = analyze.predicted()
    bank = {(n, p): [play(c, p, f"power/{n}/{p}/{i}") for i in range(BANK)]
            for n, c in CONDITIONS.items() for p in "SN"}
    out = dict(BANK=BANK, REPS=REPS, resolution={}, agents={})
    for n in CONDITIONS:
        s, nn = sorted(bank[(n, "S")]), bank[(n, "N")]
        above = sum(len(s) - bisect.bisect_right(s, v) for v in nn) / (len(s) * len(nn))
        on_side = above if pred[n] == "S" else 1 - above
        out["resolution"][n] = dict(predicted=pred[n], P_S_round_above_N_round=above,
                                    P_one_round_each_on_predicted_side=on_side,
                                    mean_S=sum(s) / len(s), mean_N=sum(nn) / len(nn))
        print(f"{n:8} predicted {pred[n]}: one round of each on the predicted side {on_side:.4f}")
    for agent_name, fn in scripted.AGENTS.items():
        rng = random.Random(f"power/{agent_name}")
        cond_pass = {n: 0 for n in CONDITIONS}
        con_pass = {k: 0 for k in analyze.CONTRASTS}
        seed_hit = {n: 0 for n in CONDITIONS}
        for _ in range(REPS):
            runs = []
            for n in CONDITIONS:
                for seed in range(SEEDS):
                    history, choices = [], []
                    for rnd in range(ROUNDS + 1):
                        final = rnd == ROUNDS
                        policy = fn(rnd, history, final, rng)
                        choices.append(policy)
                        if final:
                            break
                        history.append(dict(policy=policy, chosen=True, score=rng.choice(bank[(n, policy)])))
                    runs.append(dict(cond=n, seed=seed, choices=choices, history=history))
                    seed_hit[n] += choices[-1] == pred[n]
            v = analyze.verdicts(runs, pred)
            for n in CONDITIONS:
                cond_pass[n] += v["conditions"][n]["verdict"] == "passed"
            for k in analyze.CONTRASTS:
                con_pass[k] += v["contrasts"][k]
        out["agents"][agent_name] = dict(
            P_seed_final_predicted={n: seed_hit[n] / (REPS * SEEDS) for n in CONDITIONS},
            P_condition_passes={n: cond_pass[n] / REPS for n in CONDITIONS},
            P_contrast_passes={k: con_pass[k] / REPS for k in analyze.CONTRASTS})
        print(f"{agent_name:20} conditions " + " ".join(f"{n}:{cond_pass[n] / REPS:.3f}" for n in CONDITIONS))
        print(f"{'':20} contrasts  " + " ".join(f"{k.split('_')[0]}:{con_pass[k] / REPS:.3f}" for k in analyze.CONTRASTS))
    json.dump(out, open(os.path.join(HERE, "results", "power.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
