# EC6: the independent review

28 October 2026. One independent read-only review by a separate AI agent (Claude Opus, in a subagent of the drafting session), of `AUDIT.md` as committed at `60a129f25`, against the Lean on main and the dependency dump the audit used. The report follows verbatim; what was taken is in AUDIT.md, "What the review changed".

---

I checked all 50 declarations against their Lean source and the dependency dump. I recomputed every count with the measure's own dependency walk over `COVERAGE.json`, and checked every record id against `theories/becoming/results/records/*.json`. Nothing was edited or compiled.

Lean paths below are relative to `L = /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## Findings

1. **error**: Measure notes 1, and "What this audit does not do".
   - **Claim:** "28 central rows reach `ClosedUnder`."
   - **Evidence:** in the dump, 12 central rows reach `Becoming.ClosedUnder`, and all 12 already reach `WithinClosure`. The 28 is the number that reach `«闭»`, which is every row that reaches the grammar, because `«所闭»` is defined from `«闭»` (`GrammarLaws.lean:131`).
   - **Consequence:** adding `ClosedUnder` as an anchor credits no current row. It only credits rows rewritten to name it, which is a definitional mention.
   - **Fix:** correct the count to 12, and say what adding the anchor would and would not move.

2. **overclaim**: (a) chains, rows `Web.living_on_reaches` and `Flow.descent_reaches`.
   - **Evidence:** each proof is one application of N_rel, with no chain and no induction (`Descent.lean:98-104`, `135-142`). That fails the audit's own test in the Method section. Deriving them as one-step instances is rerouting.
   - **Existing theorem missed:** the "closure form of N_rel" that proposal 9 asks for already exists: `Valuation.reaches` (`ValuationFrames.lean:58`, via `Invariant.reach`) and `Valuation.forced_iff_reach` (`:75`). Both reach closure in the dump.
   - **Fix:** class both rows (c), as one step of the N_rel premise. In proposals 9 and 13, cite `Valuation.reaches` as the existing closure form instead of proposing a new one.

3. **overclaim**: (a) one step under a sameness, rows `unselected_beyond_data` and `no_exact_finite_reading`.
   - **Evidence:**
     - The first is one `.mpr` of `through` (`Learning.lean:940-950`).
     - The second's content is `prefix_does_not_decide` (`LabelledRoles.lean:171-179`).
     - The audit itself says the step "adds no content".
     - Crediting them would need `Through`/`decided` respelled as `ClosedUnder` plus a new anchor. WHAT-REMAINS item 1 rejects that, because "the measure would then count a definitional mention, not a derivation".
     - The record `generalization-through-lumping` frames the first row as lumping ("training selects through data"). That is the same static factorization the audit calls (c) for `partForms_iff`.
   - **Fix:** move both to (c), and drop them from the 17.

4. **overclaim**: (a) "reaching within *n* steps", and the Summary's "17 … with no new law needed".
   - **Evidence:** the derivation needs new grammar laws (within-n composition, and the iterate law) that none of the five laws states. `«迭»` and `«迭之接»` sit in GrammarLaws' finite-runs section (`:635`, `:654`; the section runs `:612-1034`), and closure carries no step counts.
   - **Is the step-indexed statement needed, and correctly described?**
     - It is needed only if these rows are to rest on a stated law. That makes them a (b) candidate, not cases of closure.
     - Its content matches the Lean: `answers_closed` is the exactly-n form (`Withholding.lean:244-257`), `waitsAll_closed` the within-n form with memory (`:165-190`).
     - On the grammar it would need an n-fold iterate of a map on regions. GrammarLaws has none; `Law.run` and `Law.orbit` are in Recurrence, above it.
     - `Chain` composes last-step-last (`Withholding.lean:105-109`), while `«迭»` composes first-step-first, so `Chain ↔ «迭»` needs its own induction.
     - `answers_restores_iff` also keeps an orbit-monotonicity induction, `KeepsInclusionInto.course` (`Tolerance.lean:233-246`), which the audit does not mention.
   - **Fix:** relabel the three rows (b) "step-indexed reaching" and correct the Summary. Corrected tally: (a) 10, (b) 14, (c) 26.

5. **error**: (a) chains, row `onLoop_of_closing`.
   - **Evidence:**
     - `Upstream` admits the empty chain (`j = 0`; `Loops.lean:364-368`). So `Upstream e e` always holds, and `Upstream` is `«所闭»` (equality or `«及»`), not `«及»`.
     - `«所闭之传递»` (`GrammarLaws.lean:137`) yields only the trivial `«所闭» e e`, not `OnLoop e` (which needs `0 < m`).
   - **Fix:** the join needs `«及当且仅当一步而所闭»` (`GrammarLaws.lean:206`) and then `«及之传递»` (`Grammar.lean:94`). The forward bridges from index vectors are `«线则及»` and `«线则所闭»` (`GrammarLaws.lean:842`, `849`); the converse is also needed, because the conclusion is an index vector.

6. **error**: (a) invariance, row `RegimeMargin.Drawn.run_shape`, and proposal 4.
   - **Evidence:** `orbit_mono` takes arbitrary `a b` with `rel a b` (`Lasting.lean:367-371`). The pairs law `(x, f x) ↦ (f x, f (f x))` covers only the case `b = g a` used in `rising_on` and `falling_on` (`RegimeMargin.lean:1994-2011`). Other callers pass arbitrary ordered starts: `falls_of_below` (`:1632-1638`) and `run_below` (`:2173-2176`).
   - **Fix:** derive it from the invariance of `{(a, b) | rel a b}` under the product law `(a, b) ↦ (g a, g b)`, whose closedness is `mono` (not `step_mono`), plus a lemma that the product orbit is the pair of orbits.

7. **imprecision**: (a) invariance, and proposals 1–3.
   - **Evidence:**
     - `locked_stays`, `locked_not_below` and `favours_after_reading` start at an arbitrary `t` or `r + 1` (`RuleCapture.lean:180-215`, `276-288`). `Invariant.run` starts at state 0 (`Frame.lean:259-262`).
     - Every region must be read on the joint state `S × R × Nat` of `Law.run (Pace.step …)` (`Pace.lean:107-115`).
     - Closedness for `locked_not_below` comes from `turn_locked` with transitivity, not from `locked_rises`, which is a course lemma.
     - `lock_outlives_loss` keeps two more inductions of its own, `join_course` and `loss_grows` (`ClosedCapture.lean:247-286`).
     - No central row reaches `Invariant.run`. Its only direct users are `Hexagram.*` and `Dephasing.*_along`, so proposal 1 by itself moves nothing.
   - **Confirmed:** `Invariant.run` does follow from `Invariant.reach` and `Run.reach` with `Nat.zero_add`.
   - **Fix:** use `Invariant.reach` with `Run.reach run t k` (`Frame.lean:230-233`), which matches the `t + k` shape directly, and name the lifted regions.

8. **imprecision**: (a) balance, row `CensusWebs.keep_pace`, and proposal 10.
   - **Evidence:** `balance_over_stretch_on` takes count functions `q x y : Nat → Nat` (`Prelude.lean:782-803`). `Counts.over_stretch_decided` has relational, existential counts (`Counts`, `CountsAcross`) that exist only where `Decided`, which is a Prop `p ∨ ¬p` (`Decidedness.lean:99-102`, `217-222`, `289-296`, `339-367`). In the pure core this needs a finite-choice induction over the stretch, plus a lemma reading `CountsAcross` as a `total`, so the induction moves rather than disappears.
   - **Fix:** name both bridge lemmas, and cite `Listed.over_stretch_on` (`Population.lean:504-514`) as the listed case already derived from the prelude. Also note that no record lists `CensusWebs.keep_pace`; `coming-and-ceasing-keep-pace` lists `Becoming.keep_pace`, a different declaration.

9. **imprecision**: (a) balance, Optimum rows, and proposal 11.
   - **Evidence:**
     - With `Flow.Balances` defined as a case of the new clause, the dependency runs from `Balances` to the clause. `Outcome` and `mutual_beyond` would then reach the clause but no anchor in `LAWS['balance']` (`ec-elegant-completion/measure.py:23`).
     - The proposal also changes `Flow.Outcome` (`Optimum.lean:1025-1031`) and `mutual_beyond`'s `balances` hypothesis, which is a statement change, not only the anchor.
     - Redefining `Flow.Balances` touches 52 balance rows and `Flow.balances_iff_units`.
   - **Fix:** say that the clause must be added to `LAWS` (EC's owner), that `mutual_beyond`'s statement changes, and that the 52 need a recheck.

10. **error**: (b) support gating, row `carried_iff_rising`, and the Assessment's "stated once".
    - **Evidence:** in the dump, `carried_iff_rising` reaches none of `Web.Supported`, `Web.Dependent` or `Flow.Acting`. Its gate is `ExchangeLaw.NeedsSupportAt`, built on `Web.Admits` (`LevelCoupling.lean:652-658`; `Admission.lean:377-380`), with the step `Web.Admits.mono` in `rises_at_step` (`LevelCoupling.lean:663-687`). So the gate is stated twice, not once.
    - **Effect of option 1:** its anchors would not credit this row, but would credit `Web.roles_supported` and `Web.roles_dependent`, which reach `Web.Supported` and are classed (c). The 50 would lose 9 rows (the other 7 support rows plus those 2), not the audit's 8.
    - **Fix:** either add `NeedsSupportAt` and `Admits` to option 1 (linked by `Web.supported_iff_admits`), or move the row out of the group; and state the effect on the two roles rows.

11. **imprecision**: (b) support, Assessment.
    - **Claim:** "naming it a master law would name a premise as a law".
    - **Evidence:**
      - `COVERAGE.json` `premises.items` already lists "balance" (`Flow.Balances`), with witnesses that meet and fail it, beside "activity needing support", "only active relata give" and "dissipation". So being a premise does not separate support from balance.
      - The real difference is that balance has a derived stretch law, while the gate's only consequence is the one-line `DescendsAt.supported_at` (`Evolution.lean:174-181`).
      - `Web.Supported` and `Web.Dependent` are defined in `Dependence` (`Dependence.lean:132-139`), and `Flow.Acting` in `Flow` (`Flow.lean:269-272`), not in World.
    - **Fix:** give that reason, name those modules' owners, and report dissipation (`number_within_take`; 6 central rows) the same way as support rather than as "a law of its model".

12. **imprecision**: (b) Price's identity.
    - **Evidence:**
      - The audit leaves out `Becoming.price` (`Evolution.lean:114-128`, "the counting form of Price's equation"). It has no premise and is reached by `selection_within`, `support_not_lower`, `support_moved_rises` and `closed_lineage_lowered`.
      - "The standing of balance" is loose: the step balance can fail, covariation cannot.
      - Moving it "to the prelude" would also have to move its dependencies `excess` (Change) and `total_congr` (Flow).
      - `levels_sized` speaks of the size-weighted covariance of the means.
    - **Fix:** include `price` in the candidate, or say why it is separate, and note the dependency cascade.

13. **imprecision**: Measure notes 1, `Reach`.
    - **Evidence:** `Reach` is not in `LAWS`. Adding it would credit exactly one of the 50, `Viability.kernel_and_iff`, which the audit itself calls definitional ("uses nothing of it"). The other four central rows that reach `Reach` are already on laws.
    - **Fix:** recast the sentence as a non-recommendation, or drop it.

14. **imprecision**: (c), row `differenceOnlyTogether_iff`.
    - **Evidence:** it uses `Determined` (`Laws.lean:46-50`), which is defined directly. That equals `«定后»` only through `determined_iff_fixed` (`Laws.lean:112-115`), which the row does not use; the row reaches no grammar constant.
    - **Fix:** reword the reason accordingly.

15. **imprecision**: proposals 7 and 8, and the one-step group.
    - **Evidence:** "`WithinMoves` as …" and "`Upstream`/`OnLoop` through `«及»`" do not say whether the definitions in `Labelled` and `Loops` change. `WithinMoves` would also need a bridge between `Trace` and `«迭»` (`Labelled.lean:922-929`). The one-step group would respell a hypothesis of `no_exact_finite_reading`, yet no `Learning` or `LabelledRoles` proposal exists.
    - **Fix:** say "bridge theorems; definitions and statements unchanged", or flag each change and its owner.

16. **imprecision**: derivations stated with grammar names do not move EC's count.
    - **Evidence:** closure's only anchor is `Becoming.WithinClosure` (`measure.py:22`). Derivations through `«及»`, `«所闭»` or `«迭»` (proposals 5–8) would reach the grammar but not the anchor, so the rows stay on "no master law" in 08 §7. Widening the anchor to `«所闭»` would credit 12 return-law rows by mention, because `«定后于»` is defined through it (`GrammarLaws.lean:666`).
    - **Fix:** route these derivations through `WithinClosure`, or state which measure moves.

17. **imprecision**: proposal 1's records.
    - **Evidence:** there is no record named `experiment`. Frame's closure lemmas sit in `levels-of-closure`, and `Invariant.run`, `Invariant.reach` and `Run.reach` are in no record.
    - **Fix:** name `levels-of-closure`.

18. **suggestion**: smaller points.
    - "The counts there" are counts over all 127 rows, not the 77. For example, 7 of the 17 `Web.Supported` rows are among the 50.
    - The rerun dropped return from `Flow.new_beyond_every`: finite runs is now 13, not 14, so 08 §7's "9 of 14" is stale.
    - WHAT-REMAINS's "evolution 18" should be 13; 18 is the size of the evolution row.
    - `measure_grammar.py` has uncommitted OU3c edits, so proposal 13 should be sequenced after OU3c lands.

## Verdict

It needs another pass before the proposals go to module owners.

- **Holds:** the (c) reasons, every record id except "experiment", the row assignments, the 50, and every count except the `ClosedUnder` one.
- **Needs rework:** nine of the seventeen (a) rows (findings 2–6), measure note 1, and the support gate's "stated once" (finding 10).
- **Can go after the named fixes:** proposals 2, 3 and 10; proposal 12, once findings 10–12 are fixed.
- **Should wait for the revision:** proposals 4–9, 11 and 13.

---

## Second pass

The same reviewer, on the fixes alone, of `AUDIT.md` as committed at `c88b74a15`. Verbatim:

**Second pass on the EC6 audit at `c88b74a15`: one error and four imprecisions remain.** I checked only the fixes. Lean paths are relative to `L = /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`. Nothing was edited.

**Your three questions:**
- **The fixes:** 17 of the 18 are resolved. Finding 10 is not: option 1's count is still wrong (finding 1 below).
  - **`onLoop_of_closing`:** correct. `Upstream` is the closure, the coupling step plus `«及当且仅当一步而所闭»` gives `«及» d e`, and `«及之传递»` closes the loop.
  - **`run_shape`:** correct. The product law covers the arbitrary ordered starts.
  - **Invariance rows:** each region is closed under the paced step as stated, and `Run.reach r t k` matches the statements that start at `t + k`.
  - **`keep_pace`:** the two bridges are right.
  - **Optimum:** it now adds a clause to `LAWS` and leaves `Flow.Balances` as it is. That works: the only other central row that reaches `Flow.Outcome` is `Web.course_lost_iff`, already on balance.
- **The two new texts:** the step-indexed candidate matches `answers_closed` and `waitsAll_closed`. The gating assessment is accurate except its count.
- **The counts:** all 50 are listed exactly once. The tables give 5 + 2 + 3 = 10, 9 + 3 + 3 = 15 and 7 + 4 + 14 = 25, matching the summary.

## Findings

1. **error**: (b) gating, option 1, and proposal 8.
   - **Claim:** option 1 credits "11 of the 50, two by mention".
   - **Evidence:** the anchors include `Web.Admits`, which is the order law's basis. `Web.Exceeds` is defined from it (`Admission.lean:392-393`), and the order anchor `Web.Widens` reaches it through `Web.Exceeds`. With `Web.Admits` included, option 1 credits 13 of the 50, four by mention. The two extra rows are both class (c):
     - `Web.significance_undetermined`, which uses `Web.Admits` directly;
     - `ExchangeLaw.response_not_fixed_by_coupling`, through `ofClass_take_iff` and `Web.AlikeThrough.refl`.
     16 of the other 77 rows (the widening and pool-selection rows) reach it as well. With `Web.Admits` removed and `ExchangeLaw.NeedsSupportAt` kept, the count is 11, as the audit states.
   - **Fix:** drop `Web.Admits` from the anchors, and drop `Admission` from the owners in the assessment and in proposal 8.

2. **imprecision**: Method, the test for (a), against the two Optimum rows.
   - **Evidence:** the new sentence says "A row that applies a premise or a closed region once is (c)". `optimum_beyond` and `mutual_beyond` apply the balance clause; they do not re-prove it (`Optimum.lean:1547-1558`, `1789-1850`). As worded, the test puts them in (c).
   - **Fix:** limit the sentence to premises no master law states (N_rel, the gate, a closed region). Add that applying a master law's own clause, inline or by name, is a case of that law, as for the 52 rows on `Flow.Balances`.

3. **imprecision**: Measure note 1, the sentence on widening closure's anchor to `«所闭»`.
   - **Evidence:** 12 central rows reach `«所闭»` without reaching `WithinClosure`.
     - 4 get there through `«定后于»`: `Law.drawn_iff_not_returns`, `Law.lossless_iff_returns`, and the two `RegimeMargin.Adjusted` rows.
     - 8 get there through the rest law's ending, `«尽» («而» («所闭» Q) F) «一»`, for example `Amounts.rests`.
     - Only 9 of the 12 are on return; `Adjusted.comes_to_rest`, `Adjusted.falls_iff_below` and `World.comes_to_rest_unrefuted` are on balance only.
   - **Fix:** say "12 rows that reach `«所闭»` through the finite-runs grammar laws (`«定后于»` 4, `«尽»` 8), 9 of them on return".

4. **imprecision**: the Summary sentence, and option 1's single "gating" law.
   - **Evidence:**
     - The sentence says 15 rows "share three mechanisms" and then lists four things.
     - Option 1 folds two premises into one law. Dissipation is an inequality between amounts given and taken (`Dissipation.lean:238-243`), not a gate on who takes part.
     - The "On the grammar" paragraph covers support only.
   - **Fix:** write "three groups, the first holding two premises". Offer support and dissipation as separate candidates; support alone credits 10 of the 50. Add one line saying dissipation would be represented with amounts, like balance.

5. **imprecision**: "What the review changed", findings 2–4.
   - **Claim:** "nine (a) rows reclassified".
   - **Evidence:** seven were reclassified (2 + 2 + 3). Two were corrected and stayed in (a), as the same paragraph then says.
   - **Fix:** say "seven reclassified, two corrected".

6. **suggestion**: the Optimum proposal (proposal 6).
   - **Evidence:**
     - `mutual_beyond` already depends directly on `Flow.Outcome`, so respelling `Outcome`'s body credits both rows. Respelling `mutual_beyond`'s hypothesis is optional: it only states the clause once in that theorem.
     - Keeping `Flow.Balances` means the step balance is written twice: in its body and in the new clause, linked by an `Iff.rfl` theorem. It is named once but not stated once.
   - **Fix:** say both points, and leave to `Flow`'s owner the choice of defining `Flow.Balances` from the clause.

7. **suggestion**: small completions, none of which change a classification.
   - `onLoop_of_closing`: splitting `Upstream e d` uses `«所闭当且仅当同一或及»` (`GrammarLaws.lean:195`). The converse bridges redo the index-vector joins, so the induction moves into them, as with `keep_pace`.
   - `ends_downstream`: only the direction from `Downstream` to `WithinClosure` is needed.
   - `rule_until_reading`: reading the counter as `t` needs `paced_count` (`Pace.lean:124`).
   - `keep_pace`: bridge (ii) also picks the per-step counts as functions, and `Counts.unique` identifies them with `h`, `h'`, `A` and `D`.
   - Step-indexed rows: they also need a bridge from `Law.run`'s orbit to whatever iterate on regions the grammar adds.
   - `lock_outlives_loss`: `join_course` projects the joined course onto the share's course, rather than making it "the pair of courses". `loss_grows` grows by at least one a step, not exactly one.

## Verdict

Yes for most of them. Proposals 1–7, 9 and 10 can go to module owners now. Proposal 8 (gating) should wait until finding 1 is fixed. Fix finding 2 before EC's owner relies on the (a)/(c) split. Findings 3–7 are wording and can be fixed alongside.
