#!/usr/bin/env python3
"""TR4 (RF6.1, a revision that opens a correction): Stage 0.

Exact values, scripted desks and the power check for TR4's design. Standard library only,
deterministic (Fraction for exact values, random.Random with a frozen seed), no model call.
Writes tr4.json next to itself.

What it mirrors (Lean, pure core, every axiom report empty):
- Becoming.OpenedCorrection, general section: Correctable, correctable_iff, OpensAlong,
  finer_keeps, coarser_opens_nothing, widened_correctable; with GuardHorizon.UniformPolicy and
  FiberFeasible underneath.
- Becoming.OpenedCorrection.Linked on Becoming.Revision's Revising process: acceptable,
  executable, unlinked_uncorrectable, linked_correctable, starved_uncorrectable, opens,
  rebuilt_starved, opens_after_replenishing, opens_by_support, widened_unlinked.
- Becoming.Revision (Revising): P, read, alike, determined, rebuild_enabled_iff,
  correction_enabled_iff, opened_keeps, opened_choice, closed_loses, old_cannot_select_rebuild,
  rebuild_then_close, opens_without_correction, opens_with_correction, closes_choice,
  chosen_step, controlled_revision, linkProcess, draw, restore, step_iff, feasible_iff,
  covered_not_enacted, linked_not_enacted; RevisionRuns.rebuild_opens_keeps.

What is not in the Lean and is computed here as inference (labelled in the JSON):
- the classification of every configuration of Revising (the three Linked theorems cover it);
- the source of each opening, by counterfactual hybrids of reading and executability;
- the k-line institution (an instance of the general section only, not a Lean witness);
- the per-fiber bound for policies drawn at random (a mixture argument, a candidate core lemma);
- the power check for Stage B (simulated clerks and crews).

Stage B's protocol, as simulated (DESIGN, TR4 in an hour): four arms per model. L, the rule by
line, a record naming the line given to the crew (four calls a unit: three lines and no fault),
the premise that the crew can read a record. G, the rule by count, a record written by the
harness with its wording drawn apart from the line, a harness check. P, the rule by count, a
record given naming the reporting member (each member reports on one line, and the crew is shown
the roster), the planted-leak control. C, the test arm: a clerk shown the reports keeps the
register by its rule (count only) and a crew shown only the record and the roster acts; a unit is
the three situations, a fault on line 1, 2 or 3, with the number of reports and the wording paired,
each a fresh call, so six calls. m1 is the exact within-unit permutation test of the records
naming the faulty line (the frozen parser run on every simulated record string); m2 is the same
test of the crew's matches; m3 tests any dependence of the crew's act on the line (a map fixed on
half the units, tested on the other half); m4 tests any dependence of what the records name on the
line in the same way (a map from line to a named line, so a clerk naming another line is found
whether or not the crew reads it). C1, the reading in force is the register's rule, is
contradicted where any of the four rejects, Holm over the 24 p-values of six models. Arm G's
harness check (m2 and m3 on the crew's acts at records the harness writes) is simulated apart:
Holm over its 12 p-values at 0.05, a rejection stopping the whole run.

Bounds: Revising stock 0..N_STOCK, traces up to L_TRACE steps; the Lean holds for every n and
every trace length, so the bounded checks are checks of the mirror, not of the law.
"""

from __future__ import annotations

import itertools
import json
import math
import re
import random
import time
from fractions import Fraction
from pathlib import Path

SEED = 20261031
N_STOCK = 8          # Revising stock checked: 0..N_STOCK
L_TRACE = 5          # traces enumerated up to this length
K_LINES = 3          # lines of the k-line institution
N_K = 4              # k-line stock checked: 0..N_K
REPS = 600           # power-check replications per agent and size (400 at 60 units)
ALPHA = Fraction(1, 20)
ALPHA_F = 0.05

OUT = {"test": "TR4", "law": "RF6.1", "record": "a-revision-that-opens-a-correction",
       "module": "Becoming.OpenedCorrection", "seed": SEED,
       "bounds": {"revising_stock_max": N_STOCK, "trace_length_max": L_TRACE,
                  "k_lines": K_LINES, "k_line_stock_max": N_K}}
FAILURES: list[str] = []


def check(name: str, ok: bool) -> bool:
    if not ok:
        FAILURES.append(name)
    return ok


# ---------------------------------------------------------------------------------------------
# 1. General section (OpenedCorrection; GuardHorizon underneath)
# ---------------------------------------------------------------------------------------------

def uniform_policy(S, O, A, obs, good) -> bool:
    """GuardHorizon.UniformPolicy obs good: some total policy O -> A good at every s."""
    O = list(O)
    for choice in itertools.product(A, repeat=len(O)):
        policy = dict(zip(O, choice))
        if all(good(s, policy[obs(s)]) for s in S):
            return True
    return False


def fiber_feasible(S, O, A, obs, good) -> bool:
    """GuardHorizon.FiberFeasible obs good: each reading value has one act good at every s giving it."""
    return all(any(all(good(s, a) for s in S if obs(s) == o) for a in A) for o in O)


def correctable(x, S, O, A, reading, acceptable, executable, brute=True) -> bool:
    """OpenedCorrection.Correctable reading acceptable executable x."""
    good = lambda s, a: acceptable(s, a) and executable(x, a)
    obs = lambda s: reading(x, s)
    if brute:
        return uniform_policy(S, O, A, obs, good)
    return fiber_feasible(S, O, A, obs, good)


# ---------------------------------------------------------------------------------------------
# 2. Revising (Becoming.Revision) and Linked (OpenedCorrection.Linked)
# ---------------------------------------------------------------------------------------------

ACTS = ["rep", "reb0", "reb1", "cor"]          # replenish, rebuild false, rebuild true, correct
ACT_NAME = {"rep": ".replenish", "reb0": ".rebuild false", "reb1": ".rebuild true", "cor": ".correct"}


def succ(s, a):
    """Revising.P's successors of s under a (a list; P is determined, so at most one)."""
    n, l, v = s
    if a == "rep":
        return [(n + 1, l, v)]
    if a in ("reb0", "reb1"):
        return [(n - 1, a == "reb1", v)] if n >= 1 else []
    if a == "cor":
        return [(n - 1, True, True)] if (l and n >= 1) else []
    raise ValueError(a)


def enabled(s, a) -> bool:
    return bool(succ(s, a))


def read(s, b: bool) -> bool:
    """Revising.read: the link on reads the situation, the link off reads every situation as false."""
    return b if s[1] else False


def alike(s, b: bool, c: bool) -> bool:
    return read(s, b) == read(s, c)


def lin_acceptable(needed: bool, a: str) -> bool:
    """Linked.acceptable: the correction where it is needed, replenishing where it is not."""
    return a == "cor" if needed else a == "rep"


def lin_executable(x, a: str) -> bool:
    """Linked.executable: Enabled P x a."""
    return enabled(x, a)


SIT = [False, True]       # S = Bool (needed)
OBS = [False, True]       # O = Bool


def lin_correctable(x, acceptable=lin_acceptable, executable=lin_executable, brute=True) -> bool:
    return correctable(x, SIT, OBS, ACTS, read, acceptable, executable, brute)


def configs(nmax=N_STOCK):
    return [(n, l, v) for n in range(nmax + 1) for l in (False, True) for v in (False, True)]


def traces_from(s, length, step=succ, acts=ACTS):
    """All (word, end) with a trace of exactly `length` steps from s."""
    frontier = [((), s)]
    for _ in range(length):
        nxt = []
        for w, t in frontier:
            for a in acts:
                for u in step(t, a):
                    nxt.append((w + (a,), u))
        frontier = nxt
    return frontier


def trace_ok(s, word, t, step=succ) -> bool:
    cur = [s]
    for a in word:
        cur = [u for c in cur for u in step(c, a)]
    return t in cur


def covered(draw, restore, n, word) -> bool:
    """Stock.Covered draw replenish n word."""
    for a in word:
        if draw(a) > n:
            return False
        n = n - draw(a) + restore(a)
    return True


def draw(a):
    return 0 if a == "rep" else 1


def restore(a):
    return 1 if a == "rep" else 0


