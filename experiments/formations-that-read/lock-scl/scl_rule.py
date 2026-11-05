"""SCL's rule (FREEZE-12.md, section 4): the premise, the four verdicts and the descriptive reading, from the courses
a pin's records give, and the readability rule.

What a course is in the lock means here: a course is *in the lock at round k* where every round before k was the
known option, taken by the player or chosen for it, so that its words at k are the lock's words (the same in both
worlds, asserted by the dry run). Every course in the lock at k in one name order shows one text, so their calls
at k are draws from one prompt: the rule reads shares of draws, never one course's single draw as its state.

  the premise (P): the start lists both. Of the start probes (before round 2, every course of every arm but N3,
     whose words differ), at least N_MIN are read and at least START_MIN of those read name "either". Otherwise
     the pin is not testable, for one of two reasons kept apart: too few start probes read (a pin that declines
     or cannot be read), or a start that does not list both (a pin that begins from a prior).
  K, the kept listing (bridge (i), `Loop.kept_iff`, `Untested.rests`): with no untried act and no world-dependent
     reading, the share naming "either" does not fall. Eleven comparisons (KTESTS): each later probe of B, N2a, N2b
     among courses in the lock at its round against the start probes, N3's against N3's start, and N3's start
     against the start probes. A comparison contradicts where the share falls by at least DELTA_K and Fisher's
     exact one-sided test gives p <= ALPHA / 11; it is read only with N_MIN read probes on each side.
  S, staying (bridge (ii), the act chosen from the candidates kept and the value sensed; for a fixed loop more
     steps change nothing): no control raises the chance of first trying the other option. Eight comparisons
     (STESTS) of the hazard, tries over course-rounds at risk (in the lock, the act read): N1 three times, B's
     rounds 9 to 21 against its rounds 2 to 8, B's rounds 4 to 8 against its rounds 2 and 3 (R2-1: a rise that
     empties the lock before round 9 leaves the first unread), and B's round 3 against its round 2 (R3-1: a step
     at round 3 that persists sits in the middle comparison's base); N2, N2a's rounds 4 to 6 against B's, and
     N2b's against N2a's; N3, N3's free rounds against N2a's; N4, either name order against the other. A
     comparison contradicts where the hazard rises by at least DELTA_S and Fisher's one-sided p <= ALPHA / 8; it
     is read only with N_MIN_RISK course-rounds at risk on each side. A control that lowers the hazard is
     reported, never a contradiction. Beside each comparison, the stated listing on its two sides (the three probe answers' counts at
     the matching probes) and the K comparisons that match either side (SK). A contradiction is laid on "bridge
     (ii), no shift of the listing seen" only where every matching K comparison, of both sides, is read and none
     contradicts, each side has at least N_MIN read probes, and the exact two-sided Fisher-Freeman-Halton test of
     the three answers' counts, test side against base side, gives p > SHIFT_ALPHA (R2-2); otherwise on bridge
     (i) or (ii). The attribution is a non-rejection, not a test that the listing is unchanged, and it never
     changes the verdict. N4 has no matching K comparison, so its contradiction is always laid on (i) or (ii).
  E1 and E2, the exits in belief (bridge (iii), `explorer_up`, `explorer_down`; `informed_turns`'s start): of the
     exit arm's courses in the lock at round 3, in each world, the share whose probe before round 4 names the true
     amount alone, among those whose probe is read (an unread probe answer counts in no share, here as in K). A
     world contradicts where that share's one-sided upper bound at 1 - ALPHA / 2 (Clopper and Pearson; ALPHA over
     the two worlds) is below SHARE; it supports where its one-sided 95% lower bound is at least SHARE and the share
     exceeds the twin's naming that amount (N2a for E1, N2b for E2, read probes only) at Fisher's one-sided
     p <= ALPHA / 2. Contradicted where a world is; supported where both are; not testable where a world has fewer
     than N_MIN; unresolved otherwise.
  T, the act turn in up (`explorer_up`, `informed_turns`; `order_rests` where the middle ranks above the high):
     read for an exit only where its belief verdict is supported and C is strict at 8 in both name orders. Of the
     exit arm's courses in up in the lock at round 3, the share taking the other option at round 4: supported at
     a 95% lower bound of at least SHARE where that share also exceeds the twin's (its courses in up in the lock
     at round 4 taking the other option at round 4) at Fisher's one-sided p <= ALPHA / 2, so that a pin trying
     more at round 4 whatever it is shown is not read as turning; contradicted at an upper bound at 1 - ALPHA below
     SHARE. Where C is strict at 5 in both orders no turn is predicted and the share is reported; in down no turn
     is predicted (`downRest`).

Every threshold is compared exactly: a fall or a rise as a fraction of counts against DELTA_K or DELTA_S, Fisher's p
as a fraction against its ALPHA share, and a Clopper-Pearson bound against SHARE by the binomial tail at SHARE
(the lower bound is at least SHARE exactly where P(X >= x) at SHARE is at most 1 - conf; the upper bound is below
SHARE exactly where P(X <= x) at SHARE is below 1 - conf). The bounds reported are by bisection, to six places,
and never decide.

Where a course record's earlier rounds were made again, the lock is read from the rounds its own prompt showed
(scl_design.rounds over the records logged before it), not from the latest records: every record in the lock at k
then showed the lock's text.

The law's own quantifier: the Lean's statements are for every course from the start (every step rests, every
answer to the untried act drops the false candidate). On draws from a model at default sampling the rule reads
them as shares, at exact bounds, against a tolerance frozen here; a spontaneous try is the first exit taken, not a
forbidden case, so S reads differences between controls and never a rate of trying.
"""

