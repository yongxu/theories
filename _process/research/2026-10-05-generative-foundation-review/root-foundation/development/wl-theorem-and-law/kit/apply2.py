#!/usr/bin/env python3
"""apply2 <dir>: build every <piece>.md from <piece>.orig.md, the verdict files and the coordinator's decisions.
 - verdicts: <piece>.v1.txt, overridden per use by decisions.json {piece: {id: class}} (class A = swap; anything else = keep)
 - manual.json: [{piece, line, old, new}] sentence edits; 'old' is found once in the ORIGINAL line; swaps inside it are dropped
 - hold.json: {piece: [line, ...]} lines where no swap is applied (pinned or defining lines; manual edits still apply)
Writes <piece>.md and changes.json (every changed line, old and new)."""
import sys, os, json, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sheet import verdicts
d = sys.argv[1]
man = json.load(open(d + '/manifest.json'))
def load(name, default):
    p = f'{d}/{name}'
    return json.load(open(p, encoding='utf-8')) if os.path.exists(p) else default
dec = load('decisions.json', {})
manual = load('manual.json', [])
hold = load('hold.json', {})
post = load('post.json', [])
SWAP = {'law': 'theorem', 'laws': 'theorems', 'Law': 'Theorem', 'Laws': 'Theorems'}
changes = []; nsw = nman = 0; errs = []
for m in man:
    piece = m['piece']
    orig = open(f'{d}/{piece}.orig.md', encoding='utf-8').read()
    L = orig.split('\n')
    if m.get('skip') or not os.path.exists(f'{d}/{piece}.cands.json'):
        with open(f'{d}/{piece}.md', 'w', encoding='utf-8') as f: f.write(orig)
        continue
    cs = json.load(open(f'{d}/{piece}.cands.json'))
    v = verdicts(d, piece) if os.path.exists(f'{d}/{piece}.v1.txt') else {}
    over = dec.get(piece, {})
    held = set(hold.get(piece, []))
    spans = {}
    for e in [x for x in manual if x['piece'] == piece]:
        line = L[e['line'] - 1]
        if line.count(e['old']) != 1:
            errs.append(f"{piece} line {e['line']}: manual 'old' occurs {line.count(e['old'])} times: {e['old'][:60]!r}"); continue
        s = line.find(e['old'])
        spans.setdefault(e['line'], []).append((s, s + len(e['old']), e['new'], 'manual')); nman += 1
    for c in cs:
        cl = over.get(str(c['id']), v.get(c['id'], ('?', ''))[0])
        if cl != 'A' or c['line'] in held: continue
        lst = spans.setdefault(c['line'], [])
        if any(s <= c['start'] and c['end'] <= e2 for s, e2, _, k in lst if k == 'manual'): continue
        assert L[c['line'] - 1][c['start']:c['end']] == c['word']
        lst.append((c['start'], c['end'], SWAP[c['word']], 'swap')); nsw += 1
    for ln, lst in spans.items():
        lst.sort()
        for (a, b, _, _), (a2, b2, _, _) in zip(lst, lst[1:]):
            if a2 < b: errs.append(f'{piece} line {ln}: overlapping edits')
        line = old = L[ln - 1]
        for s, e2, new, _ in sorted(lst, reverse=True):
            line = line[:s] + new + line[e2:]
        for e in post:
            if e['piece'] != piece: continue
            if 'find' in e and e.get('line') is None:
                if e['find'] not in line: continue
            elif e['line'] != ln: continue
            if line.count(e['old']) != 1:
                errs.append(f"{piece} line {ln}: post 'old' occurs {line.count(e['old'])} times: {e['old'][:70]!r}"); continue
            line = line.replace(e['old'], e['new']); e['done'] = True
        L[ln - 1] = line
        if line != old: changes.append({'piece': piece, 'file': m['file'], 'line': ln, 'old': old, 'new': line})
    with open(f'{d}/{piece}.md', 'w', encoding='utf-8') as f: f.write('\n'.join(L))
with open(f'{d}/changes.json', 'w', encoding='utf-8') as f: json.dump(changes, f, ensure_ascii=False, indent=0)
print('swaps', nsw, 'manual', nman, 'lines changed', len(changes))
for e in post:
    if not e.get('done'): errs.append(f"post edit not applied: {e['piece']} {e.get('line')} {e['old'][:60]!r}")
for e in errs: print('ERROR', e)
sys.exit(1 if errs else 0)
