# AI-written (Fable, a reader who did not write the Lean), 16 November 2026.
# Recomputes every number in the closed statements of LineOnAStock.lean section 12,
# from the definitions as the Lean has them (ordered lists, truncated subtraction).
def after(need, kids, w, x):
    out = []
    for u in w:
        if need[u] <= x:
            out += kids[u]
    return out
def taken(use, w): return sum(use[u] for u in w)
def rstep(g, H, x):
    e = max(0, x - H)
    return e + g(e)
def step(need, kids, g, use, s):
    w, x = s
    return (after(need, kids, w, x), rstep(g, taken(use, w), x))
def course(need, kids, g, use, s, n):
    for _ in range(n): s = step(need, kids, g, use, s)
    return s
def goes(need, s): return any(need[u] <= s[1] for u in s[0])
def three(z): return min(z, max(0, 12 - z))
def hump10(z): return min(z, max(0, 10 - z))
def keeps(g, hi): return all(x + g(x) <= hi for x in range(hi + 1))
bad = []
def chk(name, got, want):
    ok = got == want
    print(("ok   " if ok else "DIFF ") + name, "" if ok else f"got {got} want {want}")
    if not ok: bad.append(name)

# KidsNeedMore
need = {'A': 4, 'B': 9}; use = {'A': 2, 'B': 1}; kids = {'A': list('BAB'), 'B': list('BB')}
chk("KidsNeedMore.grows", all(use[u] < taken(use, kids[u]) for u in need), True)
chk("KidsNeedMore.not_down", all(need[v] <= need[u] for u in need for v in kids[u]), False)
chk("KidsNeedMore.fixed", step(need, kids, hump10, use, (list('BAB'), 8)), (list('BAB'), 8))
chk("KidsNeedMore goes at fixed", goes(need, (list('BAB'), 8)), True)
# premises of way_ends NOT stated in Lean for this model (my own check):
print("   KidsNeedMore, not in the Lean: FromNothing hump10:", hump10(0) == 0,
      "; least hi>=8 with Keeps hump10 0 hi:", next(h for h in range(8, 40) if keeps(hump10, h)),
      "; needs positive:", all(v > 0 for v in need.values()))

# EqualInPlaceOfMore
chk("EqualInPlaceOfMore.not_more", 1 < 1, False)
n1 = {'u': 1}; u1 = {'u': 1}; k1 = {'u': ['u']}
chk("EqualInPlaceOfMore.holds fixed", step(n1, k1, three, u1, (['u'], 12)), (['u'], 12))
# units_with, through WayOfUnits.With: way [(9,4),(1,1)] at 9, kids u = [u]
nw = {'p': 9, 'q': 1}; uw = {'p': 4, 'q': 1}; kw = {'p': ['p'], 'q': ['q']}
lv = [course(nw, kw, three, uw, (['p', 'q'], 9), n) for n in range(7)]
print("   With course:", lv)
chk("With levels (WayOfUnits.With.levels)", [s[1] for s in lv[:6]], [9, 8, 6, 10, 12, 12])
chk("With fixed at step 4", step(nw, kw, three, uw, lv[4]), lv[4])
chk("With goes at every step to the fixed one", all(goes(nw, s) for s in lv[:5]), True)

# ShareRises
ns = {'C': 1, 'O': 1}; us = {'C': 2, 'O': 2}; ks = {'C': ['C'], 'O': []}
chk("ShareRises course 1", course(ns, ks, three, us, (['C', 'O'], 12), 1), (['C'], 12))
chk("ShareRises [C],12 fixed", step(ns, ks, three, us, (['C'], 12)), (['C'], 12))
chk("ShareRises lineTake C [C,O]", sum(us[u] for u in ['C', 'O'] if u == 'C'), 2)
chk("ShareRises taken [C,O]", taken(us, ['C', 'O']), 4)
chk("ShareRises taken [C]", taken(us, ['C']), 2)
chk("ShareRises goes step 0,1", [goes(ns, course(ns, ks, three, us, (['C', 'O'], 12), j)) for j in (0, 1)], [True, True])

# Doubling
nd = {'u': 1}; ud = {'u': 1}; kd = {'u': ['u', 'u']}
cs = [course(nd, kd, three, ud, (['u'], 12), n) for n in range(6)]
chk("Doubling levels 1..5", [s[1] for s in cs[1:]], [12, 12, 12, 8, 0])
chk("Doubling lengths 1..5", [len(s[0]) for s in cs[1:]], [2, 4, 8, 16, 32])
chk("Doubling not Goes at 5", goes(nd, cs[5]), False)
chk("Doubling goes at 0..4 (docstring: 'at step 5 ... ends')", [goes(nd, s) for s in cs[:5]], [True] * 5)
chk("Doubling.ends_by_law premises: FromNothing, Keeps 0 12, grows, needs, down, 12<=12",
    (three(0) == 0, keeps(three, 12), 1 < 2, 0 < 1, True, True), (True,) * 6)

# HigherStartEnds
nh = {'A': 1, 'B': 3, 'C': 12}; uh = {'A': 3, 'B': 1, 'C': 1}
kh = {'A': list('BB'), 'B': list('CB'), 'C': ['A']}
c6 = [course(nh, kh, three, uh, (['A'], 6), n) for n in range(5)]
c7 = [course(nh, kh, three, uh, (['A'], 7), n) for n in range(7)]
chk("from_six 1", c6[1], (list('BB'), 6))
chk("from_six 2", c6[2], (list('CBCB'), 8))
chk("from_six 3", c6[3], (list('CBCB'), 8))
chk("from_six goes 0,1,2", [goes(nh, s) for s in c6[:3]], [True] * 3)
chk("from_seven 1", c7[1], (list('BB'), 8))
chk("from_seven 2", c7[2], (list('CBCB'), 12))
chk("from_seven 3", c7[3], (list('ACBACB'), 12))
chk("from_seven 4", c7[4], (list('BBACBBBACB'), 4))
chk("from_seven 5 length", len(c7[5][0]), 16)
chk("from_seven 5 level", c7[5][1], 0)
chk("from_seven not Goes at 5", goes(nh, c7[5]), False)
chk("higher_ends ways equal at 0,1,2", [c6[j][0] == c7[j][0] for j in range(3)], [True] * 3)
print("   ways at step 3:", ''.join(c6[3][0]), "vs", ''.join(c7[3][0]), "; levels 0..2:", [s[1] for s in c6[:3]], [s[1] for s in c7[:3]])
print("   HigherStartEnds: grows of every kind?", {u: uh[u] < taken(uh, kh[u]) for u in nh},
      "; down?", all(nh[v] <= nh[u] for u in nh for v in kh[u]))
# is 'the start is at least t' exact for no t, on this way? fates for every start 0..14
def fate(need, kids, g, use, s, T=400):
    seen = {}
    for t in range(T):
        if not goes(need, s): return 'ends@%d' % t
        key = (tuple(sorted(s[0])), s[1])
        if key in seen: return 'never'
        seen[key] = t
        if len(s[0]) > 5000: return 'undet'
        s = step(need, kids, g, use, s)
    return 'undet'
print("   fates from ([A], x), x = 0..14:", [(x, fate(nh, kh, three, uh, (['A'], x))) for x in range(15)])

# NoKids
nn = {'u': 1}; un = {'u': 1}; kn = {'u': []}
chk("NoKids met at start", nn['u'] <= 12, True)
chk("NoKids course 1", course(nn, kn, three, un, (['u'], 12), 1), ([], 12))
chk("NoKids not Goes at 1", goes(nn, ([], 12)), False)
print("DIFFERENCES:", bad if bad else "none")
