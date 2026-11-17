"""AI-written (Fable), 17 November 2026. A transcription, for search only, of
Becoming/LineOnAStock.lean (after :138, taken :143, left :146, Goes :150, step :153, net :158)
and RegimeMargin.step (RegimeMargin.lean:249), with one more thing a unit does: give.

A world: kinds 0..K-1 with need[u], use[u], give[u], kids[u] (a tuple of kinds), and a giving g.
A way is a tuple of kinds (the Lean's list, order kept). A configuration is (way, level).

  after(w, x)      = for each u of w in turn: kids[u] if need[u] <= x else nothing   (Lean :138)
  taken(w)         = total of use over w, every unit present, met or not             (Lean :143)
  z                = x - taken(w), truncated at 0                                    (RegimeMargin.step)
  next level, L    = z + g(z) + total of give[u] over u in w with need[u] <= z
  next level, B    = z + g(z) + total of give[u] over u in w with need[u] <= x
  Goes(w, x)       = some u in w with need[u] <= x                                   (Lean :150)
  the net never ends iff Goes at every step of the orbit (GuardedStep.stepWhile_unending_iff :143).

give = 0 is the Lean's step in both orders.
"""
from collections import namedtuple

World = namedtuple("World", "need use give kids g")


def after(W, w, x):
    out = []
    for u in w:
        if W.need[u] <= x:
            out.extend(W.kids[u])
    return tuple(out)


def taken(W, w):
    return sum(W.use[u] for u in w)


def given(W, w, x, order):
    z = max(x - taken(W, w), 0)
    gate = z if order == "L" else x
    return sum(W.give[u] for u in w if W.need[u] <= gate)


def left(W, w, x, order):
    z = max(x - taken(W, w), 0)
    return z + W.g(z) + given(W, w, x, order)


def step(W, s, order):
    w, x = s
    return (after(W, w, x), left(W, w, x, order))


def goes(W, s):
    w, x = s
    return any(W.need[u] <= x for u in w)


def course(W, s, n, order):
    out = [s]
    for _ in range(n):
        s = step(W, s, order)
        out.append(s)
    return out


# ---- the same on counts (a way as a tuple of numbers of each kind): the level and Goes read the
# ---- way only through counts, so fates agree; used where ways grow geometrically.

def cstep(W, c, x, order):
    K = len(c)
    T = sum(c[u] * W.use[u] for u in range(K))
    z = max(x - T, 0)
    gate = z if order == "L" else x
    G = sum(c[u] * W.give[u] for u in range(K) if W.need[u] <= gate)
    nc = [0] * K
    for u in range(K):
        if c[u] and W.need[u] <= x:
            for v in W.kids[u]:
                nc[v] += c[u]
    return tuple(nc), z + W.g(z) + G, z


def cgoes(W, c, x):
    return any(c[u] and W.need[u] <= x for u in range(len(c)))


def reach(W, c):
    """kinds reachable by kids from the kinds present"""
    seen = {u for u in range(len(c)) if c[u]}
    todo = list(seen)
    while todo:
        u = todo.pop()
        for v in W.kids[u]:
            if v not in seen:
                seen.add(v)
                todo.append(v)
    return seen


def cert_L(W, c, x):
    """The invariant S1 (order L, any g): every reachable kind has kids, kids need no more than the
    parent, each gives at least what its kids together take, and what is left meets every need."""
    K = len(c)
    T = sum(c[u] * W.use[u] for u in range(K))
    if x < T:
        return False
    z = x - T
    R = reach(W, c)
    if not R:
        return False
    for u in R:
        if not W.kids[u]:
            return False
        if any(W.need[v] > W.need[u] for v in W.kids[u]):
            return False
        if W.give[u] < sum(W.use[v] for v in W.kids[u]):
            return False
    return all(W.need[u] <= z for u in range(K) if c[u])


def cert_B(W, c, x):
    """Order B: every need met at the level, kids need no more, every kind has kids, kids together
    give at least what the parent gives, and the gift of the way alone meets every need in it."""
    K = len(c)
    R = reach(W, c)
    if not R:
        return False
    for u in R:
        if not W.kids[u]:
            return False
        if any(W.need[v] > W.need[u] for v in W.kids[u]):
            return False
        if W.give[u] > sum(W.give[v] for v in W.kids[u]):
            return False
    if not all(W.need[u] <= x for u in range(K) if c[u]):
        return False
    G = sum(c[u] * W.give[u] for u in range(K))
    return all(W.need[u] <= G for u in range(K) if c[u])


def fate(W, c, x, order, N=80, gmono=False):
    """('ends', step) | ('never', why, step) | ('open', N).
    never is certified by: a configuration seen before (counts and level); the invariant of the
    order; or, for a way whose kinds each leave exactly themselves under a rising giving, a level
    that did not fall with every need met (the step is then monotone in the level)."""
    seen = {}
    for j in range(N + 1):
        if not cgoes(W, c, x):
            return ("ends", j)
        if (c, x) in seen:
            return ("never", "repeat", j)
        seen[(c, x)] = j
        if order == "L" and cert_L(W, c, x):
            return ("never", "invL", j)
        if order == "B" and cert_B(W, c, x):
            return ("never", "invB", j)
        nc, nx, z = cstep(W, c, x, order)
        if gmono and nc == c and nx >= x and order == "L" and \
                all(W.need[u] <= x for u in range(len(c)) if c[u]) and \
                all(W.kids[u] == (u,) for u in range(len(c)) if c[u]):
            return ("never", "mono", j)
        c, x = nc, nx
    return ("open", N)


def g_zero(z):
    return 0


def hump12(z):
    return min(z, 12 - z) if z <= 12 else 0   # Lean: min z (12 - z) with truncated subtraction


def hump10(z):
    return min(z, 10 - z) if z <= 10 else 0
