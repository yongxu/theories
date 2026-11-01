from fractions import Fraction as F
from itertools import product
def mm(A, B): return [[sum(A[i][k]*B[k][j] for k in range(len(B))) for j in range(len(B[0]))] for i in range(len(A))]
def T(A): return [list(r) for r in zip(*A)]
def add(A, B, s=1): return [[a + s*b for a, b in zip(r, q)] for r, q in zip(A, B)]
def sc(c, A): return [[c*a for a in r] for r in A]
def inv(A):
    n=len(A); M=[list(map(F,r))+[F(int(i==j)) for j in range(n)] for i,r in enumerate(A)]
    for c in range(n):
        p=next(r for r in range(c,n) if M[r][c]!=0); M[c],M[p]=M[p],M[c]
        M[c]=[x/M[c][c] for x in M[c]]
        for r in range(n):
            if r!=c: M[r]=[x-M[r][c]*y for x,y in zip(M[r],M[c])]
    return [r[n:] for r in M]
I3=[[F(int(i==j)) for j in range(3)] for i in range(3)]
show=lambda name,M: print(name,[[str(x) for x in r] for r in M])
print("== linear: circulation through the internal coordinate, all four relay couplings present, blanket holds ==")
Pi=[[F(2),F(1),F(0)],[F(1),F(2),F(1)],[F(0),F(1),F(2)]]
Q=[[F(0),F(1),F(-1,2)],[F(-1),F(0),F(1)],[F(1,2),F(-1),F(0)]]
B=mm(add(I3,Q,-1),Pi); show(" B",B); S=inv(Pi)
print(" Lyapunov B S + S B^T = 2I:", add(mm(B,S),mm(S,T(B)))==sc(2,I3))
print(" B_02 =",B[0][2]," B_20 =",B[2][0]," B_01 =",B[0][1]," B_10 =",B[1][0]," B_12 =",B[1][2]," B_21 =",B[2][1])
print(" Pi_02 =",Pi[0][2]," Q row 0 =",[str(x) for x in Q[0]])
print(" recovered Q = (S B^T - B S)/2 equals Q:", sc(F(1,2),add(mm(S,T(B)),mm(B,S),-1))==Q)
print("== discrete: internal moves circulate (3-cycle), weights uniform, held apart ==")
# internal i in Z3 moves i -> i+1 at rate 1 (reads nothing); blanket and external bits flip at rate 1.
states=list(product(range(3),(0,1),(0,1)))
def rate(x,y):
    (i,s,e),(j,t,f)=x,y
    if (s,e)==(t,f) and j==(i+1)%3: return 1
    if i==j and e==f and s!=t: return 1
    if i==j and s==t and e!=f: return 1
    return 0
w={x:1 for x in states}
steady=all(sum(w[y]*rate(y,x) for y in states if y!=x)==w[x]*sum(rate(x,y) for y in states if y!=x) for x in states)
balanced=all(w[x]*rate(x,y)==w[y]*rate(y,x) for x in states for y in states if x!=y and x[1:]==y[1:])
cross=all(w[(i,s,e)]*w[(j,s,f)]==w[(i,s,f)]*w[(j,s,e)] for i,j in product(range(3),repeat=2) for s,e,f in product((0,1),repeat=3))
print(" global balance:",steady," internal moves in detailed balance:",balanced," cross form:",cross)
