<!-- AI-written: one of seven read-only readers, 4 November 2026, for the atlas plan. Kept as evidence for PLAN.md; not checked line by line. -->

## Atlas reader report: how the repository produces and checks its data and pages

### 0. What I covered

| Item | How |
|---|---|
| `tools/research/README.md`, `Makefile`, `_process/RESULT-WORKFLOW.md`, `_process/REPOSITORY-LAYOUT.md` | read in full |
| `research.py` | read in full: `check_or_render`, `input_snapshot`, `search`, `check_links`, `main` |
| `theory_graph.py`, `tests/test_theory_graph.py`, `tests/test_strict_fresh.py` (setup) | read in full |
| `registry.py` | read: constants (l.18–33), `validate` (l.907–1092), `validate_v2_fields`, `scoped_drift`/`cited_headings`/`links_record` (l.93–158), `load_records`, `affected_ids`, `redirect_pages`, `orphan_pages`, `shared_laws_status`. The rendering functions I only skimmed. |
| `navigation.py` | read: `write_views`, `preserve_view`, `validate_history`, `PAGES`/`NAV`. The rest I skimmed by function list. |
| `completion.py`, `indexes.py`, `paths.py`, `shared_laws.py`, `style.py`, `reading_catalogue.anchors*` | headers and the relevant functions read; the rest skimmed |
| `moves.py`, `lean_catalogue.py`, `evidence_store.py`, `boundary.py` | not read |
| Data | shapes computed with read-only python: `theory-graph.json`, `regions.json`, `law-families.json`, `shared-laws.json`, `COVERAGE.json`, `research-config.json`, `generated-manifest.json`. One record read field by field (`a-cascade-at-the-histories-reached`). Key, role and anchor counts computed over all 533 records. |
| Board | `## Rules` (1–9), `## Now`, and the start of `## Landing queue` read. The 21,934-character Queue line (l.39) I only sampled. |
| Tests | names of all 24 files listed. Only the theory-graph, strict-fresh and scoped-drift tests were read. |

Nothing was edited, and no make target, test, Lean or checker was run. The one script I wrote went to the scratchpad: `/private/tmp/claude-501/-Users-ren-theories/99fa549c-d982-4a21-9c77-afab7aa9b7b2/scratchpad/anchors.py` (it only reads).

---

### 1. Commands and what they actually run

| Make target | Runs | Notes |
|---|---|---|
| `research-check` | `research.py secrets` then `research.py check` | Exit 1 means structure or rendering failed; exit 2 means the selected records' sources drifted. A stale directory index is only reported. |
| `research-check-strict` | `secrets`, then `check --strict-fresh` | Fails if a render would change any generated page, the Lean catalogue included. CI (`.github/workflows/research.yml`) runs this and `research-test`. |
| `research-render` | `research.py render`, under a `flock` on `.git/research-navigation.lock` | Writes through the guarded writer and refuses if inputs changed during the run. |
| `research-find` | `research.py find $QUERY` | Searches record identity fields first, then files whose role is "working". **Only `.md`, `.py` and `.lean` count as working** (`working()`, l.~120–128), so a data JSON is never searched, but its generated `.md` page is. |
| `research-test` | `python3 -B -m unittest discover -s tools/research/tests -p 'test_*.py'` | The full infrastructure suite, 24 files and about 330 tests. |
| `research-links` | `research.py links` (`moves.check_links`) | Checks every relative link and anchor in live and generated Markdown. Not run in CI. |
| `research-imports` | `research.py imports` | Textual import candidates only. |

Other `research.py` subcommands: `lint [--ids|--changed-since]`, `snapshot <id>`, `compact-history`, `rename-id --plan`, `move --plan|--check`, `evidence …`, `secrets` and `preserve-view <path> --note`. These tools stand alone: `repoint.py` (writes `_process/architecture/rebinds.jsonl`), `shared_laws.py` (a heavy generator run outside render), `completion.py [--json]` and `lean_catalogue.py --check`.

