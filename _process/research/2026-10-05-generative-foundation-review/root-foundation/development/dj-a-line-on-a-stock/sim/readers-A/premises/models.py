# AI-written (reader, premises lens), 16 November 2026. A check by computation, not a proof. Seconds only.
import random, itertools
def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x: out += kids[u]
    return out
def taken(use, w): return sum(use[u] for u in w)
def stepf(g, H, x):
    z = x - H if x >= H else 0
    return z + g(z)
def course(need, kids, g, use, w, x, n):
    cs = [(list(w), x)]
    for _ in range(n):
        w, x = cs[-1]
        if len(w) > 4000: break
        cs.append((after(need, kids, w, x), stepf(g, taken(use, w), x)))
    return cs
def goes(need, c): return any(need[u] <= c[1] for u in c[0])
three = lambda z: min(z, 12 - z) if z <= 12 else 0
hump10 = lambda z: min(z, 10 - z) if z <= 10 else 0
show = lambda cs: [(''.join(map(str, w)) if len(w) <= 12 else f'<{len(w)} units>', x) for w, x in cs]

print('KidsNeedMore', show(course({'A':4,'B':9}, {'A':['B','A','B'],'B':['B','B']}, hump10, {'A':2,'B':1}, ['B','A','B'], 8, 3)))
print('  unstated premises of way_ends there: FromNothing', hump10(0) == 0, '; Keeps 0 10', all(x + hump10(x) <= 10 for x in range(11)), '; needs positive True; 8 <= 10 True')
print('Equal one unit', show(course({0:1}, {0:[0]}, three, {0:1}, [0], 12, 3)))
print('ShareRises', show(course({'C':1,'O':1}, {'C':['C'],'O':[]}, three, {'C':2,'O':2}, ['C','O'], 12, 3)))
print('Doubling', [(len(w), x) for w, x in course({0:1}, {0:[0,0]}, three, {0:1}, [0], 12, 5)])
H = dict(need={'A':1,'B':3,'C':12}, kids={'A':['B','B'],'B':['C','B'],'C':['A']}, use={'A':3,'B':1,'C':1})
for x0 in (6, 7):
    cs = course(H['need'], H['kids'], three, H['use'], ['A'], x0, 6)
    print('Higher from', x0, show(cs), 'goes:', [goes(H['need'], c) for c in cs])
print('NoKids', show(course({0:1}, {0:[]}, three, {0:1}, [0], 12, 2)))

# a small model of `fall` (no instance in the module): one unit, need 1, use 7, leaves itself, on three, from 12
cs = course({0:1}, {0:[0]}, three, {0:7}, [0], 12, 6)
print('fall model: over', all(three(z) < 7 for z in range(40)), 'low', three(0) < 1, show(cs))
# a small model of `line_ends` with a proper line: S = {'s'}; 's' doubles, 'o' leaves itself
cs = course({'s':1,'o':1}, {'s':['s','s'],'o':['o']}, three, {'s':1,'o':1}, ['s','o'], 12, 7)
print('line_ends proper line:', show(cs))

# need_unmet: is n = hi + 2 ever the first step with a need unmet?  search worlds with every premise
random.seed(5)
worst = {}
reach = None
for trial in range(60000):
    hi = random.randint(1, 7)
    tab = [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]   # FromNothing, Keeps 0 hi
    g = lambda z, tab=tab: tab[z] if z < len(tab) else 0
    k = random.randint(1, 3)
    need = {i: random.randint(1, hi) for i in range(k)}
    use = {i: random.randint(0, 2) for i in range(k)}
    kids = {i: [random.randrange(k) for _ in range(random.randint(1, 3))] for i in range(k)}
    if not all(use[i] < taken(use, kids[i]) for i in range(k)): continue
    w = [random.randrange(k) for _ in range(random.randint(1, 2))]
    x = random.randint(1, hi)
    if not all(need[u] <= x for u in w): continue
    cs = course(need, kids, g, use, w, x, hi + 3)
    first = next((n for n, c in enumerate(cs) if any(c[1] < need[u] for u in c[0])), None)
    assert first is not None and first >= 1, (hi, tab, need, use, kids, w, x)
    worst[hi] = max(worst.get(hi, 0), first)
    if first == hi + 1 and reach is None: reach = (hi, tab, need, use, kids, w, x)
print('need_unmet: largest first unmet step found, by hi:', dict(sorted(worst.items())), '(hi + 2 would be', {h: h + 2 for h in sorted(worst)}, ')')
print('  a world reaching hi + 1:', reach)
# the unbounded-kind world: kids n = [n+1], use n = n, need 1, giving z = hi - z for z > 0
hi = 5
g = lambda z: (hi - z) if 0 < z <= hi else 0
w, x, n = [0], hi, 0
while all(1 <= x for _ in w) and n < 20:
    w, x, n = [u + 1 for u in w if 1 <= x], stepf(g, sum(w), x), n + 1
print('  chain world hi=5: first unmet step', n, '(hi + 1 =', hi + 1, ')')

# line_ends with only half of `same` (a kid of the line may be outside it; nothing enters it): search for a line never gone
random.seed(7); bad = 0; tried = 0
for trial in range(40000):
    hi = random.randint(1, 8)
    tab = [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]
    g = lambda z, tab=tab: tab[z] if z < len(tab) else 0
    k = random.randint(2, 3)
    S = {i: random.random() < .5 for i in range(k)}
    need = {i: random.randint(1, hi) for i in range(k)}
    use = {i: random.randint(0, 2) for i in range(k)}
    kids = {i: [random.randrange(k) for _ in range(random.randint(0, 3))] for i in range(k)}
    if any(S[v] and not S[u] for u in range(k) for v in kids[u]): continue          # half used: S v -> S u
    if not any(S[u] and not S[v] for u in range(k) for v in kids[u]): continue       # other half broken
    lt = lambda w: sum(use[u] for u in w if S[u])
    if not all(use[u] < lt(kids[u]) for u in range(k) if S[u]): continue
    if not all(need[v] <= need[u] for u in range(k) if S[u] for v in kids[u]): continue
    w = [random.randrange(k) for _ in range(random.randint(1, 3))]
    cs = course(need, kids, g, use, w, random.randint(0, hi), 40)
    tried += 1
    if any(S[u] for u in cs[-1][0]) and len(cs) == 41: bad += 1
print('line_ends with the half of same that is used only:', tried, 'worlds, line still present at step 40 in', bad)
