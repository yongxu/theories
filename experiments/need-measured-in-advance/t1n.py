"""T1N's rules (DESIGN.md, sections 4 to 7): the need, the scope, the reference and the fate, the predicted
point, and the verdicts. Pure functions on lakes; nothing here reads a file or a value of the archive.

A lake, as reader.py builds it from the recorders' tables:
    id        the recorders' water body code (WBIC)
    acres     the lake's area
    label     {year: the recorders' primary recruitment source for the lake that year}
    adults    {year: (estimate, lower, upper)}, spring adult walleye per acre and its 95% interval
    age0      {year: fall age-0 walleye per mile of shoreline}
    harvest   {year: recorded harvest of adult walleye per acre}: tribal harvest, and angling where a
              creel survey ran that year
    creel     the years with a creel survey
    stocked   the years with recorded walleye stocking, of any size (WDNR's database)
    other     the years with fry, tribal or private walleye stocking (R5b), or None where those records
              were not read
    closed    True for a seepage lake (no inlet or outlet), False for another recorded type, None where no
              type is recorded
Standard library only.
"""

import math
from fractions import Fraction

CUTOFF = 2012                 # the need's fit (branch B) reads years up to and including this
FIRST_REF = 2013              # a reference survey's first year under branch B; its last is the archive's
LAST_REF = 2020               # last spring estimate's year less GAP_MIN, read at the layout (the dry run's: 2020)
GAP_MIN, GAP_MAX = 3, 10      # years from the reference survey to the fate's
STOCK_BEFORE = 5              # years before the reference whose recorded stocking takes a lake out of scope
RECRUIT_LAG = 3               # years from a fall's age-0 to the spring adults they join: renewal pending
FLOOR = 1.0                   # fall age-0 per mile below which a year's renewal is read as stopped
FLOORS_REPORTED = (0.0, 1.0, 5.0)   # the floors V1 is reported at (at 0, any age-0 caught); FLOOR decides it


def reached(r, floor):
    """A year's renewal reached the floor: at least `floor` age-0 per mile, or, at a floor of 0, any caught."""
    return r > 0 if floor == 0 else r >= floor
NR = "natural"                # the recorders' label for natural recruitment, as the layout maps it (reader.py)
N_MIN = 10                    # resolved lakes where T1 and the null differ, below which V1 is not decided
N_REFUTE = 20                 # the resolved lakes the letter's refutation needs (DESIGN.md, section 7)
ALPHA = Fraction(5, 100)
PAIRS_MIN, LAKES_MIN = 200, 30     # branch B's fit: at least these pairs, from at least these lakes
RIDGE = 1e-3                  # branch B's penalty on the logistic coefficients, for a finite fit under separation
BRANCH_A_LAKES = 20           # lakes of the primary scope branch A must give a curve for, else branch B for all


def tail_half(n, k):
    """The exact chance that a fair coin gives at least k heads in n tosses."""
    return Fraction(sum(math.comb(n, j) for j in range(k, n + 1)), 2 ** n)


def critical(n, alpha=ALPHA):
    """The least k with tail_half(n, k) <= alpha, or None where none is."""
    return next((k for k in range(n + 1) if tail_half(n, k) <= alpha), None)


# --- the need ---------------------------------------------------------------------------------------------

def pairs(lakes, last=CUTOFF, floor=FLOOR):
    """Branch B's data: for every lake and year up to `last` with both a spring adult estimate and a fall
    age-0 survey, (adults per acre, renewal at or above the floor that year)."""
    out = []
    for lk in lakes:
        for yr, (est, lo, hi) in sorted(lk["adults"].items()):
            if yr <= last and yr in lk["age0"] and est > 0:
                out.append((lk["id"], est, reached(lk["age0"][yr], floor)))
    return out


def logistic(xs, zs, ridge=RIDGE, iters=100):
    """The penalized maximum-likelihood fit of P(z) = 1 / (1 + exp(-(a + b ln x))), by Newton's method, the
    penalty ridge (a^2 + b^2) / 2 keeping the fit finite where the classes are separated. Returns (a, b) or
    None where it does not converge."""
    us = [math.log(x) for x in xs]
    a = b = 0.0
    for _ in range(iters):
        ga, gb = -ridge * a, -ridge * b
        haa, hab, hbb = ridge, 0.0, ridge
        for u, z in zip(us, zs):
            t = a + b * u
            p = 1 / (1 + math.exp(-t)) if t > -700 else 0.0
            w = p * (1 - p)
            ga += (z - p)
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
            return a, b
    return None


