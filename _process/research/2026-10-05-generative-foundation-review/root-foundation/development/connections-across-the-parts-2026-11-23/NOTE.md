# Ways the parts of the picture connect: a running record

*AI-written (Claude Fable, the coordinating session), begun 23 November 2026, at Ren's word: "when you see ways they get connected, record them". Each entry says what connects, the declarations, and what has and has not been checked. An entry marked PROVED is a join that Lean already has; its "proved from" was checked against the print of uses between proofs at main `97609c577`. An entry marked CANDIDATE is a statement no one has written; it was argued by one reader from the statements and is unchecked.*

*How it was made. Ten readers of another kind of model (gpt-6.2-sol, effort high, read-only, each alone) read the 297 modules that the coordinating session's sorting of that day had put in none of four parts; their briefs, their returns word for word and the list of modules each had are filed beside this page. They returned sixty connections. Of 48 claims that one named theorem is proved from another, 46 are as the print has them; one theorem is in a module the print does not hold (`FallibleInquiry`), and one pair was the coordinating session's own guess and is not so. The themes below are the coordinating session's grouping. Nothing here was built.*

The four parts, a reading and not a measure: **A** the relation (what a going-on rests on, against what makes a difference to it); **B** through time (the lock, a level, turning in time, pace); **C** through accounts (how a reading forms, spreads, locks, is learned and corrected); **D** through scale (wholes, joining, coarser steps).

## What the read changed in the picture of how far the parts are joined

The count of that afternoon (between B and D: nothing) was of four lists of modules the coordinating session chose. The readers found that much of what joins the parts lies in modules outside those lists, most of it October's: `Continuation`, `GroupEnding`, `Wholes`, `Optimum`, `SetPointOptimum`, `CoupledDrawers`, `FreeEnergyGuarantees`, `SelectionPool`, `ProjectedLaws`, `GrammarRegularity`. So the parts are less apart than the count said. What stays apart is narrower and can be named: November's line, lock and level against October's drawdown of a family; and `Sampling` against the laws of time.

## 1. One law of drawdown, used at many grains (B with D; PROVED on October's carrier)

- **The law.** Under balance, activity needing support, only active givers and renewal gated at a need m: n steps of excess from a stock below n + m end what needs that stock at m or more (`Becoming.Flow.family_excess_ends`, `Flow.below_of_excess`, `Flow.joint_excess_ends`, in `Continuation`).
- **Where it is used, by the print.** A whole made of parts ends (`Web.Whole.family_excess_ends`, `Wholes`); a group ends and selection among groups changes (`GroupEnding.Flow.ended_of_family`, `coupled_end_together`); a lineage that wins within a whole ends with its conditions (`Founding.Flow.ConfinedRise.ends`); holders of local set points end a shared renewal (`Flow.held_excess_ends`, `Optimum.HeldPair.held_end`: the pool goes 2, 1, 0 while neither holder registers it); every branch ends at a grain (`Web.family_excess_degenerates`, `MapInstances`); read off an exchange (`World.ReadOffExchange.family_excess_ends`); a ranking (`Flow.coupled_ending_ranked_below`). Theorems of nine modules reach `Flow.family_excess_ends`; of three more, `Flow.below_of_excess`.
- **What is not joined (CANDIDATE, the largest).** November's line on a stock says the same thing on another carrier: a way whose units' offspring take more runs the level below a need (`LineOnAStock.need_unmet`, `way_ends`), and `WayUnderARule.tested_or_ends` gives both outcomes. No theorem of `LineOnAStock`, `TurningInTime`, `WayOfUnits`, `WayUnderARule` or `LevelAlone` reaches the family law or is reached by it. The direction page says of this join that two built courses agree step by step and that it "is not tried in Lean". Stated: a line on a stock is a family on the web whose record balances, so that the family law gives the line's ending and the line's laws give the family a condition for both outcomes.

## 2. Reading at coarser steps against the laws of time (B with D; CANDIDATES, about ten short statements)

`Sampling` has what composes across a stretch. The time laws have deadlines. The readers found no statement that puts one on the other, and proposed these, each a short argument from named theorems:

- **Two notions of a coarser step that never meet.** `Pace` (a rule that changes only at reading steps: `Pace.paced`, `rule_until_reading`) and `Sampling` (a world read at strictly increasing times) do not import each other. Row GR's attempt of 23 November was withdrawn as the lock's laws re-indexed, so a join must say more than that.
- **A slower reading spends the margin before correction.** With `Optimum.reread_kept_iff` and `reread_deadline_iff`, a correction seen at sample j and acting from fine step σ j keeps the need exactly where m + σ j · (k − r) ≤ x 0.
- **A sampled selection's deadline in fine time.** A selection on sampled histories can separate two courses while the first is recoverable exactly where some retained step σ s before the point of no return shows a member admitted differently (`ReadOffInTime`: `NoReturnAt.recoverable_iff`, `firstApart_of_apart`; `Web.sample`).
- **Sampling can erase a read that arrives in time.** `Strobe.flick_even`, `flick_odd` with `ReadingSchedule.keeps_iff_within`: read at every step the schedule keeps; read at the even steps it does not.
- **Sampling can hide a break an optimum makes.** `Optimum.Holding.logistic_valued` breaks a dependence at step one and regrows; sampled at 0 and n + 2 it is selected alike with the course that never breaks (`Web.sample_selects_alike_iff`).
- **A guard kept at every block boundary can fail inside a block,** and a coarse block keeps the fine cutoff only if the guard is checked at every fine source (`Frame.blocks_trace_iff`, `Law.stepWhile_steps_iff`, `Viability.Kernel`).
- **Draw bounds survive a stretch read as one step:** for joint plans (`Flow.level_kept_of_plans` with `Flow.sample_taken`, `sample_given`), for a hierarchy of tiers (`Flow.uptake_le_tiers`), for stock loss summed over a block (`Flow.BalancesOn.sample_byOccurrence` with `Stock.trace_falls`), and for a rise that breaks an unread need (`Flow.Balances.rise_lowers_beyond_dissipating` on the sampled flow).
- **Two-step blocks can hide recurring change** (`RunTurns.reversing_period_two` with `Frame.blocks_trace_iff`).
- **PROVED nearby:** `Pace.stretch_fixed` and `TwoCourses.core_iff_bounded` are both from `Identification.bounded_agree`, one bound on two carriers; a reserve's duration depends on the unit and on the clock (`Web.CarriesAt.lasts`, `Lapse.reserve_step_relative`; `Feeding.endless`).

