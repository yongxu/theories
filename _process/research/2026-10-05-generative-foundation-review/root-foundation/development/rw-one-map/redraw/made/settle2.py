# AI-written, 12 November 2026. Adds to settled.json the passages written and then checked for the lower bands
# (the "filled" part of the read-and-fill workflow's result).   python3 -B settle2.py <workflow output json>
import json, os, sys, collections, shutil
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from data import CONDITIONS
ids = {c['id'] for c in CONDITIONS}
ORDER = ['law', 'line', 'needs', 'built', 'reading', 'same']

res = json.load(open(sys.argv[1]))
res = res.get('result', res)
S = json.load(open(os.path.join(HERE, 'settled.json')))
if not os.path.exists(os.path.join(HERE, 'settled-before-fill.json')):
    shutil.copy(os.path.join(HERE, 'settled.json'), os.path.join(HERE, 'settled-before-fill.json'))
P = collections.OrderedDict(((q['from'], q['to']), q) for q in S['passages'])
log = S.setdefault('log', [])
added = collections.Counter()

def add(a, b, w):
    if a not in ids or b not in ids:
        log.append('fill: unknown condition in %s -> %s, not added' % (a, b)); return
    if a == b:
        S['stays'].append({'from': a, **w}); added['stay'] += 1; return
    k = (a, b)
    if k not in P and (b, a) in P and P[(b, a)]['ways'][0]['kind'] in ('line', 'same') and w['kind'] in ('line', 'same'):
        k = (b, a)
    if k in P:
        if any(x['en'] == w['en'] for x in P[k]['ways']): return
        P[k]['ways'].append(w); added['way'] += 1
    else:
        P[k] = {'from': k[0], 'to': k[1], 'ways': [w], 'paths': []}; added['passage'] += 1

for F in res['filled']:
    if not F or not F.get('checked'):
        log.append('fill: band %s not checked, nothing added' % (F or {}).get('group')); continue
    g, ch = F['group'], F['checked']
    for p in ch['passages']:
        if p['verdict'] == 'drop':
            log.append('fill %s: dropped %s -> %s: %s' % (g, p['from'], p['to'], p['why'][:200])); continue
        a, b = (p.get('new_from') or p['from'], p.get('new_to') or p['to']) if p['verdict'] == 'move' else (p['from'], p['to'])
        add(a, b, {'kind': p['kind'], 'en': p['en'].strip(), 'zh': p['zh'].strip(), 'laws': p['laws'], 'src': 'fill-%s:%s' % (g, p['verdict'])})
    for m in ch.get('missing', []):
        add(m['from'], m['to'], {'kind': m['kind'], 'en': m['en'].strip(), 'zh': m['zh'].strip(), 'laws': m['laws'], 'src': 'fill-%s:missing' % g})
    for s in ch.get('stays', []):
        if s['verdict'] == 'drop' or s['at'] not in ids: continue
        S['stays'].append({'from': s['at'], 'kind': 'law', 'en': s['en'].strip(), 'zh': s['zh'].strip(), 'laws': s['laws'], 'src': 'fill-%s:stay' % g}); added['stay'] += 1
    for c in ch.get('conditions', []):
        if c['id'] not in ids: continue
        A = S['anchors'].setdefault(c['id'], [])
        for a in c['anchors']:
            if a not in A: A.append(a)
        if c['verdict'] == 'fix' and c['id'] not in S['cond_fix']:
            S['cond_fix'][c['id']] = {'says_en': c['says_en'], 'says_zh': c['says_zh'], 'why': c['why'], 'by': 'fill-' + g}; added['gloss'] += 1
    S.setdefault('not_there', {})[g] = (F.get('written') or {}).get('not_there', [])
    S.setdefault('fill_notes', {})[g] = {'written': (F.get('written') or {}).get('notes', ''), 'checked': ch.get('notes', '')}

out = []
for k, q in P.items():
    q['ways'].sort(key=lambda w: ORDER.index(w['kind'])); q['kind'] = q['ways'][0]['kind']; out.append(q)
S['passages'] = out
json.dump(S, open(os.path.join(HERE, 'settled.json'), 'w'), ensure_ascii=False, indent=1)
print('added', dict(added), '| passages now', len(out), collections.Counter(q['kind'] for q in out), '| stays', len(S['stays']))
