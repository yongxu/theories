<!-- AI-written: one of four read-only readers, 4 November 2026, for GT's design (GATE.md). Read against main 1e9bc6b85; not checked line by line. -->
# What each research check reads

## The research check's inputs, and what a tiered landing gate can skip

### Summary for the gate design

1. **Most of the cost is not narrowed by any existing option.**
   - `registry.validate` re-hashes about 1.22 GB of reference files and parses about 533 MB of receipt JSON on every check (registry.py:989-1030). `input_snapshot` hashes the same 1.22 GB another two times in check and three times in render (research.py:258, 292, 320).
   - `--ids` and `--changed-since` narrow only the record-page comparison (research.py:263, 280). Every validation and every other family still runs over everything (research.py:259-275).
   - The biggest saving that stays sound is a content-addressed cache (blob id to sha256, receipt facts by blob), not skipping families.
2. **The check is a function of the tree only under conditions.**
   - The checkout must be clean: no untracked files and no ignored files (inventories, globs, `iterdir` and `rg --no-ignore`).
   - HEAD's history is consulted whenever an `.md` reference has drifted.
   - The Python version enters through `unicodedata` and `difflib`.
   - Trains must run on a fresh worktree of the merged commit, take tiers from `git diff base merged`, and render-and-commit before the strict check.
3. **Family skipping is sound only with the triggers listed under "Skipping and caching" below.** Record pages can be cheaply recomputed for all records instead of trusting `affected_ids`, which is unsound for removals.
4. **There is no machine-wide lock today.**
   - `render_lock` resolves to the worktree's own git dir (`/Users/ren/theories/.git/worktrees/gc-reading-correction/research-navigation.lock`, research.py:25). It is non-blocking (28), so it fails instead of waiting.
   - check takes no lock (research.py:459-460).
   - A shared lock belongs under `git rev-parse --git-common-dir` or a home-directory cache.

### State of the checkout read

