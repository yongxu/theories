#!/usr/bin/env python3
"""UE11: join Becoming.HeldPossible to the core as a leaf. Copies the new module (no landed module changes: the two
instance theorems for Onward's `within` and Branching's `keeping`, the laws of reach and traces under the held moves,
`adaptive_keeps_rule_iff` and the root law «及在渐粗列之相续» stay in the leaf, NOTE §5); adds it to the checker's core
list (after Becoming.ReachableRanges, UE10's module) and its scope text (after ReachableRanges'); imports it in the root
module with an L1 doc bullet after ReachableRanges' (its import closure holds no L2 module, and it names no ethical
predicate); adds the package README rows (EN, ZH) after ReachableRanges'. With it rides one docstring correction in a
landed module (DF's LEFT.md, for UE1b's owner): SelectionPool's `anticipates_iff` cites `Revision.web_keeps_iff`,
whose name is `Registration.web_keeps_iff` (in Revision.lean); no statement or proof changes. Mirrors UE10's
integrate_ue10.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue11.py"""
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
target = PKG / 'Becoming/HeldPossible.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'HeldPossible.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ReachableRanges", ', '"Becoming.ReachableRanges", "Becoming.HeldPossible", ')
edit(checker, """    "every bound do not determine what can be reached together. "
    "Standpoints: """, """    "every bound do not determine what can be reached together. "
    "HeldPossible: where the possible grows, read on any process through what each configuration "
    "admits; a move adds nothing to the possible under its process, so where that possible keeps "
    "widening along a course, from every step some bounded stretch is not made of its moves, and "
    "along a course that comes back to one configuration without end nothing keeps widening; the "
    "possible with a part held, under the moves holding the part, is included in the whole possible, "
    "grows only across a step changing the part, gains nothing from the step at which the part stays "
    "for good, and keeps widening only where the part changes without end, located where holding is "
    "decided, and no list holds the whole possible, which does not suffice; on the root the moves "
    "holding a relation are its continuations and what they reach is the start or its line, and for "
    "a class holding it move by move is holding it as at the start, not in general; a rule changing "
    "its own rule keeps it exactly where the rule leaves it, so the possible with the rule held keeps "
    "widening only where the rule changes without end; reach over a sequence of relations growing "
    "coarser that each step meets lies on a line under one of them, so every possibility of a tower "
    "of rules with no top, each move keeping the rules from some height up, is had with the rules "
    "from some height up held, while a tower changing every rule at once has a possibility needing "
    "the whole tower; where the possible with the rules from a height up held keeps widening, moves "
    "above that height recur, and every origin of it passes such a move; on witnesses the possible "
    "relative to a raised rule, and relative to every height of a tower copying down, keeps widening "
    "while every formation stays possible and every moment ceases under what is held, and with the "
    "rule raised at every other step renewal without end holds as well. "
    "Standpoints: """)

