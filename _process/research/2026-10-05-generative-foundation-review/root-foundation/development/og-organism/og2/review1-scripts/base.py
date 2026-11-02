"""Rule as written in DESIGN section 2, with flags for variants. State: (q, holders tuple, others tuple)."""
import itertools
def older(s,l): return tuple(g+1 for g in l if g+1<s)
class V:
    def __init__(s,**k):
        s.teach_after=False; s.strict=False; s.delay=0; s.delay_needs_teacher=False
        s.others_quota=False; s.others_learn=None; s.door_kept=False
        s.__dict__.update(k)
BASE=V()
def step(c,x,on,rev=None,v=BASE):
    s,a,door,src=c; q,hs,os_=x
    nh,no=older(s,hs),older(s,os_)
    pool=nh if v.teach_after else hs
    ages=[g+(0) for g in pool]
    teacher=any((g>a if v.strict else g>=a) for g in ages)
    if v.strict: teacher=any(g>=max(a,1) for g in ages)
    untaught=q if v.others_quota else 1
    open_door=(door=='open') or (v.door_kept and not hs)
    if on:
        if src=='members' and teacher and q>=1: nh=(0,)*q+nh
        elif src=='given' and q>=1: nh=(0,)*q+nh
        elif open_door: no=(0,)*untaught+no
    if v.others_learn=='teacher' and teacher and q>=1 and src=='members':
        nh=no+nh; no=()
    if v.others_learn=='watch':
        conv=tuple(g for g in no if g>=a) if hs else ()
        if conv:
            nh=conv+nh; no=tuple(g for g in no if g<a)
    if rev is not None and hs and src!='given': q=rev
    return (q,nh,no)
def fresh(q,n=1): return (q,(0,)*n,())
def lists(s,maxlen=2,extra=1):
    for L in range(maxlen+1):
        yield from itertools.combinations_with_replacement(range(0,s+extra+1),L)
def reach(c,x0,steps,revs=(None,),ons=(True,False),v=BASE,cap=12):
    seen={x0}; fr={x0}
    for _ in range(steps):
        nf=set()
        for x in fr:
            for on in ons:
                for r in revs:
                    y=step(c,x,on,r,v)
                    if len(y[1])+len(y[2])<=cap and y not in seen: seen.add(y); nf.add(y)
        fr=nf
    return seen
def L1_bad(v,S=range(0,7),A=range(0,7),Q=(1,2,3)):
    for s,a,door in itertools.product(S,A,('ruled','open')):
        if not a<s: continue
        c=(s,a,door,'members')
        for q in Q:
            for hs in lists(s):
                if not hs: continue
                for r in (None,1,2):
                    y=step(c,(q,hs,()),True,r,v)
                    if not(y[0]>=1 and y[1]): return (c,q,hs,r,y)
def holds_all(c,x,T,v=BASE):
    for t in range(T):
        x=step(c,x,True,None,v)
        if not x[1]: return False
    return True
def L3_bad(v,S=range(1,8),A=range(0,10),Q=(0,1,2),N=(1,2,3),want=lambda s,a,q:a<s and q>=1,T=60):
    out=[]
    for s,a,q,n,door in itertools.product(S,A,Q,N,('ruled','open')):
        c=(s,a,door,'members')
        got=holds_all(c,fresh(q,n),T,v)
        if got!=want(s,a,q): out.append((s,a,q,n,door,got))
    return out
