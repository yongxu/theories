"""GLIFWC's Wisconsin spring rows as listed by gspring.py and gspring2.py, with aliases applied: writes results/reach-input/spring-glifwc.csv.

    python3 -I -B reach-kit/spring_list.py SPRING_JSON OUT_CSV

Lake code, year, county, the name as parsed, the recruitment code, and the report and page read. No value of any record.
"""

import csv
import json
import sys

spring, out = sys.argv[1:3]
rows = json.load(open(spring))
with open(out, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["WBIC", "Year", "County", "Name as parsed", "Code", "Report", "Page"])
    for t in sorted(rows, key=lambda t: (t["year"], t["county"], t["norm"])):
        w.writerow([t["wbic"] or "", t["year"], t["county"], t["norm"], t["label"] or "", t["report"], t["page"]])
