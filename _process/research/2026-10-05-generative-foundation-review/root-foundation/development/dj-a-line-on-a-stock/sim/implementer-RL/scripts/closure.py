# AI-written, 16 November 2026. Read only: import closures (module itself included), scratch files first.
import re,os,sys
PKG='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
SCR='/Users/ren/theories/tmp/r7/one-model/lean-scratch/'
def path(m):
    rel=m.replace('.','/')+'.lean'
    for b in (SCR,PKG):
        if os.path.exists(b+rel): return b+rel
def imports(m):
    p=path(m)
    return re.findall(r'^import\s+(\S+)',open(p).read(),re.M) if p else []
def closure(ms):
    seen=set(); todo=list(ms)
    while todo:
        m=todo.pop()
        if m in seen: continue
        seen.add(m); todo+= [i for i in imports(m) if i.startswith('Becoming')]
    return seen
groups=[g.split('+') for g in sys.argv[1:]]
for g in groups:
    print('+'.join(g), len(closure(g)))
