# Parting

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Parting.lean`
- *result records that name this place's file as a source* (computed; not a link): `identification-where-runs-part`, `typicality-by-counting`, `where-a-run-goes-on`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurrence-without-premise`, `when-the-runs-of-a-process-settle`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-13, as "Parting.lean: world_right_iff, continues_persists, unbounded_of_continues, Unparted.along" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-13.md.txt)); pass b: reader whole-b-48, as "Parting.lean: PartAt, Unparted, not_right_on_both, Unparted.along, course_statesBelow, leastBound_right, rest_earliest_runs, late_right, continues_persists, unbounded_of_continues, live_persists, world_right_iff, some_right_iff, free_never_right, free_unbounded" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-48.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: With listed moves and states, decidable steps and decidable observed equality, a predictor built from the process is correct at t on all runs from s exactly when none first part in observation at t (l. 635). For any process covered by N listed states, an N-step continuation yields continuations of every length (l. 438).
  - *pass b:* These are general laws for every process on what a prefix of a run's course through a map fixes. At a parting no extrapolation is right on both runs. Not parting is kept along runs, and from a configuration from which no two runs part, with N configurations, the least-bound extrapolation is right from N+N−1 on, which is exact. With moves and configurations listed, some extrapolation is right at a step on every run exactly where no two runs part there. Built free-branching cases show that where runs part, nothing bounds the course and every extrapolation is missed.
- **moves**
  - *pass a:* S: `continues_persists` (l. 419) gives some admissible move to another state with an N-step continuation when N is the length of a covering list and the start has such a continuation.
  - *pass b:* S: `Unparted` (l. 145): every two runs of `P : Process S A` from s have one course through reg. `Unparted.along` (l. 192): from every configuration a run from an unparted s reaches, no two runs part either. `some_right_iff` (l. 643): with listed moves and configurations and decided steps, some extrapolation is right at t on every run from s exactly where no two runs from s part at t. `unparted_of_determined` (l. 232): a determined process with one move parts nowhere.
- **a reading**
  - *pass a:* S: `not_right_on_both` (l. 155) rules out any predictor correct on both runs at a step where they first differ in observation. `world_right_iff` (l. 635) gives the converse under the finite decidability premises.
  - *pass b:* S: `not_right_on_both` (l. 155): if r, r' part at t (same through reg before t, different at t), no extrapolation pred from the prefix is right at t on both. `leastBound_right` (l. 216): on a run from an unparted configuration held by a list of N, the least-bound extrapolation is right at every t ≥ N+N−1. `rest_earliest_runs` (l. 239): no extrapolation is right at N+N−2 on every such run for N = M+2.
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
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no loss that is not regained. `Unparted.along` (l. 192) is a kept property, and `continues_persists` (l. 419) gives the opposite of ending.
- **both outcomes**
  - *pass a:* S: `live_iff_continues` (l. 472) equates a Boolean test with existence of an m-step continuation for a decidable process with exhaustive state and move lists. At the state-list length `liveRun` (l. 509) constructs a run from a passing state.
  - *pass b:* S: `unbounded_of_continues` (l. 438): for any process whose configurations are all in a list of N, a course of N steps from y makes y unbounded (courses of every length start there). Unbounded gives a course of N steps by its definition, so going on without end holds exactly where a course of N steps starts. The iff is not stated as one theorem; one direction is the definition. S: `world_right_iff` (l. 635) is an exact-when for prediction (right on every run exactly where none part).
- **a comparison between two**
  - *pass a:* S: `joinAt_before` (l. 112) and `joinAt_after` (l. 122) preserve the first run through k and the second thereafter when the second starts at the first run’s kth state.
  - *pass b:* S: `joinAt` (l. 103) with `joinAt_before`/`joinAt_after` (l. 112, 122) joins two runs at a step. `Unparted.along` (l. 192) carries not-parting from a start to every reached configuration. `leastBound_right` (l. 216) and `rest_earliest_runs` (l. 239) carry Identification's bound from determined laws to unparted processes. `statesBelow_shift` (l. 283) carries a bound from a shifted course.
- **a rank (an ending within a bound)**
  - *pass a:* S: `unbounded_of_continues` (l. 438) makes the covering list’s length a finite cutoff for bounded continuation. `leastBound_right` (l. 216) gives the distinct prediction deadline 2N−1 for a list-held unparted run with decidable outputs.
  - *pass b:* S, a bound on settling, not on ending: `course_statesBelow` (l. 203): the course has at most N states. `leastBound_right` (l. 216): right from N+N−1 on. `late_right` (l. 311): where runs part only before T, right from 2(T+N)−1 on. N: no falling variant or drain to ending.
- **a closed region**
  - *pass a:* S: `Unparted.along` (l. 192) passes unpartedness to every state reached along a run from an unparted start. `live_persists` (l. 482) supplies a preserving move on the Boolean live region with exhaustive lists.
  - *pass b:* S: `Unparted.along` (l. 192): the unparted configurations are closed along runs. `live_persists` (l. 482): from where a path of N steps is open, a step leads to where one is open, and `liveRun` (l. 509) builds a run staying there. `continues_persists` (l. 419) does the same without decidability.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `freeRun_course` (l. 666) realizes every prescribed course through identity in free branching, including alternating courses. `free_unbounded` (l. 714) exhibits a Boolean run with no finite `StatesBelow` bound.
  - *pass b:* B: `free_unbounded` (l. 714): a run of free branching on two configurations whose course has no bound on its states (it goes on and never settles into a lasso). `free_parts_after` (l. 675): after every prefix two runs part. `free_never_right` (l. 700). N: no general statement of a widening.
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring. Statements — states, moves, reading, both_outcomes, comparison, rank, closed_region. Built cases — forms_change. Not found — share, level, giving, cost, multiplying, no_return. No answer rests on commentary alone or was left unreached.
  - *pass b:* All statements read (whole module, l. 1–724). Answered from statements: moves, reading, both_outcomes, comparison, rank, closed_region. From built cases: forms_change. N for share, level, giving, cost, multiplying and no_return after all statements were read.
