"""Register the apart roots OU1 adds (Becoming.Grammar, a leaf until OU3 lifts the continuation family onto it).
Textual insertion at the end of the roots, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register.py"""
import json
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
GS = 'general-structure'
LAW = 'a law of every relation on any carrier; the base supplies no reading of continuation relative to a class yet ' \
      '(OU3 lifts the continuation family onto it)'
entries = {
    'Becoming.«根»': (GS, 'the root theorem: the core of a class under any relation is its greatest symmetric constant '
                          'relation; ' + LAW),
    'Becoming.«核为类»': (GS, 'the core of a class is a class; ' + LAW),
    'Becoming.«位根»': (GS, 'the two-way core is the greatest symmetric relation inside a class constant under a '
                            'relation and its converse; ' + LAW),
    'Becoming.«位同则四相同»': (GS, 'what shares a position under the two-way core shares beginning and ending; ' + LAW),
    'Becoming.«闭合当且仅当有常»': (GS, 'for a class, constancy is exactly closure of the coarse net; ' + LAW),
    'Becoming.«类内之缘成环»': (GS, 'reading a relation at a class without taking classes apart puts every inner '
                                  'relation on a loop; ' + LAW),
    'Becoming.«粗只连异类»': (GS, 'the coarse net joins only different classes; ' + LAW),
    'Becoming.«有常则相续不尽»': (GS, 'under a constant class a line never ends after its first step; ' + LAW),
    'Becoming.«有亡之续则不有常»': (GS, 'a class under which some line ends is not constant; ' + LAW),
    'Becoming.«相续含于及»': (GS, 'a line runs along the reach of the relation; ' + LAW),
    'Becoming.«一之续»': (GS, 'continuation under the full class is the relation itself; ' + LAW),
    'Becoming.«一之生»': (GS, 'under the full class an occurrence begins exactly where nothing conditions it; ' + LAW),
    'Becoming.«一之下无复生»': (GS, 'under the full class nothing renews; ' + LAW),
    'Becoming.«一之下无生生»': (GS, 'under the full class there is no renewal without end; ' + LAW),
    'Becoming.«亡于粗则亡于细»': (GS, 'what ends under a coarser class ends under a finer; ' + LAW),
    'Becoming.«住于细则住于粗»': (GS, 'what abides under a finer class abides under a coarser; ' + LAW),
    'Becoming.«生住不并»': (GS, 'beginning and abiding exclude each other; ' + LAW),
    'Becoming.«住亡不并»': (GS, 'abiding and ending exclude each other; ' + LAW),
    'Becoming.«四相无自立»': (GS, 'the positions depend on the class: one occurrence abides under the full class and '
                                'begins and ends under identity; ' + LAW),
    'Becoming.«复生则粗复生»': (GS, 'every renewal is a renewal at the grain of every class; ' + LAW),
    'Becoming.«生生最大»': (GS, 'renewal without end is the greatest renewing family; ' + LAW),
    'Becoming.«生生则复生»': (GS, 'renewal without end renews; ' + LAW),
    'Becoming.«无环则及为序»': (GS, 'without cycles reach is a strict order; ' + LAW),
    'Becoming.«任一缘可为续»': (GS, 'every single relation pair is a continuation under some class, so containment in '
                                  'the relation is necessary only; ' + LAW),
    'Becoming.«蜡烛之合»': (GS, 'two alike conditions of one occurrence make a merge of continuations; ' + LAW),
    'Becoming.«则之自反»': ('support', 'inclusion of relations is reflexive: a one-line unpacking of the grammar\'s own '
                                      'definition'),
    'Becoming.«则之传递»': ('support', 'inclusion of relations is transitive: a one-line unpacking of the grammar\'s own '
                                       'definition'),
    'Becoming.«一为类»': ('support', 'the full relation is a class: a one-line unpacking of the grammar\'s own definitions'),
    'Becoming.«同族为类»': ('support', 'the equivalence closure of continuation is a class: its constructors are the '
                                       'class laws'),
    'Becoming.«四相之定当且仅当排中»': ('calibration', 'that every occurrence, in every model, either begins or has a '
                                                  'predecessor is exactly excluded middle; a lemma of OU1, which reads '
                                                  'the positions as decidable only in decidable models'),
    'Becoming.«分叉»': ('model-witness', 'one constructed net where an occurrence is continued by two that go no further: '
                                         'sameness along lines is not transitive'),
    'Becoming.«亡于细者不必亡于粗»': ('model-witness', 'one constructed net of two occurrences ending under identity and '
                                                  'abiding under the full class'),
    'Becoming.«以核为判据则火无续»': ('model-witness', 'the flame of three moments ending in ash: continuing under '
                                                  '"flame or not", no continuation under that class\'s core'),
    'Becoming.Flame.alike_class': ('model-witness', 'the class "flame or not" of the flame witness is a class'),
}
block = ''
for name, (cat, reason) in entries.items():
    assert f'"{name}"' not in t, name
    block += ('  "' + name + '": {\n'
              '   "module": "Becoming.Grammar",\n'
              '   "category": "' + cat + '",\n'
              '   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n'
              '  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
d = json.loads(t)
assert all(d['roots'][n]['category'] == c for n, (c, _) in entries.items())
F.write_text(t, encoding='utf-8')
print('register:', len(entries), 'roots added')
