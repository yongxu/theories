# AI-written, 16 November 2026. Read only: for each declaration of a module, how many times its name
# occurs outside its own declaration, in code (comments stripped) and in docstrings, across the scratch modules.
import re,sys
SCR='/Users/ren/theories/tmp/r7/one-model/lean-scratch/Becoming/'
mods=['TurningInTime','LineOnAStock','WayOfUnits','LineOnAStockCases']
def strip(t):
    out=[];i=0;d=0
    while i<len(t):
        if t.startswith('/-',i): d+=1;i+=2;continue
        if t.startswith('-/',i) and d>0: d-=1;i+=2;continue
        if t.startswith('--',i) and d==0:
            j=t.find('\n',i); i=j if j>=0 else len(t); continue
        out.append(t[i] if d==0 else ('\n' if t[i]=='\n' else ' ')); i+=1
    return ''.join(out)
src={m:open(SCR+m+'.lean').read() for m in mods}
code={m:strip(src[m]) for m in mods}
target=sys.argv[1]
c=code[target]
lines=c.split('\n')
starts=[(n,re.match(r'^(?:private\s+)?(?:theorem|def|abbrev|instance)\s+(\S+)',l).group(1)) for n,l in enumerate(lines) if re.match(r'^(?:private\s+)?(?:theorem|def|abbrev|instance)\s+\S+',l)]
for k,(n,name) in enumerate(starts):
    e=starts[k+1][0] if k+1<len(starts) else len(lines)
    own='\n'.join(lines[n:e])
    pat=re.compile(r'(?<![\w.])(?:[\w.]*\.)?'+re.escape(name)+r'(?![\w₁₂\'])')
    total=0
    for m in mods:
        cc=code[m] if m!=target else '\n'.join(lines[:n]+['']*(e-n)+lines[e:])
        total+=len(pat.findall(cc))
    rec=len(pat.findall(own))-1
    if total==0: print('UNUSED in code:',name,'(line',n+1,')')
