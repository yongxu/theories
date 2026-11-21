# Onward

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Onward.lean`
- *result records that name this place's file as a source* (computed; not a link): `conditions-kept-together`, `processes-represented-both-ways`, `what-a-course-keeps-reachable`, `where-a-run-goes-on`, `where-the-possible-grows`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-course-that-only-returns`, `never-leaving-a-guard`, `rule-raised-every-other-step`, `when-the-runs-of-a-process-settle`, `where-the-possible-grows`

## 21 November, a future opening or closing: reader courses-still-open

*As "Onward.lean: KeepsMoving, run_of_trace, run_iff_returning". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-future-2026-11-21/NOTE.md), [report](../../read-a-future-2026-11-21/read-courses-still-open.md.txt).*

- **what stands for what can go on after**: KeepsMoving P K := ∀ s, K s → ∃ a t, step s a t ∧ K t (206). Separately, whether a run starts at s.
- **laws concluding an opening**: - run_of_trace (98): a trace to the start of a run gives a run. - run_of_returning (113). - KeepsMoving.run (231), premise: a list of all configurations. - run_iff_returning (179), exact under that list: ∃ run from s ↔ ∃ t, Reach s t ∧ Returns t. - run_iff_continues, run_iff_unbounded, runs_iff_dependentChoice (397).
- **laws concluding a closing**: - Built example fan_no_run (196). - rise_needs_merge (282). Premises: the list, KeepsMoving, q never falls within K, and q x\<q y across a step. Conclusion: ¬Lossless. - lossless_no_rise (264). - lossless_unlisted (291): Lossless, Unbounded and ¬Returns give no list of all configurations.
- **forms changing while it continues**: Not found in what was read.
- **from where an opening comes**: Within finitely many configurations, going on without end is coming round. A rise needs a merge, and a course that never returns needs unlisted configurations.
- **a way related to widening**: Not found in what was read.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "Onward.lean: run_iff_continues, KeepsMoving.run, runs_iff_dependentChoice" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-43, as "Onward.lean: run_iff_continues, run_iff_unbounded, run_iff_returning, run_decided, KeepsMoving, KeepsMoving.run, lossless_no_rise, rise_needs_merge, lossless_unlisted, Finds, searchedRun, runs_iff_dependentChoice, fan_no_run" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-43.md.txt)); the third pass, where the two differed: reader whole-c-settle-16, as "Onward.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-16.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `run_iff_continues` (l. 164) equates an infinite run from s with a course of length equal to a list covering all states. `runs_iff_dependentChoice` (l. 397) identifies the corresponding unrestricted principle of an infinite run inside every family with an available internal step at every member with dependent choice.
  - *pass b:* General over every `Process S A`: where a list holds every configuration, a run starts at s exactly when a course as long as the list does (`run_iff_continues` l. 164), exactly when courses of every length do (`run_iff_unbounded` l. 172), and exactly when a course leads to a configuration that returns (`run_iff_returning` l. 179). A family that keeps moving has a run from each member that stays in it (`KeepsMoving.run` l. 231). Over all processes, runs from every member of every such family are exactly `DependentChoice` (`runs_iff_dependentChoice` l. 397). One built case: `fan_no_run` (l. 196), on `Lasting.Fan`, has courses of every length and no run.
- **moves**
  - *pass a:* S: `KeepsMoving.run` (l. 231) concludes existence of a run from each member staying in K if every member has some internal move and all configurations are listed.
  - *pass b:* S: `Process S A` with actions. `KeepsMoving P K` (l. 206): from each member of K some step leads to a member. `KeepsMoving.run` (l. 231): within finitely many configurations, from each member a run starts all of whose states are in K, so some choice keeps K. `searchedRun` (l. 342) with `searchedRun_within` (l. 350): given `Finds`, a run built as data, by searching the test at each step, stays in K. `runs_iff_dependentChoice` (l. 397): that such a run exists for every process is exactly dependent choice.
