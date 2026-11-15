import re
T='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/TurningInTime.lean'
S='/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/TurningInTime.lean'
pat=re.compile(r'^(private\s+)?(theorem|def|instance|abbrev|structure|inductive|class)\s+(\S+)')
def decls(p):
    out=[]; ns=[]
    for i,l in enumerate(open(p).read().split('\n'),1):
        m=re.match(r'^namespace\s+(\S+)',l)
        if m: ns.append(m.group(1))
        m=re.match(r'^end\s+(\S+)',l)
        if m and ns and ns[-1]==m.group(1): ns.pop()
        m=pat.match(l)
        if m: out.append(('.'.join(ns[2:]+[m.group(3)]),m.group(2),bool(m.group(1)),i))
    return out
dt=decls(T); ds=decls(S)
nt={d[0] for d in dt}
print('tracked',len(dt),'theorems',sum(d[1]=='theorem' for d in dt),'scratch',len(ds),'theorems',sum(d[1]=='theorem' for d in ds))
for d in ds:
    if d[0] not in nt: print(d)
print('removed:',[d for d in dt if d[0] not in {x[0] for x in ds}])
