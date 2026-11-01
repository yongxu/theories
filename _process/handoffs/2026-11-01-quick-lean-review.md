# Quick Lean review, 1 November 2026 (AI-written, read-only, nothing built)

Eight parallel read-only passes over 40 recently changed core modules (~35k lines), plus a grep sweep of all 369.
No `sorry`/`axiom`/`Classical`/`propext`/`native_decide` in code. No false or vacuous-hypothesis theorem found. Passes were partial (often 15–40% read closely).

## Worth acting on
- RootForms.lean:179, :287 — `… = … := rfl` "certificates" hold by proof irrelevance; they cannot fail, the type ascription does the check.
- SignificanceStatements.lean:72 — `paths_comparison_grammar` sets the order to widening, so it restates extension⇒widening; header row 7 reads as more.
- UnreadStandings.lean:364, 463 — result is about `ModelRelations`' selection; record name `standings-not-read-off-the-occurrence-model` says "the occurrence model".
- PremiseWitnesses.lean:160 — `ReadsNoOrder.not_entails` quantifies over every order and picks the empty one; weaker than the premise-card wording.
- PremiseWitnesses.lean:486 — `extension_ranked_of_increasingInOwn` takes global `Unrestricted`, uses it at one p.
- GrammarScope.lean:275 — `premises_of_noOutside`: sig supplied by hypothesis `reads`; "follows" overstates.
- Grammar.lean:804 `«火薪相须»` — holds by equality of `«合» alike sameFuel`; any separating class works (l.821).
- GrammarMap.lean:390–440 — generation witnessed with `«静»` fine class, near-trivial renewal.
- PatternPassing.lean:103–170 — `ByPassing` results never use `passes`; docstrings credit passing.
- UnitMatchings.lean:84–157 — `FrameMatch N M ↔ N = M`; matchings restate balance. :326 near-definitional, `takes` unused.
- FreeEnergyCounting.lean:583 (+ header 46–48) — at total 0 both sides are 1 (0^0), not "nothing". Verified.
- BlanketWeights.lean:611, 618–630 — independence from uniform `w` alone; chain/rate unused.
- BlanketCouplings.lean:443 — ThresholdDrain join with empty couplings; header should say so.
- RevisionPlans.lean:135–165 — parameter `loss` is switching-off's gain; clashes with `KeepStop.loss`. `ofRoutes` truncates without `Valid`.
- SelectionPool.lean:270 — "however many members tell them apart" contradicts the majority premise.
- MapRegions.lean:239 — "from every occurrence" but stated from `.first`.
- ListingValuation.lean:1530 — docstring's trailing sufficient condition not in the statement.
- GrammarCrossing.lean:86, 129 — docstring relations asserted, not shown.

## Disclosed / count-as-corollary only
Wholes `Whole` (activity coincidence), Generations lineage `True`; ModelStatements §4 readings; Persistence `Iff.rfl` laws (950, 528);
ReadStages `uniform_best_iff`, `no_value` family; OpenedCorrection `acceptable := True` witnesses; RootForms `*_vacuous` minimality witnesses;
`«止而不入之例»` with `F := False`; PremiseWitnesses 376/394 near-definitional; BlanketCouplings `const_consistent`.
