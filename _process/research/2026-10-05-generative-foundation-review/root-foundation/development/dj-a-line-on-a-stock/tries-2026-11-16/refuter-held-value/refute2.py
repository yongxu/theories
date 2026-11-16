"""AI-written (Fable, refuter seat), 16 November 2026. Second checks; a search is not a proof."""
import sys; sys.path.insert(0, '/Users/ren/theories/tmp/r7/one-model/check/round11/refuter-held-value')
from refute import rstep, turn, tent, by_one, at_once, fast, fast2, course, fate, src_gave

# (b) the fixed value: `high` at the arrival level is a premise on the course unless Keeps g 0 hi is asked too.
#     g = 0,1,2,0,2,0,... ; hi 4 ; m 2 ; y 2 : Short g 2 2, Meets g 2 2 4, Keeps g 2 4, FromNothing hold; Keeps g 0 4 fails.
tab = [0, 1, 2, 0, 2, 0, 0, 0, 0]
g = lambda z: tab[z] if z < len(tab) else 0
hi, m, y = 4, 2, 2
assert all(g(z) < m for z in range(y)) and all(g(z) >= m for z in range(y, hi - m + 1)) and all(rstep(g, m, x) <= hi for x in range(hi + 1)) and g(0) == 0
print('(b) Keeps g 0 hi:', all(rstep(g, 0, x) <= hi for x in range(hi + 1)))
cs = course(fast(by_one, g), lambda s, r: r, lambda t: True, ((0, 4), 2), 8)
print('(b) course (take, level), held 2 fixed:', [p[0] for p in cs], '; arrival step 2, level there', cs[2][0][1], '>= m + y =', m + y, 'and it ends')

# (c) the order of reading: the reading sees the level before the step (Pace.turn as the seats chose) or after it.
g = tent(12); f = fast(at_once, g); hb = src_gave(g); ha = lambda s, r: hb(f(s, r), r)
flips = []; n = 0
for x in range(13):
    for yy in range(x, 13):
        for mm in range(13):
            n += 1
            a = fate(f, hb, 1, ((x, yy), mm)); b = fate(f, ha, 1, ((x, yy), mm))
            if a != b: flips.append(((x, yy, mm), 'before: ' + a, 'after: ' + b))
print('(c) at once, tent 12: fate differs between reading before and after the step at', len(flips), 'of', n, 'starts; e.g.', flips[:3])
c = ((0, 6), 7)
print('    start take 0 level 6 held 7, before:', [(p[0][0], p[0][1], p[1]) for p in course(f, hb, lambda t: True, c, 8)])
print('    start take 0 level 6 held 7, after: ', [(p[0][0], p[0][1], p[1]) for p in course(f, ha, lambda t: True, c, 8)])
# same for the other order of taking (the take moves first), by one
f1 = fast(by_one, g); f2 = fast2(by_one, g); fl = 0; n = 0
for x in range(13):
    for yy in range(1, 13):
        for mm in range(13):
            n += 1; fl += fate(f1, hb, 1, ((x, yy), mm)) != fate(f2, lambda s, r: g(max(s[1] - by_one(s[0], r), 0)), 1, ((x, yy), mm))
print('(c) by one, tent 12: fate differs between the two orders of taking at', fl, 'of', n, 'starts')

# (c) stock against fixed from every start (take, level, held), by one, schedules every 1..4
for hh in (8, 12, 16):
    g = tent(hh); f = fast(by_one, g); h = src_gave(g); part = []; n = 0
    for L in (1, 2, 3, 4):
        for x in range(hh + 1):
            for mm in range(hh + 1):
                for yy in range(1, hh + 1):
                    n += 1
                    a = fate(f, h, L, ((x, yy), mm)); b = fate(f, lambda s, r: r, L, ((x, yy), mm))
                    if a != b: part.append((L, x, yy, mm, a, b))
    se = sum(1 for p in part if p[4] == 'ends'); 
    print('(c) tent', hh, ': stock and fixed part at', len(part), 'of', n, 'starts (stock ends, fixed goes on:', se, '; stock goes on, fixed ends:', len(part) - se, ') e.g.', part[:2])
