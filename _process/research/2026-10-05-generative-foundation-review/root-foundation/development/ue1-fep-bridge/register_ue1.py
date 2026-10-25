#!/usr/bin/env python3
"""UE1: register the apart roots of Becoming.ChoiceCountCapture that connectivity lists without a reason, each with a category
and a reason; textual edits, the rest of the file byte for byte (MA3's register_ma3.py).
usage (from the checkout root): python3 -B register_ma3.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
mine = [n for n in unclassified if n.startswith('Becoming.ChoiceCountCapture.')]
others = [n for n in unclassified if not n.startswith('Becoming.ChoiceCountCapture.')]
assert not others, ('apart roots of other modules unclassified; not UE1\'s to register', others)

W = 'a witness of the count laws on two policies (Becoming.ChoiceCountCapture, UE1)'
LAW = ('an instance law of selection through couplings or of capture through the rule, read on a chooser whose prior '
       'counts its own choices (active inference); the base states no such chooser, so nothing on it uses this law')
SUPPORT_UNPACK = 'a one-line unpacking of the module\'s own definitions'
support_unpack = {'choose_favoured', 'choose_unfavoured', 'weighted_favours_iff', 'start_locked', 'memberFolds_alike',
                  'lower_strict'}


def classify(name):
    short = name[len('Becoming.ChoiceCountCapture.'):]
    if short.startswith('Witness.'):
        return 'model-witness', W
    if short in support_unpack:
        return 'support', SUPPORT_UNPACK
    return 'general-structure', LAW


t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = classify(name)
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.ChoiceCountCapture",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'model-witness')})
