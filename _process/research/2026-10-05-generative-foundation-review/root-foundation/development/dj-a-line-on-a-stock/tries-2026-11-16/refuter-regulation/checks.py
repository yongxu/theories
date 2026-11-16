# AI-written (Fable, refuter), 16 November 2026. Searches, not proofs. Runs in seconds.
# 1. Link 1 as the seat wrote it, with the start's step count left free: a countermodel.
# 2. Link 1 with the count at 0: a small exhaustive search for a counterexample.
# 3. Link 3 (cut_ends): the bound level + span, every small start, ages of any value.
# 4. Link 2: Between hi x (step g H x) is `holds` at one step; count how often Opposes fails.
import itertools, sys

def step(g, H, x):            # RegimeMargin.step
    left = max(x - H, 0)
    return left + g(left)

# ---- 1. free step count -------------------------------------------------
giving = lambda z: min(z, max(12 - z, 0))          # Three.giving
use = lambda rule: 5 if rule else 3                # Three.use
H2, y2, need = 3, 3, 1
assert all(giving(z) < H2 for z in range(y2)) and giving(0) == 0
def window_course(count0, reads, N, K, x, steps, window=True):
    rule, c, out = True, count0, [x]
    for _ in range(steps):
        nxt = step(giving, use(rule), x)
        if reads(c):
            if window and N <= x < K:
                rule = False            # hL: the window reads the rule false off the level
            else:
                rule = True             # hA: read off the share (3 <= share), true
        x, c = nxt, c + 1
        out.append(x)
    return out
reads = lambda u: u >= 5
r = 5
asitwas = window_course(5, reads, 0, 13, 9, 40, window=False)
actual  = window_course(5, reads, 0, 13, 9, 40, window=True)
print("1. start count 5, reads u = (u >= 5), r = 5: no reading step before r.")
print("   as it was:", asitwas[:8], " level at r+1 =", asitwas[r+1], "< H2+y2 =", H2+y2)
print("   actual   :", actual[:8], " min over 40 steps =", min(actual), " (need 1 met throughout:", min(actual) >= need, ")")

# ---- 2. count at 0 ------------------------------------------------------
bad = 0; tried = 0
TOP = 6
for gv in itertools.product(range(0, 4), repeat=TOP + 1):
    if gv[0] != 0: continue
    g = lambda z, gv=gv: gv[z] if z <= TOP else 0
    for H2 in range(1, 4):
        ys = [y for y in range(0, TOP + 1) if all(g(z) < H2 for z in range(y))]
        y2 = max(ys)
        for uhi in range(H2, 5):                       # use of the way as it was; least use H2
            for (N, K) in [(0, TOP + 4), (2, 5), (4, 9)]:
                for r in range(0, 4):
                    rd = lambda u, r=r: u >= r
                    for x0 in range(1, TOP + 3):
                        def run(window):
                            rule, x, out = True, x0, [x0]
                            for c in range(30):
                                nxt = step(g, uhi if rule else H2, x)
                                if rd(c):
                                    rule = not (window and N <= x < K)
                                x = nxt; out.append(x)
                            return out
                        a = run(False)
                        if a[r + 1] < H2 + y2:
                            tried += 1
                            w = run(True)
                            if min(w) >= 1:            # need 1 met for 30 steps: goes on
                                # confirm it is periodic / held, not merely slow
                                bad += 1
print("2. count 0: premises met in", tried, "cases; lines that go on:", bad)

# ---- 3. cut_ends --------------------------------------------------------
def older(s, ages): return [a + 1 for a in ages if a + 1 < s]
def cut_step(span, count, level, ages):
    l = max(level - 1, 0)
    ages = older(span, ages)
    if len(ages) < count and l > 0:
        l, ages = l - 1, [0] + ages
    return l, ages
worst = 0; fails = 0; n = 0
for span in range(1, 5):
    for count in range(0, 4):
        for level in range(0, 11):
            for k in range(0, 4):
                for ages in itertools.product(range(0, span + 2), repeat=k):
                    l, a = level, list(ages)
                    for _ in range(level + span):
                        l, a = cut_step(span, count, l, a)
                    n += 1
                    if a: fails += 1
print("3. cut_ends: starts", n, " not gone after level + span steps:", fails)

# ---- 4. link 2 ----------------------------------------------------------
tot = held = notopp = allfixed = 0
for gv in itertools.product(range(0, 4), repeat=6):
    g = lambda z, gv=gv: gv[z] if z < 6 else 0
    for H in range(0, 4):
        for hi in range(0, 6):
            if not all(step(g, H, x) <= hi for x in range(hi + 1)): continue
            for y in range(0, 6):
                if H + y > hi: continue
                if not all(g(z) >= H for z in range(y, 6) if z + H <= hi): continue
                tot += 1
                for x in range(H + y, hi + 1):
                    nx = step(g, H, x)
                    assert x <= nx <= hi          # this is `holds` at one step, and Between hi x nx
                    held += 1
                    if x < hi and nx == x: notopp += 1
                assert step(g, H, hi) == hi
print("4. holding regimes", tot, " held levels", held, " below the top and not moved (Opposes fails):", notopp)
