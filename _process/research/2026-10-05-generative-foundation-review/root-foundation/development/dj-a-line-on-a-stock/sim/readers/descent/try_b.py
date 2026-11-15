# AI-written (reader "descent", round 9), 16 November 2026. Scratch: tries candidate law B of
# STEPS-3-7-ON-PAPER.md on small worlds. Nothing here is a proof. Runs in a second or two.
#
# Model L as the page words it:
#   after w x = for u in w, in order: kids u if need u <= x else nothing
#   taken w   = sum of use u over w              (every unit present takes: page / WayOfUnits)
#   left w x  = (x - taken w) + giving (x - taken w)   (truncated subtraction, RegimeMargin.step)
#   Goes (w, x) = some u in w has need u <= x ; the net steps while Goes.
# Variant flag met_only=True: only units whose need is met draw (as the Lean's built examples do).
import itertools, random

def run(need, use, kids, giving, w, x, steps=60, met_only=False, cap=4000):
    """Returns (course, ended_at). course = list of (way, level). ended_at = first step with no
    unit going on, or None if the net went on for `steps` steps."""
    course = []
    for n in range(steps + 1):
        course.append((list(w), x))
        if not any(need(u) <= x for u in w):
            return course, n
        if n == steps:
            break
        drawers = [u for u in w if need(u) <= x] if met_only else w
        H = sum(use(u) for u in drawers)
        z = max(x - H, 0)
        w2 = [v for u in w if need(u) <= x for v in kids(u)]
        if len(w2) > cap:
            return course, None
        w, x = w2, z + giving(z)
    return course, None

def b1_step(need, course):
    """first step at which some unit of the way has its need unmet, else None"""
    for n, (w, x) in enumerate(course):
        if any(need(u) > x for u in w):
            return n
    return None

def show(name, course, ended, need, names=None, k=12):
    nm = (lambda u: names[u]) if names else str
    s = "  ".join("[%s]@%d" % (",".join(nm(u) for u in w) if len(w) <= 6 else "%d units" % len(w), x)
                  for w, x in course[:k])
    print("%s\n   course: %s%s" % (name, s, " ..." if len(course) > k else ""))
    print("   B1 (some need unmet) first at step: %s ; B2 (net ends) at step: %s" %
          (b1_step(need, course), ended))

three = lambda z: min(z, 12 - z) if z <= 12 else 0      # TurningInTime.Three.giving

print("== worlds for B ==")
# W1 intended case: every premise, start <= hi = 12
N = {0: "A"}
c, e = run(lambda u: 1, lambda u: 1, lambda u: [0, 0], three, [0], 9)
show("W1 all premises (A need1 use1 kids[A,A], giving min(z,12-z), start 9)", c, e, lambda u: 1, N)

# W2 page's (i): offspring need more and are shed
need = lambda u: {0: 1, 1: 100}[u]; use = lambda u: 1; kids = lambda u: {0: [0, 1], 1: [1, 1]}[u]
c, e = run(need, use, kids, three, [0], 12)
show("W2 page (i): A need1 kids[A,B]; B need100 kids[B,B]; start 12", c, e, need, {0: "A", 1: "B"})

# W3 page's (ii): equality
c, e = run(lambda u: 1, lambda u: 2, lambda u: [0], three, [0], 12)
show("W3 page (ii): A need1 use2 kids[A]; start 12", c, e, lambda u: 1, N)

# W4 page's (iii): share rises as a ratio, number of drawers does not
need = lambda u: {0: 1, 1: 13}[u]
c, e = run(need, lambda u: 1, lambda u: [u], three, [0, 1], 12)
show("W4 page (iii): A need1, B need13, each use1 kids[itself]; start 12", c, e, need, {0: "A", 1: "B"})

# W5 start above hi. Keeps(giving,H,12) holds for every H; above 12 the giving is z.
g5 = lambda z: min(z, 12 - z) if z <= 12 else z
c, e = run(lambda u: 1, lambda u: u, lambda u: [u + 1], g5, [0], 14, steps=200)
show("W5 start 14 > hi=12, giving z above 12; unit k: need1 use k kids[k+1]", c, e, lambda u: 1, None, k=8)
print("   level after 200 steps has %d digits; closed form x_n = 2^n (14 - sum_{k<n} k/2^(k+1)) >= 2^n * 13" % len(str(c[-1][1])))

# W6 a need of nothing
c, e = run(lambda u: 0, lambda u: 1, lambda u: [0, 0], three, [0], 9, steps=12)
show("W6 need 0 (premise 'every need positive' dropped)", c, e, lambda u: 0, N, k=7)

