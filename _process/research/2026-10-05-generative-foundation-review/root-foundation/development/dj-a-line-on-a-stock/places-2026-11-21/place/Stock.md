# Stock

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Stock.lean`
- *table of 20 November:* Stock, letters `NYPPPNYY`, standing core, told in chapter 7 §7 (The conditional direction), table row 'pending-task applicability', and chapter 3 §8 (Learning and seeking): each cites only `Stock.feasible_iff_covered`
- *result records that name this place's file as a source* (computed; not a link): `consequence-revised-reference-plan`, `learned-procedure-transmission`, `pending-task-context-applicability`, `recurring-reference-revision`, `renewing-consuming-formation`, `selection-when-the-lumping-changes`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurring-reference-revision`, `renewing-consuming-formation`, `selection-when-the-lumping-changes`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-19, as "Stock.lean: process_map_iff, repeat_covered_iff, carried_iff, exhausted_within" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-19.md.txt)); pass b: reader whole-b-73, as "Stock.lean: Balanced, trace_balance, feasible_iff_covered, covered_iff_prefix, covered_of_trace, cycles_need, repeat_covered_iff, product_repeat_iff, carried_iff, Run.draws_iff_replenishes, FallsBy, exhausted_within" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-73.md.txt)); the third pass, where the two differed: reader whole-c-settle-27, as "Stock.lean: settled fields reading, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-27.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `StockTraces.feasible_iff_prefix` (l. 633) characterizes stock-process execution by coverage of every draw from initial stock and earlier returns. In any process satisfying FallsBy and drawing positively at positive stock, every trace at least as long as its initial stock ends at zero (`exhausted_within`, l. 582).
  - *pass b:* General laws of a stock observable σ : S → Nat drawn on and replenished by the actions of every Process: balance at each step is balance along every course, a course of the stock process is executable exactly when it is covered (with a closed form by prefixes), a course repeated without end needs its replenishment to cover its draw, and an unending run is carried exactly when each draw is within the stock then standing. A level that falls by each draw, where anything positive draws, ends at nothing within as many steps as it holds; the only built case is accumulating (a stock that only replenishes).
- **moves**
  - *pass a:* S: `product_feasible_iff` (l. 199) characterizes executable move lists in the synchronous product by stock coverage and feasibility in the other process.
  - *pass b:* S: `covered_of_trace` (l. 191): for every Process P whose stock is Balanced and DrawsHeld, every course (Trace) from s is Covered from σ s. `product_feasible_iff` (l. 199): a course of the stock process run jointly with any process R is Feasible exactly when the stock covers it and R admits it. `trace_falls` (l. 537): under FallsBy, every course keeps σ t + total draw ≤ σ s. These are laws about every course among the process's steps; no policy or chosen subset is singled out.
- **a reading**
  - *settled by the third pass:* S: `process_map_iff` (l. 183): for `P : Process S A`, `σ : S → Nat`, `draw replenish : A → Nat`, `Balanced P σ draw replenish ∧ DrawsHeld P σ draw` iff every step `P.step s a t` is a step `(process draw replenish).step (σ s) a (σ t)`: σ is an observation of configurations and the law says exactly when it maps into the stock process. What it registers then decides: `covered_of_trace` (l. 191), under `bal` and `held`, every `Trace P s as t` is `Covered draw replenish (σ s) as`, and `exhausted_within` (l. 582) bounds a course by `σ s`. No class of states read alike and no rule set from the reading is stated, as b says; the field asks for an observation and a law in which it decides something, and that is there. [which pass was right: a; opened: Balanced (l. 71), DrawsHeld (l. 75), balanced_iff (l. 94), process (l. 120), feasible_iff_covered (l. 136), process_map_iff (l. 183), covered_of_trace (l. 191), exhausted_within (l. 582)]
  - *pass a:* S: `process_map_iff` (l. 183) says exactly when the natural stock observable maps each original step to a same-action stock step, namely balance and drawing from what is held.
  - *pass b:* N: σ is a stock observable and `process_map_iff` (l. 183) says Balanced ∧ DrawsHeld exactly when σ maps every step into the stock process. No class of states read alike and no rule made from what is registered was found.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* S: `process_next` (l. 123) makes the successor the remainder plus action-specific replenishment. What a move can draw is limited by current stock, while replenishment is a supplied action function.
  - *pass b:* S: `Covered` (l. 110) and `exhausted_within` (l. 582): under FallsBy, and where every step from a positive level draws something, every course at least σ s long ends with σ t = 0; `draws_nothing_from_empty` (l. 591): from 0 a step draws 0. What comes back is replenish : A → Nat, a function of the action, not of what is left (`process`, l. 120: next = n - draw a + replenish a).
