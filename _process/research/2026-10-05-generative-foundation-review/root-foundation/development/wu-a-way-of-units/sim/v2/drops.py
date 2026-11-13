from gen import *
from collections import defaultdict
import sys
rng = random.Random(int(sys.argv[1])); ITER = int(sys.argv[2])
memo = {}
def U(g, w, x):
    return unending(g, (w, x))[0]
def rg():
    r = rng.random()
    if r < .4: return hump(rng)
    hi = rng.randint(3, 12)
    t = [0 if rng.random() < .8 else rng.randint(1, 3)] + [rng.randint(0, 8) for _ in range(N)]
    for z in range(hi + 2, N + 1):
        if rng.random() < .5: t[z] = 0
    return mk(t), hi
single3 = defaultdict(list); single4 = defaultdict(list); single5 = defaultdict(list); single2 = defaultdict(list)
def p2(g, m, h, n, H2, y1, y2, hi, x): return W2prem(g, m, h, n, H2, y1, y2, hi, x)
for it in range(ITER):
    g, hi = rg()
    h = rng.randint(0, 6); H2 = rng.randint(0, 6); n = rng.randint(0, 8); m = rng.randint(0, 12); x = rng.randint(0, hi + 3)
    a = U(g, [(m, h), (n, H2)], x)
    ys = range(0, hi + 2)
    # W2 drops: enumerate y1,y2
    for y2 in ys:
        rhs = rhs2(g, m, h, n, H2, y2, x)
        if rhs == a: continue
        for y1 in ys:
            p = p2(g, m, h, n, H2, y1, y2, hi, x)
            bad = [k for k in p if not p[k]]
            if len(bad) == 1 and len(single2[bad[0]]) < 2:
                single2[bad[0]].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, h=h, n=n, H2=H2, y1=y1, y2=y2, x=x, lhs=a, rhs=rhs))
    if a:
        # W3
        m2 = rng.randint(m, m + 8)
        if not U(g, [(m2, h), (n, H2)], x):
            for y2 in ys:
                for y1 in ys:
                    p = p2(g, m, h, n, H2, y1, y2, hi, x)
                    bad = [k for k in p if not p[k]]
                    if len(bad) == 1 and len(single3[bad[0]]) < 2:
                        single3[bad[0]].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, m2=m2, h=h, n=n, H2=H2, y1=y1, y2=y2, x=x)); break
        # W4
        S = h + H2; h2 = rng.randint(h, S); H22 = S - h2
        if not U(g, [(m, h2), (n, H22)], x):
            done = False
            for y2 in ys:
                for y22 in ys:
                    for y1 in ys:
                        p = p2(g, m, h, n, H2, y1, y2, hi, x)
                        p.update(short_=Short(g, H22, y22), meets_=Meets(g, H22, y22, hi), keeps_=Keeps(g, H22, hi), within_=n <= H22 + y22)
                        bad = [k for k in p if not p[k]]
                        if len(bad) == 1 and len(single4[bad[0]]) < 2 and not done:
                            single4[bad[0]].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, h=h, H2=H2, h2=h2, H22=H22, n=n, y1=y1, y2=y2, y22=y22, x=x)); done = True
    # W5
    if U(g, [(m, 0), (n, H2)], x):
        done = False
        for y2 in ys:
            for y1 in ys:
                p = p2(g, m, 0, n, H2, y1, y2, hi, x)
                bad = [k for k in p if not p[k]]
                if len(bad) == 1 and len(single5[bad[0]]) < 2 and not done:
                    single5[bad[0]].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, n=n, H2=H2, y1=y1, y2=y2, x=x)); done = True
for nm, d in [('W2', single2), ('W3', single3), ('W4', single4), ('W5', single5)]:
    print(nm, 'single-premise counterexamples for:', sorted(d))
    for k in sorted(d): print('   ', k, d[k][0])
