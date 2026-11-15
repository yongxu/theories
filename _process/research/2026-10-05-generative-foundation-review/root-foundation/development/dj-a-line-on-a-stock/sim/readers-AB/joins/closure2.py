# AI-written (Fable, reader "joins"), 16 November 2026. Read only: closure of WayOfUnits, tracked against scratch.
import re,os
PKG='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
SCR='/Users/ren/theories/tmp/r7/one-model/lean-scratch/'
def mk(bases):
    def path(m):
        rel=m.replace('.','/')+'.lean'
        for b in bases:
            if os.path.exists(b+rel): return b+rel
    def closure(m,seen):
        p=path(m)
        if not p: return seen
        for i in re.findall(r'^import\s+(\S+)',open(p).read(),re.M):
            if i not in seen and i.startswith('Becoming'):
                seen.add(i); closure(i,seen)
        return seen
    return closure
t=mk([PKG])('Becoming.WayOfUnits',set()); s=mk([SCR,PKG])('Becoming.WayOfUnits',set())
print('tracked WayOfUnits closure',len(t),'scratch',len(s)); print('added:',sorted(x.replace('Becoming.','') for x in s-t))
print('tracked WayOfUnits imports:',re.findall(r'^import\s+(\S+)',open(PKG+'Becoming/WayOfUnits.lean').read(),re.M))
