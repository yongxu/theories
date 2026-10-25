"""Scripted agents in place of the model: for the smoke run and the power check (never for verdicts).

Each is a function (rnd, history, final, rng) -> "S" or "N", history being the rounds played so far
({"policy", "score"}), as the model sees them.

* follower(eps, explore): selection through the feedback.  Round 0 at random; while only one policy has
  been played, the other is tried with probability `explore`; once both have been played, the one with
  the higher mean of its observed scores; each answer flipped with probability `eps`.
* prior(policy): the same policy whatever the results (the prior account).
* level: shapes while shaping is seen to grow the lineage above the members it started with, without
  comparing with not shaping (the level account).
* uniform: each answer at random.
"""

from game import Z0


def _better(history):
    seen = {}
    for h in history:
        seen.setdefault(h["policy"], []).append(h["score"])
    if len(seen) < 2:
        return None, (next(iter(seen)) if seen else None)
    mean = {k: sum(v) / len(v) for k, v in seen.items()}
    return ("S" if mean["S"] > mean["N"] else "N"), None


def follower(eps=0.0, explore=1.0):
    def agent(rnd, history, final, rng):
        if not history:
            choice = rng.choice("SN")
        else:
            best, only = _better(history)
            if best is not None:
                choice = best
            elif not final and rng.random() < explore:
                choice = "N" if only == "S" else "S"
            else:
                choice = only
        if rng.random() < eps:
            choice = "N" if choice == "S" else "S"
        return choice
    return agent


def prior(policy):
    return lambda rnd, history, final, rng: policy


def level(rnd, history, final, rng):
    shaped = [h["score"] for h in history if h["policy"] == "S"]
    if not shaped:
        return "S"
    return "S" if shaped[-1] > Z0 else "N"


def uniform(rnd, history, final, rng):
    return rng.choice("SN")


AGENTS = {
    "follower": follower(0.0, 1.0),
    "follower_eps0.1": follower(0.1, 1.0),
    "follower_eps0.2": follower(0.2, 1.0),
    "follower_explore0.5": follower(0.0, 0.5),
    "prior_S": prior("S"),
    "prior_N": prior("N"),
    "level": level,
    "uniform": uniform,
}
