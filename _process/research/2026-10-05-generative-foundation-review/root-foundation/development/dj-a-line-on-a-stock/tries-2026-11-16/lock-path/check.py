# AI-written (Fable, seat "lock-path", round 11), 16 November 2026.
# Small transcriptions of Lean definitions, run on finite grids. A search by script is not a proof.
# Lean sources transcribed: RegimeMargin.step (:249), TurningInTime.pair/net (:337, :352),
# windowAlone (:1279), RuleCapture.CarrierCounts order/favours/select (:478-:498), Locked (:160),
# Pace.turn (as in TurningInTime.regroup_step :1487), RuleShaping.shaped/byBack (:150, :426),
# RuleRebuilding St/step/net (:145-:226).
from itertools import product

def monus(a, b): return a - b if a >= b else 0
def rstep(g, d, x): z = monus(x, d); return z + g(z)          # RegimeMargin.step
def le(x, y): return x[0] * y[1] <= y[0] * x[1]                # CarrierCounts.order.le
def fav(g): return g[1] <= g[0]                                # CarrierCounts.favours
def sel(x, g): return (x[0] * g[0], x[1] * g[1])               # CarrierCounts.select
def shaped(a, s, p, c): return (a + s + p, a + c + p)
def locked(h, x, g): return fav(g) and le(g, h(x, g))          # RuleCapture.Locked order favours h

def window_alone(fA, hA, reads, w):
    a, g, n = w
    return (fA(a, g), hA(a, g) if reads(n) else g, n + 1)

def run_net(need, after, left, s, cap):
    """Follow TurningInTime.net: a next only where need <= level. Returns (steps, end state or None)."""
    for n in range(cap + 1):
        w, x = s
        if x < need: return n, s
        s = (after(w, x), left(w, x))
    return None, s

print("== (1b) closed-capture's loss against the regime's level ==")
# Accrues fB: p.2 + 1 <= fB p g at every p. The regime's level step at level 0 with FromNothing is 0.
bad = 0
for table in product(range(0, 4), repeat=4):          # giving on 1..4, giving 0 = 0
    g = lambda z, t=table: 0 if z == 0 else t[min(z, 4) - 1]
    for d in range(0, 6):
        if rstep(g, d, 0) >= 1: bad += 1
print("givings with giving 0 = 0 whose step at level 0 adds one (Accrues there):", bad, "of", 4 ** 4 * 6)
# Optimum's form x + g - d with g <= r < d: never above x; Accrues asks x + 1.
viol = sum(1 for x in range(0, 30) for r in range(0, 5) for gg in range(0, r + 1) for d in range(r + 1, r + 6)
           if monus(x + gg, d) >= x + 1)
print("steps in Optimum's form (g <= r < d) that add one to the level:", viol)

print("\n== (2) types: count_rises' premise `rise` on CarrierCounts ==")
# rise : forall a g, favours g -> a < fA a g, for a natural number read off the population.
# The tie rule (1,1) favours and select x (1,1) = x: no function of x rises there.
x = (3, 2); print("select", x, "(1,1) =", sel(x, (1, 1)), "; favours (1,1):", fav((1, 1)))
print("rule (2,5): favours?", fav((2, 5)), "; carriers of", x, "after:", sel(x, (2, 5))[0], "(count rises, share falls:",
      not le(x, sel(x, (2, 5))), ")")
print("rule (2,2) <= (1,1) in the ratio order:", le((2, 2), (1, 1)), "; carriers under (1,1) from 3:", sel((3, 2), (1, 1))[0])

print("\n== (2) countermodel: covering_locks' premises, a ceiling, a use counting carriers, never ends ==")
giving = lambda z: min(z, monus(12, z))
a, p, c, s0 = 1, 0, 0, 0
sigma = lambda x: 0
h = lambda x, g: shaped(a, sigma(x), p, c)             # byBack
reads = lambda n: True
alone = lambda w: window_alone(sel, h, reads, w)
use = lambda w: w[0][0] * 1
w0 = ((1, 1), shaped(a, s0, p, c), 0)
st = (w0, 12); seen = []
for n in range(200):
    seen.append((st[0][0], st[0][1], st[1], locked(h, st[0][0], st[0][1])))
    st = (alone(st[0]), rstep(giving, use(st[0]), st[1]))
print("first 3 (share, rule, level, Locked):", seen[:3])
print("all 200 steps: level 12, share (1,1), Locked:", all(v == ((1, 1), (1, 1), 12, True) for v in seen))
print("Keeps giving 0 12:", all(rstep(giving, 0, x) <= 12 for x in range(13)), "; giving 0 =", giving(0))

