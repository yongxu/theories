"""How far T1N's and T1R's frozen rules can reach on the records as published: ceilings from structure alone (LAYOUT.md).

    python3 -I -B experiments/need-measured-in-advance/reach.py FOLDER [FALL_CSV ...]     # prints JSON

From R1 it reads the lake, the year and the label, and from R5 the lake, the year, the species and whether the number
stocked is above 0, as T1N's reader keeps a stocking. Each FALL_CSV is a table of the lake-years the published fall
tables list, columns WBIC and Year; only those two are read. No estimate, bound, density, catch or note of any record is
opened. Every value the rules need is put in by this script, chosen for the lake that favours reading it, and the frozen
rules (t1n.py, t1r.py) are then run unchanged, so a ceiling holds whatever the records' values are.

The first reading takes a fall survey in every year of every lake, whatever the tables list; the next, one per FALL_CSV,
takes them where it lists them. Standard library only.
"""

import csv
import glob
import hashlib
import importlib.util
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1n                       # noqa: E402

LABELS = {"NATURAL": t1n.NR}     # what R1's four label texts are read as here; the others are not natural recruitment
NEED = 1.0                       # any level: every value below is put in relative to it
ABOVE, ACROSS, BELOW, LOWER = (10.0, 8.0, 12.5), (1.0, 0.5, 2.0), (0.5, 0.4, 0.6), (0.05, 0.04, 0.06)


