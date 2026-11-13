from w2 import *
rng = random.Random(9)
for it in range(400000):
    hi = rng.randint(3, 8)
    tab = [0] + [rng.randint(0, 6) for _ in range(14)]
    g = mk(tab)
    n = rng.randint(1, 4); m = rng.randint(n, 9); h = rng.randint(0, 4); H2 = rng.randint(1, 4)
    y2 = root_y(g, hi)(H2); y1 = rng.randint(0, root_y(g, hi)(h + H2))
    x = rng.randint(0, hi)
    p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
    if all(p.values()):
        H1 = h + H2
        if not any(Short(g, H1, yy) and Meets(g, H1, yy, hi) for yy in range(hi + 2)):
            lhs, st = unending(g, ([(m, h), (n, H2)], x))
            print(dict(tab=tab[:hi + 2], hi=hi, m=m, h=h, n=n, H2=H2, y1=y1, y2=y2, x=x, lhs=lhs, course=st[:6])); break
