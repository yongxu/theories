#!/usr/bin/env python3
"""Join J1S to the package: copy the extended Becoming.Ranking in, extend its root doc bullet, the checker's scope text
and its README rows (EN, ZH).
usage: python3 -B integrate.py   (J1S_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['J1S_ROOT']).resolve() if os.environ.get('J1S_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


assert 'basicTier' not in (PKG / 'Becoming' / 'Ranking.lean').read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Ranking.lean', PKG / 'Becoming' / 'Ranking.lean')
root = (PKG / 'Becoming.lean').read_text()
root = once(root, '''  relations the easing course no longer takes part in or undermines.
''', '''  relations the easing course no longer takes part in or undermines. Read with the sustaining
  formation's events as the basic tier, J1 ranks absence above malignant growth under the
  stepwise and relation-level readings, where C alone leaves them unranked.
''')
(PKG / 'Becoming.lean').write_text(root)
chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '''    "kept, and in the two-part family it leaves absence and occurrence unranked as the stepwise "
    "reading does. "
''', '''    "kept, and in the two-part family it leaves absence and occurrence unranked as the stepwise "
    "reading does. Read in two tiers, the sustaining formation's included events basic and the focal "
    "formation's gains, the course without the focal formation is lexically above the course with it "
    "under the stepwise and relation-level readings, so every comparison meeting J1 "
    "(Lexical.BasicPriority) ranks absence above malignant growth. "
''')
(PKG / 'check_becoming.py').write_text(chk)
rd = (PKG / 'README.md').read_text()
rd = once(rd, '''and leaves absence and occurrence unranked in the two-part family (`Ranking.relational_unranked`) |''',
'''and leaves absence and occurrence unranked in the two-part family (`Ranking.relational_unranked`); read with the sustaining formation's events as the basic tier, J1 ranks absence above malignant growth under the stepwise and relation-level readings (`Ranking.basic_first_ranks`) |''')
(PKG / 'README.md').write_text(rd)
zh = (PKG / 'README.zh.md').read_text()
zh = once(zh, '''在二元族中也不对不在场与在场排序（`Ranking.relational_unranked`） |''',
'''在二元族中也不对不在场与在场排序（`Ranking.relational_unranked`）；以维持者的事件为基本层读时，J1 在逐步与关系层读法下都把不在场排在恶性增殖之上（`Ranking.basic_first_ranks`） |''')
(PKG / 'README.zh.md').write_text(zh)
print('integrated')
