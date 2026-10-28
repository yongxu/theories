# Migration map: derived-history-law-exactness

Old record sha256 `48e5348ed1d2f150345190376341678cfd1bab6b1c6c82d49a6d2b00426e2c60`; snapshot `_process/architecture/history/48e5348ed1d2f150/derived-history-law-exactness.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Mechanism.lean` (`Image`), `Becoming/Readout.lean` (`SameFutures`, `image_feasible`, `feasible_of_image`, `futures_through_iff`), `Becoming/HistoryLanguages.lean` (`PrefixClosed`, `law`, `trace_iff`) and `Becoming/SummaryFutures.lean`, at the bytes bound by the record's proof bindings. Every condition is kept: `futures_through_iff` quantifies every configuration and is an equivalence (law 2); `feasible_of_image` needs the condition on merged configurations (law 2, "under that condition"); `trace_iff` needs the language prefix-closed and the starting history admitted (law 3). The admitted-history form (law 4) is `futures_through_iff` with the admitted histories as configurations, the law restricted to them, and `trace_iff`: no single core declaration states it, and law 4 says so, as the old claim did ("not one declaration"); the periphery's `Generative.DerivedHistoryLaw.exact_iff_fiber_future` proved it on its own definitions (validation_scope). `every_word` says every word can be taken (law 5, "can take"). No declaration was added to the references.

| Old text | Type | New place |
|---|---|---|
| T0 "Exactness of a local law derived from history summaries" | title | title (unchanged) |
| S0–S1 | statement | statement (unchanged) |
| C0 "The law read through a summary takes a step from one summary value to another where some configuration with the first takes it to one with the second." | definition | law 1 (with `image_feasible`: every word a configuration can take, the read law can take from its summary) |
| C1 "From the value of each configuration it takes exactly the words the configuration can take, for every configuration, exactly when the configurations the summary merges can take the same words: the nondeterministic counterpart of a determined law carried through a reduction." | law | law 2 ("for laws that need not be determined" for "nondeterministic"; `feasible_of_image` written in) |
| C2 "For histories, the law extending an admitted history by one move takes, from an admitted history of a prefix-closed language, exactly the courses whose extension is admitted;" | law | law 3 ("each ending at that extension", as `trace_iff` states) |
| C3a "with the admitted histories as the configurations, the law derived from a summary keeps every finite continuation at every admitted history exactly where admitted histories sharing a code admit the same continuations" | law (instance) | law 4 (with "For a prefix-closed language", the condition C2 states and `trace_iff` takes) |
| C3b "(proved on the periphery's own definitions;" | evidence | validation_scope ("proved the admitted-history form on its own definitions") |
| C3c "in the core an instance of the first of the record's laws, not one declaration)." | law (scope) | law 4 ("the law of futures above"; "This instance is stated by no single core declaration") |
| C4–C5 "Carrying the futures is not carrying the endpoints: …" | law (witness) | law 5 ("can take every word", as `every_word` is feasibility); counterexamples[0] (unchanged) |
| L0 "Finite existential word feasibility only: no endpoint, branch-identity, probability or policy guarantee." | non-implication | does_not_show[0] (witness `SummaryFutures.endpoint_moved`) |
| L1 "An empty L permits vacuous validity without occurrence;" | scope | does_not_show[1] |
| L2 "the universal assumption-free foundation remains unproved." | standard boundary | standard_boundaries: zero-axiom-target-open |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; the bound receipts report empty axioms for every cited declaration) |
| V0 "Actually compiled with Lean 4.29.1: 6 new theorems and 5 definitions, 11 new empty audits plus 43 inherited empty audits." | evidence (counts) | validation_scope ("with empty audits"); the counts stay in the periphery receipt (deeper/derived-history-law-checks/20261008T181617.432149Z) and the snapshot |
| V1–V2 "The first control-summary compilation introduced propext; explicit constructor cases removed it, with the failed record retained." | evidence | validation_scope |
| V3 "Author counterreview, no independent acceptance." | evidence | validation_scope ("Author counterreview; no independent review") |
| — | evidence | validation_scope: the core modules and their receipt directory, which the old paragraph (written for the periphery module) did not name |
| R0–R2 | correspondence | correspondence (unchanged). R2's "nor proves that every process has this finite-word representation" is true of this record's construction, but `HistoryLanguages.realizes_feasible` proves that every process's feasible words are realized by the law of its histories; the clause is corrected to "Construction does not create actual possibilities; every process's feasible words are realized by the law of its histories, but that representation keeps the words, not the endpoints or branches", with `realizes_feasible` added to the HistoryLanguages.lean reference |
| N0 "Establish deductive warrant for the universal operative relationship and its actual interpretation;" | next step | next_delta |
| N1 "do not require every particular history language to be necessary or substitute another equivalent encoding for that warrant." | next step + instruction | next_delta ("the warrant is for that relationship, not for the necessity of each particular history language"); "or substitute another equivalent encoding" is an instruction to later sessions and stays in the snapshot |
| H0.0–H0.2 | premise | hypotheses[0] (unchanged) |
| H1.0 | premise | hypotheses[1] (unchanged) |
| H1.1 "exactness from only one initial value is a different contract." | premise | hypotheses[1] ("a different condition": "contract" is not a structural word; the Chinese already said 条件) |
| X0–X1 | counterexamples | counterexamples[0]–[1] (unchanged) |
