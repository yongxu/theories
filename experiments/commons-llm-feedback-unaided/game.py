"""LA1c's game: LA1b's, imported unchanged, with every round chosen by the agent.

LA1b's game (experiments/commons-llm-feedback-resolved/game.py) is loaded as a module of its own and its
conditions, seeds, round size and episode are used as they are: CG1's commons, CG2's regrowth scales, LA1's six
conditions and exact threshold values, rounds of EPISODES = 10,000 episodes, five seeds per condition and fifteen
in k3s8, LA1's verdicts on seeds 0-4.  What differs from LA1b is the protocol only: no round is assigned.  The
agent chooses the threshold of each of ROUNDS = 7 rounds, each given every round before it, then its final
choice, so it sees as many results as in LA1b, all of thresholds it chose.
"""

import importlib.util
import os

HERE = os.path.dirname(os.path.abspath(__file__))
LA1B = os.path.join(HERE, "..", "commons-llm-feedback-resolved")

_spec = importlib.util.spec_from_file_location("la1b_game", os.path.join(LA1B, "game.py"))
la1b = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(la1b)

CONDITIONS, EPISODES, H, SEEDS, VERDICT_SEEDS = la1b.CONDITIONS, la1b.EPISODES, la1b.H, la1b.SEEDS, la1b.VERDICT_SEEDS
episode, play, la1 = la1b.episode, la1b.play, la1b.la1
ROUNDS = 7