def link_succ(s, a):
    """Revising.linkProcess on (link, response)."""
    l, v = s
    if a == "rep":
        return [(l, v)]
    if a in ("reb0", "reb1"):
        return [(a == "reb1", v)]
    if a == "cor":
        return [(True, True)] if l else []
    raise ValueError(a)


def stock_succ(n, a):
    """Stock.process draw restore: draw a <= n and m + draw a = n + restore a."""
    return [n - draw(a) + restore(a)] if draw(a) <= n else []


def feasible(step, s, word) -> bool:
    cur = [s]
    for a in word:
        cur = [u for c in cur for u in step(c, a)]
        if not cur:
            return False
    return True


def revising_checks():
    res = {}
    cs = configs()
    # determined: at most one successor per (s, a)
    res["determined"] = check("determined", all(len(succ(s, a)) <= 1 for s in cs for a in ACTS))
    res["rebuild_enabled_iff"] = check("rebuild_enabled_iff", all(
        enabled(s, b) == (s[0] >= 1) for s in cs for b in ("reb0", "reb1")))
    res["correction_enabled_iff"] = check("correction_enabled_iff", all(
        enabled(s, "cor") == (s[1] and s[0] >= 1) for s in cs))
    # opened_keeps n m: Keeps alike (n,false,false) (m,true,false): alike t x y -> alike s x y
    res["opened_keeps"] = check("opened_keeps", all(
        all((not alike((m, True, False), x, y)) or alike((n, False, False), x, y)
            for x in SIT for y in SIT) for n in range(N_STOCK + 1) for m in range(N_STOCK + 1)))
    sel_true = lambda b: b is True

    def through(s, select):
        return all((select(x) == select(y)) for x in SIT for y in SIT if alike(s, x, y))
    res["opened_choice"] = check("opened_choice", all(through((n, True, False), sel_true)
                                                      for n in range(N_STOCK + 1)))
    res["closed_loses"] = check("closed_loses", all(not through((n, False, False), sel_true)
                                                    for n in range(N_STOCK + 1)))
    selects = [lambda b, t=t: t[int(b)] for t in itertools.product([False, True], repeat=2)]
    res["old_cannot_select_rebuild"] = check("old_cannot_select_rebuild", all(
        (not through((n, False, False), sel)) or (sel(True) == sel(False))
        for n in range(N_STOCK + 1) for sel in selects))
    res["rebuild_then_close"] = check("rebuild_then_close", trace_ok(
        (0, False, False), ["rep", "rep", "reb1", "cor", "rep", "reb0"], (0, False, True)))
    res["opens_without_correction"] = check("opens_without_correction",
        (0, True, False) in succ((1, False, False), "reb1") and through((0, True, False), sel_true)
        and not enabled((0, True, False), "cor"))
    res["opens_with_correction"] = check("opens_with_correction",
        (1, True, False) in succ((2, False, False), "reb1") and through((1, True, False), sel_true)
        and enabled((1, True, False), "cor"))
    res["closes_choice"] = check("closes_choice",
        (1, False, False) in succ((2, True, False), "reb0") and through((2, True, False), sel_true)
        and not through((1, False, False), sel_true) and not enabled((1, False, False), "cor"))

    # the supplied controller (choose, next) and its run from (0, false, false)
    def choose(s):
        n, l, _ = s
        if n == 0:
            return "rep"
        return "cor" if l else "reb1"

    def nxt(s):
        n, l, v = s
        if n == 0:
            return (1, l, v)
        return (n - 1, True, v) if not l else (n - 1, True, True)
    res["chosen_step"] = check("chosen_step", all(nxt(s) in succ(s, choose(s)) for s in cs))
    run = [(0, False, False)]
    for _ in range(7):
        run.append(nxt(run[-1]))
    acts = [choose(s) for s in run]
    cr = (acts[1] == "reb1" and run[2] == (0, True, False)
          and not through(run[0], sel_true) and through(run[2], sel_true)
          and not enabled(run[2], "cor") and acts[2] == "rep" and acts[3] == "cor"
          and run[4] in succ(run[3], "cor") and run[3][2] is False and run[4][2] is True)
    res["controlled_revision"] = check("controlled_revision", cr)
    res["controlled_run"] = [{"step": i, "state": list(run[i]), "act": ACT_NAME[acts[i]],
                              "correctable": lin_correctable(run[i])} for i in range(len(run))]
    # step_iff: P.step s a t <-> product of Stock.process and linkProcess
    ok = True
    for s in cs:
        for a in ACTS:
            for t in configs(N_STOCK + 1):
                lhs = t in succ(s, a)
                rhs = (t[0] in stock_succ(s[0], a)) and ((t[1], t[2]) in link_succ((s[1], s[2]), a))
                ok &= (lhs == rhs)
    res["step_iff"] = check("step_iff", ok)
    # feasible_iff over all words up to L_TRACE
    ok, n_words = True, 0
    for s in configs(4):
        for length in range(L_TRACE + 1):
            for word in itertools.product(ACTS, repeat=length):
                n_words += 1
                lhs = feasible(succ, s, word)
                rhs = covered(draw, restore, s[0], word) and feasible(link_succ, (s[1], s[2]), word)
                ok &= (lhs == rhs)
    res["feasible_iff"] = check("feasible_iff", ok)
    res["feasible_iff_cases"] = n_words
    res["covered_not_enacted"] = check("covered_not_enacted",
        covered(draw, restore, 1, ["cor"]) and not feasible(succ, (1, False, False), ["cor"]))
    res["linked_not_enacted"] = check("linked_not_enacted",
        feasible(link_succ, (True, False), ["cor"]) and not feasible(succ, (0, True, False), ["cor"]))
    # RevisionRuns.rebuild_opens_keeps: a rebuild-true step from link off, response false, keeps alike
    ok = True
    for s in cs:
        if (s[1], s[2]) == (False, False):
            for t in succ(s, "reb1"):
                ok &= all((not alike(t, x, y)) or alike(s, x, y) for x in SIT for y in SIT)
    res["rebuild_opens_keeps"] = check("rebuild_opens_keeps", ok)
    return res


def linked_checks():
    res = {}
    cs = configs()
    # the mirror: brute force over all 16 policies Bool -> Act equals the fiber condition
    res["brute_equals_fiber"] = check("brute_equals_fiber", all(
        lin_correctable(x, brute=True) == lin_correctable(x, brute=False) for x in cs))
    # correctable_iff on Linked: Bool has choice, so both directions are checked
    res["unlinked_uncorrectable"] = check("unlinked_uncorrectable", all(
        not lin_correctable((n, False, v)) for n in range(N_STOCK + 1) for v in (False, True)))
    res["linked_correctable"] = check("linked_correctable", all(
        lin_correctable((n + 1, True, v)) for n in range(N_STOCK) for v in (False, True)))
    res["starved_uncorrectable"] = check("starved_uncorrectable", all(
        not lin_correctable((0, True, v)) for v in (False, True)))

    def opens_along(x, xp, word):
        return trace_ok(x, word, xp) and not lin_correctable(x) and lin_correctable(xp)
    res["opens"] = check("opens", all(
        opens_along((n + 2, False, v), (n + 1, True, v), ["reb1"])
        for n in range(N_STOCK - 1) for v in (False, True)))
    res["rebuilt_starved"] = check("rebuilt_starved", all(
        (0, True, v) in succ((1, False, v), "reb1") and not lin_correctable((0, True, v))
        for v in (False, True)))
    res["opens_after_replenishing"] = check("opens_after_replenishing", all(
        opens_along((1, False, v), (1, True, v), ["reb1", "rep"]) for v in (False, True)))
    res["opens_by_support"] = check("opens_by_support", all(
        opens_along((0, True, v), (1, True, v), ["rep"]) for v in (False, True)))
    widened = lambda s, a: True
    res["widened_unlinked"] = check("widened_unlinked", all(
        lin_correctable((n, False, v), acceptable=widened) for n in range(N_STOCK + 1)
        for v in (False, True)))
    res["widened_every_configuration"] = check("widened_every_configuration", all(
        lin_correctable(x, acceptable=widened) for x in cs))
    # inference, not a Lean theorem: the three Linked theorems classify every configuration
    res["classification_inference"] = check("classification", all(
        lin_correctable(x) == (x[1] and x[0] >= 1) for x in cs))
    res["table"] = [{"state": list(x), "correctable": lin_correctable(x),
                     "executable": [ACT_NAME[a] for a in ACTS if enabled(x, a)]}
                    for x in configs(3)]
    return res


