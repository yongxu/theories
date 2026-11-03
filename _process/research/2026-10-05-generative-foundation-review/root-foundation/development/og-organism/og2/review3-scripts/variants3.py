import sys,itertools as I,collections
sys.dont_write_bytecode=True
from rule3 import tsub,gone,held,e as ee
M='members'
def mk(v):
    def step(p,x,on=True,rev=None):
        s,l,g,f,c,src=p;q,L,H,O=x;H=list(H);O=list(O);H0=sum(H)
        q2=rev if rev is not None and H0>0 and src!='outside' else q
        def ent(T,qq):
            return (qq if on and (src=='outside' or (src==M and T>0)) else 0, (0 if not on else (0 if v=='door-param' and T==0 and src==M else tsub(f,c*T))))
        qq=q2 if v=='revise-before-enter' else q
        if v=='enter-before-draw':
            T=sum(H[l:]);eh,eo=ent(T,qq);H=[eh]+H;O=[eo]+O;take=sum(H)+sum(O)
            if L==0 or take>L+g: return (q,0,[],[])
            return (q2,L+g-take,H[:s],O[:s])
        if v=='age-before-draw':
            H2=H[:max(s-1,0)];O2=O[:max(s-1,0)];T=sum(H2[l:]);take=sum(H2)+sum(O2)
            if L==0 or take>L+g: return (q,0,[],[])
            eh,eo=ent(T,qq);return (q2,L+g-take,([eh]+H2)[:s],([eo]+O2)[:s])
        take=sum(H)+sum(O)
        if v in('renew','ration'):
            if take>L+g or (v=='ration' and L==0):
                if v=='ration' and L==0: return (q,0,[],[])
                room=L+g
                def cut(C):
                    nonlocal room
                    out=[]
                    for n in reversed(C):
                        t=min(n,room);room-=t;out.append(t)
                    return list(reversed(out))
                H,O=cut(H),cut(O);take=sum(H)+sum(O)
        elif v=='end-after-enter':
            T=sum(H[l:]);eh,eo=ent(T,qq)
            if L==0 or take+eh+eo>L+g: return (q,0,[],[])
        elif L==0 or take>L+g: return (q,0,[],[])
        T=sum(H[max(0,0):][l:]) if v!='teach-after-age' else sum(H[:max(s-1,0)][l:])
        eh,eo=ent(T,qq)
        return (q2,L+g-take,([eh]+H)[:s],([eo]+O)[:s])
    return step
def steady(p,q,L,mm=None):
    s,l,g,f,c,_=p;m=tsub(s,l) if mm is None else mm
    ev=tsub(f,c*q*m);return (q,L,[q]*s,[ev]*s)
def battery(v,thr=None,mm=None):
    st=mk(v);N=collections.Counter();W={}
    def bad(k,*a):
        N[k]+=1;W.setdefault(k,a)
    for s,l,g,f,c,q,L in I.product(range(1,5),range(0,5),range(0,15),range(0,5),range(0,4),range(0,5),(1,2,3,6)):
        p=(s,l,g,f,c,M);x=steady(p,q,L);m=tsub(s,l);a=q+tsub(f,c*q*m)
        y=x;ok=True
        for _ in range(45):
            if not held(y): ok=False;break
            y=st(p,y)
        if ok!=(l<s and q>=1 and a*s<=g): bad('L2',p,q,L,ok)
        if l<s and q>=1 and a*s>g:
            d=a*s-g;y=x;k=0
            while k*d<=L:
                if y[1]!=L-k*d or y[2]!=[q]*s or y[3]!=[a-q]*s: bad('L1h',p,q,L,k,y);break
                y=st(p,y);k+=1
            else:
                if not gone(y): bad('L1 end',p,q,L,y)
        if l<s and q>=1 and f>=1:
            ar=a*s;r=x;o=(q,L,[0]*s,[f]*s)
            for _ in range(120): r,o=st(p,r),st(p,o)
            r_end=r[1]==0 and sum(r[2])+sum(r[3])==0;o_end=o[1]==0 and sum(o[2])+sum(o[3])==0
            if r_end!=(ar>g) or o_end!=(f*s>g): bad('L9',p,q,L,r_end,o_end,'row' if ar>g else 'top')
            if ar>g and not r_end: bad('L9 bottom row',p,q,L)
        if f>=1 and g<f*s:
            o=(1,L,[0]*s,[f]*s)
            for _ in range(200):o=st(p,o)
            if not(o[1]==0 and sum(o[3])==0): bad('L8 ruin',p,L)
        if l<s and q>=1 and a*s<=g:
            y=st(p,x,True,None)
            if not (len(y[2])==s and y[1]>=L and all(v_>=1 for v_ in y[2])): bad('L4 case',p,q,L,y)
    for s,l,g,f,c,q,src in I.product(range(1,4),range(0,3),range(0,4),(0,2),(0,2),(1,2),(M,'outside','none')):
        y=st((s,l,g,f,c,src),(q,0,[],[]))
        if not gone(y): bad('L7',s,l,g,f,c,q,src,y)
    return N,W
for v in ['base','revise-before-enter','enter-before-draw','end-after-enter','age-before-draw','teach-after-age','renew','ration','door-param']:
    N,W=battery(v);print(v,dict(N));
    for k in list(W)[:2]: print('   ',k,W[k])
# §5 thresholds under third rule
def thr(v,formula,lab):
    st=mk(v);n=b=0;w=None
    for s,l,g,f,c,q,L in I.product(range(1,5),range(0,5),range(0,20),range(0,5),range(0,4),range(1,5),(1,3,6)):
        p=(s,l,g,f,c,M);want,x=formula(s,l,g,f,c,q,L)
        y=x;ok=True
        for _ in range(60):
            if not held(y): ok=False;break
            y=st(p,y)
        n+=1
        if ok!=want: b+=1;w=w or (p,q,L,ok,want)
    print(lab,'runs',n,'mismatches',b,w)
def fA(s,l,g,f,c,q,L):
    m=tsub(s,l);ev=tsub(f,c*q*m);return (l<s and (q+ev)*(s+1)<=g,(q,L,[q]*s,[ev]*s))
def fA0(s,l,g,f,c,q,L):
    m=tsub(s,l);ev=tsub(f,c*q*m);return (l<s and q*(s+1)<=g,(q,L,[q]*s,[ev]*s))
def fT(s,l,g,f,c,q,L):
    m=tsub(s-1,l);ev=tsub(f,c*q*m);return (l+1<s and (q+ev)*s<=g,(q,L,[q]*s,[ev]*s))
def fT0(s,l,g,f,c,q,L):
    m=tsub(s,l);ev=tsub(f,c*q*m);return (l+1<s and (q+ev)*s<=g,(q,L,[q]*s,[ev]*s))
thr('enter-before-draw',fA,"threshold (q+e)(s+1)")
thr('enter-before-draw',fA0,"DESIGN's threshold q(s+1)")
thr('teach-after-age',fT,"teach after age: l+1<s and e with s-l-1 and own steady")
thr('teach-after-age',fT0,"teach after age: window narrowed by one only, e unchanged")
