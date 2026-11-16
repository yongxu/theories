"""AI-written (Fable, refuter seat), 16 November 2026. Third check: is 'from the stock' ever worse than the fixed value? A search, not a proof."""
import sys, random; sys.path.insert(0, '/Users/ren/theories/tmp/r7/one-model/check/round11/refuter-held-value')
from refute import rstep, turn, tent, by_one, at_once, fast, course, fate, src_gave
random.seed(7)
def refill(hi): return lambda z: hi - z if 1 <= z <= hi else 0
def count(g, hh, A, Ls=(1, 2, 3)):
    f = fast(A, g); h = src_gave(g); worse = []; better = 0; n = 0
    for L in Ls:
        for x in range(hh + 1):
            for mm in range(hh + 1):
                for yy in range(1, hh + 1):
                    n += 1
                    a = fate(f, h, L, ((x, yy), mm)); b = fate(f, lambda s, r: r, L, ((x, yy), mm))
                    if a == 'ends' and b == 'goes on': worse.append((L, x, yy, mm))
                    if a == 'goes on' and b == 'ends': better += 1
    return n, better, worse
for name, g, hh in (('tent 12', tent(12), 12), ('refill 8', refill(8), 8), ('refill 12', refill(12), 12)):
    for mv, A in (('by one', by_one), ('at once', at_once)):
        n, better, worse = count(g, hh, A)
        print(f'{name:9} {mv:7}: starts {n}; stock goes on where fixed ends {better}; stock ends where fixed goes on {len(worse)} e.g. {worse[:2]}')
tot = 0; w = 0; ex = None
for _ in range(60):
    hh = random.randint(3, 8); tab = [0] + [random.randint(0, hh - z) for z in range(1, hh + 1)]
    g = lambda z, tab=tab, hh=hh: tab[z] if z <= hh else 0
    n, better, worse = count(g, hh, by_one, Ls=(1, 2))
    tot += n; w += len(worse)
    if worse and ex is None: ex = (hh, tab, worse[0])
print('60 random givings within a ceiling (by one): starts', tot, '; stock ends where fixed goes on', w, '; first', ex)
if ex:
    hh, tab, (L, x, yy, mm) = ex; g = lambda z: tab[z] if z <= hh else 0
    print('   stock:', [(p[0][0], p[0][1], p[1]) for p in course(fast(by_one, g), src_gave(g), lambda t: t % L == 0, ((x, yy), mm), 9)])
    print('   fixed:', [(p[0][0], p[0][1], p[1]) for p in course(fast(by_one, g), lambda s, r: r, lambda t: True, ((x, yy), mm), 9)])
