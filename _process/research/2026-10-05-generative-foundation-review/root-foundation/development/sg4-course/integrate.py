#!/usr/bin/env python3
"""Join SG4's laws to the core package: copy the extended Becoming.Optimum in, extend its root doc bullet, its scope
text in check_becoming.py and its README rows (EN, ZH).
usage: python3 -B integrate.py   (SG4_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG4_ROOT']).resolve() if os.environ.get('SG4_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


target = PKG / 'Becoming' / 'Optimum.lean'
assert 'Reoptimizes' not in target.read_text(), 'already integrated'
shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', target)

DOC_OLD = ('  capacity `k` whose optimum breaks the dweller exactly where `0 < k`; two takers each within\n'
           '  the slack of a need of one leave nothing at their mutual best response.\n')
DOC_NEW = ('  capacity `k` whose optimum breaks the dweller exactly where `0 < k`; two takers each within\n'
           '  the slack of a need of one leave nothing at their mutual best response.\n'
           '  Over a course in which a part chooses again at every step, each step is read off the one\n'
           '  before; against a renewal of `r` a step at a positive need, at most `r` below it, a draw\n'
           '  `k` loses a dependence at that need exactly where `r < k`, the level then below the need\n'
           '  once the steps exceed its starting excess, and for good; where the renewal stops below the\n'
           '  need what the course draws is then bounded, and where something is given at every step it\n'
           '  has no bound; several optimizers each within the renewal lose it where their joint capacity\n'
           '  exceeds it. Witnesses: a taker re-optimizing its store against a renewing dweller, and two takers\n'
           '  of capacity one at mutual best responses losing a source renewed by one that either alone\n'
           '  keeps, holding less than the course in which one restrains.\n')
SCOPE_OLD = ('    "two leave nothing at their mutual best response, and one taker\'s restraint is none. "\n')
SCOPE_NEW = ('    "two leave nothing at their mutual best response, and one taker\'s restraint is none; over a "\n'
             '    "course in which a part re-optimizes at every step, each step\'s level beyond is the level "\n'
             '    "before with what the rest gives, less what the rest takes and the part\'s capacity (with "\n'
             '    "several optimizers at mutual best responses, their joint capacity), and against a renewal "\n'
             '    "of r a step at a positive need m, at most r below it, a draw k loses a dependence at m "\n'
             '    "exactly where r < k: above the renewal the level never rises and is below m once the steps "\n'
             '    "exceed its starting excess, for good; within it the level never falls; what a course draws "\n'
             '    "is at most the start with r a step; where the renewal stops below m a positive draw is "\n'
             '    "bounded exactly where r < k and over a long enough course keeping draws more, and where at "\n'
             '    "least one is given at every step the draw has no bound; Renewing: a taker re-optimizing its store loses the dweller exactly "\n'
             '    "where r < k and holds less than a taker of capacity r, and two takers of capacity one at "\n'
             '    "mutual best responses lose a source renewed by one that either alone keeps, holding less "\n'
             '    "than the course in which one restrains, none of whose steps is a mutual best response. "\n')
README_OLD = ('witnesses `Optimum.TwoTakers.joint_drains`, `Optimum.TwoTakers.restrained_not_mutual` |')
README_NEW = ('witnesses `Optimum.TwoTakers.joint_drains`, `Optimum.TwoTakers.restrained_not_mutual`; over a course of '
              're-optimizing steps (`Optimum.Reoptimizes`) each step is read off the one before (`Optimum.course_beyond`, '
              '`Optimum.mutual_course_beyond`), and against a renewal of `r` at a positive need, at most `r` below it, a '
              'dependence there is lost exactly where the draw exceeds `r` (`Web.course_lost_iff`; several optimizers by '
              'their joint capacity, `Web.mutual_course_lost`), once the steps exceed the starting excess over the need '
              'and for good (`Optimum.ends_within`); where the renewal stops below the need a positive draw is bounded '
              'exactly then (`Optimum.drawn_bounded_iff`, `Web.course_ended_drawn`) and keeping draws more over a long '
              'course (`Optimum.keeping_draws_more`), and where at least one is given at every step the draw has no bound '
              '(`Web.course_drawn_unbounded`); witnesses `Optimum.Renewing.lost_iff`, `Optimum.Renewing.keeping_holds_more`, '
              '`Optimum.Renewing.joint_course_lost`, `Optimum.Renewing.alone_kept`, '
              '`Optimum.Renewing.restraint_holds_more` |')
README_ZH_OLD = '见证 `Optimum.TwoTakers.joint_drains`、`Optimum.TwoTakers.restrained_not_mutual` |'
README_ZH_NEW = ('见证 `Optimum.TwoTakers.joint_drains`、`Optimum.TwoTakers.restrained_not_mutual`；在每一步重新优化的进程中'
                 '（`Optimum.Reoptimizes`），每一步都由前一步读出（`Optimum.course_beyond`、`Optimum.mutual_course_beyond`），'
                 '面对在正的所需处每步 `r`、其下至多 `r` 的更新，那里的依存恰在抽取超过 `r` 时失去（`Web.course_lost_iff`；多个'
                 '优化者按其合计容量，`Web.mutual_course_lost`），步数超过起始超出所需之量后永久如此（`Optimum.ends_within`）；'
                 '更新在所需之下停止时，正的抽取总量恰在此时有界（`Optimum.drawn_bounded_iff`、`Web.course_ended_drawn`），足够长'
                 '的进程中保持者抽取更多（`Optimum.keeping_draws_more`）；每步至少给予一时抽取无界（`Web.course_drawn_unbounded`）；'
                 '见证 '
                 '`Optimum.Renewing.lost_iff`、`Optimum.Renewing.keeping_holds_more`、`Optimum.Renewing.joint_course_lost`、'
                 '`Optimum.Renewing.alone_kept`、`Optimum.Renewing.restraint_holds_more` |')

root = (PKG / 'Becoming.lean').read_text()
(PKG / 'Becoming.lean').write_text(once(root, DOC_OLD, DOC_NEW))
chk = (PKG / 'check_becoming.py').read_text()
(PKG / 'check_becoming.py').write_text(once(chk, SCOPE_OLD, SCOPE_NEW))
rd = (PKG / 'README.md').read_text()
(PKG / 'README.md').write_text(once(rd, README_OLD, README_NEW))
zh = (PKG / 'README.zh.md').read_text()
(PKG / 'README.zh.md').write_text(once(zh, README_ZH_OLD, README_ZH_NEW))
print('integrated')
