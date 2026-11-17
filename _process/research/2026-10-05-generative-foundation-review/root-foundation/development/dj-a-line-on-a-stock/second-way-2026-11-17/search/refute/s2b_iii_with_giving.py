"""AI-written (Fable). C2 (iii) again, asking whether it needs any giving: the smallest worlds with
a never-ending start below an ending one, split by b = 0 (the 'giver' gives nothing) and by
t >= 1 (the giver takes, so it must be given back to). Order L, g = 0, the WIDE ranges."""
import os
os.environ["WIDE"] = "1"
from s2_two_kinds import *

z0 = GS[0][1]
cls = {}
for a, m, t, b, c, k, NG, n0 in worlds():
    fs = [fate2(a, t, b, NG, m, c, k, n0, x0, z0, "L", True)[0] for x0 in range(0, 60)]
    lo = next((i for i in range(60) if fs[i] == "never"), None)
    if lo is None or not any(fs[i] == "ends" for i in range(lo + 1, 60)):
        continue
    hi = next(i for i in range(lo + 1, 60) if fs[i] == "ends")
    key = ("b=0" if b == 0 else "b>=1", "t=0" if t == 0 else "t>=1")
    size = a + m + t + b + c + k + NG + n0 + hi
    alt = sum(1 for i in range(59) if fs[i] != fs[i + 1])
    e = cls.setdefault(key, [0, None, (0, None)])
    e[0] += 1
    if e[1] is None or size < e[1][0]:
        e[1] = (size, dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0), lo, hi)
    if alt > e[2][0]:
        e[2] = (alt, dict(a=a, m=m, t=t, b=b, c=c, k=k, NG=NG, n0=n0),
                "".join("N" if f == "never" else "e" for f in fs))
for key, e in sorted(cls.items()):
    print(key, "worlds:", e[0])
    print("   smallest:", e[1])
    p = e[1][1]
    for x0 in (e[1][2], e[1][3]):
        print("     from", x0, run2(p["a"], p["t"], p["b"], p["NG"], p["m"], p["c"], p["k"], p["n0"],
                                    x0, z0, "L", N=7))
    print("   most changes of fate over x0 = 0..59:", e[2])
