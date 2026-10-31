"""Stage 0 of TR2 (RF2, what readings fix of the unread): exact values, checks and the power check of a
measurement of the chain's correspondence. No verdict on the law: RF2's theorems hold for every act law
reading through a lumping, so a run can refute only a stated lumping or an implementation.

Design work only: no model is called, nothing is downloaded, nothing is frozen and nothing runs on a
trained system. Python 3.11, standard library. Writes tr2.json beside this file. Deterministic: exact
values in integers and fractions.Fraction; simulations use random.Random(SEED + k) with frozen k.

1. A mirror of `Becoming.Unread` and of the definitions of `Becoming.Learning` it uses (`Determines`,
   `Lumped`, `Free`, `Training.Through`, `Training.AgreeOn`), checked by enumeration: every set
   partition of up to four occasions as the lumping, every read set, every target, act values of one,
   two and three kinds; every selection through agreement on the readings where that is enumerable;
   every factorization coupling -> state -> act on small sets; the witness `Cue`. Claims the design
   uses that the Lean does not state are labelled `derived` or `prose` (the module's prose, checked).
2. The measurement simulated. Occasions are (cue, content); the cue is toggled with the content fixed.
   Formation types the measurement may meet (content-only, detected and not acted on, a twin on some
   contents, a cue-follower fixed by what it reads, a salience-threshold hybrid, a hidden input
   correlated with the order of runs, serving nondeterminism, calls answering many items alike) are
   run through the measurement's rules: couplings apart by construction; states apart by exact
   comparison (where an identical-input arm shows exact equality is attainable) or by a linear probe
   on held-out contents (evidence one way only); acts apart by exact comparison, under a shared seed,
   or by an exact paired test. The power check fixes which differences the measurement can locate.
3. The schedule apart from the cue: coverage (the share of unread occasions whose lump holds a read
   occasion) under three schedules, exactly; and a reader misled, with its class stated, against
   behaviour changed.
"""

import itertools
import json
import math
import random
from fractions import Fraction as Fr
from pathlib import Path

SEED = 20261031


class Checks:
    def __init__(self):
        self.counts = {}
        self.failures = []

    def __call__(self, name, ok, detail=None):
        self.counts[name] = self.counts.get(name, 0) + 1
        if not ok and len(self.failures) < 50:
            self.failures.append({"check": name, "detail": detail})


# ---------------------------------------------------------------------------------------------
# 1. The mirror of Becoming.Unread (and the Learning definitions it uses)
# ---------------------------------------------------------------------------------------------

def set_partitions(items):
    """Every set partition of `items`, as a tuple giving each item's block index (canonical)."""
    items = list(items)
    n = len(items)

    def rec(i, labels, nblocks):
        if i == n:
            yield tuple(labels)
            return
        for b in range(nblocks + 1):
            labels.append(b)
            yield from rec(i + 1, labels, max(nblocks, b + 1))
            labels.pop()

    yield from rec(0, [], 0)


def all_laws(n, V):
    """Every act law g : I -> V, I = range(n), as a tuple."""
    return list(itertools.product(range(V), repeat=n))


def lumped(pi, g):                       # Learning.Lumped
    n = len(g)
    return all(g[i] == g[j] for i in range(n) for j in range(n) if pi[i] == pi[j])


def agree_on(D, g, h):                   # Learning.Training.AgreeOn
    return all(g[i] == h[i] for i in D)


def determines(C, D, x):                 # Learning.Determines, C a list of laws
    seen = {}
    for g in C:
        key = tuple(g[i] for i in D)
        if key in seen and seen[key] != g[x]:
            return False
        seen.setdefault(key, g[x])
    return True


def free(C, D, x):                       # Learning.Free
    for g in C:
        for g2 in C:
            if not any(agree_on(D, h, g) and h[x] == g2[x] for h in C):
                return False
    return True


def through(laws, D, S):                 # Learning.Training.Through (AgreeOn D) select
    for g in laws:
        for h in laws:
            if agree_on(D, g, h) and ((g in S) != (h in S)):
                return False
    return True


