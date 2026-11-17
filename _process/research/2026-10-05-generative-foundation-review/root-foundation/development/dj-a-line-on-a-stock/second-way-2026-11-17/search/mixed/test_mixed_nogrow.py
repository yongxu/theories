"""Variant of test_mixed.py: kids-take premise dropped for set B (kept for A). AI-written (Claude, DJ batch 19), 17 November 2026. Scratch, outside the package, not landed.

A direct run of LineOnAStock's model (after :138, taken :143, left :146, Goes :150, net :158,
RegimeMargin.step) on counts, against the statement tried for a growing line beside units that
leave themselves:

  S kinds 0..s-1: need m, use us[i], kids among S kinds, each use at most what its kids take.
  R kinds: need n, use ur[i], kids [itself]; R not empty.
  H2 = what R takes. Course as it was: the S part by allKids at every step, level under H2 + what
  the S part takes.
  Right side: exists T with m <= X_j for j < T, n <= X_T < m, H2 + y2 <= X_{T+1}.

Premise sets checked:
  A (the reader's): FromNothing, Short g H2 y2, Meets g H2 y2 hi, Keeps g H2 hi, 0 < n <= m,
    n <= H2 + y2, Short g H1 y1 with H1 = H2 + taken c, x < H1 + y1, x <= hi.
  B (the turns reader's): as A but in place of Short g H1 y1 and x < H1 + y1, the course as it was
    comes below n at some step.
The words line, stock, need, use, kids are working names of the model's parts.
"""
import itertools
import random
import sys


def step_level(g, H, x):
    z = max(x - H, 0)
    return z + g(z)


def short(g, H, y):
    return all(g(z) < H for z in range(y))


def meets(g, H, y, hi):
    return all(H <= g(z) for z in range(y, hi + 1) if z + H <= hi)


def keeps(g, H, hi):
    return all(step_level(g, H, x) <= hi for x in range(hi + 1))


def direct_unending(m, n, us, skids, ur, c, x, g, limit=400):
    """Counts: c = counts of S kinds; R counts fixed as len(ur) units each one of a kind."""
    H2 = sum(ur)
    seen = {}
    cc = tuple(c)
    for t in range(limit):
        goes = (n <= x and len(ur) > 0) or (m <= x and any(cc))
        if not goes:
            return False
        key = (cc, x)
        if key in seen:
            return True
        seen[key] = t
        take = H2 + sum(cc[i] * us[i] for i in range(len(us)))
        # after: S units met where m <= x; R units met where n <= x (all R need n)
        if m <= x:
            nc = [0] * len(us)
            for i, k in enumerate(cc):
                for v in skids[i]:
                    nc[v] += k
            nc = tuple(nc)
        else:
            nc = tuple(0 for _ in us)
        rkeep = n <= x
        x = step_level(g, take, x)
        cc = nc
        if not rkeep:
            # R gone: the rest; only S could go on, but S needs m >= n > x ... compute honestly
            # (it never happens while goes held at n <= x)
            pass
        if sum(cc) > 10 ** 6:
            # still growing: keep going on counts
            pass
    return None


def as_it_was(m, us, skids, ur, c, x, g, N):
    H2 = sum(ur)
    out = [x]
    cc = tuple(c)
    for _ in range(N):
        take = H2 + sum(cc[i] * us[i] for i in range(len(us)))
        nc = [0] * len(us)
        for i, k in enumerate(cc):
            for v in skids[i]:
                nc[v] += k
        cc = tuple(nc)
        x = step_level(g, take, x)
        out.append(x)
    return out


def right_side(m, n, H2, y2, X):
    for T in range(len(X) - 1):
        if X[T] < m:
            return n <= X[T] and H2 + y2 <= X[T + 1]
    return None


def main(seed=0, trials=200000):
    rnd = random.Random(seed)
    counts = {"A": [0, 0], "B": [0, 0], "Bonly": [0, 0], "unk": 0}
    bad = []
    for _ in range(trials):
        top = rnd.randint(3, 14)
        vals = [0] + [rnd.randint(0, 6) for _ in range(top)]
        g = (lambda vals: lambda z: vals[z] if z < len(vals) else vals[-1])(vals)
        ns = rnd.randint(1, 2)
        us = [rnd.randint(0, 3) for _ in range(ns)]
        skids = []
        for i in range(ns):
            k = [rnd.randrange(ns) for _ in range(rnd.randint(0, 3))]
            skids.append(k)
        grow_ok = all(us[i] <= sum(us[v] for v in skids[i]) for i in range(ns))
        nr = rnd.randint(1, 2)
        ur = [rnd.randint(0, 3) for _ in range(nr)]
        H2 = sum(ur)
        n = rnd.randint(1, 6)
        m = rnd.randint(n, 9)
        c = [rnd.randint(0, 2) for _ in range(ns)]
        x = rnd.randint(0, 16)
        hi = rnd.randint(x, 18)
        H1 = H2 + sum(c[i] * us[i] for i in range(ns))
        if not keeps(g, H2, hi):
            continue
        y2s = [y for y in range(0, 20) if short(g, H2, y) and meets(g, H2, y, hi) and n <= H2 + y]
        if not y2s:
            continue
        y2 = rnd.choice(y2s)
        X = as_it_was(m, us, skids, ur, c, x, g, 60)
        ends = any(v < n for v in X)
        y1s = [y for y in range(0, 25) if short(g, H1, y) and x < H1 + y]
        prem_A = bool(y1s) and grow_ok
        prem_B = ends
        if not (prem_A or prem_B):
            continue
        d = direct_unending(m, n, us, skids, ur, c, x, g)
        if d is None:
            counts["unk"] += 1
            continue
        r = right_side(m, n, H2, y2, X)
        if r is None:
            r_ok = False
        else:
            r_ok = r
        for name, p in (("A", prem_A), ("B", prem_B)):
            if p:
                counts[name][0] += 1
                if d != r_ok:
                    counts[name][1] += 1
                    if len(bad) < 10:
                        bad.append((name, dict(vals=vals, us=us, skids=skids, ur=ur, n=n, m=m, c=c, x=x,
                                               hi=hi, y2=y2, X=X[:8], direct=d, right=r)))
        if prem_B and not prem_A:
            counts["Bonly"][0] += 1
            counts["Bonly"][1] += int(d != r_ok)
    print("seed", seed, "cases [checked, mismatches]:", counts)
    for b in bad:
        print(b)
    # A implies B?
    return counts


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 0, int(sys.argv[2]) if len(sys.argv) > 2 else 200000)
