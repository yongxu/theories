# GLIFWC's spring adult tables, all reports: lake (by code, or county and name), year and the recruitment code. Masked; counts only.
import collections, csv, glob, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(sys.argv[0])))
import rows as R
X, r1, r5, out = sys.argv[1:5]
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
rows5 = csv.DictReader(open(r5, newline='', encoding='utf-8-sig'))
print('R5 columns', rows5.fieldnames)
for r in rows5:
    c = (r.get('STOCKED_COUNTY_NAME') or '').strip().upper()
    n = r.get('STOCKED_WB_NAME') or r.get('LOCAL_WB_NAME') or ''
    w = (r.get('WBIC') or '').strip()
    if c and n and w:
        key.setdefault((c, norm(n)), w)
        counties.add(c)
counties |= {'ST CROIX', 'SAINT CROIX', 'EAU CLAIRE', 'GREEN LAKE'}
CAP = re.compile(r'(?i)^\W*(Table|Tabie|Tab1e)\s*[A-Z]?\s*\d+\s*[\.:]?\s*(.*)')
YR = re.compile(r'(?i)\bSpring\s+(\d{4})\b')
CODE = re.compile(r'\b(C-NR|C-ST|O-ST|NR|ST|REM|C-)(?=\s|$)')
sources = []
for tx in sorted(glob.glob(f'{X}/glifwc/*.txt')):
    rep = os.path.basename(tx)[:-4]
    t = open(tx, encoding='utf-8', errors='replace').read().split('\f')
    pages = {}
    if sum(1 for p in t if len(p.strip()) > 80) >= 5:
        pages.update({k + 1: [re.sub(r'\s+', ' ', l).strip() for l in pg.splitlines()] for k, pg in enumerate(t)})
    taken = set()
    for d in ('ocr-rot-spring', 'ocr-rot', 'ocr'):
        f = f'{X}/{d}/{rep}.tsv'
        if os.path.exists(f):
            for p, ls in R.pages_from_tsv(f).items():
                if p not in taken and any(CAP.match(s) and YR.search(s) and re.search(r'(?i)adult (walleye )?population estimates?', s) for s in ls):
                    pages[p] = ls                # the rotation that read rows wins over the text layer
                    taken.add(p)
    sources.append((rep, pages))
found = []
for rep, pages in sources:
    section, year = None, None
    for pg, ls in sorted(pages.items()):
        for s in ls:
            m = CAP.match(s)
            if m:
                y = YR.search(s)
                low = s.lower()
                if y and re.search(r'adult (walleye )?population estimates?', low) and 'length' not in low and 'aged' not in low:
                    section, year = True, int(y.group(1))
                elif not re.search(r'(?i)cont', s):
                    section = None
                continue
            if not section:
                continue
            w = s.replace(',', ' ').split()
            code = None
            if w and re.fullmatch(r'\d{5,7}', w[0]):
                code = w[0]; w = w[1:]
            if w and w[0] in ('WI', 'Wl', 'W1'):
                w = w[1:]
            elif w and w[0] in ('MI', 'MN'):
                continue
            c, n = None, 0
            for n in (2, 1):
                cand = ' '.join(w[:n]).upper()
                if cand in counties:
                    c = cand; break
            if not c:
                continue
            i = next((k for k, t in enumerate(w) if k >= n and re.search(r'\d', t)), None)
            if i is None:
                continue
            name = ' '.join(w[n:i])
            lab = CODE.search(s)
            found.append({'report': rep, 'year': year, 'county': c, 'norm': norm(name), 'wbic': code or key.get((c, norm(name))), 'label': lab.group(1) if lab else None, 'page': pg})
json.dump(found, open(out, 'w'))
by = collections.Counter(t['year'] for t in found)
hit = collections.Counter(t['year'] for t in found if t['wbic'])
print('rows, of them with a lake code, by year', {y: (by[y], hit[y]) for y in sorted(by)})
print('labels', collections.Counter(t['label'] for t in found))
inr1 = sum(1 for t in found if t['wbic'] in wbics)
print('rows', len(found), 'lake in R1', inr1, 'lakes', len({t['wbic'] for t in found if t['wbic']}))