# W7 given from nothing
c, e = run(lambda u: 1, lambda u: 1, lambda u: [0, 0], lambda z: 3, [0], 9, steps=12)
show("W7 giving 3 everywhere (giving 0 = 0 dropped)", c, e, lambda u: 1, N, k=7)

# W8 giving nothing everywhere: with growth and with equality
c, e = run(lambda u: 1, lambda u: 1, lambda u: [0, 0], lambda z: 0, [0], 9)
show("W8a giving 0 everywhere, kids[A,A]", c, e, lambda u: 1, N)
c, e = run(lambda u: 1, lambda u: 1, lambda u: [0], lambda z: 0, [0], 9)
show("W8b giving 0 everywhere, kids[A] (equality): ends too, growth idle", c, e, lambda u: 1, N)

# W9 empty start
c, e = run(lambda u: 1, lambda u: 1, lambda u: [0, 0], three, [], 9)
show("W9 empty start way", c, e, lambda u: 1, N)

# W10 only met unit has no kids (excluded by 'use u < taken(kids u)')
c, e = run(lambda u: 1, lambda u: 1, lambda u: [], three, [0], 9)
show("W10 A need1 use1 kids[] (growth premise fails)", c, e, lambda u: 1, N)

# W11 a use of nothing: A use0 kids [B]; B use1 kids [B,B]
use = lambda u: {0: 0, 1: 1}[u]; kids = lambda u: {0: [1], 1: [1, 1]}[u]
c, e = run(lambda u: 1, use, kids, three, [0], 9)
show("W11 a use of nothing (A use0 kids[B]; B use1 kids[B,B])", c, e, lambda u: 1, {0: "A", 1: "B"})

# W12 B's net conclusion against a second line that holds (Commons' shape; premises fail at W)
need = lambda u: {0: 5, 1: 1}[u]; use = lambda u: {0: 1, 1: 1}[u]; kids = lambda u: {0: [0, 0], 1: [1]}[u]
c, e = run(need, use, kids, three, [0, 1], 12, steps=30)
show("W12 F need5 use1 kids[F,F] with W need1 use1 kids[W]; start 12", c, e, need, {0: "F", 1: "W"}, k=9)

print()
print("== random search: all of B's premises, start <= hi ==")
random.seed(7)
bad = 0; worst = 0; tried = 0
for trial in range(4000):
    hi = random.randint(1, 9)
    g = [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]        # g(0)=0, z+g(z)<=hi
    nU = random.randint(1, 4)
    nd = [random.randint(1, hi + 1) for _ in range(nU)]
    us = [random.randint(0, 3) for _ in range(nU)]
    ks = []
    ok = True
    for u in range(nU):
        cands = [v for v in range(nU) if nd[v] <= nd[u]]
        found = None
        for _ in range(30):
            k = [random.choice(cands) for _ in range(random.randint(1, 3))]
            if sum(us[v] for v in k) > us[u]:
                found = k; break
        if found is None: ok = False; break
        ks.append(found)
    if not ok: continue
    tried += 1
    w0 = [random.randrange(nU) for _ in range(random.randint(1, 3))]
    x0 = random.randint(0, hi)
    for mo in (False, True):
        c, e = run(lambda u: nd[u], lambda u: us[u], lambda u: ks[u], lambda z: g[z], w0, x0,
                   steps=400, met_only=mo)
        if e is None:
            bad += 1
            print("  COUNTERMODEL to B2:", hi, g, nd, us, ks, w0, x0, mo)
        else:
            worst = max(worst, e)
            bound = (max(nd[u] for u in w0)) * (hi + 2)
            if e > bound: print("  past the bound mx0*(hi+2):", e, bound)
            if b1_step(lambda u: nd[u], c) is None:
                print("  B1 fails (no need ever unmet):", hi, g, nd, us, ks, w0, x0, mo)
print("  worlds tried: %d, B2 failures: %d, latest ending step: %d" % (tried, bad, worst))

