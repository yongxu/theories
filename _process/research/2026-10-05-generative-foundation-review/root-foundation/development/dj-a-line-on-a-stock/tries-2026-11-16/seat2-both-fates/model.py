# AI-written (Fable, seat 2 of round 11), 16 November 2026. A transcription in Python of
# LineOnAStock's model, for searches. A search by script is not a proof.
#
# Lean (LineOnAStock.lean):
#   after need kids w x  : each unit in turn leaves its kids where need u <= x, nothing otherwise
#   taken use w          : total of the uses of every unit present (met or not)
#   left giving use w x  : RegimeMargin.step giving (taken use w) x = (x - T) + giving (x - T),
#                          natural-number subtraction
#   step                 : (after w x, left w x), both read off the same (w, x)
#   Goes                 : some unit of the way has need <= level
#   net never ends       : Goes at every step of the course (Law.stepWhile_unending_iff)
#
# The fate depends on a way only through how many units of each kind it has (taken is a sum, Goes a
# membership, after a flatMap), so a way is kept here as a tuple of counts. That is an argument on
# paper, not a Lean statement.

def make_world(need, use, kids, g):
    """need, use: tuples by kind; kids: tuple of tuples of kinds; g: list, g[z] for z in 0..hi."""
    K = len(need)
    kc = tuple(tuple(k.count(j) for j in range(K)) for k in kids)
    return (K, tuple(need), tuple(use), kc, tuple(g))


def step(world, c, x):
    K, need, use, kc, g = world
    T = 0
    for i in range(K):
        T += c[i] * use[i]
    z = x - T if x > T else 0
    nx = z + g[z]
    nc = [0] * K
    for i in range(K):
        if c[i] and need[i] <= x:
            row = kc[i]
            for j in range(K):
                nc[j] += c[i] * row[j]
    return tuple(nc), nx


def goes(world, c, x):
    K, need = world[0], world[1]
    for i in range(K):
        if c[i] and need[i] <= x:
            return True
    return False


def never_ends(world, c, x, memo, cap=100000):
    """True where Goes holds at every step of the course from (c, x). Exact where the course is
    eventually periodic or comes to a step with no need met; `cap` guards the rest (raises)."""
    path = []
    on_path = set()
    s = (c, x)
    n = 0
    while True:
        if s in memo:
            r = memo[s]
            break
        if not goes(world, s[0], s[1]):
            r = False
            break
        if s in on_path:
            r = True
            break
        path.append(s)
        on_path.add(s)
        s = step(world, s[0], s[1])
        n += 1
        if n > cap:
            raise RuntimeError("cap reached: fate not decided")
    for t in path:
        memo[t] = r
    return r


def course(world, c, x, n):
    out = [(c, x)]
    for _ in range(n):
        c, x = step(world, c, x)
        out.append((c, x))
    return out


def classify(levels, hi):
    """levels: sorted list of levels in 0..hi from which the net never ends."""
    if not levels:
        return "empty"
    lo, top = levels[0], levels[-1]
    convex = (top - lo + 1 == len(levels))
    if convex and top == hi:
        return "up-set"
    if convex:
        return "interval"
    return "neither"


def multisets(K, size):
    """All count tuples over K kinds with the given total."""
    if K == 1:
        yield (size,)
        return
    for a in range(size + 1):
        for rest in multisets(K - 1, size - a):
            yield (a,) + rest
