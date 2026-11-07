# How the theory repository presents itself: review synthesis for Ren

*AI-written, 7 November 2026: seven AI reviewers, one AI checker and one AI synthesizer, spot-checked by the coordinator (section 6); no person has reviewed it.*

Main at 947744cc7. Seven reviewers covered first contact, the site, unification, growth, uses, navigation and the Chinese side. A checker then verified every high and medium finding. Severities below are the checker's. Low findings were not checked unless marked "checked". Nothing was edited or run.

## 1. Short answers

| Question | Score | Why |
|---|---|---|
| How representable is the project? | 4/10 | The honest material exists: standings, refuters, failed tests and the known-results verdict. A GitHub visitor meets a 12,684-word README, no picture, and no plain sentence saying what the work is worth. |
| Is there a static website? | 2/10 | None. Pages is off (API 404), and there are no topics, homepage or specific description. The parts for one are already built: generated pages under a CI check, a self-contained map, and a converter that needs only the Python standard library. |
| Are unification and connections shown elegantly? | 4/10 | The prose states the degree of unification honestly (08-METHOD.md:440: 11 of 117 central declarations derived on the root, 99 "at a named distance"), and the data keeps edge kinds apart. Nothing draws this. THEORY-GRAPH.md is tables. The one drawing, map.html, shows the earlier folders meeting the account, not the chapters meeting each other, and it cannot be opened on GitHub. |
| Is it clear how the whole grew into today's account? | 3/10 | The good narrative (_process/history/2026-09-consolidation/TIMELINE.md) stops on 4 October 2026 and is linked only from history. The Becoming era, about 6,060 of 6,073 commits, has no narrative. Earlier folders still speak in their September voice. |
| Can people understand the value? | 4/10 | The value sentence and the fisher case are on ONE-PAGE (line 9) and in the overview (line 26). The README first screen has neither. The verdict that none of the central results is new mathematics appears in neither README nor MAP. |
| Are uses in alignment, wisdom, coordination and human development shown? | 4/10 | Alignment: the dossier's ten-minute section does it well, but it is three clicks deep. Coordination: theorem rows, no worked example. Wisdom and human development: no page says what is or is not claimed. "wisdom" and "coordinat" occur 0 times in ONE-PAGE, the overview and GLOSSARY. |
| Are valuable things easy to see, with clear connections? | 3/10 | About three of the ten most valuable things are one click from README. The tests index, the atlas and the edition-5 PDFs are linked from no live front page. Four linked evidence pages do not render on GitHub. |

**Overall:** the account itself is honest, and its strongest material is just hidden. The places that tell a reader more than the account supports lie around it: the earlier folder READMEs, a few sentences of the opening, and legacy catalogues under current-sounding names.

## 2. What is strong: keep it and show it more

- **Standings and refuters on every claim.** ONE-PAGE.md:13-22 and THE-THEORY-OF-BECOMING.md:28-57 give each claim a standing and a "What would show it wrong" column. Failures are on the front page: T1 "failed in four settings" (ONE-PAGE.md:17), and T7's bridge "failed" (:20).
- **A sharp self-verdict.** 08-METHOD.md:482: "None of the central results is new mathematics: each is near-definitional or a known result restated." ONE-PAGE's own rows say "near-definitional" and "a known theorem restated" (:18-19).
- **The fisher case.** It is concrete, memorable and honest about its limits: "They are language models told what to do, not systems trained" (ONE-PAGE.md:9).
- **Unification stated without inflation.** 08-METHOD.md:440 gives the count: 11 derived, 1 under a hypothesis, 6 counting, 99 at a named distance. ONE-PAGE.md:11 gives the same in words: "a few are cases of the root, more use its laws in their proofs and most use none".
- **Edge kinds defined and kept apart.** The data has 1,162 formal-reuse edges, 11 application, 98 interpretive and 1,420 related (analogy). THEORY-GRAPH.md:5 says an edge is "not an agreement in meaning".
- **Generated pages, enforced by CI.** `make research-check-strict` runs on every push, so a site built from main in CI would stay in step with main without extra work.
- **map.html models how every visual should behave.** It is self-contained and frames itself honestly: "Every thread is an AI reading, and no person's". It shows its critics' sample: 82.6% hold, 14.2% have a label wrong, 3.2% fail.
- **The Chinese dossiers are exemplary.** They concede the theory "站在《中论》所破的那一边" (stands on the side the Middle Treatise refutes). They label the 中华本 經 as AI-written pseudo-classical text. They keep "相合不是印证" (agreement is not confirmation; 06:46-49).
- **The alignment dossier's ten minutes has the right shape.** It states "What is not claimed" (ALIGNMENT.md:22) and sorts its tests with the failures first (:28-34).
- **Reproducibility and provenance.**
  - MAP.md:41-54 gives a three-step Lean check.
  - Reading times are mostly accurate.
  - Nothing is deleted, and the 536 record JSONs carry 3,767 dated history entries, so a timeline already exists as data.

