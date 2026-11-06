# WDNR's lake-level fall tables, from text and OCR pages alike. A fall-table row is a row with a survey date from August on
# and one of R1's lake codes. Keeps (lake, fall year), prints counts per year. Reads no catch.
import collections, csv, glob, json, re, sys
X, r1, out = sys.argv[1], sys.argv[2], sys.argv[3]
codes = {str(int(float(r['WBIC']))) for r in csv.DictReader(open(r1, newline='', encoding='utf-8-sig'))}
DATE = re.compile(r'\b(\d{1,2})[/\-](\d{1,2})[/\-](\d{2,4})\b')
def rows_of(report):
    t = open(f'{X}/wdnr/wdnr_{report}.txt', encoding='utf-8', errors='replace').read().split('\f')
    for k, pg in enumerate(t):
        for l in pg.splitlines():
            yield k + 1, l
    for f in glob.glob(f'{X}/ocr-wdnr/wdnr_{report}-p*.tsv'):
        boxes = [l.rstrip('\n').split('\t') for l in open(f, encoding='utf-8')]
        boxes = [b for b in boxes if len(b) >= 7]
        boxes.sort(key=lambda b: float(b[2]))
        line, last = [], None
        for b in boxes:
            y = float(b[2])
            if last is not None and y - last > 0.006:
                line.sort(key=lambda c: float(c[1]))
                yield int(b[0]), ' '.join(c[6] for c in line)
                line = []
            line.append(b)
            last = y
        if line:
            line.sort(key=lambda c: float(c[1]))
            yield int(line[0][0]), ' '.join(c[6] for c in line)
found = collections.defaultdict(set)
perreport = {}
for p in sorted(glob.glob(f'{X}/wdnr/wdnr_*.txt')):
    report = p.split('/')[-1][5:-4]
    first = int(report[:4])
    n = hit = 0
    pages = collections.Counter()
    for pg, l in rows_of(report):
        ds = [m for m in DATE.finditer(l) if 8 <= int(m.group(1)) <= 12 and 1 <= int(m.group(2)) <= 31]
        if not ds:
            continue
        n += 1
        y = int(ds[0].group(3)); y = y + 2000 if y < 100 else y
        cs = [c for c in re.findall(r'\b\d{5,7}\b', l) if c in codes]
        if cs:
            hit += 1
            pages[pg] += 1
            found[y if abs(y - first) <= 1 else first].add(cs[0])
    perreport[report] = {'rows with a fall date': n, 'with an R1 code': hit, 'pages': sorted(pages)[:14]}
for k, v in perreport.items():
    print(k, v)
print({y: len(s) for y, s in sorted(found.items())})
json.dump({str(y): sorted(s) for y, s in found.items()}, open(out, 'w'))
