<!-- AI-written: one of seven read-only readers, 4 November 2026, for the atlas plan. Kept as evidence for PLAN.md; not checked line by line. -->

# Attractor-atlas slice: what 02-MAP and 03-KNOWING say about attraction, locks, drains, capture and thresholds

## 0. What I did

- **`theories/becoming/chapters/02-MAP.md`:** read in full, lines 1–479.
- **`theories/becoming/chapters/03-KNOWING.md`:** read in full, lines 1–579, with three exceptions in §12, which have nothing to do with attractors:
  - line 550 (`r-a-reading-informed-and-revalued`): only its first 5,000 of 10,297 characters;
  - lines 547 and 552 (the Readings after §12's holding-for-a-reading laws): not read.
- **Record files:** for every `id="r-…"` anchor in both chapters I checked that `theories/becoming/results/records/<id>.json` exists and noted its `kind` and `status`. I read `statement.en` for 15 key records. No record was read in full.
- **Lean names:** I searched the Lean tree for 23 of the declaration names cited below, and all were found. I did not check any proofs.
- **Labels used below:** every 02 record is `theorem / recorded-checked`, so "Core" means the pure core and "Periph" means periphery, with its axioms named.

---

## 1. 02-MAP: what each dynamic forbids, its exits and its transitions

### §1 The map on branches (`#branches`)

| Record id | Statement (home's words, shortened) | Model; standing | Key Lean | Forbids / exit / transition |
|---|---|---|---|---|
| `generation-and-degeneration-at-two-grains` | Generation (生成), keeping (守) and degeneration (退化, 尽). Generation and keeping each exclude degeneration. On a single line they exclude each other. Along branches they can mix (生守相杂). The three strong forms are 全生成, 全守 and 有终. | Root, every carrier, relation and pair of classes; Core | `«延尽不并»`, `«生成退化不并»`, `«守退化不并»`, `Map.«生守相杂»`, `«单行则生守不并»`, `«全三域之周»` (EM a hypothesis), `«三域之周»`, `«后守退化不并»`, `«有常则无终»`, `«阶生成则上不退化»`, `Map.Once.*`, `Map.Short.renews_and_ends` | **Forbids:** generating or keeping together with degenerating; a constant coarse class reaching an end; generation at order k with order k+1 ending on every branch. **Transition:** placing every point in a region is exactly excluded middle (`«三域之定当且仅当排中»`). Deciding 后守 gives LPO and deciding 生成 gives only WLPO (`Map.«后守之定则LPO»`, `Map.«生成之定则WLPO»`). "Renewal does not decide the region." |
| (same record) `Becoming.MapInstances` | On the World under passing, a 全生成 line has carriers arising at arbitrarily late steps. Read by names alone, nothing is 全生成. | World | `Web.carries_iff`, `Web.generation_arises_late`, `Web.itself_not_generation`, `Web.itself_keeps`, `Map.renewal_undecided` | The some-branch regions are **not read on the World**. |
| `degeneration-from-a-horizon` | A line from an active occurrence, of which nothing reached at step `N` is active, ends on every branch. | World; root for reaching an end | `Web.every_branch_ends_of_gone`, `Web.ends_of_ends_at`, `Web.consumed_held_degenerates`, `Web.family_excess_degenerates`, `Web.stopped_degenerates`, `Map.end_of_gone_iff_excluded_middle`, `«尽则有终当且仅当排中»` | **Transition:** a horizon `N`. Locating where the line ends needs a decision at each point. |

### §2 Return and attraction (`#return`)

| Record id | Statement | Model | Key Lean | Lock / exit / transition |
|---|---|---|---|---|
| `attraction-is-not-returning` | A configuration is drawn into an absorbing region exactly where it does not return, and once drawn never comes back. The home calls it "near-definitional, not a classical attractor". | Any type, determined law, no finiteness | `Law.drawn_iff_not_returns`, `Law.reachable_absorbing`, `Law.Merges.not_both_return`, `Law.Merges.draws` (¬¬), `Run.locked_in` | Absorption. **Edge:** an open world separates merging from drawing. |
| `basins-of-a-determined-law` | Courses meeting is an equivalence whose classes are basins. Within `m` listed configurations every course enters what returns before step `m`, and each basin holds one cycle. | Any type | `Law.enters_returning_within`, `Law.basin_one_cycle` | Entry deadline `m`. |
| `returning-where-the-course-branches` | Every configuration returns exactly where each never-left region keeps every possibility of its own. | Any process | `Branching.returns_iff_keepsWithin`, `Transit.keeps_not_returns` | — |
| `necessarily-drawn-is-not-returning` | Every process necessarily draws exactly what does not return. "Possibly drawn" is losing oneself on some course. A dead end is necessarily drawn only vacuously. | Any process | `Branching.necessarilyDrawn_iff_not_returns`, `OneWay`, `Law.perturbation_drawnInto` | A perturbed state is drawn back at once (self-keeping rule). |
| `every-loss-passes-a-juncture` | Every loss of a returning `s` passes a juncture 机 (up to ¬¬). A process keeping `s` has no juncture for it. | Any process | `Branching.loss_passes_juncture`, `Branching.no_juncture_of_keeps`, `Many`; `Branching.lpo_of_junctures_found` (LPO) | **Transition:** the juncture. **Exit:** keep only the steps after which `s` can still be had. |
| `a-source-before-a-juncture` | To turn a reader at a juncture, a source must reach it before `D`. | World with a process | `TimedResponse.same_step_unreached`, `TimedResponse.turned_at_juncture` (¬¬) | **Deadline:** `D`. |
| `reaching-before-and-after-a-juncture` | "A choice matters only at a juncture." | Any process; listed and decided | `Branching.reach_within_listed`, `Branching.keeps_before_juncture` | — |
| `endpoint-loss-and-return`, `effective-capacity-and-eventual-reachability`, `control-coherence-loss` | Cases at their own scope: hidden lost endpoint; release loses joint realization; no map restores a merge. | Any process / any type | `Irreversibility.constant_reading_hides_loss`, `ActivationCapacity.release_loses_joint`, `Readout.no_restore` | — |

### §3 Renewal, consumption and wholes

| Record id | Statement | Model | Key Lean | Drain / exit / transition |
|---|---|---|---|---|
| `relational-renewal-classification` | Renews and consumes exclude each other, and do not exhaust the cases (a seasonal condition is neither). In gated giving, a level below `m` stays below. Two drawers, each within renewal, can together consume. | World | `Flow.stays_below_at`, `Flow.ends_below(_at)`, `RelationalRenewal.Law.jointly_consuming` | **Absorbing drain** below `m`. |
| `becoming-renewal-reading` | Which class holds belongs to the run, not to the configuration. | Any process; renewable-process witness | `falls_not_recurring`, `Renewable.class_belongs_to_the_run` | — |
| `becoming-dependence-dynamics` | The outcomes of a loss: restored, transformed or ended. They are constrained, not exhaustive or exclusive. | World | `ceases_at_a_step`, `Web.consumed_ends_when_fixed`, `Crossing` | — |
| `becoming-return-grades` | Return grades renewal; consumption is exactly a dependence that never returns. | World | `Web.consumed_iff`, `Web.Restored.not_consumed`, `Slowing` | Recovery can slow without bound. |
| `becoming-finite-horizon` | For every horizon `h`, a reading fixed by `h` that includes every renewing run includes a consuming one. | Renewable process | `Renewable.finite_reading_includes_consumption`, `Becoming.ModelStatements.renewing_not_closed` | — |
| `substitution-preserves-consumption` | Switching keeps the formation active without undoing its consumption. | World | `Web.consumingIn_kept_iff`, `persists_consuming` | — |
| `supported-renewal-recovery` | `m − level` steps of joint net giving restore the level. "Recovery does not guarantee maintenance." | World | `Flow.restores` | **Exit** from the drain. |
| `renewing-consuming-formation` | A one-step count ranks consuming first; past a bound, every renewing course exceeds every consuming one. | Periph (`propext`, `Quot.sound`, `Classical.choice`); a supplied wear law | `RenewingFormation` | **Transition:** the bound. |
| `represented-boundary-against-dependence` | A formation keeps its own support and can still undermine another's. | World | `Web.RenewingOver.keeps_own`, `Clearing`, `Omitted.loses_own` | — |
| `unceasing-generation-needs-renewal`, `more-needs-renewers`, `no-finite-part-bears-taking`, `continuing-self-fed-from-beyond`, `far-conveying-runs-the-family-down`, `arising-needs-change` | Arising without end needs renewal from beyond any finite family; a stock `S` conveys at most `S` stages. | World | `Web.Unceasing.activeRenewer_recurs`, `Flow.More.renewers_unbounded`, `Flow.Dissipative.opens`, `Flow.fed_from_beyond`, `Halving.never_rests`, `rest_needs_quantum`, `Flow.conveyed_loses`, `Web.not_arises_of_unchanged` | **Edge:** no theorem over real amounts. |
| `support-passed-on` | Support runs as a chain of gains, each giver a newer gainer. | World | `Flow.support_passes_on` (¬¬), `Flow.gain_given_by_recent_gainer_at` | **Window:** `K` steps. |
| `whole-persists-through-generation`, `a-whole-carried-by-lasting-parts`, `a-whole-of-every-part` | A whole persists only through new parts arising within `d` steps. A whole of every part ends once one part ends. | World | `Whole.arises_within`, `Covered.needs_new`, `Web.Whole.persists_from`, `Web.AllWhole.ends_of_part`, `Web.diminished_iff` | **Windows:** `d`, `T + d`. |

### §4 Rest

| Record id | Statement | Model | Key Lean | What it rules out |
|---|---|---|---|---|
| `least-loss-rest` | With a least loss `ε` (or Archimedean amounts), the falling steps do not recur. | Any type; the World an instance | `Amounts.rests`, `Law.loss_needs_merge` | Endless loss. A halving stock is the counter-witness. |
| `rest-from-a-finite-reading` | Read off a list, strict falls number at most the list's length. | Any type | `Amounts.rests_of_finite_reading`, `Halving.stock_unlisted` | — |
| `merge-of-a-part-kept-by-the-rest` | Landauer's count with Bennett's history; kT ln 2 is not derived. | Any type | `Law.Lossless.narrowing_spreads`, `Reset.kept_by_rest`, `Law.withHistory_never_returns` | — |
| `continued-change-needs-openness` | The rest theorem: under the enclosed premises, rest cannot be refuted. | World | `World.comes_to_rest_unrefuted`, `World.arising_opens`, `World.holding_world`, `World.lpo_of_finite_ends` (LPO) | Endless change under enclosure. Naming the step gives LPO. |
| `rest-theorem-in-any-amounts`, `rest-exactly-where-falls-stop`, `rest-by-balance` | Rest in any amounts; rest exactly where the strict falls stop. | World / any type | `World.InAmounts.rests_unrefuted_enclosed`, `Pass.endless_keeps_from_rest`, `Amounts.worldsRest_of_noEndlessFall`, `Amounts.falls_by_stretch` | Classical equivalence not shown constructively. |
| `least-loss-from-entropy-production` | The second law alone gives no dissipation; a floor of destroyed exergy does. | Periph (3 axioms) | `EntropyProduction.secondLaw_not_dissipative`, `EntropyProduction.dissipative_of_floor`, `EntropyProduction.taking_not_recurring_ae` | — |
| `entropy-history-and-record`, `returning-novelty-forgetting-on-levels`, `where-novelty-gain-comes-from`, `rest-at-every-resolution`, `rest-with-refinement-counted` | A history never shrinks; a bounded family revisits and forgets. | World | `Flow.dissipatesOn_iff_conserved`, `Web.revisits_of_bounded`, `World.forgets_of_bounded`, `Flow.rise_from_rest_or_open`, `Flow.uptake_bound`, `World.rests_unrefuted_refinement_counted` | `rest-at-every-resolution` uses a research-note premise, not the theory's. |

### §5 Draw and margin: the thresholds

| Record id | Statement | Model | Key Lean | Transition |
|---|---|---|---|---|
| `a-need-with-a-cap` | A band between need and cap, stated in margins. | World | `Flow.fitsBand_iff_within_margins_at` | — |
| `margin-of-a-regime` | "The point of no return is exact": a level up to `hi` ends exactly where it starts below `H + y`. Joint draws are superadditive up to one, `a + b ≤ c + 1`. | Regime, any giving law, whole numbers | `RegimeMargin.ends_iff_below`, `RegimeMargin.root_above_need`, `RegimeMargin.lowered_raises(_strictly)`, `RegimeMargin.rises_superadditive` | **Exact threshold** `H + y`. "They locate an end, ordering nothing." |
| `exit-from-a-margin` | Courses reaching the need within `n` steps take at most `n·p·q/m²` of the weight (Kolmogorov in counts). | Two values, natural weights, independent steps; unregulated | `ConditionalWeights.fallsWithin_share`, `ConditionalWeights.fallsTo_succ`, `ConditionalWeights.record_share` | The bound is void from `n = m²/(pq)` (Reading D45). |
| `threshold-in-the-state-plane` | "One law of exact thresholds": a fate down-closed in the level, read off an exact check, has an exact least level. | Any fate over whole-number levels | `RegimeMargin.leading_exact`, `RegimeMargin.leading_falls`, `RegimeMargin.Adjusted.falls_iff_below` (decided at `3hi+3`), `RegimeMargin.Notch.no_threshold` | Without "rising with what is left", no threshold exists (Notch). |
| `regime-point-under-adjusting-giving`; `where-a-run-of-a-regime-comes-to-rest` | Every run within the band rests within `3hi+3` steps. "Overcompensating giving can cycle for ever." | Regime | `Adjusted.rests_iff`, `Crossing.crosses`, `Adjusted.comes_to_rest`, `Alternation` | **Cycle** exists, as a witness only. |
| `regime-in-any-amounts` | Over the non-negative reals, every run converges and need not rest. | Any linear order; Periph for the reals | `Drawn.run_shape`, `Drawn.converges` | — |
| `coupled-regimes`, `coupled-webs`, `rest-on-coupled-webs`, `thresholds-beyond-a-band`, `webs-with-a-recent-giving` | A cascade runs downstream along total dependence; a ring ends together or not at all. Support beyond a band can sustain a cycle. Recent giving can lower a threshold. | Regime / webs | `Coupled.ends_iff_below`, `Coupled.Indexed.ends_downstream`, `Coupled.Indexed.threshold_falls`, `Coupled.Indexed.ends_iff_within`, `Momentum` | **Deadlines:** `2hi+1`; count·hi + 1; `(B+1)^n`. |

### §6 Closures, §7 carried differences and loops, §8 regulation

| Record id | Statement | Model | Key Lean | Transition |
|---|---|---|---|---|
| `feeding-closure`; `consumption-ends-with-feeders`; `where-a-rising-take-ends` | An unfed consumer lasts at most its level at `T` in steps. A rising take ends after `B+1` steps. | World | `Flow.beyond_gives_nothing`, `Flow.Balances.consumption_ends_with_feeders`, `Overshoot`, `Flow.seeking_ends`, `Flow.seeking_exhausts` | **Deadlines:** level at `T`; `B+1`. |
| `growth-constrained-fragmentation` | Grown graphs constrain what fragmentation does. | Periph | `GrownFragmentation`; `Becoming.Cuts` | — |
| `how-a-carried-difference-grows`, `what-a-cut-loses`, `two-act-worlds-carry-the-difference` | The carried amount is at most `D(1+M)^t`. A polynomial bound holds exactly where no loop lies upstream. | World | `finite_order_iff_no_loop`, `carried_le_geomBound`, `gap_polynomial_iff_no_loop`, `carried_le_polynomial_from` | **Loop ⇔ faster than polynomial** (a worst case). |
| `how-loops-form`; `loops-within-what-a-law-reads`; `whether-a-loop-closes-a-difference`; `how-often-couplings-act`; `a-coupling-saturated-by-what-it-has-carried`; `repeated-disturbance` | Loop onset is not foreseeable in the amounts. A loop forms at the break. Whole-number factors leave "nothing between". | World / any type | `Closing.Onset.unforeseen`, `Thresholds.Draw.forms_at_break`, `LoopReturn.nothing_between`, `Frequency.Sparse.polynomial`, `settled_iff_recursOrStops` (LPO), `Saturation.stops`, `carried_le_disturbed` | — |
| `differences-below-threshold`; `runaway-distance-uncoupled` | How far off the break is does not couple in. | World | `Flow.subthreshold_alike`, `Flow.policy_uses_after_failure`, `Web.break_not_bounded` | Blindness up to the break. |
| `counterfactual-is-the-course`, `where-two-courses-rejoin`, `how-much-difference-arrives`, sums-over-histories rows | Counterfactuals and carried amounts; groundwork, not attractors. | World / any type | `counterfactual_is_course`, `Flow.stays_beyond_response`, `most_difference_arrives` | — |
| `two-sided-regulation-and-late-reading` | "The bound is exactly no overshoot"; beyond it the level can oscillate for ever. No band narrower than `2(ℓ+1)d`. The relay settles exactly where `a+(ℓ+1)M ≤ b+1`. | World / any type | `Flow.withinGap_iff_between`, `Regulation.no_narrower_band`, `Regulation.relay_threshold` | **Thresholds** stated by those inequalities. |
| `regulation-from-one-side-and-locally` | Gated renewal: a level below `m` never returns to it. A family's stock settles locally. | World | `Flow.never_returns_below`, `Flow.stock_settles` | One-sided lock. |
| `how-fast-a-rule-may-change` | A stretch fixes every held-rule course with at most `N` states exactly when `L ≥ 2N−1`. | Any type | `Pace.pace_law` | **Pace bound.** |
| `reserve-defers-ending`; `dormancy-over-a-stretch` | A reserve defers an end without escaping it; coextinction runs down a chain of links. | World | `Web.Carries.lasts`, `Web.Carries.chain_ends`, `Web.lpo_of_ending` (LPO), `Web.late_return_finds_none` | Deferral, not escape. |

### §9 Capture (`#capture`); every law is Core

| Record id | Statement | Model | Key Lean | Lock / exit / transition |
|---|---|---|---|---|
| `target-capture` | A target's carriers' share rises; a perturbed state is re-absorbed in one step. | Any type; World for the descent | `share_rises`, `Law.perturbation_reabsorbed`, `Flow.descent_exhausted` | — |
| `capture-through-the-rule` | Locked from the step after the first reading step. "The lock belongs to how the rule reads, not the share it favours." | Any type, two-level course | `RuleCapture.favouring_locks`, `RuleCapture.Reversed.not_absorbed` | **Exits:** a change of the law, of how the rule reads, or of the selection. A reversal held past the threshold is not absorbed. |
| `two-rules-lock-together`; `a-reading-against-the-share-does-not-ratchet` | A pair of rules locks; a rule read against the share does not ratchet. | Any type | `RuleCapture.pair_locks`, `RuleCapture.against_not_rising` | — |
| `closed-capture` | "The loss passes every bound while the course stays locked." | Any type | `ClosedCapture.courses_alike_iff_unread`, `ClosedCapture.lock_outlives_loss`, `ClosedCapture.turned_by_loss` | **Exit:** a reading that favours at no loss above a bound, "a sufficient way out". |
| `readers-drawn-from-the-selected` | Who reads decides whether, and when, a reading of the loss turns the course. | Any type | `ClosedCapture.Drawn.pool_reads_iff`, `ClosedCapture.agreeing_stays`, `Thinned.kept_iff`, `Thinned.turned_iff`, `Thinned.late_kept` | **Transition:** the carriers at least as many as the others when the loss is read. |
| `shaping-the-rule-selected-by-what-comes-back` | The rule favours the shapers exactly where `c ≤ s`. | Counts, no noise | `RuleShaping.favours_iff`, `RuleShaping.nothing_back_falls`, `RuleShaping.stretch_iff`, `RuleShaping.covering_locks`, `RuleShaping.threshold_rises/falls` | **Tipping** where `lo < c < hi`. |
| `shaping-selected-among-groups` | Hamilton's rule with what comes back added: `c < s + m q ρ`. With unequal sizes, either verdict is possible. | Counts | `RuleShaping.grouped_rises_iff`, `RuleShaping.grouped_rises_iff_sized`, `RuleShaping.Sized.either_verdict` | — |
| `shaping-read-by-readers-drawn-from-the-selected` | "Every such course is locked one way at every step"; this is the stag hunt. | Counts, no noise | `DrawnShaping.critical_mass_iff`, `DrawnShaping.drawn_locks`, `DrawnShaping.drawn_locked_either`, `DrawnShaping.CriticalMass` | **Critical mass:** the shapers stand to the others at least as `c − lo` to `hi − c`. |
| `drawn-shaping-drawn-one-at-a-time` | "Drawn, neither lock holds for good." Fixation weight can part from risk dominance. | Counts | `DrawnReplacement.fixation`, `lost_above`, `fixed_below`, `risk_dominant_iff` (`2c < hi+lo`), `Strong.other_first` | **Exit by drift**, its weight bound shrinking with distance from the mass. |
| `loss-read-in-time-by-the-others` | Turning steps come first and keeping steps last, with at most one step between. A deadline bounds the window. | Counts | `ReadInTime.kept_iff`, `turned_iff`, `in_time_earlier`, `at_most_one_between`, `ReadInTime.deadline`, `ReadInTime.Window` | **Window:** the deadline `g.other·c·x.other`, quadratic in the start's counts; 24 in the witness. |
| `capture-by-counted-choices` | The threshold `κo·other ≤ κc·carrier` splits the counts into two never-left regions. | World for the selection laws, counts for the count laws | `ChoiceCountCapture.counted_locks(_down)`, `counted_outlives_loss`, `posterior_count_falls` | **Bistable** regions. |
| `rules-that-change-themselves-in-the-grammar` | The rule is read in the state's regularity. A lock line never ends while the unread loss changes at every step. | Root | `adaptive_constant_iff`, `ClosedCapture.constant_iff_unread`, `ClosedCapture.lock_line`, `ClosedCapture.loss_ends_line` | **Exit:** `loss_ends_line`. |

---

## 2. 03-KNOWING: the results relevant to attractors and thresholds

| Record id | Statement | Model | Key Lean | Lock / transition |
|---|---|---|---|---|
| `selection-through-couplings` (blindness) | A selection cannot tell apart what does not couple into the selector. | World | `Flow.unselected_beyond_coupling(_responsive)`, `Clearing.unselected` | Grounds locked seeking. |
| `the-markov-blanket-as-a-coupling-structure` | Supply read only by threshold: every reading of the internal course is alike to step four; the break registers at four. | Any type; four-part law | `Blanket.ThresholdDrain.any_model`, `Blanket.ThresholdDrain.sensory_apart_at_four` | A drain unseen until the break. |
| `a-formations-couplings-as-its-blanket` | A three-phase drain is admitted by no law; a two-phase drain-and-feed is admitted. | Any type / World | `BlanketCouplings.PhasedDrain.not_admitted`, `BlanketCouplings.Alternating.recurs` | — |
| `what-the-existence-claim-forbids` | The ended witness rests at a fixed point of its law. | Any type | `Blanket.ThresholdDrain.short_rests`, `Blanket.forbids_iff` | — |
| `one-reader-several-conditions` | A reader keeps a condition within its margin exactly where `(a + l) d ≤ m < (a + 1 + l) d`. | World | `ReadingSchedule.keeps_iff_within`, `keeps_of_half` | **Threshold:** between one half and five sixths (Open). |
| `timely-response-necessity`; `what-a-center-can-know-by-a-step`; `where-a-formations-acts-return` | A deadline `D`; what a center can know grows one link a step; loop classes. | World | `TimedResponse.answer_alike_before`, `TimedResponse.Spread.linked`, `Flow.reachReturns_iff_closed` | **Pace:** one link a step. |
| `rooms-tested-by-a-window` | The overshooting thermostat is in the mixed region and alternates 3 and 4. The matched one is 全守. The unheated room keeps, then degenerates once the window opens. | Root; a family of models | `«给过所取则生守相杂»`, `«给如所取则全守»`, `«开窗则平衡新而尽»`, `Overshooting.alternation_shifted`, `Unheated.window_cold` | **Transition:** the margin `n+1`, told apart at stage `n+1`. |
| `testing-within-couplings` | No finite prefix excludes an eventual zero. | World | `Web.tail_unexcluded` | — |
| `what-a-finite-stretch-verifies`, `what-a-method-comes-to-say-in-the-limit` | Settling is verifiable only in the limit; recurrence is dense. | Any process | `insulates_iff_dense`, `Limit.Sequences.recurs_not_verified`, `LastChange.lpo_iff_settles` | — |
| `learning-by-refutation`; `identification-where-bounded`; `what-an-extrapolation-given-nothing-fixes` | Elimination comes to rest: misses are fewer than `tri N`; it is right from `2N−1`; rest comes late, at least `(N³−N)/4`. | Any type | `Learning.held_byElimination_bounded`, `Identification.leastBound_exact`, `Learnable.ahead_fixes` | The exact rest step is Open. |
| `what-seeking-cannot-separate` | No course of seeking corrects an error that every experiment ties. | Any type | `LumpedSeeking.seeking_keeps_order` | **Lock** of the prior's order. |
| `readings-within-what-they-read`; `revision-with-an-undecided-value` | Completing a family is an unfolding that never returns. Revision settles within `N`; the liar rests undecided. | Any type | `Diagonal.Unfolds.never_returns`, `Undecided.settles`, `Undecided.chain_exact` | **Deadline:** `N`. |
| `seeking-boundary` | Rests exactly at an unchanged state meeting the target. "More than now" needs an open world. "Above all others" never rests for two. | Any type / World | `Law.rests_iff`, `more_needs_open`, `Law.aboveAll_never_rests`, `Flow.more_exhausted` | Exhaustion, not enough. |
| `the-boundary-of-enough-under-undetermined-laws` | Possible vs assured rest; the alternating run never settles. | Any process | `Enough.possibly_rests_iff`, `Enough.assured_iff`, `Enough.Free.stays_meet_not_assured` | — |
| `a-revision-that-opens-a-correction` | Rebuilding the link opens a correction in one step; with one unit, it needs replenishing too. | Any types | `OpenedCorrection.Linked.opens`, `rebuilt_starved`, `opens_after_replenishing` | **Exit** from an uncorrectable state. |
| `recurring-reference-revision` | The cycle repeats exactly where the yield covers nine units. | Any process | `ContinuingRevision.repeats_iff`, `no_run_without_return` | — |
| `formed-goal-revision-continuation` | Runs `n ≤ 5` (`n ≤ 2` without reform). | Periph | `MachineInstances.revision_continues` | — |
| `adaptive-closure-cannot-resolve` | A closed rule must abstain; reopening with inspection repairs. | Periph | `NormativeActivity.reopening_and_inspection_repair` | — |
| `evidence-through-change`; `when-to-inquire-and-when-to-respond` | Error budget `2ρt ≤ B − L − 2σ`; inquiry can cross a floor before its response. | Periph / core | `ChangingDependency.error_growth_budget`, `InquiryChoice.inquiry_can_cross_floor_before_response` | — |
| `slowing-down-before-an-own-end` | Variance `Var E/(1−a²)` and lag-1 autocorrelation `a`, with `a → 1` at a fold or transcritical end. A dependent's need enters neither. | Periph (3 axioms); linearized, one variable | `SlowingDown.stationary_variance`, `stationary_lag1`, `need_not_read` | **Transition:** critical slowing down. |
| `when-complying-when-read-is-best` | Uniquely best exactly where `k_O V + c T < k_C V`; with a fresh draw, `2k_O V + cT < k_C V`. | Natural weights | `ReadStages.complyThenOwn_best_iff`, `ReadStages.freshDraw_above_iff` | Threshold. |
| `a-reading-kept-by-its-update`; `a-response-common-over-a-reading` | A kept region is a closed region; the invariance kernel. | Root | `ReadingLoop.kept_iff_closed`, `«所闭之承最大»`, `Viability.kernel_iff_held` | A viability basin. |
| `what-a-course-chosen-through-its-model-does-not-test`; `acts-alike-from-a-model-or-from-an-order` | "Rests at once on a model its course never refutes." | Any types, blanketed law | `ReadingLoop.Loop.rests_of_unrefuted`, `Untested.rests`, `Untested.never_high`, `Untested.floor_forgoes`, `explorer_up`, `informed_turns` | **Self-confirming lock.** **Exit:** an untried act, or a reading from outside. |
| `a-prediction-read-by-what-it-predicts` | The least right prediction is reached from the bottom by step `n`. A threshold response has two right predictions, the start deciding which. Negation alternates for ever. | Any type | `ReflexivePrediction.bottom_rests`, `ThresholdResponse.reached_by_start`, `Negating.alternates` | **Bistable / cycle.** |
| `what-holding-for-a-reading-is-worth` | Listing only gain, it "rests at once" and never senses the stop. | Natural weights | `HeldForReading.SignLoop.rests_unread`, `never_senses_stop`, `threshold_go_iff` | Self-confirming rest. |

**Not attractor-relevant.** The other 03 records (couplings and blanket readings, tests and joining, free energy, acquisition chain, inquiry assessments) are listed only by id, under the chapter's anchors. The anchor `r-selection-under-registration-revision` has no record of its own; it is an alias of `selection-when-the-lumping-changes`.

---

## 3. Theses

| Thesis | Home | Forbids | Evidence summary | Standing |
|---|---|---|---|---|
| **T1** *Persistence certifies the joint draw* | `02#t1` | A condition below a need measured in advance returning with nothing given from beyond. A dependent active while its condition stood below its need. | **Passed:** held-out yeast regimes (93–100% each side, §266); a simulated Allee yeast (§253); a commons with gated regrowth (§240). **Failed:** the floor of the instrument (§253); salt shock (§266, 7 of 8 died); fish under held catches (§272); §314 (3 of 10 passed; five of six timing verdicts failed). "No field test of a need measured in advance has run." | Proved in the model (the regime, and the World via 05 `r-own-count-misses-joint-excess`); "beyond them conjectured". |
| **T2** *State = level, recent giving, one lag* | `02#t2` | A fourth variable removing a tenth of the residual variance. The level alone forecasting as well at five steps (outside the regime's-step end, shown by a bound). The lag's sign changing between series. | §277 failed; §280 passed; §316 missed; §508: the three numbers better in 42 of 65 (p = 0.025), though worse than persistence in 53 of 65. UE31 (beetle) decided nothing. Restated 4 Nov from proposals 1, 2 and 4. | "conjectured, on the four frozen fish-stock tests above; untested outside fisheries". |
| **T6** *A break is seen coming only through what couples into what breaks* | `03#break-seen-coming` | Given the stock's own course, its early-warning statistics separating runs in which a dependent's need is crossed from runs in which it is not, the dependent taking no measurable share. | The literature refuted the first wording. Three frozen seabird tests did not reject T6: power about 0.3 estimate, about 0.9, about 0.5. None establishes conditional independence. | Invisible half proved on the World (`Web.break_not_bounded`, `Flow.policy_uses_after_failure`); seen half in the periphery; the cross-domain law and "only where" conjectured. |
| **T7** *A measure read from what it selects outlives its refutation* | `02#t7` | Four items: dropped on evidence alone; left more often than the drift bound allows; a reform of the reading alone outlasting the next reading; a metric whose loss is read only by those it disfavours dropped once they are no more than its carriers among its readers. | "Evidence: none frozen." LA2 (frozen 25 Oct, `36c8b79cb`): every frozen verdict passed, the pool conjecture failed for the judge, and the third forbidden case occurred. | In the model, invariance and lock-outlives-loss proved without noise; actual metrics conjectured. |

---

## 4. "Does not show" and "Open" lists (near-verbatim)

**02, not shown:**
- generation better than keeping or degeneration (needs C; the continuation condition for whose losses count);
- regions decided at a point, or renewal being generation;
- which regions actual unfoldings enter, or any measure on branching courses;
- actual systems meeting the World's or the regime's premises, a least loss or a finite reading; that the margin times a break;
- which strengths and loops a world has, a runaway's pace, or a loop forming at every break;
- that passing, a reserve or a regulated level is good;
- any universal phase threshold between regions.

**02, Open:**
- the some-branch regions read on the World;
- lifting §§2–9 onto the grammar (the grammar has no amounts);
- real amounts, damping strengths, continuous time, infinitely many conditions; the regime's threshold over the reals as a computed level;
- rest within a band for webs with a recent giving; partial dependence; a cascade's time;
- a closed form for a turn around a cycle of several conditions;
- whether a capture loop is 生成 at some pair of classes, and 生成 versus widening;
- graded shaping capacities, groups that assort, drift, the rare-mutation limit, the time to leave a lock, the round after the one step between, the step from which the window is closed;
- counted choices beyond two policies;
- field tests: T1 with a need measured in advance, T2 on grassland or forests, a frozen test of T7;
- "reality generally develops more shared and more responsive renewal" as an empirical target, which forbids nothing measurable as stated.

**03, not shown:**
- that an actual selector selects through just the couplings stated;
- that access suffices for knowledge;
- which map or projection an actual formation holds;
- typicality; which way a parting goes; probabilistic or PAC learning;
- that refutability is a criterion of standing, or that self-correction certifies calibration;
- that the reanalyses identify a mechanism.

**03, Open:**
- lifting the World and process laws onto the grammar; relating 诘 to 层;
- a principle weaker than excluded middle; whether the diagonal limit laws need Markov's principle;
- elimination's exact rest step; the one-reader threshold; a least coupling for laws that do not read finitely;
- which law a trained system follows;
- formations that read: a condition for a history policy to exist, deception beyond incentive, and others;
- the two §9 targets;
- T6 on a coupled case, and a measured share for the uncoupled side;
- cognition beyond composition.

---

## 5. "Positive" or generative basins (the account assumes none is good)

02 "does not show … that passing, a reserve or a regulated level is good", and "Patterns of capture pass as patterns of care do".

- **Generation 生成 / 全生成:** `Map.Endless.generation`; generation at order k keeps order k+1 alive. 生成 is not 生生 (D65), and whatever separates it from keeping widening is exactly loss (07 §2).
- **Keeping 守 / 后守 / 全守:** `Map.Still.keeping`; the matched thermostat `«给如所取则全守»`. "Regulation has no region of its own."
- **Renewal:** `RenewingIn`, `Flow.restores`, `Web.Restored.not_consumed`, and support passed on (`Flow.support_passes_on`).
- **Wholes:** a whole carried by lasting parts, `Web.Whole.persists_from`.
- **Regulation:** settling at `m` within the no-overshoot bound; `Regulation.relay_threshold`; local settling, `Flow.stock_settles`.
- **Reserve:** defers an end (`Web.Carries.lasts`) and bridges a gap (dormancy); it does not escape.
- **Rests:** an adjusted regime rests within `3hi+3`; coupled webs rest in a band; mutual support never ends a condition that held.
- **Knowing:** opening a correction (`OpenedCorrection.Linked.opens`); the revision cycle covered by its yield; the least right prediction; revision settling at the least fixed point; 知足 as rest at an unchanged state meeting the target; viability or invariance kernels (`«所闭之承最大»`).

---

## 6. Flags: false, stale or misleading

1. **T7, medium.** "*Evidence*: none frozen; a test needs a coding…" is followed at once by "*Frozen test* … LA2", and the Open list asks for "a frozen test of T7" (02 lines 434–436 and 476). A reader can take these as contradicting each other. The intended sense, "no frozen *field* test of reform events", is stated only at the end of the LA2 paragraph.
2. **T7 and LA2, medium.** 02, 08 (row 574) and ONE-PAGE (line 20) all say T7's third forbidden case "occurs" in LA2. None of the three says whether this counts against T7 or falls outside its premise, since the judge was found not to be a pool counted by kind. Its Forbids and Refuted-by lines are unchanged.
   - On ties, ONE-PAGE says "three by one tie". 02 mentions only "the late course passed by a tie". `experiments/self-rewarding-lock/README.md` lines 13 and 17 confirm that `late`, L3 and L4 all pass by the same tie, so 02 is less complete, not wrong.
3. **T2 standing, low to medium.** "Untested outside fisheries" stands beside MQ6 yeast evidence that "passed" (lag-1 −0.14). That run was outside *Refuted by*'s scope, so the standing is technically right, but it reads as a contradiction.
4. **Front-matter Open items missing from the end lists, low.**
   - 02's thesis Open, "whether every becoming has a faithful representation in the grammar", is not in 02's Open list.
   - 03's thesis Open, "T6's conjectured 'only where'", is not in 03's Open list in those words.
5. **Names, low.** The records `unceasing-generation-needs-renewal` and `whole-persists-through-generation` are about arising, not §1's generation; 02 §3.2 says so itself. They are rename candidates, and the atlas must not file them under 生成.
6. **Labels, low.**
   - `correction-is-not-calibration`: the home leads with "Assessment (argument without Lean)", but the record kind is `theorem`.
   - `wisdom-root-without-axiom`: the home labels it "Reading", but the record kind is `argument`.
   - The alias anchor `r-selection-under-registration-revision` has no record.
7. **Atlas hazard.** `attraction-is-not-returning` is "near-definitional, not a classical attractor". "Necessarily drawn" is vacuous at dead ends. "A region ceasing, a state's departure and a strict bifurcation are not one 'phase transition'" (02 §9, D65 Reading). The atlas should not merge these into one notion.

---

## 7. Attractor-like dynamics no law yet states (gaps)

- **Cycles in general.** Overcompensation (`Alternation`), coupled support beyond a band, overshoot oscillation, the rooms (3 and 4), `RuleCapture.Alternating.never_locked`, `Negating.alternates`, the liar and `Enough.Free` are all witnesses. There is no law of when a regime cycles, or with what period or amplitude; Open lists only "a turn around a cycle of several conditions".
- **Hysteresis.** No law gives distinct collapse and recovery thresholds. Only the one-sided lock (`Flow.never_returns_below`) and recovery time (`Flow.restores`) are stated.
- **Basins for branching processes.** Basins are stated for determined laws only, and no measure on branching courses is given.
- **Noise-driven exit from a regulated regime.** The exit-from-a-margin bound is unregulated only. "Persisting longer needs a giving that reads the level" is a Reading. Time to break, a cascade's time and the time to leave a lock are all open.
- **Self-confirming locks.** `rests_of_unrefuted` exists, but its basin (which starts end there) and exit by noise or exploration are witness-only.
- **Several right predictions.** Which start reaches which fixed point is stated only for the least fixed point from the bottom, plus one threshold witness.
- **Thresholds for fates that are not down-closed.** Notch shows none in one witness; there is no general law of windows or multiple thresholds. The threshold over the reals as a computed level is open.
- **Escalation.** "Above all others" never rests for two, but its course (escalation or cycle) is unstated.
- **Increasing returns.** Lock-in with noise (the urn of Arthur and others) is cited, not stated.
- **Regions read on the World.** There is no law of transitions between some-branch regions on the World.
- **Early warning beyond the linear case.** Nonlinear runs, finite windows, several variables, and T6 with feedback are not treated.

## 8. Reading labels

- **02:**
  - D45 ×7, D65 ×4, plus one more D65 "from the market study";
  - D67 ×1;
  - "D26 as revised in D45, D48, D56, D57, D58" ×1;
  - "D25, D39, D43, D45" ×1 and "D25, D32, D43, D52" ×1;
  - "[AI reading over the proved cases]" ×1, on `#which-locks-noise-leaves`, with no D-number;
  - inline: "Counting it is a reading [AI reading, D45]" in the refinement row.
- **03:**
  - "[AI reading, new]" ×12, all in §§3, 8, 11 and 12, with no D-number;
  - D45 ×7, D65 ×2, D26 ×2, D63 ×1 (the 文 definition);
  - "D26, D45" ×1; "D26, D41, D45" ×1 (无明); "D26, D33, D34, D40, D43, D52" ×1;
  - "D25" ×1; "D25, D39, D43, D45" ×1; "D25, D26" ×1; "D20, D26, D45" ×1 (明).