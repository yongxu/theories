"""Check names-decisions.tsv: one name per concept, anchors on current main, quotations in the frozen texts."""
import csv, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from resolve import DECLS, resolve_decl
CT = '/private/tmp/claude-501/-Users-ren-theories/ab4fc732-b2ac-420a-aa49-cf63c999271c/scratchpad/ctpkg/civilization-thought-v1.0'
model = json.load(open(CT + '/data/model.json', encoding='utf-8'))
import re as _re
def rank(s):
    era, title, layer = s.get('era') or '', s.get('title') or '', s.get('layer') or ''
    if layer == '注疏' or _re.search('[汉漢魏晋晉唐宋元明清]', era) or _re.search('注|疏|章句|本義|本义|易傳|易传|語類|语类|集|解', title): return 2
    if _re.search('战国|戰國|春秋|先秦|西周', era) or _re.match('(周易|墨子|莊子|庄子|荀子|孟子|《孟子》|论语|論語|禮記|礼记|中庸|大學|大学|孙子|孫子|韩非|韓非|公孫龍|公孙龙|商君|吳子|司马法|司馬法)', title) or s['id'] == 'YD-LAO-BASE': return 0
    return 1
texts = {}; ALIASES = []
for s in model['sources']:
    tp = s.get('text_path')
    if tp and tp in texts and texts[tp][0] != s['id']: ALIASES.append((s['id'], tp))
    if tp and tp not in texts: texts[tp] = (s['id'], open(os.path.join(CT, tp), encoding='utf-8').read(), rank(s))
P = r'[\s，。、；：！？「」『』〈〉《》“”‘’,.;:]*'
from simplify import simp as _simp
def locate(ph):
    hits = _locate(ph) + ([h for h in _locate(_simp(ph)) ] if _simp(ph) != ph else [])
    order = {sid: k for sid, t, k in texts.values()}
    seen = set(); out = []
    for h in sorted(hits, key=lambda h: order.get(h[0], 1)):
        if h[0] not in seen: seen.add(h[0]); out.append(h)
    return out
def _locate(ph):
    pat = re.compile(P.join(map(re.escape, re.sub(r'[\s，。、；：]', '', ph))))
    return [(sid, m.group(0)) for sid, t, k in sorted(texts.values(), key=lambda x: x[2]) for m in [pat.search(t)] if m] + [(sid, m.group(0)) for sid, tp in ALIASES for m in [pat.search(texts[tp][1])] if m]
from resolve import receipt
modules = {d.rsplit('.', 1)[0] for d in DECLS} | {m['module'] for m in json.load(open(receipt))['modules']}
rows = list(csv.DictReader(open(os.path.join(os.path.dirname(__file__), 'names-decisions.tsv'), encoding='utf-8'), delimiter='\t'))
seen = {}; bad = 0; out = []
for r in rows:
    n = r['名']
    if n in seen: print('DUPLICATE NAME', n, seen[n], r['篇']); bad += 1
    seen[n] = r['篇']
    anchors = [a.strip() for a in r['锚'].split('；') if a.strip() and a.strip() != '—']
    res = []
    for a in anchors:
        cur, path = resolve_decl(a)
        if not cur:
            m = a if a.startswith('Becoming.') else 'Becoming.' + a
            if m in modules: res.append(m); continue
            print('ANCHOR', n, a); bad += 1
        else:
            res.append(cur)
            if path: print('renamed', n, a, '->', cur)
    quotes = []
    for q in [x for x in r['引'].split('／') if x.strip() and x.strip() != '—']:
        if '@' in q:
            q, want = q.split('@')
            hits = [h for h in _locate(q) if h[0] == want]
        else:
            hits = locate(q)
        if not hits: print('QUOTE NONE', n, q); bad += 1
        quotes.append({'phrase': q, 'found': [{'source_id': s, 'text': t} for s, t in hits[:4]]})
    out.append({**r, 'anchors': res, 'quotes': quotes})
json.dump(out, open(os.path.join(os.path.dirname(__file__), 'names-checked.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
concepts = {}
for r in rows: concepts.setdefault(r['所名'].split('（')[0], []).append(r['名'])
for c, ns in concepts.items():
    if len(ns) > 1: print('ONE CONCEPT, TWO NAMES?', c, ns)
print(len(rows), 'names;', bad, 'problems')
