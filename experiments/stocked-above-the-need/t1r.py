"""T1R's rules (DESIGN.md, sections 4 to 7): whether natural renewal returns in lakes stocked back above the need
T1N fits. Pure functions on lakes as T1N's reader builds them (t1n.py's docstring), on the years with stocking
recorded, and on the marked shares of a stocked year's catch where they are recorded; nothing here reads a file
or a value of the archive, save T1N's freeze file, to check that the T1N files T1R runs are the bytes T1N's
freeze names.

T1N's need is used as T1N fits it: `t1n.need` on the same lakes, never refitted here. Its fit reads lake-years
with no stocking recorded in them or the five years before; every year T1R reads has stocking recorded in T1N's
records in the five years before it, so none of T1R's years is one the need was fitted on (DESIGN.md, section 4).
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
WINDOW = t1n.STOCK_BEFORE     # a year read has stocking recorded in the WINDOW years before it, after the low survey
SPAN = t1n.GAP_MAX            # a lake's years read lie within SPAN years of its first
M_READ = 1                    # and are its first M_READ such years: one a lake
FLOOR = t1n.FLOOR
ROSE = "Renewal rose with the level"
NOT_ROSE = "Renewal did not rise with the level"
ABATED = "the cause that stopped it ended when they were stocked"
SUPPRESSED = "stocking suppresses natural renewal"
OWN_NEEDS = "their own needs lie above the common one"


def chance(nd, x):
    """The need's fit (T1N's): the chance that a year's renewal reaches the floor at x adults per acre."""
    t = nd["a"] + nd["b"] * math.log(x)
    return 0.0 if t < -700 else 1.0 if t > 700 else 1 / (1 + math.exp(-t))


def stocked_years(lk, dated=None):
    """The years with walleye stocking recorded: WDNR's database and, where read, the other records (T1N's
    `stocked` and `other`), and, where the stocking files give a date, the year of the date too, so that a
    stocking filed under another year's entry counts in both years (DESIGN.md, section 5)."""
    return set(lk["stocked"]) | set(lk.get("other") or ()) | set((dated or {}).get(lk["id"], ()))


def natural_catch(lk, t, stocked, marks=None):
    """The fall age-0 per mile of the lake's own spawning in year t: the whole catch in a year with no stocking
    recorded, a fish stocked the year before being a yearling by that fall; in a stocked year, the catch times
    its recorded unmarked share where the year's stocking is recorded as marked (`marks`, the second route);
    None otherwise."""
    if t not in lk["age0"]:
        return None
    if t not in stocked:
        return lk["age0"][t]
    share = (marks or {}).get(lk["id"], {}).get(t)
    return None if share is None else lk["age0"][t] * share


def years_read(lk, need_, stocked, marks=None):
    """The lake's low survey and the years after it read for natural renewal (DESIGN.md, section 5). The low
    survey is its first spring estimate wholly below the need. A year read comes after it: the spring estimate
    wholly above the need; stocking recorded after the low survey within the WINDOW years before it in T1N's
    records, so that T1N's fit, which reads no year with stocking in it or the five before, never reads it; and a
    natural catch that year (natural_catch). The years read are the first M_READ such, within SPAN years of the
    first. Returns (low survey, years read, the reason none is read)."""
    years = sorted(lk["adults"])
    low = next((b for b in years if lk["adults"][b][0] > 0 and lk["adults"][b][2] < need_), None)
    if low is None:
        return None, [], "never wholly below the need"
    if not any(s > low for s in stocked):
        return low, [], "no stocking recorded after its survey below the need"
    read = []
    for t in years:
        est, lo, hi = lk["adults"][t]
        if t <= low or est <= 0 or lo < need_ or natural_catch(lk, t, stocked, marks) is None:
            continue
        if not t1n.stocked_in(lk, max(low + 1, t - WINDOW), t - 1):
            continue
        if read and t > read[0] + SPAN:
            break
        read.append(t)
        if len(read) == M_READ:
            break
    if not read:
        return low, [], "no year read: none wholly above the need, stocked before and not in it, and surveyed"
    return low, read, None


