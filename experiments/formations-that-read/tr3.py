#!/usr/bin/env python3
"""TR3 (RF4, readers reading readers), Stage 0: where the premise holds, and the conditional verdict.

Design work only. Exact values, exhaustive checks and the power check; no model is called, nothing
is downloaded, nothing is frozen. Python 3.11, standard library only. Deterministic: fractions.Fraction
for every exact value, random.Random(seed) with frozen seeds for the simulated runs, floats only for
the logit (quantal-response) rival and for the reported normal approximations.
Run: python3 -B tr3.py   (writes tr3.json beside this file; about two minutes on one core)

It mirrors Becoming.Cascade (experiments/integrated-correction/general-framework/generative-basis/
lean/becoming/Becoming/Cascade.lean, sha256 e6add4291cb2af7c...):

  structure Turns W O A where coupling : Nat -> W -> O ; law : Nat -> O -> List A -> A
  acts w 0 = []        acts w (n+1) = acts w n ++ [law n (coupling n w) (acts w n)]
  act w n = law n (coupling n w) (acts w n)
  ReadsOnlyActsFrom k := forall n, k <= n -> forall o o' (before : List A), law n o before = law n o' before
  AlikeBefore k w w'  := forall j, j < k -> coupling j w = coupling j w'
  law_alike_of_cascade, acts_alike_of_cascade, act_alike_of_cascade, cascade_through, separates_at,
  Copying.turns, Copying.readsOnlyActs, Copying.reaches_first_only.

Parts (each writes one key of tr3.json):
  A  the mirror, checked on the Lean's witness (Copying) and on every law of small pools;
     the reached-history form, proved since as Turns.acts_alike_along, checked beside it
  B  the urn game: the deterministic BHW member and its rivals, exact own-draw dependence D per cell
  C  BHW's timing values, and where its law meets the Lean's premise (it meets it at no position)
  D  the stochastic analogue a sampled arm would need (a total-variation bound), checked exactly
  E  the power check: the frozen classification of a cell, BHW's rule, RF4's conditional verdict
  F  the planned protocol: cells, calls and an estimate of tokens per model
"""

import itertools
import json
import math
import random
from fractions import Fraction as Fr
from pathlib import Path

OUT = Path(__file__).with_suffix(".json")
SEED = 20261031
CASCADE_SHA = "e6add4291cb2af7cefb3882ed48619aeaa6a473446fd5ff5b2505c49fe5df538"


def fr(x):
    """A value for the JSON: exact as a string where it is a Fraction, with a float beside it."""
    if isinstance(x, Fr):
        return {"exact": f"{x.numerator}/{x.denominator}" if x.denominator != 1 else str(x.numerator),
                "float": round(float(x), 6)}
    if isinstance(x, float):
        return round(x, 6)
    return x


# ---------------------------------------------------------------------------------------------
# A. The mirror of Becoming.Cascade
# ---------------------------------------------------------------------------------------------

def acts(coupling, law, w, n):
    """Turns.acts: the acts of members 0..n-1, in turn."""
    h = ()
    for j in range(n):
        h = h + (law(j, coupling(j, w), h),)
    return h


def act(coupling, law, w, n):
    """Turns.act: member n's act."""
    return law(n, coupling(n, w), acts(coupling, law, w, n))


def reads_only_acts_from(law, k, N, O, A, lengths):
    """Turns.ReadsOnlyActsFrom k, on members k..N-1, every two couplings in O, every list over A of
    each length in `lengths` (lists no run gives a member included)."""
    for n in range(k, N):
        for m in lengths:
            for before in itertools.product(A, repeat=m):
                vals = {law(n, o, before) for o in O}
                if len(vals) > 1:
                    return False
    return True


def alike_before(coupling, k, w, w2):
    """Turns.AlikeBefore k w w'."""
    return all(coupling(j, w) == coupling(j, w2) for j in range(k))


def copying_law(fallback):
    """Turns.Copying.turns: member 0 acts as its coupling; later members copy the first act of the
    list, or give `fallback` where the list is empty."""
    def law(n, o, before):
        if n == 0:
            return o
        return before[0] if before else fallback
    return law


def check_copying():
    """The Lean's witness: Copying.readsOnlyActs (a cascade from member 1) and reaches_first_only."""
    out = {}
    for O in ((0, 1), (0, 1, 2)):
        N = 5
        worlds = list(itertools.product(O, repeat=N))
        coupling = lambda n, w: w[n]
        law = copying_law(O[0])
        lengths = range(0, N + 2)  # every list of length 0..N+1: the Lean's 'every list', bounded
        from1 = reads_only_acts_from(law, 1, N, O, O, lengths)
        from0 = reads_only_acts_from(law, 0, N, O, O, lengths)
        pairs = viol = 0
        for w in worlds:
            for w2 in worlds:
                if w[0] == w2[0]:
                    for n in range(N):
                        pairs += 1
                        if act(coupling, law, w, n) != act(coupling, law, w2, n):
                            viol += 1
        # nonvacuity: worlds differing in member 0's coupling differ in some act
        apart = sum(1 for w in worlds for w2 in worlds if w[0] != w2[0]
                    and acts(coupling, law, w, N) != acts(coupling, law, w2, N))
        apart_total = sum(1 for w in worlds for w2 in worlds if w[0] != w2[0])
        out[f"couplings_{len(O)}"] = {
            "members": N, "worlds": len(worlds),
            "ReadsOnlyActsFrom_1": from1, "ReadsOnlyActsFrom_0": from0,
            "reaches_first_only_checks": pairs, "reaches_first_only_violations": viol,
            "pairs_apart_in_member_0_with_different_acts": f"{apart} of {apart_total}"}
    return out


def enumerate_boolean_pools(N=3):
    """Every Turns with N members, Boolean couplings and acts: member n's law is a table over
    (own coupling, the n earlier acts), 2^(2^(n+1)) tables. A table is extended to lists of other
    lengths through the length-n list they truncate or pad to with 0, so for these laws the Lean's
    premise over every list is the premise over the length-n lists (checked below for N = 3 on a
    sample, by the explicit-list checker)."""
    sizes = [1 << (1 << (n + 1)) for n in range(N)]
    worlds = list(range(1 << N))  # bit j is member j's coupling
    res = {"members": N, "laws": math.prod(sizes), "worlds": len(worlds)}
    premise_count = [0] * (N + 1)
    conclusion_checks = conclusion_viol = 0
    reached_checks = reached_viol = reached_not_full = 0
    sep_checks = sep_viol = 0
    nonvacuous = 0
    for tables in itertools.product(*[range(s) for s in sizes]):
        # acts of every world, as a tuple of bits
        runs = []
        for w in worlds:
            hb = 0
            seq = []
            for n in range(N):
                o = (w >> n) & 1
                a = (tables[n] >> ((o << n) | hb)) & 1
                seq.append(a)
                hb |= a << n
            runs.append(tuple(seq))
        # ReadsOnlyActsFrom k on the length-n lists
        ignores = [((tables[n] & ((1 << (1 << n)) - 1)) == (tables[n] >> (1 << n))) for n in range(N)]
        for k in range(N + 1):
            full = all(ignores[n] for n in range(k, N))
            mask = (1 << k) - 1
            if full:
                premise_count[k] += 1
            for w in worlds:
                for w2 in worlds:
                    if (w ^ w2) & mask:
                        continue
                    same = runs[w] == runs[w2]
                    if full:
                        conclusion_checks += 1
                        if not same:
                            conclusion_viol += 1
                    elif not same:
                        nonvacuous += 1
                    # the reached-history premise: for n >= k, law n gives one act for the two
                    # worlds' couplings at the history world w reaches
                    reached = True
                    hb = 0
                    for n in range(N):
                        if n >= k:
                            o, o2 = (w >> n) & 1, (w2 >> n) & 1
                            if ((tables[n] >> ((o << n) | hb)) & 1) != ((tables[n] >> ((o2 << n) | hb)) & 1):
                                reached = False
                                break
                        hb |= runs[w][n] << n
                    if reached:
                        reached_checks += 1
                        if not same:
                            reached_viol += 1
                        if not full:
                            reached_not_full += 1
        # separates_at: wherever the first n acts agree, act w n != act w' n iff the law at that
        # shared list gives different acts for the two couplings
        for w in worlds:
            for w2 in worlds:
                for n in range(N):
                    if runs[w][:n] != runs[w2][:n]:
                        continue
                    sep_checks += 1
                    hb = sum(a << i for i, a in enumerate(runs[w][:n]))
                    o, o2 = (w >> n) & 1, (w2 >> n) & 1
                    lhs = runs[w][n] != runs[w2][n]
                    rhs = ((tables[n] >> ((o << n) | hb)) & 1) != ((tables[n] >> ((o2 << n) | hb)) & 1)
                    if lhs != rhs:
                        sep_viol += 1
    res.update({
        "laws_meeting_ReadsOnlyActsFrom_k": {str(k): premise_count[k] for k in range(N + 1)},
        "acts_alike_of_cascade_checks": conclusion_checks, "acts_alike_of_cascade_violations": conclusion_viol,
        "pairs_alike_before_k_with_different_acts_where_the_premise_fails": nonvacuous,
        "separates_at_checks": sep_checks, "separates_at_violations": sep_viol,
        "reached_history_form_checks": reached_checks, "reached_history_form_violations": reached_viol,
        "reached_history_premise_met_where_the_Lean_premise_fails": reached_not_full})
    return res


