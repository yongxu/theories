from w2 import *
def show(lab, tab, m, m2, h, n, H2, y1, y2, hi, x):
    g = mk(tab + [0] * 40)
    p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
    a = unending(g, ([(m, h), (n, H2)], x)); b = unending(g, ([(m2, h), (n, H2)], x))
    print(lab, 'failing:', [k for k in p if not p[k]], 'm:', a[0], 'm2:', b[0], [s[1] for s in b[1]])
show('W3 drop Keeps', [0, 6, 7, 7, 7, 0, 0, 7, 2, 7, 7, 6, 1], 10, 11, 2, 6, 6, 3, 1, 10, 10)
show('W3 drop high', [0, 5, 4, 0, 0, 0, 0, 0, 0], 9, 15, 1, 4, 5, 9, 1, 6, 14)
# r3's G7 counterexample: g=[0,3,6,3,7,1,6,4,7,0,5,6,4,0], (m,1),(4,5), from 8, m=4 vs 9
g = mk([0,3,6,3,7,1,6,4,7,0,5,6,4,0] + [0]*40)
ok = []
for hi in range(8, 20):
    for y2 in range(0, hi + 2):
        for y1 in range(0, 15):
            p = W2prem(g, 4, 1, 4, 5, y1, y2, hi, 8)
            ok.append((tuple(k for k in p if not p[k]), hi, y2, y1))
best = min(ok, key=lambda t: len(t[0]))
print('r3 G7 CE: fewest failing premises', best, 'm=4', unending(g, ([(4,1),(4,5)], 8))[0], 'm=9', unending(g, ([(9,1),(4,5)], 8))[0])
print(' failing-sets that occur with 2 or fewer:', sorted({t[0] for t in ok if len(t[0]) <= 2}))
