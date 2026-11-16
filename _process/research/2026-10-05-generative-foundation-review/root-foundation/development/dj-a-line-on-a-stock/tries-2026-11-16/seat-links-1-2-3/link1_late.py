# AI-written (Fable, seat links 1-3), 16 November 2026. A search, not a proof.
# Link 1: "a rule reading l steps late keeps no band narrower than 2 (l + 1) d" (Regulation)
# against "the first reading comes before the point of no return" (TurningInTime).
# The pair, in Three's shape: the way is 'as it was' (use H1) until a step at a marked level, then
# of the kept kind (use H2) for good; the level steps by RegimeMargin.step giving (use w).
# Marks: every level below mu. A delay `late` is added by hand (the pair in the Lean has none: its
# way after a marked step is of the kept kind at once, so the kept use first applies one step on).
import random

def sub(a, b): return a - b if a >= b else 0
def step(g, H, x): return sub(x, H) + g[sub(x, H)]
def short(g, H, y): return all(g[z] < H for z in range(y))
def meets(g, H, y, hi): return all(H <= g[z] for z in range(y, hi + 1) if z + H <= hi)
def keeps(g, H, hi): return all(step(g, H, x) <= hi for x in range(hi + 1))

def as_it_was(g, H1, x, n):
    xs = [x]
    for _ in range(n): xs.append(step(g, H1, xs[-1]))
    return xs

def pair_unending(g, H1, H2, mu, late, need, x, hi):
    # way: None = as it was; k >= 0 = pending k more steps under H1; 'kept'
    w, seen = None, set()
    for _ in range(4 * (hi + 2) * (late + 3)):
        if x < need: return False
        if (w, x) in seen: return True
        seen.add((w, x))
        use = H2 if w == 'kept' else H1
        nx = step(g, use, x)
        if w is None: w = (late - 1 if late > 0 else 'kept') if x < mu else None
        elif w != 'kept': w = w - 1 if w > 0 else 'kept'
        x = nx
    return True

random.seed(11)
tried = suff_fail = exact_fail = suff_used = exact_used = 0
tight = None
for _ in range(150000):
    hi = random.randint(4, 18)
    g = [0] + [random.randint(0, 5) for _ in range(hi)]
    H2 = random.randint(1, 3); H1 = H2 + random.randint(1, 3)
    ys2 = [y for y in range(hi + 1) if short(g, H2, y) and meets(g, H2, y, hi) and H2 + y <= hi]
    ys1 = [y for y in range(hi + 2) if short(g, H1, y)]
    if not ys2 or not keeps(g, H2, hi): continue
    y2 = ys2[0]; y1 = max(ys1)
    need = random.randint(1, H2 + y2)
    x = random.randint(1, hi)
    if not x < H1 + y1: continue
    late = random.randint(0, 2)
    xs = as_it_was(g, H1, x, x + late + 3)
    d = max(a - b for a, b in zip(xs, xs[1:]))            # the course as it was falls by at most d a step
    mu = random.randint(1, hi + 1)
    tried += 1
    un = pair_unending(g, H1, H2, mu, late, need, x, hi)
    # exact, on the course as it was: T the first marked step; the kept use first applies at T + 1 + late
    T = next((t for t, v in enumerate(xs) if v < mu), None)
    if T is not None and T + 1 + late < len(xs):
        N = next(t for t, v in enumerate(xs) if v < H2 + y2)   # the point of no return, a step
        exact = all(v >= need for v in xs[:T + 1 + late]) and T + 1 + late < N
        exact_used += 1
        if exact != un: exact_fail += 1
    # sufficient, in levels: the start not marked and the mark (late + 2) d above the point
    if x >= mu and H2 + y2 + (late + 2) * d <= mu:
        suff_used += 1
        if not un: suff_fail += 1
    if x >= mu and H2 + y2 + (late + 2) * d == mu + 1 and not un and tight is None:
        tight = (g, H1, H2, y2, mu, late, d, x, xs[:8])
print("regimes tried:", tried, " exact law checked on:", exact_used, " margin premise met on:", suff_used)
print("'never ends iff T + 1 + late < N' fails:", exact_fail)
print("mark at least (late + 2) d above H2 + y2, start not marked, yet the line ends:", suff_fail)
print("one unit short of that margin and the line ends (the bound is met):", tight)

