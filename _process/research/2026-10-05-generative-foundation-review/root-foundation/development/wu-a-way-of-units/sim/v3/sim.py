import random, itertools, sys
random.seed(int(sys.argv[1]) if len(sys.argv)>1 else 1)
def step(g,H,x):
    e=max(x-H,0); return e+g(e)
def taken(w): return sum(u[1] for u in w)
def after(w,x): return tuple(u for u in w if u[0]<=x)
def goes(s): return any(u[0]<=s[1] for u in s[0])
def nxt(g,s): return (after(s[0],s[1]), step(g,taken(s[0]),s[1]))
def course(g,s,N):
    out=[s]
    for _ in range(N): s=nxt(g,s); out.append(s)
    return out
def unending(g,s,cap=2000):
    seen=set()
    for _ in range(cap):
        if not goes(s): return False
        if s in seen: return True
        seen.add(s); s=nxt(g,s)
    raise Exception("cap")
def Short(g,H,y): return all(g(z)<H for z in range(y))
def Meets(g,H,y,hi): return all(H<=g(z) for z in range(y,hi+1) if z+H<=hi)
def Keeps(g,H,hi): return all(step(g,H,x)<=hi for x in range(hi+1))
def mkg(L,from_nothing=True,keepcap=True):
    if random.random()<0.6:
        r=[0];
        for e in range(1,L+1): r.append(r[-1]+random.randint(0,3))
        vals=[min(r[e],L-e) for e in range(L+1)]
        if random.random()<0.3:
            i=random.randint(0,L); vals[i]=random.randint(0,L-i)
    else:
        vals=[random.randint(0,(L-e)) for e in range(L+1)]
    if from_nothing: vals[0]=0
    return lambda z: vals[z] if z<=L else vals[L]
