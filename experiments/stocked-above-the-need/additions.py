"""What T1R reads beyond T1N's reader (DESIGN.md, sections 3, 5 and 10): the years of the stocking files' dates,
where they give one, so that a stocking filed under another year's entry counts in the year it was made; R8, the
unmarked share of a stocked year's fall age-0 catch, where the agency records it for a stocking it marked; and
the lake-years with more than one fall survey. The layout facts read the structural columns alone (the lake, the
year, the species and the date), never a count, a number stocked or a share.

    python3 -B additions.py facts FOLDER     # the layout step's facts on T1R's additions; no value is printed
"""

import collections
import csv
import datetime
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1r                       # noqa: E402  (checks T1N's files against T1N's freeze as it loads)
import reader                    # noqa: E402  (T1N's, checked by t1r)

LAYOUT = json.loads((HERE / "layout.json").read_text())
DATES, MARKS = LAYOUT["dates"], LAYOUT["marks"]
MONTHS = "jan feb mar apr may jun jul aug sep oct nov dec".split()


def date_year(text):
    """The year of a date as the files may give it, None where it cannot be told:
    - a four-digit year from 1900 to 2099, one or the same twice (2014-05-02, 5/2/2014, 2014/05/02, 02-May-2014,
      a range within one year); two different, a range across years, gives None;
    - eight digits, year, month and day (20140502);
    - a spreadsheet's count of days from 1899-12-30, five digits and perhaps a fraction (41761, the 2nd of May
      2014);
    - a month and day, either way round, and a two-digit year (5/2/14, 13/2/14), or a day, month's name and
      two-digit year (02-May-14): 00 to 29 read as 2000 to 2029, 30 to 99 as 1930 to 1999."""
    s = (text or "").strip()
    runs = set(re.findall(r"(?<!\d)(19\d\d|20\d\d)(?!\d)", s))
    if runs:
        return int(runs.pop()) if len(runs) == 1 else None
    if m := re.fullmatch(r"((?:19|20)\d\d)(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])", s):
        return int(m.group(1))
    if m := re.fullmatch(r"(\d{5})(\.\d+)?", s):
        y = (datetime.date(1899, 12, 30) + datetime.timedelta(days=int(m.group(1)))).year
        return y if 1900 <= y <= 2099 else None
    m = (re.fullmatch(r"(?:0?[1-9]|[12]\d|3[01])/(?:0?[1-9]|[12]\d|3[01])/(\d\d)", s)
         or re.fullmatch(r"(?:0?[1-9]|[12]\d|3[01])[-/ ]([A-Za-z]{3,9})[-/ ]+(\d\d)", s))
    if m and (m.lastindex == 1 or m.group(1)[:3].lower() in MONTHS):
        yy = int(m.group(m.lastindex))
        return 2000 + yy if yy < 30 else 1900 + yy
    return None


def rows_of(folder, kind, columns):
    path = Path(folder) / reader.FILES[kind]
    if not path.exists():
        return None, None
    with path.open(newline="", encoding="utf-8-sig") as f:
        rd = csv.DictReader(f)
        names = rd.fieldnames or []
        return [{k: row.get(c) for k, c in columns.items() if c in names} for row in rd], names


def dated(folder):
    """(the years its walleye stockings' dates fall in, by lake; the lakes undated; the facts), from the stocking
    files. A lake is undated where a walleye row of it gives no readable year in its date, or stands in a stocking
    file with no date column while the other file has one. The map is None where neither file gives a date column,
    and every lake is then undated. The facts count the rows whose date falls in another year than their entry,
    the rows with no readable year, and the lakes undated."""
    out, undated, facts, any_dates = {}, set(), {}, False
    for kind in ("stocking", "other"):
        cols = dict(reader.COLUMNS[kind])
        rows, names = rows_of(folder, kind, {**{k: cols[k] for k in ("lake", "year", "species")}, "date": DATES[kind]})
        if rows is None:
            facts[reader.FILES[kind]] = "not in the folder"
            continue
        walleye = [r for r in rows if reader.is_species(r.get("species") or "")]
        if DATES[kind] not in names:
            facts[reader.FILES[kind]] = f"no date column ({DATES[kind]!r})"
            undated |= {reader.code(r.get("lake") or "") for r in walleye}
            continue
        any_dates = True
        other_year = unread = 0
        for r in walleye:
            lid = reader.code(r.get("lake") or "")
            y, d = reader.year_of(r.get("year") or ""), date_year(r.get("date"))
            if d is None:
                unread += 1
                undated.add(lid)
                continue
            other_year += y is not None and d != y
            out.setdefault(lid, set()).add(d)
        facts[reader.FILES[kind]] = {"walleye rows whose date falls in another year than their entry": other_year,
                                     "walleye rows with no readable year in the date": unread}
    if not any_dates:
        return None, set(), facts
    facts["lakes with a walleye stocking whose date could not be read"] = len(undated)
    return out, undated, facts


