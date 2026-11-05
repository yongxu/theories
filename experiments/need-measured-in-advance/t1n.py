"""T1N's rules (DESIGN.md, sections 4 to 7): the need, the scope, the reference and the fate, and the verdicts.
Pure functions on lakes; nothing here reads a file or a value of the archive.

A lake, as reader.py builds it from the recorders' tables:
    id        the recorders' water body code (WBIC)
    acres     the lake's area
    label     {year: the recorders' primary recruitment source for the lake that year}, mapped by layout.json
    adults    {year: (estimate, lower, upper)}, spring adult walleye per acre and its 95% interval
    age0      {year: fall age-0 walleye per mile of shoreline}
    harvest   {year: recorded harvest of adult walleye per acre}: tribal harvest, and angling where a
              creel survey ran that year (reported only)
    creel     the years with a creel survey
    stocked   the years with walleye stocking in WDNR's database, of any size
    other     the years with fry, tribal or private walleye stocking (R5b), or None where those records
              were not read
    closed    True for a recorded seepage lake (no inlet or outlet), False for another recorded type, None
              where no type is recorded
`labels` (an argument throughout) is False where the layout shows no lake's label changing across years: the
label is then the lake's classification when the report was made, after the series, and the rules read the
stocking records alone. Standard library only.
"""

import math
import re
from fractions import Fraction

CUTOFF = 2012                 # the need's fit and the premise's check read years up to and including this
FIRST_REF = 2013              # a reference's first year; its last is the archive's last estimate year less GAP_MIN
GAP_MIN, GAP_MAX = 3, 10      # years from the reference survey to the fate's
STOCK_BEFORE = 5              # years before a survey whose recorded stocking makes its level a stocked one
RECRUIT_LAG = 3               # years from a fall's age-0 to the spring adults they join: renewal pending
FLOOR = 1.0                   # fall age-0 per mile below which a year's renewal is read as stopped
FLOORS_REPORTED = (0.0, 1.0, 5.0, 10.0)   # the floors V1 is reported at (at 0, any age-0 caught); FLOOR decides it
NR, COMBINATION = "natural", "combination"   # the rules' label categories, as layout.json maps the recorders' texts
N_MIN = 10                    # resolved lakes below the need, below which V1 is not decided
N_REFUTE = 20                 # the resolved lakes below the need the letter's refutation needs (DESIGN.md, section 7)
ALPHA = Fraction(5, 100)
PAIRS_MIN, LAKES_MIN = 200, 30     # the need's fit: at least these pairs, from at least these lakes
RIDGE = 1e-3                  # the fit's penalty on its coefficients, for a finite fit under separation
Z95 = 1.96                    # the slope's lower 95% bound is b - Z95 se(b); a 95% interval's half-width in sds
Z_ONE = 1.645                 # a decline or a rise by the ratio test on the recorders' intervals, one-sided at 0.05
KEPT = 0.25                   # persisted: the later estimate's ratio to the reference's, at its lower bound, keeps a quarter
LABELS_SHARE = 0.05           # labels read per year where at least this share of lakes change category across surveys
DID_NOT_OCCUR = "T1's forbidden case did not occur"   # V1's positive outcome (DESIGN.md, section 7)
SIDE_MIN = 20                 # the need must have at least this many of the fit's lake-years on each side


def reached(r, floor):
    """A year's renewal reached the floor: at least `floor` age-0 per mile, or, at a floor of 0, any caught."""
    return r > 0 if floor == 0 else r >= floor


def tail_half(n, k):
    """The exact chance that a fair coin gives at least k heads in n tosses."""
    return Fraction(sum(math.comb(n, j) for j in range(k, n + 1)), 2 ** n)


def critical(n, alpha=ALPHA):
    """The least k with tail_half(n, k) <= alpha, or None where none is."""
    return next((k for k in range(n + 1) if tail_half(n, k) <= alpha), None)


