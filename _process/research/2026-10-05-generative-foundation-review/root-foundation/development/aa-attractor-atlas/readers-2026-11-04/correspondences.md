<!-- AI-written: one of seven read-only readers, 4 November 2026, for the atlas plan. Kept as evidence for PLAN.md; not checked line by line. -->

# Correspondence material: what exists, how it is checked, what is absent

## 0. What I did

- **Read in full:** 06-CLASSICAL-TEXTS.md §一, §二 (the corpus and classification table), §三 (most of it), §六, §七, §十, §十一, 未示 and 未决. The 08-METHOD.md §8 table and its "beyond the table" list, with each line cut to about 400 characters. 08's third-parts paragraph, also cut. The fronts and method sections of the review dossiers C, B, P, L and S. Items C-01–C-03, C-31–C-39, B-01–B-02 and B-36, plus B's "not-items" list and appendix. S-01–S-03 and A-06. The FEP page's "In brief", its claim table, §6 and Standing.
- **Read with code:** the JSON shapes and counts of the four named data files and of `y1-changes/passages.json`. The full records of the two correspondence assessments. The docstrings and key code paths of `verify_ro.py`, `verify_zh.py` and `check_dossiers.py`.
- **Skimmed:** the headings and claim titles of the meta-attractor README (claims A–P), and the headings of COLLECTIVE-DESTRUCTIVE-ATTRACTORS, GENERATIVE-REGIMES and COMMON-ORGANIZATION. The completion ledger of META-ATTRACTOR-RECONCILIATION.
- **Searched for:** domain keywords across chapters, fronts, dossiers, the 533 record JSONs, `history/` and `meta-attractor/`. Keyword hits are not readings; I checked the context of the surprising ones.
- **Not covered:** 06 §五, §八 and §九 in detail. The rest of the A, P, L and S item bodies. The `history/` correspondence chapters themselves (CHINESE-SOURCES…, CIVILIZATION-THOUGHT…, WENLI…), apart from line 67 of CIVILIZATION-THOUGHT. The meta-attractor claims beyond their titles.
- **Ran nothing heavy.** I did not run any verifier. Statements below about what a verifier "would" report come from reading its code.

## 1. Inventory of correspondence artifacts

