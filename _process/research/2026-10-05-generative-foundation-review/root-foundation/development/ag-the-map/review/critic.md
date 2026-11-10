# AG review: completeness critic

AI-written, 9 November 2026, 12:06 (UTC+7). This read the review's 21 finder and verifier outputs and 15 fix reports in this folder, the tree of `/Users/ren/tmp/ag/rv` (base `976e2bafb`, 132 files changed, nothing committed), and main at `70276b2f9`. I sampled the fix diffs for THE-THEORY, 07, 08, MAP, GLOSSARY, ALIGNMENT, experiments/README, the goal JSONs, the chain, the records and correspondences.json. Nothing was built, rendered or tested. The checks named below are substring checks I ran with small Python scripts, not the repository's checkers. The list runs from most consequential to least.

## 1. The fronts Ren quoted are still unfixed

About 120 of the 406 verified findings have no fix applied. They sit almost entirely on the layer a reader or agent meets first:

| File | Findings not applied |
|---|---|
| OPENING.md | 16 |
| BECOMING-WORKBOARD | 12 |
| USES.md | 11 |
| README-FIRST-SCREEN.md | 9 |
| THE-THEORY.zh | 9 |
| README-ZH | 7 |
| USES.zh | 7 |
| ONE-PAGE.zh | 6 |
| ONE-PAGE.md | 5 |
| USES-EXAMPLES.md | 5 |
| atlas.py | 9, counted across three finders |
| spine.json | 4 |

Smaller sets sit on the review cover in both languages, WHAT-REMAINS, WB's FOR-OTHERS, research-config.json, USES-EXAMPLES.zh, GLOSSARY.zh, connection_map.py and README-LEAD.

