# AI-written (Fable), 16 November 2026. Reader's script: not Lean. Small-model search for
# counterexamples to the statements of scratch LineOnAStock.lean that changed in the repair pass,
# and a recomputation of the worked courses and kept countermodels. Read-only; runs in seconds.
import itertools, random, sys
random.seed(20261116)

def lvl(g, H, x):                      # RegimeMargin.step g H x = (x - H) + g (x - H)
    z = x - H if x >= H else 0
    return z + g(z)

def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x:
            out.extend(kids[u])
    return out

def taken(use, w):
    return sum(use[u] for u in w)

def step(need, kids, g, use, s):
    w, x = s
    return (after(need, kids, w, x), lvl(g, taken(use, w), x))

def course(need, kids, g, use, s, n):
    out = [s]
    for _ in range(n):
        s = step(need, kids, g, use, s)
        out.append(s)
    return out

def allkids(kids, w):
    out = []
    for u in w:
        out.extend(kids[u])
    return out

def generation(kids, n, w):
    for _ in range(n):
        w = allkids(kids, w)
    return w

def goes(need, s):
    return any(need[u] <= s[1] for u in s[0])

def reach(kids, w):
    seen = set(w); todo = list(seen)
    while todo:
        u = todo.pop()
        for v in kids[u]:
            if v not in seen:
                seen.add(v); todo.append(v)
    return seen

def tab(t):                             # a giving from a table, constant past its end
    return lambda z: t[z] if z < len(t) else t[-1]

def keeps0(g, hi):
    return all(x + g(x) <= hi for x in range(hi + 1))

def rand_giving(hi):                    # FromNothing and Keeps g 0 hi
    return [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]

def rand_world(K, hi, maxuse=3, maxkids=3, needlo=0):
    need = [random.randint(needlo, hi + 1) for _ in range(K)]
    use = [random.randint(0, maxuse) for _ in range(K)]
    kids = [[random.randrange(K) for _ in range(random.randint(0, maxkids))] for _ in range(K)]
    return need, use, kids

fails = []
def bad(name, *a):
    fails.append((name, a))
    if len(fails) < 20:
        print("COUNTEREXAMPLE", name, a)

# ---------------------------------------------------------------- need_unmet
stats = dict(n=0, reached=0, level_not_fallen=0, maxgap=-99, down=0, down_not_fallen=0)
keep_example = None
def try_need_unmet(need, use, kids, t, hi, w, x):
    g = tab(t)
    if not (t[0] == 0 and keeps0(g, hi)): return
    if not all(use[u] < taken(use, kids[u]) for u in range(len(need))): return   # grows, every u
    if not all(need[u] > 0 for u in reach(kids, w)): return                      # Needing
    if not (x <= hi and w and all(need[u] <= x for u in w)): return
    stats['n'] += 1
    c = course(need, kids, g, use, (w, x), hi + 1)
    n = None
    for j in range(hi + 2):
        if any(c[j][1] < need[u] for u in c[j][0]):
            n = j; break
    if n is None or n == 0 or n > hi + 1:
        bad('need_unmet', need, use, kids, t, hi, w, x, n); return
    for j in range(n + 1):
        if c[j][0] != generation(kids, j, w):
            bad('need_unmet.generation', need, use, kids, t, hi, w, x, j); return
    stats['maxgap'] = max(stats['maxgap'], n - (hi + 1))
    if n == hi + 1: stats['reached'] += 1
    down = all(need[v] <= need[u] for u in reach(kids, w) for v in kids[u])
    if down: stats['down'] += 1
    if c[n][1] >= x:
        stats['level_not_fallen'] += 1
        if down: stats['down_not_fallen'] += 1

for _ in range(250000):
    hi = random.randint(1, 5); K = random.randint(1, 3)
    need, use, kids = rand_world(K, hi, needlo=1)
    w = [random.randrange(K) for _ in range(random.randint(1, 3))]
    try_need_unmet(need, use, kids, rand_giving(hi), hi, w, random.randint(0, hi))
