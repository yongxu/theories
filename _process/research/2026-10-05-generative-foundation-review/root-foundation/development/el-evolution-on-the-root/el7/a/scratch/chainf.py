# float mirror of markov.py: absorption by n, giving share over n, mean absorption time (Gauss)
from itertools import product
def chain(lawf, lawg, H, e, q=0.0):
    S = list(product(product((True, False), repeat=H), repeat=2))
    T = {}
    for s in S:
        h1, h2 = s
        p1 = 1.0 if lawf(h1, h2) else q; p2 = 1.0 if lawg(h2, h1) else q
        g1, g2 = p1*(1-e), p2*(1-e)
        out = {}
        for a, pa in ((True, g1), (False, 1-g1)):
            for b, pb in ((True, g2), (False, 1-g2)):
                if pa*pb == 0: continue
                ns = ((a,)+h1[:-1], (b,)+h2[:-1]); out[ns] = out.get(ns, 0)+pa*pb
        T[s] = out
    return S, T
def run(lawf, lawg, H, e, n, q=0.0):
    S, T = chain(lawf, lawg, H, e, q)
    d = {(tuple([True]*H), tuple([True]*H)): 1.0}; g = 0.0; dead = 0.0
    for t in range(n):
        nd = {}
        for s, p in d.items():
            for ns, r in T[s].items(): nd[ns] = nd.get(ns, 0)+p*r
        d = nd
        g += sum(p for s, p in d.items() if s[0][0]) + sum(p for s, p in d.items() if s[1][0])
        dead = sum(p for s, p in d.items() if not any(s[0]) and not any(s[1]))
    return g/(2*n), dead
def mean_time(lawf, lawg, H, e):
    S, T = chain(lawf, lawg, H, e)
    dead = (tuple([False]*H), tuple([False]*H))
    tr = [s for s in S if s != dead]; ix = {s: i for i, s in enumerate(tr)}; m = len(tr)
    A = [[0.0]*(m+1) for _ in range(m)]
    for s in tr:
        i = ix[s]; A[i][i] += 1.0; A[i][m] = 1.0
        for ns, r in T[s].items():
            if ns != dead: A[i][ix[ns]] -= r
    for c in range(m):
        piv = max(range(c, m), key=lambda r: abs(A[r][c])); A[c], A[piv] = A[piv], A[c]
        for r in range(m):
            if r != c and A[r][c] != 0:
                f = A[r][c]/A[c][c]
                for k in range(c, m+1): A[r][k] -= f*A[c][k]
    return A[ix[(tuple([True]*H), tuple([True]*H))]][m]/A[ix[(tuple([True]*H), tuple([True]*H))]][ix[(tuple([True]*H), tuple([True]*H))]]
W = lambda w: (lambda o, p: any(p[:w]))
agree = lambda o, p: o[0] == p[0]
spare = lambda o, p: True
grim = lambda o, p: o[0] and p[0]
e = 1/20
for name, law, H in (('answering', W(1), 1), ('window2', W(2), 2), ('window3', W(3), 3), ('grim', grim, 1), ('agreement', agree, 1), ('sparing', spare, 1)):
    row = [f'{name:9s}']
    for n in (20, 200, 2000, 6000, 7000, 10000):
        gs, dd = run(law, law, H, e, n); row.append(f'n={n}: give {gs:.4f} dead {dd:.4f}')
    print(' | '.join(row))
for name, law, H in (('answering', W(1), 1), ('window2', W(2), 2), ('window3', W(3), 3), ('grim', grim, 1)):
    print(name, 'mean steps to total withholding', f'{mean_time(law, law, H, e):.4g}')
for q in (0.1, 1/3):
    print('GTFT q', round(q, 3), ' | '.join(f'n={n}: give {run(W(1), W(1), 1, e, n, q)[0]:.4f} dead {run(W(1), W(1), 1, e, n, q)[1]:.4f}' for n in (20, 200, 2000, 6000, 7000, 10000)))
