# AI-written (Fable, reader "premises"), 16 November 2026. Read-only check of LineOnAStock.lean's
# worked numbers and of small models for premises; seconds to run. Not a proof.
import itertools, random

def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x:
            out += kids[u]
    return out
def taken(use, w): return sum(use[u] for u in w)
def step(giving, H, x):
    r = max(x - H, 0); return r + giving(r)
def course(need, kids, giving, use, w, x, n):
    out = [(list(w), x)]
    for _ in range(n):
        w, x = after(need, kids, w, x), step(giving, taken(use, w), x)
        out.append((list(w), x))
    return out
def goes(need, s): return any(need[u] <= s[1] for u in s[0])
def holds(need, use, y, s):
    return len(s[0]) > 0 and all(need[u] <= s[1] for u in s[0]) and taken(use, s[0]) + y(taken(use, s[0])) <= s[1]
three = lambda z: min(z, max(12 - z, 0))
def short(g, H, y): return all(g(z) < H for z in range(y))
def meets(g, H, y, hi): return all(H <= g(z) for z in range(y, hi + 1) if z + H <= hi)
def keeps(g, H, hi): return all(step(g, H, x) <= hi for x in range(hi + 1))
def regime(g, use, y, hi, w):
    H = taken(use, w); return short(g, H, y(H)) and meets(g, H, y(H), hi) and keeps(g, H, hi)

print("== 1. a way that multiplies and varies under `even` (no such closed instance in the Lean)")
need = {'P': 2, 'Q': 1, 'Z': 1}; use = {'P': 2, 'Q': 1, 'Z': 0}
kids = {'P': ['Q', 'Q'], 'Q': ['Q', 'Z'], 'Z': ['Z']}
assert all(taken(use, kids[u]) == use[u] for u in kids)           # even
assert all(kids[u] for u in kids)                                   # some
assert all(need[v] <= need[u] for u in kids for v in kids[u])       # down
c = course(need, kids, three, use, ['P'], 12, 8)
print([(len(w), x, taken(use, w)) for w, x in c])
print(" regime along:", all(regime(three, use, lambda t: t, 12, w) for w, x in c),
      " holds at 0:", holds(need, use, lambda t: t, c[0]), " goes all:", all(goes(need, s) for s in c))

print("== 2. implementer's three hand countermodels for unending_iff_holds")
# (a) without needs
need = {'u': 0}; use = {'u': 1}; kids = {'u': ['u']}; z0 = lambda z: 0
c = course(need, kids, z0, use, ['u'], 0, 30)
for yv in range(0, 4):
    y = lambda t, yv=yv: yv
    print("  no-needs y=%d: regime along %s, goes all %s, any holds %s" % (yv,
        all(regime(z0, use, y, 0, w) for w, x in c), all(goes(need, s) for s in c), any(holds(need, use, y, s) for s in c)))
# (b) without some
need = {'u': 1}; use = {'u': 0}; kids = {'u': []}
c = course(need, kids, z0, use, ['u'], 5, 5); y = lambda t: 0
print("  no-some: regime at step0 %s, holds at 0 %s, goes at 1 %s" % (regime(z0, use, y, 5, c[0][0]), holds(need, use, y, c[0]), goes(need, c[1])))
# (c) without even: Doubling, y = id, hi = 12
need = {'u': 1}; use = {'u': 1}; kids = {'u': ['u', 'u']}
c = course(need, kids, three, use, ['u'], 12, 6); y = lambda t: t
print("  no-even: levels", [x for w, x in c], "sizes", [len(w) for w, x in c], "goes", [goes(need, s) for s in c])
print("     regime while goes upto k:", [regime(three, use, y, 12, c[k][0]) for k in range(5)], " holds at 0:", holds(need, use, y, c[0]))

print("== 3. Holds at k implies Goes at every j<k (the `before` conjunct is implied); brute force")
random.seed(1); bad = 0; tried = 0
for _ in range(20000):
    K = random.randint(1, 3); U = list(range(K))
    need = {u: random.randint(0, 6) for u in U}; use = {u: random.randint(0, 3) for u in U}
    kids = {u: [random.choice(U) for _ in range(random.randint(0, 2))] for u in U}
    cc = random.randint(6, 12); g = lambda z, cc=cc: min(z, max(cc - z, 0))
    w = [random.choice(U) for _ in range(random.randint(1, 3))]; x = random.randint(0, cc)
    yv = random.randint(0, 3); y = lambda t: yv
    c = course(need, kids, g, use, w, x, 8)
    for k in range(9):
        if holds(need, use, y, c[k]):
            tried += 1
            if not all(goes(need, c[j]) for j in range(k)): bad += 1
