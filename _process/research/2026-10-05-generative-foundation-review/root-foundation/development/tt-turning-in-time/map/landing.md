Kept as written; local paths in it point to the session's scratch folder.

AI-written map, 12 November 2026

# Landing map: one train carrying a new L1 leaf, a general law in RegimeMargin, records, a home section and a study note

Read only (Claude Opus 5.5). Nothing was built, run, rendered or gated. This reader maps the landing
procedure, not mathematics. Paths without a leading `/` are under `/Users/ren/theories`; `LEAN` below is
`experiments/integrated-correction/general-framework/generative-basis/lean/becoming`.

Sources read: `_process/RESULT-WORKFLOW.md` (all 174 lines), `_process/BECOMING-WORKBOARD.md` (rules, Now, the
Queue line, the TT row), `_process/REPOSITORY-LAYOUT.md` (all), `.../architecture/gt/GATE.md` (all 327 lines),
`tools/research/gate.py` (header, CHECKS, TESTS, STEPS, `receipt_check`, `laws_changed`, `main`),
`tools/research/research.py` (its subcommands), `tools/research/style.py` (header and constants),
`tools/research/registry.py` (constants, `validate_v2_fields`, the record validator 960-1130),
`tools/research/repoint.py` (header), `tools/research/theory_graph.py` (regions, modules),
`tools/research/tests/test_theory_graph.py`, the `Makefile`, `LEAN/check_becoming.py` (header, lists, `lean_plan`,
`main`), `LEAN/scratch_build.py` (header), `LEAN/Becoming.lean` (header, the import lines and bullets of
PoolFromCourse, RegimeMargin, ReadOffInTime), `LEAN/README.md` and `README.zh.md` (structure, the rows),
the two schema-2 records, `regions.json`, `law-families.json`, `standard-boundaries.json`, and the commits
7c7860eb1, b110553be, 5fab3baf4, f5f5a3023 (with c04e68ef4 and c4f6228b5, the same train's last two commits).
The memory notes of earlier landings were read for gotchas and are cited as such.

## 0. What a landing is here (the order, quoted)

RESULT-WORKFLOW.md line 164 gives the order in one place:

> "Before landing, work in a clean worktree you own, switched to the branch (`git switch --detach <branch>` takes
> seconds; a new worktree takes minutes and 5.3 GB). The order: put the head clause on the Queue line, in a gap;
> merge main into the branch; run what writes, each through `gate.py hold --` (the core run for changed Lean, the
> shared-laws generator where the paragraph above asks for it, then the render), and commit it with the landing,
> docs-only landings included, since committed files are counted and `.lean` files catalogued wherever they lie;
> write the landed clause in place of the head clause and commit the board with the landing; run `make gate`, and
> any area check it does not yet run; re-read the Queue line; fast-forward main."

GATE.md §3.1, line 93 ("Before the gate"): "Three steps write what the landing commits, so they run first, each
through `gate.py hold`, and their output is committed: the core run for changed Lean; the shared-laws generator
after a change to the Lean, COVERAGE, the measure, the connectivity dump or a record's laws …; the render whenever
the strict check is selected."

A train (board rule 5, GATE.md §4): "Landings ready together go as one train: each keeps its own commits and
landed clause"; "The lander runs the steps that write once, then the gate once on the merged tree." "A train costs
one render, one strict check and one core run, however many landings it carries."

Rule 9 (board line 23), which bears on (B): "A module that generalizes an existing law lands below it and proves
it, or proves it as a corollary; it does not land beside it with a second proof and a theorem saying the old law
is its case. … the special module imports it and derives its law from it, and the direct proof goes. A new module
is imported by an existing one, or its row says why it is a leaf (an instance, a tool, a model)." TT's row (board
line 56) says "One leaf module, `Becoming.TurningInTime`, a model".

The memory note "landed clause last" adds: run `make gate` first, write the landed clause last naming the actual
content tip, then gate the board commit. RESULT-WORKFLOW's order puts the landed clause before `make gate`; in
practice (K train: content `c04e68ef4`/`502254145`, then board `c4f6228b5`) the landed clause is a separate board
commit after the content passed, and the gate's board check refuses a board-only commit while a head clause stands
at the base, the lander's own included (memory: "study links and claim renders", item 4: "if that guard is the only
error and the head is mine, the clause is valid").

## A. A new L1 leaf Lean module (`Becoming.TurningInTime`)

The K2 landing (7c7860eb1) is the template: it touched, for one new core leaf, exactly
`LEAN/Becoming.lean` (+20), `LEAN/Becoming/PoolFromCourse.lean` (new), `LEAN/README.md` (+1 row),
`LEAN/README.zh.md` (+1 row), `LEAN/check_becoming.py` (16 lines: one CORE entry, one SCOPE paragraph),
`theories/becoming/chapters/02-MAP.md` (+24, §10), three records, and the study folder. Regions came in a later
commit of the same train (f95fab769: "K2: its three records and module placed in the theory graph's regions").

Literal edits:

1. **The module file**: `LEAN/Becoming/TurningInTime.lean`, beginning `import Becoming.RegimeMargin` (the scratch at
   `tmp/r7/the-loop/lean/Becoming/TurningInTime.lean` has exactly that one import, line 1, and opens
   `namespace Becoming` / `namespace TurningInTime` at lines 94-95). The path decides the name: "The package names
   modules by path (`Becoming/Frame.lean` is `Becoming.Frame`)" (check_becoming.py header, lines 4-5).
2. **`check_becoming.py`, CORE** (lines 100-113, one Python list of 396 strings ending `"Becoming"]`): insert
   `"Becoming.TurningInTime", ` in the list. Convention (K2): at the position matching its `import` line in
   `Becoming.lean`, i.e. next to its neighbour there. CORE order does not change correctness (compile order comes
   from imports, `closure`), but it changes the receipt's `compile_order`. Do not put it in INSTANCES or
   APPLICATIONS (lines 120-121): a model leaf of the core is CORE.
