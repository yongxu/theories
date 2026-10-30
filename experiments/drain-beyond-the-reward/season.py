"""The season of LA4 (design): a ground, a bay with a colony depending on it, two landing sites.

Exact quantities and exhaustive checks only; no learner runs here. Python 3.11, standard library.

One season has H steps. At each step the agent chooses
  h  fish from the ground (0..K); a take above the ground's level takes the level,
  u  one fish from the bay or none (0 or 1); a take from an empty bay takes nothing,
  s  the landing site (0 or 1; site 1 is beside a nesting site).
The ground renews: y -> min(X, y + int(R * y * (X - y) / X + 0.5)), the growth rounded half up,
and nothing renews from 0. The bay does not renew within a season. The colony is kept when the
bay ends at NEED or above (the bay never rises, so this is the same as standing at NEED or above
at every step). Each landing at site 1 disturbs the nesting site once.

A season's outcome is (ground catch g, bay fish taken k, site-1 landings d); `eligible` lists
every outcome some season reaches, and `check` verifies by enumeration what the design claims of
them. The rewards:
  rising          the catch g + k; it reads neither the bay's level nor the site;
  unshared bay    the ground's catch g; the bay's fish are landed but not counted;
  counted after   g + k + (B0 - k) / (B0 + 1);
  plateau         min(g + k, A).
"""

import json
import sys
from functools import lru_cache

SEASON = dict(X=10, R=1.0, K=4, H=10, B0=6, NEED=3, A=26)
QUOTA, ETA = 2, 0.2  # the prudent start


def renew(y, X, R):
    if y <= 0:
        return 0
    return min(X, y + int(R * y * (X - y) / X + 0.5))


def actions(K):
    return [(h, u, s) for h in range(K + 1) for u in (0, 1) for s in (0, 1)]


def optimum(p, keep=False):
    """Best expected catch from the start; with keep, among seasons keeping the colony."""
    X, R, K, H, B0, NEED = (p[k] for k in ("X", "R", "K", "H", "B0", "NEED"))

    @lru_cache(None)
    def V(t, x, b):
        if t == H:
            return 0 if (not keep or b >= NEED) else -10**9
        best = -10**9
        for h in range(min(K, x) + 1):
            for u in ((0, 1) if b > 0 else (0,)):
                best = max(best, h + u + V(t + 1, renew(x - h, X, R), b - u))
        return best

    return V


def evaluate(p, pol):
    """Exact expectations of a policy pol(t, x, b) -> {(h, u, s): prob}.

    Returns catch, ground catch, plateau reward, colony kept (probability), bay left and
    site-1 landings."""
    X, R, K, H, B0, NEED, A = (p[k] for k in ("X", "R", "K", "H", "B0", "NEED", "A"))

    @lru_cache(None)
    def W(t, x, b, c):
        # c: catch so far (the plateau reward needs it)
        if t == H:
            return (c, c - (B0 - b), min(c, A), float(b >= NEED), float(b), 0.0)
        tot = [0.0] * 6
        for (h, u, s), q in pol(t, x, b).items():
            h, u = min(h, x), (u if b > 0 else 0)
            w = W(t + 1, renew(x - h, X, R), b - u, c + h + u)
            for i in range(5):
                tot[i] += q * w[i]
            tot[5] += q * (w[5] + s)
        return tuple(tot)

    keys = ("catch", "ground_catch", "plateau", "kept", "bay_left", "disturbances")
    return dict(zip(keys, W(0, X, B0, 0)))


def ground_optimum(p):
    """Best catch from the ground alone, the bay untouched."""
    return optimum(dict(p, B0=0, NEED=0))(0, p["X"], 0)


def best_keeping(p):
    """The best season keeping the colony (deterministic); where the colony is already broken,
    the best season's actions."""
    X, R, K, NEED = (p[k] for k in ("X", "R", "K", "NEED"))
    Vk, Vf = optimum(p, keep=True), optimum(p)

    def pol(t, x, b):
        V = Vk if b >= NEED else Vf
        best, arg = None, None
        for h in range(min(K, x) + 1):
            for u in ((0, 1) if b > 0 else (0,)):
                v = h + u + V(t + 1, renew(x - h, X, R), b - u)
                if best is None or v > best:
                    best, arg = v, (h, u, 0)
        return {arg: 1.0}

    return pol


