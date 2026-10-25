#!/usr/bin/env python3
"""GS6: the connectivity register. «所经不同则不及» (GrammarPath) and «续即缘当且仅当含族» (GrammarScope) are now used by
GrammarCases, and LineOfDescent.Endless.member_class by member_line, so they are no longer apart roots and their
entries go; GrammarPath's other entries no longer say it is a
leaf; the two shared-condition witnesses say they are proved from the law. Textual edits, the rest of the file byte for
byte (GS5's register_gs5.py). usage (from the checkout root): python3 -B register_gs6.py"""
import json
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
for name, module in (('Becoming.«所经不同则不及»', 'Becoming.GrammarPath'), ('Becoming.«续即缘当且仅当含族»', 'Becoming.GrammarScope'),
                     ('Becoming.LineOfDescent.Endless.member_class', 'Becoming.GrammarScope')):
    key = '  ' + json.dumps(name, ensure_ascii=False) + ': {\n'
    assert t.count(key) == 1, name
    i = t.index(key)
    j = t.index('  },\n', i) + len('  },\n')
    assert t[i:j].count(f'"module": "{module}"') == 1
    t = t[:i] + t[j:]
leaf = ' (Becoming.GrammarPath is a leaf until the owner of Becoming.GrammarCases decides on the proposed corollary)'
n = t.count(leaf)
assert n == 3, n
t = t.replace(leaf, ' (of this module, Becoming.GrammarCases uses only «所经不同则不及», since GS6)')
for old in ('under a member or not the other family is not reached: a witness of two lines sharing a condition, computed on its supplied net',
            'from a condition no member affects, no relation reaches the other family: a witness of two lines sharing a condition, computed on its supplied net'):
    assert t.count(old) == 1, old[:40]
    t = t.replace(old, old.replace('computed on its supplied net', 'proved from «所经不同则不及» on its supplied net'))
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register: dropped 3 (now used), GrammarPath leaf notes and the two shared-condition reasons updated')
