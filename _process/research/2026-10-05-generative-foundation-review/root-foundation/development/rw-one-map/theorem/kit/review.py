#!/usr/bin/env python3
# AI-written, 13 November 2026 (the map's part of WL). Sheets for second readers: every tagged field of the map's data as it
# will stand, each changed use shown as theorem⟦id⟧ / 定理⟦id⟧, each kept use as law⟦id:kept⟧, hand rewordings listed under
# the field. Reads the untouched copy in orig/, the verdicts, decisions.json and rewrites.json; writes run/R<nn>.review.md.
import json, os, sys, collections
sys.path.insert(0, '/Users/ren/tmp/rw/wm')
import tag, apply
RUN, KIT = apply.RUN, apply.KIT
ORIG = KIT + '/orig'
PER = 55
C, V, notes, bad = apply.verdicts()
assert not bad, bad[:3]
F, D = apply.final(V)
RW = collections.defaultdict(list)
for r in json.load(open(KIT + '/rewrites.json', encoding='utf-8')):
    RW[(r['file'], tuple(r['path']))].append(r)
fields = collections.OrderedDict()
for i in sorted(C):
    fields.setdefault((C[i]['file'], tuple(C[i]['path'])), []).append(i)
data = {f: apply.load(ORIG, f) for f in tag.FILES}
blocks = collections.OrderedDict()  # record -> lines, n tags
for (f, path), ids in fields.items():
    d = data[f]
    s = apply.get(d, list(path))
    for i in sorted(ids, key=lambda i: -C[i]['start']):
        c = C[i]
        s = s[:c['start']] + ((apply.SWAP[c['word']] + '⟦%d⟧' % i) if F[i] == 'A' else (c['word'] + '⟦%d:kept⟧' % i)) + s[c['end']:]
    key, head, ctx = tag.record_of(f, d, path)
    b = blocks.setdefault((f,) + key, {'file': f, 'head': head, 'ctx': ctx, 'lines': [], 'n': 0, 'changed': 0})
    b['lines'].append('[%s] %s' % (tag.label(path), s))
    for r in RW.get((f, path), []):
        b['lines'].append('    REWORDED BY HAND after the swap, in this field: "%s" => "%s"' % (r['old'], r['new']))
    b['n'] += len(ids); b['changed'] += sum(1 for i in ids if F[i] == 'A')
sheets, cur, n = [], [], 0
for b in blocks.values():
    if cur and (n + b['n'] > PER or cur[0]['file'] != b['file'] and n > 20):
        sheets.append(cur); cur, n = [], 0
    cur.append(b); n += b['n']
if cur: sheets.append(cur)
units = []
for k, sh in enumerate(sheets, 1):
    name = 'R%02d' % k
    out = ['# Sheet %s' % name, '']
    for b in sh:
        out += ['=== %s.json: %s' % (b['file'], b['head'])] + ['    (' + c + ')' for c in b['ctx']] + b['lines'] + ['']
    open('%s/%s.review.md' % (RUN, name), 'w', encoding='utf-8').write('\n'.join(out))
    units.append({'name': name, 'files': sorted({b['file'] for b in sh}), 'records': len(sh), 'tags': sum(b['n'] for b in sh),
                  'changed': sum(b['changed'] for b in sh), 'chars': len('\n'.join(out))})
json.dump(units, open(RUN + '/review-units.json', 'w', encoding='utf-8'), indent=1)
print(len(units), 'sheets;', sum(u['tags'] for u in units), 'tags;', sum(u['changed'] for u in units), 'changed')
for u in units: print(' ', u['name'], u['files'], u['tags'], 'tags', u['changed'], 'changed', u['chars'], 'chars')
