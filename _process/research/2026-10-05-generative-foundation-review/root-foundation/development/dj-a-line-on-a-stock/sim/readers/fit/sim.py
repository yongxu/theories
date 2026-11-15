# AI-written (Fable), 16 November 2026. A reader's simulation of the candidate L of STEPS-3-7-ON-PAPER.md.
# Not Lean; computed cases only. Runs in seconds.
import random, itertools

def step(giving, H, x):
    z = max(x - H, 0)
    return z + giving(z)

def after(need, kids, w, x):
    out = []
    for u in w:
        if need(u) <= x:
            out.extend(kids(u))
    return out

def taken(use, w): return sum(use(u) for u in w)
def goes(need, w, x): return any(need(u) <= x for u in w)

def run(need, use, kids, giving, w, x, n, cap=4000):
    """returns list of (w, x) up to n steps of the pair's orbit, and the first step where Goes fails (or None)."""
    tr = [(list(w), x)]; ended = None
    for k in range(n):
        if ended is None and not goes(need, w, x): ended = k
        w, x = after(need, kids, w, x), step(giving, taken(use, w), x)
        if len(w) > cap: tr.append((w[:3] + ['...%d' % len(w)], x)); break
        tr.append((list(w), x))
    if ended is None and not goes(need, tr[-1][0], tr[-1][1]) and '...' not in str(tr[-1][0]): ended = len(tr) - 1
    return tr, ended

three = lambda z: min(z, 12 - z) if z <= 12 else 0

print("== 1. a met unit with no kids: the net ends with every need met")
U = {'A': (1, 1, [])}
need = lambda u: U[u][0]; use = lambda u: U[u][1]; kids = lambda u: U[u][2]
tr, e = run(need, use, kids, three, ['A'], 12, 3); print(tr, "Goes first fails at step", e)

print("== 2a. C only-if: kids A=[B], kids B=[A], same need 1, use 1, from 12: way never unchanged by the step, net never ends")
U = {'A': (1, 1, ['B']), 'B': (1, 1, ['A'])}
tr, e = run(need, use, kids, three, ['A'], 12, 8); print(tr, "ended:", e)
print("== 2b. C only-if: a doubler that takes nothing: way never unchanged, net never ends")
U = {'A': (1, 0, ['A', 'A'])}
tr, e = run(need, use, kids, three, ['A'], 6, 6); print([(len(w), x) for w, x in tr], "ended:", e)
print("== 2c. C if-direction without 'way unchanged': Holds (nonempty, needs met, level >= taken+y) then childless: ends")
U = {'A': (1, 0, [])}
tr, e = run(need, use, kids, three, ['A'], 6, 3); print(tr, "ended:", e)

print("== 3. E3: A=(need 1,use 3), B=(need 9,use 2) on Three.giving from 9; kids u=[u]")
U = {'A': (1, 3, ['A']), 'B': (9, 2, ['B'])}
for w in (['B'], ['B', 'A'], ['A']):
    tr, e = run(need, use, kids, three, w, 9, 8); print(w, [(''.join(a), x) for a, x in tr], "ended:", e)
print("   Against's numbers A=(1,4), B=(9,1):")
U = {'A': (1, 4, ['A']), 'B': (9, 1, ['B'])}
tr, e = run(need, use, kids, three, ['B', 'A'], 9, 8); print([(''.join(a), x) for a, x in tr], "ended:", e)

print("== 4. A4: one unit (1,5) from 9 and from 10")
U = {'A': (1, 5, ['A'])}
for x in (9, 10):
    tr, e = run(need, use, kids, three, ['A'], x, 8); print(x, [t[1] for t in tr], "ended:", e)

print("== 5. B: random search. premises: giving 0 = 0, x+giving x <= hi for x <= hi, needs positive, use u < taken(kids u), [need v <= need u]")
def rand_model(rng, order):
    n = rng.randint(1, 4)
    names = list(range(n))
    nd = [rng.randint(1, 6) for _ in names]; us = [rng.randint(0, 3) for _ in names]
    kd = []
    for u in names:
        for _ in range(200):
            k = [rng.choice(names) for _ in range(rng.randint(1, 3))]
            if sum(us[v] for v in k) > us[u] and (not order or all(nd[v] <= nd[u] for v in k)):
                kd.append(k); break
        else: return None
    hi = rng.randint(3, 10)
    g = [0] + [rng.randint(0, hi - z) for z in range(1, hi + 1)]
    return names, nd, us, kd, hi, g
def trial(rng, order, horizon=400):
    m = rand_model(rng, order)
    if m is None: return None
    names, nd, us, kd, hi, g = m
    giving = lambda z: g[z] if z <= hi else 0
    w = [rng.choice(names) for _ in range(rng.randint(1, 3))]; x = rng.randint(0, hi)
    w0, x0 = list(w), x
    maxneed_ok = True; b1 = None
    for k in range(horizon):
        if not any(nd[u] <= x for u in w): return ('ends', k, b1, maxneed_ok, (nd, us, kd, hi, g, w0, x0))
        unmet = any(nd[u] > x for u in w)
        if unmet and b1 is None: b1 = k
        nw = [v for u in w if nd[u] <= x for v in kd[u]]
        if unmet and order and nw and not (max(nd[v] for v in nw) <= x < max(nd[u] for u in w)): maxneed_ok = False
        x = step(giving, sum(us[u] for u in w), x); w = nw
        if len(w) > 3000: return ('big', k, b1, maxneed_ok, (nd, us, kd, hi, g, w0, x0))
    return ('unending?', horizon, b1, maxneed_ok, (nd, us, kd, hi, g, w0, x0))
for order in (True, False):
    rng = random.Random(7); res = {}; worst = 0; ex = None; bad_measure = 0; b1_at0 = 0; tot = 0
    for _ in range(20000):
        t = trial(rng, order)
        if t is None: continue
        tot += 1; res[t[0]] = res.get(t[0], 0) + 1
        if t[0] == 'ends':
            hi = t[4][3]; mx = max(t[4][0])
            worst = max(worst, t[1] - mx * (hi + 3))
        if t[0] != 'ends' and ex is None: ex = t
        if not t[3]: bad_measure += 1
        if t[2] == 0: b1_at0 += 1
    print("order premise", order, "trials", tot, res, "| max(end step - maxneed*(hi+3)):", worst, "| max-need measure violated:", bad_measure, "| some need unmet already at step 0:", b1_at0)
    if ex: print("   not ended within horizon:", ex[0], ex[4])
