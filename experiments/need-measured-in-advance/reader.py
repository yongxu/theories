"""T1N's reader (DESIGN.md, section 10): the recorders' tables, as CSV files in one folder, into the lakes t1n.py
reads. The layout assumed before any file was seen is layout.json, which alone an addendum may change (with
the dry run's record), once the layout is read with no value.

    python3 -B reader.py layout FOLDER     # each file's header and row count; no value is printed
    python3 -B reader.py facts FOLDER      # what the layout step records, from structural columns alone

Standard library only.
"""

import csv
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1n                       # noqa: E402

LAYOUT = json.loads((HERE / "layout.json").read_text())
FILES, COLUMNS, LABELS, SPECIES = LAYOUT["files"], LAYOUT["columns"], LAYOUT["labels"], LAYOUT["species"]
OPTIONAL = set(LAYOUT["optional files"])
OPTIONAL_COLUMNS = {tuple(x) for x in LAYOUT["optional columns"]}
OPEN_TYPES = ("drainage", "drained", "spring", "impoundment", "flowage", "reservoir", "river")
STRUCTURE = {"lake", "year", "label", "characteristics", "species", "type"}   # what the layout step reads


def code(s):
    """A lake's code as the files give it, one form for all: "123456", " 123456 " and "123456.0" alike."""
    s = (s or "").strip()
    return str(int(float(s))) if re.fullmatch(r"\d+(\.0+)?", s) else s


def is_species(s):
    return (s or "").strip().lower() == SPECIES.lower()


def closed_of(text):
    """A recorded type read as closed: True for a seepage lake, False for another named type (OPEN_TYPES),
    None where neither is named."""
    t = (text or "").lower()
    if "seepage" in t:
        return True
    if any(w in t for w in OPEN_TYPES):
        return False
    return None


def num(s):
    s = (s or "").replace(",", "").strip()
    try:
        return float(s) if s not in ("", "-", "NA") else None
    except ValueError:
        return None


def year_of(s):
    v = num(s)
    return int(v) if v is not None else None


def table(folder, kind, keys=None):
    """A file's rows as dicts of the reader's keys (all, or `keys`), refusing where it lacks a column the
    reader needs."""
    path = Path(folder) / FILES[kind]
    with path.open(newline="", encoding="utf-8-sig") as f:
        rd = csv.DictReader(f)
        missing = [c for k, c in COLUMNS[kind].items()
                   if c not in (rd.fieldnames or []) and (kind, k) not in OPTIONAL_COLUMNS]
        if missing:
            raise SystemExit(f"{path.name} lacks {missing}: the layout differs from the one assumed (an addendum "
                             f"may change layout.json alone)")
        want = {k: c for k, c in COLUMNS[kind].items() if keys is None or k in keys}
        return [{k: row.get(c, "") for k, c in want.items()} for row in rd]


def read_all(folder):
    """Every lake the adult estimates name, with the other tables joined by the lake's code. Refuses a label
    layout.json does not map (so no label is read as natural by default), a missing required file, a present
    file whose rows name no lake of the estimates (the codes differ), and a stocking file with no row of the
    species. Returns (lakes, meta): meta says whether the labels are read per year (some lake's label changes
    across years) and how many rows each file matched."""
    lakes, skipped = {}, {"a blank year or acres": 0, "no estimate or interval": 0}
    for row in table(folder, "adults"):
        label = row["label"].strip()
        if label not in LABELS:
            raise SystemExit(f"a label layout.json does not map: {label!r}")
        lid, yr, acres = code(row["lake"]), year_of(row["year"]), num(row["acres"])
        if yr is None or acres is None or acres <= 0:
            skipped["a blank year or acres"] += 1
            continue
        lk = lakes.setdefault(lid, {"id": lid, "acres": acres, "label": {}, "adults": {}, "age0": {}, "harvest": {},
                                    "creel": set(), "stocked": set(), "other": None,
                                    "closed": closed_of(row.get("characteristics"))})
        est, lo, hi = num(row["estimate"]), num(row["lower"]), num(row["upper"])
        if None in (est, lo, hi):
            skipped["no estimate or interval"] += 1
            continue
        lk["adults"][yr] = (est / acres, lo / acres, hi / acres)
        lk["label"][yr] = LABELS[label]
    matched = {}

    def join(kind, take):
        if not (Path(folder) / FILES[kind]).exists():
            if kind in OPTIONAL:
                matched[kind] = None
                return
            raise SystemExit(f"{FILES[kind]} is missing")
        rs, hits = table(folder, kind), 0
        for row in rs:
            lk = lakes.get(code(row["lake"]))
            if lk is not None:
                hits += 1
                take(lk, row)
        matched[kind] = [hits, len(rs)]
        if rs and not hits:
            raise SystemExit(f"no row of {FILES[kind]} names a lake of {FILES['adults']}: the lake codes differ")

    def age0(lk, row):
        yr, v = year_of(row["year"]), num(row["per mile"])
        if yr is not None and v is not None:
            lk["age0"][yr] = v

    def harvest(creel):
        def take(lk, row):
            yr, v = year_of(row["year"]), num(row["number"])
            if yr is None or v is None:
                return
            lk["harvest"][yr] = lk["harvest"].get(yr, 0.0) + v / lk["acres"]
            if creel:
                lk["creel"].add(yr)
        return take

    def stocking(field):
        def take(lk, row):
            yr = year_of(row["year"])
            if yr is not None and is_species(row["species"]) and (num(row["number"]) or 0) > 0:
                lk[field].add(yr)
        return take

    def types(lk, row):
        if lk["closed"] is None:
            lk["closed"] = closed_of(row["type"])

    join("age0", age0)
    join("tribal", harvest(False))
    join("creel", harvest(True))
    join("stocking", stocking("stocked"))
    if (Path(folder) / FILES["other"]).exists():
        for lk in lakes.values():
            lk["other"] = set()
    join("other", stocking("other"))
    join("types", types)
    for kind in ("stocking", "other"):
        if (Path(folder) / FILES[kind]).exists():
            rs = table(folder, kind, {"species"})
            if rs and not any(is_species(r["species"]) for r in rs):
                raise SystemExit(f"no row of {FILES[kind]} names {SPECIES!r}: the species' text differs")
    labels = any(len(set(lk["label"].values())) > 1 for lk in lakes.values())
    return lakes, {"labels per year": labels, "rows matched by lake code, of rows": matched, "rows skipped": skipped}


