# AI-written (Fable, refuter seat, round 11), 16 November 2026. An independent transcription of
# LineOnAStock's model with ways kept as LISTS (not counts), for searches. A search is not a proof.
#   after need kids w x : each unit in turn leaves kids where need u <= x   (LineOnAStock.lean:137)
#   left giving use w x : RegimeMargin.step giving (taken use w) x = (x - T) + giving (x - T)  (:146, RM:249)
#   Goes                : some unit of the way has need <= level            (:150)
import itertools, random, sys

def sub(a, b): return a - b if a >= b else 0

def step(W, w, x):
    need, use, kids, g = W
    T = sum(use[u] for u in w)
    z = sub(x, T)
    return tuple(k for u in w if need[u] <= x for k in kids[u]), z + g(z)

def goes(W, w, x): return any(W[0][u] <= x for u in w)

def never(W, w, x, cap=4000, maxlen=4000):
    seen = set(); s = (w, x)
    for _ in range(cap):
        if not goes(W, *s): return False
        key = (tuple(sorted(s[0])), s[1])           # fate reads a way through its counts (argued on paper)
        if key in seen: return True
        seen.add(key)
        s = step(W, *s)
        if len(s[0]) > maxlen: return None
    return None

def itin(W, w, x, n):
    out = []; s = (w, x)
    for _ in range(n):
        out.append(s[0]); s = step(W, *s)
    return out

tent12 = lambda z: min(z, sub(12, z))
H = (dict(A=1, B=3, C=12), dict(A=3, B=1, C=1), dict(A=('B','B'), B=('C','B'), C=('A',)), tent12)

# 0. the transcription against the Lean's values (from_six, from_seven; LineOnAStock.lean:1810, :1823)
s = (('A',), 6); tr = [s]
for _ in range(3): s = step(H, *s); tr.append(s)
assert tr == [(('A',),6), (('B','B'),6), (('C','B','C','B'),8), (('C','B','C','B'),8)]
s = (('A',), 7); tr = [s]
for _ in range(5): s = step(H, *s); tr.append(s)
assert [t[1] for t in tr] == [7, 8, 12, 12, 4, 0] and len(tr[5][0]) == 16 and tr[3][0] == ('A','C','B','A','C','B')
print("0. agrees with from_six and from_seven (lists)")

# 1. seat 1: 1,079 starts (multisets of one to six units, levels 0..12), 17 never end; at most one level per way
starts = 0; nev = []; perway = {}
for size in range(1, 7):
    for w in itertools.combinations_with_replacement('ABC', size):
        for x in range(13):
            starts += 1
            r = never(H, w, x); assert r is not None
            if r: nev.append((w, x)); perway.setdefault(w, []).append(x)
print(f"1. starts {starts}; never ending {len(nev)}; ways with more than one never-ending level: {[w for w in perway if len(perway[w]) > 1]}")
line = lambda w, x: x == 6*w.count('A') + 3*w.count('B') + w.count('C')
print("   all never-ending starts on level = 6a+3b+c:", all(line(w, x) for w, x in nev))
on = [(w, x) for size in range(1, 7) for w in itertools.combinations_with_replacement('ABC', size) for x in range(13) if line(w, x)]
print(f"   starts on that line: {len(on)}; of them ending: {sum(1 for w, x in on if not never(H, w, x))}; never ending: {sum(1 for w, x in on if never(H, w, x))}")
# seat 2's exact condition
exact = lambda w, x: ((w.count('A') == 0 and w.count('B') in (1, 2) and x == 3*w.count('B') + w.count('C') and x <= 11)
                      or (w.count('A') == 1 and w.count('B') == 0 and x == 6 + w.count('C') and x <= 11))
print("   seat 2's two equations exact on these 1,079:", all(exact(w, x) == bool(never(H, w, x)) for size in range(1, 7)
      for w in itertools.combinations_with_replacement('ABC', size) for x in range(13)))
# is the exact condition anything but 'at a fixed configuration within two steps'?
fixed = lambda w, x: (tuple(sorted(step(H, w, x)[0])), step(H, w, x)[1]) == (tuple(sorted(w)), x) and goes(H, w, x)
def within2(w, x):
    s = (w, x)
    for _ in range(3):
        if fixed(*s): return True
        if not goes(H, *s): return False
        s = step(H, *s)
    return False
print("   never ending == 'at a fixed, going configuration within two steps' on the 1,079:",
      all(within2(w, x) == bool(never(H, w, x)) for size in range(1, 7)
          for w in itertools.combinations_with_replacement('ABC', size) for x in range(13)))

