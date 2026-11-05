"""Exact Markov chains of pair runs under i.i.d. one-way errors (chance e per formation per step),
optionally with forgiveness by chance q (withholding turned into giving before errors).
State: each formation's last H steps. Design checks only."""
from fractions import Fraction as F
from itertools import product

def chain(lawf, lawg, H, e, q=F(0)):
    states = list(product(product((True, False), repeat=H), repeat=2))
    idx = {s: i for i, s in enumerate(states)}
    T = {}
    for s in states:
        h1, h2 = s
        out = {}
        i1 = lawf(h1, h2); i2 = lawg(h2, h1)
        # intended giving: law or forgiveness
        p1 = F(1) if i1 else q
        p2 = F(1) if i2 else q
        g1 = p1 * (1 - e); g2 = p2 * (1 - e)
        for a, pa in ((True, g1), (False, 1 - g1)):
            for b, pb in ((True, g2), (False, 1 - g2)):
                if pa * pb == 0: continue
                ns = ((a,) + h1[:-1], (b,) + h2[:-1])
                out[ns] = out.get(ns, 0) + pa * pb
        T[s] = out
    return states, T

def step_dist(dist, T):
    nd = {}
    for s, p in dist.items():
        for ns, r in T[s].items():
            nd[ns] = nd.get(ns, 0) + p * r
    return nd

def horizon(lawf, lawg, H, e, n, q=F(0)):
    states, T = chain(lawf, lawg, H, e, q)
    start = (tuple([True]*H), tuple([True]*H))
    dist = {start: F(1)}
    give1 = F(0); give2 = F(0); dead = []
    for t in range(n):
        dist = step_dist(dist, T)
        give1 += sum(p for s, p in dist.items() if s[0][0])
        give2 += sum(p for s, p in dist.items() if s[1][0])
        dead.append(sum(p for s, p in dist.items() if not any(s[0]) and not any(s[1])))
    return give1, give2, dead

W = lambda w: (lambda o, p: any(p[:w]))
agree = lambda o, p: o[0] == p[0]
spare = lambda o, p: True
if __name__ == '__main__':
    e = F(1, 20)
    for name, law, H in (('answering', W(1), 1), ('window2', W(2), 2), ('window3', W(3), 3), ('agreement', agree, 1), ('sparing', spare, 1)):
        for n in (20, 200, 2000):
            g1, g2, dead = horizon(law, law, H, e, n)
            print(f'{name:10s} n={n:5d} giving share {float((g1+g2)/(2*n)):.4f}  P(total withholding at n) {float(dead[-1]):.4f}')
    # GTFT: answering with forgiveness chance q
    for q in (F(1,10), F(1,3)):
        for n in (20, 200, 2000):
            g1, g2, dead = horizon(W(1), W(1), 1, e, n, q)
            print(f'GTFT q={q} n={n:5d} giving share {float((g1+g2)/(2*n)):.4f}  P(total withholding at n) {float(dead[-1]):.4f}')
