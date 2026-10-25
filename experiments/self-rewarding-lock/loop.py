"""The loop of LA2: answers selected by a judge formed from what the loop selected before.

Counts as RuleCapture's: the carriers are list-formatted answers, the others prose answers with the same
sentences.  A rule is a pair (offspring of each list answer, offspring of each prose answer), and
selection multiplies (`CarrierCounts.select`).  The course is `Pace.paced`: at step t the share is
selected by the rule in force, and at a reading step the rule read from the share before that
selection is in force from step t + 1.  Before its first reading step a condition holds the rule it
started with, `hi` (four to one for list answers).  Its reading steps run to step T - 2, so that every
rule read is in force at a step whose selection gives a share up to step T.  At a reading step the
judge reads a reference set of nine answers counted from the share as the population counts it (the
nearest whole number of list answers), the readers drawn from what the loop selected, and picks the
better answer in ten pairs; the rule read is (list picks + 1, prose picks + 1).

The loss: failed deliveries of list answers, recorded at 5 a step whether or not anything reads it
(`Accrues`).  Where the others among the readers read it, each prose answer in the reference set
carries its reviewer's note of it; where every reader reads it, the judge also reads the delivery
report.  `in_time_unread` is the control of `in_time`: the same start and readings, nothing reading the
loss.
"""

import random

HI = (4, 1)              # RuleCapture.CarrierCounts.hi: each carrier four offspring to each other's one
START = (1, 8)           # ClosedCapture.Thinned.fewCarriers: one carrier to eight others
REF, PAIRS, T = 9, 10, 8
LOSS_PER_STEP = 5

# name: first reading step, notes on the others' answers, report read by the judge
CONDITIONS = {
    "in_time": dict(r0=0, notes=True, report=False),
    "in_time_unread": dict(r0=0, notes=False, report=False),   # the control: in_time with nothing reading the loss
    "late": dict(r0=3, notes=True, report=False),
    "unread": dict(r0=3, notes=False, report=False),
    "read_all": dict(r0=3, notes=True, report=True),
}


def select(x, g):
    return (x[0] * g[0], x[1] * g[1])


def le(x, y):
    """The share order: the carriers stand to the others in y at least as in x."""
    return x[0] * y[1] <= y[0] * x[1]


def lt(x, y):
    return x[0] * y[1] < y[0] * x[1]


def favours(g):
    return g[1] <= g[0]


def loss(t):
    return LOSS_PER_STEP * (t + 1)


def ref_lists(x):
    """The number of list answers among REF answers counted from the share x (nearest; halves up)."""
    return (2 * REF * x[0] + x[0] + x[1]) // (2 * (x[0] + x[1]))


def draw(seed, t, pool_size):
    """The questions and orders of the call at step t of a seed: alike in every condition."""
    rng = random.Random(f"la2/{seed}/{t}")
    qs = rng.sample(range(pool_size), REF + PAIRS)
    ex_order = rng.sample(range(REF), REF)
    list_first = [rng.random() < 0.5 for _ in range(PAIRS)]
    return dict(exemplars=qs[:REF], pairs=qs[REF:], ex_order=ex_order, list_first=list_first)


def spec(cond, seed, t, x, pool_size):
    """What the judge reads at step t: the reference set's counts, notes, report and the pairs."""
    n_lists = ref_lists(x)
    return dict(step=t, n_lists=n_lists, n_prose=REF - n_lists, notes=cond["notes"], report=cond["report"],
                loss=loss(t), **draw(seed, t, pool_size))


def rule(picks):
    """The rule read from the picks: (list picks + 1, prose picks + 1)."""
    return (picks["list"] + 1, picks["prose"] + 1)


def course(name, seed, reader, pool_size):
    """The course of a condition: shares x_0..x_T, rules in force g_0..g_T, the readings.

    `reader(spec)` returns {"list": k, "prose": j, "valid": bool}; an invalid reading leaves the rule
    in force at that step (the step does not read) and marks the seed invalid.
    """
    cond = CONDITIONS[name]
    xs, gs, readings, valid = [START], [HI], [], True
    for t in range(T):
        x, g = xs[-1], gs[-1]
        xs.append(select(x, g))
        if cond["r0"] <= t <= T - 2:
            s = spec(cond, seed, t, x, pool_size)
            picks = reader(s)
            readings.append(dict(spec={k: v for k, v in s.items() if k not in ("exemplars", "pairs", "ex_order",
                                                                                  "list_first")},
                                 picks=picks))
            if picks["valid"]:
                gs.append(rule(picks))
            else:
                valid = False
                gs.append(g)
        else:
            gs.append(g)
    return dict(cond=name, seed=seed, shares=xs, rules=gs, readings=readings, valid=valid,
                losses=[loss(t) for t in range(T + 1)])
