#!/usr/bin/env python3
"""Join RM5's core laws to the package: copy the extended Becoming.RegimeMargin in, extend its root doc bullet, its
scope text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (RM5_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM5_ROOT']).resolve() if os.environ.get('RM5_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'RegimeMargin.lean'
assert 'structure Drawn' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', target)

RM_DOC_OLD = '  rising giving is needed.\n'
RM_DOC_NEW = (RM_DOC_OLD +
              '  In any linearly ordered amounts with a draw taken first the adjusted step keeps the order of\n'
              '  states, a step neither raising nor lowering both climbs or sinks toward the draw and the next\n'
              '  such step is of its kind, a step raising or lowering both is followed by such steps for ever,\n'
              '  and the rests are the regime\'s point or below the draw with level and recent giving equal; whole\n'
              '  numbers are an instance.\n')
RM_SCOPE_OLD = '    "nothing elsewhere, under a draw of two, rests from four at nothing and from three at three. "\n'
RM_SCOPE_NEW = ('    "nothing elsewhere, under a draw of two, rests from four at nothing and from three at three; in "\n'
                '    "any linearly ordered amounts with a draw (Drawn) a rising adjustment\'s step keeps the order of "\n'
                '    "states, from the first step a step neither raising nor lowering both climbs or sinks toward H "\n'
                '    "and the next such step is of its kind, ordered steps stay ordered, a run within a band stays "\n'
                '    "there, and the rests are H\'s point or below H with level and recent giving equal; whole "\n'
                '    "numbers are an instance. "\n')
RM_README_OLD = 'threshold (`Notch.no_threshold`) |'
RM_README_NEW = ('threshold (`Notch.no_threshold`); in any linearly ordered amounts with a draw (`Drawn`), the step of a '
                 'rising adjustment keeps the order of states (`Drawn.step_mono`), from the first step on a step neither '
                 'raising nor lowering both climbs or sinks toward the draw and the next such step is of its kind, while '
                 'a step raising or lowering both is followed by such steps for ever (`Drawn.run_shape`), a run within a '
                 'band stays there (`Drawn.run_within`), and the rests are the regime\'s point or below the draw with level '
                 'and recent giving equal (`Drawn.still_iff`); whole numbers are an instance (`Drawn.whole_run`) |')
RM_README_ZH_OLD = '所给不上升时无阈值（`Notch.no_threshold`） |'
RM_README_ZH_NEW = ('所给不上升时无阈值（`Notch.no_threshold`）；在任何带汲取的线性有序量中（`Drawn`），上升调整之步保持状态之序'
                    '（`Drawn.step_mono`），自首步起，既不同升也不同降的一步向汲取攀升或下沉，下一个这样的步同类，而同升或同降的一步之后'
                    '永远如此（`Drawn.run_shape`），带内的运行留在带内（`Drawn.run_within`），静止即体制之点或汲取之下水平与近来所给相等'
                    '（`Drawn.still_iff`）；整数是其实例（`Drawn.whole_run`） |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, RM_DOC_OLD, RM_DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, RM_SCOPE_OLD, RM_SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, RM_README_OLD, RM_README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, RM_README_ZH_OLD, RM_README_ZH_NEW))
print('integrated')