## 3. Accurate accounts, joint depletion (A, B, C and D together; PROVED in witnesses)

- **Each account right, the whole run down.** `FreeEnergyGuarantees.SharedModels.held_not_one`: two holders use one prediction rule, each predicts its own store rightly and chooses at no risk, each draw fits renewal, their sum exceeds it, and the pool lies outside both holders' couplings. From `Optimum.HeldPair.held_end`, from `Flow.held_excess_ends`.
- **A reward that registers a shared need which no one's own change can reach.** `Optimum.Coupled.gated_threshold` against `Optimum.Coupled.AtOnce.Shores.drain_perfect` (`CoupledDrawers`).
- **Joining drawers changes what restraint returns.** `Optimum.mutual_as_one`; `Optimum.Holding.halves_race`: full draw is perfect for two half-share drawers, joint restraint pays both more, and one drawer who received the whole would not drain.
- **A better account can leave too little to act on it** (`WitnessRefinement.step_then_completes`); **one process revises its distinctions and spends what lets it revise** (`ReferencePlanTraces.revise_gains_contact` with `ReferencePlan.covered`, from `Stock.covered_of_trace`); **getting the answer is not executing the correction** (`Actuation.timely_trace`, `late_no_trace`).
- **CANDIDATE.** These are built cases. The general statement they point at, an account exact of what each registers while what all rest on runs down, is the lock's own picture and is stated of the lock only on a share (`ClosedCapture`).

## 4. The lock as an account that is exactly closed (B with C; PROVED)

- `ClosedCapture.constant_iff_unread` (`GrammarRegularity`): share, rule and count are constant under every reading schedule exactly where the next share and the rule read do not depend on the coordinate left out; from `Learning.goAlike_iff_lumped`. `ClosedCapture.lock_line`: an unending locked line with the loss changing at every step, from `lock_outlives_loss`.
- So the lock is already stated as a coarse law that forgets a coordinate which goes on changing. The general test for when a coarse account carries a law of its own is `ProjectedLaws.reduced_law_exists_iff` (fibre consistency). **CANDIDATES under it:** `Dephasing` (a projected law at two steps where none exists at one), `SummaryFutures` (exact feasible words with no deterministic summary update), and `WeightedTraces.lumped_iff` at one move, each argued as a case and not written.

## 5. What a pool can select that no member can (A with C and D; PROVED)

- `Direction.exchange_widening_selected_by_pool` (through `Flow.act_selected_by_pool`): a changed admission is selectable by any pool containing the formation and by no pool confined to the acting group's closure. `Clearing.selected_pooled` and `Clearing.pooled`: each reader has a history it cannot tell apart, and neither survives the intersection. `Flow.returning_pool_covers`; `World.withRest_unselected_beyond_pool`.
- **Against it:** a grouping can hide a transfer's losses and gains (`Transfer.generated_mixed_hidden`), and local readings can each keep a guard that jointly fails (`Viability.ChoicePoint.keptFor_each_not_joint`, against `Viability.Plan.zip_keeps`).
- **CANDIDATE:** a cascade in which later readers ignore their own inputs makes every act list equal, so no selector of those lists carries the pool's distinction (`Turns.acts_alike_of_cascade` with `Clearing.selected_pooled`).

## 6. Deadlines by distance (A with B and C)

- **PROVED:** what an answer's deadline costs (`TimedResponse.answer_alike_before`, used in `FallibleInquiry`); coupling depth is the exact test for cutting off a bound (`gap_within_order_iff`, `gap_within_order_iff_worlds`); what a law reads bounds where differences arrive (`ExchangeLaw.insensitiveAt_iff_strength_zero`, `Conveyed.spread`); dropping dates can create apparent mutual dependence (`LatePair.apart`).
- **CANDIDATES:** a coupling distance rules out a turn (`TimedResponse.turned_at_juncture` against `not_reached_of_far`); threshold blindness can outlast recoverability (`break_carried_nowhere` with `Web.too_late_of_alike`).

## 7. Selection among groups, lineages and rules (A with B and D; PROVED)

- Selection terms leave a lineage's fate open, on two carriers (`SelectionShift.Horizon.same_terms_two_fates`, `LineageRegions.Courses.same_terms_two_fates`). A family's inflow bounds the response to selection (`SelectionPace.response_sq_within_inflow`). Rule rebuilding on a count becomes a replacement law with weight on complete loss even from a favoured count (`DrawnReplacement.favours_iff`, `fixation`, `lost_ge`, against `DrawnShaping.drawn_locks`).

## What this record does not say

That any candidate holds. That the sixty are all there is: each reader says what it did not read, and the larger modules were read at their statements in part. That the grouping into seven themes is the map's own; it is one session's reading of ten returns.