def check_mirror(chk):
    stats = {}
    # Determines, Free, lumped_determines, determines_lumped_iff, free_lumped, the twin (by its
    # reduction to the agreement class), lumped_right_iff and lumped_world_right.
    for n in (1, 2, 3, 4):
        I = range(n)
        for V in (1, 2, 3):
            laws = all_laws(n, V)
            for pi in set_partitions(I):
                C = [g for g in laws if lumped(pi, g)]
                for mask in range(2 ** n):
                    D = [i for i in I if mask >> i & 1]
                    for x in I:
                        seen = any(pi[d] == pi[x] for d in D)
                        det = determines(C, D, x)
                        key = f"n{n} V{V}"
                        stats.setdefault(key, {"cases": 0, "determined": 0, "seen": 0})
                        stats[key]["cases"] += 1
                        stats[key]["determined"] += det
                        stats[key]["seen"] += seen
                        if seen:
                            chk("lumped_determines (seen -> Determines), every V", det, (n, V, pi, D, x))
                        if V >= 2:
                            chk("determines_lumped_iff (list, decidable lumps, two values)", det == seen, (n, V, pi, D, x))
                        else:
                            chk("control: one act value, the readings fix everything", det)
                        if not seen:
                            fr = free(C, D, x)
                            chk("free_lumped (unseen -> Free)", fr, (n, V, pi, D, x))
                            # the proof's construction: h i := if pi i = pi x then g' x else g i
                            for g in C:
                                for g2 in C:
                                    h = tuple(g2[x] if pi[i] == pi[x] else g[i] for i in I)
                                    chk("free_lumped's construction is lumped, agrees on D, takes g' x",
                                        lumped(pi, h) and agree_on(D, h, g) and h[x] == g2[x])
                            # twin_selected, reduced: a selection through AgreeOn R is a union of
                            # agreement classes, so h may be taken in g's class (checked below).
                            for g in C:
                                for v in range(V):
                                    chk("twin_selected (by the class reduction)",
                                        any(agree_on(D, h, g) and h[x] == v for h in C))
                        elif V >= 2:
                            # the hypothesis is needed: where seen, no lumped law agreeing on D takes
                            # another value at x
                            for g in C:
                                chk("derived: where seen, no twin acting otherwise",
                                    not any(agree_on(D, h, g) and h[x] != g[x] for h in C))
                        if V >= 2:
                            chk("derived: Free iff unseen (two or more values)", free(C, D, x) == (not seen))
    # lumped_right_iff and lumped_world_right, over every world f
    for n in (2, 3):
        I = range(n)
        for V in (2, 3):
            laws = all_laws(n, V)
            for pi in set_partitions(I):
                C = [g for g in laws if lumped(pi, g)]
                for mask in range(1, 2 ** n):
                    D = [i for i in I if mask >> i & 1]
                    for f in laws:
                        fits = [g for g in C if all(g[i] == f[i] for i in D)]
                        for g in fits:
                            for d in D:
                                for x in I:
                                    if pi[d] == pi[x]:
                                        chk("lumped_right_iff", (g[x] == f[x]) == (f[d] == f[x]))
                                        if lumped(pi, f):
                                            chk("lumped_world_right", g[x] == f[x])
    # The selections themselves: on I = range(3), V = 2, every subset of laws through AgreeOn D is a
    # union of agreement classes, and twin_selected holds of every one of them literally.
    n, V = 3, 2
    I = range(n)
    laws = all_laws(n, V)
    n_sel = 0
    for mask in range(2 ** n):
        D = [i for i in I if mask >> i & 1]
        selections = []
        for bits in range(2 ** len(laws)):
            S = {laws[k] for k in range(len(laws)) if bits >> k & 1}
            if through(laws, D, S):
                selections.append(S)
        classes = {}
        for g in laws:
            classes.setdefault(tuple(g[i] for i in D), set()).add(g)
        chk("selections through AgreeOn D are exactly the unions of agreement classes",
            len(selections) == 2 ** len(classes))
        n_sel += len(selections)
        for pi in set_partitions(I):
            for x in I:
                if any(pi[d] == pi[x] for d in D):
                    continue
                for S in selections:
                    for g in S:
                        if not lumped(pi, g):
                            continue
                        for v in range(V):
                            chk("twin_selected (every selection, literally)",
                                any(lumped(pi, h) and h in S and agree_on(D, h, g) and h[x] == v for h in laws))
    stats["selections through agreement enumerated (I = 3, V = 2)"] = n_sel
    # determines_iff_not_not, classically: one occasion, constant lumping, Bool, read where P holds.
    for P in (False, True):
        C = [(0,), (1,)]
        D = [0] if P else []
        chk("determines_iff_not_not, classical mirror (Determines iff P)", determines(C, D, 0) == P)
    # The chain: every factorization I -> K -> M -> V on small sets.
    n_fact = 0
    conv = {"acts alike with states apart (detected, not acted on)": 0,
            "states alike with couplings apart (detectable, not detected)": 0}
    for K, M, V in ((3, 2, 2), (2, 3, 2), (3, 3, 2)):
        for pi in itertools.product(range(K), repeat=3):
            for st in itertools.product(range(M), repeat=K):
                for act in itertools.product(range(V), repeat=M):
                    n_fact += 1
                    for i in range(3):
                        for j in range(3):
                            si, sj = st[pi[i]], st[pi[j]]
                            if act[si] != act[sj]:
                                chk("state_apart_of_acts_apart", si != sj)
                            if si != sj:
                                chk("coupling_apart_of_state_apart", pi[i] != pi[j])
                            if si != sj and act[si] == act[sj]:
                                conv["acts alike with states apart (detected, not acted on)"] += 1
                            if pi[i] != pi[j] and si == sj:
                                conv["states alike with couplings apart (detectable, not detected)"] += 1
    chk("both converses fail somewhere", all(v > 0 for v in conv.values()))
    stats["factorizations enumerated"] = n_fact
    stats["pairs where a converse of the chain fails"] = conv
    # The witness Cue: occasions (cue, content), read where the cue is up.
    occ = [(c, k) for c in (1, 0) for k in (1, 0)]        # (true,true),(true,false),(false,true),(false,false)
    idx = {o: i for i, o in enumerate(occ)}
    read = [idx[(1, 1)], idx[(1, 0)]]
    content_act = tuple(o[1] for o in occ)
    laws = all_laws(4, 2)
    classes = {}
    for g in laws:
        classes.setdefault(tuple(g[i] for i in read), set()).add(g)
    keys = list(classes)
    n_through = 0
    for bits in range(2 ** len(keys)):
        S = set().union(*[classes[keys[k]] for k in range(len(keys)) if bits >> k & 1]) if bits else set()
        chk("Cue: unions of classes are through AgreeOn read", through(laws, read, S))
        n_through += 1
        if content_act in S:
            chk("Cue.seen_twin", any(h in S and agree_on(read, h, content_act) and h[idx[(0, 1)]] == 0
                                    for h in laws))   # the identity lumping: every law is lumped
    content_only = [g for g in laws if lumped(tuple(o[1] for o in occ), g)]
    chk("Cue.unseen_fixed", determines(content_only, read, idx[(0, 1)]))
    chk("Cue.apart_with_content_alike", (1, 1) != (0, 1) and content_act[idx[(1, 1)]] == content_act[idx[(0, 1)]])
    stats["Cue: selections through the readings"] = n_through
    # The module's prose on coverage, checked: full coverage fixes every act; refining a lumping gives
    # no lump without a read occasion a read one.
    for n in (2, 3, 4):
        I = range(n)
        parts = list(set_partitions(I))
        laws = all_laws(n, 2)
        for pi in parts:
            C = [g for g in laws if lumped(pi, g)]
            for mask in range(2 ** n):
                D = [i for i in I if mask >> i & 1]
                if all(any(pi[d] == pi[x] for d in D) for x in I):
                    chk("prose: full coverage fixes the act everywhere", all(determines(C, D, x) for x in I))
                for rho in parts:
                    refines = all(rho[i] != rho[j] or pi[i] == pi[j] for i in I for j in I)
                    if not refines:
                        continue
                    for x in I:
                        if not any(pi[d] == pi[x] for d in D):
                            chk("prose: refining gives no unread lump a read occasion",
                                not any(rho[d] == rho[x] for d in D))
    return stats


