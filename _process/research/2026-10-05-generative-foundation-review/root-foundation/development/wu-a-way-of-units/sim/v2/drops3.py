from gen import *
from collections import defaultdict, Counter
import sys
rng = random.Random(int(sys.argv[1])); ITER = int(sys.argv[2])
def U(g, w, x): return unending(g, (w, x))[0]
def rg():
    if rng.random() < .4: return hump(rng)
    hi = rng.randint(3, 12)
    t = [0 if rng.random() < .85 else rng.randint(1, 3)] + [rng.randint(0, 9) for _ in range(N)]
    for z in range(hi + 2, N + 1):
        if rng.random() < .6: t[z] = 0
    return mk(t), hi
s3 = defaultdict(list); s4 = defaultdict(list); s5 = defaultdict(list)
viol3 = viol4 = viol5 = 0
for it in range(ITER):
    g, hi = rg()
    h = rng.randint(0, 6); H2 = rng.randint(0, 6); n = rng.randint(0, 9); x = rng.randint(0, hi + 3)
    ys = range(0, hi + 3)
    flags = [U(g, [(m, h), (n, H2)], x) for m in range(0, hi + 5)]
    for m in range(len(flags)):
        for m2 in range(m + 1, len(flags)):
            if flags[m] and not flags[m2]:
                viol3 += 1
                found = set()
                for y2 in ys:
                    for y1 in ys:
                        p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
                        bad = tuple(k for k in p if not p[k])
                        if len(bad) == 1 and bad not in found:
                            found.add(bad)
                            if len(s3[bad[0]]) < 2: s3[bad[0]].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, m2=m2, h=h, n=n, H2=H2, y1=y1, y2=y2, x=x))
    # W4: same m, vary split of S
    m = rng.randint(n, max(n, hi + 4)); S = h + H2
    fl = {hh: U(g, [(m, hh), (n, S - hh)], x) for hh in range(S + 1)}
    for hA in range(S + 1):
        for hB in range(hA + 1, S + 1):
            if fl[hA] and not fl[hB]:
                viol4 += 1
                found = set()
                for y2 in ys:
                    for y22 in ys:
                        for y1 in ys:
                            p = W2prem(g, m, hA, n, S - hA, y1, y2, hi, x)
                            H22 = S - hB
                            p.update(short_=Short(g, H22, y22), meets_=Meets(g, H22, y22, hi), keeps_=Keeps(g, H22, hi), within_=n <= H22 + y22)
                            bad = tuple(k for k in p if not p[k])
                            if len(bad) == 1 and bad not in found:
                                found.add(bad)
                                if len(s4[bad[0]]) < 2: s4[bad[0]].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, h=hA, H2=S - hA, h2=hB, H22=H22, n=n, y1=y1, y2=y2, y22=y22, x=x))
    # W5
    for m in range(n, hi + 4):
        if U(g, [(m, 0), (n, H2)], x):
            viol5 += 1; found = set()
            for y2 in ys:
                for y1 in ys:
                    p = W2prem(g, m, 0, n, H2, y1, y2, hi, x)
                    bad = tuple(k for k in p if not p[k])
                    if len(bad) == 1 and bad not in found:
                        found.add(bad)
                        if len(s5[bad[0]]) < 2: s5[bad[0]].append(dict(tab=g.tab[:hi + 3], hi=hi, m=m, n=n, H2=H2, y1=y1, y2=y2, x=x))
print('conclusion-violating pairs: W3', viol3, 'W4', viol4, 'W5', viol5)
for nm, d in [('W3', s3), ('W4', s4), ('W5', s5)]:
    print(nm, 'single-premise counterexamples for:', sorted(d))
    for k in sorted(d): print('   ', k, d[k][0])