- HEAD `3bf962941` is `1e9bc6b85` plus one board commit; `tools/` is identical to `1e9bc6b85`.
- The working tree holds edits I did not make, all uncommitted:
  - `tools/research/registry.py` adds `DRIFT_CACHE` (a cache of drift comparisons under `~/.cache`, keyed by both texts' sha256 and the Python version).
  - `tools/research/completion.py` rewrites `_strip_comments`.
  - `tools/research/tests/test_scoped_drift.py` is changed.
  - `sources/15-codex-theory-conversations/2026-11-04-checks-and-order.md` is untracked.
- All line numbers below are HEAD's.
- Nothing was run except `git` reads and read-only Python counts over records and receipts.

### How `check_or_render` runs (research.py:253-339)

1. A snapshot of the inputs is taken (258).
2. Records are loaded (259) and validated (260): orphan pages, goals and history (261).
3. If there are errors, it stops early (265-266).
4. The generated families are computed:
   - navigation (267)
   - completion (270-272)
   - theory graph (274)
   - indexes and the reading catalogue (275); the Lean catalogue only when `render or strict_fresh` (241-250)
   - record pages for selected ids without drift (279-282)
5. Links in all outputs are checked (284-285).
6. Render writes everything through the guarded writer (286-295), then runs the Lean catalogue a second time to reach a fixed point (299-303).
7. Check compares the outputs:
   - Index and reading-catalogue pages are only reported as stale (307-308).
   - Under `--strict-fresh`, stale index pages are errors (311-313).
   - Every other page is a hard error when it differs (310).
8. Lint runs (316). The ratchet runs only with a base and only in check (317).
9. The snapshot is checked again (320). The shared-laws status is reported (335).
10. Exit codes: 1 for errors, 2 for drift in selected records (339).

`session_map` is imported (research.py:19) but never called. The config note (`indexes.note`) saying it renders through `research.py render` is not borne out by the code.

The output families and validations, with every input and its line, are in the `outputs` field.

### What `input_snapshot` covers, and what it misses

**Covered** (research.py:37-56):
- the config and the history manifest
- `shared-laws.json` and `law-families.json`
- the four `readme_*` files and the timed files
- the standard boundaries file
- `goals/*.json`
- record JSONs and their reference paths

It also adds a bogus `ROOT/PATH`, because the `{{time:PATH}}` example in the comment at README-FIRST-SCREEN.md:1 matches the field pattern. This is harmless.

**Missed** (all read):
- the generated manifest's keys
- move receipts (`_process/architecture/moves/*.json`)
- `text_versions` files and history-manifest artifacts
- `THEOREM-CONNECTIVITY.json`, and the 26 of the 386 completion Lean sources that no record references
- the theory graph's inputs: `regions.json`, the Becoming modules, `classify/*.tsv`, `outcomes.tsv`, `chapters/*.md`
- every index input
- the reading catalogue's registers and sources
- the whole Lean catalogue's input set
- link-target existence and anchors
- standard-boundary and goal source existence
- the shared-laws `inputs_sha256` paths
- the generator code
- HEAD's history and `~/.cache`
- on-disk generated pages (lean docs, titles, anchors)

The snapshot is a race guard for a shared checkout, not a cache key.

### Dependence on git history

**HEAD's history** is used only through `registry.reviewed_version` (registry.py:46-90). That happens only for references that are `.md` files and whose sha256 differs from the record's (non-`.md` files return before any git call, registry.py:145-146). The result decides three things:
- source drift versus `changed_outside_cited` (registry.py:993-998)
- which record pages are skipped as stale (research.py:279-280)
- exit code 2

CI fetches full history for this reason (`.github/workflows/research.yml`, `fetch-depth: 0`).

**`--changed-since`** additionally uses the base commit: `git diff`, untracked files, and `git show` per changed record (research.py:68-96).

**The git index**, not the history, feeds:
- the inventories (moves.py:86-122)
- secrets' `git grep` over tracked files
- `gitlinks` in `links`

### Dependence on untracked and ignored files

**Untracked, not ignored:**
- the index inventory (indexes.py:52-62); the untracked file in this worktree would add a row to `DIRECTIVE-INDEX.md` and change the `sources/README.md` count
- `changed_paths` (research.py:71)
- `links` (moves.py:340)

**Any file on disk, filesystem globs:**
- `records/*.json` (registry.py:1352)
- `records/*.md` (registry.py:1446; paths.py:85-86)
- `goals/*.json` (navigation.py:83)
- `chapters/*.md` (indexes.py:140; reading_catalogue.py:304; theory_graph.py:163)
- `classify/*.tsv` (theory_graph.py:137)
- `theories/*/README.md` (reading_catalogue.py:319)
- move receipts (moves.py:1041)

**Ignored files too:**
- `iterdir` of `sources/` (indexes.py:361, 438); the main checkout's ignored `sources/12-`, `13-` and `18-` directories would add rows to `sources/README.md`
- the Lean catalogue's `rg --no-ignore` (lean_catalogue.py:95-100); only `.git`, `.lake`, `.build`, `node_modules`, `.venv`, `venv`, `__pycache__` and `.claude/worktrees` are excluded, so `tmp/` and `work/` are scanned
- `Path.exists()` link checks (research.py:187; lean_catalogue.py:280; registry.py:219-223)

**Not the same in `links`:** it accepts only inventory files and reports ignored targets apart (moves.py:378, 397-402).

### Skipping and caching by changed paths (conservative)

**Global triggers: run everything.** A change to any of these:
- imported tools code: `research`, `registry`, `navigation`, `completion`, `lean_catalogue`, `reading_catalogue`, `style`, `paths`, `moves`, `indexes`, `session_map`, `history_notes`, `rename_ids`, `theory_graph`, `boundary`, `__init__`
- `Makefile`
- `_process/research-config.json`
- move receipts
- `.gitignore`, `.gitattributes`
- the key set of `generated-manifest.json`; its values only feed the write guard, navigation.py:679-681

**Per-family triggers:**

| Family | Rerun when the change touches |
|---|---|
| **Records and validate** | Record JSONs; any record reference or `text_versions` path; review files; standard boundaries; `law-families.json`; `shared-laws.json`. Cache per record (see `cache_ideas`) rather than trusting `affected_ids`. |
| **Navigation** | Records, goals, history manifest and artifacts, the four `readme_*` files, timed files (ONE-PAGE.md), `law-families.json`, existence of `FOUNDATION_COMPOSITION` or `MAP.md`. Cheap, so always recompute when any of these change. |
| **Completion** | `COVERAGE.json`, the core receipt, the receipt-listed pure-layer Lean files (computable from the receipt), `THEOREM-CONNECTIVITY.json`, `08-METHOD.md`, additions or deletions in `records/`. |
| **Theory graph** | Records, `regions.json`, `Becoming.lean` and the modules it imports, the grammar module headers, `classify/*.tsv`, `outcomes.tsv`, `chapters/*.md`. |
| **Indexes** | Any addition or deletion under `_process/research/`, `_process/history/`, `sources/` or `chapters/`; modification of chapters, `THE-THEORY-OF-BECOMING.md`, study entry files, root-foundation top-level files, `history/root-foundation` REVIEW files, `sources/*/README.md`, directive-group `.md`, `RESEARCH-DIRECTIVES.md`. |
| **Reading catalogue** | The three registers, chapters (additions, deletions, edits), every entry source, existence of lean or evidence paths, the frozen volumes, `theories/*/README.md`. |
| **Lean catalogue (strict and render)** | Any `.lean` outside saved-copy paths (`tools/research/boundary_check.lean`, `drafts/` and `sources/` included); any `.md` in its docs scope (theories/ except results/, `_process/research/`, `experiments/`, root); any addition or deletion that a docs-scope `.md` links to; the core receipt. |
| **`check_links` on outputs** | Rerun on cached outputs when a fragment-linked `.md` target changes. Example: OPEN-QUESTIONS.md links `_process/BECOMING-WORKBOARD.md#decisions-pending-ren`. |
| **links** | Changed live or generated `.md` as referrers; referrers of changed `.md` targets with fragments; referrers of added or deleted targets. |
| **secrets** | Changed files, plus a full run when the allowlist or patterns change. |

**Worked example: a board-only change.** A modification of `_process/BECOMING-WORKBOARD.md` alone affects only:
- `links` for the board itself and the 7 files that link into it with a fragment
- `check_links`' test of OPEN-QUESTIONS.md's anchor into it
- secrets

It is not a record reference. It is outside the Lean docs scope (`_process/`, not `_process/research/`). Its existence is listed in `source-index.json`, but its content is not read there.

### Problems in `affected_ids` (registry.py:1395-1425)

- It ignores changes to code and config.
- It misses a member removed from a law family, because it uses the current `_law_family` (1397, 1417).
- It misses producers when a dependency edge or a consumer record is removed, because it follows current dependencies only (1420-1425).
- Drifted records are never compared at all (research.py:279-280).

### Two anchor algorithms

`check_links` uses `reading_catalogue.slug` (reading_catalogue.py:129-150). `links` uses `moves.github_slug` (moves.py:259-315). The two are not equivalent, so one cannot stand in for the other.

### Inert paths

The conservative list is in `unaffecting_paths`. All entries are modification-only. Additions, deletions and renames always need the inventory and link tiers.
