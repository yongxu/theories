from w2 import *
g = mk([max(0, min(z, 12 - z)) for z in range(N + 1)])
for nm, w in [('With', [(9, 4), (1, 1)]), ('Against', [(9, 1), (1, 4)])]:
    s = (tuple(w), 9); out = []
    for i in range(8): out.append((s, Goes(s))); s = pair(g, s)
    print(nm, out); print('  unending', unending(g, (w, 9))[0])
    X = orbitX(g, 5, 9, 5); print('  course as it was under 5:', X)
# premises of With: m=9,h=4,n=1,H2=1,y1=5,y2=1,hi=12
for (h, H2, y2) in [(4, 1, 1), (1, 4, 4)]:
    print('h,H2', h, H2, W2prem(g, 9, h, 1, H2, 5, y2, 12, 9), 'rhs', rhs2(g, 9, h, 1, H2, y2, 9), 'root y2', root_y(g, 12)(H2), 'root y1', root_y(g, 12)(5))
# ends_while_net_goes: random check
import random
rng = random.Random(3); bad = 0
for it in range(100000):
    w = rand_way(rng); x = rng.randint(0, 12)
    ps = [u for u in w if x < u[0]]; qs = [u for u in w if u[0] <= x]
    if ps and qs:
        nxt = pair(g, (w, x))
        if list(nxt[0]) == list(w) or not Goes((w, x)): bad += 1
print('ends_while_net_goes violations', bad)
# W5 / W1 on the witnesses: W1 for With? check along with y = root
y = root_y(g, 12)
for w in [[(9, 4), (1, 1)], [(9, 1), (1, 4)]]:
    lhs, st = unending(g, (w, 9)); idx = reach_idx(st)
    print(w, 'W1 along', all(Regime(g, y, 12, st[k][0]) for k in idx), 'lhs', lhs, 'rhs', any(Holds(y, st[k]) for k in idx))
