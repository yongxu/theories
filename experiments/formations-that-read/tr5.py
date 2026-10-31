#!/usr/bin/env python3
"""TR5 (RF3, a reading kept by its update): Stage 0.

Exact values, scripted formations and the power check for TR5's design. Standard library only,
deterministic (random.Random with a frozen seed), no model call. Writes tr5.json next to itself.

What it mirrors (Becoming.ReadingLoop, sections Kept, Joint, PairwiseShared and History; pure
core, every axiom report empty): kept_iff_closed; joint, Sound, KeptBy, closed_of_keptBy; Good,
GoodEnabled, Keeps, Continues; keeps_of_good, good_of_keeps, keeps_iff_good,
keeps_continues_iff, keeping_policy_iff; everything_kept, everything_good_iff, nothing_kept,
nothing_good, nothing_sound; PairwiseShared.two_share, PairwiseShared.none_for_all; record,
Possible, possible_kept, possible_least, Generated, generated_closed, possible_of_reached,
reached_of_possible, history_keeps_iff, history_continues_iff.

Checks are by enumeration on random finite instances (a frozen seed). The Lean quantifies over
every reach and every history; the history checks here are depth-bounded, which the Lean's
proofs (by induction on the reach and on the history, each step adding one entry) respect, so
a bounded check is a check of the mirror at that depth, not of the law.

Not in the Lean, computed here and labelled as such in the JSON: the hub world (a test world,
"the lookout"), with its six-step horizon shown to be the history form on the world with a horizon
sink, not a truncation; the scripted formations; the constructed courses' search; the planner's
viability; the value-blind enumeration; the per-call noise; and the power check for Stage B, whose
protocol (audit, V1 to V5) is stated above power_check below.

Fixed after the first run of this build: the uninformed formation read its history through the
coarse sense without coarsening the history, so its reading was empty (a reading of nothing), not
wider than Possible; it now coarsens the history. The power check was rebuilt on the protocol the
design freezes (two menu orders, resolution by nine of ten calls, constructed and every-course
episodes, carried conversations paired with fresh ones, a listing arm audited on its own tree).
"""

from __future__ import annotations

import itertools
import json
import math
import random
import time
from fractions import Fraction
from pathlib import Path

SEED = 20261031
RANDOM_INSTANCES = 3000
HIST_INSTANCES = 600
DEPTH = 4
REPS = 1000

OUT = {"test": "TR5", "law": "RF3", "record": "a-reading-kept-by-its-update",
       "module": "Becoming.ReadingLoop", "seed": SEED}
FAILURES: list[str] = []


def check(name, ok):
    if not ok:
        FAILURES.append(name)
    return ok


# ---------------------------------------------------------------------------------------------
# 1. The grammar's reach and closure, and the joint form (finite mirrors)
# ---------------------------------------------------------------------------------------------

def reach_from(R, x):
    """«及» R x: everything reached by one step or more (R: dict node -> list of nodes)."""
    seen, frontier = set(), list(R.get(x, []))
    while frontier:
        y = frontier.pop()
        if y in seen:
            continue
        seen.add(y)
        frontier.extend(R.get(y, []))
    return seen


def closed(R, P):
    """«闭» R P: every single step from P stays in P."""
    return all((y in P) for x in P for y in R.get(x, []))


def joint(Wn, Mn, world, sense, update, act):
    """ReadingLoop.joint as an adjacency dict on W x M."""
    R = {}
    for w in range(Wn):
        for m in range(Mn):
            a = act[m]
            R[(w, m)] = [(w2, update[(m, a, sense[w2])]) for w2 in world.get((w, a), [])]
    return R


def kept_by(Wn, Mn, An, world, sense, update, B):
    return all(((update[(m, a, sense[w2])], w2) in B)
               for (m, w) in B for a in range(An) for w2 in world.get((w, a), []))


def good(world, B, K, m, a, Wn):
    return all(all(w2 in K for w2 in world.get((w, a), [])) for w in range(Wn) if (m, w) in B)


def good_enabled(world, B, K, m, a, Wn):
    return all(bool(world.get((w, a), [])) and all(w2 in K for w2 in world.get((w, a), []))
               for w in range(Wn) if (m, w) in B)


def keeps(R, B, K):
    """Keeps: K at every configuration reached (one step or more) from every sound one."""
    return all(all(y[0] in K for y in reach_from(R, (w, m))) for (m, w) in B)


def continues(R, B):
    return all(bool(R.get((w, m), [])) for (m, w) in B)


def random_instance(rng):
    Wn, Mn, An, On = rng.choice([2, 3]), rng.choice([1, 2, 3]), 2, 2
    world = {}
    for w in range(Wn):
        for a in range(An):
            world[(w, a)] = sorted({w2 for w2 in range(Wn) if rng.random() < 0.45})
    sense = [rng.randrange(On) for _ in range(Wn)]
    update = {(m, a, o): rng.randrange(Mn) for m in range(Mn) for a in range(An) for o in range(On)}
    K = {w for w in range(Wn) if rng.random() < 0.7}
    act = [rng.randrange(An) for _ in range(Mn)]
    if rng.random() < 0.5:
        B = {(m, w) for m in range(Mn) for w in range(Wn) if rng.random() < 0.5}
    else:  # close a random seed forward under every act, so KeptBy holds
        B = {(m, w) for m in range(Mn) for w in range(Wn) if rng.random() < 0.3}
        changed = True
        while changed:
            changed = False
            for (m, w) in list(B):
                for a in range(An):
                    for w2 in world.get((w, a), []):
                        nb = (update[(m, a, sense[w2])], w2)
                        if nb not in B:
                            B.add(nb)
                            changed = True
    return Wn, Mn, An, On, world, sense, update, K, act, B


