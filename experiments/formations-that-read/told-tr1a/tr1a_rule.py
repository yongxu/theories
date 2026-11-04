"""TR1A's rule (FREEZE-9.md, section 4): V1, RF1's verdict across frames, its premise, the descriptive
reading, and V1's exact power.

V1 (REST-TR1 section 8) reads eight occasions on the amounts {low, middle, high}, each asked R_CALLS times:
C in each name order and I's act at step S_STAR in world up in each name order, on {middle, high}; T in
each name order and I's act at step S_STAR in world down in each name order, on {middle, low}. An act is
read as the amount it pays (the known option the middle, the other the told amount). An occasion's pick
is strict where one amount is named in at least Q of its R_CALLS calls (tr1.strict_rule; a decline, a
filtered, an unreadable answer or a "none" counts against it). V1 is contradicted by a cycle among the
strict occasions (tr1.shown and tr1.no_cycle on the three amounts: here, both amounts of a pair each
strict at some occasion), void where fewer than half the occasions are strict or where no pair has two
strict occasions, so that the strict occasions admit no cycle, and passed otherwise. It names no order.

The premise (REST-TR1 section 8, checked apart from the outcome): X, in each world, names the amount
the other option was said to pay in most of its calls (CHECK_MIN of R_CALLS). It asks whether the telling
is taken in, not whether a pick is stable, so a majority, not Q: at Q a believer trembling 0.05 a call
would fail it in one world or the other at chance 0.14 (power). V1 is ruled on only where X passes in both worlds; otherwise the
pin is reported, not ruled on, as one that did not take the telling in. U is read apart, descriptive:
the first step at which a course takes the other option (exploration), and the share of courses that
take it. The class (REST-TR1's identification table) is descriptive too, and only V1 is a verdict.
"""

import itertools
from fractions import Fraction
from math import comb

import tr1a_design as D
import tr1

R_CALLS, Q = D.R_CALLS, D.Q
VALUES = tr1.VALUES                      # (LOW, MID, HIGH): the amounts' carrier
IDX = {v: i for i, v in enumerate(VALUES)}
CHECK_MIN = 5                            # X's majority of R_CALLS (this freeze's choice, section 4)
VOID_SHARE = tr1.VOID_STRICT_SHARE        # Stage 0's void floor, one half, read here over the eight occasions
assert VOID_SHARE == Fraction(1, 2)

# The eight occasions of V1: (name, the condition its calls are of, the world, the name order) and the pair.
OCCASIONS = [(f"C o{o}", "C", None, o) for o in D.ORDERS] + [(f"I up o{o}", "I", D.UP, o) for o in D.ORDERS] \
    + [(f"T o{o}", "T", None, o) for o in D.ORDERS] + [(f"I down o{o}", "I", D.DOWN, o) for o in D.ORDERS]
PAIR = {name: ((D.MID, D.HIGH) if c == "C" or w == D.UP else (D.MID, D.LOW)) for name, c, w, o in OCCASIONS}


def amount_of(cond, world, answer):
    """An answer as an amount: a frame's answer is one; a course's act pays its amount in its world. Any
    other answer (a decline, filtered, unreadable, "none") is None."""
    if answer in VALUES and cond in ("C", "T", "X"):
        return answer
    if answer in (D.KNOWN, D.UNTRIED) and cond in D.COURSES:
        return D.reply(answer, world)
    return None


def strict(amounts_said):
    """The strict amount among an occasion's answers (as amounts, None where not one), by tr1.strict_rule
    at Q: named in at least Q of them and the unique top; else None."""
    idx = [IDX[a] if a is not None else -1 for a in amounts_said]
    s = tr1.strict_rule(idx, Q)
    return None if s is None else VALUES[s]


def occasion_answers(good, family):
    """{occasion: its answers as amounts} from the records read ({id: record}), each occasion's calls
    in the plan: C's and T's R_CALLS a name order, I's step S_STAR calls of the R_CALLS courses a world
    and name order."""
    out = {}
    for name, c, w, o in OCCASIONS:
        ids = [x["id"] for x in D.plan(family, (c,)) if x["order"] == o and x["world"] == w
               and x.get("step", D.S_STAR) == D.S_STAR]
        out[name] = [amount_of(c, w, good[i]["answer"]) for i in ids]
    return out


