#!/usr/bin/env python3
"""Join OU1's module Becoming.Grammar to the core package: copy it in, import it first in the root
module, add its root doc bullet before Prelude's, put it first in CORE with its scope text in
check_becoming.py, and add its README rows (EN and ZH) before Prelude's.
The texts come from the kit's files doc_bullet.txt, scope.txt, readme_row.txt, readme_row_zh.txt.
usage: python3 -B integrate.py   (OU1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['OU1_ROOT']).resolve() if os.environ.get('OU1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def kit(name):
    return (HERE / name).read_text(encoding='utf-8')


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Grammar.lean', PKG / 'Becoming' / 'Grammar.lean')

root = (PKG / 'Becoming.lean').read_text(encoding='utf-8')
assert 'import Becoming.Grammar' not in root, 'already integrated'
first_import = root.index('import ')
root = root[:first_import] + 'import Becoming.Grammar\n' + root[first_import:]
start = root.index('* `Becoming.Prelude` (L0)')
root = root[:start] + kit('doc_bullet.txt') + root[start:]

chk = (PKG / 'check_becoming.py').read_text(encoding='utf-8')
chk = once(chk, 'CORE = ["Becoming.Prelude", ', 'CORE = ["Becoming.Grammar", "Becoming.Prelude", ')
chk = once(chk, 'SCOPE = (\n', 'SCOPE = (\n' + kit('scope.txt'))

readmes = {}
for name, row in (('README.md', kit('readme_row.txt').rstrip('\n')),
                  ('README.zh.md', kit('readme_row_zh.txt').rstrip('\n'))):
    lines = (PKG / name).read_text(encoding='utf-8').split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith('| L0 | [`Becoming.Prelude`](Becoming/Prelude.lean) |')]
    assert len(idx) == 1, (name, idx)
    lines[idx[0]:idx[0]] = [row]
    readmes[name] = '\n'.join(lines)
(PKG / 'Becoming.lean').write_text(root, encoding='utf-8')
(PKG / 'check_becoming.py').write_text(chk, encoding='utf-8')
for name, text in readmes.items():
    (PKG / name).write_text(text, encoding='utf-8')
print('integrated')