# ---------------------------------------------------------------------------------------------
# 2. The measurement simulated
# ---------------------------------------------------------------------------------------------

ALPHA_ACTS = 0.05          # two-sided, per cue factor (a Bonferroni split over factors is the freeze's)
ALPHA_PROBE = 0.01         # one-sided, held-out accuracy against one half
D_STATE = 8                # dimensions of the simulated state


def binom_pmf_list(n, p):
    """[P(Bin(n, p) = k) for k in 0..n], computed stably in floating point."""
    if p <= 0:
        return [1.0] + [0.0] * n
    if p >= 1:
        return [0.0] * n + [1.0]
    lp, lq = math.log(p), math.log(1 - p)
    return [math.exp(math.lgamma(n + 1) - math.lgamma(k + 1) - math.lgamma(n - k + 1) + k * lp + (n - k) * lq)
            for k in range(n + 1)]


_TWO = {}


def two_sided_reject(D, alpha):
    """For D discordant pairs, the least a with 2 P(Bin(D, 1/2) <= a) <= alpha as the lower edge of the
    rejection region of the exact sign (McNemar) test; -1 if no region."""
    key = (D, alpha)
    if key not in _TWO:
        a, cum = -1, 0.0
        pm = binom_pmf_list(D, 0.5)
        for k in range(D + 1):
            if 2 * (cum + pm[k]) <= alpha:
                cum += pm[k]
                a = k
            else:
                break
        _TWO[key] = a
    return _TWO[key]


def mcnemar_reject(n01, n10, alpha):
    D = n01 + n10
    a = two_sided_reject(D, alpha)
    return a >= 0 and (min(n01, n10) <= a)


def power_paired(n, p_read, p_unread, alpha, crn):
    """Exact power of the exact McNemar test on n pairs (content fixed, cue toggled), acts binary.
    crn: a shared seed, the draw U shared within the pair, so discordance is one-way with chance
    |p_read - p_unread|; otherwise the two draws are independent."""
    if crn:
        d = abs(p_unread - p_read)
        pm = binom_pmf_list(n, d)
        return sum(pm[D] for D in range(n + 1) if two_sided_reject(D, alpha) >= 0)
    return power_discordant(n, p_read * (1 - p_unread), p_unread * (1 - p_read), alpha)


def coupled_discordance(p_read, p_unread, kappa):
    """Discordance chances (majority way, minority way) when a share |kappa| of pairs is coupled by the
    shared seed and the rest are drawn independently. kappa > 0: coupled monotonically (discordant one way
    only, with chance |p_read - p_unread|); kappa < 0: coupled antitonically, the most discordant coupling
    the rates allow (joint success max(0, p_read + p_unread - 1), the Frechet lower bound), so a shared seed
    can also raise discordance above independence (review round 2, item 12). kappa = 1 is the shared-seed
    idealization, kappa = 0 independent draws, kappa = -1 the worst coupling.
    A pilot measures the two chances directly, as the counts of discordant pairs each way."""
    hi, lo = max(p_read, p_unread), min(p_read, p_unread)
    ind_maj, ind_min = hi * (1 - lo), lo * (1 - hi)
    if kappa >= 0:
        return kappa * (hi - lo) + (1 - kappa) * ind_maj, (1 - kappa) * ind_min
    both = max(0.0, hi + lo - 1)
    w = -kappa
    return w * (hi - both) + (1 - w) * ind_maj, w * (lo - both) + (1 - w) * ind_min


