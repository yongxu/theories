import sys, itertools, collections
sys.dont_write_bytecode=True
from rule import *
W=collections.defaultdict(list); N=collections.Counter()
def bad(law,*w):
    N[law]+=1
    if len(W[law])<4: W[law].append(w)
R=itertools.product
S_=range(0,6); Ls=range(0,7); G=range(0,13); F=range(0,5); Q=range(0,5); LV=range(0,13)
T=80
# L1 literal, all level, f, Q, off excluded. holders exact s cohorts in [1,Q]; others empty/zeros/longer
for s,l,g,f in R(range(0,5),range(0,6),range(0,13),F):
    for Qm in range(0,5):
        if not(l<s and Qm*s<=g): continue
        for hs in R(range(1,Qm+1),repeat=s):
            for q in range(1,Qm+1):
              for lv in (1,2,5):
                for os_ in ([],[0],[0]*s,[0]*(s+2)):
                  for rv in [None]+list(range(1,Qm+1)):
                    y=step((s,l,g,f,'members'),(q,lv,list(hs),os_),True,rv)
                    N['L1 cases']+=0
                    ok=len(y[2])==s and all(1<=c<=Qm for c in y[2]) and sum(y[3])==0 and 1<=y[0]<=Qm and y[1]>=lv
                    if not ok: bad('L1',s,l,g,f,Qm,hs,q,lv,os_,rv,y)
# L2 literal: on, no rev; held at step 0.. T
for s,l,g,f,q,L in R(S_,Ls,G,F,Q,range(1,13)):
    p=(s,l,g,f,'members');x=settled(q,L,s);ok=True
    for k in range(T):
        if not held(x): ok=False;break
        x=step(p,x)
    if ok!=(l<s and q>=1 and q*s<=g): bad('L2',p,q,L,ok)
# L2 with off steps: one witness class: exists off pattern with window true, not held
for s,l,g,f,q,L in R(range(1,4),range(0,3),range(0,8),[0,1],[1,2],[1]):
    if not(l<s and q*s<=g):continue
    x=settled(q,L,s);p=(s,l,g,f,'members')
    for _ in range(s): x=step(p,x,False)
    if held(x): bad('L2-off-held-still',p,q,L)
    else: N['L2 fails if off steps are in "every step" (cases)']+=1
# L3 unpassed from settled, all levels; from general lists
for s,l,g,f,q,L in R(S_,Ls,G,F,Q,LV):
    if not(q==0 or s<=l):continue
    x=run((s,l,g,f,'members'),settled(q,L,s),s)
    if held(x): bad('L3u settled',s,l,g,f,q,L,x)
for s,l,g,f,q,L in R(range(0,4),range(0,5),range(0,6),[0,1],[0,1,2],[1,3]):
    if not(q==0 or s<=l):continue
    for n in range(0,s+3):
        for hs in R([0,1],repeat=n):
            x=run((s,l,g,f,'members'),(q,L,list(hs),[]),s)
            if held(x): bad('L3u any list',(s,l,g,f,q,L),hs,x)
