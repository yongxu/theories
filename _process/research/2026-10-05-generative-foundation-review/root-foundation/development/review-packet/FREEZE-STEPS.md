# The freeze: steps for its owner

*AI-written, 2 November 2026, from a rehearsal on a scratch copy of main at `2cab11114`. An independent AI reader read a draft and its findings were taken; no person has reviewed it. Twenty to twenty-five minutes to read. Each step says whether it was run. [What was run](#how-long-it-takes) ends in a release build of a scratch commit; no frozen commit exists yet.*

The release gate's [item 7](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#the-release-gate-30-october-2026) asks for one frozen commit, every dossier re-synced to it, the reader edition built with `--release`, and the sending decisions. The commands take under an hour. The re-sync is the work.

## Why the re-sync cannot be skipped

[`check_dossiers.py`](check_dossiers.py) checks that each quotation still occurs, that each Lean name still exists and that each copied Lean statement still reads as its source does. It cannot see a paragraph changing around a quotation, or a section an item points to now saying more. At `2cab11114` every check passed, and this much had moved under the dossiers ([the cold read's F3](COLD-READ-2026-10-25.md)):

| Dossier | Last read against its citations | Quote paragraphs changed or new | Linked sections changed | Linked whole files changed | Items to re-read | New results in its main chapters, not linked |
|---|---|---|---|---|---|---|
| Classical texts | `3f294b01c` | 0 of 41 | 27 of 50 | 7 of 7 | 25 of 38 | 1 |
| Buddhist thought | `3f294b01c` | 1 of 17 | 36 of 50 | 8 of 10 | 25 of 35 | 60 |
| Logic | `3f294b01c` | 13 of 47 | 44 of 55 | 2 of 3 | 25 of 29 | 69 |
| Philosophy | `33d06e9b7` | 15 of 135 | 9 of 29 | 0 of 1 | 11 of 27 | 2 |
| Alignment | `3ada8819f` | 0 of 109 | 8 of 20 | 2 of 13 | 3 of 20 | 11 |
| Sciences, if it joins | `b7b36ab74` | 81 of 258 | 7 of 20 | 2 of 7 | 22 of 23 | 86 |

Most flagged items stay true. Philosophy was re-synced in the rehearsal ([what it found](../rp2-philosophy/README.md#the-re-sync-of-2-november-2026)), so its last read is now `2cab11114`: its 11 items gave one addition, one sentence on what a standpoint is, and a few changes of wording. Logic, the most of the packet's five with 25 of 29 items flagged, was re-synced on 2 November 2026, so its last read is now `515c0d953`: twelve items changed, the shared laws, one root to its edge and premises met and failed now linked, and two statements the chapters had overtaken corrected (L-09 said no theorem joins 延 to dependent choice; L-03 cited the wrong decision). One independent reader's nine findings were checked against the sources and taken. The sciences dossier's pin is its last re-sync as a whole, on 27 October; later commits there touched single quotations. The whole-file column counts Markdown files, as the report then did; it now counts every linked file and folder, so a re-run's totals are higher (classical 10, Buddhist 16).

## Before starting

1. The way now's items 1 to 4 have landed. Each changes what readers are told, so a re-sync before them is done twice.
2. What would change the frozen commit has been put to Ren: [the board's Decisions](../../../../../BECOMING-WORKBOARD.md#decisions-pending-ren) gives a recommendation for each. None of it holds the freeze if he has not answered: [`COMMONS.md`](../../../../../../COMMONS.md), which says the work is not licensed, stays as it is; the first coder's twenty timed units stand in for a trial of the codebook; and the sciences dossier ([`SCIENCES.md`](../ue8-sciences-dossier/SCIENCES.md)) can join a later edition. If it joins, it moves into the review folder, it is re-synced with the others, and the cover's table, the builder's `PARTS`, the codebook's count of the dossiers, step 9's second path, the measure's lists and this page's table of what each reader is sent all change.
3. The coordinator has given the slot. As set on 2 November: logic is re-synced by RP's owner, alignment by AJ4's, the sciences dossier, if it joins, by UE8's; classical, Buddhist, the cover and what has moved under philosophy since its pin by the holder of this page. An owner no longer active hands over: check, then take it.

## The steps

Run from the root of a worktree of your own, outside `/private/tmp`, which a restart wipes:

```bash
git worktree add -b freeze <path> main
KIT=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet
```

Call C the commit of main you read the dossiers against, at first this branch's start. Keep your reports outside the tree.

**1. Report each dossier's drift (run).** The pin is the table's second column, philosophy's now `2cab11114` and logic's `515c0d953`. Under half a minute for all five.

```bash
python3 -B $KIT/resync_report.py 3f294b01c theories/becoming/review/CLASSICAL-TEXTS.md --out <scratch>/CLASSICAL-TEXTS.md
```

The report gives, item by item, each quotation whose paragraph changed, each linked section that changed as its changed spans, each linked file or folder that changed or is new since the pin, and the results new in the dossier's main chapters that it does not link. Whatever its summary counts gets a line, under each item that links it. An anchor it cannot follow is listed: read those by hand. The cover and the codebook cite little: read them whole.

**2. Read every flagged item against its chapter (run for philosophy only).** The dossier says what the chapter now says and no more. Three rules from the rehearsal:

- A report line is not a fault. Open the chapter and decide. A long insertion is cut in the report, so never judge one from the report alone.
- A new result goes in only where it bears on what the item asks this reader. Philosophy took the result on self-concern and C; it left holding for a reading to alignment, which already carries it. State every hypothesis the chapter states: the independent read of this step found two dropped.
- If a chapter has answered a dossier's question or removed a known weakness, say so in the item, with the date. Do not delete it silently.

Copy new Lean statements by script ([`lean_statements.py`](../rp2-philosophy/lean_statements.py); `Web.*` names need their full dotted form), since the checker compares every declaration in a Lean block with the sources, a definition whole and a theorem up to its proof. Run `python3 -B $KIT/check_dossiers.py` after each dossier. Record the pass in the dossier's *How this dossier was made* where it has one (philosophy, alignment), and move its pin in this page's table.

**3. An independent read of each changed dossier (run for philosophy).** One AI reader per dossier, read-only and with no part in the writing, given the diff, the chapter and the Lean; every finding taken or its refusal recorded. That is up to five agents, so state the count to the coordinator first. Check a reader's findings against the sources before taking them.

**4. Re-measure, and correct what the dossiers state (run for philosophy).**

```bash
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/kit/measure_layers.py
```

A moved time changes in three places: the dossier's own statement of its time, the row in `README.md` and in `README.zh.md`, and [READING-BUDGETS](../aj4-alignment-readers/READING-BUDGETS.md) lines 32 and 35. A front over budget keeps what amendment 1 says may not be cut and moves the rest down a layer; what it keeps beyond that it records, with the reason.

**5. If main has moved, merge it and re-run step 1 with the last C as the pin (not run).** The commit of main it brought is the new C. Repeat until nothing landed since is unread. The coordinator can shorten this by holding landings that change the chapters.

**6. Set the one pin a dossier states (not run).** `CLASSICAL-TEXTS.md` line 5 names the version it was checked against. Set it to C, with C's date. No other dossier states a commit it was checked against, and this goes last because C can move.

**7. Freeze which sampled units the dossiers quote (run).** This reads the final dossiers, so it comes after them, and its file belongs to the frozen commit.

```bash
python3 -B theories/becoming/review/recoding/agreement.py --write-quoted theories/becoming/review/recoding/SHEET.tsv
```

At `2cab11114` it wrote 23 units. [`FREEZE.md`](../../../../../../theories/becoming/review/recoding/FREEZE.md)'s three sha256 sums, for the sheet in its two forms and the key, matched; check them with `shasum -a 256`.

**8. Take the head and make D (run on the scratch branch; the head not taken).** Commit the dossiers, `QUOTED.txt` and the kit's pages on the branch with `git commit -m … -- <paths>`. Put the clause on the board's Queue line. Merge main into the branch: it must bring only the clause, and if it brings more, go back to step 5. Run `make research-render` and commit the views. The branch's tip is D. Because the landing is a fast-forward, D's hash does not change when main takes it, so the edition can be built before landing, and a defect stops the landing rather than a sent file.

**9. Run the gates on D in a clean detached worktree (run on the scratch commit, the full tests at `2cab11114`).** `git worktree add --detach <path2> D`, and from there:

```bash
make research-secrets
make research-check-strict
make research-links
python3 -B $KIT/check_dossiers.py
python3 -B $KIT/check_dossiers.py _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue8-sciences-dossier/SCIENCES.md
make research-test
```

**10. Confirm the dossiers were read against what D contains (run on the scratch commit).** The first command must print nothing. Read what the second lists: dossiers, the board, rendered indexes and the kit's pages, nothing else.

```bash
git diff --name-only C D -- theories/becoming experiments sources GLOSSARY.md ':!theories/becoming/review'
git diff --name-only C D
```

**11. Build the edition from D, in the same worktree (run on the scratch commit).**

```bash
python3 -B tools/publishing/build_review_packet.py --release
```

It refuses a dirty tree, a failing dossier check and an earlier release of another commit. It builds every part apart and refuses the edition if any part has a defect: checker markup left, a stray `*`, a link to nowhere, a glyph in the box font, a radical in the text layer, a local path. It warns if the one page runs past one sheet, and does not refuse for length (amendment 2). Only then does it write twelve PDFs, `SHEET.xlsx`, `SHEET.tsv` and a `MANIFEST.txt` of sha256 sums to `output/pdf/review-packet/`. Each part names D under its title and at the foot of every page; the codebook alone does not point to the repository. Then look with your own eyes at the first page of each file and at one page with Chinese and Lean, and confirm that the key is not among the files.

**12. Land, and keep what was sent (the sent files tested on the scratch commit; main not touched).** Re-read the Queue line, fast-forward main to D, and tag it locally with `git tag -a review-packet-1 D -m "…"`. In your branch's worktree, copy the folder over from step 9's worktree and commit it with the board's landed clause, so that what readers cite by page stays in the history (7 MB; it leaves the views as they were), and fast-forward main to that. A later edition first moves this folder to a `history/` beside it, and the builder refuses until it has. Pushing main and the tag is Ren's.

## What needs a person

[The board's Decisions](../../../../../BECOMING-WORKBOARD.md#decisions-pending-ren) gives a recommendation and its reason for each of these.

Ren's, before D: `COMMONS.md`, if it is to change; whether the sciences dossier joins; and whether one person tries the codebook first. The codebook says that its five to eight hours have not been tried by anyone, and asks coders to time twenty units. A trial takes twenty units outside the sample, on a small sheet made from the corpus, since [the codebook](../../../../../../theories/becoming/review/recoding/CODEBOOK.md) says its rules avoided the sample's units and a rule changed after trying them would make that false.

Ren's, after D and before anything is sent:

- **The covering letter.** The packet relies on it. [An AI draft](COVERING-LETTER-DRAFT.md) exists for his decision, one form for a reader and one for a coder, with [what the packet promises of it](COVERING-LETTER-DRAFT.md#what-the-letter-has-to-carry). Who signs it, its date and its terms are his, and nothing has been sent.
- **The recipients.** 146 of the 237 sampled units are from Buddhist texts, so a coder has to read those as well.
- **The push.** The remote's main, as last fetched, is at `74e2c9a69` (31 October), behind main by what `git rev-list --count origin/main..main` gives. An older review folder and `recoding-key.tsv` are already on it, so a coder's blindness rests on being asked not to look, as the codebook asks, and on not being sent a link. A letter must not name a tag the remote lacks.

What each reader is sent, from `output/pdf/review-packet/`:

| Reader | Files |
|---|---|
| Classical texts | `README.zh`, `ONE-PAGE.zh`, `THE-THEORY-OF-BECOMING.zh`, `CLASSICAL-TEXTS` |
| Buddhist thought | `README.zh`, `ONE-PAGE.zh`, `THE-THEORY-OF-BECOMING.zh`, `BUDDHIST-THOUGHT` |
| Logic | `README`, `ONE-PAGE`, `THE-THEORY-OF-BECOMING`, `LOGIC` |
| Philosophy | `README`, `ONE-PAGE`, `THE-THEORY-OF-BECOMING`, `PHILOSOPHY` |
| Alignment | `README`, `ONE-PAGE`, `THE-THEORY-OF-BECOMING`, `ALIGNMENT` |
| Sciences, if it joins | `README`, `ONE-PAGE`, `THE-THEORY-OF-BECOMING`, `SCIENCES` |
| A coder | `CODEBOOK`, `SHEET.xlsx` and `SHEET.tsv`, nothing else until the sheet is back |

## How long it takes

Measured on the scratch copy, three times, while other sessions ran Lean (machine load 25 to 90), so an idle machine does better. The estimates are marked.

| Step | Time |
|---|---|
| All five drift reports | under 10 s |
| Philosophy's reading, edits and independent read | about two hours of one session (an estimate), the reader's part about 20 minutes |
| The other four, at that rate | a few hours each for classical and Buddhist, under an hour for alignment (an estimate, not run); logic, run, about two hours of one session, the reader's part about 6 minutes; the sciences dossier, if it joins, about as long as logic |
| Measure, `--write-quoted` | seconds |
| Render | 119 to 334 s |
| Secrets | 13 to 45 s |
| Strict check | 121 to 262 s |
| Links | 6 to 11 s |
| The two dossier checks | 5 to 19 s together |
| Full tests | 1,554 s (one run) |
| The edition, twelve parts | 38 to 60 s at release; drafts 26 to 187 s by load |

So the head is held for 30 to 40 minutes at that load, 26 of them the full tests, and the whole freeze is a day or two of sessions if the owners work in parallel, plus whatever the queue holds. No Lean changes, so there is no core run.

## What the rehearsal changed

- [The builder](../../../../../../tools/publishing/build_review_packet.py). `--release` had no clean-tree guard and named no commit anywhere, so a reader could not tell which version they held. It now refuses as step 11 says, stamps each part with the commit, adds the one page, the overview and the codebook the cover sends readers to, drops dead navigation lines, sets quoted lines apart, and labels citations by what they are. It prints under its own Chrome profile and reads Chrome's own count of bytes written, because under load Chrome can write the file and then die in its teardown.
- [The glyph map](../../../../../../tools/publishing/build_xiaokang_datong.py). The radicals supplement has no compatibility decomposition, so 见, 门, 长, 民 and others copied from a PDF as radicals. They no longer do.
- [The checker](check_dossiers.py) now compares Lean blocks with the sources (none of 132 declarations was stale), and covers the codebook. [Its test](../../../../../../tools/research/tests/test_review_packet.py) has negative cases.
- [`resync_report.py`](resync_report.py) is new. It was corrected on 3 November 2026, after alignment's reader found a changed file missing from its report. Rows with no text of their own shared one key, so only the first whole file that changed printed as itself. A later one in the same item got no line (six in classical, two in Buddhist, one in alignment), and one under a later item got only "as under" an item that showed nothing. The summary's counts were right throughout. It also read heading anchors as not found, and did not look at other linked files or at files new since the pin. Now whatever it counts gets a line, and [its test](../../../../../../tools/research/tests/test_review_packet.py) holds that. Alignment's re-run gained one row this way, the goal section of its plan.
- Philosophy re-synced. In the classical and logic dossiers, the sentences that explained checker markup a reader never sees were reworded to read true in both forms; classical's said the repository held no 郭象注, which C-37 quotes from it. C-13's gloss of 生生 now matches chapter 6. The codebook's count of the dossiers is five, and it asks coders to time twenty units from across the sheet, since the sheet opens with 22 units of one text.
