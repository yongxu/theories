# AI-written (Fable, seat 2 of round 11), 16 November 2026.
# Checks behind the statements of seat 2. A search by script is not a proof.
import sys, os, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from model import make_world, step, goes, never_ends, course, classify, multisets
from b_general import givings, step_rising, two_kinds


def N(W, c, hi):
    memo = {}
    return [x for x in range(hi + 1) if never_ends(W, c, x, memo)]


print("1. Two units that each leave themselves (WayOfUnits), all needs met at the start")
hi = 12
tent = [min(z, hi - z) for z in range(hi + 1)]
W = make_world((1, 9), (1, 5), ((0,), (1,)), tent)
print("   tent, ceiling 12, P needs 1 takes 1, Q needs 9 takes 5, start [P,Q]: never-ending levels", N(W, (1, 1), hi))
infl3 = [0] + [min(3, hi - z) for z in range(1, hi + 1)]
W = make_world((1, 9), (1, 5), ((0,), (1,)), infl3)
print("   inflow min(3,12-z), same units: never-ending levels", N(W, (1, 1), hi),
      " course from 11:", [x for _, x in course(W, (1, 1), 11, 5)], " from 12:", [x for _, x in course(W, (1, 1), 12, 5)])
infl2 = [0] + [min(2, hi - z) for z in range(1, hi + 1)]
W = make_world((2, 6), (1, 3), ((0,), (1,)), infl2)
lv = N(W, (1, 1), hi)
print("   inflow min(2,12-z), units (need 6, use 3) and (need 2, use 1): never-ending levels", lv,
      "; among levels 6..12:", [x for x in lv if x >= 6])


def two_units_rhs(g, m, h, n, H2, y2, x, hi):
    """the right side of WayOfUnits.two_units_iff, by running the level's course under h + H2"""
    lev = x
    for T in range(0, 4 * hi + 4):
        if lev < m:
            nxt = max(lev - (h + H2), 0)
            nxt = nxt + g[nxt]
            return n <= lev and H2 + y2 <= nxt
        z = max(lev - (h + H2), 0)
        lev = z + g[z]
    return False


def premises(g, m, h, n, H2, hi):
    """two_units_iff's premises on the giving and the units; returns (y2, y1) or None"""
    if n > m or n < 1 or g[0] != 0:
        return None
    y2 = next((z for z in range(hi + 1) if g[z] >= H2), None)
    if y2 is None:
        return None
    if not all(g[z] >= H2 for z in range(y2, hi + 1) if z + H2 <= hi):       # Meets
        return None
    if not all(max(x - H2, 0) + g[max(x - H2, 0)] <= hi for x in range(hi + 1)):  # Keeps
        return None
    if n > H2 + y2:                                                           # within
        return None
    y1 = next((z for z in range(hi + 1) if g[z] >= h + H2), hi + 1)           # Short g (h+H2) y1
    return y2, y1


print("\n2. The smallest ceiling at which two units under two_units_iff's premises have never-ending starts")
print("   that are not an up-set among the levels meeting both needs (uses 1..4, rising step maps)")
found = False
for hi in range(3, 13):
    for gname, g in givings(hi).items():
        if not step_rising(g):
            continue
        for m in range(1, hi + 1):
            for n in range(1, m + 1):
                for h in range(1, 5):
                    for H2 in range(1, 5):
                        pr = premises(g, m, h, n, H2, hi)
                        if pr is None:
                            continue
                        y2, y1 = pr
                        W = make_world((m, n), (h, H2), ((0,), (1,)), g)
                        memo = {}
                        xs = [x for x in range(m, hi + 1) if x < h + H2 + y1]   # `below`, and all needs met
                        fate = {x: never_ends(W, (1, 1), x, memo) for x in xs}
                        # the transcription against the Lean's exact law
                        for x in xs:
                            assert fate[x] == two_units_rhs(g, m, h, n, H2, y2, x, hi), (hi, gname, m, h, n, H2, x)
                        lv = [x for x in xs if fate[x]]
                        if lv and any((x + 1 in fate) and not fate[x + 1] for x in lv):
                            print("   ceiling %d, %s: unit (need %d, use %d) and unit (need %d, use %d); y2=%d y1=%d;"
                                  % (hi, gname, m, h, n, H2, y2, y1))
                            print("      levels within the premises %s; never ending from %s" % (xs, lv))
                            found = True
                            break
                    if found: break
                if found: break
            if found: break
        if found: break
    if found: break
