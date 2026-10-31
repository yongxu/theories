# Independent review of U4's boundary record `one-root-to-its-edge`

An AI-written independent review, 31 October 2026, of commit `21f06c7af` on branch `u4-edge` (the request named it `a21f06c7a`). The branch tip has since moved to `403f78887`, which adds only `integrate_u4.py`. That script writes the record and the home section through `make_record_u4.py`, so nothing below changes with it.

**What was read.**
- The record as HE2 will leave it (`record-draft-after-he2.json`), its generator (`make_record_u4.py`), the home section (`home-08-section7-after-he2.txt`), the names list (`review-names-after-he2.txt`) and `integrate_u4.py`.
- `Becoming/RootForms.lean` in full.
- The source of every row and every lemma the record names. Lean paths below are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.
- MV's [BOUNDARY-FIELD.md](../../../../2026-10-05-repository-reconciliation/architecture/mv/BOUNDARY-FIELD.md), `tools/research/boundary.py` (`Terms`, `derived`) and the dump's forwarder test (`THEOREM-CONNECTIVITY-DUMP.lean:63-98`).
- [DESIGN-BOUNDARY.md](DESIGN-BOUNDARY.md), [LEVER-2-AUDIT.md](LEVER-2-AUDIT.md) (§0, §1, §2, §4) and [CONNECTED-ROWS-READING.md](CONNECTED-ROWS-READING.md).
- HE2's items 2 to 4 kit on branch `he2-land` (`he2-items-2-to-4/KIT.md`, `he2_u4.py`, `tree/Becoming/HE2U4Laws.lean`).
- [07-SIGNIFICANCE.md](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md) (lead, §3, §4, §8, "What this chapter does not show", Open) and AGENTS.md.

**What was verified, and how.** Everything here was checked by reading source. One command was run: `U4_HE2=1 python3 -B make_record_u4.py --names`. Its output is byte-identical to `review-names-after-he2.txt`. Its counts are derived 10, under a stated hypothesis 1, counting 6, connected 22, balance in its statement 32, amounts 18, at a represented model 16, own carrier 7, at its model 3, free significance 3 and unplaced 0, which agree with the home section (118 in all).

**What could not be verified.**
- No Lean was built and no checker was run. HE2 has not landed on this branch.
- What D2 to D5 report for the two rows HE2 changes is predicted from the kit's proof text and the forwarder test's code, not observed on a dump.
- The renamed leaf has not been run through `boundary_check.lean`. Its content equals the boundary scratch that MV ran, apart from names and docstrings.

**Summary.** There are 22 findings: 1 major, 12 minor and 9 wording.
- The major finding: after HE2, `Flow.withinCoupling_reads_iff` declares too little support, so D2 and D3 fail and the landing gate stays shut (finding 1).
- Of the derived entries, eight hold as cases of their laws, and so does `Flow.mutuallyDependent_iff_reach`.
- The entry under a stated hypothesis holds. Its basis misstates what the row carries beyond the form (finding 2).
- Row 5's relational part and its failure of the discharge condition hold.
- Both premises pass Q1. Their bases are faithful to AGENTS, apart from the glosses and the citation (finding 9).

## Entries

### Flow.beyond_gives_nothing

`Flow.beyond_gives_nothing`, `«所闭之界»`, `eq_zero_of_not_pos`.

Holds, with finding 14.
- The proof (`Interdependence.lean:152-156`) is `eq_zero_of_not_pos` applied to `WithinClosure.not_rel within beyond ⟨…⟩`.
- `WithinClosure.not_rel` is a pure forwarder of `«所闭之界»` (`Frame.lean:127-129`), so the law is applied as the case, at the relation `FedFrom`.
- The anonymous constructor is `FedBy`'s unfolding (`Continuation.lean:1117`), so no bridge is needed.
- `eq_zero_of_not_pos` (`Flow.lean:109`) holds for every natural number.
- The basis has two inaccuracies of wording (finding 14).

### Flow.withinSystem_of_withinInfluence

`Flow.withinSystem_of_withinInfluence`, `«所闭之单调»`, `Flow.shares_of_affectedBy`, `WithinClosure.mono`.

Holds, with finding 10.
- The row (`Feedback.lean:224`) is `WithinClosure.mono` with `Flow.shares_of_affectedBy` (`Feedback.lean:215`) as the inclusion.
- `WithinClosure.mono` is `«所闭之单调» larger f g within` (`Frame.lean:117-119`), so the law is applied as the case.
- The inclusion is general: affecting implies sharing at every pair.
- In content, `WithinClosure.mono` is a forwarder. It is listed as support only because the dump does not recognize it as one (finding 10).

### Law.drawn_iff_not_returns

`Law.drawn_iff_not_returns`, `«定后有后则入当且仅当不返»`, `Branching.law_reach_iff`, `Branching.law_trace_iff`, `Law.absorbing_iff_closed`, `Law.drawn_iff_drawnIn`, `Law.reaches_iff_orbit`, `Law.returns_iff`, `Law.returns_iff_reaches`, `Branching.law_trace_of`, `Branching.units_length`, `Law.next_fixed`, `Law.next_total`, `Law.orbit_add`, `Law.orbit_shift`, `Law.reaches_of_orbit`.

