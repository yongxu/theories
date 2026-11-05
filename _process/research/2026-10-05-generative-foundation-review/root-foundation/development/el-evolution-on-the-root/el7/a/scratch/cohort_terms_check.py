"""Design check: the record's cohort (x answerer pairs, y answerer-withholder pairs, z withholder
pairs, no errors, 1 + d steps). Mean law (PairSelection.answering_rises_iff) against the four
terms read on own withholding (EL7a.pairs_rises_iff_withheld_ge), evaluated by hand:
for beta = gamma + e, answering rises iff
  e * (x*y*(2d+1) + 4*x*z*(d+1) + y*z) > (x+y+z) * (beta+gamma) * y ;
for beta <= gamma it never rises. Also recomputes the four terms by brute force."""
import random
from itertools import product
random.seed(11)
def exc(u, v): return u - v if u > v else 0
def concord(ps, w, a): return sum(exc(w(p), w(q)) * exc(a(p), a(q)) for p in ps for q in ps)
def discord(ps, w, a): return sum(exc(w(p), w(q)) * exc(a(q), a(p)) for p in ps for q in ps)
bad = 0
for _ in range(4000):
    a, g = random.randint(0, 4), random.randint(0, 5); b = random.randint(0, 8)
    d = random.randint(0, 6); x, y, z = random.randint(0, 3), random.randint(0, 3), random.randint(0, 3)
    n = 1 + d
    # place = (K_own, K_partner, kind)
    AA = [(0, 0, 1), (0, 0, 1)]; AD = [(d, 1 + d, 1), (1 + d, d, 0)]; DD = [(n, n, 0), (n, n, 0)]
    gs = [AA] * x + [AD] * y + [DD] * z
    whole = [p for gp in gs for p in gp]
    off = lambda p: a + b * (n - p[1]) + g * p[0]
    kind = lambda p: p[2]
    rises = discord(whole, off, kind) < concord(whole, off, kind)
    mean = (x*2 + y) * (y*(a + b + g*(1+d)) + z*((a + g*(1+d)) + (a + g*(1+d)))) < (y + z*2) * (x*((a + b*(1+d)) + (a + b*(1+d))) + y*(a + g*d))
    if b > g:
        e = b - g
        closed = e * (x*y*(2*d+1) + 4*x*z*(d+1) + y*z) > (x+y+z) * (b+g) * y
    else:
        closed = False
    # brute-force four terms on own withholding
    K = lambda p: p[0]
    ctx = [gp for gp in gs for _ in gp]
    DW = sum(discord(gp, K, kind) for gp in gs); CW = sum(concord(gp, K, kind) for gp in gs)
    CM = concord(ctx, lambda gp: sum(K(p) for p in gp), lambda gp: sum(kind(p) for p in gp))
    DM = discord(ctx, lambda gp: sum(K(p) for p in gp), lambda gp: sum(kind(p) for p in gp))
    L = len(whole)
    if b >= g:
        e = b - g; four = 2*L*((b+g)*DW) + e*CM < 2*L*((b+g)*CW) + e*DM
    else:
        e = g - b; four = 2*L*((b+g)*DW) + e*DM < 2*L*((b+g)*CW) + e*CM
    if not (rises == mean == closed == four): bad += 1
print('mismatches', bad)
