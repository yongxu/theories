"""AI-written (Fable), 17 November 2026. The two-kind world of C2 on counts.

Givers: need a, use t, give b, kids [self].  Takers: need m, use c, give 0, kids k takers.
A way is, up to order, (G givers, N takers); no total in model.py reads the order.

Step at level x (transcribed from model.step; cross-checked against it in __main__):
  T = G*t + N*c ; z = max(x - T, 0)
  L: x' = z + g(z) + (G*b if a <= z else 0)
  B: x' = z + g(z) + (G*b if a <= x else 0)
  G' = G if a <= x else 0 ; N' = k*N if m <= x else 0
Goes: (G > 0 and a <= x) or (N > 0 and m <= x).

"Never ends", decided soundly (no cap is ever relied on; a cap hit raises):
  R  repeat: with the takers gone the configuration (G, x) repeats an earlier one.
  S  saturated rise (givers only): z = x - G*t >= zs where zs is at or above a and the point
     from which g is constant (gsat), and gsat + G*b >= G*t.  Then x' = x + (gsat + G*b - G*t) >= x
     and z' >= z, so the same holds at every later step and a <= x always.
  P  pinned with takers (takers present): every kind present is met at x, z = 0, and x' = x.
     Then G' = G, N' = k*N >= N, T' >= T >= x, so z' = 0 and x'' = x' again, at every later step:
     the level rests while the takers' number grows without bound.
  Z  takers need nothing (m = 0, N > 0): a taker's need is met at every level and it leaves takers.
The searches use c >= 1 and m >= 1 unless they say otherwise; then, g being bounded, the takers' take
k^n*N*c outgrows the level (which rises by at most sup g + G*b a step), so the loop below reaches
"takers unmet", P, or an end.
"""

def g_zero(z): return 0
def g_min(r): return lambda z: min(z, r)
def g_gate(q, r): return lambda z: (r if z >= q else 0)

# (name, function, saturation point, saturated value)
def givings():
    out = [('0', g_zero, 0, 0)]
    for r in (1, 2, 3):
        out.append((f'min(z,{r})', g_min(r), r, r))
    for q, r in ((1, 1), (2, 1), (2, 2), (3, 2)):
        out.append((f'gate(z>={q}:{r})', g_gate(q, r), q, r))
    return out

def givers_only(order, name, g, zs, gsat, a, t, b, G, x, _cache={}):
    """Outcome of G >= 1 givers alone from level x. Returns ('never', why) or ('ends', n)."""
    key = (order, name, a, t, b, G, x)   # keyed by the giving's name (an id can be reused)
    if key in _cache:
        return _cache[key]
    d = G * t
    sat = max(zs, a)
    seen = set()
    n = 0
    x0 = x
    while True:
        if x < a:
            res = ('ends', n); break
        if a == 0:
            # need nothing: met at every level, kids [self]
            res = ('never', 'N0'); break
        if x - d >= sat and gsat + G * b >= d:
            res = ('never', 'S'); break
        if x in seen:
            res = ('never', 'R'); break
        seen.add(x)
        z = max(x - d, 0)
        gate = z if order == 'L' else x
        x = z + g(z) + (G * b if a <= gate else 0)
        n += 1
        if n > 100000:
            raise RuntimeError('cap')
    _cache[(order, name, a, t, b, G, x0)] = res
    return res

def run(order, gv, a, t, b, m, c, k, G, N, x):
    """Returns dict: out in {'ends','never'}, n_end, why, the step the givers first go unmet (gcut,
    None if never), and the numbers at the step the takers first go unmet (cut): step n, level x,
    takers' number N, givers' number G, what is left z, and the level after that step x1."""
    name, g, zs, gsat = gv
    n = 0
    cut = None
    gcut = None
    while True:
        gmet = G > 0 and a <= x
        tmet = N > 0 and m <= x
        if G > 0 and not gmet and gcut is None:
            gcut = n
        if N > 0 and not tmet and cut is None:
            T = G * t + N * c
            z = max(x - T, 0)
            gate = z if order == 'L' else x
            cut = dict(n=n, x=x, N=N, G=G, z=z, x1=z + g(z) + (G * b if (G > 0 and a <= gate) else 0))
        if not (gmet or tmet):
            return dict(out='ends', n_end=n, why='', cut=cut, gcut=gcut)
        if N == 0:
            o, w = givers_only(order, name, g, zs, gsat, a, t, b, G, x)
            if o == 'ends':
                return dict(out='ends', n_end=n + w, why='', cut=cut, gcut=n + w)
            return dict(out='never', n_end=None, why=w, cut=cut, gcut=None)
        if tmet and m == 0:
            return dict(out='never', n_end=None, why='Z', cut=cut, gcut=gcut)
        T = G * t + N * c
        z = max(x - T, 0)
        gate = z if order == 'L' else x
        x2 = z + g(z) + (G * b if (G > 0 and a <= gate) else 0)
        if z == 0 and x2 == x and (G == 0 or a <= x) and tmet:
            return dict(out='never', n_end=None, why='P', cut=cut, gcut=gcut)
        G = G if a <= x else 0
        N = N * k if m <= x else 0
        x = x2
        n += 1
        if n > 2000:
            raise RuntimeError('cap with takers: %r' % ((order, name, a, t, b, m, c, k, G, N, x),))

if __name__ == '__main__':
    # cross-check against the list transcription model.py, on a random sample
    import random, model
    random.seed(15)
    checked = agree = 0
    for _ in range(4000):
        order = random.choice('LB')
        gv = random.choice(givings())
        a = random.randint(0, 4); t = random.randint(0, 3); b = random.randint(0, 4)
        m = random.randint(1, 6); c = random.randint(1, 3); k = random.choice((2, 3))
        G = random.randint(0, 3); N = random.randint(0, 2); x = random.randint(0, 30)
        need = lambda u: a if u == 'g' else m
        use = lambda u: t if u == 'g' else c
        give = lambda u: b if u == 'g' else 0
        kids = lambda u: ['g'] if u == 'g' else ['t'] * k
        s = (['g'] * G + ['t'] * N, x)
        # step by step: same counts and level for 6 steps
        Gc, Nc, xc = G, N, x
        ok = True
        s2 = s
        for j in range(6):
            if len(s2[0]) > 3000: break
            assert (s2[0].count('g'), s2[0].count('t'), s2[1]) == (Gc, Nc, xc), (s2, Gc, Nc, xc)
            T = Gc * t + Nc * c; z = max(xc - T, 0); gate = z if order == 'L' else xc
            x2 = z + gv[1](z) + (Gc * b if a <= gate else 0)
            Gc, Nc, xc = (Gc if a <= xc else 0), (Nc * k if m <= xc else 0), x2
            s2 = model.step(need, kids, gv[1], use, s2, give, order)
        ref = model.outcome_by_repeat(need, kids, gv[1], use, s, give, order, cap=300, maxlen=20000)
        r = run(order, gv, a, t, b, m, c, k, G, N, x)
        if ref[0] == 'unknown':
            continue   # the list model cannot decide a way or level that grows without bound
        checked += 1
        if ref[0] == r['out'] and (ref[0] != 'ends' or ref[1] == r['n_end']):
            agree += 1
        else:
            print('DISAGREE', order, gv[0], a, t, b, m, c, k, G, N, x, ref, r)
    print(f'cross-check with model.py: {agree} of {checked} decided cases agree (4000 drawn; the rest grow without bound in the list model)')