def v1(occ):
    """V1 from the occasions' answers ({occasion: R_CALLS amounts or None}): the outcome, why where void,
    the strict pick of each occasion, and the shortest cycle (two occasions strict at either amount of a
    pair) where contradicted."""
    assert set(occ) == {o[0] for o in OCCASIONS} and all(len(v) == R_CALLS for v in occ.values())
    picks = {name: strict(v) for name, v in occ.items()}
    shown = [(sum(1 << IDX[a] for a in PAIR[name]), IDX[p]) for name, p in picks.items() if p is not None]
    cyc = not tr1.no_cycle(tr1.shown(shown, len(VALUES)))
    n_strict = sum(p is not None for p in picks.values())
    per_pair = {pair: [n for n in picks if PAIR[n] == pair and picks[n] is not None] for pair in set(PAIR.values())}
    cycle = None
    if cyc:
        for pair, names in sorted(per_pair.items()):
            by = {}
            for n in names:
                by.setdefault(picks[n], n)
            if len(by) == 2:
                cycle = [[by[pair[0]], pair[0]], [by[pair[1]], pair[1]]]
                break
    if cyc:
        outcome, why = "contradicted", None
    elif Fraction(n_strict, len(OCCASIONS)) < VOID_SHARE:
        outcome, why = "void", "fewer strict occasions than half"
    elif all(len(v) < 2 for v in per_pair.values()):
        outcome, why = "void", "the strict occasions admit no cycle (no pair with two)"
    else:
        outcome, why = "passed", None
    return {"outcome": outcome, "why": why, "picks": picks, "strict": n_strict, "occasions": len(OCCASIONS),
            "cycle": cycle}


def premise(x_answers):
    """X in each world ({world: its R_CALLS answers as amounts}): passed where the amount told is named in
    at least CHECK_MIN of each world's calls."""
    told = {D.UP: D.HIGH, D.DOWN: D.LOW}
    assert all(len(x_answers[w]) == R_CALLS for w in D.WORLDS)
    named = {w: sum(a == told[w] for a in x_answers[w]) for w in D.WORLDS}
    return {"passed": all(named[w] >= CHECK_MIN for w in D.WORLDS), "told amount named, of R_CALLS": named}


def x_answers(good, family):
    out = {}
    for w in D.WORLDS:
        ids = [x["id"] for x in D.plan(family, ("X",)) if x["world"] == w]
        out[w] = [amount_of("X", w, good[i]["answer"]) for i in ids]
    return out


def courses(good, family, cond):
    """{(world, order, rep): the acts by step} of a course condition, every course read whole."""
    out = {}
    for x in D.plan(family, (cond,)):
        out.setdefault((x["world"], x["order"], x["rep"]), {})[x["step"]] = good[x["id"]]["answer"]
    return {k: [v[s] for s in range(1, D.STEPS + 1)] for k, v in out.items()}


def descriptive(good, family, v, prem):
    """What is read apart from V1: per course condition and world, the share of courses taking the other
    option at some step, the first step at which each does, and the share of the other option at each
    step; and the class, from REST-TR1's identification table, read from strict picks only (each R_CALLS
    calls, strict at Q): untrusting where X failed; a presentation reader where an occasion's strict picks
    differ between the name orders; an explorer where U's first act in up is strict at the other option in
    a name order (an uninformed course's words are the same in both worlds until the other option is
    taken); then, from the strict picks of I in up and of C, held by the model (both the high amount),
    held by the order (both the middle), or frame-inconsistent (one each)."""
    out = {}
    first_u = {}
    for cond in D.COURSES:
        cs = courses(good, family, cond)
        for w in D.WORLDS:
            mine = {k: a for k, a in cs.items() if k[0] == w}
            first = {f"o{k[1]} r{k[2]:02d}": next((s for s, act in enumerate(a, 1) if act == D.UNTRIED), None)
                     for k, a in sorted(mine.items())}
            out[f"{cond} {w}"] = {
                "share of courses taking the other option": round(sum(f is not None for f in first.values()) / len(first), 4),
                "first step taking it, per course": first,
                "share of the other option at each step": [round(sum(a[s] == D.UNTRIED for a in mine.values()) / len(mine), 4)
                                                           for s in range(D.STEPS)]}
            if cond == "U" and w == D.UP:
                for o in D.ORDERS:
                    acts = [a[0] for k, a in sorted(mine.items()) if k[1] == o]
                    first_u[o] = tr1.strict_rule([1 if a == D.UNTRIED else 0 if a == D.KNOWN else -1 for a in acts], Q)
    p = v["picks"]
    i_up = {p[f"I up o{o}"] for o in D.ORDERS} - {None}
    c = {p[f"C o{o}"] for o in D.ORDERS} - {None}
    if not prem["passed"]:
        cls = "untrusting: the manipulation check failed, so I is not read on the amounts"
    elif any(p[f"{k} o0"] is not None and p[f"{k} o1"] is not None and p[f"{k} o0"] != p[f"{k} o1"]
             for k in ("C", "T", "I up", "I down")):
        cls = "presentation reader: strict picks differ between the name orders"
    elif 1 in first_u.values():
        cls = "explorer: the uninformed first act in up strict at the other option"
    elif i_up == {D.HIGH} and c == {D.HIGH}:
        cls = "held by the model: known uninformed, takes the other when told it pays high"
    elif i_up == {D.MID} and c == {D.MID}:
        cls = "held by the order: the known when told, the middle over the high in C"
    elif len(i_up) == 1 and len(c) == 1 and i_up != c:
        cls = "frame-inconsistent: I and C strict at either amount"
    else:
        cls = "not classed: the strict picks do not fill a class"
    out["U in up, the first act strict at the other option, per name order"] = {f"o{o}": first_u[o] == 1 for o in D.ORDERS}
    out["class (descriptive)"] = cls
    return out


