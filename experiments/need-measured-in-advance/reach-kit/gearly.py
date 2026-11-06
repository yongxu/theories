# GLIFWC's reports before 2012's, from the OCR at the rotation that gives rows: the same parsing as gfall2. Counts and masked captions only.
import collections, csv, json, os, re, sys, glob
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
wbics = set(key.values())
counties |= {'ST CROIX', 'SAINT CROIX', 'EAU CLAIRE', 'GREEN LAKE'}
CAP = re.compile(r'(?i)^\W*(Table|Tabie|Tab1e)\s*[A-Z]?\s*\d+\s*[\.:]?\s*(.*)')
YR = re.compile(r'(?i)\b(Spring|Fall|Fail)\s+(\d{4})\b')
tables, caps = [], collections.defaultdict(list)
for tsv in sorted(glob.glob(f'{X}/ocr-rot/*.tsv')):
    report = os.path.basename(tsv)[:-4]
    section, year = None, None
    for pg, ls in R.pages_from_tsv(tsv).items():
        for s in ls:
            m = CAP.match(s)
            if m:
                y = YR.search(s)
                section = None
                caps[report].append((pg, re.sub(r'\d', '9', s)[:90]))
                if y:
                    year = int(y.group(2))
                    kind = y.group(1).lower().replace('fail', 'fall')
                    low = s.lower()
                    if kind == 'spring' and re.search(r'population estimates?', low) and 'length' not in low and 'aged' not in low:
                        section = 'spring'
                    elif kind == 'fall' and 'recruitment' in low and not re.search(r'summary|other', low):
                        section = 'fall'
                elif re.search(r'(?i)cont', s):
                    pass
                continue
            if section is None:
                continue
            w = s.replace(',', ' ').split()
            code = None
            if w and re.fullmatch(r'\d{5,7}', w[0]):
                code = w[0]
                w = w[1:]
            if w and w[0] in ('WI', 'Wl', 'W1'):
                w = w[1:]
            elif w and w[0] in ('MI', 'MN'):
                continue
            c, n = None, 0
            for n in (2, 1):
                cand = ' '.join(w[:n]).upper()
                if cand in counties:
                    c = cand
                    break
            if not c:
                continue
            i = next((k for k, t in enumerate(w) if k >= n and re.search(r'\d', t)), None)
            if i is None:
                continue
            name = ' '.join(w[n:i])
            tables.append({'report': report, 'kind': section, 'year': year, 'county': c, 'name': name, 'norm': norm(name), 'wbic': code if code in wbics else key.get((c, norm(name))), 'page': pg, 'row': s})
json.dump(tables, open(out, 'w'))
json.dump(caps, open(out + '.caps', 'w'), indent=0)
by = collections.Counter((t['report'][-5:], t['kind'], t['year']) for t in tables)
hit = collections.Counter((t['report'][-5:], t['kind'], t['year']) for t in tables if t['wbic'])
for k in sorted(by):
    print(k, by[k], hit[k])