print()
print("== the built examples as courses of L ==")
# Drain. Units r (restrained), d0 (first drawer), d1 (relaying drawer).
# Level read as pool + the renewer's gift of that step (the Lean's ledger lets the step's take
# draw on the step's gift: level(t+1) + taken = level t + given).
nm = {0: "r", 1: "d0", 2: "d1"}
use = lambda u: {0: 1, 1: 2, 2: 2}[u]; kids = lambda u: {0: [], 1: [2, 2], 2: [2]}[u]
lean_pool_gate = [8, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0]
lean_pool_out = [8, 8, 7, 6, 5, 4, 3, 2, 1, 0, 3, 6]
for label, g, lean, gift in (("gated", lambda z: 3 if z >= 1 else 0, lean_pool_gate, lambda p: 3 if p >= 1 else 0),
                             ("outside", lambda z: 3, lean_pool_out, lambda p: 3)):
    for mo in (False, True):
        w, x = [0, 1], 8 + 3
        lv = []; ways = []
        for n in range(12):
            lv.append(x); ways.append([nm[u] for u in w])
            drawers = [u for u in w if 4 <= x] if mo else w
            H = sum(use(u) for u in drawers); z = max(x - H, 0)
            w = [v for u in w if 4 <= x for v in kids(u)]; x = z + g(z)
        want = [p + gift(p) for p in lean]
        print("Drain %-7s met_only=%-5s L levels %s\n      Lean pool+gift %s  same: %s ; ways %s" %
              (label, mo, lv, want, lv == want, ways[:3] + ["..."] + ways[8:11]))
# No giving reproduces the pool itself (level := pool) under use 4:
print("Drain with level := pool: needs (x-4)+g(x-4) = x-1 for x=4,3,2,1, i.e. g(0) =",
      [x - 1 for x in (4, 3, 2, 1)], "-> no such giving")

# Commons, overdrawn, nothing coming back. F0 focal founder, F1 focal, W wide. Level := source.
nm = {0: "F0", 1: "F1", 2: "W"}
need = lambda u: {0: 5, 1: 5, 2: 1}[u]; use = lambda u: {0: 2, 1: 2, 2: 1}[u]
kids = lambda u: {0: [1, 1], 1: [1], 2: [2]}[u]
lean_source = [5, 5] + [2 * t + 3 for t in range(6)]
for mo in (False, True):
    c, e = run(need, use, kids, lambda z: 3, [0, 2], 5, steps=7, met_only=mo)
    lv = [x for _, x in c]
    print("Commons.overdrawn met_only=%-5s L source %s  Lean overSource %s same: %s\n      ways %s  net ended: %s" %
          (mo, lv, lean_source, lv == lean_source, [[nm[u] for u in w] for w, _ in c[:5]], e))

# Habitat, overdrawn. One unit A need 2 use 2 kids [A]; source renews by 1.
lean_h = [2] + [t + 1 for t in range(6)]
for mo in (False, True):
    c, e = run(lambda u: 2, lambda u: 2, lambda u: [0], lambda z: 1, [0], 2, steps=6, met_only=mo)
    w, x = c[-1]
    lv = [x for _, x in c]
    # after the net ends the level's own course goes on: extend by hand
    while len(lv) < 7: lv.append(lv[-1] + 1)
    print("Habitat.overdrawn met_only=%-5s L source %s Lean overSource %s same: %s net ended at %s" %
          (mo, lv, lean_h, lv == lean_h, e))

# MultiplyingTakers: A need1 use1 kids[A,A], giving nothing, pool 3.
c, e = run(lambda u: 1, lambda u: 1, lambda u: [0, 0], lambda z: 0, [0], 3)
print("MultiplyingTakers: L sizes/levels %s ended at %s ; Lean: sizes 1,2,4 pool 3,2,0, generation 3 empty" %
      ([(len(w), x) for w, x in c], e))

# --- appended: the pair's orbit past the net's end (the course is the pair's orbit, the net is cut)
def orbit(need, use, kids, giving, w, x, steps, met_only=False):
    lv, ways = [], []
    for n in range(steps):
        lv.append(x); ways.append(list(w))
        drawers = [u for u in w if need(u) <= x] if met_only else w
        H = sum(use(u) for u in drawers); z = max(x - H, 0)
        w = [v for u in w if need(u) <= x for v in kids(u)]; x = z + giving(z)
    return lv, ways
print()
print("== Habitat.overdrawn again, on the pair's orbit (the earlier line extended the level by hand) ==")
for mo in (False, True):
    lv, ways = orbit(lambda u: 2, lambda u: 2, lambda u: [0], lambda z: 1, [0], 2, 7, met_only=mo)
    print("Habitat.overdrawn met_only=%-5s L source %s Lean overSource %s same: %s" % (mo, lv, lean_h, lv == lean_h))

