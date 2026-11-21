# Readings

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Readings.lean`
- *result records that name this place's file as a source* (computed; not a link): `unity-of-readings`, `where-a-move-is-formed`, `worlds-are-runs`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurrence-without-premise`

## 21 November, how a registering comes to be: reader readings-and-the-lock

*As "Readings.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-readings-and-the-lock.md.txt).*

- **what registers what**: Contextual claims as relata of one world (Contextual.world 95); two readings of change, by standing and by exchange (changeReadings 115).
- **what changes it**: No change stated.
- **laws where something comes to be registered**: None found in what was read.
- **cost and keeping**: Not stated.
- **a registering lost**: Not stated.
- **tied to what it rests on**: changeReadings_glue_iff (171): the two readings glue exactly where the flow balances; World.unity (203), no premise. A tie between readings, not to what it rests on.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-15, as "Readings.lean: Contextual.world_active, Flow.changeReadings_glue_iff, World.unity" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-15.md.txt)); pass b: reader whole-b-56, as "Readings.lean: Flow.changeReadings, changes_agree_iff, Flow.changeReadings_glue_iff, Flow.changeReadings_glue_everywhere_iff, Flow.changeReadings_free_iff, Flow.changeReadings_glue_counting_rest, World.unity, Contextual.world" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-56.md.txt)); the third pass, where the two differed: reader whole-c-settle-21, as "Readings.lean: settled fields moves, level" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-21.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Flow.changeReadings_glue_iff` (l. 171) equates gluing of standing and exchange readings at a step with balance at each condition there. `World.unity` (l. 203) gives every world an exchange run matching its standings, gluing everywhere with the rest counted, and equivalent criteria for balance in the original world.
  - *pass b:* The module states, generally for every flow, web and world, that the two readings of change across a step (by standing, the rise and fall of the level; by exchange, given beyond taken and taken beyond given) glue exactly where the flow balances there. A frame of context-free claims of change fits exactly where the flow balances, and with the rest of the whole counted the readings glue at every step (changeReadings_glue_iff, changeReadings_free_iff, changeReadings_glue_counting_rest). World.unity states that every world, with the rest counted, is a run of the law of exchange whose standings are the world's, and that it is Balanced exactly where the rest is never active. Contextual.world defines the readings of one run as one world.
- **moves**
  - *settled by the third pass:* S for a process with acts in a statement, N for a law of what a choice keeps: `World.unity` (l. 203): for every `w : World` there is `r : Run (exchange (Option w.Relatum))` with `r.state t (some x) = w.web.level t x` for all t and x, where `exchange R : Process (R -> Nat) (Exchange R)` (Labelled.lean l. 120) has the exchanges as acts; `Flow.changeReadings_free_iff` (l. 183) is stated for any `P : Process Nat A`; `Contextual.world` (l. 95) takes a `Process` and a `Run`. The one statement about a run asserts that some run reproduces the standings; none says what some move or every move keeps. [which pass was right: both in part; opened: Contextual.world (l. 95), world_active (l. 99), Flow.changeReadings (l. 115), changeReadings_glue_everywhere_iff (l. 178), changeReadings_free_iff (l. 183), changeReadings_glue_counting_rest (l. 191), World.unity (l. 203); exchange (Labelled.lean l. 120)]
  - *pass a:* S: `World.unity` (l. 203) supplies some run of `exchange (Option w.Relatum)` reproducing every original standing at every time.
  - *pass b:* N: Contextual.world (l. 95) takes a Process and a Run, but no law about any choice of steps is stated.
- **a reading**
  - *pass a:* S: `Contextual.world_active` (l. 99) makes activity of a claim along a run equivalent to its belonging to the indicated context and that context showing its specified value.
  - *pass b:* S: `Flow.changeReadings` (l. 115) is a contextual system with two readings of change. `changeReadings_agree_iff` (l. 159) and `changeReadings_glue_iff` (l. 171): the readings agree, and glue, across the step from t exactly where level(t+1) + taken = level(t) + given for every condition. `changeReadings_free_iff` (l. 183): a context-free Frame fits exactly where the flow Balances. `Contextual.world_active` (l. 99): a relatum is active exactly where its context shows it with its value. D: the opening account says the readings of one unfolding are one world even where context-free values are impossible (Square.no_whole, Quantum); those are not stated here.
- **a share**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no share.
- **a level that runs down**
  - *settled by the third pass:* N: opened `Flow.changeReadings` (l. 115), where `W.level` is read as rise and fall across a step; `changes_agree_iff` (l. 149); `Flow.changeReadings_agree_iff` (l. 159): the two readings agree at t iff `W.level (t + 1) c + L.taken t c = W.level t c + L.given t c` for every c; `changeReadings_glue_iff` (l. 171); `World.unity` (l. 203). The level enters only in the balance equation; no statement says it runs down, and nothing given depends on what is left. [which pass was right: b; opened: ChangeReading (l. 108), Flow.changeReadings (l. 115), changes_agree_iff (l. 149), changeReadings_agree_iff (l. 159), changeReadings_glue_iff (l. 171), changeReadings_glue_everywhere_iff (l. 178), World.unity (l. 203)]
  - *pass a:* S: `Flow.changeReadings_agree_iff` (l. 159) equates agreement at t with next level plus take equalling current level plus gift for each condition. No feedback from remaining level to gifts is asserted.
  - *pass b:* N: W.level appears only as the standing reading of change (l. 118). No running down is stated, and nothing that comes back depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: nothing gives to a level in a law here, beyond the balance equation's given term.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no cost.
- **multiplying**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no units leaving units.
- **a point of no return**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no point of no return.
- **both outcomes**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no dichotomy of going on and ending, or of keeping and losing. The iffs (`changeReadings_glue_everywhere_iff` l. 178; in `World.unity` l. 203, Balanced ↔ the rest is never active) are of gluing against balance. D: the opening account names a dichotomy of significance and boundary (presupposition_iff_all_of_invariant, bounded_invariant_iff, not_subTrue_of_invariant), which it says are stated in Becoming.Boundaries, not here.
- **a comparison between two**
  - *pass a:* S: `World.unity` (l. 203) carries standings to the exchange run by the map x ↦ some x. `Flow.changeReadings_glue_counting_rest` (l. 191) gives gluing after the imbalance is counted.
  - *pass b:* S: `changes_agree_iff` (l. 149): the standing reading and the exchange reading of one change agree exactly where b + p = a + q. `World.unity` (l. 203): there is a Run of the exchange law on Option w.Relatum whose state at some x is the world's level at x, which carries the world onto a run of one law.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no rank, variant or bound.
- **a closed region**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no region closed under steps. The 'rest never active' of World.unity is a condition at every step, not a closed region.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N: no statement or built case of forms changing while the going on continues.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, level, comparison. The remaining findings are N. No question was unreached.
  - *pass b:* All fourteen were answered from statements, with D for the significance dichotomy, which the opening account places in Becoming.Boundaries. The whole module was read: the opening account and every statement and docstring to l. 213.
