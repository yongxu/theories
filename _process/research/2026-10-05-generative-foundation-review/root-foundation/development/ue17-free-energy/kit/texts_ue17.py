#!/usr/bin/env python3
"""UE17 texts: the home of the new record, free-energy-bounds-surprisal, in 03 §6 after conditioning by restriction and
its reading (a new anchor, so conditioning's own text is unchanged), with a labelled reading; 03's thesis; a bullet in
08 §8's known results after conditioning's; the study section; the UE plan's item 1 and owners, and the plan for the
principle (FEP-INTEGRATION); the record's region. Every FreeEnergy name the texts cite is checked against the
periphery receipt's declarations. Mirrors UE16's texts_ue16.py; every edit is asserted to apply exactly once. No core
receipt: the module is in the periphery, so 08's core counts do not move.
usage (from the checkout root of the landing worktree, after the periphery checker): python3 -B <kit>/texts_ue17.py
       RECEIPT N   (RECEIPT the periphery checker's run id)"""
import datetime
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
FE = 'experiments/integrated-correction/general-framework/generative-basis/lean/free-energy'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID = 'free-energy-bounds-surprisal'
KIT = f'../../../{RF}/development/ue17-free-energy/NOTE.md'
R = json.loads((ROOT / FE / 'free-energy-reals-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed' and R['bridge_module'] == 'FreeEnergyReals'
MOD = next(m for m in R['modules'] if m['module'] == 'FreeEnergyReals')
NAMES = {d['name'] for d in MOD['declarations']}


def cited(text):
    """Every backticked FreeEnergy name the text cites is a declaration of the module."""
    found = set(re.findall(r'`(FreeEnergy\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if 'Becoming.' + n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C03 = CH / '03-KNOWING.md'
# 03's thesis
edit(C03, "理 is a lumping that models structure and change at once;",
     "conditioning is restriction, and minimizing variational free energy over the beliefs where it is finite "
     "reaches it; 理 is a lumping that models structure and change at once;")

# 03 §6: the new anchor after conditioning's reading, before the split that makes sense
BEFORE = '<a id="r-the-split-that-makes-sense"></a>'
edit(C03, BEFORE, f"""<a id="r-{RID}"></a>
**Theorem** (periphery: [`FreeEnergyReals`](../../../{FE}/FreeEnergyReals.lean) on Mathlib's reals, Lean's three standard axioms reported, the core's `ConditionalWeights` read unchanged; a finite set of causes; Mathlib's conventions at zero). *Variational free energy bounds surprisal.* For a belief `q` with total one and a joint weighting `p` of causes and a record, `q` zero wherever `p` is, the free energy, the average under `q` of the logarithm of `q` less that of `p`, is at least the record's surprisal, the negative logarithm of `p`'s total (`FreeEnergy.surprisal_le_freeEnergy`, Gibbs' inequality); it equals the surprisal exactly at the posterior (`FreeEnergy.freeEnergy_eq_surprisal_iff`), which alone has the least free energy among such beliefs, those where it is finite as usually defined (`FreeEnergy.minimizes_iff_posterior`; off that support the bound fails under Mathlib's `log 0 = 0`, `FreeEnergy.Witness.bound_fails_off_support`). It is the energy less the entropy, the divergence from the posterior plus the surprisal, and, where `p` is a prior times a likelihood, the divergence from the prior less the expected log-likelihood (`FreeEnergy.freeEnergy_eq_energy_sub_entropy`, `FreeEnergy.freeEnergy_eq_divergence_add_surprisal`, `FreeEnergy.freeEnergy_eq_complexity_sub_accuracy`). Joined to [conditioning by restriction](#r-conditioning-by-restriction): in a generative model of the core, the joint weights read as shares sum to the record's share and their posterior is the core's share given the record (`FreeEnergy.givenShare_eq_posterior`), so minimizing free energy over beliefs with no weight where a hypothesis's prior weight times the record's weight under it is zero, which exist only where the record weighs something (`FreeEnergy.record_pos_of_belief`), gives exactly that share, at free energy the record's surprisal (`FreeEnergy.freeEnergy_givenShare`, `FreeEnergy.minimizes_iff_givenShare`). Gibbs' inequality and its equality case are classical (Gibbs 1902; Kullback and Leibler 1951); the bound is the evidence bound of variational Bayes (Hinton and van Camp 1993; Neal and Hinton 1998) and the free-energy principle's quantity (Friston 2005, 2010); the decompositions and the join are near-definitional, and new is the join: the core states the posterior by counting, and the periphery characterizes it as the one minimizer of free energy. The law is in the periphery until a core form lands; no process that lowers free energy is stated ([record](../results/records/{RID}.md)).

**Reading** [AI reading, D45]. The free-energy principle reads perception as the minimization of variational free energy over beliefs, and the bound's equality says that the minimizer, among the beliefs where the free energy is finite, is the posterior, which in the theory is conditioning by restriction. So perception in the principle's sense, read exactly, adds no law to the theory's conditioning; it gives conditioning a variational form, whose use is approximation: a belief confined to a family reaches only the least free energy within it, and the divergence term measures how far it stops from the posterior. What the principle adds beyond Bayes is reading a system's dynamics as descent on this quantity, which the law does not state ([study]({KIT})).

""" + BEFORE)

C08 = CH / '08-METHOD.md'
# 08 §8: known results beyond the table, after conditioning's bullet
OLD08 = ("and a prior weight is the prior share only where the likelihood totals agree.\n")
edit(C08, OLD08, OLD08 + f"- Variational free energy bounds surprisal ([03 §6](03-KNOWING.md#r-{RID})) restates Gibbs' inequality "
     "and the evidence bound of variational Bayes (Gibbs 1902; Kullback and Leibler 1951; Hinton and van Camp 1993; Neal "
     "and Hinton 1998), the free-energy principle's quantity (Friston 2005, 2010), in the periphery over the reals. What "
     "is new is the join: the core states the posterior by counting, and the periphery characterizes it as the one "
     "minimizer of free energy over the beliefs where it is finite. Gibbs' inequality is classical; the decompositions "
     "and the join are near-definitional. For beliefs with natural counts the bound has a counting form, not yet "
     "stated.\n")

# the study section
section = (HERE / 'study_ue17.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({MOD['theorems']} theorems in {len(MOD['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and 'PARAGRAPH' not in section, 'a placeholder left'
assert not re.search(r'RECHECK(?!-UE17)', section), 'the re-check placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle, brought to the landing
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = f'../../../../../../theories/becoming/results/records/{RID}.md'
plan = (UE / 'PLAN.md').read_text(encoding='utf-8')
owners = re.search(r'UE11, UE12, UE13, UE14, UE15(?: and UE16|, UE16)?(?: and UE17)?, and holds UE8\.', plan)
assert owners and 'UE17' not in owners.group(0), 'the owners line'
new_owners = owners.group(0).replace(' and UE16, and', ', UE16 and UE17, and') if 'UE16' in owners.group(0) \
    else owners.group(0).replace(' and UE15, and', ', UE15 and UE17, and')
assert new_owners != owners.group(0)
(UE / 'PLAN.md').write_text(plan.replace(owners.group(0), new_owners), encoding='utf-8')
TODAY = datetime.date.today()
edit(UE / 'FEP-INTEGRATION.md',
     "2. **UE17. Variational free energy and its bound** (periphery, on Mathlib's reals, joined to the core).",
     "2. **UE17. Variational free energy and its bound** (periphery, on Mathlib's reals, joined to the core; landed "
     f"{TODAY.day} {TODAY:%B} as `FreeEnergyReals` with its checker and [a record]({REC}) at 03 §6, study section {N}).")
edit(UE / 'FEP-INTEGRATION.md',
     "The variational bound was drafted for the periphery (`ConditionalWeightsReals.lean`, compiled against the pinned "
     "Mathlib) with no checker and no record.",
     "The variational bound was drafted for the periphery (`ConditionalWeightsReals.lean`, compiled against the pinned "
     f"Mathlib) with no checker and no record; UE17 states it in the periphery with its checker and [record]({REC}).")
edit(UE / 'FEP-INTEGRATION.md', "- **Not stated anywhere in Lean:** free energy, expected free energy,",
     f"- **Not stated anywhere in Lean:** free energy (until UE17, [record]({REC})), expected free energy,")

# regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
reg['records'][RID] = {'region': 'knowing', 'base': 'periphery',
                       'note': 'FreeEnergyReals UE17: variational free energy over the reals, its bound by surprisal '
                               'with equality exactly at the posterior, the decompositions, and the minimizer the '
                               "core's share given the record (periphery)"}
reg['records'] = dict(sorted(reg['records'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 thesis, §6 theorem and reading; 08 bullet; study section', N, '; UE plan and FEP-INTEGRATION; regions')
