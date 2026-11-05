"""T1R's rules (DESIGN.md, sections 4 to 7): whether natural renewal returns in lakes stocked back above the need
T1N fits. Pure functions on lakes as T1N's reader builds them (t1n.py's docstring), on the years with stocking
recorded, and on the marked shares of a stocked year's catch where they are recorded; nothing here reads a file
or a value of the archive, save T1N's freeze file, to check that the T1N files T1R runs are the bytes T1N's
freeze names.

T1N's need is used as T1N fits it: `t1n.need` on the same lakes, never refitted here. Its fit reads lake-years
with no stocking recorded in them or the five years before; every year T1R reads above the need has stocking
recorded in T1N's records in the five years before it, so the need was fitted on none of them (DESIGN.md,
section 4). A lake's year below the need, and its low survey, may be years the fit reads.
Standard library only.
"""

import hashlib
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
T1N_DIR = HERE.parent / "need-measured-in-advance"
IMPORTED = ("t1n.py", "reader.py", "run.py")   # T1N's files T1R runs, at the hashes T1N's base link names


def imported_hashes(t1n_dir=T1N_DIR):
    """The sha-256 T1N's base link (its FROZEN.sha256) gives each file T1R imports. T1N's addenda may change only
    its layout and its dry run's record (its DESIGN.md, section 14), so the base link's hashes for these stand."""
    link = t1n_dir / "FROZEN.sha256"
    if not link.exists():
        raise SystemExit("T1N's FROZEN.sha256 is not there: T1R runs only T1N's frozen rules")
    names = {p: h for h, p in (line.split() for line in link.read_text().splitlines() if line.strip())}
    return {f: names[f"experiments/{t1n_dir.name}/{f}"] for f in IMPORTED}


def check_imported(t1n_dir=T1N_DIR):
    """Each T1N file T1R imports is the bytes T1N's freeze names; refuses otherwise."""
    for f, h in imported_hashes(t1n_dir).items():
        if hashlib.sha256((t1n_dir / f).read_bytes()).hexdigest() != h:
            raise SystemExit(f"T1N's {f} is not the file T1N's freeze names: T1R runs only T1N's frozen rules")


check_imported()
sys.path.insert(0, str(T1N_DIR))
import t1n                               # noqa: E402

ALPHA = 0.05
N_MIN = 10                    # lakes read, below which V1 is not decided
WINDOW = t1n.STOCK_BEFORE     # a year read has stocking recorded in the WINDOW years before it, from the low survey on
GAP = 2                       # a year read or below has no stocking recorded in it or the year before: a fish stocked
                              # earlier is two or more by that fall, past a stocking's first-year effects
JOIN = 3                      # stocked fingerlings can join the adults counted from three years on (walleye mature
                              # at three to five), so a lake's first fall after its low survey is read before then
FLOOR = t1n.FLOOR
ROSE = "Renewal rose with the level"
SHORT = "Renewal fell short of the fit at the levels restored"
ABATED = "what held their renewal down ended by the year read"
SUPPRESSED = "stocking suppresses natural renewal"
OWN_NEEDS = "their own needs lie above the common one"
YOUNG = "the adults restored count stocked fish not yet spawning"


def chance(nd, x):
    """The need's fit (T1N's): the chance that a year's renewal reaches the floor at x adults per acre; none at
    no adults."""
    if x <= 0:
        return 0.0
    t = nd["a"] + nd["b"] * math.log(x)
    return 0.0 if t < -700 else 1.0 if t > 700 else 1 / (1 + math.exp(-t))


def stocked_years(lk, dated=None):
    """The years with walleye stocking recorded: WDNR's database and, where read, the other records (T1N's
    `stocked` and `other`), and, where the stocking files give a date, the year of the date too, so that a
    stocking filed under another year's entry counts in both years (DESIGN.md, section 5)."""
    return set(lk["stocked"]) | set(lk.get("other") or ()) | set((dated or {}).get(lk["id"], ()))


def wholly_below(interval, need_):
    """A spring estimate whose 95% interval lies wholly below the need: a positive estimate, an upper bound above
    no adults and below the need."""
    est, lo, hi = interval
    return est > 0 and 0 < hi < need_


def wholly_above(interval, need_):
    """A spring estimate whose 95% interval lies wholly above the need: a positive estimate, a lower bound at the
    need or above it."""
    est, lo, hi = interval
    return est > 0 and lo >= need_


def natural_catch(lk, t, stocked, marks=None, gap=1):
    """The fall age-0 per mile of the lake's own spawning in year t, None where it cannot be read. With `gap` at
    GAP (the year read), no stocking may be recorded in the year before t: a fish stocked earlier is two or more
    by that fall. In t itself, no stocking may be recorded, or, where `marks` (the second route) records t's
    stocking as marked, the catch is read times its unmarked share."""
    if t not in lk["age0"] or any((t - j) in stocked for j in range(1, gap)):
        return None
    if t not in stocked:
        return lk["age0"][t]
    share = (marks or {}).get(lk["id"], {}).get(t)
    return None if share is None else lk["age0"][t] * share


