# Migration map: exclusive-footprint-support

Old record sha256 `eba02b611d35285449d9fc9afa85d9946fe71c08948bbea74f5ceff6df2a31b5`; snapshot `_process/architecture/history/eba02b611d352854/exclusive-footprint-support.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/JointPlans.lean` (`JointPlan`, `JointPlan.Realizes`, `PartsWithin`, `PartsApart`, `Supports`, `JointPlan.draws`, `JointPlan.within_of_realizes`, `JointPlan.nodup_of_realizes`, `JointPlan.supports_of_realizes`) and `Becoming/Composition.lean` (`Unjoined.supports_not_realizes`), at the bytes bound by the record's proof bindings. Every condition is kept: the plan realized with each leaf read as `Supports` (laws 2 and 3, as hypotheses[0] says); `PartsWithin` alone for `within_of_realizes` (law 2) and with `PartsApart` for `nodup_of_realizes` and `supports_of_realizes` (law 3). The witness (law 4) is the relation holding no parts, the footprint holding everything and a plan of two empty leaves. `JointPlan` was added to the JointPlans.lean reference. The record's proof bindings list the Composition.lean binding twice; the entries are identical and are kept as they were.

| Old text | Type | New place |
|---|---|---|
| T0 "Exclusive footprints support all leaves" | title | title (unchanged) |
| S0 | statement | statement (unchanged) |
| C0a "For a plan realized at a configuration with each leaf supported (its list repeating nothing and lying within the leaf configuration's footprint):" | condition + definitions | law 1 (`JointPlan.Realizes`, `Supports`) and law 2 (the condition) |
| C0b "what its leaves draw on, joined in order, lies within the root's footprint where each part's footprint lies within its whole's," | law | law 2 |
| C0c "and repeats nothing where moreover the two parts' footprints share nothing;" | law | law 3 |
| C1 "together, the root's footprint supports it." | law | law 3 |
| L0–L1 "This direction derives support from a realized plan; converse realization cannot omit additional structure." | converse | does_not_show[0] (kind converse, witness `Unjoined.supports_not_realizes`); law 4 states the witness, which the history entry of 14 October 2026 calls "the record's limitation witnessed on the spine" |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; the bound receipts report empty axioms for every cited declaration) |
| V0–V2 "Credits the linked existing Lean receipt. This migration reads source and checks declaration presence and receipt hash binding; it does not rerun Lean." | evidence (superseded) | validation_scope (the bound core receipts); the 8 October migration it described is history entry 0, and the sentence stays in the snapshot |
| R0 | correspondence | correspondence (unchanged) |
| N0 "Reuse for nested exclusive requests;" | next step | next_delta (unchanged wording) |
| N1 "sharing or renewal requires a new account." | next step | next_delta ("an account of its own for footprints that are shared or renewed", stated positively) |
| H0.0–H0.1 | premise | hypotheses[0] (unchanged) |
| X0 | counterexample | counterexamples[0] (unchanged; its text repeats the old limitation, now does_not_show[0]) |
