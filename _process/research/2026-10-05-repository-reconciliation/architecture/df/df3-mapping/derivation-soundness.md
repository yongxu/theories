# Migration map: derivation-soundness

Old record sha256 `33a9b49367ea626216fa4df0b206565ba620a9010b9902f3709468250013c11b`; snapshot `_process/architecture/history/33a9b49367ea6262/derivation-soundness.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Derivation.lean` (the core module the record binds), with `Becoming.Scope` and `Scope.secures` in `Becoming/Inquiry.lean` for law 6. None states more than the declaration; every condition the Lean takes is kept: the basis holding throughout the domain (`rootHolds`, laws 3 and 4), the premises holding throughout for discharge (`premisesHold`, law 3), the soundness of the policy for its goal (`sound`, law 6). The old record had no statement; the new one says what the home section (08-METHOD, `r-derivation-soundness`) says. The home section's declarations `countermodel_excludes` and `claim_under_itself` were not among the references and are added, with `Derives`, `Holds`, `Throughout`, `relative_throughout`, `discharged_throughout`, `claim_implies_itself` and `claim_not_throughout`, all in the Derivation entry, whose sha256 and binding are unchanged.

| Old text | Type | New place |
|---|---|---|
| T0 “Premise-tracked derivation soundness” | title | title (unchanged) |
| (none) | statement | statement, written from the home section: soundness, the closure holding throughout exactly where the basis does, a local premise not discharged |
| C0 “If Derives basis context p, every interpretation satisfying the entire basis and local context satisfies p.” | law | law 2 (in words: a claim derived under local premises holds at every configuration where every basis claim and every premise holds); the calculus it names is law 1 |
| H0 “The existing finite derivation rules are fixed; basis truth and local assumptions are explicit inputs.” | premise | hypotheses[0] (unchanged); law 1 names the rules |
| R0 “Formal soundness supplies neither actual basis truth nor normative authority.” | correspondence + non-implication | correspondence (unchanged); does_not_show[1] (“Soundness supplies neither the truth of the basis nor any normative authority; the basis and the domain where it holds are supplied.”) |
| L0 “Adding a local premise supports a conditional derivation, not discharge of that premise.” | non-implication | does_not_show[0] (witness `claim_not_closed`); law 5 states the witness; counterexamples[0] (unchanged) |
| V0 “Credits the linked existing Lean receipt.” | evidence | validation_scope (the core receipt binding Becoming.Derivation's current bytes, with empty axiom reports); standard_boundaries: no-ethical-premise (the hypothesis holds no ethical premise; the bound receipt reports an empty axiom list for every cited declaration) |
| V1 “This migration reads source and checks declaration presence and receipt hash binding; it does not rerun Lean.” | bookkeeping (the 8 October migration) | snapshot and history entry 0 (“migrated existing result identity and scope”); the evidence is now the core receipt named in validation_scope |
| N0 “Reuse soundness; a new contribution must explain acquisition or discharge of substantive premises.” | next step | next_delta (stated positively: explain how a basis and the substantive premises are acquired or discharged, reusing soundness) |
| X0 “Adding a local premise supports a conditional derivation, not discharge of that premise.” | counterexample | counterexamples[0] (unchanged, its path the provenance module GenerativeClosure) |

Unchanged: id, kind, status, family, canonical_source, aliases, dependencies, related, the references' paths and sha256 (declarations added to the Derivation entry only), proof_bindings, the earlier history entries. The R35 compaction snapshot `_process/architecture/history/ac670179d1e2a668/derivation-soundness.json`, named in the condensed history note, is the second text_versions entry.
