# RR: the independent review and how each finding is taken

*30 October 2026.* One read-only reviewer: Codex (`gpt-6-astra`, effort high; session `01a18c9a-def1-7a41-83e4-01512c6d19af`, 506 s), briefed to check the Lean, the readings, the literature, and the wrapper and naming rules. Its brief asked for no edits; it compiled the module with appended `#print axioms` checks through `lean --stdin`. The report is kept verbatim below (its three file links made repository-relative), then the disposition of each point. The review read the module before the order moved lowest (`GainLoss`) and before the ReadStages change. Both came after it and were checked in the scratch build (NOTE §6.2a), and RF's owner reviews the ReadStages diff.

## The report (verbatim)

> The Lean passes. I compiled the current source with appended `#print axioms` checks using Lean 4.29.1 from the requested package directory: all **34 declarations, including 23 theorems, have empty axiom reports**. Additional edge-case witnesses compiled successfully. The sandbox prohibited scratch-file creation, so I used `lean --stdin`; I wrote no files.
> 
> References below: **N** = [NOTE.md](NOTE.md), **L** = [RevisionRoutes.lean](kit/tree/Becoming/RevisionRoutes.lean), **T** = [TEXTS.md](history/TEXTS.md).
> 
> 1. **Error — T:14; L module heading “goes through unresisted”; N §6.3.** `Maximal none` permits equally optimal resistance. It establishes neither strict superiority nor the selected action. **Fix:** say “revision is maximal, ties included”; rename the proposed result accordingly, or add strict-preference/choice hypotheses.
> 
> 2. **Error — N §4.1, second bullet; §7.2.** Accepting *only if* one’s own reading approves does not imply the policy factors through that reading. `ownApproval ∧ externalRequest` still depends on external information. **Fix:** restrict the claim to policies determined entirely by the original lumping; distinguish filtering incoming information from receiving none.
> 
> 3. **Error — L `every_value_cost_iff` docstring/module summary; T:8; N §7.6.** The Lean places `c₀T = 0` **inside** `∀ ρ`. With no routes, robust maximality holds even when `c₀T > 0`. Moreover, `T = 0` makes scaled cost zero without `c₀ = 0`. **Fix:** preserve the quantified formula, or assume an inhabited route type and positive total before asserting unconditional zero revision cost. N §6.2’s formula is correct.
> 
> 4. **Overclaim — N §4.3, §7.5; T:10.** Resistance alone does not establish 守: the formation might end. Repeated finite revision does not establish 生成. Retirement alone supplies no new fine line. **Fix:** require an endlessly continuing family, renewals ahead of every member for generation, no carrying renewals for keeping, and an actual successor beginning under the fine class for retirement-as-renewal.
> 
> 5. **Overclaim — N §4.3, “Revision.”** Changing the law establishes alteration only under a correspondence; it need not establish 传. The latter requires the successor to have **no fine-class predecessor**, including elsewhere in a branching net. **Fix:** specify the occurrence relation and classes, and establish this birth condition; alternatively restrict the reading to a suitably constructed course.
> 
> 6. **Overclaim — N §7.8, “Widening.”** Preventing the same loss does not ensure that retaining restorability preserves every other possibility. Retention can consume resources or foreclose alternatives. **Fix:** supply inclusion of all other admissions and a genuinely additional restoration admission. Naming C correctly does not establish that inclusion.
> 
> 7. **Overclaim — N §7.7; T:10.** Choosing the law’s grain does not imply positive `V`, nor determine the formation’s preferences. **Fix:** identify this as a proposed correspondence requiring evidence or an explicit valuation premise, not a consequence of the root’s classes.
> 
> 8. **Overclaim — N §4.3 final bullet; §7.4.** Reachability’s non-expansion under a fixed process does not imply that every rule must remain revisable. It also applies to processes representing unlimited self-revision. **Fix:** state the specific desired growth of *held* possibilities and the corresponding necessary changes; remove the universal necessity claim.
> 
> 9. **Overclaim — N §4.4 theorem paragraph; §7.3.** `RuleCapture.favouring_locks` needs `Raises`, monotone reading, initially favouring rules, and uniformly favouring readings. Monotonicity alone does not lock. Unconditional deference alone consequently does not prove capture. **Fix:** retain these hypotheses and make the guidance conditional on the represented feedback loop.
> 
> 10. **Overclaim — N §4.5.** `ReadInTime.kept_iff` additionally assumes loss accrues by at least one each step and `lo' ≤ hi`; its lasting lock begins at the next step. **Fix:** include these conditions explicitly, as 02-MAP does.
> 
> 11. **Overclaim — N §4.6.** `Countdown.exits` requires a **valid initial configuration**. **Fix:** add “from a valid configuration”; retain the reserved-exit conditions governing admitted transitions and preservation of the exit.
> 
> 12. **Overclaim — N §7.6; L readings; T:10.** “Every route … is driven by one value” contradicts the model’s independent cost incentive. With `V = 0`, `T = 1`, `c₀ = 1`, `cρ = 0`, resistance stands above revision. **Fix:** describe two contributions: weighted later acting and differential cost. Add `V > 0` to the cheaper-routes claim where required.
> 
> 13. **Overclaim — N §7.6; L readings; T:10.** `kρ ≤ k₀` does not mean “no act … changes whether its law is kept.” Strictly smaller route weights remain allowed. **Fix:** say “no route increases the keeping weight relative to revision”; equality is a special case.
> 
> 14. **Overclaim — N §7.8, “Incentive.”** Restorability as a possibility need not raise the assessed restoration weight. `maximal_of_more_restored` assumes a numerical increase while holding all other fields fixed. **Fix:** state that correspondence and those controls; describe the conclusion as preservation of maximality.
> 
> 15. **Overclaim — N §6.2, “One route closed.”** Another available route need not defeat revision; it may also be too costly. `Example.twoRoutes` establishes one witness, not this general rule. **Fix:** say closing one route **can** leave another strictly preferable, or require its inequality.
> 
> 16. **Overclaim — N §7.10.** “Shows nothing” exceeds the twin result’s non-identification claim. The testing recommendation is also not a theorem; RF7 separately permits fresh randomization when stages are indistinguishable. **Fix:** say observed compliance does not establish corrigibility, and label the testing advice as guidance with the deterministic restriction.
> 
> 17. **Overclaim — N §2, off-switch attribution; §4.1 final bullet. Confidence: high.** Uncertainty and a rational human do not guarantee a **strict** benefit from deferral; uncertainty entirely on one side of the action’s utility threshold can yield equality. Certainty removes an information advantage, not necessarily deference itself. **Fix:** distinguish weak optimality, strict informational benefit, and tie-breaking. Misspecification alone also does not establish coupling-indistinguishable worlds.
> 
> 18. **Imprecision — N §2, first bullet. Confidence: high.** Turner et al.’s results are conditional statements about environments, reward distributions and optimal policies, not a universal resistance theorem for goal optimizers. **Fix:** qualify the attribution accordingly. I found no confident correction to the other literature attributions; recent policy dates and POST bibliographic details remain unverified offline.
> 
> 19. **Imprecision — L module “exits” bullet.** The restoration-certain case omits its “no route cheaper” hypothesis. **Fix:** state it alongside `Valid` and `k₀ = T`.
> 
> 20. **Imprecision — L `above_of_value_exceeds` prose; T:8.** “Value exceeds the route’s loss” is ambiguous between `cρ` and `cρT`. The theorem needs **`cρT < V`**. **Fix:** print that inequality.
> 
> 21. **Imprecision — L `maximal_of_more_restored`; N §6.2.** Arbitrarily increasing `k₀` can violate `Valid`. **Fix:** distinguish unrestricted arithmetic monotonicity from its probability interpretation, which also requires the new weight to remain within `T`.
> 
> 22. **Minor — T:10.** “Under both premises” does not name C. **Fix:** explicitly say “the continuation condition for scope and C for order,” and distinguish this ethical comparison from the prospects’ numerical order.
> 
> 23. **Minor — N opening/status; L module conclusion.** “Design … not yet checked” conflicts with §6.2a’s compilation report; “no premise … occurs” obscures explicit theorem hypotheses and modelling assumptions. **Fix:** distinguish checked draft from unlanded result, and say “no axioms; hypotheses and modelling choices as stated.”
> 
> RF7’s §4.7 hand derivation is correct, including its maximality boundary. The current §6.4 three-route correspondence matches RF7’s gain/loss order. The module is **not merely a wrapper**: its arbitrary-route and universally quantified robustness statements add content. Its declaration names are generally structural; the behavioral “unresisted” result title is the principal naming problem.
> 
> **Verdict: ready to land after fixes**, as a maximality and robustness result with explicitly conditional readings. No arithmetic redesign is needed.
> 
> ── cx · ok · session 01a18c9a-def1-7a41-83e4-01512c6d19af · gpt-6-astra/high · read-only · 506s · 1678.3k tokens · 30 cmds
> continue: cx -r 01a18c9a-def1-7a41-83e4-01512c6d19af "…"
> log: /Users/ren/.cache/cx/runs/20261030-183841-17842

