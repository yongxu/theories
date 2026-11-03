import sys, itertools, collections
sys.dont_write_bytecode=True
from rule import *
R=itertools.product
# 1 gap law: e_t=OR(e_{t-j}, j in l+1..s). Persistent gaps exactly at l=s-1; there k strands, k*q+(s-k)*f vs g
print('== gap law')
persist=collections.Counter();viol=0;n=0;vw=None
for s,l,q in R(range(1,8),range(0,8),[1]):
    if l>=s: continue
    for H in R([0,1],repeat=s):
        if not any(H): continue
        p=(s,l,1000,0,'members');x=(1,10**6,list(H),[])
        for _ in range(4*s*s+20): x=step(p,x)
        if not all(x[2]): persist[(s,l)]+=1
print('holder patterns that stay gapped, by (s,l):',dict(persist))
print('any with l<s-1?',any(l<s-1 for s,l in persist))
for s,g,f,q,L in R(range(1,7),range(0,25),range(0,5),range(1,5),range(1,12)):
    l=s-1
    for H in R([0,q],repeat=s):
        k=sum(1 for c in H if c)
        if k==0: continue
        p=(s,l,g,f,'members');O=[0 if c else f for c in H]
        # the steady others of that pattern: door down exactly at steps when oldest is empty
        x=(q,L,list(H),O)
        pred=k*q+(s-k)*f<=g
        ok=True
        for t in range(120):
            if not held(x): ok=False;break
            x=step(p,x)
        n+=1
        if ok!=pred: viol+=1; vw=vw or (s,g,f,q,L,H,O,ok,pred)
print('l=s-1 law: from k strands with their others, held forever iff k*q+(s-k)*f<=g: cases',n,'violations',viol,vw)
# 2 transient breach: l<s-1, window true, level>=1, on all steps, rule held to last step
print('== breach by transient, l<s-1, window true, from settled by a revision to 0 and back')
fnd=[];cnt=0
for s,l,g,f,q,L in R(range(3,6),range(1,4),range(0,16),range(1,13),range(1,4),range(1,6)):
    if not(l<s-1 and q*s<=g<f*s): continue
    for t in range(1,s):
        p=(s,l,g,f,'members');x=step(p,settled(q,L,s),True,0)
        for _ in range(t-1): x=step(p,x)
        if gone(x) or not held(x): continue
        x=step(p,x,True,q)
        for k in range(200):
            y=step(p,x)
            if gone(y):
                if held(x): cnt+=1; fnd.append((p,q,L,t,k))
                break
            x=y
print('cases',cnt,fnd[:3])
# off steps
fnd=[];cnt=0
for s,l,g,f,q,L in R(range(3,6),range(1,4),range(0,16),range(1,13),range(1,4),range(1,6)):
    if not(l<s-1 and q*s<=g<f*s): continue
    for t in range(1,s):
        p=(s,l,g,f,'members');x=settled(q,L,s)
        for _ in range(t): x=step(p,x,False)
        if gone(x) or not held(x): continue
        for k in range(200):
            y=step(p,x)
            if gone(y):
                if held(x): cnt+=1; fnd.append((p,q,L,t,k))
                break
            x=y
print('off-step cases',cnt,fnd[:3])
# 3 One lemma: settled under members (l<s) = queue of inflow q; same level course as .none with f:=q, all three
print('== one lemma: level course')
bad=0;n=0
for s,l,g,f,q,L in R(range(1,6),range(0,6),range(0,13),range(0,4),range(1,5),range(0,13)):
    if l>=s: continue
    a=settled(q,L,s);b=(0,L,[],[q]*s);c=(0,L,[0]*s,[q]*s);d=settled(q,L,s)
    pa=(s,l,g,f,'members');pb=(s,0,g,q,'none');pc=(s,l,g,q,'members');pd=(s,l,g,f,'outside')
    for t in range(60):
        a,b,c,d=step(pa,a),step(pb,b),step(pc,c),step(pd,d)
        n+=1
        if not(a[1]==b[1]==c[1]==d[1]): bad+=1;break
print('settled(.members) / .none at f:=q / no holder at f:=q / settled(.outside): compared steps',n,'level differences',bad)
# 4 L8 2x2: quadrants
print('== L8 2x2 from settled vs no-holder state')
Qd=collections.Counter()
for s,l,g,f,q,L in R(range(1,6),range(0,6),range(0,16),range(0,5),range(1,5),range(1,13)):
    if l>=s:continue
    a=settled(q,L,s);b=(q,L,[0]*s,[f]*s);p=(s,l,g,f,'members')
    ta=tb=None
    for t in range(300):
        a=step(p,a);b=step(p,b)
        if ta is None and gone(a): ta=t+1
        if tb is None and gone(b): tb=t+1
    key=('q*s<=g' if q*s<=g else 'q*s>g','f*s<=g' if f*s<=g else 'f*s>g')
    res='rule saves' if ta is None and tb else 'rule ruins' if tb is None and ta else 'both go on' if ta is None else ('rule buys time' if ta>tb else 'rule loses time' if ta<tb else 'same end')
    Qd[key+(res,)]+=1
for k in sorted(Qd): print(k,Qd[k])
# 5 single counts: does any law distinguish q=1 from q>1 inside window? door side
print('== q=1 dominates: any (s,l,g,f,L) with q>=2 in window holding where q=1 fails, settled')
c=0
for s,l,g,f,L in R(range(1,5),range(0,5),range(0,13),range(0,4),range(1,6)):
    if l>=s:continue
    def holds(q):
        x=settled(q,L,s);p=(s,l,g,f,'members')
        for t in range(60):
            if not held(x):return False
            x=step(p,x)
        return True
    if not holds(1) and any(holds(q) for q in (2,3,4)): c+=1
print('count',c)
