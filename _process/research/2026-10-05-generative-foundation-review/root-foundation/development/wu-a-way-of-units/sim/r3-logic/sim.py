import itertools, random
random.seed(1)
def stepR(g,H,x):
    z=max(x-H,0); return z+g(z)
def use(w): return sum(u for (_,u) in w)
def after(w,x): return tuple(p for p in w if p[0]<=x)
def pair(s,g): w,x=s; return (after(w,x), stepR(g,use(w),x))
def can(s): w,x=s; return any(n<=x for (n,_) in w)
def orbit(s,g,N):
    out=[s]
    for _ in range(N): out.append(pair(out[-1],g))
    return out
def unending(s,g,N=400):
    seen=set(); c=s
    for _ in range(N):
        if not can(c): return False
        if c in seen: return True
        seen.add(c); c=pair(c,g)
    return None
def Short(g,H,y): return all(g(z)<H for z in range(y))
def Meets(g,H,y,hi): return all(H<=g(z) for z in range(y,hi+1) if z+H<=hi)
def Keeps(g,H,hi): return all(stepR(g,H,x)<=hi for x in range(hi+1))
def yof(g,H,hi):
    y=0
    while y<=hi+1 and g(y)<H: y+=1
    return y
gives=[lambda z:min(z,12-z) if z<=12 else 0]
for _ in range(200):
    tbl=[0]+[random.randint(0,7) for _ in range(30)]
    gives.append(lambda z,t=tbl: t[z] if z<len(t) else 0)
# ---- G1, G2
bad=0
for g in gives[:40]:
  for _ in range(30):
    w=tuple((random.randint(0,6),random.randint(0,4)) for _ in range(random.randint(0,4)))
    x=random.randint(0,14)
    o=orbit((w,x),g,8)
    for n in range(9):
      for p in set(w):
        lhs = p in o[n][0]
        rhs = all(p[0]<=o[j][1] for j in range(n))
        if lhs!=rhs: bad+=1
    for xx in range(15):
      if (after(w,xx)==w)!=all(p[0]<=xx for p in w): bad+=1
print("G1/G2 failures",bad)
# ---- G4
def G4rhs(s,g,hi,ys,nonempty,N=200):
    c=s
    for k in range(N):
        S,z=c
        ok = all(p[0]<=z for p in S) and use(S)+ys(use(S))<=z and (len(S)>0 or not nonempty)
        if ok: return True
        if not can(c): return False
        c=pair(c,g)
    return False
cnt=dict(tested=0,fail_nonempty=0,fail_empty_allowed=0)
ex=None
for g in gives:
  if g(0)!=0: continue
  for hi in range(4,16):
    ys=lambda H,g=g,hi=hi: yof(g,H,hi)
    okprem=all(Short(g,H,ys(H)) and Meets(g,H,ys(H),hi) and Keeps(g,H,hi) for H in range(0,25))
    if not okprem: continue
    for _ in range(40):
      w=tuple((random.randint(1,8),random.randint(0,6)) for _ in range(random.randint(0,4)))
      x=random.randint(0,hi)
      L=unending((w,x),g)
      assert L is not None
      cnt['tested']+=1
      if L!=G4rhs((w,x),g,hi,ys,True): cnt['fail_nonempty']+=1
      if L!=G4rhs((w,x),g,hi,ys,False):
          cnt['fail_empty_allowed']+=1
          if ex is None: ex=(w,x)
print(cnt, "example empty-S failure", ex)
print("---- G4 with premises only on sub-way uses")
def subuses(w):
    return {use(c) for r in range(len(w)+1) for c in itertools.combinations(w,r)}
cnt=dict(tested=0,fail=0,fail_need0=0)
for g in gives:
  if g(0)!=0: continue
  for hi in range(3,16):
    for _ in range(25):
      w=tuple((random.randint(1,8),random.randint(0,6)) for _ in range(random.randint(1,4)))
      ys=lambda H,g=g,hi=hi: yof(g,H,hi)
      if not all(Short(g,H,ys(H)) and Meets(g,H,ys(H),hi) and Keeps(g,H,hi) for H in subuses(w)): continue
      for x in range(hi+1):
        L=unending((w,x),g); cnt['tested']+=1
        if L!=G4rhs((w,x),g,hi,ys,True): cnt['fail']+=1
