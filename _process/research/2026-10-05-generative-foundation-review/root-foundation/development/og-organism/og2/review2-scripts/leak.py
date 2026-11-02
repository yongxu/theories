import sys, itertools, collections
sys.dont_write_bytecode=True
R=itertools.product
# Door strength: T teachers turn away c untaught each; f-c*T others enter past them. c=None means the present door.
def step(p,x,c,on=True):
    s,l,g,f=p;q,L,H,O=x
    take=sum(H)+sum(O)
    if L==0 or take>L+g:return (q,0,[],[])
    T=sum(H[l:])
    eh=q if on and T>0 else 0
    eo=(f if T==0 else (0 if c is None else max(0,f-c*T))) if on else 0
    return (q,L+g-take,([eh]+H)[:s],([eo]+O)[:s])
viol=0;n=0;vw=None;width=collections.Counter();needq2=0;empty=0;tot=0;twosided=0;ex=[]
for s,l,g,f,c in R(range(1,6),range(0,5),range(0,31),range(0,9),range(1,4)):
    if l>=s:continue
    win=[]
    for q in range(1,9):
        e=max(0,f-c*q*(s-l));pred=(q+e)*s<=g
        for L in (1,3,10):
            x=(q,L,[q]*s,[]);ok=True;fall=False
            p=(s,l,g,f)
            for t in range(120):
                if sum(x[2])==0:ok=False;break
                y=step(p,x,c)
                if y[1]<x[1]:fall=True
                x=y
            n+=1
            if ok!=pred or (pred and fall): viol+=1;vw=vw or (p,c,q,L,ok,pred,fall)
        if pred:win.append(q)
    tot+=1
    if not win:empty+=1
    elif win[0]>1:
        needq2+=1
        if len(ex)<3:ex.append(((s,l,g,f,c),win))
print('leaky door: from settled, held forever and level never falls iff (q+max(0,f-c*q*(s-l)))*s<=g: runs',n,'violations',viol,vw)
print('parameter points',tot,'no q works',empty,'q=1 fails and some q>=2 works',needq2,ex)
# compare level-side effect of l: same s, q, f, c, different l
print([((s,l),[q for q in range(1,9) if (q+max(0,6-1*q*(s-l)))*s<=20]) for s,l in [(4,0),(4,1),(4,2),(4,3)]])
# end variants for Q1: ration with no renewal from empty; L8 comparison
def stepR(p,x):
    s,l,g,f,src=p;q,L,H,O=x;H=list(H);O=list(O)
    if L==0: return (q,0,[],[])
    room=L+g
    def cut(C):
        nonlocal room
        out=[]
        for n_ in reversed(C):
            t=min(n_,room);room-=t;out.append(t)
        return list(reversed(out))
    H,O=cut(H),cut(O)
    take=sum(H)+sum(O)
    t=any(c>0 for i,c in enumerate(H) if i>=l)
    eh=q if t else 0;eo=0 if t else f
    return (q,L+g-take,([eh]+H)[:s],([eo]+O)[:s])
bad=0;n=0
for s,l,g,f,q,L in R(range(1,5),range(0,4),range(0,13),range(0,5),range(1,4),range(1,10)):
    if not(l<s and q*s<=g):continue
    p=(s,l,g,f,'members');a=(q,L,[q]*s,[]);b=(q,L,[0]*s,[f]*s)
    for t in range(300):a=stepR(p,a);b=stepR(p,b)
    n+=1
    ga=a[1]==0;gb=b[1]==0
    if ga or (gb!=(g<f*s)): bad+=1
print('L8 under rationed draw, empty level still renews nothing: cases',n,'failures',bad)
