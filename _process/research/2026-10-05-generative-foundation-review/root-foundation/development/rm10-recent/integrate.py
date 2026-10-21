#!/usr/bin/env python3
"""Join RM10's laws to the core package: copy the extended Becoming.RegimeMargin in, extend its root doc entry, its
scope text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (RM10_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM10_ROOT']).resolve() if os.environ.get('RM10_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'RegimeMargin.lean'
assert 'def KeepsBelow' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', target)

DOC_OLD = '  within B.\n'
DOC_NEW = ('  within B. These hold for any law of states read condition by condition, and so for a web with\n'
           '  a recent giving, each condition holding its level and what it gave last: under mutual support\n'
           '  its thresholds fall as any level or recent giving rises; the plain web and the adjusted regime\n'
           '  are its cases.\n')
SCOPE_OLD = '    "not rise as any other level rises wherever the run from the top level stays within B. "\n'
SCOPE_NEW = ('    "not rise as any other level rises wherever the run from the top level stays within B; these are "\n'
             '    "stated for any law of states read condition by condition, a law keeping the order of states so "\n'
             '    "reading them; a web with a recent giving, each condition holding its level and what it gave last, "\n'
             '    "keeps the order under mutual support, the plain web and the adjusted regime its cases, and a "\n'
             '    "giving ramping with what was given has its threshold fall from four to three as its last giving "\n'
             '    "rises. "\n')
README_OLD = "`Relay` keeping no band (`Coupled.Relay.threshold_beyond_band`) |"
README_NEW = ("`Relay` keeping no band (`Coupled.Relay.threshold_beyond_band`); these hold for any law read condition by "
              "condition (`Coupled.Indexed.ReadsPointwise`, `Coupled.Indexed.KeepsBelow`), so for a web with a recent giving "
              "(`Coupled.Indexed.Recent.step`, `Coupled.Indexed.Recent.keepsBelow`), the plain web and the adjusted regime "
              "its cases (`Coupled.Indexed.Recent.plain`, `Coupled.Indexed.Recent.adjusted`); what was given last can lower "
              "a threshold (`Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent`) |")
README_ZH_OLD = "`Relay` 不保持任何带（`Coupled.Relay.threshold_beyond_band`） |"
README_ZH_NEW = ("`Relay` 不保持任何带（`Coupled.Relay.threshold_beyond_band`）；这些对任何逐条件读取状态之律成立"
                 "（`Coupled.Indexed.ReadsPointwise`、`Coupled.Indexed.KeepsBelow`），故对带近来所给的网成立"
                 "（`Coupled.Indexed.Recent.step`、`Coupled.Indexed.Recent.keepsBelow`），普通之网与调整的体制是其情形"
                 "（`Coupled.Indexed.Recent.plain`、`Coupled.Indexed.Recent.adjusted`）；上次所给可降低阈值"
                 "（`Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent`） |")

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
