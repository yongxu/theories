#!/usr/bin/env python3
"""OU5: join Becoming.GrammarTesting (import after Becoming.GrammarMap, root doc bullet before Prelude's, CORE entry
after GrammarMap's, scope text, README rows after GrammarMap's). usage: OU_ROOT=<checkout> python3 -B integrate5.py"""
import os
import shutil
from pathlib import Path
HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['OU_ROOT']).resolve()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def kit(name):
    return (HERE / name).read_text(encoding='utf-8')


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'GrammarTesting.lean', PKG / 'Becoming' / 'GrammarTesting.lean')
root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
root = once(root, 'import Becoming.GrammarMap\n', 'import Becoming.GrammarMap\nimport Becoming.GrammarTesting\n')
start = root.index('* `Becoming.Prelude` (L0)')
root = root[:start] + kit('doc_bullet.txt') + root[start:]
chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
chk = once(chk, '"Becoming.GrammarMap", ', '"Becoming.GrammarMap", "Becoming.GrammarTesting", ')
chk = once(chk, '    "GrammarMap: at a fine', kit('scope.txt') + '    "GrammarMap: at a fine')
for name, row in (('README.md', kit('readme_row.txt').rstrip('\n')), ('README.zh.md', kit('readme_row_zh.txt').rstrip('\n'))):
    lines = (PKG / name).read_text(encoding='utf-8').split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith('| L0 | [`Becoming.GrammarMap`]')]
    assert len(idx) == 1, (name, idx)
    lines[idx[0] + 1:idx[0] + 1] = [row]
    (PKG / name).write_text('\n'.join(lines), encoding='utf-8')
(PKG / 'Becoming.lean').write_text(root, encoding='utf-8')
(PKG / 'check_becoming.py').write_text(chk, encoding='utf-8')
print('integrated GrammarTesting')
