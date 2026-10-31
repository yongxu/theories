#!/usr/bin/env python3
"""TR6 (RF6.3, a prediction read by what it predicts), Stage 0: the premise and the bridge.

Design work only. Exact values, exhaustive checks on small chains, simulated publics and the power
check; no model is called, nothing is downloaded, nothing is frozen. Python 3.11, standard library
only. Deterministic: integers and fractions.Fraction for exact values, random.Random(seed) with
frozen seeds for the simulated runs.
Run: python3 -B tr6.py   (writes tr6.json beside this file; under a minute on one core)

It mirrors Becoming.ReflexivePrediction (experiments/integrated-correction/general-framework/
generative-basis/lean/becoming/Becoming/ReflexivePrediction.lean, sha256 4eb919e7bb105c90...):

  Right r p := r p = p
  Law.orbit next s 0 = s,  Law.orbit next s (n+1) = next (Law.orbit next s n)   (Recurrence)
  none_right_of_moves, no_predictor_right, not_moves, predictor_iff (choice over the admitted),
  rests_iff_right, right_rests, reached_rests,
  on chain 0..n:  within := forall v <= n, r v <= n ;  keeps := forall v w, v <= w -> w <= n -> r v <= r w
  on_chain (within), rises (within, keeps), below_right (keeps only), stays_from (none),
  again_or_risen (within, keeps), bottom_rests (within, keeps),
  ThresholdResponse (threshold v = if 1 <= v then 2 else 0), Negating (Bool negation),
  Reflecting (reflect v = 2 - v, natural subtraction).

Parts (each writes one key of tr6.json):
  A  the mirror, checked on the Lean's witnesses
  B  every self-map of small chains: the chain laws, where each hypothesis is needed, the bound's
     attainment, maps with no right value, order-reversing maps, and the orbit from any start
     (a candidate core lemma, checked exhaustively)
  C  simulated publics of ten agents: their response tables, shapes, right values and orbits
  D  the power check: offline measurement, the live loops (memoryless and with memory) and the
     verdict rules, on publics that meet the representation and on rivals that do not
  E  the planned protocol: calls and an estimate of tokens per model
"""

import itertools
import json
import math
import random
from fractions import Fraction as Fr
from pathlib import Path

OUT = Path(__file__).with_suffix(".json")
SEED = 20261031
LEAN_SHA = "4eb919e7bb105c90b4eb6dd40467601fa94e160d6ed8674faa376c378be40b3f"


# ---------------------------------------------------------------------------------------------
# A. The mirror
# ---------------------------------------------------------------------------------------------

def right(r, p):
    """ReflexivePrediction.Right."""
    return r(p) == p


def orbit(r, s, n):
    """Law.orbit r s n."""
    for _ in range(n):
        s = r(s)
    return s


def orbit_list(r, s, steps):
    out = [s]
    for _ in range(steps):
        s = r(s)
        out.append(s)
    return out


def threshold(v):
    return 2 if 1 <= v else 0


def negate(b):
    return not b


def reflect(v):
    return max(0, 2 - v)  # natural subtraction


