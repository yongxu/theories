import sys, itertools, collections
sys.dont_write_bytecode=True
from rule import *
R=itertools.product
# Filtered edge results
print('--- edge filters (s>=1 etc)')
c=collections.Counter(); w={}
def note(k,*a):
    c[k]+=1; w.setdefault(k,a)
for s,l,g,f,q,L in R(range(1,6),range(0,7),range(0,13),range(0,5),range(1,5),range(0,6)):
    if q*s>g: continue
    p=(s,l,g,f,'outside')
    e=step(p,(q,L,[],[]))
    if not held(e): note('L10 outside no return, s>=1',p,q,L,e)
    if L>=1:
        x=settled(q,L,s)
        for k in range(60):
            x=step(p,x)
            if not held(x): note('L10 outside not held, s>=1,L>=1',p,q,L,k);break
for s,l,g,f,q,L in R(range(1,4),range(0,5),range(0,6),[0,1],[0,1,2],[1,3]):
    if not(q==0 or s<=l):continue
    for n in range(0,s+3):
        for hs in R([0,1],repeat=n):
            x=run((s,l,g,f,'members'),(q,L,list(hs),[]),s)
            if held(x):
                k='L3u any list s>=1 '+('len<=s' if n<=s else 'len>s')
                note(k,(s,l,g,f,q,L),hs,x)
for s,l,g,f,L in R(range(1,6),range(0,7),range(0,13),range(1,5),range(1,13)):
    if f*s>g: continue
    p=(s,l,g,f,'members');x=(1,L,[0]*s,[f]*s)
    for k in range(80):
        y=step(p,x)
        if y[3]!=[f]*s or y[1]<x[1]: note('L7 keep full, L>=1',p,L,k,y);break
        x=y
for s,l,g,f,q in R(range(1,5),range(0,5),[20],[1],[1,2]):
    for n in range(0,s+4):
        for hs in R([0,3],repeat=n):
            p=(s,l,g,f,'members');x=(q,50,list(hs),[]);ent=[]
            for k in range(s):
                tea=any(cc>0 for i,cc in enumerate(x[2]) if i>=l); ent.insert(0,q if tea else 0); x=step(p,x)
            if x[2]!=ent: note('Replaced s>=1',p,q,hs,x,ent)
for k in c: print(k,c[k],w[k])
# Table rows from settled, all-on, no revision
print('--- s4 table rows, from settled, on, no revision')
c=collections.Counter(); w={}
for s,l,g,f,q,L in R(range(1,6),range(0,7),range(0,13),range(0,5),range(0,5),range(1,13)):
    p=(s,l,g,f,'members');x=settled(q,L,s)
    if q==0 or s<=l:   # unpassed
        row='row1' if f*s<=g else 'row2'
        last=None;ended_held=False;minL=L
        for k in range(300):
            y=step(p,x)
            if gone(y):
                ended_held=held(x);break
            x=y;minL=min(minL,x[1])
        if row=='row1':
            if gone(y):
                note('row1 gone (overdraw before unpassed)',p,q,L,'held at end' if ended_held else '')
            else:
                if sum(x[3])==0: note('row1 no members left (f=0): level, no member',p,q,L,x)
                if minL<L: note('row1 level fell below start and does not come back to it at f*s==g?',p,q,L,minL,x[1])
        else:
            if not gone(y): note('row2 not gone',p,q,L,x)
            elif ended_held: note('row2 gone with rule still held at the last step',p,q,L)
    elif q*s>g:
        pass
for k in c: print(k,c[k],w[k])
# All-on, no revision: (H,O) deterministic until end. Classify eventual behaviour over all initial holder patterns
print('--- eventual classes, all-on no revision, initial H in {0,q}^s, O empty, big level')
def classify(p,q,L,H,O):
    x=(q,L,list(H),list(O));seen={};lv=[]
    for k in range(4000):
        key=(tuple(x[2]),tuple(x[3]))
        if gone(x): return ('gone', 'heldlast' if lastheld else 'noholderlast',lastdoor)
        if key in seen:
            per=k-seen[key];dr=x[1]-lv[seen[key]]
            return ('cycle',per,dr,tuple(x[2]),tuple(x[3]))
        seen[key]=k;lv.append(x[1])
        lastheld=held(x);l_=p[1];lastdoor=any(c>0 for i,c in enumerate(x[2]) if i>=l_)
        x=step(p,x)
    return ('undecided',)
T=collections.Counter();ex={}
for s,l,g,f,q in R(range(1,6),range(0,6),range(0,16),range(0,5),range(1,5)):
    if l>=s: continue
    p=(s,l,g,f,'members')
    for H in R([0,q],repeat=s):
        if sum(H)==0 or not all(H) and False: continue
        r=classify(p,q,200,H,[])
        full=all(H)
        if r[0]=='cycle':
            Hc,Oc=r[3],r[4]
            hp=any(Hc);gap=hp and not all(Hc);om=sum(Oc)>0
            kind=('held' if hp else 'no holder')+(', gapped' if gap else ', full' if hp else '')+(', others' if om else ', no others')
            dr=r[2]; kind+=(', level rises' if dr>0 else ', level steady' if dr==0 else ', level falls')
            kind+=' | q*s'+('<=' if q*s<=g else '>')+'g | f*s'+('<=' if f*s<=g else '>')+'g'
        elif r[0]=='gone':
            kind='gone, '+r[1]+(' door up last' if r[2] else ' door down last')+' | q*s'+('<=' if q*s<=g else '>')+'g | f*s'+('<=' if f*s<=g else '>')+'g | start '+('full' if full else 'gapped')
        else: kind='undecided'
        T[kind]+=1; ex.setdefault(kind,(p,q,H,r))
for k in sorted(T): print(T[k],k,ex[k])
