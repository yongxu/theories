# Migration map: assured-route-criterion

Old record sha256 `7a1cea4e295c72940088816563e39998dd08339a475c560b0b2ba0567f3408a5`; snapshot `_process/architecture/history/7a1cea4e295c7294/assured-route-criterion.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Assurance.lean` (completion and runs, `Branch`), `Becoming/Laws.lean` (`Determined`, laws of change and partial laws) and `Becoming/AssurancePlans.lean` (`Routes`, `Regulation`). Every condition the Lean takes is kept: determinacy for `completes_of_runs`, `completes_iff_of_determined` and `completes_iff_runs` (laws 2, 3); no safety condition (`free`) for `completes_iff_runs`, `completes_ofMap_iff`, `completes_ofPartial_iff` and `Routes.completes_iff` (laws 3, 5–7); an unreached starting configuration for the routes (law 7); a count in the band for `Regulation.kept_along` (law 8). Ten declarations the laws name were not among the references and are added to the entries of their files (Laws: `Determined`, `Assurance.ofPartial_determined`; Assurance: `Branch.process`; AssurancePlans: `Routes.advance`, `Routes.process`, `Routes.Reached`, `Regulation.update`, `Regulation.process`, `Regulation.Band`, `Regulation.respond`); every file's sha256 and binding is unchanged, and the bound receipts report an empty axiom list for every cited declaration.

The old record had no statement; the new one says what the home section (07-SIGNIFICANCE, `r-assured-route-criterion`) says.

| Old text | Type | New place |
|---|---|---|
| T0 “Assured arrival in the three-route process” | title | title (unchanged) |
| (none) | statement | statement, written from the home section |
| C0 “For every determined process (…), a plan completes — … — exactly when it runs, its run is safe and its endpoint meets the goal;” | law | laws 1 (`runs_of_completes`, every process) and 2 (`completes_of_runs`, `completes_iff_of_determined`); statement |
| C1 “with no safety condition, exactly when it runs and every endpoint meets the goal.” | law | law 3 (`free`, `completes_iff_runs`) |
| C2 “For a law of change, a plan completes exactly when the goal holds where the law takes it, and for one move exactly when it holds at the successor.” | law | law 5 (`ofMap`, `ofMap_determined`, `completes_ofMap_iff`, `completes_ofMap_single`), with no safety condition as the Lean has it |
| C3 “A partial law's traces are exactly its completed runs.” | law | law 6 (`trace_ofPartial_iff`, with `completes_ofPartial_iff`) |
| C4 “The converse fails for nondeterministic processes.” | law (witness) | law 4 (`Branch.runs_not_completes`, `Branch.not_determined`); counterexamples[0] |
| C5 “Contextual wisdom's assurance is completion with no safety condition.” | provenance | history: the identification was proved only by the retired bridge `Becoming.Instances.assured_iff_completes` (`lean/history/`, a provenance reference, its alias marked retired); the core the record cites states completion with no safety condition (law 3) and no theorem about the older predicate, so no law states it |
| C6 “The three-route process is a law of change, so taking route a from an unreached state assures arrival exactly when a differs from the uniquely blocked mode m: an instance.” | law | law 7 (`Routes.advance`, `Routes.process`, `Routes.Reached`, `Routes.completes_iff`), “assures arrival” stated as completing into arrival |
| (new) law 8 | law | `Regulation.kept_along`, already among the references, stated with its definitions (the regulation law, the second instance named in the 14 October history note) |
| H0, H1 | premise | hypotheses[0], [1] (unchanged) |
| L0 “Risk weights, capacity to acquire the mode, and ethical grounds for selection are not supplied by this equivalence.” | non-implication | does_not_show[0] |
| V0 “Credits the linked existing Lean receipt.” | evidence | validation_scope (the core receipts in becoming-checks binding the three modules, and the original theorem's receipt) |
| V1 “This migration reads source and checks declaration presence and receipt hash binding;” | evidence (bookkeeping) | snapshot (it described the 8 October migration) |
| V2 “it does not rerun Lean.” | evidence (bookkeeping) | snapshot |
| R0 | correspondence | correspondence (unchanged) |
| N0 “Risk applications reuse this completion criterion for every determined process;” | instruction | snapshot (an instruction to reuse); next_delta names what risk applications need (risk weights, the reading of the mode) |
| N1 “nondeterministic plans need the full completion condition.” | next step | next_delta (“A criterion for nondeterministic processes between running safely into the goal and completing, …”) |
| X0 “Risk weights, capacity to acquire the mode, and ethical grounds for selection are not supplied by this equivalence.” | boundary (repeats L0; no declaration witnesses it) | removed; does_not_show[0] carries it |
| X1 “The two-outcome process Branch: …” | counterexample | counterexamples[0] (unchanged); law 4 |

Standard boundaries: no-ethical-premise (the hypotheses are determinacy and the routes' construction, and the bound receipts report empty axiom lists for every cited declaration) and discrete-steps (plans are lists of moves). Unchanged: id, kind, status, family, canonical_source, aliases, dependencies, related, correspondence, the references' paths and sha256 (declarations added only), proof_bindings, the earlier history entries. The R35 compaction snapshot `_process/architecture/history/026b536b113ea820/assured-route-criterion.json`, named in the condensed history note, is the second text_versions entry.
