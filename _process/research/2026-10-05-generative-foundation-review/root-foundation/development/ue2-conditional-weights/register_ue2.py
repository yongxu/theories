#!/usr/bin/env python3
"""UE2: register the apart roots of Becoming.ConditionalWeights (and of the changed Becoming.Typicality, should any appear)
that connectivity lists without a reason, each with a category and a reason; textual edits, the rest of the file byte for
byte. Adapted from UE1's register_ue1.py.
usage (from the checkout root, after connectivity): python3 -B <kit>/register_ue2.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
CW = 'Becoming.ConditionalWeights.'
TY = 'Becoming.Typicality.'
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
mine = [n for n in unclassified if n.startswith(CW) or n.startswith(TY)]
others = [n for n in unclassified if not (n.startswith(CW) or n.startswith(TY))]
assert not others, ('apart roots of other modules unclassified; not UE2\'s to register', others)

W = 'a witness on one constructed weighting or pair of shares (Becoming.ConditionalWeights, UE2)'
LAW_A = ('a law of every natural weighting of listed courses (conditioning by restriction, shares, a generative '
         'model\'s posterior, independence), an identity of counting with no world; the base supplies no reading of '
         'its vocabulary (Becoming.ConditionalWeights, UE2)')
LAW_B = ('a law of the courses of Becoming.Typicality read at a margin (the exit from a margin and what a record of the '
         'course says of it), with no world; the base supplies no reading of its vocabulary (Becoming.ConditionalWeights, '
         'UE2)')
LAW_T = ('a law of the courses of Becoming.Typicality, counting with natural weights and no world (the bound at every '
         'step, UE2); the base supplies no reading of its vocabulary')
SUPPORT = 'an arithmetic or list lemma, or a one-line unpacking of the module\'s own definitions'
support = {'entry_and', 'entry_swap', 'entry_split', 'entry_test_le', 'entry_mul_left', 'entry_and_true',
           'entry_and_comm', 'entry_restrict_le', 'mass_eq_sum', 'mass_congr_mem', 'mass_congr', 'mass_le_of_entries',
           'mass_none', 'mass_append', 'mass_map', 'mass_joinMap', 'mass_mul_left', 'mass_mul_right',
           'whole_of_entries', 'mass_eq_total', 'mass_and_comm', 'mass_and_true', 'mass_scaled_event', 'mass_first',
           'mass_absent', 'mass_single', 'foldr_whole', 'foldr_part', 'share_within', 'Share.le_refl', 'joinMap_congr',
           'joinMap_single', 'extend_append', 'extend_joinMap', 'extend_map_append', 'drop_append_length',
           'weight_append', 'ones_append', 'zeros_append', 'margin_shift', 'deviates_offBy', 'whole_typical',
           'fallsWithin_of_end', 'fallsWithin_reachesBy', 'fallsWithin_entry', 'fallsTo_succ'}
exit_laws = {'deviates_bound', 'fallsWithin_bound', 'fallsTo_bound', 'fallsWithin_share', 'fallsWithin_reciprocal',
             'courses_add', 'mass_record', 'fallsTo_append', 'fallsWithin_append', 'record_fallsWithin', 'record_share',
             'record_bound'}
typicality_support = {'regroup_square', 'square_gap', 'margin_square', 'two_mul_le_of_le', 'reachesBy_of_end',
                      'moving_le', 'stopped_go', 'offBy_le_within'}


def classify(name):
    if name.startswith(TY):
        short = name[len(TY):]
        return ('support', SUPPORT) if short in typicality_support else ('general-structure', LAW_T)
    short = name[len(CW):]
    if short.startswith('Witness.'):
        return 'model-witness', W
    if short in support:
        return 'support', SUPPORT
    return 'general-structure', LAW_B if short in exit_laws else LAW_A


t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = classify(name)
    module = 'Becoming.Typicality' if name.startswith(TY) else 'Becoming.ConditionalWeights'
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + module + '",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'model-witness')})
