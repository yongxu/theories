# Small exact checks for reader "stock-and-line". Reading aid only; no Lean is built.
import random
random.seed(16)

def step(g, H, x):            # RegimeMargin.step
    left = max(x - H, 0)
    return left + g(left)

# --- the line (LineOnAStock.after / taken / left / Goes), units as (need, use, kids-index list)
def line_course(units_need, units_use, kids, g, w, x, N):
    out = [(list(w), x)]
    for _ in range(N):
        T = sum(units_use[u] for u in w)
        w2 = []
        for u in w:
            if units_need[u] <= x:
                w2 += kids[u]
        x2 = step(g, T, x)
        w, x = w2, x2
        out.append((list(w), x))
    return out

def along(draw, repl, n, acts, k):   # Stock.along
    for i in range(k):
        n = max(n - draw(acts[i]), 0) + repl(acts[i])
    return n

# 1. level course = Stock.along at the acts read off the course; step balances iff taken <= level
bad = 0; runs = 0; balfail = 0
for trial in range(4000):
    nU = random.randint(1, 3)
    need = [random.randint(0, 6) for _ in range(nU)]
    use = [random.randint(0, 4) for _ in range(nU)]
    kids = [[random.randrange(nU) for _ in range(random.randint(0, 2))] for _ in range(nU)]
    table = [random.randint(0, 5) for _ in range(40)]
    g = lambda z, table=table: table[min(z, 39)]
    w = [random.randrange(nU) for _ in range(random.randint(1, 3))]
    x = random.randint(0, 12)
    N = 8
    c = line_course(need, use, kids, g, w, x, N)
    if max(len(s[0]) for s in c) > 200: continue
    acts = []
    for (ww, xx) in c[:-1]:
        T = sum(use[u] for u in ww)
        acts.append((T, g(max(xx - T, 0))))
    for k in range(N + 1):
        runs += 1
        if along(lambda a: a[0], lambda a: a[1], x, acts, k) != c[k][1]:
            bad += 1
    for k in range(N):
        T, r = acts[k]
        balanced = (c[k + 1][1] + T == c[k][1] + r)
        if balanced != (T <= c[k][1]):
            balfail += 1
print("1. along == level:", runs, "checks,", bad, "mismatches; (step balances) <-> (taken <= level) failures:", balfail)

# 2. carried for ever (taken <= level at every step) while the net has ended at step 0
need = [5]; use = [1]; kids = [[0]]
g = lambda z: 1 if z >= 1 else 0          # FromNothing holds
c = line_course(need, use, kids, g, [0], 3, 30)
goes0 = any(need[u] <= c[0][1] for u in c[0][0])
within = all(sum(use[u] for u in ww) <= xx for (ww, xx) in c)
print("2. need 5, use 1, level 3: Goes at step 0 =", goes0, "; taken <= level at steps 0..30 =", within, "; levels", [s[1] for s in c[:6]])

# 3. draw = level: a Stock.process step exists; on the line (FromNothing, need > 0) the net ends next step
need = [1]; use = [3]; kids = [[0]]
c = line_course(need, use, kids, g, [0], 3, 3)
print("3. need 1, use 3, level 3: stock step allowed (3 <= 3); line levels", [s[1] for s in c], "Goes at step 1 =", any(need[u] <= c[1][1] for u in c[1][0]))

# 4. FourReaders: habitat tables against 'turned' of the cleared course, and Recoverable against 2 <= X N
def habitat(k, t):
    if k == 's0': return 4
    if k == 's1': return 4 if t == 0 else 3
    if k == 's2': return [4, 3][t] if t < 2 else 2
    return [4, 3, 2, 1][t] if t < 4 else 0
giv = lambda z: 1 if z >= 1 else 0
X = lambda t: habitat('never', t)
def turned(X, g, H, T, t):
    if t <= T: return X(t)
    v = X(T)
    for _ in range(t - T): v = step(g, H, v)
    return v
