#!/usr/bin/env python3
"""MA4b: register the apart roots of Becoming.ReadInTime that connectivity lists without a reason, each with a category
and a reason; textual edits, the rest of the file byte for byte (register_ma4.py).
usage (from the checkout root): python3 -B register_ma4b.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
PREFIX = 'Becoming.ReadInTime.'
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
mine = [n for n in unclassified if n.startswith(PREFIX)]
others = [n for n in unclassified if not n.startswith(PREFIX)]
assert not others, ('apart roots of other modules unclassified; not MA4b\'s to register', others)

W = 'a witness of the loss read in time by the others, joined to the critical mass (Becoming.ReadInTime, MA4b)'
LAW = ('a law of selection on counts of two kinds (RuleCapture\'s CarrierCounts) for every rule after shaping read by '
       'readers drawn from the selected, the others reading a loss late; the base states no shaping of the rule, so '
       'nothing on it uses this law')
SUPPORT_UNPACK = ('a one-line unpacking of the module\'s own definitions, or a general lemma on counts or powers it '
                  'uses')
support_unpack = {'shapedLossPool_before', 'turn_before', 'loss_next', 'next_share', 'held_counts',
                  'powers_base_le', 'powers_eq_pow', 'covers_of_strict'}


def classify(name):
    short = name[len(PREFIX):]
    if short.startswith(('Window.', 'Between.', 'Tie.')):
        return 'model-witness', W
    if short in support_unpack:
        return 'support', SUPPORT_UNPACK
    return 'general-structure', LAW


t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = classify(name)
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.ReadInTime",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'model-witness')})