**`check_or_render` (research.py l.~250–330), in order:**
1. `input_snapshot()` hashes the config, the history manifest, `shared-laws.json`, `law-families.json`, `standard-boundaries.json`, the README input files, goals, every record and every path a record references. It does **not** hash `regions.json`, `COVERAGE.json`, the chapters or the Lean headers, although the theory graph and the completion report read them.
2. `registry.validate`, `orphan_pages`, `validate_goals`, `validate_history`. Any error here returns exit 1 before anything is rendered.
3. The outputs, in order: `navigation.render_views` → `completion.render()` → `theory_graph.render(records)` → `index_outputs` (indexes, the reading catalogue, and the Lean catalogue only when rendering or strict) → record pages, `RESULT-REGISTER.md` and redirect pages.
4. `check_links` runs over every generated body; a missing link or anchor is an error.
5. In check mode, a stale non-index output (README, RESULTS, theory graph, COMPLETION, record pages) **is an error even without `--strict-fresh`**. A stale index output is an error only under `--strict-fresh`.
6. The result JSON also carries `style_warnings`, `changed_outside_cited`, `reading_drift`, `stale_indexes` and `shared_laws` (status only, never an error).

---

### 2. What "generated pages, never hand-edited" means mechanically

- **Marker.** Every generated Markdown page opens with `<!-- Generated by … -->`; `test_indexes.test_every_index_page_is_marked_generated` checks the index pages. A JSON output cannot hold a comment, so it says the same in its `about` (theory-graph.json does).
- **Manifest guard.** `navigation.write_views` (l.670–695) looks up the expected hash in `_process/architecture/generated-manifest.json` (596 files, among them `results/data/theory-graph.json`, `lean-index.json`, `source-index.json`, `THEORY-GRAPH.md` and `completion/COMPLETION.md`). If a file differs from both that hash and the new body, render stops with "Unincorporated concurrent edit; preserve and reconcile". The writer swaps files in atomically and then updates the manifest, **so the manifest changes on every render and is committed with the landing.**
- **A new output path** must not already exist on disk with other bytes. A page that was hand prose before it became generated is adopted only through `indexes.adopted_pages` in the config, by sha256.
- **Reconciling an edit someone made by hand:** carry the prose into its source or record, run `research.py preserve-view <path> --note …` (which adds it to `history-manifest.json` with prior versions), then render.
- **Path role.** `paths.py` marks as `generated` whatever the manifest lists, plus `*.md` in record directories. **`shared-laws.json` is not in the manifest:** it is written by `shared_laws.py` outside render, so its role reads as `live`.
- **Orphan check.** Any `.md` in a record directory that is neither a record page nor a redirect is an error. Nothing else may be placed in `records/`.

---

### 3. Records, ids and anchors

- **Schema.** All 533 records are schema 2. Kinds: `theorem` 509, `assessment` 15, `argument` 5, `target` 4. Statuses: `recorded-checked` 502, `reviewed-scoped` 20, `superseded` 7, `open` 4.
- **Vocabularies** (`registry.py` l.21–24): `STATUSES`, `KINDS`, `RELATIONS = {formal-reuse, application, interpretive}` and `ROLES = {statement, proof, receipt, review, integration, counterexample, provenance}`. Role counts across all references: receipt 5,343, proof 2,315, integration 958, provenance 634, statement 563, review 248, counterexample 8.
- **Required by `validate`:**
  - an id matching `[a-z][a-z0-9-]+` that equals the filename stem;
  - non-empty `hypotheses`, `history`, a session-map `family` matching `F\d\d`, and a `reviewed_at_utc` ending `+00:00`;
  - `canonical_source` among the hashed references;
  - for `recorded-checked`: both `proof` and `receipt` roles plus a `proof_bindings` entry whose receipt pointer equals the proof's sha256 and whose success value is `passed`/`True`, with every declaration elaborated in the bound module;
  - for `reviewed-scoped`: `statement` and `review` roles;
  - either `counterexamples` or `does_not_show`;
  - a `relation` on every dependency, no dependency cycles, and an `interface` whose evidence is a reviewed reference;
  - `superseded_by` on a superseded record;
  - `former_ids` that are not live ids;
  - a `kind: target` can never be completed.
