"""AI-written (Fable, refuter seat), 16 November 2026. My own transcription; a search is not a proof.
Lean definitions transcribed (read at the files, not rebuilt):
  Pace.turn f h : true, p => (f p.1 p.2, h p.1 p.2) ; false, p => (f p.1 p.2, p.2)          Pace.lean:101
  RegimeMargin.step g H x = (x - H) + g (x - H)   (truncated)                               RegimeMargin.lean:249
  Regulation.Between m x y = (m<=x -> m<=y /\ y<=x) /\ (x<=m -> x<=y /\ y<=m)               Regulation.lean:109
Types: S = (take, level), R = held.  f (x,y) m = (A x m, step g x y).  h : S -> R -> R the source.
"""
import random, itertools
random.seed(20261116)

def rstep(g, H, x):
    left = x - H if x >= H else 0
    return left + g(left)
def between(m, x, y):
    return ((not m <= x) or (m <= y <= x)) and ((not x <= m) or (x <= y <= m))
def turn(f, h, b, p):
    s, r = p
    return (f(s, r), h(s, r)) if b else (f(s, r), r)
def tent(hi): return lambda z: min(z, hi - z) if 0 <= z <= hi else 0
def by_one(x, m): return x + 1 if x < m else (x - 1 if x > m else x)
def at_once(x, m): return m
def fast(A, g): return lambda s, m: (A(s[0], m), rstep(g, s[0], s[1]))
def fast2(A, g): return lambda s, m: (A(s[0], m), rstep(g, A(s[0], m), s[1]))   # the take moves first

def course(f, h, reads, c, n):
    out = [c]
    for t in range(n):
        c = turn(f, h, reads(t), c); out.append(c)
    return out

# ---------------- (a) set above the take: adversarial search for the bound (2hi+1)L ----------------
def rand_move():
    memo = {}
    def A(x, m):
        if (x, m) not in memo:
            memo[(x, m)] = m if x == m else (random.randint(x + 1, m) if x < m else random.randint(m, x - 1))
        return memo[(x, m)]
    return A
def rand_above(maxjump):
    memo = {}
    def h(s, m):
        k = (s, m)
        if k not in memo: memo[k] = s[0] + 1 + (random.randint(0, maxjump) if random.random() < 0.5 else 0)
        return memo[k]
    return h
def rand_giving(hi):
    tab = [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]    # g 0 = 0 ; z + g z <= hi : Keeps g 0 hi
    return lambda z: tab[z] if z <= hi else 0
def rand_sched(L):
    # a reading in every window of L consecutive steps
    marks = set(); t = random.randint(0, L - 1)
    while t < 5000:
        marks.add(t); t += random.randint(1, L)
    return lambda t: t in marks

def test_a(trials=40000):
    worst = 0.0; latest = {}
    bad = []
    for _ in range(trials):
        hi = random.randint(1, 9); L = random.randint(1, 4)
        g = rand_giving(hi); A = rand_move(); h0 = rand_above(random.choice([0, 1, 5, 30]))
        order = random.choice(['O1', 'O2']); when = random.choice(['before', 'after'])
        f = fast(A, g) if order == 'O1' else fast2(A, g)
        h = h0 if when == 'before' else (lambda s, m, f=f, h0=h0: h0(f(s, m), m))
        reads = rand_sched(L)
        c = ((random.randint(0, 2 * hi), random.randint(0, hi)), random.randint(0, 2 * hi))
        bound = (2 * hi + 1) * L
        cs = course(f, h, reads, c, bound + 3)
        end = next((t for t, p in enumerate(cs) if p[0][1] == 0), None)
        key = (order, when)
        if end is None or end > bound:
            bad.append((hi, L, order, when, c, end))
        else:
            worst = max(worst, end / bound); latest[key] = max(latest.get(key, 0), end / bound)
    return bad, worst, latest

