#!/usr/bin/env python3
"""UE19: register the core module's six apart roots in THEOREM-CONNECTIVITY-APART.json, each with a category and a
reason, as THEOREM-CONNECTIVITY.py --check reported them at UE19's landing (with UE18), and drop the entry of
ConditionalWeights.posterior_single, no longer an apart root since posterior_ratio_kept uses it. Asserts each new root
is absent before and the dropped entry present, and writes the register as it stands (no other entry touched).
Mirrors UE18's apart_ue18.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/apart_ue19.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
PATH = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
M = 'Becoming.LumpedSeeking'
P = f'{M}.'
WITNESS = ('a fact about one constructed model, three coins under a model reading only whether two tosses agree and '
           'one reading both tosses (UE19)')
ROOTS = {
    P + 'posterior_ratio_kept':
        ('general-structure', 'posterior_ratio_kept: the shares of a tied pair given any record stand as the prior '
                              'weights do; a law of every natural weighting of listed hypotheses and records, an '
                              'identity of counting with no world; the base supplies no reading of its vocabulary '
                              '(UE19)'),
    P + 'Agree.totals':
        ('model-witness', 'Agree.totals: every bias\'s weights total sixteen; ' + WITNESS),
    P + 'Agree.turns_fair':
        ('model-witness', 'Agree.turns_fair: given two heads the true coin comes above the fair one; ' + WITNESS),
    P + 'Agree.keeps_tails':
        ('model-witness', 'Agree.keeps_tails: given two heads the tails-biased coin stays above the true one; '
                          + WITNESS),
    P + 'Agree.seeking_keeps_tails':
        ('model-witness', 'Agree.seeking_keeps_tails: with only the experiment reading agreement, seeking keeps the '
                          'tails-biased coin above the true one; ' + WITNESS),
    P + 'Agree.seeking_turns_tails':
        ('model-witness', 'Agree.seeking_turns_tails: with the experiment reading both tosses chosen, seeking turns '
                          'that order; ' + WITNESS),
}
DROPPED = 'Becoming.ConditionalWeights.posterior_single'
d = json.loads(PATH.read_text(encoding='utf-8'))
assert DROPPED in d['roots'], DROPPED
del d['roots'][DROPPED]
for name, (category, reason) in ROOTS.items():
    assert name not in d['roots'], name
    assert category in d['categories'], category
    d['roots'][name] = {'module': M, 'category': category, 'reason': reason}
PATH.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('registered', len(ROOTS), 'apart roots of', M, '; dropped', DROPPED, '(no longer an apart root)')
