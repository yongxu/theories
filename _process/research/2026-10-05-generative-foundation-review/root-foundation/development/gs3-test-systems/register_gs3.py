"""GS3: register the apart roots of Becoming.GrammarCases that connectivity lists, all witnesses. Textual insertion,
the rest of the file byte for byte (GS1's register_gs1.py). usage (from the checkout root): python3 -B register_gs3.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
w = 'a small witness of a test system of the source texts, computed on its supplied net (Becoming.GrammarCases, GS3)'
entries = {n: ('model-witness', what + ': ' + w) for n, what in (
    ('Becoming.Decay.both_open', 'decay: stay and decay both open at every intact moment'),
    ('Becoming.Decay.decay_alters', 'decay: the decay an alteration under the one'),
    ('Becoming.Decay.history_apart', 'decay: the two intact moments of one history apart in the core'),
    ('Becoming.Decay.history_within', 'decay: the history lies within the net of possibilities'),
    ('Becoming.Decay.possible_acyclic', 'decay: no occurrence reaches itself'),
    ('Becoming.Decay.time_not_in_core', 'decay: every two intact moments alike in the core'),
    ('Becoming.LineOfDescent.Endless.generates', 'the line of descent generates at two grains'),
    ('Becoming.Overlap.b_positions', 'no clear boundary: positions differing by class'),
    ('Becoming.Overlap.continues_each', 'no clear boundary: two overlapping classes'),
    ('Becoming.Overlap.tolerance_line_apart', 'no clear boundary: the union not a class, its line leaving it'),
    ('Becoming.TwoLines.between', 'two family lines: the family class between a member\'s and the one'),
    ('Becoming.TwoLines.core_through_birth', 'two family lines: the family core going on through each birth'),
    ('Becoming.TwoLines.other_line_outside', 'two family lines: the other family not reached'))}
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
