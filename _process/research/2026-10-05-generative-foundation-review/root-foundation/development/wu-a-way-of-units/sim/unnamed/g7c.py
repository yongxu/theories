import random
random.seed(1)
def run(gt,parts,x):
    w=tuple(parts)
    for _ in range(50):
        if not any(n<=x for n,u in w): return False
        use=sum(u for n,u in w); w=tuple(p for p in w if p[0]<=x)
        z=max(x-use,0); x=min(z+gt[min(z,len(gt)-1)],40)
    return True
found=[]
for trial in range(1500):
    gt=[0]+[random.randint(0,6) for _ in range(14)]
    u1=random.randint(1,5);u2=random.randint(1,4);n=random.randint(1,6)
    for x in range(0,15):
      for m in range(n,15):
        a=run(gt,[(m,u1),(n,u2)],x)
        if not a: continue
        for m2 in range(m+1,16):
          if not run(gt,[(m2,u1),(n,u2)],x):
            found.append((gt,u1,u2,n,x,m,m2)); break
    if len(found)>3: break
print(len(found))
for f in found[:4]: print(f)
