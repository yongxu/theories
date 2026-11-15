# AI-written (Fable, a reader who did not write the Lean), 16 November 2026.
# A search, not a proof. For each main law of LineOnAStock.lean: (1) look for a counterexample to the
# statement as written; (2) drop each premise in turn and look for a model where the conclusion fails.
# Ways are kept as counts per kind (every statement tested here is unchanged by reordering a way).
import random, sys, time, itertools
T0 = time.time()
rng = random.Random(20261116)

def hump(c): return lambda z: min(z, max(0, c - z))
def plateau(p): return lambda z: 0 if z == 0 else p            # nothing from nothing, bounded, Keeps fails above 0
def fromnothing(c): return lambda z: max(0, c - z)             # gives c at nothing; Keeps at hi = c
def one_at_zero(z): return 1 if z == 0 else 0                  # gives 1 at nothing; Keeps at hi = 1
def linear(k): return lambda z: k * z                          # unbounded
def table(vals): return lambda z: vals[z] if z < len(vals) else 0
GIV = [("hump%d" % c, hump(c)) for c in (4, 6, 8, 10, 12, 14)]
GIV += [("plateau%d" % p, plateau(p)) for p in (1, 3, 5)]
GIV += [("gives%d-z" % c, fromnothing(c)) for c in (2, 5)]
GIV += [("one_at_zero", one_at_zero), ("3z", linear(3)), ("zero", lambda z: 0)]
for i in range(40):
    vals = [rng.randint(0, 6) for _ in range(rng.randint(3, 14))]
    if rng.random() < 0.7: vals[0] = 0
    GIV.append(("table%s" % vals, table(vals)))
GMAXZ = 60
def gsup(g): return max(g(z) for z in range(GMAXZ)) if g(GMAXZ) <= g(GMAXZ - 1) or g(GMAXZ) == 0 else None  # None = unbounded
def valid_his(g, upto=40): 
    out = []; ok = True
    for h in range(upto + 1):
        ok = ok and (h + g(h) <= upto + 10**9)
        if all(x + g(x) <= h for x in range(h + 1)): out.append(h)
    return out
GINFO = [(n, g, g(0) == 0, valid_his(g), (None if n == "3z" else max(g(z) for z in range(GMAXZ)))) for n, g in GIV]

def rand_struct(K):
    eq = rng.random() < 0.35
    n0 = rng.randint(0, 10)
    need = tuple(n0 if eq else rng.choice((0, 1, 1, 2, 3, 4, 5, 7, 9, 12)) for _ in range(K))
    use = tuple(rng.randint(0, 3) for _ in range(K))
    kids = tuple(tuple(sorted(rng.randrange(K) for _ in range(rng.choice((0, 1, 1, 2, 2, 3))))) for _ in range(K))
    return need, use, kids

def step(st, g, c, x):
    need, use, kids = st
    K = len(need)
    H = sum(c[u] * use[u] for u in range(K))
    new = [0] * K
    for u in range(K):
        if c[u] and need[u] <= x:
            for v in kids[u]: new[v] += c[u]
    e = x - H if x > H else 0
    return tuple(new), e + g(e)

def lineTake(st, S, c): return sum(c[u] * st[1][u] for u in S)
def lineTakeKids(st, S, u): return sum(st[1][v] for v in st[2][u] if v in S)
def same(st, S): return all((v in S) == (u in S) for u in range(len(st[0])) for v in st[2][u])
def grows(st, S): return all(st[1][u] < lineTakeKids(st, S, u) for u in S)
def keepsL(st, S): return all(st[1][u] <= lineTakeKids(st, S, u) for u in S)
def needs(st, S): return all(st[0][u] > 0 for u in S)
def down(st, S): return all(st[0][v] <= st[0][u] for u in S for v in st[2][u])
def goes(st, c, x): return any(c[u] and st[0][u] <= x for u in range(len(c)))

def line_fate(st, g, c, x, S, same_ok, T=120):
    """'gone' / 'stays' (a repeating configuration with a unit of S in it) / 'undet'."""
    seen = {}; hist = []
    for t in range(T):
        pres = any(c[u] for u in S)
        if same_ok and not pres: return 'gone', t
        key = (c, x)
        if key in seen:
            return ('stays' if any(hist[seen[key]:]) else 'gone'), t
        seen[key] = t; hist.append(pres)
        if sum(c) > 10**9: return 'undet', t
        c, x = step(st, g, c, x)
    return 'undet', T

