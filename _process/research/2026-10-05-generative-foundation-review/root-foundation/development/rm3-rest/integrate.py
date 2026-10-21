#!/usr/bin/env python3
"""Join RM3's laws to the core package: copy the extended Becoming.LastChange and Becoming.RegimeMargin in, extend their
root doc bullets, their scope text in check_becoming.py and their README rows (EN; ZH for RegimeMargin, the ZH README
having no LastChange row).
usage: python3 -B integrate.py   (RM3_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM3_ROOT']).resolve() if os.environ.get('RM3_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


for name, marker in [('LastChange', 'section LawRuns'), ('RegimeMargin', 'rises_to_rest')]:
    target = PKG / 'Becoming' / f'{name}.lean'
    assert marker not in target.read_text(), 'already integrated'
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{name}.lean', target)

LC_DOC_OLD = '  enough is every reachable stay meeting the target and no reachable change undoable.\n'
LC_DOC_NEW = (LC_DOC_OLD +
              '  A law\'s run is fixed by its law, so whether it changes at a step is decided: where a quantity\n'
              '  never falls along it, rises at every change and stays at most `d` above where it started, the\n'
              '  run is still from some step at most `d`, with no omniscience.\n')
RM_DOC_OLD = '  the regime\'s crosses the point both ways.\n'
RM_DOC_NEW = (RM_DOC_OLD +
              '  Where giving rises with what is left, a run of the regime\'s step moves one way only, and within\n'
              '  a band up to a top it is still from some step at most the top. Where the adjustment rises with\n'
              '  what is left and with the recent giving, a step that neither raises nor lowers both the level\n'
              '  and the recent giving brings the recent giving toward the draw, so such steps run out, and from\n'
              '  the first step that does, the run moves one way only: every run within a band up to a top is\n'
              '  still within three times the top and three steps, at the draw with a level the regime\'s step\n'
              '  leaves as it is, or below the draw with level and recent giving equal. A giving that falls as\n'
              '  what is left rises, and a run with no band, show both premises are needed; a constant giving\n'
              '  resting short of the draw shows the rest below it.\n')
LC_SCOPE_OLD = '    "undoable. "\n'
LC_SCOPE_NEW = ('    "undoable; a law\'s run with a quantity that never falls along it, rises at every change and stays "\n'
                '    "at most d above its start is still from some step at most d, with no omniscience. "\n')
RM_SCOPE_OLD = '    "where the regime\'s step ends the condition from four and holds it from five. "\n'
RM_SCOPE_NEW = ('    "where the regime\'s step ends the condition from four and holds it from five; where g rises, a "\n'
                '    "run of the regime\'s step within a band up to hi is still from some step at most hi, and where "\n'
                '    "A rises in both arguments and the step keeps every state up to hi at a level up to hi, every run "\n'
                '    "from such a state is still from some step at most 3 hi + 3, at recent giving H with a level the "\n'
                '    "regime\'s step leaves, or below H with level and recent giving equal and A 0 fixing them, since "\n'
                '    "a step raising neither or lowering neither both brings the recent giving toward H; Alternation: "\n'
                '    "g 0 = 2 and nothing from more keeps levels up to two under a draw of one yet its run from one "\n'
                '    "alternates between one and two; under the gated giving with no band the run from five rises by "\n'
                '    "one at every step; A = 1 rests at one with recent giving one under a draw of two. "\n')
LC_README_OLD = ' ([the-last-change-of-a-run](../../../../../../theories/becoming/results/records/the-last-change-of-a-run.md)). |'
LC_README_NEW = ('; a law\'s run is fixed by its law, so whether it changes at a step is decided, and where a quantity '
                 'never falls along it, rises at every change and stays at most `d` above where it started, the run is '
                 'still from some step at most `d`, with no omniscience (`LastChange.still_within`)' + LC_README_OLD)
RM_README_OLD = 'both ways (`Crossing.crosses`) |'
RM_README_NEW = ('both ways (`Crossing.crosses`); where giving rises with what is left, the regime\'s step keeps the order '
                 'of levels (`step_mono`) and a run within a band up to `hi` is still from some step at most `hi` '
                 '(`rests_within`, through `LastChange.still_within`); where the adjustment rises with what is left and '
                 'with the recent giving (`Adjusted.Rises`), a run whose first step lowers, or raises, neither its level '
                 'nor its recent giving never does (`Adjusted.run_rises`, `Adjusted.run_falls`), a step that does neither '
                 'lowers a count bounded by the recent giving\'s distance from the draw (`Adjusted.unordered_falls`), and '
                 'so, where the step keeps every state up to `hi` at a level up to `hi` (`Adjusted.Band`), every run from '
                 'such a state is still from some step at most `3 hi + 3`, at the draw with a level the regime\'s step '
                 'leaves as it is or below the draw with level and recent giving equal (`Adjusted.comes_to_rest`, '
                 '`Adjusted.fixed_iff`); neither rising giving nor the band can be dropped (`Alternation.alternates`, '
                 '`Crossing.rises_without_rest`), and the rest below the draw occurs (`Adjusted.rests_short`) |')
RM_README_ZH_OLD = '两向皆被越过（`Crossing.crosses`） |'
RM_README_ZH_NEW = ('两向皆被越过（`Crossing.crosses`）；所给随所剩而升时，体制之步保持水平之序（`step_mono`），'
                    '带内至 `hi` 的运行至多在第 `hi` 步起静止（`rests_within`，经 `LastChange.still_within`）；'
                    '调整随所剩与近来所给而升时（`Adjusted.Rises`），首步不降（或不升）水平与近来所给的运行永不降（或不升）'
                    '（`Adjusted.run_rises`、`Adjusted.run_falls`），二者不同升也不同降的一步使一个以近来所给与汲取之距为界的计数下降'
                    '（`Adjusted.unordered_falls`），故步把至 `hi` 的每个状态保持在至 `hi` 的水平时（`Adjusted.Band`），'
                    '自此种状态的每个运行至多在第 `3 hi + 3` 步起静止，静于汲取且水平为体制之步所不动，或静于汲取之下且水平与近来所给相等'
                    '（`Adjusted.comes_to_rest`、`Adjusted.fixed_iff`）；所给上升与带皆不可少（`Alternation.alternates`、'
                    '`Crossing.rises_without_rest`），汲取之下的静止确会发生（`Adjusted.rests_short`） |')

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
