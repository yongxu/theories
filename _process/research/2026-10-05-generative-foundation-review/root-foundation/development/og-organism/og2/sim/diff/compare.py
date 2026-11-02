import importlib.util,sys
spec=importlib.util.spec_from_file_location('sim3','../sim3.py')
m=importlib.util.module_from_spec(spec)
sys.argv=['x']
src=open(spec.origin).read().split("if __name__")[0]
g={}
exec(src,g)
step=g['step']
lists=[[],[1],[2,0],[0,2],[1,1,1],[3,0,1,2]]
fmt=lambda l:'['+', '.join(map(str,l))+']'
moves=[(True,None),(False,None),(True,0),(True,2),(False,2)]
out=[]
for s in [0,1,2,3]:
 for l in [0,1,3]:
  for G in [0,2,5]:
   for f in [0,1,4]:
    for c in [0,2]:
     for n in ['members','outside','none']:
      for q in [0,2]:
       for L in [0,1,4]:
        for hs in lists:
         for os_ in lists:
          for on,rev in moves:
           y=step((s,l,G,f,c,n),(q,L,hs,os_),on,rev)
           out.append(f"{s} {l} {G} {f} {c} {n} {q} {L} {fmt(hs)} {fmt(os_)} {'true' if on else 'false'} {'none' if rev is None else '(some '+str(rev)+')'} -> {y[0]} {y[1]} {fmt(y[2])} {fmt(y[3])}")
open('py.txt','w').write('\n'.join(out)+'\n')
