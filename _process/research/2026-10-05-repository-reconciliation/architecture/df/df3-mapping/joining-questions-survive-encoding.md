# Migration map: joining-questions-survive-encoding

Old record sha256 `6e40ccc4dd156fc510eeb68e5900f74d69dc828faee4bda37d7e0301dff9b297`; snapshot `_process/architecture/history/6e40ccc4dd156fc5/joining-questions-survive-encoding.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations: `Joining`, `Joining.image`, `Joining.Lifts`, `Joining.frame`, `Joining.lifts_iff`, `Joining.mapPartners`, `Joining.holds_image_iff` and `Joining.FiniteOutcomes` in `Becoming/Joining.lean`; `Joining.FiniteOutcomes.lifts_of_exact` in `Becoming/JoiningCodes.lean` (with `Exact` and `Reduced` of `Becoming/Presentations.lean` and `BranchingTest` of `Becoming/Likeness.lean`, written out in words). Every condition the Lean takes is kept: lifting, and only lifting, for the surviving tests (law 3, `holds_image_iff` takes `lifts : J.Lifts π` and nothing else); no premise for the characterization of lifting (law 2, an iff proved both ways); excluded middle as the named hypothesis `em`, listed outcomes of each pair (`FiniteOutcomes`), exactness and reduction for the lifting from a presentation (law 4). The tests have no atomic claims: their claim type is `Empty`. The bound core receipts report empty axioms for every cited declaration, and the hypotheses hold no ethical premise, so `no-ethical-premise` is cited. The added declarations are all in `Joining.lean`, already referenced and bound (`becoming-checks/20261020T051144.879480Z` binds its current bytes, as does the newest receipt `20261028T085101.429997Z`, which `binding_for.py` reports).

The old record had no statement; the new one says what the claim and the home section (03-KNOWING, `r-joining-questions-survive-encoding`) say, with the lifting from a presentation added as the Lean has it.

| Old text | Type | New place |
|---|---|---|
| T0 “Joining questions remain exact under the same encoding” | title | title (unchanged) |
| (none) | statement | statement, written from C0 and the home section |
| C0 “After encoding every joining partner in a question through the same account, interpreting the translated question in the induced multivalued joining relation gives exactly the original answer.” | law | law 3 (`holds_image_iff`: the test with its partners read through the description, `mapPartners`, holds at the code in the joining read through the description, `image`, exactly where it holds at the fragment), with “through the same account” read as a description that lifts the joining; laws 1 and 2 define the joining read through a description, lifting and the frame; law 4 gives the lifting from an exact presentation. “Account” is not kept: the Lean's object is a description `π : F → K` |
| H0 “One partial joining relation J;” | premise | hypotheses[0] (“which may relate a pair to several outcomes, to one or to none”, the docstring of `Joining`) |
| H1 “each input pair has a finite outcome set.” | premise | hypotheses[2] and law 4: the current Lean uses finiteness (`FiniteOutcomes`, outcomes listed) only for the lifting from a presentation; the surviving tests need only lifting (law 3) |
| H2 “The target contains all finite negation, conjunction and left/right joining-successor questions, with no independent atomic predicates.” | premise | hypotheses[1]; law 3 (truth, negation, conjunction, joining a named partner on the left or right; no atomic claims, the claim type `Empty`) |
| H3 “Exact supplies complete truthful answers;” | premise | hypotheses[2] (“exact: its codes read every test's answer”); law 4 |
| H4 “Reduced is used for minimal codes and lifting output codes.” | premise | hypotheses[2] (“reduced: fragments answering alike get one code”); law 4, where exactness and reduction together give the lifting (`reduced_exact_kernel`) |
| — | added premise | hypotheses[2]: excluded middle as the named hypothesis `em : ∀ p : Prop, Decided p`, which `FiniteOutcomes.lifts_of_exact` takes; history entry 3 (14 October, I3) recorded that the spine form names it |
| R0 “Fragments, joining and its questions interpret relations within the same activity;” | correspondence | correspondence (unchanged) |
| R1 “mathematical semantics does not establish acquired access to every answer.” | correspondence | correspondence (unchanged); also in does_not_show[0] (“nor access to every answer”) |
| X0 “Covers semantics of finite negation, conjunction and continuation;” | counterexample (no declaration witnesses it) | does_not_show[0] (non-implication); the counterexample entry is removed: it repeated the limitation and no declaration witnesses it |
| X1 “it does not establish apparatus formation, actual negative evidence or acquired access to all questions.” | counterexample (no declaration witnesses it) | does_not_show[0] |
| L0 “Covers semantics of finite negation, conjunction and continuation;” | non-implication | does_not_show[0] (the same sentence as X0) |
| L1 “it does not establish apparatus formation, actual negative evidence or acquired access to all questions.” | non-implication | does_not_show[0] (the same sentence as X1) |
| V0 “Listed Lean sources bind by exact hash to successful frozen receipts.” | evidence | validation_scope (the core receipts named by location, the checker check_becoming.py, Lean 4.29.1 as the receipts record it, the empty axiom reports) |
| V1 “This round checks 223 declarations including 26 new ones.” | evidence (bookkeeping of the 8 October round) | snapshot; history entry 0 records that round |
| V2 “The older functional theorem credits its previous 166-audit receipt, not a new proof.” | evidence (bookkeeping) | snapshot; validation_scope says the periphery module and its receipt under explanatory-joining-branches-checks keep their earlier scope |
| N0 “Reuse finite guarded programs and coherent residual recovery;” | next step (an instruction to reuse results) | dropped from next_delta: reusing completed results is not a next step, and those results are the related records guarded-program-question-recovery and residual-continuation-correspondence, which stay in `related` |
| N1 “establish warranted residual/guard/formation translation between descriptions with different internal syntax, distinguishing semantic tests from actual acquisition.” | next step | next_delta (stated positively) |
| — | standard boundary | standard_boundaries: no-ethical-premise (no ethical premise in the hypotheses; empty axiom reports for every cited declaration in the bound receipts) |

The home section and the Lean agree; one chapter edit was made in review: the home section's “one account” became “one description”, the word the record uses.
