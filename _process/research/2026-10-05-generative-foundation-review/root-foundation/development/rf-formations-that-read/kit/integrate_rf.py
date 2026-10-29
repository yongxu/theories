#!/usr/bin/env python3
"""RF round 1: join Becoming.ShownOrder (on the grammar), Becoming.Unread and Becoming.Cascade (on Learning's
lumping laws) to the core as leaves at L1. Copies the three new modules (no landed module changes); adds them to the
checker's core list (ShownOrder after Becoming.GrammarTransport, Unread and Cascade after Becoming.Learning) and its
scope text (ShownOrder's sentence before GrammarPath's, Unread's and Cascade's before Learning's); imports them in the
root module, each with an L1 doc bullet (ShownOrder's before Ideals', after GrammarTransport's; Unread's and Cascade's
before PropositionIdentity's, after Learning's); adds the package README rows (EN, ZH) after GrammarTransport's and
Learning's rows. None names an ethical predicate, and no import closure holds an L2 module. Every backticked name the
texts cite from the three modules is checked against the scratch build's axiom audits, so a renamed declaration fails
here and not at render. Mirrors WRT2's integrate_wrt2.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_rf.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE / 'tree/Becoming'
MODULES = ('ShownOrder', 'Unread', 'Cascade')
AUDITS = [HERE / f'tree/.build/Becoming{m}AxiomAudit.lean' for m in MODULES]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set()
for audit in AUDITS:
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$', audit.read_text(encoding='utf-8'), re.M))
OURS = ('ChoiceOccasions.', 'Turns.', 'Learning.free_lumped', 'Learning.twin_selected', 'Learning.state_apart',
        'Learning.coupling_apart', 'Learning.Cue.')


def cited(text):
    """Every backticked name of the three modules the text cites is one of their declarations."""
    found = set(re.findall(r'`((?:ChoiceOccasions|Turns|Learning)\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if n.startswith(OURS) and n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the new modules
for name in MODULES:
    target = PKG / f'Becoming/{name}.lean'
    assert not target.exists(), target
    shutil.copyfile(TREE / f'{name}.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.GrammarTransport", "Becoming.World"',
     '"Becoming.GrammarTransport", "Becoming.ShownOrder", "Becoming.World"')
edit(checker, '"Becoming.Learning", "Becoming.PropositionIdentity"',
     '"Becoming.Learning", "Becoming.Unread", "Becoming.Cascade", "Becoming.PropositionIdentity"')
edit(checker, """    "GrammarPath: a line under a class that must pass through a set holds a member of it alike to its start; \"""",
     """    "ShownOrder: every transitive relation in which what is chosen stands above every other open alternative "
    "contains the reach of the relation the choices show; some strict order does exactly where nothing shown returns; "
    "then the positive comparisons every such order shares are exactly the shown reach, and beyond that reach no "
    "comparison is forced; reach with one pair added is reach without it or a path through the pair, and adding a "
    "pair leaves no cycle exactly where there was none and the pair's second member neither is nor reaches its first; "
    "choices required only to be maximal force no positive comparison; one search run with either of two orders "
    "according with one choice chooses alike on the menu met and apart on a menu met after. "
    "GrammarPath: a line under a class that must pass through a set holds a member of it alike to its start; \"""")
edit(checker, """    "Learning: given two values, two courses share the record before any step and differ at it, also \"""",
     """    "Unread: where no read occasion is lumped with x, the class going alike across the lumping is free at x beyond "
    "the readings, so every act law a selection through agreement on the readings selects has, for every value, a "
    "selected twin agreeing with it on every reading and taking that value at x, being in x's lump decided; for fixed "
    "maps from coupling to state to act, acts apart come from states apart and states apart from couplings apart, "
    "neither converse holding; in the cue witness a formation coupled into the cue has a selected twin at an unread "
    "occasion, and among laws reading only the content the act there is fixed. "
    "Cascade: members acting in turn on their own couplings and the acts before them; from the member on whom every "
    "later member reads only the acts before it, every act is alike across worlds alike through the earlier members' "
    "couplings, so every selection through the acts is one through those couplings, an upper bound on what the acts "
    "carry; after the same acts a member acts differently in two worlds exactly where its law tells apart the values "
    "they give its coupling; copying the first act carries only the first member's coupling. "
    "Learning: given two values, two courses share the record before any step and differ at it, also \"""")

