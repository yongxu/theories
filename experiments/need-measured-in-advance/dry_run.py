"""T1N's dry run (DESIGN.md, section 8): synthetic archives of walleye lakes in worlds with and without a need,
read by the frozen rules; the rules on scripted lakes; the reader and the run on synthetic files in the assumed
layout; and the freeze's chain in stand-in git repositories. No value of the archive is read, nothing is
downloaded, and no model is called.

    python3 -B tools/research/gate.py hold -- python3 -B experiments/need-measured-in-advance/dry_run.py
                                       # writes results/dry-run.json

A synthetic lake, year by year from 1990 to 2025: spring adults per acre x; fall age-0 per mile r = R(x) e^(s z),
R(x) = A x^q / (K^q + x^q); next spring x' = S x - h + C r(t - 3), with the lake's draw h = e x, cut to 0.05 x
below one adult per acre, as safe harvests are, and in a year, with chance KNOCK, nine tenths of the adults
lost (a winterkill). The recorders estimate adults every 3 to 5 years (log-normal error, CV 0.25, and a 95%
interval) and survey age-0 most years; 40% of lakes are speared and their tribal harvest recorded, angling only
in creel years; managers stock a lake below one adult per acre with a chance a year (the speed) and relabel it;
a lake is a recorded seepage lake with chance 0.4. The worlds (WORLDS) are in three families: T1 holds (a
need, renewal stopping below it), the need misplaced (where the surveys put a need, T1 is false, or holds only
within the intervals' margin), and no need (renewal never stops with the level, though it may fail by chance or
stop for another reason); a fourth, half the lakes with a need, is reported apart. Standard library only;
seeded.
"""

import contextlib
import csv
import re
import hashlib
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
import t1n                       # noqa: E402
import reader                    # noqa: E402
import run as RUN                # noqa: E402

SEED = "T1N-dry-run-2026-11-05"
ARCHIVES = 40                   # synthetic archives a world and speed
LAKES, BIG = 300, 900           # lakes an archive; and in the report of a plain refutation's reach
YEARS = range(1990, 2026)
A, K, S, C = 60.0, 1.5, 0.70, 0.03     # with these, a lake exploited above 0.3 a year keeps no level
SIGMA_R, CV, KNOCK = 0.8, 0.25, 0.02
STOCK_BELOW, CUT = 1.0, 0.05    # managers stock a lake below this many adults per acre, and cut its draw to CUT x
STOCK_SPEEDS = (0.3, 0.1, 0.03, 0.0)
NO_NEED_POSITIVE_MAX = 5        # of 40: a level of 0.05 exceeds 5 positive outcomes in 40 archives with chance 0.014
ALPHA_REPORT = 0.05             # the renewal report counted as beyond the fit at this chance (reported, no verdict)
FROZEN_FILES = ("t1n.py", "reader.py", "run.py", "dry_run.py", "layout.json")   # the files the dry run runs with
WORLDS = {
    # T1 holds: renewal stops below a need
    "need": dict(family="T1 holds", q=3),
    "needs vary": dict(family="T1 holds", q=3, k_spread=math.log(2)),
    "need rises": dict(family="T1 holds", q=3, k_after=2.0),
    "relabelled": dict(family="T1 holds", q=3, relabel=0.03),
    "unrecorded": dict(family="T1 holds", q=3, unrecorded=1 / 3, other_read=False),
    "unrecorded, read": dict(family="T1 holds", q=3, unrecorded=1 / 3),
    "open": dict(family="T1 holds", q=3, immigration=0.15),
    "episodic": dict(family="T1 holds", q=3, sigma_r=1.6),
    "unsurveyed": dict(family="T1 holds", q=3, no_estimate_below=0.03),            # no estimate of a lake this low
    "unsurveyed early": dict(family="T1 holds", q=3, no_estimate_below=0.15),      # reported: surveys stopping early
    "static labels": dict(family="T1 holds", q=3, static_labels=True),
    "estimates widen": dict(family="T1 holds", q=3, cv_low=(2.0, 0.5, 1.0)),      # mark-recapture's CV at low density
    "labels follow failure": dict(family="T1 holds", q=3, remnant=(3, 0.5)),      # recorders relabel a failing lake
    "labels follow failure, slowly": dict(family="T1 holds", q=3, remnant=(3, 0.2)),
    "estimates inflate at low density": dict(family="T1 holds", q=3, bias_low=(1.0, 0.7)),
    "intervals understate the error": dict(family="T1 holds", q=3, true_low=(2.0, 0.7, 1.5)),
    "inflated and understated": dict(family="T1 holds", q=3, bias_low=(2.0, 0.5), true_low=(2.0, 0.5, 1.0)),
    # the need misplaced: T1 false where the age-0 surveys put a need
    "survival compensates": dict(family="need misplaced", q=3, gamma=0.3, c_gamma=0.40),
    "compensates, relabelled": dict(family="need misplaced", q=3, gamma=0.3, c_gamma=0.40, relabel=0.03),
    "need falls": dict(family="need misplaced", q=3, k_after=0.5),          # within the intervals' margin: reported
    "need falls far": dict(family="need misplaced", q=3, k_after=0.25),
    "weak depensation": dict(family="need misplaced", q=1.5, sigma_r=1.6),  # stopping well below the 50% point
    "renewal below the floor": dict(family="need misplaced", q=3, gamma=0.3, c_gamma=0.10),
    # no need: renewal never stops with the level; its chance failures independent from year to year
    "no need": dict(family="no need", q=1),
    "no need, catch 0.1": dict(family="no need", q=1, catch=0.1),                 # the need fitted where T1's world's is
    "lakes differ 0.5": dict(family="no need", q=1, prod_spread=0.5),
    "lakes differ 0.7": dict(family="no need", q=1, prod_spread=0.7),
    "lakes differ 1.0": dict(family="no need", q=1, prod_spread=1.0),
    "lakes differ 1.5": dict(family="no need", q=1, prod_spread=1.5),
    "lakes differ 0.7, catch 0.1": dict(family="no need", q=1, prod_spread=0.7, catch=0.1),
    "lakes differ 1.5, catch 0.1": dict(family="no need", q=1, prod_spread=1.5, catch=0.1),
    "general decline": dict(family="no need", q=1, decline=0.04),
    "general decline, catch 0.1": dict(family="no need", q=1, decline=0.04, catch=0.1),
    "no need, relabelled": dict(family="no need", q=1, prod_spread=0.7, relabel=0.03),
    "no need, unsurveyed": dict(family="no need", q=1, prod_spread=0.7, no_estimate_below=0.15),
    "renewal unseen": dict(family="no need", q=1, unseen=0.5),
    "floor by chance": dict(family="no need", q=1, floor_chance=(-0.847, 0.6)),
    "episodic, no need": dict(family="no need", q=1, sigma_r=2.5),
    "episodic, lakes differ": dict(family="no need", q=1, sigma_r=2.0, prod_spread=1.0),
    # renewal lost to another cause (habitat, warming), whatever the level: reported, with no bound (DESIGN.md, §8)
    "renewal stops after": dict(family="renewal lost", q=1, prod_spread=0.7, collapse=0.2),   # a fifth, after 2012
    "renewal stops after, lakes differ widely": dict(family="renewal lost", q=1, prod_spread=1.5, collapse=0.2),
    "no renewal in some": dict(family="renewal lost", q=1, prod_spread=0.5, none=0.15),
    "renewal lost before, catch 0.1": dict(family="renewal lost", q=1, catch=0.1, loss=(0.3, 1998, 2012)),
    "renewal lost before, lakes differ": dict(family="renewal lost", q=1, prod_spread=0.7, loss=(0.3, 1998, 2012)),
    "renewal lost across the cutoff": dict(family="renewal lost", q=1, prod_spread=1.0, loss=(0.3, 2005, 2020)),
    "renewal lost in spells": dict(family="renewal lost", q=1, spells=(0.05, 0.05, 0.02)),      # spells of 20 years
    "renewal lost in spells, lakes differ": dict(family="renewal lost", q=1, prod_spread=0.7, spells=(0.05, 0.1, 0.02)),
    # reported apart
    "half need": dict(family="mixed", q_mix=(3, 1)),
}
NATURAL, STOCKED, REMNANT = t1n.NR, "stocked", "remnant"


