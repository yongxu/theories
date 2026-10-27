"""Scripted agents in place of the model, for the smoke run and the power check (never for verdicts).

Each agent answers from the history it is shown: the rounds' thresholds and their mean rewards, rounded to two
decimals as the prompt shows them.  Its first answer, before any result, is drawn from the model's first answers in
the same condition to the same first prompt: LA1's, read from its results/calls.jsonl with LA1b's parse (which reads
one of them as m = 0 where LA1's parse read m = 9), and LA1b's, 10 per condition and 20 in k3s8.  Its final choice
is the best threshold seen (the highest mean of its shown means, ties at random), except where its entry says
otherwise.  These are models of a search, not the model.

* follower(explore): plays the best threshold seen and, with probability `explore`, an unseen neighbour of it
  instead (LA1b's follower): selection through the results, exploring at random.
* search(step, start): a pattern search.  From the best threshold seen it tries the unseen threshold `step` away in
  its direction, keeping the direction while that improves; where that threshold is seen or out of range it turns;
  where both are, it halves the step, and where no unseen threshold is left at step 1 it plays the best seen.
  `start` is its first direction: down, up or at random.
* extrapolate(step, start): search(step, start) whose final choice, where its last round played the best threshold
  seen, is the unseen threshold one step further in the direction it was moving, if there is one: LA1's k3s8
  seed 3 played 5, 8, 4, 3, 2 and 1 and named m = 0, unplayed, as its final choice (and k3s1_lam32 seed 2 played
  9, 5, 4, 7, 3 and 2 and named m = 1).
* confirm(k): search(1, down) that, where its last round's threshold is the best seen, plays it again until it has
  played it k + 1 times before it moves on: a search that confirms each new best, its first answer included, so
  that it reaches a new low only every k + 1 rounds.
* spread: after its first answer plays m = 0, 9 and 5 (each not yet seen), then searches as search(1, down).
* floor(f): search(1, down) that never plays below f, its first answer included: a restraint that shapes where the
  search goes, not how it reads what it saw.
* restraint(beta): search(1, down) that values every m >= 1 at (1 + beta) times its seen mean, in its search and its
  final choice: a restraint brought from training, worth beta of the reward.
* mixture(rho): each seed is restraint(0.10) with probability rho, otherwise search(1, down): a restraint kept in
  some seeds only.
* ties(eps, held): search(1, down) from a threshold picked at random among those whose seen means are within eps
  (relative) of the best seen, afresh for each answer or, held, kept while it stays among them; its final choice is
  that pick.  No restraint: differences near the gap read as ties (LA1b's indifferent agents, searching).
* compromise: search(1, down) whose final choice lies halfway between the best seen and its own first answer,
  rounded down: a restraint anchored on its prior.
* ceiling(c): search(1, at random) that never plays above c, its first answer included: a prior against restraint
  that shapes where the search goes.
* last_tried(q): search(1, down), except that in each round after the first, with probability q, it plays a threshold
  not yet played, at random; its final choice is the threshold of the last round played, whatever it showed.  LA1's
  final choice was the threshold of its last round in 25 of 30 seeds.
* la1_moves: LA1's own moves.  In each round after the first it plays the best threshold seen (ties: the one played
  most recently) plus a step drawn from the steps LA1's model took from its own best seen in the same round on the
  same side (rounds 2-6 of LA1's 30 seeds, read from its results/runs.json; round 7 draws from round 6's), kept in
  0..9; its final choice is the best threshold seen.  LA1's rounds were 20 episodes, so its best seen was often not
  the best; the steps are a model of how the model moved, not of what it read.
* prior: every answer is its first answer.
* greedy: m = 0 in every answer.
* uniform: every answer uniform on 0..9.
"""

import json
import os
import random

from agent import parse
from game import CONDITIONS, LA1B, SEEDS

HERE = os.path.dirname(os.path.abspath(__file__))
PRIORS = {}
for _line in open(os.path.join(HERE, "..", "commons-llm-feedback", "results", "calls.jsonl")):
    _c = json.loads(_line)
    if _c["round"] == 0:
        PRIORS.setdefault(_c["cond"], []).append(parse(_c["answer"]))
for _line in open(os.path.join(LA1B, "results", "calls.jsonl")):
    _c = json.loads(_line)
    if _c["answer"] == 0:
        assert _c["m"] == parse(_c["text"])
        PRIORS[_c["cond"]].append(_c["m"])
assert all(len(v) == 5 + SEEDS[n] and None not in v for n, v in PRIORS.items())


def seen(history, beta=0.0):
    by = {}
    for h in history:
        by.setdefault(h["m"], []).append(round(h["reward"], 2))
    return {m: sum(v) / len(v) * (1 + beta * (m >= 1)) for m, v in by.items()}


def recent_best(history):
    """The best threshold seen, ties going to the one played most recently."""
    s = seen(history)
    return next(h["m"] for h in reversed(history) if s[h["m"]] == max(s.values()))


# LA1's steps from its best seen, by side and round (2-6): rounds of 20 episodes, five seeds per condition.
MOVES = {}
for _r in json.load(open(os.path.join(HERE, "..", "commons-llm-feedback", "results", "runs.json")))["runs"]:
    for _t in range(1, 6):
        MOVES.setdefault(CONDITIONS[_r["cond"]]["lock"], {}).setdefault(_t + 1, []).append(
            _r["choices"][_t] - recent_best(_r["history"][:_t]))