def lower_bound(k, n, alpha=ALPHA):
    """The exact one-sided lower bound at 1 - alpha on a share of k in n (Clopper and Pearson's): the p at which
    k or more in n has chance alpha, by bisection; 0 where k is 0. Reported, deciding nothing."""
    if k == 0:
        return 0.0
    lo, hi = 0.0, k / n
    for _ in range(60):
        mid = (lo + hi) / 2
        tail = sum(math.comb(n, j) * mid ** j * (1 - mid) ** (n - j) for j in range(k, n + 1))
        lo, hi = (mid, hi) if tail < alpha else (lo, mid)
    return lo


def fisher_greater(k, n, ka, na):
    """The exact one-sided chance, under no difference, of k or more falls among n lakes below the need when
    k + ka fell among n + na: Fisher's exact test that the share below exceeds the share above."""
    total, falls = n + na, k + ka
    den = math.comb(total, n)
    return Fraction(sum(math.comb(falls, j) * math.comb(total - falls, n - j)
                        for j in range(k, min(n, falls) + 1)), den)


def stocked_in(lk, a, b):
    """The years from a to b with walleye stocking in WDNR's database or, where read, in the other records."""
    return sorted(s for s in lk["stocked"] | (lk.get("other") or set()) if a <= s <= b)


def labels_per_year(lakes):
    """Whether the recorders' labels are read per year: at least LABELS_SHARE of the lakes with two or more
    labelled surveys change category across them. One lake's change may be a correction; a label no lake
    changes is the lake's classification when the report was made (DESIGN.md, section 5)."""
    multi = [lk for lk in lakes if len(lk["label"]) > 1]
    changing = sum(1 for lk in multi if len(set(lk["label"].values())) > 1)
    return bool(multi) and changing >= LABELS_SHARE * len(multi)


def natural_at(lk, year, labels):
    """The recorders' label says natural recruitment that year; always so where the labels are not per year."""
    return (not labels) or lk["label"].get(year) == NR


def log_sd(estimate):
    """A survey's standard error on the log scale, from its 95% interval: (ln upper - ln lower) / (2 Z95);
    None where the estimate or a bound is not positive."""
    est, lo, hi = estimate
    return (math.log(hi) - math.log(lo)) / (2 * Z95) if min(est, lo, hi) > 0 else None


def change(lk, a, b):
    """The change from the lake's survey in year a to its survey in year b, as a ratio test on the recorders'
    intervals: z = (ln est_b - ln est_a) / sqrt(s_a^2 + s_b^2), each s from its interval (log_sd); a decline
    where z < -Z_ONE, a rise where z > Z_ONE. None where an interval cannot be read on the log scale."""
    sa, sb = log_sd(lk["adults"][a]), log_sd(lk["adults"][b])
    if sa is None or sb is None or sa * sa + sb * sb == 0:
        return None
    return (math.log(lk["adults"][b][0]) - math.log(lk["adults"][a][0])) / math.sqrt(sa * sa + sb * sb)


def ratio_lower(lk, a, b):
    """The ratio of the lake's estimate in year b to its estimate in year a, at its one-sided lower bound at 0.05
    on the recorders' intervals (log_sd): exp(ln est_b - ln est_a - Z_ONE sqrt(s_a^2 + s_b^2)). None where an
    interval cannot be read on the log scale."""
    sa, sb = log_sd(lk["adults"][a]), log_sd(lk["adults"][b])
    if sa is None or sb is None:
        return None
    return math.exp(math.log(lk["adults"][b][0]) - math.log(lk["adults"][a][0]) - Z_ONE * math.sqrt(sa * sa + sb * sb))


# --- the need ---------------------------------------------------------------------------------------------

def pairs(lakes, last=CUTOFF, floor=FLOOR, labels=True):
    """The need's data: every lake-year up to `last` with both a spring adult estimate and a fall age-0 survey,
    the label natural that year and no stocking recorded in it or the STOCK_BEFORE years before, as
    (lake, adults per acre, renewal at or above the floor that year)."""
    out = []
    for lk in lakes:
        for yr, (est, lo, hi) in sorted(lk["adults"].items()):
            if (yr <= last and yr in lk["age0"] and est > 0 and natural_at(lk, yr, labels)
                    and not stocked_in(lk, yr - STOCK_BEFORE, yr)):
                out.append((lk["id"], est, reached(lk["age0"][yr], floor)))
    return out


