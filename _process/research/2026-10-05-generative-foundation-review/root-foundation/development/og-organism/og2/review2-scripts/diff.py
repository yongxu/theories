import sys, random, itertools
sys.dont_write_bytecode=True
sys.path.insert(0, sys.argv[1])
import rule, sim2_copy as o
random.seed(1); n=0; bad=0
for _ in range(600000):
    s=random.randint(0,6); l=random.randint(0,7); g=random.randint(0,10); f=random.randint(0,4)
    src=random.choice(['members','outside','none']); p=(s,l,g,f,src)
    q=random.randint(0,4); L=random.randint(0,12)
    H=[random.randint(0,3) for _ in range(random.randint(0,8))]; O=[random.randint(0,3) for _ in range(random.randint(0,8))]
    on=random.random()<.7; rev=random.choice([None,0,1,3])
    a=rule.step(p,(q,L,H,O),on,rev); b=o.step(p,(q,L,H,O),on,rev)
    n+=1
    if a!=b: bad+=1; print('DIFF',p,q,L,H,O,on,rev,a,b)
print('steps compared',n,'differences',bad)
