"""Exact solve of `SynchronousCopy`'s kernels (core leaf `Becoming.BlanketWeights`).

For each kernel (sensory miss 0 and 1 in 4) the steady weights are the left null space of
K - 64 I over the rationals, K the kernel on the eight states (mu, s, e). The rank of K - 64 I
is 7 for both, so each steady law is unique up to scale; the script prints the integer weights,
which are the Lean module's `exactWeight` and `noisyWeight`.
"""
from fractions import Fraction as F
from functools import reduce
from itertools import product
from math import gcd, lcm

def external_step(e, e2): return 3 if e2 == e else 1
def sensory_step(miss, e, s2): return 4 - miss if s2 == e else miss
def internal_step(s, mu2): return 4 if mu2 == s else 0

def kernel(miss, x, y):
    _, s, e = x; mu2, s2, e2 = y
    return internal_step(s, mu2) * sensory_step(miss, e, s2) * external_step(e, e2)

STATES = list(product((False, True), repeat=3))

def rank_and_null(rows):
    m = [r[:] for r in rows]; n = len(m[0]); pivots = []; r = 0
    for c in range(n):
        p = next((i for i in range(r, len(m)) if m[i][c] != 0), None)
        if p is None: continue
        m[r], m[p] = m[p], m[r]
        m[r] = [x / m[r][c] for x in m[r]]
        for i in range(len(m)):
            if i != r and m[i][c] != 0:
                f = m[i][c]; m[i] = [a - f * b for a, b in zip(m[i], m[r])]
        pivots.append(c); r += 1
    free = [c for c in range(n) if c not in pivots]
    assert len(free) == 1
    v = [F(0)] * n; v[free[0]] = F(1)
    for i, c in enumerate(pivots): v[c] = -m[i][free[0]]
    return r, v

for miss, expected in [(0, {(False, False, False): 9, (False, False, True): 3, (False, True, False): 1,
                             (False, True, True): 3, (True, False, False): 3, (True, False, True): 1,
                             (True, True, False): 3, (True, True, True): 9}),
                       (1, {(False, False, False): 6, (False, False, True): 3, (False, True, False): 3,
                             (False, True, True): 4, (True, False, False): 4, (True, False, True): 3,
                             (True, True, False): 3, (True, True, True): 6})]:
    # rows of (K - 64 I)^T: the steady weights w satisfy sum_x w(x) K(x, y) = 64 w(y)
    rows = [[F(kernel(miss, x, y) - (64 if x == y else 0)) for x in STATES] for y in STATES]
    rank, v = rank_and_null(rows)
    scale = reduce(lcm, (q.denominator for q in v))
    w = [int(q * scale) for q in v]; g = reduce(gcd, w); w = [x // g for x in w]
    if w[0] < 0: w = [-x for x in w]
    weights = dict(zip(STATES, w))
    print(f"miss {miss}: rank {rank}, weights {[weights[s] for s in STATES]}")
    assert rank == 7 and weights == expected
print("both kernels: steady weights unique up to scale, equal to the module's")
