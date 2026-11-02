import sys,itertools as I,collections
sys.dont_write_bytecode=True
from rule3 import *
N=collections.Counter();W={}
def bad(k,*a): N[k]+=1;W.setdefault(k,a)
Sx=range(0,5);Lx=range(0,6);Gx=range(0,13);Fx=range(0,5);Cx=range(0,4);Qx=range(0,5);LV=(0,1,2,3,5,8)
M='members'
for s,l,g,f,c,q,L in I.product(Sx,Lx,Gx,Fx,Cx,Qx,LV):
    p=(s,l,g,f,c,M);x=steady(p,q,L);a=q+e(p,q)
    if l<s and q>=1:
        if a*s<=g:
            if L>=1 and step(p,x)!=steady(p,q,L+g-a*s): bad('L1 keep',p,q,L)
        else:
            d=a*s-g;k=0;y=x
            while k*d<=L:
                if y!=steady(p,q,L-k*d): bad('L1 horizon',p,q,L,k,y)
                y=step(p,y);k+=1
            if not gone(y): bad('L1 end',p,q,L,y)
    if L>=1:
        y=x;ok=True
        for _ in range(50):
            if not held(y): ok=False;break
            y=step(p,y)
        if ok!=(l<s and q>=1 and a*s<=g): bad('L2',p,q,L,ok)
# L3 witnesses + closed form
def band(s,l,g,f,c): 
    p=(s,l,g,f,c,M); return [q for q in range(1,40) if l<s and (q+e(p,q))*s<=g]
print('L3',band(1,0,2,4,2),band(4,2,20,6,1),band(4,3,20,6,1))
cf=0;n=0;above=0;t=0;above_cm1=0
for s,l,g,f,c in I.product(range(1,7),range(0,6),range(0,41),range(0,13),range(0,6)):
    if l>=s: continue
    b=band(s,l,g,f,c);A=g//s;m=c*(s-l);n+=1
    if m>=2:
        lo=1 if f<=A else (f-A+m-2)//(m-1)   # ceil((f-A)/(m-1))
        lo=max(lo,1);pred=[q for q in range(lo,A+1)]
    elif m==1: pred=list(range(1,A+1)) if f<=A else []
    else: pred=list(range(1,A-f+1))
    if pred!=[q for q in b]: cf+=1;W.setdefault('closed',(s,l,g,f,c,b,pred))
    if b and b[0]>1:
        above+=1
        if m<2: above_cm1+=1
print('band closed form: points',n,'mismatches',cf,W.get('closed'),'| only q>1:',above,'of which c(s-l)<2:',above_cm1)
# quota size in actual runs: q>=2 held where q=1 fails
cnt=0;w=None;tot=0
for s,l,g,f,c,L in I.product(range(1,5),range(0,4),Gx,Fx,Cx,(1,3)):
    if l>=s: continue
    def h(q):
        p=(s,l,g,f,c,M);x=steady(p,q,L)
        for _ in range(60):
            if not held(x): return False
            x=step(p,x)
        return True
    tot+=1
    if not h(1) and any(h(q) for q in (2,3,4,5)): cnt+=1;w=w or (s,l,g,f,c,L)
print('run: q=1 fails, q>=2 held forever:',cnt,'of',tot,w)
# from no others (a founding), same?
cnt=0;w=None
for s,l,g,f,c,L in I.product(range(1,5),range(0,4),Gx,Fx,Cx,(1,3)):
    if l>=s: continue
    def h(q):
        p=(s,l,g,f,c,M);x=(q,L,[q]*s,[])
        for _ in range(60):
            if not held(x): return False
            x=step(p,x)
        return True
    if not h(1) and any(h(q) for q in (2,3,4,5)): cnt+=1;w=w or (s,l,g,f,c,L)
