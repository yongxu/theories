"""GS2: register the apart roots of Becoming.GrammarScope that connectivity lists, and drop GS1's «守理则不穷», which
GS2's laws now use. Textual edits, the rest of the file byte for byte (GS1's register_gs1.py).
usage (from the checkout root): python3 -B register_gs2.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
# drop «守理则不穷», now used
key = '  "Becoming.«守理则不穷»": {\n'
i = t.index(key)
j = t.index('  },\n', i) + len('  },\n')
assert t[i:j].count('"module": "Becoming.GrammarRegularity"') == 1
t = t[:i] + t[j:]
law = ('a law of every relation and class on any carrier; the base states no center\'s continuing under a class yet, '
       'so nothing on it uses this law')
wit = 'computed on a line of descent in Becoming.GrammarScope, a witness of the reach past one\'s own end'
entries = {
    'Becoming.«续无外则族无外»': ('general-structure', 'the condition along the net gives it in families: ' + law),
    'Becoming.«续无外之粗化»': ('general-structure', 'the condition along the net at a class gives it at every coarser '
                                                    'class: ' + law),
    'Becoming.«族无外之粗化»': ('general-structure', 'the condition in families at a class gives it at every coarser '
                                                    'class: ' + law),
    'Becoming.«续无外则同一中心»': ('general-structure', 'along a net with no cycle the condition holds only with one '
                                                       'center: ' + law),
    'Becoming.«续无外则中心无缘»': ('general-structure', 'and nothing conditions that center: ' + law),
    'Becoming.«核有续当且仅当有不穷»': ('general-structure', 'a core continues something exactly where some line under '
                                                         'it never ends: ' + law),
    'Becoming.premises_of_noOutside': ('support', 'one instance of Valuation.premises_of_unrestricted at the de se '
                                                  'own-closure significance, through ownClosure_unrestricted_iff_noOutside'),
    'Becoming.LineOfDescent.Endless.descent_unending': ('model-witness', 'the core of descent goes on for good from '
                                                                         'each birth: ' + wit),
    'Becoming.LineOfDescent.Endless.member_class': ('support', 'a one-line check that same member is a class'),
    'Becoming.LineOfDescent.Endless.descent_no_outside': ('model-witness', 'with the first birth as the only center the '
                                                                           'condition holds under the one: ' + wit),
    'Becoming.LineOfDescent.Endless.member_outside': ('model-witness', 'under the member\'s class it fails: ' + wit),
    'Becoming.LineOfDescent.Last.core_no_continuation': ('model-witness', 'in descent that ends no core continues '
                                                                          'anything: ' + wit),
    'Becoming.LineOfDescent.Last.descent_past_end': ('model-witness', 'the one reaches the second member past the '
                                                                      'first\'s end: ' + wit),
}
block = ''
for name, (cat, reason) in entries.items():
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.GrammarScope",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register: dropped 1, added', block.count('"module"'))
