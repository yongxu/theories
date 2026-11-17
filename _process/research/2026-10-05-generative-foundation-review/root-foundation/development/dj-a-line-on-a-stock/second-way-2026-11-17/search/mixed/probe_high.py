"""AI-written (Claude, DJ batch 19), 17 November 2026. Scratch, outside the package, not landed.
Probe: premise set B with the start allowed above hi (x <= hi dropped). Same model as test_mixed.py."""
import random, sys
import test_mixed as t
rnd = random.Random(int(sys.argv[1]) if len(sys.argv) > 1 else 1)
checked = bad = 0
ex = []
for _ in range(200000):
    top = rnd.randint(3, 14)
    vals = [0] + [rnd.randint(0, 6) for _ in range(top)]
    g = (lambda vals: lambda z: vals[z] if z < len(vals) else vals[-1])(vals)
    ns = rnd.randint(1, 2)
    us = [rnd.randint(0, 3) for _ in range(ns)]
    skids = [[rnd.randrange(ns) for _ in range(rnd.randint(0, 3))] for i in range(ns)]
    if not all(us[i] <= sum(us[v] for v in skids[i]) for i in range(ns)):
        continue
    ur = [rnd.randint(0, 3) for _ in range(rnd.randint(1, 2))]
    H2 = sum(ur); n = rnd.randint(1, 6); m = rnd.randint(n, 9)
    c = [rnd.randint(0, 2) for _ in range(ns)]
    x = rnd.randint(0, 18); hi = rnd.randint(0, 18)
    if x <= hi or not t.keeps(g, H2, hi):
        continue
    y2s = [y for y in range(20) if t.short(g, H2, y) and t.meets(g, H2, y, hi) and n <= H2 + y]
    if not y2s: continue
    y2 = rnd.choice(y2s)
    X = t.as_it_was(m, us, skids, ur, c, x, g, 60)
    if not any(v < n for v in X): continue
    d = t.direct_unending(m, n, us, skids, ur, c, x, g)
    r = t.right_side(m, n, H2, y2, X)
    checked += 1
    if d != bool(r):
        bad += 1
        if len(ex) < 3: ex.append(dict(vals=vals, us=us, skids=skids, ur=ur, n=n, m=m, c=c, x=x, hi=hi, y2=y2, X=X[:8], direct=d, right=r))
print("start above hi:", checked, "checked,", bad, "mismatches")
for e in ex: print(e)