## 3. Findings that survived checking

Ranked within each theme. The themes are in the repository's own order of priority.

### A. What a reader is told (misleading or oversold)

1. **HIGH: earlier folder READMEs present their September self-assessments as current.**
   - Evidence: keep-the-possibility-space-open/README.md:5 calls its proof-sketch "rigorous", says it "survived a 56-criticism adversarial review", and calls it "Near-publishable". The crosswalk has no entry for that proof-sketch. wamotopia-and-the-wamo-protocol/README.md says "publishable today" (so do human-solutions-museum and zhishan-intelligence-must-be-good). alignment-selection-on-cognition says "Publishable now".
   - None of the 16 links CROSSWALK. 14 of 16 have no Markdown link to theories/becoming. None has a banner. theories/ has no README (medium, navigation-44).
   - Fix: a generated banner on each folder, built from correspondences.json and worded from 05-COLLECTIVES.md:398 ("design programmes, not results; correspondence not established"). Give the crosswalk counts (e.g. architecture: 30 entries, 11 carried in part, 13 fresh readings). Mark the folder's own assessment as its dated view, and keep the bytes below the banner unchanged. Add a theories/README.md naming becoming/ as the live account.
2. **MEDIUM: the known-results verdict is missing from README and MAP, while the first screen leads with volume.**
   - README.md:17: "Lean receipts credit 505 of 536 registered results". The phrase "new mathematics" appears 0 times in README and MAP.
   - The checker found that ONE-PAGE does give the verdict near the top, row by row, so it is not buried there.
   - Fix: one sentence in `readme_first_screen` and in MAP's "What this is", copied from ONE-PAGE.md:30 / 08-METHOD.md:482 and linked to 08#known-results.
3. **MEDIUM: README.md:43 says the foundation "supplies" coordination.** Its own note 13 (:107) calls this "a thesis … not a theorem". COLLECTIVE-DIRECTION.md:87 adds that "no test has human participants". Fix: the main sentence should carry the qualifier. This is your voice; see §4.
4. **MEDIUM: README.md:188 says "AJ4's one page for alignment researchers, now in draft".** That page was retired on 31 October and replaced by ALIGNMENT.md's "The dossier in ten minutes" (moves-2026-10-31-aj4-page-retire.json). Fix the goal or record text, then re-render.
5. **MEDIUM: README.md:156 overstates chapter 06.**
   - :156 says "The relational start holds across the lines". Chapter 06 says "主导线索" (a main thread), and its list of what is not shown (06:4, :628) excludes the stronger reading.
   - :156 also gives "91 agree" without "agreement is not confirmation".
   - :158's "Next" lists an item that 06:466 marks as answered.
   - Fix the source text, not the generated view.
6. **MEDIUM: 01-ROOT.md:5 says "It takes nothing from the others".**
   - 45 of 01's 86 results formally reuse results from later chapters. 196 of 467 cross-chapter formal-reuse edges run backward. Becoming.Courses imports modules from the knowing region.
   - Fix: limit the claim to the grammar, and say the chapter order is a reading order, not a derivation order.
