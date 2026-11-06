# GLIFWC's spring (Table A1) and fall (Table C2 or B2) tables, from text and OCR alike. Keeps county, lake's name, year and
# the rest of the row unprinted; prints counts only; lake names matched to R1's by county and normalised name.
import collections, csv, glob, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(sys.argv[0])))
import rows as R
X, r1, out = sys.argv[1], sys.argv[2], sys.argv[3]
rows1 = list(csv.DictReader(open(r1, newline='', encoding='utf-8-sig')))
def norm(s):
    s = s.upper().replace('.', ' ').replace(',', ' ').replace('&', ' AND ').replace("'", '').replace('-', ' ')
    s = re.sub(r'\b(LAKE|LAKES|LK|L|FLOWAGE|FLOW|FLW|FL|RES|RESERVOIR|CHAIN)\b', ' ', s)
    return re.sub(r'\s+', ' ', s).strip()
key, counties = {}, set()
for r in rows1:
    c = r['County'].strip().upper()
    counties.add(c)
    key[(c, norm(r['Waterbody Name']))] = str(int(float(r['WBIC'])))
counties |= {'ST CROIX', 'SAINT CROIX', 'EAU CLAIRE', 'GREEN LAKE'}
def pages(report):
    tx = f'{X}/glifwc/{report}.txt'
    t = open(tx, encoding='utf-8', errors='replace').read().split('\f')
    if sum(1 for p in t if len(p.strip()) > 80) >= 5:
        return {k + 1: [re.sub(r'\s+', ' ', l).strip() for l in pg.splitlines()] for k, pg in enumerate(t)}
    return R.pages_from_tsv(f'{X}/ocr/{report}.tsv')
CAP = re.compile(r'(?i)^\W*(Table|Tabie|Tab1e)\s*[A-Z]?\s*\d+\s*[\.:]?\s*(Spring|Fall|Fail)\s+(\d{4})\s*(.*)')
tables = []
for tx in sorted(glob.glob(f'{X}/glifwc/*.txt')):
    report = tx.split('/')[-1][:-4]
    section, year = None, None
    nf = ns = nrow = 0
    for pg, ls in pages(report).items():
        for s in ls:
            m = CAP.match(s)
            if m:
                rest = m.group(4).lower()
                kind = m.group(2).lower().replace('fail', 'fall')
                year = int(m.group(3))
                section = None
                if kind == 'spring' and 'adult population estimates' in rest and 'length' not in s.lower() and 'aged' not in s.lower():
                    section = 'spring'
                elif kind == 'fall' and 'recruitment survey' in rest and not re.search(r'(?i)summary|other', s):
                    section = 'fall'
                continue
            if re.match(r'(?i)^\W*(Table|Appendix|Figure)\b', s):
                if not re.search(r'(?i)cont', s):
                    section = None
                continue
            if section is None:
                continue
            w = s.replace(',', ' ').split()
            if w and w[0] in ('WI', 'MI', 'MN', 'Wl', 'W1'):
                if w[0] != 'WI' and w[0] not in ('Wl', 'W1'):
                    continue
                w = w[1:]
            c = None
            for n in (2, 1):
                cand = ' '.join(w[:n]).upper()
                if cand in counties:
                    c = cand; break
            if not c:
                continue
            words = s.split()
            i = next((k for k, t in enumerate(w) if k >= n and re.search(r'\d', t)), None)
            if i is None:
                continue
            name = ' '.join(w[n:i])
            tables.append({'report': report, 'kind': section, 'year': year, 'county': c, 'name': name, 'norm': norm(name), 'wbic': key.get((c, norm(name))), 'page': pg, 'row': s})
            nrow += 1
            if section == 'fall': nf += 1
            else: ns += 1
    print(report[-18:], 'years', sorted({t['year'] for t in tables if t['report'] == report}), 'spring', ns, 'fall', nf)
json.dump(tables, open(out, 'w'))
by = collections.Counter((t['kind'], t['year']) for t in tables)
hit = collections.Counter((t['kind'], t['year']) for t in tables if t['wbic'])
for kind in ('spring', 'fall'):
    print(kind, 'rows, of them lakes of R1 by name, by year:', {y: (by[(k, y)], hit[(k, y)]) for k, y in sorted(by) if k == kind})
