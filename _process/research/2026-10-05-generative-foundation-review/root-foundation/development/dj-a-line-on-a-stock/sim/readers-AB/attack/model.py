# AI-written (Fable, reader with the attack lens), 16 November 2026. Notes only; nothing here is proved.
# The model of LineOnAStock.lean, transcribed from its definitions (ordered lists, truncated subtraction).
import random


def lvl_step(g, H, x):
    """RegimeMargin.step g H x = (x - H) + g (x - H), truncated."""
    l = x - H if x >= H else 0
    return l + g(l)


class M:
    """need, use: lists over kinds 0..k-1; kids: list of tuples; giving: table then a constant tail."""

    def __init__(self, need, use, kids, gt, tail=0):
        self.need, self.use, self.kids, self.gt, self.tail = need, use, kids, gt, tail
        self.k = len(need)

    def g(self, z):
        return self.gt[z] if z < len(self.gt) else self.tail

    def after(self, w, x):
        return tuple(v for u in w if self.need[u] <= x for v in self.kids[u])

    def taken(self, w):
        return sum(self.use[u] for u in w)

    def step(self, w, x):
        return self.after(w, x), lvl_step(self.g, self.taken(w), x)

    def goes(self, w, x):
        return any(self.need[u] <= x for u in w)

    def course(self, w, x, n):
        out = [(tuple(w), x)]
        for _ in range(n):
            w, x = self.step(w, x)
            out.append((w, x))
        return out

    def orbit(self, w, x, cap_steps=300, cap_len=4000, cap_level=5000):
        """States until the (multiset, level) repeats. Returns (states, index of the repeat) or (states, None)."""
        seen, states = {}, []
        w = tuple(w)
        while True:
            key = (tuple(sorted(w)), x)
            if key in seen:
                return states, seen[key]
            if len(states) >= cap_steps or len(w) > cap_len or x > cap_level:
                return states, None
            seen[key] = len(states)
            states.append((w, x))
            w, x = self.step(w, x)

    def unending(self, w, x):
        """True / False / None (not decided within the caps)."""
        states, c = self.orbit(w, x)
        if any(not self.goes(a, b) for a, b in states):
            return False
        return True if c is not None else None

    def allkids(self, w):
        return tuple(v for u in w for v in self.kids[u])

    def generation(self, n, w):
        w = tuple(w)
        for _ in range(n):
            w = self.allkids(w)
        return w


def keeps(g, H, hi):
    return all(lvl_step(g, H, x) <= hi for x in range(hi + 1))


def short(g, H, y):
    return all(g(z) < H for z in range(y))


def meets(g, H, y, hi):
    return all(H <= g(z) for z in range(y, hi - H + 1)) if hi >= H else True


def regime(m, y, hi, w):
    T = m.taken(w)
    return short(m.g, T, y(T)) and meets(m.g, T, y(T), hi) and keeps(m.g, T, hi)


def holds(m, y, w, x):
    T = m.taken(w)
    return len(w) > 0 and all(m.need[u] <= x for u in w) and T + y(T) <= x


def rand_kids(rng, k, maxlen):
    return [tuple(rng.randrange(k) for _ in range(rng.randint(0, maxlen))) for _ in range(k)]


def rand_giving(rng, hi, want_nothing=None, want_keeps=None, big=None):
    """A table on 0..hi+2 and a tail. want_*: True, False or None (free)."""
    for _ in range(200):
        L = hi + 3
        mode = rng.random()
        if want_keeps is True or (want_keeps is None and mode < 0.5):
            gt = [rng.randint(0, max(hi - z, 0)) for z in range(L)]
        else:
            gt = [rng.randint(0, big if big is not None else hi + 1) for z in range(L)]
        if want_nothing is True:
            gt[0] = 0
        elif want_nothing is False:
            gt[0] = rng.randint(1, hi + 1)
        tail = rng.choice([0, 0, gt[-1]])
        g = lambda z, gt=gt, tail=tail: gt[z] if z < len(gt) else tail
        k = keeps(g, 0, hi)
        if want_keeps is not None and k != want_keeps:
            continue
        if want_nothing is not None and (gt[0] == 0) != want_nothing:
            continue
        return gt, tail
    return None


class Counts:
    """The same model on counts (a way as a multiset): exact for levels, takes, Goes and membership."""

    def __init__(self, need, use, kids, g):
        self.need, self.use, self.kids, self.g, self.k = need, use, kids, g, len(need)

    def step(self, n, x):
        out = [0] * self.k
        for u in range(self.k):
            if n[u] and self.need[u] <= x:
                for v in self.kids[u]:
                    out[v] += n[u]
        return tuple(out), lvl_step(self.g, sum(n[u] * self.use[u] for u in range(self.k)), x)

    def run(self, n, x, steps):
        out = [(tuple(n), x)]
        for _ in range(steps):
            out.append(self.step(*out[-1]))
        return out