print("\n== (2) `more` for use = carriers * u, from a start whose rule favours strictly ==")
G = [(i, j) for i in range(0, 5) for j in range(1, 5)]
bad_strict = bad_weak = n_strict = n_weak = 0
for x0 in G:
    if x0[0] == 0: continue
    for g0 in G:
        if not fav(g0): continue
        strict = g0[1] < g0[0]
        for y in G:
            if not le(x0, y): continue
            for g1 in G:
                if not le(g0, g1): continue
                rises = y[0] < sel(y, g1)[0]
                if strict:
                    n_strict += 1; bad_strict += (not rises)
                else:
                    n_weak += 1; bad_weak += (not rises)
print("strict start rule, carriers present: cases", n_strict, "failures of the rise", bad_strict)
print("tie start rule: cases", n_weak, "failures of the rise", bad_weak)

print("\n== (2) composed statement (A): from the locked configuration covering_locks reaches ==")
def givings(hi):
    out = [lambda z, hi=hi: min(z, monus(hi, z)), lambda z, hi=hi: 0,
           lambda z, hi=hi: 0 if z == 0 else min(1, monus(hi, z)),
           lambda z, hi=hi: 0 if z == 0 else monus(hi, z)]
    return [g for g in out if g(0) == 0 and all(rstep(g, 0, x) <= hi for x in range(hi + 1))]
cases = fails = notlocked = 0
for a, p, c in product((1, 2), (0, 1), (0, 1, 2)):
    for lo_, hi_ in ((c + 1, c + 1), (c + 1, c + 3)):
        sigma = lambda x, lo_=lo_, hi_=hi_: hi_ if x[1] <= x[0] else lo_      # thresholdBack, lo <= hi: monotone
        h = lambda x, g, a=a, p=p, c=c, sigma=sigma: shaped(a, sigma(x), p, c)
        for s in (c, c + 2):
            for x0 in ((1, 1), (1, 3), (2, 1)):
                for sched in (lambda n: True, lambda n: n % 2 == 1):
                    r = 0 if sched(0) else 1
                    cfg = (x0, shaped(a, s, p, c))
                    for t in range(r + 1):                       # paced select byBack reads, r + 1 steps
                        cfg = (sel(cfg[0], cfg[1]), h(cfg[0], cfg[1]) if sched(t) else cfg[1])
                    if not locked(h, cfg[0], cfg[1]): notlocked += 1; continue
                    w = (cfg[0], cfg[1], r + 1)
                    alone = lambda w, h=h, sched=sched: window_alone(sel, h, sched, w)
                    for hi in (3, 6, 9):
                        for g in givings(hi):
                            for need, u, lvl in product((1, 2), (1, 2), range(0, hi + 1)):
                                usef = lambda w, u=u: w[0][0] * u
                                n, end = run_net(need, lambda w, x: alone(w), lambda w, x: rstep(g, usef(w), x),
                                                 (w, lvl), hi + 1)
                                cases += 1
                                if n is None or not locked(h, end[0][0], end[0][1]): fails += 1
print("covering_locks' conclusion Locked at r + 1 failed:", notlocked)
print("cases", cases, "; not ended Locked within hi + 1 steps:", fails)

print("\n== (2) from the start, before the lock: the line can end not Locked ==")
a, p, c, s = 1, 0, 1, 5
sigma = lambda x: 1
h = lambda x, g: shaped(a, sigma(x), p, c)
sched = lambda n: n >= 3                                  # first reading step is step 3
w0 = ((1, 1), shaped(a, s, p, c), 0)
print("start rule", w0[1], "read", h(w0[0], w0[1]), "Locked at start:", locked(h, w0[0], w0[1]))
g12 = lambda z: min(z, monus(12, z))
n, end = run_net(1, lambda w, x: window_alone(sel, h, sched, w), lambda w, x: rstep(g12, w[0][0], x), (w0, 12), 13)
print("ends at step", n, "way", end[0], "level", end[1], "Locked:", locked(h, end[0][0], end[0][1]))

print("\n== (3) RuleRebuilding ==")
def sumL(xs): return sum(xs)
def after_(l, xs): return sum(xs[l:])
def rr_step(r, m, x):
    s, l, g, f, c, src = r; q, L, H, O = x; on, rev = m
    take = sumL(H) + sumL(O)
    if L == 0 or L + g < take: return (q, 0, (), ())
    T = after_(l, H)
    ent = (q if (src == 'out' or (src == 'mem' and T > 0)) else 0) if on else 0
    door = monus(f, c * T) if on else 0
    q2 = q if src == 'out' else (rev if (sumL(H) > 0 and rev is not None) else q)
    return (q2, L + g - take, tuple(([ent] + list(H))[:s]), tuple(([door] + list(O))[:s]))