def check_extension_claim(N=3, samples=400, seed=SEED):
    """For table laws extended through truncation or padding, the premise over every list of
    length 0..N+1 equals the premise over the length-n lists (the claim enumerate_boolean_pools
    rests on), on random tables."""
    rng = random.Random(seed)
    agree = 0
    for _ in range(samples):
        tables = [rng.randrange(1 << (1 << (n + 1))) for n in range(N)]
        # bias toward premises that hold
        for n in range(N):
            if rng.random() < 0.5:
                low = tables[n] & ((1 << (1 << n)) - 1)
                tables[n] = low | (low << (1 << n))

        def law(n, o, before, tables=tables):
            b = (tuple(before) + (0,) * n)[:n]
            hb = sum(a << i for i, a in enumerate(b))
            return (tables[n] >> ((o << n) | hb)) & 1

        for k in range(N + 1):
            every = reads_only_acts_from(law, k, N, (0, 1), (0, 1), range(0, N + 2))
            # the premise checked member by member on each member's own length only
            own = True
            for n in range(k, N):
                for before in itertools.product((0, 1), repeat=n):
                    if law(n, 0, before) != law(n, 1, before):
                        own = False
            agree += (every == own)
    return {"samples": samples * (N + 1), "agree": agree}


def enumerate_ternary_pools():
    """Every Turns with 2 members, couplings in {0,1,2}, Boolean acts (512 laws), checked with
    the explicit-list mirror."""
    O, A, N = (0, 1, 2), (0, 1), 2
    worlds = list(itertools.product(O, repeat=N))
    coupling = lambda n, w: w[n]
    entries0 = list(O)
    entries1 = list(itertools.product(O, A))
    checks = viol = sep_checks = sep_viol = 0
    premise = [0] * (N + 1)
    for t0 in itertools.product(A, repeat=len(entries0)):
        for t1 in itertools.product(A, repeat=len(entries1)):
            d0 = dict(zip(entries0, t0))
            d1 = dict(zip(entries1, t1))

            def law(n, o, before, d0=d0, d1=d1):
                if n == 0:
                    return d0[o]
                b = before[0] if before else 0
                return d1[(o, b)]

            for k in range(N + 1):
                full = reads_only_acts_from(law, k, N, O, A, range(0, N + 1))
                if full:
                    premise[k] += 1
                    for w in worlds:
                        for w2 in worlds:
                            if alike_before(coupling, k, w, w2):
                                checks += 1
                                if acts(coupling, law, w, N) != acts(coupling, law, w2, N):
                                    viol += 1
            for w in worlds:
                for w2 in worlds:
                    for n in range(N):
                        if acts(coupling, law, w, n) == acts(coupling, law, w2, n):
                            sep_checks += 1
                            lhs = act(coupling, law, w, n) != act(coupling, law, w2, n)
                            h = acts(coupling, law, w, n)
                            rhs = law(n, w[n], h) != law(n, w2[n], h)
                            sep_viol += (lhs != rhs)
    return {"members": N, "couplings": 3, "laws": 8 * 64, "laws_meeting_premise_k": premise,
            "acts_alike_of_cascade_checks": checks, "violations": viol,
            "separates_at_checks": sep_checks, "separates_at_violations": sep_viol}


def random_boolean_pools(N=5, laws=1500, seed=SEED + 1):
    """Random Turns with N members (each member's law ignores its coupling with probability 1/2,
    otherwise a random table): the law and the reached-history form, pair by pair."""
    rng = random.Random(seed)
    worlds = range(1 << N)
    checks = viol = rchecks = rviol = rnotfull = 0
    for _ in range(laws):
        tables = []
        for n in range(N):
            t = rng.randrange(1 << (1 << (n + 1)))
            if rng.random() < 0.5:
                low = t & ((1 << (1 << n)) - 1)
                t = low | (low << (1 << n))
            tables.append(t)
        ignores = [((tables[n] & ((1 << (1 << n)) - 1)) == (tables[n] >> (1 << n))) for n in range(N)]
        runs = []
        for w in worlds:
            hb = 0
            for n in range(N):
                o = (w >> n) & 1
                a = (tables[n] >> ((o << n) | hb)) & 1
                hb |= a << n
            runs.append(hb)
        for k in range(N + 1):
            full = all(ignores[n] for n in range(k, N))
            mask = (1 << k) - 1
            for w in worlds:
                for w2 in worlds:
                    if (w ^ w2) & mask:
                        continue
                    same = runs[w] == runs[w2]
                    if full:
                        checks += 1
                        viol += (not same)
                    reached = True
                    for n in range(k, N):
                        hb = runs[w] & ((1 << n) - 1)
                        o, o2 = (w >> n) & 1, (w2 >> n) & 1
                        if ((tables[n] >> ((o << n) | hb)) & 1) != ((tables[n] >> ((o2 << n) | hb)) & 1):
                            reached = False
                            break
                    if reached:
                        rchecks += 1
                        rviol += (not same)
                        rnotfull += (not full)
    return {"members": N, "laws": laws, "seed": seed,
            "acts_alike_of_cascade_checks": checks, "violations": viol,
            "reached_history_form_checks": rchecks, "reached_history_form_violations": rviol,
            "reached_premise_met_where_the_Lean_premise_fails": rnotfull}


def part_a():
    return {
        "lean_module": "Becoming.Cascade", "lean_sha256": CASCADE_SHA,
        "copying_witness": check_copying(),
        "extension_claim": check_extension_claim(),
        "every_boolean_pool_of_three": enumerate_boolean_pools(3),
        "every_pool_of_two_ternary_couplings": enumerate_ternary_pools(),
        "random_boolean_pools_of_five": random_boolean_pools(),
        "reached_history_form": (
            "Inference from the proof term of law_alike_of_cascade, which uses the premise only at "
            "T.acts w n with the two worlds' couplings: if, for every n >= k, law n gives one act "
            "for coupling n w and coupling n w' at the list acts w n, then worlds alike before k "
            "give the same acts. Proved since: Turns.acts_alike_along under Turns.LawAlikeAlong "
            "(Becoming.ReachedCascade)."),
    }