3. **`check_becoming.py`, SCOPE** (from line 218; one long string, a paragraph per module, e.g. K2's
   `"PoolFromCourse: the rule read …"` inserted after ReadInTime's): add `"TurningInTime: … "` paragraphs at the
   matching place. SCOPE is written verbatim into every receipt (`"scope": SCOPE`, line 4814); no tool or test checks
   it (grep found no reader besides the receipt), so it is convention, but every landed module has one.
4. **`Becoming.lean`, import** (the import block, lines 1-400; e.g. `import Becoming.PoolFromCourse` at line 179,
   `import Becoming.RegimeMargin` at 274, `import Becoming.ReadOffInTime` at 398): add
   `import Becoming.TurningInTime`. Needed: `theory_graph.modules()` lists modules from the root's
   `^import (Becoming\.\S+)` lines (theory_graph.py ~115), and `test_theory_graph` asserts every module node has a
   region; the README says "`import Becoming` brings in every layer".
5. **`Becoming.lean`, docstring bullet** (the `/-! … -/` block from line 402 to 5014): add
   `* \`Becoming.TurningInTime\` (L1, through \`Becoming.RegimeMargin\`): …`. The layer tag is parsed:
   theory_graph.py reads `^\* \`(Becoming\.[^\`]+)\` \((L\d)\b[^)]*\)` for the module's level. Layer rule (Becoming.lean
   lines 412-418): "L2 holds the modules whose source states the continuation condition or a valuation
   (`Unrestricted`, `Valuation`) and every module importing one of them; L1 holds the rest." RegimeMargin is L1
   (line 4193), so a module importing only it is L1. Convention: end the bullet "A leaf; …".
