# AG review, ninth pass: the completeness critic

AI-written (Claude Opus 5.5). Written on 10 November 2026, about 08:50 to 09:45 WIB, on `/Users/ren/tmp/ag/rv` (branch `ag-review`, HEAD 5fb2ced14, with the ninth pass's uncommitted changes; not rendered). Every agent of the pass had finished.

I read:
- the eighth pass's critic (§1 to §6);
- both eighth-pass cold readings;
- all sixteen pass9 reports (changed, left, problems, for_ren, and the records agent's k9 table).

In the Lean I opened the statements these corrections rest on:
- `Web.extension_reached_of_met` (FromTheDynamics.lean:163);
- `Web.extension_ranked_of_increasingInOwnOn` and `Web.extension_ranked_of_increasingInOwn` (PremiseWitnesses.lean:506, 531);
- `Flow.StepInTime`, `Flow.AffectsBefore`, `UnrestrictedEventually` and `Flow.not_unrestricted_inTime` (ConditionInTime.lean:259, 264, 396, 421);
- `Flow.persists_not_listsAdmitted` and its docstrings (PersistingChoices.lean:83, 846);
- `Direction.grounded_widening_selected` (Direction.lean:325).

I ran no make, render, gate, lake or build.

## 1. The eighth pass's critic, §5.1 to §5.3, item by item

| Item | Now |
|---|---|
| 5.1.1 spine.json `laws_zh.statements.Widening` (C as "better") | **Fixed** (records). It now reads "…在一个有限列表上，它恰是凡给每个所列之物一个大于零的权重、再把权重相加的计法都排得更高者（`Weighting.widens_iff_every_positive`）". |
| 5.1.2 The H15 quantifier | **Fixed** (K5) at every listed site. These are GLOSSARY.md:75, GLOSSARY.zh.md:85 (相合), OPENING.md:79, OPENING.zh.md:87, THE-THEORY:144 and .zh:148 (重合, see §6.3, item 3), 08:95, PHILOSOPHY:374, and 07's §4 table cell (07:256) and does-not-show bullet (07:1003). The pins moved: test_navigation_pages:765, test_uses_pages:948, 1032 and 1043. |
| 5.1.3 05:246 lake result | **Fixed**: "under any instruction tried". The quote at ALIGNMENT.md:567 was re-taken. |
| 5.2.4 05:396 warrant | **Fixed**: "can support building shared capacity …; eligibility and basic classifications are supplied, each needing its own argument". |
| 5.2.5 07's H5 shorthands | **Fixed.** 07:113 and 07:1021 (twice) now say "C asks nothing of …, so the lag's verdict is a requirement beyond C", and "C asks no ranking of two courses from the empty set". The §4.13 bullets are 07:719 and 720 (K2 d). In what-would-give-c, `related[2].detail` says "of which C asks nothing" (zh C 对它无所要求). |
| 5.2.6 07's Open heading | **Fixed**: "How a self-concerned order forms" (07:1018). |
| 5.2.7 08:452 | **Fixed**: "in many of them C (`Comparison`) …; in the direction…". connection_map.py:942 says the same. |
| 5.2.8 mutual-dependence-gives-the-condition-de-se `next_delta` | **Fixed**: re-said in both languages, with no 自承. |
| 5.2.9 organizational-formation `hypotheses[0]` | **Fixed**: "The reading, not the theorems, takes …". |
| 5.2.10 route-b-joined `next_delta` | **Fixed**: the landed condition in time is no longer named as next. |
| 5.2.11 One-center sentences | **Fixed**: THE-THEORY:61 and .zh:65, 07:255, the-continuation-condition-on-the-root laws[3] and route-b-universal-form-closed laws[1] now carry the time clause. continuation-condition-yields-living-significance laws[15] and significance-retained-within-margin laws[14] each gained a related link to what-the-one-center-bound-counts. The law caps left no room for the clause itself, so this was the eighth critic's alternative. |
| 5.2.12 MAP:9 | **Fixed** under K3 ("read in time, the continuation condition cannot hold over every step …"). |
| 5.2.13 06:426 C gloss | **Fixed**, with its living reading as at 06:18. |
| 5.2.14 07:909, §6's endorsement label | **Left** (ch07's file; not among K1–K10; six crosswalk entries quote it). See §6.2, item 7. |
| 5.2.15 lean_catalogue.py:68 group title | **Fixed** (records). The title is now "伦理与生成方向 / The ethics and the generative direction". The old title stays in `FORMER`, so the anchor is kept at the render. |
| 5.2.16 Register rows that describe history sources | **Left deliberately**: the register has no notes field (coordinator). |
| 5.3.17 08 §2's reach clause | **Fixed** (08:92, the screen's form). |
| 5.3.18 Self-concern defined two ways | **Fixed** (K6). The anchor's sentence now stands in 07:5 and 07:251, THE-THEORY:141, GLOSSARY:75, PHILOSOPHY:143, ALIGNMENT:503 and navigation.py's OPEN_LEAD. 07:328 and GLOSSARY:75 say once that §4.3's "self-concern" is the scope sense. |
| 5.3.19 USES "the two results compose directly" | **Fixed**: "mutual dependence and that ranking compose directly". |
| 5.3.20 Chinese terms | **Fixed on the fronts** (§3, row 12). Remaining spots are in §6.3. |
| 5.3.21 07's thesis "Where it holds de se" | **Fixed**: "Where the condition, read across all steps, holds de se" (07:5). |