- **Field caps** are in RESULT-WORKFLOW §"Writing a record". Public fields must not carry round numbers, sections, dates, receipt stamps, the status in other words, or exchange words (`style.py`).
- **Home section.** A chapter states a result at `<a id="r-<record id>"></a>`. In the eight chapters there are 530 such anchors (87, 94, 111, 46, 72, 16, 83, 21). **Only `theory_graph.sections()` reads them.** No check requires a record to have a home section or a home section to match a record. The graph has 526 `states` edges; the 7 records without one are all superseded. Five anchors keep a former id beside the new one (for example 01-ROOT l.158–159) and become section nodes with no edge.
- **Regions** in `regions.json` agree with the chapter of every home anchor: 0 mismatches over 521 records. Five records are unassigned (the newest: `a-cascade-at-the-histories-reached`, `coupled-drawers-…`, `drawn-shaping-…`, `shaping-selected-among-groups`, `unequal-groups-…`). `regions.json` itself is not validated.
- **Renames.** `rename-id --plan` keeps `former_ids`, writes a generated redirect page and leaves study logs and the board's ids as they were at the time.

---

### 4. How records cite sections, and what "cited sections frozen" really is

- A reference hashes the **whole file** (`sha256`). On a mismatch, `scoped_drift` reads the reviewed version back from `HEAD`'s history. A rewritten or removed line counts as drift (exit 2) only if (a) it links `records/<id or former id>.(md|json)`, (b) it lies under a `##` heading whose anchor the record cites as `path#anchor` anywhere in its JSON, or (c) it comes before the first `##` heading. A record that neither links the file nor cites an anchor drifts on any rewrite. **Added lines never drift.** Lean sources and other non-Markdown files need their exact bytes. A change confined to uncited text is reported as `changed_outside_cited` and needs no rebinding.
- `progress[].source` anchors must exist (`validate_v2_fields`). 101 records reference a chapter by path, and **none cites a chapter by anchor**. The chapters link the record pages (86/94/113/47/76/16/81/32 distinct links), so for those records only rewritten lines that link the record, plus the chapter preambles, can drift.
- **Gap (flag 1).** The heading match is `anchors & anchors_from_text(<the "## " line>)`, and `sections()` treats only level-2 headings as sections. Two kinds of anchor therefore locate nothing:
  - an explicit `<a id="x"></a>` on its own line, which is the repository's convention (`#condition`, `#r-…`, `#record-history`, the board's `#落地队列--landing-queue`);
  - the slug of a `###` heading.

  Citing either makes `located` true but matches no section, so **rewrites under the cited text never register as drift**. Over all records I counted 56 cited anchors that are `##` slugs and 39 that are not. An example: `universal-practical-warrant` cites `ZERO-AXIOM-PRACTICAL-JUDGMENT-INTEGRATION.md#purpose-revision-and-prior-warrant`, which is the explicit anchor at l.776, above `## 21.` at l.779. The `##` line's anchors are only `{'21-purpose-revision-formed-commitment-and-prior-warrant'}`. `tests/test_scoped_drift.py` tests only heading-slug citations. RESULT-WORKFLOW l.61 ("A record that wants this precision … cites its sections by anchor") leads a reader to expect that such a citation pins the section. If this is fixed, those 39 citations may start reporting drift, so the fix needs a dry run and its owners.
- The memory note "records pin a hash of each cited section" overstates the mechanism: the hash is of the whole file, and drift is then located by section. Its practical advice still holds: **add a section rather than rewrite a cited one.**

---

### 5. Data files under `theories/becoming/results/`