def part_a():
    K = 50
    out = {"lean_module": "Becoming.ReflexivePrediction", "lean_sha256": LEAN_SHA}
    out["ThresholdResponse"] = {
        "within_on_0..2": all(threshold(v) <= 2 for v in range(3)),
        "keeps_on_0..2": all(threshold(v) <= threshold(w) for v in range(3) for w in range(v, 3)),
        "both_right": right(threshold, 0) and right(threshold, 2),
        "reached_by_start_k<50": all(orbit(threshold, 0, k) == 0 and orbit(threshold, 1, k + 1) == 2
                                     for k in range(K)),
        "orbit_from_1": orbit_list(threshold, 1, 5)}
    out["Negating"] = {
        "not_moves": all(negate(b) != b for b in (False, True)),
        "none_right": not any(right(negate, b) for b in (False, True)),
        "alternates_k<50": all(orbit(negate, p, k + 1) != orbit(negate, p, k)
                               for p in (False, True) for k in range(K))}
    out["Reflecting"] = {
        "reverses_v<=w<=8": all(reflect(w) <= reflect(v) for v in range(9) for w in range(v, 9)),
        "middle_right": right(reflect, 1),
        "orbit_from_0 (computed here, not a Lean statement)": orbit_list(reflect, 0, 7),
        "orbit_from_0_ever_right_within_50": any(right(reflect, orbit(reflect, 0, k)) for k in range(K))}
    # rests_iff_right, right_rests, reached_rests on random maps of 0..9
    rng = random.Random(SEED)
    checks = viol = 0
    for _ in range(2000):
        t = [rng.randrange(10) for _ in range(10)]
        r = t.__getitem__
        p = rng.randrange(10)
        for n in range(15):
            checks += 1
            viol += ((orbit(r, p, n + 1) == orbit(r, p, n)) != right(r, orbit(r, p, n)))
        if right(r, p):
            viol += any(orbit(r, p, n) != p for n in range(15))
        q = r(p)
        if right(r, q):
            viol += any(orbit(r, p, n + 1) != q for n in range(15))
    out["rests_iff_right_right_rests_reached_rests"] = {"random_maps_of_0..9": 2000,
                                                         "checks": checks, "violations": viol}
    # no_predictor_right on Bool: every predictor (V -> V) -> V over the four maps of Bool
    maps = [(False, False), (False, True), (True, False), (True, True)]  # (r False, r True)
    admitted_sets = [s for k in range(1, 5) for s in itertools.combinations(range(4), k)]
    holds_where_premise = 0
    premise_count = 0
    iff_checks = iff_viol = 0
    for adm in admitted_sets:
        has_mover = any(maps[i] == (True, False) for i in adm)
        exists = False
        for pred in itertools.product((False, True), repeat=len(adm)):
            if all(maps[i][int(pred[j])] == pred[j] for j, i in enumerate(adm)):
                exists = True
                break
        if has_mover:
            premise_count += 1
            holds_where_premise += (not exists)
        each = all(any(maps[i][int(p)] == p for p in (False, True)) for i in adm)
        iff_checks += 1
        iff_viol += (exists != each)
    out["no_predictor_right_and_predictor_iff_on_Bool"] = {
        "admitted_classes": len(admitted_sets), "classes_with_a_mover": premise_count,
        "no_predictor_right_where_a_mover": holds_where_premise,
        "predictor_iff_checks": iff_checks, "predictor_iff_violations": iff_viol,
        "note": "a predictor reads the response: it is a function from the admitted maps to Bool"}
    return out


# ---------------------------------------------------------------------------------------------
# B. Every map of small chains
# ---------------------------------------------------------------------------------------------

def keeps(t, n):
    return all(t[v] <= t[w] for v in range(n + 1) for w in range(v, n + 1))


def reverses(t, n):
    return all(t[w] <= t[v] for v in range(n + 1) for w in range(v, n + 1))


def rest_step(t, s, limit):
    """The first step j at which publication repeats (orbit j+1 = orbit j), or None."""
    x = s
    for j in range(limit + 1):
        y = t[x] if x < len(t) else None
        if y is None:
            return None
        if y == x:
            return j
        x = y
    return None


EXTENSIONS = {"v + 1": lambda v, n: v + 1, "v (fixes every value off the chain)": lambda v, n: v,
              "n": lambda v, n: n, "0": lambda v, n: 0}


def chain_laws(t, n, off="v + 1"):
    """The chain laws' conclusions on a table t over 0..n (values may leave the chain). In the Lean r
    is a function on all of Nat; a table over 0..n does not fix it beyond n, so `off` names the
    extension read where the orbit leaves the chain (never read when `within` holds)."""
    e = EXTENSIONS[off]
    ext = lambda v: t[v] if v < len(t) else e(v, n)
    orb = [0]
    for _ in range(n + 2):
        orb.append(ext(orb[-1]))
    rights = [f for f in range(n + 1) if t[f] == f]
    res = {
        "on_chain": all(x <= n for x in orb[:n + 2]),
        "rises": all(orb[k] <= orb[k + 1] for k in range(n + 1)),
        "below_right": all(orb[k] <= f for f in rights for k in range(n + 2)),
        "bottom_rests": (ext(orb[n]) == orb[n]) and all(orb[n] <= f for f in rights),
        "again_or_risen": all(any(orb[j + 1] == orb[j] for j in range(k)) or k <= orb[k] for k in range(n + 2)),
        "stays_from": all(all(orb[j + m] == orb[j] for m in range(n + 2 - j)) for j in range(n + 1)
                          if orb[j + 1] == orb[j])}
    return res


def monotone_tables(n, top):
    """Every non-decreasing table over 0..n with values in 0..top."""
    for c in itertools.combinations_with_replacement(range(top + 1), n + 1):
        yield list(c)


