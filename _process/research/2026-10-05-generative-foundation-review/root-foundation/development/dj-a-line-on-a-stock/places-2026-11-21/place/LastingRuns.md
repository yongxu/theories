# LastingRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LastingRuns.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-09, as "LastingRuns.lean: lasts_iff_runs, guarded_none_iff, stays_below_iff, reaches_iff_runs" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-09.md.txt)); pass b: reader whole-b-33, as "LastingRuns.lean: lasts_iff_runs, reaches_iff_runs, stays_below_iff, determined_lasts_iff_courses, reaches_iff_not_lasts_courses, drained_of_courses, collapse_leaves, needs_admissible_runs" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-33.md.txt)); the third pass, where the two differed: reader whole-c-settle-12, as "LastingRuns.lean: settled fields level" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-12.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `LastingRuns.lasts_iff_runs` (l. 71) equates lasting n with every run from the start staying guarded through n if some disturbance is admissible. With the additional premise of a decidable target, `reaches_iff_runs` (l. 165) characterizes bounded reaching by every run hitting the target within the horizon.
  - *pass b:* The module restates Lasting's laws on runs of the disturbed process and on courses of a determined law's process: lasting n iff every run stays within the guard n steps (lasts_iff_runs), reaching iff every run meets the target within n (reaches_iff_runs), and reaching iff not lasting on courses (reaches_iff_not_lasts_courses). It also has the worst-growth law on runs (stays_below_iff) and decision-needed results. Laws are general; Collapse, Search and needs_admissible_runs are built.
- **moves**
  - *pass a:* S: `courses_iff_of_exact` (l. 108) identifies guard preservation by every admissible plan of length ≤ n with membership of the start at level n of a family that is both a ladder and necessary.
  - *pass b:* S: `lasts_iff_runs` (l. 71): given one admissible disturbance, a start lasts n iff every run of disturbed f adm from it stays within the guard for its first n steps. `reaches_iff_runs` (l. 165): given one admissible disturbance and a decided target, reaching within n iff every run meets the target within n.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a level that runs down**
  - *settled by the third pass:* N for a stock with an amount; S for a horizon-indexed family. `drained_of_courses` (l. 115): with `Lasting.Drains f adm guard L` (Lasting.lean l. 128: `guard x → L 0 x`; `guard x`, `adm a`, `L k (f x a)` give `L (k+1) x`), one admissible `a₀`, and every `Trace (disturbed f adm) s plan t` with `plan.length ≤ n` ending in the guard, `L n s`. `L : Nat → S → Prop` is a family of predicates by number of steps, not an amount held by a configuration; nothing runs down and comes back. B: `collapse_leaves` (l. 126) for `Lasting.Collapse.step`: drained and `true` at level 1, yet a course of one disturbance leaves the guard. [which pass was right: both in part; opened: `lasts_iff_runs` l. 71; `courses_iff_of_exact` l. 108; `drained_of_courses` l. 115; `collapse_leaves` l. 126; `stays_below_iff` l. 142; `Lasting.Lasts`, `Ladder`, `Drains` (Lasting.lean l. 105-131). Section `Disturbed` variables `{f : S → A → S} {adm : A → Prop} {guard : S → Prop}`.]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `drained_of_courses` (l. 115): given one admissible disturbance, a drained family holds at level n every start whose courses of at most n moves stay within the guard. Levels are horizon families, not stocks. B: `collapse_leaves` (l. 126).
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **a point of no return**
  - *pass a:* S: `guarded_none_iff` (l. 97) concludes that the guarded history has stopped by n exactly if the run failed to stay within its initially met decidable guard through n. Any later horizon still includes that failure.
  - *pass b:* B: `collapse_leaves` (l. 126): from a start at level 1 of a drained family some course of at most one disturbance leaves the guard. S: `reaches_excludes_courses` (l. 272): reaching the target from every seed rules out a closed avoiding set holding a seed. Leaving is concluded at the guard's level.
