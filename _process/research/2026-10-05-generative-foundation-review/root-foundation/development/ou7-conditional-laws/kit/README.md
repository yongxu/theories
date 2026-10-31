# OU7's landing kit

One kit carries OU7's landing, both parts. It follows the pattern of U1b's kit (`development/u1-balance-under-units/u1b/land_u1b.sh`, landed with U1b) and of HE2's re-point.
- **Part A**, the corpus's conditional laws ([DESIGN.md](../DESIGN.md)), is in this folder.
- **Part B**, 验's model examples ([check/DESIGN.md](../check/DESIGN.md)), keeps its pieces where its review read them: [check/kit/](../check/kit/README.md) and `check/scratch/Becoming/`. This kit's scripts read them there.

No stage has run against the package yet. The near-full rebuild comes last in the core round, after UE26, BD2, EL and UE27. No stage runs before OU's owner says, and a rehearsal stays in a scratch tree.

## What the kit holds

| file | what it is |
|---|---|
| [Becoming/GrammarConditionals.lean](Becoming/GrammarConditionals.lean) | part A's core leaf, 41 declarations: 11 laws, `«依»`, one instance, one helper and 27 witnesses. It imports GrammarCandidates and GrammarLaws |
| `../check/scratch/Becoming/RoomNet.lean`, `RoomRuns.lean` | part B's two modules, in the instance ring. RoomNet has 120 declarations (94 theorems) and imports GrammarTesting, GrammarLaws, GrammarReadings and MapRegions. RoomRuns has 27 (24 theorems) and imports RoomNet, RegimeMargin and HeldPossible |
| [patches/](patches/README.md) | four patches. `Grammar.patch` and `GrammarReadings.patch` hold the two general laws below part A's leaf. `MapRegions.patch` changes its module doc, comments only, since it is no longer a leaf. `PLAN.patch` is the OU plan's line on beginning |
| [../check/kit/GrammarTesting.patch](../check/kit/GrammarTesting.patch) | part B's one clause in GrammarTesting's header, pointing to the toy derived in RoomNet; comments only |
| [patches/owner/01-GrammarLaws-header.patch](patches/owner/01-GrammarLaws-header.patch) | the grammar's owner's held header items from HE2, comments only. Closure's list of cases gains `Response` and `SelectionPool`, "as the pairing is" goes, and the long lines are rewrapped. The apply stage takes every patch in `patches/owner/` in name order, after the kit's own |
| [patches/HELD.md](patches/HELD.md) | the grammar's owner's three items held until BD2 lands, with the Lean text of the third as BD2 sent it |
| [home-06-section.txt](home-06-section.txt) | 06 §四's home section, in Chinese. It holds the 22-family table (Z, Y, the law, where Z fails, the standing, the units), G01's conjunction as text, the six false as read, the premises, the units back to 丁, the units not expressible and the definitions |
| [../check/kit/home-03-section-3.txt](../check/kit/home-03-section-3.txt) | 03 §3's home section for part B, after testing-within-the-net |
| [record-text.json](record-text.json), [make_record_ou7.py](make_record_ou7.py) | part A's record `conditional-laws-of-the-corpus`: its prose (AI-written) and its maker (`--draft OUT`, `--validate`, or `RECEIPT STUDY` at the landing) |
| [../check/kit/record-text.json](../check/kit/record-text.json), [make_record_ou7b.py](make_record_ou7b.py) | part B's record `rooms-tested-by-a-window`: its prose (AI-written) and its maker, with the same three uses |
| [integrate_ou7.py](integrate_ou7.py) | the landing's edits: `anchors`, `apply`, `audit`, `record`, `register`, `check`, `study` |
| [land_ou7.sh](land_ou7.sh) | the stages: `prepare`, `apply`, `run`, `post [N]` |
| [dry_run.py](dry_run.py) | the dry run, in a throwaway git tree, with no Lean ([below](#checked-python-only-no-lean)) |
| [repoint_reason.txt](repoint_reason.txt) | the re-point's reason, for the records pinning a source the patches change |
| [assign.py](assign.py) | writes `data/groups.tsv` from `data/units.tsv` (a design step, not a landing step) |

## The landing

Run from the checkout root of the landing worktree, with `LOG` a folder outside the repository:

1. By hand: the head claim on the board, with its guard.
2. `LOG=… zsh <kit>/land_ou7.sh prepare` merges main, then checks three things:
   - the six patches apply to the merged tree as one series, in the order apply takes them;
   - the package has none of the three leaves yet;
   - every anchor of the joins and the home sections is found once (`integrate_ou7.py anchors`, which writes nothing).
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

   Then the audit runs over every Lean source the patches changed, against HEAD, with comments blanked:
   - Grammar and GrammarReadings gain exactly `«位核含于逆核»`, `«生于逆核下不变»` and `«两向有常有前则通»`;
   - no declaration is removed, and every other statement is unchanged;
   - `«生于位核下不变»` and `«两向有常则通»` are proved as cases of the new laws;
   - every other changed source keeps its code: GrammarTesting, MapRegions and GrammarLaws;
   - the three leaves import what their notes say, and the plan line is replaced.

   An owner's patch that changes code adds its own expectation to `EXPECTED` in `integrate_ou7.py`.
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
     - regions.json's five entries.
     - OU7's two records, bound to the receipt, each to its leaves only.
   - **Master laws.** `master_laws.py` runs, then OU7's check. The data must be the run's and must read both records' laws. The boundary report and the central figures must match main.
   - **Register.** The apart register.
     - The leaves' roots get their reasons: part A's from `reasons()`, part B's from its `apart-reasons.json`. Part B's 28 must be exactly the log's.
     - Entries for roots that the leaves' code or the patches' code now use are dropped. Part B's six must be among them.
     - Any other stale entry stops the stage, and a refused log leaves the register untouched.
   - **Study.** The study's section N: part A's block, then part B's, with the receipt and counts filled in.
   - **Re-point.** The records pinning a source the patches changed are re-pointed from the drift that `research.py check` reports. The Lean files' proof bindings are rebound to the receipt.
   - **Checks.** Render, the strict check (no source drift left), links, both records' lint and the tests.
6. By hand: commit only the landing's paths, write the board's landed clause, re-read the Queue line, then fast-forward.

Every edit asserts that it applies exactly once or is already in place, so a stage can be rerun after main moves.

**Before the re-point,** read each changed source with the records that pin it. On main at 89243dd5a they are:

| source | pinned by | bound by |
|---|---|---|
| Grammar.lean | 10 records | `continuation-relative-to-a-class` |
| GrammarReadings.lean | `classical-definitions-in-the-grammar` | the same |
| GrammarTesting.lean | `testing-within-the-net` | the same |
| GrammarLaws.lean | 6 records | 3 of them |
| MapRegions.lean | `generation-and-degeneration-at-two-grains` | the same |
| the OU plan | `continuation-relative-to-a-class`, `generation-and-degeneration-at-two-grains` | (a document) |

What the patches would make false, the record stage has already corrected, each change with its history note:
- the two generalized laws;
- MapRegions as a leaf.

Nothing else these records say changes:
- the two-way core still keeps beginning, abiding and ending, and what abides still passes through;
- the GrammarTesting, MapRegions and GrammarLaws changes are comments only, and no record or chapter quotes the passages they change.

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

## Checked (Python only, no Lean)

All checks ran on 1 November.

- **Record drafts.** `make_record_ou7.py --validate` and `make_record_ou7b.py --validate` ran the registry's own validation in this worktree. Each draft was checked in place, beside every record of the checkout.
  - Part A: one finding, because the leaf is not yet in the package. No other finding, and no lint finding.
  - Part B: two findings, because the leaves are not yet in the package. No other finding, and no lint finding.
- **Part B's names.** `check_record_b.py`: every declaration the record names was built, and there were no errors.
- **Dry run.** [dry_run.py](dry_run.py) ran on main at 89243dd5a, in a throwaway git tree. The tree held the main files the kit reads or writes, plus this branch's study folder:
  - `prepare`: the six patches applied as one series, and every anchor was found.
  - `apply`, run twice: the first run made every edit, the Lean catalogue's description of the ring among them. Grammar went from 115 to 117 declarations and GrammarReadings from 17 to 18. GrammarTesting, MapRegions and GrammarLaws changed in comments only. The second run applied nothing.
  - `record`, run twice, against a synthetic receipt. That receipt was main's latest, with three additions: the patched sources' hashes, the patches' three laws, and the three leaves as checked. The stage wrote:
    - 08 §3's two sentences: the receipt's counts (16 modules in the ring), and the ring's members with seven applications;
    - both home sections and 06's seven lines;
    - 01 §4;
    - the two generalized records, with their counts and history notes;
    - the corrected record;
    - regions;
    - OU7's two records.
  - The re-point of the three records the record stage changed.
  - `register`: a log missing one of part B's predicted roots was refused, and the register was left untouched. Then the stage registered 30 roots (part B's 28 and two of part A's) and dropped 12 entries the leaves now use, part B's six among them. A third-party root was left for its owner. A rerun changed nothing.
  - `study`, run twice: section 485 was written once.
  - The five records then went through the registry's validation and the lint, with no findings. The lint's six warnings are all on laws that were already over its 420 characters on main. The generalization lengthens two of them: law 5 of `continuation-relative-to-a-class` from 473 to 506, and law 4 of `classical-definitions-in-the-grammar` from 520 to 554.
- **Links.** `research.py links`: 0 broken, the kit's documents among the files checked.
- **Builds.** Part A's build 3 applied the two Lean patches to fresh copies of main's files at 8a1b06a3a and added the kit's leaf. Nothing was unclean, and every axiom report was empty ([BUILD.json](../tree/BUILD.json)). Part B's scratch build is fork 2's ([check/scratch-build.log](../check/scratch-build.log)).
  - No build of all three leaves with all six patches has run yet.
  - That build, on the latest main, is the rehearsal's Lean step. It waits until the machine-wide Lean hold lifts and fewer than two core runs are going.

## What waits

- **The owner's items after BD2** ([patches/HELD.md](patches/HELD.md)):
  - `«不出»` into GrammarLaws;
  - `Flow.Cut` restated with it;
  - BD2's two equivalences for a region not crossed.

  Each becomes a patch in `patches/owner/` once BD2 is on main, with its expectation in `EXPECTED` and its reason in `repoint_reason.txt`.
- **The rehearsal's Lean step**, in a scratch tree. It waits for the hold to lift, as above.
- **The run.** No Lean runs for the rebuild until OU's owner says. The slot is last in the core round.
