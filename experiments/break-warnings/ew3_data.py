"""EW3: the series read from their published sources into one CSV. Standard library, and pypdf
(6.14.2) for the two MARAM data records' text layer.

    python3 ew3_data.py <bcodmo.csv> <sag_summary.json> <sardine.pdf> <anchovy.pdf> <out.csv>

Sources (none committed; hashes in PREDICTIONS-2026-10-22-EW3.md):
  BCO-DMO 985565 v1, global seabird breeding success (Sydeman et al.), offspring per nesting
    female per year, by site and species.
  ICES Stock Assessment Graphs, assessment key 21106: Norwegian spring-spawning herring
    (her.27.1-24a514a), assessment year 2025, recruitment at age 2 (thousands), SSB and catches
    (tonnes).
  FISHERIES/2024/OCT/SWG-PEL/40, the data used in the 2024 sardine assessment (doi
    10.25375/uct.27824667.v1): Table 3, November survey biomass Hondeklip Bay to Cape Agulhas;
    Tables 1a, 1b, 1d, 1e, the monthly sardine catch west of Cape Agulhas (1e includes the small
    amounts landed east of it).
  FISHERIES/2024/AUG/SWG-PEL/34, the data used in the 2024 anchovy assessment (doi
    10.25375/uct.27917268.v1): Table 2, November survey biomass west of Port Alfred; Table 1,
    the monthly anchovy catch.

Output rows: series,year,value. Series: bs:<site>:<species>; ben_sardine_west, ben_anchovy,
ben_catch (sardine west of Cape Agulhas plus anchovy, tonnes); her_recruit_age2, her_ssb,
her_catch.
"""

import csv
import json
import re
import sys


def bcodmo(path):
    out = {}
    for r in csv.DictReader(open(path, encoding="utf-8")):
        v = r["breeding_success"].strip()
        if v:
            out.setdefault("bs:%s:%s" % (r["site"], r["species"]), {})[int(r["year"])] = float(v)
    return out


def sag(path):
    d = json.load(open(path, encoding="utf-8"))
    assert d["FishStock"] == "her.27.1-24a514a" and d["RecruitmentAge"] == 2
    out = {"her_recruit_age2": {}, "her_ssb": {}, "her_catch": {}}
    for line in d["Lines"]:
        y = line["Year"]
        for key, col in (("her_recruit_age2", "Recruitment"), ("her_ssb", "SSB"),
                         ("her_catch", "Catches")):
            if line.get(col) is not None:
                out[key][y] = float(line[col])
    return out


def pages(path):
    import pypdf
    return [p.extract_text() or "" for p in pypdf.PdfReader(path).pages]


def table_text(texts, title):
    """The text of the page holding the table, from its title to the next table or the end."""
    pattern = r"\s+".join(re.escape(w) for w in title.split(" "))
    for t in texts:
        m = re.search(pattern, t)
        if m:
            body = t[m.start():]
            j = body.find("Table", 10)
            return body if j < 0 else body[:j]
    raise ValueError("table not found: " + title)


def monthly_annual(text, first, last):
    """Annual sums of a monthly table (thousands of tons) for the years first..last."""
    out = {}
    for line in text.split("\n"):
        m = re.match(r"^\s*(\d{4})\s+(.*)$", line)
        if not m:
            continue
        y = int(m.group(1))
        if not first <= y <= last:
            continue
        vals = [float(x) for x in re.findall(r"\d+\.\d+", m.group(2))]
        out[y] = sum(vals) * 1000.0
    return out


def survey(text, column):
    """Survey biomass (tons) in the given biomass column (0-based) of rows starting with a year;
    thousands may be printed with a space ("1 344637")."""
    out = {}
    for line in text.replace("\xa0", " ").split("\n"):
        m = re.match(r"^\s*(\d{4})\s+(.*)$", line)
        if not m or "‐" in m.group(2) or "-" in m.group(2):
            continue
        rest = re.sub(r"(?<=\d) (?=\d{6}\b)", "", m.group(2))   # "1 344637" -> "1344637"
        nums = rest.split()
        # biomass and CV alternate
        out[int(m.group(1))] = float(nums[2 * column])
    return out


def maram(sardine_pdf, anchovy_pdf):
    s, a = pages(sardine_pdf), pages(anchovy_pdf)
    west = survey(table_text(s, "Table 3. Sardine total biomass"), 2)
    anch = survey(table_text(a, "Table 2. Anchovy total biomass"), 0)
    catch_s = {}
    for title in ("Table 1a. The monthly sardine", "Table 1b. The monthly sardine",
                  "Table 1d. The monthly sardine", "Table 1e. The monthly sardine"):
        for y, v in monthly_annual(table_text(s, title), 1984, 2023).items():
            catch_s[y] = catch_s.get(y, 0.0) + v
    catch_a = monthly_annual(table_text(a, "Table 1. The monthly anchovy"), 1984, 2023)
    years = sorted(set(catch_s) & set(catch_a))
    return {"ben_sardine_west": west, "ben_anchovy": anch,
            "ben_sardine_catch_west": catch_s, "ben_anchovy_catch": catch_a,
            "ben_catch": {y: catch_s[y] + catch_a[y] for y in years}}


def main(bco, sag_json, sardine_pdf, anchovy_pdf, out_path):
    series = {}
    series.update(bcodmo(bco))
    series.update(sag(sag_json))
    series.update(maram(sardine_pdf, anchovy_pdf))
    with open(out_path, "w", encoding="utf-8", newline="") as h:
        w = csv.writer(h)
        w.writerow(["series", "year", "value"])
        for name in sorted(series):
            for y in sorted(series[name]):
                w.writerow([name, y, repr(series[name][y])])
    print(f"{len(series)} series -> {out_path}")


if __name__ == "__main__":
    if len(sys.argv) != 6:
        print(__doc__)
        sys.exit(1)
    main(*sys.argv[1:])