def own_level(lk, low, stocked, floor=FLOOR):
    """The median spring level of the lake's own years before its low survey with no stocking recorded in them
    and a fall survey that reached the floor: a level at which the lake renewed before it fell (DESIGN.md,
    section 7, its own needs). None where it has none."""
    xs = sorted(lk["adults"][y][0] for y in lk["adults"]
                if y < low and y not in stocked and y in lk["age0"] and t1n.reached(lk["age0"][y], floor))
    return xs[len(xs) // 2] if xs else None


def rows(lakes, nd, dated=None, floor=FLOOR, first=None, marks=None):
    """One row a lake: out, with the reason, or its low survey, the years read, where it renewed, and the chances
    the two readings give it of renewing in some year read: the need's fit at the levels restored, and the same
    fit at its own level below the need, as though renewal had stayed as it was there. Each is read at the bound
    of its interval that errs toward not deciding: a year read is chosen for an interval wholly above the need,
    so its estimate runs high, and the low survey for one wholly below, so its estimate runs low (DESIGN.md,
    section 6). `first` keeps only the years read from that year on (the years after 2012, reported); `marks`
    adds the second route's years."""
    out = []
    for lk in lakes:
        stocked = stocked_years(lk, dated)
        row = {"id": lk["id"], "closed": lk.get("closed"), "other stocking read": lk.get("other") is not None,
               "dated": dated is not None}
        low, read, why = years_read(lk, nd["need"], stocked, marks)
        if first is not None and not why:
            read = [t for t in read if t >= first]
            why = None if read else f"no year read from {first}"
        if why:
            out.append({**row, "out": why})
            continue
        x_low = lk["adults"][low][0]
        p = [chance(nd, lk["adults"][t][1]) for t in read]      # at each restored interval's lower bound
        q = chance(nd, lk["adults"][low][2])                     # at the low interval's upper bound
        p_est = [chance(nd, lk["adults"][t][0]) for t in read]  # at the estimates, reported
        renewed = [t for t in read if t1n.reached(natural_catch(lk, t, stocked, marks), floor)]
        own = own_level(lk, low, stocked, floor)
        row.update({"low survey": low, "low estimate": x_low, "years read": read,
                    "levels read": [lk["adults"][t][0] for t in read], "renewed in": renewed,
                    "renewed": bool(renewed), "marked years read": [t for t in read if t in stocked],
                    "years since stocking": [t - max(s for s in stocked if s < t) for t in read],
                    "at the levels restored": 1 - math.prod(1 - pi for pi in p),
                    "at the levels restored, at the estimates": 1 - math.prod(1 - pi for pi in p_est),
                    "at its level below the need": 1 - (1 - q) ** len(read),
                    "own renewing level": own,
                    "restored to its own level": own is not None and min(lk["adults"][t][0] for t in read) >= own})
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
    is shown where at least k renewing has a chance of at most ALPHA at their levels below the need; the shortfall
    where at most k has a chance of at most ALPHA at the levels restored, at the intervals' lower bounds."""
    inn = [r for r in table if "out" not in r]
    n, k = len(inn), sum(r["renewed"] for r in inn)
    e = [r["at the levels restored"] for r in inn]
    e_est = [r["at the levels restored, at the estimates"] for r in inn]
    q = [r["at its level below the need"] for r in inn]
    nums = {"lakes read": n, "renewed": k, "expected at their levels below the need": round(sum(q), 2),
            "expected at the levels restored, at the lower bounds": round(sum(e), 2),
            "expected at the levels restored, at the estimates": round(sum(e_est), 2)}
    if n < N_MIN:
        return "not decided", f"not decided: {n} lakes read, fewer than {N_MIN}", nums
    short, _ = tails(e, k)
    _, rose = tails(q, k)
    nums.update({"p, at least as many as below the need": rose, "p, no more than the fit at the lower bounds": short})
    head = f"of {n} lakes stocked back above the need, {k} renewed at the floor in a year read"
    if rose <= ALPHA:
        return ROSE, (f"{ROSE}: {head}, more than their levels below the need allow ({sum(q):.1f} expected, p = "
                      f"{rose:.3g}), the need's fit expecting {sum(e_est):.1f} at the levels restored ({sum(e):.1f} at "
                      f"their intervals' lower bounds)"), nums
    if short <= ALPHA:
        return NOT_ROSE, (f"{NOT_ROSE}: {head}, no more than their levels below the need allow ({sum(q):.1f} expected, "
                          f"p = {rose:.3g}), and fewer than the need's fit expects even at the lower bounds of the levels "
                          f"restored ({sum(e):.1f} expected, p = {short:.3g})"), nums
    return "not decided", (f"not decided: {head}, no more than their levels below the need allow ({sum(q):.1f} "
                           f"expected, p = {rose:.3g}), and not fewer than the need's fit expects at the lower bounds of "
                           f"the levels restored ({sum(e):.1f} expected, p = {short:.3g})"), nums


def v1(table, own=None, closed=None):
    """The verdict (primary), its line in full, decided before any value is read (DESIGN.md, section 7).
    - Renewal rose with the level: more of the lakes read renewed than their levels below the need allow. Read
      as renewal following the level in some of these lakes at least, not lost to another cause in all of them;
      the line gives what the need's fit expects at the levels restored, and does not say what share follows it.
      It carries the cause abating always; unrecorded stocking where the other stocking records were not read for
      a lake that renewed, or the stocking files give no date; and connected waters where a lake that renewed is
      not a recorded seepage lake and the closed lakes alone (`closed`, the same rule on them) do not also show
      the rise.
    - Renewal did not rise with the level: no more renewed than their levels below the need allow, and fewer
      than the fit expects even at the lower bounds of the levels restored. Read as renewal not following the
      level in these lakes taken together, as where it is lost to another cause; it carries stocking suppressing
      natural renewal and the lakes' own needs lying above the common one, always. The lakes restored to a level
      they renewed at before (`own`) are reported, read before the clauses: the fit they are compared with is the
      common one, so a shortfall there does not rule their own needs out."""
    outcome, line, nums = decide(table)
    out = {"outcome": outcome, **nums}
    inn = [r for r in table if "out" not in r]
    if closed is not None:
        out["the closed lakes alone, read before the clauses"] = closed
    if own is not None:
        out["the lakes restored to their own renewing level alone, read before the clauses"] = own
    if outcome == ROSE:
        unless = []
        renewed = [r for r in inn if r["renewed"]]
        if any(not r["other stocking read"] or not r["dated"] for r in renewed):
            unless.append("unrecorded stocking")
        if any(r["closed"] is not True for r in renewed) and (closed is None or not closed.startswith(ROSE)):
            unless.append("connected waters")
        verdict = (f"{line}; renewal read as following the level in some of these lakes at least, not lost to another "
                   "cause in all of them, unless " + " or ".join(unless + [ABATED]))
    elif outcome == NOT_ROSE:
        verdict = (f"{line}; renewal read as not following the level in these lakes taken together, as where it is "
                   f"lost to another cause, unless {SUPPRESSED} or {OWN_NEEDS}")
    else:
        verdict = line
    return {**out, "verdict": verdict}


def reports(table):
    """Ruling on nothing: the lakes out by reason; renewal by the years since the last stocking, which a
    suppression by stocked fish would lower nearest the stocking."""
    outs, by_gap = {}, {}
    for r in table:
        if "out" in r:
            outs[r["out"]] = outs.get(r["out"], 0) + 1
            continue
        for t, g in zip(r["years read"], r["years since stocking"]):
            cell = by_gap.setdefault(g, [0, 0])
            cell[0] += t in r["renewed in"]
            cell[1] += 1
    return {"lakes out, by reason": outs,
            "years read by years since the last stocking: renewed, read": {str(g): by_gap[g] for g in sorted(by_gap)}}


def read(lakes, nd, dated=None, floor=FLOOR, marks=None):
    """V1, its readings and the reports on lakes with a need (T1N's `need` on them), as run.py and the dry run
    read them. Reported beside V1: the years after 2012 alone, and, where marked shares are recorded, V1 with the
    second route's years added."""
    table = rows(lakes, nd, dated, floor)
    own = decide([r for r in table if "out" not in r and r["restored to its own level"]])[1]
    closed = decide([r for r in table if "out" not in r and r["closed"] is True])[1]
    out = {"V1": v1(table, own, closed),
           "the years after 2012 alone (reported)": v1(rows(lakes, nd, dated, floor, first=t1n.CUTOFF + 1))["verdict"],
           "reports": reports(table), "rows": table}
    if marks:
        out["with the marked years added (reported)"] = v1(rows(lakes, nd, dated, floor, marks=marks))["verdict"]
    return out
