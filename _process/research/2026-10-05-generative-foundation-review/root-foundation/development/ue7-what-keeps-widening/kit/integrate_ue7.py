#!/usr/bin/env python3
"""UE7: join Becoming.KeepingWidening to the core and apply board rule 9 in the four modules whose landed laws are now
proved from general ones (Population, Novelty, Gain, Admission). Copies the new module; applies the four patches of
patches/ with `git apply --3way` (each a full-index diff from the file's base blob, so changes landed on main since
survive; a conflict stops the run); adds the module to the checker's core list (after Becoming.Gain, the last of its
imports there) and its scope text (after EventualWideningInstances'); imports it in the root module with an L2 doc
bullet (it imports Becoming.MapInstances, an L2 module), revises the bullets the change makes incomplete or untrue
(EventualWideningInstances' provisional carrier property, Admission's passing on, Novelty's list form, Population's
count); adds the package README rows (EN, ZH) and revises EventualWideningInstances' rows. Mirrors OU3b's
integrate_ou3b.py and UE4's integrate_ue4.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue7.py"""
import shutil
import subprocess
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
PATCHES = HERE.parent / 'patches'
PKG_REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PKG = ROOT / PKG_REL
CHANGED = ('Population', 'Novelty', 'Gain', 'Admission')


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# the new module
target = PKG / 'Becoming/KeepingWidening.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'KeepingWidening.lean', target)

# the four changed modules, as patches merged three ways onto the current files
paths = [f'{PKG_REL}/Becoming/{m}.lean' for m in CHANGED]
dirty = subprocess.run(['git', 'status', '--porcelain', '--', *paths], cwd=ROOT, capture_output=True, text=True).stdout
assert not dirty, ('changed modules not clean before the patches', dirty)
for name in CHANGED:
    r = subprocess.run(['git', 'apply', '--3way', '--whitespace=nowarn', str(PATCHES / f'{name}.patch')],
                       cwd=ROOT, capture_output=True, text=True)
    assert r.returncode == 0, (name, r.stdout, r.stderr)
    merged = (ROOT / f'{PKG_REL}/Becoming/{name}.lean').read_text(encoding='utf-8')
    assert '<<<<<<<' not in merged and '>>>>>>>' not in merged, name
    same = merged == (TREE / f'{name}.lean').read_text(encoding='utf-8')
    print(f'{name}: applied ({"identical to the kit tree" if same else "merged with changes landed since its base"})')
# --3way stages what it applies; leave the index as it was, so the landing commits by paths as usual
subprocess.run(['git', 'reset', '-q', '--', *paths], cwd=ROOT, check=True)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Gain", ', '"Becoming.Gain", "Becoming.KeepingWidening", ')
edit(checker, """    "the opened with no widening, and of ranking by carriers reversing widening. "
    "Standpoints: """, """    "the opened with no widening, and of ranking by carriers reversing widening. "
    "KeepingWidening: a course keeping widening by name on the actual levels, what its formations require "
    "fixed within a finite family, lists steps with pairwise distinct configurations of every length, so "
    "the family's stock passes every bound and rises at arbitrarily late steps, and under the first law "
    "the rest gives it net or it is open at arbitrarily late steps; a finite balanced world under the "
    "first law has no such course; under upkeep its takers are more without end, and with balance its "
    "replenishment, and with bounded giving its renewers, are bounded from no step on; opened by the "
    "opened within a recency bound, the form the uniform law of support passing on gives, with its "
    "laws, the first form's independence from it and the restated witnesses; the map reads nothing "
    "lost as an endless line of the admitted pattern, by name kept and never wholly generating, and "
    "along carrying on or passing support a carrying renewal is a passing of support, every supported "
    "endless line wholly generating where supports are brief; under the World premises nothing keeps "
    "opening along passing of support; witnesses that each premise is needed. "
    "Standpoints: """)

