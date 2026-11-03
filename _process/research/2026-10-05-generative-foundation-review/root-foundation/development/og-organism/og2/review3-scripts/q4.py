import sys,itertools as I,collections
sys.dont_write_bytecode=True
from rule3 import *
M='members'
# closed form, cap fixed
n=cf=0;w=None
for s,l,g,f,c in I.product(range(1,7),range(0,6),range(0,41),range(0,13),range(0,6)):
    if l>=s: continue
    p=(s,l,g,f,c,M);b=[q for q in range(1,60) if (q+e(p,q))*s<=g];A=g//s;m=c*(s-l);n+=1
    if m>=2: lo=1 if f<=A else max(1,(f-A+m-2)//(m-1));pred=list(range(lo,A+1))
    elif m==1: pred=list(range(1,A+1)) if f<=A else []
    else: pred=list(range(1,A-f+1))
    if pred!=b: cf+=1;w=w or (s,l,g,f,c,b,pred)
print('closed form of band, cap 60: points',n,'mismatches',cf,w)
# Q4: .outside from steady has the same course at l<s: whole state
n=d=0
for s,l,g,f,c,q,L in I.product(range(1,6),range(0,5),range(0,16),range(0,6),range(0,4),range(1,6),(0,1,3,8)):
    if l>=s: continue
    p=(s,l,g,f,c,M);po=(s,l,g,f,c,'outside');a=steady(p,q,L);b=steady(po,q,L)
    for t in range(40):
        a,b=step(p,a),step(po,b);n+=1
        if a!=b: d+=1;break
print('steady under .members vs .outside (no revision): steps',n,'state differences',d)
# Split the one age into teach age lt and keep age lk
def step2(p,x):
    s,lt,lk,g,f,c=p;q,L,H,O=x
    take=sum(H)+sum(O)
    if L==0 or take>L+g: return (q,0,[],[])
    return (q,L+g-take,([q if sum(H[lt:])>0 else 0]+H)[:s],([tsub(f,c*sum(H[lk:]))]+O)[:s])
n=v=0;w=None
for s,lt,lk,g,f,c,q,L in I.product(range(1,6),range(0,7),range(0,6),range(0,16),range(0,6),range(0,4),range(1,5),(1,4)):
    if lk>=s: continue
    a_=q+tsub(f,c*q*(s-lk));p=(s,lt,lk,g,f,c);x=(q,L,[q]*s,[tsub(f,c*q*(s-lk))]*s);ok=True
    for t in range(60):
        if sum(x[2])==0: ok=False;break
        x=step2(p,x)
    n+=1
    if ok!=(lt<s and a_*s<=g): v+=1;w=w or (p,q,L,ok)
print('split ages: held iff lt<s and (q+max(0,f-c*q*(s-lk)))*s<=g: runs',n,'violations',v,w)
# Fixed lk, lt varied: does lt move the band? No by formula; the coupling is the identification lt=lk
# Breach under third rule
def tr(p,x,seq,n):
    o=[x]
    for t in range(n):
        on,rv=seq[t] if t<len(seq) else (True,None);x=step(p,x,on,rv);o.append(x)
    return o
p=(3,2,6,4,2,M);t=tr(p,steady(p,2,30),[(True,0),(True,None),(True,2)],40)
print('in band?',(2+e(p,2))*3<=6,'e',e(p,2));
last=[i for i,x in enumerate(t) if gone(x)][0]
print('breach gone at step',last,'state before',t[last-1],'all held until then:',all(held(x) for x in t[:last]))
print(' draw in cycle',sum(t[8][2])+sum(t[8][3]),t[8])
p=(3,2,6,4,2,M);t=tr(p,steady(p,2,30),[(False,None),(False,None)],40);last=[i for i,x in enumerate(t) if gone(x)][0]
print('by two off steps gone at',last,all(held(x) for x in t[:last]))
# table rows: row1 from steady at s<=l; abandoned at g=0; band's lower edge
p=(1,1,1,1,1,M);print('row1 s<=l',steady(p,3,1),step(p,steady(p,3,1)))
p=(2,2,3,1,1,M);print('row1 s<=l',tr(p,steady(p,3,4),[],3))
p=(1,0,0,0,0,M);print('abandoned g=0',tr(p,(0,3,[0],[]),[],3))
p=(1,0,2,4,2,M);print('below band ends: q=1 in',band if False else '',tr(p,steady(p,1,3),[],5))
print('revision down from band',tr(p,steady(p,2,1),[(True,1)],5))
