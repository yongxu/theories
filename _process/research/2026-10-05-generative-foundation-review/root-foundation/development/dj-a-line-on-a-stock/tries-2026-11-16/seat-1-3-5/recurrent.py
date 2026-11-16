"""AI-written (Fable, seat 1-3-5, round 11), 16 November 2026. A search, not a proof.
Same worked case as higher_start.py. For every way of 1..6 units and level 0..12: the fate; the
configurations a never-ending course settles on; whether every need is met there."""
from itertools import combinations_with_replacement as cwr
from higher_start import Counter, need, step, goes, key, fate
rec = set(); starts = 0; total = 0; per_way = {}
for n in range(1, 7):
    for combo in cwr('ABC', n):
        w0 = ''.join(combo)
        for x0 in range(13):
            total += 1
            if fate(w0, x0)[0] != 'never': continue
            starts += 1; per_way.setdefault(w0, []).append(x0)
            w, x = Counter(w0), x0; seen = []
            while key(w, x) not in seen:
                seen.append(key(w, x)); w, x = step(w, x)
            i = seen.index(key(w, x)); rec.update(seen[i:])
print('starts searched:', total, '; never-ending:', starts)
print('ways with more than one never-ending level:', {w: v for w, v in per_way.items() if len(v) > 1})
print('configurations the never-ending courses settle on:', len(rec))
for kw, x in sorted(rec, key=lambda r: r[1]):
    unmet = [u for u, n in kw if need[u] > x]
    w2, x2 = step(Counter(dict(kw)), x)
    print('  ', kw, 'level', x, '| fixed:', key(w2, x2) == (kw, x), '| unmet kinds there:', unmet)
