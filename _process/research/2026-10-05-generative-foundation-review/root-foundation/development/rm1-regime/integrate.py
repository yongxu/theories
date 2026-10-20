#!/usr/bin/env python3
"""Join RM1's module Becoming.RegimeMargin to the core package: copy it in, import it after Becoming.Regulation,
add its root doc bullet after Regulation's, its CORE entry and scope text in check_becoming.py, and its README rows
(EN and ZH, after Regulation's). A leaf on Law.orbit (Becoming.Recurrence); nothing below depends on it.
usage: python3 -B integrate.py   (RM1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM1_ROOT']).resolve() if os.environ.get('RM1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', PKG / 'Becoming' / 'RegimeMargin.lean')

DOC = (
    '* `Becoming.RegimeMargin` (L1): the margin of a regime, with giving read off the level under a\n'
    '  standing draw (`step g H x = (x - H) + g (x - H)`), stated on `Law.run`. Where giving falls short of\n'
    '  the draw below `y` and nothing gives from nothing, a level below `H + y` falls at every step and is\n'
    '  nothing after as many steps as it stood; where giving meets the draw from `y` up to a top the step\n'
    '  keeps, a level from `H + y` holds, so the point of no return is exact. Where giving stops below a\n'
    '  need, the point of no return lies at least the draw above it, and more exactly where giving at the\n'
    '  need falls short of the draw; a larger draw, giving no more, raises it by at least the difference, and\n'
    '  giving lowered by the regime raises it beyond what removal alone gives. Where giving under the joint\n'
    '  draw is subadditive above the need and no greater than under either draw, harms of two draws are\n'
    '  super-additive up to one unit, strictly so in\n'
    '  `Concave`; in `Peaked` each of two draws holds alone and together they end the condition. The time\n'
    '  to break lies between `b + H n ≤ x` and `x < b + (H - Y) n`.\n'
)
SCOPE = (
    '    "RegimeMargin: under a standing draw H with giving g read off what is left, a level below H + y, where "\n'
    '    "giving falls short of H below y and nothing gives from nothing, falls at every step while positive and "\n'
    '    "is nothing after as many steps as it stood; from H + y up to a top the step keeps, with giving meeting "\n'
    '    "H from y up to it, the level never falls below its start, so the condition ends exactly from below "\n'
    '    "H + y; with giving stopped below a need m, the least level meeting a positive draw is at least m, "\n'
    '    "above m exactly where giving at m falls short of the draw, and rises with the draw where giving does "\n'
    '    "not rise; giving lowered by the regime gives a least level no lower, higher exactly where the lowered "\n'
    '    "giving falls short at the old one; with joint giving subadditive above m and no greater than either "\n'
    '    "draw\'s, the rises of the least levels meeting H1, H2 and H1 + H2 satisfy a + b <= c + 1; "\n'
    '    "the level stays at or above b while b + H n <= x and, with giving at most Y <= H <= b, falls below b "\n'
    '    "within any n with x < b + (H - Y) n; witnesses Concave (strictly super-additive) and Peaked (each "\n'
    '    "draw holds alone, together they end the condition from every level). "\n')
README_ROW = (
    '| L1 | [`Becoming.RegimeMargin`](Becoming/RegimeMargin.lean) | the margin of a regime: giving read off the level '
    'under a standing draw, on `Law.run` (premises named in each law; whole-number amounts): below the point of no '
    'return the condition is gone within as many steps as it stood (`ends_below`, `stays_ended`), at or above it the '
    'level holds (`holds`), and the point is exact (`ends_iff_below`); the least level meeting a positive draw lies at '
    'or above the need (`root_above_need`), above it exactly where giving at the need falls short '
    '(`beyond_draw_iff`), and rises with the draw where giving does not rise (`rises_by_draw`); giving lowered by the '
    'regime raises the need (`lowered_raises`, `lowered_raises_strictly`); harms super-additive up to one unit where '
    'joint giving is subadditive above the need and no greater than either draw\'s (`harms_superadditive`); a draw beyond all giving ends the condition from every '
    'level (`ends_beyond_giving`); the time to break between `not_before` and `falls_within`; witnesses '
    '`Concave.roots`, `Peaked.each_holds`, `Peaked.together_ends` |')
README_ZH_ROW = (
    '| L1 | [`Becoming.RegimeMargin`](Becoming/RegimeMargin.lean) | 一个体制的余量：在常设的汲取下，所给读自水平，陈述于 '
    '`Law.run`（前提写在各条规律中；整数量）：在不可回返点之下，条件在其所立的步数之内归于无（`ends_below`、`stays_ended`），'
    '在其上水平得以维持（`holds`），此点是确切的（`ends_iff_below`）；满足正的汲取的最低水平不低于需求（`root_above_need`），'
    '恰在需求处的所给不足汲取时高于需求（`beyond_draw_iff`），在所给不升时随汲取升高（`rises_by_draw`）；体制降低所给即抬高需求'
    '（`lowered_raises`、`lowered_raises_strictly`）；联合汲取下的所给在需求之上次可加且不大于各自汲取下的所给时，'
    '损害在一单位之内超可加（`harms_superadditive`）；超出一切所给的汲取从每个水平终结条件（`ends_beyond_giving`）；'
    '破断的时间在 `not_before` 与 `falls_within` 之间；见证 `Concave.roots`、`Peaked.each_holds`、`Peaked.together_ends` |')

root = (PKG / 'Becoming.lean').read_text()
assert 'import Becoming.RegimeMargin' not in root, 'already integrated'
root = once(root, 'import Becoming.Regulation\n', 'import Becoming.Regulation\nimport Becoming.RegimeMargin\n')
root = once(root, '* `Becoming.Loops` (L1): how a carried difference grows', DOC + '* `Becoming.Loops` (L1): how a carried difference grows')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '"Becoming.Regulation", "Becoming.Loops"', '"Becoming.Regulation", "Becoming.RegimeMargin", "Becoming.Loops"')
chk = once(chk, '    "Regulation: with balance, the joint exchange is within the gap to m on both sides exactly "',
           SCOPE + '    "Regulation: with balance, the joint exchange is within the gap to m on both sides exactly "')
(PKG / 'check_becoming.py').write_text(chk)

# EN after Regulation's row; the ZH table has no Regulation row, so before Loops' row there.
for name, row, anchor, after in (
        ('README.md', README_ROW, '| L1 | [`Becoming.Regulation`](Becoming/Regulation.lean) |', True),
        ('README.zh.md', README_ZH_ROW, '| L1 | [`Becoming.Loops`](Becoming/Loops.lean) |', False)):
    rd = (PKG / name).read_text()
    lines = rd.split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith(anchor)]
    assert len(idx) == 1, (name, idx)
    at = idx[0] + 1 if after else idx[0]
    lines[at:at] = [row]
    (PKG / name).write_text('\n'.join(lines))
print('integrated')