# ---------------------------------------------------------------------------------------------
# 3. Openings and their source (inference over the Lean's definitions)
# ---------------------------------------------------------------------------------------------

def opening_source(x, xp, S, O, A, reading, acceptable, executable):
    """Counterfactual hybrids: is x' correctable with the reading of x' and the executability of x
    (the reading alone suffices), or with the reading of x and the executability of x' (the
    executability alone suffices)?  Both hybrids are Correctable applied to other arguments."""
    rd_hyb = lambda _y, s: reading(xp, s)
    ex_hyb = lambda _y, a: executable(x, a)
    by_reading = correctable(None, S, O, A, rd_hyb, acceptable, ex_hyb, brute=False)
    rd_hyb2 = lambda _y, s: reading(x, s)
    ex_hyb2 = lambda _y, a: executable(xp, a)
    by_exec = correctable(None, S, O, A, rd_hyb2, acceptable, ex_hyb2, brute=False)
    reading_changed = any(reading(x, s) != reading(xp, s) for s in S)
    exec_changed = any(executable(x, a) != executable(xp, a) for a in A)
    if by_reading and by_exec:
        cls = "either alone"
    elif by_reading:
        cls = "the reading alone"
    elif by_exec:
        cls = "executability alone"
    else:
        cls = "both needed"
    return {"class": cls, "reading_changed": reading_changed, "executability_changed": exec_changed}


def revising_openings():
    rows, classes = [], {}
    for x in configs(4):
        if lin_correctable(x):
            continue
        shortest, witness, ends = None, None, set()
        for length in range(1, L_TRACE + 1):
            for word, t in traces_from(x, length):
                if lin_correctable(t):
                    ends.add(t)
                    if shortest is None:
                        shortest, witness = length, word
            if shortest is not None and length >= shortest:
                pass
        src = {}
        for t in sorted(ends):
            c = opening_source(x, t, SIT, OBS, ACTS, read, lin_acceptable, lin_executable)
            src[str(t)] = c
            classes[c["class"]] = classes.get(c["class"], 0) + 1
        first_end = None
        if witness is not None:
            first_end = traces_from_word(x, witness)
        rows.append({"from": list(x), "shortest_opening_steps": shortest,
                     "witness_trace": [ACT_NAME[a] for a in witness] if witness else None,
                     "witness_end": list(first_end) if first_end else None,
                     "witness_source": opening_source(x, first_end, SIT, OBS, ACTS, read,
                                                      lin_acceptable, lin_executable)["class"]
                     if first_end else None,
                     "ends_within_L": len(ends)})
    # both orders from one unit
    order = {}
    for v in (False, True):
        a = trace_ok((1, False, v), ["reb1", "rep"], (1, True, v))
        b = trace_ok((1, False, v), ["rep", "reb1"], (1, True, v))
        order[str(v)] = {"rebuild_then_replenish_reaches": a, "replenish_then_rebuild_reaches": b,
                         "intermediate_after_rebuild": [0, True, v],
                         "intermediate_after_replenish": [2, False, v],
                         "both_intermediates_uncorrectable":
                             (not lin_correctable((0, True, v))) and (not lin_correctable((2, False, v)))}
    check("no_trap_on_revising", all(o["rebuild_then_replenish_reaches"] and
                                     o["replenish_then_rebuild_reaches"] for o in order.values()))
    return {"rows": rows, "source_counts_over_all_ends_within_L": classes, "orders_from_one_unit": order}


def traces_from_word(x, word):
    cur = [x]
    for a in word:
        cur = [u for c in cur for u in succ(c, a)]
    return cur[0] if cur else None


# ---------------------------------------------------------------------------------------------
# 4. Monotonicities on Revising, every pair and every map Bool -> Bool
# ---------------------------------------------------------------------------------------------

def reach_closure(states, step, acts, nmax):
    """Pairs (x, y) with a trace of one step or more (any length) within stock <= nmax."""
    idx = {s: i for i, s in enumerate(states)}
    reach = {s: set() for s in states}
    for s in states:
        seen, frontier = set(), [s]
        while frontier:
            c = frontier.pop()
            for a in acts:
                for u in step(c, a):
                    if u in idx and u not in seen:
                        seen.add(u)
                        frontier.append(u)
        reach[s] = seen
    return reach


def monotonicity_revising():
    cs = configs(5)
    corr = {x: lin_correctable(x) for x in cs}
    exe = {x: {a for a in ACTS if enabled(x, a)} for x in cs}
    reach = reach_closure(cs, succ, ACTS, 5)
    maps = [dict(zip([False, True], m)) for m in itertools.product([False, True], repeat=2)]
    fk_prem = fk_viol = cn_prem = cn_viol = cn_core_viol = 0
    for x in cs:
        for xp in cs:
            for f in maps:
                refines = all(f[read(xp, s)] == read(x, s) for s in SIT)
                kept = exe[x] <= exe[xp]
                if refines and kept and corr[x]:
                    fk_prem += 1
                    fk_viol += (not corr[xp])
                coarser = all(f[read(x, s)] == read(xp, s) for s in SIT)
                no_gain = exe[xp] <= exe[x]
                if coarser and no_gain:
                    cn_prem += 1
                    cn_viol += ((xp in reach[x]) and (not corr[x]) and corr[xp])
                    # the proof's content: correctable at x' gives correctable at x, any pair
                    cn_core_viol += ((not corr[x]) and corr[xp])
    check("finer_keeps_revising", fk_viol == 0)
    check("coarser_opens_nothing_revising", cn_viol == 0)
    check("coarser_opens_nothing_revising_any_pair", cn_core_viol == 0)
    return {"pairs": len(cs) ** 2, "maps": len(maps),
            "finer_keeps": {"premises_met": fk_prem, "violations": fk_viol},
            "coarser_opens_nothing": {"premises_met": cn_prem, "violations": cn_viol,
                                      "violations_without_the_trace": cn_core_viol},
            "reach_bound": "traces within stock <= 5; the second count asks no trace, as the "
                           "proof (finer_keeps with the roles exchanged) needs none"}


# ---------------------------------------------------------------------------------------------
# 5. Controllers on Revising, the plan's controls, and rival scorings
# ---------------------------------------------------------------------------------------------

def controller_course(start, policy, horizon=8):
    s, course = start, []
    first_corr = first_correction = None
    for t in range(horizon):
        c = lin_correctable(s)
        a = policy(s)
        nx = succ(s, a)
        course.append({"step": t, "state": list(s), "correctable": c, "act": ACT_NAME[a],
                       "enabled": bool(nx)})
        if c and first_corr is None:
            first_corr = t
        if a == "cor" and nx and first_correction is None:
            first_correction = t
        if not nx:
            break
        s = nx[0]
    return {"course": course, "first_correctable_step": first_corr,
            "first_correction_step": first_correction}


def controllers():
    def choose(s):  # Revising.choose
        n, l, _ = s
        return "rep" if n == 0 else ("cor" if l else "reb1")

    def replenish_first(s):
        n, l, _ = s
        if not l:
            return "reb1" if n >= 2 else "rep"
        return "cor" if n >= 1 else "rep"

    def never_rebuild(s):
        return "rep"

    def refuser(s):
        n, l, _ = s
        if not l:
            return "reb1" if n >= 1 else "rep"
        return "rep"

    def summary_reviser(s):  # adopts the summary (rebuild false) whenever it can
        n, l, _ = s
        return "reb0" if (l and n >= 1) else "rep"
    out = {}
    for name, pol, start in [("Revising.choose (controlled_revision)", choose, (0, False, False)),
                             ("replenish first", replenish_first, (0, False, False)),
                             ("never rebuild (by count only)", never_rebuild, (0, False, False)),
                             ("refuser (correctable, never corrects)", refuser, (0, False, False)),
                             ("summary reviser (rebuild false)", summary_reviser, (2, True, False))]:
        out[name] = controller_course(start, pol)
    return out


