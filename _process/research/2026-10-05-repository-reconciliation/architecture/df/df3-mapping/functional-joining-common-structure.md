# Migration map: functional-joining-common-structure

Old record sha256 `05205141b41359bc2d16a28899d4d2b9c47104d960f60d67df2a597ede9c3dbe`; snapshot `_process/architecture/history/05205141b41359bc/functional-joining-common-structure.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence. The old record had no statement.

Each law was read against its declarations: `Joining.Functional`, `Joining.image`, `Used`, `Aligned` (namespace `Becoming`) and `Joining.common_operation` in `Becoming/Joining.lean`; `Joining.Context`, `Joining.Context.Realizes`, `Joining.Context.Possible`, `Joining.ContextSame` and `Joining.ContextSame.iff_sameTests` in `Becoming/JoiningContexts.lean`; `Presentations.Exact`, `Presentations.Reduced` and `Presentations.reduced_exact_kernel` in `Becoming/Presentations.lean`. Every condition the Lean takes is kept: a functional joining and two descriptions whose codes are equal exactly where `SameTests J.frame J.frame` holds, the three hypotheses of `common_operation`, no other (law 2). The old claim's “exact reduced accounts of all joining contexts” is not the hypothesis of one current core theorem: the retired bridge stated it in one theorem (`unique_common_operational_structure_by_core`, kept as a provenance alias), and in the core it is the composition of laws 4 (an exact reduced presentation's kernel is answering alike), 3 (agreeing on contexts is passing the same tests) and 2; the statement takes law 2's form and hypotheses[0] says how the old accounts meet it. The bound receipts report empty axioms for every cited declaration (all core), so `no-ethical-premise` is cited. Added to references: `Joining.Functional`, `Joining.image`, `Used` and `Aligned` (Joining.lean), `Joining.Context`, `Joining.Context.Realizes`, `Joining.Context.Possible` and `Joining.ContextSame` (JoiningContexts.lean), `Presentations.Exact` and `Presentations.Reduced` (Presentations.lean), all in the bound receipts. The record's two identical proof bindings of Joining.lean are kept as they were.

| Old text | Type | New place |
|---|---|---|
| T0 “Common operational structure for functional joining” | title | title (unchanged) |
| — | statement | statement (written from C0 and the home section, in the form of `common_operation`) |
| C0 “When a fixed input pair has at most one result, two exact reduced accounts of all joining contexts carry the same induced partial operation, with a unique same-fragment-aligned correspondence on used codes.” | law | law 2 (“carry the same induced partial operation” read as the Lean has it: each reads a functional joining of codes, aligned one to one on used codes, aligned codes joining alike), with laws 1 (the definitions), 3 and 4 (how exact reduced accounts of contexts give codes equal exactly for fragments passing the same tests); statement |
| L0 “No separate finite-fiber premise” | law | law 2 (“No other premise, no finiteness”) |
| L1 “internal histories are not recovered.” | non-implication | does_not_show[0] |
| L2 “The multivalued extension changes the test scope and neither rewrites this theorem” | scope of another record | related (multivalued-joining-common-structure, whose detail already says the continuation changes the scope and the older result remains); not repeated, since another record's scope is a link, not a boundary |
| L2 (continued) “nor establishes uniqueness of whole worlds.” | non-implication | does_not_show[1] |
| V0 “Listed Lean sources bind by exact hash to successful frozen receipts.” | evidence | validation_scope (the bound core receipts named) |
| V1 “This round checks 223 declarations including 26 new ones.” | evidence (the 8 October periphery receipt) | snapshot; validation_scope says that receipt (explanatory-joining-contexts-checks/) keeps its scope |
| V2 “The older functional theorem credits its previous 166-audit receipt, not a new proof.” | evidence (periphery) | snapshot; the core declarations now cited are bound to their own receipts |
| R0 “Fragments, joining and its questions interpret relations within the same activity” | correspondence | correspondence (unchanged) |
| R1 “mathematical semantics does not establish acquired access to every answer.” | correspondence | correspondence (unchanged) |
| N0 “Reuse finite guarded programs and coherent residual recovery” | instruction | dropped from live fields (an instruction to reuse results); kept in the snapshot |
| N1 “establish warranted residual/guard/formation translation between descriptions with different internal syntax, distinguishing semantic tests from actual acquisition.” | next step | next_delta (the joining study's next step, as in the related records) |
| H0.0 “Functional J” | premise | hypotheses[0] (“A functional joining”) |
| H0.1 “all finite single-hole joining contexts” | premise | hypotheses[0] (unchanged); law 3 |
| H0.2 “Exact and Reduced for both accounts.” | premise | hypotheses[0] (“both descriptions are exact and reduced for them”), with what this gives (codes equal exactly for fragments agreeing on contexts); law 4 |
| X0.0 “No separate finite-fiber premise” | law (repeats L0; no declaration witnesses a case) | law 2; the counterexample entry goes, since it pointed to the study, not to a witnessing declaration |
| X0.1 “internal histories are not recovered.” | non-implication (repeats L1) | does_not_show[0] |
| X0.2 “The multivalued extension changes the test scope and neither rewrites this theorem nor establishes uniqueness of whole worlds.” | repeats L2 | related and does_not_show[1], as L2 |
| — | standard boundary | no-ethical-premise (no ethical premise among the hypotheses; every cited declaration is core with an empty axiom report in its bound receipt) |
