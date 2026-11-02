import sys, itertools, collections
sys.dont_write_bytecode=True
R=itertools.product
def mk(variant):
    def step(p,x,on=True,rev=None):
        s,l,g,f,src=p;q,L,H,O=x;H=list(H);O=list(O)
        H0=sum(H)
        def tea(H): return any(c>0 for i,c in enumerate(H) if i>=l)
        def entrants(t,q):
            if not on: return 0,0
            if src=='members' and t: return q,0
            if src=='outside': return q,0
            return 0,f
        qq=q
        if variant=='revise-before-enter' and rev is not None and H0>0 and src!='outside': qq=rev
        if variant=='enter-before-draw':   # entrants draw on the step they enter, then age
            eh,eo=entrants(tea(H),qq); H=[eh]+H;O=[eo]+O
            take=sum(H)+sum(O)
            if L==0 or take>L+g: return (q,0,[],[])
            q2=rev if rev is not None and H0>0 and src!='outside' else q
            return (q2,L+g-take,H[:s],O[:s])
        if variant=='age-before-draw':     # oldest leave before the draw; teacher read after that; entrants next
            t=tea(H[:s-1] if s>0 else [])
            H2=H[:s-1] if s>0 else [];O2=O[:s-1] if s>0 else []
            take=sum(H2)+sum(O2)
            if L==0 or take>L+g: return (q,0,[],[])
            eh,eo=entrants(t,qq)
            q2=rev if rev is not None and H0>0 and src!='outside' else q
            return (q2,L+g-take,([eh]+H2)[:s],([eo]+O2)[:s])
        take=sum(H)+sum(O)
        if variant=='no-empty-clause':
            if take>L+g: return (q,0,[],[])
        elif variant=='end-after-enter':
            pass
        elif L==0 or take>L+g: return (q,0,[],[])
        t=tea(H)
        if variant=='teach-after-age': t=tea(H[:s-1] if s>0 else [])
        eh,eo=entrants(t,qq)
        if variant=='end-after-enter':
            if L==0 or take+eh+eo>L+g: return (q,0,[],[])
        q2=rev if rev is not None and H0>0 and src!='outside' else q
        return (q2,L+g-take,([eh]+H)[:s],([eo]+O)[:s])
    return step
def settled(q,L,s): return (q,L,[q]*s,[])
def gone(x): return x[1]==0 and sum(x[2])==0 and sum(x[3])==0
def held(x): return sum(x[2])>0
def battery(step):
    N=collections.Counter();W={}
    def bad(k,*a):
        N[k]+=1;W.setdefault(k,a)
    def run(p,x,k):
        for _ in range(k):x=step(p,x)
        return x
    for s,l,g,f,q,L in R(range(1,5),range(0,6),range(0,10),range(0,4),range(0,4),range(1,9)):
        p=(s,l,g,f,'members');x=settled(q,L,s);ok=True
        for k in range(60):
            if not held(x):ok=False;break
            x=step(p,x)
        if ok!=(l<s and q>=1 and q*s<=g):bad('L2',p,q,L,ok)
        if (q==0 or s<=l) and held(run(p,settled(q,L,s),s)):bad('L3u',p,q,L)
        if l<s and q*s>g:
            d=q*s-g;x=settled(q,L,s)
            for k in range(L//d+1):
                if x[1]!=L-k*d or x[2]!=[q]*s:bad('L3o',p,q,L,k,x);break
                x=step(p,x)
            if not gone(x):bad('L3o-end',p,q,L,x)
        if l<s and q>=1 and q*s<=g:
            a=settled(q,L,s);b=(q,L,[0]*s,[f]*s);
            for k in range(50):
                y=step(p,a)
                if not held(y) or y[1]<a[1]:bad('L8a',p,q,L,k,y);break
                a=y
            for k in range(300):
                y=step(p,b)
                if g<f*s and gone(y):break
                if not g<f*s and (gone(y) or y[1]<b[1]):bad('L8b keep',p,q,L,k,y);break
                b=y
            else:
                if g<f*s:bad('L8b gone',p,q,L)
            # L9 to zero counted from after the revision
            y=step(p,settled(q,L,s),True,0)
            z=run(p,y,s)
            if held(z):bad('L9 s steps after',p,q,L,z)
            # within
            for rv in (None,q):
                y=step(p,(q,L,[q]*s,[0]*s),True,rv)
                if not(len(y[2])==s and all(c>=1 for c in y[2]) and sum(y[3])==0 and y[1]>=L):bad('L1',p,q,L,y)
    for s,g,f,L in R(range(1,5),range(0,10),range(1,4),range(1,9)):
        p=(s,0,g,f,'none');x=(1,L,[],[f]*s)
        if f*s<=g:
            for k in range(40):
                y=step(p,x)
                if y[3]!=[f]*s or y[1]<x[1]:bad('L6',p,L,y);break
                x=y
        else:
            d=f*s-g
            if not gone(run(p,x,L//d+1)):bad('L6 end',p,L)
    return N,W
for v in ['base','revise-before-enter','enter-before-draw','age-before-draw','no-empty-clause','end-after-enter','teach-after-age']:
    N,W=battery(mk(v))
    print(v,dict(N))
    for k in list(W)[:6]: print('    ',k,W[k])
