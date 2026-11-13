import random, itertools
def step(g, H, x):
    z = max(0, x - H)
    return z + (g[z] if z < len(g) else 0)
def unending(g, w, x, cap=400):
    seen = set()
    for _ in range(cap):
        if not any(n <= x for n, _ in w): return False
        key = (tuple(w), x)
        if key in seen: return True
        seen.add(key)
        H = sum(u for _, u in w)
        w, x = [p for p in w if p[0] <= x], step(g, H, x)
    raise RuntimeError('cap')
def ys(g, H, hi):
    """all y with Short g H y and Meets g H y hi"""
    out = []
    for y in range(0, hi + 2):
        short = all(g[z] < H for z in range(y))
        meets = all(H <= g[z] for z in range(y, hi + 1) if z + H <= hi)
        if short and meets: out.append(y)
    return out
def keeps(g, H, hi): return all(step(g, H, x) <= hi for x in range(hi + 1))
random.seed(7)
t7 = t8 = t6 = 0; bad7 = bad8 = bad6 = 0
for trial in range(60000):
    hi = random.randint(4, 14)
    g = [0] + [random.randint(0, 7) for _ in range(hi + 8)]
    H1 = random.randint(1, 7)
    h = random.randint(0, H1 - 1); h2 = random.randint(h, H1 - 1)   # h <= h2 < H1, so H2' <= H2, both >= 1
    H2, H2p = H1 - h, H1 - h2
    n = random.randint(1, 5); m = random.randint(n, 12); mp = random.randint(m, 14)
    x = random.randint(0, hi)
    y1s = [y for y in range(hi + 2) if all(g[z] < H1 for z in range(y))]
    if not y1s: continue
    y1 = max(y1s)
    if not x < H1 + y1: continue
    A, B = ys(g, H2, hi), ys(g, H2p, hi)
    if not A or not B or not keeps(g, H2, hi) or not keeps(g, H2p, hi): continue
    for y2 in A:
        for y2p in B:
            if n <= H2 + y2 and n <= H2p + y2p:
                a = unending(g, [(m, h), (n, H2)], x); b = unending(g, [(m, h2), (n, H2p)], x)
                t7 += 1
                if a and not b: bad7 += 1; print('T7 fails', g, m, n, h, h2, H1, x, hi, y2, y2p)
    for y2 in A:
        if n <= H2 + y2:
            a = unending(g, [(m, h), (n, H2)], x); c = unending(g, [(mp, h), (n, H2)], x)
            t6 += 1
            if a and not c: bad6 += 1; print('T6 fails', g, m, mp, n, h, H2, x)
            if h == 0:
                t8 += 1
                if a: bad8 += 1; print('T8 fails', g, m, n, H2, x, hi, y2, y1)
print('T6', t6, bad6, 'T7', t7, bad7, 'T8', t8, bad8)
g = [min(z, 12 - z) if z <= 12 else 0 for z in range(30)]
for w in ([(9, 4), (1, 1)], [(9, 1), (1, 4)], [(9, 2), (1, 3)], [(8, 2), (1, 3)]):
    xs, ww, x = [], list(w), 9
    for _ in range(9):
        xs.append((len(ww), x))
        if not any(nn <= x for nn, _ in ww): break
        H = sum(u for _, u in ww); ww, x = [p for p in ww if p[0] <= x], step(g, H, x)
    print(w, unending(g, w, 9), xs)
for H in (1, 3, 4, 5): print('H', H, 'y', ys(g, H, 12), 'keeps', keeps(g, H, 12))
