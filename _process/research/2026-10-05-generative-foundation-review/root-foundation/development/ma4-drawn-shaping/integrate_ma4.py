#!/usr/bin/env python3
"""MA4: join Becoming.DrawnShaping to the core. Copy the module into the package; import it in the root module after
Becoming.ChoiceCountCapture, with a doc bullet; add it to the checker's core list and scope text; and add its rows to
the package README (EN, ZH). Each edit is asserted to apply exactly once (integrate_ma3.py).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ma4.py"""
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


target = PKG / 'Becoming/DrawnShaping.lean'
assert not target.exists()
shutil.copyfile(HERE / 'tree/Becoming/DrawnShaping.lean', target)
assert hashlib.sha256(target.read_bytes()).digest() == hashlib.sha256(
    (HERE / 'tree/Becoming/DrawnShaping.lean').read_bytes()).digest()

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.ChoiceCountCapture\n', 'import Becoming.ChoiceCountCapture\nimport Becoming.DrawnShaping\n')
edit(root, """  on active inference, whose lock is the lock-in of increasing returns (board item UE1).
* `Becoming.PatternPassing` (L1):""", """  on active inference, whose lock is the lock-in of increasing returns (board item UE1).
* `Becoming.DrawnShaping` (L1): what comes back to the shapers, read by readers drawn from the
  selected. The rule after shaping (`RuleShaping.shaped`) is read as the pool of its readers'
  readings (`ClosedCapture.Drawn.pool`), each shaper among the readers reading what comes back to the
  shapers alone as `hi` and each other as `lo`, both with the same `a`, `p` and `c`. The rule read
  reads the share monotonically exactly where `lo ≤ hi` (`drawn_reads_iff`), against it where
  `hi ≤ lo`; at a share it favours the shapers exactly where
  `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo`, whatever `a` and `p`, and with
  `lo ≤ c ≤ hi` exactly where the shapers stand to the others at least as `c - lo` to `hi - c`
  (`critical_iff`). It favours the shapers at every share exactly where `c ≤ lo` and `c ≤ hi`, at no
  share exactly where `lo < c` and `hi ≤ c`; with `lo ≤ hi` a share decides exactly where
  `lo < c < hi` (`critical_mass_iff`), and from a start under the rule read there every course is
  locked one way at every step (`drawn_locked_either`), the share rising strictly above the critical
  mass and falling strictly below it, the shapers present (`drawn_rises`, `drawn_falls`). A leaf: the
  join of `RuleShaping`'s shaping with `ClosedCapture`'s readers, which nothing below needs (board
  item MA4).
* `Becoming.PatternPassing` (L1):""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.RuleShaping", "Becoming.ChoiceCountCapture", ',
     '"Becoming.RuleShaping", "Becoming.ChoiceCountCapture", "Becoming.DrawnShaping", ')
edit(checker, """    "choosing, the share falls at every step. "
    "PatternPassing: on a web whose activity is carrying, a pattern present from T on with carriers brief \"""",
     """    "choosing, the share falls at every step. "
    "DrawnShaping: RuleShaping's rule after shaping read by readers drawn from the selected, hi coming back "
    "to the shapers where a shaper reads and lo where an other does: the rule read reads the share "
    "monotonically exactly where lo <= hi and against it where hi <= lo; at a share it favours the shapers "
    "exactly where carrier*c + other*c <= carrier*hi + other*lo, whatever a and p, with lo <= c <= hi "
    "exactly where other*(c-lo) <= carrier*(hi-c); it favours them at every share exactly where c <= lo and "
    "c <= hi, at none exactly where lo < c and hi <= c, and with lo <= hi a share decides exactly where "
    "lo < c < hi; with lo <= hi, from a start under the rule read there, every course is locked one way at "
    "every step, the share rising strictly above the critical mass and falling strictly below it. "
    "PatternPassing: on a web whose activity is carrying, a pattern present from T on with carriers brief \"""")

readme = PKG / 'README.md'
text = readme.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.ChoiceCountCapture`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.DrawnShaping`](Becoming/DrawnShaping.lean) | what comes back to the shapers, '
             'read by readers drawn from the selected (no premise beyond the hypotheses named): the rule read reads '
             'the share monotonically exactly where `lo ≤ hi` (`DrawnShaping.drawn_reads_iff`); at a share it favours '
             'the shapers exactly where `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo` '
             '(`DrawnShaping.drawn_favours_iff`), with `lo ≤ c ≤ hi` exactly where '
             '`x.other * (c - lo) ≤ x.carrier * (hi - c)` (`DrawnShaping.critical_iff`); with `lo ≤ hi` a share '
             'decides exactly where `lo < c < hi` (`DrawnShaping.critical_mass_iff`), and every course from the rule '
             'read at its start is locked one way at every step (`DrawnShaping.drawn_locked_either`), the share '
             'rising strictly above the critical mass and falling strictly below it (`DrawnShaping.drawn_rises`, '
             '`DrawnShaping.drawn_falls`) |')
readme.write_text('\n'.join(lines), encoding='utf-8')

readme_zh = PKG / 'README.zh.md'
text = readme_zh.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.ChoiceCountCapture`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.DrawnShaping`](Becoming/DrawnShaping.lean) | 返于塑规者者，由取自被选者之读者读之'
             '（除所列假设外不加前提）：所读之规则随份额单调恰当 `lo ≤ hi`（`DrawnShaping.drawn_reads_iff`）；于一份额，其偏向塑规者恰当 '
             '`x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo`（`DrawnShaping.drawn_favours_iff`），'
             '`lo ≤ c ≤ hi` 时恰当 `x.other * (c - lo) ≤ x.carrier * (hi - c)`（`DrawnShaping.critical_iff`）；'
             '`lo ≤ hi` 时，份额能定其向恰当 `lo < c < hi`（`DrawnShaping.critical_mass_iff`），且自起点所读之规则起，'
             '每一进程每步皆锁于一向（`DrawnShaping.drawn_locked_either`）：临界量之上份额每步严格升，其下每步严格降'
             '（`DrawnShaping.drawn_rises`、`DrawnShaping.drawn_falls`） |')
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.DrawnShaping joined (root import and bullet, checker core list and scope, README rows)')
