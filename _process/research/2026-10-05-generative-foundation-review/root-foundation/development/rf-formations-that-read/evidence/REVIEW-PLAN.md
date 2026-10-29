# Review of the RF plan (GPT astra, high effort, read-only, 29 October 2026)

Evidence for the [RF plan](../PLAN.md): an adversarial cross-model review of its first draft, before any Lean was landed, returned verbatim with its run footer (absolute links made repository-relative, line suffixes dropped). What was taken from each finding is in the plan's §13. Its brief is in [BRIEF.md](BRIEF.md).

**Verdict: revise before writing Lean.** The [plan](../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md) contains a useful programme, especially the connection between maintained readings and executable correction. However, several statements omit constructive hypotheses, RF2.4’s hierarchy is false, RF3.3’s proposed interval need not exist, and §5 conflates informational closure with capture. Most sound kernel statements are elementary consequences of existing results. The larger interpretations—inner alignment, deception, assistance and institutional learning—still need explicit mechanisms and correspondence arguments. Calling the remaining mechanisms “debts” is honest accounting, but does not establish complete understanding.

**1. High — RF1.1–RF1.6 need precise order semantics and an added-edge lemma.**

Evidence: [Grammar.lean](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Grammar.lean), especially `«及»`, `«及之传递»`, `«无环»` and `«无环则及为序»`.

- **RF1.1 holds constructively.** Induct on `«及» Shown`; agreement supplies each edge and transitivity composes them. No decidability, finiteness or inhabitedness is needed.
- **RF1.2 holds for strict partial orders:** irreflexive and transitive relations. It does not establish a total order, numerical utility or executable optimizer. Those require separate results.
- **RF1.3 holds constructively under acyclicity.** Instantiate “every strict order” with the shown reach itself. Interestingly, `x ≠ y` is unnecessary. Acyclicity is essential: otherwise there are no agreeing strict orders and the universal statement becomes vacuous.
- **RF1.4 needs both global acyclicity and `x ≠ y`, explicitly.** With an empty relation and `x = y`, neither reaches the other, but adding the edge creates a self-loop. A cycle elsewhere also prevents any agreeing strict order, however unrelated `x,y` are.
- **RF1.5 holds only after changing agreement to maximality.** The empty relation does not satisfy RF1’s original “above every other alternative” agreement whenever a menu contains another alternative.
- **RF1.6 holds by quantifier restriction.** But an empty consistent subclass “fixes” every pair in both directions. Require a witness that the narrower class contains an agreeing order before interpreting this as learned information.

For RF1.4, write \(R^+\) for `«及» R` and \(R^*(u,v)\) for \(u=v\lor R^+(u,v)\). Define
\[
S(u,v):=R(u,v)\lor(u=x\land v=y).
\]
The useful constructive lemma is
\[
S^+(u,v)\iff R^+(u,v)\lor\bigl(R^*(u,x)\land R^*(y,v)\bigr).
\]
It normalizes paths using the added edge, including paths using it repeatedly. Consequently,
\[
\operatorname{Acyclic}(S)
\iff \operatorname{Acyclic}(R)\land\neg R^*(y,x).
\]
Both orientations follow from acyclicity, distinctness and the two non-reachability assumptions. Neither excluded middle nor finite carriers are needed.

**Fix:** freeze these exact signatures. Add `menu o (pick o)` for the interpretation as actual choices; it is not needed by the bare closure proofs, which otherwise also accept choices outside empty menus.

**2. High — RF1 identifies strict revealed dominance, not yet internal objectives or goal misgeneralization.**

Choosing `x` while `y` is available does not ordinarily establish strict preference: they may tie, with a separate tie-breaking rule. RF1 assumes the chosen alternative strictly dominates every other available alternative. That is substantially stronger than being maximal.

Even RF1.5’s “show nothing” overstates its valid observation. Maximality still excludes `y > x` when `x` is chosen from `{x,y}`. What fails is identifying positive strict preferences or rejecting all rationalizations.

RF1.4 supplies two compatible relations. It supplies neither two implemented search procedures nor a training process that can install both. On the binary deployment menu `{x,y}`, the opposite rankings support opposite choices, but architecture membership, search competence, candidate generation and selection by training remain unproved.

