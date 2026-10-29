#!/usr/bin/env python3
"""RF round 1, after the cold read of the texts (evidence/REVIEW-TEXTS.md): applies the texts' fixes once to the
landing branch, and mirrors them into the kit's scripts (texts_rf.py, integrate_rf.py) so that a reland on a new main
reproduces them. Each edit is asserted to apply exactly once. The records are rebuilt by make_records_rf.py and the
study section from study_rf.txt; this script touches neither.
usage (from the checkout root of the landing worktree): python3 -B cold_read_rf.py"""
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
CH = ROOT / 'theories/becoming/chapters'
OVERVIEW = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
TEXTS, INTEGRATE = HERE / 'texts_rf.py', HERE / 'integrate_rf.py'
R1, R2, R4 = 'what-choices-show-of-an-order', 'what-readings-fix-of-the-unread', 'readers-reading-readers'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


def between(path, start, end, new):
    """Replace the text from start (included) to end (excluded), each occurring once."""
    text = path.read_text(encoding='utf-8')
    assert text.count(start) == 1 and text.count(end) == 1, (path.name, start[:60], end[:60])
    i, j = text.index(start), text.index(end)
    assert i < j, path.name
    path.write_text(text[:i] + new + text[j:], encoding='utf-8')


def placeheld(text):
    """The block as texts_rf.py's f-strings hold it: record ids through R1, R2 and R4."""
    for rid, name in ((R1, '{R1}'), (R2, '{R2}'), (R4, '{R4}')):
        text = text.replace(f'records/{rid}.md', f'records/{name}.md').replace(f'id="r-{rid}"', f'id="r-{name}"')
    return text


S11 = (HERE / 'cold-read/s11.txt').read_text(encoding='utf-8')
S5 = (HERE / 'cold-read/s5.txt').read_text(encoding='utf-8')
assert '{' not in S11 and '{' not in S5

# 03 §11 and 05 §8: the blocks whole
between(CH / '03-KNOWING.md', '<a id="what-the-acts-show"></a>', '<a id="does-not-show"></a>', S11)
between(CH / '05-COLLECTIVES.md', '<a id="r-readers-reading-readers"></a>',
        '**Reading** [AI reading, D45]. Pooling moves the gap outward', S5)
between(TEXTS, 'S11 = f"""', '"""\nedit(CH / \'03-KNOWING.md\', \'<a id="does-not-show"></a>',
        'S11 = f"""' + placeheld(S11))
between(TEXTS, 'S5 = f"""', '"""\nedit(CH / \'05-COLLECTIVES.md\'', 'S5 = f"""' + placeheld(S5))
edit(TEXTS, "OURS = ('ChoiceOccasions.', 'Turns.', 'Learning.free_lumped', 'Learning.twin_selected', 'Learning.state_apart',\n"
            "        'Learning.coupling_apart', 'Learning.Cue.')",
     "OURS = ('ChoiceOccasions.', 'Turns.', 'Learning.free_lumped', 'Learning.twin_selected', 'Learning.state_apart',\n"
     "        'Learning.coupling_apart', 'Learning.Cue.', 'Learning.determines_iff_not_not')")

# 03's Open: the regulator's adequacy is §9's; what is open is composing it with a reading kept by its own update
OPEN_OLD = ("its own update, with the good regulator's adequacy; revision that opens an executable correction;")
OPEN_NEW = ("its own update, composed with the good regulator's adequacy ([§9](#r-when-to-inquire-and-when-to-respond)); "
            "revision that opens an executable correction;")
edit(CH / '03-KNOWING.md', "- Formations that read, beyond what their acts show ([§11](#what-the-acts-show)): a formation's "
     "reading kept by " + OPEN_OLD, "- Formations that read, beyond what their acts show ([§11](#what-the-acts-show)): a "
     "formation's reading kept by " + OPEN_NEW)
