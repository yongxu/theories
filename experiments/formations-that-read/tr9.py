"""TR9 (RF-M.3, informing and revaluing, after TR8), Stage 0: exact values, mirror checks,
simulated choosers and the power check.

Design work only: no model call, no download, no network, no trained system. Python 3.11,
standard library. Deterministic: exact values as integers and fractions.Fraction, simulations from
random.Random seeded with frozen strings. Writes tr9.json next to itself. It imports the mirror of
Becoming.HeldForReading from tr8.py, as Becoming.ListingValuation imports HeldForReading.

    python3 -B tr9.py            # the whole of Stage 0, about two minutes on one core

Parts
  A  A mirror of Becoming.ListingValuation: within, answer, residual, weightOf, weightedOn,
     SplitsKeep; the carrier (Input, Act, Reader.update, answerOf, input, Holder, joint and its
     course). Checked against every evaluated witness of the module: scales_by_candidate,
     unweighted_told, release_keeps, Informing.informing_lowers, WeightsApart.weights_matter,
     weights_split, not_splitsKeep, OneListing.refined_lowers, no_order_across,
     Revaluing.revaluing_best, and TwoWorlds (shown_turns, presented_turns, shown_removes_least,
     shown_course, presented_removes_residual, presented_course, routes_rest, route_answers,
     routes_alike, changed_apart, starts_apart, not_lumped, lumped_with_start, orders_apart).
  B  The mirror checked by enumeration against the criteria and identities the design uses
     (exhaustive on two candidates with values 0-2; sampled on three; SplitsKeep against every
     refinement on sampled three-candidate tables; the carrier's laws on sampled readers), with
     mutation checks.
  C  The design's conditions, each option built by running the carrier (a demonstration filters,
     a presented valuation is adopted, the answer is read once every scheduled input is taken in)
     and checked against Part 1's answer through the map; exact counts (shortfall + amount) by the
     stated objective on the holding formation's model; the options the counts rank first, gaps,
     and the Lean statement each strict exclusion rests on.
  D  The simulated choosers (the counts with noise and lapses, the named rivals, readers fixed by
     what they read, hybrids, calls answered alike) and the power check of the verdict rule.
  E  What Stage 0 settles, and what stays a choice for the freeze.
"""

import itertools
import json
import random
import sys
import time
from fractions import Fraction
from pathlib import Path

import tr8
from tr8 import Model, GO, OFF, byRule, offPart, total, pos, frs, binom_tail, set_partitions
from tr8 import N_CALLS, SUPPORT_AT, CONTRA_AT, part_D_full, familywise_at_half, set_probe_models


class _Sub:
    """A value function given as a callable, read by index as tr8's mirror reads it."""

    def __init__(self, f):
        self.f = f

    def __getitem__(self, c):
        return self.f(c)


def _ix(x):
    return _Sub(x) if callable(x) and not hasattr(x, "__getitem__") else x


def _fn(x):
    return x if callable(x) else (lambda c: x[c])


# The HeldForReading mirror, taking value functions either way (tables or callables).
def shifted(g, l):
    return tr8.shifted(_ix(g), _ix(l))


def byReading(g, l):
    return tr8.byReading(_ix(g), _ix(l))


def goExcess(m, g, l):
    return tr8.goExcess(m, _ix(g), _ix(l))


def offExcess(m, g, l):
    return tr8.offExcess(m, _ix(g), _ix(l))


def shortfall(m, g, l, r):
    return tr8.shortfall(m, _ix(g), _ix(l), r)


def goExcessWithin(m, g, l, pi, z):
    return tr8.goExcessWithin(m, _ix(g), _ix(l), pi, z)


def offExcessWithin(m, g, l, pi, z):
    return tr8.offExcessWithin(m, _ix(g), _ix(l), pi, z)


def leastThrough(m, g, l, pi, z):
    return tr8.leastThrough(m, _ix(g), _ix(l), pi, z)

SEED = "TR9-stage0-2026-10-31"
OUT = Path(__file__).with_suffix(".json")
T0 = time.time()
LEAN = ("experiments/integrated-correction/general-framework/generative-basis/lean/becoming/"
        "Becoming/ListingValuation.lean")


# ---------------------------------------------------------------------------------------------
# A. The mirror of Becoming.ListingValuation
# ---------------------------------------------------------------------------------------------

def within(pm, pi, f, z):
    f = _fn(f)
    return total(pm.listed, lambda c: pm.weight(c) * f(c) if pi(c) == z else 0)


def answer(pm, g, l, pi, z):
    """Stops a cell exactly where the weighted value of going on is below that of switching off."""
    return within(pm, pi, g, z) < within(pm, pi, l, z)


def residual(m, gain, loss, pi, zs, s):
    def term(z):
        P = goExcessWithin(m, gain, loss, pi, z)
        N = offExcessWithin(m, gain, loss, pi, z)
        return pos(P - N) if s(z) else pos(N - P)
    return total(zs, term)


def weightOf(pm, c):
    return total(pm.listed, lambda c2: pm.weight(c2) if c2 == c else 0)


def weightedOn(pm, B, f):
    f = _fn(f)
    return offPart(pm, B, lambda c: pm.weight(c) * f(c))


def splitsKeep(m, pm, gain, loss, g, l, cands):
    """SplitsKeep over every pair of disjoint Boolean sets on the candidates `cands`."""
    for assign in itertools.product((0, 1, 2), repeat=len(cands)):
        Bs = {c for c, a in zip(cands, assign) if a == 1}
        Ds = {c for c, a in zip(cands, assign) if a == 2}
        B = lambda c, Bs=Bs: c in Bs
        D = lambda c, Ds=Ds: c in Ds
        if not (weightedOn(pm, B, l) <= weightedOn(pm, B, g) and weightedOn(pm, D, g) < weightedOn(pm, D, l)):
            continue
        if weightedOn(pm, B, l) + weightedOn(pm, D, l) <= weightedOn(pm, B, g) + weightedOn(pm, D, g):
            if not weightedOn(m, D, gain) <= weightedOn(m, D, loss):
                return False
        if weightedOn(pm, B, g) + weightedOn(pm, D, g) < weightedOn(pm, B, l) + weightedOn(pm, D, l):
            if not weightedOn(m, B, loss) <= weightedOn(m, B, gain):
                return False
    return True


def ans_rule(pm, g, l, pi):
    return lambda c: answer(pm, g, l, pi, pi(c))


def worth(m, gain, loss, r):
    return m.after(shifted(gain, loss), byRule(r))


# The carrier -----------------------------------------------------------------------------------

class Reader:
    """Reader W V O X: weights on worlds, values per valuation state, reveal, revalue."""

    def __init__(self, weight, goVal, offVal, reveal, revalue):
        self.weight, self.goVal, self.offVal = weight, goVal, offVal
        self.reveal, self.revalue = reveal, revalue

    def update(self, st, inp):
        L, v = st
        kind = inp[0]
        if kind == "shown":
            return (tuple(w for w in L if self.reveal(w) == inp[1]), v)
        if kind == "presented":
            return (L, self.revalue(v, inp[1]))
        return st                                   # none, asked

    def answerOf(self, st):
        L, v = st
        pm = Model(L, self.weight)
        return answer(pm, lambda w: self.goVal(v, w), lambda w: self.offVal(v, w), lambda _w: (), ())

    def input(self, w, act):
        if act == "demonstrate":
            return ("shown", self.reveal(w))
        if isinstance(act, tuple) and act[0] == "present":
            return ("presented", act[1])
        if act == "hold":
            return ("asked",)
        return ("none",)                            # go, off


class Schedule:
    """TwoWorlds.schedule: act h = h.headD hold, next h _ = h.tail."""

    @staticmethod
    def act(h):
        return h[0] if h else "hold"

    @staticmethod
    def next(h, _a):
        return h[1:]


def joint_step(rd, hd, x):
    i, s, a, e = x
    i2 = rd.update(i, s)
    return (i2, rd.input(e[0], hd.act(e[1])), rd.answerOf(i2), (e[0], hd.next(e[1], a)))


def course(rd, hd, x, n):
    for _ in range(n):
        x = joint_step(rd, hd, x)
    return x


# TwoWorlds witnesses ---------------------------------------------------------------------------

FIRST, SECOND = "first", "second"
AGREE, RAISED, REVERSED = "agree", "raised", "reversed"
TW_GO = {(AGREE, FIRST): 1, (AGREE, SECOND): 0, (RAISED, FIRST): 1, (RAISED, SECOND): 0,
         (REVERSED, FIRST): 0, (REVERSED, SECOND): 0}
TW_OFF = {(AGREE, FIRST): 0, (AGREE, SECOND): 1, (RAISED, FIRST): 0, (RAISED, SECOND): 2,
          (REVERSED, FIRST): 1, (REVERSED, SECOND): 1}
TW = Reader(lambda w: 1 if w == FIRST else 2, lambda v, w: TW_GO[(v, w)], lambda v, w: TW_OFF[(v, w)],
            lambda w: w, lambda _v, x: x)


def tw_route(b):
    if b:
        return (((FIRST,), REVERSED), ("none",), True, (FIRST, (("present", AGREE),)))
    return (((FIRST, SECOND), AGREE), ("none",), True, (FIRST, ("demonstrate",)))


def tw_record(T, b):
    ans = [course(TW, Schedule, tw_route(b), n)[2] for n in range(T)]
    return (tuple(ans), course(TW, Schedule, tw_route(b), T)[0])


def tw_changed(T, b):
    vals = [course(TW, Schedule, tw_route(b), n)[0][1] for n in range(T + 1)]
    return any(vals[k + 1] != vals[k] for k in range(T))


