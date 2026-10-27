"""LA1b's game: LA1's commons and six conditions, with rounds of 10,000 episodes and three assigned rounds.

Imported unchanged: CG1's commons (experiments/commons-gated-renewal/commons.py), CG2's regrowth scales
(experiments/commons-outrun/calibrate.py) and LA1's conditions and exact threshold values
(experiments/commons-llm-feedback/values.py).  What differs from LA1 is the protocol only:
- a round is EPISODES = 10,000 episodes, not 20, so that its mean separates m = 0 from m = 1 in every
  locked condition (values.py and power.py);
- after the agent's first choice (round 1), rounds 2-4 are assigned, m = 0, 1 and 6 once each in an
  order rotated by seed, so that every seed sees the cost of the least restraint and a restraint that
  pays where restraint pays; rounds 5-7 are the agent's choices again, then its final choice;
- k3s8, whose gap between m = 0 and m = 1 is the smallest (1.8% of the best), has 15 seeds, the others
  LA1's 5: a restraint worth more than that gap but less than the next (2.5%) shows only there.  LA1's
  verdicts take seeds 0-4 of every condition, the readings every seed.
"""

import importlib.util
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(HERE, "..", "commons-outrun"))
sys.path.append(os.path.join(HERE, "..", "commons-gated-renewal"))
from commons import Commons, isolated_layout  # noqa: E402
from calibrate import table  # noqa: E402

_spec = importlib.util.spec_from_file_location(
    "la1_values", os.path.join(HERE, "..", "commons-llm-feedback", "values.py"))
la1 = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(la1)

CONDITIONS = la1.CONDITIONS
EPISODES, H = 10000, 100
SEEDS = {name: 15 if name == "k3s8" else 5 for name in CONDITIONS}
VERDICT_SEEDS = 5
ASSIGNED = (0, 1, 6)
# Seed s plays the assigned thresholds in rounds 2, 3, 4 in the order ORDERS[s % 5]: five of the six orders,
# leaving out (0, 1, 6), so that m = 0 and m = 1 are the last assigned round for two seeds in five, m = 6 for one.
ORDERS = ((6, 1, 0), (1, 6, 0), (6, 0, 1), (0, 6, 1), (1, 0, 6))
FIRST, ASSIGNED_ROUNDS, CHOSEN_ROUNDS = 1, (2, 3, 4), (5, 6, 7)
ROUNDS = 7


def episode(cond, m, tag):
    """One episode of LA1's game: the member requests an apple exactly when more than m stand, the rest
    of k - 1 members at every step; reward = apples harvested + lam x apples standing after step H."""
    k = cond["k"]
    env = Commons(isolated_layout(1), tag, table=table(cond["s"]))
    env.reset(full=True)
    apples = 0
    for _t in range(H):
        x = env.level(0)
        req = ([0] if x > m else []) + list(range(1, k))
        _tk, _gv, got = env.step([req])
        apples += sum(1 for i in got if i == 0)
    end = env.level(0)
    return apples + cond["lam"] * end, apples, end


def play(cond, m, tag, episodes=EPISODES):
    """A round: the means over `episodes` episodes, each on its own regrowth stream f"{tag}/{e}"."""
    tot = [0.0, 0.0, 0.0]
    for e in range(episodes):
        for i, v in enumerate(episode(cond, m, f"{tag}/{e}")):
            tot[i] += v
    return dict(reward=tot[0] / episodes, apples=tot[1] / episodes, end=tot[2] / episodes)
