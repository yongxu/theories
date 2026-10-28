# Migration map: trace-law-equivalence

Old record sha256 `0160e5cbd634fcbeb36d978042dbc9e1d29e0df16a104321a040e660151014c7`; snapshot `_process/architecture/history/0160e5cbd634fcbe/trace-law-equivalence.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations: `same_steps_iff_traces` in `Becoming/Labelled.lean` (an iff proved in both directions, no premise on the processes), `Generative.trace_singleton_iff` in `GenerativeCore.lean` (a trace of one move is exactly a step), and `Carriers.static`, `Carriers.toggle`, `Carriers.word_feasibility_does_not_determine_endpoints` and `Carriers.static_toggle_not_same_steps` in `Becoming/Carriers.lean`. The claim's “traces of one move sufficing” is the docstring of `same_steps_iff_traces`, whose converse direction uses only one-move traces; as a stated law it is `trace_singleton_iff`, now cited. GenerativeCore.lean had no references entry, so one was added with the newest receipt binding its current bytes (`becoming-checks/20261027T195912.152773Z`, from `binding_for.py`). The bound receipts report empty axioms for every cited core declaration, so `no-ethical-premise` is cited; the periphery and retired files stay provenance or integration, as before.

| Old text | Type | New place |
|---|---|---|
| T0 “Step laws and endpoint traces” | title | title (unchanged) |
| S0 “Two processes on the same configurations and moves take the same steps exactly when they have the same finite traces with both endpoints kept” | statement | statement (unchanged) |
| S1 “traces of one move suffice.” | statement | statement (unchanged); law 1 (with `trace_singleton_iff`) |
| S2 “Feasible words alone lose the law.” | statement | statement (unchanged); law 2 |
| C0 “A law is fixed by its traces: two processes on the same configurations and moves take the same steps exactly when they have the same finite traces with both endpoints kept, traces of one move sufficing.” | law | law 1 (“from every configuration”, as the Lean quantifies; “a trace of one move is exactly a step, so traces of one move suffice”) |
| C1 “Forgetting endpoints loses the law: the process that stays put and the one that flips a bit take the same words from every configuration and end differently after one move, so they do not take the same steps.” | law (witness) | law 2 (static and toggle by their names, on two configurations with one move; “end differently after one move” as the Lean has it: static goes from false to false in one move and toggle does not); counterexamples[0] (unchanged) |
| H0 “Common State and Action types, supplied Process.step relations, and the existing Trace definition.” | premise | hypotheses[0], restated in the account's words (configurations and moves of any kind, no premise on either process, the foundation's finite traces carrying every intermediate configuration) |
| R0 “The actual interpretation of states, actions and steps remains supplied.” | correspondence | correspondence (unchanged) |
| X0 “Word feasibility alone loses law information; static and toggle processes supply the counterexample.” | counterexample | counterexamples[0] (unchanged) |
| L0 “Word feasibility alone loses law information” | non-implication | counterexamples[0], which carries the same sentence; law 2 states it with its declarations; not repeated as a does-not-show item, so it is not rendered twice |
| L1 “static and toggle processes supply the counterexample.” | witness | counterexamples[0] (same sentence); law 2 |
| V0 “Credits the linked existing Lean receipt.” | evidence | validation_scope (the core receipts under becoming-checks named by location; the module receipt beside GenerativeCore and the source-reuse review keep their scope) |
| V1 “This migration reads source and checks declaration presence and receipt hash binding” | evidence (bookkeeping of the 8 October migration) | snapshot; history entry 0 records that migration |
| V2 “it does not rerun Lean.” | evidence (bookkeeping) | snapshot; the new history entry says no source hash changed |
| N0 “Reuse the original theorem or its existing public wrapper” | instruction to later sessions | snapshot: the public wrapper (`Generative.Model.laws_iff_endpoint_histories`) is retired and was dropped from the aliases on 25 October (history entry 10); reuse is shown by the dependency on finite-trace-transport |
| N1 “weaker observational scope needs a separate result.” | next step | next_delta (“For observations weaker than traces with both endpoints, such as feasible words or traces with one endpoint, state which conditions on the processes let them fix the law”), stated positively |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; the bound core receipts report empty axioms for every cited core declaration) |