- **a giving that is itself a going-on**
  - *pass a:* N: Replenishment is supplied as an action function. `Run.stockFlow` (l. 465) represents it by one formation present at every step.
  - *pass b:* N: replenish is a function handed in. In `Run.stockFlow` (l. 465) the one giving formation is Unit, present at every step, and nothing can lose it.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* S: `trace_falls` (l. 537) bounds end stock plus total draw by start stock under FallsBy, hence zero cannot recover. `draws_nothing_from_empty` (l. 591) concludes zero draw at each step from empty.
  - *pass b:* S: `trace_falls` (l. 537) / `exhausted_within` (l. 582): under the premise FallsBy (no replenishment), a level that reaches 0 stays at 0 along every course. The ending is concluded; the no-replenishment that makes it irreversible is a premise. It is at a low level, not at the loss of a giver. S: `cycles_need` (l. 276): if every finite number of cycles drawing D and replenishing R is feasible from one configuration of a balanced process, then D ≤ R.
- **both outcomes**
  - *pass a:* S: `product_repeat_iff` (l. 336) says a cycle in the other process can be repeated arbitrarily often jointly with stock exactly when the first cycle is covered and total return covers total draw. `carried_iff` (l. 499) gives the analogous pointwise coverage test for a specified infinite run.
  - *pass b:* S: `repeat_covered_iff` (l. 319): a course w can be repeated any number of times from stock n exactly when Covered n w and total draw ≤ total replenish. `product_repeat_iff` (l. 336) says the same for a cycle of any R run jointly with the stock. `carried_iff` (l. 499): a run of R can be run jointly with the stock from n exactly when each draw is ≤ `along` at its step. All general.
- **a comparison between two**
  - *pass a:* S: `Covered.mono` (l. 209) transports a covered move list to every larger start. `Run.stockFlow_balances_iff` (l. 475) equates balance in the one-condition flow with balance equations along the run.
  - *pass b:* S: `process_map_iff` (l. 183): a balanced, held stock is a map of P into the stock process (used through trace_map). `Covered.mono` (l. 209): more starting stock covers whatever less covers. `product_feasible_iff` (l. 199). `Run.stockFlow_balances_iff` (l. 475): the stock along a run balances as a Flow exactly when it balances at each step.
- **a rank (an ending within a bound)**
  - *pass a:* S: `exhausted_within` (l. 582) bounds time to zero along any sufficiently long trace by the starting stock, given FallsBy and positive draws from positive levels.
  - *pass b:* S: `exhausted_within` (l. 582) and `trace_exhausts` (l. 557): under FallsBy, and where every positive level draws, every course ends at 0 or lowers σ by at least its length, so the level is exhausted within σ s steps.
- **a closed region**
  - *settled by the third pass:* S, in a weaker form: `cycles_covered` (l. 303): for `w : Nat → List A` and `n`, if each cycle is `Covered draw replenish n (w k)` and `total (w k) draw ≤ total (w k) replenish`, then for every `k` the first `k` cycles are covered from `n` and `n ≤ after draw replenish n (cycles w k)`: the stock is at least `n` at every cycle boundary. `repeat_covered_iff` (l. 319) makes repetition without end exact. That is a level kept at cycle ends of a given course, not a region closed under every step; no invariant set, kernel, largest closed region or fixed point is stated. `trace_falls` (l. 537) gives `σ t + total as draw ≤ σ s` along every course under `FallsBy`, a bound, not stated as a region. [which pass was right: both in part; opened: cycles_covered (l. 303), cycles_need (l. 276), repeat_needs (l. 296), repeat_covered_iff (l. 319), trace_repeat (l. 327), balanced_iff (l. 94), FallsBy (l. 532), trace_falls (l. 537), falls_iff (l. 550), trace_exhausts (l. 557), exhausted_within (l. 582), draws_nothing_from_empty (l. 591)]
  - *pass a:* S: `cycles_covered` (l. 303) keeps stock at least n at cycle boundaries if each cycle is covered from n and its total draw does not exceed its return.
  - *pass b:* N: `balanced_iff` (l. 94) and `falls_iff` (l. 550) turn a stepwise condition into one holding along every course, but no region closed under steps, kernel or fixed point is stated.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `accumulating` (l. 520) is a built stock that rises by 1 at every step and never draws; nothing about what is present changing.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring where present. General statements support states, moves, reading, level, no_return, both_outcomes, comparison, rank, closed_region. All fourteen questions were reached.
  - *pass b:* All statements read, including the StockTraces section to l. 649. All fourteen answered from statements; no proof bodies needed.