| Artifact | Location | Unit and format | Counts | Relation vocabulary | Checked how | Standing |
|---|---|---|---|---|---|---|
| Corpus classification | `development/one-unfolding-root/corpus/`, `classify/REPORT.md`; ch06 §二 | sentence units (e.g. MJ-J-001) | round 1: 2,997 units, 8 texts; round 2: 1,119 units | codes 甲 定义, 乙 candidate, 丙一 conditional law, 丙二, 丁 evaluation (deferred), 戊 divergence, 己 contrary reading, 庚 narration, 未读出 | offsets of round-1 units checked; one AI coder per unit; no human review | AI reconstruction |
| 乙 candidates | `ou2-candidates/outcomes.tsv`; `Becoming/GrammarCandidates.lean`; record `candidate-theorems-of-the-corpus` | 59 sentences read as root statements | 38 proved; 15 proved under a premise; 3 refuted; 2 misclassified; 1 not expressible. 181 round-2 candidates untested | proved / premise / countermodel | Lean (root) | Theorem (root). The counts are counts of readings, "不是关于历史语料的定理" |
| 丙一 families | `ou7-conditional-laws/data/{groups,units}.tsv` | 219 sentences | 128 in 22 families: 103 laws, 6 refuted, 19 premises. The other 91: 33 丁, 53 not expressible, 5 definitions. Buddhist share 146; classical 73 | Y⇔Z / Z→Y, with a net where Z fails | Lean | Theorem; readings AI, unreviewed |
| Hexagram world and Y-map | `Becoming.Hexagrams`; `y1-changes/passages.json` | passages of 周易/易传 | 90 passages: 51 agreement, 27 scope, 12 divergence | agreement / scope / divergence | `verify_mapping.py`; Lean (instance ring) | Theorem (the Changes) plus readings (D47) |
| RO map | `ro-relational-sources/passages.json`; ch06 §六 `#r-chinese-sources-on-the-spine` | passage, verbatim fragments | 248 passages: 91 agreement, 98 scope, 59 divergence; 486 fragments; 604 distinct declarations; 122 records | same three | `verify_ro.py` | Assessment [D54] |
| ZH map (脉络 v1.0) | `zhonghua/{coverage,clusters,passages}.json`; ch06 §7.1 `#r-civilization-thought-on-the-spine` | judgment → entry | 5,673 judgments; 3,499 bear on the spine; 1,300 entries (453 / 647 / 200); 1,742 parallels; 251 rejected; 35 dropped (moved); 239 name flags; 76 gap notes | same three | `verify_zh.py`; `ctq.py`; three AI reads | Assessment [D62] |
| 中华本 names | `zhonghua/work/names-decisions.tsv`; ch06 §7.3 | name | 449 names, 379 anchored, 37 characters not adopted | — | `verify_zh.py` check 4 | Definition (convention) [D62] |
| Wenli and fidelity | records `wenli-on-the-spine`, `fidelity-of-the-classical-statements`, `fidelity-under-one-discipline`, `fidelity-coders-on-own-and-other-texts` | 條 / statements | 270 條; 672 scored pairs; 240 statements | LLM-coded counts | bootstrap CIs | Assessment, provisional |
| Closure-type map | ch06 §十 | early terms → spine | 9 closure terms; 4 open-marks (未, 可, 应, 转) plus "开非更多" | home links | none beyond the links | Reading [D49] |
| Dossier C | `review/CLASSICAL-TEXTS.md` | item C-nn: 原文〔unit〕, 读法 (AI, D#), 归类, 用途, 已知之弱, 问 | 39 items, 95 questions | 可 / 可而须改 / 不可 / 无从判断 | `check_dossiers.py` | for review |
| Dossier B | `review/BUDDHIST-THOUGHT.md` | same form plus a 登记 column | 36 items, 76 questions, 8 sentences to classify | 相合 / 定域 / 相分 / 反读 | `check_dossiers.py`; CBETA cross-checks (25 Oct) | for review |
| Dossier P | `review/PHILOSOPHY.md` | item: statement, Meaning, Standing and use, Readings, Known weaknesses, Questions | 27 items; 44 references | accept / with changes / reject / cannot judge | references checked against publication records 24 Oct; quotations by script | for review |
| Dossier L | `review/LOGIC.md` | as P, with Lean blocks | 29 items; 27 references; Q1–Q74 | same | references checked 24–25 Oct; Lean blocks re-compared | for review |
| Dossier S | `review/SCIENCES.md` | as P; "containment" = premises + Lean + third part | 23 items; the theses T1, T2, T6 | restated / near-definitional / third part | references via kit `ue8-sciences-dossier/README.md#references`; check_dossiers | for review |
| Dossier A | `review/ALIGNMENT.md` | as P | 22 items (A-01–A-20, A-10b, A-10c) | same | kit `aj4-alignment-readers/README.md#references-as-checked-on-25-october-2026` | for review |
| FEP page | `theories/becoming/FREE-ENERGY-PRINCIPLE.md` | claim table | 15 rows; 5 forbidden (2 weak); 5 "leaves open"; §5 "says more" | stated (core/periphery) / correspondence / near-definitional / forbidden as a guarantee / forbidden in its wording; weak / the principle says more | adds no result; links to homes | Reading [D45] where marked |
| 08 §8 known results | 08-METHOD.md `#known-results`, `#beyond-the-table`, `#third-parts` | result → closest prior | 13 table rows; 33 bullets beyond the table; the audit read 21 rows: 4 have a third part, 3 distinct | near-definitional / restated / "new as an artefact" (premise ledger) / third part | AI prior-art review (20 Oct), UE0 audit, UE6 search in 3 rounds, KD debts column | Assessment |
| Per-record correspondence | `results/records/*.json` field `correspondence` | free prose, en (525 also zh) | all 533 records | none (prose) | none specific | mixed |

**The theory graph.** `results/data/theory-graph.json` has 3,211 nodes and 6,198 edges. Of the nodes, 1,724 are `text:` corpus units, but only 23 `read-as` edges join text to result. The RO, ZH and Y-map passages are not in the graph.

## 2. JSON shapes of the named data files

**`ro-relational-sources/passages.json`.** `{about, kinds{agreement, scope, divergence}, passages[248]}`. Each passage has the fields `id, tradition, work, source, locator, fragments[], kind, declarations[], records[], atlas_ids[{atlas, id}], relational (en), reading (zh, "AI读法："), reading_en, mapper`. Every passage has at least one declaration and one record. 219 sources are under `evidence/`. Counts by tradition match the ch06 §六 table exactly, row by row.

**`zhonghua/clusters.json`.** A list of 17 entries `{key C01…C17, title, theory (en gloss), seeds (a space-separated string of characters and phrases, some marked "(相分?)" or "(后起)")}`.

**`zhonghua/coverage.json`.** `{about, model_sha256, verdicts{5,673 ids: {c primary cluster or "-", s [other clusters], k a/s/d/"-", w gloss}}}`. 3,499 have a cluster and 2,174 have "-". The `about` field says these are triage verdicts from 25 agents on 20 October. Their kinds (a 2,112, s 870, d 517) are first-pass verdicts, not the final kinds.

**`zhonghua/passages.json`.** `{clusters{C01…C17: {entries[], parallels[], rejected[], dropped[], name_flags[], notes (str), check_notes (str)}}}`.
- An entry has the fields `id, status (revised 1,165 / new 132 / kept 3), record_ids[], source_id, layer, fragments, kind, declarations, records, reading (with 原文义 then structure), names_used, layer_checked, relational, gap, locator, tradition, work, ro_passage, checked (passed 699 / corrected 601), integrator`.
- A parallel is `{record_id, same_as_entry, note}`. A rejection is `{record_id, why}`.
- Entries per cluster run from C12's 37 to C08's 145.
- 259 entries carry an `ro_passage` link.
- The `tradition` field holds **116 distinct free-text labels**, and **131 entries lack it**.

## 3. Checks and the read-count lesson

| Script | What it checks | In the standard gate? |
|---|---|---|
| `development/review-packet/check_dossiers.py` | Quotations in the forms 原文〔ID〕, 引〔PATH〕, Source […] and Quote […]. Under an ellipsis each part must occur in order, and an omission of one or two characters is reported. Backticked Lean names in core, physics and warning. Lean blocks against their sources | Yes, through `tools/research/tests/test_review_packet.py` (research-test) |
| `development/rp2-philosophy/lean_statements.py` | copies Lean statements into the dossiers | — |
| `ro-relational-sources/verify_ro.py` | 7 checks: SHA-256 of `sources/chinese-classical-texts`; fragments verbatim (Wikisource markup stripped); atlas ids; declarations in the newest core receipt; records exist; the chapter's tables; `build_passages --check` | **No** |
| `zhonghua/verify_zh.py` (and `ctq.py`) | 5 checks: 438 import files by SHA-256; one verdict per judgment; each flagged judgment in exactly one place *per cluster*; names; the chapters | **No** |
| `y1-changes/verify_mapping.py` | Y-map fragments, declarations, the chapter table | No, as far as I searched |
| `review/recoding/agreement.py` | agreement on the blind re-coding of 237 sentences | not yet run: no human coder |

**The read-count lesson.** 06 §7.1: "三读是必要的：修订者原样保留的 88 条，第二位检查者读后 84 条要改正 … 只经两读的条目不可靠；三读之后仍可能有错，此比例也不能推到第一位检查者所通过的 696 条". The counts are given in full at `history/CIVILIZATION-THOUGHT-AND-BECOMING.md:67`: the reviser rewrote 1,084 entries, added 133, kept 88 and deleted 30; the checker passed 696, corrected 517 and deleted 4. The data agrees: `checked` passed 699 = 696 + 3, and corrected 601 = 517 + 84. Dossier C-33 repeats the lesson under its known weaknesses.

## 4. Coverage by domain

"Spine" here means chapters, fronts, dossiers and records. `history/` and `meta-attractor/` are noted separately.

| Domain | Present? Where, how many, checked how |
|---|---|
| **Chinese classical** | **Extensive.** ch06 throughout; dossier C (39 items); the corpus (4,116 units); Lean tests of 59 乙 and 219 丙一; the hexagram world (record `hexagrams-on-the-spine`); the Y-map (90); RO (248 passages across nine groups); ZH (1,300 entries across 17 clusters); 中华本 (449 names); wenli. Quotations are machine-checked and the Lean is checked. Every reading, kind and name is AI-made, with no human review. Not read (ch06 未决): 诗经, 阴阳家, 农家; 老子 chapters 34 and 57; 中庸 chapters 1 and 13; the 坛经 Dunhuang text |
| **Buddhist** (as received in China) | **Present.** Dossier B (36 items); corpus units from 中论 (chapters 1, 2, 7, 21, 10, 17, 19, 24), 成唯识论 (9 passages), 起信论, 金师子章, 五教章; 146 of the 219 丙一, with all 6 refuted readings Buddhist; RO 10 passages (5 / 2 / 3); ZH entries labelled 佛* (about 90 under varied labels). Checked against CBETA for the 杂阿含 and 坛经. **Absent, and listed as gaps in B's "未列为条目之处":** the Sanskrit MMK, Candrakīrti, Pali *idappaccayatā*, 吉藏, 窥基, Tiantai, and 中论 chapter 26. 无明 is glossed as Sanskrit *avidyā* (03) |
| **Other Indian** | **Absent on the spine.** In the meta README only: claim 138 (saṃsāra; Gītā 2.62–63) |
| **Greek and Roman** | **Absent on the spine**: no Heraclitus, Plato, Aristotle or Stoics. Aristotle appears in `history/` (WISDOM-AND-CONTEXT.md:110, GENERATIVE-GROUNDING.md:605, ASSUMPTION-FREE-FOUNDATION.md:292). Meta README claims 139, 140 and 143 (Rome, the annona, Polybius) |
| **Abrahamic** | **Absent.** Meta README 143 (Hebrew prophetic critique) and README:808 (early Christians) |
| **Islamic** | **Absent.** Meta README 143 and 1115 (hisba) |
| **Indigenous** | **Absent.** Meta README:61 and :395 name "Indigenous knowledge" in a list only |
| **African** | **Absent.** The only keyword hit is the Ubuntu Linux distribution (`history/MARKETS-AND-GENERATIVE-REGIMES.md:240`) |
| **Modern Western philosophy** | **Present for ethics, personal identity and environmental ethics**: dossier P (27 items, 44 references), the STEP study, and the 08 §8 row (is–ought, Gewirth, Parfit, Sen). Spinoza's conatus, Næss, Jonas and Lewis's *de se* are in P. Genidentity (Lewin, Padovani) is in L. **Absent on the spine:** Kant and Hegel (history only), process philosophy (Whitehead, Bergson), Heidegger, Simondon, Deleuze, Marx; pragmatism appears only in history (6 files) |
| **Systems thinking** | **Thin.** Meadows et al. 1972 (overshoot, "near-definitional": 05 and S-11). Ashby's requisite variety and deadbeat control, and Conant–Ashby as a contrast (08 §8). Ostrom 1990 (05:413). Scheffer 2009 on early warning (08 §8, T6). **Absent:** Senge and the system archetypes, leverage points, Beer's viable system model, second-order cybernetics, Luhmann (meta only), Holling's panarchy and adaptive cycle, Forrester (history only) |
| **Dynamical systems and physics** | **Present:** S-04–S-06; 08 rows (Poincaré, Landauer, Bennett, Lyapunov, LaSalle, Floyd, Schrödinger, Prigogine, Petri nets); beyond the table: stochastic thermodynamics, constructor theory, causal sets, Kolmogorov. Verdicts are "restated", or "level / states less". Bifurcation enters only through Clark and May's fold; no self-organized criticality or percolation |
| **Ecology** | **Present:** S-11–S-16; T1, T2 and T6 with frozen tests (yeast, fish stocks, seabirds, flour beetle); Clark 1976, May 1977, Gordon, Hardin. Holling's resilience is absent |
| **Evolution** | **Present:** S-07–S-10; 08 rows (Price, Fisher, Hamilton, Malthus, Wright–Fisher, Moran, Kimura, Haldane, Eigen, Nowak); one third part, the Malthusian bound |
| **Economics** | **Present, by result:** the commons and positional goods (Hirsch), opportunity sets (Pattanaik–Xu), Arthur 1989, Kreps, Chichilnisky, von Weizsäcker and Gale, Simon, Richter and Afriat, bioeconomics; the market-model assessment ("adds no mathematical advantage", 08 §8) |
| **Political science and sociology** | **Sparse:** information cascades (record `a-cascade-at-the-histories-reached`), Lewis and Skyrms conventions, the voter model, relative position as zero-sum, capture through the rule (Everitt 2017); the Chinese 法家 and 兵家 (RO: 13 passages, 8 divergent). Olson, Granovetter and Schelling get one or two hits each. Not on the spine: the meta README's historical layer |
| **Psychology** | **Sparse:** the habit literature (Miller, Shenhav and Ludvig 2019). Four assessment records reanalyse public data: `naming-attention-coverage` (36 infants), `encounter-control-and-retention` (CuriGaze, 75), `situated-recovery-empirical-correspondence` (16), `context-sensitive-updating-correspondence` (24). Kahneman-type work is absent from the spine |
| **AI alignment literature** | **Present:** dossier A (22 items); 08 §8 bullets (Ross 2011, Langosco 2022, Everitt 2017, Hubinger 2019, Soares 2015, Omohundro 2008, Good 1967, Hadfield-Menell 2017, Taylor 2016, Zhuang and Hadfield-Menell 2020); record `alignment-approaches-under-the-selection-laws` (6 approaches); record `coupling-closures-of-training-pipelines` (Gao 2023, Wen 2024, Sharma 2023, "figures are from the papers abstracts"); tests LA2–LA4 and IN1; theses T3 and T7 |
| **Logic and mathematics** | **Present:** dossier L (29 items, 27 references); 08 §5 calibrations; Tarski, Park, Milner, Hennessy–Milner, LPO/WLPO/LLPO, Lawvere, Kripke and Gupta–Belnap |
| **FEP** | The page itself (15 rows) and S-17; "farther than the principle alone … not yet farther than the sciences taken together" |

## 5. The meta-attractor line: on the spine or not

**On the spine**, with records:
- `Becoming.RuleCapture`, `ClosedCapture`, `RuleShaping`, `DrawnShaping` and `ReadInTime` (the meta README header lists the records: `closed-capture`, `readers-drawn-from-the-selected`, `shaping-the-rule-selected-by-what-comes-back`, `shaping-read-by-readers-drawn-from-the-selected`, `loss-read-in-time-by-the-others`). Also `ChoiceCountCapture` (02 §9, read as Arthur's lock-in).
- "The metric survives its own refutation" is ClosedCapture's lock outliving its loss, and thesis T7.
- 科举 as an anti-attractor that became a trap: 07, reading `RuleCapture.Alternating.never_locked`.
- Absorbed criticism is partly covered: in ClosedCapture, a change of the reading alone is absorbed.
- The early closure types and open marks are mapped to spine laws in ch06 §十 (成闭 = attraction not returning; 元闭 = capture through the rule and closed capture; 伪开 = joint excess, finite horizon, runaway).

**Not on the spine** (claim numbers from the meta README):
- totalisation as the loss of "indispensable, non-compensable independent capacity" (75), and its three endings (76);
- non-totality and patches (72–74);
- partial capture and its "decisive nodes" (77–79);
- plurality as material independence (80–84);
- the CAOC (Control–Accumulation–Optimization–Competition) covariance derivation (§C; the reconciliation ledger separates the August and October laws and lifts neither);
- the comparisons with Moloch, ideology, paradigm, autopoiesis and Schmachtenberger (117–131);
- the historical and cross-cultural layer (132–146);
- the counter-attractor "openness criterion", an ecology of generative attractors (230);
- tempo and slack, the guardian test, the cosmic-cancer film (§N–§P);
- Wamo, which appears only as "Wamo texts" and "Wamo Guardian" (meta README; a separate theory in `theories/wamotopia-and-the-wamo-protocol/`).

COLLECTIVE-DESTRUCTIVE-ATTRACTORS, GENERATIVE-REGIMES and COMMON-ORGANIZATION cite **no `Becoming.` declarations**. Their Lean is in older experiment packages outside the Becoming spine (e.g. `experiments/market-generativity/meta-attractor/{CollectiveDestruction,CommonOrganization,CommonTaskRevision}.lean`), cited by its theorem and audit counts. They link to 2, 0 and 3 records.

## 6. Flags: false, stale or contradictory

1. **The correspondence data has drifted, and nothing catches it (medium-high).**
   - **Record id.** `ro-relational-sources/passages.json` (10 times) and `zhonghua/passages.json` (27 times) cite the record `whole-first-and-bounded-centers`. Commit 603ce1722 (3 Nov) renamed it `whole-and-regions-and-bounded-centers`; only a `.md` redirect remains and there is no `.json`.
   - **Declaration name.** Both files cite `Becoming.Pool.difference_belongs_to_the_joint`. OU7 (e5951932b, 1 Nov) renamed it `Becoming.Pool.difference_only_together`, and the old name is absent from core receipt 20261103T211917.845905Z. The chapter (§六, 老子五十一) already uses the new name.
   - **Effect on the checks.** By their code, both verifiers would now fail: verify_ro check 5 tests `(RECORDS / f'{r}.json').exists()`, and verify_zh builds `records = {p.stem for p in RECORDS.glob('*.json')}` and runs `decl_ok`. Yet ch06 §六 says, in the present tense, "所引之声明皆在纯核回执之审计清单中，所引之记录皆存在". Neither script is in research-test.
2. **Stale chapter paths in the verifiers (medium).**
   - `verify_ro.py`'s default chapter is `theories/becoming/chapters/CHINESE-SOURCES-AND-BECOMING.md`. `verify_zh.py` looks for `chapters/{THE-THEORY-OF-BECOMING-ZHONGHUA, CIVILIZATION-THOUGHT-AND-BECOMING, WENLI-AND-BECOMING}.md`. All four now live in `theories/becoming/history/`.
   - verify_ro appends "no chapter at …", so a default run fails. verify_zh silently `continue`s, so check 5 (quotations, declarations, links, 对照 kinds and tables of those chapters) no longer runs.
   - The `validation_scope` of record `civilization-thought-on-the-spine` still says those chapter checks pass.
3. **"Meta-attractor" has two senses (medium; core vocabulary for the atlas).**
   - `GLOSSARY.md:39` and `02-MAP.md:402` define 元吸引子 as closed capture: "a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share".
   - `meta-attractor/GENERATIVE-REGIMES.md` (8 Oct) gives the neutral working definition Ren selected: "a recurrent organization of activity whose consequences help reproduce the conditions selecting that organization, across changes in its particular carriers". `META-ATTRACTOR-RECONCILIATION.md` says "the old proposal to reserve the word exclusively for pathology is superseded".
   - The meta README's one-paragraph statement is a third sense.
4. **"Each placed once" overstates the check (low-medium).** ch06 §7.1 says "各自恰好落在一处", and the record says "each placed once". verify_zh checks one place *per flagged cluster*. Counting `passages.json` myself: 3,403 judgments sit in one place and 96 in places in more than one cluster. 245 are rejected only, against the chapter's 250, so the counting rule behind the 3,249 base is not stated.
5. **Pointer to the read counts (low).** ch06 §7.1 says "各读之数见记录", but the record gives no read counts. They are at `history/CIVILIZATION-THOUGHT-AND-BECOMING.md:67`.
6. **95 against 96 (low).** Record `civilization-thought-on-the-spine` `does_not_show` says "95 classical words … carry no checked quotation". ch06 §7.3 and C-34 say 96.
7. **Dated counts (low).**
   - The civilization-thought record gives 1,495 declarations and 196 records; the file now cites 1,603 and 234.
   - `hexagrams-on-the-spine` says its passage map has 44 passages; `y1-changes/passages.json` now has 90.
8. **Definitions and labels drift between data and home (low).**
   - The `kinds` text in the data files differs from ch06 `#three-relations`. RO: "相分：…或与理论的结构相冲突". Y-map: "…结构名称相冲突". Agreement in the data is "与之对应", where the chapter says "结构相同".
   - Tradition labels differ: RO "兵家、法家与轻重纵横" and "佛教" against the chapter's "兵家、法家、管子与纵横" and "汉传佛教". ZH has 116 free-text tradition labels, and 131 entries have none.
9. **Triage kinds look like final kinds (low).** `coverage.json`'s `k` values are triage, not the final kinds. An atlas reading them would report 60% agreement where the entries give 35%.

## 7. Consequences for the atlas

- **Relation vocabularies.** At least five are in use: 相合/定域/相分; the 己 反读 register; FEP's stated / forbidden / weak / says-more; the restated / near-definitional / third-part verdicts; and the closure-type mappings. The atlas needs one schema with a mapping from each, taking ch06 `#three-relations` as the home definition.
- **Per-record correspondence.** All 533 records carry it only as prose, with no domain or kind field.
- **Not yet joined to the graph.** The RO, ZH and Y-map correspondences are outside the theory graph.
- **Machine-checked first means fixing the checks.** The atlas cannot claim to be machine-checked until flags 1–2 are fixed and the RO, ZH and Y-map verifiers are joined to research-test.
- **Two gaps.** Outside China and Chinese Buddhism, no wisdom tradition is mapped on the spine. Classic systems thinking (Senge, Beer, Holling, Meadows beyond overshoot) is also absent.