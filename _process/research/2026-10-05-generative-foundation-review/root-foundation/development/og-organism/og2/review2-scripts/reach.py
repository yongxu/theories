import sys, itertools, collections
sys.dont_write_bytecode=True
from rule import *
R=itertools.product
# Explicit traces of gapped states
def tr(p,x,seq,n=14):
    print(p,x)
    for t in range(n):
        on,rv=seq[t] if t<len(seq) else (True,None)
        x=step(p,x,on,rv); print('  ',t+1,on,rv,x, 'door' if any(c>0 for i,c in enumerate(x[2]) if i>=p[1]) else 'NO DOOR')
print('A: q*s<=g<f*s, settled start, all on, revision 0 then back -> rule held at last step, gone')
print('search shortest course from settled by on/off/rev to a gapped recurrent cycle')
def bfs(p,q,L,revs,offs=True,depth=10):
    st=settled(q,L,p[0]); fr=[(st,[])]; seen=set()
    while fr:
        x,path=fr.pop(0)
        if len(path)>=depth: continue
        for on,rv in R((True,False) if offs else (True,),revs):
            y=step(p,x,on,rv)
            key=(y[0],y[1],tuple(y[2]),tuple(y[3]))
            if key in seen or gone(y): continue
            seen.add(key)
            np=path+[(on,rv)]
            yield y,np
            fr.append((y,np))
def eventually(p,x):
    seen={};k=0;lv=[]
    while True:
        if gone(x): return ('gone',k,lastheld)
        key=(tuple(x[2]),tuple(x[3]))
        if key in seen: return ('cycle',k-seen[key],x[1]-lv[seen[key]],x)
        seen[key]=k;lv.append(x[1]);lastheld=held(x);x=step(p,x);k+=1
        if k>3000:return('undecided',)
# W1 breach: within the window; rule always held; gone, reached by revisions only (all on)
for s,l,g,f,q,L in [(3,2,6,4,2,30),(3,1,6,4,2,30),(4,3,4,2,1,30),(2,1,2,3,1,30)]:
    p=(s,l,g,f,'members');found=None
    for y,path in bfs(p,q,L,(None,0,q),offs=False,depth=2*s+2):
        r=eventually(p,y)
        if r[0]=='gone' and r[2]:
            found=(path,y,r);break
    print('breach, all-on, revisions only',p,'q',q,'L',L,'window true:',l<s and q*s<=g,'->',found)
    found=None
    for y,path in bfs(p,q,L,(None,),offs=True,depth=2*s+2):
        r=eventually(p,y)
        if r[0]=='gone' and r[2]:
            found=(path,y,r);break
    print('breach, off steps only',p,'->',found)
# W2 q*s>g sustained forever from a gap
for s,l,g,f,q,L in [(3,2,6,1,3,40),(4,3,8,1,3,60),(3,2,4,0,3,40),(3,2,6,1,3,40)]:
    p=(s,l,g,f,'members')
    found=None
    for y,path in bfs(p,q,L,(None,0,q),offs=False,depth=2*s+2):
        r=eventually(p,y)
        if r[0]=='cycle' and r[2]>=0 and any(r[3][2]):
            found=(path,y,r);break
    print('overdrawn at settled yet held forever, all-on rev',p,'q',q,'window',q*s<=g,'->',found)
    found=None
    for y,path in bfs(p,q,L,(None,),offs=True,depth=2*s+2):
        r=eventually(p,y)
        if r[0]=='cycle' and r[2]>=0 and any(r[3][2]):
            found=(path,y,r);break
    print('   by off-steps only ->',found)
tr((3,2,6,4,'members'),settled(2,30,3),[(True,0),(True,None),(True,2)],16)
tr((3,2,6,1,'members'),settled(3,40,3),[(False,None),(False,None)],16)
# abandoned: level, no member, absorbing; f=0
tr((2,1,5,0,'members'),settled(0,3,2),[],5)
tr((2,1,5,0,'members'),settled(1,3,2),[(True,0)],6)
# unpassed row 1 failure
tr((1,1,1,1,'members'),settled(3,1,1),[],3)
tr((2,2,3,1,'members'),settled(3,4,2),[],5)
# row 2 rule held at end
tr((3,3,6,4,'members'),settled(2,1,3),[],5)
