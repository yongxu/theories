#!/usr/bin/env python3
"""Join EV12 to the core package: copy SelectionLevels in, extend the root doc, the checker scope and the README rows
(EN, ZH).
usage: python3 -B integrate.py   (from the checkout root; each edit must match exactly once)"""
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


sl = PKG / 'Becoming' / 'SelectionLevels.lean'
assert 'rises_iff_returns' not in sl.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'SelectionLevels.lean', sl)
edits = {
    'Becoming.lean': [(
        '  amount. Witnesses: two groups of two with one member holding back, the whole going either way.\n',
        '  amount. Returns to groupmates: where each unit a member keeps gives b to every member of its\n'
        '  group and takes c from the keeper, selection within goes against keeping, among groups for it\n'
        '  exactly where b + c falls short of m times b, and the whole selects for it exactly where b + c\n'
        '  times the spread falls short of m times b times the spread among groups (Hamilton\'s rule with\n'
        '  the assortment the share of the spread among groups). Witnesses: two groups of two with one\n'
        '  member holding back, the whole going either way; the same returns either way by how the groups\n'
        '  are founded; assortment below one losing where assortment one would win.\n')],
    'check_becoming.py': [(
        '''    "lineages' means select for the amount; witnesses where the whole goes either way. "\n''',
        '''    "lineages' means select for the amount; where each member's offspring number with k per unit "\n'''
        '''    "of its own amount is a base with b per unit of a reading, the selection term is b times the "\n'''
        '''    "reading's covariation with the amount less k times its spread; with returns to groupmates in "\n'''
        '''    "groups of m, selection within goes against keeping by b + c times the groups' spreads, among "\n'''
        '''    "groups for it exactly where b + c falls short of m b, and the whole selects for it exactly where "\n'''
        '''    "b + c times the spread falls short of m b times the spread among groups; witnesses where the "\n'''
        '''    "whole goes either way, by the counts and by how the groups are founded. "\n''')],
    'README.md': [(
        '`SelectionLevels.rises_iff_lineages`, from `SelectionLevels.rises_iff_means_of_uniform`) |',
        '`SelectionLevels.rises_iff_lineages`, from `SelectionLevels.rises_iff_means_of_uniform`); returns to groupmates '
        '(each unit kept giving b to every member of its group and taking c from the keeper): selection within goes against '
        'keeping (`SelectionLevels.within_returns`), among groups for it exactly where b + c falls short of m b '
        '(`SelectionLevels.among_for_iff`), and the whole selects for it exactly where b + c times the spread falls short of '
        'm b times the spread among groups (`SelectionLevels.rises_iff_returns`, from `SelectionLevels.returns_balance`), '
        'Hamilton\'s rule with the assortment the share of the spread among groups; the same returns either way by how the '
        'groups are founded (`SelectionLevels.Founding.either_verdict`, `SelectionLevels.Partly.below_one`) |')],
    'README.zh.md': [(
        '（`SelectionLevels.rises_iff_lineages`，由 `SelectionLevels.rises_iff_means_of_uniform`） |',
        '（`SelectionLevels.rises_iff_lineages`，由 `SelectionLevels.rises_iff_means_of_uniform`）；组员间的回报'
        '（每保留一单位给其组每个成员 b、从保留者取走 c）：组内选择不利于保留（`SelectionLevels.within_returns`），'
        '组间恰在 b + c 小于 m b 时有利于它（`SelectionLevels.among_for_iff`），整体恰在 b + c 乘离散小于 m b 乘组间离散时选择它'
        '（`SelectionLevels.rises_iff_returns`，由 `SelectionLevels.returns_balance`），即以组间离散所占份额为同类聚合的 Hamilton 规则；'
        '同样的回报按组如何建立而得出两种判定（`SelectionLevels.Founding.either_verdict`、`SelectionLevels.Partly.below_one`） |')],
}
for name, pairs in edits.items():
    p = PKG / name
    t = p.read_text()
    for old, new in pairs:
        t = once(t, old, new)
    p.write_text(t)
print('integrated')
