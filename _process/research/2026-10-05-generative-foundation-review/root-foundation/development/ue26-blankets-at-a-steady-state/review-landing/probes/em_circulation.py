"""Landing review probe: the synchronous (Euler-Maruyama) steady precision of four-part drifts.

Exact rationals. For B = (D - Q) P with D = I, the scheme x' = (I - hB) x + xi, cov(xi) = 2hI,
has steady covariance S solving S = A S A^T + 2h I (A = I - hB). We solve it by vectorisation,
invert, and read the internal-external entry. Order of coordinates: external 0, sensory 1,
active 2, internal 3 (as in LinearBlankets.Autonomous).
"""
from fractions import Fraction as F
import itertools, math

def mat(rows): return [[F(x) for x in r] for r in rows]
def mul(A, B): return [[sum(A[i][k]*B[k][j] for k in range(len(B))) for j in range(len(B[0]))] for i in range(len(A))]
def T(A): return [list(r) for r in zip(*A)]
def add(A, B, c=1): return [[a + c*b for a, b in zip(ra, rb)] for ra, rb in zip(A, B)]
def eye(n): return [[F(int(i == j)) for j in range(n)] for i in range(n)]
def scal(c, A): return [[c*a for a in r] for r in A]

def solve(M, b):
    n = len(M); A = [r[:] + [bb] for r, bb in zip(M, b)]
    for c in range(n):
        p = next(i for i in range(c, n) if A[i][c] != 0)
        A[c], A[p] = A[p], A[c]
        A[c] = [x / A[c][c] for x in A[c]]
        for i in range(n):
            if i != c and A[i][c] != 0:
                f = A[i][c]; A[i] = [a - f*bq for a, bq in zip(A[i], A[c])]
    return [A[i][n] for i in range(n)]

def inv(M):
    n = len(M); cols = [solve(M, [F(int(i == j)) for i in range(n)]) for j in range(n)]
    return T(cols)

def em_steady_cov(B, h, D):
    n = len(B); A = add(eye(n), B, -h)
    # S - A S A^T = 2 h D, unknowns S[i][j]
    idx = [(i, j) for i in range(n) for j in range(n)]
    M = []; rhs = []
    for (i, j) in idx:
        row = []
        for (k, l) in idx:
            row.append(F(int((i, j) == (k, l))) - A[i][k]*A[j][l])
        M.append(row); rhs.append(2*h*D[i][j])
    s = solve(M, rhs)
    return [[s[i*n + j] for j in range(n)] for i in range(n)]

def spectral_ok(A, steps=400):
    # crude: the norm of A^steps (floats) should be tiny
    Af = [[float(x) for x in r] for r in A]; P = [[float(i == j) for j in range(len(A))] for i in range(len(A))]
    for _ in range(steps):
        P = [[sum(P[i][k]*Af[k][j] for k in range(len(A))) for j in range(len(A))] for i in range(len(A))]
    return max(abs(x) for r in P for x in r)

P = mat([[2, 1, 0, 0], [1, 3, 1, 0], [0, 1, 3, 1], [0, 0, 1, 2]])
I4 = eye(4)
cases = {
    "Autonomous (Q_es = 1, Q_ai = -1)": mat([[0, 1, 0, 0], [-1, 0, 0, 0], [0, 0, 0, -1], [0, 0, 1, 0]]),
    "agent-only circulation (Q_ai = -1)": mat([[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, -1], [0, 0, 1, 0]]),
    "world-only circulation (Q_es = 1)": mat([[0, 1, 0, 0], [-1, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]),
    "no circulation": mat([[0]*4]*4),
}
for name, Q in cases.items():
    B = mul(add(I4, Q, -1), P)
    sparse = all(B[i][j] == 0 for i in (2, 3) for j in (0,)) and all(B[i][j] == 0 for i in (0, 1) for j in (3,))
    for h in (F(1, 10), F(1, 100)):
        S = em_steady_cov(B, h, I4)
        M = inv(S)
        A = add(I4, B, -h)
        print(f"{name}: sparse={sparse}, h={h}: internal-external precision {M[3][0]} (~{float(M[3][0]):.3e}), "
              f"active-external {M[2][0]} ; |A^400| = {spectral_ok(A):.1e}")

print("\n-- counterexamples to the general wording --")
# Agent and world uncoupled in the precision (P_as = 0): the drift circulates (Q_es = 1, Q_ai = -1),
# meets footnote 13 and the four-part sparse coupling, and the synchronous steady precision keeps every
# agent-world zero at every listed h. So "with circulation it loses the internal-external zero" is a
# witness, not a law.
P2 = mat([[2, 1, 0, 0], [1, 3, 0, 0], [0, 0, 3, 1], [0, 0, 1, 2]])
Q2 = cases["Autonomous (Q_es = 1, Q_ai = -1)"]
B2 = mul(add(I4, Q2, -1), P2)
for h in (F(1, 10), F(1, 3)):
    M = inv(em_steady_cov(B2, h, I4))
    print(f"P_as = 0, circulating: h={h}: internal-external {M[3][0]}, active-external {M[2][0]}, Q != 0: True")
# Without circulation, P_as = 0: the active-external entry stays zero (em_active_external's sum is empty
# of nonzero terms), so "loses the active-external one" is not a law either.
B3 = P2
for h in (F(1, 10),):
    M = inv(em_steady_cov(B3, h, I4))
    print(f"P_as = 0, no circulation: h={h}: active-external {M[2][0]}, sensory-internal {M[1][3]}")
# Sensory-internal entry in Autonomous's no-circulation case: -(h/2) * P_sa * P_ai (no Lean theorem states it)
M = inv(em_steady_cov(P, F(1, 10), I4))
print(f"Autonomous P, no circulation, h=1/10: sensory-internal {M[1][3]}, closed form {-(F(1,10)/2)*P[1][2]*P[2][3]}")

print("\n-- the formula P - (h/2) P D P is the steady precision only without circulation --")
Qa = cases["Autonomous (Q_es = 1, Q_ai = -1)"]
Ba = mul(add(I4, Qa, -1), P)
h = F(1, 10)
formula = add(P, mul(P, P), -h/2)
M = inv(em_steady_cov(Ba, h, I4))
print(f"Autonomous, circulating, h=1/10: (P - (h/2)P^2)[3][0] = {formula[3][0]}, steady precision [3][0] = {M[3][0]}")
print("order h: internal-external entry at h = 1/10, 1/100, 1/1000:",
      [float(inv(em_steady_cov(Ba, hh, I4))[3][0]) for hh in (F(1, 10), F(1, 100), F(1, 1000))])
