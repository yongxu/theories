"""AI-written (Fable), 17 November 2026. Extra checks beside search_c2.py and search_c3.py.
A search, not a proof.

 (a) order L: which way the guess "what is left at the cut-off step meets the givers' need" fails, per giving
 (b) order L, g = 0: a condition from the start numbers alone (no course run):
       X(j) = x + j*G*(b - t) - N*c*(k^j - 1)/(k - 1);  n* = least j with X(j) < m;
       z(j) = X(j) - G*t - N*k^j*c;   never  <=>  b >= t and z(0) >= a and z(n*) >= a      (m > a >= 1)
 (c) the never verdicts of twokind.run replayed step by step (60 steps, exact integers)
 (d) edges: a = 0, m = 0, c = 0, and an unbounded rising giving g(z) = 2z
 (e) C1 on the list model with give in both orders (three kinds, random worlds)
 (f) order B, Gb >= a, m > a: never ends exactly from starts at or above a
"""
import time, itertools, collections, random
from twokind import givings, run, g_zero
import model

t0 = time.process_time()

# ---------------------------------------------------------------- (a)
print('(a) order L, m > a: the guess "x* >= a and z* >= a" against the outcome')
A = range(1, 4); M = range(1, 6); T = range(0, 3); B = range(0, 4); C = (1, 2); K = (2, 3); GG = (1, 2); NN = (1, 2); X = range(0, 25)
for gv in givings():
    c1 = collections.Counter(); ex = {}
    for a, m, t, b, c, k, G, N in itertools.product(A, M, T, B, C, K, GG, NN):
        if m <= a: continue
        for x in X:
            r = run('L', gv, a, t, b, m, c, k, G, N, x); cut = r['cut']
            guess = cut is not None and cut['x'] >= a and cut['z'] >= a
            nev = r['out'] == 'never'
            tag = ('left meets need, ends' if guess and not nev else 'left below need, never ends' if nev and not guess else 'agree')
            if tag != 'agree': tag += (' [b>=t]' if b >= t else ' [b<t]')
            c1[tag] += 1
            ex.setdefault(tag, dict(a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N, x=x, cut=cut))
    print('  g=%-14s' % gv[0], dict(c1))
    for tag in ex:
        if tag != 'agree': print('      e.g.', tag, ex[tag])

# ---------------------------------------------------------------- (b)
def from_start(a, t, b, m, c, k, G, N, x):
    if b < t: return False
    def Xj(j): return x + j * G * (b - t) - N * c * (k ** j - 1) // (k - 1)
    def zj(j): return Xj(j) - G * t - N * k ** j * c
    j = 0
    while Xj(j) >= m:
        j += 1
        if j > 500: raise RuntimeError('no cut')
    return zj(0) >= a and zj(j) >= a and Xj(j) >= a
ok = bad = 0; badex = []
gv0 = givings()[0]
for a, m, t, b, c, k, G, N in itertools.product(range(1, 5), range(1, 8), range(0, 4), range(0, 5), (1, 2), (2, 3), (1, 2, 3), (1, 2)):
    if m <= a: continue
    for x in range(0, 41):
        r = run('L', gv0, a, t, b, m, c, k, G, N, x)
        if from_start(a, t, b, m, c, k, G, N, x) == (r['out'] == 'never'): ok += 1
        else:
            bad += 1
            if len(badex) < 5: badex.append((a, t, b, m, c, k, G, N, x, r))
print(f'(b) order L, g = 0, m > a >= 1 (the wide range): the condition from the start numbers agrees {ok} of {ok + bad}', badex)

# ---------------------------------------------------------------- (c)
random.seed(7); val = collections.Counter()
for _ in range(20000):
    order = random.choice('LB'); gv = random.choice(givings()); name, g, zs, gsat = gv
    a = random.randint(1, 4); t = random.randint(0, 3); b = random.randint(0, 4)
    m = random.randint(1, 7); c = random.randint(1, 2); k = random.choice((2, 3)); G = random.randint(1, 3); N = random.randint(1, 2); x = random.randint(0, 40)
    r = run(order, gv, a, t, b, m, c, k, G, N, x)
    Gc, Nc, xc = G, N, x
    for n in range(60):
        goes = (Gc > 0 and a <= xc) or (Nc > 0 and m <= xc)
        if r['out'] == 'never': assert goes, (order, name, a, t, b, m, c, k, G, N, x, n)
        else:
            assert goes == (n < r['n_end']) or n > r['n_end'], (order, name, a, t, b, m, c, k, G, N, x, n, r)
            if n == r['n_end']: assert not goes; break
        Tk = Gc * t + Nc * c; z = max(xc - Tk, 0); gate = z if order == 'L' else xc
        x2 = z + g(z) + (Gc * b if (Gc > 0 and a <= gate) else 0)
        Gc, Nc, xc = (Gc if a <= xc else 0), (Nc * k if m <= xc else 0), x2
    val[(r['out'], r['why'])] += 1
print('(c) verdicts of twokind.run replayed (never: Goes at each of 60 steps; ends: Goes up to the end step and not at it):', dict(val), '0 failures')

