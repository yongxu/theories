"""AI-written (Fable). Does a giver lost for good ever change the fate, against the same giving
folded into the stock (which comes back when the level does)?  Order L. Two or three kinds, the giving unit
leaves exactly itself and no other unit leaves it, every giver met at the start; g is a random table on
0..15 with g(0) = 0 and nothing above 15."""
import random
from model import *

random.seed(1711)
best = None
tot = fd = 0
for trial in range(150000):
    K = random.choice((2, 3))
    need = tuple(random.randint(1, 6) for _ in range(K))
    use = tuple(random.randint(0, 3) for _ in range(K))
    give = (random.randint(1, 4),) + (0,) * (K - 1)
    kids = ((0,),) + tuple(tuple(random.randrange(1, K) for _ in range(random.randint(0, 2)))
                           for _ in range(K - 1))
    tab = [0] + [random.choice((0, 0, 0, 1, 2, 4, 8)) for _ in range(15)]
    g = lambda z, tab=tab: tab[z] if z < 16 else 0
    w0 = (0,) + tuple(random.randrange(1, K) for _ in range(random.randint(1, 2)))
    x0 = random.randint(need[0], 12)
    W = World(need, use, give, kids, g)
    gp = lambda z, g=g: g(z) + (give[0] if need[0] <= z else 0)
    Wt = World(need, use, (0,) * K, kids, gp)
    c0 = tuple(w0.count(u) for u in range(K))
    f1, f2 = fate(W, c0, x0, "L", N=40), fate(Wt, c0, x0, "L", N=40)
    tot += 1
    if f1[0] != f2[0] and "open" not in (f1[0], f2[0]):
        fd += 1
        size = sum(need) + sum(use) + sum(give) + len(w0) + x0 + sum(tab)
        if best is None or size < best[0]:
            best = (size, need, use, give, kids, tab, w0, x0, f1, f2)
print("worlds", tot, "fates differ", fd)
print("smallest:", best)
if best:
    _, need, use, give, kids, tab, w0, x0, f1, f2 = best
    K = len(need)
    g = lambda z: tab[z] if z < 16 else 0
    gp = lambda z: g(z) + (give[0] if need[0] <= z else 0)
    print("  with the giver a unit:", course(World(need, use, give, kids, g), (w0, x0), 8, "L"))
    print("  folded into g'       :", course(World(need, use, (0,) * K, kids, gp), (w0, x0), 8, "L"))
