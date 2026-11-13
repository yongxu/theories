from w2 import *
def hump(rng):
    K = rng.randint(6, 24); a = rng.randint(1, 3); b = rng.randint(2, 12); c = rng.randint(1, 3)
    t = [max(0, min(a * z, b, c * (K - z))) for z in range(N + 1)]
    if rng.random() < .3:
        for _ in range(2):
            i = rng.randint(1, K); t[i] = max(0, t[i] + rng.randint(-2, 2))
    t[0] = 0
    hi = K if rng.random() < .7 else rng.randint(max(3, K - 3), K + 3)
    return mk(t), hi
def case(rng, g=None, hi=None):
    if g is None: g, hi = hump(rng)
    H2 = rng.randint(1, 8); h = rng.randint(0, 8)
    y2 = root_y(g, hi)(H2) if rng.random() < .8 else rng.randint(0, hi)
    r1 = root_y(g, hi)(h + H2); y1 = r1 if rng.random() < .7 else rng.randint(0, r1 + 1)
    n = rng.randint(1, 12); m = rng.randint(n, 20)
    x = rng.randint(0, hi + 2)
    return g, m, h, n, H2, y1, y2, hi, x
