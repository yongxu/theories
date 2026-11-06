# GLIFWC's spring tables of 2020 and 2022, which gspring.py did not parse: the 2020 table's rows lie on one text line and
# the 2022 table's columns are split over many, so the rows are found in the page's text joined up. Adds them to the list
# gspring.py wrote, keeping its form: lake (by county and name), year and the recruitment code. Prints counts only.
# Usage: gspring2.py TEXT_DIR R1.csv R5.csv SPRING.json
import collections, csv, json, re, sys
X, r1, r5, path = sys.argv[1:5]
TABLES = ((2020, 'AssessmentReport2020_final', 17), (2022, 'AssessmentReport_2022', 18))
def norm(s):
    s = s.upper().replace('.', ' ').replace(',', ' ').replace('&', ' AND ').replace("'", '').replace('-', ' ')
    s = re.sub(r'\b(LAKE|LAKES|LK|L|FLOWAGE|FLOW|FLW|FL|RES|RESERVOIR|CHAIN)\b', ' ', s)
    return re.sub(r'\s+', ' ', s).strip()
key, counties = {}, set()
for r in csv.DictReader(open(r1, newline='', encoding='utf-8-sig')):
    c = r['County'].strip().upper()
    counties.add(c)
    key[(c, norm(r['Waterbody Name']))] = str(int(float(r['WBIC'])))
for r in csv.DictReader(open(r5, newline='', encoding='utf-8-sig')):
    c, n, w = (r.get('STOCKED_COUNTY_NAME') or '').strip().upper(), r.get('STOCKED_WB_NAME') or r.get('LOCAL_WB_NAME') or '', (r.get('WBIC') or '').strip()
    if c and n and w:
        key.setdefault((c, norm(n)), w)
        counties.add(c)
ROW = re.compile(r'\bWI\s+([A-Z][A-Z\s\-\.\']*?)\s+\d[\d,]*\s+(C-NR|C-ST|O-ST|NR|ST|REM|C-)(?=\s)')
found = [t for t in json.load(open(path)) if t['year'] not in {y for y, _, _ in TABLES}]
for year, rep, page in TABLES:
    text = open(f'{X}/glifwc/{rep}.txt', encoding='utf-8', errors='replace').read().split('\f')[page - 1]
    text = re.sub(r'\s+', ' ', text.replace('\n', ' '))
    n = 0
    for m in ROW.finditer(text):
        w = m.group(1).split()
        for k in (2, 1):
            c = ' '.join(w[:k])
            if c in counties:
                name = ' '.join(w[k:])
                found.append({'report': rep, 'year': year, 'county': c, 'norm': norm(name), 'wbic': key.get((c, norm(name))), 'label': m.group(2), 'page': page})
                n += 1
                break
    print(year, 'rows', n, 'with a lake code', sum(1 for t in found if t['year'] == year and t['wbic']))
json.dump(found, open(path, 'w'))
by = collections.Counter(t['year'] for t in found)
print('rows in all', len(found), 'years', {y: by[y] for y in sorted(by)})
print('with a lake code', sum(1 for t in found if t['wbic']), 'labels', collections.Counter(t['label'] for t in found))