def need_branch_b(lakes, last=CUTOFF, floor=FLOOR):
    """The need from every lake's years up to `last`: the adults per acre at which the fitted chance that a
    year's renewal reaches the floor is one half. One need for every lake, so no lake's need reads its own
    later series. None, with the reason, where the pairs are too few or the fit finds no need (renewal
    not rising with the level)."""
    ps = pairs(lakes, last, floor)
    lakes_in = len({i for i, _, _ in ps})
    out = {"branch": "B", "pairs": len(ps), "lakes": lakes_in, "last year": last, "floor": floor}
    if len(ps) < PAIRS_MIN or lakes_in < LAKES_MIN:
        return {**out, "need": None, "reason": f"too few pairs: {len(ps)} from {lakes_in} lakes"}
    fit = logistic([x for _, x, _ in ps], [1 if z else 0 for _, _, z in ps])
    if fit is None:
        return {**out, "need": None, "reason": "the fit did not converge"}
    a, b = fit
    if b <= 0:
        return {**out, "need": None, "reason": "no need: renewal does not rise with the level", "a": a, "b": b}
    return {**out, "need": math.exp(-a / b), "a": a, "b": b}


CURVES = {
    # the forms branch A can read a published stock-recruitment curve in (DESIGN.md, section 4)
    "bh-q": lambda s, p: p["alpha"] * s ** p["q"] / (1 + p["beta"] * s ** p["q"]),
    "ricker-q": lambda s, p: p["alpha"] * s ** p["q"] * math.exp(-p["beta"] * s),
}


def need_branch_a(form, params, floor=FLOOR, top=100.0):
    """A lake's need from its published curve: the least adults per acre, up to `top`, at which the curve's
    recruitment reaches the floor, by bisection on the curve's rising part near zero. None where the curve
    stays below the floor up to `top`."""
    f = CURVES[form]
    lo, hi = 1e-9, top
    if f(hi, params) < floor:
        grid = [top * k / 1000 for k in range(1, 1001)]
        hits = [s for s in grid if f(s, params) >= floor]
        if not hits:
            return None
        hi = hits[0]
    if f(lo, params) >= floor:
        return 0.0
    for _ in range(200):
        mid = (lo + hi) / 2
        if f(mid, params) >= floor:
            hi = mid
        else:
            lo = mid
    return hi


# --- the scope, the reference and the fate --------------------------------------------------------------

def candidates(lk, first, last):
    """Each spring estimate in [first, last] with a later one GAP_MIN to GAP_MAX years after it: (the
    estimate's year, the first such later year), in order."""
    years = sorted(lk["adults"])
    out = []
    for r in years:
        if first <= r <= last:
            later = [f for f in years if GAP_MIN <= f - r <= GAP_MAX]
            if later:
                out.append((r, later[0]))
    return out


def in_scope(lk, ref):
    """The recorders' own fields keep the lake at its reference: their label says natural recruitment there,
    and no walleye stocking is recorded in the STOCK_BEFORE years before it or in its year, so the level read
    is not one stocked fish make. Returns the reason it is out, or None."""
    if lk["label"].get(ref) != NR:
        return f"label at the reference: {lk['label'].get(ref)!r}"
    stocked = sorted(s for s in lk["stocked"] | (lk.get("other") or set()) if ref - STOCK_BEFORE <= s <= ref)
    if stocked:
        return f"stocking recorded before the reference: {stocked}"
    return None


def pending(lk, ref, floor=FLOOR):
    """Renewal pending at the reference: an age-0 survey at or above the floor in the RECRUIT_LAG years
    before it, whose fish join the adults within the fate's horizon. T1's regime has no lag. V1 reads every
    lake below the need, pending or not, and reports the two apart; the single-lake form reads only lakes
    with none pending, where a return is renewal from below the need. Returns the reason, or None where
    none is pending."""
    years = [t for t in range(ref - RECRUIT_LAG, ref) if t in lk["age0"]]
    if not years:
        return "renewal unread: no age-0 survey in the years before the reference"
    up = [t for t in years if reached(lk["age0"][t], floor)]
    if up:
        return f"renewal pending: age-0 at or above the floor in {up}"
    return None