def plan_controls():
    rows = []
    for v in (False, True):
        rows.append({"control": "a finer reading with no stock", "configuration": [0, True, v],
                     "correctable": lin_correctable((0, True, v)),
                     "reached_from": [1, False, v], "by": ".rebuild true (rebuilt_starved)",
                     "opened_by": ".replenish, one step (opens_by_support)",
                     "source": opening_source((0, True, v), (1, True, v), SIT, OBS, ACTS, read,
                                              lin_acceptable, lin_executable)["class"]})
    for n in (0, 1, 2, 3):
        rows.append({"control": "stock with no link", "configuration": [n, False, False],
                     "correctable": lin_correctable((n, False, False)),
                     "shortest_opening_steps": {0: 3, 1: 2}.get(n, 1),
                     "computed_shortest": None})
    for n in (1, 2):
        rows.append({"control": "a correction available but refused",
                     "configuration": [n, True, False], "correctable": lin_correctable((n, True, False)),
                     "role": "scoring control: correctability is computed from the table, never "
                             "from corrections taken; it carries no verdict"})
    rows.append({"control": "widened acceptability (added)",
                 "every_configuration_correctable": all(
                     lin_correctable(x, acceptable=lambda s, a: True) for x in configs()),
                 "role": "an opening counts only with acceptability frozen before and apart from "
                         "every act"})
    # coarser revision: rebuild false from (n+1, true, v) to (n, false, v), forget := const false
    cr = []
    for n in range(3):
        x, xp = (n + 1, True, False), (n, False, False)
        coarser = all((False) == read(xp, s) for s in SIT)  # forget := fun _ => false
        no_gain = {a for a in ACTS if enabled(xp, a)} <= {a for a in ACTS if enabled(x, a)}
        cr.append({"from": list(x), "to": list(xp), "coarser_with_const_false": coarser,
                   "no_executability_gained": no_gain, "opens": (not lin_correctable(x)) and lin_correctable(xp),
                   "closes": lin_correctable(x) and not lin_correctable(xp)})
    rows.append({"control": "a coarser revision, a summary measure (added)", "pairs": cr})
    return rows


def fill_shortest(rows, openings):
    by = {tuple(r["from"]): r["shortest_opening_steps"] for r in openings["rows"]}
    for r in rows:
        if r.get("control") == "stock with no link":
            r["computed_shortest"] = by.get(tuple(r["configuration"]))
            check("shortest_" + str(r["configuration"]), r["computed_shortest"] == r["shortest_opening_steps"])
    return rows


def rival_scorings():
    """How each rival scoring reads Revising's configurations, exactly."""
    out = {}
    f = Fraction(1, 10)  # rate of a needed situation, for the drawn-situation scoring
    rows = []
    for x in [(0, False, False), (1, False, False), (2, False, False), (0, True, False), (1, True, False)]:
        # best expected success on drawn situations through the reading in force
        best = Fraction(0)
        fibers = {}
        for s in SIT:
            fibers.setdefault(read(x, s), []).append(s)
        for o, ss in fibers.items():
            best += max(sum((f if s else 1 - f) for s in ss if lin_acceptable(s, a) and enabled(x, a))
                        for a in ACTS)
        rows.append({"configuration": list(x), "correctable": lin_correctable(x),
                     "best_expected_success_on_drawn_situations_at_f_1_10": str(best),
                     "as_float": float(best)})
    out["drawn_situations"] = {"needed_rate": "1/10", "rows": rows,
                               "reading": "at the link off the best drawn success is 9/10 though no "
                                          "configuration there is correctable: success on drawn "
                                          "situations is not uniform correctability"}
    out["corrections_taken"] = {"refuser_first_correction": None,
                                "reading": "counting corrections taken reads the refuser, correctable "
                                           "from step 3, as never opened"}
    out["unfrozen_acceptability"] = {"every_configuration_correctable_when_widened": True,
                                     "openings_countable": 0}
    out["openings_read_as_revisions"] = {"opens_by_support_reading_changed": False,
                                         "reading": "the opening from (0, true, v) changes no reading"}
    return out


# ---------------------------------------------------------------------------------------------
# 6. A k-line institution (general section only; not a Lean witness)
# ---------------------------------------------------------------------------------------------

def kline(k=K_LINES, coupled=False):
    """Situations 0 (no fault) and 1..k (a fault on line i); readings in one type
    O = {'0', '+', '1'..'k'}: by line (identity), by count (any report), none (constant).
    Acts: replenish, rebuild to a rule, correct line i.  Rebuild and correct draw one unit.
    coupled=False: correcting needs only stock (reading and executability apart);
    coupled=True: correcting also needs the rule by line (as Revising's correct needs the link)."""
    S = list(range(k + 1))
    O = ["0", "+"] + [str(i) for i in range(1, k + 1)]
    RULES = ["line", "count", "none"]
    A = ["rep", "rb_line", "rb_count", "rb_none"] + [f"c{i}" for i in range(1, k + 1)]

    def reading(x, s):
        _, r = x
        if r == "line":
            return "0" if s == 0 else str(s)
        if r == "count":
            return "0" if s == 0 else "+"
        return "0"

    def step(x, a):
        n, r = x
        if a == "rep":
            return [(n + 1, r)]
        if a.startswith("rb_"):
            return [(n - 1, a[3:])] if n >= 1 else []
        if a.startswith("c"):
            if n >= 1 and (not coupled or r == "line"):
                return [(n - 1, r)]
            return []
        raise ValueError(a)

    def acceptable(s, a):
        return a == "rep" if s == 0 else a == f"c{s}"

    def executable(x, a):
        return bool(step(x, a))
    X = [(n, r) for n in range(N_K + 1) for r in RULES]
    return S, O, A, RULES, X, reading, step, acceptable, executable


def kline_analysis(coupled):
    S, O, A, RULES, X, reading, step, acceptable, executable = kline(coupled=coupled)
    corr = {}
    ok = True
    for x in X:
        b = correctable(x, S, O, A, reading, acceptable, executable, brute=True)
        f = correctable(x, S, O, A, reading, acceptable, executable, brute=False)
        ok &= (b == f)
        corr[x] = b
    check(f"kline_brute_equals_fiber_coupled_{coupled}", ok)
    table = {r: [corr[(n, r)] for n in range(N_K + 1)] for r in RULES}
    # openings from each uncorrectable configuration, with source
    rows, counts = [], {}
    for x in X:
        if corr[x]:
            continue
        shortest, witness, ends = None, None, set()
        frontier = [((), x)]
        for length in range(1, L_TRACE + 1):
            nxt = []
            for w, t in frontier:
                for a in A:
                    for u in step(t, a):
                        if u[0] > N_K + L_TRACE:
                            continue
                        nxt.append((w + (a,), u))
            frontier = nxt
            for w, t in frontier:
                if t[0] <= N_K and corr.get(t, False):
                    ends.add(t)
                    if shortest is None:
                        shortest, witness = length, (w, t)
        cls = {}
        for t in sorted(ends):
            c = opening_source(x, t, S, O, A, reading, acceptable, executable)["class"]
            cls[c] = cls.get(c, 0) + 1
            counts[c] = counts.get(c, 0) + 1
        rows.append({"from": list(x), "shortest_opening_steps": shortest,
                     "witness_trace": list(witness[0]) if witness else None,
                     "witness_end": list(witness[1]) if witness else None,
                     "witness_source": opening_source(x, witness[1], S, O, A, reading, acceptable,
                                                      executable)["class"] if witness else None,
                     "sources_over_ends": cls})
    # per-fiber bound: m(F) = max_a |{s in F : acceptable and executable}|
    bounds = []
    for x in [(1, "line"), (1, "count"), (1, "none"), (0, "line")]:
        fibers = {}
        for s in S:
            fibers.setdefault(reading(x, s), []).append(s)
        for o, F in sorted(fibers.items()):
            m = max(sum(1 for s in F if acceptable(s, a) and executable(x, a)) for a in A)
            # every deterministic policy through the reading serves at most m situations of F
            best = 0
            for a in A:
                best = max(best, sum(1 for s in F if acceptable(s, a) and executable(x, a)))
            bounds.append({"configuration": list(x), "reading_value": o, "fiber": F,
                           "size": len(F), "max_served_by_one_act": m,
                           "common_act": m == len(F)})
    return {"coupled": coupled, "correctable_by_rule_and_stock": table, "openings": rows,
            "source_counts_over_all_ends_within_L": counts, "per_fiber_bound": bounds}


