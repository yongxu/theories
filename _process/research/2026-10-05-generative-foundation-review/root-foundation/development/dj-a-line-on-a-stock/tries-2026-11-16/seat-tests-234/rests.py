"""AI-written (Fable, seat tests 2-3-4), 16 November 2026. A search, not a proof.
Set from the stock: is every amount left a rest (level l + g l, take g l, held g l), under every schedule?
And which rest does a start reach: does the dynamics pick the value, or the start?"""
from seat234 import tent, flat, gated, run, every
import contextlib
fams = {'tent 12': (tent(12), 12), 'flat top 6 on 20': (flat(20, 6), 20), 'gated at 2, gives 4, to 12': (gated(2, 4, 12), 12)}
for name, (g, c) in fams.items():
    n = 0; moved = 0
    for l in range(0, c + 1):
        y, x = l + g(l), g(l)
        if y < 1: continue
        for k in (1, 2, 4, 8):
            n += 1
            fate, course = run(g, y, x, x, 'stock', every(k), steps=40)
            if fate[0] != 'goes on' or any(s != (y, x, x) for s in course): moved += 1
    print(f'{name}: starts (l + g l, g l, g l) x schedules {n}; not at rest: {moved}')
g = tent(12)
ends = {}
for y in range(6, 13):
    for x in range(0, 7):
        for k in (1, 4):
            fate, course = run(g, y, x, x, 'stock', every(k), steps=80)
            if fate[0] == 'goes on':
                tail = sorted(set((s[0], s[1]) for s in course[-8:]))
                ends.setdefault(tuple(tail), 0); ends[tuple(tail)] += 1
print('tent 12, starts level 6..12, take 0..6, read every 1 or 4: the (level, take) pairs the course ends in, with counts:')
for k, v in sorted(ends.items()): print('  ', k, v)
