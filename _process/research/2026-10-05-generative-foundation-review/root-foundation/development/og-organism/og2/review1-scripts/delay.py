# Entrants taught with a delay d: an entrant is a pupil, holds at age d. D1 no teacher needed after entry; D2 a teacher must stand at every step of the pupillage.
import itertools
from base import older
def step(c,x,on,d,need):
    s,a,q0=c; hs,ps=x
    teacher=any(g>=a for g in hs)
    nh,np=older(s,hs),older(s,ps)
    if need and not teacher: np=()
    if on and teacher and q0>=1: np=(0,)*q0+np
    grad=tuple(g for g in np if g>=d); np=tuple(g for g in np if g<d)
    return (grad+nh,np)
for need in (False,True):
    bad=[];rows={}
    for s,a,d,q in itertools.product(range(1,9),range(0,9),range(0,8),(1,2)):
        x=((0,),());ok=True
        for t in range(80):
            x=step((s,a,q),x,True,d,need)
            if not x[0]: ok=False;break
        rows[(s,a,d,q)]=ok
    for f,fn in (('a+d<s',lambda s,a,d:a+d<s),('max(a,d)<s',lambda s,a,d:max(a,d)<s),('a<s',lambda s,a,d:a<s),('d==0 and a<s',lambda s,a,d:d==0 and a<s),('a+d<s or d==0 and a<s',lambda s,a,d:a+d<s or (d==0 and a<s))):
        m=[k for k,v in rows.items() if v!=fn(k[0],k[1],k[2])]
        print('need teacher' if need else 'no need',f,'mismatch',len(m),m[:3])
    # ever held again after a gap, and endless?
    ends={}
    for s,a,d in itertools.product(range(1,9),range(0,9),range(0,8)):
        x=((0,),());gap=False;t=0
        for t in range(120):
            x=step((s,a,1),x,True,d,need)
            if not x[0]: gap=True
        ends[(s,a,d)]=(gap,bool(x[0] or x[1]))
    print(' L4 fails (holder after a holderless state) e.g.:',[k for k,v in ends.items() if v[0] and v[1]][:4])
    print(' endless line window by a<s and d<s?',all((v[1])==(k[1]<k[0] and k[2]<k[0]) for k,v in ends.items()),[ (k,v) for k,v in ends.items() if v[1]!=(k[1]<k[0] and k[2]<k[0])][:4])
print('trace s=3,a=2,d=1, no need:')
x=((0,),());
for t in range(8): print(t,x); x=step((3,2,1),x,True,1,False)
