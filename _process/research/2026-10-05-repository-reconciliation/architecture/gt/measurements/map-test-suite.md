<!-- AI-written: one of four read-only readers, 4 November 2026, for GT's design (GATE.md). Read against main 1e9bc6b85; not checked line by line. -->
# The research tests and what selects each

# research-test: which tests can be tiered, and the triggers that keep it sound

The `tests` rule in the in-progress gate is not sound. It selects research-test only for `tools/research/**`, `_process/research-config.json` and `Makefile` (`tools/research/gate.py:55`, `:109-110`, in the uncommitted working copy as read). But 55 of the 308 tests read live content. At least 14 different kinds of non-tool change can turn research-test red while `check --strict-fresh` stays green.

The `dossiers` check being added to gate.py also misses inputs: `lean/deeper/**`, `one-unfolding-root/review-checks/**` and root-level quoted files such as `GLOSSARY.md`.

Below: how each test is classified, what to move into check, what to rewrite, sound trigger sets for the current code, and the cost drivers.

**Baseline.** Commit `1e9bc6b85` in `/Users/ren/theories/.claude/worktrees/gc-reading-correction`. While I read, HEAD moved to `3bf962941` (a board commit only), and uncommitted edits appeared in `tools/research/{completion,registry}.py`, `tests/test_scoped_drift.py`, `AGENTS.md`, `Makefile`, `RESULT-WORKFLOW.md` and an untracked `tools/research/gate.py`. Every count and line number below is from `1e9bc6b85`, except gate.py, which is the working copy as I read it and is still changing.

**What I did not do.** I ran no tests, no check and no make target, so there are no timings. The costs given are sizes by construction: file counts, bytes and subprocesses.

## The soundness rule
A landing may skip test T on change Δ only if no failure that Δ could cause in T is left unblocked by a check that runs anyway. `check --strict-fresh` reads `**` and is selected on every landing (`gate.py:111-112`). So a live failure mode that also fails check can be ignored when choosing T's triggers. Any other live dependence must either:
- become part of check,
- be added to T's triggers, or
- be replaced by a fixture.

## How the tests split: 308 in all (counts per file are in `tests`)
- **253 tool tests.** They exercise code on fixtures, temporary trees or patches.
  - Code outside `tools/` that they run: `check_becoming.py` and `check.py` (test_style @157 and @164, test_checker_steps), `check_dossiers.py` and `resync_report.py` (test_review_packet @107), and `THEOREM-CONNECTIVITY-DUMP.lean` plus the Lean toolchain (TheLeanCheck).
  - Some tool tests read `research-config.json` `path_roles` through `research.working` (`test_architecture.py:49-54`, `test_moves.py:188-190`, `paths.py:113-121`). That config is in the tool trigger set.
- **16 tests covered by check.** Their live dependence can only fail them where check also fails:
  - `test_registry.py:69`
  - `test_law_families.py:12`
  - `test_completion.py:109` (and the errors half of `:119`)
  - `test_rename_ids.py:52` (the `orphan_pages` part, already in check at `research.py:261`)
  - `test_architecture.py:90`
  - `test_featured_results.py:117`
  - `test_indexes.py:144`
  - `test_strict_fresh.py:35`, `:42` and `:51`, which leave `completion.render` unpatched (`:20-31`, `:64-77`) and so fail exactly when check errors (`research.py:272`, `:304-310`)
  - `test_theory_graph.py:13`, `:19` and `:29`, which hold by construction (`theory_graph.py:183-216`)
  - in `test_schema2.py:174`, only the `validate_standard_boundaries` half (`registry.py:914`)
- **29 tests depend on a live fixture.** Check does not guard these. Examples:
  - The 10 mutation tests in `test_registry.py`: each needs a recorded-checked record, a target record, or `records[0]` with aliases.
  - `test_registry.py:120` passes only because the first recorded-checked record's canonical source is a `.lean` file (`a-cascade-at-the-histories-reached`). A Markdown source that matches its review gives `None` (`registry.py:158`) and lands in GROWN rather than drift (`:998`).
  - `test_rename_ids.py:33-40` needs specific live ids and chain entries.
  - `test_review_packet.py:62` needs the exact Lean text at `Becoming/Significance.lean:296`.
  - `test_boundary.py:657` needs `measure_grammar.py`, `THEOREM-CONNECTIVITY.py` and the DUMP file to exist (`shared_laws.py:269-274`).
  - Also in this group: `test_indexes.py:152` (session-map JSON shapes, and `research.py` never calls `session_map.check`), `test_schema2.py:186`, the shared-laws page tests (`:89`, `:317`, `:330`, `:336`), and the boundary page tests (`:792`, `:802`, `:859`).
