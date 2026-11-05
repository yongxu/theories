"""T1N's reader (DESIGN.md, section 10): the recorders' tables, as CSV files in one folder, into the lakes
t1n.py reads. FILES, COLUMNS and LABELS are the layout assumed before any file was seen; an addendum may
change only them (DESIGN.md, section 14), once the layout is read with no value.

    python3 -B reader.py layout FOLDER     # each file's header and row count; no value is printed

Standard library only.
"""

import csv
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1n                       # noqa: E402

FILES = {
    "adults": "adult_estimates.csv",     # FMIS, WDNR Treaty Walleye Adult Population Estimate, statewide by year
    "age0": "fall_age0.csv",              # fall recruitment surveys, age-0 walleye per mile of shoreline
    "tribal": "tribal_harvest.csv",       # the Ceded Territory's tribal harvest, by lake and year
    "creel": "creel_harvest.csv",         # angling harvest, by lake and year, where a creel survey ran
    "stocking": "stocking.csv",           # WDNR's fish stocking records
    "other": "other_stocking.csv",        # R5b: fry, tribal and private stocking, where those records are had
    "types": "lake_types.csv",            # R7: WDNR's lake type, where R1's characteristics do not give it
    "curves": "published_curves.csv",     # branch A: the published per-lake stock-recruitment curves, if any
}
COLUMNS = {
    "adults": {"lake": "WBIC", "year": "Survey Year", "acres": "Acres", "label": "Primary Recruitment Source",
               "estimate": "Population Estimate", "lower": "Lower 95 C.I.", "upper": "Upper 95 C.I.",
               "characteristics": "Lake Characteristics"},
    "age0": {"lake": "WBIC", "year": "Survey Year", "per mile": "Age-0 per Mile"},
    "tribal": {"lake": "WBIC", "year": "Year", "number": "Walleye Harvested"},
    "creel": {"lake": "WBIC", "year": "Year", "number": "Walleye Harvested"},
    "stocking": {"lake": "WBIC", "year": "Year", "species": "Species", "number": "Number Stocked"},
    "other": {"lake": "WBIC", "year": "Year", "species": "Species", "number": "Number Stocked"},
    "types": {"lake": "WBIC", "type": "Lake Type"},
    "curves": {"lake": "WBIC", "form": "Form", "alpha": "alpha", "beta": "beta", "q": "q",
               "last year": "Last Data Year"},
}
LABELS = {"NR": t1n.NR, "Natural Reproduction": t1n.NR, "C-NR": "combination", "C-ST": "combination",
          "ST": "stocked", "Stocked": "stocked", "REM": "remnant"}
SPECIES = "Walleye"
OPTIONAL = {"curves", "other", "types"}   # read where present (branch A's curves; R5b; R7)
OPEN_TYPES = ("drainage", "drained", "spring", "impoundment", "flowage", "reservoir", "river")
OPTIONAL_COLUMNS = {("adults", "characteristics")}   # read where present: the water body's type, for a report
STRUCTURE = {"lake", "year", "label", "characteristics", "species", "form", "last year", "type"}   # read at the layout


def closed_of(text):
    """A recorded type read as closed: True for a seepage lake, False for another named type (OPEN_TYPES),
    None where neither is named."""
    t = (text or "").lower()
    if "seepage" in t:
        return True
    if any(w in t for w in OPEN_TYPES):
        return False
    return None


def table(folder, kind):
    """A file's rows as dicts, refusing where it lacks a column the reader reads."""
    path = Path(folder) / FILES[kind]
    with path.open(newline="", encoding="utf-8-sig") as f:
        rd = csv.DictReader(f)
        missing = [c for k, c in COLUMNS[kind].items()
                   if c not in (rd.fieldnames or []) and (kind, k) not in OPTIONAL_COLUMNS]
        if missing:
            raise SystemExit(f"{path.name} lacks {missing}: the layout differs from the one assumed (an addendum "
                             f"may change only reader.py's FILES, COLUMNS and LABELS)")
        return [{k: row.get(c, "") for k, c in COLUMNS[kind].items()} for row in rd]


