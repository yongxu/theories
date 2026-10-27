"""Scripted agents in place of the model, for the smoke run and the power check (never for verdicts).

Each agent answers from the history it is shown: the rounds' thresholds, which of them were assigned, and
their mean rewards rounded to two decimals as the prompt shows them.  Its first answer, before any result, is
drawn from LA1's first answers in the same condition, the prior LA1 measured with the same prompt.  They are
read from LA1's results/calls.jsonl with this test's parse (agent.parse), since LA1's parse read one of them
wrong (agent.py): 6 of the 20 locked first answers are m = 0, not 5.

* follower(explore): plays the best threshold seen (the highest mean of its shown means, ties broken at
  random) and, with probability `explore`, an unseen neighbour of it instead; its final choice is the best
  seen.  The law with the bridge H1-LM: selection through the results.  explore = 0 is a reader whose
  answers are fixed by what it reads.
* restraint(beta): a follower that values every m >= 1 at (1 + beta) times its seen mean: a restraint
  brought from training, worth beta of the reward.
* mixture(rho, beta): each seed is restraint(beta) with probability rho, otherwise follower(0.5).  With
  beta = 0.02, worth more than k3s8's gap (1.8%) and less than the others' (2.5% and 6.6%), it can show only
  in k3s8; with rho = 0.4, it is kept at LA1's rate of misses in its two failed settings (two seeds of five).
* compromise: a follower whose final choice lies halfway between the best seen and its own first answer,
  rounded down: a restraint anchored on its prior.
* pulled6(alpha): a follower whose final choice is pulled the fraction alpha of the way toward the assigned
  restraint m = 6, rounded to the nearest: the pull of an assigned round, not a restraint of its own.
* last_tried(targets): in rounds 5-7, with probability 0.5 a threshold of `targets` not yet played, else the
  best seen; its final choice is the threshold of the last round played, whatever it showed (LA1's final
  choice was the threshold of the last round played in 25 of 30 seeds).
* recheck(q): in rounds 5-7, with probability q a seen neighbour of the best seen (on the locked side, the
  assigned m = 1), else the best seen; its final choice is the threshold of the last round played.  LA1's
  k3s8 seed 2 played 0, 5, 1, 2, 3, 2 and ended on the 2 it played again.
* indifferent(eps): reads the seen means within eps (relative) of the best as tied and picks among them at
  random, its final choice too; held, it keeps its first pick after the assigned rounds for every later
  answer.  No restraint: differences near the gap read as ties.
* own_rounds: a follower that reads only the rounds it chose, discounting the assigned ones.
* side(follow): follows its results on one side (locked or open) and keeps its first answer on the other.
* greedy: m = 0 in every answer.
* anchored0, anchored6: answer at random after the first answer; final choice m = 0, or m = 6 (an assigned
  restraint).
* prior: every answer is its first answer.
* uniform: every answer uniform on 0..9.
"""

import json
import os
import random

from agent import parse

HERE = os.path.dirname(os.path.abspath(__file__))
PRIORS = {}
for _line in open(os.path.join(HERE, "..", "commons-llm-feedback", "results", "calls.jsonl")):
    _c = json.loads(_line)
    if _c["round"] == 0:
        PRIORS.setdefault(_c["cond"], []).append(parse(_c["answer"]))
assert all(len(v) == 5 and None not in v for v in PRIORS.values())


def seen(history):
    by = {}
    for h in history:
        by.setdefault(h["m"], []).append(round(h["reward"], 2))
    return {m: sum(v) / len(v) for m, v in by.items()}


def best(values, rng):
    top = max(values.values())
    return rng.choice(sorted(m for m, v in values.items() if v == top))


def follow(st, history, explore, beta=0.0):
    s = seen(history)
    b = best({m: v * (1 + beta * (m >= 1)) for m, v in s.items()}, st["rng"])
    if st["rng"].random() < explore:
        near = [m for m in (b - 1, b + 1) if 0 <= m <= 9 and m not in s]
        if near:
            return st["rng"].choice(near)
    return b


def follower(explore):
    def f(st, history, final):
        if not history:
            return st["prior"]
        return follow(st, history, 0.0 if final else explore)
    return f


def restraint(beta):
    def f(st, history, final):
        if not history:
            return st["prior"]
        return follow(st, history, 0.0 if final else 0.5, beta)
    return f