def skeletons(folder, fall=None):
    """The lakes with their years, labels and stocking years; no value of the records. `fall`, a set of (lake, year),
    limits the fall surveys to those; None takes one in every year of every lake."""
    lakes = {}
    with (Path(folder) / "adult_estimates.csv").open(newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            lid, yr = str(int(float(row["WBIC"]))), int(float(row["Survey Year"]))
            lk = lakes.setdefault(lid, {"id": lid, "acres": 1.0, "label": {}, "adults": {}, "age0": {}, "harvest": {},
                                        "creel": set(), "stocked": set(), "other": None, "closed": None})
            read = LABELS.get(row["Primary Recruitment Source"].strip(), "not natural")   # a repeated lake-year: natural if any row is
            lk["label"][yr] = t1n.NR if t1n.NR in (read, lk["label"].get(yr)) else read
            lk["adults"][yr] = ACROSS
    with (Path(folder) / "stocking.csv").open(newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            lk = lakes.get(row["WBIC"].strip())
            try:
                kept = row["Species"].strip().lower() == "walleye" and float(row["Number Stocked"] or 0) > 0
                yr = int(row["Year"])
            except ValueError:
                continue
            if lk is not None and kept:
                lk["stocked"].add(yr)
    for lk in lakes.values():
        for yr in lk["adults"]:
            if fall is None or (lk["id"], yr) in fall:
                lk["age0"][yr] = 0.0
        if fall is not None:
            for lid, yr in fall:
                if lid == lk["id"]:
                    lk["age0"][yr] = 0.0
    return lakes


def t1n_read(lk, last):
    """Whether any putting of values reads the lake below the need with a fate resolved: its years to the cutoff above
    the need, its window's years before a chosen reference across the need, that reference below it, and every later
    survey lower still, so a decline by the ratio test with nothing recovering. Returns the reference or None."""
    years = sorted(lk["adults"])
    for r in (t for t in years if t1n.FIRST_REF <= t <= last):
        trial = dict(lk)
        trial["adults"] = {t: ABOVE if t <= t1n.CUTOFF else ACROSS if t < r else BELOW if t == r else LOWER for t in years}
        row = t1n.rows([trial], NEED, t1n.FIRST_REF, last, t1n.FLOOR, True)[0]
        if row.get("below the need at the reference") and row.get("fate") in ("fell", "persisted"):
            return r
    return None


def t1r_read(lk, t1r):
    """Whether any putting of values reads the lake in T1R's scope: its years before a chosen low survey across the
    need, that survey below it, one later year above it, and the rest across. Returns (low, read) or None."""
    years = sorted(lk["adults"])
    stocked = t1r.stocked_years(lk)
    for low in years:
        for read in (t for t in years if t > low):
            trial = dict(lk)
            trial["adults"] = {t: BELOW if t == low else ABOVE if t == read else ACROSS for t in years}
            got = t1r.scope(trial, NEED, stocked)
            if got[1] == read:
                return low, read
    return None


def funnel(lakes, t1r_last):
    """How many lakes pass each of T1N's structural conditions on the way to a lake read below the need."""
    premise = []
    for lk in lakes:
        trial = dict(lk)
        trial["adults"] = {t: ABOVE for t in lk["adults"]}
        if t1n.held_above(trial, NEED, True):
            premise.append(lk)
    in_window = [lk for lk in premise if any(t1n.FIRST_REF <= t <= t1r_last and t1n.in_scope(lk, t, True) is None
                                             for t in lk["adults"])]
    with_later = [lk for lk in in_window if any(t1n.FIRST_REF <= t <= t1r_last and t1n.in_scope(lk, t, True) is None
                                                and any(t1n.GAP_MIN <= f - t <= t1n.GAP_MAX for f in lk["adults"])
                                                for t in lk["adults"])]
    return {"lakes with two estimates to the cutoff, ten years apart at most, the label natural at both and no stocking "
            "from five years before the first to the second": len(premise),
            "of them, with a survey in the reference window with the label natural and no stocking in five years": len(in_window),
            "of them, with a later estimate three to ten years after such a survey": len(with_later)}


def reach(folder, fall=None):
    lakes = skeletons(folder, fall)
    vals = list(lakes.values())
    last = max(t for lk in vals for t in lk["adults"]) - t1n.GAP_MIN
    spec = importlib.util.spec_from_file_location("t1r", HERE.parent / "stocked-above-the-need" / "t1r.py")
    t1r = importlib.util.module_from_spec(spec)
    sys.path.insert(0, str(Path(spec.origin).parent))
    spec.loader.exec_module(t1r)
    pairs = t1n.pairs(vals, labels=True)
    by_year = {}
    for first in (1990, 1996, 1997, 1998, 1999, 2001, 2005):
        got = [(lk["id"], yr) for lk in vals for yr in lk["adults"]
               if first <= yr <= t1n.CUTOFF and yr in lk["age0"] and t1n.natural_at(lk, yr, True)
               and not t1n.stocked_in(lk, yr - t1n.STOCK_BEFORE, yr)]
        by_year[str(first)] = [len(got), len({i for i, _ in got})]
    below = sorted(lk["id"] for lk in vals if t1n_read(lk, last) is not None)
    scoped = sorted(lk["id"] for lk in vals if t1r_read(lk, t1r) is not None)
    return {
        "lakes": len(vals),
        "labels read per year": t1n.labels_per_year(vals),
        "lakes changing label category, of lakes with two or more estimates": [
            sum(1 for lk in vals if len(lk["label"]) > 1 and len(set(lk["label"].values())) > 1),
            sum(1 for lk in vals if len(lk["label"]) > 1)],
        "the fit": {"pairs needed": t1n.PAIRS_MIN, "lakes needed": t1n.LAKES_MIN,
                    "pairs at most, and their lakes": [len(pairs), len({i for i, _, _ in pairs})],
                    "pairs at most, and their lakes, from each first year": by_year},
        "T1N's V1": {"lakes needed below the need, resolved": t1n.N_MIN,
                     "lakes that can be read so at most, whatever the values": len(below), "lakes": below,
                     "on the way": funnel(vals, last)},
        "T1R's V1": {"lakes needed": t1r.N_MIN, "lakes that can be read at most, whatever the values": len(scoped)},
    }


def main():
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    folder, falls = sys.argv[1], sys.argv[2:]
    inputs = sorted(glob.glob(str(Path(folder) / "*.csv"))) + falls
    out = {"inputs": {Path(p).name: hashlib.sha256(Path(p).read_bytes()).hexdigest() for p in inputs},
           "a fall survey in every year of every lake": reach(folder)}
    for path in falls:
        with open(path, newline="", encoding="utf-8-sig") as f:
            fall = {(row["WBIC"].strip(), int(row["Year"])) for row in csv.DictReader(f)}
        out["fall surveys where " + Path(path).name + " lists them"] = reach(folder, fall)
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
