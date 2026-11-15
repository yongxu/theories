# AI-written (Fable, reader "joins"), 16 November 2026. Read only: import closures, scratch files first.
import re,os,sys
PKG='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
SCR='/Users/ren/theories/tmp/r7/one-model/lean-scratch/'
def path(m):
    rel=m.replace('.','/')+'.lean'
    for b in (SCR,PKG):
        if os.path.exists(b+rel): return b+rel
def imports(m):
    p=path(m)
    if not p: return []
    return re.findall(r'^import\s+(\S+)',open(p).read(),re.M)
def closure(m,seen=None):
    seen=seen if seen is not None else set()
    for i in imports(m):
        if i not in seen and i.startswith('Becoming'):
            seen.add(i); closure(i,seen)
    return seen
for m in sys.argv[1:]:
    c=closure(m)
    print(m,len(c),'modules in closure;', 'ReadingsPersist' , 'Becoming.ReadingsPersist' in c, '; WayOfUnits', 'Becoming.WayOfUnits' in c, '; LineOnAStock','Becoming.LineOnAStock' in c,'; RuleCapture','Becoming.RuleCapture' in c, '; PoolFromCourse','Becoming.PoolFromCourse' in c,'; Stock','Becoming.Stock' in c)
