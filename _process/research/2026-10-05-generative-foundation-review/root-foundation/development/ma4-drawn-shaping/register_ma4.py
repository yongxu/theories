#!/usr/bin/env python3
"""MA4: register the apart roots of Becoming.DrawnShaping that connectivity lists without a reason, each with a category
and a reason; textual edits, the rest of the file byte for byte (register_ma3.py).
usage (from the checkout root): python3 -B register_ma4.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
PREFIX = 'Becoming.DrawnShaping.'
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
mine = [n for n in unclassified if n.startswith(PREFIX)]
others = [n for n in unclassified if not n.startswith(PREFIX)]
assert not others, ('apart roots of other modules unclassified; not MA4\'s to register', others)

W = 'a witness of the capacity to shape the rule read by readers drawn from the selected (Becoming.DrawnShaping, MA4)'
LAW = ('a law of selection on counts of two kinds (RuleCapture\'s CarrierCounts) for every rule after shaping read by '
       'readers drawn from the selected; the base states no shaping of the rule, so nothing on it uses this law')
SUPPORT_ARITH = 'an arithmetic lemma on natural numbers about what the rule read gives each kind'
SUPPORT_UNPACK = 'a one-line unpacking of the module\'s own definitions, or a general lemma on counts it uses'
support_unpack = {'drawn_carrier_pos', 'present_along_course', 'upper_strictly', 'shaped_le_iff'}
support_arith = {'mul_split', 'drawn_split'}


def classify(name):
    short = name[len(PREFIX):]
    if short.startswith(('CriticalMass.', 'Against.')):
        return 'model-witness', W
    if short in support_unpack:
        return 'support', SUPPORT_UNPACK
    if short in support_arith:
        return 'support', SUPPORT_ARITH
    return 'general-structure', LAW


t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = classify(name)
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.DrawnShaping",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'model-witness')})
