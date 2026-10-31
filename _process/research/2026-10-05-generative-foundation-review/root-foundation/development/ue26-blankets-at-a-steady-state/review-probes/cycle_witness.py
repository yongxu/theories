from itertools import product
from collections import Counter
# Blanketed law: external e in Z4 steps e+1; sensory reads a bit of e; internal copies sensory. No active part.
for name, bit in (("high bit (e >= 2)", lambda e: int(e >= 2)), ("low bit (e mod 2)", lambda e: e % 2)):
    x = (0, 0, 0); seen = []
    for t in range(40):
        seen.append(x); mu, s, e = x; x = (s, bit(e), (e + 1) % 4)
    period = seen[20:24]; w = Counter(period)
    cross = all(w[(i, s, e)] * w[(j, s, f)] == w[(i, s, f)] * w[(j, s, e)]
                for i, j, s in product((0, 1), repeat=3) for e, f in product(range(4), repeat=2))
    print(name, "period states", sorted(period), "held apart:", cross)
