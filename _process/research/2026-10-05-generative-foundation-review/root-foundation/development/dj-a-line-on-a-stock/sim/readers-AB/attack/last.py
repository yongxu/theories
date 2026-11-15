# AI-written (Fable, attack reader), 16 November 2026. Three small points.
from model import *

# 1. need_unmet: the bound hi + 1 is reached for every hi (U = Nat: unit j takes j and leaves [j + 1]; need 1;
#    giving refills to hi from 1 up and gives nothing at nothing).
for hi in range(1, 9):
    g = lambda z, hi=hi: 0 if z == 0 else max(hi - z, 0)
    assert g(0) == 0 and keeps(g, 0, hi)
    w, x, first = [0], hi, None
    for n in range(1, hi + 3):
        w, x = [u + 1 for u in w if 1 <= x], lvl_step(g, sum(w), x)   # grows: use u = u < u + 1
        if any(x < 1 for u in w):
            first = n
            break
    print('need_unmet, chain on Nat, hi =', hi, ': first step with an unmet need =', first, '(hi + 1 =', hi + 1, ')')

# 2. need_unmet: "No premise on the kids' needs" -- positivity is asked of every unit, kids included, and is used:
#    u (need 1, use 0) leaves z; z (need 0, use 1) leaves z, z. Every start unit needs something and is met.
m = M([1, 0], [0, 1], [(1,), (1, 1)], [0, 0, 0, 0, 0])
hi = 3
c = m.course((0,), 3, hi + 1)
print('kids needing nothing: FromNothing', m.g(0) == 0, 'Keeps', keeps(m.g, 0, hi), 'grows', [m.use[u] < m.taken(m.kids[u]) for u in (0, 1)],
      '; unmet unit at steps 1..hi+1:', [any(s[1] < m.need[u] for u in s[0]) for s in c[1:]])

# 3. one_need_ends against need_unmet in the same world: first step with no need met, exhaustively on a small family
import itertools
worst, cnt = -99, 0
for k in (1, 2):
    kidopts = [t for l in range(0, 4) for t in itertools.product(range(k), repeat=l)]
    for use in itertools.product(range(3), repeat=k):
        for kids in itertools.product(kidopts, repeat=k):
            if not all(use[u] < sum(use[v] for v in kids[u]) for u in range(k)):
                continue
            for hi in (1, 2, 3, 4):
                for gt in itertools.product(*[range(0, hi - z + 1) for z in range(1, hi + 1)]):
                    gt = (0,) + gt
                    for n in range(1, hi + 2):
                        m = M([n] * k, list(use), list(kids), list(gt))
                        for w in [t for l in range(1, 3) for t in itertools.product(range(k), repeat=l)]:
                            for x in range(hi + 1):
                                s, j = (w, x), 0
                                while m.goes(*s):
                                    s, j = m.step(*s), j + 1
                                    assert j <= 2 * hi + 1
                                assert s[0] == m.generation(j, w)
                                worst, cnt = max(worst, j - (hi + 1)), cnt + 1
print('one_need_ends as written, exhaustive [1-2 kinds, use 0..2, kids len<=3, hi 1..4, every giving with FromNothing and Keeps on 0..hi, need 1..hi+1, way len 1..2, level 0..hi]:',
      cnt, 'worlds, conclusion holds in all; largest (first step with no need met) - (hi + 1) =', worst)
