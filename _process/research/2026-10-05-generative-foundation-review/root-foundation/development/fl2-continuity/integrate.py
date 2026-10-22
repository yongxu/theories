#!/usr/bin/env python3
"""Join FL2's module Becoming.Continuity to the core package: copy it in, import it after Becoming.Imbalance, add its
root doc bullet after Imbalance's, its CORE entry and scope text in check_becoming.py, and its README rows (EN and ZH
after Imbalance's).
usage: python3 -B integrate.py   (FL2_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['FL2_ROOT']).resolve() if os.environ.get('FL2_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Continuity.lean', PKG / 'Becoming' / 'Continuity.lean')

DOC = (
    '* `Becoming.Continuity` (L1): balance from conservation along a relation. Over finitely many\n'
    '  relata, with the relation a computable test and equality of relata decided, transfers that\n'
    '  move only between adjacent relata and balance a step exist exactly where the total is\n'
    '  conserved on every family the relation closes (`Continuity.balancing_iff`); the transfers\n'
    '  are computed one relatum at a time (`Continuity.route`). A law whose next level at a\n'
    '  relatum reads only it and the relata adjacent to it, conserving the total from every\n'
    '  configuration, conserves it on every closed family (`Continuity.conservedOn_of_law`), so\n'
    '  every run of it balances along the relation (`Continuity.balancesOn_of_law`). Swapping two\n'
    '  levels conserves the total and balances along the full relation, not along the empty one\n'
    '  (`Continuity.Teleport`). The transfers depend on the whole configuration: a local flux is\n'
    '  known for cellular automata on lattices (Hattori and Takesue 1991; Pivato 2002), not shown\n'
    '  here. A leaf: nothing builds on the transfers yet.\n'
)
SCOPE = (
    '    "Continuity: over relata listed without repetition, transfers moving only between relata "\n'
    '    "adjacent under a Bool relation balance a step exactly where the total is conserved on every "\n'
    '    "family the relation closes, the transfers routed one relatum at a time; a law reading only a "\n'
    '    "relatum and those adjacent to it and conserving the total from every configuration conserves "\n'
    '    "it on every closed family, so its runs balance along the relation; swapping two levels "\n'
    '    "balances along the full relation and not along the empty one. "\n')
README_ROW = (
    '| L1 | [`Becoming.Continuity`](Becoming/Continuity.lean) | balance from conservation along a relation: over '
    'finitely many relata, transfers between adjacent relata balancing a step exist exactly where the total is '
    'conserved on every family the relation closes (`Continuity.balancing_iff`, the transfers computed by '
    '`Continuity.route`); a law reading only adjacent relata and conserving the total conserves it on every closed '
    'family (`Continuity.conservedOn_of_law`) and its runs balance (`Continuity.balancesOn_of_law`); a swap of two '
    'levels balances along the full relation and not along the empty one (`Continuity.Teleport`) |')
README_ZH_ROW = (
    '| L1 | [`Becoming.Continuity`](Becoming/Continuity.lean) | 沿关系的守恒给出平衡：在有限多个关系项上，只在相邻关系项之间移动、'
    '使一步平衡的转移，恰在总量于关系封闭的每个家族上守恒时存在（`Continuity.balancing_iff`，转移由 `Continuity.route` 计算）；'
    '只读相邻关系项、从每个配置守恒总量的规律，在每个封闭家族上守恒（`Continuity.conservedOn_of_law`），其运行平衡'
    '（`Continuity.balancesOn_of_law`）；交换两个水平沿完全关系平衡，沿空关系不平衡（`Continuity.Teleport`） |')

root = (PKG / 'Becoming.lean').read_text()
assert 'import Becoming.Continuity' not in root, 'already integrated'
root = once(root, 'import Becoming.Imbalance\n', 'import Becoming.Imbalance\nimport Becoming.Continuity\n')
start = root.index('* `Becoming.Imbalance` (L1)')
nxt = root.index('\n* `Becoming.', start) + 1
root = root[:nxt] + DOC + root[nxt:]

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '"Becoming.Units", "Becoming.Imbalance"', '"Becoming.Units", "Becoming.Imbalance", "Becoming.Continuity"')
chk = once(chk, '    "Loops: the amount carried by routes of at most j responses rises with j to the carried "\n',
           SCOPE + '    "Loops: the amount carried by routes of at most j responses rises with j to the carried "\n')

readmes = {}
for name, row in (('README.md', README_ROW), ('README.zh.md', README_ZH_ROW)):
    lines = (PKG / name).read_text().split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.Imbalance`](Becoming/Imbalance.lean) |')]
    assert len(idx) == 1, (name, idx)
    lines[idx[0] + 1:idx[0] + 1] = [row]
    readmes[name] = '\n'.join(lines)
(PKG / 'Becoming.lean').write_text(root)
(PKG / 'check_becoming.py').write_text(chk)
for name, text in readmes.items():
    (PKG / name).write_text(text)
print('integrated')