# A second family, with small falls: giving min(G + noise, hi - z) from one unit left, nothing from nothing.
random.seed(12)
tried = suff_used = suff_fail = exact_used = exact_fail = 0
tight = None
for _ in range(40000):
    hi = random.randint(12, 36)
    H2 = random.randint(1, 3); H1 = H2 + random.randint(1, 4)
    G = random.randint(H2, H1 - 1)
    g = [0] + [min(max(H2, G + random.choice((0, 0, 0, -1, 1))), hi - z) for z in range(1, hi + 1)]
    g = [min(v, H1 - 1) if z else 0 for z, v in enumerate(g)]
    ys2 = [y for y in range(hi + 1) if short(g, H2, y) and meets(g, H2, y, hi) and H2 + y <= hi]
    if not ys2 or not keeps(g, H2, hi) or not short(g, H1, hi + 1): continue
    y2 = ys2[0]
    need = random.randint(1, H2 + y2); x = random.randint(1, hi); late = random.randint(0, 3)
    mu = random.randint(1, hi + 1)
    xs = as_it_was(g, H1, x, x + late + 3)
    T = next((t for t, v in enumerate(xs) if v < mu), None)
    if T is None or T + 1 + late >= len(xs): continue
    d = max(a - b for a, b in zip(xs[:T + late + 1], xs[1:T + late + 2]))   # falls up to the step before the kept use applies
    tried += 1
    un = pair_unending(g, H1, H2, mu, late, need, x, hi)
    N = next(t for t, v in enumerate(xs) if v < H2 + y2)
    exact = all(v >= need for v in xs[:T + 1 + late]) and T + 1 + late < N
    exact_used += 1; exact_fail += (exact != un)
    if x >= mu and H2 + y2 + (late + 2) * d <= mu:
        suff_used += 1; suff_fail += (not un)
    if x >= mu and H2 + y2 + (late + 2) * d == mu + 1 and not un and tight is None:
        tight = dict(giving=g, H1=H1, H2=H2, y2=y2, mark_below=mu, late=late, d=d, start=x, as_it_was=xs[:T + late + 3], T=T, N=N)
print("second family tried:", tried, " exact law checked on:", exact_used, " margin premise met on:", suff_used)
print("'never ends iff T + 1 + late < N' fails:", exact_fail)
print("margin (late + 2) d met, start not marked, yet the line ends:", suff_fail)
print("one unit short of the margin and the line ends:", tight)

# A third check, the schedule's half (Pace's reads): a window [lo, hi_w) that reads nothing before
# step r and at every step from r; the rule read in the window is the kept one (use H2), read off
# the share outside it (use H1 again: the lock's own rule). Claim: if the level of the course as it
# was at r + 1 is below H2 + y2 (the point of no return N <= r + 1), the line ends.
def sched_unending(g, H1, H2, lo, hw, r, need, x, hi):
    kept, seen, t = False, set(), 0
    for _ in range(6 * (hi + 2) + 4 * r + 20):
        if x < need: return False
        key = (kept, x, min(t, r))
        if t >= r and key in seen: return True
        seen.add(key)
        nx = step(g, H2 if kept else H1, x)
        if t >= r: kept = (lo <= x < hw)       # read through the window; outside it, off the share
        x = nx; t += 1
    return True
random.seed(13)
tried = nec_used = nec_fail = conv_fail = conv_used = 0
for _ in range(40000):
    hi = random.randint(12, 30)
    H2 = random.randint(1, 3); H1 = H2 + random.randint(1, 4)
    G = random.randint(H2, H1 - 1)
    g = [0] + [min(max(H2, G + random.choice((0, 0, 0, -1, 1))), hi - z) for z in range(1, hi + 1)]
    g = [min(v, H1 - 1) if z else 0 for z, v in enumerate(g)]
    ys2 = [y for y in range(hi + 1) if short(g, H2, y) and meets(g, H2, y, hi) and H2 + y <= hi]
    if not ys2 or not keeps(g, H2, hi) or not short(g, H1, hi + 1): continue
    y2 = ys2[0]
    need = random.randint(1, H2 + y2); x = random.randint(1, hi); r = random.randint(0, 8)
    lo = random.randint(0, hi); hw = random.randint(lo, hi + 2)
    xs = as_it_was(g, H1, x, r + 2)
    tried += 1
    un = sched_unending(g, H1, H2, lo, hw, r, need, x, hi)
    if xs[r + 1] < H2 + y2:
        nec_used += 1; nec_fail += un
print("schedule: tried", tried, "; level as it was at r + 1 below H2 + y2 on", nec_used, "; of these the line goes on:", nec_fail)