def part_A():
    fails = []
    chk = {}

    def eq(name, got, want):
        chk[name] = got == want
        if got != want:
            fails.append((name, got, want))

    # scales_by_candidate
    m2 = Model([False, True], lambda _c: 1)
    one = lambda _c: ()
    eq("scales_by_candidate.answer",
       answer(m2, lambda c: 0 if c else 10, lambda c: 2 if c else 0, one, ()), False)
    eq("scales_by_candidate.residual",
       residual(m2, lambda c: 0 if c else 1, lambda c: 2 if c else 0, one, [()],
                lambda z: answer(m2, lambda c: 0 if c else 10, lambda c: 2 if c else 0, one, z)), 1)
    eq("scales_by_candidate.scale", all(1 * (0 if c else 10) + (1 if c else 10) * (2 if c else 0)
                                        == 1 * (2 if c else 0) + (1 if c else 10) * (0 if c else 1)
                                        for c in (False, True)), True)
    # unweighted_told
    mu0 = Model([()], lambda _c: 0)
    mu1 = Model([()], lambda _c: 1)
    idm = lambda c: c
    ok = all(answer(mu0, lambda _c, a=a: a, lambda _c, b=b: b, idm, ()) is False
             for a in range(4) for b in range(4))
    eq("unweighted_told.released", ok, True)
    eq("unweighted_told.residual", residual(mu1, lambda _c: 0, lambda _c: 1, idm, [()],
                                            lambda z: answer(mu0, lambda _c: 0, lambda _c: 1, idm, z)), 1)
    eq("unweighted_told.shortfall", shortfall(mu1, {(): 0}, {(): 1},
                                              lambda c: answer(mu0, lambda _c: 0, lambda _c: 1, idm, c)), 1)
    # release_keeps
    eq("release_keeps.splitsKeep", splitsKeep(mu1, mu1, {(): 0}, {(): 1}, lambda _c: 1, lambda _c: 0, [()]), True)
    eq("release_keeps.residual", residual(mu1, {(): 0}, {(): 1}, one, [()],
                                          lambda z: answer(mu1, lambda _c: 1, lambda _c: 0, one, z)), 1)
    # Informing.informing_lowers
    gain = {False: 0, True: 1}
    loss = {False: 10, True: 0}
    gv = lambda c: 0 if c else 2
    ov = lambda c: 5 if c else 0
    eq("informing_lowers", (
        worth(m2, gain, loss, lambda c: answer(m2, gv, ov, one, ())),
        shortfall(m2, gain, loss, lambda c: answer(m2, gv, ov, one, ())),
        residual(m2, gain, loss, one, [()], lambda z: answer(m2, gv, ov, one, z)),
        worth(m2, gain, loss, lambda c: answer(m2, gv, ov, idm, c)),
        shortfall(m2, gain, loss, lambda c: answer(m2, gv, ov, idm, c)),
        residual(m2, gain, loss, idm, [False, True], lambda z: answer(m2, gv, ov, idm, z)),
        m2.committed(shifted(gain, loss), GO), m2.committed(shifted(gain, loss), OFF)),
       (10, 1, 0, 0, 11, 11, 1, 10))
    # WeightsApart
    hold = Model([0, 1, 2], lambda c: 2 if c == 0 else 1)
    read = Model([0, 1, 2], lambda c: 1 if c == 0 else 2)
    wg = {0: 1, 1: 0, 2: 1}
    wl = {0: 0, 1: 1, 2: 0}
    gf, lf = (lambda c: wg[c]), (lambda c: wl[c])
    two = lambda c: c == 2
    eq("weights_matter", (worth(hold, wg, wl, lambda c: answer(read, gf, lf, one, ())),
                          worth(hold, wg, wl, lambda c: answer(read, gf, lf, two, two(c))),
                          worth(hold, wg, wl, lambda c: answer(read, gf, lf, idm, c))), (3, 2, 4))
    eq("weights_split", (
        shortfall(hold, wg, wl, lambda c: leastThrough(hold, wg, wl, one, ())),
        residual(hold, wg, wl, one, [()], lambda z: answer(read, gf, lf, one, z)),
        shortfall(hold, wg, wl, lambda c: leastThrough(hold, wg, wl, two, two(c))),
        residual(hold, wg, wl, two, [False, True], lambda z: answer(read, gf, lf, two, z)),
        shortfall(hold, wg, wl, lambda c: leastThrough(hold, wg, wl, idm, c)),
        residual(hold, wg, wl, idm, [0, 1, 2], lambda z: answer(read, gf, lf, idm, z))), (1, 0, 1, 1, 0, 0))
    eq("not_splitsKeep", splitsKeep(hold, read, wg, wl, gf, lf, [0, 1, 2]), False)
    # OneListing.refined_lowers
    oh = Model([False], lambda _c: 1)
    orr = Model([False, True], lambda _c: 1)
    og, ol = {False: 0, True: 0}, {False: 1, True: 0}
    ogv = lambda c: 5 if c else 0
    oov = lambda c: 0 if c else 1
    eq("refined_lowers.splitsKeep", splitsKeep(oh, orr, og, ol, ogv, oov, [False, True]), True)
    eq("refined_lowers.worths", (worth(oh, og, ol, lambda c: answer(orr, ogv, oov, idm, c)),
                                 worth(oh, og, ol, lambda c: answer(orr, ogv, oov, one, ()))), (1, 0))
    # no_order_across
    eq("no_order_across", (worth(mu1, {(): 10}, {(): 9}, lambda c: answer(mu1, lambda _c: 10, lambda _c: 9, one, ())),
                           worth(mu1, {(): 1}, {(): 2}, lambda c: answer(mu1, lambda _c: 1, lambda _c: 2, one, ()))),
       (10, 2))
    # Revaluing.revaluing_best
    rg = {False: 1, True: 0}
    rl = {False: 0, True: 1}
    eq("revaluing_best", (
        m2.after(shifted(rg, rl), byReading(rg, rl)),
        m2.committed(shifted(rg, rl), GO), m2.committed(shifted(rg, rl), OFF),
        worth(m2, rg, rl, lambda c: answer(m2, lambda _c: 0, lambda _c: 1, idm, c)),
        worth(m2, rg, rl, lambda c: answer(m2, lambda c2: rg[c2], lambda c2: rl[c2], idm, c)),
        shortfall(m2, rg, rl, lambda _c: False), shortfall(m2, rg, rl, lambda _c: True),
        shortfall(m2, rg, rl, lambda c: answer(m2, lambda _c: 0, lambda _c: 1, idm, c)),
        shortfall(m2, rg, rl, lambda c: answer(m2, lambda c2: rg[c2], lambda c2: rl[c2], idm, c))),
       (2, 1, 1, 1, 2, 1, 1, 1, 0))
    # TwoWorlds
    eq("shown_turns", (TW.answerOf(((FIRST, SECOND), AGREE)),
                       TW.answerOf(TW.update(((FIRST, SECOND), AGREE), ("shown", FIRST))),
                       TW.answerOf(TW.update(((FIRST, SECOND), AGREE), ("presented", RAISED)))), (True, False, True))
    eq("presented_turns", (TW.answerOf(((FIRST,), REVERSED)),
                           TW.answerOf(TW.update(((FIRST,), REVERSED), ("shown", FIRST))),
                           TW.answerOf(TW.update(((FIRST,), REVERSED), ("presented", AGREE)))), (True, True, False))
    mab = Model([FIRST, SECOND], TW.weight)
    ma = Model([FIRST], TW.weight)
    ag = {w: TW.goVal(AGREE, w) for w in (FIRST, SECOND)}
    al = {w: TW.offVal(AGREE, w) for w in (FIRST, SECOND)}
    agf, alf = (lambda w: ag[w]), (lambda w: al[w])
    eq("shown_removes_least", (
        shortfall(mab, ag, al, lambda _w: answer(mab, agf, alf, one, ())),
        residual(mab, ag, al, one, [()], lambda z: answer(mab, agf, alf, one, z)),
        shortfall(mab, ag, al, lambda c: answer(mab, agf, alf, TW.reveal, TW.reveal(c)))), (1, 0, 0))
    st_a = lambda w: (((FIRST, SECOND), AGREE), ("none",), True, (w, ("demonstrate",)))
    eq("shown_course", tuple(shortfall(mab, ag, al, lambda w: course(TW, Schedule, st_a(w), n)[2]) for n in (1, 2)), (1, 0))
    eq("presented_removes_residual", (
        residual(ma, ag, al, one, [()], lambda z: answer(ma, lambda w: TW.goVal(REVERSED, w),
                                                         lambda w: TW.offVal(REVERSED, w), one, z)),
        shortfall(ma, ag, al, lambda _w: leastThrough(ma, ag, al, one, ())),
        shortfall(ma, ag, al, lambda _w: answer(ma, agf, alf, one, ()))), (1, 0, 0))
    st_b = lambda w: (((FIRST,), REVERSED), ("none",), True, (w, (("present", AGREE),)))
    eq("presented_course", tuple(shortfall(ma, ag, al, lambda w: course(TW, Schedule, st_b(w), n)[2]) for n in (1, 2)), (1, 0))
    reached = (((FIRST,), AGREE), ("asked",), False, (FIRST, ()))
    eq("reached_rests", joint_step(TW, Schedule, reached), reached)
    eq("routes_rest", all(course(TW, Schedule, tw_route(b), n + 2) == reached for b in (False, True) for n in range(30)), True)
    eq("route_answers", all(course(TW, Schedule, tw_route(b), 0)[2] is True and course(TW, Schedule, tw_route(b), 1)[2] is True
                            and all(course(TW, Schedule, tw_route(b), n + 2)[2] is False for n in range(30))
                            for b in (False, True)), True)
    eq("routes_alike", all(tw_record(T, False) == tw_record(T, True) for T in range(2, 25)), True)
    eq("changed_apart", all((tw_changed(T, False), tw_changed(T, True)) == (False, True) for T in range(2, 25)), True)
    eq("starts_apart", tw_route(False)[0] != tw_route(True)[0], True)
    eq("not_lumped", all(tw_record(T, False) == tw_record(T, True) and tw_changed(T, False) != tw_changed(T, True)
                         for T in range(2, 25)), True)
    eq("lumped_with_start", all((tw_record(T, False), tw_route(False)[0]) != (tw_record(T, True), tw_route(True)[0])
                                for T in range(0, 25)), True)

    def order_start(first):
        sched = ("demonstrate", ("present", RAISED)) if first else (("present", RAISED), "demonstrate")
        return (((FIRST, SECOND), AGREE), ("none",), True, (FIRST, sched))
    order_end = (((FIRST,), RAISED), ("asked",), False, (FIRST, ()))
    eq("orders_apart", (course(TW, Schedule, order_start(True), 2)[2], course(TW, Schedule, order_start(False), 2)[2],
                        all(course(TW, Schedule, order_start(f), n + 3) == order_end for f in (False, True) for n in range(30))),
       (False, True, True))
    return {"witnesses_checked": len(chk), "failures": fails, "checked": chk}


