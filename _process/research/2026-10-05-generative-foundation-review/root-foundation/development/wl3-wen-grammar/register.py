"""WL3: register the apart roots of Becoming.GrammarCourse that connectivity lists. Textual insertion at the end of the
roots, the rest of the file byte for byte. usage (from the checkout root): python3 -B register.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
entries = {
    'Becoming.Law.ends_iff_changes': ('general-structure', 'a law of every determined law and map on any type: under the '
                                      'class of the map\'s values a line of continuation ends exactly where the value '
                                      'changes at the next step; the base reads no course through the grammar\'s ending yet'),
    'Becoming.Steps.next_is_step': ('support', 'a one-line unpacking: the steps of one course (Steps.next) are the step of '
                                    'the successor law (Law.step Nat.succ), pointwise by definition'),
    'Becoming.core_within_core_iff': ('general-structure', 'a law of every relation and class on any carrier, from the root '
                                      'theorem: a core lies in another class\'s core exactly where it lies in that class; '
                                      'the base compares no two classes\' cores yet'),
}
block = ''
for name, (cat, reason) in entries.items():
    assert f'"{name}"' not in t, name
    block += ('  "' + name + '": {\n   "module": "Becoming.GrammarCourse",\n   "category": "' + cat + '",\n'
              '   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register:', block.count('"module"'))
