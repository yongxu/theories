"""T1R's dry run (DESIGN.md, section 8): synthetic archives in worlds where T1 holds, where renewal is lost for
years to another cause, and where there is no need, each with managers stocking lakes that fall; T1N's need and
T1R's rules read on each; the rules on scripted lakes; the reader's additions and the run on synthetic files.
Writes results/dry-run.json; standard library only, nothing downloaded, no model called.

    python3 -B experiments/stocked-above-the-need/dry_run.py
"""

import contextlib
import csv
import hashlib
import importlib.util
import io
import json
import math
import random
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1r                       # noqa: E402  (checks T1N's files against T1N's freeze as it loads)
import additions                 # noqa: E402
import reader                    # noqa: E402  (T1N's)
t1n = t1r.t1n
_spec = importlib.util.spec_from_file_location("t1r_run", HERE / "run.py")
RUN = importlib.util.module_from_spec(_spec)      # T1R's run.py, by its path: T1N's folder is first on the path
_spec.loader.exec_module(RUN)

SEED = "T1R-dry-run-2026-11-05"
ARCHIVES = 40                   # synthetic archives a world and speed
LAKES = 300
YEARS = range(1990, 2026)
A, K, S, C = 60.0, 1.5, 0.70, 0.03     # T1N's model (its DESIGN.md, section 8)
SIGMA_R, CV, KNOCK = 0.8, 0.25, 0.02
STOCK_BELOW, CUT = 1.0, 0.05    # managers begin stocking a lake below this many adults per acre, its draw cut to CUT x
FINGERLINGS = 1 / C             # a stocking's fingerlings, in the fall survey's units: they join as one adult an acre
PROGRAMME, EVERY = 10, 2        # a programme stocks every EVERY years for PROGRAMME years
SPEEDS = (0.1, 0.03)            # the chance a year that managers begin a programme for a lake below STOCK_BELOW
FROZEN_FILES = ("t1r.py", "additions.py", "run.py", "dry_run.py", "layout.json")   # the files the dry run runs with
FALSE_MAX = 5                   # of 40: a level of 0.05 exceeds 5 such outcomes in 40 archives with chance 0.014
BIG = 900                       # lakes an archive, about the field's size, in the worlds run again (reported)
WORLDS = {
    # T1 holds: renewal stops below a need in the level
    "need": dict(family="T1 holds", q=3),
    "needs vary": dict(family="T1 holds", q=3, k_spread=math.log(2)),
    "lakes differ": dict(family="T1 holds", q=3, prod_spread=0.5),
    "episodic": dict(family="T1 holds", q=3, sigma_r=1.6),
    "stocked every year": dict(family="T1 holds", q=3, every=1),
    "open": dict(family="T1 holds", q=3, immigrants=1.5),
    # T1 holds, and stocked fish suppress natural renewal: the rival the test cannot separate (reported)
    "stocking suppresses": dict(family="suppressed", q=3, suppress=(3, 0.2)),
    # renewal lost to another cause, whatever the level (T1N's family of that name)
    "renewal lost, light harvest": dict(family="renewal lost", q=1, loss=(0.3, 1995, 2015), harvest=(0.05, 0.3)),
    "renewal lost": dict(family="renewal lost", q=1, loss=(0.3, 1995, 2015)),
    "renewal lost, other stocking read": dict(family="renewal lost", q=1, loss=(0.3, 1995, 2015), harvest=(0.05, 0.3),
                                              fry=0.5),
    "renewal lost, dated": dict(family="renewal lost", q=1, loss=(0.3, 1995, 2015), harvest=(0.05, 0.3), filed=0.5),
    # mixed: most lakes in T1's regime, some losing their renewal (reported apart: placed first among the renewal
    # lost, where its bound failed at 0.03, 6 of 40, since most of its lakes follow the level; DESIGN.md, section 8)
    "renewal lost, need": dict(family="mixed", q=3, loss=(0.3, 1995, 2015)),
    # renewal lost, and a confound only a qualifier answers
    "renewal lost, other stocking unread": dict(family="confounded", q=1, loss=(0.3, 1995, 2015), harvest=(0.05, 0.3),
                                                fry=0.5, other_read=False),
    "renewal lost, no dates": dict(family="confounded", q=1, loss=(0.3, 1995, 2015), harvest=(0.05, 0.3), filed=0.5,
                                   dates=False),
    "renewal lost, open": dict(family="confounded", q=1, loss=(0.3, 1995, 2015), harvest=(0.05, 0.3), immigrants=1.5),
    "renewal lost, the cause ends": dict(family="confounded", q=1, loss=(0.3, 1995, 2015), harvest=(0.05, 0.3),
                                         ends=True),
    # no need: renewal never stops with the level
    "no need": dict(family="no need", q=1),
    "no need, lakes differ": dict(family="no need", q=1, prod_spread=0.7),
    "no need, catch 0.1": dict(family="no need", q=1, catch=0.1),         # T1N's: a need fitted near T1's world's
}
QUALIFIER = {"renewal lost, other stocking unread": "unrecorded stocking", "renewal lost, no dates": "unrecorded stocking",
             "renewal lost, open": "connected waters", "renewal lost, the cause ends": t1r.ABATED}