class Checks:
    def __init__(self):
        self.by_kind, self.failed = {}, []

    def __call__(self, kind, name, ok, detail=None):
        self.by_kind[kind] = self.by_kind.get(kind, 0) + 1
        if not ok:
            self.failed.append({"kind": kind, "check": name, "detail": detail})


def code_hashes():
    """The sha-256 of each file the dry run runs with, repository-relative."""
    rel = HERE.relative_to(HERE.parents[1])
    return {str(rel / f): hashlib.sha256((HERE / f).read_bytes()).hexdigest() for f in FROZEN_FILES}


def recruitment(x, q, k, a):
    return a * x ** q / (k ** q + x ** q) if x > 0 else 0.0


def lake(rng, i, world, speed):
    """One synthetic lake's records, as reader.py builds them."""
    w = WORLDS[world]
    q = w["q_mix"][i % 2] if "q_mix" in w else w["q"]
    acres = math.exp(rng.uniform(math.log(100), math.log(5000)))
    k0 = K * math.exp(rng.gauss(0, w["k_spread"])) if w.get("k_spread") else K
    spread = w.get("prod_spread", 0.0)
    a0 = A * math.exp(rng.gauss(0, spread)) if spread else A
    c0 = C * math.exp(rng.gauss(0, spread)) if spread else C
    e = rng.uniform(0.05, 0.6)
    speared, closed = rng.random() < 0.4, rng.random() < 0.4
    x = rng.uniform(1.5, 8.0)
    none = "none" in w and rng.random() < w["none"]                   # a lake with no renewal at all
    collapse = "collapse" in w and rng.random() < w["collapse"]       # a lake whose renewal stops after the cutoff
    hist = {}
    rec = {"id": f"L{i:04d}", "acres": acres, "label": {}, "adults": {}, "age0": {}, "harvest": {}, "creel": set(),
           "stocked": set(), "closed": closed, "other": set() if w.get("other_read", True) else None}
    unrec = set()
    phase, every = rng.randrange(5), rng.choice((3, 4, 5))
    surveyed = rng.random() < 0.7
    loss_year = None
    if "loss" in w:                                    # (share, first year, last year): renewal lost from a year on
        share, y0, y1 = w["loss"]
        if rng.random() < share:
            loss_year = rng.randint(y0, y1)
    bad = (rng.random() < w["spells"][0] / (w["spells"][0] + w["spells"][1])) if "spells" in w else False
    label, rescued = NATURAL, False
    for yr in YEARS:
        k = k0 * (w.get("k_after", 1.0) if yr > t1n.CUTOFF else 1.0)
        a = a0 * (1 - w.get("decline", 0.0)) ** (yr - 1990)
        if "spells" in w:                              # (p into, p out of, factor): renewal cut in chance spells
            p_in, p_out, factor = w["spells"]
            bad = (rng.random() >= p_out) if bad else (rng.random() < p_in)
            if bad:
                a *= factor
        if none or (collapse and yr > t1n.CUTOFF) or (loss_year is not None and yr >= loss_year):
            a = 0.0
        sr = w.get("sigma_r", SIGMA_R)
        r = recruitment(x, q, k, a) * math.exp(sr * rng.gauss(0, 1) - sr * sr / 2 + SIGMA_R * SIGMA_R / 2)
        hist[yr] = r
        rec["label"][yr] = label
        if (yr - 1990 + phase) % every == 0 and x >= w.get("no_estimate_below", 0.0):
            cv = CV
            if "cv_low" in w:                          # (x0, power, cap): error, and its interval, widening below x0
                x0, pw, cap = w["cv_low"]
                cv = min(cap, CV * max(1.0, (x0 / max(x, 1e-9)) ** pw))
            stated = cv
            if "true_low" in w:                        # (x0, power, cap): the true error widening, the interval not
                x0, pw, cap = w["true_low"]
                cv = min(cap, CV * max(1.0, (x0 / max(x, 1e-9)) ** pw))
            est = x * math.exp(cv * rng.gauss(0, 1) - cv * cv / 2)
            if "bias_low" in w and x < w["bias_low"][0]:   # (x0, power): estimates inflated below x0 by (x0 / x)^power
                est *= (w["bias_low"][0] / max(x, 1e-9)) ** w["bias_low"][1]
            rec["adults"][yr] = (est, est * math.exp(-1.96 * stated), est * math.exp(1.96 * stated))
        if surveyed or rng.random() < 0.4:
            seen = x / (x + w["unseen"]) if "unseen" in w else 1.0
            rec["age0"][yr] = round(r * seen * w.get("catch", 1.0) * math.exp(0.3 * rng.gauss(0, 1)), 1)
            if "floor_chance" in w:                # the survey reaches the floor by a chance rising slowly with x
                b0, b1 = w["floor_chance"]
                rec["age0"][yr] = 5.0 if x > 0 and rng.random() < 1 / (1 + math.exp(-(b0 + b1 * math.log(x)))) else 0.0
        if "remnant" in w and label == NATURAL:        # (k, p): recorders relabel a lake whose last k surveys failed
            k_run, p_relabel = w["remnant"]
            run_ = 0
            for t in range(yr, yr - 12, -1):
                if t in rec["age0"]:
                    if rec["age0"][t] < t1n.FLOOR:
                        run_ += 1
                    else:
                        break
            if run_ >= k_run and rng.random() < p_relabel:
                label = REMNANT
        h = (e if x >= STOCK_BELOW else CUT) * x
        creel = rng.random() < 0.2
        recorded = (0.6 * h if speared else 0.0) + (0.4 * h if creel else 0.0)
        if recorded:
            rec["harvest"][yr] = recorded
        if creel:
            rec["creel"].add(yr)
        add = 0.0
        if x < STOCK_BELOW and rng.random() < speed:
            if w.get("unrecorded") and (rescued or rng.random() < w["unrecorded"]):
                rescued = True                     # stocked outside WDNR's database, the label kept
                unrec.add(yr)
            else:
                rec["stocked"].add(yr)
                label = STOCKED
            add = 1.0
        elif yr > t1n.CUTOFF and rng.random() < w.get("relabel", 0.0):
            rec["stocked"].add(yr)                 # a programme's stocking and relabelling, whatever the stock
            label = STOCKED
            add = 1.0
        r3 = hist.get(yr - 3, recruitment(x, q, k, a))
        joins = w["c_gamma"] * r3 ** w["gamma"] if "gamma" in w else c0 * r3
        x = max(S * x - h + joins + add + (0.0 if closed else w.get("immigration", 0.0)), 0.0)
        if rng.random() < KNOCK:
            x *= 0.1
    if rec["other"] is not None:
        rec["other"] = unrec if w.get("unrecorded") else set()
    if w.get("static_labels"):
        final = rec["label"][max(YEARS)]
        rec["label"] = {yr: final for yr in rec["label"]}
    return rec