def logistic(xs, zs, ridge=RIDGE, iters=100):
    """The penalized maximum-likelihood fit of P(z) = 1 / (1 + exp(-(a + b ln x))), by Newton's method, the
    penalty ridge (a^2 + b^2) / 2 keeping the fit finite where the classes separate. Returns (a, b, se(b)),
    se from the inverse of the penalized information, or None where it does not converge."""
    us = [math.log(x) for x in xs]
    a = b = 0.0
    for _ in range(iters):
        ga, gb = -ridge * a, -ridge * b
        haa, hab, hbb = ridge, 0.0, ridge
        for u, z in zip(us, zs):
            t = a + b * u
            p = 0.0 if t < -700 else 1.0 if t > 700 else 1 / (1 + math.exp(-t))
            w = p * (1 - p)
            ga += z - p
            gb += (z - p) * u
            haa += w
            hab += w * u
            hbb += w * u * u
        det = haa * hbb - hab * hab
        if det <= 0:
            return None
        da, db = (hbb * ga - hab * gb) / det, (haa * gb - hab * ga) / det
        a, b = a + da, b + db
        if abs(da) < 1e-10 and abs(db) < 1e-10:
            return a, b, math.sqrt(haa / det)
    return None


def need(lakes, last=CUTOFF, floor=FLOOR, labels=True):
    """The need from every lake's years up to `last`: the adults per acre at which the fitted chance that a
    year's renewal reaches the floor is one half. One need for every lake, so no lake's need reads its own
    later series. None, with the reason, where the pairs are too few, the fit does not converge, the slope's
    lower 95% bound is not above zero (renewal not shown to rise with the level), or fewer than SIDE_MIN of
    the fit's lake-years lie on either side of the need (a need the data do not reach); an exponent too large
    to take counts as the last."""
    ps = pairs(lakes, last, floor, labels)
    lakes_in = len({i for i, _, _ in ps})
    out = {"pairs": len(ps), "lakes": lakes_in, "last year": last, "floor": floor}
    if len(ps) < PAIRS_MIN or lakes_in < LAKES_MIN:
        return {**out, "need": None, "reason": f"too few pairs: {len(ps)} from {lakes_in} lakes"}
    xs = [x for _, x, _ in ps]
    fit = logistic(xs, [1 if z else 0 for _, _, z in ps])
    if fit is None:
        return {**out, "need": None, "reason": "the fit did not converge"}
    a, b, se = fit
    out.update({"a": a, "b": b, "se(b)": se})
    if b - Z95 * se <= 0:
        return {**out, "need": None, "reason": "no need: the slope's lower 95% bound is not above zero"}
    t = -a / b
    if abs(t) > 700:
        return {**out, "need": None, "reason": "no need: the fitted level lies beyond any level of the fit"}
    y = math.exp(t)
    sides = sum(1 for x in xs if x < y), sum(1 for x in xs if x >= y)
    out["lake-years below and above the need"] = list(sides)
    if min(sides) < SIDE_MIN:
        return {**out, "need": None, "reason": f"no need: {sides[0]} of the fit's lake-years below it and {sides[1]} "
                                              f"above, fewer than {SIDE_MIN} on a side"}
    return {**out, "need": y}


# --- the scope, the reference and the fate --------------------------------------------------------------