def part_b():
    out = {}
    # B1: every self-map of 0..n, n <= 4: the laws under their hypotheses, and how often each
    # conclusion fails where a hypothesis is dropped
    b1 = {}
    for n in range(1, 5):
        total = kept = 0
        viol = {k: 0 for k in ("on_chain", "rises", "below_right", "bottom_rests", "again_or_risen", "stays_from")}
        fails_without_keeps = {k: 0 for k in viol}
        for t in itertools.product(range(n + 1), repeat=n + 1):
            t = list(t)
            total += 1
            laws = chain_laws(t, n)
            viol["on_chain"] += not laws["on_chain"]          # within only
            viol["stays_from"] += not laws["stays_from"]      # no hypothesis
            if keeps(t, n):
                kept += 1
                for k in ("rises", "below_right", "bottom_rests", "again_or_risen"):
                    viol[k] += not laws[k]
            else:
                for k in ("rises", "below_right", "bottom_rests", "again_or_risen"):
                    fails_without_keeps[k] += not laws[k]
        b1[str(n)] = {"self_maps": total, "order_keeping": kept, "violations_under_the_hypotheses": viol,
                      "maps_not_keeping_the_order_where_the_conclusion_fails": fails_without_keeps}
    out["B1_every_self_map_n<=4"] = b1
    # B2: every order-keeping self-map of 0..n, n <= 6: laws, the most steps, the step distribution
    b2 = {}
    for n in range(1, 7):
        count = viol = 0
        steps = {}
        witness_max = None
        for t in monotone_tables(n, n):
            count += 1
            laws = chain_laws(t, n)
            viol += not all(laws.values())
            j = rest_step(t, 0, n)
            steps[j] = steps.get(j, 0) + 1
            if j == n and witness_max is None:
                witness_max = t
        b2[str(n)] = {"order_keeping_self_maps": count, "violations": viol,
                      "rest_step_from_0_distribution": {str(k): v for k, v in sorted(steps.items(), key=lambda x: (x[0] is None, x[0]))},
                      "most_steps": max(k for k in steps if k is not None),
                      "a_map_needing_n_steps": witness_max,
                      "min(v+1,n)_needs_n": rest_step([min(v + 1, n) for v in range(n + 1)], 0, n) == n}
    out["B2_order_keeping_self_maps_n<=6"] = b2
    # B3: dropping `within` (plan section 4.6 drops it): order-keeping tables over 0..n into 0..n+2
    # values in 0..n+2 (a stated choice); r off the chain by each extension in EXTENSIONS, since the
    # counts depend on it (the orbit that leaves the chain reads r there)
    b3 = {}
    for n in range(1, 5):
        row = {}
        for off in EXTENSIONS:
            cnt = leave = below_viol = bottom_fail = 0
            for t in monotone_tables(n, n + 2):
                if all(x <= n for x in t):
                    continue
                cnt += 1
                laws = chain_laws(t, n, off)
                below_viol += not laws["below_right"]
                bottom_fail += not laws["bottom_rests"]
                leave += not laws["on_chain"]
            row[f"r off the chain: {off}"] = {"order_keeping_tables_leaving_the_chain": cnt,
                                              "below_right_violations (needs keeps only)": below_viol,
                                              "bottom_rests_fails": bottom_fail, "orbit_leaves_the_chain": leave}
        row["example"] = [v + 1 for v in range(n + 1)]
        b3[str(n)] = row
    out["B3_without_within"] = {"values": "0..n+2", "by_n": b3,
                                "note": ("the counts depend on r off the chain, which a table over 0..n "
                                         "does not fix; some extension (v + 1, n or 0) breaks bottom_rests "
                                         "in every table whose orbit leaves the chain (5 of 7, 14 of 25, "
                                         "42 of 91, 132 of 336 for n = 1 to 4), and r fixing every value "
                                         "off the chain breaks it in 2")}
    # B4: maps with no right value: every self-map of 0..n, n <= 6 (counted by enumeration to 5,
    # by the formula n^(n+1) at 6, checked against enumeration below 6)
    b4 = {}
    for n in range(1, 7):
        tot = (n + 1) ** (n + 1)
        formula = n ** (n + 1)
        if n <= 5:
            enum = sum(1 for t in itertools.product(range(n + 1), repeat=n + 1)
                       if all(t[v] != v for v in range(n + 1)))
        else:
            enum = None
        b4[str(n)] = {"self_maps": tot, "with_no_right_value (formula n^(n+1))": formula,
                      "by_enumeration": enum, "share": round(formula / tot, 4)}
    out["B4_no_right_value"] = b4
    # B5: order-reversing self-maps of 0..n: how many leave a value, and whether publication from 0
    # reaches it (the Lean states only that some reversing maps leave one, Reflecting)
    b5 = {}
    for n in range(1, 7):
        rev = nonconst = with_right = reached = 0
        two_cycle = 0
        for t in monotone_tables(n, n):
            t = t[::-1]  # non-increasing
            rev += 1
            if len(set(t)) == 1:
                continue
            nonconst += 1
            rights = [f for f in range(n + 1) if t[f] == f]
            if rights:
                with_right += 1
                orb = orbit_list(t.__getitem__, 0, 2 * n + 4)
                if any(x in rights for x in orb):
                    reached += 1
                else:
                    two_cycle += 1
        b5[str(n)] = {"order_reversing_self_maps": rev, "non_constant": nonconst,
                      "non_constant_with_a_right_value": with_right,
                      "of_which_reached_from_0": reached, "of_which_never_reached": two_cycle}
    out["B5_order_reversing"] = b5
    # B6: the orbit from any start under an order-keeping self-map (candidate core lemma):
    # if r s >= s, publication rises to the least right value >= s within n - s steps;
    # if r s <= s, it falls to the greatest right value <= s within s steps.
    b6 = {}
    for n in range(1, 7):
        checks = viol = 0
        for t in monotone_tables(n, n):
            for s in range(n + 1):
                checks += 1
                orb = orbit_list(t.__getitem__, s, n + 1)
                if t[s] >= s:
                    target = min(f for f in range(s, n + 1) if t[f] == f)
                    ok = orb[n - s] == target and all(orb[k] <= orb[k + 1] for k in range(n))
                else:
                    target = max(f for f in range(0, s + 1) if t[f] == f)
                    ok = orb[s] == target and all(orb[k] >= orb[k + 1] for k in range(n))
                viol += not ok
        b6[str(n)] = {"checks": checks, "violations": viol}
    out["B6_orbit_from_any_start_candidate_lemma"] = {
        "statement": ("For r keeping 0..n and its order and any start s <= n: if s <= r s, the orbit "
                      "from s never falls and is at step n - s the least right value >= s; if r s <= s, "
                      "it never rises and is at step s the greatest right value <= s. Not in the Lean; "
                      "checked here exhaustively for n <= 6; a candidate core lemma."),
        "by_n": b6}
    return out


