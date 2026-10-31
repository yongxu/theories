"""Landing review probe: scan the agent's circulation r (Q_ai = r) with the world's Q_es = 1 on
LinearBlankets.Autonomous's precision, h = 1/10; the internal-external entry of the synchronous
steady precision changes sign, so some circulating, coupled, footnote-13 drift keeps the zero at
that step (by cancellation)."""
import sys
sys.path.insert(0, '.')
from em_circulation import mat, mul, add, inv, em_steady_cov, eye, F, P
I4 = eye(4)
for r in [F(x, 4) for x in range(-8, 9)]:
    Q = mat([[0, 1, 0, 0], [-1, 0, 0, 0], [0, 0, 0, r], [0, 0, -r, 0]])
    B = mul(add(I4, Q, -1), P)
    M = inv(em_steady_cov(B, F(1, 10), I4))
    print(f"Q_ai = {str(r):>5}: internal-external {float(M[3][0]): .5f}")
