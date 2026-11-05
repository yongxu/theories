"""Exact mirror of Becoming.PairSelection's pair run, for design checks only (not evidence)."""
from itertools import product
from fractions import Fraction as F

# laws: f(own=(last, prev), partner=(last, prev)) -> bool
sparing     = lambda o, p: True
answering   = lambda o, p: p[0]
windowed    = lambda o, p: p[0] or p[1]
agreeing    = lambda o, p: o[0] == p[0]
waitingBoth = lambda o, p: o[0] and p[0]
withholding = lambda o, p: False
alternating = lambda o, p: not o[0]
LAWS = dict(S=sparing, A=answering, W=windowed, P=agreeing, G=waitingBoth, D=withholding, L=alternating)

def run(f, g, err, n, forgive=None):
    """err(t, side) -> bool (side 0 first, 1 second); forgive(t, side) -> bool turns withholding into giving
    (forgiveness by a supplied pattern; None = none). Returns lists P, Q of giving at steps 0..n-1."""
    fo = forgive or (lambda t, s: False)
    def act(law, own, par, t, s):
        intended = law(own, par) or fo(t, s)
        return intended and not err(t, s)
    o1, o2 = (True, True), (True, True)
    P, Q = [], []
    for t in range(n):
        a = act(f, o1, o2, t, 0)
        b = act(g, o2, o1, t, 1)
        P.append(a); Q.append(b)
        o1, o2 = (a, o1[0]), (b, o2[0])
    return P, Q

def counts(P, Q):
    n = len(P)
    R1, K1 = sum(Q), n - sum(P)
    R2, K2 = sum(P), n - sum(Q)
    return (R1, K1), (R2, K2)

if __name__ == '__main__':
    # check against table_twenty / error_table_twenty
    names = 'SAWPGDL'
    rows = []
    for x in names:
        row = []
        for y in names:
            P, Q = run(LAWS[x], LAWS[y], lambda t, s: False, 20)
            row.append(counts(P, Q)[0])
        rows.append(row)
    for x, r in zip(names, rows): print(x, r)
    print()
    for x in names:
        P, Q = run(LAWS[x], LAWS[x], lambda t, s: t == 5 and s == 0, 20)
        print(x, counts(P, Q))