## 2. The eighth pass's cold readings, item by item

### Fable

| Item | Now |
|---|---|
| 1.1 GOALS in the withdrawn frame | **Fixed at the source** (K9). The three goal JSONs re-say only the named clauses. The old and new text of each is in pass9-records.json `k9`. GOALS.md:104, 114, 322, 362 and RESEARCH.md:42 are generated and follow at the render. |
| 1.2 The rendered README.md:19 and README.zh.md:23 ("neither asserted") | **Render item**: they are still the public face until the render runs. |
| 1.3 The opening's body | **Left deliberately** (Ren's). FOR-REN-opening carries (a) to (d3). |
| 1.4 The two aims | **K8**: AGENTS.md's sentence is now on the screen, its Chinese, USES, MAP, the cover and RESEARCH's lead. FOR-REN-opening (f) puts the three wordings side by side. The one page and the overview give only the first half (§6.1, item 1). |
| 2.1 The direction's hypotheses | **Fixed** (K4) in 07 §7's lead and label (07:916 and 919), the one page, THE-THEORY §7, USES:44 and USES-EXAMPLES, in both languages, and in 08 §12 item 4, 08:757, ALIGNMENT:63 and 529, alignment-approaches, the goal summary and 19 crosswalk labels. |
| 2.2 "Seeing … needed" with no How-far label | **Left** (low, not in K). The fronts still state it bare. 07's does-not-show states it under its premise. |
| 2.3 The screen's length | A note, not a finding. The screen's ethics now runs to two paragraphs plus How-far. |
| 3.1 之内者 | **Fixed** on the fronts ("这里把自身的延续读作自身所能到达的一切"). I fixed the theory graph's Chinese lead (spine.py, §3). The records' classical register keeps 之内者, which reads naturally there. |
| 3.2 "每一个的行为" | **Gone** (K3). |
| 3.3 都可以 / 都能 | **Fixed** (都能). |
| 3.4 在容纳已判定时 | **Fixed** (在能判定容纳与否时) on the fronts and the glossary. I fixed spine.py's copy. A history line of one-root-to-its-edge keeps the old term. |
| 3.5 （只证明了这一个方向） | **Fixed**: （其逆未证）. I fixed spine.py's copy. |
| 4.1–4.4 A loss read is not a loss borne; the own closure; naming the relation; the order side open | **Fixed** (K1). See 07:7 and AJ's PLAN.md:22 (Reading). "Relations of dependence close", "along coupling" and "along being affected" are now named at each "close" in the reading. |

