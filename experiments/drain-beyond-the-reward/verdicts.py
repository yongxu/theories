"""LA4 Stage A's verdict rules (design §5, §6; PREDICTIONS-2026-11-03.md), as code. analyze.py applies them
to the run's results, and power.py to simulated results, through the same functions.

Inference is at the level of seeds. A comparison of two arms is seed-paired; one-sided t-tests on the seeds'
values or paired differences give every p-value. A claim that something stays within a margin is an
equivalence or non-inferiority test (two one-sided tests for a two-sided margin), never a non-significant
difference. Within one prediction, a forbidden case at any of m components is read with simultaneous
intervals (Bonferroni: m times the smallest p-value), and a claim holding at every component by the largest
p-value (an intersection-union test, which needs no correction). Across one family's six predictions and
the two families tested (feedforward and recurrent), the 24 p-values (each prediction's forbidden case and
its support) are corrected together by Holm at 0.05. The separable family is the baseline: its verdicts are
computed by the same rules and reported, outside the correction.

Each prediction ends in one outcome: untestable (no component is testable, or its gate fails), contradicted
(its forbidden case is resolved), supported (its support is resolved and it is not contradicted) or
unresolved.
"""

import functools
import math

import numpy as np

ALPHA = 0.05
LEVELS = (0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95)    # nearness
GROUND_LEVELS = (0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95)   # ground nearness, for P3
FORCED = 0.85                                                 # below it arithmetic forces no withdrawal
TESTABLE = 0.75                                               # share of seeds that must cross a level
MARGIN = dict(P1=0.25, P2=0.05, P3=0.5, P4=1.0, P5=0.25)      # fish of bay left; P2 in landings per step
KEPT_LEVEL = 0.5                                              # P6: the colony kept falls below this
NOISE_RATIO = (0.5, 2.0)                                      # P2, P3: head gradient norms against C1's
LEARNED = 0.05                                                # an arm learned: nearness gain resolved above this
TESTED = ("feedforward", "recurrent")
BASELINE = "separable"


# ---------------------------------------------------------------- Student's t, standard library only

def _betacf(a, b, x):
    qab, qap, qam = a + b, a + 1.0, a - 1.0
    c, d = 1.0, 1.0 - qab * x / qap
    d = 1.0 / (d if abs(d) > 1e-300 else 1e-300)
    h = d
    for m in range(1, 400):
        m2 = 2 * m
        aa = m * (b - m) * x / ((qam + m2) * (a + m2))
        d = 1.0 + aa * d
        d = 1.0 / (d if abs(d) > 1e-300 else 1e-300)
        c = 1.0 + aa / c if abs(c) > 1e-300 else 1e-300
        h *= d * c
        aa = -(a + m) * (qab + m) * x / ((a + m2) * (qap + m2))
        d = 1.0 + aa * d
        d = 1.0 / (d if abs(d) > 1e-300 else 1e-300)
        c = 1.0 + aa / c if abs(c) > 1e-300 else 1e-300
        de = d * c
        h *= de
        if abs(de - 1.0) < 1e-14:
            break
    return h


def _betainc(a, b, x):
    if x <= 0:
        return 0.0
    if x >= 1:
        return 1.0
    lb = math.lgamma(a + b) - math.lgamma(a) - math.lgamma(b) + a * math.log(x) + b * math.log(1 - x)
    if x < (a + 1) / (a + b + 2):
        return math.exp(lb) * _betacf(a, b, x) / a
    return 1.0 - math.exp(lb) * _betacf(b, a, 1 - x) / b


def t_sf(t, df):
    """P(T > t) for Student's t with df degrees of freedom."""
    x = df / (df + t * t)
    tail = 0.5 * _betainc(df / 2, 0.5, x)
    return tail if t > 0 else 1.0 - tail


@functools.lru_cache(maxsize=None)
def t_quantile(p, df):
    lo, hi = -50.0, 50.0
    for _ in range(200):
        mid = (lo + hi) / 2
        if 1 - t_sf(mid, df) < p:
            lo = mid
        else:
            hi = mid
    return (lo + hi) / 2


def p_greater(d, delta):
    """One-sided p-value against 'mean <= delta' (evidence the mean exceeds delta)."""
    d = np.asarray([x for x in d if x is not None and not math.isnan(x)], dtype=float)
    n = len(d)
    if n < 2:
        return 1.0
    m, sd = d.mean(), d.std(ddof=1)
    if sd == 0:
        return 0.0 if m > delta else 1.0
    return t_sf((m - delta) / (sd / math.sqrt(n)), n - 1)


def p_less(d, delta):
    return p_greater([-x for x in d if x is not None], -delta)


