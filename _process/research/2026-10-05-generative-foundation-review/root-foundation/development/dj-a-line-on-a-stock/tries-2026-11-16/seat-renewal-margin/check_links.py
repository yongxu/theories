#!/usr/bin/env python3
"""AI-written (round 11, seat renewal-margin), 16 November 2026.
Searches over small instances. A search is not a proof; it can only refute.

link 1: loss-of-renewal-for-good  x  unceasing-generation-needs-renewal
link 2: margin-of-a-regime        x  never-leaving-a-guard
link 3: margin-of-a-regime        x  threshold-in-the-state-plane
"""
import itertools, random

# ---------------------------------------------------------------- link 1
def link1():
    print("== link 1 ==")
    # (a) countermodel to the bare sentence "below the renewers' need for good,
    #     arising that depends on the condition is not unceasing".
    #     One condition, level 3 at every step. m = 5.
    #     renewer: requires c, need 5, gives 2 while active; active iff level >= 5 (never).
    #     flicker: requires c, need 1 (<m), active at odd steps, takes 0, gives 0.
    m, level = 5, 3
    T = 200
    arises = 0
    for t in range(T):
        renewer_active = level >= 5
        given = 2 if renewer_active else 0
        taken = 0
        assert level + taken == level + given          # Balances
        assert not (given > 0 and not renewer_active)   # Acting
        fl_t, fl_t1 = (t % 2 == 1), ((t + 1) % 2 == 1)
        assert (not fl_t) or 1 <= level                 # Dependent (flicker supported when active)
        assert level < m                                # below for good
        if (not fl_t) and fl_t1:
            arises += 1
    print(f"(a) flicker of need 1 < m=5 on a level held at 3: arisings in {T} steps = {arises}; "
          f"every premise of Flow.stays_below holds; arising that takes = 0")

    # (b) search for a refutation of the composed law:
    #     gated + balanced + acting + dependent, level < m at T  ==>
    #       given = 0 from T on, level never rises from T on,
    #       steps with positive uptake after T  <= level T,
    #       arisings-that-take after T          <= level T.
    rng = random.Random(20261116)
    worst_plain_arisings = 0
    runs = bad = crossed = 0
    for _ in range(4000):
        m = rng.randint(1, 5)
        n = rng.randint(1, 4)
        forms = []
        for _f in range(n):
            giver = rng.random() < 0.5
            need = rng.randint(m, m + 2) if giver else rng.randint(0, m + 1)
            requires = True if giver else rng.random() < 0.7
            forms.append(dict(giver=giver, need=need, requires=requires,
                              give=rng.randint(1, 3) if giver else 0,
                              take=rng.randint(0, 3),
                              period=rng.randint(1, 3), phase=rng.randint(0, 2)))
        level = rng.randint(0, 8)
        hist_active, hist_take, hist_level, hist_given = [], [], [], []
        for t in range(60):
            act = []
            for f in forms:
                supported = (not f['requires']) or f['need'] <= level
                own = ((t + f['phase']) % f['period'] == 0) or f['period'] == 1
                act.append(supported and own)          # Dependent: active -> supported
            given = sum(f['give'] for f, a in zip(forms, act) if a)   # Acting: only active give
            avail = level + given
            takes = []
            for f, a in zip(forms, act):
                tk = min(f['take'], avail) if a else 0
                avail -= tk
                takes.append(tk)
            hist_active.append(act); hist_take.append(takes)
            hist_level.append(level); hist_given.append(given)
            level = level + given - sum(takes)          # Balances
        runs += 1
        Ts = [t for t, l in enumerate(hist_level) if l < m]
        if not Ts:
            continue
        crossed += 1
        T0 = Ts[0]
        ok = all(hist_given[t] == 0 for t in range(T0, 60))
        ok &= all(hist_level[t + 1] <= hist_level[t] for t in range(T0, 59))
        uptake_steps = sum(1 for t in range(T0, 60) if sum(hist_take[t]) > 0)
        ok &= uptake_steps <= hist_level[T0]
        arises_taking = arises_plain = 0
        for t in range(T0, 59):
            for i in range(n):
                if (not hist_active[t][i]) and hist_active[t + 1][i]:
                    arises_plain += 1
                    if hist_take[t + 1][i] > 0:
                        arises_taking += 1
        ok &= arises_taking <= hist_level[T0]
        worst_plain_arisings = max(worst_plain_arisings, arises_plain)
        if not ok:
            bad += 1
    print(f"(b) {runs} random gated flows, {crossed} fall below m: refutations of "
          f"'given 0, level never rises, uptake steps <= level, arisings-that-take <= level' = {bad}")
    print(f"    most plain arisings (taking or not) after the crossing in one run of 60 steps: "
          f"{worst_plain_arisings}  (plain arising is not bounded by the level)")

# ---------------------------------------------------------------- regime
def step(g, H, x):
    e = max(x - H, 0)
    return e + g[e]

