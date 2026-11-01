# Linear case of Friston et al. 2023 eq. 9: J = (Q - G) H, Q antisymmetric, G diagonal positive, H symmetric.
# Term-by-term sparse coupling at an absent influence of v on u: G_u H_uv = 0 and Q_ui H_iv = 0 for every i.
# Relay on (mu, s, eta) = (0, 1, 2): mu not read by s or eta; eta not read by mu (absent or directed edges).
import sympy as sp
q01, q02, q12 = sp.symbols('q01 q02 q12')
g = sp.symbols('g0:3', positive=True)
h00, h11, h22 = sp.symbols('h00 h11 h22', positive=True)
h01, h02, h12 = sp.symbols('h01 h02 h12')
Q = sp.Matrix([[0, q01, q02], [-q01, 0, q12], [-q02, -q12, 0]])
G = sp.diag(*g)
H = sp.Matrix([[h00, h01, h02], [h01, h11, h12], [h02, h12, h22]])
absent = [(1, 0), (2, 0), (0, 2)]   # (u, v): u does not read v
conds = []
for u, v in absent:
    conds.append(G[u, u] * H[u, v])
    conds += [Q[u, i] * H[i, v] for i in range(3)]
sol = sp.solve(conds, [q01, q02, h01, h02], dict=True)
print('solutions of the term-by-term conditions:', sol)
for s_ in sol:
    J = ((Q - G) * H).subs(s_)
    print(' J_mu,s (internal reading the blanket) =', sp.simplify(J[0, 1]))