# ---------------------------------------------------------------------------------------------
# B. The urn game: the deterministic BHW member and its rivals
# ---------------------------------------------------------------------------------------------
# State theta in {1 (A), 0 (B)}, prior P(A) = prior; draws i.i.d. given theta, P(draw = theta) = p.
# A member sees its own draw s (its coupling) and the list of earlier guesses (the earlier acts).
# Every type below is a law: P(guess A | position n, draw s, history h).

class Urn:
    def __init__(self, p, prior):
        self.p, self.prior = p, prior

    def lik(self, s, theta):
        return self.p if s == theta else 1 - self.p

    def post(self, mu, s):
        num = mu * self.lik(s, 1)
        return num / (num + (1 - mu) * self.lik(s, 0))


def decide_own(q, s, mu):
    return Fr(1) if q > Fr(1, 2) else Fr(0) if q < Fr(1, 2) else Fr(s)


def decide_coin(q, s, mu):
    return Fr(1) if q > Fr(1, 2) else Fr(0) if q < Fr(1, 2) else Fr(1, 2)


def decide_public(q, s, mu):
    if q != Fr(1, 2):
        return Fr(1) if q > Fr(1, 2) else Fr(0)
    return Fr(1) if mu > Fr(1, 2) else Fr(0) if mu < Fr(1, 2) else Fr(s)


def decide_overweight(t):
    """Abandon the own draw only where the odds against the state it indicates exceed t:1."""
    t = Fr(t)

    def d(q, s, mu):
        q_own = q if s == 1 else 1 - q
        follow_own = not (q_own < 1 / (1 + t))
        a = s if follow_own else 1 - s
        return Fr(a)
    return d


def decide_logit(lam):
    def d(q, s, mu):
        x = lam * (2 * float(q) - 1)
        return 1.0 / (1.0 + math.exp(-x))
    return d


class FilterType:
    """A member that reads the earlier guesses through the public belief, computed by Bayes on the
    assumption that every earlier member is of its own type (common knowledge), then decides on
    its posterior. A guess of probability 0 under both states (off the type's own path) is read,
    by convention, as revealing the draw it names, so that the member acts at every history the
    experimenter shows; `on_path` says where the convention was not needed. BHW's predictions are
    taken only on its own path."""
    def __init__(self, name, urn, decide, exact=True):
        self.name, self.urn, self.decide, self.exact = name, urn, decide, exact
        self.cache = {}
        self.path_cache = {(): True}

    def mu(self, h):
        if h in self.cache:
            return self.cache[h]
        if not h:
            m = self.urn.prior if self.exact else float(self.urn.prior)
        else:
            m0 = self.mu(h[:-1])
            a = h[-1]
            l1 = sum(self.urn.lik(s, 1) * self._pa(m0, s, a) for s in (0, 1))
            l0 = sum(self.urn.lik(s, 0) * self._pa(m0, s, a) for s in (0, 1))
            if l1 == 0 and l0 == 0:
                self.path_cache[h] = False
                l1, l0 = self.urn.lik(a, 1), self.urn.lik(a, 0)
                if not self.exact:
                    l1, l0 = float(l1), float(l0)
            else:
                self.path_cache[h] = self.path_cache[h[:-1]]
            m = m0 * l1 / (m0 * l1 + (1 - m0) * l0)
        self.cache[h] = m
        return m

    def on_path(self, h):
        self.mu(h)
        return self.path_cache[h]

    def _pa(self, m, s, a):
        q = self.urn.post(m, s) if self.exact else self._postf(m, s)
        pA = self.decide(q, s, m)
        return pA if a == 1 else 1 - pA

    def _postf(self, m, s):
        p = float(self.urn.p)
        num = m * (p if s == 1 else 1 - p)
        return num / (num + (1 - m) * ((1 - p) if s == 1 else p))

    def prob_A(self, n, s, h):
        m = self.mu(h)
        q = self.urn.post(m, s) if self.exact else self._postf(m, s)
        return self.decide(q, s, m)


class Naive:
    """Counts every earlier guess as an independent draw (naive inference, Eyster and Rabin 2010);
    ties to the own draw."""
    def __init__(self, urn):
        self.name, self.urn = "naive counting", urn

    def prob_A(self, n, s, h):
        r = self.urn.p / (1 - self.urn.p)
        odds = self.urn.prior / (1 - self.urn.prior) * r ** (sum(h) - (len(h) - sum(h))) * (r if s == 1 else 1 / r)
        return Fr(1) if odds > 1 else Fr(0) if odds < 1 else Fr(s)


class Rule:
    """A deterministic reader given by a rule on (position, draw, history)."""
    def __init__(self, name, f):
        self.name, self.f = name, f

    def prob_A(self, n, s, h):
        return Fr(self.f(n, s, h))


def majority(h, s):
    a = sum(h)
    b = len(h) - a
    return 1 if a > b else 0 if b > a else s


class Mix:
    """With probability q the member follows its own draw, else `base` (a hybrid of reading and a
    rival); with flip > 0, the act is flipped with that probability (noise that reads nothing)."""
    def __init__(self, name, base, q=Fr(0), flip=Fr(0)):
        self.name, self.base, self.q, self.flip = name, base, q, flip

    def prob_A(self, n, s, h):
        b = self.base.prob_A(n, s, h)
        if b is None:
            return None
        x = self.q * s + (1 - self.q) * b
        return (1 - self.flip) * x + self.flip * (1 - x)


def make_types(urn, logit=(2.0, 5.0, 10.0)):
    bhw = FilterType("BHW, ties to the own draw", urn, decide_own)
    naive = Naive(urn)
    types = [
        bhw,
        FilterType("BHW, ties by a coin", urn, decide_coin),
        FilterType("BHW, ties to the public", urn, decide_public),
        FilterType("overweighting 3:2", urn, decide_overweight(Fr(3, 2))),
        FilterType("overweighting 2:1", urn, decide_overweight(Fr(2))),
        FilterType("overweighting 3:1", urn, decide_overweight(Fr(3))),
        naive,
        Rule("copier (Copying.turns)", lambda n, s, h: s if n == 0 else h[0]),
        Rule("last-act copier", lambda n, s, h: s if n == 0 else h[-1]),
        Rule("majority copier", lambda n, s, h: majority(h, s)),
        Rule("constant A (fixed by label)", lambda n, s, h: 1),
        Rule("fixed by position", lambda n, s, h: n % 2),
        Rule("own draw always", lambda n, s, h: s),
        Rule("contrarian to the last", lambda n, s, h: s if n == 0 else 1 - h[-1]),
    ]
    for lam in logit:
        types.append(FilterType(f"logit response, precision {lam:g}", urn, decide_logit(lam), exact=False))
    for q in (Fr(1, 10), Fr(1, 4), Fr(1, 2)):
        types.append(Mix(f"hybrid: own draw w.p. {q}, else counting", naive, q=q))
    for e in (Fr(1, 100), Fr(1, 20)):
        types.append(Mix(f"counting with flips w.p. {e}", naive, flip=e))
    return types


def D(t, n, h):
    a, b = t.prob_A(n, 1, h), t.prob_A(n, 0, h)
    if a is None or b is None:
        return None
    return a - b


def cell_list(prior_units):
    """The cells the premise map reads. prior_units 0: prior 1:1; 1: a prior worth one draw for A."""
    A, B = 1, 0
    if prior_units == 0:
        static = [(), (A,), (B,), (A, B), (B, A)]
        paths = {"(A,A)": [(A,) * j for j in range(2, 8)], "(B,B)": [(B,) * j for j in range(2, 8)]}
        explore = [(A, A, B), (B, B, A), (A, A, A, B)]
    else:
        static = [(), (B,), (B, A), (B, B)]
        paths = {"(A)": [(A,) * j for j in range(1, 8)], "(B,B,B)": [(B,) * j for j in range(3, 8)]}
        explore = [(A, B), (A, A, B)]
    return static, paths, explore


def hname(h):
    return "(" + ",".join("A" if a else "B" for a in h) + ")"


