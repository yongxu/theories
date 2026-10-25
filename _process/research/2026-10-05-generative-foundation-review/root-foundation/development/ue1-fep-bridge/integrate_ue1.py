#!/usr/bin/env python3
"""UE1: join Becoming.ChoiceCountCapture to the core: copy the module into the package, import it in the root module after
Becoming.RuleShaping with a doc bullet, add it to the checker's core list and scope text, and add its rows to the
package README (EN, ZH). Mirrors MA3's integrate_ma3.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ue1.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


target = PKG / 'Becoming/ChoiceCountCapture.lean'
assert not target.exists()
shutil.copyfile(HERE / 'tree/Becoming/ChoiceCountCapture.lean', target)

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.RuleShaping\n', 'import Becoming.RuleShaping\nimport Becoming.ChoiceCountCapture\n')
edit(root, """  nothing below needs (board item MA3).
* `Becoming.PatternPassing` (L1):""", """  nothing below needs (board item MA3).
* `Becoming.ChoiceCountCapture` (L1): a chooser reading what couples in, its rule read from the
  count of its choices. The choice made from a fold of the prefix of what couples in, whatever the
  fold and the choice, is a selection through the couplings (`selectsThrough`,
  `unchosen_beyond_coupling`), and choosers sharing their folds select through their pooled
  couplings (`pooled_selectsThrough`, `pooled_unchosen_beyond`); near-definitional. A chooser over
  two policies counting its choices, the rule read from the counts weighted by a standing score
  (`choose`, `weighted`): under a standing score, with the rule in force read from the counts, the
  threshold `κo · other ≤ κc · carrier` divides the counts into two regions the course never
  leaves, also against the score (`counted_locks`, `counted_locks_down`), and the lock outlives a
  loss it does not read (`counted_outlives_loss`); a moved count, a stale rule or a change of score
  read late carries the course across (`Witness`). Counted from the posterior at the time of
  choosing, the share falls at every step (`posterior_count_falls`, by `RuleShaping`). A leaf: an
  instance module of selection through couplings, capture through the rule and closed capture, read
  on active inference, whose lock is the lock-in of increasing returns (board item UE1).
* `Becoming.PatternPassing` (L1):""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ClosedCapture", "Becoming.RuleShaping", ',
     '"Becoming.ClosedCapture", "Becoming.RuleShaping", "Becoming.ChoiceCountCapture", ')
edit(checker, """    "PatternPassing: on a web whose activity is carrying, a pattern present from T on with carriers brief \"""",
     """    "ChoiceCountCapture: a chooser choosing from a fold of what couples in selects through its couplings, "
    "and choosers sharing their folds through their pooled couplings; a chooser over two policies counting "
    "its choices, the rule read from the counts weighted by a standing score and in sync at the start, "
    "never leaves the region of kappa_o * other <= kappa_c * carrier or its complement, also against the "
    "score, and the lock outlives a loss it does not read; counted from the posterior at the time of "
    "choosing, the share falls at every step. "
    "PatternPassing: on a web whose activity is carrying, a pattern present from T on with carriers brief \"""")

readme = PKG / 'README.md'
text = readme.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.RuleShaping`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.ChoiceCountCapture`](Becoming/ChoiceCountCapture.lean) | a chooser reading what '
             'couples in, its rule read from the count of its choices (no premise beyond the hypotheses named): choosing '
             'from a fold of what couples in selects through the couplings (`ChoiceCountCapture.selectsThrough`), and '
             'sharing folds through the pooled couplings (`ChoiceCountCapture.pooled_selectsThrough`); under a standing score '
             '`κc`, `κo`, with the rule in force read from the counts, the counts never leave `κo · other ≤ κc · carrier` or '
             'its complement (`ChoiceCountCapture.counted_locks`, `ChoiceCountCapture.counted_locks_down`), also where '
             '`κc < κo`, and the lock outlives a loss it does not read (`ChoiceCountCapture.counted_outlives_loss`); counted '
             'from the posterior at the time of choosing, the share falls at every step '
             '(`ChoiceCountCapture.posterior_count_falls`) |')
readme.write_text('\n'.join(lines), encoding='utf-8')

readme_zh = PKG / 'README.zh.md'
text = readme_zh.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.RuleShaping`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.ChoiceCountCapture`](Becoming/ChoiceCountCapture.lean) | 读其所耦合者之择者，'
             '其规则读自其所择之计数（除所列假设外不加前提）：自所耦合者之折叠而择，即经其耦合之选择'
             '（`ChoiceCountCapture.selectsThrough`），共享折叠者经其合耦合而选（`ChoiceCountCapture.pooled_selectsThrough`）；'
             '常立评分 `κc`、`κo` 下，所行之规则读自计数时，计数永不离 `κo · other ≤ κc · carrier` 或其补'
             '（`ChoiceCountCapture.counted_locks`、`ChoiceCountCapture.counted_locks_down`），`κc < κo` 时亦然，且锁定久于其所不读之损失'
             '（`ChoiceCountCapture.counted_outlives_loss`）；于择时计后验，份额每步皆降（`ChoiceCountCapture.posterior_count_falls`） |')
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.ChoiceCountCapture joined (root import and bullet, checker core list and scope, README rows)')
