# OU7's landing kit

One kit carries OU7's landing, both parts. It follows the pattern of U1b's kit (`development/u1-balance-under-units/u1b/land_u1b.sh`, landed with U1b) and of HE2's re-point.
- **Part A**, the corpus's conditional laws ([DESIGN.md](../DESIGN.md)), is in this folder.
- **Part B**, 验's model examples ([check/DESIGN.md](../check/DESIGN.md)), keeps its pieces where its review read them: [check/kit/](../check/kit/README.md) and `check/scratch/Becoming/`. This kit's scripts read them there.

No stage has run against the package in the repository. The rehearsal's Lean steps have run in copies outside it ([below](#checked)). The near-full rebuild comes last in the core round. No stage runs before OU's owner says.

## What the kit holds

| file | what it is |
|---|---|
| [Becoming/GrammarConditionals.lean](Becoming/GrammarConditionals.lean) | part A's core leaf, 41 declarations: 11 laws, `«依»`, one instance, one helper and 27 witnesses. It imports GrammarCandidates and GrammarLaws |
| `../check/scratch/Becoming/RoomNet.lean`, `RoomRuns.lean` | part B's two modules, in the instance ring. RoomNet has 120 declarations (94 theorems) and imports GrammarTesting, GrammarLaws, GrammarReadings and MapRegions. RoomRuns has 27 (24 theorems) and imports RoomNet, RegimeMargin and HeldPossible |
| [patches/](patches/README.md) | four patches. `Grammar.patch` and `GrammarReadings.patch` hold the two general laws below part A's leaf. `MapRegions.patch` changes its module doc, comments only, since it is no longer a leaf. `PLAN.patch` is the OU plan's line on beginning |
| [../check/kit/GrammarTesting.patch](../check/kit/GrammarTesting.patch) | part B's one clause in GrammarTesting's header, pointing to the toy derived in RoomNet; comments only |
| [patches/owner/](patches/README.md#the-grammars-owners-patches) | the grammar's owner's five patches, which the apply stage takes in name order after the kit's own. `01` holds the header items held from HE2, comments only: closure's list of cases gains `Response` and `SelectionPool`, "as the pairing is" goes, and the long lines are rewrapped. `02`–`04` hold the items held until BD2 landed, as OU's owner specified them: `«不出»`, `«闭则不出»` and `«所闭不出»` moved unchanged into GrammarLaws, after the closure law; `Flow.Cut` defined as `«不出»` at the valuation's relation; BD2's two equivalences for a region not crossed. `05` words GrammarScope's docstrings of `«续无外»` as its definition quantifies, comments only. `02` and `05` were re-cut on main at 624ba4b22, after the quick Lean review narrowed docstrings in both modules, and `02` now also words `«不出皆闭当且仅当排中»`'s docstring as 08 §2 and the module's doc state its standing, comments only ([why](patches/README.md#the-grammars-owners-patches)). What was held is kept in [patches/history/HELD.md](patches/history/HELD.md) |
| [stages/](stages/README.md) | extra patch sets that ride in the same rebuild, each its owner's: U4c's census as `10-u4c/`, then ND's names as `20-nd/`, each here as its owner's series. A stage is a directory of patches made against the tree after the kit's `apply` and the stages before it, applied patch by patch, with what the audit and the register expect of it, its re-point reason and its study paragraph. A stage that is empty or does not apply stops `apply`, nothing of it written; a `SKIP` file or `OU7_STAGES` leaves one out |
| [REHEARSAL.json](REHEARSAL.json) | the full rehearsal: the kit's and the stages' patches and the tree, each with its hash, the gate at the start, the build command, and the build's output with each of the 376 modules' counts and axiom report. The earlier rehearsals are in history: the owner's patches ([history/REHEARSAL-owner-patches.json](history/REHEARSAL-owner-patches.json)) and the kit's own ([history/REHEARSAL.json](history/REHEARSAL.json)) |
| [rehearsal_tree.py](rehearsal_tree.py) | the full rehearsal's tree and targets, from a dry run's tree: every Lean file apply changed or added, each checked against the synthetic receipt, and every module downstream of them |
| [home-06-section.txt](home-06-section.txt) | 06 §四's home section, in Chinese. It holds the 22-family table (Z, Y, the law, where Z fails, the standing, the units), G01's conjunction as text, the six false as read, the premises, the units back to 丁, the units not expressible and the definitions |
| [../check/kit/home-03-section-3.txt](../check/kit/home-03-section-3.txt) | 03 §3's home section for part B, after testing-within-the-net |
| [record-text.json](record-text.json), [make_record_ou7.py](make_record_ou7.py) | part A's record `conditional-laws-of-the-corpus`: its prose (AI-written) and its maker (`--draft OUT`, `--validate`, or `RECEIPT STUDY` at the landing) |
| [../check/kit/record-text.json](../check/kit/record-text.json), [make_record_ou7b.py](make_record_ou7b.py) | part B's record `rooms-tested-by-a-window`: its prose (AI-written) and its maker, with the same three uses |
| [integrate_ou7.py](integrate_ou7.py) | the landing's edits: `anchors`, `apply`, `audit`, `record`, `register`, `check`, `study` |
| [land_ou7.sh](land_ou7.sh) | the stages: `prepare`, `apply`, `run`, `post [N]` |
| [dry_run.py](dry_run.py) | the dry run, in a throwaway git tree whose one commit has main for its parent, with no Lean ([below](#checked)) |
| [stage_check.py](stage_check.py) | the stage handling, tested in a dry run's tree with two throwaway stages |
| [repoint_reason.txt](repoint_reason.txt) | the re-point's reason, for the records pinning a source the patches change |
| [assign.py](assign.py) | writes `data/groups.tsv` from `data/units.tsv` (a design step, not a landing step) |

## The landing

Run from the checkout root of the landing worktree, with `LOG` a folder outside the repository:

1. By hand: the head claim on the board, with its guard.
2. `LOG=… zsh <kit>/land_ou7.sh prepare` merges main, then the text review's commit ([front-refresh/MERGE](front-refresh/MERGE), dd95b4ba7, its ref checked unmoved). It merges that commit here because git cannot merge over the record stage's uncommitted edits to 01 and 08. Then it checks three things:
   - the ten patches apply to the merged tree as one series, in the order apply takes them;
   - the package has none of the three leaves yet;
   - every anchor of the joins and the home sections is found once (`integrate_ou7.py anchors`, which writes nothing).

   It lists the stages selected. Their series are checked at `apply`, after the joins they are made against. Last, `front-refresh/front_refresh.py --check` finds once each sentence the front refresh replaces, writing nothing.
3. `… land_ou7.sh apply` applies the patches in this order: Grammar, GrammarReadings, MapRegions, the plan, GrammarTesting, then `patches/owner/`. It copies the three leaves into the package and makes their joins:
   - **The root module.** Its imports and notes: part A's after GrammarLaws', part B's after RegimeMargin's.
   - **What imports what.** The notes and README rows that say what imports a module the leaves import:
     - GrammarCandidates' "A leaf." becomes "Imported by `Becoming.GrammarConditionals`.";
     - GrammarReadings and GrammarTesting add RoomNet, and HeldPossible adds RoomRuns;
     - MapRegions' note and rows say RoomNet imports it, and "kept in a leaf" becomes "kept in a module of their own".
   - **GrammarReadings' general law.** Its note and its scope sentence in the checker state it: what has a predecessor passes through where a class is constant both ways, and what abides is its case.
   - **The checker's lists.** Part A goes in `CORE` after GrammarLaws. Part B goes at the end of `INSTANCES`, and the ring's comment names the rooms among its carriers.
   - **The checker's scope sentences.** Part A's goes before GrammarTesting's, part B's two before Regulation's.
   - **The README rows, EN and ZH.** Part A's goes after GrammarLaws', part B's after RegimeMargin's. Part B's EN rows are its own; the ZH rows are this kit's. The ring's summary row names the rooms.
   - **The Lean catalogue.** Its description of the ring (`tools/research/lean_catalogue.py`) names the rooms. The index pages render from it, and the rooms join the ring's group from the receipt's layer.
   - **What the owner's patches change.** The root module's notes on GrammarLaws, GrammarCrossing and ConveyanceBoundaries, the README rows of GrammarLaws and GrammarCrossing, EN and ZH, and those two modules' scope sentences in the checker say where `«不出»`, `«闭则不出»`, `«所闭不出»` and the cut are now stated, and that the two count laws read as one.
   - **The reading of `«续无外»`.** SignificanceStatements' scope sentence in the checker and PHILOSOPHY.md's gloss read it as everything lying on every center's line, every center and every occurrence, as patch 05 words GrammarScope's docstrings. The text review's merge words the front pages so.

   Then each stage's series, in name order, patch by patch, each stage tried first on a copy of the files it changes. A stage with no patch, or one whose series does not apply there, stops `apply` with git's words, nothing of it written. Its owner then rebases the series, or the landing leaves the stage out with `SKIP` or `OU7_STAGES`, and OU7 lands without it (R10).

   Then the audit runs over every Lean source the patches changed, against HEAD, with comments blanked:
   - Grammar and GrammarReadings gain exactly `«位核含于逆核»`, `«生于逆核下不变»` and `«两向有常有前则通»`;
   - GrammarLaws gains exactly `«不出»`, `«闭则不出»` and `«所闭不出»`, which GrammarCrossing loses and which arrive unchanged, and the two equivalences;
   - no other declaration is removed, and every other statement is unchanged;
   - `«生于位核下不变»` and `«两向有常则通»` are proved as cases of the new laws;
   - `Flow.Cut`'s new body unfolds to its old one, and no other definition changes;
   - every other changed source keeps its code: GrammarTesting, MapRegions, ConveyanceBoundaries, BalanceRegions and GrammarScope;
   - the three leaves import what their notes say, and the plan line is replaced.

   Every selected stage must be in place, and each adds its `EXPECTED.json` ([stages/README.md](stages/README.md#expectedjson)). An owner's patch that changes code adds its expectation to the audit in `integrate_ou7.py`: what it adds to `EXPECTED`, a declaration it moves to `MOVED`, and a definition it rewrites to `REDEFINED`, with the body that must unfold to the old one.
4. `… land_ou7.sh run` runs the checker in place, or outside the repository with `OUT=DIR`. It runs on OU's owner's word.
5. `… land_ou7.sh post [N]` takes these steps in order:
   - **Records.**
     - 08 §3's receipt sentence, and its sentence naming the ring's members: the rooms join the instances, and the applications are counted from the checker. Main says six there, though `APPLICATIONS` has held seven since RF6.1 added OpenedCorrection.
     - 06's home section, at the end of §四, in place of the sentence that left the 丙一 laws unwritten. Then 06's seven lines: the thesis twice, §三's sentence on 通 and 息, its two lines on 通 (the general law), and the open items 丙一 and 穷 → 变 → 通.
     - 03 §3's home section for part B, and the toy's line pointing to it.
     - The two general laws, stated where the laws they generalize are:
       - 01 §4's paragraph on the two-way core;
       - in `continuation-relative-to-a-class` (law 5) and `classical-definitions-in-the-grammar` (law 4): the law, its declarations, the validation scope's counts from the receipt, and a history note.
     - generation-and-degeneration-at-two-grains: MapRegions is a core module, no longer a leaf, with a history note.
     - balance-from-conservation-along-a-relation: `«不出»` is GrammarLaws', with a history note.
     - the-continuation-condition-on-the-root: its correspondence reads the source in English as "everything lies on every center's continuing", with a history note. The Chinese 凡中心之续无外 stands.
     - The owner's two records, each with a history note:
       - master-laws-on-the-grammar: law 4 reads the two count laws as one law on regions not gone out of either way, and so does 01 §7. Law 4 and the GrammarLaws reference gain the two equivalences, and the validation scope takes the receipt's counts.
       - not-going-out-of-a-region: `«不出»`, `«闭则不出»` and `«所闭不出»` move to a GrammarLaws reference with a proof binding, and the validation scope takes the receipt's counts.
     - regions.json's five entries.
     - OU7's two records, bound to the receipt, each to its leaves only.
   - **Shared laws.** `master_laws.py` (named so until ND's part 2) runs, then OU7's check. The data must be the run's and must read both records' laws. The boundary report and the central figures must match main.
   - **Register.** The apart register.
     - The leaves' roots get their reasons: part A's from `reasons()`, part B's from its `apart-reasons.json`. Part B's 28 must be exactly the log's.
     - The owner's two equivalences are registered as roots of general structure, and each stage's roots as its `EXPECTED.json` gives them.
     - Entries for roots that the leaves' code or the patches' code now use are dropped, and part B's six must be among them. A root a patch moves keeps its entry, which now names its module: `«所闭不出»`, GrammarLaws.
     - Any other stale entry stops the stage, and a refused log leaves the register untouched.
   - **Study.** The study's section N: part A's block, then part B's, with the receipt and counts filled in, then a paragraph for each stage in place.
   - **Front pages.** `front-refresh/front_refresh.py` first checks item 2's figures (219, 22 and six) against the record conditional-laws-of-the-corpus as the record stage wrote it, and the two anchors it links. Then it applies OU's owner's texts ([TEXTS.md](front-refresh/TEXTS.md), kept as sent) to both editions of the one page and the overview, each to the sentence as it then stands, the four step-5 comments going with them. It writes READING-BUDGETS' two rows from one recount by AJ4's measure, and adds the recount to the front pages' measure runs. If a sentence it replaces is not found once, nothing is written. Run again, it finds every edit in place.
   - **Re-point.** One pass for the kit and every stage in place. The records pinning a source the patches changed are re-pointed from the drift that `research.py check` reports, and the Lean files' proof bindings are rebound to the receipt. The reason is the kit's, then each stage's, then the front pages' (`integrate_ou7.py reason N`).
   - **Checks.** Render, the strict check (no source drift left), links, both records' lint and the tests.
6. By hand: commit only the landing's paths, write the board's landed clause, re-read the Queue line, then fast-forward. The commit and the clause name only the stages in place (`integrate_ou7.py stages`).

Every edit asserts that it applies exactly once or is already in place, so a stage can be rerun after main moves.

**Before the re-point,** read each changed source with the records that pin it. On main at a91c84d35 the dry run's re-point takes exactly the registry's drift: 31 pairs in 24 records. With `10-u4c` in place, on main at 73b86ad76, it takes 295 pairs in 150 records. With both stages, on main at 5382b2435, it takes 419 pairs in 191 records: the kit's, as below, and those pinning what the stages change. Each stage's owner read theirs, and the pass joins their reasons.

| source | pinned by, drifting | bound by |
|---|---|---|
| Grammar.lean | 10 records | `continuation-relative-to-a-class` |
| GrammarReadings.lean | `classical-definitions-in-the-grammar` | the same |
| GrammarTesting.lean | `testing-within-the-net` | the same |
| GrammarLaws.lean | 6 records | 3 of them |
| MapRegions.lean | `generation-and-degeneration-at-two-grains` | the same |
| GrammarCrossing.lean | `not-going-out-of-a-region` | the same |
| Standpoints.lean | 5 records | the same 5 |
| ConveyanceBoundaries.lean | `conveyance-crosses-the-boundary` | the same |
| BalanceRegions.lean | `balance-from-conservation-along-a-relation` | the same |
| the OU plan | `continuation-relative-to-a-class`, `generation-and-degeneration-at-two-grains` | (a document) |
| 03 | `capture-by-counted-choices` and `exit-from-a-margin`, which pin it whole | (a document) |

A record that cites a chapter by section drifts only where a cited section is rewritten. So 01, 06, 08 and the study, where the landing's other changes add lines or rewrite sections no other record cites, add no pair. The two records pinning 03 whole drift on 03 §3's rewritten line on the toy.

What the patches would make false, the record stage has already corrected, each change with its history note:
- the two generalized laws;
- MapRegions as a leaf;
- `«不出»` as GrammarCrossing's, in balance-from-conservation-along-a-relation;
- the owner's items: master-laws-on-the-grammar's law 4, its declarations and counts, and not-going-out-of-a-region's references and counts.

Nothing else these records say changes:
- the two-way core still keeps beginning, abiding and ending, and what abides still passes through;
- the GrammarTesting, MapRegions, ConveyanceBoundaries and BalanceRegions changes, and GrammarCrossing's module doc, are comments only, and no record or chapter quotes the passages they change. GrammarCrossing's docstring of `«不出皆闭当且仅当排中»` is a comment too, and now calls the law what not-going-out-of-a-region and 01 §9.9 call it, a lemma of `«不外者内则不出当且仅当闭»`;
- GrammarLaws' other records state none of its counts and quote none of the passages the owner's patches change, and every statement in GrammarLaws and GrammarCrossing is kept;
- `Flow.Cut`'s new body is its old one unfolded. Law 7 of `conveyance-crosses-the-boundary` says the cut is `«不出»` at a valuation's relation "by definition", which the patch makes literal. Standpoints' other four records say nothing of the cut;
- `capture-by-counted-choices` and `exit-from-a-margin` say nothing of testing-within-the-net's toy.

The re-point itself writes no history note, by its rule that a history note comes with a changed claim, scope or declaration list. Its reason goes to `_process/architecture/rebinds.jsonl` instead. An owner's patch appends its reason to `repoint_reason.txt`.

## Decided on 1 November

These were the choices left open for OU's owner. The kit now makes each one, for the reason given; OU's owner may revisit any of them.

- **Each general law is stated where the law it generalizes is.** A change to a result's statement goes to its record and its home section. The Grammar patch generalizes law 5 of `continuation-relative-to-a-class`, whose home is 01 §4. The GrammarReadings patch generalizes law 4 of `classical-definitions-in-the-grammar`, whose home is 06 §三. The record stage states each law there, in the law's text, its declarations and its counts, each with a history note.
  - OU7's record names both laws in its prose and depends on both records. Its own laws name only its leaf's declarations, and it binds only its leaf.
  - Before this, part A's record listed the two laws among its own and was bound to Grammar and GrammarReadings as well. That stated each law twice.
- **Part B goes in the instance ring.** RoomNet and RoomRuns read general laws of the core on one named carrier, the rooms: testing's stages, the map's regions, constancy and the regime's runs. Nothing in the core imports them. That is what `INSTANCES` is for, as with the Changes and place/transition nets. In `CORE`, a later core module could import them as if they were laws. The ring says they are readings.
  - Every text that lists the ring's members names the rooms: the checker's comment, both READMEs' ring rows, 08 §3's sentence and the Lean catalogue's description.
  - The checker counts the ring like the core (`SPINE` and `PURE` hold both), and its one receipt gives each module a layer. So part B's register predictions and its record's proof bindings are the same in either list.
- **MapRegions is no longer called a leaf.** Once RoomNet imports it, "kept in a leaf" is false in its module doc, in its note in the root module, in its README rows and in one record's validation scope. All four now say "a module of their own" or "a core module", and the rows name what imports it. GW's history keeps "a core leaf", which was true when written.
- **GrammarReadings states the general law.** Its note in the root module and its scope sentence in the checker state the general law, with the old law as its case: what has a predecessor passes through where a class is constant both ways.
- **The toy points to its derivation.** testing-within-the-net's line on `«恒温与平衡»` in 03 §3 now says the toy's branches are stipulated. It adds that at a margin of one draw they are the steps of one rule of rooms, and points to part B's section.

The two records' prose is AI-written, in the two `record-text.json` files. OU's owner may keep, shorten or rewrite it.

## Checked

All checks ran on 1 November.

- **Record drafts.** `make_record_ou7.py --validate` and `make_record_ou7b.py --validate` ran the registry's own validation in this worktree. Each draft was checked in place, beside every record of the checkout.
  - Part A: one finding, because the leaf is not yet in the package. No other finding, and no lint finding.
  - Part B: two findings, because the leaves are not yet in the package. No other finding, and no lint finding.
- **Part B's names.** `check_record_b.py`: every declaration the record names was built, and there were no errors.
- **Dry run.** [dry_run.py](dry_run.py) ran on main at a91c84d35 (DU landed), merged into this branch as dfcd8d450, in a throwaway git tree. The tree held the main files the kit reads or writes, every record pinning one of them with every file it references, and this branch's study folder. Its one commit has main for its parent, so the registry reads every version a record was reviewed against, as in the checkout.
  - `prepare`: the nine patches applied as one series, and every anchor was found.
  - `apply`, run twice: the first run made every edit, the Lean catalogue's description of the ring and the owner's notes, rows and scope sentences among them. The second run applied nothing. The audit passed after each run:
    - Grammar gained exactly its two laws and GrammarReadings its one;
    - GrammarLaws gained `«不出»`, `«闭则不出»`, `«所闭不出»` and the two equivalences, and GrammarCrossing lost the three moved, which arrived unchanged;
    - Standpoints kept every declaration, `Cut`'s new body unfolding to its old one;
    - GrammarTesting, MapRegions, ConveyanceBoundaries and BalanceRegions changed in comments only.
  - `record`, run twice, against a synthetic receipt stamped at the run, after main's latest. That receipt was main's latest, with three additions: the patched sources' hashes, the patches' declarations (the moved ones in GrammarLaws), and the three leaves as checked. The stage wrote:
    - 08 §3's two sentences: the receipt's counts, and the ring's members with seven applications;
    - both home sections and 06's seven lines;
    - 01 §4 and 01 §7;
    - the two generalized records, with their counts and history notes;
    - the two records whose words the patches make false;
    - the owner's two records, master-laws-on-the-grammar at 179 theorems in 208 declarations and not-going-out-of-a-region at GrammarCrossing's 9 in 9, each with a history note;
    - regions;
    - OU7's two records.
  - The re-point took exactly the registry's drift, 31 pairs in 24 records ([above](#the-landing)), with the nine changed Lean files' proof bindings rebound to the receipt. No drift was left.
  - `register`: a log missing one of part B's predicted roots was refused, and the register was left untouched. Then the stage registered 32 roots: part B's 28, two of part A's and the owner's two equivalences. It dropped 12 entries the leaves and the patches now use, part B's six among them. `«所闭不出»`'s entry now names GrammarLaws. A third-party root was left for its owner. A rerun changed nothing.
  - `study`, run twice: section 490 was written once.
  - The 26 records OU7 writes, changes or re-points then went through the registry's validation and the lint, with no findings. Every lint warning is on a field already over its cap on main. The kit lengthens three laws: law 5 of `continuation-relative-to-a-class` from 473 to 506 characters, law 4 of `classical-definitions-in-the-grammar` from 520 to 554, and law 4 of `master-laws-on-the-grammar` from 1,322 to 1,364.
- **Stages.** [stage_check.py](stage_check.py) ran in the dry run's tree with two throwaway stages, after the real ones:
  - a stage of two patches that change one file, the second's context the first's line, was applied patch by patch; `git apply --check` over the two as one series fails there, as U4c's owner found;
  - the audit took its `EXPECTED.json`, and `apply` run again found it in place;
  - an empty stage and a stage whose patch does not apply each stopped `apply`, with nothing written;
  - `SKIP` left the second out, and the audit named it nowhere;
  - `OU7_STAGES` selected the stages taken; a stage applied but not taken failed the audit; and a name with no stage stopped the run.
- **A failed stage dropped.** A second dry run took two throwaway stages, one that applies and one that does not. The second was dropped and named, nothing of it written, and the run printed the `OU7_STAGES` the landing would take. The run went on with the first, every step taking it:
  - the audit took its `EXPECTED.json`;
  - the record stage counted its law in master-laws-on-the-grammar's scope, at 180 theorems in 209 declarations;
  - the register took its root, the study section its paragraph, and the joined re-point reason its line;
  - `integrate_ou7.py stages` named it alone, and 0 findings were left on the 26 records.
- **Dry run with both stages.** The dry run ran again on main at 5382b2435 (EL at the head of the queue), with `10-u4c` from branch `u4c` at d5d034614 and `20-nd` from branch `nd-stage` at 24d4aef64. Before the first `apply`, the dry run wrote a record of every stage in place, as an earlier apply on a tree since reset would leave it:
  - `apply` cleared that record when it applied the kit's own patches, then applied the stages' 33 and 43 patches one by one. Run again, it applied nothing and found both stages in place from the tree's record;
  - the audit took both `EXPECTED.json` files: `10-u4c`'s additions in seven modules, two cases, 15 declarations moved, 11 restated and four roots; `20-nd`'s 24 renames with three binders, four roots and four now used;
  - `record` filled the history notes of the stages' 33 records (1 November 2026, 2026年11月1日, study section 490) and set their `reviewed_at_utc`. Run again, it found nothing left to fill, and no record held a placeholder. master-laws-on-the-grammar's scope came to 192 theorems in 221 declarations;
  - the re-point took exactly the registry's drift, 419 pairs in 191 records, with 29 Lean files rebound. No drift was left;
  - `register` took 40 roots, four from each stage with the kit's 32, and dropped 16 entries now used, four of them `20-nd`'s. `study` wrote section 490 once;
  - the 195 records went through the registry's validation and the lint with no findings.

  With `10-u4c` alone, on main at 73b86ad76, the same steps passed: 22 records filled, 295 pairs in 150 records re-pointed, 36 roots registered, and no finding on 152 records. `stage_check.py` ran in each tree, after the real stages, and all 13 checks passed both times: the throwaway stages were found in place from the tree's record even after the record stage and the re-point had edited the stages' records.

  The synthetic receipt names a stage's new and renamed declarations as Lean does, with the namespaces open at their lines (`Becoming.Steps.along_fixed`, `Becoming.World.CensusMarksHold`). A renamed structure's constructor and fields take the new name with it. The tree holds every file a stage's records reference. U4c's owner found that without the first and the record of stages in place, the dry run gave one finding and `stage_check.py` stopped. Without the renamed names and the references, it gave `20-nd`'s 25.
- **Render, checks and tests.** On this branch at 7195ffa84, in a clean worktree: render (run again, nothing changed), the strict check (no error, no drift), links (0 broken in 1,970 files, the kit's documents among them) and the 305 tests all passed.
- **The rehearsals' Lean steps**, each in a tree outside the repository:
  - **The full rehearsal** ([REHEARSAL.json](REHEARSAL.json)), on 1 November from 03:55:51 to 03:58:26 UTC, inside the coordinator's gate (5-minute load 22.7, 60% of memory free, no other Lean run). Its tree is the 33 Lean files that the kit's apply and both stages change or add, taken by [rehearsal_tree.py](rehearsal_tree.py) from the dry run's tree on main at 9a01af14e, each checked against the synthetic receipt. Its targets are every module downstream of them, with the root: 376 of the package's modules, not only Persistence and Identity's importers, since the landing's core run rebuilds them all and reuses every step that passed.
    - `scratch_build.py` built their closure of 383 modules, nothing unclean: 225 compiled and 344 audited, 190 steps restored from the shared cache. The targets hold 18,670 theorems in 25,419 declarations; GrammarLaws 192 in 221, GrammarConditionals 40 in 41, RoomNet 94 in 120, RoomRuns 24 in 27.
    - Every axiom report is empty but FallibleInquiry's, a periphery bridge outside the tree, rebuilt as downstream of it, whose 17 declarations with axioms are exactly those of its own receipt.
    - A first build, started at 03:34:38, copied its tree after `stage_check.py` had added two throwaway theorems to GrammarLaws. It is not used, and `rehearsal_tree.py` now refuses any file the receipt does not record.
  - **Patch 05** ([REHEARSAL.json](REHEARSAL.json)'s `patch_05`), from 06:22:02 to 06:22:18 UTC, inside the gate (5-minute load 23.3, 54% of memory free, no other Lean run): on the full rehearsal's tree, with GrammarScope as the patch leaves main's file, GrammarScope and the four modules downstream of it, the root among them. 10 steps ran and 376 were reused. Nothing was unclean, and every axiom report was empty.
  - The owner's ([history/REHEARSAL-owner-patches.json](history/REHEARSAL-owner-patches.json); the counts are in [the patches' README](patches/README.md#checked)): the four patches on main's five files, beside four name checks, inside the coordinator's gate. It stands on a91c84d35: since its base, 8f11b43bd, main has changed only three new leaves and the root module, none of them in the closure it built. `scratch_build.py` built 53 modules, nothing unclean, every axiom report empty. Every name the patches move or define anew resolves as before, to its old statement, from GrammarCrossing, ConveyanceBoundaries, GrammarPath and BalanceRegions. Applied to main's files at a91c84d35, the patches make the tree's five files byte for byte.
  - The first ([history/REHEARSAL.json](history/REHEARSAL.json)): the kit's own patches and the three leaves, with the earlier owner patches, 145 modules, nothing unclean, every axiom report empty. Neither the kit's patches nor the leaves have changed since.
  - The rehearsals leave three things to the landing's core run: the checker's run with its new lists, its environment audit and controls, and the core receipt. It builds only what changes after the rehearsal's base, reusing the rest ([below](#what-waits)).
  - Earlier builds: part A's build 3 ([BUILD.json](../tree/BUILD.json)) and part B's scratch build, which is fork 2's ([check/scratch-build.log](../check/scratch-build.log)).

## What waits

- **The run.** No Lean runs for the rebuild until OU's owner says. The slot is last in the core round.
- **What changes after the full rehearsal.** Each is built alone at the landing, reusing the rehearsal's steps:
  - owner patch 05, GrammarScope's comments;
  - U4c's re-cut of `10-u4c` after its documents slot, record side only, so any Lean it changes is reported first;
  - main's Lean after 9a01af14e, UE28 first.

  `20-nd`'s patch 25 no longer applies on main: the collective page's text-review fixes (50655604a) rewrote the line under its §8 hunk, so its owner re-cuts it. The dry run then runs again on the main the landing merges.
- **The stages.** Each stage is its owner's series, made against the tree that this kit's `apply` and the stages before it leave. U4c's census laws are here as `10-u4c/` and ND's names as `20-nd/`, and the dry run and `stage_check.py` take both ([above](#checked)). If main moves under a stage before the landing, its owner re-cuts it on the main the landing merges. OU's owner tells the coordinator. The rename of master-laws-on-the-grammar's id is not a stage: it comes after the rebuild, last, in ND's own landing.
- **The landing's texts.** The commit message and the board's landed clause name the owner's items with the kit's: the two theorems new in GrammarLaws are BD2's text, `«不出»`, `«闭则不出»` and `«所闭不出»` move there, and `Flow.Cut` is defined as `«不出»`.