def num(s):
    s = (s or "").replace(",", "").strip()
    return float(s) if s not in ("", "-", "NA") else None


def read_all(folder):
    """Every lake the adult estimates name, with the other tables joined by the lake's code and year. A
    label the map does not hold refuses, so that no label is read as natural by default."""
    lakes = {}
    for row in table(folder, "adults"):
        lid, yr, acres = row["lake"].strip(), int(row["year"]), num(row["acres"])
        if row["label"].strip() not in LABELS:
            raise SystemExit(f"a label the map does not hold: {row['label']!r}")
        lk = lakes.setdefault(lid, {"id": lid, "acres": acres, "label": {}, "adults": {}, "age0": {},
                                    "harvest": {}, "creel": set(), "stocked": set(), "other": None,
                                    "closed": closed_of(row["characteristics"])})
        est, lo, hi = num(row["estimate"]), num(row["lower"]), num(row["upper"])
        if None in (est, lo, hi, acres) or acres <= 0:
            continue
        lk["adults"][yr] = (est / acres, lo / acres, hi / acres)
        lk["label"][yr] = LABELS[row["label"].strip()]
    for row in table(folder, "age0"):
        lk, v = lakes.get(row["lake"].strip()), num(row["per mile"])
        if lk is not None and v is not None:
            lk["age0"][int(row["year"])] = v
    for kind in ("tribal", "creel"):
        for row in table(folder, kind):
            lk, v = lakes.get(row["lake"].strip()), num(row["number"])
            if lk is None or v is None:
                continue
            yr = int(row["year"])
            lk["harvest"][yr] = lk["harvest"].get(yr, 0.0) + v / lk["acres"]
            if kind == "creel":
                lk["creel"].add(yr)
    for row in table(folder, "stocking"):
        lk = lakes.get(row["lake"].strip())
        if lk is not None and row["species"].strip() == SPECIES and (num(row["number"]) or 0) > 0:
            lk["stocked"].add(int(row["year"]))
    if (Path(folder) / FILES["other"]).exists():
        for lk in lakes.values():
            lk["other"] = set()
        for row in table(folder, "other"):
            lk = lakes.get(row["lake"].strip())
            if lk is not None and row["species"].strip() == SPECIES and (num(row["number"]) or 0) > 0:
                lk["other"].add(int(row["year"]))
    if (Path(folder) / FILES["types"]).exists():
        for row in table(folder, "types"):
            lk = lakes.get(row["lake"].strip())
            if lk is not None and lk["closed"] is None:
                lk["closed"] = closed_of(row["type"])
    return lakes


def curves(folder):
    """Branch A's curves, {lake: (form, params, last data year)}, or {} where the folder has none."""
    if not (Path(folder) / FILES["curves"]).exists():
        return {}
    out = {}
    for row in table(folder, "curves"):
        if row["form"].strip() in t1n.CURVES:
            out[row["lake"].strip()] = (row["form"].strip(),
                                        {k: num(row[k]) for k in ("alpha", "beta", "q")}, int(row["last year"]))
    return out


def layout(folder):
    """Each present file's header and number of rows: the layout, with no value read."""
    out = {}
    for kind, name in FILES.items():
        path = Path(folder) / name
        if not path.exists():
            continue
        with path.open(newline="", encoding="utf-8-sig") as f:
            rd = csv.reader(f)
            header = next(rd, [])
            out[kind] = {"columns": header, "rows": sum(1 for _ in rd)}
    return out


