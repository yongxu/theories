# AI-written, 16 November 2026. Read only: lines of named declarations (docstring included) in two copies.
import re,sys
def decls(p):
    L=open(p).read().split('\n'); out={}; starts=[]
    for i,l in enumerate(L):
        if re.match(r'^(?:private\s+)?(?:theorem|def|abbrev|instance)\s+\S+',l): starts.append(i)
    for k,i in enumerate(starts):
        name=re.match(r'^(?:private\s+)?(?:theorem|def|abbrev|instance)\s+(\S+)',L[i]).group(1)
        j=i
        while j>0 and (L[j-1].startswith('/--') or (L[j-1] and not L[j-1].startswith(('theorem','def','/-!','end','namespace','section','variable','instance','abbrev','  ','|')) ) or L[j-1].endswith('-/') and not L[j-1].startswith('  ')):
            j-=1
            if L[j].startswith('/--'): break
        e=starts[k+1] if k+1<len(starts) else len(L)
        while e>i and (L[e-1].strip()=='' or L[e-1].startswith('/--') or not L[e-1].startswith((' ','|')) and e-1>i): e-=1
        out.setdefault(name,(j,e))
    return out
a=decls(sys.argv[1]); b=decls(sys.argv[2])
for n in sys.argv[3:]:
    x=a.get(n); y=b.get(n)
    print(f"{n:24s} before {x[1]-x[0] if x else '-':>4} now {y[1]-y[0] if y else '-':>4}")
