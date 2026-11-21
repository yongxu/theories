# Assurance

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Assurance.lean`
- *result records that name this place's file as a source* (computed; not a link): `assured-route-criterion`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "Assurance.lean: runs_of_completes, completes_iff_of_determined, Branch.runs_not_completes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-01, as "Assurance.lean: runs_of_completes, completes_iff_of_determined, completes_iff_runs, Branch.runs_not_completes, completes_ofMap_iff, completes_ofPartial_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-01.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "Assurance.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* For every process a completing plan has a trace and every trace endpoint admits a safe trace and meets the goal (`runs_of_completes`, l. 46). Determinacy gives the converse, and a branching example refutes the unrestricted converse (`completes_iff_of_determined`, l. 88, `Branch.runs_not_completes`, l. 145).
  - *pass b:* For every process, a plan that completes (each step possible and safe from every reachable configuration, every endpoint meeting the goal) runs, safely, into the goal. For every determined process the converse holds, and for laws of change (ofMap) and partial laws (ofPartial) completion is the goal at the law's endpoint. A built two-outcome process (Branch) shows the converse fails without determinacy.
- **moves**
  - *pass a:* S: `runs_of_completes` (l. 46) gives existence of a run and safety and goal at every reachable endpoint for a completing plan.
  - *pass b:* S: `runs_of_completes` (l.46): for every Process P, Completes P safe goal s plan gives a trace, and every trace of the plan is safe and ends in the goal. `completes_iff_of_determined` (l.88): for Determined P, completes iff it runs and every trace is safe and ends in the goal. B: `Branch.runs_not_completes` (l.145): both moves run from 0 and every endpoint is 3, yet the plan does not complete.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
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
  - *settled by the third pass:* B (weak): `Branch.stuck` (l.122): `∀ t, ¬ process.step 2 () t` in the built `Branch.process` (l.114), where 2 is one of the two outcomes of the move from 0; `Branch.runs_not_completes` (l.145) uses it to give `¬ Completes process free (fun t => t = 3) 0 [(), ()]`. So a configuration reachable by one move from which no step is possible is concluded; it is not stated as something lost and not regained, nor as 'no course from 2 reaches 3'. [which pass was right: both in part; opened: Branch.process l.114, Branch.stuck l.122, Branch.ends_three l.127, Branch.runs_not_completes l.145, Branch.not_determined l.153, completes_iff_of_determined l.88]
  - *pass a:* B: `Branch.stuck` (l. 122) concludes there is no successor at state 2, reachable as a first outcome in `Branch.process` (l. 114).
  - *pass b:* N: `Branch.stuck` (l.122) only says no move is possible from 2.
- **both outcomes**
  - *pass a:* S: `completes_iff_of_determined` (l. 88) characterizes completion by existence of a trace and safety and goal for every trace endpoint under determinacy.
  - *pass b:* S (securing a target, not going on and ending): `completes_iff_of_determined` (l.88) and `completes_iff_runs` (l.102) are exactly-whens of completion for determined processes.
- **a comparison between two**
  - *pass a:* S: `completes_ofPartial_iff` (l. 181) transfers completion under free safety for the process of any partial map to the existence of a successful runPartial endpoint meeting the goal.
  - *pass b:* S in part: `completes_ofMap_iff` (l.162) carries Completes on the process `ofMap f` to the goal at `plan.foldl f s`. `completes_ofPartial_iff` (l.181) carries it to `runPartial f`. These relate a process and its law, not two processes.
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
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and moves, both_outcomes, comparison. Built statements supply no_return. The remaining fields are N. None were unreached.
  - *pass b:* Answered from statements or N. All statements were read, the whole module (195 lines).

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-01

*As "Assurance.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-01.md.txt).*

- **an exact statement of both outcomes**: S: `completes_iff_of_determined` (l.88). Section variables `{S : Type u} {A : Type v}` (l.38). For `P : Process S A`, `determined : Determined P`, and any `safe`, `goal`, `s`, `plan : List A`: `Completes P safe goal s plan ↔ (∃ t, Trace P s plan t) ∧ ∀ t, Trace P s plan t → SafeTrace P safe s plan t ∧ goal t`. Same shape: `completes_iff_runs` (l.102), `completes_ofMap_iff` (l.162: `Completes (ofMap f) free goal s plan ↔ goal (plan.foldl f s)`), `completes_ofPartial_iff` (l.181: `↔ ∃ t, runPartial f s plan = some t ∧ goal t`). The two outcomes are that one finite plan completes or does not. The condition is a re-description in traces, not a threshold. It is of securing a goal, not of going on and ending.
- **the side that keeps**: N: the completing side asserts that a trace exists, every trace is safe and every endpoint is in `goal`. No region closed under the step, no kernel, no fixed point. `Completes` (InquirySufficiency.lean l.31) is a recursion on the plan's list.
- **the side that ends**: N: the failing side is only `¬ Completes`: no trace, or some trace unsafe, or some endpoint outside `goal`. Nothing is bounded by the statement and nothing falls; the plan is a finite list on both sides alike. Opened: `Branch.stuck` (l.122: `¬ process.step 2 () t`), `Branch.runs_not_completes` (l.145), `Branch.ends_three` (l.127), `completes_ofPartial_iff` (l.181).
- **moves in that statement**: S, as a choice made once at the start: `plan : List A` is a parameter of the statement, fixed before the course and not read off the configuration. `Completes` quantifies over every successor of each move (`∀ t, P.step s a t → …`), which under `Determined` is at most one. There is no "some move" or "every move" in the statement.
- **a reading in that statement**: N
- **the carrier**: A `Process S A` with `Determined P`, a plan `List A`, `Completes P safe goal s plan`, `Trace P s plan t`, `SafeTrace P safe s plan t`. For l.162 the process is `ofMap f` with `f : S → A → S`; for l.181 it is `ofPartial f` with `f : S → A → Option S`.
- **what is handed in**: Handed in: the process, `Determined P`, `safe`, `goal`, the start `s` and the plan. Concluded: that completing is running safely into the goal. No level, giving, share, favouring, reading or turn appears.
- **links to other modules**: (1) `completes_iff_of_determined` (l.88) names `Completes` and `SafeTrace` (InquirySufficiency.lean l.31, l.37), `Trace` and `Process` (GenerativeCore.lean) and `Determined` (Laws.lean l.48): an equivalence characterizing `Completes` for determined processes. (2) `runs_of_completes` (l.46): for every `Process`, `Completes` gives a `Trace`, and every trace is a `SafeTrace` ending in `goal`. (3) `completes_ofMap_iff` (l.162) names `ofMap` (Laws.lean l.64): the instance for a law of change. (4) `completes_ofPartial_iff` (l.181) names `ofPartial` and `runPartial` (Laws.lean l.70, l.76): the instance for a partial law. (5) `Branch.not_determined` (l.153): `¬ Determined Branch.process`, a built process outside the premise.
- **standing**: None seen. The opening account says (l.29): "No premise is added; every declaration has an empty axiom report." Not checked by running.
- **note**: This module counts against the thought: a general exactly-when with moves (a plan as a parameter) and no reading, with neither a closed region nor a rank on either side. `Branch.runs_not_completes` (l.145) shows the condition is not exact without `Determined`: both moves run from 0 and every endpoint is 3, yet the plan does not complete.