edit(TEXTS, '"its own update, with the good regulator\'s adequacy; revision that opens an executable correction; a prediction "',
     '"its own update, composed with the good regulator\'s adequacy ([§9](#r-when-to-inquire-and-when-to-respond)); "\n'
     '     "revision that opens an executable correction; a prediction "')

# 03's bases: what choices show is on the root's grammar
BASES_OLD = "testing within the net and 文 are on the root's grammar."
BASES_NEW = ("testing within the net, 文 and what choices show of an order ([§11](#r-what-choices-show-of-an-order)) are on "
             "the root's grammar.")
edit(CH / '03-KNOWING.md', BASES_OLD, BASES_NEW)

# 07: the pointer, and the open row on deception
P07_OLD = ("read, is [03 §11](03-KNOWING.md#what-the-acts-show)'s; where a pool's members read only the acts before them, its "
           "acts carry no more than what couples into those read first ([05 §8](05-COLLECTIVES.md#r-readers-reading-readers)).")
P07_NEW = ("read, is [03 §11](03-KNOWING.md#what-the-acts-show)'s; what a pool's acts carry where, from some member on, every "
           "member reads only the acts before it (no more than what couples into the members before that one) is "
           "[05 §8](05-COLLECTIVES.md#r-readers-reading-readers)'s.")
edit(CH / '07-SIGNIFICANCE.md', P07_OLD, P07_NEW)
edit(TEXTS, "     f'read, is [03 §11](03-KNOWING.md#what-the-acts-show)\\'s; where a pool\\'s members read only the acts before them, its '\n"
            "     f'acts carry no more than what couples into those read first ([05 §8](05-COLLECTIVES.md#r-{R4})).\\n')",
     "     f'read, is [03 §11](03-KNOWING.md#what-the-acts-show)\\'s; what a pool\\'s acts carry where, from some member on, every '\n"
     "     f'member reads only the acts before it (no more than what couples into the members before that one) is '\n"
     "     f'[05 §8](05-COLLECTIVES.md#r-{R4})\\'s.\\n')")
ROW_OLD = ("| Which function is learned | open | the laws say where any neighbourhood rests, not which one or which lumping "
           "an actual system has, nor anything of deception |")
ROW_NEW = ("| Which function is learned | open | the laws say where any neighbourhood rests, not which one or which lumping "
           "an actual system has, nor anything of deception beyond where behaviour can differ when not read "
           f"([03 §11](03-KNOWING.md#r-{R2})) |")
edit(CH / '07-SIGNIFICANCE.md', ROW_OLD, ROW_NEW)

# 08 §8: the known results the three laws restate
K08_AFTER = "- A world's reorderings as courses of growth ([01 §9.6](01-ROOT.md#r-reorderings-as-courses-of-growth))"
K08 = (f"- What choices show of an order ([03 §11](03-KNOWING.md#r-{R1})) restates rationalizing strict choices by a strict "
       "partial order, close to Richter (1966) without completeness and not Afriat (1967); what readings fix of the unread "
       f"([03 §11](03-KNOWING.md#r-{R2})) is indistinguishability, with the data-processing inequality the probabilistic "
       f"form of its chain of acts, states and couplings; readers reading readers ([05 §8](05-COLLECTIVES.md#r-{R4})) is "
       "the deterministic form of an information cascade (Bikhchandani, Hirshleifer and Welch 1992; Banerjee 1992). Each "
       "law is near-definitional or a witness; what they add is their place in one account.")
lines = (CH / '08-METHOD.md').read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith(K08_AFTER)]
assert len(at) == 1 and not any(line.startswith('- What choices show of an order') for line in lines), at
lines[at[0] + 1:at[0] + 1] = [K08]
(CH / '08-METHOD.md').write_text('\n'.join(lines), encoding='utf-8')

