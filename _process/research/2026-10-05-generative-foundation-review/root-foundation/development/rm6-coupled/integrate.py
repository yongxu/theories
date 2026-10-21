#!/usr/bin/env python3
"""Join RM6's core laws to the package: copy the extended Becoming.RegimeMargin in, extend its root doc bullet, its
scope text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (RM6_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM6_ROOT']).resolve() if os.environ.get('RM6_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'RegimeMargin.lean'
assert 'namespace Coupled' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', target)

RM_DOC_OLD = ("  and the rests are the regime's point or below the draw with level and recent giving equal; whole\n"
              "  numbers are an instance.\n")
RM_DOC_NEW = (RM_DOC_OLD +
              '  Two conditions under draws, each giving from what is left of both: under mutual support the\n'
              '  coupled step keeps the order of states, so a condition ending from a state ends from every state\n'
              '  below it; within a band in whole numbers a run comes to rest and each condition\'s point of no\n'
              '  return is a least level that falls as its partner\'s level rises; a condition giving nothing\n'
              '  where nothing is left of its partner drains by its draw once its partner has nothing left.\n'
              '  Inhibition breaks the order of fates, and outside a band mutual support can hold a pair neither\n'
              '  of which holds alone in a cycle that never rests.\n')
RM_SCOPE_OLD = '    "numbers are an instance. "\n    "Regulation: '
RM_SCOPE_NEW = ('    "numbers are an instance. Two conditions under draws H1 and H2, each giving from what is left of "\n'
                '    "both (Coupled): under mutual support the coupled step keeps the order of states and a condition "\n'
                '    "ending from a state ends from every state below it; within a band, mutual support gives within "\n'
                '    "each draw and in whole numbers a run is still from some step at most 2 hi + 1, the first "\n'
                '    "condition ends exactly below a threshold in its partner\'s level, and the threshold does not "\n'
                '    "rise as the partner rises; a condition giving nothing where nothing is left of its partner "\n'
                '    "falls by its draw once its partner stays within its draw, and under dependence both ways the "\n'
                '    "two end together; mutual inhibition within a band of two breaks the order of fates, and "\n'
                '    "outside a band a pair each of which ends alone moves between (2, 3) and (3, 2) for ever. "\n'
                '    "Regulation: ')
RM_README_OLD = 'whole numbers are an instance (`Drawn.whole_run`) |'
RM_README_NEW = ('whole numbers are an instance (`Drawn.whole_run`); two conditions under draws, each giving from what is '
                 'left of both (`Coupled.step`): under mutual support the coupled step keeps the order of states '
                 '(`Coupled.step_mono`) and a condition ending from a state ends from every state below it '
                 '(`Coupled.ends_of_below`); within a band in whole numbers a run comes to rest (`Coupled.comes_to_rest`), '
                 'the first condition ends exactly below a threshold in its partner\'s level (`Coupled.ends_iff_below`), '
                 'which does not rise as the partner rises (`Coupled.threshold_falls`); a dependent condition drains by '
                 'its draw once its partner has nothing left (`Coupled.drains`, `Coupled.ends_after`), and under '
                 'dependence both ways the two end together (`Coupled.ends_together`); support can save a condition '
                 '(`Coupled.MutualActivation.saves`), inhibition breaks the order of fates '
                 '(`Coupled.MutualInhibition.breaks_order`), and outside a band mutual support can hold a pair neither '
                 'of which holds alone in a cycle that never rests (`Coupled.Relay.cycles`) |')
RM_README_ZH_OLD = '整数是其实例（`Drawn.whole_run`） |'
RM_README_ZH_NEW = ('整数是其实例（`Drawn.whole_run`）；两个条件各在其汲取之下，各从两者所余中给出（`Coupled.step`）：在相互支持下，'
                    '耦合之步保持状态之序（`Coupled.step_mono`），自一状态终结的条件自其下每一状态终结（`Coupled.ends_of_below`）；'
                    '在整数的带内，运行归于静止（`Coupled.comes_to_rest`），第一个条件恰在其伙伴水平所定的阈值之下终结'
                    '（`Coupled.ends_iff_below`），伙伴升高时阈值不升（`Coupled.threshold_falls`）；依赖的条件在伙伴一无所余后按其汲取'
                    '流尽（`Coupled.drains`、`Coupled.ends_after`），双向依赖时两者同终（`Coupled.ends_together`）；支持可以挽救一个条件'
                    '（`Coupled.MutualActivation.saves`），抑制打破命运之序（`Coupled.MutualInhibition.breaks_order`），带外的相互支持'
                    '可以在永不静止的循环中维持两个单独都不能维持的条件（`Coupled.Relay.cycles`） |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, RM_DOC_OLD, RM_DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, RM_SCOPE_OLD, RM_SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, RM_README_OLD, RM_README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, RM_README_ZH_OLD, RM_README_ZH_NEW))
print('integrated')
