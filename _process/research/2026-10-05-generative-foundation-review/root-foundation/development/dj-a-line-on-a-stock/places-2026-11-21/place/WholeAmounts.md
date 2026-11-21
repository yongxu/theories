# WholeAmounts

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/WholeAmounts.lean`
- *result records that name this place's file as a source* (computed; not a link): `what-discrete-steps-and-whole-amounts-represent`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurring-at-fine-steps-quiet-at-coarser`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-21, as "WholeAmounts.lean: falls_by_steps, Amounts.no_whole_reading, Halving.new_without_gain, Dyadic.half_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-21.md.txt)); pass b: reader whole-b-81, as "WholeAmounts.lean: Amounts.no_whole_reading, not_falls_ever, falls_by_steps, Halving.new_without_gain, Dyadic.half_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-81.md.txt)); the third pass, where the two differed: reader whole-c-settle-30, as "WholeAmounts.lean: settled fields no_return, closed_region, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-30.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Amounts.no_whole_reading` (l. 52) excludes any natural-valued reading preserving every strict fall of an amount system admitting endless fall. `Halving.new_without_gain` (l. 74) exhibits bounded dyadic stock below every earlier stock, and `Dyadic.half_return` (l. 91) proves for every positive dyadic amount that adding half of itself raises it by less than doubling.
  - *pass b:* Generally, for any amounts M with an endless strict fall, no map into the whole numbers takes every strict fall to a strict fall (Amounts.no_whole_reading), because no whole number falls at every step (not_falls_ever). The rest are of one built model, the dyadic amounts: they have no such reading, the halving stock is new at every step without rising, and a return of strength one half rises but stays below double.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no process with a choice among steps was found; every statement is about a given sequence or a given order of amounts.
- **a reading**
  - *pass a:* S: `Amounts.no_whole_reading` (l. 52) rules out a map to Nat that registers every strict fall as a strict decrease when `M.EndlessFall` holds.
  - *pass b:* S: `Amounts.no_whole_reading` (l. 52): where M.EndlessFall holds, there is no φ : A → Nat with φ b \< φ a whenever b is strictly below a. Here a reading is a map that represents the order, not an observation, and the law says that no such reading exists. B: `Halving.no_whole_reading` (l. 62), the same for Dyadic.amounts.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no share or fraction of a kind was found, and no rule set again from one.
- **a level that runs down**
  - *pass a:* B: `Halving.new_without_gain` (l. 74) gives a nonincreasing stock ≤ 1 for which no later stock is at least an earlier one. S: `Dyadic.half_return` (l. 91) treats adding half of a positive amount back to itself. These are separate statements.
  - *pass b:* S: `falls_by_steps` (l. 36): if f : Nat → Nat falls strictly at every step, then f t + t ≤ f 0. `not_falls_ever` (l. 42): no such f exists. B: `Halving.new_without_gain` (l. 74): the halving stock never rises and stays at most one. `Dyadic.half_return` (l. 91): for positive a, a plus half of a is not at most a, and a plus a is not at most a plus half of a. So what is added depends on what is there, in this built case only.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing that gives is a formation or unit of the model. Amounts and stocks are handed in as functions.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a point of no return**
  - *settled by the third pass:* B: `Halving.new_without_gain` (l. 74), first conjunct: `∀ i j, i < j → ¬ Dyadic.amounts.le (stock i) (stock j)`, with no premise, of the one sequence `Halving.stock t = ⟨1, t⟩` (LeastLoss.lean l. 227): no later stock holds an earlier one, so each level once left is not regained. It is concluded, in one built course; it holds of every step alike, so there is no point of no return, no low level and no loss of something that gives. `not_falls_ever` (l. 42) is not it: it denies an endless fall of a whole number. [which pass was right: a; opened: WholeAmounts.lean, all seven: falls_by_steps (l. 36), not_falls_ever (l. 42), Amounts.no_whole_reading (l. 52), Halving.no_whole_reading (l. 62), two_pow_lt (l. 67), new_without_gain (l. 74), Dyadic.half_return (l. 91); LeastLoss.lean Halving.stock (l. 227).]
  - *pass a:* B: `Halving.new_without_gain` (l. 74) concludes for all i \< j that the later stock never regains the level of the earlier one on this fixed path.
  - *pass b:* N: no irreversibility or point of no return was found. not_falls_ever rules out an endless fall; it is not a loss that cannot be regained.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no statement with both outcomes of going on and ending, or of keeping and losing, was found.
- **a comparison between two**
  - *pass a:* S: `Amounts.no_whole_reading` (l. 52) is an obstruction to order transfer. If a strict descent continues forever, no map carries all strict decreases into strict decreases of naturals.
  - *pass b:* S: `Amounts.no_whole_reading` (l. 52) denies that any map carries M's strict order into the order of Nat. That is the only law here that relates two orders, and it is a non-existence.
- **a rank (an ending within a bound)**
  - *pass a:* S: `falls_by_steps` (l. 36) gives f(t) + t ≤ f(0) if a natural-valued f falls strictly at every step. `not_falls_ever` (l. 42) rules out the endless premise.
  - *pass b:* S: `falls_by_steps` (l. 36) and `not_falls_ever` (l. 42): a whole-number variant that falls at each step falls by at least t by step t, so it cannot fall forever. `Amounts.no_whole_reading` (l. 52): where an amount falls without end, no whole-number variant tracks the fall. B: `Halving.no_whole_reading` (l. 62).
- **a closed region**
  - *settled by the third pass:* B, weakly: `Halving.new_without_gain` (l. 74), third conjunct `∀ t, Dyadic.amounts.le (stock t) ⟨1, 0⟩`, with the second `∀ t, Dyadic.amounts.le (stock (t + 1)) (stock t)`: the halving stock is within one at every step and never rises. That is a bound kept along one built sequence; no statement names a region and says a step keeps it (there is no step law here, only the sequence `stock`), and there is no kernel, certificate, fixed point or standing population. [which pass was right: both in part; opened: WholeAmounts.lean, all seven declarations (l. 36, 42, 52, 62, 67, 74, 91); LeastLoss.lean Halving.stock (l. 227), Halving.never_rests (l. 256).]
  - *pass a:* B: `Halving.new_without_gain` (l. 74) proves the bound of one at every step of the specified halving trajectory.
  - *pass b:* N: not found.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B, weakly: `Halving.new_without_gain` (l. 74): for all i \< j the stock at j does not hold the stock at i, it never rises, and it stays within one; so the amount present differs at every step of an endless built sequence. What changes is one falling amount: no statement here has kinds or formations coming and going, an activity that continues, or more going on after (the second conjunct says it never rises). `Dyadic.half_return` (l. 91) is one rise of one amount, not a course. No general statement. [which pass was right: both in part; opened: WholeAmounts.lean, all seven declarations (l. 36, 42, 52, 62, 67, 74, 91); LeastLoss.lean Halving.stock (l. 227), Halving.endless (l. 443).]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: `Halving.new_without_gain` (l. 74): the halving stock is new at every step (for i \< j, stock i is not at most stock j), never rises, and stays at most one. This is novelty at every step without gain, in one built model. N for any general statement.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and every docstring. States, reading, level, no_return, comparison, rank and closed_region use statements or their built cases. The remaining questions were not found, and none was unreached.
  - *pass b:* Read all of it: the account and every statement (100 lines). Answered from statements: reading, level, comparison, rank, and forms_change (built only). N: moves, share, giving, cost, multiplying, no_return, both_outcomes, closed_region. None from the docstrings alone; none U.