# the overview: one paragraph in §3, one in §5
O3_BEFORE = "How a formation acquires its own map is shown on one process"
O3 = ("What a selection reading a formation's acts fixes of it is what those acts show. Proved on the root's grammar: "
      "strict choices come from some strict order exactly where nothing they show returns, and then the positive "
      "comparisons every such order shares are exactly the reach of what they show, none forced beyond it. Proved for "
      "every type: where a formation's lumping tells an occasion it is not read at from every read one, being in that "
      "lump decided, a selection through the readings that selects a law reading through the lumping also selects one "
      "taking any value there. Read as inner alignment and evaluation awareness, these locate where a trained law can "
      "choose otherwise later and where it can act otherwise unread; installation, intention and incentive are not "
      f"represented [AI reading] ([what choices show](chapters/03-KNOWING.md#r-{R1}), "
      f"[what readings fix](chapters/03-KNOWING.md#r-{R2})).\n\n")
O5_BEFORE = "Agreement on a code needs a broken symmetry"
O5 = ("Readers reading readers carry no more than the first readers took in. Proved for every type: where every member "
      "from some member on, that one included, acts alike whatever its own coupling, on every list of earlier acts, the "
      "pool's acts and every selection through them are alike across worlds alike through the couplings of the members "
      "before it, however many follow; this is the deterministic form of an information cascade, an upper bound, not the "
      f"pool's exact reach ([readers reading readers](chapters/05-COLLECTIVES.md#r-{R4})).\n\n")
edit(OVERVIEW, O3_BEFORE, O3 + O3_BEFORE)
edit(OVERVIEW, O5_BEFORE, O5 + O5_BEFORE)
NOTE_OLD = "from a cascade on, the pool reaches only the couplings of those read first; copying"
NOTE_NEW = "from a cascade on, the pool's acts carry no more than the couplings of the members before it; copying"
edit(REGIONS, NOTE_OLD, NOTE_NEW)

# texts_rf.py: the same, for a reland on a new main
edit(TEXTS, "'couplings of those read first; copying'}", "'couplings of the members before it; copying'}")
edit(TEXTS, "                      'note': 'Cascade RF4: readers reading readers; from a cascade on, the pool reaches only the '\n"
            "                              'couplings of the members before it; copying'}",
     "                      'note': 'Cascade RF4: readers reading readers; from a cascade on, the pool\\'s acts carry no '\n"
     "                              'more than the couplings of the members before it; copying'}")
MORE = f'''
# after the cold read (cold_read_rf.py): 03's bases, 07's open row, 08 §8's known results, the overview
edit(CH / '03-KNOWING.md', {BASES_OLD!r},
     {BASES_NEW!r})
edit(CH / '07-SIGNIFICANCE.md', {ROW_OLD!r},
     {ROW_NEW!r})
lines08 = (CH / '08-METHOD.md').read_text(encoding='utf-8').split('\\n')
at08 = [i for i, line in enumerate(lines08) if line.startswith({K08_AFTER!r})]
assert len(at08) == 1, at08
lines08[at08[0] + 1:at08[0] + 1] = [{K08!r}]
(CH / '08-METHOD.md').write_text('\\n'.join(lines08), encoding='utf-8')
OVERVIEW = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
edit(OVERVIEW, {O3_BEFORE!r}, {O3!r} + {O3_BEFORE!r})
edit(OVERVIEW, {O5_BEFORE!r}, {O5!r} + {O5_BEFORE!r})
'''
edit(TEXTS, "\n# 08: receipt and counts, every count read from the receipt (as texts_wrt2.py)\n",
     MORE + "\n# 08: receipt and counts, every count read from the receipt (as texts_wrt2.py)\n")