# ---------------------------------------------------------------------------------------------
# B. Enumeration against the Lean's statements
# ---------------------------------------------------------------------------------------------

def check_two(fails, cnt, mut):
    """Two candidates [0, 1]; m's weights 0-2; reference and valuations 0-2; pm = m or apart."""
    cands = [0, 1]
    ident = lambda c: c
    onec = lambda _c: 0
    MAPS = [("identity", ident, [0, 1]), ("one", onec, [0]), ("one+unused", onec, [0, 7])]
    vals16 = list(itertools.product((0, 1), repeat=4))
    for w in itertools.product(range(3), repeat=2):
        m = Model(cands, lambda c, w=w: w[c])
        for gain in itertools.product(range(3), repeat=2):
            for loss in itertools.product(range(3), repeat=2):
                gE, oE = goExcess(m, gain, loss), offExcess(m, gain, loss)
                for g in itertools.product(range(3), repeat=2):
                    for l in itertools.product(range(3), repeat=2):
                        gf, lf = (lambda c, g=g: g[c]), (lambda c, l=l: l[c])
                        net = all(g[c] + loss[c] == l[c] + gain[c] for c in cands if w[c] > 0)
                        for name, pi, zs in MAPS:
                            least = shortfall(m, gain, loss, lambda c: leastThrough(m, gain, loss, pi, pi(c)))
                            P = {z: goExcessWithin(m, gain, loss, pi, z) for z in zs}
                            N = {z: offExcessWithin(m, gain, loss, pi, z) for z in zs}
                            for sv in itertools.product((False, True), repeat=len(zs)):
                                s = dict(zip(zs, sv))
                                sr = lambda c, s=s: s[pi(c)]
                                res = residual(m, gain, loss, pi, zs, lambda z: s[z])
                                if shortfall(m, gain, loss, sr) != least + res:
                                    fails.append(("shortfall_split", w, gain, loss, name, sv))
                                z0 = all((not s[z] or P[z] <= N[z]) and (s[z] or N[z] <= P[z]) for z in zs)
                                if (res == 0) != z0:
                                    fails.append(("residual_zero_iff",))
                                pz = any((s[z] and N[z] < P[z]) or (not s[z] and P[z] < N[z]) for z in zs)
                                if (0 < res) != pz:
                                    fails.append(("residual_pos_iff",))
                                # own_least: reference := (g, l) on m, the answer by (g, l) at least as high
                                if name != "one+unused":
                                    if worth(m, g, l, sr) > worth(m, g, l, ans_rule(m, gf, lf, pi)):
                                        fails.append(("own_least", w, g, l, name, sv))
                            ar = ans_rule(m, gf, lf, pi)
                            ares = residual(m, gain, loss, pi, zs, lambda z: answer(m, gf, lf, pi, z))
                            crit = all((not (within(m, pi, gf, z) < within(m, pi, lf, z)) or P[z] <= N[z]) and
                                       ((within(m, pi, gf, z) < within(m, pi, lf, z)) or N[z] <= P[z]) for z in zs)
                            if (ares == 0) != crit:
                                fails.append(("answer_residual_zero_iff",))
                            if net and ares != 0:
                                fails.append(("answer_least_of_net", w, gain, loss, g, l, name))
                            for p_, q_ in ((1, 1), (1, 2), (2, 1), (2, 3)):
                                if all(q_ * g[c] + p_ * loss[c] == q_ * l[c] + p_ * gain[c] for c in cands if w[c] > 0):
                                    if ares != 0:
                                        fails.append(("answer_least_of_scaled", p_, q_))
                            # revaluing_gain (pm = m)
                            if name != "one+unused":
                                if worth(m, gain, loss, ar) + ares != worth(m, gain, loss,
                                                                           ans_rule(m, lambda c: gain[c], lambda c: loss[c], pi)):
                                    fails.append(("revaluing_gain",))
                                # revaluing_gains_iff: existence over value functions ({0,1} on each
                                # candidate realizes every answer pattern here)
                                base = worth(m, gain, loss, ar)
                                exists = any(base < worth(m, gain, loss, ans_rule(m, lambda c, v=v: v[c], lambda c, v=v: v[2 + c], pi))
                                             for v in vals16)
                                if exists != (0 < ares):
                                    fails.append(("revaluing_gains_iff",))
                                # outcome_least: by (g, l), its own answer has no residual
                                if residual(m, g, l, pi, zs, lambda z: answer(m, gf, lf, pi, z)) != 0:
                                    fails.append(("outcome_least",))
                        # identity against one cell: informed_*, refined_lt_iff, forgone_least_iff,
                        # coarser_not_above, least_falls (f : identity labels -> one cell)
                        lf_least = shortfall(m, gain, loss, lambda c: leastThrough(m, gain, loss, onec, 0))
                        li_least = shortfall(m, gain, loss, lambda c: leastThrough(m, gain, loss, ident, c))
                        if li_least > lf_least:
                            fails.append(("least_falls",))
                        fine_ans = ans_rule(m, gf, lf, ident)
                        coarse_ans = ans_rule(m, gf, lf, onec)
                        rows = []
                        for s1 in (False, True):
                            for sv in itertools.product((False, True), repeat=2):
                                rows.append((s1, sv))
                        for s1, sv in rows:
                            rc = lambda c, s1=s1: s1
                            rf = lambda c, sv=sv: sv[c]
                            resf = residual(m, gain, loss, ident, [0, 1], lambda z, sv=sv: sv[z])
                            resc = residual(m, gain, loss, onec, [0], lambda z, s1=s1: s1)
                            wc, wf = worth(m, gain, loss, rc), worth(m, gain, loss, rf)
                            if wc > wf + resf:
                                fails.append(("informed_le_add_residual",))
                            if resf == 0 and wc > wf:
                                fails.append(("informed_le",))
                            if resf == 0 and ((wc < wf) != (li_least < lf_least or 0 < resc)):
                                fails.append(("informed_lt_iff",))
                            for k in range(4):
                                # refined_lt_iff: fine + k < coarse + k  <->  (lc - lf) + resc < resf
                                if (wf + k < wc + k) != (pos(lf_least - li_least) + resc < resf):
                                    fails.append(("refined_lt_iff",))
                            if net and wc > worth(m, gain, loss, fine_ans):
                                fails.append(("informed_answer_le",))
                            cnt["refinement_rows"] += 1
                        if net:
                            for k in range(4):
                                for k2 in range(4):
                                    lhs = worth(m, gain, loss, fine_ans) + k < worth(m, gain, loss, coarse_ans) + k2
                                    if lhs != (lf_least + k < li_least + k2):
                                        fails.append(("forgone_least_iff", k, k2))
                                    if k2 <= k and lhs:
                                        fails.append(("coarser_not_above", k, k2))
                            cnt["net_tables"] += 1
                        # revalued_split, revalued_forgone_lt_iff with pm apart (weights 2-w) and pm = m,
                        # against one second valuation per table (deterministic choice)
                        g2 = ((g[0] + 1) % 3, l[1])
                        l2 = (l[0], (g[1] + 2) % 3)
                        g2f, l2f = (lambda c: g2[c]), (lambda c: l2[c])
                        for pm in (m, Model(cands, lambda c, w=w: 2 - w[c])):
                            for name, pi, zs in MAPS[:2]:
                                a1 = ans_rule(pm, gf, lf, pi)
                                a2 = ans_rule(pm, g2f, l2f, pi)
                                r1 = residual(m, gain, loss, pi, zs, lambda z: answer(pm, gf, lf, pi, z))
                                r2 = residual(m, gain, loss, pi, zs, lambda z: answer(pm, g2f, l2f, pi, z))
                                if shortfall(m, gain, loss, a1) + r2 != shortfall(m, gain, loss, a2) + r1:
                                    fails.append(("revalued_split",))
                                for k, k2 in ((0, 0), (0, 2), (3, 0), (2, 5)):
                                    if (worth(m, gain, loss, a1) + k2 < worth(m, gain, loss, a2) + k) != (r2 + k2 < r1 + k):
                                        fails.append(("revalued_forgone_lt_iff",))
                                # residual_pos_of_gains (any pm): a gain needs a positive residual
                                if worth(m, gain, loss, a1) < worth(m, gain, loss, a2) and not 0 < r1:
                                    fails.append(("residual_pos_of_gains",))
                            # told_residual_zero_iff (identity, pm's net agreement where pm weighs)
                            pnet = all(g[c] + loss[c] == l[c] + gain[c] for c in cands if pm.weight(c) > 0)
                            if pnet:
                                tres = residual(m, gain, loss, ident, [0, 1], lambda z: answer(pm, gf, lf, ident, z))
                                crit = all(weightOf(pm, c) > 0 for c in cands if w[c] > 0 and gain[c] < loss[c])
                                if (tres == 0) != crit:
                                    fails.append(("told_residual_zero_iff",))
                                if (shortfall(m, gain, loss, ans_rule(pm, gf, lf, ident)) == 0) != crit:
                                    fails.append(("told_shortfall_zero_iff",))
                                cnt["told_cases"] += 1
                        # revalued_lowers_iff: reference := (g, l), pm = m, the second valuation
                        for name, pi, zs in MAPS[:2]:
                            cur = worth(m, g, l, ans_rule(m, gf, lf, pi))
                            new = worth(m, g, l, ans_rule(m, g2f, l2f, pi))
                            Pg = {z: goExcessWithin(m, g, l, pi, z) for z in zs}
                            Ng = {z: offExcessWithin(m, g, l, pi, z) for z in zs}
                            dec = any((answer(m, g2f, l2f, pi, z) and Ng[z] < Pg[z]) or
                                      (not answer(m, g2f, l2f, pi, z) and Pg[z] < Ng[z]) for z in zs)
                            if (new < cur) != dec:
                                fails.append(("revalued_lowers_iff",))
                            # mutation: the answer stopping at ties breaks own_least's tie part?
                            tie_ans = lambda c, pi=pi: within(m, pi, gf, pi(c)) <= within(m, pi, lf, pi(c))
                            if worth(m, g, l, tie_ans) != cur:
                                mut["answer_stopping_at_ties_changes_own_worth"] += 1
                        # const_worth, const_below_iff, one_cell_worth
                        for b in (False, True):
                            wv = worth(m, gain, loss, lambda c, b=b: b)
                            if wv != m.committed(shifted(gain, loss), OFF if b else GO):
                                fails.append(("const_worth",))
                            for k in range(3):
                                if (wv < wv + k) != (0 < k):
                                    fails.append(("const_below_iff",))
                        oc = answer(m, gf, lf, onec, 0)
                        if worth(m, gain, loss, lambda c: oc) != m.committed(shifted(gain, loss), OFF if oc else GO):
                            fails.append(("one_cell_worth",))
                        # mutation: residual without truncation (signed) breaks the split
                        sgn = total([0], lambda z: (goExcessWithin(m, gain, loss, onec, z) - offExcessWithin(m, gain, loss, onec, z)))
                        if shortfall(m, gain, loss, lambda c: True) != lf_least + sgn:
                            mut["residual_signed_breaks_split"] += 1
                        cnt["two_candidate_tables"] += 1


