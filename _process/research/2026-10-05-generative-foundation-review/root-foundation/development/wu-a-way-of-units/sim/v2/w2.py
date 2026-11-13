from wu import *
rng = random.Random(5)
G = givings(rng, allow_nonzero0=True)
def orbitX(g, H, x, T):
    xs = [x]
    for _ in range(T): xs.append(step(g, H, xs[-1]))
    return xs
def rhs2(g, m, h, n, H2, y2, x):
    X = orbitX(g, h + H2, x, 200)
    for T in range(199):
        if X[T] < m:   # T must be the first below m
            return n <= X[T] and H2 + y2 <= X[T + 1]
    return False
def W2prem(g, m, h, n, H2, y1, y2, hi, x):
    return dict(order=n <= m, nothing=FromNothing(g), short=Short(g, H2, y2), meets=Meets(g, H2, y2, hi),
                keeps=Keeps(g, H2, hi), needs=0 < n, within=n <= H2 + y2, short1=Short(g, h + H2, y1),
                below=x < h + H2 + y1, high=x <= hi)
def sample():
    name, g = rng.choice(G); hi = rng.randint(4, 24)
    n = rng.randint(0, 10); m = rng.randint(0, 14)
    if rng.random() < .7 and m < n: m, n = n, m
    h = rng.randint(0, 6); H2 = rng.randint(0, 6)
    r2 = root_y(g, hi)(H2); r1 = root_y(g, hi)(h + H2)
    y2 = r2 if rng.random() < .6 else rng.randint(0, hi + 1)
    y1 = r1 if rng.random() < .5 else rng.randint(0, r1 + 2)
    x = rng.randint(0, hi + 4)
    return name, g, m, h, n, H2, y1, y2, hi, x
if __name__ == '__main__':
    keys = ['order','nothing','short','meets','keeps','needs','within','short1','below','high']
    drops = {k: [0, []] for k in keys}
    prem = fail = unend = implies_along = 0
    for it in range(200000):
        name, g, m, h, n, H2, y1, y2, hi, x = sample()
        w = [(m, h), (n, H2)]
        lhs, st = unending(g, (w, x)); rhs = rhs2(g, m, h, n, H2, y2, x)
        p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
        if all(p.values()):
            prem += 1; unend += lhs
            if lhs != rhs: fail += 1; print('FAIL', name, m, h, n, H2, y1, y2, hi, x)
            # does W2's premise give W1's along, for some y with y(H2)=y2 ?
            idx = [k for k in reach_idx(st) if Goes(st[k])]
            Hs = {taken(st[k][0]) for k in idx}
            ok = True
            for H in Hs:
                cands = [y2] if H == H2 else range(0, hi + 2)
                if not any(Short(g, H, yy) and Meets(g, H, yy, hi) and Keeps(g, H, hi) for yy in cands): ok = False
            implies_along += ok
        for k in keys:
            if not p[k] and all(p[j] for j in keys if j != k):
                drops[k][0] += 1
                if lhs != rhs and len(drops[k][1]) < 2:
                    drops[k][1].append(dict(g=name, tab=g.tab[:hi + 2], m=m, h=h, n=n, H2=H2, y1=y1, y2=y2, hi=hi, x=x, lhs=lhs, rhs=rhs, levels=[s[1] for s in st[:7]], ways=[len(s[0]) for s in st[:7]]))
    print('premise cases', prem, 'failures', fail, 'unending', unend, 'W1 along also holds (some y)', implies_along)
    for k in keys:
        print('DROP', k, 'cases', drops[k][0], 'ce found', len(drops[k][1]))
        for c in drops[k][1][:1]: print('    ', c)
