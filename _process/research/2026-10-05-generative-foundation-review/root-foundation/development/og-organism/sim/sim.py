import itertools
def step(L, ages, on, s, n, m, src='level', readmode='each'):
    if L>=1: L-=1                       # 1 draw
    if on:                               # 2 read
        if readmode=='each':
            for _ in ages:
                if L<m: L+=1
        else:
            if L<m: L+=len(ages)
    ages=[a+1 for a in ages if a+1<s]    # 3 age
    if len(ages)<n:                      # 4 rebuild
        if src=='level' and L>=1: L-=1; ages.append(0)
        elif src=='supply' and on: ages.append(0)
    return L, ages
def horizon(L0, ages0, s, n, m, src='level', T=60):
    L, a = L0, list(ages0)
    for t in range(1,T):
        L,a = step(L,a,False,s,n,m,src)
        if not a: return t
    return None
for n in (1,2):
  for s in (2,3):
    profs=set(tuple(sorted(p)) for p in itertools.product(range(s),repeat=n))
    for p in sorted(profs):
      print(f"n={n} s={s} ages={p}: h(L0=0..5)=",[horizon(L0,p,s,n,2) for L0 in range(6)])
# viability with supply on
print("supply on, 40 steps, m=2:")
for n in (1,2):
  for s in (2,3):
    for mode in ('each','all'):
      L,a=2,[0]*n
      tr=[]
      for t in range(40):
        L,a=step(L,a,True,s,n,2,'level',mode); tr.append((L,len(a)))
      print(n,s,mode,tr[:10],'...',tr[-2:])
print("steady (d), supply on, states after 30 steps (L,count):")
for n in (1,2,3):
  for s in (2,3):
    for m in (2,3):
      L,a=m,list(range(min(n,s)))[:n]+[0]*(n-min(n,s))
      seen=[]
      for t in range(40):
        L,a=step(L,a,True,s,n,m); 
        if t>=30: seen.append((L,len(a)))
      print(f"n={n} s={s} m={m}", sorted(set(seen)))
print("(c) given reader n=1 m=2 from L=2:", end=' ')
L=2
for t in range(5):
    L-=1; L+= 1 if L<2 else 0; print(L,end=' ')
print()
print("longer L0 n=1 s=2 ages0:", [horizon(L0,(0,),2,1,2) for L0 in range(12)])
print("longer L0 n=2 s=3 (0,0):", [horizon(L0,(0,0),3,2,2) for L0 in range(14)])
print("(d) from a state with L0 but reader at age s-1, n=1,s=3:", [horizon(L0,(2,),3,1,2) for L0 in range(10)])
