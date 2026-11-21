# RootForms

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RootForms.lean`
- *result records that name this place's file as a source* (computed; not a link): `one-root-to-its-edge`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "RootForms.lean: descent_forms_no_dependence, outside_leaves_no_offspring, all_end_at_model" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-65, as "RootForms.lean: descent_forms_no_dependence, outside_leaves_no_offspring, all_end_at_model, no_new_dependence_at_model, GivesFrom, ListedWithin, Inherits" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-65.md.txt)); the third pass, where the two differed: reader whole-c-settle-24, as "RootForms.lean: settled fields no_return, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-24.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any relations, a newly standing member has no specified after-dependence if it has a predecessor, that dependence is inherited, and no predecessor has it (`descent_forms_no_dependence`, l. 94). Listed parents wholly outside the giving region have zero listed offspring when listed descent entails giving and only region members give (`outside_leaves_no_offspring`, l. 208).
  - *pass b:* Two general forms over any type X, each under three named hypotheses, each hypothesis shown not droppable by a one-point witness. `descent_forms_no_dependence` (l. 94): nothing coming to stand depends after the step. `outside_leaves_no_offspring` (l. 208): a listing wholly outside the giving region has no listed offspring. Recoveries state that GroupEnding.Flow.all_end follows from the second form by definitions alone, and that Flow.no_new_dependence follows from the first only with amount reasoning (balance).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no level runs down here. The recovered row `no_new_dependence_at_model` (l. 170) takes Flow's balance of levels as a hypothesis (level at t+1 plus taken equals level at t plus given), but states nothing about running down.
- **a giving that is itself a going-on**
  - *pass a:* S: `all_end_at_model` (l. 282) specializes the giving region to active formations at t and giving to positive contribution by a participant, with acting, descent and inactivity premises.
  - *pass b:* S: `outside_leaves_no_offspring` (l. 208): where giving lies within giving from a region (`GivesFrom`, l. 188) and listed descent lies within giving (`ListedWithin`, l. 193), a listing outside the region has `(ps.flatMap kids).length = 0`. `all_end_at_model` (l. 282): at its model, what gives is a present member with positive giving, the region is activity, and where every member of generation t is inactive the size at t+1 is 0. So the givers are the model's own members, whose inactivity leaves no next generation.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* S: `outside_leaves_no_offspring` (l. 208) concludes the next flattened offspring list has length zero under GivesFrom, ListedWithin and Outside. The lists of children are supplied.
  - *pass b:* S: `outside_leaves_no_offspring` (l. 208) counts offspring lists `kids` of listed members, with the next listing's size as `(ps.flatMap kids).length`. `all_end_at_model` (l. 282): GroupEnding.Flow.all_end, `G.size (t + 1) = 0` where no member of `G.family t` is active.
- **a point of no return**
  - *settled by the third pass:* S, in a weaker form, concluded: `all_end_at_model` (l. 282) has the type of `GroupEnding.Flow.all_end` (GroupEnding.lean l. 398): with `L.Acting W`, `Descended L W G` and every member of `G.family t` not active at `t`, `G.size (t + 1) = 0`; its form `outside_leaves_no_offspring` (l. 208) states `(ps.flatMap kids).length = 0` under `GivesFrom region gives`, `ListedWithin ps kids gives` and `Outside region ps`. It is an ending across one step at the loss of what gives; no statement says the generation stays empty or that nothing is regained. [which pass was right: both in part; opened: `GivesFrom` (l. 188), `ListedWithin` (l. 193), `Outside` (l. 197), `outside_leaves_no_offspring` (l. 208), `all_end_at_model` (l. 282), `all_end_certified` (l. 293); `GroupEnding.Flow.all_end` (GroupEnding.lean l. 398); variable `{X : Type}` (l. 54).]
  - *pass a:* S: `all_end_at_model` (l. 282) concludes a zero next generation when the listed generation is inactive, only active formations give, and descent requires giving. The relational conclusion at l. 208 concerns the immediate offspring list.
  - *pass b:* N: no irreversibility is stated. all_end gives an empty next generation at one step only, and nothing here says it stays empty.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* N: The recovery certificates at ll. 183 and 293 identify proofs at the same type. I found no transfer between two processes, starts or ways of proceeding.
  - *pass b:* N
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* S, for one step only and not as a region: `descent_forms_no_dependence` (l. 94) states `¬ ∃ x, comes x ∧ after x` under `GivenTo comes descends`, `Inherits descends before after` and `UndependedFrom descends before`: nothing coming to stand depends after the step. The premise is about what is descended from before the step and the conclusion about what comes to stand after it, so no one predicate is shown kept by the step, and nothing is iterated; no invariant, kernel, certificate of a closed region or fixed point is stated (`no_new_dependence_certified` l. 183 is an equality of two proofs). [which pass was right: both in part; opened: `GivenTo` (l. 79), `Inherits` (l. 84), `UndependedFrom` (l. 88), `descent_forms_no_dependence` (l. 94), `no_new_dependence_at_model` (l. 170), `no_new_dependence_certified` (l. 183), `outside_leaves_no_offspring` (l. 208); `Flow.no_new_dependence` (Transmission.lean l. 531).]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S, for one step only: `descent_forms_no_dependence` (l. 94): where what comes to stand is given to (`GivenTo`), dependence after the step is inherited along descent (`Inherits`), and nothing descended from depends before (`UndependedFrom`), then nothing coming to stand depends after. Non-dependence is carried across one step; nothing is iterated.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, giving, multiplying, no_return. N for moves, reading, share, level, cost, both_outcomes, comparison, rank, closed_region, forms_change.
  - *pass b:* Answers from statements throughout (S or N). All statements were read (all 297 lines), plus the statements of GroupEnding.Flow.all_end and Transmission's Flow.no_new_dependence to understand the recoveries.
