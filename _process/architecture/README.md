<a id="repository-architecture-repair--仓库架构修正"></a>
# Repository architecture repair

8 October 2026. Implementation of [Ren's architecture request](../../sources/15-codex-theory-conversations/2026-10-08-repository-architecture-repair.md). This is a structural repair record, not another scientific result register.

| Problem | Implemented repair |
|---|---|
| Competing current-status summaries | Eleven current overviews are generated from canonical result records and scoped goals. Update the source record, then render. |
| Shared tools buried in a dated study | Shared implementations now live in [tools/research](../../tools/research/README.md). Five older build commands remain importable wrappers. Active studies and experimental packages stay in place. |
| Session objectives mixed into global instructions | [AGENTS.md](../../AGENTS.md) retains permanent method and contribution rules. Nine authorization records generate [GOALS.md](../../GOALS.md); original detailed directives remain preserved. |
| Weak result identity and connection visibility | [RESULTS.md](../../RESULTS.md) reads the individual records; [DEPENDENCIES.md](../../DEPENDENCIES.md) renders typed relationships and explicit producer/output, consumer/input, retained-condition and evidence contracts where recorded. New connections retain their existing proof scope. |
| Frozen copies dominate discovery | `make research-find QUERY=topic` searches canonical claims and active sources. Historical evidence requires `--archives`. `make research-imports` separates textual candidates from unresolved module names. |
| No shared checks or safe rendering | Root Make targets, GitHub Actions, focused drift checks, source-bound receipt validation, local links/anchors, preserved-byte hashes, input-change checks, serialized rendering and per-output overwrite guards are in place. |

## Preservation and reconciliation

[history-manifest.json](history-manifest.json) binds exact previous bytes and separately labelled, link-adapted reading editions. Its `prior_versions` and reconciliation notes preserve additions that arrived during the repair. Original heading anchors remain available through generated historical links. This includes the complete earlier README, RESEARCH, BRIEF, instructions, theory entry point, roadmap, study index, open questions and claim ledger.

One temporary generated result page became orphaned when its concurrent author removed the editable record. The page's original bytes and reading edition remain in the manifest; only the orphan generated page was retired. Its supporting theorem remains in the unchanged scientific source. No proof source, counterexample or scientific receipt was deleted.

[start-state.json](start-state.json) records the starting Git state. [generated-manifest.json](generated-manifest.json) records managed output versions, not scientific approval. To reconcile a later prose addition, read it, integrate its content into the relevant existing source/record, then use the documented `preserve-view` command before rendering.

## Validation and remaining scope

The repair passed the infrastructure tests, complete metadata/navigation check, legacy registry check and invocation from outside the repository. The recorded check results are in [validation.json](validation.json). The exact working-module and textual-import counts at the validation cutoff are recorded with the checks. These are navigation counts, not distinct theorem counts or elaborated Lean dependency proofs.

No Lean source was changed by this repair and no new mathematical claim was introduced. Existing source/receipt bindings were checked; mathematical and empirical work arriving from other sessions retains those sessions' recorded scope. A whole-repository checkpoint preserves incoming work without upgrading its validation status.

Historical semantic migration is not exhaustive. The register explicitly distinguishes migrated coverage from the full corpus; existing reading catalogues and studies retain unmigrated claims. Physical relocation of active workspaces, a universal Lean build, automatic hash refresh and universal semantic equivalence detection are not part of the repair. Future research should migrate the particular result it changes and reuse its existing evidence. New independent authorization remains valid even before its scope record is added.

<a id="directory-renames-9-october-2026--目录改名"></a>
## Directory renames, 9 October 2026

At [Ren's request](../../sources/15-codex-theory-conversations/2026-10-09-pure-core.md#rens-follow-up-finish-the-renames-then-continue-the-theory), two directories were renamed so that their paths name what they hold.

| Former path | Path |
|---|---|
| `theories/shengsheng-buxi-generative-existence/` | [`theories/becoming/`](../../theories/becoming/README.md) |
| `theories/shengsheng-buxi-generative-existence/unified-2026-10-05/` | [`theories/becoming/chapters/`](../../theories/becoming/history/THE-THEORY-OF-BECOMING.md) |

The move changed no file's content. Live references were rewritten by five ordered substitution rules that match only whole path components in path positions. This covers tools, configuration, records, catalogues, studies, experiment documentation and the other theories. In the directive register `sources/15-codex-theory-conversations/`, only Markdown link targets were rewritten, and no line quoting Ren was touched.

Evidence keeps its original bytes and its old paths. This covers imported originals, drafts and exports, reading notes and handoffs, preservation history, and frozen, before/after, retained and verification copies. It also covers receipts and other recorded JSON outputs, and Lean sources. To follow an old path in evidence, use the table above.

[rename-2026-10-09.json](rename-2026-10-09.json) lists every rewritten file with its hash before and after the rename, and every reviewed hash that was carried across. A hash was carried only where the file had matched it before and its new bytes are exactly the substitution of the old. As a result, the records, the reading catalogue, the generativity chain and the session map show the same freshness as before the rename. To verify:

```sh
python3 -B _process/architecture/check_rename.py
```

The checker re-derives each rewritten file from the base commit and compares hashes, and confirms that every carried hash moved from a file's hash before the rename to its hash after it.
