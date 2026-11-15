# AI-written (Fable, attack reader), 16 November 2026. Every number of every worked course and kept
# countermodel of LineOnAStock.lean, recomputed from the definitions as transcribed in model.py.
from model import *

bad = []


def eq(label, got, want):
    ok = got == want
    print(('ok   ' if ok else 'DIFF ') + label + ('' if ok else f': got {got}, the Lean/docstring says {want}'))
    if not ok:
        bad.append(label)


g12 = [min(z, 12 - z) for z in range(13)]   # TurningInTime.Three.giving; 0 from 12 up (truncated)
h10 = [min(z, 10 - z) for z in range(11)]
G12 = lambda z: g12[z] if z < 13 else 0
H10 = lambda z: h10[z] if z < 11 else 0

# KidsNeedMore: A=0 (need 4, use 2, kids B A B), B=1 (need 9, use 1, kids B B)
A, B = 0, 1
m = M([4, 9], [2, 1], [(B, A, B), (B, B)], h10)
eq('KidsNeedMore.fixed', m.step((B, A, B), 8), ((B, A, B), 8))
eq('KidsNeedMore FromNothing hump10', H10(0), 0)
eq('KidsNeedMore Keeps hump10 0 10', keeps(H10, 0, 10), True)
eq('KidsNeedMore grows', [m.use[u] < m.taken(m.kids[u]) for u in (A, B)], [True, True])
eq('KidsNeedMore needs positive', all(n > 0 for n in m.need), True)
eq('KidsNeedMore down fails at (A, B)', m.need[B] <= m.need[A], False)
eq('KidsNeedMore never ends', m.unending((B, A, B), 8), True)
eq('KidsNeedMore docstring: what is taken, four', m.taken((B, A, B)), 4)

# EqualInPlaceOfMore
m = M([1], [1], [(0,)], g12)
eq('EqualInPlaceOfMore fixed', m.step((0,), 12), ((0,), 12))
eq('EqualInPlaceOfMore Keeps giving 0 12', keeps(G12, 0, 12), True)
eq('EqualInPlaceOfMore grows fails', m.use[0] < m.taken(m.kids[0]), False)
eq('EqualInPlaceOfMore.holds_by_law Regime at [()] with y=id, hi=12', regime(m, lambda T: T, 12, (0,)), True)
eq('EqualInPlaceOfMore Holds at ([()],12), y=id', holds(m, lambda T: T, (0,), 12), True)

# ShareRises: C=0 leaves itself, O=1 leaves nothing; need 1, use 2
m = M([1, 1], [2, 2], [(0,), ()], g12)
c = m.course((0, 1), 12, 5)
eq('ShareRises course 1', c[1], ((0,), 12))
eq('ShareRises course 1+k', all(s == ((0,), 12) for s in c[1:]), True)
eq('ShareRises takes (2 of 4, 2 of 2)', (2, m.taken((0, 1)), 2, m.taken((0,))), (2, 4, 2, 2))
eq('ShareRises never ends', m.unending((0, 1), 12), True)

# Doubling
m = M([1], [1], [(0, 0)], g12)
c = m.course((0,), 12, 14)
eq('Doubling levels 0..5', [s[1] for s in c[:6]], [12, 12, 12, 12, 8, 0])
eq('Doubling sizes 0..5', [len(s[0]) for s in c[:6]], [1, 2, 4, 8, 16, 32])
eq('Doubling no need met at 5', m.goes(*c[5]), False)
eq('Doubling first unmet step (docstring: 5; law: <= 13)', next(n for n in range(1, 14) if any(c[n][1] < 1 for u in c[n][0])), 5)

# HigherStartEnds: A=0 (1, 3, [B,B]), B=1 (3, 1, [C,B]), C=2 (12, 1, [A])
A, B, Cc = 0, 1, 2
m = M([1, 3, 12], [3, 1, 1], [(B, B), (Cc, B), (A,)], g12)
c6, c7 = m.course((A,), 6, 6), m.course((A,), 7, 6)
eq('from_six 1', c6[1], ((B, B), 6))
eq('from_six 2', c6[2], ((Cc, B, Cc, B), 8))
eq('from_six 3', c6[3], ((Cc, B, Cc, B), 8))
eq('from_six never ends', m.unending((A,), 6), True)
eq('from_seven 1', c7[1], ((B, B), 8))
eq('from_seven 2', c7[2], ((Cc, B, Cc, B), 12))
eq('from_seven 3', c7[3], ((A, Cc, B, A, Cc, B), 12))
eq('from_seven 4', c7[4], ((B, B, A, Cc, B, B, B, A, Cc, B), 4))
eq('from_seven 5 (length, level)', (len(c7[5][0]), c7[5][1]), (16, 0))
eq('from_seven ends', m.unending((A,), 7), False)
eq('higher_ends: ways equal at 0..2', [c6[j][0] == c7[j][0] for j in range(3)], [True] * 3)
eq('higher_ends: same needs met at steps 0, 1 (all three kinds)',
   [[(n <= c6[j][1]) == (n <= c7[j][1]) for n in m.need] for j in range(2)], [[True] * 3] * 2)
eq('higher_ends: ways differ at step 3', c6[3][0] != c7[3][0], True)
print('     (module docstring: "not monotone in the start level"): from ([A], x), x = 0..14, never ends at',
      [x for x in range(15) if m.unending((A,), x)])

# NoKids
m = M([1], [1], [()], g12)
eq('NoKids course 1', m.course((0,), 12, 1)[1], ((), 12))