# exhaustive, 2 kinds, hi <= 3, uses 0..2, kids up to 2, ways up to 2
for hi in (1, 2, 3):
    K = 2
    kidlists = [list(k) for r in range(3) for k in itertools.product(range(K), repeat=r)]
    gs = [[0] + list(r) for r in itertools.product(*[range(hi - z + 1) for z in range(1, hi + 1)])]
    ws = [list(k) for r in (1, 2) for k in itertools.product(range(K), repeat=r)]
    for need in itertools.product(range(1, hi + 2), repeat=K):
        for use in itertools.product(range(3), repeat=K):
            for kids in itertools.product(kidlists, repeat=K):
                if not all(use[u] < taken(use, kids[u]) for u in range(K)): continue
                for t in gs:
                    for w in ws:
                        for x in range(hi + 1):
                            try_need_unmet(need, use, kids, t, hi, w, x)
print("need_unmet: instances with every premise true", stats['n'], "| bound hi+1 reached in", stats['reached'],
      "| latest n - (hi+1):", stats['maxgap'], "| unmet at n with level(n) >= start level:", stats['level_not_fallen'],
      "| of the", stats['down'], "instances where kids need no more than their parent:", stats['down_not_fallen'])

# the hand instance: kids that need more; the need is unmet at step 1 with the level where it was
g12 = lambda z: min(z, 12 - z)
need, use, kids = [1, 13], [1, 1], [[1, 1], [1, 1]]
c = course(need, kids, g12, use, ([0], 12), 2)
print("need_unmet with kids needing more (a: need 1, use 1, kids b b; b: need 13, use 1, kids b b; min z (12-z); ([a],12)):",
      c[:2], "premises:", keeps0(g12, 12), all(use[u] < taken(use, kids[u]) for u in (0, 1)))

# ---------------------------------------------------------------- one_need_ends
st = dict(n=0, latest=-99, zero=0)
def try_one(n_, use, kids, t, hi, w, x):
    g = tab(t); K = len(use); need = [n_] * K
    if not (t[0] == 0 and keeps0(g, hi) and n_ > 0 and x <= hi): return
    if not all(use[u] < taken(use, kids[u]) for u in range(K)): return
    st['n'] += 1
    c = course(need, kids, g, use, (w, x), hi + 1)
    m = None
    for j in range(hi + 2):
        if not goes(need, c[j]): m = j; break
    if m is None: bad('one_need_ends', n_, use, kids, t, hi, w, x); return
    if c[m][0] != generation(kids, m, w): bad('one_need_ends.generation', n_, use, kids, t, hi, w, x, m)
    st['latest'] = max(st['latest'], m - (hi + 1))
    if m == 0: st['zero'] += 1
for _ in range(200000):
    hi = random.randint(1, 5); K = random.randint(1, 3)
    _, use, kids = rand_world(K, hi)
    w = [random.randrange(K) for _ in range(random.randint(0, 3))]
    try_one(random.randint(1, hi + 1), use, kids, rand_giving(hi), hi, w, random.randint(0, hi))
print("one_need_ends: instances", st['n'], "| latest stop - (hi+1):", st['latest'], "| stops at step 0:", st['zero'])

# ---------------------------------------------------------------- rising_takes_all (TurningInTime), W = Nat, alone = succ
rt = dict(n=0, tight=0)
for hi in range(1, 6):
    gs = [[0] + list(r) for r in itertools.product(*[range(hi - z + 1) for z in range(1, hi + 1)])]
    for a0 in range(3):
        for incs in itertools.product((1, 2), repeat=hi):
            a = [a0]
            for d in incs: a.append(a[-1] + d)
            a.append(0)                                  # the use at step hi+1 is free: rises asks j < hi only
            for t in gs:
                g = tab(t)
                for x in range(hi + 1):
                    lv = [x]
                    for j in range(hi + 1): lv.append(lvl(g, a[j], lv[-1]))
                    rt['n'] += 1
                    if lv[hi + 1] != 0: bad('rising_takes_all', hi, a, t, x, lv)
                    if lv[hi] > 0: rt['tight'] += 1
print("rising_takes_all: instances", rt['n'], "| level at step hi still positive (so hi+1 is needed):", rt['tight'])

