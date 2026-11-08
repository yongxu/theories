# How the theory repository presents itself: scores from seven reviewers and a checker

**Every reader here is an AI. No person has scored this or reported on it.** Seven AI reviewers scored it and an AI checker tested their findings against the tree. Their agreement is not the agreement of independent people, and it does not stand in for what the repository's order of work puts third: what people who have read it report.

State scored: tree `196b32e21`, site build `site-r3`, 2026-11-08.

**Result: five of the seven questions have a median below 8.** Q2 is 7.5; Q1, Q3, Q5 and Q7 are 7. Q4 and Q6 have a median of 8, and the checker puts Q4 at 7.5 and Q6 at 7.5 to 8. No reviewer gave any question above 8.

## Scores

The Chinese reviewer scored each question for a reader of Chinese, so its column is a narrower question.

| Question | First contact | Site | Unification | Growth | Uses | Navigation | Chinese | Median | Checker's view |
|---|---|---|---|---|---|---|---|---|---|
| Q1 Representable | 6 | 7 | 7 | 7 | 7 | 7 | 6 | **7** | About 7; zh 6 |
| Q2 Static site | 7.5 | 7 | 7.5 | 8 | 8 | 7 | 6 | **7.5** | 7 to 7.5 as built; the two 8s did not examine card times or chapter pages |
| Q3 Unification shown | 7 | 7 | 6.5 | 8 | 8 | 8 | 6 | **7** | 7 |
| Q4 How it grew | 8 | 8 | 8 | 7 | 8 | 8 | 7 | **8** | 7.5; the 7 read the most and found what the 8s missed |
| Q5 Value | 6 | 7 | 7.5 | 7 | 6 | 7 | 7 | **7** | 6.5 to 7, with a ceiling (see Q5) |
| Q6 Uses across fields | 8 | 8 | 8 | 8 | 7 | 8 | 8 | **8** | 7.5 to 8; the 7 read the most and its findings mostly hold |
| Q7 Valuable things visible | 7 | 7 | 7.5 | 7 | 7 | 7 | 6 | **7** | 7; zh 6 |

The site is scored as built. It has no public URL.

## What this rests on

- **Checked by script:** internal links in `site-r3`, 0 broken in three independent crawls; the published counts on the spine; cycles in the formal-reuse graph.
- **Looked at:** the pictures and main pages, rendered in headless Chrome.
- **Not done:**
  - No reviewer read the chapters through.
  - Nothing was fetched from GitHub, so GitHub rendering is inferred from file sizes.
  - Dark mode was read in the CSS and never rendered.
  - Restatements were checked against their homes only in the places the reviewers name.
  - Chinese against English was sampled, not audited line by line.
- **The checker's scope:** high and medium findings only. Low findings are reported as found.

## Blockers for questions below 8

**A constraint on every first-screen fix.** `READING-BUDGETS` row 27 has the first screen at 553 words against a 150 target, and the additions below come to well over 100 words. They need paired cuts, and the hedges in the lead cannot be those cuts. `_process/navigation/README-FIRST-SCREEN.md` generates `README.md` and the site home.

### Q1, median 7

| # | Blocker | File | Fix |
|---|---|---|---|
| 1.1 | The English landing never says the work was written with AI. The Chinese landing and ONE-PAGE do, and OPENING says it only in an HTML comment. | `README-FIRST-SCREEN.md`; `theories/becoming/OPENING.md` header | Add a clause such as "Written with language models, the Lean proofs included; the proofs are checked by machine, everything else only by automated review." ONE-PAGE's "with AI" fails `test_featured_results.py:339,342`. The file's comment records the omission as deliberate, so argue the rule: a front that hides authorship misleads. Say in OPENING's visible header that the listed passages were machine-written. |
| 1.2 | "In plain words" is not plain. | `README-FIRST-SCREEN.md` line 4 | Use short sentences with an everyday instance of the lock, then one sentence carrying the qualifiers together. Do not write an unqualified lead: a third-round reader already took a plainer one as findings the homes do not state. A second reader checks it against 05 and 02. |
| 1.3 | The landing does not say what the work is for, and its identity is in two unjoined pieces. "alignment", "coordination" and "wisdom" occur 0 times above the opening. | `README-FIRST-SCREEN.md` | Add one sentence of purpose ("alignment of trained systems" passes the test) and one joining the selection results to "An account". |
| 1.4 | After "none new mathematics" the reader is not told what is gained. | `README-FIRST-SCREEN.md`, "Lean receipts" | Copy 08 line 569, "Three things survive, none of them a discovery". Do not copy ONE-PAGE's gloss, which drops that qualifier. |
| 1.5 | "Grammar", "frozen" and "Lean" appear 3 times each, unglossed. | `README-FIRST-SCREEN.md`; `GLOSSARY.md`; `ONE-PAGE.md` root paragraph | Add one defining clause each at first use, glossary headwords, and a plain sentence before the root paragraph. |
| 1.6 | For a Chinese reader, the layer after the landing is calque. The project's name and its word for "account" also mislead. | `ONE-PAGE.zh.md`; `GLOSSARY.zh.md`; zh fronts | See findings 15, 11 and 32. |