# the root module: import, the new bullet after EventualWideningInstances', and the bullets the change revises
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Gain\n', 'import Becoming.Gain\nimport Becoming.KeepingWidening\n')
edit(root, """  mixed with it in every tail (`LagWitness.lag`). Opened by the opened, a provisional property of
  what carries a range (`Flow.OpenedByOpened`): one range is carried by a relay of openings or by""",
     """  mixed with it in every tail (`LagWitness.lag`). Opened by the opened in its first form, at a fixed
  origin (`Flow.OpenedByOpened`), superseded by `Becoming.KeepingWidening`'s recency form, which the
  uniform law of support passing on gives: one range is carried by a relay of openings or by""")
edit(root, """  (`Saturated.reverses`). A leaf: an instance module and models (board item UE4).
* `Becoming.Growth` (L1):""", """  (`Saturated.reverses`). A leaf: an instance module and models (board item UE4).
* `Becoming.KeepingWidening` (L2, through `Becoming.MapInstances`): what a range that keeps
  widening needs, and what carries it. A course keeping widening by name on the actual levels, what
  its formations require fixed within a finite family, lists steps with pairwise distinct
  configurations of every length (`Web.KeepsWidening.distinct_configs`), so by Novelty's list form
  the family's stock passes every bound and rises at arbitrarily late steps
  (`Web.KeepsWidening.passes_every_bound`, `Web.KeepsWidening.rises_late`); under the first law the
  rest gives it net or it is open at arbitrarily late steps (`Web.KeepsWidening.from_rest_or_open`),
  and a finite balanced world under the first law has no such course
  (`Flow.whole_not_keepsWidening`). Under upkeep its takers are more without end
  (`Web.KeepsWidening.more`), and with balance its replenishment, with bounded giving its renewers,
  are bounded from no step on (`Web.KeepsWidening.renewers_unbounded`). Opened by the opened within
  a recency bound (`Flow.OpenedByOpenedWithin`) is the form Admission's uniform law of support
  passing on gives; brief supports give it, and it and UE4's form are independent
  (`OpeningChain.forms_independent`). The map reads nothing lost as an endless line of the admitted
  pattern (`Web.includesAcrossFrom_iff_endless`); along carrying on or passing support a carrying
  renewal is a passing of support (`Flow.passesSupport_carries_iff`) and brief supports make every
  supported endless line 全生成 (`Flow.generation_of_brief`); 全生成 is 生成 (`«全生成则生成»`).
  Under the World premises nothing keeps opening along passing of support
  (`Flow.not_keepsWidening_along_passings`), so on both readings used 全生成 and keeping widening do
  not hold together. Witnesses show each premise needed (`Ladder`, `ClosedCycle`, `OpeningChain`,
  `Loosening`, `Source`, `Saturated`). Each law is a restatement or near-definitional, and none
  compares two courses. A leaf: it joins EventualWidening with Gain, Flow and the map, which no
  landed module joins (board item UE7).
* `Becoming.Growth` (L1):""")
edit(root, """  Support gained ever later is passed on by formations that gained it later.""",
     """  Every gain is given, up to double negation, on a rising required condition by a supported
  formation taking part; where no support lasts `K + 1` steps, by one that gained support within the
  `K` steps before, so support gained ever later is passed on by formations that gained it later.""")
edit(root, """  bound returns; a family new at each of as many steps as there are configurations within a bound
  exceeds the bound at one of them, so what is new at every step exceeds every bound; no reading of a""",
     """  bound returns; a family whose configurations differ pairwise at as many listed steps as there are
  configurations within a bound exceeds the bound at one of them, consecutive steps among them, so
  what is new at every step exceeds every bound; no reading of a""")
edit(root, """  with the steps of change staying within a number, change does not recur, while a step
  after which nothing changes needs omniscience in general.""",
     """  with the steps of change staying within a number, change does not recur, while a step
  after which nothing changes needs omniscience in general. A list without repetition whose
  members each lie in another list with a positive weight is no longer than that list's
  weighted count, with no decision of equality.""")

# the package README rows (EN, ZH): the new row after EventualWideningInstances', and its row revised
readme = PKG / 'README.md'
edit(readme, "opened by the opened, provisional (`Flow.OpenedByOpened`): one range with two carriers",
     "opened by the opened in its first form (`Flow.OpenedByOpened`), superseded by "
     "`Becoming.KeepingWidening`'s recency form: one range with two carriers")
