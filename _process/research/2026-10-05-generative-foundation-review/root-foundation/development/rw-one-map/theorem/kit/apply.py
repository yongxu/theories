#!/usr/bin/env python3
# AI-written, 13 November 2026 (the map's part of WL). Applies the verdicts to the map's data in a checkout.
#   apply.py verdicts            -> reads run/<piece>.v1.txt, checks every tag has one class, writes run/v1.json and prints counts
#   apply.py sheet <classes>     -> prints every use of the given classes with its sentence (for the coordinator to decide)
#   apply.py write <root>        -> swaps every use whose final class is A (after decisions.json), then applies rewrites.json
#   apply.py review              -> writes run/R<nn>.review.md sheets of every changed field for second readers
# decisions.json: {"<id>": "A" | "B" | ... }  (the coordinator's decision for a G, N, U, T, W, D use, or a correction)
# rewrites.json:  [{"file": "paths", "path": [...], "old": "...", "new": "..."}]  (after the swaps; old occurs exactly once)
import json, os, re, sys, collections

RUN = '/Users/ren/theories/tmp/r7/sheet/wm/run'
KIT = '/Users/ren/tmp/rw/wm'
TAIL = {'sheet': '', 'passages': '', 'paths': '', 'laid': '', 'web': '\n', 'cards': '\n', 'cases': '\n'}
SWAP = {'law': 'theorem', 'laws': 'theorems', 'Law': 'Theorem', 'Laws': 'Theorems', 'LAW': 'THEOREM', 'LAWS': 'THEOREMS', '定律': '定理', '律': '定理'}
CLASSES = set('AGBCDENTWU')


def cands():
    return {int(k): v for k, v in json.load(open(RUN + '/cands.json', encoding='utf-8')).items()}


def verdicts():
    C = cands()
    V, notes, bad = {}, {}, []
    for piece in sorted({c['piece'] for c in C.values()}):
        p = '%s/%s.v1.txt' % (RUN, piece)
        if not os.path.exists(p): bad.append('missing ' + piece); continue
        for line in open(p, encoding='utf-8'):
            m = re.match(r'\s*(\d+)\s+([A-Z])\b\s*(.*)', line)
            if not m: continue
            i, c = int(m.group(1)), m.group(2)
            if i not in C or C[i]['piece'] != piece: bad.append('%s: tag %d is not of this piece' % (piece, i)); continue
            if c not in CLASSES: bad.append('%s: tag %d class %s' % (piece, i, c)); continue
            if i in V: bad.append('%s: tag %d twice' % (piece, i)); continue
            V[i], notes[i] = c, m.group(3).strip()
    bad += ['tag %d (%s) has no verdict' % (i, C[i]['piece']) for i in C if i not in V]
    return C, V, notes, bad


def final(V):
    p = KIT + '/decisions.json'
    D = {int(k): v for k, v in json.load(open(p, encoding='utf-8')).items()} if os.path.exists(p) else {}
    F = dict(V); F.update(D)
    return F, D


def load(root, name):
    return json.load(open(os.path.join(root, 'theories/becoming/results/map', name + '.json'), encoding='utf-8'))


def get(d, path):
    for x in path: d = d[x]
    return d


def put(d, path, v):
    for x in path[:-1]: d = d[x]
    d[path[-1]] = v


def sentence(s, a, b):
    """The sentence around a span, with the use in brackets."""
    lo = max(s.rfind('. ', 0, a), s.rfind('。', 0, a), s.rfind('; ', 0, a), s.rfind('；', 0, a))
    hi = min([x for x in (s.find('. ', b), s.find('。', b), s.find('; ', b), s.find('；', b)) if x >= 0] or [len(s)])
    return (s[lo + 1:a] + '[[' + s[a:b] + ']]' + s[b:hi + 1]).strip()