import math
from fractions import Fraction

import scl_design as D

# Exact fractions, so that "at least" and "at most" are the frozen rule's at every tie (FREEZE-12.md, section 4).
ALPHA = Fraction(1, 100)        # per verdict and pin: Bonferroni over K's and S's comparisons; over the exits' two
                                # worlds; the turn's one world
DELTA_K = Fraction(1, 5)        # the least fall of the "either" share that can contradict K
DELTA_S = Fraction(1, 10)       # the least rise of the hazard of trying that can contradict S
SHARE = Fraction(1, 2)          # the exits' and the turn's share
START_MIN = Fraction(1, 2)      # the premise: the start probes naming "either"
N_MIN = 10                      # read probes, or courses, a comparison or a world needs
N_MIN_RISK = 30                 # course-rounds at risk a hazard needs
CONF = Fraction(95, 100)        # one-sided bounds for support (and the readability rule's)
CONF_EXIT_CONTRA = 1 - ALPHA / 2    # an exit's world contradicts at this one-sided upper bound
CONF_TURN_CONTRA = 1 - ALPHA        # the turn contradicts at this one-sided upper bound
SHIFT_ALPHA = Fraction(5, 100)      # an S contradiction's listing shift is seen at Fisher-Freeman-Halton p at most
                                    # this (R2-2): it decides only the bridge a contradiction is laid on
EXIT_ARMS = {"E1": "N2a", "E2": "N2b"}       # each exit and its twin

START_ARMS = ("B", "E1", "N2a", "E2", "N2b")
KTESTS = [("K B 4", "B", 4, "start"), ("K B 7", "B", 7, "start"), ("K B 14", "B", 14, "start"),
          ("K B 21", "B", 21, "start"), ("K N2a 4", "N2a", 4, "start"), ("K N2a 7", "N2a", 7, "start"),
          ("K N2b 4", "N2b", 4, "start"), ("K N2b 7", "N2b", 7, "start"), ("K N3 4", "N3", 4, "N3 start"),
          ("K N3 7", "N3", 7, "N3 start"), ("K N3 start", "N3", 2, "start")]
LATE = tuple(range(9, D.N_ANN + 1))
EARLY = tuple(range(2, 9))
MIDDLE = tuple(range(4, 9))          # R2-1: B's rounds 4 to 8, against its rounds 2 and 3
FIRST = (2, 3)
AFTER = (4, 5, 6)
SHORT_FREE = (2, 4, 5, 6)
STESTS = [("S N1 more rounds, 9 to 21 over 2 to 8", ("B", LATE, None), ("B", EARLY, None)),
          ("S N1 more rounds, 4 to 8 over 2 and 3", ("B", MIDDLE, None), ("B", FIRST, None)),
          ("S N1 more rounds, 3 over 2", ("B", (3,), None), ("B", (2,), None)),
          ("S N2a an assigned known round", ("N2a", AFTER, None), ("B", AFTER, None)),
          ("S N2b a telling of the known", ("N2b", AFTER, None), ("N2a", AFTER, None)),
          ("S N3 rewording", ("N3", SHORT_FREE, None), ("N2a", SHORT_FREE, None)),
          ("S N4 order 1 over 0", ("N4", None, 1), ("N4", None, 0)),
          ("S N4 order 0 over 1", ("N4", None, 0), ("N4", None, 1))]