- **10 tests assert live content that check does not:**
  - `test_theory_graph.py:24-27`: a known region in `regions.json`. The page silently drops unknown regions (`theory_graph.py:241`, `:264`).
  - `test_featured_results.py:322-348`: front-page rules (no AI/Ren/Claude above the opening, both premises with their roles, the opening's notes line).
  - `test_featured_results.py:93` and `:242`: they pin sentences of `REPOSITORY.md`, `README-FIRST-SCREEN.md` and `README-LEAD.md`, though what they test is ordering.
  - `test_shared_laws.py:354-375` and `test_boundary.py:1475-1486`: the shape of `shared-laws.json`, which check only reports on (`registry.py:864`).
  - `test_completion.py:122`: all of K1-K7 met. `research.py:268-269` says an unmet criterion is not an error.
  - `test_review_packet.py:38-51`: the whole packet's quotations and Lean names.
  - `test_style.py:51-52`: `style.STOCK` keys must be in the live boundaries.
  - `test_schema2.py:177`: the exact `no-ethical-premise` text.
  - `test_schema2.py:246-287`: the frozen drafts against the live registry.

  Two of these already mean research-test gates content: `test_review_packet.py:38` and `test_completion.py:122`.

## Proposed split
1. **Into check, as errors.** These are cheap, because check already reads the same inputs.
   - Unknown region → `research.py:274`.
   - Front-page rules → `navigation.validate_goals` (`navigation.py:325-366`).
   - STOCK keys and the stock text matching its pattern → `validate_standard_boundaries` (`registry.py:320-341`). Note this generalizes the exact pin at `test_schema2.py:177`.
   - Shape of `shared-laws.json` → `shared_laws_status`. Shape is not staleness, so it can be an error without the checker cache.
   - The dossiers → the gate's own `dossiers` check, after which `test_review_packet.py:38` goes.
   - "K1-K7 all met" → needs a decision, because it contradicts the current rule that check reports it without failing.
2. **Drop or keep tool-only:** the 16 tests check already covers.
3. **Rewrite on `TemporaryRoot`** (`test_schema2.py:25-71`) or patches. That covers all the fixture-dependent tests and the incidental pins at `test_featured_results.py:93` and `:242`.
   - Patch the reads in `test_indexes.py:152`.
   - Give `test_review_packet.py:62` a fixture Lean directory.
   - Retire `test_style.py:121-132`, which always skips (0 of the 533 records are on schema 1).
   - Decide on MigrationDraftTests: retire it, or make it an opt-in check.
4. **After 1-3, every file is triggered by its code closure only.**
   - `tools/research/*.py` and `boundary_check.lean` for most files, because `research.py:19` imports every module and `registry` lazily imports `moves`, `reading_catalogue`, `boundary` and `style`.
   - Leaf sets: completion; evidence_store; history_notes; moves and paths (test_links); split_languages and reading_catalogue; repoint and registry.
   - Plus the outside code listed under the tool tests above, plus the imported test files: `test_checker_steps.py:6` imports test_style, and `test_boundary.py:689` imports test_schema2.
   - "The record schema" is code (`registry.py:27`, `style.py`), so these sets already cover it.
5. **Until then, use `trigger_map`.** It is sound for the current code: it adds each test's live paths and the derived sets (dossier quotes, first-screen time fields, receipts bound by records, draft references).

## Gaps in the in-progress gate.py
- `tests` reads only `RESEARCH_TOOLS` (`:55`, `:109-110`). Changes that fail research-test without selecting it include:
  - a dossier or a quoted chapter
  - `README-LEAD.md`, `README-FIRST-SCREEN.md` or `OPENING.md`
  - `regions.json`, `shared-laws.json` or `COVERAGE.json`
  - `generativity-chain.json`
  - `check_becoming.py`
  - the DUMP file
  - the Lean text of `ReadsOnlyDynamics`
  - a new record that sorts first and has a Markdown canonical source
- `dossiers` (`:115-118`) omits `lean/deeper/**` and `one-unfolding-root/review-checks/**`, which are in `BLOCK_DIRS` (`check_dossiers.py:33-34`).
- `quoted_paths` (`:92-98`) has two problems:
  - It drops paths without a `/`. `GLOSSARY.md`, quoted at `review/PHILOSOPHY.md:122`, is not selected.
  - It matches only `引〔` and `Quote \[`, while the checker accepts whitespace and either bracket (`check_dossiers.py:31`).
- A tree-keyed pass is reused when only paths outside a check's `reads` change. With `reads` incomplete, the pass cache inherits the same gaps.

## Heavy runs, cache keys and trains
- **Cost drivers:**
  - 14 full validates: 11 in RegistryTests, 2 in test_architecture, 1 in MigrationDraftTests. Each hashes 1,634 files (1.2 GB) and parses 220 receipts (533 MB), because `Sources` is built anew on every validate call (`registry.py:911`, `:255-297`). Check itself runs 1.
  - TheLeanCheck: real Lean compiles (`test_boundary.py:1321-1376`), 600 s timeout. Under load it can produce load reds.
  - 11 dossier scans of about 20.8 MB of Lean each.
  - About 60 scratch git repositories across evidence_store, moves, scoped_drift, links, credentials and review_packet.
  - Put TheLeanCheck and the live-validate tests under the machine lock, or split them into a heavy lane keyed by their own inputs.
- **The tree is not the whole key.**
  - Whether the toolchain is installed decides skip or run (`test_boundary.py:1317-1318`), so key on `lean --version`, or do not reuse a pass that had skips.
  - git and `rg` versions (`moves.py:602`) and the Python version.
  - HEAD's history (`registry.py:58`; `research.py:86`). gate.py's "history only grows" argument covers this.
  - `~/.cache/research-source-versions.json` (`registry.py:42`) is content-addressed.
- **Trains:** select test files by the union of the branches' changed paths, and always include imported test modules. Process-wide caches can leak between files: `lean_catalogue.receipt_layers` is filled under a patched ROOT by `test_architecture.py:63-65` (`lean_catalogue.py:222`); others are `completion.sources` and `paths.default`. I found no outcome that changes today, but subsets should run in a fresh process.

## Decisions this leaves open
- Should check require K1-K7 all met?
- Should the shape of `shared-laws.json` be a check error?
- Retire MigrationDraftTests, or make it opt-in?
- Generalize the exact boundary-text pin?