print("   (every start checked here agreed with the right side of two_units_iff)")

print("\n3. Sandwich: with a rising step map, if the ways from x and x'' agree for 14 steps (or to the end), so do the ways from any level between")
hi = 5
G = givings(hi)
WAYS2 = [cc for s in (1, 2) for cc in multisets(2, s)]
for gname, g in G.items():
    viol, cases = 0, 0
    for (need, use, kids) in two_kinds(hi)():
        W = make_world(need, use, kids, g)
        for c in WAYS2:
            sig = {}
            for x in range(hi + 1):
                cc, xx, ws = c, x, []
                for _ in range(14):
                    ws.append(cc)
                    if not goes(W, cc, xx):
                        break
                    cc, xx = step(W, cc, xx)
                sig[x] = tuple(ws)
            cases += 1
            for x in range(hi + 1):
                for x2 in range(x + 2, hi + 1):
                    if sig[x] == sig[x2] and any(sig[x1] != sig[x] for x1 in range(x + 1, x2)):
                        viol += 1
    print("   %-32s step rising %-5s  (world, way) cases %d, violations %d" % (gname, step_rising(g), cases, viol))

print("\n4. The levels from which every unit's need is met at every step and the way is never empty (all met for ever); ceiling 5")
for gname, g in G.items():
    notup, nonempty, outside = 0, 0, 0
    for (need, use, kids) in two_kinds(hi)():
        W = make_world(need, use, kids, g)
        memo = {}
        for c in WAYS2:
            H = []
            for x in range(hi + 1):
                cc, xx, ok, seen = c, x, True, set()
                while (cc, xx) not in seen:
                    seen.add((cc, xx))
                    if sum(cc) == 0 or any(cc[i] and need[i] > xx for i in range(2)):
                        ok = False
                        break
                    cc, xx = step(W, cc, xx)
                if ok:
                    H.append(x)
                    if not never_ends(W, c, x, memo):
                        outside += 1
            if H:
                nonempty += 1
                if classify(H, hi) != "up-set":
                    notup += 1
    print("   %-32s step rising %-5s  non-empty %d, not an up-set %d, not within the never-ending %d"
          % (gname, step_rising(g), nonempty, notup, outside))

hi = 6
G = givings(hi)
print("\n5. One kind (so one need): never-ending levels that are not an up-set, by giving (ceiling 6, kids 0..3 copies, uses 1..3)")
for gname, g in G.items():
    bad, tot = 0, 0
    eg = None
    for k in range(0, 4):
        for u in (1, 2, 3):
            for n in range(1, hi + 1):
                W = make_world((n,), (u,), ((0,) * k,), g)
                for size in (1, 2):
                    lv = N(W, (size,), hi)
                    tot += 1
                    if lv and classify(lv, hi) != "up-set":
                        bad += 1
                        if eg is None:
                            eg = (n, u, k, size, lv)
    print("   %-32s step rising %-5s  cases %d, not an up-set %d %s" % (gname, step_rising(g), tot, bad,
          ("e.g. need %d use %d kids %d copies, %d unit(s): %s" % eg) if eg else ""))

print("\n6. HigherStartEnds, the class B B C C (take 4) under the tent at ceiling 12: levels 3..11 from which the level")
print("   under a standing take of 4 stays within 3..11 for ever (C's need 12 never met):")
hi = 12
stay = []
for x in range(3, 12):
    xx, ok = x, True
    for _ in range(50):
        if not (3 <= xx <= 11):
            ok = False
            break
        z = max(xx - 4, 0)
        xx = z + tent[z]
    if ok:
        stay.append(x)
print("   ", stay, "; boundary H + y = 4 + 4 = 8; fixed levels of the take-4 step:",
      [x for x in range(hi + 1) if max(x - 4, 0) + tent[max(x - 4, 0)] == x])
