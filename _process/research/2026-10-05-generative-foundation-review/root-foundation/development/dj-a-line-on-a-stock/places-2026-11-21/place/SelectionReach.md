# SelectionReach

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/SelectionReach.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-rise-past-the-inflow-is-drawn-from-beyond`, `raising-what-couples-in-draws-from-beyond`, `what-a-rise-draws-from-beyond`
- *dynamics in the atlas that name one of those records* (computed; not a link): `restraint-within-the-joint-slack`, `what-a-rise-draws-from-beyond`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-18, as "SelectionReach.lean: Flow.Balances.rise_le_inflow_beyond, Flow.favours_reaching_beyond_inflow, Diversion.supplying_rises_by_inflow" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-18.md.txt)); pass b: reader whole-b-69, as "SelectionReach.lean: Flow.Balances.gives_more_of_rise, Flow.Balances.rise_draws_beyond_inflow, Flow.Balances.rise_le_inflow_beyond, Flow.Balances.rise_takes_beyond, Flow.favours_reaching_beyond, Web.raises_selectsThrough, Diversion.draws_beyond" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-69.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Flow.Balances.rise_le_inflow_beyond` (l. 146) bounds a distinct subfamily’s new stock by old stock, enclosing inflow and withdrawals beyond it in a balanced flow. `Flow.favours_reaching_beyond_inflow` (l. 235) locates an uncoupled withdrawal if selection holds and entails a rise exceeding that inflow, given decidable equality, distinct nested lists and coverage of coupled conditions.
  - *pass b:* For any balanced flow, a rise of a family's stock has a formation giving it more than it takes (`Flow.Balances.gives_more_of_rise`). A rise past the inflow of a containing family, or any rise where the containing family is gainless, is drawn from beyond: some formation takes from the containing family more than from the risen one, and from a condition outside it (`rise_draws_beyond_inflow`, `rise_takes_beyond(_inflow)`, `rise_le_inflow_beyond`, `rise_paid_from_beyond`, `Gainless.rise_takes_beyond`). So every selection that holds only where the family a group couples into rises holds only where some formation takes from a condition no member couples into (`Flow.favours_reaching_beyond(_inflow)`). These are general; `Diversion` is the built instance and the built case showing the premise binds.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no Process with moves or choice among steps. The flow is supplied, and the 'selection' is a predicate on level histories, not a choice of step.
- **a reading**
  - *pass a:* S: `Web.raises_selectsThrough` (l. 270) makes a rise in a listed family’s stock selectable through any observer that observes all its conditions, by the end of the step.
  - *pass b:* S: `Web.raises_selectsThrough` (l. 270): where g observes every condition of ds, the predicate 'the stock of ds rises from t to t+1' is a selection through g's coupling up to t+1. `Flow.favours_reaching_beyond` (l. 254): given balance, distinct ds inside distinct es, es gainless at t, every condition a member couples into listed in ds, and a selection whose holding implies the rise, the selection holds only where some present formation gives ds more than it takes and takes from a condition c with no member coupled into c. B: `Diversion.draws_beyond` (l. 320).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no share among kinds, and no rule set from one.
- **a level that runs down**
  - *pass a:* S: `Flow.Balances.rise_paid_from_beyond` (l. 184) bounds next stock by old stock plus withdrawals beyond the distinct subfamily when the containing family gains nothing. It bounds withdrawals, without requiring depletion at their source.
  - *pass b:* S: a family's stock `W.stock ds t`. `Flow.Balances.rise_le_inflow_beyond` (l. 146): stock after ≤ stock before + inflow of the containing family + what present formations take from es beyond ds. `rise_paid_from_beyond` (l. 184) is the gainless case. N: no law in which what comes back depends on what is left of a running-down level.
- **a giving that is itself a going-on**
  - *pass a:* S: `Flow.Balances.gives_more_of_rise` (l. 92) obtains a participating net giver from balance and a strict rise. No loss of that giver or consequent failure of renewal is stated.
  - *pass b:* S: in `gives_more_of_rise` (l. 92) the giver is some formation f ∈ L.present t. Presence is part of the supplied Flow, and no statement here concerns a giver being lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: `Flow.Balances.rise_takes_beyond_inflow` (l. 196) requires the net giver to withdraw from an outside condition under its balance, nesting, distinctness, decidability and excess-rise hypotheses. No premise identifies that condition as the giver’s own standing.
  - *pass b:* N: the laws charge the rise to conditions beyond (what the formation takes from es outside ds), not to the formation doing it.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no point of no return or irreversibility.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no exactly-when of going on versus ending. B, as a contrast only: `Diversion.supplying_raises_untaken` (l. 346) and `Diversion.supplying_rises_by_inflow` (l. 356) show a rise with nothing taken where the gainless premise fails, against `Diversion.draws_beyond` (l. 320).
- **a comparison between two**
  - *pass a:* S: `Flow.Balances.rise_le_inflow_beyond` (l. 146) compares the subfamily’s stock change with enclosing inflow and withdrawals between the two lists under balance and distinctness of the smaller list.
  - *pass b:* S: `Web.raises_selectsThrough` (l. 270): for two level histories alike through g's coupling up to t+1, the rise holds of one iff of the other. N: no law carrying something between two processes or two ways.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no ending within a bound, falling rank or drain.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no law of a region closed under steps. `L.Around ds t` (the step enclosed around a family) and `GainlessOn` enter only as premises (`Gainless.rise_takes_beyond` l. 219, `rise_takes_beyond` l. 207).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no statement of the going on continuing while what is present changes.
- **how it was read**
  - *pass a:* Statements, their docstrings and the opening account were read throughout. General statements for states, reading, level, giving, comparison. Not found for moves, share, cost, multiplying, no_return, both_outcomes, rank, closed_region, forms_change. All questions were reached.
  - *pass b:* I answered states, reading, level, giving and comparison from statements, and both_outcomes as N with a built contrast; the rest are N after reading every statement. I read all statements and docstrings to l. 365.