7. **MEDIUM: legacy catalogues appear under current names.**
   - results/README.md:29-34 sends "What foundation has been established?" to frozen 8 October pages.
   - GENERATIVITY-CHAIN.md:1 is titled "the connected theory". It uses G0 on 17 lines (131 times), states a different centre, and carries "Content updated 2026-11-07".
   - It is linked as "Curated" from README.md:212, RESULTS.md:575, theories/becoming/README.md:20 and chapters/CLAIMS.md:18.
   - Fix: re-route those rows to the current homes, retitle the chain as historical, and move its links under a history label.
8. **Low, checked:**
   - MAP.md:22 promises "how they connect" from a page that shows no edges.
   - Chapter 06 §7.3 links the 中华本 without its date (2026-10-21) or the fact that it was superseded.
   - experiments/README.md:5 calls a history copy "the canonical chapter".

### B. The landing and the way in

9. **MEDIUM: no value sentence on the first screen** (README.md:9-17). The checker notes the opening has one at :43, so "never" was too strong. Fix: put the overview:26 sentence, with its [AI reading] label, and the fisher case in two sentences on the first screen.
10. **MEDIUM: the landing is 12,684 words.** The opening and its 24 notes come before the four layers. The labels exist (README.md:15, :25); the problem is length and placement. Your decision.
11. **MEDIUM: the nav bar and stubs point newcomers at process material.**
    - "Scopes" opens GOALS.md:10 at "Scopes not yet marked by Ren". "Connections" is a 6,113-word edge list.
    - There is no Tests, Lean, Map, Reviewers or Glossary entry.
    - RESEARCH.md:8 and theories/becoming/README.md:10 are "kept so that links to it resolve".
    - Fix the generator config.
12. **MEDIUM: there is no scoreboard of tests that could fail.** experiments/README.md has frozen and run dates and outcomes, and is linked from neither README nor MAP. Fix: a generated TESTS.md, failures first, in the nav bar.
13. **MEDIUM: ONE-PAGE is denser than its 11-15 minutes allows.**
    - The T7 cell is 117 words.
    - "room", "couples into" and "admits" are never glossed in everyday words.
    - Fix: cut each cell to its standing plus one clause, keeping "every frozen verdict passed, three by one tie" and "no field test". Gloss each term on first use, and have a non-author reader time the page.
14. **MEDIUM: the Chinese way in.**
    - README's nav bar and first screen have no 中文 link. MAP.md:19-26 has them, so a Chinese reader is one click away, not 9,400 words.
    - The Chinese fronts link into English pages without marking them.
    - There is no Chinese GLOSSARY or OPENING. 智慧 and 合作 count 0 on the Chinese fronts.
    - Fix: a 中文 line in the nav via config, （英文） marks on links, and a Chinese glossary first.
15. **Low, checked:**
    - README's lower half is board process talk.
    - The atlas is linked from no live front, and it does not render anyway.
    - The edition-5 PDFs are linked from nowhere, and output/ has no README.
    - The Lean package has no "ten central declarations" table.
    - 生生 as the work's aim appears once, in a table cell.
    - The 248-passage work on Chinese thought is absent from the overviews.
    - Chinese terms drift (扩大 / 以广为愈 / 拓宽).
    - The Chinese fronts read as close translation.
    - On the 生生 / «生生不息» senses: the Chinese fronts never use «生生», so they do not themselves cause the confusion. A rename is arguable, not a clear wrong meaning.

### C. Visuals and the site

16. **MEDIUM: no site, and no picture anywhere a reader goes.**
    - map.html is 4,954,810 bytes. GitHub's raw view serves it as `text/plain` with `nosniff`, and the blob page shows only "View raw".
    - Its only live link is MAP.md:75.
    - No reading page has a Mermaid block, SVG or image.
