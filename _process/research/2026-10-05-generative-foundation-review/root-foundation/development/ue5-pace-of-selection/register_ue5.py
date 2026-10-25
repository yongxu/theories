#!/usr/bin/env python3
"""UE5: register the apart roots of Becoming.SelectionPace that connectivity lists without a reason, each with a category
and a reason; textual edits, the rest of the file byte for byte (UE1's register_ue1.py).
usage (from the checkout root): python3 -B <kit>/register_ue5.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
PREFIX = 'Becoming.SelectionPace.'
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
mine = [n for n in unclassified if n.startswith(PREFIX)]
others = [n for n in unclassified if not n.startswith(PREFIX)]
assert not others, ('apart roots of other modules unclassified; not UE5\'s to register', others)

WITNESS = ('a witness of the pace laws on one constructed flow and its generations '
           '(Becoming.SelectionPace, UE5)')
SPACES = ('Displacement.', 'Fed.', 'Inherited.', 'Swap.', 'Uncapped.', 'Shrink.')
SUPPORT = ('an arithmetic or list lemma, or a one-line unpacking of the module\'s own definitions '
           '(a lineage, its carriers, the generations read by offspring number)')
support = {'lineage_mono', 'lineage_sub', 'fresh_total', 'standing_total', 'mem_carriers', 'total_lineage_one',
           'total_lineage', 'excess_add_le', 'excess_total_le', 'total_carriers_le', 'total_carriers_unit',
           'numbered_family', 'numbered_number'}
RESTATES = ('it restates, under exact transmission, Price\'s step and the offspring total of SelectionTerm '
            '(the base\'s Generations.mean_step and price)')
restates = {'sum_exact', 'mean_step_exact'}
LAW = ('a law of the flow joined to selection over generations, on any type of relatum: the base supplies balance '
       'and the inflow, and no central declaration reads a pace of selection, so nothing on it uses this law')


def classify(name):
    short = name[len(PREFIX):]
    if short.startswith(SPACES):
        return 'model-witness', WITNESS
    if short in support:
        return 'support', SUPPORT
    if short in restates:
        return 'restates', RESTATES
    return 'general-structure', LAW


t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = classify(name)
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.SelectionPace",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    data = json.loads(t)
    assert all(data['roots'][n]['category'] in data['categories'] for n in mine)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'restates', 'model-witness')})
