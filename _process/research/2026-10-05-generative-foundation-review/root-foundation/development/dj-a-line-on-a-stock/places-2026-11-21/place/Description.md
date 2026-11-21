# Description

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Description.lean`
- *result records that name this place's file as a source* (computed; not a link): `identification-where-bounded`, `identification-where-runs-part`, `separation-loses-the-relation`, `the-split-that-makes-sense`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurrence-without-premise`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-04, as "Description.lean: separation_faithful_iff, relation_persists, SameAhead.next, finitely_many_states_iff_lasso" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-04.md.txt)); pass b: reader whole-b-13, as "Description.lean: Rectangular, Separated, separation_faithful_iff, relation_persists, forgetting_unrelates, coupling_relates_and_unrelates, SameAhead, SameAhead.next, finitely_many_states_iff, finitely_many_states_iff_lasso, Negation.two_states" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-13.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "Description.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `separation_faithful_iff` (l. 111) says describing each coordinate separately recovers exactly a rectangular whole, and `relation_persists` (l. 257) preserves nonrectangularity when separate maps are injective on occurring coordinates. `finitely_many_states_iff_lasso` (l. 526) equates a finite bound on future-equivalence classes of any history with eventual periodicity.
  - *pass b:* Two sets of general laws with no premise. First, what a cut keeps and loses: separate description gives the whole back exactly when the whole is Rectangular; a relation persists under separate laws that lose nothing of what occurs; it ends by forgetting. Second, states read off one history through a map (SameAhead): a history has finitely many states exactly when two moments are one state, which is exactly a lasso. Built Bool, Specker-parity and negation cases illustrate these.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no Process or choice. The laws are single functions (next, f, g, couple).
- **a reading**
  - *pass a:* S: `SameAhead` (l. 349) identifies moments by all subsequent observations. `SameAhead.next` (l. 361) carries this identification through the next step.
  - *pass b:* S: `separation_faithful_iff` (l. 111): for any whole, every Separated combination is in the whole iff the whole is Rectangular. `SameAhead` (l. 349) with `finitely_many_states_iff` (l. 460): a history o : Nat → O has finitely many states (StatesBelow o L for some L) iff some i \< j are SameAhead. `Law.Returns.states` (l. 467): a configuration that returns has finitely many states through every map o. B: `evenBoxes_not_determined` (l. 202): parity on Specker's boxes is not determined by its pairs.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no irreversibility was found. `relation_persists` (l. 257) states that non-rectangularity is kept under separate laws injective on what occurs, which is persistence, not a point of no return. `coupling_relates_and_unrelates` (l. 287) shows a relation formed and then undone.
- **both outcomes**
  - *pass a:* S: `separation_faithful_iff` (l. 111) characterizes exactly when the separate descriptions keep the whole relation. B: `coupling_relates_and_unrelates` (l. 287) forms and removes a relation in two successive applications.
  - *pass b:* S: `separation_faithful_iff` (l. 111) is an exactly-when of keeping and losing, for a description: separation adds nothing exactly when the parts are unrelated. `finitely_many_states_iff` (l. 460) and `finitely_many_states_iff_lasso` (l. 526) are exactly-whens about states. Neither is of a going-on and its ending.
- **a comparison between two**
  - *pass a:* S: `sameAhead_orbit_iff` (l. 367) equates same-ahead moments of an observed orbit with same-future configurations at those moments.
  - *pass b:* S: `Rectangular.image_of_separate` (l. 213): a law moving each part by itself carries a rectangular whole to a rectangular image. `relation_persists` (l. 257) carries non-rectangularity forward. `SameAhead.next` (l. 361): two moments that are one state step to two moments that are one state. `sameAhead_orbit_iff` (l. 367): SameAhead along an orbit iff Law.SameFuture of the two orbit points.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: `shared_below` (l. 419): for every L and relation P, if each n ≤ L is related to some i \< L, there are t \< t' ≤ L and i with P t i and P t' i; a repeat within L, nothing that falls and no ending. `finitely_many_states_iff` (l. 460) and `finitely_many_states_iff_lasso` (l. 526) are exactly-whens of repeating. Opened to rule it out: shared_below, StatesBelow, statesBelow_of_same, finitely_many_states_iff, finitely_many_states_iff_lasso. [which pass was right: b; opened: shared_below l. 419; StatesBelow l. 439; statesBelow_of_same l. 442; finitely_many_states_iff l. 460; lasso_iff_sameAhead l. 515; finitely_many_states_iff_lasso l. 526]
  - *pass a:* S: `shared_below` (l. 419) forces two distinct moments by L to share a value if every moment through L relates to a value below L. This bounds a repeat, rather than a time to extinction.
  - *pass b:* N: no law of ending within a bound. `shared_below` (l. 419) is a pigeonhole: if each of the first L+1 moments is related to a value below L, two are related to one value.
- **a closed region**
  - *pass a:* S: `Rectangular.image_of_separate` (l. 213) preserves rectangularity under any pair of coordinatewise maps. `SameAhead.next` (l. 361) closes the equivalence on pairs of moments under simultaneous advance.
  - *pass b:* S: `SameAhead.next` (l. 361): the relation SameAhead is closed under the step, and it is an equivalence (refl, symm, trans, l. 351-358). `statesBelow_of_same` (l. 442): if i \< j are one state, every moment is one of the states before j. `Rectangular.image_of_separate` (l. 213): rectangularity is invariant under separate laws.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Negation.two_states` (l. 488) and `Negation.each_through_other` (l. 499) give a course with exactly two future classes, passing from each to the other at every step.
  - *pass b:* B: `Negation.two_states` (l. 488) and `Negation.each_through_other` (l. 499): the two-valued negation has exactly two states that alternate, each defined through the other. B: `coupling_relates_and_unrelates` (l. 287): a coupling relates two parts and, acting again, unrelates them.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring. I used statements for states, reading, both_outcomes, comparison, rank, closed_region, and built cases for forms_change. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read (l. 1-536). reading, both_outcomes, comparison and closed_region are answered from statements; forms_change is B; the rest are N. Many Law and Motion names in the account are not declared here; the account places them in Becoming.IdentificationRuns, which I did not read.
