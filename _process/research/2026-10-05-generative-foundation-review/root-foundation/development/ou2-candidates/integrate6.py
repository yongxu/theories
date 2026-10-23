#!/usr/bin/env python3
"""OU2c: join Becoming.GrammarCandidates (import after Becoming.GrammarTesting, root doc bullet before Prelude's, CORE
entry after GrammarTesting's, scope text, README rows after GrammarTesting's). usage: OU_ROOT=<checkout> python3 -B integrate6.py"""
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


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'GrammarCandidates.lean', PKG / 'Becoming' / 'GrammarCandidates.lean')
root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
root = once(root, 'import Becoming.GrammarTesting\n', 'import Becoming.GrammarTesting\nimport Becoming.GrammarCandidates\n')
start = root.index('* `Becoming.Prelude` (L0)')
root = root[:start] + kit('doc_bullet.txt') + root[start:]
chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
chk = once(chk, '"Becoming.GrammarTesting", ', '"Becoming.GrammarTesting", "Becoming.GrammarCandidates", ')
chk = once(chk, '    "GrammarTesting: the core', kit('scope.txt') + '    "GrammarTesting: the core')
for name, row in (('README.md', kit('readme_row.txt').rstrip('\n')), ('README.zh.md', kit('readme_row_zh.txt').rstrip('\n'))):
    lines = (PKG / name).read_text(encoding='utf-8').split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith('| L0 | [`Becoming.GrammarTesting`]')]
    assert len(idx) == 1, (name, idx)
    lines[idx[0] + 1:idx[0] + 1] = [row]
    (PKG / name).write_text('\n'.join(lines), encoding='utf-8')
(PKG / 'Becoming.lean').write_text(root, encoding='utf-8')
(PKG / 'check_becoming.py').write_text(chk, encoding='utf-8')
print('integrated GrammarCandidates')