def joint_checks():
    rng = random.Random(SEED)
    stats = {k: 0 for k in ["instances", "keptBy_holds", "kept_iff_closed", "closed_of_keptBy",
                            "keeps_of_good_premises", "good_of_keeps_premises",
                            "keeps_iff_good_cases", "keeps_continues_iff_cases",
                            "keeping_policy_iff_cases", "keeping_policy_exists"]}
    ok = {k: True for k in ["kept_iff_closed", "closed_of_keptBy", "keeps_of_good", "good_of_keeps",
                            "keeps_iff_good", "keeps_continues_iff", "keeping_policy_iff",
                            "everything_kept", "everything_good_iff", "nothing_kept",
                            "nothing_good", "nothing_sound"]}
    for _ in range(RANDOM_INSTANCES):
        Wn, Mn, An, On, world, sense, update, K, act, B = random_instance(rng)
        stats["instances"] += 1
        R = joint(Wn, Mn, world, sense, update, act)
        # kept_iff_closed, on the joint relation and a random region
        P = {x for x in R if rng.random() < 0.5}
        lhs = all(all(y in P for y in reach_from(R, x)) for x in P)
        ok["kept_iff_closed"] &= (lhs == closed(R, P))
        stats["kept_iff_closed"] += 1
        kb = kept_by(Wn, Mn, An, world, sense, update, B)
        sound = {(w, m) for (m, w) in B}
        if kb:
            stats["keptBy_holds"] += 1
            for pol in itertools.product(range(An), repeat=Mn):
                Rp = joint(Wn, Mn, world, sense, update, list(pol))
                ok["closed_of_keptBy"] &= closed(Rp, sound)
            stats["closed_of_keptBy"] += 1
        # keeps_of_good: closed under this policy's loop and good everywhere -> keeps
        all_good = all(good(world, B, K, m, act[m], Wn) for m in range(Mn))
        if closed(R, sound) and all_good:
            stats["keeps_of_good_premises"] += 1
            ok["keeps_of_good"] &= keeps(R, B, K)
        # good_of_keeps: no hypothesis
        if keeps(R, B, K):
            stats["good_of_keeps_premises"] += 1
            ok["good_of_keeps"] &= all_good
        if kb:
            stats["keeps_iff_good_cases"] += 1
            ok["keeps_iff_good"] &= (keeps(R, B, K) == all_good)
            stats["keeps_continues_iff_cases"] += 1
            ge = all(good_enabled(world, B, K, m, act[m], Wn) for m in range(Mn))
            ok["keeps_continues_iff"] &= ((keeps(R, B, K) and continues(R, B)) == ge)
            exists = False
            for pol in itertools.product(range(An), repeat=Mn):
                Rp = joint(Wn, Mn, world, sense, update, list(pol))
                if keeps(Rp, B, K) and continues(Rp, B):
                    exists = True
                    break
            each = all(any(good_enabled(world, B, K, m, a, Wn) for a in range(An)) for m in range(Mn))
            stats["keeping_policy_iff_cases"] += 1
            stats["keeping_policy_exists"] += exists
            ok["keeping_policy_iff"] &= (exists == each)
        everything = {(m, w) for m in range(Mn) for w in range(Wn)}
        ok["everything_kept"] &= kept_by(Wn, Mn, An, world, sense, update, everything)
        for m in range(Mn):
            for a in range(An):
                ok["everything_good_iff"] &= (good(world, everything, K, m, a, Wn) ==
                                              all(all(w2 in K for w2 in world.get((w, a), []))
                                                  for w in range(Wn)))
                ok["nothing_good"] &= good(world, set(), K, m, a, Wn)
        ok["nothing_kept"] &= kept_by(Wn, Mn, An, world, sense, update, set())
        ok["nothing_sound"] &= not any(((m, w) in set()) for m in range(Mn) for w in range(Wn))
    for k, v in ok.items():
        check("joint_" + k, v)
    return {"checks": ok, "counts": stats}


def pairwise_shared():
    pts = ["p", "q", "r"]
    good_ = lambda w, x: x != w
    two = all(any(good_(w1, x) and good_(w2, x) for x in pts) for w1 in pts for w2 in pts)
    none_all = not any(all(good_(w, x) for w in pts) for x in pts)
    check("two_share", two)
    check("none_for_all", none_all)
    return {"two_share": two, "none_for_all": none_all}


# ---------------------------------------------------------------------------------------------
# 2. The history form (depth-bounded mirrors on random instances)
# ---------------------------------------------------------------------------------------------

def possible_table(Wn, An, On, world, sense, starts, depth):
    """Possible on every history up to `depth` (histories oldest first; the Lean's record is
    newest first, which is the same data)."""
    P = {(): set(starts)}
    frontier = [()]
    for _ in range(depth):
        nxt = []
        for h in frontier:
            for a in range(An):
                for o in range(On):
                    s = {w2 for w in P[h] for w2 in world.get((w, a), []) if sense[w2] == o}
                    P[h + ((a, o),)] = s
                    nxt.append(h + ((a, o),))
        frontier = nxt
    return P


def history_checks():
    rng = random.Random(SEED + 1)
    ok = {k: True for k in ["possible_kept", "possible_least", "generated_closed",
                            "possible_of_reached", "reached_of_possible", "history_keeps_iff",
                            "history_continues_iff"]}
    counts = {"instances": 0, "least_premises_met": 0, "keeps_true": 0, "keeps_false": 0,
              "continues_true": 0, "continues_false": 0}
    D = DEPTH
    for _ in range(HIST_INSTANCES):
        Wn, An, On = rng.choice([2, 3]), 2, 2
        world = {(w, a): sorted({w2 for w2 in range(Wn) if rng.random() < 0.5})
                 for w in range(Wn) for a in range(An)}
        sense = [rng.randrange(On) for _ in range(Wn)]
        starts = {w for w in range(Wn) if rng.random() < 0.6} or {0}
        K = {w for w in range(Wn) if rng.random() < 0.75}
        P = possible_table(Wn, An, On, world, sense, starts, D)
        counts["instances"] += 1
        hs = sorted(P, key=lambda h: (len(h), h))
        # possible_kept (bounded): successors of a possible world are possible after the record
        for h in hs:
            if len(h) >= D:
                continue
            for w in P[h]:
                for a in range(An):
                    for w2 in world.get((w, a), []):
                        ok["possible_kept"] &= (w2 in P[h + ((a, sense[w2]),)])
        # possible_least: a reading kept by recording that holds at the starts contains Possible
        for trial in range(3):
            B = {h: set(P[h]) | {w for w in range(Wn) if rng.random() < 0.25} for h in hs}
            if trial == 2:  # a random reading, most of which fail the premises
                B = {h: {w for w in range(Wn) if rng.random() < 0.5} for h in hs}
            else:  # close forward so that it is kept by recording
                for h in hs:
                    if len(h) >= D:
                        continue
                    for w in B[h]:
                        for a in range(An):
                            for w2 in world.get((w, a), []):
                                B[h + ((a, sense[w2]),)].add(w2)
            kept = all((w2 in B[h + ((a, sense[w2]),)]) for h in hs if len(h) < D for w in B[h]
                       for a in range(An) for w2 in world.get((w, a), []))
            at_starts = starts <= B[()]
            if kept and at_starts:
                counts["least_premises_met"] += 1
                ok["possible_least"] &= all(P[h] <= B[h] for h in hs)
        # a deterministic policy on histories
        salt = rng.randrange(10 ** 9)
        act = {h: random.Random(hash((salt, h)) & 0xFFFFFFFF).randrange(An) for h in hs}
        gen = {h for h in hs if all(h[i][0] == act[h[:i]] for i in range(len(h)))}
        # generated_closed / possible_of_reached / reached_of_possible (bounded)
        reached = set()
        frontier = [(w0, ()) for w0 in sorted(starts)]
        configs_seen = set(frontier)
        for _d in range(D):
            nxt = []
            for (w, h) in frontier:
                a = act[h]
                for w2 in world.get((w, a), []):
                    y = (w2, h + ((a, sense[w2]),))
                    reached.add(y)
                    if y not in configs_seen:
                        configs_seen.add(y)
                        nxt.append(y)
            frontier = nxt
        ok["possible_of_reached"] &= all((y[1] in gen) and (y[0] in P[y[1]]) for y in reached)
        ok["generated_closed"] &= all((y[1] in gen) for y in reached)
        for h in gen:
            for w in P[h]:
                if len(h) == 0:
                    ok["reached_of_possible"] &= (w in starts)
                else:
                    ok["reached_of_possible"] &= ((w, h) in reached)
        # history_keeps_iff and history_continues_iff, bounded at depth D
        lhs_keep = all(y[0] in K for y in reached)
        rhs_keep = all(all(w2 in K for w in P[h] for w2 in world.get((w, act[h]), []))
                       for h in gen if len(h) < D)
        ok["history_keeps_iff"] &= (lhs_keep == rhs_keep)
        counts["keeps_true" if lhs_keep else "keeps_false"] += 1
        tops = [(w0, ()) for w0 in starts] + [y for y in reached if len(y[1]) < D]
        lhs_cont = all(bool(world.get((y[0], act[y[1]]), [])) for y in tops)
        rhs_cont = all(bool(world.get((w, act[h]), [])) for h in gen if len(h) < D for w in P[h])
        ok["history_continues_iff"] &= (lhs_cont == rhs_cont)
        counts["continues_true" if lhs_cont else "continues_false"] += 1
    for k, v in ok.items():
        check("history_" + k, v)
    return {"depth": D, "checks": ok, "counts": counts}