Holds, with finding 15.
- The row (`Attraction.lean:191`) applies the law at the relation of the law's next configuration.
- Its hypotheses, a successor that is fixed and total, are met by `Law.next_fixed` and `Law.next_total` (`Recurrence.lean:571`, `:575`). Both hold for every law, so neither adds a hypothesis.
- Each bridge is an `Iff` between the model's notion and the grammar's (`Recurrence.lean:556-606`; `Attraction.lean:149`, `:155`), and none carries a hypothesis the row lacks.
- The orbit lemmas are arithmetic of steps and hold at every instance.
- `Law.absorbing_iff_closed` maps absorbing to a closed region `«闭»`, not to a closure (finding 15).

### Law.lossless_iff_returns

`Law.lossless_iff_returns`, `«有限遍后定后则定前当且仅当皆返»`, `Branching.law_reach_iff`, `Branching.law_trace_iff`, `Law.lossless_iff`, `Law.lossless_iff_fixedBefore`, `Law.reaches_iff_orbit`, `Law.returns_iff`, `Law.returns_iff_reaches`, `Branching.law_trace_of`, `Branching.units_length`, `Law.next_fixed`, `Law.next_total`, `Law.orbit_add`, `Law.orbit_shift`, `Law.reaches_of_orbit`.

Holds, with finding 16.
- The row (`Recurrence.lean:689`) is the law over the listed configurations.
- `Law.lossless_iff` and `Law.lossless_iff_fixedBefore` read lossless as a fixed predecessor.
- The other five bridges, and the support, are those that `Law.drawn_iff_not_returns` uses.
- The basis says the other bridges "are those of" that row. That row has seven bridges, so the five here are among them (finding 16).

### Learning.goAlike_iff_lumped

`Learning.goAlike_iff_lumped`, `«像定后当且仅当同行»`, `Learning.lumped_iff_fixed_image`, `goAlikeUnder_iff_alike`.

Holds.
- The row (`LearningRuns.lean:113`) applies the image law at the step taken along the projection.
- `goAlikeUnder_iff_alike` (`Laws.lean:119`) and `Learning.lumped_iff_fixed_image` (`LearningRuns.lean:101`) are unfoldings stated as `Iff`, and neither has a hypothesis.
- The basis is true.

### Tolerance.answers_restores_iff

`Tolerance.answers_restores_iff`, `«承之迭»`, `Tolerance.worst_start`, `Withholding.answers_closed`, `Withholding.chain_iff_steps`, `Tolerance.KeepsInclusion.course`, `Tolerance.KeepsInclusionInto.course`, `Tolerance.answers_keeps`, `Withholding.Chain.last`, `Withholding.Chain.last_of_eq`, `Withholding.Chain.zero_eq`.

Holds, with finding 17.
- The row (`Tolerance.lean:451`) applies `«承之迭»` at the relation up.
- `Withholding.answers_closed` (`Withholding.lean:251`) and `Withholding.chain_iff_steps` (`:163`) are equivalences.
- `Tolerance.worst_start` (`Tolerance.lean:249`) needs a step that keeps inclusion. `Tolerance.answers_keeps` (`:294`) meets that for every answering step, so the bridge adds no hypothesis the row lacks.
- The worst start does not "instantiate the law's start". It reduces every start to total withholding by keeping inclusion (finding 17).

### Withholding.withholding_spreads

`Withholding.withholding_spreads`, `«存承之迭»`, `Withholding.chain_iff_steps`, `Withholding.waitsAll_closed`, `Withholding.within_iff_withinSteps`, `Withholding.Chain.last`, `Withholding.Chain.last_of_eq`, `Withholding.Chain.zero_eq`.

Holds, with finding 18.
- The row (`Withholding.lean:216`) applies `«存承之迭»` at up.
- The three bridges are equivalences (`:163`, `:186`, and `within_iff_withinSteps`), and the support is the chain's own arithmetic.
- `Withholding.waitsAll_closed` meets the law's round by `Iff.rfl`. That is an unfolding, not "closed by definition" (finding 18).

### WithinMoves.after_course

`WithinMoves.after_course`, `«迭内之接»`, `trace_iff_steps`, `withinMoves_iff_withinSteps`, `trace_steps`.

Holds.
- The row (`Labelled.lean:936-965`) applies `«迭内之接»` at the moves' steps.
- `trace_iff_steps` and `withinMoves_iff_withinSteps` are equivalences, and `trace_steps` holds of every trace.
- The basis is true.

### Flow.mutuallyDependent_iff_reach

`Flow.mutuallyDependent_iff_reach`, `«所闭之逆»`.

