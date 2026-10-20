#!/usr/bin/env python3
"""Join SG3's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG3_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG3_ROOT']).resolve() if os.environ.get('SG3_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'mutual_beyond' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = ('  Witnesses on `Diversion`: the drive, no room, a satisficing order, keeping, a taker of\n'
           '  capacity `k` whose optimum breaks the dweller exactly where `0 < k`.\n')
DOC_NEW = ('  Several optimizers at a mutual best response, each alone by its own order rising with its own\n'
           '  family, leave a condition beyond every family at what the formations outside them leave less\n'
           '  their joint capacity, or at nothing, as one part made of all of them would; where something\n'
           '  stands each takes its whole capacity there, so restraint is no mutual best response.\n'
           '  Witnesses on `Diversion`: the drive, no room, a satisficing order, keeping, a taker of\n'
           '  capacity `k` whose optimum breaks the dweller exactly where `0 < k`; two takers each within\n'
           '  the slack of a need of one leave nothing at their mutual best response.\n')
SCOPE_OLD = ('    "store\'s optimum, and the dweller\'s dependence breaks exactly where k is positive. "\n')
SCOPE_NEW = ('    "store\'s optimum, and the dweller\'s dependence breaks exactly where k is positive; several "\n'
             '    "formations each optimizing alone, by its own order rising with its own family, at a mutual best "\n'
             '    "response, each step an optimum among the outcomes open to it with the others exchanging as they "\n'
             '    "do, leave a condition beyond every family at the level before with what the formations outside "\n'
             '    "every optimizer give, less what they take and less the optimizers\' joint capacity, or at "\n'
             '    "nothing; where something stands there each optimizer takes its whole capacity and gives nothing, "\n'
             '    "the optimizers leave it where every optimum of one part made of all of them would, it is lowered "\n'
             '    "exactly where they have capacity and something is left, and on a web a dependence on it breaks "\n'
             '    "exactly where its need exceeds that level; TwoTakers: two takers of capacity one at a source of "\n'
             '    "two leave nothing at their mutual best response, and one taker\'s restraint is none. "\n')
README_OLD = ('`Optimum.Drain.kept_takes_slack`, `Optimum.Drain.drawing_broken_iff` |')
README_NEW = ('`Optimum.Drain.kept_takes_slack`, `Optimum.Drain.drawing_broken_iff`; several optimizers at a mutual best response '
              '(`Optimum.MutualBest`), each alone by its own order rising with its own family, leave a condition beyond every '
              'family at what the formations outside them leave less their joint capacity (`Optimum.mutual_beyond`), each '
              'taking its whole capacity where something stands (`Optimum.MutualBest.full`), as one part made of all of them '
              'would (`Optimum.mutual_as_one`), lowered exactly where they have capacity (`Optimum.mutual_lowers_iff`), a '
              'dependence there breaking exactly where its need exceeds that (`Web.mutual_broken_iff_capacity`); witnesses '
              '`Optimum.TwoTakers.joint_drains`, `Optimum.TwoTakers.restrained_not_mutual` |')
README_ZH_OLD = '见证 `Optimum.Drain.drawing_broken_iff` |'
README_ZH_NEW = ('见证 `Optimum.Drain.drawing_broken_iff`；多个优化者处于相互最优回应（`Optimum.MutualBest`），各自按随其族升高的序'
                 '独自优化时，把每个族之外的条件留在其外的构成所留减去它们的合计容量处（`Optimum.mutual_beyond`），有所存处各取'
                 '其全部容量（`Optimum.MutualBest.full`），与由它们全体组成的一个部分相同（`Optimum.mutual_as_one`），恰在它们'
                 '有容量处被降低（`Optimum.mutual_lowers_iff`），那里的依存恰在其所需超过此处时被打断'
                 '（`Web.mutual_broken_iff_capacity`）；见证 `Optimum.TwoTakers.joint_drains`、'
                 '`Optimum.TwoTakers.restrained_not_mutual` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
