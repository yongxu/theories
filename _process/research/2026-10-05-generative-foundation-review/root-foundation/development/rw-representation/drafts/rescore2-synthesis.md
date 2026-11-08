# How the theory repository presents itself: scores from seven AI reviewers and an AI checker

**Every reader here is an AI.** Seven AI reviewers each read through one lens, and an AI checker then re-checked their findings against the files. No person has scored any of this. Nothing below is a human reader's report.

**What was scored.** The tree at `/Users/ren/tmp/rw/wt2`. The reviewers read it at 1cce86922 and the checker at a980f79c5; the two differ only in the board. None of this content is on GitHub yet: origin/main is 805cff889, so a newcomer on GitHub today sees older pages. The site at `/Users/ren/tmp/rw/site2` was built from e4c5fa6a6 plus three uncommitted files, which 1cce86922 later committed.

**What was not done.**
- Nobody ran tests or builds, and nobody edited anything.
- The interactive map was not run in a browser.
- The site was viewed in a browser only in part: the growth and Chinese lenses viewed some pages, and the checker measured the home page at 1024px.

## Scores

Lenses: FC first contact, Site, Uni unification, Gro growth, Uses, Nav navigation, ZH Chinese.

| Question | FC | Site | Uni | Gro | Uses | Nav | ZH | Median | Checker's view |
|---|---|---|---|---|---|---|---|---|---|
| Q1 Representable from where a newcomer lands | 6 | 6 | 7 | 6 | 6 | 6 | 6 | **6** | 6 is right. The English first screen never says the work was made with AI, and it calls an AI review "A review". Only Nav caught this. |
| Q2 Static website: built, reachable, elegant, faithful | 6 | 6 | 7 | 6 | 6 | 6 | 6 | **6** | 6 is fair; Uni's 7 is generous. Reaching the site takes more than the reviewers said: `pages.yml` is not on origin/main, so it needs a push, then enabling Pages, then a dispatch, all the owner's. |
| Q3 Unification and connections shown elegantly and honestly | 6 | 6 | 7 | 6 | 7 | 7 | 5 | **6** | Fair. Two suggested fixes are already in: counts have halos, and pairs under 10 uses are not drawn. The labels collide anyway. |
| Q4 How the whole grew | 7 | 7 | 7 | 7 | 7 | 7 | 8 | **7** | 7 is fair; ZH's 8 is generous. LINEAGE.zh has the same uniform "public" labels and the same picture with 8 of 48 points titled. |
| Q5 Value said plainly, early, with a case, without overclaiming | 5 | 6 | 6 | 6 | 6 | 5 | 6 | **6** | Fair. The judge audit is less empty than the Uses lens said: it reads questions 4–5 beside LA2, and question 3 against published measurements. |
| Q6 Uses across fields at their true standing | 7 | 7 | 7 | 7 | 7 | 7 | 7 | **7** | Fair. The blockers are presentation only. The word counts were overstated: table cells run 36–125 words, not 100–200 or "hundreds". |
| Q7 Valuable things easy to see, navigation that leads | 7 | 6 | 7 | 7 | 7 | 6 | 6 | **7** | **The 6s are fairer.** The reviewers who gave 7 missed the one high finding: about 970 evidence links land on a 3.78 MB Markdown file that GitHub does not render. |

Every median is below 8. No question reaches 8 on what is there today.

## What holds each question below 8, after checking

### Q1 Representability (median 6)
1. **The English first screen never says the work was made with AI, and it calls the review "A review".** Lines 8–25 of README.md say neither. ONE-PAGE.md:7, THE-THEORY-OF-BECOMING.md:11 and README.zh.md all say both.
   - **File:** `_process/navigation/README-FIRST-SCREEN.md`, the source of README.md's first screen.
   - **Fix:** add ONE-PAGE.md:7's sentence ("Made with AI, proofs included…") and change "A review" to "An AI review". This names no AI, so the first-screen test still passes.
