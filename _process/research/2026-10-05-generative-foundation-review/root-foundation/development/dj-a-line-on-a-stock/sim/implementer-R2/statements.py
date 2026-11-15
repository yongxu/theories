"""Compare declaration headers (up to the first top-level `:=`) of tracked vs scratch modules."""
import re, sys
PKG='/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
SCR='/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/'
def strip(s):
    s=re.sub(r'/-.*?-/','',s,flags=re.S)
    return re.sub(r'--[^\n]*','',s)
def headers(path):
    s=strip(open(path).read())
    out={}; ns=[]
    lines=s.split('\n')
    i=0
    text=s
    for m in re.finditer(r'^(?:private |protected |noncomputable )*(theorem|def|abbrev|instance|structure|inductive|lemma) (\S+)',text,flags=re.M):
        st=m.start()
        k=text.find(':=',st)
        w=text.find(' where',st)
        p=text.find('\n  |',st)
        cut=min(x for x in [k,w,p] if x>=0) if (k>=0 or w>=0 or p>=0) else len(text)
        # for inductive/structure take till next blank line
        if m.group(1) in ('inductive','structure'):
            cut=text.find('\n\n',st)
        h=' '.join(text[st:cut].split())
        out[m.group(2)]=out.get(m.group(2),[])+[h]
    return out
tot=0
for mod in ['TurningInTime','WayOfUnits']:
    a=headers(PKG+mod+'.lean'); b=headers(SCR+mod+'.lean')
    kept=[n for n in a if n in b]; removed=[n for n in a if n not in b]
    diff=[n for n in kept if a[n]!=b[n]]
    print(mod,'tracked',len(a),'kept',len(kept),'removed',len(removed),'changed',len(diff))
    for n in diff: print('  CHANGED',n); print('   T:',a[n]); print('   S:',b[n])
    if mod=='TurningInTime' and removed: print('  REMOVED',removed)