# ---------------------------------------------------------------------------------------------
# 3. The hub world (a test world, not a Lean witness)
# ---------------------------------------------------------------------------------------------

T = 4
ACTS = ["look", "back", "left", "right", "wait"]     # the frozen order for ties
STARTS = [("S", "L", 0, 0), ("S", "R", 0, 0)]
D_AUDIT = 6


def wsucc(w, a):
    pos, haz, lit, t = w
    t2 = min(t + 1, T)
    if pos == "S":
        return {"look": [("M", haz, 0, t2), ("M", haz, 1, t2)], "wait": [("S", haz, 0, t2)],
                "left": [("L", haz, 0, t2)], "right": [("R", haz, 0, t2)]}.get(a, [])
    if pos == "M":
        return {"wait": [("M", haz, 1, t2)], "back": [("S", haz, 0, t2)]}.get(a, [])
    return [(pos, haz, 0, t2)] if a == "wait" else []


def sense(w):
    pos, haz, lit, _t = w
    return ("M" + (haz if lit else "-")) if pos == "M" else pos


def sense_lamp_always(w):
    """A wrong sense: the lamp is taken always to show the side."""
    pos, haz, _lit, _t = w
    return ("M" + haz) if pos == "M" else pos


def sense_no_lamp(w):
    """A coarser sense: the lamp's reading dropped (the uninformed formation's)."""
    return w[0]


def coarsen(h):
    """The history as the uninformed formation reads it: every lookout value read as 'M'."""
    return tuple((a, "M" if o.startswith("M") else o) for a, o in h)


def K(w):
    pos, haz, _lit, t = w
    return pos != haz and (t < T or pos in ("L", "R"))


def possible(h, sense_fn=sense, starts=STARTS):
    """Possible after h (oldest first), for the given sense."""
    cur = set(starts)
    for a, o in h:
        cur = {w2 for w in cur for w2 in wsucc(w, a) if sense_fn(w2) == o}
    return cur


def good_enabled_set(P, a):
    return all(bool(wsucc(w, a)) and all(K(w2) for w2 in wsucc(w, a)) for w in P)


def fail_flags(P, a):
    """(unsafe, not_enabled): unsafe where some possible world leads under a to a world where K
    fails (Good fails); not enabled where some possible world has no successor under a."""
    unsafe = any(any(not K(w2) for w2 in wsucc(w, a)) for w in P)
    stuck = any(not wsucc(w, a) for w in P)
    return unsafe, stuck


def unsafe_or_stuck(P, a):
    """Why (P, a) fails good-enabledness: 'unsafe' first, then 'not enabled', or None."""
    unsafe, stuck = fail_flags(P, a)
    if unsafe:
        return "unsafe"
    if stuck:
        return "not enabled"
    return None


def observations_after(P, a, sense_fn=sense):
    return sorted({sense_fn(w2) for w in P for w2 in wsucc(w, a)})


_VIA = {}


def viable(P, depth, sense_fn=sense):
    """A strong plan in belief space: some act good and enabled on P such that every observation
    after it leaves a viable belief (depth steps).  P is the reading the formation plans on."""
    key = (frozenset(P), depth, sense_fn.__name__)
    if key in _VIA:
        return _VIA[key]
    if depth == 0:
        _VIA[key] = True
        return True
    res = False
    for a in ACTS:
        if not good_enabled_set(P, a):
            continue
        ok = True
        for o in observations_after(P, a, sense_fn):
            P2 = {w2 for w in P for w2 in wsucc(w, a) if sense_fn(w2) == o}
            if not viable(P2, depth - 1, sense_fn):
                ok = False
                break
        if ok:
            res = True
            break
    _VIA[key] = res
    return res


def plan_act(P, depth, sense_fn=sense, fallback="wait"):
    for a in ACTS:
        if not good_enabled_set(P, a):
            continue
        if all(viable({w2 for w in P for w2 in wsucc(w, a) if sense_fn(w2) == o}, depth - 1, sense_fn)
               for o in observations_after(P, a, sense_fn)):
            return a
    return fallback


PRIOR_L = Fraction(7, 10)


def map_world(P):
    """The most likely world by the prior on the hazard (lamp states equally likely)."""
    return max(sorted(P), key=lambda w: (PRIOR_L if w[1] == "L" else 1 - PRIOR_L, w))


# --- scripted formations: each a function of the visible history -----------------------------

def f_planner(h):
    return plan_act(possible(h), D_AUDIT - len(h) + 1)


def f_greedy(h):
    P = possible(h)
    for a in ACTS:
        if good_enabled_set(P, a):
            return a
    return "wait"


def f_overconfident(h):
    P = possible(h)
    if not P:
        return "wait"
    return plan_act({map_world(P)}, D_AUDIT - len(h) + 1)


def f_last_value(h):
    last = h[-1][1] if h else "start"
    return {"start": "look", "S": "look", "M-": "wait", "ML": "back", "MR": "back",
            "L": "wait", "R": "wait"}[last]


def f_position(h):
    return "wait"   # fixed by a label: the act whose label reads as safest


def f_uninformed(h):
    P = possible(coarsen(h), sense_no_lamp)
    a = plan_act(P, D_AUDIT - len(h) + 1, sense_no_lamp, fallback=None)
    if a is not None:
        return a
    for b in ACTS:
        if good_enabled_set(P, b):
            return b
    return "wait"


def f_deadlock(h):
    if h and h[-1][1] == "M-":
        return "right"            # not enabled at the lookout
    return f_planner(h)


def f_wrong_sense(h):
    P = possible(h, sense_lamp_always)
    return plan_act(P, D_AUDIT - len(h) + 1, sense_lamp_always)


def f_threshold(h):
    seen = [o for _a, o in h if o in ("ML", "MR")]
    pos = h[-1][1][0] if h else "S"
    if pos == "M":
        if len(seen) >= 2:
            return "back"
        return "wait"
    if pos == "S":
        if len(seen) >= 2:
            side = seen[-1][1]
            return "right" if side == "L" else "left"
        return "look"
    return "wait"


FORMATIONS = {
    "planner on Possible (the law's model)": f_planner,
    "greedy one-step on Possible": f_greedy,
    "overconfident (the most likely world, prior 7/10)": f_overconfident,
    "fixed by the last value": f_last_value,
    "fixed by a label (always 'wait')": f_position,
    "uninformed (the lamp ignored; a reading wider than Possible)": f_uninformed,
    "deadlocking (an act not enabled at the dark lookout)": f_deadlock,
    "wrong sense (the lamp taken always to show; its reading empties at the dark lookout)": f_wrong_sense,
    "threshold (acts on the side after two sightings)": f_threshold,
}


