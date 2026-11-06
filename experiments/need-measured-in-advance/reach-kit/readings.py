"""The counts LAYOUT.md gives beyond reach.py's: how much of T1N's ceiling rests on what, and the plain facts of R1.

    python3 -I -B reach-kit/readings.py R1_R5_FOLDER REACH_INPUT_FOLDER SPRING_JSON     # prints JSON

No estimate, bound, density or number stocked is printed or kept. Two values are touched, each reduced to one bit: whether
R1's lower bound is below zero, and, as T1N's reader does, whether R5's number stocked is above zero. The acres text is
tested for being there. The rest is lakes, years, labels, and R5's source and age categories. Standard library only.
"""

import collections
import csv
import hashlib
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
import reach as RE    # noqa: E402
import t1n            # noqa: E402


def read_fall(path):
    with open(path, newline="", encoding="utf-8-sig") as f:
        return {(row["WBIC"].strip(), int(row["Year"])) for row in csv.DictReader(f)}


def stock_rows(folder):
    """R5's rows that T1N's reader keeps as a stocking: (lake, year, source, age class)."""
    out = []
    with (Path(folder) / "stocking.csv").open(newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            try:
                kept = row["Species"].strip().lower() == "walleye" and float(row["Number Stocked"] or 0) > 0
                yr = int(row["Year"])
            except ValueError:
                continue
            if kept:
                out.append((row["WBIC"].strip(), yr, (row["SOURCE_TYPE"] or "").strip(), (row["AGE_CLASS"] or "").strip().upper()))
    return out


def r5_rows(folder):
    """R5's walleye rows by source and age class, and how many have a number stocked above zero."""
    n = above = 0
    source, age = collections.Counter(), collections.Counter()
    with (Path(folder) / "stocking.csv").open(newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            if row["Species"].strip().lower() != "walleye":
                continue
            n += 1
            source[(row["SOURCE_TYPE"] or "").strip() or "blank"] += 1
            age[(row["AGE_CLASS"] or "").strip().upper() or "blank"] += 1
            try:
                above += float(row["Number Stocked"] or 0) > 0
            except ValueError:
                pass
    return {"walleye rows": n, "with a number stocked above zero": above, "by source": dict(source), "by age class": dict(age)}


def lakes_of(folder, fall=None, natural=("NATURAL",), every_label_natural=False, stock=None):
    """reach.skeletons, with what it reads as natural and what it reads as stocked put in by hand."""
    saved = RE.LABELS
    RE.LABELS = {text: t1n.NR for text in natural}
    try:
        lakes = RE.skeletons(folder, fall)
    finally:
        RE.LABELS = saved
    for lk in lakes.values():
        if every_label_natural:
            lk["label"] = {yr: t1n.NR for yr in lk["label"]}
        if stock is not None:
            lk["stocked"] = {yr for yr in stock.get(lk["id"], ())}
    return lakes


def stock_by_lake(rows, keep):
    out = collections.defaultdict(set)
    for lake, yr, source, age in rows:
        if keep(source, age):
            out[lake].add(yr)
    return out


def read(lakes):
    vals = list(lakes.values())
    last = max(t for lk in vals for t in lk["adults"]) - t1n.GAP_MIN
    return sorted(lk["id"] for lk in vals if RE.t1n_read(lk, last) is not None)


def fit(lakes, first=1990):
    """The lake-years the need's fit could use, as reach.py counts them from a first year: [lake-years, lakes]."""
    got = [(lk["id"], yr) for lk in lakes.values() for yr in lk["adults"]
           if first <= yr <= t1n.CUTOFF and yr in lk["age0"] and t1n.natural_at(lk, yr, True)
           and not t1n.stocked_in(lk, yr - t1n.STOCK_BEFORE, yr)]
    return [len(got), len({i for i, _ in got})]


def main():
    folder, inputs, spring = sys.argv[1:4]
    inputs = Path(inputs)
    listed, generous = read_fall(inputs / "fall-listed.csv"), read_fall(inputs / "fall-generous.csv")
    wide = read_fall(inputs / "fall-with-glifwc.csv")
    rows1 = list(csv.DictReader((Path(folder) / "adult_estimates.csv").open(newline="", encoding="utf-8-sig")))
    r1_years = {(str(int(float(r["WBIC"]))), int(float(r["Survey Year"]))) for r in rows1}
    union = generous | wide
    sturdy = {(w, y) for w, y in r1_years if y >= 2002} | {(w, y) for w, y in generous if y < 2002}
    r5 = stock_rows(folder)
    whole = stock_by_lake(r5, lambda s, a: True)
    no_fry = stock_by_lake(r5, lambda s, a: a != "FRY")
    dnr = stock_by_lake(r5, lambda s, a: s == "DNR")
    named = stock_by_lake(r5, lambda s, a: s == "DNR" and a != "FRY")
    out = {"inputs": {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in
                      [Path(folder) / "adult_estimates.csv", Path(folder) / "stocking.csv", inputs / "fall-listed.csv",
                       inputs / "fall-generous.csv", inputs / "fall-with-glifwc.csv", Path(spring)]}}

    # R1's plain facts.
    per_lake = collections.Counter(str(int(float(r["WBIC"]))) for r in rows1)
    acres = {}
    blank_acres = 0
    for r in rows1:
        w = str(int(float(r["WBIC"])))
        has = bool(re.search(r"LAKE ACRES:\s*\S", r["Lake Characteristics"] or ""))
        blank_acres += not has
        acres[w] = acres.get(w, False) or has
    below_zero = 0
    for r in rows1:
        try:
            below_zero += float(r["Lower 95 C.I."]) < 0
        except (TypeError, ValueError):
            pass
    repeats = [k for k, n in collections.Counter((str(int(float(r["WBIC"]))), int(float(r["Survey Year"]))) for r in rows1).items() if n > 1]
    out["R1"] = {"rows": len(rows1), "lakes": len(per_lake), "lake-years": len(r1_years),
                 "years": [min(y for _, y in r1_years), max(y for _, y in r1_years)],
                 "lakes with one row": sum(1 for n in per_lake.values() if n == 1),
                 "mean rows a lake": round(len(rows1) / len(per_lake), 2),
                 "rows with the acres text missing or empty": blank_acres, "lakes with it in no row": sum(1 for v in acres.values() if not v),
                 "rows whose lower bound is below zero": below_zero, "repeated lake-years": len(repeats),
                 "label texts": dict(collections.Counter(r["Primary Recruitment Source"].strip() for r in rows1))}

    out["R5"] = r5_rows(folder)

    # GLIFWC's spring lakes in R1, by year.
    sp = json.load(open(spring))
    coded = {(t["wbic"], t["year"]) for t in sp if t["wbic"] and str(t["wbic"]).isdigit()}
    out["GLIFWC's Wisconsin spring rows"] = {"rows": len(sp), "with a lake code": sum(1 for t in sp if t["wbic"] and str(t["wbic"]).isdigit()),
                                             "lake-years they give": len(coded), "of them, not in R1": len(coded - r1_years)}
    by = {}
    for year in range(1997, 2024):
        lakes = {t["wbic"] for t in sp if t["year"] == year and t["wbic"]}
        by[str(year)] = {"GLIFWC's Wisconsin spring lakes with a code": len(lakes),
                         "in R1 in that year": sum(1 for w in lakes if (w, year) in r1_years),
                         "in R1 in some year": sum(1 for w in lakes if w in per_lake)}
    out["GLIFWC's spring lakes against R1"] = {"lake-years also in R1": sum(v["in R1 in that year"] for v in by.values()),
                                               "by year": by}

    # What the ceiling rests on: each cut alone, and R5's parts. Fall surveys do not enter the 9 (LAYOUT.md).
    plain = lakes_of(folder, every_label_natural=True, stock={})
    labels_only = lakes_of(folder, stock={})
    stock_only = lakes_of(folder, every_label_natural=True)
    both = lakes_of(folder)
    out["the ceiling by cut"] = {"the estimates' years alone": len(read(plain)), "with the labels": len(read(labels_only)),
                                 "with stocking": len(read(stock_only)), "with both, as reach.py": read(both)}
    out["the ceiling by R5's rows, labels read"] = {
        "R5 whole": len(read(both)),
        "R5 without fry": read(lakes_of(folder, stock=no_fry)),
        "R5's DNR rows": read(lakes_of(folder, stock=dnr)),
        "R5's DNR rows without fry, the database as DESIGN.md section 3 describes it": read(lakes_of(folder, stock=named)),
        "no R5": read(labels_only)}
    near = {}
    for lk in both.values():
        last = max(t for l in both.values() for t in l["adults"]) - t1n.GAP_MIN
        if RE.t1n_read(lk, last) is not None:
            continue
        for yr in sorted(lk["stocked"]):
            trial = dict(lk)
            trial["stocked"] = lk["stocked"] - {yr}
            if RE.t1n_read(trial, last) is not None:
                near.setdefault(lk["id"], []).append(yr)
    out["lakes one stocking year away from being read"] = near
    out["the ceiling by what is read as natural"] = {
        "NATURAL": len(read(both)),
        "NATURAL and REMNANT": read(lakes_of(folder, natural=("NATURAL", "REMNANT"))),
        "NATURAL and NONE": len(read(lakes_of(folder, natural=("NATURAL", "NONE")))),
        "NATURAL, REMNANT and NONE": len(read(lakes_of(folder, natural=("NATURAL", "REMNANT", "NONE"))))}

    # The fit, by the fall list and by R5's parts: [lake-years, lakes], reading labels.
    lists = {"every lake-year": None, "fall-listed.csv": listed, "fall-generous.csv": generous,
             "fall-generous.csv with fall-with-glifwc.csv": union,
             "every lake-year from 2002 with fall-generous.csv before": sturdy}
    out["the fit (200 lake-years, 30 lakes), by fall list and R5"] = {
        name: {"R5 whole": fit(lakes_of(folder, fall)), "R5's DNR rows without fry": fit(lakes_of(folder, fall, stock=named)),
               "no R5": fit(lakes_of(folder, fall, stock={}))}
        for name, fall in lists.items()}
    out["the fit on fall-generous.csv, by reading"] = {
        "as reach.py": fit(lakes_of(folder, generous)),
        "R5 without fry": fit(lakes_of(folder, generous, stock=no_fry)),
        "R5's DNR rows": fit(lakes_of(folder, generous, stock=dnr)),
        "R5's DNR rows without fry": fit(lakes_of(folder, generous, stock=named)),
        "no R5": fit(lakes_of(folder, generous, stock={})),
        "NATURAL and REMNANT": fit(lakes_of(folder, generous, natural=("NATURAL", "REMNANT"))),
        "NATURAL and NONE": fit(lakes_of(folder, generous, natural=("NATURAL", "NONE")))}
    out["the fit from 1997 on every lake-year"] = {"R5 whole": fit(both, 1997),
                                                   "R5's DNR rows without fry": fit(lakes_of(folder, stock=named), 1997),
                                                   "no R5": fit(labels_only, 1997)}
    out["R1's lake-years to 2012 on the fall lists, before the label and stocking cuts"] = {
        name: {"1997 to 2001": sum(1 for w, y in r1_years if 1997 <= y <= 2001 and (w, y) in fall),
               "2002 to 2012": sum(1 for w, y in r1_years if 2002 <= y <= 2012 and (w, y) in fall)}
        for name, fall in lists.items() if fall is not None}
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
