from base import *
import itertools
vs={'teach after ageing':V(teach_after=True),'strictly senior (age>=max(l,1))':V(strict=True),
    'others learn when a teacher appears':V(others_learn='teacher'),'others learn by watching at age l, a holder present':V(others_learn='watch'),
    'untaught at quota':V(others_quota=True),'door kept only while a holder stands':V(door_kept=True)}
def L4_bad(v):
    for s,a,q,door in itertools.product(range(1,5),range(0,5),(0,1,2),('ruled','open')):
        c=(s,a,door,'members')
        for os_ in ((),(0,),(0,1)):
            for on,r in itertools.product((True,False),(None,0,3)):
                y=step(c,(q,(),os_),on,r,v)
                if y[1] or y[0]!=q: return (c,q,os_,on,r,y)
def L5a_bad(v):
    for s,a,q in itertools.product(range(1,5),range(0,5),(0,1,2)):
        c=(s,a,'open','members');x=(q,(),())
        for t in range(10):
            x=step(c,x,True,None,v)
            if x[1] or not x[2]: return (c,q,t,x)
def fam_bad(v):
    out=[]
    for s,a,q,door in itertools.product(range(1,5),range(0,5),(0,1,2),('ruled','open')):
        c=(s,a,door,'members')
        R=reach(c,fresh(q),s+6,revs=(None,0,1),v=v,cap=9)
        h=any(not x[1] and x[2] for x in R)
        if h!=(door=='open'): out.append((c,q,h))
    return out
def route_rev(v):
    out=[]
    for s,a,q in itertools.product(range(1,5),range(0,4),(1,2)):
        if a>=s: continue
        c=(s,a,'open','members');x=fresh(q);x=step(c,x,True,0,v)
        for t in range(s+3): x=step(c,x,True,None,v)
        if not(not x[1] and x[2]): out.append((c,q,x))
    return out
def route_q0_noRev(v):
    out=[]
    for s,a in itertools.product(range(1,5),range(0,5)):
        c=(s,a,'open','members')
        R=reach(c,fresh(0),s+5,revs=(None,),v=v,cap=9)
        if not any(not x[1] and x[2] for x in R): out.append(c)
    return out
for name,v in vs.items():
    print("==",name)
    print(" L1 first bad:",L1_bad(v))
    b=L3_bad(v); print(" L3 window mismatches:",len(b),b[:4])
    print(" L4:",L4_bad(v))
    print(" L5 open, no holder stays hollow:",L5a_bad(v))
    f=fam_bad(v); print(" family law mismatches:",len(f),f[:3])
    r=route_rev(v); print(" revision-to-zero route fails:",len(r),r[:2])
    print(" q=0 no revision: no hollow at:",route_q0_noRev(v)[:3])
# strict window
b=L3_bad(vs['strictly senior (age>=max(l,1))'],want=lambda s,a,q:max(a,1)<s and q>=1); print("strict with max(l,1)<s:",len(b))
b=L3_bad(vs['teach after ageing'],want=lambda s,a,q:a<s and s>=2 and q>=1); print("teach-after with l<s and s>=2:",len(b))
# Under teach after ageing, cut leaves only the oldest holder
c=(3,1,'ruled','members');v=vs['teach after ageing'];print("teach-after, kept state (1,[2]) on:",step(c,(1,(2,),()),True,None,v))
x=fresh(1);tr=[x]
for on in (True,False,True,True):
    pass
# founder with cut then on: reachable loss under teach-after that base rule survives
for s,a in [(3,1),(4,2),(2,1)]:
    c=(s,a,'ruled','members')
    for vname,v in (('base',BASE),('after',vs['teach after ageing'])):
        x=fresh(1)
        for _ in range(s-1): x=step(c,x,False,None,v)
        y=step(c,x,True,None,v); print(" cut to last age then one entrant",(s,a),vname,x,'->',y)
# overlap: at l = s-1 in base does the teacher coexist with the pupil in any state?
for s in (1,2,3,4):
    a=s-1;c=(s,a,'ruled','members');x=fresh(1);co=False;T=[]
    for t in range(3*s+3):
        y=step(c,x,True); T.append(y)
        # pupil age 0 in y from teacher of age s-1 in x: does any holder of teaching age stand in y?
        if 0 in y[1] and any(g>=a for g in y[1]): co=True
        x=y
    print(f" s={s}, l={a}: a teaching-age holder stands beside a new entrant in some state:",co,T[:s+2])