Holds after HE2.
- The row (`MutualDependence.lean:111`) is proved through `WithinClosure.converse`.
- HE2 re-proves `WithinClosure.converse` as `«所闭之逆»` with no explicit argument (`he2_u4.py`, Response's proof). Every explicit argument is then a bound variable, so the dump's `forwardTarget` marks it a pure forwarder, and the walk counts it as the law.
- With no lemma declared, D2 and D4 pass and D3 is met through the forwarder. The statement names no balance anchor, so D5 passes.
- The basis is true: `WithinReach` is the closure of `Affects`, which is `AffectedBy` reversed (`Feedback.lean:199`).

### Flow.withinCoupling_reads_iff

`Flow.withinCoupling_reads_iff`, `«借步之所闭在二所闭»`, `«二所闭在借步之所闭»`, `Flow.withinCoupling_reads`, `WithinClosure.of_reads`, `Flow.CoupledFrom.of_reads`.

Finding 1.
- The forward half of the row (`SelectionPool.lean:600-608`) is a case of `«借步之所闭在二所闭»`. It goes through `Flow.withinCoupling_reads`, then `WithinClosure.of_reads` (re-proved by HE2 as a `match` on the law), with `Flow.CoupledFrom.of_reads` splitting a step.
- The backward half is `WithinClosureOf.to_reads`. After HE2 its proof is `«二所闭在借步之所闭» larger reaches (match within with …)`. Its third explicit argument is a `match`, not a bound variable, so the forwarder test (`THEOREM-CONNECTIVITY-DUMP.lean:79`) does not mark it a forwarder.
- `WithinClosureOf.to_reads` is not a grammar law, not a root theorem and not a declared lemma. `boundary.derived` (`boundary.py:445`) therefore puts it in `undeclared` (D2) and does not walk it, so `«二所闭在借步之所闭»` is never reached (D3, `boundary.py:449`).
- The content is right. The row is a case of both laws, and the hypotheses are met at every instance: the inline inclusion for `larger`, and `WithinClosure.of_rel` (a forwarder of `«缘在所闭»`) for `reaches`. Only the declaration is short.

### GroupEnding.Flow.all_end

`GroupEnding.Flow.all_end`, `RootForms.outside_leaves_no_offspring`, `RootForms.all_end_at_model`, `RootForms.all_end_certified`, `RootForms.GivesFrom`, `RootForms.outside_leaves_no_offspring.needs_gate`, `RootForms.outside_leaves_no_offspring.gate_needed`, `RootForms.ListedWithin`, `RootForms.outside_leaves_no_offspring.needs_descent`, `RootForms.outside_leaves_no_offspring.descent_needed`, `RootForms.Outside`, `RootForms.outside_leaves_no_offspring.needs_outside`, `RootForms.outside_leaves_no_offspring.outside_needed`.

Holds as a standing under a stated hypothesis, with finding 2.

**Relational content.** The form (`RootForms.lean:204`) names only `«则»`, `«而»`, list membership and `flatMap`. Its three hypotheses are relations between relations, regions and lists, and none names a model or an amount:
- `RootForms.GivesFrom` (`:184`): giving lies within giving from the region;
- `RootForms.ListedWithin` (`:189`): listed descent lies within giving;
- `RootForms.Outside` (`:193`): the listing lies outside the region.

**Countermodels and fits.** Each countermodel (`:233-268`) is over `Unit`, and each fit applies the form at its witness. Each shows the hypothesis is not redundant, and no more, as `does_not_show` says.

**Recovery.** `RootForms.all_end_at_model` (`:278-284`) instantiates the form as follows:
- the region is `W.active t`;
- `gives g k` is `g ∈ L.present t ∧ 0 < L.give t g k`;
- the gate is met by `acting t g k gives.1 gives.2`, an application of the hypothesis `Flow.Acting` (`Flow.lean:280`);
- descent is met by the first two conjuncts of `Flow.DescendsAt` (`Evolution.lean:154`);
- the conclusion is the family's length (`SelectionTerm.lean:440-443`).

Every step uses a hypothesis of the row or a projection, so the recovery is by definitions alone. `RootForms.all_end_certified` ties it to the row by `rfl`.

**What the row carries beyond the form.** The row's hypotheses are stronger than the form uses:
- `Flow.Acting` is quantified over every step and condition;
- `SelectionTerm.Flow.Descended` is quantified over every step (`SelectionTerm.lean:664`);
- `Flow.DescendsAt` adds that each offspring comes to stand, which the recovery never uses.

The basis says the opposite (finding 2).

### Flow.no_new_dependence

`Flow.no_new_dependence`, `RootForms.descent_forms_no_dependence`.

Holds.
- The row (`Transmission.lean:531`) writes balance out, so the rule places it at balance in its statement.
- Its relational part (`RootForms.lean:77-96`) is the right one. It has three relations, `GivenTo`, `Inherits` and `UndependedFrom`, each with a countermodel (`:124-160`).
- The recovery (`:168-176`) meets `GivenTo` only through `Flow.descends_of_comes` (`Transmission.lean:501`). That lemma uses `total_pos` and `BalancesOn.rise_given` (`Flow.lean:464`), which is amount reasoning, so the discharge condition fails, as the basis says.
- The basis is true.

### CensusWebs.keep_pace

`CensusWebs.keep_pace`.

Holds. The row (`Listing.lean:1057`) is the counting law at a web's arising and ceasing over a listing, and the basis says so.

### Drift.falls_back

`Drift.falls_back`.

Holds. The row (`Drift.lean:232`) counts weighted courses of binary draws. The basis's "the model's hypothesis" is lever 2's wording for reading the courses as drift.

### Listed.coming_of_ceasing

`Listed.coming_of_ceasing`.

Holds. The row (`Population.lean:609`) names no amount. `ComesToBe` and `CeasesToBe` (`Change.lean:295`) are predicates over a listing.

### RelativePosition.rise_needs_fall

`RelativePosition.rise_needs_fall`.

Holds. The row (`RelativePosition.lean:175`) counts rises and falls over a list. Both counts weight by amounts, but the identity is one of counting.

### SelectionLevels.levels_sized

`SelectionLevels.levels_sized`.

Holds. The row (`SelectionLevels.lean:266`) is Price's partition as an identity of sums.

### SelectionTerm.covariation

`SelectionTerm.covariation`.

Holds. The row (`SelectionTerm.lean:248`) is Price's covariance as an identity of sums.

### Flow.new_beyond_every

`Flow.new_beyond_every`.

Finding 5. The label holds: the conclusion is an imbalance of amounts, and `Balances` enters only the proof. The basis reverses the direction of the conclusion.

### Flow.selected_le

`Flow.selected_le`.

Finding 3. The label holds: the conclusion compares weighted totals of need and level (`Evolution.lean:231`). The basis's "sums of amounts over generations" is not what this row states, since it speaks of one step of descent.

### Flow.selection_within

`Flow.selection_within`.

Finding 3. The label holds (`Evolution.lean:242`): the row compares the offspring's totals with the lowered and raised terms, at one step of descent.

### Flow.transmitted_supported

`Flow.transmitted_supported`.

Finding 3. The label holds (`Evolution.lean:291`).
- The conclusion is one descendant's need at most the level plus `δ`.
- The hypothesis `TransmitsWithin` (`:256`) also constrains amounts.
- Neither is a sum over generations.

### SelectionTerm.Flow.support_moved_rises

`SelectionTerm.Flow.support_moved_rises`.

Finding 3. The label holds (`SelectionTerm.lean:682`): the conclusion compares products of sizes and sums over `T` generations, so the shared basis is right on the conclusion here. Only its "stated on the root" needs the precision of finding 3.

### SelectionTerm.Flow.support_not_lower

`SelectionTerm.Flow.support_not_lower`.

Finding 3. As the previous row (`SelectionTerm.lean:670`), and the conclusion is again over generations.

### GroupEnding.Flow.rises_iff_inactive

`GroupEnding.Flow.rises_iff_inactive`.

Finding 4. The label holds (`GroupEnding.lean:281`).
- The row takes `Exact` at the one step `t`: each offspring's amount is its parent's (`SelectionTerm.lean:365`). It does not take cancellation.
- The inactive hypothesis compares trait sums, as the basis says.

### SelectionLevels.rises_exact_iff_levels

`SelectionLevels.rises_exact_iff_levels`.

Finding 4. The label holds (`SelectionLevels.lean:553`). The row takes `exact` at step `t`, not "cancellation … at each step".

### Reproduction.Flow.number_within_take

`Reproduction.Flow.number_within_take`.

Holds. The row (`Reproduction.lean:561`) bounds a count within a take, an amount, under dissipation and an injection. The basis is true.

### RegimeMargin.ends_iff_below

`RegimeMargin.ends_iff_below`.

Finding 19. The label holds: the row (`RegimeMargin.lean:739`) compares the starting level with `H + y`. The run's state is a level, not a margin.

### RegimeMargin.Adjusted.ends_iff_below

`RegimeMargin.Adjusted.ends_iff_below`.

Finding 19. The label holds (`RegimeMargin.lean:674`). The state is a level paired with recent giving.

### Web.Next.frontier_ends_drawn_first

`Web.Next.frontier_ends_drawn_first`.

Holds. The row (`Optimum.lean:7783`) is stated in natural-number levels and weighted sums.

### Web.frontier_breaks_below

`Web.frontier_breaks_below`.

Holds. The row (`Optimum.lean:4750`) is a coupling below what keeping forgoes, in natural-number worths and draws.

### Web.frontier_broken

`Web.frontier_broken`.

Finding 19. The label holds. The row (`Optimum.lean:3898`) ranks by `drawnOver`, which is unweighted, so the basis's "weighted draws" is wrong.

### Web.frontier_exhausts

`Web.frontier_exhausts`.

Holds. The row (`Optimum.lean:7172`) uses `weightedOver`, and the basis is true.

### Web.frontier_keeps_stepwise

`Web.frontier_keeps_stepwise`.

Finding 19. The label holds (`Optimum.lean:5874`). The worth adds a per-step coupling `w` to the draws, which is not a weighting.

### Web.frontier_rebuilds

`Web.frontier_rebuilds`.

Holds. The row (`Optimum.lean:7458`) is stated in natural-number levels and weights.

### responses_le_missBound

`responses_le_missBound`.

Holds. The row (`Remainder.lean:237`) is a bound of propagation on amounts, a law of its model.

### Direction.extension_iff_widens

`Direction.extension_iff_widens`.

Holds, with finding 21. The row's whole proof is `W.paths_extension_iff_widens` (`Direction.lean:90-92`), which is another central row, on its own carrier. The basis says it "states another row". It should say the row is proved as that row.

### PartForms.goAlike

`PartForms.goAlike`.

Holds. The row (`MoveFormation.lean:269`) is a law of its model, and the image law only reads it. The basis follows OU3d's review.

### carried_iff_rising

`carried_iff_rising`.

Finding 11.
- The statement (`LevelCoupling.lean:904-910`) compares amounts, `r x ≤ r (x + 1)` with levels up to `N`. That is the sense §1 gives "amounts".
- `responses_le_missBound`, also a law of its model, is labelled amounts.
- The basis gives no reason for choosing "at its model" here.

### Web.paths_one_object

`Web.paths_one_object`.

Holds, with finding 20. The row (`Relevance.lean:167`) keeps `sig` free. Its root form is `SignificanceStatements.paths_one_object_root` (`SignificanceStatements.lean:95`), at the own-closure reading. That form states less than the row.

### Web.widens_iff_retains_adds

`Web.widens_iff_retains_adds`.

Holds, with finding 20. The row (`Significance.lean:324`) takes `Unrestricted sig` as a hypothesis with `sig` free. Its root form is `SignificanceStatements.widens_iff_retains_adds_root` (`:82`).

### unrestricted_iff_livingSignificance

`unrestricted_iff_livingSignificance`.

Holds, with finding 20.
- The row (`Relevance.lean:136`) is stated on any frame `M` with realized events.
- Its root form, `SignificanceStatements.noOutside_iff_paths_livingSignificance` (`:55`), is on a web's level paths only.
- So it too states less than the row, which the basis omits.

## Premises of the ethics

### Premise, scope: the continuation condition

`Unrestricted`, `ReadsOnlyDynamics.not_entails`.

Q1 holds:
- `Unrestricted` is a definition (`Significance.lean:181`);
- the type of `ReadsOnlyDynamics.not_entails` (`:296-299`) names it;
- the theorem states non-entailment by every statement that reads only the dynamics.

The basis is faithful to AGENTS:
- the condition fixes scope;
- its warrant is open;
- no warrant binding every possible mind is claimed;
- nowhere is the ethics said to "derive" from it.

The gloss is less precise than the theorem, and the citation for the warrant points to the wrong section (finding 9).

### Premise, order: C

`Comparison`.

Holds.
- `Comparison` is a definition with `Better` a parameter (`Extension.lean:57-58`).
- `not_entailed` is null, and `absent` says truly that no such theorem exists.
- The basis says that what ranks lies in C alone, that the condition orders nothing, and that a reason for C is open. This agrees with AGENTS and 07 §4.

## Findings

1. **Major. `Flow.withinCoupling_reads_iff` after HE2: the support omits `WithinClosureOf.to_reads`, so the entry fails D2 and D3.**
   - *Evidence.* The row's backward half is `WithinClosureOf.to_reads` (`SelectionPool.lean:604`). HE2 re-proves it as `«二所闭在借步之所闭» larger reaches (match within with …)` (`he2_u4.py` on `he2-land`, the `WithinClosureOf.to_reads (proof)` edit).
   - `appliedTheorem` admits only bound variables as explicit arguments (`THEOREM-CONNECTIVITY-DUMP.lean:79`). So the dump gives it no `f`, and `_forwarder` (`boundary.py:364-374`) returns `None`.
   - `WithinClosureOf.to_reads` lives in SelectionPool, so it is not a root theorem. It is not declared either. `derived` therefore adds it to `undeclared` (`boundary.py:445`), which is D2, and never walks it. The walk then does not reach `«二所闭在借步之所闭»`, which is D3 (`:449`).
   - The entry would be listed as unverified, and `integrate_u4.py` requires the four boundary lists to be empty before landing.
   - *Fix.* In `make_record_u4.py`'s HE2 branch (`derived('Flow.withinCoupling_reads_iff', …)`), make the support `['Flow.withinCoupling_reads', 'WithinClosure.of_reads', 'Flow.CoupledFrom.of_reads', 'WithinClosureOf.to_reads']`.
   - Append to the basis: "WithinClosureOf.to_reads is the second law with the pool's two-member closure read as a disjunction, its `larger` met by an inline inclusion of the pool's couplings in the reader's, and its `reaches` by WithinClosure.of_rel."
   - The entry's names then include `WithinClosureOf.to_reads`, which this review already gives. Confirm on HE2's core run that D2 to D5 pass.
2. **Minor. `GroupEnding.Flow.all_end`'s basis says the row carries nothing beyond the form's hypotheses. It carries more, and the basis does not name K3's premise.**
   - *Evidence.* The sentence is "The row carries nothing beyond the three hypotheses but these readings". The row's `acting : L.Acting W` is quantified over every step, formation and condition (`Flow.lean:280`), and `descended` over every step (`SelectionTerm.lean:664`). `Flow.DescendsAt`'s third conjunct, `W.ComesToStand t x` (`Evolution.lean:154`), is never used by `RootForms.all_end_at_model` (`RootForms.lean:282-283` projects `.1` and `.2.1`).
   - BOUNDARY-FIELD §3.2 requires the basis to state what the row carries beyond the form's hypotheses. It also requires a hypothesis that matches a K3 premise to name that premise. The gate matches COVERAGE.json's "only active relata give" (pattern `\bActing\b`).
   - *Fix.* Replace that sentence with: "Beyond the form's hypotheses at the one step `t`, the row carries the gate and descent at every step, and descent's third part, that each offspring comes to stand, which the recovery does not use; neither places the row."
   - Name the first hypothesis as K3's premise "only active relata give". For example, write "That only active formations give (K3's premise 'only active relata give') meets the first hypothesis".
