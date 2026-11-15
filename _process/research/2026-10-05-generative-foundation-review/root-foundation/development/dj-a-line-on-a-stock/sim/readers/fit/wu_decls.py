import re
p = "/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/WayOfUnits.lean"
src = open(p).read()
# strip the module docstring
body = src[src.index("namespace Becoming"):]
# split into declarations
pat = re.compile(r"^(theorem|def|abbrev|instance)\s+(\S+)", re.M)
ms = list(pat.finditer(body))
ns = []
out = []
unit_words = ["Nat × Nat", "need u", "taken", "after ", "Goes", "course ", "net giving", "Holds", "Regime ", "goes ", "left giving", "twoWay", "anyGoes", "way"]
for i, m in enumerate(ms):
    end = ms[i+1].start() if i+1 < len(ms) else len(body)
    chunk = body[m.start():end]
    stmt = chunk.split(":=")[0]
    # equation-compiler style: statement ends before first "\n  |"
    stmt = re.split(r"\n\s*\|", stmt)[0]
    hits = [w for w in unit_words if w in stmt]
    out.append((m.group(1), m.group(2), bool(hits), hits))
chg = [o for o in out if o[2]]
same = [o for o in out if not o[2]]
print("total decls", len(out), "| statement mentions units/way:", len(chg), "| does not:", len(same))
print("CHANGE:", ", ".join(o[1] for o in chg))
print("SAME:", ", ".join(o[1] for o in same))