# premises dropped one at a time, each with a course that goes on (so the conclusion is the conjunction and no more)
def drops():
    g = tent(12); out = {}
    def goes(f, h, reads, c, n=400): return all(p[0][1] >= 1 for p in course(f, h, reads, c, n))
    out['identity move (Between holds by Between.refl; not strictly nearer)'] = goes(fast(lambda x, m: x, g), lambda s, m: s[0] + 1, lambda t: True, ((3, 12), 3))
    out['set at-or-above (h = take), not strictly above'] = goes(fast(by_one, g), lambda s, m: s[0], lambda t: True, ((3, 12), 3))
    out['finitely many readings (reads only before step 3)'] = goes(fast(by_one, g), lambda s, m: s[0] + 1, lambda t: t < 3, ((3, 12), 3))
    out['no ceiling (g z = z)'] = goes(fast(by_one, lambda z: z), lambda s, m: s[0] + 1, lambda t: True, ((0, 2), 1), 60)
    out['something from nothing (g 0 = 1)'] = any(p[0][1] >= 1 for p in course(fast(by_one, lambda z: 1 if z == 0 else 0), lambda s, m: s[0] + 1, lambda t: True, ((0, 1), 1), 400)[300:])
    return out

# is the per-step `rises` of rising_takes_all met?  (use = take, W = (take, held, count), alone = the turn off the level)
def rises_fails():
    g = tent(12); res = {}
    for name, A in (('by one', by_one), ('at once', at_once)):
        for L in (1, 2, 3):
            cs = course(fast(A, g), lambda s, m: s[0] + 1, lambda t: t % L == 0, ((3, 12), 3), 12)
            takes = [p[0][0] for p in cs]
            res[(name, L)] = (takes, sum(1 for j in range(12) if not takes[j] < takes[j + 1]))
    return res

# the one inner step both endings use: at a step where take >= level, the next level is nothing (FromNothing)
def inner_step_is_all(trials=20000):
    ok = 0; n = 0
    for _ in range(trials):
        hi = random.randint(1, 9); g = rand_giving(hi); A = rand_move(); h = rand_above(3)
        c = ((random.randint(0, hi), random.randint(1, hi)), random.randint(0, hi))
        cs = course(fast(A, g), h, lambda t: True, c, 2 * hi + 3)
        end = next(t for t, p in enumerate(cs) if p[0][1] == 0)
        first = next(t for t, p in enumerate(cs) if p[0][0] >= p[0][1])
        n += 1; ok += (end == first + 1) or (end == first == 0)
    return ok, n

# ---------------- (c) from what the stock gave ----------------
def src_gave(g): return lambda s, m: g(s[1] - s[0] if s[1] >= s[0] else 0)
def fate(f, h, L, c, off=0, horizon=3000):
    seen = set(); p = c
    for t in range(horizon):
        if p[0][1] < 1: return 'ends'
        k = (p, t % L)
        if k in seen: return 'goes on'
        seen.add(k); p = turn(f, h, (t % L) == off, p)
    return 'open'
def settle(f, h, L, c, horizon=3000):
    seen = {}; p = c
    for t in range(horizon):
        if p[0][1] < 1: return None
        k = (p, t % L)
        if k in seen: return p
        seen[k] = t; p = turn(f, h, (t % L) == 0, p)

def test_c(hi=12):
    g = tent(hi); out = {}
    # at once, reading every step: D = (level - take) - held conserved while nothing is truncated; tent condition as the seat states it
    f = fast(at_once, g); h = src_gave(g)
    mism = 0; n = 0; cons_bad = 0
    for x in range(0, hi + 1):
        for y in range(x, hi + 1):
            for m in range(0, hi + 1):
                n += 1
                said = (m < y - x) or (m == y - x and 1 <= m < hi)
                mism += (fate(f, h, 1, ((x, y), m)) == 'goes on') != said
                p = ((x, y), m); q = turn(f, h, True, p)
                if q[0][1] >= q[0][0] and (y - x) >= m:
                    cons_bad += ((q[0][1] - q[0][0]) - q[1]) != ((y - x) - m)
    out['at once: seat condition mismatches'] = (mism, n); out['at once: conserved quantity broken'] = cons_bad
    # every amount left is a rest: (take, level, held) = (g z, z + g z, g z)
    for name, A in (('at once', at_once), ('by one', by_one)):
        f = fast(A, g)
        rests = [z for z in range(0, hi + 1) if turn(f, h, True, ((g(z), z + g(z)), g(z))) == ((g(z), z + g(z)), g(z))]
        out[name + ': rests among left 0..hi'] = rests
        # one unit of the stock lost at a rest: does the course return, rest elsewhere, or end
        res = []
        for z in range(1, hi + 1):
            if g(z) < 1: continue
            for d in (-1, +1):
                y = z + g(z) + d
                if y < 1 or y > hi: res.append((z, d, 'out of range' if y > hi else 'ends')); continue
                s = settle(f, h, 1, ((g(z), y), g(z)))
                res.append((z, d, 'ends' if s is None else ('returns' if s == ((g(z), z + g(z)), g(z)) else 'rests at take %d level %d' % (s[0][0], s[0][1]))))
        out[name + ': one unit lost or added at each rest'] = res
    # lagged (by one): is the fate that of the fixed value from the same start (take = held = m0)?
    f = fast(by_one, g); part = []; n = 0
    for L in (1, 2, 3, 4, 5):
        for m0 in range(0, hi + 1):
            for y0 in range(1, hi + 1):
                n += 1
                a = fate(f, h, L, ((m0, y0), m0)); b = fate(f, lambda s, m: m, L, ((m0, y0), m0))
                if a != b: part.append((L, m0, y0, 'stock ' + a, 'fixed ' + b))
    out['by one, start take = held: stock and fixed part at'] = (len(part), n, part[:12])
    return out

