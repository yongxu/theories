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
LAKES = 900                     # lakes an archive, about the field's size
YEARS = range(1990, 2026)
A, K, S, C = 60.0, 1.5, 0.70, 0.03     # T1N's model (its DESIGN.md, section 8)
SIGMA_R, CV, KNOCK = 0.8, 0.25, 0.02
STOCK_BELOW, CUT = 1.0, 0.05    # managers begin stocking a lake below this many adults per acre, its draw cut to CUT x
FINGERLINGS = 1 / C             # a stocking's fingerlings, in the fall survey's units: they join as one adult an acre
PROGRAMME, EVERY = 10, 2        # a programme stocks every EVERY years for PROGRAMME years
SPEEDS = (0.1, 0.03)            # the chance a year that managers begin a programme for a lake below STOCK_BELOW
YEARLING_SURVIVAL = 0.4         # of a stocking's fingerlings, the share alive at their second fall
YOUNG = (1.0, 0.6, 0.36)        # a stocked cohort's weight among the adults in its first three years counted, not spawning
FROZEN_FILES = ("t1r.py", "additions.py", "run.py", "dry_run.py", "layout.json")   # the files the dry run runs with
FALSE_MAX = 5                   # of 40: a level of 0.05 exceeds 5 such outcomes in 40 archives with chance 0.014
LOSS = (0.3, 1995, 2015)        # renewal lost in 30% of lakes, for good, from a year between these
LIGHT = (0.05, 0.3)             # a light harvest: lakes fall mostly by the loss
WORLDS = {
    # T1 holds: renewal stops below a need in the level
    "need": dict(family="T1 holds", q=3),
    "needs vary": dict(family="T1 holds", q=3, k_spread=math.log(2)),
    "lakes differ": dict(family="T1 holds", q=3, prod_spread=0.5),
    "episodic": dict(family="T1 holds", q=3, sigma_r=1.6),
    "stocked every year": dict(family="T1 holds", q=3, every=1),
    "open": dict(family="T1 holds", q=3, immigrants=1.5),
    "yearlings read as age 0": dict(family="T1 holds", q=3, yearlings=0.1),       # round 2's R-18
    # T1 holds, with a rival the negative outcome always names (reported): stocked fish suppressing natural renewal,
    # and stocked cohorts counted among the adults for three years before they spawn (round 1's R-03)
    "stocking suppresses": dict(family="a rival of the negative outcome", q=3, suppress=(3, 0.2)),
    "stocked fish counted before they spawn": dict(family="a rival of the negative outcome", q=3, young=True),
    # renewal lost to another cause, whatever the level (T1N's family of that name)
    "renewal lost, light harvest": dict(family="renewal lost", q=1, loss=LOSS, harvest=LIGHT),
    "renewal lost": dict(family="renewal lost", q=1, loss=LOSS),
    "renewal lost, other stocking read": dict(family="renewal lost", q=1, loss=LOSS, harvest=LIGHT, fry=0.5),
    "renewal lost, dated": dict(family="renewal lost", q=1, loss=LOSS, harvest=LIGHT, filed=0.5),
    # round 1's R-01: managers leave the lakes whose renewal is lost unstocked and stock the others ten times as
    # soon, so the lakes read renew at any level and are many; winterkills twice the rate
    "renewal lost, the lost lakes left unstocked": dict(family="renewal lost", q=1, loss=LOSS, spare_lost=True,
                                                        haste=10, knock=0.04),
    # round 1's R-02: a tenth of last year's surviving stocked fish read as age 0 in the fall survey
    "renewal lost, yearlings read as age 0": dict(family="renewal lost", q=1, loss=LOSS, harvest=LIGHT, yearlings=0.1),
    # mixed: most lakes in T1's regime, some losing their renewal (reported apart: placed first among the renewal
    # lost, where its bound failed, since most of its lakes follow the level; DESIGN.md, section 8)
    "renewal lost, need": dict(family="mixed", q=3, loss=LOSS),
    # renewal lost, and a confound only a clause answers
    "renewal lost, other stocking unread": dict(family="confounded", q=1, loss=LOSS, harvest=LIGHT, fry=0.5,
                                                other_read=False),
    "renewal lost, no dates": dict(family="confounded", q=1, loss=LOSS, harvest=LIGHT, filed=0.5, dates=False),
    "renewal lost, open": dict(family="confounded", q=1, loss=LOSS, harvest=LIGHT, immigrants=1.5),
    "renewal lost, the cause ends": dict(family="confounded", q=1, loss=LOSS, harvest=LIGHT, ends=True),
    # managers begin a programme only after a fall survey below the floor, renewal episodic: a run of poor years
    # brings the stocking and then passes; the lost lakes left unstocked, so that the lakes read mostly kept their
    # renewal (round 2's R-23)
    "renewal lost, stocked after a failed survey": dict(family="confounded", q=1, loss=LOSS, harvest=LIGHT,
                                                         sigma_r=1.6, trigger=True, spare_lost=True, haste=10,
                                                         knock=0.04),
    # round 2's R-17: stocked fish cutting the lake's own age-0 to a fifth for three years after each stocking, where
    # the lost lakes are left unstocked
    "renewal lost, stocking suppresses": dict(family="confounded", q=1, loss=LOSS, spare_lost=True, haste=10,
                                              knock=0.04, suppress=(3, 0.2)),
    # the coordinator's point after round 1: the lost lakes keep a renewal held low whatever their adults, and a
    # year's conditions scale the spring estimate and the fall catch together, each lake-year's own or the region's,
    # so a low survey is chosen more often in a poor year, whose age-0 is low too
    "renewal held low, the year in both counts": dict(family="confounded", q=1, loss=LOSS, harvest=LIGHT, resid=0.7,
                                                      shared=(0.8, 1.2, "lake")),
    "renewal held low, the year in both counts, region-wide": dict(family="confounded", q=1, loss=LOSS,
                                                                   harvest=LIGHT, resid=0.7,
                                                                   shared=(0.5, 0.8, "region")),
    # no need: renewal never stops with the level
    "no need": dict(family="no need", q=1),
    "no need, lakes differ": dict(family="no need", q=1, prod_spread=0.7),
    "no need, catch 0.1": dict(family="no need", q=1, catch=0.1),         # T1N's: a need fitted near T1's world's
}
QUALIFIER = {"renewal lost, other stocking unread": "unrecorded stocking", "renewal lost, no dates": "unrecorded stocking",
             "renewal lost, open": "connected waters", "renewal lost, the cause ends": t1r.ABATED,
             "renewal lost, stocked after a failed survey": t1r.ABATED,
             "renewal lost, stocking suppresses": t1r.ABATED, "renewal held low, the year in both counts": t1r.ABATED,
             "renewal held low, the year in both counts, region-wide": t1r.ABATED}
