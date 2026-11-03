def sub(a,b): return max(0,a-b)
def teachers(hs,l): return sum(hs[l:])
def step(p,x,on=True,rev=None):
    s,l,g,f,c,src=p; q,L,hs,os_=x
    take=sum(hs)+sum(os_)
    if L==0 or take>L+g: return (q,0,[],[])
    t=teachers(hs,l)
    eh=q if on and (src=='outside' or (src=='members' and t>0)) else 0
    eo=sub(f,c*t) if on else 0
    q2=rev if rev is not None and sum(hs)>0 and src!='outside' else q
    return (q2,L+g-take,([eh]+hs)[:s],([eo]+os_)[:s])
def leak(p,q): s,l,g,f,c,_=p; return sub(f,c*q*sub(s,l))
def steady(p,q,L): return (q,L,[q]*p[0],[leak(p,q)]*p[0])
def band(p,q): s,l,g,*_=p; return l<s and q>=1 and (q+leak(p,q))*s<=g
gone=lambda x:x[1]==0 and sum(x[2])==0 and sum(x[3])==0
rB=(4,2,20,6,1,'members'); rA=(1,0,2,4,2,'members'); rE=(3,2,6,4,2,'members'); rF=(2,1,10,2,1,'members')
print('band rB',[q for q in range(0,8) if band(rB,q)])
# in-band revision from quota 1 to 5 at rB, level 1
for L in (1,3,4,5,50):
    x=steady(rB,1,L); tr=[]
    for k in range(40):
        x=step(rB,x,True,5 if k==0 else None); tr.append(x[1])
        if gone(x): break
    print('rB 1->5 L',L,'levels',tr[:14],'gone' if gone(x) else 'alive', x[2],x[3])
# in-band reverse
x=steady(rB,5,1)
for k in range(30):
    x=step(rB,x,True,1 if k==0 else None)
print('rB 5->1 L1',x, gone(x))
# outside-band revision that doesn't end: to 0 at rF (band?) f*s<=g
print('band rF',[q for q in range(0,12) if band(rF,q)])
x=steady(rF,1,1)
for k in range(200): x=step(rF,x,True,0 if k==0 else None)
print('rF 1->0',x)
# outside the band above, level large, revised out and back
x=steady(rA,2,50); x=step(rA,x,True,3); x=step(rA,x,True,2)
for k in range(300): x=step(rA,x)
print('rA 2->3->2 L50',x)
# outAndBack trace
oab={1:0,3:2}
x=steady(rE,2,30); 
for k in range(19):
    print(k,x, 'held' if sum(x[2])>0 else 'NOTHELD')
    x=step(rE,x,True,oab.get(k))
print(19,x)
# strands gap: reach non-Held w/ level intact? stated ¬∀Held at rE gaps
x=(2,1,[2,0,0],[0,4,4])
for k in range(4):
    print('gap',k,x); x=step(rE,x)
print('gap',4,x)
# c>=1 witness for hold-where-steady-cannot
for s,l,g,f,c,q in [(2,1,4,1,1,3)]:
    p=(s,l,g,f,c,'members'); print('band',band(p,q)); x=(q,1,[q,0],[sub(f,c*q),f]); ok=True
    for k in range(50):
        if sum(x[2])==0: ok=False
        x=step(p,x)
    print('gap held',ok,x)
# search: states Band and strand gaps at c>=1 saves level vs. open entry? gap holds where steady cannot AND f*s>g
out=[]
for s in (2,3):
  for g in range(1,14):
    for f in range(1,7):
      for c in range(1,4):
        for q in range(1,7):
          p=(s,s-1,g,f,c,'members')
          for k in range(1,s):
            if k*(q+sub(f,c*q))+(s-k)*f<=g and not band(p,q) and g<f*s: out.append((s,g,f,c,q,k))
print('gap holds, steady not, open entry ends:',out[:8],len(out))
# stricter: total entrants at rA q=1 vs q=2
print('rA entrants q=2',2+leak(rA,2),'q=1',1+leak(rA,1))
# L9 gloss: f<q+e iff f<q or C=0, q>=1
bad=0
for f in range(0,12):
  for C in range(0,6):
    for q in range(1,12):
      if (f<q+sub(f,C*q))!=(f<q or C==0): bad+=1; print(f,C,q)
print('gloss bad',bad)
