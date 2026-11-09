# AG review, eighth pass: the completeness critic

AI-written (Claude Opus 5.5). Written on 10 November 2026, about 05:15 to 05:45 WIB, on `/Users/ren/tmp/ag/rv` (branch `ag-review`, HEAD a2200f38e, with the eighth pass's uncommitted changes; not rendered). Every agent of the pass had finished. I read the seventh pass's critic and all twenty pass8 reports (changed, left, for_ren). I also read astra's seventh-pass cold reading, findings 1 to 9 and its Chinese points, and J1's note to AG (`/Users/ren/tmp/za-how-far/route-b/join/J1-FOR-AG.md`). In the Lean I checked:

- `Direction.extension_iff_widens` (Direction.lean:90);
- `Priority.comparison` (FrontierFrames.lean:445);
- `increasingInOwn_iff_increasing_iff_marks` (PremiseWitnesses.lean:318), for the one new finding in §5.1.

I ran no make, render, gate, lake or build.

## 1. The seventh pass's critic, §3, item by item

| Item | Now |
|---|---|
| 1. The direction's "C read as widening" (07 §7, overview, one page, USES, USES-EXAMPLES, the opening's [^alignment], ALIGNMENT A-17, crosswalk) | **Fixed.** 07:919 now carries the H11 label word for word. No live front, chapter, dossier or crosswalk entry lists C among the direction's or the handover's hypotheses. Left deliberately: the goal JSON (item 5 below, Ren's) and Direction.lean's docstrings (Lean pass, §5.4). New: the Lean package README's Direction row also said it; fixed by me (§3). |
| 2. "so" before "ranking by widening adds no premise" | **Fixed** everywhere (GLOSSARY, GLOSSARY.zh 而, 08 §2, COLLECTIVE-DIRECTION, BUDDHIST 而, USES.zh). The opening's [^ethics] keeps "So", which follows the self-concern composition, the right reason. 07:382's "so ranking by widening meets whatever C requires" is another sense. |
| 3. 01-ROOT:11, C said as an order | **Fixed** (a requirement on an order, with `living`). |
| 4. Lean docstrings in the withdrawn frame | **Left deliberately** (Lean pass with its own core run). Not one changed. The list is updated in §5.4. |
| 5–7. Goal wording (generative-alignment, zero-axiom-session, universal-intelligence-session) | **Left deliberately** (Ren's). Unchanged. Proposals updated for H11/H12 in §5.5. |
| 8. normative-grounding.json, theory-of-becoming.json | Other senses; kept. |
| 9. USES "normative warrant" | **Fixed.** |
| 10. The picture's alt text | **Fixed** ("the continuation condition, self-concern and C coming into chapter 7", both languages, one page and overview). |
| 11. 07's weighting phrases and eventual-widening laws[4] | **Fixed.** Kept: 07 §4.4's table row "every positive weighting", whose theorem line states the additive natural weighting. |
| 12. "C ranks it above" | **Fixed** in relation-level-law-of-easing, stepwise-law-of-easing, ranking-under-readings (retitled, old title an alias) and relational-reading-comparison, with crosswalk entry 878. "Every comparison satisfying C ranks" stays: it is the theorems' own form. |
| 13. 自承 for de se | **Fixed**, except one current field: mutual-dependence-gives-the-condition-de-se `next_delta.zh` "自承而其所及返回之形成" (§5.2). The other hits are history lines or other senses (自承者, 独自承担). |
| 14. Register row the-step-of-invariance | **Left** (coordinator: the register has no notes field). It is joined by the rows listed in §5.3. |
| 15. Three crosswalk entries | **Fixed.** |
| 16. 08 §12 item 12; route-b-universal-form-closed; J3's docstrings | **Fixed:** 08 §12 item 12 carries J1's wording with "wherever only ending was at stake there". route-b-universal-form-closed says the one-center law with its hypothesis. The docstrings are left for the Lean pass (§5.4). |

## 2. What was searched, and the counts

I ran ripgrep over every text file (md, json, py, lean, txt, tex, yaml, toml, csv, tsv, html), excluding `sources/`, `_process/history/`, `theories/becoming/history/`, `.lake` and receipt folders. Then I classified the hits by folder. For the live JSON (records, data, atlas entries, goals) I took each hit's key, so that history, progress and alias fields could be told from current ones.

- **(a) What this pass corrects:**
  - "C read as widening" and C among the hypotheses (`C, J1–J4`, `under C and J1`);
  - "needed, and not enough" without saying what it is needed for;
  - "holds its own continuation as an order";
  - "holds only with one center", "as among dated occurrences", "dated occurrences make none";
  - "and only from the steps where they do", and "over what comes after" joined with "come to bear";
  - "go on forming without end";
  - "one way" as the path result's label;
  - "so ranking by widening", "already counts every continuation", and "a reason of its own … closure";
  - 自承 for de se, 直接合成, 拓宽;
  - "C ranks", "C orders", "C's order", "C leaves … unranked", "premise beyond C";
  - "normative/ethical/practical warrant", 规范根据.
- **(b) What H1–H10 corrected, in case any of it survived:**
  - not asserted / unasserted, "two premises", "second premise", "widening what can form is better", 不断言, 以广为愈, 第二个前提;
  - argued, not shown; "every way of counting"; "every positive weighting";
  - "the makers' offer"; "binding every mind"; "continues with"; "courses that end"; "derived from the dynamics".

C's gloss at its definitions, the condition in time, the one-center sentences, "seeing … needed", "compose directly", and the H15 quantifier sentence were searched separately and read one by one.

| Where | (a) | (b) |
|---|---:|---:|
| experiments other than the live Lean source (almost all `lean/becoming/becoming-checks/<run>/` receipt copies and `lean/history/`; also the package README, `Becoming.lean` and `check_becoming.py`) | 4,797 | 2,612 |
| development studies (dated) | 3,694 | 8,704 |
| other `_process/research` (dated studies, architecture indexes) | 955 | 617 |
| `_process/architecture/history` (record snapshots) | 378 | 181 |
| generated pages (follow at the render) | 346 | 1,053 |
| live records (all fields, history included) | 96 | 163 |
| live results/data registers | 60 | 25 |
| Lean package `Becoming/*.lean` | 45 | 53 |
| live atlas entries (crosswalk phase) | 41 | 17 |
| tools/research/tests (retired-phrase lists, pins) | 41 | 52 |
| live chapters and fronts | 37 | 32 |
| drafts | 33 | 125 |
| live dossiers | 18 | 23 |
| `_process` other (board, navigation, workflow) | 8 | 10 |
| earlier theory folders | 7 | 36 |
| tools/research/*.py | 6 | 2 |
| goals | 5 | 3 |
| root pages (GLOSSARY, MAP, RESEARCH) | 2 | 3 |

I read the live hits one by one: about 750 lines and fields from the two sets, and about 250 more from the separate searches. They cover chapters, fronts, dossiers, glossaries, MAP, navigation, the live JSON by key, tools, goals, the Lean package's README and the Lean docstrings. I only sampled two groups: the test hits, which are lists of retired phrases whose absence the tests assert, and the atlas hits, which belong to the crosswalk phase and were read whole by its agent and verifier. Classified:

- **A theorem's exact hypothesis, or another sense (kept).**
  - "One way" for relations and laws: widening is one-way (`«广不可逆»`), `Downstream.one_way`, continuity read one way, chance errors one way, "runs one way".
  - "Courses whose admissions end" as H8 says it.
  - "Every comparison satisfying C ranks", the theorems' form.
  - "Premise beyond C" or "requirement beyond C" for C∞ and the lag.
  - "A verdict C leaves open" (what-a-course-keeps-reachable): C as a requirement asks nothing there.
  - "Not asserted" for reachability (03 §11) and lemmas.
  - "Two premises" of other laws (exchanges, premises-read-off-the-exchange, whole-law-of-counting, the step's two premises).
  - "Derived from the dynamics" only in "the center is not derived from the dynamics" (`Clearing.center_not_derived`).
  - 自承 as "the one who bears" (what-the-claims-do-not-read) and 独自承担.
  - 而不是从这条路径生出 (the crux's route).
  - 03:379's "warrants" inside a conditional on the practical commitments.
  - lineage's and the board's quotations of "makers' offer" (points 48 and 49, dated).
  - The widening-as-what-every-positive-weighting-ranks title and dossier titles, with the additive definition beside them.
- **History, dated notes, verbatim quotes (kept, E10).**
  - Records' history and progress fields; aliases kept for search.
  - Line 1 comments of the fronts (revision notes).
  - The dossiers' dated making lines (PHILOSOPHY 703–706, ALIGNMENT 711–715, A-16's narrative at 516).
  - 07 §4's C history note; 08's retired-labels row and 08 §8's dated quotation.
  - The register rows describing history sources at their hashes; lineage points.
  - RESEARCH-DIRECTIVES (Ren's directives); the board.
  - The opening's body.
- **Fixed by this pass's agents.** Every front, 07, 08, the glossaries, MAP, COLLECTIVE-DIRECTION, ONE-ARGUMENT, 01, 02, 05, 06, AJ's plan, the dossiers, the records, the data, spine.py, connection_map.py, navigation.py and the crosswalk carry H11 to H20. The one exception in the live theory is the stale Chinese row in §5.1, and the items in §5 are what remain.

No live sentence says that self-concern, the condition or the ethics is derived from the dynamics, or that a life forms such an order.

## 3. What I changed (files no agent of this pass reported as its own; each a sentence, its quotes checked)

1. **`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md`** (the Lean package's hand-written front; not frozen, not quoted, not machine-checked), three rows:
   - **Direction row (H11).** It said "C read as widening on the moves' outcomes (`Direction.extension_iff_widens`)". It now says what the theorem states: "with every admission counted, one move's outcome extends another's exactly where it widens it". It also says that J1/J2 "give C wherever it is decided whether an extension adds a basic claim (`Priority.comparison`)".
   - **GrammarScope row (H16 b).** It said "along a net with no cycle only one center". It now says "where the condition holds on a net with no cycle, every standpoint has the same center".
   - **PremiseWitnesses row (H15).** It said "between two level paths whose admissions are listed". It now says "with admission decided, … between two level paths whose admitted pairs fit in a finite list".

   No other copy quotes these rows (the hits are dated studies and history).
2. **`_process/RESULT-WORKFLOW.md`**, the description of the edge record's `boundary` field (lines 97 and 154). It said "the two premises of the ethics", with C in role `order`, which is the 9 November frame (H5). It now says:
   - "the hypotheses the ethics' ranking results name";
   - that `premises_of_the_ethics` is "a name kept from before 9 November 2026, when C was taken as a second premise giving order";
   - the roles: "role `scope`: whose losses count" and "role `order`: a requirement on an order, a hypothesis where a theorem takes it".

   The field name and roles, which code reads, are unchanged. No test pins these lines.
3. **`drafts/2026-10-10-opening/README.md`**, the dated revised-passages paragraph. I added the eighth-pass sentence the opening agent proposed for the coordinator, checked phrase by phrase against OPENING.md's notes. It puts the quantifier where the Lean puts it ("coinciding for every order exactly when every listed item is marked"). The seventh-pass sentence before it stays as history.

Checks on these: `gate.frozen_paths` and `gate.quoted_paths` contain none of them. `reading_catalogue.validate` gives 0 errors and 101 drifts, none from these files (the drifts are the 07 and 08 rows and older rows, to be re-read at landing).

## 4. Checks run on the pass as it stands

- `check_dossiers.py`: 0 problems (the six 07 quotations ch07 listed are reconciled).
- `spine.check`: 0. `lineage.check`: 0. `zh_fronts.problems`: 0.
- The atlas render in memory: 0 errors, 177 dynamics, 1,183 correspondences.
- Single test files, run one after another on a load of about 7:
  - `test_navigation_pages`: 52 OK.
  - `test_uses_pages`: 54 OK (the reds reported mid-edit are gone).
  - `test_featured_results`: 31 OK.
  - `test_spine`: 32 OK.
  - `test_connection_map`: 32 OK.
  - `test_boundary`: 62 OK.
  - `test_chinese_fronts`: 27 OK and 1 failure, `test_the_chinese_opening_is_timed_without_its_notes`. It compares the generated README.zh.md, rendered before this pass, with OPENING.zh.md now, so it clears at the render. It is not a load red.
- `test_registry` was not rerun: verify-ch07 ran it twice on the final records, 21 OK each time, and the statements I spot-checked are within the 300-character cap.
- The full suite, the gate and the render were deliberately not run.

## 5. What is left, with file, line, text and proposed wording

### 5.1 Medium

1. **A survivor of the withdrawn frame in the spine's Chinese** (rest's file this pass; from the second pass, at HEAD).
   - Where: `theories/becoming/results/data/spine.json:509`, `laws_zh.statements.Widening`.
   - Now: "扩大（包含并超出）是非自反、单向且传递的；在延续条件之下，它是保留并添加；更广者更好，是 C 的读法". That is "the wider is better is C's reading", C as "better" (H1, H5). It is the 译文 column of THEORY-GRAPH.zh's shared-laws table, where the generated page still shows the older "伦理加上延续条件定范围、C 定次序".
   - The English it translates (08 §7's row) now ends "on a finite listing it is exactly what every additive weighting that counts each listed item above zero ranks higher".
   - Proposed: "扩大（包含并超出）是非自反、单向且传递的；在延续条件之下，它是保留并添加；在一个有限列表上，它恰是凡给每个所列之物一个大于零的权重、再把权重相加的计法都排得更高者（`Weighting.widens_iff_every_positive`）". The generated page then follows at the render.
2. **H15's prescribed sentence misplaces its quantifier** (the coordinator's wording; also found by verify-ch08, verify-onepage and verify-opening).
   - The Lean: `increasingInOwn_iff_increasing_iff_marks` (PremiseWitnesses.lean:318) is `(∀ O, IncreasingInOwn items own O ↔ Increasing items O) ↔ ∀ x ∈ items, own x = true`.
   - The trouble: "For every order on a fixed listing, self-concern and increasing admission coincide exactly when every listed item is marked" reads as a per-order iff, which is false: an order can be both, or neither, under any marking.
   - Where: GLOSSARY.md:75, GLOSSARY.zh.md:85, OPENING.md:79 ([^ethics]), THE-THEORY-OF-BECOMING.md:144, THE-THEORY-OF-BECOMING.zh.md:148, 08-METHOD.md:95, review/PHILOSOPHY.md:374 ("For every order on a fixed listing they coincide…"), 07-SIGNIFICANCE.md:256 (the table cell "for every order on a fixed listing, exactly when every listed item is marked"). OPENING.zh.md was corrected by its verifier.
   - Proposed: "On a fixed listing, self-concern and increasing admission coincide for every order exactly when every listed item is marked". In Chinese: "在一个固定列表上，自我关切与随容纳而递增对每一种次序都相合，恰在每个所列之物都被标记之时".
   - The 07 table cell: "on a fixed listing, for every order exactly when every listed item is marked".
   - Tests pin the present words in test_uses_pages and test_navigation_pages; the pins move with them.
3. **The lake's result in 05 said beyond the test** (H13; rest's 05 with the dossiers' ALIGNMENT A-18 quote, which must change in the same landing).
   - Where: 05-COLLECTIVES.md:246.
   - Now: "LLM fishers sharing a lake kept no dependent they were not told of, under any instruction (0 of 10 per cell…)".
   - Proposed: "…, under any instruction tried (0 of 10 per cell…)", as ONE-ARGUMENT:72 says it. Then re-quote ALIGNMENT.md:567.

### 5.2 Low, for their owners

4. **05-COLLECTIVES.md:396** (rest).
   - Now: "Under these premises it can warrant building shared capacity without fixing one carrier; eligibility and basic classifications need substantive warrant".
   - Proposed: "…it can support building shared capacity without fixing one carrier; eligibility and basic classifications are supplied, each needing its own argument", as its record and the crosswalk now say it.
5. **07's H5 shorthands kept for their quotes** (ch07, with the quoters in one landing):
   - **07:113** (D45 reading), quoted by BECOMING-RENEWAL-READING.md. Now: "C does not choose between the two, so the lag's verdict is a premise beyond C". Proposed: "C asks nothing of the two, so the lag's verdict is a requirement beyond C".
   - **07:1018** (Open), quoted by SCIENCES.md:601. Now: "C leaves that pair unranked, so the lag's verdict is a premise beyond C". Proposed: "C asks nothing of that pair, so the lag's verdict is a requirement beyond C". This is verify-ch07's wording; it rejected ch07's "meets more than C asks", since deciding a pair C asks nothing of does not meet C.
   - **07:1018**, quoted by the record what-can-be-born-next. Now: "where C ranks no two courses from the empty set". Proposed: "where C asks no ranking of two courses from the empty set".
   - **07:720**, with route-b-joined's laws[3] and laws[4], which already say it. Now: "**C never ranks the course taken.** … so C between listed level paths ranks only alternatives the line did not take". Proposed: "**C asks no ranking of the course taken.** … so what C asks between listed level paths concerns only alternatives the line did not take".
   - **07:719**, the bullet head "**C read from what persisting shows.**". Proposed: "**What orders allowed by a persisting line's choices give of C.**" (verify-records).
   - **what-would-give-c.json**, `related[2].detail` (line 423). Now: "where C does not rank it". Proposed: "of which C asks nothing"; zh "C 不排它" → "C 对它无所要求".
6. **07:1015** (ch07). Now: "**How an order holding one's own continuation forms**". Proposed: "**How a self-concerned order forms**" (H14; test_featured_results and test_spine already assert the old phrase absent from the screen and the spine).
7. **08-METHOD.md:452** (ch08). Now: "in most of them any order meeting the requirement C (`Comparison`)". Proposed: "in many of them C (`Comparison`), in the direction's J1 and J2, in others self-concern", as the map page and the spine footer now say it from rest's count (connection_map.py:942 and test_connection_map pin the 08 words).
8. **mutual-dependence-gives-the-condition-de-se.json** `next_delta.zh` (ch07). Now: "自动态读出中心（自承而其所及返回之形成）". Proposed: "（以从己方式持有而其所及返回之形成）". The glossary renders de se as 从己, and the record's own eighth-pass history line says it was changed, but this field was missed.
9. **organizational-formation-from-generative-comparison.json** `hypotheses[0]` (records; also verify-records and verify-rest). It lists the condition, C and J1–J4 as hypotheses, but its bound theorems take only an irreflexive, transitive comparison on an exactly listed range and improvement witnesses (05 §11's label now separates the two). Proposed: "The reading takes the continuation condition through living significance, an order meeting C (with every claim counted as living, the requirement that an order rank each course above every course it widens) with the practical commitments J1–J4, and complete relational correspondence, each a premise of the reading, not of the theorems; ethics is not deduced from monism alone", with zh to match.
10. **route-b-joined.json** `next_delta` (J1 or coordinator). It still names "the condition read in time, along dated mutual dependence" as next, now landed as the-condition-in-time. Drop the clause, or name what that record leaves next.
11. **One-center sentences without H16 (b)'s time clause.** They are exact, with the condition as subject, but short:
    - THE-THEORY-OF-BECOMING.md:61 and .zh:65; 07:255 (the §4 table cell);
    - the-continuation-condition-on-the-root.json laws (line 48); route-b-universal-form-closed.json laws (lines 25, 148, 153);
    - continuation-condition-yields-living-significance laws[15]; significance-retained-within-margin laws[14].

    Proposed, where room allows: add "on a net going forward in time this comes from the condition's asking that nothing other than the center lie at or before the center's step (`«续无外当且仅当后与独»`, `«独则同一中心»`)", or a related link to what-the-one-center-bound-counts.
12. **MAP.md:9** (ch08). Now: "read in time, the condition holds only from some step on". The paragraph has not yet named the condition. Proposed: "read in time, the continuation condition holds only from some step on" (the test_uses_pages pin moves with it).
13. **06-CLASSICAL-TEXTS.md:426** (rest). Now: "或广者居上（C，对次序的一项要求：把一个进程排在它所扩大的每一个进程之上". It is a gloss of C without its reading. Proposed: "…：在每一个主张都算作活之时，把一个进程排在它所扩大的每一个进程之上", as 06:18 says it (H12).
14. **07:909**, §6's endorsement label "(the continuation condition, an order ranking by widening and the practical commitments; an argument)" (ch07). It is not the direction's hypotheses, so H11 does not reach it. If re-said ("an order meeting C" or "a self-concerned order"), the six crosswalk entries quoting it follow (verify-crosswalk's list).
15. **`tools/research/lean_catalogue.py:68`**, the catalogue group title "规范根据与生成方向 / Normative grounding and generative direction". This is warrant by sense, on the generated page `results/lean-declarations/ethics.md` and its anchor. Proposed: "伦理与生成方向 / The ethics and the generative direction", keeping the old anchor explicitly at the render. Left, because the heading derives the anchor and I cannot render.
16. **The reading register's rows describing history sources at their hashes** (coordinator; there is no notes field). The rows:
    - arguments-m-z [55] (the-step-of-invariance: "On order, C is exactly what every positive weighting that counts everything shares"), [56] ("what C ranks depends on the reading"), [61] ("under the relational reading C ranks every overdraw"), [72] ("the remaining first normative warrant");
    - arguments-a-l rows whose `next` says "first normative warrant", "universal normative warrant" or 规范根据 (about 18 rows, among them [31], [43] and [51]).

    One register-level note saying that the two-premise frame and the warrant question were set aside on 9 November would cover them all.

### 5.3 Choices for the coordinator (each a wording, none wrong in the Lean)

17. **Widening and the reach clause.**
    - The screen, the one page and USES say "A course widens another when …; where the condition holds, read across all steps, whatever a widening adds lies within the life's own reach", which follows the screen agent's check.
    - 08 §2 (line 92) says "Where it holds read across all steps, a course widens another when … and whatever it adds lies within the life's own reach", the anchor's form with "There" replaced. That form joins the reach clause to widening's definition.
    - Proposed: 08 §2 takes the screen's form (and a comma after "holds").
18. **Self-concern defined two ways.**
    - The fronts say "Call a life's order over courses self-concerned when it ranks above what it widens every widening that adds to its own continuation, read as what lies within its reach". That is H14's anchor, used by the screen, the one page, USES, 08 §2, COLLECTIVE-DIRECTION, the cover and the dossiers' fronts.
    - 07 (thesis line 5, §4 line 251), the overview §7 (THE-THEORY:141), GLOSSARY:75, PHILOSOPHY:10, ALIGNMENT:503 and navigation.py's OPEN_LEAD say "where a life holds its own continuation as an order over courses, ranking above what it widens every widening that adds to its own continuation, that order is self-concern".
    - Both define it. The second keeps "holds its own continuation", which the cold readers found undefined when it stood alone, and in 07 and the overview does not add "read as what lies within its reach" in that sentence.
    - Aligning on the anchor's wording would make it one sentence everywhere. 07's line 251 is quoted by navigation.py's OPEN_LEAD, PHILOSOPHY:143 and its pins, so they move together.
19. **"The two results compose directly"** (USES.md:15, inside a parenthesis after the persisting-line clause) against "mutual dependence and that ranking compose directly" (screen, one page, 07 thesis). The latter is clearer wherever a clause stands between the two results.
20. **Chinese terms not yet one** (the Chinese readers' round):
    - 一道筛选 (screen, one page, overview, USES.zh) against 过滤 (GLOSSARY.zh:85, OPENING.zh:87 and 98, 06:18, BUDDHIST:25 and 340);
    - 谱系 against 世系 for the persisting line;
    - 这条路径 in USES.zh.md:24, 77 and 83 against 这一论证路线 (screen, one page, overview), next to 两条水平路径;
    - ONE-PAGE.zh's pronoun 它就 against 这一次序就;
    - 并没有形成一种次序 against 而不是一种已形成的次序.

    The zh edition stamps (`zh_fronts.py --revised`) follow that round.
21. 07's thesis (line 5): "Where it holds de se, self-concern … ranks every widening" follows the in-time block. It is exact, since the in-time forms are other predicates, but "Where the condition, read across all steps, holds de se" would remove a doubt the screen's verifier and verify-ch07 both raised.

### 5.4 Lean docstrings and receipt-bound strings (a later Lean pass with its own core run; not edited)

- **H11.** Direction.lean:18, 56–62 ("C read as widening through the moves' frame … the order is C's and J's"), 88 (extension_iff_widens' docstring: say "with every admission counted, one outcome extends another exactly where it widens it"), 124, 324 ("a selection realizing C's order"), 387. Becoming.lean:3159 (the module index line).
- **H16 (b).** GrammarScope.lean:40 and 230, BeyondCoupling.lean:355, Becoming.lean:4635, check_becoming.py:316 and its receipt copy in becoming-verification.json ("holds only with one center"). Say "where the condition holds, every standpoint has the same center".
- **H15.** PremiseWitnesses.lean:12, 55 and 423 ("one way"): drop it.
- **H5.**
  - FromTheDynamics.lean:53 ("C never ranks the persisting course itself") and 175 ("the met-pair C ranks only keeping above ending");
  - RoutesToC.lean:5 and 9, Becoming.lean:4705 and check_becoming.py:321 ("What would give C's order on a listing", the title the record keeps because it is bound into the receipt's scope strings);
  - Ranking.lean:7 and 11, Becoming.lean:1896 ("What comparison C ranks");
  - Becoming.lean:1527 and 1570 ("C's order does not adopt");
  - Weightings.lean:383 and 6214 ("wherever C ranks");
  - EventualWidening.lean:65 ("calling eventual widening better is a premise beyond C" → "ranking eventual widening above is a requirement beyond C");
  - check_becoming.py:2820 ("C ranks the restrained course higher").
- **The frame of 9 November.** SignificanceStatements.lean:10–12 ("The ethics keeps its two premises with two roles, neither asserted") and 29 ("C's ordering is supplied"); Significance.lean:5 and 8 ("not asserted"); Readings.lean:16 and 63; Significance.lean:157 and ListingValuation.lean:19 ("normative warrant").
- The Lean README's RoutesToC and Ranking rows (lines 382 and 356) follow the module titles at that pass. The generated Lean catalogue pages follow the docstrings.

### 5.5 Ren's goal wording (listed, not edited; also shown on RESEARCH.md and GOALS.md, which are generated)

- **`_process/goals/generative-alignment.json`.**
  - objective.en: "and courses are compared by widening, the continuation condition fixing whose losses count and C ordering, both named and neither asserted". Proposed: "and courses are compared by widening, the continuation condition fixing whose losses count: on a finite listing every additive weighting counting each listed thing above zero ranks the wider course higher, and where relations close, read across all steps, a self-concerned order already ranks every widening above". objective.zh to match, with 拓宽 → 扩大.
  - overview.summary.en: "Under the continuation condition, which fixes whose losses count, and C read as widening, which orders, with the practical premises disclosed". Proposed (H11): "Under the continuation condition, which fixes whose losses count, and the practical premises disclosed, with moves compared by widening". zh: 以拓宽读出并给出次序的 C → 以扩大比较诸动作.
- **`_process/goals/zero-axiom-session.json`** objective (en, zh).
  - "the continuation condition for scope, C for order" (范围上的延续条件、次序上的 C) → "the continuation condition (whose losses count), self-concern and C (`Comparison`) where a theorem takes them".
  - "C needs its own reason" (C 需要其自身的理由) → "self-concern, which where the condition holds ranks by widening, is a hypothesis whose forming is not shown (07 §4.9)".
  - "Whether a warrant binding every possible mind exists stays an open question" → set aside as a question the map does not need (F5).
- **`_process/goals/universal-intelligence-session.json`.**
  - objective (en, zh): "Whether a stronger, universal warrant exists stays an open question the ethics does not wait on" → set aside, as above.
  - overview.summary (en, zh): "or C (widening: keeping all another course keeps and letting more form)" (或 C（扩大：…）), which glosses C as widening (H5). Proposed: "or C, a requirement on an order: with every claim counted as living, that it rank each course above every course it widens" (zh "或 C（对次序的一项要求：在每一个主张都算作活之时，把一个进程排在它所扩大的每一个进程之上）").

### 5.6 At the landing (carried)

- The render: README.md, README.zh.md (clears test_chinese_fronts' red), THEORY-GRAPH, the spine and standings pictures, map.html, record pages, RESULTS, LINEAGE, the atlas and crosswalk pages, the Lean catalogue, data/atlas.json and data/shared-laws.json (the edge record's renamed premise basis).
- Re-reviewing the records whose sources drifted (registry), and re-reading the 07 and 08 register rows before refreshing their hashes.
- The review cover's SCIENCES range (165–225 stated, about 172–223 counted).
- USES.zh's 本版落后于英文版 banner and the zh edition stamps.
- READING-BUDGETS' uses row (the hour's path 52–68, guard relaxed to 68 by the counted amount).
- FOR-REN-opening's body sentences, which wait on Ren.

## 6. The ethics said the same way across the fronts

I read the following clause by clause:

- the first screen, the one page, the overview §7, USES (In brief and human development), the review cover (its Philosophy row), 07 (thesis, §4, §4.11, T8, does-not-show), 08 §2 and §12, GLOSSARY and MAP;
- COLLECTIVE-DIRECTION, ONE-ARGUMENT, the opening's notes and the PHILOSOPHY and ALIGNMENT fronts;
- in Chinese: README-ZH, ONE-PAGE.zh, THE-THEORY.zh, USES.zh, the cover, 06, GLOSSARY.zh, OPENING.zh's notes, BUDDHIST and CODEBOOK.

Every one says:

- no should beyond becoming, and no good and evil set over it;
- the ethics emerges from continuation, with what is shown, offered and open beside it (H10);
- going on is not yet an order;
- the condition as reach where relations close, read across all steps, and read in time only from some step on, exactly where each one's acts, from every step, come to bear on every other's later continuation, with J3's names and no "only from the steps where they do";
- widening on a finite listing as the additive weighting theorem;
- "adds no premise beside the life's own concern: where the condition holds, that concern already does it", with "and", not "so";
- one-way concern that "need not count those who depend on one";
- "seeing them is needed for a choice to answer to their loss, and not enough" (要让选择因它们的损失而改变，就得看见它们，但看见还不够);
- mixed courses weighed for no one;
- the path result with decided admission and admitted pairs in a finite list, no longer labelled "one way";
- the persisting line's course never fitting such a list, so the route is silent there;
- that a life forms such an order is not shown, persisting a filter;
- C, where defined, with its reading of `living`;
- the direction's hypotheses as its Lean takes them.

The screen and the one page say the ethics paragraph word for word alike, in both languages each.

Where they differ:

- **The reach clause.** The screen departs from the coordinator's anchor in two places, both from its check, and its verifier agreed. "There, a course widens…" became "A course widens another when …; where the condition holds, read across all steps, whatever a widening adds lies within the life's own reach", so that "there" cannot be taken as the in-time reading, under which no theorem ranks. And "the two results compose directly" became "mutual dependence and that ranking compose directly". The one page and USES follow the first change. 08 §2 keeps the anchor's form with "Where it holds read across all steps" (§5.3, 17).
- **Self-concern's definition** has two wordings (§5.3, 18).
- **The quantifier sentence** of §5.1, 2.
- **Chinese terms** (§5.3, 20).

## 7. What I did not do

- No render, gate, make, lake or full suite.
- I did not read the development studies' hits one by one (counted only).
- I did not read every crosswalk entry; the crosswalk agent and its verifier did, and the atlas render has 0 errors.
- I did not edit Lean, goal JSON, the opening's body, sources, AGENTS.md, or any file a pass8 agent reported as its own.