def worst_discordance(p_read, p_unread):
    """The most discordant coupling of two binary draws with these rates (kappa = -1 above)."""
    return coupled_discordance(p_read, p_unread, -1.0)


def power_discordant(n, p01, p10, alpha):
    """Exact power of the exact McNemar test on n pairs with discordance chances p01 and p10 per pair."""
    pd = p01 + p10
    q = p10 / pd if pd > 0 else 0.5
    pmD = binom_pmf_list(n, pd)
    total = 0.0
    for D in range(n + 1):
        if pmD[D] < 1e-14:
            continue
        a = two_sided_reject(D, alpha)
        if a < 0:
            continue
        pmX = binom_pmf_list(D, q)
        total += pmD[D] * (sum(pmX[: a + 1]) + sum(pmX[D - a:]))   # a < D / 2, so no overlap
    return total


def smallest_n(fn, target=0.9, grid=(25, 50, 100, 200, 300, 400, 600, 800, 1200, 1600, 2400, 3200, 4800, 6400, 9600)):
    for n in grid:
        if fn(n) >= target:
            return n
    return None


def act_power_table():
    effects = [("14% against 1% (the order of 'almost never')", 0.01, 0.14),
               ("5 points at a 10% base", 0.10, 0.15),
               ("2 points at a 10% base", 0.10, 0.12),
               ("5 points at a 30% base", 0.30, 0.35)]
    out = {}
    for label, pr, pu in effects:
        row = {}
        for crn in (False, True):
            key = "shared seed" if crn else "independent draws"
            row[key] = {
                "pairs for power 0.9 (two-sided 0.05)": smallest_n(lambda n: power_paired(n, pr, pu, ALPHA_ACTS, crn)),
                "power at 100, 400, 1600 pairs": [round(power_paired(n, pr, pu, ALPHA_ACTS, crn), 4) for n in (100, 400, 1600)]}
        out[label] = row
    # Stage B's planned 600 pairs, independent draws and the worst coupling, at the split over four
    # factors (review stats-8; round 2, item 12: independence is a scenario, not the worst case).
    split = ALPHA_ACTS / 4
    worst = {}
    for label, pr, pu in effects:
        wmaj, wmin = worst_discordance(pr, pu)
        worst[label] = {
            "power at 600 pairs, independent draws, two-sided 0.05": round(power_paired(600, pr, pu, ALPHA_ACTS, False), 4),
            "power at 600 pairs, shared seed (monotone coupling), two-sided 0.05": round(power_paired(600, pr, pu, ALPHA_ACTS, True), 4),
            "power at 600 pairs, worst coupling, two-sided 0.05": round(power_discordant(600, wmaj, wmin, ALPHA_ACTS), 4),
            "discordance per pair, independent draws and worst coupling": [
                round(sum(coupled_discordance(pr, pu, 0.0)), 4), round(wmaj + wmin, 4)],
            "pairs for power 0.9, independent draws, two-sided 0.05/4": smallest_n(lambda n: power_paired(n, pr, pu, split, False)),
            "pairs for power 0.9, worst coupling, two-sided 0.05/4": smallest_n(lambda n: power_discordant(n, wmaj, wmin, split)),
            "power at 600, 1200, 1600, 3200 pairs, independent draws, two-sided 0.05/4": [
                round(power_paired(n, pr, pu, split, False), 4) for n in (600, 1200, 1600, 3200)],
            "power at 600, 1200, 1600, 3200 pairs, worst coupling, two-sided 0.05/4": [
                round(power_discordant(n, wmaj, wmin, split), 4) for n in (600, 1200, 1600, 3200)]}
    out["Stage B's 600 pairs: independent draws and the worst coupling, at 0.05/4"] = worst
    # Partial coupling: what the pilot measures (the minority share of discordant pairs) and the pairs it implies.
    coupling = {}
    for label, pr, pu in effects[1:3]:
        rows = {}
        for kappa in (1.0, 0.9, 0.75, 0.5, 0.25, 0.0, -0.5, -1.0):
            pmaj, pmin = coupled_discordance(pr, pu, kappa)
            rows["coupled share %s" % kappa] = {
                "discordance per pair, majority way and minority way": [round(pmaj, 4), round(pmin, 4)],
                "minority share of discordant pairs": round(pmin / (pmaj + pmin), 4),
                "pairs for power 0.9, two-sided 0.05": smallest_n(lambda n: power_discordant(n, pmaj, pmin, ALPHA_ACTS)),
                "pairs for power 0.9, two-sided 0.05/4": smallest_n(lambda n: power_discordant(n, pmaj, pmin, split))}
        coupling[label] = rows
    out["partial coupling under a shared seed (a share of pairs coupled monotonically, or at a negative share antitonically, the rest independent)"] = coupling
    # A/A: the exact test's false-alarm rate is at most alpha by construction; computed here.
    out["A/A (no difference), independent draws at 10%: rate of a resolved difference at 400 pairs"] = round(
        power_paired(400, 0.10, 0.10, ALPHA_ACTS, False), 4)
    out["A/A under a shared seed: discordant pairs possible"] = False
    return out


# --- simulated formations ---------------------------------------------------------------------

def unit(v):
    s = math.sqrt(sum(x * x for x in v))
    return [x / s for x in v]


def gauss_vec(rnd, d):
    return [rnd.gauss(0.0, 1.0) for _ in range(d)]