N4_ARMS = ("B", "N2a", "N2b")
# Beside each S comparison (R1-3, R2-2): the probes matching its two sides (arms, probe rounds; None: both name
# orders, else the order) and the K comparisons that read the listing on either side (the start probes are K's own
# base, so a side of start probes adds none). N4 has none in K.
SK = {"S N1 more rounds, 9 to 21 over 2 to 8": {"test": (("B",), (14, 21), None), "base": (("B",), (2, 4, 7), None),
                                               "K": ("K B 14", "K B 21", "K B 4", "K B 7")},
      "S N1 more rounds, 4 to 8 over 2 and 3": {"test": (("B",), (4, 7), None), "base": (("B",), (2,), None),
                                                "K": ("K B 4", "K B 7")},
      "S N1 more rounds, 3 over 2": {"test": (("B",), (4,), None), "base": (("B",), (2,), None), "K": ("K B 4",)},
      "S N2a an assigned known round": {"test": (("N2a",), (4, 7), None), "base": (("B",), (4, 7), None),
                                        "K": ("K N2a 4", "K N2a 7", "K B 4", "K B 7")},
      "S N2b a telling of the known": {"test": (("N2b",), (4, 7), None), "base": (("N2a",), (4, 7), None),
                                       "K": ("K N2b 4", "K N2b 7", "K N2a 4", "K N2a 7")},
      "S N3 rewording": {"test": (("N3",), (2, 4, 7), None), "base": (("N2a",), (2, 4, 7), None),
                         "K": ("K N3 start", "K N3 4", "K N3 7", "K N2a 4", "K N2a 7")},
      "S N4 order 1 over 0": {"test": (N4_ARMS, (2, 4, 7), 1), "base": (N4_ARMS, (2, 4, 7), 0), "K": ()},
      "S N4 order 0 over 1": {"test": (N4_ARMS, (2, 4, 7), 0), "base": (N4_ARMS, (2, 4, 7), 1), "K": ()}}
FREE = {a: tuple(D.free_rounds(a)) for a in D.COURSE_ARMS}


# ------------------------------------------------------------------------------------------------
# Exact statistics

def binom_cdf(k, n, p):
    """P(X <= k), X binomial(n, p), each term in logs (lgamma), so a large n does not overflow."""
    if k < 0:
        return 0.0
    if k >= n:
        return 1.0
    if p <= 0.0:
        return 1.0
    if p >= 1.0:
        return 0.0
    lp, lq = math.log(p), math.log1p(-p)
    lg = math.lgamma(n + 1)
    return min(1.0, sum(math.exp(lg - math.lgamma(i + 1) - math.lgamma(n - i + 1) + i * lp + (n - i) * lq)
                        for i in range(k + 1)))


def bound(x, n, upper, conf=CONF):
    """The one-sided Clopper-Pearson bound at conf: the least p with P(X >= x) >= 1 - conf (lower), or the
    greatest with P(X <= x) >= 1 - conf (upper). By bisection, 60 halvings; rounded to 6 places."""
    if n == 0:
        return 1.0 if upper else 0.0
    if not upper and x == 0:
        return 0.0
    if upper and x == n:
        return 1.0
    lo, hi = 0.0, 1.0
    for _ in range(60):
        mid = (lo + hi) / 2
        if upper:
            ok = binom_cdf(x, n, mid) >= 1 - conf          # mid still plausible from above
            lo, hi = (mid, hi) if ok else (lo, mid)
        else:
            ok = 1 - binom_cdf(x - 1, n, mid) >= 1 - conf  # mid plausible from below
            lo, hi = (lo, mid) if ok else (mid, hi)
    return round((lo + hi) / 2, 6)


def fisher_exact(a, n1, b, n2):
    """Fisher's exact one-sided p that the first group's rate exceeds the second's: P(X >= a) for X
    hypergeometric, the margins fixed (a + b successes among n1 + n2, n1 drawn). An exact fraction."""
    if n1 == 0 or n2 == 0:
        return Fraction(1)
    k, N = a + b, n1 + n2
    tot = math.comb(N, k)
    tail = sum(math.comb(n1, i) * math.comb(n2, k - i) for i in range(a, min(n1, k) + 1))
    return Fraction(tail, tot)


