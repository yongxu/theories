#!/usr/bin/env python3
"""UE10: join Becoming.ReachableRanges to the core as a leaf. Copies the new module (no landed module changes: the chain
law both ways for keeping widening by name and the two-run form of a law's runs stay in the leaf, NOTE §5); adds it to
the checker's core list (after Becoming.ComparingCourses, the last item of UE's line) and its scope text (after
ComparingCourses'); imports it in the root module with an L1 doc bullet after ComparingCourses' (its import closure
holds no L2 module, and it names no ethical predicate); adds the package README rows (EN, ZH) after ComparingCourses'.
It also corrects the layer of two landed modules, as the re-check found (RECHECK-UE10 N6): EventualWideningInstances
imports Weightings, an L2 module, and ComparingCourses imports EventualWideningInstances, so their README rows (EN, ZH)
and root bullets say L2 through those imports, with no ethical predicate, as KeepingWidening's do. Mirrors UE9's
integrate_ue9.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue10.py"""
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
target = PKG / 'Becoming/ReachableRanges.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'ReachableRanges.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ComparingCourses", ', '"Becoming.ComparingCourses", "Becoming.ReachableRanges", ')
edit(checker, """    "admission, and leaves the two-sided pair unranked both ways. "
    "Standpoints: """, """    "admission, and leaves the two-sided pair unranked both ways. "
    "ReachableRanges: what a course keeps reachable, read on any process through what each "
    "configuration admits; a configuration covers another where every course from the other is "
    "included offset for offset by a course from it, a preorder, and widens what can be reached over "
    "it where it covers it and some course from it is included by none from the other, irreflexive "
    "and transitive; covering implies inclusion now, so widening what can be reached never ranks a "
    "configuration above one that starts a course and admits now what it does not, a premise that is "
    "needed, nor does the lexical order with the realized courses starting at their configurations; "
    "on a determined process "
    "widening what can be reached is the strict part of range inclusion of the two courses; widening "
    "what can be reached, or covering with some lag and covered back with none, is a strict partial "
    "order containing it that never ranks a configuration above one covering it and along a course "
    "ranks a successor above its predecessor exactly where same-offset widening does; on one witness "
    "it ranks a climb above a configuration wider now where same-offset widening is silent, on "
    "another it is silent both ways, and both orders satisfy C, so its verdict there is a premise "
    "beyond C; the whole "
    "possible is realizability within moves, along a course nothing is added to it, and where "
    "reachable configurations start courses covering carries it, a configuration starting no course "
    "being covered by every configuration; with a lag of one step every configuration of a course "
    "covers its successor; a chain keeping widening is held by no list, keeping widening by name "
    "being exactly such a chain, so along a course the possible within a horizon keeps widening only "
    "where no list holds the whole possible, which does not suffice; on a branching witness realized "
    "widening and "
    "widening what can be reached rank a pair oppositely; covering is inclusion of the ranges some "
    "course includes, dominance for every upward-closed criterion and carrying profiles on the frame "
    "of courses, and widening what can be reached is extension on the frame of reachable ranges; "
    "covering cannot see when a commitment is made, and on a witness the bundles realizable within "
    "every bound do not determine what can be reached together. "
    "Standpoints: """)

# the root module: import, the two layer corrections, and the new bullet after ComparingCourses'
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.ComparingCourses\n', 'import Becoming.ComparingCourses\nimport Becoming.ReachableRanges\n')
edit(root, "* `Becoming.EventualWideningInstances` (L1): eventual widening's instances and witnesses, and what\n",
     "* `Becoming.EventualWideningInstances` (L2, through `Becoming.Weightings`): eventual widening's\n"
     "  instances and witnesses, and what\n")
edit(root, '* `Becoming.ComparingCourses` (L1): what a comparison of two courses can be on what they admit.\n',
     '* `Becoming.ComparingCourses` (L2, through `Becoming.EventualWideningInstances`): what a\n'
     '  comparison of two courses can be on what they admit.\n')