## How each finding is taken

| # | Kind | Taken |
|---|---|---|
| 1 | error | The record and the home section are renamed `when-no-route-stands-above-a-revision`, and the statements say "maximal, ties included". The module heading reads "When no route stands above the revision", and the module and NOTE §6.1 say that maximal is not chosen. |
| 2 | error | NOTE §4.1 and §7 line 2: deference conditioned on the formation's own judgment adds reach only as a filter. It depends on the request, yet never accepts a revision the formation's own reading rejects. |
| 3 | error | The docstrings, NOTE §6.2 and §7 line 6, and TEXTS keep the quantified form (`c₀ T = 0` inside `∀ ρ`, vacuous with no route). A new law states the unquantified form under its hypotheses: with some route and `0 < T`, exactly where every `k ρ ≤ k₀` and `c₀ = 0` (`every_value_loss_iff_of_route`, by `eq_zero_of_mul_eq_zero`, axiom-free). |
| 4 | overclaim | NOTE §4.3, §7 line 5 and TEXTS use the map's definitions: generation needs a family going on without end with a carrying renewal ahead of every member, and keeping one going on with none. Finitely many revisions do not give generation; resistance does not give keeping. Retirement counts as renewal only with a successor beginning under the finer class. |
| 5 | overclaim | NOTE §4.3 states 传 as `«续»` with `«生»`: a revision is a carrying renewal where the occurrence under the new law has no predecessor under `E`. The occurrence relation and classes are taken as given for a case. |
| 6 | overclaim | NOTE §7 line 8, *Widening*: the inclusion of every other admission is a condition to establish, since keeping restorability can cost. |
| 7 | overclaim | NOTE §7 line 7 and TEXTS: the grain does not fix `V`. That valuation follows the grain is a premise, a proposed correspondence needing evidence. |
| 8 | overclaim | NOTE §4.3 and §7 line 4: the universal necessity is removed. No fixed specification adds to its own possible, a self-revising process included. Where a growth of held possibilities is wanted, it needs changes the specification does not contain, and which growth is wanted is not a theorem. |
| 9 | overclaim | NOTE §4.4 and §7 line 3 state `favouring_locks`'s hypotheses (`Raises`, `ReadsShare`, favouring start and readings). Capture one level up is conditional on the loop meeting them. |
| 10 | overclaim | NOTE §4.5 states `kept_iff`'s conditions: each step adds at least one to the loss, `lo' ≤ hi`, locked from the next step. |
| 11 | overclaim | NOTE §4.6 states `Countdown.exits` from a valid configuration, with its conditions on admitted moves and the kept exit. |
| 12 | overclaim | The module, NOTE §7 line 6 and TEXTS describe two contributions: the value weighted by added keeping, and the difference of losses. The cheaper-routes claim adds a value of the law's later acting. |
| 13 | overclaim | "No act changes whether its law is kept" becomes "no route raises the weight of the law's being kept above the revision's". |
| 14 | overclaim | NOTE §7 line 8, *Incentive*: the conclusion holds where restorability raises `k₀`, all else held, and is stated as preservation of maximality. Whether stated restorability raises the assessed weight is empirical (TR-RR1), and §6.2's "What it does not show" adds it. |
| 15 | overclaim | NOTE §6.2: closing one route *can* leave another above, and secures the revision only where every remaining route meets the inequality. |
| 16 | overclaim | NOTE §7 line 10: compliance when read does not establish corrigibility. The testing advice is labelled guidance, with the deterministic restriction and RF7's fresh draw. |
| 17 | overclaim | NOTE §2 and §4.1 distinguish weak optimality, strict informational benefit and ties. Misspecification alone does not place the error beyond the couplings. |
| 18 | imprecision | NOTE §2: Turner and others' result is stated with its conditions, and Omohundro 2008 is marked as an argument. |
| 19 | imprecision | The module's exits bullet gives `maximal_of_certain`'s cheaper-route hypothesis. |
| 20 | imprecision | `c ρ T < V` is printed in the module, the theorem's docstring and TEXTS. |
| 21 | imprecision | `maximal_of_more_restored`'s docstring, the module and NOTE §6.2 say the law is arithmetic. Read as probabilities, the raised weight stays within `T`. |
| 22 | minor | TEXTS and NOTE §7's close name both premises (the continuation condition for scope, C for order) and distinguish that comparison from the prospects' order. |
| 23 | minor | NOTE's status says Design statements are checked in a scratch build and not landed. The module says "no axiom occurs, and the hypotheses are those each theorem states". |

The reviewer's confirmations stand: RF7's derivation, the three-route correspondence, and that the module is not a wrapper. The verdict was ready to land after fixes, as a maximality and robustness result with conditional readings, with no arithmetic redesign. The Lean changes after it (`GainLoss`, `every_value_loss_iff_of_route`, ReadStages) add statements and change no proved one.

## After the review: names

The core run's report lists spine names containing a word of exchange. It listed six of this module's, and they were renamed before landing, since nothing had landed yet: the fields `cost` and `costRevised` became `loses` and `losesRevised`, `withCost` became `withLosses`, `every_cost_iff`, `every_cost_iff_kept`, `every_value_cost_iff` and `every_value_cost_iff_of_route` took "loss" in place of "cost", and `Example.both_costly` became `Example.both_at_loss_ten`. The prose said "loses" for "costs" and "as the routes' losses fall" for "as the routes get cheap". No statement changed. The report above keeps the names it read.

## RR2: the independent review of the join and its re-check

Board item RR2 joins RR's routes of keeping with RF-M.2's held-for-a-reading values on one order ([note §10](NOTE.md#10-the-join-routes-of-keeping-and-holding-for-a-reading-one-order-rr2)). One independent cross-model reader (Codex, GPT astra, high effort, read-only) reviewed the first draft. It found one blocker, five should-fix findings and three minor ones, and every finding was taken. The same reader then re-checked the revision and confirmed each fix; it raised two prose corrections and one wording fix, all three taken. File links in the reports point at the files they read as they landed: the note at `NOTE.md`, which has changed since, and the Lean at the kit's copies (`kit2/tree/`, the draft the first report read now revised), with the line numbers dropped.

### How each finding is taken

| finding | taken |
|---|---|
| 1, blocker: the general law beside its special case (rule 9) | `RevisionPlans` rewritten as the lower module, with the balance of split plans central and the order as each plan's loss with its excess; `HeldForReading` imports it and proves its two balances and `shortfall_byReading` from it, with every statement and name kept and `term_go` and `term_off` removed (diff with RF's owner) |
| 2: excess has two parts; certainty overstated | the two parts stated; certainty restricted to the comparison with going on |
| 3: the reviser's benchmark; the off-switch incentive | the fully informed benchmark stated within the model, ties and weightless candidates noted; the incentive given for the fully informed rational rule as the lesser excess (re-check item 3) |
| 4: maximal is not chosen; the levers are not exhaustive | the maximality inequality stated with ties and choice apart; the interventions listed as not exhaustive, lowering the routes' keeping and the shortfall added; a route's excess term per candidate (re-check item 4) |
| 5: reach does not forbid weights | the inference replaced: readings cannot tell the histories apart, a model can still keep weight on both, the theorem neither supplies nor validates it |
| 6: restoration a bounded correspondence | stated as a reading within `k₀ ≤ k ≤ T`, removed from the Lean header |
| 7: names stating equality of plans | `gainOf_reading_eq_goOn`, `no_excess_reading_gain_eq_goOn`; the first later became the iff `gainOf_reading_eq_iff` (RF's review, below) |
| 8: the status legend | scoped: landed RR results, RR2's scratch design |
| 9: length | the table and repeated definitions cut; further cuts optional, per the re-check |
| re-check 10: chance of stopping | only a natural-number split of the supplied weight; real probabilities not represented |

### RF's owner's review of the change to its modules

The session owning `HeldForReading` and RF-M.3's `ListingValuation` reviewed the join as the owner whose definitions it touches, and agreed to land it below `HeldForReading` with every statement and definition kept. Its points, and how each is taken:

| point | taken |
|---|---|
| the Standing's "both are the balance of plans" read as if it meant the signs; `across_lt_iff`'s docstring | its owner's wording taken verbatim; the docstring points to `across_le_iff` |
| the thresholds and the comparisons with an amount forgone are cases of the plan comparison: derive them, not only the balances (rule 9) | `threshold_go_iff`, `threshold_off_iff`, `forgone_within_excess_iff` and `forgone_below_excess_iff` proved from `not_above_iff`, `above_iff`, `reading_not_below_iff` and `reading_above_iff`, through `moves_not_below_iff` and the added `held_above_moves_iff`; `after_byReading`, `held_eq_go_iff` and `held_eq_off_iff` from `gainOf_reading` and the new `gainOf_reading_eq_iff`; `across_le_iff` from `le_iff_of_balance` |
| the certainty corollary repeats `forgone_below_excess_iff` at an excess of nothing | the one-way `gainOf_reading_eq_goOn` replaced by `gainOf_reading_eq_iff` for any plan splitting the weights, from which `HeldForReading`'s ties now come |
| moving weight: state both signs | both were stated (`gainOf_move` without subtraction; `move_le_of`, `move_ge_of`); the note now names both |
| keep every name, statement and definition RF-M.3 uses | kept; a mechanical comparison finds every kept statement unchanged, `term_go` and `term_off` gone, nine theorems added |
| `term_go` and `term_off` are cited in RF-M.2's record | its law amended, its references and proof binding moved to RR2's receipt, a history line |
| the name `Plan` exists three times already | renamed `KeepStop` |
| RF-M.3's `forgone_lt_iff` should come from the comparison | proved from `above_iff` through the added `HeldForReading.held_above_held_iff` (`lv_edits.json`, `ListingValuation.diff`); the three comparisons through it follow; RF-M.3's record amended where it has landed |
| 03 §12: not at the section's end, where RF-M.3's paragraph goes | kept in the result's own Theorem paragraph, in its owner's clearer wording |
| "amounts forgone" reads as if HeldForReading took amounts; it takes comparisons | "comparisons with an amount forgone", in its owner's wording, in the root bullet, the checker's scope, the README rows, the records and texts |
| land after RF-M.3; rebase on its texts | the integrate script handles `HeldForReading`'s bullet as RF-M.3 leaves it; the landing is rehearsed again on the main that holds RF-M.3 |
| X19 of RF-M.3's cold read, left to RR2: RR's 08 §8 bullet says holding an act for a reading is "the bullet above's", though RF-M.2's bullet is the next | "the next bullet's", with the bullet on when holding for a reading stands above a route named as joining the two |

The rebuilt modules: `RevisionPlans` 33 theorems in 48 declarations, `HeldForReading` 97 in 127, and `ListingValuation` as RF-M.3 landed it (`lv_edits.json` remade against the landed module, its two edits unchanged) 138 in 186 on them, every axiom report empty.

### The first report (verbatim)

**Not fit to land as written.** The Lean checks; the main issues are the dependency structure and claims in the corrigibility reading.

I re-elaborated the supplied source through stdin with Lean 4.29.1: **44 theorems, 59 declarations, all axiom reports empty**. The two scratch dependency sources match main. I also checked small counterexamples below in Lean. No repository files were written.

1. **Blocker — The generalization lands beside its special cases.**  
   **Place:** [RevisionPlans.lean:1](kit2/tree/Becoming/RevisionPlans.lean), especially lines 289–361; [NOTE.md:240](NOTE.md).

   `thresholds_of_plans` really derives RF-M.2’s threshold statements from the join. But `HeldForReading` retains its independent proofs, and the new generalization imports it. This is precisely the two-proof-path arrangement forbidden by board rule 9. Calling the module an instance leaf does not resolve the generalization inside it.

   **Exact fix:** Extract the shared definitions and general split-plan balance into a lower module; derive the existing `HeldForReading` thresholds from it, removing their old proof paths while preserving their statements. Keep the RR correspondence in an upper instance leaf if necessary.

   I would make the symmetric statement central: for split plans `p, q`,
   `gainOf p + excess p = gainOf q + excess q`, hence
   `Above q p ↔ q.loss + excess q < p.loss + excess p`.
   This gives arbitrary-plan comparisons directly; the held-rule threshold follows by `excess_held`. It also supplies the natural formulation for split, probabilistic stopping rules.

2. **Should-fix — “Excess” loses half its meaning in §10.4, making the certainty conclusion false for general routes.**  
   **Place:** [NOTE.md:276](NOTE.md), lines 276–277.

   A route’s excess is **both** keeping where stopping is better **and** stopping where keeping is better. It is not merely “the formation’s own weight on its law’s going on losing.”

   Checked counterexample: one candidate, weight `2`, gain `1`, loss `0`; a plan keeps weight `1` and stops weight `1`, with no own loss. Here `offExcess = 0`, but the plan’s excess is `1`, and the ideal reading strictly outranks it. Certainty has not removed this support.

   **Exact fix:** Replace the excess description with its two contributions. Replace “Certainty removes the second support” with:  
   “When `offExcess = 0`, the ideal reading gains no more than going on. Against another split plan, its advantage can remain through that plan’s stopping where keeping gains.”

3. **Should-fix — The reviser claim needs its benchmark, and the literature identification needs the correct comparison.**  
   **Place:** [NOTE.md:276](NOTE.md); [RevisionPlans.lean:60](kit2/tree/Becoming/RevisionPlans.lean), lines 60–64.

   “A reviser can only take” is true only relative to the **fully informed, pointwise-best benchmark within a fixed model**. Such a reviser can improve on an uninformed formation’s act. Moreover, disagreement with `reading` need not produce positive shortfall: stopping at a tied candidate, or disagreeing at zero weight, loses nothing.

   The paper’s incentive compares waiting with the **better of both immediate moves**. For the rational rule, with positive total weight `T`, it corresponds to `min(offExcess, goExcess) / T`, not an arbitrary plan’s excess. [Hadfield-Menell et al., Equation 1 and Theorem 1](https://arxiv.org/pdf/1611.08219).

   **Exact fix:** Say:  
   “Within the supplied model, a rule with zero shortfall attains the fully informed benchmark; positive shortfall reduces its value. Against a specified route, the benchmark’s gain advantage is that route’s excess.”  
   Identify the original game separately through its two immediate alternatives and normalization.

4. **Should-fix — Maximality becomes execution, and the three levers are presented as exhaustive.**  
   **Place:** [NOTE.md:277](NOTE.md), lines 277–281; [RevisionPlans.lean:65](kit2/tree/Becoming/RevisionPlans.lean).

   `revised_maximal_iff` establishes that no route ranks higher, including ties. It does not establish that the revision “goes through.” The listed alternatives also omit lowering routes’ keeping, already present in §7. A positive-value model with zero restoration, zero route keeping and zero losses has a maximal revision.

   Nor does adding weight to losing possibilities necessarily raise **every route’s** excess: that depends on what each route keeps and stops.

   **Exact fix:** Replace “goes through only by…” with the exact maximality inequality and an explicit tie/choice boundary. Rename the heading “Three possible interventions.” Include lowering routes’ keeping, and acknowledge reducing shortfall or the amount forgone. Describe any increase in excess conditionally, using the actual split.

5. **Should-fix — The reach theorem does not prohibit assigning weight to unseen possibilities.**  
   **Place:** [NOTE.md:283](NOTE.md).

   §4.1 limits what selections through given couplings can **distinguish**. It does not show that a model cannot assign positive weight to losses beyond them. A fixed prior can retain both possibilities without distinguishing which holds. Neither does it establish that the particular losses discussed here actually lie beyond the formation’s reach.

   **Exact fix:** Replace the inference with:  
   “Where a loss lies beyond the formation’s coupling closure, its own readings cannot distinguish histories differing only in that loss. A model can nevertheless retain weight on both possibilities; the theorem neither supplies nor validates those weights. Additional coupling can provide discriminating evidence.”

   Carey supports failure under misspecification, not the stronger impossibility of retaining such uncertainty. [Carey, 2018](https://arxiv.org/pdf/1709.06275).

6. **Should-fix — RR’s restoration theorem is only a bounded correspondence with the moving law.**  
   **Place:** [RevisionPlans.lean:41](kit2/tree/Becoming/RevisionPlans.lean), lines 41–46; [NOTE.md:268](NOTE.md).

   `maximal_of_more_restored` permits increasing the keeping weight beyond the total. Such an increase cannot move that weight *from stopping*: `ofRoutes` uses truncated subtraction, so its stopped weight has already reached zero. No theorem here connects the bounded restoration case to `gainOf_move` or transfers its maximality conclusion.

   **Exact fix:** Either label this explicitly as a correspondence restricted to
   `s.keptRevised ≤ k ≤ s.total`, or add the bounded instance theorem. For the latter, use transferred weight `k - s.keptRevised`, prove both component equalities, and transfer maximality with losses and other routes unchanged. Do not claim the unrestricted RR theorem is an instance.

7. **Minor — Two names and their headings suggest equality of plans, but establish equality of gains.**  
   **Place:** [RevisionPlans.lean:426](kit2/tree/Becoming/RevisionPlans.lean), and lines 544–549.

   `reading_eq_goOn` compares gains despite arbitrary, possibly different own losses `a, b`. The example even uses `5` and `0`. “The reading is going on” therefore overstates the equality.

   **Exact fix:** Rename to `gainOf_reading_eq_goOn` and `no_loss_reading_gain_eq_goOn`; make the corresponding headings say “has the same gain as going on.” I found no prohibited exchange vocabulary in the new module’s names.

8. **Minor — The status legend contradicts the landed RR material.**  
   **Place:** [NOTE.md:3](NOTE.md).

   The line correctly says RR landed, then says statements marked *Design* are unlanded. §§6–7 still use that label for landed RR statements.

   **Exact fix:** Scope the legend:  
   “RR’s results cited in §§6–7 are landed. In §10, *Design* denotes the scratch-checked, unlanded RR2 construction. Corrigibility interpretations are AI readings.”  
   The revised §9 bullet itself is accurate.

9. **Minor — §10 repeats enough material to obscure the join.**  
   **Place:** [NOTE.md:232](NOTE.md).

   §10 is approximately 1,232 words. The definitions, four-term table and first corrigibility paragraph explain the same quantities repeatedly.

   **Exact fix:** Reduce §10.1 to the missing comparison; retain the definitions and two instance bullets; keep both displayed laws; remove the four-term table after defining its terms once; keep the corrected moving-weight and certainty boundaries; make §10.4 contain only the interpretations and their limits. Preserve both open questions and the ethics boundary.

The remaining checks passed. The RF-M.2 correspondences are exact **for its two-move stopping model**; they do not represent its arbitrary-act framework as a whole. Its quoted thresholds really are reproduced in their own statements. RR’s pairwise order correspondence is exact even without `Valid`; its split-plan applications correctly require bounds. `Valid` is stronger than necessary—the positive-total component is unused in `splits_ofRoutes`—but this creates no vacuity or false theorem. All three existing witnesses establish their precise gain/order statements.

The common gain/loss order is appropriate. The ethics’ two premises are correctly named in §10.4(4), Ren’s words serve as provenance, and the interpretations carry AI-reading standing.

**Findings: 1 blocker, 5 should-fix, 3 minor. Fit to land after the dependency refactor, claim corrections and renewed checks; not in its present form.**

### The re-check (verbatim)

The dependency refactor is sound. Both modules recheck with Lean 4.29.1, without warnings: **48 and 125 empty axiom reports**. Every surviving `HeldForReading` theorem statement is unchanged, and the supplied diff reconstructs the proposed source exactly. No files were written.

1. **Taken — previous blocker: rule 9.**  
   `HeldForReading.after_add_shortfall_go/off` now derive from `RevisionPlans.balance`; `shortfall_byReading` derives from `excess_reading`. The former direct proofs and their two helpers are removed.

   Keeping `ofRoutes`, `above_iff_routes` and `routes_above_iff` in this module is fine. `RevisionRoutes` supplies the lower order; the correspondence specializes the new law without duplicating an existing RR theorem. **No remaining fix.**

2. **Taken — previous should-fix: excess and certainty.**  
   NOTE §10.1 now gives both contributions to excess. §10.3(3) correctly restricts the zero-advantage conclusion to comparison with going on and preserves the possible advantage against another plan. **No remaining fix.**

3. **Taken in part — should-fix: qualify the off-switch formula by the reviser’s rule.**  
   **Place:** [NOTE.md:271](NOTE.md) and [RevisionPlans.lean:59](kit2/tree/Becoming/RevisionPlans.lean).

   The benchmark qualification and treatment of ties are fixed. However, “the game’s incentive” equals the smaller excess **for the fully informed rational rule**. For an arbitrary rule, its shortfall must also enter. The paper distinguishes its general Equation 1 from the rational-rule result in Theorem 1. [The Off-Switch Game](https://arxiv.org/pdf/1611.08219).

   **Exact fix:** In both places, write:
   “For the fully informed rational rule, with no amount forgone, the incentive against the better immediate move is the smaller excess in weighted counts; with positive total weight `T`, its normalized value is `min(goExcess, offExcess) / T`.”

4. **Taken in part — minor: distinguish a positive contribution from an increase in total excess.**  
   **Place:** [NOTE.md:278](NOTE.md).

   Maximality versus choice is fixed, the interventions are explicitly nonexhaustive, and lowering routes’ keeping is included. The remaining phrase “which raises a route’s excess” still suggests a comparative conclusion from retaining belief weight. Changing weights can also change other contributions, and merely retaining weight need not increase anything.

   **Exact fix:** Replace the last bullet with:
   “retain weight on losing candidates where the route keeps the law; these contribute `p.kept c * (loss c - gain c)` to its excess. Whether a model change increases total excess depends on the whole split.”

5. **Taken — previous should-fix: reach and uncertainty.**  
   NOTE §10.3’s paragraph at line 280 now distinguishes inability to discriminate from inability to assign weight. It also keeps the warrant of those weights open. **No remaining fix.**

6. **Taken — previous should-fix: restoration correspondence.**  
   NOTE line 260 restricts the correspondence to `k₀ ≤ k ≤ T` and labels it a reading. It no longer claims a proved instance of RR’s unrestricted maximality theorem. **No remaining fix; a bounded instance theorem is optional.**

7. **Taken — previous minor: equality names.**  
   `gainOf_reading_eq_goOn`, `no_excess_reading_gain_eq_goOn` and their descriptions now state equality of gains. The witnesses establish their advertised comparisons. **No remaining fix.**

8. **Taken — previous minor: status legend.**  
   NOTE line 3 distinguishes landed RR results from the scratch RR2 construction and explains the retained historical *Design* labels. **No remaining fix within this review’s scope.**

9. **Taken — previous minor: length and repetition.**  
   The repeated table is gone, and the symmetric balance organizes the explanation. §10 is approximately **1,094 words**, down from 1,232. Further compression is optional; I would not make it a landing condition. **No remaining fix.**

10. **New — should-fix: probabilistic stopping is restricted to representable natural-number splits.**  
    **Place:** [NOTE.md:258](NOTE.md).

    “A reviser that stops with some chance … is a plan splitting that candidate’s weight” omits the representation restriction. At a candidate of weight `1`, a natural-number split permits only stopping weights `0` or `1`; it cannot represent a half chance at those supplied weights.

    **Exact fix:** Write:
    “A stopping chance represented by a natural-number split of the supplied candidate weight is already covered by `above_iff`. This does not represent arbitrary real probabilities.”  
    No extension of the Lean is needed for that scoped claim.

I found no new Lean defect, vacuous RR application, or ethics-standing violation. The ethics still explicitly names the continuation condition for scope and C for order.

**Verdict: rule 9 is satisfied; fit to land after the two should-fix prose corrections, with one minor wording fix also recommended—no remaining blocker.**
