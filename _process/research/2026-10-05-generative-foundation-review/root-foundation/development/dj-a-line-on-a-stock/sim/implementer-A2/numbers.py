def giving12(z): return min(z, 12 - z) if z <= 12 else 0
def hump10(z): return min(z, 10 - z) if z <= 10 else 0
def step(g, H, x): l = max(x - H, 0); return l + g(l)
def course(need, kids, use, g, w, x, n):
    out = [(w, x)]
    for _ in range(n):
        w, x = [v for u in w if need[u] <= x for v in kids[u]], step(g, sum(use[u] for u in w), x)
        out.append((w, x))
    return out
# fall: one kind need 1 use 7 leaves itself
for k, (w, x) in enumerate(course({'u':1}, {'u':['u']}, {'u':7}, giving12, ['u'], 12, 6)): print('fall', k, w, x)
# proper line
for k, (w, x) in enumerate(course({'D':1,'O':1}, {'D':['D','D'],'O':['O']}, {'D':1,'O':1}, giving12, ['D','O'], 12, 7)):
    print('line', k, ''.join(w) if len(w) < 40 else (w.count('D'), w.count('O')), x)
# doubling
for k, (w, x) in enumerate(course({'u':1}, {'u':['u','u']}, {'u':1}, giving12, ['u'], 12, 6)): print('dbl', k, len(w), x)
# higher start
N={'A':1,'B':3,'C':12}; K={'A':['B','B'],'B':['C','B'],'C':['A']}; S={'A':3,'B':1,'C':1}
c6=course(N,K,S,giving12,['A'],6,3); c7=course(N,K,S,giving12,['A'],7,3)
for j in range(3): print('hse', j, c6[j], c7[j], [ (N[u]<=c6[j][1]) == (N[u]<=c7[j][1]) for u in 'ABC'])
# kids need more on hump10
for k,(w,x) in enumerate(course({'A':4,'B':9},{'A':['B','A','B'],'B':['B','B']},{'A':2,'B':1},hump10,['B','A','B'],8,3)): print('knm',k,w,x)
print('keeps hump10 0 10', all(step(hump10,0,x) <= 10 for x in range(11)))
print('keeps g12 0 12', all(step(giving12,0,x) <= 12 for x in range(13)))
