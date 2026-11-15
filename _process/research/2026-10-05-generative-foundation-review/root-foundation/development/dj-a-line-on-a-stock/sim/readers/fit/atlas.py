import json, re, collections, os, subprocess
p = "/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json"
d = json.load(open(p))
print(type(d), (list(d.keys())[:10] if isinstance(d, dict) else len(d)))
items = d if isinstance(d, list) else d.get("entries") or d.get("dynamics") or list(d.values())
def walk(o, path=""):
    if isinstance(o, str):
        yield path, o
    elif isinstance(o, list):
        for i, x in enumerate(o): yield from walk(x, path + "[%d]" % i)
    elif isinstance(o, dict):
        for k, x in o.items(): yield from walk(x, path + "." + k)
names = collections.Counter()
for e in items:
    if not isinstance(e, dict): continue
    s = json.dumps(e, ensure_ascii=False)
    if "WayOfUnits" in s:
        ident = e.get("id") or e.get("key") or e.get("name")
        thms = sorted(set(re.findall(r"WayOfUnits\.[A-Za-z_.₁₂']+", s)))
        print("ENTRY", ident, "|", e.get("home") or e.get("module") or "", "|", e.get("title","")[:80] if isinstance(e.get("title"), str) else "")
        print("   keys:", list(e.keys())[:14])
        print("   ", thms)
        for t in thms: names[t] += 1
print(names.most_common())
