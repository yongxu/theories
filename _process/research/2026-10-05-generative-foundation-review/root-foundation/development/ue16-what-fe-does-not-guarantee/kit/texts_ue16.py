#!/usr/bin/env python3
"""UE16 texts: the homes of the two new records, identical-cells-under-a-descent-treating-them-alike at 05 §9 after the
swap-symmetric assignment (the same obstruction, of cells) and risk-minimization-on-a-shared-renewal at 05 §1 after
the rest outrunning the renewal, with a labelled reading; 05's thesis; 08 §8's bullet on the count of choices (the
containment's third parts), a bullet in its known results beyond the table after UE15's, a sentence in its third
parts, and 08's receipt and counts read from the receipt; the study section; the UE plan and the plan for the
principle (FEP-INTEGRATION); the records' and the module's regions. Every FreeEnergyGuarantees name the texts cite is
checked against the scratch build's axiom audit. Mirrors UE15's texts_ue15.py; every edit is asserted to apply exactly
once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue16.py RECEIPT N"""
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
RIDA = 'identical-cells-under-a-descent-treating-them-alike'
RIDB = 'risk-minimization-on-a-shared-renewal'
KIT = f'../../../{RF}/development/ue16-what-fe-does-not-guarantee/NOTE.md'
AUDIT = HERE.parent / 'tree/.build/BecomingFreeEnergyGuaranteesAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked name of the module the text cites is a declaration of it."""
    found = set(re.findall(r'`(FreeEnergyGuarantees\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C05 = CH / '05-COLLECTIVES.md'
# 05's thesis: the symmetry clause reaches the cells
edit(C05, "from a symmetric start only a broken symmetry brings agreement on a code.",
     "from a symmetric start only a broken symmetry brings agreement on a code, or parts identical cells under a "
     "descent that treats them alike.")

# 05 §1: risk minimization on a shared renewal, after the rest outrunning the renewal, with a labelled reading
B_BEFORE = '<a id="r-draws-on-a-shared-stock"></a>'
edit(C05, B_BEFORE, f"""<a id="r-{RIDB}"></a>
**Theorem** (World: balance, activity needing support, only active giving; local: the gate, the rest listed without repetition, a member outside it; the witnesses those of joint excess and of set points held). Read in the free-energy principle's terms, an agent with a generative model predicting the level after a step from what it reads and what it takes, choosing the first amount of least risk, the predicted distance from its preferred level (`FreeEnergyGuarantees.RiskAndNeeds.Chooser.chosen`), minimizes risk in counting form (a correspondence, not a Lean law: for a point prediction ô, active inference's risk KL[δ_ô ‖ P] is −ln P(ô), which orders as the distance does under a preference falling alike on both sides of its mode). Holders of one such model, each taking, at the two steps they take part, its choice of least risk at its own store, a condition of the web, at no risk, each store at its set point at every step and so each goal met, each within what a step gives the pool, together end the pool's renewal, neither coupling into the pool (`FreeEnergyGuarantees.SharedModels.held_not_one`, by [the set point's held pair](#r-what-a-set-point-optimum-does-beyond)). Alike preferences, each over one's own, are not one goal; a goal over the shared level is no guarantee either: two regulators each counting only its own take continue, three end at the first step (`FreeEnergyGuarantees.SharedModels.OneGoal.continues`, `FreeEnergyGuarantees.SharedModels.OneGoal.three_end`). And where the rest outruns a gated renewal, a member outside it has its need end whatever its model, reading and preference (`FreeEnergyGuarantees.RiskAndNeeds.need_ends`, by [the outrun law](#r-the-rest-outruns-the-renewal); at need three, `FreeEnergyGuarantees.RiskAndNeeds.Outrun.ends_either_way`), and where it expects at no risk a level at least its need, the level reached is below it from the rest's end on (`FreeEnergyGuarantees.RiskAndNeeds.expectation_not_course`). So the claim that one generative model with one set of preferences makes each agent's goal the group's (Friston, Ramstead and others 2024; Da Costa and others 2025) fails for preferences over one's own store, and the wording that risk minimization ensures needs are met (Albarracin and others 2024) fails where others outrun the renewal; the second applies landed laws with a chooser they do not read and forbids only the wording, not the authors' gloss. These are the commons (Lloyd 1833; Hardin 1968) and pivotality (Palfrey and Rosenthal 1984) in the principle's terms; the papers' simulations, with no shared draw, are not refuted ([record](../results/records/{RIDB}.md)).

**Reading** [AI reading, D45]. The free-energy principle explains a system's persistence by its gathering evidence for its own model. These laws, with [the cells of §9](#r-{RIDA}), show in its own terms where that explanation stops: minimizing free energy cannot break a symmetry its law keeps, cannot read a drain it does not couple to, and cannot turn alike preferences for one's own into a preference over the joint outcome, while a preference over the joint outcome, each counting only its own take, guarantees nothing either. The theory states each by a law the principle lacks, of symmetry, of what passes between a thing and its world, and of renewal; these are the principle's third parts ([study]({KIT})).

""" + B_BEFORE)

# 05 §9: identical cells under a symmetric descent, after the swap-symmetric assignment
A_BEFORE = '<a id="r-synonyms-and-coined-forms"></a>'
edit(C05, A_BEFORE, f"""<a id="r-{RIDA}"></a>
**Theorem** (any type of cell states and fields; configurations as lists, exchanges of neighbouring cells). The same obstruction holds of cells minimizing free energy. Under a descent moving every cell by one rule, from its own state and a field read from the configuration, never from a cell's number, two cells alike at the start are alike at every step, and all cells alike stay all alike (`FreeEnergyGuarantees.IdenticalCells.two_alike_stay_alike`, `FreeEnergyGuarantees.IdenticalCells.all_alike_stay_alike`). Where no exchange of cells changes the field, the descent commutes with exchanging two neighbouring cells (`FreeEnergyGuarantees.IdenticalCells.descent_commutes`), so, by the [commuting law](01-ROOT.md#r-what-a-commuting-law-keeps-apart), the run from the exchanged start is the exchanged run (`FreeEnergyGuarantees.IdenticalCells.exchanged_run`); and among configurations of one number of cells the minima of a free energy symmetric in the cells, as one summed from each cell's own at the field it senses is, come in exchanged pairs, and a unique minimum has its cells alike (`FreeEnergyGuarantees.IdenticalCells.minimum_exchanged`, `FreeEnergyGuarantees.IdenticalCells.unique_minimum_alike`). In a witness two cells at `[1, 1]` rest where they started, and from any two alike cells the free energy stays above the least, while a start differing by one unit parts them to either end, and no two-cell configuration is the unique minimum (`FreeEnergyGuarantees.IdenticalCells.TwoCells.alike_rests`, `FreeEnergyGuarantees.IdenticalCells.TwoCells.alike_never_least`, `FreeEnergyGuarantees.IdenticalCells.TwoCells.parts`, `FreeEnergyGuarantees.IdenticalCells.TwoCells.minima`). So the claim that identical cells minimizing free energy are guaranteed unique places (Friston, Levin, Sengupta and Pezzulo 2015) fails for a deterministic descent that reads no cell's number: what parts them is a start that differs, a rule reading a cell's number, or noise, as the paper's small random initial expectations did. It is Curie's principle (1894) in the principle's terms, its uniqueness clause the [symmetric choice that singles out none](03-KNOWING.md#r-selection-through-a-model-of-the-options) (Angluin 1980); the paper's simulations are not refuted ([record](../results/records/{RIDA}.md)).

""" + A_BEFORE)

C08 = CH / '08-METHOD.md'
# 08 §8: the count of choices' containment, its third parts now stated
edit(C08, "What the law adds is exactness for a simplified model and its edges, so as a containment of the free-energy "
          "principle it is a restatement with its third part open.",
     "What the law adds is exactness for a simplified model and its edges, so as a containment of the free-energy "
     f"principle it is a restatement; the containment's third parts are [05 §9's](05-COLLECTIVES.md#r-{RIDA}) and "
     f"[05 §1's](05-COLLECTIVES.md#r-{RIDB}).")

# 08 §8: known results beyond the table, after UE15's bullet
ASSESS = "\n\n**Assessment** (the market model of [05](05-COLLECTIVES.md), read against conventional control)."
edit(C08, ASSESS, f"""
- Identical cells under a descent that treats them alike ([05 §9](05-COLLECTIVES.md#r-{RIDA})) and risk minimization on a shared renewal ([05 §1](05-COLLECTIVES.md#r-{RIDB})) bring known results into the free-energy principle's terms: Curie's principle (1894), Turing's remark that morphogenesis from a symmetric state needs disturbances (1952) and symmetric choice in anonymous networks (Angluin 1980), and the commons (Lloyd 1833; Hardin 1968) with pivotality (Palfrey and Rosenthal 1984). Each law applies a landed law (the commuting law, the outrun law, the held pair of a set point) to an explicit model in the principle's terms, or is a witness; that alike cells stay alike needs only a descent reading no cell's number. They forbid three statements of the principle's literature read as guarantees, the second only in its wording, not the papers' simulations, which break the symmetry by random starts and have no shared draw. Each law is near-definitional, an application or a witness.""" + ASSESS)

# 08 §8's third parts: the free-energy principle's containment has three
edit(C08, "Each joins a framework that lacks conservation, renewal over time or a threshold to a premise or law of the "
          "theory, and forbids what the conjunction forbids. ",
     "Each joins a framework that lacks conservation, renewal over time or a threshold to a premise or law of the "
     "theory, and forbids what the conjunction forbids. The free-energy principle's containment "
     "([02 §9](02-MAP.md#r-capture-by-counted-choices)) has three, joining claims of its literature, read as guarantees, "
     "to a descent reading no cell's number, the held pair of a set point and the outrun law: identical cells under a "
     f"descent that treats them alike stay alike ([05 §9](05-COLLECTIVES.md#r-{RIDA})), and neither alike preferences for "
     "one's own nor risk "
     f"minimization keeps a renewal the joint draw outruns ([05 §1](05-COLLECTIVES.md#r-{RIDB})); each is known (Curie "
     "1894; the commons). ")

# 08: receipt and counts, every count read from the receipt (as texts_ue15.py)
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
s = C08.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
C08.write_text(s, encoding='utf-8')

# the study section
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.FreeEnergyGuarantees')
section = (HERE / 'study_ue16.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'PARAGRAPH' not in section, 'a placeholder left'
assert not re.search(r'RECHECK(?!-UE16)', section), 'the re-check placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle, brought to the landing
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md',
     "Each is a known result, and each forbids a verbal generalization, not a paper's simulation "
     "([corrections](../ue1-fep-bridge/NOTE-CORRECTIONS.md) §3).",
     "Each is a known result, and each forbids a verbal generalization, not a paper's simulation "
     "([corrections](../ue1-fep-bridge/NOTE-CORRECTIONS.md) §3). UE16 (29 October) states three of them as theorems "
     "on models in the principle's terms, so the containment has third parts: identical cells under a descent that "
     f"treats them alike stay alike ([record]({REC}{RIDA}.md)), and neither alike preferences for one's own nor risk "
     f"minimization keeps a renewal the joint draw outruns ([record]({REC}{RIDB}.md)).")
edit(UE / 'PLAN.md',
     "(landed 25 October; a restatement, its third part open; on 29 October its integration into the whole theory was "
     "planned as UE16 to UE20,",
     "(landed 25 October; a restatement, its third parts landed with UE16 on 29 October, when its integration into the "
     "whole theory was planned as UE16 to UE20,")
edit(UE / 'PLAN.md', "UE11, UE12, UE13, UE14 and UE15, and holds UE8.",
     "UE11, UE12, UE13, UE14, UE15 and UE16, and holds UE8.")
edit(UE / 'FEP-INTEGRATION.md', "A restatement: its third part is open.",
     "Its own laws restate; the containment's third parts are UE16's (below).")
edit(UE / 'FEP-INTEGRATION.md',
     "1. **UE16. What free-energy minimization does not guarantee** (the third parts; pure core).",
     "1. **UE16. What free-energy minimization does not guarantee** (the third parts; pure core; landed 29 October as "
     f"`Becoming.FreeEnergyGuarantees` with two records, [identical cells]({REC}{RIDA}.md) at 05 §9 and "
     f"[risk minimization]({REC}{RIDB}.md) at 05 §1, study section {N}).")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RIDA not in reg['records'] and RIDB not in reg['records']
assert 'Becoming.FreeEnergyGuarantees' not in reg['modules']
reg['records'][RIDA] = {'region': 'collective', 'base': 'general',
                        'note': 'FreeEnergyGuarantees UE16: under a descent reading no cell\'s number alike cells stay '
                                'alike; with an exchangeable field, minima within one size come in exchanged pairs; '
                                'against guaranteed differentiation (Friston and others 2015)'}
reg['records'][RIDB] = {'region': 'collective', 'base': 'old-base',
                        'note': 'FreeEnergyGuarantees UE16: a risk-minimizing chooser, its need ending where the rest '
                                'outruns a gated renewal, unread after; alike preferences for own stores are not one '
                                'goal (joint excess); against risk minimization ensuring needs and shared preferences '
                                'making a group goal'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.FreeEnergyGuarantees'] = {'region': 'collective', 'base': 'old-base',
                                                   'note': 'UE16 what free-energy minimization does not guarantee '
                                                           '(05 §1, §9)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 05 thesis, §1 theorem and reading, §9 theorem; 08 bullets, third parts and counts:', counts[:90],
      '...; study section', N, '; UE plan and FEP-INTEGRATION; regions')
