# Migration map: finite-joining-tree-lifting

Old record sha256 `8409d21f98c83e3b6f72c1077d3fd5c3996c13b791fc6f36f5b18dd94c4065a9`; snapshot `_process/architecture/history/8409d21f98c83e3b/finite-joining-tree-lifting.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Joining.lean` (`frame`, `image`, `Lifts`, `lifts_iff`, `image_iff`, `lifts_of_identifiesAlike`, `lifts_iff_sameBranchingTests`, `FiniteOutcomes`, `Tree`, `Tree.map`, `Tree.Realizes`, `tree_lifts`) and `Becoming/JoiningCodes.lean` (`FiniteOutcomes.lifts_of_exact`), at the bytes bound by the record's proof bindings. Every condition is kept: no premise for `lifts_iff` (law 1); a lifting description for `image_iff` and `tree_lifts` (laws 2 and 3); the kernel condition of `lifts_iff_sameBranchingTests`, having one code exactly where passing the same branching tests (law 4); excluded middle as the named hypothesis `em`, `FiniteOutcomes`, and an `Exact` and `Reduced` presentation of the frame's branching tests for `FiniteOutcomes.lifts_of_exact` (law 5, with hypotheses[0] naming the tests). `lifts_of_identifiesAlike`, already in the references, is now stated (law 2); `Joining.frame` was added to the references, law 1 naming the frame whose moves join a partner on either side. The record's proof bindings list the Joining.lean binding twice; the entries are identical and are kept as they were.

| Old text | Type | New place |
|---|---|---|
| T0 "Finite joining trees lift from specified fragments" | title | title (unchanged) |
| S0–S1 | statement | statement (unchanged) |
| C0 "Read through a description, codes join where fragments with those codes join into one with that code." | definition | law 1 |
| C1–C2 "The description lifts the joining, every joining of the codes of two fragments coming from a joining of the fragments themselves, exactly where having one code is a bisimulation of the joining's frame; no premise." | law | law 1 (the frame's moves written in) |
| C3a "Where it lifts, a joining of codes is exactly the code of a joining of any fragments having them," | law | law 2 |
| C3b "and every finite binary tree of joinings lifts: the tree with its leaves read through the description joins into a code exactly where the tree with its own leaves joins into a fragment with that code;" | law | law 3 |
| C4 "the leaves stay the given fragments." | law | law 3 |
| C5 "Where codes are passing the same branching tests, the description lifts the joining exactly where passing the same branching tests is a bisimulation of its frame;" | law | law 4 |
| C6 "with excluded middle as a hypothesis, where each pair joins into listed fragments, a presentation reading the branching tests exactly and reducedly lifts the joining." | law | law 5 ("reducedly" written out: giving fragments passing the same tests one code, as `Reduced` defines) |
| — (no old sentence) | law | law 2, second part: `lifts_of_identifiesAlike`, cited in the references and not stated before |
| L0a "Tree-shaped relational realization does not … cover shared nodes, cycles, infinite completion" | scope | does_not_show[0] (witness `Joining.Tree`) |
| L0b "does not authorize resource copying … or actual scheduling." | non-implication | does_not_show[1] ("does not show that a resource can be copied", a structural wording of "authorize") |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; excluded middle is a named hypothesis, not an axiom, and the bound receipts report empty axioms for every cited declaration) |
| V0 "Listed Lean sources bind by exact hash to successful frozen receipts." | evidence | validation_scope (the bound core receipts) |
| V1 "This round checks 223 declarations including 26 new ones." | evidence (counts, round narration) | receipt + snapshot (the count belongs to the periphery's earlier receipt, deeper/explanatory-joining-branches-checks/20261008T130611.816353Z) |
| V2 "The older functional theorem credits its previous 166-audit receipt, not a new proof." | evidence | receipt + snapshot (the functional theorem is the periphery's; the record cites it only as provenance) |
| R0–R1 | correspondence | correspondence (unchanged) |
| N0–N1 | next step | next_delta (unchanged) |
| H0.0–H0.1 | premise | hypotheses[0] (unchanged) |
| X0 | counterexample | counterexamples[0] (unchanged; its text repeats the old limitation, now does_not_show[0]–[1]) |
