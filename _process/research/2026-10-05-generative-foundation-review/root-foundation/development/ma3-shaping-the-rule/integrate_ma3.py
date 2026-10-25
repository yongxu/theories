#!/usr/bin/env python3
"""MA3: join Becoming.RuleShaping to the core: copy the module into the package, import it in the root module after
Becoming.ClosedCapture with a doc bullet, add it to the checker's core list and scope text, and add its rows to the
package README (EN, ZH).
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ma3.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


target = PKG / 'Becoming/RuleShaping.lean'
assert not target.exists()
shutil.copyfile(HERE / 'tree/Becoming/RuleShaping.lean', target)

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.ClosedCapture\n', 'import Becoming.ClosedCapture\nimport Becoming.RuleShaping\n')
edit(root, """  (`Thinned`).
* `Becoming.PatternPassing` (L1):""", """  (`Thinned`).
* `Becoming.RuleShaping` (L1): the capacity to shape the rule, selected by what comes back to it.
  On `RuleCapture`'s counts the carriers are shapers: each leaves `a + s + p` offspring and each
  other `a + c + p`, `s` what comes back to the shapers alone, `p` what comes to every member alike,
  `c` the cost. At a step the rule favours the shapers (weakly) exactly where `c ≤ s`, whatever `p`;
  a larger `p` pulls the rule toward even, a smaller cost raises it; with nothing coming back and a
  cost the shapers' share falls at every step, and with no cost and nothing coming back it stays.
  Selection by rules in turn is selection by their product, so `m` steps before anything comes back
  and `n` with it keep the share from falling exactly where
  `(a + c + p)^m (a + c + p)^n ≤ (a + p)^m (a + s + p)^n`; across a stretch the shared part can turn
  the verdict (`SharedFlips`). On the reading of what comes back from the share (`byBack`),
  `ReadsShare` is equivalent to what comes back being monotone in the share (`byBack_reads_iff`);
  monotone and covering the cost, the loop locks (`covering_locks`); at a threshold with
  `lo < c < hi` the share rises at every step from above and falls at every step from below
  (`threshold_rises`, `threshold_falls`). A leaf: a model of selection on the capacity, which
  nothing below needs (board item MA3).
* `Becoming.PatternPassing` (L1):""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.RuleCapture", "Becoming.ClosedCapture", ', '"Becoming.RuleCapture", "Becoming.ClosedCapture", "Becoming.RuleShaping", ')
edit(checker, """    "PatternPassing: on a web whose activity is carrying, a pattern present from T on with carriers brief \"""",
     """    "RuleShaping: on RuleCapture's counts with shapers leaving a + s + p offspring and others a + c + p, "
    "at a step the rule favours the shapers weakly exactly where c <= s whatever p, a larger p pulls the "
    "rule toward even and a smaller cost raises it, nothing coming back with a cost lowers the shapers' "
    "share at every step and no cost with nothing coming back leaves it; selection by rules in turn is "
    "selection by their product, so m steps before anything comes back and n with it keep the share "
    "from falling exactly where (a+c+p)^m (a+c+p)^n <= (a+p)^m (a+s+p)^n, one more step before never "
    "helping the shapers and one more step with it never hurting them where it covers the cost, and the "
    "shared part can turn a stretch; on the reading of what comes back from the share, ReadsShare is "
    "equivalent to what comes back being monotone in the share, the loop locking where it is so and "
    "covers the cost; at a threshold with lo < c < hi the share rises at every step from above and falls "
    "at every step from below. "
    "PatternPassing: on a web whose activity is carrying, a pattern present from T on with carriers brief \"""")

readme = PKG / 'README.md'
text = readme.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.ClosedCapture`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.RuleShaping`](Becoming/RuleShaping.lean) | the capacity to shape the rule, '
             'selected by what comes back to it (no premise beyond the hypotheses named): with shapers leaving '
             '`a + s + p` offspring and others `a + c + p`, at a step the rule favours the shapers exactly where '
             '`c ≤ s`, whatever `p` (`RuleShaping.favours_iff`, `RuleShaping.favours_alike`); with nothing coming '
             'back and a cost their share falls at every step (`RuleShaping.nothing_back_falls`); `m` steps before '
             'anything comes back and `n` with it keep the share from falling exactly where '
             '`(a + c + p)^m (a + c + p)^n ≤ (a + p)^m (a + s + p)^n` (`RuleShaping.stretch_iff`); on the reading of '
             'what comes back from the share, `ReadsShare` is equivalent to its being monotone in the share '
             '(`RuleShaping.byBack_reads_iff`), and monotone and covering the cost the loop locks '
             '(`RuleShaping.covering_locks`); at a threshold with `lo < c < hi` the share rises at every step from above '
             'and falls at every step from below (`RuleShaping.threshold_rises`, `RuleShaping.threshold_falls`) |')
readme.write_text('\n'.join(lines), encoding='utf-8')

readme_zh = PKG / 'README.zh.md'
text = readme_zh.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.ClosedCapture`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.RuleShaping`](Becoming/RuleShaping.lean) | 塑规之能，以独返于塑规者之所得被选'
             '（除所列假设外不加前提）：塑规者各留 `a + s + p` 后代、他者各留 `a + c + p` 时，一步之内规则偏向塑规者恰当 `c ≤ s`，'
             '与 `p` 无关（`RuleShaping.favours_iff`、`RuleShaping.favours_alike`）；无所独返而有成本，其份额每步皆降'
             '（`RuleShaping.nothing_back_falls`）；先 `m` 步无所返、后 `n` 步有之，份额不降恰当 '
             '`(a + c + p)^m (a + c + p)^n ≤ (a + p)^m (a + s + p)^n`（`RuleShaping.stretch_iff`）；所返读自份额时，'
             '`ReadsShare` 等价于所返随份额单调（`RuleShaping.byBack_reads_iff`），单调且覆盖成本则回路锁定'
             '（`RuleShaping.covering_locks`）；门槛处 `lo < c < hi` 时，自上则份额每步皆升，自下则每步皆降'
             '（`RuleShaping.threshold_rises`、`RuleShaping.threshold_falls`） |')
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.RuleShaping joined (root import and bullet, checker core list and scope, README rows)')