def scope(lk, need_, stocked, marks=None, made=None):
    """The lake's low survey, its year read and its year below the need (DESIGN.md, section 5), and the reason it
    is out. The low survey is its first spring estimate wholly below the need. Stocking is recorded from that
    year on, and no spring estimate wholly above the need comes before the first such stocking: for a lake whose
    stockings' dates are all read, the first made from that year on, by `made`, the years of its dates and of its
    other records (round 2's R-21); otherwise the first recorded. The year read is
    its first year after the low survey wholly above the need, with stocking recorded in T1N's records from the
    low survey's year within the WINDOW years before it, so that T1N's fit never reads it, none recorded in it or
    the year before, and a fall survey. The year below is its last year from the low survey to the year read
    wholly below the need, with no stocking recorded in it or the year before (round 2's R-17 and R-18: both
    years compared stand apart from a stocking's first-year effects) and a fall survey; None where it has none.
    Returns (low survey, year read, year below, why out)."""
    A = lk["adults"]
    years = sorted(A)
    low = next((b for b in years if wholly_below(A[b], need_)), None)
    if low is None:
        return None, None, None, "never wholly below the need"
    after = sorted(s for s in stocked if s >= low)
    if not after:
        return low, None, None, "no stocking recorded from its survey below the need"
    first = min((s for s in made if s >= low), default=after[0]) if made is not None else after[0]
    if any(low < t <= first and wholly_above(A[t], need_) for t in years):
        return low, None, None, "back above the need before it was stocked"
    read = next((t for t in years if t > low and wholly_above(A[t], need_)
                 and t1n.stocked_in(lk, max(low, t - WINDOW), t - 1)
                 and natural_catch(lk, t, stocked, marks, GAP) is not None), None)
    if read is None:
        return low, None, None, ("no year read: none wholly above the need, stocked in the five years before, not "
                                 "in it or the year before, and surveyed")
    under = [b for b in years if low <= b < read and wholly_below(A[b], need_)
             and natural_catch(lk, b, stocked, None, GAP) is not None]
    return low, read, (under[-1] if under else None), None


def first_fall(lk, need_, stocked, low, read):
    """The lake's first fall after its low survey whose renewal no spring estimate chose (reported only, DESIGN.md,
    sections 5 and 7): a fall survey with no stocking recorded that year or the year before and no spring
    estimate of its own, while every spring estimate since the low survey lies wholly below the need, and before
    any stocking from JOIN - 1 years before the low survey on can have joined the adults counted, JOIN years after
    it. Its level is presumed below the need, not measured. The low survey is chosen as the lake's first estimate
    wholly below the need, so a year whose conditions lower both its count and its age-0 is chosen more often; a
    year chosen by no estimate is not. None where the lake has none before its year read."""
    A = lk["adults"]
    joins = [s + JOIN for s in stocked if s >= low - (JOIN - 1)]
    for b in range(low + 1, read):
        if any(low < t < b and not wholly_below(A[t], need_) for t in A) or (joins and b >= min(joins)):
            return None
        if b not in A and natural_catch(lk, b, stocked, None, GAP) is not None:
            return b
    return None


