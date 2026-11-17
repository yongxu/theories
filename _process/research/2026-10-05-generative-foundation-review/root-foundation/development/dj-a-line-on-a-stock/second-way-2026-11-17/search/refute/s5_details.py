"""AI-written (Fable). Three details.
(1) Order L, m > a, a stock that gives (min(z,3)): a case where 'what is left at the step the takers
    first go unmet meets the givers' need' (condA) is false and the net never ends, or true and it ends.
(2) The renaming g' in the two-kind world under random table givings (g(0) = 0, nothing above 15):
    courses compared through the net's end, split by m >= a and m < a.
(3) Keeps g' 0 hi for the folded giving: for which hi does it hold (g = 0, a = 2, b*NG = 1)?
"""
import os, random
os.environ["WIDE"] = "1"
from s2_two_kinds import *

g3 = lambda z: min(z, 3)
found = {}
for a, m, t, b, c, k, NG, n0 in worlds():
    if m <= a:
        continue
    for x0 in range(0, 40):
        f = fate2(a, t, b, NG, m, c, k, n0, x0, g3, "L", True)
        cr = run2(a, t, b, NG, m, c, k, n0, x0, g3, "L", N=40)
        j = first_unmet(cr, m)
        hasG, n, xj, zj = cr[j]
        predA = hasG and b >= t and a <= zj
        key = (predA, f[0])
        if key in ((False, "never"), (True, "ends")):
            size = a + m + t + b + c + k + NG + n0 + x0
            if key not in found or size < found[key][0]:
                found[key] = (size, dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0, x0=x0), j, cr[:j + 4])
print("(1) g = min(z,3), order L:")
for key, v in found.items():
    print("   condA", key[0], "fate", key[1], v)

random.seed(99)
res = {"m>=a": [0, 0], "m<a": [0, 0]}
ex = None
for trial in range(60000):
    a, m = random.randint(1, 6), random.randint(1, 6)
    t, b, c = random.randint(0, 2), random.randint(0, 4), random.randint(1, 2)
    k, NG, n0, x0 = random.choice((2, 3)), random.randint(1, 2), random.randint(1, 2), random.randint(0, 20)
    tab = [0] + [random.choice((0, 0, 1, 2, 4, 8)) for _ in range(15)]
    g = lambda z, tab=tab: tab[z] if z < 16 else 0
    gp = lambda z, g=g: g(z) + (b * NG if a <= z else 0)
    c1 = run2(a, t, b, NG, m, c, k, n0, x0, g, "L", N=25)
    c2 = run2(a, t, 0, NG, m, c, k, n0, x0, gp, "L", N=25)
    key = "m>=a" if m >= a else "m<a"
    res[key][0] += 1
    if [s[:3] for s in c1] != [s[:3] for s in c2]:
        res[key][1] += 1
        if ex is None:
            ex = (dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0, x0=x0), tab,
                  [s[:3] for s in c1[:7]], [s[:3] for s in c2[:7]])
print("(2) random table givings, two kinds, order L: ", {k_: dict(cases=v[0], course_differs=v[1]) for k_, v in res.items()})
print("    first differing:", ex)

a, bN = 2, 1
gp = lambda z: (bN if a <= z else 0)
print("(3) Keeps g' 0 hi, g = 0, a = 2, b*NG = 1: holds for hi in",
      [hi for hi in range(0, 12) if all(x + gp(x) <= hi for x in range(hi + 1))])