2. **No plain-words lead, and the case's lesson is left unsaid.** "Lock", "one relational unfolding", "C", "central declarations" and "grammar laws" all come before any gloss. "Couples into" already has its inline gloss "(what it reads or needs)". The case stops at its outcome and never says that the bed is what the fishers' selection does not read.
   - **File:** the same first-screen source.
   - **Fix:** add one plain lead sentence, one gloss for "lock", and one sentence giving the case's lesson.
   - **Two cautions:**
     - If the proxy/Goodhart problem is named, it must keep note 11's limit: the account restates only its blindness to what a proxy does not register, not its regressional or causal kinds.
     - Do not use First contact's sample sentence ("what it destroys there"). It overclaims: the drain is proved at optima where there is room, and T3 is a conjecture for trained systems.
3. **The opening follows the first screen on GitHub with no label under its heading.** The heading is "## Truth exists", and the lines quoted are at README lines 51 and 53. The finding is only partly right: README line 35 already links the one page and the uses page before the opening's prose.
   - **File:** README.md (its opening source).
   - **Fix:** put one visible line under the heading, for example "A first-person conviction, not the account's claims; each note gives its sentence's standing." Moving the opening off the README, as the site already does through `site.aliases`, changes where the author's text sits. That needs an argument and a before-copy.

### Q2 Static website (median 6)
1. **The site is not reachable.** `.github/workflows/pages.yml` is dispatch-only and is not on origin/main, so it has never run. This is the owner's decision.
   - **What the switch takes:** push, enable Pages (Settings → Pages → GitHub Actions), then dispatch the workflow.
   - **What the switch would add:**
     - a public URL;
     - outbound links pinned to a commit that exists on the remote;
     - the only viewable form of the interactive map, since GitHub shows `map.html` as source.
   - **Before that:** run the build once in a sparse checkout made from the job's patterns. `tools/research/navigation.py` names `_process/architecture/*-manifest.json`, which is outside the sparse set, and nobody has shown whether the build reads it.
2. **Outbound links point at a commit no one can fetch.** All 19,866 blob/tree links and the footer are pinned to e4c5fa6a6, which is not on origin. The footer says "Built from uncommitted edits".
   - **File:** `tools/publishing/build_site.py`.
   - **Fix:** warn, or refuse, when `--commit` is not reachable from a remote ref or the tree is dirty, unless the build is a local preview.
3. **The home picture is clipped and the nav overflows.** Seen in a browser at 1024px: `a.picture` starts at -96px, and "Glossary", "Reviewers" and "中文" lie past the right edge of the nav. By arithmetic the clipping covers widths from about 770 to 1250px.
   - **File:** `tools/publishing/site.css`.
   - **Fix:** `body.home a.picture{width:100%;margin-left:0;transform:none}`, or centre `section.hero`.
4. **The site sends readers to GitHub's source view of the map.** MAP.html has 1 such link and CROSSWALK.html has 3, and both pages still say "open it from a clone".
   - **Files:** `build_site.py`, or `site.aliases` in `_process/research-config.json`.
   - **Fix:** map `theories/becoming/results/atlas/map.html` to `connections.html` (`MAP_PAGE` is already defined but not used for this). Drop the clone sentence on the site; it is written by `MAP.md` and `tools/research/atlas.py`. Add a test in `tools/research/tests/test_site.py`.
5. **414 status marks leave the site,** although all 558 record pages are built on it.
   - **File:** `build_site.py` `Page._record_mark`, line 248.
   - **Fix:** resolve the mark through `self.links.resolve('theories/becoming/results/records/<id>.md', …)`.
6. **Two pages publish a home-directory path.** These are the only two files in site2 that contain `/Users/`.
   - **Files:** `experiments/recipient-value-learning/README.md:52` and `experiments/motor-learning-cost/README.md:56`.
   - **Fix:** replace the path with a portable command, and add a check in `build()` that refuses any written page containing `/Users/`, `/home/` or `/private/tmp`.
7. **Smaller build defects.**
   - The five SVGs are mode 0600: use `shutil.copyfile` at about line 811.
   - Three pages have empty `#` links (OPEN-QUESTIONS, RESULTS and TESTS): drop or resolve them.
   - `connections.html` is 5 MB with its data inline, is titled "Becoming Connection Map", and looks like a different site: load its data lazily and reuse `site.css` (`tools/research/connection_map.py`).