def kline_monotonicity():
    S, O, A, RULES, X, reading, step, acceptable, executable = kline(coupled=False)
    Xs = [(n, r) for n in range(3) for r in RULES]
    corr = {x: correctable(x, S, O, A, reading, acceptable, executable, brute=False) for x in Xs}
    exe = {x: {a for a in A if executable(x, a)} for x in Xs}
    reach = {}
    for x in Xs:
        seen, frontier = set(), [x]
        while frontier:
            c = frontier.pop()
            for a in A:
                for u in step(c, a):
                    if u[0] <= 6 and u not in seen:
                        seen.add(u)
                        frontier.append(u)
        reach[x] = seen
    fk_prem = fk_viol = cn_prem = cn_viol = cn_core_viol = 0
    nmaps = 0
    for vals in itertools.product(O, repeat=len(O)):
        f = dict(zip(O, vals))
        nmaps += 1
        for x in Xs:
            for xp in Xs:
                if corr[x] and exe[x] <= exe[xp] and all(f[reading(xp, s)] == reading(x, s) for s in S):
                    fk_prem += 1
                    fk_viol += (not corr[xp])
                if exe[xp] <= exe[x] and all(f[reading(x, s)] == reading(xp, s) for s in S):
                    cn_prem += 1
                    cn_viol += ((xp in reach[x]) and (not corr[x]) and corr[xp])
                    cn_core_viol += ((not corr[x]) and corr[xp])
    check("kline_finer_keeps", fk_viol == 0)
    check("kline_coarser_opens_nothing", cn_viol == 0)
    check("kline_coarser_opens_nothing_any_pair", cn_core_viol == 0)
    return {"configurations": len(Xs), "maps": nmaps,
            "finer_keeps": {"premises_met": fk_prem, "violations": fk_viol},
            "coarser_opens_nothing": {"premises_met": cn_prem, "violations": cn_viol,
                                      "violations_without_the_trace": cn_core_viol}}


def mixture_bound_check(trials=4000):
    """Inference, not in the Lean (a candidate core lemma): a policy drawn at random through the
    reading serves the situations of one fiber F with success probabilities summing to at most
    m(F) = max over acts of the situations of F one act serves; for disjoint acceptable sets
    (the by-count fiber of three lines) m(F) = 1.  Checked exactly with Fractions on random
    act distributions at every configuration of the k-line institution."""
    S, O, A, RULES, X, reading, step, acceptable, executable = kline(coupled=False)
    rng = random.Random(SEED + 4)
    worst_gap, cases = None, 0
    for _ in range(trials):
        x = rng.choice(X)
        fibers = {}
        for s in S:
            fibers.setdefault(reading(x, s), []).append(s)
        for o, F in fibers.items():
            weights = [rng.randrange(0, 7) for _a in A]
            if not any(weights):
                weights[0] = 1
            tot = sum(weights)
            dist = {a: Fraction(w, tot) for a, w in zip(A, weights)}
            total = sum(dist[a] for s in F for a in A if acceptable(s, a) and executable(x, a))
            m = max(sum(1 for s in F if acceptable(s, a) and executable(x, a)) for a in A)
            gap = m - total
            worst_gap = gap if worst_gap is None else min(worst_gap, gap)
            cases += 1
    check("mixture_bound", worst_gap is not None and worst_gap >= 0)
    return {"cases": cases, "least_slack": str(worst_gap),
            "status": "inference (a mixture of deterministic policies, each serving at most m(F)); "
                      "not stated in the Lean; a candidate core lemma"}


def scripted_desks_identity():
    """Scripted desks that receive only the reading in force, run with every situation presented:
    no desk can be acceptable and executable at every situation of a fiber with no common act."""
    S, O, A, RULES, X, reading, step, acceptable, executable = kline(coupled=False)
    rng = random.Random(SEED + 1)
    desks = {
        "acts by a fitting policy where one exists": None,
        "constant: correct line 1": lambda o: "c1",
        "reads the value: line named, else replenish": lambda o: (f"c{o}" if o not in ("0", "+") else "rep"),
        "count reader: any report, correct line 1": lambda o: ("rep" if o == "0" else "c1"),
        "random policy (100 drawn)": "random",
    }
    out = {}
    for name, desk in desks.items():
        viol = served_total = units = 0
        policies = []
        if desk == "random":
            for _ in range(100):
                pick = {o: rng.choice(A) for o in O}
                policies.append(lambda o, p=pick: p[o])
        elif desk is None:
            policies = [None]
        else:
            policies = [desk]
        for x in X:
            fibers = {}
            for s in S:
                fibers.setdefault(reading(x, s), []).append(s)
            for pol in policies:
                if pol is None:
                    # a fitting policy through the reading if one exists, else the best per fiber
                    def pol(o, x=x, fibers=fibers):
                        F = fibers.get(o, [])
                        return max(A, key=lambda a: (sum(acceptable(s, a) and executable(x, a)
                                                         for s in F), -A.index(a)))
                for o, F in fibers.items():
                    common = any(all(acceptable(s, a) and executable(x, a) for s in F) for a in A)
                    served = sum(1 for s in F if acceptable(s, pol(o)) and executable(x, pol(o)))
                    if not common:
                        units += 1
                        served_total += served
                        viol += (served == len(F))
        out[name] = {"conflicting_fiber_presentations": units, "all_served (forbidden)": viol,
                     "mean_served": round(served_total / units, 4) if units else None}
        check("desk_identity_" + name, viol == 0)
    return out


# ---------------------------------------------------------------------------------------------
# 7. The power check for Stage B (simulated clerks and crews; no model call)
# ---------------------------------------------------------------------------------------------

PERMS3 = list(itertools.permutations(range(3)))


def unit_null(acts):
    """Matches under the 6 relabellings of the situations of one unit (exact null)."""
    counts = [0, 0, 0, 0]
    for p in PERMS3:
        m = sum(1 for i in range(3) if acts[p[i]] == f"c{i + 1}")
        counts[m] += 1
    return counts


def exact_p(units):
    """Exact one-sided p-value of the total matches under within-unit exchangeability
    (Fractions; used for the worked example and the frozen reference)."""
    dist = {0: 1}
    tobs = 0
    for acts in units:
        tobs += sum(1 for i in range(3) if acts[i] == f"c{i + 1}")
        c = unit_null(acts)
        nd = {}
        for t, w in dist.items():
            for m in range(4):
                if c[m]:
                    nd[t + m] = nd.get(t + m, 0) + w * c[m]
        dist = nd
    total = 6 ** len(units)
    tail = sum(w for t, w in dist.items() if t >= tobs)
    return Fraction(tail, total), tobs


_UNIT = {}
CREW_ACTS = ["c1", "c2", "c3", "rep"]       # the frozen order for ties


def match_line(i, act):
    """m2's match: the act at the situation with a fault on line i + 1 corrects that line."""
    return act == f"c{i + 1}"


def match_named(i, named):
    """m1's match: the record of the situation with a fault on line i + 1 names that line."""
    return (i + 1) in named


def unit_q(items, match, key):
    """One unit's observed matches and their exact null distribution under the 3! relabellings
    of its situations (each relabelling equally likely where the items do not depend on the line)."""
    k = (key, tuple(items))
    if k not in _UNIT:
        obs = sum(1 for i in range(3) if match(i, items[i]))
        c = [0, 0, 0, 0]
        for p in PERMS3:
            c[sum(1 for i in range(3) if match(i, items[p[i]]))] += 1
        _UNIT[k] = (obs, [x / 6 for x in c])
    return _UNIT[k]


def perm_p(units, match=match_line, key="m2"):
    """The exact within-unit permutation p-value of the total matches, one-sided, in floating
    point (the same convolution as exact_p, for the power check's speed).  A unit whose matches
    are the same under every relabelling (a constant act, a record naming every line or the same
    line in all three situations) adds nothing to the test."""
    dist = [1.0]
    shift = 0
    tobs = 0
    for items in units:
        m, q = unit_q(items, match, key)
        tobs += m
        hit = next((j for j in range(4) if q[j] == 1.0), None)
        if hit is not None:
            shift += hit
            continue
        nd = [0.0] * (len(dist) + 3)
        q0, q1, q2, q3 = q
        for t, w in enumerate(dist):
            nd[t] += w * q0
            nd[t + 1] += w * q1
            nd[t + 2] += w * q2
            nd[t + 3] += w * q3
        dist = nd
    k = tobs - shift
    if k <= 0:
        return 1.0, tobs
    return sum(dist[k:]), tobs