NATURAL, STOCKED = t1n.NR, "stocked"


def recruitment(x, q, k, a):
    return a * x ** q / (k ** q + x ** q) if x > 0 else 0.0


def lake(rng, i, world, speed):
    """One synthetic lake's records, as T1N's reader builds them, and the years its stocking dates fall in."""
    w = WORLDS[world]
    q = w["q"]
    k0 = K * math.exp(rng.gauss(0, w["k_spread"])) if w.get("k_spread") else K
    a0 = A * math.exp(rng.gauss(0, w["prod_spread"])) if w.get("prod_spread") else A
    e = rng.uniform(*w.get("harvest", (0.05, 0.6)))
    closed = rng.random() < 0.4
    x = rng.uniform(1.5, 8.0)
    rec = {"id": f"L{i:04d}", "acres": 1000.0, "label": {}, "adults": {}, "age0": {}, "harvest": {}, "creel": set(),
           "stocked": set(), "closed": closed, "other": set() if w.get("other_read", True) else None}
    dated, other = set(), set()
    phase, every = rng.randrange(5), rng.choice((3, 4, 5))
    surveyed = rng.random() < 0.7
    loss_year = None
    if "loss" in w:
        share, y0, y1 = w["loss"]
        if rng.random() < share:
            loss_year = rng.randint(y0, y1)
    label, start, stocked_true, hist, fish = NATURAL, None, set(), {}, {}
    for yr in YEARS:
        lost = loss_year is not None and yr >= loss_year
        if lost and w.get("ends") and stocked_true and min(stocked_true) <= yr:
            lost = False                           # the cause ends when the lake is first stocked
        a = 0.0 if lost else a0
        sr = w.get("sigma_r", SIGMA_R)
        r = recruitment(x, q, k0, a) * math.exp(sr * rng.gauss(0, 1) - sr * sr / 2 + SIGMA_R * SIGMA_R / 2)
        past = [s for s in stocked_true if s < yr]
        if "suppress" in w and past and 1 <= yr - max(past) <= w["suppress"][0]:
            r *= w["suppress"][1]                  # stocked yearlings eating the lake's own age-0
        hist[yr] = r
        if start is None and x < STOCK_BELOW and rng.random() < speed:
            start = yr
        f = 0.0
        if start is not None and yr < start + PROGRAMME and (yr - start) % w.get("every", EVERY) == 0:
            f = FINGERLINGS
            stocked_true.add(yr)
            if w.get("filed") and rng.random() < w["filed"]:
                rec["stocked"].add(yr - 1)         # filed under the year before (a season's or a budget's year)
            else:
                rec["stocked"].add(yr)
            dated.add(yr)
            label = STOCKED
        elif start is not None and yr >= start + PROGRAMME:
            start = None if x < STOCK_BELOW else start
        fry = 0.0
        if w.get("fry") and stocked_true and yr not in stocked_true and rng.random() < w["fry"]:
            fry = FINGERLINGS / 3                  # fry stocked in a year between, recorded only in R5b
            other.add(yr)
            stocked_true.add(yr)
        fish[yr] = f + fry
        rec["label"][yr] = label
        if (yr - 1990 + phase) % every == 0:
            est = x * math.exp(CV * rng.gauss(0, 1) - CV * CV / 2)
            rec["adults"][yr] = (est, est * math.exp(-1.96 * CV), est * math.exp(1.96 * CV))
        if surveyed or rng.random() < 0.4:
            immig = w["immigrants"] if (w.get("immigrants") and not closed and rng.random() < 0.5) else 0.0
            rec["age0"][yr] = round((r + f + fry + immig) * w.get("catch", 1.0) * math.exp(0.3 * rng.gauss(0, 1)), 1)
        h = (e if x >= STOCK_BELOW else CUT) * x
        r3 = hist.get(yr - 3, recruitment(x, q, k0, a0))
        x = max(S * x - h + C * r3 + C * fish.get(yr - 3, 0.0), 0.0)
        if rng.random() < KNOCK:
            x *= 0.1
    if rec["other"] is not None:
        rec["other"] = other
    rec["_lost"] = loss_year             # the world's truth, for the dry run's tallies alone: no rule reads it
    return rec, (dated if w.get("dates", True) else None)


