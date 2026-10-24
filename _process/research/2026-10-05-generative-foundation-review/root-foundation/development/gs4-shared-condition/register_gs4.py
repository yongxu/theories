"""GS4: register the apart roots of the shared-condition witnesses. Textual insertion, the rest of the file byte for
byte (GS1's register_gs1.py). usage (from the checkout root): python3 -B register_gs4.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
w = 'a witness of two lines sharing a condition, computed on its supplied net (Becoming.GrammarCases, GS4)'
entries = {n: ('model-witness', what + ': ' + w) for n, what in (
    ('Becoming.SharedCondition.affecting_reaches_other', 'the line under the one reaches the other family through the condition'),
    ('Becoming.SharedCondition.affecting_member_outside', 'under a member or not the other family is not reached'),
    ('Becoming.SharedCondition.fed_outside', 'from a condition no member affects, no relation reaches the other family'))}
block = ''
for name, (cat, reason) in entries.items():
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.GrammarCases",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register:', block.count('"module"'))