def fisher_greater(a, n1, b, n2):
    """fisher_exact rounded to 9 places, as reported; it never decides."""
    return round(float(fisher_exact(a, n1, b, n2)), 9)


def tail_at(x, n, p, upper_tail):
    """The exact binomial tail at p (a fraction): P(X >= x) where upper_tail, else P(X <= x)."""
    p = Fraction(p)
    idx = range(max(x, 0), n + 1) if upper_tail else range(0, min(x, n) + 1)
    return sum(math.comb(n, i) * p ** i * (1 - p) ** (n - i) for i in idx)


def lower_at_least(x, n, share=SHARE, conf=CONF):
    """Exactly: the one-sided Clopper-Pearson lower bound at conf is at least share (P(X >= x) at share is at most
    1 - conf). With n = 0 the bound is 0."""
    return n > 0 and tail_at(x, n, share, True) <= 1 - Fraction(conf)


def upper_below(x, n, share=SHARE, conf=CONF):
    """Exactly: the one-sided Clopper-Pearson upper bound at conf is below share (P(X <= x) at share is below
    1 - conf). With n = 0 the bound is 1."""
    return n > 0 and tail_at(x, n, share, False) < 1 - Fraction(conf)


def k_hit(t, b):
    """A K comparison (test (x, n) against base (x, n)): the fall, Fisher's p, and whether it contradicts: the fall
    at least DELTA_K and p at most ALPHA / 11, both exact."""
    fall = Fraction(b[0], b[1]) - Fraction(t[0], t[1])
    p = fisher_exact(b[0], b[1], t[0], t[1])
    return fall, p, fall >= DELTA_K and p <= ALPHA / len(KTESTS)


def s_hit(t, b):
    """An S comparison (test (tries, at risk) against base): the rise, Fisher's p, and whether it contradicts: the
    rise at least DELTA_S and p at most ALPHA / 8 (len(STESTS)), both exact."""
    rise = Fraction(t[0], t[1]) - Fraction(b[0], b[1])
    p = fisher_exact(t[0], t[1], b[0], b[1])
    return rise, p, rise >= DELTA_S and p <= ALPHA / len(STESTS)


def ffh_two_sided(t, b):
    """The exact two-sided Fisher-Freeman-Halton p of a 2 x k table (rows t and b, counts of each answer): the
    chance, the margins fixed, of a table no more likely than the one seen. Each table's chance is the product of
    the columns' binomial coefficients over C(N, n_t), so the tables are compared by integers exactly. A fraction."""
    cols = [x + y for x, y in zip(t, b)]
    nt, N = sum(t), sum(cols)
    if nt == 0 or nt == N:
        return Fraction(1)

    def tables(i, left):
        if i == len(cols) - 1:
            if left <= cols[i]:
                yield (left,)
            return
        for a in range(max(0, left - sum(cols[i + 1:])), min(cols[i], left) + 1):
            for rest in tables(i + 1, left - a):
                yield (a,) + rest

    def weight(row):
        w = 1
        for a, c in zip(row, cols):
            w *= math.comb(c, a)
        return w

    seen = weight(t)
    tail = sum(w for w in map(weight, tables(0, nt)) if w <= seen)
    return Fraction(tail, math.comb(N, nt))


def rate(x, n):
    return round(x / n, 6) if n else None


def num(v):
    """A fraction as the readout reports it: a float to nine places."""
    return round(float(v), 9)


# ------------------------------------------------------------------------------------------------
# The courses from the records read

def label_of(answer):
    return answer if answer in D.PROBE_LABELS else D.UNREAD


def courses_of(good, recs=None):
    """From the records read (freeze 1's verdicts.load's good records, any order): each course's acts by free round
    and probes by round, and C's answers by name order. recs: every record in its logged order; where given, each
    course record keeps the rounds its own prompt showed (scl_design.rounds over the records logged before its
    latest record), and the lock at its round is read from them (section 6)."""
    courses, c_ans = {}, {o: [] for o in D.ORDERS}
    last = {r["id"]: k for k, r in enumerate(recs)} if recs is not None else None
    for r in good:
        if r["condition"] == "C":
            c_ans[r["order"]].append(r["answer"])
            continue
        c = courses.setdefault(D.course_key(r), {"acts": {}, "probes": {}})
        if r["what"] == "act":
            c["acts"][r["round"]] = r["answer"]
        else:
            c["probes"][r["round"]] = label_of(r["answer"])
        if last is not None:
            c.setdefault("shown", {})[(r["what"], r["round"])] = D.rounds(r, recs[:last[r["id"]]])
    return courses, c_ans