### Q3 Unification and connections (median 6)
1. **The spine's spokes read as "every chapter derives from the grammar".** The spokes count modules ("k of m core modules state their laws on the grammar"). The standings (11 / 1 / 6 / 99) appear only in the top banner, and no chapter's standing appears on the drawing.
   - **File:** `tools/research/spine.py`, which writes `spine.svg` and `spine.zh.svg`.
   - **Fix:** draw each chapter's standings on its circle, as ring segments or a stacked bar. Label the spokes on the drawing as "modules stating laws on the grammar, not results derived".
2. **The spine's layout.**
   - There is an empty band from about y 140 to y 279/315.
   - Labels sit inside circles 01–04 but outside 05, 06 and 07, and above 08.
   - Count labels collide ("5, 14/76", "14 14/88").
   - "The grammar" fills its circle.
   - **File:** the same.
   - **Fix:** tighten the layout, place every chapter's label the same way, and place count labels with collision avoidance (or drop the labels under 15).
3. **The eleven derived declarations are never listed in words.** 08 §7 (line 448) names three, then "and five more", then three. The edge record lists all 11 only as Lean names, each a case of a Chinese-named grammar law. THEORY-GRAPH.md has no list.
   - **File:** `theory_graph.py`, which writes THEORY-GRAPH.md, and `08-METHOD.md` §7.
   - **Fix:** generate a table "The eleven derived": declaration, a one-line English statement, its home anchor, the grammar law it is a case of, and a link to its record.
4. **The backward uses are counted but never explained.** 212 of 497 between-chapter uses run backward, and the root uses the map 60 times against 42 the other way.
   - **File:** THEORY-GRAPH.md "Reading it", through `theory_graph.py`.
   - **Fix:** one sentence saying that chapter order is the order of exposition, not of dependence, and that the standings, not the curve direction, measure what rests on the grammar.
5. **08 §7's counts are hard to reconcile.** Its paragraphs run to 612 and 509 words, and the sentence that 45 and 11 count different things is only in THEORY-GRAPH.md.
   - **Fix:** open §7 with a four-row table saying what each count counts.
6. **Chinese readers have no view beyond the spine.** Neither `THEORY-GRAPH.zh.md` nor `CROSSWALK.zh.md` exists, and the zh captions link the English THEORY-GRAPH.md.
   - **Fix:** add a zh spine section (显示什么、不显示什么) with the edge-kind table, and a short CROSSWALK.zh.md front.

