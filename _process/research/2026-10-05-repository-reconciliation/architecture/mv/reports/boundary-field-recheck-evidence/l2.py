import json, sys
import lib
from lib import *
MOD='Becoming.U4LeverTwo'
new={}
for l in open('u4l2.jsonl'):
    d=json.loads(l)
    if d['m']==MOD: new[d['n']]=d
C.update(new)
# root by content inside the leaf: leaf constants whose statements reach only root constants or such leaf constants
leafroot=set()
changed=True
while changed:
    changed=False
    for n in new:
        if n in leafroot: continue
        if all((b in root) or (b in leafroot) or (b not in C) for b in own(n)):
            leafroot.add(n); changed=True
ext = root | leafroot
def nt(n, base): return sorted(b for b in direct(n) if b not in base)
thms=[n for n in new if C[n]['k']=='thm' and not aux(n)]
defs=[n for n in new if C[n]['k']!='thm' and not aux(n)]
print('leaf constants', len(new), 'leaf constants on the root by content', len(leafroot))
print('leaf defs on root by content:', sorted(x.replace('Becoming.U4LeverTwo.','') for x in leafroot if x in defs))
fail_loc=[n for n in thms if nt(n, root) and not nt(n, ext)]
print('leaf theorems failing the name test only because leaf helpers are off the root:', len(fail_loc))
for n in sorted(fail_loc)[:30]: print('  ', n.replace('Becoming.U4LeverTwo.',''), '->', [b.replace('Becoming.U4LeverTwo.','') for b in nt(n, root)])
for n in ['all_end_on_root','no_new_dependence_of_given','exact_iff_within','totals_iff_cancel']:
    k='Becoming.U4LeverTwo.'+n
    if k in C: print(n, 'name test (draft 2):', [b.replace('Becoming.','') for b in nt(k, root)])
