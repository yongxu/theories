# Research infrastructure

Run commands from the repository root; the Python entry point also works from another directory.

| Command | Purpose |
|---|---|
| `make research-check` | Check all configured records, goal scopes, generated views, preservation hashes and declared proof-receipt bindings. |
| `make research-check-strict` | The same check, and it also fails when a render would change any generated page, directory indexes and the Lean catalogue included (CI runs this; locally a stale index is only reported, so parallel sessions are not blocked). |
| `make research-render` | Render compact navigation and healthy result pages; preserve stale pages and refuse to overwrite concurrent prose. |
| `make research-find QUERY=support` | Search result identity and active sources, excluding frozen copies and development attempts. |
| `make research-test` | Test the infrastructure’s validation, preservation and concurrency behavior. |
| `make research-imports` | Emit working Lean import candidates; ambiguous and external modules remain explicit. |

Focused validation: `python3 -B tools/research/research.py check --ids joint-plan-composition`, or `check --changed-since <commit>`. Directly changed source references select their records and registered downstream consumers. Global metadata remains checked; unrelated freshness failures are reported without blocking the selected records. Exit 1 means structural/rendering failure; exit 2 means selected source drift. A successful metadata check does not establish new proof validity or substantive premise warrant.

To include preserved artifacts in discovery, run `python3 -B tools/research/research.py find support --archives`. The original Lean packages retain their own toolchains and source-bound checks. No universal mathematical build or automatic semantic equivalence claim is added here.

Records come in two schemas, validated side by side ([Writing a record](../../_process/RESULT-WORKFLOW.md#writing-a-record-schema-2)). `style.py` holds the readability lint and the growth ratchet: `check` fails schema-2 records on its hard rules, reports every other finding as a warning without changing the exit status, and with `--changed-since` stops changed schema-1 records from lengthening their boundaries. `python3 -B tools/research/research.py lint [--ids …]` lists the findings; `python3 -B tools/research/research.py snapshot <id>` stores a record's exact bytes before migration and prints its `text_versions` entry. Shared boundary sentences live in the file named by `standard_boundaries` in the configuration.

`atlas.py` validates the [atlas of dynamics](../../theories/becoming/results/atlas/ATLAS.md) and renders it, each entry's standing read from its records ([the workflow](../../_process/RESULT-WORKFLOW.md#the-atlas-aa)).

`registry.py` maintains claim identity, scope, aliases, evidence and typed result dependencies. `navigation.py` derives current overviews from those records and the separate authorization records in `_process/goals/`. Configuration is in [_process/research-config.json](../../_process/research-config.json); record storage can span theory branches without moving active sources. Dates in historical study paths no longer determine where shared tools must live.

The older `build_result_registry.py`, `build_results_catalogue.py`, `build_lean_catalogue.py`, `build_session_result_map.py` and `build_generative_chain.py` paths remain importable command wrappers. Their preserved data and scientific receipts stay at their original locations. The reading catalogue, generativity chain and dated session snapshot retain distinct scopes; use their dedicated tools only when updating the corresponding view. No automatic review-hash refresh occurs.

Original overview bytes and separately labelled link-adapted reading editions are bound by [_process/architecture/history-manifest.json](../../_process/architecture/history-manifest.json). Generated pages retain old heading anchors as links to that history. Do not edit the preservation copies. A renderer refuses to overwrite unincorporated prose in an overview; reconcile the evidence into its existing study/record and preserve it before rerendering.

After reading and integrating a concurrent addition, run `python3 -B tools/research/research.py preserve-view RESEARCH.md --note 'Reviewed additions; integrated in <source/result ID> at <scope>'`, then render. This keeps every earlier snapshot and the new exact bytes. It acknowledges only the reviewed navigation edit; it does not update a proof hash or certify research. Rendering is serialized across cooperating sessions, checks that inputs stayed unchanged, and guards every managed output against unincorporated edits.

Moves to history: `python3 -B tools/research/research.py move --plan PLAN.tsv [--apply] --batch NAME` (dry run unless `--apply`; plans and their rules are in [_process/architecture/moves/plans/](../../_process/architecture/moves/plans/README.md)). It moves bytes unchanged, rewrites live Markdown links, exact multi-component path mentions in live Markdown and path strings in the configured JSON, and writes a receipt to `_process/architecture/moves/`. `--keep-references` moves without rewriting, for a path that receives a new file afterwards. `move --check RECEIPT` verifies an applied batch. Receipts are frozen evidence; tools follow moves through them (`moves.former_paths`, `later_path`, `current_path`), so drift lookup, chain discovery, the reading catalogue and fixed links in generated views keep working. `python3 -B tools/research/research.py evidence {plan,pack,restore,verify} …` runs the checker-run evidence store ([evidence_store.py](evidence_store.py)).

Research content is authored in the existing theory, study and source locations. Current overview pages are generated, so completing a study usually edits one record and its substantive source instead of several competing status summaries. The [contribution workflow](../../_process/RESULT-WORKFLOW.md) defines interpretation, scientific checking and scope obligations.
