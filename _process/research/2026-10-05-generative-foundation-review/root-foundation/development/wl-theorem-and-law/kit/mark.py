#!/usr/bin/env python3
"""mark <piecesdir>: for every piece write <piece>.marked.md (each candidate use followed by a tag ⟦n⟧)
and <piece>.cands.json; write units.json (pieces packed per classifier)."""
import sys, os, json, glob, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cands import cands
d = sys.argv[1]
man = json.load(open(d + '/manifest.json'))
frozen = json.load(open('/Users/ren/tmp/wl/frozen-windows.json'))
units = []; cur = None
tot = 0
for m in man:
    if m.get('skip'):
        continue
    piece = m['piece']
    t = open(f'{d}/{piece}.orig.md', encoding='utf-8').read()
    L = t.split('\n')
    cs = cands(t)
    byline = {}
    out = []
    for n, (i, s, e, w) in enumerate(cs, 1):
        byline.setdefault(i, []).append((s, e, n))
        out.append({'id': n, 'line': i, 'start': s, 'end': e, 'word': w})
    for i, lst in byline.items():
        line = L[i - 1]
        for s, e, n in sorted(lst, reverse=True):
            line = line[:e] + '⟦%d⟧' % n + line[e:]
        L[i - 1] = line
    with open(f'{d}/{piece}.marked.md', 'w', encoding='utf-8') as f:
        f.write('\n'.join(L))
    with open(f'{d}/{piece}.cands.json', 'w', encoding='utf-8') as f:
        json.dump(out, f, indent=0)
    tot += len(cs)
    if not cs:
        continue
    words = len(t.split())
    if cur and cur['file'] == m['file'] and cur['cands'] + len(cs) <= 62 and cur['words'] + words <= 11500:
        cur['pieces'].append(piece); cur['cands'] += len(cs); cur['words'] += words
    else:
        cur = {'file': m['file'], 'pieces': [piece], 'cands': len(cs), 'words': words}
        units.append(cur)
for k, u in enumerate(units):
    u['label'] = u['pieces'][0] + ('+%d' % (len(u['pieces']) - 1) if len(u['pieces']) > 1 else '')
    u['counts'] = {p: len(json.load(open(f'{d}/{p}.cands.json'))) for p in u['pieces']}
with open(d + '/units.json', 'w') as f:
    json.dump(units, f, indent=1)
print('candidates', tot, 'units', len(units))
for u in units:
    print('%-34s cands %3d words %5d  %s' % (u['label'], u['cands'], u['words'], ' '.join(u['pieces'])))
