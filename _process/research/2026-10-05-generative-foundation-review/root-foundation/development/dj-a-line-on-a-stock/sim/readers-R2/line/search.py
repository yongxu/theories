#!/usr/bin/env python3
"""AI-written (Fable, reader), 16 November 2026. Small-model search for a counterexample to
LineOnAStock.falls_to_unmet as written, and counts for need_unmet without `down`.
Model, from the Lean: after need kids w x = concat (kids u if need u <= x else []) for u in w;
step giving H x = (x - H) + giving (x - H) with truncated subtraction; taken = sum of uses."""
import itertools, random, sys

def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x:
            out.extend(kids[u])
    return out

def stepv(g, H, x):
    z = max(x - H, 0)
    return z + g(z)

def course(need, kids, g, use, w, x, n):
    cs = [(list(w), x)]
    for _ in range(n):
        w0, x0 = cs[-1]
        cs.append((after(need, kids, w0, x0), stepv(g, sum(use[u] for u in w0), x0)))
    return cs

def generation(kids, n, w):
    w = list(w)
    for _ in range(n):
        w = [v for u in w for v in kids[u]]
    return w

def descendants(kids, w):
    seen = set(w); todo = list(seen)
    while todo:
        u = todo.pop()
        for v in kids[u]:
            if v not in seen:
                seen.add(v); todo.append(v)
    return seen

def premises(need, kids, gt, use, w, x, hi, want_down):
    U = range(len(need))
    g = lambda z: gt[z] if z < len(gt) else 0
    if g(0) != 0: return None
    if any(z + g(z) > hi for z in range(hi + 1)): return None          # Keeps giving 0 hi
    if any(not use[u] < sum(use[v] for v in kids[u]) for u in U): return None   # grows, every unit
    if any(need[u] == 0 for u in descendants(kids, w)): return None     # Needing, descendants of w
    if x > hi or not w: return None
    if any(need[u] > x for u in w): return None
    down = all(need[v] <= need[u] for u in U for v in kids[u])
    if want_down and not down: return None
    return g, down

def check_falls(need, kids, g, use, w, x, hi):
    """the conclusion of falls_to_unmet; returns the list of witnesses n."""
    cs = course(need, kids, g, use, w, x, hi + 1)
    ok = []
    for n in range(1, hi + 2):
        c3 = all(need[u] <= cs[j][1] for j in range(n) for u in cs[j][0])
        c4 = all(cs[j][0] == generation(kids, j, w) for j in range(n + 1))
        c5 = any(cs[n][1] < need[u] for u in cs[n][0])
        c6 = any(need[p] <= x and cs[n][1] < need[p] for p in w)
        c7 = cs[n][1] < x
        if c3 and c4 and c5 and c6 and c7:
            ok.append(n)
    return ok, cs

def check_unmet(need, kids, g, use, w, x, hi):
    cs = course(need, kids, g, use, w, x, hi + 1)
    for n in range(1, hi + 2):
        c3 = all(need[u] <= cs[j][1] for j in range(n) for u in cs[j][0])
        c4 = all(cs[j][0] == generation(kids, j, w) for j in range(n + 1))
        c5 = any(cs[n][1] < need[u] for u in cs[n][0])
        if c3 and c4 and c5:
            return n, cs
    return None, cs

def lists(k, maxlen, minlen=0):
    for L in range(minlen, maxlen + 1):
        yield from (list(t) for t in itertools.product(range(k), repeat=L))

def tables(hi):
    """all giving tables on 0..hi with g 0 = 0 and z + g z <= hi."""
    rng = [range(0, 1)] + [range(0, hi - z + 1) for z in range(1, hi + 1)]
    return (list(t) for t in itertools.product(*rng))

stats = dict(cases=0, counter=0, maxratio=(0, None), nodown_cases=0, nodown_level_not_fallen=0,
             nodown_no_start_need_above=0, rise_fail=0, tight=0)

