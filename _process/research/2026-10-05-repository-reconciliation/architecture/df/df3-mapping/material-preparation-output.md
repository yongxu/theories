# Migration map: material-preparation-output

Old record sha256 `6540bb12f9b48cb6669049a1774170300f64ffd0d5c8d1f3b1ef6af9e1195207`; snapshot `_process/architecture/history/6540bb12f9b48cb6/material-preparation-output.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Copying.lean` and `Becoming/Courses.lean` (core) and `MaterialMaturation.lean` and `PreparationCorrespondence.lean` (periphery). The conditions the Lean takes are kept: decidable equality and any law of draws (laws 1 and 2); a supplied word for `countOf_removeAll` (law 1); Boolean tokens and the unit draw for the correspondence of routing with copying (`route_some_iff`, law 3); the permutation and `target.length ≤ fuel` (laws 4 and 5); the declared pool of the failing witness (law 6); and the eight-slot recipe with eight units (law 7). `canonical_iff_counts`, which `actual_preparation_iff` rests on, and `partial_routing_preserves_unused_components_and_work`, which witnesses the hypothesis that failure keeps partial state, were added to the references of `MaterialMaturation.lean`; its bound receipt `material-maturation-verification/verification.json` lists both (`Classical.choice`, `Quot.sound`, `propext`; `propext`). The core receipts report empty axiom lists for every cited declaration and the periphery receipts (the PreparationCorrespondence check under Lean 4.30.0-rc2) at most `propext`, `Quot.sound` and `Classical.choice`, so `no-ethical-premise-core-axiom-free` holds.

The old record had no statement; the new one says what the home section (04-LIFE, `r-material-preparation-output`, its core-law and instance cells) says.

| Old text | Type | New place |
|---|---|---|
| T0 “Actual material preparation output” | title | title (unchanged) |
| (none) | statement | statement, written from the home section |
| C0 “For every target recipe, pool and routing support: route completes with an empty residual pool exactly when the pool is a permutation of the recipe and the recipe is no longer than the support, the remaining support then being the support less the recipe's length;” | law | law 4 (`preparation_empties_iff`, `preparation_leaves`); law 5 (`route_sound`, `route_complete`); laws 1–3 give the core form it is an instance of (`empties_iff` and its course form, `route_some_iff`) |
| C1 “the actual routeTrace keeps placed and residual material for every input, and route is its projection.” | law | law 6 (`routing_trace_accounts`, `route_trace_projection`) |
| C2 “The specified eight-slot recipe under eight support units is an instance: whole-pool completion requires exactly four A and four B.” | law | law 7 (`canonical_iff_counts`, `actual_preparation_iff`: exactly when four of each kind) |
| H0 “Supplied target recipe and type-sensitive removal/movement; completion requires no residual pool, while failure retains partial state.” | premise | hypotheses[0] (unchanged); law 6 states its last clause as a witness (`partial_routing_preserves_unused_components_and_work`) |
| (new) hypotheses[1] | premise | the core laws' generality and routing's Boolean tokens, unit draws and natural-number counts, as the Lean has them |
| X0 “Recipe/capability formation, mechanical release and renewed provision remain unexplained; a success scalar does not replace actual material.” | non-implication | does_not_show[0] and [1]: the counterexample repeated the limitations word for word and no declaration witnesses it, so the entry goes and counterexamples is empty |
| L0 “Recipe/capability formation, mechanical release and renewed provision remain unexplained;” | non-implication | does_not_show[0] (“do not follow from these laws”, not a status) |
| L1 “a success scalar does not replace actual material.” | correspondence | does_not_show[1] |
| V0 “The cited Lean receipt binds the actual source;” | evidence | validation_scope (the four bound receipts named, with their checkers, Lean versions and counts) |
| V1 “inference validity and biological correspondence remain distinct.” | evidence | validation_scope |
| R0 “The actual routeTrace output is the reusable material interface;” | correspondence | correspondence (unchanged) |
| R1 “it does not record load-bearing mechanical edges.” | correspondence | correspondence (unchanged) |
| N0 “Reuse the completed material interface and connect it to actual attachment and repeated structural formation.” | instruction + another record's scope | dropped as an instruction to reuse the result; the connection to attachment and repeated formation is recurrent-chain-assembly's, which depends on this record, now a related entry (added); next_delta takes the open explanations of L0 as the step |
