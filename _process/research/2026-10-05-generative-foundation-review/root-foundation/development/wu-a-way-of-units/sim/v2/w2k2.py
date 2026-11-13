from w2 import *
import sys
rng = random.Random(int(sys.argv[1]))
found = 0; tried = 0
for it in range(300000):
    hi = rng.randint(4, 14); H2 = rng.randint(1, 6); h = rng.randint(1, 5)
    tab = [0] + [rng.choice([0, 1, 2, H2, H2 + 1, rng.randint(0, 16)]) for _ in range(24)]
    g = mk(tab)
    y2 = root_y(g, hi)(H2)
    if not (Meets(g, H2, y2, hi) and not Keeps(g, H2, hi)): continue
    n = rng.randint(1, max(1, H2 + y2)); m = rng.randint(n, hi + 2)
    r1 = root_y(g, hi)(h + H2)
    for y1 in range(0, r1 + 1):
        for x in range(0, min(hi, h + H2 + y1 - 1) + 1):
            p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
            if not all(p[k] for k in p if k != 'keeps'): continue
            tried += 1
            w = [(m, h), (n, H2)]
            lhs, st = unending(g, (w, x)); rhs = rhs2(g, m, h, n, H2, y2, x)
            if lhs != rhs and found < 2:
                found += 1
                print('CE', dict(tab=tab[:hi + 3], hi=hi, m=m, h=h, n=n, H2=H2, y1=y1, y2=y2, x=x, lhs=lhs, rhs=rhs, course=st[:10]))
print('tried', tried, 'found', found)