lines = readme.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.EventualWideningInstances`]')]
assert len(at) == 1, at
assert not any('[`Becoming.KeepingWidening`]' in line for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    '| L2 | [`Becoming.KeepingWidening`](Becoming/KeepingWidening.lean) | what a range that keeps widening needs, and '
    'what carries it (L2 through `Becoming.MapInstances`; no ethical predicate): a course keeping widening by name on '
    'the actual levels, what its formations require fixed within a finite family, passes every bound and rises at '
    'arbitrarily late steps (`Web.KeepsWidening.passes_every_bound`, `Web.KeepsWidening.rises_late`), and under the '
    'first law is fed by the rest or open at arbitrarily late steps (`Web.KeepsWidening.from_rest_or_open`); a finite '
    'balanced world under the first law has none (`Flow.whole_not_keepsWidening`); under upkeep its takers are more '
    'without end and its renewers bounded from no step on (`Web.KeepsWidening.more`, '
    '`Web.KeepsWidening.renewers_unbounded`); opened by the opened within a recency bound '
    '(`Flow.OpenedByOpenedWithin`), the form the uniform law of support passing on gives, independent of UE4\'s '
    '(`OpeningChain.forms_independent`); the map reads nothing lost as an endless line '
    '(`Web.includesAcrossFrom_iff_endless`), a carrying renewal along carrying on or passing support as a passing of '
    'support (`Flow.passesSupport_carries_iff`), and brief supports as 全生成 (`Flow.generation_of_brief`); under the '
    'World premises nothing keeps opening along passing of support (`Flow.not_keepsWidening_along_passings`); '
    'witnesses that each premise is needed; restatements or near-definitional, none comparing two courses |']
readme.write_text('\n'.join(lines), encoding='utf-8')

readme_zh = PKG / 'README.zh.md'
edit(readme_zh, "由已开者所开（暂定，`Flow.OpenedByOpened`）：一个范围两种承载者",
     "由已开者所开的初形（`Flow.OpenedByOpened`，已为 `Becoming.KeepingWidening` 的近期形式所取代）：一个范围两种承载者")
lines = readme_zh.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.EventualWideningInstances`]')]
assert len(at) == 1, at
assert not any('[`Becoming.KeepingWidening`]' in line for line in lines)
lines[at[0] + 1:at[0] + 1] = [
    '| L2 | [`Becoming.KeepingWidening`](Becoming/KeepingWidening.lean) | 持续扩大的范围需要什么，以及承载它者'
    '（经 `Becoming.MapInstances` 而属 L2；无伦理谓词）：按名于实有水平上持续扩大、其构成所需固定在一有限族内的进程，'
    '超出一切界并在任意晚的步上上升（`Web.KeepsWidening.passes_every_bound`、`Web.KeepsWidening.rises_late`），'
    '在第一律下于任意晚的步上由其余部分净给予或为开放（`Web.KeepsWidening.from_rest_or_open`）；第一律下有限而平衡的世界中没有这样的进程'
    '（`Flow.whole_not_keepsWidening`）；有维持时其取用者无尽增多，其更新者自无一步起有界'
    '（`Web.KeepsWidening.more`、`Web.KeepsWidening.renewers_unbounded`）；在一近期界内由已开者所开'
    '（`Flow.OpenedByOpenedWithin`），即支撑传递之一致律所给的形式，与 UE4 的形式彼此独立（`OpeningChain.forms_independent`）；'
    '图谱把无失读作所纳模式的不穷之线（`Web.includesAcrossFrom_iff_endless`），沿“延续或传递支撑”把承载之更新读作支撑之传递'
    '（`Flow.passesSupport_carries_iff`），支撑短暂时读作全生成（`Flow.generation_of_brief`）；在世界前提下，沿支撑之传递无一持续开出'
    '（`Flow.not_keepsWidening_along_passings`）；各前提皆必需的见证；皆为重述或近乎定义，无一比较两个进程 |']
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.KeepingWidening joined (root import and bullet, checker core list and scope, README rows '
      'EN and ZH); Population, Novelty, Gain and Admission patched (board rule 9); bullets revised')