# the package README rows and the root's bullets, here and in integrate_rf.py
ROWS = {
    '[`Becoming.ShownOrder`]': (
        '| L1 | [`Becoming.ShownOrder`](Becoming/ShownOrder.lean) | what choices show of the order they come from (no '
        'premise, on the grammar): every transitive relation according with the choices contains the shown reach '
        '(`ChoiceOccasions.reach_within`); a strict order accords exactly where nothing shown returns '
        '(`ChoiceOccasions.accorded_iff_noCycle`); then the positive comparisons every such order shares are exactly the '
        'shown reach (`ChoiceOccasions.above_in_every_iff_reach`), a narrower class making at least those '
        '(`ChoiceOccasions.above_in_class_of_every`), and none is forced beyond it '
        '(`ChoiceOccasions.above_in_some_of_unreached`, `ChoiceOccasions.both_ways_of_unreached`); choices required only '
        'to be maximal force no positive comparison (`ChoiceOccasions.weakly_forces_no_comparison`); one search with two '
        'orders, alike on the menu met and apart after (`ChoiceOccasions.Untried.same_search_met`, '
        '`ChoiceOccasions.Untried.same_search_after`); near-definitional |',
        '| L1 | [`Becoming.ShownOrder`](Becoming/ShownOrder.lean) | 所择所示之序（不加前提，于文法上）：凡与诸择相合之传递关系皆含所示之及'
        '（`ChoiceOccasions.reach_within`）；所示无环恰为有严序与之合（`ChoiceOccasions.accorded_iff_noCycle`）；其时每一此序所共有之正比较恰为'
        '所示之及（`ChoiceOccasions.above_in_every_iff_reach`），较窄之类至少作此诸比较（`ChoiceOccasions.above_in_class_of_every`），其外无比较'
        '为所迫（`ChoiceOccasions.above_in_some_of_unreached`、`ChoiceOccasions.both_ways_of_unreached`）；唯求极大之择不迫任何正比较'
        '（`ChoiceOccasions.weakly_forces_no_comparison`）；一搜以二序行之，于所遇之单同择，于其后之单异择'
        '（`ChoiceOccasions.Untried.same_search_met`、`ChoiceOccasions.Untried.same_search_after`）；近乎定义 |'),
    '[`Becoming.Unread`]': (
        '| L1 | [`Becoming.Unread`](Becoming/Unread.lean) | what readings fix of what is not read (no premise): with being '
        'in `x`\'s lump decided, where no read occasion is lumped with `x`, the lumped class is free at `x` beyond the '
        'readings (`Learning.free_lumped`), so every act law reading through the lumping that a selection through '
        'agreement on the readings selects has, for every value, a selected twin agreeing on every reading and taking '
        'that value at `x` (`Learning.twin_selected`); for a schedule not given as a list, fixing up to a double negation '
        '(`Learning.determines_iff_not_not`); acts apart from states apart, states apart from couplings apart '
        '(`Learning.state_apart_of_acts_apart`, `Learning.coupling_apart_of_state_apart`), neither converse holding, by a '
        'witness (`Learning.Cue.apart_with_content_alike`); near-definitional |',
        '| L1 | [`Becoming.Unread`](Becoming/Unread.lean) | 读处所定于未读处者（不加前提）：「在 `x` 之归并中」可判定，未有读处与 `x` 同归处，'
        '归并之类于读处之外在 `x` 为自由（`Learning.free_lumped`），故凡经读处之合而选者所选之经归并而读之行律，于每一值皆有所选之孪生，于每一读处'
        '与之合而于 `x` 取此值（`Learning.twin_selected`）；读时不以列给，则所定唯至二重否定（`Learning.determines_iff_not_not`）；行之异出于'
        '态之异，态之异出于耦合之异（`Learning.state_apart_of_acts_apart`、`Learning.coupling_apart_of_state_apart`），其逆皆不成，有例'
        '（`Learning.Cue.apart_with_content_alike`）；近乎定义 |'),
    '[`Becoming.Cascade`]': (
        '| L1 | [`Becoming.Cascade`](Becoming/Cascade.lean) | readers reading readers (no premise): where every member from '
        'member `k` on, `k` included, acts alike whatever its own coupling on every list of earlier acts, every act is '
        'alike across worlds alike through the couplings of the members before `k` (`Turns.acts_alike_of_cascade`), so '
        'every selection through the acts is one through those couplings (`Turns.cascade_through`), an upper bound; '
        'copying carries only the first member\'s coupling (`Turns.Copying.reaches_first_only`); near-definitional |',
        '| L1 | [`Becoming.Cascade`](Becoming/Cascade.lean) | 读者读读者（不加前提）：自第 `k` 员起（含第 `k` 员），每员于每一前行之列皆不论其耦合'
        '而同行，则凡于第 `k` 员前诸员之耦合无别之二世界，每一行皆同（`Turns.acts_alike_of_cascade`），故凡经诸行之选择皆经彼诸耦合'
        '（`Turns.cascade_through`）；相仿者唯及于首一成员（`Turns.Copying.reaches_first_only`）；近乎定义 |'),
}
for key, (en, zh) in ROWS.items():
    for path, row in ((PKG / 'README.md', en), (PKG / 'README.zh.md', zh)):
        lines = path.read_text(encoding='utf-8').split('\n')
        at = [i for i, line in enumerate(lines) if line.startswith('| L1 | ' + key)]
        assert len(at) == 1, (path.name, key, at)
        old = lines[at[0]]
        lines[at[0]] = row
        path.write_text('\n'.join(lines), encoding='utf-8')
        name = {'[`Becoming.ShownOrder`]': 'SO', '[`Becoming.Unread`]': 'UN', '[`Becoming.Cascade`]': 'CA'}[key]
        lang = 'EN' if path.name == 'README.md' else 'ZH'
        text = INTEGRATE.read_text(encoding='utf-8')
        start = text.index(f'{name}_{lang} = (')
        end = text.index('\n', text.index(" |')", start)) + 1
        INTEGRATE.write_text(text[:start] + f'{name}_{lang} = {row!r}\n' + text[end:], encoding='utf-8')