def held_above(lk, need_, labels=True):
    """T1's premise at the lake, from its years up to CUTOFF: giving met the draw above the need. Two
    estimates up to CUTOFF, GAP_MAX years apart or less, both with their lower bounds at or above the need,
    no decline between them by the ratio test (change), the label natural at both and no stocking recorded
    from STOCK_BEFORE years before the first to the second. Returns the pair's years, or None."""
    years = sorted(t for t in lk["adults"] if t <= CUTOFF)
    for i, t1 in enumerate(years):
        for t2 in years[i + 1:]:
            if t2 - t1 > GAP_MAX:
                break
            z = change(lk, t1, t2)
            if (lk["adults"][t1][1] >= need_ and lk["adults"][t2][1] >= need_ and z is not None and z >= -Z_ONE
                    and natural_at(lk, t1, labels) and natural_at(lk, t2, labels)
                    and not stocked_in(lk, t1 - STOCK_BEFORE, t2)):
                return t1, t2
    return None


def side(estimate, need_):
    """Where a survey's interval stands against the need: below (wholly), above (wholly), or across it."""
    est, lo, hi = estimate
    return "below" if hi < need_ else "above" if lo >= need_ else "across"


def in_scope(lk, ref, labels=True):
    """The recorders' own fields keep the lake at its reference: the label natural there, and no stocking
    recorded in its year or the STOCK_BEFORE years before. Returns the reason it is out, or None."""
    if not natural_at(lk, ref, labels):
        return f"label at the reference: {lk['label'].get(ref)!r}"
    s = stocked_in(lk, ref - STOCK_BEFORE, ref)
    if s:
        return f"stocking recorded before the reference: {s}"
    return None


def pending(lk, ref, floor=FLOOR):
    """Renewal pending at the reference: an age-0 survey at or above the floor in the RECRUIT_LAG years before
    it, whose fish join the adults within the fate's horizon; unread unless every one of those years was
    surveyed. Returns the reason, or None where nothing is pending and every year was read."""
    window = range(ref - RECRUIT_LAG, ref)
    missing = [t for t in window if t not in lk["age0"]]
    up = [t for t in window if t in lk["age0"] and reached(lk["age0"][t], floor)]
    if up:
        return f"renewal pending: age-0 at or above the floor in {up}"
    if missing:
        return f"renewal unread: no age-0 survey in {missing}"
    return None


def below_read(lk, r, need_, floor=FLOOR):
    """A survey read as below the need, where T1 predicts a fall: its interval wholly below the need, and no
    renewal recorded at or above the floor in the RECRUIT_LAG years before it. Renewal already made is part of
    the lake's condition, its fish joining the adults within the fate's horizon, so a lake with it recorded is
    not shown below its need: that survey is set aside, and its fate reported. A year of the lag unsurveyed
    does not set it aside; a cohort the surveys missed can only lift the lake, against T1."""
    return side(lk["adults"][r], need_) == "below" and not (pending(lk, r, floor) or "").startswith("renewal pending")


def managed(lk, ref, fate, labels=True):
    """Giving from beyond, or a programme's relabelling, recorded after the reference up to the fate's survey:
    ("label", the first year the label leaves natural recruitment) or ("stocking", the first year stocking is
    recorded); None where neither is."""
    if labels:
        left = [t for t in sorted(lk["label"]) if ref < t <= fate and lk["label"][t] != NR]
        if left:
            return "label", left[0]
    s = stocked_in(lk, ref + 1, fate)
    return ("stocking", s[0]) if s else None