def lock_end(arm, acts):
    """The first round at which the course's round was not the known option (taken by the player or chosen for
    it), or the arm's last round plus one: the course is in the lock at every round up to it."""
    a = D.ARMS[arm]
    for r in range(2, a["last"] + 1):
        if r in a["assigned"]:
            if a["assigned"][r] != D.KNOWN:
                return r
        elif acts.get(r) != D.KNOWN:
            return r
    return a["last"] + 1


def in_lock(arm, acts, k):
    """Every round before k the known option: the free ones taken by the player, the assigned ones chosen for it."""
    return k <= lock_end(arm, acts)


def locked(c, arm, k, rec=None):
    """in_lock for a course of the rule's structure. rec: (what, round), the record whose lock is read; where its
    shown rounds are kept (courses_of with recs), the lock at k is read from them; otherwise from the course's acts,
    its lock's end computed once and kept with it."""
    if rec is not None and rec in c.get("shown", {}):
        return in_lock(arm, c["shown"][rec], k)
    if "end" not in c:
        c["end"] = lock_end(arm, c["acts"])
    return k <= c["end"]


def both_share(courses, arm_set, k, order=None):
    """(probes naming "either", probes read) before round k, over courses of the arms in the lock at k."""
    x = n = 0
    for (arm, w, o, rep), c in courses.items():
        if arm not in arm_set or (order is not None and o != order) or k not in c["probes"]:
            continue
        if not locked(c, arm, k, ("probe", k)):
            continue
        lab = c["probes"][k]
        if lab == D.UNREAD:
            continue
        n += 1
        x += lab == D.BOTH
    return x, n


def listing(courses, arm_set, ks, order=None):
    """The stated listing, described: the counts of the three probe answers (and unread) over the probes before the
    rounds ks, of the arms' courses in the lock at each probe's round (R1-3's two-sided description)."""
    cnt = {D.BOTH: 0, D.HIGH: 0, D.LOW: 0, D.UNREAD: 0}
    for (arm, w, o, rep), c in courses.items():
        if arm not in arm_set or (order is not None and o != order):
            continue
        for k in ks:
            if k in c["probes"] and locked(c, arm, k, ("probe", k)):
                cnt[c["probes"][k]] += 1
    return cnt


def hazard(courses, arm, rounds_, order=None):
    """(tries, course-rounds at risk): rounds in rounds_ at which a course of the arm (N4: of N4_ARMS, every free
    round) is in the lock and its act is read; a try is the other option."""
    arms = N4_ARMS if arm == "N4" else (arm,)
    tries = risk = 0
    for (a, w, o, rep), c in courses.items():
        if a not in arms or (order is not None and o != order):
            continue
        free = FREE[a]
        for k in (free if rounds_ is None else rounds_):
            if k not in free or not locked(c, a, k, ("act", k)):
                continue
            act = c["acts"].get(k)
            if act not in (D.KNOWN, D.UNTRIED):
                continue
            risk += 1
            tries += act == D.UNTRIED
    return tries, risk


# ------------------------------------------------------------------------------------------------
# The verdicts

NO_START = f"not testable (fewer than {N_MIN} start probes read)"
NO_BOTH = "not testable (the start does not list both)"


def premise(courses):
    x, n = both_share(courses, START_ARMS, 2)
    asked = sum(1 for (arm, w, o, rep), c in courses.items() if arm in START_ARMS and 2 in c["probes"])
    holds = n >= N_MIN and x >= START_MIN * n
    why = None if holds else NO_START if n < N_MIN else NO_BOTH
    return {"start probes naming either, of those read": [x, n], "start probes unread, of those asked": [asked - n, asked],
            "share": rate(x, n), "holds": holds, "not testable because": why}


