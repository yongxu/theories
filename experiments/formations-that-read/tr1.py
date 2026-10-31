"""TR1 (RF1, what choices show of an order), Stage 0: exact values, mirror checks, simulated
choosers and the power check. RF-M's mechanism (acts-alike-from-a-model-or-from-an-order) is
carried here as its exact table and the optional informing variant's power.

Design work only: no model call, no download, no network, no trained system. Python 3.11,
standard library. Deterministic: exact values as fractions.Fraction, simulations from
random.Random seeded with frozen strings. Writes tr1.json next to itself.

    python3 -B tr1.py            # the whole of Stage 0, about three minutes on one core

Parts
  A  A mirror of Becoming.ShownOrder (ChoiceOccasions, Shown, Accords, AccordsWeakly, PicksOpen,
     reach «及», no cycle «无环», withPair), checked against the Lean's evaluated witness (Untried)
     and by enumeration: every relation on three alternatives with every family of up to three
     occasions; transitive relations on four; strict orders on five by extension.
  B  A mirror of ReadingLoop's Loop and Untested witness, checked against the Lean's evaluated
     courses; floor_forgoes over classes of small formations; the general forms the design uses
     (inferences, checked by enumeration, candidate core lemmas); the identification table and
     the power of the informing variant's one verdict (RF1 across frames).
  C  Exact anchors: random tournaments, a trembling order on pairs, the stability rule, the share
     of pick patterns the one-order claim allows on each design (Selten's area).
  D  The candidate designs and their exact P1 structure under every hidden order; the simulated
     choosers (the law's model with noise, readers fixed by what they read, menu-dependent,
     limited attention, mixtures, hybrids, ties, history readers); the power check, which reads
     each chooser as void, contradicted or passed by the candidate frozen rules, sweeps the
     repetitions r and the stability threshold q on the primary design (D5q), and takes the
     cheapest (r, q) meeting the criterion (the law's model with tolerated noise contradicted at
     most 0.05 and void at most 0.05; near-ties contradicted at most 0.05; every rival passing at
     most 0.2).
  E  The questions Stage 0 settles and the choices left for the freeze.

Conventions. Alternatives are 0..n-1. A relation is a list of row bitmasks: bit j of row i means
"i above j" (the Lean's P i j). An occasion is (menu bitmask, pick). Shown x y: some occasion picks
x while y, another, is open. Nothing here is new mathematics; every check mirrors a statement the
Lean proves, or is labelled an inference (a general form the Lean does not state).
"""

import itertools
import json
import math
import random
import statistics
import sys
import time
from fractions import Fraction
from pathlib import Path

SEED = "TR1-stage0-2026-10-31"
OUT = Path(__file__).with_suffix(".json")
T0 = time.time()


def fr(x):
    """A Fraction as a string, with its float, for the JSON."""
    x = Fraction(x)
    return {"exact": f"{x.numerator}/{x.denominator}" if x.denominator != 1 else str(x.numerator),
            "float": float(x)}


def rate(k, n):
    return round(k / n, 4) if n else None


# ---------------------------------------------------------------------------------------------
# A. The mirror of Becoming.ShownOrder
# ---------------------------------------------------------------------------------------------

def closure(rows):
    """Reach «及»: the transitive closure (Warshall), on row bitmasks."""
    r = list(rows)
    n = len(r)
    for k in range(n):
        bk = 1 << k
        for i in range(n):
            if r[i] & bk:
                r[i] |= r[k]
    return r


def no_cycle(rows):
    """«无环»: nothing reaches itself."""
    c = closure(rows)
    return not any(c[i] >> i & 1 for i in range(len(c)))


def shown(family, n):
    """ChoiceOccasions.Shown: x above y where some occasion picks x while y, another, is open."""
    rows = [0] * n
    for menu, pick in family:
        rows[pick] |= menu & ~(1 << pick)
    return rows


def accords(family, P):
    """Accords: at every occasion the pick stands above every other open alternative."""
    for menu, pick in family:
        need = menu & ~(1 << pick)
        if P[pick] & need != need:
            return False
    return True


def accords_weakly(family, P):
    """AccordsWeakly: at every occasion nothing open stands above the pick."""
    for menu, pick in family:
        for y in range(len(P)):
            if menu >> y & 1 and P[y] >> pick & 1:
                return False
    return True


def picks_open(family):
    return all(menu >> pick & 1 for menu, pick in family)


def with_pair(R, x, y):
    """withPair R x y: R with the pair (x, y) added."""
    r = list(R)
    r[x] |= 1 << y
    return r


def is_irreflexive(P):
    return not any(P[i] >> i & 1 for i in range(len(P)))


def is_transitive(P):
    return closure(P) == list(P)


def contains(P, Q):
    """«则» Q P: every pair of Q is in P."""
    return all(Q[i] & ~P[i] == 0 for i in range(len(P)))


def rows_from_index(idx, n):
    return [(idx >> (i * n)) & ((1 << n) - 1) for i in range(n)]


def subsets(n):
    return list(range(1 << n))


def mirror_untried():
    """ShownOrder.Untried: three alternatives, one occasion, first and second open, first chosen."""
    FIRST, SECOND, THIRD = 0, 1, 2
    occ = [((1 << FIRST) | (1 << SECOND), FIRST)]
    S = shown(occ, 3)
    reach = closure(S)
    res = {}
    res["shown_is_first_second"] = S == [1 << SECOND, 0, 0]
    res["reach_first_second"] = reach == [1 << SECOND, 0, 0]
    res["noCycle"] = no_cycle(S)
    # met_fixed: every according relation, strict or not, puts first above second (all 512)
    ok = True
    strict_first_third = strict_third_first = False
    for idx in range(1 << 9):
        P = rows_from_index(idx, 3)
        if accords(occ, P):
            ok &= bool(P[FIRST] >> SECOND & 1)
            if is_irreflexive(P) and is_transitive(P):
                strict_first_third |= bool(P[FIRST] >> THIRD & 1)
                strict_third_first |= bool(P[THIRD] >> FIRST & 1)
    res["met_fixed"] = ok
    res["untried_free"] = strict_first_third and strict_third_first

    # The search, with the two orders as decisions (aboveFirst: first > third > second;
    # aboveThird: third > first > second), as the Lean's tables.
    aboveFirst = {(0, 1): True, (0, 2): True, (2, 1): True}
    aboveThird = {(0, 1): True, (2, 0): True, (2, 1): True}

    def above(t):
        return lambda a, b: t.get((a, b), False)

    def same(a, b):
        return a == b

    def search(ab, menu):
        for a in menu:  # List.find? on the menu
            if all(same(b, a) or ab(a, b) for b in menu):  # List.all
                return a
        return None

    aF, aT = above(aboveFirst), above(aboveThird)

    def strict_table(ab):
        irr = all(not ab(a, a) for a in range(3))
        tra = all(not (ab(a, b) and ab(b, c)) or ab(a, c)
                  for a in range(3) for b in range(3) for c in range(3))
        return irr and tra

    res["aboveFirst_strict"] = strict_table(aF)
    res["aboveThird_strict"] = strict_table(aT)
    PF = [sum(1 << b for b in range(3) if aF(a, b)) for a in range(3)]
    PT = [sum(1 << b for b in range(3) if aT(a, b)) for a in range(3)]
    res["both_accord"] = accords(occ, PF) and accords(occ, PT)
    res["same_search_met"] = (search(aF, [FIRST, SECOND]) == FIRST
                              and search(aT, [FIRST, SECOND]) == FIRST)
    res["same_search_after"] = (search(aF, [FIRST, THIRD]) == FIRST
                                and search(aT, [FIRST, THIRD]) == THIRD)
    # Beyond the witness (not in the Lean, which evaluates two lists): on all 15 nonempty lists
    # of distinct alternatives the search returns the top of each order, a finite check only.
    tops = True
    for k in range(1, 4):
        for lst in itertools.permutations(range(3), k):
            for ab, order in ((aF, [0, 2, 1]), (aT, [2, 0, 1])):
                top = min(lst, key=order.index)
                tops &= search(ab, list(lst)) == top
    res["search_returns_top_on_all_15_lists_(finite_check_beyond_the_Lean)"] = tops
    res["all_witness_checks_pass"] = all(v for k, v in res.items())
    return res


def mirror_enumeration_n3():
    """Every relation on three alternatives (512) against every family of up to three occasions
    (2,925 multisets of the 24 occasions: any menu, the empty one included, and any pick, open or
    not, since no general law assumes PicksOpen)."""
    n = 3
    R_ALL = [rows_from_index(i, n) for i in range(1 << 9)]
    TRANS = 0
    STRICT = 0
    for i, P in enumerate(R_ALL):
        if is_transitive(P):
            TRANS |= 1 << i
            if is_irreflexive(P):
                STRICT |= 1 << i
    HAS = {}
    for x in range(n):
        for y in range(n):
            HAS[(x, y)] = sum(1 << i for i, P in enumerate(R_ALL) if P[x] >> y & 1)
    occasions = [(menu, pick) for menu in subsets(n) for pick in range(n)]
    ACC = {}
    WACC = {}
    for o in occasions:
        ACC[o] = sum(1 << i for i, P in enumerate(R_ALL) if accords([o], P))
        WACC[o] = sum(1 << i for i, P in enumerate(R_ALL) if accords_weakly([o], P))
    EMPTY_REL = 0  # index 0 is the empty relation
    counts = dict(families=0, acyclic=0, cyclic=0, picks_not_open=0)
    fails = []
    for size in range(0, 4):
        for fam in itertools.combinations_with_replacement(occasions, size):
            fam = list(fam)
            counts["families"] += 1
            if not picks_open(fam):
                counts["picks_not_open"] += 1
            S = shown(fam, n)
            reach = closure(S)
            acyclic = no_cycle(S)
            counts["acyclic" if acyclic else "cyclic"] += 1
            A = (1 << 512) - 1
            W = (1 << 512) - 1
            for o in fam:
                A &= ACC[o]
                W &= WACC[o]
            # shown_accords, reach_accords
            if not accords(fam, S) or not accords(fam, reach):
                fails.append(("shown/reach_accords", fam))
            # reach_within: every transitive according P contains the reach
            for x in range(n):
                for y in range(n):
                    if reach[x] >> y & 1 and (A & TRANS & ~HAS[(x, y)]):
                        fails.append(("reach_within", fam))
            # accorded_iff_noCycle
            if bool(A & STRICT) != acyclic:
                fails.append(("accorded_iff_noCycle", fam))
            AS = A & STRICT
            for x in range(n):
                for y in range(n):
                    every = (AS & ~HAS[(x, y)]) == 0
                    if acyclic:
                        # above_in_every_iff_reach
                        if every != bool(reach[x] >> y & 1):
                            fails.append(("above_in_every_iff_reach", fam, x, y))
                        # above_in_some_of_unreached, with the Lean's witness order
                        if x != y and not reach[y] >> x & 1:
                            if not (AS & HAS[(x, y)]):
                                fails.append(("above_in_some_of_unreached", fam, x, y))
                            Wt = closure(with_pair(S, x, y))
                            if not (is_irreflexive(Wt) and is_transitive(Wt) and accords(fam, Wt)
                                    and Wt[x] >> y & 1):
                                fails.append(("witness reach(withPair)", fam, x, y))
                        # both_ways_of_unreached
                        if x != y and not reach[x] >> y & 1 and not reach[y] >> x & 1:
                            if not (AS & HAS[(x, y)]) or not (AS & HAS[(y, x)]):
                                fails.append(("both_ways_of_unreached", fam, x, y))
                    else:
                        # with a cycle no strict order accords: the universal side is vacuous
                        if not every:
                            fails.append(("vacuous with a cycle", fam, x, y))
                    # weakly_forces_no_comparison: the empty relation is strict and accords
                    # weakly with every family, cyclic ones included
                    if not (W >> EMPTY_REL & 1):
                        fails.append(("weakly_forces_no_comparison", fam))
            if acyclic:
                # top_in_every_iff_reach, for every N and x
                for N in subsets(n):
                    for x in range(n):
                        need = N & ~(1 << x)
                        left = all((AS & ~HAS[(x, y)]) == 0 for y in range(n) if need >> y & 1)
                        right = reach[x] & need == need
                        if left != right:
                            fails.append(("top_in_every_iff_reach", fam, N, x))
                # above_in_class_of_every on three classes: the empty class, one member, all
                members = [i for i in range(512) if AS >> i & 1]
                for cls in ([], members[:1], members):
                    for x in range(n):
                        for y in range(n):
                            if (AS & ~HAS[(x, y)]) == 0:
                                if not all(R_ALL[i][x] >> y & 1 for i in cls):
                                    fails.append(("above_in_class_of_every", fam))
    # reach_withPair_iff and noCycle_withPair_iff on every relation on three alternatives
    wp_checked = 0
    for R in R_ALL:
        cR = closure(R)
        acR = no_cycle(R)
        for x in range(n):
            for y in range(n):
                cW = closure(with_pair(R, x, y))
                for a in range(n):
                    for b in range(n):
                        left = bool(cW[a] >> b & 1)
                        right = bool(cR[a] >> b & 1) or (
                            (a == x or bool(cR[a] >> x & 1)) and (y == b or bool(cR[y] >> b & 1)))
                        wp_checked += 1
                        if left != right:
                            fails.append(("reach_withPair_iff", R, x, y, a, b))
                ncw = no_cycle(with_pair(R, x, y))
                if ncw != (acR and y != x and not cR[y] >> x & 1):
                    fails.append(("noCycle_withPair_iff", R, x, y))
    return dict(counts, relations=512, strict_relations=bin(STRICT).count("1"),
                transitive_relations=bin(TRANS).count("1"),
                withPair_cases=wp_checked, failures=len(fails), first_failures=[str(f) for f in fails[:5]])