# ---------------------------------------------------------------- ways_alike, never_in/gone_from, takes_nothing, course_asItWas
cnt = dict(wa=0, ni=0, tn=0, ca=0, gr=0)
for _ in range(120000):
    hi = random.randint(1, 6); K = random.randint(1, 3)
    need, use, kids = rand_world(K, hi, maxkids=2)
    use2 = [random.randint(0, 3) for _ in range(K)]
    g = tab([random.randint(0, hi) for _ in range(hi + 2)]); g2 = tab([random.randint(0, hi) for _ in range(hi + 2)])
    w = [random.randrange(K) for _ in range(random.randint(0, 3))]
    x, x2 = random.randint(0, hi + 1), random.randint(0, hi + 1)
    N = 5
    c1 = course(need, kids, g, use, (w, x), N); c2 = course(need, kids, g2, use2, (w, x2), N)
    # ways_alike: largest n with the premise for all j < n
    n = 0
    while n < N and all((need[u] <= c1[n][1]) == (need[u] <= c2[n][1]) for u in c1[n][0]): n += 1
    cnt['wa'] += 1
    for j in range(n + 1):
        if c1[j][0] != c2[j][0]: bad('ways_alike', need, kids, w, x, x2, j)
    for j in range(n):                                   # born_alike: next lengths
        if len(c1[j + 1][0]) != len(c2[j + 1][0]): bad('born_alike', j)
    # never_in / gone_from: S closed (a kid with S has a parent with S)
    S = [random.random() < 0.5 for _ in range(K)]
    if all((not S[v]) or S[u] for u in range(K) for v in kids[u]):
        cnt['ni'] += 1
        for k in range(N + 1):
            if not any(S[u] for u in c1[k][0]):
                for j in range(k, N + 1):
                    if any(S[u] for u in c1[j][0]): bad('gone_from', need, kids, S, w, x, k, j)
    # takes_nothing
    Z = [random.random() < 0.5 for _ in range(K)]
    if all((not Z[u]) or (use[u] == 0 and all(Z[v] for v in kids[u])) for u in range(K)):
        cnt['tn'] += 1
        strip = lambda l: [u for u in l if not Z[u]]
        d = course(need, kids, g, use, (strip(w), x), N)
        for j in range(N + 1):
            if d[j][1] != c1[j][1] or strip(d[j][0]) != strip(c1[j][0]): bad('takes_nothing', j)
    # course_asItWas / way_while_met: while every need is met, the way is the generation
    m = 0
    while m < N and all(need[u] <= c1[m][1] for u in c1[m][0]): m += 1
    cnt['ca'] += 1
    aw, ax = w, x
    for j in range(m + 1):
        if c1[j] != (aw, ax) or c1[j][0] != generation(kids, j, w): bad('course_asItWas', j)
        aw, ax = allkids(kids, aw), lvl(g, taken(use, aw), ax)
    # kids_of_grows, generations_rise
    if w and all(use[u] < taken(use, kids[u]) for u in range(K)):
        cnt['gr'] += 1
        if any(not kids[u] for u in range(K)): bad('kids_of_grows')
        for j in range(4):
            if not taken(use, generation(kids, j, w)) < taken(use, generation(kids, j + 1, w)): bad('generations_rise', j)
print("ways_alike/born_alike", cnt['wa'], "| never_in/gone_from (closed S)", cnt['ni'], "| takes_nothing", cnt['tn'],
      "| course_asItWas/way_while_met", cnt['ca'], "| kids_of_grows/generations_rise", cnt['gr'])

# ---------------------------------------------------------------- worked courses and kept countermodels
def show(name, need, kids, g, use, s, n):
    c = course(need, kids, g, use, s, n)
    return c
nothing = lambda z: 0
hump10 = lambda z: min(z, 10 - z) if z <= 10 else 0
out = []
def eq(label, got, want):
    ok = got == want
    out.append(ok)
    print(("ok   " if ok else "DIFF ") + label, "" if ok else (got, want))

# Doubling on min z (12-z)
c = course([1], [[0, 0]], g12, [1], ([0], 12), 5)
eq("Doubling levels 0..5", [s[1] for s in c], [12, 12, 12, 12, 8, 0])
eq("Doubling sizes 0..5", [len(s[0]) for s in c], [1, 2, 4, 8, 16, 32])
eq("Doubling: first step with an unmet need (unmet_by_law's docstring: 5; bound 13)",
   next(j for j, s in enumerate(c) if any(1 > s[1] for _ in s[0])), 5)