def k_verdict(courses):
    start = both_share(courses, START_ARMS, 2)
    n3start = both_share(courses, ("N3",), 2)
    rows, contra, unread = [], [], []
    for name, arm, k, base in KTESTS:
        t = both_share(courses, (arm,), k)
        b = start if base == "start" else n3start
        if t[1] < N_MIN or b[1] < N_MIN:
            unread.append(name)
            rows.append({"comparison": name, "test": list(t), "base": list(b), "read": False})
            continue
        fall, p, hit = k_hit(t, b)
        rows.append({"comparison": name, "test": list(t), "base": list(b), "read": True,
                     "fall": round(float(fall), 6), "p": num(p), "contradicts": hit})
        if hit:
            contra.append(name)
    status = "contradicted" if contra else ("passed" if len(unread) < len(KTESTS) else "not testable")
    return {"verdict": status, "contradicting": contra, "not read": unread, "comparisons": rows}


LAID_II = "bridge (ii), no shift of the listing seen"
LAID_I_OR_II = "bridge (i) or (ii)"


def shift(beside):
    """Whether a shift of the stated listing between an S comparison's two sides is seen, can't be read, or is not
    seen: the three answers' counts (unread left out), test against base, by ffh_two_sided at SHIFT_ALPHA; read
    only with N_MIN read probes on each side."""
    t = [beside["test"][lab] for lab in D.PROBE_LABELS]
    b = [beside["base"][lab] for lab in D.PROBE_LABELS]
    if sum(t) < N_MIN or sum(b) < N_MIN:
        return {"read": False}
    p = ffh_two_sided(t, b)
    return {"read": True, "p": num(p), "seen": p <= SHIFT_ALPHA}


def s_verdict(courses, k=None):
    """S, each comparison with the stated listing beside it and, where it contradicts, the bridge it is laid on:
    LAID_II only where every matching K comparison of both sides (SK) is read and none contradicts, and the
    listing's two sides are read and show no shift (shift); else LAID_I_OR_II. k: K's verdict, as k_verdict gives
    it."""
    k = k or k_verdict(courses)
    krows = {r["comparison"]: r for r in k["comparisons"]}
    rows, contra, unread, laid = [], [], [], {}
    for name, (ta, tr, to), (ba, br, bo) in STESTS:
        t = hazard(courses, ta, tr, to)
        b = hazard(courses, ba, br, bo)
        sk = SK[name]
        beside = {"test": listing(courses, *sk["test"]), "base": listing(courses, *sk["base"]),
                  "matching K comparisons": {n: ("not read" if not krows[n]["read"] else
                                                 "contradicts" if krows[n]["contradicts"] else "read, no fall")
                                             for n in sk["K"]}}
        if t[1] < N_MIN_RISK or b[1] < N_MIN_RISK:
            unread.append(name)
            rows.append({"comparison": name, "test": list(t), "base": list(b), "read": False,
                         "the stated listing beside it": beside})
            continue
        rise, p, hit = s_hit(t, b)
        row = {"comparison": name, "test": list(t), "base": list(b), "read": True,
               "rise": round(float(rise), 6), "p": num(p), "contradicts": hit, "the stated listing beside it": beside}
        if hit:
            contra.append(name)
            sh = shift(beside)
            beside["a shift of the listing between the sides (Fisher-Freeman-Halton)"] = sh
            clean = bool(sk["K"]) and all(krows[n]["read"] and not krows[n]["contradicts"] for n in sk["K"]) \
                and sh["read"] and not sh["seen"]
            laid[name] = row["laid on"] = LAID_II if clean else LAID_I_OR_II
        rows.append(row)
    status = "contradicted" if contra else ("passed" if len(unread) < len(STESTS) else "not testable")
    return {"verdict": status, "contradicting": contra, "laid on": laid, "not read": unread, "comparisons": rows}


def true_label(world):
    return D.HIGH if world == D.UP else D.LOW


def exit_counts(courses, arm, w):
    """(naming the true amount alone, read): the exit arm's courses in world w in the lock at round 3 whose probe
    before round 4 is read; an unread probe, or none, counts in neither."""
    x = n = 0
    for (a, ww, o, rep), c in courses.items():
        if a != arm or ww != w or not locked(c, arm, D.K0, ("probe", D.K0 + 1)):
            continue
        lab = c["probes"].get(D.K0 + 1)
        if lab is None or lab == D.UNREAD:
            continue
        n += 1
        x += lab == true_label(w)
    return x, n


def twin_counts(courses, twin, w):
    """(naming world w's true amount, read): the twin's courses (both worlds: its words are world-blind) in the lock
    at round 4 whose probe before round 4 is read."""
    x = n = 0
    for (a, ww, o, rep), c in courses.items():
        if a != twin or not locked(c, twin, D.K0 + 1, ("probe", D.K0 + 1)):
            continue
        lab = c["probes"].get(D.K0 + 1)
        if lab is None or lab == D.UNREAD:
            continue
        n += 1
        x += lab == true_label(w)
    return x, n