3. **Minor. The basis shared by five amounts rows (`Flow.selected_le`, `Flow.selection_within`, `Flow.transmitted_supported`, `SelectionTerm.Flow.support_moved_rises`, `SelectionTerm.Flow.support_not_lower`) is untrue of three of them, and overstates where the gate stands.**
   - *Evidence.* "the conclusion compares sums of amounts over generations" fits `support_not_lower` and `support_moved_rises`, which speak of `G.size T`, `G.sum T` and so on.
   - It does not fit `selected_le` or `selection_within`, which compare weighted totals at one step of descent (`Evolution.lean:231-247`). Nor does it fit `transmitted_supported`, which bounds one descendant's need by `W.level t c + δ` (`:291-296`) and whose `TransmitsWithin` hypothesis (`:256`) itself constrains amounts.
   - On the gate, lever 2 §4 says both parts of the gate "stand at the represented model together". The relations they include are read off amounts (`0 < give`, `need ≤ level`).
   - *Fix.* Write the basis per row. For the gate, write "the gate is stated as inclusions at the represented model (lever 2 §4), its relations read off amounts". Then give the conclusion:
     - `selected_le`: "compares the parents' needs, weighted by their offspring, with the level, at one step of descent";
     - `selection_within`: "compares the offspring's totals with the lowered and raised terms, at one step";
     - `transmitted_supported`: "bounds a descendant's need by the level plus `δ`, and `TransmitsWithin` constrains amounts";
     - the two `SelectionTerm.Flow` rows: keep "over generations".
