from fractions import Fraction as F
for c in [F(1,2), F(1)]:
    S11, S12 = F(1), c/2; S22 = 1 + c*c/2
    # check Lyapunov J S + S J^T + 2I = 0 with J=[[-1,0],[c,-1]]
    J = [[F(-1),F(0)],[c,F(-1)]]; S=[[S11,S12],[S12,S22]]
    JS = [[sum(J[i][k]*S[k][j] for k in range(2)) for j in range(2)] for i in range(2)]
    L = [[JS[i][j]+JS[j][i]+(2 if i==j else 0) for j in range(2)] for i in range(2)]
    det = S11*S22 - S12*S12
    H = [[S22/det, -S12/det],[-S12/det, S11/det]]
    Q = [[JS[i][j] + (1 if i==j else 0) for j in range(2)] for i in range(2)]
    recon = [[sum((Q[i][k]-(1 if i==k else 0))*H[k][j] for k in range(2)) for j in range(2)] for i in range(2)]
    print("c",c,"Lyap residual",L,"Q",Q,"H12",H[0][1],"J recon",recon)
    print("  J_12 terms: Q11H12",Q[0][0]*H[0][1]," Q12H22",Q[0][1]*H[1][1]," -G1H12",-H[0][1])