print('same, founders with no others:',cnt,w)
# L4
for s,l,g,f,c in I.product(range(1,4),range(0,4),range(0,14),range(0,5),range(0,4)):
    if l>=s: continue
    for P,Q in [(a,b) for a in range(1,4) for b in range(a,4)]:
        E=tsub(f,c*P*(s-l))
        if (Q+E)*s>g: continue
        p=(s,l,g,f,c,M)
        for hs in I.product(range(P,Q+1),repeat=s):
          for n_ in range(0,s+1):
            for os_ in I.product(sorted({0,E,E//2}),repeat=n_):
              for q,rv,L in I.product(range(P,Q+1),[None]+list(range(P,Q+1)),(1,4)):
                y=step(p,(q,L,list(hs),list(os_)),True,rv)
                if not(len(y[2])==s and all(P<=v<=Q for v in y[2]) and len(y[3])<=s and all(v<=E for v in y[3]) and P<=y[0]<=Q and y[1]>=L): bad('L4',p,P,Q,hs,os_,q,rv,L,y)
                # source unread inside the region
                if rv is None and step((s,l,g,f,c,'outside'),(q,L,list(hs),list(os_)),True,None)!=y: bad('L4 source read',p)
# L5
for s,l,g,f,c,q,L in I.product(range(0,4),range(0,5),range(0,5),(0,2),(0,1,2),(0,1,2),(0,1,3)):
    if not(q==0 or s<=l): continue
    p=(s,l,g,f,c,M)
    for n_ in range(0,s+1):
      for hs in I.product((0,1,2),repeat=n_):
        for seq in I.product(I.product((True,False),(None,0)),repeat=s):
            x=(q,L,list(hs),[1])
            for on,rv in seq: x=step(p,x,on,rv)
            if held(x): bad('L5',p,q,L,hs,seq,x)
# L5 over-long
for s,l in [(1,1),(2,2)]:
    p=(s,l,5,1,1,M);x=(1,5,[0]*(l)+[1],[]);y=run(p,x,s)
    if held(y): bad('L5 over-long (excluded by its hypothesis)',p,x,y)
# L6
for s,l,g,f,c,L in I.product(range(0,4),range(0,4),range(0,5),(0,1,2),(0,1,2),range(0,4)):
    p=(s,l,g,f,c,M)
    for O in ([],[1],[0,2],[1]*5):
      for hz in ([],[0]*s,[0]*(s+2)):
        for seq in I.product(I.product((True,False),(None,0,2)),repeat=3):
            a=(1,L,hz,O);b=(4,L,hz,O)
            for on,rv in seq:
                a,b=step(p,a,on,rv),step(p,b,on,rv)
                if held(a) or held(b) or a[1:]!=b[1:] or a[0]!=1 or b[0]!=4: bad('L6',p,L,O,seq);break
# L7
for s,l,g,f,c,q,src,on,rv in I.product(range(0,4),range(0,3),range(0,4),(0,2),(0,2),(0,2),(M,'outside','none'),(True,False),(None,1)):
    for x in ((q,0,[],[]),(q,0,[0,0],[0])):
        if not gone(step((s,l,g,f,c,src),x,on,rv)): bad('L7',s,l,g,f,c,q,src,on,rv)
# L8
for s,l,g,f,c,L in I.product(range(1,5),range(0,4),Gx,range(1,5),(0,1,3),range(0,9)):
    p=(s,l,g,f,c,M)
    if f*s<=g and L>=1:
      for n_ in range(0,s+1):
        for O in I.product(sorted({0,f}),repeat=n_):
            x=(1,L,[0]*s,list(O))
            if sum(O)==0: N['L8: others absent at the start state (cases)']+=1
            for _ in range(25):
                y=step(p,x)
                if y[1]<x[1] or sum(y[3])==0 or held(y): bad('L8 keep',p,L,O,y);break
                x=y
    if g<f*s:
      for O in ([],[f],[9],[3]*(s+3),[0,1]):
        for hz in ([0]*s,[0]*(s+2),[]):
            x=(1,L,hz,O);hit=False
            for _ in range(400):
                if gone(x): hit=True;break
                x=step(p,x)
            if not hit: bad('L8 ruin',p,L,O)
# L9
Qd=collections.Counter();Wq={}
for s,l,g,f,c,q,L in I.product(range(1,6),range(0,5),range(0,16),range(1,7),range(0,5),range(1,6),(1,2,5,8)):
    if l>=s: continue
    p=(s,l,g,f,c,M);a=(q+e(p,q))*s;m=c*(s-l)
    r=steady(p,q,L);o=(q,L,[0]*s,[f]*s);kr=kn=None
    for t in range(1,90):
        r,o=step(p,r),step(p,o)
        if kr is None and gone(r): kr=t
        if kn is None and gone(o): kn=t
    if (kr is not None)!=(a>g) or (kn is not None)!=(f*s>g): bad('L9',p,q,L,kr,kn)
    if a>g and f*s>g and (kr!=L//(a-g)+1 or kn!=L//(f*s-g)+1): bad('L9 horizon',p,q,L,kr,kn)
    key=('rule ends' if a>g else 'rule ok','open ends' if f*s>g else 'open ok')
    Qd[key]+=1
    if key==('rule ends','open ok'):
        kind='c=0' if c==0 else ('e=0' if e(p,q)==0 else 'partial leak')
        Qd['bottom-left: '+kind]+=1;Wq.setdefault(kind,(p,q,L))
    if key==('rule ok','open ends'):
        Qd['top-right m=%s'%('<2' if m<2 else '>=2')]+=1
print(dict(Qd),Wq)
# L10
for s,l,g,f,c,q,L in I.product(range(1,5),range(0,4),Gx,Fx,Cx,range(1,5),(1,3)):
    if l>=s: continue
    p=(s,l,g,f,c,M);x=step(p,steady(p,q,L),True,0)
    if held(run(p,x,s)): bad('L10 to 0',p,q,L)
    if (q+e(p,q))*s<=g:
        for r in range(1,6):
            if (r+e(p,r))*s<=g or r>=q: continue
            y=step(p,steady(p,q,L),True,r)
            for _ in range(400):
                if gone(y): N['L10 omitted: revision DOWN below band ends level']+=1;W.setdefault('down',(p,q,L,r));break
                y=step(p,y)
# L11
for s,l,g,f,c,q,L in I.product(range(1,5),range(0,6),range(0,5),(0,2),(0,2),(1,2),(1,3)):
    if not held(step((s,l,g,f,c,'outside'),(q,L,[],[]))): bad('L11 outside',s,l)
    for src in (M,'none'):
        if held(step((s,l,g,f,c,src),(q,L,[],[]))): bad('L11 '+src,s,l)
p=(1,1,5,1,1,M);print('L11 over-long at s<=l, members enters:',step(p,(1,5,[0,1],[])))
p=(1,0,0,1,0,'none');print('L11 .none with a holder at start:',(1,5,[2],[]),step(p,(1,5,[2],[])))
# L12
print('L12 s=0, zero steps:',(1,5,[3],[]))
for s,l,g,f,c,q in I.product(range(1,4),range(0,4),(30,),(1,),(1,),(1,2)):
    for n_ in range(0,s+3):
      for hs in I.product((0,3),repeat=n_):
        for seq in I.product(I.product((True,False),(None,1)),repeat=s):
            p=(s,l,g,f,c,M);x=(q,50,list(hs),[]);ent=[]
            for on,rv in seq:
                T=sum(x[2][l:]);ent.insert(0,x[0] if on and T>0 else 0);x=step(p,x,on,rv)
            if x[2]!=ent: bad('L12',p,q,hs,seq,x,ent)
# Gaps
for s,g,f,c,q,L in I.product(range(2,6),range(0,22),range(0,5),range(0,4),range(1,4),(0,1,4)):
    l=s-1;p=(s,l,g,f,c,M);ee=tsub(f,c*q)
    for pat in I.product((0,1),repeat=s):
        k=sum(pat)
        if not k: continue
        x=(q,L,[q*b for b in pat],[ee if b else f for b in pat]);ok=True
        for _ in range(70):
            if not held(x): ok=False;break
            x=step(p,x)
        if ok!=(k*(q+ee)+(s-k)*f<=g):
            bad('Gaps L>=1' if L>=1 else 'Gaps L=0',p,q,L,pat,ok)
for k in sorted(set(N)|set(W)): print(k,N[k],W.get(k))
