# Migration map: branching-target-uniqueness

Old record sha256 `3aa5b9aa10693210ed495496a5feec728bc83fe0f6b8a012c4afa1ecbe42bb37`; snapshot `_process/architecture/history/3aa5b9aa10693210/branching-target-uniqueness.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Likeness.lean`: `BranchingTest`, `BranchingTest.Holds`, `SameBranchingTests`, `SameBranchingTests.functional` and `Alike.functional` (`Alike` itself is defined in `Becoming/Labelled.lean`, described in words). Both uniqueness laws take any two frames with the same moves and claims and one hypothesis each, that the target is separated, by branching tests or by likeness; that condition is kept (laws 2 and 3, hypotheses[0]). No finiteness of the frames' steps is taken, as the old limitation said; law 2 says so. The bound core receipt (`becoming-checks/20261020T051144.879480Z`) binds Likeness.lean's current bytes and reports empty axioms for every cited declaration, so `no-ethical-premise` is cited.

| Old text | Type | New place |
|---|---|---|
| T0 “Target uniqueness for branching tests” | title | title (unchanged) |
| C0 “If branching tests separate the target model, two target positions agreeing with one source position on all tests are equal.” | law | statement (written from C0 and the home section, with the likeness law the record already cited); law 2 (`SameBranchingTests.functional`) |
| — | added law | law 1: what a branching test, its holding and passing the same branching tests are; law 3: `Alike.functional`, the likeness form, which the record cited in references and in its related link |
| H0.0 “ExplanatoryBranching Model, Test and Same” | premise | hypotheses[0], restated on the spine's frames (any two frames with the same moves and claims): since the twentieth review the proof the record cites as proof is Likeness.lean, the periphery's `same_functional` kept as an alias marked “(retired module)” and in a provenance reference |
| H0.1 “Separated holds for the target.” | premise | hypotheses[0] (“the target frame is separated by branching tests, or for the likeness law by likeness”), unchanged in content |
| L0 “This lemma itself needs no image-finiteness and does not alone establish universal bisimulation or unique ontology.” | scope, non-implication | “needs no image-finiteness”: law 2 (“with no finiteness of their steps assumed”); “does not alone establish universal bisimulation”: does_not_show[0] (“It does not show that configurations passing the same branching tests are alike”); “or unique ontology”: does_not_show[1] (“Uniqueness of the matching configuration does not make the target frame the one right description of the source”) |
| X0.0 the same sentence as L0, path ExplanatoryBranching.lean | counterexample | does_not_show[0] and [1] and law 2, as L0: the entry repeated the limitation and named no witnessed case, so counterexamples is empty |
| V0 “Credits the linked existing Lean receipt.” | evidence | validation_scope (the core receipt named; the periphery ExplanatoryBranching and the retired Bridge are provenance, the receipt under explanatory-branching-checks keeping its earlier scope) |
| V1 “This migration reads source and checks declaration presence and receipt hash binding” | evidence (bookkeeping of the 8 October migration) | snapshot; history entry 0 records that migration |
| V2 “it does not rerun Lean.” | evidence (bookkeeping) | snapshot; the new history entry says no source hash changed |
| R0 “Tests include conditions, negation, conjunction and action successors” | correspondence | correspondence (unchanged) |
| R1 “their applicability is part of explanatory scope.” | correspondence | correspondence (unchanged) |
| N0 “Reuse for this test language” | instruction | not in next_delta, which states a next step and not an instruction to reuse the result; the sentence stays in the snapshot |
| N1 “a richer language must retain its own semantics.” | instruction | not in next_delta: tests with parts, the richer language the record's related link names, keep their own semantics in joint-target-uniqueness, which states the same law for them; next_delta now names an application step (“Give, for an application, the target frame its branching tests separate, so that each observed configuration has one matching target configuration”) |
| related[1] “(Ren agreed with the direction)” | provenance | the reading of identity as likeness is labelled “(an AI reading)” in the related link; that Ren agreed with its direction is provenance, kept in the new history entry and the snapshot |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; the bound core receipt reports empty axioms for every cited declaration) |

The first related link, the aliases, the dependencies (none), the references' paths and hashes and the proof bindings are unchanged; `BranchingTest`, `BranchingTest.Holds` and `SameBranchingTests` were added to Likeness.lean's reference (all elaborated in the bound receipt). The second text_versions entry is the compaction snapshot named by the 20 October history note.