- **a reading**
  - *pass a:* S: `decidedTest_finds` (l. 363) gives a recognition test for internal steps with decidable steps, decidable membership and an enumeration covering the move/successor pairs. `searchedRun_within` (l. 350) keeps the run chosen by a Finds test inside a family that keeps moving.
  - *pass b:* S: `Finds P K e test` (l. 326) is a Bool test over enumerated moves: what passes is a step that stays in K, and wherever such a step exists some enumerated move passes. `searchedStep` (l. 335, a def) takes the first passing move, so the test decides which step is taken. `decidedTest_finds` (l. 363): where steps and K are decidable and moves are enumerated, testing each move is such a test. There is no observation class or rule made from what is registered in the sense of a reading of the world.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no stock that runs down. The only quantity is `lossless_no_rise` (l. 264): merging nothing (`Branching.Lossless`) within finitely many configurations, a q that never falls across a step within a family that keeps moving keeps its value across each such step.
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
  - *settled by the third pass:* S (as a premise only, not concluded): `Onward.lossless_unlisted` (l. 291): for P : Process S A (section variable), given `Branching.Lossless P`, `Lasting.Unbounded P s` and `never : not (Branching.Returns P s)`, no list holds every configuration; never returning is a hypothesis and the conclusion is that the configurations are unlisted. What the module concludes runs the other way: `KeepsMoving.returns` (l. 255) and `lossless_returns_iff` (l. 242) conclude that a configuration returns (lossless, all configurations listed). `fan_no_run` (l. 196) states only that no `Run Lasting.Fan.process` starts at `.root`; it names no state from which something is lost for good, so it is not a built point of no return in this module's statement. [which pass was right: both in part; opened: fan_no_run (l. 196), KeepsMoving (l. 206), within (l. 210), KeepsMoving.run (l. 231), lossless_returns_iff (l. 242), KeepsMoving.returns (l. 255), lossless_no_rise (l. 264), rise_needs_merge (l. 282), lossless_unlisted (l. 291), run_decided (l. 187); for names: Branching.returns_iff_ahead (Branching.lean l. 184), Lasting.Fan.no_unbounded_step (Lasting.lean l. 1153). Section variable: {S A} {P : Process S A}; no include.]
  - *pass a:* B: `fan_no_run` (l. 196) concludes that no infinite run starts at the fan root. S: Nonreturn is a premise of `lossless_unlisted` (l. 291), which rules out a finite state listing for a lossless process with arbitrarily long courses there.
  - *pass b:* N: no irreversibility. The laws run the other way. `KeepsMoving.returns` (l. 255): merging nothing, within finitely many configurations, each member of a family that keeps moving returns. `lossless_unlisted` (l. 291): merging nothing, a configuration with courses of every length that never returns forces that no finite list holds all configurations. The never-returning there is a premise, and the conclusion is openness.
- **both outcomes**
  - *pass a:* S: `run_iff_returning` (l. 179) gives existence of an infinite run iff a returning state is reachable when a list contains all states. `run_decided` (l. 187) decides run existence with listed successors as well.
  - *pass b:* S: `run_decided` (l. 187), general: within finitely many configurations whose successors are listed (`Lasting.FinitelyBranching`), `Decided (∃ r : Run P, r.state 0 = s)`, that is, either a run starts at s or none does. The three exactly-when laws `run_iff_*` (l. 164, 172, 179) say when a run without end starts. `lossless_returns_iff` (l. 242): merging nothing, s returns exactly when a course as long as the list starts from it.
- **a comparison between two**
  - *pass a:* S: `run_of_reach` (l. 106) carries run existence at a reached state back to its start by prefixing the reaching course.
  - *pass b:* S: `run_of_trace` (l. 98) and `run_of_reach` (l. 106): a run from t carries back to any s that leads to t, by putting the course first. `ofWithin` (l. 214): a run of the steps within K is a run of P. `runs_iff_dependentChoice` (l. 397) carries between processes with moves and total relations (each direction builds one from the other). `lossless_returns_iff`, `lossless_no_rise` and `lossless_unlisted` restate `Branching`'s laws along runs with no run given.
- **a rank (an ending within a bound)**
  - *pass a:* S: `run_iff_continues` (l. 164) makes the size of a covering state list a finite horizon: absence of an infinite run rules out a course of that length.
  - *pass b:* S, for search and for finding a return, not for a process ending: `acc_below` (l. 311): below a place where the test passes, the search is accessible, so `search` (l. 320) ends at a passing place. `returning_of_continues` (l. 133): a course as long as the list repeats a configuration within that length (pigeonhole through `revisits_within`). N: no falling variant or deadline of the process itself.
- **a closed region**
  - *pass a:* S: `KeepsMoving` (l. 206) requires some internal step at each member. `KeepsMoving.continues` (l. 222) yields internal courses of every finite length; `KeepsMoving.run` (l. 231) yields an internal run with all states listed.
  - *pass b:* S: `KeepsMoving K` (l. 206) is a region in which every member has a step staying inside, though K need not be closed under every step. `within P K` (l. 210) is the process restricted to K. `KeepsMoving.continues` (l. 222): courses of every length stay in K. `KeepsMoving.run` (l. 231) and `searchedRun_within` (l. 350): a run stays in K for ever.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no relay, no kinds coming and going, no widening. Within finitely many configurations a run that goes on is a course into a return, coming round (`run_of_returning` l. 113). `rise_needs_merge` (l. 282): a rise of a never-falling quantity within a family that keeps moving needs a merge. D: the account's readings (D43) say that going on without end does so by coming round.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, moves, reading, no_return, both_outcomes, comparison, rank, closed_region. Built cases — no_return. Not found — share, level, giving, cost, multiplying, forms_change. No commentary-only answers. All questions were reached.
  - *pass b:* All fourteen questions answered from statements, with only the coming-round reading in forms_change from the account. The whole module (423 lines) was read: the account, every statement and most proof bodies. A few names were looked up in Recurrence.lean (`Returns`, `Lossless`) and Lasting.lean (`Continues`, `Unbounded`).