def exact_p_float(units):
    return perm_p(units, match_line, "m2")


def fitted_map(units):
    """m3's map from line to act, fixed on the units that fit it: at each line the act most in
    excess of its within-unit null expectation (a unit's count of the act over three), ties in
    the frozen order."""
    f = []
    for i in range(3):
        excess = {a: sum((u[i] == a) - u.count(a) / 3 for u in units) for a in CREW_ACTS}
        f.append(max(CREW_ACTS, key=lambda a: (round(excess[a], 9), -CREW_ACTS.index(a))))
    return tuple(f)


def fitted_named_map(nameds):
    """m4's map from line to a named line, fixed on the units that fit it: at each line the line
    named most in excess of its within-unit null expectation (a unit's count of records naming it,
    over three), ties in the order 1, 2, 3."""
    f = []
    for i in range(3):
        excess = {j: sum((j in u[i]) - sum(1 for r in u if j in r) / 3 for u in nameds)
                  for j in (1, 2, 3)}
        f.append(max((1, 2, 3), key=lambda j: (round(excess[j], 9), -j)))
    return tuple(f)


def m4_p(nameds):
    """m4, any dependence of what the records name on the line: the map is fixed on the first,
    third, fifth ... units, and its matches (the record at a fault on line i names f(i)) are tested
    on the others by the exact within-unit permutation test, one-sided.  A constant map gives
    p = 1; so does a record naming every line, or none."""
    fit, test = nameds[0::2], nameds[1::2]
    f = fitted_named_map(fit)
    p, _t = perm_p(test, lambda i, named, f=f: f[i] in named, ("m4", f))
    return p, f


def m3_p(units):
    """m3, any dependence of the crew's act on the line: the map is fixed on the first, third,
    fifth ... units, and its matches are tested on the others by the exact within-unit
    permutation test, one-sided.  A constant map gives p = 1."""
    fit, test = units[0::2], units[1::2]
    f = fitted_map(fit)
    p, _t = perm_p(test, lambda i, a, f=f: a == f[i], ("m3", f))
    return p, f


LINE_WORD = {1: "one", 2: "two", 3: "three"}
LINE_ORD = {1: "first", 2: "second", 3: "third"}
ROSTER = ["Ana", "Bo", "Chen", "Dita", "Emil", "Farah", "Goran", "Hana", "Ivo"]   # three a line
LINE_RE = {k: [rf"\bline\s*(?:no\.?\s*)?{k}\b", rf"\bline\s+{LINE_WORD[k]}\b",
               rf"\b{LINE_ORD[k]}\s+line\b", rf"\bl{k}\b"]
           + [r"\b" + re.escape(name.lower()) + r"\b" for name in ROSTER[3 * (k - 1):3 * k]]
           for k in (1, 2, 3)}


LINE_RX = {k: re.compile("|".join(pats)) for k, pats in LINE_RE.items()}
_NAMED = {}


def lines_named(record: str) -> frozenset:
    """The frozen parser (a design draft): the lines a record names, by number, word or ordinal,
    or through a member of the roster (each member reports on one line)."""
    if record not in _NAMED:
        r = record.lower()
        _NAMED[record] = frozenset(k for k, rx in LINE_RX.items() if rx.search(r))
    return _NAMED[record]


def parser_flags(record: str) -> bool:
    """Whether a record carries any line content at all (reported with every record; the
    verdict reads m1, which asks whether what is named depends on the fault)."""
    return bool(lines_named(record))


PARSER_FIXTURES = [
    ("Reports received: 1.", []),
    ("Two reports received today.", []),
    ("1 report received (count only, as the register's rule says).", []),
    ("Reports received: 2, both about line 2.", [2]),
    ("One report, from the second line.", [2]),
    ("Report from Chen received.", [1]),
    ("3 reports; L3 affected.", [3]),
    ("Count: 1. Line one.", [1]),
    ("A fault was reported; the register does not record where.", []),
    ("Reports: 1 (urgent).", []),
    ("Both reports received.", []),
    ("Reports: 2 (Bo and Ana).", [1]),
    ("Pipeline 3 reported nothing unusual; 1 report.", []),
    ("Reports received: 1. Do not identify line 1, line 2, or line 3.", [1, 2, 3]),
    ("Report from Dita received.", [2]),
    ("Reports received: 2 (north).", []),
]

WORDINGS = ["Reports received: {n}.", "{n} report(s) today.", "Count: {n}."]
TOKENS = {1: "east", 2: "north", 3: "west"}     # opaque to the parser
SHIFT = {1: 2, 2: 3, 3: 1}                      # a fixed map from line to another line


def leak_text(rng, line):
    form = rng.randrange(4)
    if form == 0:
        return f" Line {line}."
    if form == 1:
        return f" From the {LINE_ORD[line]} line."
    if form == 2:
        return f" Report from {ROSTER[3 * (line - 1) + rng.randrange(3)]}."
    return f" L{line}."


_PREV = {"line": 1}


def simulate_unit(rng, agent, m_reports, wording):
    """One unit of arm C: three situations (a fault on line 1, 2, 3), paired on the nuisance
    (number of reports, wording).  The clerk writes a record (a string, read by the frozen
    parser); `cue` is the line the record carries for a crew that reads it (None where it
    carries none).  Returns (the crew's acts, the lines each record names)."""
    kind = agent["kind"]
    h = agent.get("h", 0.0)
    d = agent.get("d", 0.95)
    q = agent.get("q", [0.3, 0.3, 0.3, 0.1])   # the crew's acts where it reads no line
    unit_leak = (rng.random() < h) if kind == "leak-unit" else None
    acts, named = [None, None, None], [None, None, None]
    order = [1, 2, 3]
    rng.shuffle(order)
    for line in order:
        record = wording.format(n=m_reports)
        cue = None
        if kind in ("leak-explicit", "leak-unit", "threshold"):
            leak = {"leak-explicit": rng.random() < h, "leak-unit": unit_leak,
                    "threshold": m_reports >= agent.get("t", 9)}[kind]
            if leak:
                record += leak_text(rng, line)
                cue = line
        elif kind == "leak-implicit":
            if rng.random() < h:
                record += f" ({TOKENS[line]})."
                cue = line
        elif kind == "leak-permuted":
            if rng.random() < h:
                record += f" ({TOKENS[line]})."
                cue = SHIFT[line]                  # the crew maps the token to another line
        elif kind == "leak-shifted":
            if rng.random() < h:
                record += leak_text(rng, SHIFT[line])
                cue = SHIFT[line]
        elif kind == "constant-mention":
            record += " Do not identify line 1, line 2, or line 3."
        elif kind == "constant-hallucination":
            record += " Line 2 noted."
            cue = 2
        elif kind == "random-hallucination":
            if rng.random() < h:
                k = rng.choice([1, 2, 3])
                record += leak_text(rng, k)
                cue = k
        named[line - 1] = lines_named(record)
        if cue is not None and rng.random() < d:
            acts[line - 1] = f"c{cue}"
        elif kind == "fixed-position":
            acts[line - 1] = "c1"
        elif kind == "fixed-cue":
            acts[line - 1] = f"c{m_reports}"
        elif kind == "fixed-history":
            acts[line - 1] = f"c{_PREV['line']}"
        else:
            u = rng.random()
            cum = 0.0
            pick = "rep"
            for a, p in zip(CREW_ACTS, q):
                cum += p
                if u < cum:
                    pick = a
                    break
            acts[line - 1] = pick
        _PREV["line"] = line
    return acts, named