def run(need, kids, gt, use, w, x, hi):
    p = premises(need, kids, gt, use, w, x, hi, want_down=False)
    if p is None: return
    g, down = p
    if down:
        stats['cases'] += 1
        ok, cs = check_falls(need, kids, g, use, w, x, hi)
        if not ok:
            stats['counter'] += 1
            print('COUNTEREXAMPLE falls_to_unmet', need, kids, gt, use, w, x, hi, cs[:4]); sys.exit(1)
        n = ok[0]
        if len(ok) != 1: print('more than one witness', ok)
        # the docstring's "what it takes rises at each of those steps"
        tk = [sum(use[u] for u in cs[j][0]) for j in range(n + 1)]
        if any(not tk[j] < tk[j + 1] for j in range(n)): stats['rise_fail'] += 1
        if n == hi + 1: stats['tight'] += 1
        if n * 1000 // (hi + 1) > stats['maxratio'][0]:
            stats['maxratio'] = (n * 1000 // (hi + 1), (need, kids, gt, use, w, x, hi, n))
    else:
        stats['nodown_cases'] += 1
        n, cs = check_unmet(need, kids, g, use, w, x, hi)
        if n is None:
            print('COUNTEREXAMPLE need_unmet', need, kids, gt, use, w, x, hi); sys.exit(1)
        if not cs[n][1] < x: stats['nodown_level_not_fallen'] += 1
        if not any(cs[n][1] < need[p] for p in w): stats['nodown_no_start_need_above'] += 1

# 1. exhaustive: two kinds, hi <= 3, kids lists up to length 3, uses 0..2, ways of 1..2 units
for hi in range(0, 4):
    for gt in tables(hi):
        for need in itertools.product(range(0, hi + 3), repeat=2):
            for use in itertools.product(range(0, 3), repeat=2):
                for k0 in lists(2, 3):
                    if not use[0] < sum(use[v] for v in k0): continue
                    for k1 in lists(2, 3):
                        if not use[1] < sum(use[v] for v in k1): continue
                        for w in lists(2, 2, 1):
                            for x in range(hi + 1):
                                run(need, [k0, k1], gt, use, w, x, hi)
print('exhaustive (2 kinds, hi<=3):', stats)

# 2. random: three kinds, hi up to 7
random.seed(20261116)
for _ in range(120000):
    hi = random.randint(1, 7)
    gt = [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]
    k = 3
    need = [random.randint(1, hi + 2) for _ in range(k)]
    if random.random() < 0.7:   # make `down` likely: sort so that kids come from kinds needing no more
        need.sort(reverse=True)
    use = [random.randint(0, 2) for _ in range(k)]
    kids = []
    for u in range(k):
        pool = [v for v in range(k) if need[v] <= need[u]] if random.random() < 0.8 else list(range(k))
        kids.append([random.choice(pool) for _ in range(random.randint(1, 3))])
    w = [random.randrange(k) for _ in range(random.randint(1, 2))]
    x = random.randint(0, hi)
    run(need, kids, gt, use, w, x, hi)
print('with random (3 kinds, hi<=7):', stats)

# 3. the reader's instance and the file's KidHigherNeed: A=0 need 1, B=1 need 13, use 1, kids [B,B], min z (12-z), ([A],12)
g12 = [min(z, 12 - z) for z in range(13)]
p = premises([1, 13], [[1, 1], [1, 1]], g12, [1, 1], [0], 12, 12, want_down=False)
n, cs = check_unmet([1, 13], [[1, 1], [1, 1]], p[0], [1, 1], [0], 12, 12)
print('KidHigherNeed: premises hold, down =', p[1], '; first unmet step', n, '; course[1] =', cs[1])
# Doubling at 12 on the same giving: n should be 5, levels 12,12,12,12,8,0
p = premises([1], [[0, 0]], g12, [1], [0], 12, 12, want_down=True)
ok, cs = check_falls([1], [[0, 0]], p[0], [1], [0], 12, 12)
print('Doubling: witnesses', ok, 'levels', [c[1] for c in cs[:6]], 'sizes', [len(c[0]) for c in cs[:6]])
