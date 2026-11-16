"""AI-written (Fable, seat tests 2-3-4), 16 November 2026. A search, not a proof. Refines part E of seat234.py:
fixed against from-the-stock from one start (held = take), levels within the band the giving keeps."""
from seat234 import tent, flat, gated, run, every, toward
import io, contextlib
fams = {'tent 8': (tent(8), 8), 'tent 12': (tent(12), 12), 'tent 16': (tent(16), 16),
        'flat top 6 on 20': (flat(20, 6), 20), 'flat top 4 on 14': (flat(14, 4), 14),
        'gated at 2, gives 4, to 12': (gated(2, 4, 12), 12)}
for name, (g, c) in fams.items():
    n = 0; diff = []
    for k in (1, 2, 3, 4, 6, 8):
        for y in range(1, c + 1):
            for x in range(0, c + 1):
                n += 1
                f1 = run(g, y, x, x, 'fixed', every(k))[0][0]
                f2 = run(g, y, x, x, 'stock', every(k))[0][0]
                if f1 != f2: diff.append((k, y, x, f1, f2))
    kinds = {}
    for d in diff: kinds[(d[3], d[4])] = kinds.get((d[3], d[4]), 0) + 1
    print(f'{name}: in-band starts x schedules {n}; fates differ at {len(diff)} {kinds}; first {diff[:3]}')
# the two-stroke counter: a take that moves to the held value at once, held set one above the take at every step
x, m = 3, 3; takes = []
for t in range(10):
    takes.append(x); x, m = m, x + 1
print('take at once, held set one above at every step:', takes, '(the lock of Three.rise_count_ends: 3,4,5,6,7,8,9,10)')
# a flat-top course to show the difference of fate from one start
g = flat(20, 6)
print('flat top, start (14, take 7, held 7): fixed', run(g, 14, 7, 7, 'fixed', every(1))[0], '; stock', run(g, 14, 7, 7, 'stock', every(1))[0],
      run(g, 14, 7, 7, 'stock', every(1))[1][:6])
