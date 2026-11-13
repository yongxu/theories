#!/usr/bin/env python3
"""follow <tree> <run> [--apply] [width]: carry each changed sentence into the files that hold it word for word."""
import sys, json, glob, difflib, os, re
tree, run = sys.argv[1], sys.argv[2]
apply = '--apply' in sys.argv
W = int(sys.argv[-1]) if sys.argv[-1].isdigit() else 30
ch = json.load(open(run + '/changes.json'))
pairs = {}
for c in ch:
    o, n = c['old'], c['new']
    sm = difflib.SequenceMatcher(None, o, n, autojunk=False)
    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == 'equal': continue
        a = max(0, i1 - W); b = min(len(o), i2 + W)
        # trim to word boundaries inside the equal context
        while a < i1 and a > 0 and o[a - 1].isalnum(): a += 1
        while b > i2 and b < len(o) and o[b].isalnum(): b -= 1
        ow = o[a:b]; nw = o[a:i1] + n[j1:j2] + o[i2:b]
        if ow != nw and len(ow) >= 14: pairs[ow] = nw
print('windows', len(pairs))
pats = ['tools/research/*.py', 'tools/research/tests/*.py', 'theories/becoming/results/atlas/entries/*.json',
        'theories/becoming/results/data/spine.json', 'theories/becoming/results/data/lineage.json', 'theories/becoming/results/data/regions.json',
        'theories/becoming/results/data/arguments-a-l.json', 'theories/becoming/results/data/arguments-m-z.json',
        'theories/becoming/results/data/generativity-chain.json', 'theories/becoming/results/data/law-families.json', 'theories/becoming/results/data/shared-laws.json',
        '_process/research-config.json']
tot = 0
for pat in pats:
    for p in sorted(glob.glob(f'{tree}/{pat}')):
        s = open(p, encoding='utf-8').read(); t = s; n = 0; shown = []
        for ow, nw in pairs.items():
            for a, b in ((ow, nw), (json.dumps(ow, ensure_ascii=False)[1:-1], json.dumps(nw, ensure_ascii=False)[1:-1])):
                k = t.count(a)
                if k:
                    t = t.replace(a, b); n += k; shown.append(a[:90])
        if n:
            tot += n
            print(f'{n:4d} {os.path.relpath(p, tree)}')
            if 'entries' not in p:
                for x in shown: print('        ', x)
            if apply:
                with open(p, 'w', encoding='utf-8') as f: f.write(t)
print('replacements', tot, '(applied)' if apply else '(dry run)')