def layout(folder):
    """Each present file's header and number of rows: the layout, with no value read."""
    out = {}
    for kind, name in FILES.items():
        path = Path(folder) / name
        if path.exists():
            with path.open(newline="", encoding="utf-8-sig") as f:
                rd = csv.reader(f)
                header = next(rd, [])
                out[kind] = {"columns": header, "rows": sum(1 for _ in rd)}
    return out


def layout_facts(folder, cutoff=t1n.CUTOFF):
    """What the layout step records beside the headers, read from the structural columns alone (lake, year,
    label, characteristics, species, type): never an estimate, an interval, an age-0 count, a harvest or a
    number stocked."""
    def rows_of(kind):
        path = Path(folder) / FILES[kind]
        if not path.exists():
            return None
        with path.open(newline="", encoding="utf-8-sig") as f:
            rd = csv.DictReader(f)
            keep = {k: c for k, c in COLUMNS[kind].items() if k in STRUCTURE and c in (rd.fieldnames or [])}
            return [{k: row[c] for k, c in keep.items()} for row in rd]
    adults = rows_of("adults") or []
    est, labs, chars = {}, {}, {}
    for r in adults:
        lid, yr = code(r["lake"]), year_of(r["year"])
        if yr is None:
            continue
        est.setdefault(lid, set()).add(yr)
        labs.setdefault(lid, set()).add(r["label"].strip())
        chars.setdefault(lid, set()).add((r.get("characteristics") or "").strip())
    age0 = {(code(r["lake"]), year_of(r["year"])) for r in rows_of("age0") or []}
    last = max((y for ys in est.values() for y in ys), default=None)
    pairs = [(l, y) for l, ys in est.items() for y in ys if y <= cutoff and (l, y) in age0]
    end = last - t1n.GAP_MIN if last else None
    cand = [l for l, ys in est.items()
            if any(t1n.FIRST_REF <= y <= (end or 0) and any(t1n.GAP_MIN <= z - y <= t1n.GAP_MAX for z in ys) for y in ys)]
    types = {code(r["lake"]): r.get("type", "") for r in rows_of("types") or []}
    closed = {l: closed_of(" ".join(chars.get(l, ()))) for l in est}
    for l, t in types.items():
        if l in closed and closed[l] is None:
            closed[l] = closed_of(t)
    match = {}
    for kind in FILES:
        if kind != "adults":
            rs = rows_of(kind)
            match[kind] = None if rs is None else [sum(1 for r in rs if code(r["lake"]) in est), len(rs)]
    species = {kind: sorted({r["species"].strip() for r in rows_of(kind) or []}) for kind in ("stocking", "other")}
    return {"label texts": sorted({t for s in labs.values() for t in s}),
            "lakes whose label changes across years": sum(1 for s in labs.values() if len(s) > 1),
            "water body types named": sorted(({t for s in chars.values() for t in s} | set(types.values())) - {""})[:60],
            "lakes recorded closed / open / unknown": [sum(1 for v in closed.values() if v is s) for s in (True, False, None)],
            "species texts": species, "rows naming a lake of the estimates, of rows": match,
            "other stocking records (R5b) had": (Path(folder) / FILES["other"]).exists(),
            "lake types (R7) had": (Path(folder) / FILES["types"]).exists(),
            "last estimate year": last, "reference window": [t1n.FIRST_REF, end],
            "lake-years up to the cutoff with an estimate and a fall survey": len(pairs),
            "lakes in them": len({l for l, _ in pairs}),
            "lakes with a candidate reference": len(cand),
            "lakes with a candidate reference, recorded closed": sum(1 for l in cand if closed.get(l) is True)}


def write_synthetic(lakes, folder):
    """The dry run's lakes written in the assumed layout, so the reader is checked on files of that form."""
    folder = Path(folder)
    back = {}
    for k, v in LABELS.items():
        back.setdefault(v, k)
    rows = {k: [] for k in ("adults", "age0", "tribal", "creel", "stocking")}
    for lk in lakes:
        for yr, (est, lo, hi) in sorted(lk["adults"].items()):
            rows["adults"].append({"lake": lk["id"], "year": yr, "acres": lk["acres"],
                                   "label": back[lk["label"].get(yr, t1n.NR)], "estimate": est * lk["acres"],
                                   "lower": lo * lk["acres"], "upper": hi * lk["acres"],
                                   "characteristics": {True: "Seepage", False: "Drainage", None: ""}[lk.get("closed")]})
        for yr, v in sorted(lk["age0"].items()):
            rows["age0"].append({"lake": lk["id"], "year": yr, "per mile": v})
        for yr, v in sorted(lk["harvest"].items()):
            rows["creel" if yr in lk["creel"] else "tribal"].append({"lake": lk["id"], "year": yr, "number": v * lk["acres"]})
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
    if len(sys.argv) == 3 and sys.argv[1] in ("layout", "facts"):
        out = layout(sys.argv[2]) if sys.argv[1] == "layout" else layout_facts(sys.argv[2])
        print(json.dumps(out, indent=1))
    else:
        raise SystemExit(__doc__)
