import random, itertools
random.seed(1)
def monotone_A(E, R, V):
    # random table A[e][r], monotone in e and r, values in 0..V
    A = [[random.randint(0, V) for r in range(R+1)] for e in range(E+1)]
    for e in range(E+1):
        for r in range(R+1):
            m = A[e][r]
            if e > 0: m = max(m, A[e-1][r])
            if r > 0: m = max(m, A[e][r-1])
            A[e][r] = min(m, V)
    return A
bad = 0; checked = 0; worst = 0
for trial in range(200000):
    H = random.randint(1, 3); hi = random.randint(H, 7)
    A = monotone_A(hi, hi, hi)
    # Keeps: for x <= hi, any r <= hi: step level <= hi
    def step(p):
        x, r = p; e = max(x - H, 0); a = A[e][r]; return (e + a, a)
    ok = all(step((x, r))[0] <= hi for x in range(hi+1) for r in range(hi+1))
    if not ok: continue
    for x in range(hi+1):
        for r in range(hi+1):
            p = (x, r); seen = {}
            n = 0
            while True:
                q = step(p)
                if q == p: break
                if p in seen:
                    bad += 1; print('cycle', H, hi, A, (x, r)); break
                seen[p] = n; p = q; n += 1
            worst = max(worst, n); checked += 1
    if bad > 3: break
print('checked runs', checked, 'cycles', bad, 'longest time to rest', worst)
