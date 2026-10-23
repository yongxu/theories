"""OU4: register the apart roots of Becoming.GrammarMap (a leaf). usage (from the checkout root): python3 -B register3.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
GS = 'general-structure'
LAW = 'a law of every relation read at a fine and a coarse class on any carrier; the base supplies no reading of the two grains yet'
entries = {
    'Becoming.«传则异»': (GS, 'a carrying renewal is an alteration; ' + LAW),
    'Becoming.«生成守不并»': (GS, 'generation and keeping exclude each other; ' + LAW),
    'Becoming.«守退化不并»': (GS, 'keeping and degeneration exclude each other; ' + LAW),
    'Becoming.«三域之周»': (GS, 'with excluded middle the three regions cover every point; ' + LAW),
    'Becoming.«生成之所及亦生成»': (GS, 'generation holds along its line; ' + LAW),
    'Becoming.«退化之所前亦退化»': (GS, 'degeneration reaches back along its line; ' + LAW),
    'Becoming.«退化则粗不有常»': (GS, 'what degenerates after a continued step has a coarse class that is not constant; ' + LAW),
    'Becoming.«阶生成则上不退化»': (GS, 'generation at an order keeps the next order from degenerating; ' + LAW),
    'Becoming.«生败之定当且仅当排中»': ('calibration', 'telling generation from degeneration on every line, in every model, is '
                                              'exactly excluded middle; a lemma of OU4, which reads the regions as decided '
                                              'only in decided models'),
    'Becoming.Map.Endless.generation': ('model-witness', 'the endless chain on the numbers generates under the one with identity as the parts\' class'),
    'Becoming.Map.Still.keeping': ('model-witness', 'the still pattern on one occurrence keeps'),
    'Becoming.Map.Short.renews_and_ends': ('model-witness', 'the short life of two occurrences renews and ends'),
}
block = ''
for name, (cat, reason) in entries.items():
    assert f'"{name}"' not in t, name
    block += ('  "' + name + '": {\n   "module": "Becoming.GrammarMap",\n   "category": "' + cat + '",\n'
              '   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register3:', len(entries))