def premises(g, H, y, hi):
    if not (0 < H + y): return False
    if g[0] != 0: return False                                   # FromNothing
    if any(g[z] >= H for z in range(0, min(y, hi + 1))): return False   # Short
    if any(g[z] < H for z in range(y, hi + 1) if z + H <= hi): return False  # Meets
    if any(step(g, H, x) > hi for x in range(hi + 1)): return False     # Keeps
    return True

def orbit(g, H, x, n):
    out = [x]
    for _ in range(n):
        x = step(g, H, x); out.append(x)
    return out

def leading(b, k):
    r = 0
    for i in range(k):
        if r == i and b(i): r = i + 1
    return r

def links23():
    cases = nonmono = 0
    kernel_bad = below_not_closed = basin_bad = need_bad = need_cases = 0
    thr_bad_reach = thr_bad_noreach = thr_cases_reach = thr_nonmono_ok = 0
    oscillates_above = 0
    ends_not_downclosed = 0
    step_not_mono_example = None
    rests_ne_ends = 0
    for hi in range(1, 5):
        for g in itertools.product(range(0, 5), repeat=hi + 1):
            for H in range(0, 4):
                for y in range(0, hi + 2):
                    if not premises(g, H, y, hi):
                        continue
                    cases += 1
                    mono = all(g[a] <= g[a + 1] for a in range(hi))
                    nonmono += (not mono)
                    N = 3 * hi + 3
                    orbs = {x: orbit(g, H, x, N + hi + 2) for x in range(hi + 1)}
                    # link 2: kernel of the guard 0 < z <= hi
                    kernel = {x for x in range(hi + 1) if all(0 < z <= hi for z in orbs[x])}
                    want = {x for x in range(hi + 1) if H + y <= x}
                    kernel_bad += (kernel != want)
                    below_not_closed += any(step(g, H, x) >= H + y for x in range(min(H + y, hi + 1)))
                    basin_bad += any(orbs[x][x] != 0 for x in range(min(H + y, hi + 1)))
                    # guard "the need is met": m <= z <= hi, giving gated at m>0, H>0
                    for mm in range(1, hi + 1):
                        if H > 0 and all(g[z] == 0 for z in range(mm)):
                            need_cases += 1
                            k2 = {x for x in range(hi + 1) if all(mm <= z <= hi for z in orbs[x])}
                            need_bad += (k2 != want)
                    # link 3
                    ends = {x for x in range(hi + 1) if 0 in orbs[x]}
                    if any((b in ends) and (a not in ends) for b in range(hi + 1) for a in range(b)):
                        ends_not_downclosed += 1
                    still_below = set()
                    for x in range(hi + 1):
                        o = orbs[x]
                        # rests below the draw: still from some N' and level < H there
                        for n0 in range(N + 1):
                            if all(o[k] == o[n0] for k in range(n0, len(o))) and o[n0] < H:
                                still_below.add(x); break
                    rests_ne_ends += (still_below != ends)
                    falling = lambda x: orbs[x][N] < H
                    thr = leading(falling, hi + 1)
                    if H + y <= hi + 1:
                        thr_cases_reach += 1
                        if thr != H + y: thr_bad_reach += 1
                        elif not mono: thr_nonmono_ok += 1
                    else:
                        if thr != H + y: thr_bad_noreach += 1
                    if any(len(set(orbs[x][N:])) > 1 for x in want):
                        oscillates_above += 1
                    if step_not_mono_example is None and not mono:
                        st = [step(g, H, x) for x in range(hi + 1)]
                        if any(st[a] > st[a + 1] for a in range(hi)) and want and (hi + 1 - len(want)) > 0:
                            step_not_mono_example = (g, H, y, hi, st)
    print("== link 2 ==")
    print(f"parameter sets meeting pos, Short, FromNothing, Meets, Keeps (hi<=4, g<=4, H<=3): {cases}")
    print(f"kernel of '0 < z <= hi' differs from [H+y, hi]: {kernel_bad}")
    print(f"some level below H+y steps to H+y or above (complement not closed): {below_not_closed}")
    print(f"some level x below H+y is not at 0 after x steps: {basin_bad}")
    print(f"guard 'm <= z <= hi' (giving gated at m>0, H>0): {need_cases} cases, kernel differs from [H+y, hi]: {need_bad}")
    print("== link 3 ==")
    print(f"giving not rising with what is left among them: {nonmono}")
    print(f"'ends' not closed downward up to hi: {ends_not_downclosed}")
    print(f"'rests below the draw' differs from 'ends' on levels up to hi: {rests_ne_ends}")
    print(f"with H+y <= hi+1 ({thr_cases_reach} cases): leading-threshold at step 3hi+3 differs from H+y: {thr_bad_reach}; "
          f"equal with giving NOT rising: {thr_nonmono_ok}")
    print(f"with H+y > hi+1: leading-threshold differs from H+y: {thr_bad_noreach} (reach is needed)")
    print(f"runs from [H+y, hi] that never come to rest (giving not rising): {oscillates_above}")
    print(f"an instance meeting ends_iff_below's premises whose step does not keep the order of levels "
          f"(g, H, y, hi, step table): {step_not_mono_example}")

if __name__ == "__main__":
    link1()
    links23()