print()
print("== B for one line among others: a family S closed under kids, not entered from outside,")
print("   every unit of S with positive need, kids needing no more, kids together drawing more;")
print("   the other units arbitrary (kids among themselves). Claim tried: S is gone from the way at some step. ==")
random.seed(11)
tried = 0; bad = 0; net_goes = 0
for trial in range(4000):
    hi = random.randint(1, 9)
    g = [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]
    nS = random.randint(1, 3); nO = random.randint(1, 3)
    nd = [random.randint(1, hi + 1) for _ in range(nS)] + [random.randint(0, hi + 1) for _ in range(nO)]
    us = [random.randint(0, 3) for _ in range(nS + nO)]
    ks = []; ok = True
    for u in range(nS):
        cands = [v for v in range(nS) if nd[v] <= nd[u]]; found = None
        for _ in range(30):
            k = [random.choice(cands) for _ in range(random.randint(1, 3))]
            if sum(us[v] for v in k) > us[u]: found = k; break
        if found is None: ok = False; break
        ks.append(found)
    if not ok: continue
    for u in range(nS, nS + nO):
        ks.append([random.randrange(nS, nS + nO) for _ in range(random.randint(0, 2))])
    tried += 1
    w0 = [random.randrange(nS)] + [random.randrange(nS + nO) for _ in range(random.randint(0, 2))]
    x0 = random.randint(0, hi)
    for mo in (False, True):
        w, x = list(w0), x0; gone = None
        for n in range(300):
            if not any(u < nS for u in w): gone = n; break
            drawers = [u for u in w if nd[u] <= x] if mo else w
            H = sum(us[u] for u in drawers); z = max(x - H, 0)
            w = [v for u in w if nd[u] <= x for v in ks[u]]
            if len(w) > 3000: break
            x = z + g[z]
        if gone is None:
            bad += 1; print("  S NOT gone:", hi, g, nS, nd, us, ks, w0, x0, mo)
        elif any(nd[u] <= x for u in w): net_goes += 1
print("  worlds tried: %d ; S not gone: %d ; runs where the net still goes when S is gone: %d" % (tried, bad, net_goes))

print()
print("== a weaker form tried ('fall'): S closed under kids, not entered from outside, all of S needing m,")
print("   kids together drawing NO LESS (<=), giving 0 < m, and at the start S (all met) takes more than")
print("   giving gives at any level. Claim tried: S is gone from the way at some step. ==")
random.seed(23)
tried = 0; bad = 0
for trial in range(6000):
    Z = random.randint(2, 9)
    g = [random.randint(0, 4) for _ in range(Z + 1)]          # giving z = g[min(z, Z)], no bound on the level
    gv = lambda z: g[min(z, Z)]
    nS = random.randint(1, 3); nO = random.randint(0, 2)
    m = random.randint(g[0] + 1, g[0] + 4)
    nd = [m] * nS + [random.randint(0, 9) for _ in range(nO)]
    us = [random.randint(0, 4) for _ in range(nS + nO)]
    ks = []; ok = True
    for u in range(nS):
        found = None
        for _ in range(30):
            k = [random.randrange(nS) for _ in range(random.randint(1, 2))]
            if sum(us[v] for v in k) >= us[u]: found = k; break
        if found is None: ok = False; break
        ks.append(found)
    if not ok: continue
    for u in range(nS, nS + nO):
        ks.append([random.randrange(nS, nS + nO) for _ in range(random.randint(0, 1))])   # others do not multiply: keeps the way small (the first run's 4 'not gone' were the 3000-unit cap, others doubling)
    w0 = [random.randrange(nS) for _ in range(random.randint(1, 3))] + \
         ([random.randrange(nS, nS + nO) for _ in range(random.randint(0, 2))] if nO else [])
    x0 = random.randint(m, 30)
    if not sum(us[u] for u in w0 if u < nS) > max(g): continue
    tried += 1
    for mo in (False, True):
        w, x = list(w0), x0; gone = None
        for n in range(200):
            if not any(u < nS for u in w): gone = n; break
            drawers = [u for u in w if nd[u] <= x] if mo else w
            H = sum(us[u] for u in drawers); z = max(x - H, 0)
            w = [v for u in w if nd[u] <= x for v in ks[u]]
            if len(w) > 3000: print('  cap hit'); break
            x = z + gv(z)
        if gone is None:
            bad += 1
            if bad <= 3: print("  S NOT gone:", g, m, nS, nd, us, ks, w0, x0, mo)
print("  worlds tried: %d ; S not gone: %d" % (tried, bad))
print("  built examples under it: Drain (m=4 on pool+gift, d1,d1 take 4 > 3, giving 0 = 0 or 3 < 4);")
print("  Commons focal (m=5, F1,F1 take 4 > 3, giving 0 = 3 < 5); Habitat (m=2, take 2 > 1, giving 0 = 1 < 2);")
print("  MultiplyingTakers (m=1, take >= 1 > 0).")
