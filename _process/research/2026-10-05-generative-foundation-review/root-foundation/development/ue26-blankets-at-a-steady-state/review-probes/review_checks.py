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
def solve_sym(op, R):
    # solve op(S) = R for symmetric S (op linear), by unknowns S_ij i<=j
    n=len(R); pairs=[(i,j) for i in range(n) for j in range(i,n)]
    def Sm(v):
        M=[[F(0)]*n for _ in range(n)]
        for (i,j),x in zip(pairs,v): M[i][j]=M[j][i]=x
        return M
    rows=[]; rhs=[]
    cols=[op(Sm([F(int(q==p)) for q in pairs])) for p in pairs]
    for (i,j) in pairs:
        rows.append([c[i][j] for c in cols]); rhs.append(R[i][j])
    Ai=inv(rows); v=[sum(Ai[i][k]*rhs[k] for k in range(len(rhs))) for i in range(len(rhs))]
    return Sm(v)
I3=[[F(int(i==j)) for j in range(3)] for i in range(3)]
show=lambda name,M: print(name,[[str(x) for x in r] for r in M])

print("== (a) Euler-Maruyama x' = (I - hB)x + sqrt(2hD) xi, no circulation (Q = 0) ==")
Pi=[[F(2),F(1),F(0)],[F(1),F(2),F(1)],[F(0),F(1),F(2)]]   # Pi_02 = 0: the blanket holds in continuous time
B=mm(I3,Pi)                                              # B = D Pi, D = I, Q = 0 (detailed balance)
print("continuous: B_02 =",B[0][2]," Pi_02 =",Pi[0][2]," (B Pi^-1 symmetric:", mm(B,inv(Pi))==T(mm(B,inv(Pi))),")")
for h in (F(1,10),F(1,100)):
    A=add(I3,sc(h,B),-1)
    Sh=solve_sym(lambda S: add(S, mm(mm(A,S),T(A)),-1), sc(2*h,I3))
    Ph=inv(Sh)
    print(" h =",h," Euler-Maruyama steady precision_02 =",Ph[0][2]," (Pi - h/2 Pi^2)_02 =",(add(Pi,sc(h/2,mm(Pi,Pi)),-1))[0][2])

print("== (b) circulation through the internal coordinate, yet B_02 = 0 and Pi_02 = 0 ==")
Pi=[[F(2),F(1),F(0)],[F(1),F(2),F(0)],[F(0),F(0),F(2)]]  # Pi_02 = 0, Pi_12 = 0
Q=[[F(0),F(1),F(0)],[F(-1),F(0),F(0)],[F(0),F(0),F(0)]]  # Q_01 = 1: circulation through 0
B=mm(add(I3,Q,-1),Pi); show(" B",B)
S=inv(Pi); print(" Lyapunov:",add(mm(B,S),mm(S,T(B)))==sc(2,I3)," Q row 0 nonzero:",Q[0]," B_02 =",B[0][2]," B_20 =",B[2][0]," Pi_02 =",Pi[0][2])

print("== (c) law 1 with listings not covering the type ==")
# I = E = {0,1}; listings LI = LE = [1]; weights at one blanket state
w={(0,0):5,(0,1):1,(1,0):0,(1,1):0}   # w(i,e)
LI=[1]; LE=[1]
Wb=sum(w[(i,e)] for i in LI for e in LE)
WI=lambda i: sum(w[(i,e)] for e in LE)
WE=lambda e: sum(w[(i,e)] for i in LI)
held=all(w[(i,e)]*Wb==WI(i)*WE(e) for i in (0,1) for e in (0,1))
cross=all(w[(i,e)]*w[(j,f)]==w[(i,f)]*w[(j,e)] for i,j,e,f in product((0,1),repeat=4))
print(" held apart in counts over the listings:",held," cross form:",cross)

print("== (d) the relay's Euler step is not the core relay's moves ==")
print(" (core relay: one part flips at a time, continuous-time rates; Blanketed.step: all parts at once)")
