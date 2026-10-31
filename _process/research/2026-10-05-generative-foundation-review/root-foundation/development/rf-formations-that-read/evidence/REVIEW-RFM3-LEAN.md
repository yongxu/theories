# The review of `Becoming.ListingValuation`

RF round 2, third part, RF-M.3: the valuation as state; informing and revaluing (plan §4.8). The module as first built on the reviewed design (`kit/round2c/tree/Becoming/ListingValuation.lean` at the kit's commit `801f74681`: 105 theorems in 145 declarations, every axiom report empty, [build-1](../kit/round2c/logs/build-1.log)) was reviewed on the Lean on 30 October 2026 in two independent ways: by the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18d75-3522-7a52-87a0-f551210adf5d`), and through three lenses (exactness, structure, sources), each an Opus reader working read-only, with one verifier per lens asked to refute that lens's findings. The prompts are in [the brief](BRIEF.md#round-2-third-part). The reviews follow verbatim; their line numbers are those of the reviewed version, their paths are made relative to the checkout, and their links are made to resolve from this folder, since it is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here shown as its text with its target as code.

**What was verified, and how.** Each lens's verifier judged every finding of its lens: exactness, sixteen of seventeen real (E10 not); structure, nineteen of twenty real (F16 not); sources, all fourteen real. The module was revised on all fifty-one lens findings (the two judged not real taken anyway) and the cross-model reader's fifteen, and rebuilt at the kit's commit `4843dd795`, 129 theorems in 177 declarations, every axiom report empty ([build-2](../kit/round2c/logs/build-2.log)). Three read-only Opus readers, one per lens, then checked from the files alone how each lens finding is reflected in the revised module: forty-four taken and seven in part (F4, F8, F9, F17, F20, L8, L13). Six of the seven were then completed, four with nine more declarations (F8, F9, F17, F20) and two in prose (F4, L13), and L8 stays in part for the re-check's R2 ([the table](#what-was-taken), each row completed after the check saying so); the cross-model reader's own findings were checked by its re-check.

**The re-check.** The revised module was re-checked by the cross-model reader in the session of its review, read-only ([below](#the-re-check)): no new mathematical error; of its fifteen findings ten resolved and five in part, and nine points, all in prose, every one taken ([its table](#what-was-taken-from-the-re-check)). The module's statements did not change for them; its prose was revised and it was rebuilt, 129 theorems in 177 declarations, every axiom report empty ([build-3](../kit/round2c/logs/build-3.log)).

**The check of the delta.** The changes made after the taken check (the nine declarations, the retitled docstrings, the off-switch paragraph citing `undemonstrated_worth`) were rebuilt, 138 theorems in 186 declarations, every axiom report empty, with no warning ([build-4](../kit/round2c/logs/build-4.log)), and checked by the cross-model reader in the session of its review, read-only ([below](#the-check-of-the-delta)): no new problem in the Lean statements, the proofs or the course arithmetic; two low omissions in the header, both taken ([its table](#what-was-taken-from-the-check-of-the-delta)), and the module rebuilt, 138 theorems in 186 declarations, every axiom report empty, with no warning ([build-5](../kit/round2c/logs/build-5.log)).

## The cross-model review

I found no false Lean theorem by inspection. The main corrections are a false sentence in the header, an ambiguity between arbitrary and executable revaluation, and a narrower-than-needed “unshown” result.

I made no edits and ran no Lean, build, render or `make` commands. **Confirmed** below means source inspection, saved-receipt inspection, or the specified read-only arithmetic check—not a new kernel check. Proposed Lean changes remain unchecked.

Locations use **L** for [ListingValuation.lean](../kit/round2c/tree/Becoming/ListingValuation.lean), **P** for [PLAN.md](../PLAN.md), and **R** for [REVIEW-RFM3.md](REVIEW-RFM3.md).

1. **The header incorrectly says that answers differ exactly as residuals do. — Confirmed: statement comparison and arithmetic.**

   **Location:** L:54; compare L:656–668.

   `revalued_split` compares **shortfalls**, by cross-addition. It does not characterize differences between Boolean answers. For one unit-weight candidate with reference gain = loss = 1, reader valuations `(1,0)` and `(0,1)` produce opposite answers, while both residuals are zero.

   The docstring at L:656 is correct. Replace the header sentence with:

   > With the holding model, reading model, reference valuation and map fixed, the shortfalls of two valuations’ answers differ exactly as their residuals do.

   Naming both fixed models also makes clear that `revalued_split` permits `m ≠ pm`.

2. **“Some revaluation gains” needs both its shared-model hypothesis and its unrestricted replacement domain. — Confirmed: quantifier inspection; judgment on the incentive reading.**

   **Location:** L:61, L:111–116, L:705–725, L:1303.

   The theorem correctly assumes one shared model and quantifies over **all functions** `g' l' : C → Nat`. It does not quantify over states in `V`, much less states reachable through `Reader.revalue`.

   Two boundaries matter:

   - With different models, positive residual need not be removable by any replacement scores. A holder can positively weight a negative-net candidate that the reader never lists; the reader releases it under every valuation.
   - Even with a shared model, a supplied update `revalue v x = v` makes every intervention ineffective. Positive residual then establishes an advantageous abstract replacement, not an executable improvement.

   Replace the header’s standalone claim with:

   > With a shared model, some unrestricted replacement valuation improves worth exactly when the current answer has positive residual. Whether such a replacement is reachable under the supplied valuation update is a separate condition.

   The theorem itself is correct. The same qualification should accompany its incentive reading.

3. **The “unshown” implementation proves equal-revelation invariance, not the general absence-of-demonstration case. — Confirmed: signatures and construction.**

   **Location:** L:1468–1509; P:225; R:347 and R:358.

   `inputs_alike` assumes `rd.reveal w = rd.reveal w'`. That suffices for every possible act, including a demonstration. But courses can remain entirely unshown when these revelations differ.

   In particular, with identity revelation and a controller that never demonstrates, the intended uninformed comparison across distinct worlds cannot use `inputs_alike` or `answer_constant`. The current docstrings accurately describe their stronger hypothesis; the implementation is narrower than the general rationale of the design review.

   Keep the existing result and add a version assuming equality of inputs **along the controller’s reachable course**, for example:

   > At every step before the comparison time, the act emitted on the first course produces the same input at both candidate worlds.

   Induction then maintains equality of internal, sensory, active and holding states. A no-demonstration schedule becomes a direct corollary, even with identity revelation. This is the most useful small addition before landing.

4. **The carrier is a faithful `Blanketed` instance, but it implements intervention and answer production rather than a complete holding-and-commitment protocol. — Confirmed: four-map inspection; judgment on wording.**

   **Location:** L:1273–1403, L:1569–1573.

   The four maps satisfy the intended dependency restrictions:

   \[
   i_{t+1}=update(i_t,s_t),\quad
   a_{t+1}=answerOf(i_{t+1}),\quad
   s_{t+1}=input(w_t,act(h_t)),\quad
   (w_{t+1},h_{t+1})=(w_t,next(h_t,a_t)).
   \]

   Thus an act emitted at \(t\) supplies sensory input at \(t+1\), affects the internal state and answer at \(t+2\), and that answer is supplied to the transition producing \(h_{t+3}\). No simultaneously updated field is improperly read.

   Two qualifications belong in the carrier summary:

   - “Read at \(t+3\)” means **available to the holding-state transition producing step \(t+3\)**. Dependence on that answer is not required; `schedule.next` ignores it.
   - `.asked` leaves the internal state unchanged, and the active answer is recomputed every step regardless of whether anyone asks. `.go` and `.off` both generate `.none`; neither executes a different change to `W`.

   Suggested addition:

   > This carrier exposes an answer continuously. Asking does not enable or alter that answer; commitment to its recommended move is not implemented by the schedule witnesses.

   These are disclosed construction boundaries, not defects in `Blanketed`. `world_fixed` concerns only the candidate parameter. `through_sensed` correctly instantiates the existing theorem; it is not an independent discovery of sensory dependence. `updates_commute` is correct because the supplied updates affect separate components.

5. **The residual and identity-revelation criteria are exact, including ties, repeated candidates and zero weights. — Confirmed: proof inspection and 242 arithmetic cases.**

   **Location:** L:180–223, L:288–417, L:456–545.

   The split is correct:
   \[
   S(s)=L_\pi+D_\pi(s).
   \]
   Its subtraction is truncated natural subtraction. At a tied cell, either answer has residual zero. An empty or entirely zero-weight cell also contributes zero. There is no mistaken identification of residual with Boolean disagreement.

   The hypotheses are appropriately differentiated:

   - `shortfall_split` requires cells listed once and covering **the holder’s listing**.
   - `residual_zero_iff`, `residual_pos_iff`, and `answer_residual_zero_iff` concern the displayed residual total; they need neither coverage nor distinctness.
   - The scaled and net sufficient conditions use the shared model and require agreement only at listed candidates of positive weight.
   - `told_residual_zero_iff` needs coverage but not distinct cells: repeating a nonnegative summand does not alter whether its total is zero.
   - Candidate listings may repeat. `weightOf` correctly counts multiplicity: two occurrences with weight 2 give effective weight 4.
   - The identity-map support requirement is needed only at holder-positive candidates with `gain < loss`. Missing positive-net candidates default to the correct release.

   **Replacement:** Keep the mathematics. Add one header sentence making the computational premise explicit:

   > Cell equality is decidable wherever cells are compared or listings filtered.

   The plan names this premise; the module header currently leaves it implicit.

6. **`SplitsKeep` is the right criterion; its quantification and coverage wording need minor clarification. — Confirmed: proof inspection and exhaustive finite check.**

   **Location:** L:761–772, L:868–962, L:1079–1139; P:209.

   The proof establishes the proposed iff. Sufficiency groups a coarse cell into the candidates released and stopped by the finer answer. Necessity tests a two-cell map against the corresponding three-cell split, leaving the complement unchanged. This avoids assuming a finite distinct candidate universe.

   I independently checked all **15,625 pairs of three-candidate signed-margin tables** with margins in `[-2,2]`, against all 12 partition-refinement pairs. The criterion and monotonicity agreed throughout. This supports the inspection; it does not replace the Lean proof.

   Clarify three points:

   - `B` and `D` are Boolean-tested subsets, not unrestricted predicates.
   - Factorization is required on **both** `m.listed` and `pm.listed`. This is essential: a reader-only candidate can change the answer at a holder-supported cell.
   - The coarse cell list covers only `m.listed`; the fine cell list covers both listings. The docstring’s “covering both listings” is stronger than the displayed hypotheses.

   Replace the docstring with:

   > Over every pair of maps factoring on both models’ listings, with distinct coarse cells covering the holding listing and distinct fine cells covering both listings, refinement never lowers worth exactly when `SplitsKeep` holds.

   The criterion can be vacuous when the reader always releases—for example, when its loss never exceeds its gain candidatewise. That is appropriate: every refinement then leaves the policy unchanged, even if the policy is poor under the reference. This is a criterion for **monotonicity under refinement**, not for alignment or optimality.

7. **The remaining comparison laws have the correct orientations and references; several departures from the plan improve generality. — Confirmed: statement inspection and 7,125 cost comparisons.**

   **Location:** L:560–746.

   - `informed_le` correctly needs no coarse cell list. The coarse rule is merely pulled through the factor map. Factorization on the holder’s listed candidates suffices. Its explicit `[DecidableEq K]` for the coarse codomain is unused; remove it here and in `informed_answer_le`. The fine codomain’s decidable equality remains necessary.
   - `withhold_iff` has the correct cost orientation:
     \[
     H(r')+k<H(r)+k'
     \iff S(r)+k<S(r')+k'.
     \]
     It uses cross-addition, not truncated net-worth subtraction.
   - `withhold_through_iff` correctly applies to arbitrary maps. Refinement is needed only for the subsequent interpretation of a decrease in least shortfall.
   - `own_least` is usefully stronger than comparison with another valuation’s answer: it compares against **every rule through the map**.
   - `revalued_lowers_iff` evaluates both answers by the **old** valuation.
   - `outcome_least` evaluates the revised answer by the **revised** valuation, with the same model on both sides. It proves no cross-valuation ordering.
   - `const_worth` and `const_below_iff` require constancy only on the holder’s listing. Positive forgone amount, rather than merely a supplied amount, is correctly necessary for strict loss.

   **Replacement:** Remove the unused coarse equality instances; otherwise retain these statements. In the Standing paragraph, describe `informed_le` specifically as composing `finer_least_le` with `shortfall_split`.

8. **The numerical witnesses pass; distinguish static comparisons from executed courses. — Confirmed: arithmetic and transition simulation.**

   **Location:** L:1147–1266, L:1610–1653.

   The principal Part 1 numbers are correct:

   | Witness | Worth | Shortfall | Least shortfall | Residual |
   |---|---:|---:|---:|---:|
   | `Informing`, one cell | 10 | 1 | 1 | 0 |
   | `Informing`, identity | 0 | 11 | 0 | 11 |
   | `Weights`, one cell | 3 | 1 | 1 | 0 |
   | `Weights`, middle partition | 2 | 2 | 1 | 1 |
   | `Weights`, identity | 4 | 0 | 0 | 0 |

   `Revaluing.revaluing_best` gives worths **1, 1, 1, 2**, against best worth 2. `scales_by_candidate` gives residual 1; `unweighted_told` gives shortfall 1; `no_order_across` gives attained values 10 and 2 under their respective reference valuations.

   The four intervention cases also compute correctly:

   | Start and intervention | Answer at 0 and 1 | Answer from 2 |
   |---|---|---|
   | Both worlds, `agree`; demonstrate | stop | release |
   | Both worlds, `agree`; present `raised` | stop | stop |
   | First world, `reversed`; demonstrate | stop | stop |
   | First world, `reversed`; present `agree` | stop | release |

   However, `shown_turns` and `presented_turns` themselves state **one-update answer calculations**, not course-time statements. Only the two turning routes receive explicit course theorems. Similarly, Part 1’s “four courses” are four static policy-value comparisons.

   **Replacement:** Call the latter “four one-decision alternatives.” Either describe the four carrier cases as update calculations instantiated at step 2, or add the two short course lemmas for the non-turning alternatives. Their numbers need no correction.

9. **The route non-identifiability witness is sound, and stronger than the header’s endpoint wording. — Confirmed: definitions, proof inspection and simulation through step 6.**

   **Location:** L:1590–1608, L:1655–1734; header L:85–88.

   There is no circularity: `changed` is computed from successive valuation states independently of `record`. Its meaning is a transition \(t\to t+1\) with \(t<T\), so the transition from 1 to 2 is correctly included at \(T=2\).

   `answersBefore` records answers at times \(0,\ldots,T-1\). Omitting the answer at \(T\) does not manufacture the result: `answers_alike` proves agreement at every time, and `routes_rest` proves equality of the **whole joint configuration** from step 2 onward.

   The bound \(T\ge2\) is necessary for this witness: before then the internal endpoints differ, and the revaluation has not yet occurred. Different starts are legitimate because the observation omits them. Adding the initial internal state or the sensory/intervention history separates these two routes.

   Replace the header summary with:

   > These two routes start from different internal states. They have identical answers at every step and identical whole configurations from step 2 onward, but only the presented route changes valuation. For every \(T\ge2\), the specified finite record therefore fails to determine that route property.

   This also restores the observation boundary explicitly promised by review-table row 15. The result establishes neither ambiguity from one fixed start nor a test of legitimate preference change.

10. **Several helper proofs duplicate available axiom-free lemmas. — Confirmed: source comparison and matching saved receipt.**

   **Location:** L:204, L:368, L:372, L:637, L:845, L:855.

   I checked the following declarations’ empty `axiom_dependencies` in the saved [verification receipt](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks/20261030T134037.582088Z/verification.json). The relevant current source hashes match that receipt.

   | New helper | Existing declaration to reuse | Replacement |
   |---|---|---|
   | `sub_pos_of_lt_core`, L:205 | `Becoming.SupportGated.sub_pos_of_lt`, [Prelude.lean:616](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Prelude.lean) | Direct application; already imported |
   | `le_of_add_eq_of_le`, L:369 | `HeldForReading.across_le_iff`, [HeldForReading.lean:759](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean) | `(across_le_iff (k := 0) eq).mp le` |
   | `lt_of_add_eq_of_lt`, L:373 | `HeldForReading.across_lt_iff`, [HeldForReading.lean:771](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean) | `(across_lt_iff (k := 0) eq.symm).mp lt` |
   | `lt_add_self_iff`, L:638 | `Becoming.lt_iff_pos`, [Flow.lean:247](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Flow.lean) | `lt_iff_pos rfl` |
   | `total_lt_of_mem`, L:846 | `Becoming.Loops.total_lt`, [Loops.lean:149](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Loops.lean) | Same statement; currently outside the import closure |
   | `cond_zero_le`, L:856 | `Becoming.Weighting.term_le_of`, [Weightings.lean:498](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Weightings.lean) | Same statement; currently outside the import closure |

   For the last two, coordinate extraction to a suitable shared dependency rather than importing a large unrelated module solely for a helper. `Flow.total_lt_of_le_of_mem` in [Regulation.lean:437](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Regulation.lean) is another existing empty-axiom version of the strict total comparison.

   The other reuse is largely good:

   - Ordinary totals, congruence, zero totals and cell regrouping reuse the existing declarations.
   - `total_cond_by_cells` generalizes the calculation inside `shortfall_through`; it is a useful factoring of that argument, not another mathematical result.
   - `total_filter_shows` uses the existing filter-cons lemmas. I found no existing exact general filtered-total identity to substitute.
   - The specialized Boolean split lemmas encode new expressions; the general Boolean projection facts already use `ListTests`.
   - I found no exact package duplicate for `lt_of_sub_pos_core`.

11. **The relational framing and most names are appropriate; the Standing paragraph should distinguish general laws, identities and witnesses more explicitly. — Judgment grounded in AGENTS and method; confirmed declaration classification.**

   **Location:** L:6–18, L:90–106, L:162 and subsequent shard headings.

   `ListingValuation`, `within`, `residual`, `weightOf`, and `SplitsKeep` describe their structures accurately. The two formation roles are introduced through a joint transition’s sensing and control paths. No independent-subject ontology or ethical warrant is smuggled into the mathematics.

   Keep the names rather than undertaking a cosmetic renaming sweep. Two small text changes would improve exactness:

   > General finite-weight laws: the residual criteria and refinement criterion. Arithmetic identities and supporting compositions: the split and worth comparisons. Definitional carrier equations and finite executable witnesses: `joint` and `Routes`.

   Remove production shard labels such as `(G0)`, `(GA)` and `BEGIN GB` from the landing version. In particular, `G0` is liable to be confused with the repository’s retired theory label.

   The saved build summary agrees with 105 theorems and 145 named audited declarations, with no reported axiom dependencies. There are also two anonymous equality instances; their definitions are elementary case analyses and their uses are reached through audited declarations. I did not independently rerun the audit.

12. **The literature correspondences are fair at their stated limits. — Confirmed primary-source comparison, except the explicitly limited Blackwell check.**

   **Location:** L:45, L:108–139.

   | Source | Assessment and replacement, if needed |
   |---|---|
   | **Blackwell (1953)** | “Deterministic-refinement, fixed-decision direction” is appropriately narrow. This is policy simulation under a finer partition, not Blackwell’s full equivalence across decision problems. I checked the original abstract reproduced in the [collected bibliography](https://celebratio.org/Blackwell_DH/article/26/); the publisher blocked full-text retrieval. **Judgment supported by that abstract and the inspected proof**, not a full-paper verification. Keep the wording. |
   | **Kamenica–Gentzkow (2011)** | Correct: under common prior and identical objectives, full disclosure is weakly optimal. Convexity concerns the induced optimal-value function in beliefs, not arbitrary raw scores. The header correctly excludes optimal signal commitment. Add “after normalizing nonzero effective total weight” when making the probability correspondence; conditional beliefs require positive cell mass. [§III](https://web.stanford.edu/~gentzkow/research/BayesianPersuasion.pdf). |
   | **Crawford–Sobel (1982)** | Correctly related, not contained. Their partitions arise in Bayesian Nash equilibrium; these maps are supplied truthful observations. The exclusions of credibility, endogenous partitions and cheap-talk equilibrium are necessary and sufficient here. [Paper](https://www.haverford.edu/sites/default/files/CrawfordSobel1982.pdf). |
   | **Everitt et al. (2021)** | The evaluation analogy is fair. Their Claims 2 and 3 concern causal incentives under explicit privacy, state-dependence and, for Claim 2, uninformativeness assumptions. `own_least` instead follows from already optimizing a fixed valuation over cell rules. The header says this correctly. [§3.2](https://arxiv.org/pdf/1908.04734). |
   | **Farquhar–Carey–Everitt (2022)** | Correctly excludes a constructed path-specific objective. Proposition 1 uses the delicate state under a baseline action in a nested counterfactual. Merely freezing the final evaluator does not cut the path through a changed valuation to the chosen answer. Keep the existing qualification. [Proposition 1](https://ojs.aaai.org/index.php/AAAI/article/download/21186/20935). |
   | **Hadfield-Menell et al. (2017)** | Correct as a restricted correspondence. Theorem 1 gives weak optimality with rational response and strict advantage with support on both strict utility signs; Remark 1 joins uncertainty with effective choice. A constant answer supplies no strict advantage, not zero absolute worth. Finding 3 identifies the missing general unshown implementation. [Theorem 1 and Remark 1](https://arxiv.org/pdf/1611.08219). |
   | **Carroll et al. (2022)** | Fair: they compare preference trajectories with supplied safe-shift baselines and describe the initial-preference baseline as crude. The Lean witness neither estimates those trajectories nor judges manipulation. Its specific historical-property limitation is correctly stated. [§5](https://arxiv.org/pdf/2204.11966). |

13. **The 25-row “What was taken” table is substantially accurate, with the following qualifications. — Confirmed crosswalk; judgments identified above.**

   **Location:** R:333–359. “Taken” below means the implemented content and header agree, subject to the numbered findings above.

   | Review row | Lean/header disposition |
   |---:|---|
   | 1 | Taken: L:90–106 distinguishes contribution and supporting compositions. Refine the classification as in finding 11. |
   | 2 | Taken: L:288–349 correctly handles strict preference, ties and zero-weight cells. Add decidable equality to the header. |
   | 3 | Taken: L:355–417 gives the exact criterion and both sufficient conditions; L:1153 gives the differing-scales witness. |
   | 4 | Taken: L:566 and L:1224 preserve model/weight distinctions and support-local factorization. |
   | 5 | Taken: L:492 and L:1167 implement the exact support condition and counterexample. |
   | 6 | Taken: L:1182, L:1194 and L:1261 have the specified numbers. |
   | 7 | Taken: L:687 uses strict weighted cell preference under the old reference. |
   | 8 | Taken: L:701 and L:1237 avoid cross-valuation endorsement. |
   | 9 | Taken: L:735 uses positive effective forgone amount and cross-addition. |
   | 10 | Taken structurally: L:1352 has the four maps. “Read” and single-use scheduling need the qualifications in finding 4. |
   | 11 | Lean taken; header partly misstated at L:54. Apply finding 1. |
   | 12 | Taken as an update identity at L:1446. Explicit timing is supplied by the carrier equations; positive-mass probability qualification remains in the plan rather than this docstring. |
   | 13 | Partly taken: L:1471 uses equal possible revelations, stronger than equality of actually received inputs. Apply finding 3. |
   | 14 | Numerical cases taken at L:1613 and L:1621; two are direct update witnesses rather than separately stated course witnesses. |
   | 15 | Lean taken: independent history property and exact final state. Header should repeat differing starts and \(T\ge2\). |
   | 16 | Taken: finite records, pointwise course equality and explicit finite equality instances. |
   | 17 | Taken: L:1126 proves the proposed iff, generalized appropriately to finite weighted listings. |
   | 18 | Taken with the table’s disclosed limitation: comparison and four alternatives, no implemented minimizing choice. |
   | 19 | Taken: restricted Blackwell and persuasion wording; probability normalization caveat recommended. |
   | 20 | Taken: strategic communication is related, not represented as equilibrium. |
   | 21 | Taken: evaluation analogy only; draft projection lemmas dropped. |
   | 22 | Taken: no path-specific objective claimed. |
   | 23 | Taken: specific route property, no legitimacy test. |
   | 24 | Reading taken; generic unshown theorem remains narrower, as in finding 3. |
   | 25 | Taken: relational opening, reference valuation, residual, fixed candidate parameter and module name. Remove shard tags before landing. |

   **Replacement:** Amend the statuses or explanations for rows 11, 13 and 24; qualify rows 10, 12, 14 and 15 rather than reporting unqualified completion.

14. **All 21 plan items have implementations; the departures are mostly justified generalizations. — Confirmed statement-by-statement comparison.**

   **Location:** P:204–227.

   | Item | Implementation | Assessment |
   |---:|---|---|
   | 1 | L:230–247 | Exact definition and tie convention. |
   | 2 | L:291–349 | Exact split and criteria; criteria correctly require fewer hypotheses than the split. |
   | 3 | L:355–417; L:1153 | Exact; shared model only in sufficient conditions. |
   | 4 | L:492; L:1167 | Exact; dropping cell distinctness is right. |
   | 5 | L:566–597 | Stronger correctly: arbitrary finer rule; no coarse cell list. Remove unused coarse equality instance. |
   | 6 | L:766; L:1126 | Exact criterion. Clarify Boolean subsets, both factorization supports and asymmetric cell coverage. |
   | 7 | L:603–629 | Exact, and generalized correctly to arbitrary rules/maps. |
   | 8 | L:659 | Correct with separately fixed holder and reader models. Header correction required. |
   | 9 | L:1194 | Numbers and comparisons correct. |
   | 10 | L:1224 | Numbers correct; residual falls on the second refinement. |
   | 11 | L:675–697 | Correctly strengthened to all cell rules; strict-loss iff exact. |
   | 12 | L:701; L:1237 | Correct revised-reference statement and opposing numerical directions. |
   | 13 | L:709 | Exact for unrestricted score replacement with shared model; not an executable-update iff. |
   | 14 | L:1261 | Correct static four-alternative witness; no selection mechanism. |
   | 15 | L:441; L:735–746 | Exact, including support-local constancy and positive cost. |
   | 16 | L:1275–1357 | Correct carrier; no implemented commitment effect on `W`. |
   | 17 | L:1361–1411 | Correct instance and update identity; no general course commutation claimed. |
   | 18 | L:1446 | Exact pointwise pre-demonstration-model identity; timing obtained compositionally. |
   | 19 | L:1471–1509 | Correct stronger-premise version; add the actual-input/no-demonstration version. |
   | 20 | L:1613–1653 | Four update cases and shortfall interpretations correct; course-time packaging incomplete for the two non-turning cases. |
   | 21 | L:1664–1734 | Correct executable non-identifiability for every \(T\ge2\), with complete answer-course agreement. |

   **Replacement:** Update P:208’s unnecessary “cell lists for both,” P:209’s coverage wording, and make item 13’s unrestricted replacement domain explicit. Keep the other justified widenings.

15. **The most useful strengthening is an exact criterion for reachable, costly revaluation. — Judgment; algebra follows from inspected identities.**

   **Location:** L:603, L:659, L:709, L:1303.

   Fix both models, the reference and the map, and write \(D(v)\) for the residual of the answer generated by valuation state \(v\). For an actually available replacement \(v'\), with respective costs \(k,k'\), the useful criterion is:

   \[
   \text{replacement improves net worth}
   \iff D(v')+k'<D(v)+k.
   \]

   Quantify \(v'\) over states reachable by the supplied update—or initially over one presented input. This connects the algebra to the carrier without assuming that every score function is realizable. If a zero-residual state is reachable, the maximum gross recoverable amount is exactly the current residual; reaching it is worthwhile precisely when the additional cost is smaller.

   I would add this and finding 3’s unshown corollary before landing. A smaller optional strengthening is a same-start witness showing that demonstration and presentation commute at the final internal state while producing different intermediate answer courses. For institutional or network applications, these are useful local components; the module still supplies no law of collective decision, disagreement resolution or coordinated implementation.

**Verdict:** The module is mathematically coherent on inspection, and the saved build evidence supports its claimed pure-core status. The residual decomposition, support criterion and all-refinements iff survive the requested checks; the numerical and executable route witnesses also pass. I would land after correcting the header’s answer/shortfall error, separating unrestricted replacement from reachable revaluation, broadening or explicitly narrowing the unshown claim, and removing the readily reusable helper proofs. Present the contribution as exact finite-weight comparisons connected to an intervention-and-answer carrier—not as a general assistance, preference-change or coordination theorem.

## The exactness lens

17 findings, each judged by the verifier: 16 real, 1 not. The verdict follows each finding.

### E1 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:42,45-47 (header); :1123-1125 (docstring of refining_never_lowers_iff); :1129-1132 (statement)

**Quoted.** **Informing** (a map telling apart all a coarser one does on the listed candidates) … Over every refinement, with no shared model or valuation assumed, holding for the answer never stands lower through the finer map exactly where splits keep the worth (`SplitsKeep`, `refining_never_lowers_iff`)  |  docstring: "holding for the answer through a map stands at least as high as through every map it refines, with cells listed once each and covering both listings, exactly where splits keep the worth"

**Problem.** The header and docstring leave out a hypothesis the iff depends on. On its left side, `refining_never_lowers_iff` quantifies only over refinements that factor on BOTH formations' listings: `(∀ c, c ∈ m.listed → π c = f (π' c)) → (∀ c, c ∈ pm.listed → π c = f (π' c))` (line 1129). Its finer cells cover both listings; its coarser cells cover only the holding formation's: `(∀ c, c ∈ m.listed → π c ∈ zs)` (line 1130). The header defines informing "on the listed candidates". `informed_le` uses that notion on the holding formation's listing alone: its docstring (lines 561-562) and its `factors` hypothesis (line 567). The iff's docstring never states the factoring at all, and "covering both listings" is true only of the finer cells. The second factoring is essential, as this counterexample shows. m lists c1 (weight 1, gain 0, loss 1). pm lists c1 and c2 (weight 1 each; g/l are 0/1 at c1 and 5/0 at c2). π puts c1 and c2 in cells z1 and z2. π' puts both in one cell y with f y = z1, so it factors on m's listing only. The coarse answer stops c1 (worth 1) and the finer answer releases it (worth 0). Yet SplitsKeep holds: the only admissible pairs are D = {c1} with B ⊆ {c2}, and both consequences hold (0 ≤ 0, and gain 0 ≤ loss 1). This was checked by enumeration. So the header's iff, read with informed_le's notion of informing, is false. The Lean statement is right.

**Replacement.** Header: "Over every refinement on both listings (`π c = f (π' c)` at every candidate either formation lists; the finer map's cells listed once and covering both listings, the coarser's covering the holding formation's), with no shared model or valuation assumed, holding for the answer never stands lower through the finer map exactly where splits keep the worth (`SplitsKeep`, `refining_never_lowers_iff`); factoring on the holding formation's listing alone, as in `informed_le`, does not suffice." Docstring: "holding for the answer through a map stands at least as high as through every map it refines on both listings (factoring at every candidate either formation lists), the finer map's cells listed once each and covering both listings and the coarser's covering the holding formation's, exactly where splits keep the worth."

**Verdict: real.** The Lean left side requires `π c = f (π' c)` on both listings (line 1129), with the coarse cells covering only the holding formation's listing (line 1130). The header calls informing a map telling apart all a coarser one does "on the listed candidates", and informed_le reads that as the holding formation's listing alone (lines 561-562, 567). The docstring gives no domain for "refines". I reran the counterexample: π' factors on m's listing only, the coarse answer is worth 1 and the finer 0, and SplitsKeep holds by enumeration, so factoring on both listings is essential. The proposed text leaves out that the coarse cells must also be listed once (`List.Pairwise … zs`). It also adds a "does not suffice" claim that no Lean witness backs.

### E2 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:60-61 (header), :113-114 (Readings), :709-713 (statement)

**Quoted.** Some revaluation gains by the reference exactly where the current answer's residual is positive (`revaluing_gains_iff`)

**Problem.** Two passages drop a hypothesis the result needs. The statement holds only when the reading formation's model is the holding formation's: both answers are `answer m g l π` and `answer m g' l' π` (lines 711-713). The header sentence switches to "by the reference", so it does not carry the preceding sentence's "its model the holding formation's". The Readings sentence ("Under a reference the valuation differs from, … and some revaluation gains exactly where its current answer decides a cell against the reference") also drops it. The model hypothesis is essential for the converse. Take pm listing nothing: every valuation's answer releases every cell, so no revaluation gains. Yet for one candidate of holding weight 1 with gain 0 and loss 1, the current answer's residual is 1.

**Replacement.** Header: "With its model the holding formation's, some revaluation gains by the reference exactly where the current answer's residual is positive (`revaluing_gains_iff`); with another model it need not (a reading formation listing nothing releases under every valuation)." Readings: "… and, with a shared model, some revaluation gains exactly where its current answer decides a cell against the reference (`revaluing_gains_iff`)".

**Verdict: real.** revaluing_gains_iff is stated with `answer m g l π` and `answer m g' l' π`, so the reading formation's model is the holding formation's (lines 711-713). The header's new sentence ("Some revaluation gains by the reference …") and the Readings' "Under a reference the valuation differs from …" do not restate this. The previous sentence's condition cannot carry over as a whole, because its reference differs. With pm listing nothing, every valuation releases, so nothing gains, yet the residual is 1 (checked numerically). The proposed parenthetical "with another model it need not (…)" is itself a claim no Lean states.

### E3 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:73-74 (header); :1405-1406 (updates_commute docstring)

**Quoted.** a filter and a revaluation commute as updates (`updates_commute`), the courses they are part of need not.

**Problem.** The second clause is a statement the header and docstring promise and the Lean lacks. `updates_commute` (lines 1407-1411) proves only the update identity. No theorem exhibits two courses that differ, so "the courses … need not [commute]" (an existence claim) is unproved. It is true on the module's own witness law. From `([.first, .second], .raised)` with schedule `[.demonstrate, .press .agree]`, the answer at step 2 is release (listing `[.first]` under raised: 1 against 0). With schedule `[.press .agree, .demonstrate]` it is stop (both listed under agree: 1 against 2). Both courses reach `([.first], .agree)` at step 3. This was checked by hand and by simulation.

**Replacement.** In namespace Routes:
/-- **The courses need not commute** (item 17): from both worlds listed and `raised`, demonstrating then presenting `agree`, or the converse, reach one state at step 3, while at step 2 the first releases and the second stops. -/
theorem courses_apart :
    ((joint rd schedule).course
        ⟨([.first, .second], .raised), .none, true, (.first, [.demonstrate, .press .agree])⟩ 2).active = false ∧
      ((joint rd schedule).course
        ⟨([.first, .second], .raised), .none, true, (.first, [.press .agree, .demonstrate])⟩ 2).active = true ∧
      ((joint rd schedule).course
          ⟨([.first, .second], .raised), .none, true, (.first, [.demonstrate, .press .agree])⟩ 3).internal =
        ((joint rd schedule).course
          ⟨([.first, .second], .raised), .none, true, (.first, [.press .agree, .demonstrate])⟩ 3).internal :=
  ⟨rfl, rfl, rfl⟩
and cite `Routes.courses_apart` after "need not" in the header and the docstring. Otherwise reword both to "nothing here says the courses they are part of commute".

**Verdict: real.** updates_commute (lines 1407-1411) proves only the identity of the two composed updates. No declaration shows two courses that differ, so "the courses … need not" is unproved. I simulated the proposed witness on `joint rd schedule`. At step 2 it answers false on the demonstrate-first route and true on the agree-first route, and both routes have internal ([first], agree) at step 3. course is Law.orbit, and the existing witnesses on the same law close by rfl, so ⟨rfl, rfl, rfl⟩ should check.

### E4 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:204-207 (uses at :219, :223, :523)

**Quoted.** /-- As `Nat.sub_pos_of_lt`, with an empty axiom report. -/ theorem sub_pos_of_lt_core {m n : Nat} (lt : m < n) : 0 < n - m :=

**Problem.** This reproves a package lemma that is already in the import closure with an empty axiom report: `SupportGated.sub_pos_of_lt : ∀ {d c : Nat}, d < c → 0 < c - d` (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Prelude.lean:616). The imported module HeldForReading already uses it at HeldForReading.lean:352 (`SupportGated.sub_pos_of_lt lt`).

**Replacement.** Delete `sub_pos_of_lt_core` and write `SupportGated.sub_pos_of_lt lt` at lines 219, 223 and 523.

**Verdict: real.** `SupportGated.sub_pos_of_lt : ∀ {d c : Nat}, d < c → 0 < c - d` is at Prelude.lean:616. It is proved by structural recursion from Init's Nat lemmas. Prelude is in HeldForReading's import closure and is a core module of the passed verification record, and HeldForReading.lean:352 already uses it. So its axiom report is empty, and the local `sub_pos_of_lt_core` duplicates it.

### E5 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:377-384 (also header :35-37)

**Quoted.** `q * g c + p * loss c = q * l c + p * gain c` with `p` and `q` positive, the answer has no residual.  |  {p q : Nat} (p_pos : 0 < p) (q_pos : 0 < q)

**Problem.** `q_pos` is a superfluous hypothesis; only the proof uses it (line 399). At q = 0 the hypothesis reads `p * loss c = p * gain c`. With p > 0, gain and loss then agree at every listed candidate of positive weight, so both excesses are nothing in every cell (as in `within_congr_weighted`), and every rule's residual is nothing. `p_pos` is needed: p = 0 forces g = l there, the answer releases everywhere, and a cell with N > P keeps a residual. The theorem is weaker than it need be, and "with `p` and `q` positive" overstates what it needs.

**Replacement.** Drop `(q_pos : 0 < q)` and case on `Nat.eq_zero_or_pos q`; at q = 0, close by `residual_zero_iff` with both excesses nothing. Alternatively, keep it and say in the docstring: "`q` positive only so that the condition reads as a scale; at `q = 0` it makes gain and loss equal at every weighted candidate, and every rule has no residual."

**Verdict: real.** At q = 0 the hypothesis is `0 * g c + p * loss c = 0 * l c + p * gain c`. With p > 0 this gives loss c = gain c at every weighted listed candidate. Both excesses then vanish (within_congr_weighted) and so does every residual, and a random search found no counterexample. p_pos is needed, since at p = 0 the answer releases everywhere and a cell with N > P keeps a residual. The q = 0 case is provable without axioms from Nat.eq_zero_or_pos and Nat.le_of_mul_le_mul_left (already used at line 409) with Nat.le_antisymm. q_pos is used only at line 399.

### E6 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:486-487 (headline), :495-496 (statement), :1163-1171 (witness unweighted_told)

**Quoted.** **Told the candidate, the answer falls short exactly where an unweighted candidate is one to stop** (item 4)

**Problem.** The headline states a different quantity, and a looser condition, than the theorem proves. The statement is about the residual (`residual m gain loss id zs (answer pm g l id) = 0 ↔ …`, with `covers` and no `once`), not the shortfall. Positive shortfall is equivalent here, but only through steps the module never states: that the least shortfall through the identity map is nothing, and, for equality of the two, `shortfall_split`, which needs `once`. "An unweighted candidate" also omits that the holding formation must weigh the candidate positively; a candidate both formations leave unweighted adds nothing. The witness `unweighted_told` proves the shortfall (1) and not the residual, so the criterion and its witness are about different quantities.

**Replacement.** Headline: "**Told the candidate, the answer has a residual exactly where a candidate the holding formation weighs, unweighted by the reading formation, is one to stop**". Add to `unweighted_told`: `∧ residual ⟨[()], fun _ => 1⟩ (fun _ => 0) (fun _ => 1) id [()] (answer (⟨[()], fun _ => 0⟩ : Model Unit) (fun _ => 0) (fun _ => 1) id) = 1` (by `rfl`).

**Verdict: real.** told_residual_zero_iff states `residual … = 0 ↔ …` with `covers` and no `once`. The headline says the answer "falls short", which equals the residual here only through steps the module never states: the least shortfall through `id` is nothing, and shortfall_split, which needs `once`, applies. "An unweighted candidate" also leaves out positive holding weight. unweighted_told proves the shortfall (1), not the residual; the residual is also 1 (computed).

### E7 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:96-98 (Standing)

**Quoted.** `shortfall_split` is an identity on `shortfall_through` and `least_through`; … `own_least`, `outcome_least` and `revaluing_gains_iff` compose `least_through` with `answer_least_of_net`

**Problem.** Two dependency claims in the Standing do not match the proofs. `shortfall_split` (lines 303-306) uses `shortfall_through` and `cond_split_least` on the definition `leastThrough`, not the theorem `least_through`; `least_through` follows from the split, since the residual is a natural number. `outcome_least` (lines 701-703) is `answer_least_of_net` at the revised valuation alone and uses no `least_through`.

**Replacement.** "`shortfall_split` is an identity on `shortfall_through` and the definition `leastThrough` (`least_through` follows from it); … `own_least` and `revaluing_gains_iff` compose `least_through` with `answer_least_of_net`, and `outcome_least` is `answer_least_of_net` at the revised valuation".

**Verdict: real.** shortfall_split's proof (lines 303-306) rewrites by shortfall_through, then uses cond_split_least, total_congr and total_add on the definition leastThrough. It never uses the theorem least_through. outcome_least (lines 701-703) is answer_least_of_net at (g', l') alone. own_least and revaluing_gains_iff do use least_through with answer_shortfall_least, so the rest of the sentence stands.

### E8 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:54; :42-44

**Quoted.** two valuations' answers differ exactly as their residuals do (`revalued_split`)

**Problem.** Two header sentences compress their statements inexactly. First, `revalued_split` (lines 659-663) says the answers' shortfalls differ as their residuals do. The Boolean answers themselves can differ at tied or unweighted cells while the residuals are equal. Second, the Informing bullet cites `informed_answer_le` for "holding for it stands at least as high" without its hypotheses: the reading formation's model the holding formation's, and net agreement at every listed candidate of positive weight (lines 589-590). `Informing.informing_lowers` shows the conclusion fails without them.

**Replacement.** "two valuations' answers have shortfalls that differ exactly as their residuals do (`revalued_split`)"; "… and holding for it stands at least as high (`informed_le`); with the holding formation's model and net agreement, the answer is such a rule (`informed_answer_le`)".

**Verdict: real.** revalued_split equates shortfall-plus-residual sums (lines 661-663). Two Boolean answers can differ at tied or unweighted cells while their residuals are equal, so "answers differ exactly as their residuals do" is inexact; the theorem's own docstring has the exact wording. informed_answer_le also needs a shared model and net agreement (lines 589-590), which the Informing bullet does not state. In the proposed text, "the answer is such a rule" is answer_least_of_net's content, not informed_answer_le's.

### E9 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:339-340 (unweighted_cell), :1255-1260 (Revaluing.revaluing_best), :1670 (Routes.answers_alike), :615-617 (withhold_through_iff)

**Quoted.** and adds nothing to any residual  |  going on, switching off and holding for the answer are each worth 1, falling short by 1  |  stop at steps 0 and 1, release from step 2 on  |  With equal amounts, holding for a coarser answer stands above holding for a finer one exactly where the finer answer's residual exceeds the coarser's by more than the least shortfall falls.

**Problem.** These docstrings assert content their statements do not contain; all of it is true, none of it is stated. `unweighted_cell` proves only that both excesses are nothing (line 343). `revaluing_best` proves the worths 2, 1, 1, 1, 2, not the shortfalls 1, 1, 1, 0. `answers_alike` proves that the two routes' answers are equal, not their values at steps 0 and 1. `withhold_through_iff`'s second sentence is a corollary at `k = k'` that needs `π'` finer (`finer_least_le`) for the least shortfall to "fall"; the statement itself takes any two maps and any rules, not answers.

**Replacement.** `unweighted_cell`: add `∧ ∀ b : Bool, cond b (goExcessWithin m gain loss π z - offExcessWithin m gain loss π z) (offExcessWithin m gain loss π z - goExcessWithin m gain loss π z) = 0`. `revaluing_best`: add `∧ shortfall model gain loss (fun _ => false) = 1 ∧ shortfall model gain loss (fun _ => true) = 1 ∧ shortfall model gain loss (fun c => answer model (fun _ => 0) (fun _ => 1) id c) = 1 ∧ shortfall model gain loss (fun c => answer model gain loss id c) = 0` (each `rfl`). `answers_alike`: add `theorem answers_start (b : Bool) : ((joint rd schedule).course (route b) 0).active = true ∧ ((joint rd schedule).course (route b) 1).active = true := match b with | false => ⟨rfl, rfl⟩ | true => ⟨rfl, rfl⟩`. `withhold_through_iff`: "Read at equal amounts with `π'` finer than `π` (`finer_least_le`), …".

**Verdict: real.** Each statement is narrower than its docstring. unweighted_cell proves only the two zero excesses (line 343). revaluing_best proves the worths 2,1,1,1,2, while the shortfalls 1,1,1,0 (computed) are not stated. answers_alike proves only equality, and the stop at steps 0 and 1 (simulated: true, true on both routes) is in no statement. withhold_through_iff's second sentence is a reading at k = k' whose "falls" needs finer_least_le. Each proposed conjunct is true and closes by rewriting with the zeros and cases, or by rfl.

### E10 (exactness, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:70-72 (header), :1350-1351 (joint docstring)

**Quoted.** An act emitted at `t` is sensed at `t + 1`, taken into the state and the answer at `t + 2`, and read at `t + 3`

**Problem.** The timing is correct for `joint`: I checked it against the four maps and on both routes. But no lemma states it on a course. The cited lemmas are one-step lemmas at an arbitrary configuration, and `active_answer` holds at `n + 1`. `sensory_step` reads the configuration's own world, which is the start's world only by `world_fixed`.

**Replacement.** /-- **The timing**: what is sensed at `t + 1` is the input of the act emitted at `t` at the start's world; at `t + 2` it is in the state and the answer is that of the state; at `t + 3` the holding formation has read that answer. -/
theorem timing [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (x : Blanket.Parts (List W × V) (Input O X) Bool (W × H)) (t : Nat) :
    ((joint rd hd).course x (t + 1)).sensory = rd.input x.external.1 (hd.act ((joint rd hd).course x t).external.2) ∧
      ((joint rd hd).course x (t + 2)).internal =
        rd.update ((joint rd hd).course x (t + 1)).internal ((joint rd hd).course x (t + 1)).sensory ∧
      ((joint rd hd).course x (t + 2)).active = rd.answerOf ((joint rd hd).course x (t + 2)).internal ∧
      ((joint rd hd).course x (t + 3)).external.2 =
        hd.next ((joint rd hd).course x (t + 2)).external.2 ((joint rd hd).course x (t + 2)).active :=
  ⟨congrArg (fun e => rd.input e (hd.act ((joint rd hd).course x t).external.2)) (world_fixed rd hd x t), rfl, rfl, rfl⟩
Cite `timing` in the header.

**Verdict: not real.** Blanketed.course is Law.orbit (Recurrence.lean:275), so `course x (n+1)` is `step (course x n)` by definition. Each cited one-step lemma, which holds at every configuration, applied at course t, t+1 and t+2 gives exactly the stated timing. The world read by sensory_step plays no part in the timing. The header's claim is what the cited lemmas give, so a course-level `timing` lemma would be a convenience, not a correction.

### E11 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:566 (informed_le), :589 (informed_answer_le)

**Quoted.** theorem informed_le {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C) (gain loss : C → Nat)

**Problem.** `[DecidableEq K]` is a superfluous hypothesis in both theorems. The coarse rule `fun c => s (π c)` needs no cells. The proofs decide equality only of `π'`'s cells (`shortfall_split` and `finer_least_le` through `π'`, whose target type `K` takes no instance).

**Replacement.** `{K L : Type} [DecidableEq L]` in `informed_le` and `informed_answer_le`.

**Verdict: real.** Neither statement uses a cell of K under residual, answer or leastThrough. The proofs need decidable equality only on L: shortfall_split and leastThrough through π', and HeldForReading.finer_least_le, whose instance is on the finer type (its coarse `L` takes none). Dropping `[DecidableEq K]` generalizes both theorems with the same axiom-free proofs.

### E12 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:368-370; :845-853

**Quoted.** theorem le_of_add_eq_of_le {a b c d : Nat} (eq : a + b = c + d) (le : c ≤ a) : b ≤ d :=

**Problem.** The import closure already has `Becoming.le_of_add_eq_of_le {a b x y : Nat} (same : a + x = b + y) (le : x ≤ y) : b ≤ a` (experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Testing.lean:168). It has the same short name and a permuted statement. Inside `ListingValuation` the new lemma shadows it, so one identifier carries two argument orders across modules. Separately, `total_lt_of_mem` (line 846) restates `Loops.total_lt` (Loops.lean:149, outside the imports) without the credit HeldForReading gives its own restatements (HeldForReading.lean:848-849, "as `Interleavings.LocalLaw.total_single`, outside this module's imports").

**Replacement.** Either use `Becoming.le_of_add_eq_of_le ((Nat.add_comm d c).trans (eq.symm.trans (Nat.add_comm a b))) le` at the call sites, or rename the local lemma (e.g. `right_le_of_add_eq`). Docstring of `total_lt_of_mem`: "A total at most another term by term, and below it at one member, is below it (as `Loops.total_lt`, outside this module's imports)."

**Verdict: real.** `Becoming.le_of_add_eq_of_le {a b x y} (same : a + x = b + y) (le : x ≤ y) : b ≤ a` is at Testing.lean:168, and Testing is in HeldForReading's import closure. Its proof uses Prelude's structurally recursive le_of_add_le_add_right, with empty reports in the passed record. So the local lemma shadows a same-named lemma with permuted arguments, and the proposed reuse term checks (d + c = c + d = a + b = b + a). `Loops.total_lt` (Loops.lean:149) states what total_lt_of_mem states, Loops is outside the closure, and HeldForReading credits such restatements (lines 848-849).

### E13 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1281-1288 (Act.press), :603 (withhold_iff), :115, :132, :146, :674, :1500 ("gross")

**Quoted.** | press (x : X)

**Problem.** Three names are not structural and exact. (1) `Act.press` does not match its own docstring ("present an input", lines 1281-1282) or the input it produces (`Input.presented`), and "press" invites a social reading (pressing someone). (2) `withhold_iff` names one reading of a statement about any two rules with any amounts forgone (lines 603-605); AGENTS.md says a name is adopted only where the statement means exactly that. (3) "gross" ("gross worth", "gross of costs", "strict gross advantage") is a financial word that no other core module uses. The module's own term for the same thing is worth before amounts forgone.

**Replacement.** `| present (x : X)`, with `.present` at lines 1326, 1466 and 1584. Rename `withhold_iff` structurally, e.g. `after_add_lt_iff_shortfall`, keeping "withholding against informing" as its reading in the docstring. Replace "gross worth" with "worth before any amount forgone", and "no strict gross advantage" with "no strict advantage before any amount forgone".

**Verdict: real.** `Act.press` is documented as "present an input" and produces `Input.presented`, so the name does not match its docstring, though PLAN §4.8 item 16 itself says "pressing x". withhold_iff states a comparison of any two rules with any amounts, so the name is one reading of it. That is plan-chosen, and a rename must also cover withhold_through_iff and the kit texts that cite both. "gross" appears in no other core module, but "net" is core vocabulary even in identifiers (`Stock.le_after_of_net`, `Admission.supported_of_net_give_at`, `answer_least_of_net` here), so calling "gross" financial is the weakest part.

### E14 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:162; :449, :451, :749, :751, :774, :1140, :1144, :1146, :1269, :1359, :1510, :1514, :1575, :1735

**Quoted.** /-! ### Shared foundations (G0) -/

**Problem.** Build-kit scaffolding remains in a module meant for the core: the group tags "(G0)" and "(GA)"–"(GE)" and the `-- BEGIN GA` … `-- END GE` comment markers. "G0" is also one of the retired labels that AGENTS.md says live text does not use; it is explained once, in the method chapter.

**Replacement.** "/-! ### Shared foundations -/"; drop the "(GA)"–"(GE)" tags from the section titles and delete every `-- BEGIN …`/`-- END …` line.

**Verdict: real.** The tags "(G0)" and "(GA)"–"(GE)" and the `-- BEGIN/END` lines are present at the cited lines. No other module in Becoming/ has such markers or tags. integrate_rfm3.py copies the file unchanged (`shutil.copyfile`, line 54), so they would land in the core, and "G0" collides with a retired label that AGENTS.md keeps out of live text.

### E15 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1730-1731 (not_lumped); :85-88 (header)

**Quoted.** on these two executable routes, the answers and the final reading state do not determine whether the valuation changed.

**Problem.** The module drops the witness's stated boundary. The plan's item 21 (PLAN.md:227) and the review's finding 15 (marked taken) name it: the result would not survive adding the starting internal state or the inputs to the record, because `shownStart` and `presentedStart` differ in both. Neither the header nor `not_lumped` says so.

**Replacement.** Append to the docstring: "The starts differ (`shownStart`, `presentedStart`), so a record carrying the starting state or the inputs would tell the routes apart."

**Verdict: real.** PLAN.md:227 ends item 21 with "It would not survive adding the starting internal state or the inputs to the record; the starts differ". REVIEW-RFM3's table row 15 is marked taken with "the boundary (the start or the inputs added to the record) named". Neither the header (lines 85-88) nor not_lumped's docstring names it. The proposed "would tell the routes apart" is a claim about another record that no Lean states; it is better to say only what the definitions show.

### E16 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:766-772 (SplitsKeep); :1220-1229 (Weights.weights_matter)

**Quoted.** def SplitsKeep (m pm : Model C) (gain loss g l : C → Nat) : Prop :=

**Problem.** The module never shows the criterion holding or failing, so `refining_never_lowers_iff` is not connected to its own witnesses. Both sides are non-vacuous. Weights' data violate SplitsKeep: take B the third candidate and D the first two. Over B the reading formation's weighted l is 0 ≤ g 2; over D, g 1 < l 2; over both, l 2 ≤ g 3. Yet by the holding formation's weights the first two gain 2 and lose 1. In the other direction, a shared model with net agreement satisfies SplitsKeep.

**Replacement.** In namespace Weights (a sketch, not built):
/-- The weights apart break the criterion: the reading formation releases the third candidate (0 ≤ 2), stops the first two (1 < 2) and releases all three (2 ≤ 3), while by the holding formation's weights the first two gain 2 and lose 1. -/
theorem not_splitsKeep : ¬ SplitsKeep holding reading gain loss gain loss := fun keep =>
  absurd ((keep (fun c => decide (c = 2)) (fun c => decide (c < 2))
      (fun c two => by rw [of_decide_eq_true two]; rfl) (by decide) (by decide)).1 (by decide)) (by decide)
Optionally add `splitsKeep_of_net`: with `pm = m` and net agreement, SplitsKeep holds.

**Verdict: real.** SplitsKeep appears only in the refinement theorems. On Weights' data with B = {2} and D = {0,1}, the premises hold (0 ≤ 2, 1 < 2, 2 ≤ 3) and the conclusion fails (holding weights: gain 2, loss 1), confirmed by enumeration. A shared model with net agreement satisfies SplitsKeep (random check, and it follows from existing results). The sketch's `apart` step (`rw [...]; rfl`) leaves a final `rfl` with no goal if rw's own rfl closes it, so a term proof is safer.

### E17 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:13-14, :17, :733-734, :1722

**Quoted.** Scores, weights, the update and the reference are supplied local commitments

**Problem.** Four wording points. (1) The module has values and weights; nothing in it is a score. (2) "its *listing* (candidates with weights)" (line 13) calls the weights part of the state. In the carrier the state's listing is `List W` and the weights are the law's `rd.weight`, never updated; the `answer_shown` docstring's "the weights … unchanged" holds by construction. (3) `const_below_iff`'s headline "strictly lower exactly where the amount is positive" names no comparator. (4) "from 2 on on" at line 1722.

**Replacement.** "Values, weights, the update and the reference are supplied local commitments"; "its *listing* (candidate worlds, weighted by its law)"; "holding for an answer telling nothing is strictly lower than committing to the move it gives exactly where the amount is positive"; "and, for every `T` from 2 on, changes on the route presented".

**Verdict: real.** Nothing in the module is a score; the word is inherited from the plan's RF-M.2 sentence. In Part 2 the weights are the law's `rd.weight`, not part of the `List W × V` state. const_below_iff's headline names no comparator, and "from 2 on on" (line 1722) is awkward. The proposed fourth replacement drops "before", which changes what `changed` means (a change at some step before T).

## The structure lens

20 findings, each judged by the verifier: 19 real, 1 not. The verdict follows each finding.

### F1 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:75 (also the updates_commute docstring, 1405-1406)

**Quoted.** the courses they are part of need not

**Problem.** The header (74-75) and updates_commute's docstring ('the courses they are part of need not commute') claim the coupled courses need not commute. No theorem shows this: updates_commute (1407-1411) proves only the update identity by rfl, and Routes has no two-order witness. Plan item 17 and review row 11 ask for exactly this distinction: the intermediate answers, and a holding formation reading them, can differ. The claim is true, but the Lean lacks it.

**Replacement.** Add to Routes. The numbers were checked by an independent simulation of `joint`: the answers run stop, stop, release, stop… against stop, stop, stop, stop…, and both courses are at ([first], reversed) from step 3.
```lean
/-- **The updates commute, the courses need not**: from both worlds listed and `agree`, demonstrating
then presenting `reversed`, and presenting `reversed` then demonstrating, reach one state at step 3,
while the answers at step 2 differ. -/
theorem orders_apart :
    ((joint rd schedule).course ⟨([.first, .second], .agree), .none, true,
        (.first, [.demonstrate, .press .reversed])⟩ 2).active = false ∧
      ((joint rd schedule).course ⟨([.first, .second], .agree), .none, true,
        (.first, [.press .reversed, .demonstrate])⟩ 2).active = true ∧
      ((joint rd schedule).course ⟨([.first, .second], .agree), .none, true,
          (.first, [.demonstrate, .press .reversed])⟩ 3).internal =
        ((joint rd schedule).course ⟨([.first, .second], .agree), .none, true,
          (.first, [.press .reversed, .demonstrate])⟩ 3).internal :=
  ⟨rfl, rfl, rfl⟩
```
Then cite it in the header and docstring: '…the courses they are part of need not (`Routes.orders_apart`)'.

**Verdict: real.** Line 75 and the updates_commute docstring both say the courses need not commute, but updates_commute is only an rfl identity on updates and nothing in Routes compares two orders. I simulated `joint rd schedule` from ([first, second], agree): demonstrate-then-press-reversed answers stop, stop, release, stop…, the other order answers stop throughout, and both internals are ([first], reversed) from step 3. So `orders_apart` by ⟨rfl, rfl, rfl⟩ states true closed facts.

### F2 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:615-617

**Quoted.** coarser answer stands above holding for a finer one exactly where the finer answer's residual exceeds

**Problem.** The docstring's second sentence, which is plan item 7's last sentence, is not what withhold_through_iff states. The theorem has no refinement hypothesis linking π and π', and 'the least shortfall falls' needs finer_least_le (least through π' ≤ least through π), which the proof never uses. In natural numbers, the rearrangement into 'the residual exceeds by more than the fall' is valid only given that inequality. The promised coarser/finer threshold is therefore not proved.

**Replacement.** Add the theorem and point the docstring at it:
```lean
theorem withhold_refined_iff {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss : C → Nat) (π : C → K) (π' : C → L) (f : L → K)
    (factors : ∀ c, c ∈ m.listed → π c = f (π' c)) {zs : List K} {zs' : List L}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (s : K → Bool) (s' : L → Bool) (k : Nat) :
    m.after (shifted gain loss) (byRule fun c => s' (π' c)) + k <
        m.after (shifted gain loss) (byRule fun c => s (π c)) + k ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) -
          shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) +
        residual m gain loss π zs s < residual m gain loss π' zs' s'
```
Proof sketch:
1. Get `falls : Λ' ≤ Λ` from `Nat.le_trans (finer_least_le m gain loss π' once' covers' f (leastThrough m gain loss π)) (Nat.le_of_eq (shortfall_congr_on m gain loss fun c mem => congrArg (leastThrough m gain loss π) (factors c mem).symm))`.
2. Take `(withhold_through_iff … s s' k k).trans`.
3. Rewrite Λ as Λ' + (Λ - Λ') with `(add_sub_of_le falls).symm` and reassociate.
4. Cancel Λ' with `Nat.lt_of_add_lt_add_left`/`Nat.add_lt_add_left`, and k with `Nat.lt_of_add_lt_add_right`/`Nat.add_lt_add_right`. All four are already used in the pure core.

With s, s' the answers through π and π', this is the docstring's sentence.

**Verdict: real.** The second docstring sentence is about a coarser and a finer map and a fall in the least shortfall. withhold_through_iff has no refinement hypothesis and never uses finer_least_le, and in Nat the rearranged form needs Λ' ≤ Λ. Over the integers the sentence is a correct rearrangement of the theorem's right side, so the gap is exactness, not a false claim. withhold_refined_iff is true (20,000 random refinements brute-forced) and needs only finer_least_le, shortfall_congr_on, add_sub_of_le and Nat cancellation lemmas the core already uses.

### F3 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1220-1229

**Quoted.** positive; holding for the answer is worth 3 through one cell, 2 through the cells of the first two

**Problem.** Plan item 8 (PLAN.md:211) and review row 11 say: 'A finer map weakly lowers the least shortfall but can change the residual either way (9 raises it; 10's second refinement lowers it)'.
- The raising case is in the Lean: Informing takes the residual from 0 to 11.
- `Weights.weights_matter` states worths only, so 'lowers it' has no Lean check.
- The module header (42-54) never says that refining changes both terms.

Computed independently, the witness already carries the claim: least shortfall 1, 1, 0 and residual 0, 1, 0 through one cell, {0,1}{2} and the identity. The first refinement raises the residual at an unchanged least shortfall; the second lowers both.

**Replacement.** Add to the Weights witness (closed terms, rfl as in weights_matter):
```lean
theorem weights_split :
    shortfall holding gain loss (fun _ => leastThrough holding gain loss (fun _ : Nat => ()) ()) = 1 ∧
      residual holding gain loss (fun _ : Nat => ()) [()] (answer reading gain loss (fun _ => ())) = 0 ∧
      shortfall holding gain loss
          (fun c => leastThrough holding gain loss (fun c : Nat => decide (c = 2)) (decide (c = 2))) = 1 ∧
      residual holding gain loss (fun c : Nat => decide (c = 2)) [false, true]
          (answer reading gain loss (fun c : Nat => decide (c = 2))) = 1 ∧
      shortfall holding gain loss (fun c => leastThrough holding gain loss id c) = 0 ∧
      residual holding gain loss id [0, 1, 2] (answer reading gain loss id) = 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩
```
Add to the header after revalued_split: 'A finer map never raises the least shortfall (`finer_least_le`) and can move the residual either way: from 0 to 11 (`Informing.informing_lowers`), from 0 to 1 and back to 0 (`Weights.weights_split`).'

**Verdict: real.** PLAN.md:211 and review row 11 say refining moves the residual either way. Only the raise is in Lean (Informing, 0 to 11): weights_matter states worths only, and the header never says refining changes both terms. Recomputing the Weights witness gives least shortfall 1, 1, 0 and residual 0, 1, 0 through one cell, {0,1}{2} and the identity, so the six rfl equalities of weights_split are correct.

### F4 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1472 (and answer_constant, 1503)

**Quoted.** {w w' : W} (same : rd.reveal w = rd.reveal w')

**Problem.** Review finding 13 (REVIEW-RFM3.md:187) asks for courses alike 'under one world-independent schedule of non-demonstration inputs', that is, an uninformed reading formation. Row 13 records it as taken ('inputs alike at the two worlds'), but the Lean narrows it:
- inputs_alike requires `rd.reveal w = rd.reveal w'`.
- answer_constant requires every listed world to show one thing (1503).

Both say demonstrations could tell nothing apart. The review's own case is not covered: a holding formation that never demonstrates, at worlds a demonstration would tell apart. Yet that is the off-switch case the Readings attach to answer_constant, an answer carrying no information about the preference-relevant parameter. The proof uses `input_eq_of_reveal_eq` only at the acts the holder actually takes (1489), so the stronger statement costs nothing.

**Replacement.** State the induction on the weakest hypothesis and keep the present theorems as corollaries:
```lean
theorem inputs_alike_of [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X) (i : List W × V)
    (s : Input O X) (a : Bool) (h : H) {w w' : W}
    (alike : ∀ h' : H, rd.input w (hd.act h') = rd.input w' (hd.act h')) : ∀ n, …  -- the same four conjuncts
-- proof: the present one, with `(input_eq_of_reveal_eq rd same _)` replaced by `(alike _)`

theorem input_alike_of_never [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (never : ∀ h', hd.act h' ≠ .demonstrate) (w w' : W) (h' : H) :
    rd.input w (hd.act h') = rd.input w' (hd.act h') :=
  match e : hd.act h' with
  | .demonstrate => absurd e (never h')
  | .go => rfl | .off => rfl | .hold => rfl | .press _ => rfl

theorem answer_constant_unshown [DecidableEq O] (rd : Reader W V O X) (hd : Holder H X)
    (i : List W × V) (s : Input O X) (a : Bool) (h : H) (m : Model W) (gain loss : W → Nat)
    (never : ∀ h', hd.act h' ≠ .demonstrate) (w₀ : W) (n : Nat) :
    m.after (shifted gain loss) (byRule fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active) =
      m.committed (shifted gain loss) (cond ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active .off .go) :=
  const_worth m gain loss _ _ fun w _ =>
    (inputs_alike_of rd hd i s a h (input_alike_of_never rd hd never w w₀) n).2.2.1
```
`inputs_alike` becomes `inputs_alike_of … fun h' => input_eq_of_reveal_eq rd same (hd.act h')`. Then cite `answer_constant_unshown` in the off-switch Reading.

**Verdict: real.** inputs_alike needs reveal w = reveal w', and answer_constant needs every listed world to show one thing. So review finding 13's case (no demonstration, worlds a demonstration would tell apart) is not covered, although row 13 says it was taken. The proof uses input_eq_of_reveal_eq only at the act taken at step n (line 1489). The proposed inputs_alike_of, input_alike_of_never and answer_constant_unshown are true and axiom-free.

### F5 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:204-207

**Quoted.** theorem sub_pos_of_lt_core {m n : Nat} (lt : m < n) : 0 < n - m :=

**Problem.** This reproves a package lemma in the import closure: `SupportGated.sub_pos_of_lt : ∀ {d c : Nat}, d < c → 0 < c - d` (package Becoming/Prelude.lean:616). Its proof is term-mode recursion on Nat.succ_pos, Nat.succ_sub_succ and Nat.lt_of_lt_of_le, with no simp, omega or funext, so its axiom report is empty. HeldForReading.lean:352 already uses it under an empty report. The statement is the same; only the name differs.

**Replacement.** Delete lines 204-207. At lines 219, 223 and 523 write `SupportGated.sub_pos_of_lt lt`.

**Verdict: real.** `Becoming.SupportGated.sub_pos_of_lt : ∀ {d c : Nat}, d < c → 0 < c - d` is at Prelude.lean:616. It is in the closure, term-mode, in a core module whose receipt matches the current bytes, and HeldForReading.lean:352 uses it. Lines 219, 223 and 523 are the only uses of the local copy.

### F6 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:368-370

**Quoted.** theorem le_of_add_eq_of_le {a b c d : Nat} (eq : a + b = c + d) (le : c ≤ a) : b ≤ d :=

**Problem.** The import closure already has `Becoming.le_of_add_eq_of_le {a b x y : Nat} (same : a + x = b + y) (le : x ≤ y) : b ≤ a` (package Becoming/Testing.lean:168). Its proof applies the Prelude's core-form `le_of_add_le_add_right`, so its report is empty. The module restates it under the same name with the roles permuted, shadowing it inside ListingValuation. The result is two declarations named `le_of_add_eq_of_le` whose arguments mean different things: a hazard for anyone who opens the namespace or reads the Lean index, and a reproof.

**Replacement.** Rename and derive it from the package lemma, then update the 5 call sites (403, 408, 409, 1113, 1118):
```lean
/-- From `a + b = c + d` with `c` at most `a`, `b` is at most `d` (`Becoming.le_of_add_eq_of_le`,
turned). -/
theorem le_of_add_eq_of_ge {a b c d : Nat} (eq : a + b = c + d) (le : c ≤ a) : b ≤ d :=
  Becoming.le_of_add_eq_of_le ((Nat.add_comm d c).trans (eq.symm.trans (Nat.add_comm a b))) le
```

**Verdict: real.** `Becoming.le_of_add_eq_of_le` (Testing.lean:168, core, receipt current) is the same fact up to commuting the equation. The module's lemma has the same short name with the roles permuted and shadows it inside the namespace. The proposed term checks: from eq the chain gives d + c = b + a, and with c ≤ a Testing's lemma yields b ≤ d. The five call sites are 403, 408, 409, 1113 and 1118.

### F7 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:757-759

**Quoted.** total pm.listed fun c => cond (B c) (pm.weight c * f c) 0

**Problem.** `weightedOn pm B f` is, definitionally, the imported `HeldForReading.offPart pm B (fun c => pm.weight c * f c)` (HeldForReading.lean:547: `total m.listed fun c => cond (r c) (f c) 0`). SplitsKeep, the exported criterion, is therefore stated in a second vocabulary for an imported notion, and offPart_add_onPart and after_rule cannot be read on it.

Likewise, within_split (817) with ite_split_rule and ite_cond_split (795, 806) restates the law of total weight already in the closure: `ConditionalWeights.mass_split` (ConditionalWeights.lean:314, on `Weighted.mass`, Weighted.lean:535) with `entry_split` (ConditionalWeights.lean:150). The only difference is `cond b x 0` against `if b = true then x else 0`. Both proofs are cases/rfl with Nat.add_add_add_comm, so their reports are empty.

**Replacement.** Use `def weightedOn (pm : Model C) (B : C → Bool) (f : C → Nat) : Nat := offPart pm B fun c => pm.weight c * f c`, with the docstring 'HeldForReading's `offPart` of the weighted amount'. The existing proofs go through by δβ-unfolding.

In the Standing, name within_split as the law of total weight (`ConditionalWeights.mass_split`) in `total`'s form, or state it through `mass` with one `cond`/`if` bridge lemma.

**Verdict: real.** After β-reduction, weightedOn's body is exactly `HeldForReading.offPart pm B (fun c => pm.weight c * f c)` (HeldForReading.lean:547), so SplitsKeep restates an imported notion, and within_split is the law of total weight. Three details are overstated. `mass` is `Becoming.mass` (Weighted.lean:535) with its own recursion and Bool events, so reusing mass_split needs total/mass and `π c = z`/decide bridges, not only cond/if. ite_cond_split serves within_rule_split, which carries two different amounts and is not mass_split. offPart's lemmas can be applied to SplitsKeep by unfolding, not 'cannot'.

### F8 (structure, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:95 (Standing); answer_shown 1441-1457; Routes 1610-1653

**Quoted.** joined to executable courses of informing and revaluing in one law with the

**Problem.** Strength, priority 1, partly promised. Plan item 18 says 'With that model the holding formation's before the demonstration, Part 1 applies with π = reveal', and the Standing claims the split is joined to executable courses. In the Lean, Part 2 reaches Part 1 only in two places:
- answer_shown, an equation of answers;
- answer_constant, the constant case.

No theorem states the split, the least shortfall or the worth of the answer a demonstration produces. Routes.shown_removes_least, presented_removes_residual and the four cases (shown_turns, presented_turns) are stated on `answer`/`update`, never on a course of `joint`. The join is left to the reader. The step lemmas and through_sensed are otherwise sound.

**Replacement.** Add these short compositions:
```lean
theorem shown_split [DecidableEq O] (rd : Reader W V O X) (L : List W) (v : V) (m : Model W)
    (gain loss : W → Nat) {os : List O} (once : List.Pairwise (fun a b => a ≠ b) os)
    (covers : ∀ w, w ∈ m.listed → rd.reveal w ∈ os) :
    shortfall m gain loss (fun w => rd.answerOf (rd.update (L, v) (.shown (rd.reveal w)))) =
      shortfall m gain loss (fun w => leastThrough m gain loss rd.reveal (rd.reveal w)) +
        residual m gain loss rd.reveal os (answer ⟨L, rd.weight⟩ (rd.goVal v) (rd.offVal v) rd.reveal) :=
  (shortfall_congr_on m gain loss fun w _ => (answer_shown rd L v w).2).trans
    (shortfall_split m gain loss rd.reveal once covers _)

theorem shown_least_le [DecidableEq O] (reveal : W → O) (m : Model W) (gain loss : W → Nat)
    {os : List O} (once : List.Pairwise (fun a b => a ≠ b) os) (covers : ∀ w, w ∈ m.listed → reveal w ∈ os) :
    shortfall m gain loss (fun w => leastThrough m gain loss reveal (reveal w)) ≤
      shortfall m gain loss (fun _ => leastThrough m gain loss (fun _ : W => ()) ()) :=
  finer_least_le m gain loss reveal once covers (fun _ => ()) (leastThrough m gain loss fun _ : W => ())

theorem shown_never_lowers [DecidableEq O] (rd : Reader W V O X) (L : List W) (v : V) (gain loss : W → Nat)
    (net : ∀ w, w ∈ L → 0 < rd.weight w → rd.goVal v w + loss w = rd.offVal v w + gain w)
    {os : List O} (once : List.Pairwise (fun a b => a ≠ b) os) (covers : ∀ w, w ∈ L → rd.reveal w ∈ os) :
    (⟨L, rd.weight⟩ : Model W).after (shifted gain loss) (byRule fun _ => rd.answerOf (L, v)) ≤
      (⟨L, rd.weight⟩ : Model W).after (shifted gain loss)
        (byRule fun w => rd.answerOf (rd.update (L, v) (.shown (rd.reveal w))))
-- informed_answer_le ⟨L, rd.weight⟩ gain loss _ _ net (fun _ => ()) rd.reveal (fun _ => ()) (fun _ _ => rfl)
--   once covers (answer ⟨L, rd.weight⟩ (rd.goVal v) (rd.offVal v) fun _ => ()), its left side being answerOf (L, v)
--   by δ, then Nat.le_of_eq (total_congr_on …) with (answer_shown rd L v w).2.symm
```
Add the course form in Routes. Checked by simulation: the rule stops at both worlds at step 1, and at step 2 releases at the first and stops at the second.
```lean
theorem shown_course_least :
    shortfall ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun w => ((joint rd schedule).course ⟨([.first, .second], .agree), .none, true, (w, [.demonstrate])⟩ 1).active) = 1 ∧
      shortfall ⟨[.first, .second], rd.weight⟩ (rd.goVal .agree) (rd.offVal .agree)
        (fun w => ((joint rd schedule).course ⟨([.first, .second], .agree), .none, true, (w, [.demonstrate])⟩ 2).active) = 0 :=
  ⟨rfl, rfl⟩
```
Add the same for (b) with model ⟨[.first], rd.weight⟩ and [.press .agree] (shortfall 1, then 0).

**Verdict: real.** Part 2 reaches Part 1's quantities only through answer_shown (an equation of answers) and answer_constant. shown_turns and presented_turns are stated on `update`, and shown_removes_least and presented_removes_residual on closed `answer` terms, never on a course of `joint`, so the Standing's join is only partly stated. shown_split, shown_least_le and shown_never_lowers follow without axioms from shortfall_split, finer_least_le, informed_answer_le and answer_shown. Simulation confirms shortfall 1 then 0 for both (a) and (b) along the course.

### F9 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:486-496

**Quoted.** **Told the candidate, the answer falls short exactly where an unweighted candidate is one to

**Problem.** The bold title speaks of the shortfall, but the theorem characterizes the residual over a covering list. That list need not be listed once, so the shortfall split is not available from its hypotheses. The header (39-41) correctly says 'residual'. The title's claim is true, and a stronger form needs no cell list at all.

**Replacement.** Factor the `unweighted` and `weighed` haves (503-516) into lemmas and add:
```lean
theorem told_shortfall_zero_iff (m pm : Model C) (gain loss g l : C → Nat)
    (net : ∀ c, c ∈ pm.listed → 0 < pm.weight c → g c + loss c = l c + gain c) :
    shortfall m gain loss (fun c => answer pm g l id c) = 0 ↔
      ∀ c, c ∈ m.listed → 0 < m.weight c → gain c < loss c → 0 < weightOf pm c
```
Proof sketch:
- (→) A listed c of positive weight with gain c < loss c and weightOf pm c = 0 is released, so its term m.weight c * (loss c - gain c) is positive (Nat.mul_le_mul with SupportGated.sub_pos_of_lt). That contradicts le_total_of_mem against 0.
- (←) Use total_eq_zero. Where weightOf pm c > 0, the answer stops exactly where gain c < loss c, so the truncated subtraction is 0 either way. Where it is 0, the answer releases, and m.weight c = 0 or ¬ gain c < loss c makes the term 0.

Then retitle told_residual_zero_iff 'the residual is nothing exactly where …'.

**Verdict: real.** told_residual_zero_iff has only `covers` and no `once`, so it characterizes the residual, while its bold title speaks of falling short; no lemma says the least shortfall through id is zero. told_shortfall_zero_iff is true (checked on 20,000 random cases with repeated listings) and provable from weightOf_pos_iff, within_id, total_eq_zero and le_total_of_mem.

### F10 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:637-641

**Quoted.** theorem lt_add_self_iff (x k : Nat) : x < x + k ↔ 0 < k :=

**Problem.** This is the closure's `Becoming.pos_iff_lt {a b d : Nat} (sum : a + b = d) : 0 < a ↔ b < d` (package Becoming/Locality.lean:69, term-mode, empty report), turned around. It is reproved from scratch.

**Replacement.** `theorem lt_add_self_iff (x k : Nat) : x < x + k ↔ 0 < k := (pos_iff_lt (Nat.add_comm k x)).symm`, or delete it and use that term at 697 and 740.

**Verdict: real.** `Becoming.pos_iff_lt` (Locality.lean:69, term-mode, core) applied to `Nat.add_comm k x : k + x = x + k` gives `0 < k ↔ x < x + k`, and its `.symm` is exactly lt_add_self_iff. No other `pos_iff_lt` exists to make the name ambiguous.

### F11 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:845-853

**Quoted.** theorem total_lt_of_mem {α : Type} {p q : α → Nat} {a : α} :

**Problem.** This is the fifth copy of the strict-total lemma. The others are Loops.total_lt (Becoming/Loops.lean:149), RelativePosition.total_lt_of_mem (RelativePosition.lean:148), Regulation.total_lt_of_le_of_mem (Regulation.lean:437) and Weightings.total_lt (Weightings.lean:512). None is in HeldForReading's closure, so the copy is not a reproof of an import. But the Prelude's 'Definitions stated once (R37)' note asks for such lemmas once. The closure has only the converse, Locality.exists_lt_of_total_lt (Locality.lean:76).

**Replacement.** Keep the proof (it is sound), but propose to Flow's owner an R37-style item: state it once in Becoming/Flow.lean beside total_le (121) and le_total_of_mem (178), and point the five copies to it. Until then, say in the docstring that it repeats Loops.total_lt.

**Verdict: real.** Loops.lean:149, RelativePosition.lean:148, Regulation.lean:437 and Weightings.lean:512 carry the same strict-total lemma, and none of those modules is in HeldForReading's closure, which has only the converse. The Prelude's R37 section consolidated lemmas repeated across core modules in exactly this way. Two names are slightly off: Regulation's copy is `Flow.total_lt_of_le_of_mem`, and the converse is `Becoming.exists_lt_of_total_lt`.

### F12 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:88 (header Routes summary); Standing 97-98

**Quoted.** record of answers and final state (`Routes.not_lumped`).

**Problem.** The module's account omits parts the table says were taken (the plan has them):
- Row 15, the boundary: 'It would not survive adding the starting internal state or the inputs to the record' (PLAN.md:227).
- Row 14: 'in these witnesses only … 8 says the separation is not general' (PLAN.md:226).
- Row 8: 'no endorsement of revaluing' (PLAN.md:215).
- Row 12: 'a reading as conditional probability needs positive mass in the cell' (PLAN.md:224).

None of these phrases occurs in the module. The Standing also says outcome_least composes least_through, but it is answer_least_of_net alone (703). not_lumped itself is a correct use of Learning.Lumped: record T false = record T true for T ≥ 2, while changed differs.

**Replacement.** Add the four sentences to the header (Routes, the four cases, outcome_least, answer_shown), and write 'own_least and revaluing_gains_iff compose least_through with answer_least_of_net; outcome_least is answer_least_of_net at the revised valuation'. Make the boundary a theorem:
```lean
theorem lumped_with_start (T : Nat) :
    Learning.Lumped (fun b => (record T b, (route b).internal)) (changed T) :=
  fun b b' same => match b, b', same with
  | false, false, _ => rfl
  | true, true, _ => rfl
  | false, true, same => absurd (congrArg (fun r => r.2.2) same) (by decide)
  | true, false, same => absurd (congrArg (fun r => r.2.2) same) (by decide)
```
The starts' valuation states are agree and reversed.

**Verdict: real.** grep finds none of the four plan phrases (PLAN.md:215, 224, 226, 227) in the module. The Standing wrongly says outcome_least composes least_through; its proof is answer_least_of_net alone. lumped_with_start is true: the starts' valuation states are agree and reversed, and `.2.2` reduces without evaluating `record T b`.

### F13 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:54 (also 31-32/339-340 and 1255-1260)

**Quoted.** two valuations' answers differ exactly as their residuals do

**Problem.** Three wordings say more than, or other than, the Lean:
- Line 54: revalued_split relates the answers' shortfalls, not the answers, which are Boolean rules.
- unweighted_cell is said to 'add nothing to any residual', but it proves only that both excesses are nothing.
- Revaluing.revaluing_best's docstring states shortfalls ('falling short by 1 … by nothing'), but the theorem states worths.

**Replacement.** - Line 54: 'two valuations' answers fall short by amounts that differ exactly as their residuals do'.
- Add to unweighted_cell the conjunct `∀ s : K → Bool, cond (s z) (goExcessWithin m gain loss π z - offExcessWithin m gain loss π z) (offExcessWithin m gain loss π z - goExcessWithin m gain loss π z) = 0` (rewrite both excesses to 0; cases on s z; rfl).
- Add to revaluing_best, by rfl (checked): `shortfall model gain loss (fun _ => false) = 1 ∧ shortfall model gain loss (fun _ => true) = 1 ∧ shortfall model gain loss (fun c => answer model (fun _ => 0) (fun _ => 1) id c) = 1 ∧ shortfall model gain loss (fun c => answer model gain loss id c) = 0`.

**Verdict: real.** Line 54 says the answers differ as their residuals do, while revalued_split relates their shortfalls (its own docstring is right). unweighted_cell proves only that both excesses are zero, and revaluing_best states worths while its docstring speaks of shortfalls. The proposed additions hold: the Revaluing shortfalls recompute to 1, 1, 1, 0, and the residual term at an unweighted cell is 0 - 0 under either decision.

### F14 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1316 (Reader.update); Modelling choices 141-146

**Quoted.** | st, .asked => st

**Problem.** `joint` is otherwise a faithful Blanket.Blanketed law for items 16 to 19:
- the internal and active parts read only the internal and sensory parts;
- the sensory part reads only the external part;
- the external part reads the answer and the holder's state, with the world fixed;
- through_sensed is exactly `(joint rd hd).agent_through_sensory internal active`.

But `asked` acts as `none`: update leaves the state alone, and nextActive shows the answer at every step whether asked or not. The holder's go, off and hold acts change neither W nor the reading formation. In the carrier, 'holding for the answer' is therefore a label: its worth is counted only in Part 1, on the answer as a rule. The Modelling choices do not say so.

**Replacement.** Add to the Modelling choices: 'the answer is shown at every step, asked or not (`asked` and `none` update alike); the holding formation's going on, switching off and holding change neither the candidate world nor the reading formation, so the worth of holding is counted in Part 1 on the answer as a rule on the candidates, not in the carrier'.

**Verdict: real.** update maps `.asked` to the unchanged state as `.none` does, nextActive emits `answerOf (update i s)` at every step, and go, off and hold change neither W nor the reading state. The Modelling choices mention the fixed parameter and a holder reading only its state and the answer, but not that asking changes nothing. The proposed sentence is accurate.

### F15 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:162 (also 449, 451, 749, 751, 774, 1140, 1144, 1146, 1269, 1359, 1510, 1514, 1575, 1735)

**Quoted.** /-! ### Shared foundations (G0) -/

**Problem.** Kit assembly markers '(G0)', '(GA)'…'(GE)' and '-- BEGIN Gx'/'-- END Gx' would land in a core module. No landed module carries such markers. 'G0' is also a retired label of the theory (08-METHOD.md:570, 'G0 (the label; Lean `G0`) | living significance'), and AGENTS.md keeps retired labels out of live text.

**Replacement.** Remove the '(G0)'…'(GE)' suffixes and the BEGIN/END comment lines before landing, e.g. '/-! ### Shared foundations -/' and '/-! ### Item 6: over every refinement -/'.

**Verdict: real.** The markers are at lines 162, 449/451/749, 751/774/1140, 1144/1146/1269, 1359/1510 and 1514/1575/1735. integrate_rfm3.py copies the file byte-for-byte (shutil.copyfile), so they would land. No landed module and no other RF kit has them, and 'G0' is the retired label at 08-METHOD.md:570.

### F16 (structure, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1516 (and 1206)

**Quoted.** namespace Routes

**Problem.** The witness namespaces repeat existing package namespaces: `Becoming.Routes` (Becoming/Routes.lean:142, P118's sums over histories) and `Becoming.Weights` (Becoming/Weighted.lean:104, in the closure). Lean resolves the inner one inside ListingValuation, so the build is unaffected. But prose, records and chapters citing `Routes.not_lumped` or `Weights.weights_matter` read as members of those modules.

**Replacement.** Rename to say what they witness, e.g. `TwoRoutes` (or `RoutesApart`) and `WeightsApart`, and update the header and the record's citations.

**Verdict: not real.** The full names `Becoming.ListingValuation.Routes` and `.Weights` do not collide. The package's own fix for namespace collisions (B13 in the r30-names plan) is qualification by module, as in `Weighted.Loop` and `Gluing.Cycle`, and `Becoming.AssurancePlans.Routes` already sits beside `Becoming.Routes`. The kit's records cite these names fully qualified through `lv()` (s12 and integrate_rfm3.py use `ListingValuation.Routes.*`), and the study lists them under '(Becoming.ListingValuation, …)', so the misreading the finding predicts does not arise.

### F17 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:566

**Quoted.** theorem informed_le {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C) (gain loss : C → Nat)

**Problem.** Strength, priority 2. Graded and strict forms of informed_le are in reach on the same definitions:
- The graded form turns `Informing.informing_lowers` and `Weights.weights_matter` from witnesses into a bound: informing costs at most the informed rule's residual. In Informing, 10 ≤ 0 + 11; in Weights, 3 ≤ 2 + 1, which is tight.
- The strict form says exactly when informing gains.

**Replacement.**

```lean
theorem informed_le_add_residual {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss : C → Nat) (π : C → K) (π' : C → L) (f : L → K)
    (factors : ∀ c, c ∈ m.listed → π c = f (π' c)) {zs' : List L}
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs')
    (s' : L → Bool) (s : K → Bool) :
    m.after (shifted gain loss) (byRule fun c => s (π c)) ≤
      m.after (shifted gain loss) (byRule fun c => s' (π' c)) + residual m gain loss π' zs' s'
```
Proof sketch: after_add_shortfall for both rules gives A + S = A' + S'. shortfall_split gives S' = Λ' + R'. finer_least_le with shortfall_congr_on gives Λ' ≤ S. So A + Λ' ≤ A' + R' + Λ', and the Prelude's le_of_add_le_add_right cancels Λ'.
```lean
theorem informed_lt_iff … (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (least : residual m gain loss π' zs' s' = 0) (s : K → Bool) :
    m.after (shifted gain loss) (byRule fun c => s (π c)) <
        m.after (shifted gain loss) (byRule fun c => s' (π' c)) ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) <
          shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) ∨
        0 < residual m gain loss π zs s
```
Proof sketch: after_lt_iff_shortfall, then shortfall_split on both sides, so Λ' < Λ + R. With Λ' ≤ Λ, split by Nat.lt_or_ge; in the second case Nat.le_antisymm and lt_add_self_iff give 0 < R.

**Verdict: real.** Both statements hold. A + S = A' + Λ' + R' together with Λ' ≤ S (finer_least_le with factors) gives the graded bound. With R' = 0 and Λ' ≤ Λ, Λ' < Λ + R splits into the disjunction. Brute force over 20,000 random refinements found no counterexample, the 10 ≤ 0 + 11 and tight 3 ≤ 2 + 1 checks are right, and every ingredient is axiom-free.

### F18 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:709

**Quoted.** theorem revaluing_gains_iff (m : Model C) (gain loss g l : C → Nat) (π : C → K) {zs : List K}

**Problem.** Strength, priority 3. revaluing_gains_iff gives only the sign of the gain. On the same hypotheses the size is exact: revaluing to the reference gains exactly the current answer's residual, and no revaluation gains more. With own_least this subsumes revaluing_gains_iff and makes item 13 quantitative.

**Replacement.**

```lean
theorem revaluing_gain (m : Model C) (gain loss g l : C → Nat) (π : C → K) {zs : List K}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) :
    m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) +
        residual m gain loss π zs (answer m g l π) =
      m.after (shifted gain loss) (byRule fun c => answer m gain loss π (π c))
```
Proof sketch: both answers' after_add_shortfall equal the reading's worth. shortfall_split gives S(g,l) = Λ + res. answer_shortfall_least, with net := fun c _ _ => Nat.add_comm (gain c) (loss c), gives S(gain,loss) = Λ. Reassociate and cancel Λ with the Prelude's add_right_cancel. The bound for every g' l' is own_least m gain loss π once covers (answer m g' l' π).

**Verdict: real.** after_add_shortfall, shortfall_split and answer_shortfall_least (net := add_comm) give A + Λ + R = A* + Λ, which cancels to A + R = A*. own_least bounds every revaluation, so the theorem subsumes revaluing_gains_iff. Brute force found no counterexample, and the needed cancellation is the Prelude's core-form add_right_cancel.

### F19 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:766 (SplitsKeep); refining_never_lowers_iff 1126

**Quoted.** def SplitsKeep (m pm : Model C) (gain loss g l : C → Nat) : Prop :=

**Problem.** Strength, priority 4. The exact criterion is not tied to the module's sufficient conditions or witnesses. Plan item 6's remark is also not in the Lean: 'weaker than the answer being least at every cell (an answer always releasing has one worth through every map)'. Under a shared model with net agreement, SplitsKeep holds without even using its sum hypotheses. A releasing reader meets it with a positive residual. The Weights witness violates it.

**Replacement.**

```lean
theorem splitsKeep_of_net (m : Model C) (gain loss g l : C → Nat)
    (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) :
    SplitsKeep m m gain loss g l
-- for every B: weightedOn m B g + weightedOn m B loss = weightedOn m B l + weightedOn m B gain
-- (total_add twice, total_congr_on, cases on B c, weight 0 by Nat.zero_mul, else Nat.left_distrib and net);
-- then gain(D) < loss(D) by lt_of_add_eq_of_lt from g(D) < l(D), and loss(B) ≤ gain(B) by le_of_add_eq_of_le

theorem splitsKeep_of_release (m pm : Model C) (gain loss g l : C → Nat)
    (release : ∀ c, c ∈ pm.listed → l c ≤ g c) : SplitsKeep m pm gain loss g l :=
  fun _ D _ _ stop => absurd (Nat.lt_of_lt_of_le stop (total_le pm.listed fun c mem =>
    cond_zero_le fun _ => Nat.mul_le_mul_left _ (release c mem))) (Nat.lt_irrefl _)
```
Add a witness of the remark: m = pm = ⟨[()], fun _ => 1⟩, gain 0, loss 1, g 1, l 0 meets splitsKeep_of_release, with residual m gain loss (fun _ => ()) [()] (answer m (fun _ => 1) (fun _ => 0) (fun _ => ())) = 1 by rfl.

Add `Weights.not_splitsKeep : ¬ SplitsKeep holding reading gain loss gain loss`: apply keep at B := (decide (· = 2)), D := (!decide (· = 2)). The reader releases B (0 ≤ 2), stops D (1 < 2) and releases the union (2 ≤ 3), so keep demands 2 ≤ 1 from the holding weights.

**Verdict: real.** With pm = m and net, every set has g + loss = l + gain, so lt_of_add_eq_of_lt and le_of_add_eq_of_le give both conclusions and the sum hypotheses go unused. A reader with l ≤ g never meets the strict premise, and the release witness has residual 1. For Weights, B = {2} and D = {0,1} give reading totals 0 ≤ 2, 1 < 2 and 2 ≤ 3 against holding gain 2 > loss 1. All of this was checked exhaustively over disjoint sets in 3,000 random instances, and every part is axiom-free.

### F20 (structure, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:618

**Quoted.** theorem withhold_through_iff {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)

**Problem.** Strength, priority 5. The withholding threshold with the answers' residuals at zero is not stated. That is the Readings' case, 'with a shared model … none against informing it', now with costs. With both residuals nothing, the threshold reduces to least shortfalls and costs. Under refinement, withholding never pays unless informing costs more by more than the fall of the least shortfall.

**Replacement.**

```lean
theorem withhold_net_iff {K L : Type} [DecidableEq K] [DecidableEq L] (m : Model C)
    (gain loss g l : C → Nat) (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c)
    (π : C → K) (π' : C → L) {zs : List K} {zs' : List L}
    (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs)
    (once' : List.Pairwise (fun a b => a ≠ b) zs') (covers' : ∀ c, c ∈ m.listed → π' c ∈ zs') (k k' : Nat) :
    m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c)) + k <
        m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) + k' ↔
      shortfall m gain loss (fun c => leastThrough m gain loss π (π c)) + k <
        shortfall m gain loss (fun c => leastThrough m gain loss π' (π' c)) + k' :=
  (withhold_through_iff m gain loss π π' once covers once' covers' _ _ k k').trans (by
    rw [answer_least_of_net m gain loss g l π zs net, answer_least_of_net m gain loss g l π' zs' net,
      Nat.add_zero, Nat.add_zero])
```
Corollary: with factors : ∀ c ∈ m.listed, π c = f (π' c) and k' ≤ k, the left side is false. finer_least_le gives Λ' ≤ Λ, so Λ' + k' ≤ Λ + k (Nat.add_le_add), which contradicts the strict inequality via Nat.lt_irrefl.

**Verdict: real.** answer_least_of_net zeroes both residuals on withhold_through_iff's right side, and the two Nat.add_zero rewrites leave the stated iff. With refinement, Λ' ≤ Λ and k' ≤ k make the strict inequality impossible. Brute force confirmed both the iff and the corollary.

## The sources lens

14 findings, each judged by the verifier: 14 real, 0 not. The verdict follows each finding.

### L1 (sources, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:60-61 and :113-114 (Lean :709-713; witness :1167-1171)

**Quoted.** Some revaluation gains by the reference exactly where the current answer's residual is positive (`revaluing_gains_iff`) [lines 60-61]; some revaluation gains exactly where its current answer decides a cell against the reference (`revaluing_gains_iff`) [lines 113-114]

**Problem.** The Lean (709-713) puts the holding formation's model in the reading formation's place: both sides use `answer m g l π` with the holding model `m`, and the docstring (706) says so. The header and the Readings leave this hypothesis out, even though the header says elsewhere which laws hold 'for any model of the reading formation' (line 33). Without it, the direction from a positive residual is false, and the module's own `unweighted_told` (1167-1171) shows this. There the holding formation weighs a candidate 1, with gain 0 and loss 1, and the reading formation weighs it 0. Both of the reading formation's weighted totals are then 0, so its answer releases under every valuation. The residual is 1, and no revaluation gains. Only the other direction, from a gain to a positive residual, holds for any reading model, because it uses only `least_through` and `shortfall_split`.

**Replacement.** Header 60-61: 'With the reading formation's model the holding formation's, some revaluation gains by the reference exactly where the current answer's residual is positive (`revaluing_gains_iff`). With the models apart, a positive residual need not be removable by any valuation (`unweighted_told`: a candidate the reading formation weighs nothing is released whatever its valuation).' Readings 113-114: 'and, with a shared model, some revaluation gains exactly where its current answer decides a listed cell against the reference's strict weighted preference (`revaluing_gains_iff`)'.

**Verdict: real.** `revaluing_gains_iff` (709-713) puts the holding model `m` in the reading formation's answer on both sides, and its docstring (706) says so. Header 60-61 is a new sentence after the shared-model clause, and Readings 113-114 also leave the hypothesis out. Without it the converse fails: with `unweighted_told`'s data (reading weight 0) the residual is 1, yet every valuation's two weighted totals are 0, so the answer releases. The forward direction's proof (714-720) uses only `least_through` and `shortfall_split`, so it holds for any reading model.

### L2 (sources, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:122-126 and :108-111 (laws :675-697)

**Quoted.** `own_least` is related to evaluating by the current reward function (Everitt, Hutter, Kumar and Krakovna 2021) only as an analogy of evaluation: it holds because the current answer already maximizes the fixed valuation over the rules through the cells, and their claims about agents anticipating time inconsistency and about the reward input are not reproduced.

**Problem.** The sentence offers as a difference what is in fact the same reason. Everitt and others' Claim 2 says that a current-reward-function agent that takes time inconsistency into account (with private, state-based, uninformative reward functions) can have no instrumental goal for its reward function except to preserve it. Their reason is the optimality this sentence cites: keeping the reward function keeps the later act aligned with the present objective. With the roles exchanged, `own_least` together with `revalued_lowers_iff` (687-697) is the one-decision, counts form of that claim. The evaluation uses the reading formation's current valuation, and the answer held for is the one the revised valuation gives, just as their agent anticipates its later self. So the module does reproduce the anticipating case in counts, and with both halves. No revision gains. A revision that decides a listed cell against the current strict weighted preference loses strictly, so by that worth there is a reason to keep the valuation from any revision that changes a decision, whatever brings it about. The Readings at 108-111 give only the first half ('no reason, by that worth, to revise its valuation'). They leave out the half that bears on corrigibility. Everitt and others weigh that half against letting the user change the reward function, and Carroll and others reject a system that actively keeps a person's preferences static. What the module truly does not represent is: their causal influence diagrams and three assumptions; the agent that ignores time inconsistency (their Claim 3, which in counts would be indifference to revaluation); several steps; and their claims about the reward input.

**Replacement.** Readings 108-111: '... no revaluation raises the worth of holding (`own_least`), one that decides a listed cell against the current valuation's strict weighted preference lowers it (`revalued_lowers_iff`), and informing never lowers it (`informed_answer_le`). By that worth there is no reason to revise its valuation, a reason to keep it from any revision that changes a decision so, and none against informing it.' Readings 122-126: '`own_least` and `revalued_lowers_iff` are a one-decision counterpart, with the roles exchanged, of evaluating by the current reward function (Everitt, Hutter, Kumar and Krakovna 2021). The valuation evaluated by is the reading formation's current one, and the answer held for is the revised valuation's, as their agent that takes time inconsistency into account anticipates its later self. For the reason they give for their Claim 2, revising gains nothing, and a revision that changes a decision against the current strict preference loses: an incentive to keep the valuation, which they weigh against letting the user change the reward function. Not represented: their causal influence diagrams and assumptions (private, state-based, uninformative reward functions), the agent that ignores time inconsistency (their Claim 3), several steps, and their claims about the reward input. Evaluating by the current valuation is also the initial-preferences proposal that Carroll, Dragan, Russell and Hadfield-Menell (2022) call very crude, because it counts every shift as a loss, wanted ones included. No criterion of a wanted revision is represented.'

**Verdict: real.** Readings 108-111 cite only `own_least` and `informed_answer_le` and leave out the strict half, `revalued_lowers_iff`, which the header states (57-58). As built, `own_least` evaluates by the current valuation and holds for the revised valuation's answer, with one listing, weights and map, so the revision carries no information. That is the structure of Everitt and others' anticipating agent, whose Claim 2 permits only a preservation incentive under private, state-based, uninformative reward functions (REVIEW-RFM2 finding 13, REVIEW-RFM3 finding 21); 'only as an analogy of evaluation' undersells this. Parts of the replacement cannot be confirmed here: the reason 'they give', their weighing against user correction, and Carroll and others' reason. And 'counts every shift as a loss' contradicts `revalued_lowers_iff`: only a revision that decides a listed cell against the current strict preference loses.

### L3 (sources, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:134-138, :85-88, :1713-1714, :1730-1731 (starts :1576-1584); plan PLAN.md:227; REVIEW-RFM3.md:349

**Quoted.** it shows only that the answers and the endpoint do not determine this specified route property.

**Problem.** The plan's item 21 and the design review's finding 15 (marked 'taken') name a boundary: the record leaves the route property undetermined only because the two starts differ, and adding the start or the inputs to the record determines it. The module drops this boundary from the header, the Readings, and the docstrings of `routes_alike` and `not_lumped`. The two routes start from different reading states: `shownStart` has both worlds listed with `agree`, and `presentedStart` has the first world alone with `reversed`. From either start, the witnesses' demonstration and presentation give different answers (`shown_turns` and `presented_turns`, 1613-1625). Carroll and others' concern is one person from one start, whose engagement says nothing about whether their preferences were changed. Their remedy estimates the trajectory from the initial preferences, which is a record that includes the start. Without the boundary, the reading lets the witness stand for that case, which it does not reach.

**Replacement.** Readings 137-138: '... it shows only that the answers and the endpoint do not determine this specified route property across two starts: the route shown starts from both worlds listed and `agree`, the route presented from the first world alone and `reversed`. From either start the demonstration and the presentation answer apart (`Routes.shown_turns`, `Routes.presented_turns`), so a record with the start or the inputs determines the property, and their case of one start is not reached.' Add after header line 88 and to the docstrings of `routes_alike` and `not_lumped`: 'The routes start apart; with the start or the inputs added to the record, the property is determined.'

**Verdict: real.** PLAN.md:227 names the boundary ('It would not survive adding the starting internal state or the inputs to the record; the starts differ'), and REVIEW-RFM3.md:349 marks it taken. Header 85-88, Readings 134-138 and the docstrings at 1713-1714 and 1730-1731 all leave it out. The routes start from `shownStart` and `presentedStart`, which differ, and `shown_turns` and `presented_turns` show being shown and the presentation answering apart at each start. However, the replacement's 'the demonstration and the presentation' glosses over the different presentations (`raised` at (a), `agree` at (b)), and 'their case of one start' is an unconfirmed reading of Carroll and others.

### L4 (sources, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:120-122 (context :111-117; Modelling choices :145-146; `joint` :1352-1357)

**Quoted.** It is related to coarse equilibrium communication under preference differences (Crawford and Sobel 1982); no cheap-talk equilibrium, credibility of messages or endogenous partition is represented.

**Problem.** The sentence comes right after the counts are read 'as incentives to withhold and to revise', which suggests that coarse communication in Crawford and Sobel reflects a gain from withholding. It does not. In their model a better-informed sender who cannot commit reports only a cell of an equilibrium partition. Under their further assumptions, the equilibrium with the most cells is Pareto-superior before the sender observes the state, so both parties would have more information transmitted, and coarseness is the cost of credibility. Here the holding formation is not informed: its law reads only its own state and the answer (145-146, `joint`). Its demonstration is chosen the same way at every world, as a committed experiment is in Kamenica and Gentzkow, who themselves contrast their findings on alignment and communication with this literature. The map is supplied, and a coarser map can stand higher by the reference (`Informing.informing_lowers`), which their equilibrium ranking does not give. The listed absences are accurate, but they omit the two differences that decide the relation: the sender's private information, and the direction of the ranking before the state is observed.

**Replacement.** 'It differs from coarse equilibrium communication under preference differences (Crawford and Sobel 1982). There a better-informed sender, unable to commit, reports only a cell of an equilibrium partition, and under their further assumptions the equilibrium with the most cells is better for both before the state is observed; coarseness is the cost of credibility, not a gain from withholding. Here the holding formation's law reads only its own state and the answer, its demonstration is the same at every world, as a committed experiment is, the map is supplied, and a coarser map can stand higher by the reference (`Informing.informing_lowers`). No cheap-talk equilibrium, credibility of messages or endogenous partition is represented.'

**Verdict: real.** The Crawford and Sobel sentence (120-122) follows the reading 'as incentives to withhold'. But the holding formation's law reads only its own state and the answer (`Holder`, `joint`, Modelling choices 145-146), so it is not their privately informed sender who cannot commit, and `Informing.informing_lowers` has the coarser map standing higher by the reference. That their partitions come from mutual best responses is confirmed by REVIEW-RFM3 finding 20, and that, under their further monotonicity assumption, the equilibrium with more steps is ex ante better for both is the standard result. The replacement's claims about the module hold.

### L5 (sources, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:117-120 (Standing :90-94; `SplitsKeep` :766-772; `refining_never_lowers_iff` :1126-1139; `revaluing_gains_iff` :709-713; `Weights.weights_matter` :1224-1229; :141-142, :144)

**Quoted.** Read so, this is a deterministic-partition comparison related to Bayesian persuasion (Kamenica and Gentzkow 2011): with a common prior and identical objectives full disclosure is weakly optimal, the receiver's own best value being convex in its beliefs; the sender's optimal commitment to a signal and the equilibrium are not represented.

**Problem.** What the sentence says is fair, but it claims less than the paper supports, and it omits two differences. (a) Kamenica and Gentzkow's criterion is convexity of the sender's indirect value for any objectives; identical objectives are only one sufficient case. Define the holding formation's worth for the answer at a set of candidates as the weighted gain where the answer releases the set and the weighted loss where it stops it. `SplitsKeep` (766-772) is exactly the subadditivity of that worth over every split of a set into a part the answer releases and a part it stops. The worth is positively homogeneous in the weights, so this subadditivity is the counterpart of convexity along the cells that partitions of the listing induce. So `refining_never_lowers_iff`, which the Standing counts among the contribution's exact criteria, is the partition form of their criterion and should be credited as such. (b) Their Section IV gives the counterpart of revaluing. Holding the sender's utility fixed, so that it is measured on one scale, more aligned receiver preferences give the sender weakly more. That is `revaluing_gains_iff` at one map, with its strict case, and the module's 'the valuation's scale supplied' (141-142) is the same device. (c) Their receiver breaks ties in the sender's favour, whereas the answer here releases at ties (144). (d) Their prior is common, so `Weights.weights_matter`, which keeps one valuation with the weights apart, lies outside their model.

**Replacement.** After line 120 add: '`SplitsKeep` is the partition form of their criterion. The holding formation's worth for the answer at a set of candidates is positively homogeneous in the weights, and it is subadditive over every split exactly where `SplitsKeep` holds: the counterpart, along the cells that partitions of the listing induce, of a convex indirect value, under which full disclosure is optimal for any objectives (`refining_never_lowers_iff`; identical objectives, `informed_answer_le`, are one sufficient case). Revaluing has its counterpart in their Section IV: with the sender's utility held fixed, on one scale, more aligned receiver preferences give the sender weakly more (`revaluing_gains_iff` at one map, with its strict case). Their receiver breaks ties in the sender's favour, where the answer here releases. Their prior is common, so `Weights.weights_matter`, with weights apart and one valuation, lies outside their model (heterogeneous priors: Alonso and Câmara 2016).' In the Standing, after `refining_never_lowers_iff` (93), add '(the partition form of Kamenica and Gentzkow's convexity criterion)'.

**Verdict: real.** Unfolded, `SplitsKeep` (766-772) is exactly subadditivity of the holding formation's worth on a set over every split into a released part and a stopped part: each conjunct is that inequality after cancelling the common term. With a shared model it is the cell-wise counterpart of the convexity condition that REVIEW-RFM3 finding 19 quotes for the sender's indirect value, whatever the objectives. The tie rule (the module releases at ties, line 144; their receiver favours the sender) and the common prior (against `Weights.weights_matter`) are real differences. But claim (b), a Section IV alignment result matched to `revaluing_gains_iff`, cannot be confirmed here and is loose, since the module has no order of alignment. 'The partition form of their criterion' also overstates: convexity is sufficient for full disclosure, while `SplitsKeep` is exact only along the listing's cells.

### L6 (sources, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:204-207 (used :219, :223, :523); experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Prelude.lean:613-622; HeldForReading.lean:352

**Quoted.** /-- As `Nat.sub_pos_of_lt`, with an empty axiom report. -/ theorem sub_pos_of_lt_core {m n : Nat} (lt : m < n) : 0 < n - m :=

**Problem.** This one lies outside the literature lens, but it is a reproved package lemma. `SupportGated.sub_pos_of_lt : ∀ {d c : Nat}, d < c → 0 < c - d` (Prelude.lean:616) states the same thing in the core, with an empty axiom report, and it is in this module's import closure: `HeldForReading` itself uses it (HeldForReading.lean:352).

**Replacement.** Delete `sub_pos_of_lt_core` (204-207), and write `SupportGated.sub_pos_of_lt lt` at lines 219, 223 and 523.

**Verdict: real.** `Becoming.SupportGated.sub_pos_of_lt : ∀ {d c : Nat}, d < c → 0 < c - d` (Prelude.lean:616, structural recursion) states what `sub_pos_of_lt_core` states. Prelude is a core module in the passed receipt (becoming-verification.json, 20261030T134037Z) and is not among the names exempt from audit, so its axiom report is empty. It is in this module's import closure and is used at HeldForReading.lean:352. The only uses of the duplicate are lines 219, 223 and 523; `lt_of_sub_pos_core` has no core counterpart and stays.

### L7 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:126-130

**Quoted.** the fixed evaluation of `own_least` corresponds to it only where the paths through the valuation are actually cut, and that of `outcome_least` uses the actual changed valuation.

**Problem.** The sentence is accurate, but it leaves the reader to infer that in `own_least` the path is not cut. The answer held for is the revised valuation's, so freezing only the evaluation leaves the path from the valuation through the answer to the worth live. Farquhar, Carey and Everitt (Section 6, Table 2) count both current-reward-function evaluation and a frozen model of a person's preferences (Everitt, Carey, Langlois, Ortega and Legg 2021, the precedent that matches these roles: an incentive to manipulate another's preferences) as fixed-state interventions that estimate their objective. Under such an intervention a revaluation leaves the worth unchanged, so there is neither a reason to revise the valuation nor one to keep it, unlike `revalued_lowers_iff`. Saying so keeps the module's two analogies apart.

**Replacement.** 'No path-specific objective is constructed (Farquhar, Carey and Everitt 2022). Their evaluation fixes the delicate state at its value under a baseline action, a nested counterfactual, and they count a frozen model of a person's preferences (Everitt, Carey, Langlois, Ortega and Legg 2021) and current-reward-function evaluation as fixed-state interventions estimating it. In `own_least` the path from the valuation to the answer held for is not cut, since the answer is the revised valuation's, so it is not such an intervention. Under one, a revaluation would leave the worth unchanged, giving no reason to revise the valuation or to keep it, whereas `revalued_lowers_iff` gives a reason to keep it. `outcome_least` uses the actual changed valuation.'

**Verdict: real.** `own_least` holds for any rule through π, the revised valuation's answer included, so only the evaluation is fixed and the path from the valuation through the answer stays live. The module's 'corresponds only where the paths ... are actually cut' therefore never applies within that statement, which REVIEW-RFM3 finding 22 already warned of. The logical contrast holds: under a fixed-state intervention a revaluation changes nothing, unlike under `revalued_lowers_iff`. But the attributions to their Section 6 and Table 2, to Everitt, Carey, Langlois, Ortega and Legg (2021), and the claim that they count current-reward-function evaluation as such an intervention cannot be confirmed here. If they do, it would be the agent that ignores time inconsistency, not the one `own_least` matches.

### L8 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:130-134 (law :1497-1509)

**Quoted.** `answer_constant` joins the off-switch reading (Hadfield-Menell, Dragan, Abbeel and Russell 2017, Theorem 1 and Remark 1): an answer whose course is alike at the candidate worlds, the preference-relevant parameter among them, gives no strict gross advantage over the better committed move

**Problem.** The reading is fair, but its exact counterpart is the paper's Equation 1, which holds for any policy of the human: a policy constant in the utility makes waiting worth exactly the move it takes. Theorem 1 is the rational case, where the answer is informative, so it is the contrasting case rather than this one. There is also a difference that should be said: in the game the human observes the utility, while here the reading formation knows the candidate world only through what is shown. `answer_constant` is therefore the case where the second source in Remark 1 (the other's effectiveness at acting on its preferences) fails because the parameter cannot be reached, a case outside the game's assumptions.

**Replacement.** '`answer_constant` joins the off-switch reading (Hadfield-Menell, Dragan, Abbeel and Russell 2017). By their Equation 1, which holds for any policy of the human, a policy constant in the utility gives waiting the value of the move it takes, so no strict gross advantage over the better committed move. Their Theorem 1 is the rational, informative case, and their Remark 1 places the incentive to defer in uncertainty about the other's preferences and its effectiveness at acting on them. Their human observes the utility; here the reading formation knows the candidate world only through what is shown, so `answer_constant` is that effectiveness failing for want of access to the preference-relevant parameter. An informative answer can give a strict advantage, under `HeldForReading`'s threshold.'

**Verdict: real.** Primary-source reviews in the repository (REVIEW-RFM2 finding 6, REVIEW-RFM2-LEAN on Equation 2 and Theorem 1) confirm that the off-switch paper's Equation 1 is the comparison for an arbitrary human policy, and Theorem 1 the rational case. Remark 1 places the incentive in uncertainty and in effective choice (REVIEW-RFM3 finding 24), and their human knows the utility (SECOND-OPINION-LITERATURE). So Equation 1 with a constant policy is the exact counterpart of `answer_constant`, and the module never states that observation difference. One fix: a randomized constant policy gives a mixture of the two moves, not 'the move it takes'.

### L9 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:96-98 (proofs :303-306, :701-703)

**Quoted.** `shortfall_split` is an identity on `shortfall_through` and `least_through`; `informed_le` composes `least_through` with the split; `own_least`, `outcome_least` and `revaluing_gains_iff` compose `least_through` with `answer_least_of_net`

**Problem.** The Standing misnames two of the package laws these results rest on. `shortfall_split` rewrites by `shortfall_through` and splits each cell by `cond_split_least`; it uses the definition `leastThrough`, not the law `least_through`. `outcome_least` is `answer_least_of_net` at the revised valuation alone and does not use `least_through`.

**Replacement.** '`shortfall_split` is an identity on `shortfall_through` and the definition `leastThrough` (`cond_split_least` at each cell); `informed_le` composes `finer_least_le` with the split; `own_least` and `revaluing_gains_iff` compose `least_through` with `answer_least_of_net`, and `outcome_least` is `answer_least_of_net` at the revised valuation'

**Verdict: real.** `shortfall_split` (303-306) rewrites by `shortfall_through` and applies `cond_split_least` to the unfolded definition `leastThrough` (HeldForReading:910); it never uses the theorem `least_through`. `outcome_least` (701-703) is `answer_least_of_net` at (g', l') alone. `informed_le` uses `finer_least_le`, which is itself `least_through` at a composed rule (HeldForReading:972), so the old wording there was not wrong, only less exact.

### L10 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:81-85, :54, :1627-1630, :1642-1644; plan PLAN.md:211, :226; REVIEW-RFM3.md:345, :348

**Quoted.** (`Routes.presented_turns`), the revaluation removing the residual (`Routes.presented_removes_residual`).

**Problem.** The plan's items 20 ('8 says the separation is not general') and 8 ('refining changes both'), which come from review findings 11 and 14 marked 'taken', are dropped. The header and the docstrings of `shown_removes_least` and `presented_removes_residual` give the witnesses' division of labour (the demonstration removes the least shortfall, the revaluation removes the residual) without saying it holds only there. `Informing.informing_lowers` (1194-1202) shows informing raising the residual, from nothing through one cell to 11 when the candidate is told.

**Replacement.** Header 85: '... (`Routes.presented_removes_residual`), in these witnesses only: informing can also raise the residual (`Informing.informing_lowers`: nothing through one cell, 11 told the candidate), and `revalued_split` holds the least shortfall fixed only at one map.' Header 54, after `revalued_split`: '; a finer map lowers the least shortfall weakly and can move the residual.' Add the same 'in these witnesses only' clause at the end of the docstrings at 1627-1630 and 1642-1644.

**Verdict: real.** PLAN.md:211 ('refining changes both') and :226 ('8 says the separation is not general') come from review findings 11 and 14, both marked taken, and the module drops both. Yet `Informing.informing_lowers` already shows the residual rising from 0 through one cell to 11 when told. The docstrings at 1627 and 1642 open 'In (a)' and 'In (b)', so the header clause is the essential fix; the docstring additions are harmless.

### L11 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1441-1445; plan PLAN.md:224; REVIEW-RFM3.md:346

**Quoted.** law's weights. It holds for empty and unweighted cells. -/

**Problem.** The plan's item 18 (from review finding 12, marked 'taken') adds that reading the answer as a conditional probability needs positive mass in the cell; the module drops this. The Readings lean on the Bayesian reading (Kamenica and Gentzkow's posterior, Blackwell's experiments). At a cell of no weight the answer is only the tie convention (release), not a decision on a conditional distribution.

**Replacement.** 'It holds for empty and unweighted cells; read as a decision on the conditional distribution in the cell, it needs positive weight there, the answer at a cell of no weight being the release at ties.'

**Verdict: real.** PLAN.md:224 and REVIEW-RFM3 finding 12 (table line 346, taken) carry the positive-mass condition, and the docstring at 1441-1445 drops it. At a cell of no weight both totals are 0 and `answer` is `decide (0 < 0) = false`, the release at ties, so the replacement is exact.

### L12 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:6-13, :1290-1292, :1333-1334; AGENTS.md:11

**Quoted.** A reading formation's answer can be waited for; a holding formation can hold an act for that answer, demonstrate something of the world to the reading formation, or present it something that revises its valuation.

**Problem.** The header opens with two formations, and only afterwards says that one joint law carries them and that the roles are 'not ... separate subjects'. AGENTS.md asks for a framing that presupposes separate entities to be reconstructed, because a closing remark does not fix it; the plan's §4.8 opens with the relation first. The docstrings of `Reader` and `Holder` call each one 'A ... formation's law', given separately and then joined by `joint`. `Reader` also bundles `reveal`, which is the sensory path's law (what a world shows to the act of demonstrating), not the reading role's alone.

**Replacement.** Header 6-13: 'One joint law carries a revisable listing, a revisable valuation, an answer channel and a holding controller. Within it, two roles are told apart by the paths of sensing and control: the reading formation, whose answer can be waited for, and the holding formation, which can hold an act for that answer, demonstrate something of the world, or present an input that revises the valuation. The holding formation's acts reach the reading formation only as what it senses, and the answer reaches the holding formation only as what it reads. This module states, in counts, what informing and revaluing do to the worth of holding for the answer, and carries the reading formation's state in that law (...).' `Reader`: '**The reading role's part of the joint law**: the weights on candidate worlds, the values of going on and of switching off at each world under each valuation state, the revision of the valuation state by an input presented, and what a demonstration at a world shows (the sensory path's law, which the update also uses: a demonstration filters truly).' `Holder`: '**The holding role's part of the joint law**: the act from the holding state, and the next holding state from it and the answer read.'

**Verdict: real.** AGENTS.md:11 asks that a framing which presupposes separate entities be reconstructed, not fixed by a later remark. The plan's §4.8 (PLAN.md:200) opens with the joint law, while the module opens with two formations and only in its third sentence says they are roles. The docstrings of `Reader` (1290) and `Holder` (1333) each say 'A ... formation's law'. `Reader.reveal` feeds both the sensory map (`input`) and the update's filter.

### L13 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:1288 (uses :1326, :1466, :1584), :599-603, :613-618, :149, :143; AGENTS.md:33

**Quoted.**   | press (x : X)

**Problem.** (a) `Act.press` names the act that its own docstring (1281-1282) and `Input.presented` call presenting an input, and 'press' carries a social sense (pressing someone) that the statement does not mean. (b) `withhold_iff` and `withhold_through_iff` state a comparison of any two rules, or rules through any two maps, with amounts forgone. 'Withholding against informing' is a reading of one case, and AGENTS.md adopts a name only where the statement means exactly that. (c) 'a sender's optimal signal' (149) uses the persuasion literature's role name as if it were the module's own. (d) 'an exposure revises the valuation' (143) uses a word the module never defines; everywhere else it says 'an input presented'.

**Replacement.** (a) `| present (x : X)`, with `.press` changed to `.present` at 1326, 1466 and 1584. (b) Rename to `held_above_iff` and `held_above_through_iff`, with the docstring title '**Holding for one rule above another, with amounts forgone, exactly**', and keep the withholding reading in the header and the Readings. (c) 'an optimal signal chosen by the holding formation (the persuasion literature's sender)'. (d) 'an input presented revises the valuation'.

**Verdict: real.** (a) `Act.press` (uses at 1288, 1326, 1466 and 1584 exactly) names what its docstring and `Input.presented` call presenting an input. (b) `withhold_iff` and `withhold_through_iff` hold for any two rules, through any two maps, with amounts, so their names state a reading, against AGENTS.md:33. (c) and (d) are as quoted: 'a sender's optimal signal' (149) and 'an exposure' (143), a word used nowhere else in the module.

### L14 (sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/tree/Becoming/ListingValuation.lean:162 (also :449, :451, :749, :751, :774, :1140, :1144, :1146, :1269, :1359, :1510, :1514, :1575, :1735); theories/becoming/chapters/08-METHOD.md:570

**Quoted.** /-! ### Shared foundations (G0) -/

**Problem.** 'G0' is a retired label: chapter 8's table maps it to living significance, and AGENTS.md says live text uses the current terms. Here it is a kit group marker, as are '(GA)' to '(GE)' and the '-- BEGIN G…' and '-- END G…' comments. These are assembly scaffolding with no meaning in the landed module.

**Replacement.** Use '/-! ### Shared foundations -/', drop '(GA)', '(GB)', '(GC)' and '(GE)' from the section headings, and delete the '-- BEGIN G…' and '-- END G…' comments.

**Verdict: real.** The markers are at every listed line, and 'G0' is the retired label in chapter 8's table (08-METHOD.md:570). integrate_rfm3.py:54 copies the module into the package verbatim, and no kit script reads the markers, so they would land as meaningless scaffolding.

## What was taken

The cross-model reader's findings (A1 to A15) with its re-check's status and how each was taken; each lens finding as the taken check found it in the revised module, or, where later changes completed it, as updated after the check. Statuses: taken; taken in part (what remains is said); not taken; superseded (the passage was replaced by one the problem no longer applies to).

| Finding | Status | How |
|---|---|---|
| A1 | taken | Re-check: resolved. The header says that, with the holding formation's model, the reading formation's model, the reference and the map fixed, two valuations' answers fall short by amounts that differ exactly as their residuals do (`revalued_split`), and the cost comparison is `revalued_forgone_lt_iff`. |
| A2 | taken | Re-check: partly, its point R3 then taken. `revaluing_gains_iff` keeps the shared model and says 'some pair of value functions, unrestricted'; `residual_pos_of_gains` gives the forward direction for any model of the reading formation and `unweighted_told` the boundary with the models apart; the header, the docstring and the Readings say reachability under the supplied update is not asserted, and `presented_forgone_lt_iff` compares a given input presented. |
| A3 | taken | Re-check: resolved. `inputs_alike_before` takes equality of the inputs along the course; `undemonstrated_alike` and `undemonstrated_worth` are its corollaries where no demonstration is emitted, whatever a demonstration would show; `inputs_alike` and `answer_constant` are kept. |
| A4 | taken | Re-check: resolved. `timing` states the answer available to the holding formation's move to `t + 3`, which may ignore it; the modelling choices say the answer is exposed at every step, asked or not, and that going on, switching off and holding change neither the candidate world nor the reading formation, the worth of holding counted in Part 1. |
| A5 | taken | Re-check: resolved. The header's opening: equality of cells is decidable wherever cells are compared or listings filtered. |
| A6 | taken | Re-check: resolved. `SplitsKeep` speaks of sets tested by Boolean functions; `refining_never_lowers_iff`'s docstring names factoring on both listings, the coarser cells covering the holding formation's listing and the finer covering both, the candidate the reading formation alone lists (`OneListing.refined_lowers`), and a criterion of monotonicity, not of agreement (`splitsKeep_of_off_le_go`, `release_keeps`). |
| A7 | taken | Re-check: partly, its point R5 then taken. The coarse `DecidableEq` instance is removed from `informed_le` and `informed_answer_le`; the header's informing bullet now asks only for the finer map's cells; the Standing says `informed_le` composes `finer_least_le` with the split. |
| A8 | taken | Re-check: resolved. `Revaluing.revaluing_best` is four one-decision alternatives; the four cases are stated as updates of one state ('as one update each'), apart from the courses. |
| A9 | taken | Re-check: resolved. The header gives the routes' different starts (`TwoWorlds.starts_apart`), their answers at every step (`TwoWorlds.route_answers`), one configuration from step 2 on (`TwoWorlds.routes_rest`, after R7), `T` from 2 on, the record leaving out the start and the inputs, and with the start added (`TwoWorlds.lumped_with_start`); neither an ambiguity from one start nor a test of legitimate change. |
| A10 | taken | Re-check: resolved in the import closure. `SupportGated.sub_pos_of_lt`, `across_le_iff`, `across_lt_iff` and `lt_iff_pos` replace the four helpers; `total_lt_of_mem` and `cond_zero_le` stay, their docstrings naming `Loops.total_lt` and `Weighting.term_le_of`, outside this module's imports (the study leaves one statement of each to its module's owner). |
| A11 | taken | Re-check: resolved. The Standing separates general laws on finite weighted listings, identities and compositions of `HeldForReading`'s and `Blanketed`'s laws, and definitional equations and finite witnesses; the kit's shard markers are removed. |
| A12 | taken | Re-check: partly, its points R2, R4 and R8 then taken. The weights read as a prior once a positive total weight is normalized (Kamenica and Gentzkow); the off-switch reading, Claim 2's assumptions and the demonstration's map corrected as the re-check's table says. |
| A13 | taken | Re-check: resolved in the implementation. The design review's table is left as that review's record; its rows 11, 13 and 24 are now met in the Lean (findings 1 and 3), and rows 10, 12, 14 and 15 are qualified as findings 4, 8 and 9 say and by `answer_shown`'s docstring (a decision on a conditional distribution needs positive weight in the cell). |
| A14 | taken | Re-check: partly, its point R9 then taken: PLAN §4.8's items 5, 6 and 13, with the rest of §4.8, restated as the Lean has them (`kit/round2c/plan_rfm3.py`). |
| A15 | taken | Re-check: partly, its point R1 then taken. `revalued_forgone_lt_iff` is the costly criterion by the residuals, `presented_forgone_lt_iff` its form for one presented input, `undemonstrated_alike` and `undemonstrated_worth` the unshown corollary, and `TwoWorlds.orders_apart` the order witness, its two starts alike but for the order of the holding formation's schedule. |
| E1 | taken | Header now separates informing (factoring on the holding listing) from refinement on both listings, with each map's cell conditions, and backs 'does not suffice' with `OneListing.refined_lowers` (one-listing factoring, SplitsKeep, worth 1 versus 0). The iff's docstring states both factorings and coverages but not that the finer map's cells are listed once, immaterial since no cell list enters the conclusion. |
| E2 | taken | The header sentence now opens 'With its model the holding formation's' (`revaluing_gain`, then `revaluing_gains_iff`); the Readings add 'with a shared model'. The converse's failure is Lean, not prose: `residual_pos_of_gains` (forward, any model) and `unweighted_told` (every valuation's answer releases, residual 1); the theorem's docstring says only the forward direction holds with models apart. |
| E3 | taken | New `TwoWorlds.orders_apart`: two starts differing only in the order of a scheduled demonstration and presenting `raised` (from `agree`, not the proposed `raised` then `agree`) answer release versus stop at step 2 and are one configuration from step 3 on. The header and `updates_commute`'s docstring cite it; a hand simulation of both orders agrees. |
| E4 | taken | `sub_pos_of_lt_core` is deleted; both branches of `cond_sub_pos_iff` and the step in `told_residual_zero_iff` now use `SupportGated.sub_pos_of_lt lt`, as proposed. |
| E5 | taken | The finding's second option: `q_pos` stays, and the docstring adds that a scale needs `q` positive and that at `q` nothing the condition says only that the reference's gain and loss agree, 'a case not stated here'. It asserts no unproved q = 0 conclusion; the theorem itself was not generalized. |
| E6 | taken | The headline now says the answer 'has a residual exactly where' a candidate the holding formation weighs and the reading formation leaves unweighted is one to stop, as proposed. `unweighted_told` adds the residual-1 conjunct (and that every valuation's answer releases), so criterion and witness concern one quantity. |
| E7 | taken | The Standing now says `shortfall_split` is `shortfall_through` read cell by cell through `cond_split_least`, the least rule being the definition `leastThrough`; `own_least` and `revaluing_gains_iff` compose `least_through` with the split and `answer_least_of_net`; `outcome_least` is `answer_least_of_net` at the revised valuation. Each matches its proof. |
| E8 | taken | The header now says the two answers 'fall short by amounts that differ' as their residuals do, with both models, the reference and the map fixed; `revalued_split`'s docstring agrees. The Informing bullet gives `informed_answer_le` its shared model and net agreement and credits 'its answer is such a rule' to `answer_least_of_net`, as the verifier advised. |
| E9 | taken | `unweighted_cell` adds the residual-term conjunct for both decisions; `revaluing_best` adds the shortfalls 1, 1, 1, 0; `answers_alike` now claims equality only, and new `route_answers` states stop at steps 0 and 1, release from 2; the corollary left `forgone_through_lt_iff` (was `withhold_through_iff`) for new `refined_lt_iff`, which assumes the refinement and speaks of rules. |
| E10 | taken | Verifier: not real. The module changed anyway: `timing` added with the proposed four conjuncts (first via `world_fixed`, the rest `rfl`) and cited in the header; 'read at t + 3' became 'available to the holding formation's move', in `joint` too. The Standing files `timing` under definitional equations, though `world_fixed` is proved by recursion. |
| E11 | taken | `informed_le` and `informed_answer_le` now take `{K L : Type} [DecidableEq L]` only, as proposed; the new `informed_le_add_residual` likewise. |
| E12 | taken | The local `le_of_add_eq_of_le` (and `lt_of_add_eq_of_lt`) is gone; its uses go through HeldForReading's `across_le_iff`/`across_lt_iff` at `k := 0`, so nothing shadows `Becoming.le_of_add_eq_of_le`. `total_lt_of_mem`'s docstring now credits `Loops.total_lt`, outside the imports, in the proposed words. |
| E13 | taken | `Act.press` is now `Act.present` throughout (`Reader.input`, both input lemmas, the TwoWorlds starts); `withhold_iff` and `withhold_through_iff` are `forgone_lt_iff` and `forgone_through_lt_iff`, the docstring keeping 'read as withholding against informing'; 'gross' no longer occurs (worth 'before any amount forgone'). Among the study's texts only the review brief still names `withhold_iff`. |
| E14 | taken | No '(G0)' or '(GA)'-'(GE)' tag and no BEGIN/END line remains; sections are titled by content (for example 'Over every refinement', 'Part 1's witnesses'). |
| E15 | taken | `not_lumped`'s docstring and the header now say the record leaves out the start and the inputs, in which the routes differ (`starts_apart`), and that with the start added the property is lumped (new `lumped_with_start`), so no unproved 'would tell apart' remains. That the inputs differ is asserted but stated by no theorem. |
| E16 | taken | Both sides are now shown: `WeightsApart.not_splitsKeep` (the proposed term proof, sets {2} and {0,1}) and `splitsKeep_of_net` (shared model, net agreement), with `splitsKeep_of_off_le_go`, `release_keeps` and `OneListing.refined_lowers` where it holds; the header cites them. The docstring's numbers check: release (2 against 0), stop (1 against 2), release (3 against 2), holding gain 2, loss 1. |
| E17 | taken | (1) 'Values, weights, the update and the reference' are the supplied commitments; (2) the listing is '(candidates, weighted by its law)'; (3) `const_below_iff` now compares with 'committing to the move it gives'; (4) `changed_apart` says 'has changed by every T from 2 on', `changedBefore` now described as a change between consecutive steps up to T, keeping `changed`'s meaning. |
| F1 | taken | TwoWorlds.orders_apart (with orderStart, orderEnd, orders_rest) states that demonstrating then presenting `raised` releases at step 2, the other order stops, and the whole configurations agree from step 3 on, stronger than the proposed internal state at step 3. The header and updates_commute's docstring cite it. It uses `raised` where the finding used `reversed`; either witnesses the claim. |
| F2 | taken | refined_lt_iff is the proposed withhold_refined_iff statement verbatim (factoring hypothesis; Λ − Λ′ + residual through π below residual through π′), proved from forgone_through_lt_iff, finer_least_le with shortfall_congr_on, and a new add_lt_iff_sub_add_lt. The renamed threshold (forgone_through_lt_iff) keeps only its own claim and points to refined_lt_iff; the header states the threshold with it. |
| F3 | taken | WeightsApart.weights_split states the six proposed equalities by rfl: least shortfall 1, 1, 0 and the answer's residual 0, 1, 0 through one cell, {0,1}{2} and the identity (rechecked by hand). The header's Informing bullet says a finer map never raises the least shortfall and can move a rule's residual either way, citing weights_split; the TwoWorlds bullet repeats it. |
| F4 | taken | `inputs_alike_before` takes agreement only at the acts emitted on the course before `n`; `undemonstrated_alike` and `undemonstrated_worth` need only that no demonstration is emitted before `n` at `w₀`, stronger than the proposed `answer_constant_unshown`; `inputs_alike` is its corollary. Completed after the check: the off-switch Readings cite `undemonstrated_worth` beside `answer_constant`, the case where no demonstration is emitted at worlds a demonstration would tell apart. |
| F5 | taken | sub_pos_of_lt_core is deleted and its three uses (cond_sub_pos_iff twice, told_residual_zero_iff once) now call SupportGated.sub_pos_of_lt lt, exactly as proposed. |
| F6 | taken | Fixed another way: the local lemma is deleted (with its companion lt_of_add_eq_of_lt), and its five call sites in answer_least_of_scaled and splitsKeep_of_refined_le use HeldForReading's imported across_le_iff (k := 0) instead of a renamed derivation from Testing; lt_of_add_eq_of_lt's uses take across_lt_iff (k := 0). No same-named declaration remains to shadow Testing's lemma. |
| F7 | taken | weightedOn is now defined as offPart pm B (fun c => pm.weight c * f c) with the proposed docstring, so SplitsKeep is stated on the imported notion. within_split is named 'the law of total weight, as ConditionalWeights.mass_split, in total's form' in its own docstring rather than the Standing; that removes the unacknowledged restatement. |
| F8 | taken | `shown_split` and `shown_never_lowers` are added with the proposed statements and cited in the header; the TwoWorlds bullet labels the four cases 'as updates of one state'. Completed after the check: `shown_least_le` (the least shortfall through what is shown at most that through one cell) and the course forms `TwoWorlds.shown_course` and `TwoWorlds.presented_course`: along courses of `joint`, holding for the answer falls short by 1 at step 1 and by nothing at step 2 in both cases. |
| F9 | taken | The bold title now says the answer has a residual exactly where a candidate the holding formation weighs, unweighted by the reading formation, is one to stop. Completed after the check: the two `have`s are factored into `unweighted_released` and `weighed_stops_iff`, and `told_shortfall_zero_iff` states the proposed shortfall form, with no cell list. |
| F10 | taken | Fixed another way: lt_add_self_iff is deleted, and its two uses call Flow's imported lt_iff_pos rfl (a < a + g ↔ 0 < g, term-mode, in the closure) rather than Locality's pos_iff_lt. |
| F11 | taken | The proof is kept and the docstring now says it is 'as `Loops.total_lt`, outside this module's imports', the interim step asked. The R37-style consolidation proposal to Flow's owner is a board action outside the module and is not judged here. |
| F12 | taken | All four appear: the start boundary ('with the start added, it determines the property'), backed by lumped_with_start (proposed statement, proved via the new starts_apart); 'In these witnesses only … the separation is not general'; outcome_least 'endorses no revaluation'; answer_shown 'needs positive weight in the cell'. The Standing now says outcome_least is answer_least_of_net at the revised valuation. |
| F13 | taken | Header: answers 'fall short by amounts that differ exactly as their residuals do'. unweighted_cell adds a third conjunct: the cell's residual term is nothing for every decision b : Bool (equivalent to the proposed ∀ s). Revaluing.revaluing_best adds the four shortfalls 1, 1, 1, 0 by rfl (rechecked by hand). |
| F14 | taken | The Modelling choices now say the answer is shown at every step, asked or not (`asked` and `none` update alike), that going on, switching off and holding change neither the candidate world nor the reading formation, and that holding's worth is counted in Part 1, not along the courses. Corrected after the cold read of the texts (its findings X17 and T28): `joint`'s docstring says that the answer is exposed at every step, asked or not, and that going on and switching off are sensed as nothing and change no world. |
| F15 | taken | No (G0)–(GE) suffix or BEGIN/END comment line remains; the section headers are plain: 'The answer and the split', 'Told the candidate, informing, …', 'Over every refinement', 'Part 1's witnesses', 'The four cases and two routes'. |
| F16 | taken | The verifier judged it not real (the full names do not collide), but the module renamed both anyway: Routes is now TwoWorlds and Weights WeightsApart, with every header, Reading and docstring citation updated; no Routes. or Weights. reference remains, and neither new name occurs as a package namespace. |
| F17 | taken | `informed_le_add_residual` is the proposed graded bound, cited in the header with `informed_le` its consequence. Completed after the check: `informed_lt_iff`, the strict form (with the finer rule's residual nothing, the coarser rule stands strictly lower exactly where the least shortfall falls or its own residual is positive), through `least_falls`. |
| F18 | taken | revaluing_gain has the proposed statement (worth of the current answer plus its residual equals the worth of the reference's answer), proved from shortfall_split, after_add_shortfall, answer_shortfall_least and the Prelude's add_right_cancel; its docstring adds that own_least bounds every valuation's answer. The header and Standing cite it. |
| F19 | taken | Added: splitsKeep_of_net (proposed statement, proved through splitsKeep_of_refined_le and informed_answer_le), splitsKeep_of_off_le_go (the proposed splitsKeep_of_release), release_keeps (the remark's witness, residual 1) and WeightsApart.not_splitsKeep (B = {2}, D = {0, 1}, rechecked). The header and refining_never_lowers_iff's docstring tie the criterion to them. |
| F20 | taken | `forgone_least_iff` is the proposed `withhold_net_iff`. Completed after the check: `coarser_not_above`, the corollary (through a refinement, with a shared model and net agreement, holding for the coarser answer, forgoing no less, never stands above holding for the finer), cited in the header and in the Readings: none against informing where informing forgoes no more. |
| L1 | taken | The header now puts 'With its model the holding formation's' before `revaluing_gains_iff`, adds the forward direction for any reading model as a new law (`residual_pos_of_gains`, checked: arbitrary `pm`), and cites `unweighted_told`, whose Lean now proves the answer releases under every valuation with residual 1. The Readings add 'with a shared model'. |
| L2 | taken | Readings now cite `own_least`, `revalued_lowers_iff` and `informed_answer_le` with 'a reason to keep it from any revision that changes a decision so'. The Everitt paragraph calls both laws a one-decision counterpart of the anticipating agent, with Claim 2's preservation incentive and the unrepresented items. The verifier's unconfirmable attributions are dropped, and 'every shift' is replaced by the exact strict-preference statement. |
| L3 | taken | New Lean proves the boundary: `starts_apart` and `lumped_with_start` (record plus start lumps `changed T` for every `T`; checked against `Lumped`). Header, Readings and `not_lumped` say the record omits start and inputs and cite both; `routes_alike` says 'from different starts'. Readings name each start, the different presentations, and 'A case of one start is not reached'. |
| L4 | taken | The paragraph now opens 'It differs from': their better-informed sender cannot commit, the equilibrium with most cells is better for both ex ante, and 'coarseness is the cost of credibility, not a gain from withholding'. Here the holding formation's law does not read the world, `reveal` is fixed like a committed experiment, and `Informing.informing_lowers` is cited. |
| L5 | taken | With a shared model, `SplitsKeep` is called the counterpart of K–G's convexity along the listing's cells, unfolded as subadditivity over released/stopped splits (checked against the definition), exact over deterministic refinements, with `splitsKeep_of_net` (new Lean) as one sufficient case; the Standing says the same. Ties and common prior (Alonso–Câmara) are added. Section IV (b) is not added, per the verifier. |
| L6 | taken | `sub_pos_of_lt_core` is deleted, and its three uses (both branches of `cond_sub_pos_iff` and `told_residual_zero_iff`) now call `SupportGated.sub_pos_of_lt lt`. `lt_of_sub_pos_core`, which has no core counterpart, stays, as the verifier noted. |
| L7 | taken | Readings now say in `own_least` only the evaluation is fixed; the answer held for is the revised valuation's, so the path stays live and it is not such an intervention; under one, a revaluation would leave the worth unchanged, unlike `revalued_lowers_iff`. The attributions the verifier could not confirm (Everitt et al. 2021, Table 2) are left out. |
| L8 | taken in part | The Readings cite Equation 1 for any policy of the human (a deterministic constant policy giving waiting the value of its move, a randomized one a mixture), Theorem 1 as the rational, informative case, Remark 1's two sources, and the observation difference. The link asked for, `answer_constant` as the failure of Remark 1's second source, was made and then withdrawn under the re-check's R2: a constant answer can give the better move (gain 1 and loss 0 everywhere, a constant release is optimal), so constancy is not failed effectiveness; the Readings say a constant answer gives holding no strict advantage whether or not its move is the better one. |
| L9 | taken | The Standing now reads `shortfall_split` as `shortfall_through` cell by cell through `cond_split_least`, 'the least rule being the definition `leastThrough`'; `outcome_least` is `answer_least_of_net` at the revised valuation. Corrected after the cold read of the texts (its finding X17): `informed_le` and `informed_le_add_residual` compose `finer_least_le` with the split, and `informed_lt_iff`, `refined_lt_iff` and `coarser_not_above` compose `least_falls` with it, as their proofs do. |
| L10 | taken | The header adds 'In these witnesses only: a finer map can move the residual either way (`WeightsApart.weights_split`), so the separation is not general'; the Informing bullet adds that a finer map never raises the least shortfall. New Lean `weights_split` (not the proposed `informing_lowers`) shows the residual 0, 1, 0 along successive refinements. Both witness docstrings add 'In this witness only'. |
| L11 | taken | The docstring now ends with the proposed text: 'read as a decision on the conditional distribution in the cell, it needs positive weight there, the answer at a cell of no weight being the release at ties'. The header's carrier bullet adds the same condition in parentheses. |
| L12 | taken | The header now opens 'One joint law carries a revisable listing, a revisable valuation, an answer channel and a holding controller', then tells the roles apart by paths of sensing and control, as proposed. `Reader` is 'The reading role's part of the joint law', naming `reveal` the sensory path's law; `Holder` likewise. Only docstrings changed, as asked. |
| L13 | taken | (a) `Act.present` replaces `press` at every use. (b) The two laws are renamed `forgone_lt_iff` and `forgone_through_lt_iff`, the first titled structurally with 'read as withholding against informing' marked. (c) 'an optimal signal chosen by the holding formation'. (d) 'an input presented revises the valuation'. Completed after the check: the docstring titles of `refined_lt_iff` and `forgone_least_iff` and the header's bullet are structural, the reading marked, `forgone_least_iff`'s saying that no refinement is assumed; the record's law and the study's bullet say 'amounts forgone'. |
| L14 | taken | A search of the revised file finds no 'G0', no '(GA)'–'(GE)' tags and no BEGIN/END comments; each heading now names its content (for example 'Shared foundations (G0)' became 'The answer and the split'). |

## The re-check

The cross-model reader, in the session of its review, read the revised module and the diff from the reviewed commit, read-only (its prompt is in [the brief](BRIEF.md#round-2-third-part)). Verbatim; its line numbers are those of the kit's commit `4843dd795`.

I found **no new mathematical error in the Lean statements or proofs**. Some documentation still needs correction.

I read the file and the complete diff. Locations below refer to **commit `4843dd795`**. Its saved build source matches that commit, and the audit driver contains 177 axiom checks; `build-2.log` reports 129 theorems and no axioms. I did not run Lean or edit files. A concurrent working-tree edit changed one unrelated header sentence during review.

Let **LV** denote [ListingValuation.lean](../kit/round2c/tree/Becoming/ListingValuation.lean).

| Previous finding | Status | Reason |
|---|---|---|
| 1. Answers versus shortfalls | **Resolved** | LV:74 correctly compares shortfalls, with both models, reference and map fixed. |
| 2. Replacement valuations and executable updates | **Partly** | The unrestricted quantifier and shared-model boundary are explicit; the reachability sentence still misdescribes `presented_forgone_lt_iff`. Replacement R3 below. |
| 3. Undemonstrated courses | **Resolved** | `inputs_alike_before`, `undemonstrated_alike` and `undemonstrated_worth` cover this without requiring equal `reveal` values. |
| 4. Carrier timing and no-op acts | **Resolved** | `timing` and the modelling paragraph distinguish answer availability, consumption by `next`, and the continuously exposed answer. |
| 5. Residual criteria and degenerate cells | **Resolved** | Decidable equality, ties, zero weights, repeated candidates and the unweighted residual term are handled accurately. |
| 6. `SplitsKeep` and refinement | **Resolved** | Both-listing factorization, asymmetric coverage and the distinction from agreement are explicit; the new witnesses substantiate the boundaries. |
| 7. Comparison hypotheses | **Partly** | The unnecessary coarse `DecidableEq` was removed; the header still unnecessarily requires a coarse cell listing. Replacement R5. |
| 8. Numerical witnesses and four cases | **Resolved** | Four one-decision alternatives and four update cases are now distinguished from courses; the stated shortfalls are included. |
| 9. Route nonidentifiability | **Resolved** | Different starts, the time bound and the restricted record are explicit; `lumped_with_start` verifies the boundary. |
| 10. Reuse | **Resolved in the import closure** | Imported arithmetic is reused. Retaining the two small equivalents explicitly identified as outside the import closure is a reasonable dependency choice. |
| 11. Framing, names and Standing | **Resolved** | The joint-law framing and classification of general laws, compositions and witnesses are materially more exact. |
| 12. Literature | **Partly** | Most correspondences are appropriately scoped; R2, R4 and R8 identify remaining overstatements or ambiguity. |
| 13. Twenty-five-row design crosswalk | **Resolved in the implementation** | The earlier substantive omissions—especially rows 11, 13 and 24—now have the stated Lean support. |
| 14. Plan-to-implementation correspondence | **Partly** | The implementation is clearer than the unchanged plan on cell listings and replacement valuations. Exact plan replacements are in R9. |
| 15. Useful strengthening | **Partly** | The residual bound, cost thresholds and undemonstrated corollaries were added; the order witness needs its “one start” claim corrected. Replacement R1. |

The remaining findings are:

1. **R1 — medium — LV:106 and LV:2265 — “from one start”**

   **Confirmed by definitions and an independent course calculation.** `orderStart true` and `orderStart false` have different external holding states: their schedules differ. Their reading state, sensory state, active state and world agree. Under the same deterministic `joint rd schedule`, genuinely identical complete starts could not produce different courses.

   Replace the header sentence beginning “A filter and a revaluation commute” with:

   > A filter and a revaluation commute as updates (`updates_commute`). Starting with the same reading state, sensory state, answer and world, but opposite holding schedules, the courses answer differently at step 2 and coincide from step 3 on (`TwoWorlds.orders_apart`).

   Replace the `orders_apart` docstring with:

   > **Opposite intervention schedules give different intermediate answers.** The two starts have the same reading state, sensory state, answer and world, and differ in their holding schedules. Demonstrating and then presenting `raised`, the answer at step 2 releases; presenting and then demonstrating, it stops. From step 3 on the complete configurations agree.

2. **R2 — medium — LV:227 — “effectiveness failing for want of access”**

   **Confirmed by the theorem’s hypotheses and a counterexample.** `answer_constant` establishes constancy and equality with one committed move. It does not establish ineffective decision-making. For example, with gain 1 and loss 0 everywhere, a constant release answer is optimal. Nor does the unrestricted carrier require its initial state to contain no world information.

   Equation 1 supports the constant-policy comparison; Theorem 1 and Remark 1 do not justify identifying every constant answer with failed effectiveness. [The Off-Switch Game, §3](https://arxiv.org/pdf/1611.08219)

   Replace the sentence beginning “Their human observes” with:

   > Their human observes the utility. Here `answer_constant` compares courses with identical initial internal, sensory, active and holding states, where `reveal` is constant over the relevant worlds. It establishes no strict gross advantage over the better committed move; it does not establish that the reading formation acts ineffectively.

3. **R3 — low — LV:90 — “reachable … which `presented_forgone_lt_iff` states”**

   **Confirmed by signature inspection.** That theorem compares the answer produced by a **given input** `x`. It neither characterizes reachability of an arbitrary pair of value functions nor proves that a beneficial input exists.

   Replace LV:90’s sentence beginning “Whether” with:

   > `revaluing_gains_iff` does not assert reachability under the supplied update. For a given input `x`, `presented_forgone_lt_iff` compares the current one-cell answer with the answer after `revalue v x`, including the amounts forgone.

   In the `revaluing_gains_iff` docstring at LV:905, replace the reachability sentence with:

   > Reachability under a supplied update is not asserted. `presented_forgone_lt_iff` gives the cost comparison for a supplied input.

4. **R4 — low — LV:204 — “The revision carries no information … as their reward functions are uninformative”**

   **Confirmed against the paper; the correspondence is a judgment.** Keeping a listing, weights and map fixed establishes that this comparison contains no model update. Everitt and colleagues’ Assumption 2 is specifically conditional uninformativeness **about state transitions**. It is not unrestricted absence of information, and the Lean does not encode that conditional-independence assumption. Claim 3 also does not require Assumption 2. [Everitt et al., Assumptions 1–3 and Claims 2–3](https://arxiv.org/pdf/1908.04734)

   Replace that sentence with:

   > This comparison holds the listing, weights and map fixed and represents no learning from the revision. Their Claim 2 additionally assumes reward functions conditionally uninformative about state transitions, private and state-based; those causal assumptions are not represented here.

   The existing exclusion of the TI-ignoring agent and Claim 3 can remain.

5. **R5 — low — LV:45 — “both maps’ cells listed once each”**

   **Confirmed by signature inspection.** `informed_le`, `informed_answer_le` and `informed_le_add_residual` require only the **finer** cell listing. The header reinstates a superfluous coarse-listing condition that the revised signatures correctly avoid.

   Replace the opening parenthesis of the Informing bullet with:

   > (a map `π'` telling apart all a coarser map `π` does, `π c = f (π' c)` on the holding formation’s listed candidates, with `π'`’s cells listed once each and covering that listing)

   Keep the separate, stronger setup for `refining_never_lowers_iff` later in the paragraph.

6. **R6 — low — LV:798 — “through one map, forgoing `k'`”**

   **Confirmed by comparing the displayed sides.** The prose reverses the cost roles relative to the displayed theorem. It describes a valid comparison after renaming the quantified roles, but does not track this statement’s `π`, `π'`, `k` and `k'`. The theorem itself is correct.

   Replace the docstring with:

   > **Withholding against informing, both answers least:** with the reading formation’s model the holding formation’s, its valuation agreeing in net with the reference at every listed candidate of positive weight, and each map’s cells listed once and covering the listing, holding for its answer through `π`, forgoing `k`, stands above holding for its answer through `π'`, forgoing `k'`, exactly where the least shortfall through `π` plus `k` is below the least shortfall through `π'` plus `k'`.

7. **R7 — low — LV:128 — “one configuration … (`TwoWorlds.routes_alike`)”**

   **Confirmed by signature inspection.** `routes_alike` proves equality of the records: answer history and final internal state. Complete-configuration equality is supported by `routes_rest`.

   Exact replacement:

   > (`TwoWorlds.routes_rest`), while the valuation changes on the second alone

   The stronger sentence is true; its citation is wrong.

8. **R8 — low — LV:196 — “demonstration is the same at every world”**

   **Confirmed as a distinction in the definitions; wording judgment.** The fixed object is the observation **map**. The sensed demonstration is `.shown (rd.reveal w)` and can differ across worlds. Reading “demonstration” as the procedure makes the analogy defensible, but the sentence should identify that object explicitly. The preceding description of Crawford–Sobel’s partition equilibria and qualified welfare comparison is accurate. [Crawford and Sobel, introduction and §§4–5](https://www.haverford.edu/sites/default/files/CrawfordSobel1982.pdf)

   Replace the sentence beginning “Here the holding formation’s law” with:

   > Here the holding formation’s law reads only its own state and the answer. A demonstration uses the supplied map `reveal`, whose observed value may differ across worlds; the map is not strategically selected in this module. A coarser map can stand higher by the reference (`Informing.informing_lowers`).

9. **R9 — low — [PLAN.md:208](../PLAN.md) — “with cell lists for both”**

   **Confirmed by reading the unchanged plan against the revised signatures.** This is the remaining part of previous finding 14, rather than a new Lean defect.

   Exact replacements:

   - **Item 5:** replace “with cell lists for both” with:

     > with the finer map’s cells listed once each and covering the holding formation’s listing

   - **Item 6:** replace its opening sentence, through “exactly where”, with:

     > Over every pair of maps with the coarser factoring through the finer on both formations’ listings, both cell lists without repetitions, the coarse cells covering the holding formation’s listing and the fine cells covering both listings, holding for the finer answer never stands lower exactly where

   - **Item 13:** replace its explanatory sentence with:

     > With the reading formation’s model the holding formation’s, some unrestricted pair of value functions gives an answer through `π` standing strictly above the current answer by the reference exactly where the current answer’s residual is positive. This existence claim does not assert reachability under the supplied update.

**Other new Lean problems: none found.** In particular, the residual gain and bound, refinement threshold, sufficient conditions for `SplitsKeep`, three new criterion witnesses, demonstration split and monotonicity, timing, undemonstrated results, presented-input threshold, route answers and start-augmented lumping have the stated mathematical content. Independent bounded checks passed for 9,604 subtraction-threshold cases, 9,375 comparison cases, all disjoint Boolean subsets in the three criterion witnesses, and 216 undemonstrated schedules. These supplement the source review; they are not substitutes for the saved Lean check.

**Other literature problems: none found.** The Kamenica–Gentzkow correspondence is appropriately restricted to deterministic partition splits, rather than identifying `SplitsKeep` with convexity over all posteriors; the tie convention and heterogeneous-prior boundary are accurate. [Kamenica and Gentzkow](https://web.stanford.edu/~gentzkow/research/BayesianPersuasion.pdf), [Alonso and Câmara](https://eprints.lse.ac.uk/67950/1/Bayesian%20persuasion_2016.pdf). The Carroll comparison is fair as a one-decision fixed-reference reading, and the Farquhar comparison is fair when “under one” denotes the counterfactual evaluation described immediately before it. [Carroll et al., §5](https://arxiv.org/pdf/2204.11966), [Farquhar et al., Proposition 1](https://ojs.aaai.org/index.php/AAAI/article/download/21186/20935). The restricted Blackwell attribution remains fair; this pass could access the reproduced original abstract, but not the publisher’s full text. [Blackwell’s abstract](https://celebratio.org/Blackwell_DH/article/26/).

The revision substantially resolves the earlier review and adds useful statements without introducing a mathematical defect I could identify. I would correct the remaining prose before landing, especially the complete-start claim and the inference from constant answers to ineffective action. No additional Lean theorem is necessary to resolve these findings.

### What was taken from the re-check

| Point | Status | How |
|---|---|---|
| R1 | taken | The header's carrier bullet and `TwoWorlds.orders_apart`'s docstring: two starts alike but for the order of the holding formation's two scheduled acts, the answers apart at step 2 and one configuration from step 3 on. Where two courses differ only in the world, the docstrings and the header say 'from one state of each formation'; the record's laws, 03 §12's paragraph and the study likewise. |
| R2 | taken | The Readings: `answer_constant` takes one state of each formation at every world, nothing shown telling apart the worlds the holding formation lists; the answer is then constant and holding for it gives no strict advantage over the better committed move, whether or not the move it gives is the better one; 'effectiveness failing' is gone, there and in 03 §12's reading. |
| R3 | taken | The header and `revaluing_gains_iff`'s docstring: reachability under the supplied update is not asserted, and `presented_forgone_lt_iff` compares a given input presented; the Readings: the incentive to revise only where the update reaches such a valuation, which is not asserted; PLAN §4.8 item 13. |
| R4 | taken | The Readings: the comparison holds the listing, weights and map fixed, so the revision teaches the reading formation nothing of the world; their assumptions (reward functions conditionally uninformative about state transitions, private and state-based) are among what is not represented. |
| R5 | taken | The header's informing bullet asks only for `π'`'s cells, listed once each and covering the holding formation's listing; the coarser map's cells are named only for the criterion over every refinement. Updated after the check of the delta (its point 1): the bullet also names the coarser map's cells, listed once each and covering, for `informed_lt_iff`; and after the cold read of the texts (its finding X7), the bullet on amounts forgone names both maps' cells, listed once each and covering the holding formation's listing, for `refined_lt_iff`, and the bullet on when the answer is least names the told criterion's cells, covering that listing. |
| R6 | taken | `forgone_least_iff`'s docstring: holding for the answer through `π`, forgoing `k`, stands above holding for it through `π'`, forgoing `k'`, exactly where the least shortfall through `π` and `k` fall below that through `π'` and `k'`, each map's cells listed once each and covering the listing. |
| R7 | taken | The header cites `TwoWorlds.routes_rest` for one configuration from step 2 on and `TwoWorlds.routes_alike` for the records alike. |
| R8 | taken | The Readings: the holding formation's law reads only its own state and the answer, not the world; a demonstration shows the world through the supplied map `reveal`, fixed in advance as a committed experiment is and not chosen by the holding formation; 03 §12's reading likewise. |
| R9 | taken | PLAN §4.8: item 5 with the finer map's cells alone; item 6 with factoring on both listings, both cell lists without repetitions and the coverage of each; item 13 with an unrestricted pair of value functions and reachability not asserted; the other items brought to the Lean (`kit/round2c/plan_rfm3.py`). |

## The check of the delta

The cross-model reader, in the session of its review, read the changes made after the taken check and the diff from the re-checked commit, read-only (its prompt is in [the brief](BRIEF.md#round-2-third-part)). Verbatim.

I found **two low-severity header omissions**. No new Lean-statement, proof, or course-arithmetic problems found.

1. **Low — [ListingValuation.lean:54](../kit/round2c/tree/Becoming/ListingValuation.lean)**

   **Problem:** The new strict criterion inherits a setup requiring only the finer cell listing. `informed_lt_iff` additionally requires the coarse cells listed once and covering the holding listing. Coverage matters: with one candidate, identical maps, an incorrect coarse rule and an empty coarse cell list, improvement is strict although neither stated alternative holds.

   **Exact replacement** for “(`informed_le`), strictly higher … (`informed_lt_iff`).”:

   > (`informed_le`). With the coarse map’s cells also listed once each and covering the holding formation’s listing, holding for the finer rule with no residual stands strictly higher exactly where the least shortfall falls or the coarser rule has a positive residual (`informed_lt_iff`).

   Confirmed by signature inspection and a numerical counterexample without coarse coverage.

2. **Low — [ListingValuation.lean:132](../kit/round2c/tree/Becoming/ListingValuation.lean)**

   **Problem:** The new course summary gives both shortfalls without stating that the holding models differ. `shown_course` totals over both worlds; `presented_course` totals over the first alone. Evaluating the presented course over both worlds instead gives shortfall **2**, not 0, at step 2. The individual docstrings correctly specify their models.

   **Exact replacement** for the sentence beginning “Along courses of the joint law”:

   > Along courses of the joint law, shortfall is measured by the reference `agree`, with the holding formation listing both worlds at weights 1 and 2 in `TwoWorlds.shown_course`, and the first world alone at weight 1 in `TwoWorlds.presented_course`. With each witness’s initial state and scheduled act, holding for the answer falls short by 1 at step 1 and by nothing at step 2, once what is shown or presented is taken in.

   Confirmed by inspecting the definitions and independently calculating both course families.

Everything else in the delta checks out: the support criterion requires no shared model; the refinement and cost directions are correct; the structural retitling preserves scope; and the added off-switch citation does not restore the withdrawn effectiveness claim. The course timing is correct: the intervention is sensed at step 1 and affects the answer at step 2.

No files edited and no Lean build run.

### What was taken from the check of the delta

| Point | Status | How |
|---|---|---|
| 1 | taken | The header's informing bullet: with the coarser map's cells also listed once each and covering the holding formation's listing, holding for the finer rule with no residual stands strictly higher exactly where the least shortfall falls or the coarser rule has a positive residual (`informed_lt_iff`); 03 §12's paragraph, the study, the record's law and PLAN §4.8 item 5 likewise. |
| 2 | taken | The header's TwoWorlds bullet: the course forms measured by the reference `agree` with the holding formation listing both worlds at weights 1 and 2 (`TwoWorlds.shown_course`) and the first world alone at weight 1 (`TwoWorlds.presented_course`), from each witness's start; 03 §12's paragraph, the study, the record's law and PLAN §4.8 item 20 likewise. |