def mutation_checks():
    """The checks can fail: two wrong mirrors, each caught by enumeration on three alternatives
    (families of one or two occasions). A mirror of Shown without "y ≠ x", and Accords read as
    AccordsWeakly, each break accorded_iff_noCycle somewhere."""
    n = 3
    R_ALL = [rows_from_index(i, n) for i in range(1 << 9)]
    strict = [P for P in R_ALL if is_irreflexive(P) and is_transitive(P)]
    occasions = [(menu, pick) for menu in subsets(n) for pick in range(n)]

    def shown_without_apart(fam):
        rows = [0] * n
        for menu, pick in fam:
            rows[pick] |= menu
        return rows

    bad_shown = bad_accords = 0
    for size in (1, 2):
        for fam in itertools.combinations_with_replacement(occasions, size):
            fam = list(fam)
            if any(accords(fam, P) for P in strict) != no_cycle(shown_without_apart(fam)):
                bad_shown += 1
            if any(accords_weakly(fam, P) for P in strict) != no_cycle(shown(fam, n)):
                bad_accords += 1
    return {"Shown without y != x: mismatches found": bad_shown,
            "Accords read as AccordsWeakly: mismatches found": bad_accords,
            "both caught": bad_shown > 0 and bad_accords > 0}


def transitive_relations(n):
    out = []
    for idx in range(1 << (n * n)):
        P = rows_from_index(idx, n)
        if is_transitive(P):
            out.append(P)
    return out


def strict_orders(n_max):
    """All strict orders (irreflexive, transitive) on 0..n-1 for n <= n_max, by extension: a new
    element with a down-closed set D below it and an up-closed set U above it, U and D apart, and
    every member of U above every member of D. Counts 1, 1, 3, 19, 219, 4231 are the labelled
    posets (OEIS A001035)."""
    levels = {0: [[]]}
    for n in range(1, n_max + 1):
        new = []
        v = n - 1
        for P in levels[n - 1]:
            m = n - 1
            # the down-closure and up-closure tests on the old elements
            below = [P[i] for i in range(m)]  # i above these
            above = [sum(1 << j for j in range(m) if P[j] >> i & 1) for i in range(m)]
            for D in range(1 << m):
                ok = True
                for d in range(m):
                    if D >> d & 1 and below[d] & ~D:
                        ok = False
                        break
                if not ok:
                    continue
                for U in range(1 << m):
                    if U & D:
                        continue
                    ok = True
                    for u in range(m):
                        if U >> u & 1:
                            if above[u] & ~U or (D & ~below[u]):
                                ok = False
                                break
                    if not ok:
                        continue
                    Q = [P[i] | ((1 << v) if U >> i & 1 else 0) for i in range(m)] + [D]
                    new.append(Q)
        levels[n] = new
    return levels


def mirror_enumeration_bigger(rng, posets):
    """reach_within on every transitive relation on four alternatives (3,994) and the strict laws
    on every strict order on four (219) and five (4,231), for sampled families of occasions."""
    out = {}
    n = 4
    T4 = transitive_relations(4)
    out["transitive_relations_n4"] = len(T4)
    S4 = [P for P in T4 if is_irreflexive(P)]
    out["strict_orders_n4"] = len(S4)
    out["strict_orders_by_extension"] = {str(k): len(v) for k, v in posets.items()}
    fails = 0
    checked = 0
    for n, rels_all, rels_strict, samples in ((4, T4, S4, 400), (5, None, posets[5], 120)):
        for _ in range(samples):
            size = rng.randint(1, 5)
            fam = [(rng.randrange(1 << n), rng.randrange(n)) for _ in range(size)]
            S = shown(fam, n)
            reach = closure(S)
            acyclic = no_cycle(S)
            if rels_all is not None:
                for P in rels_all:
                    if accords(fam, P) and not contains(P, reach):
                        fails += 1
            acc = [P for P in rels_strict if accords(fam, P)]
            checked += 1
            if bool(acc) != acyclic:
                fails += 1
            if acyclic:
                inter = [(1 << n) - 1] * n
                union = [0] * n
                for P in acc:
                    inter = [inter[i] & P[i] for i in range(n)]
                    union = [union[i] | P[i] for i in range(n)]
                if inter != reach:
                    fails += 1
                for x in range(n):
                    for y in range(n):
                        if x != y and not reach[x] >> y & 1 and not reach[y] >> x & 1:
                            if not (union[x] >> y & 1 and union[y] >> x & 1):
                                fails += 1
    out["sampled_families"] = checked
    out["failures"] = fails
    return out


# ---------------------------------------------------------------------------------------------
# B. The mirror of ReadingLoop's Loop and the Untested witness
# ---------------------------------------------------------------------------------------------

LOW, MID, HIGH = "low", "mid", "high"
KNOWN, UNTRIED = "known", "untried"
UP, DOWN = "up", "down"
VALUES = (LOW, MID, HIGH)


def reply(_s, a, w):
    if a == KNOWN:
        return MID
    return HIGH if w == UP else LOW


RANK = {LOW: 0, MID: 1, HIGH: 2}     # Untested.rank: high > mid > low
RANK2 = {LOW: 0, HIGH: 1, MID: 2}    # Untested.rank': mid > high > low


def lower(x, y):
    return x if x <= y else y


def worst(r, a, ws):
    """Untested.worst: the least rank the candidates kept predict for the act (0 with none)."""
    if not ws:
        return 0
    if len(ws) == 1:
        return r[reply(MID, a, ws[0])]
    return lower(r[reply(MID, a, ws[0])], worst(r, a, ws[1:]))


def by_worst(r):
    def choose(ws, _s):
        return UNTRIED if worst(r, KNOWN, ws) < worst(r, UNTRIED, ws) else KNOWN
    return choose


class LoopLaw:
    """ReadingLoop.Loop.law: internal (candidates kept, last (value, act)); the step moves every
    part at once: internal from (internal, sensed, act), sensed from (sensed, act, world), act
    from (internal, sensed, act) through the candidates kept once the latest answer is taken in,
    world from (sensed, act, world)."""

    def __init__(self, choose, predict=None, answer=reply, move=None):
        self.choose = choose
        self.predict = predict or (lambda h, s, a: reply(s, a, h))
        self.answer = answer
        self.move = move or (lambda s, a, e: e)

    def keep(self, hs, last, sensed):
        if last is None:
            return hs
        s, a = last
        return tuple(h for h in hs if self.predict(h, s, a) == sensed)

    def step(self, x):
        (hs, last), s, a, e = x
        kept = self.keep(hs, last, s)
        return ((kept, (s, a)), self.answer(s, a, e), self.choose(kept, s), self.move(s, a, e))

    def course(self, x, n):
        out = [x]
        for _ in range(n):
            x = self.step(x)
            out.append(x)
        return out


def start(hs, s, a, e):
    return ((tuple(hs), None), s, a, e)


