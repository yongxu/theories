# KeepableStep

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/KeepableStep.lean`
- *result records that name this place's file as a source* (computed; not a link): `conditions-kept-together`, `kept-at-the-length-of-a-list`
- *dynamics in the atlas that name one of those records* (computed; not a link): `never-leaving-a-guard`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "KeepableStep.lean: keepable_step_iff, not_keepable_invariant_iff, ChoicePoint.keepable_gained" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-31, as "KeepableStep.lean: Viability.keepable_step_iff, not_keepable_invariant_iff, not_keepable_step, not_keepable_run, ChoicePoint.keepable_gained, Successor.not_keepable_kept_complement_not" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-31.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "KeepableStep.lean: settled fields comparison, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For every process a guard is keepable iff it holds now and some successor is keepable (keepable_step_iff, l. 50). Nonkeepability is invariant exactly when no step from outside the guard leads to a keepable state (not_keepable_invariant_iff, l. 68).
  - *pass b:* The module gives general laws for every process and guard. A guard is keepable from s exactly when it holds at s and some step leads to a configuration it is keepable from (keepable_step_iff). Not being keepable is kept by every step exactly when no step from outside the guard leads to a keepable configuration; where every step keeps the guard's complement, keepability is not gained along a run. Built cases (ChoicePoint, Successor) show that this premise is needed for the step law and is not the least.
- **moves**
  - *pass a:* S: keepable_step_iff (l. 50) quantifies over both action and successor for existence of a continuing guard-preserving run.
  - *pass b:* S: `keepable_step_iff` (l. 50): g is keepable from s iff g s and there is some step from s to a t from which g is keepable. This is a law of what some choice keeps.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
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
  - *pass b:* N.
- **a point of no return**
  - *pass a:* S: not_keepable_run (l. 94) assumes initial nonkeepability and a step-closed guard complement and concludes nonkeepability at every later state. B: ChoicePoint.keepable_gained (l. 115) gains keepability in one move without this premise.
  - *pass b:* S: `not_keepable_invariant_iff` (l. 68): not-keepable is invariant iff every step from outside g leads to a non-keepable configuration. `not_keepable_step` (l. 83) and `not_keepable_run` (l. 94): where every step keeps not-g, along a run whose start is not keepable no configuration is keepable. This is concluded under the premise `closed`. B: `ChoicePoint.keepable_gained` (l. 115): without the premise, keepability is gained in one step.
- **both outcomes**
  - *pass a:* S: keepable_step_iff (l. 50) gives an exact criterion for the existence of an indefinitely keeping course in one arbitrary process.
  - *pass b:* S, general: `keepable_step_iff` (l. 50) states exactly when a guard is keepable. `not_keepable_invariant_iff` (l. 68).
- **a comparison between two**
  - *settled by the third pass:* S (weaker: carried along one step of one process, not between two processes or ways): `not_keepable_step` (l. 83), section variables `S`, `A`; premises `closed : ∀ s a t, P.step s a t → ¬ g s → ¬ g t`, `lost : ¬ Keepable P g s`, `step : P.step s a t`; conclusion `¬ Keepable P g t`. It carries not being keepable from the source to the target of a step, which is an invariance (`not_keepable_invariant_iff`, l. 68, states it as `Invariant P (fun s => ¬ Keepable P g s) ↔ …`); there is no simulation, order, covering or second process in the module. [which pass was right: both in part; opened: keepable_step_iff l.50; not_keepable_invariant_iff l.68; not_keepable_step l.83; not_keepable_run l.94]
  - *pass a:* S: not_keepable_step (l. 83) propagates nonkeepability from the source to the target of any step under closure of the guard complement.
  - *pass b:* N.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: not_keepable_invariant_iff (l. 68) characterizes closure of the whole nonkeepable region. B: Successor.not_keepable_kept_complement_not (l. 156) separates that closure from closure of the guard complement.
  - *pass b:* S: `not_keepable_invariant_iff` (l. 68) and `not_keepable_run` (l. 94): the region where the guard is not keepable is invariant under the stated condition. B: `Successor.nowhere_keepable` (l. 144).
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: `ChoicePoint.keepable_gained_along_run` (l. 125) states `¬ Keepable process afterSplit (leftRun.state 0) ∧ Keepable process afterSplit (leftRun.state 1)`, where `afterSplit` (l. 105) is false at `split` only; the guard fails at step 0 because it does not hold there, and holds from `left` on. That is a guard becoming keepable after the one configuration where it is false is left, not the going on continuing while what is present changes, and not a widening (from `left` every move returns to `left`). Opened to rule it out: `afterSplit` (l. 105), `keepable_gained` (l. 115), `keepable_gained_along_run` (l. 125), `Successor.nowhere_keepable` (l. 144), `not_keepable_kept_complement_not` (l. 156). [which pass was right: b; opened: afterSplit l.105; keepable_gained l.115; keepable_gained_along_run l.125; Successor.process l.137; nowhere_keepable l.144; not_keepable_kept_complement_not l.156; (JointKeeping) ChoicePoint.next l.166]
  - *pass a:* B: ChoicePoint.keepable_gained_along_run (l. 125) exhibits a guard which becomes keepable at the first successor along leftRun.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, no_return, both_outcomes, comparison, closed_region. Built cases support no_return, closed_region, forms_change. I found no matching statement for reading, share, level, giving, cost, multiplying, rank. No answer rests on prose alone or was unreached.
  - *pass b:* All answered from statements. Read whole (168 lines, all statements).

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-06

*As "KeepableStep.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-06.md.txt).*

- **an exact statement of both outcomes**: S. `Viability.keepable_step_iff` (l. 50): for `P : Process S A`, `g : S → Prop`, `s : S` (`S`, `A` from the section variable, l. 41), no further premise: `Keepable P g s ↔ g s ∧ ∃ a t, P.step s a t ∧ Keepable P g t`, where `Keepable P g s` is `∃ r : Run P, r.state 0 = s ∧ ∀ n, g (r.state n)` (JointKeeping l. 91). Its other outcome is `¬ Keepable P g s`.
- **the side that keeps**: S, by the edge statement itself: the keepable configurations are those within `g` from which some step leads to a keepable configuration, a set closed under SOME step. No statement here says it is the largest such set, and none relates it to the kernel (the docstring says so).
- **the side that ends**: N. `¬ Keepable P g s` says no run from `s` stays within `g`; when a run leaves is not bounded and nothing is stated to fall. What the module states of that side is another closed region: `not_keepable_invariant_iff` (l. 68), no premise: `Invariant P (fun s => ¬ Keepable P g s) ↔ ∀ s a t, P.step s a t → ¬ g s → ¬ Keepable P g t`; and `not_keepable_run` (l. 94): with `closed : ∀ s a t, P.step s a t → ¬ g s → ¬ g t`, a run `r` and `¬ Keepable P g (r.state 0)`, `¬ Keepable P g (r.state n)` for every `n`. All eleven declarations opened.
- **moves in that statement**: S. The statement has `∃ a t, P.step s a t ∧ …` (some action and successor), and `Keepable` is `∃ r : Run P` (some course). `not_keepable_invariant_iff` quantifies over every step (`∀ s a t`).
- **a reading in that statement**: N. The condition is on the guard at the configuration (`g s`) and on steps; no observation or class appears in any statement.
- **the carrier**: A `Process S A` with a guard `g : S → Prop`; `Keepable P g s`, `Run P`, `Invariant P`.
- **what is handed in**: None of level, giving, share, favouring, reading or turn occurs. `P` and `g` are parameters and the equivalence is concluded with no premise. In `not_keepable_step` and `not_keepable_run` the closure of the guard's complement (`closed`) and `lost` are premises.
- **links to other modules**: `keepable_step_iff` (l. 50) names `Keepable` (JointKeeping): its one-step form. `not_keepable_invariant_iff` (l. 68) names `Invariant` (Frame) and `Keepable`: an equivalence. `ChoicePoint.keepable_gained` (l. 115) names `ChoicePoint.process` (JointKeeping l. 174): `¬ Keepable process afterSplit .split ∧ process.step .split true .left ∧ Keepable process afterSplit .left ∧ ¬ ∀ s a t, process.step s a t → ¬ afterSplit s → ¬ afterSplit t`. `keepable_gained_along_run` (l. 125) names `leftRun`. `Successor.not_keepable_kept_complement_not` (l. 156) uses `Law.process Nat.succ` (Recurrence) through `process` (l. 137).
- **standing**: None seen. The account says no premise is added beyond what each statement names and that no decision of the guard is used.
- **note**: This module has moves in an exact statement with both outcomes and no reading, and its two sides are both regions: keepable (closed under some step) and, exactly under the condition of l. 68, not keepable (kept by every step). There is no rank. `ChoicePoint.keepable_gained` shows that without that condition not being keepable is not a point of no return: one step gains it.