# Overdrawn
m = M([1], [7], [(0,)], g12)
c = m.course((0,), 12, 8)
eq('Overdrawn 1,2,3', c[1:4], [((0,), 10), ((0,), 6), ((0,), 0)])
eq('Overdrawn 4+k', all(s == ((), 0) for s in c[4:]), True)
eq('Overdrawn.short: giving z < 7 for every z', all(G12(z) < 7 for z in range(40)), True)

# ProperLine: D=0 (kids D D), O=1 (kids O); need 1, use 1
m = M([1, 1], [1, 1], [(0, 0), (1,)], g12)
c = m.course((0, 1), 12, 9)
eq('ProperLine 1', c[1], ((0, 0, 1), 12))
eq('ProperLine 2', c[2], ((0, 0, 0, 0, 1), 12))
eq('ProperLine 3,4,5 (length, level)', [(len(s[0]), s[1]) for s in c[3:6]], [(9, 12), (17, 6), (33, 0)])
eq('ProperLine 6+k', all(s == ((), 0) for s in c[6:]), True)
eq('ProperLine: first step with no D', next(i for i, s in enumerate(c) if 0 not in s[0]), 6)
print('     docstring of ProperLine.gone: "then 9, 17, 33 units at twelve, twelve, six, nothing": three sizes, four levels;'
      ' computed (size, level) at steps 3, 4, 5:', [(len(s[0]), s[1]) for s in c[3:6]])

# AlikeFiner: d=0 (need 5, no kids), b=1 (need 1, leaves itself)
m = M([5, 1], [0, 0], [(), (1,)], [0])
eq('AlikeFiner after at 4 and 6', (m.after((0, 1), 4), m.after((0, 1), 6)), ((1,), (1,)))
eq('AlikeFiner needs met differ (d)', (5 <= 4, 5 <= 6), (False, True))

# TakesNothing: A=0 (1,3), B=1 (9,2), C=2 (7,0); each leaves itself
m = M([1, 9, 7], [3, 2, 0], [(0,), (1,), (2,)], g12)
c3, c2 = m.course((0, 1, 2), 9, 8), m.course((0, 1), 9, 8)
eq('TakesNothing ABC 1,2', c3[1:3], [((0, 1, 2), 8), ((0, 2), 6)])
eq('TakesNothing ABC 3+k', all(s == ((0,), 6) for s in c3[3:]), True)
eq('TakesNothing AB 1', c2[1], ((0, 1), 8))
eq('TakesNothing AB 2+k', all(s == ((0,), 6) for s in c2[2:]), True)
eq('TakesNothing levels equal, ways without C equal', all(a[1] == b[1] and tuple(u for u in a[0] if u != 2) == b[0] for a, b in zip(c3, c2)), True)
eq('TakesNothing C in the way exactly at steps 0..2', [2 in s[0] for s in c3[:5]], [True, True, True, False, False])
eq('TakesNothing never ends', m.unending((0, 1, 2), 9), True)

# MultiplyingTakersCase: the doubling unit, nothing given, from 3; and the built example's own tables
m = M([1], [1], [(0, 0)], [0])
c = m.course((0,), 3, 6)
fam = {0: [1], 1: [2, 3], 2: [4, 5, 6, 7]}          # LineageRegimes.MultiplyingTakers.generations (kids 0 1, 1 2, 1 3)
pool = {0: 3, 1: 2}                                  # MultiplyingTakers.level t 0
present = {0: [1], 1: [2, 3]}
eq('MultiplyingTakers sizes', [len(s[0]) for s in c[:5]], [len(fam.get(t, [])) for t in range(5)])
eq('MultiplyingTakers pool = level', [s[1] for s in c[:5]], [pool.get(t, 0) for t in range(5)])
eq('MultiplyingTakers active iff Goes', [m.goes(*s) for s in c[:5]],
   [any(p in present.get(t, []) for p in fam.get(t, [])) for t in range(5)])
eq('MultiplyingTakers Keeps (nothing given) 0 3', keeps(lambda z: 0, 0, 3), True)

# DrainCase: r=0, d0=1, d1=2; need 4; uses 1,2,2; gift 3 from 1 up; and Drain's own tables (phaseP gated, familyP)
gift = lambda z: 0 if z == 0 else 3
m = M([4, 4, 4], [1, 2, 2], [(), (2, 2), (2,)], [0] + [3] * 30, 3)
c = m.course((0, 1), 11, 14)
poolP = [8, 8, 7, 6, 5, 4, 3, 2, 1, 0] + [0] * 5       # phaseP true
famP = [2] * 10 + [0] * 5                              # familyP sizes
eq('Drain sizes', [len(s[0]) for s in c], famP)
eq('Drain pool + gift(pool) = level', [s[1] for s in c], [p + gift(p) for p in poolP])
eq('Drain course 1', c[1], ((2, 2), 11))
eq('Drain: way empty from step 10', [len(s[0]) for s in c[9:12]], [2, 0, 0])
eq('Drain fall premises from step 1: over (4 > every gift), low, one need 4, keeps',
   (all(gift(z) < 4 for z in range(50)), gift(0) < 4, True, [2 <= 4, 2 <= 2]), (True, True, True, [True, True]))
eq('Drain: over fails at step 0 (drawers take 2, gift 3)', all(gift(z) < 2 for z in range(5)), False)
print('     Drain\'s own organisms need the pool at ONE (web.need = 1); here every kind needs FOUR on pool + gift:',
      'need 4 <= pool + gift(pool) iff 1 <= pool, for pool 0..12:', all((4 <= p + gift(p)) == (1 <= p) for p in range(13)))

print('\nnumbers that differ:', bad if bad else 'none')