def fate_of(lk, ref, fate, need_, labels=True, label_alone=False):
    """The lake's fate between its reference and the fate's survey, read the same way on either side of the
    need, so that the separation compares like with like, and shown either way, never by default.
    - Unresolved where the label leaves natural recruitment at a survey after the reference, up to the fate's,
      or stocking is recorded after the reference (managed): giving from beyond, or a programme's relabelling,
      either way. (label_alone reads the label leaving natural recruitment as a fall by itself: the reading
      set aside, which the dry run and the run report beside.)
    - Fell where the fate's survey lies below the reference's by the ratio test (change), and no later survey
      within GAP_MAX years of the reference, before any recorded giving, rises from the fate's by the test (a
      recovery, a return T1 forbids below the need); after a recovery the lake is read at that survey.
    - Persisted where the later estimate keeps at least KEPT of the reference's at the ratio's one-sided lower
      bound (ratio_lower): a level shown kept, a rise, a return. At the surveys' usual error (each CV up to
      about 0.3) any change short of a decline by the test meets it; where the intervals are wider, it asks
      that the lake be shown to have kept a quarter, so low precision is not read as persistence.
    - Unresolved otherwise: the intervals show neither a fall nor a quarter kept; or where an interval cannot be
      read on the log scale.
    Returns (fate, how)."""
    m = managed(lk, ref, fate, labels)
    if m and m[0] == "label":
        return ("fell" if label_alone else "unresolved"), f"the label left natural recruitment in {m[1]}"
    if m:
        return "unresolved", f"stocking recorded in {m[1]}"
    z = change(lk, ref, fate)
    if z is None:
        return "unresolved", "an interval not read on the log scale"
    at, how = fate, "a quarter kept by the ratio's lower bound"
    if z < -Z_ONE:
        for f2 in sorted(t for t in lk["adults"] if fate < t <= ref + GAP_MAX):
            if managed(lk, ref, f2, labels):
                break
            z2 = change(lk, fate, f2)
            if z2 is not None and z2 > Z_ONE:
                at, how = f2, f"a decline by the ratio test, and a recovery by {f2}"
                break
        else:
            return "fell", "a decline by the ratio test"
        if at == fate:
            return "fell", "a decline by the ratio test"
    kept = ratio_lower(lk, ref, at)
    if kept is not None and kept >= KEPT:
        return "persisted", how
    return "unresolved", ("neither a decline nor a quarter kept shown by the intervals" if at == fate
                          else how + ", a quarter not shown kept")


def rows(lakes, need_, first=FIRST_REF, last=None, floor=FLOOR, labels=True, label_alone=False):
    """One row a lake. Out where T1's premise is not shown at the lake (held_above). Its reference is its first
    survey in time, from `first` to `last`, that is in scope and readable: read as below the need (below_read),
    where T1 predicts a fall, or with its interval wholly above the need, where T1 predicts persistence. A
    survey whose interval holds the need, or wholly below it with renewal pending, is passed over; so is one
    with no later estimate GAP_MIN to GAP_MAX years after, except that a lake whose first readable survey is
    below the need with none, where the archive runs GAP_MAX years past it, is marked unsurveyed (DESIGN.md,
    section 6); where the archive ends sooner, the missing estimate is the archive's end, not a survey stopped. Taking the first readable survey in
    time, not the first below the need wherever it falls, keeps a lake's side from being chosen by whether it
    later went below: a lake falling from above the need for any reason counts on the side it stood. Reading
    the interval, not the estimate, keeps a survey low by chance from being read as a lake below the need,
    whose next survey would regress upward. The first survey passed over for renewal pending is set aside,
    its fate by the same reading reported. The row gives the reference, the recorded draw, the need, both
    classifiers' predictions and the fate; or the reason it is out."""
    archive_end = max((t for lk in lakes for t in lk["adults"]), default=FIRST_REF)
    last = last if last is not None else archive_end - GAP_MIN
    out = []
    for lk in lakes:
        row = {"id": lk["id"]}
        held = held_above(lk, need_, labels)
        if held is None:
            out.append({**row, "out": "the premise not shown: no two estimates up to the cutoff held above the need"})
            continue
        years = sorted(lk["adults"])
        chosen, unsurveyed, aside, why_not = None, None, None, []
        for r in years:
            if not first <= r <= last:
                continue
            why = in_scope(lk, r, labels)
            if why is not None:
                why_not.append(why)
                continue
            where = side(lk["adults"][r], need_)
            later = [f for f in years if GAP_MIN <= f - r <= GAP_MAX]
            if where == "below" and not below_read(lk, r, need_, floor):
                if aside is None and later:
                    aside = (r, later[0])
                continue
            if where == "across":
                continue
            if not later:
                if where == "below" and r + GAP_MAX <= archive_end:
                    unsurveyed = r
                    break
                continue
            chosen = (r, later[0])
            break
        if aside:
            row["set aside, renewal pending"] = {"ref": aside[0],
                                                 "fate": fate_of(lk, aside[0], aside[1], need_, labels, label_alone)[0]}
        if chosen is None:
            if unsurveyed is not None:
                out.append({**row, "out": "below the need with no later estimate", "unsurveyed below": unsurveyed})
            else:
                out.append({**row, "out": "below the need only with renewal pending" if aside else
                            why_not[0] if why_not else "no reference survey with a later one"})
            continue
        r, f = chosen
        x, lo, hi = lk["adults"][r]
        h = lk["harvest"].get(r, 0.0)
        below = below_read(lk, r, need_, floor)
        row.update({"ref": r, "fate year": f, "x": x, "x interval": [lo, hi], "h": h, "need": need_,
                    "premise shown by": list(held), "creel at the reference": r in lk["creel"],
                    "T1 predicts": "falls" if below else "persists",
                    "null predicts": "persists",
                    "below the point with the recorded draw": x < need_ + h,
                    "fate estimate": list(lk["adults"][f]), "below the need at the reference": below,
                    "pending at the reference": pending(lk, r, floor),
                    "closed": lk.get("closed"), "other stocking read": lk.get("other") is not None})
        row["fate"], row["fate by"] = fate_of(lk, r, f, need_, labels, label_alone)
        out.append(row)
    return out


