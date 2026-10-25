#!/usr/bin/env python3
"""UE4: join Becoming.EventualWidening and Becoming.EventualWideningInstances to the core: copy both modules into the
package, import them in the root module after Becoming.Regions with a doc bullet each, add them to the checker's core
list and scope text, and add their rows to the package README (EN, ZH). Mirrors UE1's integrate_ue1.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ue4.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
MODULES = ('EventualWidening', 'EventualWideningInstances')


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


for name in MODULES:
    target = PKG / f'Becoming/{name}.lean'
    assert not target.exists(), target
    shutil.copyfile(HERE / f'tree/Becoming/{name}.lean', target)

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Regions\n',
     'import Becoming.Regions\nimport Becoming.EventualWidening\nimport Becoming.EventualWideningInstances\n')
edit(root, """  it requires, and over a region omitting a requirement can lose its own support.
* `Becoming.Growth` (L1):""", """  it requires, and over a region omitting a requirement can lose its own support.
* `Becoming.EventualWidening` (L1): widening read on late tails, and keeping widening (no premise
  beyond the representation). The web from a step on (`Web.after`) and a level path from it
  (`Web.tailFrom`) give eventual widening, widening on every late tail (`Web.EventuallyWidens`):
  first-order widening read on late tails, not a comparison of growth. Its order laws are
  widening's (`Web.EventuallyWidens.irrefl`, `Web.EventuallyWidens.trans`); it never reverses
  widening, and widening or eventual widening is transitive (`Web.Widens.not_eventually_reversed`,
  `Web.WidensOrEventually.trans`); it reads only tails (`Web.EventuallyWidens.of_agree_left`). A
  course keeps widening along a continuation where nothing admitted is lost and something keeps
  being opened (`Web.KeepsWidening`): by name over a listed type none does
  (`Web.KeepsWidening.not_listed`), and one that does eventually widens a range admitting alike on
  what it admits at some step (`Web.KeepsWidening.eventually_widens_of_within`). Near-definitional.
  A leaf: a tool, the long-run reading of widening, until a gain or giver law imports it (board
  item UE4).
* `Becoming.EventualWideningInstances` (L1): eventual widening's instances and witnesses, and what
  carries a widening. Read on the sequences of levels, where some course eventually widens a second,
  eventually widening it and its complement are dense (the first course varied, the second fixed),
  so the verdict is neither verifiable nor refutable and a practice fixed by the record can keep it
  against every record (`Web.eventually_neither`, `Web.eventually_insulated`, by
  `insulates_iff_dense`); a course whose admissions are listed eventually widens nothing
  (`Web.not_eventually_of_listed`). Witnesses: a burst wider at the first step is mixed with a
  rising course that eventually widens it and keeps widening (`OwnCondition.disagreement`); a
  saturated course widens the rising one and keeps widening from no step
  (`OwnCondition.not_monotone`); a course keeping every formation of another from one step later is
  mixed with it in every tail (`LagWitness.lag`). Opened by the opened, a provisional property of
  what carries a range (`Flow.OpenedByOpened`): one range is carried by a relay of openings or by
  one giver with every admission the same (`OpeningChain.carried`), a closed cycle is opened by the
  opened with no widening (`ClosedCycle.cycle`), and ranking by it reverses widening
  (`Saturated.reverses`). A leaf: an instance module and models (board item UE4).
* `Becoming.Growth` (L1):""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Regions", "Becoming.Growth", ',
     '"Becoming.Regions", "Becoming.EventualWidening", "Becoming.EventualWideningInstances", "Becoming.Growth", ')
edit(checker, """    "own dependence by its own draw and loses its support. No ethical predicate occurs. "
    "Standpoints: """, """    "own dependence by its own draw and loses its support. No ethical predicate occurs. "
    "EventualWidening: a level path eventually widens another where from some step on it widens it on "
    "every tail, read on the web from that step; its order laws are widening's, it never reverses "
    "widening, widening or eventual widening is transitive, and it reads only tails; along a continuation "
    "a course keeps widening where nothing admitted is lost and something keeps being opened, by name over "
    "a listed type none does, and one that does eventually widens a range admitting alike on what it "
    "admits at some step. "
    "EventualWideningInstances: on the sequences of levels, where some course eventually widens a second, "
    "eventually widening it and its complement are dense, neither verifiable nor refutable, and insulable "
    "by a practice fixed by the record; a course whose admissions are listed eventually widens nothing; "
    "witnesses of a burst and a rising course mixed over every step with the rising course eventually "
    "wider, of a saturated course widening one that keeps widening, of a lag that eventual widening "
    "cannot order, of a merging continuation, of one range with two carriers, of a closed cycle opened by "
    "the opened with no widening, and of ranking by carriers reversing widening. "
    "Standpoints: """)