# the root module: import, and the new bullet after ReachableRanges'
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.ReachableRanges\n', 'import Becoming.ReachableRanges\nimport Becoming.HeldPossible\n')
edit(root, """  adopt (board item UE10).
* `Becoming.Growth` (L1):""", """  adopt (board item UE10).
* `Becoming.HeldPossible` (L1): where the possible grows, read on any process through what each
  configuration admits. A move adds nothing to the possible under its process
  (`Reaching.not_reach_of_grows`, `Reaching.not_step_of_grows`), so where it keeps widening along a
  course, from every step some bounded stretch is not made of the process's moves
  (`Run.possible_of_stretch`, `Run.departs_of_keepsWidening`), and along a course that comes back to
  one configuration without end nothing keeps widening (`Run.not_keepsWidening_of_returns`). With a
  part held, read through the moves holding it (`Reaching.heldMoves`, `Reaching.PossibleHeld`;
  Onward's `within` and Branching's `keeping` are instances), the possible is included in the whole
  possible (`Reaching.PossibleHeld.possible`), grows only across a step changing the part
  (`Run.changes_of_heldGrows`), gains nothing from the step at which the part stays for good
  (`Run.possibleHeld_of_stays`), and keeps widening only where the part changes without end
  (`Run.changes_of_heldKeepsWidening`; located where holding is decided,
  `Run.held_change_recurs_of_keepsWidening`) and no list holds the whole possible
  (`Run.not_heldKeepsWidening_of_listed`), which does not suffice (`Oscillating.converse_fails`); a
  course that only returns has the whole possible exceeding the actual and the held possible
  widening across a step, and does not keep it widening (`Oscillating.returning_has_both`). On the
  root the moves holding a relation are its continuations, what they reach is the start or its line
  (`Reaching.reach_heldMoves_iff`), and the possible with it held is what the line admits
  (`Reaching.possibleHeld_iff_line`); for a class, holding it move by move is holding it as at the
  start, both ways (`Reach.heldMoves_iff_sameAsStart`), not in general (`AdjacentHeld.differs`,
  `OrderHeld.differs`); and where it keeps widening, from no moment is the course's line under the
  part unending and, where holding is decided, lines under it begin after every moment
  (`Run.not_unending_of_heldKeepsWidening`, `Run.begins_of_heldKeepsWidening`). A rule changing its own rule keeps it exactly where the rule
  leaves it (`adaptive_keeps_rule_iff`), so the possible with the rule held keeps widening only where
  the rule changes without end (`Run.adaptive_rule_changes_of_keepsWidening`). Reach over a sequence
  of relations growing coarser that each step meets lies on a line under one of them
  (`«及在渐粗列之相续»`), so every possibility of a process whose moves each hold some member is had
  with some member held (`Reaching.possible_iff_held_of_sequence`): on a tower of rules with no top
  (`RuleTower.process`), each is had by changing only the state and the rules below some height
  (`RuleTower.possible_iff_held`), while a tower changing every rule at once has one needing the
  whole tower (`Synchronous.tower_law_fails`). Where the possible with the rules from height `n` up
  held keeps widening, moves above `n`, the only moves that can change a rule from height `n` up,
  recur (`Run.ruleTower_move_above_recurs_of_keepsWidening`), and every origin of it passes such a
  move (`RuleTower.held_origin`, from `Gated.origin`). On witnesses the possible relative to a raised
  rule (`RaisedRule.held_keeps_widening`), and relative to every height of a tower copying down
  (`CopyDown.held_keeps_widening`), keeps widening while every formation stays possible
  (`RaisedRule.whole_every`, `CopyDown.whole_every`) and every moment ceases under what is held
  (`RaisedRule.ceases`, `CopyDown.ceases`); with the rule raised at every other step, renewal without
  end holds as well (`RaisedEveryOther.both`). Each law is near-definitional or a witness. A leaf
  (board item UE11).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.ReachableRanges`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.HeldPossible`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [row]
    path.write_text('\n'.join(lines), encoding='utf-8')


# the package README rows (EN, ZH), after ReachableRanges'
readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.HeldPossible`](Becoming/HeldPossible.lean) | where the possible grows (no ethical '
    'predicate): a move adds nothing to the possible under its process (`Reaching.not_step_of_grows`), and along '
    'a course that comes back to one configuration without end nothing keeps widening '
    '(`Run.not_keepsWidening_of_returns`); the possible with a part held (`Reaching.PossibleHeld`, through the '
    'moves holding it, `Reaching.heldMoves`) grows only across a step changing the part '
    '(`Run.changes_of_heldGrows`), gains nothing from the step at which the part stays for good '
    '(`Run.possibleHeld_of_stays`), and keeps widening only where the part changes without end '
    '(`Run.changes_of_heldKeepsWidening`, located where holding is decided, '
    '`Run.held_change_recurs_of_keepsWidening`) and no list holds the whole possible, which does not suffice '
    '(`Oscillating.converse_fails`); on the root it is what the line under the part admits '
    '(`Reaching.possibleHeld_iff_line`), and for a class holding it move by move is holding it as at the start '
    '(`Reach.heldMoves_iff_sameAsStart`); a rule changing its own rule keeps widening the possible with it held '
    'only where it changes without end (`Run.adaptive_rule_changes_of_keepsWidening`); reach over a sequence of '
    'relations growing coarser lies on a line under one of them (`«及在渐粗列之相续»`), so every possibility of a '
    'tower of rules with no top is had with the rules from some height up held (`RuleTower.possible_iff_held`), '
    'not so for a tower changing every rule at once (`Synchronous.tower_law_fails`), and where the possible '
    'held from height `n` keeps widening, moves above `n` recur '
    '(`Run.ruleTower_move_above_recurs_of_keepsWidening`); on witnesses the possible relative to a raised rule '
    'and relative to every height of a tower keeps widening while every formation stays possible '
    '(`RaisedRule.held_keeps_widening`, `CopyDown.held_keeps_widening`) and every moment ceases under what is '
    'held (`RaisedRule.ceases`, `CopyDown.ceases`), and with the rule raised at every other step renewal without '
    'end holds as well (`RaisedEveryOther.both`); near-definitional |')

readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.HeldPossible`](Becoming/HeldPossible.lean) | 可能者于何处增长（无伦理谓词）：一步不给其过程下之'
    '可能增添任何东西（`Reaching.not_step_of_grows`），沿无尽地回到同一构型之进程无物持续扩大'
    '（`Run.not_keepsWidening_of_returns`）；持守一部分时之可能（`Reaching.PossibleHeld`，经持守之之诸步，'
    '`Reaching.heldMoves`）仅于改变该部分之步上增长（`Run.changes_of_heldGrows`），自该部分永住之步起无所增'
    '（`Run.possibleHeld_of_stays`），仅当该部分无尽地改变（`Run.changes_of_heldKeepsWidening`；持守可判定时可定位，'
    '`Run.held_change_recurs_of_keepsWidening`）且无列表持全部可能时持续扩大，而此不足（`Oscillating.converse_fails`）；'
    '于根上它即该部分下之线所纳（`Reaching.possibleHeld_iff_line`），对类而言逐步持守即如起点般持守'
    '（`Reach.heldMoves_iff_sameAsStart`）；改变自身规则之规则，持守该规则时之可能仅当该规则无尽地'
    '改变时持续扩大（`Run.adaptive_rule_changes_of_keepsWidening`）；渐粗之关系列上之及，落于其一之相续上'
    '（`«及在渐粗列之相续»`），故无顶之规则塔之每一可能，皆可于持守某高度以上诸规则时得之（`RuleTower.possible_iff_held`），'
    '同时改变每一规则之塔则不然（`Synchronous.tower_law_fails`）；持守高度 `n` 以上而可能持续扩大时，高于 `n` 之步反复出现'
    '（`Run.ruleTower_move_above_recurs_of_keepsWidening`）；于见证上，相对于逐步提升之规则、及相对于塔之每一高度，'
    '可能持续扩大而每一构成始终可能（`RaisedRule.held_keeps_widening`、`CopyDown.held_keeps_widening`），于所持守者下每一'
    '时刻皆息（`RaisedRule.ceases`、`CopyDown.ceases`），隔步提升规则时生生亦成立（`RaisedEveryOther.both`）；近乎定义 |')
# SelectionPool's docstring: the name of the theorem it cites (DF's LEFT.md)
edit(PKG / 'Becoming/SelectionPool.lean', '(`Revision.web_keeps_iff` is the case of one formation at two steps)',
     '(`Registration.web_keeps_iff` is the case of one formation at two steps)')
print('integrated: Becoming.HeldPossible joined (root import and L1 bullet, checker core list and scope, README rows '
      'EN and ZH); one landed docstring corrected (SelectionPool, a cited name); no landed statement or proof changed')