def exit_verdict(courses, arm):
    twin = EXIT_ARMS[arm]
    worlds = {}
    for w in D.WORLDS:
        x, n = exit_counts(courses, arm, w)
        tx, tn = twin_counts(courses, twin, w)
        lo, hi = bound(x, n, False), bound(x, n, True, CONF_EXIT_CONTRA)
        p = fisher_exact(x, n, tx, tn)
        if n < N_MIN:
            s = "not testable"
        elif upper_below(x, n, SHARE, CONF_EXIT_CONTRA):
            s = "contradicted"
        elif lower_at_least(x, n, SHARE, CONF) and tn >= N_MIN and p <= ALPHA / 2:
            s = "supported"
        else:
            s = "unresolved"
        worlds[w] = {"in the lock at round 3, probe before round 4 read": n, "naming the true amount alone": x,
                     "share": rate(x, n), "lower (95%)": lo, "upper (1 - ALPHA/2)": hi,
                     "twin naming it, of those read": [tx, tn], "p over the twin": num(p), "reading": s}
    ss = [worlds[w]["reading"] for w in D.WORLDS]
    status = "contradicted" if "contradicted" in ss else "supported" if all(s == "supported" for s in ss) \
        else "not testable" if "not testable" in ss else "unresolved"
    return {"verdict": status, "worlds": worlds}


def c_strict(c_ans):
    """C's pick in each name order, strict where one amount is named in at least Q of its C_CALLS calls."""
    out = {}
    for o in D.ORDERS:
        got = [a for a in c_ans[o] if a in (D.MID, D.HIGH)]
        top = max((D.MID, D.HIGH), key=lambda v: got.count(v))
        out[o] = top if got.count(top) >= D.Q and len(c_ans[o]) == D.C_CALLS else None
    return out


def turn_counts(courses, arm, w, k_lock):
    """(taking the other option at round 4, act read): the arm's courses in world w in the lock at k_lock (3 for
    the exit arm, 4 for its twin), as the act record at round 4 showed it."""
    x = n = 0
    for (a, ww, o, rep), c in courses.items():
        if a != arm or ww != w or not locked(c, arm, k_lock, ("act", D.K0 + 1)):
            continue
        act = c["acts"].get(D.K0 + 1)
        if act not in (D.KNOWN, D.UNTRIED):
            continue
        n += 1
        x += act == D.UNTRIED
    return x, n


def turn_verdict(courses, arm, exit_v, cs):
    shares = {}
    twin = EXIT_ARMS[arm]
    for w in D.WORLDS:
        x, n = turn_counts(courses, arm, w, D.K0)
        tx, tn = turn_counts(courses, twin, w, D.K0 + 1)
        shares[w] = {"in the lock at round 3, act read at round 4": n, "taking the other option": x,
                     "share": rate(x, n), "lower (95%)": bound(x, n, False),
                     "upper (1 - ALPHA)": bound(x, n, True, CONF_TURN_CONTRA),
                     "twin taking it, of those read (in the lock at round 4)": [tx, tn],
                     "p over the twin": num(fisher_exact(x, n, tx, tn))}
    if all(cs[o] == D.MID for o in D.ORDERS):
        status = "no turn predicted (C strict at 5: order_rests)"
    elif not all(cs[o] == D.HIGH for o in D.ORDERS):
        status = "not ruled (C not strict at 8 in both name orders)"
    elif exit_v["verdict"] != "supported":
        status = "not ruled (the exit in belief not supported)"
    else:
        x, n = turn_counts(courses, arm, D.UP, D.K0)
        tx, tn = turn_counts(courses, twin, D.UP, D.K0 + 1)
        status = "not testable" if n < N_MIN else \
            "contradicted" if upper_below(x, n, SHARE, CONF_TURN_CONTRA) else \
            "supported" if lower_at_least(x, n, SHARE, CONF) and tn >= N_MIN \
            and fisher_exact(x, n, tx, tn) <= ALPHA / 2 else "unresolved"
    return {"verdict": status, "up": shares[D.UP], "down (no turn predicted: downRest)": shares[D.DOWN]}