def part_b(p=Fr(3, 5)):
    """Exact D per cell for every type, at the planned precision and both priors."""
    out = {"precision": fr(p), "priors": {}}
    for units in (0, 1):
        prior = Fr(1, 2) if units == 0 else p  # one draw's worth: odds p/(1-p)
        urn = Urn(p, prior)
        types = make_types(urn)
        static, paths, explore = cell_list(units)
        cells = static + [h for v in paths.values() for h in v] + explore
        table = {}
        for t in types:
            row = {}
            for h in cells:
                d = D(t, len(h), h)
                v = fr(d)["exact"] if isinstance(d, Fr) else round(d, 4)
                if isinstance(t, FilterType) and not t.on_path(h):
                    v = f"{v} (off its own path; by the convention)"
                row[hname(h)] = v
            table[t.name] = row
        out["priors"]["1:1" if units == 0 else "one draw for A"] = {
            "prior": fr(prior), "static_cells": [hname(h) for h in static],
            "paths": {k: [hname(h) for h in v] for k, v in paths.items()},
            "exploration_cells_no_bhw_prediction": [hname(h) for h in explore],
            "D_by_type": table}
    # where each rival parts from BHW (|D| differs by at least 1/2 at an on-path cell, or the act
    # differs where both ignore the draw)
    parts = {}
    for units in (0, 1):
        prior = Fr(1, 2) if units == 0 else p
        urn = Urn(p, prior)
        types = make_types(urn)
        bhw = types[0]
        static, paths, explore = cell_list(units)
        cells = static + [h for v in paths.values() for h in v]
        for t in types[1:]:
            where = []
            for h in cells:
                n = len(h)
                db, dt = D(bhw, n, h), D(t, n, h)
                if dt is None:
                    where.append(hname(h) + ": undefined")
                    continue
                if abs(float(db) - float(dt)) >= 0.5:
                    where.append(hname(h) + f": D {fr(db)['exact'] if isinstance(db, Fr) else db} vs {round(float(dt), 3)}")
                elif db == 0 and float(dt) == 0:
                    ab, at = bhw.prob_A(n, 1, h), t.prob_A(n, 1, h)
                    if ab != at:
                        where.append(hname(h) + ": ignores, other act")
            parts.setdefault(t.name, {})["1:1" if units == 0 else "one draw for A"] = where
    out["where_each_rival_parts_from_bhw"] = parts
    # the precision choice: where the 2:1-overweighting rival starts to ignore its draw, by precision
    grid = {}
    for pp in (Fr(5, 9), Fr(3, 5), Fr(2, 3), Fr(3, 4)):
        r = pp / (1 - pp)
        row = {}
        for tt in (Fr(3, 2), Fr(2), Fr(5, 2), Fr(3)):
            d = 1
            while not (r ** (d - 1) > tt):
                d += 1
            row[f"{tt}:1"] = d
        grid[str(pp)] = {"bhw_cascade_at_net_informative_guesses": 2,
                         "overweighting_cascade_at": row,
                         "odds_against_a_contrary_draw_at_2": fr(r)}
    out["precision_choice"] = grid
    return out


# ---------------------------------------------------------------------------------------------
# C. BHW's timing values, and where its law meets the Lean's premise
# ---------------------------------------------------------------------------------------------

def bhw_runs(p, prior, N, decide=decide_own):
    """Exact distribution over guess histories of N members under each state, for BHW, with the
    cascade start (the first position whose member gives one act for both draws at the history
    reached) and its act."""
    urn = Urn(p, prior)
    t = FilterType("bhw", urn, decide)
    res = {}
    for theta in (1, 0):
        dist = {(): Fr(1)}
        for n in range(N):
            nxt = {}
            for h, ph in dist.items():
                for s in (0, 1):
                    ps = urn.lik(s, theta)
                    pa = t.prob_A(n, s, h)
                    for a, pr in ((1, pa), (0, 1 - pa)):
                        if pr:
                            nxt[h + (a,)] = nxt.get(h + (a,), Fr(0)) + ph * ps * pr
            dist = nxt
        res[theta] = dist
    return t, res


def cascade_start(t, h):
    for n in range(len(h)):
        if D(t, n, h[:n]) == 0:
            return n, t.prob_A(n, 1, h[:n])
    return None, None


def part_c():
    out = {}
    N = 10
    for p in (Fr(5, 9), Fr(3, 5), Fr(2, 3), Fr(3, 4)):
        row = {}
        for tie, dec in (("own draw", decide_own), ("coin", decide_coin)):
            t, res = bhw_runs(p, Fr(1, 2), N, dec)
            dist = res[1]  # true urn A
            start_at = {}
            wrong = none = Fr(0)
            for h, ph in dist.items():
                n, a = cascade_start(t, h)
                if n is None:
                    none += ph
                else:
                    start_at[n] = start_at.get(n, Fr(0)) + ph
                    if a == 0:
                        wrong += ph
            by = lambda m: sum((v for k, v in start_at.items() if k <= m), Fr(0))
            row[f"ties: {tie}"] = {
                "P(cascade starts at member 2)": fr(start_at.get(2, Fr(0))),
                "P(started by member 4)": fr(by(4)), "P(started by member 6)": fr(by(6)),
                "P(wrong cascade within ten members)": fr(wrong), "P(no cascade within ten members)": fr(none)}
        out[str(p)] = row
    # where the law meets the premise: at each position, a reachable history where the member reads
    p = Fr(2, 3)
    t, res = bhw_runs(p, Fr(1, 2), N)
    reach = {n: set() for n in range(N)}
    for theta in (1, 0):
        for h in res[theta]:
            for n in range(N):
                reach[n].add(h[:n])
    reads_somewhere = {}
    for n in range(N):
        hs = sorted(reach[n])
        reading = [hname(h) for h in hs if D(t, n, h) != 0]
        reads_somewhere[str(n)] = {"reachable_histories": len(hs), "reading_at": len(reading),
                                   "example": reading[0] if reading else None}
    meets_for = [k for k in range(N) if all(reads_somewhere[str(n)]["reading_at"] == 0 for n in range(k, N))]
    out["premise_at_p_2/3"] = {"positions": reads_somewhere,
                               "k_from_which_BHW_ignores_its_draw_at_every_reachable_list": meets_for,
                               "note": ("reachable lists are weaker than the Lean's every list; BHW meets "
                                        "even this weaker premise from no k <= 9")}
    # the stopping-time form on the BHW instance: worlds are draw assignments; tau(w) the cascade
    # start in w; worlds alike in the draws before tau(w) give the same guesses
    worlds = list(itertools.product((0, 1), repeat=N))
    urn = Urn(p, Fr(1, 2))
    tt = FilterType("bhw", urn, decide_own)

    def law(n, o, h):
        return 1 if tt.prob_A(n, o, h) == 1 else 0

    coupling = lambda n, w: w[n]
    runs = {w: acts(coupling, law, w, N) for w in worlds}
    tau = {}
    for w in worlds:
        h = runs[w]
        tau[w] = next((n for n in range(N) if D(tt, n, h[:n]) == 0), N)
    # persistence: in BHW (deterministic) every member from tau(w) on ignores its draw at the
    # history w reaches (a cascade is absorbing). The general stopping-time form needs this as a
    # premise: a first ignoring member followed by a reading one breaks it (counterexample below).
    persist_viol = sum(1 for w in worlds for n in range(tau[w], N) if D(tt, n, runs[w][:n]) != 0)
    # the counterexample to the form without persistence: member 0 reads its draw, member 1 is
    # constant, member 2 reads its draw; tau = 1 for every world, yet worlds alike before 1 differ
    ce_law = lambda n, o, h: 0 if n == 1 else o
    ce_worlds = list(itertools.product((0, 1), repeat=3))
    ce_runs = {w: acts(lambda n, w: w[n], ce_law, w, 3) for w in ce_worlds}
    ce_pairs = [(w, w2) for w in ce_worlds for w2 in ce_worlds if w[:1] == w2[:1] and ce_runs[w] != ce_runs[w2]]
    checks = viol = tau_viol = 0
    by_prefix = {}
    for w in worlds:
        by_prefix.setdefault(w[:tau[w]], []).append(w)
    for w in worlds:
        for w2 in by_prefix.get(w[:tau[w]], []):
            checks += 1
            viol += runs[w] != runs[w2]
            tau_viol += tau[w] != tau[w2]
    # the fixed-k form: for each k, pairs alike before k; the reached premise (for n >= k, one act
    # for the two worlds' draws at the history w reaches) and the conclusion. Worlds as bit masks:
    # the premise holds iff every member n >= k whose draws differ ignores its draw at w's history.
    wbits = {w: sum(b << i for i, b in enumerate(w)) for w in worlds}
    ign = {w: sum(1 << n for n in range(N) if law(n, 0, runs[w][:n]) == law(n, 1, runs[w][:n])) for w in worlds}
    fixed = {}
    for k in range(N + 1):
        low = (1 << k) - 1
        met = met_same = alike = 0
        for w in worlds:
            bw, iw = wbits[w], ign[w]
            for w2 in worlds:
                diff = bw ^ wbits[w2]
                if diff & low:
                    continue
                alike += 1
                if diff & ~iw == 0:
                    met += 1
                    met_same += runs[w] == runs[w2]
        fixed[str(k)] = {"pairs_alike_before_k": alike, "pairs_meeting_reached_premise": met,
                         "of_which_same_acts": met_same}
    out["stopping_time_form_p_2/3"] = {
        "worlds": len(worlds), "pairs_alike_before_tau": checks, "different_acts": viol,
        "different_tau": tau_viol,
        "persistence_violations (a member from tau(w) on reading its draw at w's history)": persist_viol,
        "counterexample_without_persistence": {
            "laws": "member 0 reads its draw, member 1 always B, member 2 reads its draw; tau = 1 everywhere",
            "pairs_alike_before_tau_with_different_acts": len(ce_pairs),
            "example": [list(ce_pairs[0][0]), list(ce_pairs[0][1])] if ce_pairs else None},
        "note": ("tau(w) is the first position whose member gives one guess for both draws at the "
                 "history w reaches; the stopping-time form, a candidate core lemma, needs persistence as a premise (every "
                 "member from tau(w) on ignores its draw at the history w reaches), which BHW meets "
                 "since its cascades are absorbing; checked here on BHW only (the Lean fixes k)")}
    out["fixed_k_reached_premise_p_2/3"] = fixed
    # prior worth one draw for A at p = 2/3 (odds 2:1): where BHW cascades
    urn2 = Urn(Fr(2, 3), Fr(2, 3))
    t2 = FilterType("bhw", urn2, decide_own)
    cells = [(), (1,), (0,), (0, 1), (0, 0), (0, 0, 0), (0, 0, 0, 0)]
    out["prior_2:1_at_p_2/3"] = {hname(h): (None if D(t2, len(h), h) is None else fr(D(t2, len(h), h)))
                                for h in cells}
    return out


