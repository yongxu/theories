# Bounded sufficiency through actual inquiry

**Derived native packet law:** [this continuation](../../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/PROCESS-LAW-DERIVATION.md) derives the A/B/C probe profiles, source consumption and calibrated response from the original executable port. Exact chosen-schedule guards fund every actual phase rotation and the later probe/receipt, with interrupted states retained. [The public entry](../../GenerativeDerivedProcessLawModel.lean) passes 32 modules / 599 empty audits, including 190 additions and 5,928 closed original-command cases. Run `python3 check_native_packet_correspondence.py` then `python3 check_process_law.py` here. This is the calibrated one-packet probe interface; phase acquisition, calibration formation, arbitrary permissive controls and the primitive apparatus law remain separate obligations.

**Derived inquiry certificates:** [this continuation](../../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/DERIVED-INQUIRY-PREMISES.md) computes a policy or exact bounded failure, validates a proposed prefix, and derives continuations at actual reached beliefs. Global agreement preservation and a supplied successful prefix answer are unnecessary. The concrete packet example uses actual availability instead of `safe := True`. Run `python3 check_derived_inquiry.py` here for the combined fresh build; [the public entry](../../GenerativeDerivedInquiryModel.lean) retains every earlier audited declaration.

6 October 2026. Additive formal integration of the existing [inquiry-sufficiency argument](../../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/INQUIRY-SUFFICIENCY-MATH.md), under the [nondual method](../../../../../../../theories/becoming/history/NONDUAL-METHOD.md). The named connection is inquiry's actual effects on further activity → sufficient retained distinctions for a declared continuation. This supplies a structural interface for the stronger acquired-criterion question; it does not complete that mechanism or derive its warrant.

[InquirySufficiency.lean](InquirySufficiency.lean) imports only the unchanged [GenerativeCore](../../GenerativeCore.lean). The public [GenerativeInquirySufficiencyModel](../../GenerativeInquirySufficiencyModel.lean) also imports the existing outcome model unchanged. No new event law, reward, controller or physical state is introduced. `SafeTrace` is a proof annotation on existing native events.

## What is proved

- A terminal response is one common finite event word. `Completes` requires each prescribed next event to be available, every admitted successor to satisfy the prefix condition and continue, and every endpoint to meet the declared requirement. Existence of one favorable trace is insufficient.
- Inquiry moves candidate configurations through actual `Process.step` before partitioning them by the acquired observation. Every admitted successor enters its matching branch; any relevant historical target must remain represented in the configuration.
- `Policy` is independently inductive syntax with responses, inquiries and finitely many observation branches. `Within n` bounds inquiry nodes along each path. `sufficiency_iff_bounded_policy` proves that the constructive recurrence holds exactly when a sound policy with that bound exists, from an inhabited candidate set.
- An abort node is sound only on an empty branch. An empty initial set never establishes usable sufficiency. A live inquiry cannot pass through a universally quantified empty transition set: it must be enabled at every candidate.
- The execution results prove existence of a complete actual native path from every admitted starting configuration, satisfaction of the endpoint requirement by every admitted complete policy execution, and preservation of every declared prefix condition. `completes_after_actual_prefix` additionally preserves response completion after every actual response prefix.
- Constructive finite choice supplies the finite branch table without `Classical.choice`. Exact finite enumeration yields a local nonemptiness decision without requiring equality tests.

These are bounded path/plan guarantees, not a scheduling or probability-one liveness theorem. The bound counts inquiry events, not response-event length, elapsed time, fuel, storage or computation. Infinite State, Action and Response types are permitted; only the observation branching is `Fin k`. Existence does not make a policy physically available to the learner.

## The constructive branch distinction

The original mathematical recurrence requires success whenever a successor branch is nonempty. On an arbitrary predicate-valued belief, that implication alone does not supply an executable distinction between unreachable and live branches. Finite observation labels do not themselves decide arbitrary predicate nonemptiness.

Here `Sufficient` carries `EmptyBelief branch ∨ Sufficient n branch`. Every live sufficiency statement includes a witness of nonemptiness, and sound response/inquiry nodes likewise carry that witness. This makes the empty/live alternative explicit without invoking excluded middle.

`ImplicationSufficient` records the original implication form separately. `sufficiency_iff_implication_form` proves equivalence under `ClassifiedThrough`: explicit empty/live classification at the declared depth. This sufficient interface classifies every contemplated action/observation branch, including branches an eventual policy may not select; it is not asserted to be a necessary minimal interface. `empty_or_inhabited_of_decidable` and `nonemptyDecisionFromList` explain how decidability and exact enumerated successor data supply local classifications. The subsequent [finite extension](FiniteInquiryClassification.lean) discharges exact enumeration and classification for executable finite-state representations; faithful correspondence between that representation and the application remains a realization obligation. [Integration and review](../../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/CONSTRUCTIVE-DEPENDENCY-REMOVAL-INTEGRATION.md) distinguish these claims.

## Derived classification for executable finite representations

[FiniteInquiryClassification.lean](FiniteInquiryClassification.lean) constructs the complete `Fin size` list, proves its coverage, and filters it with executable membership. It constructs exact successor lists by testing all predecessors under the actual event relation and acquired observation. Every nondeterministic successor is retained. Induction on inquiry depth then derives `ClassifiedThrough`; no exact-enumeration or branch-classification proof is supplied to the final criterion.

