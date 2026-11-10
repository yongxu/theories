# The atlas, and finishing the map: a plan for review

*AI-written, 4 November 2026, for Ren's review. Nothing here is claimed on the board, landed or run. About fifty minutes to read; §0 takes ten. It rests on seven read-only reports written today ([readers-2026-11-04/](readers-2026-11-04/)), of which four findings were checked against the sources by hand (§1.3). It adds no result.*

*Status, 6 November 2026. Phase 0's errata landed (`cb58b403c`). §7's tests went as far as they could before Ren's hold of that day on new test designs: SCL and CMT are frozen and not run, T7F did not freeze, and the hysteresis test waits on CY (CY landed on 10 November; the test now waits on the hold alone, §7). Phase 1's tool and family C have landed ([ATLAS.md](../../../../../../theories/becoming/results/atlas/ATLAS.md)): the dynamics only, of the eight kinds in §3.2. The other seven families were extracted and checked on 6 and 7 November ([the note](phase1/FAMILIES.md)): 177 dynamics. §4.1, §4.4 and Appendix A and B below are the first pass, unchecked when written; where they differ from the atlas, the atlas stands. The other kinds are next, their agent counts proposed first. §2 to §12 stand as written on 4 November unless a line says otherwise.*

The request (4 November 2026, in chat; verbatim in [the source record](../../../../../../sources/15-codex-theory-conversations/2026-11-04-the-atlas.md)): finish what the map does not yet do, and "map out all attractors, phase transitions, what maps onto existing wisdoms, systems thinking, philosophy, cultures and scientific/logic understanding", as "a full, very detailed, structured, well thought, data collection, that can be visualized in all different ways, and server as our progress map, and make the theory complete" (sic: serve). Later the same day, on the order: "lean "unification of the root" needs to be done - we just need to make them run fast, but our order should be finishing the objectives of plan direction first, and improve overtime" (§5, RU; the gate change GT is drafted separately).

---

## 0. In ten minutes

**What exists already.** Most of the data the request asks for is in the repository, though not in one place:

- 533 result records as JSON (schema 2), each with laws, hypotheses, `does_not_show`, counterexamples, a prose `correspondence` and a `next_delta`;
- a generated theory graph (3,211 nodes, 6,198 edges);
- a completion check whose seven criteria all pass, and 08's twelve ranked open items;
- about 40 experiment folders, with T1 to T8 tested in part;
- Chinese correspondences at scale: 248 passages from nine bodies of thought, and 5,673 judgments of 《中华思想脉络》 placed in 1,300 checked entries;
- six review dossiers (classical, Buddhist, philosophy, logic, sciences, alignment) and a page on the free-energy principle.

**What is missing:**

