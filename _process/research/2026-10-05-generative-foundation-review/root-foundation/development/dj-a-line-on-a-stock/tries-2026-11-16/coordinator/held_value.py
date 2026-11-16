"""AI-written (Fable), 16 November 2026. A small probe, not a proof.
A loop holds a take. What it holds (its set level m) is set again at reading steps.
  stock:  y' = (y - x) + g(y - x)      the regime's step under the take x  (g = min z (12 - z), the tent)
  take:   x' = one step from x towards m (never past it)                    the fast loop
  value:  at a reading step m' = h(x, m, y); otherwise m' = m               the slow loop
The net goes on while the stock meets a need of 1.
Three sources for the value, everything else the same:
  fixed          h = m
  from itself    h = x + 1                 (set again one above what it now takes)
  from the stock h = g(left)               (set again to what the stock just gave)
"""
def g(z): return min(z, 12 - z) if 0 <= z <= 12 else 0
def toward(x, m): return x + 1 if x < m else (x - 1 if x > m else x)
def run(y, x, m, source, every, steps=60):
    out = []
    for t in range(steps):
        if y < 1: return out, 'ends at step %d' % t
        out.append((y, x, m))
        left = max(y - x, 0)
        ny = left + g(left)
        nx = toward(x, m)
        if t % every == 0:
            if source == 'itself': m = x + 1
            elif source == 'stock': m = g(left)
        y, x = ny, nx
    return out, 'goes on (60 steps)'
for source in ('fixed', 'itself', 'stock'):
    for every in (1, 4):
        if source == 'fixed' and every == 4: continue
        for y0 in (9, 12):
            course, fate = run(y0, 3, 3, source, every)
            print(f'{source:7} read every {every}, start level {y0}: {fate}; first steps (level, take, held): {course[:9]}')
# how the fate of "from the stock" depends on how often it reads and on the start
print()
for every in (1, 2, 3, 4, 6, 8):
    fates = ''.join('.' if run(y0, 3, 3, 'stock', every)[1].startswith('goes') else 'x' for y0 in range(1, 13))
    print(f'from the stock, read every {every}: start levels 1..12 -> {fates}   (. goes on, x ends)')
for every in (1, 2, 4, 8):
    fates = ''.join('.' if run(y0, 3, 3, 'itself', every)[1].startswith('goes') else 'x' for y0 in range(1, 13))
    print(f'from itself,    read every {every}: start levels 1..12 -> {fates}')
fates = ''.join('.' if run(y0, 3, 3, 'fixed', 1)[1].startswith('goes') else 'x' for y0 in range(1, 13))
print(f'fixed at 3:                    start levels 1..12 -> {fates}')
