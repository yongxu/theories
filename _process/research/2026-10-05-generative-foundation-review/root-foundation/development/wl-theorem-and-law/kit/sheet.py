#!/usr/bin/env python3
"""sheet <dir> <piece> [classes] [ver]: print each candidate with its verdict and a window of its line."""
import sys, json, re
def verdicts(d, piece, ver='v1'):
    v = {}
    for l in open(f'{d}/{piece}.{ver}.txt', encoding='utf-8').read().split('\n'):
        m = re.match(r'\s*(\d+)\s+([A-Z])\b\s*(.*)$', l)
        if m: v[int(m.group(1))] = (m.group(2), m.group(3).strip())
    return v
if __name__ == '__main__':
    d, piece = sys.argv[1], sys.argv[2]
    only = set(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[3] != '-' else None
    ver = sys.argv[4] if len(sys.argv) > 4 else 'v1'
    W = int(sys.argv[5]) if len(sys.argv) > 5 else 75
    L = open(f'{d}/{piece}.orig.md', encoding='utf-8').read().split('\n')
    cs = json.load(open(f'{d}/{piece}.cands.json'))
    v = verdicts(d, piece, ver)
    miss = [c['id'] for c in cs if c['id'] not in v]
    if miss: print('MISSING', miss)
    for c in cs:
        cl, note = v.get(c['id'], ('?', ''))
        if only and cl not in only: continue
        line = L[c['line'] - 1]
        a, b = max(0, c['start'] - W), min(len(line), c['end'] + W)
        print(f"{c['id']:>3} {cl} L{c['line']:<4}| …{line[a:c['start']]}⟪{c['word']}⟫{line[c['end']:b]}…" + (f"   [{note}]" if note else ''))