def partition_maps(n):
    out = []
    for blocks in set_partitions(list(range(n))):
        lab = [None] * n
        for i, b in enumerate(blocks):
            for c in b:
                lab[c] = i
        out.append(tuple(lab))
    return out


def refines(fine, coarse):
    """coarse = f o fine on every candidate, for some f."""
    f = {}
    for a, b in zip(fine, coarse):
        if f.setdefault(a, b) != b:
            return False
    return True


def check_three(fails, cnt, rng):
    """Sampled three-candidate tables: informing over every refinement pair; SplitsKeep against
    refining_never_lowers_iff (the criterion over every refinement on both listings)."""
    parts = partition_maps(3)
    pairs = [(fi, co) for fi in parts for co in parts if refines(fi, co)]
    sk_true = sk_false = 0
    for t in range(20000):
        wm = [rng.randint(0, 2) for _ in range(3)]
        wp = [rng.randint(0, 2) for _ in range(3)] if t % 2 else list(wm)
        mlist = [0, 1, 2] if t % 5 else [c for c in range(3) if rng.random() < 0.7]
        m = Model(mlist, lambda c, wm=wm: wm[c])
        pm = Model([0, 1, 2], lambda c, wp=wp: wp[c])
        gain = [rng.randint(0, 3) for _ in range(3)]
        loss = [rng.randint(0, 3) for _ in range(3)]
        if t % 3 == 0:
            off = [rng.randint(0, 2) for _ in range(3)]
            g = [gain[c] + off[c] for c in range(3)]
            l = [loss[c] + off[c] for c in range(3)]
        else:
            g = [rng.randint(0, 3) for _ in range(3)]
            l = [rng.randint(0, 3) for _ in range(3)]
        gf, lf = (lambda c, g=g: g[c]), (lambda c, l=l: l[c])
        never_lower = True
        for fi, co in pairs:
            pif, pic = (lambda c, fi=fi: fi[c]), (lambda c, co=co: co[c])
            zf, zc = sorted(set(fi)), sorted(set(co))
            wfine = worth(m, gain, loss, ans_rule(pm, gf, lf, pif))
            wco = worth(m, gain, loss, ans_rule(pm, gf, lf, pic))
            if wco > wfine:
                never_lower = False
            lfine = shortfall(m, gain, loss, lambda c: leastThrough(m, gain, loss, pif, pif(c)))
            lco = shortfall(m, gain, loss, lambda c: leastThrough(m, gain, loss, pic, pic(c)))
            if lfine > lco:
                fails.append(("least_falls_3",))
            if wm == wp and mlist == [0, 1, 2]:
                net = all(g[c] + loss[c] == l[c] + gain[c] for c in mlist if wm[c] > 0)
                if net:
                    for k in range(3):
                        for k2 in range(k + 1):
                            if worth(m, gain, loss, ans_rule(m, gf, lf, pif)) + k < worth(m, gain, loss, ans_rule(m, gf, lf, pic)) + k2:
                                fails.append(("coarser_not_above_3",))
                    cnt["net_refinements_3"] += 1
            # refined_lt_iff with s, s' each answer by a sampled valuation and by the reference
            for _ in range(2):
                sv = [rng.random() < 0.5 for _ in range(3)]
                sf_ = {z: sv[z] for z in zf}
                sc_ = {z: sv[z] for z in zc}
                rf_ = residual(m, gain, loss, pif, zf, lambda z: sf_[z])
                rc_ = residual(m, gain, loss, pic, zc, lambda z: sc_[z])
                wf_ = worth(m, gain, loss, lambda c: sf_[pif(c)])
                wc_ = worth(m, gain, loss, lambda c: sc_[pic(c)])
                if (wf_ < wc_) != (pos(lco - lfine) + rc_ < rf_):
                    fails.append(("refined_lt_iff_3",))
            cnt["refinement_pairs_3"] += 1
        sk = splitsKeep(m, pm, gain, loss, gf, lf, [0, 1, 2])
        if sk != never_lower:
            fails.append(("refining_never_lowers_iff", wm, wp, mlist, gain, loss, g, l))
        if sk:
            sk_true += 1
        else:
            sk_false += 1
        if wm == wp and mlist == [0, 1, 2] and all(g[c] + loss[c] == l[c] + gain[c] for c in range(3) if wm[c] > 0) and not sk:
            fails.append(("splitsKeep_of_net",))
        if all(l[c] <= g[c] for c in range(3)) and not sk:
            fails.append(("splitsKeep_of_off_le_go",))
        cnt["three_candidate_tables"] += 1
    cnt["splitsKeep_true"] = sk_true
    cnt["splitsKeep_false"] = sk_false


