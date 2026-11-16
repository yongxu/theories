"""AI-written (Fable, seat exact-model). (c) The value set again from the stock:
   h (x, y) m = g (y - x)   (what the stock gives in this step),  and  h (x, y) m = y - r  (the level less a reserve).
A search over small cases; not a proof."""
import time
from model import *
t0 = time.time()

def fate_of(f, h, L, c, horizon=3000):
    return run(f, h, every(L), c, horizon, period=L)[0]

# ---- 1. at once, reading every step: (y - x) - m is carried along, and the course is a one-place map of what is left ----
def line_fate(g, z0, m0, horizon=3000):
    """z -> (z0 - m0) + g z, ending where z <= 0."""
    I = z0 - m0; z = z0; seen = set()
    for _ in range(horizon):
        if z <= 0: return 'ends'
        if z in seen: return 'goes on'
        seen.add(z)
        z = I + g(z)
    return 'open'
tot = 0; bad = 0; bad_tent = 0; carried_bad = 0
for gname, mk in (('tent', tent), ('refill', refill)):
    for hi in range(1, 13):
        g = mk(hi)
        f = fast_O1(at_once, g)
        for x0 in range(0, hi + 2):
            for m0 in range(0, hi + 2):
                for y0 in range(1, hi + 1):
                    fate, step, course = run(f, src_gave(g), every(1), ((x0, y0), m0), 3000, period=1)
                    tot += 1
                    if fate != line_fate(g, y0 - x0, m0): bad += 1
                    # carried along while the level covers the take
                    for (x, y), m in course:            # carried along up to the first step at which the take exceeds the level
                        if y < x: break
                        if (y - x) - m != (y0 - x0) - m0: carried_bad += 1; break
                    if gname == 'tent':
                        z0 = y0 - x0
                        closed = 'goes on' if (z0 > m0 and z0 >= 1) or (z0 == m0 and 1 <= z0 <= hi - 1) else 'ends'
                        if closed != fate: bad_tent += 1
print(f'1. at once, read every step ({tot} starts, tent and refill, ceilings 1..12):')
print(f'   fate differs from the one-place map z -> (z0 - m0) + g z staying positive: {bad};  (y - x) - m not carried along: {carried_bad}')
print(f'   tent: fate differs from "z0 > m0, or z0 = m0 with 1 <= z0 <= hi - 1" (z0 = y0 - x0): {bad_tent}')

# ---- 2. slower moves: least start level that goes on, tent 12 ----
hi = 12; g = tent(hi)
for mname, A in (('by one', by_one), ('by half', by_half), ('at once', at_once)):
    f = fast_O1(A, g)
    not_up = 0
    print(f'2. tent 12, {mname}, read every step: least start level that goes on (rows start take 0..8, columns start held 0..8; - none):')
    for x0 in range(0, 9):
        row = ''
        for m0 in range(0, 9):
            fates = [fate_of(f, src_gave(g), 1, ((x0, y0), m0)) for y0 in range(1, hi + 1)]
            on = [i + 1 for i, q in enumerate(fates) if q == 'goes on']
            if on and any(q != 'goes on' for q in fates[on[0] - 1:]): not_up += 1
            row += f'{on[0] if on else "-":>4}'
        print(f'   take {x0}: {row}')
    print(f'   rows where a higher start level ends after a lower one goes on: {not_up}')

# every rest: take = held = what is given; one for each amount left
rests = [(g(z), z + g(z), g(z)) for z in range(1, hi)]
ok = all(turn(fast_O1(by_one, g), src_gave(g), True, ((x, y), m)) == ((x, y), m) for x, y, m in rests)
print(f'   rests (take, level, held) for the tent 12, one for each amount left 1..11: {rests}; each is fixed by a turn: {ok}')