### Q2, median 7.5

| # | Blocker | File | Fix |
|---|---|---|---|
| 2.1 | Card times mislead. "The eight chapters" says 18–24 minutes and the chapters take about 26 to 33 hours. "Check the proofs" says 1–2 minutes, the time to read the section. Tests, Results and Graph also show whole-page times. | `tools/publishing/build_site.py` `home_body`; `site.ways_in` in `_process/research-config.json` | Add a time override per card: "index 18–24 minutes; the chapters about 26–33 hours". State a run's duration only if timed. Add a test in `tools/research/tests/test_site.py`. |
| 2.2 | 115 result anchors in table rows have no status mark, though the home card promises each result one. | `build_site.py` Page | Emit the mark inside the cell, and test that marks equal anchors with records. |
| 2.3 | Chapter pages have no contents or previous/next links. The longest reading is worse on the site than on GitHub. | `build_site.py`; `site.css:62` | Generate a contents block from h2/h3, add prev/next links, and fix the `div.marks` margin. |
| 2.4 | Generated pages show two navigations. | `build_site.py` | Strip the `[Home](...)` line, as `first_screen` already does. |
| 2.5 | Wide tables are clipped. TESTS is cut at "Not" at 1280. On a phone, USES hides "What is not claimed". | `site.css`; `build_site.py` `_table` | Widen tables past the text column, cue overflow, and stack rows as labelled blocks on narrow screens. |
| 2.6 | There is no search over 667 pages, no 404 page and no favicon. | `build_site.py` | Generate `search.json` with a small script and write `404.html`; standard library only. |
| 2.7 | The home repeats the README, and the cards fall below the fold. | `build_site.py` `home_body`; `site.css` | Put the cards after "Start with", with the picture beside or after them. |
| 2.8 | Two published pages print a local path. | `experiments/motor-learning-cost/README.md`, `experiments/recipient-value-learning/README.md`; `build_site.py` `build()` | First check whether a frozen copy binds the text; if so, redact at build. Add a written-file scan for local paths. |
| 2.9 | Not reachable. | `.github/workflows/pages.yml`; `README-FIRST-SCREEN.md`; `MAP.md` | The owner's switch, after a push. It adds a public URL, the map without a clone, and resolving links. **It does not by itself reach 8.** Prepare the one-line URL so it lands in the same step. |
| 2.10 | The Chinese graph and crosswalk are off the site, and the header has no 对照表. | `site.pages`, `nav_zh` in `research-config.json` | Add both pages and the nav entry; link `connections.html` from CROSSWALK.zh, marked English. |

### Q3, median 7

