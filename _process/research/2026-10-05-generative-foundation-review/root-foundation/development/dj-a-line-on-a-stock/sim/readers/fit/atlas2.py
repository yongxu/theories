import json, re
p = "/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json"
d = json.load(open(p))
for e in d:
    if e.get("id") == "turning-in-time":
        print("name:", e.get("name")); print("family:", e.get("family"))
        print("records:", e.get("records"))
        decl = e.get("declarations")
        print("n declarations:", len(decl) if hasattr(decl, "__len__") else decl)
        wu = [x for x in (decl if isinstance(decl, list) else []) if "WayOfUnits" in json.dumps(x, ensure_ascii=False)]
        print("WU declarations:", len(wu))
        for x in wu: print("  ", json.dumps(x, ensure_ascii=False)[:200])
        print("base:", json.dumps(e.get("base"), ensure_ascii=False)[:600])
        for k in ["hypotheses","forbids","exits","transitions","tests","open"]:
            v = e.get(k)
            s = json.dumps(v, ensure_ascii=False)
            print(k, "len", len(v) if hasattr(v, "__len__") else v, "| mentions WU:", s.count("WayOfUnits"))
        print("mechanism:", (e.get("mechanism") if isinstance(e.get("mechanism"), str) else json.dumps(e.get("mechanism"), ensure_ascii=False))[:1500])
pp = "/Users/ren/theories/theories/becoming/results/atlas/entries/premises.json"
d2 = json.load(open(pp))
n = 0
for e in (d2 if isinstance(d2, list) else d2.values()):
    s = json.dumps(e, ensure_ascii=False)
    if "WayOfUnits" in s:
        n += 1
        print("PREMISE", (e.get("id") if isinstance(e, dict) else ""), sorted(set(re.findall(r"WayOfUnits\.[A-Za-z_.₁₂']+", s)))[:12])
print("premise entries naming WU:", n)