# ---------------------------------------------------------------------------------------------
# D. The stochastic analogue: total variation of the act list across later draws
# ---------------------------------------------------------------------------------------------

class Leaky:
    """Outside the Turns representation: from position `start` on, with probability lam the member
    guesses the next member's draw (a channel beyond its own draw and the earlier acts)."""
    def __init__(self, base, lam, start):
        self.name, self.base, self.lam, self.start = f"leaky {lam}", base, lam, start

    def prob_A_leak(self, n, s, h, nxt):
        b = self.base.prob_A(n, s, h)
        if n < self.start or nxt is None:
            return b
        return (1 - self.lam) * b + self.lam * nxt


def law_of_acts(t, prefix, draws, leak=False):
    """Exact law of the guesses of members k..N-1 after the scripted prefix, given their draws."""
    k = len(prefix)
    dist = {prefix: (Fr(1) if not isinstance(t, FilterType) or t.exact else 1.0)}
    for i, s in enumerate(draws):
        n = k + i
        nxt_draw = draws[i + 1] if i + 1 < len(draws) else None
        new = {}
        for h, ph in dist.items():
            pA = t.prob_A_leak(n, s, h, nxt_draw) if leak else t.prob_A(n, s, h)
            for a, pr in ((1, pA), (0, 1 - pA)):
                if pr:
                    new[h + (a,)] = new.get(h + (a,), 0) + ph * pr
        dist = new
    return dist


def tv(d1, d2):
    keys = set(d1) | set(d2)
    return sum(abs(d1.get(x, 0) - d2.get(x, 0)) for x in keys) / 2


