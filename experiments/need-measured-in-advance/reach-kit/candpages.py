# For GLIFWC's reports before 2011's: which pages have a table's caption or the words of its heads, at rotation 0, in text or OCR. Prints page numbers and masked captions only.
import glob, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(sys.argv[0])))
import rows as R
X, out = sys.argv[1], sys.argv[2]
early = ['99-11','00-03','00-09','01-10','02-03','03-06','04-07','05-06','06-07','07-12','09-05','09-07','11-05','11-06']
WORDS = re.compile(r'(?i)recruitment surv|hours surv|shore miles|population estimates?|adult pop|temp-? ?erature|surface area|lake \(?acres')
res = {}
for rep in early:
    name = f'Administrative_Report_{rep}'
    t = open(f'{X}/glifwc/{name}.txt', encoding='utf-8', errors='replace').read().split('\f')
    pages = {}
    if sum(1 for p in t if len(p.strip()) > 80) >= 5:
        pages = {k + 1: pg for k, pg in enumerate(t)}
        src = 'text'
    if os.path.exists(f'{X}/ocr/{name}.tsv'):
        for p, ls in R.pages_from_tsv(f'{X}/ocr/{name}.tsv').items():
            pages[p] = pages.get(p, '') + '\n' + '\n'.join(ls)
        src = 'ocr' if len(t) < 5 or not any(len(p.strip()) > 80 for p in t) else 'text+ocr'
    cand = sorted(p for p, tx in pages.items() if WORDS.search(tx))
    n = len(pages)
    res[rep] = {'name': name, 'pages': n, 'cand': cand, 'src': src}
    print(rep, 'pages', n, 'src', src, 'cand', len(cand), cand[:60])
json.dump(res, open(out, 'w'))
