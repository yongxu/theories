#!/usr/bin/env python3
"""Join SG2's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG2_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG2_ROOT']).resolve() if os.environ.get('SG2_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'optimum_beyond' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = ('  unit; restricted to outcomes keeping each dependence, the optimum takes exactly the slack.\n'
           '  Witnesses on `Diversion`: the drive, no room, a satisficing order, keeping.\n')
DOC_NEW = ('  unit; restricted to outcomes keeping each dependence, the optimum takes exactly the slack.\n'
           '  Read off one step of exchange, where a part\'s members take at most their capacity, give only\n'
           '  to the family and gain nothing on it, the rest exchanging as it does, there is room above any\n'
           '  floors, and every optimum stands at each condition beyond at what the rest leaves less the\n'
           '  part\'s capacity there, or at its floor: no drive where no member may take, the drain exactly\n'
           '  where one may and something stands, and on a web a dependence beyond broken exactly where its\n'
           '  need exceeds what the rest leaves less the capacity.\n'
           '  Witnesses on `Diversion`: the drive, no room, a satisficing order, keeping, a taker of\n'
           '  capacity `k` whose optimum breaks the dweller exactly where `0 < k`.\n')
SCOPE_OLD = ('    "among its optima, and the keeping optimum takes the slack. "\n')
SCOPE_NEW = ('    "among its optima, and the keeping optimum takes the slack; read off one step of exchange, the "\n'
             '    "outcomes open to a part are the levels after every balanced step in which the rest exchanges "\n'
             '    "as it does and each member takes from each condition at most its capacity, gives only to a "\n'
             '    "listed family and gives it no more than it takes from it; among them, above any floors, an "\n'
             '    "outcome above another at a condition beyond is exceeded on the family, with no premise beyond "\n'
             '    "listings without repetition; above its floor an optimum of every order rising with the family "\n'
             '    "has each member take its whole capacity at a condition beyond and give nothing there, so it "\n'
             '    "stands at its floor or at the level before with what the rest gives, less what the rest takes "\n'
             '    "and less the capacity; with no floor, at that or at nothing; where no member may take from a "\n'
             '    "condition beyond every optimum leaves it where the rest leaves it, and lowers it below that "\n'
             '    "exactly where the part has some capacity and the rest leaves something there; on a web a "\n'
             '    "dependence beyond is broken exactly where its need exceeds what the rest leaves less the "\n'
             '    "capacity; Drain: a taker of capacity k up to two drains the source to two less k at the "\n'
             '    "store\'s optimum, and the dweller\'s dependence breaks exactly where k is positive. "\n')
README_OLD = ('witnesses `Optimum.Drain.drained_ends`, `Optimum.Drain.counted_after_drains`, `Optimum.Drain.room_needed`, '
              '`Optimum.Drain.satisficing_either`, `Optimum.Drain.kept_takes_slack` |')
README_NEW = ('read off one step of exchange, where a part\'s members take at most their capacity, give only to the family and '
              'gain nothing on it, the rest exchanging as it does (`Flow.ActsWithin`, `Flow.Outcome`), there is room above any '
              'floors (`Optimum.Above.room`), each member of an optimum takes its whole capacity beyond above the floor and gives '
              'nothing there (`Optimum.Above.full`, `Optimum.Above.floor_or_full`), every optimum stands beyond at what the '
              'rest leaves less the capacity (`Optimum.optimum_beyond`), untouched where no member may take '
              '(`Optimum.optimum_untouched`), lowered exactly where the part has capacity and something stands '
              '(`Optimum.optimum_lowers_iff`), and on a web a dependence beyond is broken exactly where its need exceeds what '
              'the rest leaves less the capacity (`Web.optimum_broken_iff_capacity`); witnesses `Optimum.Drain.drained_ends`, '
              '`Optimum.Drain.counted_after_drains`, `Optimum.Drain.room_needed`, `Optimum.Drain.satisficing_either`, '
              '`Optimum.Drain.kept_takes_slack`, `Optimum.Drain.drawing_broken_iff` |')
README_ZH_OLD = '保持每个依存时，最优恰取余量（`Flow.keeping_optimum_takes_slack`） |'
README_ZH_NEW = ('保持每个依存时，最优恰取余量（`Flow.keeping_optimum_takes_slack`）；读于一步交换——部分的成员所取不超过其容量、'
                 '只给予族、在族上不增益，其余者如其所为而交换（`Flow.ActsWithin`、`Flow.Outcome`）——在任何底线之上都有余地'
                 '（`Optimum.Above.room`），最优在底线之上于之外处用尽成员的容量且不给予（`Optimum.Above.full`、'
                 '`Optimum.Above.floor_or_full`），每个最优在之外处立于其余者所留减去容量（`Optimum.optimum_beyond`），'
                 '无成员可取处不动（`Optimum.optimum_untouched`），恰在部分有容量且有所存处被降低（`Optimum.optimum_lowers_iff`），'
                 '在网上，之外的依存恰在其所需超过其余者所留减去容量处被打断（`Web.optimum_broken_iff_capacity`）；'
                 '见证 `Optimum.Drain.drawing_broken_iff` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
