# Migration map: draws-on-a-shared-stock

Old record sha256 `5c832183c236a87daf00f735680bb3bb58d4720dcc2fafe7fab2de10494b821b`; snapshot `_process/architecture/history/5c832183c236a87d/draws-on-a-shared-stock.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Weighted.lean` and `Becoming/Courses.lean` (core), and `meta-attractor/SharedStockInstances.lean` and `meta-attractor/CorrectionDependence.lean` (periphery, `experiments/market-generativity/`). `every_event_within_iff` quantifies over every event (`Ω → Bool`) of a listed domain with a weighting in `Nat`; the mass counts an entry listed twice twice (law 1). `entries_within_not_together` is the witness of two entries of weight two against the bound two; `Courses.supported_not_together` the web witness `twoDrawers` (law 2). The claim's “first n draws” is SharedStockInstances' `firstDraws`, whose selected totals are masses (`selectedTotal_eq_mass`, `total_eq_mass`), so CorrectionDependence's theorems are the core law on that domain (law 3). “combination” is kept, as DF1 wrote it, for what the Lean calls a selection (`chosen : Nat → Bool`). The core and SharedStockInstances receipts report empty axiom lists; CorrectionDependence's two cited theorems report `propext` and `Quot.sound`, so `no-ethical-premise-core-axiom-free` holds.

| Old text | Type | New place |
|---|---|---|
| T0 “Draws on one shared stock: every combination fits exactly when the total does” | title (a statement) | title shortened to the name “Draws on one shared stock”; the part after the colon is what the statement says |
| S0 “Draws on one listed domain fit within a bound in every combination exactly when their total does;” | statement | statement (unchanged) |
| S1 “each draw fitting alone does not make them fit together.” | statement | statement (unchanged) |
| C0 “Of the first n draws, given as natural numbers, every combination fits within the stock exactly when their total does.” | law (instance) | law 3 (`firstDraws`, `selectedTotal_eq_mass`, `total_eq_mass`, both `every_selection_within_iff_total_within`); law 1 states the core law it instantiates |
| H0 “The draws are natural numbers that add; the stock is the one quantity they all draw on.” | premise | hypotheses[0] (unchanged) |
| R0–R2 “In the source model, each draw is the work an activity needs to stop without its transition loss, … The numbers are not a general measure of value; their correspondence to actual activities and stocks needs separate evidence.” | correspondence | correspondence (unchanged) |
| X0 “Each draw fitting alone does not make them fit together: two draws of two units each can compete for one stock of two.” | counterexample | counterexamples[0] (unchanged); law 2 and law 3 state the witnesses |
| L0 “Each draw fitting alone does not make them fit together: two draws of two units each can compete for one stock of two.” | non-implication | does_not_show[0] (wording unchanged, witness `entries_within_not_together`) |
| V0 “Credits the linked existing Lean receipt.” | evidence | validation_scope (the core, instance and source receipts named, with their axiom reports) |
| V1 “This migration reads source and checks declaration presence and receipt hash binding; it does not rerun Lean.” | evidence (history of the 8 October migration) | validation_scope (“The 8 October migration of this record read the source and checked receipt bindings without rerunning Lean”); history entry 0 |
| N0 “Reuse wherever draws add on one shared stock;” | next step | next_delta (unchanged) |
| N1 “other kinds of support need a stated translation or a separate proof.” | next step / scope | next_delta (unchanged) and does_not_show[1] (the law is for draws that add on one stock) |
