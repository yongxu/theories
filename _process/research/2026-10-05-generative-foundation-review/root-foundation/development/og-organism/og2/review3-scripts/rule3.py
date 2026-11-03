"""Third rule from DESIGN s2 prose only. p=(s,l,g,f,c,src); x=(quota,level,holders,others)."""
def tsub(a,b): return a-b if a>b else 0
def step(p,x,on=True,rev=None):
    s,l,g,f,c,src=p; q,L,H,O=x
    take=sum(H)+sum(O)
    if L==0 or take>L+g: return (q,0,[],[])
    L1=L+g-take
    T=sum(H[l:])
    eo=tsub(f,c*T) if on else 0
    eh=q if on and (src=='outside' or (src=='members' and T>0)) else 0
    q1=rev if rev is not None and sum(H)>0 and src!='outside' else q
    return (q1,L1,([eh]+list(H))[:s],([eo]+list(O))[:s])
def e(p,q): return tsub(p[3],p[4]*q*tsub(p[0],p[1]))
def steady(p,q,L): return (q,L,[q]*p[0],[e(p,q)]*p[0])
def gone(x): return x[1]==0 and sum(x[2])==0 and sum(x[3])==0
def held(x): return sum(x[2])>0
def run(p,x,k):
    for _ in range(k): x=step(p,x)
    return x
