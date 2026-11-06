# WDNR's lake-level fall tables with deskewed rows: a row with a survey date from August on and a lake code. Counts only.
import collections, csv, glob, json, os, re, sys
sys.path.insert(0, sys.argv[5])
import rows as R
X, r1, r5, out = sys.argv[1:5]
codes = {str(int(float(r['WBIC']))) for r in csv.DictReader(open(r1, newline='', encoding='utf-8-sig'))}
codes |= {(r['WBIC'] or '').strip() for r in csv.DictReader(open(r5, newline='', encoding='utf-8-sig'))}
DATE = re.compile(r'\b(\d{1,2})[/\-](\d{1,2})[/\-](\d{2,4})\b')
DATE2 = re.compile(r'\b(\d{1,2})[/\-](\d{1,2})\b')
found = collections.defaultdict(set)
per = {}
for p in sorted(glob.glob(f'{X}/wdnr/wdnr_*.txt')):
    rep = os.path.basename(p)[5:-4]
    first = int(rep[:4])
    rows = []
    t = open(p, encoding='utf-8', errors='replace').read().split('\f')
    for k, pg in enumerate(t):
        rows += [(k + 1, l) for l in pg.splitlines()]
    for f in glob.glob(f'{X}/ocr-wdnr/wdnr_{rep}-p*.tsv') + glob.glob(f'{X}/ocr-rot-wdnr/wdnr_{rep}.tsv'):
        for pg, ls in R.pages_from_tsv(f).items():
            rows += [(pg, l) for l in ls]
    n = 0
    pages = collections.Counter()
    for pg, l in rows:
        ds = [m for m in DATE.finditer(l) if 8 <= int(m.group(1)) <= 12 and 1 <= int(m.group(2)) <= 31]
        if not ds:
            ds2 = [m for m in DATE2.finditer(l) if 8 <= int(m.group(1)) <= 12 and 1 <= int(m.group(2)) <= 31]
            if not ds2:
                continue
            y = first
        else:
            y = int(ds[0].group(3)); y = y + 2000 if y < 100 else y
        cs = [c for c in re.findall(r'\b\d{5,7}\b', l) if c in codes]
        if cs:
            n += 1
            pages[pg] += 1
            found[y if abs(y - first) <= 1 else first].add(cs[0])
    per[rep] = (n, sorted(pages)[:10])
print({k: v[0] for k, v in per.items()})
print({y: len(s) for y, s in sorted(found.items())})
json.dump({str(y): sorted(s) for y, s in found.items()}, open(out, 'w'))