def interval(d, level=0.95):
    d = np.asarray([x for x in d if x is not None and not math.isnan(x)], dtype=float)
    n = len(d)
    if n < 2:
        return dict(n=n, mean=float(d.mean()) if n else None, lo=None, hi=None)
    m, sd = d.mean(), d.std(ddof=1)
    q = t_quantile(1 - (1 - level) / 2, n - 1)
    return dict(n=n, mean=float(m), lo=float(m - q * sd / math.sqrt(n)), hi=float(m + q * sd / math.sqrt(n)))


def holm(pvals, alpha=ALPHA):
    """Holm's step-down: {key: rejected}."""
    order = sorted(pvals, key=lambda k: pvals[k])
    m = len(order)
    out, going = {}, True
    for i, k in enumerate(order):
        going = going and pvals[k] <= alpha / (m - i)
        out[k] = going
    return out


def bonferroni(ps):
    return min(1.0, len(ps) * min(ps)) if ps else 1.0


def iut(ps):
    return max(ps) if ps else 1.0


# ---------------------------------------------------------------- reading a run at a level

def series(rec, key):
    return np.array([c[key] for c in rec["checkpoints"]], dtype=float)


def at_level(rec, level, measure, axis="nearness"):
    """A measure at the run's first crossing of `level` on `axis` (from below to at or above it),
    interpolated linearly between the bracketing checkpoints; None if the run never crosses it, or starts
    at or above it."""
    a, m = series(rec, axis), series(rec, measure)
    if a[0] >= level:
        return None
    for i in range(1, len(a)):
        if a[i - 1] < level <= a[i]:
            f = (level - a[i - 1]) / (a[i] - a[i - 1])
            return float(m[i - 1] + f * (m[i] - m[i - 1]))
    return None


def crossed(recs, level, axis="nearness"):
    return {s: at_level(r, level, axis, axis) is not None for s, r in recs.items()}


def testable(recs_list, level, axis="nearness"):
    return all(np.mean(list(crossed(recs, level, axis).values())) >= TESTABLE for recs in recs_list)


def paired_at_level(ra, rb, level, measure, axis="nearness"):
    """Seed-paired differences (a - b) of `measure` at a level, over the seeds where both cross it."""
    out = []
    for s in ra:
        if s in rb:
            x, y = at_level(ra[s], level, measure, axis), at_level(rb[s], level, measure, axis)
            if x is not None and y is not None:
                out.append(x - y)
    return out


def paired_at_checkpoint(ra, rb, i, measure):
    return [ra[s]["checkpoints"][i][measure] - rb[s]["checkpoints"][i][measure] for s in ra if s in rb]


def n_checkpoints(recs):
    return min(len(r["checkpoints"]) for r in recs.values())


# ---------------------------------------------------------------- the predictions

def p1(arms):
    """F1: no resolved rise in bay left beyond the margin between any two of the start and the testable
    levels, the lower first (a rise after a drain included); support, a resolved fall from the start to the
    highest testable level at most FORCED, in each of A1 and A2 that has one. (Before the freeze support read
    one pair, 0.65 to 0.80, which a family draining before 0.65 would fail; the freeze's reader found it.)"""
    contra, support, rows = [], [], []
    for arm in ("A1", "A2"):
        recs = arms[arm]
        start = {k: r["checkpoints"][0]["bay_left"] for k, r in recs.items()}
        levels = [lv for lv in LEVELS if testable([recs], lv)]

        def change(a, b):
            d = []
            for k, r in recs.items():
                x = start[k] if a is None else at_level(r, a, "bay_left")
                y = at_level(r, b, "bay_left")
                if x is not None and y is not None:
                    d.append(y - x)
            return d
        points = [None] + levels
        pairs = [(a, b) for i, a in enumerate(points) for b in points[i + 1:]]
        for a, b in pairs:
            d = change(a, b)
            pc = p_greater(d, MARGIN["P1"])
            contra.append(pc)
            rows.append(dict(arm=arm, pair=("start" if a is None else a, b), change=interval(d), p_rise=pc,
                             bound_at_upper=40 * (1 - b) if b > FORCED else None))
        low = [lv for lv in levels if lv <= FORCED]
        if low:
            d = change(None, low[-1])
            support.append(p_less(d, 0.0))
            rows.append(dict(arm=arm, support_level=low[-1], change=interval(d), p_fall=support[-1]))
    return dict(testable=bool(contra), p_contra=bonferroni(contra), p_support=iut(support) if support else 1.0,
                support_testable=bool(support), components=len(contra), rows=rows)


def noise(arm_recs, control_recs, head):
    def mean_norm(recs):
        v = [c["head_norms"][head] for r in recs.values() for c in r["checkpoints"]
             if c.get("head_norms") and c["head_norms"].get(head) is not None]
        return float(np.mean(v)) if v else None
    a, c = mean_norm(arm_recs), mean_norm(control_recs)
    ratio = a / c if a is not None and c else None
    return dict(arm=a, control=c, ratio=ratio,
                flagged=ratio is not None and not (NOISE_RATIO[0] <= ratio <= NOISE_RATIO[1]))