# TwoForOne: P=0 (use 2, kids Q Q), Q=1 (use 1, kids Q)
need, use, kids = [1, 1], [2, 1], [[1, 1], [1]]
c = course(need, kids, g12, use, ([0], 4), 4)
eq("TwoForOne course", c, [([0], 4)] + [([1, 1], 4)] * 4)
H = 2
eq("TwoForOne Short 2 2", all(g12(z) < H for z in range(2)), True)
eq("TwoForOne Meets 2 2 12", all(H <= g12(z) for z in range(2, 11)), True)
eq("TwoForOne Keeps 2 12", all(lvl(g12, H, x) <= 12 for x in range(13)), True)
eq("TwoForOne even/some/down/needs", [taken(use, kids[u]) == use[u] for u in (0, 1)], [True, True])
eq("TwoForOne ([P],4) holds: 2 + 2 <= 4", taken(use, [0]) + taken(use, [0]) <= 4, True)
# NothingTakenEnds: A=0 (need 5, use 1), C=1 (need 1, use 0), each leaves itself, nothing given
need, use, kids = [5, 1], [1, 0], [[0], [1]]
c1 = course(need, kids, nothing, use, ([0, 1], 5), 5); c0 = course(need, kids, nothing, use, ([0], 5), 5)
eq("NothingTakenEnds with C", c1[:4], [([0, 1], 5), ([0, 1], 4), ([1], 3), ([1], 3)])
eq("NothingTakenEnds without C", c0[:4], [([0], 5), ([0], 4), ([], 3), ([], 3)])
eq("NothingTakenEnds levels same, ways same without C",
   all(a[1] == b[1] and [u for u in a[0] if u != 1] == [u for u in b[0] if u != 1] for a, b in zip(c0, c1)), True)
eq("NothingTakenEnds: with C goes at 0..5; without C goes at 0, not at 1",
   ([goes(need, s) for s in c1], [goes(need, s) for s in c0[:2]]), ([True] * 6, [True, False]))
# TakesNothing.lost: A=0 (1,3), B=1 (9,2), C=2 (7,0)
need, use, kids = [1, 9, 7], [3, 2, 0], [[0], [1], [2]]
c = course(need, kids, g12, use, ([0, 1, 2], 9), 5); d = course(need, kids, g12, use, ([0, 1], 9), 5)
eq("TakesNothing with C", c[:5], [([0, 1, 2], 9), ([0, 1, 2], 8), ([0, 2], 6), ([0], 6), ([0], 6)])
eq("TakesNothing without C", d[:4], [([0, 1], 9), ([0, 1], 8), ([0], 6), ([0], 6)])
# ProperLine: D=0 (kids D D), O=1 (kids O), both need 1 use 1
need, use, kids = [1, 1], [1, 1], [[0, 0], [1]]
c = course(need, kids, g12, use, ([0, 1], 12), 8)
eq("ProperLine sizes and levels 3,4,5", [(len(s[0]), s[1]) for s in c[3:6]], [(9, 12), (17, 6), (33, 0)])
eq("ProperLine from 6", c[6:9], [([], 0)] * 3)
eq("ProperLine steps 1,2", c[1:3], [([0, 0, 1], 12), ([0, 0, 0, 0, 1], 12)])
# Overdrawn
c = course([1], [[0]], g12, [7], ([0], 12), 6)
eq("Overdrawn", c, [([0], 12), ([0], 10), ([0], 6), ([0], 0), ([], 0), ([], 0), ([], 0)])
eq("Overdrawn short: giving z < 7", all(g12(z) < 7 for z in range(13)), True)
# HigherStartEnds: A=0 B=1 C=2
need, use, kids = [1, 3, 12], [3, 1, 1], [[1, 1], [2, 1], [0]]
c6 = course(need, kids, g12, use, ([0], 6), 5); c7 = course(need, kids, g12, use, ([0], 7), 5)
eq("HigherStartEnds from six", c6[:4], [([0], 6), ([1, 1], 6), ([2, 1, 2, 1], 8), ([2, 1, 2, 1], 8)])
eq("HigherStartEnds from seven 1..4", c7[1:5],
   [([1, 1], 8), ([2, 1, 2, 1], 12), ([0, 2, 1, 0, 2, 1], 12), ([1, 1, 0, 2, 1, 1, 1, 0, 2, 1], 4)])
