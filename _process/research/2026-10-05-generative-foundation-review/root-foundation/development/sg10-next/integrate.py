#!/usr/bin/env python3
"""Join SG10's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG10_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG10_ROOT']).resolve() if os.environ.get('SG10_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'namespace Next' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = '  rebuilt by every optimum under weights falling less than twofold, ended at more.\n'
DOC_NEW = (DOC_OLD +
           '  These laws hold over any law G of what stands, a level z giving G t z at the step from\n'
           '  t, the renewal law z + R z their case. Where others first draw from what an optimizer\n'
           '  leaves at least what the remainder renews, every optimum of an order whose weighting falls\n'
           '  at every step ends the base at once; where they draw more, so does every optimum of an\n'
           '  order with positive weights rising at no step. Witness: from two, the doubling source is\n'
           '  rebuilt alone and ended with others drawing first, under the same weights.\n')
SCOPE_OLD = '    "falling more than twofold every optimum ends it. "\n'
SCOPE_NEW = ('    "falling more than twofold every optimum ends it; each of these laws holds over any law G of "\n'
             '    "what stands, a level z at the step from t giving G t z to be drawn or left, with holding or "\n'
             '    "rising to y needing y <= G t y, the renewal law G t z = z + R z the case from which the "\n'
             '    "laws above are stated; where at each step to the n-th G (t + 1) z <= z and the weighting "\n'
             '    "falls at every step, or G (t + 1) z < z for z > 0 and the weighting is positive and rises "\n'
             '    "at no step, with a capacity covering G 0 s and G t 0, every optimum stands at nothing at "\n'
             '    "every step from the first to the n-th; where others first leave K t z of the level z and "\n'
             '    "that renews by R, G t z = K t z + R (K t z), and every dependence on the base with a "\n'
             '    "positive need met at the start is broken at the first step; Holding: from two, a source "\n'
             '    "doubling up to eight is rebuilt to four and eight by every optimum alone under weights "\n'
             '    "falling less than twofold a step, ended at once with others leaving a quarter, ended under "\n'
             '    "weights falling at every step with others leaving half, and with equal weights and others "\n'
             '    "leaving half ending and holding at two are both optima. "\n')
README_OLD = 'witness `Optimum.Holding.doubling_rebuilds` |'
README_NEW = ('witness `Optimum.Holding.doubling_rebuilds`; each of these laws holds over any law `G` of what stands, a '
              'level `z` giving `G t z` at the step from `t` (`Optimum.Next`, `Web.Next`), the renewal law `z + R z` '
              'the case; where others first draw from what an optimizer leaves at least what the remainder renews, every '
              'optimum of an order whose weighting falls at every step ends the base at once, and where they draw more, '
              'so does every optimum of an order with positive weights rising at no step '
              '(`Optimum.Next.frontier_ends_drawn_first`, '
              '`Optimum.Next.frontier_ends_drawn_more`, `Web.Next.frontier_ends_drawn_first`, '
              '`Web.Next.frontier_ends_drawn_more`); witness `Optimum.Holding.doubling_drawn_first` |')
README_ZH_OLD = '见证 `Optimum.Holding.doubling_rebuilds` |'
README_ZH_NEW = ('见证 `Optimum.Holding.doubling_rebuilds`；这些规律对任何“所立之律” `G` 都成立，水平 `z` 在自 `t` 之步给出 `G t z`'
                 '（`Optimum.Next`、`Web.Next`），更新之律 `z + R z` 是其情形；他者先从优化者所留中抽取不少于剩余之更新时，'
                 '权重每步下降之序的每个最优都立即终结基础，抽取更多时，权重为正且不上升之序的每个最优亦然'
                 '（`Optimum.Next.frontier_ends_drawn_first`、`Optimum.Next.frontier_ends_drawn_more`、'
                 '`Web.Next.frontier_ends_drawn_first`、`Web.Next.frontier_ends_drawn_more`）；见证 '
                 '`Optimum.Holding.doubling_drawn_first` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
GONE = ['weighted_add_left', 'drawable_step', 'drawable_le_of_gains', 'drawable_lt_of_gains', 'weighted_of_ends',
        'weighted_le_of_gains', 'weighted_lt_of_gains', 'outpaced_greatest', 'outpaced_above', 'ended_outdrawn',
        'stays_empty', 'rise_succ', 'rise_le', 'rise_le_top', 'rise_within', 'rise_of_below', 'rise_at_top',
        'rise_below_before', 'le_rise', 'rebuilding_before', 'rebuilding_after', 'rebuilding_at', 'rebuilding_within',
        'rebuilding_le_cap', 'rebuilding_open', 'rebuilding_gainsMost', 'drawable']


def general(text):
    """The renewal-law forms no longer declared are cited by their general forms."""
    import re
    return re.sub(r'`Optimum\.(' + '|'.join(sorted(GONE, key=len, reverse=True)) + r')`', r'`Optimum.Next.\1`', text)


rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(general(once(rd, README_OLD, README_NEW)))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(general(once(zh, README_ZH_OLD, README_ZH_NEW)))
print('integrated')
