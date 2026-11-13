from wu import *
from collections import Counter
rng = random.Random(3)
G = givings(rng)
for fam in ['tent', 'min', 'rand']:
    GG = [t for t in G if t[0].startswith(fam)]
    cnt = Counter(); tot = 0
    for it in range(20000):
        name, g = rng.choice(GG); hi = rng.randint(6, 24)
        w = [(rng.randint(1, 12), rng.randint(0, 6)) for _ in range(rng.randint(1, 4))]
        x = rng.randint(0, hi); y = root_y(g, hi)
        lhs, st = unending(g, (w, x))
        if not lhs: continue
        tot += 1
        idx = reach_idx(st)
        fl = tuple(n for n, p in zip('SMK', [(1,0,0),(0,1,0),(0,0,1)]) if not all(Regime(g, y, hi, st[k][0], p) for k in idx))
        cnt[fl] += 1
    print(fam, tot, cnt.most_common())
# tent with hi>=c only
GG = [t for t in G if t[0].startswith('tent')]
cnt = Counter(); tot = 0
for it in range(20000):
    name, g = rng.choice(GG); c = int(name[4:]); hi = rng.randint(c, 26)
    w = [(rng.randint(1, 12), rng.randint(0, 6)) for _ in range(rng.randint(1, 4))]
    x = rng.randint(0, hi); y = root_y(g, hi)
    lhs, st = unending(g, (w, x))
    if not lhs: continue
    tot += 1; idx = reach_idx(st)
    fl = tuple(n for n, p in zip('SMK', [(1,0,0),(0,1,0),(0,0,1)]) if not all(Regime(g, y, hi, st[k][0], p) for k in idx))
    cnt[fl] += 1
print('tent hi>=c', tot, cnt.most_common())