# --- the verdicts ----------------------------------------------------------------------------------------

def decide(below, above):
    """V1's decision from resolved rows below the need and above it: (verdict, numbers)."""
    n, k = len(below), sum(r["fate"] == "fell" for r in below)
    na, ka = len(above), sum(r["fate"] == "fell" for r in above)
    c = critical(n) if n else None
    nums = {"below: resolved": n, "below: fell": k, "above: resolved": na, "above: fell": ka, "critical": c}
    if n < N_MIN:
        return f"not decided: {n} resolved lakes below the need, fewer than {N_MIN}", nums
    if k >= c:
        p = fisher_greater(k, n, ka, na) if na else None
        nums["separation p"] = float(p) if p is not None else None
        if p is not None and p <= ALPHA:
            return DID_NOT_OCCUR + ": lakes below the need fell and did not return, the need's causal role not shown", nums
        return "not decided: below the need more fell than the null allows, but the lakes above it fell as often", nums
    if k <= n - c:
        return "refuted: the fates separated no better than by the null, on the null's side at 0.05", nums
    if 2 * k <= n and n >= N_REFUTE:
        return "refuted: the fates separated no better than by the null, at most half fell", nums
    if 2 * k <= n:
        return f"not decided: at most half fell, but {n} resolved lakes are fewer than {N_REFUTE}", nums
    return "not decided", nums


