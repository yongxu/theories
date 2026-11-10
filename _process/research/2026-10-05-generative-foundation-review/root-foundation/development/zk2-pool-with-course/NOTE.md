# K2: readers the course removes — the meta-attractor as a dynamic (study note)

AI-written (Claude Opus 5.5), 10 November 2026. Route (b)'s round K, piece K2 (board row K2; the round's brief is `/Users/ren/tmp/za-how-far/route-b/K-ROUND.md`, outside the repository). Ren's words: route (b) to be completed carefully and in parallel (9 November 2026, [kept](../../../../../../sources/15-codex-theory-conversations/2026-11-09-route-b-ethics-forms.md)); the dynamics connected, mapped and unified, with the higher orders as dynamics of their own (10 November 2026, on ED6's branch until it lands). Home: [02 §10](../../../../../../theories/becoming/chapters/02-MAP.md#pool-from-course). Lean: [`Becoming.PoolFromCourse`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PoolFromCourse.lean). The design and its first cold reading: [DESIGN.md](DESIGN.md). Readers' rounds: [READER.md](READER.md).

```text
Result(s): new records a-pool-read-off-the-course, the-lock-draws-its-readers-out, on-whom-the-loss-falls; reuses capture-through-the-rule (turn_locked, order_kept), closed-capture (course_past, join_course, loss_grows), readers-drawn-from-the-selected (Thinned.lossPool), shaping-the-rule-selected-by-what-comes-back (shaped, favours_iff, falls_strictly)
Delta: what the rule reads is read off the course: a pool whose readers of what lies beyond the share stand only where the course leaves them; where a lock read off the share can be left; readers a loss removes; the loop by which a lock draws its readers out (order kept in share, loss and rule with the readers' bound reversed); on whom the loss falls (MA3's lever with the loss)
Supplied premises / correspondence: presence of readers is a predicate (ReadsThroughPresent, NotReadmitted supplied); the drain monotone in share, loss and rule; the readers reading never above the share-readers; that actual pools, readers or drains are so is not shown
Evidence: Becoming.PoolFromCourse, 40 theorems, every axiom report empty (scratch build and prelude-only run, 10 November 2026; core receipt at landing)
Boundary: kept failure the clock design (DESIGN.md); presence drops how many read and which lines; no optimizer, no preference for removal beyond the order law; no noise
Integration: 02 §10 new; 07 §4.12's three candidates placed as regimes of who reads (02 §10 "What registers a removal"); AJ's condition 1's gap (what the rule reads fixed by premise) given a dynamic
```

## The question and the answer in short

J2 ([07 §4.12](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-a-selection-removing-its-readers)) stated a selection that removes its own readers, with persistence as the selection. 02 §9 states capture with its readers fixed by premise; AJ's plan §1 names the gap: "what the rule reads is fixed by the readers' premise, not by the shaping". K2 reads the rule through a pool whose readers of what lies beyond the share stand only where the course leaves them.

- **How the pool changes with the course.** The readers of a loss stand while it is below a bound and are gone from it on; the loss grows by what the course draws, and in the witness the shapers draw more the more they outnumber the others.
- **When the loop closes.** Removed and not readmitted, the readers read nothing; the rule is read off the share, and a lock that forms is kept for good while the loss grows (`closed_stays_closed`, `window_locked_after_removal`); what they read changes nothing once they are gone (`window_removed_unregistered`). With the readers reading from when they stand, their reading monotone and never above the share-readers', and selection, reading and drain monotone, two courses keep their order in share, loss and rule with the bound reversed (`window_order_kept`): a share not lower draws no less and its readers go no later; readers gone at a bound not higher leave a share not lower.
- **What can keep it open.** A lock read off the share is left only along a stretch containing a reading step read otherwise (a reader of the beyond present and reading against) or a step at which the share fell (`locked_along`; where leaving can lie, not that it happens). So, as necessary conditions, none shown sufficient: readers present, because their standing does not hang on the loss and is not read off the course (`ClosedCapture.turned_by_loss`), or hangs only on the share (`Thinned`); readers admitted from outside the pool (`NotReadmitted` failing); the loss borne by the shapers (`borne_falls`, `bear_shaped_shapers`); readers reading enough, while they stand, to carry the share across the share-readers' threshold (`Drained.weak_turned` against `Drained.strong_undone`).

## What is proved, and how much is by construction

Every law is a short composition of §9's laws: near-definitional. What is new is the statement (presence as a coordinate of the configuration, read off the course) and the witnesses.

1. `turn_locked_at`: `RuleCapture.turn_locked` with the share type `Bool` and the order pulled back along `false ↦ x`, `true ↦ y` (`twoShares`); its `Raises` premise quantifies over the two points and holds by the step's own `P.le x y`; its `ReadsShare` premise is the share-readers' reading's, monotone everywhere by hypothesis. So the one-step law is `turn_locked`'s, not a second proof (board rule 9). `locked_along` is its induction; `closed_stays_closed` its induction with presence carried.
2. `window_*`: `ClosedCapture.course_past` and `join_course` past the bound, `closed_stays_closed` with `Stands`, `loss_grows` for the bound on the loss. `window_standing_thinned` is a computation on `Nat.ble`.
3. `window_order_kept`: `RuleCapture.order_kept` on `A × Nat × Nat` (share, loss, bound) with the bound reversed in the order (`boundOrder`), the window's reading monotone there (`boundRead_reads`, four cases, one impossible), and `bound_course` identifying that course with the window's. Needs the readers to read from when they stand (`N = 0`): with `N > 0` starting to read lowers the rule, so the reading is not monotone in the loss.
4. `bear_*`, `borne_*`: arithmetic on `RuleShaping.shaped` and `CarrierCounts.raises`, `RuleShaping.falls_strictly`.
5. Witnesses computed by `rfl` and `decide` on small counts, their "for good" by the laws above. The drain avoids Nat division (core's division lemmas use `propext`): one a step and forty more where the carriers outnumber the others sixteen to one; monotone in the share by `outnumber_mono`.

## Kept failures

See [DESIGN.md](DESIGN.md#kept-failures): the clock design (readers removed by a loss growing one a step whatever the selection did; the loop not shown), the "exits, exactly" wording, and "K unbounded" as a value.

## Which law, which dynamics

- Case of: RuleCapture's lock laws (`turn_locked`, `order_kept`) read on the configuration with the pool's presence, the loss and the readers' bound as coordinates; past the removal, closed capture's law of what the loop does not read (`course_past`, `join_course`).
- Joins: capture (02 §9), the drain beyond what couples in (07 §3.5's bound: the loss lies beyond the shapers' coupling and reaches the readers who would couple it into the rule), persisting's filter and instrumental convergence's self-preservation half (07 §4.9; a reading in 02 §10), J2's selection removing its readers (07 §4.12), a pool recruiting through itself (05; `NotReadmitted` its analogue, supplied).
- K1's lines carrying readings are not used: they were not on main when this landed. Agreed with K1 by message (10 November 2026): with `present` the beyond-reading's carrying count positive, `NotReadmitted` is K1's revision into the reading being zero wherever the count is zero (K1's `SelectionTerm.Generations.absent_step`, on K1's branch), and readmission is exactly a revision into it, which by K1's `fixed_of_present` needs a reading from beyond the cohort. Whichever lands second states that join in its record.

## Checks

Scratch build of `Becoming.PoolFromCourse` (10 November 2026): 40 theorems, 60 declarations, every axiom report empty, no warning; prelude-only run and signatures clean. Core run and gate: at landing, recorded in the records and the board's history row.