BULLETS = {
    "* `Becoming.ShownOrder` (L1):": """* `Becoming.ShownOrder` (L1): what choices show of the order they come from, on the grammar. The
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
""",
    "* `Becoming.Unread` (L1):": """* `Becoming.Unread` (L1): what readings fix of what is not read. With being in `x`'s lump decided,
  where no read occasion is lumped with `x`, the class going alike across the lumping is free at `x`
  beyond the readings (`Learning.free_lumped`), so every act law reading through the lumping that a
  selection through agreement on the readings selects has, for every value, a selected twin agreeing
  on every reading and taking that value at `x` (`Learning.twin_selected`); for a schedule not given
  as a list, fixing holds up to a double negation (`Learning.determines_iff_not_not`); for fixed maps
  from coupling to state to act, acts apart come from states apart and states apart from couplings
  apart (`Learning.state_apart_of_acts_apart`, `Learning.coupling_apart_of_state_apart`), neither
  converse holding, by a witness (`Learning.Cue.apart_with_content_alike`).
  A leaf (board item RF).
""",
    "* `Becoming.Cascade` (L1):": """* `Becoming.Cascade` (L1): readers reading readers. Members act in turn on their own couplings and
  the acts before them (`Turns`); where every member from member `k` on, `k` included, acts alike
  whatever its own coupling on every list of earlier acts, every act is alike across worlds alike
  through the couplings of the members before `k` (`Turns.acts_alike_of_cascade`), so every
  selection through the acts is one through those couplings (`Turns.cascade_through`), an upper
  bound on what the acts carry; copying carries only the first member's coupling
  (`Turns.Copying.reaches_first_only`). A leaf (board item RF).
""",
}
for head, bullet in BULLETS.items():
    for path in (PKG / 'Becoming.lean', INTEGRATE):
        text = path.read_text(encoding='utf-8')
        assert text.count(head) == 1, (path.name, head)
        start = text.index(head)
        end = text.index('\n* `', start + 1) + 1
        path.write_text(text[:start] + bullet + text[end:], encoding='utf-8')
print('cold read: 03 §11, Open, bases; 05 §8; 07 pointer and row; 08 §8; overview §3, §5; regions; README rows; root '
      'bullets; texts_rf.py and integrate_rf.py mirrored')
