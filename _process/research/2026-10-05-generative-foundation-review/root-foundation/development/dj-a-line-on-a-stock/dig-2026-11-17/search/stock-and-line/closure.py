import re, os, sys
root = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
def imports(mod):
    p = os.path.join(root, mod.replace(".", "/") + ".lean")
    if not os.path.exists(p):
        return []
    out = []
    with open(p) as f:
        for line in f:
            m = re.match(r"import\s+(\S+)", line)
            if m:
                out.append(m.group(1))
            elif line.strip() and not line.startswith("import") and not line.startswith("--"):
                if line.startswith("/-") or line.startswith("namespace") or line.startswith("open"):
                    break
    return out
def closure(mod):
    seen = set(); stack = [mod]
    while stack:
        m = stack.pop()
        if m in seen: continue
        seen.add(m)
        stack.extend(imports(m))
    return seen
for m in ["Becoming.LineOnAStock", "Becoming.TurningInTime", "Becoming.WayOfUnits", "Becoming.RegimeMargin", "Becoming.ReadOffInTime"]:
    c = closure(m)
    print(m, len(c), "Stock in closure:", "Becoming.Stock" in c, "| Flow:", "Becoming.Flow" in c, "| Optimum:", "Becoming.Optimum" in c)
c = closure("Becoming.Stock")
print("Stock closure:", len(c), sorted(c))
for m in ["Becoming.LineOnAStock","Becoming.TurningInTime","Becoming.RegimeMargin"]:
    print("Stock imports", m, ":", m in c)
