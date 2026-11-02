from base import *
import itertools
# 1. per-capita fecundity (clonal age-structured population): same window as R0=(s-l)q>=1
def pc(s,a,q,T=60):
    hs=(0,)
    for t in range(T):
        ent=sum(q for g in hs if g>=a); hs=older(s,hs)
        hs=(0,)*min(ent,3)+hs   # cap for size only; 0 vs >=1 is what matters
        if not hs: return False
    return True
print('clonal per-capita window == R0>=1 == L3:',all(pc(s,a,q)==(max(s-a,0)*q>=1)==(a<s and q>=1) for s,a,q in itertools.product(range(1,8),range(0,10),(0,1,2))))
# 2. OG dictionary: OG2 .given q=1 ages == ReaderRebuilding .supply count>=big ages, .none == .none; cut law
def rr_supply(s,n,on,ages):
    nx=tuple(older(s,ages))
    if len(nx)<n and on: nx=(0,)+nx
    return nx
bad=0
for s,on_seq in itertools.product(range(1,6),itertools.product((True,False),repeat=7)):
    a=(0,);b=(1,(0,),())
    for on in on_seq:
        a=rr_supply(s,99,on,a); b=step((s,99,'ruled','given'),b,on)
        if a!=b[1]: bad+=1
print('OG2 .given q=1 vs ReaderRebuilding .supply (count large), age lists differ:',bad)
bad=0
for s,on_seq in itertools.product(range(1,6),itertools.product((True,False),repeat=7)):
    a=(0,);b=(1,(0,),())
    for on in on_seq:
        a=older(s,a); b=step((s,99,'ruled','none'),b,on)
        if a!=b[1]: bad+=1
print('OG2 .none vs ReaderRebuilding .none, differ:',bad)
# under a cut .members is the same ageing: horizon = tenure - min age whatever the count
print('cut horizon by count (s=5, ages 0):',[ next(t for t in range(1,20) if not (lambda x:[x:=step((5,1,"ruled","members"),x,False) for _ in range(t)][-1])((1,(0,)*n,()))[1]) for n in (1,5,50)])
# 3. ReaderRebuilding port: reader gone with stock left, per source
def read(m,k,l): return (min(l+k,m) if l<m else l)
def rstep(src,s,n,m,on,x):
    l,ag=x; l=max(l-1,0)
    if on: l=read(m,len(ag),l)
    ag=older(s,ag)
    if len(ag)<n:
        if src=='level' and l>=1: l-=1; ag=(0,)+ag
        if src=='supply' and on: ag=(0,)+ag
        if src=='level-gated' and l>=1 and x[1]: l-=1; ag=(0,)+ag
    return (l,ag)
for src in ('level','supply','none','level-gated'):
    found=None;gonepos=0
    for s,n,m,L0 in itertools.product((2,3),(1,2),(2,3),range(0,9)):
        for ons in itertools.product((True,False),repeat=8):
            x=(L0,(0,)*n)
            for on in ons:
                x=rstep(src,s,n,m,on,x)
                if not x[1] and x[0]>0:
                    gonepos+=1
                    if not found: found=(s,n,m,L0,x)
    print('OG source',src,': reader gone with stock left, count',gonepos,'e.g.',found)
# 4. core of samePresence, partition refinement, s=3,l=1, open door, states by (q bit, age set, others set)
def setstep(s,a,x,on,r):
    q,hs,os_=x
    y=step((s,a,'open','members'),(q,tuple(sorted(hs)),tuple(sorted(os_))),on,r)
    return (y[0],frozenset(y[1]),frozenset(y[2]))
def core(s,a,cls):
    ages=[g for g in range(s)]
    subs=[frozenset(c) for L in range(len(ages)+1) for c in itertools.combinations(ages,L)]
    st=[(q,h,o) for q in (0,1) for h in subs for o in subs]
    part={x:cls(x) for x in st}
    while True:
        sig={x:(part[x],frozenset((on,part[setstep(s,a,x,on,r)]) for on in (True,False) for r in (None,0,1))) for x in st}
        ids={}
        new={x:ids.setdefault(sig[x],len(ids)) for x in st}
        if len(set(new.values()))==len(set(part.values())): part=new;break
        part=new
    return st,part
for s,a in [(3,1),(4,2),(3,0),(2,1)]:
    st,part=core(s,a,lambda x:bool(x[1]))
    byo=all(part[(q,h,o)]==part[(q,h,frozenset())] for q,h,o in st)
    hollow=part[(1,frozenset(),frozenset({0}))]==part[(1,frozenset(),frozenset())]
    nohold=len({part[x] for x in st if not x[1]})
    q_matters=any(part[(0,h,o)]!=part[(1,h,o)] for _,h,o in st if h)
    print(f's={s} l={a}: states {len(st)}, blocks {len(set(part.values()))}; others never matter in the core {byo}; hollow and empty one block {hollow}; blocks with no holder {nohold}; quota bit matters {q_matters}')
    blocks={}
    for x in st:
        if x[1] and not x[2]: blocks.setdefault(part[x],[]).append((x[0],tuple(sorted(x[1]))))
    print('   ',list(blocks.values())[:6])