| File | Curated or generated | Shape |
|---|---|---|
| `data/theory-graph.json` (1.6 MB) | generated by `theory_graph.py` | `{schema_version:1, about, regions{11}, nodes, edges}`. 3,211 nodes: text 1,724, result 533, section 531, module 382, concept 41. 6,198 edges: proved-in 2,142, related 1,411, formal-reuse 1,151, imports 836, states 526, interpretive 98, read-as 23, application 11. Ids: `concept:<name>`, `record:<id>`, `module:Becoming.X`, `text:<unit>`, `section:<path>#r-<id>`. |
| `data/regions.json` | curated (RA) | `{about, records{528: {region, base, note}}, modules{380}}`. Bases: old-base 191, general 158, frame 97, periphery 36, grammar 31, none 15. |
| `data/law-families.json` | curated, validated by `law_family_errors` | `{about, families[5]: {id, title{en,zh}, lead, members[], statement{en,zh}}}` |
| `data/shared-laws.json` (1.8 MB) | generated outside render | `{about, core_receipt "20261103T211917.845905Z", core_sources_sha256, from_dump, inputs_sha256{8}, names{5}, anchors{5}, counts{13}, counts_at_model, counts_at_boundary_record, model_relations, central_reach, records{514}, boundary{11}}`. `check` reports how current it is, never as an error. |
| `completion/COVERAGE.json` | curated, validated by `completion.validate` | `{about, statuses{proved,prose,open}, rows[17] (axis phase 5 / differentiation 6 / domain 6, each with declarations, records, sections, status, open_items), premises{items[17] (name, pattern, witnesses, meets…), …}, representation, enclosure, ethics_chain, open_register, unity, shared_laws[5]}`. Its report `COMPLETION.md` is generated. |
| `data/standard-boundaries.json` | curated | the shared boundary sentences |
| `lean-index.json` (17.6 MB), `source-index.json` | generated by `lean_catalogue` | |
| `arguments-*.json`, `generativity-chain.json`, `session-results.json`, `theory-map.json` | the reading catalogue, a chain with its own hash workflow, and frozen session maps | |

`move_rewrite_json` covers `theories/becoming/results/data/*.json`, so a move rewrites path strings inside those files. Any other location must be added to that config key.

---

### 6. What a new data layer needs, by the repository's own pattern

There are three precedents. `law-families.json` is curated, validated in the registry and rendered onto pages. `COVERAGE.json` → `COMPLETION.md` is a curated file with a generated report, both in one directory. `shared-laws.json` is the pattern for a heavy generator run outside render.

1. **The atlas is not records.** RESULT-WORKFLOW says "A record registers a scoped claim, not a whole session or a broad theme", and every file in `record_directories` is validated as a result and counted in RESULTS. Atlas entries are a curated data layer. Like `readme_featured_results`, they "create no result and strengthen no proof".
2. **A module, `tools/research/atlas.py`,** with constants for its paths, a loader that tolerates a missing file, a `validate()` returning error strings, a `build()` returning the resolved data, a `render(records) -> ({path: body}, errors)` like `completion.render`, and a `main()` offering `--check` and `--json` for cheap iteration.
3. **Wiring in `research.py`:**
   - `atlas_pages, atlas_errors = atlas.render(records); outputs.update(atlas_pages); errors += atlas_errors`, next to `theory_graph`;
   - add the curated atlas files to `input_snapshot()`;
   - **patch `atlas.render` in `tests/test_strict_fresh.py::run_check`**, as `theory_graph.render` is patched there, or that test reads the real outputs;
   - add to `affected_ids` only if atlas text is ever rendered onto record pages (as `LAW_FAMILIES` is). I recommend not doing that in version 1.
4. **Freshness group.** As a non-index output, a stale atlas fails plain `check` for everyone, which is how the theory graph already behaves when any chapter gains an `r-` anchor. Keep the page's content dependent only on the atlas files, the records, `COVERAGE.json` and `shared-laws.json`. Make anchor existence a *validation* that reads the chapters, but not something the page's text depends on.
5. **Standing is derived and never upgraded.**
   - An entry backed by records carries no stored standing; the generator prints each linked record's `status` and links its page.
   - An entry with no record (a conjecture or reading in a chapter) must carry `standing ∈ {argued, conjectured, reading, open}` and a hashed `##`-anchored source.
   - Errors: `proved` without a `recorded-checked` record, or a standing above what the linked records say.
   - Declarations are checked against `completion.sources()` (the core receipt's pure modules, cached) and, for periphery names, `registry.Sources().declares(path, name)`.
6. **Text.** `{en, zh}` pairs, rendered in English with the Chinese as fallback (`registry.en`). Reuse `style.py`'s `ROUND`, `PROCESS`, `STATUS` and `MARKET_*` rules on the public text. Ids match `[a-z][a-z0-9-]+`. The `about` field is labelled as AI-written ("Written by AI … the tool checks it, it does not choose it", as COVERAGE's is).
7. **Reuse instead of copying:**
   - premises: the `COVERAGE.premises.items[].name`;
   - phases and domains: `COVERAGE.rows[].id`;
   - standings of central declarations: `shared-laws.json.boundary`;
   - the five shared laws: `COVERAGE.shared_laws[].id`;
   - corpus units: `text:<unit>`, the classify TSV ids;
   - region and base: `regions.json`;
   - tests: the paths of `experiments/<name>/FREEZE-*.md` and their pinned hashes. These are evidence-role files and are never copied.
