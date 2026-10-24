#!/usr/bin/env python3
"""OU2 + OU3a: copy the merged modules into the core package, join Becoming.GrammarReadings (import after
Becoming.Grammar, root doc bullet before Prelude's, CORE entry after Grammar's, scope text, README rows after
Grammar's). usage: OU_ROOT=<checkout> python3 -B integrate2.py   (each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['OU_ROOT']).resolve()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
TREE = HERE.parent / 'merged' / 'tree' / 'Becoming'
MODULES = ['Grammar', 'GrammarReadings', 'Arising', 'Change', 'Identity', 'ContinuedClasses', 'PatternPassing',
           'Persistence', 'Space']


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def kit(name):
    return (HERE / name).read_text(encoding='utf-8')


for m in MODULES:
    shutil.copyfile(TREE / f'{m}.lean', PKG / 'Becoming' / f'{m}.lean')
root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
assert 'import Becoming.GrammarReadings' not in root
root = once(root, 'import Becoming.Grammar\n', 'import Becoming.Grammar\nimport Becoming.GrammarReadings\n')
start = root.index('* `Becoming.Prelude` (L0)')
root = root[:start] + kit('doc_bullet_readings.txt') + root[start:]
chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
chk = once(chk, 'CORE = ["Becoming.Grammar", ', 'CORE = ["Becoming.Grammar", "Becoming.GrammarReadings", ')
chk = once(chk, '    "Grammar: for every carrier and relation,', kit('scope_readings.txt') + '    "Grammar: for every carrier and relation,')
readmes = {}
for name, row in (('README.md', kit('readme_row_readings.txt').rstrip('\n')),
                  ('README.zh.md', kit('readme_row_readings_zh.txt').rstrip('\n'))):
    lines = (PKG / name).read_text(encoding='utf-8').split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith('| L0 | [`Becoming.Grammar`](Becoming/Grammar.lean) |')]
    assert len(idx) == 1, (name, idx)
    lines[idx[0] + 1:idx[0] + 1] = [row]
    readmes[name] = '\n'.join(lines)
(PKG / 'Becoming.lean').write_text(root, encoding='utf-8')
(PKG / 'check_becoming.py').write_text(chk, encoding='utf-8')
for name, text in readmes.items():
    (PKG / name).write_text(text, encoding='utf-8')
print('integrated', len(MODULES))
