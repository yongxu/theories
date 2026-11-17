"""AI-written (Fable). Past the world of two kinds: where the renaming fails, and what is left.

(a) Random worlds of three kinds in which every unit that gives leaves exactly itself (order L):
    compare the course with givers to the Lean's course (give = 0) under the folded giving
    g'(z) = g(z) + total over giving units u of the START way of give[u]*[need[u] <= z].
    Claim to break: they agree through the end of the net unless some giving unit was unmet earlier.
(b) A worked course: a giver cut off, the level comes back, the giving does not.
(c) Givers that leave more givers. One kind (need a, use t, give b, leaves k of itself), g = 0,
    order L: is 'never ends' exactly (b >= k*t and a <= x0 - t*N0)?
(d) The invariant S1 (order L, any g) and its B counterpart on random worlds: from a configuration
    in the region, is every later configuration in it, with what is left never falling?
(e) C2 (i) with givers that leave two givers, or takers that leave one taker (order L, g = 0).
"""
import random
from itertools import product
from model import *

random.seed(1517)
gs = [("zero", g_zero), ("hump12", hump12), ("min(z,3)", lambda z: min(z, 3)), ("z", lambda z: z)]


def part_a():
    print("== (a) three kinds, givers leave exactly themselves, order L ==")
    tot = differ = fdiff = differ_nocut = 0
    ex = None
    exf = None
    for trial in range(60000):
        K = 3
        need = tuple(random.randint(1, 5) for _ in range(K))
        use = tuple(random.randint(0, 3) for _ in range(K))
        give = [random.choice((0, 0, 1, 2, 3)) for _ in range(K)]
        kids = [tuple(random.randrange(K) for _ in range(random.randint(0, 2))) for _ in range(K)]
        for u in range(K):
            if give[u]:
                kids[u] = (u,)
        # no kind other than a giver leaves a giver (so the number of givers is fixed while met)
        for u in range(K):
            if not give[u]:
                kids[u] = tuple(v for v in kids[u] if not give[v])
        give = tuple(give)
        kids = tuple(kids)
        gname, g = random.choice(gs)
        w0 = tuple(random.randrange(K) for _ in range(random.randint(1, 3)))
        if not any(give[u] for u in w0):
            continue
        x0 = random.randint(0, 14)
        W = World(need, use, give, kids, g)
        cnt = [w0.count(u) for u in range(K)]
        gp = (lambda z, g=g, cnt=cnt: g(z) + sum(cnt[u] * give[u] for u in range(K) if need[u] <= z))
        Wt = World(need, use, (0,) * K, kids, gp)
        tot += 1
        s, st = (w0, x0), (w0, x0)
        cut = False
        d = None
        for j in range(14):
            if s != st and d is None:
                d = j
            if not goes(W, s) or len(s[0]) > 400:
                break
            if any(give[u] and need[u] > s[1] for u in s[0]):
                cut_now = True
            else:
                cut_now = False
            s, st = step(W, s, "L"), step(Wt, st, "L")
            cut = cut or cut_now
            if s != st and d is None and not cut:
                differ_nocut += 1
        if d is not None:
            differ += 1
            c0 = tuple(w0.count(u) for u in range(K))
            f1, f2 = fate(W, c0, x0, "L", N=40), fate(Wt, c0, x0, "L", N=40)
            if f1[0] != f2[0] and "open" not in (f1[0], f2[0]):
                fdiff += 1
                size = sum(need) + sum(use) + sum(give) + len(w0) + x0
                if exf is None or size < exf[0]:
                    exf = (size, gname, W._replace(g=gname), w0, x0, f1, f2)
    print("  worlds with a giver in the start way:", tot, "| course differs from the folded one:", differ,
          "| of these with no giver unmet before the difference:", differ_nocut,
          "| fates differ:", fdiff)
    print("  smallest with different fates:", exf)
    if exf:
        _, gname, Wn, w0, x0, f1, f2 = exf
        g = dict(gs)[gname]
        W = Wn._replace(g=g)
        cnt = [w0.count(u) for u in range(3)]
        gp = (lambda z: g(z) + sum(cnt[u] * W.give[u] for u in range(3) if W.need[u] <= z))
        Wt = World(W.need, W.use, (0, 0, 0), W.kids, gp)
        print("     with givers :", course(W, (w0, x0), 7, "L"))
        print("     folded      :", course(Wt, (w0, x0), 7, "L"))


def part_b():
    print("== (b) a giver cut off; the level comes back; the giving does not ==")
    # G: need 3, use 1, give 1, leaves itself.  T: need 1, use 5, leaves nothing.
    # K: need 1, use 0, leaves itself.  g(z) = min(z, 4).  from ([G, T, K], 7), order L.
    g = lambda z: min(z, 4)
    W = World(need=(3, 1, 1), use=(1, 5, 0), give=(1, 0, 0), kids=((0,), (), (2,)), g=g)
    gp = lambda z: g(z) + (1 if 3 <= z else 0)
    Wt = World(need=(3, 1, 1), use=(1, 5, 0), give=(0, 0, 0), kids=((0,), (), (2,)), g=gp)
    print("  with the giver a unit :", course(W, ((0, 1, 2), 7), 6, "L"))
    print("  giving folded into g' :", course(Wt, ((0, 1, 2), 7), 6, "L"))


