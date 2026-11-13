import itertools
def step(g,H,x): z=max(x-H,0); return z+g(z)
def unending(parts,x,g):
    w=tuple(parts); seen=set()
    while True:
        if not any(n<=x for n,u in w): return False
        if (w,x) in seen: return True
        seen.add((w,x))
        use=sum(u for n,u in w)
        w2=tuple(p for p in w if p[0]<=x)
        x=step(g,use,x); w=w2
gs={'min12':lambda z:min(z,12-z) if z<=12 else 0,
    'min12pos':lambda z:max(0,min(z,12-z)),
    'half':lambda z:z//2,
    'cap':lambda z:min(z,4)}
viol=[]
for name,g in gs.items():
  for u1 in range(0,6):
    for u2 in range(0,6):
      for n in range(0,10):
        for x in range(0,16):
          for m in range(0,16):
            for m2 in range(m,16):
              a=unending([(m,u1),(n,u2)],x,g); b=unending([(m2,u1),(n,u2)],x,g)
              if a and not b: viol.append((name,u1,u2,n,x,m,m2))
print(len(viol)); 
import collections
print(collections.Counter(v[0] for v in viol))
for v in viol[:15]: print(v)
