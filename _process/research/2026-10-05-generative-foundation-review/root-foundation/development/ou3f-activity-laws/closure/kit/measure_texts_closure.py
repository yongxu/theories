#!/usr/bin/env python3
"""OU3f, closure: the measure moved by one declaration (Web.Whole.family_excess_ends, resting on balance, now also
reaching the grammar through closure, its proof using active_back): 08 §7's counts and the four front pages' count.
Run after the measure; the counts are asserted against its JSON.
usage (from the checkout root): python3 -B measure_texts_closure.py MEASURE_JSON"""
import json
import sys
from pathlib import Path

M = json.loads(Path(sys.argv[1]).read_text(encoding='utf-8'))
assert M['reaching_the_grammar'] == 45 and M['central_declarations'] == 127
assert M['distinct_by_dependence'] == {'grammar': 44, 'balance, represented': 31, 'anchor, not reached': 7, 'no master law': 36}
assert M['by_master_law_resting_and_reaching_grammar']['balance'] == [55, 16]
B = Path('theories/becoming')


def edit(path, pairs):
    text = path.read_text(encoding='utf-8')
    for old, new in pairs:
        assert text.count(old) == 1, (path.name, old[:60], text.count(old))
        text = text.replace(old, new)
    path.write_text(text, encoding='utf-8')


edit(B / 'chapters/08-METHOD.md', [
    ('Of the 127, 44 now reach the grammar (', 'Of the 127, 45 now reach the grammar ('),
    ('all 27 on closure, all 13 on finite runs, 15 of 55 on balance,', 'all 27 on closure, all 13 on finite runs, 16 of 55 on balance,'),
    ('fall four ways: 43 reach the grammar; 32 rest on balance,', 'fall four ways: 44 reach the grammar; 31 rest on balance,')])
for name in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
    edit(B / name, [('of the 127 central declarations, 44 now reach the grammar' if 'THEORY' in name
                     else 'Of the 127 central declarations, 44 now reach the grammar',
                     'of the 127 central declarations, 45 now reach the grammar' if 'THEORY' in name
                     else 'Of the 127 central declarations, 45 now reach the grammar')])
for name in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
    edit(B / name, [('127 条核心声明中，现有 44 条通到文法', '127 条核心声明中，现有 45 条通到文法')])
print('measure texts: 08 §7 (45 of 127; 16 of 55 on balance; 44 and 31 of the distinct) and the four front pages (45)')