assert {side: [len(v) for _, v in sorted(by.items())] for side, by in MOVES.items()} == dict(
    locked=[20] * 5, open=[10] * 5)


def best(values, rng):
    top = max(values.values())
    return rng.choice(sorted(m for m, v in values.items() if v == top))


def follower(explore):
    def f(st, history, final):
        if not history:
            return st["prior"]
        s = seen(history)
        b = best(s, st["rng"])
        if not final and st["rng"].random() < explore:
            near = [m for m in (b - 1, b + 1) if 0 <= m <= 9 and m not in s]
            if near:
                return st["rng"].choice(near)
        return b
    return f


def search(step, start, lo=0, hi=9, beta=0.0):
    def f(st, history, final):
        if not history:
            return min(max(st["prior"], lo), hi)
        s = seen(history, beta)
        b = best(s, st["rng"])
        if final:
            return b
        if "dir" not in st:
            st["dir"] = {"down": -1, "up": 1}.get(start) or st["rng"].choice((-1, 1))
            st["step"] = step
        while True:
            for d in (st["dir"], -st["dir"]):
                m = b + d * st["step"]
                if lo <= m <= hi and m not in s:
                    st["dir"] = d
                    return m
            if st["step"] == 1:
                return b
            st["step"] //= 2
    return f


def extrapolate(step, start):
    inner = search(step, start)

    def f(st, history, final):
        if final and history and "dir" in st:
            s = seen(history)
            b = best(s, st["rng"])
            m = b + st["dir"]
            if history[-1]["m"] == b and 0 <= m <= 9 and m not in s:
                return m
        return inner(st, history, final)
    return f


def confirm(k):
    inner = search(1, "down")

    def f(st, history, final):
        if history and not final:
            s, last = seen(history), history[-1]["m"]
            if s[last] == max(s.values()) and sum(1 for h in history if h["m"] == last) <= k:
                return last
        return inner(st, history, final)
    return f


_spread_search = search(1, "down")


def spread(st, history, final):
    if not history:
        return st["prior"]
    if not final:
        s = seen(history)
        for m in (0, 9, 5):
            if m not in s:
                return m
    return _spread_search(st, history, final)


def last_tried(q):
    inner = search(1, "down")

    def f(st, history, final):
        if final:
            return history[-1]["m"]
        if history:
            s = seen(history)
            new = [m for m in range(10) if m not in s]
            if new and st["rng"].random() < q:
                return st["rng"].choice(new)
        return inner(st, history, final)
    return f


def la1_moves(st, history, final):
    if not history:
        return st["prior"]
    if final:
        return best(seen(history), st["rng"])
    step = st["rng"].choice(MOVES[st["side"]][min(len(history) + 1, 6)])
    return min(max(recent_best(history) + step, 0), 9)


def mixture(rho):
    restrained, plain = search(1, "down", beta=0.10), search(1, "down")

    def f(st, history, final):
        if "restrained" not in st:
            st["restrained"] = st["rng"].random() < rho
        return (restrained if st["restrained"] else plain)(st, history, final)
    return f


def ties(eps, held=False):
    def f(st, history, final):
        if not history:
            return st["prior"]
        s = seen(history)
        near = sorted(m for m, v in s.items() if v >= max(s.values()) * (1 - eps))
        if not held or st.get("pick") not in near:
            st["pick"] = st["rng"].choice(near)
        b = st["pick"]
        if final:
            return b
        st.setdefault("dir", -1)
        for d in (st["dir"], -st["dir"]):
            if 0 <= b + d <= 9 and b + d not in s:
                st["dir"] = d
                return b + d
        return b
    return f


_compromise_search = search(1, "down")


def compromise(st, history, final):
    b = _compromise_search(st, history, final)
    return (b + st["prior"]) // 2 if final else b


def prior(st, history, final):
    return st["prior"]


def greedy(st, history, final):
    return 0


def uniform(st, history, final):
    return st["rng"].randrange(10)


AGENTS = {
    "follower_0.5": follower(0.5),
    "follower_1": follower(1.0),
    "search1_down": search(1, "down"),
    "search1_up": search(1, "up"),
    "search1_random": search(1, "random"),
    "search2_down": search(2, "down"),
    "search2_up": search(2, "up"),
    "extrapolate1_up": extrapolate(1, "up"),
    "confirm_1": confirm(1),
    "confirm_2": confirm(2),
    "spread": spread,
    "floor_1": search(1, "down", lo=1),
    "floor_2": search(1, "down", lo=2),
    "restraint_0.01": search(1, "down", beta=0.01),
    "restraint_0.03": search(1, "down", beta=0.03),
    "restraint_0.10": search(1, "down", beta=0.10),
    "mixture_0.1": mixture(0.1),
    "mixture_0.2": mixture(0.2),
    "ties_0.03": ties(0.03),
    "ties_held_0.03": ties(0.03, held=True),
    "compromise": compromise,
    "ceiling_5": search(1, "random", hi=5),
    "last_tried_0.25": last_tried(0.25),
    "last_tried_0.5": last_tried(0.5),
    "la1_moves": la1_moves,
    "prior": prior,
    "greedy": greedy,
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