17. **MEDIUM: four linked evidence pages do not render on GitHub.** CROSSWALK.md is 3.7 MB, ATLAS.md 1.0 MB, GENERATIVITY-CHAIN.md 615 KB and LEAN-INDEX.md 436 KB, and all return `richText: null`. Fix: split them in the generators, and add a size check.
18. **MEDIUM: the theory graph is tables.** THEORY-GRAPH.md says "3220 nodes, 6892 edges", then lists. map.html's "theory's own graph" is one sentence of counts.
19. **Low, checked:**
    - Any site must be built from an allow-list: sources/ holds 47 publishers' HTML copies, and .claude/launch.json is tracked although .claude/ is on the private list (a future risk only).
    - Per-unit AI classes should not sit one hover away from blind coders.
    - Add one sentence reconciling "11 derived" with "45 reach the grammar".
    - The four organising schemes (chapters, three questions, atlas families, the chain) are never related to each other.

### D. Growth

20. **MEDIUM: the only live growth story is MAP.md:32.**
    - It reads "more than 1,550 commits (1,568 in all by 19 October 2026)"; the count is now 6,073.
    - TIMELINE.md (11,564 words, to 4 October) is linked only from history.
    - _process/history/INDEX.md:9 says it was "superseded by the Becoming-era record". That record is the board and the commits, not a narrative.
21. **Low, checked:**
    - The crosswalk has no dates.
    - No lineage picture exists.
    - The paper line (the IASEAI drafts and the output/pdf papers) has no page saying what of it stands.
    - Genealogy citations to untracked private records cannot be checked publicly. They are backticked paths, not dead links.

### E. Uses

22. **MEDIUM: no page says, field by field, what the account is for and how far it goes.** This merges first-contact-6, uses-28 and navigation-38. The checker adds that for wisdom and human development the account claims almost nothing: wisdom-root is open, and 07 shows no well-being, duty or rights. Those rows must say "nothing claimed", not invent uses.
23. **MEDIUM: wisdom traditions have no English statement.** Both dossiers are Chinese only. The checker found the reviewer's proposed worked passage misattributed: 天之道损有余而补不足 is read in the two-sided-regulation record, not in Becoming.RuleCapture.
24. **Low, checked:**
    - AJ's "what the goal is not" list and its three questions live only in a _process plan. The goal itself is live at GOALS.md:104 and README.md:186.
    - ALIGNMENT's 22 "Standing and use" paragraphs give almost no use.
    - The handover case sits in history/ in older vocabulary; restate it against J1–J4, do not copy it.
    - A coordination example must be constructed, never estimates for a real body.

**Unchecked lows worth keeping:**
- theories/becoming/README.md is a legacy page.
- map.html needs a `--site` link mode, and its `<title>` sits outside `<head>`.
- generative-core.html is a pre-spine fragment; keep it off any site.
- Edition manifests give no reason for each supersession.
- MAP gives no reading time of its own.
- The lessons on freezing tests are buried in experiments/README.md.
- The frozen test environments are not offered as reusable.
- Guardian-anarchy images are tracked in output/.
- Chapter 06 has no ten-minute way in.
- Edition 5 links chapter 06 but does not include it.

## 4. Plan, in order

By AGENTS "What moves it", step (a) comes first. Steps (b) to (d) are representation work. Edition 5 is already with readers, and what they report should steer the polish. None of the steps below designs or runs a test, so all are clear of RUNHOLD. Fixes made now change what GitHub visitors see, not edition 5's PDFs. Whether readers get a note or a later edition is yours: it falls under who is sent what.

**(a) Fix what a reader is told** (the work, unless marked)
1. Generated folder banners and theories/README.md (finding 1). Any of your own words in a folder stay verbatim below the banner.
2. The verdict sentence on the README first screen and in MAP (finding 2).
3. Re-render README.md:188 and :156/158 from corrected source text (findings 4 and 5).
4. Correct 01-ROOT.md:5 in its home and its restatements, searched by claim, not by word (finding 6).
5. Retitle or re-route the legacy catalogues. Fix MAP.md:22, experiments/README.md:5 and the 中华本 link (findings 7 and 8).
6. Then render, run the gate, and have a second reader check each restatement against its home.
7. **Yours:** the README.md:43 coordination sentence. A qualified version can be prepared under OPENING's revision header, but it is your voice.
8. **Yours:** whether the opening stays inline on the landing or is linked to OPENING.md. Both versions can be prepared.

