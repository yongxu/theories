#!/usr/bin/env python3
"""Join ST1 to the package: copy the extended Becoming.Ranking and Becoming.JointDraw in, extend their root doc bullets,
their scope text in check_becoming.py and Ranking's README rows (EN, ZH).
usage: python3 -B integrate.py   (ST1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['ST1_ROOT']).resolve() if os.environ.get('ST1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


for name in ['Ranking', 'JointDraw']:
    target = PKG / 'Becoming' / f'{name}.lean'
    assert 'stepwise_extends_iff_of_eases' not in target.read_text() or name == 'JointDraw', 'already integrated'
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{name}.lean', target)

root = (PKG / 'Becoming.lean').read_text()
root = once(root, '''  leaves every need met, only the whole-run reading ranks its absence above its
  occurrence.
''', '''  leaves every need met, only the whole-run reading ranks its absence above its
  occurrence. Under easing the stepwise reading withdraws exactly the events the easing
  course undermines, so its law of easing adds that premise; a course whose levels never
  fall undermines nothing.
''')
root = once(root, '''  withholds (`Ranking.restraint_extends_iff`); `TwoDrawers` is the instance.
''', '''  withholds (`Ranking.restraint_extends_iff`), and under the stepwise reading too where the
  restrained flow takes from no condition more than it gives (`Ranking.restraint_extends_iff_stepwise`);
  `TwoDrawers` is the instance.
''')
(PKG / 'Becoming.lean').write_text(root)
chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '''    "the threshold, while with a third formation sharing the condition neither course extends the "
    "other under the stepwise reading. "
''', '''    "the threshold, while with a third formation sharing the condition neither course extends the "
    "other under the stepwise reading. Under easing (activity needing support in one course and "
    "following it in the other, which asks no more, holds every condition as high and draws on "
    "nothing more) an event the stepwise reading includes in the first stays included exactly where "
    "the second does not undermine there, so the second extends the first under the stepwise "
    "reading exactly when it undermines no event the first includes and includes one the first "
    "withholds; a course whose levels never fall undermines nothing; in ThirdParty the restrained "
    "course undermines the focal event at step 3, which the overdrawing course includes. "
''')
chk = once(chk, '''    "of drawers, and every comparison satisfying C ranks it higher; TwoDrawers: each take within the "
''', '''    "of drawers, and every comparison satisfying C ranks it higher; under the stepwise reading the "
    "same holds where moreover the restrained flow takes from no condition more than it gives; "
    "TwoDrawers: each take within the "
''')
(PKG / 'check_becoming.py').write_text(chk)
rd = (PKG / 'README.md').read_text()
rd = once(rd, '''for an overdrawing formation with a credited event before the loss, only the whole-run reading ranks its absence above its occurrence |''',
'''for an overdrawing formation with a credited event before the loss, only the whole-run reading ranks its absence above its occurrence; under easing the stepwise reading withdraws exactly the events the easing course undermines (`Ranking.stepwise_extends_iff_of_eases`), and a course whose levels never fall undermines nothing (`Ranking.stepwise_extends_iff_of_rising`), which gives restraint over any number of drawers under the stepwise reading (`Ranking.restraint_extends_iff_stepwise`, in `Becoming.JointDraw`) |''')
(PKG / 'README.md').write_text(rd)
zh = (PKG / 'README.zh.md').read_text()
zh = once(zh, '''对在损失之前有被记入事件的过度汲取者，只有整段读法把它的不在场排在其在场之上 |''',
'''对在损失之前有被记入事件的过度汲取者，只有整段读法把它的不在场排在其在场之上；在缓和下，逐步读法所撤回的恰是缓和之进程所侵蚀的事件（`Ranking.stepwise_extends_iff_of_eases`），水平从不下降的进程不侵蚀任何事件（`Ranking.stepwise_extends_iff_of_rising`），由此在逐步读法下节制对任意多个汲取者排在过度汲取之上（`Ranking.restraint_extends_iff_stepwise`，在 `Becoming.JointDraw` 中） |''')
(PKG / 'README.zh.md').write_text(zh)
print('integrated')
