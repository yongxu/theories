import os,re
SRC = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming"
READ = """World Flow Dissipation Stock Interdependence MutualDependence Feeding Feedback Clearing Continuation Renewal RenewalFlow RenewalBound Restoration Reserve Arising Dependence LineageRegimes LineageDrawdown LineageRegions ReadingsSpread ReadingsPersist PairSelection PairFlow SelectionLevels Founding CoupledDrawers RuleShaping LineOnAStock WayOfUnits TurningInTime RegimeMargin SelectionPace Evolution GroupEnding Exclusion DrawnBeyond Roles Succession Novelty Openness Growth KeepingWidening EventualWidening OwnWidening Wholes OverExchange PersistingChoices Descent ReadOffInTime Reproduction""".split()
names = sorted(f[:-5] for f in os.listdir(SRC) if f.endswith(".lean"))
missing=[r for r in READ if r not in names]
print("read-list names not found as modules:", missing)
tot=0; rows=[]
for n in names:
    txt=open(os.path.join(SRC,n+".lean"),encoding="utf-8").read()
    i=txt.find("/-!"); j=txt.find("-/",i)
    b=txt[i:j+2] if i>=0 else ""
    rows.append((n,len(b),b.count("\n")+1,txt.count("\n")+1, n in READ))
un=[r for r in rows if not r[4]]
print("unread modules",len(un),"chars",sum(r[1] for r in un),"lines",sum(r[2] for r in un))
print("read modules",len(rows)-len(un),"chars",sum(r[1] for r in rows if r[4]))
import statistics
print("median acct chars unread",statistics.median(r[1] for r in un))
for r in sorted(un,key=lambda r:-r[1])[:25]: print(r)
print("no block:",[r[0] for r in rows if r[1]==0])
