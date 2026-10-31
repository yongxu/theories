from fractions import Fraction as F
from itertools import product
from math import lcm, gcd
from functools import reduce

def solve(A, b):
    n = len(A); M = [row[:] + [b[i]] for i, row in enumerate(A)]
    for c in range(n):
        p = next(r for r in range(c, n) if M[r][c] != 0); M[c], M[p] = M[p], M[c]
        for r in range(n):
            if r != c and M[r][c] != 0:
                f = M[r][c] / M[c][c]; M[r] = [x - f * y for x, y in zip(M[r], M[c])]
    return [M[i][n] / M[i][i] for i in range(n)]

def stationary(states, rate):
    n = len(states); idx = {s: i for i, s in enumerate(states)}
    # generator rows; solve pi G = 0 with sum = 1
    G = [[F(0)] * n for _ in range(n)]
    for x in states:
        for y in states:
            if x != y:
                G[idx[x]][idx[y]] = F(rate(x, y))
        G[idx[x]][idx[x]] = -sum(G[idx[x]][j] for j in range(n) if j != idx[x])
    A = [[G[j][i] for j in range(n)] for i in range(n)]  # transpose
    A[-1] = [F(1)] * n; b = [F(0)] * (n - 1) + [F(1)]
    pi = solve(A, b)
    L = reduce(lcm, (p.denominator for p in pi)); w = [int(p * L) for p in pi]
    g = reduce(gcd, w); return {s: w[i] // g for i, s in enumerate(states)}

# chain: (mu, s, e) in Bool^3, single-part flips
def rate(x, y, a=3, c=1):
    d = [i for i in range(3) if x[i] != y[i]]
    if len(d) != 1: return 0
    mu, s, e = x
    if d == [2]: return 1                      # e flips, reads e
    if d == [1]: return a if s != e else c     # s tracks e, reads s, e
    if d == [0]: return a if mu != s else c    # mu tracks s, reads mu, s
states = list(product((0, 1), repeat=3))
w = stationary(states, rate)
print('weights', w)
ci = all(w[(m, s, e)] * w[(m2, s, e2)] == w[(m, s, e2)] * w[(m2, s, e)]
         for m, m2, s, e, e2 in product((0, 1), repeat=5))
print('cross form holds:', ci)
for s in (0, 1):
    print(' s=', s, 'w(0,s,0)w(1,s,1)=', w[(0, s, 0)] * w[(1, s, 1)], ' w(0,s,1)w(1,s,0)=', w[(0, s, 1)] * w[(1, s, 0)])
db = all(w[x] * rate(x, y) == w[y] * rate(y, x) for x in states for y in states if x != y and x[1:] == y[1:])
print('internal moves in detailed balance:', db)
# global balance check
for x in states:
    assert sum(w[y] * rate(y, x) for y in states if y != x) == w[x] * sum(rate(x, y) for y in states if y != x)
print('global balance ok')