# the root module: imports, and the new bullets
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.GrammarTransport\n', 'import Becoming.GrammarTransport\nimport Becoming.ShownOrder\n')
edit(root, 'import Becoming.Learning\n', 'import Becoming.Learning\nimport Becoming.Unread\nimport Becoming.Cascade\n')
edit(root, "* `Becoming.Ideals` (L1):", """* `Becoming.ShownOrder` (L1): what choices show of the order they come from, on the grammar. The
  choices show `x` above `y` where `x` was chosen while `y`, another, was open
  (`ChoiceOccasions.Shown`); every transitive relation according with them contains the shown reach
  (`ChoiceOccasions.reach_within`); some strict order accords exactly where nothing shown returns
  (`ChoiceOccasions.accorded_iff_noCycle`), and then the positive comparisons every such order shares
  are exactly the shown reach (`ChoiceOccasions.above_in_every_iff_reach`), a narrower class making
  at least those (`ChoiceOccasions.above_in_class_of_every`), with no comparison forced beyond it
  (`ChoiceOccasions.above_in_some_of_unreached`, `ChoiceOccasions.both_ways_of_unreached`, through
  `ChoiceOccasions.reach_withPair_iff` and `ChoiceOccasions.noCycle_withPair_iff`); choices required
  only to be maximal force no positive comparison (`ChoiceOccasions.weakly_forces_no_comparison`);
  one search, two orders according with one choice, alike on the menu met and apart after
  (`ChoiceOccasions.Untried.same_search_met`, `ChoiceOccasions.Untried.same_search_after`). A leaf
  (board item RF).
* `Becoming.Ideals` (L1):""")
edit(root, "* `Becoming.PropositionIdentity` (L1):", """* `Becoming.Unread` (L1): what readings fix of what is not read. With being in `x`'s lump decided,
  where no read occasion is lumped with `x`, the class going alike across the lumping is free at `x`
  beyond the readings (`Learning.free_lumped`), so every act law reading through the lumping that a
  selection through agreement on the readings selects has, for every value, a selected twin agreeing
  on every reading and taking that value at `x` (`Learning.twin_selected`); in a one-occasion example
  read where `P` holds, fixed exactly where `¬¬P` (`Learning.determines_iff_not_not`); for fixed maps
  from coupling to state to act, acts apart come from states apart and states apart from couplings
  apart (`Learning.state_apart_of_acts_apart`, `Learning.coupling_apart_of_state_apart`), neither
  converse holding, by a witness (`Learning.Cue.apart_with_content_alike`).
  A leaf (board item RF).
* `Becoming.Cascade` (L1): readers reading readers. Members act in turn on their own couplings and
  the acts before them (`Turns`); where every member from member `k` on, `k` included, acts alike
  whatever its own coupling on every list of earlier acts, every act is alike across worlds alike
  through the couplings of the members before `k` (`Turns.acts_alike_of_cascade`), so every
  selection through the acts is one through those couplings (`Turns.cascade_through`), an upper
  bound on what the acts carry; copying carries only the first member's coupling
  (`Turns.Copying.reaches_first_only`). A leaf (board item RF).
* `Becoming.PropositionIdentity` (L1):""")


def readme_row(path, after, row, absent):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(after)]
    assert len(at) == 1, (after, at)
    assert not any(absent in line for line in lines), absent
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


