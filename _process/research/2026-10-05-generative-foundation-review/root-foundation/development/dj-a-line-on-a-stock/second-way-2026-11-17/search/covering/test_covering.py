# AI-written (Claude), scratch, outside the package, not landed. 17 November 2026.
# Tests the exact statements (3) and (4) of ScratchCovering before proving them.
# Model transcribed from the Lean: after, taken, level in order L, Goes, course.
import itertools, random, sys
random.seed(19)

def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x: out += kids[u]
    return out

def taken(use, w): return sum(use[u] for u in w)

def level(need, giving, use, give, w, x):
    z = max(0, x - taken(use, w))
    return z + giving(z) + sum(give[u] for u in w if need[u] <= z)

def step(need, kids, giving, use, give, s):
    w, x = s
    return (after(need, kids, w, x), level(need, giving, use, give, w, x))

def goes(need, s): return any(need[u] <= s[1] for u in s[0])

def gen(kids, n, w):
    for _ in range(n):
        w = [v for u in w for v in kids[u]]
    return w

GIVINGS = {'zero': lambda z: 0, 'min3': lambda z: min(z, 3), 'hump12': lambda z: max(0, min(z, 12 - z)),
           'id': lambda z: z, 'one': lambda z: 1}

# (3): premises some, down, covers, w != [], met on what is left; conclusion for n < STEPS
def test3(trials=20000, STEPS=7, cap=400):
    bad = 0; checked = 0
    for _ in range(trials):
        K = random.randint(1, 3)
        need = [random.randint(0, 5) for _ in range(K)]
        use = [random.randint(0, 3) for _ in range(K)]
        kids = [[random.randrange(K) for _ in range(random.randint(1, 2))] for _ in range(K)]
        if any(need[v] > need[u] for u in range(K) for v in kids[u]): continue
        give = [taken(use, kids[u]) + random.randint(0, 2) for u in range(K)]
        w = [random.randrange(K) for _ in range(random.randint(1, 3))]
        x = random.randint(0, 25)
        if any(need[u] > x - taken(use, w) for u in w): continue
        gname = random.choice(list(GIVINGS)); g = GIVINGS[gname]
        checked += 1
        s = (w, x)
        for n in range(STEPS):
            if len(s[0]) > cap: break
            left = s[1] - taken(use, s[0])
            ok = s[0] == gen(kids, n, w) and all(need[u] <= left for u in s[0]) and goes(need, s)
            s2 = step(need, kids, g, use, give, s)
            ok = ok and (s2[1] - taken(use, s2[0])) >= left
            if not ok:
                bad += 1; print('BAD3', need, use, kids, give, w, x, gname, n); break
            s = s2
    print('test3 configurations checked', checked, 'violations', bad)

# (3) without one premise each: show which are needed (counterexamples count)
def test3_drop(trials=20000, STEPS=7, cap=400):
    for drop in ['some', 'down', 'covers', 'ne', 'met']:
        bad = 0; checked = 0; ex = None
        for _ in range(trials):
            K = random.randint(1, 3)
            need = [random.randint(0, 5) for _ in range(K)]
            use = [random.randint(0, 3) for _ in range(K)]
            kids = [[random.randrange(K) for _ in range(random.randint(0 if drop=='some' else 1, 2))] for _ in range(K)]
            if drop != 'down' and any(need[v] > need[u] for u in range(K) for v in kids[u]): continue
            give = [max(0, taken(use, kids[u]) + random.randint(-2 if drop=='covers' else 0, 2)) for u in range(K)]
            w = [random.randrange(K) for _ in range(random.randint(0 if drop=='ne' else 1, 3))]
            x = random.randint(0, 25)
            if drop != 'met' and any(need[u] > x - taken(use, w) for u in w): continue
            g = GIVINGS['zero']; checked += 1
            s = (w, x); fail = False
            for n in range(STEPS):
                if len(s[0]) > cap: break
                if not goes(need, s): fail = True; break
                s = step(need, kids, g, use, give, s)
            if fail:
                bad += 1; ex = ex or (need, use, kids, give, w, x)
        print('drop', drop, 'checked', checked, 'net ended within', STEPS, ':', bad, 'e.g.', ex)

# (4): one kind, exact, giving zero
def unending_one(a, t, b, k, N, x, STEPS=None):
    # returns True if never ends (certified), False if ends; decided by invariant/decrease argument
    n, X = N, x
    for i in range(10000):
        if not (n >= 1 and a <= X): return False
        z = max(0, X - t * n)
        if z >= a and b >= k * t: return True   # covered: what is left never falls (proved on paper)
        if t == 0 and z >= a: return True
        X = z + (n * b if a <= z else 0); n = n * k
        if n > 10**6 and b < k*t: pass
    raise Exception('undecided')

def sim(a, t, b, k, N, x, STEPS=40):
    s = ([0]*N, x); need=[a]; use=[t]; give=[b]; kids=[[0]*k]
    for i in range(STEPS):
        if not goes(need, s): return False
        if len(s[0]) > 20000: return None
        s = step(need, kids, GIVINGS['zero'], use, give, s)
    return True

def test4():
    mism = 0; cases = 0; undec = 0
    for a, t, b, k, N, x in itertools.product(range(0, 5), range(0, 4), range(0, 9), range(0, 4), range(0, 4), range(0, 25)):
        r = sim(a, t, b, k, N, x)
        if r is None: undec += 1; continue
        cond = k * t <= b and a + t * N <= x
        prem = a >= 1 and k >= 1 and N >= 1
        cases += 1
        if r != cond:
            mism += 1
            if prem: print('MISMATCH4 under premises', a, t, b, k, N, x, r, cond)
    print('test4 cases', cases, 'undecided (too large)', undec, 'mismatches (any premises)', mism)
    # mismatches by which premise fails
    for name, f in [('a=0', lambda a,k,N: a == 0), ('k=0', lambda a,k,N: k == 0), ('N=0', lambda a,k,N: N == 0)]:
        c = 0; ex = None
        for a, t, b, k, N, x in itertools.product(range(0, 5), range(0, 4), range(0, 9), range(0, 4), range(0, 4), range(0, 25)):
            if not f(a,k,N): continue
            others = [p for p in [a >= 1, k >= 1, N >= 1]]
            r = sim(a, t, b, k, N, x, 30)
            if r is None: continue
            if r != (k * t <= b and a + t * N <= x):
                c += 1; ex = ex or (a, t, b, k, N, x, r)
        print('premise', name, 'mismatches', c, 'e.g. (a,t,b,k,N,x,never)', ex)

test3(); test3_drop(); test4()
