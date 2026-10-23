"""OU5: register the apart roots of Becoming.GrammarTesting (a leaf). usage (from the checkout root): python3 -B register5.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
entries = {
    'Becoming.«恒温与平衡»': ('model-witness', 'the balanced and the thermostat-held room: one core class under the closed '
                                         'net, told apart under the net with the window\'s opening'),
    'Becoming.«可分则不在核»': ('general-structure', 'a law of every relation and class on any carrier: what a finite stage '
                                              'tells apart is not in the core; the base supplies no reading of the stages yet'),
    'Becoming.«核在每层之内»': ('general-structure', 'a law of every relation and class on any carrier: the core lies in every '
                                              'stage; the base supplies no reading of the stages yet'),
}
import sys
only = set(sys.argv[1:])
block = ''
for name, (cat, reason) in entries.items():
    if only and name not in only:
        continue
    assert f'"{name}"' not in t, name
    block += ('  "' + name + '": {\n   "module": "Becoming.GrammarTesting",\n   "category": "' + cat + '",\n'
              '   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register5:', block.count('"module"'))
