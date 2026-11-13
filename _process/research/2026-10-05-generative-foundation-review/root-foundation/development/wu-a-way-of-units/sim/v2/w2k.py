from w2 import *
rng = random.Random(7)
found = 0; tried = 0; meetsH1 = 0; prem_all = 0
for it in range(400000):
    hi = rng.randint(3, 8)
    tab = [0] + [rng.randint(0, 6) for _ in range(14)]
    g = mk(tab)
    n = rng.randint(1, 4); m = rng.randint(n, 9); h = rng.randint(0, 4); H2 = rng.randint(1, 4)
    y2 = root_y(g, hi)(H2); y1 = rng.randint(0, root_y(g, hi)(h + H2))
    x = rng.randint(0, hi)
    p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
    ks = [k for k in p if k != 'keeps']
    if all(p[k] for k in ks):
        # W1 Meets at h+H2 for some y?
        if p['keeps']:
            prem_all += 1
            H1 = h + H2
            if any(Short(g, H1, yy) and Meets(g, H1, yy, hi) for yy in range(hi + 2)): meetsH1 += 1
            elif meetsH1 >= 0 and found < 100:
                pass
        else:
            tried += 1
            w = [(m, h), (n, H2)]
            lhs, st = unending(g, (w, x)); rhs = rhs2(g, m, h, n, H2, y2, x)
            if lhs != rhs and found < 2:
                found += 1
                print('KEEPS dropped CE', dict(tab=tab[:hi + 3], hi=hi, m=m, h=h, n=n, H2=H2, y1=y1, y2=y2, x=x, lhs=lhs, rhs=rhs, course=st[:8]))
print('keeps-dropped cases', tried, 'found', found)
print('W2 premises hold', prem_all, 'of which W1 Short+Meets at h+H2 for some y', meetsH1)
