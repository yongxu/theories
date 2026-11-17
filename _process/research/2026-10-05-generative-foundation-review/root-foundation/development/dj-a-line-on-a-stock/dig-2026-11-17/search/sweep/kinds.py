"""Rough classification of each module by the kind of object its statements are about.
Counts regex hits in the Lean source with block comments (/- ... -/) and line comments removed."""
import os,re,json
SRC="/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
def strip(txt):
    txt=re.sub(r"/-.*?-/","",txt,flags=re.S)
    txt=re.sub(r"--.*","",txt)
    return txt
PAT={
 "record": r"\bBalances\b|Web F C|Flow F C|\(W : Web\b|\(L : Flow\b|\bWorld\b|W\.active|W\.level|W\.Supported|W\.requires|L\.give\b|L\.take\b|L\.present|w\.web|w\.flow|\.Dependent\b",
 "detlaw": r"Law\.orbit|Law\.run\b|\borbit\b|Law\.process|\bpaced\b|RegimeMargin\.step|\biterate\b|underDraws|Law\.step",
 "ownstep": r"^\s*def (step|next|run|tick|advance|course|turn)\b",
 "process": r"\bProcess\b|\bTrace\b|\bRun\b|\bReach\b|ofPartial|ofMap",
 "exlaw": r"ExchangeLaw",
 "grammar": r"«",
}
rows=[]
for f in sorted(os.listdir(SRC)):
    if not f.endswith(".lean"): continue
    t=strip(open(os.path.join(SRC,f),encoding="utf-8").read())
    c={k:len(re.findall(p,t,flags=re.M)) for k,p in PAT.items()}
    nth=len(re.findall(r"^\s*(?:private |protected )?theorem\b",t,flags=re.M))
    rows.append((f[:-5],nth,c))
def kind(c):
    rec=c["record"]; law=c["detlaw"]+3*c["ownstep"]; pr=c["process"]; ex=c["exlaw"]; gr=c["grammar"]
    tags=[]
    if rec>=10: tags.append("record")
    if law>=5: tags.append("detlaw")
    if ex>=5: tags.append("exlaw")
    if pr>=10: tags.append("process")
    if gr>=30: tags.append("grammar")
    return "+".join(tags) if tags else "other"
from collections import Counter
cnt=Counter(); out=[]
for n,nth,c in rows:
    k=kind(c); cnt[k]+=1
    out.append(f"{n}\t{nth}\t{k}\t"+"\t".join(f"{a}={b}" for a,b in c.items()))
open("kinds.tsv","w").write("\n".join(out)+"\n")
for k,v in cnt.most_common(): print(v,k)
tot=Counter()
for n,nth,c in rows:
    for tag in kind(c).split("+"): tot[tag]+=1
print("by tag (modules may carry several):",dict(tot))