def archive(world, a, speed=0.1, lakes=LAKES):
    rng = random.Random("|".join((SEED, world, str(speed), str(a), str(lakes))))
    return [lake(rng, i, world, speed) for i in range(lakes)]


def verdict_of(lakes, world, label_alone=False):
    """V1 on a synthetic archive as run.py reads it: the labels per year unless no lake's label changes."""
    labels = t1n.labels_per_year(lakes)
    nd = t1n.need(lakes, labels=labels)
    if nd["need"] is None:
        return "not decided", None, nd
    res = t1n.read(lakes, nd["need"], labels=labels, label_alone=label_alone)
    res["renewal below the need"] = t1n.renewal_below(lakes, nd, labels=labels)
    return res["V1"]["verdict"], res, nd


DID, DID_V2 = "second form not met", "second form not met, V2 met"    # V1's positive outcome, and with V2 met


def kind(v):
    if v.startswith(t1n.SEPARATED):
        m = re.search(r"(\d+) of them with every year of the lag surveyed", v)
        return DID_V2 if m and int(m.group(1)) else DID
    if v.startswith(t1n.STRONGEST):
        return "refuted"                       # the strongest form: the residual clause alone (DESIGN.md, §7)
    if v.startswith("refuted unless"):
        return "refuted unless"
    return "not decided"


