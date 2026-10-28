# Migration map: fulfillment-chance-floor

Old record sha256 `89fc94daf5da6139383553f1f28e85e1530e5717dce34fd44608dc3447a51033`; snapshot `_process/architecture/history/89fc94daf5da6139/fulfillment-chance-floor.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Weighted.lean` (mass, inclusion, the all-weightings law), `Becoming/Courses.lean` (the two laws on frames) and `Becoming/ChanceFloors.lean` (the due protection, fulfilment, repair and the witness). Every condition the Lean takes is kept: decided equality of entries or configurations for `every_weighting_iff` and `claims_every_weighting_iff` (laws 2, 4; standard boundary decidability); the reading of claims by Boolean events at listed configurations and the fulfilment hypothesis for `claims_floor` (law 3); a positive total and fulfilment for `fulfillment_gives_chance_floor` (law 5); a listed entry of positive weight where the protection was not due and the candidate works for `repair_adds_new_protection` (law 6). Six definitions and theorems the laws name were not among the references and are added to ChanceFloors' entry (`total`, `target`, `Fulfilled`, `repair`, `repair_covers_target_and_candidate`, `repair_adds_new_protection`); every file's sha256 and binding is unchanged, and the bound receipts report an empty axiom list for every cited declaration. The duplicate proof binding of Weighted.lean is left as it was.

The old record had no statement; the new one says what the home section (07-SIGNIFICANCE, `r-fulfillment-chance-floor`) says.

| Old text | Type | New place |
|---|---|---|
| T0 “Fulfillment implies a same-law chance floor” | title | title (unchanged) |
| (none) | statement | statement, written from the home section |
| C0 “In a finite coupled domain, pointwise coverage of demand with still-working old support yields a mass floor under one positive total weight;” | law | laws 1 (mass and inclusion), 3 (`Courses.claims_floor`, on a frame) and 5 (`ChanceFloors.fulfillment_gives_chance_floor`, with the positive total); law 6 (repair) states the event-level repair the old limitation named |
| C1 “preservation for all natural weights characterizes inclusion.” | law | laws 2 (`every_weighting_iff`) and 4 (`Courses.claims_every_weighting_iff`), with the decided equality the Lean takes written in |
| H0 “Finite event enumeration, natural event weights, target demand AND oldWorks, and Fulfilled; probability interpretation requires positive total weight.” | premise | hypotheses[0] (unchanged) |
| L0 “Equal success under one law need not fulfill the undertaking pointwise;” | witness | counterexamples[0] (law 7, `positive_chance_can_miss_due_protection`) |
| L1 “an event-level repair definition does not ensure timely authorized implementation.” | non-implication | does_not_show[0] |
| V0 “Credits the linked existing Lean receipt.” | evidence | validation_scope (the core receipts in becoming-checks binding the three modules, and the original's receipt) |
| V1, V2 “This migration reads source and checks declaration presence and receipt hash binding; it does not rerun Lean.” | evidence (bookkeeping) | snapshot (they described the 8 October migration) |
| R0 “Coupling, time window, coverage and validity of the undertaking need evidence;” | correspondence | correspondence (unchanged) |
| R1 “weights are not ethical importance.” | correspondence | correspondence (unchanged); does_not_show[1], as the home section says it |
| N0 “Reuse this bridge for takeover;” | instruction | snapshot (an instruction to reuse); next_delta names the step a takeover needs |
| N1 “additional tasks still require actual implementation and warranted undertakings.” | next step | next_delta (“A due protection read off an actual run: … so that the floor holds of an actual takeover”) |
| X0 “Equal success under one law need not fulfill the undertaking pointwise; an event-level repair definition does not ensure timely authorized implementation.” | counterexample (first half witnessed) | counterexamples[0], narrowed to its witnessed half and naming its declaration (`positive_chance_can_miss_due_protection`, in the original's file and ported to ChanceFloors); the second half, which no declaration witnesses and repeats L1, is does_not_show[0] |

Related: the detail of practical-judgment-under-living-significance began “J3 supports the undertaking interpretation”, a retired label; it now reads “Bounded responsibility, one of the practical commitments, supports …” (Chinese J3 → 实践承诺中的有界责任), the meaning the method chapter's premise card gives J3.

Standard boundaries: no-ethical-premise (the hypotheses are the finite enumeration, the weights and the supplied events, and the bound receipts report empty axiom lists for every cited declaration) and decidability. Unchanged: id, kind, status, family, canonical_source, aliases, dependencies, the references' paths and sha256 (declarations added only), proof_bindings, the earlier history entries. The R35 compaction snapshot `_process/architecture/history/b9d1f8d4d39138c2/fulfillment-chance-floor.json`, named in the condensed history note, is the second text_versions entry.