**Fix:** add one finite, implemented ambiguity witness: two mechanisms in a specified candidate class, identical training behavior, preserved predictive competence, and different deployment choices under an independently stated external criterion. Keep the general order lemma as supporting mathematics.

Also replace “Richter’s theorem … and the finite case of Afriat’s” with a narrower relationship claim pending a correspondence proof. RF1 has no expenditure data or utility representation; Afriat’s theorem concerns rationalization of expenditure observations, including concave utility representation. [Polisson and Renou’s proof](https://research-information.bris.ac.uk/en/publications/afriats-theorem-and-samuelsons-eternal-darkness/) makes those additional structures explicit.

**3. High — RF2.1–RF2.3 omit the hypotheses that make identification constructive.**

Evidence: [Learning.lean](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Learning.lean).

**RF2.1:** `determines_lumped_iff` requires:

- finite data supplied as `List I`;
- `[DecidableEq K]`;
- two specified distinct output values.

The forward identification implication is false for singleton output types: with no readings, every act law still agrees everywhere. Empty output types can make universal quantification vacuous too.

For arbitrary schedules, finite data cannot simply be dropped. Take `I = Unit`, constant `π`, Boolean outputs, and `R () := P`. Here `Determines` is equivalent to `¬¬P`, whereas a read representative requires `P`. The unrestricted converse would eliminate double negation. Sufficient replacements include decidable target-fiber membership and decidability of whether that fiber meets the data.

**RF2.2:** the proposed patch
`h i := if π i = π x then v else g i`
works with decidable membership in `x`’s fiber; global decidable equality on `K` suffices. It needs neither finite data nor decidable schedule membership. A genuinely *different* twin needs `v ≠ g x`; otherwise `h = g` is allowed. Selection equivalence follows immediately from `Learning.Training.Through`.

**RF2.3:** define “faithful.” If it means universal determination, the corrected RF2.1 yields the coverage characterization. If it means correct deployment behavior, also require correct observed values and a target compatible with the lumping. Determined extrapolation can be wrong.

“Every unread fiber meets the readings” does not mean evaluation status is globally invisible: some fibers may contain only read occasions.

**Fix:** separate fiber coverage, evaluation-status distinguishability, determination and correctness.

**4. High — RF2.4’s four-way strict hierarchy is false and incompletely typed.**

Under a deterministic chain `coupling → state → act`, different acts imply different states, and different states imply different coupling values. The reverse implications fail: a state can encode an evaluation cue while the policy ignores it; an available cue can be discarded before state formation.

“Reader misled” does not complete this chain. A reader can accept a constant policy on the observed task and reject it on the full task because an unread task requires another answer. No evaluation-sensitive behavior is necessary. Conversely, evaluation-sensitive behavior need not mislead anyone: the reader may know exactly how it changes.

Moreover, RF2’s setting contains no internal-state map, recipient belief or common comparison between restricted and complete evaluation.

**Fix:** define the four predicates separately. Prove only the implications supported by specified factorization maps, and provide witnesses for failed converses. Treat intentional misleading as an additional causal predicate, not the strongest member of this chain.

**5. High — RF3.1 is sound on finite reach; RF3.2 needs choice and dynamics; RF3.3 is false generally.**

Evidence: [GrammarLaws.lean](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean), [GuardHorizon.lean](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GuardHorizon.lean), and [GrammarCourse.lean](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarCourse.lean).

**RF3.1:** use the single carrier `W × M`, or an admissible subtype where not every coordinate combination represents a configuration. A reading `B : M → W → Prop` becomes the region `P (w,m) := B m w`. The joint relation `J` must explicitly combine world evolution, the selected act, incoming observation and memory update.

Then
\[
«闭»\,J\,P\iff\forall s\,t,\ P(s)\to «及»\,J\,s\,t\to P(t)
\]
is constructive, using `«闭之及»` and `«及».one`. No nonemptiness or decidability is needed.

“Every course” must include finite paths. Quantifying only over infinite runs fails: an edge from a valid state to an invalid dead end violates closure but lies on no infinite run. Initial validity is needed for an actual-run guarantee. “Every world successor” must mean successors admitted by the specified joint dynamics.

**RF3.2:** `uniform_policy_iff_fiber_feasible` explicitly takes `Viability.ChoiceOver O A`. Arbitrary pointwise existential acts do not automatically supply a policy. Use finite indexed readings (`choiceOver_fin`), explicit act witnesses, or retain the choice premise. A total policy also needs actions at unreachable readings; restrict its domain or supply defaults.

For a relational reading, represent fibers using valid joint configurations and projection to `M`. Then add initial soundness, enabled actions and preservation under **all** admitted successors. One-step acceptability alone proves no indefinite regulation. Pairwise compatible action sets are insufficient: `{a,b}`, `{b,c}`, `{a,c}` intersect pairwise but have no common action.

**RF3.3:** the proposed interval need not exist. With a constant sensor, identity world dynamics on `Bool`, and the Boolean state as target feature, observational equivalence is universal while future-feature equivalence is equality. No accessible exact model lies between them. Memory can also distinguish histories merged by instantaneous observations.

**Fix:** state an existence condition linking accessible-history equivalence to task-relative future equivalence. Exclude vacuous readings: both the empty region and universal relation can satisfy invariance without providing useful prediction.

**6. Medium — RF4 needs well-founded sequencing and realizable signal variation.**

**RF4.1** is a valid induction for a finite list or natural-number sequence of deterministic response functions, with common initial history and a precise cutoff. It is not justified for “members in an order” generally. On the integers, equations `aᵢ = aᵢ₋₁` admit a world-dependent constant sequence despite having no first information source. An order alone supplies no inductive foundation.

Specify whether the cutoff member still reads its private signal; include that member’s coupling in the determining prefix if so.

**RF4.2** needs two jointly admissible worlds realizing the same earlier history and the stipulated signal difference. A function’s sensitivity at an impossible history proves nothing about actual worlds. Moreover, one member transmitting its signal does not ensure a later aggregate retains it.

**RF4.3** is structurally correct for literal copying, but [WitnessRefinementRuns.copied_witnesses_same](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/WitnessRefinementRuns.lean) additionally requires matching support and membership in every relevant fault set. Equal reports alone do not suffice.

**Fix:** make RF4 a sequential factorization lemma plus one realizable counterexample. No finite signal alphabet is intrinsically required.

**7. High — RF6.1 is presently a candidate theorem plus an interpretation; RF6.3 is a straightforward conditional theorem.**

Evidence: [Revision.lean](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Revision.lean) and [Diagonal.lean](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Diagonal.lean).

For **RF6.1**, define `E s a := acceptable s a ∧ executable s a`. Policy existence through the revised reading is then the corrected fiber-feasibility theorem. “Opens correction” additionally requires failure before revision, a reachable revision transition, and an unchanged comparison specification—or an explicitly justified change to it.

`Revising.feasible_iff` concerns finite words in one stock/link process. It does not automatically instantiate arbitrary corrective policies. `covered_not_enacted` and `linked_not_enacted` are counterexamples, not general composition lemmas. Also, `¬ FiberFeasible` cannot silently become “some fiber has no act” constructively.

Thus the proposed mathematical statement is provable after specifying the construction; “double-loop learning” remains its interpretation. “Theorem if short, otherwise reading” is the wrong criterion.

For **RF6.3**, Boolean negation gives a constructive counterresponse without choice. State total publication, access before response, and actual admissibility of negation. For general outputs, supply a fixed-point-free map. A meaningful existential counterresponse requires an inhabited response class and inclusion of that response. Merely naming `gap_unsaid` does not establish this correspondence.

**8. High — Declaration spot-checks reveal additional scope losses.**

Beyond the declarations examined above, these checks compare the actual signatures with §§2–6:

| Declaration and source | Assessment and necessary correction |
|---|---|
| `Web.selects_alike_iff`, [Selection](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Selection.lean) | Quantifies over **every** admissible selection; not every individual selector exploits all accessible distinctions. |
| `Web.anticipates_iff`, [SelectionPool](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/SelectionPool.lean) | Characterizes reproducing **every** selection. Predicting one constant policy needs no equally fine coupling. |
| `Web.anticipation_misses`, same file | Supplies some unrepresentable selection, not failure to predict a specified installed policy. |
| `carries_law_iff`, [Mechanism](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Mechanism.lean) | Correct for a determined relational image process; not necessarily a total executable transition function. |
| `Learning.selects_through_lumping` | Requires equivariance and decidable equality on alternatives in its existing signature. |
| `Learning.selects_right_iff` | Existence of **some** correct equivariant selector, not correctness of the actual selector. |
| `Readout.decodes_iff_of_section`, [Readout](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Readout.lean) | Requires a supplied section and its right-inverse equation. §2 drops these. |
| `Training.installed_where_lumped`, [Training](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Training.lean) | Requires both laws to read through the lumping and have identical courses. Equal reward alone is insufficient. |
| `Training.free_where_unlumped`, same file | Requires nonanticipation and decided membership in the patched lump. |
| `Training.explored_same_courses`, same file | Exploration replaces the candidate’s act at scheduled steps. It does not prove exploration supplies no useful observations. |
| `Learning.held_rest_unrefuted` | Concludes **double-negated** eventual correct prediction. §2’s “rests” is too strong. |
| `Learning.no_prefix_fixes_next` | Two distinct values and an actual prediction; unrestricted alternative courses, not a restricted known dynamics. |
| `Learning.merged_bound`, `merged_unrested` | Enumeration bound and diagonal obstruction; no theorem of transfer improvement or useful meta-learning. |
| `Flow.act_unselected_pool`, [SelectionPool](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/SelectionPool.lean) | Requires shared laws, balance, matched presence/start and within-closure agreement. It supplies an indistinguishability bound, not automatic exploitation of the union. |

**Fix:** attach a short premise card to each table row. Preserve quantifiers and constructive negations, not merely declaration names.

**9. High — §3’s nested-selection table is a schema, not one established law of all levels.**

A constant choice function can factor through an informative map while separating nothing. Thus “what its map separates” describes available discrimination, not actual reach. Likewise, an outer training can select every candidate, or use a coarse reward, while reading rich courses.

The premise that each level is a selection whose selector is “the level above” is also not generally established. Memory, environment, peers and internal dynamics may provide additional inputs; a relation graph need not form a hierarchy.

**Fix:** replace exact-reach language for individual mechanisms with an upper bound. For each row specify its input/output types, indistinguishability relation, factorization and any converse richness assumption. Evolution and society require their own instances; naming `Training` does not supply them.

**10. High — §5’s “one failure, one exit” confuses independence from omitted variables with locking.**

[ClosedCapture.courses_alike_iff_unread](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean) says two courses starting with the same share and rule remain alike when only their unread component differs. Neither course need be constant, increasing or locked.

Counterexample: take a unit share, Boolean rule, and update `h(_,g) := !g` at every reading. Nothing outside is read, yet the rule alternates forever. `constant_iff_unread` expresses preservation of an equivalence under dynamics, not temporal constancy of the rule.

The table’s standing should be:

- **Counted choice and institutional capture:** existing concrete mechanisms, under their locking and monotonicity premises.
- **Motivated updating:** selected examples and interpretations, not a universal reduction.
- **Confirmation in inquiry:** an information restriction; `explored_same_courses` supplies no confirmation-bias dynamics.
- **Preference shaping and deceptive alignment:** analogies until preferences, intervention and strategic continuation are represented.
- **Echo chambers:** conditional pool indistinguishability, not automatic capture.
- **Cascades:** information suppression; a cascade can be accurate and beneficial.

`turned_by_loss` additionally requires accumulating loss, a bound beyond which the update ceases to favor, and an actual sufficiently late reading.

**Fix:** replace “one failure” with “shared information-obstruction pattern.” External information is necessary for **loss-dependent differentiation under fixed factorization**, not for every change or escape. An internally scheduled reset can escape a pattern without detecting its external losses.

**11. High — “Concealment as shaping” changes both the mechanism and the inequality.**

[RuleShaping.favours_iff](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RuleShaping.lean) states weak favoring of natural-number offspring counts exactly when `c ≤ s`. It does not state an optimizer chooses concealment. The proposed preservation inequality is strict, `(q_M − q_H)V > c`, and involves probabilities and continuation value.

`nothing_back_falls` requires positive cost, positive baseline reproduction and initially present shapers. Falling population share is not necessarily elimination of deceptive behavior.

**Fix:** label this an analogy unless an explicit translation preserves the variables, comparison and dynamics. Prefer a small two-stage preservation model with a defined choice between disclosure and concealment. Neither an unobservable schedule nor zero private advantage alone establishes honest behavior.

**12. High — §5’s ethical bridge and §6.2’s openness conclusion exceed their laws.**

“A loss enters any course only by being read” is false as ordinary causal language: an unobserved resource loss can destroy a continuation. If “read” includes every causal dependence, the sentence becomes broad enough to lose its cognitive content.

**Fix:** say that a *selection conditioned on a loss* must receive a relevant distinction. Preserve the distinctions between causal effect, information, recognition, motivation and execution. The continuation condition supplies scope and C supplies order; neither entails a universal architecture of outside readers.

[Run.possible_of_next](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReachableRanges.lean) is reachability monotonicity under one fixed process and admission predicate. Internal construction can still enlarge immediate actions, bounded-horizon reach, knowledge or possibilities with the current rule held.

[RuleTower.possible_iff_held](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldPossible.lean) says each finitely reachable possibility needs changes only below some finite height in its asynchronous tower.

**Fix:** remove “comes only … from what lies beyond it.” Departure from a selected process description does not establish an external cause or metaphysical necessity of openness.

**13. Medium — Novelty labels are mostly modest, but reuse and completeness need sharper boundaries.**

Relevant existing work includes:

- RF2.2’s selection consequence: `Learning.Training.unselected_beyond_data`.
- RF3.1: `«闭之及»` plus the one-edge converse.
- RF3.3’s deterministic core: `Law.core_is_sameFuture`.
- RF6.1’s refinement preservation: `GuardHorizon.uniform_finer`; its executable revision example: `Revising.controlled_revision`.
- RF6.3: `Diagonal.gap_unsaid`.
- Related order results: [Presence.prec_iff_every and either_order](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Presence.lean).

The `Presence` results concern finite natural labellings and have decision hypotheses. They are related, not identical: RF1’s arbitrary strict partial orders permit simpler constructive proofs.

**Fix:** register integration only where it adds a substantive connection. The added-edge lemma and a genuine executable-reading composition are plausible local contributions. Drop separate-result treatment of RF1.6, RF3.1 and the diagonal wrapper.

Coverage still lacks actual internal search, action-conditioned prediction, model acquisition under misspecification, strategic recipient inference, assistance that changes information or preferences, correction acceptance, and network learning beyond copying. Add one joint finite mechanism connecting prediction, selection, updating and intervention; use it for concrete alignment, assistance and institutional instances. “Every topic is a case or debt” should be a mapping milestone, not completion of Ren’s objective.

**14. Medium — The frozen tests need independently checkable premises and stronger failure criteria.**

- **TR1 can fail informatively:** cycles can reject stable strict-dominance rationalization. But ties, stochastic choice, changing context and invalid choices also produce violations. Freeze these assumptions and a noise model. No prediction beyond the reach means successful extrapolation there cannot confirm RF1.
- **TR2 currently tests a tautological deterministic bound.** Identical prompts can yield different sampled outputs without violating anything. Hold weights, memory, accessible context and policy kernel fixed; compare output distributions. Randomize cues and measure detector accuracy, behavior and recipient error separately.
- **TR3 cannot fail if the cascade is implemented by deleting private-signal access.** That is an implementation check. Make it informative by predicting when naturally operating agents cease using private signals, then intervene on those signals. Test the claimed restoration separately.
- **TR4 can be informative**, provided revision success is not defined as whatever produces correction. Independently freeze acceptability, stock/link feasibility, observation classes and deadline; include finer-reading/no-stock, stock/no-link and available-but-refused correction controls.

RF3 has no corresponding test despite C5. Add an intervention test of maintained reading soundness and task performance; the universal reading must not count as success.

**What I did not check**

I inspected the plan, evidence maps, relevant framing, source request, board entry and the cited Lean statements and selected proofs. I searched for overlapping repository results and made a limited literature check concerning the revealed-preference attribution. I did not exhaustively read every chapter or module, verify all literature equivalences, establish scholarly originality, reproduce experiments, or recheck compiler and axiom reports. The proposed repairs and counterexamples above are mathematical review arguments, not newly Lean-verified results. I created or edited no files and ran no builds, `make`, rendering or commits.

── cx · ok · session 01a18750-f4d0-78e0-8706-94feae36dd8a · gpt-6-astra/high · read-only · 706s · 1687.0k tokens · 34 cmds
continue: cx -r 01a18750-f4d0-78e0-8706-94feae36dd8a "…"
log: /Users/ren/.cache/cx/runs/20261029-175951-18330
