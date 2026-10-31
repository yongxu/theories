from fractions import Fraction as F
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
eta, s, a, mu = 0, 1, 2, 3
I4=[[F(int(i==j)) for j in range(4)] for i in range(4)]
Pi=[[F(2),F(1),F(0),F(0)],[F(1),F(3),F(1),F(0)],[F(0),F(1),F(3),F(1)],[F(0),F(0),F(1),F(2)]]
Q=[[F(0)]*4 for _ in range(4)]
Q[mu][a]=F(1); Q[a][mu]=F(-1)     # circulation between internal and active (autonomous block)
Q[eta][s]=F(1); Q[s][eta]=F(-1)   # circulation between external and sensory (non-autonomous block)
B=mm(add(I4,Q,-1),Pi); S=inv(Pi)
print("Lyapunov:", add(mm(B,S),mm(S,T(B)))==sc(2,I4))
print("sparse coupling (eq. 13 of the 2023 paper): B_mu,eta =",B[mu][eta]," B_a,eta =",B[a][eta]," B_s,mu =",B[s][mu]," B_eta,mu =",B[eta][mu])
print("internal reads sensory: B_mu,s =",B[mu][s],"  Pi_mu,s =",Pi[mu][s]," (carried by Q_mu,a Pi_a,s)")
print("blanket: Pi_mu,eta =",Pi[mu][eta]," Pi_a,eta =",Pi[a][eta]," ; circulation through internal: Q_mu,a =",Q[mu][a])