- **both outcomes**
  - *pass a:* S: `guarded_upto_iff` (l. 83) and `guarded_none_iff` (l. 97) give both outcomes of the guarded run at n. `reaches_iff_not_lasts_courses` (l. 234) gives the bounded course duality for a determined law and decidable target.
  - *pass b:* S: `reaches_iff_not_lasts_courses` (l. 234): for a determined law and decided target, some course of at most n moves ends in the target iff not every such course ends outside it. `dual_needs_decision_courses` (l. 246): without the decision this would eliminate double negation. General.
- **a comparison between two**
  - *pass a:* S: `stays_below_iff` (l. 142) relates all runs bounded stepwise by g and starting below v to every run of g from v, for reflexive transitive comparison preserved by g.
  - *pass b:* S: `stays_below_iff` (l. 142): every run of Courses.anyChange V from at or below v whose growth g bounds stays at or below θ for n steps iff every run of Law.process g from v does. This carries between two processes. `lasts_iff_runs` (l. 71) carries between histories and runs; `reaches_trans_runs` (l. 185) composes reaching on runs.
- **a rank (an ending within a bound)**
  - *pass a:* S: `reaches_trans_runs` (l. 185) gives a hit by k+m from a start reaching a region by m if every member reaches target by k. `drained_of_courses` (l. 115) makes level n necessary for safety of every plan up to n, given an admissible disturbance.
  - *pass b:* S: `reaches_iff_runs` (l. 165), meeting within n; `runs_iff_of_exact` (l. 176); `numeric_needs_decision_courses` (l. 261): a numeric variant for every course into a target would decide equality.
- **a closed region**
  - *pass a:* S: `reaches_excludes_courses` (l. 272) excludes a target-disjoint closed set containing a seed when every seed has a course of the determined law reaching target.
  - *pass b:* S: `reaches_excludes_courses` (l. 272), closed sets avoiding the target; `courses_iff_of_exact` (l. 108), a ladder-and-necessary family being exactly what every course keeps in the guard. B: `needs_admissible_runs` (l. 288): with no admissible disturbance there is no run, while the configuration is not in the kernel of the empty guard.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found in what was read.
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring where present. S for states, moves, no_return, both_outcomes, comparison, rank, closed_region. N for reading, share, level, giving, cost, multiplying, forms_change. No U fields.
  - *pass b:* All statements of the whole module (299 lines) were read. Moves, level, no_return, both_outcomes, comparison, rank and closed_region came from statements and built cases; the rest are N.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge-13

*As "LastingRuns.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge-13.md.txt).*