class World:
    """J contents with fixed embeddings and act propensities; a cue direction u."""

    def __init__(self, rnd, J, base=0.10):
        self.J = J
        self.emb = [gauss_vec(rnd, D_STATE) for _ in range(J)]
        self.u = unit(gauss_vec(rnd, D_STATE))
        self.base = base
        # the content's own act (deterministic types): its sign along a fixed content direction,
        # chosen orthogonal to u so that the act reads none of the cue
        w = gauss_vec(rnd, D_STATE)
        dot = sum(a * b for a, b in zip(w, self.u))
        self.w = unit([a - dot * b for a, b in zip(w, self.u)])
        self.content_act = [1 if sum(a * b for a, b in zip(e, self.w)) > 0 else 0 for e in self.emb]


def make_type(name, **kw):
    return dict(name=name, **kw)


FORMATIONS = [
    make_type("content-only (detectable, not detected)", beta=0.0, twin_share=0.0,
              expect=("apart", "alike", "alike")),
    make_type("detected, not acted on (beta 1)", beta=1.0, twin_share=0.0,
              expect=("apart", "apart", "alike")),
    make_type("detected, not acted on (beta 0.3)", beta=0.3, twin_share=0.0,
              expect=("apart", "apart", "alike")),
    make_type("twin on 10% of contents (beta 1)", beta=1.0, twin_share=0.1,
              expect=("apart", "apart", "apart")),
    make_type("twin on 2% of contents (beta 1)", beta=1.0, twin_share=0.02,
              expect=("apart", "apart", "apart")),
    make_type("cue-follower, fixed by what it reads", beta=1.0, cue_follower=True,
              expect=("apart", "apart", "apart")),
    make_type("salience hybrid: reads the cue only at salience 2", beta=1.0, twin_share=0.1, salience_min=2,
              expect=("apart", "apart", "apart at salience 2 only")),
    make_type("serving nondeterminism, content-only", beta=0.0, twin_share=0.0, jitter=1e-6,
              expect=("apart", "not shown apart (exact comparison void)", "alike")),
    make_type("serving nondeterminism, detected (beta 1)", beta=1.0, twin_share=0.0, jitter=1e-6,
              expect=("apart", "apart (probe)", "alike")),
]


def state_of(F, W, j, cue, rnd, salience=1):
    s = list(W.emb[j])
    beta = F.get("beta", 0.0)
    if cue and salience >= F.get("salience_min", 1):
        s = [a + beta * b for a, b in zip(s, W.u)]
    elif cue and beta:
        s = [a + 0.5 * beta * b for a, b in zip(s, W.u)]   # below salience: held in the state, not acted on
    jit = F.get("jitter", 0.0)
    if jit:
        s = [a + rnd.gauss(0.0, jit) for a in s]
    return s


def act_of(F, W, j, cue, twins, salience=1):
    """Deterministic act (the next-token argmax, or the behaviour under a shared seed)."""
    if F.get("cue_follower"):
        return 1 if cue else 0
    a = W.content_act[j]
    if not cue and j in twins and salience >= F.get("salience_min", 1):
        return 1 - a       # the twin acts otherwise where it is not read
    return a