4. **Minor. `GroupEnding.Flow.rises_iff_inactive` and `SelectionLevels.rises_exact_iff_levels`: the bases say cancellation, but the rows take exact transmission.**
   - *Evidence.* Both rows take `Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))` at the one step `t`, and `Exact` says each offspring's amount equals its parent's (`SelectionTerm.lean:365`).
   - Cancellation is lever 2's weakening, in scratch (`rises_cancel_iff_levels`, `rises_iff_inactive_on_root`; LEVER-2-AUDIT §1, §4). The "two inclusions … on the root" of `rises_iff_inactive` are also lever 2's scratch, not package Lean.
   - *Fix.* For `rises_exact_iff_levels`, write: "Exact transmission at the step, each offspring's amount its parent's, constrains amounts (the proof needs only its cancellation, lever 2); its list facts are counting."
   - For `rises_iff_inactive`, write: "The gate and descent stand as two inclusions in lever 2's weakening; exact transmission at the step, and inactivity compared on sums of the trait, constrain amounts; its list facts are counting."
5. **Minor. `Flow.new_beyond_every`: the basis reverses the direction of the imbalance.**
   - *Evidence.* The basis says the family "gives more than it takes". The row concludes `(L.withImbalance W).NetGiver ds t none ∨ ¬ L.ClosedAt ds t` (`Gain.lean:341-345`). `NetGiver ds t f` says that `f` gives the family more than it takes (`Gain.lean:220`), and here `f` is the imbalance relatum `none`. The docstring says the family "is given more than it takes, by the rest or across its boundary".
   - *Fix.* Write: "Endless novelty concludes that a family is given more than it takes, by the rest or across its boundary, an imbalance of amounts; balance enters only the proof."