| # | Blocker | File | Fix |
|---|---|---|---|
| 3.1 | The picture's form says more than its numbers. The title and hub with eight spokes read as unified; the measure is 11 of 117, and the spokes count modules. | `tools/research/spine.py` | Retitle to what is drawn and add a proportional 11/1/6/99 bar. Per-chapter standings are not the simple join a reviewer implied: they first need each central declaration placed in a chapter (`rw-spine/README.md`). |
| 3.2 | The five shared laws of 08 §7, the content of the unification, are on no front and in no picture. | `tools/research/theory_graph.py`; `ONE-PAGE.md`; `THE-THEORY-OF-BECOMING.md` | Add a five-row view with 08's terms: the counts sum to 120 over 126 rows, 87 rest on at least one, a row can rest on several, balance is represented and not derived. |
| 3.3 | The loom opens as a tangle, and the only form GitHub shows is the static one. | `connection_map.py`; `atlas.py`; `CROSSWALK.md` | Open on an aggregate or one folder. CROSSWALK already has a per-group relation table below the image: move or sum it above. |
| 3.4 | Solid curves read as machine-checked. | `spine.py` legend | Say who verifies. `registry.py:1104-1109` checks an interface contract where one is present, 365 of 1,162 edges have none, and nothing joins an edge to a Lean use. Give the count with an interface. |
| 3.5 | Headline terms have no glossary entry, and "spine" has two senses. | `GLOSSARY.md`; `spine.py` | Add headwords for grammar, edge of one root, central declaration, derived, named distance and formal-reuse. Resolve "spine" (`GLOSSARY.md` line 80). |
| 3.6 | The page never answers whether the foundation is circular. | `theory_graph.py` | Compute and print it on each render: no cycle in 1,162 recorded formal-reuse edges over 479 nodes. State it of recorded edges only. |
| 3.7 | T6 alone wears green, though it is only "not rejected", once at low power. | `spine.py`; `data/spine.json` | Use a neutral or hatched fill. |
| 3.8 | The 11 and the 99 cannot be followed from the graph page or the map (partly holds). `records/one-root-to-its-edge.md` does list them. | `theory_graph.py`; `connection_map.py` | Link to that record from the page and the bars, mark central results in the region lists, and add the plain-words table `rw-spine/README.md` lists as not done. |

### Q5, median 7

**Ceiling, from the checker:** no deployed test exists and new runs are held, so the value can be said more plainly but not made larger.

| # | Blocker | File | Fix |
|---|---|---|---|
| 5.1 | No statement of what a reader gets beyond Goodhart's law and the proxy and commons literature. | `README-FIRST-SCREEN.md`; `USES.md` top | Copy 08 §8 with "none of them a discovery", and keep ONE-PAGE's "the review finds each prohibition known in a neighbouring field". |
| 5.2 | The case tells the foreseeable and leaves out the striking. | `README-FIRST-SCREEN.md`, "One case"; source `experiments/direction-installation/README.md` | Carry 50 tons ending the bed against 30 keeping it at 40% of the catch, and 8 of 10 against 3 of 10. Name the three conditions, labelled "a reading" because of the token test. Keep "one model of two" and "frozen predictions mostly failed". Answer the four questions for the lake. |
| 5.3 | "Told of it and of the scope" is undefined where the case turns on it. | `README-FIRST-SCREEN.md`; `ONE-PAGE.md` line 9; `USES-EXAMPLES.md` line 20 | Shorten from `agents.py` DIRECTION: count everything that depends on what their fishing changes. README.zh already glosses it. |
| 5.4 | The audits have no closing statement of what they yielded (partly holds: the body does sort law, reading and empirical). | `USES-EXAMPLES.md`, both audits | End each with what is left and what a pipeline's owner would check next, marked as an AI reading. |
| 5.5 | The Chinese landing shows nothing of 古文. | `_process/navigation/README-ZH.md` | See finding 27. |

### Q7, median 7

| # | Blocker | File | Fix |
|---|---|---|---|
| 7.1 | The shared navigation is absent or partial on the hand-written fronts newcomers reach first. | `MAP.md`, `GLOSSARY.md`, `theories/README.md`, `ONE-PAGE.md`, `USES.md`, `USES-EXAMPLES.md`, `OPENING.md`, `THE-THEORY-OF-BECOMING.md`, `review/README.md`, `chapters/README.md`, `CROSSWALK.md` | Emit the same line through the generators where one exists, and a shared include or a required-line check for the rest. |
| 7.2 | No landing says which few results are worth seeing first, and the 15 links are flat. | `README-FIRST-SCREEN.md` or `README-LEAD.md`; site home; `tools/research/navigation.py` | Add a block of five or six items, each with its standing, paired with cuts. Group the links as Read, Check, See. |
| 7.3 | RESULTS opens on process language and an alphabetical 536-row table. | `research.py` render | Add a "Start here" list and a chapter column or grouping; move the maintenance sentences below. |
| 7.4 | OPEN-QUESTIONS omits the crux and publishes maintainer material, including a visible slug naming the owner (line 114). | Its generator | Open with the crux and the warrant of C in their homes' words, explain or drop D45, and move "Discovery and evidence" and "Preserved history" off the reader's page. |
| 7.5 | No search. | See 2.6 | |
| 7.6 | Lean checking is not one click from GitHub's first screen. | Nav generator; `README-FIRST-SCREEN.md`; README line 152 | Link `MAP.md#check-the-proofs-yourself` from the nav and "Lean receipts", and link "the Lean package". |
| 7.7 | The sticky nav omits Chapters, the overview and Results. Phones show three items, and the fade washes out 中文 on desktop. | `site.nav`; `site.css:104` | Add the entries, wrap under 600px, and apply the mask only on narrow widths. |
| 7.8 | 39 site links go to a 3.78 MB Markdown file GitHub does not render. 5,763 record-page links go to receipts over 1 MB. | Chapters 02–05 and experiment READMEs; `build_site.py` | Repoint to `mirror/BECOMING-RENEWAL-READING/NNN.md`, label raw receipts with their size, and add a check against live links to Markdown over 1 MB. |
| 7.9 | GitHub's README runs into the full opening with no ways-in table; the layers begin near character 66,500 of 86,600. | `research.py`, `readme_lead`/`readme_opening` | Put a compact table after the caption. |
| 7.10 | For a Chinese reader, the tests are English only, links fall into English unmarked, and the 古文 door is labelled 第六章. | See findings 10, 27 and 34 | |

