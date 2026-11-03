"""Runs of OG2's candidate rule, before any Lean: a level of quota, holders and others by age."""
import itertools
def older(s, l): return [g+1 for g in l if g+1 < s]
def step(cfg, x, on, rev=None):
    s, a, door, src = cfg
    q, hs, os_ = x
    teacher = any(g >= a for g in hs)
    nh, no = older(s, hs), older(s, os_)
    if on:
        if src == 'members' and teacher and q >= 1: nh = [0]*q + nh
        elif src == 'given' and q >= 1: nh = [0]*q + nh
        elif door == 'open': no = [0] + no
    if rev is not None and hs and src != 'given': q = rev
    return (q, nh, no)
def run(cfg, x, k, on=True):
    for _ in range(k): x = step(cfg, x, on)
    return x
def fresh(q, n=1): return (q, [0]*n, [])
bad = []
# 1. outlives its founders iff a < s and q >= 1 (members); given iff q >= 1; none never
for s,a,q,door,src in itertools.product(range(1,6),range(0,7),range(0,3),('ruled','open'),('members','given','none')):
    cfg=(s,a,door,src)
    if sum(1 for _ in [0])==0: pass
    x=fresh(q); ok=True
    for k in range(40):
        if not x[1]: ok=False; break
        x=step(cfg,x,True)
    want={'members':a<s and q>=1,'given':q>=1,'none':False}[src]
    if ok!=want: bad.append(('outlive',cfg,q,ok,want))
# 2. closure of Kept under every course with q' >= 1, members, a < s
for s,a,q,door in itertools.product(range(1,5),range(0,5),(1,2),('ruled','open')):
    if a>=s: continue
    cfg=(s,a,door,'members')
    for ages in itertools.product(range(0,s+2),repeat=2):
      for rev in (None,1,2):
        y=step(cfg,(q,list(ages),[]),True,rev)
        if not y[1]: bad.append(('closure',cfg,q,ages,rev))
# 3. no holders stays no holders on every branch (members)
for s,a,q,door in itertools.product(range(1,5),range(0,5),(0,1,2),('ruled','open')):
    cfg=(s,a,door,'members')
    for os_ in ([],[0],[1,0]):
      for on,rev in itertools.product((True,False),(None,0,3)):
        y=step(cfg,(q,[],list(os_)),on,rev)
        if y[1] or y[0]!=q: bad.append(('absorb',cfg,q,os_,on,rev))
# 4. a cut empties everything by the span, every source
for s,a,q,door,src in itertools.product(range(1,5),range(0,5),(0,1,2),('ruled','open'),('members','given','none')):
    cfg=(s,a,door,src)
    for hs,os_ in itertools.product(itertools.product(range(0,s+2),repeat=2),repeat=2):
        y=run(cfg,(q,list(hs),list(os_)),s,on=False)
        if y[1] or y[2]: bad.append(('cut',cfg,hs,os_))
# 5. returns after a gap iff given (q >= 1)
for s,a,q,door,src in itertools.product(range(1,5),range(0,5),(1,2),('ruled','open'),('members','given','none')):
    y=step((s,a,door,src),(q,[],[]),True)
    if bool(y[1])!=(src=='given'): bad.append(('returns',s,a,q,door,src))
# 6. hollow reachable from founders iff door open (members; a course of s cuts then one on)
for s,a,q,door in itertools.product(range(1,5),range(0,5),(1,2),('ruled','open')):
    cfg=(s,a,door,'members'); seen=False; frontier={(q,(0,),())}
    for _ in range(s+6):
        nf=set()
        for (qq,h,o) in frontier:
            for on in (True,False):
                y=step(cfg,(qq,list(h),list(o)),on)
                t=(y[0],tuple(y[1]),tuple(y[2]))
                if len(t[1])<8: nf.add(t)
                if not y[1] and y[2]: seen=True
        frontier=nf
    if seen!=(door=='open'): bad.append(('hollow',cfg,q,seen))
    if door=='ruled':
        for (qq,h,o) in frontier:
            if o: bad.append(('ruled-others',cfg))
print('counterexamples:',len(bad)); print(bad[:12])
# show the courses
c=(3,1,'open','members'); x=fresh(1)
print('s=3 a=1 open: founders, then revised to 0 at step 2')
for t in range(8):
    print(t,x); x=step(c,x,True,0 if t==2 else None)
c=(2,3,'open','members'); x=fresh(1); print('a>=s: never teaches')
for t in range(5): print(t,x); x=step(c,x,True)