def rand_way(K, allow_empty=False):
    while True:
        c = tuple(rng.choice((0, 0, 1, 1, 2)) for _ in range(K))
        if allow_empty or any(c): return c
def rand_S(K):
    while True:
        S = frozenset(u for u in range(K) if rng.random() < 0.6)
        if S: return S

def show(st, gname, c, x, S=None):
    return "need=%s use=%s kids=%s giving=%s way(counts)=%s level=%s%s" % (st[0], st[1], st[2], gname, c, x, "" if S is None else " S=%s" % sorted(S))

def trace(st, g, c, x, n=8):
    out = []
    for _ in range(n):
        out.append("%s@%d" % (list(c), x)); c, x = step(st, g, c, x)
    return " -> ".join(out)

BUDGET = int(sys.argv[1]) if len(sys.argv) > 1 else 40000
report = []
def run(law, variants, sampler, need_examples=1):
    """variants: dict name -> set of premise names REQUIRED. sampler yields (premise truth dict, conclusion fn, describe fn)."""
    for vname, req in variants.items():
        tested = 0; fail = []; undet = 0; tries = 0
        while tries < BUDGET * 6 and tested < BUDGET and len(fail) < need_examples:
            tries += 1
            inst = sampler(req)
            if inst is None: continue
            tested += 1
            verdict, desc = inst
            if verdict == 'fail': fail.append(desc)
            elif verdict == 'undet': undet += 1
        line = "%-12s %-22s tested=%-6d undetermined=%-4d %s" % (law, vname, tested, undet, ("COUNTERMODEL: " + fail[0]) if fail else "no countermodel")
        print(line, flush=True); report.append(line)

# ---------- Rise (one step) ----------
def s_rise(req):
    K = rng.choice((1, 2, 2, 3)); st = rand_struct(K); S = rand_S(K); c = rand_way(K, True); x = rng.randint(0, 12)
    P = {'grows': grows(st, S), 'met': all(st[0][u] <= x for u in S if c[u])}
    if not all(P[p] for p in req): return None
    if req == {'grows', 'met'} and not any(c[u] for u in S): pass
    c2, _ = step(st, lambda z: 0, c, x)
    ok = lineTake(st, S, c) + sum(c[u] for u in S) <= lineTake(st, S, c2)
    return ('ok' if ok else 'fail'), show(st, "-", c, x, S) + " | S takes %d of the way, %d units, %d of the next way" % (lineTake(st, S, c), sum(c[u] for u in S), lineTake(st, S, c2))
run("rise", {"all premises": {'grows', 'met'}, "drop grows": {'met'}, "drop met": {'grows'}}, s_rise)

# ---------- Fall ----------
def s_fall(req):
    K = rng.choice((1, 2, 2, 3)); st = rand_struct(K); S = rand_S(K)
    gname, g, g0, his, sup = rng.choice(GINFO)
    c = rand_way(K); x = rng.randint(0, 14)
    ns = {st[0][u] for u in S}
    one = len(ns) == 1
    P = {'same': same(st, S), 'one': one, 'keeps': keepsL(st, S),
         'low': all(g(0) < n for n in ns),          # with `one` this is giving 0 < m
         'over': sup is not None and sup < lineTake(st, S, c)}
    if not all(P[p] for p in req): return None
    f, t = line_fate(st, g, c, x, S, P['same'])
    return ({'gone': 'ok', 'stays': 'fail', 'undet': 'undet'}[f]), show(st, gname, c, x, S) + " | course: " + trace(st, g, c, x)
allf = {'same', 'one', 'keeps', 'low', 'over'}
run("fall", dict([("all premises", allf)] + [("drop " + p, allf - {p}) for p in sorted(allf)]), s_fall)

