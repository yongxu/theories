"""E5 scan over the Lean bodies (comments stripped) of ALL 406 modules: which have identifiers for
(1) multiplying units, (2) a cost, (3) a level/stock, (4) giving."""
import os,re
SRC="/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
def strip(t):
    t=re.sub(r"/-.*?-/","",t,flags=re.S); return re.sub(r"--.*","",t)
P={"mult":r"offspring|kids|children|descend|Descend|lineage|Lineage|doubling|copying|births?\b|Generations|\* *2 *\^|carrier",
   "cost":r"\bcost\b|Cost\b|\bc \+ |price|forgo",
   "level":r"\blevel\b|stock|Stock|\bstore\b|reserve|fuel",
   "give":r"\bgive\b|\bgives\b|giving|Giving|contrib|\bgift|renew"}
for f in sorted(os.listdir(SRC)):
    t=strip(open(os.path.join(SRC,f),encoding="utf-8").read())
    c={k:len(re.findall(p,t)) for k,p in P.items()}
    if all(v>=3 for v in c.values()):
        print(f[:-5],c)
