#!/usr/bin/env python3
"""UE15 texts: the home of the new record, reorderings-as-courses-of-growth, as a row of 01 §9.6's table after the
order of exchanges as the invariant, with a labelled reading after the section's reading; 01's open entry on presence
in time extended to it; the overview's open list; a bullet in 08 §8's known results beyond the table after UE14's, and
08's receipt and counts read from the receipt; the study section; the UE plan's item 6, its structural gap, its
failure list and its owners; the record's and the module's regions. Every ReorderingGrowth name the texts cite is
checked against the scratch build's axiom audit. Mirrors UE14's texts_ue14.py; every edit is asserted to apply
exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue15.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'reorderings-as-courses-of-growth'
RIDP = 'the-present-on-causal-set-growth'
RIDO = 'order-of-exchanges-is-the-invariant'
KIT = f'../../../{RF}/development/ue15-reorderings-as-growth/NOTE.md'
AUDIT = HERE.parent / 'tree/.build/BecomingReorderingGrowthAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked name of the module the text cites is a declaration of it."""
    found = set(re.findall(r'`(ReorderingGrowth\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# 01 §9.6: the row after the order of exchanges as the invariant, and a labelled reading after the section's reading
ROW_BEFORE = "| <a id=\"r-least-footprint-where-idleness-decided\"></a>"
edit(CH / '01-ROOT.md', "\n" + ROW_BEFORE, f"""
| <a id="r-{RID}"></a>[A world's reorderings as courses of growth](../results/records/{RID}.md) | With a given footprint containing the exchanges, the exchanges of a finite stretch from the first step form a causal set under the order of joined exchanges, and a renumbering of the stretch is the numbering of some reordering exactly where it numbers them by a course of causal-set growth from the empty set (`ReorderingGrowth.reordering_iff_course`), one course carrying several numberings where the order has automorphisms; so the laws of presence on that growth hold on the reorderings by instance, each with its decision ([§1](#r-{RIDP})). On the world as it is, an exchange is present when another is taken exactly where it precedes it and no exchange between is joined to it (`ReorderingGrowth.present_identity_iff`), and then it leaves every relatum it touched as it left it (`ReorderingGrowth.persists_of_present`); not conversely, through a dependence or by moving what it touched and moving it back (`ReorderingGrowth.ByDependence.persists_not_present`, `ReorderingGrowth.MovedBack.persists_not_present`). |
""" + ROW_BEFORE)
edit(CH / '01-ROOT.md', """The choice moves where on the index a standing falls, not which standings a relatum passes through or in what order.
""", f"""The choice moves where on the index a standing falls, not which standings a relatum passes through or in what order.

**Reading** [AI reading, D45]. Read as the present of causal-set growth is read ([§1](#r-{RIDP})), the present of a reordering is the exchanges taken by a step that none taken by then follows in the order of joined exchanges, and what every interleaving keeps of presence, or some interleaving has, is defined from that order: the one link and the link. An exchange present when another is taken has left everything it touched as it left it, and an exchange can leave all that unchanged without being present, where an exchange between is joined to it while what it touched persists: through a dependence, through a touch that does not move it, or through a move that a later exchange between undoes. So what presence adds to persistence is that nothing between is joined to the earlier exchange, and which presence holds between the two bounds is the choice of interleaving the step index makes ([study]({KIT})).
""")

# 01's open entry on presence in time, extended to the World
edit(CH / '01-ROOT.md',
     "a link on some course and the one link on every course. Open: presence on the theory's other models, first the "
     "order of exchanges the World's interleavings leave; continuous time; the present of a center; growths whose "
     "courses are weighted.",
     "a link on some course and the one link on every course. On the World, with a footprint containing the exchanges, "
     "the numberings a world's reorderings give a stretch are the orders of birth of the courses of growth of its order "
     "of exchanges, so the same bounds hold there by instance, and presence gives persistence of what an exchange "
     f"touched, not conversely ([§9.6](#r-{RID})). Open: "
     "presence on processes without a footprint; continuous time; the present of a center; growths whose courses are "
     "weighted.")

# the overview's open list
edit(ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md',
     "on causal-set growth presence is a choice of course between bounds defined from precedence "
     f"([01](chapters/01-ROOT.md#r-{RIDP})).",
     "on causal-set growth presence is a choice of course between bounds defined from precedence "
     f"([01](chapters/01-ROOT.md#r-{RIDP})), and so on a world's reorderings ([01](chapters/01-ROOT.md#r-{RID})).")

# 08 §8: known results beyond the table, after UE14's bullet
edit(CH / '08-METHOD.md', """for one reading of presence. Each law is near-definitional, a lemma, a witness or a calibration.

**Assessment**""", f"""for one reading of presence. Each law is near-definitional, a lemma, a witness or a calibration.
- A world's reorderings as courses of growth ([01 §9.6](01-ROOT.md#r-{RID})) composes two correspondences: the linear extensions of a trace's dependence order are its interleavings (Mazurkiewicz 1977; Diekert and Rozenberg 1995), here the World's own form of it, and the natural labellings of a causal set are its linear extensions, read as the paths of sequential growth (Rideout and Sorkin 2000; [01 §1](01-ROOT.md#r-{RIDP})); the prefixes of a trace correspond to the down-sets of its dependence order, the configurations of its event structure (Nielsen, Plotkin and Winskel 1981). That presence gives persistence of what an exchange touched is an elementary consequence of a footprint containing the exchanges. The composition follows at once from the two, and the review's light search found no paper connecting traces with causal-set growth. What is new is reading the World's interleavings as causal-set growth, so one law of presence across the two models, and what presence means on the World. Each law is near-definitional, a composition, a lemma or a witness.

**Assessment**""")

# 08: receipt and counts, every count read from the receipt (as texts_ue14.py)
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.ReorderingGrowth')
section = (HERE / 'study_ue15.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'PARAGRAPH' not in section, 'a placeholder left'
assert not re.search(r'RECHECK(?!-UE15)', section), 'the re-check placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan: item 6, the structural gap, the failure list and the owners brought to the landing
PLAN = ROOT / RF / 'development/ue-unified-explanation/PLAN.md'
REC = f'../../../../../../theories/becoming/results/records/{RID}.md'
edit(PLAN, "UE14 read the present on the same growth (§5).",
     "UE14 read the present on the same growth (§5), and UE15 carried it to the World's interleavings.")
edit(PLAN,
     "The present on the theory's other models, first the World's interleavings, and the present of a center remain.",
     "UE15 carries it to the World: with a footprint containing the exchanges, the numberings a world's reorderings "
     "give a stretch are exactly the orders of birth of the courses of growth of its order of exchanges, so the same "
     "bounds hold on the World by instance, and "
     f"presence at a step gives persistence of what an exchange touched, not conversely ([record]({REC})). The present "
     "on processes without a footprint, and that of a center, remain.")
edit(PLAN,
     "Self-changing conditions with no fixed scheme, and presence in time on models other than causal-set growth, are "
     "the known candidates.",
     "Self-changing conditions with no fixed scheme, and presence in time on processes without a footprint, are the "
     "known candidates.")
edit(PLAN, "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10, UE11, UE12, UE13 and UE14, and holds UE8.",
     "UE0, UE1, UE2, UE1b, UE4, UE5, UE7, UE9, UE10, UE11, UE12, UE13, UE14 and UE15, and holds UE8.")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.ReorderingGrowth' not in reg['modules']
reg['records'][RID] = {'region': 'root', 'base': 'old-base',
                       'note': 'ReorderingGrowth UE15: the exchanges of a stretch a causal set under the order of joined '
                               'exchanges; with the footprint containing the exchanges, the reorderings the courses of '
                               'causal-set growth, as numberings; the laws of presence on the reorderings by instance; '
                               'presence on the world as it is gives persistence of what an exchange touched, not '
                               'conversely; the vee as a world'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.ReorderingGrowth'] = {'region': 'root', 'base': 'old-base',
                                               'note': "UE15 a world's reorderings as courses of growth (01 §9.6)"}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01 §9.6 row and reading, open entry; overview; 08 bullet and counts:', counts[:90],
      '...; study section', N, '; UE plan; regions')