NATURAL, STOCKED = t1n.NR, "stocked"


def recruitment(x, q, k, a):
    return a * x ** q / (k ** q + x ** q) if x > 0 else 0.0


def lake(rng, i, world, speed, zr=None):
    """One synthetic lake's records, as T1N's reader builds them, and the years its stocking dates fall in. `zr`:
    the region's year effects, where a world shares one year's conditions among all its lakes."""
    w = WORLDS[world]
    s_a, s_c, scope = w.get("shared", (0.0, 0.0, None))
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
    label, start, stocked_true, hist, fish, failed = NATURAL, None, set(), {}, {}, False
    for yr in YEARS:
        z = rng.gauss(0, 1) if scope == "lake" else (zr[yr] if scope == "region" else 0.0)
        lost = loss_year is not None and yr >= loss_year
        if lost and w.get("ends") and stocked_true and min(stocked_true) <= yr:
            lost = False                           # the cause ends when the lake is first stocked
        sr = w.get("sigma_r", SIGMA_R)
        spawners = x
        if w.get("young"):                         # stocked cohorts counted for three years before they spawn
            spawners = max(x - C * sum(wt * fish.get(yr - 4 - j, 0.0) for j, wt in enumerate(YOUNG)), 0.0)
        # a lost lake's renewal is none, or held at a low level whatever its adults (`resid`, per mile)
        r = (w.get("resid", 0.0) if lost else recruitment(spawners, q, k0, a0)) * math.exp(
            sr * rng.gauss(0, 1) - sr * sr / 2 + SIGMA_R * SIGMA_R / 2)
        past = [s for s in stocked_true if s < yr]
        if "suppress" in w and past and 1 <= yr - max(past) <= w["suppress"][0]:
            r *= w["suppress"][1]                  # stocked yearlings eating the lake's own age-0
        hist[yr] = r
        lost_now = loss_year is not None and yr >= loss_year
        spared = w.get("spare_lost") and lost_now          # managers leave the lakes whose renewal is lost unstocked
        haste = 1.0 if lost_now else w.get("haste", 1.0)    # and may stock the others sooner
        if (start is None and x < STOCK_BELOW and not spared and (failed or not w.get("trigger"))
                and rng.random() < min(1.0, speed * haste)):
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
            est = x * math.exp(CV * rng.gauss(0, 1) - CV * CV / 2) * math.exp(s_a * z - s_a * s_a / 2)
            rec["adults"][yr] = (est, est * math.exp(-1.96 * CV), est * math.exp(1.96 * CV))
        if surveyed or rng.random() < 0.4:
            immig = w["immigrants"] if (w.get("immigrants") and not closed and rng.random() < 0.5) else 0.0
            yl = w.get("yearlings", 0.0) * YEARLING_SURVIVAL * fish.get(yr - 1, 0.0)   # last year's, read as age 0
            rec["age0"][yr] = round((r + f + fry + immig + yl) * w.get("catch", 1.0) * math.exp(0.3 * rng.gauss(0, 1))
                                    * math.exp(s_c * z - s_c * s_c / 2), 1)
            failed = rec["age0"][yr] < t1n.FLOOR
        h = (e if x >= STOCK_BELOW else CUT) * x
        r3 = hist.get(yr - 3, recruitment(x, q, k0, a0))
        x = max(S * x - h + C * r3 + C * fish.get(yr - 3, 0.0), 0.0)
        if rng.random() < w.get("knock", KNOCK):
            x *= 0.1
    if rec["other"] is not None:
        rec["other"] = other
    rec["_lost"] = loss_year             # the world's truth, for the dry run's tallies alone: no rule reads it
    return rec, (dated if w.get("dates", True) else None)


