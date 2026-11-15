# AI-written check of the worked numbers of pass B (implementer-B, 16 November 2026).
def run(need, use, kids, giving, w, x, n):
    out = [(list(w), x)]
    for _ in range(n):
        T = sum(use[u] for u in w)
        nw = [v for u in w if need[u] <= x for v in kids[u]]
        x = max(x - T, 0) + giving(max(x - T, 0)); w = nw
        out.append((list(w), x))
    return out
three = lambda z: min(z, max(12 - z, 0))
# item 1c
need = {'d': 5, 'b': 1}; kids = {'d': [], 'b': ['b']}
aft = lambda w, x: [v for u in w if need[u] <= x for v in kids[u]]
print('AlikeFiner', aft(['d', 'b'], 4), aft(['d', 'b'], 6))
# item 4
need = {'A': 1, 'B': 9, 'C': 7}; use = {'A': 3, 'B': 2, 'C': 0}; kids = {k: [k] for k in need}
print('TakesNothing ABC', run(need, use, kids, three, ['A', 'B', 'C'], 9, 5))
print('TakesNothing AB ', run(need, use, kids, three, ['A', 'B'], 9, 5))
# item 7a
print('MultiplyingTakers', [(len(w), x) for w, x in run({'u': 1}, {'u': 1}, {'u': ['u', 'u']}, lambda z: 0, ['u'], 3, 5)])
# item 7b
gift = lambda z: 0 if z == 0 else 3
r = run({'r': 4, 'd0': 4, 'd1': 4}, {'r': 1, 'd0': 2, 'd1': 2}, {'r': [], 'd0': ['d1', 'd1'], 'd1': ['d1']}, gift, ['r', 'd0'], 11, 12)
print('Drain', [(len(w), x) for w, x in r])
pools = [8, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 0]
print('pool+gift', [p + gift(p) for p in pools])