def marks(folder):
    """R8: ({lake: {year: the unmarked share of that fall's age-0 catch}}, the facts), where the file is there. A
    row with no year, or a share blank or below 0, is skipped and counted; a lake-year given twice with different
    shares is dropped and counted. Where any share is above 1, the file may give percentages, and the second route
    is not read: the map is None, since no rule here guesses the file's scale. None where the file is not there."""
    path = Path(folder) / MARKS["file"]
    if not path.exists():
        return None, {"R8": "not in the folder"}
    out, skipped, above, twice = {}, 0, 0, set()
    c = MARKS["columns"]
    with path.open(newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            lid, yr = reader.code(row.get(c["lake"]) or ""), reader.year_of(row.get(c["year"]) or "")
            share = reader.num(row.get(c["unmarked share"]) or "")
            if yr is None or share is None or share < 0:
                skipped += 1
                continue
            if share > 1:
                above += 1
                continue
            if yr in out.get(lid, {}) and out[lid][yr] != share:
                twice.add((lid, yr))
            out.setdefault(lid, {})[yr] = share
    for lid, yr in twice:
        del out[lid][yr]
    facts = {"R8 lake-years read": sum(len(v) for v in out.values()), "R8 rows skipped": skipped,
             "R8 lake-years given twice with different shares, dropped": len(twice), "R8 shares above 1": above}
    if above:
        return None, {**facts, "R8": "not read: shares above 1, so the file may give percentages"}
    return out, facts


def repeated_fall(folder):
    """The lake-years with more than one fall-survey row in R2, by its lake and year columns alone."""
    cols = reader.COLUMNS["age0"]
    rows, _ = rows_of(folder, "age0", {"lake": cols["lake"], "year": cols["year"]})
    counts = collections.Counter((reader.code(r.get("lake") or ""), reader.year_of(r.get("year") or ""))
                                 for r in rows or ())
    return {k for k, n in counts.items() if n > 1 and k[1] is not None}


def facts(folder):
    """The layout step's facts on T1R's additions, from the structural columns alone: the stocking files' date
    columns, the rows filed under another year than their date's and the lakes undated; R8's rows and lakes by
    its lake and year columns, never its shares; the lake-years with more than one fall survey."""
    out = {"stocking dates": dated(folder)[2], "fall surveys: lake-years with more than one row": len(repeated_fall(folder))}
    path = Path(folder) / MARKS["file"]
    if not path.exists():
        out["R8"] = "not in the folder"
    else:
        with path.open(newline="", encoding="utf-8-sig") as f:
            rd = csv.DictReader(f)
            names = rd.fieldnames or []
            missing = [c for c in MARKS["columns"].values() if c not in names]
            keys = [(reader.code(r.get(MARKS["columns"]["lake"]) or ""), reader.year_of(r.get(MARKS["columns"]["year"]) or ""))
                    for r in rd]
        out["R8"] = {"header": names, "columns layout.json names and the file lacks": missing,
                     "lake-years": len({k for k in keys if k[1] is not None}), "lakes": len({k[0] for k in keys}),
                     "rows naming a lake-year another row names": len(keys) - len(set(keys))}
    return out


def write_synthetic(lakes, folder, dated_map=None, marks_map=None, unreadable=()):
    """Add T1R's columns to synthetic files T1N's reader wrote: a date for each stocking row, in its entry's year
    or, where `dated_map` names one year for the lake's entry year less one, that year; no readable date for the
    lakes `unreadable` names; and R8 from `marks_map`. For the dry run's reader and run checks."""
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
            r[DATES[kind]] = ("spring" if lid in unreadable else f"{(y + 1) if moved else y}-05-02" if y is not None
                              else "")
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


if __name__ == "__main__":
    if len(sys.argv) != 3 or sys.argv[1] != "facts":
        raise SystemExit(__doc__)
    print(json.dumps(facts(sys.argv[2]), indent=1, default=sorted))
