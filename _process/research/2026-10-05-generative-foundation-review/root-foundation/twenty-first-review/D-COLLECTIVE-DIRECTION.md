# Reader D: collective direction and the meta-attractor (Claude Opus 5.5)

Part of the [twenty-first review](../BECOMING-TWENTY-FIRST-REVIEW.md); an AI report, read-only, kept as evidence. Its claims were checked by the cross-checker ([H](H-CROSS-CHECK.md)) and, where the review leans on them, by the synthesizing reviewer.

## Verdict
Short answer: no, not "always". The theory proves why not. What it does give is narrower and still useful. First, a direction that can always be stated and that every valuer who counts everything positively agrees on: widening, which is Pareto unanimity. But that direction says nothing about mixed cases, and mixed cases are the hard ones. Second, a set of exact exits from the meta-attractor, each true only under stated conditions and each with its edges stated. The honest category for your question is "achievable under stated conditions", not "always guaranteed".

The meta-attractor is defined formally in 02 §9: "a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share". The pure core proves the following, in two-kind count models without noise:
- A rule read from the share it selects locks.
- The lock outlives any loss it does not read.
- Drawing the readers from those the rule selects moves the premise to who reads; it does not remove it.
- The capacity to shape the rule is selected at a step exactly where what comes back to the shapers alone covers its cost.
- Joined, control and lock are one loop on either side of a critical mass, and every course read from the share alone is locked one way or the other.

What feeds the loop is also proved: joint excess, position summing to zero, races for position drawing everything, and optima draining whatever lies beyond their couplings, several optimizers draining together as one of their joint capacity.

The exits that are proved:
- reading the loss in time, before a window that a deadline closes;
- rule-shaping whose returns to the shapers alone do not cover its cost;
- pooling couplings across members;
- restraint where the others' take leaves room (joint slack);
- a per-step reward for keeping a need met;
- someone giving first, and a reserve to start from;
- reviewers counted by independent causes.

Each holds only under its own hypotheses.

The theory's own laws rule out a guarantee:
- A selection is blind beyond what couples into it.
- How far off a break is does not couple in by threshold.
- No reading fixed by a finite record certifies renewal.
- Whether one course eventually widens another can be neither verified nor refuted.
- Points of no return are exact.
- Where the rest outruns the renewal, no weighting selects one member's restraint, and at a mutual best response restraint is not a best response.
- A finite balanced world has no course that keeps widening.
- No statement about the dynamics alone entails the continuation condition.

"Enough situationality" would have to mean all of these together:
- what is drawn and the need it is drawn toward both couple into a pool that can respond;
- they do so before the regime's point of no return;
- they do so before the share reaches the step from which the late reading would favour the shapers;
- the feedback resolves the differences that matter;
- the rest is not outrunning the renewal.

Observation is necessary, not sufficient: the chapter itself says "seeing is not valuing" and "coupling is not compliance". Ranking a generative course as better needs C. Counting losses that return to no one needs the continuation condition. The theory asserts neither.

On zero-sum: starting from relations removes the fixed-sum frame. Joint draws have no single consumer. A part's own widening widens the whole exactly when its net draw stays within others' margins. With no C at all, self-concern ranks a coupled collapse lower. Real rivalry remains: positions sum to zero by counting alone, conserved stocks are rivalrous, and mixed cases stay unranked.

The evidence is thin. Tests ran on one model (Claude Haiku, choosing in context) and toy learners. Human institutions are untested. The one test of the readers premise (LA2) found a judge that did not meet it. The records say the calibration to the present world is "not established". On institutions, checklists follow from the laws. But there is no institution model, no frozen field test of reform events, and the keep-open mechanisms (exit, abundance floor, plurality) are not formalized.

This line is careful and labels itself honestly. The main risk is that readers take theorems about toy models as guarantees.

## Shape
META-ATTRACTOR ON THE SPINE (02 §9; pure core; two-kind counts, no noise)

| Mechanism | Result | Key premise |
|---|---|---|
| rule read from share locks | RuleCapture.favouring_locks | ReadsShare |
| lock outlives unread loss | ClosedCapture.lock_outlives_loss | Unread, accrual |
| who reads | Drawn.pool_reads_iff, Thinned.kept_iff | readers drawn by kind (LA2: unmet) |
| control selected | RuleShaping.favours_iff (c ≤ s) | capacity inherited |
| one loop, critical mass | DrawnShaping.critical_mass_iff, drawn_locked_either | lo ≤ hi |
| feeders | joint_excess_ends, rise_needs_fall, position_keeps_nothing, Optimum.least_iff, mutual_beyond | World: balance, gate, room |

EXITS (each conditional)
- read the loss: turned_by_loss (sufficient only)
- read in time: ReadInTime.turned_early_iff; window closes (kept_once_favoured, deadline)
- control not selected: nothing_back_falls (but SharedFlips; lower_c_raises)
- pool couplings: act_unselected_pool (reach = union); recruitment needs an outside reader
- restrain within joint slack: kept_of_restrained; exclusive footprints: level_kept_of_plans
- per-step keeping coupling: frontier_keeps_stepwise
- give first and hold a reserve: sparing_gives / total_stays; ignition_requires_actual_reserve