def layout_facts(folder, cutoff=t1n.CUTOFF):
    """What the layout step records beside the headers, read from the structural columns alone (lake,
    year, label, characteristics, species, form, last year): never an estimate, an age-0 count, a harvest
    or a number stocked. The label's texts, the water body types named, the archive's last estimate year,
    the lake-years up to the cutoff with both an estimate and a fall survey, the lakes with a candidate
    reference, and branch A's curves by form, with the publication's last data year."""
    def rows_of(kind):
        path = Path(folder) / FILES[kind]
        if not path.exists():
            return None
        with path.open(newline="", encoding="utf-8-sig") as f:
            rd = csv.DictReader(f)
            keep = {k: c for k, c in COLUMNS[kind].items() if k in STRUCTURE and c in (rd.fieldnames or [])}
            return [{k: row[c] for k, c in keep.items()} for row in rd]
    adults, age0, curves_ = rows_of("adults") or [], rows_of("age0") or [], rows_of("curves")
    est_years = {}
    for r in adults:
        est_years.setdefault(r["lake"].strip(), set()).add(int(r["year"]))
    surveyed = {(r["lake"].strip(), int(r["year"])) for r in age0}
    last = max((y for ys in est_years.values() for y in ys), default=None)
    pairs = [(l, y) for l, ys in est_years.items() for y in ys if y <= cutoff and (l, y) in surveyed]
    window_end = last - t1n.GAP_MIN if last else None
    cand = sum(1 for ys in est_years.values()
               if any(t1n.FIRST_REF <= y <= (window_end or 0) and any(t1n.GAP_MIN <= z - y <= t1n.GAP_MAX for z in ys)
                      for y in ys))
    types = rows_of("types")
    return {"label texts": sorted({r["label"].strip() for r in adults}),
            "other stocking records (R5b) had": (Path(folder) / FILES["other"]).exists(),
            "lake types (R7) had": types is not None,
            "water body types named": sorted({(r.get("characteristics") or "").strip() for r in adults} - {""})[:50],
            "last estimate year": last, "reference window": [t1n.FIRST_REF, window_end],
            "pairs up to the cutoff": len(pairs), "lakes in them": len({l for l, _ in pairs}),
            "lakes with a candidate reference": cand,
            "curves": None if curves_ is None else {
                "readable forms": sorted({r["form"].strip() for r in curves_ if r["form"].strip() in t1n.CURVES}),
                "lakes with a readable curve": sum(1 for r in curves_ if r["form"].strip() in t1n.CURVES),
                "last data year": max((int(r["last year"]) for r in curves_), default=None)}}


def write_synthetic(lakes, folder):
    """The dry run's lakes written in the assumed layout, so the reader is checked on files of that form."""
    folder = Path(folder)
    back = {v: k for k, v in LABELS.items()}
    rows = {k: [] for k in FILES if k not in ("curves", "other", "types")}
    for lk in lakes:
        for yr, (est, lo, hi) in sorted(lk["adults"].items()):
            rows["adults"].append({"lake": lk["id"], "year": yr, "acres": lk["acres"],
                                   "label": back[lk["label"].get(yr, t1n.NR)], "estimate": est * lk["acres"],
                                   "lower": lo * lk["acres"], "upper": hi * lk["acres"],
                                   "characteristics": {True: "Seepage", False: "Drainage", None: ""}[lk.get("closed")]})
        for yr, v in sorted(lk["age0"].items()):
            rows["age0"].append({"lake": lk["id"], "year": yr, "per mile": v})
        for yr, v in sorted(lk["harvest"].items()):
            kind = "creel" if yr in lk["creel"] else "tribal"
            rows[kind].append({"lake": lk["id"], "year": yr, "number": v * lk["acres"]})
        for yr in sorted(lk["creel"] - set(lk["harvest"])):
            rows["creel"].append({"lake": lk["id"], "year": yr, "number": 0})
        for yr in sorted(lk["stocked"]):
            rows["stocking"].append({"lake": lk["id"], "year": yr, "species": SPECIES, "number": 1000})
    if any(lk.get("other") is not None for lk in lakes):
        rows["other"] = [{"lake": lk["id"], "year": yr, "species": SPECIES, "number": 1000}
                         for lk in lakes for yr in sorted(lk.get("other") or ())]
    for kind, rs in rows.items():
        cols = COLUMNS[kind]
        with (folder / FILES[kind]).open("w", newline="", encoding="utf-8") as f:
            wr = csv.DictWriter(f, fieldnames=list(cols.values()))
            wr.writeheader()
            for r in rs:
                wr.writerow({cols[k]: r[k] for k in cols})


if __name__ == "__main__":
    if len(sys.argv) == 3 and sys.argv[1] == "layout":
        import json
        print(json.dumps(layout(sys.argv[2]), indent=1))
    else:
        raise SystemExit(__doc__)
