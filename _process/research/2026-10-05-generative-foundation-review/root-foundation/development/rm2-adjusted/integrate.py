#!/usr/bin/env python3
"""Join RM2's laws to the core package: copy the extended Becoming.RegimeMargin in, extend its root doc bullet, its
scope text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (RM2_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM2_ROOT']).resolve() if os.environ.get('RM2_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'RegimeMargin.lean'
assert 'namespace Adjusted' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean', target)

DOC_OLD = '  to break lies between `b + H n ≤ x` and `x < b + (H - Y) n`.\n'
DOC_NEW = (DOC_OLD +
           '  Where giving adjusts, a law of what is left and of the recent giving on the state of level and\n'
           '  recent giving, the regime\'s step is the case reading what is left alone. Where the adjustment\n'
           '  rests at the draw exactly where the regime gives the draw, every rest point at or above the draw\n'
           '  is the regime\'s, on the step and on the run; the frozen rest, between the recent and the\n'
           '  regime\'s giving, shows the premise is needed. With the recent giving on the level\'s side of the\n'
           '  draw and the adjustment keeping giving on the side where the recent and the regime\'s giving\n'
           '  lie, as every giving between them does, the regime\'s laws hold with their premises: the\n'
           '  condition ends below the point of no return and holds at or above it, and the point is exact\n'
           '  on the state. With the recent giving on the other side, giving moving one unit a step toward\n'
           '  the regime\'s crosses the point both ways.\n')
SCOPE_OLD = ('    "draw holds alone, together they end the condition from every level). "\n')
SCOPE_NEW = ('    "draw holds alone, together they end the condition from every level); where giving adjusts, "\n'
             '    "a law A of what is left and of the recent giving on the state of level and recent giving, the "\n'
             '    "regime\'s step is the case A e r = g e; where A e H = H exactly where g e = H, a state at or "\n'
             '    "above H is left as it is exactly where its recent giving is H and the regime\'s step leaves its "\n'
             '    "level, and its run stays where it started exactly where the regime\'s run from its level does; "\n'
             '    "with the recent giving below H and A below H where the recent giving and g are, a level below "\n'
             '    "H + y is nothing after as many steps as it stood where A gives nothing from nothing, and with y "\n'
             '    "positive at most H from x - H steps on whatever A gives from nothing; with the recent giving at "\n'
             '    "least H and A at least H where the recent giving and g are, a level from H + y never falls "\n'
             '    "below its start, up to a top the step keeps or with no top where g meets H from y on; the "\n'
             '    "condition ends exactly from below H + y where the recent giving is below H exactly there; any A "\n'
             '    "between the recent giving and g keeps both sides, so the point is exact on its state, and rests "\n'
             '    "at H exactly where g gives H where A moves wherever it differs from g, so its runs rest only at "\n'
             '    "the regime\'s point; Crossing: under giving gated at two and a draw of three, the frozen rest "\n'
             '    "A e r = r, between the recent giving and g, stays at four with recent giving three, A moving "\n'
             '    "one unit toward g has the level at nothing from the second step on from five with recent "\n'
             '    "giving nothing and at or above seven from the second step on from four with recent giving six, "\n'
             '    "where the regime\'s step ends the condition from four and holds it from five. "\n')
README_OLD = 'witnesses `Concave.roots`, `Peaked.each_holds`, `Peaked.together_ends` |'
README_NEW = ('witnesses `Concave.roots`, `Peaked.each_holds`, `Peaked.together_ends`; where giving adjusts, a law of '
              'what is left and of the recent giving on the state of level and recent giving (`Adjusted.step`), the '
              'regime\'s step is the case reading what is left alone (`Adjusted.orbit_regime`); where the adjustment '
              'rests at the draw exactly where the regime gives the draw, every rest point at or above the draw is the '
              'regime\'s, on the step and on the run (`Adjusted.rest_iff`, `Adjusted.rests_iff`), so for every giving '
              'between the recent and the regime\'s that moves wherever it differs from the regime\'s '
              '(`Adjusted.Between.rests_iff`), and the frozen rest, between them, shows the premise is needed '
              '(`Crossing.frozen_stays`); with the recent giving on the level\'s side of the draw the condition ends '
              'below the point and holds at or above it (`Adjusted.ends_below`, `Adjusted.stays_ended`, '
              '`Adjusted.taken_whole`, `Adjusted.holds`, `Adjusted.holds_from`), and the point is exact on the state '
              '(`Adjusted.ends_iff_below`), for every giving between the recent and the regime\'s too '
              '(`Adjusted.Between.ends_iff_below`); with the recent giving on the other side the point is crossed both '
              'ways (`Crossing.crosses`) |')
README_ZH_OLD = '见证 `Concave.roots`、`Peaked.each_holds`、`Peaked.together_ends` |'
README_ZH_NEW = ('见证 `Concave.roots`、`Peaked.each_holds`、`Peaked.together_ends`；所给调整时，即所给是所剩与近来所给之律，'
                 '状态为水平与近来所给（`Adjusted.step`），体制之步是只读所剩的情形（`Adjusted.orbit_regime`）；'
                 '调整恰在体制给出汲取处静于汲取时，汲取及其上的每个静点都是体制的，在步上与在运行上皆然'
                 '（`Adjusted.rest_iff`、`Adjusted.rests_iff`），故介于近来所给与体制所给之间、凡与体制所给不同处皆移动的所给亦然'
                 '（`Adjusted.Between.rests_iff`），而介于两者之间的冻结之静表明此前提不可少（`Crossing.frozen_stays`）；'
                 '近来所给在水平一侧时，条件在不可回返点之下终结、在其上维持（`Adjusted.ends_below`、`Adjusted.stays_ended`、'
                 '`Adjusted.taken_whole`、`Adjusted.holds`、`Adjusted.holds_from`），此点在状态上是确切的'
                 '（`Adjusted.ends_iff_below`），对介于近来所给与体制所给之间的每个所给亦然（`Adjusted.Between.ends_iff_below`）；'
                 '近来所给在另一侧时，此点两向皆被越过（`Crossing.crosses`） |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
