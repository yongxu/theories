#!/usr/bin/env python3
"""UE16: register the module's twelve apart roots in THEOREM-CONNECTIVITY-APART.json, each with a category and a
reason, as THEOREM-CONNECTIVITY.py --check reported them at UE16's landing. Asserts each is absent before and writes
the register sorted as it stands (entries appended, no other entry touched).
usage (from the checkout root of the landing worktree): python3 -B <kit>/apart_ue16.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
PATH = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
M = 'Becoming.FreeEnergyGuarantees'
P = f'{M}.'
ROOTS = {
    P + 'IdenticalCells.TwoCells.minima':
        ('model-witness', 'IdenticalCells.TwoCells.minima: a fact about one constructed model, two cells whose ends have '
                          'free energy nothing, so no two-cell configuration is the unique minimum (UE16)'),
    P + 'IdenticalCells.TwoCells.other_minima':
        ('model-witness', 'IdenticalCells.TwoCells.other_minima: a fact about one constructed model, other '
                          'configurations of free energy nothing (UE16)'),
    P + 'IdenticalCells.alike_of_fixed':
        ('support', 'IdenticalCells.alike_of_fixed: a list lemma, a configuration fixed by exchanging two neighbouring '
                    'cells has them alike (UE16)'),
    P + 'IdenticalCells.fixed_of_alike':
        ('support', 'IdenticalCells.fixed_of_alike: a list lemma, two alike neighbouring cells leave the configuration '
                    'fixed by their exchange (UE16)'),
    P + 'IdenticalCells.apart_not_unique':
        ('general-structure', 'IdenticalCells.apart_not_unique: a law of every free energy on configurations symmetric in '
                              'the cells; it waits for a free energy read on the base (UE16)'),
    P + 'IdenticalCells.freeEnergy_symmetric':
        ('general-structure', 'IdenticalCells.freeEnergy_symmetric: a law of every free energy summed over cells at an '
                              'exchangeable field; it waits for a free energy read on the base (UE16)'),
    P + 'IdenticalCells.minimum_exchanged':
        ('general-structure', 'IdenticalCells.minimum_exchanged: a law of every free energy on configurations symmetric in '
                              'the cells; it waits for a free energy read on the base (UE16)'),
    P + 'IdenticalCells.unique_across_sizes_empty':
        ('general-structure', 'IdenticalCells.unique_across_sizes_empty: a law of every summed free energy on lists, '
                              'why minima are compared within one size; it waits for a free energy read on the base '
                              '(UE16)'),
    P + 'RiskAndNeeds.Chooser.chosen_mem':
        ('support', 'RiskAndNeeds.Chooser.chosen_mem: a one-line unpacking of the chooser\'s own definition (UE16)'),
    P + 'RiskAndNeeds.Chooser.chosen_minimizes':
        ('support', 'RiskAndNeeds.Chooser.chosen_minimizes: a one-line unpacking of the chooser\'s own definition, by '
                    'firstMin_le (UE16)'),
    P + 'RiskAndNeeds.Chooser.restraint_chosen':
        ('support', 'RiskAndNeeds.Chooser.restraint_chosen: a one-line unpacking of restraint\'s definition (UE16)'),
    P + 'SharedModels.OneGoal.regulator_choice':
        ('model-witness', 'SharedModels.OneGoal.regulator_choice: a fact about one constructed model, the regulator\'s '
                          'choices at four and at two (UE16)'),
}
d = json.loads(PATH.read_text(encoding='utf-8'))
for name, (category, reason) in ROOTS.items():
    assert name not in d['roots'], name
    assert category in d['categories'], category
    d['roots'][name] = {'module': M, 'category': category, 'reason': reason}
PATH.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('registered', len(ROOTS), 'apart roots of', M)
