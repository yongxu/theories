"""PF: register the apart roots that connectivity lists for Becoming.GrammarPath. Textual edits, the rest of the file
byte for byte (GS5's register_gs5.py). usage (from the checkout root): python3 -B register_pf.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
law = ('a law of every relation and class on any carrier, the general form of 07 §4.6\'s steps 3-4; the base states '
       'no line under a class yet, so nothing on it uses this law (Becoming.GrammarPath is a leaf until the owner of '
       'Becoming.GrammarCases decides on the proposed corollary)')
M = 'Becoming.GrammarPath'


def w(what):
    return what + ': a witness of Becoming.GrammarPath (PF)'


entries = {
    'Becoming.«所经不同则不及»': ('general-structure', 'nothing beyond is reached where the class holds none of what the line must pass: ' + law),
    'Becoming.«常闭则所缘同类»': ('general-structure', 'under a constant class, what is alike to a member whose effects it holds conditions only what is alike: ' + law),
    'Becoming.«常闭则所及皆及»': ('general-structure', 'under a constant class, a line reaching what is alike to such a member reaches all that follows: ' + law),
    'Becoming.«常类之闭当且仅当后皆同类»': ('general-structure', 'under constancy, holding a member\'s effects is equivalent to all downstream being alike: ' + law),
    'Becoming.Unclosed.constant': ('model-witness', w('the class of the unclosed witness is constant')),
    'Becoming.Unclosed.not_taken_in': ('model-witness', w('without holding the member\'s effects, a constant class does not reach what the condition feeds')),
    'Becoming.Inconstant.same_class': ('support', 'a one-line check that the inconstant witness\'s relation is a class'),
    'Becoming.Inconstant.not_all_follow': ('model-witness', w('without constancy, even up to the net\'s end, what follows a held effect need not be alike')),
    'Becoming.FiniteFamilies.family_narrower': ('model-witness', w('the family\'s class is narrower than the one')),
    'Becoming.FiniteFamilies.one_not_constant': ('model-witness', w('in a finite net the one is not constant')),
    'Becoming.FiniteFamilies.member_not_constant_to_end': ('model-witness', w('the organism\'s class is not constant up to the net\'s end')),
    'Becoming.FiniteFamilies.family_takes_in_all': ('model-witness', w('the family\'s class takes in all downstream of its first birth')),
    'Becoming.FiniteFamilies.other_family_outside': ('model-witness', w('no line leaves its family')),
    'Becoming.FiniteSharedCondition.held_narrower': ('model-witness', w('the class holding the families with their condition is narrower than the one')),
    'Becoming.FiniteSharedCondition.one_not_constant': ('model-witness', w('in the finite shared-condition net the one is not constant')),
    'Becoming.FiniteSharedCondition.member_not_constant_to_end': ('model-witness', w('the member\'s class is not constant up to the net\'s end')),
    'Becoming.FiniteSharedCondition.reaches_other_past_end': ('model-witness', w('the line reaches the second family past the first member\'s end')),
    'Becoming.FiniteSharedCondition.fourth_outside': ('model-witness', w('the line never reaches the fourth thing')),
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
