"""Design check: the window kind in a cohort of x window pairs, y window-withholder pairs and
z withholder pairs, no errors, n >= 2 steps (counts from counts_windowed_withholding):
rises iff (beta - gamma) * n * x * (y + 2z) > y * (beta * (2x + y) + gamma * (y + 2z)).
Compared with the mean law (kind_rises_iff) and the withholding-count law
(EL7a.kind_rises_iff_withheld)."""
import random
from fractions import Fraction as F
random.seed(7)
bad = 0
for _ in range(20000):
    a, b, g = random.randint(0, 5), random.randint(0, 6), random.randint(0, 6)
    n = random.randint(2, 12); x, y, z = random.randint(0, 4), random.randint(0, 4), random.randint(0, 4)
    # places: (own K, partner K, kind)
    places = [(0, 0, 1)] * (2 * x) + [(n - 2, n, 1)] * y + [(n, n - 2, 0)] * y + [(n, n, 0)] * (2 * z)
    off = lambda K, P: a + b * (n - P) + g * K
    N1 = sum(k for _, _, k in places); N0 = len(places) - N1
    W1 = sum(off(K, P) for K, P, k in places if k); W0 = sum(off(K, P) for K, P, k in places if not k)
    mean = N1 * W0 < N0 * W1
    Q1 = sum(K for K, P, k in places if k); P1 = sum(P for K, P, k in places if k)
    Q0 = sum(K for K, P, k in places if not k); P0 = sum(P for K, P, k in places if not k)
    counts = b * N0 * P1 + g * N1 * Q0 < b * N1 * P0 + g * N0 * Q1
    closed = (b - g) * n * x * (y + 2 * z) > y * (b * (2 * x + y) + g * (y + 2 * z))
    if not (mean == counts == closed):
        bad += 1
print('mismatches', bad)