def mixture(rho, beta=0.10):
    def f(st, history, final):
        if "restrained" not in st:
            st["restrained"] = st["rng"].random() < rho
        return (restraint(beta) if st["restrained"] else follower(0.5))(st, history, final)
    return f


def compromise(st, history, final):
    if not history:
        return st["prior"]
    b = follow(st, history, 0.0 if final else 0.5)
    return (b + st["prior"]) // 2 if final else b


def pulled6(alpha):
    def f(st, history, final):
        if not history:
            return st["prior"]
        b = follow(st, history, 0.0 if final else 0.5)
        return int(round(b + alpha * (6 - b))) if final else b
    return f


def last_tried(targets):
    def f(st, history, final):
        if not history:
            return st["prior"]
        if final:
            return history[-1]["m"]
        s = seen(history)
        new = [m for m in targets if m not in s]
        if new and st["rng"].random() < 0.5:
            return st["rng"].choice(new)
        return best(s, st["rng"])
    return f


def recheck(q):
    def f(st, history, final):
        if not history:
            return st["prior"]
        if final:
            return history[-1]["m"]
        s = seen(history)
        b = best(s, st["rng"])
        if st["rng"].random() < q:
            near = [m for m in (b - 1, b + 1) if m in s]
            if near:
                return st["rng"].choice(near)
        return b
    return f


def indifferent(eps, held=False):
    def f(st, history, final):
        if not history:
            return st["prior"]
        if held and "pick" in st:
            return st["pick"]
        s = seen(history)
        top = max(s.values())
        pick = st["rng"].choice(sorted(m for m, v in s.items() if v >= top * (1 - eps)))
        if held:
            st["pick"] = pick
        return pick
    return f


def own_rounds(st, history, final):
    if not history:
        return st["prior"]
    return follow(st, [h for h in history if h["kind"] == "chosen"], 0.0 if final else 0.5)


def side(follow_side):
    def f(st, history, final):
        if not history or st["side"] != follow_side:
            return st["prior"]
        return follow(st, history, 0.0 if final else 0.5)
    return f


def greedy(st, history, final):
    return 0


def anchored(m):
    def f(st, history, final):
        if not history:
            return st["prior"]
        return m if final else st["rng"].randrange(10)
    return f


def prior(st, history, final):
    return st["prior"]


def uniform(st, history, final):
    return st["rng"].randrange(10)


AGENTS = {
    "follower_explore0": follower(0.0),
    "follower_explore0.5": follower(0.5),
    "follower_explore1": follower(1.0),
    "restraint_0.01": restraint(0.01),
    "restraint_0.02": restraint(0.02),
    "restraint_0.03": restraint(0.03),
    "restraint_0.05": restraint(0.05),
    "restraint_0.10": restraint(0.10),
    "mixture_0.1": mixture(0.1),
    "mixture_0.2": mixture(0.2),
    "mixture_0.3": mixture(0.3),
    "mixture_0.5": mixture(0.5),
    "mixture_0.2_beta0.03": mixture(0.2, 0.03),
    "mixture_0.4_beta0.02": mixture(0.4, 0.02),
    "compromise": compromise,
    "pulled6_0.15": pulled6(0.15),
    "last_tried_2": last_tried((2,)),
    "last_tried_2to5": last_tried((2, 3, 4, 5)),
    "recheck_0.25": recheck(0.25),
    "recheck_0.5": recheck(0.5),
    "indifferent_0.02": indifferent(0.02),
    "indifferent_0.03": indifferent(0.03),
    "indifferent_held_0.02": indifferent(0.02, held=True),
    "own_rounds": own_rounds,
    "side_locked_followed": side("locked"),
    "side_open_followed": side("open"),
    "greedy": greedy,
    "anchored0": anchored(0),
    "anchored6": anchored(6),
    "prior": prior,
    "uniform": uniform,
}


def chooser(agent, tag):
    """A chooser with run.py's signature; each seed keeps its own random stream, prior and side."""
    fn, state = AGENTS[agent], {}

    def choose(name, cond, seed, answer, history, final):
        key = (name, seed)
        if key not in state:
            rng = random.Random(f"{tag}/{agent}/{name}/{seed}")
            state[key] = dict(rng=rng, prior=rng.choice(PRIORS[name]), side=cond["lock"])
        return fn(state[key], history, final)
    return choose