def v1(table, v2_=None):
    """The separation (primary): lakes below the need against the null with no need (y = 0), which predicts no
    fall; T1 predicts a fall below the need under any draw. T1's forbidden case did not occur where among the
    resolved lakes below the need at least the critical count of an exact one-sided sign test at 0.05 fell
    (McNemar's on the discordant lakes) and, by Fisher's exact test at 0.05, they fell more often than the
    resolved lakes above the need, both sides in scope: the separation across the need. That outcome says the
    need's causal role is not shown: renewal lost to another cause before the window gives it too (DESIGN.md,
    section 7). Refuted, the fates separated no better than
    by the null, where at most n - c fell (the null's side at 0.05) or, by the home's letter, at most half
    with at least N_REFUTE resolved. Not decided otherwise, or where fewer than N_MIN are resolved.

    Decided here before any value is read (DESIGN.md, section 7): a refutation one of three confounds could
    make on its own reads "refuted unless ...": fish from connected waters (a lake that persisted is not a
    recorded seepage lake, and the closed lakes alone do not refute), unrecorded stocking (the other stocking
    records were not read for a lake that persisted), and the unsurveyed (counted as fallen, the lakes below
    the need with no later estimate undo the refutation). The positive outcome with V2 met says so, with the
    lakes."""
    inn = [r for r in table if "out" not in r]
    below = [r for r in inn if r["T1 predicts"] == "falls" and r["fate"] != "unresolved"]
    above = [r for r in inn if r["T1 predicts"] == "persists" and r["fate"] != "unresolved"]
    verdict, nums = decide(below, above)
    out = dict(nums)
    out["below: fell share"] = round(nums["below: fell"] / nums["below: resolved"], 4) if nums["below: resolved"] else None
    out["below: fell share, exact lower bound at 0.95"] = (round(lower_bound(nums["below: fell"], nums["below: resolved"]), 4)
                                                          if nums["below: resolved"] else None)
    out["above: fell share"] = round(nums["above: fell"] / nums["above: resolved"], 4) if nums["above: resolved"] else None
    persisted = {"closed": [sum(1 for r in below if r["closed"] is True and r["fate"] == "persisted"),
                            sum(1 for r in below if r["closed"] is True)],
                 "open or of no type": [sum(1 for r in below if r["closed"] is not True and r["fate"] == "persisted"),
                                        sum(1 for r in below if r["closed"] is not True)]}
    out["below: persisted / resolved, by type"] = persisted
    (ko, no), (kc, nc) = persisted["open or of no type"], persisted["closed"]
    out["below: open lakes persisting more often than closed, p"] = float(fisher_greater(ko, no, kc, nc)) if no and nc else None
    if verdict.startswith(DID_NOT_OCCUR):
        out["p"] = float(tail_half(nums["below: resolved"], nums["below: fell"]))
        if v2_ and v2_["met"]:
            verdict += "; V2 met in " + ", ".join(m["id"] for m in v2_["lakes"])
    if verdict.startswith("refuted"):
        unless, kept = [], [r for r in below if r["fate"] == "persisted"]
        if any(r["closed"] is not True for r in kept):
            closed = decide([r for r in below if r["closed"] is True], [r for r in above if r["closed"] is True])[0]
            out["closed lakes alone"] = closed
            if not closed.startswith("refuted"):
                few = closed.startswith("not decided: ") and f"fewer than {N_MIN}" in closed
                unless.append("connected waters (the seepage lakes alone " + ("too few to decide)" if few else "not refuting)"))
        if any(not r["other stocking read"] for r in kept):
            unless.append("unrecorded stocking")
        unsurveyed = sum(1 for r in table if r.get("out") == "below the need with no later estimate")
        out["below the need with no later estimate"] = unsurveyed
        if unsurveyed:
            fell = [dict(r, fate="fell") for r in table if r.get("out") == "below the need with no later estimate"]
            if not decide(below + fell, above)[0].startswith("refuted"):
                unless.append("the unsurveyed fell")
        if unless:
            verdict = "refuted unless " + " or ".join(unless) + ": " + verdict.split(": ", 1)[1]
    out["verdict"] = verdict
    return out


def v2(table):
    """The single-lake form (reported): lakes in scope read as below their need at the reference with every
    year of the lag surveyed and none at or above the floor, and back above the need at the fate (the later
    interval's lower bound at or above it), with no stocking recorded after the reference and the label kept."""
    cand = [r for r in table if "out" not in r and r["T1 predicts"] == "falls" and r["pending at the reference"] is None]
    met = [r for r in cand if r["fate"] != "unresolved" and r["fate estimate"][1] >= r["need"]]
    return {"below the need at the reference, nothing pending": len(cand), "returned": len(met), "met": bool(met),
            "lakes": [{"id": r["id"], "closed": r["closed"], "other stocking read": r["other stocking read"]}
                      for r in met]}


