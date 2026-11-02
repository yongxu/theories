import sys,random
sys.dont_write_bytecode=True
src=open(sys.argv[1]).read().split("S, LS, GS")[0]
ns={};exec(src,ns)
import rule3
random.seed(3);bad=0
for _ in range(500000):
    p=(random.randint(0,6),random.randint(0,7),random.randint(0,10),random.randint(0,5),random.randint(0,4),random.choice(['members','outside','none']))
    x=(random.randint(0,4),random.randint(0,12),[random.randint(0,3) for _ in range(random.randint(0,8))],[random.randint(0,3) for _ in range(random.randint(0,8))])
    on=random.random()<.7;rv=random.choice([None,0,1,3])
    a=rule3.step(p,x,on,rv);b=ns['step'](p,x,on,rv)
    if a!=b: bad+=1;print(p,x,on,rv,a,b)
print('rule3 vs sim3.step: 500000 random steps, differences',bad)
