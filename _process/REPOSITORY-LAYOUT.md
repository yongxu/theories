# Repository layout

Where each kind of material lives, how retired material is kept, and where a new file goes. Approved by Ren on 17 October 2026 as part of the [restructure plan](research/2026-10-05-repository-reconciliation/whole-repo-review-2026-10-16/RESTRUCTURE-PLAN.md) (§4.1–4.3). The working rules are in [AGENTS.md](../AGENTS.md); the procedure for results is in [RESULT-WORKFLOW.md](RESULT-WORKFLOW.md).

**Principle.** One responsibility per top-level area, and fewer copies rather than more layers. Only the latest, most informative version of a document stays live. What it replaces moves, byte for byte, to a sibling `history/` directory with a manifest entry. Nothing is deleted.

## Target tree

```
README.md            generated: Ren's opening → what is established → start here
AGENTS.md            working instructions
RESULTS.md           the single result register
GOALS.md             generated: scopes, ordered by authorization state
OPEN-QUESTIONS.md    generated: targets, open items, decisions pending Ren
DEPENDENCIES.md      generated: compact dependency adjacency and used-by
RESEARCH.md, MAP.md, GLOSSARY.md   short current pages or stubs; paths and anchors kept
Makefile, .gitignore, .gitattributes, .ignore, .github/

theories/becoming/            the canonical theory, in four layers: one page, overview, eight chapters, the evidence
  ONE-PAGE.md                 the one page (with ONE-PAGE.zh.md)
  THE-THEORY-OF-BECOMING.md   the overview, the canonical entry (with .zh.md)
  OPENING.md                  Ren's text
  COLLECTIVE-DIRECTION.md, FREE-ENERGY-PRINCIPLE.md, ONE-ARGUMENT.md   pages for one question or field, off the reading path
  README.md                   generated landing page
  chapters/                   01-ROOT.md … 08-METHOD.md, CLAIMS.md (stub), generated README index
  review/                     the review packet: cover (README, README.zh), six dossiers, recoding/
  results/                    records/, data/, atlas/, generated views
  history/                    retired chapters (the canonical chapter among them), verification/, lineage/, lean-declarations/
theories/<branch folders>/    September syntheses, in place, each under a banner; their index, theories/README.md, is generated from the crosswalk

experiments/integrated-correction/general-framework/generative-basis/lean/   the Lean root
  becoming/                   pure core + bridge package, check_becoming.py, receipt
  becoming/becoming-checks/   run receipts; file copies in the content-addressed store
  deeper/, inquiry-root/, universal-ethics/, …   periphery (paths unchanged)
  history/                    unreferenced run folders and earlier stage material
experiments/                  experiments + generated index; history/ for retired studies

_process/
  BECOMING-WORKBOARD.md       the live work board
  RESEARCH-DIRECTIVES.md, DIRECTIVE-INDEX.md, goals/, RESULT-WORKFLOW.md,
  REPOSITORY-LAYOUT.md, research-config.json
  architecture/               manifests, hash-addressed history/, moves/ (receipts), repairs/
  research/2026-10-05-generative-foundation-review/   the one live study
     root-foundation/         live study files + generated index
     history/                 retired packets, landing kits, working sets, executed plans
  research/2026-10-05-concern-theory/   stays (freeze-pinned)
  history/                    retired studies, the September corpus pages, handoffs, board log

sources/                      imported originals only, with README, GROUPS.json, SOURCES.md
tools/research/               shared infrastructure (paths, moves, landing, scanners, tests)
tools/publishing/             PDF and site builders
drafts/                       dated drafts + generated index
output/                       exports + README (source → builder → export)
tmp/, work/                   scratch; nothing tracked
```


## The areas

**Root pages.** README, RESULTS, GOALS, OPEN-QUESTIONS and DEPENDENCIES are generated from records, goals and the config by `make research-render` and are never edited by hand. `RESULTS.md` is the one register; `RESEARCH.md`, `theories/becoming/README.md`, `chapters/CLAIMS.md` and `results/RESULT-REGISTER.md` are stubs pointing to it, and `results/ROADMAP.md` points to GOALS. `AGENTS.md` and the short MAP and GLOSSARY pages are maintained by hand. Superseded root corpus pages (TIMELINE, BOOKS, the originals of MAP and GLOSSARY) go to `_process/history/2026-09-consolidation/`.

