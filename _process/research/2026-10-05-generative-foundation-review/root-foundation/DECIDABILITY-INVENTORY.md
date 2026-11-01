<a id="可判定性清点--decidability-inventory-p58"></a>
# Decidability inventory (P58)

> Some passages exist only in the [Chinese edition](DECIDABILITY-INVENTORY.zh.md): sections “Theorems using decidability only in proofs”.

Generated: `DECIDABILITY-INVENTORY.py` runs `DECIDABILITY-INVENTORY.lean` on the core checked by consolidated receipt `20261016T124157.989030Z`, its source bytes matching the receipt (a periphery tool importing Lean's own library, which the core never does). Lean reads each row: whether a binder's type is a decidability family, a decided proposition (`p ∨ ¬ p` for a given `p`, such as the core's `Decided p`) or an excluded middle (`p ∨ ¬ p` for every proposition or predicate a binder ranges over, in full or restricted form), whether the statement depends on it, and whether the proof uses it.

<a id="总数--totals"></a>
## Totals

| Class | Count |
|---|---:|
| statements depending on it (counting or construction): decidedness is that statement's own condition | 437 |
| used only in proofs | 263 |
| unused | 0 |
| excluded middle, in full or restricted form, as a hypothesis (boundary theorems) | 34 |
| counting with decidedness proved, not assumed | 94 |
| definitions and instances proving decidedness | 149 |
| definitions taking a decidability family (counting primitives) | 117 |

<a id="理由--reasons"></a>
## Reasons

Where a statement depends on decidedness, the reason is given by the decidability-taking definitions its statement mentions, as Lean reads them; where only a proof uses it, each theorem is classified by hand, and generation asserts that every one is.

| Reason | Meaning | Theorems |
|---|---|---:|
| counts | counts: a count exists exactly where what it counts is decided (`counts_iff_decided`) | 77 |
| coarser reading | a coarser reading: each relatum listed once within a coarse step, which tells relata apart | 88 |
| one condition raised | one condition raised: tells conditions apart | 8 |
| dependence moved | dependence moved at unsupported steps: support decided | 3 |
| a kept list | a list kept by a determination: decided of its members | 9 |
| learning by refutation | learning by refutation: decides whether claims are refuted, to retain a hypothesis or select one borne out by the record, which tells values apart | 26 |
| first fitting member | first fitting member: decides the condition on each listed member in order | 16 |
| another value | another value: a value other than a given one, which tells values apart | 1 |
| a list without repetition | a list without repetition: membership decided | 7 |
| mixed in condition by condition | another history mixed in condition by condition: tells conditions apart | 8 |
| exchanging two values | exchanging two values: decides whether the input is either of the exchanged values | 40 |
| list membership | boolean list membership: tells values apart at each listed member | 1 |
| tells same from different | tells same from different: the proof splits on whether two conditions, relata, values or inputs are the same, or a condition is in a family | 203 |
| builds an indicator | builds an indicator: the proof uses the mark of a decided proposition (one where it holds, zero where it fails) as a number, such as a score | 51 |
| splits on a case | splits on a determination: the proof uses both its holding and failing cases | 35 |
| a guarded step | a guarded step: decides the guard at each step and stops where it fails | 10 |
| reached | reached: the proof builds the learner given the world from decided steps and registered values | 11 |
| finds | finds a step or a member: the statement asserts one exists, which without decidedness is only not refuted | 90 |
| builds a list | builds a list: a census or a list without repetition, from decided members | 16 |

<a id="陈述依赖可判定性的定理计数或构造--theorems-whose-statements-depend-on-decidedness-counting-or-construction"></a>
## Theorems whose statements depend on decidedness (counting or construction)

| Module | Theorem | Decidability | Reason | Other form |
|---|---|---|---|---|
| Change | `Web.activity_over_stretch` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | counts | its own condition |
| Change | `excess_mark` | `Decidable p`；`Decidable q` | counts | its own condition |
| Change | `fall_mark` | `(t : Nat) → Decidable (p t)` | counts | its own condition |
| Change | `held_over_stretch` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | no premise） |
| Change | `keep_pace` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | no premise） |
| Change | `mark_cases` | `Decidable p` | counts | its own condition |
| Change | `mark_iff` | `Decidable p`；`Decidable q` | counts | its own condition |
| Change | `mark_le_one` | `Decidable p` | counts | its own condition |
| Change | `mark_pos` | `Decidable p` | counts | its own condition |
| Change | `marks_within` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | no premise） |
| Change | `rise_mark` | `(t : Nat) → Decidable (p t)` | counts | its own condition |
| Contacts | `Contacts.agree_spot` | `DecidableEq I` | builds an indicator | its own condition |
| Contacts | `Contacts.spot_other` | `DecidableEq I` | builds an indicator | its own condition |
| Contacts | `Contacts.spot_self` | `DecidableEq I` | builds an indicator | its own condition |
| Copying | `Copying.batch_all_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.batch_all_swap` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.built_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.completes_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.copies` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_append` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_joinAll_replicate` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_joinAll_swap` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_other` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_remove` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_removeAll` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_remove_other` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_remove_self` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_self` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.countOf_setAt` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.defects_beyond` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.defects_break` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.defects_fix` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.defects_self` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.defects_zero_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.empties_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.exchange_keeps_counts` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.exchange_le` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.inspect_keeps_counts` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.inspect_le` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.inspect_le_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.inspect_matches_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.ite_cases` | `Decidable c` | splits on a case | its own condition |
| Copying | `Copying.lineage_all_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.nil_iff_countOf_zero` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.pos_of_supplies` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.readStep_extends` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.readSteps_extends` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.readSteps_fixed` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.reading_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.releases_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.scan_le` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.steps_fixed` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.supplied_of_completes` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.supplies_append_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.supplies_cons_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.supplies_nil` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.tick_cons` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.use_lt_iff` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.use_midpoint` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.use_pair` | `DecidableEq α` | tells same from different | its own condition |
| Copying | `Copying.use_word` | `DecidableEq α` | tells same from different | its own condition |
| Counterfactual | `mixIn_alike` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Counterfactual | `mixIn_either` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Counterfactual | `mixIn_listed` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Counterfactual | `swap_alike` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Counting | `World.binds_arising` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Counting | `World.counts_arising` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Counting | `World.enclosed_binds_counting` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Counting | `World.enclosure_bounds_change` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Counting | `World.finite_binding_census` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Counting | `World.taking_binds_counting` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Coupling | `policyUpto_agrees` | `DecidableEq K` | tells same from different | its own condition |
| Coupling | `policyUpto_taken` | `DecidableEq K` | tells same from different | its own condition |
| Courses | `Courses.copy_built_iff` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.copy_completes_iff` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.copy_empties_iff` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.copy_grows` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.every_released_iff_course` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.inspection_course_le` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.inspection_le_iff` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.lineage_course_iff` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.no_run_record_groups` | `DecidableEq A` | tells same from different | its own condition |
| Courses | `Courses.readSteps_orbit` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.reading_completes_iff` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.release_course_iff` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.run_settles` | `DecidableEq S` | tells same from different | its own condition |
| Courses | `Courses.runs_settle_iff` | `DecidableEq S` | tells same from different | its own condition |
| Courses | `Courses.steps_orbit` | `DecidableEq α` | tells same from different | its own condition |
| Courses | `Courses.tick_extends` | `DecidableEq α` | tells same from different | its own condition |
| Decidedness | `ceasings_counts` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Decidedness | `comings_counts` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Decidedness | `counts_total` | `(a : α) → Decidable (q a)` | counts | its own condition |
| Decidedness | `indicates_mark` | `Decidable p` | counts | its own condition |
| Dissipation | `adjoin_spec` | `DecidableEq α` | a list without repetition | its own condition |
| Dissipation | `insertNew_spec` | `Decidable (a ∈ l)` | a list without repetition | its own condition |
| Entropy | `mark_mono` | `Decidable p`；`Decidable q` | counts | its own condition |
| Identification | `Identification.answer_exceeds_bound` | `DecidableEq O` | first fitting member | its own condition |
| Identification | `Identification.firstFit_found` | `(a : α) → Decidable (p a)` | first fitting member | its own condition |
| Identification | `Identification.firstFit_sound` | `(a : α) → Decidable (p a)` | first fitting member | its own condition |
| Identification | `Identification.held_learner_rests` | `DecidableEq O` | learning by refutation | its own condition |
| Identification | `Identification.learner_rests` | `DecidableEq O` | learning by refutation | its own condition |
| Identification | `Identification.leastBound_exact` | `DecidableEq O` | first fitting member | its own condition |
| Identification | `Identification.leastFit_sound` | `DecidableEq O` | first fitting member | its own condition |
| Identification | `Identification.leastFit_within` | `DecidableEq O` | first fitting member | its own condition |
| Identification | `Identification.moved_on` | `DecidableEq O` | learning by refutation | its own condition |
| Identification | `Identification.rests_of_lasso` | `DecidableEq O` | learning by refutation | its own condition |
| Identification | `Identification.run_kept` | `DecidableEq O` | learning by refutation | its own condition |
| Identification | `Identification.withBound_exact` | `DecidableEq O` | first fitting member | its own condition |
| Identification | `Identification.withBound_holds` | `DecidableEq O` | first fitting member | its own condition |
| Identity | `Web.Census.balanceFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | counts | its own condition |
| Identity | `Web.Census.balanceFrom_at` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | counts | its own condition |
| Identity | `Web.Census.balanceFrom_eq` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | counts | its own condition |
| Identity | `Web.Census.balanceFrom_eq_at` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | counts | its own condition |
| Lasting | `Lasting.guarded_agrees` | `DecidablePred guard` | a guarded step | its own condition |
| Lasting | `Lasting.guarded_none_iff` | `DecidablePred guard` | a guarded step | its own condition |
| Lasting | `Lasting.guarded_upto_iff` | `DecidablePred guard` | a guarded step | its own condition |
| Lasting | `Lasting.guarded_within` | `DecidablePred guard` | a guarded step | its own condition |
| Lasting | `Lasting.hitTime_lowers` | `DecidablePred target` | first fitting member | its own condition |
| Lasting | `Lasting.hitTime_of_reaches` | `DecidablePred target` | first fitting member | its own condition |
| Lasting | `Lasting.hitTime_stable` | `DecidablePred target` | first fitting member | its own condition |
| Lasting | `Lasting.hitTime_succ` | `DecidablePred target` | first fitting member | its own condition |
| Learnable | `Learnable.firstFit_congr` | `(a : α) → Decidable (p a)`；`(a : α) → Decidable (q a)` | first fitting member | its own condition |
| Learnable | `Learnable.predicts_through` | `DecidableEq R` | learning by refutation | its own condition |
| LearnableRuns | `LearnableRuns.predicts_through` | `DecidableEq R` | learning by refutation | its own condition |
| Learning | `Learning.diagonal_not_lasso` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.held_learner_bounded` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.held_rest_unrefuted` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_kept` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_le_of_holds` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_le_succ` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_mono` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_mono_le` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_refuted` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_succ_le` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.index_unbounded` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.lasso_learner_bounded` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.lasso_of_rest` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.learner_through_record` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.merged_bound` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.merged_unrested` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.refutations_not_recurring` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.refuted_before` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.rest_unrefuted` | `DecidableEq O` | learning by refutation | its own condition |
| Learning | `Learning.selects_not_right_of_parted` | `DecidableEq K` | exchanging two values | its own condition |
| Learning | `Learning.selects_right_of_reads` | `DecidableEq K` | exchanging two values | its own condition |
| Learning | `Learning.selects_right_through` | `DecidableEq K` | exchanging two values | its own condition |
| Learning | `Learning.selects_through_lumping` | `DecidableEq K` | exchanging two values | its own condition |
| Learning | `Learning.swapTo_moves` | `DecidableEq O` | another value | its own condition |
| Learning | `Learning.values_lumped` | `DecidableEq K` | exchanging two values | its own condition |
| Learning | `Learning.values_not_right_of_parted` | `DecidableEq K` | exchanging two values | its own condition |
| Learning | `Learning.values_right_lumped` | `DecidableEq K` | exchanging two values | its own condition |
| Learning | `Learning.values_right_of_reads` | `DecidableEq K` | exchanging two values | its own condition |
| Listing | `Flow.BalancesOn.sample_byOccurrence` | `DecidableEq F` | coarser reading | its own condition |
| Listing | `Listed.of_listing` | `(t : Nat) → (a b : α) → a ∈ l t → b ∈ l t → Decidable (a = b)` | a list without repetition | its own condition |
| Listing | `keepFresh_spec` | `Decidable (a ∈ l)` | a list without repetition | its own condition |
| Listing | `listOnce_listsOnce` | `(a b : α) → a ∈ l → b ∈ l → Decidable (a = b)` | a list without repetition | its own condition |
| Locality | `ceasing_needs_arising` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Locality | `cohort_closes_iff` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| LossMatching | `Frame.StrictLossMatch.classCount_le` | `DecidableEq K` | counts | its own condition |
| LossMatching | `Frame.distinct_lostOf` | `(c : C) → Decidable (F.realized s c)` | a kept list | its own condition |
| LossMatching | `Frame.lossesListed_lostOf` | `(c : C) → Decidable (F.realized s c)` | a kept list | its own condition |
| LossMatching | `Frame.matching_of_counts` | `DecidableEq C`；`DecidableEq K` | counts | its own condition |
| LossMatching | `Frame.mem_lostOf` | `(c : C) → Decidable (F.realized s c)` | a kept list | its own condition |
| LossMatching | `Frame.strictLossMatch_iff_counts` | `DecidableEq C`；`DecidableEq K` | counts | its own condition |
| LossMatching | `Frame.strictLossMatch_of_counts` | `DecidableEq C`；`DecidableEq K` | counts | its own condition |
| Onward | `Onward.decidedTest_finds` | `(s : S) → (a : A) → (t : S) → Decidable (P.step s a t)`；`(s : S) → Decidable (K s)` | builds an indicator | its own condition |
| Order | `Flow.sample_idle_balancesOn` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_closedAt` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_dissipatesOn` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_enclosed` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_give` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_not_descends` | `DecidableEq X` | coarser reading | its own condition |
| Order | `Flow.sample_idle_present` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_runsDownOn` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_take` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_idle_takers` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_acting_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_balancesOn_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_closedAt_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_descends_iff` | `DecidableEq X` | coarser reading | its own condition |
| Order | `Flow.sample_moves_dissipatesOn_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_give` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_given` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_mem` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_runsDownOn_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_take` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_taken` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_moves_taking_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.sample_not_more` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.stutter_acting_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.stutter_balances_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.stutter_dissipative_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.stutter_given` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.stutter_taken` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.stutter_taking_iff` | `DecidableEq F` | coarser reading | its own condition |
| Order | `Flow.stutter_transmitsWithin_iff` | `DecidableEq X` | coarser reading | its own condition |
| Order | `Reorders.counts` | `(n : Nat) → (x : X) → Decidable (W'.active n x)`；`(n : Nat) → (x : X) → Decidable (W.active n x)` | counts | its own condition |
| Order | `World.commute_counts` | `(n : Nat) → (x : (w.commute t side).Relatum) → Decidable ((w.commute t side).web.active n x)`；`(n : Nat) → (x : w.Relatum) → Decidable (w.web.active n x)` | counts | its own condition |
| Order | `World.stutter_arisingRecurs_iff` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Order | `World.stutter_ceasingRecurs_iff` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Order | `World.stutter_change_recurs_iff` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Order | `World.stutter_counted` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Order | `World.stutter_counted_of_section` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Order | `World.stutter_premises_iff` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Order | `World.withoutIdle_counts` | `(n : Nat) → (x : v.Relatum) → Decidable (v.web.active n x)` | counts | its own condition |
| Order | `ceasings_moved` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (p' a n)` | counts | its own condition |
| Order | `ceasings_of_iff` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (q a n)` | counts | its own condition |
| Order | `comings_moved` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (p' a n)` | counts | its own condition |
| Order | `comings_of_iff` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (q a n)` | counts | its own condition |
| Order | `stutter_ceasings` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Order | `stutter_comings` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| OrderNormal | `Footprinted.inList_iff` | `DecidableEq X` | list membership | its own condition |
| Parting | `Parting.candidates_run` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | reached | its own condition |
| Parting | `Parting.firstLive_found` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | reached | its own condition |
| Parting | `Parting.firstLive_spec` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | reached | its own condition |
| Parting | `Parting.late_right` | `DecidableEq R` | first fitting member | its own condition |
| Parting | `Parting.leastBound_right` | `DecidableEq R` | first fitting member | its own condition |
| Parting | `Parting.live_iff_continues` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | reached | its own condition |
| Parting | `Parting.live_of_run` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | reached | its own condition |
| Parting | `Parting.live_persists` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | reached | its own condition |
| Parting | `Parting.live_succ_iff` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | reached | its own condition |
| Parting | `Parting.run_in_candidates` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | reached | its own condition |
| Parting | `Parting.world_right` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | reached | its own condition |
| Parting | `Parting.world_right_iff` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | reached | its own condition |
| Persistence | `Reidentify.exchangeAfter_across` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `Reidentify.exchangeAfter_at` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `Reidentify.exchangeAfter_elsewhere` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `Reidentify.exchangeAfter_next` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `World.exchangeAfter_balanced` | `DecidableEq w.Relatum` | exchanging two values | its own condition |
| Persistence | `transpose_alike` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `transpose_left` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `transpose_other` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `transpose_right` | `DecidableEq X` | exchanging two values | its own condition |
| Persistence | `transpose_transpose` | `DecidableEq X` | exchanging two values | its own condition |
| Population | `Listed.across` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | no premise） |
| Population | `Listed.across_at` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | no premise） |
| Population | `Listed.ceasing_iff_shortfall` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.ceasing_iff_shortfall_from` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.ceasing_of_outpacing` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.ceasings_within` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.coming_iff_excess` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.coming_iff_excess_from` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.comings_within` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.keeps` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.keeps_at` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Listed.over_stretch` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | no premise） |
| Population | `Listed.over_stretch_on` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | no premise） |
| Population | `Listed.tally` | `(a : α) → (t : Nat) → Decidable (p a t)` | counts | its own condition |
| Population | `Web.Census.over_stretch` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | counts | its own condition |
| Population | `Web.Census.over_stretch_on` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | counts | its own condition |
| Population | `Web.DependenceCensus.over_stretch` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | counts | its own condition |
| Population | `Web.DependenceCensus.over_stretch_on` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | counts | its own condition |
| Population | `mark_add_not` | `Decidable q`；`Decidable r` | counts | its own condition |
| Population | `mark_le_total` | `(a : α) → Decidable (q a)`；`Decidable P` | counts | its own condition |
| Population | `mark_one` | `Decidable p` | counts | its own condition |
| Population | `mark_turn` | `Decidable p`；`Decidable q` | counts | its own condition |
| Population | `mark_zero` | `Decidable p` | counts | its own condition |
| Population | `marks_le_of_sub` | `(a : α) → Decidable (q a)`；`(a : α) → Decidable (r a)` | counts | its own condition |
| Population | `total_le_mark` | `(a : α) → Decidable (q a)`；`Decidable P` | counts | its own condition |
| Premises | `World.keep_lists` | `(x : w.Relatum) → Decidable (w.web.active t x)` | a kept list | its own condition |
| Premises | `keep_distinct` | `(a : α) → Decidable (p a)` | a kept list | its own condition |
| Premises | `listed_of_ever` | `(a : α) → (t : Nat) → Decidable (p a t)` | a kept list | its own condition |
| Premises | `mem_keep` | `(a : α) → Decidable (p a)` | a kept list | its own condition |
| Propagation | `ExchangeLaw.exchangeGap_le_mixCells` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Propagation | `mixCells_either` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Propagation | `mixCells_listed` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Reading | `Flow.adopt_census` | `(t : Nat) → (f : Option F) → Decidable ((L.withImbalance W).Exchanging t f)` | a kept list | its own condition |
| Reading | `Flow.readOff_census` | `(t : Nat) → (f : F) → Decidable (L.Exchanging t f)` | a kept list | its own condition |
| Readout | `Readout.firstJudge_judges` | `DecidableEq K` | first fitting member | its own condition |
| Readout | `Readout.pick_of` | `Decidable p` | builds an indicator | its own condition |
| Readout | `Readout.pick_of_not` | `Decidable p` | builds an indicator | its own condition |
| Regrouping | `Web.admits_iff_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | builds an indicator | its own condition |
| Regrouping | `Web.admits_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | builds an indicator | its own condition |
| Regrouping | `Web.regroup_faithful_iff_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | builds an indicator | its own condition |
| Regrouping | `Web.same_admission_iff_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | builds an indicator | its own condition |
| RegroupingSelection | `Web.group_keeps_selections_iff_faithful` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | builds an indicator | its own condition |
| RegroupingSelection | `Web.merged_requirement_loses_selection` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | builds an indicator | its own condition |
| Reserve | `Web.Carries.lasts` | `(t : Nat) → Decidable (W.active t f)` | counts | its own condition |
| Reserve | `Web.Carries.lasts_within` | `(t : Nat) → Decidable (W.active t f)` | counts | its own condition |
| Reserve | `Web.Carries.step` | `Decidable (W.active t f)` | counts | its own condition |
| Reserve | `Web.CarriesAcross.step` | `Decidable (W.active t f)` | counts | its own condition |
| Reserve | `Web.lasts_on` | `(t : Nat) → Decidable (W.active t f)` | counts | its own condition |
| Reserve | `Web.redirect_dependent` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` | dependence moved | its own condition |
| Reserve | `Web.redirect_same` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` | dependence moved | its own condition |
| Reserve | `Web.redirect_supported_at` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` | dependence moved | its own condition |
| Resolution | `Web.CarriesAt.lasts` | `(t : Nat) → Decidable (W.active t f)` | counts | its own condition |
| Resolution | `Web.CarriesIn.lasts_unrefined` | `(t : Nat) → Decidable (W.active t f)` | counts | its own condition |
| Retrodiction | `Retrodiction.bracket` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.bracket_settles_iff` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.change_unlocated` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.changes_const` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.changes_le` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.changes_split` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.excursion_changes` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.moved_changes` | `DecidableEq R` | tells same from different | its own condition |
| Retrodiction | `Retrodiction.step_changes` | `DecidableEq R` | tells same from different | its own condition |
| Runaway | `Flow.BalancesOn.raise` | `DecidableEq C` | one condition raised | its own condition |
| Runaway | `Web.Dependent.raise` | `DecidableEq C` | one condition raised | its own condition |
| Runaway | `Web.Supported.raise` | `DecidableEq C` | one condition raised | its own condition |
| Runaway | `Web.break_not_bounded` | `DecidableEq C` | one condition raised | its own condition |
| Runaway | `Web.le_raise` | `DecidableEq C` | one condition raised | its own condition |
| Runaway | `Web.observed_raise_registers` | `DecidableEq C` | one condition raised | its own condition |
| Runaway | `Web.raise_other` | `DecidableEq C` | one condition raised | its own condition |
| Runaway | `Web.registersAlike_raise` | `DecidableEq C` | one condition raised | its own condition |
| Sampling | `Flow.BalancesOn.sample` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.DissipatesOn.sample` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.RunsDownOn.sample` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.RunsDownOn.sample_of_fine` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.gateBy_dissipates` | `Decidable p` | coarser reading | its own condition |
| Sampling | `Flow.pos_of_gated` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_acting` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_acting_on` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_balances` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_closed` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_closedAt_iff` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_dissipative` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_give_total` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_given` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_given_on` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_once` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_take_total` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_taken` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_taken_on` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_taking` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.sample_taking_on` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `Flow.unionPresent_spec` | `DecidableEq F` | coarser reading | its own condition |
| Sampling | `World.sample_acting` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_arisingRecurs` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)`；`DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_balanced` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_ceasingRecurs` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)`；`DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_counted` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_dependent` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_dissipative` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_embodied` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_finite` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_rests_unrefuted` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_survives` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `World.sample_taking` | `DecidableEq w.Relatum` | coarser reading | its own condition |
| Sampling | `gateBy_of` | `Decidable p` | coarser reading | its own condition |
| Sampling | `gateBy_of_not` | `Decidable p` | coarser reading | its own condition |
| Sampling | `gateBy_zero` | `Decidable p` | coarser reading | its own condition |
| Sampling | `gate_mem` | `DecidableEq α` | coarser reading | its own condition |
| Sampling | `mem_adjoin` | `DecidableEq α` | a list without repetition | its own condition |
| Sampling | `mem_insertNew` | `Decidable (a ∈ l)` | a list without repetition | its own condition |
| Sampling | `mem_of_gateBy_pos` | `Decidable p` | coarser reading | its own condition |
| Sampling | `mem_of_gate_pos` | `DecidableEq α` | coarser reading | its own condition |
| Sampling | `total_gate` | `DecidableEq α` | coarser reading | its own condition |
| Sampling | `total_gateBy` | `Decidable p` | coarser reading | its own condition |
| Segmentation | `Segmentation.bond_unique` | `DecidableEq α` | tells same from different | its own condition |
| Segmentation | `Segmentation.no_record_groups` | `DecidableEq α` | tells same from different | its own condition |
| Segmentation | `Segmentation.transitions_le` | `DecidableEq α` | tells same from different | its own condition |
| Selection | `Relabel.Equivariant.none_of_full_tie` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.Equivariant.tied` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.Equivariant.untied` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.EquivariantChoice.selects` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.EquivariantChoice.untied` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.EquivariantChoice.withholds_of_full_tie` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.EquivariantValue.const` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.EquivariantValue.full_tie` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.EquivariantValue.level` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.EquivariantValue.tied` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.alone_equivariant` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.entry_equivariant` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.fixed_of_tied` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.map_swap_eq_some` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.selected_alike_iff` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.singled_iff_untied` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.swap_inj` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.swap_left` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.swap_other` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.swap_right` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.swap_swap` | `DecidableEq K` | exchanging two values | its own condition |
| Selection | `Relabel.valued_alike_iff` | `DecidableEq K` | exchanging two values | its own condition |
| Sensitivity | `mixIn_alike_of_insensitiveAt` | `DecidableEq C` | mixed in condition by condition | its own condition |
| Sensitivity | `tailLaw_differs` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_insensitive` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_no_least_registration` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_nonanticipating` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_not_readsFinitely` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_not_sensitive` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_not_through` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_not_through_sensitive` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_reads_from` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `tailLaw_through_from` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `vanishIndicator_eq_of_agree` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `vanishIndicator_eq_one` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `vanishIndicator_eq_zero` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `vanishIndicator_ones` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Sensitivity | `vanishIndicator_zeros` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Situations | `Situations.mul_indicator` | `Decidable c` | splits on a case | its own condition |
| Situations | `Situations.occ_courses` | `DecidableEq A`；`DecidableEq S` | tells same from different | its own condition |
| Situations | `Situations.occ_courses_once` | `DecidableEq A`；`DecidableEq S` | tells same from different | its own condition |
| Situations | `Situations.occ_map_cons` | `DecidableEq α` | tells same from different | its own condition |
| Situations | `Situations.occ_map_pair` | `DecidableEq A`；`DecidableEq S` | tells same from different | its own condition |
| Situations | `Situations.occ_openSteps` | `DecidableEq A`；`DecidableEq S` | tells same from different | its own condition |
| Situations | `Situations.situations_of_course_listed` | `DecidableEq A`；`DecidableEq S` | tells same from different | its own condition |
| Situations | `Situations.situations_take` | `DecidableEq A`；`DecidableEq S` | tells same from different | its own condition |
| Situations | `Situations.sum_only` | `DecidableEq α` | tells same from different | its own condition |
| Standing | `World.Embodied.standingMarksHold_iff` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Standing | `World.Embodied.tally_of_stands` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | counts | its own condition |
| Standing | `ceasings_congr` | `(a : α) → (t : Nat) → Decidable (p a t)`；`(a : α) → (t : Nat) → Decidable (q a t)` | counts | its own condition |
| Standing | `comings_congr` | `(a : α) → (t : Nat) → Decidable (p a t)`；`(a : α) → (t : Nat) → Decidable (q a t)` | counts | its own condition |
| Tail | `neverIndicator_add_vanishIndicator` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)`；`(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Tail | `neverIndicator_changedByNoCondition` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverIndicator_eq_of_agree` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverIndicator_eq_one` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverIndicator_eq_zero` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverIndicator_ones` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverIndicator_zeros` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverLaw_differs` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverLaw_insensitive` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverLaw_nonanticipating` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `neverLaw_not_sensitive` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `raisedFrom_false` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` | builds an indicator | its own condition |
| Tail | `raisedFrom_of` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` | builds an indicator | its own condition |
| Tail | `tailLaw_eq_wholeLaw` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Tail | `vanishIndicator_changedByNoCondition` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | builds an indicator | its own condition |
| Tail | `vanishesFrom_never_iff` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `vanishesFrom_of` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tail | `vanishesFrom_true` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | builds an indicator | its own condition |
| Tower | `Tower.balances_coarser` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.changes_within` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.dissipative_coarser` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.flow_sample` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.level_zero` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.reads_strict` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.strict` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.web_sample` | `DecidableEq F` | coarser reading | its own condition |
| Tower | `Tower.web_zero` | `DecidableEq F` | coarser reading | its own condition |
| Viability | `Viability.agrees_of_within` | `DecidablePred guard` | a guarded step | its own condition |
| Viability | `Viability.guardedStep_none` | `DecidablePred guard` | a guarded step | its own condition |
| Viability | `Viability.guarded_iff` | `DecidablePred guard` | a guarded step | its own condition |
| Viability | `Viability.guarded_never_fails_iff` | `DecidablePred guard` | a guarded step | its own condition |
| Viability | `Viability.ready_of_step` | `DecidablePred guard` | a guarded step | its own condition |
| Viability | `Viability.step_of_ready` | `DecidablePred guard` | a guarded step | its own condition |
| Weighted | `mass_dirac_pos` | `DecidableEq Ω` | tells same from different | its own condition |
| Weighted | `mem_of_mass_dirac_pos` | `DecidableEq Ω` | tells same from different | its own condition |

<a id="只在证明中用到可判定性的定理--theorems-using-decidability-only-in-proofs"></a>
## Theorems using decidability only in proofs

| Module | Theorem | Decidability | Reason | Other form |
|---|---|---|---|---|
| Attraction | `Law.lossless_iff_none_drawn` | `DecidableEq S` | tells same from different | no decision, P67） |
| Attraction | `Law.none_drawn_lossless` | `DecidableEq S` | tells same from different | no decision, P67） |
| Change | `Web.arising_recurs_iff` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | as for `coming_recurs_iff` |
| Change | `Web.unceasing_iff` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | decided from some step on） |
| Change | `Web.unceasing_iff_covering` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Change | `coming_recurs_iff` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | `Recurs.ceasing_not_stopping`、`Recurs.coming_not_stopping`（无前提 / no premise）；`coming_recurs_iff_decided`（从某步起已定 / decided from some step on） |
| Change | `persists` | `(t : Nat) → Decidable (p t)` | splits on a case | `stays_failing`（不成立的持续，不判定 / failing persists, no decision）；`persists_of_em` 示其需要 / shows the need |
| Contacts | `Contacts.added_gains` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.answers_iff` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.blind_misses` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.keeps_data_iff` | `DecidableEq I`；`∀ (i : I), D t i ∨ ¬D t i` | tells same from different | — |
| Contacts | `Contacts.keeps_iff_retains` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.mem_or_not` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.retired_loses` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.selections_survive_iff` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.survive_data_iff` | `DecidableEq I`；`∀ (i : I), D t i ∨ ¬D t i` | tells same from different | — |
| Contacts | `Contacts.through_at_iff` | `DecidableEq I` | tells same from different | — |
| Contacts | `Contacts.through_data_iff` | `DecidableEq I`；`∀ (i : I), D i ∨ ¬D i` | tells same from different | — |
| Contacts | `Contacts.trace_keeps_of_retains` | `DecidableEq I` | tells same from different | — |
| Continuation | `Flow.fed_from_beyond` | `DecidableEq C` | tells same from different | — |
| Continuation | `Flow.fed_from_beyond_from` | `DecidableEq C` | tells same from different | — |
| Continuation | `Flow.fed_of_not_inward` | `DecidableEq C` | tells same from different | — |
| Continuation | `Flow.inward_iff_not_fed` | `DecidableEq C` | tells same from different | — |
| Continuation | `Flow.inward_of_not_fed` | `DecidableEq C` | tells same from different | — |
| Continuation | `Flow.rising_fed_from_beyond` | `DecidableEq C` | tells same from different | — |
| Continuation | `Flow.rising_fed_from_beyond_from` | `DecidableEq C` | tells same from different | — |
| Continuation | `Web.embodiedArising_fed_from_beyond` | `DecidableEq X` | tells same from different | — |
| Counterfactual | `ExchangeLaw.Nonanticipating.through_of_observed` | `DecidableEq C` | tells same from different | `ExchangeLaw.Nonanticipating.through_all`（不判定 / no decision, P80）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Counterfactual | `ExchangeLaw.Nonanticipating.through_sensitive` | `DecidableEq C` | tells same from different | `ExchangeLaw.Nonanticipating.through_all`（不判定 / no decision, P80）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Counterfactual | `alike_of_sensitive_agree` | `DecidableEq C` | tells same from different | through registering everything, no decision, P80） |
| Counterfactual | `comparison_through_sensitivity` | `DecidableEq C` | tells same from different | through a registration the law reads through, no decision, P80） |
| Coupling | `lumped_upto_iff` | `DecidableEq K` | tells same from different | — |
| Coupling | `no_policy_upto_iff` | `DecidableEq A`；`DecidableEq K` | finds | — |
| Coupling | `throughout_or_fails` | `(n : Nat) → Decidable (p n)` | finds | — |
| CourseWorlds | `TwoActs.gap_le_carried` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `TwoActs.gap_le_carried_read` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `TwoActs.gap_le_count` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `TwoActs.gap_le_polynomial` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `TwoActs.gap_le_polynomial_before` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `TwoActs.gap_le_polynomial_from` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `carrying_twoActs` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `gap_polynomial_iff_no_loop_worlds` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `gap_within_order_iff_worlds` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `most_difference_courses_worlds` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `most_difference_within_worlds` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `most_difference_worlds` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `runaway_worlds` | `DecidableEq C` | tells same from different | — |
| CourseWorlds | `worlds_iff_flows` | `DecidableEq C` | tells same from different | — |
| Courses | `Courses.claims_every_weighting_iff` | `DecidableEq S` | builds an indicator | — |
| Courses | `Courses.course_reaches_iff_variant` | `DecidablePred target` | builds an indicator | — |
| Courses | `Courses.course_resolves_every_iff` | `DecidableEq M` | tells same from different | — |
| Courses | `Courses.extension_frontier_exists` | `∀ (a b : S), a ∈ x :: rest → b ∈ x :: rest → Becoming.WeaklyDecided (Becoming.Extension F living b a)` | finds | — |
| Courses | `Courses.extension_frontier_has_iff` | `∀ (a : S), a ∈ menu → Becoming.Decided (task a)`；`∀ (a b : S), a ∈ menu → b ∈ menu → Becoming.Decided (Becoming.Extension F living b a)` | finds | — |
| Courses | `Courses.run_judges_iff` | `DecidableEq K` | finds | — |
| Courses | `Courses.run_resolves_explained_iff` | `DecidableEq M` | tells same from different | — |
| Courses | `Courses.run_resolves_iff` | `DecidableEq M` | tells same from different | — |
| Courses | `Courses.runs_look_right_iff` | `DecidableEq O`；`DecidableEq V` | tells same from different | — |
| Courses | `Courses.runs_reading_right_iff` | `DecidableEq O`；`DecidableEq V` | tells same from different | — |
| CrossSituational | `CrossSituational.candidates_eq_iff` | `DecidableEq M` | tells same from different | — |
| CrossSituational | `CrossSituational.reads_every_iff` | `DecidableEq M` | tells same from different | — |
| CrossSituational | `CrossSituational.resolves_explained_iff` | `DecidableEq M` | tells same from different | — |
| CrossSituational | `CrossSituational.resolves_iff` | `DecidableEq M` | tells same from different | — |
| Decidedness | `Counts.over_stretch_decided` | `∀ (a : α), a ∈ as → ∀ (t : Nat), t ∈ Becoming.steps S (n + 1) → Becoming.Decided (p a t)` | splits on a case | — |
| Decidedness | `Decided.and` | `Becoming.Decided p`；`Becoming.Decided q` | splits on a case | — |
| Decidedness | `Decided.exists_below` | `∀ (t : Nat), M ≤ t → t < U → Becoming.Decided (P t)` | splits on a case | — |
| Decidedness | `Decided.exists_mem` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | splits on a case | — |
| Decidedness | `Decided.not` | `Becoming.Decided p` | splits on a case | — |
| Decidedness | `Decided.of_not_not` | `Becoming.Decided p` | splits on a case | — |
| Decidedness | `Decided.weakly` | `Becoming.Decided p` | splits on a case | — |
| Decidedness | `World.arising_iff_ceasing_of_decidable` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | — |
| Decidedness | `bettered_of_undominated_has` | `∀ (a b : β), a ∈ menu → b ∈ menu → Becoming.Decided (better a b)` | finds | — |
| Decidedness | `exists_undominated` | `∀ (a b : β), a ∈ x :: rest → b ∈ x :: rest → Becoming.WeaklyDecided (better a b)` | finds | — |
| Decidedness | `undominated_has` | `∀ (a : β), a ∈ menu → Becoming.Decided (P a)` | splits on a case | — |
| Decidedness | `undominated_has_iff` | `∀ (a : β), a ∈ menu → Becoming.Decided (P a)`；`∀ (a b : β), a ∈ menu → b ∈ menu → Becoming.Decided (better a b)` | finds | — |
| Diagonal | `Diagonal.alike_of_complete` | `(x : B) → Decidable (x = b)` | tells same from different | — |
| Diagonal | `Diagonal.complete_iff_alike` | `DecidableEq B` | tells same from different | — |
| Dissipation | `Flow.Enclosed.around` | `DecidableEq C` | builds a list | no decision） |
| Distinguishing | `Law.labelled_finite` | `DecidableEq A`；`DecidableEq S` | tells same from different | — |
| Feedback | `Flow.Balances.adds_iff_exceeds_of_decidable` | `(t : Nat) → (g : F) → Decidable (sig p t g)` | splits on a case | — |
| Frequency | `gap_le_count` | `DecidableEq C` | tells same from different | — |
| Gated | `Gated.change_located` | `DecidableEq R` | tells same from different | — |
| Gated | `Gated.origin_of_decides` | `∀ (a : A), gate a ∨ ¬gate a` | splits on a case | — |
| Gluing | `ParityConstraint.met_or_contradicts` | `DecidableEq C` | tells same from different | — |
| Gluing | `ParitySystem.global_or_contradicts` | `DecidableEq C` | tells same from different | — |
| Gluing | `ParitySystem.glues_iff` | `DecidableEq C` | tells same from different | — |
| Gluing | `ParitySystem.noGlobal_iff` | `DecidableEq C` | tells same from different | — |
| Granularity | `Frame.byRecipes_translates` | `Becoming.TestsDecided F` | finds | — |
| Granularity | `Frame.holds_byRecipes` | `Becoming.TestsDecided F` | finds | — |
| Granularity | `Recipe.holds_after` | `Becoming.TestsDecided F` | finds | — |
| Granularity | `Recipe.outcomes` | `Becoming.TestsDecided F` | builds a list | — |
| Identification | `Identification.bounded_induction` | `DecidableEq O` | tells same from different | — |
| Identification | `Identification.fits_of_unrefuted` | `DecidableEq O` | tells same from different | — |
| Identification | `Identification.sameAhead_iff_classes` | `∀ (n m : Nat), Becoming.Decided (o n = o m)` | tells same from different | `Identification.sameAhead_iff_within`（N − 1，无前提，判定位置 / no premise, positions decided）；`Identification.sameAhead_iff_below`（2N − 1，无前提 / no premise） |
| Identification | `Identification.unrefuted_persists` | `DecidableEq O` | tells same from different | — |
| Identification | `Law.AgreeTo.decided` | `∀ (s s' : S), s ∈ l → s' ∈ l → Becoming.Decided (o s = o s')` | splits on a case | — |
| Identification | `Law.sameFuture_iff_classes` | `∀ (s s' : S), s ∈ l → s' ∈ l → Becoming.Decided (o s = o s')` | tells same from different | `Law.sameFuture_iff_within`（N − 1，无前提，判定位置 / no premise, positions decided）；`Law.sameFuture_classes_unrefuted`（不判定，不被否证 / no decision, refuted by nothing）；`Law.sameFuture_iff_below`（2N − 1，无前提 / no premise） |
| Identity | `Flow.More.unceasingFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)` | finds | — |
| Identity | `Flow.More.unceasing_reidentified` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Identity | `Flow.More.unceasing_reidentified_covering` | `(s : Nat) → (f : F) → S ≤ s → Decidable (W.active s f)` | finds | — |
| Identity | `Web.Census.arisingFrom_of_ceasingFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | finds | — |
| Identity | `Web.Census.arisingFrom_of_ceasingFrom_from` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | finds | — |
| Identity | `Web.Census.ceasingFrom_of_arisingFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | finds | — |
| Identity | `Web.Census.ceasingFrom_of_arisingFrom_from` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | finds | — |
| Identity | `Web.arisesFrom_of_more` | `(f : F) → Decidable (W.Continues R t f)` | finds | — |
| Identity | `Web.unceasingFrom_of_growth` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)` | finds | — |
| Identity | `forces_iff_noSplit` | `DecidableEq F` | tells same from different | — |
| Lasting | `Lasting.TwoChains.branching` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | builds a list | — |
| Lasting | `Lasting.list_throughout_not_not` | `∀ (k : Nat) (b : β), Becoming.Decided (Q k b)` | splits on a case | — |
| Lasting | `Lasting.orbit_reaches_iff_variant` | `DecidablePred target` | builds an indicator | — |
| Lasting | `Lasting.reaches_iff_histories` | `DecidablePred target` | finds | — |
| Lasting | `Lasting.reaches_iff_not_lasts` | `DecidablePred target` | finds | — |
| Lasting | `Lasting.reaches_of_histories` | `DecidablePred target` | finds | — |
| Lasting | `Lasting.reaches_of_not_lasts` | `DecidablePred target` | finds | — |
| Learnable | `Learnable.learnable_iff` | `DecidableEq R` | finds | the necessary side, of every learner, no decision） |
| Learnable | `Learnable.learnable_of_lumped` | `DecidableEq R` | finds | — |
| Learnable | `Learnable.refuted_on_one` | `DecidableEq V` | tells same from different | no premise: the claim is not right on both） |
| Learnable | `Learnable.still_learnable_iff_lumped` | `DecidableEq R` | finds | the necessary side, no decision） |
| LearnableRuns | `LearnableRuns.learnable_iff` | `DecidableEq R` | finds | — |
| LearnableRuns | `LearnableRuns.still_learnable_iff_lumped` | `DecidableEq R` | finds | — |
| Learning | `Learning.claim_refuted_on_one` | `DecidableEq O` | tells same from different | no premise: the claim is not right on both, P73） |
| Learning | `Learning.determines_lumped_iff` | `DecidableEq K` | finds | one direction, no premise, P73） |
| Learning | `Learning.eq_of_not_refuted` | `DecidableEq O` | tells same from different | — |
| Learning | `Learning.every_determines_nothing` | `DecidableEq I` | tells same from different | — |
| Learning | `Learning.every_free` | `DecidableEq I` | tells same from different | — |
| Likeness | `BranchingTest.apart_from_listed` | `∀ (y : S'), Becoming.Decided (q y)` | finds | — |
| Likeness | `Chains.outcomes` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | builds a list | — |
| Likeness | `Chains.outcomesListed` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | builds a list | — |
| Likeness | `Decided.exists_listed` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | splits on a case | — |
| Likeness | `Decided.exists_not_in` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | finds | — |
| Likeness | `Decided.exists_not_of_listed` | `∀ (b : β), Becoming.Decided (P b)` | finds | — |
| Likeness | `Decided.exists_of_listed` | `∀ (b : β), Becoming.Decided (P b)` | splits on a case | — |
| Likeness | `Decided.forall_in` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | splits on a case | — |
| Likeness | `Decided.forall_of_listed` | `∀ (b : β), Becoming.Decided (P b)` | splits on a case | — |
| Likeness | `Decided.iff` | `Becoming.Decided p`；`Becoming.Decided q` | splits on a case | — |
| Likeness | `Decided.imp` | `Becoming.Decided p`；`Becoming.Decided q` | splits on a case | — |
| Likeness | `EitherThroughout.list` | `∀ (k : Nat) (b : β), Becoming.Decided (P k b)` | finds | — |
| Likeness | `LLPO.FirstAt.decided` | `∀ (k : Nat), Becoming.Decided (α k)` | splits on a case | — |
| Likeness | `LLPO.FirstAt.of_holds` | `∀ (k : Nat), Becoming.Decided (α k)` | finds | — |
| Likeness | `LLPO.Interleave.decided` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | splits on a case | — |
| Likeness | `LLPO.decidable` | `(n : Nat) → Decidable (γ n)` | builds an indicator | — |
| Likeness | `OutcomesListed.forth_decided` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | splits on a case | — |
| Likeness | `OutcomesListed.matched_decided` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | splits on a case | — |
| Likeness | `OutcomesListed.unmatched` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | finds | — |
| Likeness | `drops_somewhere` | `∀ (k : Nat), Becoming.Decided (P k x)` | finds | — |
| Likeness | `forth_decided` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | splits on a case | — |
| Likeness | `stops_decreasing` | `∀ (k : Nat) (x : X), Becoming.Decided (P k x)` | finds | — |
| Likeness | `unmatched_of_not_forth` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | finds | — |
| Listing | `Flow.standing_lowers_decided` | `Becoming.IdentityDecided ds` | builds a list | — |
| Listing | `Web.arising_of_ceasing_listing` | `(t : Nat) → (a b : F) → a ∈ l t → b ∈ l t → Decidable (a = b)`；`(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | a supplied census; here `listOnce` also constructs it, P77） |
| Listing | `listsOnceBy_of_decided` | `∀ (a b : α), a ∈ l → b ∈ l → Becoming.Decided (R a b)` | builds a list | — |
| Listing | `listsOnce_of_decided` | `Becoming.IdentityDecided l` | builds a list | — |
| Listing | `of_listsOnce` | `Becoming.IdentityDecided l` | builds a list | — |
| Locality | `Covers.coming_from_of_ceasing` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | no premise, P48） |
| Locality | `Covers.within` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | — |
| Locality | `coming_of_ceasing_covered` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | no premise, P48） |
| Loops | `gap_le_polynomial` | `DecidableEq C` | tells same from different | — |
| Loops | `gap_polynomial_iff_no_loop` | `DecidableEq C` | tells same from different | — |
| Loops | `most_difference_within` | `DecidableEq C` | tells same from different | — |
| LossMatching | `Frame.exists_fresh` | `DecidableEq C` | finds | — |
| LossMatching | `Frame.strictLossMatch_iff_length_of_alike` | `DecidableEq C` | tells same from different | — |
| Novelty | `upto_or_fails` | `(n : Nat) → Decidable (p n)` | finds | — |
| Openness | `Flow.Enclosed.aroundStanding` | `DecidableEq C` | builds a list | no decision） |
| Openness | `Listed.few_of_quiet` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | no decision, P58） |
| Openness | `World.CountedBy.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | — |
| Openness | `World.CountedWithin.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | — |
| Openness | `World.Finite.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | — |
| Openness | `World.Finite.countedWithin` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | builds a list | — |
| Openness | `World.arising_of_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | — |
| Openness | `World.few_active` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | no decision, P58） |
| Openness | `comes_after` | `(t : Nat) → Decidable (p t)` | finds | no decision, the step unrefuted） |
| OrderNormal | `Footprinted.decidesIdle_iff` | `DecidableEq X` | tells same from different | — |
| OrderNormal | `Footprinted.least_exists_iff` | `DecidableEq X` | tells same from different | — |
| ParityReadings | `ParitySystem.freeFrame_iff` | `DecidableEq C` | tells same from different | — |
| ParityReadings | `ParitySystem.world_free_iff` | `DecidableEq C` | tells same from different | — |
| Parting | `Parting.free_open` | `DecidableEq V` | tells same from different | no premise: not right on both runs, P116） |
| Parting | `Parting.late_statesBelow` | `DecidableEq R` | tells same from different | — |
| Parting | `Parting.some_right_iff` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | reached | — |
| Parting | `Parting.unparted_at_of_late` | `DecidableEq R` | tells same from different | — |
| Parting | `Parting.unparted_iff` | `DecidableEq R` | tells same from different | the forward direction and the parting law, no decision, P116） |
| Persistence | `Web.persisting_census` | `(t : Nat) → (f : F) → Decidable ((W.persisting h).Continues R t f)`；`(t : Nat) → (f : F) → Decidable ((W.persisting h).active t f)`；`(t : Nat) → (g : F) → Decidable ((W.persisting h).Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | finds | — |
| Persistence | `World.arises_fixed_iff` | `DecidableEq w.Relatum` | tells same from different | — |
| Persistence | `World.ceases_fixed_iff` | `DecidableEq w.Relatum` | tells same from different | — |
| Persistence | `World.fixed_iff` | `DecidableEq w.Relatum` | tells same from different | — |
| Population | `Flow.More.unceasing` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Population | `Flow.More.unceasing_covering` | `(s : Nat) → (f : F) → S ≤ s → Decidable (W.active s f)` | finds | — |
| Population | `Listed.ceasing_of_coming` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | — |
| Population | `Listed.ceasing_of_returning` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | — |
| Population | `Listed.coming_iff_ceasing` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | — |
| Population | `Listed.coming_of_ceasing` | `(a : α) → (t : Nat) → Decidable (p a t)` | finds | — |
| Population | `Web.DependenceCensus.forming_iff_dissolving` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | finds | — |
| Population | `Web.DependenceCensus.forming_of_dissolving` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | finds | — |
| Population | `Web.arises_of_more` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Population | `Web.arising_of_ceasing` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Population | `Web.ceasing_of_arising` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Population | `Web.unceasing_iff_bounded` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Population | `Web.unceasing_of_growth` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | finds | — |
| Population | `came_between` | `(t : Nat) → Decidable (q t)` | finds | — |
| Population | `came_between_from` | `(s : Nat) → S ≤ s → Decidable (q s)` | finds | — |
| Population | `search` | `(a : α) → Decidable (p a)` | finds | — |
| Premises | `World.Finite.counted` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | builds a list | — |
| Premises | `World.counted_of_ever` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | builds a list | — |
| Propagation | `ExchangeLaw.carrying_respondsWithin` | `DecidableEq C` | tells same from different | — |
| Propagation | `ExchangeLaw.exchangeGap_le_shares` | `DecidableEq C` | tells same from different | — |
| Propagation | `ExchangeLaw.exchangeGap_le_strengths` | `DecidableEq C` | tells same from different | — |
| Propagation | `ExchangeLaw.exchangeGap_le_strengths_listed` | `DecidableEq C` | tells same from different | — |
| Propagation | `ExchangeLaw.insensitiveAt_iff_strength_zero` | `DecidableEq C` | tells same from different | — |
| Propagation | `ExchangeLaw.sensitive_iff_strength` | `DecidableEq C` | tells same from different | — |
| Propagation | `gap_le_carried` | `DecidableEq C` | tells same from different | — |
| Propagation | `levels_alike_of_not_conveyed` | `DecidableEq C` | tells same from different | — |
| Propagation | `most_difference_arrives` | `DecidableEq C` | tells same from different | — |
| Readout | `Readout.commonWitness_or_covered` | `DecidableEq D` | finds | — |
| Readout | `Readout.judges_iff_lumpedOn` | `DecidableEq K` | finds | — |
| Readout | `Readout.no_common_report_envelopes_iff` | `DecidableEq D` | finds | — |
| Readout | `Readout.no_common_report_iff` | `DecidableEq D` | finds | — |
| Refinement | `Decided.exists_within` | `∀ (x : X), x ∈ l → Becoming.Decided (P x)` | splits on a case | — |
| Refinement | `Refining.grow` | `∀ (k : Nat) (x y : X), x ∈ l → y ∈ l → Becoming.Decided (R k x y)` | splits on a case | — |
| Refinement | `Refining.steady_or_grown` | `∀ (k : Nat) (x y : X), x ∈ l → y ∈ l → Becoming.Decided (R k x y)` | finds | — |
| Refinement | `Refining.steady_within` | `∀ (k : Nat) (x y : X), x ∈ l → y ∈ l → Becoming.Decided (R k x y)` | finds | — |
| Remainder | `gap_within_order_iff` | `DecidableEq C` | tells same from different | — |
| Response | `Flow.Balances.comparison_within_response_of_decidable` | `(g : F) → Decidable (L.WithinResponse L' W obs part g)` | tells same from different | covering what is not refuted to be within the reach, no decision, P65） |
| Retrodiction | `Retrodiction.fits_or_separated` | `DecidableEq O` | tells same from different | — |
| Retrodiction | `Retrodiction.look_right_iff` | `DecidableEq O`；`DecidableEq V` | tells same from different | — |
| Retrodiction | `Retrodiction.reading_right_iff` | `DecidableEq O`；`DecidableEq V` | tells same from different | — |
| Runaway | `Flow.exchangeFollows_of_policy` | `DecidableEq F` | tells same from different | — |
| Runaway | `Flow.policy_keeps_difference` | `DecidableEq C`；`DecidableEq F` | tells same from different | — |
| Runaway | `Flow.policy_uses_after_failure` | `DecidableEq F` | tells same from different | — |
| Sampling | `Flow.sample_ceasesToStand_iff` | `DecidableEq F` | builds a list | — |
| Sampling | `Flow.sample_changes_iff` | `DecidableEq F` | builds a list | — |
| Sampling | `Flow.sample_comesToStand_iff` | `DecidableEq F` | builds a list | — |
| Sampling | `Web.sample_arises` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | finds | — |
| Sampling | `Web.sample_ceases` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | finds | — |
| Sampling | `Web.sample_ceasing` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | finds | — |
| Sampling | `Web.sample_unceasing` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | finds | — |
| Sampling | `arises_within` | `(n : Nat) → Decidable (p n)` | finds | — |
| Sampling | `ceases_within` | `(n : Nat) → Decidable (p n)` | finds | — |
| Selection | `Relabel.alone_single` | `DecidableEq K` | tells same from different | — |
| Selection | `Web.scores_alike_iff` | `(m : Nat → C → Nat) → Decidable (W.RegistersAlikeUpTo obs g l m t)` | builds an indicator | selections rather than scores, no decision, P64） |
| Sensitivity | `ExchangeLaw.Nonanticipating.through_sensitive_of_every` | `DecidableEq C` | tells same from different | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `ExchangeLaw.ReadsFinitely.alike_of_insensitive` | `DecidableEq C` | tells same from different | — |
| Sensitivity | `ExchangeLaw.ReadsFinitely.least_registration` | `DecidableEq C` | tells same from different | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `ExchangeLaw.ReadsFinitely.through_of_observed` | `DecidableEq C` | tells same from different | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `ExchangeLaw.ReadsFinitely.through_sensitive` | `DecidableEq C` | tells same from different | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `alike_of_insensitiveAt_within` | `DecidableEq C` | tells same from different | — |
| Sensitivity | `alike_of_sensitive_agree_within` | `DecidableEq C` | tells same from different | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `comparison_through_sensitivity_of_readsFinitely` | `DecidableEq C` | tells same from different | through a registration the law reads through, no decision, P113） |
| Sensitivity | `lpo_of_vanish_decided` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | splits on a case | — |
| Space | `World.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | `World.ceasing_not_stopping`、`World.arising_not_stopping`（无前提 / no premise）；`World.arising_iff_ceasing_decided`（从某步起已定 / decided from some step on） |
| Space | `World.arising_iff_ceasing_covering` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | finds | — |
| Standpoints | `Flow.boundary_crossed` | `DecidableEq X` | tells same from different | — |
| Standpoints | `Flow.region_not_a_cut` | `DecidableEq X` | tells same from different | — |
| Standpoints | `Valuation.significant_iff_reached` | `(c : C) → Decidable (∃ p, V.own p c)` | splits on a case | — |
| Substitution | `ceasing_step` | `DecidablePred p` | finds | — |
| Tail | `LPO.of_rule` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` | splits on a case | — |
| Tail | `WLPO.of_rule` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | splits on a case | — |
| Testing | `Flow.subthreshold_alike` | `DecidableEq C` | tells same from different | — |
| Testing | `Flow.subthreshold_alike_always` | `DecidableEq C` | tells same from different | — |
| Testing | `Web.alike_of_threshold` | `DecidableEq C` | tells same from different | — |
| Testing | `Web.tail_unrefuted` | `DecidableEq C` | tells same from different | — |
| TimedResponse | `TimedResponse.different_answers_require_reached` | `Decidable (Becoming.TimedResponse.ReachedBy L L' W obs source g D)` | splits on a case | — |
| Transmission | `Flow.transmitsWithin_iff_split` | `(t : Nat) → (x : X) → Decidable (W.requires t x c)` | splits on a case | — |
| Transmission | `Web.inheritsAt_of_split` | `Decidable (W.requires t x c)` | splits on a case | inheritance is unrefuted without the decision, P84） |
| Unfolding | `Frame.claims_recur_iff` | `(c : C) → (t : Nat) → Decidable (F.realized (r.state t) c)` | finds | — |
| Weighted | `every_weighting_iff` | `DecidableEq Ω` | builds an indicator | — |

<a id="排中律或其受限形式作为假设--excluded-middle-in-full-or-restricted-form-as-a-hypothesis"></a>
## Excluded middle, in full or restricted form, as a hypothesis

These are boundary theorems: they show what excluded middle, or a restricted form of it (such as `NowhereDecided`: whether a decided family holds nowhere is decided), gives, and with `World.law_iff_em`, `World.law_decides`, `World.lpo_of_finite_ends`, `Listed.lpo_of_few`, `Web.lpo_of_ending`, `ChangeBound.lpo_of_ends`, `alike_decided_iff_em`, `alike_of_sameBranchingTests_iff_em`, `alike_of_sameBranchingTests_decided_steps_iff_em`, `alike_of_sameBranchingTests_outcomes_iff`, `matchesParts_of_compact_iff_em`, `jointAlike_of_sameJointTests_iff_em`, `Recipe.holds_after_iff_em`, `exists_undominated_iff_weakly`, `undominated_has_iff_em`, `Gated.origin_of_propositions_iff`, `refutable_passes_iff_markov`, `Lasting.step_iff_either`, that the forms naming a step, asking recurrence of every world, fixing likeness by tests, reading a recipe as one test, finding an undominated choice, locating an origin at a gate, refuting by prefix tests or finding an unbounded successor where branching is finite need decidedness.

- Change: `exists_not_of_em`
- Change: `persists_of_em`
- Composition: `Compact.of_listed`
- Composition: `JointFrame.TestsStable.of_em`
- Composition: `jointAlike_iff_sameJointTests_of_listed`
- Granularity: `Frame.blocks_history_matches_of_em`
- Granularity: `Frame.byRecipes_history_matches_of_em`
- Granularity: `Recipe.Advance.same_of_em`
- Granularity: `Recipe.Leaves.same_of_em`
- Granularity: `Recipe.trace_same_of_em`
- Granularity: `SameBranchingTests.step_of_em`
- Granularity: `SameBranchingTests.trace_of_em`
- Granularity: `TestsDecided.of_em`
- Granularity: `Translates.history_matches_of_em`
- Horizon: `refutable_adheres_of_em`
- Joining: `Joining.FiniteOutcomes.alike_iff_sameBranchingTests`
- Joining: `Joining.FiniteOutcomes.common_structure`
- Joining: `Joining.FiniteOutcomes.identifiesAlike`
- Joining: `Joining.FiniteOutcomes.retained_alike_iff`
- Joining: `Joining.LocallyFinite.alike_iff`
- Joining: `Joining.common_refinement_of_em`
- Joining: `Joining.retained_history_matches_of_em`
- Likeness: `EitherNever.of_nowhereDecided`
- Likeness: `EitherThroughout.of_em`
- Likeness: `EitherThroughout.of_nowhereDecided`
- Likeness: `NowhereDecided.of_em`
- Likeness: `alike_iff_sameBranchingTests_of_em`
- Likeness: `alike_of_sameBranchingTests_of_em`
- Likeness: `apart_of_not_sameBranchingTests`
- Reserve: `Web.Carries.chain_ends_of_em`
- Reserve: `Web.chain_ends_of_em_from`
- Space: `World.law_of_em`
- Space: `quiet_of_once`
- Transmission: `split_of_em`

<a id="计数而可判定被证明--counting-with-decidedness-proved"></a>
## Counting with decidedness proved

These theorems count in their statements without taking decidedness as a hypothesis: it is proved for witness worlds or from embodiment (for example `Embodied.decided`). By module:

- Counting: 35
- Entropy: 5
- Identification: 8
- Learnable: 1
- Learning: 2
- Locality: 1
- LossMatching: 1
- Novelty: 1
- Openness: 2
- Order: 1
- Population: 14
- Reserve: 2
- Resolution: 3
- Runaway: 1
- Sampling: 6
- Standing: 11

<a id="计数的原语--counting-primitives"></a>
## Counting primitives

| Module | Definition | Decidability |
|---|---|---|
| Change | `Web.instDecidableArises` | `(t : Nat) → (f : F) → Decidable (W.active t f)` |
| Change | `Web.instDecidableCeases` | `(t : Nat) → (f : F) → Decidable (W.active t f)` |
| Change | `ceasings` | `(a : α) → (t : Nat) → Decidable (p a t)` |
| Change | `comings` | `(a : α) → (t : Nat) → Decidable (p a t)` |
| Change | `instDecidableCeasesToBe` | `(t : Nat) → Decidable (p t)` |
| Change | `instDecidableComesToBe` | `(t : Nat) → Decidable (p t)` |
| Change | `mark` | `Decidable p` |
| Contacts | `Contacts.spot` | `DecidableEq I` |
| Copying | `Copying.Supplies` | `DecidableEq α` |
| Copying | `Copying.batch` | `DecidableEq α` |
| Copying | `Copying.countOf` | `DecidableEq α` |
| Copying | `Copying.defects` | `DecidableEq α` |
| Copying | `Copying.exchange` | `DecidableEq α` |
| Copying | `Copying.exchangeAt` | `DecidableEq α` |
| Copying | `Copying.inspect` | `DecidableEq α` |
| Copying | `Copying.inspectAt` | `DecidableEq α` |
| Copying | `Copying.pairDraw` | `DecidableEq α` |
| Copying | `Copying.readStep` | `DecidableEq α` |
| Copying | `Copying.readSteps` | `DecidableEq α` |
| Copying | `Copying.readTick` | `DecidableEq α` |
| Copying | `Copying.remove` | `DecidableEq α` |
| Copying | `Copying.removeAll` | `DecidableEq α` |
| Copying | `Copying.scanSites` | `DecidableEq α` |
| Copying | `Copying.steps` | `DecidableEq α` |
| Copying | `Copying.tick` | `DecidableEq α` |
| Copying | `Copying.unlikeFrom` | `DecidableEq α` |
| Counterfactual | `mixIn` | `DecidableEq C` |
| Counting | `World.CensusMarksHold` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` |
| Counting | `World.saturated_decided` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` |
| Coupling | `policyUpto` | `DecidableEq K` |
| Courses | `Courses.inspection` | `DecidableEq α` |
| Courses | `Courses.release` | `DecidableEq α` |
| Dissipation | `adjoin` | `DecidableEq α` |
| Dissipation | `decideMem` | `DecidableEq α` |
| Dissipation | `insertNew` | `Decidable (a ∈ l)` |
| Identification | `Identification.decBorneOut` | `DecidableEq O` |
| Identification | `Identification.decFits` | `DecidableEq O` |
| Identification | `Identification.firstFit` | `(a : α) → Decidable (p a)` |
| Identification | `Identification.leastBound` | `DecidableEq O` |
| Identification | `Identification.leastFit` | `DecidableEq O` |
| Identification | `Identification.withBound` | `DecidableEq O` |
| Identification | `Law.decideAlike` | `DecidableEq R` |
| Identity | `Web.Census.decideContinued` | `(t : Nat) → (g f : F) → Decidable (R t g f)` |
| Identity | `Web.Census.decideContinues` | `(t : Nat) → (g f : F) → Decidable (R t g f)` |
| Identity | `Web.instDecidableArisesFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)` |
| Identity | `Web.instDecidableCeasesFrom` | `(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)` |
| Lasting | `Lasting.hitTime` | `DecidablePred target` |
| Learnable | `Learnable.withWorld` | `DecidableEq R` |
| Learnable | `Learnable.withWorldAt` | `DecidableEq R` |
| Learning | `Learning.decRefuted` | `DecidableEq O` |
| Learning | `Learning.decRefutedAt` | `DecidableEq O` |
| Learning | `Learning.decideSeen` | `DecidableEq K` |
| Learning | `Learning.index` | `DecidableEq O` |
| Learning | `Learning.indexOn` | `DecidableEq O` |
| Learning | `Learning.learner` | `DecidableEq O` |
| Learning | `Learning.swapTo` | `DecidableEq O` |
| Listing | `decideIn` | `(b : α) → b ∈ l → Decidable (a = b)` |
| Listing | `keepFresh` | `Decidable P` |
| Listing | `listOnce` | `(a b : α) → a ∈ l → b ∈ l → Decidable (a = b)` |
| LossMatching | `Frame.classCount` | `DecidableEq K` |
| LossMatching | `Frame.lostOf` | `(c : C) → Decidable (F.realized s c)` |
| LossMatching | `LossMatching.decideDistinct` | `DecidableEq α` |
| Onward | `Onward.decidedTest` | `(s : S) → (a : A) → (t : S) → Decidable (P.step s a t)`；`(s : S) → Decidable (K s)` |
| Order | `Web.commuteDecided` | `(n : Nat) → (f : F) → Decidable (W.active n f)` |
| OrderNormal | `Footprinted.inList` | `DecidableEq X` |
| Parting | `Parting.advance` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.advanced` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.candidates` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` |
| Parting | `Parting.firstLive` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.live` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.liveRun` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.worldLearner` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` |
| Persistence | `Reidentify.exchangeAfter` | `DecidableEq X` |
| Persistence | `transpose` | `DecidableEq X` |
| Population | `Web.decideDissolves` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` |
| Population | `Web.decideForms` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` |
| Population | `decideSome` | `(a : α) → Decidable (p a)` |
| Premises | `keep` | `(a : α) → Decidable (p a)` |
| Propagation | `mixCells` | `DecidableEq C` |
| Readout | `Readout.blame` | `DecidableEq D` |
| Readout | `Readout.firstJudge` | `DecidableEq K` |
| Readout | `Readout.pick` | `Decidable p` |
| Regrouping | `Web.requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` |
| Reserve | `Web.redirect` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` |
| Retrodiction | `Retrodiction.changes` | `DecidableEq R` |
| Runaway | `Web.raise` | `DecidableEq C` |
| Sampling | `Flow.sample` | `DecidableEq F` |
| Sampling | `Flow.unionPresent` | `DecidableEq F` |
| Sampling | `World.sample` | `DecidableEq w.Relatum` |
| Sampling | `gate` | `DecidableEq α` |
| Sampling | `gateBy` | `Decidable p` |
| Segmentation | `Segmentation.bond` | `DecidableEq α` |
| Segmentation | `Segmentation.departures` | `DecidableEq α` |
| Segmentation | `Segmentation.transitions` | `DecidableEq α` |
| Selection | `Relabel.Equivariant` | `DecidableEq K` |
| Selection | `Relabel.EquivariantChoice` | `DecidableEq K` |
| Selection | `Relabel.EquivariantValue` | `DecidableEq K` |
| Selection | `Relabel.swap` | `DecidableEq K` |
| Sensitivity | `tailLaw` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` |
| Sensitivity | `vanishIndicator` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` |
| Situations | `Situations.occ` | `DecidableEq α` |
| Standing | `World.DependenceMarksHold` | `(t : Nat) → (f c : w.Relatum) → Decidable (w.web.requires t f c)` |
| Tail | `lpoRuleOfVanishDecision` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` |
| Tail | `neverIndicator` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` |
| Tail | `neverLaw` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` |
| Tail | `raisedFrom` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` |
| Tail | `vanishDecisionOfLPORule` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` |
| Tail | `vanishesFrom` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` |
| Tail | `wlpoRuleOfLPORule` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` |
| Testing | `recordThen` | `DecidableEq C` |
| Tower | `Tower.flow` | `DecidableEq F` |
| Tower | `Tower.reads` | `DecidableEq F` |
| Tower | `Tower.refine` | `DecidableEq F` |
| Tower | `Tower.web` | `DecidableEq F` |
| Viability | `Viability.guardedHistory` | `DecidablePred guard` |
| Viability | `Viability.guardedStep` | `DecidablePred guard` |
| Weighted | `dirac` | `DecidableEq Ω` |

Also: a part is given as `part : F → Bool`, its split decided by its type (`Becoming.Admission`, `Becoming.Significance`); it is a parameter of the comparison, not a premise about the world.