# the probe's own settling: tent 12, by one, take 3 held 3, every start level
def probe_rest():
    g = tent(12); f = fast(by_one, g); h = src_gave(g); res = {}
    for y0 in range(1, 13):
        s = settle(f, h, 1, ((3, y0), 3)); res[y0] = None if s is None else (s[0][0], s[0][1], s[1])
    return res

# ---------------- (d) a top ----------------
def test_d():
    bad = 0; n = 0
    for s in range(0, 9):
        for c in range(1, 4):
            for x in range(0, 14):
                if not s <= x + c: continue
                for y in range(0, 14):
                    if not between(s, x, y): continue          # every Between move, strict or not
                    n += 1
                    newheld = min(x + c, s)                    # reading before the step (Pace.turn)
                    bad += not (newheld == s and s <= y + c)
    # where the top helps: tent 12, by one, c = 1, start take 0 held 0, level 12
    g = tent(12); f = fast(by_one, g); tops = {}
    for s in range(1, 13):
        tops[s] = ''.join('.' if fate(f, lambda p, m, s=s: min(p[0] + 1, s), 1, ((0, y0), 0)) == 'goes on' else 'x' for y0 in range(1, 13))
    return bad, n, tops

# ---------------- the lock ----------------
def lock_never_reads():
    # Three.riseShare a g = a + 1 if g else a ; rule true and standing ; use = share ; giving tent 12 ; level 12, share 3
    g = tent(12); a, y = 3, 12; t = 0
    while y >= 1: y = rstep(g, a, y); a += 1; t += 1
    guess = fate(fast(by_one, g), lambda s, m: s[0] + 1, 1, ((3, 12), 3), off=5)   # off=5 with L=1: never reads
    return t, guess

if __name__ == '__main__':
    bad, worst, latest = test_a()
    print('(a) bound (2hi+1)L, 40000 random moves, sources above the take, givings, schedules, both orders, reading before/after:')
    print('    courses past the bound:', len(bad), bad[:3]); print('    latest end / bound:', round(worst, 3), {k: round(v, 3) for k, v in latest.items()})
    print('(a) one premise dropped, the course goes on:'); [print('    ', k, '->', v) for k, v in drops().items()]
    print('(a) rising_takes_all`s `rises` (strict at every step), failures in 12 steps:')
    for k, (takes, fails) in rises_fails().items(): print('    ', k, takes, 'fails at', fails)
    print('(a) end = the step after the first step where take >= level:', inner_step_is_all())
    print('(c)'); [print('    ', k, '->', v) for k, v in test_c().items()]
    print('(c) probe (take 3, held 3, by one, reading every step): rest by start level:', probe_rest())
    b, n, tops = test_d(); print('(d) region kept under every Between move:', n - b, 'of', n)
    print('(d) tent 12, by one, c 1, start take 0 held 0; top s -> start levels 1..12:'); [print('    ', s, v) for s, v in tops.items()]
    print('lock (Three.riseShare, rule standing) never reading ends at step', lock_never_reads())
