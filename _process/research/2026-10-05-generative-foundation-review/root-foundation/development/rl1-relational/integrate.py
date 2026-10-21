#!/usr/bin/env python3
"""Join RL1 to the package: copy the extended Becoming.Ranking, Becoming.Relevance and Becoming.JointDraw in, extend the
root doc bullets, the checker's scope text and Ranking's README rows (EN, ZH).
usage: python3 -B integrate.py   (RL1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RL1_ROOT']).resolve() if os.environ.get('RL1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


assert 'def relational' not in (PKG / 'Becoming' / 'Ranking.lean').read_text(), 'already integrated'
for name in ['Ranking', 'Relevance', 'JointDraw']:
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{name}.lean', PKG / 'Becoming' / f'{name}.lean')
root = (PKG / 'Becoming.lean').read_text()
root = once(root, '''  course undermines, so its law of easing adds that premise; a course whose levels never
  fall undermines nothing.
''', '''  course undermines, so its law of easing adds that premise; a course whose levels never
  fall undermines nothing. The relation-level reading withdraws under easing exactly the
  relations the easing course no longer takes part in or undermines.
''')
(PKG / 'Becoming.lean').write_text(root)
chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '''    "course undermines the focal event at step 3, which the overdrawing course includes. "
''', '''    "course undermines the focal event at step 3, which the overdrawing course includes. The "
    "relation-level reading (a formation's relation to a condition at a step, the living of "
    "Web.relations) withdraws under easing exactly the relations the easing course no longer takes "
    "part in or undermines, its law is the whole-run one where no level falls and every relation is "
    "kept, and in the two-part family it leaves absence and occurrence unranked as the stepwise "
    "reading does. "
''')
chk = once(chk, '''    "same holds where moreover the restrained flow takes from no condition more than it gives; "
''', '''    "same holds where moreover the restrained flow takes from no condition more than it gives, and "
    "under the relation-level reading where the restrained course also takes part wherever the other "
    "does; "
''')
(PKG / 'check_becoming.py').write_text(chk)
rd = (PKG / 'README.md').read_text()
rd = once(rd, '''which gives restraint over any number of drawers under the stepwise reading (`Ranking.restraint_extends_iff_stepwise`, in `Becoming.JointDraw`) |''',
'''which gives restraint over any number of drawers under the stepwise reading (`Ranking.restraint_extends_iff_stepwise`, in `Becoming.JointDraw`); the relation-level reading (`Ranking.relational`, the `living` of `Web.relations`) withdraws under easing exactly the relations the easing course no longer takes part in or undermines (`Ranking.relational_extends_iff_of_eases`), and leaves absence and occurrence unranked in the two-part family (`Ranking.relational_unranked`) |''')
(PKG / 'README.md').write_text(rd)
zh = (PKG / 'README.zh.md').read_text()
zh = once(zh, '''由此在逐步读法下节制对任意多个汲取者排在过度汲取之上（`Ranking.restraint_extends_iff_stepwise`，在 `Becoming.JointDraw` 中） |''',
'''由此在逐步读法下节制对任意多个汲取者排在过度汲取之上（`Ranking.restraint_extends_iff_stepwise`，在 `Becoming.JointDraw` 中）；关系层读法（`Ranking.relational`，`Web.relations` 的 `living`）在缓和下所撤回的恰是缓和之进程不再参与或所侵蚀的关系（`Ranking.relational_extends_iff_of_eases`），在二元族中也不对不在场与在场排序（`Ranking.relational_unranked`） |''')
(PKG / 'README.zh.md').write_text(zh)
print('integrated')
