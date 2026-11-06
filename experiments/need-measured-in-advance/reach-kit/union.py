# The lake-years the published fall tables list, from the parsed lists: LISTED (a row matched to a lake of R1 by code or
# by county and name) and GENEROUS (also every lake of R1 in a county-year where a table's row matched no lake of R1, or in
# a WDNR year whose table the OCR read poorly). Reads no value of any record: lake, county, year only. Prints counts.
import collections, csv, json, sys
wd, ge, gl, r1, out1, out2 = sys.argv[1:7]
POOR = {2005, 2008, 2015}     # WDNR's fall tables on images the OCR did not read in rows
wdnr = json.load(open(wd))
rows = json.load(open(ge)) + json.load(open(gl))
fall = [t for t in rows if t['kind'] == 'fall' and t['year'] is not None]
lakes = collections.defaultdict(set)   # county -> lakes of R1
ly = set()
for r in csv.DictReader(open(r1, newline='', encoding='utf-8-sig')):
    w, y, c = str(int(float(r['WBIC']))), int(float(r['Survey Year'])), r['County'].strip().upper()
    lakes[c].add(w)
    ly.add((w, y))
listed = {(str(w), int(y)) for y, ws in wdnr.items() for w in ws}
listed |= {(t['wbic'], t['year']) for t in fall if t['wbic']}
unmatched = collections.Counter((t['county'], t['year']) for t in fall if not t['wbic'])
generous = set(listed)
for (c, y), n in unmatched.items():
    generous |= {(w, y) for w in lakes.get(c, ())}
county_of = {w: c for c, ws in lakes.items() for w in ws}
all_years = {y for _, y in ly}
for y in POOR:
    generous |= {(w, yy) for w, yy in ly if yy == y}
for name, s in (('listed', listed), ('generous', generous)):
    both = s & ly
    print(name, 'lake-years', len(s), 'with an estimate of R1', len(both), 'by year up to 2012:',
          {y: sum(1 for _, yy in both if yy == y) for y in sorted(all_years) if y <= 2012})
for path, s in ((out1, listed), (out2, generous)):
    with open(path, 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['WBIC', 'Year'])
        for a, b in sorted(s):
            w.writerow([a, b])