# where do the lasting courses come to: a rest or a cycle
ends_in = {}
for mname, A in MOVES.items():
    f = fast_O1(A, g); r = c = 0
    for x0 in range(0, hi + 2):
        for m0 in range(0, hi + 2):
            for y0 in range(1, hi + 1):
                fate, step, course = run(f, src_gave(g), every(1), ((x0, y0), m0), 3000, period=1)
                if fate == 'goes on':
                    last = course[-1]
                    if turn(f, src_gave(g), True, last) == last: r += 1
                    else: c += 1
    ends_in[mname] = (r, c)
print(f'   lasting courses that come to a rest / to a cycle, by move: {ends_in}')

# ---- 3. sparse and late readings ----
def gated_tent(hi): return lambda z: 0 if z < 2 else (min(z, hi - z) if z <= hi else 0)   # gives nothing below a need of two left

def fast_late(A, g, ell):     # S := (take, level, the last ell amounts given, oldest first); the reading sees the oldest
    def f(s, m):
        x, y, buf = s
        left = y - x if y >= x else 0
        return (A(x, m), left + g(left), (buf + (g(left),))[1:] if ell else ())
    return f
def src_late(g, ell):
    def h(s, m):
        x, y, buf = s
        return buf[0] if ell else g(y - x if y >= x else 0)
    return h
def run_late(A, g, ell, x0, y0, m0, fill, horizon=3000):
    left0 = y0 - x0 if y0 >= x0 else 0
    first = g(left0) if fill == 'stood' else m0          # the history as if the start had stood, or as the held value
    start = ((x0, y0, tuple([first] * ell)), m0)
    return run(fast_late(A, g, ell), src_late(g, ell), every(1), start, horizon, period=1)

g = tent(12)
assert all(run_late(by_one, g, 0, x0, y0, m0, 'stood')[0] == fate_of(fast_O1(by_one, g), src_gave(g), 1, ((x0, y0), m0))
           for x0 in range(5) for y0 in range(1, 13) for m0 in range(5))

print('3. kept by reading every step, ended by a sparse or late reading (ceilings 1..12, every start with take and held 0..hi+1, level 1..hi):')
VARIANTS = [('sparse', L, off) for L in (2, 3, 4) for off in range(L)] + [('late', ell, fill) for ell in (1, 2, 3) for fill in ('stood', 'held')]
for gname, mk in (('tent', tent), ('refill', refill), ('gated tent', gated_tent)):
    counts = {}; first = {}
    for hi in range(1, 13):
        g = mk(hi)
        for mname, A in MOVES.items():
            f = fast_O1(A, g)
            for x0 in range(0, hi + 2):
                for m0 in range(0, hi + 2):
                    for y0 in range(1, hi + 1):
                        if fate_of(f, src_gave(g), 1, ((x0, y0), m0)) != 'goes on': continue
                        for v in VARIANTS:
                            k = v + (mname,)
                            counts.setdefault(k, [0, 0]); counts[k][1] += 1
                            if v[0] == 'sparse':
                                fate = run(f, src_gave(g), every(v[1], v[2]), ((x0, y0), m0), 3000, period=v[1])[0]
                            else:
                                fate = run_late(A, g, v[1], x0, y0, m0, v[2])[0]
                            if fate == 'ends':
                                counts[k][0] += 1
                                first.setdefault(k, (hi, x0, y0, m0))
    print(f'   {gname}: ended / kept, by move (by one, by half, at once); first found as (ceiling, take, level, held) for by one')
    for v in VARIANTS:
        cells = ' '.join(f"{counts[v + (mn,)][0]:>4}/{counts[v + (mn,)][1]:<5}" for mn in MOVES)
        tag = f'read every {v[1]} from step {v[2]}' if v[0] == 'sparse' else f'reading old by {v[1]}, history {v[2]}'
        print(f'      {tag:34} {cells}  {first.get(v + ("by one",))}')
    SMALL = first if gname == 'tent' else None
    if gname == 'tent': first_tent = dict(first)

