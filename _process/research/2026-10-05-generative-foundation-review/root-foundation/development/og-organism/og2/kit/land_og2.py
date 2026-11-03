"""OG2's landing texts that need the core run: the record (fill_record.py), 08's receipt sentence, the study's section,
WHAT-REMAINS' lines. Run from the landing worktree's root after the core run, before render.
Usage: land_og2.py RECEIPT_ID SECTION"""
import json, re, subprocess, sys
from pathlib import Path
rid, section = sys.argv[1], sys.argv[2]
kit = Path(__file__).resolve().parent
root = Path(__file__).resolve().parents[8]
lean = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/"
d = json.loads((root / lean / f"becoming-checks/{rid}/verification.json").read_text(encoding="utf-8"))
assert d["status"] == "passed", d["status"]
mods = {v["module"]: v for v in d["modules"]}
rr = mods["Becoming.RuleRebuilding"]
thms, decls = rr["theorems"], len(rr["declarations"])
assert not any(x.get("axioms") for x in rr["declarations"]), "an axiom in RuleRebuilding"
subprocess.run([sys.executable, "-B", str(kit / "fill_record.py"), rid, section, str(thms), str(decls)], check=True)
(kit.parent / "LANDED-COUNTS.txt").write_text(f"{decls} declarations ({thms} theorems)\n", encoding="utf-8")

lay = {}
for v in d["modules"]:
    lay.setdefault(v["layer"], []).append(v)
n = lambda k: len(lay.get(k, []))
ring = n("instance") + n("application")
core_thm = sum(v["theorems"] for v in lay["core"])
sentence = (f"At core receipt [`{rid}`](../../../{lean}becoming-checks/{rid}/verification.json) (Lean 4.29.1), "
            f"the closure held {len(d['modules'])} modules ({n('foundation')} foundation, {n('core')} core, {ring} in the "
            f"instance and application ring) and {sum(v['theorems'] for v in d['modules']):,} theorems; the {n('core')} core "
            f"modules held {core_thm:,} of them; {sum(len(v['declarations']) for v in d['modules']):,} declarations were "
            f"audited; {len(d['generated_axiom_dependencies'])} generated `injEq` lemmas depend on `propext`; "
            f"{len(d['superseded_modules'])} superseded modules were kept out of the run.")
p = root / "theories/becoming/chapters/08-METHOD.md"
t = p.read_text(encoding="utf-8")
pat = re.compile(r"At core receipt \[`\d{8}T\d{6}\.\d+Z`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held .*? superseded modules were kept out of the run\.")
assert len(pat.findall(t)) == 1, "08's receipt sentence not found once"
p.write_text(pat.sub(lambda _: sentence, t, count=1), encoding="utf-8")
print(sentence)

p = root / "_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
t = p.read_text(encoding="utf-8")
assert f"\n## {section}. " not in t, f"§{section} already taken"
body = (kit / "study.txt").read_text(encoding="utf-8").replace("## N. ", f"## {section}. ", 1).replace("RECEIPT", rid).replace("COUNTS", f"{decls} declarations ({thms} theorems)")
p.write_text(t.rstrip("\n") + "\n\n" + body, encoding="utf-8")

p = root / "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md"
t = p.read_text(encoding="utf-8")
for a, b in [("the test systems of plan §六, each with its model, the institution named on the one page as having none (9)",
              "the test systems of plan §六, each with its model (9)"),
             ("exactly where the rebuild draws on the level; the institution is next.",
              f"exactly where the rebuild draws on the level. OG2 landed (study §{section}): one kind of institution, a rule of entry rebuilt from the members it limits; other kinds and purposes stay open, and part 2 is the two families on the World's flows."),
             ("- models of an organism and an institution (plan §八 step 9), which is modelling work beyond the unification and is named as open on the one page;",
              "- further models of plan §八 step 9's test systems, which is modelling work beyond the unification;")]:
    assert t.count(a) == 1, a
    t = t.replace(a, b)
a = "(the board's way now, item 3)"
if a in t:
    t = t.replace(a, "(the board's way now, item 5)")
p.write_text(t, encoding="utf-8")
print("filled for", rid, "§" + section)