def archive(world, a, speed, lakes_=LAKES):
    rng = random.Random("|".join((SEED, world, str(speed), str(a), str(lakes_))))
    zr = None
    if WORLDS[world].get("shared", (0, 0, None))[2] == "region":
        rz = random.Random("|".join((SEED, world, str(speed), str(a), "region")))
        zr = {yr: rz.gauss(0, 1) for yr in YEARS}
    lakes, dated = [], {}
    for i in range(lakes_):
        lk, d = lake(rng, i, world, speed, zr)
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


CLAUSES = ("unrecorded stocking", "connected waters", t1r.ABATED, t1r.SUPPRESSED, t1r.OWN_NEEDS, t1r.YOUNG)


def cell(world, speed, n=ARCHIVES, lakes_=LAKES):
    """A world's outcomes at a speed over n archives, with the clauses each line carries; by outcome, the lakes
    read that had lost their renewal and those whose rise within the lake (renewed above the need and not below)
    drove it; and, by outcome, the archives whose rise read with each lake's first fall after its low survey as
    its year below, a year no spring estimate chose, is shown (reported)."""
    tally, clauses, read, paired, needs, lost, falls = {}, {}, [], [], 0, {}, {}
    for a in range(n):
        lakes, dated = archive(world, a, speed, lakes_)
        kind, res, nd = verdict_of(lakes, dated)
        tally[kind] = tally.get(kind, 0) + 1
        needs += nd["need"] is not None
        if res:
            read.append(res["V1"]["lakes read"])
            paired.append(res["V1"]["read in a year below the need too"])
            truth = {lk["id"]: lk["_lost"] for lk in lakes}
            inn = [r for r in res["rows"] if "out" not in r]
            gone = [r for r in inn if truth[r["id"]] is not None and truth[r["id"]] <= r["year read"]]
            up = [r for r in inn if r["renewed"] and r["renewed below"] is False]
            cell_ = lost.setdefault(kind, [0, 0, 0, 0])
            cell_[0] += len(gone)
            cell_[1] += len(inn)
            cell_[2] += sum(1 for r in up if r in gone)
            cell_[3] += len(up)
            fall = next(v for key, v in res["reports"].items() if key.startswith("the rise with the first fall"))
            if fall[3] <= t1r.ALPHA:
                falls[kind] = falls.get(kind, 0) + 1
            for q in CLAUSES:
                if q in res["V1"]["verdict"]:
                    clauses.setdefault(kind, {})[q] = clauses.setdefault(kind, {}).get(q, 0) + 1
    out = {"V1": tally, "clauses, by outcome": clauses, "a need fitted": needs,
           "lakes read, median": sorted(read)[len(read) // 2] if read else None,
           "lakes read in a year below the need too, median": sorted(paired)[len(paired) // 2] if paired else None,
           "the rise with the first fall after the low survey as the year below shown (reported), by outcome": falls}
    if "loss" in WORLDS[world]:
        out["lakes read that had lost their renewal, by outcome: lost, read; of the lakes that renewed above the need "
            "and not below, lost, all"] = lost
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
                chk(f"worlds: {w['family']}", f"{world} at speed {speed}: '{t1r.SHORT}' in at most {FALSE_MAX} of {ARCHIVES}",
                    t.get(t1r.SHORT, 0) <= FALSE_MAX, t)
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
    chk("worlds: power", f"renewal lost, light harvest at speed 0.1: '{t1r.SHORT}' in at least 30 of {ARCHIVES}",
        t.get(t1r.SHORT, 0) >= 30, t)
    return out


def scripted(chk):
    """The rules on scripted lakes: the low survey, the year read and the year below, the stocking's window and
    gap, dates and marks, the decision at its thresholds, the clauses, and that no year read is one T1N's fit
    reads."""
    nd = {"need": 1.0, "a": 0.0, "b": 4.0}

    def lk(i, low=0.5, high=3.0, stock=(2001,), catch=5.0, below=0.0, other=True, closed=True, extra=None):
        """Low survey 2000 wholly below the need (1.0), its fall at `below`, unstocked; stocked as `stock`; spring
        2004 wholly above it, its fall at `catch`."""
        rec = {"id": f"S{i}", "acres": 100.0, "label": {},
               "adults": {2000: (low, low * 0.8, low * 1.2), 2004: (high, high * 0.9, high * 1.1)},
               "age0": {2000: below, 2004: catch}, "harvest": {}, "creel": set(), "stocked": set(stock),
               "closed": closed, "other": set() if other else None}
        rec.update(extra or {})
        return rec

    chk("rules: the fit", "the need's chance at the need is one half, and none at no adults",
        abs(t1r.chance(nd, 1.0) - 0.5) < 1e-12 and t1r.chance(nd, 0.0) == 0.0)
    st = lambda l, d=None: t1r.stocked_years(l, d)
    sc = lambda l, d=None, m=None: t1r.scope(l, 1.0, st(l, d), m)
    l = lk(1)
    chk("rules: the scope", "below the need, stocked, then above it with none that year or the year before: the year "
        "read, and the low survey's year as the year below", sc(l) == (2000, 2004, 2000, None), sc(l))
    for name, l_, want in (
            ("never wholly below the need", lk(2, low=0.9), "never wholly below"),
            ("an upper bound of no adults is not wholly below", lk(3, extra={"adults": {2000: (0.5, 0.0, 0.0),
                                                                                     2004: (3.0, 2.7, 3.3)}}),
             "never wholly below"),
            ("no stocking from the low survey's year", lk(4, stock=(1998,)), "no stocking recorded from"),
            ("back above the need before it was stocked",
             lk(5, stock=(2003,), extra={"adults": {2000: (0.5, 0.4, 0.6), 2002: (3.0, 2.7, 3.3), 2004: (3.0, 2.7, 3.3)}}),
             "back above the need before"),
            ("stocked in the year read itself", lk(6, stock=(2001, 2004)), "no year read"),
            ("stocked in the year before it", lk(7, stock=(2001, 2003)), "no year read"),
            ("no stocking in the five years before", lk(8, extra={"adults": {2000: (0.5, 0.4, 0.6), 2008: (3.0, 2.7, 3.3)},
                                                                    "age0": {2000: 0.0, 2008: 5.0}}), "no year read"),
            ("the interval not wholly above the need", lk(9, high=1.05), "no year read"),
            ("no fall survey that year", lk(10, extra={"age0": {2000: 0.0}}), "no year read")):
        got = sc(l_)
        chk("rules: the scope", f"{name}: out", got[3] is not None and got[3].startswith(want), got)
    l = lk(11, stock=(2000,))
    chk("rules: the scope", "a stocking in the low survey's own year counts as after it; that year, stocked, is no "
        "year below", sc(l) == (2000, 2004, None, None), sc(l))
    l = lk(12, stock=(2001,), extra={"adults": {2000: (0.5, 0.4, 0.6), 2003: (0.6, 0.5, 0.7), 2004: (3.0, 2.7, 3.3)},
                                     "age0": {2000: 0.0, 2003: 2.0, 2004: 5.0}})
    chk("rules: the scope", "the year below is the last wholly below the need before the year read, with no "
        "stocking that year or the year before, and surveyed", sc(l) == (2000, 2004, 2003, None), sc(l))
    l = lk(46, stock=(2001,), extra={"adults": {2000: (0.5, 0.4, 0.6), 2002: (0.6, 0.5, 0.7), 2004: (3.0, 2.7, 3.3)},
                                     "age0": {2000: 0.0, 2002: 2.0, 2004: 5.0}})
    chk("rules: the scope", "a year below the need one year after a stocking is passed over (round 2's R-17 and "
        "R-18)", sc(l) == (2000, 2004, 2000, None), sc(l))
    l = lk(13, extra={"age0": {2004: 5.0}})
    chk("rules: the scope", "no fall survey below the need: read, with no year below", sc(l) == (2000, 2004, None, None), sc(l))
    l = lk(45, stock=(2004,), extra={"adults": {2000: (0.5, 0.4, 0.6), 2005: (3.0, 2.7, 3.3), 2008: (3.0, 2.7, 3.3)},
                                     "age0": {2000: 0.0, 2008: 5.0}})
    got = [r.get("out", "") for r in t1r.rows([l], nd, {"S45": {2005}})] + [r.get("out", "") for r in t1r.rows([l], nd)]
    chk("rules: dates", "a lake back above the need in the spring of its first stocking's dated year, the stocking "
        "filed under the year before, is out; undated, it is read (round 2's R-21)",
        got[0].startswith("back above the need before") and got[1] == "", got)
    ff = lambda l: t1r.first_fall(l, 1.0, st(l), 2000, 2004)
    l = lk(41, stock=(2001,), extra={"age0": {2000: 0.0, 2001: 9.0, 2002: 0.0, 2003: 4.0, 2004: 5.0}})
    chk("rules: the first fall", "the first fall after the low survey with no stocking that year or the year before "
        "and no estimate of its own, before the stocked fish can join the adults", ff(l) == 2003, ff(l))
    l = lk(42, stock=(1999, 2001), extra={"age0": {2000: 0.0, 2001: 9.0, 2002: 0.0, 2004: 5.0}})
    chk("rules: the first fall", "none once a stocking from two years before the low survey can have joined the adults",
        ff(l) is None, ff(l))
    l = lk(43, stock=(2001,), extra={"adults": {2000: (0.5, 0.4, 0.6), 2002: (0.6, 0.5, 0.7), 2004: (3.0, 2.7, 3.3)},
                                     "age0": {2000: 0.0, 2002: 2.0, 2003: 0.0, 2004: 5.0}})
    l2 = lk(44, stock=(2001,), extra={"adults": {2000: (0.5, 0.4, 0.6), 2002: (1.2, 1.0, 1.4), 2004: (3.0, 2.7, 3.3)},
                                      "age0": {2000: 0.0, 2002: 2.0, 2003: 0.0, 2004: 5.0}})
    chk("rules: the first fall", "a year with a spring estimate of its own is passed over, and none after an estimate "
        "not wholly below the need", ff(l) == 2003 and ff(l2) is None, (ff(l), ff(l2)))
    l = lk(14, stock=(2001,))
    chk("rules: dates", "a stocking dated in the year read or the year before, filed under another, keeps it out",
        sc(l, {"S14": {2004}})[1] is None and sc(l, {"S14": {2003}})[1] is None and sc(l, {"S14": {2002}})[1] == 2004)
    l = lk(15, extra={"other": {2004}})
    chk("rules: the other records", "fry recorded in R5b in the year read keeps it out", sc(l)[1] is None, sc(l))
    l = lk(16, stock=(2001, 2004), catch=40.0)
    chk("rules: marks", "a stocked year with its unmarked share recorded is read by the second route, at the share",
        sc(l, m={"S16": {2004: 0.1}})[1] == 2004 and t1r.natural_catch(l, 2004, st(l), {"S16": {2004: 0.1}}, t1r.GAP) == 4.0
        and sc(l)[1] is None, sc(l, m={"S16": {2004: 0.1}}))
    l = lk(17, extra={"adults": {1995: (3.0, 2.7, 3.3), 1996: (5.0, 4.5, 5.5), 2000: (0.5, 0.4, 0.6), 2004: (3.0, 2.7, 3.3)},
                      "age0": {1995: 9.0, 1996: 9.0, 2000: 0.0, 2004: 5.0}})
    row = t1r.rows([l], nd)[0]
    chk("rules: own level", "the own level is the median of the years it renewed before its low survey, unstocked, the "
        "upper of two", row["own renewing level"] == 5.0 and row["restored to its own level"] is False, row)
    r = t1r.rows([lk(18)], nd)[0]
    chk("rules: T1N's fit", "the year read has stocking in T1N's records in the five years before it, so T1N's fit "
        "never reads it", t1n.stocked_in(lk(18), r["year read"] - t1n.STOCK_BEFORE, r["year read"]) != [], r)

    def table(up=0, both=0, none=0, down=0, single=0, high=3.0, closed=True, other=True, undated=False):
        """Lakes renewing above the need and not below (up), in both years, in neither, below and not above
        (down), and above with no year below (single)."""
        spec = [(5.0, 0.0)] * up + [(5.0, 5.0)] * both + [(0.0, 0.0)] * none + [(0.0, 5.0)] * down
        lakes = [lk(100 + i, catch=c, below=b, high=high, closed=closed, other=other) for i, (c, b) in enumerate(spec)]
        lakes += [lk(200 + i, high=high, closed=closed, other=other, extra={"age0": {2004: 5.0}}) for i in range(single)]
        return t1r.rows(lakes, nd, {}, undated={l["id"] for l in lakes} if undated else ())

    v = t1r.v1(table(up=10))
    chk("rules: V1", "ten lakes renewing above the need and not below: rose", v["outcome"] == t1r.ROSE, v)
    chk("rules: V1", "the rise's line gives the counts within the lakes and the fit's expectations, and carries what "
        "held their renewal down ending, always", v["verdict"].endswith(t1r.ABATED) and "10 renewed above it and not "
        "below and 0 below it and not above" in v["verdict"] and "lower bounds" in v["verdict"], v["verdict"])
    v = t1r.v1(table(up=4, none=6))
    chk("rules: V1", "four up and none down: the rise not shown (p = 1/16)", v["outcome"] != t1r.ROSE, v)
    v = t1r.v1(table(up=5, none=5))
    chk("rules: V1", "five up and none down: rose (p = 1/32)", v["outcome"] == t1r.ROSE, v)
    v = t1r.v1(table(both=10))
    chk("rules: V1", "lakes renewing below the need as well as above it: not rose, whatever the fit allows at their "
        "low levels (round 1's R-01)", v["outcome"] == "not decided" and v["expected at their levels below the need, "
        "by the fit (reported)"] < 2, v)
    v = t1r.v1(table(single=10))
    chk("rules: V1", "lakes with no year below the need do not show the rise", v["outcome"] != t1r.ROSE, v)
    v = t1r.v1(table(none=10))
    chk("rules: V1", "none renewing: fell short, its line carrying the three clauses",
        v["outcome"] == t1r.SHORT and all(q in v["verdict"] for q in (t1r.SUPPRESSED, t1r.OWN_NEEDS, t1r.YOUNG))
        and "some of these lakes at least" in v["verdict"], v)
    v = t1r.v1(table(up=2, both=3, none=5, high=1.2))
    chk("rules: V1", "neither shown: not decided, its line saying 'not shown' both ways (round 1's R-07)",
        v["outcome"] == "not decided" and "not shown more often above" in v["verdict"]
        and "not shown fewer than" in v["verdict"], v)
    v = t1r.v1(table(up=9))
    chk("rules: V1", "nine lakes: not decided, its line opening with the counts", v["outcome"] == "not decided"
        and v["verdict"].startswith("not decided: of 9 lakes") and "fewer than 10" in v["verdict"], v)
    v = t1r.v1(table(up=10, other=False))
    chk("rules: V1", "the other records not read for a lake that rose: unless unrecorded stocking",
        "unrecorded stocking" in v["verdict"], v["verdict"])
    v = t1r.v1(table(up=10, undated=True))
    chk("rules: V1", "a lake that rose with a stocking's date unread: unless unrecorded stocking (round 1's R-04)",
        "unrecorded stocking" in v["verdict"], v["verdict"])
    v = t1r.v1(table(up=10))
    chk("rules: V1", "a seepage lake's rise needs no clause of connected waters, nor dated records one of unrecorded "
        "stocking", "connected waters" not in v["verdict"] and "unrecorded stocking" not in v["verdict"], v["verdict"])
    v = t1r.v1(table(up=10, closed=False), closed="not decided: of 0 lakes")
    chk("rules: V1", "open lakes rising, the closed lakes alone not deciding: unless connected waters",
        "connected waters" in v["verdict"], v["verdict"])
    v = t1r.v1(table(none=10), own=t1r.SHORT + ": ...")
    chk("rules: V1", "the own-level reading, a shortfall there too, keeps the clause of own needs", t1r.OWN_NEEDS in v["verdict"]
        and v["the lakes restored to their own renewing level alone, read before the clauses"].startswith(t1r.SHORT), v)
    lo_, hi_ = t1r.tails([0.5, 0.5], 1)
    chk("rules: the tails", "two fair trials: at most one 0.75, at least one 0.75", abs(lo_ - 0.75) < 1e-12 and abs(hi_ - 0.75) < 1e-12)


def additions_checks(chk):
    """T1R's reading beyond T1N's reader, on synthetic files: dates, the lakes undated and their facts, R8 and its
    scale, the fall surveys repeated, and that the facts read no value."""
    lakes, dated = archive("renewal lost, dated", 0, 0.1, 30)
    moved = {lk["id"]: dated[lk["id"]] for lk in lakes if dated.get(lk["id"])}
    marks_map = {lakes[0]["id"]: {2010: 0.25}}
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        additions.write_synthetic(lakes, tmp, moved, marks_map)
        got, undated, facts = additions.dated(tmp)
        want = {lid: set(ys) for lid, ys in moved.items()}
        chk("additions", "the dates read back as the years the stockings were made, no lake undated",
            all(want[l] <= got.get(l, set()) for l in want) and not undated, (sorted(want.items())[:3], sorted(got.items())[:3]))
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
        c = additions.MARKS["columns"]
        p.write_text(f"{c['lake']},{c['year']},{c['unmarked share']}\nA,2010,25\nB,2011,0.5\nB,2011,0.6\nC,2012,0.4\n")
        m, mf = additions.marks(tmp)
        chk("additions", "R8 with a share above 1 is not read, the file perhaps giving percentages (round 1's R-11)",
            m is None and mf["R8 shares above 1"] == 1, mf)
        p.write_text(f"{c['lake']},{c['year']},{c['unmarked share']}\nB,2011,0.5\nB,2011,0.6\nC,2012,0.4\nC,2012,0.4\n")
        m, mf = additions.marks(tmp)
        chk("additions", "R8's lake-year given twice with different shares is dropped and counted; given twice alike, read",
            m == {"C": {2012: 0.4}, "B": {}} and mf["R8 lake-years given twice with different shares, dropped"] == 1, (m, mf))
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        got, undated, facts = additions.dated(tmp)
        chk("additions", "stocking files with no date column: no dates, and the facts say so",
            got is None and "no date column" in facts[reader.FILES["stocking"]], facts)
        stocked_lakes = sorted({lk["id"] for lk in lakes if lk["stocked"]})
        additions.write_synthetic(lakes, tmp, unreadable={stocked_lakes[0]})
        got, undated, facts = additions.dated(tmp)
        chk("additions", "a lake whose stocking's date has no readable year is undated, and the others are not "
            "(round 1's R-04)", undated == {stocked_lakes[0]} and stocked_lakes[0] not in got
            and facts["lakes with a walleye stocking whose date could not be read"] == 1, (undated, facts))
        p = tmp / reader.FILES["stocking"]
        rows = list(csv.DictReader(p.open()))
        far = next(r for r in rows if reader.code(r[reader.COLUMNS["stocking"]["lake"]]) == stocked_lakes[1]
                   and reader.is_species(r[reader.COLUMNS["stocking"]["species"]]))
        far[additions.DATES["stocking"]] = "25000"
        with p.open("w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0]))
            w.writeheader()
            w.writerows(rows)
        got, undated, facts = additions.dated(tmp)
        chk("additions", "a date more than a year from its entry is read as no date, its lake undated and the row "
            "counted (round 2's R-22)", stocked_lakes[1] in undated and facts[reader.FILES["stocking"]][
                "walleye rows whose date falls more than a year from their entry, read as no date"] == 1, facts)
        p = tmp / reader.FILES["age0"]
        rows = list(csv.DictReader(p.open()))
        with p.open("a", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0]))
            w.writerow(rows[0])
        key = (reader.code(rows[0][reader.COLUMNS["age0"]["lake"]]), reader.year_of(rows[0][reader.COLUMNS["age0"]["year"]]))
        chk("additions", "a lake-year with two fall-survey rows is found by its lake and year alone (round 1's R-13)",
            additions.repeated_fall(tmp) == {key}, additions.repeated_fall(tmp))
    chk("additions", "a date's year in the files' forms (round 1's R-04)", [additions.date_year(t) for t in
        ("2014-05-02", "5/2/2014", "2014/05/02", "02-May-2014", "", "5/2/14", "13/2/94", "2014-2015", "20140502",
         "41761", "41761.5", "5/2/2014-5/9/2014", "02-May-14", "spring", "32/1/14", "1/0/1900", "FY2015", "2014-15",
         "May 2, 2014", "2014-05-02 00:00:00", "5/2/2014 - 5/9/2015")]
        == [2014, 2014, 2014, 2014, None, 2014, 1994, None, 2014, 2014, 2014, 2014, 2014, None, None, None, None, None,
            2014, 2014, None])


def run_checks(chk):
    """run.py end to end on synthetic files, and its refusals of R8 unrecorded."""
    lakes, dated = archive("need", 0, 0.1, 300)
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        additions.write_synthetic(lakes, tmp)
        out = RUN.run(tmp, check_frozen=False, check_inputs=False)
        back = list(reader.read_all(tmp)[0].values())
        nd = t1n.need(back, labels=t1n.labels_per_year(back))
        d, u, _ = additions.dated(tmp)
        want = t1r.read(back, nd, d, undated=u)["V1"]["verdict"] if nd["need"] is not None else None
        chk("the run", "V1 is the rules' own on the lakes T1N's reader builds, with the dates read",
            nd["need"] is not None and out["V1"]["verdict"] == want, (out["V1"].get("verdict"), want))
        chk("the run", "the lakes T1N also reads, the repeated fall surveys and the run without the disclosed lakes "
            "are reported", all(k in out for k in ("lakes T1R reads that T1N also reads (reported)",
                                                   "without the lakes a search summary showed (reported)",
                                                   "years with more than one fall survey, read at the largest catch "
                                                   "(reported)")), sorted(out))
        (tmp / additions.MARKS["file"]).write_text("WBIC,Survey Year,Unmarked Share\n")
        saved = (RUN.T1N_RUN.once, RUN.T1N_RUN.inputs, RUN.DOWNLOADS, RUN.HERE)
        try:
            RUN.T1N_RUN.once, RUN.T1N_RUN.inputs = (lambda repo, rel: None), (lambda folder: {})
            RUN.HERE = tmp / "experiments" / "stocked-above-the-need"     # a stand-in repository's folder
            RUN.DOWNLOADS = tmp / "no-downloads.json"
            chk("the run", "refuses R8 in the folder with no downloads.json of T1R's",
                "does not record it" in refusal(lambda: RUN.inputs(tmp)))
            RUN.DOWNLOADS = tmp / "downloads.json"
            RUN.DOWNLOADS.write_text(json.dumps({"files": []}))
            chk("the run", "refuses R8 in the folder with a downloads.json of T1R's that does not record it (round 1's R-10)",
                "does not record it" in refusal(lambda: RUN.inputs(tmp)))
        finally:
            RUN.T1N_RUN.once, RUN.T1N_RUN.inputs, RUN.DOWNLOADS, RUN.HERE = saved


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
    out = {f"worlds, {LAKES} lakes an archive": worlds(chk)}
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
