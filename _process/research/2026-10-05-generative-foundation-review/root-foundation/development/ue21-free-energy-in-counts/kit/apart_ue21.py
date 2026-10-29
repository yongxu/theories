#!/usr/bin/env python3
"""UE21: register the module's thirteen apart roots in THEOREM-CONNECTIVITY-APART.json, each with a category and a
reason, as THEOREM-CONNECTIVITY.py --check reported them at UE21's landing. Asserts each is absent before and writes
the register as it stands (entries appended, no other entry touched). Mirrors UE19's apart_ue19.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/apart_ue21.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
PATH = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
M = 'Becoming.FreeEnergyCounting'
P = f'{M}.'
COUNTS = ('a law of every natural count and weighting over any listing, an identity or inequality of counting with no '
          'world; the base supplies no reading of its vocabulary (UE21)')
MODEL = ('a law of every natural weighting of a generative model of listed hypotheses and records, an identity or '
         'inequality of counting with no world; the base supplies no reading of its vocabulary (UE21)')
WITNESS = 'a fact about one constructed model of two or three listed hypotheses with small natural weights (UE21)'
ROOTS = {
    P + 'bound_lt_of_not_proportional':
        ('general-structure', 'bound_lt_of_not_proportional: away from proportion the bound in counts is strict; '
                              + COUNTS),
    P + 'zero_weights_reach':
        ('general-structure', 'zero_weights_reach: every weight nothing puts every count belief at the bound; '
                              + COUNTS),
    P + 'no_counts_reach':
        ('general-structure', 'no_counts_reach: with every count nothing both sides of the bound are one; ' + COUNTS),
    P + 'bound_given_record':
        ('general-structure', 'bound_given_record: the bound in counts with the record\'s weight as the total; '
                              + MODEL),
    P + 'nothing_record_reach_all':
        ('general-structure', 'nothing_record_reach_all: where the record weighs nothing every count belief is at '
                              'the bound; ' + MODEL),
    P + 'given_record_eq_iff_share':
        ('general-structure', 'given_record_eq_iff_share: with the hypotheses listed once, the count beliefs at the '
                              'bound are those at the shares given the record; ' + MODEL),
    P + 'posterior_counts_reach':
        ('general-structure', 'posterior_counts_reach: the joint weights as counts reach the bound; ' + MODEL),
    P + 'Witness.strict_off_proportion':
        ('model-witness', 'Witness.strict_off_proportion: 1 < 2 for a belief all on one of two hypotheses; ' + WITNESS),
    P + 'Witness.scaled_reach':
        ('model-witness', 'Witness.scaled_reach: two counts on each of two hypotheses reach the bound; ' + WITNESS),
    P + 'Witness.off_support':
        ('model-witness', 'Witness.off_support: a belief on a hypothesis of weight nothing makes the left side '
                          'nothing; ' + WITNESS),
    P + 'Witness.total_two_unreached':
        ('model-witness', 'Witness.total_two_unreached: against weights one and two no belief of total two reaches '
                          'the bound; ' + WITNESS),
    P + 'Witness.nothing_record_reach':
        ('model-witness', 'Witness.nothing_record_reach: a record weighing nothing puts a belief at the bound; '
                          + WITNESS),
    P + 'Witness.duplicate_share':
        ('model-witness', 'Witness.duplicate_share: a hypothesis listed twice breaks the join to the share; '
                          + WITNESS),
}
d = json.loads(PATH.read_text(encoding='utf-8'))
for name, (category, reason) in ROOTS.items():
    assert name not in d['roots'], name
    assert category in d['categories'], category
    d['roots'][name] = {'module': M, 'category': category, 'reason': reason}
PATH.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('registered', len(ROOTS), 'apart roots of', M)
