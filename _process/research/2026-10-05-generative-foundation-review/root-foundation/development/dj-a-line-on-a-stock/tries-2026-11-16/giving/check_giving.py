# AI-written (Fable, seat "giving", round 11), 16 November 2026. A transcription for search; searches are not proofs.
# Transcribes: RegimeMargin.step (:249), RelationalRenewal.Law.level (deeper :246), LineOnAStock.after/left (:137-148),
# Coupled.step for Relay (:3524), and three orders of a step with members that give.
import itertools, sys

def sub(a, b): return a - b if a >= b else 0          # Nat subtraction

def rm_step(g, H, x):                                 # RegimeMargin.step
    z = sub(x, H); return z + g(z)

def rm_run(g, H, x, n):
    out = [x]
    for _ in range(n): x = rm_step(g, H, x); out.append(x)
    return out

def law_levels(start, renew, needG, needF, draw, contrib, n):   # RelationalRenewal.Law.level
    l = start; out = [l]
    for t in range(n):
        if needG <= l:
            l = sub(l + renew + contrib(t), draw(t)) if needF <= l else l + renew
        else:
            l = sub(l + contrib(t), draw(t)) if needF <= l else l
        out.append(l)
    return out

const = lambda c: (lambda t: c)

# --- 0. the transcription against values the Lean states -------------------------------------
assert law_levels(3, 2, 1, 1, lambda t: t, const(0), 3)[3] == 6            # escalation_consumes: level 3 = 6
assert law_levels(2, 1, 2, 1, lambda t: 2 if t == 0 else 0, lambda t: 0 if t == 0 else 1, 2) == [2, 1, 2]   # pulse_levels
assert law_levels(2, 1, 2, 1, lambda t: 3 if t == 0 else 0, lambda t: 0 if t == 0 else 1, 1) == [2, 0]
assert all(v == 2 for v in law_levels(2, 1, 1, 1, const(2), const(1), 30))                                    # cultivation
hump = lambda z: min(z, sub(12, z))                                                                        # Three.giving
def line_course(need, use, kids, giving, w, x, n):                                                         # LineOnAStock.course
    out = [(list(w), x)]
    for _ in range(n):
        w2 = [k for u in w if need[u] <= x for k in kids[u]]
        x = rm_step(giving, sum(use[u] for u in w), x); w = w2; out.append((list(w), x))
    return out
need = dict(A=1, B=3, C=12); use = dict(A=3, B=1, C=1); kids = dict(A=['B', 'B'], B=['C', 'B'], C=['A'])
assert [x for _, x in line_course(need, use, kids, hump, ['A'], 6, 3)] == [6, 6, 8, 8]                     # from_six
assert [x for _, x in line_course(need, use, kids, hump, ['A'], 7, 5)] == [7, 8, 12, 12, 4, 0]             # from_seven
print("0. transcription agrees with escalation, the pulses, cultivation, from_six, from_seven")

# --- (b) a rising giving with nothing from nothing as a sum of gated givers ----------------------
N, V = 6, 4
count = 0
for incs in itertools.product(range(V + 1), repeat=N):       # every rising g on 0..N with g 0 = 0, increments <= V
    g = [0]
    for d in incs: g.append(g[-1] + d)
    members = [(m, g[m] - g[m - 1]) for m in range(1, N + 1)]   # a member of need m gives g m - g (m-1)
    for z in range(N + 1):
        assert sum(gv for m, gv in members if m <= z) == g[z]
    count += 1
print(f"(b) telescoping: {count} rising givings on 0..{N} (increments <= {V}) are each the sum of their gated givers, gates read on what is left")
incs = [hump(m) - hump(m - 1) for m in range(1, 14)]
print("(b) hump min z (12-z): increments at needs 1..13 =", incs, "-> six givers (needs 1..6) and six takers (needs 7..12)")

# three orders of a step with members; kinds = list of (need, take, give); g = the stock's own giving
def step_left(g, kinds, x):      # RM's order: all take first (standing), gates of giving read on what is left
    z = sub(x, sum(k[1] for k in kinds)); return z + g(z) + sum(k[2] for k in kinds if k[0] <= z)
def step_mixed(g, kinds, x):     # the brief's formula read literally: all take first, giving gated on the level before the take
    z = sub(x, sum(k[1] for k in kinds)); return z + g(z) + sum(k[2] for k in kinds if k[0] <= x)
def step_law(g, kinds, x):       # Law's order: gates of take and give read on the level, give, take, one truncation
    return sub(x + g(x) + sum(k[2] for k in kinds if k[0] <= x), sum(k[1] for k in kinds if k[0] <= x))