def check_carrier(fails, cnt, rng):
    """timing, answer_shown, shown_never_lowers, inputs_alike, undemonstrated_worth,
    answer_constant, presented_forgone_lt_iff, updates_commute on sampled readers."""
    W = [0, 1, 2]
    V = [0, 1, 2]
    for t in range(1500):
        wt = [rng.randint(0, 2) for _ in W]
        gv = {(v, w): rng.randint(0, 3) for v in V for w in W}
        ov = {(v, w): rng.randint(0, 3) for v in V for w in W}
        rev = [rng.randint(0, 1) for _ in W]
        rd = Reader(lambda w, wt=wt: wt[w], lambda v, w, gv=gv: gv[(v, w)], lambda v, w, ov=ov: ov[(v, w)],
                    lambda w, rev=rev: rev[w], lambda _v, x: x)
        L = tuple(w for w in W if rng.random() < 0.8)
        v0 = rng.choice(V)
        acts = ["go", "off", "hold", "demonstrate"] + [("present", x) for x in V]
        sched = tuple(rng.choice(acts) for _ in range(rng.randint(0, 3)))
        for w in W:
            x0 = ((L, v0), ("none",), rng.random() < 0.5, (w, sched))
            xs = [x0]
            for n in range(6):
                xs.append(joint_step(rd, Schedule, xs[-1]))
            for n in range(3):
                if xs[n + 1][1] != rd.input(xs[0][3][0], Schedule.act(xs[n][3][1])):
                    fails.append(("timing.sensory",))
                if xs[n + 2][0] != rd.update(xs[n + 1][0], xs[n + 1][1]):
                    fails.append(("timing.internal",))
                if xs[n + 2][2] != rd.answerOf(xs[n + 2][0]):
                    fails.append(("timing.active",))
                if xs[n + 3][3][1] != Schedule.next(xs[n + 2][3][1], xs[n + 2][2]):
                    fails.append(("timing.external",))
            if any(x[3][0] != w for x in xs):
                fails.append(("world_fixed",))
            # answer_shown
            st = rd.update((L, v0), ("shown", rd.reveal(w)))
            if st != (tuple(c for c in L if rd.reveal(c) == rd.reveal(w)), v0):
                fails.append(("answer_shown.state",))
            pmL = Model(L, rd.weight)
            if rd.answerOf(st) != answer(pmL, lambda c: rd.goVal(v0, c), lambda c: rd.offVal(v0, c), rd.reveal, rd.reveal(w)):
                fails.append(("answer_shown.answer",))
            # updates_commute
            for x in V:
                a = rd.update(rd.update((L, v0), ("shown", rd.reveal(w))), ("presented", x))
                b = rd.update(rd.update((L, v0), ("presented", x)), ("shown", rd.reveal(w)))
                if a != b:
                    fails.append(("updates_commute",))
        # shown_never_lowers: net agreement of v0 with a reference on L's positive weights
        off = [rng.randint(0, 2) for _ in W]
        gain = {w: pos(rd.goVal(v0, w) - off[w]) for w in W}
        loss = {w: rd.offVal(v0, w) - rd.goVal(v0, w) + gain[w] for w in W}
        if all(loss[w] >= 0 for w in W):
            mL = Model(L, rd.weight)
            if all(rd.goVal(v0, w) + loss[w] == rd.offVal(v0, w) + gain[w] for w in L if rd.weight(w) > 0):
                before = worth(mL, gain, loss, lambda _w: rd.answerOf((L, v0)))
                after = worth(mL, gain, loss, lambda w: rd.answerOf(rd.update((L, v0), ("shown", rd.reveal(w)))))
                if after < before:
                    fails.append(("shown_never_lowers",))
                cnt["shown_never_lowers_cases"] += 1
        # presented_forgone_lt_iff, any holding model m
        m = Model([w for w in W if rng.random() < 0.8], lambda w, wt=wt: wt[(w + 1) % 3])
        gref = {w: rng.randint(0, 3) for w in W}
        lref = {w: rng.randint(0, 3) for w in W}
        x = rng.choice(V)
        cur = lambda _w: rd.answerOf((L, v0))
        new = lambda _w: rd.answerOf(rd.update((L, v0), ("presented", x)))
        for k, k2 in ((0, 0), (1, 0), (0, 2), (3, 1)):
            lhs = worth(m, gref, lref, cur) + k2 < worth(m, gref, lref, new) + k
            rhs = residual(m, gref, lref, lambda _w: (), [()], lambda _z: new(None)) + k2 < \
                residual(m, gref, lref, lambda _w: (), [()], lambda _z: cur(None)) + k
            if lhs != rhs:
                fails.append(("presented_forgone_lt_iff",))
        # undemonstrated_worth / answer_constant: a schedule with no demonstration
        sched_nd = tuple(rng.choice(["go", "off", "hold"] + [("present", y) for y in V]) for _ in range(3))
        for n in range(5):
            rule = lambda w, n=n: course(rd, Schedule, ((L, v0), ("none",), True, (w, sched_nd)), n)[2]
            a0 = rule(0)
            if worth(m, gref, lref, rule) != m.committed(shifted(gref, lref), OFF if a0 else GO):
                fails.append(("undemonstrated_worth",))
        # inputs_alike: worlds with one reveal have one course
        for w1, w2 in itertools.combinations(W, 2):
            if rd.reveal(w1) == rd.reveal(w2):
                for n in range(5):
                    x1 = course(rd, Schedule, ((L, v0), ("none",), False, (w1, sched)), n)
                    x2 = course(rd, Schedule, ((L, v0), ("none",), False, (w2, sched)), n)
                    if x1[:3] != x2[:3] or x1[3][1] != x2[3][1]:
                        fails.append(("inputs_alike",))
        cnt["carrier_readers"] += 1


def part_B():
    fails = []
    cnt = {"two_candidate_tables": 0, "refinement_rows": 0, "net_tables": 0, "told_cases": 0,
           "three_candidate_tables": 0, "refinement_pairs_3": 0, "net_refinements_3": 0,
           "carrier_readers": 0, "shown_never_lowers_cases": 0}
    mut = {"answer_stopping_at_ties_changes_own_worth": 0, "residual_signed_breaks_split": 0}
    t = time.time()
    check_two(fails, cnt, mut)
    t2 = time.time() - t
    rng = random.Random(SEED + "-B")
    t = time.time()
    check_three(fails, cnt, rng)
    t3 = time.time() - t
    t = time.time()
    check_carrier(fails, cnt, rng)
    tc = time.time() - t
    return {"counts": cnt, "n_failures": len(fails), "failures": fails[:40], "mutations": mut,
            "seconds": {"two": round(t2, 1), "three": round(t3, 1), "carrier": round(tc, 1)},
            "note": ("Mutations: an answer stopping at ties never changes the worth by the reader's own "
                     "valuation (ties add to neither excess), so the tie rule matters for which option is "
                     "taken, not for any count; a residual without truncation breaks the split wherever a "
                     "cell's preference is not the rule's, so the truncation is load-bearing."),
            "the_menu_in_the_lean": [
                "menu_rank is not a candidate lemma: every option (going on, switching off, waiting, "
                "showing, giving values, both) holds for the reader's resulting rule at its amount, a "
                "plan of RevisionPlans.order under the stated objective's gain and loss (the committed "
                "moves goOn 0 and off 0), and RevisionPlans.above_iff with excess_goOn, excess_off and "
                "excess_held ranks any two by amount + shortfall; ListingValuation.forgone_lt_iff, "
                "proved through above_iff and HeldForReading.held_above_held_iff, is its form for two "
                "rules, and const_worth makes a committed move a constant rule. TR8's script checks the "
                "order of plans on every enumerated table.",
            ],
            "candidate_core_lemmas": [
                "answer_least_of_scaled composed with informed_le (inference, the reviewing session's report): a "
                "positive common scale suffices for informing never to lower the worth; not stated as "
                "one theorem. No verdict rests on it.",
            ]}


# ---------------------------------------------------------------------------------------------
# C. The design's conditions, built through the carrier
# ---------------------------------------------------------------------------------------------

def build_option(rd, L, v0, sched, worlds):
    """The rule an option gives: run the joint law from one start at each world, the schedule's
    acts emitted at steps 0, 1, ..., and read the answer once every input is taken in (timing:
    an act emitted at t is in the answer at t + 2)."""
    n = len(sched) + 1
    return {w: course(rd, Schedule, ((L, v0), ("none",), True, (w, tuple(sched))), n)[2] for w in worlds}


def part1_rule(rd, L, v0, sched, worlds):
    """The same rule from Part 1: the answer through what is shown, by the revalued valuation."""
    v = v0
    shown = False
    for a in sched:
        if isinstance(a, tuple) and a[0] == "present":
            v = rd.revalue(v, a[1])
        if a == "demonstrate":
            shown = True
    pm = Model(L, rd.weight)
    g = lambda w: rd.goVal(v, w)
    l = lambda w: rd.offVal(v, w)
    if shown:
        return {w: answer(pm, g, l, rd.reveal, rd.reveal(w)) for w in worlds}
    return {w: answer(pm, g, l, lambda _w: (), ()) for w in worlds}


def tr9_condition(cid, role, note, m, objective, rd, L, v0, options, governing, regime):
    """options: (label, kind, schedule or None for a committed move, amount)."""
    gain, loss = objective
    worlds = list(dict.fromkeys(m.listed))
    S = goExcess(m, gain, loss) + offExcess(m, gain, loss)
    T = total(m.listed, m.weight)
    outs = []
    for label, kind, sched, k in options:
        if sched is None:
            stops = {w: kind == "off" for w in worlds}
        else:
            stops = build_option(rd, L, v0, sched, worlds)
            if stops != part1_rule(rd, L, v0, sched, worlds):
                raise AssertionError(("carrier and Part 1 disagree", cid, label))
        sf = shortfall(m, gain, loss, lambda w: stops[w])
        outs.append({"label": label, "kind": kind, "schedule": None if sched is None else [str(a) for a in sched],
                     "k": k, "k_per_decision": frs(Fraction(k, T)), "stops": {str(w): stops[w] for w in worlds},
                     "shortfall": sf, "count": sf + k,
                     "worth_total": worth(m, gain, loss, lambda w: stops[w]) - k})
    cs = sorted(set(o["count"] for o in outs))
    first = [o["label"] for o in outs if o["count"] == cs[0]]
    gap = cs[1] - cs[0] if len(cs) > 1 else 0
    by_reader = ({w: rd.goVal(v0, w) for w in worlds}, {w: rd.offVal(v0, w) for w in worlds})
    xs = [a[1] for _l, _k, sch, _a in options if sch for a in sch if isinstance(a, tuple) and a[0] == "present"]
    by_task = (({w: rd.goVal(xs[0], w) for w in worlds}, {w: rd.offVal(xs[0], w) for w in worlds})
               if xs else objective)
    RAW[cid] = (m, rd, L, v0, objective, by_reader, by_task, worlds)
    r_opts[cid] = options
    return {"id": cid, "role": role, "regime": regime, "note": note, "T": T, "scale_S": S,
            "goExcess": goExcess(m, gain, loss), "offExcess": offExcess(m, gain, loss),
            "options": outs, "counts_first": first, "gap": gap,
            "gap_rel": round(gap / S, 4), "gap_per_decision": frs(Fraction(gap, T)),
            "governing": governing}


