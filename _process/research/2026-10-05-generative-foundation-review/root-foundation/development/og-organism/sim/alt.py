def step2(L,ages,on,s,n,m):
    if L>=1: L-=1
    ages=[a+1 for a in ages if a+1<s]
    if len(ages)<n and L>=1: L-=1; ages.append(0)
    if on:
        for _ in ages:
            if L<m: L+=1
    return L,ages
for n in (1,2,3):
  for s in (2,3):
    m=2; L,a=m,[0]*n; seen=set()
    for t in range(40):
      L,a=step2(L,a,True,s,n,m)
      if t>30: seen.add((L,len(a)))
    print("draw,age,rebuild,read",n,s,sorted(seen))
