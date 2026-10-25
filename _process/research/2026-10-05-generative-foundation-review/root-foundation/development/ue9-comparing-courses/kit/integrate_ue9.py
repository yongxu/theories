#!/usr/bin/env python3
"""UE9: join Becoming.ComparingCourses to the core as a leaf. Copies the new module (no landed module changes: the
general lemma and link composition stay in the leaf, NOTE §5); adds it to the checker's core list (after
Becoming.EventualWideningInstances, its one import) and its scope text (after KeepingWidening's); imports it in the root
module with an L1 doc bullet after KeepingWidening's (it imports only Becoming.EventualWideningInstances, an L1 module,
and names no ethical predicate); adds the package README rows (EN, ZH) after KeepingWidening's. Mirrors UE7's
integrate_ue7.py without its patches; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue9.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# the new module
target = PKG / 'Becoming/ComparingCourses.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'ComparingCourses.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.EventualWideningInstances", ',
     '"Becoming.EventualWideningInstances", "Becoming.ComparingCourses", ')
edit(checker, """    "opening along passing of support; witnesses that each premise is needed. "
    "Standpoints: """, """    "opening along passing of support; witnesses that each premise is needed. "
    "ComparingCourses: two rankings crossed by widening close a cycle on every web, so on a web of "
    "formations on two sides no strict partial order containing widening ranks every course keeping "
    "widening by name from the first step above every course that admits alike, was wider up to the "
    "first step and is mixed with it; the one-pair form needs the exchange of sides, the reverse ranking "
    "is consistent, by scale among others, and where the static course's admissions are listed the "
    "ranking is a strict partial order containing widening on every web; infinite width does not "
    "suffice, and along a merging continuation listed static courses close the cycle; a transitive "
    "relation joined to the strict part of a transitive relation containing it is transitive, so "
    "widening joined to the strict part of inclusion with a lag, uniform, varying with the formation, "
    "for each admission or along a continuation, and widening or eventual widening joined to the "
    "strict part of inclusion with a lag from some step on, are strict partial orders containing "
    "widening, and each decides the lag of a course keeping every formation of another one step "
    "later; the lag by name reads names across "
    "steps, along a continuation it is unchanged by every re-identification carrying it; on the "
    "own-condition web widening with a lag and eventual widening disagree, so no strict partial order "
    "there contains both, and the tail order ranks a course above one that admitted what it never "
    "admits; keeping what the other keeps is met by widening or widening with a lag, by the order of a "
    "lag varying with the formation and by the tail order, not by the order of a lag for each "
    "admission, and leaves the two-sided pair unranked both ways. "
    "Standpoints: """)

# the root module: import, and the new bullet after KeepingWidening's
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.EventualWideningInstances\n',
     'import Becoming.EventualWideningInstances\nimport Becoming.ComparingCourses\n')
edit(root, """  landed module joins (board item UE7).
* `Becoming.Growth` (L1):""", """  landed module joins (board item UE7).
* `Becoming.ComparingCourses` (L1): what a comparison of two courses can be on what they admit.
  Two rankings crossed by widening close a cycle (`Web.ranks_self_of_crossed`). On a web of
  formations on two sides (`Sides.web`), no strict partial order containing widening ranks every
  course keeping widening by name from the first step above every course that admits alike from
  the first step, was wider up to it and is mixed with it
  (`Sides.no_order_ranks_keeping_over_alike`); for one pair the cycle needs the exchange of sides
  (`Sides.keeping_over_alike_cycles`, `Sides.exchange_needed`), the reverse ranking is consistent,
  by scale among others (`Sides.reverse_consistent`, `Sides.scale_counts`), and where the static
  course's admissions are listed the ranking is a strict partial order containing widening on every
  web (`Web.ListedOrder.irrefl`, `Web.ListedOrder.trans`, `Web.ListedOrder.ranks`). Infinite width
  does not suffice (`AllOrSegment.unlisted_consistent`), and along a merging continuation listed
  static courses close the cycle (`AlongMerging.no_order_ranks_along_listed`). Widening with a lag
  (`Web.IncludesLater`, `Web.WidensWithLag`): a transitive relation joined to the strict part of a
  transitive relation containing it is transitive (`strictJoin_trans`), so widening or widening
  with a lag is a strict partial order containing widening (`Web.strictJoin_order`,
  `Web.WidensOrWithLag.irrefl`, `Web.WidensOrWithLag.trans`), as are the orders of the other lags
  (`Web.widensOrWithFormationLag_order`, `Web.widensOrEachLater_order`). It reads names across
  steps (`NamesAcrossSteps.lag_reads_names`); along a continuation it is unchanged by every
  re-identification carrying it (`Web.widensOrWithLagAlong_reidentify`). It decides UE4's lag
  (`LagWitness.decided`), as do lags varying with the formation or for each admission and the tail
  order, which contains eventual widening (`Web.tailOrder_order`, `LagWitness.tailOrder_decides`).
  On the own-condition web widening with a lag and eventual widening disagree, so no strict partial
  order there contains both (`TailAndLag.no_order_contains_both`); the tail order ranks a course
  above one that admitted what it never admits (`TailAndLag.tailOrder_loses`), widening or widening
  with a lag never (`Web.WidensOrWithLag.includesEachLater`). Keeping what the other keeps
  (`Web.KeepsWhatKept`) is met by widening or widening with a lag and by the tail order, not by the
  order of a lag for each admission (`EachLagDrops.eachLag_not_keeping`), and leaves the two-sided
  pair unranked both ways (`Sides.keeping_reading`). Each law is near-definitional. A leaf:
  alternative comparisons and their witnesses, which no module uses and C's order does not adopt
  (board item UE9).
* `Becoming.Growth` (L1):""")

