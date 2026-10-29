# Migration map: endpoint-loss-and-return

Old record sha256 `32ccdb09f67955661bfd6e012aed8466439a667c3cb2a3239e6545c6274bfd6e`; snapshot `_process/architecture/history/32ccdb09f6795566/endpoint-loss-and-return.json`. Before its history was compacted (R35): `_process/architecture/history/c6d4517c23a99e3a/endpoint-loss-and-return.json`, the second text_versions entry.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations: `keeps_reach_iff_returns`, `same_reach_iff_returns`, `not_returns_iff_loses` and `DeadEnd.law` in `Becoming/Labelled.lean`; `Irreversibility.flip`, `Irreversibility.deadEnd_no_return`, `Irreversibility.same_change_different_return` and `Irreversibility.constant_reading_hides_loss` in `Becoming/Irreversibility.lean`. Every condition the Lean takes is kept: any process and any two configurations (laws 1 and 2), `t` reached from `s` for the same-reach equivalence (law 1), both directions of each `iff` proved (laws 1 and 2); the witnesses are the specific two-configuration laws (laws 3 and 4). The bound receipts (`becoming-checks/20261028T085101.429997Z` for Labelled.lean, `becoming-checks/20261020T051144.879480Z` for Irreversibility.lean) report empty axioms for every cited declaration and the hypotheses hold no ethical premise, so `no-ethical-premise` is cited. No reference, declaration list or proof binding changed: every declaration the laws name was already listed. The aliases `BecomingReversibility.same_endpoint_possibilities_iff_return` and `BecomingReversibility.irreversible_iff_endpoint_loss` name declarations of the provenance module `deeper/BecomingReversibility.lean` (checked: both are there) and are kept.

| Old text | Type | New place |
|---|---|---|
| T0 “Endpoint opportunity loss and return” | title | title (unchanged) |
| S0 “What can be had from a configuration is kept from another exactly where the other leads back to it” | statement | statement (unchanged) |
| S1 “failing to return loses a possibility, the start itself a witness” | statement | statement (unchanged) |
| S2 “and return belongs to the law, not to the change, which a reading that omits the configuration reached can hide.” | statement | statement (unchanged) |
| C0 “Every configuration reachable from s is reachable from t exactly when t leads back to s” | law | law 1 (for any process and any configurations s and t) |
| C1 “along a path from s to t, the configurations reachable from both are the same exactly when t leads back to s.” | law | law 1 (“for t reached from s”, the Lean's `onward : Reach P s t`) |
| C2 “t does not lead back to s exactly when some configuration reachable from s is not reachable from t” | law | law 2 |
| C3 “s itself is one.” | law | law 2 |
| C4 “Witnesses: the dead end and the flip both take false to true” | law | law 3 (with what each law is: the dead end one step from false into true with no continuation, the flip every configuration to its negation) |
| C5 “the flip returns from true to false and the dead end does not” | law | law 3 |
| C6 “read through the constant summary, every question about what the dead end reaches has the same answer from false and from true, though it cannot return.” | law | law 4 (with the statement's “a reading that omits the configuration reached hides the loss”, the docstring's reading) |
| H0 “Supplied Process.step, configuration identity, finite Trace and endpoint predicates; an actual forward path for the change interpretation.” | premise | hypotheses[0] (unchanged) |
| H1 “Full endpoint test family is structural, not an omniscient available observation; actual meanings require correspondence.” | premise | hypotheses[1] (unchanged) |
| R0 “States articulate relations within one unfolding.” | correspondence | correspondence (unchanged) |
| R1 “A return restores precisely the represented configuration; historical harms and distinct projected recovery targets are not erased.” | correspondence | correspondence (unchanged) |
| X0 “One occurring step admits both reversible and non-returning declared laws; a constant observation hides non-return.” | counterexample | counterexamples[0] (unchanged; witnessed by `same_change_different_return` and `constant_reading_hides_loss`) |
| X1 “These are weak-description controls, not refutations of a fully specified constitutive account.” | counterexample | counterexamples[0] (unchanged) |
| L0 “Fixed-law endpoint reachability only” | scope | does_not_show[0] (scope: reachability under one fixed law) |
| L1 “configuration equality does not erase history.” | non-implication | does_not_show[1] |
| L2 “No physical irreversibility … is proved” | non-implication | does_not_show[2] |
| L3 “No … ethical ranking … is proved” | boundary | standard_boundaries: no-evaluation (the record contains no ethical predicate and evaluates nothing) |
| L4 “No … law origin … is proved” | scope | does_not_show[0] (“where a law comes from … lies outside them”) |
| L5 “No … zero-substantive-axiom foundation is proved.” | boundary | standard_boundaries: zero-axiom-target-open |
| V0 “Lean 4.29.1: 10 new theorems / 14 audits, all empty named-axiom dependencies” | evidence | validation_scope (the periphery BecomingReversibility receipt, named as provenance; the core receipts named first, as the current proof) |
| V1 “23 inherited theorems / 28 audits separately rebuilt.” | evidence (bookkeeping of the periphery check) | snapshot; the periphery receipt keeps the count, and the current proof is the core |
| V2 “Two application examples.” | evidence | validation_scope (“two application examples”) |
| V3 “Author counterreview; no independent-agent acceptance or empirical validation.” | evidence | validation_scope (“Author counterreview; no independent review or empirical validation”) |
| N0 “Specify actual target-relative restoration in an existing formation/reconstruction mechanism, preserving support and history” | next step | next_delta (restated positively) |
| N1 “do not reconstruct completed path-composition results.” | instruction | dropped from the public fields: an instruction to later sessions (the work board's place); kept in the snapshot |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; the bound core receipts report empty axioms for every cited declaration) |