# ---------------------------------------------------------------------------------------------
# C. Simulated publics of ten agents
# ---------------------------------------------------------------------------------------------
# An agent's decision at a published forecast p (0..N, the number predicted to take part):
#   bandwagon agent with threshold th: takes part iff p >= th (taking part pays when enough do)
#   congestion agent with capacity c:  takes part iff p <  c  (taking part pays when few do)
# The response is the count, so it maps 0..N into itself by construction (`within`).

N = 10


def table_of(decide):
    return [sum(decide(i, p) for i in range(N)) for p in range(N + 1)]


def shape(t):
    n = len(t) - 1
    rights = [f for f in range(n + 1) if t[f] == f]
    sh = ("constant" if len(set(t)) == 1 else "keeps the order" if keeps(t, n)
          else "reverses the order" if reverses(t, n) else "neither")
    return {"table": t, "shape": sh, "right_values": rights,
            "least_right": min(rights) if rights else None,
            "moves_every_value": not rights,
            "orbit_from_0": orbit_list(t.__getitem__, 0, 12),
            "rest_step_from_0": rest_step(t, 0, 2 * n)}


PUBLICS = {
    "bandwagon, full climb (thresholds 0,1,2,3,3,5,6,6,8,9)": ("band", [0, 1, 2, 3, 3, 5, 6, 6, 8, 9]),
    "bandwagon, stalled (thresholds 0,1,2,4,4,5,7,8,9,10)": ("band", [0, 1, 2, 4, 4, 5, 7, 8, 9, 10]),
    "Granovetter: thresholds 0..9": ("band", list(range(10))),
    "Granovetter: 0,2,2,3,..,9 (one threshold moved)": ("band", [0, 2, 2, 3, 4, 5, 6, 7, 8, 9]),
    "bandwagon, identical (threshold 5)": ("band", [5] * 10),
    "congestion, spread (capacities 1..10)": ("cong", list(range(1, 11))),
    "congestion, identical (capacity 6)": ("cong", [6] * 10),
    "congestion, uneven (capacities 2,3,3,4,6,6,7,8,9,9)": ("cong", [2, 3, 3, 4, 6, 6, 7, 8, 9, 9]),
    "identity (each forecast is met)": ("id", None),
    "constant 4 (deaf to the forecast)": ("const", 4),
}