def part_d(p=Fr(3, 5), N=8):
    urn = Urn(p, Fr(1, 2))
    naive = Naive(urn)
    prefix = (1, 1)
    k = len(prefix)
    types = [FilterType("BHW, ties to the own draw", urn, decide_own),
             FilterType("BHW, ties by a coin", urn, decide_coin)]
    types += [Mix(f"hybrid: own draw w.p. {q}, else counting", naive, q=q) for q in (Fr(1, 20), Fr(1, 5), Fr(1, 2))]
    types += [Mix(f"counting with flips w.p. {e}", naive, flip=e) for e in (Fr(1, 100), Fr(1, 20))]
    bhw0 = FilterType("BHW, ties to the own draw (base of the flipped rows)", urn, decide_own)
    types += [Mix(f"BHW with flips w.p. {e}", bhw0, flip=e) for e in (Fr(1, 1000), Fr(1, 100))]
    types += [FilterType(f"logit response, precision {lam:g}", urn, decide_logit(lam), exact=False) for lam in (2.0, 5.0, 10.0)]
    assignments = list(itertools.product((0, 1), repeat=N - k))
    rows = []
    for t in types:
        laws = {a: law_of_acts(t, prefix, a) for a in assignments}
        tv_max = max(tv(laws[a], laws[b]) for a, b in itertools.combinations(assignments, 2))
        # the weighted form (the hybrid argument with each member's dependence averaged over the
        # histories the earlier draws actually reach): for assignments a, b and hybrids
        # H_j = b[:j] + a[j:], TV(L(a), L(b)) <= sum over j with a_j != b_j of
        # E_{h ~ law of the history at position k + j under the draws b[:j]} |D(k + j, h)|.
        # Unlike the sum of eps_n it can lie below 1. For every member in Turns (its act depends only
        # on the history and its own draw) it holds by the hybrid argument and data processing, so a
        # violation could come only from a simulator fault: the check verifies the simulator.
        hist_law = {}
        for b in assignments:
            for j in range(N - k):
                if b[:j] not in hist_law:
                    hist_law[b[:j]] = law_of_acts(t, prefix, b[:j])
        exp_abs_d = {}
        for pre, dist in hist_law.items():
            n = k + len(pre)
            exp_abs_d[pre] = sum(ph * abs(D(t, n, h)) for h, ph in dist.items())
        pairs = viol_w = below1 = 0
        w_at_max = None
        min_gap = None
        for a, b in itertools.combinations(assignments, 2):
            tvab = tv(laws[a], laws[b])
            wb = sum(exp_abs_d[b[:j]] for j in range(N - k) if a[j] != b[j])
            wa = sum(exp_abs_d[a[:j]] for j in range(N - k) if a[j] != b[j])
            wab = min(wa, wb)
            pairs += 1
            viol_w += float(tvab) > float(wab) + 1e-12
            if float(wab) < 1:
                below1 += 1
                g = float(wab) - float(tvab)
                min_gap = g if min_gap is None else min(min_gap, g)
            if tvab == tv_max and w_at_max is None:
                w_at_max = wab
        weighted = {"pairs": pairs, "violations": viol_w, "pairs_with_weighted_bound_below_1": below1,
                    "smallest_gap_bound_minus_tv_where_bound_below_1": None if min_gap is None else round(min_gap, 6),
                    "weighted_bound_at_a_pair_of_largest_tv": round(float(w_at_max), 6)}
        # selections: the majority of all N guesses, and the last guess
        def sel(dist, f):
            out = {}
            for h, ph in dist.items():
                out[f(h)] = out.get(f(h), 0) + ph
            return out
        tv_maj = max(tv(sel(laws[a], lambda h: int(sum(h) * 2 > len(h))), sel(laws[b], lambda h: int(sum(h) * 2 > len(h))))
                     for a, b in itertools.combinations(assignments, 2))
        # eps_n: the largest |D| over histories reachable from the prefix at position n
        reach = {prefix}
        bound = 0
        eps = []
        for n in range(k, N):
            e = max(abs(D(t, n, h)) for h in reach)
            eps.append(e)
            bound += e
            reach = {h + (a,) for h in reach for a in (0, 1)
                     if any((t.prob_A(n, s, h) if a == 1 else 1 - t.prob_A(n, s, h)) for s in (0, 1))}
        rows.append({"type": t.name, "tv_max_act_list": fr(tv_max) if isinstance(tv_max, Fr) else round(tv_max, 6),
                     "tv_max_majority": fr(tv_maj) if isinstance(tv_maj, Fr) else round(tv_maj, 6),
                     "bound_sum_of_eps": fr(bound) if isinstance(bound, Fr) else round(bound, 6),
                     "holds": float(tv_max) <= float(bound) + 1e-12,
                     "sum_of_eps_check_informative": float(bound) < 1,
                     "weighted_form": weighted})
    # outside the representation: the member reads the next member's draw
    lk = Leaky(Rule("follows the prefix", lambda n, s, h: 1), Fr(1, 2), k)
    laws = {a: law_of_acts(lk, prefix, a, leak=True) for a in assignments}
    tv_leak = max(tv(laws[a], laws[b]) for a, b in itertools.combinations(assignments, 2))
    rows.append({"type": "leaky 1/2 (reads the next member's draw; own D = 0)", "tv_max_act_list": fr(tv_leak),
                 "bound_sum_of_eps": fr(Fr(0)), "holds": False,
                 "note": "outside Turns: the member-wise premise holds and the bound does not apply"})
    return {"precision": fr(p), "members": N, "scripted_prefix": "(A,A)", "k": k,
            "later_draw_assignments": len(assignments),
            "statement_checked": ("If every member from k on has |P(A | a, h) - P(A | b, h)| <= eps_n at every "
                                  "history reachable at its position, the act list's law moves by at most "
                                  "the sum of eps_n in total variation between any two assignments of the "
                                  "later draws (a hybrid argument; not proved in Lean; a candidate periphery "
                                  "lemma, since the core has no probability)."),
            "rows": rows, "all_hold_within_turns": all(r["holds"] for r in rows[:-1]),
            "note_on_the_sum_form": ("total variation is at most 1, so the sum-of-eps check can fail only "
                                     "in rows whose sum is below 1: here only the two BHW rows without "
                                     "flips (sum 0); every other row meets it trivially"),
            "weighted_statement": ("For assignments a, b of the later draws, TV <= sum over the positions "
                                   "j where they differ of E|D(k + j, h)|, h drawn from the law of the "
                                   "history at k + j under the draws of one assignment before j (the hybrid "
                                   "argument; the smaller of the two orders is used). Not in the Lean; "
                                   "it can lie below 1. For every member in Turns it holds by the hybrid "
                                   "argument and data processing, so its check verifies the simulator, "
                                   "not the members. It is attained at pairs differing in one draw and "
                                   "is loose at the pairs of largest total variation where members read "
                                   "(the hybrids and the logit rows)."),
            "weighted_all_hold_within_turns": all(r["weighted_form"]["violations"] == 0 for r in rows[:-1])}


# ---------------------------------------------------------------------------------------------
# E. The power check
# ---------------------------------------------------------------------------------------------
# A cell is (prior, history). At temperature 0 each cell is asked R times with each draw.
# Frozen classification (rule C0), on the 2R guesses:
#   'ignores A' / 'ignores B'  all 2R guesses one act;
#   'reads'                    the R under draw a unanimous, the R under draw b unanimous, and apart
#                              ('follows' where the act is the draw, 'inverted' otherwise);
#   'flagged'                  anything else (the cell shows nondeterminism; no class).

def classes(x, y, R):
    """Exact probabilities of each class, given P(A | draw a) = x and P(A | draw b) = y per call."""
    return {"ignores A": x ** R * y ** R, "ignores B": (1 - x) ** R * (1 - y) ** R,
            "reads (follows)": x ** R * (1 - y) ** R, "reads (inverted)": (1 - x) ** R * y ** R}


def flagged(c):
    return 1 - sum(c.values())


class Noisy:
    """A type observed through residual nondeterminism: each call's guess flipped w.p. eta."""
    def __init__(self, base, eta):
        self.base, self.eta = base, eta
        self.name = f"{base.name}, flips {eta}"

    def prob_A(self, n, s, h):
        x = self.base.prob_A(n, s, h)
        if x is None:
            return None
        return (1 - self.eta) * x + self.eta * (1 - x)


def bhw_prediction(bhw, n, h):
    if not bhw.on_path(h):
        return None
    d = D(bhw, n, h)
    if d == 0:
        return "ignores A" if bhw.prob_A(n, 1, h) == 1 else "ignores B"
    return "reads (follows)"


def bhw_rule_outcome(t, bhw, units, R, cls=None):
    """Exact P(placed), P(contradicted), P(unresolved) of BHW's frozen rule for member type t:
    placed where every planned cell's class is BHW's prediction; contradicted where some reached
    cell's class (not flagged) differs; unresolved otherwise. Paths are followed along BHW's
    predicted path: a flagged cell ends a path (later cells unreached)."""
    cls = cls or classes
    static, paths, _ = cell_list(units)
    p_place = 1
    p_nocontra = 1
    for h in static:
        x, y = t.prob_A(len(h), 1, h), t.prob_A(len(h), 0, h)
        if x is None or y is None:
            return None
        c = cls(x, y, R)
        pred = bhw_prediction(bhw, len(h), h)
        p_place *= c[pred]
        p_nocontra *= c[pred] + flagged(c)
    for name, cells in paths.items():
        reach = 1  # probability the path has matched so far
        pl = 1
        nc = 0
        for h in cells:
            x, y = t.prob_A(len(h), 1, h), t.prob_A(len(h), 0, h)
            if x is None or y is None:
                return None
            c = cls(x, y, R)
            pred = bhw_prediction(bhw, len(h), h)
            nc += reach * flagged(c)  # stops here, no contradiction so far
            reach *= c[pred]
        nc += reach
        p_place *= reach
        p_nocontra *= nc
    return {"placed": p_place, "contradicted": 1 - p_nocontra, "unresolved": p_nocontra - p_place}


def call(t, n, s, h, rng, nxt=None):
    if isinstance(t, Leaky):
        pA = t.prob_A_leak(n, s, h, nxt)
    else:
        pA = t.prob_A(n, s, h)
    return 1 if rng.random() < float(pA) else 0


