# OU7's landing kit

One kit for OU7's landing, both parts, built on the pattern of U1b's kit (`development/u1-balance-under-units/u1b/land_u1b.sh`, landed with U1b) and HE2's re-point:
- **Part A**, the corpus's conditional laws ([DESIGN.md](../DESIGN.md)), is in this folder.
- **Part B**, 验's model examples ([check/DESIGN.md](../check/DESIGN.md)), keeps its pieces where its review read them, in [check/kit/](../check/kit/README.md) and `check/scratch/Becoming/`. This kit's scripts read them there.

No stage has run against the package. The near-full rebuild comes last in the core round, after UE26, BD2, EL and UE27, and no stage runs before OU's owner says. A rehearsal stays in a scratch tree.

## What the kit holds

| file | what it is |
|---|---|
| [Becoming/GrammarConditionals.lean](Becoming/GrammarConditionals.lean) | part A's core leaf: 41 declarations (11 laws, `«依»`, one instance, one helper, 27 witnesses), importing GrammarCandidates and GrammarLaws |
| `../check/scratch/Becoming/RoomNet.lean`, `RoomRuns.lean` | part B's two core leaves (120 declarations with 94 theorems, and 27 with 24). RoomNet imports GrammarTesting, GrammarLaws, GrammarReadings and MapRegions; RoomRuns imports RoomNet, RegimeMargin and HeldPossible |
| [patches/](patches/README.md) | `Grammar.patch` and `GrammarReadings.patch`, the two general laws below part A's leaf; `PLAN.patch`, the OU plan's line on beginning, accepted by OU's owner |
| [../check/kit/GrammarTesting.patch](../check/kit/GrammarTesting.patch) | part B's one clause in GrammarTesting's header, pointing to the toy derived in RoomNet; comments only |
| [patches/owner/01-GrammarLaws-header.patch](patches/owner/01-GrammarLaws-header.patch) | the grammar's owner's held header items from HE2, comments only: closure's list of cases gains `Response` and `SelectionPool`, "as the pairing is" goes, the long lines are rewrapped. The apply stage applies every patch in `patches/owner/` in name order, after the kit's own |
| [home-06-section.txt](home-06-section.txt) | 06 §四's home section, in Chinese: the 22-family table (Z, Y, the law, where Z fails, the standing, the units), G01's conjunction as text, the six false as read, the premises, the units back to 丁, the units not expressible and the definitions |
| [../check/kit/home-03-section-3.txt](../check/kit/home-03-section-3.txt) | 03 §3's home section for part B, after testing-within-the-net |
| [record-text.json](record-text.json), [make_record_ou7.py](make_record_ou7.py) | part A's record `conditional-laws-of-the-corpus`: its prose (AI-written, for OU's owner to keep, shorten or rewrite), and its maker (`--draft OUT`, `--validate`, or `RECEIPT STUDY` at the landing) |
| [../check/kit/record-text.json](../check/kit/record-text.json), [make_record_ou7b.py](make_record_ou7b.py) | part B's record `rooms-tested-by-a-window`: its prose (AI-written), and its maker, with the same three uses |
| [integrate_ou7.py](integrate_ou7.py) | the landing's edits: `anchors`, `apply`, `audit`, `record`, `register`, `check`, `study` |
| [land_ou7.sh](land_ou7.sh) | the stages: `prepare`, `apply`, `run`, `post [N]` |
| [dry_run.py](dry_run.py) | the dry run, in a throwaway git tree, with no Lean ([below](#checked-python-only-no-lean)) |
| [repoint_reason.txt](repoint_reason.txt) | the re-point's reason, for the records pinning a source the patches change |
| [assign.py](assign.py) | writes `data/groups.tsv` from `data/units.tsv` (the design's step, not the landing's) |

## The landing

From the checkout root of the landing worktree, with `LOG` a folder outside the repository:

1. By hand: the head claim on the board, with its guard.
2. `LOG=… zsh <kit>/land_ou7.sh prepare` merges main, then checks three things:
   - the five patches apply to the merged tree as one series, in the order apply takes them;
   - the package has none of the three leaves yet;
   - every anchor of the joins and of the two home sections is found once (`integrate_ou7.py anchors`, which writes nothing).
3. `… land_ou7.sh apply` applies the patches: Grammar, GrammarReadings, the plan and GrammarTesting, then `patches/owner/`. It copies the three leaves into the package and makes their joins:
   - the root module's imports and notes: part A's after GrammarLaws', part B's after RegimeMargin's;
   - the notes and README rows saying what imports a module the leaves import. GrammarCandidates' "A leaf." becomes "Imported by `Becoming.GrammarConditionals`." GrammarReadings and GrammarTesting add RoomNet, and HeldPossible adds RoomRuns. MapRegions' note and rows now say RoomNet imports it, and "kept in a leaf" becomes "kept apart";
   - the checker's lists: part A in `CORE` after GrammarLaws, part B after RegimeMargin in the list `B_LIST` names (`CORE` unless OU's owner says `INSTANCES`);
   - the checker's scope sentences: part A's before GrammarTesting's, part B's two before Regulation's;
   - the README rows, EN and ZH: part A's after GrammarLaws', part B's after RegimeMargin's (part B's EN rows are its own, the ZH rows this kit's).

   Then the audit runs over every Lean source the patches changed, against HEAD with comments blanked:
   - Grammar and GrammarReadings gain exactly `«位核含于逆核»`, `«生于逆核下不变»` and `«两向有常有前则通»`;
   - no declaration is removed and every other statement is unchanged;
   - `«生于位核下不变»` and `«两向有常则通»` are proved as their cases;
   - every other changed source (GrammarTesting, GrammarLaws) keeps its code;
   - the three leaves import what their notes say, and the plan line is replaced.

   An owner's patch that changes code adds its own expectation to `EXPECTED` in `integrate_ou7.py`.
4. `… land_ou7.sh run`: the checker in place, or with `OUT=DIR` outside the repository. It runs on OU's owner's word.
5. `… land_ou7.sh post [N]` takes these steps in order:
   - **Records.** 08 §3's receipt sentence. 06's home section, at the end of §四, in place of the sentence that left the 丙一 laws unwritten, and 06's four lines: the thesis, §三's sentence on 通, and the open items 丙一 and 穷 → 变 → 通. 03 §3's home section for part B. regions.json's five entries. The two records, bound to the receipt: part A's to the leaf, Grammar and GrammarReadings; part B's to its two leaves.
   - **Master laws.** `master_laws.py`, then OU7's check. The data must be the run's and read both records' laws. The boundary report and the central figures must match main.
   - **Register.** The apart register.
     - The leaves' roots get their reasons: part A's from `reasons()`, part B's from its `apart-reasons.json`. Part B's 28 must be exactly the log's.
     - Entries for roots that the leaves' code or the patches' code now use are dropped. Part B's six must be among them.
     - Any other stale entry stops the stage, and a refused log leaves the register untouched.
   - **Study.** The study's section N: part A's block, then part B's, the receipt and counts filled.
   - **Re-point.** The records pinning a source the patches changed are re-pointed from the drift that `research.py check` reports, and the Lean files' proof bindings are rebound to the receipt.
   - **Checks.** Render, strict check (no source drift left), links, both records' lint and the tests.
6. By hand: commit only the landing's paths, write the board's landed clause, re-read the Queue line, then fast-forward.

Every edit asserts that it applies exactly once or is already in place, so a stage can be rerun after main moves.

**Before the re-point,** read each changed source with the records that pin it. On main at 753460b81 they are:

| source | pinned by | bound by |
|---|---|---|
| Grammar.lean | 10 records | `continuation-relative-to-a-class` |
| GrammarReadings.lean | `classical-definitions-in-the-grammar` | the same |
| GrammarTesting.lean | `testing-within-the-net` | the same |
| GrammarLaws.lean | 6 records | 3 of them |
| the OU plan | `continuation-relative-to-a-class`, `generation-and-degeneration-at-two-grains` | (a document) |

None of them says anything the patches make false:
- the two-way core still keeps beginning, abiding and ending, and what abides still passes through;
- the GrammarTesting and GrammarLaws changes are comments only, and no record or chapter quotes the passages they change.

Part B suggested a history line in `testing-within-the-net`. The re-point tool writes none, by its rule that a history note comes with a changed declaration list; the reason goes to `_process/architecture/rebinds.jsonl` instead. An owner's patch appends its reason to `repoint_reason.txt`.

## Checked (Python only, no Lean)

All on 31 October.

- **Record drafts.** `make_record_ou7.py --validate` and `make_record_ou7b.py --validate` ran the registry's own validation in this worktree, each draft in place beside every record of the checkout.
  - Part A: 4 findings, all because the kit is not applied (the leaf's path and the three declarations the patches add). No other finding and no lint finding.
  - Part B: 2 findings, both because the leaves are not in the package. No other finding and no lint finding. Its validation scope comes to 530 of 600 characters in English and 194 of 260 in Chinese.
- **Dry run** ([dry_run.py](dry_run.py)) on main at 753460b81, in a throwaway git tree holding main's files that the kit reads or writes, with this branch's study folder:
  - `prepare`: the five patches applied as one series, and every anchor was found.
  - `apply`, run twice. The first run made every edit. Grammar went from 115 to 117 declarations and GrammarReadings from 17 to 18, and GrammarTesting and GrammarLaws changed in comments only. The second run applied nothing again.
  - `record`, run twice against a synthetic receipt. The receipt was main's latest, with the patched sources' hashes, the patches' three laws and the three leaves added as checked. The run wrote 08 §3's sentence, both home sections, 06's four lines, regions and both records.
  - `register`: a log missing one of part B's predicted roots was refused, with the register untouched. Then 30 roots were registered (part B's 28 and two of part A's) and 12 entries the leaves now use were dropped, among them part B's six. A third-party root was left for its owner, and a rerun changed nothing.
  - `study`, run twice: section 482 was written once.
  - Both records then went through the registry's validation and the lint, with 0 findings.
- **Patches against main.** All five apply to main at 753460b81, in order.
- **Builds.** Part A's build 3 applied the two Lean patches to fresh copies of main's files at 8a1b06a3a and added the kit's leaf; nothing was unclean, and every axiom report was empty ([BUILD.json](../tree/BUILD.json)). Part B's scratch build is fork 2's ([check/scratch-build.log](../check/scratch-build.log)). No build of all three leaves with all five patches has run yet. That build, on the latest main, is the rehearsal's Lean step, and it waits for CPU.

## What waits

- **The owner's items after BD2.** These go in `patches/owner/` once BD2 has landed, named to sort after `01-`:
  - `«不出»` moves into GrammarLaws, with `«所闭之界»` and `«所闭不出»` stated once;
  - `Flow.Cut` in Standpoints becomes `«不出» V.related region`, keeping `Flow.cut_iff_notGoingOut`.

  Each changes code, so each adds its expectation to `EXPECTED` in `integrate_ou7.py` and its reason to `repoint_reason.txt`.
- **`CORE` or `INSTANCES`** for part B's leaves: `B_LIST` in `integrate_ou7.py`, `CORE` by default. Both meet the ring's conditions (part B's README). The ring's README rows sit in the same table, so only the list changes.
- **The run.** No Lean runs for the rebuild until OU's owner says.

## OU's owner's choices, not applied by the kit

- **GrammarReadings' note.** Its sentence in the root module ("what abides passes through where a class is constant both ways (`«两向有常则通»`)") stays true. A sentence naming the general law could replace it ([patches](patches/README.md#texts-that-name-the-two-laws)). The same holds for the checker's scope sentence for GrammarReadings.
- **Two records' declaration lists.** `continuation-relative-to-a-class` lists Grammar's declarations, and `classical-definitions-in-the-grammar` lists GrammarReadings'. Adding the new laws to either changes a declaration list, which takes a history note by the record's author. The re-point does not do it.
- **The notes the joins change.** MapRegions' "kept in a leaf" and "A leaf (board item GW)" are no longer true once RoomNet imports it. The kit writes "kept apart" and "Imported by `Becoming.RoomNet` (board items GW, OU7)"; the wording is GW's owner's to change.
- **The records' prose.** It is in the two `record-text.json` files.
