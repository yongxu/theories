def g(z): return max(0,min(z,12-z))
def step(H,x): z=max(x-H,0); return z+g(z)
def unending(parts,x):
    w=tuple(parts)
    for _ in range(60):
        if not any(n<=x for n,u in w): return False
        use=sum(u for n,u in w)
        w=tuple(p for p in w if p[0]<=x); x=step(use,x)
    return True
viol=[]
for u1 in range(1,6):
  for u2 in range(1,6):
    for n in range(1,10):
      for x in range(0,13):
        for m in range(n,13):
          for m2 in range(m,14):
            if unending([(m,u1),(n,u2)],x) and not unending([(m2,u1),(n,u2)],x): viol.append((u1,u2,n,x,m,m2))
print(len(viol))
for v in viol[:12]: print(v)
# with first part using most and start below H1+y1 roughly
sel=[v for v in viol if v[0]>=v[1]]
print(len(sel)); print(sel[:8])