8. **Correspondence gap to know about.** 1,724 classified text units exist, but only 23 `read-as` edges reach a record. Most traditions' links currently live only in each record's free-text `correspondence` field.
9. **Documentation:** a paragraph in RESULT-WORKFLOW (like "Law families"), a row in REPOSITORY-LAYOUT's "Where things go", and a line in `tools/research/README.md`.

---

### 7. How the theory graph could gain the new node types

| Constraint | Where it is set |
|---|---|
| Every edge joins two nodes | `test_every_edge_joins_two_nodes` |
| Every record is a node | `test_every_record_is_a_node` |
| Any node carrying `region` uses one of `REGION_ORDER`; leave it out otherwise | `test_regions_are_known` |
| The page starts with the marker | `test_page_is_generated` |
| Edges are de-duplicated by `(from, to, type)` and sorted | `build` |
| `page()` counts only result/module/text/concept per region; other types are ignored, so nothing breaks, but they are not shown | `page` |
| Consumers of `theory-graph.json`: only `research.py` and the tests (searched) | — |

The recipe: `theory_graph.build` calls `atlas.build()` and adds the types `attractor`, `transition`, `exit`, `premise`, `thesis`, `test` and `correspondence`, with prefixed ids (`attractor:<id>`, …). Suggested edges:

- `shown-by` → `record:`
- `leaves` (exit → attractor)
- `between` (transition → attractor)
- `assumes` (record → premise)
- `tests` (test → record or thesis)
- `corresponds-to` (correspondence → record or text)
- `on-row` → a COVERAGE row

Region comes from the linked records' region, or is omitted. Add a table and section to `page()`, and add tests that every atlas node has at least one edge and every id an atlas entry cites resolves. Keep `schema_version: 1` if the change is additive; otherwise bump it and say so in `about`.

---

### 8. Tests under `tools/research/tests/` (24 files)

architecture 16, boundary 61, checker_steps 3, completion 14, credentials 2, evidence_store 16, featured_results 25, history_notes 8, indexes 14, law_families 3, links 5, moves 12, navigation_pages 12, registry 20, rename_ids 6, repoint 1, review_packet 3, schema2 16, scoped_drift 10, shared_laws 25, split_languages 6, strict_fresh 4, style 22, theory_graph 4.

Focused set for the atlas: a new `test_atlas` plus `test_theory_graph`, `test_strict_fresh`, `test_architecture` (concurrent prose, planned links), `test_law_families` (the pattern) and `test_links`.

---

### 9. Recommended layout

```
theories/becoming/results/atlas/                 (like completion/: curated input + generated report)
  entries/attractors.json  transitions.json  exits.json  premises.json
  entries/theses.json  tests.json  correspondences.json      curated, one array per kind
  vocabulary.json        closed lists: kinds, edge types, standings, traditions/fields
  ATLAS.md               generated (marker): counts, tables per kind, links to records and #r-<id>
  GAPS.md                generated: open edges and open items → candidate Lean results, linking the board
theories/becoming/results/data/atlas.json        generated: resolved entries and derived standings
theories/becoming/results/data/theory-graph.json  extended (or a separate data/atlas-graph.json)
tools/research/atlas.py, tools/research/tests/test_atlas.py
tools/publishing/build_atlas_view.py             later: visual exports → output/atlas/ (with its README)
_process/research/2026-10-05-generative-foundation-review/root-foundation/development/atlas/NOTE.md
```

Add `theories/becoming/results/atlas/entries/*.json` to `move_rewrite_json`. Do not put atlas pages in `chapters/`, because the chapter index generator's `NUMBERED` pattern and the generated chapters README govern that folder.