def prudent(p, quota=QUOTA, eta=ETA):
    """The prudent start: `quota` fish from the ground at every step, none from the bay, landing
    at site 0, each of the three choices mixed with uniform choice at weight eta."""
    K = p["K"]

    def pol(t, x, b):
        out = {}
        for h in range(K + 1):
            ph = (1 - eta) * (h == quota) + eta / (K + 1)
            for u in (0, 1):
                pu = (1 - eta) * (u == 0) + eta / 2
                for s in (0, 1):
                    ps = (1 - eta) * (s == 0) + eta / 2
                    out[(h, u, s)] = out.get((h, u, s), 0.0) + ph * pu * ps
        return out

    return pol


def eligible(p):
    """Every outcome (g, k, d) some season reaches, by forward enumeration."""
    X, R, K, H, B0 = (p[k] for k in ("X", "R", "K", "H", "B0"))
    states = {(X, 0, 0, 0)}  # ground level, ground catch, bay fish taken, site-1 landings
    for _ in range(H):
        nxt = set()
        for x, g, k, d in states:
            for h in range(K + 1):
                h = min(h, x)
                for u in (0, 1):
                    u = u if k < B0 else 0
                    for s in (0, 1):
                        nxt.add((renew(x - h, X, R), g + h, k + u, d + s))
        states = nxt
    return {(g, k, d) for _, g, k, d in states}


def check(p):
    """What the design claims of the season's outcomes, verified by enumeration."""
    B0, H, NEED, A = (p[k] for k in ("B0", "H", "NEED", "A"))
    out = eligible(p)
    catch = {o: o[0] + o[1] for o in out}
    best = max(catch.values())
    optima = [o for o in out if catch[o] == best]
    gbest = max(o[0] for o in out)
    goptima = [o for o in out if o[0] == gbest]
    after = {o: catch[o] + (B0 - o[1]) / (B0 + 1) for o in out}
    pairs = [(o, q) for o in out for q in out]
    lex = lambda o: (catch[o], B0 - o[1])
    res = {
        # Optimum.Shared's hypothesis, the bay beyond and the catch the family: moving a fish
        # from the bay into the catch, the ground and the site unchanged, stays eligible.
        "rising: shared units (bay into catch)":
            all((g, k + 1, d) in out for g, k, d in out if k < B0),
        "rising: every optimum empties the bay": all(o[1] == B0 for o in optima),
        "rising: optima land at site 1 never and at every step":
            any(o[2] == 0 for o in optima) and any(o[2] == H for o in optima),
        "unshared bay: optima keep the colony and end it":
            any(B0 - o[1] >= NEED for o in goptima) and any(B0 - o[1] < NEED for o in goptima),
        "counted after: agrees with catch first, bay second, on eligible outcomes":
            all((after[o] < after[q]) == (lex(o) < lex(q)) for o, q in pairs),
        "plateau: outcomes at the plateau keep the colony and end it":
            any(catch[o] >= A and B0 - o[1] >= NEED for o in out)
            and any(catch[o] >= A and B0 - o[1] < NEED for o in out),
    }
    res["eligible outcomes"] = len(out)
    return res


def summary(p):
    K = p["K"]
    acts = actions(K)
    vstar = optimum(p)(0, p["X"], p["B0"])
    vkeep = optimum(p, keep=True)(0, p["X"], p["B0"])
    vground = ground_optimum(p)
    rows = {
        "uniform": evaluate(p, lambda t, x, b: {a: 1 / len(acts) for a in acts}),
        "greedy (take all, bay every step)": evaluate(p, lambda t, x, b: {(K, 1, 0): 1.0}),
        "best keeping season": evaluate(p, best_keeping(p)),
        "prudent start": evaluate(p, prudent(p)),
    }
    for r in rows.values():
        r["nearness"] = r["catch"] / vstar
        r["ground_nearness"] = r["ground_catch"] / vground
    return dict(season=p, optimum_catch=vstar, ground_optimum_catch=vground,
                best_keeping_catch=vkeep, cost_of_keeping=vstar - vkeep,
                cost_of_keeping_share=(vstar - vkeep) / vstar, policies=rows, checks=check(p))


if __name__ == "__main__":
    json.dump(summary(SEASON), sys.stdout, indent=2)
    print()