def design_tables():
    A, B, Cc = "a", "b", "c"
    # The CV/REF table: two situations, weight one each; the reader values a at go 20 / off 0 and
    # b at go 0 / off 50 (state 'own'); the task values (state 'task') are a: go 0 / off 100,
    # b: go 50 / off 0, opposite to the reader's at both. A demonstration shows the situation.
    VALS = {("own", A): (20, 0), ("own", B): (0, 50), ("task", A): (0, 100), ("task", B): (50, 0),
            ("own", Cc): (5, 5), ("own_c", A): (20, 0), ("own_c", B): (0, 50), ("own_c", Cc): (5, 6),
            ("task", Cc): (5, 5)}
    rd = Reader(lambda _w: 1, lambda v, w: VALS[(v, w)][0], lambda v, w: VALS[(v, w)][1],
                lambda w: w, lambda _v, x: x)
    rd_blind = Reader(lambda _w: 1, lambda v, w: VALS[(v, w)][0], lambda v, w: VALS[(v, w)][1],
                      lambda _w: "noon", lambda _v, x: x)
    m = Model([A, B], lambda _w: 1)
    own = ({A: 20, B: 0}, {A: 0, B: 50})
    task = ({A: 0, B: 50}, {A: 100, B: 0})
    six = [("go", "go", None, 0), ("off", "off", None, 0), ("wait", "wait", (), 0),
           ("show, then wait", "show", ("demonstrate",), 4),
           ("give the task values, then wait", "give", (("present", "task"),), 3),
           ("give and show, then wait", "give+show", (("present", "task"), "demonstrate"), 7)]
    four = six[:4]
    conds = [
        tr9_condition("CV6", "strict", "objective: the reader's current values; six options", m, own, rd,
                      (A, B), "own", six,
                      {"show over wait/off/go": "forgone_least_iff (net trivial: reference = current), "
                       "threshold_go_iff/threshold_off_iff on the shown answer",
                       "show over give+show": "own_least, revalued_forgone_lt_iff with outcome_least",
                       "wait over give": "forgone_lt_iff (the same rule, shortfall 20, against 20 and the amount 3; "
                       "presented_forgone_lt_iff, as oriented, gives only that giving is not above waiting)"},
                      "CV"),
        tr9_condition("REF6", "strict", "objective: the task values; the same six options and numbers", m, task, rd,
                      (A, B), "own", six,
                      {"give+show over show": "revalued_forgone_lt_iff (residual 150 against 0)",
                       "give+show over wait/off": "forgone_lt_iff",
                       "show strictly worst": "forgone_through_lt_iff (least shortfall + residual + amount: "
                       "show 0 + 150 + 4 against give 50 + 0 + 3, wait and off 50 + 0 + 0, go 100; "
                       "the pattern of Informing.informing_lowers, the same signs, not a scaling)"},
                      "REF"),
        tr9_condition("CVW", "strict", "objective: the reader's values; no option gives values", m, own, rd,
                      (A, B), "own", four, {"show over wait": "forgone_least_iff"}, "CV"),
        tr9_condition("REFW", "strict", "objective: the task values; no option gives values (withholding)", m,
                      task, rd, (A, B), "own", four,
                      {"wait/off over show": "forgone_through_lt_iff (least shortfall + residual + amount: "
                       "show 0 + 150 + 4 against wait and off 50 + 0 + 0; at equal amounts refined_lt_iff, "
                       "the finer rule's residual 150 exceeding the coarser's 0 by more than the least "
                       "shortfall falls, 50, and the finer option's larger amount only widens the gap)"}, "REF"),
    ]
    # CV-T: a third situation c, tied for the reader (go 5 / off 5); a revaluation changing only c.
    m3 = Model([A, B, Cc], lambda _w: 1)
    own3 = ({A: 20, B: 0, Cc: 5}, {A: 0, B: 50, Cc: 5})
    conds.append(tr9_condition(
        "CVT", "strict", "objective: the reader's values; a revaluation changing only a tied situation",
        m3, own3, rd, (A, B, Cc), "own",
        [("go", "go", None, 0), ("off", "off", None, 0), ("wait", "wait", (), 0),
         ("show, then wait", "show", ("demonstrate",), 4),
         ("give the revised values and show, then wait", "give+show", (("present", "own_c"), "demonstrate"), 16)],
        {"show over give+show": "revalued_forgone_lt_iff with outcome_least (revalued_lowers_iff: no "
         "strict loss before the amount, the change being at a tied cell)"}, "CV"))
    # UNINF: a demonstration that cannot tell a from b.
    conds.append(tr9_condition(
        "UNINF", "strict", "objective: the reader's values; the demonstration shows the same in both "
        "situations", m, own, rd_blind, (A, B), "own",
        [("go", "go", None, 0), ("off", "off", None, 0), ("wait", "wait", (), 0),
         ("show the uninformative view, then wait", "show", ("demonstrate",), 12)],
        {"wait/off over show": "answer_constant and const_below_iff (undemonstrated_worth)"}, "CV"))
    # The revaluing table (Revaluing.revaluing_best, times ten): the reader is already told the
    # situation (every option but the committed ones begins with a free demonstration).
    RV = {("prefoff", A): (0, 10), ("prefoff", B): (0, 10), ("t2", A): (10, 0), ("t2", B): (0, 10),
          ("agrees", A): (5, 1), ("agrees", B): (1, 5)}
    rdv = Reader(lambda _w: 1, lambda v, w: RV[(v, w)][0], lambda v, w: RV[(v, w)][1],
                 lambda w: w, lambda _v, x: x)
    t2 = ({A: 10, B: 0}, {A: 0, B: 10})
    prefoff = ({A: 0, B: 0}, {A: 10, B: 10})

    def rev_opts(k):
        return [("go", "go", None, 0), ("off", "off", None, 0), ("wait", "wait", ("demonstrate",), 0),
                ("give the task values, then wait", "give", ("demonstrate", ("present", "t2")), k)]
    conds += [
        tr9_condition("REV4", "strict", "objective: the task values; giving costs 4, below the residual 10",
                      m, t2, rdv, (A, B), "prefoff", rev_opts(4),
                      {"give over wait": "revalued_forgone_lt_iff / revaluing_gain (gain = residual 10)"}, "REF"),
        tr9_condition("REV16", "strict", "objective: the task values; giving costs 16, above the residual",
                      m, t2, rdv, (A, B), "prefoff", rev_opts(16),
                      {"wait over give": "revalued_forgone_lt_iff"}, "REF"),
        tr9_condition("REVCV", "strict", "objective: the reader's values; the same numbers as REV4", m,
                      prefoff, rdv, (A, B), "prefoff", rev_opts(4),
                      {"wait over give": "own_least, revalued_lowers_iff (the task values decide a "
                       "into the reader's strict dispreference)"}, "CV"),
        tr9_condition("REV0", "strict", "objective: the task values; the reader's strict preferences already "
                      "agree with them (residual 0); giving costs 6", m, t2, rdv, (A, B), "agrees", rev_opts(6),
                      {"wait over give": "revaluing_gains_iff (residual 0: no valuation gains), "
                       "revalued_forgone_lt_iff"}, "REF"),
    ]
    # WA-P (strict, the control separating N10): the weights apart (WeightsApart, times ten): partial showing lowers the worth.
    WV = {("v", 0): (10, 0), ("v", 1): (0, 10), ("v", 2): (10, 0)}
    rdw = Reader(lambda c: 1 if c == 0 else 2, lambda v, w: WV[(v, w)][0], lambda v, w: WV[(v, w)][1],
                 lambda c: c == 2, lambda _v, x: x)
    rdw_full = Reader(lambda c: 1 if c == 0 else 2, lambda v, w: WV[(v, w)][0], lambda v, w: WV[(v, w)][1],
                      lambda c: c, lambda _v, x: x)
    mh = Model([0, 1, 2], lambda c: 2 if c == 0 else 1)
    wobj = ({0: 10, 1: 0, 2: 10}, {0: 0, 1: 10, 2: 0})
    conds.append(tr9_condition(
        "WAP", "strict", "weights apart (holding 2,1,1; reader 1,2,2); a partial view only", mh, wobj, rdw,
        (0, 1, 2), "v",
        [("go", "go", None, 0), ("off", "off", None, 0), ("wait", "wait", (), 0),
         ("show whether the case is the third, then wait", "show", ("demonstrate",), 0)],
        {"wait/go over partial show": "forgone_lt_iff (WeightsApart.weights_matter scaled: 30 against 20)"},
        "REF"))
    full = tr9_condition("WAF", "x", "the full view in the same table", mh, wobj, rdw_full, (0, 1, 2), "v",
                         [("show all, then wait", "show", ("demonstrate",), 0)], {}, "REF")
    return conds, {"WA_full_view_worth": full["options"][0]["worth_total"]}


def design_rules(conds):
    rep = []
    for c in conds:
        if c["role"] == "strict":
            ok = c["gap"] >= 6 and c["gap"] >= 0.10 * c["scale_S"]
            rep.append({"id": c["id"], "first": c["counts_first"], "gap": c["gap"],
                        "rel": c["gap_rel"], "meets": ok})
    return rep


# ---------------------------------------------------------------------------------------------
# D. Simulated choosers and the power check
# ---------------------------------------------------------------------------------------------

def opt_by(c, kinds):
    return [o for o in c["options"] if o["kind"] in kinds]


def argmin(opts, key):
    vals = [(key(o), o["label"]) for o in opts]
    mn = min(v for v, _ in vals)
    return [lab for v, lab in vals if v == mn]


def counts_first(c, key=lambda o: o["count"], allowed=None):
    opts = c["options"] if allowed is None else [o for o in c["options"] if o["kind"] in allowed]
    return argmin(opts, key)


