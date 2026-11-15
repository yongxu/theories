# AI-written (Fable, reader "web"), 16 November 2026. A search, not a proof. Read-only check of the
# reading of a WayOfUnits course (and the candidate with offspring) as a Web with a Flow.
import random, itertools
random.seed(9)
sub = lambda a, b: a - b if a >= b else 0           # Nat subtraction
def hump(c): return lambda z: min(z, sub(c, z))
def gated(c, m): return lambda z: 0 if z < m else min(z, sub(c, z))
def gfn(z): return 2 if z in (0, 2) else 0          # WayOfUnits.GivenFromNothing.giving
def step(g, H, x): return sub(x, H) + g(sub(x, H))  # RegimeMargin.step

# ---- A. the regime alone, min z (12 - z)
g = hump(12); useF = minF = tot = 0; wrong_iff = 0
for H in range(0, 10):
    for x in range(0, 17):
        tot += 1
        bal_use = step(g, H, x) + H == x + g(sub(x, H))
        bal_min = step(g, H, x) + sub(x, sub(x, H)) == x + g(sub(x, H))   # Adjusted.step_balances
        useF += not bal_use; minF += not bal_min
        wrong_iff += (bal_use != (H <= x))
print("A regime 12: cases", tot, "| take:=H fails", useF, "| take:=x-(x-H) fails", minF,
      "| (balance with take:=H) <-> H<=x wrong in", wrong_iff)

# ---- B. a way of units (kids u = [u]) and the candidate (kids given)
def course(g, need, use, kids, w, x, n):
    out = []
    for _ in range(n):
        out.append((list(w), x))
        T = sum(use[u] for u in w)
        w2 = [v for u in w if need[u] <= x for v in kids[u]]
        if len(w2) > 200: return None               # a way that multiplies without bound: left out
        w, x = w2, step(g, T, x)
    return out
def goes(need, w, x): return any(need[u] <= x for u in w)

def run(label, offspring, zero_need=False, giving=None, trials=3000):
    st = dict(courses=0, steps=0, unbal=0, iff_wrong=0, item7_viol=0, unbal_while_next_goes=0,
              max_unbal=0, dep_present_viol=0, taking_viol=0, jk=0, jk_bad=0, ex=0, ex_bad=0,
              over=0, over_not_g0=0, rest_app=0, rest_bad=0, unending=0, unending_unbal=0)
    for _ in range(trials):
        k = random.randint(1, 3)
        need = [random.randint(0 if zero_need else 1, 12) for _ in range(k)]
        use = [random.randint(0, 5) for _ in range(k)]
        if offspring:
            kids = [[random.randrange(k) for _ in range(random.randint(0, 2))] for _ in range(k)]
        else:
            kids = [[u] for u in range(k)]
        w = [random.randrange(k) for _ in range(random.randint(1, 3))]
        gg = giving or hump(random.randint(8, 14))
        x0 = random.randint(0, 14)
        N = 24
        c = course(gg, need, use, kids, w, x0, N + 1)
        if c is None: continue
        st['courses'] += 1; nun = 0
        allgo = all(goes(need, *c[t]) for t in range(N))
        st['unending'] += allgo
        for t in range(N):
            wy, x = c[t]; x1 = c[t + 1][1]
            T = sum(use[u] for u in wy); G = gg(sub(x, T))
            bal = (x1 + T == x + G)
            st['steps'] += 1; st['unbal'] += not bal; nun += not bal
            st['iff_wrong'] += (bal != (T <= x))
            if goes(need, *c[t + 1]):
                st['item7_viol'] += not (T < x)
                st['unbal_while_next_goes'] += not bal
            st['dep_present_viol'] += any(need[u] > x for u in wy)
            st['taking_viol'] += any(need[u] > x and use[u] > 0 for u in wy)
            if T <= x and T <= G: st['jk'] += 1; st['jk_bad'] += not (x <= x1)
            if T <= x and G < T: st['ex'] += 1; st['ex_bad'] += not (x1 + 1 <= x)
            if T > x: st['over'] += 1; st['over_not_g0'] += (x1 != gg(0))
        st['max_unbal'] = max(st['max_unbal'], nun)
        if allgo: st['unending_unbal'] += nun
        # restores: from T0, m = level + d, premise net giving at k<d wherever level >= level T0
        for T0 in range(0, 6):
            for d in range(1, 5):
                lv = c[T0][1]; ok = True
                for kk in range(d):
                    wy, x = c[T0 + kk]; T = sum(use[u] for u in wy); G = gg(sub(x, T))
                    if not (c[T0 + kk + 1][1] + T == x + G): ok = False
                    if lv <= x and not (T < G): ok = False
                if ok:
                    st['rest_app'] += 1; st['rest_bad'] += not (lv + d <= c[T0 + d][1])
    print(label, st)

run("B1 way of units, humps, needs>0:", False)
run("B2 candidate with kids, humps, needs>0:", True)
run("B3 way of units, a need of 0 allowed:", False, zero_need=True)
run("B4 way of units, given from nothing (2 at 0 and 2):", False, giving=gfn)

# ---- B7. stays_below at a gate m (giving nothing below m): how often the flow of uses balances there
tot = bal = esc = 0
for _ in range(3000):
    m = random.randint(1, 4); gg = gated(random.randint(8, 14), m)
    k = random.randint(1, 3); need = [random.randint(1, 12) for _ in range(k)]; use = [random.randint(0, 5) for _ in range(k)]
    c = course(gg, need, use, [[u] for u in range(k)], list(range(k)), random.randint(0, 14), 30)
    seen = False
    for t in range(29):
        wy, x = c[t]; T = sum(use[u] for u in wy)
        if x < m: seen = True
        if seen:
            tot += 1; bal += (T <= x); esc += not (x < m)
print("B7 gate m: steps once below m", tot, "| level back at or above m", esc, "| of those steps balanced with take:=use", bal)