### astra

| Item | Now |
|---|---|
| 1 The opening's body | **Left deliberately** (Ren's; FOR-REN-opening). |
| 2 Closing relations, and scope telling ethics from self-keeping | **Fixed**. For K1, see 07:7 and PLAN:22, including "dependence can also be made by domination". For K2 (a), 07:751 now reads "This route shows how far self-concern reaches under an adopted marking; …". |
| 3 The joined-route summary drops hypotheses | **Fixed** (K2 b), 07:719. It now names the de se condition, the marking covering the center's closure, decided admission, every claim living, both paths completely listed, and met together. I checked these against `Web.extension_reached_of_met` and `Web.extension_ranked_of_increasingInOwnOn`. |
| 4 "C never ranks the course taken" | **Fixed** (K2 d), 07:720 and §4.9. The heads at 719 and 720 are as K2 asks, and route-b-joined's laws follow. Still open: the Lean docstrings (§6.4) and the record's statement (§6.2, item 3). |
| 5 The temporal gloss | **Fixed** (K3) on every front, in 07 §3, §4.11, the glossaries, 08 §2 and MAP, in both languages. I checked it against `StepInTime`, which is `(y.1 = x.1 + 1 ∧ y.2 = x.2) ∨ AffectsBefore`, and against `UnrestrictedEventually`'s `∀ p g, ∃ T`. One phrase of J3's frame remains (§6.2, item 1). |
| 6 "Near-definitional by necessity" | **Fixed** (K2 c), 07:712, and in the regions note. The Lean docstring remains (§6.4). |
| 7 The direction's hypotheses on the summaries | **Fixed** (K4), as for Fable 2.1. |
| 8 The aim | **For Ren** (FOR-REN-opening (f)). |
| Chinese table | Applied: 在能判定容纳与否时; 这里把自身的延续读作…一切; the plainer lake instruction; the persisting sentence (K10's); the in-time sentence (K3's). Kept by K10's choice: 两条水平路径, 扩大，就是更多的未来 and 每一个主张都算作活. Not taken: "都把它排在上面" with its object, the paragraph breaks on ONE-PAGE.zh, and 看见 → 耦合 (§6.3). |
| The "emerges" wording | Kept (Fable 4.5 argues for keeping it; not in K). |

## 3. What was searched, and what it found

