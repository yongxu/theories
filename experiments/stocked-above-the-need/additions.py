"""What T1R reads beyond T1N's reader (DESIGN.md, sections 3, 5 and 9): the years of the stocking files' dates,
where they give one, so that a stocking filed under another year's entry counts in the year it was made; and R8,
the unmarked share of a stocked year's fall age-0 catch, where the agency records it for a stocking it marked.
The layout facts read the structural columns alone (the lake, the year, the species and the date), never a count,
a number stocked or a share.
"""

import csv
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
import t1r                       # noqa: E402  (checks T1N's files against T1N's freeze as it loads)
import reader                    # noqa: E402  (T1N's, checked by t1r)

LAYOUT = json.loads((HERE / "layout.json").read_text())
DATES, MARKS = LAYOUT["dates"], LAYOUT["marks"]


def date_year(text):
    """The year of a date as the files may give it (2014-05-02, 5/2/2014, 2014/05/02, 02-May-2014): its one
    four-digit run from 1900 to 2099; None where it has none or more than one."""
    runs = re.findall(r"(?<!\d)(19\d\d|20\d\d)(?!\d)", text or "")
    return int(runs[0]) if len(runs) == 1 else None


def rows_of(folder, kind, columns):
    path = Path(folder) / reader.FILES[kind]
    if not path.exists():
        return None, None
    with path.open(newline="", encoding="utf-8-sig") as f:
        rd = csv.DictReader(f)
        names = rd.fieldnames or []
        return [{k: row.get(c) for k, c in columns.items() if c in names} for row in rd], names


def dated(folder):
    """{lake: the years its walleye stockings' dates fall in}, from the stocking files that give a date column,
    and the facts: the files with one, and the rows whose date falls in another year than their entry, or gives
    no readable year. None in place of the map where neither stocking file gives a date column."""
    out, facts, any_dates = {}, {}, False
    for kind in ("stocking", "other"):
        cols = dict(reader.COLUMNS[kind])
        rows, names = rows_of(folder, kind, {**{k: cols[k] for k in ("lake", "year", "species")}, "date": DATES[kind]})
        if rows is None:
            facts[reader.FILES[kind]] = "not in the folder"
            continue
        if DATES[kind] not in names:
            facts[reader.FILES[kind]] = f"no date column ({DATES[kind]!r})"
            continue
        any_dates = True
        other_year = unread = 0
        for r in rows:
            if not reader.is_species(r.get("species") or ""):
                continue
            y, d = reader.year_of(r.get("year") or ""), date_year(r.get("date"))
            if d is None:
                unread += 1
                continue
            other_year += y is not None and d != y
            out.setdefault(reader.code(r["lake"]), set()).add(d)
        facts[reader.FILES[kind]] = {"walleye rows whose date falls in another year than their entry": other_year,
                                     "walleye rows with no readable year in the date": unread}
    return (out if any_dates else None), facts


def marks(folder):
    """R8: {lake: {year: the unmarked share of that fall's age-0 catch}}, where the file is there; the shares
    outside 0 to 1, or blank, are skipped and counted. None where the file is not."""
    path = Path(folder) / MARKS["file"]
    if not path.exists():
        return None, {"R8": "not in the folder"}
    out, skipped = {}, 0
    with path.open(newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            lid, yr = reader.code(row.get(MARKS["columns"]["lake"]) or ""), reader.year_of(row.get(MARKS["columns"]["year"]) or "")
            share = reader.num(row.get(MARKS["columns"]["unmarked share"]) or "")
            if yr is None or share is None or not 0 <= share <= 1:
                skipped += 1
                continue
            out.setdefault(lid, {})[yr] = share
    return out, {"R8 lake-years read": sum(len(v) for v in out.values()), "R8 rows skipped": skipped}


def facts(folder):
    """The layout step's facts on T1R's additions, from the structural columns alone: the stocking files' date
    columns and the rows filed under another year than their date's; R8's rows and lakes by its lake and year
    columns, never its shares."""
    out = {"stocking dates": dated(folder)[1]}
    path = Path(folder) / MARKS["file"]
    if not path.exists():
        out["R8"] = "not in the folder"
    else:
        with path.open(newline="", encoding="utf-8-sig") as f:
            rd = csv.DictReader(f)
            names = rd.fieldnames or []
            missing = [c for c in MARKS["columns"].values() if c not in names]
            keys = {(reader.code(r.get(MARKS["columns"]["lake"]) or ""), reader.year_of(r.get(MARKS["columns"]["year"]) or ""))
                    for r in rd}
        out["R8"] = {"header": names, "columns layout.json names and the file lacks": missing,
                     "lake-years": len({k for k in keys if k[1] is not None}), "lakes": len({k[0] for k in keys})}
    return out


def write_synthetic(lakes, folder, dated_map=None, marks_map=None):
    """Add T1R's columns to synthetic files T1N's reader wrote: a date for each stocking row, in its entry's year
    or, where `dated_map` names one year for the lake's entry year less one, that year; and R8 from `marks_map`.
    For the dry run's reader and run checks."""
    for kind in ("stocking", "other"):
        path = Path(folder) / reader.FILES[kind]
        if not path.exists():
            continue
        with path.open(newline="", encoding="utf-8") as f:
            rd = csv.DictReader(f)
            names, rows = list(rd.fieldnames or []), list(rd)
        for r in rows:
            y = reader.year_of(r[reader.COLUMNS[kind]["year"]])
            lid = reader.code(r[reader.COLUMNS[kind]["lake"]])
            moved = dated_map and y is not None and (y + 1) in dated_map.get(lid, set()) and y not in dated_map.get(lid, set())
            r[DATES[kind]] = f"{(y + 1) if moved else y}-05-02" if y is not None else ""
        with path.open("w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=names + [DATES[kind]])
            w.writeheader()
            w.writerows(rows)
    if marks_map:
        c = MARKS["columns"]
        with (Path(folder) / MARKS["file"]).open("w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=[c["lake"], c["year"], c["unmarked share"]])
            w.writeheader()
            for lid, years in sorted(marks_map.items()):
                for yr, share in sorted(years.items()):
                    w.writerow({c["lake"]: lid, c["year"]: yr, c["unmarked share"]: share})
