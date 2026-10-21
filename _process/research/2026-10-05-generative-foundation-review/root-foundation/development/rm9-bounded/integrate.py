#!/usr/bin/env python3
"""Join RM9's laws to the core package: copy the extended Becoming.RegimeMargin in, extend its root doc entry, its
scope text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (RM9_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM9_ROOT']).resolve() if os.environ.get('RM9_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'RegimeMargin.lean'
assert 'def StaysWithin' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', target)

DOC_OLD = ("  other levels, is a least level that does not rise as any other rises; the pair's rest and\n"
           "  thresholds are these laws read for two.\n")
DOC_NEW = (DOC_OLD +
           '  Beyond a band a bound on the run takes its place: a run within B comes back within the count\n'
           '  of lists of levels within B and repeats, so whether a condition ends is decided by a finite\n'
           '  check, with no band and no order of states, and under mutual support each point of no return\n'
           '  is exact and falls as others rise wherever the run from the top level considered stays\n'
           '  within B.\n')
SCOPE_OLD = ("    \"rises; the pair's rest and thresholds are these read for two. \"\n")
SCOPE_NEW = ("    \"rises; the pair's rest and thresholds are these read for two; beyond a band, where the run \"\n"
             "    \"stays within B, it comes back within (B + 1) to the conditions' count steps and repeats, so \"\n"
             "    \"whether a condition ends is decided by a finite check where each giving reads what is left \"\n"
             "    \"condition by condition, and under mutual support each point of no return is exact and does \"\n"
             "    \"not rise as any other level rises wherever the run from the top level stays within B. \"\n")
README_OLD = "the pair's laws its case (`Coupled.threshold_pair`) |"
README_NEW = ("the pair's laws its case (`Coupled.threshold_pair`); beyond a band, where a run stays within a bound, "
              "whether a condition ends is decided by a finite check (`Coupled.Indexed.ends_iff_within`) and each point "
              "of no return is exact (`Coupled.Indexed.ends_iff_below_within`) and falls as others rise "
              "(`Coupled.Indexed.threshold_falls_within`), `Relay` keeping no band (`Coupled.Relay.threshold_beyond_band`) |")
README_ZH_OLD = "一对的律是其情形（`Coupled.threshold_pair`） |"
README_ZH_NEW = ("一对的律是其情形（`Coupled.threshold_pair`）；带之外，运行保持在一个界之内时，条件是否终止由有限检查判定"
                 "（`Coupled.Indexed.ends_iff_within`），每个不可回返点是精确的（`Coupled.Indexed.ends_iff_below_within`），"
                 "且随其他水平上升而不升（`Coupled.Indexed.threshold_falls_within`），`Relay` 不保持任何带"
                 "（`Coupled.Relay.threshold_beyond_band`） |")

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