**(b) The smallest elegant static site**
- **Cheap steps on GitHub first:**
  - Split the four oversized generated pages. This fixes GitHub now and gives the site its pages.
  - Put a generated Mermaid region diagram at the top of THEORY-GRAPH.md, using the formal-reuse counts root→map 60, map→root 42, knowing→root 40.
  - Add a note at MAP.md:75 that the map opens from a local clone.
- **One builder,** e.g. tools/publishing/build_site.py, extending build_review_packet.py's standard-library converter:
  - It reads only a `site_paths` allow-list in _process/research-config.json.
  - It refuses any path matching push_screen's private regex.
  - It rewrites links that leave the site to GitHub permalinks at the build commit.
  - It checks links, anchors, standing badges and page size.
- **Pages:**
  - Home: the first screen, verbatim.
  - One page, in both languages; the overview; the chapters, with a standing badge at each r- anchor.
  - Tests and Graph.
  - Map: map.html via a new `--site` mode, title moved into head, entries loaded lazily.
  - Growth; Check the Lean (from MAP.md:41-54); Reviewers.
- **Hosting:** a `workflow_dispatch`-only Actions job using `upload-pages-artifact` from a sparse checkout without LFS. No generated HTML is committed, so nothing can drift from main.
- **Kept off the site:** third-party copies under sources/, generative-core.html, and per-unit AI classes for the frozen sample. The last is a dated limit that lapses when the blind coding returns.
- **Yours:**
  - Enabling Pages; it would serve at yongxu.ren/theories/ via GitHub's redirect.
  - The repository's description, topics and homepage. A careful description might be "One account of how things form, persist, change and end: Lean-checked models, frozen tests, and an ethics on two unasserted premises."
  - Whether the edition-5 PDFs go on the site before the letter.
  - The status of .claude/launch.json and the guardian-anarchy images.

**(c) Showing unification and growth** (the work)
- **A generated SVG of the spine,** from theory-graph.json, embedded in ONE-PAGE and the overview, where GitHub renders it:
  - the grammar at the centre;
  - eight chapters sized by their results;
  - formal reuse as solid lines with the backward edges drawn, interpretive edges dashed, analogy hidden by default;
  - the continuation condition and C entering chapter 7 from outside, as unasserted inputs;
  - T1–T8 pinned at their homes and coloured by test outcome.
  - Caption it with "11 of 117 derived; 99 at a named distance", the line "an edge is a dependence, not an agreement in meaning", and the 45-versus-11 reconciliation. A second reader checks the caption.
- **Two generated tables:** edge kinds per chapter pair in THEORY-GRAPH.md, and atlas families by chapter in ATLAS.md.
- **A generated LINEAGE.md (and .zh):**
  - Carry TIMELINE's ledger of renames forward using the record history arrays, the experiments index, the edition tags and the crosswalk outcomes per folder (488 carried in part, 189 changed, 105 not carried, 3 carried).
  - The time axis compresses 2021–2025 and widens September–November 2026.
  - Each turning point carries an evidence label: public, private and unpublished, or AI reconstruction.
  - Trace one thread: the selection mechanism from 2024-07, through the meta-attractor, to closed capture on the spine (20 October), to T7's failed bridge.
  - Add a papers stratum and a generated output/README.
  - Generate MAP's counts, and correct INDEX.md:9.

**(d) Uses, with worked examples at their true standing** (the work)
- **One page, "What it is for, and how far".**
  - Rows: alignment, coordination among people, people and AI, wisdom traditions, human development (生生), sciences.
  - Columns: what you can do today, the standing in its home's words, a worked example, and what is not claimed.
  - Link it from the first screen and from MAP.
- **Alignment:**
  - the fisher case;
  - a coupling-closure audit of an LLM-as-judge pipeline, set beside what LA2 actually showed;
  - the IN1, LA2 and CG2 environments as reusable instruments, with their limits stated;
  - AJ's "what the goal is not" and its three questions as a checklist, each with its standing.