- **No catalogue of dynamics.** Locks, drains, absorptions, cycles and thresholds are spread over 02, 03, 04, 05 and 07. No catalogue names them, joins each to its exits, and says what would refute it.
- **Correspondence beyond China is thin.** Outside Chinese thought and Chinese Buddhism, no wisdom tradition is mapped on the spine. Classical systems thinking (Meadows's traps, Senge, Beer, Holling) is absent. Correspondences are prose, not data.
- **Seven gaps have no law.** The fourth combination of control and lock; noise over the long run; how pools resist capture; the second-order direction of 生生 (set aside, §5's SO row); a premise weaker than C (set aside with it); the corpus's wide sense of the meta-attractor; and, of cycles, when a regime cycles and with which period, with hysteresis. (10 November: CY narrows the last without closing it. A step reversing the order on a band it keeps ends every run there at rest or period two, and a run turns only where the step breaks the order ([where a run turns](../../../../../../theories/becoming/results/records/where-a-run-turns.md)); under one draw the draws before decide the level, with separated bounds for collapse and for leaving the inflow, not exact thresholds ([the draws before](../../../../../../theories/becoming/results/records/the-draws-before.md)). A general law of when a regime cycles, with its period, and hysteresis with distinct collapse and recovery thresholds are still absent.)

**What the plan does, in order:**

1. **Errata first.** The readers found about forty places where a page is stale, overstated or self-contradictory. Some would change what a reader believes; Appendix C lists them. Each is verified and then sent to its page's owner. This comes first by AGENTS' order, and it is cheap.
2. **The atlas, version 1.** It is a curated data layer, not records, at `theories/becoming/results/atlas/`. A tool validates it and renders it, and each standing is derived from the linked records, never typed in. It holds eight kinds of entity: dynamics, transitions, exits, premises, theses and tests, correspondences, open items, and progress events. Extraction is done by readers working in parallel, and checked by other readers.
3. **Finishing the map: eight Lean items.** Each is claimed on the board, built as a new leaf module, read by an independent reader, and landed with its record and home section. The order is set by what can change a verdict: first CW, the premise lattice around C, and MC, the fourth combination; then WM, the meta-attractor in the corpus's wide sense.
4. **Correspondences** in twelve domains, each placed with three reads, the number the Chinese work found necessary. Before that, the Chinese verifiers are mended and joined to the standard test run, because their data has drifted (Appendix C, E1–E3).
5. **Refuters** for dynamics that have no test, designed and frozen. Any run with model calls or downloads is Ren's.
6. **Views and two new criteria.** Views of every kind are generated from one JSON (§8). K8 checks atlas coverage. K9 asks that every limit be dated or proved.
7. **Root unification, after these (RU).** 303 of the 382 core modules do not yet state their laws on the grammar, and only processes and the World's relations are represented in it both ways (01 Open). RU lifts them in bottom-up batches and seeks the representation theorem for the other models, the step that would show the most at once (§5, after the order). It comes after items 1–6 because, by AGENTS' order, a lift changes nothing a reader is told unless it removes a premise; and it waits on the gate change GT, so each batch pays for one core run and one landing gate rather than one per module.

**What it will not claim:**

- The atlas adds no result, and each correspondence is an AI reading.
- "Complete" will mean that every entity has its standing, every open item says what would settle it, and every limit is either proved or dated with its reason (§2). It does not mean the warrant of C or of the continuation condition is settled; nothing here claims a verdict binding every possible mind.
- 08 §8's verdict, that none of the central results is new mathematics, stands until one of the items in §5 changes it.

**Size.** About 85 agents across six workflows, proposed per phase and not started. Today's seven readers used about 1.6 million tokens in fifteen minutes. The Lean items run at most two at a time.

**Ren's decisions.** He approves each phase's agent count. Any download of source texts for the new traditions is his (§6.4), as are the frozen runs already waiting, who sees the dashboard, and the push. The points of form where he may disagree are listed in §11.

---

## 1. What the readers found

Seven readers, each read-only, covered:

- the map and knowing chapters (02, 03);
- life and collectives (04, 05);
- the ethics, alignment and the gaps;
- method and completion;
- the correspondences;
- the data tooling and landing process;
- the tests, the board and the Lean.

Each report says what it read in full, skimmed or only searched. All seven are in [readers-2026-11-04/](readers-2026-11-04/).

### 1.1 The account by its own verdict

[08 §8](../../../../../../theories/becoming/chapters/08-METHOD.md#known-results): "None of the central results is new mathematics". What survives is the premise ledger with its witnesses and calibrations, the ethics with scope and order apart, and one vocabulary, "None of them a discovery". The theses' standings are copied from 08 §9:

- **T1:** proved in the model; beyond the model, passed three settings and failed four.
- **T2:** conjectured, on four frozen fish-stock tests. UE32 (4 November): the three numbers beat the field's embedding in 42 of 65 stocks, both states behind persistence in most.
- **T3:** the law for optima proved; the clause on trained systems conjectured, with partial support.
- **T4:** partly passed.
- **T5:** reduction proved; bound conjectured.
- **T6:** both halves proved in their models; across domains, conjectured.
- **T7:** proved in the model; LA2's bridge failed.
- **T8:** argued.

### 1.2 Data that exists, and its shape

| Store | Shape | Note |
|---|---|---|
| `theories/becoming/results/records/*.json` | 533 records: 509 theorem, 15 assessment, 5 argument, 4 target. Status: 502 recorded-checked, 20 reviewed-scoped, 7 superseded, 4 open | every `next_delta` is filled in; 264 of them ask for a review or a person |
| `results/data/theory-graph.json` | node types text 1,724, result 533, section 531, module 382, concept 41; edge types proved-in, related, formal-reuse, imports, states, interpretive, read-as, application | owned by RA, together with `theory_graph.py` and `regions.json`; only 23 `read-as` edges join a corpus unit to a result |
| `results/completion/COVERAGE.json` → `COMPLETION.md` | 17 rows (5 phase, 6 differentiation, 6 domain), 17 premises, K1–K7 all met | criteria read the Lean source text |
| `results/data/shared-laws.json`, `law-families.json`, `regions.json` | shared laws by Lean dependency (heavy, generated outside render); 5 law families; the region and base of each record | five newest records are not in `regions.json` |
| `development/ro-relational-sources/passages.json` | 248 passages: 91 agreement, 98 scope, 59 divergence | its verifier is not in `research-test` |
| `development/zhonghua/{coverage,clusters,passages}.json` | 5,673 triage verdicts; 17 clusters; 1,300 entries (453 / 647 / 200) | 116 free-text tradition labels; 131 entries have none |
| `development/y1-changes/passages.json` | 90 passages of 周易 / 易传 | — |
| Review dossiers C, B, P, L, S, A | 39, 36, 27, 29, 23 and 22 items | quotations checked by `check_dossiers.py`, which is in `research-test` |
| Experiments | about 40 folders; the RF freezes 1, 2, 3, 6 and 7 frozen, none run | runs wait on Ren (board, Decisions) |

### 1.3 Errors found

Appendix C lists them. I checked four against the sources myself, and all four hold:

- OG2 landed at `368a8bde7`, yet the board's way-now still says "if ready before the freeze, OG2".
- Both correspondence data files cite the record `whole-first-and-bounded-centers`, which was renamed (`whole-and-regions-and-bounded-centers.json` exists, and the old JSON does not).
- Both cite `Becoming.Pool.difference_belongs_to_the_joint`, which no Lean file now declares.
- The overview's line 195 lists "T3 varying how near a trained system comes to its optimum" among the tests still to run, though LA4's Stage A ran on 3 November.

The rest are the readers' findings and are verified in Phase 0 before anyone acts on them.

### 1.4 Who owns what (so nothing is reproved)

- **AJ** (fork 2) holds "control left unselected and a lock left in time not shown independent" in its text. MC is therefore AJ's, unless its owner hands it over.
- **RA** owns `theory_graph.py`, `THEORY-GRAPH.md` and `regions.json`. The atlas's graph is therefore a separate file in version 1, with a merge proposed to RA.
- **CD's next edition** renames `Web.widens_iff_every_weighting` → `Web.widens_iff_every_positive` and edits docstrings in Weightings and Ranking. CW must import Weightings and must not edit it.
- **OG part 2**, the family of the organism and the institution on the World's flows, is open and unclaimed.
- **RF's owner** has been inactive since 31 October, so by rule 4 the claim has lapsed; it has not yet been moved.
- **No open row** covers noise or fixation, pools, second-order widening or C's warrant.
- **The Lean waiting for a near-full rebuild** (Grammar, GrammarMap, GrammarLaws, PremiseWitnesses and others, from WHAT-REMAINS) must not be touched by the new items. New leaves import those modules and leave them unchanged.

---

## 2. What "complete" can mean here

- **K1–K7 are met** ([COMPLETION](../../../../../../theories/becoming/results/completion/COMPLETION.md)). 08 calls that "completion in a qualified sense": the criteria read the Lean source, and a criterion is met when it has no finding.
- **08 §12's twelve ranked open items** stay open in part. Item 12, warrant, is philosophical: a reason for C, and the step of invariance. It can be argued and narrowed; it cannot be closed by a proof (`ReadsNoOrder.not_entails`, `ReadsOnlyDynamics.not_entails`).
- **The plan's sense of complete:**
  - (a) every central declaration, thesis, premise, open item, §8 row and unification has an atlas entry;
  - (b) every entry's standing is derived and never above its sources;
  - (c) every limit is either proved (an impossibility, a countermodel or a not-entails theorem) or dated with its reason and the condition under which it lapses;
  - (d) every attractor named in the declared correspondence frame is one of three things: a case of a law, a gap stated as an open item, or outside the account with a reason.
- **K8, atlas coverage.** Its findings, in the style of K1–K7 (method reader, §g):
  - a covered item with no entry;
  - a standing above its record;
  - a base outside the seven bases;
  - a correspondence with nothing behind it;
  - an open item that no entry maps;
  - a superseded record shown as live.
  On today's data, open item 1 would already be a finding: no COVERAGE row maps it.
- **K9, limits dated or proved.** It needs fields, not a regex: `proved_by`, or `since`, `reason` and `lapses_when`. Of the 531 records with `does_not_show`, only 35 mention a year, so K9 would start with about 500 findings. It therefore begins as a report of counts and becomes a criterion only once the field is filled in. Whether to fill in 500 limits is weighed in §9; they are not all worth the reading.
- **The root, complete.** Three senses, none met today: (i) every core module states its laws on the grammar (79 of 382 do, by the [theory graph](../../../../../../theories/becoming/results/THEORY-GRAPH.md)); (ii) every model is represented in the grammar both ways (processes are, and the World for its relations but not faithfully on its amounts, [01 Open](../../../../../../theories/becoming/chapters/01-ROOT.md#open)); (iii) the ethics' laws are stated on the root (none of significance's central laws is derived from it, 01 Open). RU (§5) takes (i) and (ii); (iii) is limited by the premises themselves, since what reads no order entails nothing about C.
- **What stays open whatever is done:** the warrant of C and of the continuation condition; whether actual systems meet the hypotheses (that is observed correspondence); and what people who read it report.

---

## 3. The atlas: design

### 3.1 What it is and is not

- **It is a curated data layer**, beside the records, with generated pages. It is not records: RESULT-WORKFLOW says "A record registers a scoped claim, not a whole session or a broad theme". Like the README's featured results, it "create[s] no result and strengthen[s] no proof".
- **It holds no standing of its own.** An entry backed by records shows each record's status and links its page. An entry with no record (a conjecture, reading or open item in a chapter) carries one of `argued`, `conjectured`, `reading` or `open`, with its source cited by a `##` anchor.
- **The validator refuses** an entry saying `proved` with no `recorded-checked` record behind it, and any standing above what its records say.
- **Text is `{en, zh}`**, checked by `style.py`'s rules. Ids match `[a-z][a-z0-9-]+`.

### 3.2 Entities

| Kind | Fields (beyond `id`, `name{en,zh}`, `sources`, `labels`) |
|---|---|
| **dynamic** (an attractor, lock, drain, absorption, cycle, closure or kept region) | `family` (§4.1); `mechanism`, saying what reads what in the account's terms; `records[]`; `declarations[]`; `base` (one of the seven); `hypotheses[]`, copied from the record; derived standing; `forbids`; `exits[]`; `transitions[]`; `tests[]`; `correspondences[]`; `open[]`; `valence: none asserted`; `beyond`, what it does to what lies beyond its couplings |
| **transition** | `kind` (§4.2); control parameter; order parameter, where one exists; the exact condition (the iff, copied); `between` (dynamics); derived standing; `phase_diagram` (§8, where the condition is decidable) |
| **exit** | law; its edge; window or deadline; which of the six situationality conditions it needs (CD §6); `sufficient` / `necessary` / `exact`, as proved, or `witness`, 08 §2's constructed example |
| **premise** | from 08 §4's card and COVERAGE's premises; Lean; the models where it is met and failed (K3's witnesses); the laws that use it (from `shared-laws.json` and the records' hypotheses); standing ("stated, not asserted", "application obligation" …) |
| **thesis / test** | T1–T8, the unifications and the two philosophical theses; each test's folder, freeze file and hash, run date, verdicts, what it forbade, and whether its run waits on Ren |
| **correspondence** | `domain` (§6.3); work and locator; the source's own sense, first (06's rule: 原文义 before the structural reading); the structural reading; `relation` (§3.3); what the account adds; what the source states that the account does not yet; reads done (mapper, reviser, checker); a quote only where verified by script, otherwise a paraphrase with citation; `[AI reading]` |
| **open item** | class (further proof / philosophical warrant / empirical); what would settle it; source (08 §12 item, chapter Open line, record `next_delta`, or this plan's §5); owner; board row |
| **event** | commit, receipt or landing; date; entities touched; this is what drives the progress timeline |

### 3.3 Vocabulary decisions (argued here; Ren may object, §11)

- **Standings and bases.** Use exactly 08 §2's labels and its seven bases. Keep the thesis standings, the §8 verdicts and the record statuses as separate fields; do not merge them into one scale.
- **Relations of a correspondence.** The home is 06's three relations, 相合 (agreement), 定域 (scope) and 相分 (divergence), with 反读 (contrary reading) as a fourth. Five vocabularies are in use today; each gets one mapping table:
  - the FEP page's "stated / forbidden / weak / says more";
  - 08 §8's "restated / near-definitional / third part";
  - the closure types;
  - dossier B's register;
  - the triage `k` codes. These are first-pass verdicts and must never be read as final kinds (correspondences reader, flag 9).
- **"Meta-attractor" has two senses**, and the atlas keeps them apart:
  - The glossary's (02 §9): closed capture, "a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share".
  - The corpus's working definition (`theories/meta-attractor/GENERATIVE-REGIMES.md`, 8 October): "a recurrent organization of activity whose consequences help reproduce the conditions selecting that organization, across changes in its particular carriers". The reconciliation says reserving the word for pathology is superseded.

  02 notes the wider sense too, saying that whether a capture loop is 生成 at some pair of classes "stays **Open**". **Decision:** the atlas files the glossary's sense under the name 元吸引子 (family C). It files the wide sense as its own dynamic, "self-reproducing selection across carriers", standing `open`, until item WM (§5) gives it a law. The glossary keeps its one sense, so no word changes meaning silently. If WM lands, the glossary row is revised on argument, with a before-copy.
- **"Phase transition" is not one notion.** 02's reading (D65) separates a region ceasing, a state's departure and a strict bifurcation. 05's reading names four routes of transition, "none a proved phase transition". 02 claims no "universal phase threshold". The atlas files each transition by kind (§4.2) and keeps the physics term for correspondences only.
- **Valence.** No dynamic is marked good or bad. 02 says "Patterns of capture pass as patterns of care do", and the entry's `beyond` field says what it does to what lies beyond its couplings. Ranking, where wanted, needs C or a premise in its place, named.

### 3.4 Files and wiring (from the tooling reader, §6–§10)

```
theories/becoming/results/atlas/
  entries/{dynamics,transitions,exits,premises,theses,tests,correspondences,open}.json   curated
  vocabulary.json             closed lists: families, kinds, edge types, relations, domains
  ATLAS.md                    generated: counts, tables per kind, links to records and #r-<id>
  GAPS.md                     generated: open items → candidate results, with board rows
theories/becoming/results/data/atlas.json        generated: resolved entries, derived standings
theories/becoming/results/data/atlas-graph.json  generated (v1); merged into theory-graph.json with RA later
tools/research/atlas.py, tools/research/tests/test_atlas.py
tools/publishing/build_atlas_views.py            views (§8), outputs listed in the manifest
```

- **`atlas.py`** offers `validate()`, `build()`, `render(records)` and `main(--check, --json)`, on the pattern of `completion.render`.
- **`research.py`** gains `outputs.update(atlas_pages)` next to `theory_graph`. The curated atlas files go into `input_snapshot()`.
- **`tests/test_strict_fresh.py`** patches `atlas.render` as it patches the graph.
- **`move_rewrite_json`** gains the entries path.
- **Documentation:** a paragraph in RESULT-WORKFLOW, a row in REPOSITORY-LAYOUT, and a line in `tools/research/README.md`.
- **What the page depends on.** The rendered text depends only on the atlas files, the records, COVERAGE and `shared-laws.json`. That anchors exist is checked, not rendered, so a chapter edit does not make the atlas stale for everyone.

### 3.5 What the validator checks

1. Every record id, declaration (checked against the core receipt, or `Sources().declares` for the periphery), anchor and test path resolves.
2. No standing is above its sources. No superseded record is shown as live.
3. Every dynamic has at least one record, or a cited `##` anchor with an `open` or `reading` standing.
4. Every exit names an edge.
5. Every correspondence has a relation, the source's own sense, a reads count, and either a verified quote or a citation.
6. Every open item has a class, and an owner or "unclaimed".
7. Hypotheses are copied from the record, never paraphrased in a way that drops one (diffed against the record's `hypotheses`).

---

## 4. First-pass content (from the readers; to be checked in Phase 1)

### 4.1 Families of dynamics

Appendix A lists about 95 dynamics with record ids and Lean names. In brief:

| Family | What it is in the account's terms | Examples (record ids) | First-pass count |
|---|---|---|---:|
| **A. Absorption and ending** | a region not left; an end not returned from | `attraction-is-not-returning`, `margin-of-a-regime`, `consumption-ends-with-feeders`, `fixation-by-drift`, the institution's and organism's ends | 16 |
| **B. Drains beyond what couples in** | selection or optimization lowering what does not couple into it | `own-count-misses-joint-excess`, `the-rest-outruns-the-renewal`, `what-an-optimum-does-beyond-what-couples-in`, `a-race-for-position-draws-everything`, `several-optimizers-drain-by-their-joint-capacity` | 16 |
| **C. Capture of the selection** (元吸引子 in the glossary's sense among them) | a rule read from the share it selects | `capture-through-the-rule`, `closed-capture`, `shaping-the-rule-selected-by-what-comes-back`, `shaping-read-by-readers-drawn-from-the-selected`, `loss-read-in-time-by-the-others`, `capture-by-counted-choices`, `a-cascade-at-the-histories-reached` | 16 |
| **D. Locks of knowing** | a reading kept by what it does not test | `seeking-boundary` (无明, reading), `what-a-course-chosen-through-its-model-does-not-test`, `a-prediction-read-by-what-it-predicts`, `the-markov-blanket-as-a-coupling-structure` | 8 |
| **E. Waiting and reciprocity** | giving that waits on giving | `giving-that-waits-on-giving`, `thresholds-of-waiting`, `a-pair-tolerates-only-within-a-window` | 4 |
| **F. Cycles and alternation** | a course that returns without resting. Many are stated at witnesses; general laws say that a course within a list returns, that a period exists within a bound under function laws, when a run can keep changing, when a relay from a held start crosses both ends and when a cycle can repeat. Absent as a law is when a regime cycles, and with which period | `where-a-run-of-a-regime-comes-to-rest`, `rooms-tested-by-a-window`, `RuleCapture.Alternating.never_locked`, `Negating.alternates` | 8 |
| **G. Closure and stagnation** | what can form stops widening | `where-the-possible-grows` (`Run.not_keepsWidening_of_within`), `what-keeping-widening-needs`, `continued-change-needs-openness` | 5 |
| **H. Kept regions, renewal, generation** (none assumed good) | regions that renew, keep or generate | `generation-and-degeneration-at-two-grains`, `supported-renewal-recovery`, `a-pattern-lasts-through-passing`, `division-by-exclusive-footprints`, `a-rule-rebuilt-from-the-members-it-limits` (its band), `RaisedEveryOther` | 19 |

### 4.2 Kinds of transition

Appendix B gives the full table. The kinds:

- an exact threshold, with "one law of exact thresholds" for fates down-closed in the level, and none without (Notch);
- superadditive joint thresholds;
- a critical mass, or bistability;
- windows and deadlines;
- a juncture;
- a pace bound;
- exit by drift;
- tipping in parameters (`c ≤ s`, `lo < c < hi`, `c` against `m`, `r < k`, `k ≤ w`, `β ≤ γ`);
- critical slowing down (periphery, linearized);
- loop onset, unforeseen in the amounts;
- 05's four routes (a reading).

**Absent as laws:** hysteresis (distinct collapse and recovery thresholds); when a regime cycles, and with what period; tipping caused by the rate of change; noise-driven exit from a regulated regime; thresholds of tolerance on a general web. (10 November: CY narrows the first two without closing them, [the draws before](../../../../../../theories/becoming/results/records/the-draws-before.md) with separated bounds and [where a run turns](../../../../../../theories/becoming/results/records/where-a-run-turns.md) with rest or period two under a reversing step; it did not take up tipping by rate.)

### 4.3 Exits and the six conditions

CD §2's nine exits and §6's six conditions of situationality go in as written (ethics reader). One exit's edge matters most for the atlas: "read what lies beyond the share" is "a sufficient way out, not shown necessary". Item PR (§5) asks whether, within the class, it is necessary.

### 4.4 Gaps the readers named (attractor-like dynamics with no law)

From 02 and 03:

- when a regime cycles, and with which period (general laws of return stand: family F of the atlas; narrowed by CY on 10 November, §5's CY row);
- hysteresis (narrowed by CY on 10 November, with separated bounds and not distinct thresholds: §5's CY row);
- basins of branching processes;
- noise-driven exit from a regulated regime;
- the basin of a self-confirming lock;
- several right predictions;
- thresholds for fates that are not down-closed;
- escalation;
- increasing returns under noise;
- transitions between regions on the World;
- early warning beyond the linear case.

From 04 and 05:

- the mutation–selection balance as an attractor (convergence);
- fixation times;
- the basins of learners in a commons, and whether a mutual best response exists;
- bistability in the pure core;
- thresholds of tolerance on webs;
- selection among laws of giving over many cohorts;
- conventions under chance;
- the ends of position races (a conjecture list in 05 Open);
- the institution's ends, and its World-flow form;
- the organism's ending from every stock;
- what decides which side a lineage's course is on;
- group dynamics;
- pools;
- reserves under noise.

§5 takes the ones that change a verdict or what a reader is told. The rest become open-item entries.

---

## 5. Finishing the map: the work items

Every item follows the same route: claim on the board, its own worktree and branch, a design note, a new leaf module (so the base modules are not rebuilt), a focused `scratch_build.py`, an independent reader, then the record and home section `r-<id>`, then landing with a cached core run. At most two run at once, as in AJ's plan. Each item says beforehand what result would be a proved limit and what would be a new law, so a limit is not reported as a failure.

| Id | Question | Likely form of the answer | Builds on | Owner / coordination | What it would change | Order |
|---|---|---|---|---|---|---|
| **CW** | Is there a premise weaker than C that, with the continuation condition, gives C's order on a stated class? | A **premise lattice**: each candidate stated in Lean, every pair related by implication, equivalence or a countermodel, in the style of K3's met-and-failed witnesses. Candidates are those the repository already names (ethics reader, Gap 5): monotonicity at each standpoint, self-concern (`IncreasingInOwn`), positive valuers, graded significance, standpoint-Pareto, and quasi-option value. Then: which candidate, if any, is strictly weaker than C and, together with §4.6's P1–P4 path, entails C on the downstream class. If none does, the lattice is itself a proved limit. It never claims that C "derives from the condition": anything that reads no order entails nothing about C (`ReadsNoOrder.not_entails`) | `Weightings`, `PremiseWitnesses`, `Significance`, 07 §4.4–§4.7 | new row; tell CD's owner, since it imports Weightings and does not edit it | the one route AGENTS names that can move 08 §8's verdict ("a premise derived from something weaker"); settles what "weaker" means in CD §1, §8 and 07 §4.4 (ethics reader, flag 12) | **1** |
| **MC** | Are leaving control unselected and leaving a lock in time independent? | (a) Within two kinds, prove the prose reason, that leaving the lock below the mass means a rule favouring the shapers, as a proved limit, with ties handled (`ReadInTime.Tie.both`). (b) A third kind of reader who reads what lies beyond the share (accountable revisers): a witness or a law where control is left unselected and the lock is left in time. (c) Starts not under the rule read there (`RuleCapture.Reversed.not_absorbed`) | `DrawnShaping`, `ReadInTime`, `RuleShaping`, `ClosedCapture` | AJ (fork 2) holds it; ask its owner, and claim only on a handover or a lapse | replaces "not shown" in 07 §6, CD, GOALS, the dossier's A-10c and two records | **1** |
| **WM** | Is there a law for the corpus's meta-attractor: an organization whose consequences rebuild the conditions that select it, across changes of its carriers? | Join passing (`Web.ByPassing`, 传) to capture through the rule: a capture loop whose carriers renew while the pattern keeps. That is, is it 生成 at a pair of classes, which 02 lists as Open? Expected: an iff on when the loop is 生成 at (carrier, pattern), and a witness where capture keeps across carriers while the unread loss grows | `RuleCapture`, `ClosedCapture`, `MapInstances`, `PatternRelay` / ByPassing, grammar map laws (imported, not edited) | new row | gives the request's "meta-attractor-like dynamics" a law, or a stated limit; decides the glossary question in §3.3 | **2** |
| **PR** | How do pools form, last and resist capture? Is reading beyond the share necessary for leaving a closed lock, within the class? | (a) Turn the `PoolCourse.scheduled_apart` witness into an iff: a pool resists a capture that hides a loss exactly where admission reads what the pool does not yet read. (b) Compose `RecruitsThrough` with readers drawn from the selected, for a pool whose rule and members are both formed through what it reads. (c) A necessity converse for `turned_by_loss` within the class: from `courses_alike_iff_unread` | `SelectionPool`, `PoolCourse`, `PoolResponse`, `ClosedCapture`, `Reconfiguration` | new row; no owner holds pools | CD's exits table: the edge "sufficient, not shown necessary"; 05 Open, 07 Open | **3** |
| **IN2** | The institution on the World's flows, and capture inside it | OG part 2: the family on the World's flows, with a bridge to `Flow.joint_excess_ends`; a classification of the ends; then the members shaping the entry rule (RuleShaping inside RuleRebuilding), which is institutional capture | `RuleRebuilding`, `ReaderRebuilding`, `RuleShaping`, `Flow` | OG part 2 is unclaimed (WHAT-REMAINS l.459); ask OG's owner | the fronts' "one minimal model"; a model of an institution captured by its members | **3** |
| **CY** | When does a regime cycle, and is there hysteresis? | In whole numbers: (a) a law of when an adjusted regime cycles, with its period, from `Alternation`'s witnesses; (b) hysteresis: a band with distinct collapse and recovery thresholds (one-sided locks exist: `Flow.never_returns_below`); (c) tipping by rate, from the four routes' "change too fast for correction" and `Pace.pace_law` | `RegimeMargin` (as a leaf importing it), `Regulation`, `Pace` | new row; landed 10 November by the session TM (its row, done, is in the board's history): (a) in part, a reversing step ends at rest or period two, with a period-three witness ([where a run turns](../../../../../../theories/becoming/results/records/where-a-run-turns.md)); (b) in part, separated bounds, not distinct thresholds ([the draws before](../../../../../../theories/becoming/results/records/the-draws-before.md)); (c) not taken up | the phase-transition part of the request; the transition taxonomy gets laws where today it has witnesses | **4** |
| **SO** | The second-order direction of 生生 | Expected: a proved limit generalizing `Sides.no_order_ranks_keeping_over_alike` over orders unchanged under re-identification, plus what a further premise buys (a lexical join on what widening leaves open, `strictJoin_trans` pattern, never reversing widening). 07 already says calling eventual widening better is a premise beyond C | `EventualWidening`, `KeepingWidening`, `ComparingCourses`, `ReachableRanges`, `HeldPossible` | new row; **set aside on 10 November 2026**, with the gap of a premise weaker than C (§0), since both aim at an order of courses by widening. Ren, 10 November 2026: "i think "widening is better" is not the way to go - we need to make dynamics connected, mapped, and "unified"" (his words are kept in sources on the branch `edition-6`, `9e7fd5a94`, until edition 6 lands). CW's landed laws stay as what they prove, and widening stays as a relation between two courses and as family G's dynamics; the work goes to connecting the dynamics instead (§13) | 07 Open, CD's last "does not show"; it must keep the grammar's `«生生»` apart from the ethics' 生生 | **5** |
| **NC** | Noise and the long run of capture | (a) The window under drift: `DrawnReplacement` joined to `ReadInTime`. (b) The time to leave a lock. (c) The rare-mutation limit for the two-state chain, in the periphery, credited to Fudenberg and Imhof (2006); the periphery's Mathlib has kernels and martingales but no packaged chain theory | `Drift`, `DrawnReplacement`, `ReadInTime`; periphery | new row | T7's drift clause; CD line 125 (which already overstates what is not shown: flag S5) | **6** |

**Later, as open-item entries until claimed:**

- the existence of a mutual best response;
- the ends of a selection for position;
- thresholds of tolerance on webs;
- conventions under chance;
- convergence to the mutation–selection balance;
- the organism's ending from every stock;
- basins of branching processes;
- the twelve items of 08 §12 in their own terms.

**Order, argued.** AGENTS puts "what lets the account be wrong" and "a premise derived from something weaker" ahead of a new model:

- **CW** is the only item that can change 08 §8's verdict on its own.
- **MC** is small, and it settles a sentence five pages repeat.
- **WM** answers the request's central question.
- **PR, IN2 and CY** complete the exits and the transitions.
- **SO and NC** come last: both are expected to give limits, or known results restated.

**Root unification, after these (RU).** Lifting is the restructure's remaining formal work (01 Open, "Lifting"; 08 §6). At `0cc1aafb4`, 9,370 of 13,828 spine theorems read no World field, 348 read only `active`, and 313 (upper bound 605) read all eight, so most lifts are restatements with a lifting theorem, and a few carry the World's premises, which a lift must keep visible (08 §6: expressible is not derived).

- **The representation theorem first.** 01 says a representation theorem for the other models, with the liftings, "would show the rest". Each model shown to be a model of the grammar both ways, or its failure written down, settles many modules at once; the liftings then follow its map.
- **Bottom-up batches.** A batch is the modules of one layer whose imports are already lifted, so the core run rebuilds each closure once per batch; a change to a low module (`Grammar`, `Prelude`) is batched with everything above it that the lift touches.
- **Fast runs.** It waits on GT, the gate change: a batch lands as one train with one core run and one gate, and the Lean steps it does not touch are reused from the cache. The speedups for the checker itself are in GT's design note.
- **Board rule 9 holds:** a lift lands below the model law and proves it, never beside it.
- **Order, argued.** After the items above, because a lift removes no premise from what a reader is told unless the audit finds the premise unused, and those few lifts are flagged and moved forward when found. Ren asked on 4 November 2026 that the root's unification be done, after the plan's objectives, with fast runs.

---

## 6. Correspondences

### 6.1 What exists, and what to mend first

What exists is in §1.2; the coverage by domain is Appendix D. Mend first:

1. **Rebind the drifted names.** Both data files cite the renamed record and declaration. Re-point them through `repoint.py` with `--reason`.
2. **Fix the verifiers' chapter paths.** `verify_ro.py` and `verify_zh.py` look for the correspondence chapters in `chapters/`; they now live in `history/`. A default run of `verify_ro.py` therefore fails, and `verify_zh.py` silently skips its chapter checks.
3. **Join the verifiers to `research-test`.** Add the RO, ZH and Y-map verifiers.
4. **Correct the overstated sentences.** 06 §六's present-tense claim that every cited declaration and record exists is false today. "各自恰好落在一处" is checked per cluster only, while 96 judgments sit in more than one cluster.

These are corrections on pages the RO and ZH owners hold, sent to them with the evidence (Phase 0).

### 6.2 One schema

All correspondence moves into `entries/correspondences.json`, generated by importers from the RO, ZH and Y-map files, with each importer's hash recorded. Nothing is re-mapped. Free-text tradition labels are mapped once to a closed list in `vocabulary.json`. An entry with no label is reported, not guessed. The prose `correspondence` field of each record stays where it is; Phase 3 classifies it into entries by domain and kind, with a reader.

### 6.3 Domains, and the frame each is read in

The frame is declared before mapping, so that K8 can read it. These are the patterns each domain is read for. They are seeds from the AI's knowledge, to be checked against the sources themselves.

| # | Domain | Present today | Patterns to map against families A–H |
|---|---|---|---|
| 1 | Chinese classical | extensive (RO 248, ZH 1,300, Y 90) | import; then map only onto dynamics and transitions not yet reached (06 未决 lists texts not read) |
| 2 | Buddhist | dossier B (36); RO 10; 146 of the 219 丙一 sentences | the twelve links as a closed loop with 明 as the exit; taṇhā; saṃsāra; the gaps B lists itself (Sanskrit MMK, Candrakīrti, Pali *idappaccayatā*, Tiantai, 中论 26) |
| 3 | Other Indian | absent | Gītā 2.62–63 (a chain of attachment); karma as reproduction across carriers; Jain anekāntavāda (readings within what they read) |
| 4 | Greek and Roman | absent | Heraclitus on flux and measure; Aristotle's *phronesis* and the mean; Stoic *oikeiosis* (concern widening from oneself, which bears on the crux at 07 §4.7); Polybius's anacyclosis (a cycle of regimes) |
| 5 | Abrahamic, Islamic | absent | jubilee and sabbath years as periodic resets (rule changing without end); prophetic critique of rulers (reading beyond the share); *ḥisba*; stewardship |
| 6 | Indigenous, African | absent | seventh-generation reasoning (scope across lines); reciprocity and gift cycles (giving that waits on giving); ubuntu (relational personhood, beside 07's crux). Each must be read from published sources by members of those traditions, and kept apart from paraphrase |
| 7 | Modern philosophy | dossier P (ethics, identity, environment) | process philosophy (Whitehead, Bergson); Hegel's recognition; Marx on capital's self-reproduction (the wide meta-attractor); Simondon on individuation; Jonas's imperative of responsibility (P already cites Jonas); Spinoza's *conatus* |
| 8 | Systems thinking, cybernetics | thin (Meadows 1972, Ashby, Ostrom, Scheffer) | Meadows's system traps: tragedy of the commons → B1/B2; success to the successful → C1/C2; seeking the wrong goal → B4; escalation → B9; eroding goals → a goal read from its own share; policy resistance → absorbed reading; rule beating; addiction → D/E. Meadows's leverage points; Senge's archetypes; Beer's viable system model; Holling's adaptive cycle and panarchy; Luhmann; second-order cybernetics; Ostrom's design principles read as exits |
| 9 | Dynamical systems, physics, complexity | present (S-04–S-06, 08 §8) | saddle-node, transcritical and Hopf bifurcations; hysteresis; tipping by rate and by noise (CY); absorbing-state transitions; critical slowing down (T6); self-organized criticality; percolation (tolerance on webs) |
| 10 | Ecology, evolution | present (S-07–S-16) | alternative stable states; Allee effects (critical mass); extinction debt; evolutionary suicide (a witness exists); evolutionary traps; Red Queen; Fisherian runaway (closed capture by preference); major transitions |
| 11 | Economics, politics, sociology | partial (commons, positional goods, Arthur, Everitt) | Goodhart and Campbell; the Lucas critique and Soros's reflexivity (D5); Stigler's regulatory capture and Michels's iron law of oligarchy (C6–C8); Olson; Acemoglu and Robinson on extractive institutions; the Matthew effect; Collingridge (already credited); Schelling and Granovetter (credited); Tainter and Ibn Khaldun on the cycles of states |
| 12 | Psychology; AI alignment; logic | psychology sparse; alignment present (dossier A); logic present (dossier L) | habit and addiction; learned helplessness; confirmation bias as a closed reading. Alignment: power-seeking theorems (Turner), instrumental convergence (Omohundro, Bostrom), the Goodhart taxonomy, reward hacking, gradual disempowerment, value lock-in, multipolar traps. Logic: Lawvere, Gödel and Löb fixed points against reflexive prediction; the calibrations already in 08 §5 |

### 6.4 Method

- **Three reads** for every entry: a mapper, a reviser and a checker, as 06 §7.1 measured. Of the entries the reviser kept unchanged, the second checker changed 84 of 88. Two reads are not reliable.
- **The source's own sense first**, then the structural reading, then the relation. "同语不等于同指，也不等于相承" (06 §7.1): sameness of words is not sameness of reference, nor of lineage.
- **Divergence (相分) is kept as prominently as agreement.** Every domain reports its share of each relation, as 06 does by tradition.
- **Quotations.** Public-domain texts may be quoted, verified by script against a stored copy. Modern works are paraphrased with citations, with short quotes only. **Storing a source text for a new tradition means downloading it, and that is Ren's yes (§11).** Without it, entries cite work and locator and carry no verified quote.
- **No tradition is spoken for.** Every reading keeps its `[AI reading]` label, and the review packet's offer of human readers extends to each new domain.

### 6.5 What it will not claim

That a tradition "is" the account, or the account a tradition's; that agreement in structure is agreement in meaning; that the frame covers a domain beyond the patterns declared for it.

---

## 7. Refuters for dynamics with no test

Each dynamic's `forbids` field is checked for reach. Where a forbidden case could be met but no test is designed, a design is drafted and frozen. Freezing is not Ren's; any run with model calls or downloads is. Candidates the readers point to:

- **T7's field test** of reform events. Its Forbids names one, and 02 Open asks for it. Claimed as T7F (5 November 2026).
- **A critical-mass test** on recorded adoption data. This is Schelling and Granovetter's own domain, and it is only a test if the critical mass is located before the data: at the shapers' share `(c − lo)/(hi − lo)` (`critical_iff`), in the regime `lo < c < hi` that `critical_mass_iff` fixes. (Corrected 5 November 2026: this line named `critical_mass_iff`'s inequality as the location, which gives only the regime.) Claimed as CMT.
- **A hysteresis test** on existing yeast or fish data, after CY. The threshold must be fixed before the series is read. No row, holding so far (5 November 2026) until CY lands: until CY states a band with distinct collapse and recovery thresholds, there is no law for it to refute. The limit lapses when CY lands. CY landed on 10 November ([the draws before](../../../../../../theories/becoming/results/records/the-draws-before.md)). It does not state distinct thresholds, but it gives a law a test could refute: under any schedule of draws, a level at the inflow stays there while every draw is at least the inflow, so a level at the inflow found elsewhere later, with every draw in between at least the inflow, is what the law forbids (`DrawHistory.inflow_kept`, `DrawHistory.leaving_needs_a_lower_draw`); a draw above every giving is enough for collapse (`DrawHistory.collapses`). The record claims no correspondence with measured systems, and the inflow rest is its convention's. The limit has lapsed; the design is held with every new test design under Ren's hold of 6 November, until the first readers report.
- **A self-confirming-lock test on agents**, from `rests_of_unrefuted`'s witness: an untried act or a reading from outside should leave the lock, and nothing else should. Claimed as SCL; FREEZE-10 (TR1A) is built to the same witness and does not test its exits.
- **T1 with a need measured in advance** (02 Open). Offered by the coordinator to the owner of ED2 and ED3 as T1N, and not this plan's.

Each design names who decides its verdict, a family that neither wrote nor read the theory, as RF's freezes do.

---

## 8. Views

All views are generated from `data/atlas.json` and `atlas-graph.json`. Nothing is hand-drawn twice.

1. **The landscape.** Families → dynamics, with exits as arrows and transitions as ridges. Static SVG, in both themes.
2. **Exact phase diagrams.** For each "exactly where" law with decidable integer conditions, the condition is evaluated over a grid:
   - `DrawnShaping` (lo, hi, c): the critical mass, all-favour and none-favour regions;
   - `RuleShaping` (c against s, p);
   - coupled drawers (c against m);
   - re-optimizing (r against k);
   - mutation (k against w);
   - `ReadInTime`'s window against the start's counts;
   - `RegimeMargin`'s point;
   - tolerance thresholds;
   - the market margin (periphery).

   The grid is a Python rendering of the theorem's stated condition. At sample points it is checked against Lean, by `decide` on the decidable predicate in a small leaf. The theorem is the authority, and each diagram says so.
3. **The graph.** Dynamics, laws, premises, tests and correspondences, filterable by family, base, standing and domain.
4. **Heatmaps.** Dynamics × domains by relation (agreement, scope, divergence); premises × laws.
5. **The standing ladder** per region and per family; the theses × tests × verdicts board, with runs waiting.
6. **Exits as a flow.** Dynamic → exit → situationality condition, showing which conditions recur across exits.
7. **The timeline**, from events: landings, receipts, tests. This is the progress map over time.
8. **A private dashboard artifact** that reads `atlas.json`, made from the Dashboard type where the account offers one. Who sees it is Ren's.

---

## 9. Phases, size, checks

| Phase | Work | Agents (proposed) | Lean | Lands as |
|---|---|---|---|---|
| **0. Errata** | verify Appendix C's flags, two refuters per flag; route each to its page's owner through the coordinator; claim and fix the ones on pages nobody holds | 6 (in pairs, on the 14 belief-changing flags; the rest by me) | none | separate small landings by owners |
| **1. Atlas v1** | claim **AA**; I write `vocabulary.json`, `atlas.py`, `test_atlas.py`; extraction of dynamics, transitions, exits, premises, theses and tests from 01–08, CD, ONE-ARGUMENT and the dossiers, the home's words copied first | 8 extractors + 8 checkers who did not extract = **16** | none | one landing (docs and tools): render, `check --strict-fresh`, links, `research-test` |
| **2. Lean items** | CW and MC first (two at once), then WM, PR, IN2, CY, SO, NC; each as its own session and branch on its own row | 1 implementer + 1 independent reader per item = **16** over the phase | new leaves, focused builds; cached core run at each landing; the full checker run once, at the phase's end | one landing per item; the atlas is updated in each |
| **3. Correspondences** | mend the verifiers (§6.1); import RO, ZH and Y; twelve domains × three reads; a completeness critic for K8's frame | 12 × 3 = 36 + 2 critics = **38**, in three runs of about 13 | none | one landing per run |
| **4. Refuters** | designs for §7's candidates, frozen | about 4 designs × (designer + 2 readers) = **12** | none | one landing per freeze; runs wait on Ren |
| **5. Views, K8, K9** | `build_atlas_views.py`; K8 into `completion.py` (owner to be asked); K9 as a report | 2 readers of the views and criteria | small `decide` leaf for the diagrams | one landing |
| **6. Root unification (RU)** | the representation theorem for each remaining model; then liftings in bottom-up batches (§5, RU) | per batch: 1–3 implementers on disjoint modules + 1 reader; sized when the representation step is known | focused builds per module; one cached core run per batch | one train per batch, through GT's gate |

**About 90 agents in all.** A rough token estimate, scaled from today's 1.6 million for seven readers: Phase 1 about 4M, Phase 3 about 9M, the others 1–4M each. **A lean variant at about 45 agents:**

- two reads on domains 3–7, at the higher error rate 06 measured;
- refuter designs by me alone;
- errata verified by me alone.

**Machine load.** Load averages of 18 or more are normal here. Lean runs only on the new leaves, with `BECOMING_JOBS=1` under load. `uptime` and `ps` are checked before anything heavy. Until the gate change GT lands, the project's landing checks (render, strict check, links, `research-test`) run at every landing, as AGENTS requires; after it, each landing runs what its tier selects, and ready landings go as trains. The full Lean checker runs once, at the end of Phase 2. Reports say which checks ran.

**K9's 500 limits.** Filling `since`, `reason` and `lapses_when` for every `does_not_show` is a large pass that changes nothing a reader is told unless a limit has lapsed. So it goes record by record as each is touched, and K9 reports counts until then. If Ren wants it done at once, it is one more workflow of about 10 agents.

---

## 10. Coordination and landing

- **Claim first.** Every item is claimed on the board before any Lean or data work: AA, then each of §5's ids. MC needs AJ's owner's handover, and IN2 OG's.
- **One head.** Landings take the Queue line's head clause, re-read it immediately before landing, and fast-forward main. Nothing else commits to main while a clause stands.
- **Commits.** Owned paths only (`git commit -m … -- <paths>`), naming no person or AI, with no co-author trailer, as AGENTS requires. AGENTS overrides the harness's attribution line.
- **Generated pages are never hand-edited.** The manifest is committed with each landing. A data drift is rebound with `repoint.py --reason`, never by refreshing a hash.
- **Shared files.** The board, `experiments/README.md` and the chapters are re-read before each edit, and every hunk is checked. A landed clause replaces only the head clause; line lengths are compared before committing.
- **Records with home sections.** Each new result is stated in its record and in its home section, `r-<id>`. Cited sections are not rewritten; a new section is added beside them.

---

## 11. What is Ren's, and where he may disagree

**His, by AGENTS:**

1. The agent counts above, per phase, or the lean variant.
2. Any download of source texts for domains 3–7 (§6.4).
3. The runs already frozen (RF freezes, UE31b, TR2's downloads), and any run of §7's designs.
4. Who sees the dashboard, and the push.

**Decided here on argument; open to his objection:**

- The atlas is a data layer, not records.
- "Meta-attractor" keeps the glossary's sense, and the corpus's wide sense is filed apart until WM gives it a law (§3.3).
- The atlas's graph is a separate file in version 1, because RA owns the theory graph.
- Errata come before the atlas.
- CW and MC come before WM, though WM answers his question most directly. CW can change the account's verdict, and MC is small.
- New traditions are paraphrased with citations, not quoted, until their texts are stored.

---

## 12. Risks, and how the plan guards against them

| Risk | Guard |
|---|---|
| The atlas becomes a second account, glossing results looser than their homes | standings derived, never typed; hypotheses diffed against records; extraction checked by other readers; K8 refuses an entry above its record |
| Correspondences read as claims about traditions | the source's own sense first; three reads; divergence kept; `[AI reading]` everywhere; human readers offered |
| A limit reported as a failure, or a witness as a law | each item says beforehand what a limit and what a law would be (§5); "witness" stays a label |
| Parallel lines held open, nothing landed | at most two Lean items at once; each phase lands before the next opens |
| Collisions with live items | §1.4; claims before work; leaf modules only |
| Cost | counts proposed per phase; a lean variant; this round's cost stated |
| "Complete" heard as more than it is | §2's sense, printed at the top of ATLAS.md |

---

## 13. The next phase: the map's structures (9 November 2026)

*AI-written, 9 November 2026.*

On 9 November 2026 Ren asked how the map could be better visualized, stored, indexed and understood, and how it relates to the world, to our understanding of it, to alignment, even universal alignment, and to wisdom ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-09-map-structures.md)). Claude Opus 5.5, Claude Fable 5.1 and GPT astra each read a fixed copy of main at `008c950e5` under one brief, none seeing the others, and Opus then wrote a joint reading in Chinese ([the readings](../map-structures/readings/), [the joint reading](../map-structures/readings/04-joint-reading.md)). Asked whether that design goes to the atlas as its next phase, he answered "交给 AA" ("give it to AA"; [his answer](../../../../../../sources/15-codex-theory-conversations/2026-11-09-map-structures.md#rens-answer-the-same-evening), with the question it answered).

So this plan's next phase is that design. It builds what §3.2 designed and Phase 1 did not build (exits that end somewhere, transitions with their ends, premises, theses and tests, open items) and §8's views, in the joint reading's order (its §7). Each step is claimed on AA's row and lands through the queue on its own:

1. **The index.** `tools/research/atlas_index.py` reads the records, the atlas, the tests table, the theory graph and the declarations the core run lists into one disposable SQLite index, and counts what does not join on a generated page, [JOINS.md](../../../../../../theories/becoming/results/atlas/JOINS.md). Test ids and premise ids are tried on a small batch (LA2, LA4 and IN1; K3's 17 premises) to measure what they would join, with no entry added. No agents.
2. **The premise ledger and the exit graph, families C and D.** Premises become entries, seeded from K3's 17, 08 §4's premise card and the Lean hypothesis names, with module-qualified ids. Each exit ends at a destination predicate and says what it drops. The terrain of the two families' 38 dynamics is drawn, with the routes out of each capture region and the weakest step of each route.
3. **The layer that meets the world.** Every test is bound to its records and dynamics. Dynamics gain `touches`, and more `forbids` from the frozen predictions. LA2, LA4 and IN1 get bindings. A failure is hung on the dynamics it bears on (`bears_on`). The coverage matrix is generated.
4. **Situations and their checker.** Closed capture, the `Clearing` and `Diversion` witnesses and the lake come first, then a reward-model pipeline. The checker computes what lies beyond, where the readers come from, reading in time and mutual dependence.
5. **The wisdom matrix and Chinese names.** Dynamic × domain pages are generated from the crosswalk, and the 177 dynamics get Chinese names from their records' titles.

Beside these is a Lean item named in MS's row, from the two limits 07 §3.5 states: higher-order capture (a selection whose pool changes with its course, or that removes its own readers), and when a selection read off continuation reads before a loss passes its point of no return. J2 has since stated the first in one form ([07 §4.12](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-a-selection-removing-its-readers), `Becoming.RemovesItsReaders`, `Becoming.survivorsPersist_of_settled`). With the pool read off the course, selection by persistence passes every course whose lines settle, one removing every line included; read off a fixed pool, it is turned by every removal. Its record leaves two things not shown, and no row claims either: a reading in time, before a loss passes its point of no return, and the meta-attractor as a selection by share coming to select for control of its rule, joined to RuleShaping's counts. The second meets this plan's WM (§5).

Step 1 uses no agents. Each later step has its agent count proposed to Ren before it runs (§11, item 1). By the joint reading, none of them makes a paid run or designs a new test, so none is held by his hold of 6 November.

**Step 1 landed** on 10 November 2026, with this section ([what does not join](../../../../../../theories/becoming/results/atlas/JOINS.md)). Measured on the tree it landed on: 22 of 286 exits name a destination and 56 of 177 dynamics have no exit; none of the 66 test rows names a record or a dynamic, and by route 6 tests join records exactly, 26 only through a folder other tests share, 44 join a dynamic through the folder the atlas links, and 14 join nothing; 2,196 of 3,768 crosswalk targets resolve to a record and 693 of 1,183 entries reach a dynamic; 296 of 522 live theorem records are cited by no dynamic. The page counts them again at every render.

**Step 2 landed** on 10 November 2026, on Ren's yes to about six agents ([his answer](../../../../../../sources/15-codex-theory-conversations/2026-11-10-aa-step-2-agents.md)). Two extractors and two checkers, one of each per family, read families C (capture of the selection) and D (locks of knowing) against the Lean, a reconciler merged their premises, and a fresh reader, a new agent each round with the last round's findings, read the result five times: the first in full, the last with no high or medium. The fourth and fifth rounds were a ninth and a tenth agent, each on his yes ([his answers](../../../../../../sources/15-codex-theory-conversations/2026-11-10-aa-step-2-agents.md#later-answers)). Every exit of the two families now ends somewhere: of 51, 1 at a dynamic a law places it in (with that law named), 50 at a state in words, as its law concludes; 27 name a premise they drop. 23 of their 25 transitions name both ends they lie between, and one names one. The 384 laws of their 38 dynamics (394 listings, ten laws under two dynamics) list the premises they take, from [the premise ledger](../../../../../../theories/becoming/results/atlas/PREMISES.md) of 215 premises (K3's 17 and 08's 17 seeded; the statements of K3's four of ethics and practice withheld while their homes are re-said). [The terrain](../../../../../../theories/becoming/results/atlas/TERRAIN.md) draws the two families' exits, the routes out of each dynamic and which premise releases which lock. A law's list is not every hypothesis it takes, and "none listed" does not mean none: some bounds on a reading's parameters, some hypotheses on the model, a course or a sequence, and many start conditions are left out, as the ledger says. Completing them is a pass over every read law, not done here; it is open, and comes before the premises of another family are read, so that each family is read to the same rule. The other six families are not read for premises yet. CY, which §5 lists, is handed to the session that designed the traditions' place on the map (TM), which claimed it on its own row (`a6ab2336a`); its first piece (`Becoming.RunTurns`, `Becoming.BandRest`) and its first law, stated once as `BandRest.keeps_one_way` and saying it restates `Invariant.reach`, have landed on main.

**Step 2b landed** on 10 November 2026, on Ren's yes to about five agents ([his answer](../../../../../../sources/15-codex-theory-conversations/2026-11-10-aa-premise-lists-agents.md)). For families C and D, a law's list now names every hypothesis its Lean statement binds. A script read the binders whose type is a proposition off the elaborated statements of the 344 laws in the Becoming core; the extractors read them off the source for the 40 in the periphery. An extractor and a checker per family mapped each of the 700 binders to the premise it states. A fresh reader then read the result against the Lean; its one round found 1 high, 5 medium and 12 low, all fixed, the high being six binders mapped to the World premise of balance where they state balance only on what couples in. The lists gained 315 takes and lost 5. The ledger gained 126 premises (341 in all): 14 per-module copies of one proposition were merged into the 10 that receive them, and no existing premise was renamed. The definitions a statement is made through, the commitments, what a law holds by its form, and premises taken through data (decided, a supplied law of exchange, others present in every count) are listed as the readers and a script found them ([the step's folder](step2b/README.md)). A test holds every listing of these laws to the mapping.

**What comes next (10 November 2026).** Ren said on 10 November that "widening is better" is not the way to go, and that the dynamics are to be connected, mapped and "unified". So the next step, before §7's steps 3 to 5, reads the other six families for their premises and where their exits lead, to the same rule as C and D. Every exit gets the destination its law gives, so routes cross families. Two fields are to be proposed with it: which general law a dynamic's law is a case of, where the Lean derives it; and how two dynamics compose, where one's state is another's rule, reading or pool (the higher orders: learning, prediction, capture of the selection). Its agent count goes to Ren first. Set aside in §5: SO and the gap of a premise weaker than C.

---

## Appendix A. First pass of the dynamics

These come from the readers' reports, unchecked against every home. Phase 1 checked them, and [the atlas](../../../../../../theories/becoming/results/atlas/ATLAS.md) holds the result; this table stays as written, with its errors, some of them named in [the note](phase1/FAMILIES.md). Base key: AT any type, AP any process, W World, C counts, R root, P periphery.

| # | Dynamic | Record | Key Lean | Base |
|---|---|---|---|---|
| A1 | drawn into an absorbing region exactly where it does not return ("not a classical attractor") | attraction-is-not-returning | `Law.drawn_iff_not_returns`, `Law.reachable_absorbing` | AT |
| A2 | basins of a determined law, one cycle each | basins-of-a-determined-law | `Law.enters_returning_within`, `Law.basin_one_cycle` | AT |
| A3 | necessarily drawn exactly what does not return (vacuous at dead ends) | necessarily-drawn-is-not-returning | `Branching.necessarilyDrawn_iff_not_returns` | AP |
| A4 | degeneration from a horizon | degeneration-from-a-horizon | `Web.every_branch_ends_of_gone` | W |
| A5 | gated drain: below the need, stays below | relational-renewal-classification | `Flow.stays_below_at`, `Flow.never_returns_below` | W |
| A6 | the point of no return is exact | margin-of-a-regime | `RegimeMargin.ends_iff_below` | regime |
| A7 | consumption ends with its feeders | consumption-ends-with-feeders | `Flow.Balances.consumption_ends_with_feeders` | W |
| A8 | a cascade downstream along total dependence | coupled-regimes | `Coupled.Indexed.ends_downstream` | regime |
| A9 | co-extinction along dependence | life-as-condition-of-life | `Web.coextinct` | W |
| A10 | a whole of every part ends with one part | a-whole-of-every-part | `Web.AllWhole.ends_of_part` | W |
| A11 | a confined rise ends (cancer, germ line: reading) | confined-rise-within-a-whole | `Founding.Flow.ConfinedRise.ends` | W |
| A12 | doubling takers stop (lineage regimes) | ending-laws-as-regimes-on-a-lineage | `LineageRegimes.multiplying_takers_stop` | W |
| A13 | drift's ends absorb; fixation with selection | fixation-by-drift, fixation-with-selection | `Drift.fixation`, `Drift.Replacement.fixation` | C |
| A14 | the institution's absorbing ends | a-rule-rebuilt-from-the-members-it-limits | `«无持者不复»`, `«尽而不复»` | R |
| A15 | the organism's end does not come back | the-stock-buys-time-where-the-rebuild-draws-on-it | `«读者绝则无储»`, `«取于储者绝而不复»` | R |
| A16 | an empty pool stays empty | organizational-rule-inheritance | `empty_pool_preserved_by_core` | P instance |
| B1 | own count misses joint excess | own-count-misses-joint-excess | `Pair.own_not_joint`, `Flow.joint_excess_ends` | W |
| B2 | the rest outruns the renewal; no weight selects restraint | the-rest-outruns-the-renewal | `Flow.outrun_reading_alike` | W |
| B3 | full taking excludes | what-taking-all-excludes | `Flow.full_taking_ends` | W |
| B4 | with room, every optimum drains beyond its couplings | what-an-optimum-does-beyond-what-couples-in | `Optimum.least_iff`, `Optimum.Shared.room` | any outcomes |
| B5 | a set point's plateau decides | what-a-set-point-optimum-does-beyond | `Optimum.Nearing.not_rising` | any outcomes |
| B6 | open access ends the base (Gordon) | others-drawing-first-end-the-base | `Optimum.Next.frontier_ends_drawn_first` | any G |
| B7 | drawers in turn reach the floor profile | drawers-in-turn | `Optimum.InTurn.perfect_at_floors` | any G |
| B8 | coupled drawers drain below the need where c < m | coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it | `Optimum.Coupled.drains_below` | any G |
| B9 | a race for position draws everything | a-race-for-position-draws-everything | `Optimum.InTurn.position_keeps_nothing` | any G |
| B10 | several optimizers drain by their joint capacity | several-optimizers-drain-by-their-joint-capacity | `Optimum.MutualBest.full` | W |
| B11 | re-optimizing above a renewal ends it | re-optimizing-above-a-renewal-ends-it | `Web.course_lost_iff`, `Optimum.reread_deadline_iff` | W |
| B12 | a weighting faster than renewal ends the base | a-weighting-faster-than-renewal-ends-the-base | `Optimum.frontier_exhausts` | any R |
| B13 | a rise past the slack breaks a dependence unseen | what-a-rise-draws-from-beyond | `Flow.Balances.rise_breaks_beyond` | W |
| B14 | three risk-minimizers end a shared renewal; two continue | risk-minimization-on-a-shared-renewal | `FreeEnergyGuarantees.OneGoal.three_end` | W |
| B15 | the market's share margin | market-model-share-margin-and-ends | `RegimeBoundary.exact_floor_boundary` | P |
| B16 | a rising take ends | where-a-rising-take-ends | `Flow.seeking_ends` | W |
| C1 | target capture: the share rises | target-capture | `share_rises`, `Law.perturbation_reabsorbed` | AT |
| C2 | capture through the rule | capture-through-the-rule | `RuleCapture.favouring_locks` | AT |
| C3 | two rules lock together | two-rules-lock-together | `RuleCapture.pair_locks` | AT |
| C4 | **closed capture: 元吸引子 (glossary)**; the lock outlives the loss | closed-capture | `ClosedCapture.lock_outlives_loss`, `turned_by_loss` | AT |
| C5 | readers drawn from the selected | readers-drawn-from-the-selected | `ClosedCapture.Drawn.pool_reads_iff` | AT |
| C6 | control over the selection, selected by what comes back | shaping-the-rule-selected-by-what-comes-back | `RuleShaping.favours_iff` | C |
| C7 | the same among groups (Hamilton's rule added) | shaping-selected-among-groups | `RuleShaping.grouped_rises_iff_sized` | C |
| C8 | the critical-mass loop (stag hunt), locked either way | shaping-read-by-readers-drawn-from-the-selected | `DrawnShaping.critical_mass_iff`, `drawn_locked_either` | C |
| C9 | drawn one at a time, drift leaves either lock | drawn-shaping-drawn-one-at-a-time | `DrawnReplacement.lost_above`, `risk_dominant_iff` | C |
| C10 | the loss read in time by the others | loss-read-in-time-by-the-others | `ReadInTime.turned_early_iff`, `deadline` | C |
| C11 | counted choices: two never-left regions (Arthur) | capture-by-counted-choices | `ChoiceCountCapture.counted_locks` | W / C |
| C12 | the lock line in the grammar | rules-that-change-themselves-in-the-grammar | `ClosedCapture.lock_line`, `loss_ends_line` | R |
| C13 | a counter-rule read from its own share locks (reading D68) | (07 §6) | `RuleCapture.uniform_locks` | reading |
| C14 | an information cascade | a-cascade-at-the-histories-reached | `Turns.cascade_through_along` | W / AT |
| C15 | a pool recruiting through itself stays blind | a-pool-that-recruits-through-itself | `Web.RecruitsThrough.alike_iff` | W |
| C16 | a shared code: agreement absorbs; symmetry blocks it | a-code-formed-between-formations | `SharedCodes.agreement_kept`, `CountedCodes.never_shared` | AT |
| D1 | seeking "above all others" never rests (无明: reading) | seeking-boundary | `Law.aboveAll_never_rests`, `more_needs_open` | AT / W |
| D2 | a course rests on a model it never refutes | what-a-course-chosen-through-its-model-does-not-test | `ReadingLoop.Loop.rests_of_unrefuted`, `Untested.rests` | AT |
| D3 | seeking keeps the prior's order where experiments tie | what-seeking-cannot-separate | `LumpedSeeking.seeking_keeps_order` | AT |
| D4 | holding for a reading never senses the stop | what-holding-for-a-reading-is-worth | `HeldForReading.SignLoop.never_senses_stop` | weights |
| D5 | a prediction read by what it predicts: least fixed point, bistable, alternating | a-prediction-read-by-what-it-predicts | `ReflexivePrediction.bottom_rests`, `ThresholdResponse.reached_by_start`, `Negating.alternates` | AT |
| D6 | a drain read only by threshold, unseen until the break | the-markov-blanket-as-a-coupling-structure; runaway-distance-uncoupled | `Blanket.ThresholdDrain.any_model`, `Web.break_not_bounded` | AT / W |
| D7 | a kept region is a closed region (viability kernel) | a-reading-kept-by-its-update | `ReadingLoop.kept_iff_closed`, `Viability.kernel_iff_held` | R |
| D8 | habit lock in active inference (reading, 02 §9) | (02 §9 reading) | — | reading |
| E1 | withholding with memory absorbs (grim trigger) | giving-that-waits-on-giving | `Withholding.withholding_absorbs` | AT |
| E2 | total withholding stays without a sparing formation | thresholds-of-waiting | `Tolerance.total_stays` | AT |
| E3 | the echo: the pair never give together again | a-pair-tolerates-only-within-a-window | `Pair.echo` | AT |
| E4 | a circular wait: ignition needs a reserve present | joint-plans-from-a-supported-start | `ignition_requires_actual_reserve` | P |
| F1 | overcompensating giving can cycle (witness) | regime-point-under-adjusting-giving | `Alternation` | regime |
| F2 | beyond the no-overshoot bound, oscillation | two-sided-regulation-and-late-reading | `Flow.withinGap_iff_between` | W |
| F3 | the overshooting room alternates 3 and 4 | rooms-tested-by-a-window | `Overshooting.alternation_shifted` | R |
| F4 | a threshold reading read late alternates, never locked | capture-through-the-rule | `RuleCapture.Alternating.never_locked` | AT |
| F5 | negation alternates for ever | a-prediction-read-by-what-it-predicts | `Negating.alternates` | AT |
| F6 | without memory, withholding returns (period p) | giving-that-waits-on-giving | `Withholding.withholding_returns` | AT |
| F7 | support beyond a band sustains a cycle | thresholds-beyond-a-band | — | regime |
| F8 | the alternating run never settles | the-boundary-of-enough-under-undetermined-laws | `Enough.Free.stays_meet_not_assured` | AP |
| G1 | a course of one fixed process stops widening | where-the-possible-grows | `Run.not_keepsWidening_of_within` | AP |
| G2 | a finite balanced world keeps widening by no name | what-keeping-widening-needs | `Flow.whole_not_keepsWidening` | W |
| G3 | a bounded family revisits and forgets | returning-novelty-forgetting-on-levels | `World.forgets_of_bounded` | W |
| G4 | an enclosed world's rest cannot be refuted | continued-change-needs-openness | `World.comes_to_rest_unrefuted` | W |
| G5 | merged distinctions stay merged (codes) | a-code-formed-between-formations | `SharedCodes.coined_returns` (and kin) | AT |
| H1 | 全生成, 全守 and their exclusions | generation-and-degeneration-at-two-grains | `«生成退化不并»`, `Map.«生守相杂»` | R |
| H2 | renewal restores in m − level steps | supported-renewal-recovery | `Flow.restores` | W |
| H3 | support passed on | support-passed-on | `Flow.support_passes_on` | W |
| H4 | a whole persists through new parts | whole-persists-through-generation | `Whole.arises_within` | W |
| H5 | a pattern lasts through passing (传) | a-pattern-lasts-through-passing | `Web.ByPassing.passes_within` | W |
| H6 | regulation within the band; the relay's threshold | two-sided-regulation-and-late-reading | `Regulation.relay_threshold` | W / AT |
| H7 | a reserve defers ending, without escape | reserve-defers-ending | `Web.Carries.lasts` | W |
| H8 | the kind relay keeps widening within kinds | what-keeping-widening-needs | `KindRelay.keeps_widening` | witness |
| H9 | renewal without end, the rule raised every other step (the grammar's `«生生»`) | where-the-possible-grows | `RaisedEveryOther.renews_without_end` | witness |
| H10 | restraint within the joint slack keeps the need | what-a-rise-draws-from-beyond | `Flow.Balances.kept_of_restrained` | W |
| H11 | division by exclusive footprints keeps the level | division-by-exclusive-footprints | `Flow.level_kept_of_plans` | W |
| H12 | a sparing formation gives from step 1 | thresholds-of-waiting | `Tolerance.sparing_gives` | AT |
| H13 | a step coupling keeps at every horizon | a-step-coupling-keeps-at-every-horizon | `Optimum.frontier_keeps_stepwise` | any R |
| H14 | the institution's band | a-rule-rebuilt-from-the-members-it-limits | `«稳者恒持当且仅当在带»` | R |
| H15 | the organism's stock buys time | the-stock-buys-time-where-the-rebuild-draws-on-it | `«以储买时当且仅当取于储»` | R |
| H16 | a revision opens a correction | a-revision-that-opens-a-correction | `OpenedCorrection.Linked.opens` | AT |
| H17 | the revision cycle repeats where its yield covers it | recurring-reference-revision | `ContinuingRevision.repeats_iff` | AP |
| H18 | the mutation–selection balance (forward-invariant only) | mutation-and-the-balance-it-sets | `Mutation.not_falls_below` | AT |
| H19 | mutual dependence carries exponentially, both ways | mutual-dependence-and-its-pace | `Flow.mutuallyDependent_iff_reach` | W |
| — | **wide meta-attractor** (the corpus's sense), standing open | (WM, §5) | — | open |

## Appendix B. Kinds of transition

| Kind | Exact condition, where proved | Record | Base |
|---|---|---|---|
| exact threshold | ends exactly where the start is below `H + y` | margin-of-a-regime | regime |
| one law of exact thresholds | a fate down-closed in the level, read off an exact check, has an exact least level; none without (`Notch.no_threshold`) | threshold-in-the-state-plane | any fate, whole numbers |
| superadditive joint thresholds | `a + b ≤ c + 1` | margin-of-a-regime | regime |
| critical mass (bistable) | shapers to others at least as `c − lo` to `hi − c`, where `lo < c < hi` | shaping-read-by-readers-drawn-from-the-selected | C |
| bistable counted choices | `κo·other ≤ κc·carrier` | capture-by-counted-choices | C |
| two right predictions | the start decides | a-prediction-read-by-what-it-predicts | AT |
| window and deadline | `turned_early_iff`; deadline `g.other·c·x.other` | loss-read-in-time-by-the-others | C |
| deadlines elsewhere | a source before `D`; re-read by `T(k − r)`; basin entry before `m`; an unfed consumer within its level | a-source-before-a-juncture, re-optimizing-above-a-renewal-ends-it, basins-of-a-determined-law, feeding-closure | W / AT |
| juncture | every loss of a returning `s` passes one (¬¬) | every-loss-passes-a-juncture | AP |
| pace | `L ≥ 2N − 1` | how-fast-a-rule-may-change | AT |
| exit by drift | weight bound shrinking with distance from the mass; risk dominance `2c < hi + lo`, fixation can part from it | drawn-shaping-drawn-one-at-a-time | C |
| exit from a margin by chance | at most `n·p·q/m²` of the weight | exit-from-a-margin | weights |
| parameter tipping | `c ≤ s`; `c` against `m`; `r < k`; `k ≤ w`; `β ≤ γ`; `K < s + mqρ` | the shaping, coupled-drawers, re-optimizing, mutation, offspring-read-from-giving-that-waits, selection-with-returns-to-groupmates records | C / any G |
| critical slowing down | variance `Var E/(1 − a²)`, lag-1 autocorrelation `a → 1` at a fold or transcritical end; the dependent's need enters neither | slowing-down-before-an-own-end | P, linearized |
| loop onset | not foreseeable in the amounts; a loop forms at the break; a loop ⇔ faster than polynomial (worst case) | how-loops-form, how-a-carried-difference-grows | W |
| four routes (reading, D65) | parameter change removing retention; a shock into another region; a failure stopping correction; change too fast for correction | (05, reading) | reading |
| **absent** | hysteresis; when a regime cycles; tipping by rate; noise-driven exit from regulation; tolerance on webs (percolation-like) | (CY, NC, later) | open; CY landed 10 November and narrows the first two (separated bounds; rest or period two under a reversing step), §5's CY row |

## Appendix C. Errata the readers found (to verify in Phase 0)

Severity is the reader's. ✓ means checked by hand today. Items marked **belief** would change what a reader believes.

| # | Where | Issue | Sev. |
|---|---|---|---|
| E1 ✓ | `ro-relational-sources/passages.json` (10×), `zhonghua/passages.json` (27×) | cite the renamed record `whole-first-and-bounded-centers` | **belief** (a checked claim is false) |
| E2 ✓ | same files (4× and 18×) | cite `Pool.difference_belongs_to_the_joint`, now `Pool.difference_only_together` | **belief** |
| E3 | `verify_ro.py`, `verify_zh.py`; 06 §六; record `civilization-thought-on-the-spine` | chapter paths moved to `history/`; neither verifier is in `research-test`; 06 says in the present tense that every cited declaration and record exists | **belief** |
| E4 | 06 §7.1 and its record | "各自恰好落在一处" is checked per cluster only; 96 judgments sit in places in more than one cluster | med |
| E5 ✓ | THE-THEORY-OF-BECOMING.md l.195 | lists T3's nearness test as still to run; LA4 Stage A ran on 3 November | **belief** |
| E6 | 08 §9 T3 row | drops "on average", "systematic" and "eligible" from the home's Forbids, making the forbidden case stronger | **belief** |
| E7 | 05 `#t3` evidence | lacks the fronts' caveat that the first tests ran before T3's wording | med |
| E8 | GOALS l.114 (generated from the scoped-goal record) | states more of `Direction` than the Lean gives (`¬¬`, and the hypotheses) | **belief** |
| E9 | CD §4 l.76 | narrows 07 §4.6's "what the path does not reach" (four things) to future beings | **belief** |
| E10 | CD l.125 | "the noisy … case" is not shown, though drift one at a time is proved; only the long-run state is cited | med |
| E11 | 04 l.276 | `recurrence-without-selector-revision` is labelled Theorem; the record is reviewed-scoped with no receipt bound | **belief** |
| E12 | 05 l.174 (ZH reading) | "the drain falls only where units are shared": the law proves sufficiency, not "only" | med |
| E13 | 05 l.98 | "lasts only through passing" drops the premise `Web.ByPassing` | low |
| E14 | 02 T7 | "*Evidence*: none frozen", followed by LA2's frozen test | med |
| E15 | 02, 08, ONE-PAGE on LA2 | none says whether T7's third forbidden case, occurring, counts against T7 or falls outside its premise | med |
| E16 ✓ | board, way now item 1 | "if ready before the freeze, OG2": OG2 landed `368a8bde7` | med |
| E17 | board, Now l.28 | the latest core receipt named is stale (now `20261103T211917.845905Z`) | med |
| E18 | board, `## Landing queue` | says PF is at the head (October text); the live Queue line is under Now | med |
| E19 | board | TR45 "done" still open; TR71's title still names TR1; RF lapsed by rule 4; RFZ's state cell stale | low |
| E20 | board, OU row | lists item 9's institution as left; post-gate items wait "on Ren's word to go past the gate", which AGENTS' list of his does not include | med |
| E21 | `experiments/README.md` l.29 | omits TR2's Stage B freeze (FREEZE-7) | low |
| E22 | 08 §7 | shared-law counts stale against COMPLETION at the same receipt (closure 41/42, balance 55/54, 86/87, 40/39), and 08 contradicts itself (55 against 54) | med |
| E23 | 08 §4 | K4 counts stale (74/73, 9/8) | low |
| E24 | 08 §11, §12 | "twenty numbered reviews" (a twenty-first exists); "D1–D66" (D67 and D68 used) | low |
| E25 | 08 §12 item 4 | classed "further proof", but its Open says it has no formal part | med |
| E26 | 08 and chapters | bare `[AI reading]` without a D-number, against 08 §2's rule (08 ×7, 05 ×4, 06 ×3, 07 ×7, ONE-PAGE ×5) | low |
| E27 | COMPLETION.md, COVERAGE.json | section numbers from before the eight chapters ("§8.1", "§2.2") | low |
| E28 | COVERAGE rows | no row maps open item 1 | low |
| E29 | records | all 7 superseded records carry a live-looking `next_delta` | low |
| E30 | `registry.py` `scoped_drift` | an explicit `<a id>` or a `###` anchor cited by a record locates no section, so 39 citations are not drift-protected (RESULT-WORKFLOW l.61 implies they are) | med (tooling; RA) |
| E31 | GLOSSARY l.39 against `meta-attractor/GENERATIVE-REGIMES.md` and the reconciliation | two senses of 元吸引子 (§3.3) | med |
| E32 | 07 §4.2 and §4.6 | P1–P4 names two different arguments | low |
| E33 | 07 | C's home never cites `ReadsNoOrder.not_entails` | low |
| E34 | 07 §6 l.665 | uses `m` without defining it; holds for groups of size `m` only | low |
| E35 | 08 T8 row | omits P3 | low |
| E36 | 02, 03 | records `unceasing-generation-needs-renewal` and `whole-persists-through-generation` concern arising, not §1's generation (rename candidates; 02 §3.2 says so) | low |
| E37 | 03 | `correction-is-not-calibration` led as Assessment though kind theorem; `wisdom-root-without-axiom` led as Reading though kind argument | low |
| E38 | 05 l.392 | anchor `not-shown` sits on §12, and the chapter's "does not show" has no anchor | low |
| E39 | REPOSITORY-LAYOUT | target tree puts the overview under `chapters/`, omits `review/` and the fronts | low |
| E40 | `regions.json` | five newest records unassigned; the file is not validated | low |

## Appendix D. Correspondence coverage today (correspondences reader, §4)

| Domain | Present? |
|---|---|
| Chinese classical | extensive; every reading AI-made; quotations and Lean checked; 未决 lists texts not read |
| Buddhist (as received in China) | present: dossier B, the corpus, 146 of the 219 丙一 sentences; Sanskrit and Pali sources absent |
| Other Indian; Greek and Roman; Abrahamic; Islamic; Indigenous; African | absent on the spine (a few lines in the meta README) |
| Modern Western philosophy | ethics, identity and environmental ethics (dossier P); process philosophy, Hegel, Marx, Simondon absent |
| Systems thinking | thin: Meadows 1972, Ashby, Ostrom, Scheffer; Senge, leverage points, Beer, Holling, Luhmann absent |
| Dynamical systems and physics | present; bifurcations only through Clark and May's fold; no self-organized criticality or percolation |
| Ecology, evolution | present (S-07–S-16) |
| Economics | present by result |
| Political science, sociology | sparse |
| Psychology | sparse (habit; four reanalyses) |
| AI alignment | present (dossier A, 08 §8, LA tests) |
| Logic | present (dossier L, 08 §5) |
| The meta-attractor corpus | the capture laws are on the spine; totalization, plurality, CAOC, the comparisons (Moloch, ideology, paradigm, autopoiesis), the historical layer and the counter-attractor criterion are not |

## Appendix E. The readers' reports

| Report | Slice |
|---|---|
| [dynamics-map-knowing](readers-2026-11-04/dynamics-map-knowing.md) | 02, 03 in full: dynamics, thresholds, theses, gaps |
| [dynamics-life-collectives](readers-2026-11-04/dynamics-life-collectives.md) | 04, 05 in full: dynamics, T3, institution and organism, gaps |
| [significance-alignment-gaps](readers-2026-11-04/significance-alignment-gaps.md) | 07, CD, ONE-ARGUMENT, GOALS, AJ plan: the five gaps, exits, situationality |
| [method-completion-open](readers-2026-11-04/method-completion-open.md) | 08, COMPLETION, COVERAGE: vocabularies, premise card, K1–K7, K8/K9, next_delta counts |
| [correspondences](readers-2026-11-04/correspondences.md) | 06, dossiers, RO/ZH/Y data: inventory, checks, coverage |
| [data-tooling-process](readers-2026-11-04/data-tooling-process.md) | tools/research, RESULT-WORKFLOW, REPOSITORY-LAYOUT: how to wire a data layer |
| [tests-board-lean](readers-2026-11-04/tests-board-lean.md) | experiments, board claims, Lean modules and checks |