def archive(world, a, speed, lakes_=LAKES):
    rng = random.Random("|".join((SEED, world, str(speed), str(a), str(lakes_))))
    lakes, dated = [], {}
    for i in range(lakes_):
        lk, d = lake(rng, i, world, speed)
        lakes.append(lk)
        if d is not None:
            dated[lk["id"]] = d
    return lakes, (dated if WORLDS[world].get("dates", True) else None)


def verdict_of(lakes, dated):
    """T1R's V1 on a synthetic archive as run.py reads it: T1N's need, then T1R's rules."""
    labels = t1n.labels_per_year(lakes)
    nd = t1n.need(lakes, labels=labels)
    if nd["need"] is None:
        return "no need", None, nd
    res = t1r.read(lakes, nd, dated)
    return res["V1"]["outcome"], res, nd


class Checks:
    def __init__(self):
        self.by_kind, self.failed = {}, []

    def __call__(self, kind, name, ok, detail=None):
        self.by_kind[kind] = self.by_kind.get(kind, 0) + 1
        if not ok:
            self.failed.append({"kind": kind, "check": name, "detail": str(detail)[:2000]})


def code_hashes():
    """The sha-256 of each file the dry run runs with, repository-relative."""
    rel = HERE.relative_to(HERE.parents[1])
    return {str(rel / f): hashlib.sha256((HERE / f).read_bytes()).hexdigest() for f in FROZEN_FILES}


def refusal(f):
    try:
        f()
    except SystemExit as e:
        return str(e)
    return ""