# ---------- W1 unending_iff_holds
BAL=[0,0]
def w1(trials):
    tested=fails=0; ex=None
    for _ in range(trials):
        hi=random.randint(4,14); L=hi+random.randint(0,4)
        g=mkg(L)
        k=random.randint(1,3)
        w=tuple((random.randint(1,hi),random.randint(0,hi//2)) for _ in range(k))
        x=random.randint(0,hi)
        # prefix of course where Goes holds at all j<=k (finite: until end or repeat)
        s=(w,x); seen=[]; 
        while goes(s) and s not in seen:
            seen.append(s); s=nxt(g,s)
        Ts=sorted(set(taken(t[0]) for t in seen))
        ok=True; ychoices={}
        for T in Ts:
            if not Keeps(g,T,hi): ok=False;break
            ys=[y for y in range(0,hi+3) if Short(g,T,y) and Meets(g,T,y,hi)]
            if not ys: ok=False;break
            ychoices[T]=ys
        if not ok: continue
        lhs=unending(g,(w,x))
        for combo in itertools.islice(itertools.product(*[ychoices[T] for T in Ts]),50):
            y=dict(zip(Ts,combo))
            def holds(t): return len(t[0])>0 and all(u[0]<=t[1] for u in t[0]) and taken(t[0])+y[taken(t[0])]<=t[1]
            # rhs: exists k with goes before k and holds at k; holds implies goes, so k ranges over seen
            rhs=any(holds(t) for t in seen)
            tested+=1; BAL[lhs]+=1
            if lhs!=rhs:
                fails+=1; ex=ex or (w,x,hi,y,[g(z) for z in range(L+1)],lhs,rhs)
    print("W1 tested",tested,"fails",fails,ex)
w1(40000)
def orb(g,H,x,N):
    o=[x]
    for _ in range(N): o.append(step(g,H,o[-1]))
    return o
def rhs2(g,m,h,n,H2,y2,x,N=200):
    X=orb(g,h+H2,x,N)
    for T in range(N):
        if all(m<=X[j] for j in range(T)) and n<=X[T] and X[T]<m and H2+y2<=X[T+1]: return True
    return False
def prem2(g,m,h,n,H2,y1,y2,hi,x,below=True,regime2=True,high=True):
    return (n<=m and g(0)==0 and (not regime2 or (Short(g,H2,y2) and Meets(g,H2,y2,hi) and Keeps(g,H2,hi)))
            and 0<n and n<=H2+y2 and Short(g,h+H2,y1) and (not below or x<h+H2+y1) and (not high or x<=hi))
def rnd2(hi):
    return dict(m=random.randint(1,hi),h=random.randint(0,hi//2),n=random.randint(1,hi),H2=random.randint(0,hi//2),
                y1=random.randint(0,hi),y2=random.randint(0,hi),x=random.randint(0,hi))
def w2(trials):
    t=f=0; bal=[0,0]; ex=None
    for _ in range(trials):
        hi=random.randint(4,14); g=mkg(hi+random.randint(0,2) if random.random()<.3 else hi)
        p=rnd2(hi)
        if not prem2(g,hi=hi,**p): continue
        l=unending(g,(((p['m'],p['h']),(p['n'],p['H2'])),p['x']))
        r=rhs2(g,p['m'],p['h'],p['n'],p['H2'],p['y2'],p['x'])
        t+=1; bal[l]+=1
        if l!=r: f+=1; ex=ex or p
    print("W2 tested",t,"ends/never",bal,"fails",f,ex)
def w3(trials,below=True):
    t=f=0; ex=None
    for _ in range(trials):
        hi=random.randint(4,14); g=mkg(hi+random.randint(0,2) if random.random()<.3 else hi)
        p=rnd2(hi); m2=random.randint(p['m'],hi+2)
        if not prem2(g,hi=hi,below=below,**p): continue
        a=unending(g,(((p['m'],p['h']),(p['n'],p['H2'])),p['x']))
        if not a: continue
        b=unending(g,(((m2,p['h']),(p['n'],p['H2'])),p['x']))
        t+=1
        if not b: f+=1; ex=ex or (p,m2,hi)
    print("W3 below=%s tested"%below,t,"fails",f,ex)
def w4(trials,regime2=True,below=True):
    t=f=0; ex=None
    for _ in range(trials):
        hi=random.randint(4,14); g=mkg(hi+random.randint(0,2) if random.random()<.3 else hi)
        p=rnd2(hi); S=p['h']+p['H2']; h2=random.randint(p['h'],S); H2b=S-h2; y2b=random.randint(0,hi)
        if not prem2(g,hi=hi,regime2=regime2,below=below,**p): continue
        if not (Short(g,H2b,y2b) and Meets(g,H2b,y2b,hi) and Keeps(g,H2b,hi) and p['n']<=H2b+y2b): continue
        a=unending(g,(((p['m'],p['h']),(p['n'],p['H2'])),p['x']))
        if not a: continue
        b=unending(g,(((p['m'],h2),(p['n'],H2b)),p['x']))
        t+=1
        if not b: f+=1; ex=ex or (p,h2,H2b,y2b,hi)
    print("W4 regime2=%s below=%s tested"%(regime2,below),t,"fails",f,ex)
def w5(trials):
    t=f=0;ex=None;t2=f2=0
    for _ in range(trials):
        hi=random.randint(4,14); L=hi+3
        g=mkg(L,from_nothing=random.random()<.5)
        n=random.randint(0,hi); m=random.randint(n,hi+2); H2=random.randint(0,hi); x=random.randint(0,L)
        a=unending(g,(((m,0),(n,H2)),x)); b=unending(g,(((n,H2),),x)); t+=1
        if a!=b: f+=1; ex=ex or (m,n,H2,x)
        y1=random.randint(0,hi)
        if g(0)==0 and n>0 and Short(g,H2,y1) and x<H2+y1:
            t2+=1
            if a: f2+=1
    print("takes_nothing_iff_alone tested",t,"fails",f,ex,"| takes_nothing_ends tested",t2,"fails",f2)
w2(200000); w3(300000); w3(300000,below=False); w4(400000); w4(400000,regime2=False); w5(50000)