def run(step, x, n=400, cap=10**6):
    out = [x]
    for _ in range(n):
        x = step(x); out.append(x)
        if x > cap: break
    return out
zero = lambda z: 0

# order matters: a take beyond all giving
kinds = [(0, 5, 0), (1, 0, 4)]           # a taker needing nothing takes 5; a giver needing 1 gives 4
print("(b/c) taker 5, giver (need 1, give 4), g = 0, from 4:",
      "left-order", run(lambda x: step_left(zero, kinds, x), 4, 6),
      "| mixed", run(lambda x: step_mixed(zero, kinds, x), 4, 6),
      "| Law-order", run(lambda x: step_law(zero, kinds, x), 4, 6))

# --- (c) the phase lemma: Law with an independent standing draw is RM.step read after the take ---
bad = 0; tried = 0
for start in range(0, 9):
    for renew in range(0, 4):
        for needG in range(0, 6):
            for d in range(0, 5):
                for c in range(0, d + 1):
                    H = d - c
                    g = lambda z, r=renew, m=needG: r if m <= z else 0
                    a = law_levels(start, renew, needG, 0, const(d), const(c), 25)
                    b = [sub(v, H) for v in rm_run(g, H, start + H, 25)]
                    tried += 1
                    if a != b: bad += 1
print(f"(c) phase lemma  Law.level t = (run of RM.step g H from start+H) t - H,  g z = renew if needG <= z else 0, H = draw - contrib: {tried} laws, {bad} disagree")

# where Law and the take-first steps part (same phase, no shift)
print("(c) start 2, renew 1, needG 2, needF 0, draw 1 (within renewal): Law", law_levels(2, 1, 2, 0, const(1), const(0), 5),
      "| RM.step same g, same start", rm_run(lambda z: 1 if 2 <= z else 0, 1, 2, 5))
print("(c) start 1, renew 1, needG 1, needF 0, draw 3 (overdraw): Law", law_levels(1, 1, 1, 0, const(3), const(0), 4),
      "| mixed order", run(lambda x: step_mixed(zero, [(0, 3, 0), (1, 0, 1)], x), 1, 4))
# permanence: Law's kinds come back when the level returns; LineOnAStock's unmet unit leaves nothing
print("(c) pulse 2 (Law): levels", law_levels(2, 1, 2, 1, lambda t: 2 if t == 0 else 0, lambda t: 0 if t == 0 else 1, 6),
      "- the renewer (need 2) is unmet at step 1 and gives again from step 2")

# Law's exact threshold through the phase lemma: renew >= H > 0, needG >= 1: never below start iff start >= needG
ok = True
for renew in range(1, 4):
    for H in range(1, renew + 1):
        for needG in range(1, 6):
            for start in range(0, 10):
                lv = law_levels(start, renew, needG, 0, const(H), const(0), 60)
                ends = lv[-1] == 0
                if ends != (start < needG): ok = False
print("(c) Law, standing draw 0 < H <= renew, independent taker: level ends at 0 iff start < needG (searched 30 laws x 10 starts; the first run's label said 90 by mistake):", ok)

# --- (d) the boundary for a standing way that takes and gives --------------------------------------
def root(G, T, top):                      # least z with T <= G z, or None
    for z in range(top + 1):
        if T <= G(z): return z
    return None
import random
random.seed(11)
tested = 0; viol = 0
for _ in range(4000):
    kinds = [(random.randint(1, 5), random.randint(0, 2), random.randint(0, 3)) for _ in range(random.randint(1, 3))]
    T = sum(k[1] for k in kinds)
    if T == 0: continue
    Gam = lambda z, kinds=kinds: sum(k[2] for k in kinds if k[0] <= z)
    y = root(Gam, T, 6)
    for x in range(0, 16):
        tr = run(lambda v: step_left(zero, kinds, v), x, 80, cap=500)
        ends = tr[-1] == 0
        want = True if y is None else (x < T + y)
        tested += 1
        if ends != want: viol += 1
print(f"(d) left-order, g = 0, standing takes, gated givers: ends iff start < T + (least z with total give of needs <= z covering T): {tested} starts, {viol} violations")

