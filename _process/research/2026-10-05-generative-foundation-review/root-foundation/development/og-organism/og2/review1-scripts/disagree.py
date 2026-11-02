# Holders disagree: each holder (age,q). Entrants take the teacher's q. A revision changes one holder's q.
import itertools
from base import older
def old(s,hs): return tuple(sorted((g+1,q) for g,q in hs if g+1<s))
def step_all(s,a,hs,on):
    # every teacher teaches
    n=old(s,hs)
    if on: n=tuple(sorted(n+tuple((0,q) for g,q in hs if g>=a for _ in range(q))))
    return n
def step_one(s,a,hs,on):
    # one teacher admits per step, whichever: a branch per teacher
    n=old(s,hs); ts=[(g,q) for g,q in hs if g>=a]
    if not on or not ts: return [n]
    return [tuple(sorted(n+((0,q),)*q)) for g,q in ts]
Kept=lambda hs:any(q>=1 for g,q in hs)
bad=[]
for s,a in itertools.product(range(1,6),range(0,6)):
    if a>=s: continue
    for hs in itertools.product([(g,q) for g in range(s+1) for q in (0,1,2)],repeat=2):
        if not Kept(hs): continue
        if not Kept(step_all(s,a,hs,True)): bad.append((s,a,hs))
print('every teacher teaches: Kept (some holder q>=1) closure bad:',bad[:3])
bad=[]
for s,a in itertools.product(range(1,6),range(0,6)):
    if a>=s: continue
    for hs in itertools.product([(g,q) for g in range(s+1) for q in (0,1)],repeat=2):
        if not Kept(hs): continue
        for y in step_one(s,a,hs,True):
            if not Kept(y): bad.append((s,a,hs,y));break
print('one teacher a step: Kept closure bad:',len(bad),bad[:2])
# L6: one holder revises to zero, others do not
s,a=3,1; x=((1,1),(2,1)); x=((1,0),(2,1)); print('start, one revised to 0:',x)
for t in range(5): x=step_all(s,a,x,True); print(t,x)
# share of larger quota under no cap
x=((0,1),(0,2));s,a=4,1
for t in range(8):
    x=step_all(s,a,x,True); print(t,'q1',sum(1 for g,q in x if q==1),'q2',sum(1 for g,q in x if q==2))
