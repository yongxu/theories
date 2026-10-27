# Valuation development: formal companion

**Supporting trajectory study, 7 October 2026:** [Present and future fidelity](lean/perspectival/README.md) adds 25 separately checked core-Lean theorems about a supplied readout's preservation of binary comparisons through deterministic evolution and specified action words. Its concrete witness distinguishes current success from continuation capacity. This is a correspondence study supporting the [perspectival ethical investigation](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/PERSPECTIVAL-GOOD-AND-TRAJECTORIES.md); it does not add a learned valuation mechanism or ethical warrant to the earlier results below.

7 October 2026. This is the formal companion to the [valuation-development argument](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/VALUATION-DEVELOPMENT-ARGUMENT.md). It checks six results about how an organization's selective dispositions can change through its own history, together with the finite countermodels showing that their hypotheses cannot be dropped. It is AI-authored. A separate internal AI review compiled it independently and accepted it with corrections, which have been applied.

## Contents

| File | Purpose |
|---|---|
| [lean/ValuationDevelopment.lean](lean/ValuationDevelopment.lean) | 33 theorems: U1 retention, U2 extension underdetermination, U3 prediction/scoring trade-off, U4 coupling and proxy capture, U5 convergence and divergence, U6 separable capacities (levels 1–4) |
| [lean/Audit.lean](lean/Audit.lean) | `#print axioms` for every theorem |
| [lean/audit-output.txt](lean/audit-output.txt) | Saved audit result |
| [lean/ClosedLoopValuation.lean](lean/ClosedLoopValuation.lean) | 11 theorems (§12 of the argument): under per-encounter contraction, closed-loop amplification needs a selection difference; witnesses of amplification, self-confirming underestimates, scheduled variation and generative or degenerative fates |
| [lean/ClosedLoopAudit.lean](lean/ClosedLoopAudit.lean), [lean/closed-loop-audit-output.txt](lean/closed-loop-audit-output.txt) | `#print axioms` for the closed-loop module and its saved result |
| [lean/ExplorationCoverage.lean](lean/ExplorationCoverage.lean) | 11 theorems (§13): under retention exact for the option reached, in a world whose consequences do not change, coverage equalizes estimates whatever drives exploration; witnesses of retained curiosity and optimism covering and of a low estimate preventing coverage |
| [lean/ExplorationAudit.lean](lean/ExplorationAudit.lean), [lean/exploration-audit-output.txt](lean/exploration-audit-output.txt) | `#print axioms` for the exploration module and its saved result |
| [lean/ValuationCompletion.lean](lean/ValuationCompletion.lean) | 15 theorems (§14): stale estimates after a change, a noise floor (reached and kept) and noise-induced lock-in, reduction of interaction with a fixed partner and a joint-coverage witness, level-5 route revision and level-6 valuation of others formed by pairing, each reaching selection |
| [lean/CompletionAudit.lean](lean/CompletionAudit.lean), [lean/completion-audit-output.txt](lean/completion-audit-output.txt) | `#print axioms` for the completion module and its saved result |
| [lean/ValuationBridges.lean](lean/ValuationBridges.lean) | 33 theorems (§16): finite weighted laws and one escape bound; coverage and exact estimates for one option with probability at least `1 - (r/q)^n` (positive totals); a noisy witness in which greedy lock-in has probability at least `1 - (2/3)^n`, so tends to certainty, and a curiosity witness; ledgers of generations closed under succession and division (formalized for lines and one division step), the lineage prefix bound, late arrivals needed under positive demand, and a countermodel without inheritance and an attribution illustration |
| [lean/BridgesAudit.lean](lean/BridgesAudit.lean), [lean/bridges-audit-output.txt](lean/bridges-audit-output.txt) | `#print axioms` for the bridges module and its saved result |
| [lean/LineageInProcess.lean](lean/LineageInProcess.lean) | 14 theorems (§17): the generation ledger is the core per-event support law (`AccountLaw`, U1) of a lineage process, and the lineage bound is its prefix bound; histories of every U1 process split into inheriting generations; the renewal channel process obeys U1, its windows are sustained generations, and lineage and the renewal–closure theorem hold on one process; persistence of a kind is decided by population membership |
| [lean/LineageAudit.lean](lean/LineageAudit.lean), [lean/lineage-audit-output.txt](lean/lineage-audit-output.txt) | `#print axioms` for the lineage-in-process module and its saved result |
| [lean/ValuationRenewal.lean](lean/ValuationRenewal.lean) | 7 theorems (§18): every valuation over formations determines an execution of the shared channel process; some valuation keeps a kind forever exactly when a self-renewing population contains it; otherwise every valuation loses it by an explicit time; valuing a kind is not keeping it; the contraction hypothesis of C1 is necessary |
| [lean/ValuationRenewalAudit.lean](lean/ValuationRenewalAudit.lean), [lean/valuation-renewal-audit-output.txt](lean/valuation-renewal-audit-output.txt) | `#print axioms` for the valuation–renewal module and its saved result |
| [lean/OneProcess.lean](lean/OneProcess.lean) | 6 theorems (§19): an organization with its consequence law is one process of the shared core; two interacting organizations are one organization on their joint state; cut at either center, the joint process gives a single organization whose consequences are its relation to the other's activity, and neither cut is privileged |
| [lean/OneProcessAudit.lean](lean/OneProcessAudit.lean), [lean/one-process-audit-output.txt](lean/one-process-audit-output.txt) | `#print axioms` for the one-process module and its saved result |
| [lean/lean-toolchain](lean/lean-toolchain) | `leanprover/lean4:v4.29.1` |

