"""AI-written (Fable, seat exact-model). (d) The value set again above the take but never above a top s:
   h (x, y) m = min (x + c) s.
A search over small cases; not a proof."""
import time
from model import *
t0 = time.time()

def in_region(p, c, s):       # held at the top and the take within c of it (or above it)
    (x, y), m = p
    return m == s and s <= x + c

# ---- 1. the region {m = s, s <= x + c} is kept by every turn, for every move ----
viol = 0
for A in MOVES.values():
    for c in (1, 2, 3):
        for s in range(0, 14):
            for x in range(0, 18):
                if not s <= x + c: continue
                for b in (True, False):
                    q = turn(lambda st, r: (A(st[0], r), 0), src_top(c, s), b, ((x, 0), s))
                    if not in_region(q, c, s): viol += 1
print(f'1. the region (held = s and s <= take + c) left by a turn: {viol} (three moves, c 1..3, s 0..13, takes 0..17, reading or not)')

# ---- 2. from the first step in the region it is the fixed case at s; "from the step the held value first equals s" is not enough ----
tot = 0; never_in = 0; mismatch = 0; first_eq_not_in = []; before = 0; late_fixed = 0
for hi in range(1, 13):
    g = tent(hi)
    for mname, A in MOVES.items():
        f = fast_O1(A, g)
        for c in (1, 2):
            for s in range(0, hi + 1):
                h = src_top(c, s)
                for L in (1, 2, 3):
                    for x0 in range(0, hi + 2, 2):
                        for m0 in range(0, hi + 2, 2):
                            for y0 in range(1, hi + 1):
                                fate, step, course = run(f, h, every(L), ((x0, y0), m0), 3000, period=L)
                                tot += 1
                                T = next((t for t, p in enumerate(course) if in_region(p, c, s)), None)
                                E = next((t for t, p in enumerate(course) if p[1] == s), None)
                                if E is not None and (T is None or E < T):
                                    first_eq_not_in.append((hi, L, c, mname, s, x0, y0, m0))
                                if T is None:
                                    if fate == 'ends': before += 1
                                    else: never_in += 1
                                    continue
                                # from T on: the same course as h = m (fixed) from the configuration at T
                                fate_fixed = run(f, src_fixed(), every(1), course[T], 3000, period=1)[0]
                                if fate_fixed != fate: mismatch += 1
                                # and the regime's fate at a standing take s from the level at the step the take is s
                                Ts = next((t for t, p in enumerate(course) if t >= T and p[0][0] == s), None)
                                if Ts is not None and regime_fate(g, s, course[Ts][0][1]) != fate: late_fixed += 1
print(f'2. {tot} courses (tent, ceilings 1..12, three moves, c 1..2, every top 0..hi, read every 1, 2, 3):')
print(f'   lasting courses that never enter the region: {never_in};  ended before entering it: {before}')
print(f'   fate from the first step in the region differs from the fixed case at s from that configuration: {mismatch};',
      f'differs from the regime under a standing take s from the level where the take reaches s: {late_fixed}')
print(f'   courses where the held value equals s before the region is entered: {len(first_eq_not_in)}; smallest (ceiling, L, c, move, s, x0, y0, m0): {min(first_eq_not_in) if first_eq_not_in else None}')
if first_eq_not_in:
    hi, L, c, mname, s, x0, y0, m0 = min(first_eq_not_in)
    g = tent(hi)
    _, _, course = run(fast_O1(MOVES[mname], g), src_top(c, s), every(L), ((x0, y0), m0), 14, period=None)
    print(f'      (take, level, held): {[(p[0][0], p[0][1], p[1]) for p in course]}')
# is "held = s" alone left again? (the top reached and then lost)
lost = []
for hi in (6, 12):
    g = tent(hi)
    for mname, A in MOVES.items():
        for c in (1, 2):
            for s in range(1, hi + 1):
                for x0 in range(0, hi + 2):
                    for m0 in range(0, hi + 2):
                        _, _, course = run(fast_O1(A, g), src_top(c, s), every(1), ((x0, hi), m0), 60, period=1)
                        ms = [p[1] for p in course]
                        if any(a == s and b != s for a, b in zip(ms, ms[1:])):
                            lost.append((hi, c, mname, s, x0, m0))
print(f'   the held value at the top and then off it again (start level at the ceiling): {len(lost)}; smallest {min(lost) if lost else None};',
      f'moves: {sorted(set(q[2] for q in lost))}')
if lost:
    hi, c, mname, s, x0, m0 = min(lost)
    _, _, course = run(fast_O1(MOVES[mname], tent(hi)), src_top(c, s), every(1), ((x0, hi), m0), 12, period=None)
    print(f'      (take, level, held): {[(p[0][0], p[0][1], p[1]) for p in course]}')

# ---- 3. the top decides: tent 12, start take 0, level 12, held 0, by one, c = 1 ----
g = tent(12)
print('3. tent 12, by one, c = 1, read every step, start take 0, held 0: fate by top s (rows) and start level 1..12 (columns); . goes on, x ends')
for s in range(0, 9):
    row = ''.join('.' if run(fast_O1(by_one, g), src_top(1, s), every(1), ((0, y0), 0), 3000, period=1)[0] == 'goes on' else 'x' for y0 in range(1, 13))
    reg = ''.join('.' if regime_fate(g, s, y0) == 'goes on' else 'x' for y0 in range(1, 13))
    print(f'   s={s}: {row}   standing take s from the same level: {reg}')
print(f'   {time.time() - t0:.1f} s')
