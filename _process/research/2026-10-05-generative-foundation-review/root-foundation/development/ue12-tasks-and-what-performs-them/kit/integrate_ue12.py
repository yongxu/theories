#!/usr/bin/env python3
"""UE12: join Becoming.Tasks to the core as a leaf. Copies the new module (no landed module changes: the two laws of
reach and lagged covering, `Reaching.coversLater_of_trace` and `Reaching.not_widensWithLag_of_reach`, stay in the leaf,
NOTE §5); adds it to the checker's core list (after Becoming.HeldPossible, UE11's module) and its scope text (after
HeldPossible's); imports it in the root module with an L1 doc bullet after HeldPossible's (its import closure holds no
L2 module, and it names no ethical predicate); adds the package README rows (EN, ZH) after HeldPossible's. Mirrors
UE11's integrate_ue11.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue12.py"""
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
target = PKG / 'Becoming/Tasks.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'Tasks.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.HeldPossible", ', '"Becoming.HeldPossible", "Becoming.Tasks", ')
edit(checker, """    "rule raised at every other step renewal without end holds as well. "
    "Standpoints: """, """    "rule raised at every other step renewal without end holds as well. "
    "Tasks: constructor theory's tasks and what performs them, read on any process divided into a "
    "performing part and a substrate; a region of the part performs a task where each of its states is "
    "had with every legitimate input and the process reaches from each an output with the part in the "
    "region again, which is having an output possible with the part in the region, invariable where "
    "the successor is fixed at what the presented configuration reaches, with no halting; delivered "
    "with the part held at every move, a task is delivered, not conversely, as on a catalytic cycle "
    "whose task has an impossible transpose; one region composes a regular pair in series, and two "
    "compose in series and in parallel where each delivers by the moves holding what the other uses, "
    "which is sufficient and not needed and which interleaving gives, possibility read in each "
    "process; within one interleaving on one substrate, and where a delivery changes what its task "
    "does not list, a regular pair of possible tasks can have a composite performed by no region of "
    "any reading, and with no performing part a pair not regular can too; on two substrates passing a "
    "unit the additive pattern of a conservation law holds for readings of the other substrate, and an "
    "invariant read as the performer performs each single task; on a tower of performers with no top "
    "every delivery and every making of a performer from a natural configuration is had with the "
    "performers from some level up held; what can be done with the part held grows only across steps "
    "changing the part; and a delivery adds nothing to the whole possible, while widening what can be "
    "reached follows deliveries in neither direction: on what a configuration reaches the lagged order "
    "is same-offset widening, which ranks a delivered output above its input on one witness and below "
    "it on another, and where no course starts covering ranks nothing while the whole possible can "
    "narrow strictly. "
    "Standpoints: """)