def mirror_untested():
    res = {}
    M = LoopLaw(by_worst(RANK))
    O = LoopLaw(by_worst(RANK2))
    rest = lambda w: (((UP, DOWN), (MID, KNOWN)), MID, KNOWN, w)
    upRest = (((UP,), (HIGH, UNTRIED)), HIGH, UNTRIED, UP)
    downRest = (((DOWN,), (MID, KNOWN)), MID, KNOWN, DOWN)
    orderRest = (((UP,), (MID, KNOWN)), MID, KNOWN, UP)
    N = 40
    # rests (w): from step 1 at rest w; the induction certificate: step(start) = rest, step(rest) = rest
    for w in (UP, DOWN):
        c = M.course(start([UP, DOWN], MID, KNOWN, w), N)
        res[f"rests_{w}"] = all(c[n + 1] == rest(w) for n in range(N)) and M.step(rest(w)) == rest(w)
    cu = M.course(start([UP, DOWN], MID, KNOWN, UP), N)
    cd = M.course(start([UP, DOWN], MID, KNOWN, DOWN), N)
    res["alike_in_both"] = all(cu[n][0] == cd[n][0] and cu[n][1] == cd[n][1] and cu[n][2] == cd[n][2]
                               for n in range(N + 1))
    res["never_high"] = all(x[1] != HIGH for x in cu)
    res["true_kept"] = all(UP in x[0][0] for x in cu[1:]) and all(DOWN in x[0][0] for x in cd[1:])
    eu = M.course(start([UP, DOWN], MID, UNTRIED, UP), N)
    ed = M.course(start([UP, DOWN], MID, UNTRIED, DOWN), N)
    res["explorer_up_from_step_4"] = all(eu[n + 4] == upRest for n in range(N - 4)) and M.step(upRest) == upRest
    res["explorer_up_not_before_4"] = eu[3] != upRest
    res["explorer_down_from_step_3"] = all(ed[n + 3] == downRest for n in range(N - 3)) and M.step(downRest) == downRest
    res["explorer_low_once"] = all((ed[n][1] == LOW) == (n == 1) for n in range(N + 1))
    co = O.course(start([UP], MID, KNOWN, UP), N)
    res["order_rests"] = all(co[n + 1] == orderRest for n in range(N)) and O.step(orderRest) == orderRest
    res["model_or_order"] = all(cu[n][1] == co[n][1] and cu[n][2] == co[n][2] for n in range(N + 1))
    res["model_or_order_internal_parts_differ"] = cu[1][0][0] != co[1][0][0]
    ci = M.course(start([UP], MID, KNOWN, UP), N)
    res["informed_turns_from_step_3"] = all(ci[n + 3] == upRest for n in range(N - 3)) and M.step(upRest) == upRest
    # inference by evaluation (the reader's note): the act is untried from step 1, high sensed from 2
    res["informed_act_untried_from_step_1_(inference)"] = all(x[2] == UNTRIED for x in ci[1:])
    res["informed_high_sensed_from_step_2_(inference)"] = all(x[1] == HIGH for x in ci[2:]) and ci[1][1] == MID
    res["informed_turns_not_at_step_2"] = ci[2] != upRest
    # both_accord, apart_beyond (the training occasion: mid and low open, mid chosen)
    above = lambda r: [[r[y] < r[x] for y in VALUES] for x in VALUES]
    idx = {v: i for i, v in enumerate(VALUES)}
    training = [((1 << idx[MID]) | (1 << idx[LOW]), idx[MID])]
    rows = lambda r: [sum(1 << j for j, y in enumerate(VALUES) if r[y] < r[x]) for x in VALUES]
    res["both_accord"] = accords(training, rows(RANK)) and accords(training, rows(RANK2))
    res["apart_beyond"] = RANK[MID] < RANK[HIGH] and RANK2[HIGH] < RANK2[MID]
    # training's shown reach: mid above low only
    res["training_reach_mid_low_only"] = closure(shown(training, 3)) == [0, 1 << idx[LOW], 0]
    # byWorst_iff, worst_le, worst_attained over every list of up to three worlds and every
    # ranking Value -> 0..3 (64 rankings)
    ok_iff = ok_le = ok_att = True
    for r_vals in itertools.product(range(4), repeat=3):
        r = dict(zip(VALUES, r_vals))
        for k in range(0, 4):
            for ws in itertools.product((UP, DOWN), repeat=k):
                ws = list(ws)
                ch = by_worst(r)(ws, MID)
                ok_iff &= (ch == UNTRIED) == (worst(r, KNOWN, ws) < worst(r, UNTRIED, ws))
                for a in (KNOWN, UNTRIED):
                    for w in ws:
                        ok_le &= worst(r, a, ws) <= r[reply(MID, a, w)]
                    if ws:
                        ok_att &= any(worst(r, a, ws) == r[reply(MID, a, v)] for v in ws)
    res["byWorst_iff"] = ok_iff
    res["worst_le"] = ok_le
    res["worst_attained"] = ok_att
    res["all_witness_checks_pass"] = all(v for v in res.values())
    return res


def floor_forgoes_check(rng):
    """Untested.floor_forgoes over classes of small formations: every blanketed law that senses by
    reply in worlds that do not move, from one start in both worlds. A formation is (internal
    states, nextInternal, nextActive); its configuration takes finitely many values, so a course
    is followed until the pair of courses (up, down) repeats, which covers every step."""
    S_VALS = VALUES
    A_VALS = (KNOWN, UNTRIED)
    checked = holds_hyp = 0
    viol = 0

    def run(nI, nA, i0, s0, a0):
        nonlocal checked, holds_hyp, viol
        xu = (i0, s0, a0)
        xd = (i0, s0, a0)
        seen = set()
        floor = True
        alike = True
        known_down = True
        while (xu, xd) not in seen:
            seen.add((xu, xd))
            if xd[1] == LOW:
                floor = False
            if xu[1] != xd[1]:
                alike = False
            if xd[2] != KNOWN:
                known_down = False
            iu, su, au = xu
            idn, sd, ad = xd
            xu = (nI(iu, su, au), reply(su, au, UP), nA(iu, su, au))
            xd = (nI(idn, sd, ad), reply(sd, ad, DOWN), nA(idn, sd, ad))
        checked += 1
        if floor:
            holds_hyp += 1
            if not (alike and known_down):
                viol += 1

    keys_sa = [(s, a) for s in S_VALS for a in A_VALS]
    # one internal state, the act any function of (sensed, act): 64 laws, 6 starts each
    for acts in itertools.product(A_VALS, repeat=len(keys_sa)):
        tab = dict(zip(keys_sa, acts))
        for s0 in S_VALS:
            for a0 in A_VALS:
                run(lambda i, s, a: 0, lambda i, s, a, t=tab: t[(s, a)], 0, s0, a0)
    # two internal states, each part a function of (internal, sensed): 4,096 laws, 12 starts each
    keys_is = [(i, s) for i in (0, 1) for s in S_VALS]
    for nexts in itertools.product((0, 1), repeat=len(keys_is)):
        ti = dict(zip(keys_is, nexts))
        for acts in itertools.product(A_VALS, repeat=len(keys_is)):
            ta = dict(zip(keys_is, acts))
            for i0 in (0, 1):
                for s0 in S_VALS:
                    for a0 in A_VALS:
                        run(lambda i, s, a, t=ti: t[(i, s)], lambda i, s, a, t=ta: t[(i, s)], i0, s0, a0)
    # three internal states, each part any function of (internal, sensed, act): 20,000 sampled laws
    keys_isa = [(i, s, a) for i in range(3) for s in S_VALS for a in A_VALS]
    for _ in range(20000):
        ti = {k: rng.randrange(3) for k in keys_isa}
        ta = {k: rng.choice(A_VALS) for k in keys_isa}
        run(lambda i, s, a, t=ti: t[(i, s, a)], lambda i, s, a, t=ta: t[(i, s, a)],
            rng.randrange(3), rng.choice(S_VALS), rng.choice(A_VALS))
    return dict(courses_checked=checked, floor_hypothesis_held=holds_hyp, violations=viol)


def inferences_untested():
    """General forms the informing variant uses, checked by enumeration over every ranking
    Value -> 0..3 (64). Not stated in the Lean: inferences, candidate core lemmas."""
    out = {}
    I1 = I2 = I3 = True
    uninformed_same_for_every_according = True
    according = 0
    for r_vals in itertools.product(range(4), repeat=3):
        r = dict(zip(VALUES, r_vals))
        L = LoopLaw(by_worst(r))
        acc = r[LOW] < r[MID]  # accords with the training occasion (mid chosen over low)
        if not acc:
            continue
        according += 1
        for w in (UP, DOWN):
            c = L.course(start([UP, DOWN], MID, KNOWN, w), 30)
            I1 &= all(x[2] == KNOWN for x in c)
            uninformed_same_for_every_according &= all(x[1] == MID for x in c)
        ci = L.course(start([UP], MID, KNOWN, UP), 30)
        turns = all(x[2] == UNTRIED for x in ci[1:])
        stays = all(x[2] == KNOWN for x in ci)
        I2 &= (turns if r[MID] < r[HIGH] else stays)
        cdn = L.course(start([DOWN], MID, KNOWN, DOWN), 30)
        I3 &= all(x[2] == KNOWN for x in cdn)
    out["rankings_according_with_training"] = according
    out["I1_uninformed_known_at_every_step_for_every_according_ranking"] = I1 and uninformed_same_for_every_according
    out["I2_informed_up_untried_from_step_1_exactly_where_mid_below_high"] = I2
    out["I3_informed_down_known_at_every_step"] = I3
    out["reading"] = ("For every ranking according with the training occasion, the worst-case "
                      "formation listing both candidates has one course (known, mid) in both worlds; "
                      "listing the true candidate alone in up, it takes the untried act from step 1 "
                      "exactly where mid ranks below high, the comparison beyond the training's shown "
                      "reach; in down it keeps the known act. Inferences by enumeration over 64 "
                      "rankings, not theorems.")
    return out


# The identification table of the informing variant (RF-M's mechanism, exact)

def ev_choose(r, p_down):
    """Expected rank over the kept candidates, prior weight p_down on down (renormalized)."""
    def choose(ws, _s):
        if not ws:
            return KNOWN
        wt = {UP: 1 - p_down, DOWN: p_down}
        tot = sum(wt[w] for w in ws)
        ev = sum(wt[w] * r[reply(MID, UNTRIED, w)] for w in ws) / tot
        return UNTRIED if ev > r[MID] else KNOWN
    return choose


def max_choose(r):
    def choose(ws, _s):
        if not ws:
            return KNOWN
        return UNTRIED if max(r[reply(MID, UNTRIED, w)] for w in ws) > r[MID] else KNOWN
    return choose


