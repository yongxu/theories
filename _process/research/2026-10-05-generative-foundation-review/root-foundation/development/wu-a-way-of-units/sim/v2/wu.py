# Faithful python translation of Becoming.WayOfUnits (AI-written reader script)
import random, itertools, sys
N = 40  # giving defined on 0..N, 0 beyond (bounded state space)

def mk(g_list):
    def g(z):
        return g_list[z] if 0 <= z < len(g_list) else 0
    g.tab = g_list
    return g

def step(g, H, x):
    z = max(x - H, 0); return z + g(z)

def taken(w): return sum(u[1] for u in w)
def after(w, x): return [u for u in w if u[0] <= x]
def Goes(s): return any(u[0] <= s[1] for u in s[0])
def pair(g, s): w, x = s; return (tuple(after(w, x)), step(g, taken(w), x))

def course(g, s0):
    """states list until first repeat; returns (states, loop_start)"""
    seen = {}; st = []; s = (tuple(s0[0]), s0[1])
    while s not in seen:
        seen[s] = len(st); st.append(s); s = pair(g, s)
    return st, seen[s]

def unending(g, s0):
    st, _ = course(g, s0); return all(Goes(s) for s in st), st

def Short(g, H, y): return all(g(z) < H for z in range(y))
def Meets(g, H, y, hi): return all(H <= g(z) for z in range(y, hi + 1) if z + H <= hi)
def Keeps(g, H, hi): return all(step(g, H, x) <= hi for x in range(hi + 1))
def FromNothing(g): return g(0) == 0
def Regime(g, y, hi, S, parts=(1,1,1)):
    H = taken(S); r = True
    if parts[0]: r = r and Short(g, H, y(H))
    if parts[1]: r = r and Meets(g, H, y(H), hi)
    if parts[2]: r = r and Keeps(g, H, hi)
    return r
def Holds(y, s):
    S, z = s
    return len(S) > 0 and all(u[0] <= z for u in S) and taken(S) + y(taken(S)) <= z

def reach_idx(st):
    """indices k (in the orbit prefix) with all j<k Goes"""
    out = []
    for k, s in enumerate(st):
        out.append(k)
        if not Goes(s): break
    return out

# ---------- givings
def givings(rng, allow_nonzero0=False):
    L = []
    for c in range(4, 25): L.append(('tent%d' % c, mk([max(0, min(z, c - z)) for z in range(N + 1)])))
    L.append(('concave', mk([min(2 * z, z + 2) for z in range(N + 1)])))
    for a in range(1, 4):
        for b in (3, 6, 9): L.append(('min%dz,%d' % (a, b), mk([min(a * z, b) for z in range(N + 1)])))
    for i in range(60):
        t = [0] + [rng.randint(0, 8) for _ in range(N)]
        if rng.random() < .5: t = [0] + sorted(t[1:22]) + [rng.randint(0, 8) for _ in range(N - 21)]
        L.append(('rand%d' % i, mk(t)))
    if allow_nonzero0:
        for i in range(20):
            t = [rng.randint(1, 6)] + [rng.randint(0, 8) for _ in range(N)]
            L.append(('rand0_%d' % i, mk(t)))
    return L

def root_y(g, hi):
    def y(H):
        for z in range(hi + 2):
            if g(z) >= H: return z
        return hi + 1
    return y

def rand_way(rng):
    k = rng.randint(0, 4)
    base = [(rng.randint(0, 12), rng.randint(0, 6)) for _ in range(k)]
    if k and rng.random() < .3: base.append(rng.choice(base))  # repeat
    return base