# the root module: import, and the new bullet after HeldPossible's
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.HeldPossible\n', 'import Becoming.HeldPossible\nimport Becoming.Tasks\n')
edit(root, """  (board item UE11).
* `Becoming.Growth` (L1):""", """  (board item UE11).
* `Becoming.Tasks` (L1): constructor theory's tasks and what performs them, read on any process
  divided into a performing part (`part`) and a substrate (`sub`), a task a relation on the
  substrate (`Tasks.Input`). A region `K` of the part performs a task (`Tasks.Performs`) where it is
  presented with every legitimate input (`Tasks.Presented`) and the process reaches from each such
  configuration an output with the part in `K` again (`Tasks.Delivers`), which is having an output
  possible with the part in `K` (`Tasks.delivers_iff_possible`), invariable where the successor is
  fixed at what the presented configuration reaches, with no halting (`Tasks.Delivers.invariably`,
  `Tasks.ClimbTask.invariably`); a task is possible where some region performs it (`Tasks.Possible`),
  and possible from natural configurations where the performer can also be made from one
  (`Tasks.PossibleFrom`, `Tasks.Unmade.possible_not_possibleFrom`). Delivered by the moves holding
  any relation, a task is delivered (`Tasks.Delivers.of_heldMoves`), not conversely: on a catalytic
  cycle what performs is restored at the end, not held (`Tasks.Catalysis.not_held`,
  `Tasks.Catalysis.not_held_unchanged`), and the task's transpose `«逆»` is performed by no region of
  any reading of a performing part (`Tasks.Catalysis.transpose_not_possible`). One region delivers a
  regular pair in series, the grammar's `«而»` (`Tasks.Delivers.serial`, `Tasks.Performs.serial`),
  and the pair must be regular (`Tasks.Unregular.composite_not_possible`); two regions together
  deliver where each delivers by the moves holding what the other uses
  (`Tasks.Delivers.serial_holding`, `Tasks.Delivers.parallel_holding`), sufficient and not needed
  (`Tasks.CatalysedSeries.performs_pair`), which interleaving gives, possibility read in each process
  (`Tasks.Possible.serial_interleaveOn`, `Tasks.Possible.parallel_interleave`,
  `Tasks.Possible.parallel_within`); within one interleaving on one substrate, and where a delivery
  changes what its task does not list, composition fails by any means
  (`Tasks.ResettingInterleaved.composition_fails_within`, `Tasks.Resetting.composition_fails`,
  `Tasks.Resetting.listed_not_regular`). On two substrates passing a unit the additive pattern of a
  conservation law holds for readings of the other substrate, and an invariant read as the performer
  performs each single task (`Tasks.Conserved.additive_pattern`,
  `Tasks.Conserved.performs_with_one`). On a tower of performers with no top what is reached is
  reached with the performers from some level up held (`Tasks.tower_reach_held`), so every delivery,
  and every making of a performer from a natural configuration, is had with them held
  (`Tasks.tower_delivers_iff_held`, `Tasks.tower_made_held`), not so on a tower changing every level
  at once (`Tasks.FlipTower.not_held`). What can be done with the part held
  (`Tasks.PossibleWithPartHeld`) grows only across steps changing the part
  (`Tasks.changes_of_partHeldGrows`). A delivery adds nothing to the whole possible
  (`Tasks.Delivers.adds_nothing`), strictly narrowing it on the catalytic cycle
  (`Tasks.Catalysis.narrows`), while widening what can be reached follows deliveries in neither
  direction: on what a configuration reaches the lagged order is same-offset widening
  (`Reaching.widensOrLater_iff_of_reach`), which ranks a delivered output above its input
  (`Tasks.RiseTask.widens`) or below it (`Tasks.FallTask.widens_back`), and where no course starts
  covering ranks nothing (`Tasks.Catalysis.not_widensOrLater`). Each law is near-definitional or a
  witness. A leaf (board item UE12).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.HeldPossible`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.Tasks`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [row]
    path.write_text('\n'.join(lines), encoding='utf-8')


# the package README rows (EN, ZH), after HeldPossible's
readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.Tasks`](Becoming/Tasks.lean) | tasks and what performs them, constructor theory read on '
    'processes (no ethical predicate): a region of the performing part performs a task where, presented with every '
    'legitimate input, the process reaches from it an output with the part in the region again '
    '(`Tasks.Performs`, `Tasks.delivers_iff_possible`), invariably where the successor is fixed, with no halting '
    '(`Tasks.Delivers.invariably`, `Tasks.ClimbTask.invariably`); what performs is restored at the end, not held '
    '(`Tasks.Catalysis.not_held`), and a possible task can have an impossible transpose '
    '(`Tasks.Catalysis.transpose_not_possible`); one region composes a regular pair in series '
    '(`Tasks.Performs.serial`, `Tasks.Unregular.composite_not_possible`), two compose where each holds what the other '
    'uses, sufficient and not needed (`Tasks.Delivers.serial_holding`, `Tasks.CatalysedSeries.performs_pair`), which '
    'interleaving gives (`Tasks.Possible.parallel_within`), and composition fails within one interleaving and where a '
    'delivery changes what its task does not list (`Tasks.ResettingInterleaved.composition_fails_within`, '
    '`Tasks.Resetting.composition_fails`); the additive pattern and the division (`Tasks.Conserved.additive_pattern`, '
    '`Tasks.Conserved.performs_with_one`); the regress on a tower of performers (`Tasks.tower_reach_held`, '
    '`Tasks.tower_delivers_iff_held`, `Tasks.tower_made_held`, `Tasks.FlipTower.not_held`); what can be done with the '
    'part held grows only where the part changes (`Tasks.changes_of_partHeldGrows`); a delivery adds nothing to the '
    'whole possible (`Tasks.Delivers.adds_nothing`), and widening follows deliveries in neither direction '
    '(`Reaching.widensOrLater_iff_of_reach`, `Tasks.RiseTask.widens`, `Tasks.FallTask.widens_back`, '
    '`Tasks.Catalysis.not_widensOrLater`); near-definitional |')

readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.Tasks`](Becoming/Tasks.lean) | 任务与执行之者，构造子理论读于过程之上（无伦理谓词）：执行之部分之一区域执行一任务，'
    '谓呈以每一合法输入时，过程自之达一输出而该部分复在此区域中（`Tasks.Performs`、`Tasks.delivers_iff_possible`），'
    '后继固定时即恒然，而无停机（`Tasks.Delivers.invariably`、`Tasks.ClimbTask.invariably`）；执行者于终时复得，'
    '非全程持守（`Tasks.Catalysis.not_held`），可能之任务可有不可能之转置（`Tasks.Catalysis.transpose_not_possible`）；'
    '一区域串联合成正则之对（`Tasks.Performs.serial`、`Tasks.Unregular.composite_not_possible`），二者各持守对方所用者时相合，'
    '充分而非必要（`Tasks.Delivers.serial_holding`、`Tasks.CatalysedSeries.performs_pair`），交错即给出之'
    '（`Tasks.Possible.parallel_within`），于一交错之内及交付改变其任务所未列者时合成失败'
    '（`Tasks.ResettingInterleaved.composition_fails_within`、`Tasks.Resetting.composition_fails`）；可加之模式与划分'
    '（`Tasks.Conserved.additive_pattern`、`Tasks.Conserved.performs_with_one`）；执行者之塔上之回归（`Tasks.tower_reach_held`、'
    '`Tasks.tower_delivers_iff_held`、`Tasks.tower_made_held`、`Tasks.FlipTower.not_held`）；持守该部分时所能为者仅于该部分改变处增长'
    '（`Tasks.changes_of_partHeldGrows`）；交付不给全部可能增添任何东西（`Tasks.Delivers.adds_nothing`），扩大于两向皆不随交付'
    '（`Reaching.widensOrLater_iff_of_reach`、`Tasks.RiseTask.widens`、`Tasks.FallTask.widens_back`、'
    '`Tasks.Catalysis.not_widensOrLater`）；近乎定义 |')
print('integrated: Becoming.Tasks joined (root import and L1 bullet, checker core list and scope, README rows EN and '
      'ZH); no landed module changed')