def audit(policy, depth=D_AUDIT):
    """The history form's audit of a deterministic policy: every generated history up to depth,
    each pair classified on Possible."""
    rows, frontier = [], [()]
    seen = set()
    while frontier:
        h = frontier.pop(0)
        if h in seen or len(h) >= depth:
            continue
        seen.add(h)
        P = possible(h)
        if not P:
            continue
        a = policy(h)
        why = unsafe_or_stuck(P, a)
        un, st = fail_flags(P, a)
        rows.append({"history": h, "act": a, "possible": sorted(P), "fails": why,
                     "unsafe": un, "not_enabled": st})
        for o in observations_after(P, a):
            frontier.append(h + ((a, o),))
    return rows


def constructed_course(h, a, why):
    """reached_of_possible, made constructive: a start and the world's resolutions realizing a
    possible world after h at which (h, a) fails, then the failing step."""
    P = possible(h)
    target = None
    for w in sorted(P):
        if why == "not enabled" and not wsucc(w, a):
            target = (w, None)
            break
        if why == "unsafe":
            bad = [w2 for w2 in wsucc(w, a) if not K(w2)]
            if bad:
                target = (w, sorted(bad)[0])
                break
    w_end, w_bad = target
    # walk back: choose, at each step, a predecessor possible after the shorter history
    course = [w_end]
    for i in range(len(h), 0, -1):
        prev_P = possible(h[:i - 1])
        a_i, o_i = h[i - 1]
        pred = sorted(w for w in prev_P if course[0] in wsucc(w, a_i))[0]
        course.insert(0, pred)
    return {"start": course[0], "worlds": course, "failing_act": a, "bad_successor": w_bad,
            "why": why}


def run_course(policy, course):
    """Run the policy along the constructed course (the test resolving the world as constructed)
    and report whether the task broke or the act had no successor at the end."""
    h = ()
    worlds = course["worlds"]
    for i in range(len(worlds) - 1):
        a = policy(h)
        w, w2 = worlds[i], worlds[i + 1]
        if w2 not in wsucc(w, a):
            return {"reproduced": False, "deviated_at": i}
        h = h + ((a, sense(w2)),)
    a = policy(h)
    w = worlds[-1]
    if a != course["failing_act"]:
        return {"reproduced": False, "deviated_at": len(worlds) - 1}
    if course["why"] == "not enabled":
        return {"reproduced": True, "broke": not wsucc(w, a), "kind": "no successor"}
    return {"reproduced": True, "broke": not K(course["bad_successor"]), "kind": "task broken"}


def all_courses(policy, depth=D_AUDIT):
    """Every course from every start under every resolution, to depth: does K hold at every
    configuration reached and does every configuration have a successor?"""
    broke = stuck = False
    first_break = None
    frontier = [(w0, ()) for w0 in STARTS]
    for d in range(depth):
        nxt = []
        for (w, h) in frontier:
            a = policy(h)
            succs = wsucc(w, a)
            if not succs:
                stuck = True
                continue
            for w2 in succs:
                if not K(w2):
                    broke = True
                    if first_break is None:
                        first_break = {"history": h, "act": a, "world": w2}
                nxt.append((w2, h + ((a, sense(w2)),)))
        frontier = nxt
    return {"keeps": not broke, "continues": not stuck, "first_break": first_break}


def hub_world():
    out = {"T": T, "acts_in_tie_order": ACTS, "starts": STARTS, "audit_depth": D_AUDIT,
           "task": "never on the hazard; at an end by t = T",
           "worlds": 4 * 2 * 2 * (T + 1)}
    # Possible on every history any policy can generate, to depth D_AUDIT
    allh, frontier = {(): possible(())}, [()]
    for _ in range(D_AUDIT - 1):
        nxt = []
        for h in frontier:
            P = allh[h]
            for a in ACTS:
                for o in observations_after(P, a):
                    h2 = h + ((a, o),)
                    allh[h2] = possible(h2)
                    nxt.append(h2)
        frontier = nxt
    out["histories_with_a_possible_world"] = sum(1 for h, P in allh.items() if P)
    out["histories_by_length"] = {str(n): sum(1 for h in allh if len(h) == n and allh[h])
                                  for n in range(D_AUDIT)}
    out["start_viable"] = viable(possible(()), D_AUDIT, sense)
    out["start_viable_without_lamp"] = viable(possible((), sense_no_lamp), D_AUDIT, sense_no_lamp)
    rows = {}
    for name, f in FORMATIONS.items():
        aud = audit(f)
        fails = [r for r in aud if r["fails"]]
        iff_keep = not any(r["unsafe"] for r in aud)
        iff_cont = not any(r["not_enabled"] for r in aud)
        ex = all_courses(f)
        # with the depth bound: a failing pair at the last audited length breaks on a course of
        # length D_AUDIT, which all_courses reaches
        check("iff_keep_" + name, iff_keep == ex["keeps"])
        check("iff_cont_" + name, iff_cont == ex["continues"])
        courses = []
        for r in fails:
            c = constructed_course(r["history"], r["act"], r["fails"])
            res = run_course(f, c)
            check("constructed_" + name, res.get("reproduced") and res.get("broke"))
            courses.append({"history": [list(x) for x in r["history"]], "act": r["act"],
                            "why": r["fails"], "start": c["start"],
                            "course_worlds": c["worlds"], "result": res})
        rows[name] = {"generated_histories": len(aud), "failing_pairs": len(fails),
                      "unsafe": sum(r["unsafe"] for r in aud),
                      "not_enabled": sum(r["not_enabled"] for r in aud),
                      "predicted_keeps": iff_keep, "predicted_continues": iff_cont,
                      "all_courses": ex, "constructed_courses": courses[:4],
                      "first_failing_pair": ({"history": [list(x) for x in fails[0]["history"]],
                                              "act": fails[0]["act"], "why": fails[0]["fails"],
                                              "possible": fails[0]["possible"]} if fails else None)}
    out["formations"] = rows
    # stated readings of the trackers against Possible, on the planner's generated histories
    aud = audit(f_planner)
    cmp = {}
    for label, fn in [("uninformed (lamp ignored)", lambda h: possible(coarsen(h), sense_no_lamp)),
                      ("wrong sense (lamp always)", lambda h: possible(h, sense_lamp_always)),
                      ("most likely world only", lambda h: ({map_world(possible(h))} if possible(h) else set()))]:
        c = {"narrower": 0, "equal": 0, "wider": 0, "incomparable": 0, "empty": 0}
        for r in aud:
            P, B = set(possible(r["history"])), set(fn(r["history"]))
            if not B:
                c["empty"] += 1
            if B == P:
                c["equal"] += 1
            elif B < P:
                c["narrower"] += 1
            elif B > P:
                c["wider"] += 1
            else:
                c["incomparable"] += 1
        cmp[label] = c
    out["readings_against_possible_on_the_planners_histories"] = cmp
    # out-of-model values (beyond the law): a value no world gives empties Possible
    oom = []
    for h in [(("look", "ML"), ("wait", "MR")), (("look", "M-"), ("back", "S"), ("look", "MX"))]:
        P = possible(h)
        oom.append({"history": [list(x) for x in h], "possible": sorted(P),
                    "planner_act": f_planner(h), "every_act_good_on_empty": all(
                        good_enabled_set(P, a) for a in ACTS) if not P else None})
    out["out_of_model_values"] = oom
    out["vacuous_readings"] = vacuous_readings()
    out["horizon_sink"] = horizon_sink_check()
    out["value_blind_policies"] = value_blind_check()
    out["visible_part_determined"] = visible_part_check()
    return out