CAN WE ALWAYS? (the theory's own laws)

| Sense | Verdict | Why |
|---|---|---|
| always guaranteed | NO | break_not_bounded; finite_reading_includes_consumption; eventually_neither; ends_iff_below; outrun_reading_alike; MutualBest.full; whole_not_keepsWidening; not_entails; lpo_iff_settles |
| always available as a direction | ONLY AS A CRITERION | widens_iff_every_positive (unanimity) but mixed_either_way; recognition needs pooled coupling (widening_selected_by_pool) |
| achievable under stated conditions | YES, for named exits | coupling + responsive reach + in time + resolved feedback + pace ≥ 2N−1 + rest not outrunning |

PREMISES: scope = continuation condition; order = C; plus J1–J4 and E. Neither condition nor C is asserted. Mixed cases need a further measure (open).
EMPIRICAL: T3 partly supported (Claude Haiku in context); T4 one model of two; T5 VD1 failed, VD2 partial; T7 LA2 bridge failed; humans untested.

## Answers
### (1) What is the meta-attractor in the theory's terms, which results describe it (with hypotheses), and which results describe exits?
DEFINITION. 02 §9 defines the meta-attractor formally: "a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share." A second, wider definition is the one Ren selected on 8 October in the meta-attractor line: an organization whose consequences help rebuild the conditions that select it, across changes of its carriers. That wider one is not on the spine; 02 §9 reading D65 marks whether a capture loop is 生成 as Open.

RESULTS THAT DESCRIBE IT (all pure core unless stated; any type or counts unless stated):
(a) Capture through the rule. With `Raises` (selection does not lower the share under a favouring rule) and `ReadsShare` (the rule read is monotone in the share), the course locks from the step after its first reading step (`RuleCapture.favouring_locks`). A perturbation that keeps the rule's direction is absorbed. Only a change of the law, of how the rule reads, or of the selection leaves.
(b) Closed capture. Where neither the next share nor the rule read reads the beyond (`Unread`), courses alike in share and rule stay alike (`courses_alike_iff_unread`). Under accrual of at least one beyond per step, the loss passes every bound while the course stays locked (`ClosedCapture.lock_outlives_loss`). A change of the reading formed from the share is absorbed.
(c) Readers drawn from the selected (MA2). `ReadsShare` holds exactly where `v` is not above `u`, so the premise moves to who reads (`Drawn.pool_reads_iff`). A loss read only by the others keeps the lock for good exactly where the carriers are at least as many when it is read (`Thinned.kept_iff`).
(d) Selection for control (MA3). The rule favours the shapers exactly where `c ≤ s`, whatever the shared part `p` (`RuleShaping.favours_iff`). Across a stretch, `(a+c+p)^m(a+c+p)^n ≤ (a+p)^m(a+s+p)^n` decides (`stretch_iff`). Where what comes back is monotone and covers the cost, the loop locks (`covering_locks`).
(e) MA4 joins (c) and (d). With `lo ≤ hi`, a share decides exactly where `lo < c < hi` (`DrawnShaping.critical_mass_iff`), and every course read from the share alone is locked one way at every step (`drawn_locked_either`). Above the mass, control rises and the lock is for the shapers. Below, control falls, but the course is locked the other way.
(f) Inputs that feed the loop: joint excess ends a gated renewal whatever each taker's own draw (`Flow.joint_excess_ends`, World with balance and the gate); positions sum to zero (`RelativePosition.change_balances`) and do not protect (`Flow.race_ends_greatest`); a race for position keeps nothing (`Optimum.InTurn.position_keeps_nothing`); with room, an optimum drains what lies beyond its couplings as far as any eligible outcome (`Optimum.least_iff`); several optimizers at a mutual best response drain as one of their joint capacity, and restraint is no mutual best response (`Optimum.mutual_beyond`, `Optimum.MutualBest.full`); a long-horizon optimizer keeps its own base and breaks what needs more (`Optimum.frontier_holds`, read in the AJ plan as instrumental convergence); a rise past the inflow is drawn from beyond (`Flow.Balances.rise_draws_beyond_inflow`).

RESULTS THAT DESCRIBE EXITS:
- A reading that favours at no loss above a bound unlocks. This is sufficient, not shown necessary (`ClosedCapture.turned_by_loss`).
- A perturbation reversing the direction, held past the threshold, is not absorbed (`RuleCapture.Reversed.not_absorbed`).
- A rule read against the share does not ratchet (`against_not_rising`).
- Read in time (MA4b): a reading turns the course for good exactly where the late reading still favours the others at the share one step on (`ReadInTime.turned_early_iff`). Once it would favour the shapers, every later reading keeps the lock (`kept_once_favoured`). At most one step lies between (`at_most_one_between`), and a deadline quadratic in the start's counts bounds the window (`ReadInTime.deadline`).
- Control not selected: with nothing coming back to the shapers alone and a positive cost, their share falls at every step (`RuleShaping.nothing_back_falls`). But a larger shared part can turn the verdict across a stretch (`SharedFlips`). Cheaper shaping raises selection for control (`lower_c_raises`), the basis of AI reading D68 that capable assistance to rule-shapers does not lower it.
- Pooling: the pool reaches the union of its members' closures and nothing beyond (`Flow.act_unselected_pool`, `Web.separates_all_iff_member`). A pool that recruits through itself couples into a loss only as its course without the loss would (`Web.RecruitsThrough.alike_iff`). A scheduled outside reader breaks this (`PoolCourse.scheduled_apart`).
- Shared condition (GS4/GS5): held de se under the one or the class of being joined, concern reaches the members that a condition one affects later feeds (`SharedCondition.affecting_reaches_other`, `«族之所及即一之所及»`). A common cause reaches nothing (`fed_outside`). These are witness-level; the general form is open (PW §6f).
- Widening as a criterion, not a target: `Weighting.widens_iff_every_positive`; AJ PLAN §2 argues that a criterion cannot become a share-read proxy.
- Restraint within joint slack keeps a need met (`Flow.Balances.kept_of_restrained`). Exclusive-footprint joint plans keep the level (`Flow.level_kept_of_plans`). A per-step coupling for keeping makes every optimum keep at every horizon where `r ≤ q + c` and `e < c` (`Optimum.frontier_keeps_stepwise`).
- Giving first and sparing formations restore giving; without one, total withholding stays (`Tolerance.sparing_gives`, `Tolerance.total_stays`). Ignition needs an actual reserve (`ignition_requires_actual_reserve`, periphery).
- Reviewers count by independent causes (`Reconfiguration.ready_iff_nonempty_separated`).

KEY CAVEATS:
- Every capture result is a two-kind count model with constants `hi`, `lo`, `c`, `p` and no noise. The noise bound (Kandori, Mailath and Rob; Young) is cited, not proved.
- That actual rules read the share, or are pools of readers drawn by kind, is a premise. The one test of it, LA2, found the judge not a pool counted by kind: one note in nine turned it.
- The two AJ conditions are not shown independent. Of their four combinations, three occur; control left unselected with a lock left in time is not shown.
- The records state that "the calibration to the present world is not established".

Evidence: theories/becoming/chapters/02-MAP.md:388 (Definition 元吸引子); theories/becoming/chapters/02-MAP.md §9 #r-capture-through-the-rule (RuleCapture.favouring_locks), #r-closed-capture (ClosedCapture.lock_outlives_loss, turned_by_loss), #r-readers-drawn-from-the-selected (Thinned.kept_iff), #r-shaping-the-rule-selected-by-what-comes-back (RuleShaping.favours_iff, stretch_iff, nothing_back_falls), #r-shaping-read-by-readers-drawn-from-the-selected (DrawnShaping.critical_mass_iff, drawn_locked_either), #r-loss-read-in-time-by-the-others (ReadInTime.deadline, at_most_one_between); experiments/.../lean/becoming/Becoming/DrawnShaping.lean:374 (drawn_locked_either); ReadInTime.lean:631 (deadline); ClosedCapture.lean:307 (lock_outlives_loss); theories/becoming/chapters/02-MAP.md §9 T7 frozen test LA2: 'the conjecture failed for this judge. One note of the loss, on the one prose answer among nine readers, turned its reading'; theories/becoming/chapters/02-MAP.md §9 reading D65: 'whether a capture loop is 生成 at some pair of classes stays Open'; theories/meta-attractor/GENERATIVE-REGIMES.md lines 5-9 (Ren-selected cross-carrier definition); theories/becoming/chapters/05-COLLECTIVES.md §1 #r-own-count-misses-joint-excess, §3 #r-relative-position-is-zero-sum, §7 #r-what-an-optimum-does-beyond-what-couples-in, #r-several-optimizers-drain-by-their-joint-capacity, #r-a-race-for-position-draws-everything, §8 #r-what-pooled-coupling-reaches, #r-a-pool-that-recruits-through-itself; theories/becoming/chapters/07-SIGNIFICANCE.md §6 'Of the four ways the two conditions can combine, three occur in these models'; readings D68; theories/becoming/chapters/07-SIGNIFICANCE.md §4.5 #r-reach-through-a-shared-condition, #r-the-class-of-being-joined; _process/research/.../development/aj-joint-selection/PLAN.md §1-§2; _process/research/.../development/pw-step-forward/NOTE.md §6f (steps 4 and 5 rest on witnesses; general form is the formal gap)

### (2) Can we, with the theory plus enough observable situationality, ALWAYS make sure, at least directionally, that the world moves toward generation, escapes zero-sum competition and keeps the future open? Separate theorem / impossibility / premise / empirical; distinguish always guaranteed, always available as a direction, achievable under conditions; say what 'enough situationality' means.
(a) THEOREMS, WITH THEIR HYPOTHESES, THAT SUPPORT A DIRECTION:
- Direction as unanimity: one course widens another exactly when every positive weighting ranks it higher (`Weighting.widens_iff_every_positive`; any type, finite listing, two-valued admission). A mixed comparison is decided both ways (`Weighting.mixed_either_way`).
- A local test: a part's widening of its own options widens the whole exactly when its net draw stays within the margin of every formation outside its region (`Flow.Balances.widens_iff_others_within`; World, balance, part and region decided). The result is mixed exactly when the draw goes beyond the margin of one such formation.
- No C needed: under the coupled gate, every order increasing in a standpoint's own continuation ranks a course ending the coupled cohorts below one that continues them (`Flow.coupled_ending_ranked_below`). Where the other course keeps an independent copy, some such order reverses (`some_increasingInOwn_reverses`).
- Under the condition, C, J1/J2 and correspondence E: a move whose outcome another's widens is not chosen where it is decided (`Direction.narrowed_not_chosen`). Widening beyond the acting group's coupling closure is selected only through the pooled coupling of a group holding the formation beyond, and by no group within the closure (`Direction.widening_selected_by_pool`).
- Conditional exits: `ClosedCapture.turned_by_loss`, `ReadInTime.turned_early_iff`, `RuleShaping.nothing_back_falls`, `Flow.Balances.kept_of_restrained`, `Flow.restores` (joint net giving restores a level within `m − level` steps), `Optimum.frontier_keeps_stepwise`, `Tolerance.restores_iff`.

(b) WHAT THE THEORY'S OWN LAWS SHOW CANNOT BE GUARANTEED:
- A selection reaches exactly what couples into its selector (`Web.selects_alike_iff`). An act whose difference stays beyond the actor's closure is selected by no member (`Flow.act_unselected`). Pools are blind beyond the union of their members' closures (`Flow.act_unselected_pool`).
- A break is not bounded through threshold coupling (`Web.break_not_bounded`, `Flow.policy_uses_after_failure`; T6). Early warning reads a condition's own end, never a dependent's need (`SlowingDown.need_not_read`, periphery).
- Every reading fixed by `h` steps that includes every renewing run includes a consuming one (`Renewable.finite_reading_includes_consumption`). Eventual widening is neither verifiable nor refutable (`Web.eventually_neither`).
- Points of no return are exact (`RegimeMargin.ends_iff_below`). Harms are superadditive: two draws each tolerable alone can end a condition together (`harms_superadditive`). The read-in-time window closes (`ReadInTime.kept_once_favoured`, `deadline`).
- Critical mass: without noise the start decides (`DrawnShaping.drawn_rises`/`drawn_falls`). A reading of the share alone never leaves the lock (`drawn_locked_either`).
- Where the rest outruns the renewal, every score reading the condition only from the rest's end scores the member's acts alike (`Flow.outrun_reading_alike`). A reward with such a term settles where it would without it (`Training.outrun_settles_iff`). Restraint is no mutual best response (`Optimum.MutualBest.full`).
- With memory, one withholding absorbs all giving (`Withholding.withholding_absorbs`). Promises alone start nothing (`reciprocal_eventual_promises_can_be_empty`, periphery).
- A finite balanced world under the first law has no course that keeps widening (`Flow.whole_not_keepsWidening`). Keeping widening needs throughput from beyond (`KeepsWidening.from_rest_or_open`).
- No satisfiable statement reading only the dynamics entails the condition (`ReadsOnlyDynamics.not_entails`, SD1).
- Settling, deciding whether a run changes again, is LPO (`LastChange.lpo_iff_settles`). Where it is open whether one move betters another, choosing needs weak excluded middle (`exists_undominated_iff_weakly`).
- Periphery, older: a passive history cannot tell two return routes apart, and a probe may consume what recovery needs (GENERATIVE-REGIMES §Recognizing approach; §Diagnosis).

(c) WHAT NEEDS THE ETHICS' TWO PREMISES:
- Calling a generative or widening course better is C's (02 'What this chapter does not show': 'order needs C').
- Counting losses that return to no one, including future beings outside one's own line, needs the continuation condition through the step of invariance. PW's route reaches successors in one's own line, and members fed by conditions one affects, without the step, but at witness level.
- Mixed comparisons are left unranked by both premises; a measure for mixed parts is open. Expansion that ends forms of life is the hard case: 07 §9 verdict 'the order left open'.
- J1–J4 and correspondence E are further practical premises.

(d) WHAT IS EMPIRICAL:
- Whether actual rules read the share, or readers are drawn by kind (LA2: not for that judge).
- Whether trained systems drain near their optimum (T3: supported on the locked side for Claude Haiku in context, LA1b/LA1c; tabular learners do not approach the optimum).
- Whether scope installs (T4: one model of two). Whether valuers rank kept sets (VD1 failed; VD2 partial; role-play only).
- Whether margins time breaks (fish stocks: they rank risk, not timing; 47 of 149).
- Whether humans lie within one another's feeding closures (D64). Whether the actual net is joined.
- The meta-attractor's calibration to the present world.

THREE SENSES:
- 'Always guaranteed': refuted by the laws in (b).
- 'Always available as a direction': true only as a criterion. Widening is always definable and unanimously agreed where it applies, but it is silent on mixed cases. Its recognition requires pooled coupling of what is widened. A widening move need not exist past a point of no return, after a window closes, where the rest outruns the renewal, or in a closed finite world.
- 'Achievable under stated conditions': yes, for many specific exits listed in (a).

'ENOUGH SITUATIONALITY', IN THE THEORY'S TERMS, MEANS ALL OF:
1. Coupling: the drawn level and the dependent's need both couple into the selecting pool, by level, not threshold (T6; 05 §8).
2. Responsive reach: the pool's members respond. 'Coupling is not compliance' (07, 'What this chapter does not show'), and a difference beyond responsive reach neither opens nor closes (`Flow.stays_beyond_response`).
3. In time: before the regime's point of no return, and before the share passes the step from which the late reading favours the shapers.
4. Resolution: the feedback separates the differences (the LA1 vs LA1b lesson).
5. Pace: a rule with at most `N` states is fixed by a reading stretch of at least `2N − 1` (`Pace.pace_law`).
6. Structure: the rest does not outrun the renewal. If it does, observation by one member changes nothing selected, and only a change of the rest's exchange helps.

So observation is necessary, not sufficient. This matches Ren's own 16 October clarification ('the situation makes it true') and his 2026-06-04 line quoted in keep-open: 'I don't think there are ways to absolutely ensure any system not collapse'. Both are provenance, not warrant.

Evidence: theories/becoming/chapters/07-SIGNIFICANCE.md §4.4 #r-widening-as-what-every-weighting-ranks (Weighting.widens_iff_every_positive, Weighting.mixed_either_way); #r-what-self-concern-alone-ranks (Flow.coupled_ending_ranked_below); theories/becoming/chapters/07-SIGNIFICANCE.md §6 #r-own-widening-within-the-margin (Flow.Balances.widens_iff_others_within); §7 #r-alignment-direction-under-widening (Direction.narrowed_not_chosen, Direction.widening_selected_by_pool); §7 'Necessary, not sufficient'; experiments/.../Becoming/Direction.lean:30-40,156 (widening_selected_by_pool doc and statement); theories/becoming/chapters/03-KNOWING.md §1 #r-selection-through-couplings; §10 #break-seen-coming, T6 (Web.break_not_bounded); theories/becoming/chapters/02-MAP.md §3.1 #r-becoming-finite-horizon (Renewable.finite_reading_includes_consumption); §5 #r-margin-of-a-regime (RegimeMargin.ends_iff_below, harms_superadditive); §7 #r-runaway-distance-uncoupled; theories/becoming/chapters/07-SIGNIFICANCE.md §2 #r-eventual-widening (Web.eventually_neither); #r-what-keeping-widening-needs (Flow.whole_not_keepsWidening; KeepingWidening.lean:245); theories/becoming/chapters/05-COLLECTIVES.md §1 #r-the-rest-outruns-the-renewal (Flow.outrun_reading_alike); 07 §6 #r-what-training-installs (Training.outrun_settles_iff); theories/becoming/chapters/07-SIGNIFICANCE.md §1 #r-what-the-dynamics-leave-open (ReadsOnlyDynamics.not_entails); theories/becoming/chapters/08-METHOD.md §5 #r-the-last-change-of-a-run (LastChange.lpo_iff_settles); calibration table row 'Weak excluded middle'; theories/becoming/chapters/07-SIGNIFICANCE.md:652-653 ('Seeing is not valuing', 'Coupling is not compliance'); §9 objections row on expansion; theories/becoming/chapters/02-MAP.md §8 #r-how-fast-a-rule-may-change (Pace.pace_law); §7 #r-where-two-courses-rejoin (Flow.stays_beyond_response); theories/meta-attractor/GENERATIVE-REGIMES.md §Recognizing approach and entrenchment; §Diagnosis is activity within the regime; sources/15-codex-theory-conversations/2026-10-16-the-situation-makes-it-true.md; theories/keep-the-possibility-space-open/README.md:113 (Ren 2026-06-04 quote); theories/becoming/chapters/05-COLLECTIVES.md §7 T3 evidence (LA1, LA1b, LA1c, CG1, CG2); 07 §8 T4, T5 evidence; 02 §5 assessment (§277: 47 of 149)

### (3) Does the relational start dissolve zero-sum framing; which results show non-zero-sum structure vs real conflicts that remain?
The relational start dissolves the FRAME (a fixed sum divided among independent owners of value). It does not dissolve real rivalry.

RESULTS SHOWING NON-ZERO-SUM STRUCTURE:
- Joint consumption has no single consumer. In an overdetermined loss no single part makes the difference, while parts make it together (`Dependence.differenceOnlyTogether_iff`, `Pool.difference_belongs_to_the_joint`). Responsibility is not divided among owners.
- Each can take within what is given while together they take more (`Pair.own_not_joint`). Joint excess ends every gated dependent, takers included (`Flow.joint_excess_ends`). Groups on one coupled family end together, nothing selected among them (`GroupEnding.Flow.coupled_end_together`): a shared fate, not a distribution.
- Positive sum is possible: drawing jointly within what is given keeps the level (`Flow.level_kept`). Exclusive-footprint joint plans keep it at every step (`Flow.level_kept_of_plans`). One drawer's restraint within the joint slack keeps a third party's need met (`Flow.Balances.kept_of_restrained`).
- Cooperation has exact conditions: giving that waits on giving, tolerance, giving first (05 §5). Hamilton's rule among groups (`SelectionLevels.among_for_iff`).
- Widening is Pareto unanimity (`Weighting.widens_iff_every_positive`). Own widening widens the whole exactly within others' margins (`widens_iff_others_within`). Self-concern alone ranks a coupled ending below, with no C (`Flow.coupled_ending_ranked_below`).
- Harms are superadditive (`RegimeMargin.harms_superadditive`): joint damage can be negative-sum beyond the parts.

REAL CONFLICTS THAT REMAIN (stated as theorems):
- Positions sum to zero by counting alone. No change raises every part's position, and a rise needs another's fall (`RelativePosition.change_balances`, `rise_needs_fall`). 'Above all others' never rests for two (`Law.aboveAll_never_rests`). A best response for position keeps nothing (`Optimum.InTurn.position_keeps_nothing`).
- Conserved draws fit together only when their total fits (`every_event_within_iff`, `entries_within_not_together`).
- Several optimizers drain as one, and restraint is no mutual best response (`Optimum.MutualBest.full`). Where the rest outruns, no reweighting selects restraint.
- A swap-symmetric predicate cannot single out one contributor (`symmetric_assignment_not_unique`, periphery with empty reports). Agreement on a code from symmetry needs a symmetry breaker (`SharedCodes.majority_held`, `impose_privileges_forms`). So who restrains, or gives first, needs an actual asymmetry or a procedure.
- Mixed comparisons (a gain here, a loss there) are unranked by C. 07 §3.4: 'Under the condition every narrowing loses something with significance.' Gross partiality is left unranked where numbers differ (07 §9).
- That a race for position produces joint excess is 'a premise here, not derived' (05:59). So the negative-sum character of positional races is conditional.

NET: the theory converts 'who wins more' into 'does the joint draw stay within renewal and within others' margins'. It is right that this removes the frame Ren objected to (source 2026-10-08, 'common problem solving'). Positional goods remain genuinely zero-sum, and conserved stocks genuinely rivalrous. The relational move changes which question is asked; it does not make rivalry vanish. The older periphery work in COLLECTIVE-DESTRUCTIVE-ATTRACTORS still uses separate payoffs `U_i = b a_i − h Σ a_j − q a_i`, kept as conditional local results after Ren's correction.

Evidence: theories/becoming/chapters/05-COLLECTIVES.md §1 #r-joint-difference-making, #r-own-count-misses-joint-excess, #r-what-taking-all-excludes, #r-draws-on-a-shared-stock, #r-division-by-exclusive-footprints; theories/becoming/chapters/05-COLLECTIVES.md §3 #r-relative-position-is-zero-sum (RelativePosition.change_balances, rise_needs_fall); line 59 'That a race for position produces joint excess is a premise here, not derived'; theories/becoming/chapters/05-COLLECTIVES.md §6 #r-what-a-rise-draws-from-beyond (Flow.Balances.kept_of_restrained, broken_shared); §7 #r-a-race-for-position-draws-everything; #r-several-optimizers-drain-by-their-joint-capacity; theories/becoming/chapters/05-COLLECTIVES.md §9 #r-a-swap-symmetric-assignment-singles-out-none, #r-taking-what-most-hold; theories/becoming/chapters/04-LIFE.md §groups #r-groups-whose-conditions-are-coupled, #r-selection-with-returns-to-groupmates; theories/becoming/chapters/03-KNOWING.md #r-seeking-boundary (Law.aboveAll_never_rests); theories/becoming/chapters/07-SIGNIFICANCE.md §3.4 #does-not-settle; §9 objections table (partiality, expansion); sources/15-codex-theory-conversations/2026-10-08-collective-destructive-attractors.md §Common problem solving and awareness; theories/meta-attractor/COLLECTIVE-DESTRUCTIVE-ATTRACTORS.md §An incentive condition for collective loss

### (4) What actionable guidance follows for human institutions now, and what is missing?
GUIDANCE THAT FOLLOWS FROM PROVED LAWS. Each item is a check that follows from a pure-core theorem under its stated hypotheses; reading it onto real institutions is AI reading D45/D48/D65/D68.
1. Ask whether a rule is read from the share it selects (`ReadsShare`). If it is, a reform that changes only the rule's value is absorbed; a change in how it reads, or a reader of what lies beyond the share, is needed (`RuleCapture.favouring_locks`, `ClosedCapture.turned_by_loss`).
2. Ask who reads the loss, and when. A loss read only by those the rule disfavours keeps the lock once the carriers are at least as many when it is read (`Thinned.kept_iff`). The window closes, and a deadline bounds it (`ReadInTime.deadline`). Practical form: put readers of losses in place who are not drawn from the selected, and read early.
3. Count what rule-shaping returns to the shapers alone against its cost (`RuleShaping.favours_iff`). Lowering the cost of shaping, for example with AI assistance to lobbyists, raises selection for control (`lower_c_raises`; D68). Shared returns pull toward even but can turn the verdict across a stretch.
4. An obedient assistant adds capacity, not coupling; joint optimizers drain as one (`Optimum.mutual_beyond`; D68).
5. Bringing dependents into what selectors read is necessary. Where the rest outruns the renewal, reweighting a later reading changes nothing (`Flow.outrun_reading_alike`): rules on everyone's take are needed, such as exclusive-footprint divisions (`Flow.level_kept_of_plans`).
6. Reward keeping per period with a coupling `c` large enough (`r ≤ q + c`, `e < c`) and every optimum keeps at every horizon. A one-off terminal valuation does not keep (`Optimum.frontier_keeps_stepwise`, `valuing-what-is-left` rows). Discounting faster than renewal makes ending the stock optimal (`Optimum.frontier_exhausts`).
7. Read the joint draw against the regime's point of no return, not each party's own draw (T1). Expect margins to rank risk but not time breaks (§277).
8. Count reviewers by independent causes, and recompute fault envelopes after mergers (`Reconfiguration.stale_envelope_accepts_shared`).
9. Cooperation needs someone giving first, and a reserve to start from. Tolerance survives scattered withholding but does not rebuild total withholding (`Tolerance.total_stays`, `ignition_requires_actual_reserve`).
10. A slow rule level must read the fast one at stretches of at least `2N − 1` (`Pace.pace_law`).

WHAT IS MISSING:
- No institution model. GS3 dropped the institution and organism models as laws. An institution kept by consent or by penalty is only the thermostat witness renamed (01 §8.7, D69). The one page says the institution test system has 'no models yet'.
- No frozen field test of T7 on reform events: 'Evidence: none frozen; a test needs a coding of reform events fixed before the cases are read' (02 §9 T7).
- No test on human valuers or human institutions. All tests are LLM role-play or toy learners.
- How pools form, last and resist capture is open. So is 'a pool whose rule and members are both formed through what it reads' (05 Open; 07 Open 'Installation').
- The constructive mechanisms of the keep-open corpus are not on the spine: exit plus free association flipping the selection's sign, the non-capturable abundance floor, plurality as decorrelation, many measures of worth.
- No noise and no real amounts in the capture laws, and mutual best responses are not shown to exist.
- Market laws are periphery models. 'No universal phase threshold is claimed, and no market law ranks arrangements' (05 §10). Enshittification is open.
- Under DF3 batch B (in flight, record schema migrations), none of this changes.

Evidence: theories/becoming/chapters/05-COLLECTIVES.md §4 constraint table and readings D48 (term limits, audits, courts read as pooling); theories/becoming/chapters/07-SIGNIFICANCE.md §6 readings D68 (assistance, obedience, counter-rule, shared rule-making); theories/becoming/chapters/05-COLLECTIVES.md §7 cases table #r-a-step-coupling-keeps-at-every-horizon, #r-a-weighting-faster-than-renewal-ends-the-base, #r-valuing-what-is-left-at-the-horizon; theories/becoming/chapters/02-MAP.md §5 T1 and assessment (§277); §8 #r-how-fast-a-rule-may-change; theories/becoming/chapters/05-COLLECTIVES.md §9 #r-reviewers-count-by-independent-causes; §5 #r-thresholds-of-waiting; §11 #r-joint-plans-from-a-supported-start; theories/becoming/chapters/01-ROOT.md §8.7 (#r-the-source-texts-test-systems; reading D69); git 04d49b8e6 message ('the institution and organism models dropped as laws'); theories/becoming/ONE-PAGE.md 'What is not yet done' (test systems 'have no models yet'); theories/becoming/chapters/02-MAP.md §9 T7 'Evidence: none frozen'; theories/becoming/chapters/05-COLLECTIVES.md 'Open' and 'What this chapter does not show'; §10 last paragraph; theories/keep-the-possibility-space-open/README.md §What keeping-open requires (exit, abundance floor, plurality)

## Strengths
- [proved-core] The meta-attractor's lock and its second order (selection of control over the selection) are stated with exact conditions and counterexamples in the pure core. That includes the critical mass where lo < c < hi and the result that every course read from the share alone is locked one way or the other. — experiments/.../Becoming/DrawnShaping.lean:374 drawn_locked_either; theories/becoming/chapters/02-MAP.md §9 #r-shaping-read-by-readers-drawn-from-the-selected (DrawnShaping.critical_mass_iff)
- [proved-core] The exit has a theorem form with a closing window. A reading of what lies beyond the share turns the course exactly while the late reading still favours the others one step on; after that every reading keeps the lock, with at most one step between and a deadline. This makes 'read in time' exact in the model, which is Collingridge's second horn as a theorem. — experiments/.../Becoming/ReadInTime.lean:631 deadline; at_most_one_between; kept_once_favoured; theories/becoming/chapters/02-MAP.md §9 #r-loss-read-in-time-by-the-others
- [proved-core] The account proves its own limits instead of hiding them: selection blind beyond coupling, break distance not coupled in, finite readings unable to certify renewal, eventual widening neither verifiable nor refutable, the rest outrunning so that no reweighting selects restraint, no keeping-widening course in a finite balanced world, the dynamics not entailing the condition, and settling equivalent to LPO. — Runaway.lean break_not_bounded; Horizon.lean finite_reading_includes_consumption; EventualWideningInstances.lean eventually_neither; Exclusion.lean:174 outrun_reading_alike; KeepingWidening.lean:245 whole_not_keepsWidening; Significance.lean not_entails; LastChange.lean lpo_iff_settles
- [proved-core] The direction is a criterion, not a quantity: widening is exactly what every positive weighting ranks higher (Sen's intersection, Pareto unanimity). So no share-read proxy can stand in for it, and mixed cases are honestly left unranked. — theories/becoming/chapters/07-SIGNIFICANCE.md §4.4 Weighting.widens_iff_every_positive, Weighting.mixed_either_way; _process/research/.../aj-joint-selection/PLAN.md §2 'A criterion, not a target'
- [argued] Scope and order are kept apart everywhere the ethics is used for collectives. The chapters, the AJ plan and the dossier name both premises (the continuation condition for scope, C for order) and assert neither. The self-concern-only ranking of coupled ending (no C) is separated out as a premise-free part. — theories/becoming/chapters/07-SIGNIFICANCE.md §4 table; §4.4 Flow.coupled_ending_ranked_below; theories/becoming/chapters/05-COLLECTIVES.md line 9 'No law here evaluates'
- [proved-core] Positive-sum structure has exact local tests: a part's own widening widens the whole exactly when its net draw stays within others' margins, and one drawer's restraint within the joint slack keeps a third party's need met. — theories/becoming/chapters/07-SIGNIFICANCE.md §6 #r-own-widening-within-the-margin (OwnWidening.lean widens_iff_others_within); theories/becoming/chapters/05-COLLECTIVES.md §6 (JointDraw.lean kept_of_restrained, broken_shared)
- [empirical] Failures are reported first and tests are frozen. LA2's bridge failed (the judge was not a pool counted by kind), LA3 failed two of four contrasts, and LA1 failed on its locked side before the resolved follow-ups LA1b and LA1c passed. — theories/becoming/chapters/02-MAP.md §9 T7 frozen test; theories/becoming/chapters/07-SIGNIFICANCE.md §6 Tests paragraph; theories/becoming/chapters/05-COLLECTIVES.md §7 T3 evidence
- [known-result-restated] The capture literature is credited rather than presented as new: the stag hunt and its mixed equilibrium, Schelling/Granovetter thresholds, Arthur lock-in, Kandori-Mailath-Rob/Young risk dominance, Collingridge, Biggs-Carpenter-Brock. The records grade the results as elementary. — theories/becoming/chapters/02-MAP.md §9 readings D45; _process/research/.../aj-joint-selection/PLAN.md §4 steps 6-7 'Standing after the review: elementary'; theories/becoming/ONE-PAGE.md 'None of the central results is new mathematics'

## Gaps
- [high/missing-test] The readers premise behind the timing exit (MA2/MA4b) is unmet in the only test. The premise is that actual rules are pools of readers drawn from those they select, counted by kind, each kind favouring its own. LA2's judge was not such a pool: one note in nine turned it. So 'read in time' is not yet shown to apply to any actual system. — theories/becoming/chapters/02-MAP.md §9 T7 frozen test (LA2); _process/research/.../aj-joint-selection/PLAN.md §6 'MA2's premise is not met'
- [high/structural] Mixed comparisons are unranked by C. These are exactly the hard cases of 'generative direction': expansion that ends forms of life, partiality, predation. So 'always available as a direction' fails where it matters most. A measure for mixed parts is open. — theories/becoming/chapters/07-SIGNIFICANCE.md §4.4 Weighting.mixed_either_way; §3.4; §9 'the order left open'
- [high/missing-model] There are no institution models and no frozen field test of reform events. GS3 dropped the institution model as a law, the one page lists the institution test system as having no model, and T7 states 'Evidence: none frozen'. Guidance for human institutions is therefore readings, not tested laws. — theories/becoming/chapters/01-ROOT.md §8.7 reading D69; theories/becoming/ONE-PAGE.md 'What is not yet done'; theories/becoming/chapters/02-MAP.md §9 T7
- [high/missing-model] How pools form, last and resist capture is open. That is the formal core of 'a collective of consciousness'. Resisting a capture that hides a loss needs a member admitted by what the pool does not yet read, and that is not modelled. — theories/becoming/chapters/05-COLLECTIVES.md Open (first item); 07 Open 'Installation'
- [medium/overclaim] The capture and shaping laws are two-kind count models with constant returns and no noise. The noise result (risk dominance) is cited, not proved. The two AJ conditions are not shown independent: the fourth combination is not shown. — theories/becoming/chapters/02-MAP.md §9 #r-shaping-read-by-readers-drawn-from-the-selected ('the courses are without noise'); theories/becoming/chapters/07-SIGNIFICANCE.md §6 'keeping control from being selected and leaving a lock in time are not shown to be independent'
- [medium/structural] There are two meta-attractor definitions. The formal one (02 §9: rule and reading formed from the share) is narrower than the cross-carrier recurrent organization Ren selected on 8 October. The wider one is not on the spine, and 'whether a capture loop is 生成' is Open. — theories/becoming/chapters/02-MAP.md:388 and §9 reading D65; theories/meta-attractor/GENERATIVE-REGIMES.md lines 5-9
- [medium/missing-model] The keep-open corpus's constructive mechanisms are not formalized on the spine: exit plus free association as a sign-flipped selection, a non-capturable abundance floor, plurality as decorrelation, many measures of worth. Only independent-cause reviewers (Reconfiguration) touches decorrelation. — theories/keep-the-possibility-space-open/README.md §What keeping-open requires; grep of chapters 02/03/05/07: 'exit' appears only as 'blocked exit' in 07 §3.3 reading D65
- [medium/structural] The second-order direction of 生生 (a range whose widening keeps widening, against one merely wider now) is open. 'Keep the future open' in the strong sense has only a negative law: a finite balanced world has no keeping-widening course. — theories/becoming/chapters/07-SIGNIFICANCE.md Open 'The second-order direction'; §2 #r-what-keeping-widening-needs
- [medium/missing-model] Reaching future beings without the step of invariance (PW/GS4/GS5) rests on witnesses. The general forms of steps 4 and 5 are 'the path's formal gap'. Future beings in no one's line still need the step. — _process/research/.../pw-step-forward/NOTE.md §6f
- [medium/missing-test] The empirical base is narrow: one model (Claude Haiku) choosing in context, tabular or generalizing learners in toy commons, and LLM role-play valuers. No human or institutional test. The meta-attractor's calibration to the present world is 'not established'. — theories/becoming/chapters/05-COLLECTIVES.md §7 T3 evidence; theories/becoming/chapters/07-SIGNIFICANCE.md §8 T5 evidence ('The judgments are role-play; human valuers are untested'); theories/meta-attractor/README.md lines 3-9
- [medium/missing-model] Existence of mutual best responses is not shown, nor which self-consistent outcome learners reach. Exploration is not modelled; the LA1c open misses turned on it. — theories/becoming/chapters/05-COLLECTIVES.md 'What this chapter does not show'; §7 T3 LA1c
- [low/structural/in-flight] The collective laws are on the World, counts or types, not on the grammar. WRT2 (in flight) represents the World in the grammar 'both ways, its amounts not', so joint excess, margins and points of no return, which depend on natural-number amounts, will still not be grammar laws after it lands. OU3f (in flight) addresses laws reading only activity. — theories/becoming/chapters/05-COLLECTIVES.md 'What this chapter does not show' (last item); _process/research/.../development/world-representation/DESIGN.md lines 32-42, 113
- [low/overclaim] That a race for position produces joint excess is a premise. So the negative-sum character of positional races is conditional, not derived. — theories/becoming/chapters/05-COLLECTIVES.md:59
- [low/readability] Minor readability inconsistency: the one page says the test systems 'have no models yet', while 01 §8.7 gives small witnesses for decay and a system with no clear boundary. The distinction between a 'model' and a 'small witness' is not stated on the one page. — theories/becoming/ONE-PAGE.md 'What is not yet done'; theories/becoming/chapters/01-ROOT.md:337
- [low/readability] The older meta-attractor line (COLLECTIVE-DESTRUCTIVE-ATTRACTORS, COMMON-ORGANIZATION, GENERATIVE-REGIMES) holds periphery results in separate-payoff and market vocabulary that Ren rejected as a default frame. Their reconciliation to the spine's capture laws is partial, which leaves two vocabularies for one phenomenon. — theories/meta-attractor/COLLECTIVE-DESTRUCTIVE-ATTRACTORS.md 'Current methodological correction'; theories/meta-attractor/README.md lines 11-17

## Load-bearing claims
- With lo ≤ hi, every course whose rule is read from the share alone is locked one way or the other at every step, so leaving the lock needs a reading beyond the share. (check: experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/DrawnShaping.lean:374 theorem drawn_locked_either; confirm the module imports only Becoming modules and check_becoming.py's axiom report for it is empty.)
- From a start strictly favouring the shapers, a reading of the stated form at any step from g.other · c · x.other on keeps the lock (the window closes by a deadline). (check: ReadInTime.lean:631 theorem deadline: hypotheses step, readers, some, strict, late, at_N; conclusion Locked … at N + (1 + k).)
- Where the rest alone outruns the renewal, every score reading the condition only from the rest's end on scores the member's acts alike, so no weighting selects restraint. (check: Exclusion.lean:174 theorem outrun_reading_alike (hypotheses: balances, acting, dependent, gated, outruns); 05-COLLECTIVES.md §1 #r-the-rest-outruns-the-renewal; Training.lean outrun_settles_iff.)
- Widening is exactly what every positive weighting ranks higher, and mixed comparisons are decided both ways, so C is silent on mixed cases. (check: Weightings.lean Weighting.widens_iff_every_positive and Weighting.mixed_either_way; 07-SIGNIFICANCE.md §4.4 table.)
- A finite balanced world (gainless, every condition listed, requirements within the list) has no course that keeps widening by name on the actual levels. (check: KeepingWidening.lean:245 theorem whole_not_keepsWidening; 07-SIGNIFICANCE.md §2 #r-what-keeping-widening-needs.)
- Without C, under the coupled gate with uptake above replenishment, every order increasing in a standpoint's own continuation ranks the coupled ending below a course that continues it. Where the other course keeps an independent copy, some such order reverses. (check: Weightings.lean Flow.coupled_ending_ranked_below and Weighting.some_increasingInOwn_reverses; 07-SIGNIFICANCE.md §4.4 #r-what-self-concern-alone-ranks.)

## Recommendations
- P1 Write one page for the collective question in the account's terms: what is a theorem (with hypotheses), what the laws show cannot be guaranteed, what needs the continuation condition or C, and what is empirical. Use the three senses (guaranteed, available as a direction, achievable under conditions) and the six-part meaning of 'enough situationality'. — serves shared understanding with human readers; alignment researchers (AJ4); The material exists but is scattered across 02 §9, 03 §10, 05, 07 §2/§4/§6/§7 and 08 §5. Without it, readers will take the toy-model exits as guarantees.
- P2 Freeze a test of the readers premise on actual rules: are the readers of a rule drawn from those it selects, and does each kind read for its own? Also freeze T7's field test of reform events, with coding fixed before reading. — serves tests on trained systems; the timing exit's applicability; MA2/MA4b's read-in-time exit is the theory's main escape route, and its one test (LA2) found the premise unmet.
- P3 Model one institution test system on the spine, for example an audit or court whose readers are not drawn from the selected, with a reading schedule and a cost of rule-shaping. State what it adds beyond the thermostat witness. — serves a real test system (GS3); guidance for human institutions; Institution guidance is presently readings only; GS3 dropped the institution model.
- P3 Test human valuers and human groups (VT1; a commons with human participants) rather than only LLM role-play. — serves empirical correspondence; Every test of T3, T4, T5 and T7 to date uses one LLM or toy learners.
- P4 State candidate mechanisms from keep-the-possibility-space-open as conjectures with forbids-lists: whether affordable exit makes a rule read against the share, and whether a non-capturable floor lowers what rule-shaping returns to shapers alone. — serves alignment of the joint selection; escape from the meta-attractor; The corpus's highest-rated constructive mechanisms are absent from the spine, though the capture laws give them a precise test.
- P5 Either state the cross-carrier meta-attractor on the spine (a capture loop read at two grains) or explicitly scope the formal 元吸引子 as the narrower case in the meta-attractor README. — serves shared understanding; one vocabulary; Two definitions coexist; readers will conflate them.

## Not read
Chapters 01, 03, 04, 06 and 08: only targeted ranges (01 §8.7; 03 §1, §5, the seeking boundary and §10; 04 groups; 08 §5 calibrations). 07: §4.6 (the future without the step) and most of §5 (practical judgment) not read in full. Meta-attractor README: only its intro, 'Why it is not fated' and 'The exit' (a small part of 372 KB). COMMON-ORGANIZATION.md: headings only. GENERATIVE-REGIMES.md: opening and two sections. META-ATTRACTOR-RECONCILIATION.md: headings only. keep-the-possibility-space-open README: intro and requirements only. COLLECTIVE-DESTRUCTIVE-ATTRACTORS.md: opening through 'An incentive condition' only. GS4/GS5/GS6: their kit scripts were not read; their results were read through 07 §4.5 and the PW note. Records files: not read individually. Lean proofs: not read beyond the statements of a handful of declarations, though about 50 declaration names were checked to exist. ALIGNMENT review dossier and the AJ4 draft one page: headings only. Experiment READMEs (LA1–LA3, CG, IN1, VD): not read, only the chapters' summaries. THEORY-GRAPH and the completion measure: not read. WRT2/OU3f/DF3 work: in flight, only DESIGN.md lines on amounts skimmed. No Lean was built and no checker was run.
