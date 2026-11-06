# OCR at the rotation that gives rows beginning with a county of R1, page by page. Keeps boxes per report; prints counts, no value.
import csv, json, os, re, subprocess, sys, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(sys.argv[0])))
import rows as R
S, RR, X, r1 = sys.argv[1:5]
jobs = json.load(open(sys.argv[5]))      # list of [pdf, out_tsv, [pages], [rotations to try in order]]
counties = {r['County'].strip().upper() for r in csv.DictReader(open(r1, newline='', encoding='utf-8-sig'))} | {'ST CROIX','SAINT CROIX','EAU CLAIRE','GREEN LAKE'}
def score(lines):
    n = 0
    for s in lines:
        w = s.replace(',', ' ').upper().split()
        if w[:1] and w[0] in ('WI', 'WL', 'W1'):
            w = w[1:]
        if (' '.join(w[:2]) in counties or ' '.join(w[:1]) in counties) and re.search(r'\d', s):
            n += 1
    return n
for pdf, out, pages, rots in jobs:
    kept = []
    for p in pages:
        best, bestb, bestr = -1, None, None
        for rot in rots:
            t = tempfile.NamedTemporaryFile(suffix='.tsv', delete=False, dir=S).name
            subprocess.run(['nice', '-n', '10', S + '/pdf/pdfocr2', pdf, t, '3', str(rot), str(p), str(p)], capture_output=True, timeout=240)
            ls = R.pages_from_tsv(t).get(p, [])
            sc = score(ls)
            if sc > best:
                best, bestb, bestr = sc, open(t, encoding='utf-8').read(), rot
            os.unlink(t)
            if sc >= 5:
                break
        kept.append(bestb or '')
        print(os.path.basename(pdf)[:32], 'page', p, 'rotation', bestr, 'county rows', best, flush=True)
    open(out, 'w', encoding='utf-8').write(''.join(kept))
print('ROTOCRDONE', flush=True)
