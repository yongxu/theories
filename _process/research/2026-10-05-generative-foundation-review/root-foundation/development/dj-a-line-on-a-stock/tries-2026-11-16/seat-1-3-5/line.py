"""AI-written (Fable, seat 1-3-5, round 11), 16 November 2026. A search, not a proof.
In the worked case: do the never-ending starts lie on level = 6a + 3b + c (a, b, c the counts of A, B, C)?"""
import io, contextlib
with contextlib.redirect_stdout(io.StringIO()):
    from higher_start import fate
from itertools import combinations_with_replacement as cwr
on_never = off_never = on_ends = 0; ends_on = []
for n in range(1, 7):
    for combo in cwr('ABC', n):
        w = ''.join(combo); a, b, c = w.count('A'), w.count('B'), w.count('C')
        for x in range(13):
            nev = fate(w, x)[0] == 'never'; on = (x == 6 * a + 3 * b + c)
            if nev and on: on_never += 1
            if nev and not on: off_never += 1
            if on and not nev: on_ends += 1; ends_on.append((w, x))
print('never-ending on the line:', on_never, '; never-ending off it:', off_never, '; on the line and ending:', on_ends)
print('on the line and ending:', ends_on)
