"""AI-written (Fable). C2 in the world of two kinds, orders L and B, set to break it.

Givers G: need a, use t, give b, each leaving itself; NG of them.
Takers T: need m, use c, each leaving k takers; n0 of them at the start.
State on counts: (givers present?, number of takers, level).  The Lean's `taken` counts every
unit present, met or not; a unit unmet at a step still takes at that step and is absent after.

fate2 returns ('ends', j) | ('never', why, j) | ('open', N).  'never' is certified only by
  repeat : a configuration seen before;
  invL   : order L, what is left meets every need present, givers give at least what they take,
           takers take nothing (the invariant S1; argued on paper for any g);
  invB   : order B, every need present met at the level and by the givers' total gift alone;
  mono   : givers alone, rising g, level not fallen with the need met (the step is monotone).
"""
import os
import sys
from itertools import product


def run2(a, t, b, NG, m, c, k, n0, x0, g, order, N=120):
    """the course on counts: list of (hasG, n, x, z)"""
    hasG, n, x = NG > 0, n0, x0
    out = []
    for _ in range(N):
        T = (t * NG if hasG else 0) + c * n
        z = x - T if x > T else 0
        gate = z if order == "L" else x
        G = b * NG if (hasG and a <= gate) else 0
        out.append((hasG, n, x, z))
        metG, metT = hasG and a <= x, n > 0 and m <= x
        if not (metG or metT):
            break
        hasG, n, x = metG, (n * k if metT else 0), z + g(z) + G
    return out


def fate2(a, t, b, NG, m, c, k, n0, x0, g, order, gmono, N=120):
    hasG, n, x = NG > 0, n0, x0
    seen = set()
    for j in range(N):
        metG, metT = hasG and a <= x, n > 0 and m <= x
        if not (metG or metT):
            return ("ends", j)
        T = (t * NG if hasG else 0) + c * n
        z = x - T if x > T else 0
        gate = z if order == "L" else x
        G = b * NG if (hasG and a <= gate) else 0
        nx = z + g(z) + G
        if order == "L":
            if (not hasG or (a <= z and b >= t)) and (n == 0 or (c == 0 and m <= z)):
                return ("never", "invL", j)
        else:
            Gt = b * NG if hasG else 0
            if (not hasG or (a <= x and a <= Gt)) and (n == 0 or (m <= x and m <= Gt)):
                return ("never", "invB", j)
        if n == 0 and gmono and metG and nx >= x:
            return ("never", "mono", j)
        key = (hasG, n if c > 0 else (n > 0), x)
        if key in seen:
            return ("never", "repeat", j)
        seen.add(key)
        hasG, n, x = metG, (n * k if metT else 0), nx
    return ("open", N)


def hump12(z):
    return min(z, 12 - z) if z <= 12 else 0


GS = [("zero", lambda z: 0, True, True),          # name, g, rising, bounded
      ("min(z,3)", lambda z: min(z, 3), True, True),
      ("hump12", hump12, False, True),
      ("z", lambda z: z, True, False),
      ("2z", lambda z: 2 * z, True, False)]

RNG = dict(a=range(1, 5), m=range(1, 5), t=range(0, 3), b=range(0, 4), c=range(0, 3),
           k=(2, 3), NG=(1, 2), n0=(1, 2), x0=range(0, 15))
if os.environ.get("WIDE"):   # a wider gap between the needs, for (ii), (iii) and the renaming
    RNG = dict(a=range(1, 4), m=range(1, 13), t=range(0, 2), b=range(0, 4), c=range(1, 3),
               k=(2, 3), NG=(1, 2), n0=(1, 2), x0=range(0, 40))


def worlds():
    for a, m, t, b, c, k, NG, n0 in product(RNG["a"], RNG["m"], RNG["t"], RNG["b"], RNG["c"],
                                           RNG["k"], RNG["NG"], RNG["n0"]):
        yield a, m, t, b, c, k, NG, n0


def part_i():
    print("== C2 (i): m <= a.  counts of fates; x0 in 0..14, both orders ==")
    for order in "LB":
        for name, g, mono, bounded in GS:
            tot = {"c>=1": [0, 0, 0], "c=0": [0, 0, 0]}
            ex = {}
            for a, m, t, b, c, k, NG, n0 in worlds():
                if m > a:
                    continue
                for x0 in RNG["x0"]:
                    f = fate2(a, t, b, NG, m, c, k, n0, x0, g, order, mono)
                    key = "c>=1" if c >= 1 else "c=0"
                    i = {"ends": 0, "never": 1, "open": 2}[f[0]]
                    tot[key][i] += 1
                    if i and key not in ex:
                        ex[key] = (dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0, x0=x0), f)
            print(order, name, {k_: dict(ends=v[0], never=v[1], open=v[2]) for k_, v in tot.items()})
            for k_, e in ex.items():
                print("     first not ending,", k_, e)