**`theories/`.** Current arguments. `theories/becoming/` is the canonical theory: Ren's opening, the one page and the overview (each with a Chinese edition), the eight chapters, the pages for one question or field, the review packet, and the result records with their generated views. A retired chapter goes to `theories/becoming/history/`, at the same depth as `chapters/`, so its relative links still resolve. The sixteen September branch folders stay in place as historical syntheses.

**The Lean root.** The Lean package stays at `experiments/integrated-correction/general-framework/generative-basis/lean/` (decision 4). `becoming/` holds the pure core and the bridge; `check_becoming.py` compiles them together with the three foundation modules, which it finds by file stem under the Lean root. The periphery keeps its paths. Retired run folders go to `lean/history/` inside the Lean root, where the checker's receipt discovery still finds them and its archive rule never mistakes them for live modules.

**`experiments/`.** Executable research: models, data, checkers and their receipts. Retired 5 October studies go to `experiments/history/`.

**`_process/`.** Coordination and process: the work board, directives, goals, this page, the result workflow and the config. `architecture/` holds manifests, the hash-addressed record snapshots (`architecture/history/<hash>/`, unchanged and never renamed), move receipts and repair evidence. `research/` holds studies; the generative-foundation review is the one live study, and its retired material goes to `history/` beside `root-foundation/`. Retired whole studies, handoffs and the board's closed rows go to `_process/history/`.

**`sources/`.** Imported originals and Ren's directive records only. Bytes never change; files never move. A redacted or adapted reading edition is labelled and registered, and the original stays.

**Searching.** The root `.ignore` (13 November 2026) leaves `_process/history/`, `_process/architecture/history/` and the saved check copies (`becoming-checks/`) out of plain ripgrep searches, so that a search meets what is current first; `rg --no-ignore-dot` or `research.py find --archives` searches them too, and nothing is removed.

**`tools/`.** Shared infrastructure in `tools/research/` (path roles, moves, landing, scanners, tests), publishing builders in `tools/publishing/`. Old dated tool paths stay as compatibility entry points.

**`drafts/`, `output/`, `worldbuilding/`.** Dated drafts, exports with their builder named, and the worldbuilding subproject. Each is to have a README index; on 4 November 2026 only `worldbuilding/` has one.

**Scratch.** `tmp/`, `work/`, `.claude/worktrees/`, `.lake/` and caches are not tracked. Unique scratch work is saved into the right area before delivery.

## Path roles

[`tools/research/paths.py`](../tools/research/paths.py) classifies every path once, from `path_roles` in `research-config.json`, and the other tools use it. In order of precedence: **source** (`sources/`), **scratch** (`tmp/`, `work/`, `.claude/`, caches), **history** (any path component named exactly `history`, and `_process/architecture/history/`), **evidence** (timestamped run folders, `verification-history/`, `legacy-replays/`, snapshots, `-BEFORE-` copies, `frozen/` and `review-history/` folders, and the files and folders `evidence_paths` names, each with its reason: frozen copies and inputs whose bytes a manifest, freeze or review receipt hashes), **generated** (pages written by render), **live** (everything else). Default search and discovery read live and generated files; history and evidence are reached deliberately (`research.py find … --archives`).

`make research-links` checks every relative link and anchor in live and generated Markdown and fails on any break, so it is a gate: a new break shows. Links use repository-relative paths, never absolute ones. A target inside a submodule or excluded by `.gitignore` (a recording kept locally) cannot be checked from the repository; the check lists it under `not_in_repository` and does not count it. A file pinned by a hash keeps its bytes: it is classified as evidence, not repaired.

## History layout

