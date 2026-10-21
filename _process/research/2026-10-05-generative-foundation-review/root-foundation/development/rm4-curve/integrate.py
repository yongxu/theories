#!/usr/bin/env python3
"""Join RM4's laws to the core package: copy the extended Becoming.LastChange and Becoming.RegimeMargin in, extend their
root doc bullets, their scope text in check_becoming.py and their README rows (EN; ZH for RegimeMargin, the ZH README
having no LastChange row).
usage: python3 -B integrate.py   (RM4_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM4_ROOT']).resolve() if os.environ.get('RM4_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


for name, marker in [('LastChange', 'still_same'), ('RegimeMargin', 'threshold_regime')]:
    target = PKG / 'Becoming' / f'{name}.lean'
    assert marker not in target.read_text(), 'already integrated'
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{name}.lean', target)

LC_DOC_OLD = '  run is still from some step at most `d`, with no omniscience.\n'
LC_DOC_NEW = LC_DOC_OLD + '  A run still from two steps is at one configuration at both: a run has at most one rest.\n'
RM_DOC_OLD = '  resting short of the draw shows the rest below it.\n'
RM_DOC_NEW = (RM_DOC_OLD +
              '  Where the adjustment rises in both and keeps a band, a state at or below one whose run rests\n'
              '  below the draw rests below it too, decided at a fixed step, so for each recent giving a least\n'
              '  level separates the runs that rest below the draw from those that rest at the regime\'s point,\n'
              '  exactly, and it does not rise as the recent giving rises: the point of no return is a falling\n'
              '  curve in the plane of level and recent giving, the regime\'s point of no return at every recent\n'
              '  giving under the regime\'s step. A giving that falls from one level to the next shows that\n'
              '  rising giving is needed.\n')
LC_SCOPE_OLD = '    "at most d above its start is still from some step at most d, with no omniscience. "\n'
LC_SCOPE_NEW = ('    "at most d above its start is still from some step at most d, with no omniscience; a run still "\n'
                '    "from two steps is at one configuration at both. "\n')
RM_SCOPE_OLD = '    "one at every step; A = 1 rests at one with recent giving one under a draw of two. "\n'
RM_SCOPE_NEW = ('    "one at every step; A = 1 rests at one with recent giving one under a draw of two; where A "\n'
                '    "rises in both and keeps a band up to hi, a state below one whose run rests below H rests below "\n'
                '    "it too, decided at step 3 hi + 3, so for each recent giving r up to hi the runs from levels up "\n'
                '    "to hi rest below H exactly below threshold r, which does not rise with r; below it a run rests "\n'
                '    "on the line where level and recent giving are equal, from it on at H with a level the regime\'s "\n'
                '    "step leaves; under the regime\'s step threshold r = H + y; Notch: giving two from one and "\n'
                '    "nothing elsewhere, under a draw of two, rests from four at nothing and from three at three. "\n')
LC_README_OLD = 'with no omniscience (`LastChange.still_within`) ([the-last-change-of-a-run]'
LC_README_NEW = ('with no omniscience (`LastChange.still_within`), and a run still from two steps is at one '
                 'configuration at both (`LastChange.still_stays`, `LastChange.still_same`) ([the-last-change-of-a-run]')
RM_README_OLD = 'and the rest below the draw occurs (`Adjusted.rests_short`) |'
RM_README_NEW = ('and the rest below the draw occurs (`Adjusted.rests_short`); where the adjustment rises in both and keeps '
                 'a band, a state at or below one whose run rests below the draw rests below it too '
                 '(`Adjusted.falls_of_below`), decided at step `3 hi + 3` (`Adjusted.falls_iff`), so for each recent '
                 'giving the runs rest below the draw exactly from levels below `Adjusted.threshold` '
                 '(`Adjusted.falls_iff_below`, through `leading`), which does not rise as the recent giving rises '
                 '(`Adjusted.threshold_falls`); below it a run rests below the draw with level and recent giving equal, '
                 'from it on at the draw with a level the regime\'s step leaves as it is (`Adjusted.fates`); under the '
                 'regime\'s step the threshold is `H + y` (`threshold_regime`), and without rising giving there is no '
                 'threshold (`Notch.no_threshold`) |')
RM_README_ZH_OLD = '汲取之下的静止确会发生（`Adjusted.rests_short`） |'
RM_README_ZH_NEW = ('汲取之下的静止确会发生（`Adjusted.rests_short`）；调整在两个变元上皆升且有带时，低于一个静于汲取之下的状态者亦静于汲取之下'
                    '（`Adjusted.falls_of_below`），在第 `3 hi + 3` 步可判定（`Adjusted.falls_iff`），故对每个近来所给，运行恰在水平低于'
                    ' `Adjusted.threshold` 时静于汲取之下（`Adjusted.falls_iff_below`，经 `leading`），且此阈值不随近来所给上升而升'
                    '（`Adjusted.threshold_falls`）；阈值之下运行静于汲取之下且水平与近来所给相等，阈值及其上静于汲取且水平为体制之步所不动'
                    '（`Adjusted.fates`）；体制之步下阈值为 `H + y`（`threshold_regime`），所给不上升时无阈值（`Notch.no_threshold`） |')

root = (PKG / 'Becoming.lean').read_text()
root = once(root, LC_DOC_OLD, LC_DOC_NEW)
(PKG / 'Becoming.lean').write_text(once(root, RM_DOC_OLD, RM_DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, LC_SCOPE_OLD, LC_SCOPE_NEW)
(PKG / 'check_becoming.py').write_text(once(chk, RM_SCOPE_OLD, RM_SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
rd = once(rd, LC_README_OLD, LC_README_NEW)
(PKG / 'README.md').write_text(once(rd, RM_README_OLD, RM_README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, RM_README_ZH_OLD, RM_README_ZH_NEW))
print('integrated')