def part_i_B_law():
    print("== C2 (i) in order B, g = 0, c >= 1, m <= a: is 'never' exactly (b*NG >= a and x0 >= a)? ==")
    bad = tot = nev = 0
    for a, m, t, b, c, k, NG, n0 in worlds():
        if m > a or c == 0:
            continue
        for x0 in RNG["x0"]:
            f = fate2(a, t, b, NG, m, c, k, n0, x0, GS[0][1], "B", True)
            tot += 1
            nev += f[0] == "never"
            if (f[0] == "never") != (b * NG >= a and x0 >= a):
                bad += 1
    print("  cases", tot, "never", nev, "mismatches", bad)


def first_unmet(course, m):
    """index j of the first step with takers present and unmet, or None"""
    for j, (hasG, n, x, z) in enumerate(course):
        if n > 0 and x < m:
            return j
    return None


def root(gp, H, lim=400):
    for y in range(lim):
        if gp(y) >= H:
            return y
    return None


def part_ii():
    print("== C2 (ii): m > a, c >= 1.  exact conditions tried against the simulated fate ==")
    for order in "LB":
        for name, g, mono, bounded in GS:
            tot = nev = opn = 0
            badA = badB = badH = 0
            noj = 0
            exH = None
            for a, m, t, b, c, k, NG, n0 in worlds():
                if m <= a or c == 0:
                    continue
                for x0 in RNG["x0"]:
                    f = fate2(a, t, b, NG, m, c, k, n0, x0, g, order, mono)
                    if f[0] == "open":
                        opn += 1
                        continue
                    tot += 1
                    never = f[0] == "never"
                    nev += never
                    cr = run2(a, t, b, NG, m, c, k, n0, x0, g, order, N=60)
                    j = first_unmet(cr, m)
                    if j is None:
                        noj += 1
                        continue
                    hasG, n, xj, zj = cr[j]
                    # A: order L with g = 0: givers give at least what they take, and what is left at
                    #    the step the takers first go unmet meets the givers' need
                    predA = hasG and b >= t and a <= zj
                    # B: order B with g = 0
                    predB = hasG and a <= xj and (b * NG >= a or (b >= t and zj + b * NG >= a))
                    # H: Holds at step j+1 for the givers' way under the folded giving
                    #    g'(z) = g(z) + b*NG*[a <= z] (order L) : need met, level >= take + root
                    if hasG and a <= xj and j + 1 < len(cr):
                        x1 = cr[j + 1][2]
                        Hd = t * NG
                        if order == "L":
                            gp = lambda z: g(z) + (b * NG if a <= z else 0)
                        else:   # order B, constant way: the gate read before the take
                            gp = lambda z: g(z) + (b * NG if a <= z + Hd else 0)
                        y = root(gp, Hd)
                        predH = y is not None and a <= x1 and Hd + y <= x1
                    else:
                        predH = False
                    badA += predA != never
                    badB += predB != never
                    if predH != never:
                        badH += 1
                        if exH is None:
                            exH = (dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0, x0=x0), f, j,
                                   cr[:j + 4])
            print(order, name, "decided", tot, "never", nev, "open", opn, "takers never unmet", noj,
                  "| mismatches: condA(L,g=0)", badA, " condB(B,g=0)", badB, " Holds at j+1", badH)
            if exH:
                print("     first mismatch of Holds at j+1:", exH)


def closed_form(a, t, b, NG, m, c, k, n0, x0):
    """order L, g = 0, m > a, c >= 1: the answer from the numbers with no step of the model run:
    X_0 = x0, X_{i+1} = X_i + (b - t) NG - c n0 k^i while it is at least m; j the first i with
    X_i < m; never ends iff b >= t and a <= X_j - t NG - c n0 k^j.  (If what is left at some i < j
    is below a the givers give nothing, X_{i+1} is what is left, below a < m, so j = i + 1 and the
    test fails there too.)"""
    X, i = x0, 0
    while X >= m:
        z = X - t * NG - c * n0 * k ** i
        if z < a:
            return False
        X = z + b * NG
        i += 1
    return b >= t and a <= X - t * NG - c * n0 * k ** i


def part_ii_closed():
    print("== C2 (ii) order L, g = 0: the closed form against the simulated fate ==")
    bad = tot = nev = 0
    for a, m, t, b, c, k, NG, n0 in worlds():
        if m <= a or c == 0:
            continue
        for x0 in range(0, 60):
            f = fate2(a, t, b, NG, m, c, k, n0, x0, GS[0][1], "L", True)
            tot += 1
            nev += f[0] == "never"
            bad += (f[0] == "never") != closed_form(a, t, b, NG, m, c, k, n0, x0)
    print("  cases", tot, "(x0 in 0..59) never", nev, "mismatches", bad)


