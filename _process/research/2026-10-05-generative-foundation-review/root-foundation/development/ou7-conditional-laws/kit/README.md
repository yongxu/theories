# OU7's landing kit

One kit for OU7's landing, built on the pattern of U1b's (`development/u1-balance-under-units/u1b/land_u1b.sh`, on branch u1b) and HE2's re-point. Part A, the corpus's conditional laws ([DESIGN.md](../DESIGN.md)), is complete here. Part B, 验's model examples ([check/DESIGN.md](../check/DESIGN.md)), joins once OU's owner has decided its Lean ([below](#what-waits)).

No stage has run against the package. The near-full rebuild comes last in the core round, after UE26, BD2, EL's core Lean and U1b, and no stage runs before OU's owner says.

## What the kit holds

| file | what it is |
|---|---|
| [Becoming/GrammarConditionals.lean](Becoming/GrammarConditionals.lean) | the core leaf: 41 declarations (11 laws, `«依»`, one instance, one helper, 27 witnesses), importing GrammarCandidates and GrammarLaws |
| [patches/](patches/README.md) | `Grammar.patch` and `GrammarReadings.patch`, the two general laws below the leaf; `PLAN.patch`, the OU plan's line on beginning, accepted by OU's owner |
| `patches/owner/` | not yet made: the grammar's owner's held items from BD2 and HE2 (`«不出»` into GrammarLaws, `Flow.Cut`, the GrammarLaws header), as `*.patch`, once BD2 has landed. The apply stage applies every patch there, in name order, after OU7's |
| [home-06-section.txt](home-06-section.txt) | 06 §四's home section, in Chinese: the 22-family table (Z, Y, the law, where Z fails, the standing, the units), G01's conjunction as text, the six false as read, the premises, the units back to 丁, the units not expressible and the definitions |
| [record-text.json](record-text.json) | the prose of the record `conditional-laws-of-the-corpus` (AI-written, for OU's owner to keep, shorten or rewrite); every field within its cap |
| [make_record_ou7.py](make_record_ou7.py) | the record: `--draft OUT`, `--validate` (the registry's validation in memory), or `RECEIPT STUDY` at the landing |
| [integrate_ou7.py](integrate_ou7.py) | the landing's edits: `apply`, `audit`, `record`, `register`, `check`, `study` |
| [land_ou7.sh](land_ou7.sh) | the stages: `prepare`, `apply`, `run`, `post [N]` |
| [repoint_reason.txt](repoint_reason.txt) | the re-point's reason, for the records pinning Grammar, GrammarReadings and the OU plan |
| [assign.py](assign.py) | writes `data/groups.tsv` from `data/units.tsv` (the design's step, not the landing's) |

## The landing

From the checkout root of the landing worktree, with `LOG` a folder outside the repository:

1. By hand: the head claim on the board, with its guard.
2. `LOG=… zsh <kit>/land_ou7.sh prepare`: merges main, then checks that every patch applies to the merged tree and that the package has no GrammarConditionals yet.
3. `… land_ou7.sh apply`: the three patches, then `patches/owner/`; the leaf copied into the package; its joins:
   - the root module's import and note (after GrammarLaws');
   - GrammarCandidates' note, whose "A leaf." becomes "Imported by `Becoming.GrammarConditionals`.";
   - the checker's core list (after GrammarLaws) and its scope sentence (after GrammarCandidates');
   - the README rows, EN and ZH (after GrammarLaws').

   Then the audit, from the sources with comments blanked, against HEAD. It checks four things:
   - Grammar and GrammarReadings gain exactly `«位核含于逆核»`, `«生于逆核下不变»` and `«两向有常有前则通»`;
   - no declaration is removed, and every other statement is unchanged;
   - `«生于位核下不变»` and `«两向有常则通»` are proved as their cases;
   - the leaf imports only GrammarCandidates and GrammarLaws, and the plan line is replaced.
4. `… land_ou7.sh run`: the checker in place, or with `OUT=DIR` outside the repository. It runs on OU's owner's word.
5. `… land_ou7.sh post [N]` takes these steps in order:
   - **Record.** 08 §3's receipt sentence. 06's home section, at the end of §四, in place of the sentence that left the 丙一 laws unwritten. 06's four lines: the thesis, §三's sentence on 通, and the open items 丙一 and 穷 → 变 → 通. regions.json. The record, bound to the receipt for the leaf, Grammar and GrammarReadings.
   - **Master laws.** `master_laws.py`, then OU7's check: the data is the run's, it reads the record's laws, and the boundary report and central figures match main.
   - **Register.** The apart register. The leaf's roots get their reasons. Entries for roots that the leaf's code or the patches' code now use are dropped. Any other stale entry stops the stage.
   - **Study.** The study's section N.
   - **Re-point.** The records pinning a source the patches changed are re-pointed from the drift that `research.py check` reports, and the Lean files' proof bindings are rebound to the receipt.
   - **Checks.** Render, strict check (no source drift left), links, the record's lint and the tests.
6. By hand: commit only the landing's paths, write the board's landed clause, re-read the Queue line, then fast-forward.

Every edit asserts that it applies exactly once or is already in place, so a stage can be rerun after main moves.

**Before the re-point,** read each changed source with the records that pin it. On main at 8a1b06a3a they are:
- Grammar.lean: ten records; `continuation-relative-to-a-class` binds it to a receipt;
- GrammarReadings.lean: `classical-definitions-in-the-grammar`, which binds it;
- the OU plan: `continuation-relative-to-a-class` and `generation-and-degeneration-at-two-grains`.

None of them says anything the patches make false. The two-way core still keeps beginning, abiding and ending, and what abides still passes through. If an owner's patch is added, append its reason to `repoint_reason.txt`.

## Checked (Python only, no Lean)

All on 31 October.

- **Record draft.** `make_record_ou7.py --validate`, in this worktree, ran the registry's own validation with the draft in place. It gave 4 findings, all from the kit not being applied: the leaf's path, and the three declarations the patches add. There were 0 findings elsewhere and no lint finding.
- **Dry run.** The dry run used a throwaway git tree holding main's files at 8a1b06a3a. It ran `apply` twice; the second run found everything in place. Then it ran `audit`: Grammar went from 115 to 117 top-level commands, GrammarReadings from 17 to 18, and nothing else changed. Then:
  - 06's home section and its four lines, each run twice;
  - regions;
  - `record` and `study` against a synthetic receipt, built from main's receipt 20261031T125855.282103Z with the leaf and the patched files' hashes added. This tested the 08 §3 sentence, the record's bindings to the three sources, and the study section with its rerun;
  - `register` against a synthetic connectivity log: two roots registered, two entries dropped, a third-party root left for its owner, a rerun clean, and an entry OU7 does not use refused.
- **Patches against main.** The two Lean patches and PLAN.patch apply to main at 8a1b06a3a.
- **Build 3.** It applied the patches to fresh copies of main's files, unchanged at 8a1b06a3a, and added the kit's leaf as it stands. Only the leaf and the checks re-ran after the module doc was rewritten. Nothing was unclean, and every axiom report is empty: Grammar 120 declarations, GrammarReadings 18, GrammarConditionals 41, the checks 17 ([BUILD.json](../tree/BUILD.json)).

## What waits

- **Part B.** Its leaves (RoomNet, RoomRuns), any record of its own and its study text wait on OU's owner's decision on its Lean. When decided:
  - its leaves go in `Becoming/` beside this one, with their joins added to `integrate_ou7.py`'s `join()`;
  - its record maker goes beside `make_record_ou7.py`;
  - its study text goes in `study-part-b.txt`, which `study()` appends to part A's block.
- **The owner's held items** from BD2 and HE2 go in `patches/owner/` once BD2 has landed.
- **The run.** No Lean runs for the rebuild until OU's owner says.

## OU's owner's choices, not applied by the kit

- **GrammarReadings' note.** Its sentence in the root module ("what abides passes through where a class is constant both ways (`«两向有常则通»`)") stays true. A sentence naming the general law could replace it ([patches](patches/README.md#texts-that-name-the-two-laws)). The same holds for the checker's scope sentence for GrammarReadings.
- **Two records' declaration lists.** `continuation-relative-to-a-class` lists Grammar's declarations, and `classical-definitions-in-the-grammar` lists GrammarReadings'. Adding the new laws to either changes a declaration list, which takes a history note by the record's author. The re-point does not do it.
- **The record's prose.** It is in record-text.json.
