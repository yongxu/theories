# AI-written (Fable, refuter seat, round 11), 16 November 2026. Searches, not proofs.
import random, itertools
def sub(a, b): return a - b if a >= b else 0
# A. seat 1: Q = Holds (LineOnAStock.lean:188) and level <= hi and Regime at the way (:193) is kept by one step,
#    under even (taken (kids u) = use u), some (kids u != []), down (a kid needs no more than its parent).
random.seed(2)
def world():
    while True:
        K = random.randint(1, 3); names = list(range(K))
        use = {u: random.randint(0, 3) for u in names}; need = {u: random.randint(0, 7) for u in names}
        kids = {}
        ok = True
        for u in names:
            opts = [c for r in (1, 2, 3) for c in itertools.product(names, repeat=r)
                    if sum(use[v] for v in c) == use[u] and all(need[v] <= need[u] for v in c)]
            if not opts: ok = False; break
            kids[u] = random.choice(opts)
        if ok: return names, need, use, kids
tried = viol = holdsonly = 0; ex = None
for _ in range(4000):
    names, need, use, kids = world()
    hi = random.randint(4, 12); g = [random.randint(0, 5) for _ in range(hi + 8)]; g[0] = random.choice([0, 0, 1])
    gf = lambda z: g[z] if z < len(g) else 0
    yv = {T: random.randint(0, 6) for T in range(0, 40)}; y = lambda T: yv.get(T, 0)
    step_l = lambda T, x: sub(x, T) + gf(sub(x, T))
    def regime(w):
        T = sum(use[u] for u in w); yy = y(T)
        return (all(gf(z) < T for z in range(yy)) and all(T <= gf(z) for z in range(yy, hi + 1) if z + T <= hi)
                and all(step_l(T, x) <= hi for x in range(hi + 1)))
    def holds(w, x):
        T = sum(use[u] for u in w); return len(w) > 0 and all(need[u] <= x for u in w) and T + y(T) <= x
    for w in itertools.chain.from_iterable(itertools.product(names, repeat=r) for r in (1, 2)):
        for x in range(hi + 1):
            if holds(w, x):
                T = sum(use[u] for u in w)
                w2 = tuple(k for u in w if need[u] <= x for k in kids[u]); x2 = step_l(T, x)
                if not holds(w2, x2): holdsonly += 1
                if regime(w):
                    tried += 1
                    if not (holds(w2, x2) and x2 <= hi and regime(w2)): viol += 1; ex = ex or (need, use, kids, g, w, x, w2, x2)
print(f"A. Holds with level <= hi and Regime: {tried} members, {viol} whose next is not a member; Holds alone left in {holdsonly} steps", ex or "")
# B. the edge of seat 3's (d): which starts break 'level at 0 iff start below the least z whose net giving covers H'
def step_law(kinds, x): return sub(x + sum(k[2] for k in kinds if k[0] <= x), sum(k[1] for k in kinds if k[0] <= x))
random.seed(9); kinds_of = {}; n = 0
for _ in range(6000):
    ks = []
    for _ in range(random.randint(1, 3)):
        nd = random.randint(0, 6); tk = random.randint(0, 3); ks.append((nd, tk, tk + random.randint(0, 3)))
    H = random.randint(1, 6); kinds = ks + [(0, H, 0)]
    N = lambda z: sum(k[2] - k[1] for k in ks if k[0] <= z)
    y = next((z for z in range(0, 8) if N(z) >= H), None)
    for x in range(0, 14):
        l = x
        for _ in range(60):
            l = step_law(kinds, l)
            if l > 500: break
        if (l == 0) != (True if y is None else x < y):
            kinds_of[(x, y, N(0) == H)] = kinds_of.get((x, y, N(0) == H), 0) + 1
print("B. violations by (start, least z, net giving at nothing equals H):", kinds_of)
