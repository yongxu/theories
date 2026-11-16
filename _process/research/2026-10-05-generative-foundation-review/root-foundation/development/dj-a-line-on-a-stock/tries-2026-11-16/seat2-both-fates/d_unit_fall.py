# AI-written (Fable, seat 2 of round 11), 16 November 2026. A search by script is not a proof.
# Two units that each leave themselves, both needs met at the start, rising step map. Where the level
# falls by at most one a step while both are there (g(x - T) >= T - 1 for every level x from the
# higher need up), are the never-ending starts among the levels meeting both needs an up-set?
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from model import make_world, never_ends
from b_general import givings, step_rising
tot = slow = bad_slow = bad_fast = 0
eg = None
for hi in range(3, 11):
    for gname, g in givings(hi).items():
        if not step_rising(g):
            continue
        for m in range(1, hi + 1):
            for n in range(1, m + 1):
                for h in range(1, 5):
                    for H2 in range(1, 5):
                        T = h + H2
                        W = make_world((m, n), (h, H2), ((0,), (1,)), g)
                        memo = {}
                        lv = [x for x in range(m, hi + 1) if never_ends(W, (1, 1), x, memo)]
                        tot += 1
                        notup = bool(lv) and (lv[-1] != hi or lv[-1] - lv[0] + 1 != len(lv))
                        unit = all(g[max(x - T, 0)] + 1 >= T and x >= T for x in range(m, hi + 1))
                        if unit:
                            slow += 1
                            if notup:
                                bad_slow += 1
                                eg = eg or (hi, gname, m, h, n, H2, lv)
                        elif notup:
                            bad_fast += 1
print("two-unit worlds (ceilings 3..10, uses 1..4, needs n <= m <= ceiling, five rising-step givings):", tot)
print("  level falls at most one a step while both are there:", slow, "; of them not an up-set:", bad_slow, eg or "")
print("  the others not an up-set:", bad_fast)