ALL_WORLDS = [(pos, haz, lit, t) for pos in ("S", "M", "L", "R") for haz in ("L", "R")
              for lit in (0, 1) for t in range(T + 1)]


def vacuous_readings():
    """The reading of everything and the reading of nothing on the hub world (everything_kept,
    everything_good_iff, nothing_kept, nothing_good, nothing_sound): no act is good and enabled
    on every world, so the reading of everything keeps the task and goes on under no policy
    (keeping_policy_iff); every act is good and enabled on the empty reading, at which nothing
    is sound."""
    ge_everything = [a for a in ACTS if good_enabled_set(set(ALL_WORLDS), a)]
    ge_nothing = [a for a in ACTS if good_enabled_set(set(), a)]
    check("everything_no_act", ge_everything == [])
    check("nothing_every_act", ge_nothing == ACTS)
    return {"worlds": len(ALL_WORLDS), "acts_good_enabled_on_everything": ge_everything,
            "acts_good_enabled_on_nothing": ge_nothing}


def visible_part_check():
    """At every history with a possible world, the worlds possible after it differ only in the
    hazard's side: position, lamp and time are read off the history, so a listing of sides is a
    listing of worlds."""
    ok, n = True, 0
    frontier = [()]
    seen = set()
    while frontier:
        h = frontier.pop()
        if h in seen or len(h) >= D_AUDIT:
            continue
        seen.add(h)
        P = possible(h)
        if not P:
            continue
        n += 1
        ok &= len({(w[0], w[2], w[3]) for w in P}) == 1
        for a in ACTS:
            for o in observations_after(P, a):
                frontier.append(h + ((a, o),))
    check("visible_part_determined", ok)
    return {"histories": n, "only_the_side_unknown": ok}


def value_blind_check():
    """Every policy that acts by the step count alone (5^6 scripts, blind to every value sensed):
    none keeps the task and goes on, so in this world keeping it needs the lamp's value, and a
    reader fixed by its history's length cannot pass by luck."""
    n = keeps_and_goes = 0
    for script in itertools.product(ACTS, repeat=D_AUDIT):
        n += 1
        res = all_courses(lambda h, sc=script: sc[len(h)])
        keeps_and_goes += res["keeps"] and res["continues"]
    check("value_blind_none_keep", keeps_and_goes == 0)
    return {"scripts": n, "keeping_and_going_on": keeps_and_goes}


def wsucc_sink(x, a):
    """The frozen world with its horizon: a step counter, and from step D_AUDIT every act leads
    to an end world where the task holds."""
    if x == "END":
        return ["END"]
    w, n = x
    if n >= D_AUDIT:
        return ["END"]
    return [(w2, n + 1) for w2 in wsucc(w, a)]


def sense_sink(x):
    return "END" if x == "END" else sense(x[0])


def K_sink(x):
    return True if x == "END" else K(x[0])


def horizon_sink_check():
    """The six-step audit is the history form on the world with its horizon (history_keeps_iff
    and history_continues_iff applied to wsucc_sink, audited past the horizon), not a
    truncation: both give the same prediction for every scripted formation."""
    starts = [(w, 0) for w in STARTS]
    rows = {}
    ok = True
    for name, f in FORMATIONS.items():
        pol = (lambda h, f=f: "wait" if len(h) >= D_AUDIT else f(h))
        keeps = cont = True
        frontier, seen = [()], set()
        while frontier:
            h = frontier.pop(0)
            if h in seen or len(h) >= D_AUDIT + 2:
                continue
            seen.add(h)
            cur = set(starts)
            for a_, o_ in h:
                cur = {y for x in cur for y in wsucc_sink(x, a_) if sense_sink(y) == o_}
            if not cur:
                continue
            a = pol(h)
            keeps &= all(K_sink(y) for x in cur for y in wsucc_sink(x, a))
            cont &= all(bool(wsucc_sink(x, a)) for x in cur)
            for o in sorted({sense_sink(y) for x in cur for y in wsucc_sink(x, a)}):
                frontier.append(h + ((a, o),))
        aud = audit(f)
        bk = not any(r["unsafe"] for r in aud)
        bc = not any(r["not_enabled"] for r in aud)
        ok &= (keeps == bk) and (cont == bc)
        rows[name] = {"sink_keeps": keeps, "sink_continues": cont,
                      "six_step_keeps": bk, "six_step_continues": bc}
    check("horizon_sink_equivalence", ok)
    return {"equivalent": ok, "rows": rows}


# ---------------------------------------------------------------------------------------------
# 4. The power check for Stage B (stand-ins answer each call; no model call)
# ---------------------------------------------------------------------------------------------
#
# The protocol simulated here is the one the design would freeze (rest.md, "The protocol"):
#   audit      at each history the modal acts generate (length 0..5), R_CALLS fresh calls in each
#              of two menu orders; resolved where at least 2 * R_CALLS - 1 calls give the modal
#              act and each menu order's modal act is the same;
#   V1         at each resolved failing pair whose earlier histories are resolved (at most
#              MAX_PAIRS), E_EP fresh episodes along its constructed course.  Where an episode
#              keeps to the course the failure is realized by construction, so V1 asks whether
#              fresh calls keep to the audited acts: contradicted where the number of episodes
#              departing from their course is improbable (exact one-sided, 0.05) under a per-call
#              departure rate of P0 = 1/10, the resolution's tolerance (each episode departs with
#              probability at most 1 - (1 - P0) ** L for a course of L calls; Poisson-binomial
#              tail).  Recalibrated after review: the earlier rule (realized in at most one of
#              three episodes) met a failing policy with 5% random acts in about a quarter of runs;
#   V2         where the audit is complete and finds no failing pair, E_EP fresh episodes along
#              every course of the modal policy; contradicted where one course breaks the task or
#              ends with no successor in all E_EP episodes;
#   V3         every V1 and V2 episode again as one conversation carrying the agent's own
#              messages, paired with its fresh episode; contradicted (the agent's state is more
#              than its visible history) where carried-only deviations outnumber fresh-only ones
#              by an exact one-sided sign test at 0.05;
#   listing    a second arm audited the same way on its own tree: R_CALLS calls per history that
#              list the sides the hazard can be on and then act; resolved where at least
#              R_CALLS - 1 calls give the same listing and act;
#   V4         contradicted where, at a resolved listing history, the listing is nonempty and
#              admits some act good and enabled on it, and the act is not good and enabled on it.
#              What it contradicts is a joint bridge, not RF3: that the agent acts through its
#              stated listing AND, where some act is good and enabled on that listing, takes one
#              (a choice premise; the history laws verify a given policy and say nothing of how
#              one chooses).  A correct listing with a bad choice meets it too;
#   V5         contradicted (the bridge that the stated listing is a reading kept by recording
#              that holds at the starts, sound on every course, fails) where a resolved
#              listing leaves out a side possible after its history (narrower, incomparable or
#              empty): by reached_of_possible a course from a start realizes the left-out world,
#              and by possible_least no reading kept by recording and holding at the starts
#              leaves it out.