readme = PKG / 'README.md'
text = readme.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.Regions`]')]
assert len(at) == 1, at
assert not any(line.startswith('| L1 | [`Becoming.EventualWidening') for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    '| L1 | [`Becoming.EventualWidening`](Becoming/EventualWidening.lean) | widening read on late tails, and keeping '
    'widening (no premise beyond the representation): one level path eventually widens another where from some step '
    'on it widens it on every tail (`Web.EventuallyWidens`), first-order widening read on late tails; its order laws are '
    "widening's, it never reverses widening and widening or eventual widening is transitive "
    '(`Web.Widens.not_eventually_reversed`, `Web.WidensOrEventually.trans`), and it reads only tails '
    '(`Web.EventuallyWidens.of_agree_left`); keeping widening along a continuation (`Web.KeepsWidening`) holds by name '
    'over no listed type (`Web.KeepsWidening.not_listed`) and eventually widens a range admitting alike on what it '
    'admits at some step (`Web.KeepsWidening.eventually_widens_of_within`) |',
    '| L1 | [`Becoming.EventualWideningInstances`](Becoming/EventualWideningInstances.lean) | eventual widening\'s '
    'instances and witnesses, and what carries a widening: where some course eventually widens a second, the verdict '
    'and its complement are dense (the first course varied, the second fixed), so it is neither verifiable nor '
    'refutable and insulable (`Web.eventually_neither`, `Web.eventually_insulated`); a listed course eventually widens '
    'nothing (`Web.not_eventually_of_listed`); the disagreement, saturation and lag witnesses '
    '(`OwnCondition.disagreement`, `OwnCondition.not_monotone`, `LagWitness.lag`); opened by the opened, provisional '
    '(`Flow.OpenedByOpened`): one range with two carriers (`OpeningChain.carried`), a closed cycle with no widening '
    '(`ClosedCycle.cycle`), and ranking by it reversing widening (`Saturated.reverses`) |']
readme.write_text('\n'.join(lines), encoding='utf-8')

readme_zh = PKG / 'README.zh.md'
text = readme_zh.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.Regions`]')]
assert len(at) == 1, at
assert not any(line.startswith('| L1 | [`Becoming.EventualWidening') for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    '| L1 | [`Becoming.EventualWidening`](Becoming/EventualWidening.lean) | 在晚期尾段上读的扩大，以及持续扩大'
    '（除表示外不加前提）：一条水平路径从某步起在每个尾段上扩大另一条，即最终扩大它（`Web.EventuallyWidens`），'
    '这是在晚期尾段上读的一阶扩大；其序律即扩大的序律，它从不逆转扩大，扩大或最终扩大可传递'
    '（`Web.Widens.not_eventually_reversed`、`Web.WidensOrEventually.trans`），且只读尾段'
    '（`Web.EventuallyWidens.of_agree_left`）；沿延续的持续扩大（`Web.KeepsWidening`）按名在任何列出的类型上都不成立'
    '（`Web.KeepsWidening.not_listed`），并最终扩大一个在某步所纳之上一律同纳的范围'
    '（`Web.KeepsWidening.eventually_widens_of_within`） |',
    '| L1 | [`Becoming.EventualWideningInstances`](Becoming/EventualWideningInstances.lean) | 最终扩大的实例与见证，'
    '以及承载扩大者：某进程最终扩大另一进程之处，此判定与其补皆稠密（变第一进程，第二进程固定），故既不可证实亦不可证伪，'
    '且可被依记录的实践隔绝（`Web.eventually_neither`、`Web.eventually_insulated`）；所纳被列出的进程不最终扩大任何进程'
    '（`Web.not_eventually_of_listed`）；分歧、饱和与滞后的见证（`OwnCondition.disagreement`、`OwnCondition.not_monotone`、'
    '`LagWitness.lag`）；由已开者所开（暂定，`Flow.OpenedByOpened`）：一个范围两种承载者（`OpeningChain.carried`），'
    '无扩大的闭环（`ClosedCycle.cycle`），以及按其排序会逆转扩大（`Saturated.reverses`） |']
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.EventualWidening and Becoming.EventualWideningInstances joined (root imports and bullets, '
      'checker core list and scope, README rows)')