def part_iii():
    print("== C2 (iii): a higher start ends, a lower start never ends (g = 0, c >= 1) ==")
    for order in "LB":
        best = None
        count = worldsN = 0
        most = (0, None)
        for a, m, t, b, c, k, NG, n0 in worlds():
            if c == 0:
                continue
            worldsN += 1
            fs = [fate2(a, t, b, NG, m, c, k, n0, x0, GS[0][1], order, True)[0] for x0 in range(0, 60)]
            alt = sum(1 for i in range(59) if fs[i] != fs[i + 1])
            if alt > most[0]:
                most = (alt, (dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0),
                              "".join("N" if f == "never" else "e" for f in fs)))
            lo = next((i for i in range(60) if fs[i] == "never"), None)
            if lo is not None and any(fs[i] == "ends" for i in range(lo + 1, 60)):
                count += 1
                hi = next(i for i in range(lo + 1, 60) if fs[i] == "ends")
                size = a + m + t + b + c + k + NG + n0 + hi
                if best is None or size < best[0]:
                    best = (size, dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0), lo, hi)
        print(order, "worlds", worldsN, "with a never-ending start below an ending start (x0 in 0..59):",
              count, "of which m <= a:", "see below")
        print("   smallest:", best)
        if best:
            p = best[1]
            for x0 in (best[2], best[3]):
                print("     from", x0, [(h, n, x, z) for (h, n, x, z) in
                                       run2(p["a"], p["t"], p["b"], p["NG"], p["m"], p["c"], p["k"],
                                            p["n0"], x0, GS[0][1], order, N=8)])
        print("   most changes of fate along x0 = 0..59:", most)
        # does it happen with m <= a ?
        cnt = 0
        for a, m, t, b, c, k, NG, n0 in worlds():
            if c == 0 or m > a:
                continue
            fs = [fate2(a, t, b, NG, m, c, k, n0, x0, GS[0][1], order, True)[0] for x0 in range(0, 60)]
            lo = next((i for i in range(60) if fs[i] == "never"), None)
            if lo is not None and any(fs[i] == "ends" for i in range(lo + 1, 60)):
                cnt += 1
        print("   of which with m <= a:", cnt)


def part_translation():
    print("== The renaming: is the course with givers the Lean's course (give = 0) under")
    print("   g'(z) = g(z) + b*NG*[a <= z] ?  compared step by step through the step the net ends ==")
    for order in "LB":
        for name, g, mono, bounded in GS:
            res = {"m>a": [0, 0, 0], "m<=a": [0, 0, 0]}
            ex = {}
            for a, m, t, b, c, k, NG, n0 in worlds():
                if c == 0:
                    continue
                gp = lambda z: g(z) + (b * NG if a <= z else 0)
                for x0 in RNG["x0"]:
                    c1 = run2(a, t, b, NG, m, c, k, n0, x0, g, order, N=25)
                    c2 = run2(a, t, 0, NG, m, c, k, n0, x0, gp, "L", N=25)
                    key = "m>a" if m > a else "m<=a"
                    res[key][0] += 1
                    L = min(len(c1), len(c2))
                    same = all(c1[i][:3] == c2[i][:3] for i in range(L)) and len(c1) == len(c2)
                    if not same:
                        res[key][1] += 1
                        f1 = fate2(a, t, b, NG, m, c, k, n0, x0, g, order, mono)[0]
                        f2 = fate2(a, t, 0, NG, m, c, k, n0, x0, gp, "L", False)[0]
                        if f1 != f2 and "open" not in (f1, f2):
                            res[key][2] += 1
                            if key not in ex:
                                ex[key] = (dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0, x0=x0),
                                           f1, f2, [s[:3] for s in c1[:6]], [s[:3] for s in c2[:6]])
            print(order, name, {k_: dict(cases=v[0], course_differs=v[1], fate_differs=v[2])
                                for k_, v in res.items()})
            for k_, e in ex.items():
                print("     first with a different fate,", k_, e)


if __name__ == "__main__":
    which = sys.argv[1:] or ["i", "iB", "ii", "iic", "iii", "tr"]
    if "i" in which:
        part_i()
    if "iB" in which:
        part_i_B_law()
    if "ii" in which:
        part_ii()
    if "iic" in which:
        part_ii_closed()
    if "iii" in which:
        part_iii()
    if "tr" in which:
        part_translation()