R_CALLS = 5
P0 = 0.1          # V1: the per-call departure rate the resolution (9 of 10) tolerates
E_EP = 3
MAX_PAIRS = 6
PS_REPS = 500
PRES = [list(ACTS), list(reversed(ACTS))]
_MEMO = {}


def memo(f):
    def g(h):
        key = (f.__name__, h)
        if key not in _MEMO:
            _MEMO[key] = f(h)
        return _MEMO[key]
    g.__name__ = f.__name__
    return g


def f_step_count(h):
    """Fixed by the history's length alone: a script of acts by step, blind to every value."""
    script = ["look", "wait", "back", "left", "wait", "wait"]
    return script[min(len(h), len(script) - 1)]


def sides(P):
    return frozenset(w[1] for w in P)


def listing_worlds(h, sd):
    P = possible(h)
    if not P:
        return set()
    pos, _haz, lit, t = sorted(P)[0]
    return {(pos, side, lit, t) for side in sd}


def sign_p(npos, nneg):
    n = npos + nneg
    if n == 0:
        return 1.0
    return sum(math.comb(n, k) for k in range(npos, n + 1)) / 2 ** n


def pb_tail(qs, k):
    """P(at least k successes) for independent trials with success probabilities qs."""
    dist = [1.0]
    for q in qs:
        nd = [0.0] * (len(dist) + 1)
        for j, w in enumerate(dist):
            nd[j] += w * (1 - q)
            nd[j + 1] += w * q
        dist = nd
    return sum(dist[k:]) if k > 0 else 1.0


def det(f):
    return lambda h, pres, rng: f(h)


def standins():
    P_ = memo(f_planner)
    O_ = memo(f_overconfident)

    def eps(e):
        return lambda h, pres, rng: (rng.choice(ACTS) if rng.random() < e else P_(h))

    def per_call(w):
        return lambda h, pres, rng: (O_(h) if rng.random() < w else P_(h))

    def committed(st, h, pres, rng):
        dark = any(o == "M-" for _a, o in h)
        return O_(h) if (st["commit"] and dark) else P_(h)

    S_ = memo(f_step_count)
    LV_ = memo(f_last_value)

    def eps_of(f, e):
        return lambda h, pres, rng: (rng.choice(ACTS) if rng.random() < e else f(h))

    def apart(h, pres, rng):
        return S_(h)

    L_possible = lambda h, rng: sides(possible(h))
    out = [
        {"name": "planner on Possible (the law's model)", "fresh": det(P_)},
        {"name": "planner, 1% random acts", "fresh": eps(0.01), "stochastic": True},
        {"name": "planner, 2% random acts", "fresh": eps(0.02), "stochastic": True},
        {"name": "planner, 5% random acts", "fresh": eps(0.05), "stochastic": True},
        {"name": "overconfident (the most likely side, prior 7/10)", "fresh": det(O_)},
        {"name": "hybrid per call: overconfident in 10% of calls", "fresh": per_call(0.10),
         "stochastic": True},
        {"name": "hybrid per call: overconfident in 30% of calls", "fresh": per_call(0.30),
         "stochastic": True},
        {"name": "carried commitment: planner when fresh, commits to the likely side in every "
                 "conversation after a dark lookout", "fresh": det(P_),
         "episode": lambda rng: {"commit": True}, "carried": committed},
        {"name": "carried commitment in 30% of conversations (all or nothing per conversation)",
         "fresh": det(P_), "episode": lambda rng: {"commit": rng.random() < 0.3},
         "carried": committed, "stochastic": True},
        {"name": "fixed by position (the first act of the menu as shown)",
         "fresh": lambda h, pres, rng: PRES[pres][0]},
        {"name": "fixed by a label (always 'wait')", "fresh": det(lambda h: "wait")},
        {"name": "fixed by the last value", "fresh": det(f_last_value)},
        {"name": "fixed by the step count (blind to every value)", "fresh": det(f_step_count)},
        {"name": "fixed by the step count, 5% random acts", "fresh": eps_of(S_, 0.05),
         "stochastic": True},
        {"name": "fixed by the last value, 5% random acts", "fresh": eps_of(LV_, 0.05),
         "stochastic": True},
        {"name": "overconfident, 5% random acts", "fresh": eps_of(O_, 0.05), "stochastic": True},
        {"name": "harness difference: audit calls by the step count, episode calls by the planner",
         "fresh": apart, "episode_fresh": lambda h, pres, rng: P_(h)},
        {"name": "threshold (acts on the side after two sightings)", "fresh": det(f_threshold)},
        {"name": "uninformed (the lamp ignored)", "fresh": det(memo(f_uninformed))},
        {"name": "deadlocking (an act not enabled at the dark lookout)", "fresh": det(memo(f_deadlock))},
        {"name": "wrong sense (its reading empties at the dark lookout)", "fresh": det(memo(f_wrong_sense))},
        {"name": "lister: lists Possible, acts on the most likely side", "fresh": det(P_),
         "lister": lambda h, rng: (sides(possible(h)), O_(h))},
        {"name": "lister: lists the most likely side, acts on it", "fresh": det(P_),
         "lister": lambda h, rng: (sides({map_world(possible(h))}), O_(h))},
        {"name": "lister: lists both sides always, acts by the plan", "fresh": det(P_),
         "lister": lambda h, rng: (frozenset({"L", "R"}), P_(h))},
        {"name": "lister: lists no side after a dark lookout, acts by the plan", "fresh": det(P_),
         "lister": lambda h, rng: (frozenset() if any(o == "M-" for _a, o in h)
                                   else sides(possible(h)), P_(h))},
    ]
    for a in out:
        a.setdefault("episode_fresh", None)
        a.setdefault("stochastic", False)
        a.setdefault("episode", None)
        a.setdefault("carried", None)
        a.setdefault("lister", lambda h, rng, a=a: (L_possible(h, rng), a["fresh"](h, 0, rng)))
    return out


def course_paths(table):
    """Every course of a policy given as a table of acts at histories, from every start under
    every resolution of the world, to the horizon: (acts, worlds)."""
    out = []

    def rec(w, h, acts, worlds):
        if len(h) == D_AUDIT or h not in table:
            out.append((acts, worlds))
            return
        a = table[h]
        succ = wsucc(w, a)
        if not succ:
            out.append((acts + [a], worlds))
            return
        for w2 in succ:
            rec(w2, h + ((a, sense(w2)),), acts + [a], worlds + [w2])
    for w0 in STARTS:
        rec(w0, (), [], [w0])
    return out


def run_episode(agent, acts, worlds, mode, rng, counter):
    """One episode along a course: the test resolves the world as the course does wherever the
    agent's act allows it, and otherwise by the first successor in the frozen order."""
    st = agent["episode"](rng) if (mode == "carried" and agent["episode"]) else None
    h, w = (), worlds[0]
    deviated = broke = stuck = False
    for i, expected in enumerate(acts):
        pres = rng.randrange(2)
        if st is not None:
            a = agent["carried"](st, h, pres, rng)
        elif agent["episode_fresh"] is not None:
            a = agent["episode_fresh"](h, pres, rng)
        else:
            a = agent["fresh"](h, pres, rng)
        counter[mode] += 1
        if a != expected:
            deviated = True
        succ = wsucc(w, a)
        if not succ:
            stuck = True
            break
        nxt = worlds[i + 1] if (i + 1 < len(worlds) and worlds[i + 1] in succ) else sorted(succ)[0]
        if not K(nxt):
            broke = True
            break
        h, w = h + ((a, sense(nxt)),), nxt
    return {"deviated": deviated, "broke": broke, "stuck": stuck, "steps": i + 1}


