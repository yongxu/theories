"""PF2: register the apart roots that connectivity lists for the declarations PF2 added to Becoming.GrammarPath. Textual
edits, the rest of the file byte for byte (PF's register_pf.py). usage (from the checkout root): python3 -B register_pf2.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
M = 'Becoming.GrammarPath'


def w(what):
    return what + ': a witness of Becoming.GrammarPath (PF2)'


entries = {
    'Becoming.CleanStep.not_constant_to_end': ('model-witness', w('a step with nothing outside the class breaks constancy up to the net\'s end')),
    'Becoming.FiniteWake.not_constant': ('model-witness', w('the finite class constant up to the net\'s end is not constant')),
    'Becoming.FiniteWake.not_held': ('model-witness', w('the class does not hold the member\'s effects')),
    'Becoming.FiniteWake.wake_follows': ('model-witness', w('something outside the class follows every step of its line that goes on')),
}
block = ''
for name, (cat, reason) in entries.items():
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + M + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register: added', block.count('"module"'))
