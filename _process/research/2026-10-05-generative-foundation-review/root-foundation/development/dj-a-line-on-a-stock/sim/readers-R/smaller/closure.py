# AI-written (reader "smaller"), 16 November 2026. Read only: import closures by following imports, scratch files first.
import re, os, sys
PKG='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
SCR='/Users/ren/theories/tmp/r7/one-model/lean-scratch/'
def path(m, scratch=True):
    rel=m.replace('.','/')+'.lean'
    for b in ((SCR,PKG) if scratch else (PKG,)):
        if os.path.exists(b+rel): return b+rel
def imports(m, scratch=True):
    p=path(m, scratch)
    if not p: return None
    return re.findall(r'^import\s+(\S+)',open(p).read(),re.M)
def closure(m, scratch=True):
    seen=set(); todo=[m]; missing=set()
    while todo:
        x=todo.pop()
        if x in seen: continue
        im=imports(x, scratch)
        if im is None: missing.add(x); continue
        seen.add(x); todo+=im
    return seen, missing
def lines(ms, scratch=True):
    return sum(open(path(m, scratch)).read().count('\n') for m in ms)
for m in ['Becoming.TurningInTime','Becoming.LineOnAStock','Becoming.WayOfUnits','Becoming.LineOnAStockCases']:
    c,miss=closure(m)
    print('scratch %-28s closure (self included) %d modules, %d lines; non-Becoming/missing: %s' % (m,len(c),lines(c),sorted(miss)))
for m in ['Becoming.TurningInTime','Becoming.WayOfUnits']:
    c,miss=closure(m, False)
    print('tracked %-28s closure (self included) %d modules, %d lines; missing: %s' % (m,len(c),lines(c,False),sorted(miss)))
a,_=closure('Becoming.TurningInTime'); b,_=closure('Becoming.LineOnAStock'); c,_=closure('Becoming.WayOfUnits'); d,_=closure('Becoming.LineOnAStockCases')
print('LineOnAStock minus TurningInTime:', sorted(b-a))
print('WayOfUnits minus LineOnAStock:', sorted(c-b))
print('Cases minus LineOnAStock:', sorted(d-b))
for x in ['Becoming.SelectionTerm','Becoming.ReadingsPersist','Becoming.LineageDrawdown','Becoming.LineageRegimes','Becoming.Flow','Becoming.RegimeMargin','Becoming.ReadOffInTime']:
    print(x, 'in TT closure:', x in a, '| in LineOnAStock closure:', x in b)
print('direct imports:', {m: imports(m) for m in ['Becoming.TurningInTime','Becoming.LineOnAStock','Becoming.WayOfUnits','Becoming.LineOnAStockCases','Becoming.ReadingsPersist','Becoming.SelectionTerm']})
print('tracked WayOfUnits imports:', imports('Becoming.WayOfUnits', False))