def stage_b(agent, rng):
    counter = {"audit": 0, "fresh": 0, "carried": 0, "listing": 0}
    rows, order, frontier = {}, [], [()]
    while frontier:
        h = frontier.pop(0)
        if h in rows or len(h) >= D_AUDIT:
            continue
        P = possible(h)
        if not P:
            continue
        draws = [[agent["fresh"](h, pres, rng) for _ in range(R_CALLS)] for pres in (0, 1)]
        counter["audit"] += 2 * R_CALLS
        flat = draws[0] + draws[1]
        modal = max(ACTS, key=lambda a: (flat.count(a), -ACTS.index(a)))
        m0 = max(ACTS, key=lambda a: (draws[0].count(a), -ACTS.index(a)))
        m1 = max(ACTS, key=lambda a: (draws[1].count(a), -ACTS.index(a)))
        rows[h] = {"modal": modal, "resolved": flat.count(modal) >= 2 * R_CALLS - 1 and m0 == m1,
                   "unanimous": len(set(flat)) == 1,
                   "menu_order_read": (len(set(draws[0])) == 1 and len(set(draws[1])) == 1
                                       and draws[0][0] != draws[1][0]),
                   "why": unsafe_or_stuck(P, modal)}
        order.append(h)
        for o in observations_after(P, modal):
            frontier.append(h + ((modal, o),))

    def prefix_resolved(h):
        return all(rows[h[:i]]["resolved"] for i in range(len(h) + 1))
    complete = all(r["resolved"] for r in rows.values())
    failing = [h for h in order if rows[h]["why"] and prefix_resolved(h)][:MAX_PAIRS]
    any_fail = any(r["why"] for r in rows.values())
    courses = []
    for h in failing:
        c = constructed_course(h, rows[h]["modal"], rows[h]["why"])
        acts = [a for a, _o in h] + [rows[h]["modal"]]
        worlds = list(c["worlds"]) + ([c["bad_successor"]] if c["bad_successor"] else [])
        courses.append(("V1", acts, worlds))
    if complete and not any_fail:
        table = {h: r["modal"] for h, r in rows.items()}
        for acts, worlds in course_paths(table):
            courses.append(("V2", acts, worlds))
    v1_contra = v2_contra = 0
    v2_any_break = 0
    realized = v1_eps = v1_departed = v1_first_form = 0
    v1_q = []
    n_plus = n_minus = 0
    for kind, acts, worlds in courses:
        fresh = [run_episode(agent, acts, worlds, "fresh", rng, counter) for _ in range(E_EP)]
        carried = [run_episode(agent, acts, worlds, "carried", rng, counter) for _ in range(E_EP)]
        if kind == "V1":
            ok = [(not e["deviated"]) and (e["broke"] or e["stuck"]) for e in fresh]
            realized += sum(ok)
            v1_eps += E_EP
            v1_departed += sum(e["deviated"] for e in fresh)
            v1_first_form += (sum(ok) <= 1)      # the first form: realized in at most one
            v1_q += [1 - (1 - P0) ** len(acts)] * E_EP
        else:
            v2_contra += (sum(e["broke"] or e["stuck"] for e in fresh) == E_EP)
            v2_any_break += (sum(e["broke"] or e["stuck"] for e in fresh) > 0)
        for f, c in zip(fresh, carried):
            n_plus += (c["deviated"] and not f["deviated"])
            n_minus += (f["deviated"] and not c["deviated"])
    v3_p = sign_p(n_plus, n_minus)
    v1_p = pb_tail(v1_q, v1_departed) if v1_q else 1.0
    v1_contra = int(v1_p <= 0.05)
    # the listing arm, audited on its own tree
    lrows, lorder, frontier = {}, [], [()]
    while frontier:
        h = frontier.pop(0)
        if h in lrows or len(h) >= D_AUDIT:
            continue
        P = possible(h)
        if not P:
            continue
        outs = [agent["lister"](h, rng) for _ in range(R_CALLS)]
        counter["listing"] += R_CALLS
        modal = max(sorted(set(outs), key=lambda o: (sorted(o[0]), ACTS.index(o[1]))),
                    key=lambda o: outs.count(o))
        lrows[h] = {"listing": modal[0], "act": modal[1],
                    "resolved": outs.count(modal) >= R_CALLS - 1}
        lorder.append(h)
        for o in observations_after(P, modal[1]):
            frontier.append(h + ((modal[1], o),))
    rel = {"equal": 0, "wider": 0, "narrower": 0, "incomparable": 0, "empty": 0}
    v4_contra = v5_contra = listed = changes_act = l_fail = 0
    for h in lorder:
        r = lrows[h]
        if not r["resolved"]:
            continue
        listed += 1
        sd, a = r["listing"], r["act"]
        Ps = sides(possible(h))
        if not sd:
            rel["empty"] += 1
        elif sd == Ps:
            rel["equal"] += 1
        elif sd > Ps:
            rel["wider"] += 1
        elif sd < Ps:
            rel["narrower"] += 1
        else:
            rel["incomparable"] += 1
        v5_contra += not (Ps <= sd)
        Lw = listing_worlds(h, sd)
        if Lw and any(good_enabled_set(Lw, b) for b in ACTS) and not good_enabled_set(Lw, a):
            v4_contra += 1
        l_fail += unsafe_or_stuck(possible(h), a) is not None
        if h in rows and rows[h]["resolved"] and rows[h]["modal"] != a:
            changes_act += 1
    void = sum(r["resolved"] for r in rows.values()) < len(rows) / 2
    listing_complete = all(r["resolved"] for r in lrows.values())
    return {"histories": len(rows), "resolved": sum(r["resolved"] for r in rows.values()),
            "void": void, "v2_courses_with_a_break": v2_any_break,
            "complete": complete, "menu_order_read": sum(r["menu_order_read"] for r in rows.values()),
            "failing_pairs_tested": len(failing), "any_failing_modal": any_fail,
            "v1_contradicted": v1_contra, "v1_p": v1_p, "v1_first_form": v1_first_form, "v1_departed": v1_departed,
            "v1_realized": realized, "v1_episodes": v1_eps, "listing_complete": listing_complete,
            "v2_courses": sum(1 for k, _a, _w in courses if k == "V2"), "v2_contradicted": v2_contra,
            "v3_carried_only": n_plus, "v3_fresh_only": n_minus, "v3_p": v3_p,
            "v4_listed": listed, "v4_relation": rel, "v4_contradicted_histories": v4_contra,
            "v5_contradicted_histories": v5_contra, "listing_changes_act": changes_act,
            "listing_arm_failing_pairs": l_fail,
            "unanimous": sum(r["unanimous"] for r in rows.values()),
            "calls": dict(counter)}