6. **Minor. The statement (en and zh) and the home section say that every declaration stands "on the edge". Most stand at a distance from it.**
   - *Evidence.* The statement reads "Each central declaration stands in one place on the edge of one root", and the home has the same words. By WHAT-REMAINS and BOUNDARY-FIELD §0, only derived and under a stated hypothesis are on the edge. Counting is below the grammar, and the other 101 are "a distance from the edge". The zh also says the entry under a stated hypothesis "为一根形", that is, is a root form, but it is an instance of one.
   - *Fix.*
     - In the statement (en), write: "Each central declaration has one standing against the edge of one root: on it, derived from grammar laws or under a stated hypothesis with each hypothesis needed; below the grammar, counting; or at a named distance, with its reason."
     - In the zh, write `于一根之边各有一所立：在边上，或推出为文法之律之例，或在所述假设之下为一根形之例而其每一假设皆必要；在文法之下，计数；或在有名之距，各有其理。`
     - In `home()`, write "Each of the 118 … has one standing against the edge of one root."
7. **Minor. The home section says "Neither is shown stated on the root, so no premise stands on the edge". This misses the actual reason.**
   - *Evidence.* 07's lead says the condition "on the root … is `«续无外»`" at a reading. BOUNDARY-FIELD §3.3 gives the reason that standing 3 is empty:
     - `ReadsOnlyDynamics.not_entails` is about the free form, which 07 §4.5 keeps off the root;
     - the root form `«续无外»` has no not-entailed theorem;
     - C has neither.
   - *Fix.* In `home()`, write: "Neither stands on the edge: the condition's not-entailed theorem concerns its free form, which chapter 7 keeps off the root, and its root form at the own-closure reading, `«续无外»`, has none; C has neither."
8. **Minor. "`master_laws.py` checks every entry" overclaims.**
   - *Evidence.* By BOUNDARY-FIELD §3.4, readings of labels the rule does not compute are declared and reviewed, not checked. These labels are counting, amounts, at its model and free significance, 30 entries in all.
   - Whether a derived row applies its laws as the case is likewise read, as the record's own third hypothesis says. `validation_scope` gets this right. The home section does not.
   - *Fix.* In `home()`, write: "`master_laws.py` checks on the core run what the Lean can show of each entry (the derived entries by D1 to D6, the entry under a stated hypothesis by the Lean check, the premises by Q1, readings of computed labels against the rule); the other readings and the case of each derived row rest on the review."
