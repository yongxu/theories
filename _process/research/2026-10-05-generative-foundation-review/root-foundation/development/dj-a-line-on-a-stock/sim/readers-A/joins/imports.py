import re,os,sys
root='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
def imps(mod):
    p=os.path.join(root,mod.replace('.','/')+'.lean')
    if not os.path.exists(p): return []
    out=[]
    for l in open(p):
        m=re.match(r'^import\s+(\S+)',l)
        if m: out.append(m.group(1))
        elif l.strip() and not l.startswith('import') and not l.startswith('--'):
            if out: break
    return out
seen=set()
stack=['Becoming.WayOfUnits','Becoming.SelectionTerm']
while stack:
    m=stack.pop()
    if m in seen: continue
    seen.add(m)
    stack.extend(imps(m))
want=['Becoming.ReadingsPersist','Becoming.RuleCapture','Becoming.LineageDrawdown','Becoming.ReadingsSpread','Becoming.LineageRegimes','Becoming.Flow','Becoming.GrammarLaws','Becoming.ReadOffInTime','Becoming.RegimeMargin','Becoming.TurningInTime','Becoming.Evolution','Becoming.PoolFromCourse','Becoming.Continuation','Becoming.Recurrence','Becoming.GuardedStep']
print(len(seen),'modules reachable')
for w in want: print(w, w in seen)
# who imports WayOfUnits / mentions LineOnAStock in tracked tree
import subprocess