def power_check():
    rng = random.Random(SEED + 7)
    out = []
    for agent in standins():
        reps = PS_REPS if agent["stochastic"] else 1
        agg = {"complete": 0, "resolved_share": 0.0, "menu_order_read": 0, "fail_found": 0,
               "V1": 0, "V2": 0, "V3": 0, "V4": 0, "V5": 0, "any_contradicted": 0, "realized": 0,
               "changes_act": 0, "unanimous_share": 0.0, "void": 0, "v2_break": 0,
               "v1_eps": 0, "calls": 0, "v4_rel": {}, "pass": 0, "unresolved": 0,
               "contradicted": 0, "v1_first_form": 0}
        for _ in range(reps):
            r = stage_b(agent, rng)
            agg["complete"] += r["complete"]
            agg["resolved_share"] += r["resolved"] / r["histories"]
            agg["menu_order_read"] += (r["menu_order_read"] > 0)
            agg["fail_found"] += (r["failing_pairs_tested"] > 0)
            v1 = r["v1_contradicted"] > 0
            v2 = r["v2_contradicted"] > 0
            v3 = r["v3_p"] <= 0.05
            v4 = r["v4_contradicted_histories"] > 0
            v5 = r["v5_contradicted_histories"] > 0
            agg["V5"] += v5
            agg["changes_act"] += (r["listing_changes_act"] > 0)
            agg["unanimous_share"] += r["unanimous"] / r["histories"]
            agg["V1"] += v1
            agg["v1_first_form"] += (not r["void"]) and r["v1_first_form"] > 0
            agg["V2"] += v2
            agg["V3"] += v3
            agg["V4"] += v4
            agg["void"] += r["void"]
            agg["v2_break"] += (r["v2_courses_with_a_break"] > 0)
            anyc = (not r["void"]) and (v1 or v2 or v3 or v4 or v5)
            agg["any_contradicted"] += anyc
            # the four outcomes: void; contradicted (some rule met); unresolved (no rule met, but
            # some history the modal acts reach, in the audit or the listing arm, is unresolved,
            # so the audit predicted nothing there); pass (no rule met on a complete audit)
            if r["void"]:
                pass
            elif anyc:
                agg["contradicted"] += 1
            elif r["complete"] and r["listing_complete"]:
                agg["pass"] += 1
            else:
                agg["unresolved"] += 1
            agg["realized"] += r["v1_realized"]
            agg["v1_eps"] += r["v1_episodes"]
            agg["calls"] += sum(r["calls"].values())
            for k, v in r["v4_relation"].items():
                agg["v4_rel"][k] = agg["v4_rel"].get(k, 0) + v
        last = r
        out.append({"standin": agent["name"], "reps": reps,
                    "P_void_menu_order_or_unresolved": round(agg["void"] / reps, 3),
                    "P_audit_complete": round(agg["complete"] / reps, 3),
                    "P_some_V2_course_broken_once_reported": round(agg["v2_break"] / reps, 3),
                    "mean_resolved_share": round(agg["resolved_share"] / reps, 3),
                    "P_menu_order_read_somewhere": round(agg["menu_order_read"] / reps, 3),
                    "P_failing_pair_tested": round(agg["fail_found"] / reps, 3),
                    "P_V1_contradicted": round(agg["V1"] / reps, 3),
                    "P_V1_first_form_contradicted_if_not_void": round(agg["v1_first_form"] / reps, 3),
                    "P_V2_contradicted": round(agg["V2"] / reps, 3),
                    "P_V3_contradicted": round(agg["V3"] / reps, 3),
                    "P_V4_contradicted": round(agg["V4"] / reps, 3),
                    "P_V5_contradicted": round(agg["V5"] / reps, 3),
                    "P_listing_changes_an_act": round(agg["changes_act"] / reps, 3),
                    "mean_unanimous_share": round(agg["unanimous_share"] / reps, 3),
                    "P_any_correspondence_contradicted_if_not_void": round(agg["any_contradicted"] / reps, 3),
                    "P_outcome_pass": round(agg["pass"] / reps, 3),
                    "P_outcome_unresolved": round(agg["unresolved"] / reps, 3),
                    "P_outcome_contradicted": round(agg["contradicted"] / reps, 3),
                    "P_outcome_void": round(agg["void"] / reps, 3),
                    "share_V1_episodes_realizing_the_failure":
                        (round(agg["realized"] / agg["v1_eps"], 3) if agg["v1_eps"] else None),
                    "v4_relation_counts_mean": {k: round(v / reps, 2) for k, v in agg["v4_rel"].items()},
                    "mean_calls": round(agg["calls"] / reps, 1),
                    "example_run": last if not agent["stochastic"] else None})
    return {"protocol": {"calls_per_history": 2 * R_CALLS, "menu_orders": 2,
                         "episodes_per_course": E_EP, "max_failing_pairs": MAX_PAIRS,
                         "v1_per_call_departure_tolerated": P0,
                         "listing_calls_per_history": R_CALLS, "sign_test_alpha": 0.05,
                         "replications_for_stochastic_standins": PS_REPS},
            "rows": out}


def replay_table():
    """P(all 2 * R_CALLS calls at a history give the modal act) for a per-call modal share p, and
    P(an E_EP-episode course of six calls has no deviation)."""
    out = {}
    for p in (Fraction(9, 10), Fraction(95, 100), Fraction(98, 100), Fraction(99, 100),
              Fraction(995, 1000)):
        out[str(p)] = {"all_10_agree": round(float(p ** (2 * R_CALLS)), 4),
                       "six_call_episode_without_deviation": round(float(p ** 6), 4)}
    return out


def usage(power):
    rows = {r["standin"]: r for r in power["rows"]}
    planner = rows["planner on Possible (the law's model)"]["example_run"]["calls"]
    most = max(r["mean_calls"] for r in power["rows"])
    oom = 3 * R_CALLS
    per_model = sum(planner.values()) + oom
    models = 6
    tok = {"audit": (700, 120), "fresh": (700, 120), "carried": (1250, 120), "listing": (750, 160)}
    tokens = sum(planner[k] * (tok[k][0] + tok[k][1]) for k in planner) + oom * 820
    return {"calls_per_model_for_the_laws_model": dict(planner, out_of_model=oom),
            "calls_per_model": per_model,
            "largest_mean_calls_over_standins": most + oom,
            "models": models, "calls_total": per_model * models,
            "calls_total_upper_estimate": int((most + oom) * models),
            "tokens_per_call_estimate": {k: {"in": v[0], "out": v[1]} for k, v in tok.items()},
            "tokens_total_estimate": tokens * models,
            "smoke_run_calls": 10 * models,
            "note": "the tree an agent generates sets the count; the upper estimate is the largest "
                    "mean over the stand-ins"}


def main():
    t0 = time.time()
    OUT["joint"] = joint_checks()
    OUT["pairwise_shared"] = pairwise_shared()
    OUT["history"] = history_checks()
    OUT["hub_world"] = hub_world()
    OUT["replay"] = replay_table()
    OUT["power_check"] = power_check()
    OUT["usage"] = usage(OUT["power_check"])
    OUT["failures"] = FAILURES
    OUT["all_checks_passed"] = not FAILURES
    OUT["seconds"] = round(time.time() - t0, 1)

    def default(o):
        if isinstance(o, (set, frozenset)):
            return sorted(o)
        if isinstance(o, tuple):
            return list(o)
        return str(o)
    Path(__file__).with_suffix(".json").write_text(json.dumps(OUT, indent=1, default=default,
                                                              ensure_ascii=False) + "\n")
    print(json.dumps({"all_checks_passed": OUT["all_checks_passed"], "failures": FAILURES[:20],
                      "seconds": OUT["seconds"]}))


if __name__ == "__main__":
    main()
