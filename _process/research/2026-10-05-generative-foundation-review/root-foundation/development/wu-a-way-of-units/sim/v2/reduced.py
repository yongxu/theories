from gen import *
import sys
rng = random.Random(int(sys.argv[1])); ITER = int(sys.argv[2])
def U(g, w, x): return unending(g, (w, x))[0]
def rg():
    r = rng.random()
    if r < .6:
        g, hi = hump(rng); t = list(g.tab)
        for _ in range(rng.randint(0, 3)):
            i = rng.randint(1, hi + 2); t[i] = rng.randint(0, 12)
        return mk(t), hi
    hi = rng.randint(3, 12)
    return mk([0] + [rng.randint(0, 9) for _ in range(N)]), hi
c = dict(w3a=0, w3a_bad=0, w3b=0, w3b_bad=0, w3c=0, w3c_bad=0, w4a=0, w4a_bad=0, w4a_strict=0, w4b=0, w4b_bad=0, w5=0, w5_bad=0)
ex = {}
for it in range(ITER):
    g, hi = rg()
    h = rng.randint(0, 6); H2 = rng.randint(0, 6); n = rng.randint(1, 9); m = rng.randint(n, n + 8); x = rng.randint(0, hi)
    R = root_y(g, hi)
    y2 = R(H2); y1 = R(h + H2)
    base = FromNothing(g) and n <= m and x <= hi
    if not base: continue
    a = U(g, [(m, h), (n, H2)], x)
    S2 = Short(g, H2, y2) and Meets(g, H2, y2, hi) and Keeps(g, H2, hi)
    belowok = x < h + H2 + y1  # y1 = root: Short1 holds
    # W3 reduced A: no below/short1 (within kept)
    m2 = rng.randint(m, m + 8)
    if a and S2 and n <= H2 + y2:
        b = U(g, [(m2, h), (n, H2)], x)
        c['w3a'] += 1
        if not b: c['w3a_bad'] += 1; ex.setdefault('w3a', (g.tab[:hi+2], hi, m, m2, h, n, H2, y2, x))
    # W3 reduced B: no within (below kept)
    if a and S2 and belowok:
        b = U(g, [(m2, h), (n, H2)], x)
        c['w3b'] += 1
        if not b: c['w3b_bad'] += 1; ex.setdefault('w3b', (g.tab[:hi+2], hi, m, m2, h, n, H2, y2, x))
    # W3 joint drop of below and within
    if a and S2:
        b = U(g, [(m2, h), (n, H2)], x)
        c['w3c'] += 1
        if not b: c['w3c_bad'] += 1; ex.setdefault('w3c', (g.tab[:hi+2], hi, m, m2, h, n, H2, y2, x))
    # W4 reduced: only Short'/Meets'/Keeps' at H2', sum, more, high, and (below) or (Keeps at H2)
    S = h + H2; h2 = rng.randint(h, S); H22 = S - h2; y22 = R(H22)
    S2p = Short(g, H22, y22) and Meets(g, H22, y22, hi) and Keeps(g, H22, hi)
    if a and S2p:
        b = U(g, [(m, h2), (n, H22)], x)
        if belowok:
            c['w4a'] += 1; c['w4a_strict'] += (h2 > h and not S2)
            if not b: c['w4a_bad'] += 1; ex.setdefault('w4a', (g.tab[:hi+2], hi, m, h, H2, h2, H22, n, x))
        if Keeps(g, H2, hi):
            c['w4b'] += 1
            if not b: c['w4b_bad'] += 1; ex.setdefault('w4b', (g.tab[:hi+2], hi, m, h, H2, h2, H22, n, x))
    # W5 reduced: only nothing, short1 at H2 (y1 = root), below, n>0, m>0
    y1b = R(H2)
    if x < H2 + y1b:
        c['w5'] += 1
        if U(g, [(m, 0), (n, H2)], x): c['w5_bad'] += 1
print(c); print(ex)