## Reproduce

The development uses core Lean only, with no Mathlib and no Lake project.

```sh
cd experiments/valuation-development/lean
lean -o ValuationDevelopment.olean ValuationDevelopment.lean
LEAN_PATH=. lean Audit.lean
LEAN_PATH=. lean -o ClosedLoopValuation.olean ClosedLoopValuation.lean
LEAN_PATH=. lean ClosedLoopAudit.lean
LEAN_PATH=. lean -o ExplorationCoverage.olean ExplorationCoverage.lean
LEAN_PATH=. lean ExplorationAudit.lean
LEAN_PATH=. lean -o ValuationCompletion.olean ValuationCompletion.lean
LEAN_PATH=. lean CompletionAudit.lean
LEAN_PATH=. lean -o ValuationBridges.olean ValuationBridges.lean
LEAN_PATH=. lean BridgesAudit.lean
# LineageInProcess also needs GenerativeCore, Depletion, SupportNecessity, ResourceContinuation
# and the renewal modules (RenewalAccounting, RenewalClosure, RenewalSufficiency, RenewalLink,
# RenewalCharacterization) from experiments/integrated-correction/general-framework/generative-basis/lean,
# compiled into the same LEAN_PATH in dependency order.
LEAN_PATH=. lean -o LineageInProcess.olean LineageInProcess.lean
LEAN_PATH=. lean LineageAudit.lean
LEAN_PATH=. lean -o ValuationRenewal.olean ValuationRenewal.lean
LEAN_PATH=. lean ValuationRenewalAudit.lean
LEAN_PATH=. lean -o OneProcess.olean OneProcess.lean
LEAN_PATH=. lean OneProcessAudit.lean
rm -f *.olean *.ilean
```

Axiom audit, 7 October 2026, after the axiom-free rewrite Ren asked for (the generative model needs no axioms): 123 of the 130 theorems depend on no axioms at all, not even Lean's standard `propext` and `Quot.sound`. The lemmas this needs are proved by structural induction in [lean/AxiomFree.lean](lean/AxiomFree.lean), and no module uses `simp`, `omega` or `funext` in a proof that reaches an axiom. There are no custom axioms, no `sorry` and no `native_decide`. The other 7 theorems, all in `LineageInProcess`, take the axioms only from shared theorems they call: `support_trace_balance`, `execution_interval_balance`, `unbounded_demand_requires_unbounded_credit` and `interval_total_unit_bound` in the shared support package. Their own proof steps are axiom-free. They become axiom-free when that package's axiom-free version reaches main; the dependency-map thread did that work. The renewal package became axiom-free on 7 October, so `ValuationRenewal` (all 7) and `attribution_is_by_population` now audit empty; the saved outputs were regenerated then. **Update, 7 October (dependency-map branch merge):** the shared support package is now axiom-free, and its identifiers use the renamed vocabulary: `SustainLaw`, `support_trace_bound`, `execution_interval_bound`, `unbounded_enactment_requires_unbounded_arrival` and `arrivalEvent`. `LineageInProcess` was updated to those names with no change of statement. All 130 theorems now depend on no axioms; the saved outputs were regenerated, and [lineage-audit-output.txt](lean/lineage-audit-output.txt) shows 14 of 14 empty. Three conclusions are now stated pointwise (`∀ a, … a = … a`) instead of as equalities of functions, which would need `funext`: `coverage_equalizes`, `optimism_covers` and `curiosity_equalizes_forever`. `Inherits` is defined by explicit cases so that its pattern match needs no axiom.

## Scope

- The universals quantify over every `Org` (selection plus retention law) and every consequence law.
- The countermodels are concrete finite witnesses checked by evaluation.
- `halving_nonexpanding_on_sample` is checked only over values below 8.
- Modules 1–4 are deterministic, and their noise floor has no probability law. The bridges module uses finite weighted laws with natural-number weights, constant total weight per step and one target option. It does not construct joint probability spaces for two learners, and it has no continuous measures. Its lineage ledgers take the per-generation prefix bound and inheritance as hypotheses. Interaction covers two organizations with a common presented condition. Levels 5 and 6 are minimal witnesses whose route-switching rule and plasticity law are supplied.
- This is formal mathematics about the stated representation. It is not empirical evidence and not an ethical result.
