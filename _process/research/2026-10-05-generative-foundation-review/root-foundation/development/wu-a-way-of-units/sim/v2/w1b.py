from wu import *
rng = random.Random(2)
G = givings(rng)
def sublists(w):
    return {tuple(w[i] for i in range(len(w)) if m >> i & 1) for m in range(1 << len(w))}
def reach_strict(st):
    out = []
    for k, s in enumerate(st):
        if not Goes(s): break
        out.append(k)
    return out
for fam in ['tent', 'min', 'concave', 'rand']:
    c = dict(n=0, along=0, along_strict=0, sub=0, sub_nonempty=0, unend=0, unend_along=0, fail_strict=0, prem_strict=0, nontriv=0, nontriv_along=0)
    GG = [t for t in G if t[0].startswith(fam)]
    for it in range(20000):
        name, g = rng.choice(GG); hi = rng.randint(6, 24)
        w = [(rng.randint(1, 12), rng.randint(0, 6)) for _ in range(rng.randint(1, 4))]
        x = rng.randint(0, hi); y = root_y(g, hi)
        lhs, st = unending(g, (w, x)); idx = reach_idx(st); idx2 = reach_strict(st)
        al = all(Regime(g, y, hi, st[k][0]) for k in idx)
        al2 = all(Regime(g, y, hi, st[k][0]) for k in idx2)
        sub = all(Regime(g, y, hi, S) for S in sublists(w))
        subne = all(Regime(g, y, hi, S) for S in sublists(w) if S)
        rhs = any(Holds(y, st[k]) for k in idx)
        c['n'] += 1; c['along'] += al; c['along_strict'] += al2; c['sub'] += sub; c['sub_nonempty'] += subne
        c['unend'] += lhs; c['unend_along'] += lhs and al
        nontriv = Goes((w, x))
        c['nontriv'] += nontriv; c['nontriv_along'] += nontriv and al
        if al2:
            c['prem_strict'] += 1
            if lhs != rhs: c['fail_strict'] += 1
    print(fam, c)