9. **Minor. The glosses of `ReadsOnlyDynamics.not_entails` drop its conditions, and the warrant is cited to the wrong section.**
   - *Evidence.* The scope premise's basis, `does_not_show` item 3 ("not entailed by the dynamics") and the home section all say that no statement reading only the dynamics entails the condition, without conditions.
   - The theorem holds only "where there is a standpoint and a formation" (its arguments `p f`), and only for a statement that holds of some dynamics with some significance (its conclusion `¬ law d sig`; `Significance.lean:296-299`). 07's lead states both conditions.
   - The basis cites "(07 §3)" for the warrant being open, but §3 defines the condition. The warrant is stated open under T8 (§8) and in "What this chapter does not show" (07:676).
   - *Fix.* In all three places, write: "where there is a standpoint and a formation, no statement reading only the dynamics and holding of some dynamics entails it". Change "(07 §3)" to "(07 §3 for the condition; T8, §8, for the warrant)".
   - Optionally, add the condition's content beyond the self's presupposition, as AGENTS gives it: "its content beyond the self's presupposition, the step of invariance, extends scope to losses that return to no one".
10. **Minor. `WithinClosure.mono` is support only because the dump fails to recognize it as a forwarder, so the entry depends on that tool gap.**
    - *Evidence.* `WithinClosure.mono` is `«所闭之单调» larger f g within` (`Frame.lean:117-119`), a forwarder in content. BOUNDARY-FIELD §3.0 records it as a false negative: the law is applied past `«则»` with more arguments than its type has binders.
    - If the forwarder test is extended, D4 will fail with "it is a grammar law or a forwarder of one".
    - *Fix.* Add to the basis: "WithinClosure.mono is listed as support only because the dump's forwarder test does not recognize a law applied past «则» (BOUNDARY-FIELD §3.0); it is to be dropped from the support when the test does." Tell MV's owner so that the test change and the record change land together.
11. **Minor. `carried_iff_rising` is labelled "at its model", though its statement compares amounts, and no reason is given.**
    - *Evidence.* The statement is `… ↔ ∀ x, x < N → r x ≤ r (x + 1)`, with `l t d ≤ N` inside (`LevelCoupling.lean:904-910`). §1 defines amounts as "its statement compares amounts". `responses_le_missBound`, also a law of its model, is labelled amounts.
    - *Fix.* Either relabel it amounts, which makes the counts amounts 19 and at its model 2 (the home section is generated, so the numbers follow), or add to the basis why "at its model" is chosen over amounts. One possible reason: the amounts are the response's own and the row's content is the support kept inside the existential.
12. **Minor. The correspondence to reverse mathematics claims more than the record does.**
    - *Evidence.* Reverse mathematics places a theorem by a reversal, the theorem implying its hypotheses over a base system.
    - Here, one row is placed by hypotheses whose countermodels show only that none is redundant. The record says so itself in `does_not_show` item 2. Ten rows are placed as cases of laws, and the other 107 by reading.
    - *Fix.* Write: "Reverse mathematics in spirit only: a theorem placed by what it needs (Friedman 1975; Simpson 2009). Here the base is a grammar of relations, one row is placed by a form whose hypotheses are each shown non-redundant (no reversal is proved), and the measure is dependence in the compiled terms."
13. **Minor. The counts and the rule's labels come from `boundary-table.json`, which was computed before HE2.**
    - *Evidence.* `make_record_u4.py` reads `boundary-table.json` for every row it does not place. HE2 adds grammar laws and re-proves model lemmas, so the reach of rows using `WithinClosure.of_reads` or `WithinClosureOf.to_reads` changes. HE2's KIT says `central_reach` may move.
    - No central row lies in Sampling or PatternPassing, and readings come before the rule, so I expect no label to change. That is not verified.
    - *Fix.* Rerun `boundary_table.py` on HE2's core run before `integrate_u4.py record`, and keep master_laws.py's count check as the gate.
14. **Wording. `Flow.beyond_gives_nothing`'s basis.**
    - *Evidence.* "FedFrom and FedBy unfold to the closure" is wrong. `FedFrom` unfolds to `FedBy` at one step (`Interdependence.lean:115`), and `WithinFeeding` is the closure (`:125`).
    - "One step of the prelude" is also wrong. `eq_zero_of_not_pos` is Flow's lemma (`Flow.lean:109`), with `Init` content.
    - *Fix.* Write: "WithinFeeding is the closure of FedFrom, which unfolds through FedBy to a positive giving to a required condition; the support, eq_zero_of_not_pos, is Flow's lemma that a natural number not above nothing is nothing."
15. **Wording. `Law.drawn_iff_not_returns`'s basis: "absorbing … closure".**
    - *Evidence.* `Law.absorbing_iff_closed` reads absorbing as `«闭»`, a region closed under the step (`Attraction.lean:149`), not as `«所闭»`.
    - *Fix.* Write "as the grammar's «入», closed region («闭», `Law.absorbing_iff_closed`), «及» and return".
16. **Wording. `Law.lossless_iff_returns`'s basis.**
    - *Fix.* Change "the other bridges and the support are those of Law.drawn_iff_not_returns" to "the other five bridges are among those of Law.drawn_iff_not_returns, and the support is its support".
