# Migration map: binding-preserving-substitution

Old record sha256 `b9f306f90c0e2e47936f7878c46e08c6222aa1eafc97e41716b6b0f143f97292`; snapshot `_process/architecture/history/b9f306f90c0e2e47/binding-preserving-substitution.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations: `Readout.ThroughParts`, `Readout.ReadsDirectly`, `Readout.agree_iff_parts` and `Readout.supplied_agree_iff_parts` in `Becoming/Readout.lean` (core; laws 1 and 2); `extract_substitute`, `extract_rename`, `all_terms_agree_iff_positions`, `discharge_matches_supply`, `discharge_preserves_assessment`, `successive_substitution`, `nested_substitution_retains_outer`, `typed_capture_changes_answer` and `matching_values_hide_capture` in `deeper/InferentialSubstitution.lean`, with `extract` and `application_after_abstraction` of `deeper/InferentialGrounds.lean` (periphery; laws 3 to 7); `part`, `read`, `use`, `through`, `direct`, `supplied`, `supplies` and `all_terms_agree_iff_positions_by_core` in `deeper/SubstitutionCorrespondence.lean` (periphery bridge; law 4). Every condition the Lean takes is kept: reading only through parts and each part read directly, for both core laws, and the supply condition for the replacement form; the assignments of grounds to both contexts and the position condition (an iff proved both ways) for the language criterion; the criterion and the supplied input for the preserved assessment. Every declaration a law names was already in the record's references; none is added. Axioms as the bound receipts report them: the cited core declarations none (`becoming-checks/20261019T185632.962707Z` for Readout); six of InferentialSubstitution's nine `Quot.sound` only, the rest and InferentialGrounds' none (`inferential-substitution-checks/20261008T181823.552825Z`); `through`, `supplies` and `all_terms_agree_iff_positions_by_core` `Quot.sound`, the rest none (`substitution-correspondence-checks/20261020T161957.579185Z`, Lean 4.30.0-rc2). So `no-ethical-premise-core-axiom-free` is cited, not `no-ethical-premise`. `Courses.lean` keeps its reference and binding without declarations: the laws its history entry of 16 October named were folded into Readout's under one name by R29.

The old record had no statement; the new one says what the claim and the home section (03-KNOWING, `r-binding-preserving-substitution`) say.

| Old text | Type | New place |
|---|---|---|
| T0 “Binding-preserving substitution and its exact position criterion” | title | title (unchanged) |
| (none) | statement | statement, written from C0–C1 and the home section |
| C0 “For the supplied finite typed-term language, substitution and context assignments, every consumer evaluates equally before and after replacement iff each replacement term supplies the ground at its original position.” | law | law 4 (`all_terms_agree_iff_positions`, and by the core law `all_terms_agree_iff_positions_by_core`); laws 1 and 2 state the core criterion it instantiates (home section); law 3 the substitution lemma it rests on |
| C1 “Constructed substitution retains positions under nested binders;” | law | law 3 (the substitution lemma holds under binders, `extract_substitute` by induction through `abstract`) and law 6 (the witness `nested_substitution_retains_outer`) |
| C2 “single insertion and successive substitution satisfy the corresponding semantic equations.” | law | law 5 (`discharge_matches_supply`, as `application_after_abstraction` evaluates an applied abstraction; `discharge_preserves_assessment`; `successive_substitution`) |
| H0 “Uses existing InferentialGrounds finite terms, types and evaluation, with the same atomic carrier family and stable binding positions;” | premise | hypotheses[0] |
| H1 “no mutable state, divergence or physical cost.” | premise | hypotheses[0], “physical cost” rewritten “physical resources” (no word of exchange; the record's subject is not an exchange) |
| H2 “The all-consumer scope includes direct use of every position.” | premise | hypotheses[1] (unchanged) |
| H3 “Assessment preservation additionally requires a hypothetical guarantee and an actual producer satisfying its input criterion;” | premise | hypotheses[1] (reworded: “Preserving an assessment also needs …”); law 5 states the theorem with both premises |
| H4 “substitution does not prove either premise.” | premise | hypotheses[1] |
| — | added premise | hypotheses[2]: function extensionality through `Quot.sound`, which the periphery uses for evaluation reading only through positions (`SubstitutionCorrespondence.through`) and in six substitution lemmas, as the receipts report |
| R0 “Introduction, position, use and substitution are analytical roles within one derivation.” | correspondence | correspondence (unchanged) |
| R1 “The equations preserve the selected denotation;” | correspondence | correspondence (unchanged) |
| R2 “actual reference, full content and source-history correspondence remain obligations.” | correspondence | correspondence (unchanged) |
| X0 “A same-type capture of an inner position can change the answer;” | counterexample | counterexamples[0] (kept; witnessed by `typed_capture_changes_answer`); law 7 |
| X1 “equal current values can conceal the capture.” | counterexample | counterexamples[0] (kept; witnessed by `matching_values_hide_capture`); law 7 |
| X2 “The all-consumer condition is not necessary for an individual consumer that ignores that position.” | converse (no declaration witnesses it) | does_not_show[0] (converse): for one consumer the criterion is shown sufficient (`extract_substitute`), not necessary; the docstring of `all_terms_agree_iff_positions` says a single consumer may ignore a position, and no declaration builds such a consumer, so it is no counterexample |
| L0 “The language and interpretation of binding remain supplied;” | scope | does_not_show[1] (“the language, its typing and the interpretation of binding are supplied”) |
| L1 “presuppositionless grounding of metalogic is unfinished.” | scope | does_not_show[1] (“the result gives no presuppositionless grounding of the logic it uses”; “unfinished” restated the status and is not kept) |
| L2 “Denotational equality alone does not establish identity of reference, content or history.” | non-implication | does_not_show[2] |
| L3 “No physical double execution, cost preservation or uniqueness of this calculus for all reasoning is proved.” | non-implication | does_not_show[3], “cost preservation” rewritten “preservation of resources”, the docstring of `successive_substitution` (“does not assert syntactic equality or a resource-preserving double execution”) added: successive substitution is equal in evaluation, not syntactically |
| V0 “Actual Lean 4.29.1 compilation: 9 new theorems plus 10 inherited declaration audits, 19 total: 13 empty and 6 only Quot.sound through function extensionality.” | evidence | validation_scope (the 13 of 19 and 6 Quot.sound of inferential-substitution-checks, with its checker and Lean version; the core and bridge receipts added) |
| V1 “No custom axioms, proof holes, warnings or classical choice.” | evidence | validation_scope, which names the axioms each receipt reports (none beyond Quot.sound) |
| V2 “Author counterreview and primary-method comparison;” | evidence | validation_scope (“Author counter-review only”); the primary-method comparison is in the integration study the references name |
| V3 “no independent acceptance or new empirical experiment.” | evidence | validation_scope (“Author counter-review only”); the result is a theorem, so no experiment is in question |
| N0 “The strict target still lacks the passage from local reference constitution to adequate warrant for the metainferential resources used here;” | next step | next_delta, stated positively (the passage itself); “still lacks” restated the status and is not kept |
| N1 “repeating substitution or equating intelligible challenge with acceptance of the entire logic does not supply it.” | next step | next_delta (“without repeating the substitution theorem or reading an intelligible challenge as acceptance of the whole logic”) |
| — | standard boundary | standard_boundaries: no-ethical-premise-core-axiom-free |

**Chapter edit (proposed, not made).** The home section's standing says “`Quot.sound` in six declarations, as the record reports”. The record now reports, for the cited periphery declarations, six in InferentialSubstitution and three in SubstitutionCorrespondence (`through`, `supplies`, `all_terms_agree_iff_positions_by_core`), nine in all. In 03-KNOWING.md, `r-binding-preserving-substitution`:

- old: “(periphery; a supplied finite typed-term language; \`Quot.sound\` in six declarations, as the record reports)”
- new: “(periphery; a supplied finite typed-term language; \`Quot.sound\` in nine of the cited declarations, as the receipts report)”

(The backticks around Quot.sound are the chapter's own.)

DF1's triage row 130 (regions.json base `general` → `periphery` for this record) is not a record change; regions.json already has base `periphery` for this record.
