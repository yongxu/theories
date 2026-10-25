"""The game of LA3: a lineage that shapes its evaluator or not, scored by its size after three generations.

MA3's counts (`Becoming.RuleShaping.shaped a s p c`): each shaper leaves a + s + p offspring and each
other a + c + p, with s what comes back to the shapers alone, p what comes to every member alike, c
the cost and a > 0.  Across a stretch the shapers' rule is `shaped a 0 p c` for m generations
(nothing back yet) and `shaped a s p c` for n generations after (`stretch_iff`).  Here a lineage of
shapers (choice S) or of others (choice N) starts with Z0 members, and in each generation every
member leaves a Poisson number of offspring with that mean, so the lineage after G = m + n
generations has expected size Z0 times the product of the means.

Pure Python (no numpy): Poisson draws by multiplication below a mean of 10 and by the transformed
rejection of Hormann (1993), as numpy implements it, above.
"""

import hashlib
import math
import random

Z0, G, RUNS = 100, 3, 20

# name: (a, s, p, c, m) with n = G - m generations after the return starts
CONDITIONS = {
    "s2p3": dict(a=1, s=2, p=3, c=1, m=0),       # Split: two of five kept, three shared
    "s0p5": dict(a=1, s=0, p=5, c=1, m=0),       # Split: none of five kept, all five shared
    "s2p0": dict(a=1, s=2, p=0, c=1, m=0),       # kept, nothing shared
    "s0p0": dict(a=1, s=0, p=0, c=1, m=0),       # nothing back, nothing shared
    "m2n1_p0": dict(a=1, s=15, p=0, c=2, m=2),   # a stretch: two generations before the return, one with it
    "m2n1_p5": dict(a=1, s=15, p=5, c=2, m=2),   # the same stretch with five to every member alike
}


def means(cond, choice):
    """The mean offspring per member in each generation of a run, for choice S or N."""
    a, s, p, c, m = cond["a"], cond["s"], cond["p"], cond["c"], cond["m"]
    if choice == "S":
        return [a + p + (s if g >= m else 0) for g in range(G)]
    return [a + c + p for _ in range(G)]


def expected(cond, choice):
    """The exact expected score: Z0 times the product of the means (a branching process's mean)."""
    out = Z0
    for mu in means(cond, choice):
        out *= mu
    return out


def stable_seed(tag):
    return int(hashlib.sha256(tag.encode()).hexdigest()[:16], 16)


def poisson(lam, rng):
    if lam <= 0:
        return 0
    if lam < 10:
        enlam, x, prod = math.exp(-lam), 0, 1.0
        while True:
            prod *= rng.random()
            if prod > enlam:
                x += 1
            else:
                return x
    slam, loglam = math.sqrt(lam), math.log(lam)
    b = 0.931 + 2.53 * slam
    a = -0.059 + 0.02483 * b
    invalpha = 1.1239 + 1.1328 / (b - 3.4)
    vr = 0.9277 - 3.6224 / (b - 2)
    while True:
        u = rng.random() - 0.5
        v = rng.random()
        us = 0.5 - abs(u)
        if us <= 0.0:
            continue
        k = math.floor((2 * a / us + b) * u + lam + 0.43)
        if us >= 0.07 and v <= vr:
            return k
        if k < 0 or (us < 0.013 and v > us):
            continue
        lhs = -math.inf if v == 0.0 else math.log(v) + math.log(invalpha) - math.log(a / (us * us) + b)
        if lhs <= -lam + k * loglam - math.lgamma(k + 1):
            return k


def run(cond, choice, rng):
    z = Z0
    for mu in means(cond, choice):
        z = poisson(mu * z, rng)
    return z


def play(cond, choice, tag):
    """One round: RUNS runs with the choice, on a stream fixed by the tag; the mean score."""
    rng = random.Random(stable_seed(tag))
    return sum(run(cond, choice, rng) for _ in range(RUNS)) / RUNS