def make_agents(conds_by_id, alt_counts):
    A = []
    for s in (0.0, 0.05, 0.10, 0.15, 0.20, 0.30):
        for eps in (0.0, 0.05, 0.10):
            A.append({"name": f"counts sigma={s} lapse={eps}", "family": "law", "sigma": s, "lapse": eps})
    lapse = 0.05
    det = lambda name, fam, f: A.append({"name": name, "family": fam, "det": f, "lapse": lapse})
    det("N1 norm: always shows, never gives", "rival",
        lambda c, x: ([o["label"] for o in opt_by(c, ("show",))] or counts_first(c, allowed=("go", "off", "wait"))))
    det("N2 manipulator: always gives (and shows where offered)", "rival",
        lambda c, x: ([o["label"] for o in opt_by(c, ("give+show",))] or [o["label"] for o in opt_by(c, ("give",))]
                      or counts_first(c)))
    det("N3 persuasion only: counts, never gives", "rival",
        lambda c, x: counts_first(c, allowed=("go", "off", "wait", "show")))
    det("N4 deferential: always waits uninformed", "rival",
        lambda c, x: [o["label"] for o in opt_by(c, ("wait",))])
    det("N5 objective-confused: counts by the reader's current values", "rival",
        lambda c, x: argmin(c["options"], lambda o: alt_counts[c["id"]]["by_reader"][o["label"]]))
    det("N6 task values always: counts by the presented values where any", "rival",
        lambda c, x: argmin(c["options"], lambda o: alt_counts[c["id"]]["by_task"][o["label"]]))
    det("N7 reader taken to answer by the objective once shown", "rival",
        lambda c, x: argmin(c["options"], lambda o: alt_counts[c["id"]]["reader_perfect"][o["label"]]))
    det("N8 cost-blind counts", "rival", lambda c, x: argmin(c["options"], lambda o: o["shortfall"]))
    det("N9 never acts on the reader (go, off or wait only)", "rival",
        lambda c, x: counts_first(c, allowed=("go", "off", "wait")))
    det("N10 own weights: counts by the reader's weights", "rival",
        lambda c, x: argmin(c["options"], lambda o: alt_counts[c["id"]]["reader_weights"][o["label"]]))
    det("F1 position: first listed, order shuffled per call", "fixed", lambda c, x: [o["label"] for o in c["options"]])
    det("F2 position: first listed, order fixed", "fixed", lambda c, x: c["options"][0]["label"])
    det("F3 label: never gives under the social framing, counts under the abstract", "fixed",
        lambda c, x: counts_first(c, allowed=("go", "off", "wait", "show")) if x["framing"] == "social" else counts_first(c))
    det("F4 label: never takes an option described as changing values", "fixed",
        lambda c, x: counts_first(c, allowed=("go", "off", "wait", "show")))
    det("H1 counts where worths are given, deferential where left to compute", "hybrid",
        lambda c, x: counts_first(c) if x["presentation"] == "given" else [o["label"] for o in opt_by(c, ("wait",))])
    for rho in (0.3, 0.6):
        A.append({"name": f"H3 calls alike: with prob {rho} a condition's calls all take one option drawn once, "
                          "else counts sigma=0.1", "family": "hybrid", "alike": rho})
    set_probe_models(A, PROBE_OWN_TR9)
    # the guard's own check, as TR8's: choices follow the counts-first options (a cue aligned with
    # them), the probe computes cost-blind counts (N8's)
    A.append({"name": G1_NAME_TR9, "family": "guard", "det": lambda c, x: counts_first(c), "lapse": lapse,
              "probe": "cue", "probe_det": lambda c, x: argmin(c["options"], lambda o: o["shortfall"])})
    return A


G1_NAME_TR9 = "G1 guard check: chooses the counts-first options by a cue, its probe cost-blind"


# As TR8's: rivals defined by another calculation probe their own counts ("own"); rivals defined by a
# choice policy probe the told counts ("counts"). An assumption of the power check.
PROBE_OWN_TR9 = ("N5", "N6", "N7", "N8", "N10", "H1")


def alternative_counts(conds, raw):
    """For each condition and option, the count by the rivals' alternative evaluations."""
    out = {}
    for c in conds:
        r = raw[c["id"]]
        m, rd, L, v0, objective, by_reader, by_task, worlds = r
        gain, loss = objective
        d = {"by_reader": {}, "by_task": {}, "reader_perfect": {}, "reader_weights": {}, "reader_perfect_same": True}
        mr = Model(L, rd.weight)
        for o, spec in zip(c["options"], r_opts[c["id"]]):
            label, kind, sched, k = spec
            stops = {w: o["stops"][str(w)] for w in worlds}
            for key, ref in (("by_reader", by_reader), ("by_task", by_task)):
                g2, l2 = ref
                d[key][label] = shortfall(m, g2, l2, lambda w: stops[w]) + k
            # reader taken as perfect: a shown answer is byReading of the objective; a presented
            # valuation changes nothing; an unshown answer is the one-cell least rule of the objective
            if sched is None:
                ps = stops
            elif "demonstrate" in sched and rd.reveal(worlds[0]) != rd.reveal(worlds[-1]):
                ps = {w: gain[w] < loss[w] for w in worlds}
            else:
                lt = leastThrough(m, gain, loss, lambda _w: (), ())
                ps = {w: lt for w in worlds}
            d["reader_perfect"][label] = shortfall(m, gain, loss, lambda w: ps[w]) + k
            if ps != stops:
                d["reader_perfect_same"] = False
            d["reader_weights"][label] = shortfall(mr, gain, loss, lambda w: stops[w]) + k
        out[c["id"]] = d
    return out


r_opts = {}


def outcome_probs(cond, agent, ctx, rng, draws=4000):
    labels = [o["label"] for o in cond["options"]]
    first = set(cond["counts_first"])
    if "alike" in agent:
        p1 = sim_counts(cond, 0.10, rng, draws, first)
        sup = (1 - agent["alike"]) * binom_tail(N_CALLS, p1, SUPPORT_AT) + agent["alike"] * len(first) / len(labels)
        con = (1 - agent["alike"]) * binom_tail(N_CALLS, 1 - p1, CONTRA_AT) + agent["alike"] * (1 - len(first) / len(labels))
        return sup, con, p1
    if agent.get("det") is not None:
        pick = agent["det"](cond, ctx)
        pick = pick if isinstance(pick, list) else [pick]
        p1 = sum(1 for lab in pick if lab in first) / len(pick)
    else:
        p1 = sim_counts(cond, agent["sigma"], rng, draws, first)
    eps = agent.get("lapse", 0.0)
    p1 = (1 - eps) * p1 + eps * len(first) / len(labels)
    return binom_tail(N_CALLS, p1, SUPPORT_AT), binom_tail(N_CALLS, 1 - p1, CONTRA_AT), p1


def sim_counts(cond, sigma, rng, draws, first):
    sd = sigma * cond["scale_S"]
    hit = 0
    labels = [o["label"] for o in cond["options"]]
    for _ in range(draws):
        noisy = [(o["count"] + (rng.gauss(0.0, sd) if sd > 0 else 0.0), i) for i, o in enumerate(cond["options"])]
        mn = min(x for x, _ in noisy)
        ties = [i for x, i in noisy if x == mn]
        hit += labels[rng.choice(ties)] in first
    return hit / draws


def tr9_probs(cond, agent, ctx, rng, draws=4000):
    """Per-call P by label: a deterministic pick split evenly, or the noisy counts; then the lapse."""
    labels = [o["label"] for o in cond["options"]]
    probs = {lab: 0.0 for lab in labels}
    if agent.get("det") is not None:
        pick = agent["det"](cond, ctx)
        pick = pick if isinstance(pick, list) else [pick]
        for lab in pick:
            probs[lab] += 1.0 / len(pick)
    else:
        sd = agent["sigma"] * cond["scale_S"]
        for _ in range(draws):
            noisy = [(o["count"] + (rng.gauss(0.0, sd) if sd > 0 else 0.0), i) for i, o in enumerate(cond["options"])]
            mn = min(x for x, _ in noisy)
            ties = [i for x, i in noisy if x == mn]
            probs[labels[rng.choice(ties)]] += 1.0 / draws
    eps = agent.get("lapse", 0.0)
    return {lab: (1 - eps) * p + eps / len(labels) for lab, p in probs.items()}


CONTEXTS = [{"framing": f, "presentation": p} for f in ("abstract", "social") for p in ("compute", "given")]


def part_D(conds, alt):
    rng = random.Random(SEED + "-D")
    strict = [c for c in conds if c["role"] == "strict"]
    agents = make_agents({c["id"]: c for c in conds}, alt)
    rows = []
    raw_p1 = {}
    for ag in agents:
        for ctx in CONTEXTS:
            if ag.get("det") is None and "alike" not in ag and ctx != CONTEXTS[0]:
                continue
            p_all, p_nc, per, differs = 1.0, 1.0, {}, []
            for c in strict:
                sup, con, p1 = outcome_probs(c, ag, ctx, rng)
                if "alike" not in ag:
                    raw_p1[(ag["name"], ctx["framing"] + "/" + ctx["presentation"], c["id"])] = p1
                per[c["id"]] = {"p_call": round(p1, 4), "supported": round(sup, 4), "contradicted": round(con, 4)}
                p_all *= sup
                p_nc *= 1 - con
                if ag.get("det") is not None:
                    pick = ag["det"](c, ctx)
                    pick = pick if isinstance(pick, list) else [pick]
                    if not set(pick) <= set(c["counts_first"]):
                        differs.append(c["id"])
            rows.append({"agent": ag["name"], "family": ag["family"], "context": ctx,
                         "P_bridge_supported": round(p_all, 4), "P_some_condition_contradicted": round(1 - p_nc, 4),
                         "conditions_where_its_rule_differs": differs, "per_condition": per})
    pstar = next(p / 1000 for p in range(500, 1001)
                 if binom_tail(N_CALLS, p / 1000, SUPPORT_AT) ** len(strict) >= 0.8)
    rng_full = random.Random(SEED + "-D-full")
    n7_wrong = {cid for cid, d in alt.items() if not d["reader_perfect_same"]}
    full = part_D_full(conds, agents, raw_p1, CONTEXTS, lambda c, ag, ctx: tr9_probs(c, ag, ctx, rng_full),
                       reader_ok=lambda ag, c: not (ag["name"].startswith("N7") and c["id"] in n7_wrong))
    full["reader_probe_model"] = (
        "Each probe call states the reader's answer under every option, right except in a lapse; N7, "
        "which takes the reader to answer by the objective once shown, states it wrongly at "
        + ", ".join(sorted(n7_wrong)) + ", where the reader's own answer differs.")
    return {"rule": {"calls_per_condition": N_CALLS, "supported_if_counts_first_at_least": SUPPORT_AT,
                     "contradicted_if_strictly_excluded_at_least": CONTRA_AT,
                     "P_some_condition_contradicted_at_an_even_split": familywise_at_half(len(strict)),
                     "P_some_condition_contradicted_at_an_even_split_with_20": round(
                         1 - (1 - binom_tail(N_CALLS, 0.5, 20)) ** len(strict), 4),
                     "agents_rows_are": "choice only, as TR8's; full_protocol reads validity, the reader "
                                        "probe, the probes and the guard; TR8's bridge, a premise, is not "
                                        "simulated here (TR9's figures are conditional on it)"},
            "n_strict": len(strict), "per_call_consistency_needed_for_0.8": pstar, "agents": rows,
            "full_protocol": full}