edit(root, """  (board item UE9).
* `Becoming.Growth` (L1):""", """  (board item UE9).
* `Becoming.ReachableRanges` (L1): what a course keeps reachable, read on any process through what
  each configuration admits. Covering (`Reaching.Covers`) is a preorder and widening what can be
  reached (`Reaching.Widens`) is irreflexive, transitive and not covered back
  (`Reaching.Widens.trans`, `Reaching.widens_not_covered`). Covering implies inclusion now
  (`Reaching.Covers.now`), so widening what can be reached never ranks a configuration above one
  that starts a course and admits now what it does not (`Reaching.not_widens_of_wider_now`; the
  premise needed, `EndsNow.keeps_widening_above_wider_now`), nor, with the realized courses starting
  at their configurations, does the lexical order (`Reaching.not_above_wider_now`); on a determined
  process widening what can be reached is the strict part of range inclusion of the two courses
  (`Reaching.widens_iff_of_unique`). With a lag (`Reaching.CoversLater`, `Reaching.WidensWithLag`),
  widening what can be reached or widening it with a lag (`Reaching.WidensOrLater`), built as UE9's
  lagged order is, is a strict partial order containing it that never ranks a configuration above
  one covering it (`Reaching.WidensOrLater.trans`, `Reaching.WidensOrLater.not_covered`), and along
  a course it ranks a successor above its predecessor exactly where same-offset widening does
  (`Run.widensOrLater_next_iff`). It decides one witness's pair where same-offset covering is silent
  (`WiderNow.silent`, `WiderNow.decided`), not every such pair (`WiderNow.TwoSided.silent`); where
  the configuration wider now also widens what can be reached over the climb, it ranks that
  configuration above, as it must (`WiderNow.Full.not_silent`,
  `Reaching.WidensOrLater.not_reversed`). Both orders satisfy C on the frame of reachable ranges and
  differ on the first witness, so its verdict there is a premise beyond C
  (`Reaching.comparison_widens`, `Reaching.comparison_widensOrLater`,
  `WiderNow.comparison_undecided`). The whole possible is realizability within moves
  (`Reaching.possible_iff_withinMoves`); along a course nothing is added to it
  (`Run.possible_of_next`), and where reachable configurations start courses covering carries it
  (`Reaching.Covers.possible`; the premise needed, `NoCourse.widens_reversed`). With a lag of one
  step every configuration of a course covers its successor (`Run.coversLater_next`), and on a
  determined process a rise is the course one step on strictly including the course
  (`Reaching.widens_next_iff_rising`). A chain keeping widening is held by no list
  (`Reaching.KeepsWidening.not_listed`; by name, `Web.keepsWidening_iff_chain`), so along a course
  the possible within a horizon keeps widening only where no list holds the whole possible
  (`Reaching.not_keepsWidening_of_listed`), which does not suffice (`AllAtOnce.converse_fails`). On
  a branching witness realized widening and widening what can be reached rank a pair oppositely
  (`KeptAlternative.no_order_contains_both`, `KeptAlternative.no_comparison_both`); the lexical
  order (`Reaching.Lexical`) lies inside the two-tier `Lexical.Above` (`Reaching.lexical_above`,
  `Reaching.lexical_of_above_decided`). Covering is the lower preorder of the families of course
  ranges (`Reaching.covers_iff_included`, `Reaching.covers_iff_criteria`,
  `Reaching.covers_iff_carries`), and widening what can be reached is extension on the frame of
  reachable ranges (`Reaching.widens_iff_extension`); covering cannot see when a commitment is made
  (`DeferredBranching.cover_both`, `DeferredBranching.early_not_simulating_late`), and on a witness
  the bundles realizable within every bound do not determine what can be reached together
  (`KeptTogether.no_comparison_through_bundles`). Each law is near-definitional or a witness. A
  leaf: alternative comparisons and their witnesses, which no module uses and C's order does not
  adopt (board item UE10).
* `Becoming.Growth` (L1):""")