def identification_table():
    """Each scripted formation in each condition: U (both candidates listed, both worlds), I (told:
    the true candidate alone listed), C (one choice between the middle and the high value, stated
    as values, in both name orders), T (the training choice, middle against low, both orders), and
    a manipulation check (whether being told is taken in). V1 is RF1's verdict across frames, on
    the value carrier: no cycle among the strict occasions T, I-up at step 1, I-down at step 1, C."""
    STEPS = 10
    # formation: (loop chooser, told is taken in, C rule, T rule)
    #   C/T rule: 'rank' picks by the ranking; 'first' picks the first listed (both orders shown)
    F = {
        "M (worst case, high > mid > low)": (by_worst(RANK), True, RANK, None),
        "O (worst case, mid > high > low)": (by_worst(RANK2), True, RANK2, None),
        "EV, prior 3/4 on down": (ev_choose(RANK, Fraction(3, 4)), True, RANK, None),
        "EV, prior 1/4 on down": (ev_choose(RANK, Fraction(1, 4)), True, RANK, None),
        "optimistic (max)": (max_choose(RANK), True, RANK, None),
        "untrusting, high > mid": (by_worst(RANK), False, RANK, None),
        "untrusting, mid > high": (by_worst(RANK2), False, RANK2, None),
        "frame-inconsistent (O in courses, high > mid in C)": (by_worst(RANK2), True, RANK, None),
        "default reader (known; first listed in C and T)": ("known", True, None, "first"),
        "first-listed reader": ("first", True, None, "first"),
    }
    idx = {v: i for i, v in enumerate(VALUES)}
    rows = []
    for name, (chooser, believes, crank, crule) in F.items():
        row = {"formation": name}

        def course(listed, world, first_known=True):
            if chooser == "known":
                return [KNOWN] * (STEPS + 1)
            if chooser == "first":
                # the option listed first: the known option in one name order, the other in the
                # other; a course in each order
                return [KNOWN if first_known else UNTRIED] + [KNOWN if first_known else UNTRIED] * STEPS
            L = LoopLaw(chooser)
            c = L.course(start(listed, MID, KNOWN, world), STEPS)
            return [x[2] for x in c]

        u_up = course([UP, DOWN], UP)
        u_dn = course([UP, DOWN], DOWN)
        told_up = [UP] if believes else [UP, DOWN]
        told_dn = [DOWN] if believes else [UP, DOWN]
        i_up = course(told_up, UP)
        i_dn = course(told_dn, DOWN)
        row["U up: acts"] = "".join("k" if a == KNOWN else "u" for a in u_up)
        row["U down: acts"] = "".join("k" if a == KNOWN else "u" for a in u_dn)
        row["I up: acts"] = "".join("k" if a == KNOWN else "u" for a in i_up)
        row["I down: acts"] = "".join("k" if a == KNOWN else "u" for a in i_dn)
        first_try = next((n for n, a in enumerate(u_up) if a == UNTRIED and n > 0), None)
        row["U: first untried step"] = first_try
        row["manipulation check passed"] = believes

        def frame_pick(menu_vals, order):
            if crule == "first":
                return order[0]
            return max(menu_vals, key=lambda v: crank[v])

        c_picks = [frame_pick((MID, HIGH), o) for o in ((MID, HIGH), (HIGH, MID))]
        t_picks = [frame_pick((MID, LOW), o) for o in ((MID, LOW), (LOW, MID))]
        row["C picks (two name orders)"] = c_picks
        row["T picks (two name orders)"] = t_picks
        occ = []
        for o, p in zip(((MID, HIGH), (HIGH, MID)), c_picks):
            occ.append(((1 << idx[MID]) | (1 << idx[HIGH]), idx[p]))
        for o, p in zip(((MID, LOW), (LOW, MID)), t_picks):
            occ.append(((1 << idx[MID]) | (1 << idx[LOW]), idx[p]))
        if believes and chooser not in ("known", "first"):
            occ.append(((1 << idx[MID]) | (1 << idx[HIGH]), idx[HIGH if i_up[1] == UNTRIED else MID]))
            occ.append(((1 << idx[MID]) | (1 << idx[LOW]), idx[LOW if i_dn[1] == UNTRIED else MID]))
        elif chooser in ("known", "first"):
            # in I the default reader keeps the known option (mid); the first-listed reader takes
            # the first listed, which is the known option in one name order and the other in the
            # other
            occ.append(((1 << idx[MID]) | (1 << idx[HIGH]), idx[MID]))
            if chooser == "first":
                occ.append(((1 << idx[MID]) | (1 << idx[HIGH]), idx[HIGH]))
        S = shown(occ, 3)
        row["V1 contradicted (a cycle across frames)"] = not no_cycle(S)
        # the descriptive class
        if not believes:
            cls = "untrusting (check failed): I not on the value carrier; C gives its ranking"
        elif chooser in ("known", "first") or c_picks[0] != c_picks[1]:
            cls = "presentation reader: V1 contradicted within a frame"
        elif first_try is not None:
            cls = "explorer: tries the untried option uninformed"
        elif i_up[1] == UNTRIED and c_picks[0] == HIGH:
            cls = "held by the model: known uninformed, turns when told"
        elif i_up[1] == KNOWN and c_picks[0] == MID:
            cls = "held by the order: known uninformed and told, middle over high in C"
        elif i_up[1] == KNOWN and c_picks[0] == HIGH:
            cls = "frame-inconsistent: V1 contradicted"
        else:
            cls = "other"
        row["class (descriptive)"] = cls
        rows.append(row)
    alike_U = sorted(r["formation"] for r in rows
                     if r["U up: acts"] == "k" * (STEPS + 1) and r["U down: acts"] == "k" * (STEPS + 1))
    return {"steps": STEPS, "rows": rows,
            "alike_uninformed (known at every step in both worlds)": alike_U,
            "reading": ("Uninformed, the worst-case formations of either ranking, the pessimistic "
                        "expected-value formation, both untrusting formations and the default reader "
                        "act alike (known, middle sensed, in both worlds): model_or_order's case, here "
                        "for a class. Being told separates those held by the model (M, EV 3/4) from "
                        "those held by the order or not taking the telling in; C separates O from the "
                        "untrusting high-ranker; the check separates untrusting formations; nothing here "
                        "separates M from EV 3/4, so a classification names the class (held by the "
                        "model), not the rule. Only V1 is a verdict.")}


def informing_power(rqs=((3, 3), (5, 4), (5, 5))):
    """V1's exact power and false-contradiction rate under a per-call tremble eps, each frame
    occasion asked r times with fresh calls, a pick strict where at least q of r agree. The
    occasions on the value carrier: C (two name orders), T (two), I-up at step 1, I-down at step 1."""
    out = []
    for eps in (Fraction(1, 50), Fraction(1, 20), Fraction(1, 10), Fraction(1, 5)):
        for r, q in rqs:
            def strict_probs(p_right):
                # two options: P(strict right), P(strict wrong)
                pr = sum(math.comb(r, k) * p_right ** k * (1 - p_right) ** (r - k) for k in range(q, r + 1))
                pw = sum(math.comb(r, k) * (1 - p_right) ** k * p_right ** (r - k) for k in range(q, r + 1))
                return pr, pw
            pr, pw = strict_probs(1 - eps)
            # consistent formations (M: I-up high, C high; O: I-up mid, C mid): a cycle needs one
            # of the three {mid, high} occasions strict the wrong way while another is strict the
            # right way, or the {mid, low} occasions likewise
            def p_cycle_consistent():
                # three occasions on {mid, high} (C twice, I-up once), each strict right pr,
                # strict wrong pw, else not strict; a cycle where at least one right and one wrong
                def two_way(k):
                    tot = Fraction(0)
                    for pattern in itertools.product((0, 1, 2), repeat=k):
                        p = Fraction(1)
                        for s in pattern:
                            p *= (pr, pw, 1 - pr - pw)[s]
                        if 0 in pattern and 1 in pattern:
                            tot += p
                    return tot
                a = two_way(3)  # {mid, high}: C, C, I-up
                b = two_way(3)  # {mid, low}: T, T, I-down
                return 1 - (1 - a) * (1 - b)
            def p_cycle_inconsistent():
                # I-up picks mid (strict right for it: pr), C picks high in both orders; a cycle
                # where some {mid, high} occasion strict at mid and another at high
                tot = Fraction(0)
                for pattern in itertools.product((0, 1, 2), repeat=3):
                    # occasions: C1, C2 (right = high), I-up (right = mid)
                    p = Fraction(1)
                    picks = []
                    for occ_i, s in enumerate(pattern):
                        p *= (pr, pw, 1 - pr - pw)[s]
                        right = HIGH if occ_i < 2 else MID
                        wrong = MID if right == HIGH else HIGH
                        picks.append(None if s == 2 else (right if s == 0 else wrong))
                    if MID in picks and HIGH in picks:
                        tot += p
                # the {mid, low} occasions as for a consistent formation
                b = Fraction(0)
                for pattern in itertools.product((0, 1, 2), repeat=3):
                    p = Fraction(1)
                    for s in pattern:
                        p *= (pr, pw, 1 - pr - pw)[s]
                    if 0 in pattern and 1 in pattern:
                        b += p
                return 1 - (1 - tot) * (1 - b)
            out.append({"eps": str(eps), "r": r, "q": q,
                        "P(V1 contradicted | consistent formation)": float(p_cycle_consistent()),
                        "P(V1 contradicted | frame-inconsistent formation)": float(p_cycle_inconsistent()),
                        "calls_per_formation_frame_occasions": 6 * r})
    return out


# ---------------------------------------------------------------------------------------------
# C. Exact anchors
# ---------------------------------------------------------------------------------------------

def anchors():
    out = {}
    # random tournaments: each pair once, uniform picks; acyclic share n!/2^C(n,2), enumerated
    tour = {}
    for n in range(3, 7):
        pairs = list(itertools.combinations(range(n), 2))
        m = len(pairs)
        acyc = 0
        for bits in range(1 << m):
            rows = [0] * n
            for k, (a, b) in enumerate(pairs):
                if bits >> k & 1:
                    rows[a] |= 1 << b
                else:
                    rows[b] |= 1 << a
            acyc += no_cycle(rows)
        formula = Fraction(math.factorial(n), 2 ** m)
        tour[str(n)] = {"enumerated": fr(Fraction(acyc, 2 ** m)), "formula n!/2^C(n,2)": fr(formula),
                        "agree": Fraction(acyc, 2 ** m) == formula}
    out["random_tournament_acyclic"] = tour
    # each pair in both presentation orders, uniform picks: n!/4^C(n,2), enumerated for n <= 4
    both = {}
    for n in (3, 4):
        pairs = list(itertools.combinations(range(n), 2))
        m = len(pairs)
        acyc = 0
        for bits in range(1 << (2 * m)):
            rows = [0] * n
            for k, (a, b) in enumerate(pairs):
                for t in (0, 1):
                    if bits >> (2 * k + t) & 1:
                        rows[a] |= 1 << b
                    else:
                        rows[b] |= 1 << a
            acyc += no_cycle(rows)
        formula = Fraction(math.factorial(n), 4 ** m)
        both[str(n)] = {"enumerated": fr(Fraction(acyc, 4 ** m)), "formula": fr(formula),
                        "agree": Fraction(acyc, 4 ** m) == formula}
    for n in (5, 6):
        m = n * (n - 1) // 2
        both[str(n)] = {"formula": fr(Fraction(math.factorial(n), 4 ** m))}
    out["both_orders_uniform_acyclic"] = both

    # one strict order, each pair in both orders once (r = 1), tremble eps: P(no cycle) is
    # (1-eps)^(2m) times the inversion generating function at t = eps^2/(1-eps)^2 (a pattern is
    # acyclic exactly where both presentations of each pair agree and the agreed tournament is a
    # linear order, whose reversed pairs are its inversions); checked by enumeration for n = 4
    def p_no_cycle_formula(n, eps):
        m = n * (n - 1) // 2
        t = eps ** 2 / (1 - eps) ** 2
        g = Fraction(1)
        for k in range(1, n + 1):
            g *= sum(t ** j for j in range(k))
        return (1 - eps) ** (2 * m) * g

    eps = Fraction(1, 20)
    n = 4
    pairs = list(itertools.combinations(range(n), 2))
    m = len(pairs)
    tot = Fraction(0)
    for bits in range(1 << (2 * m)):
        rows = [0] * n
        wrong = 0
        for k, (a, b) in enumerate(pairs):
            for t_ in (0, 1):
                if bits >> (2 * k + t_) & 1:
                    rows[a] |= 1 << b  # the order's pick (a above b)
                else:
                    rows[b] |= 1 << a
                    wrong += 1
        if no_cycle(rows):
            tot += eps ** wrong * (1 - eps) ** (2 * m - wrong)
    out["trembling_order_pairs_both_orders_r1"] = {
        "n4_eps_1/20_enumerated": fr(tot), "n4_formula": fr(p_no_cycle_formula(4, eps)),
        "agree": tot == p_no_cycle_formula(4, eps),
        "n6_eps_1/20_P(no wrong pick)=(19/20)^30": fr(Fraction(19, 20) ** 30),
        "n6_eps_1/20_P(no cycle)": fr(p_no_cycle_formula(6, eps)),
        "n5_eps_1/20_P(no cycle)": fr(p_no_cycle_formula(5, eps)),
    }

    # the stability rule: a presentation asked r times; strict where one alternative is picked
    # at least q times (q > r/2); tremble eps spread evenly over the k - 1 others
    def stability(k, eps, r, q):
        right = 1 - eps
        each = eps / (k - 1)
        p_right = Fraction(0)
        p_wrong = Fraction(0)
        # multinomial over (right, wrong_1, ..., wrong_{k-1})
        def rec(i, left, probs, counts):
            nonlocal p_right, p_wrong
            if i == len(probs) - 1:
                cs = counts + [left]
                coef = math.factorial(r)
                p = Fraction(1)
                for c, pr in zip(cs, probs):
                    coef //= math.factorial(c)
                    p *= pr ** c
                p *= coef
                if cs[0] >= q:
                    p_right += p
                elif max(cs[1:]) >= q:
                    p_wrong += p
                return
            for c in range(left + 1):
                rec(i + 1, left - c, probs, counts + [c])
        rec(0, r, [right] + [each] * (k - 1), [])
        return p_right, p_wrong, 1 - p_right - p_wrong

    stab = []
    for k in (2, 3):
        for eps in (Fraction(1, 50), Fraction(1, 20), Fraction(1, 10), Fraction(1, 5), Fraction(3, 10)):
            for r, q in ((3, 2),) + RQ:
                pr, pw, pn = stability(k, eps, r, q)
                stab.append({"menu_size": k, "eps": str(eps), "r": r, "q": q,
                             "strict_right": float(pr), "strict_wrong": float(pw), "not_strict": float(pn)})
    out["stability_rule"] = stab
    # a presentation whose choice is a coin flip (two options, 1/2 each): P(counted strict)
    coin = []
    for r, q in ((3, 2),) + RQ:
        p = 2 * sum(Fraction(math.comb(r, k), 2 ** r) for k in range(q, r + 1))
        coin.append({"r": r, "q": q, "P(strict | coin flip)": fr(p)})
    out["coin_flip_counted_strict"] = coin
    out["reader_check_r5_q4_eps_1/20_pairs"] = {
        "strict_wrong": fr(stability(2, Fraction(1, 20), 5, 4)[1]),
        "not_strict": fr(stability(2, Fraction(1, 20), 5, 4)[2])}
    return out, stability