eq("HigherStartEnds from seven step 5", (len(c7[5][0]), c7[5][1], goes(need, c7[5])), (16, 0, False))
eq("HigherStartEnds kids take less/more/more", [taken(use, kids[u]) - use[u] for u in range(3)], [-1, 1, 2])
# KidsNeedMore on hump10: A=0 (4,2,[B,A,B]), B=1 (9,1,[B,B])
need, use, kids = [4, 9], [2, 1], [[1, 0, 1], [1, 1]]
eq("KidsNeedMore fixed", step(need, kids, hump10, use, ([1, 0, 1], 8)), ([1, 0, 1], 8))
eq("KidsNeedMore keeps hump10 0 10, grows", (keeps0(hump10, 10), [use[u] < taken(use, kids[u]) for u in (0, 1)]), (True, [True, True]))
# EqualInPlaceOfMore, ShareRises, NoKids, AlikeFiner
eq("EqualInPlaceOfMore fixed", step([1], [[0]], g12, [1], ([0], 12)), ([0], 12))
c = course([1, 1], [[0], []], g12, [2, 2], ([0, 1], 12), 3)
eq("ShareRises", c, [([0, 1], 12), ([0], 12), ([0], 12), ([0], 12)])
eq("NoKids", course([1], [[]], g12, [1], ([0], 12), 1)[1], ([], 12))
eq("AlikeFiner", (after([5, 1], [[], [1]], [0, 1], 4), after([5, 1], [[], [1]], [0, 1], 6)), ([1], [1]))

# ---------------------------------------------------------------- the two built examples (their own tables, read from the tracked Lean)
# LineageRegimes.MultiplyingTakers
mk = {(0, 1): [2, 3], (1, 2): [4, 5], (1, 3): [6, 7]}
fam = [[1]]
for t in range(6): fam.append([k for p in fam[-1] for k in mk.get((t, p), [])])
present = lambda t: {0: [1], 1: [2, 3]}.get(t, [])
pool = lambda t: {0: 3, 1: 2}.get(t, 0)
c = course([1], [[0, 0]], nothing, [1], ([0], 3), 6)
eq("MultiplyingTakers sizes", [len(f) for f in fam], [len(s[0]) for s in c])
eq("MultiplyingTakers pool = level", [pool(t) for t in range(7)], [s[1] for s in c])
eq("MultiplyingTakers some member active <-> some need met",
   [any(p in present(t) for p in fam[t]) for t in range(7)], [goes([1], s) for s in c])
print("     MultiplyingTakers: sizes", [len(f) for f in fam], "levels", [s[1] for s in c],
      "| first step with no need met:", next(j for j, s in enumerate(c) if not goes([1], s)))
# LineageDrawdown.Drain, gated
def kidsP(t, p):
    if p == 4: return [5, 6] if t == 0 else []
    if p == 5: return [] if t == 9 else [7]
    if p == 6: return [] if t == 9 else [8]
    if p == 7: return [5]
    if p == 8: return [6]
    return []
draw = lambda p: 0 if p < 2 else (1 if p < 4 else 2)
poolP = lambda t: [8, 8, 7, 6, 5, 4, 3, 2, 1, 0][t] if t < 10 else 0
gift = lambda p: 0 if p == 0 else 3
fam = [[2, 4]]
for t in range(13): fam.append([k for p in fam[-1] for k in kidsP(t, p)])
need, use, kids = [4, 4, 4], [1, 2, 2], [[], [2, 2], [2]]          # r, d0, d1
c = course(need, kids, gift, use, ([0, 1], 11), 13)
eq("Drain sizes", [len(f) for f in fam], [len(s[0]) for s in c])
eq("Drain pool + gift(pool) = level", [poolP(t) + gift(poolP(t)) for t in range(14)], [s[1] for s in c])
eq("Drain total of draws = taken", [sum(draw(p) for p in f) for f in fam], [taken(use, s[0]) for s in c])
eq("Drain late: ([],0) from step 10", c[10:], [([], 0)] * 4)
eq("Drain step 1", c[1], ([2, 2], 11))
eq("need_agrees to 2000", all((4 <= p + gift(p)) == (1 <= p) for p in range(2000)), True)
eq("fall's premises at ([d1,d1],11): gift 0 < 4, every gift < 4 = what the drawers take", (gift(0) < 4, all(gift(z) < 4 for z in range(50)), taken(use, [2, 2])), (True, True, 4))
print("     Drain: levels", [s[1] for s in c[:11]], "sizes", [len(s[0]) for s in c[:11]])
print("     Drain: model's unit met (need 4 <= level) vs Drain's organisms active (stand and 1 <= pool), steps 0..9:",
      [goes(need, s) for s in c[:10]], [poolP(t) >= 1 for t in range(10)])

print()
print("worked numbers checked:", len(out), "differing:", out.count(False), "| counterexamples:", len(fails))