### Q4 How it grew (median 7)
1. **The evidence labels sort nothing.** All 48 points are "public"; private and AI reconstruction have 0 each. Who wrote each point (the person's own words, AI-drafted from them, or an AI reading) appears only in each row's prose.
   - **Files:** `theories/becoming/results/data/lineage.json` and `tools/research/lineage.py`.
   - **Fix:** add an authorship field to each point, and show it in the table and as a mark in the picture.
2. **Two gaps against TIMELINE are not marked.** No point falls between 2025-08-10 and 2026-02-09, or between 2026-07-15 and 2026-09-03. TIMELINE has a section for each: "The thin window, and what it probably means" and "The theory as engineering".
   - **Fix:** mark the first as an evidence gap, with TIMELINE's authorship reason. Add a point, or a stated omission, for the engineering and worldbuilding stretch.
3. **The picture shows one strand of growth, not the whole.**
   - Only 8 of 48 points are titled (6, 8, 11, 13, 19, 27, 32, 38).
   - The six phase bands are about the same width, although their spans run from 26 months to one week, and nothing says so.
   - **File:** `lineage.py`.
   - **Fix:** title at least one point per phase, or draw a second strand. Say that the phases are not to time scale. Fix the leader lines that cross labels, which reviewers reported and the checker did not measure.
4. **Four points cite the board without an anchor.** Points 36, 45, 47 and 48 cite `_process/BECOMING-WORKBOARD.md`, for clauses inside the Queue line, which is board line 39 at 97,825 characters and is rewritten at landings.
   - **Fix:** cite the commit that landed each clause.
5. **Three reading times for the lineage brief:** 8–11 minutes on MAP.md, 12–15 on LINEAGE.md and 12–16 on the site card.
   - **Fix:** take all three from the one computed timing field.

### Q5 Value (median 6)
1. **The value is stated in the account's own vocabulary.** The "What you can do today" cells run 47–81 words, and the gloss of "room" is close to unreadable.
   - **Files:** `theories/becoming/USES.md` and the first-screen source.
   - **Fix:** lead each cell with one plain sentence, a verb and its object. Rewrite the gloss of room in plain words. On the first screen, state the audit as three plain questions:
     - What does it read?
     - What does it not read that could be lost?
     - Can its rule lock on what it already picked?
2. **The first-screen case ends at its outcome without saying what the audit adds.** It never says that the audit flags that the selection reads the catch while the bed lies beyond it.
   - **Fix:** one sentence giving the case's lesson, with its standing kept. Also finish ONE-PAGE.md's "One case" with the positive half: told of the bed, one model of two kept it in 8 of 10 seasons, and the frozen predictions mostly failed.
3. **No named pipeline is taken through all five questions** of the judge audit. This is new AI-reading content, not a fix, and would need its label. Splitting question 4 of the judge audit, a single sentence of about 150 words, is a fix.

### Q6 Uses (median 7)
1. **Worked examples are missing from the English nav and the site's cards.** `nav_zh` has 实例.
   - **File:** `_process/research-config.json` (`nav`, `site.nav`, `site.ways_in`).
   - **Fix:** add `USES-EXAMPLES.md`.
2. **The field table is dense.** Cells run 36–125 words, and "the uses pages' AI reading" is opaque.
   - **File:** USES.md.
   - **Fix:** one sentence plus a link per "What you can do" cell, and the standing word first in "How it stands". Write "an AI reading on this page". Add one "try it" line per field.
3. **The people-and-AI row links a history file without saying so.** The row points into `history/ALIGNMENT-DIRECTION.md`, which has no superseded banner. USES-EXAMPLES does label its link to that file; only the USES.md row is unlabelled.
   - **Fix:** point the row to 07 §7 and its record, and keep the history file as provenance. A banner should come through `research.py`, not a hand edit.

### Q7 Visibility and navigation (median 7; the checker would put it at 6)
1. **High: evidence links land on a file GitHub does not render.** `_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md` is 3,780,784 bytes. 972 repository links point into it: chapters 02 (15), 03 (4), 04 (1) and 05 (5); RESULTS.md (4); LEAN-INDEX.md (35); review/SCIENCES.md (2); and 822 record files, most with section anchors. On the site there are 496 such links on 423 pages; Nav's 1,194 was overstated.
   - **Fix:** re-point the links to the result's record page, or split the file by section with `research.py move` and keep the original in history. The `?plain=1#L` line view is unproven for a file this size.
   - **Also:** add a research-check rule that fails when a live page links Markdown over 1 MB. Check the 1.8 MB zh edition the same way.
2. **Many fronts have no shared nav line.**
   - None at all: 01-ROOT, 06, chapters/README, MAP, theories/README and THEORY-GRAPH.
   - Only a 中文 link: GLOSSARY.
   - Local strips with no Home link: ONE-PAGE, USES and review/README.
   - **Fix:** have `research.py` render the shared nav line on generated fronts, and add a Home strip to the hand-written ones. For chapter 06, add the zh nav line and a reading time under the title.
3. **The nav does not lead.** It has 15 ungrouped links. The hero says "Start with the one page", but the nav's "Start here" goes to MAP.md, which is also the last of 16 equal cards. "Discovery and evidence" repeats the nav.
   - **File:** `_process/research-config.json` (`nav`, `site.nav`, `site.ways_in`).
   - **Fix:** have one start; group the cards as Read / Check / See; cut the nav to about eight items.
4. **Card times are wrong.** The chapters card says 18–24 minutes, which is the index page's time; the chapters take about 25.5–33 hours in all. "Check the proofs" says 12–16 minutes, the time of the whole of MAP.md.
   - **File:** `site.ways_in`.
   - **Fix:** state both times on the chapters card, and give the proofs card a `time_until` for its section.
5. **OPEN-QUESTIONS.md never names the crux, a reason for C, or the step of invariance,** though README line 47 calls the step "our first open question".
   - **Fix:** open the page with the crux and ONE-PAGE's "What is not yet done", copied in their homes' words.
6. **RESULTS.md has no reader's lead.** It opens on 536 rows in alphabetical order, and "Where to look first" (line 565) holds maintenance notes.
   - **Fix:** a lead at the top with the central results by chapter, and rename the closing section to what it holds.
7. **Chinese navigation gaps.** `nav_zh` has no chapters index, TESTS, THEORY-GRAPH or `connections.html`. The in-text zh nav lines link 八章 and 检验 without marking them as English.
   - **Fix:** add 检验 and 对照, marked （英文）, and mark English targets in the in-text lines.

## Findings that hold, ranked

Items the checker confirmed or partly confirmed. Where it found a reviewer overstated, the corrected figure is given.

| # | Severity | Where | Problem | Fix |
|---|---|---|---|---|
| 1 | high | `BECOMING-RENEWAL-READING.md` (3.78 MB) | 972 repo links and 496 site links land on Markdown GitHub does not render | Re-point to record pages, or split by `research.py move` keeping the original; add a check for links to Markdown over 1 MB |
| 2 | medium | README first-screen source | Never says the work was made with AI; calls an AI review "A review" | Add ONE-PAGE.md:7's sentence; write "An AI review" |
| 3 | medium | `site.ways_in`, chapters card | Says 18–24 min for about 25.5–33 h of chapters | State the index time and the chapters' time |
| 4 | medium | `spine.svg` (`spine.py`) | Spokes read as derivation; standings only in the banner | Standings on each circle; spoke meaning on the drawing |
| 5 | medium | 08 §7, edge record, THEORY-GRAPH | The 11 derived never listed in words | Generated table "The eleven derived" |
| 6 | medium | THEORY-GRAPH.md | 212 of 497 backward uses unexplained | One sentence: exposition order, not dependence |
| 7 | medium | README "## Truth exists" (partly) | No visible conviction label under the heading; README line 35 already links one page and uses | One label line; moving the opening needs an argument and a before-copy |
| 8 | medium | LINEAGE labels, `lineage.json` | 48 of 48 "public"; authorship only in prose | Authorship field in the table and the picture |
| 9 | medium | LINEAGE vs TIMELINE | Two unmarked gaps (2025-08→2026-02, 2026-07→09) | Mark the gap with its reason; add a point or a stated omission |
| 10 | medium | site2 out-links; `pages.yml` | Pinned to unpushed e4c5fa6a6; the workflow is not on origin | Owner: push, enable Pages, dispatch; builder warns on an unpushed commit |
| 11 | medium | site MAP.html and CROSSWALK.html | 4 map links go to GitHub's source view, plus the "from a clone" sentence | Map `map.html` to `connections.html`; add a test |
| 12 | medium | `site.css` `a.picture`; nav | Home picture at -96px and nav overflow at 1024px (observed) | The CSS fix above; shorter nav |
| 13 | medium | `build_site.py` `_record_mark` | 414 marks leave the site | Resolve to site record pages |
| 14 | medium | two experiment READMEs | Publish a `/Users/ren/.cache/codex-runtimes/…` path | Portable command; builder refuses local paths |
| 15 | medium | README first screen (partly) | No plain lead; "lock" unglossed; case lesson left unsaid ("couples into" is glossed) | Plain lead and lesson; keep note 11's Goodhart limit; avoid "destroys" |
| 16 | medium | USES.md "What you can do" | 47–81-word cells in the account's terms; room gloss unreadable | Plain verb-object lead per cell; rewrite the room gloss |
| 17 | medium | OPEN-QUESTIONS.md | Crux, reason for C, step of invariance not named | Open with the crux and "What is not yet done", in their homes' words |
| 18 | medium | chapters, MAP, THEORY-GRAPH, GLOSSARY, ONE-PAGE, USES, review/README | No shared nav line, or no Home link | Render the shared line; add a Home strip |
| 19 | medium | RESULTS.md | No reader's lead | Central results by chapter at the top |
| 20 | medium | nav, `site.nav`, `ways_in` | 15 ungrouped links, two starts, Examples missing in English | Group, one start, add Examples |
| 21 | medium | `lineage.svg` | 8 of 48 titled; phases equal width, scale not stated | Title per phase; scale note |
| 22 | medium | `lineage.json` points 36, 45, 47, 48 | Cite the live board with no anchor | Cite the landing commits |
| 23 | medium | zh nav, `nav_zh` | No tests or connections; English targets unmarked | Add 检验 and 对照; mark （英文） |
| 24 | medium | THEORY-GRAPH and CROSSWALK in zh | No zh edition; zh captions send readers to English | THEORY-GRAPH.zh spine section; short CROSSWALK.zh |
| 25 | medium | `pages.yml` sparse checkout (plausible) | Never tested; manifests outside the sparse set may be read | One local sparse-checkout build first |
| 26 | low→medium | `spine.svg` layout | Empty band; inconsistent labels; colliding counts | Tighten the layout; consistent labels; collision avoidance |
| 27 | low | 08 §7 counts | 612- and 509-word count paragraphs; "45 vs 11" only in THEORY-GRAPH | Four-row "what each count counts" table |
| 28 | low (partly) | ONE-PAGE.zh, THE-THEORY-OF-BECOMING.zh, review/README.zh | Say made with AI and unreviewed, but not "AI translation, the English governs" | Add USES.zh's line (以英文版为准) |
| 29 | low (partly) | USES.md people-and-AI row | Unlabelled link to a history file with no banner (USES-EXAMPLES labels its link) | Point to 07 §7 and its record; banner via `research.py` |
| 30 | low | reading times | Opening 22–28 / 22–29; lineage 8–11 / 12–15 / 12–16; zh one-page and lineage times differ; README.zh says 多数 where the English gives 505/536 | One computed source for all fronts |
| 31 | low | five site SVGs | Mode 0600 | `shutil.copyfile` |
| 32 | low | OPEN-QUESTIONS, RESULTS, TESTS on the site | Empty `#` links | Drop or resolve |
| 33 | low | `connections.html` | 5.0 MB inline; title and look differ from the site | Lazy data; site tokens and header; consistent title |
| 34 | low | `spine.svg` vs chapters index | 86/110/46/82 vs 87/111/47/84 with no reason given | State why, or use one count |
| 35 | low | CROSSWALK top strip | "the results" links the earlier catalogue | Relabel, or link RESULTS.md (`atlas.py`) |
| 36 | low | ONE-PAGE "One case" | Stops at the negative half | Add the told-of-the-bed result and the failed predictions |
| 37 | low | `experiments/direction-installation/README.md` (the first-screen case link) | Names "a Claude Code session" and links "[Ren]"; opens in board jargon | Point the case link at `USES-EXAMPLES.md#the-fishers-and-the-mussel-bed` |
| 38 | low (partly) | site search | None across 667 pages; a missing feature, not an error | Optional JSON index and search box |
| 39 | low (partly) | LINEAGE "Growth in the records" | Counts only history entries, as it says | Optional results-registered series |
| 40 | low (partly) | zh prose | Dense; GLOSSARY.zh already has 耦合进; translation-ese is a judgment for a native reader | A native reader's pass on the first screen and the one page |

Reviewers also reported the items below. The checker did not re-check them, and none contradicts the above:
- italic CJK rendered as a synthetic slant;
- chapter 06 without a nav line on GitHub;
- 生住异亡 vs 生住异灭;
- the 中文 link fourth of 15 on README.md;
- `connections.svg` as one dense band;
- duplicate same-line evidence links in LINEAGE;
- LINEAGE.md with no English nav line;
- INDEX's TIMELINE row not a link;
- the spine unreadable at phone width;
- TESTS.html with a double nav;
- the human-development example being a community choice, not a person's development;
- jargon in the lineage brief's phases 5 and 6;
- "Connections" naming two things;
- the review README's covering letter, which does not exist yet;
- a person's name in OPEN-QUESTIONS' anchor.

**Corrections the checker made to the reviews:**
- Site links into the renewal reading: 496, not 1,194.
- USES cells: 36–125 words, not 100–200.
- "Couples into" is already glossed on the first screen.
- The opening does not come before every link to the uses page.
- Halos on the counts and the under-10 cutoff are already in the spine.
- The historical anchors sit in a collapsed `<details>`.
- The judge audit is partly filled.
- `pages.yml` is not on origin/main.

**What would move the medians.**
- **The owner's switch** (push, enable Pages, dispatch) moves Q2, and through it Q7.
- **Fixes that change no claim:** the first-screen, spine, lineage, nav and build fixes above.
- **Q7 needs the renewal-reading fix first.** It is the one high finding, and it is the largest of these fixes.

No score is lowered or raised here beyond the checker's view. Q7's median is 7 by the numbers, and the checker would put it at 6.