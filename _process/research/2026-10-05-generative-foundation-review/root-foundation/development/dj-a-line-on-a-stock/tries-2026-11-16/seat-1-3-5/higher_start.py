"""AI-written (Fable, seat 1-3-5, round 11), 16 November 2026. A search, not a proof.
LineOnAStock.HigherStartEnds re-run in Python: need A=1,B=3,C=12; use A=3,B=1,C=1;
kids A->[B,B], B->[C,B], C->[A]; giving z = min(z, 12-z) (Nat subtraction).
step (w,x) = (after w x, (x-T) + giving(x-T)) with T = total use of every unit present.
The net goes on while some unit's need is met (Goes)."""
from collections import Counter
need = {'A': 1, 'B': 3, 'C': 12}
use = {'A': 3, 'B': 1, 'C': 1}
kids = {'A': 'BB', 'B': 'CB', 'C': 'A'}
def giving(z): return min(z, max(0, 12 - z))
def step(w, x):
    w2 = Counter()
    for u, n in w.items():
        if need[u] <= x:
            for k in kids[u]: w2[k] += n
    T = sum(use[u] * n for u, n in w.items())
    z = max(0, x - T)
    return w2, z + giving(z)
def goes(w, x): return any(n > 0 and need[u] <= x for u, n in w.items())
def key(w, x): return (tuple(sorted((u, n) for u, n in w.items() if n)), x)
def fate(w, x, cap=200):
    seen = set(); w = Counter(w)
    for t in range(cap):
        if not goes(w, x): return ('ends', t)
        k = key(w, x)
        if k in seen: return ('never', t)
        seen.add(k); w, x = step(w, x)
    return ('cap', cap)
def orbit(w, x, n):
    out = []; w = Counter(w)
    for _ in range(n):
        out.append(key(w, x)); w, x = step(w, x)
    return out
print('orbit from ([A],6):', orbit('A', 6, 4))
print('orbit from ([A],7):', orbit('A', 7, 6))
ways = ['A', 'BB', 'CBCB']
print('\nfate by start level (ways on the orbit from six):')
for w in ways:
    print(' ', w.ljust(5), ' '.join(f"{x}:{'N' if fate(w, x)[0]=='never' else 'e'}" for x in range(0, 13)))
# the smallest product (class of ways) x (set of levels) holding ([A],6) and closed under the step
K = {key(Counter('A'), 0)[0]}; B = {6}
changed = True; ended = None
while changed and ended is None:
    changed = False
    for kw in list(K):
        for x in list(B):
            w = Counter(dict(kw))
            if not goes(w, x): ended = (kw, x); break
            w2, x2 = step(w, x); k2 = key(w2, x2)[0]
            if k2 not in K: K.add(k2); changed = True
            if x2 not in B: B.add(x2); changed = True
            if len(K) > 200: ended = ('grows past 200 ways', x); break
        if ended: break
print('\nsmallest closed product holding ([A],6): ways', len(K), 'levels', sorted(B))
print('  a member with no need met, or growth:', ended)
print('  fate of ([A],8):', fate('A', 8), ' of ([B,B],8):', fate('BB', 8), ' of ([C,B,C,B],6):', fate('CBCB', 6))
# all never-ending starts among ways with at most 4 units, levels 0..12; is the set of levels an up-set?
from itertools import combinations_with_replacement as cwr
rows = []
for n in range(1, 5):
    for combo in cwr('ABC', n):
        w = ''.join(combo)
        nev = [x for x in range(13) if fate(w, x)[0] == 'never']
        rows.append((w, nev))
nonup = [(w, nev) for w, nev in rows if nev and nev != list(range(nev[0], 13))]
print('\nways of 1..4 units:', len(rows), '; with some never-ending level:', sum(1 for _, n in rows if n),
      '; whose never-ending levels are not an up-set in 0..12:', len(nonup))
for w, nev in nonup[:12]: print('   ', w, nev)
