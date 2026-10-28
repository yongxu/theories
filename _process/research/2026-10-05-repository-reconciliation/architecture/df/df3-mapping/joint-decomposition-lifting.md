# Migration map: joint-decomposition-lifting

Old record sha256 `5f20a3815242fd719b28794ce02539e58b2a24950851d81739d43a855915ecd5`; snapshot `_process/architecture/history/5f20a3815242fd71/joint-decomposition-lifting.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Composition.lean` (the section "Reading the parts through a description", `JointAlike`, `SameJointTests`, `JointFrame.JointCompact`, `JointFrame.TestsStable`, `TestsStable.of_em`, `matchesParts_of_compact_iff_em`), `Becoming/JointCorrespondence.lean` (`liftsFromEach_of_exact`, `matchesParts_of_exact`) and `Becoming/Likeness.lean` (`MatchesParts`), at the bytes bound by the record's proof bindings. Every condition is kept: no premise for `liftsFromEach_iff`, `liftsFromEach_iff_of_kernel` and `IdentifiesJointAlike.lifts`; `JointCompact` and `TestsStable` for `liftsFromEach_of_sameJointTests` (law 3) and, with `Exact` and `Reduced`, for the code forms (law 4); `matchesParts_of_compact_iff_em` quantifies joint frames on configurations of any type in `Type` with moves and claims in `Unit` (law 5, "with one move and one claim"). `MatchesParts`, which the claim used in words and which the record's schema-1 form could not name in a law, was added with a new reference to `Likeness.lean`, its receipt `becoming-checks/20261027T195912.152773Z` (the newest passing receipt binding the file's current bytes, empty axiom report) and a proof binding; `JointAlike` and `SameJointTests` were added to the Composition.lean reference.

| Old text | Type | New place |
|---|---|---|
| T0 "Lifting a joint decomposition from a whole code" | title | title (unchanged) |
| S0–S1 | statement | statement (unchanged) |
| C0 "A description reads the joint relation among descriptions where some configuration so described holds together parts so described." | definition | law 1 |
| C1 "The parts it reads at a description lift from every configuration it describes, with parts it describes alike, exactly where configurations it identifies match parts into configurations it identifies;" | law | law 1 (`LiftsFromEach` written out) and law 2 (`MatchesParts` written out; `liftsFromEach_iff`) |
| C2 "where it identifies exactly the configurations some relation relates, exactly where that relation matches parts." | law | law 2 (`liftsFromEach_iff_of_kernel`) |
| C3 "No premise." | condition | law 2 ("no premise"); hypotheses[0] |
| C4 "So the parts lift through a description identifying exactly the jointly alike configurations, with no premise;" | law | law 3 |
| C5 "through one identifying exactly the configurations passing the same joint tests, where the pairs of parts are compact and the tests stable;" | law | law 3 (both conditions written out, as hypotheses[0] defines them) |
| C6 "and through a code reading the joint tests exactly and giving configurations passing the same tests one code, under the same two conditions, configurations given one code then matching parts." | law | law 4 |
| C7 "Stability is what excluded middle would give: excluded middle makes every joint test stable, and that passing the same joint tests matches parts in every frame whose pairs of parts are compact holds exactly under excluded middle." | law | law 5 (the frames' one move and one claim written in) |
| L0 "Lifting provides some parts, not arbitrary substitution of designated parts or duplication of support." | non-implication | does_not_show[0] (witness `LiftsFromEach`) |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; excluded middle appears in statements, never as an axiom, and the bound receipts report empty axioms for every cited declaration) |
| V0–V2 "Credits the linked existing Lean receipt. This migration reads source and checks declaration presence and receipt hash binding; it does not rerun Lean." | evidence (superseded) | validation_scope (the bound core receipts); the 8 October migration it described is history entry 0, and the sentence stays in the snapshot |
| R0–R1 | correspondence | correspondence (unchanged) |
| N0 | next step | next_delta (unchanged) |
| H0.0–H0.2 | premise | hypotheses[0] (unchanged) |
| X0 | counterexample | counterexamples[0] (unchanged; its text repeats the old limitation, now does_not_show[0]) |

The cold read removed the counterexample, which no declaration witnesses and which does_not_show[0] (witness `LiftsFromEach`) already carry: X0 goes to those items.
