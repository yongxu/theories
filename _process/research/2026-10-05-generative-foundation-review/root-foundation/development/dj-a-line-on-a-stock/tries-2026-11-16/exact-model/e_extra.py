"""AI-written (Fable, seat exact-model). Further small checks for (c) and the frozen tests. A search, not a proof."""
from model import *
import importlib
hi = 12; g = tent(hi)

# 1. up to and including the first reading step the held value is the start's (Pace.rule_until_reading)
print('1. tent 12, by one, value from what the stock gave, start take 0, held 6; first reading at step r, then every step:')
print('   least start level that goes on | the same computed as: run the fixed case (held 6) for r steps, then ask whether reading at every step keeps that configuration')
for r in range(0, 8):
    reads = lambda t, r=r: t >= r
    on = [y0 for y0 in range(1, hi + 1) if run(fast_O1(by_one, g), src_gave(g), reads, ((0, y0), 6), 3000, period=1)[0] == 'goes on']
    via = []
    for y0 in range(1, hi + 1):
        p = ((0, y0), 6); dead = False
        for _ in range(r):
            if p[0][1] < 1: dead = True; break
            p = turn(fast_O1(by_one, g), src_fixed(), True, p)
        if not dead and run(fast_O1(by_one, g), src_gave(g), every(1), p, 3000, period=1)[0] == 'goes on': via.append(y0)
    print(f'   r={r}: {on[0] if on else "none"} | {via[0] if via else "none"}', end=';')
print()
# the rule is the start's up to and including the first reading step, on every searched course
bad = 0
for r in range(0, 6):
    reads = lambda t, r=r: t == r or t > r + 2
    for x0 in range(0, 8):
        for y0 in range(1, 13):
            _, _, course = run(fast_O1(by_half, g), src_gave(g), reads, ((x0, y0), 5), r + 1)
            if any(p[1] != 5 for p in course[:r + 1]): bad += 1
print(f'   held value differs from the start\'s at a step up to and including the first reading step: {bad}')

# 2. the level less a reserve: kept by reading every step, ended by reading every L from step 0
print('2. held := level less a reserve r, tent 12: kept by reading every step and ended by reading every L (first reading at step 0)')
for r in (6, 8, 10):
    for mname, A in MOVES.items():
        f = fast_O1(A, g)
        for L in (2, 3):
            ended = []; kept = 0; rev = 0
            for x0 in range(0, hi + 2):
                for m0 in range(0, hi + 2):
                    for y0 in range(1, hi + 1):
                        a = run(f, src_reserve(r), every(1), ((x0, y0), m0), 3000, period=1)[0]
                        b = run(f, src_reserve(r), every(L), ((x0, y0), m0), 3000, period=L)[0]
                        if a == 'goes on':
                            kept += 1
                            if b == 'ends': ended.append((x0 + y0 + m0, x0, y0, m0))
                        elif b == 'goes on': rev += 1
            print(f'   r={r:2} {mname:8} every {L}: {len(ended)} of {kept} kept are ended; smallest (take, level, held) {min(ended)[1:] if ended else None}; ended by every step but kept: {rev}')
f = fast_O1(by_half, g)
for L in (1, 2):
    _, st, course = run(f, src_reserve(6), every(L), ((0, 7), 13), 30, period=L)
    print(f'   r=6, by half, read every {L}, start (0, 7, 13): {[(p[0][0], p[0][1], p[1]) for p in course[:10]]}{" ends" if st is not None else ""}')

# 3. the smallest case of (c) for the move by one
g2 = tent(2)
for name, reads, per in (('every step', every(1), 1), ('every 2 from step 1', every(2, 1), 2)):
    fate, st, course = run(fast_O1(by_one, g2), src_gave(g2), reads, ((0, 1), 2), 20, period=per)
    print(f'3. tent 2, by one, start (take 0, level 1, held 2), read {name}: {fate}; {[(p[0][0], p[0][1], p[1]) for p in course]}')

# 4. a source that reads only the take and the held value: the course of (take, held) is the same from every start level
#    (the whole Pace.paced course, not cut where the level fails the need)
def whole(f, h, reads, c, T):
    p = c; out = []
    for t in range(T):
        out.append(p); p = turn(f, h, reads(t), p)
    return out
diff = {}
for name, h in (('fixed', src_fixed()), ('itself', src_itself(1)), ('top 5', src_top(1, 5)), ('gave', src_gave(g)), ('reserve 6', src_reserve(6))):
    d = 0
    for A in MOVES.values():
        for x0 in range(0, 8):
            for m0 in range(0, 8):
                ref = [(p[0][0], p[1]) for p in whole(fast_O1(A, g), h, every(1), ((x0, 12), m0), 30)]
                for y0 in range(0, 12):
                    if [(p[0][0], p[1]) for p in whole(fast_O1(A, g), h, every(1), ((x0, y0), m0), 30)] != ref: d += 1
    diff[name] = d
print(f'4. starts whose (take, held) course over 30 steps differs from the course at start level 12, of 2304 each: {diff}')