- **Coordination:** a constructed standards body with illustrative s, p and c and the critical mass. Label it constructed, and say CMT is frozen and not run, and no test has had people in it.
- **People and AI:** the handover case restated against 07's J1–J4, keeping "constructed, not an observed deployment".
- **Wisdom:** a structural concordance for scholars, AI-classified and unreviewed; agreement confirms nothing; nothing claimed for practice; wisdom-root open. Add one English passage from the two-sided-regulation record, with B-02's concession.
- **Human development:** T8 is argued under two unasserted premises. 07 shows no well-being, duty or rights. The worldbuilding and other programmes are design programmes whose correspondence is not established.
- **In the dossier,** split "Standing and use" into two headings, writing "no use claimed" where none is.

## 5. What this review did not cover

- **The truth of the account.** The review judged only how the work is shown. It did not judge the proofs, the premises or the ethics.
- **What the reviewers read.**
  - Chapter bodies only around their anchors.
  - Most dossier items unread.
  - Most records, the Lean source, the PDFs, the bodies of the crosswalk, atlas and 中华本, the work board and sources/ unread.
- **Rendering.**
  - map.html was parsed, never viewed in a browser.
  - GitHub rendering was checked through blob JSON for 13 files only.
  - No phone or accessibility test.
  - yongxu.ren did not resolve from the reviewer's network.
- **Readers.** Every reading here is an AI's. No person timed a page or reported back.
- **The checker's coverage.** Low findings went unchecked. navigation-47 (growth) had no verdict of its own and is folded into finding 20.
- **Comparisons.** No comparison was made with how similar projects present themselves.
## 6. The coordinator's check of this synthesis

Re-read against main at 947744cc7, 7 November 2026. Each of these was checked against the file, not taken from the reviewers:

- **Pages.** `has_pages` is false for yongxu/theories, which has no topics or homepage. yongxu/yongxu.github.io serves Pages with the custom domain `yongxu.ren`, so a project site would appear at yongxu.ren/theories/.
- **Folder self-assessments.** "rigorous", "56-criticism adversarial review" and "Near-publishable" are in keep-the-possibility-space-open/README.md:5. "Publishable now" is in alignment-selection-on-cognition/README.md:9. "publishable today" is in three folder READMEs. No folder README links CROSSWALK, and theories/ has no README.
- **README sentences.**
  - README.md:43 says the foundation "supplies" coordination.
  - :156 reads "The relational start holds across the lines".
  - :188 still has "AJ4's one page for alignment researchers, now in draft".
- **01-ROOT.md:5's sentence.** "It takes nothing from the others" is there. I recounted from theory-graph.json:
  - 45 of the root region's 86 results have a formal-reuse edge to a result in a later region. That matches the review exactly.
  - Across the eight chapter regions I count 497 cross-region formal-reuse edges, 212 of them running to a later region. The review's 467 and 196 used a slightly different region set; the finding stands either way.
  - The region counts root→map 60, map→root 42 and knowing→root 40 match.
- **MAP.md.** :22 promises "how they connect". :32 still counts "more than 1,550 commits"; main has 6,073.
- **The 0 counts.** "wisdom" and "coordinat" occur 0 times in ONE-PAGE, the overview and GLOSSARY.
- **08-METHOD.** The :440 counts and the :482 verdict are as quoted.
- **Sizes.** CROSSWALK.md is 3,742,459 bytes, ATLAS.md 1,035,845, GENERATIVITY-CHAIN.md 615,112 and LEAN-INDEX.md 436,115.
- **Other paths.** TIMELINE.md ends with September's narrative. experiments/README.md is linked from neither README nor MAP. output/ has no README. .claude/launch.json is tracked.

**Corrected in the synthesis:**
- wamotopia's path;
- the G0 count, which is 17 lines, not 17 uses;
- the proposed description, which now copies AGENTS' "form, persist, change and end" and "unasserted".

**Not checked by me:** GitHub's rendering of the large pages and of map.html (the reviewers' blob-JSON reading), and every low finding the checker did not verify.
