#!/usr/bin/env python3
"""UE21 texts: 03's thesis; the home of the new record at 03 §6 after UE17's free energy and its reading (before
expected free energy and its terms), with a labelled reading; 03 §6's sentences that called the counting form absent
(the reading on conditioning) or pending (UE17's paragraph); 08 §8's bullet on free energy, and 08's receipt and counts
read from the receipt; the principle's page (In brief, the table row, §1, §5 and Standing); the study section; the UE
plan's owners and FEP-INTEGRATION's item 6; the record's and the module's regions. Every FreeEnergyCounting name the
texts cite is checked against the scratch build's axiom audit. Mirrors UE19's texts_ue19.py; every edit is asserted to
apply exactly once.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/texts_ue21.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
PAGE = ROOT / 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'free-energy-bound-in-counts'
KIT = f'../../../{RF}/development/ue21-free-energy-in-counts/NOTE.md'
AUDIT = HERE.parent / 'tree/.build/BecomingFreeEnergyCountingAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked FreeEnergyCounting name the text cites is a declaration of the module."""
    found = set(re.findall(r'`(FreeEnergyCounting\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C03 = CH / '03-KNOWING.md'
THESIS = "and minimizing variational free energy over the beliefs where it is finite reaches it; "
edit(C03, THESIS, THESIS + "in counts the bound and its equality hold with no axiom; ")
edit(C03, "Averages of logarithms, entropy and free energy among them, have no counting form here.",
     "Averages of logarithms, entropy and free energy among them, are not the logarithm of one reciprocal share; the "
     f"free-energy bound has a counting form, [below](#r-{RID}).")
edit(C03, "The law is in the periphery until a core form lands; no process that lowers free energy is stated",
     f"The law is in the periphery; its counting form, with its case of equality, is in the pure core "
     f"([below](#r-{RID})); no process that lowers free energy is stated")
BEFORE = '<a id="r-expected-free-energy-and-its-terms"></a>'
edit(C03, BEFORE, f"""<a id="r-{RID}"></a>
**Theorem** (any type; natural counts and weights, listed hypotheses, `0 ^ 0 = 1`). *The free-energy bound in counts.* For natural counts `n` over listed hypotheses, total `N`, and natural weights `a`, total `A`, `N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n` (`FreeEnergyCounting.bound`): for the belief whose shares are `n / N`, with `N` positive and on the support, the [free-energy bound](#r-free-energy-bounds-surprisal) exponentiated. It needs no support condition: a count on a hypothesis of weight nothing makes the left side nothing (`FreeEnergyCounting.Witness.off_support`), as the free energy is infinite there as usually defined, while the real form under `log 0 = 0` fails there, so off the support the two laws are not one. It is the arithmetic–geometric mean inequality in counts (`FreeEnergyCounting.mean_two`, `FreeEnergyCounting.two_parts`), proved from a Bernoulli-type inequality (`FreeEnergyCounting.bernoulli`), with equality exactly where the counts are proportional to the weights, `n h * A = a h * N` at every listed hypothesis, and strict elsewhere (`FreeEnergyCounting.bound_eq_iff`, `FreeEnergyCounting.bound_lt_of_not_proportional`); at one total it may be reached by no count belief (`FreeEnergyCounting.Witness.total_two_unreached`). Joined to [conditioning by restriction](#r-conditioning-by-restriction): in a generative model of the core, each joint weight a hypothesis's prior weight times the record's weight under it, the total is the record's weight (`FreeEnergyCounting.record_total`), the count beliefs at the bound are exactly those in proportion to the joint weights (`FreeEnergyCounting.given_record_eq_iff`), and, with the hypotheses listed once, exactly those whose every count over the total is the hypothesis's share given the record (`FreeEnergyCounting.given_record_eq_iff_share`); where the record weighs nothing, every count belief is at the bound (`FreeEnergyCounting.nothing_record_reach_all`). In counts the bound is Cauchy's arithmetic–geometric mean inequality (1821), equivalently Gibbs' inequality for rational shares; read with the weights as a model it says that the observed frequencies maximize the multinomial likelihood (the method of types). New is that the principle's central bound, with its equality, holds in the pure core ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. So, for a belief in counts with a positive total, on the support, where the record weighs something, with the hypotheses listed once, minimizing free energy is conditioning in the core itself: over count beliefs of every total the least free energy is the record's surprisal, reached exactly at the shares given the record, while at one fixed total it may not be reached ([study]({KIT})).

""" + BEFORE)

C08 = CH / '08-METHOD.md'
edit(C08, "For beliefs with natural counts the bound has a counting form, not yet stated.",
     "For beliefs with natural counts the bound has a counting form, Cauchy's arithmetic–geometric mean inequality in "
     f"counts (1821), a count being a repetition, stated in the pure core with its case of equality "
     f"([03 §6](03-KNOWING.md#r-{RID})).")

# 08: receipt and counts, every count read from the receipt
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

# the principle's page
LINK = f'[03 §6](chapters/03-KNOWING.md#r-{RID})'
edit(PAGE, "variational free energy bounds the record's surprisal with equality exactly at the posterior, so exact "
     "minimization over the beliefs where it is finite is that conditioning;",
     "variational free energy bounds the record's surprisal with equality exactly at the posterior, so exact "
     "minimization over the beliefs where it is finite is that conditioning, and for beliefs in counts the bound and "
     "its equality hold in the pure core;")
edit(PAGE, "| stated, periphery; its minimizer over the beliefs where it is finite is the core's conditioning |",
     f"| stated, periphery; its minimizer over the beliefs where it is finite is the core's conditioning; in counts, "
     f"with its equality, pure core ({LINK}) |")
edit(PAGE, "`FreeEnergy.surprisal_le_freeEnergy`, `FreeEnergy.minimizes_iff_givenShare`).",
     "`FreeEnergy.surprisal_le_freeEnergy`, `FreeEnergy.minimizes_iff_givenShare`). In counts it holds in the pure "
     "core: `N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n`, equal exactly where the counts are proportional to the weights, and "
     "in a core generative model, with the hypotheses listed once, exactly at the shares given the record (*any "
     f"type*; {LINK}; `FreeEnergyCounting.bound_eq_iff`, `FreeEnergyCounting.given_record_eq_iff_share`).")
edit(PAGE, "the free-energy bound's counting form for beliefs with natural counts, N^N·∏ a^n ≤ A^N·∏ n^n, checked on "
     "small cases and not proved; complexity", "complexity")
edit(PAGE, "What is new lies in the joins (the free-energy minimizer as the core's conditioning;",
     "What is new lies in the joins (the free-energy minimizer as the core's conditioning, and the bound with its "
     "equality in the pure core for beliefs in counts;")

# the study section
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.FreeEnergyCounting')
section = (HERE / 'study_ue21.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({mod['theorems']} theorems in {len(mod['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'COUNTS' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
plan = (UE / 'PLAN.md').read_text(encoding='utf-8')
owners = re.search(r'(UE16[^.]*?) and (UE20), and holds UE8\.', plan)
assert owners and 'UE21' not in owners.group(0), 'the owners line'
(UE / 'PLAN.md').write_text(plan.replace(owners.group(0), f'{owners.group(1)}, {owners.group(2)} and UE21, and holds UE8.'),
                            encoding='utf-8')
edit(UE / 'FEP-INTEGRATION.md', "6. **UE21. The bound in counting form, in the pure core** (claimed 30 October, after UE20).",
     f"6. **UE21. The bound in counting form, in the pure core** (landed as `Becoming.FreeEnergyCounting` with "
     f"[a record]({REC}{RID}.md) at 03 §6, study section {N}).")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.FreeEnergyCounting' not in reg['modules']
reg['records'][RID] = {'region': 'knowing', 'base': 'general',
                       'note': 'FreeEnergyCounting UE21: the free-energy bound in counts, N^N·∏ a^n ≤ A^N·∏ n^n, equal '
                               'exactly in proportion; in a generative model, hypotheses listed once, the count '
                               'beliefs at the bound are those at the shares given the record'}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.FreeEnergyCounting'] = {'region': 'knowing', 'base': 'general',
                                                 'note': 'UE21 the free-energy bound in counting form (03 §6)'}
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 thesis, §6 theorem, reading and two sentences; 08 bullet and counts:', counts[:90], '...; the page; '
      'study section', N, '; UE plan and FEP-INTEGRATION; regions')