rB = (4, 2, 20, 6, 1, 'mem')
x = (3, 10, (3, 3, 3, 3), (0, 0, 0, 0))
succ = {rr_step(rB, m, x) for m in ((True, None), (False, None), (True, 5))}
print("successors of one state under three moves:", len(succ))
gone = (3, 0, (), ())
print("the end has a next, itself:", rr_step(rB, (True, None), gone) == gone)
# level: level + g - take (give, then take). The regime's step takes first and gives of what is left.
print("level 1, renewal 4, take 3 -> RuleRebuilding", 1 + 4 - 3, "; regime needs giving 0 =", 1 + 4 - 3 - monus(1, 3))
print("level 3, renewal 4, take 3 -> RuleRebuilding", 3 + 4 - 3, "; regime needs giving 0 =", 3 + 4 - 3 - monus(3, 3))
# AloneOutside: at which levels does the way after a step read the level, for a fixed move?
m = (True, None); read_at = set()
for L in range(1, 40):
    for k in range(1, 80):
        w = (1, (k,), ())                                 # one cohort of k holders: take k
        r1 = (1, 0, 4, 0, 0, 'mem')
        a1 = rr_step(r1, m, (w[0], L, w[1], w[2]))[2:]
        a2 = rr_step(r1, m, (w[0], L + 100, w[1], w[2]))[2:]
        if a1 != a2: read_at.add(L)
print("levels 1..39 at which some way's next way reads the level:", len(read_at), "of 39")

print("\n== (2) composed statement with weak covering and 2 <= a + c + p (each member leaves two) ==")
cases = fails = notlocked = 0
for a, p, c in product((1, 2), (0, 1), (0, 1, 2)):
    if a + c + p < 2: continue
    for lo_, hi_ in ((c, c), (c, c + 2)):
        sigma = lambda x, lo_=lo_, hi_=hi_: hi_ if x[1] <= x[0] else lo_
        h = lambda x, g, a=a, p=p, c=c, sigma=sigma: shaped(a, sigma(x), p, c)
        for s in (c, c + 2):
            for x0 in ((1, 1), (1, 3), (2, 1)):
                for sched in (lambda n: True, lambda n: n % 2 == 1):
                    r = 0 if sched(0) else 1
                    cfg = (x0, shaped(a, s, p, c))
                    for t in range(r + 1):
                        cfg = (sel(cfg[0], cfg[1]), h(cfg[0], cfg[1]) if sched(t) else cfg[1])
                    if not locked(h, cfg[0], cfg[1]): notlocked += 1; continue
                    w = (cfg[0], cfg[1], r + 1)
                    alone = lambda w, h=h, sched=sched: window_alone(sel, h, sched, w)
                    for hi in (3, 6, 9):
                        for g in givings(hi):
                            for need, u, lvl in product((1, 2), (1, 2), range(0, hi + 1)):
                                usef = lambda w, u=u: w[0][0] * u
                                n, end = run_net(need, lambda w, x: alone(w), lambda w, x: rstep(g, usef(w), x),
                                                 (w, lvl), hi + 1)
                                cases += 1
                                if n is None or not locked(h, end[0][0], end[0][1]): fails += 1
print("not Locked at r + 1:", notlocked, "; cases", cases, "; not ended Locked within hi + 1 steps:", fails)

print("\n== (1b) the reading level = K - loss (neither side defines it) ==")
import random
random.seed(11)
cases = fails = 0
for trial in range(400):
    K = random.randint(1, 12)
    bump = {}
    def fB(pp, g, bump=bump):                      # Accrues: p.2 + 1 <= fB p g
        key = (pp, g)
        if key not in bump: bump[key] = random.randint(1, 3)
        return pp[1] + bump[key]
    hh = lambda x, g: (4, 1)                        # closedRead: the rule read is hi at every share
    alone = lambda w: window_alone(sel, hh, lambda n: True, w)
    left = lambda w, x, K=K, fB=fB: monus(K, fB((w[0], monus(K, x)), w[1]))
    for lvl in range(0, K + 1):
        for need in (1, 2):
            w0 = ((2, 1), (4, 1), 0)
            n, end = run_net(need, lambda w, x: alone(w), left, (w0, lvl), lvl + 1)
            cases += 1
            if n is None or n > lvl or not locked(hh, end[0][0], end[0][1]): fails += 1
print("cases", cases, "; not ended Locked within the start level's steps:", fails)