# ---------------------------------------------------------------------------------------------
# D. Designs, simulated choosers and the power check
# ---------------------------------------------------------------------------------------------

class Design:
    def __init__(self, name, n, sizes, met_pairs):
        """Every menu of each size in `sizes`, each in all its cyclic rotations (pairs: both
        orders); met: the pair presentations of `met_pairs`, both orders."""
        self.name, self.n = name, n
        pres = []
        for k in sizes:
            for menu in itertools.combinations(range(n), k):
                for s in range(k):
                    pres.append(tuple(menu[s:] + menu[:s]))
        self.pres = pres
        self.menus = [sum(1 << c for c in p) for p in pres]
        self.size = [len(p) for p in pres]
        mp = {tuple(sorted(p)) for p in met_pairs}
        self.met = [len(p) == 2 and tuple(sorted(p)) in mp for p in pres]
        self.met_pairs = sorted(mp)
        # the course condition's order: the met presentations first, then the after ones, each
        # part in an order frozen by a seeded shuffle, so that which listing of a menu comes
        # first is not the sorted one
        srng = random.Random(f"{SEED}|course-order|{name}")
        met_i = [i for i in range(len(pres)) if self.met[i]]
        aft_i = [i for i in range(len(pres)) if not self.met[i]]
        srng.shuffle(met_i)
        srng.shuffle(aft_i)
        self.course_order = met_i + aft_i

    def area(self):
        """Selten's area: the share of all pick patterns (one alternative per presentation) that
        some strict order accords with. With every pair in both orders, an acyclic pattern is a
        linear order's top at every presentation, so the count is n!."""
        tot = 1
        for k in self.size:
            tot *= k
        return Fraction(math.factorial(self.n), tot)


def check_area_argument():
    """The area argument checked by enumeration on n = 3 (pairs both orders, the triple in its
    three rotations): 2^6 * 3^3 = 1,728 patterns, of which exactly 3! = 6 are acyclic."""
    d = Design("check", 3, (2, 3), [])
    count = 0
    total = 0
    for picks in itertools.product(*[p for p in d.pres]):
        total += 1
        fam = [(d.menus[i], picks[i]) for i in range(len(d.pres))]
        count += no_cycle(shown(fam, 3))
    return {"patterns": total, "acyclic": count, "agree_with_n!": count == 6}


def p1_structure(design):
    """Exact, over every hidden strict linear order (the law's model without noise): the met
    reach, the after presentations P1 can test (some open alternative reaches another), the forced
    tops (one open alternative reaches all the others), and the after pairs inferred (joined by
    the met reach but not met)."""
    n = design.n
    stats = {"testable": [], "forced": [], "inferred_pairs": []}
    for perm in itertools.permutations(range(n)):
        rank = {c: i for i, c in enumerate(perm)}
        fam = [(design.menus[i], min(design.pres[i], key=rank.__getitem__))
               for i in range(len(design.pres)) if design.met[i]]
        reach = closure(shown(fam, n))
        testable = forced = 0
        for i, p in enumerate(design.pres):
            if design.met[i]:
                continue
            M = design.menus[i]
            t = any(reach[x] & M & ~(1 << x) for x in p)
            f = any((reach[x] & M) == (M & ~(1 << x)) for x in p)
            testable += t
            forced += f
        inferred = 0
        for a, b in itertools.combinations(range(n), 2):
            if (a, b) in design.met_pairs:
                continue
            if reach[a] >> b & 1 or reach[b] >> a & 1:
                inferred += 1
        stats["testable"].append(testable)
        stats["forced"].append(forced)
        stats["inferred_pairs"].append(inferred)
    after = sum(1 for m in design.met if not m)
    return {k: {"mean": fr(Fraction(sum(v), len(v))), "min": min(v), "max": max(v)} for k, v in stats.items()} | {
        "after_presentations": after, "met_presentations": len(design.pres) - after}


def mirror_on_designs(designs, posets):
    """above_in_every_iff_reach and both_ways_of_unreached on the designs' met families: for every
    hidden order on five alternatives, the comparisons every according strict order (all 4,231)
    shares are the computed reach, and every distinct unjoined pair is ranked both ways; on six
    alternatives the same against the 720 linear orders (Szpilrajn's extension, standard
    mathematics, not in the Lean)."""
    out = {}
    for d in designs:
        n = d.n
        if n == 5:
            cands, label = posets[5], "strict orders (4,231)"
        else:
            cands = []
            for perm in itertools.permutations(range(n)):
                rows = [0] * n
                for i, a in enumerate(perm):
                    for b in perm[i + 1:]:
                        rows[a] |= 1 << b
                cands.append(rows)
            label = "linear orders (720)"
        fails = 0
        orders = 0
        for perm in itertools.permutations(range(n)):
            rank = {c: i for i, c in enumerate(perm)}
            fam = [(d.menus[i], min(d.pres[i], key=rank.__getitem__))
                   for i in range(len(d.pres)) if d.met[i]]
            S = shown(fam, n)
            reach = closure(S)
            inter = [(1 << n) - 1] * n
            union = [0] * n
            found = False
            for P in cands:
                if contains(P, S):
                    found = True
                    inter = [inter[i] & P[i] for i in range(n)]
                    union = [union[i] | P[i] for i in range(n)]
            orders += 1
            if not found or inter != reach:
                fails += 1
            for x in range(n):
                for y in range(n):
                    if x != y and not reach[x] >> y & 1 and not reach[y] >> x & 1:
                        if not (union[x] >> y & 1 and union[y] >> x & 1):
                            fails += 1
        out[d.name] = {"against": label, "hidden_orders": orders, "failures": fails}
    return out


# The simulated choosers. Each is made per replication with its hidden parameters; call() answers
# one call on a presentation (listed contents) with a content, None (no preference) or -1 (an
# invalid answer); record() lets a history reader see its own answer in the course condition.

NORMAL = statistics.NormalDist()


class Chooser:
    history = False

    def __init__(self, rng, n, **kw):
        self.rng = rng
        self.n = n
        perm = list(range(n))
        rng.shuffle(perm)
        self.rank = {c: i for i, c in enumerate(perm)}  # 0 = top
        self.kw = kw
        self.sticky = {}
        self.setup()

    def setup(self):
        pass

    def top(self, listed):
        return min(listed, key=self.rank.__getitem__)

    def tremble(self, a, listed):
        eps = self.kw.get("eps", 0.0)
        if eps and self.rng.random() < eps:
            return self.rng.choice([c for c in listed if c != a])
        return a

    def invalid(self):
        iv = self.kw.get("invalid", 0.0)
        return iv and self.rng.random() < iv

    def new_course(self):
        pass

    def record(self, pidx, listed, a):
        pass


class Order(Chooser):
    """The law's model: one strict order; tremble eps per call; sticky delta per presentation."""

    def call(self, pidx, listed):
        if self.invalid():
            return -1
        base = self.top(listed)
        delta = self.kw.get("delta", 0.0)
        if delta:
            s = self.sticky.get(pidx)
            if s is None:
                s = self.rng.choice([c for c in listed if c != base]) if self.rng.random() < delta else base
                self.sticky[pidx] = s
            base = s
        return self.tremble(base, listed)


class Thurstone(Chooser):
    """Random utility: equally spaced utilities, i.i.d. normal noise (variance 1) per alternative
    per call. The gap is given directly ("gap", in units of the noise) or set so that an adjacent
    pair is chosen right with probability p_adj. An optional bonus for the first listed makes a
    hybrid of the law and a position reader: given directly ("bonus") or set so that a pair of
    equal utilities goes to the first listed with probability f0. A bonus above the adjacent gap
    lets position decide adjacent pairs while the order decides distant ones."""

    def setup(self):
        kw = self.kw
        self.gap = kw["gap"] if "gap" in kw else math.sqrt(2) * NORMAL.inv_cdf(kw["p_adj"])
        if "bonus" in kw:
            self.bonus = kw["bonus"]
        else:
            f0 = kw.get("f0")
            self.bonus = math.sqrt(2) * NORMAL.inv_cdf(f0) if f0 else 0.0

    def call(self, pidx, listed):
        best, bv = None, None
        for j, c in enumerate(listed):
            v = -self.gap * self.rank[c] + self.rng.gauss(0.0, 1.0) + (self.bonus if j == 0 else 0.0)
            if bv is None or v > bv:
                best, bv = c, v
        return best


class Position(Chooser):
    """A reader fixed by position: the first listed (or the last) with fidelity f."""

    def call(self, pidx, listed):
        a = listed[-1] if self.kw.get("last") else listed[0]
        f = self.kw.get("f", 1.0)
        if f < 1.0 and self.rng.random() > f:
            return self.rng.choice([c for c in listed if c != a])
        return a


class Cue(Chooser):
    """A reader fixed by a cue that stays with the presentation but not with any content: a
    favoured listed place drawn at random per presentation and kept across its repeated calls,
    picked with fidelity f. It is what a label reader would be if option codes were fixed per
    presentation; under the protocol (codes reassigned per call) a label reader is LabelPerCall."""

    def call(self, pidx, listed):
        s = self.sticky.get(pidx)
        if s is None:
            s = self.rng.randrange(len(listed))
            self.sticky[pidx] = s
        a = listed[s]
        f = self.kw.get("f", 1.0)
        if f < 1.0 and self.rng.random() > f:
            return self.rng.choice([c for c in listed if c != a])
        return a


