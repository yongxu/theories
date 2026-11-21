# Refinement

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Refinement.lean`
- *result records that name this place's file as a source* (computed; not a link): `identification-where-bounded`, `tests-fix-likeness-where-determined`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurrence-without-premise`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-15, as "Refinement.lean: Refining.grow, Refining.steady_or_grown, Refining.steady_within" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-15.md.txt)); pass b: reader whole-b-58, as "Refinement.lean: Refining.steady_within, Refining.steady_or_grown, Refining.grow, DistinctUnder.length_le, DistinctUnder.unique, SteadyAt, Refining" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-58.md.txt)); the third pass, where the two differed: reader whole-c-settle-22, as "Refinement.lean: settled fields no_return, both_outcomes, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-22.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Refining.grow` (l. 116) extends a list of apart representatives by one when a joined pair splits in a decidable chain on a listing. `Refining.steady_within` (l. 167) finds a step k with no split on the listing and k plus the initial representative count at most the listing’s length.
  - *pass b:* For any type and any chain of equivalence relations R k, each finer than the one before (Refining), decided among the members of a list l, the chain stops refining at some step k with k plus the number of members pairwise apart at step 0 at most the length of l (Refining.steady_within); a strict refinement adds a class (Refining.grow), and members pairwise apart under a reflexive relation are no more than the list holding them (DistinctUnder.length_le). All are general laws over any type and any such chain; there is no built model.
- **moves**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no process with moves, policy or allowed set is stated; the only index is the step k of the chain of relations R k.
- **a reading**
  - *pass a:* S: `Refining` (l. 101) specifies indexed equivalences whose related pairs remain related at all earlier adjacent indices. `Refining.grow` (l. 116) shows the effect of distinguishing a previously joined pair under decided relations on listed members.
  - *pass b:* S: `Refining` (l. 101) is a chain of equivalences, classes of configurations read alike at step k, each finer than the one before; `DistinctUnder.unique` (l. 50): under a symmetric relation, two members of a pairwise-apart list that the relation joins are one member. N: no law in which what is registered decides an outcome of a course; what is decided is only when the likeness stops refining (`Refining.steady_within`, l. 167).
- **a share**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no count or fraction of one kind among several, and nothing set again from one.
- **a level that runs down**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no stock, reserve or amount that runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: nothing gives to a level or keeps a condition met.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no cost to anyone is stated.
- **multiplying**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no units leaving units or kinds forming kinds. The count of pairwise-apart members grows by one at a strict refinement (`Refining.grow`, l. 116), but that is a count of classes, not units of the model.
- **a point of no return**
  - *settled by the third pass:* S (a premise): field `finer` of `structure Refining` (l. 101, the field at l. 105): `R (k + 1) x y → R k x y`, so a pair apart at step k is apart at k+1; it is assumed, not concluded. `Refining.grow` (l. 116) uses it to keep a list pairwise apart at step j pairwise apart at j+1 (`DistinctUnder (R (j + 1)) (z :: r)`). `SteadyAt` (l. 108) and `steady_within` (l. 167) speak of one step k only and state no lasting steadiness; nothing here is at a low level or at the loss of something that gives. [which pass was right: a; opened: Refining (l. 101), SteadyAt (l. 108), Refining.grow (l. 116), Refining.steady_or_grown (l. 141), Refining.steady_within (l. 167), DistinctUnder.mono (l. 43)]
  - *pass a:* S: The `finer` premise of `Refining` (l. 101) requires that a separated pair cannot rejoin at the next index. The theorem `Refining.steady_within` (l. 167) guarantees one steady step, without asserting permanent steadiness from that step.
  - *pass b:* N: `SteadyAt` (l. 108) says what step k joins, step k+1 joins, at one step only; no statement that from there on the chain never refines again, and no irreversibility or loss.
- **both outcomes**
  - *settled by the third pass:* N: `Refining.steady_or_grown` (l. 141) is a disjunction for every j (some k with `k + s.length ≤ l.length ∧ SteadyAt R l k`, or a list pairwise apart at step j within l of length at least `s.length + j`), under `Refining R`, `decided`, `apart`, `within`; but `Refining.steady_within` (l. 167) proves the first disjunct outright from the same premises, so the module states one outcome, not two; and neither side is a going on, an ending, a keeping or a losing. [which pass was right: a; opened: Refining.steady_or_grown (l. 141), Refining.steady_within (l. 167), Refining.grow (l. 116), SteadyAt (l. 108), DistinctUnder.length_le (l. 80), not_not_within (l. 92)]
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* S: `Refining.steady_or_grown` (l. 141): for every j, either at some k with k + s.length \<= l.length the chain is SteadyAt, or there is a list pairwise apart at step j, within l, of length at least s.length + j. This is a dichotomy of stopping and refining, not of going on and ending. General.
- **a comparison between two**
  - *pass a:* S: `DistinctUnder.mono` (l. 43) carries pairwise apartness from a relation to any contained relation.
  - *pass b:* S: `DistinctUnder.mono` (l. 43): members pairwise apart under a relation R are pairwise apart under every relation R' contained in R. Nothing carried between two processes or two starts.
- **a rank (an ending within a bound)**
  - *pass a:* S: `Refining.steady_within` (l. 167) bounds the first available no-split step by N−c, assuming decided relations on the listing and c initially apart listed representatives.
  - *pass b:* S: `Refining.steady_within` (l. 167): where Refining R holds, each R k is decided among the members of l, and s is pairwise apart at step 0 within l, there is k with k + s.length \<= l.length and SteadyAt R l k; the count of pairwise-apart members rises at each strict refinement and is bounded by l.length (`DistinctUnder.length_le`, l. 80). Also `not_not_within` (l. 92): decisions of finitely many propositions are together unrefuted.
- **a closed region**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no invariant region, kernel or fixed point of a step is stated; SteadyAt is a one-step stability of the relation's joins, not a region closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: `Refining.grow` (l. 116) states that, under `Refining R`, decided relations on l, a list r pairwise apart at step j within l, and x, y in l with `R j x y` and `¬ R (j + 1) x y`, some z in l makes `z :: r` pairwise apart at step j+1: one more class told apart. No process, course or going-on is in the statement, nothing present comes or goes, and nothing says more can go on after. [which pass was right: b; opened: Refining.grow (l. 116), Refining.steady_or_grown (l. 141), Refining.steady_within (l. 167), Refining (l. 101); the whole module (188 lines) was read]
  - *pass a:* S: `Refining.grow` (l. 116) adds a listed representative to those already apart when a joined listed pair separates at the next step of a decided refining chain. The widening concerns distinguishable classes.
  - *pass b:* N: no statement or built case of a going-on continuing while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, no_return, comparison, rank, forms_change. The remaining findings are N. No question was unreached.
  - *pass b:* All of the fourteen from statements or found absent having read every statement; the whole module (188 lines) was read, proofs included.
