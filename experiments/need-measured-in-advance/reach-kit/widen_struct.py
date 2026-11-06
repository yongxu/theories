# A structural folder for reach.py: R1's lakes, years and labels with GLIFWC's spring lake-years added, and R5. No value of any record.
# Variant 'wide': GLIFWC's NR, C-NR and C- read as NATURAL, as WDNR's appendix groups them. Variant 'strict': NR alone, T1N's own map.
# A code not read is taken as natural in those two, favouring reading, and as not natural in 'wide-unread-not' and 'strict-unread-not'.
# R1's own NATURAL is left as it is in all four.
import collections, csv, json, os, re, shutil, sys
S, frozen, out = sys.argv[1:4]
spring = json.load(open(f'{S}/glifwc-spring.json'))
def norm(s):
    s = s.upper().replace('.', ' ').replace(',', ' ').replace('&', ' AND ').replace("'", '').replace('-', ' ')
    s = re.sub(r'\b(LAKE|LAKES|LK|L|FLOWAGE|FLOW|FLW|FL|RES|RESERVOIR|CHAIN)\b', ' ', s)
    return re.sub(r'\s+', ' ', s).strip()
key = {}
for r in csv.DictReader(open(f'{frozen}/adult_estimates.csv', newline='', encoding='utf-8-sig')):
    key[(r['County'].strip().upper(), norm(r['Waterbody Name']))] = str(int(float(r['WBIC'])))
for r in csv.DictReader(open(f'{frozen}/stocking.csv', newline='', encoding='utf-8-sig')):
    c, n, w = (r['STOCKED_COUNTY_NAME'] or '').strip().upper(), r['STOCKED_WB_NAME'] or r['LOCAL_WB_NAME'] or '', (r['WBIC'] or '').strip()
    if c and n and w:
        key.setdefault((c, norm(n)), w)
# fall lake-years with the wider key
fall = json.load(open(f'{S}/glifwc-early.json')) + json.load(open(f'{S}/glifwc.json'))
fall = [t for t in fall if t['kind'] == 'fall' and t['year']]
wdnr = json.load(open(f'{S}/wdnr-fall3.json'))
listed = {(str(w), int(y)) for y, ws in wdnr.items() for w in ws}
listed |= {(t['wbic'] or key.get((t['county'], t['norm'])), t['year']) for t in fall if t['wbic'] or key.get((t['county'], t['norm']))}
unmatched = collections.Counter((t['county'], t['year']) for t in fall if not (t['wbic'] or key.get((t['county'], t['norm']))))
print('fall rows', len(fall), 'with no lake code', sum(unmatched.values()))
for variant, nat, unread in (('wide', {'NR', 'C-NR', 'C-'}, True), ('strict', {'NR'}, True), ('wide-unread-not', {'NR', 'C-NR', 'C-'}, False), ('strict-unread-not', {'NR'}, False)):
    d = f'{out}/{variant}'
    os.makedirs(d, exist_ok=True)
    rows = []
    for r in csv.DictReader(open(f'{frozen}/adult_estimates.csv', newline='', encoding='utf-8-sig')):
        rows.append((str(int(float(r['WBIC']))), int(float(r['Survey Year'])), r['Primary Recruitment Source'].strip(), 'FMIS'))
    have = {(a, b) for a, b, _, _ in rows}
    added = 0
    for t in spring:
        if not t['wbic'] or not str(t['wbic']).isdigit():
            continue
        lab = 'NATURAL' if t['label'] in nat or (t['label'] is None and unread) else 'STOCKED'
        if (t['wbic'], t['year']) not in have or lab == 'NATURAL':
            rows.append((t['wbic'], t['year'], lab, 'GLIFWC'))
            added += (t['wbic'], t['year']) not in have
    with open(f'{d}/adult_estimates.csv', 'w', newline='') as f:
        w = csv.writer(f); w.writerow(['WBIC', 'Survey Year', 'Primary Recruitment Source'])
        for a, b, c, _ in rows:
            w.writerow([a, b, c])
    shutil.copy(f'{frozen}/stocking.csv', f'{d}/stocking.csv')
    print(variant, 'rows', len(rows), 'lake-years added', added, 'lakes', len({a for a, _, _, _ in rows}))
with open(f'{out}/fall-wide-listed.csv', 'w', newline='') as f:
    w = csv.writer(f); w.writerow(['WBIC', 'Year'])
    for a, b in sorted(listed):
        w.writerow([a, b])
print('fall lake-years', len(listed))
