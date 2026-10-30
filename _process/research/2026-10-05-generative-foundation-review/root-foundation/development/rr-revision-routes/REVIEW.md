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
