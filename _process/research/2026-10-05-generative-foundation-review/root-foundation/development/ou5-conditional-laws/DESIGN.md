# OU5, part A: the corpus's conditional laws in the grammar (design)

Board item OU5 (OU plan §八 step 5, §十三 item 4; the release gate's item 4 in [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md)). This is the design for OU's owner. Nothing here is in the package. The laws marked new are proved in scratch Lean outside it ([tree](tree/Becoming/GrammarConditionals.lean), [build](tree/BUILD.json)). Part B, 验's model examples, belongs to another session and is not touched here.

Every reading of which unit states which law is an AI reconstruction, as the classification itself is. The classical text decides nothing. Lean checks only the derivation, and the counts below count readings, not facts about the historical texts.

## In five minutes

The 219 units classed 丙一 ([classification](../one-unfolding-root/classify/)) fall into **24 groups**, one law each, and **65 units outside the groups**:

| | units | of which in the first batch |
|---|---|---|
| in a group, stating its law (5 of them a law false as read: G24's four and LZ-07-002) | 124 | 87 |
| in a group, stating the premise its law takes | 30 | 26 |
| back to 丁 (Z or Y is an evaluation) | 32 | 24 |
| not expressible in the grammar | 28 | 25 |
| a definition (甲), not a law | 5 | 0 |
| **total** | **219** | **162** |

The 24 laws stand as follows.

- **14 are theorems already**, from the grammar's modules or OU6's candidates: G04, G07, G10–G14, G16–G19 and G21–G23.
- **6 need new Lean**, all proved in scratch: G01, G02, G03, G06, G09 and G15.
- **2 are premises of the model**, not laws: G08 (what occurs has conditions) and G20 (Xunzi's 同類同情 is constancy). Each has the grammar's exact statement and the net where it fails.
- **1 is false as read**: G24.
- **G05** is a theorem in its sufficient form, with a new iff beside it.

The scratch module has 38 declarations: the new laws, their countermodels, and named checks of the compositions this design cites. Every one has an empty axiom report.

What the work finds, beyond the count:

- **穷 → 变 → 通 → 久 holds exactly where the design's premises say** (G01). What ends under a class alters exactly where it has a successor; 穷而息 is the countermodel. What it alters into passes through when the class it continues under is constant both ways; counting up from zero is the countermodel. This closes 06 未决's "穷 → 变 → 通".
- **相推而生 is 全生成** (G02). Where every step passes from one phase to the other and nothing stops, the coarse pattern (the day, the year) goes on through carrying renewal at every point.
- **物壯則老 and 復歸其根 are the two sides of bounded room** (G03, G04). In finite room, a line that never returns cannot go on for ever. A line that always has a successor and merges with nothing returns.
- **無緣不起 is a premise, not a law** (G08). It holds of a net exactly where every occurrence is conditioned, which the grammar does not assume (OU6's `«从缘生非文法之律»`).
- **The 起信论's 無後際 and 無前際 are not symmetric** (G15). An endless line stays endless for its whole core class. A beginning is kept only along the two-way core, and dependence on what has no beginning does not make the dependent beginningless. So 「以如來藏無前際故，無明之相亦無有始」 needs a premise its pair about 後際 does not.

For a reader, each law gets its hypotheses in the grammar's words and a net where they fail. That is what the gate's item 4 asks.

## How the groups were made

**Input.** These are the 219 rows classed 丙一, with their form (the classifier's Z and Y), commentary and confidence ([units.tsv](data/units.tsv)). 162 come from the first batch. 25 come from 中论 chapters 10, 17, 19 and 24, and 32 from 成唯识论.

**Grouping.** A group is one law in the grammar: one Z and one Y over every carrier, relation and class. A unit joins the group whose law it states, or whose law is the closest reading of it under its commentary. Each unit keeps its id and confidence ([groups.tsv](data/groups.tsv), written by [assign.py](kit/assign.py)).

**Dispositions.** Each unit gets one:

- *law*: the unit states the group's law, or a case of it.
- *premise*: the unit states the Z the law takes, or a premise of its model. An example is 「以依動故能見」, which states a dependence; 「不動則無見」 then states the law.
- *丁*: the Z or Y asserts or presupposes a valuation. This covers 吉凶, 利害, 善惡 as moral kinds, 福 and 罪, 苦 and 樂 as valenced, 勝 between parties, 養, 可 as approval, 好醜貴賤, and attitudes of aversion and aspiration (厭, 樂求). Attainments read as states, such as 斷煩惱 or the ending of a line, stay with their law. 染/淨 are read as a mark and its complement, as OU6 read them. They go back to 丁, recorded and never forced in.
- *not expressible*: the Z or Y names qualities of bodies, amounts, agents' offices, affects or practices that the grammar has no terms for. The reason is given per unit.
- *甲*: the unit states a definition.

**The grammar's terms.** The terms come from `Becoming.Grammar`, `GrammarReadings`, `GrammarMap`, `GrammarLaws`, `GrammarTesting` and OU6's `GrammarCandidates`, each in the one sense the [glossary](../../../../../../GLOSSARY.md) gives:

- 缘 (a relation `R`), class (类), continuation (`«续»`), line (`«相续»`)
- the four marks (`«生» «住» «异» «亡»`)
- constancy (`«有常»`), the core (`«核»`), the two-way core (`«位核»`)
- reach (`«及»`), never ending (`«不穷»`), passing through (`«通»`)
- generation (`«全生成»`, `«传»`)
- marks as predicates (`«有相»`)

A *further premise* is one the grammar needs beyond the Z the text states. Each is named with its law.

**Form.** Each law is "Y 当且仅当 Z" where an iff holds, otherwise "Z 则 Y". The countermodel where Z fails is a net, a relation and a class, in which Z fails and Y fails with it.

## The 24 groups

Units are listed as count (高/中/低). Laws are named by their declarations. Names marked † are new and provisional until OU's owner decides them. Each countermodel is a witness (`…之例`) or a named check (`check_…`) in the [scratch module](tree/Becoming/GrammarConditionals.lean).

| | law | form | standing | where Z fails | units |
|---|---|---|---|---|---|
| G01 穷变通久 | what ends under `E` and continues under `F` alters (`«穷则变»`†); it alters exactly where it has a successor (`«穷则变当且仅当有后»`†); with `F` constant both ways it then passes through and never ends (`«穷变通久»`†) | iff; 则 | new; further premise: two-way constancy of `F` | `«穷而息之例»`†, `«变而不通之例»`† | 2 (1/0/1) |
| G02 相推而生 | everything continued under `L`, every step leaving `E`: `«全生成» R L E x` for every `x` (`«相推则全生成»`†) | 则 | new; further premise: nothing stops | `check_short_not_generating` (ends), `check_still_not_generating` (keeps) | 6 (2/2/2) |
| G03 物壮则老 | no cycle, the reach held by a list: the line is shorter than the list (`«无环之线短于所列»`†), so not endless (`«无环有限则非不穷»`†) | 则 | new; further premise: bounded room | `«无环而不穷之例»`† (unbounded), `«返而不穷之例»`† (returns) | 3 (0/2/1) |
| G04 复归其根 | finitely many, each with a successor, merging nothing: everything returns (`«有限遍后定前则皆返»`) | 则 | theorem; further premise: all three | `«并而不返之例»`†, `«无尽而不返之例»`† | 1 (0/0/1) |
| G05 乾坤毁则无以见易 | under the one nothing alters (`«平等无异»`); nothing alters from `E` under `F` exactly where `F` parts no continuation's ends (`«无异当且仅当类不分续»`†) | 则; iff | theorem; new iff | `«分则见易之例»`† | 1 (1/0/0) |
| G06 感而遂通 | class constant both ways, a predecessor under it: passes through (`«感而遂通»`†) | 则 | new; further premise: two-way constancy | `«寂而不感之例»`†, `«有常而不通»` | 1 (0/0/1) |
| G07 动静有常 | a class is constant exactly where it lies within its core (`«类有常当且仅当含于核»`) | iff | theorem | `«非有常之类不含于核之例»`† | 1 (0/1/0) |
| G08 缘起之设 | nothing begins under the one exactly where everything is not-not conditioned (`«无缘不起当且仅当皆有缘»`†) | iff | premise of the model | `«从缘生非文法之律»` | 13 (4/7/2) |
| G09 依则离无 | where `Q` depends on `P` (`«依»`†), no `P` gives no `Q` (`«依则离无»`†); dependences compose (`«依之传»`†) | 则 | new | `«不依之例»`† | 35 (7/26/2) |
| G10 相由俱有 | mutual conditions are co-present, one cluster (`«相由则俱有»`, `«俱有为一念»`); condition before result exactly without cycles (`«缘先果后当且仅当无环»`) | 则; iff | theorem | `«无环则无俱有»`† | 6 (1/4/1) |
| G11 相须 | the joint class constant: the joint line never ends (`«有常则往不穷»` at `«合»`); neither alone (`«相须»`) | 则 | theorem; witnesses `«相须之例»`†, `«火薪相须»` | `check_short_not_constant` with the short line ending | 5 (0/5/0) |
| G12 细亡粗续 | fine within coarse: ending under the coarse gives ending under the fine (`«亡于粗则亡于细»`), not conversely (`«亡于细者不必亡于粗»`); abiding goes up (`«住于细则住于粗»`) | 则 | theorem | the same witness with the classes not nested | 3 (2/1/0) |
| G13 不断不常 | a condition, a result, not its own condition: abides under the one, begins and ends under identity (`«四相俱时»`, `«四相无自立»`); no continuation under identity (`«非一非异»`) | 则 | theorem; further premise: not its own condition | own condition (`«自缘则常»`: 常); no result (`check_end_without_rise`: 斷) | 12 (3/7/2) |
| G14 恒相续 | the class constant, a predecessor: the line never ends (`«有常则往不穷»`); a fine beginning on it alters (`«生于细而续于粗则异»`) | 则 | theorem | `check_short_not_constant`, `Map.Short.degeneration` | 15 (8/6/1) |
| G15 前际后际 | an endless line stays endless along the core (`«不穷于核下不变»`†); a beginning is kept along the two-way core (`«生于位核下不变»`) and not the one-way core or dependence; going back ending on every branch is not beginningless (`«尽则非不穷»` on `«逆» R`) | 则 | new; further premise for 前際: the two-way core | `«生于核下可变之例»`†, `«依于无始而有始之例»`†, `«无始而有终之例»`† | 6 (1/4/1) |
| G16 定性与常 | own condition: abides under every class (`«自缘则常»`); has a beginning or end under some class exactly when not its own condition (`«有成坏当且仅当不自缘»`); no own position exactly when not-not conditioned and not own condition (`«定性之判»`); no condition: begins under every class (`check_unconditioned_begins_everywhere`) | iff; 则 | theorem; further premise: not its own condition | LZ-07-002 false: `check_short_end_not_own_condition` | 14 (1/9/4) |
| G17 显隐随类 | under a class holding of every pair, nothing alters (`«平等无异»`); a predicate holding everywhere has no mark (`«遍而无相»`) | 则 | theorem | `«分则见易之例»`† | 12 (0/6/6) |
| G18 标与其补 | a mark gives its complement a mark (`«有相则非亦有相»`); to know a mark is to have its non (`«知相则有其非»`); nothing outside, no mark (`«离非无相»`) | 则 | theorem | a predicate holding everywhere (`«遍而无相»`) | 4 (0/1/3) |
| G19 三时相待 | something precedes exactly where something follows (`«能所相待»` on reach) | iff | theorem; pointwise false | `«有生不必有亡»` (zero: a later, no earlier) | 3 (3/0/0) |
| G20 同类同情 | those alike under `E` perceive alike: exactly `E` constant under perceiving (`«有常之逐点»`) | iff | premise of the model | `«非有常之类不含于核之例»`† | 2 (0/1/1) |
| G21 征知 | separated at some stage: not in the core (`«可分则不在核»`); conversely only where not separating is constant (`«不可致诘而有常则混而为一»`) | 则 | theorem | `«致诘不尽»` | 2 (0/2/0) |
| G22 衡 | a map keeps `R` within `R'` exactly where each `R`-pair maps to an `R'`-pair (`«保之像»`) | iff | theorem | `check_reversing_balance` | 2 (0/2/0) |
| G23 无厚入有间 | a point within what has two parts does not fill it (`«尺与端或尽或不尽»`) | 则 | theorem | `«尺与尺可相尽»` | 1 (0/1/0) |
| G24 将欲必固 | "every end is preceded by a rise" | — | false | `check_end_without_rise` | 4 (0/0/4) |

## Group by group

Each entry gives the units, the law, the reading and what the reading loses. The units' own readings are in [groups.tsv](data/groups.tsv).

**G01 穷变通久** (XCX-02-008 高, XCS-04-004 低).

- **Law.** For classes `E` and `F`, if `x` ends under `E` and `y` continues `x` under `F`, then `x` alters into `y` (`«异» R F E x y`). For what ends under `E`, altering under `F` is exactly having a successor under `F` (Y iff Z). If `F` is constant under 缘 and under its converse, what `x` alters into passes through under `F`, and its line under `F` never ends.
- **Reading.** 窮 is ending under a class, 變 is alteration and 通 is 06 §三's `«通»` (往来不穷). 久 is the line never ending; the 墨经's 久 is 彌異時, which this does not take up. 韩注's 聚極則散 (XCS-04-004) is the same law.
- **Countermodels.** 穷而息: one occurrence with nothing after it ends and does not alter, as the plan's §三 names. 变而不通: counting up from zero. Zero ends under identity and alters into one under the one, which is constant one way only, and one does not pass through.
- **Lost.** 06 §5.7's hexagram-world reading (老则变 within the 之卦 law) stays a model law; this is its form on the root. 「困，窮而通」 remains no counterexample (06 §二).

**G02 相推而生** (XCX-04-004 高, XCX-04-005 高, XCS-02-002 中, XCX-01-003 中, XCS-06-004 低, XCS-06-005 低).

- **Law.** Suppose everything is continued under a coarse class `L`, and every step of 缘 leaves the fine class `E`. Then for every `x`, the coarse line never ends and a carrying renewal lies ahead of each of its points: `«全生成» R L E x`. Day and night are its instance (`«昼夜全生成»`).
- **Reading.** 相推 is each step passing from one phase to the other (日往則月來，月往則日來). 明生 and 歲成 are the coarse pattern going on through renewal: generation in 02's sense, a pattern going on through carrying renewal, never arising or any new organization. 變化 is the alteration at each step. 乾坤's 靜/動 in turn (XCS-06-004/005) is read as 相推; 專直翕闢 are not read.
- **Countermodels.** The short line stops: it reaches an end, so it is not 全生成. The still occurrence's step keeps every class: it keeps (全守) and does not generate.

**G03 物壮则老** (LZ-30-008 中, LZ-55-009 中, LZ-23-002 低).

- **Law.** Where nothing reaches itself, a line of continuation whose places a list holds has fewer steps than the list is long. So where a list holds everything the line from `x` reaches, that line is not endless.
- **Reading.** 壯 is a rise that does not return. 不道 is not returning, read with 「反者道之動」 (40章). 早已 is ending within the room it has. 王弼 on 23 (暴疾美興不長) puts 飄風驟雨 here.
- **Countermodels.** Counting up has no bound and never ends. Day and night have bounded room and return, and never end.
- **Lost.** "早" is the bound only: the list's length, not a time.

**G04 复归其根** (LZ-16-003 低).

- **Law.** The grammar's law of finite return: where a list holds every occurrence, everything has a successor and nothing merges, every occurrence reaches itself. G03 and G04 are the two sides of one pigeonhole. In bounded room, a line that never returns cannot go on for ever; one that always has a successor and merges with nothing returns.
- **Reading.** 復歸其根 is the line returning to its start, 06's 復 (`«复»`).
- **Countermodels.** In a merge (both of two occurrences go to the second), the first never returns. Counting up merges nothing and never returns.
- **Lost.** 芸芸 read as every occurrence. 歸根曰靜 and 復命曰常 are 甲 units elsewhere.

**G05 乾坤毁则无以见易** (XCS-12-012 高).

- **Law.** Under the one nothing alters. More exactly, nothing alters from `E` under `F` exactly where `F` tells apart the two ends of no continuation (up to double negation). The second clause, 「易不可見，則乾坤或幾乎息矣」, is that iff read backwards: with no alteration the distinction parts nothing in the net.
- **Reading.** 乾坤 are the two classes of one distinction; 韩注 has 易之所以為易，乾坤之變也.
- **Countermodel.** Day and night under the one, told apart by identity: the step alters.

**G06 感而遂通** (XCS-10-006 低).

- **Law.** Where a class is constant under 缘 and its converse, an occurrence with a predecessor under it passes through. Constancy gives the successor, so `«两向有常则通»` needs only a predecessor, not abiding. This is G01's middle step.
- **Reading.** 感 is a condition reaching it under the class; 寂然不動 is having no step of its own.
- **Countermodels.** A lone occurrence (寂而不感) does not pass through; counting up from zero is constant one way only (`«有常而不通»`).

**G07 动静有常** (XCS-01-003 中).

- **Law.** For a class, being constant under 缘 is exactly lying within its core: what it puts together, 缘 never tells apart.
- **Reading.** 韩注 reads 「動止得其常體，則剛柔之分著矣」. With motion and rest a constant class, the distinction is the dynamics' own: 剛柔斷.
- **Countermodel.** One occurrence is its own successor and another has none. The one is not constant, and its core does not put them together.

**G08 缘起之设** (13 units; JSZ-C-015 高, JSZ-C-016 高, JSZ-P-01-003 高, QXL-JS-212 高, …).

- **Law.** That nothing begins under the one is exactly that every occurrence is not-not conditioned. So 「無緣即不起」 states a premise of the model, as OU6 found for 「一切物皆從眾緣生」. Production (緣具則生: JSZ-P-01-003, ZL-07-133, XCX-04-051) and the two kinds of condition (因 and 緣 both needed: QXL-JS-212, QXL-JS-214) are premises too. The design records each with the grammar's statement.
- **Countermodel.** An occurrence with no condition begins under the one.
- **Lost.** "An unarisen 法 meeting its conditions" (ZL-07-127) has no reading: an occurrence that has not arisen is no place of the net, except on the net of the possible (plan §4.1).

**G09 依则离无** (35 units: 20 state the law, 15 the premise; QXL-JS-119 高, QXL-JS-123 高, QXL-JS-159 高, QXL-JS-197 高, ZL-24-041 高, ZL-17-040 高, ZL-17-042 高, …).

- **Law.** `Q` depends on `P` along `R` (`«依»`: everything with `Q` has a condition with `P`). Then if nothing is `P`, nothing is `Q`, and dependences compose. The 起信论's 離X則無Y units state the law. Its 依X故有Y units state the dependence, the Z. Its chains (無明 → 心起 → 境界, QXL-JS-197) and 中论 24's 俗諦 → 第一義 → 涅槃 are compositions.
- **Reading.** Read statically. For the temporal 「心滅則種種法滅」 (QXL-JS-123), the law on a region needs the `P`-conditions inside that region, a co-present dependence. A result whose condition lies earlier need not end when the condition ends. That further premise is named here.
- **Countermodel.** A `Q` with no `P`-condition stands where nothing is `P`.
- **Lost.** The kinds themselves (心, 境界, 種子) are the model's: that this text's 境界 depends on its 心 is its premise, which the grammar neither proves nor refutes. 「心生則種種法生」 is a production premise.

**G10 相由俱有** (QXL-JS-178, QXL-JS-179, QXL-JS-195, CWS-P3-074 高, CWS-P3-077, ZL-01-065).

- **Law.** Mutual conditions are co-present, and co-presence is one cluster. Every condition strictly precedes its result exactly where there is no cycle.
- **Reading.** The 熏習 loops (真如 → 無明 → 妄心 → 無明), 能熏所熏 「俱生俱滅」 and the 中论's reductio 「穀作芽、芽作穀者應是一」.
- **Countermodel.** In a net without cycles nothing is co-present (`«无环则无俱有»`).

**G11 相须** (CWS-P6+P7+P8-019, -020, -043, -049; ZL-10-043; all 中).

- **Law.** Where the joint class of the holding classes is constant, the joint line from what it has continued never ends. 「不相離」 is `«相须»`: the joint class is constant and neither alone is. `«相须之例»` witnesses it for lines that do not end; `«火薪相须»` does so through the core for the flame that ends.
- **Reading.** 「三法無間轉者可恒相持，不爾便無」: 壽、煖 and 識 turning without gap is the joint class being constant. 冷觸 at death is the mate that ends when the holding withdraws.
- **Countermodel.** On the short line the one is not constant and the line ends.

**G12 细亡粗续** (QXL-JS-058 高, QXL-JS-167 高, ZL-02-091 中).

- **Law.** For a fine class inside a coarse one:
  - ending under the coarse gives ending under the fine;
  - abiding under the fine gives abiding under the coarse;
  - the fine can end while the coarse goes on.
- **Reading.** 「若無明滅相續則滅，智性不壞故」: the defiled line, under the fine class, ends with its condition, while 智性 goes on under the coarse. 「去法滅故有住」: going ends under the class of going, and the goer abides under its coarser class.
- **Countermodel.** Where the classes are not nested, the first clause fails: the same two-occurrence witness with identity and the one in the other order.

**G13 不断不常** (12 units; ZL-21-120 高, CWS-P1-031 高, CWS-P9-016 高, …).

- **Law.** With a condition and a result, and not its own condition, an occurrence abides under the one (不斷) and begins and ends under identity (不常). Without self-conditioning there is no continuation under identity at all.
- **The two 邊.** ZL-21-113's two 邊 are exactly the two ways the premise fails. An occurrence that is its own condition abides under every class, identity included (常). One with no result ends under the one (斷).
- **Reading.** 似我相現 and 似常一 (CWS-P1-031, P9-016, P1-007): abiding under a coarse class (一類相續) taken for identity. 來 and 出 (ZL-01-079, -086): continuation read as identity, which needs self-conditioning. The premise 不自缘 is OU6's finding.
- **Countermodels.** As the two 邊: `«自缘则常»`, and a lone occurrence.

**G14 恒相续** (15 units; CWS-P4-019 高, CWS-P5-017 高, CWS-P5-021 高, CWS-P5-022 高, …).

- **Law.** Under a class constant under 缘, a line with a past never ends. A beginning under a finer class on it is an alteration, not a break.
- **Reading.** 瀑流: the stream's class is constant, and the waves (轉識, raised by 風緣) begin under the fine class on a line that does not break.
- **Countermodel.** On the short line the one is not constant and the line ends.
- **Lost.** The converse fails. Constancy is a global property and is sufficient, not necessary. "Z 则 Y", not iff.

**G15 前际后际** (QXL-JS-326, QXL-JS-324, QXL-JS-238, CWS-P4-062 高, ZL-02-070, LZ-63-004).

- **Ends (後際).** For a class, what the core puts with an occurrence whose line never ends has a line that never ends (`«不穷于核下不变»`). So 「如來藏無有後際，諸佛所得涅槃與之相應則無後際」 holds with 相應 read as lying in one class of the core.
- **Beginnings (前際).** A beginning is kept along the two-way core, and not along the one-way core (`«生于核下可变之例»`). Dependence does not keep it either: what depends on a line without beginning can begin (`«依于无始而有始之例»`). So 「以如來藏無前際故，無明之相亦無有始」 needs the two-way core between them, a premise its pair about 後際 does not need.
- **Beginningless and ending.** Counting down to zero is the witness (QXL-JS-238 「無始…得佛後則有斷」; CWS-P4-062 「阿羅漢位方究竟捨」).
- **A first beginning.** Where going back ends on every branch, the line is not beginningless (ZL-02-070 「應有初發」; LZ-63-004 「必作於細」). Counting down is again the countermodel.

**G16 定性与常** (14 units; ZL-24-185 高, …).

- **Law.** OU6's family of no own position:
  - What is its own condition abides under every class (ZL-07-235 自相住則為是常).
  - Something has a beginning, or an end, under some class exactly when it is not its own condition (ZL-21-022, -058, -069).
  - It has no own position exactly when it is not-not conditioned and not its own condition (ZL-24-185, JSZ-C-067, JSZ-C-064).
  - What has no condition begins under every class.
- **The two horns.** 中论's two horns (ZL-01-099, ZL-17-051) are the last two: no condition gives 斷 (beginning everywhere, no line from before); own condition gives 常. The premise 不自缘 is OU6's.
- **LZ-07-002 is false under the reading 不自生 = not its own condition.** The short line's end is not its own condition and ends. The grammar's law runs the other way (`«自缘则常»`). 王弼's reading, 自生 as 與物爭, is a social stance, not expressible.

**G17 显隐随类** (12 units: 金師子章's 隱顯 and 純雜, the 起信论's 差別 and 分齊, 樸散則為器).

- **Law.** Under a class holding of every pair nothing alters. A predicate holding everywhere has no mark.
- **Reading.** 看 is the class taken. Under the class of shapes the lion is told apart (顯), and gold, holding of every part, has no mark (隱). Under gold's class nothing in the lion is told apart. 「離妄念則無一切境界之相」 is the same: with no class but the one, nothing is told apart.
- **Lost.** "Shows" is read as being told apart. 由心迴轉 (JSZ-P-07-032) is read as changing the class taken; the mind that turns is not read.

**G18 标与其补** (QXL-JS-256, QXL-JS-260, QXL-JS-028 中, LZ-01-001).

- **Law.** OU6's mark and its complement.
- **Reading.** 「若心起見，則有不見之相」: a mark gives its complement a mark. 「若離妄心實無可空」: where nothing falls outside, no mark. 「道可道，非常道」: what has a mark does not hold everywhere.

**G19 三时相待** (ZL-19-002, -003, -004, all 高; the opponent's view in 中论 19).

- **Law.** Past and future as the two ends of one reach: something precedes exactly where something follows.
- **Pointwise false.** Zero in counting up has a later and no earlier.
- **Reading.** The grammar keeps the three times as positions relative to a present, not as three things.

**G20 同类同情** (XZ-ZM-034 中, XZ-ZM-016 低).

- **Law.** 「凡同類同情者，其天官之意物也同」 says that the class 同類同情 is constant under perceiving. That is exactly `«有常»`, pointwise. It is a premise of 荀子's model, the ground of 約定俗成, and the grammar's word for it is 有常.
- **Countermodel.** A class that is not constant.

**G21 征知** (XZ-ZM-043, -044).

- **Law.** 「征知必將待天官之當簿其類」: what a coupling separates at some stage is not in its core. The unconditional converse fails; it holds where not being separated at any stage is itself constant.
- **Note.** This uses GrammarTesting's laws, not Part B's models.

**G22 衡** (XZ-ZM-164, -165).

- **Law.** A balance keeps "heavier than" within "hangs lower than" exactly where every heavier pair maps to a lower-hanging pair.
- **Countermodel.** A reversing balance, 「衡不正，則重縣於仰，而人以為輕」.

**G23 无厚入有间** (ZZ-YSZ-016 中).

- **Law.** The 墨经's 尺與端: a point within what has two distinct parts does not fill it.
- **Reading.** 「以无厚入有間，恢恢乎其於遊刃必有餘地矣」.
- **Countermodel.** Two extended things can fill each other.

**G24 将欲必固** (LZ-36-001…004, all 低).

- **False.** Read as G03's converse, every end preceded by a rise, it is false: an occurrence can end with nothing before it.
- **Not expressible as strategy.** 將欲 is an agent's plan, about how to bring about the end of something one opposes (王弼: 令其自戮).

## Outside the groups

The per-unit reasons are in [groups.tsv](data/groups.tsv).

**Back to 丁 (32).**

- 老子 18's virtues and counterfeits (4). The claim values a social order's decline. The marking reading (a virtue is named only where its absence occurs, `«知相则有其非»`) fits three of them but loses that claim.
- 利, 用, 得, 惑 and 王弼's humility pairs (老子 11, 22), and the ranking 道 德 仁 義 禮 (38).
- 荀子's 可 as approval, and his 重物, 危, 憂恐 and 養.
- The 起信论's 苦 as Y, its attitudes of aversion and aspiration (厭生死苦, 樂求涅槃, 信, 善根), and its valued qualities (常樂我淨, 淨功德).
- 中论 17's merit, demerit and gravity (opponent's view).
- 成唯识论's 異熟 from valenced deeds only (CWS-P2-007): there the valuation is what the law turns on. Its 等流 from all three kinds (CWS-P2-006) is 甲.

**Not expressible (28).**

- Qualities and rates of bodies: 虛, 濁清, 徐, 柔脆, 枯槁, 堅強.
- 勝 between qualities or parties (6). Read as a contest, its Y would rank outcomes.
- Social mechanisms between ruler and people (老子 75), armies and land, rain and people.
- Amounts: 有餘 and 不足 (老子 77) are laws of the World model with natural-number amounts, not of the grammar. Also 段食 and 增長.
- A ruler's naming practice, and an agent's desire and belief moving to seeking.
- Affect and perception, a knower's attainment, the effect of long practice, a dialectical consequence inside the opponent's system, and a comparison of degree (偏勝).

**Definitions (5).**

- 等流 and 自類相生 are continuation under the class of one's kind (01 §2).
- 因緣 and 增上緣 are two kinds of condition. In the grammar they are two relations, given apart.
- 攝藏 is holding the seeds.

## New Lean, in scratch

The module is `Becoming.GrammarConditionals`, importing `Becoming.GrammarCandidates` and `Becoming.GrammarLaws`. It needs GrammarMap's `«全生成»` and GrammarLaws' pigeonhole and finite lines.

Build: `python3 -B scratch_build.py TREE Becoming.GrammarConditionals` from the package folder. The result is 38 declarations (37 theorems and the definition `«依»`), every axiom report empty, no warning ([BUILD.json](tree/BUILD.json)).

| declaration | statement | group |
|---|---|---|
| `«穷则变»` | `«亡» R E x`, `«续» R F x y` give `«异» R F E x y` | G01 |
| `«穷则变当且仅当有后»` | for `«亡» R E x`: `(∃ y, «异» R F E x y) ↔ «有后» R F x` | G01 |
| `«感而遂通»` | `«类» E`, `«有常» R E`, `«有常» («逆» R) E`, `«有前» R E x` give `«通» R E x` | G06, G01 |
| `«穷变通久»` | `F` a class constant both ways, `«亡» R E x`, `«续» R F x y` give `«异» R F E x y ∧ «通» R F y ∧ «不穷» R F y` | G01 |
| `«相推则全生成»` | `∀ y, «有后» R L y` and `∀ a b, R a b → ¬ E a b` give `«全生成» R L E x` | G02 |
| `«昼夜全生成»` | day and night are 全生成 under the one and identity | G02 |
| `«无环之线短于所列»` | `«无环» R`, a line of `n` continuation steps with places in `l`, give `n < l.length` | G03 |
| `«无环有限则非不穷»` | `«无环» R` and `l` holding the reach from `x` give `¬ «不穷» R E x` | G03 |
| `«无异当且仅当类不分续»` | `(∀ x y, ¬ «异» R E F x y) ↔ ∀ x y, «续» R E x y → ¬¬ F x y` | G05 |
| `«无缘不起当且仅当皆有缘»` | `(∀ y, ¬ «生» R «一» y) ↔ ∀ y, ¬¬ ∃ x, R x y` | G08 |
| `«依»` (def), `«依则离无»`, `«依之传»` | `∀ y, Q y → ∃ x, R x y ∧ P x`; with `¬ ∃ x, P x` it gives `¬ ∃ y, Q y`; it composes along `«而»` | G09 |
| `«核下线相随»`, `«不穷于核下不变»` | lines follow each other along a symmetric constant relation within a class; for `«类» E`, `«核» R E y y'` and `«不穷» R E y` give `«不穷» R E y'` | G15 |
| `«无环则无俱有»` | `«无环» R` gives `¬ «俱有» R x y` | G10 |
| witnesses (13) | `«穷而息之例»`, `«变而不通之例»`, `«寂而不感之例»`, `«无环而不穷之例»`, `«返而不穷之例»`, `«并而不返之例»`, `«无尽而不返之例»`, `«分则见易之例»`, `«非有常之类不含于核之例»`, `«不依之例»`, `«生于核下可变之例»`, `«无始而有终之例»`, `«依于无始而有始之例»`, and `«相须之例»` | as above |
| checks (7) | compositions of existing laws the design cites, named so the audit reads them: `check_unconditioned_begins_everywhere`, `check_short_not_generating`, `check_short_not_constant`, `check_still_not_generating`, `check_short_end_not_own_condition`, `check_end_without_rise`, `check_reversing_balance` | G16, G02, G14, G24, G22 |

The helper `counting_reach_lt` is English, as the package's helpers are.

Names marked † in the table of groups were sent to OU's owner before the build. The three corpus-phrase names (`«穷则变»`, `«感而遂通»`, `«穷变通久»`) follow OU6's `«薪尽火传»`, with structural alternatives offered.

## A landing sketch, for OU's owner to decide

- **One core module** joined below GrammarLaws: `Becoming.GrammarConditionals`, holding the laws and witnesses OU's owner takes. The checks stay in scratch unless wanted.
- **One record** for the conditional laws of the corpus, beside `candidate-theorems-of-the-corpus`. Its claim:
  - the counts above;
  - the 24 laws with their premises;
  - the 65 units outside, with their reasons.

  Every count is a count of readings.
- **06 §四 as its home section.** The sentence 「八部文本之 162 条丙一之律尚未逐条写成"Y 当且仅当 Z"」 becomes the result: the laws, grouped by family as §四 already does for OU6's candidates. 06 未决's "穷 → 变 → 通" is closed by G01.
- **The gate's item 4** is then met for the 219 units, by law, premise, 丁, not expressible or 甲, each with its reason.

## What this design does not do

- No package file changes; Part B is untouched.
- The design does not say what any text means. A reading stands or is revised by its place in one account, and each reading here keeps its AI label. The classifier's confidence is kept. A 低 unit in a group is the group's weakest evidence that the law is the text's.
- The 181 乙 candidates of the three added texts (06 §四) are outside OU5.

## Files

- [data/units.tsv](data/units.tsv): the 219 丙一 rows, with their classification fields.
- [data/groups.tsv](data/groups.tsv): each unit's group, disposition and reading.
- [kit/assign.py](kit/assign.py): writes groups.tsv from units.tsv and checks that every unit is placed once.
- [tree/Becoming/GrammarConditionals.lean](tree/Becoming/GrammarConditionals.lean) and [tree/BUILD.json](tree/BUILD.json): the scratch module and its build.

## Review

One independent review of this design is recorded below, with how each finding was taken.
