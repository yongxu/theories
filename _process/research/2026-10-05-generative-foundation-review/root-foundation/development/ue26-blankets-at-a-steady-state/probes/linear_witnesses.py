from fractions import Fraction as F
from itertools import product
def mm(A, B): return [[sum(A[i][k] * B[k][j] for k in range(len(B))) for j in range(len(B[0]))] for i in range(len(A))]
def T(A): return [list(r) for r in zip(*A)]
def add(A, B, s=1): return [[a + s * b for a, b in zip(r, q)] for r, q in zip(A, B)]
def sc(c, A): return [[c * a for a in r] for r in A]
def inv(A):
    n = len(A); M = [list(map(F, r)) + [F(int(i == j)) for j in range(n)] for i, r in enumerate(A)]
    for c in range(n):
        p = next(r for r in range(c, n) if M[r][c] != 0); M[c], M[p] = M[p], M[c]
        M[c] = [x / M[c][c] for x in M[c]]
        for r in range(n):
            if r != c: M[r] = [x - M[r][c] * y for x, y in zip(M[r], M[c])]
    return [r[n:] for r in M]
def solve(A, b):
    Ai = inv(A); return [sum(Ai[i][j] * b[j] for j in range(len(b))) for i in range(len(b))]
def lyap(B, D):
    n = len(B); pairs = [(i, j) for i in range(n) for j in range(i, n)]
    def S(vals):
        M = [[F(0)] * n for _ in range(n)]
        for (i, j), v in zip(pairs, vals): M[i][j] = M[j][i] = v
        return M
    rows, rhs = [], []
    for (i, j) in pairs:
        row = []
        for p in pairs:
            E = S([F(int(q == p)) for q in pairs]); L = add(mm(B, E), mm(E, T(B)))
            row.append(L[i][j])
        rows.append(row); rhs.append(2 * D[i][j])
    return S(solve(rows, rhs))
I3 = [[F(int(i == j)) for j in range(3)] for i in range(3)]
show = lambda name, M: print(name, [[str(x) for x in r] for r in M])
# witness 1: (mu, s, eta), mu <- s <- eta, noise each coordinate's own
c = F(1)
B = [[F(1), -c, F(0)], [F(0), F(1), -c], [F(0), F(0), F(1)]]
Sig = lyap(B, I3); Pi = inv(Sig); Q = sc(F(1, 2), add(mm(Sig, T(B)), mm(B, Sig), -1))
show('B', B); show('Sigma', Sig); show('Pi', Pi); show('Q', Q)
print('check B = (D - Q) Pi:', mm(add(I3, Q, -1), Pi) == B, ' Pi_mu,eta =', Pi[0][2])
# witness 2: Pi with zero (mu,eta) block, circulation through mu
Pi2 = [[F(2), F(1), F(0)], [F(1), F(2), F(1)], [F(0), F(1), F(2)]]
Q2 = [[F(0), F(1), F(0)], [F(-1), F(0), F(0)], [F(0), F(0), F(0)]]
B2 = mm(add(I3, Q2, -1), Pi2); show('B2', B2)
Sig2 = inv(Pi2); print('Lyapunov holds for B2:', add(mm(B2, Sig2), mm(Sig2, T(B2))) == sc(2, I3), ' B2_mu,eta =', B2[0][2], ' B2_eta,mu =', B2[2][0])
# witness 3: no circulation through mu (Q row mu zero) but circulation s-eta
Q3 = [[F(0), F(0), F(0)], [F(0), F(0), F(1)], [F(0), F(-1), F(0)]]
B3 = mm(add(I3, Q3, -1), Pi2); show('B3', B3); print(' B3_mu,eta =', B3[0][2], '(equals D_mumu Pi_mu,eta =', Pi2[0][2], ')')