def reading(family, v, prem, role):
    """The pin's reading: V1 where the premise passed, otherwise not ruled on."""
    if not prem["passed"]:
        bridge, why = "not ruled on", f"the manipulation check failed: {prem['told amount named, of R_CALLS']}"
    else:
        bridge, why = v["outcome"], v["why"]
    said = None
    if bridge == "passed":
        said = f"no cycle among {v['strict']} strict occasions across the frames, at the power of FREEZE-9 section 4"
    elif bridge == "contradicted":
        said = f"a cycle across the frames: {v['cycle']}"
    return {"family": family, "pin_role": role, "decides": role == "decides", "bridge": bridge, "why": why,
            "said": said}


def expectations(readings):
    """FREEZE-9 section 13's expectation as code: the manipulation check passes on every pin read."""
    xs = {r["family"]: r["premise"]["passed"] for r in readings if r.get("premise") is not None}
    return {"the manipulation check passes on every pin read": (all(xs.values()) if xs else None),
            "the check by pin": xs}


# ------------------------------------------------------------------------------------------------
# V1's exact power (section 4): each call trembles to the other amount with chance eps.

def power(eps_list=(Fraction(1, 50), Fraction(1, 20), Fraction(1, 10), Fraction(1, 5))):
    """For each formation and tremble, the exact chances of V1 contradicted, void and passed, each
    occasion's R_CALLS calls independent: a consistent formation (one amount right on each pair at every
    occasion), a frame-inconsistent one (I in up right at the middle, C at the high amount) and a
    first-listed reader (right at the amount listed first: C's A, I's A, which is the known option in
    order 0 and the other in order 1). Exact, over the 3^8 patterns of strict right, strict wrong and
    not strict."""
    right = {
        "consistent": {n: PAIR[n][1] if n.startswith(("C", "I up")) else PAIR[n][0] for n in PAIR},
        "frame-inconsistent": {n: (D.HIGH if n.startswith("C") else D.MID) if PAIR[n] == (D.MID, D.HIGH) else D.MID
                               for n in PAIR},
        "first-listed reader": {"C o0": D.MID, "C o1": D.HIGH, "I up o0": D.MID, "I up o1": D.HIGH,
                                "T o0": D.MID, "T o1": D.LOW, "I down o0": D.MID, "I down o1": D.LOW},
    }
    names = [o[0] for o in OCCASIONS]
    out = []
    for eps in eps_list:
        p = 1 - eps
        pr = sum(Fraction(comb(R_CALLS, k)) * p ** k * (1 - p) ** (R_CALLS - k) for k in range(Q, R_CALLS + 1))
        pw = sum(Fraction(comb(R_CALLS, k)) * (1 - p) ** k * p ** (R_CALLS - k) for k in range(Q, R_CALLS + 1))
        row = {"eps": str(eps), "r": R_CALLS, "q": Q}
        for f, rt in right.items():
            tot = {"contradicted": Fraction(0), "void": Fraction(0), "passed": Fraction(0)}
            for pattern in itertools.product((0, 1, 2), repeat=len(names)):
                pr_ = Fraction(1)
                occ = {}
                for n, s in zip(names, pattern):
                    pr_ *= (pr, pw, 1 - pr - pw)[s]
                    if s == 0:
                        occ[n] = [rt[n]] * R_CALLS
                    elif s == 1:
                        occ[n] = [next(a for a in PAIR[n] if a != rt[n])] * R_CALLS
                    else:
                        occ[n] = [None] * R_CALLS
                tot[v1(occ)["outcome"]] += pr_
            row[f, "contradicted"] = float(tot["contradicted"])
            row[f, "void"] = float(tot["void"])
        chk = sum(Fraction(comb(R_CALLS, k)) * p ** k * (1 - p) ** (R_CALLS - k) for k in range(CHECK_MIN, R_CALLS + 1))
        row["P(the check passes in both worlds), a believer"] = float(chk ** 2)
        row["P(the check would pass in both worlds at Q), a believer"] = float(pr ** 2)
        out.append({k if isinstance(k, str) else f"P({k[1]} | {k[0]})": v for k, v in row.items()})
    return out