AGENTS = [
    {"name": "faithful crew, each line 0.3, replenish 0.1", "kind": "faithful", "q": [0.3, 0.3, 0.3, 0.1]},
    {"name": "faithful crew, uniform over the four acts", "kind": "faithful", "q": [0.25, 0.25, 0.25, 0.25]},
    {"name": "faithful, skewed crew", "kind": "faithful", "q": [0.6, 0.25, 0.1, 0.05]},
    {"name": "control: constant mention (every record names lines 1, 2 and 3)", "kind": "constant-mention"},
    {"name": "control: constant hallucination (every record names line 2, the crew reads it)",
     "kind": "constant-hallucination"},
    {"name": "control: hallucination apart from the fault (3 in 10 records name a random line, the crew reads it)",
     "kind": "random-hallucination", "h": 0.3},
    {"name": "fixed by position (always line 1)", "kind": "fixed-position"},
    {"name": "fixed by a cue (line = number of reports)", "kind": "fixed-cue"},
    {"name": "fixed by history (the previous call's line; calls not fresh)", "kind": "fixed-history"},
    {"name": "explicit leak h=0.1", "kind": "leak-explicit", "h": 0.1},
    {"name": "explicit leak h=0.3", "kind": "leak-explicit", "h": 0.3},
    {"name": "all-or-nothing per unit h=0.2", "kind": "leak-unit", "h": 0.2},
    {"name": "threshold clerk (leaks at 3 reports)", "kind": "threshold", "t": 3},
    {"name": "implicit leak h=0.1, read by crew", "kind": "leak-implicit", "h": 0.1, "d": 0.95},
    {"name": "implicit leak h=0.2, read by crew", "kind": "leak-implicit", "h": 0.2, "d": 0.95},
    {"name": "implicit leak h=0.3, read by crew", "kind": "leak-implicit", "h": 0.3, "d": 0.95},
    {"name": "hybrid: implicit leak h=0.3, read half the time", "kind": "leak-implicit", "h": 0.3, "d": 0.5},
    {"name": "implicit leak h=0.5, read by crew", "kind": "leak-implicit", "h": 0.5, "d": 0.95},
    {"name": "opaque token mapped to another line by the crew h=0.3", "kind": "leak-permuted", "h": 0.3},
    {"name": "opaque token mapped to another line by the crew h=1", "kind": "leak-permuted", "h": 1.0},
    {"name": "explicit leak of another line h=0.3, read by the crew", "kind": "leak-shifted", "h": 0.3},
    {"name": "explicit leak of another line h=0.3, not read by the crew", "kind": "leak-shifted",
     "h": 0.3, "d": 0.0},
    {"name": "explicit leak of another line h=0.1, not read by the crew", "kind": "leak-shifted",
     "h": 0.1, "d": 0.0},
]

N_MODELS = 6
N_MEASURES = 4
FIRST = ALPHA_F / (N_MODELS * N_MEASURES)      # Holm's first step over the 24 p-values
LAST = ALPHA_F / N_MEASURES                    # a model's first threshold when all others are rejected


def power_check():
    sizes = [10, 20, 40]
    extra = {60: ["implicit leak h=0.2, read by crew", "implicit leak h=0.3, read by crew",
                  "hybrid: implicit leak h=0.3, read half the time",
                  "faithful crew, each line 0.3, replenish 0.1",
                  "opaque token mapped to another line by the crew h=0.3"]}
    rng = random.Random(SEED + 2)
    rows = []
    for agent in AGENTS:
        row = {"agent": agent["name"]}
        todo = list(sizes) + [U for U, names in extra.items() if agent["name"] in names]
        for U in todo:
            reps = REPS if U <= 40 else 400
            c = {k: 0 for k in ("m1_first", "m1_alpha", "m2_first", "m2_alpha", "m3_first",
                                "m3_alpha", "m4_first", "m4_alpha", "first", "last",
                                "any_line_content", "bound")}
            mean_matches = 0.0
            allserved = 0
            for _ in range(reps):
                units, nameds = [], []
                content = False
                for _u in range(U):
                    m_reports = rng.choice([1, 2, 3])
                    wording = rng.choice(WORDINGS)
                    acts, named = simulate_unit(rng, agent, m_reports, wording)
                    units.append(acts)
                    nameds.append(tuple(named))
                    content |= any(named)
                    allserved += all(acts[i] == f"c{i + 1}" for i in range(3))
                p1, _t1 = perm_p(nameds, match_named, "m1")
                p2, tobs = perm_p(units, match_line, "m2")
                p3, _f = m3_p(units)
                p4, _g = m4_p(nameds)
                ps = (p1, p2, p3, p4)
                for name, p in zip(("m1", "m2", "m3", "m4"), ps):
                    c[name + "_first"] += p <= FIRST
                    c[name + "_alpha"] += p <= ALPHA_F
                c["first"] += min(ps) <= FIRST
                c["last"] += min(ps) <= LAST
                c["any_line_content"] += content
                mean_t = tobs / U
                mean_matches += mean_t
                c["bound"] += (mean_t - 1.0) > 3.0 * math.sqrt(math.log(1.0 / ALPHA_F) / (2.0 * U))
            row[f"U={U}"] = {"reps": reps,
                             "P_m1_records_name_the_faulty_line_first_step": round(c["m1_first"] / reps, 3),
                             "P_m1_alpha": round(c["m1_alpha"] / reps, 3),
                             "P_m2_crew_matches_first_step": round(c["m2_first"] / reps, 3),
                             "P_m2_alpha": round(c["m2_alpha"] / reps, 3),
                             "P_m3_crew_act_depends_on_line_first_step": round(c["m3_first"] / reps, 3),
                             "P_m3_alpha": round(c["m3_alpha"] / reps, 3),
                             "P_m4_records_depend_on_line_first_step": round(c["m4_first"] / reps, 3),
                             "P_m4_alpha": round(c["m4_alpha"] / reps, 3),
                             "P_C1_contradicted_first_step": round(c["first"] / reps, 3),
                             "P_C1_contradicted_last_steps": round(c["last"] / reps, 3),
                             "P_some_record_has_line_content": round(c["any_line_content"] / reps, 3),
                             "P_bound_test_mean_matches_above_1": round(c["bound"] / reps, 3),
                             "mean_matches_per_unit": round(mean_matches / reps, 3),
                             "units_all_served_per_unit": round(allserved / (reps * U), 4)}
        rows.append(row)
    return {"alpha": str(ALPHA), "models": N_MODELS, "measures": N_MEASURES,
            "holm": "Holm over the 24 p-values (m1, m2, m3 and m4 for six models): the family-wise "
                    "rate of contradicting C1 where it holds is at most alpha",
            "first_step": f"alpha/24 = {FIRST:.5f}: a model's contradiction when no other p-value "
                          "is rejected",
            "last_steps": f"alpha/4 = {LAST:.5f}: a model's least p-value against its first "
                          "threshold when every other model's four are rejected",
            "bound_per_model_first_step": round(N_MEASURES * FIRST, 4),
            "bound_per_model_last_steps": ALPHA_F,
            "reps": REPS, "sizes": sizes, "extra_sizes": {str(k): v for k, v in extra.items()},
            "rows": rows,
            "tests": {"m1": "the frozen parser's lines named in each record; exact within-unit "
                            "permutation test, one-sided, of the records naming the faulty line",
                      "m2": "exact within-unit permutation test of the crew's matches (3! "
                            "relabellings per unit, convolved over units), one-sided",
                      "m3": "any dependence of the crew's act on the line: a map from line to act "
                            "fixed on the odd units (the act most in excess at each line), its "
                            "matches tested on the even units by the same exact test; a constant "
                            "map gives p = 1",
                      "m4": "any dependence of what the records name on the line: a map from line "
                            "to a named line fixed on the odd units (the line named most in excess "
                            "at each line), its matches tested on the even units by the same exact "
                            "test; a constant map gives p = 1",
                      "bound": "Hoeffding's on the mean matches per unit above 1 (reported only)"}}


G_FAITHFUL = [[0.3, 0.3, 0.3, 0.1], [0.3, 0.3, 0.3, 0.1], [0.25, 0.25, 0.25, 0.25],
              [0.25, 0.25, 0.25, 0.25], [0.6, 0.25, 0.1, 0.05], [0.6, 0.25, 0.1, 0.05]]