### 10. Command sequence

The project requires the full `research-test`, strict check and links before landing (AGENTS.md "Working together"; RESULT-WORKFLOW l.155). That overrides the machine-wide "focused only" default for the landing step.

```sh
# claim a row on the board in your own worktree; if another item holds the Queue head, commit nothing to main
git -C /Users/ren/theories worktree add .claude/worktrees/atlas -b atlas main
# iterate (cheap, from the worktree root)
python3 -B tools/research/atlas.py --check
python3 -B -m unittest tools.research.tests.test_atlas tools.research.tests.test_theory_graph tools.research.tests.test_strict_fresh
# before landing: uptime and ps first; background long runs with a log
git -C /Users/ren/theories worktree add --detach .claude/worktrees/atlas-land atlas
python3 -B tools/research/research.py render
python3 -B tools/research/research.py check --strict-fresh
python3 -B tools/research/research.py links
make research-test
git commit -m "…" -- <atlas files> tools/research/atlas.py tools/research/research.py tools/research/theory_graph.py \
   tools/research/tests/… <re-rendered pages> _process/architecture/generated-manifest.json <indexes render changed>
# Queue clause; re-read the Queue line immediately before: git merge --ff-only
```

This landing touches only docs and tools, so no Lean checker run is needed. AGENTS.md asks for commits "naming no person or AI, with no co-author trailer", which conflicts with the harness's attribution reminder; the planner should decide which applies.

---

### 11. Things that look false, stale or misleading

| # | Where | What | Severity |
|---|---|---|---|
| 1 | `registry.py` `scoped_drift` l.137–158 vs RESULT-WORKFLOW l.61; untested in `test_scoped_drift.py` | An explicit `<a id>` or a `###` anchor that a record cites locates no section, so the cited text is not drift-protected. 39 such citations exist (example in §4). | **medium** |
| 2 | Board `## Now`, l.27 | "the latest core receipt is HE2's `20261031T054654.692180Z`". The latest is `20261103T211917.845905Z`, in `becoming-checks/`, `shared-laws.json` and `COMPLETION.md`. | medium |
| 3 | Board `## Landing queue` l.62–64 (anchor `落地队列--landing-queue`, the target of AGENTS.md's "Queue line" link) | Says "PF is at the head of the queue" (19–25 October text). The live Queue line is l.39, under `## Now`. | medium |
| 4 | Board l.9 (Target) | "the continuation condition appears only as the condition of chapter §6.15". It is now 07-SIGNIFICANCE `## 3`, `#condition` (l.134–135), which AGENTS.md links. The board text predates RA (written 19 October). | low–medium |
| 5 | `COVERAGE.json` `rows[].sections`, rendered as COMPLETION.md's "Sections" column (l.21ff); also COMPLETION.md l.96 "Section 8.1 has 12 items" (from `completion.py` l.643), and COVERAGE's `about` ("chapter section 0") and `open_register.about` ("chapter 8.1") | These use the numbering from before the chapters were split into eight files. Example: Generation shows "§2.2, §2.6", but its records' home sections are 02-MAP §3, §4 and §7 and 04-LIFE §1. The open items are now at `08-METHOD.md#open-items-ranked`. | low–medium |
| 6 | REPOSITORY-LAYOUT target tree | Puts `THE-THEORY-OF-BECOMING.md` under `chapters/`; it is at `theories/becoming/` (navigation `CANONICAL`), with the chapters numbered 01–08. "output/ exports + README": there is no `output/README.md`. The tree also omits `theories/becoming/review/` and the front pages. | low |
| 7 | THEORY-GRAPH.md "Not yet on the root" | "303 of 382 … (they neither are a grammar module nor import one)". `theory_graph.modules()` also counts a module that uses «» names as on the grammar, so the parenthetical understates the criterion. 369 of 382 reach the grammar through imports, which the page does not say. | low |
| 8 | `theory-graph.json` | Five section nodes for former-id anchors have no edge, because `states` resolves only current ids. | low |
| 9 | `regions.json` | Five records are unassigned, and the file is never validated against the record ids. | low |