def descriptive(courses):
    """Reported, no verdict: per arm the share in the lock at round 3 (2 for none), the first round each course
    tries the other option, the hazard over its free rounds, and the probes' answers at each round."""
    out = {}
    for arm in D.COURSE_ARMS:
        cs = [(k, c) for k, c in courses.items() if k[0] == arm]
        first = {}
        for k, c in cs:
            tried = [r for r in sorted(c["acts"]) if c["acts"][r] == D.UNTRIED]
            first[tried[0] if tried else None] = first.get(tried[0] if tried else None, 0) + 1
        t, risk = hazard(courses, arm, None)
        probes = {}
        for r in D.ARMS[arm]["probes"]:
            cnt = {}
            for k, c in cs:
                lab = c["probes"].get(r)
                if lab is not None:
                    cnt[lab] = cnt.get(lab, 0) + 1
            probes[r] = dict(sorted(cnt.items()))
        by_order = {str(o): listing(courses, (arm,), (2,), o) for o in D.ORDERS}
        out[arm] = {"start probes by name order (N4, described)": by_order, "courses": len(cs), "in the lock at round 3": sum(locked(c, arm, D.K0) for _, c in cs),
                    "first try, by round (None: never)": {str(k): v for k, v in sorted(first.items(), key=str)},
                    "hazard over the free rounds": [t, risk, rate(t, risk)], "probes by round": probes}
    return out


def reading(courses, c_ans, family=None, role=None):
    """The pin's reading: the premise, K, S, E1, E2 and the turn after each, and the descriptive part."""
    prem = premise(courses)
    cs = c_strict(c_ans)
    res = {"family": family, "pin_role": role, "decides": role == "decides", "premise": prem,
           "C strict, by name order": {str(o): cs[o] for o in D.ORDERS}}
    if not prem["holds"]:
        for v in ("K", "S", "E1", "E2", "T after E1", "T after E2"):
            res[v] = {"verdict": prem["not testable because"]}
    else:
        res["K"] = k_verdict(courses)
        res["S"] = s_verdict(courses, res["K"])
        for arm in EXIT_ARMS:
            res[arm] = exit_verdict(courses, arm)
            res["T after " + arm] = turn_verdict(courses, arm, res[arm], cs)
    res["descriptive"] = descriptive(courses)
    res["summary"] = {v: res[v]["verdict"] for v in ("K", "S", "E1", "E2", "T after E1", "T after E2")}
    return res


# ------------------------------------------------------------------------------------------------
# The readability rule (FREEZE-8's form, section 8)

READ_MIN_SHARE = 0.8    # a pin starts where, at the unreadable rate's lower bound, this share of a short course's
SHORT_CALLS = 7         # seven calls (four acts, three probes) would all be read


def unreadable(answer):
    return answer in (D.INVALID, D.FILTERED, D.NONE)


def readability(n_unread, n_calls):
    """The pin's unreadable answers over every SCL call it made under the client in force (smoke runs and logged
    calls), at the one-sided 95% lower bound: the run starts where (1 - lower)^7 >= 0.8."""
    lo = bound(n_unread, n_calls, False) if n_calls else 0.0      # the bound to six places, part of this rule
    share = round((1 - lo) ** SHORT_CALLS, 6)
    return {"unreadable": n_unread, "calls": n_calls, "lower bound": lo,
            "short courses read whole at that rate": share, "starts": share >= READ_MIN_SHARE}


def readability_stop_chance(u, n):
    """The exact chance that n calls, each unreadable with chance u, stop a pin by the readability rule."""
    p = 0.0
    for k in range(n + 1):
        if not readability(k, n)["starts"]:
            p += math.comb(n, k) * u ** k * (1 - u) ** (n - k)
    return round(p, 6)


# ------------------------------------------------------------------------------------------------
# The AI expectation (section 13), coded and reported, never a verdict

def expectations(res):
    """Stated before any call: on each pin read, the lock forms (at least half of E1's and E2's courses in the lock
    at round 3), and E1 and E2 are supported. Nothing is expected of K, S or the turn."""
    if not res["premise"]["holds"]:
        return {"lock forms": None, "E1 supported": None, "E2 supported": None}
    d = res["descriptive"]
    lock = all(d[a]["in the lock at round 3"] >= d[a]["courses"] / 2 for a in ("E1", "E2"))
    return {"lock forms": lock, "E1 supported": res["E1"]["verdict"] == "supported",
            "E2 supported": res["E2"]["verdict"] == "supported"}