def decide_fn(kind, par):
    if kind == "band":
        return lambda i, p: int(p >= par[i])
    if kind == "cong":
        return lambda i, p: int(p < par[i])
    if kind == "id":
        return lambda i, p: int(i < p)
    if kind == "const":
        return lambda i, p: int(i < par)
    raise ValueError(kind)


def part_c():
    return {name: shape(table_of(decide_fn(*spec))) for name, spec in PUBLICS.items()}


# ---------------------------------------------------------------------------------------------
# D. The power check
# ---------------------------------------------------------------------------------------------
# Protocol simulated (per framing):
#   offline: every agent at every forecast 0..N, R fresh calls; its decision at p is the modal one
#            where at least R-1 of R agree, else the decision is flagged; table = count of modal ones
#   arm A:   memoryless live loop, fresh calls: publish 0, then each round the last count; S seeds,
#            ROUNDS rounds each (publications 0..N, so the count after the last is orbit N+1)
#   arm B:   the same loop with memory (each agent keeps its own course of rounds); S seeds
#   V1 (premise, offline): no flagged decision; the table read (not constant); its shape
#   V2 (the representation along the loop, at the Lean's level): the Lean's response r is the
#            count, so a round mismatches where the live count differs from the offline table's
#            count at the published forecast. V2 contradicted where arm B's mismatching rounds
#            exceed arm A's by an exact one-sided Fisher test at 0.05; reported as "not
#            contradicted" otherwise (no support is claimed for a theorem)
#   individual mismatches (a diagnostic, not a verdict): live decisions differing from the agent's
#            offline modal decision. They test a stronger premise than the Lean's (each agent a
#            function of the forecast alone) and can be resolved where the count is unchanged
#            (agents exchanging rules: the cancellation control)
#   forbidden cases (reported in each arm): a fall, a pass above the least right value found
#            offline, no rest by round N, a right round followed by another count, and under a
#            table moving every value, a right round
R = 5
S = 5
ROUNDS = N + 1


def fisher_one_sided(a, n1, b, n2):
    """P(X >= a) for X hypergeometric: a mismatches of n1 in arm B, b of n2 in arm A."""
    k = a + b
    tot = math.comb(n1 + n2, k)
    return sum(math.comb(n1, x) * math.comb(n2, k - x) for x in range(a, min(k, n1) + 1)) / tot


class Agent:
    """One agent of a simulated public: a base decision rule, residual nondeterminism eta (each call
    flipped with that chance), and an optional memory rule used only in arm B."""
    def __init__(self, base, eta, memory=None, w=0.0):
        self.base, self.eta, self.memory, self.w = base, eta, memory, w

    def call(self, i, p, rng, past=None):
        d = self.base(i, p)
        if past is not None and self.memory:
            d = self.memory(i, p, d, past, rng, self.w)
        if self.eta and rng.random() < self.eta:
            d = 1 - d
        return d


def inertia(i, p, d, past, rng, w):
    """With chance w, repeat the agent's own last decision."""
    if past["own"] and rng.random() < w:
        return past["own"][-1]
    return d


def momentum_band(thresholds):
    def m(i, p, d, past, rng, w):
        """After two rises of the count, take part one below the threshold (trend following)."""
        c = past["counts"]
        if len(c) >= 2 and c[-1] > c[-2] and rng.random() < w:
            return int(p >= thresholds[i] - 1)
        return d
    return m


def regret_cong(caps):
    def m(i, p, d, past, rng, w):
        """After going to a crowded round (count >= capacity), stay out once (learning from payoffs)."""
        if past["own"] and past["own"][-1] == 1 and past["counts"][-1] >= caps[i] and rng.random() < w:
            return 0
        return d
    return m