# L3 overdrawn, literal equality with settled, and up to zeros
for s,l,g,f,q,L in R(S_,Ls,G,F,Q,LV):
    if not(l<s and q*s>g):continue
    d=q*s-g;p=(s,l,g,f,'members');x=settled(q,L,s)
    for k in range(L//d+1):
        if x!=(q,L-k*d,[q]*s,[]): N['L3o literal settled equality fails']+=1
        if (x[0],x[1],x[2],sum(x[3]))!=(q,L-k*d,[q]*s,0): bad('L3o',p,q,L,k,x)
        if not held(x): bad('L3o-held',p,q,L,k,x)
        x=step(p,x)
    if not gone(x): bad('L3o-gone',p,q,L,x)
# L4 whole net, random lists; bisim
for s,l,g,f,L in R(range(0,4),range(0,4),range(0,5),[0,1,2],range(0,5)):
    for O in ([],[1],[0,2],[1,1,1,1,1]):
      for hs0 in ([],[0],[0]*s,[0]*(s+2)):
        for seq in R(R((True,False),(None,0,2)),repeat=3):
            a=(0,L,hs0,O);b=(3,L,hs0,O);p=(s,l,g,f,'members')
            for on,rv in seq:
                a=step(p,a,on,rv);b=step(p,b,on,rv)
                if held(a) or held(b): bad('L4 held',p,L,O,seq)
                if a[0]!=0 or b[0]!=3: bad('L4 quota moved',p,L,O,seq)
                if a[1:]!=b[1:]: bad('L4 differ',p,L,O,seq)
# L5
for s,l,g,f,q,src,on,rv in R(range(0,4),range(0,3),range(0,4),[0,2],[0,2],('members','outside','none'),(True,False),(None,1)):
    for x in ((q,0,[],[]),(q,0,[0,0],[0])):
        if not gone(step((s,l,g,f,src),x,on,rv)): bad('L5',s,l,g,f,q,src,on,rv)
# L6
for s,g,f,L in R(S_,G,F,LV):
    p=(s,0,g,f,'none');x=(1,L,[],[f]*s)
    if f*s<=g and L>=1:
        for k in range(T):
            y=step(p,x)
            if y[3]!=[f]*s or y[1]<x[1]: bad('L6 keep',p,L,k,y);break
            x=y
    elif f*s>g:
        d=f*s-g
        for k in range(L//d+1):
            if sum(x[3])==0 or gone(x): bad('L6 early',p,L,k,x)
            x=step(p,x)
        if not gone(x): bad('L6 gone',p,L,x)
# L6 with holders present under .none, literal (others full, holders unsaid)
for s,g,f,L in R(range(1,4),range(0,9),[1,2],range(1,6)):
    if f*s>g: continue
    x=(1,L,[1],[f]*s)
    y=step((s,0,g,f,'none'),x)
    # transient
    if y[1]<L: bad('L6 needs no holder',s,g,f,L,y)
# L7 door clause
for s,l,g,f,q,L in R(S_,Ls,G,range(1,5),Q,LV):
    for hs in ([],[0]*s,[1]+[0]*max(s-1,0)):
      for O in ([],[1],[0,3],[2]*(s+2)):
        x=(q,L,hs,O);p=(s,l,g,f,'members')
        if any(c>0 for i,c in enumerate(hs) if i>=l): continue
        y=step(p,x)
        if gone(y) and (L==0 or sum(hs)+sum(O)>L+g): continue
        if not(y[3] and y[3][0]==f): bad('L7 door',p,q,L,hs,O,y)
# L7 keep, f*s<=g, no holder, full cohorts, every level
for s,l,g,f,L in R(S_,Ls,G,range(1,5),LV):
    if f*s>g: continue
    p=(s,l,g,f,'members');x=(1,L,[0]*s,[f]*s)
    for k in range(T):
        y=step(p,x)
        if y[3]!=[f]*s or y[1]<x[1]: bad('L7 keep, full',p,L,k,x,y);break
        x=y
# L7 keep, from not-full others with L>=1: does it reach full?
for s,l,g,f,L in R(range(1,5),range(0,4),G,range(1,4),range(1,10)):
    if f*s>g: continue
    for O in ([],[1],[0,2],[5],[0,0,9],[3]*(s+2)):
        p=(s,l,g,f,'members');x=(1,L,[0]*s,O)
        for k in range(T):
            x=step(p,x)
            if gone(x): bad('L7 keep, not yet full',p,L,O,k);break
# L7 ruin, no holder, any others, every level
for s,l,g,f,L,q in R(range(0,6),range(0,5),G,range(1,5),range(0,15),[0,2]):
    if not g<f*s: continue
    for O in ([],[1],[0,2],[9],[3]*(s+3)):
      for hs in ([],[0]*s,[0]*(s+2)):
        p=(s,l,g,f,'members');x=(q,L,hs,O);hit=False
        for k in range(400):
            if gone(x): hit=True;break
            x=step(p,x)
        if not hit: bad('L7 ruin',p,q,L,O,hs)
# L7 reading B: "such a state" = no teacher, young holders present
for s,l,g,f,q,L in R(range(1,5),range(1,4),range(0,13),range(1,5),range(1,4),range(1,40)):
    if not(l<s and q*s<=g<f*s): continue
    hs=[q]+[0]*(s-1)
    x=(q,L,hs,[]);p=(s,l,g,f,'members');hit=False
    for k in range(400):
        if gone(x): hit=True;break
        x=step(p,x)
    if not hit: bad('L7 ruin, no teacher but young holder',p,q,L,hs,x)
for s,l,g,f,q,L in R(range(2,5),range(1,4),G,range(1,5),range(1,4),range(1,10)):
    if not(l<s and f*s<=g): continue
    x=(q,L,[q]+[0]*(s-1),[]);p=(s,l,g,f,'members')
    x=run(p,x,s+5)
    if held(x): bad('L7 keep: holder returned though teacher gone',p,q,L,x)
# L8
for s,l,g,f,q,L in R(S_,Ls,G,F,Q,range(1,13)):
    if not(l<s and q>=1 and q*s<=g): continue
    p=(s,l,g,f,'members');a=settled(q,L,s);b=(q,L,[0]*s,[f]*s)
    la=[L];ok=True
    for k in range(T):
        y=step(p,a)
        if not held(y) or y[1]<a[1]: bad('L8 first',p,q,L,k,y);break
        a=y
    if g<f*s:
        d=f*s-g
        b2=run(p,b,L//d+1)
        if not gone(b2): bad('L8 second gone',p,q,L,b2)
    else:
        for k in range(T):
            y=step(p,b)
            if y[1]<b[1] or (gone(y)): bad('L8 second keep',p,q,L,k,y);break
            b=y
# L9 rev to 0
for s,l,g,f,q,L in R(range(1,6),Ls,G,F,range(1,5),range(1,13)):
    p=(s,l,g,f,'members');x=settled(q,L,s)
    y=step(p,x,True,0)
    if gone(y): continue
    z=run(p,y,s)
    if held(z): bad('L9 to 0',p,q,L,z)
    # one step short: is held?
    z1=run(p,y,s-1)
    if not held(z1) and not gone(z1) and s>=1: N['L9: held at s-1 fails (non-tight)']+=1
    # revised back just before s
    a=y
    for i in range(s-1): a=step(p,a)
    if not gone(a):
        b=step(p,a,True,q)   # revision back on the last holder's step
        if held(b): bad('L9 last-step rev-back still held',p,q,L,b)
    # revised back at s-2 th step: recovers?
    if s>=2:
        a=y
        for i in range(s-2): a=step(p,a)
        if not gone(a) and held(a):
            b=step(p,a,True,q)
            b=run(p,b,3*s)
            if held(b): N['L9 revision back before last exit restores holders (cases)']+=1
# L9 up: revision above: eventually gone
for s,l,g,f,q,L,r in R(range(1,5),range(0,5),range(0,13),F,range(1,4),range(1,10),range(1,6)):
    if not(l<s and q*s<=g and r*s>g): continue
    p=(s,l,g,f,'members');x=step(p,settled(q,L,s),True,r);hit=False
    for k in range(600):
        if gone(x): hit=True;break
        x=step(p,x)
    if not hit: bad('L9 above',p,q,L,r)
# L10
for s,l,g,f,q,L in R(S_,Ls,G,F,range(1,5),range(0,6)):
    if not (q*s<=g): continue
    for src in ('members','outside','none'):
        p=(s,l,g,f,src);e=step(p,(q,L,[],[]))
        if src=='outside' and not held(e) : bad('L10 outside no return',p,q,L,e)
        if src=='none' and held(e): bad('L10 none',p,q,L)
        if src=='members' and held(e): bad('L10 members returns',p,q,L)
    x=settled(q,L,s);p=(s,l,g,f,'outside')
    if L>=1:
      for k in range(T):
        x=step(p,x)
        if not held(x): bad('L10 outside not held',p,q,L,k);break
# Replaced: after s on steps, holders are exactly entrants; any list length
for s,l,g,f,q in R(range(0,5),range(0,5),[20],[1],[1,2]):
    for n in range(0,s+4):
        for hs in R([0,3],repeat=n):
            p=(s,l,g,f,'members');x=(q,50,list(hs),[]);ent=[]
            for k in range(s):
                tea=any(c>0 for i,c in enumerate(x[2]) if i>=l)
                ent.insert(0,q if tea else 0)
                x=step(p,x)
            if x[2]!=ent: bad('Replaced',p,q,hs,x,ent)
for k in sorted(set(N)|set(W)):
    print(k,N[k]);
    for w in W[k]: print('   ',w)
