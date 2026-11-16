"""AI-written (Fable, seat exact-model). (a) The value set again from the take itself, above it: h (x, y) m = x + c, c >= 1.
A search over small cases; not a proof."""
import itertools, time
from model import *

t0 = time.time()

def squares(t):            # an irregular schedule that reads without end, gaps growing: not bounded-gap
    r = int(t ** 0.5); return r * r == t
def two_of_five(t): return t % 5 in (0, 1)

SCHEDULES = [('every 1', every(1), 1), ('every 2', every(2), 2), ('every 3', every(3), 3),
             ('every 5', every(5), 5), ('every 5 from 4', every(5, 4), 5), ('two of five', two_of_five, 5)]

# ---- 1. ends from every start, under each schedule with gaps at most L; the bound (2 hi + 1) L ----
total = 0; worst = {}; fails = []
for gname, mk in (('tent', tent), ('refill', refill)):
    for hi in range(1, 13):
        g = mk(hi)
        assert keeps(g, 0, hi) and g(0) == 0
        for mname, A in MOVES.items():
            for c in (1, 2, 3):
                h = src_itself(c)
                f = fast_O1(A, g)
                for sname, reads, L in SCHEDULES:
                    bound = (2 * hi + 1) * L
                    top = hi + 2
                    for x0 in range(0, top, 1 if hi <= 6 else 2):
                        for m0 in range(0, top, 1 if hi <= 6 else 3):
                            for y0 in range(1, hi + 1):
                                fate, step, course = run(f, h, reads, ((x0, y0), m0), bound + 2)
                                total += 1
                                if fate != 'ends':
                                    fails.append((gname, hi, mname, c, sname, x0, y0, m0))
                                else:
                                    k = (gname, mname, c, sname, hi)
                                    if step > worst.get(k, (0,))[0]:
                                        worst[k] = (step, (x0, y0, m0))
print(f'1. {total} courses (tent and refill, ceilings 1..12, three moves, c in 1..3, six schedules, starts on a grid):')
print(f'   not ended within (2 hi + 1) L steps: {len(fails)}', fails[:3])
print('   latest ending step at ceiling 12, tent (rows: move, c; columns: schedule) and the bound (2*12+1) L:')
print('   ' + ' ' * 14 + ''.join(f'{s[0]:>16}' for s in SCHEDULES))
for mname in MOVES:
    for c in (1, 2, 3):
        row = ''.join(f"{worst[('tent', mname, c, s[0], 12)][0]:>16}" for s in SCHEDULES)
        print(f'   {mname:8} c={c} {row}')
print('   ' + ' ' * 14 + ''.join(f'{(2*12+1)*s[2]:>16}' for s in SCHEDULES))

# ---- 2. the take need not rise at every step: rising_takes_all's premise `rises` fails on these courses ----
g = tent(12)
for mname, A, c, L in (('by one', by_one, 1, 1), ('at once', at_once, 1, 1), ('by one', by_one, 2, 1), ('by one', by_one, 3, 4)):
    fate, step, course = run(fast_O1(A, g), src_itself(c), every(L), ((3, 12), 10 if A is at_once else 3), 200)
    takes = [p[0][0] for p in course]
    strict = all(a < b for a, b in zip(takes, takes[1:]))
    print(f'2. {mname}, c={c}, read every {L}: takes {takes} levels {[p[0][1] for p in course]}; rises at every step: {strict}')

# ---- 3. the lock's premises at these types: A = Nat (the take as share), R = Nat (the set level as rule) ----
# count_rises.rise : forall a g, favours g -> a < fA a g.   With fA = a move towards g it fails at a = g, whatever favours holds of.
# RuleCapture.Raises (<=) favours fA : forall x g, favours g -> x <= fA x g.  It fails at x = g + 1.
bad_rise = [(a, gg) for gg in range(6) for a in range(8) if not a < by_one(a, gg)]
bad_raises = [(a, gg) for gg in range(6) for a in range(8) if not a <= by_one(a, gg)]
print(f'3. for every set level g in 0..5 some take a has not (a < A a g): {sorted(set(q[1] for q in bad_rise)) == list(range(6))};',
      f'and some take has not (a <= A a g): {sorted(set(q[1] for q in bad_raises)) == list(range(6))}  (e.g. a = g + 1)')
# locked_ends_rising.more at use := the take: forall v not below the start (in <= on take and on set level), use v < use (windowAlone v)
# fails at any v whose take is at or above its set level.
print('   `more` at use = take fails at v = (take 9, set level 4): A 9 4 =', by_one(9, 4))
# ReadsShare (<=) (<=) hA holds for hA x m = x + c (monotone in the take alone).
# A region that every turn does keep, for every move that is Between: x <= m <= x + c.
viol = 0
for A in MOVES.values():
    for c in (1, 2, 3):
        for x in range(0, 15):
            for m in range(x, x + c + 1):
                for b in (True, False):
                    (x2, _), m2 = turn(lambda s, r: (A(s[0], r), 0), src_itself(c), b, ((x, 0), m))
                    if not (x2 <= m2 <= x2 + c and x <= x2 and m <= m2): viol += 1
print(f'   the region x <= m <= x + c is kept by every turn, take and set level never falling in it: violations {viol}')

# ---- 4. without a ceiling ----
for gname, g in (('doubling g z = z', doubling()), ('flat g z = min z 3', flat(3)), ('crossing', crossing()), ('concave', concave())):
    res = {}
    for mname, A in MOVES.items():
        for c in (1, 2):
            for L in (1, 3):
                on = []
                for y0 in range(1, 25):
                    fate, step, course = run(fast_O1(A, g), src_itself(c), every(L), ((0, y0), 1), 3000)
                    if fate != 'ends': on.append(y0)
                res[(mname, c, L)] = on
    some = {k: v for k, v in res.items() if v}
    print(f'4. {gname}: start take 0, held 1, start levels 1..24, horizon 3000:',
          'ends from every one' if not some else f'does not end within the horizon from: { {k: (v[0], "...", v[-1]) for k, v in some.items()} }')
fate, step, course = run(fast_O1(by_one, doubling()), src_itself(1), every(1), ((0, 2), 1), 12)
print('   doubling, by one, c=1, from level 2:', [(p[0][0], p[0][1]) for p in course])

# ---- 5. the other order and the other reading ----
tot = 0; bad = 0; latest = 0
for hi in (6, 12):
    g = tent(hi)
    for A in MOVES.values():
        for c in (1, 2):
            for sname, reads, L in SCHEDULES[:4]:
                for fmk in (fast_O1, fast_O2):
                    f = fmk(A, g)
                    for h in (src_itself(c), after(f, src_itself(c))):
                        for x0 in range(0, hi + 2, 2):
                            for m0 in range(0, hi + 2, 3):
                                for y0 in range(1, hi + 1):
                                    fate, step, _ = run(f, h, reads, ((x0, y0), m0), (2 * hi + 1) * L + 3)
                                    tot += 1
                                    if fate != 'ends': bad += 1
                                    else: latest = max(latest, step)
print(f'5. both orders of the fast step, reading before or after the step ({tot} courses, tent 6 and 12): not ended within (2 hi + 1) L + 1: {bad}')
print(f'   {time.time() - t0:.1f} s')
