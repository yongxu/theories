#!/usr/bin/env python3
"""review_kept <dir>: sheets of every line that still has a kept "law" (tagged with id and the class it was kept under)."""
import sys, os, json, re
sys.path.insert(0, '/Users/ren/tmp/wl/kit')
from sheet import verdicts
d = sys.argv[1]
man = json.load(open(d + '/manifest.json'))
dec = json.load(open(d + '/decisions.json')); manual = json.load(open(d + '/manual.json')); hold = json.load(open(d + '/hold.json')); post = json.load(open(d + '/post.json'))
SWAP = {'law': 'theorem', 'laws': 'theorems', 'Law': 'Theorem', 'Laws': 'Theorems'}
blocks = []; nk = 0
for m in man:
    p = m['piece']
    if not os.path.exists(f'{d}/{p}.v1.txt'): continue
    L = open(f'{d}/{p}.orig.md', encoding='utf-8').read().split('\n')
    cs = json.load(open(f'{d}/{p}.cands.json')); v = verdicts(d, p); over = dec.get(p, {}); held = set(hold.get(p, []))
    spans = {}; kept_lines = set()
    for e in [x for x in manual if x['piece'] == p]:
        s = L[e['line'] - 1].find(e['old'])
        spans.setdefault(e['line'], []).append((s, s + len(e['old']), e['new'], 'manual'))
    for c in cs:
        first = v[c['id']][0]; fin = over.get(str(c['id']), first)
        lst = spans.setdefault(c['line'], [])
        if any(s <= c['start'] and c['end'] <= e2 for s, e2, _, k in lst if k == 'manual'): continue
        if c['line'] in held: continue
        if fin == 'A':
            lst.append((c['start'], c['end'], SWAP[c['word']], 'swap'))
        else:
            label = first if fin == first else first + '*'
            lst.append((c['start'], c['end'], c['word'] + '⟦%d:%s⟧' % (c['id'], label), 'kept')); kept_lines.add(c['line']); nk += 1
    for ln in sorted(kept_lines):
        line = L[ln - 1]
        for s, e2, new, _ in sorted(spans[ln], reverse=True):
            line = line[:s] + new + line[e2:]
        for e in post:
            if e['piece'] == p and e.get('line') == ln and line.count(e['old']) == 1: line = line.replace(e['old'], e['new'])
        blocks.append((m['file'], p, ln, line, len(line.split()), sum(1 for x in spans[ln] if x[3] == 'kept')))
units = []; cur = None
for b in blocks:
    if cur and cur['file'] == b[0] and cur['words'] + b[4] <= 6000:
        cur['blocks'].append(b); cur['words'] += b[4]; cur['tags'] += b[5]
    else:
        cur = {'file': b[0], 'blocks': [b], 'words': b[4], 'tags': b[5]}; units.append(cur)
args = []
for k, u in enumerate(units, 1):
    name = 'K%02d' % k
    out = []
    for f, p, ln, text, w, n in u['blocks']: out += [f'=== {p} line {ln}', text, '']
    with open(f'{d}/{name}.kept.md', 'w', encoding='utf-8') as fh: fh.write('\n'.join(out))
    args.append({'name': name, 'file': u['file'], 'pieces': sorted({b[1] for b in u['blocks']}), 'tags': u['tags'], 'lines': len(u['blocks'])})
    print(name, u['file'].split('/')[-1], 'lines', len(u['blocks']), 'tags', u['tags'], 'words', u['words'])
print('kept uses', nk, 'sheets', len(units))
with open(d + '/kept-units.json', 'w') as fh: json.dump(args, fh)
