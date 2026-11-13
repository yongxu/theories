from gen import *
from collections import defaultdict
import sys
rng = random.Random(int(sys.argv[1])); ITER = int(sys.argv[2])
def U(g, w, x): return unending(g, (w, x))[0]
def rg():
    if rng.random() < .3: return hump(rng)
    hi = rng.randint(3, 12)
    t = [0 if rng.random() < .9 else rng.randint(1, 3)] + [rng.randint(0, 9) for _ in range(N)]
    for z in range(hi + 2, N + 1):
        if rng.random() < .6: t[z] = 0
    return mk(t), hi
s3 = defaultdict(list); s5 = defaultdict(list); s4 = defaultdict(list); v3 = v4 = v5 = 0
def best(g, m, h, n, H2, hi, x, extra=None):
    y1 = root_y(g, hi)(h + H2)
    res = set()
    for y2 in range(hi + 3):
        p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
        if extra: p.update(extra)
        bad = tuple(k for k in p if not p[k])
        if len(bad) == 1: res.add((bad[0], y1, y2))
    return res
for it in range(ITER):
    g, hi = rg()
    h = rng.randint(0, 6); H2 = rng.randint(0, 6); n = rng.randint(0, 9); x = rng.randint(0, hi + 3)
    flags = [U(g, [(m, h), (n, H2)], x) for m in range(0, hi + 5)]
    for m in range(len(flags)):
        if not flags[m]: continue
        for m2 in range(m + 1, len(flags)):
            if not flags[m2]:
                v3 += 1
                for (k, y1, y2) in best(g, m, h, n, H2, hi, x):
                    if len(s3[k]) < 2: s3[k].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, m2=m2, h=h, n=n, H2=H2, y1=y1, y2=y2, x=x))
    # W4 with same m: shift use to first; y22 = root(H22) best for short_/meets_/within_ ? enumerate small
    m = rng.randint(0, hi + 4); S = h + H2
    if U(g, [(m, h), (n, H2)], x):
        for h2 in range(h + 1, S + 1):
            H22 = S - h2
            if not U(g, [(m, h2), (n, H22)], x):
                v4 += 1
                for y22 in range(hi + 3):
                    ex = dict(short_=Short(g, H22, y22), meets_=Meets(g, H22, y22, hi), keeps_=Keeps(g, H22, hi), within_=n <= H22 + y22)
                    for (k, y1, y2) in best(g, m, h, n, H2, hi, x, ex):
                        if len(s4[k]) < 2: s4[k].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, h=h, H2=H2, h2=h2, H22=H22, n=n, y1=y1, y2=y2, y22=y22, x=x))
    for m in range(0, hi + 5):
        if U(g, [(m, 0), (n, H2)], x):
            v5 += 1
            for (k, y1, y2) in best(g, m, 0, n, H2, hi, x):
                if len(s5[k]) < 2: s5[k].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, n=n, H2=H2, y1=y1, y2=y2, x=x))
print('violations W3', v3, 'W4', v4, 'W5', v5)
for nm, d in [('W3', s3), ('W4', s4), ('W5', s5)]:
    print(nm, 'single-premise CE for:', sorted(d))
    for k in sorted(d): print('   ', k, d[k][0])