SO_EN = '| L1 | [`Becoming.ShownOrder`](Becoming/ShownOrder.lean) | what choices show of the order they come from (no premise, on the grammar): every transitive relation according with the choices contains the shown reach (`ChoiceOccasions.reach_within`); a strict order accords exactly where nothing shown returns (`ChoiceOccasions.accorded_iff_noCycle`); then the positive comparisons every such order shares are exactly the shown reach (`ChoiceOccasions.above_in_every_iff_reach`), a narrower class making at least those (`ChoiceOccasions.above_in_class_of_every`), and none is forced beyond it (`ChoiceOccasions.above_in_some_of_unreached`, `ChoiceOccasions.both_ways_of_unreached`); choices required only to be maximal force no positive comparison (`ChoiceOccasions.weakly_forces_no_comparison`); one search with two orders, alike on the menu met and apart after (`ChoiceOccasions.Untried.same_search_met`, `ChoiceOccasions.Untried.same_search_after`); near-definitional |'
SO_ZH = '| L1 | [`Becoming.ShownOrder`](Becoming/ShownOrder.lean) | 所择所示之序（不加前提，于文法上）：凡与诸择相合之传递关系皆含所示之及（`ChoiceOccasions.reach_within`）；所示无环恰为有严序与之合（`ChoiceOccasions.accorded_iff_noCycle`）；其时每一此序所共有之正比较恰为所示之及（`ChoiceOccasions.above_in_every_iff_reach`），较窄之类至少作此诸比较（`ChoiceOccasions.above_in_class_of_every`），其外无比较为所迫（`ChoiceOccasions.above_in_some_of_unreached`、`ChoiceOccasions.both_ways_of_unreached`）；唯求极大之择不迫任何正比较（`ChoiceOccasions.weakly_forces_no_comparison`）；一搜以二序行之，于所遇之单同择，于其后之单异择（`ChoiceOccasions.Untried.same_search_met`、`ChoiceOccasions.Untried.same_search_after`）；近乎定义 |'
UN_EN = "| L1 | [`Becoming.Unread`](Becoming/Unread.lean) | what readings fix of what is not read (no premise): with being in `x`'s lump decided, where no read occasion is lumped with `x`, the lumped class is free at `x` beyond the readings (`Learning.free_lumped`), so every act law reading through the lumping that a selection through agreement on the readings selects has, for every value, a selected twin agreeing on every reading and taking that value at `x` (`Learning.twin_selected`); in a one-occasion example read where `P` holds, fixed exactly where `¬¬P` (`Learning.determines_iff_not_not`); acts apart from states apart, states apart from couplings apart (`Learning.state_apart_of_acts_apart`, `Learning.coupling_apart_of_state_apart`), neither converse holding, by a witness (`Learning.Cue.apart_with_content_alike`); near-definitional |"
UN_ZH = '| L1 | [`Becoming.Unread`](Becoming/Unread.lean) | 读处所定于未读处者（不加前提）：「在 `x` 之归并中」可判定，未有读处与 `x` 同归处，归并之类于读处之外在 `x` 为自由（`Learning.free_lumped`），故凡经读处之合而选者所选之经归并而读之行律，于每一值皆有所选之孪生，于每一读处与之合而于 `x` 取此值（`Learning.twin_selected`）；一时之例，`P` 成立处为读，则所定恰当 `¬¬P`（`Learning.determines_iff_not_not`）；行之异出于态之异，态之异出于耦合之异（`Learning.state_apart_of_acts_apart`、`Learning.coupling_apart_of_state_apart`），其逆皆不成，有例（`Learning.Cue.apart_with_content_alike`）；近乎定义 |'
CA_EN = "| L1 | [`Becoming.Cascade`](Becoming/Cascade.lean) | readers reading readers (no premise): where every member from member `k` on, `k` included, acts alike whatever its own coupling on every list of earlier acts, every act is alike across worlds alike through the couplings of the members before `k` (`Turns.acts_alike_of_cascade`), so every selection through the acts is one through those couplings (`Turns.cascade_through`), an upper bound; copying carries only the first member's coupling (`Turns.Copying.reaches_first_only`); near-definitional |"
CA_ZH = '| L1 | [`Becoming.Cascade`](Becoming/Cascade.lean) | 读者读读者（不加前提）：自第 `k` 员起（含第 `k` 员），每员于每一前行之列皆不论其耦合而同行，则凡于第 `k` 员前诸员之耦合无别之二世界，每一行皆同（`Turns.acts_alike_of_cascade`），故凡经诸行之选择皆经彼诸耦合（`Turns.cascade_through`）；相仿者唯及于首一成员（`Turns.Copying.reaches_first_only`）；近乎定义 |'
readme_row(PKG / 'README.md', '| L1 | [`Becoming.GrammarTransport`]', SO_EN, '[`Becoming.ShownOrder`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.GrammarTransport`]', SO_ZH, '[`Becoming.ShownOrder`]')
readme_row(PKG / 'README.md', '| L1 | [`Becoming.Learning`]', UN_EN, '[`Becoming.Unread`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.Learning`]', UN_ZH, '[`Becoming.Unread`]')
readme_row(PKG / 'README.md', '| L1 | [`Becoming.Unread`]', CA_EN, '[`Becoming.Cascade`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.Unread`]', CA_ZH, '[`Becoming.Cascade`]')
print('integrated: Becoming.ShownOrder, Becoming.Unread and Becoming.Cascade joined (root imports and L1 bullets, '
      'checker core list and scope, README rows EN and ZH); no landed module changed')