### Q4 and Q6: median 8, checker lower

Neither has a median below 8, but the checker does not place either firmly at 8.

- **Q4 reaches a firm 8 with:**
  - the thread numbering fixed (`lineage.py:623`);
  - a sourced arc above "In brief";
  - a second thread;
  - a coverage paragraph (all in `lineage.json` and `lineage.py`);
  - evidence links in the Chinese edition.
- **Q6 reaches a firm 8 with:**
  - plainer "What you can do" cells;
  - the exits and design laws named at their standing, carrying "none shown to hold of an actual collective";
  - the additions for development and wisdom.

## Findings that hold, ranked

Ranked by the repository's own order. The checker found no high or medium finding failed outright. Of seven reported highs (five distinct), it found that two truly mislead a reader: ranks 1 and 2. It placed thread numbering, ONE-PAGE.zh and the missing Chinese tests at medium.

**What is false or misleading in what a reader is told**

| Rank | Finding | Where | Verdict | Fix |
|---|---|---|---|---|
| 1 | English fronts omit AI authorship | README, site home, OPENING | Holds (high) | 1.1 |
| 2 | Card times off by a factor of about eighty on the chapters | Site home | Holds (high) | 2.1 |
| 3 | Pass and fail words do not match TESTS classes: T1, MQ5, "the six" against seven T2 rows, UE32 | `USES.md`, `ONE-PAGE.md`, `USES-EXAMPLES.md`, `02` | Partly; T4 does not hold, since TESTS already explains it | Say "by setting". Add one sentence above By-thesis (`tests_page.py`). Change 02's "where MQ5 passed" too. |
| 4 | "Some passed, some failed" is vaguer and rosier than the page | `README-FIRST-SCREEN.md` | Partly; the proposed base of 66 is wrong | Render from `tests.json` the 36 naming a thesis: 4 passed, 4 failed, 18 mixed, 1 partly passed, 3 not rejected, 2 refused, 1 decided nothing, 2 held, 1 dropped. |
| 5 | Solid curves read as machine-checked | `spine.svg` | Holds, corrected | 3.4 |
| 6 | The picture's form says more than its numbers | `spine.svg` | Holds | 3.1 |
| 7 | T6 in green | `spine.svg` | Holds | 3.7 |
| 8 | 115 results lack the promised mark, with no visible difference from a checked one | Chapter pages | Holds | 2.2 |
| 9 | Lineage omits its coverage caveat and date basis | `lineage.json` | Partly; points 16–21 and 23 read "AI-drafted from a person's words", so the fill does not say the person stopped | Add TIMELINE line 7's caveat and a date basis. |
| 10 | A Chinese reader cannot see which tests failed | No `TESTS.zh.md`; inline 检验 links unmarked | Holds; a gap, medium | Generate a short front from `tests.json`, failures first. |
| 11 | 生成变化之论 conflicts with the glossary's 生成 | zh fronts, `GLOSSARY.zh.md` | Holds | Decide by argument, gloss it, add an entry, and use one term for becoming. |
| 12 | Thread numbers render wrong, sending a reader to the wrong row | `lineage.py:623` | Holds, medium; the bold date and title still identify each point | Emit bullets or a table with the number in the text, in both editions. |
| 13 | The scope in the landing case is undefined | 5.3 | Holds | 5.3 |