class LabelPerCall(Chooser):
    """A reader fixed by label under the protocol: a fixed preference over the frozen pool of n
    option codes; at every call the listed options receive distinct codes drawn afresh from the
    pool; it picks the option whose code it favours most, with fidelity f. Codes reassigned per
    call leave it no stable pick (its picks are uniform over the listed options)."""

    def setup(self):
        self.code_rank = list(range(self.n))
        self.rng.shuffle(self.code_rank)

    def call(self, pidx, listed):
        codes = self.rng.sample(range(self.n), len(listed))
        j = min(range(len(listed)), key=lambda i: self.code_rank[codes[i]])
        a = listed[j]
        f = self.kw.get("f", 1.0)
        if f < 1.0 and self.rng.random() > f:
            return self.rng.choice([c for c in listed if c != a])
        return a


class Compromise(Chooser):
    """Menu-dependent: by its order on pairs; from a triple, the middle one (a compromise effect)."""

    def call(self, pidx, listed):
        if len(listed) == 3:
            return sorted(listed, key=self.rank.__getitem__)[1]
        return self.tremble(self.top(listed), listed)


class Attention(Chooser):
    """Limited attention: considers only the first k listed; picks its order's top among them."""

    def call(self, pidx, listed):
        return self.tremble(self.top(listed[: self.kw["k"]]), listed)


