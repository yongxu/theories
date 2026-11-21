# FinerTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/FinerTraces.lean`
- *result records that name this place's file as a source* (computed; not a link): `weights-count-situations`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-05, as "FinerTraces.lean: mem_finer_iff, trace_forget, trace_lift, finer_exists_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-05.md.txt)); pass b: reader whole-b-17, as "FinerTraces.lean: mem_finer_iff, supportLaw, trace_forget, trace_lift, finer_exists_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-17.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `mem_finer_iff` (l. 98) characterizes membership in the finite enumeration by length, finer-law tracehood and listed moves and destinations for any natural step weights. `trace_forget` (l. 144) and `trace_lift` (l. 157) relate these traces to precisely the positive-weight traces after forgetting situations.
  - *pass b:* For any weight S → A → S → Nat, the finer courses listed by Situations.finer are exactly the traces of the finer law, of the right length and with listed moves and configurations. Forgetting the situation maps the finer law's traces onto the traces of the law of steps of positive weight (supportLaw), and finer courses exist exactly where that law has a trace. The laws are general, with a two-valued case (two_values_mem_iff).
- **moves**
  - *pass a:* S: `mem_finer_iff` (l. 98) requires every chosen move and destination of the finer trace to be listed for membership in the length-n enumeration.
  - *pass b:* S, in part. `supportLaw` (l. 141) is a Process S A whose steps are those of positive weight, and the finer law is a process whose moves are situations. `trace_forget` (l. 144) and `trace_lift` (l. 157) relate their traces. No law says what some choice or every choice keeps.
- **a reading**
  - *pass a:* S: `trace_forget` (l. 144) projects each finer move to its first component, preserving tracehood with the same endpoints in the support law.
  - *pass b:* S: `trace_forget` (l. 144) and `trace_lift` (l. 157): forgetting the situation (h.map Prod.fst) sends each trace of the finer law to a trace of supportLaw, and every supportLaw trace is such a forgetting. So traces are read alike once the situation is forgotten. Nothing registered decides a selection.
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
  - *pass b:* N
- **both outcomes**
  - *pass a:* S: `finer_exists_iff` (l. 173) equates a nonzero enumeration with existence of a positive-weight trace of the specified length from the same start, given exhaustive move and state lists.
  - *pass b:* S, of existence of courses, not of going on and ending. `finer_exists_iff` (l. 173): with every move and configuration listed, the finer courses of n steps from s are non-empty exactly where supportLaw has a trace of n moves from s.
- **a comparison between two**
  - *pass a:* S: `trace_lift` (l. 157) realizes each support-law trace by a finer trace with the same endpoints and exactly that projected move list.
  - *pass b:* S: `trace_forget` (l. 144) and `trace_lift` (l. 157) are a two-way simulation between the finer law and the support law, under forgetting the situation.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements — states, moves, reading, both_outcomes, comparison. Not found — share, level, giving, cost, multiplying, no_return, rank, closed_region, forms_change. No answer rests on commentary alone; all questions were reached.
  - *pass b:* Answered from statements: moves (in part), reading, both_outcomes and comparison. The other ten were not found. All statements and docstrings were read, lines 1 to 196, including the opening account.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-03

*As "FinerTraces.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-03.md.txt).*

- **an exact statement of both outcomes**: S in form: `finer_exists_iff` (l. 173), in section `Finer` with `{S : Type u} {A : Type v}` (l. 68): `(weight : S → A → S → Nat) {moves : List A} {all : List S} (every_move : ∀ a, a ∈ moves) (every : ∀ s, s ∈ all) (n : Nat) (s : S)` gives `nonzero (finer weight moves all n s).length = true ↔ ∃ as t, as.length = n ∧ Trace (supportLaw weight) s as t`. The outcomes are that finer courses of `n` steps from `s` exist or that there are none. The two sides are two tellings of that existence (a count non-zero; a trace of the law of positive weight exists), not a condition on a start or a parameter that separates going on from ending.
- **the side that keeps**: Neither side names a region. The statement only asserts that a trace of `n` moves exists. Opened: `mem_finer_iff` (l. 98), `supportLaw` (l. 141), `trace_forget` (l. 144), `trace_lift` (l. 157), `two_values_mem_iff` (l. 187): none states an invariant, a kernel or a fixed point.
- **the side that ends**: N. The negative side says only that the list of finer courses is empty, equivalently that no list of `n` moves is a trace from `s`. The `n` is a parameter of the statement, handed in, not a bound concluded; nothing falls. `of_mem_finerSteps` (l. 79) has `x.2.2 < weight s x.1 x.2.1`, a bound on a situation's index within one step, not on a course.
- **moves in that statement**: S, existentially: `∃ as t, as.length = n ∧ Trace (supportLaw weight) s as t` asks for some list of moves `as : List A`; `moves : List A` with `every_move` lists every move. `supportLaw weight : Process S A` (l. 141) admits the steps of positive weight. No law says what some choice or every choice keeps.
- **a reading in that statement**: N in that statement: the condition is on `weight` itself (positive or not). Beside it, `trace_forget` (l. 144) and `trace_lift` (l. 157) state that forgetting the situation (`h.map Prod.fst`) sends every trace of `finerLaw weight` to a trace of `supportLaw weight` and that every trace of `supportLaw weight` is such a forgetting; nothing registered decides anything.
- **the carrier**: A `Process S A` (`supportLaw weight`) and the process `Situations.finerLaw weight : Process S (A × S × Nat)`, with their `Trace`s; and the list `Situations.finer weight moves all n s : List (List (A × S × Nat))`.
- **what is handed in**: Handed in: the weights, the lists of moves and of configurations with their exhaustiveness, `n` and `s`. No level, giving, share, favouring, reading or turn occurs. Concluded: only the equivalence of the two tellings of existence.
- **links to other modules**: `mem_finer_iff` (l. 98) names `Situations.finer`, `Situations.finerLaw` and `Trace`: a list is a finer course of `n` steps from `s` exactly where it has length `n`, is a trace of `finerLaw weight` from `s`, and takes listed moves to listed configurations. `finer_exists_iff` (l. 173) names `finer`, `nonzero` (Prelude.lean l. 770) and `Trace`; its proof goes through `Situations.finer_count` and `WeightedTraces.counting_transfer_iff`. `trace_forget` (l. 144) and `trace_lift` (l. 157) name `finerLaw` and `Trace`: `supportLaw` is `finerLaw` with the situation forgotten. `two_values_mem_iff` (l. 187) names `Typicality.stepWeight`: the instance on two values, where every list is listed. `of_mem_finerSteps` (l. 79) names `Situations.finerSteps`.
- **standing**: None seen. The account (l. 29-31) says no ethical predicate, ranking or axiom occurs, and that no theorem here excludes a trace being listed more than once.
- **note**: The module's exactly-when is a bridge between an enumeration and the traces of a process, with some list of moves in it and no reading; it has neither a closed region nor a rank on either side, and its two outcomes are not going on and ending of a course.