def own_level(lk, low, stocked, floor=FLOOR):
    """The median spring level of the lake's own years before its low survey with no stocking recorded in them
    and a fall survey that reached the floor, the upper of the middle two where they are even: a level at which
    the lake renewed before it fell (DESIGN.md, section 7, its own needs). None where it has none."""
    xs = sorted(lk["adults"][y][0] for y in lk["adults"]
                if y < low and y not in stocked and y in lk["age0"] and t1n.reached(lk["age0"][y], floor))
    return xs[len(xs) // 2] if xs else None


def rows(lakes, nd, dated=None, floor=FLOOR, first=None, marks=None, undated=()):
    """One row a lake: out, with the reason, or its low survey, its year read and year below, whether each
    renewed, and the need's fit at the level restored, at the bound of its interval that errs toward not
    deciding (its lower bound: a year read is chosen for an interval wholly above the need, so its estimate runs
    high), and, reported, at its estimate and at the low survey's upper bound (DESIGN.md, section 6). `first`
    keeps only the lakes whose year read is from that year on (the years after 2012, reported); `marks` adds the
    second route's years; `undated` names the lakes whose stockings' dates could not all be read."""
    out = []
    for lk in lakes:
        stocked = stocked_years(lk, dated)
        row = {"id": lk["id"], "closed": lk.get("closed"), "other stocking read": lk.get("other") is not None,
               "dated": dated is not None and lk["id"] not in undated}
        made = (set((dated or {}).get(lk["id"], ())) | set(lk.get("other") or ())) if row["dated"] else None
        low, read, under, why = scope(lk, nd["need"], stocked, marks, made)
        if first is not None and not why and read < first:
            why = f"its year read before {first}"
        if why:
            out.append({**row, "out": why})
            continue
        A = lk["adults"]
        own = own_level(lk, low, stocked, floor)
        fall = first_fall(lk, nd["need"], stocked, low, read)
        row.update({"low survey": low, "year read": read, "year below": under, "level read": A[read][0],
                    "renewed": t1n.reached(natural_catch(lk, read, stocked, marks, GAP), floor),
                    "renewed below": None if under is None else t1n.reached(natural_catch(lk, under, stocked, None, GAP), floor),
                    "first fall after the low survey": fall,
                    "renewed in it": None if fall is None else t1n.reached(natural_catch(lk, fall, stocked, None, GAP), floor),
                    "marked year read": read in stocked,
                    "years since stocking": read - max(s for s in stocked if s < read),
                    "at the level restored": chance(nd, A[read][1]),
                    "at the level restored, at the estimate": chance(nd, A[read][0]),
                    "at its level below the need, by the fit": chance(nd, A[low][2]),
                    "own renewing level": own,
                    "restored to its own level": own is not None and A[read][0] >= own})
        out.append(row)
    return out


def tails(ps, k):
    """The exact chances that a sum of independent trials with chances ps is at most k, and at least k."""
    dist = [1.0]
    for p in ps:
        dist = [(dist[j] if j < len(dist) else 0.0) * (1 - p) + (dist[j - 1] * p if j else 0.0) for j in range(len(dist) + 1)]
    return min(1.0, sum(dist[:k + 1])), min(1.0, sum(dist[k:]))


def decide(table):
    """V1's decision on the lakes read (DESIGN.md, section 7): (outcome, its line's first part, numbers). The rise
    is shown within the lakes read in a year below the need too, by an exact sign test at ALPHA: more renewed
    above the need and not below it than below it and not above. The shortfall is shown where at most k of the
    lakes read renewing has a chance of at most ALPHA at the levels restored, at the intervals' lower bounds."""
    inn = [r for r in table if "out" not in r]
    n, k = len(inn), sum(r["renewed"] for r in inn)
    paired = [r for r in inn if r["renewed below"] is not None]
    up = sum(1 for r in paired if r["renewed"] and not r["renewed below"])
    down = sum(1 for r in paired if r["renewed below"] and not r["renewed"])
    e = [r["at the level restored"] for r in inn]
    e_est = [r["at the level restored, at the estimate"] for r in inn]
    q = [r["at its level below the need, by the fit"] for r in inn]
    nums = {"lakes read": n, "renewed": k, "read in a year below the need too": len(paired),
            "renewed above the need and not below": up, "renewed below the need and not above": down,
            "expected at the levels restored, at the lower bounds": round(sum(e), 2),
            "expected at the levels restored, at the estimates": round(sum(e_est), 2),
            "expected at their levels below the need, by the fit (reported)": round(sum(q), 2)}
    head = f"of {n} lakes stocked back above the need, {k} renewed at the floor in a year read"
    if n < N_MIN:
        return "not decided", f"not decided: {head}; fewer than {N_MIN} lakes read", nums
    rise = float(t1n.tail_half(up + down, up))
    short, _ = tails(e, k)
    nums.update({"p, the rise within the lakes": rise, "p, the shortfall at the lower bounds": short})
    within = (f"of the {len(paired)} also read in a year below the need, {up} renewed above it and not below and "
              f"{down} below it and not above (p = {rise:.3g})")
    if rise <= ALPHA:
        return ROSE, (f"{ROSE}: {head}; {within}, more often above; the need's fit expecting {sum(e_est):.1f} at the "
                      f"levels restored ({sum(e):.1f} at their intervals' lower bounds)"), nums
    if short <= ALPHA:
        return SHORT, (f"{SHORT}: {head}, fewer than the need's fit expects even at the lower bounds of the "
                          f"levels restored ({sum(e):.1f} expected, p = {short:.3g}); {within}, not shown more often "
                          f"above"), nums
    return "not decided", (f"not decided: {head}; {within}, not shown more often above; and not shown fewer than the "
                           f"need's fit expects at the lower bounds of the levels restored ({sum(e):.1f} expected, "
                           f"p = {short:.3g})"), nums


def v1(table, own=None, closed=None):
    """The verdict (primary), its line in full, decided before any value is read (DESIGN.md, section 7).
    - Renewal rose with the level: within the lakes read in a year below the need too, more renewed above it
      and not below than the reverse, by an exact sign test at ALPHA. Read as renewal following the level in
      some of these lakes at least, not
      lost to another cause in all of them; the line gives what the need's fit expects at the levels restored,
      and does not say what share follows it. It carries what held their renewal down ending by the year read,
      always; unrecorded stocking where the other stocking records were not read, or a stocking's date could not
      be read, for a lake that renewed above the need and not below; and connected waters where such a lake is
      not a recorded seepage lake and the closed lakes alone (`closed`, the same rule on them) do not also show
      the rise.
    - Renewal fell short of the fit at the levels restored: fewer renewed than the fit expects even at the lower
      bounds of the levels restored, by an exact test at ALPHA, and the rise not shown, whichever way its counts
      lean. Read as renewal short of the level's in some of these lakes at least, as where it is lost to another
      cause; it carries stocking suppressing natural renewal, the lakes'
      own needs lying above the common one, and the adults restored counting stocked fish not yet spawning,
      always. The lakes restored to a level they renewed at before (`own`) are reported, read before the
      clauses: the fit they are compared with is the common one, so a shortfall there does not rule their own
      needs out."""
    outcome, line, nums = decide(table)
    out = {"outcome": outcome, **nums}
    inn = [r for r in table if "out" not in r]
    if closed is not None:
        out["the closed lakes alone, read before the clauses"] = closed
    if own is not None:
        out["the lakes restored to their own renewing level alone, read before the clauses"] = own
    if outcome == ROSE:
        unless = []
        rose = [r for r in inn if r["renewed"] and r["renewed below"] is False]
        if any(not r["other stocking read"] or not r["dated"] for r in rose):
            unless.append("unrecorded stocking")
        if any(r["closed"] is not True for r in rose) and (closed is None or not closed.startswith(ROSE)):
            unless.append("connected waters")
        verdict = (f"{line}; renewal read as following the level in some of these lakes at least, not lost to another "
                   "cause in all of them, unless " + " or ".join(unless + [ABATED]))
    elif outcome == SHORT:
        verdict = (f"{line}; renewal read as short of the level's in some of these lakes at least, as where it is lost "
                   f"to another cause, unless {SUPPRESSED}, {OWN_NEEDS} or {YOUNG}")
    else:
        verdict = line
    return {**out, "verdict": verdict}


def reports(table):
    """Ruling on nothing: the lakes out by reason; renewal in the years read by the years since the last stocking,
    which a suppression by stocked fish would lower nearest the stocking; the lakes read with no year below the
    need, and how they renewed; and the rise read with each lake's first fall after its low survey in place of its
    year below, a year no spring estimate chose (`first_fall`), by the same exact sign test."""
    outs, by_gap = {}, {}
    for r in table:
        if "out" in r:
            outs[r["out"]] = outs.get(r["out"], 0) + 1
            continue
        cell = by_gap.setdefault(r["years since stocking"], [0, 0])
        cell[0] += r["renewed"]
        cell[1] += 1
    single = [r for r in table if "out" not in r and r["renewed below"] is None]
    fall = [r for r in table if "out" not in r and r["renewed in it"] is not None]
    up = sum(1 for r in fall if r["renewed"] and not r["renewed in it"])
    down = sum(1 for r in fall if r["renewed in it"] and not r["renewed"])
    return {"lakes out, by reason": outs,
            "the rise with the first fall after the low survey as the year below: lakes, renewed above the need and "
            "not in that fall, in that fall and not above, p": [len(fall), up, down, float(t1n.tail_half(up + down, up))],
            "years read by years since the last stocking: renewed, read": {str(g): by_gap[g] for g in sorted(by_gap)},
            "lakes read with no year below the need: renewed, read": [sum(r["renewed"] for r in single), len(single)]}


def read(lakes, nd, dated=None, floor=FLOOR, marks=None, undated=()):
    """V1, its readings and the reports on lakes with a need (T1N's `need` on them), as run.py and the dry run
    read them. Reported beside V1: the years after 2012 alone, and, where marked shares are recorded, V1 with the
    second route's years added."""
    table = rows(lakes, nd, dated, floor, undated=undated)
    own = decide([r for r in table if "out" not in r and r["restored to its own level"]])[1]
    closed = decide([r for r in table if "out" not in r and r["closed"] is True])[1]
    out = {"V1": v1(table, own, closed),
           "the years after 2012 alone (reported)":
               v1(rows(lakes, nd, dated, floor, first=t1n.CUTOFF + 1, undated=undated))["verdict"],
           "reports": reports(table), "rows": table}
    if marks:
        out["with the marked years added (reported)"] = v1(rows(lakes, nd, dated, floor, marks=marks,
                                                               undated=undated))["verdict"]
    return out