# 2. the product countermodel: least K x B closed under the pair's step and holding ([A],6)
K = {('A',)}; Bset = {6}; grew = True
while grew:
    grew = False
    for w in list(K):
        for x in list(Bset):
            if not goes(H, w, x): continue            # the net has no next there
            w2, x2 = step(H, w, x); w2 = tuple(sorted(w2))
            if len(w2) > 40: continue
            if w2 not in K: K.add(w2); grew = True
            if x2 not in Bset: Bset.add(x2); grew = True
    if len(K) > 60: break
bad = [(w, x) for w in K for x in Bset if not goes(H, w, x)]
print(f"2. least product holding ([A],6), closed under the net: levels {sorted(Bset)}, {len(K)}+ ways; members with no need met: {len(bad)}, e.g. {sorted(bad, key=lambda t: (len(t[0]), t[1]))[:2]}")

# 3. itinerary classes from [A] on levels 0..12: are they intervals, and which is six's
cls = {}
for x in range(13): cls.setdefault(tuple(itin(H, ('A',), x, 12)), []).append(x)
print("3. [A]: itinerary classes of levels:", sorted(cls.values()), "| fates:", ''.join('N' if never(H, ('A',), x) else 'e' for x in range(13)))

# 4. seat 2's countermodels, by lists
W7 = (dict(P=5, Q=1), dict(P=2, Q=1), dict(P=('P',), Q=('Q',)), lambda z: 1 if z > 0 else 0)
print("4. ceiling 7, giving 1 from anything positive, (need 5,use 2),(need 1,use 1), each its own kid: fates 0..7:",
      ''.join('N' if never(W7, ('P','Q'), x) else 'e' for x in range(8)))
tent6 = lambda z: min(z, sub(6, z))
W6 = (dict(P=1, Q=4), dict(P=1, Q=1), dict(P=('P',), Q=('P','P')), tent6)
print("   ceiling 6, tent, P(1,1)->P, Q(4,1)->PP, from [P,Q]: fates 0..6:", ''.join('N' if never(W6, ('P','Q'), x) else 'e' for x in range(7)),
      "| from [P]:", ''.join('N' if never(W6, ('P',), x) else 'e' for x in range(7)))

# 5. try to break 'itinerary intervals', 'all-met up-set' and 'one need: up-set' where seat 2 did not search:
#    use 0, need 0, units with no kids, levels above the ceiling. Rising step only (z + g z non-decreasing).
random.seed(1116)
def rand_world(K, hi, one_need=False):
    names = list(range(K))
    need = {u: random.randint(0, hi) for u in names}
    if one_need:
        m = random.randint(0, hi); need = {u: m for u in names}
    use = {u: random.randint(0, 3) for u in names}
    kids = {u: tuple(random.choice(names) for _ in range(random.randint(0, 2))) for u in names}
    while True:
        g = [0] + [random.randint(0, 4) for _ in range(hi + 6)]
        if random.random() < 0.5: g[0] = random.randint(0, 1)
        if all(z + g[z] <= z + 1 + g[z + 1] for z in range(len(g) - 1)): break
    gf = lambda z, g=g: g[z] if z < len(g) else g[-1]
    return (need, use, kids, gf), names
v_int = v_up = v_one = tried = 0; ex = None
for _ in range(6000):
    hi = random.randint(3, 8); K = random.randint(1, 3)
    W, names = rand_world(K, hi, one_need=(random.random() < 0.3))
    w = tuple(random.choice(names) for _ in range(random.randint(1, 3)))
    top = hi + 4; n = 14
    its = [tuple(itin(W, w, x, n)) for x in range(top + 1)]
    if any(len(i[-1]) > 200 for i in its): continue
    tried += 1
    for a in range(top + 1):
        for c in range(a + 2, top + 1):
            if its[a] == its[c] and any(its[b] != its[a] for b in range(a + 1, c)):
                v_int += 1; ex = ex or ('interval', W[0], W[1], W[2], w, a, c)
    def allmet(x):
        s = (w, x)
        for _ in range(n):
            if not s[0] or any(W[0][u] > s[1] for u in s[0]): return False
            s = step(W, *s)
        return True
    am = [allmet(x) for x in range(top + 1)]
    if any(am[i] and not am[j] for i in range(top + 1) for j in range(i + 1, top + 1)): v_up += 1; ex = ex or ('allmet', W[0], W[1], W[2], w, am)
    if len(set(W[0].values())) == 1:
        def goes_n(x):
            s = (w, x)
            for _ in range(n):
                if not goes(W, *s): return False
                s = step(W, *s)
            return True
        gn = [goes_n(x) for x in range(top + 1)]
        if any(gn[i] and not gn[j] for i in range(top + 1) for j in range(i + 1, top + 1)): v_one += 1; ex = ex or ('one need', W[0], W[1], W[2], w, gn)
print(f"5. {tried} random worlds (use 0, need 0, no kids, levels past the ceiling; rising step; {14} steps): "
      f"interval violations {v_int}, all-met up-set violations {v_up}, one-need up-set violations {v_one}", ex or "")