def readme_rows(path, fixes, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    for prefix, old, new in fixes:
        at = [i for i, line in enumerate(lines) if line.startswith(prefix)]
        assert len(at) == 1 and lines[at[0]].count(old) == 1, (path.name, prefix)
        lines[at[0]] = '| L2 |' + lines[at[0]][len('| L1 |'):].replace(old, new, 1)
    at = [i for i, line in enumerate(lines) if line.startswith('| L2 | [`Becoming.ComparingCourses`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.ReachableRanges`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [row]
    path.write_text('\n'.join(lines), encoding='utf-8')


# the package README rows (EN, ZH): the two layer corrections, and the new row after ComparingCourses'
readme_rows(PKG / 'README.md', [
    ('| L1 | [`Becoming.EventualWideningInstances`]',
     "eventual widening's instances and witnesses, and what carries a widening: ",
     "eventual widening's instances and witnesses, and what carries a widening (L2 through `Becoming.Weightings`; "
     "no ethical predicate): "),
    ('| L1 | [`Becoming.ComparingCourses`]',
     'what a comparison of two courses can be on what they admit (no ethical predicate): ',
     'what a comparison of two courses can be on what they admit (L2 through `Becoming.EventualWideningInstances`; '
     'no ethical predicate): ')],
    '| L1 | [`Becoming.ReachableRanges`](Becoming/ReachableRanges.lean) | what a course keeps reachable (no '
    'ethical predicate): covering (`Reaching.Covers`) is a preorder implying inclusion now '
    '(`Reaching.Covers.now`), so widening what can be reached never ranks a configuration above one that '
    'starts a course and admits now what it does not (`Reaching.not_widens_of_wider_now`), and on a determined '
    'process it is the strict part of range inclusion of the two courses (`Reaching.widens_iff_of_unique`); '
    "with a lag, built as UE9's lagged order is on families of courses (`Reaching.WidensOrLater`), it decides "
    "one witness's pair (`WiderNow.decided`), not every such pair (`WiderNow.TwoSided.silent`), and both "
    'orders satisfy C while differing there, so the verdict is a premise beyond C '
    '(`WiderNow.comparison_undecided`); along a course nothing is added to the whole possible '
    '(`Run.possible_of_next`), covering carries it where reachable configurations start courses '
    '(`Reaching.Covers.possible`), and on a determined process a rise is the course one step on strictly '
    'including the course (`Reaching.widens_next_iff_rising`); a chain keeping widening is held by no list '
    '(`Reaching.KeepsWidening.not_listed`), so along a course the possible within a horizon keeps widening '
    'only where no list holds the whole possible, which does not suffice (`AllAtOnce.converse_fails`); '
    'realized and reachable widening rank a pair oppositely on a branching witness '
    '(`KeptAlternative.no_order_contains_both`); covering is the lower preorder of the families of course '
    'ranges (`Reaching.covers_iff_included`), and widening what can be reached is extension on the frame of '
    'reachable ranges (`Reaching.widens_iff_extension`); near-definitional |')

readme_rows(PKG / 'README.zh.md', [
    ('| L1 | [`Becoming.EventualWideningInstances`]', '最终扩大的实例与见证，以及承载扩大者：',
     '最终扩大的实例与见证，以及承载扩大者（经 `Becoming.Weightings` 而属 L2；无伦理谓词）：'),
    ('| L1 | [`Becoming.ComparingCourses`]', '就所纳比较两个进程能是什么（无伦理谓词）：',
     '就所纳比较两个进程能是什么（经 `Becoming.EventualWideningInstances` 而属 L2；无伦理谓词）：')],
    '| L1 | [`Becoming.ReachableRanges`](Becoming/ReachableRang'
    'es.lean) | 进程保持可达者（无伦理谓词）：覆盖（`Reaching.Covers`）是蕴含当下之包含的预序'
    '（`Reaching.Covers.now`），故可达之扩大从不把一构型排在一起进程且当下纳其所不纳者之上（`Rea'
    'ching.not_widens_of_wider_now`），在决定性过程上它即两进程之范围包含的严格部分（`Re'
    'aching.widens_iff_of_unique`）；带滞后时，如 UE9 的滞后之序那样构于进程之族（`Re'
    'aching.WidensOrLater`），它判定一见证之一对（`WiderNow.decided`），非每一这样'
    '的对（`WiderNow.TwoSided.silent`），两序皆满足 C 而于此相异，故其判定是 C 之外之前提'
    '（`WiderNow.comparison_undecided`）；沿一进程全部可能无所增（`Run.possibl'
    'e_of_next`），可达构型皆起进程时覆盖承载之（`Reaching.Covers.possible`），决定性'
    '过程上，上升即进程后移一步严格包含进程本身（`Reaching.widens_next_iff_rising`）；持'
    '续扩大之链无列表可持（`Reaching.KeepsWidening.not_listed`），故沿一进程，一视界内'
    '之可能仅在无列表持全部可能时持续扩大，而此不足（`AllAtOnce.converse_fails`）；在一分支见证'
    '上，实现之扩大与可达之扩大对一对排序相反（`KeptAlternative.no_order_contains_bo'
    'th`）；覆盖是进程范围之族的下（Hoare）预序（`Reaching.covers_iff_included`），'
    '可达之扩大是可达范围之框上的延展（`Reaching.widens_iff_extension`）；近乎定义 |')
print('integrated: Becoming.ReachableRanges joined (root import and L1 bullet, checker core list and scope, README rows '
      'EN and ZH); EventualWideningInstances and ComparingCourses marked L2 through their imports (README EN and ZH, '
      'root bullets); no landed Lean changed')
