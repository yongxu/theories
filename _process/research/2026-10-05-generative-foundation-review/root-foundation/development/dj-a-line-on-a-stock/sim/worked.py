"""Worked courses for A4 and E3 on small humps. AI-written (Fable), 16 November 2026."""
from sim import hump, run, step
def course(way, x, need, use, kids, g, n=8):
    out=[]; way=tuple(sorted(way))
    for _ in range(n):
        out.append((''.join('AB'[u] for u in way) or '-', x))
        if not any(need[u] <= x for u in way): break
        way, x = step(way, x, need, use, kids, g)
    return out
found=[]
for c in (12, 14, 16):
    g=hump(c)
    for nA in range(1,4):
        for uA in range(2,8):
            for nB in range(nA+1, c+1):
                for uB in range(1,uA):
                    need=[nA,nB]; use=[uA,uB]; kids=[(0,),(1,)]
                    for x in range(c, c-3, -1):
                        rB=run((1,),x,need,use,kids,g)
                        rA=run((0,),x,need,use,kids,g)
                        rAB=run((0,1),x,need,use,kids,g)
                        if rB[0]=='cycle' and rA[0]=='cycle' and rAB[0]=='cycle':
                            last=rAB[2][-1]
                            if last[0]==(0,):
                                found.append((c,nA,uA,nB,uB,x))
print(len(found))
for f in found[:12]:
    c,nA,uA,nB,uB,x=f; g=hump(c); need=[nA,nB]; use=[uA,uB]; kids=[(0,),(1,)]
    print(f, 'AB:',course((0,1),x,need,use,kids,g), 'B:',course((1,),x,need,use,kids,g,4), 'A:',course((0,),x,need,use,kids,g,4))