def show(tag, course): print(f'      {tag}: (take, level, held) {[(p[0][0], p[0][1], p[1]) for p in course[:12]]}')
for kind in ('sparse', 'late'):
    cands = [(v, k) for k, v in first_tent.items() if k[0] == kind]
    if not cands: print(f'   no {kind} case on the tent'); continue
    (hi_, x0, y0, m0), k = min(cands)
    g = tent(hi_); A = MOVES[k[3]]
    print(f'   smallest {kind} case on the tent: ceiling {hi_}, {k[3]}, {k[1:3]}, start take {x0}, level {y0}, held {m0}')
    show('read every step', run(fast_O1(A, g), src_gave(g), every(1), ((x0, y0), m0), 40, period=1)[2])
    if kind == 'sparse': show(f'read every {k[1]} from step {k[2]}', run(fast_O1(A, g), src_gave(g), every(k[1], k[2]), ((x0, y0), m0), 40, period=k[1])[2])
    else: show(f'old by {k[1]}, history {k[2]}', run_late(A, g, k[1], x0, y0, m0, k[2], 40)[2])

# up to and including the first reading step the held value is the start's (Pace.rule_until_reading): a first reading at step r
hi = 12; g = tent(hi)
print('   tent 12, by one, start take 5, held 5, first reading at step r and at every step after: least start level that goes on,')
print('   beside the least level from which a standing take 5 leaves, after r steps, a level that reading at every step keeps')
for r in range(0, 6):
    reads = lambda t, r=r: t >= r
    on = [y0 for y0 in range(1, hi + 1) if run(fast_O1(by_one, g), src_gave(g), reads, ((5, y0), 5), 3000, period=1)[0] == 'goes on']
    via = []
    for y0 in range(1, hi + 1):
        y = y0
        for _ in range(r): y = rstep(g, 5, y)
        if y >= 1 and fate_of(fast_O1(by_one, g), src_gave(g), 1, ((5, y), 5)) == 'goes on': via.append(y0)
    print(f'      r = {r}: {on[0] if on else "none"} | {via[0] if via else "none"}', end=';')
print()

# ---- 4. the level less a reserve ----
print('4. held := level less a reserve r (tent 12): starts (take, held 0..13, level 1..12) that go on, of 2352; and where they come to')
for r in (2, 4, 6, 8, 10):
    for mname, A in MOVES.items():
        for L in (1, 3):
            f = fast_O1(A, g); on = 0; fin = set()
            for x0 in range(0, hi + 2):
                for m0 in range(0, hi + 2):
                    for y0 in range(1, hi + 1):
                        fate, step, course = run(f, src_reserve(r), every(L), ((x0, y0), m0), 3000, period=L)
                        if fate == 'goes on':
                            on += 1
                            last = course[-1]
                            fin.add(('rest', last[0][0], last[0][1]) if turn(f, src_reserve(r), True, last) == last else ('cycle',))
            rests = sorted(q for q in fin if q[0] == 'rest')
            print(f'   r={r:2} {mname:8} every {L}: {on:5} go on; rests (take, level): {[(a, b) for _, a, b in rests][:6]}{"; and cycles" if ("cycle",) in fin else ""}')

# ---- 5. one start, one fast step, four sources ----
print('5. one start (take 3, level 9, held 3), tent 12, by one, read every step; only the source differs:')
for name, h in (('held fixed', src_fixed()), ('from the take, +1', src_itself(1)), ('what the stock gave', src_gave(g)),
                ('level less a reserve 6', src_reserve(6)), ('above the take, top 3', src_top(1, 3)), ('above the take, top 5', src_top(1, 5)),
                ('above the take, top 6', src_top(1, 6)), ('above the take, top 7', src_top(1, 7))):
    fate, step, course = run(fast_O1(by_one, g), h, every(1), ((3, 9), 3), 3000, period=1)
    print(f'   {name:24}: {fate}{"" if step is None else " at step " + str(step)}; comes to (take, level, held) {(course[-1][0][0], course[-1][0][1], course[-1][1])}')
print(f'   {time.time() - t0:.1f} s')
