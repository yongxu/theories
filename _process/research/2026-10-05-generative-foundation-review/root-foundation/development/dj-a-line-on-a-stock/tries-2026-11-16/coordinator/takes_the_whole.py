"""AI-written (Fable), 16 November 2026. A search, not a proof.
Model: LineOnAStock. A way is a list of kinds; each kind has need, use, kids. All present take; a unit leaves its
kids where its need is met at the level before the step; level' = (x - T) + g(x - T), T the way's total use, cut at 0.
Statement tried: S a closed line (no kind outside S leaves a kind of S) of one need m > 0, each S-kind's kids of S together
taking more than it; nothing from nothing; the step under no take keeps levels up to hi within hi; start level <= hi;
some unit of S in the start way; EVERY kind outside S needs at least m.  Then: within hi + 1 steps no need is met.
Second question: with some outside kind needing LESS than m, how often does something go on for ever?"""
import random, itertools, sys
random.seed(11)
def step_level(g, T, x):
    left = max(x - T, 0)
    return left + g[left]
def run(kinds, g, w, x, hi, limit):
    """returns the first step at which no need is met, or None if none within limit; cuts off if the way is huge"""
    for n in range(limit + 1):
        if not any(kinds[u][0] <= x for u in w):
            return n
        T = sum(kinds[u][1] for u in w)
        nw = []
        for u in w:
            if kinds[u][0] <= x:
                nw.extend(kinds[u][2])
        x = step_level(g, T, x)
        w = nw
        if len(w) > 4000:
            # take already far above any level: the next level is g[0]; all gone next step if needs positive
            pass
    return None
def lasts(kinds, g, w, x, hi):
    """decides by cycle detection on (sorted way as counts, level) with a cap; returns True if it never ends"""
    seen = set()
    for n in range(400):
        if not any(kinds[u][0] <= x for u in w): return False
        key = (tuple(sorted(w)), x)
        if key in seen: return True
        seen.add(key)
        T = sum(kinds[u][1] for u in w)
        nw = []
        for u in w:
            if kinds[u][0] <= x: nw.extend(kinds[u][2])
        x = step_level(g, T, x); w = nw
        if len(w) > 3000: return False if all(k[0] > 0 for k in kinds) and g[0] == 0 else None
    return None
def givings(hi):
    out = []
    out.append([min(z, hi - z) if z <= hi else 0 for z in range(hi + 1)])            # tent
    out.append([0] * (hi + 1))                                                      # nothing
    out.append([0] + [1] * hi)                                                      # one from anything positive (keeps? checked below)
    for _ in range(3):
        g = [0] + [random.randint(0, hi) for _ in range(hi)]
        out.append(g)
    return out
def keeps(g, hi):
    return all(z + g[z] <= hi for z in range(hi + 1))
stats = dict(tried=0, premises=0, ended_in_time=0, late=0, never=0, worst=0)
bad = []
less = dict(worlds=0, lasts=0, ends=0, example=None)
for trial in range(200000):
    hi = random.randint(2, 9)
    nk = random.randint(2, 4)
    nS = random.randint(1, nk - 1)
    S = set(range(nS))
    m = random.randint(1, hi)
    g = random.choice(givings(hi))
    if not keeps(g, hi): continue
    kinds = []
    for u in range(nk):
        use = random.randint(0, 3)
        if u in S:
            need = m
            kids = [random.randrange(nk) for _ in range(random.randint(0, 3))]
        else:
            need = random.randint(1, hi + 1)
            kids = [random.choice([v for v in range(nk) if v not in S]) for _ in range(random.randint(0, 2))]   # closed: outside leaves no S
        kinds.append((need, use, kids))
    stats['tried'] += 1
    # grows on S: use u < total use of kids in S
    if not all(kinds[u][1] < sum(kinds[v][1] for v in kinds[u][2] if v in S) for u in S): continue
    w = [random.randrange(nk) for _ in range(random.randint(1, 3))]
    if not any(u in S for u in w): continue
    x = random.randint(0, hi)
    outside_ok = all(kinds[u][0] >= m for u in range(nk) if u not in S)
    if outside_ok:
        stats['premises'] += 1
        n = run(kinds, g, w, x, hi, hi + 1)
        if n is not None:
            stats['ended_in_time'] += 1; stats['worst'] = max(stats['worst'], n)
        else:
            r = lasts(kinds, g, w, x, hi)
            if r: stats['never'] += 1
            else: stats['late'] += 1
            if len(bad) < 3: bad.append((hi, m, g, kinds, w, x, r))
    else:
        less['worlds'] += 1
        r = lasts(kinds, g, w, x, hi)
        if r:
            less['lasts'] += 1
            if less['example'] is None: less['example'] = (hi, m, g, kinds, w, x)
        elif r is False: less['ends'] += 1
print('with every outside kind needing at least m:', stats)
print('violations:', bad)
print('with some outside kind needing less than m:', less)
