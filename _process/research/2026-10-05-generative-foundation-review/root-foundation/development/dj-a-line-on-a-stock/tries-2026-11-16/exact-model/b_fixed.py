"""AI-written (Fable, seat exact-model). (b) The value held fixed: h (x, y) m = m (or a schedule that never reads).
A search over small cases; not a proof."""
import time
from model import *
t0 = time.time()

def squares(t):
    r = int(t ** 0.5); return r * r == t

# (a) addendum: a schedule that reads without end with gaps that grow (the squares): ends by the step after the reading of index 2 hi
bad = 0; tot = 0; latest = 0
for hi in (3, 6, 9):
    g = tent(hi)
    for A in MOVES.values():
        for c in (1, 2):
            for x0 in range(0, hi + 2, 2):
                for m0 in range(0, hi + 2, 3):
                    for y0 in range(1, hi + 1):
                        fate, step, _ = run(fast_O1(A, g), src_itself(c), squares, ((x0, y0), m0), (2 * hi) ** 2 + 3)
                        tot += 1
                        if fate != 'ends' or step > (2 * hi) ** 2 + 1: bad += 1
                        else: latest = max(latest, step)
print(f'(a) addendum, readings at the squares, tent 3, 6, 9 ({tot} courses): not ended by step (2 hi)^2 + 1: {bad}; latest {latest}')

# ---- 1. once the take is at m, the course is the regime's under a standing take m ----
tot = 0; mismatch = 0; arrive_late = 0
before_arrival = []; ends_though_holds = []; lasts_though_ends = []
never_same = 0
for gname, mk in (('tent', tent), ('refill', refill)):
    for hi in range(1, 13):
        g = mk(hi)
        for mname, A in MOVES.items():
            f = fast_O1(A, g)
            for m in range(0, hi + 2):
                for x0 in range(0, hi + 2):
                    for y0 in range(1, hi + 1):
                        fate, step, course = run(f, src_fixed(), every(1), ((x0, y0), m), 400, period=1)
                        fate_never, step_never, _ = run(f, src_itself(1), never(), ((x0, y0), m), 400, period=1)
                        tot += 1
                        if (fate, step) != (fate_never, step_never): never_same += 1
                        # first step with the take at m (within the gap, by Between and strictly nearer)
                        T = next((t for t, p in enumerate(course) if p[0][0] == m), None)
                        gap = abs(x0 - m)
                        if T is None:
                            # the course was cut where the level fell below the need before the take arrived
                            before_arrival.append((hi, gname, mname, m, x0, y0, step))
                            at_arrival = 'ends'
                        else:
                            if T > gap: arrive_late += 1
                            at_arrival = regime_fate(g, m, course[T][0][1])
                        if at_arrival != fate: mismatch += 1
                        at_start = regime_fate(g, m, y0)
                        if fate == 'ends' and at_start == 'goes on': ends_though_holds.append((hi, gname, mname, m, x0, y0, step))
                        if fate == 'goes on' and at_start == 'ends': lasts_though_ends.append((hi, gname, mname, m, x0, y0))
print(f'1. {tot} courses (tent and refill, ceilings 1..12, three moves, every set level and start take 0..hi+1, start levels 1..hi):')
print(f'   the fate differs from the regime\'s fate under a standing take m from the level at the step the take reaches m: {mismatch}')
print(f'   the take reaches m later than the gap |x0 - m|: {arrive_late};  a schedule that never reads gives another course than h = m: {never_same}')
def smallest(rows): return sorted(rows)[0] if rows else None
print(f'   ends before the take arrives: {len(before_arrival)}; smallest (ceiling, giving, move, m, x0, y0, end step): {smallest(before_arrival)}')
print(f'   ends though the start level holds under a standing take m: {len(ends_though_holds)}; smallest: {smallest(ends_though_holds)}')
print(f'      of these the take started above m in {sum(1 for r in ends_though_holds if r[4] > r[3])}, below m in {sum(1 for r in ends_though_holds if r[4] < r[3])}')
print(f'   lasts though the start level ends under a standing take m: {len(lasts_though_ends)}; smallest: {smallest(lasts_though_ends)}')
print(f'      of these the take started below m in {sum(1 for r in lasts_though_ends if r[4] < r[3])}, above m in {sum(1 for r in lasts_though_ends if r[4] > r[3])}')

# examples on the probe's numbers: tent 12, m = 3 (point of no return 3 + 3 = 6)
g = tent(12)
for x0, y0, A in ((9, 8, by_one), (0, 5, by_one), (9, 12, by_one), (0, 4, by_one), (3, 12, by_one)):
    fate, step, course = run(fast_O1(A, g), src_fixed(), every(1), ((x0, y0), 3), 60, period=1)
    print(f'   tent 12, m=3, start take {x0}, level {y0} (standing take 3 from {y0}: {regime_fate(g, 3, y0)}): {fate}{"" if step is None else " at step " + str(step)};',
          f'(take, level): {[(p[0][0], p[0][1]) for p in course[:9]]}')

# ---- 2. RegimeMargin.ends_iff_below's own form on the tent: ends exactly below H + y, y the least level meeting H ----
ok = 0; n = 0; nohyp = 0
for hi in range(1, 13):
    g = tent(hi)
    for H in range(0, hi + 1):
        roots = [y for y in range(hi + 1) if H <= g(y)]
        if not roots: nohyp += 1; continue
        y = roots[0]
        meets = all(H <= g(z) for z in range(y, hi + 1) if z + H <= hi)
        kp = keeps(g, H, hi)
        if not (meets and kp and 0 < H + y): nohyp += 1; continue
        for x in range(0, hi + 1):
            n += 1
            ok += (regime_fate(g, H, x) == 'ends') == (x < H + y)
print(f'2. ends_iff_below on the tent, ceilings 1..12, every draw whose premises hold: {ok} of {n} levels agree ({nohyp} draws without the premises)')

# ---- 3. is the fate monotone in the start take, the rest the same? ----
non_mono = []
for hi in range(1, 13):
    g = tent(hi)
    for mname, A in MOVES.items():
        for m in range(0, hi + 2):
            for y0 in range(1, hi + 1):
                fates = [run(fast_O1(A, g), src_fixed(), every(1), ((x0, y0), m), 400, period=1)[0] for x0 in range(0, hi + 2)]
                # monotone: once it ends at some start take, it ends at every larger one
                if any(a == 'ends' and b == 'goes on' for a, b in zip(fates, fates[1:])):
                    non_mono.append((hi, mname, m, y0, ''.join('.' if q == 'goes on' else 'x' for q in fates)))
print(f'3. a larger start take lasting where a smaller one ends (tent): {len(non_mono)}; smallest: {smallest(non_mono)}')
print(f'   {time.time() - t0:.1f} s')