So README's "What this is", the sentence Ren quoted, still takes the purpose back in this tree. research-config.json's site `description` (the site's link preview) has no map and keeps the ethics tail.

The holds that kept these files out no longer apply. rw-iter4 landed at `a49c14850`, rw-zh10 at `9bfa31357`, and RW's eighth piece at `70276b2f9`. All three landed after this worktree's base.

## 2. Main has moved: new text was not reviewed, and 14 files need merging

The finders read `976e2bafb`. What landed after it was not read:

- **OPENING.zh.md** is new (116 lines). It mirrors OPENING's revised passages, including 其排序的前提陈述而不断言 and 选择诸律重述代理指标问题.
- **USES.md's new "At a glance" table.** One cell reads "Argued: T8, binding no one". The sciences row's "Not claimed" cell is "New mathematics". The table has a Standing column.
- **README-FIRST-SCREEN's new centre sentence:** "Its centre, as a reading: … the laws do not say whether that loss counts". The qualifier comes first.
- **Other changed text on main:** README-ZH, ONE-PAGE.zh, THE-THEORY.zh, CROSSWALK.zh, lineage.json (48 lines), zh_fronts.py's banners, build_site.py and the site config, and 11 re-pointed records.

Fourteen files were changed both on main and here:

- THE-THEORY-OF-BECOMING.md
- chapters 01, 02, 03, 04, 05, 07 and 08
- lineage.json
- records mutual-dependence-and-its-pace and relative-position-is-zero-sum
- navigation.py, indexes.py and theory_graph.py

Merge main first. Then re-locate every unapplied finding's quote on the merged tree, and give the post-base text above its own read.

## 3. The fixes break checks, and no fix group owned the checks

- **OPEN-QUESTIONS lead.** Three `navigation.py` OPEN_LEAD quotes no longer occur in their homes. These are `unasserted` (07: "Neither is asserted, and …"), `c-question` (08: "…; no warrant from outside is sought.") and `c-open` (08). `open_lead_errors` fails the render on any one of them.
- **Dossier quotes.** Seven dossier quotes no longer match their homes, even with ellipses allowed:
  - ALIGNMENT, from 03: "It is the proxy problem …"
  - ALIGNMENT, from 07: "Neither is asserted, and …"
  - LOGIC, from 08: the verdict sentence
  - PHILOSOPHY, from 07: "covers less than it may seem to" and "Neither is asserted, and …"
  - SCIENCES, from 03: "The main law holds by construction …"
  - SCIENCES, from 07: "Every law here is near-definitional …"
- **Test pins.**
  - `test_uses_pages.py:213` still pins 08's old "neither why alignment is hard nor a foundation".
  - `test_navigation_pages.py:295` pins "Neither is asserted, and neither is the account's own".
  - `test_spine` expects the picture key on the fronts, but spine.py's English key changed while ONE-PAGE.md line 17 and THE-THEORY line 30 still carry the old one. Its line 417 also asserts an anchor that `how_to_read` no longer gives.
  - `test_connection_map.py:160` pins "no warrant from outside is sought". It fails as soon as connection_map.py's finding is applied.
  - `test_featured_results.py:110` pins "We investigate how relations form". That pin made the BRIEF fix keep the old opening rather than the purpose line.
- **A kind of finding nobody looked for.** No finder covered `tools/research/tests/` or the checkers' quote tables. A pinned phrase keeps the old frame in place, or else it fails the gate.

## 4. The board still sets the old order

The process reader found 12 problems on the board, and none is applied:

- "The way now" repeats the old AGENTS items 1 to 3, followed by "Behind these in the queue, unless it changes what a reader is told".
- One item is "for when the text is ready for readers", and it now cites the before-copy (`AGENTS-before-the-map.md#what-moves-it`) as its authority.
- Line 103 says "His texts … revised by the work on argument ([AGENTS.md])". The new AGENTS.md no longer has that rule.

Every session claims through the board, so after AGENTS.md it is the agent-facing text read most. The plan sends "The way now" to Ren before it lands. Prepare that replacement now. Meanwhile, the lines that cite the replaced file as their authority can get a dated pointer.

## 5. Live text that no finder covered as an area

- **DELEGATED-CHOICES.md** (and .zh, 255 KB) is the register behind every "[AI reading, Dxx]" label. Its "Standard 1 restated" says "Ren's words are provenance, not warrant ([AGENTS.md] …)", a rule the new file dropped. In D45, line 319 says "(4) is not Ren's to state … provenance, not warrant". That is ai-over-aim. Its sections are cited, so list them rather than edit them. The header can carry a dated note.
- **aj-joint-selection/PLAN.md** is the home of the alignment goal, and finders read only its §1:
  - Line 20 still says "Both are named and neither is asserted", the tail cut from USES-EXAMPLES's copy of it.
  - §1 says condition 1's wording "had stood on a yes; it is replaced on the argument given". Nobody checked whether Ren read that change.
- **WHAT-REMAINS item 6, amendment 1, and READING-BUDGETS' never-cut list.** This is the gate rule that every layer keeps "each claim's standing … what is not claimed", the machinery that put a standing on every front sentence. Three lines were found and left unapplied. READING-BUDGETS was not reviewed, and its hold has now landed.
- **theories/meta-attractor/** holds the loop the new AGENTS.md names. Its dated "on the spine" paragraphs restate live laws, and it was not reviewed.
- **The banners on the 16 earlier folders** (7 November, hand-written in each README) say "every entry is an AI reading with no person's behind it" and "not carried is an outcome, not a defect". The same words were found in atlas.py's crosswalk lead, but not in these banners.
- **Cited studies:** BECOMING-RENEWAL-READING.md and .zh (26 phrase hits) and GENERATIVITY-CHAIN-INDEX-RECORD.md (16). List them, and point their headers to current wording.
- **Generated restatements:**
  - completion/COVERAGE.json, the shared law 'order' (the 08 fixer flagged it)
  - arguments-a-l.json (5 hits)
  - dynamics.json and its family pages, swept by pattern only
  - the Lean docstrings in Readings.lean, ListingValuation.lean and Becoming.lean ("(not asserted)"), which the module catalogue shows. Changing these needs a core run, so list them only.
- **Branches still on the old AGENTS.md:** rw-spine5 and rw-iter3 (both from 9 November, before `e9333346c`), cx-crosswalk, wb-within-becoming, tr2a-freeze and edition-5. A session that resumes on one of them reads the replaced rules until it merges main.
- **Codex's memory** (`~/.codex/memories/memory_summary.md`, 13 October) still describes this work as "preserves independently authorized scopes … a checked conditional result does not complete the universal foundation". It lies outside the repository and is not Claude's, so this is low priority.

## 6. Kinds of finding missing in areas that were covered

- **Purpose: none** in chapters 01–04, 07, the records and the sources. Chapters 02 and 05 now say what they map for alignment. 03 holds the laws of wisdom and 07 the alignment direction, and neither was asked what it is for.
- **Under-saying: none** in the records, dossier B and the experiments. A phrase sweep cannot find an absence. For example:
  - the plain lines of the meta-attractor records (closed-capture, drawn shaping, readers drawn from the selected, loss read in time), which RESULTS and the atlas show;
  - the LA1–LA3 test READMEs, and whether they say what they found for alignment.
- **AI over Ren's aim: none** found in OPENING. The opening's AI revisions are written in Ren's first person ("its ordering premise stated and not asserted", "The work's selection laws restate the proxy problem", "untested here"), and the finder classed them as defence.
  - Fixing them by rewording again in his voice repeats the pattern. Where a revision of 1 to 9 November only added a qualifier, restore version 12's sentence and correct the revised-passages line to match.
  - README-FIRST-SCREEN's comment rule, "the opening is revised in place to [current terms]", sets AI terms over his text. No finder caught it.
- **Consistency across fixes was not checked.**
  - "Map" now has two senses: the whole account, and chapter 2's map. GLOSSARY and THE-THEORY mark the difference, but every "the map" in the chapters still means chapter 2.
  - The chain's new intro defines meta-attractors in the corpus's working sense, which GLOSSARY calls another sense.

## 7. Fixes that may say more than is there, or drop something true

Most of the sample held: the purpose stays at "want", and "on models" and "AI reading" are kept. The removal of 871 "[AI reading]" tags from correspondences.json loses no label, since atlas.py renders "Reading [AI reading]:" for every entry and validates `labels`. The chain's cut scopes moved into its header note, and that note holds them. These need a second look:

- **alignment-direction-under-widening.json, does_not_show.** The review's verdict, "No result on alignment beyond the known proxy problem" (verbatim from BECOMING-SIGNIFICANCE-REVIEW), became "… the selection part restates the proxy problem qualitatively and adds the responsive closure and the pool …". A negative verdict is now a claim of what the work adds. Check it against the review and 07.
- **08 §8.** "What survives … none of them a discovery" became "What the review found new … what is new is the artefact, not its mathematics, in three things". The review gives the artefact and, separately, "a clarified ethics, not a grounded one". The second bullet is not the artefact, and "not a grounded one" is lost. Use the review's own words.
- **experiments/README.md.** "Most folders here are tests that could fail, their predictions and rules frozen before any run." Counting file names, 26 of 36 folders carry a freeze, prediction or design file, and TESTS notes a test whose data had already been seen (MQ2). Keep TESTS' qualifier.
- **The relabel "*Standing:*" to "*How far seen:*"** (15 lines added: 07 three times, ONE-ARGUMENT, the crosswalk) and the new "Kind" column still put a label on every paragraph. The uses verifier had warned that this swap is the pile-up a peer flagged. Where the label repeats the sentence's own qualifier, cut it.
- **08: "whether a universal practical warrant exists is kept as a question the account does not pursue".** The live goal normative-grounding.json and the open record universal-practical-warrant say otherwise. Either retire the goal, or say it as that record does.
- **theory-of-becoming.json.** The title and scope ("Priority since 8 October 2026") are goal wording that the fixer says should wait for Ren's read, but they sit in the working tree with everything else. Keep them out of the landing, or show them to him. Its scope also keeps "the scopes of independently authorized tasks".
- **Leftovers the fixers listed without owning:**
  - MAP.md line 13: "quoted as provenance, not as the warrant"
  - RESEARCH-DIRECTIVES line 5
  - the chain's C03: "with its warrant open"
  - the 2026-11-01 source: "forbid nothing"
  - the dated pointer for the 2026-10-13 source
  - aa-attractor-atlas/PLAN.md §2
  - wisdom-root-without-axiom.json: "The ethical warrant of judgment goes through"
  - goals/chinese-sources-and-becoming.json line 60, which restates 05's old gloss
- **Crosswalk fields that now restate nothing.** A substring count finds 23 fields in correspondences.json still restating chapter sentences the fixes removed, and the chapters no longer contain those sentences:
  - 02's "none of this ranks a locked loop" (13) and "nothing here ranks open rule-making above capture" (5)
  - 04's "no reproductive advantage is ethical authority" (2)
  - 05's "more tolerance gives no less, not that it is better" (1)
  - 03's "the warrant of judgment goes through" (2)

  The chapter fixers listed these by index. The correspondences fixer applied only the findings' own quotes.
