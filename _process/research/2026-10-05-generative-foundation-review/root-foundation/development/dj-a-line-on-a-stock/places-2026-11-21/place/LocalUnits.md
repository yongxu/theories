# LocalUnits

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LocalUnits.lean`
- *result records that name this place's file as a source* (computed; not a link): `unanchored-incidence-collapse`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-10, as "LocalUnits.lean: Joining.chainComplete_iff_commonUnit_suffices, Fragment.composable_iff_commonUnit, Fragment.stepsImage_not_chainComplete" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-10.md.txt)); pass b: reader whole-b-39, as "LocalUnits.lean: Joining.composable_iff_commonUnit, chainComplete_iff_commonUnit_suffices, twoSidedUnit_transport, atMostOnce_not_chainComplete, Fragment.twoSidedUnit_iff_idle, Fragment.steps_reads, Fragment.stepsImage_not_chainComplete" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-39.md.txt)); the third pass, where the two differed: reader whole-c-settle-14, as "LocalUnits.lean: settled fields no_return, rank, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-14.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* Under associativity, functionality and existence of units, chain completion is equivalent to a common unit sufficing for composition (`Joining.chainComplete_iff_commonUnit_suffices`, l. 148). Every process's traced fragments have this property and recover their endpoints as idle units (`Fragment.chainComplete`, l. 316, `leftUnit_iff`, l. 323, `rightUnit_iff`, l. 331), but the built Boolean reading loses chain completion.
  - *pass b:* The module states general laws of any joining (a ternary relation on fragments). Under associativity, units are unique and joined fragments share a unit; under associativity, units and chain completion, fragments join exactly where they share a unit; chain completion is exactly that a common unit suffices; a bijection carrying a joining carries its units. For the traced fragments of any process P, the joining is functional, associative and chain-complete, with units the idle traces (twoSidedUnit_iff_idle), and a built case (atMostOnce, and the process once read through steps) shows a description keeping functionality, associativity and units while losing chain completion.
- **moves**
  - *pass a:* S: `Fragment.LeftUnit.of_joined` (l. 367) and `Fragment.RightUnit.of_joined` (l. 372) preserve the first trace's left unit and the last trace's right unit under any valid composition of move fragments of a `Process`.
  - *pass b:* S: `Fragment.joining` (l. 281) and `Fragment.chainComplete` (l. 316) are stated for every `Process S A`, but they are laws about joining traced fragments, not about what a choice among steps keeps. N: no law of what some choice or every choice keeps.
- **a reading**
  - *pass a:* B: `Fragment.steps_reads` (l. 439) identifies the image joining under the Boolean observation of whether the once-process stepped with `Joining.atMostOnce`. The image loses chain completion (`stepsImage_not_chainComplete`, l. 466).
  - *pass b:* B: `Fragment.steps_reads` (l. 439): the traced fragments of the process `once`, read through `steps` (whether a fragment takes its step, an image of the joining under a map), join exactly as `Joining.atMostOnce`. `Fragment.stepsImage_not_chainComplete` (l. 466): the read joining is not chain-complete, though the traced fragments are (`Fragment.chainComplete`, l. 316). What the reading registers decides which joinability law holds. This is built, for the process once.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *settled by the third pass:* B: `Fragment.once_trace_cases` (l.387): for all `s t : Bool` and `w : List Unit`, `Trace once s w t → (w = [] ∧ s = t) ∨ (w = [()] ∧ s = false ∧ t = true)`. With `s = true` and `t = false` neither case holds, so no trace of the built process `once` leads from true to false; concluded, in one built process, read off by the cases of the disjunction (no separate statement says it). [which pass was right: a; opened: once_trace_cases l.387; stepsWord l.379; steps l.384; steps_reads l.439; stepsImage_not_chainComplete l.466]
  - *pass a:* B: `Fragment.once_trace_cases` (l. 387) concludes that any trace either is empty with equal endpoints or takes the single move from false to true. Hence no trace returns from true to false.
  - *pass b:* N
- **both outcomes**
  - *pass a:* S: `Fragment.composable_iff_commonUnit` (l. 339) characterizes exactly when any two traced fragments of the same process can continue one another. The criterion is a shared right and left unit.
  - *pass b:* S: `Joining.composable_iff_commonUnit` (l. 142): under associativity, units and chain completion, two fragments join exactly where they share a unit. `Joining.chainComplete_iff_commonUnit_suffices` (l. 148) is general. Neither is of going on and ending, or of keeping and losing. N for that.
- **a comparison between two**
  - *pass a:* S: `Joining.leftUnit_transport` (l. 184) and `rightUnit_transport` (l. 192) transport unit relations in both directions along any bijection preserving and reflecting joining triples.
  - *pass b:* S: `Joining.twoSidedUnit_transport` (l. 165), `leftUnit_transport` (l. 184), `rightUnit_transport` (l. 192): a one-to-one, onto map f with J a b c ↔ K (f a) (f b) (f c) carries neutral fragments and left and right units both ways. `TwoSidedUnit.of_iff` (l. 200): neutrality passes between joinings that hold at the same triples.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B: `Fragment.once_trace_cases` (l.387): every trace of `once` has word `[]` or `[()]`, so every course of moves of this built process has at most one move. A bound on the length of every trace of one built process; no general law of a falling rank is in the module. [which pass was right: a; opened: once_trace_cases l.387; atMostOnce l.208; atMostOnce_commonUnit_not_composable l.258; steps_reads_mp l.396; steps_reads l.439]
  - *pass a:* B: `Fragment.once_trace_cases` (l. 387) bounds every move word in the once-process by length one.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* B: `Fragment.once_trace_cases` (l.387): with `s = true` the second case is excluded, so `w = []` and `t = true`: every trace of `once` from true ends at true. Read off by one case of the statement, in one built process. The general statements nearby are of joining, not of steps: `Joining.LeftUnit.of_joined` (l.119) and `RightUnit.of_joined` (l.127), under `J.Associative` and `J.Functional`, carry a unit of a fragment to what it joins into; `Fragment.twoSidedUnit_iff_idle` (l.345) says the neutral traced fragments of any `P : Process S A` are exactly the `idleTrace P s`. [which pass was right: a; opened: once_trace_cases l.387; LeftUnit.of_joined l.119; RightUnit.of_joined l.127; idle_twoSidedUnit l.302; twoSidedUnit_iff_idle l.345; Fragment.LeftUnit.of_joined l.367]
  - *pass a:* B: `Fragment.once_trace_cases` (l. 387) leaves only the empty trace from true, which stays there.
  - *pass b:* N for a region closed under steps. S, nearby: `Joining.LeftUnit.of_joined` (l. 119) and `RightUnit.of_joined` (l. 127): under associativity and functionality, a unit of a fragment is a unit of what it joins into. This is closure under joining, not under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Surveyed the opening account and every declaration's statement and docstring. General statements answer moves, both_outcomes, comparison. The headline is from statements. Built cases supply evidence for reading, no_return, rank, closed_region. No matching result was found for share, level, giving, cost, multiplying, forms_change. All questions were reached.
  - *pass b:* All statements and docstrings were read (l. 1–473). moves, reading, both_outcomes, comparison and closed_region are answered from statements (reading from a built case). The other questions are N.