17. **Wording. `Tolerance.answers_restores_iff`'s basis.**
    - *Evidence.* `Tolerance.worst_start` (`Tolerance.lean:249`) shows that, for a step keeping inclusion, restoring from total withholding gives restoring from every start. It does not instantiate a start.
    - *Fix.* Write "the worst start reduces every start to total withholding, the answering step keeping inclusion (`Tolerance.answers_keeps`)".
18. **Wording. `Withholding.withholding_spreads`'s basis.**
    - *Fix.* Change "waiting on all is closed by definition" to "waiting on all meets the law's round by unfolding (`Withholding.waitsAll_closed`, `Iff.rfl`)".
19. **Wording. The bases of four amounts rows.**
    - `RegimeMargin.ends_iff_below` and `RegimeMargin.Adjusted.ends_iff_below`: change "natural-number margins" to "natural-number levels". The run's state is the level (`RegimeMargin.lean:739-742`).
    - `Web.frontier_broken`: change "weighted draws" to "what is drawn" (`drawnOver`, `Optimum.lean:3898-3900`).
    - `Web.frontier_keeps_stepwise`: change "weighted sums" to "draws with a per-step coupling `w`" (`Optimum.lean:5874-5880`).
20. **Wording. The three free-significance bases name their root forms without namespace, and one omits that its form states less than the row.**
    - *Fix.* Write `SignificanceStatements.paths_one_object_root`, `SignificanceStatements.widens_iff_retains_adds_root` and `SignificanceStatements.noOutside_iff_paths_livingSignificance`.
    - For `unrestricted_iff_livingSignificance`, add "on a web's level paths only, so it states less than the row, which is on any frame".
    - For `Web.widens_iff_retains_adds`, add "it takes the condition as a hypothesis with significance free".
21. **Wording. `Direction.extension_iff_widens`'s basis.**
    - *Fix.* Write: "C's extension on the moves' frame, proved as `Web.paths_extension_iff_widens` (another central row, on its own carrier) read at that frame; a law of that model."
22. **Wording. Smaller points in the record and the home section.**
    - `related` cites "row 17" and "row 5" without saying whose numbering. Write "row 17 of lever 2's table (LEVER-2-AUDIT §1)" and the same for row 5.
    - The home section says "the eight connected rows the reading took". Write "the eight connected rows that the reading of connected rows took as derived (CONNECTED-ROWS-READING.md)".
    - The home section also says each derived row is a case "through bridges … and support". `Flow.mutuallyDependent_iff_reach` has neither, and `Flow.beyond_gives_nothing` and `Flow.withinSystem_of_withinInfluence` have no bridges. Write "through bridges checked in Lean as equivalences and support the review reads, where a row has them".

## How the findings were taken

*Added by U4's taker after the review, 31 October 2026. The review above is unchanged.*

Every finding was taken in `make_record_u4.py`, and the drafts, the home section and the names list were regenerated. Both drafts pass the field's rules with this file's text and the record style lint.
1. `WithinClosureOf.to_reads` joins the support of `Flow.withinCoupling_reads_iff`, with the proposed sentence in its basis. D2 to D5 are confirmed on HE2's core run at the rehearsal.
2. Row 17's basis now names what the row carries beyond the form at the one step: the gate and descent at every step, and descent's third part, unused. It also names K3's premise "only active relata give".
3. The five gate rows have bases of their own, the gate stated as inclusions at the represented model with its relations read off amounts.
4. `GroupEnding.Flow.rises_iff_inactive` and `SelectionLevels.rises_exact_iff_levels` now name exact transmission; cancellation is lever 2's weakening.
5. `Flow.new_beyond_every`: the family is given more than it takes.
6. The statement says that each declaration "has one standing against the edge", on it, below the grammar or at a named distance. The zh says "为一根形之例", an instance of a root form, not the form itself. The home section changes to match.
7. The home section gives the actual reason no premise stands on the edge: the not-entailed theorem concerns the free form, `«续无外»` has none, and C has neither.
8. The home section says what `master_laws.py` checks and what rests on the review.
9. The not-entailed glosses carry the theorem's conditions in the premise's basis, `does_not_show` and the home section. The warrant is cited to T8 in 07 §8, and the step of invariance is added.
10. `Flow.withinSystem_of_withinInfluence`'s basis says why `WithinClosure.mono` is support and that it leaves the support when the forwarder test recognizes it. MV's owner is told.
11. `carried_iff_rising` is relabelled amounts, as `responses_le_missBound` is: amounts 19, at its model 2.
12. The correspondence reads "in spirit only", with no reversal proved.
13. `integrate_u4.py` now says to rerun `boundary_table.py` on the landing's core run before `record`. A new `check` step, after `master_laws.py`, requires all of the following:
    - the data reads the record;
    - nothing is unverified or unplaced;
    - the premises are not entailed or not shown;
    - the Lean check ran;
    - the counts are the home section's.
14. to 22. The wording is taken as proposed:
    - `Flow.beyond_gives_nothing`, `Law.drawn_iff_not_returns`, `Law.lossless_iff_returns`, `Tolerance.answers_restores_iff` and `Withholding.withholding_spreads`;
    - the four amounts rows;
    - the three root forms of the free-significance rows, named with `SignificanceStatements.`, and what each states less;
    - `Direction.extension_iff_widens`;
    - `related`'s rows, now "of lever 2's table";
    - the home section's "where a row has them".