def rule_exchange(base):
    def m(i, p, d, past, rng, w):
        """From round 1 the agents exchange decision rules cyclically: agent i decides by agent
        (i + t) mod N's rule at round t. Every agent departs from its own offline decisions, but the
        count at each forecast is the table's (the cancellation control)."""
        t = len(past["own"])
        return base((i + t) % N, p)
    return m


def trend_reader(i, p, d, past, rng, w):
    """Reads the last two counts, not the forecast: takes part where the count rose (a public
    reading its history, as learning-to-forecast subjects do)."""
    c = past["counts"]
    if len(c) >= 2 and rng.random() < w:
        return int(c[-1] >= c[-2])
    return d


def run_protocol(agents, rng):
    # offline
    modal = [[None] * (N + 1) for _ in range(N)]
    flagged = 0
    for i, a in enumerate(agents):
        for p in range(N + 1):
            calls = [a.call(i, p, rng) for _ in range(R)]
            ones = sum(calls)
            if ones >= R - 1:
                modal[i][p] = 1
            elif ones <= 1:
                modal[i][p] = 0
            else:
                flagged += 1
                modal[i][p] = int(ones * 2 > R)
    table = [sum(modal[i][p] for i in range(N)) for p in range(N + 1)]
    rights = [f for f in range(N + 1) if table[f] == f]
    least = min(rights) if rights else None
    moves_all = not rights

    def live(memory_on):
        mism = 0
        decisions = 0
        cmism = 0
        rounds = 0
        forb = {"fall": 0, "passes the least right value": 0, "no rest by round N": 0,
                "right not repeated": 0, "right where none can be": 0}
        clean_forb = 0
        moving = 0
        for _ in range(S):
            pubs = [0]
            counts = []
            owns = [[] for _ in range(N)]
            seed_mism = 0
            seed_cmism = 0
            for t in range(ROUNDS):
                p = pubs[-1]
                ds = []
                for i, a in enumerate(agents):
                    past = {"own": owns[i], "counts": counts} if memory_on else None
                    d = a.call(i, p, rng, past)
                    ds.append(d)
                    mism += (d != modal[i][p])
                    seed_mism += (d != modal[i][p])
                    decisions += 1
                for i, d in enumerate(ds):
                    owns[i].append(d)
                c = sum(ds)
                counts.append(c)
                pubs.append(c)
                rounds += 1
                cmism += (c != table[p])
                seed_cmism += (c != table[p])
            seq = pubs  # publications 0..ROUNDS (the last is the final count)
            moving += sum(1 for k in range(ROUNDS) if seq[k + 1] != seq[k])
            before = sum(forb.values())
            if any(seq[k + 1] < seq[k] for k in range(len(seq) - 1)) and keeps(table, N):
                forb["fall"] += 1
            if least is not None and keeps(table, N) and any(x > least for x in seq):
                forb["passes the least right value"] += 1
            if keeps(table, N) and seq[N + 1] != seq[N]:
                forb["no rest by round N"] += 1
            rr = next((k for k in range(ROUNDS) if seq[k + 1] == seq[k]), None)
            if rr is not None and any(x != seq[rr] for x in seq[rr:]):
                forb["right not repeated"] += 1
            if moves_all and any(seq[k + 1] == seq[k] for k in range(ROUNDS)):
                forb["right where none can be"] += 1
            if seed_cmism == 0 and sum(forb.values()) > before:
                clean_forb += 1
        forb["in a seed with no count mismatch (a harness fault)"] = clean_forb
        return mism, decisions, forb, moving / S, cmism, rounds

    ma, na, fa, mva, ca, ra = live(False)
    mb, nb, fb, mvb, cb, rb = live(True)
    pval = fisher_one_sided(cb, rb, ca, ra)
    pind = fisher_one_sided(mb, nb, ma, na)
    return {"flagged": flagged, "table": table, "keeps": keeps(table, N), "reverses": reverses(table, N),
            "constant": len(set(table)) == 1, "moves_all": moves_all, "least": least,
            "identity": all(table[f] == f for f in range(N + 1)),
            "mA": ma, "nA": na, "mB": mb, "nB": nb, "p": pval, "p_individual": pind,
            "cA": ca, "rA": ra, "cB": cb, "rB": rb, "fA": fa, "fB": fb,
            "moving_rounds_B": mvb}


