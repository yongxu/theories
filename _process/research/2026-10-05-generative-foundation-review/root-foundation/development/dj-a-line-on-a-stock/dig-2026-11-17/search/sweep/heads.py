import os,re
SRC = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
READ = """World Flow Dissipation Stock Interdependence MutualDependence Feeding Feedback Clearing Continuation Renewal RenewalFlow RenewalBound Restoration Reserve Arising Dependence LineageRegimes LineageDrawdown LineageRegions ReadingsSpread ReadingsPersist PairSelection PairFlow SelectionLevels Founding CoupledDrawers RuleShaping LineOnAStock WayOfUnits TurningInTime RegimeMargin SelectionPace Evolution GroupEnding Exclusion DrawnBeyond Roles Succession Novelty Openness Growth KeepingWidening EventualWidening OwnWidening Wholes OverExchange PersistingChoices Descent ReadOffInTime Reproduction""".split()
KW = {
 "renew":r"renew|replenish|regenerat|restor|remak|made again",
 "within":r"within what|no more than|sustainab|carrying|overshoot|overdraw|overdraft",
 "drain":r"drain|deplet|exhaust|run[s]? down|running down|used up|use[s]? up|draws? down|drawdown|give[s]? out",
 "give":r"\bgiv(e|es|ing|er|ers)\b|gift|donor|contribut|provision|public good|altru|cooperat|defect|free.rid|commons",
 "cost":r"\bcost|costly|at a price|forgo|sacrific",
 "mult":r"multipl|offspring|reproduc|descend|lineage|birth|progeny|replicat|copies|children|parent",
 "select":r"select|fitness|favou?r",
 "receiver":r"receiv|recipient|comes back|come back|returns? to|kin|assort|reciproc",
 "noreturn":r"no return|irrevers|too late|cannot be turned|can no longer|lock.?in|locked|past the point|hysteres|tipping|commit",
 "arise":r"niche|facilitat|arises?|arising|scaffold|rests? on|condition of|conditions? others|construct",
 "step":r"\bstep\b|iterate|orbit|recursion|next state|trajectory",
}
names = sorted(f[:-5] for f in os.listdir(SRC) if f.endswith(".lean"))
out=open("heads.txt","w"); sc=open("scores.tsv","w")
sc.write("module\tfilelines\tacctlines\t"+"\t".join(KW)+"\n")
for n in names:
    if n in READ: continue
    txt=open(os.path.join(SRC,n+".lean"),encoding="utf-8").read()
    i=txt.find("/-!"); j=txt.find("-/",i)
    b=txt[i:j+2]
    lines=b.split("\n")
    counts={k:len(re.findall(p,b,flags=re.I)) for k,p in KW.items()}
    sc.write(f"{n}\t{txt.count(chr(10))+1}\t{len(lines)}\t"+"\t".join(str(counts[k]) for k in KW)+"\n")
    head="\n".join(lines[:13])
    if len(head)>1150: head=head[:1150]+" …"
    hits=" ".join(f"{k}{v}" for k,v in counts.items() if v)
    out.write(f"### {n} [{txt.count(chr(10))+1}L file, {len(lines)}L acct] kw: {hits}\n{head}\n\n")
out.close(); sc.close()
print(os.path.getsize("heads.txt"))
