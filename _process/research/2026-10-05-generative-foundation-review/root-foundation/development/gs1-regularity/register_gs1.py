"""GS1: register the apart roots of Becoming.GrammarRegularity that connectivity lists. Textual insertion at the end of
the roots, the rest of the file byte for byte (WL3's register.py). usage (from the checkout root): python3 -B register_gs1.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
why = ('a law of every relation and class on any carrier, from the root theorem; the base reads no line through a '
       'class\'s core yet, so nothing on it uses this law')
entries = {
    'Becoming.«守理则不穷»': ('general-structure', 'a kept regularity can always be kept: ' + why),
    'Becoming.«有亡之线末步离核»': ('general-structure', 'the last step of a line that ends leaves the core: ' + why),
    'Becoming.«有亡之线两端理异»': ('general-structure', 'the ends of a line that ends lie apart in the core: ' + why),
    'Becoming.ClosedCapture.lockedAlike_class': ('support', 'a one-line check that being locked or not is a class; '
                                                 'the lock line is stated without needing it'),
    'Becoming.ClosedCapture.Beyond.open_line_ends': ('model-witness', 'the witness read from the loss: its line under '
                                                     'favouring ends at the first step, computed on the witness'),
}
block = ''
for name, (cat, reason) in entries.items():
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.GrammarRegularity",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register:', block.count('"module"'))
