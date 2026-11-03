from base import *
import itertools
print("L1 base bad:",L1_bad(BASE)); print("L3 base bad:",L3_bad(BASE)[:5])
# L2 edge
def iter_older(s,l,k):
    for _ in range(k): l=older(s,l)
    return l
print("L2 older^0 at tenure 0, [0] ->",iter_older(0,(0,),0))
print("L2 others:",[ (s,l) for s in range(1,6) for l in lists(s,3) if iter_older(s,l,s)!=()][:3])
# tenure 0 window: L3 excludes; what happens?
print("tenure0 l=0 q=1 on:",holds_all((0,0,'ruled','members'),fresh(1),30), " l=1:",holds_all((0,1,'ruled','members'),fresh(1),30))
# L3 with revision in the net: q=1, l<s, rev 0
c=(3,1,'ruled','members');x=fresh(1);tr=[x]
for t in range(6): x=step(c,x,True,0 if t==0 else None);tr.append(x)
print("L3 with a revision to 0:",tr)
# L3 reverse: quota 0 revised up
c=(3,1,'ruled','members');x=fresh(0);tr=[x]
for t in range(8): x=step(c,x,True,1 if t==0 else None);tr.append(x)
print("q=0 revised to 1:",tr[:5],"held",all(y[1] for y in tr))
# L3 'gone by tenure from every level of entrants' / starting ages at or above learning
for s,a,hs in [(2,5,(5,)),(3,3,(3,)),(3,4,(4,0))]:
    c=(s,a,'ruled','members');x=(1,hs,());t=0;tr=[x]
    while x[1] and t<20: x=step(c,x,True);t+=1;tr.append(x)
    print("a>=s, old start",s,a,hs,"gone at",t,"tenure",s,tr)
# exact time of end from founders in failing windows
worst={}
for s,a,q,n in itertools.product(range(1,7),range(0,9),(0,1,2),(1,2)):
    if a<s and q>=1: continue
    c=(s,a,'open','members');x=fresh(q,n);t=0
    while x[1] and t<50: x=step(c,x,True);t+=1
    if t!=s: worst[(s,a,q,n)]=t
print("founders: end step != tenure:",list(worst.items())[:5])
# L5 routes: at tenure 0 cut of `tenure` steps then entrant
for (s,a,q,n) in [(0,0,1,1),(0,3,1,1),(1,0,1,1),(3,1,1,1),(3,1,0,1),(2,3,1,0)]:
    c=(s,a,'open','members');x=fresh(q,n)
    for _ in range(s): x=step(c,x,False)
    y=step(c,x,True)
    print("route cut s then entrant",(s,a,q,n),"->",y,"hollow" if (not y[1] and y[2]) else "NOT hollow")
# L5 first bullet per source
for src in ('members','given','none'):
  for q in (0,1):
    c=(3,1,'open',src);x=(q,(),());tr=[]
    for t in range(4): x=step(c,x,True);tr.append(x)
    print("L5 from no holder",src,"q",q,tr[-1])
# Family law per source: hollow reachable from founders vs door; include revisions
for src,door,q,a,s in itertools.product(('members','given','none'),('open','ruled'),(0,1),(0,1,4),(1,3)):
    c=(s,a,door,src);R=reach(c,fresh(q),s+6,revs=(None,0,1))
    h=any(not x[1] and x[2] for x in R)
    if h!=(door=='open'): print("family law fails",c,"q",q,"hollow reachable",h)
# hollow reached with no empty state on the way: members present at the last holder's exit, no revision vs revision
def continuous(c,q,revs,T):
    x0=fresh(q);seen={x0};fr={x0}
    for _ in range(T):
        nf=set()
        for x in fr:
            if not x[1] and x[2]: return True
            for on in (True,False):
              for r in revs:
                y=step(c,x,on,r)
                if (y[1] or y[2]) and y not in seen and len(y[1])+len(y[2])<=10: seen.add(y);nf.add(y)
        fr=nf
    return any(not x[1] and x[2] for x in seen)
tab={}
for s,a,q in itertools.product(range(1,6),range(0,7),(1,2)):
    c=(s,a,'open','members')
    tab[(s,a,q)]=(continuous(c,q,(None,),s+6),continuous(c,q,(None,0),s+6))
print("hollow with members never empty, no revision False cases:",sorted(k for k,v in tab.items() if not v[0]))
print("  ... with revision False cases:",sorted(k for k,v in tab.items() if not v[1]))
# hollow with no cut and no revision
fal=[(s,a,q) for s,a,q in itertools.product(range(1,6),range(0,7),(0,1,2)) if any(not x[1] and x[2] for x in reach((s,a,'open','members'),fresh(q),s+6,ons=(True,)))]
print("hollow, every step on, no revision, reached exactly at:", all(((a>=s or q==0) == ((s,a,q) in fal)) for s,a,q in itertools.product(range(1,6),range(0,7),(0,1,2))))
# L6 timing
for s,a,q in [(3,1,1),(1,0,1),(4,0,2)]:
    c=(s,a,'ruled','members');x=fresh(q)
    x0=x; x=step(c,x,True,0);t=1;tr=[x0,x]
    while x[1] and t<30: x=step(c,x,True);t+=1;tr.append(x)
    print("L6 revise at step 1:",(s,a,q),"gone at step",t,"counted from post-revision",t-1)
# Revision back on the last holder's exit
c=(3,1,'ruled','members');print("revise back on exit:",step(c,(0,(2,),()),True,1))
# a holder too young to teach revises
c=(3,2,'ruled','members');print("age-0 holder, teaching age 2, revises:",step(c,(1,(0,),()),True,5))
# Quota idle: bisimulation q>=1 at presence and age-support
def sup(x): return (x[0]>=1,frozenset(x[1]),x[2])
bad=0
for s,a,door in itertools.product(range(1,5),range(0,5),('ruled','open')):
    c=(s,a,door,'members')
    for hs in lists(s,2):
      for on in (True,False):
        for r in (None,1,3,0):
            y1=step(c,(1,hs,()),on,None if r is None else r); y2=step(c,(3,hs,()),on,None if r is None else r)
            if sup(y1)!=sup(y2): bad+=1
print("q=1 vs q=3 differ in (bit, age support, others):",bad)
# L8 inside members alone
c=(3,1,'open','members'); print("members last exit, cut: ",(1,(2,),()),"->",step(c,(1,(2,),()),False))