**What lets the account be wrong, and be seen to be**

| Rank | Finding | Where | Verdict | Fix |
|---|---|---|---|---|
| 14 | OPEN-QUESTIONS omits the crux | 7.4 | Holds | 7.4 |
| 15 | ONE-PAGE.zh is calque at the root and table rows. The T7 cell is 322 characters in six sentences, and the English cell is equally dense. | `ONE-PAGE.zh.md`, overview | Holds, medium | Rewrite in Chinese syntax with one example per row, copying the home's qualifiers first; another reader checks. Shorten the English T7 cell too. |
| 16 | Lean checking is not one click from GitHub | 7.6 | Holds | 7.6 |
| 17 | Circularity unanswered, though the answer favours the account | 3.6 | Holds | 3.6 |
| 18 | The 11 and the 99 are not reachable from the graph page or map | 3.8 | Partly | 3.8 |

**What a reader cannot yet get from it**

| Rank | Finding | Where | Verdict | Fix |
|---|---|---|---|---|
| 19 | No statement of what survives "none new mathematics" | 1.4, 5.1 | Holds | 1.4, 5.1 |
| 20 | The landing does not say what the work is for | 1.3 | Holds | 1.3 |
| 21 | The case undersold | 5.2 | Holds | 5.2 |
| 22 | The lead is not plain | 1.2 | Holds | 1.2 |
| 23 | Shared laws unseen | 3.2 | Holds | 3.2 |
| 24 | No narrative of why one phase gave way to the next | `LINEAGE.md`; `lineage.json` | Holds | Add a sourced arc of 150–250 words, drawing on TIMELINE's "The shape of the arc". |
| 25 | "What you can do" cells are the hardest in the table (54–97 words, undefined `hi`, `lo`, `c`) | `USES.md` | Holds | One plain sentence plus one link. |
| 26 | The most actionable material is not surfaced | `USES.md`, from `COLLECTIVE-DIRECTION` §2, §6 and 05 | Holds | Name them with "none shown to hold of an actual collective". |
| 27 | The Chinese landing shows nothing of 古文; the door says 第六章 | `README-ZH.md` | Holds | Add a short paragraph with 名取自古文 and 相合不是印证; relabel the door 古文（第六章）. |
| 28 | Only the selection strand is followed; 16, 35, 40 and 46 are untitled | `lineage.json`, `lineage.svg` | Holds | Add threads for root and ethics. |
| 29 | Folders not placed in the growth; 4 of 16 named in the evidence | `LINEAGE.md` | Holds | Per-folder table, or say plainly that the 48 follow two strands. |
| 30 | Terms unglossed on the first screen, in the lineage brief, and in the glossary | 1.5, 3.5; `lineage.json` | Holds | 1.5, 3.5; gloss T2, T7, C at first use. |
| 31 | Wisdom row covers Chinese texts only | `USES.md` | Holds | Add 03's reading [AI reading, D26] with "The matching proves no coverage of wisdom". |
| 32 | 本说明 and 本理论 alternate; 说明 reads as instructions | zh fronts | Holds | One rendering, recorded in the glossary. |
| 33 | Chinese lineage has no evidence links | `LINEAGE.zh.md` | Holds | Render the same links. |
| 34 | Chapter 06 entry and unmarked English links: 32 of 37 on ONE-PAGE.zh, 130 of 148 on the overview | `06-CLASSICAL-TEXTS.md`; zh fronts | Holds | Contents list, a short path, the dossier's 一小时之路, a gloss of 乙类; mark the links. |
| 35 | Opening unmentioned in Chinese | `README-ZH.md` | Holds | Table row now; prepare a labelled translation and list it for the owner. |
| 36 | Selection criteria of the 48 points unstated; 9 of 48 in the last week | `lineage.json` | Holds | Two sentences from `rw-spine/reads`. |
| 37 | Human development row hides material | `USES.md`, 04 lines 283, 286 | Partly; "Nothing claimed" can stand, and the valley is filed under 生生, not misfiled | Add the material beside it at its standing. |
| 38 | Audits have no closing statement | 5.4 | Partly | 5.4 |
| 39 | Revision list before the essay | README line 33; `OPENING.md` | Partly; the tonal preparation mostly exists | Shorten or fold the 219-word list. |
| 40 | No direct route on the home for an alignment reader; examples link missing | `USES.md` line 5; site cards | Partly; two cards name alignment | Add the examples link and bring the dossier forward. |