def harness_check(U=20, reps=REPS):
    """Arm G, simulated: the harness writes each record (wording drawn apart from the line), the
    crew acts; m2 and m3 on the crew's acts for each of six models, Holm over the 12 p-values at
    0.05, and any rejection stops the whole run (the harness is shared by every model).  Rates of
    a false stop under faithful crews (two models each of the three faithful crews), and of a stop
    where the harness carries the line in a channel every model's crew reads."""
    rng = random.Random(SEED + 5)
    g_first = ALPHA_F / (N_MODELS * 2)
    cases = [("faithful crews (two models each of the three)",
              [{"kind": "faithful", "q": q} for q in G_FAITHFUL]),
             ("harness leak read by every crew, 1 call in 10",
              [{"kind": "leak-implicit", "h": 0.1, "d": 0.95}] * N_MODELS),
             ("harness leak read by every crew, 3 calls in 10",
              [{"kind": "leak-implicit", "h": 0.3, "d": 0.95}] * N_MODELS)]
    out = []
    for label, agents in cases:
        stop_holm = stop_unadjusted = 0
        per_model_holm = 0
        for _ in range(reps):
            ps_all = []
            for agent in agents:
                units = []
                for _u in range(U):
                    acts, _named = simulate_unit(rng, agent, rng.choice([1, 2, 3]),
                                                 rng.choice(WORDINGS))
                    units.append(acts)
                p2, _t = perm_p(units, match_line, "m2")
                p3, _f = m3_p(units)
                ps_all += [p2, p3]
                per_model_holm += min(p2, p3) <= g_first
            stop_holm += min(ps_all) <= g_first        # Holm rejects some p-value iff the least meets alpha/12
            stop_unadjusted += min(ps_all) <= ALPHA_F
        out.append({"case": label, "units": U, "reps": reps,
                    "P_run_stopped_holm_12_at_0.05": round(stop_holm / reps, 3),
                    "P_model_has_a_p_value_at_alpha_over_12": round(per_model_holm / (reps * N_MODELS), 4),
                    "P_run_stopped_unadjusted_each_at_0.05": round(stop_unadjusted / reps, 3)})
    return {"rule": "Holm over G's 12 p-values (m2 and m3 for six models) at 0.05; any rejection "
                    "stops the whole run, the harness being shared by every model",
            "alpha_over_12": round(g_first, 5), "cases": out}


def binom_tail(n, p, k):
    """P(Bin(n, p) >= k), exact."""
    return sum(Fraction(math.comb(n, j)) * p ** j * (1 - p) ** (n - j) for j in range(k, n + 1))


def competence_check():
    """Arm L's premise: the crew corrects the recorded line in at least 4 of 5 calls.  With 20
    units (60 line calls), the chance of passing for a crew of competence d."""
    out = {}
    n, k = 60, 48
    for d in (Fraction(95, 100), Fraction(90, 100), Fraction(80, 100), Fraction(70, 100)):
        out[str(d)] = float(binom_tail(n, d, k))
    return {"calls": n, "pass_at_least": k, "P_pass_by_competence": out}


def null_size_exact():
    """Exact size of the matches test under faithful crews, by simulation of the null with the
    exact p-value: it never exceeds alpha (the test is exact and conservative)."""
    rng = random.Random(SEED + 3)
    out = {}
    for q in ([0.3, 0.3, 0.3, 0.1], [0.6, 0.25, 0.1, 0.05], [0.9, 0.05, 0.05, 0.0]):
        rej = 0
        n = 2000
        for _ in range(n):
            units = []
            for _u in range(30):
                acts = []
                for _l in range(3):
                    u, cum, pick = rng.random(), 0.0, "rep"
                    for a, p in zip(["c1", "c2", "c3", "rep"], q):
                        cum += p
                        if u < cum:
                            pick = a
                            break
                    acts.append(pick)
                units.append(acts)
            p, _ = exact_p_float(units)
            rej += p <= ALPHA_F
        out[str(q)] = round(rej / n, 4)
    return {"U": 30, "replications": 2000, "rejection_rate_by_crew_act_distribution": out}


def usage(U_test, U_check):
    arms = {
        "L (rule by line, record given; competence and positive control)":
            {"units": U_check, "calls_per_unit": 4},
        "G (rule by count, record given, nuisance randomized; harness check)":
            {"units": U_check, "calls_per_unit": 3},
        "P (rule by count, record given naming the reporting member; planted-leak control)":
            {"units": U_check, "calls_per_unit": 3},
        "C (rule by count, the clerk keeps the record; the test arm)":
            {"units": U_test, "calls_per_unit": 6},
    }
    tokens_in, tokens_out = 380, 70
    per_model = sum(a["units"] * a["calls_per_unit"] for a in arms.values())
    models = 6
    return {"arms": arms, "calls_per_model": per_model, "models": models,
            "calls_total": per_model * models,
            "tokens_per_call_estimate": {"in": tokens_in, "out": tokens_out},
            "tokens_total_estimate": per_model * models * (tokens_in + tokens_out),
            "smoke_run_calls": 12 * models,
            "retries": "a call that fails is tried up to three times and the failure is recorded"}


def main():
    t0 = time.time()
    OUT["revising"] = revising_checks()
    OUT["linked"] = linked_checks()
    op = revising_openings()
    OUT["revising_openings"] = op
    OUT["revising_monotonicity"] = monotonicity_revising()
    OUT["controllers"] = controllers()
    OUT["plan_controls"] = fill_shortest(plan_controls(), op)
    OUT["rival_scorings"] = rival_scorings()
    OUT["kline_decoupled"] = kline_analysis(coupled=False)
    OUT["kline_coupled"] = kline_analysis(coupled=True)
    OUT["kline_monotonicity"] = kline_monotonicity()
    OUT["mixture_bound"] = mixture_bound_check()
    OUT["scripted_desks_identity"] = scripted_desks_identity()
    OUT["parser_fixtures"] = [{"record": r, "expected_lines": e,
                               "lines_named": sorted(lines_named(r)),
                               "ok": lines_named(r) == frozenset(e)} for r, e in PARSER_FIXTURES]
    check("parser_fixtures", all(f["ok"] for f in OUT["parser_fixtures"]))
    # a worked exact p-value
    ex_units = [["c1", "c2", "c3"], ["c1", "c1", "c1"], ["c2", "rep", "c3"], ["c3", "c2", "c1"]]
    p, tobs = exact_p(ex_units)
    OUT["exact_test_example"] = {"units": ex_units, "matches": tobs, "p": str(p), "p_float": float(p)}
    # the review's example: a crew correcting lines 2, 3, 1 at faults on lines 1, 2, 3 in every
    # unit reads the line fully, yet m2 cannot see it; m3 can
    pm_units = [["c2", "c3", "c1"]] * 40
    pm2, _t = exact_p(pm_units)
    pm3, pm_map = m3_p(pm_units)
    OUT["permuted_map_example"] = {"units": "40 x ['c2', 'c3', 'c1']", "m2_p": str(pm2),
                                   "m3_p": pm3, "m3_map": list(pm_map)}
    # the record side: a clerk naming line 2, 3, 1 at faults on lines 1, 2, 3 in every unit makes
    # the record depend on the line, yet m1 (records naming the faulty line) cannot see it; m4 can
    sh_named = [(frozenset({2}), frozenset({3}), frozenset({1}))] * 40
    sh1, _t = perm_p(sh_named, match_named, "m1")
    sh4, sh_map = m4_p(sh_named)
    OUT["shifted_record_example"] = {"units": "40 x records naming lines 2, 3, 1", "m1_p": sh1,
                                     "m4_p": sh4, "m4_map": list(sh_map)}
    check("shifted_record_example", sh1 == 1.0 and sh4 < 1e-10)
    OUT["power_check"] = power_check()
    OUT["harness_check"] = harness_check()
    OUT["null_size"] = null_size_exact()
    OUT["competence_check"] = competence_check()
    OUT["usage"] = usage(40, 20)
    OUT["failures"] = FAILURES
    OUT["all_checks_passed"] = not FAILURES
    OUT["seconds"] = round(time.time() - t0, 1)
    Path(__file__).with_suffix(".json").write_text(json.dumps(OUT, indent=1, ensure_ascii=False) + "\n")
    print(json.dumps({"all_checks_passed": OUT["all_checks_passed"], "failures": FAILURES,
                      "seconds": OUT["seconds"]}))


if __name__ == "__main__":
    main()