- **Where.** Retired material goes to a directory named exactly `history`, placed as a sibling at the same depth as the material it replaces (`chapters/` → `theories/becoming/history/`; `root-foundation/` → the study's `history/`). Same-depth moves keep relative links valid, the Lean checker already skips `history` components, and Lean history stays under the Lean root.
- **How.** Move with `python3 -B tools/research/research.py move --plan …` first, read the plan, then run the move. The tool checks blob identity, rewrites links in live files only, re-keys records whose path changed with the hash carried over, and writes the manifest and receipt. Never copy a file into `history/` while keeping it live, and never keep `-old`, `-v2` or dated copies beside a live file.
- **Manifest.** Every history root carries `MANIFEST.json` (old path, new path, sha256, git blob id, move commit, reason: superseded, failed attempt, applied kit, …) and a generated `INDEX.md`. Each batch writes a receipt `_process/architecture/moves/<batch>.json` from a plan in `_process/architecture/moves/plans/` (`research.py move --plan PLAN --apply --batch NAME`), verified by `research.py move --check RECEIPT`; the 9 October rename receipt and `check_rename.py` stay as they are and must keep passing.
- **Frozen evidence keeps its paths.** Receipts, freezes, edit ledgers and other evidence are never edited to follow a move; their old paths resolve through the manifests.
- **Hashes.** A record's source hash is carried over only for an exact path substitution. Any other byte change is read and rebound through the result workflow, never refreshed blind.
- **Never moves.** `sources/` originals; every FREEZE or preregistration manifest and the files it pins; `*-verification.json` and run receipts cited by records or inherited by the core receipt; `build_*.py` scripts with fixed depths; chapters tied by records' `path#anchor` citations, which stay in place with a status banner.
- **Left in place, out of navigation.** Material too tied to move (many inbound links, goal records, anchored citations) stays at its path, gets a banner or a generated status entry, and is excluded from default discovery.

## The evidence store

Run folders under `becoming/becoming-checks/<run>/` keep their receipts (`verification.json` and summaries) whole. The file copies a run checked (Lean sources and logs, mostly identical across runs) are kept once in a content-addressed store, `becoming-checks/_objects/<sha[0:2]>/<sha>`, built from each receipt's `artifact_sha256`. `RUN-INDEX.json` maps every run's file paths to their objects, so no byte is lost and git gains no objects. A restore command (`research.py evidence restore <run>`, being built) rebuilds a run folder from the store. Kept whole in place regardless: every receipt, every run or file named by a record, a current receipt or any link, the latest passed run per checker and the two newest becoming runs.

New imports larger than 10–20 MB go to LFS or an external store with a committed manifest (url, sha256, size); existing large files stay in plain git.

## Where things go

| Material | Place |
|---|---|
| A new or changed result | its record in `theories/becoming/results/records/`; the argument in its home section of the eight chapters, or the live study |
| New Lean | the Becoming spine (`lean/becoming/`), or the periphery package it extends |
| A study step, review or landing note | the live study (`_process/research/2026-10-05-generative-foundation-review/root-foundation/`), not a new dated workspace |
| A dynamic in the atlas | `theories/becoming/results/atlas/entries/`, its standing read from its records ([the workflow](RESULT-WORKFLOW.md)) |
| A correspondence: what became of an earlier folder's or a domain's claim | the read file in `development/cx-crosswalk/reads/`, imported to `theories/becoming/results/atlas/entries/` ([the workflow](RESULT-WORKFLOW.md#the-crosswalk-and-the-connection-map-cx)) |
| A claim on work | [the work board](BECOMING-WORKBOARD.md) |
| Ren's message that governs work | a source record in `sources/15-codex-theory-conversations/` (Ren's words verbatim, AI context labelled), linked from the [directive register](RESEARCH-DIRECTIVES.md) when it is a retained authorization |
| A new or changed authorization | `_process/goals/<id>.json` (with Ren) |
| Shared tooling | `tools/research/`, with tests |
| An experiment or empirical check | `experiments/<name>/` with its README and receipts |
| A draft for Ren | `drafts/<date>-<topic>/` |
| A Chinese edition of a live document | `NAME.zh.md` beside the English `NAME.md` |
| A superseded version | the sibling `history/`, via `research.py move` |