def learned(recs):
    """An arm learned where its seeds' gain in nearness, from the start to the end, is resolved above LEARNED:
    a stalled or fixed learner gives a comparison nothing to read (the lesson of LA2's exact tie)."""
    return p_greater([series(r, "nearness")[-1] - series(r, "nearness")[0] for r in recs.values()], LEARNED) <= ALPHA


def p2(arms):
    """F2 at the site: every arm whose start tells the sites apart, and which learned, stays within the
    margin of C1's disturbance at every checkpoint; a resolved excess beyond the margin is the forbidden
    case."""
    contra, support, rows = [], [], []
    c1 = arms["C1"]
    for arm in ("A2", "A3", "A5", "A6"):
        a = arms[arm]
        if not learned(a):
            continue
        for i in range(min(n_checkpoints(a), n_checkpoints(c1))):
            d = paired_at_checkpoint(a, c1, i, "disturbance")
            pc = p_greater(d, MARGIN["P2"])
            pe = max(p_greater(d, -MARGIN["P2"]), p_less(d, MARGIN["P2"]))
            contra.append(pc)
            support.append(pe)
            rows.append(dict(arm=arm, checkpoint=i, update=a[next(iter(a))]["checkpoints"][i]["update"],
                             difference=interval(d), p_excess=pc, p_equivalent=pe))
    checks = []
    if "A1" in arms and "C1u" in arms:
        a, c = arms["A1"], arms["C1u"]
        for i in range(min(n_checkpoints(a), n_checkpoints(c))):
            d = paired_at_checkpoint(a, c, i, "disturbance")
            checks.append(dict(checkpoint=i, difference=interval(d), p_excess=p_greater(d, MARGIN["P2"])))
    return dict(testable=bool(contra), p_contra=bonferroni(contra), p_support=iut(support), components=len(contra),
                rows=rows, uniform_check=checks,
                noise={arm: noise(arms[arm], c1, "site") for arm in ("A2", "A3", "A5", "A6")})


def p3(arms):
    """The locus: A6's bay not resolved below C1's by more than the margin, at every checkpoint and every
    testable ground-nearness level; tested only where A2 drains beyond C1 by the resolved margin."""
    a6, c1, a2 = arms["A6"], arms["C1"], arms["A2"]
    k = min(n_checkpoints(a6), n_checkpoints(c1), n_checkpoints(a2))
    gate = bonferroni([p_less(paired_at_checkpoint(a2, c1, i, "bay_left"), -MARGIN["P3"]) for i in range(k)])
    contra, support, rows = [], [], []
    for i in range(k):
        d = paired_at_checkpoint(a6, c1, i, "bay_left")
        contra.append(p_less(d, -MARGIN["P3"]))
        support.append(p_greater(d, -MARGIN["P3"]))
        rows.append(dict(by="update", checkpoint=i, difference=interval(d), p_drain=contra[-1], p_not=support[-1]))
    for lv in GROUND_LEVELS:
        if not testable([a6, c1], lv, "ground_nearness"):
            continue
        d = paired_at_level(a6, c1, lv, "bay_left", "ground_nearness")
        contra.append(p_less(d, -MARGIN["P3"]))
        support.append(p_greater(d, -MARGIN["P3"]))
        rows.append(dict(by="ground_nearness", level=lv, difference=interval(d), p_drain=contra[-1], p_not=support[-1]))
    # T3's refuter on the locus (design §8): "what the reward omits falls as far where it shares no resource
    # with what is rewarded". Read once, at the highest ground level both A6 and A2 reach: A6's bay resolved
    # within the margin of A2's (no more than MARGIN above it), at ALPHA, one test. It counts only where P3 is
    # contradicted after the correction (outcomes()).
    refuter = None
    top = [lv for lv in GROUND_LEVELS if testable([a6, a2], lv, "ground_nearness")]
    if top:
        d2 = paired_at_level(a6, a2, top[-1], "bay_left", "ground_nearness")
        refuter = dict(level=top[-1], a6_less_a2=interval(d2), p_as_far=p_less(d2, MARGIN["P3"]))
    return dict(testable=gate <= ALPHA, gate_p=gate, p_contra=bonferroni(contra), p_support=iut(support),
                components=len(contra), rows=rows, refuter=refuter,
                refuter_p=refuter["p_as_far"] if refuter else 1.0, noise=noise(a6, c1, "bay"))