I searched these with ripgrep, the JSON by key:
- the live theory: GLOSSARY and GLOSSARY.zh, MAP, COMMONS;
- every hand-written front in theories/becoming, the chapters, the dossiers and the cover;
- records, data and atlas entries;
- goals, research-config, the first screens, RESULT-WORKFLOW and AJ's PLAN;
- tools/research/*.py and their tests.

I left out the generated pages (README, GOALS, RESEARCH, RESULTS, OPEN-QUESTIONS, CLAIMS, records/*.md, atlas.json, theory-graph.json, shared-laws.json), history, sources and dated studies. Hits in line-1 revision comments, `history`, `progress` and `aliases` fields, and the tests' retired-phrase lists were classified as history, not read as text.

| Searched for | Live hits outside history | Result |
|---|---|---|
| 1. "come to bear" / "each one's acts" (the temporal gloss) | 0 | Only revision notes remain (USES:1, the screen's line 1, PLAN:20's dated note). |
| 2. "holds only from some step on" | 0 | unceasing-generation-needs-renewal laws "balance … only from some step on" is another sense. |
| 3. "over what comes after" joined with the eventual form | 0 joined | Every use is the one-center bound's «续无外于后» (TwoSources.apart), or GLOSSARY:73's naming of it apart. One near case: 07:686 (§6.2, item 1). |
| 4. "takes the continuation condition, J1…" / C among the direction's hypotheses | 0 | The hits are 05 §11's organizational reading ("the reading takes the continuation condition, …"), `possible_extends_iff`'s hypothesis and open-form-realization's conditional law. All three are exact. |
| 5. "For every order on a fixed listing" (per-order iff) | 0 | Only a history line remains (self-concern-and-c `history[4]`). |
| 6. "holds its own continuation as an order" as a definition | 0 | Remaining: OPENING:75 quoting the body; 07:328, the means–end step, another sense; 07:392 and 395, shorthands (§6.2, item 4). |
| 7. "never ranks the course taken" | 0 | Lean docstrings only (§6.4). |
| 8. "by necessity" | 0 | Lean docstring FromTheDynamics.lean:17 (§6.4). Crosswalk 892 is a source's own sense. |
| 9. "relations close" in the alignment reading without the relation named | 0 | 07:7 and PLAN:22 name it each time. Ethics paragraphs elsewhere keep the bare phrase (§6.2, item 2). |
| 10. The aim in other words than AGENTS.md's on a front | 4 pages | The one page (7, 30) and the overview (3, 160) in both languages give the first half only. So does ALIGNMENT:7 (§6.1, items 1 and 2). |
| 11. "neither asserted", "for scope", "for order", "C needs its own reason", "widening what can form is better" in current fields | 0 in goals | The remaining hits are history, lineage points or other senses. PHILOSOPHY:479 "for scope" means within scope. PHILOSOPHY:143 quotes the dated note. |
| 12. Chinese terms (K10) | fronts clean | The tests forbid the old terms on the fronts. Remaining: spine.py (fixed by me), and 传代 and 诸行动 (§6.3). |
| 13. Earlier passes' corrections | 0 regressions | Checked: "every positive weighting" (titles with the additive definition beside them, as kept), "courses that end", "so ranking by widening" and "C orders" (history only), "derived from the dynamics" (only the kept `center_not_derived` sense), "dated occurrences" and "holds only with one center" (history). Also "normative warrant" and 规范根据, found only in the dated generativity-chain and session-results registers, and in Ren's goal clauses outside K9 (§6.5). |

## 4. What I changed

These are files no agent of this pass reported as its own. Each change is a sentence, with its quotes and pins checked. None is a frozen or quoted path (`gate.frozen_paths`, `gate.quoted_paths`).

1. **`tools/research/spine.py:1577–1578`**, the Chinese lead of THEORY-GRAPH.zh, the paragraph on the three boxes:
   - 读作自身所能到达的范围之内者 → 这里读作自身所能到达的一切;
   - 在延续条件以从己方式成立之处 → 在延续条件跨越所有步来读、以从己方式成立之处, as the English beside it says "read across all steps";
   - 并在容纳已判定时 → 并在能判定容纳与否时;
   - （只证明了这一方向；…） → （其逆未证；…）.

   This is word for word GLOSSARY.zh's sentence (K10, Fable 3.1, 3.4 and 3.5). The generated page follows at the render.
2. **`tools/research/tests/test_spine.py:382`**, where the pin moved with it:
   - asserted present: '这里读作自身所能到达的一切', '在延续条件跨越所有步来读、以从己方式成立之处', '并在能判定容纳与否时', '（其逆未证；';
   - asserted absent: '范围之内者', '容纳已判定', '只证明了这一方向'.
3. **`experiments/…/lean/becoming/README.md:384`**, the Lean package's PersistingChoices row (K7). The row said "where a line persists, the web's actual levels are never a listed level path". It now reads "where a line persists, under only active formations giving, activity needing support and descent, the web's actual levels are never a listed level path, so the path-ranking result does not apply to that course". These are the theorem's own hypotheses (`acting`, `dependent`, `Descended`), and the clause is K2 (d)'s. arguments-m-z and source-index list this README among their sources, so their hashes drift and are refreshed at the landing.

## 5. Checks run on the pass as it stands

The function checks:
- `check_dossiers.py`: 0 problems. The five quotations verify-ch07 found failing are re-taken.
- `spine.check`: 0, before my edit and after it.
- `lineage.check`: 0.
- `zh_fronts.problems`: 0.
- `atlas.validate`: 0 errors.

Single test files, run one after another at a load of about 7 to 13:
- test_spine: 32 OK, after my edit.
- test_navigation_pages: 53 OK.
- test_uses_pages: 54 OK.
- test_featured_results: 31 OK.
- test_connection_map: 32 OK.
- test_boundary: 62 OK.
- test_chinese_fronts: 27 OK and 1 failure. `test_the_chinese_opening_is_timed_without_its_notes` compares README.zh.md, generated before this pass, with OPENING.zh.md, so it clears at the render.
- test_site: 106 OK, 1 skipped and 1 failure. `test_the_one_page_is_timed_alike_on_its_card_in_start_with_and_on_itself` compares README.md, generated, with the one page's new time (29–38), so it clears at the render.

Neither failure is a load red. Both were predicted by the onepage and screen agents.

Also, in a second run: test_registry 21 OK (195 s), test_lineage 16 OK, test_atlas 45 OK, test_style 22 OK (1 skipped).

I deliberately did not run the full suite, the gate or the render.

## 6. What is left, with file, line, text and proposed wording

### 6.1 For Ren, or the coordinator's choice (medium)

1. **The aim on the one page and the overview** (onepage's files, both languages):
   - Where: ONE-PAGE.md:7 and 30, THE-THEORY-OF-BECOMING.md:3 and 160, ONE-PAGE.zh.md:11 and 38, THE-THEORY-OF-BECOMING.zh.md:3 and 164.
   - Now: "an alignment … that falls into neither instrumental convergence nor the meta-attractor". This is AGENTS.md's first half, without its defining clause.
   - The screen, USES, MAP, the cover and RESEARCH's lead give the whole sentence. A reader following "Start with the one page" meets the shorter aim.
   - The fourth pass's pin OnePageMakingAndMetaAttractor (test_navigation_pages:515) forbids "control over its own selection" there.
   - Proposed, if Ren takes AGENTS.md's sentence: in the Alignment paragraph, "…that keeps it out of instrumental convergence and the meta-attractor: a joint selection that reads beyond its own share and does not come to select for control over its own selection" (zh as README-ZH:13). Then reverse the pin and recount the times (the Chinese one page likely becomes 33–43).
2. **ALIGNMENT.md:7** (dossiers' file): "aligned, in AJ's plan, where control of the rule is not captured, …". These are the goal's conditions, labelled, which K8 allows. The dossier's front never states the aim itself. Optional: put AGENTS.md's clause before "in AJ's plan".
3. **Which aim wording is right** stays Ren's. FOR-REN-opening (f) sets out AGENTS.md's wording, AJ's condition 1 and astra's proposal, recommending none.

### 6.2 For their owners (low; each exact or a frame word)

1. **07:686** (ch07; J3's frame words).
   - Now: "holds in time in one form, restricted to what comes after: … the condition read from some step on is mutual dependence in time …; read over every later step it is coupling at every next step". That names two forms after "one form", next to the words of «续无外于后».
   - Proposed: "holds in time in two forms, each asking only of later steps: …". The rest stays as it is.
2. **07:571 (§4.7) and 07:982 (T8)** (ch07).
   - Now: "where relations close, read across all steps, a self-concerned order already ranks every widening above, since every continuation lies within its reach". The relation is unnamed.
   - Proposed: "where relations of being affected close, read across all steps, …".
   - The same holds at PLAN.md:20 and COLLECTIVE-DIRECTION.md:30 (dossiers' files): "it holds where relations close, read across all steps". Proposed: "…where relations close along being affected, read across all steps".
3. **route-b-joined.json `statement.en`** (ch07; 298 of 300 characters).
   - Now: "…; the course taken is never listed."
   - It carries no hypotheses, though the laws carry activity, support and descent. Under the cap, proposed: "…; under activity, support and descent the course taken is never listed", with a shortening elsewhere in the statement (for example "given one" dropped, since the laws carry it).
4. **07:392 and 07:395** (ch07, with PHILOSOPHY:354 and three crosswalk entries that quote them).
   - "what holding one's own continuation does where nothing lies outside it" → "what self-concern does where nothing lies outside it".
   - "one order in two forms, holding one's own continuation and C" → "one order in two forms, self-concern and meeting C".
5. **07:775**, the easing table header: "and C then ranks it higher" → "and an order meeting C then ranks it higher" (ch07; one crosswalk paraphrase already says it so).
6. **07:784** and **basic-priority-step-by-step.json** (`statement.en`, `laws[2].en`; ch07 and records): "where C alone leaves them unranked" → "where C asks nothing of them". Nine crosswalk entries quote the 07 line and follow it.
7. **07:909**, §6's endorsement label: "(the continuation condition, an order ranking by widening and the practical commitments; an argument)" → "(the continuation condition, a self-concerned order or one meeting C, and the practical commitments; an argument)". Six crosswalk entries quote it. The same phrase stands at 07:1002 ("an order ranking by widening or the step of invariance"); it is exact and can stay.
8. **The crosswalk** (Crosswalk phase only): cx-kpso-open-is-not-c `targets[1].says` paraphrases 07 §4 as "Where it holds de se, self-concern does what C asks between two level paths …". Proposed: "Where the condition, read across all steps, holds de se, …", as 07:5 now says it.
9. **The review cover's rows** (screen's file; at the landing). review/README.md:20 and 21 say PHILOSOPHY "151 to 197" and ALIGNMENT "180 to 235". The dossiers now state "153 to 199" (PHILOSOPHY.md:41) and "182 to 236" (ALIGNMENT.md:27). SCIENCES matches (172 to 223).
10. **Record titles in the old shorthand** (coordinator; aliases needed, and many references re-render):
    - comparison-by-widening, "Comparison C read as widening" (读作扩大的比较 C). Proposed: "The widening order meets C".
    - organizational-formation-from-generative-comparison, "Required organization under the comparison C". Proposed: "Required organization under a strict comparison with improvement witnesses". 05 §11's italic title and its pins move with it.
11. **one-root-to-its-edge's premise roles `scope` and `order`.** The generated page prints "**For order**, C, calling widening better" until a tool change renames the keys or the renderer's labels (records agent).
12. **08 §9's T6 row** (08:~545 region) and spine.json's T6 anchor `break-seen-coming` → `t6`, together, at the landing.
13. **The Lean package README lacks rows** for `Becoming.FromTheDynamics` (J1's join) and `Becoming.FallibleInquiry`. Every other one of the 395 modules has one. A row for FromTheDynamics should say what 07 §4.13 now says: near-definitional, own closure adopted as significance, and the finite-listing route not covering the course taken. That is the J1 session's or the Lean pass's.

### 6.3 Chinese, for the Chinese readers' round (low)

1. 传代 for descent in what-persisting-shows-of-an-order `laws[5].zh` and `hypotheses[2].zh`. route-b-joined and self-concern-and-c say 活动、支撑与传承; the glossary and fronts say 世系 (records' classical register). One word would help, probably 传承 in the records. 世系 on the fronts already does two jobs (verify-screen).
2. OPENING.zh.md:93 ([^alignment]) says 诸行动, against 诸动作 in K4's sentence on the one page, the overview, USES.zh and GLOSSARY.zh (dossiers' file).
3. THE-THEORY.zh:148 says 重合, against 相合 in GLOSSARY.zh:85. The onepage agent kept 重合 because §6 on that page defines 相合 as one of chapter 6's verdicts. That is a reason; the glossary could follow 重合 instead.
4. astra's points not taken:
   - "都把它排在上面" in the How-far of README-ZH and ONE-PAGE.zh loses its object. Proposed: "都把扩大另一进程的那个进程排得更高".
   - ONE-PAGE.zh's ethics paragraph could take the screen's paragraph breaks.
   - "看见它们" could become coupling language.
5. K3's Chinese short form "它不能在每一步都成立" can be read as "true at each step" (verify-screen). If revised: "按时间来读，若要求它对每一步都成立，它就不能成立，因为没有什么能到达过去". README-ZH, ONE-PAGE.zh and USES.zh move together, with their pins.

### 6.4 Lean docstrings (a later Lean pass with its own core run; not edited)

- **K2 (d).**
  - PersistingChoices.lean:83–86, the module docstring;
  - PersistingChoices.lean:846–852, `Flow.persists_not_listsAdmitted`: "an order ranking listed level paths, as C does between them, never ranks the course actually taken". Say "so the path-ranking result does not apply to that course".
  - FromTheDynamics.lean:53–55, "(d) C never ranks the persisting course itself … ranks only alternatives not taken".
- **K2 (c).** FromTheDynamics.lean:17, "**Near-definitional by necessity.** … So, on this reading, route (b) can only read significance off the flow". This one is new: no agent listed it. Say it as 07:712 now does.
- **K2 (b) heading.** FromTheDynamics.lean:40 and 132, "(c) C read from what persisting shows" → "What orders allowed by a persisting line's choices give of C".
- **H5.** FromTheDynamics.lean:175, "the met-pair C ranks only keeping above ending".
- **H11 / K4.**
  - Direction.lean:18 and 88, "C read as widening on the moves" (say "with every admission counted, one outcome extends another exactly where it widens it");
  - Direction.lean:56–59, "C read as widening through the moves' frame … the order is C's and J's";
  - Direction.lean:124, "with C read as widening";
  - Direction.lean:323–324, "the order, calling the widening better, is C's";
  - Direction.lean:387, "so that the comparison is C read as widening".
- **The eighth critic's §5.4 list stands otherwise**: GrammarScope.lean, BeyondCoupling.lean, PremiseWitnesses.lean:12, 55 and 423, SignificanceStatements.lean, Significance.lean, Readings.lean, RoutesToC.lean, Ranking.lean, Weightings.lean, EventualWidening.lean, Becoming.lean, and check_becoming.py:316, 321 and 2820. The generated Lean catalogue follows the docstrings.

### 6.5 Ren's, outside K9 (kept word for word by the records agent)

- generative-alignment `objective`: "Within this, connect normative grounds across intelligence, …" (在此之中，连接跨智能的规范根据…). This is warrant in the sense set aside on 9 November.
- universal-intelligence-session `premises`: "… are not premises of positive warrant" and "Normative universality … need separate arguments".
- The three goals are "unmarked" (written and revised by AI sessions). The K9 changes are applied and revertible, with the old and new text in pass9-records.json `k9`.

### 6.6 At the landing (carried and new)

- **The render.** It covers:
  - README.md and README.zh.md, which clear test_site's and test_chinese_fronts' reds and remove "two readings, neither asserted" from the public face;
  - GOALS.md and RESEARCH.md (the K9 text), THEORY-GRAPH(.zh), with my spine.py sentence, the spine and standings pictures, map.html, the record pages, RESULTS, LINEAGE, the atlas and crosswalk pages, the Lean catalogue (new group title, old anchor), OPEN-QUESTIONS (OPEN_LEAD), data/atlas.json and data/shared-laws.json.
- **Hashes.** Re-read and refresh 07's and 08's sha256 in the records and in the register rows (arguments-a-l [19]), and the Lean README's hash in arguments-m-z and source-index.
- **Chinese stamps.** `zh_fronts.py --revised` runs for ONE-PAGE.zh, THE-THEORY.zh, USES.zh, USES-EXAMPLES.zh, README-ZH and review/README.zh, after the Chinese readers' round. That round also removes USES.zh's 本版落后于英文版 banner.
- **READING-BUDGETS rows**, as the agents measured them:
  - one page 29–38 (zh 33–42);
  - overview 84–109 (zh 77–101);
  - USES 41–53, its hour 53–69 (guard relaxed to 69), zh 40–52;
  - COLLECTIVE-DIRECTION 43–56;
  - ONE-ARGUMENT 33–43;
  - the dossiers' wholes: PHILOSOPHY 153–199, ALIGNMENT 182–236, SCIENCES 172–223.
- **FOR-REN-opening's body sentences**, which wait on Ren.

## 7. The ethics said the same way across the fronts

I read these clause by clause:
- the first screen, the one page, the overview §7, USES "In brief", 07 (thesis, "Within the whole map", §4, §4.11, §4.13, §7, does-not-show), 08 §2, GLOSSARY, MAP, COLLECTIVE-DIRECTION, PHILOSOPHY and ALIGNMENT;
- in Chinese: README-ZH, ONE-PAGE.zh, THE-THEORY.zh §3 and §7, USES.zh "简言之", GLOSSARY.zh, OPENING.zh's notes, BUDDHIST-THOUGHT and 06.

I then tabulated fifteen clauses in English and fourteen in Chinese by pattern across these pages. The first screen, the one page and USES carry every clause, in both languages; the other pages carry the ones their scope needs. Every page says the same of each:
- no should beyond becoming, and no good and evil set over it;
- the ethics emerges from continuation, and going on is not yet an order over courses;
- the condition, where relations close, read across all steps, so that every continuation can be affected, at some remove, by every other, is nothing lying outside each one's reach along that relation.
- Read in time:
  - it cannot hold over every step, since nothing reaches back;
  - read from some step on (another predicate, named at the homes), it holds exactly where, from any formation at any step, every formation is reached at some later step, through exchanges and each one's going on;
  - "over what comes after" is joined to this nowhere.
- Self-concern is defined in the anchor's one sentence. Where 07 §4.3 uses the scope sense, that sense is named once in 07 and in the glossary.
- Where the condition, read across all steps, holds de se, a self-concerned order ranks every widening above:
  - on a finite listing;
  - and, with admission decided, between two level paths whose admitted pairs fit in a finite list.
- Under 07 §4.9's hypotheses of activity, support and descent, the course of a line that persists without end never fits such a list, so there this route is silent. Nothing says C or any order "never ranks" it.
- Widening is what every additive weighting counting each listed thing above zero ranks higher. On a fixed listing, self-concern and increasing admission coincide for every order exactly when every listed item is marked.
- "Ranking by widening adds no premise beside the life's own concern: where the condition holds, that concern already does it."
- Where relations run one way, concern need not count those who depend on one. Seeing them is needed for a choice to answer to their loss, and not enough. Counting their loss is the step offered. Mixed courses are weighed for no one.
- That a life forms such an order is not shown, and persisting is a filter. In the Chinese this is K10's plain sentence; GLOSSARY.zh adds the fuller parenthesis.
- The direction is offered under the continuation condition, J1–J4 and a correspondence to actual systems. Its theorems take J1/J2, compare moves by what their outcomes admit, and do not use the condition.
- C, where defined, carries its reading of `living`.

The screen and the one page give the ethics paragraph word for word alike in each language. USES adds its standing labels in parentheses. The overview §7 says the hinge through the coincidence theorem, not through the reach clause; that is the same claim. The one difference across the fronts is the aim (§6.1, item 1).

## 8. What I did not do

- No render, gate, make, lake or full suite.
- I did not edit Lean, the goal JSON, the opening's body, sources, AGENTS.md, or any file a pass9 agent reported as its own.
- I read the crosswalk only by search; its agent and verifier read it whole, and atlas.validate gives 0.
- I did not read the dated studies' hits.
