from wu import *
rng = random.Random(4)
G = givings(rng)
for fam in ['tent', 'min', 'concave', 'rand']:
    GG = [t for t in G if t[0].startswith(fam)]
    tot = some = 0; tot_end = some_end = 0
    for it in range(6000):
        name, g = rng.choice(GG)
        w = [(rng.randint(1, 12), rng.randint(0, 6)) for _ in range(rng.randint(1, 4))]
        x = rng.randint(0, 20)
        lhs, st = unending(g, (w, x)); idx = reach_idx(st)
        ok = False
        for hi in range(x, 41):
            y = root_y(g, hi)
            if all(Regime(g, y, hi, st[k][0]) for k in idx if Goes(st[k])): ok = True; break
        if lhs: tot += 1; some += ok
        else: tot_end += 1; some_end += ok
    print(fam, 'unending: %d/%d have some hi' % (some, tot), ' ending: %d/%d' % (some_end, tot_end))
