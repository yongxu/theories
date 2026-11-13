# AI-written (Opus reader), 13 November 2026. Rechecks each counterexample t1_fast and t1_sim report:
# the premises kept, the dropped one broken, the first line unending and the second ending (not
# undecided: a None from the cycle search is not an ending).
import importlib.util
spec = importlib.util.spec_from_file_location('t', '/Users/ren/theories/tmp/r7/wu2/readers/t1_sim.py')
t = importlib.util.module_from_spec(spec); spec.loader.exec_module(t)
def T1(tab, hi, m, m2, h, n, H2, y2, x, tail=0):
    g = t.mkg(tab, tail)
    P = dict(order=n <= m, more=m <= m2, nothing=t.fromnothing(g), short=t.short(g, H2, y2),
             meets=t.meets(g, H2, y2, hi), keeps=t.keeps(g, H2, hi), high=x <= hi)
    a, b = (((m, h), (n, H2)), x), (((m2, h), (n, H2)), x)
    print('T1', {k: v for k, v in P.items() if not v}, 'first', t.unending(g, a), [s[1] for s in t.orbit_all(g, a)][:10],
          'second', t.unending(g, b), [s[1] for s in t.orbit_all(g, b)][:10])
def T2(tab, hi, m, n, h, H2, hp, H2p, y2p, x, tail=0):
    g = t.mkg(tab, tail)
    P = dict(order=n <= m, nothing=t.fromnothing(g), short=t.short(g, H2p, y2p), meets=t.meets(g, H2p, y2p, hi),
             keeps=t.keeps(g, H2p, hi), sum=h + H2 == hp + H2p, more=h <= hp, high=x <= hi)
    a, b = (((m, h), (n, H2)), x), (((m, hp), (n, H2p)), x)
    print('T2', {k: v for k, v in P.items() if not v}, 'first', t.unending(g, a), [s[1] for s in t.orbit_all(g, a)][:10],
          'second', t.unending(g, b), [s[1] for s in t.orbit_all(g, b)][:10])
T1([0, 5, 2, 4, 0, 0, 3], 3, 0, 1, 0, 4, 4, 0, 3)
T1([0, 0, 0, 3, 2, 2, 2, 1, 1, 2, 2, 7, 1], 9, 8, 2, 3, 2, 1, 3, 9)
T1([0, 5, 2, 2, 5, 1, 2, 6, 3, 3], 6, 6, 9, 1, 1, 4, 4, 6)
T1([0, 4, 0, 0, 2, 2, 1, 2, 6, 5, 5], 7, 4, 8, 2, 4, 2, 1, 5)
T1([0, 0, 5, 6, 0, 1], 2, 4, 8, 4, 1, 1, 2, 7)
T1([0, 4, 1, 1, 7, 0, 7, 5, 1], 5, 3, 6, 1, 1, 0, 0, 3)   # keeps dropped (3000 run)
T2([0, 5, 7, 6, 1, 1, 3, 6, 3, 1], 6, 7, 1, 0, 3, 2, 1, 1, 5)  # keeps dropped
T2([0, 3, 1, 0, 6, 2, 3, 4, 0], 5, 7, 2, 1, 2, 1, 4, 3, 4)  # sum dropped
T2([0, 1, 1, 2, 6, 0, 3, 4], 4, 8, 1, 3, 0, 0, 3, 4, 4)  # more dropped
T2([0, 1, 7, 4, 3, 3], 2, 8, 3, 0, 2, 1, 1, 1, 6)  # high dropped
# hand-built, Keeps dropped: the first table with g 1 = 7, hi 5, H2 3, y2 1, start 5 at most hi
T1([0, 7, 3, 0, 4, 4, 0], 5, 5, 9, 1, 1, 3, 1, 5)
T2([0, 7, 3, 0, 4, 4, 0], 5, 9, 1, 0, 4, 1, 3, 1, 5)
# FromNothing dropped (exhaustive search, hi 6): giving 2 from nothing, hi 6, the second unit's use 3, y 4
T1([2, 0, 2, 0, 0, 0, 0, 0], 6, 2, 7, 1, 2, 3, 4, 6)
# the same giving for more_use_on_first: h 0, H2 4; h' 1, H2' 3, y2' 4; m 7, n 2, start 6
T2([2, 0, 2, 0, 0, 0, 0, 0], 6, 7, 2, 0, 4, 1, 3, 4, 6)