print(cnt)
g12=lambda z:min(z,12-z) if z<=12 else 0
# need-0 counterexample
w=((0,100),); hi=12; ys=lambda H: yof(g12,H,hi)
print("need0: prem",Short(g12,100,ys(100)),Meets(g12,100,ys(100),hi),Keeps(g12,100,hi),"unending",unending((w,9),g12),"rhs",G4rhs((w,9),g12,hi,ys,True))
# FromNothing dropped
g5=lambda z:5; w=((1,10),); hi=12; y=20
print("nothing: prem",Short(g5,10,y),Meets(g5,10,y,hi),Keeps(g5,10,hi),"unending",unending((w,3),g5),"rhs",G4rhs((w,3),g5,hi,lambda H:y,True))
# start above hi
w=((1,10),); hi=12; y=3
print("hi: prem",Short(g12,10,y),Meets(g12,10,y,hi),Keeps(g12,10,hi),"unending",unending((w,13),g12),"orbit",orbit((w,13),g12,3),"rhs",G4rhs((w,13),g12,hi,lambda H:y,True))
# Short dropped: y too big
w=((1,2),); hi=12; y=5
print("short: prem",Short(g12,2,y),Meets(g12,2,y,hi),Keeps(g12,2,hi),"unending",unending((w,4),g12),"rhs",G4rhs((w,4),g12,hi,lambda H:y,True))
# Meets dropped: y=0 for all
w=((1,5),); hi=12
print("meets: prem",Short(g12,5,0),Meets(g12,5,0,hi),"unending",unending((w,4),g12),"rhs",G4rhs((w,4),g12,hi,lambda H:0,True))
# ---- G6
for m in (10,9,8,7,3):
    w=((m,2),(1,3)); print("G6 m",m, [ (len(s[0]),s[1]) for s in orbit((w,9),g12,5)], unending((w,9),g12))
print("as it was", [stepR(g12,5,x) for x in (9,8,6,2)])
w=((1,5),)
print("meets2: unending",unending((w,6),g12),"rhs",G4rhs((w,6),g12,12,lambda H:0,True))
# Keeps only for some S: search
found=None
for g in gives:
  if g(0)!=0 or found: continue
  for hi in range(3,14):
    for _ in range(30):
      w=tuple((random.randint(1,8),random.randint(0,6)) for _ in range(random.randint(2,3)))
      ys=lambda H,g=g,hi=hi: yof(g,H,hi)
      us=subuses(w)
      if not all(Short(g,H,ys(H)) and Meets(g,H,ys(H),hi) for H in us): continue
      if all(Keeps(g,H,hi) for H in us): continue
      for x in range(hi+1):
        if unending((w,x),g)!=G4rhs((w,x),g,hi,ys,True): found=(w,x,hi,[H for H in us if not Keeps(g,H,hi)]); break
print("Keeps-dropped counterexample:",found)
# ---- G7 / G5 checks, two parts, with g12 and random g
def regime_ok(g,m,h,n,H2,x,hi):
    H1=h+H2; y1=yof(g,H1,hi); y2=yof(g,H2,hi)
    return (Short(g,H1,y1) and Short(g,H2,y2) and Meets(g,H2,y2,hi) and Keeps(g,H2,hi)
            and 0<n<=H2+y2 and x<H1+y1 and x<=hi and n<=m), H2+y2
def G5rhs(g,m,h,n,H2,x,thr):
    X=[x]
    for _ in range(60): X.append(stepR(g,h+H2,X[-1]))
    for T in range(60):
        if X[T]<m: return n<=X[T] and X[T+1]>=thr
        if X[T]<n: return False
    return False
st=dict(g5=0,g5fail=0,g7=0,g7fail=0,g7np=0,g7npfail=0)
ex7=None
for g in gives:
  if g(0)!=0: continue
  for _ in range(40):
    hi=random.randint(4,14); h=random.randint(0,5); n=random.randint(1,6); H2=random.randint(0,5); x=random.randint(0,hi)
    for m in range(n,12):
      ok,thr=regime_ok(g,m,h,n,H2,x,hi)
      L=unending((((m,h),(n,H2)),x),g)
      if ok:
        st['g5']+=1
        if L!=G5rhs(g,m,h,n,H2,x,thr): st['g5fail']+=1
      for m2 in range(m,13):
        L2=unending((((m2,h),(n,H2)),x),g)
        ok2,_=regime_ok(g,m2,h,n,H2,x,hi)
        if ok and ok2:
          st['g7']+=1
          if L and not L2: st['g7fail']+=1
        else:
          st['g7np']+=1
          if L and not L2:
            st['g7npfail']+=1
            if ex7 is None: ex7=(g(0),[g(z) for z in range(14)],m,m2,h,n,H2,x)
print(st); print("G7 without regime premises:",ex7)
print("=== concrete")
for g in gives:
  if g(0)!=0: continue
  w=((2,3),(4,0),(7,0)); hi=6
  ys=lambda H,g=g: yof(g,H,hi)
  us=subuses(w)
  if all(Short(g,H,ys(H)) and Meets(g,H,ys(H),hi) for H in us) and not all(Keeps(g,H,hi) for H in us) and unending((w,6),g)!=G4rhs((w,6),g,hi,ys,True):
    print("g",[g(z) for z in range(14)],"y",{H:ys(H) for H in us},"orbit",orbit((w,6),g,6),"unending",unending((w,6),g)); break
t=[0, 3, 6, 3, 7, 1, 6, 4, 7, 0, 5, 6, 4, 0]; g=lambda z:t[z] if z<len(t) else 0
for m in (4,9):
  print("G7 m",m,orbit((((m,1),(4,5)),8),g,8),unending((((m,1),(4,5)),8),g))