def reports(table):
    """What no verdict reads: the lakes out and why, the fates by route (the years taken out) and by reference
    year, the surveys set aside, the lakes above the need and below the point with the recorded draw, the
    recorded draw at the reference below the need and above it (T1's lakes are driven below by the draw;
    renewal lost to another cause needs no draw), and the references with a creel survey."""
    inn = [r for r in table if "out" not in r]
    outs = {}
    for r in table:
        if "out" in r:
            key = r["out"].split(":")[0]
            outs[key] = outs.get(key, 0) + 1
    fates = ("fell", "persisted", "unresolved")
    below = [r for r in inn if r["T1 predicts"] == "falls"]
    between = [r for r in inn if r["T1 predicts"] == "persists" and r["below the point with the recorded draw"]]
    by_route = {}
    for r in below:
        route = re.sub(r" (in|by) \d{4}", "", r["fate by"])
        by_route.setdefault(route, [0, 0, 0])[fates.index(r["fate"])] += 1
    above = [r for r in inn if r["T1 predicts"] == "persists"]

    def draw(rs):
        v = sorted(r["h"] / r["x"] for r in rs if r["h"] > 0 and r["x"] > 0)
        return {"references with a recorded draw": len(v), "median per adult": round(v[len(v) // 2], 4) if v else None}
    by_year = {}
    for r in below:
        by_year.setdefault(r["ref"], [0, 0, 0])[fates.index(r["fate"])] += 1
    aside = [r["set aside, renewal pending"]["fate"] for r in table if "set aside, renewal pending" in r]
    return {"in the test": len(inn), "out, by reason": outs,
            "below the need, by the fate's route: fell / persisted / unresolved": by_route,
            "below the need, by reference year: fell / persisted / unresolved": dict(sorted(by_year.items())),
            "below the need, by the lag's surveys: fell / persisted / unresolved": {
                side: [sum(1 for r in below if (r["pending at the reference"] is None) == (side == "every year surveyed")
                           and r["fate"] == s) for s in fates] for side in ("every year surveyed", "a year unread")},
            "set aside, wholly below the need with renewal pending: fell / persisted / unresolved":
                [aside.count(s) for s in fates],
            "above the need, below the point with the recorded draw: fell / persisted / unresolved":
                [sum(r["fate"] == s for r in between) for s in fates],
            "the recorded draw at the reference, per adult, below and above the need": {
                "below": draw(below), "above": draw(above)},
            "references with a creel survey": sum(1 for r in inn if r["creel at the reference"])}


def renewal_below(lakes, nd, first=CUTOFF + 1, floor=FLOOR, labels=True):
    """What T1's second Forbids reads, reported beside the verdicts (a dependent active while its condition
    stood below its need): the lake-years from `first` with a spring estimate wholly below the need and a fall
    survey that year, the label natural and no stocking recorded in it or the STOCK_BEFORE years before; how
    many reached the floor, how many the need's fit expects (the sum of its chances at the estimates) and the
    exact chance, under the fit, of so many or more. A need that fell after the cutoff shows here: lakes below
    it renewing more than the fit allows, whose surveys V1 sets aside."""
    if nd.get("need") is None:
        return None
    a, b, y = nd["a"], nd["b"], nd["need"]
    ps, k = [], 0
    for lk in lakes:
        for yr, (est, lo, hi) in sorted(lk["adults"].items()):
            if (yr >= first and hi < y and yr in lk["age0"] and est > 0 and natural_at(lk, yr, labels)
                    and not stocked_in(lk, yr - STOCK_BEFORE, yr)):
                t = a + b * math.log(est)
                ps.append(0.0 if t < -700 else 1 / (1 + math.exp(-t)))
                k += reached(lk["age0"][yr], floor)
    dist = [1.0]
    for p in ps:
        dist = [(dist[j] if j < len(dist) else 0.0) * (1 - p) + (dist[j - 1] * p if j else 0.0) for j in range(len(dist) + 1)]
    return {"lake-years": len(ps), "reached the floor": k, "the fit expects": round(sum(ps), 2),
            "chance of so many or more under the fit": round(sum(dist[k:]), 6)}


def read(lakes, need_, first=FIRST_REF, last=None, floor=FLOOR, labels=True, label_alone=False):
    table = rows(lakes, need_, first, last, floor, labels, label_alone)
    second = v2(table)
    return {"V1": v1(table, second), "V2": second, "reports": reports(table), "rows": table}