stopAt = {'s0': 0, 's1': 1, 's2': 2, 'never': 3}
HOR = 40
ok = all(habitat(k, t) == turned(X, giv, 1, stopAt[k], t) for k in stopAt for t in range(HOR))
later = all(turned(X, giv, 1, T, t) == habitat('never', t) for T in range(3, 12) for t in range(HOR))
print("4a. habitat k = cleared course turned to H=1 at stopAt k:", ok, "; turns at T>=3 are the cleared course:", later)
def recoverable_tables(N):
    return any(all(habitat(k, t) == X(t) for t in range(N + 1)) and all(habitat(k, t) >= 1 for t in range(HOR)) for k in stopAt)
def recoverable_turns(N):
    return any(all(turned(X, giv, 1, T, t) == X(t) for t in range(N + 1)) and all(turned(X, giv, 1, T, t) >= 1 for t in range(HOR)) for T in range(0, 12))
def regime_ends(x):
    v = x
    for _ in range(HOR):
        if v == 0: return True
        v = step(giv, 1, v)
    return v == 0
print("4b. N: tables-recoverable, turns-recoverable, 2<=X N, regime from X N does not end")
for N in range(7):
    print("   ", N, recoverable_tables(N), recoverable_turns(N), 2 <= X(N), not regime_ends(X(N)))
# premises of TurningInTime.recoverable_iff_above at H=1, y=1, hi=4, need=1
H, y, hi, nd = 1, 1, 4, 1
print("4c. fall", all(X(t + 1) <= X(t) for t in range(HOR)), "top", X(0) <= hi, "nothing", giv(0) == 0,
      "short", all(giv(z) < H for z in range(y)), "meets", all(H <= giv(z) for z in range(y, hi + 1) if z + H <= hi),
      "keeps", all(step(giv, H, x) <= hi for x in range(hi + 1)), "needs", 0 < nd, "within", nd <= H + y)

# 5. a line course whose level rises: recoverable (turn to H) at N=0 though X 0 < H + y
g3 = lambda z: min(z, max(12 - z, 0))     # TurningInTime.Three.giving
c = line_course([1], [1], [[0]], g3, [0], 3, 12)
Xl = lambda t: c[t][1] if t < len(c) else c[-1][1]
H, y, hi, nd = 5, 5, 12, 1
prem = dict(nothing=g3(0) == 0, short=all(g3(z) < H for z in range(y)),
            meets=all(H <= g3(z) for z in range(y, hi + 1) if z + H <= hi),
            keeps=all(step(g3, H, x) <= hi for x in range(hi + 1)), within=nd <= H + y,
            fall=all(Xl(t + 1) <= Xl(t) for t in range(12)), top=Xl(0) <= hi)
rec0 = any(all(turned(Xl, g3, H, T, t) == Xl(t) for t in range(1)) and all(turned(Xl, g3, H, T, t) >= nd for t in range(HOR)) for T in range(0, 12))
print("5. line levels", [Xl(t) for t in range(7)], "premises", prem, "; recoverable at 0 =", rec0, "; H+y <= X 0 =", H + y <= Xl(0))

# 6. with the ACTUAL take min(level, taken) as the draw, every step of every line course is a
#    Stock.process step (draw <= stock, and after + draw = before + replenish), no premise
random.seed(17)
fails = 0; n = 0
for trial in range(4000):
    nU = random.randint(1, 3)
    need = [random.randint(0, 6) for _ in range(nU)]
    use = [random.randint(0, 4) for _ in range(nU)]
    kids = [[random.randrange(nU) for _ in range(random.randint(0, 2))] for _ in range(nU)]
    table = [random.randint(0, 5) for _ in range(40)]
    g = lambda z, table=table: table[min(z, 39)]
    w = [random.randrange(nU) for _ in range(random.randint(1, 3))]
    x = random.randint(0, 12)
    c = line_course(need, use, kids, g, w, x, 8)
    if max(len(s[0]) for s in c) > 200: continue
    for k in range(8):
        T = sum(use[u] for u in c[k][0]); lvl = c[k][1]
        d = min(lvl, T); r = g(max(lvl - T, 0))
        n += 1
        if not (d <= lvl and c[k + 1][1] + d == lvl + r):
            fails += 1
print("6. actual-take stock step at every step:", n, "steps,", fails, "failures")