def worlds(chk):
    """Each world's verdicts over ARCHIVES archives at each speed, and the checks on them."""
    out = {}
    for world, w in WORLDS.items():
        out[world] = {"family": w["family"]}
        for speed in STOCK_SPEEDS:
            tallies, alone, needs, n_below, v2, flagged = {}, {}, [], [], 0, 0
            for a in range(ARCHIVES):
                lakes = archive(world, a, speed)
                v, res, nd = verdict_of(lakes, world)
                tallies[kind(v)] = tallies.get(kind(v), 0) + 1
                needs.append(nd["need"])
                if res:
                    n_below.append(res["V1"]["below: resolved"])
                    v2 += res["V2"]["met"]
                    rb = res["renewal below the need"]
                    flagged += bool(rb and rb["lake-years"] and rb["chance of so many or more under the fit"] <= ALPHA_REPORT)
                if "relabel" in w:
                    va = verdict_of(lakes, world, label_alone=True)[0]
                    alone[kind(va)] = alone.get(kind(va), 0) + 1
            fitted = sorted(y for y in needs if y is not None)
            cell = {"V1": tallies, "V2 met": v2,
                    "renewal below the need beyond the fit at 0.05 (reported)": flagged,
                    "the fitted need: median, largest": [round(fitted[len(fitted) // 2], 3), round(fitted[-1], 3)] if fitted else None,
                    "no need fitted": sum(1 for y in needs if y is None),
                    "resolved lakes below the need, median": sorted(n_below)[len(n_below) // 2] if n_below else None}
            if alone:
                cell["V1 with the label alone a fall"] = alone
            out[world][f"speed {speed}"] = cell
            did = tallies.get(DID, 0) + tallies.get(DID_V2, 0)
            if w["family"] == "no need" or (w["family"] == "need misplaced" and world != "need falls"):
                chk(f"worlds: {w['family']}", f"{world} at speed {speed}: T1's forbidden case found not to occur in at most "
                    f"{NO_NEED_POSITIVE_MAX} of {ARCHIVES}", did <= NO_NEED_POSITIVE_MAX, tallies)
            if world in ("open", "unrecorded", "unsurveyed", "static labels", "estimates widen",
                         "estimates inflate at low density", "intervals understate the error", "inflated and understated"):
                chk("worlds: confounds", f"{world} at speed {speed}: no refutation in its strongest form where T1 holds",
                    tallies.get("refuted", 0) <= NO_NEED_POSITIVE_MAX, tallies)
    t = out["need"]["speed 0.0"]["V1"]           # the draft's bar, set before any of these results; 0.03 reported (§8)
    chk("worlds: power", f"need with no managers: T1's forbidden case found not to occur in at least 30 of {ARCHIVES}",
        t.get(DID, 0) + t.get(DID_V2, 0) >= 30, t)
    for world, speeds in (("renewal below the floor", (0.1, 0.03, 0.0)), ("weak depensation", (0.0,))):
        for speed in speeds:
            t = out[world][f"speed {speed}"]["V1"]
            chk("worlds: power", f"{world} at speed {speed}: refuted, in some form, more often than the positive outcome",
                t.get("refuted", 0) + t.get("refuted unless", 0) > t.get(DID, 0) + t.get(DID_V2, 0), t)
    chk("worlds: the renewal report", f"need falls far at speed 0.0: renewal below the need beyond the fit in at least 30 of {ARCHIVES}",
        out["need falls far"]["speed 0.0"]["renewal below the need beyond the fit at 0.05 (reported)"] >= 30,
        out["need falls far"]["speed 0.0"])
    for speed in (0.03, 0.0):
        chk("worlds: the renewal report", f"need at speed {speed}: renewal below the need beyond the fit in at most {NO_NEED_POSITIVE_MAX} of {ARCHIVES}",
            out["need"][f"speed {speed}"]["renewal below the need beyond the fit at 0.05 (reported)"] <= NO_NEED_POSITIVE_MAX,
            out["need"][f"speed {speed}"])
    for world in ("weak depensation", "renewal below the floor", "inflated and understated"):   # the last two reported
        big = {}
        for speed in (0.03, 0.0):
            tallies = {}
            for a in range(ARCHIVES):
                v = kind(verdict_of(archive(world, a, speed, lakes=BIG), world)[0])
                tallies[v] = tallies.get(v, 0) + 1
            big[f"speed {speed}"] = tallies
        out[f"{world}, {BIG} lakes an archive"] = big
        if world == "weak depensation":
            chk("worlds: power", f"weak depensation at {BIG} lakes: a refutation in its strongest form reached",
                sum(t.get("refuted", 0) for t in big.values()) > 0, big)
    return out


def refusal(f):
    try:
        f()
    except SystemExit as e:
        return str(e)
    return ""


def scripted(chk):
    """The rules on scripted lakes: each verdict at its thresholds, the separation, the null, the premise, the
    scope, the ratio test, the fate and its recovery, renewal pending and the surveys set aside, V2, the
    confounds, the static labels and the renewal report."""
    y = 1.0

    def lk(i, x, fate_est, label=NATURAL, label_fate=None, stocked=(), width=0.1, age0=None, held=True,
           closed=True, other=True):
        adults = {2013: (x, x * (1 - width), x * (1 + width)),
                  2017: (fate_est, fate_est * (1 - width), fate_est * (1 + width))}
        if held:
            adults.update({2004: (3.0, 2.7, 3.3), 2008: (3.0, 2.7, 3.3)})
        labels = {t: NATURAL for t in adults}
        labels[2013], labels[2017] = label, label_fate or label
        return {"id": f"S{i}", "acres": 100.0, "label": labels, "adults": adults,
                "age0": dict(age0) if age0 is not None else {2010: 0.0, 2011: 0.0, 2012: 0.0},
                "harvest": {}, "creel": set(), "stocked": set(stocked), "closed": closed,
                "other": set() if other else None}

    def v1(lakes):
        return t1n.read(lakes, y, last=2014)["V1"]

    above = [lk(500 + i, 3.0, 3.0) for i in range(20)]       # above the need, persisting: the other side
    for n in (10, 14, 20):
        c = t1n.critical(n)
        for fell, want in ((c, t1n.SEPARATED), (c - 1, "not decided"),
                           (n // 2, "refuted" if n >= t1n.N_REFUTE else "not decided"),
                           (n - c, "refuted"), (n - c + 1, "refuted" if n >= t1n.N_REFUTE else "not decided")):
            lakes = [lk(i, 0.5, 0.2 if i < fell else 2.0) for i in range(n)] + above
            v = v1(lakes)["verdict"]
            chk("rules: V1", f"{fell} of {n} below the need fell: {want}", v.startswith(want), v)
    v = v1([lk(i, 0.5, 0.2) for i in range(t1n.N_MIN - 1)] + above)["verdict"]
    chk("rules: V1", "fewer than N_MIN resolved below the need: not decided", v.startswith("not decided"), v)
    falling_above = [lk(600 + i, 3.0, 0.3) for i in range(20)]
    v = v1([lk(i, 0.5, 0.2) for i in range(12)] + falling_above)["verdict"]
    chk("rules: the separation", "below the need fell, but the lakes above fell as often: not decided",
        v.startswith("not decided") and "above it fell as often" in v, v)
    v = v1([lk(i, 0.5, 0.2) for i in range(12)])["verdict"]
    chk("rules: the separation", "no resolved lake above the need: not the positive outcome", not v.startswith(t1n.SEPARATED), v)
    t = t1n.rows([lk(1, 0.5, 0.2, held=False)], y, last=2014)
    chk("rules: the premise", "a lake not shown to hold above the need before the cutoff: out",
        t[0].get("out", "").startswith("the premise not shown"), t)
    l = lk(2, 0.5, 0.2)
    l["adults"][2008] = (1.0, 0.9, 1.1)
    chk("rules: the premise", "two estimates up to the cutoff, one with its lower bound below the need: not shown",
        t1n.held_above(l, y) is None, t1n.held_above(l, y))
    l = lk(3, 0.5, 0.2)
    l["stocked"] = {2003}
    chk("rules: the premise", "held only with stocking recorded before it: not shown", t1n.held_above(l, y) is None)
    l = lk(26, 0.5, 0.2)
    l["adults"][2004] = (6.0, 5.4, 6.6)
    chk("rules: the premise", "a pair above the need with a decline between them by the ratio test: not shown",
        t1n.held_above(l, y) is None, t1n.held_above(l, y))
    l = lk(30, 1.0, 0.8)
    z = t1n.change(l, 2013, 2017)
    chk("rules: the ratio test", "a change against its value by hand (ln 0.8 over the intervals' joint sd, -3.0823)",
        abs(z + 3.0823) < 1e-3, z)
    for why, l in (("label at the reference", lk(4, 0.5, 0.2, label=STOCKED)),
                   ("stocking recorded before the reference", lk(5, 0.5, 0.2, stocked=(2010,))),
                   ("stocking recorded before the reference", lk(6, 0.5, 0.2, stocked=(2013,)))):
        t = t1n.rows([l], y, last=2014)
        chk("rules: the scope", f"out of scope: {why}", t[0].get("out", "").startswith(why), t)
    def with_later(l, year, est, width=0.1):
        l["adults"][year] = (est, est * (1 - width), est * (1 + width))
        l["label"][year] = NATURAL
        return l
    unread_interval = lk(24, 0.5, 0.2)
    unread_interval["adults"][2017] = (0.0, 0.0, 0.3)
    for name, l, want, by in (
            ("a decline by the ratio test", lk(7, 0.5, 0.2), "fell", "a decline by the ratio test"),
            ("holding below the need: a quarter kept by the ratio's lower bound", lk(8, 0.5, 0.48), "persisted", "quarter kept"),
            ("a change within the intervals' error, a quarter kept", lk(21, 0.5, 0.45, width=0.2), "persisted", "quarter kept"),
            ("intervals too wide to show a fall or a quarter kept", lk(33, 0.5, 0.4, width=0.9), "unresolved", "neither"),
            ("back above the need: a return", lk(9, 0.5, 2.0), "persisted", "quarter kept"),
            ("a decline, and a recovery by a later survey", with_later(lk(22, 0.5, 0.2), 2020, 0.5), "persisted", "recovery"),
            ("a decline, and a recovery not shown to keep a quarter", with_later(lk(34, 0.5, 0.05), 2020, 0.12),
             "unresolved", "quarter not shown kept"),
            ("a decline, the later rise after recorded stocking: the fall stands",
             with_later(lk(23, 0.5, 0.2, stocked=(2018,)), 2020, 0.5), "fell", "a decline by the ratio test"),
            ("stocking after the reference", lk(10, 0.5, 3.0, stocked=(2015,)), "unresolved", "stocking"),
            ("the label to a combination", lk(11, 0.5, 0.1, label_fate="combination", stocked=(2015,)), "unresolved", "label left"),
            ("the label to stocked", lk(12, 0.5, 0.1, label_fate=STOCKED, stocked=(2015,)), "unresolved", "label left"),
            ("an interval not read on the log scale", unread_interval, "unresolved", "log scale"),
            ("a lake above the need falling below it", lk(13, 3.0, 0.3), "fell", "a decline by the ratio test"),
            ("above the need, declining and still above it: the same reading", lk(25, 3.0, 1.5), "fell", "a decline")):
        t = t1n.rows([l], y, last=2014)
        chk("rules: the fate", f"{name}: {want}", t[0].get("fate") == want and by in t[0].get("fate by", ""), t)
    t = t1n.rows([lk(14, 0.5, 3.0, label_fate=STOCKED, stocked=(2015,))], y, last=2014, label_alone=True)
    chk("rules: the fate", "the reading set aside: the label alone a fall", t[0]["fate"] == "fell", t)
    l = lk(15, 0.5, 3.0)
    l["other"] = {2015}
    t = t1n.rows([l], y, last=2014)
    chk("rules: the fate", "other stocking (R5b) after the reference: unresolved", t[0]["fate"] == "unresolved", t)
    for name, age0, want in (("age-0 at or above the floor before it", {2010: 0.0, 2011: 3.0, 2012: 0.0}, "renewal pending"),
                             ("a year of the lag unsurveyed", {2010: 0.0, 2012: 0.0}, "renewal unread"),
                             ("every year surveyed, all below the floor", {2010: 0.0, 2011: 0.5, 2012: 0.0}, None)):
        got = t1n.pending(lk(16, 0.5, 0.2, age0=age0), 2013)
        chk("rules: renewal pending", name, (got or "").startswith(want) if want else got is None, got)
    t = t1n.rows([lk(27, 0.5, 0.2, age0={2010: 0.0, 2011: 3.0, 2012: 0.0})], y, last=2014)
    chk("rules: renewal pending", "a survey below the need with renewal pending is set aside: out with no other reference",
        t[0].get("out") == "below the need only with renewal pending"
        and t[0].get("set aside, renewal pending") == {"ref": 2013, "fate": "fell"}, t)
    l = with_later(with_later(lk(28, 0.5, 0.2, age0={2010: 0.0, 2011: 3.0, 2012: 0.0}), 2016, 3.0), 2020, 3.0)
    del l["adults"][2017], l["label"][2017]
    t = t1n.rows([l], y, last=2017)
    chk("rules: renewal pending", "set aside, the lake's survey above the need is its reference",
        t[0].get("ref") == 2016 and t[0].get("T1 predicts") == "persists" and "set aside, renewal pending" in t[0], t)
    t = t1n.rows([lk(29, 0.3, 3.0, age0={2010: 0.0, 2012: 0.0})], y, last=2014)
    chk("rules: renewal pending", "a year of the lag unread does not set the survey aside", t[0].get("T1 predicts") == "falls", t)
    l = with_later(with_later(lk(31, 3.0, 3.0), 2016, 0.3), 2020, 0.1)
    del l["adults"][2017], l["label"][2017]
    t = t1n.rows([l], y, last=2017)
    chk("rules: the reference", "the first readable survey in time: a lake above the need there, later below it, counts above",
        t[0].get("ref") == 2013 and t[0].get("T1 predicts") == "persists" and t[0].get("fate") == "fell", t)
    l = with_later(with_later(lk(32, 1.0, 1.0, width=0.2), 2016, 0.3), 2020, 0.1)
    del l["adults"][2017], l["label"][2017]
    t = t1n.rows([l], y, last=2017)
    chk("rules: the reference", "a survey whose interval holds the need is passed over", t[0].get("ref") == 2016
        and t[0].get("T1 predicts") == "falls", t)
    v = t1n.read([lk(17, 0.3, 3.0)], y, last=2014)["V2"]
    chk("rules: V2", "below the need, nothing pending, back above it with nothing recorded given: met",
        v["met"] and [m["id"] for m in v["lakes"]] == ["S17"], v)
    v = t1n.read([lk(18, 0.3, 0.6)], y, last=2014)["V2"]
    chk("rules: V2", "risen but still below the need: not met", not v["met"], v)
    v = t1n.read([lk(19, 0.3, 3.0, age0={2011: 3.0})], y, last=2014)["V2"]
    chk("rules: V2", "a return with renewal pending: not met", not v["met"], v)
    v = t1n.read([lk(29, 0.3, 3.0, age0={2010: 0.0, 2012: 0.0})], y, last=2014)["V2"]
    chk("rules: V2", "a return with a year of the lag unread: in V1, not met", not v["met"], v)
    for name, closed, other, want in (
            ("refuted, the residual alone, where the persisting lakes are closed and R5b was read", True, True, t1n.STRONGEST),
            ("unless connected waters where they are not recorded closed", False, True, "refuted unless connected waters"),
            ("unless unrecorded stocking where R5b was not read", True, False, "refuted unless unrecorded stocking")):
        lakes = [lk(200 + i, 0.5, 2.0, closed=closed, other=other) for i in range(12)] + above
        v = v1(lakes)["verdict"]
        chk("rules: the confounds", name, v.startswith(want), v)
    lakes = [lk(300 + i, 0.5, 2.0) for i in range(10)] + above
    gone = [lk(400 + i, 0.5, 2.0) for i in range(20)]
    for g in gone:
        del g["adults"][2017]
        del g["label"][2017]
    late = with_later(lk(450, 3.0, 3.0), 2024, 3.0)       # the archive runs GAP_MAX years past the references
    v = v1(lakes + gone + [late])["verdict"]
    chk("rules: the confounds", "unless the unsurveyed fell, where counting them as fallen undoes it",
        "the unsurveyed fell" in v, v)
    t = t1n.rows(gone[:1] + above[:1], y, last=2014)
    chk("rules: the confounds", "no later estimate where the archive ends within GAP_MAX: the archive's end, not marked",
        t[0].get("out") != "below the need with no later estimate", t)
    held_wide = [lk(800 + i, 0.5, 0.35) for i in range(12)]
    for l in held_wide:
        l["adults"][2013], l["adults"][2017] = (0.5, 0.45, 0.55), (0.35, 0.14, 0.56)
    v = v1(held_wide + above)["verdict"]
    chk("rules: the confounds", "unless the intervals understate the error, where widening them below LOW_LEVEL undoes it",
        v.startswith("refuted unless the intervals understating the error at low density"), v)
    sup = [lk(i, 0.5, 0.2) for i in range(12)] + above + [lk(700, 0.3, 3.0)]
    v = v1(sup)["verdict"]
    chk("rules: V1 and V2", "the positive outcome counts the lakes that came back, and V2's with its lake",
        v.startswith(t1n.SEPARATED) and "1 came back above the need, 1 of them with every year of the lag surveyed (V2: S700)" in v
        and "causal role not shown" in v, v)
    t = t1n.rows([lk(20, 0.5, 0.2, label=STOCKED)], y, last=2014, labels=False)
    chk("rules: static labels", "where the labels are not per year, the label decides nothing", "out" not in t[0], t)
    chk("rules: the tail", "critical counts 9, 11, 15 of 10, 14, 20",
        (t1n.critical(10), t1n.critical(14), t1n.critical(20)) == (9, 11, 15))
    lb = t1n.lower_bound(9, 10)
    chk("rules: the tail", "the exact lower bound on 9 of 10, where 10 p^9 (1 - p) + p^10 = 0.05 (0.6058)",
        abs(lb - 0.6058) < 1e-3 and abs(10 * lb ** 9 * (1 - lb) + lb ** 10 - 0.05) < 1e-6, lb)
    chk("rules: the tail", "Fisher's exact test against a table by hand",
        t1n.fisher_greater(9, 10, 2, 10) == t1n.Fraction(506, 184756), float(t1n.fisher_greater(9, 10, 2, 10)))
    rb_lakes = [{"id": f"R{i}", "adults": {2015: (0.5, 0.45, 0.55)}, "age0": {2015: a0}, "label": {2015: NATURAL},
                 "stocked": set(), "other": set()} for i, a0 in enumerate((3.0, 2.0, 0.0))]
    rb = t1n.renewal_below(rb_lakes, {"need": 1.0, "a": 0.0, "b": 1.0})
    chk("rules: the renewal report", "two of three below the need renewing, each with chance 1/3 under the fit: 7/27",
        rb["reached the floor"] == 2 and abs(rb["the fit expects"] - 1.0) < 1e-9
        and abs(rb["chance of so many or more under the fit"] - 7 / 27) < 1e-6, rb)


def need_checks(chk):
    """The need's fit on synthetic pairs with a known need, and its guards."""
    rng = random.Random(SEED + "|fit")

    def pairs_lakes(prob, n=60):
        out = []
        for i in range(n):
            rec = {"id": f"F{i}", "adults": {}, "age0": {}, "label": {}, "stocked": set(), "other": set()}
            for yr in range(1995, 2013):
                x = math.exp(rng.uniform(math.log(0.1), math.log(8)))
                rec["adults"][yr] = (x, x, x)
                rec["label"][yr] = NATURAL
                rec["age0"][yr] = 5.0 if rng.random() < prob(x) else 0.0
            out.append(rec)
        return out
    known = pairs_lakes(lambda x: 1 / (1 + (0.8 / x) ** 4))
    nd = t1n.need(known)
    chk("the need", "the fit recovers a known need within 25%", nd["need"] and abs(nd["need"] / 0.8 - 1) < 0.25, nd)
    chk("the need", "too few pairs: no need", t1n.need(known[:5])["need"] is None)
    nd = t1n.need(pairs_lakes(lambda x: 0.3))
    chk("the need", "renewal at the floor with one chance at every level: no need", nd["need"] is None, nd)
    nd = t1n.need(pairs_lakes(lambda x: 1 / (1 + math.exp(0.847 - 0.3 * math.log(x)))))
    chk("the need", "a shallow rise placing the need where the data do not reach: no need", nd["need"] is None, nd)
    later = [dict(l, adults={**l["adults"], 2014: (0.01, 0.01, 0.01)}, age0={**l["age0"], 2014: 99.0}) for l in known]
    chk("the need", "years after the cutoff do not enter the fit", t1n.need(later)["need"] == t1n.need(known)["need"])
    stocked = [dict(l, stocked={2000}) for l in known]
    chk("the need", "stocked lake-years do not enter the fit", t1n.need(stocked)["pairs"] < t1n.need(known)["pairs"])
    chk("the need", "a fit that cannot converge returns None", t1n.logistic([1.0, 2.0], [0, 1], ridge=0.0, iters=1) is None)


def reader_checks(chk):
    """The reader on synthetic files in the assumed layout, its refusals, and the layout facts from structure
    alone."""
    lakes = archive("need", 0)[:20]
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        back, meta = reader.read_all(tmp)
        chk("the reader", "rebuilds the lakes from the assumed layout",
            len(back) == 20 and all(abs(back[l["id"]]["adults"][y][0] - l["adults"][y][0]) < 1e-6
                                    and back[l["id"]]["label"].get(y) == l["label"].get(y)
                                    and back[l["id"]]["closed"] == l["closed"] for l in lakes for y in l["adults"]))
        chk("the reader", "keeps stocking, creel years and age-0 surveys",
            all(back[l["id"]]["stocked"] == l["stocked"] and back[l["id"]]["creel"] == l["creel"]
                and set(back[l["id"]]["age0"]) == set(l["age0"]) for l in lakes))
        chk("the reader", "reads the labels per year where some lake's label changes",
            meta["labels per year"] is any(len(set(l["label"].values())) > 1 for l in lakes), meta)
        facts = reader.layout_facts(tmp)
        structural = {reader.COLUMNS[k][f] for k in reader.COLUMNS for f in reader.COLUMNS[k] if f in reader.STRUCTURE}
        for name in reader.FILES.values():
            p = tmp / name
            if p.exists():
                rows = list(csv.reader(p.open()))
                cols = [i for i, c in enumerate(rows[0]) if c not in structural]
                for row in rows[1:]:
                    for i in cols:
                        row[i] = "987654321"
                with p.open("w", newline="") as f:
                    csv.writer(f).writerows(rows)
        chk("the reader", "the layout facts are the same with every value column overwritten",
            reader.layout_facts(tmp) == facts, facts)
        chk("the reader", "neither the probe nor the facts hold a value column's content",
            "987654321" not in json.dumps(reader.layout(tmp)) + json.dumps(reader.layout_facts(tmp)))
    for name, spoil, want in (
            ("a file lacking a column", lambda h, r: (h.replace(reader.COLUMNS["adults"]["estimate"], "x"), r), "adult_estimates.csv lacks"),
            ("a label the map does not hold", lambda h, r: (h, r.replace(",NR,", ",Unheard,", 1)), "a label layout.json does not map")):
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            reader.write_synthetic(lakes, tmp)
            p = tmp / reader.FILES["adults"]
            head, rest = p.read_text().split("\n", 1)
            head, rest = spoil(head, rest)
            p.write_text(head + "\n" + rest)
            got = refusal(lambda: reader.read_all(tmp))
            chk("the reader", f"refuses {name}", got.startswith(want), got)
    for name, kind_, old, new, want in (
            ("a file whose lake codes match none of the estimates'", "stocking", ",", ",X", "the lake codes differ"),
            ("a stocking file with no row of the species", "stocking", reader.SPECIES, "Muskellunge", "the species' text differs")):
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            reader.write_synthetic(lakes, tmp)
            p = tmp / reader.FILES[kind_]
            head, rest = p.read_text().split("\n", 1)
            rest = "\n".join(("X" + line) if old == "," and line else line.replace(old, new) for line in rest.split("\n"))
            p.write_text(head + "\n" + rest)
            got = refusal(lambda: reader.read_all(tmp))
            chk("the reader", f"refuses {name}", want in got, got)
    chk("the reader", "codes and species in one form", reader.code(" 123456.0 ") == "123456" and reader.is_species(" WALLEYE "))
    flat = [{"label": {2010: NATURAL, 2014: NATURAL}} for _ in range(40)]
    one = flat[:39] + [{"label": {2010: NATURAL, 2014: STOCKED}}]
    few = flat[:37] + [{"label": {2010: NATURAL, 2014: STOCKED}} for _ in range(3)]
    chk("the reader", "one lake of 40 changing category does not make the labels per year; three do",
        not t1n.labels_per_year(one) and t1n.labels_per_year(few) and not t1n.labels_per_year(flat))
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        (tmp / reader.FILES["tribal"]).unlink()
        (tmp / reader.FILES["creel"]).unlink()
        back, meta = reader.read_all(tmp)
        chk("the reader", "reads without the draw's files, which V1 does not read", len(back) == 20, meta)


def run_checks(chk):
    """run.py end to end on synthetic files, and its refusals on the inputs and on a second run."""
    lakes = archive("need", 0, 0.03)
    lakes[3] = dict(lakes[3], name="Worcester Lake", county="Price")
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        reader.write_synthetic(lakes, tmp)
        out = RUN.run(tmp, check_frozen=False, check_inputs=False)
        v, res, nd = verdict_of(list(reader.read_all(tmp)[0].values()), "need")
        chk("the run", "a need is fitted on the files and V1 is the rules' own on the lakes the reader builds",
            nd["need"] is not None and out["V1"]["verdict"] == v, (out["V1"].get("verdict"), v, nd.get("reason")))
        chk("the run", "the floors are reported", set(out["by floor"]) == {f"floor {f}" for f in t1n.FLOORS_REPORTED},
            sorted(out["by floor"]))
        cell = out["by floor"][f"floor {t1n.FLOOR}"]
        chk("the run", "V1 is also read without the lakes a search summary showed, found by county and name",
            cell.get("without the lakes a search summary showed (reported)", {}).get("lakes") == [lakes[3]["id"]],
            cell.get("without the lakes a search summary showed (reported)"))
        chk("the run", "the seepage lakes alone, the reading set aside and renewal below the need are reported",
            "recorded seepage lakes alone (reported)" in cell and "V1 with the label alone a fall (the reading set aside)" in cell
            and cell.get("renewal below the need (reported)", {}).get("lake-years") is not None, sorted(cell))
        saved = RUN.DOWNLOADS
        try:
            RUN.DOWNLOADS = tmp / "downloads.json"
            chk("the run", "refuses where no download is recorded", "no download is recorded" in refusal(lambda: RUN.inputs(tmp)))
            RUN.DOWNLOADS.write_text(json.dumps({"files": [{"file": n, "sha256": "0" * 64} for n in reader.FILES.values()]}))
            chk("the run", "refuses an input that is not the file recorded", "is not the file" in refusal(lambda: RUN.inputs(tmp)))
            present = [n for n in reader.FILES.values() if (tmp / n).exists()]
            RUN.DOWNLOADS.write_text(json.dumps({"files": [{"file": n, "sha256": RUN.sha(tmp / n)} for n in present]}))
            chk("the run", "takes the inputs recorded", bool(RUN.inputs(tmp)))
            RUN.DOWNLOADS.write_text(json.dumps({"files": [{"file": n, "sha256": RUN.sha(tmp / n)} for n in present]
                                                 + [{"file": reader.FILES["types"], "sha256": "0" * 64}]}))
            chk("the run", "refuses a file downloads.json records that is missing from the folder",
                "missing from the folder" in refusal(lambda: RUN.inputs(tmp)))
            RUN.DOWNLOADS.write_text(json.dumps({"files": [{"file": n, "sha256": RUN.sha(tmp / n)} for n in present[1:]]}))
            chk("the run", "refuses an input file downloads.json does not record",
                "not recorded in downloads.json" in refusal(lambda: RUN.inputs(tmp)))
        finally:
            RUN.DOWNLOADS = saved
        saved_out, saved_argv = RUN.OUT, sys.argv
        try:
            RUN.OUT = tmp / "run.json"
            RUN.OUT.write_text("{}")
            sys.argv = ["run.py", str(tmp)]
            chk("the run", "refuses a second run", "the run is made once" in refusal(RUN.main))
        finally:
            RUN.OUT, sys.argv = saved_out, saved_argv


def chain_checks(chk):
    """The freeze's chain in stand-in git repositories: passes when whole, refuses a changed file, an addendum
    changing a file it may not, a cut chain and a link committed twice; takes an addendum changing layout.json
    and the dry run's record alone."""
    env = {"GIT_AUTHOR_NAME": "t", "GIT_AUTHOR_EMAIL": "t@t", "GIT_COMMITTER_NAME": "t", "GIT_COMMITTER_EMAIL": "t@t",
           "PATH": "/usr/bin:/bin:/usr/local/bin:/opt/homebrew/bin", "HOME": tempfile.gettempdir()}
    rel = HERE.relative_to(HERE.parents[1])

    def stand_in(tmp):
        repo = Path(tmp)
        here = repo / rel
        (here / "results").mkdir(parents=True)
        for f in FROZEN_FILES + ("write_frozen.py",):
            shutil.copy(HERE / f, here / f)
        return repo, here

    def record(repo, here):
        hashes = {str(rel / f): hashlib.sha256((here / f).read_bytes()).hexdigest() for f in FROZEN_FILES}
        (here / "results" / "dry-run.json").write_text(json.dumps({"failed": [], "code unchanged during the run": True,
                                                                    "code hashes": hashes}))

    def g(repo, *args):
        subprocess.run(["git", "-C", str(repo), *args], capture_output=True, check=True, env=env)

    def link(repo, path, extra=()):
        files = sorted({str(rel / f) for f in FROZEN_FILES + ("write_frozen.py",)}
                       | {str(rel / "results" / "dry-run.json")} | {str(rel / e) for e in extra})
        path.write_text("".join(f"{hashlib.sha256((repo / p).read_bytes()).hexdigest()}  {p}\n" for p in files))

    with tempfile.TemporaryDirectory() as tmp:
        repo, here = stand_in(tmp)
        record(repo, here)
        chk("the chain", "the run refuses while FROZEN.sha256 is not written",
            "is not written" in refusal(lambda: RUN.frozen(repo, here)))
        g(repo, "init", "-q")
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "files")
        link(repo, here / "FROZEN.sha256")
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "freeze")
        r = refusal(lambda: RUN.frozen(repo, here))
        chk("the chain", "a whole chain passes", r == "", r)
        (here / "t1n.py").write_text((here / "t1n.py").read_text() + "\n# changed\n")
        chk("the chain", "a changed frozen file refuses", "differ" in refusal(lambda: RUN.frozen(repo, here)))
        g(repo, "checkout", "-q", "--", str(rel / "t1n.py"))
        (here / "addenda").mkdir()
        (here / "addenda" / "ADDENDUM-1.md").write_text("layout\n")
        lay = json.loads((here / "layout.json").read_text())
        lay["species"], lay["labels"]["Natural Reproduction (NR)"] = "WALLEYE", "natural"   # a text added, none remapped
        (here / "layout.json").write_text(json.dumps(lay, indent=1))
        record(repo, here)
        link(repo, here / "addenda" / "FROZEN-1.sha256", ("addenda/ADDENDUM-1.md",))
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "addendum 1")
        r = refusal(lambda: RUN.frozen(repo, here))
        chk("the chain", "an addendum changing layout.json and the record alone passes", r == "", r)
        (here / "addenda" / "ADDENDUM-2.md").write_text("rules\n")
        (here / "t1n.py").write_text((here / "t1n.py").read_text() + "\n# a rule changed\n")
        link(repo, here / "addenda" / "FROZEN-2.sha256", ("addenda/ADDENDUM-1.md", "addenda/ADDENDUM-2.md"))
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "addendum 2")
        chk("the chain", "an addendum changing a rule refuses", "may not" in refusal(lambda: RUN.frozen(repo, here)))
        g(repo, "rm", "-q", str(rel / "addenda" / "FROZEN-2.sha256"), str(rel / "addenda" / "ADDENDUM-2.md"))
        g(repo, "checkout", "-q", "HEAD~1", "--", str(rel / "t1n.py"))
        g(repo, "commit", "-qm", "cut")
        chk("the chain", "a link committed and removed refuses: the chain cut", "cut" in refusal(lambda: RUN.frozen(repo, here)))
    with tempfile.TemporaryDirectory() as tmp:
        repo, here = stand_in(tmp)
        record(repo, here)
        g(repo, "init", "-q")
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "files")
        link(repo, here / "FROZEN.sha256")
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "freeze")
        (here / "addenda").mkdir()
        (here / "addenda" / "ADDENDUM-1.md").write_text("labels\n")
        lay = json.loads((here / "layout.json").read_text())
        lay["labels"]["C-NR"] = "natural"                                                   # an existing text remapped
        (here / "layout.json").write_text(json.dumps(lay, indent=1))
        record(repo, here)
        link(repo, here / "addenda" / "FROZEN-1.sha256", ("addenda/ADDENDUM-1.md",))
        g(repo, "add", "-A")
        g(repo, "commit", "-qm", "addendum 1")
        chk("the chain", "an addendum remapping a label text layout.json held refuses",
            "remaps label texts" in refusal(lambda: RUN.frozen(repo, here)))
    with tempfile.TemporaryDirectory() as tmp:
        repo, here = stand_in(tmp)
        record(repo, here)
        g(repo, "init", "-q")
        for msg in ("one", "two"):
            (here / "FROZEN.sha256").write_text(f"{msg}\n")
            g(repo, "add", "-A")
            g(repo, "commit", "-qm", msg)
        chk("the chain", "a link committed twice refuses", "exactly once" in refusal(lambda: RUN.frozen(repo, here)))
        for msg in ("one", "two"):
            (here / "downloads.json").write_text(json.dumps({"files": [], "note": msg}))
            g(repo, "add", "-A")
            g(repo, "commit", "-qm", "downloads " + msg)
        chk("the chain", "downloads.json committed twice refuses",
            "exactly once" in refusal(lambda: RUN.once(repo, str(rel / "downloads.json"))))


def main():
    t0 = time.process_time()
    code = code_hashes()
    chk = Checks()
    scripted(chk)
    need_checks(chk)
    reader_checks(chk)
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
