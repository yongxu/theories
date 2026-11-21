# SituationTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/SituationTraces.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-19, as "SituationTraces.lean: finer_traces, course_traces_listed, event_traces_concentrated" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-19.md.txt)); pass b: reader whole-b-72, as "SituationTraces.lean: finer_traces, FinerTrace, Traces, traces_count, course_traces, traces_typical, event_traces_typical, event_traces_concentrated, course_traces_listed, signed_traces, cancels_counts" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-72.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For arbitrary natural step weights and distinct move and configuration lists, `finer_traces` (l. 158) lists each listed length-n trace exactly once. `course_traces_listed` (l. 247) counts the traces reading as a given course by its weight when all moves and configurations occur once and equality is decidable.
  - *pass b:* General: with moves and configurations listed without repetition, the finer courses list each trace of the finer law once (`finer_traces`, l. 158). So the counts of Situations are counts of traces: (p+q)^n traces (l. 182), a course taken by as many traces as its weight (l. 186, and for every process l. 247), the law of large numbers and exponential concentration over traces (l. 195, 216, 227), and signed weights as pairs of trace counts (l. 270). Built: the balanced weighting of `Interference.cancels` is two traces, one adding and one subtracting (l. 283, 291).
- **moves**
  - *pass a:* S: `FinerTrace` (l. 146) restricts a trace’s moves and next configurations to listed ones, and `finer_traces` (l. 158) enumerates all such traces once under distinctness.
  - *pass b:* S: `FinerTrace` (l. 146) is a trace of n steps of `finerLaw weight`, a `Process S (A × S × Nat)` whose moves are situations, through listed moves and configurations. The laws count these traces; no law states what some or every choice keeps.
- **a reading**
  - *pass a:* S: `course_traces_listed` (l. 247) counts the fiber of the coarse course map by its along-weight given complete once-only lists and a trace listing.
  - *pass b:* S: `event_traces_typical` (l. 216): of the traces of the finer law, those for which `seen event (coarse h)` deviates by at least d number, times d, at most `n·P·Q·(P+Q)^n`, where P and Q are the weights inside and outside the event. `coarse` forgets the situation and `seen event` reads an event along a course; the count is of what the event shows.
- **a share**
  - *pass a:* S: `event_traces_concentrated` (l. 227) bounds the count of traces with at least k event occurrences for a distinct value list, supplied weights, a trace listing and v ≤ u. The event count does not reset the weights.
  - *pass b:* S: `traces_typical` (l. 195): among the (p+q)^n traces, those whose course deviates by at least d, times d, are at most n·p·q·(p+q)^n. `course_traces` (l. 186): the traces taking course w number `Typicality.weight p q w`. N: no rule or favouring set again from the share.
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
  - *pass b:* N: the trace count (p+q)^n (l. 182) grows with n, but it counts courses, not units leaving units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `signed_traces` (l. 270) splits traces into adding and subtracting kinds; this is not going on against ending.
- **a comparison between two**
  - *pass a:* S: `signed_traces` (l. 270) carries the signed transfer to two counts on any listing of the finer traces given distinct move and configuration lists.
  - *pass b:* S: `course_traces_listed` (l. 247): where every move and configuration is listed once, the traces of the finer law taking a coarse course c number `counting.along weight (fun _ => 1) s c`. This is a count correspondence between the finer process and the weighted coarse one, not a carried order. Each count holds for every list that lists each trace once (`Traces`, l. 152).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring where present. General statements support states, moves, reading, share, comparison. All fourteen questions were reached.
  - *pass b:* All statements and the account read. Moves, reading, share and comparison are S; the rest are N.