# ---------------------------------------------------------------- (d)
print('(d) edges')
for order in 'LB':
    n = nev = 0
    for t, b, m, c, k, G, N, x in itertools.product(range(0, 3), range(0, 3), range(1, 5), (1, 2), (2, 3), (1, 2), (1, 2), range(0, 20)):
        n += 1; nev += run(order, gv0, 0, t, b, m, c, k, G, N, x)['out'] == 'never'
    print(f'   a = 0 (givers need nothing), order {order}, g = 0: never ends in {nev} of {n}')
print('   m = 0 (takers need nothing): twokind.run returns never by Z at the first step with a taker; a taker is met at every level and leaves k takers')
# c = 0: takers take nothing, m <= a; list model, the way doubles, so decide by the level resting and every need met
need = lambda u: 1; use = lambda u: 0; kids = lambda u: ['g'] if u == 'g' else ['t', 't']
s = (['g', 't'], 1)
print('   c = 0, a = m = 1, t = b = 0, g = 0, from 1: levels', [model.course(need, kids, g_zero, use, s, n, lambda u: 0, 'L')[1] for n in range(6)],
      'ways', [len(model.course(need, kids, g_zero, use, s, n, lambda u: 0, 'L')[0]) for n in range(6)], '(the level rests at 1, every need met: never ends, m <= a)')
# unbounded rising giving g(z) = 2z, m <= a: x = 3N is kept
need = lambda u: 1; use = lambda u: 0 if u == 'g' else 1; kids = lambda u: ['g'] if u == 'g' else ['t', 't']
s = (['g', 't'], 3)
cs = [model.course(need, kids, lambda z: 2 * z, use, s, n, lambda u: 0, 'L') for n in range(8)]
print('   g(z) = 2z, a = m = 1, t = 0, b = 0, c = 1, k = 2, from 3: levels', [c[1] for c in cs], 'takers', [c[0].count('t') for c in cs], '(level = 3 * takers at every step; never ends, m <= a)')

# ---------------------------------------------------------------- (e)
random.seed(11); pairs = same = viol = 0
for _ in range(4000):
    kinds = 'pqr'
    nd = {u: random.randint(0, 5) for u in kinds}
    kd = {u: [random.choice(kinds) for _ in range(random.randint(0, 2))] for u in kinds}
    w = [random.choice(kinds) for _ in range(random.randint(1, 3))]
    def world():
        us = {u: random.randint(0, 3) for u in kinds}; gi = {u: random.randint(0, 3) for u in kinds}
        r = random.randint(0, 4); return (lambda z: min(z, r)), us.__getitem__, gi.__getitem__, random.choice('LB'), random.randint(0, 12)
    g1, u1, v1, o1, x1 = world(); g2, u2, v2, o2, x2 = world()
    s1, s2 = (list(w), x1), (list(w), x2)
    alike = True
    for j in range(7):
        if len(s1[0]) > 400: break
        if alike:
            pairs += 1
            if s1[0] == s2[0]: same += 1
            else: viol += 1
        # do the two levels meet the same needs of the first course's way at step j?
        if not all((nd[u] <= s1[1]) == (nd[u] <= s2[1]) for u in s1[0]): alike = False
        s1 = model.step(nd.__getitem__, lambda u: list(kd[u]), g1, u1, s1, v1, o1)
        s2 = model.step(nd.__getitem__, lambda u: list(kd[u]), g2, u2, s2, v2, o2)
print(f'(e) C1 with give, any two orders: steps reached with the levels alike at every earlier step: {pairs}; ways the same there: {same}; different: {viol}')

# ---------------------------------------------------------------- (f)
n = okf = 0
for gv in givings():
    for a, m, t, b, c, k, G, N in itertools.product(A, M, T, B, C, K, GG, NN):
        if m <= a or G * b < a: continue
        for x in X:
            n += 1; okf += (run('B', gv, a, t, b, m, c, k, G, N, x)['out'] == 'never') == (x >= a)
print(f'(f) order B, G*b >= a, m > a, all eight givings: "never ends exactly from starts at or above a" agrees {okf} of {n}')
print('cpu seconds', round(time.process_time() - t0, 1))

# ---------------------------------------------------------------- (g)
n = okg = 0
for gv in givings():
    for a, m, t, b, c, k, G, N in itertools.product(A, M, T, B, C, K, GG, NN):
        if m > a: continue
        for x in X:
            n += 1; okg += (run('B', gv, a, t, b, m, c, k, G, N, x)['out'] == 'never') == (x >= a and G * b >= a)
print(f'(g) order B, m <= a, all eight givings: "never ends exactly where x >= a and G*b >= a" agrees {okg} of {n}')
# ---------------------------------------------------------------- (h)
n = lnb = 0
for gv in givings():
    for a, m, t, b, c, k, G, N in itertools.product(A, M, T, B, C, K, GG, NN):
        for x in X:
            if run('L', gv, a, t, b, m, c, k, G, N, x)['out'] == 'never':
                n += 1; lnb += run('B', gv, a, t, b, m, c, k, G, N, x)['out'] == 'never'
print(f'(h) all eight givings, all a, m: of {n} runs that never end in order L, {lnb} never end in order B')
print('cpu seconds', round(time.process_time() - t0, 1))
