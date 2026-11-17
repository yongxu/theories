"""AI-written (reader web-base, round16). Small checks of the paper carrying of the line's
course onto Flow/Web records. A search over small cases, not a proof. Transcribes:
  LineOnAStock.after/taken/left/step (LineOnAStock.lean:138-155), RegimeMargin.step (:249),
  Flow.taken/given/Balances/takers (Flow.lean:269-279, 314), Web.Supported/Dependent
  (Dependence.lean:134-139), Flow.Taking (Flow.lean:296), Flow.DissipatesOn (Dissipation.lean:242).
"""
import itertools, random

def rstep(g, H, x):            # RegimeMargin.step, truncated subtraction
    z = max(x - H, 0)
    return z + g(z)

def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x:
            out += kids[u]
    return out

def taken(use, w): return sum(use[u] for u in w)

def course(need, kids, g, use, w, x, n):
    cs = [(list(w), x)]
    for _ in range(n):
        w, x = cs[-1]
        cs.append((after(need, kids, w, x), rstep(g, taken(use, w), x)))
    return cs

# carried records: F = units of the way (with repetition) + giver None; one condition
def carried(need, kids, g, use, w, x, n):
    cs = course(need, kids, g, use, w, x, n + 1)
    rows = []
    for t in range(n + 1):
        wt, xt = cs[t]
        T = taken(use, wt)
        G = g(max(xt - T, 0))
        bal = (cs[t + 1][1] + T == xt + G)                 # Flow.Balances at t
        dependent = all(need[u] <= xt for u in wt)         # active := present
        takers = sum(1 for u in wt if use[u] > 0)          # Flow.takers [()] t (count with repetition)
        # DissipatesOn [()] t: every present f: give + sign(take) <= take ; giver: G + 0 <= 0
        dissip = (G == 0)
        rows.append(dict(t=t, way=wt, level=xt, T=T, G=G, bal=bal, within=(T <= xt),
                         dependent=dependent, takers=takers, dissip=dissip,
                         goes=any(need[u] <= xt for u in wt)))
    return rows

random.seed(7)
mism = 0; cases = 0; dep_fail_while_goes = 0; nd = 0
for _ in range(20000):
    k = random.randint(1, 3)
    U = list(range(k))
    need = {u: random.randint(0, 4) for u in U}
    use = {u: random.randint(0, 3) for u in U}
    kids = {u: [random.choice(U) for _ in range(random.randint(0, 2))] for u in U}
    tab = [random.randint(0, 3) for _ in range(40)]
    g = lambda z, tab=tab: tab[min(z, 39)]
    w = [random.choice(U) for _ in range(random.randint(1, 3))]
    x = random.randint(0, 8)
    for r in carried(need, kids, g, use, w, x, 6):
        cases += 1
        if r['bal'] != r['within']: mism += 1
        if r['goes'] and not r['dependent'] and any(use[u] > 0 and need[u] > r['level'] for u in r['way']):
            dep_fail_while_goes += 1
        if r['bal'] and r['T'] > 0 and r['G'] > 0: nd += 1
print("steps checked", cases, "| Balances(t) != (taken<=level):", mism)
print("steps where net goes, an unmet unit with positive use is present (Taking & Dependent cannot both hold):", dep_fail_while_goes)
print("balanced steps with positive take and positive giving (giver gives, takes nothing -> not DissipatesOn):", nd)

# D2: one lineage, kids n = [n+1], use n = n+1: grows holds, takers stays 1, uptake unbounded
need = {n: 1 for n in range(60)}; use = {n: n + 1 for n in range(60)}
kids = {n: [n + 1] for n in range(59)}; kids[59] = []
g = lambda z: z + 100      # a giving that keeps it going for the window
rows = carried(need, kids, g, use, [0], 50, 12)
print("single lineage: takers per step", [r['takers'] for r in rows], "uptake", [r['T'] for r in rows],
      "balanced", all(r['bal'] for r in rows))
assert all(use[n] < taken(use, kids[n]) for n in range(59))

# every unit `grows`, `down` fails, net never ends with bounded uptake (cf. KidsNeedMore in the package)
need = {'P': 1, 'Q': 100}; use = {'P': 1, 'Q': 1}; kids = {'P': ['P', 'Q'], 'Q': ['Q', 'Q']}
g = lambda z: 2 if z >= 1 else 0
rows = carried(need, kids, g, use, ['P'], 10, 12)
print("P/Q: ways", [''.join(r['way']) for r in rows], "levels", [r['level'] for r in rows],
      "uptake", [r['T'] for r in rows], "balanced", all(r['bal'] for r in rows),
      "dependent", [r['dependent'] for r in rows])

# D5 on the line's step: take h and give back b (added after, as ScratchCovering's order L)
# versus take h-b: differ where giving reads what is left
diff = 0; tot = 0
for x in range(0, 9):
    for h in range(0, 6):
        for b in range(0, h + 1):
            for tab in itertools.product(range(3), repeat=4):
                gg = lambda z, tab=tab: tab[min(z, 3)]
                a = rstep(gg, h, x) + b
                c = rstep(gg, h - b, x)
                tot += 1
                if h <= x and a != c: diff += 1
print("line step, h<=x: (take h, give back b) vs (take h-b): differ in", diff, "of", tot)
# under Flow.Balances alone (level' + taken = level + given) the two are the same equation