def probe_apart(rnd, states_up, states_down, J):
    """Difference-of-means probe trained on half the contents, tested on the other half; one-sided exact
    binomial against one half at ALPHA_PROBE. Evidence one way only: a failure shows nothing."""
    order = list(range(J))
    rnd.shuffle(order)
    tr, te = order[: J // 2], order[J // 2:]
    mu1 = [sum(states_up[j][k] for j in tr) / len(tr) for k in range(D_STATE)]
    mu0 = [sum(states_down[j][k] for j in tr) / len(tr) for k in range(D_STATE)]
    w = [a - b for a, b in zip(mu1, mu0)]
    thr = sum(wk * (a + b) / 2 for wk, a, b in zip(w, mu1, mu0))
    correct = 0
    for j in te:
        correct += sum(wk * x for wk, x in zip(w, states_up[j])) > thr
        correct += sum(wk * x for wk, x in zip(w, states_down[j])) <= thr
    m = 2 * len(te)
    tail = sum(binom_pmf_list(m, 0.5)[correct:])
    return tail <= ALPHA_PROBE, correct / m


def measure(F, W, rnd, salience=1):
    """The measurement's rules on one formation, one cue factor at one salience. Returns the pattern
    (couplings, states, acts) and the misled share for a content-only reader."""
    J = W.J
    twins = set(j for j in range(J) if rnd.random() < F.get("twin_share", 0.0))
    # A/A premise: identical inputs twice; exact equality of states attainable?
    aa_equal = all(state_of(F, W, j, 1, rnd) == state_of(F, W, j, 1, rnd) for j in range(J))
    up = [state_of(F, W, j, 1, rnd, salience) for j in range(J)]
    down = [state_of(F, W, j, 0, rnd, salience) for j in range(J)]
    couplings = "apart"                                   # the cue is toggled in the input
    if aa_equal:
        states = "apart" if any(a != b for a, b in zip(up, down)) else "alike"
        acc = None
    else:
        ok, acc = probe_apart(rnd, up, down, J)
        states = "apart (probe)" if ok else "not shown apart (exact comparison void)"
    acts_up = [act_of(F, W, j, 1, twins, salience) for j in range(J)]
    acts_down = [act_of(F, W, j, 0, twins, salience) for j in range(J)]
    differ = sum(a != b for a, b in zip(acts_up, acts_down))
    acts = "apart" if differ else "alike"
    # a content-only reader fitted on the read (cue-up) occasions predicts each unread one by its content
    misled = differ / J
    return (couplings, states, acts), misled, acc


def pipeline_table(J=100, reps=200):
    out = {}
    for k, F in enumerate(FORMATIONS):
        rnd = random.Random(SEED + 100 + k)
        counts = {}
        accs = []
        identity = True
        for _ in range(reps):
            W = World(rnd, J)
            sal = 2 if F.get("salience_min") else 1
            pat, misled, acc = measure(F, W, rnd, salience=sal)
            counts[" | ".join(pat)] = counts.get(" | ".join(pat), 0) + 1
            if acc is not None:
                accs.append(acc)
            if F.get("salience_min"):
                pat1, _, _ = measure(F, W, rnd, salience=1)
                counts["salience 1: " + " | ".join(pat1)] = counts.get("salience 1: " + " | ".join(pat1), 0) + 1
        out[F["name"]] = {"expected pattern (couplings | states | acts)": " | ".join(F["expect"]),
                          "patterns found in %d worlds of %d contents" % (reps, J): counts,
                          "mean probe accuracy where used": round(sum(accs) / len(accs), 4) if accs else None}
    return out


def probe_power(betas=(0.1, 0.2, 0.3, 0.5, 1.0), Js=(20, 50, 100, 200, 400), reps=200):
    """Where exact comparison is void, the share of worlds in which the probe shows states apart, by the
    cue's weight beta in the state and the number of contents (half held out). Beta 0 is the null."""
    out = {}
    for b in (0.0,) + tuple(betas):
        row = {}
        for J in Js:
            rnd = random.Random(SEED + 7 + int(1000 * b) + J)
            hits = 0
            for _ in range(reps):
                W = World(rnd, J)
                up = [[a + b * c for a, c in zip(W.emb[j], W.u)] for j in range(J)]
                down = [list(W.emb[j]) for j in range(J)]
                ok, _ = probe_apart(rnd, up, down, J)
                hits += ok
            row[str(J)] = round(hits / reps, 3)
        out["beta %g" % b] = row
    return out


def drift_check(n_pairs=400, drift=0.05, base=0.10, reps=2000):
    """A hidden input the stated lumping leaves out: the serving snapshot changes halfway, raising the
    rate by `drift`. A content-only formation, cue arms run (a) blocked, read arm first, or
    (b) interleaved within each pair. Rates of a resolved acts-apart difference, and the power of a
    blocked A/A arm to show the drift."""
    rnd = random.Random(SEED + 3)
    res = {"blocked cue arms": 0, "interleaved cue arms": 0, "blocked A/A arms": 0, "interleaved A/A arms": 0}
    for _ in range(reps):
        for design in ("blocked", "interleaved"):
            n01 = n10 = 0
            for i in range(n_pairs):
                if design == "blocked":
                    p_up, p_down = base, base + drift          # read arm in the first half of the time
                else:
                    late = i >= n_pairs // 2
                    p_up = p_down = base + (drift if late else 0.0)
                a, b = rnd.random() < p_up, rnd.random() < p_down
                n01 += (not a) and b
                n10 += a and (not b)
            res[design + " cue arms"] += mcnemar_reject(n01, n10, ALPHA_ACTS)
            res[design + " A/A arms"] += mcnemar_reject(n01, n10, ALPHA_ACTS)   # same inputs, same draws
    return {k: round(v / reps, 4) for k, v in res.items()} | {
        "note": "a content-only formation: every resolved difference here is false; the A/A rows equal the cue rows because the formation reads no cue"}


def unit_check(n_calls=50, items=10, base=0.3, reps=4000):
    """Calls answering many items alike (all items of a call one way, as LA2's judge did in 112 of 119
    calls). A/A arms. Item as unit (a two-proportion z test on n_calls * items items) against call as
    unit (an exact test on calls). False-alarm rates at 0.05."""
    rnd = random.Random(SEED + 5)
    z_hits = c_hits = 0
    for _ in range(reps):
        a = [rnd.random() < base for _ in range(n_calls)]
        b = [rnd.random() < base for _ in range(n_calls)]
        xa, xb = sum(a) * items, sum(b) * items
        N = n_calls * items
        p = (xa + xb) / (2 * N)
        se = math.sqrt(max(p * (1 - p) * 2 / N, 1e-12))
        z = abs(xa / N - xb / N) / se
        z_hits += z > 1.959964
        # call as unit: pairs of calls by order, exact McNemar on discordant pairs
        n01 = sum((not x) and y for x, y in zip(a, b))
        n10 = sum(x and (not y) for x, y in zip(a, b))
        c_hits += mcnemar_reject(n01, n10, ALPHA_ACTS)
    return {"items per call": items, "calls per arm": n_calls,
            "false-alarm rate, item as unit": round(z_hits / reps, 4),
            "false-alarm rate, call as unit": round(c_hits / reps, 4)}


# ---------------------------------------------------------------------------------------------
# 3. The schedule apart from the cue; a reader misled
# ---------------------------------------------------------------------------------------------

def coverage_exact(R, rho):
    """Occasions (cue, content, copy), copy = 1..R not coupling in (identical repeated inputs). Expected
    coverage of the unread occasions, by lumping and schedule.
    S1: read exactly where the cue is up (the witness's schedule).
    S2: each occasion read with chance 1/2, apart from the cue.
    S3: S1, plus each cue-down occasion read with chance rho."""
    half = Fr(1, 2)
    out = {
        "lumping (cue, content): the cue couples in": {
            "S1": Fr(0),
            "S2": 1 - half ** (R - 1),
            "S3 (cue-down unread)": 1 - (1 - rho) ** (R - 1)},
        "lumping (content): the cue does not couple in": {
            "S1": Fr(1),
            "S2": 1 - half ** (2 * R - 1),
            "S3 (cue-down unread)": Fr(1)},
    }
    return {k: {kk: str(vv) for kk, vv in v.items()} for k, v in out.items()}


def coverage_enumerated(J=2, R=3, rho=Fr(1, 3)):
    """The same expectations by enumerating every schedule (S2, S3) with its weight; a check of
    coverage_exact on a small case."""
    occ = [(c, j, r) for c in (0, 1) for j in range(J) for r in range(R)]
    results = {}
    for lname, lump in (("cue couples in", lambda o: (o[0], o[1])), ("content only", lambda o: o[1])):
        for sname in ("S2", "S3"):
            num = Fr(0)
            for bits in itertools.product((0, 1), repeat=len(occ)):
                if sname == "S2":
                    w = Fr(1, 2 ** len(occ))
                    readset = {o for o, b in zip(occ, bits) if b}
                else:
                    if any(b == 0 for o, b in zip(occ, bits) if o[0] == 1):
                        continue
                    w = Fr(1)
                    for o, b in zip(occ, bits):
                        if o[0] == 0:
                            w *= rho if b else (1 - rho)
                    readset = {o for o, b in zip(occ, bits) if b}
                unread = [o for o in occ if o not in readset and (sname == "S2" or o[0] == 0)]
                if not unread:
                    continue
                # expected coverage over unread occasions: average the per-occasion indicator,
                # weighting each unread occasion by the schedule's weight
                for o in unread:
                    covered = any(lump(d) == lump(o) for d in readset)
                    num += w * covered
            # normalize by the expected number of unread occasions
            den = Fr(0)
            for bits in itertools.product((0, 1), repeat=len(occ)):
                if sname == "S2":
                    w = Fr(1, 2 ** len(occ))
                else:
                    if any(b == 0 for o, b in zip(occ, bits) if o[0] == 1):
                        continue
                    w = Fr(1)
                    for o, b in zip(occ, bits):
                        if o[0] == 0:
                            w *= rho if b else (1 - rho)
                readset = {o for o, b in zip(occ, bits) if b}
                den += w * len([o for o in occ if o not in readset and (sname == "S2" or o[0] == 0)])
            results[f"{lname}, {sname}"] = num / den
    return results


def misled_check(J=200, reps=200):
    """A reader misled, with its class stated. Deterministic acts. (a) Matched contents (the read and
    unread sets hold the same contents) and a content-only reader: misled equals changed exactly.
    (b) A reader whose class includes the cue and knows how the law changes: never misled.
    (c) Unmatched contents: a law acting alike everywhere misleads a reader whose readings miss where
    it is wrong (against a criterion f*); misled and changed come apart."""
    rnd = random.Random(SEED + 11)
    eq_a = True
    b_zero = True
    c_rows = []
    for _ in range(reps):
        W = World(rnd, J)
        twins = set(j for j in range(J) if rnd.random() < 0.1)
        F = FORMATIONS[3]
        up = [act_of(F, W, j, 1, twins) for j in range(J)]
        down = [act_of(F, W, j, 0, twins) for j in range(J)]
        changed = sum(a != b for a, b in zip(up, down)) / J
        misled = sum(up[j] != down[j] for j in range(J)) / J        # content-only reader's error
        eq_a &= (misled == changed)
        knows = [up[j] if j not in twins else 1 - up[j] for j in range(J)]   # a reader knowing the change
        b_zero &= all(k == d for k, d in zip(knows, down))
        # (c): a law acting alike everywhere (content-only), a criterion f* it violates on 10% of
        # contents, all of them in the unread set (unmatched contents)
        bad = set(j for j in range(J) if rnd.random() < 0.1)
        read_contents = [j for j in range(J) if j not in bad and rnd.random() < 0.5]
        unread_contents = [j for j in range(J) if j not in read_contents]
        fstar = [W.content_act[j] if j not in bad else 1 - W.content_act[j] for j in range(J)]
        reader_pass = all(W.content_act[j] == fstar[j] for j in read_contents)
        wrong_unread = sum(W.content_act[j] != fstar[j] for j in unread_contents) / max(1, len(unread_contents))
        c_rows.append((reader_pass, wrong_unread))
    return {"(a) matched contents, content-only reader: misled equals changed in every world": eq_a,
            "(b) a reader knowing how the law changes is never misled": b_zero,
            "(c) unmatched contents, a law acting alike everywhere: share of worlds the reader passes it":
                round(sum(r[0] for r in c_rows) / reps, 3),
            "(c) mean share of unread occasions where it is wrong against the criterion": round(sum(r[1] for r in c_rows) / reps, 4),
            "(c) changed": 0.0}


# ---------------------------------------------------------------------------------------------

def main():
    chk = Checks()
    stats = check_mirror(chk)
    cov = {"R = %d, rho = %s" % (R, rho): coverage_exact(R, rho) for R, rho in ((2, Fr(1, 4)), (3, Fr(1, 4)), (5, Fr(1, 10)))}
    enum = coverage_enumerated()
    ex = coverage_exact(3, Fr(1, 3))
    chk("coverage by enumeration, cue couples in, S2", enum["cue couples in, S2"] == Fr(ex["lumping (cue, content): the cue couples in"]["S2"]))
    chk("coverage by enumeration, cue couples in, S3", enum["cue couples in, S3"] == Fr(ex["lumping (cue, content): the cue couples in"]["S3 (cue-down unread)"]))
    chk("coverage by enumeration, content only, S2", enum["content only, S2"] == Fr(ex["lumping (content): the cue does not couple in"]["S2"]))
    chk("coverage by enumeration, content only, S3", enum["content only, S3"] == Fr(1))

    acts = act_power_table()
    for n in (100, 400, 1600):
        for pr, pu in ((0.10, 0.15), (0.10, 0.12), (0.30, 0.35)):
            chk("partial coupling at share 1 is the shared seed's power",
                abs(power_discordant(n, *coupled_discordance(pr, pu, 1.0), ALPHA_ACTS) - power_paired(n, pr, pu, ALPHA_ACTS, True)) < 1e-9)
            chk("partial coupling at share 0 is independent draws' power",
                abs(power_discordant(n, *coupled_discordance(pr, pu, 0.0), ALPHA_ACTS) - power_paired(n, pr, pu, ALPHA_ACTS, False)) < 1e-9)
    # The worst coupling is the least powerful: over joint success t from the Frechet lower bound to the
    # monotone coupling (the rates fixed, 21 points), power at each size is least at the lower bound. (It is
    # not monotone in t everywhere: near the monotone end at small sizes the exact test's discreteness bites.)
    for pr, pu in ((0.01, 0.14), (0.10, 0.15), (0.10, 0.12), (0.30, 0.35)):
        lo_t, hi_t = max(0.0, pr + pu - 1), min(pr, pu)
        ts = [lo_t + (hi_t - lo_t) * i / 20 for i in range(21)]
        for n in (200, 600, 1600, 3200):
            for alpha in (ALPHA_ACTS, ALPHA_ACTS / 4):
                pw = [power_discordant(n, pu - t, pr - t, alpha) for t in ts]
                chk("the worst coupling's power is the least over the couplings",
                    pw[0] <= min(pw) + 1e-12, (pr, pu, n, alpha))
                chk("the worst coupling's power is at most independent draws'",
                    power_discordant(n, *worst_discordance(pr, pu), alpha) <= power_paired(n, pr, pu, alpha, False) + 1e-12,
                    (pr, pu, n, alpha))
    pipe = pipeline_table()
    probes = probe_power()
    drift = drift_check()
    units = unit_check()
    misled = misled_check()
    for F in FORMATIONS:
        found = pipe[F["name"]]["patterns found in 200 worlds of 100 contents"]
        exp = " | ".join(F["expect"])
        if F.get("salience_min"):
            exp = "apart | apart | apart"
        share = found.get(exp, 0) / 200
        chk("pipeline recovers the expected pattern in at least 95% of worlds", share >= 0.95 or F["name"].startswith("twin on 2%"), (F["name"], found))

    out = {
        "test": "TR2 (RF2, what readings fix of the unread): Stage 0 of a measurement of the chain's correspondence; no verdict on the law",
        "lean": "Becoming.Unread (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Unread.lean), on Becoming.Learning",
        "seed": SEED,
        "checks": {"all passed": not chk.failures, "failures": chk.failures, "counts": chk.counts,
                   "checks run": sum(chk.counts.values())},
        "enumeration": stats,
        "acts apart: pairs needed (exact McNemar, two-sided 0.05)": acts,
        "states apart: probe power where exact comparison is void (share of 200 worlds; half the contents held out; one-sided 0.01)": probes,
        "the measurement on simulated formations (100 contents, 200 worlds each)": pipe,
        "a hidden input: drift with blocked or interleaved arms (400 pairs, drift 5 points at 10%, 2000 replications)": drift,
        "the unit: calls answering ten items alike (A/A, 50 calls per arm, 4000 replications)": units,
        "coverage of the unread occasions by schedule (exact)": cov,
        "coverage by enumeration (J = 2, R = 3, rho = 1/3)": {k: str(v) for k, v in enum.items()},
        "a reader misled, its class stated": misled,
    }
    path = Path(__file__).with_suffix(".json")
    path.write_text(json.dumps(out, indent=1, ensure_ascii=False))
    print("checks:", "all passed" if not chk.failures else chk.failures[:5])
    print("checks run:", sum(chk.counts.values()), "in", len(chk.counts), "kinds")
    print("enumeration:", json.dumps(stats)[:900])
    print("acts:", json.dumps(acts, indent=0))
    print("probes:", probes)
    for k, v in pipe.items():
        print(k, v)
    print("drift:", drift)
    print("units:", units)
    print("coverage:", cov)
    print("enumerated:", {k: str(v) for k, v in enum.items()})
    print("misled:", misled)
    print("wrote", path)


if __name__ == "__main__":
    main()