def conditional_verdict(t, prefix, N, R, M, rng, reps):
    """RF4's conditional verdict for one scripted prefix (k = len(prefix)), simulated reps times:
    the path from k is classified cell by cell (R calls per draw, rule C0); where every cell
    'ignores' (the premise at the histories reached, for both draws), M fresh sequences are run
    with single calls, the later draws at random (the first two all a and all b); a sequence whose
    guesses differ from the path's has its first differing member re-asked R times at its prompt:
    unanimous for the differing act, and the same member re-asked R times at the premise check's own
    context unanimous for the path's act -> a breach of the representation, reproduced (a channel
    beyond the member's own draw and the earlier acts); otherwise unresolved (nondeterminism). With
    logged inputs a channel through the prompt is caught at once by diffing inputs. The leaky member
    here reads the next draw by a channel no request can carry; in TR3's frozen run the two contexts
    are one request, so a breach outside its leak control is read as a fault of the harness or chance,
    and the leak control, a channel the prompt carries, is this rule's positive control (FREEZE-3.md,
    section 5)."""
    k = len(prefix)
    tally = {"no verdict: premise not met": 0, "no verdict: flagged cell": 0,
             "passed": 0, "breach reproduced": 0, "unresolved: unreproduced difference": 0}
    for _ in range(reps):
        h = prefix
        status = "met"
        for n in range(k, N):
            ga = [call(t, n, 1, h, rng, nxt=1) for _ in range(R)]
            gb = [call(t, n, 0, h, rng, nxt=1) for _ in range(R)]
            allg = ga + gb
            if len(set(allg)) == 1:
                h = h + (allg[0],)
                continue
            if len(set(ga)) == 1 and len(set(gb)) == 1:
                status = "no verdict: premise not met"
            else:
                status = "no verdict: flagged cell"
            break
        if status != "met":
            tally[status] += 1
            continue
        path = h
        outcome = "passed"
        for m in range(M):
            if m == 0:
                draws = [1] * (N - k)
            elif m == 1:
                draws = [0] * (N - k)
            else:
                draws = [rng.randrange(2) for _ in range(N - k)]
            g = prefix
            diff = None
            for i, n in enumerate(range(k, N)):
                nxt = draws[i + 1] if i + 1 < len(draws) else None
                a = call(t, n, draws[i], g, rng, nxt=nxt)
                if a != path[n] and diff is None:
                    diff = (n, draws[i], g, nxt, a)
                g = g + (a,)
            if diff is not None:
                n, s, g0, nxt, a = diff
                again = [call(t, n, s, g0, rng, nxt=nxt) for _ in range(R)]
                back = [call(t, n, s, g0, rng, nxt=1) for _ in range(R)]
                if all(x == a for x in again) and all(x == path[n] for x in back):
                    outcome = "breach reproduced"
                    break
                outcome = "unresolved: unreproduced difference"
        tally[outcome] += 1
    return {k2: round(v / reps, 4) for k2, v in tally.items()}


def part_e(p=Fr(3, 5), R=5, M=8, N=8):
    out = {"R_calls_per_draw_per_cell": R, "M_fresh_sequences_per_prefix": M, "members": N,
           "precision": fr(p)}
    # E1. the classification of one cell, exactly, for deterministic classes under flips eta,
    # and for hybrids at a cascade cell
    e1 = {}
    for r in (1, 2, 3, 5):
        row = {}
        for eta in (Fr(0), Fr(1, 1000), Fr(2, 1000), Fr(5, 1000), Fr(1, 100), Fr(2, 100), Fr(5, 100)):
            ign = classes(1 - eta, 1 - eta, r)  # a cell where the member ignores, act A
            rd = classes(1 - eta, eta, r)       # a cell where it follows its draw
            row[str(eta)] = {
                "ignoring cell: P(ignores A)": round(float(ign["ignores A"]), 4),
                "ignoring cell: P(read as reads)": round(float(ign["reads (follows)"] + ign["reads (inverted)"]), 8),
                "ignoring cell: P(flagged)": round(float(flagged(ign)), 4),
                "reading cell: P(reads, follows)": round(float(rd["reads (follows)"]), 4),
                "reading cell: P(read as ignores)": round(float(rd["ignores A"] + rd["ignores B"]), 8),
                "reading cell: P(flagged)": round(float(flagged(rd)), 4)}
        e1[f"R={r}"] = row
    hyb = {}
    for q in (Fr(1, 20), Fr(1, 10), Fr(1, 4), Fr(1, 2)):
        c = classes(Fr(1), 1 - q, R)
        hyb[str(q)] = {k: round(float(v), 4) for k, v in c.items()} | {"flagged": round(float(flagged(c)), 4)}
    out["E1_cell_classification"] = e1
    out["E1_hybrid_at_a_cascade_cell_R"] = hyb
    # E2. BHW's rule, exactly, for every type, plain and through flips
    e2 = {}
    for units in (0, 1):
        prior = Fr(1, 2) if units == 0 else p
        urn = Urn(p, prior)
        types = make_types(urn)
        bhw = types[0]
        rows = {}
        for t in types:
            for eta in (Fr(0), Fr(1, 1000), Fr(1, 100)):
                tt = t if eta == 0 else Noisy(t, eta)
                o = bhw_rule_outcome(tt, bhw, units, R)
                if o is None:
                    rows[tt.name] = "undefined at a planned cell"
                    continue
                rows[tt.name] = {k: round(float(v), 4) for k, v in o.items()}
        e2["1:1" if units == 0 else "one draw for A"] = rows
    # both priors together: placed only where placed at both; contradicted where at either
    both = {}
    for name in e2["1:1"]:
        a, b = e2["1:1"][name], e2["one draw for A"].get(name)
        if isinstance(a, dict) and isinstance(b, dict):
            pl = a["placed"] * b["placed"]
            co = 1 - (1 - a["contradicted"]) * (1 - b["contradicted"])
            both[name] = {"placed": round(pl, 4), "contradicted": round(co, 4), "unresolved": round(1 - pl - co, 4)}
    out["E2_bhw_rule_by_prior"] = e2
    out["E2_bhw_rule_both_priors"] = both
    # E3. RF4's conditional verdict, simulated
    rng = random.Random(SEED + 3)
    urn = Urn(p, Fr(1, 2))
    naive = Naive(urn)
    bhw = FilterType("BHW, ties to the own draw", urn, decide_own)
    agents = [("BHW, ties to the own draw", bhw)]
    for eta in (Fr(1, 1000), Fr(1, 200), Fr(1, 100), Fr(1, 20)):
        agents.append((f"BHW, flips {eta}", Noisy(bhw, eta)))
    for q in (Fr(1, 20), Fr(1, 10), Fr(1, 4)):
        agents.append((f"hybrid: own draw w.p. {q}", Mix("h", naive, q=q)))
    agents.append(("majority copier", Rule("m", lambda n, s, h: majority(h, s))))
    agents.append(("constant A", Rule("c", lambda n, s, h: 1)))
    agents.append(("leaky 1 (guesses the next member's draw)", Leaky(Rule("f", lambda n, s, h: 1), Fr(1), 2)))
    agents.append(("leaky 1/2", Leaky(Rule("f", lambda n, s, h: 1), Fr(1, 2), 2)))
    agents.append(("own draw always", Rule("o", lambda n, s, h: s)))
    e3 = {}
    reps = 4000
    for name, t in agents:
        e3[name] = conditional_verdict(t, (1, 1), N, R, M, rng, reps)
    out["E3_conditional_verdict_prefix_(A,A)"] = {"replications_per_agent": reps, "rows": e3}
    # E7. the choice of the cell rule: C0 (R = 3, unanimous) against C1 (R = 5, at most one call of
    # each draw's five off its class), for BHW's timing rule under flips, and for the rivals it must
    # still tell apart. C1 trades robustness to residual nondeterminism for weaker resolution of
    # hybrids (a member reading its draw with chance 1/5 or less is classed as ignoring more often).
    def classes_tol(x, y, r, tol):
        def atleast(pr, k):
            return sum(math.comb(r, j) * pr ** j * (1 - pr) ** (r - j) for j in range(k, r + 1))
        need = r - tol
        return {"ignores A": atleast(x, need) * atleast(y, need),
                "ignores B": atleast(1 - x, need) * atleast(1 - y, need),
                "reads (follows)": atleast(x, need) * atleast(1 - y, need),
                "reads (inverted)": atleast(1 - x, need) * atleast(y, need)}
    e7 = {}
    for rule, (r, tol) in (("C0: R 3, unanimous", (3, 0)), ("C1: R 5, one off allowed", (5, 1))):
        cls = (lambda x, y, RR, r=r, tol=tol: classes_tol(x, y, r, tol))
        rows = {}
        for units in (0, 1):
            prior = Fr(1, 2) if units == 0 else p
            urn = Urn(p, prior)
            bhw = FilterType("BHW, ties to the own draw", urn, decide_own)
            ts = [bhw, FilterType("overweighting 2:1", urn, decide_overweight(Fr(2))),
                  Mix("hybrid 1/5", Naive(urn), q=Fr(1, 5)), Mix("hybrid 1/10", Naive(urn), q=Fr(1, 10))]
            for t in ts:
                for eta in (Fr(0), Fr(1, 1000), Fr(3, 1000), Fr(1, 100), Fr(3, 100)):
                    tt = t if eta == 0 else Noisy(t, eta)
                    o = bhw_rule_outcome(tt, bhw, units, r, cls)
                    rows.setdefault(tt.name, {})["1:1" if units == 0 else "one draw for A"] = \
                        {k: round(float(v), 4) for k, v in o.items()}
        both = {}
        for name, v in rows.items():
            a, b = v["1:1"], v["one draw for A"]
            pl = a["placed"] * b["placed"]
            co = 1 - (1 - a["contradicted"]) * (1 - b["contradicted"])
            both[name] = {"placed": round(pl, 4), "contradicted": round(co, 4)}
        e7[rule] = both
    out["E7_cell_rule_choice_both_priors"] = e7
    # E4. the sampled arm (reported only): the 95% half-width of D at r calls per draw, and the
    # normal-approximation sizes the reader gave, recomputed
    z = {"0.95_two_sided": 1.959964, "0.95_one_sided": 1.644854, "0.80_power": 0.841621, "0.90_power": 1.281552}
    hw = {}
    for r in (20, 50, 100, 200):
        hw[str(r)] = {f"base {b}": round(1.959964 * math.sqrt(2 * b * (1 - b) / r), 3) for b in (0.5, 0.8, 0.9)}
    sizes = {
        "detect D = 0.1 between 0.9 and 0.8 (two-sided 0.05, power 0.8)":
            math.ceil((z["0.95_two_sided"] + z["0.80_power"]) ** 2 * (0.9 * 0.1 + 0.8 * 0.2) / 0.01),
        "equivalence |D| < 0.1, base 0.9, true D = 0 (TOST 0.05, power 0.8)":
            math.ceil((z["0.95_one_sided"] + z["0.90_power"]) ** 2 * 2 * 0.09 / 0.01),
        "equivalence |D| < 0.1, base 0.5": math.ceil((z["0.95_one_sided"] + z["0.90_power"]) ** 2 * 2 * 0.25 / 0.01),
        "equivalence |D| < 0.05, base 0.9": math.ceil((z["0.95_one_sided"] + z["0.90_power"]) ** 2 * 2 * 0.09 / 0.0025),
        "equivalence |D| < 0.05, base 0.5": math.ceil((z["0.95_one_sided"] + z["0.90_power"]) ** 2 * 2 * 0.25 / 0.0025),
    }
    # check the equivalence size by simulation at base 0.9, margin 0.1 (Wald interval, 90%)
    rng2 = random.Random(SEED + 4)
    n_eq = sizes["equivalence |D| < 0.1, base 0.9, true D = 0 (TOST 0.05, power 0.8)"]
    passes = 0
    reps2 = 4000
    for _ in range(reps2):
        xa = sum(rng2.random() < 0.9 for _ in range(n_eq))
        xb = sum(rng2.random() < 0.9 for _ in range(n_eq))
        pa, pb = xa / n_eq, xb / n_eq
        se = math.sqrt(pa * (1 - pa) / n_eq + pb * (1 - pb) / n_eq)
        d = pa - pb
        passes += (d - 1.644854 * se > -0.1) and (d + 1.644854 * se < 0.1)
    out["E4_sampled_arm"] = {"half_width_95_of_D": hw, "normal_sizes_per_draw": sizes,
                             "simulated_tost_power_at_that_size": round(passes / reps2, 3),
                             "note": "the sampled arm is reported only: RF4 gives no verdict on sampled members"}
    # E5. the determinism pilot: the one-sided 95% upper bound on the flip rate after zero flips
    out["E5_pilot_upper_bound_on_eta_after_no_flip"] = {str(n): round(1 - 0.05 ** (1 / n), 5) for n in (100, 200, 300, 400, 1000, 3000)}
    # E6. the premise along a planned path at R, for a member that ignores at every cell, by eta
    e6 = {}
    for eta in (0.0, 0.001, 0.002, 0.005, 0.01, 0.02):
        cell = (1 - eta) ** (2 * R) + eta ** (2 * R)
        e6[str(eta)] = {"one cell": round(cell, 4), "path of 6": round(cell ** 6, 4), "path of 5": round(cell ** 5, 4)}
    out["E6_premise_met_on_a_path"] = e6
    return out