- **an exact statement of both outcomes**: S, the edge of Lasting.lean restated on courses. `reaches_iff_not_lasts_courses` (l. 234), section Determined with `variable {S : Type u} {next : S → S}`: given `target : S → Prop`, `[DecidablePred target]`, `n`, `s`: `(∃ plan t, Trace (Law.process next) s plan t ∧ plan.length ≤ n ∧ target t) ↔ ¬ ∀ plan t, Trace (Law.process next) s plan t → plan.length ≤ n → ¬ target t`. `dual_needs_decision_courses` (l. 246) shows the decision is needed. Also, for one given run, two halves: `guarded_upto_iff` (l. 83) and `guarded_none_iff` (l. 97), section Disturbed with `variable {S} {A} {f : S → A → S} {adm : A → Prop} {guard : S → Prop}`: for `r : Run (disturbed f adm)` with `guard (r.state 0)` and `[DecidablePred guard]`, `guardedHistory f guard (r.state 0) r.act n` is `some (r.state n)` exactly when `∀ k, k ≤ n → guard (r.state k)`, and `none` exactly when not.
- **the side that keeps**: The statement only asserts staying outside the target on every course of at most `n` moves, a finite horizon. A closed set appears in one direction: `reaches_excludes_courses` (l. 272): `∀ s, seed s → ∃ t, Reach (Law.process next) s t ∧ target t` gives `¬ ∃ K, (∃ s, seed s ∧ K s) ∧ (∀ x, K x → ¬ target x) ∧ ∀ x, K x → K (next x)`. `courses_iff_of_exact` (l. 108): a family that is a `Lasting.Ladder` and `Lasting.Necessary` is exactly what every course of at most `n` moves of `disturbed f adm` keeps within the guard (levels, not a closed region).
- **the side that ends**: Within `n` moves, the bound being on `plan.length`; no rank falls in the edge statement. Elsewhere: `reaches_iff_runs` (l. 165), meeting the target within `n` on every run; `reaches_trans_runs` (l. 185), within `k + m`; `drained_of_courses` (l. 115), a `Lasting.Drains` family holds what every course keeps within the guard, given `adm a₀`; a variant `V` occurs only inside the hypothesis of `numeric_needs_decision_courses` (l. 261). B: `collapse_leaves` (l. 126).
- **moves in that statement**: N in substance: the edge quantifies over `plan` (some plan, every plan) of `Law.process next`, a `Process S Unit` whose step is `t = next s` (Recurrence), so a plan is a list of `Unit` and there is one course of each length. With a real allowed set, each side stands alone: `lasts_iff_runs` (l. 71) and `reaches_iff_runs` (l. 165) over every `Run (disturbed f adm)` given `adm a₀`; `courses_iff_of_exact` (l. 108) over every plan. `guarded_upto_iff` / `guarded_none_iff` are of one given run with its moves `r.act`.
- **a reading in that statement**: N. `target` and `guard` are predicates of the configuration; no observation or class read alike occurs in any statement of the module.
- **the carrier**: Courses `Trace (Law.process next) s plan t` of a determined law `next : S → S`; the other statements on `Run (disturbed f adm)` and `Trace (disturbed f adm)` for `f : S → A → S`, `adm : A → Prop`.
- **what is handed in**: Only `next`, `target` and its decision; no level, giving, share, favoured, reading or turn. In `drained_of_courses` and `courses_iff_of_exact` the family of levels (drained; ladder and necessary) is a premise.
- **links to other modules**: 1. `lasts_iff_runs` (l. 71): `Lasting.Lasts f adm guard n s ↔` every run of `disturbed f adm` from `s` stays within the guard for `n` steps, given `adm a₀`: Lasting's law read on runs. 2. `reaches_iff_runs` (l. 165): `Lasting.Reaches f adm target n s ↔` every run meets the target within `n`, given `adm a₀` and a decided target. 3. `courses_iff_of_exact` (l. 108), `runs_iff_of_exact` (l. 176), `drained_of_courses` (l. 115): on `Lasting.Ladder`, `Lasting.Necessary`, `Lasting.Funnel`, `Lasting.Basin`, `Lasting.Drains`. 4. `determined_lasts_iff_courses` (l. 218): `Lasting.Lasts (Lasting.determined next) (fun _ => True) guard n s ↔` every course of at most `n` moves of `Law.process next` ends within the guard. 5. `needs_admissible_runs` (l. 288): the process with no admissible disturbance has no run while `()` is not in `Kernel … (fun _ => False)` (Viability); `collapse_leaves` (l. 126) on `Lasting.Collapse.step`; `search_runs_need_decision` (l. 196) on `Lasting.Search`.
- **standing**: None seen; the account says no axiom occurs. Principles appear only as what a hypothesised converse would give: the limited principle of omniscience in `search_runs_need_decision` (l. 196), double negation elimination in `dual_needs_decision_courses` (l. 246), decided equality in `numeric_needs_decision_courses` (l. 261).
- **note**: The module adds no edge of its own: it reads Lasting.lean's on runs and courses, and its exactly-when is again of a determined law, where the plan is not a choice. With every run of `disturbed f adm` it has lasting and reaching as separate exactly-whens, and no statement between them.
