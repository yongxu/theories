# Cascade

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Cascade.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-cascade-at-the-histories-reached`, `readers-reading-readers`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-cascade-at-the-histories-reached`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "Cascade.lean: Turns.cascade_through, Turns.acts_alike_of_cascade, Turns.separates_at" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-04, as "Cascade.lean: Turns, Turns.ReadsOnlyActsFrom, Turns.acts_alike_of_cascade, Turns.cascade_through, Turns.separates_at, Turns.Copying.reaches_first_only" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-04.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "Cascade.lean: settled fields moves, both_outcomes, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* In any Turns system, if members from k onward ignore their own coupling at every history, agreement on the earlier couplings makes every finite act list identical (`acts_alike_of_cascade`, l. 101). Under that premise any selection from any such list factors through agreement before k (`cascade_through`, l. 119).
  - *pass b:* General for every Turns W O A (member n acts by law n on its own coupling and the list of earlier acts): if every member from k on reads only the earlier acts (ReadsOnlyActsFrom k), two worlds alike through the first k couplings give every member the same act (acts_alike_of_cascade), so every selection reading the first N acts is Through the first k couplings (cascade_through). Built: Copying, in which every member after the first copies the first act, reaches only the first member's coupling (reaches_first_only).
- **moves**
  - *settled by the third pass:* S (weaker form): `Turns` (l.58) gives each member a `law : Nat → O → List A → A` on its own coupling and the earlier acts, a deterministic policy; `acts_alike_of_cascade` (l.101) holds for every `T : Turns W O A` with `T.ReadsOnlyActsFrom k` and worlds with `T.AlikeBefore k w w'`: `∀ n, T.acts w n = T.acts w' n`. A law over every family of policies meeting the cascade premise; there is no `Process S A` and no choice among steps. [which pass was right: both in part; opened: structure Turns l.58, acts l.69, act l.74, ReadsOnlyActsFrom l.79, AlikeBefore l.83, law_alike_of_cascade l.89, acts_alike_of_cascade l.101, act_alike_of_cascade l.112, cascade_through l.119]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: each member's act is given by its own law (Turns.law, l. 62), a deterministic policy on its coupling and the earlier acts; there is no choice among steps. acts_alike_of_cascade (l. 101) holds for every family of laws meeting ReadsOnlyActsFrom k.
- **a reading**
  - *pass a:* S: `separates_at` (l. 129) equates different acts at a common previous act list with the law distinguishing the two coupled values on that list.
  - *pass b:* S: Turns.coupling n : W → O (l. 60) is what member n registers of the world. cascade_through (l. 119): in a cascade from k, every select : List A → Prop on the first N acts satisfies Learning.Training.Through (AlikeBefore k), so the first k couplings decide it. separates_at (l. 129): after the same earlier acts, member n's act differs between two worlds exactly where its law tells apart their couplings.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the list of acts grows by one per member (acts, l. 69); no units leave units.
- **a point of no return**
  - *pass a:* S: `acts_alike_of_cascade` (l. 101) rules out recovery of a difference in the act lists of worlds alike before k at every length; ignoring all later private couplings is assumed.
  - *pass b:* S: acts_alike_of_cascade (l. 101): from the premise ReadsOnlyActsFrom k, it is concluded that distinctions in couplings of members k and beyond never reach any act, for every number of members. The cascade itself is a premise. D: the account says nothing here acquires or restores a distinction. Not of a level.
- **both outcomes**
  - *settled by the third pass:* S (different form): `separates_at` (l.129): given `T.acts w n = T.acts w' n`, `T.act w n ≠ T.act w' n ↔` the law of member n at the shared earlier acts gives different acts on `T.coupling n w` and `T.coupling n w'` (l.130-131, read through the proof term). An exact condition, for every `Turns`, for a distinction between two worlds to show in one member's act; it unfolds `act`. None of going on and ending of a course. [which pass was right: both in part; opened: separates_at l.129, act l.74, acts_alike_of_cascade l.101, Copying.reaches_first_only l.162]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: separates_at (l. 129): an exactly-when of a distinction kept or not at one member, given a shared history. N: none of going on and ending.
- **a comparison between two**
  - *pass a:* S: `act_alike_of_cascade` (l. 112) carries equality before k in the couplings to equality of every individual act across worlds under ReadsOnlyActsFrom k.
  - *pass b:* S: acts_alike_of_cascade (l. 101) and act_alike_of_cascade (l. 112) carry sameness of acts between two worlds (two starts) alike before k. cascade_through (l. 119) states this as a Through relation.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *settled by the third pass:* S (different form): `law_alike_of_cascade` (l.89): under `T.ReadsOnlyActsFrom k`, `T.AlikeBefore k w w'` and `T.acts w n = T.acts w' n`, member n's acts in w and w' are equal; `acts_alike_of_cascade` (l.101) gives `T.acts w n = T.acts w' n` for every n. An alikeness of two worlds' act lists is kept from each member to the next. It is a relation on pairs of worlds kept along the turns (nearer the field `comparison`), not a region of configurations closed under a step, a kernel or a fixed point. [which pass was right: both in part; opened: law_alike_of_cascade l.89, acts_alike_of_cascade l.101, act_alike_of_cascade l.112, cascade_through l.119, Copying.readsOnlyActs l.153]
  - *pass a:* S: `law_alike_of_cascade` (l. 89) keeps the next acts equal under equal earlier act lists, a cascade and AlikeBefore; `acts_alike_of_cascade` (l. 101) propagates equality of the lists.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and reading, no_return, comparison, closed_region. The remaining fields are N. None were unreached.
  - *pass b:* All statements read (172 lines). moves, reading, no_return, both_outcomes and comparison answered from statements; the rest are N, having read every statement.
