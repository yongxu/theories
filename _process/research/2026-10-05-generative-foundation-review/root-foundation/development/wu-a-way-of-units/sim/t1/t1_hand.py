# AI-written (Opus reader), 13 November 2026. Hand-built cases checked with t1_sim's definitions.
import importlib.util, sys
spec = importlib.util.spec_from_file_location('t', '/Users/ren/theories/tmp/r7/wu2/readers/t1_sim.py')
t = importlib.util.module_from_spec(spec); spec.loader.exec_module(t)
def show(name, tab, s0):
    g = t.mkg(tab, 0); st = t.orbit_all(g, s0)
    print(name, s0, 'levels', [s[1] for s in st], 'ways', [len(s[0]) for s in st], 'unending', t.unending(g, s0))
# greater_need without x <= hi: hi 5, H2 3, y2 1, h 1, n 1, m 8, m' 9, x 8
tab = [0, 4, 3, 0, 4, 4, 0]
g = t.mkg(tab, 0)
print('premises: nothing', t.fromnothing(g), 'short', t.short(g, 3, 1), 'meets', t.meets(g, 3, 1, 5), 'keeps', t.keeps(g, 3, 5), 'high', 8 <= 5)
show('T1 m=8 ', tab, (((8, 1), (1, 3)), 8))
show('T1 m=9 ', tab, (((9, 1), (1, 3)), 8))
# more_use_on_first without Short at H2': H2 3, H2' 2, h 0, h' 1, n 2, m 6, x 5, hi 5
tab2 = [0, 0, 3, 0, 0, 0]
g2 = t.mkg(tab2, 0)
for y in range(0, 7):
    print("y2'", y, 'short', t.short(g2, 2, y), 'meets', t.meets(g2, 2, y, 5), 'keeps', t.keeps(g2, 2, 5))
show('T2 h=0 H2=3 ', tab2, (((6, 0), (2, 3)), 5))
show("T2 h'=1 H2'=2", tab2, (((6, 1), (2, 2)), 5))
# more_use_on_first without x <= hi: the table of the first case; H2 4, h 0; H2' 3, h' 1; m 9, n 1, x 8, hi 5
show('T2 h=0 H2=4 ', tab, (((9, 0), (1, 4)), 8))
show("T2 h'=1 H2'=3", tab, (((9, 1), (1, 3)), 8))
# more_use_on_first without n <= m: giving all nothing, hi 2; m 1, n 5; h 0, H2 1; h' 1, H2' 0, y2' 0; x 2
tab3 = [0, 0, 0]
g3 = t.mkg(tab3, 0)
print('premises', t.fromnothing(g3), t.short(g3, 0, 0), t.meets(g3, 0, 0, 2), t.keeps(g3, 0, 2))
show('T2 h=0 H2=1 ', tab3, (((1, 0), (5, 1)), 2))
show("T2 h'=1 H2'=0", tab3, (((1, 1), (5, 0)), 2))
# greater_need without m <= m': g 0,3,3,..., hi 5, H2 3, y2 1, h 1, n 1, x 5, m 6, m' 4
tab4 = [0, 3, 3, 3, 3, 3]
g4 = t.mkg(tab4, 0)
print('premises', t.fromnothing(g4), t.short(g4, 3, 1), t.meets(g4, 3, 1, 5), t.keeps(g4, 3, 5))
show('T1 m=6 ', tab4, (((6, 1), (1, 3)), 5))
show("T1 m'=4", tab4, (((4, 1), (1, 3)), 5))
