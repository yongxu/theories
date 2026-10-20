#!/usr/bin/env python3
"""Join OB1's laws to the core package: copy the extended Becoming.LevelCoupling in, extend its root doc bullet and
its scope text in check_becoming.py, extend its README row (EN) and add the missing one (ZH, after Observation's).
usage: python3 -B integrate.py   (OB1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['OB1_ROOT']).resolve() if os.environ.get('OB1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'LevelCoupling.lean'
assert 'carried_iff_rising' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'LevelCoupling.lean', target)

DOC_OLD = ('  is required with a positive need; an observed one can be responded to within its need: observing\n'
           '  is exactly where a level can couple into a formation by level.\n')
DOC_NEW = ('  is required with a positive need; an observed one can be responded to within its need: observing\n'
           '  is exactly where a level can couple into a formation by level. Through dependence alone, a\n'
           '  formation exchanging only where supported exchanges no less where the levels at the step stand\n'
           '  no lower; so dependence alone carries of one level at the step exactly the responses rising with\n'
           '  it, each by units at thresholds, a fall only where some level falls, and supplying a deficit by\n'
           '  none; with a complement at a fixed total, units depending on the level and on its complement\n'
           '  carry every response.\n')
SCOPE_OLD = ('    "exactly where the condition is required with a positive need, and observing is exactly where a level can couple "\n'
             '    "into a formation within its need. "\n')
SCOPE_NEW = ('    "exactly where the condition is required with a positive need, and observing is exactly where a level can couple "\n'
             '    "into a formation within its need; under a law reading through dependence alone, a formation "\n'
             '    "exchanging across a step only where the levels there admit it takes and gives no less where "\n'
             '    "the levels at the step stand no lower, the history before alike, so a response carried by "\n'
             '    "such formations rises with the levels at the step and falls only where some level there falls; "\n'
             '    "a response to one level at the step, up to a bound, is carried by such a family exactly where "\n'
             '    "it rises with that level, by units at thresholds; supplying what a level lacks of a positive "\n'
             '    "amount passes by level and is carried by no such family; where the level and a complement "\n'
             '    "stand at a fixed total, units depending on both, one for each level up to the total, carry "\n'
             '    "every response to the level. "\n')
README_OLD = '| L1 | [`Becoming.LevelCoupling`](Becoming/LevelCoupling.lean) | where a level couples into a formation |'
README_NEW = ('| L1 | [`Becoming.LevelCoupling`](Becoming/LevelCoupling.lean) | where a level couples into a formation, and '
              'what dependence alone carries of a level (no premise beyond what each theorem names): by threshold only a '
              'crossing passes (`ExchangeLaw.Through.not_respondsByLevel`), by level the level passes, and coupling by '
              'level is exactly where a level can couple in within its need (`not_not_obs_iff_respondsByLevel`); through '
              'dependence alone, a formation exchanging only where supported (`ExchangeLaw.NeedsSupportAt`) exchanges no '
              'less where the levels at the step stand no lower (`ExchangeLaw.Through.rises_at_step`), so a carried '
              'response rises with them and falls only where some level falls (`ExchangeLaw.Through.carried_rises`, '
              '`ExchangeLaw.Through.carried_fall_needs_fall`); a response to one level is carried by dependence alone '
              'exactly where it rises with it, by units at thresholds (`carried_iff_rising`, `Layers.carry`); supplying a '
              'deficit passes by level and is carried by no such family (`supplyLaw_through`, `supply_not_carried`); with '
              'a complement at a fixed total every response is carried, each unit depending on the level and on its '
              'complement (`Complement.carry`, `supply_carried_by_complement`) |')
README_ZH_ROW = ('| L1 | [`Becoming.LevelCoupling`](Becoming/LevelCoupling.lean) | 水平在何处耦合入形成，以及单凭依存能承载一个水平的什么'
                 '（除各定理所列外不加前提）：经阈值只有跨越通过（`ExchangeLaw.Through.not_respondsByLevel`），经水平则水平通过，'
                 '经水平的耦合恰是水平能在所需之内耦合入之处（`not_not_obs_iff_respondsByLevel`）；单凭依存而读的律之下，'
                 '只在被支持处交换的形成（`ExchangeLaw.NeedsSupportAt`）在该步水平不更低处交换不更少'
                 '（`ExchangeLaw.Through.rises_at_step`），所以被承载的回应随之升高，只在某水平下降处下降'
                 '（`ExchangeLaw.Through.carried_rises`、`ExchangeLaw.Through.carried_fall_needs_fall`）；对一个水平的回应'
                 '恰在随它升高处由单凭依存者承载，由各阈值上的单元承载（`carried_iff_rising`、`Layers.carry`）；补足亏欠经水平'
                 '通过，而没有这样的族承载它（`supplyLaw_through`、`supply_not_carried`）；有总量固定的补时，每个回应都被承载，'
                 '每个单元依存于该水平及其补（`Complement.carry`、`supply_carried_by_complement`） |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
assert '`Becoming.LevelCoupling`' not in zh
lines = zh.split('\n')
idx = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.Observation`](Becoming/Observation.lean) |')]
assert len(idx) == 1, idx
lines[idx[0] + 1:idx[0] + 1] = [README_ZH_ROW]
(PKG / 'README.zh.md').write_text('\n'.join(lines))
print('integrated')
