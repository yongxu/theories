# Coverage

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Coverage.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-03, as "Coverage.lean: realizes_iff_global, complete_trace_iff, global_balance, unbalanced_no_placement_history" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-03.md.txt)); pass b: reader whole-b-11, as "Coverage.lean: placement, Global, realizes_iff_global, complete_trace_iff, two_tile_orders, balance_perm, global_balance, unbalanced_no_placement_history, mutilated_no_history, balance_does_not_determine_coverability" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-11.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "Coverage.lean: settled fields both_outcomes, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `realizes_iff_global` (l. 105) equates realizability of a placement plan up to remainder order with tile legality and a permutation of its cells plus remainder, for any tile relation. `unbalanced_no_placement_history` (l. 183) excludes every complete plan when each allowed tile has opposite colours and the initial balance is nonzero.
  - *pass b:* For every tile relation, a course of placements (a `Process`) ends at a rest exactly where the global cover holds, and where every allowed tile joins opposite colours the colour balance is an invariant, so an unbalanced board has no cover and no covering course. Built: the mutilated eight-by-eight board has neither, and two separated cells are balanced yet not coverable, so the balance does not determine coverability.
- **moves**
  - *pass a:* S: `placement` (l. 75) chooses an allowed ordered pair and removes its two occurrences up to permutation. `trace_global` (l. 88) and `global_balance` (l. 171) preserve colour balance on every such course under the opposite-colour premise.
  - *pass b:* S: `placement` (l. 75): a `Process (List C) (C × C)` whose step places an allowed tile and removes its two cells, the rest in any order. `realizes_iff_global` (l. 105) and `complete_trace_iff` (l. 113). `unbalanced_no_placement_history` (l. 183): where every allowed tile joins opposite colours and the board's balance is not 0, no course of placements covers it.
- **a reading**
  - *pass a:* S: `unbalanced_no_cover` (l. 177) uses the supplied colour reading to exclude covers from nonzero balance when tiles have opposite colours. B: `balance_does_not_determine_coverability` (l. 248) gives equal readings for the empty and separated boards with opposite coverability.
  - *pass b:* S: the colouring is a supplied reading (D, account l. 29). `unbalanced_no_cover` (l. 177): a nonzero balance, read through the colouring, decides that no cover exists. `balance_does_not_determine_coverability` (l. 248): the balance read does not decide coverability (built).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the balance is a count of +1 and -1, but nothing is set again from it.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: each placement removes two cells, but there is no amount that runs down with return depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* S: `unbalanced_no_placement_history` (l. 183) concludes no choice of tiles reaches the empty board from a nonzero-balance board under the opposite-colour law. The obstruction is a conserved imbalance.
  - *pass b:* S, an impossibility rather than a loss: `unbalanced_no_placement_history` (l. 183) concludes from the invariant that no course of placements from an unbalanced board reaches the empty board. `mutilated_no_history` (l. 218), built.
- **both outcomes**
  - *settled by the third pass:* S (weaker form): `complete_trace_iff` (l. 113): for every `tile`, `board` and tile list `ts`, `Trace (placement tile) board ts [] ↔ Global tile board ts []`, an exactly-when of one given course of placements reaching the empty board; with `unbalanced_no_placement_history` (l. 183) as a one-sided law (balance ≠ 0 and tiles of opposite colours: no course covers). It is not a dichotomy of going on against ending, and it is per given `ts`. [which pass was right: both in part; opened: complete_trace_iff l. 113; realizes_iff_global l. 105; unbalanced_no_cover l. 177; unbalanced_no_placement_history l. 183]
  - *pass a:* S: `complete_trace_iff` (l. 113) characterizes reaching empty for any board and particular tile plan by the global cover with empty rest.
  - *pass b:* N: the exactly-when laws (`realizes_iff_global` l. 105, `complete_trace_iff` l. 113) relate a course to a global condition, not going on to ending.
- **a comparison between two**
  - *pass a:* S: `balance_perm` (l. 139) transports balance through reordering. `two_tile_orders` (l. 119) reaches the same empty board in either order for any two legal tiles on the specified four-cell board.
  - *pass b:* S: `realizes_iff_global` (l. 105) carries between a course of steps and a global cover. `two_tile_orders` (l. 119): two orders of placement reach the same cover.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: `placement` (l. 75) is a definition whose step asks `board.Perm (ab.1 :: ab.2 :: rest)`, and `Perm.length_eq` (l. 51) says permuted lists are equally long; no statement puts them together as a length that falls or as a bound on a course. Opened to rule it out: Perm.length_eq, placement, trace_global, global_realized, complete_trace_iff. [which pass was right: b; opened: Perm.length_eq l. 51; placement l. 75; trace_global l. 88; global_realized l. 97; complete_trace_iff l. 113]
  - *pass a:* S: `placement` (l. 75) and `Perm.length_eq` (l. 51) give a length decrease of exactly two per successful placement. The resulting bound on steps does not imply every board can be covered.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: `global_balance` (l. 171) and `trace_global` (l. 88) keep boards of any fixed balance in that class along all placement steps if every legal tile joins opposite colours.
  - *pass b:* S: `global_balance` (l. 171): a cover keeps the balance (board's balance equals the rest's). This holds where allowed tiles are opposite-coloured, via `balance_perm` (l. 139) and `opposite_pair_balance` (l. 148): an invariant kept by each step.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements (1, 2, 3, 9, 10, 11, 12, 13). Not found (4, 5, 6, 7, 8, 14). Additional evidence is marked within 3. I reached all fourteen questions.
  - *pass b:* Answered from statements: states, moves, reading, no_return, comparison, closed_region; the rest are N. All statements read, all 255 lines.