# ---------------------------------------------------------------------------------------------
# F. The planned protocol and its usage
# ---------------------------------------------------------------------------------------------

def part_f(R=5, M=8, N=8):
    cells = 0
    path_members = 0
    prefixes = {"1:1": [(1, 1), (0, 0), (1, 1, 1), (0, 0, 0)], "one draw for A": [(1,), (0, 0, 0)]}
    seen = set()
    for units, key in ((0, "1:1"), (1, "one draw for A")):
        static, paths, _ = cell_list(units)
        for h in static:
            seen.add((key, h))
        for pref in prefixes[key]:
            for j in range(len(pref), N):
                seen.add((key, pref[:1] * j if len(set(pref)) == 1 else pref))
            path_members += N - len(pref)
    cells = len(seen)
    premise_calls = cells * 2 * R
    fresh_calls = path_members * M
    leak_calls = 6 * 2 * R + M * 6
    probes = cells * 2
    no_draw = cells * R
    sampled = 6 * 2 * 50
    pilot = 300  # a screen: with no flip it excludes eta above about 1/100 (E5), not the 1/1000 regime
    total = premise_calls + fresh_calls + leak_calls + probes + no_draw + sampled + pilot
    tokens_in = 320  # instructions and cover story ~250, history and draw ~70, stated assumption
    tokens_out = 8   # one structured field
    per_model = total * (tokens_in + tokens_out)
    return {"cells": cells, "prefixes": {k: [hname(p) for p in v] for k, v in prefixes.items()},
            "calls_per_model": {"premise cells (2 draws x R)": premise_calls,
                                "fresh sequences (M per prefix, single calls)": fresh_calls,
                                "leak control (one prefix)": leak_calls,
                                "comprehension probes (one per cell and draw)": probes,
                                "no-draw control (history only, R)": no_draw,
                                "sampled arm (6 cells x 2 draws x 50), reported only": sampled,
                                "determinism pilot (outside the cells)": pilot,
                                "total, before re-asks": total},
            "re_asks": "R per difference found in a fresh sequence, and one per invalid answer",
            "tokens_per_model_estimate": per_model,
            "assumptions": ("about 320 input and 8 output tokens a call, no reasoning tokens; a reasoning "
                            "model adds its reasoning, to be measured at the smoke run"),
            "three_families": {"calls": 3 * total, "tokens": 3 * per_model},
            "six_families": {"calls": 6 * total, "tokens": 6 * per_model}}


def main():
    import time
    out = {"test": "TR3 (RF4, readers reading readers)", "stage": "0: design, no model called",
           "seed": SEED, "python": "3.11, standard library"}
    t0 = time.time()
    for key, f in (("A_mirror", part_a), ("B_cells", part_b), ("C_bhw", part_c),
                   ("D_stochastic_bound", part_d), ("E_power", part_e), ("F_usage", part_f)):
        out[key] = f()
        print(f"{key}: {time.time() - t0:.1f} s", flush=True)
    OUT.write_text(json.dumps(out, indent=1, ensure_ascii=False) + "\n")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