def summarize(results, true_table):
    reps = len(results)
    f = lambda pred: round(sum(1 for r in results if pred(r)) / reps, 4)
    keysf = results[0]["fA"].keys()
    return {
        "V1: no flagged decision": f(lambda r: r["flagged"] == 0),
        "V1: table equals the public's true table": f(lambda r: r["table"] == true_table),
        "V1: measured shape keeps the order": f(lambda r: r["keeps"] and not r["constant"] and not r["identity"]),
        "V1: measured shape reverses the order": f(lambda r: r["reverses"] and not r["constant"]),
        "V1: measured table constant (not read)": f(lambda r: r["constant"]),
        "V1: measured table the identity (every forecast met)": f(lambda r: r["identity"]),
        "mean rounds in arm B whose publication moves": round(sum(r["moving_rounds_B"] for r in results) / reps, 2),
        "V2 contradicted (rounds whose count mismatches; Fisher one-sided 0.05)":
            f(lambda r: r["flagged"] == 0 and r["p"] < 0.05),
        "mean rounds whose count mismatches A / B": [round(sum(r["cA"] for r in results) / reps, 2),
                                                     round(sum(r["cB"] for r in results) / reps, 2)],
        "diagnostic: individual-level test contradicted (decisions; Fisher one-sided 0.05)":
            f(lambda r: r["flagged"] == 0 and r["p_individual"] < 0.05),
        "mean individual mismatches A / B": [round(sum(r["mA"] for r in results) / reps, 2),
                                             round(sum(r["mB"] for r in results) / reps, 2)],
        "forbidden case seen in some seed, arm A": {k: f(lambda r, k=k: r["fA"][k] > 0) for k in keysf},
        "forbidden case seen in some seed, arm B": {k: f(lambda r, k=k: r["fB"][k] > 0) for k in keysf},
    }


def part_d(reps=300):
    rng = random.Random(SEED + 7)
    out = {"R": R, "S_seeds_per_arm": S, "rounds": ROUNDS, "replications": reps,
           "decisions_per_arm": S * ROUNDS * N}
    stalled = PUBLICS["bandwagon, stalled (thresholds 0,1,2,4,4,5,7,8,9,10)"][1]
    climb = PUBLICS["bandwagon, full climb (thresholds 0,1,2,3,3,5,6,6,8,9)"][1]
    spread = PUBLICS["congestion, spread (capacities 1..10)"][1]
    ident = PUBLICS["congestion, identical (capacity 6)"][1]
    cases = []
    for label, kind, par in (("bandwagon, stalled", "band", stalled), ("bandwagon, full climb", "band", climb),
                             ("congestion, spread", "cong", spread), ("congestion, identical", "cong", ident)):
        base = decide_fn(kind, par)
        true_table = table_of(base)
        for eta in (0.0, 0.001, 0.01):
            cases.append((f"{label}: memoryless, eta {eta}", true_table, [Agent(base, eta) for _ in range(N)]))
        for w in (0.1, 0.3):
            cases.append((f"{label}: inertia w {w}, eta 0.001", true_table,
                          [Agent(base, 0.001, inertia, w) for _ in range(N)]))
        mem = momentum_band(par) if kind == "band" else regret_cong(par)
        mname = "momentum" if kind == "band" else "regret after a crowded round"
        for w in (0.3, 1.0):
            cases.append((f"{label}: {mname} w {w}, eta 0.001", true_table,
                          [Agent(base, 0.001, mem, w) for _ in range(N)]))
        cases.append((f"{label}: trend reader w 0.5, eta 0.001", true_table,
                      [Agent(base, 0.001, trend_reader, 0.5) for _ in range(N)]))
        cases.append((f"{label}: agents exchange rules (cancellation control), eta 0.001", true_table,
                      [Agent(base, 0.001, rule_exchange(base), 1.0) for _ in range(N)]))
    # rivals offline: deaf, identity (forecast read as an instruction), hybrid half deaf
    for label, kind, par in (("constant 4 (deaf)", "const", 4), ("identity", "id", None)):
        base = decide_fn(kind, par)
        cases.append((f"{label}: memoryless, eta 0.001", table_of(base), [Agent(base, 0.001) for _ in range(N)]))
    half = lambda i, p: (int(p >= stalled[i]) if i % 2 == 0 else int(i < 5))
    cases.append(("hybrid: even agents bandwagon-stalled, odd agents deaf, eta 0.001", table_of(half),
                  [Agent(half, 0.001) for _ in range(N)]))
    rows = {}
    for label, true_table, agents in cases:
        res = [run_protocol(agents, rng) for _ in range(reps)]
        rows[label] = summarize(res, true_table)
    out["rows"] = rows
    # exact pieces: the chance an agent decision is flagged at R = 5 (at least 2 and at most 3 of
    # 5 flipped), and the chance the whole offline table has none flagged (N x (N+1) decisions)
    ex = {}
    for eta in (Fr(1, 1000), Fr(1, 100), Fr(1, 20)):
        pf = sum(math.comb(R, k) * eta ** k * (1 - eta) ** (R - k) for k in (2, 3))
        ex[str(eta)] = {"P(decision flagged)": round(float(pf), 6),
                        "P(no flagged decision in the table)": round(float((1 - pf) ** (N * (N + 1))), 4),
                        "P(a modal decision wrong)": round(float(sum(math.comb(R, k) * eta ** k * (1 - eta) ** (R - k)
                                                                     for k in (4, 5))), 8)}
    out["exact_offline_R5"] = ex
    # Fisher: the fewest mismatching rounds in arm B that contradict V2 when arm A has 0, 1, 2 or 5
    # (S x ROUNDS rounds per arm), and the same for the individual diagnostic (decisions)
    for key, nd in (("fewest_arm_B_mismatching_rounds_contradicting_V2", S * ROUNDS),
                    ("fewest_arm_B_individual_mismatches_contradicting_the_diagnostic", S * ROUNDS * N)):
        fewest = {}
        for b in (0, 1, 2, 5):
            a = 0
            while fisher_one_sided(a, nd, b, nd) >= 0.05:
                a += 1
            fewest[f"arm A {b}"] = a
        out[key] = fewest
    return out