print("  holding configurations seen:", tried, " with an earlier step not going:", bad)

print("== 4. a unit that takes nothing changes whether the net ends (title of takes_nothing)")
need = {'A': 5, 'C': 1}; use = {'A': 1, 'C': 0}; kids = {'A': ['A'], 'C': ['C']}
c1 = course(need, kids, z0, use, ['A', 'C'], 5, 6); c2 = course(need, kids, z0, use, ['A'], 5, 6)
print("  with C :", c1[:4], [goes(need, s) for s in c1])
print("  without:", c2[:4], [goes(need, s) for s in c2])

print("== 5. one need: first step with no need met, against hi+1 and 2*hi+1 (exhaustive small)")
worst = -99; n_inst = 0
for hi in range(1, 5):
    tables = itertools.product(range(hi + 1), repeat=hi)   # giving at 1..hi ; giving(0)=0 ; beyond hi: 0
    for tab in tables:
        g = lambda z, tab=tab, hi=hi: 0 if z == 0 or z > hi else tab[z - 1]
        if not keeps(g, 0, hi): continue
        for n in range(1, 3):
            for (ua, ub, ka, kb) in itertools.product(range(0, 3), range(0, 3), [['a','a'],['a','b'],['b','b'],['b'],['a','a','b']], [['b','b'],['a','b'],['b','b','b'],['a']]):
                use = {'a': ua, 'b': ub}; kids = {'a': ka, 'b': kb}; need = {'a': n, 'b': n}
                if not all(use[u] < taken(use, kids[u]) for u in kids): continue
                for x in range(hi + 1):
                    c = course(need, kids, g, use, ['a'], x, 2 * hi + 2)
                    first = next(k for k in range(len(c)) if not goes(need, c[k]))
                    worst = max(worst, first - (hi + 1)); n_inst += 1
print("  instances:", n_inst, " max(first stop - (hi+1)):", worst)

print("== 6. docstring numbers not in statements")
need = {'u': 1}; use = {'u': 1}; kids = {'u': ['u', 'u']}
c = course(need, kids, three, use, ['u'], 12, 13)
print("  Doubling first unmet step:", next(k for k in range(len(c)) if any(need[u] > c[k][1] for u in c[k][0])))
c = course(need, kids, z0, use, ['u'], 3, 4)
print("  MultiplyingTakers model: sizes", [len(w) for w, x in c], "levels", [x for w, x in c], "goes", [goes(need, s) for s in c])
need = {'r': 4, 'd0': 4, 'd1': 4}; use = {'r': 1, 'd0': 2, 'd1': 2}; kids = {'r': [], 'd0': ['d1', 'd1'], 'd1': ['d1']}
gift = lambda z: 0 if z == 0 else 3
c = course(need, kids, gift, use, ['r', 'd0'], 11, 12)
print("  Drain model: levels", [x for w, x in c], "sizes", [len(w) for w, x in c])
print("     `over` at step 0 for the drawers (take 2 > every gift 3?):", 2 > 3, "; at step 1 (take 4 > 3):", 4 > 3)
need = {'D': 1, 'O': 1}; use = {'D': 1, 'O': 1}; kids = {'D': ['D', 'D'], 'O': ['O']}
c = course(need, kids, three, use, ['D', 'O'], 12, 7)
print("  ProperLine: sizes", [len(w) for w, x in c], "levels", [x for w, x in c], "D present", ['D' in w for w, x in c])
need = {'A': 1, 'B': 3, 'C': 12}; use = {'A': 3, 'B': 1, 'C': 1}; kids = {'A': ['B', 'B'], 'B': ['C', 'B'], 'C': ['A']}
for x0 in (6, 7):
    c = course(need, kids, three, use, ['A'], x0, 6)
    print("  HigherStartEnds from", x0, [(''.join(w) if len(w) < 8 else len(w), x) for w, x in c], [goes(need, s) for s in c])
