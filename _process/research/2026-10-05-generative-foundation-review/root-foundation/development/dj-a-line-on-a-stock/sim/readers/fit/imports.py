import re, sys, os
base = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
def imports(mod):
    p = os.path.join(base, mod.replace(".", "/") + ".lean")
    if not os.path.exists(p): return []
    out = []
    with open(p) as f:
        for line in f:
            m = re.match(r"import\s+(\S+)", line)
            if m: out.append(m.group(1))
            elif line.strip() and not line.startswith("import") and not line.startswith("--"):
                if out: break
    return out
def closure(mod):
    seen = set(); stack = [mod]
    while stack:
        m = stack.pop()
        for i in imports(m):
            if i not in seen:
                seen.add(i); stack.append(i)
    return seen
c = closure("Becoming.TurningInTime")
for name in ["SelectionTerm","Capture","Flow","LineageDrawdown","ReadingsSpread","RuleCapture","PoolFromCourse","RegimeMargin","GrammarLaws","Prelude","Selection","MutualDependence","LineageRegions","ReadingsPersist","Stock","DrawHistory","Optimum","Continuation","Exhaustion","JointDraw","CoupledDrawers","Runaway","Growth","Feeding"]:
    print(name, ("Becoming."+name) in c)
print(len(c))