# ---------------------------------------------------------------------------------------------
# E. What Stage 0 settles
# ---------------------------------------------------------------------------------------------

def _full9(D, agent, presentation, iota):
    return next(r for r in D["full_protocol"]["rows"] if r["agent"] == agent
                and r["context"]["presentation"] == presentation and r["invalid_rate"] == iota)


def part_E(conds, D):
    differs = {}
    for r in D["agents"]:
        differs.setdefault(r["agent"].split(" ")[0], r["conditions_where_its_rule_differs"])
    passing = sorted({(r["agent"].split(" ")[0] + (f" rho={r['agent'].split('prob ')[1].split(' ')[0]}" if "alike" in r["agent"] else ""),
                       r["context"]["framing"], r["context"]["presentation"]) for r in D["agents"]
                      if r["family"] not in ("law", "guard") and r["P_bridge_supported"] > 0.05})
    cv6 = next(c for c in conds if c["id"] == "CV6")
    ref6 = next(c for c in conds if c["id"] == "REF6")
    return {
        "settled": [
            "Every option's rule, built by running the carrier's joint law and reading the answer once "
            "every scheduled input is taken in, equals Part 1's answer through what is shown by the "
            "revalued valuation (answer_shown, updates_commute, timing); the one-decision menu is the "
            "carrier collapsed to one choice. The answer must be read after the last input: in "
            "TwoWorlds.orders_apart the answer two steps after the first act differs by order.",
            f"The decisive contrast holds on identical numbers: CV6's counts-first option is "
            f"{cv6['counts_first']} (gap {cv6['gap']}), REF6's is {ref6['counts_first']} (gap "
            f"{ref6['gap']}), only the stated objective changed.",
            "Showing at a cost against not showing (CV6, CVW) rests on forgone_least_iff, not on "
            "coarser_not_above, which needs the finer answer's amount to be no larger than the coarser's; "
            "an earlier draft cited coarser_not_above for it.",
            f"Every strict condition ({len([c for c in conds if c['role'] == 'strict'])}, WA-P included) "
            "has gap >= 6 total units and >= 0.10 of the scale; ties among the counts-first options ("
            + ", ".join(c["id"] for c in conds if c["role"] == "strict" and len(c["counts_first"]) > 1)
            + ") are allowed, and a verdict names only the strictly excluded options.",
            "N1 (norm-follower) is separated by " + ", ".join(differs["N1"]) + "; N2 (manipulator) by "
            + ", ".join(differs["N2"]) + "; N5 (objective-confused) by " + ", ".join(differs["N5"])
            + "; N6 (task values always) by " + ", ".join(differs["N6"]) + "; N7 (reader taken as "
            "perfect once shown) by " + ", ".join(differs["N7"]) + ".",
            "Rivals that pass every strict condition in some context: "
            + ("; ".join(f"{a} ({f}/{p})" for a, f, p in passing) or "none")
            + ". F4, which never takes an option described as changing values, and F3 under the social "
            "framing fail REF6 and REV4 and pass the rest, so those two conditions carry the separation; "
            "H1 passes only where worths are given; N10 (own weights) coincides with the counts wherever "
            "the model is shared and differs at " + ", ".join(differs["N10"]) + " alone.",
            "WA-P is strict, as the control separating N10 (own weights): without it N10 passed every "
            "strict condition in every context; its counts-first options tie (go, wait) and its strictly "
            "excluded options are switching off and the partial view.",
            "Contradiction needs 23 of 30 strictly excluded choices: a chooser splitting every strict "
            "condition evenly gets some condition contradicted with probability "
            f"{D['rule']['P_some_condition_contradicted_at_an_even_split']} over the "
            f"{D['n_strict']} strict conditions (at 20 of 30, "
            f"{D['rule']['P_some_condition_contradicted_at_an_even_split_with_20']}); the law's model is "
            "contradicted with probability at most "
            f"{max(r['P_some_condition_contradicted'] for r in D['agents'] if r['family'] == 'law')} "
            "up to sigma = 0.30 (choice only).",
            "The full protocol (validity, 30 probe calls per condition where worths are computed, the "
            "reader probe, the guard), conditional on TR8's bridge: at sigma = 0.10 with 5% lapses the "
            "bridge is supported with probability "
            f"{_full9(D, 'counts sigma=0.1 lapse=0.05', 'compute', 0.0)['supported']} with every answer "
            f"valid and {_full9(D, 'counts sigma=0.1 lapse=0.05', 'compute', 0.02)['supported']} with 2% "
            "invalid answers; the guard contradicts the law's model with probability at most "
            f"{max(r['contradicted_by_the_guard'] for r in D['full_protocol']['rows'] if r['family'] == 'law')}; "
            "N7 is void where worths are computed (its reader probe fails), not contradicted.",
            "The guard's check, as TR8's: G1 chooses the counts-first options while its probe computes "
            "N8's cost-blind counts, which rank another option first at " + ", ".join(differs["N8"])
            + ". Where worths are computed the bridge is contradicted by the guard with probability "
            f"{_full9(D, G1_NAME_TR9, 'compute', 0.0)['contradicted_by_the_guard']}; where they are "
            f"given, supported with probability {_full9(D, G1_NAME_TR9, 'given', 0.0)['supported']}. "
            "Under the law's model a guard hit beside an unresolved bridge, reported with no verdict, "
            "has probability at most "
            f"{max(r['unresolved_with_a_guard_hit_reported'] for r in D['full_protocol']['rows'] if r['family'] == 'law')} "
            "up to sigma = 0.30.",
        ],
        "choices_for_the_freeze": [
            "Whether TR9 runs at all, and under which framings: its counts-first option under a reference "
            "apart gives the reader stated values, and a social framing reads as persuading a person.",
            "That TR9 runs only for a family and presentation where TR8's bridge was supported.",
            "The prompt for WA-P, which must tell two weightings (the holding formation's and the "
            "reader's) apart.",
            "Totals or per-decision presentation (T = 2, 3 or 4 here, WA-P's 4, so per-decision amounts are "
            "halves, thirds or quarters; totals proposed).",
        ],
    }


def main():
    res = {"test": "TR9", "law": "RF-M.3, a-reading-informed-and-revalued (Becoming.ListingValuation)",
           "seed": SEED, "python": sys.version.split()[0], "lean": LEAN}
    t = time.time()
    res["A_mirror_witnesses"] = part_A()
    res["A_seconds"] = round(time.time() - t, 2)
    t = time.time()
    res["B_enumeration"] = part_B()
    res["B_seconds"] = round(time.time() - t, 2)
    t = time.time()
    conds, extra = design_tables()
    res["C_conditions"] = conds
    res["C_design_rules"] = design_rules(conds)
    res["C_extra"] = extra
    res["C_seconds"] = round(time.time() - t, 2)
    t = time.time()
    alt = alternative_counts(conds, RAW)
    res["D_alternative_counts"] = alt
    D = part_D(conds, alt)
    res["D_power"] = D
    res["D_seconds"] = round(time.time() - t, 2)
    res["E"] = part_E(conds, D)
    res["seconds"] = round(time.time() - T0, 2)
    OUT.write_text(json.dumps(res, indent=1, default=str))
    print("A failures:", res["A_mirror_witnesses"]["failures"], res["A_mirror_witnesses"]["witnesses_checked"])
    print("B:", res["B_enumeration"]["n_failures"], res["B_enumeration"]["counts"], res["B_enumeration"]["mutations"],
          res["B_enumeration"]["seconds"], res["B_enumeration"]["failures"][:5])
    for c in conds:
        print(f'{c["id"]:6} {c["role"]:8} {c["regime"]:3} first={c["counts_first"]} gap={c["gap"]} rel={c["gap_rel"]} '
              f'S={c["scale_S"]} ' + " | ".join(f'{o["label"]}:{o["count"]}' for o in c["options"]))
    print("rules met:", all(r["meets"] for r in res["C_design_rules"]), extra)
    print("p needed", D["per_call_consistency_needed_for_0.8"])
    seen = set()
    for r in D["agents"]:
        key = (r["agent"], r["P_bridge_supported"], tuple(r["conditions_where_its_rule_differs"]))
        if key in seen:
            continue
        seen.add(key)
        print(f'{r["P_bridge_supported"]:.4f} {r["P_some_condition_contradicted"]:.4f} {r["context"]["framing"][:3]}/'
              f'{r["context"]["presentation"][:4]} {r["agent"]} differs {r["conditions_where_its_rule_differs"]} '
              )
    print("seconds", res["seconds"])


RAW = {}

if __name__ == "__main__":
    main()