**Site and navigation**

| Rank | Finding | Verdict | Fix |
|---|---|---|---|
| 41 | Nav absent on hand-written fronts | Holds | 7.1 |
| 42 | RESULTS head | Holds | 7.3 |
| 43 | Links to oversized files | Holds | 7.8 |
| 44 | No ways-in table on the GitHub README | Holds | 7.9 |
| 45 | Chapter pages lack contents | Holds | 2.3 |
| 46 | Home cards below the fold, no search, no 404 or favicon | Holds | 2.6, 2.7 |
| 47 | Wide tables; USES and USES.zh on a phone | Holds | 2.5 |
| 48 | Sticky nav omissions | Holds | 7.7 |
| 49 | Zh graph and crosswalk off the site | Holds | 2.10 |
| 50 | Local paths on two pages | Holds | 2.8 |
| 51 | Spine is a static image | Holds | Site only: inline the SVG with links per node. |
| 52 | Loom's first view; map unusable on GitHub; the built pages still say "once it is published" | Holds | 3.3; the builder drops those clauses on the site. |
| 53 | Site's growth sources off-site | Partly; `pages.yml` builds from GitHub's main, so links resolve on a real deploy | Push first; add the 16 folder READMEs and TIMELINE to `site.pages`. |
| 54 | Site exists only locally | Holds; a status, not a defect | 2.9 |
| 55 | 审查包 assumes a mailed packet | Holds | Prepare a line and reply channel for the owner. |

## Claims that did not survive checking

Do not reuse these.

- **Site reviewer:** "with AI" stays within the tested rule. It fails the test.
- **Growth reviewer:** two unqualified sentences for the lead. That reopens an error a reader already caught.
- **Unification reviewer:** the Pages switch alone reaches 8. It adds reachability only.
- **First-contact reviewer:** the 66-test figure for "some passed, some failed". The right base is the 36 naming a thesis.
- **Growth reviewer:** the phrase "numbered as in the table" is not on the page, and 11 points are titled on the picture, not 13.
- **Site reviewer:** "2,272 chapter-level anchors" is wrong; the figure is 115. The reviewer corrected this itself.
- **Navigation reviewer:** nine and eight links to the large file is an undercount; it is 39.
- **Unification reviewer:** no check of formal-reuse edges exists. `registry.py` checks a contract where an interface is present.
- **Chinese reviewer:** the T7 cell is not a single sentence over 200 characters. Its link counts also differ from the checker's body-only counts.

## Low findings, reported and not put to the checker

**Bearing on what a reader believes:**
- "No test run so far has human participants" should read "no test of a thesis" (motor-learning-cost has 40 pairs).
- `MAP.md` says the formal theory was built "since October 2026", against LINEAGE rows 13 and 18.
- ALIGNMENT's "Most alignment work" is unsourced.
- The audit has three, four or five questions depending on the page.
- The map's 45/16/6/50 split has no bridge to 08 §7's 45/30/6/36.

**Surface:**
- Times disagree: the opening is 22–28 or 22–29 minutes, the one page 11–15 or 14–18.
- `lineage.svg` legend has empty entries.
- LINEAGE rows 36, 45, 47 and 48 give unlinked evidence, and it is unstated whether "a person" is one person.
- TIMELINE's end date and "Read next" paths are stale.
- Record pages print the raw `recorded-checked`.
- The chapters index carries file tables.
- `site.css` has dead rules, and `$V_4$` shows literally on one page.
- The map's filter chips are struck through when off.
- The spine is unreadable at 375 px.
- The graph page explains the picture four times.
- GLOSSARY lacks formation, thesis and room.
- `theories/README.md` has unglossed verdict heads.
- Named persons appear on 336 site pages, outside the front-page rule; decide whether provenance belongs on the site.
- Zh polish: synthetic italics, the brand link goes to the English home, the caption drops 约十分之一, 一个/一套文法, 这一屏, 附拼音.

## The owner's, prepared and not asked

- Pushing to the public remote, then the Pages switch, then the URL in README, `MAP.md` and the repository field.
- A public reply channel for readers who arrive at 审查包 by the site.
- A mirror reachable from mainland China; github.io reachability is general knowledge and was not tested.
- The Chinese wording of first-person text, if the opening is translated.
- A human reading of the Chinese fronts, and whether and when any person reads this at all.