def cell(world, speed, n=ARCHIVES, lakes_=LAKES):
    """A world's outcomes at a speed over n archives, with the clauses each line carries."""
    tally, clauses, read, needs, lost = {}, {}, [], 0, {}
    for a in range(n):
        lakes, dated = archive(world, a, speed, lakes_)
        kind, res, nd = verdict_of(lakes, dated)
        tally[kind] = tally.get(kind, 0) + 1
        needs += nd["need"] is not None
        if res:
            read.append(res["V1"]["lakes read"])
            truth = {lk["id"]: lk["_lost"] for lk in lakes}
            inn = [r for r in res["rows"] if "out" not in r]
            gone = sum(1 for r in inn if truth[r["id"]] is not None and truth[r["id"]] <= r["years read"][0])
            cell_ = lost.setdefault(kind, [0, 0])
            cell_[0] += gone
            cell_[1] += len(inn)
            for q in ("unrecorded stocking", "connected waters", t1r.ABATED, t1r.SUPPRESSED, t1r.OWN_NEEDS):
                if q in res["V1"]["verdict"]:
                    clauses.setdefault(kind, {})[q] = clauses.setdefault(kind, {}).get(q, 0) + 1
    out = {"V1": tally, "clauses, by outcome": clauses, "a need fitted": needs,
           "lakes read, median": sorted(read)[len(read) // 2] if read else None}
    if "loss" in WORLDS[world]:
        out["lakes read that had lost their renewal, by outcome: lost, read"] = lost
    return out


def worlds(chk):
    """Each world's outcomes over ARCHIVES archives at each speed, and the checks on them (DESIGN.md, section 8)."""
    out = {}
    for world, w in WORLDS.items():
        out[world] = {"family": w["family"]}
        for speed in SPEEDS:
            c = cell(world, speed)
            out[world][f"speed {speed}"] = c
            t = c["V1"]
            if w["family"] == "T1 holds":
                chk(f"worlds: {w['family']}", f"{world} at speed {speed}: '{t1r.NOT_ROSE}' in at most {FALSE_MAX} of {ARCHIVES}",
                    t.get(t1r.NOT_ROSE, 0) <= FALSE_MAX, t)
            if w["family"] == "renewal lost":
                chk(f"worlds: {w['family']}", f"{world} at speed {speed}: '{t1r.ROSE}' in at most {FALSE_MAX} of {ARCHIVES}",
                    t.get(t1r.ROSE, 0) <= FALSE_MAX, t)
            if world in QUALIFIER:
                positive = t.get(t1r.ROSE, 0)
                carried = c["clauses, by outcome"].get(t1r.ROSE, {}).get(QUALIFIER[world], 0)
                chk("worlds: confounded", f"{world} at speed {speed}: a rise read without '{QUALIFIER[world]}' in at most "
                    f"{FALSE_MAX} of {ARCHIVES}", positive - carried <= FALSE_MAX, c)
    t = out["need"]["speed 0.1"]["V1"]
    chk("worlds: power", f"need at speed 0.1: the rise read in at least 30 of {ARCHIVES}",
        t.get(t1r.ROSE, 0) >= 30, t)
    t = out["renewal lost, light harvest"]["speed 0.1"]["V1"]
    chk("worlds: power", f"renewal lost, light harvest at speed 0.1: '{t1r.NOT_ROSE}' in at least 30 of {ARCHIVES}",
        t.get(t1r.NOT_ROSE, 0) >= 30, t)
    return out


def big():
    """Three worlds again at about the field's size, at the slower speed (reported)."""
    return {f"{world}, {BIG} lakes an archive": {"speed 0.03": cell(world, 0.03, lakes_=BIG)}
            for world in ("need", "needs vary", "renewal lost, light harvest")}


def scripted(chk):
    """The rules on scripted lakes: the low survey, the years read, the stocking's window and year, dates and
    marks, the decision at its thresholds, the clauses, and that no year read is one T1N's fit reads."""
    nd = {"need": 1.0, "a": 0.0, "b": 4.0}

    def lk(i, low=0.5, high=3.0, stock=(2001, 2003), catch=5.0, years=(2004,), other=True, closed=True, extra=None):
        adults = {2000: (low, low * 0.8, low * 1.2)}
        adults.update({y: (high, high * 0.9, high * 1.1) for y in years})
        rec = {"id": f"S{i}", "acres": 100.0, "label": {}, "adults": adults,
               "age0": {y: catch for y in years}, "harvest": {}, "creel": set(), "stocked": set(stock),
               "closed": closed, "other": set() if other else None}
        rec.update(extra or {})
        return rec

    chk("rules: the fit", "the need's chance at the need is one half", abs(t1r.chance(nd, 1.0) - 0.5) < 1e-12)
    st = lambda l, d=None: t1r.stocked_years(l, d)
    l = lk(1)
    chk("rules: the years read", "below the need, stocked, then above it with no stocking that year: read",
        t1r.years_read(l, 1.0, st(l)) == (2000, [2004], None), t1r.years_read(l, 1.0, st(l)))
    for name, l_, want in (
            ("never wholly below the need", lk(2, low=0.9), "never wholly below"),
            ("no stocking after the low survey", lk(3, stock=(1998,)), "no stocking recorded after"),
            ("stocked in the year itself", lk(4, stock=(2001, 2004)), "no year read"),
            ("no stocking in the five years before", lk(5, stock=(2001,), years=(2008,)), "no year read"),
            ("the interval not wholly above the need", lk(6, high=1.05), "no year read"),
            ("no fall survey that year", lk(7, extra={"age0": {}}), "no year read")):
        got = t1r.years_read(l_, 1.0, st(l_))
        chk("rules: the years read", f"{name}: out", got[2] is not None and got[2].startswith(want), got)
    l = lk(8, stock=(2001, 2003, 2005, 2007, 2009), years=(2004, 2006, 2008, 2010))
    chk("rules: the years read", "M_READ years, the first: one a lake", t1r.years_read(l, 1.0, st(l))[1] == [2004][:t1r.M_READ],
        t1r.years_read(l, 1.0, st(l)))
    l = lk(9, stock=(2001, 2003, 2013), years=(2004, 2015))
    chk("rules: the years read", "within SPAN years of the first", t1r.years_read(l, 1.0, st(l))[1] == [2004], t1r.years_read(l, 1.0, st(l)))
    l = lk(10, stock=(2001, 2003))
    chk("rules: dates", "a stocking dated in the year read, filed under another, keeps the year out",
        t1r.years_read(l, 1.0, st(l, {"S10": {2004}}))[1] == [] and t1r.years_read(l, 1.0, st(l, {"S10": {2003}}))[1] == [2004])
    l = lk(11, other=True, extra={"other": {2004}})
    chk("rules: the other records", "fry recorded in R5b in the year read keeps it out", t1r.years_read(l, 1.0, st(l))[1] == [])
    l = lk(12, stock=(2001, 2004), catch=40.0)
    marks = {"S12": {2004: 0.1}}
    chk("rules: marks", "a stocked year with its unmarked share recorded is read by the second route, at the share",
        t1r.years_read(l, 1.0, st(l), marks)[1] == [2004] and t1r.natural_catch(l, 2004, st(l), marks) == 4.0
        and t1r.years_read(l, 1.0, st(l))[1] == [], t1r.years_read(l, 1.0, st(l), marks))
    l = lk(13, stock=(2001,), extra={"adults": {1995: (3.0, 2.7, 3.3), 1996: (5.0, 4.5, 5.5), 2000: (0.5, 0.4, 0.6),
                                                2004: (3.0, 2.7, 3.3)}, "age0": {1995: 9.0, 1996: 9.0, 2004: 5.0}})
    row = t1r.rows([l], nd)[0]
    chk("rules: own level", "the own level is the median of the years it renewed before its low survey, unstocked",
        row["own renewing level"] == 5.0 and row["restored to its own level"] is False, row)
    for lk_, good in ((lk(14), True),):
        r = t1r.rows([lk_], nd)[0]
        chk("rules: T1N's fit", "every year read has stocking in T1N's records in the five years before it, so T1N's fit "
            "never reads it", all(t1n.stocked_in(lk_, t - t1n.STOCK_BEFORE, t) for t in r["years read"]), r)

    def table(n, renew, low=0.5, high=3.0, closed=True, other=True):
        return t1r.rows([lk(100 + i, low=low, high=high, catch=5.0 if i < renew else 0.0, closed=closed, other=other)
                         for i in range(n)], nd)
    v = t1r.v1(table(10, 10))
    chk("rules: V1", "ten lakes back above the need, all renewing: rose", v["outcome"] == t1r.ROSE, v)
    chk("rules: V1", "the rise's line carries the cause abating always, and the fit's two expectations",
        v["verdict"].endswith(t1r.ABATED) and "at the levels restored" in v["verdict"] and "lower bounds" in v["verdict"],
        v["verdict"])
    v = t1r.v1(table(10, 0))
    chk("rules: V1", "none renewing: did not rise", v["outcome"] == t1r.NOT_ROSE, v)
    chk("rules: V1", "the line carries stocking suppressing always, and own needs with no own reading",
        t1r.SUPPRESSED in v["verdict"] and t1r.OWN_NEEDS in v["verdict"], v["verdict"])
    v = t1r.v1(table(20, 10, low=0.5, high=1.6))
    chk("rules: V1", "half renewing, short of the fit: still rose, read in some at least, with no shortfall claimed",
        v["outcome"] == t1r.ROSE and "some of these lakes at least" in v["verdict"] and "short" not in v["verdict"], v)
    v = t1r.v1(table(20, 10, low=0.8, high=1.2))
    chk("rules: V1", "neither more than below the need nor fewer than the fit at the lower bounds: not decided",
        v["outcome"] == "not decided" and v["lakes read"] == 20, v)
    v = t1r.v1(table(9, 9))
    chk("rules: V1", "nine lakes: not decided", v["outcome"] == "not decided" and "fewer than 10" in v["verdict"], v)
    v = t1r.v1(table(10, 10, other=False))
    chk("rules: V1", "the other records not read for a lake that renewed: unless unrecorded stocking",
        "unrecorded stocking" in v["verdict"], v["verdict"])
    v = t1r.v1(table(10, 10), closed=None)
    chk("rules: V1", "a seepage lake's rise needs no clause of connected waters", "connected waters" not in v["verdict"], v["verdict"])
    v = t1r.v1(table(10, 10, closed=False), closed="not decided: 0 lakes read, fewer than 10")
    chk("rules: V1", "open lakes renewing, the closed lakes alone not deciding: unless connected waters",
        "connected waters" in v["verdict"], v["verdict"])
    v = t1r.v1(table(10, 0), own=t1r.NOT_ROSE + ": ...")
    chk("rules: V1", "the own-level reading, a shortfall there too, keeps the clause of own needs", t1r.OWN_NEEDS in v["verdict"]
        and v["the lakes restored to their own renewing level alone, read before the clauses"].startswith(t1r.NOT_ROSE), v)
    lo_, hi_ = t1r.tails([0.5, 0.5], 1)
    chk("rules: the tails", "two fair trials: at most one 0.75, at least one 0.75", abs(lo_ - 0.75) < 1e-12 and abs(hi_ - 0.75) < 1e-12)


def additions_checks(chk):
    """T1R's reading beyond T1N's reader, on synthetic files: dates and their facts, R8, and that the facts read
    no value."""
    lakes, dated = archive("renewal lost, dated", 0, 0.1, 30)
    moved = {lk["id"]: dated[lk["id"]] for lk in lakes if dated.get(lk["id"])}
    marks_map = {lakes[0]["id"]: {2010: 0.25}}
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        additions.write_synthetic(lakes, tmp, moved, marks_map)
        got, facts = additions.dated(tmp)
        want = {lid: set(ys) for lid, ys in moved.items()}
        chk("additions", "the dates read back as the years the stockings were made", all(want[l] <= got.get(l, set()) for l in want),
            (sorted(want.items())[:3], sorted(got.items())[:3]))
        filed = sum(1 for lk in lakes for y in lk["stocked"] if (y + 1) in moved.get(lk["id"], set()) and y not in moved.get(lk["id"], set()))
        chk("additions", "the rows filed under another year than their date's are counted",
            facts[reader.FILES["stocking"]]["walleye rows whose date falls in another year than their entry"] == filed, (facts, filed))
        m, _ = additions.marks(tmp)
        chk("additions", "R8's shares read back", m == {k: dict(v) for k, v in marks_map.items()}, m)
        f1 = additions.facts(tmp)
        p = tmp / additions.MARKS["file"]
        rows = list(csv.DictReader(p.open()))
        for r in rows:
            r[additions.MARKS["columns"]["unmarked share"]] = "0.987654321"
        with p.open("w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0]))
            w.writeheader()
            w.writerows(rows)
        chk("additions", "the facts are the same with R8's shares overwritten, and hold none",
            additions.facts(tmp) == f1 and "0.987654321" not in json.dumps(additions.facts(tmp)), f1)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        got, facts = additions.dated(tmp)
        chk("additions", "stocking files with no date column: no dates, and the facts say so",
            got is None and "no date column" in facts[reader.FILES["stocking"]], facts)
    chk("additions", "a date's year in the files' forms", [additions.date_year(t) for t in
        ("2014-05-02", "5/2/2014", "2014/05/02", "02-May-2014", "", "5/2/14", "2014-2015")] == [2014, 2014, 2014, 2014, None, None, None])


def run_checks(chk):
    """run.py end to end on synthetic files, and its refusal of R8 unrecorded."""
    lakes, dated = archive("need", 0, 0.1)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        additions.write_synthetic(lakes, tmp)
        out = RUN.run(tmp, check_frozen=False, check_inputs=False)
        back = list(reader.read_all(tmp)[0].values())
        nd = t1n.need(back, labels=t1n.labels_per_year(back))
        want = t1r.read(back, nd, additions.dated(tmp)[0])["V1"]["verdict"] if nd["need"] is not None else None
        chk("the run", "V1 is the rules' own on the lakes T1N's reader builds, with the dates read",
            nd["need"] is not None and out["V1"]["verdict"] == want, (out["V1"].get("verdict"), want))
        chk("the run", "the lakes T1N also reads, and the run without the disclosed lakes, are reported",
            "lakes T1R reads that T1N also reads (reported)" in out and "without the lakes a search summary showed (reported)" in out,
            sorted(out))
        (tmp / additions.MARKS["file"]).write_text("WBIC,Survey Year,Unmarked Share\n")
        saved = (RUN.T1N_RUN.once, RUN.T1N_RUN.inputs)
        try:
            RUN.T1N_RUN.once, RUN.T1N_RUN.inputs = (lambda repo, rel: None), (lambda folder: {})
            chk("the run", "refuses R8 in the folder with no downloads.json of T1R's recording it",
                "does not record it" in refusal(lambda: RUN.inputs(tmp)))
        finally:
            RUN.T1N_RUN.once, RUN.T1N_RUN.inputs = saved


def chain_checks(chk):
    """T1R's freeze, by T1N's frozen check, in a stand-in repository holding both folders: refuses before the
    link, passes when whole, refuses a changed rule and an addendum changing one."""
    env = {"GIT_AUTHOR_NAME": "t", "GIT_AUTHOR_EMAIL": "t@t", "GIT_COMMITTER_NAME": "t", "GIT_COMMITTER_EMAIL": "t@t",
           "PATH": "/usr/bin:/bin:/usr/local/bin:/opt/homebrew/bin", "HOME": tempfile.gettempdir()}
    rel = HERE.relative_to(HERE.parents[1])
    files = FROZEN_FILES + ("write_frozen.py",)

    def g(repo, *args):
        subprocess.run(["git", "-C", str(repo), *args], capture_output=True, check=True, env=env)

    def link(repo, path, extra=()):
        names = sorted({str(rel / f) for f in files} | {str(rel / "results" / "dry-run.json")} | {str(rel / e) for e in extra})
        path.write_text("".join(f"{hashlib.sha256((repo / p).read_bytes()).hexdigest()}  {p}\n" for p in names))

    with tempfile.TemporaryDirectory() as tmp:
        repo = Path(tmp)
        here = repo / rel
        (here / "results").mkdir(parents=True)
        for f in files:
            shutil.copy(HERE / f, here / f)
        hashes = {str(rel / f): hashlib.sha256((here / f).read_bytes()).hexdigest() for f in FROZEN_FILES}
        (here / "results" / "dry-run.json").write_text(json.dumps({"failed": [], "code unchanged during the run": True,
                                                                    "code hashes": hashes}))
        chk("the chain", "refuses while FROZEN.sha256 is not written",
            "is not written" in refusal(lambda: RUN.T1N_RUN.frozen(repo, here)))
        g(repo, "init", "-q")
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "files")
        link(repo, here / "FROZEN.sha256")
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "freeze")
        r = refusal(lambda: RUN.T1N_RUN.frozen(repo, here))
        chk("the chain", "a whole chain passes by T1N's check", r == "", r)
        (here / "t1r.py").write_text((here / "t1r.py").read_text() + "\n# changed\n")
        chk("the chain", "a changed rule refuses", "differ" in refusal(lambda: RUN.T1N_RUN.frozen(repo, here)))
        g(repo, "checkout", "-q", "--", str(rel / "t1r.py"))
        (here / "addenda").mkdir()
        (here / "addenda" / "ADDENDUM-1.md").write_text("rules\n")
        (here / "t1r.py").write_text((here / "t1r.py").read_text() + "\n# a rule changed\n")
        link(repo, here / "addenda" / "FROZEN-1.sha256", ("addenda/ADDENDUM-1.md",))
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "addendum 1")
        chk("the chain", "an addendum changing a rule refuses", "may not" in refusal(lambda: RUN.T1N_RUN.frozen(repo, here)))


def main():
    t0 = time.process_time()
    code = code_hashes()
    chk = Checks()
    scripted(chk)
    additions_checks(chk)
    with contextlib.redirect_stdout(io.StringIO()):
        run_checks(chk)
    chain_checks(chk)
    out = {f"worlds, {LAKES} lakes an archive": worlds(chk), "worlds again, at about the field's size": big()}
    out.update({"checks": sum(chk.by_kind.values()), "checks by kind": chk.by_kind, "failed": chk.failed,
                "CPU seconds": round(time.process_time() - t0, 1),
                "code hashes": code, "code unchanged during the run": code_hashes() == code})
    path = HERE / "results" / "dry-run.json"
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(out, indent=1) + "\n")
    print("checks:", out["checks"], "failed:", len(chk.failed), "CPU seconds:", out["CPU seconds"],
          "code unchanged:", out["code unchanged during the run"])
    for f in chk.failed[:12]:
        print("  FAILED", f["kind"], "|", f["check"], str(f["detail"])[:240])


if __name__ == "__main__":
    main()