class Mixture(Chooser):
    """A mixture of strict orders drawn afresh per call. 'two': the hidden order with weight w,
    another random order otherwise. 'condorcet': three orders whose pairwise majorities cycle."""

    def setup(self):
        n = self.n
        base = sorted(range(n), key=self.rank.__getitem__)
        if self.kw["kind"] == "two":
            other = base[:]
            self.rng.shuffle(other)
            self.orders = [base, other]
            self.w = [self.kw.get("w", 0.7), 1 - self.kw.get("w", 0.7)]
        else:
            s = max(1, n // 3)
            self.orders = [base, base[s:] + base[:s], base[2 * s:] + base[:2 * s]]
            self.w = [1 / 3] * 3
        self.ranks = [{c: i for i, c in enumerate(o)} for o in self.orders]

    def call(self, pidx, listed):
        u = self.rng.random()
        k = 0 if u < self.w[0] else (1 if len(self.w) == 2 or u < self.w[0] + self.w[1] else 2)
        rk = self.ranks[k]
        return min(listed, key=rk.__getitem__)


class Ties(Chooser):
    """A weak order: consecutive alternatives of its order tied with probability tau. Forced
    choice breaks a tie at the top by position; with a no-preference option it answers None."""

    def setup(self):
        order = sorted(range(self.n), key=self.rank.__getitem__)
        cls, c = {}, 0
        for i, a in enumerate(order):
            if i > 0 and self.rng.random() >= self.kw["tau"]:
                c += 1
            cls[a] = c
        self.cls = cls

    def call(self, pidx, listed):
        best = min(self.cls[c] for c in listed)
        tops = [c for c in listed if self.cls[c] == best]
        if len(tops) == 1:
            return tops[0]
        if self.kw.get("no_pref"):
            return None
        if self.kw.get("coin"):
            return self.rng.choice(tops)  # a near-tie: either, afresh at each call
        return tops[0]  # the first listed among the tied


class LabelFixed(Chooser):
    """A label reader whose names stay with the contents: it favours one name, and each content
    keeps its name in every presentation, so it is one strict order on the contents."""

    def call(self, pidx, listed):
        return self.top(listed)


class Uniform(Chooser):
    def call(self, pidx, listed):
        return self.rng.choice(listed)


class HistoryCopy(Chooser):
    """A reader of its own history: copies its earlier answer to the same contents where it has
    one in its course, else the first listed. In fresh calls it has no history."""
    history = True

    def new_course(self):
        self.mem = {}

    def call(self, pidx, listed):
        key = frozenset(listed)
        if key in getattr(self, "mem", {}):
            return self.mem[key]
        return listed[0]

    def record(self, pidx, listed, a):
        self.mem.setdefault(frozenset(listed), a)


class HistoryOrder(Chooser):
    """A reader of its own history that keeps it acyclic: picks an open alternative no other open
    one reaches in the reach of its own earlier answers, the first listed of these. It builds an
    order as it goes; in fresh calls it is a position reader."""
    history = True

    def new_course(self):
        self.rows = [0] * self.n

    def call(self, pidx, listed):
        rows = getattr(self, "rows", None)
        if rows is None:
            return listed[0]
        reach = closure(rows)
        M = sum(1 << c for c in listed)
        for c in listed:
            if not any(reach[x] >> c & 1 for x in listed if x != c):
                return c
        return listed[0]

    def record(self, pidx, listed, a):
        if a is not None and a >= 0:
            self.rows[a] |= sum(1 << c for c in listed if c != a)


def strict_rule(answers, q):
    counts = {}
    for a in answers:
        if a is None or a < 0:
            continue
        counts[a] = counts.get(a, 0) + 1
    if not counts:
        return None
    best = max(counts.values())
    if best < q:
        return None
    tops = [c for c, k in counts.items() if k == best]
    return tops[0] if len(tops) == 1 else None


def simulate(design, maker, kw, r, q, rng, course=False, carrier="content"):
    """One chooser on one design: r calls per presentation (fresh calls, or r courses carrying
    their own history); the strict picks by the stability rule; then the measures."""
    ch = maker(rng, design.n, **kw)
    P = len(design.pres)
    answers = [[] for _ in range(P)]
    if course:
        for _ in range(r):
            ch.new_course()
            for i in design.course_order:
                a = ch.call(i, design.pres[i])
                answers[i].append(a)
                ch.record(i, design.pres[i], a)
    else:
        for i in range(P):
            listed = design.pres[i]
            for _ in range(r):
                answers[i].append(ch.call(i, listed))
    strict = [(i, strict_rule(answers[i], q)) for i in range(P)]
    strict = [(i, s) for i, s in strict if s is not None]
    n = design.n
    res = {"strict": len(strict), "presentations": P}
    if carrier == "content":
        rows = [0] * n
        for i, s in strict:
            rows[s] |= design.menus[i] & ~(1 << s)
        cyc = not no_cycle(rows)
    else:  # alternatives (content, position)
        K = max(design.size)
        rows = [0] * (n * K)
        for i, s in strict:
            listed = design.pres[i]
            alt = {c: c * K + j for j, c in enumerate(listed)}
            rows[alt[s]] |= sum(1 << alt[c] for c in listed if c != s)
        cyc = not no_cycle(rows)
    res["C"] = cyc
    # P1 from the met strict picks
    mrows = [0] * n
    for i, s in strict:
        if design.met[i]:
            mrows[s] |= design.menus[i] & ~(1 << s)
    mreach = closure(mrows)
    if any(mreach[x] >> x & 1 for x in range(n)):
        res["P1"] = None  # the met family has a cycle: C is contradicted, P1 is not read
        res["P1_testable"] = 0
    else:
        col = [sum(1 << x for x in range(n) if mreach[x] >> y & 1) for y in range(n)]
        viol = False
        testable = 0
        for i, s in strict:
            if design.met[i]:
                continue
            M = design.menus[i]
            if any(mreach[x] & M & ~(1 << x) for x in design.pres[i]):
                testable += 1
            if (M & ~(1 << s)) & col[s]:
                viol = True
        res["P1"] = viol
        res["P1_testable"] = testable
    # testability: whether the strict menus admit a cycle at all (the occasion-content incidence
    # graph is not a forest), read from the menus, not from the picks
    parent = list(range(n + P))

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    testable = False
    for i, s in strict:
        for c in design.pres[i]:
            a, b = find(n + i), find(c)
            if a == b:
                testable = True
            else:
                parent[a] = b
    res["cycle_possible"] = testable
    # first position among strict pair picks (descriptive)
    fp = [1 if design.pres[i][0] == s else 0 for i, s in strict if design.size[i] == 2]
    res["first_share_pairs"] = sum(fp) / len(fp) if fp else None
    return res


CHOOSERS = [
    # (key, label, class, kwargs, role). Roles (the power check's groups):
    #   law       the law's model with the noise the design tolerates: must not be contradicted
    #   strict    the premise of strictness: near-ties the stability rule must leave not strict,
    #             and ties answered "no preference": must not be contradicted
    #   law+      more noise than tolerated: reported
    #   rival     stable picks that come from no one order on contents: must not pass
    #   boundary  stochastic or hybrid choosers near one order's stable picks: reported
    #   sticky    one order with stable errors at a few presentations (a real departure): reported
    #   passes    one strict order on contents by construction (a content rule, a label kept with
    #             its content): pass every contrast, so the claim tested is only "one strict order
    #             on these contents"
    #   forced    ties broken by position under forced choice: the premise case only a
    #             "no preference" answer can show
    #   history   readers of their own history: must not pass in fresh calls; course reported
    ("L0", "one strict order, no noise", Order, {}, "law"),
    ("L.02", "one strict order, tremble 0.02 per call", Order, {"eps": 0.02}, "law"),
    ("L.05", "one strict order, tremble 0.05 per call", Order, {"eps": 0.05}, "law"),
    ("L.10", "one strict order, tremble 0.10 per call", Order, {"eps": 0.10}, "law"),
    ("Linv", "one strict order, tremble 0.05, invalid answers 0.05", Order, {"eps": 0.05, "invalid": 0.05}, "law"),
    ("RU.95", "random utility, adjacent pair right 0.95", Thurstone, {"p_adj": 0.95}, "law"),
    ("RU.90", "random utility, adjacent pair right 0.90", Thurstone, {"p_adj": 0.90}, "law"),
    ("TieC", "near-ties (0.3 of adjacent pairs) chosen either way afresh per call", Ties, {"tau": 0.3, "coin": True}, "strict"),
    ("TieN", "ties (0.3) answered 'no preference'", Ties, {"tau": 0.3, "no_pref": True}, "strict"),
    ("L.20", "one strict order, tremble 0.20 per call", Order, {"eps": 0.20}, "law+"),
    ("RU.80", "random utility, adjacent pair right 0.80", Thurstone, {"p_adj": 0.80}, "law+"),
    ("RU.70", "random utility, adjacent pair right 0.70", Thurstone, {"p_adj": 0.70}, "law+"),
    ("Alpha", "a content rule unrelated to any valuation (a fixed order)", Order, {}, "passes"),
    ("LabF", "label reader, each content keeping its name", LabelFixed, {}, "passes"),
    ("S.01", "one order with a stable error at 1% of presentations", Order, {"delta": 0.01, "eps": 0.05}, "sticky"),
    ("S.03", "one order with a stable error at 3% of presentations", Order, {"delta": 0.03, "eps": 0.05}, "sticky"),
    ("Pos1", "first listed", Position, {}, "rival"),
    ("Pos.9", "first listed with fidelity 0.9", Position, {"f": 0.9}, "rival"),
    ("Pos.7", "first listed with fidelity 0.7", Position, {"f": 0.7}, "rival"),
    ("PosL", "last listed", Position, {"last": True}, "rival"),
    ("Lab", "label reader, option codes reassigned per call (the protocol)", LabelPerCall, {}, "rival"),
    ("Lab.8", "label reader, codes reassigned per call, fidelity 0.8", LabelPerCall, {"f": 0.8}, "rival"),
    ("Cue", "cue reader (a cue fixed per presentation, as a label would be with codes fixed per presentation)", Cue, {}, "rival"),
    ("Cue.8", "cue reader with fidelity 0.8", Cue, {"f": 0.8}, "rival"),
    ("Comp", "menu-dependent: compromise (the middle) in triples", Compromise, {"eps": 0.02}, "rival"),
    ("Att2", "limited attention, first two listed", Attention, {"k": 2, "eps": 0.02}, "rival"),
    ("Att3", "limited attention, first three listed", Attention, {"k": 3, "eps": 0.02}, "rival"),
    ("MixC", "three orders with cyclic majorities, drawn per call", Mixture, {"kind": "condorcet"}, "rival"),
    ("HyP", "hybrid: random utility, gap 1, first-listed bonus 2 (position decides adjacent pairs)", Thurstone, {"gap": 1.0, "bonus": 2.0}, "rival"),
    ("Unif", "uniform", Uniform, {}, "rival"),
    ("Mix2", "two orders drawn per call, 0.7 and 0.3", Mixture, {"kind": "two", "w": 0.7}, "boundary"),
    ("HyO", "hybrid: random utility, gap 2, first-listed bonus 1 (the order decides)", Thurstone, {"gap": 2.0, "bonus": 1.0}, "boundary"),
    ("Hy.95/.8", "hybrid: random utility 0.95 plus first-listed bonus 0.8", Thurstone, {"p_adj": 0.95, "f0": 0.8}, "boundary"),
    ("TieF", "ties (0.3) broken by position, forced choice", Ties, {"tau": 0.3}, "forced"),
    ("HCopy", "reader of its own history: copies, else first listed", HistoryCopy, {}, "history"),
    ("HOrd", "reader of its own history: builds an order as it goes", HistoryOrder, {}, "history"),
]
ROLE = {key: role for key, _l, _c, _k, role in CHOOSERS}

# The frozen reading of one chooser (candidate rules for the freeze, fixed here by the power check)
VOID_STRICT_SHARE = Fraction(1, 2)  # fewer strict presentations than this share: void
P1_MIN = 10                        # fewer P1-testable strict after-presentations: P1 not read


def verdict(res):
    """C: void (strict share below the floor, or no cycle possible on the strict menus),
    contradicted (a cycle among the strict occasions), or passed. P1: not read where C is void,
    the met family has a cycle, or fewer than P1_MIN after-presentations are P1-testable."""
    void = (Fraction(res["strict"], res["presentations"]) < VOID_STRICT_SHARE
            or not res["cycle_possible"])
    c = "void" if void else ("contradicted" if res["C"] else "passed")
    if void or res["P1"] is None or res["P1_testable"] < P1_MIN:
        p1 = "not read"
    else:
        p1 = "contradicted" if res["P1"] else "passed"
    return c, p1


def run_rows(d, key, r, q, reps, course=False, tag="power"):
    _k, label, cls, kw, role = next(c for c in CHOOSERS if c[0] == key)
    rng = random.Random(f"{SEED}|{tag}|{d.name}|{key}|{course}|{r}|{q}")
    agg = {"contradicted": 0, "void": 0, "passed": 0, "P1 contradicted": 0, "P1 not read": 0,
           "P1 passed": 0, "strict": 0, "P1_testable": 0, "first_share": 0.0, "first_n": 0}
    for _ in range(reps):
        res = simulate(d, cls, kw, r, q, rng, course=course)
        c, p1 = verdict(res)
        agg[c] += 1
        agg["P1 " + p1] += 1
        agg["strict"] += res["strict"]
        agg["P1_testable"] += res["P1_testable"]
        if res["first_share_pairs"] is not None:
            agg["first_share"] += res["first_share_pairs"]
            agg["first_n"] += 1
    return {"design": d.name, "chooser": key, "label": label, "role": role,
            "condition": "course" if course else "fresh", "r": r, "q": q, "reps": reps,
            "P(contradicted)": rate(agg["contradicted"], reps), "P(void)": rate(agg["void"], reps),
            "P(passed)": rate(agg["passed"], reps),
            "P(P1 contradicted)": rate(agg["P1 contradicted"], reps),
            "P(P1 not read)": rate(agg["P1 not read"], reps),
            "mean strict share": round(agg["strict"] / (reps * len(d.pres)), 4),
            "mean P1-testable strict after-presentations": round(agg["P1_testable"] / reps, 2),
            "mean first-listed share of strict pair picks": round(agg["first_share"] / agg["first_n"], 3) if agg["first_n"] else None,
            # Selten (1991): hit rate minus area; the area of every design here is below 1e-18
            "Selten predictive success (passed minus area)": round(agg["passed"] / reps - float(d.area()), 4)}


def power_table(designs, rq, reps, only=None):
    table = []
    for d in designs:
        for key, label, cls, kw, role in CHOOSERS:
            if only is not None and key not in only:
                continue
            conds = (False, True) if key in ("L0", "L.05", "L.10", "HCopy", "HOrd") else (False,)
            for course in conds:
                for (r, q) in rq:
                    table.append(run_rows(d, key, r, q, reps, course=course))
    return table


def carrier_settlement(design, reps, r, q):
    """The carrier: alternatives as contents (each presentation its own occasion) against
    alternatives as (content, position). Only the first gives power against position readers."""
    out = []
    for key, label, cls, kw, role in CHOOSERS:
        if key not in ("L0", "L.05", "Pos1", "PosL", "Att2", "Unif", "Hy.95/.8"):
            continue
        for carrier in ("content", "content_position"):
            rng = random.Random(f"{SEED}|carrier|{key}|{carrier}")
            c = sum(simulate(design, cls, kw, r, q, rng, carrier=carrier)["C"] for _ in range(reps))
            out.append({"chooser": key, "label": label, "carrier": carrier, "r": r, "q": q,
                        "P(a cycle among strict occasions)": rate(c, reps)})
    return out


# The power check's criterion (a design choice, after the reader's proposal; frozen with the
# rules): on the primary design, every chooser of the groups "law" and "strict" is contradicted at
# most 0.05 of the time, and every chooser of "law" is void at most 0.05 of the time; every "rival" passes at most 0.2 of the
# time (it is contradicted or void at least 0.8 of the time). The cheapest (r, q) meeting it, fewest
# calls first and then the larger strict share, is the design's.
LAW_GROUP = tuple(k for k, *_x, role in CHOOSERS if role in ("law", "strict") and k != "L0")
RIVAL_GROUP = tuple(k for k, *_x, role in CHOOSERS if role == "rival")
REPORTED_GROUP = ("L.20", "RU.80", "RU.70", "Mix2", "HyO", "Hy.95/.8", "S.01", "S.03", "TieF")
RQ = ((1, 1), (3, 3), (5, 4), (5, 5), (6, 6), (7, 6), (7, 7), (9, 8), (9, 9))
LAW_MAX_CONTRADICTED = 0.05
LAW_MAX_VOID = 0.05
RIVAL_MAX_PASSED = 0.2


def sweep_rq(design, reps):
    out = []
    for key in LAW_GROUP + RIVAL_GROUP + REPORTED_GROUP:
        for r, q in RQ:
            out.append(run_rows(design, key, r, q, reps, tag="sweep"))
    return out


def settle_rq(sweep):
    status = {}
    for r, q in RQ:
        rows = [s for s in sweep if s["r"] == r and s["q"] == q]
        law = {s["chooser"]: (s["P(contradicted)"], s["P(void)"]) for s in rows if s["chooser"] in LAW_GROUP}
        riv = {s["chooser"]: s["P(passed)"] for s in rows if s["chooser"] in RIVAL_GROUP}
        # the void bound applies to the law's model only: a chooser with ties at most menus is
        # rightly void, so the "strict" group is asked only not to be contradicted
        bad_law = sorted(k for k, (c, v) in law.items()
                         if c > LAW_MAX_CONTRADICTED or (ROLE[k] == "law" and v > LAW_MAX_VOID))
        bad_riv = sorted(k for k, v in riv.items() if v > RIVAL_MAX_PASSED)
        status[f"r={r},q={q}"] = {
            "meets": not bad_law and not bad_riv,
            "law_failing": bad_law, "rivals_passing_too_often": bad_riv,
            "law_worst_P(contradicted)": max(c for c, v in law.values()),
            "law_worst_P(void)": max(v for k, (c, v) in law.items() if ROLE[k] == "law"),
            "strict_group_worst_P(contradicted)": max(c for k, (c, v) in law.items() if ROLE[k] == "strict"),
            "rival_worst_P(passed)": max(riv.values()),
            "L.10 strict share": next(s["mean strict share"] for s in rows if s["chooser"] == "L.10")}
    meeting = [(r, q) for r, q in RQ if status[f"r={r},q={q}"]["meets"]]
    chosen = None
    if meeting:
        chosen = min(meeting, key=lambda rq: (rq[0], -status[f"r={rq[0]},q={rq[1]}"]["L.10 strict share"]))
    return status, chosen


def usage(designs, r):
    """Calls for Stage B per chooser (one model version, one fixed prompt, one domain), fresh calls,
    and the estimate across the planned grid. Tokens are an estimate per call (a short prompt with
    the listed options and a one-field structured answer), stated as such."""
    per = {d.name: len(d.pres) * r for d in designs}
    return per


def informing_power_more():
    """The informing variant's V1 at the (r, q) pairs the main sweep considers."""
    return informing_power(((3, 3), (5, 4), (5, 5), (7, 7), (9, 8), (9, 9)))


# ---------------------------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------------------------

def main():
    out = {"test": "TR1 (RF1, what choices show of an order), Stage 0",
           "seed": SEED, "python": sys.version.split()[0],
           "lean": {"ShownOrder": "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ShownOrder.lean",
                    "ReadingLoop": "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingLoop.lean",
                    "ShownOrder_sha256_in_record": "ca92c7871146fdde11aec4b001c2117a188a58f59eeeabab9f8b6b0764652b43",
                    "ReadingLoop_sha256_in_record": "5ca0f323c689c19d56edeb317a3eb371d715bd74533d5edad32429433db71812"},
           "frozen_reading_candidates": {"void if strict share below": str(VOID_STRICT_SHARE),
                                         "P1 read only with at least this many P1-testable strict after-presentations": P1_MIN,
                                         "criterion": {"law and strict groups": LAW_GROUP,
                                                       "max P(contradicted)": LAW_MAX_CONTRADICTED,
                                                       "max P(void), law group only": LAW_MAX_VOID,
                                                       "rival group": RIVAL_GROUP,
                                                       "max P(passed)": RIVAL_MAX_PASSED}}}
    rng = random.Random(f"{SEED}|mirror")

    t = time.time()
    out["A_mirror_untried"] = mirror_untried()
    out["A_mirror_enumeration_n3"] = mirror_enumeration_n3()
    out["A_mutation_checks"] = mutation_checks()
    posets = strict_orders(5)
    out["A_mirror_enumeration_bigger"] = mirror_enumeration_bigger(rng, posets)
    out["A_seconds"] = round(time.time() - t, 1)

    t = time.time()
    out["B_mirror_untested"] = mirror_untested()
    out["B_floor_forgoes"] = floor_forgoes_check(random.Random(f"{SEED}|floor"))
    out["B_inferences"] = inferences_untested()
    out["B_identification_table"] = identification_table()
    out["B_informing_power"] = informing_power_more()
    out["B_seconds"] = round(time.time() - t, 1)

    t = time.time()
    anc, _stab = anchors()
    out["C_anchors"] = anc
    out["C_area_argument_check"] = check_area_argument()
    chain = [(0, 1), (1, 2), (2, 3)]
    D5 = Design("D5", 5, (2, 3), chain)
    D5q = Design("D5q", 5, (2, 3, 4), chain)
    D5c = Design("D5-complete4", 5, (2, 3), list(itertools.combinations(range(4), 2)))
    D5u = Design("D5-untried", 5, (2, 3), [(0, 1)])
    D6 = Design("D6", 6, (2, 3), [(0, 1), (1, 2), (2, 3), (3, 4)])
    D6q = Design("D6q", 6, (2, 3, 4), [(0, 1), (1, 2), (2, 3), (3, 4)])
    designs = (D5q, D5, D5c, D5u, D6, D6q)
    out["C_designs"] = {d.name: {"n": d.n, "presentations": len(d.pres),
                                 "by_menu_size": {str(k): d.size.count(k) for k in sorted(set(d.size))},
                                 "met_pairs (both orders)": d.met_pairs,
                                 "Selten_area (share of pick patterns allowed)": fr(d.area())}
                        for d in designs}
    out["C_seconds"] = round(time.time() - t, 1)

    t = time.time()
    out["D_p1_structure"] = {d.name: p1_structure(d) for d in designs}
    out["D_mirror_on_designs"] = mirror_on_designs([D5q, D5, D5c, D5u, D6], posets)
    sweep = sweep_rq(D5q, 300)
    status, chosen = settle_rq(sweep)
    out["D_sweep_rq_on_D5q"] = sweep
    out["D_rq_status_on_D5q"] = status
    out["D_rq_chosen"] = list(chosen) if chosen else None
    r, q = chosen if chosen else (9, 8)
    out["D_carrier"] = carrier_settlement(D5q, 400, r, q)
    out["D_power_main"] = power_table([D5q], ((r, q),), 600)
    out["D_power_D6q"] = power_table([D6q], ((r, q),), 150)
    out["D_power_without_quadruples"] = power_table([D5, D6], ((r, q),), 300,
                                                    only=("L.05", "L.10", "RU.90", "TieC", "Att3", "Att2", "Comp", "Pos.7", "HyP", "MixC"))
    out["D_usage_calls_per_chooser"] = usage(designs, r)
    out["D_seconds"] = round(time.time() - t, 1)
    out["E"] = settled(out)
    out["seconds"] = round(time.time() - T0, 1)
    OUT.write_text(json.dumps(out, indent=1, ensure_ascii=False) + "\n")
    print(summary(out))


def settled(out):
    """What Stage 0 settles, and what stays a choice for the freeze (read from the results)."""
    main_rows = {(x["chooser"], x["condition"]): x for x in out["D_power_main"]}
    r, q = out["D_rq_chosen"] or (None, None)

    def row(k, c="fresh"):
        x = main_rows[(k, c)]
        return {kk: x[kk] for kk in ("P(contradicted)", "P(void)", "P(passed)", "P(P1 contradicted)", "mean strict share")}

    s = {}
    s["mirror"] = ("The mirror agrees with the Lean: the Untried witness's statements and evaluations; every "
                   "law of the module by exhaustive enumeration on three alternatives (2,925 families, every "
                   "relation); reach_within on every transitive relation on four, the strict laws against "
                   "every strict order on four and five; two deliberately wrong mirrors are caught.")
    s["repetition"] = {"one call per presentation (r = 1)": {k: x["P(contradicted)"] for k, x in
                       ((s_["chooser"], s_) for s_ in out["D_sweep_rq_on_D5q"] if s_["r"] == 1 and s_["chooser"] in ("L.05", "L.10", "RU.90"))},
                       "reading": "A single call per presentation cannot carry a verdict: the law's model with a "
                                  "tremble of 0.05 shows a cycle almost surely. A stability rule over repeated "
                                  "fresh calls is needed."}
    s["rq"] = {"chosen": [r, q], "status": out["D_rq_status_on_D5q"][f"r={r},q={q}"] if r else None}
    s["carrier"] = ("Contents, each presentation its own occasion, carry the verdict: on contents with "
                    "position, a position reader shows no cycle (power 0 against the readers fixed by what "
                    "they read). The content-with-position family is reported only.")
    s["fresh_or_course"] = {"HOrd fresh": row("HOrd"), "HOrd course": row("HOrd", "course"),
                            "reading": "A reader of its own history that keeps its answers acyclic passes when "
                                       "its history is visible and fails in fresh calls, so fresh calls carry the "
                                       "verdict and the course condition is its control."}
    s["quadruples"] = ("Limited attention to the first three listed passes every design without quadruples "
                       "and is caught with them, so the primary design includes quadruples.")
    s["no_preference"] = {"TieF (forced)": row("TieF"), "TieN (no preference)": row("TieN"),
                          "reading": "Under forced choice, ties broken by position are stable, are counted strict "
                                     "and show cycles: forced choice cannot tell a tie from a position reader. With "
                                     "a 'no preference' answer counted not strict, the same chooser is not "
                                     "contradicted. The primary condition offers it; forced choice is a second "
                                     "condition, reported."}
    s["mixture"] = {"Mix2": row("Mix2"), "MixC": row("MixC"),
                    "reading": "Mixtures of orders drawn per call are mostly not strict under the rule and so "
                               "void, not passed; RF1 has no stochastic form, so their analysis is a periphery "
                               "measure (binary choice frequencies), not a verdict."}
    s["passes_every_contrast"] = {"Alpha": row("Alpha"), "LabF": row("LabF"),
                                  "reading": "A content rule unrelated to any valuation, or a label kept with its "
                                             "content, is one strict order on contents and passes: the claim "
                                             "tested is only 'one strict order on these contents'. The control is "
                                             "a domain with a canonical order (amounts), and names reassigned "
                                             "per call."}
    s["p1"] = ("P1 (a strict after-pick reached, in the met reach, by an alternative open with it) is "
               "contradicted only where C is: it is C's predictive part, read from the met choices. Its "
               "power is lower than C's; it is reported with C, and C carries the verdict.")
    s["choices_left_for_the_freeze"] = [
        "the domains and their contents (the test domain without a canonical order, the positive control with one)",
        "the prompt, the answer schema and the 'no preference' wording",
        "the models and their pinned versions, the harness and the spend guard",
        "the thresholds of the criterion (0.05, 0.05, 0.2) and the void floor (1/2) and P1_MIN (10), proposed here",
        "whether the informing variant runs, and its frozen step s* (here: 1)",
    ]
    return s


def summary(out):
    lines = []
    A = out["A_mirror_untried"]["all_witness_checks_pass"]
    E3 = out["A_mirror_enumeration_n3"]
    EB = out["A_mirror_enumeration_bigger"]
    B = out["B_mirror_untested"]["all_witness_checks_pass"]
    lines.append(f"A: Untried witness checks pass: {A}; n=3 enumeration: {E3['families']} families, "
                 f"{E3['failures']} failures; bigger: {EB['failures']} failures; strict orders "
                 f"{EB['strict_orders_by_extension']}; mutations {out['A_mutation_checks']}")
    lines.append(f"B: Untested witness checks pass: {B}; floor_forgoes {out['B_floor_forgoes']}")
    lines.append(f"B: inferences {dict((k, v) for k, v in out['B_inferences'].items() if k != 'reading')}")
    for row in out["B_identification_table"]["rows"]:
        lines.append(f"   {row['formation']:52s} U {row['U up: acts']} / {row['U down: acts']}  I {row['I up: acts']} / "
                     f"{row['I down: acts']}  C {row['C picks (two name orders)']}  V1x {row['V1 contradicted (a cycle across frames)']}  "
                     f"{row['class (descriptive)']}")
    for x in out["B_informing_power"]:
        lines.append(f"   V1 eps={x['eps']:5s} r={x['r']} q={x['q']}  consistent {x['P(V1 contradicted | consistent formation)']:.2e}  "
                     f"inconsistent {x['P(V1 contradicted | frame-inconsistent formation)']:.3f}")
    lines.append("C: designs " + json.dumps({k: (v["presentations"], v["Selten_area (share of pick patterns allowed)"]["float"]) for k, v in out["C_designs"].items()}))
    for k, v in out["D_p1_structure"].items():
        lines.append(f"D: P1 structure {k}: testable mean {v['testable']['mean']['float']:.2f} (min {v['testable']['min']}), "
                     f"forced mean {v['forced']['mean']['float']:.2f}, inferred pairs mean {v['inferred_pairs']['mean']['float']:.2f}, "
                     f"after {v['after_presentations']}, met {v['met_presentations']}")
    lines.append("D: mirror on designs " + json.dumps(out["D_mirror_on_designs"]))
    for k, v in out["D_rq_status_on_D5q"].items():
        lines.append(f"   rq {k:9s} meets {v['meets']!s:5s} law worst C {v['law_worst_P(contradicted)']:<6} void {v['law_worst_P(void)']:<6} "
                     f"strict-group worst C {v['strict_group_worst_P(contradicted)']:<6} rival worst pass {v['rival_worst_P(passed)']:<6} L.10 strict {v['L.10 strict share']}  "
                     f"law failing {v['law_failing']} rivals passing {v['rivals_passing_too_often']}")
    lines.append(f"D: chosen (r, q) = {out['D_rq_chosen']}")
    for x in out["D_carrier"]:
        lines.append(f"   carrier {x['carrier']:17s} {x['chooser']:9s} P(cycle) {x['P(a cycle among strict occasions)']}")
    for tab in ("D_power_main", "D_power_D6q", "D_power_without_quadruples"):
        for x in out[tab]:
            lines.append(f"   {x['design']:4s} {x['condition']:6s} {x['chooser']:9s} {x['role']:8s} contra {x['P(contradicted)']:<6} void {x['P(void)']:<6} "
                         f"pass {x['P(passed)']:<6} P1x {x['P(P1 contradicted)']:<6} P1nr {x['P(P1 not read)']:<6} strict {x['mean strict share']:<6} "
                         f"P1t {x['mean P1-testable strict after-presentations']:<6} first {x['mean first-listed share of strict pair picks']}")
    lines.append("D: usage calls per chooser " + json.dumps(out["D_usage_calls_per_chooser"]))
    lines.append("E: " + json.dumps(out["E"], ensure_ascii=False))
    lines.append(f"seconds: A {out['A_seconds']} B {out['B_seconds']} C {out['C_seconds']} D {out['D_seconds']} all {out['seconds']}")
    return "\n".join(lines)


if __name__ == "__main__":
    main()