def main():
    cmd = sys.argv[1]
    C, V, notes, bad = verdicts()
    if cmd == 'verdicts':
        for b in bad: print('BAD', b)
        print('tags', len(C), 'verdicts', len(V))
        by = collections.Counter((C[i]['file'], C[i]['lang'], V[i]) for i in V)
        for f in ('sheet', 'passages', 'paths', 'laid', 'web', 'cards', 'cases'):
            for lang in ('en', 'zh'):
                row = {c: by[(f, lang, c)] for c in 'AGBCDENTWU' if by[(f, lang, c)]}
                if row: print(' ', f, lang, row)
        print('all', dict(collections.Counter(V.values()).most_common()))
        json.dump({str(i): [V[i], notes[i]] for i in sorted(V)}, open(RUN + '/v1.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
        return
    F, D = final(V)
    root = '/Users/ren/tmp/rw/wm/orig' if cmd in ('sheet',) else (sys.argv[2] if len(sys.argv) > 2 and cmd == 'write' else '/Users/ren/tmp/rw/wm/orig')
    data = {}
    if cmd == 'sheet':
        want = set(sys.argv[2])
        for i in sorted(C):
            if V.get(i) in want and (len(sys.argv) < 4 or C[i]['file'] in sys.argv[3].split(',')):
                c = C[i]
                d = data.setdefault(c['file'], load(root, c['file']))
                s = get(d, c['path'])
                print('%d %s%s %s | %s | %s' % (i, V[i], ('→' + D[i]) if i in D else '', notes.get(i, ''), c['piece'], sentence(s, c['start'], c['end'])[:420]))
        return
    if cmd == 'write':
        assert not bad, bad[:5]
        by_field = collections.defaultdict(list)
        for i, c in C.items():
            if F[i] == 'A': by_field[(c['file'], tuple(c['path']))].append(c)
        n = 0
        for (f, path), cs in by_field.items():
            d = data.setdefault(f, load(root, f))
            s = get(d, list(path))
            for c in sorted(cs, key=lambda c: -c['start']):
                assert s[c['start']:c['end']] == c['word'], (f, path, c)
                s = s[:c['start']] + SWAP[c['word']] + s[c['end']:]; n += 1
            put(d, list(path), s)
        rw = json.load(open(KIT + '/rewrites.json', encoding='utf-8')) if os.path.exists(KIT + '/rewrites.json') else []
        for r in rw:
            d = data.setdefault(r['file'], load(root, r['file']))
            s = get(d, r['path'])
            assert s.count(r['old']) == 1, (r['file'], r['path'], r['old'][:60], s.count(r['old']))
            put(d, r['path'], s.replace(r['old'], r['new']))
        for f, d in data.items():
            open(os.path.join(root, 'theories/becoming/results/map', f + '.json'), 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=1) + TAIL[f])
        print('swapped', n, 'uses in', len(by_field), 'fields;', len(rw), 'rewrites; files', sorted(data))
        return
    if cmd == 'review':
        # every field with a change, old text with the changed uses shown as theorem⟦id⟧; kept uses left as they are
        fields = collections.OrderedDict()
        for i in sorted(C):
            c = C[i]
            fields.setdefault((c['file'], tuple(c['path'])), []).append(i)
        sheets, cur, cur_n, k = [], [], 0, 0
        for (f, path), ids in fields.items():
            ch = [i for i in ids if F[i] == 'A']
            if not ch: continue
            d = data.setdefault(f, load('/Users/ren/tmp/rw/wm/orig', f))
            s = get(d, list(path))
            for i in sorted(ch, key=lambda i: -C[i]['start']):
                c = C[i]
                s = s[:c['start']] + SWAP[c['word']] + '⟦%d⟧' % i + s[c['end']:]
            if cur and (cur_n + len(ch) > 60 or cur[0][0] != f and cur_n > 30):
                sheets.append(cur); cur, cur_n = [], 0
            cur.append((f, path, s, C[ch[0]]['piece'])); cur_n += len(ch)
        if cur: sheets.append(cur)
        out = []
        for n, sh in enumerate(sheets, 1):
            name = 'R%02d' % n
            lines = ['# Sheet %s' % name, '']
            for f, path, s, piece in sh:
                lines += ['=== %s %s (piece %s)' % (f, '.'.join(str(x) for x in path), piece), s, '']
            open('%s/%s.review.md' % (RUN, name), 'w', encoding='utf-8').write('\n'.join(lines))
            out.append({'name': name, 'fields': len(sh), 'tags': sum(x[2].count('⟦') for x in sh), 'files': sorted({x[0] for x in sh}),
                        'pieces': sorted({x[3] for x in sh})})
        json.dump(out, open(RUN + '/review-units.json', 'w', encoding='utf-8'), indent=1)
        for o in out: print(o)


if __name__ == '__main__':
    main()
