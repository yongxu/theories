#!/usr/bin/env python3
"""review <dir>: write review sheets (changed lines with every swap tagged) packed into units; print the units as JSON args."""
import sys, os, json, re
sys.path.insert(0, '/Users/ren/tmp/wl/kit')
from sheet import verdicts
d = sys.argv[1]
man = json.load(open(d + '/manifest.json'))
dec = json.load(open(d + '/decisions.json')); manual = json.load(open(d + '/manual.json')); hold = json.load(open(d + '/hold.json'))
SWAP = {'law': 'theorem', 'laws': 'theorems', 'Law': 'Theorem', 'Laws': 'Theorems'}
blocks = []  # (file, piece, line, text, words, ntags)
for m in man:
    p = m['piece']
    if not os.path.exists(f'{d}/{p}.v1.txt'): continue
    L = open(f'{d}/{p}.orig.md', encoding='utf-8').read().split('\n')
    cs = json.load(open(f'{d}/{p}.cands.json')); v = verdicts(d, p); over = dec.get(p, {}); held = set(hold.get(p, []))
    spans = {}
    for e in [x for x in manual if x['piece'] == p]:
        s = L[e['line'] - 1].find(e['old'])
        spans.setdefault(e['line'], []).append((s, s + len(e['old']), e['new'] + '⟦m⟧', None))
    for c in cs:
        cl = over.get(str(c['id']), v[c['id']][0])
        if cl != 'A' or c['line'] in held: continue
        lst = spans.setdefault(c['line'], [])
        if any(s <= c['start'] and c['end'] <= e2 for s, e2, _, k in lst if k is None): continue
        lst.append((c['start'], c['end'], SWAP[c['word']] + '⟦%d⟧' % c['id'], c['id']))
    for ln in sorted(spans):
        line = L[ln - 1]
        for s, e2, new, _ in sorted(spans[ln], reverse=True):
            line = line[:s] + new + line[e2:]
        blocks.append((m['file'], p, ln, line, len(line.split()), len(spans[ln])))
units = []; cur = None
for b in blocks:
    if cur and cur['file'] == b[0] and cur['words'] + b[4] <= 6500:
        cur['blocks'].append(b); cur['words'] += b[4]; cur['tags'] += b[5]
    else:
        cur = {'file': b[0], 'blocks': [b], 'words': b[4], 'tags': b[5]}; units.append(cur)
args = []
for k, u in enumerate(units, 1):
    name = 'R%02d' % k
    out = []
    for f, p, ln, text, w, n in u['blocks']:
        out += [f'=== {p} line {ln}', text, '']
    with open(f'{d}/{name}.review.md', 'w', encoding='utf-8') as fh: fh.write('\n'.join(out))
    pieces = sorted({b[1] for b in u['blocks']})
    args.append({'name': name, 'file': u['file'], 'pieces': pieces, 'tags': u['tags'], 'lines': len(u['blocks'])})
    print(name, u['file'].split('/')[-1], 'lines', len(u['blocks']), 'tags', u['tags'], 'words', u['words'], ' '.join(pieces))
with open(d + '/review-units.json', 'w') as fh: json.dump(args, fh)
print(json.dumps(args, separators=(',', ':')))
