#!/usr/bin/env python3
"""MA4b: join Becoming.ReadInTime to the core. Copy the module into the package; import it in the root module after
Becoming.DrawnShaping, with a doc bullet after DrawnShaping's; add it to the checker's core list and scope text; and add
its rows to the package README (EN, ZH) after DrawnShaping's. Each edit is asserted to apply exactly once
(integrate_ma4.py).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ma4b.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


target = PKG / 'Becoming/ReadInTime.lean'
assert not target.exists()
shutil.copyfile(HERE / 'tree/Becoming/ReadInTime.lean', target)
assert hashlib.sha256(target.read_bytes()).digest() == hashlib.sha256(
    (HERE / 'tree/Becoming/ReadInTime.lean').read_bytes()).digest()

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.DrawnShaping\n', 'import Becoming.DrawnShaping\nimport Becoming.ReadInTime\n')
edit(root, """  join of `RuleShaping`'s shaping with `ClosedCapture`'s readers, which nothing below needs (board
  item MA4).
""", """  join of `RuleShaping`'s shaping with `ClosedCapture`'s readers, which nothing below needs (board
  item MA4).
* `Becoming.ReadInTime` (L1): the loss read in time by the others, joined to the critical mass. The
  rule read is `ClosedCapture.Thinned.lossPool` over three of `RuleShaping`'s rules after shaping:
  the shapers among the readers read `hi` coming back to the shapers, whatever the loss, and the
  others `lo` while the loss is below `N` and `lo'` from then on, all with the same `a`, `p` and `c`
  (`shapedLossPool`). Where every step adds at least one to the loss and `lo' ≤ hi`, at a reading
  step past the bound at which the rule in force favours the shapers, the course is locked for good
  exactly where `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo'` at the share there
  (`kept_iff`); at one at which the late reading favours the others, the next step reading too, it
  is locked the other way for good, one step late, exactly where the late reading favours the others
  at the share of the next step (`turned_iff`). Before the bound the course is `DrawnShaping`'s
  (`early`); along it the late reading never falls (`late_never_falls`), so, with steps `N` and
  `N + 1` reading, the two laws decide a reading from `N` at every step but at most one
  (`kept_early_iff`, `turned_early_iff`, `at_most_one_between`), from which the course starts a new
  round (`kept_next_round_iff`). From a start whose rule `g` favours the shapers strictly, a shaper
  present and `lo ≤ hi`, every reading of this form with `lo' ≤ hi` from a reading step from
  `g.other * c * x.other` on keeps the lock (`deadline`, by `bernoulli_powers`). A leaf: the join of
  `ClosedCapture`'s timing with `DrawnShaping`'s critical mass, which nothing below needs (board item
  MA4b).
""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ChoiceCountCapture", "Becoming.DrawnShaping", ',
     '"Becoming.ChoiceCountCapture", "Becoming.DrawnShaping", "Becoming.ReadInTime", ')
edit(checker, """    "every step, the share rising strictly above the critical mass and falling strictly below it. "
    "PatternPassing: """, """    "every step, the share rising strictly above the critical mass and falling strictly below it. "
    "ReadInTime: ClosedCapture's Thinned.lossPool over three of RuleShaping's rules after shaping, the shapers "
    "among the readers reading hi, the others lo below the bound N and lo' from then on: where every step adds at "
    "least one to the loss and lo' <= hi, at a reading step past the bound at which the rule in force favours the "
    "shapers, the course is locked for good exactly where carrier*c + other*c <= carrier*hi + other*lo' at the "
    "share there; at one at which the late reading favours the others, the next step reading too, it is locked "
    "the other way for good, one step late, exactly where the late reading favours the others at the share of the "
    "next step; before the bound the course is DrawnShaping's, along it the late reading never falls, and with "
    "steps N and N + 1 reading at most one step escapes both laws, from which the course starts a new round; from "
    "a start whose rule favours the shapers strictly, a shaper present and lo <= hi, every reading of this form "
    "with lo' <= hi from a reading step from g.other*c*x.other on keeps the lock. "
    "PatternPassing: """)

readme = PKG / 'README.md'
text = readme.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.DrawnShaping`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.ReadInTime`](Becoming/ReadInTime.lean) | the loss read in time by the others, '
             'joined to the critical mass (no premise beyond the hypotheses named): where every step adds at least one '
             'to the loss and `lo\' ≤ hi`, read past the bound while the rule in force favours the shapers, the course is '
             'locked for good exactly where `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo\'` '
             '(`ReadInTime.kept_iff`), and read while the late reading favours the others, the next step reading too, it '
             'is locked the other way for good, one step late, exactly where the late reading favours the others at the '
             'share of the next step (`ReadInTime.turned_iff`); in `DrawnShaping`\'s course, with steps `N` and `N + 1` '
             'reading, these laws decide a reading from `N` at every step but at most one (`ReadInTime.kept_early_iff`, '
             '`ReadInTime.turned_early_iff`, `ReadInTime.at_most_one_between`), from which the course starts a new round '
             '(`ReadInTime.kept_next_round_iff`); and from a start whose rule favours the shapers strictly, a shaper '
             'present and `lo ≤ hi`, every reading of this form with `lo\' ≤ hi` from a reading step from '
             '`g.other * c * x.other` on keeps the lock (`ReadInTime.deadline`) |')
readme.write_text('\n'.join(lines), encoding='utf-8')

readme_zh = PKG / 'README.zh.md'
text = readme_zh.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.DrawnShaping`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.ReadInTime`](Becoming/ReadInTime.lean) | 他者及时读损失，接于临界量'
             '（除所列假设外不加前提）：每步损失至少增一且 `lo\' ≤ hi` 时，于界后、所行之规则偏向塑规者之读步，进程永锁恰当 '
             '`x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo\'`（`ReadInTime.kept_iff`）；于迟读偏向他者、'
             '下一步亦读之读步，进程迟一步而永反向锁定，恰当下一步之份额处迟读偏向他者（`ReadInTime.turned_iff`）；于 '
             '`DrawnShaping` 之进程，第 `N`、`N + 1` 步皆读时，除至多一步外，此二律定自第 `N` 步起之读'
             '（`ReadInTime.kept_early_iff`、`ReadInTime.turned_early_iff`、`ReadInTime.at_most_one_between`），自该步进程另起一轮'
             '（`ReadInTime.kept_next_round_iff`）；起点之规则严格偏向塑规者、有塑规者且 `lo ≤ hi` 时，自第 '
             '`g.other * c * x.other` 步起之读步，此形且 `lo\' ≤ hi` 之读皆留其锁（`ReadInTime.deadline`） |')
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.ReadInTime joined (root import and bullet, checker core list and scope, README rows)')
