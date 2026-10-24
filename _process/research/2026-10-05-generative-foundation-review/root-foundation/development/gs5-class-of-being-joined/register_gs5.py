"""GS5: register the apart roots that connectivity lists, and drop «同族为类», which GS5's laws now use. Textual edits,
the rest of the file byte for byte (GS2's register_gs2.py). usage (from the checkout root): python3 -B register_gs5.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
key = '  "Becoming.«同族为类»": {\n'
i = t.index(key)
j = t.index('  },\n', i) + len('  },\n')
assert t[i:j].count('"module": "Becoming.Grammar"') == 1
t = t[:i] + t[j:]
law = 'a law of every relation on any carrier; the base states no class of being joined yet, so nothing on it uses this law'
w = 'a witness of a third thing joined to two families and their shared condition (Becoming.GrammarCases, GS5)'
entries = {
    'Becoming.«族之所及即一之所及»': ('Becoming.GrammarScope', 'general-structure', 'the class of being joined reaches what the one reaches: ' + law),
    'Becoming.«续即缘当且仅当含族»': ('Becoming.GrammarScope', 'general-structure', 'the finest class with 缘 as its continuation: ' + law),
    'Becoming.«遍有后则核之所及即一之所及»': ('Becoming.GrammarScope', 'general-structure', 'a line under the core of the class of being joined reaches what the one reaches: ' + law),
    'Becoming.ThirdThing.fixed_class': ('Becoming.GrammarCases', 'model-witness', 'joined to nothing, outside the class of being joined: ' + w),
    'Becoming.ThirdThing.fixed_class_reaches': ('Becoming.GrammarCases', 'model-witness', 'the class of being joined reaches the other family: ' + w),
    'Becoming.ThirdAffects.finer_class_reaches': ('Becoming.GrammarCases', 'model-witness', 'a finer constant class reaches the same: ' + w),
    'Becoming.ThirdAffects.third_class': ('Becoming.GrammarCases', 'support', 'a one-line check that the third thing or not is a class'),
    'Becoming.ThirdFed.constant_takes_third': ('Becoming.GrammarCases', 'model-witness', 'a constant class takes in what the condition feeds: ' + w),
}
block = ''
for name, (mod, cat, reason) in entries.items():
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + mod + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register: dropped 1, added', block.count('"module"'))