def part_c():
    print("== (c) one kind of giver leaving k of itself, g = 0, order L ==")
    tot = nev = bad = opn = 0
    for a, t, b, k, N0, x0 in product(range(1, 5), range(0, 4), range(0, 9), (1, 2, 3), (1, 2, 3),
                                      range(0, 25)):
        W = World((a,), (t,), (b,), ((0,) * k,), g_zero)
        f = fate(W, (N0,), x0, "L", N=200)
        if f[0] == "open":
            opn += 1
            continue
        tot += 1
        nev += f[0] == "never"
        bad += (f[0] == "never") != (b >= k * t and a <= x0 - t * N0)
    print("  decided", tot, "never", nev, "open", opn, "mismatches with (b >= k*t and a <= x0 - t*N0):", bad)
    W = World((1,), (1,), (2,), ((0, 0),), g_zero)
    cs = []
    c, x = (1,), 2
    for j in range(7):
        cs.append((c[0], x))
        c, x, z = cstep(W, c, x, "L")
    print("  need 1, use 1, give 2, leaves two of itself, from one unit at 2: (number, level) =", cs)
    # the same with a stock that gives: is the condition still exact?
    for gname, g in gs[1:]:
        tot = bad1 = bad2 = opn = 0
        for a, t, b, k, N0, x0 in product(range(1, 5), range(0, 4), range(0, 9), (1, 2, 3), (1, 2),
                                          range(0, 25)):
            W = World((a,), (t,), (b,), ((0,) * k,), g)
            f = fate(W, (N0,), x0, "L", N=200, gmono=(gname != "hump12"))
            if f[0] == "open":
                opn += 1
                continue
            tot += 1
            p = (b >= k * t and a <= x0 - t * N0)
            if p and f[0] != "never":
                bad1 += 1
            if (not p) and f[0] == "never":
                bad2 += 1
        print("  with g =", gname, ": decided", tot, "open", opn,
              "| condition true but ends:", bad1, "| condition false but never ends:", bad2)


def part_d():
    print("== (d) the invariant regions on random worlds ==")
    for order, cert in (("L", cert_L), ("B", cert_B)):
        tot = viol = grew = 0
        for trial in range(200000):
            K = random.randint(1, 3)
            need = tuple(random.randint(0, 5) for _ in range(K))
            use = tuple(random.randint(0, 3) for _ in range(K))
            give = tuple(random.randint(0, 6) for _ in range(K))
            kids = tuple(tuple(random.randrange(K) for _ in range(random.randint(1, 2))) for _ in range(K))
            gname, g = random.choice(gs)
            W = World(need, use, give, kids, g)
            c = tuple(random.randint(0, 2) for _ in range(K))
            x = random.randint(0, 20)
            if not cert(W, c, x):
                continue
            tot += 1
            zprev = None
            n0 = sum(c)
            for j in range(12):
                if not cgoes(W, c, x) or not cert(W, c, x):
                    viol += 1
                    break
                nc, nx, z = cstep(W, c, x, order)
                if order == "L" and zprev is not None and z < zprev:
                    viol += 1
                    break
                zprev = z
                c, x = nc, nx
            grew += sum(c) > n0
        print(" order", order, ": starts in the region", tot, "| left it or what is left fell within 12 steps:",
              viol, "| ways that grew:", grew)


def part_e():
    print("== (e) C2 (i) with one premise changed, order L, g = 0, m <= a, c >= 1 ==")
    for label, kG, kT in (("givers leave two givers, takers two takers", 2, 2),
                          ("givers leave themselves, takers leave one taker", 1, 1)):
        tot = nev = opn = 0
        ex = None
        for a, m, t, b, c, NG, n0, x0 in product(range(1, 4), range(1, 4), range(0, 3), range(0, 6),
                                                 (1, 2), (1, 2), (1, 2), range(0, 15)):
            if m > a:
                continue
            W = World((a, m), (t, c), (b, 0), ((0,) * kG, (1,) * kT), g_zero)
            f = fate(W, (NG, n0), x0, "L", N=60)
            tot += 1
            if f[0] == "never":
                nev += 1
            if f[0] == "open":
                opn += 1
            if f[0] != "ends" and ex is None:
                ex = (dict(a=a, m=m, t=t, b=b, c=c, NG=NG, n0=n0, x0=x0), f)
        print(" ", label, ": cases", tot, "never", nev, "open at 60 steps", opn, "| first:", ex)
        if ex:
            p = ex[0]
            W = World((p["a"], p["m"]), (p["t"], p["c"]), (p["b"], 0), ((0,) * kG, (1,) * kT), g_zero)
            c, x = (p["NG"], p["n0"]), p["x0"]
            cs = []
            for j in range(7):
                cs.append((c, x))
                c, x, z = cstep(W, c, x, "L")
            print("     ((givers, takers), level):", cs)


if __name__ == "__main__":
    part_a()
    part_b()
    part_c()
    part_d()
    part_e()
