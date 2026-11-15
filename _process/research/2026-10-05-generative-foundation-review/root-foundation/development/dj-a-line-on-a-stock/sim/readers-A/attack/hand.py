# AI-written (Fable, a reader who did not write the Lean), 16 November 2026.
# Hand models for the premises whose dropping gives a way that grows without repeating (so the random
# search could not decide them), the bound of need_unmet, and alike_one_count on ordered lists.
import itertools, random, time
T0 = time.time()
def step(need, use, kids, g, c, x):
    K = len(need); H = sum(c[u] * use[u] for u in range(K)); new = [0] * K
    for u in range(K):
        if c[u] and need[u] <= x:
            for v in kids[u]: new[v] += c[u]
    e = x - H if x > H else 0
    return tuple(new), e + g(e)
def keeps(g, hi): return all(x + g(x) <= hi for x in range(hi + 1))

print("== line_ends / way_ends / need_unmet with one premise dropped, the doubling unit (kids two copies, use 1)")
# (a) drop `nothing`: giving 1 at nothing and 0 elsewhere; Keeps at hi = 1; need 1; start ([u], 1)
g = lambda z: 1 if z == 0 else 0
c, x = (1,), 1; ok = keeps(g, 1)
for t in range(200):
    ok = ok and c == (2 ** t,) and x == 1
    c, x = step((1,), (1,), ((0, 0),), g, c, x)
print("drop nothing: giving 0 = 1, Keeps at hi 1:", keeps(g, 1), "; 200 steps with level 1 and 2^t units, need met at each:", ok,
      "(for ever: the take is at least the level, so the next level is giving 0 = 1 = the need)")
# (b) drop `needs`: need 0 on hump 12 from 12
g = lambda z: min(z, max(0, 12 - z)); c, x = (1,), 12; ok = keeps(g, 12) and g(0) == 0; lv = []
for t in range(200):
    ok = ok and c == (2 ** t,); lv.append(x)
    c, x = step((0,), (1,), ((0, 0),), g, c, x)
print("drop needs: need 0, hump 12 from 12: 200 steps with 2^t units present:", ok, "; levels", lv[:8], "(a need of nothing is met at every level)")
# (c) drop `keeps` or `high`: giving 3z (Keeps only at hi = 0), need 1, start ([u], 2)
g = lambda z: 3 * z; c, x = (1,), 2; ok = g(0) == 0
for t in range(200):
    ok = ok and c == (2 ** t,) and x == 2 ** (t + 1)
    c, x = step((1,), (1,), ((0, 0),), g, c, x)
print("drop keeps / high: giving 3z, his with Keeps up to 30:", [h for h in range(31) if keeps(g, h)], "; 200 steps with 2^t units at level 2^(t+1):", ok)
g = lambda z: 0 if z <= 3 else 3 * z; c, x = (1,), 8; ok = True
for t in range(60):
    ok = ok and c == (2 ** t,) and x > 2 ** t
    c, x = step((1,), (1,), ((0, 0),), g, c, x)
print("drop high alone: giving 0 up to 3 and 3z above, his with Keeps up to 30:", [h for h in range(31) if keeps(g, h)], "; start 8 > 3; 60 steps with 2^t units and level above the take:", ok)