# ---------------------------------------------------------------------------------------------
# E. The planned protocol and its usage
# ---------------------------------------------------------------------------------------------

def part_e():
    framings = 2
    offline = framings * N * (N + 1) * R
    arm_a = framings * S * ROUNDS * N
    arm_b = framings * S * ROUNDS * N
    unread = framings * N * R                 # a round with no forecast
    identity_ctrl = N * (N + 1) * 1           # payoffs not told: forecast read as an instruction?
    from_right = framings * 3 * N * 2         # start at a right value found offline, 3 rounds, arms A and B
    probes = framings * (N + 1) * 2           # comprehension: restate the forecast and the payoff rule
    pilot = 300                               # determinism pilot, a screen: with no flip it excludes eta above about 1/100
    total = offline + arm_a + arm_b + unread + identity_ctrl + from_right + probes + pilot
    tin, tout = 280, 8
    # arm B carries each agent's course: round t adds about 60 tokens of own decision and count
    arm_b_tokens = framings * S * N * sum(tin + 60 * t + tout for t in range(ROUNDS))
    tokens = (total - arm_b) * (tin + tout) + arm_b_tokens
    return {"calls_per_model": {"offline table (2 framings x 10 agents x 11 forecasts x R 5)": offline,
                                "arm A, memoryless (2 x 5 seeds x 11 rounds x 10)": arm_a,
                                "arm B, with memory (2 x 5 seeds x 11 rounds x 10)": arm_b,
                                "no-forecast round (2 x 10 x 5)": unread,
                                "identity control (10 x 11, payoffs not told)": identity_ctrl,
                                "start at a right value (2 x 3 rounds x 10 x 2 arms)": from_right,
                                "comprehension probes (2 x 11 x 2)": probes,
                                "determinism pilot": pilot,
                                "total, before re-asks": total},
            "tokens_per_model_estimate": tokens,
            "assumptions": ("about 280 input and 8 output tokens a stateless call; arm B adds about 60 "
                            "tokens of course per round; no reasoning tokens (a reasoning model adds its "
                            "reasoning, measured at the smoke run)"),
            "three_families": {"calls": 3 * total, "tokens": 3 * tokens}}


def main():
    import time
    out = {"test": "TR6 (RF6.3, a prediction read by what it predicts)", "stage": "0: design, no model called",
           "seed": SEED, "python": "3.11, standard library"}
    t0 = time.time()
    for key, f in (("A_mirror", part_a), ("B_chains", part_b), ("C_publics", part_c),
                   ("D_power", part_d), ("E_usage", part_e)):
        out[key] = f()
        print(f"{key}: {time.time() - t0:.1f} s", flush=True)
    OUT.write_text(json.dumps(out, indent=1, ensure_ascii=False) + "\n")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
