from wu import *
rng = random.Random(1)
G = givings(rng, allow_nonzero0=True)
stats = dict(cases=0, prem=0, fail=0, along=0, along_sub=0, along_given_rest=0, rest=0, unend_prem=0)
drops = {k: dict(n=0, ce=[]) for k in ['needs', 'nothing', 'high', 'short', 'meets', 'keeps']}
fails = []
def yfuncs(g, hi):
    r = root_y(g, hi)
    out = [('root', r)]
    for d in (-1, 1, 2): out.append(('root%+d' % d, (lambda d: lambda H: max(0, r(H) + d))(d)))
    t = [rng.randint(0, hi + 1) for _ in range(60)]
    out.append(('rand', lambda H: t[H]))
    return out
def sublists(w):
    s = set()
    for mask in range(1 << len(w)):
        s.add(tuple(w[i] for i in range(len(w)) if mask >> i & 1))
    return s
for it in range(60000):
    name, g = rng.choice(G); hi = rng.randint(4, 24)
    w = rand_way(rng); x = rng.randint(0, hi + 4)
    yn, y = rng.choice(yfuncs(g, hi))
    stats['cases'] += 1
    lhs, st = unending(g, (w, x))
    idx = reach_idx(st)
    rhs = any(Holds(y, st[k]) for k in idx)
    p = dict(needs=all(u[0] > 0 for u in w), nothing=FromNothing(g), high=x <= hi,
             short=all(Regime(g, y, hi, st[k][0], (1,0,0)) for k in idx),
             meets=all(Regime(g, y, hi, st[k][0], (0,1,0)) for k in idx),
             keeps=all(Regime(g, y, hi, st[k][0], (0,0,1)) for k in idx))
    rest = p['needs'] and p['nothing'] and p['high']
    along = p['short'] and p['meets'] and p['keeps']
    if rest:
        stats['rest'] += 1
        if along: stats['along_given_rest'] += 1
        sub = all(Regime(g, y, hi, S) for S in sublists(w))
        if sub: stats['along_sub'] += 1
    if all(p.values()):
        stats['prem'] += 1
        if lhs: stats['unend_prem'] += 1
        if lhs != rhs:
            stats['fail'] += 1; fails.append((name, hi, w, x, yn, lhs, rhs))
    for k in drops:
        if not p[k] and all(p[j] for j in p if j != k):
            drops[k]['n'] += 1
            if lhs != rhs and len(drops[k]['ce']) < 3:
                drops[k]['ce'].append((name, g.tab[:hi+2], hi, w, x, yn, [y(taken(st[j][0])) for j in idx][:3], 'lhs', lhs, 'rhs', rhs, st[:8]))
print(stats)
print('fails', fails[:5])
for k, v in drops.items():
    print('DROP', k, 'cases', v['n'], 'counterexamples', len(v['ce']))
    for c in v['ce'][:2]: print('   ', c)