def fate_of(lk, ref, fate, need, label_alone=False):
    """The lake's fate between its reference and the fate's survey. Where the recorders' label leaves
    natural recruitment at a survey after the reference up to the fate's, the label alone decides nothing:
    fell only where a recorded fall goes with it (the fate's interval below the need, or an estimate after
    the reference whose upper bound is below the reference's lower bound), unresolved otherwise, since what
    persists may be stocked fish. (label_alone reads the label's change as a fall by itself: the reading set
    aside, which the dry run reports beside.) Unresolved where stocking is recorded after the reference with
    the label kept, in WDNR's database or in the other stocking records: giving from beyond. Otherwise by the
    fate's estimate against the need: fell where its upper bound is below the need, persisted where its
    lower bound is at or above it, unresolved where its interval holds the need. Returns (fate, how)."""
    later = sorted(t for t in lk["label"] if ref < t <= fate)
    left = [t for t in later if lk["label"][t] != NR]
    est, lo, hi = lk["adults"][fate]
    if left:
        if label_alone:
            return "fell", f"the label left natural recruitment in {left[0]}"
        lo_ref = lk["adults"][ref][1]
        drops = [t for t in sorted(lk["adults"]) if ref < t <= fate and lk["adults"][t][2] < lo_ref]
        if hi < need or drops:
            return "fell", f"the label left natural recruitment in {left[0]}, with a recorded fall"
        return "unresolved", f"the label left natural recruitment in {left[0]}, with no recorded fall"
    stocked = sorted(s for s in lk["stocked"] | (lk.get("other") or set()) if ref < s <= fate)
    if stocked:
        return "unresolved", f"stocking recorded in {stocked}, the label kept"
    if hi < need:
        return "fell", "the estimate's interval below the need"
    if lo >= need:
        return "persisted", "the estimate's interval at or above the need"
    return "unresolved", "the estimate's interval holds the need"


def rows(lakes, needs, first=FIRST_REF, last=LAST_REF, floor=FLOOR, label_alone=False):
    """One row a lake. Its reference is its first candidate at which T1 predicts a fall (the level below
    the need, where renewal stops under any draw), in scope; failing that, its first candidate in scope at
    which T1 predicts persistence. The choice reads the reference's level and
    the need, never a later value. The row gives the reference, the recorded draw, the need, the point with
    the recorded draw (reported), both classifiers' predictions and the fate; or the reasons it is out."""
    out = []
    for lk in lakes:
        row = {"id": lk["id"]}
        cands = candidates(lk, first, last)
        y = needs.get(lk["id"])
        if not cands:
            out.append({**row, "out": "no reference survey with a later one"})
            continue
        if y is None:
            out.append({**row, "out": "no need"})
            continue
        chosen, why_not = None, []
        for want_fall in (True, False):
            for r, f in cands:
                x, lo, hi = lk["adults"][r]
                h = lk["harvest"].get(r, 0.0)
                falls = x < y
                if falls != want_fall:
                    continue
                why = in_scope(lk, r)
                if why is None:
                    chosen = (r, f)
                    break
                why_not.append(why)
            if chosen:
                break
        if chosen is None:
            out.append({**row, "out": why_not[0] if why_not else "no reference survey in scope"})
            continue
        r, f = chosen
        x, lo, hi = lk["adults"][r]
        h = lk["harvest"].get(r, 0.0)
        row.update({"ref": r, "fate year": f, "x": x, "x interval": [lo, hi], "h": h,
                    "creel at the reference": r in lk["creel"], "need": y,
                    "T1 predicts": "falls" if x < y else "persists", "null predicts": "persists",
                    "point with the recorded draw": y + h, "below the point with the recorded draw": x < y + h,
                    "fate estimate": list(lk["adults"][f]), "below the need at the reference": hi < y,
                    "pending at the reference": pending(lk, r, floor)})
        row["fate"], row["fate by"] = fate_of(lk, r, f, y, label_alone)
        row["closed"] = lk.get("closed")
        row["other stocking read"] = lk.get("other") is not None
        out.append(row)
    return out


# --- the verdicts ----------------------------------------------------------------------------------------

def decide(res):
    """V1's decision on resolved rows of lakes below the need: (verdict, n, k, critical)."""
    n, k = len(res), sum(r["fate"] == "fell" for r in res)
    c = critical(n) if n else None
    if n < N_MIN:
        return f"not decided: {n} resolved lakes where T1 and the null differ, fewer than {N_MIN}", n, k, c
    if k >= c:
        return "supported", n, k, c
    if k <= n - c:
        return "refuted: the fates separated no better than by the null, on the null's side at 0.05", n, k, c
    if 2 * k <= n and n >= N_REFUTE:
        return "refuted: the fates separated no better than by the null, at most half fell", n, k, c
    if 2 * k <= n:
        return f"not decided: at most half fell, but {n} resolved lakes are fewer than {N_REFUTE}", n, k, c
    return "not decided", n, k, c