# the package README rows (EN, ZH), after KeepingWidening's
readme = PKG / 'README.md'
lines = readme.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L2 | [`Becoming.KeepingWidening`]')]
assert len(at) == 1, at
assert not any('[`Becoming.ComparingCourses`]' in line for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    '| L1 | [`Becoming.ComparingCourses`](Becoming/ComparingCourses.lean) | what a comparison of two courses can be on '
    'what they admit (no ethical predicate): two rankings crossed by widening close a cycle '
    '(`Web.ranks_self_of_crossed`), so on a web of formations on two sides no strict partial order containing widening '
    'ranks every course keeping widening by name from the first step above every course that admits alike, was wider '
    'up to the first step and is mixed with it (`Sides.no_order_ranks_keeping_over_alike`); the one-pair form needs '
    'the exchange (`Sides.exchange_needed`), the reverse ranking is consistent (`Sides.reverse_consistent`, '
    '`Sides.scale_counts`), and with listed static admissions the ranking is consistent (`Web.ListedOrder.ranks`), '
    'infinite width not sufficing (`AllOrSegment.unlisted_consistent`); '
    'widening or widening with a lag is a strict partial order containing widening (`Web.WidensOrWithLag.trans`, '
    'from `strictJoin_trans`) that reads names across steps (`NamesAcrossSteps.lag_reads_names`; along a continuation '
    '`Web.widensOrWithLagAlong_reidentify`) and decides UE4\'s lag (`LagWitness.decided`), as does the tail order, '
    'which contains eventual widening (`LagWitness.tailOrder_decides`); widening with a lag and eventual widening '
    'rank a pair oppositely on the own-condition web (`TailAndLag.no_order_contains_both`); keeping what the other keeps '
    'is met by both orders (`Web.WidensOrWithLag.keepsWhatKept`, `Web.TailOrder.keepsWhatKept`), not by a lag for each '
    'admission (`EachLagDrops.eachLag_not_keeping`); near-definitional |']
readme.write_text('\n'.join(lines), encoding='utf-8')

readme_zh = PKG / 'README.zh.md'
lines = readme_zh.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L2 | [`Becoming.KeepingWidening`]')]
assert len(at) == 1, at
assert not any('[`Becoming.ComparingCourses`]' in line for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    '| L1 | [`Becoming.ComparingCourses`](Becoming/ComparingCourses.lean) | 就所纳比较两个进程能是什么（无伦理谓词）：'
    '为扩大所交叉的两个排序闭成一环（`Web.ranks_self_of_crossed`），故在两侧构成之网上，没有包含扩大的严格偏序能把每个'
    '自首步起按名持续扩大的进程排在每个自首步起所纳相同、至首步更宽且与之混杂的进程之上'
    '（`Sides.no_order_ranks_keeping_over_alike`）；单对形式需要交换两侧（`Sides.exchange_needed`），反向的排序一致'
    '（`Sides.reverse_consistent`、`Sides.scale_counts`），静态进程所纳由列表持有时该排序一致（`Web.ListedOrder.ranks`），'
    '无穷之宽则不足（`AllOrSegment.unlisted_consistent`）；'
    '扩大或带滞后的扩大是包含扩大的严格偏序（`Web.WidensOrWithLag.trans`，出自 `strictJoin_trans`），它跨步按名读构成'
    '（`NamesAcrossSteps.lag_reads_names`；沿一延续见 `Web.widensOrWithLagAlong_reidentify`），并判定 UE4 的滞后'
    '（`LagWitness.decided`），包含最终扩大的尾序亦然（`LagWitness.tailOrder_decides`）；在自身条件之网上，带滞后的扩大与'
    '最终扩大对一对进程排序相反（`TailAndLag.no_order_contains_both`）；两种序皆满足“保有对方所保有者”（`Web.WidensOrWithLag.keepsWhatKept`、'
    '`Web.TailOrder.keepsWhatKept`），每次所纳各自之滞后则否（`EachLagDrops.eachLag_not_keeping`）；近乎定义 |']
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.ComparingCourses joined (root import and L1 bullet, checker core list and scope, README rows '
      'EN and ZH); no landed module changed')
