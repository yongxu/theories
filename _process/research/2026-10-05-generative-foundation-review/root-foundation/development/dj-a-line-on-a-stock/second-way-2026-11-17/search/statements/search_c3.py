"""AI-written (Fable), 17 November 2026. Item 5 (C3): the exact set of (way, level) from which a way
of givers only never ends, in each order.  A search, not a proof.

Range: givings 0, min(z,r) r=1..3, gate(z>=q: r) for (q,r) in (1,1),(2,1),(2,2),(3,2);
a 0..5, t 0..3, b 0..4, G 1..3, x 0..40; both orders.
Never-ends is decided by twokind.givers_only (repeat R, or the saturated-rise invariant S; a = 0: N0).
"""
import time, collections
from twokind import givings, givers_only

def root(geff, d, bound):
    """Least z <= bound with geff(z) >= d (RegimeMargin.Root at a rising giving), or None."""
    for z in range(bound + 1):
        if geff(z) >= d:
            return z
    return None

def simple_guess(order, g, a, t, b, G, x):
    """'every need met and total give >= total use, on what is left'."""
    return b >= t and x - G * t >= a

def exact_L(g, zs, a, t, b, G, x):
    if a == 0: return True
    d = G * t
    geff = lambda z: g(z) + (G * b if a <= z else 0)
    y = root(geff, d, max(zs, a) + 1)          # geff is constant from max(zs, a) on
    return y is not None and x >= a and x >= d + y

def exact_B(g, zs, a, t, b, G, x):
    if a == 0: return True
    d = G * t
    y = root(lambda z: g(z) + G * b, d, zs + 1)
    return x >= a and (G * b >= a or (y is not None and x >= d + y))

def exact_B_g0(a, t, b, G, x):
    return a == 0 or (x >= a and (b >= t or G * b >= a))

def exact_L_g0(a, t, b, G, x):
    return a == 0 or (b >= t and x >= G * t + a)

t0 = time.process_time()
tot = collections.Counter(); bad = collections.defaultdict(list); why = collections.Counter()
for order in 'LB':
    for gv in givings():
        name, g, zs, gsat = gv
        for a in range(0, 6):
            for t in range(0, 4):
                for b in range(0, 5):
                    for G in range(1, 4):
                        for x in range(0, 41):
                            o, w = givers_only(order, name, g, zs, gsat, a, t, b, G, x)
                            nev = (o == 'never')
                            if nev: why[(order, w)] += 1
                            key = (order, name)
                            tot[key] += 1
                            tot[key + ('never',)] += nev
                            for fname, val in (
                                ('simple', simple_guess(order, g, a, t, b, G, x)),
                                ('exact', exact_L(g, zs, a, t, b, G, x) if order == 'L' else exact_B(g, zs, a, t, b, G, x)),
                            ):
                                if val == nev: tot[key + (fname,)] += 1
                                else:
                                    if len(bad[key + (fname,)]) < 3:
                                        bad[key + (fname,)].append(dict(a=a, t=t, b=b, G=G, x=x, never=nev))
                            if name == '0':
                                val = exact_L_g0(a, t, b, G, x) if order == 'L' else exact_B_g0(a, t, b, G, x)
                                if val == nev: tot[key + ('closed_g0',)] += 1
                                else: bad[key + ('closed_g0',)].append(dict(a=a, t=t, b=b, G=G, x=x, never=nev))
                            # the simple guess restricted to a >= 1
                            if a >= 1:
                                tot[key + ('n_a>=1',)] += 1
                                if simple_guess(order, g, a, t, b, G, x) == nev: tot[key + ('simple_a>=1',)] += 1

print('range: a 0..5, t 0..3, b 0..4, G 1..3, x 0..40; per (order, giving):', 6 * 4 * 5 * 3 * 41, 'configurations')
print('how never-ends was decided (order, criterion): ', dict(why))
for order in 'LB':
    for gv in givings():
        key = (order, gv[0]); n = tot[key]
        line = f"{order} g={gv[0]:<14} never {tot[key+('never',)]:>5} of {n} | exact form agrees {tot[key+('exact',)]} of {n} | simple guess agrees {tot[key+('simple',)]} of {n} (a>=1: {tot[key+('simple_a>=1',)]} of {tot[key+('n_a>=1',)]})"
        if gv[0] == '0': line += f" | closed g=0 form agrees {tot[key+('closed_g0',)]} of {n}"
        print(line)
        for f in ('exact', 'closed_g0'):
            if bad.get(key + (f,)): print('   DISAGREE', f, bad[key + (f,)])
        if bad.get(key + ('simple',)): print('   simple guess fails at e.g.', bad[key + ('simple',)][:2])

# validation of the never verdicts: 300 steps of the plain count step, Goes at each
import random
random.seed(3); val = 0
for _ in range(3000):
    order = random.choice('LB'); gv = random.choice(givings()); name, g, zs, gsat = gv
    a = random.randint(1, 5); t = random.randint(0, 3); b = random.randint(0, 4); G = random.randint(1, 3); x = random.randint(0, 40)
    o, w = givers_only(order, name, g, zs, gsat, a, t, b, G, x)
    if o != 'never': continue
    xx = x
    for n in range(300):
        assert xx >= a, (order, name, a, t, b, G, x, n)
        z = max(xx - G * t, 0); gate = z if order == 'L' else xx
        xx = z + g(z) + (G * b if a <= gate else 0)
    val += 1
print(f'never verdicts replayed for 300 steps with every need met at each: {val} sampled, 0 failures')

# two giver kinds: the simple form is said of the way the course comes to, not of the start
import model
need = {'p': 1, 'q': 5}.__getitem__; use = {'p': 0, 'q': 1}.__getitem__; give = lambda u: 0
kids = lambda u: [u]
s = (['p', 'q'], 3)
print('two giver kinds, p (need 1, use 0, give 0) and q (need 5, use 1, give 0), g = 0, from 3:',
      [model.course(need, kids, lambda z: 0, use, s, n, give, 'L') for n in range(4)],
      model.outcome_by_repeat(need, kids, lambda z: 0, use, s, give, 'L'))
print('cpu seconds', round(time.process_time() - t0, 1))