The general interface accepts executable transition and initial-membership decisions. A Boolean transition-table and initial-membership specialization derives both internally, with no separate decision proof argument. This defines a generic representation interface, not a new physical event law. Arbitrary proposition-valued relations do not become decidable merely because their carrier is finite. An unbounded physical process needs a separately justified finite representation, retaining relevant resource and historical distinctions.

[GenerativeFiniteInquiryModel](../../GenerativeFiniteInquiryModel.lean) imports the sufficiency entry and this finite extension. It does not enumerate arbitrary action or response spaces, decide policy existence, install a planner or derive the criterion's meaning.

## Attainable questions

[AttainableQuestions.lean](AttainableQuestions.lean) reuses the original inquiry syntax and native successor semantics. It proves coarsening, answer combination under one shared policy, the no-common-upper obstruction and continuation composition at actual reached leaves. Question agreement is a logical terminal contract; a physical report or retained decoder needs its own implementation. Existing execution theorems supply actual traces and preservation of every declared prefix condition.

[OnePacketQuestions.lean](OnePacketQuestions.lean) formalizes the existing permissive A/B/C comparison, including arbitrary common controls and distinct exhausted denials. For any fixed-initial-target answer function, an inquiry exists exactly when `f B = f C ∨ f A = f C`. Thus A? and B? are separately answerable, while their common refinement and C? are not. This is a proof over arbitrary finite adaptive policies, not a bounded schedule search. The native source law is unchanged; full costed Python refinement and installed-controller affordability are not claimed.

Run the complete entry from the repository root:

```sh
python3 experiments/integrated-correction/general-framework/generative-basis/lean/inquiry-root/sufficiency/check_questions.py
```

The [checker](check_questions.py) pins the immutable 227-audit parent receipt, compiles every project import from frozen source, audits every added theorem/definition/abbreviation and requires all old and new reports to be empty. The [passed receipt](questions-verification.json) records **23 modules and 307 audits**: 227 inherited plus **80 added declarations** (47 theorems and 33 definitions/abbreviations). Sixteen evidence files, including eleven inherited source bindings, are frozen alongside the proof run. Every one of the 60 relevant saved full-belief one-packet decisions agrees with the proved criterion; neither the old graph producer nor the native apparatus is executed. Earlier runs and scientific evidence remain unchanged.

[Integration](../../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/ATTAINABLE-QUESTIONS-LEAN-INTEGRATION.md) and [review](../../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/ATTAINABLE-QUESTIONS-LEAN-REVIEW.md) distinguish formalized K1–K4/shared-policy results from the remaining finite-family converse, randomized extension, physical restoration and decoder-realization claims. The result supplies a constraint on acquired criterion formation; it does not complete that formation or the common foundation.

## Inputs and limits

The process, complete observation interface, response-word map, prefix condition and endpoint requirement are parameters. Their accuracy, availability, significance and authority are not inferred from policy existence. The state representation must preserve effects and historical target labels relevant to the declared question; a change in current configuration cannot erase an unanswered initial-state question. History-sensitive conditions require the relevant history in that representation.

The theorem does not infer an ethical criterion from an analyst's score. It does not prove that the existing method learner computes this recurrence or learns which distinctions matter. Nor does it replace the separate [inquiry-revision construction](../../../../../../../theories/becoming/history/INQUIRY-REVISION.md), whose added local event laws and actual formation/read/rewrite history have their own scope. This formalization credits the established finite contingent-planning argument; its contribution is a precise constructive integration with the repository's native Process/Trace API.

## Verification and reproduction

Run from the repository root:

```sh
python3 experiments/integrated-correction/general-framework/generative-basis/lean/inquiry-root/sufficiency/check.py
```

The [checker](check.py) recompiles the sixteen conservatively repaired structural modules, this module and the public import entry in a fresh temporary directory with pinned Lean 4.29.1. Local compiled imports are ignored. It pins an immutable successful structural receipt, checks current source hashes, retains every original audit name and requires every inherited and added audit to be empty. The import-only public entry contains no declarations.

The [current sufficiency receipt](verification.json) records **18 modules and 212 audits, all empty**. The original inquiry source is unchanged: its 16 theorem audits and finite-list decision function are retained. The earlier 18-module/196-audit receipt and its inherited standard dependencies are preserved in the [pre-repair archive](../../verification-history/2026-10-06-before-axiom-removal/manifest.json). [Development notes](DEVELOPMENT.md) retain the original scoped implementation history.

For the full finite extension, run:

```sh
python3 experiments/integrated-correction/general-framework/generative-basis/lean/inquiry-root/sufficiency/check_finite.py
```

The [finite checker](check_finite.py) compiles the complete **20-module public closure** from frozen source and pins an immutable successful sufficiency receipt. Its [receipt](finite-verification.json) passes **227 audits, all empty**: 212 inherited plus 15 added (12 theorems and three definitions/decision kernels). It has no allowed-axiom exceptions. Earlier narrow and intermediate builds remain in `finite-runs/`; their counts are development stages, not additional independent results. Source, checker, parent receipt, compiler logs and run receipt are preserved on every run. Empty dependency reports discharge named proof dependencies at this scope; they do not establish an assumption-free ontology or the physical and practical premises listed above.