# Law-order with gated takers: is the set of starts that never end an up-set?
fams = 0; notup = 0; ex = None
for kinds in itertools.product([(n, t, gv) for n in (1, 2, 3, 4) for t in (0, 1, 2) for gv in (0, 1, 2)], repeat=2):
    fams += 1
    fate = []
    for x in range(0, 12):
        tr = run(lambda v: step_law(zero, list(kinds), v), x, 60, cap=300)
        fate.append(tr[-1] > 0 and not (tr[-1] == tr[-2] and all(k[0] > tr[-1] for k in kinds)))  # goes on: some need met at rest
    if any(fate[i] and not fate[j] for i in range(12) for j in range(i + 1, 12)):
        notup += 1
        if ex is None: ex = (kinds, fate)
print(f"(d) Law-order, two gated kinds, g = 0: {fams} pairs; in {notup} a higher start stops with every need unmet while a lower one goes on", ex)
# all gated members net givers plus one standing taker: threshold at the root, in Law's phase
tested = 0; viol = 0
for _ in range(3000):
    kinds = [(random.randint(1, 5), t, t + random.randint(0, 2)) for t in [random.randint(0, 2) for _ in range(random.randint(1, 3))]]
    H = random.randint(1, 4)
    Nn = lambda z, kinds=kinds: sum(k[2] - k[1] for k in kinds if k[0] <= z)
    y = root(Nn, H, 6)
    for x in range(0, 14):
        tr = run(lambda v: step_law(zero, kinds + [(0, H, 0)], v), x, 80, cap=500)
        ends = tr[-1] == 0
        want = True if y is None else (x < y)
        tested += 1
        if ends != want: viol += 1
print(f"(d) Law-order, gated members each giving at least their take, one standing taker H: ends iff start < least z with net giving >= H: {tested} starts, {viol} violations")

# a member that takes h (standing) and gives gamma at need m: does it lower the boundary?  (left-order, level before the take)
lower = higher = same = 0
for base in itertools.product(range(0, 3), repeat=4):          # base givers at needs 1..4
    baseK = [(m + 1, 0, base[m]) for m in range(4)]
    for T in (1, 2, 3):
        y0 = root(lambda z: sum(k[2] for k in baseK if k[0] <= z), T, 8)
        if y0 is None: continue
        for h in (1, 2):
            for gam in (h, h + 1):
                for m in (1, 2, 3, 4):
                    K = baseK + [(m, h, gam)]
                    y1 = root(lambda z: sum(k[2] for k in K if k[0] <= z), T + h, 8)
                    b0, b1 = T + y0, (None if y1 is None else T + h + y1)
                    if b1 is None or b1 > b0: higher += 1
                    elif b1 < b0: lower += 1
                    else: same += 1
print(f"(d) adding a member that takes h and gives at least h back (gated): boundary in the level lower {lower}, same {same}, higher or lost {higher}")

# --- (e) smallest worked cases -------------------------------------------------------------------
for name, st in (("left-order", step_left), ("mixed", step_mixed)):
    for m in (1, 6, 7):
        K = [(0, 7, 0), (m, 0, 1)]
        goes = [x for x in range(0, 41) if run(lambda v: st(hump, K, v), x, 120)[-1] > 0]
        rest = sorted(set(run(lambda v: st(hump, K, v), x, 120)[-1] for x in goes))
        print(f"(e) hump, standing take 7, one giver (need {m}, give 1), {name}: starts 0..40 that never end: "
              f"{(goes[0], goes[-1]) if goes else None} n={len(goes)}; they rest at {rest}")
print("(e) hump, standing take 7, no giver: starts 0..40 that never end:",
      [x for x in range(41) if rm_run(hump, 7, x, 120)[-1] > 0])
print("(e) hump, standing take 6, no giver (the most the stock gives):",
      [x for x in range(41) if rm_run(hump, 6, x, 120)[-1] > 0])

# Relay: which giver is met at each state of the cycle
first = lambda a, b: 2 if (1 <= a and 2 <= b) else 0
second = lambda a, b: 2 if (2 <= a and 1 <= b) else 0
s = (2, 3); tr = []
for _ in range(4):
    a, b = sub(s[0], 1), sub(s[1], 1)
    tr.append((s, first(a, b) > 0, second(a, b) > 0)); s = (a + first(a, b), b + second(a, b))
print("(e) Relay from (2,3): (state, first gives, second gives) =", tr)

# two stocks: a rising giving that is not a sum of members with needs on both
gor = lambda a, b: min(1, a + b)
d11 = gor(1, 1) - gor(1, 0) - gor(0, 1) + gor(0, 0)
print("(b, two stocks) g(a,b) = min 1 (a+b) rises in both and gives nothing from nothing; the member of need (1,1) would give", d11)