print("== need_unmet: is the bound hi + 2 reached? exhaustive, K<=2, need in 1..3, use in 0..2, kids up to 3, hi in 1..3, every giving table with giving 0 = 0 and Keeps at hi")
worst = {}; n_inst = 0; example = None
for hi in (1, 2, 3):
    tables = list(itertools.product(*[range(0, hi - z + 1) for z in range(1, hi + 1)]))
    for K in (1, 2):
        kidsets = [m for r in range(4) for m in itertools.combinations_with_replacement(range(K), r)]
        per = [(n, u, k) for n in (1, 2, 3) for u in (0, 1, 2) for k in kidsets]
        for kinds in itertools.product(per, repeat=K):
            need = tuple(k[0] for k in kinds); use = tuple(k[1] for k in kinds); kids = tuple(k[2] for k in kinds)
            if not all(use[u] < sum(use[v] for v in kids[u]) for u in range(K)): continue
            for tb in tables:
                g = lambda z, tb=tb, hi=hi: 0 if z == 0 or z > hi else tb[z - 1]
                for c0 in itertools.product(range(3), repeat=K):
                    if not any(c0): continue
                    for x0 in range(1, hi + 1):
                        if not all(need[u] <= x0 for u in range(K) if c0[u]): continue
                        n_inst += 1; c, x = c0, x0; first = None
                        for n in range(1, hi + 3):
                            c, x = step(need, use, kids, g, c, x)
                            if any(c[u] and x < need[u] for u in range(K)): first = n; break
                        d = None if first is None else first - hi
                        worst[d] = worst.get(d, 0) + 1
                        if d == 1 and example is None: example = (need, use, kids, (0,) + tb, c0, x0, hi, first)
print("instances with every premise of need_unmet:", n_inst, "; first unmet step minus hi -> count:", sorted(worst.items(), key=lambda p: (p[0] is None, p[0])))
print("one at hi + 1 (need, use, kids, giving table from 0, way counts, level, hi, first unmet step):", example)

print("== alike_one_count on ordered lists (random; K<=3, n<=4)")
rng = random.Random(7)
def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x: out += kids[u]
    return out
def crs(need, kids, g, use, w, x, n):
    out = [(list(w), x)]
    for _ in range(n):
        w, x = out[-1]; H = sum(use[u] for u in w); e = max(0, x - H)
        out.append((after(need, kids, w, x), e + g(e)))
    return out
def gen(kids, w, n):
    out = [list(w)]
    for _ in range(n): out.append([v for u in out[-1] for v in kids[u]])
    return out
def rtab():
    vals = [rng.randint(0, 6) for _ in range(rng.randint(2, 12))]
    return lambda z: vals[z] if z < len(vals) else 0
stats = {"full": [0, 0, 0], "premise only for j < n-1": [0, 0, 0], "premise on the first course only": [0, 0, 0]}
ex = {}
for _ in range(60000):
    K = rng.choice((1, 2, 3)); need = [rng.randint(0, 6) for _ in range(K)]
    kids = [[rng.randrange(K) for _ in range(rng.choice((0, 1, 1, 2, 2)))] for _ in range(K)]
    u1 = [rng.randint(0, 2) for _ in range(K)]; u2 = [rng.randint(0, 2) for _ in range(K)]
    g1, g2 = rtab(), rtab(); w = [rng.randrange(K) for _ in range(rng.randint(1, 3))]
    x1, x2 = rng.randint(0, 12), rng.randint(0, 12); n = rng.randint(1, 4)
    c1 = crs(need, kids, g1, u1, w, x1, n); c2 = crs(need, kids, g2, u2, w, x2, n); G = gen(kids, w, n)
    m1 = [all(need[u] <= c1[j][1] for u in G[j]) for j in range(n)]; m2 = [all(need[u] <= c2[j][1] for u in G[j]) for j in range(n)]
    concl = c1[n][0] == G[n] and c2[n][0] == G[n]
    for name, prem in (("full", all(m1) and all(m2)), ("premise only for j < n-1", all(m1[:-1]) and all(m2[:-1])),
                       ("premise on the first course only", all(m1))):
        if prem:
            stats[name][0] += 1
            if G[n]: stats[name][1] += 1
            if not concl:
                stats[name][2] += 1
                ex.setdefault(name, "need=%s kids=%s way=%s n=%d levels1=%s levels2=%s ways1=%s ways2=%s free=%s" % (need, kids, w, n, [s[1] for s in c1], [s[1] for s in c2], [s[0] for s in c1], [s[0] for s in c2], G))
for name, (a, b, f) in stats.items():
    print("%-34s premise held in %d (last generation not empty in %d); conclusion failed in %d%s" % (name, a, b, f, ("; one: " + ex[name]) if name in ex else ""))
print("seconds: %.1f" % (time.time() - T0))