6. **`LEAN/README.md`, module table** ("## Three layers on one base", header row line 23
   `| Layer, ring or foundation | Module | What it states |`): one row
   `` | L1 | [`Becoming.TurningInTime`](Becoming/TurningInTime.lean) | … | ``, placed with its neighbours (RegimeMargin's
   row is line 298, its dependents' rows 299-300). No counts in the README need updating (grep found none).
7. **`LEAN/README.zh.md`**: the same row in Chinese (RegimeMargin's row is line 195). K2 and K3 both added it.
8. **`theories/becoming/results/data/regions.json`, `modules`**: add
   `"Becoming.TurningInTime": {"region": "<region>", "base": "<base>", "note": "…"}`. Required:
   `test_every_result_and_module_is_assigned` fails on `unassigned`; `test_regions_are_known` checks the region
   against `theory_graph.REGION_ORDER`. Regions in use: root, map, knowing, life, collective, classical,
   significance, method, retire. Bases in use: old-base, general, frame, periphery, grammar, none (the `about` field:
   "old-base = World/Web/Flow, frame = Process/Run, general = any type, grammar = Becoming.Grammar, periphery =
   Mathlib"). RegimeMargin is `{"region": "map", "base": "old-base"}`; PoolFromCourse `map`/`general`.

What the checker requires of the new module (check_becoming.py `main`, 4781-5005):

- `assert sorted(core_closure) == sorted(PURE)`: the closure of CORE is exactly FOUNDATION + CORE + RING, so every
  module it imports must itself be listed (RegimeMargin is).
- `ring_direction`: no core module but the root imports an INSTANCES or APPLICATIONS module (so TT must not import
  `RoomRuns` or `RoomNet`).
- Each module in the closure must be found exactly once by file name under the Lean root (`closure`,
  `assert len(paths) == 1`). A second `TurningInTime.lean` anywhere under the Lean root, outside folders the
  `ARCHIVE` pattern skips (line 3973), breaks the run. The scratch copy is under `tmp/`, outside the Lean root.
- Every Lean step's output must contain neither `error:` nor `warning:`
  (`assert not re.search(r"\b(?:error|warning):", outcome.output)`), so a linter warning (an unused variable, a
  deprecated name) fails the run, in the compile, the prelude-only compile and the signature driver alike.
- Axioms: every declaration's report must be within `{propext, Quot.sound, Classical.choice}` and, for SPINE + PURE,
  empty (`assert name not in SPINE + PURE or not axioms`). K3's NOTE.md records the traps: core
  `Nat.le_of_add_le_add_right` and `Nat.sub_le_sub_left` carry `propext`, and "Overlapping match patterns (a
  wildcard row after specific rows, even nested) also bring `propext`".
- The prelude-only compile: the core closure is compiled again with the foundation's `import Std` removed
  (`prelude=core_closure`), so nothing from `Std` may be used.
- The environment audit (`ENVIRONMENT_AUDIT`, 3946): every constant of the core closure, generated ones, private
  declarations and unnamed instances included, has an empty axiom report, the only exception generated `injEq` on
  `propext` that no source declaration is.
- **The signature check (CHECKED / signed statements).** `signed=[name for name in order if name in CHECKED]`
  (line 4896), with `CHECKED = SPINE + PERIPHERY_JOINS` (line 132) and `SPINE = CORE + RING + BRIDGE`. For each
  signed module `lean_plan` (4388-4428) writes a driver `<Flat>Signatures.lean` (`TurningInTime` →
  `BecomingTurningInTimeSignatures.lean`) holding `import Becoming.TurningInTime` and one line
  `#check @<full name>` for every declaration the scanner (`scanned`) found of kind `theorem`; it must compile
  with no error or warning. Beside it `<Flat>AxiomAudit.lean` holds `#print axioms <full name>` for every scanned
  declaration, and each name must appear in its output as "does not depend on any axioms" or with a list (else
  `assert match`). So a new module needs: every theorem nameable by its scanned full name with `#check @…`
  (namespaces resolved by the scanner, `«»` names included), and no private theorem relied on to be audited by
  name (private declarations and unnamed instances are listed in `not_audited_by_name`, covered by the
  environment audit). These logs are what kits read statements from (GATE.md §5.1: "It would change the
  `<Module>Signatures.log` layout that kits read statements from"). Only modules in CHECKED are signed: a module
  not registered in CORE gets no signatures step, in the checker or in `scratch_build.py` ("if the checker checks
  it, its theorems' statements"). TT's row says "the scratch build passes … not registered": its scratch build
  therefore ran no signatures step.
- After the run, `gate.py receipt` (gate.py 897-924) fails on "a module under Becoming/ that no receipt lists", and
  on any listed module whose current bytes the core receipt does not bind.
- Spine names with a word of exchange are listed in the receipt as `market_names` (MARKET_WORDS, line 4620); they
  do not fail.

What recompiles for (A) alone: the new module (compile, audit, signatures, prelude-only compile), the root
`Becoming` (its imports changed: compile, audit, signatures, prelude), the environment audit (its import list is
the core closure) and the controls driver (`import Becoming`). Everything else is reused from the cache. K3's
receipt `20261110T120322.270026Z`: 7 steps ran, 1,601 reused, Lean wall 44.8 s; the K train's
`20261110T132301.088622Z`: 7 ran, 1,609 reused, 36.3 s.

## B. A general law added to RegimeMargin, below an existing law

Edits:

1. `LEAN/Becoming/RegimeMargin.lean` (3,687 lines; imports Recurrence, Lasting, LastChange, Optimum, BandRest):
   the general law added; by rule 9 the existing law is then proved from it ("the direct proof goes"), its name
   and statement kept, so that "A lift that keeps the model law's name and statement, the grammar law below proving
   it (board rule 9), needs no edit to the modules above. Those only recompile." (GATE.md §5, item 2).
2. `Becoming.lean`: RegimeMargin's bullet (line 4193 on) re-said where the module now states more.
3. `check_becoming.py` SCOPE: RegimeMargin's paragraph re-said likewise.
4. `LEAN/README.md` line 298 and `README.zh.md` line 195: RegimeMargin's row.
5. The board's batched-precision section already holds "Two docstring points in `RegimeMargin`" (board line 72):
   "`threshold_regime`'s docstring says "within the band's top" before it introduces the band …; the module
   docstring's "The point is exact … (`ends_iff_below`)" does not name `0 < H + y` …. Wording only; they go with
   the next docstring pass and its core run." A landing that edits RegimeMargin is that core run; taking them
   costs nothing more and the board line then goes.

What recompiles: RegimeMargin and everything importing it, transitively, computed from the import lines:
`Becoming.RunTurns`, `Becoming.DrawHistory`, `Becoming.ReadOffInTime`, `Becoming.RoomRuns` (an instance) and the
root `Becoming`; with (A) in the same train, `Becoming.TurningInTime` too. For each: compile, axiom audit,
signatures and prelude-only compile; then the environment audit and the controls. GATE.md §5: "a module with only
the root above it adds about four steps"; RegimeMargin has five dependents, so about 4 × 7 + 2 ≈ 30 steps.

What record hashes drift (Lean sources need exact bytes, RESULT-WORKFLOW line 61):

- The 11 records that reference `LEAN/Becoming/RegimeMargin.lean`: `coupled-regimes`, `coupled-webs`,
  `margin-of-a-regime`, `regime-point-under-adjusting-giving`, `rest-by-balance`, `rest-on-coupled-webs`,
  `regime-in-any-amounts`, `thresholds-beyond-a-band`, `webs-with-a-recent-giving`, `threshold-in-the-state-plane`,
  `where-a-run-of-a-regime-comes-to-rest`. Each has a `proof` reference with a sha256 and a proof binding to an
  older receipt (`margin-of-a-regime` is bound to `becoming-checks/20261110T010039.815631Z/verification.json` via
  `/source_sha256/Becoming.RegimeMargin`). After the core run: read the diff, then
  `python3 -B tools/research/repoint.py --reason '…' --receipt LEAN/becoming-checks/<stamp>/verification.json --lean LEAN/Becoming/RegimeMargin.lean --paths LEAN/Becoming/RegimeMargin.lean --apply`
  (repoint.py header: `--receipt` with `--lean` rebinds "after checking that it binds the file's current sha256 and
  records success"). No history note where nothing the record says changed; one line goes to
  `_process/architecture/rebinds.jsonl`. The record whose laws gain the new declaration (`margin-of-a-regime`, or a
  new record) takes a history note and a fresh `reviewed_at_utc` (line 49: "A change to the claim, the premises,
  the scope or a declaration list takes a history note").
- Records of the dependents (RunTurns, DrawHistory, ReadOffInTime, RoomRuns) do not drift: their bytes are
  unchanged. Their proof bindings to older receipts stay valid.
- **The 10 records that bind the live receipt file** `LEAN/becoming-verification.json` by hash, role `receipt`:
  `confined-rise-within-a-whole`, `drift-offspring-sampled`, `fixation-with-selection`, `fixation-by-drift`,
  `groups-formed-by-descent`, `selection-within-and-among-groups`,
  `selection-within-and-among-groups-of-any-sizes`, `shaping-read-by-readers-drawn-from-the-selected`,
  `selection-with-returns-to-groupmates`, `shaping-the-rule-selected-by-what-comes-back`. Every core run rewrites
  that file, so every core run drifts these ten; each landing re-points them (the K train's `c04e68ef4`
  "receipt-file citers re-pointed; rendered"; AG-L's rebinds lines name "the records citing the receipt file"; 41
  lines of `rebinds.jsonl` mention it). This holds for (A) as well.
- Records citing a Markdown source the landing edits drift only where a reviewed line was rewritten in a cited
  section, a line linking the record, or before the first `##` (line 61). Added lines drift nothing.
- The shared-laws data (`theories/becoming/results/data/shared-laws.json`) is stale after any Lean change: the gate's
  "shared laws" step reads `LEAN/**` and is selected `when='laws_changed'` (a record's `laws`, statements at a model
  or boundary changed). Run it after the core run passes; K train commit f5f5a3023 committed the receipt and
  `shared-laws.json` together.
- `theories/becoming/results/completion/COVERAGE.json`: AG-L's rebinds line re-pointed "the records citing the
  receipt file and COVERAGE.json"; if COVERAGE changes (a central declaration), its citers drift too. Not read
  further here.

## C. Schema-2 records

Allowed values (registry.py lines 22-31):

- `kind`: `theorem`, `argument`, `assessment`, `target` (a target cannot be marked completed).
- `status`: `recorded-checked`, `reviewed-scoped`, `open`, `superseded`, `withdrawn`.
- `dependencies[].relation`: `formal-reuse`, `application`, `interpretive` (`related` edges carry no relation).
- `references[].role`: `statement`, `proof`, `receipt`, `review`, `integration`, `counterexample`, `provenance`.
- `does_not_show[].kind`: `non-implication`, `converse`, `correspondence`, `scope`; an optional `witness` must be a
  declaration named in `references` or an alias.
- `standard_boundaries` (keys of `theories/becoming/results/data/standard-boundaries.json`, 14): `discrete-steps`,
  `decidability`, `pointwise-properties`, `no-evaluation`, `significance-related-not-asserted`,
  `no-ethical-premise`, `no-ethical-premise-core-axiom-free`, `names-provisional`, `formal-not-empirical`,
  `omission-not-refutation`, `conditional-not-universal`, `zero-axiom-target-open`, `nondual-method-not-proof`,
  `no-definition-by-verdict`. `no-ethical-premise` only "where the hypotheses contain no ethical premise and the bound
  receipts report empty axioms for the cited declarations" (line 122).

Required by the validator: `schema_version` 2; `id` matching `[a-z][a-z0-9-]+`, unique; `title`, `statement`,
`correspondence`, `next_delta`, `validation_scope` each nonempty in en or zh; `hypotheses` nonempty list (max 9
items); `family` `F\d\d` (the session-map family, not the law family); `reviewed_at_utc` ending `+00:00`; `history`
nonempty; `aliases`, `references`, `dependencies`, `related`, `counterexamples` lists; `canonical_source` one of the
hashed references; `counterexamples` or `does_not_show` nonempty; for `recorded-checked`, roles `proof` and
`receipt` and at least one `proof_bindings`; for `reviewed-scoped`, roles `statement` and `review`. Every
`laws[].declarations` name must be among the references' `declarations`; every reference declaration must be found
in its file (`read.declares`) and, through a binding, among the declarations the receipt lists for that module
("declarations not elaborated in …"); an alias written as a Lean name in a namespace the bound receipts list must be
elaborated there; aliases are unique across all records (casefolded). Caps (style.py, hard where marked): title
100/40 (hard), statement 300/150 (hard), validation_scope 600/260 (hard), next_delta 400/180 (hard), claim
1500/700, correspondence 1200/500; items: laws 420/190 (up to 40), hypotheses 420/190 (9), does_not_show 240/110 (8).
Errors in public fields: receipt timestamps, round numbers `P\d\d`, `§`/"Section N", ISO dates, round narration
("has landed", "this round", "Codex"), session ids; three or more rounds or sections in one field. Warnings: market
words, a restated status, an evidence disclaimer, a negative opening.

Filled skeleton (one record; values are placeholders of the right shape):

```json
{
  "schema_version": 2,
  "id": "<stable-semantic-id>",
  "title": {"en": "<short name, ≤100>", "zh": "<≤40>"},
  "kind": "theorem",
  "status": "recorded-checked",
  "family": "F01",
  "reviewed_at_utc": "2026-11-12T00:00:00+00:00",
  "statement": {"en": "<one or two positive sentences, no Lean names, ≤300>", "zh": "<≤150>"},
  "laws": [
    {"en": "<one law, ≤420>", "zh": "<≤190>",
     "declarations": ["Becoming.TurningInTime.<name>", "Becoming.TurningInTime.<name2>"]}
  ],
  "hypotheses": [
    {"en": "No axiom. Discrete steps; …", "zh": "…"}
  ],
  "does_not_show": [
    {"en": "<one sentence>", "zh": "…", "kind": "converse"},
    {"en": "…", "zh": "…", "kind": "non-implication", "witness": "Becoming.TurningInTime.Witness.<name>"},
    {"en": "…", "zh": "…", "kind": "correspondence"}
  ],
  "counterexamples": [
    {"path": "LEAN/Becoming/TurningInTime.lean (full repository path)", "detail": {"en": "…", "zh": "…"}}
  ],
  "standard_boundaries": ["no-ethical-premise", "names-provisional", "formal-not-empirical", "discrete-steps"],
  "validation_scope": {"en": "Pure core, axiom report empty; a leaf. … Written by an AI; …; no human audit.", "zh": "…"},
  "next_delta": {"en": "<the next substantive step, positive, ≤400>", "zh": "…"},
  "correspondence": {"en": "Reading (the AI's, from its knowledge): …", "zh": "…"},
  "canonical_source": "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/TurningInTime.lean",
  "aliases": ["<plain alias>", "Becoming.TurningInTime.<name>"],
  "dependencies": [
    {"id": "margin-of-a-regime", "relation": "formal-reuse",
     "detail": {"en": "Reuses …", "zh": "…"},
     "interface": {"output": {"en": "…", "zh": "…"}, "input": {"en": "…", "zh": "…"},
                   "conditions": {"en": "…", "zh": "…"},
                   "evidence": "experiments/…/Becoming/TurningInTime.lean"}}
  ],
  "related": [{"id": "<other-record>", "detail": {"en": "…", "zh": "…"}}],
  "references": [
    {"path": "experiments/…/lean/becoming/Becoming/TurningInTime.lean", "role": "proof",
     "declarations": ["Becoming.TurningInTime.<name>", "…"], "sha256": "<sha256 of the file>"},
    {"path": "experiments/…/lean/becoming/becoming-checks/<stamp>/verification.json", "role": "receipt",
     "sha256": "<sha256 of that receipt>"},
    {"path": "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/<tt-folder>/NOTE.md",
     "role": "integration", "sha256": "…"},
    {"path": "_process/research/…/development/<tt-folder>/READER.md", "role": "review", "sha256": "…"},
    {"path": "theories/becoming/chapters/02-MAP.md", "role": "statement", "sha256": "…"},
    {"path": "sources/15-codex-theory-conversations/2026-11-12-where-we-are-and-the-loop.md", "role": "provenance", "sha256": "…"}
  ],
  "proof_bindings": [
    {"source": "experiments/…/lean/becoming/Becoming/TurningInTime.lean",
     "receipt": "experiments/…/lean/becoming/becoming-checks/<stamp>/verification.json",
     "sha256_pointer": "/source_sha256/Becoming.TurningInTime",
     "success_pointer": "/status", "success_value": "passed"}
  ],
  "history": [{"en": "12 November 2026, on Ren's words of 12 November kept in sources (…): added.", "zh": "…"}]
}
```

Notes on the skeleton:

- `interface.evidence` must be one of the record's reference paths (registry.py 1110). `counterexamples[].path` must
  be a hashed reference path.
- `progress` (targets, assessments, arguments), `not_required` (targets), `claim`, `text_versions` (migrations),
  `statements_at_model` (F5, on a law item) and `boundary` (U4's record only) are optional.
- Both K examples carry both languages throughout; full translation is not required (line 45), but it is the
  practice.
- `a-loss-read-before-its-point-of-no-return` references two receipts (its first core run and the train's) and binds
  only the train's; `a-pool-read-off-the-course` references one. Earlier receipts may stay as references.

How hashes and bindings are produced: by a kit script, not by hand. K2's `development/zk2-pool-with-course/kit/fill_records.py`
("Write K2's three records with the current hashes … usage: python3 -B fill_records.py [RECEIPT_TIMESTAMP]"):
`sha(path) = hashlib.sha256((ROOT / path).read_bytes()).hexdigest()` for every reference; "Without a receipt
timestamp the records are written without a receipt reference or proof binding (a draft for readers); with one, they
are bound to that core run", appending `{"path": <receipt>, "role": "receipt", "sha256": sha(<receipt>)}` and the
binding with `"sha256_pointer": "/source_sha256/Becoming.<Module>"`. `reviewed_at_utc` from
`datetime.now(timezone.utc).replace(microsecond=0).isoformat()`. Order consequence: a `recorded-checked` record can
validate only after the core run whose receipt binds the module's final bytes; the receipt's own sha256 is taken
from the committed run folder file. Hashes of the NOTE, READER, chapter and sources are taken last, after those files
are final; any later edit to them drifts the record (the cited-sections gotcha below).

Law families (`theories/becoming/results/data/law-families.json`): five families (census, sums-over-histories,
one-step, law-along-a-run, settling), each `{"id", "title", "lead", "members", "statement"}`; no regime or
capture family exists. RESULT-WORKFLOW line 69: "A new record that restates a family's law joins the family there
instead of repeating the statement"; `research.py check` verifies every member is a record, the lead is a member,
and no record is in two families. A new record need not join one.

`regions.json`, `records`: one entry per new record, `{"region", "base", "note"}`.
`test_a_results_region_is_its_homes_chapter` requires a record homed (`r-<id>` anchor) in 02 to have region `map`
(01 root, 02 map, 03 knowing, 04 life, 05 collective, 06 classical, 07 significance, 08 method).

## D. A new home section in `theories/becoming/chapters/02-MAP.md`

Current headings of 02 (513 lines): `## 1.` … `## 9. Capture` (line 396), `## 10. Readers the course removes`
(468, anchor `pool-from-course`, K2's), `## What this chapter does not show` (492, anchor `not-shown`), `## Open`
(502, anchor `open`). K2's template, inserted immediately before `<a id="not-shown"></a>`:

```
<a id="<section-anchor>"></a>
## 11. <Title>

<opening paragraph: what it takes from where, links to its neighbours>

<a id="r-<record-id>"></a>
**Theorem** (<base label>; witness). *<record title>.* <the law, Lean names in code, a link to the record page optional>

**Reading** [AI reading, …]. …
```

Every result's home anchor is `r-<record id>` (board line 29: "every live result stated once in its home section
(anchor `r-<record id>`) … From now on a landing updates its results' home sections, not the canonical chapter").
`navigation.py` links a record's page to `#r-<id>`; the theory graph makes each `r-<id>` a section node. A table row
carrying `r-<id>` anchors is the home of those records (gate.py `blocks`; 02 §5's regime table, lines 273-280,
is such a home). The `**Theorem** (<base>)` label follows 08's labels.

What else changes with it:

- `regions.json`: the record's region must be `map` for a home in 02 (test above).
- `theories/becoming/chapters/README.md`: generated ("Generated by tools/research/research.py render
  (tools/research/indexes.py)"), with per-chapter counts and reading times (02: "99 | 213–277 minutes"); it changes
  by the render only. `chapters/CLAIMS.md` is a generated stub ("Generated by tools/research/research.py render");
  nothing to edit. RESULT-WORKFLOW line 160: "Do not append status to generated pages (README, RESULTS, RESEARCH,
  ROADMAP, CLAIMS, GOALS, OPEN-QUESTIONS, DEPENDENCIES, study indexes)".
- No Chinese edition of the chapters exists (`chapters/` has no `*.zh.md`), so none is required. The Lean README's
  Chinese row is (A.7). The fronts' Chinese editions (ONE-PAGE.zh, THE-THEORY-OF-BECOMING.zh, USES.zh) change only if
  their English pages change; `test_chinese_fronts` reads them.
- Links in the opening paragraph to other chapters' sections (`07-SIGNIFICANCE.md#…`) are checked by `links`.
- Edits to existing 02 lines: 12 records reference `theories/becoming/chapters/02-MAP.md` by hash. Adding a section
  drifts none of them ("Added lines change nothing the record was reviewed against", line 61). Rewriting a line
  drifts a record if the line links its page, lies in a `##` section it cites by anchor, or comes before the first
  `##` (02's lines 1-16: the thesis, "Within the whole map", "Where this chapter sits", the bases). So: leave
  lines 1-16 and the existing homes untouched unless the re-saying is intended, and if a line in "## Open" (e.g.
  "Lifting §§2–9 onto the grammar …") is re-said, check which records cite `02-MAP.md#open`.
- The atlas (RESULT-WORKFLOW line 135): "A new result that states a dynamic adds or extends its entry in the same
  landing." Entries are hand-written in `theories/becoming/results/atlas/entries/dynamics.json` (with
  `premises.json`, `bindings.json`, `situations.json`, `correspondences.json`, `correspondence_groups.json`);
  `ATLAS.md`, `families/*.md`, `JOINS.md`, `TERRAIN.md`, `PREMISES.md`, `map.html` and `data/atlas.json` are
  generated (memory: "atlas.json is generated: edit results/atlas/entries/*.json"). `research.py check` fails on an
  entry whose record, declaration, anchor or test path does not resolve, or a dynamic marked good or bad.
- `gate.py restated` lists the live lines outside studies that link a changed home section or a changed record
  statement, for a reader other than the author (line 164).

## E. The study note folder

Location: `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/<item>/`
(REPOSITORY-LAYOUT line 106: "A study step, review or landing note | the live study …, not a new dated workspace").
Conventional contents, from the K folders:

- `zk2-pool-with-course/`: `DESIGN.md`, `NOTE.md`, `READER.md`, `kit/board.py`, `kit/fill_records.py`.
- `k3-reading-in-time/`: `DESIGN-v1.md`, `NOTE.md`, `READER.md`.
- `k1-readings-spread/`: `DESIGN.md`, `NOTE.md`, `READER.md`, `kit/fill_records.py`.
- `k4-route-b-on-atlas/`: `JUDGMENTS.md`, `NOTE.md`, `READER.md`, `reader-1.md` … `reader-7-astra.md`, `kit/*.py`, `kit/plan.json`.

`NOTE.md` opens with an AI-written line (K3: "# K3: reading in time (AI-written, Claude Opus 5.5, 10 November
2026)"), the board row and Ren's words, the module and home anchor and record ids, then the RESULT-WORKFLOW block
(lines 18-27):

```text
Result(s): …
Delta: …
Supplied premises / correspondence: …
Evidence: …
Boundary: …
Integration: …
```

then "What is proved" (each item with its declarations, marked substantive or near-definitional), "Failed
candidates and corrections kept" (the earlier design kept as `DESIGN-v1.md`, the reader's findings and what was
taken), "Readings, not proved". `READER.md` is the second reader's report; records cite it with role `review`, the
NOTE and DESIGN with role `integration`. For TT, the held attempt and its reader
(`tmp/r7/the-loop/lean/Becoming/TurningInTime.lean`, `tmp/r7/the-loop/readers/lean-reader-1.md`) are failed
candidates to keep: AGENTS.md "Keep counterexamples, failed candidates and failed tests"; `tmp/` is untracked
scratch (REPOSITORY-LAYOUT line 76: "Unique scratch work is saved into the right area before delivery").

Every file added there is counted by generated indexes (the study `INDEX.md`, `_process/research/README.md`), so it
needs the render (below). A `.lean` file anywhere in the tree, a study folder included, is catalogued in
`LEAN-INDEX.md` / `lean-index.json`.

## F. The commands, in order

0. **Claim.** TT's row exists (board line 56, claimed on `d7c380b25`). Any further item in the train (B) needs its
   row too (rule 1), or a widening of TT's row: TT's row lists "Not in scope: renaming existing Lean …, the instance
   theorems (`PoolFromCourse`'s course as a case of the model)", and nothing about editing RegimeMargin; a general law
   in RegimeMargin is new Lean in a module TT's row does not name. A claim commit carries only the board row (memory:
   a claim commit with a `sources/` file needs a render).
1. **Before heavy runs**: `uptime` and `ps` (CLAUDE.md); `python3 -B tools/research/gate.py status` shows the slots
   (`GATE_SLOTS`, two by default) and who holds them.
2. **Scratch build** while writing (board rule 5): `python3 -B LEAN/scratch_build.py TREE [MODULE ...]`, TREE
   holding `Becoming/TurningInTime.lean` (and a changed `Becoming/RegimeMargin.lean`). Writes only `TREE/.build` and
   `~/.cache/becoming-lean`; compiles, audits axioms, signs if in CHECKED, compiles from the prelude; no environment
   audit, no controls, no receipt. Its steps are the checker's, so the core run reuses them. `LEAN_TIMEOUT`
   defaults to 1800 here.
3. **Worktree**: a clean worktree you own, under `.claude/worktrees/` (line 164) or the owner's (TT: `/Users/ren/tmp/tt/wt`,
   branch `tt-turning-in-time`), switched to the branch. The gate refuses the shared checkout and any worktree
   with uncommitted, untracked or stray ignored `.lean`/document Markdown files (GATE.md §3.1).
4. **Head clause** on the Queue line, in a gap, behind every earlier claim: the Queue line is the single line
   starting `- **Queue:** ` (board line 40). K2's kit form: `"K2 at the head of the queue (landing now: … ; nothing
   paid); "` put first. Head-clause patterns the guard recognizes: "landing now", "landing run now", or "at (or
   holds) the head of the queue (" (GATE.md §3.5). While any head clause stands, no other commit to main.
5. **Merge main into the branch.** Read the whole merge output; on a `generated-manifest.json` conflict, restore
   main's copies of generated pages the manifest no longer matches (memory: manifest conflict).
6. **Core run**, Lean changed:
   `python3 -B tools/research/gate.py hold -- python3 -B LEAN/check_becoming.py` (gate.py STEPS, "core run").
   It ignores arguments: never pass `--help` (memory: "`--help` is a real core run that rewrites the receipt").
   Environment: `BECOMING_FRESH=1` runs every step; `BECOMING_JOBS` (default half the cores), `BECOMING_LEAN_SLOTS`
   (default the cores), `LEAN_TIMEOUT` (default 600), `BECOMING_OUT=<dir>` writes elsewhere and leaves the
   repository untouched (not for a landing). Writes: `LEAN/becoming-verification.json` (overwritten) and a new run
   folder `LEAN/becoming-checks/<stamp>/` holding `verification.json` (about 5.3 MB), `version.log`, the drivers and
   logs of the steps that ran (`<Flat>AxiomAudit.lean/.log`, `<Flat>Signatures.lean/.log`, `EnvironmentAudit.lean/.log`,
   `Controls.lean/.log`, `<Module>.PreludeOnly.log`, `<Module>.log`), and copies of sources and checker files that
   `main` does not hold byte for byte (5fab3baf4 added `Becoming.ReadOffInTime.lean`, `Becoming.lean`,
   `check_becoming.py` copies: 16 files, 167,404 lines). Recent times: the latest receipt
   (`20261110T172100.128611Z`, AG-L, docstrings) ran 1 step, reused 1,615, Lean wall 2.3 s; K train 36.3 s; K3
   44.8 s (Lean part only; the Python part, receipt discovery and writing, adds minutes). GATE.md §1: "a core run
   with Lean changed low | 1,450 to 1,500 of its 1,544 steps, 3.6 to 4.7 min at six jobs"; GT2's fresh run of all
   1,544 steps took 219 s. **Commit** the receipt and run folder (K3: 5fab3baf4; K train: f5f5a3023).
7. **Re-point and bind records**: fill the new records with the receipt (kit), rebind RegimeMargin's 11 records with
   `repoint.py --receipt … --lean …`, re-point the 10 receipt-file citers (`repoint.py --paths
   LEAN/becoming-verification.json --apply` after reading), each run once with `--reason` and `--apply`, one
   `rebinds.jsonl` line per landing.
8. **Shared laws**, after the core run passes and when a record's laws changed or the Lean changed:
   `python3 -B tools/research/gate.py hold -- python3 -B tools/research/shared_laws.py`; commit
   `theories/becoming/results/data/shared-laws.json` (RESULT-WORKFLOW line 143: "once `check_becoming.py` has passed
   on those sources, run the generator and then `make research-render`").
9. **Render**: `python3 -B tools/research/gate.py hold -- make research-render` (= `python3 -B tools/research/research.py render`),
   in the clean worktree, where the only untracked files are your own. GATE.md §1: about 2 to 4 min, 5.5 (LA4), over
   9 at load 60. Writes the generated views (K train's c04e68ef4: DEPENDENCIES, README(.zh), RESULTS,
   `generated-manifest.json`, study INDEX, `_process/research/README.md`, LINEAGE(.zh), `chapters/README.md`,
   LEAN-DECLARATIONS, LEAN-INDEX, RESULT-REGISTER, THEORY-GRAPH(.zh), the atlas pages, `data/atlas.json`,
   `lean-index.json`, `source-index.json`, `theory-graph.json`, COMPLETION …), record pages, and the mirror pages.
   It refuses unincorporated concurrent edits of generated pages. **Commit** them with the landing.
10. **Focused checks** (CLAUDE.md: run only what the change needs): `python3 -B tools/research/research.py check --ids <ids>`
    and `lint --ids <ids>` (style.py has no command of its own; its rules run inside `check` and `lint`);
    `make research-links` (6 to 9 s); `make gate-plan` lists what the change reaches.
11. **The plain gate**: `make gate` = `python3 -B tools/research/gate.py run --base main`, in the background with a
    log, run as a bare command (memory: `make gate && echo` carried a red gate to main). It runs the checks the
    changed paths select: `secrets`, `strict` (`research.py check --strict-fresh`, 1:56 to 3:21), `links`, one
    `test:<file>` per test file the paths reach, `board`, `frozen`, `receipt`, `dossiers`. A Lean change reaches,
    besides `strict` and `receipt`, at least `test_review_packet` (`LEAN/Becoming/**`), `test_theory_graph`
    (`Becoming/**`, chapters, regions), `test_classical_verifiers` (`Becoming/*.lean`, receipts), `test_completion`
    (`**/*.lean`, the core receipt), `test_strict_fresh` (the core receipt) and `dossiers`; a change to
    `check_becoming.py` reaches `test_checker_steps` and `test_style`; record changes reach `test_schema2`,
    `test_registry`, `test_shared_laws`, `test_boundary`, `test_architecture`, `test_navigation_pages`,
    `test_featured_results`, `test_indexes`, `test_rename_ids`. A pass is kept per tree and reused after main moves
    where the move touches nothing the check reads. `make gate` also prints `restated`.
12. **Landed clause**, one line, in place of the head clause; the TT row moves to
    `_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md` in the same commit (rule 4); the
    coordinator moves landed clauses to that history file "when more than five stand here" (board line 40, now five
    stand). Gate the board commit (`gate.py board` / `make gate`).
13. **Re-read the Queue line** right before `git merge --ff-only` (rule 5), then fast-forward main in the shared
    checkout with `git -C /Users/ren/theories merge --ff-only <tip>`; never `update-ref` the checked-out main.
14. **The full gate** is not part of a landing: `make gate FULL=1` (`--full`) runs every check, "once at a phase's
    end and before a push, reusing only passes kept on the same tree (`FRESH=1` with it reuses none)" (line 170);
    `make gate-push` runs the push screen from the remote's main; pushing is Ren's. A join of branches is not a
    full-gate checkpoint (CLAUDE.md).

What must be committed between them: the core run's receipt and run folder before the records are bound (records
need the receipt file to hash it); the records, chapter, regions, atlas entry, study files and the repoints before
the render; the render's output before the gate (the strict check fails on any page a render would change); the
board's landed clause after the gate passes on the content tip.

## G. Gotchas the documents record

1. **One Queue line.** The board guard (GATE.md §3.5): five sections, "exactly one Queue line", not a fifth shorter, no
   clause lost but head clauses. A landed clause written with newlines split the line (memory, 9 November: "lost 772
   clauses"); assert `'\n' not in landed`, and expect the board diff to be 2 insertions, 2 deletions.
2. **`grep -q` on the 120k-character Queue line** SIGPIPEs under pipefail; read it in Python. Board scripts match
   `at the head of the queue|at the head \(landing|\(landing now` (K2's `kit/board.py`).
3. **No commit to main while a head clause stands**, board lines and claim rows included (rule 5; GATE.md §3.5: "A
   board-only change is refused while the base's first clause is a head clause").
4. **Generated pages are never edited by hand**; a session that appended prose reconciles it and runs
   `research.py preserve-view` (line 164). `data/atlas.json` is generated from `atlas/entries/`.
5. **Render in a clean worktree**, not the shared checkout: "a render in the shared checkout lists other sessions'
   drafts and the next clean render reverts it" (line 164). Docs-only and gap commits that add files need a render
   too. Write run logs outside the repository and copy them in afterwards, or they make the study index stale.
6. **Cited sections frozen**: before editing a study note or chapter section, grep the records for its path; a record
   citing it drifts; add a new section instead (memory). The new TT records will cite their own NOTE/READER by hash,
   so those are final before `fill_records`.
7. **Hashes are never refreshed to silence a check** (line 49; repoint.py: "Never run it to silence a check: read each
   changed source first"). A re-point that changes nothing the record says needs no history note; a changed
   declaration list does.
8. **A comment edit to a bound source drifts its records** (memory: a one-line HTML comment fix to OPENING.md drifted
   seven records). For Lean, any byte.
9. **`check_becoming.py` ignores arguments**: `--help` is a full run in whatever checkout it runs in.
10. **Warnings fail the core run**, and stray `propext` from core `Nat` lemmas or overlapping match patterns fails the
    axiom audit (K3 NOTE).
11. **Links from a study note to `.lean` files** make that note the module's "Study" in LEAN-INDEX; name Lean files in
    code, link records and anchors; `File.lean:258` link forms fail `links` (memory, TM).
12. **The mirror**: `tools/research/mirror.py` mirrors each `##` section of `BECOMING-RENEWAL-READING.md`; a new study
    section there adds a page in the same render; a dangling "study section N" stops the render (memory). Only
    relevant if the landing appends to that study.
13. **The site**: RW's landings checked "a site build" (`tools/publishing/build_site.py`) and `test_site` exists;
    a landing that changes the fronts or the map's pages should build it. The reader's site is redeployed only on
    Ren's word.
14. **The map sheet** (`tools/research/map_sheet.py`) stops the render at an arrow whose law no reader has set against
    the Lean (board line 40). Only relevant if TT adds to `results/map/`.
15. **Merges**: never chain `git add` after `git merge`; read the whole output; "Unable to write index" is not a merge;
    merges can duplicate paragraphs (memory index).
16. **A fast-forward of the shared checkout stops at an untracked file at a path the landing adds**: compare, salvage a
    difference to `refs/salvage/…`, never delete (line 164). Never `git clean`/`prune` (AGENTS.md).
17. **The 10 receipt-file citers drift on every core run** (section B).
18. **`/private/tmp` is wiped after about three days unread**: keep kits and logs committed or under `/Users/ren/tmp`
    (line 164).
19. **Run the gate as a bare command**; a pipe's status is its last command's.

## What already exists that the held attempt needs (procedure only)

- The held attempt (`tmp/r7/the-loop/lean/Becoming/TurningInTime.lean`) is unregistered: no CORE entry, no SCOPE, no
  root import, no README rows, no regions entry; its scratch build ran no signatures step.
- The board's TT row says what is in scope; (B), a law in RegimeMargin, is outside it as written.
- The RegimeMargin docstring points on the board (line 72) are waiting for exactly the core run (B) causes.

## What I did not read or could not settle

- `research.py`'s `render` internals, `indexes.py`, `navigation.py`, `atlas.py` beyond grep: which generated pages a
  given landing writes is read from the K train's render commit, not derived.
- `tools/research/shared_laws.py` and `completion.py`: whether a new module or record changes `COVERAGE.json` or
  `THEOREM-CONNECTIVITY*` (the connectivity dump) obligations was not settled; the gate's plan (`make gate-plan`)
  says, and the completion check reads 08's premise card.
- How `scanned` resolves full names in nested namespaces and sections (`check_becoming.py` 4646-4660) was not read
  line by line, so whether every TT theorem is nameable by `#check @…` is settled only by a scratch build of the
  module once registered (the signatures step).
- `GATE_SLOTS`, the frozen check and the dossier check's specifics for this train were not traced.
- `_process/research-config.json` was only grepped (standard_boundaries, record_snapshots).
- Times of the render and gate for recent landings were taken from GATE.md's 4 November table; no log of the last
  week's renders was read.