# ---------- A line that grows ends ----------
def s_line(req, whole=False):
    K = rng.choice((1, 2, 2, 3)); st = rand_struct(K); S = frozenset(range(K)) if whole else rand_S(K)
    gname, g, g0, his, sup = rng.choice(GINFO)
    c = rand_way(K); x = rng.randint(0, 14)
    P = {'nothing': g0, 'keeps': bool(his), 'high': any(h >= x for h in his) if 'keeps' in req else True,
         'same': same(st, S), 'grows': grows(st, S), 'needs': needs(st, S), 'down': down(st, S)}
    if not all(P[p] for p in req): return None
    if 'high' not in req and any(h >= x for h in his): return None      # then the law applies as it stands
    f, t = line_fate(st, g, c, x, S, P['same'])
    return ({'gone': 'ok', 'stays': 'fail', 'undet': 'undet'}[f]), show(st, gname, c, x, S) + " | course: " + trace(st, g, c, x)
alll = {'nothing', 'keeps', 'high', 'same', 'grows', 'needs', 'down'}
run("line_ends", dict([("all premises", alll)] + [("drop " + p, alll - {p}) for p in sorted(alll)]), s_line)
allw = alll - {'same'}
run("way_ends", dict([("all premises", allw)] + [("drop " + p, allw - {p}) for p in sorted(allw)]), lambda req: s_line(req | {'same'}, True))

# ---------- A need comes to be unmet ----------
gap = {}
def s_unmet(req):
    K = rng.choice((1, 2, 2, 3)); st = rand_struct(K); S = frozenset(range(K))
    gname, g, g0, his, sup = rng.choice(GINFO)
    c = rand_way(K, True); x = rng.randint(0, 14)
    P = {'nothing': g0, 'keeps': bool(his), 'high': any(h >= x for h in his) if 'keeps' in req else True,
         'grows': grows(st, S), 'needs': needs(st, S), 'ne': any(c), 'met': all(st[0][u] <= x for u in range(K) if c[u])}
    if not all(P[p] for p in req): return None
    if 'high' not in req and any(h >= x for h in his): return None
    hs = [h for h in his if h >= x] if ('keeps' in req and 'high' in req) else []
    hi = min(hs) if hs else None
    lim = (hi + 2) if hi is not None else 60
    cc, xx = c, x; first = None; seen = set()
    for n in range(0, lim + 1):
        if n > 0 and any(cc[u] and xx < st[0][u] for u in range(K)): first = n; break
        if hi is None:
            if (cc, xx) in seen: break
            seen.add((cc, xx))
            if sum(cc) > 10**9: return 'undet', ""
        cc, xx = step(st, g, cc, xx)
    if hi is not None and first is not None:
        gap[first - hi] = gap.get(first - hi, 0) + 1
    return ('ok' if first is not None else 'fail'), show(st, gname, c, x) + " | hi=%s | course: %s" % (hi, trace(st, g, c, x))
allu = {'nothing', 'keeps', 'high', 'grows', 'needs', 'ne', 'met'}
run("need_unmet", dict([("all premises", allu)] + [("drop " + p, allu - {p}) for p in sorted(allu)]), s_unmet)
print("need_unmet: first step with a need unmet, minus the least hi that fits (the Lean's bound allows up to +2):", sorted(gap.items()))

# ---------- What the way takes is less than the level ----------
def s_below(req):
    K = rng.choice((1, 2, 2, 3)); st = rand_struct(K)
    gname, g, g0, his, sup = rng.choice(GINFO)
    c = rand_way(K); x = rng.randint(0, 14)
    P = {'nothing': g0, 'needs': needs(st, range(K))}
    if not all(P[p] for p in req): return None
    cc, xx = c, x; used = False
    for n in range(12):
        c2, x2 = step(st, g, cc, xx)
        if goes(st, c2, x2):
            used = True
            if not (sum(cc[u] * st[1][u] for u in range(K)) < xx):
                return 'fail', show(st, gname, c, x) + " | at step %d: takes %d, level %d, and a need is met at the next step | course: %s" % (n, sum(cc[u] * st[1][u] for u in range(K)), xx, trace(st, g, c, x))
        if sum(c2) > 10**9: break
        cc, xx = c2, x2
    return ('ok' if used else None) and ('ok', "")
run("taken_below", {"all premises": {'nothing', 'needs'}, "drop nothing": {'needs'}, "drop needs": {'nothing'}}, s_below)
print("seconds: %.1f" % (time.time() - T0))
