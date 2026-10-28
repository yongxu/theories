# Migration map: joint-correlation-reduced-dynamics

Old record sha256 `3fc423f9c6890593952077e3db3ec5bf53b5ed5b137419f8a7b1bd4741838cfb`; snapshot `_process/architecture/history/3fc423f9c6890593/joint-correlation-reduced-dynamics.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Readout.lean` (`law_through_iff`, `foldl_semiconj`), `Becoming/JointPhase.lean` (the witnesses, the two obstructions and the summary laws) and, for law 6, `universal-ethics/generative-capacity/MachineInstances.lean` (`summary_carries_law`, `summary_every_word`, stated of the periphery's `RelationalReduction.next`), at the bytes bound by the record's proof bindings. Every condition is kept: `law_through_iff` is an equivalence for a law given as a function of configuration and move (law 1); the witnesses are the joined configuration and its phase-changed one, with the retained cross contribution 1 and −1 (`retained_cross_distinguishes_change`, law 2); `no_local_pair_update` says no update agrees with the control after the interaction at both configurations (law 3); `every_finite_control_response_exact` and `summary_response` give the response after every word and at the end of every trace (law 4). The core proves that the summary commutes with both moves (`summary_update_exact`); that it carries a determined law is proved in the periphery's form (law 6), whose two declarations use propext, so the record cites `no-ethical-premise-core-axiom-free`. No declaration was added to the references.

| Old text | Type | New place |
|---|---|---|
| T0 "Relational transformation with unchanged local states and a sufficient reduction" | title | title (unchanged) |
| S0–S1 | statement | statement (unchanged) |
| C0 "For every law of change with moves and every reduction: some determined law on the reduced values carries every step exactly when configurations the reduction merges are taken by each move to configurations it merges;" | law | law 1 ("a law of change giving the next configuration for each configuration and move", as `law_through_iff` takes `next : S → A → S`) |
| C1 "a reduced law that commutes with every move commutes with every course of moves." | law | law 1 ("every finite course", the lists of `foldl_semiconj`) |
| C2 "In the specified two-qubit real-amplitude fragment, an actual phase operation preserves both complete local densities and the joint basis distribution, while the same subsequent controlled-X gives different control responses;" | law (witness) | law 2 (the responses (4, 0, 4) and (0, 4, 4) and the retained cross contribution written in) |
| C3 "so the local density pair carries no law and cannot uniformly determine the next control state." | law | law 3 |
| C4a "A four-integer summary retaining the relevant joint cross contribution carries one," | law | law 4 (in the core: the summary commutes with both moves) and law 6 (the periphery's form: it carries a determined law) |
| C4b "giving exact control densities and responses for every finite word of the supplied interaction and phase operations:" | law | law 4 |
| C4c "both are instances." | law | laws 3 and 4 ("an instance of the general law above", "again an instance of the general law") |
| — (no old sentence) | law | law 5: `summary_omits_other_relations`, in the counterexamples before and now also a law |
| L0a "Does not prove full behavior for arbitrary complex or mixed states," | scope | does_not_show[0] |
| L0b "a minimal summary for every operation," | non-implication | does_not_show[1] |
| L0c "hardware realization," | correspondence | standard_boundaries: formal-not-empirical |
| L0d "causal nonseparability, universal ontology" | correspondence | does_not_show[2] |
| L0e "or ethical authority." | standard boundary | standard_boundaries: no-evaluation and no-ethical-premise-core-axiom-free (the hypotheses hold no ethical premise; core declarations report empty axioms, the two periphery declarations propext only) |
| L1 "The strong zero-substantive-axiom goal for Becoming as a whole remains open." | standard boundary | standard_boundaries: zero-axiom-target-open |
| V0–V1 "Lean 4.29.1 checks 11 module theorem declarations / 25 audits, 21 empty and four using only propext. Separately credits 74 inherited theorems / 123 audits: total 148, 134 empty and 14 standard." | evidence (counts) | validation_scope names the earlier module RelationalReduction and its receipt directory; the counts stay in that receipt (deeper/relational-reduction-checks/20261008T185413.598553Z) and the snapshot |
| V2 "Source, import closure, signatures and receipt bound;" | evidence | validation_scope (the bound receipts of JointPhase, Readout and MachineInstances; the import closure is the checker's) |
| V3 "author counterreview, no independent-agent acceptance." | evidence | validation_scope ("Author counterreview; no independent review") |
| R0–R3 | correspondence | correspondence (unchanged; R2's evolve_semiconjugacy is the periphery's, hypotheses[2] names the core's law) |
| N0 "Use the established relation-retention condition in the constitutive account of Becoming as a whole." | next step | next_delta ("established" dropped, a status word) |
| N1 "Do not reopen this completed operational interface, require every change to be generative, or treat another local model as the universal deduction." | instruction | snapshot: instructions to later sessions belong on the work board; its substance, that one local model is not the universal deduction, is does_not_show[2] ("one witness … not a universal ontology"), and that not every change is generative is already the account's sense of generation ([glossary](../../../../../../GLOSSARY.md)) |
| H0.0–H0.2 | premise | hypotheses[0] (unchanged) |
| H1.0–H1.1 | premise | hypotheses[1] (unchanged) |
| H2.0 "All-finite-word exactness is restricted to the two specified operations and first-coordinate responses;" | premise | hypotheses[2] (the two moves named: the interaction and the phase step; "the control's response" for first-coordinate responses) |
| H2.1 "it reuses the existing SystemsOrganization theorem preserving reached-state composition." | premise | hypotheses[2] (the core proof uses Readout's `foldl_semiconj`, stated; the SystemsOrganization theorem kept as what the periphery's earlier proof reused) |
| X0–X1 | counterexamples | counterexamples[0]–[1] (unchanged) |