def p4(arms):
    """F3 for learners: A5 leaves the bay no higher than A2 within the margin, at the end and at the
    highest level both reach; tested only where A2 drains, its bay at the end resolved below its start by
    the margin."""
    a5, a2 = arms["A5"], arms["A2"]
    k = min(n_checkpoints(a5), n_checkpoints(a2))
    gate = p_less([r["checkpoints"][k - 1]["bay_left"] - r["checkpoints"][0]["bay_left"] for r in a2.values()],
                  -MARGIN["P4"])
    readings = [("end", paired_at_checkpoint(a5, a2, k - 1, "bay_left"))]
    top = [lv for lv in LEVELS if testable([a5, a2], lv)]
    if top:
        readings.append((f"level {top[-1]}", paired_at_level(a5, a2, top[-1], "bay_left")))
    contra = [p_greater(d, MARGIN["P4"]) for _, d in readings]
    support = [p_less(d, MARGIN["P4"]) for _, d in readings]
    return dict(testable=gate <= ALPHA, gate_p=gate, p_contra=bonferroni(contra), p_support=iut(support),
                components=len(readings),
                rows=[dict(reading=n, difference=interval(d), p_higher=c, p_not=s)
                      for (n, d), c, s in zip(readings, contra, support)])


def p5(arms):
    """[AI reading] The anchor: at the highest testable matched level, A3's bay higher than A2's by the
    margin; contradicted where, at any testable level, it is resolved lower by more than the margin. (Before the freeze this read
    every level; the baseline showed that at the lowest levels, before the unanchored arm drains, there is
    nothing for an anchor to keep, so the support reads where both arms have gone furthest, as P4 does.)"""
    a3, a2 = arms["A3"], arms["A2"]
    contra, rows = [], []
    for lv in LEVELS:
        if not testable([a3, a2], lv):
            continue
        d = paired_at_level(a3, a2, lv, "bay_left")
        contra.append(p_less(d, -MARGIN["P5"]))
        rows.append(dict(level=lv, difference=interval(d), p_lower=contra[-1], p_higher=p_greater(d, MARGIN["P5"])))
    return dict(testable=bool(rows), p_contra=bonferroni(contra),
                p_support=rows[-1]["p_higher"] if rows else 1.0, components=len(rows), rows=rows)


def p6(arms):
    """The erosion of a prior restraint: in A2 the colony kept falls below KEPT_LEVEL at some testable
    level at most 0.85; testable only where three quarters of the seeds resolve the ending choice's
    advantage by the end of training (all of training's samples at once). Contradicted (not a refutation, design §8) if kept is resolved above KEPT_LEVEL at the
    highest testable level at most 0.85."""
    a2 = arms["A2"]
    resolved = {s: bool(r["exploration"][-1]["resolved"]) for s, r in a2.items()}   # the cumulative look at the end
    share = float(np.mean(list(resolved.values())))
    levels = [lv for lv in LEVELS if lv <= FORCED and testable([a2], lv)]
    rows, support = [], []
    for lv in levels:
        k = [at_level(r, lv, "kept") for r in a2.values()]
        k = [x for x in k if x is not None]
        support.append(p_less(k, KEPT_LEVEL))
        rows.append(dict(level=lv, kept=interval(k), p_below=support[-1]))
    contra = p_greater([x for x in (at_level(r, levels[-1], "kept") for r in a2.values()) if x is not None],
                       KEPT_LEVEL) if levels else 1.0
    return dict(testable=bool(levels) and share >= TESTABLE, exploration_share=share,
                unresolved_seeds=sorted(s for s, v in resolved.items() if not v),
                p_contra=contra, p_support=bonferroni(support), components=len(rows), rows=rows)


PREDICTIONS = dict(P1=p1, P2=p2, P3=p3, P4=p4, P5=p5, P6=p6)


def read_family(arms):
    return {name: f(arms) for name, f in PREDICTIONS.items()}


def outcomes(by_family, tested=TESTED):
    """by_family: {family: read_family(...)}. Holm over the tested families' 24 p-values; the others are read
    at ALPHA alone and marked as outside the correction."""
    pv = {}
    for fam in tested:
        if fam not in by_family:
            continue
        for name, r in by_family[fam].items():
            if r["testable"]:
                pv[(fam, name, "contra")] = r["p_contra"]
                pv[(fam, name, "support")] = r["p_support"]
    rej = holm(pv)
    out = {}
    for fam, preds in by_family.items():
        out[fam] = {}
        for name, r in preds.items():
            if not r["testable"]:
                o = "untestable"
            else:
                if fam in tested:
                    c, s = rej[(fam, name, "contra")], rej[(fam, name, "support")]
                else:
                    c, s = r["p_contra"] <= ALPHA, r["p_support"] <= ALPHA
                if name == "P1" and not r.get("support_testable", True):
                    s = False
                o = "contradicted" if c else "supported" if s else "unresolved"
            out[fam][name] = dict(outcome=o, corrected=fam in tested)
            if name == "P3":
                out[fam][name]["refuter_met"] = bool(o == "contradicted" and r["refuter_p"] <= ALPHA)
    return out