def v1(table):
    """The separation (primary): lakes below the need against lakes above it. T1 predicts a fall below the
    need, where renewal stops, under any draw, so whether the draw stood does not enter; the null, fixed in
    advance, is T1's classifier with no need (y = 0), which predicts no fall at any level, as MQ2's null
    without a need predicts survival. The two differ exactly on the lakes below the need. Among those with
    resolved fates, an exact one-sided sign test (McNemar's on the discordant lakes): supported where at
    least the critical count c fell. Refuted, the fates separated no better than by the null, where at most
    n - c fell, so few that the same test at 0.05 puts them on the null's side, or, by the home's letter,
    where at most half fell and at least N_REFUTE are resolved. Not decided where neither, or where fewer
    than N_MIN are resolved.

    A refutation two confounds could make on their own is qualified, decided here before any value is read
    (DESIGN.md, section 7): fish from connected waters, where a lake that persisted is not a recorded seepage
    lake and the closed lakes alone do not refute; and unrecorded stocking, where the records of fry, tribal
    and private stocking were not read for a lake that persisted. It then reads "refuted unless ..."."""
    disc = [r for r in table if "out" not in r and r["T1 predicts"] == "falls" and r["null predicts"] == "persists"]
    res = [r for r in disc if r["fate"] != "unresolved"]
    verdict, n, k, c = decide(res)
    out = {"discordant": len(disc), "resolved": n, "fell": k, "critical": c,
           "reported apart, by renewal pending at the reference (fell, resolved)": {
               side: (sum(r["fate"] == "fell" for r in res if (r["pending at the reference"] is None) == (side == "none")),
                      sum(1 for r in res if (r["pending at the reference"] is None) == (side == "none")))
               for side in ("none", "pending or unread")}}
    if verdict == "supported":
        out["p"] = float(tail_half(n, k))
    if verdict.startswith("refuted"):
        out["p"] = float(tail_half(n, n - k)) if k <= n - c else None
        unless, kept = [], [r for r in res if r["fate"] == "persisted"]
        if any(r["closed"] is not True for r in kept):
            closed = decide([r for r in res if r["closed"] is True])[0]
            out["closed lakes alone"] = closed
            if not closed.startswith("refuted"):
                unless.append("connected waters")
        if any(not r["other stocking read"] for r in kept):
            unless.append("unrecorded stocking")
        if unless:
            verdict = "refuted unless " + " or ".join(unless) + ": " + verdict.split(": ", 1)[1]
    out["verdict"] = verdict
    return out


def v2(table):
    """The single-lake form (reported): lakes in scope standing below their need at the reference (the
    interval's upper bound below it), with no renewal pending, and persisting at the fate (the later
    interval's lower bound at or above it), which fate_of gives only with the recorders' natural-recruitment
    label at every survey between and no recorded stocking after the reference."""
    cand = [r for r in table if "out" not in r and r["below the need at the reference"]
            and r["pending at the reference"] is None]
    met = [r for r in cand if r["fate"] == "persisted"]
    return {"below the need at the reference": len(cand), "returned": len(met), "met": bool(met),
            "lakes": [{"id": r["id"], "closed": r["closed"], "other stocking read": r["other stocking read"]}
                      for r in met]}


def reports(table):
    """What no verdict reads: the lakes out and why, the concordant lakes' fates, the fates above the
    point (falls where T1 and the null both predicted persistence), and the draw's coverage."""
    inn = [r for r in table if "out" not in r]
    outs = {}
    for r in table:
        if "out" in r:
            key = r["out"].split(":")[0]
            outs[key] = outs.get(key, 0) + 1
    above = [r for r in inn if r["T1 predicts"] == "persists"]
    between = [r for r in above if r["below the point with the recorded draw"]]
    fates = ("fell", "persisted", "unresolved")
    return {"in the test": len(inn), "out, by reason": outs,
            "above the need: fell / persisted / unresolved": [sum(r["fate"] == s for r in above) for s in fates],
            "above the need, below the point with the recorded draw: fell / persisted / unresolved":
                [sum(r["fate"] == s for r in between) for s in fates],
            "references with a creel survey": sum(1 for r in inn if r["creel at the reference"])}


def read(lakes, needs, first=FIRST_REF, last=LAST_REF, floor=FLOOR, label_alone=False):
    table = rows(lakes, needs, first, last, floor, label_alone)
    return {"V1": v1(table), "V2": v2(table), "reports": reports(table), "rows": table}
