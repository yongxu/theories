#!/usr/bin/env python3
"""MA3: register the apart roots of Becoming.RuleShaping that connectivity lists without a reason, each with a category
and a reason; textual edits, the rest of the file byte for byte (GS5's register_gs5.py).
usage (from the checkout root): python3 -B register_ma3.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
mine = [n for n in unclassified if n.startswith('Becoming.RuleShaping.')]
others = [n for n in unclassified if not n.startswith('Becoming.RuleShaping.')]
assert not others, ('apart roots of other modules unclassified; not MA3\'s to register', others)

W = ('a witness of the capacity to shape the rule on counts of two kinds (Becoming.RuleShaping, MA3)')
LAW = ('a law of selection on counts of two kinds (RuleCapture\'s CarrierCounts) for every rule after shaping; the base '
       'states no shaping of the rule, so nothing on it uses this law')
SUPPORT_ARITH = 'an arithmetic lemma on natural numbers about the counts multiplied across a stretch'
SUPPORT_UNPACK = 'a one-line unpacking of the module\'s own definitions'
support_unpack = {'eq_of_counts', 'pow_pos_of_pos', 'present_along', 'present_of_le', 'threshold_present_below',
                  'thresholdBack_above', 'thresholdBack_below', 'thresholdBack_mono', 'shaped_shift'}
support_arith = {'wait_not_more', 'back_longer_not_less'}


def classify(name):
    short = name[len('Becoming.RuleShaping.'):]
    if short.startswith(('Split.', 'SharedFlips.', 'Timing.')):
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
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.RuleShaping",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'model-witness')})
