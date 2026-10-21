#!/usr/bin/env python3
"""Join RM8's laws to the core package: copy the extended Becoming.RegimeMargin in, extend its root doc entry, its
scope text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (RM8_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM8_ROOT']).resolve() if os.environ.get('RM8_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'RegimeMargin.lean'
assert 'theorem leftOver_bound' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', target)

DOC_OLD = ('  case: along every chain of dependence, with positive draws, the end of one ends everything\n'
           '  downstream of it, and a dependence cycle ends together.\n')
DOC_NEW = (DOC_OLD +
           '  Stated condition by condition, rest needs no equality of functions, so for finitely many\n'
           '  conditions within a band under mutual support a run comes to rest within the conditions\'\n'
           '  count times the band with one step, and each condition\'s point of no return, given the\n'
           '  other levels, is a least level that does not rise as any other rises; the pair\'s rest and\n'
           '  thresholds are these laws read for two.\n')
SCOPE_OLD = '    "draw on the chain stops it. "\n'
SCOPE_NEW = ('    "draw on the chain stops it; in whole numbers, for finitely many conditions listed by a list "\n'
             '    "covering them, under mutual support and a band up to hi, stated condition by condition, "\n'
             '    "each gives within its draw, what the draws leave never rises, the run is still from some "\n'
             '    "step at most the conditions\' count times hi with one, whether a condition ends is decided "\n'
             '    "there, each condition\'s point of no return given the other levels is a least level up to "\n'
             '    "hi + 1, exact, every state having its fate by it, and it does not rise as any other level "\n'
             '    "rises; the pair\'s rest and thresholds are these read for two. "\n')
README_OLD = 'and a zero draw on the chain stops it (`Coupled.Indexed.Chain.stopped`) |'
README_NEW = ('and a zero draw on the chain stops it (`Coupled.Indexed.Chain.stopped`); for finitely many conditions '
              'within a band, stated condition by condition, a run comes to rest within the conditions\' count times '
              'the band with one step (`Coupled.Indexed.comes_to_rest`), and each condition\'s point of no return, given '
              'the other levels, is exact (`Coupled.Indexed.ends_iff_below`) and does not rise as any other level rises '
              '(`Coupled.Indexed.threshold_falls`), the pair\'s laws its case (`Coupled.threshold_pair`) |')
README_ZH_OLD = '链上为零的汲取使其停止（`Coupled.Indexed.Chain.stopped`） |'
README_ZH_NEW = ('链上为零的汲取使其停止（`Coupled.Indexed.Chain.stopped`）；有限多个条件在一个带内、逐条件陈述时，运行在条件数乘带宽再加一步之内静止'
                 '（`Coupled.Indexed.comes_to_rest`），每个条件在其他水平给定时的不可回返点是精确的（`Coupled.Indexed.ends_iff_below`），'
                 '且不随任何其他水平上升而上升（`Coupled.Indexed.threshold_falls`），一对的律是其情形（`Coupled.threshold_pair`） |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
