# OU7, part A: the corpus's conditional laws in the grammar (design)

Board item OU7: OU plan §八 step 5 and §十三 item 4; the release gate's item 4 in [WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md). It was claimed as OU5 (40b3a1692), an id that already named an item landed on 23 October (706b80293, "OU4, OU5 and OU2c landed", which brought GrammarTesting). On 31 October OU's owner gave it the id OU7, and the workspace moved here from `development/ou5-conditional-laws/`.

This is a design for OU's owner. Nothing here is in the package. The laws and witnesses it proposes for the core are proved in Lean outside the package, in the landing kit ([the leaf](kit/Becoming/GrammarConditionals.lean); [the kit](kit/README.md)). They stand on two patches that put the general laws below, in Grammar and GrammarReadings ([patches](kit/patches/README.md)). The checks it cites stay in a second scratch module ([checks](tree/Becoming/GrammarConditionalsChecks.lean)). The build of the patched modules and both scratch modules is recorded in [BUILD.json](tree/BUILD.json). Part B, 验's model examples, belongs to another session and is not touched here.

Every reading of which unit states which law is an AI reconstruction, as the classification itself is. Each reading in [groups.tsv](data/groups.tsv) carries its own label. The classical text decides nothing, and Lean checks only the derivation. Every count below counts readings, not facts about the historical texts. One independent review of an earlier draft found 24 problems, and all of them have been taken ([Review](#review)). OU's owner's decisions on the reviewed design, and what changed for them, are in [Decisions](#decisions-31-october).

## In ten minutes

The 219 units classed 丙一 ([classification](../one-unfolding-root/classify/)) fall into **22 families of laws**, which hold 128 units. Another **91 units fall outside every family**.

| disposition | units | first batch |
|---|---|---|
| states a law that holds | 103 | 70 |
| states a law that is false as read, with a countermodel | 6 | 4 |
| states the premise a law takes, or a premise of the model | 19 | 16 |
| back to 丁 (the law turns on a valuation) | 33 | 25 |
| not expressible in the grammar, with the reason | 53 | 47 |
| a definition (甲), not a law | 5 | 0 |
| **total** | **219** | **162** |

The 22 families stand as follows:

- **12 are theorems already**, from the grammar's modules or the corpus's candidate theorems (`GrammarCandidates`): G04, G07, G10, G11, G13, G14, G16, G17, G18, G19, G22 and G23.
- **3 need a new derivation**, proved in scratch: G02, G03 and G15.
- **4 add only definitional unfoldings or corollaries**: G01, G05, G06 and G09.
- **2 are premises of the model**: G08 (what occurs has conditions) and G20 (荀子's 同類同情 is constancy).
- **1 is a theorem under a further premise**: G21.

Six units state a law that is false as read. They fall in G11, G13, G15 and G16, and each has its countermodel.

The scratch Lean holds 58 declarations, and two patches add three below it:

- the proposal module, for the core: 11 laws, one definition, one model instance, one helper and 27 witnesses, so that every family has a net where Z fails;
- the checks module, which stays in scratch: 17 compositions that the home section states as text;
- the patches: `«位核含于逆核»` and `«生于逆核下不变»` in Grammar, with `«生于位核下不变»` as a case, and `«两向有常有前则通»` in GrammarReadings, with `«两向有常则通»` as a case.

Every declaration has an empty axiom report, those of the patched Grammar and GrammarReadings included.

What the work finds, beyond the count:

- **穷则变 is one unfolding of the definitions, and 通 is not reached through 变** (G01; corrected on 6 November 2026, in the note of that date below). What ends under a class and continues under another alters (the mirror of the grammar's `«生于细而续于粗则异»`), and it alters exactly where it has a successor (`«亡者异当且仅当有后»`). Under a class constant both ways, whatever has a predecessor passes through, altered or not (`«两向有常有前则通»`). That condition is sufficient, not necessary (`«不有常而通之例»`). So if 變 is read as one alteration, the chain is a conjunction, not an order, and it goes into 06 as text, not as a law. On the text's own 變 (「一闔一闢謂之變」, XCS-11-009), with every step parted, 通 is 變 at every place, going and coming (`check_tong_is_unending_bian`). 06's [open item](../../../../../../theories/becoming/chapters/06-CLASSICAL-TEXTS.md#open) on the order stays open, restated as a question of which 變 the text means.
- **相推 gives 全生成** (G02). Where every step passes from one phase to the other and everything goes on, the coarse pattern (the day, the year) goes on through carrying renewal at every point. The condition is sufficient; the converse is not claimed.
- **Bounded room works on the line itself** (G03, G04). Take a line on which no place comes back to itself. It is shorter than any list holding its places, so in bounded room it does not go on for ever (no end is exhibited). A line that merges nothing at its places, held by a list as long as itself, comes back to its start (`«线有限不并则返»`).
- **無緣不起 is a premise of the model, and production is not expressible** (G08). 無緣不起 holds of a net exactly where every occurrence is not-not conditioned, which the grammar does not assume. Production and joint sufficiency speak of an occurrence not yet there. The grammar's 缘 is a necessary relation between places of the net, and the grammar has no predicate of presence.
- **前際 and 後際 mirror each other** (G15). The core of a net keeps what goes forward: a line that never ends, and an ending. The core of the converse net keeps what goes back: a line that never ends going back, and a beginning (`«生于逆核下不变»`, which the Grammar patch adds, with `«生于位核下不变»` as its case). The 起信论's two sentences differ only in the connectives read into them. JS-326 (無後際) has 相應, read as one class of the core. JS-324 (無前際) has 故, read as dependence, and what depends on the beginningless can begin.
- **斷 has one sense, and the 中论's horns are read on their own terms** (G13, G16). 斷 is ending with nothing continuing it. Read so, 「若無常即墮斷邊」 is false: counting ends under identity and abides under the one. 「若無因而有萬物者，是則為常」 is false too: what has no condition abides under no class.

For a reader, each law comes with its hypotheses in the grammar's words and a net in which they fail and the conclusion fails with them. That is what the gate's item 4 asks. OU's owner has chosen what lands ([Decisions](#decisions-31-october)); whether the item is met is its decision at the landing.

## How the families were made

**Input.** The input is the 219 rows classed 丙一, with their form (the classifier's Z and Y), commentary and confidence ([units.tsv](data/units.tsv)). 162 come from the first batch, 25 from 中论 chapters 10, 17, 19 and 24, and 32 from 成唯识论.

**Families.** A family holds the laws read from one corpus statement, over every carrier, relation and class. Most families hold several laws; G13 holds six. A unit joins the family whose law it states, or whose law is the closest reading of it under its commentary. Each unit keeps its id and confidence ([groups.tsv](data/groups.tsv), written by [assign.py](kit/assign.py)).

**Dispositions.** Each unit gets one:

- *law*: the unit states a law of its family, or a case of it, and the law holds;
- *false*: the unit states a law that is false as read, and a countermodel is given;
- *premise*: the unit states the Z a law takes, or a premise of the model. For example, 「以依動故能見」 states a dependence, and 「不動則無見」 then states the law;
- *丁*: its Z or Y asserts, presupposes or turns on a valuation. Such a unit goes back to 丁, recorded and never forced in;
- *NE*: not expressible in the grammar, with the reason;
- *甲*: the unit states a definition.

**Rules.** Every unit falls under these five rules:

1. A unit is read under its commentary where it has one. A structural reading against the commentary is noted, not placed.
2. A unit whose clauses read apart is placed by its structural clause. Its other clauses (丁, NE, 甲) are noted in its reading.
3. A clause whose law turns on a valuation is 丁: 吉凶, 利害, 善惡 as moral kinds, 福罪, 苦 and 樂 as valenced, 勝 between parties, 養, 可 as approval, 好醜貴賤, aversion and seeking. A valuation word that only names a kind the law does not turn on (善知識, 非善染) is noted. Attainments (斷煩惱, 涅槃) are read as states, a line's ending. 染 and 淨 are read as a mark and its complement.
4. These are not expressible:
   - production and sufficiency, which speak of an occurrence not yet there. The grammar's 缘 is a necessary relation between places of the net, and the net has no predicate of presence;
   - 所緣緣, the object of a cognition, which the plan leaves out of 缘;
   - qualities and magnitudes of bodies;
   - agents' acts, offices and practices;
   - affects;
   - doctrinal terms with no relation.
5. A Z that is the presence or absence of a condition (離 X, 依 X) places a unit in G09. A Z that is the class taken (看, 由心迴轉) places it in G17.

**The grammar's terms.** The terms come from `Becoming.Grammar`, `GrammarReadings`, `GrammarMap`, `GrammarLaws`, `GrammarTesting` and the corpus's candidate theorems, `GrammarCandidates`, which landed with OU2c in 706b80293. Each term is used in the one sense the [glossary](../../../../../../GLOSSARY.md) gives:

- 缘 (a relation `R`), class (类), continuation (`«续»`), line (`«相续»`);
- the four marks (`«生» «住» «异» «亡»`);
- constancy (`«有常»`), the core (`«核»`), the two-way core (`«位核»`);
- reach (`«及»`), never ending (`«不穷»`), passing through (`«通»`);
- generation (`«全生成»`);
- marks as predicates (`«有相»`).

`«异» R E F x y` says that `y` continues `x` under `E` while `F` tells the two apart. Each mention of alteration below names its two classes.

**Depth.** Each law carries one of three labels:

- *definitional*: one unfolding of the definitions, or pure logic;
- *corollary*: one or two existing laws composed;
- *new*: a derivation of its own.

Only the new ones are results. A wrapper, recheck, rename or repeated acceptance is not another result.

**Form and countermodels.** A law is written "Y 当且仅当 Z" where an iff holds, and "Z 则 Y" otherwise. For every law the design names a net, a relation and a class, in which Z fails and Y fails with it. The net is a witness `…之例` in the proposal module, proposed for the core, or a declaration already in the package. A `check_…` in the checks module is a composition that the home section states as text, and no family rests on one alone. A *further premise* is one the grammar needs beyond the Z the text states, and each is named with its law.

## The 22 families

Units are given as count (高/中/低), then dispositions. Names marked † are in the proposal module, for the core, and names marked ‡ are put below by a patch. "def." is definitional, "cor." a corollary, and "text" a law the home section states in prose, with its scratch check where it has one.

| | laws | form | standing | where Z fails, Y fails | units |
|---|---|---|---|---|---|
| G01 穷变通久 | `«亡者异当且仅当有后»`† (def.); `«两向有常有前则通»`‡ (cor., GrammarReadings); what ends and continues under another class alters (text); the three joined (text in 06, not a law) | 则; iff | definitional and corollary; 通 needs two-way constancy, which is sufficient, not necessary | `«亡而息之例»`†, `«两向有常而无前不通之例»`†, `«有常而不通»`; not necessary: `«不有常而通之例»`† | 2 (1/0/1): law 2 |
| G02 相推而生 | `«皆有后而步皆分则全生成»`† (new); every parted step alters (text, `check_parted_steps_alter`) | 则 | new; sufficient, the converse not claimed | `«有亡而不全生成之例»`† (ends), `«步不分而不全生成之例»`† (keeps) | 4 (2/2/0): law 4 |
| G03 物壮则老 | `«线不返则短于所列»`† (new); `«不返而有限则非不穷»`† (new) | 则 | new; further premise: bounded room | `«返而不穷之例»`† (comes back), `«无环而不穷之例»`† (unbounded) | 2 (0/2/0): law 2 |
| G04 复归其根 | `«线有限不并则返»`; globally `«有限遍后定前则皆返»` | 则 | theorem | `«有限遍后而不返之例»`† (merges), `«遍后定前而无环之例»`† (unbounded) | 1 (0/0/1): law 1 |
| G05 乾坤毁则无以见易 | `«平等无异»`; `«无异当且仅当不分续»`† (def.) | 则; iff | theorem, with a definitional iff | `«静分续而有异之例»`† | 1 (1/0/0): law 1 |
| G06 感而遂通 | `«两向有常有前则通»`‡ (cor., GrammarReadings) | 则 | corollary; sufficient, not necessary | `«两向有常而无前不通之例»`†, `«有常而不通»`; not necessary: `«不有常而通之例»`† | 1 (0/0/1): law 1 |
| G07 动静有常 | `«类有常当且仅当含于核»` | iff | theorem | `«非有常之类不含于核之例»`† | 1 (0/1/0): law 1 |
| G08 缘起之设 | `«皆不生当且仅当皆非无缘»`† (def.) | iff | premise of the model | `«从缘生非文法之律»`, `«生亡并之例»`† | 3 (2/1/0): premise 3 |
| G09 依则离无 | `«依»`† (definition); `«所依无则依者无»`† (def.); `«依之传»`† (def.); on a region (text, `check_dependence_within_region`) | 则 | definitional | `«不依之例»`†; condition before the region (text, `check_dependence_outside_region`) | 37 (9/26/2): law 24, premise 13 |
| G10 相由俱有 | `«相由则俱有»`, `«俱有为一念»`, `«缘先果后当且仅当无环»` | 则; iff | theorem | `«无环则无俱有»`† (cor.) | 4 (0/3/1): law 4 |
| G11 相须 | `«有常则往不穷»` at the joint class (`«合»`); `«相须»` | 则 | theorem; witnesses `«相须之例»`†, `«火薪相须»` | `«有前不有常而亡之例»`†; the converse is false: `«不有常而不穷之例»`† | 3 (0/3/0): law 2, false 1 |
| G13 不断不常 | `«四相俱时»`, `«四相无自立»`, `«非一非异»`; `«住亡不并»`, `«断则无相续»`, `«住因于续»` | 则 | theorem; further premise: not its own condition | own condition: `«自缘则常»`; no result: `«生亡并之例»`†; two classes: `«亡于静而住于一之例»`†; false: `«亡于静而住于一之例»`†, `«无缘不住而他有后之例»`† | 14 (3/9/2): law 12, false 2 |
| G14 恒相续 | `«有常则往不穷»`; `«生于细而续于粗则异»` | 则 | theorem; sufficient, not necessary | `«有前不有常而亡之例»`†; `«平等无异»`; not necessary: `«不有常而不穷之例»`† | 14 (8/6/0): law 14 |
| G15 前际后际 | `«核同则同不穷»`† (new), also at the converse net (text, `check_wushi_along_converse_core`); `«亡于核下不变»`; `«生于逆核下不变»`‡ (cor., Grammar); the witness `«无始而有终之例»`† | 则 | new; the four mirror each other under `«逆»` | `«不穷与亡不同核之例»`†; forward core: `«生于核下可变之例»`†; the converse core is wider: `«逆核不含于核之例»`†; false through dependence: `«依于无始而有始之例»`† | 4 (1/3/0): law 3, false 1 |
| G16 定性与常 | `«自缘则常»`, `«有成坏当且仅当不自缘»`, `«定性之判»`, `«缕之无定性»`; what has no condition begins under every class (text, `check_unconditioned_begins_everywhere`) | 则; iff | theorem | not its own condition: `«生亡并之例»`†; a condition: `«亡于静而住于一之例»`†; false: `«生亡并之例»`† (ZL-01-099), `«自缘而不生之例»`† (ZL-02-070) | 13 (1/9/3): law 11, false 2 |
| G17 显隐随类 | `«平等无异»`, `«遍而无相»` | 则 | theorem | `«静分续而有异之例»`† | 10 (0/4/6): law 10 |
| G18 标与其补 | `«有相则非亦有相»`, `«知相则有其非»`, `«离非无相»`, `«遍而无相»` | 则 | theorem | `«无相而非亦无相之例»`† | 4 (0/1/3): law 4 |
| G19 三时相待 | `«能所相待»` at reach | iff | theorem, global only | `«无能无所之例»`†; pointwise false: `«有生不必有亡»` | 3 (3/0/0): law 3 |
| G20 同类同情 | `«有常»` for perceiving, pointwise (`«有常之逐点»`) | iff | premise of the model | `«非有常之类不含于核之例»`†, `«有前不有常而亡之例»`† | 2 (0/1/1): premise 2 |
| G21 征知 | `«可分则不在核»`; its converse under a premise, `«不可致诘而有常则混而为一»` (text, `check_telling_apart_needs_a_stage`); the two stagings are one relation (text, `check_stage_eq_inquiry`) | 则 | theorem under a further premise | premise fails: `«致诘不尽»`; in the core: `«核则不可致诘»` | 2 (0/2/0): law 1, premise 1 |
| G22 衡 | `«保之像»` (def.) | iff | theorem | `«像不保之例»`† | 2 (0/2/0): law 2 |
| G23 无厚入有间 | `«尺与端或尽或不尽»` | 则 | theorem | `«尺与尺可相尽»` | 1 (0/1/0): law 1 |

G12 and G24 of the first draft are dissolved. G12's three units went to G09 and G13. G24's four units went to not expressible under rule 1.

## Family by family

Each entry gives the units, the laws, the reading (an AI reading) and what the reading loses. Each unit's own reading is in [groups.tsv](data/groups.tsv).

**G01 穷变通久** (XCX-02-008 高, XCS-04-004 低).

- **Laws.**
  - Let `x` end under `E` and let `y` continue `x` under `F`. Then `x` alters into `y` (`«异» R F E x y`: `F` continues, and `E` tells the two apart). This is one unfolding of `«异»` and `«亡»`, the mirror on the side of what comes after of `«生于细而续于粗则异»`. It is the "则" half of the next law, so it is text.
  - For what ends under `E`, altering under `F` is exactly having a successor under `F` (`«亡者异当且仅当有后»`).
  - If `F` is constant under 缘 and under its converse, whatever has a predecessor under `F` passes through under `F`, altered or not (`«两向有常有前则通»`). The GrammarReadings patch puts it below, with `«两向有常则通»` as its case.
  - Never ending is half of passing through by definition. The three together are a conjunction: the ending yields the alteration, the constancy yields passing through, and 變 does no work toward 通. The conjunction goes into 06 as text, not as a law, and the reviewed draft's `«亡而续于两向有常之类则异通不穷»` is dropped.
- **Reading.** 窮 is ending under a class. 變 is the step that a second class continues and the first tells apart. 通 is `«通»` (往来不穷, the text's definition at XCS-11-010), and 久 is its `«不穷»` half. XCS-04-004 is read through 韩注's 聚極則散, as the classifier's note cites it. On the text's own 變 (一闔一闢, XCS-11-009), read as every step being parted, 通 is 變 at every place, going and coming (`check_tong_is_unending_bian`, definitional).
- **Where Z fails.**
  - One occurrence with nothing after it ends, ceases (`«息»`) and does not alter (`«亡而息之例»`).
  - Under a class constant both ways, an occurrence with no predecessor does not pass through (`«两向有常而无前不通之例»`).
  - With constancy one way only, the line does not pass through (`«有常而不通»`).
  - Constancy is not necessary: in `«不有常而通之例»` the class is not constant, yet the occurrence ends, alters and passes through.
- **Lost.** 06's open item asks where the order 穷 → 变 → 通 holds. On 變 as one alteration there is no order to find. On 變 as 一闔一闢 the second step is definitional. Choosing between the two is a question of reading that this design does not settle, and 06's open item is restated as that question ([Open](#open)). 06 §5.7's hexagram-world reading (老则变 within the 之卦 law) stays a model law. 「困，窮而通」 is still no counterexample (06 §二).

**G02 相推而生** (XCX-04-004 高, XCX-04-005 高, XCS-02-002 中, XCX-01-003 中).

- **Law.** Suppose everything is continued under a coarse class `L`, and every step of 缘 leaves the fine class `E`. Then for every `x`, the coarse line never ends and a carrying renewal lies ahead of each of its points: `«全生成» R L E x`. Day and night are its instance (`«昼夜全生成»`). Where every step is parted, every continuation alters (text; `check_parted_steps_alter`). The law is sufficient: 相推 gives 全生成, and the converse is not claimed.
- **Reading.** 相推 is each step passing from one phase to the other (日往則月來，月往則日來). 明生 and 歲成 are the coarse pattern going on through carrying renewal, generation in chapter 2's sense, never arising or any new organization. 剛柔相推而生變化 (XCS-02-002, XCX-01-003) is read with 變化 as the alteration at each such step.
- **Where Z fails.** The short line reaches an end, so it is not 全生成 (`«有亡而不全生成之例»`). The still occurrence's step keeps the class, so not every step is parted, and it keeps every class (全守) and does not generate (`«步不分而不全生成之例»`).
- **Lost.** XCS-06-004/005 (大生, 廣生) went to not expressible, since their 生 means "to produce".

**G03 物壮则老** (LZ-30-008 中, LZ-55-009 中).

- **Laws.** Suppose no place of a line of continuation comes back to itself along continuation, and a list holds the line's places. Then the line has fewer steps than the list is long (`«线不返则短于所列»`). Only the line is constrained, not the whole net. So where a list holds every place of the line from `x` and none of them comes back to itself, that line is not endless (`«不返而有限则非不穷»`).
- **Reading.** 壯 is a rise whose line does not come back. 不道 is not coming back, read with 「反者道之動」 (40章). 早已 is that line not going on for ever in bounded room. 王弼's 暴 (intensity) is not read.
- **Where Z fails.** Counting up has no bounding list and never ends (`«无环而不穷之例»`). Day and night have bounded room, come back and never end (`«返而不穷之例»`).
- **Lost.** 早 is the bound only, the list's length, not a time. Constructively, ¬`«不穷»` exhibits no end. LZ-23-002 (飄風驟雨) went to not expressible, since it needs magnitudes of intensity and duration.

**G04 复归其根** (LZ-16-003 低).

- **Laws.** A line that merges nothing at its places and is held by a list as long as itself comes back to its start: `«及» R (g 0) (g 0)` (`«线有限不并则返»`). Globally: where a list holds every occurrence, everything has a successor and nothing merges, every occurrence reaches itself (`«有限遍后定前则皆返»`). G03 and G04 are two sides of one pigeonhole.
- **Reading.** 復歸其根 is the line coming back to its start. The law gives reach along 缘 (`«及» R x x`), not `«复»` under a class. 芸芸 is every occurrence.
- **Where Z fails.** In a merge (both of two occurrences go to the second; `«定前»` fails), the first never comes back (`«有限遍后而不返之例»`). Counting up merges nothing and never comes back, and no list holds it (`«遍后定前而无环之例»`).
- **Lost.** 歸根曰靜 and 復命曰常 are 甲 units elsewhere in the corpus.

**G05 乾坤毁则无以见易** (XCS-12-012 高).

- **Laws.** Under the one nothing alters (`«平等无异»`). More exactly, nothing alters from `E` under `F` (no `«异» R E F`) exactly where `F` tells apart the two ends of no continuation under `E`, up to double negation (`«无异当且仅当不分续»`). This is pure logic, for any `F`, a class or not.
- **Reading.** 乾坤 are the two classes of one distinction. 毁 is the distinction becoming the one, under which no step is parted (無以見易). 易不可見 is the distinction parting no continuation's ends. 息 is read so, not as the grammar's `«息»`.
- **Where Z fails.** Day and night under the one, told apart by identity: the step alters (`«静分续而有异之例»`).
- **Lost.** The iff says only that `F` parts no continuation's ends, not that the distinction parts nothing in the net.

**G06 感而遂通** (XCS-10-006 低).

- **Law.** Under a class constant under 缘 and its converse, an occurrence with a predecessor passes through (`«两向有常有前则通»`). Constancy gives the successor, so a predecessor suffices where `«两向有常则通»` takes abiding. The condition is sufficient, not necessary (`«不有常而通之例»`).
- **Reading.** 感 is a predecessor reaching it under the class. 遂通 is `«通»`. 寂然不動 is having no predecessor.
- **Where Z fails.** A lone occurrence under a class constant both ways does not pass through (`«两向有常而无前不通之例»`). Counting up from zero is constant one way only (`«有常而不通»`).
- **Patch.** By OU's owner's decision the law goes below, into GrammarReadings, and `«两向有常则通»` becomes its case ([patches](kit/patches/README.md)).

**G07 动静有常** (XCS-01-003 中).

- **Law.** For a class, being constant under 缘 is exactly lying within its core: what the class puts together, 缘 never tells apart.
- **Reading.** 動靜有常 is the class being constant. 剛柔斷 is the class lying within its core. The corpus gives no commentary for this unit.
- **Where Z fails.** One occurrence is its own successor and another has none. The one is not constant, and its core does not put the two together (`«非有常之类不含于核之例»`).

**G08 缘起之设** (JSZ-C-015 高, JSZ-C-016 高, JSZ-C-005 中).

- **Statement.** That nothing begins under the one is exactly that no occurrence is without a condition, not-not conditioned (`«皆不生当且仅当皆非无缘»`, two lines from `«一之生»`). So 「無緣即不起」 states a premise of the model, as the candidate theorems found for 「一切物皆從眾緣生」.
- **Where it fails.** The grammar admits an occurrence with no condition (`«从缘生非文法之律»`). The lone occurrence begins under the one (`«生亡并之例»`).
- **Moved.** The production and joint-sufficiency units went to not expressible (rule 4), nine of them: JSZ-P-01-003, JSZ-C-069, ZL-07-133, ZL-07-170, ZL-07-127, XCX-04-050, XCX-04-051, QXL-JS-212 and JSZ-C-044 (the last as 所緣). QXL-JS-214 went to G09.

**G09 依则离无** (37 units: 24 state the law, 13 the premise; QXL-JS-119 高, QXL-JS-123 高, QXL-JS-159 高, QXL-JS-197 高, QXL-JS-058 高, QXL-JS-167 高, ZL-24-041 高, ZL-17-040 高, ZL-17-042 高, …).

- **Laws.** `Q` depends on `P` along `R` (`«依»`: every occurrence with `Q` has a condition with `P`). Then if nothing is `P`, nothing is `Q` (`«所依无则依者无»`), and dependences compose along `«而»` (`«依之传»`).
  - Both are unfoldings of the definition.
  - `«依»` is one-way.
  - Before landing, it should be checked against the registered one-way 所依, which the plan marks 待核.
- **Temporal readings.** Some units speak of an ending in time: 「心滅則種種法滅」 (QXL-JS-123), QXL-JS-159 and QXL-JS-166. For these the law holds on a region `W`, a predicate on occurrences, when every `Q` in `W` has its `P`-condition in `W` (text; `check_dependence_within_region`). A result whose condition lies before the region stays in it when nothing in the region is the condition (text; `check_dependence_outside_region`). Both stay text: the region law is `«所依无则依者无»` at `W ∧ P` and `W ∧ Q`. "Within the region" replaces the first draft's "co-present", which is `«俱有»`'s word.
- **Reading.** The 起信论's 離 X 則無 Y units state the law, and its 依 X 故有 Y units state the dependence, the Z. Chains are compositions: 無明 → 心起 → 境界 (QXL-JS-197), and 中论 24's 俗諦 → 第一義 → 涅槃 (ZL-24-041). 涅槃 is read as a line's ending.
- **Where Z fails.** A `Q` with no `P`-condition stands where nothing is `P` (`«不依之例»`).
- **Lost.**
  - The kinds (心, 境界, 種子) are the model's. That this text's 境界 depends on its 心 is its premise, which the grammar neither proves nor refutes.
  - 「心生則種種法生」 is production, a not-expressible part.
  - In QXL-JS-167, 以體不滅心得相續 rests on a substance (體), which the plan registers as not a class.

**G10 相由俱有** (QXL-JS-178 中, QXL-JS-179 中, CWS-P3-077 中, ZL-01-065 低).

- **Laws.** Mutual conditions are co-present (`«相由则俱有»`), and co-presence is one cluster (`«俱有为一念»`). Every condition strictly precedes its result exactly where there is no cycle (`«缘先果后当且仅当无环»`).
- **Reading.** The 熏習 loops of the 起信论 (QXL-JS-178, -179), 成唯识论's 能熏生種、種起現行 (CWS-P3-077), and the 中论's reductio 「穀作芽、芽作穀者應是一」 (ZL-01-065).
- **Where Z fails.** In a net without cycles nothing is co-present (`«无环则无俱有»`, one transitivity step).
- **Moved.** CWS-P3-074 went to not expressible: its Z, 俱生俱滅, is arising and ceasing together, a simultaneity that `«俱有»` (mutual reach) does not state, and its Y is a doctrinal term. QXL-JS-195 went to 丁: its Z is an attitude (厭求).

**G11 相须** (CWS-P6+P7+P8-019 中, -049 中; -020 中 false).

- **Laws.** Where the joint class of the holding classes is constant, the joint line from what it has continued never ends (`«有常则往不穷»` at `«合»`). 「不相離」 is `«相须»`: the joint class is constant and neither class alone is. `«相须之例»` witnesses it on three bits. A point goes on only where its first two bits agree, and the joint class puts two distinct points together, so it is not identity. `«火薪相须»` witnesses it through the core for the flame that ends.
- **Reading.** 「三法無間轉者可恒相持」: 壽, 煖 and 識 turning without gap is the joint class being constant. 壽煖識不相離 (-049) is the three held together, neither alone.
- **Where Z fails.** On the short line `true` has a predecessor, the one is not constant, and `true` ends (`«有前不有常而亡之例»`).
- **False as read.** 「不爾，便無恒相持用」 (-020) states the converse: no constancy, no lasting holding. It is false: a class that is not constant, under which a line never ends (`«不有常而不穷之例»`).
- **Moved.** CWS-P6+P7+P8-043 went to G09. ZL-10-043 went to not expressible: its Z is human effort and its Y a non-difference.

**G13 不断不常** (14 units: 12 law, 2 false; ZL-21-120 高, CWS-P1-031 高, CWS-P9-016 高, …).

- **Laws.**
  - An occurrence with a condition and a result, and not its own condition, abides under the one (不斷) and begins and ends under identity (不常) (`«四相俱时»`, `«四相无自立»`).
  - Without self-conditioning there is no continuation under identity at all (`«非一非异»`).
  - At one class, what ends there does not abide there (`«住亡不并»`, ZL-21-031).
  - What ends under a class starts no line under it (`«断则无相续»`, ZL-01-047).
  - Abiding needs continuation (`«住因于续»`, ZL-02-091).
  - Abiding on a line of going is having a predecessor and a successor (ZL-02-010).
- **One sense of 斷.** 斷 is ending under the one, with nothing continuing it. It is used in this sense in G13 and G16 alike.
- **Reading.** 似我相現 and 似常一 (CWS-P1-031, P9-016, P1-007) are continuing under a coarse class (一類相續) taken for identity. 來 and 出 (ZL-01-079, -086) are continuation read as identity, which needs self-conditioning. The premise 不自缘 is the candidate theorems' finding.
- **Where Z fails.** An occurrence that is its own condition abides under every class, identity included (`«自缘则常»`). One with no result ends under the one (`«生亡并之例»`). For `«住亡不并»` read across two classes, both hold: counting at one ends under identity and abides under the one (`«亡于静而住于一之例»`).
- **False as read.**
  - 「若無常即墮斷邊」 (ZL-21-113): with 無常 as not abiding under identity and 斷 as ending under the one, counting at one is a countermodel (`«亡于静而住于一之例»`). Its other half, 若常即墮常邊, is a tautology.
  - 「若離業有果報，則有斷常」 (ZL-17-051): a result with no deed among its conditions gives neither. It abides under no class, so it is not 常, and the deed may go on, so it is not 斷 (`«无缘不住而他有后之例»`).

**G14 恒相续** (14 units; CWS-P4-019 高, CWS-P5-017 高, CWS-P5-021 高, CWS-P5-022 高, CWS-P1-018 高, CWS-P1-024 高, CWS-P1-030 高, CWS-P6+P7+P8-015 高, …).

- **Laws.** Under a class constant under 缘, a line with a past never ends (`«有常则往不穷»`). A beginning under a finer class on it is an alteration, not a break (`«生于细而续于粗则异»`).
- **Reading.** In 瀑流 the stream's class is constant, and the waves (轉識, raised by 風緣) begin under the fine class on a line that does not break. In 一類相續、無間無轉 the class is constant and the line never breaks. 不失法 (ZL-17-076, -086, the opponent's view in 中论 17) is a class constant under 缘 that carries the deed.
- **Where Z fails.** On the short line, `true` has a predecessor, the one is not constant, and `true` ends (`«有前不有常而亡之例»`). Under the one nothing alters (`«平等无异»`).
- **Lost.** Constancy is global and sufficient, not necessary (`«不有常而不穷之例»`): "Z 则 Y", not iff. CWS-P1-030 is split under rule 2, with 厭患苦故求趣涅槃 as a 丁 part. In CWS-P6+P7+P8-003, 非善、染 classifies the mind as neither, a valuation the law does not turn on. LZ-33-005 went to not expressible under rule 1.

**G15 前际后际** (QXL-JS-326 中, QXL-JS-238 中, CWS-P4-062 高; QXL-JS-324 中 false).

- **Four mirrored statements**, for a class `E`:
  - 無後際 is kept along the core: what `«核» R E` puts with an occurrence whose line never ends has a line that never ends (`«核同则同不穷»`).
  - 無前際 is kept along the core of the converse net: the same law at `«逆» R` (text; `check_wushi_along_converse_core`).
  - Ending is kept along the core (`«亡于核下不变»`).
  - Beginning is kept along the core of the converse net (`«生于逆核下不变»`). That core needs no forward constancy. The two-way core lies within it (`«位核含于逆核»`), so `«生于位核下不变»` is its case, and it also joins pairs the forward core does not (`«逆核不含于核之例»`). By OU's owner's decision the law goes below, into Grammar, by the patch ([patches](kit/patches/README.md)).
- **No asymmetry.** The forward core does not keep a beginning (`«生于核下可变之例»`). Each side is kept by the core of its own direction.
- **Reading.**
  - 「如來藏無有後際，諸佛所得涅槃與之相應則無後際」 (JS-326) holds with 相應 read as lying in one class of the core, the technical 相應 (association) read as never told apart. Whether the 起信论's uses of 相應 bear that reading stays open ([Open](#open)).
  - 「以如來藏無前際故，無明之相亦無有始」 (JS-324) has 故, read as dependence, and no 相應.
  - 「染法從無始已來熏習不斷，乃至得佛後則有斷」 (JS-238) and 「阿羅漢位方究竟捨」 (CWS-P4-062) are lines without beginning that end. Counting down to zero witnesses them: going back from zero never ends, and zero ends (`«无始而有终之例»`).
- **Where Z fails.** Where the core does not join them, an occurrence whose line never ends can stand beside one that ends (`«不穷与亡不同核之例»`).
- **False as read.** JS-324, read through dependence, is false. What depends on a line without beginning can begin (`«依于无始而有始之例»`), given a class that tells the two kinds apart (`check_kinds_told_apart`). JS-318 says the 煩惱染法 never 相應 with 如來藏, which denies the premise JS-326's reading uses, provided 無明 is among the 染法 (JS-176), which stays open ([Open](#open)). JS-324's conclusion is a premise of the model.
- **Moved.** ZL-02-070 went to G16 as false as read. LZ-63-004 went to not expressible, since it needs magnitude.

**G16 定性与常** (13 units: 11 law, 2 false; ZL-24-185 高, …).

- **Laws.** This is the candidate theorems' family of no own position:
  - What is its own condition abides under every class (`«自缘则常»`; ZL-07-235 自相住則為是常; ZL-21-022, -058, -069).
  - Something has a beginning, or an end, under some class exactly when it is not its own condition (`«有成坏当且仅当不自缘»`).
  - It has no own position exactly when it is not-not conditioned and not its own condition (`«定性之判»`; ZL-24-185, JSZ-C-067, ZL-17-162). One occurrence begins under one class and not another (JSZ-C-064).
  - 縷自有定相不應從麻出 (ZL-07-162, -163) is `«缕之无定性»` read back.
  - What has no condition begins under every class (text, `check_unconditioned_begins_everywhere`; ZL-01-040 離劫初穀有今穀則應有生).
- **Where Z fails.** What is not its own condition can begin and end (`«生亡并之例»`). What has a condition does not begin under the one (`«亡于静而住于一之例»`).
- **False as read.**
  - 「若無因而有萬物者，是則為常」 (ZL-01-099): what has no condition abides under no class (text, `check_unconditioned_not_abiding`), and it can end (the lone occurrence, `«生亡并之例»`). It is false whether 常 is read as abiding under every class or as never ending.
  - 「若決定有去、有去者，應有初發」 (ZL-02-070): own position read as own condition gives no beginning under any class (text, `check_own_condition_no_beginning`; its instance `«自缘而不生之例»`). It is the premise of a reductio.
- **Moved.** LZ-07-002 went to not expressible under rule 1, since 王弼 reads 自生 as 與物爭, a social stance. Read against the commentary, with 不自生 as not its own condition, it would be false: the short line's end (`check_short_end_not_own_condition`). ZL-17-051 went to G13.

**G17 显隐随类** (10 units: JSZ-P-07-007, -008, -009, -014, -015, -016 and -032; QXL-JS-406, QXL-JS-313, LZ-28-006).

- **Laws.** Under a class holding of every pair nothing alters (`«平等无异»`). A predicate holding everywhere has no mark (`«遍而无相»`).
- **Reading.** 看 is the class taken. Under the class of shapes the lion is told apart (顯). Gold holds of every part and has no mark (隱). Under gold's class nothing in the lion is told apart. 純 is everything being one kind under one class; under several classes each is pure and mixed (雜). 分齊 and 差別 are relative to the class taken.
- **Where Z fails.** Under identity, a step of day and night is told apart (`«静分续而有异之例»`).
- **Lost.**
  - "Shows" is read as being told apart.
  - 由心迴轉 (JSZ-P-07-032) is read as changing the class taken; the turning mind is not read.
  - LZ-28-006 (樸散則為器) loses 王弼's generative reading (殊類生), and 聖人用之…大制不割 is a 丁 part.
- **Moved.** QXL-JS-012 and -252 went to G09 under rule 5.

**G18 标与其补** (QXL-JS-256, QXL-JS-260, QXL-JS-028 中, LZ-01-001).

- **Laws.** The candidate theorems' mark and its complement: a mark gives its complement a mark, to know a mark is to have its non, where nothing falls outside there is no mark, and what has a mark does not hold everywhere.
- **Reading.** 「若心起見，則有不見之相」 and 「若離妄心實無可空」. 「道可道，非常道」 is read with 王弼's 指事造形，非其常也.
- **Where Z fails.** What holds everywhere has no mark, and neither has its complement, so Z and Y fail together (`«无相而非亦无相之例»`). In general, a predicate holding everywhere or nowhere has no mark (text, `check_everywhere_no_mark_both`).

**G19 三时相待** (ZL-19-002, -003, -004, all 高; the opponent's view in 中论 19).

- **Law.** Past and future are the two ends of one reach: something precedes exactly where something follows (`«能所相待»` at `«及» R`).
- **Where Z fails.** In the empty net nothing conditions and nothing is conditioned (`«无能无所之例»`; in general, text, `check_nothing_conditions_nothing_conditioned`).
- **Lost.** Pointwise the law fails: zero in counting up has a later and no earlier (`«有生不必有亡»`). The grammar keeps the three times as positions relative to a present, not as three things.

**G20 同类同情** (XZ-ZM-034 中, XZ-ZM-016 低).

- **Statement.** 「凡同類同情者，其天官之意物也同」 says the class 同類同情 is constant under perceiving: `«有常»`, pointwise (`«有常之逐点»`). It is a premise of 荀子's model and the ground of 約定俗成. 名定而實辨 (XZ-ZM-016) has a fixed naming class that tells realities apart. Its Z is the fixing of names, not a ruler arising, unlike XZ-ZM-026, which is not expressible.
- **Where it fails.** For a class that is not constant, the core does not put together what the class does (`«非有常之类不含于核之例»`, `«有前不有常而亡之例»`).
- **Lost.** The grammar uses one carrier, so perceivers and percepts fall under one class. 慎率民而一焉 (XZ-ZM-016) is a 丁 part.

**G21 征知** (XZ-ZM-044 中 law, XZ-ZM-043 中 premise).

- **Law.** 「征知必將待天官之當簿其類，然後可也」 makes registration at a stage the conclusion: what the coupling does not put in its core is told apart at some stage. That is the converse of `«可分则不在核»`. It holds under the premise that being told apart at no stage is itself constant (`«不可致诘而有常则混而为一»`; text, `check_telling_apart_needs_a_stage`). `«可分则不在核»` itself (told apart at a stage, so not in the core) holds unconditionally. The stages of GrammarTesting (层) and the stages of inquiry in the candidate theorems (诘) are one relation at every stage (text, `check_stage_eq_inquiry`).
- **Where the premise fails.** Some pairs are told apart at no stage and still lie outside the core (`«致诘不尽»`). What lies in the core is told apart at no stage (`«核则不可致诘»`).
- **Premise.** XZ-ZM-043 (征知 through the senses) is knowing along the sense's coupling and then the mind's, `«而»` of the two: a premise of 荀子's model.
- **Note.** This uses GrammarTesting's laws, not Part B's models.

**G22 衡** (XZ-ZM-164 中, -165 中).

- **Law.** A balance keeps "heavier than" within "hangs lower than" exactly where every heavier pair maps to a lower-hanging pair (`«保之像»`, an unfolding of `«像»` and `«则»`).
- **Where Z fails.** A reversing balance, 「衡不正，則重縣於仰，而人以為輕」 (`«像不保之例»`).
- **Open** [AI reading]. Does 衡不正 mean the balance reverses, or only that it fails to keep the order? If it reverses, the unit is definitional; if it only fails to keep, 重縣於仰 does not follow. The corpus gives no commentary ([Open](#open)).

**G23 无厚入有间** (ZZ-YSZ-016 中).

- **Law.** The 墨经's 尺與端: a point within what has two distinct parts does not fill it (`«尺与端或尽或不尽»`).
- **Reading.** 「以无厚入有間，恢恢乎其於遊刃必有餘地矣」.
- **Where Z fails.** Two extended things can fill each other (`«尺与尺可相尽»`).

## Outside the families

The reasons for each unit are in [groups.tsv](data/groups.tsv).

**Back to 丁 (33).**

- 老子 18's virtues and counterfeits (LZ-18-001…004). The claim values a social order's decline. The marking reading (a virtue is named only where its absence occurs, `«知相则有其非»`) fits three of them but loses that claim.
- 利 and 用 (LZ-11-004), and the ranking of 道 德 仁 義 禮 by loss (LZ-38-006).
- LZ-22-001. 王弼 reads each pair as the sage not displaying himself (rule 1). Read against the commentary, "what is worn renews" would be false (`«亡而息之例»`).
- 荀子's 可 as approval (XZ-ZM-144, -152), his 重物, 輕理, 危 and 憂恐 (XZ-ZM-179…182), and 養 (XZ-ZM-191, -192).
- The 起信论:
  - 苦 as Y (QXL-JS-079, -181);
  - attitudes of aversion and aspiration: 厭生死苦, 樂求涅槃, 信 and 善根 (JS-194, -206, -215, -216), and 厭求 as Z (JS-195);
  - 修善根 (JS-217);
  - valued qualities: 常樂我淨 and 淨功德 (JS-258, -259).
- 中论 17 (the opponent's view): merit and demerit (ZL-17-002, -024, -026, -028, -056), deeds ordered by gravity (ZL-17-090), and 好醜貴賤 (ZL-17-135).
- 成唯识论's 異熟 from valenced deeds only (CWS-P2-007): the valuation is what the law turns on. Its 等流 from all three kinds (CWS-P2-006) is 甲.

**Not expressible (53).**

- **Production and sufficiency** (10), rule 4: JSZ-P-01-003, JSZ-C-069, ZL-07-133, ZL-07-170, ZL-07-127 (an unarisen 法 meeting its conditions), XCX-04-050, XCX-04-051 (化醇, 化生), QXL-JS-212 (joint sufficiency of 因 and 緣), XCS-06-004 and XCS-06-005 (大生, 廣生).
- **所緣緣** (2): JSZ-C-044 and QXL-JS-086.
- **Read under the commentary** (6), rule 1:
  - LZ-07-002 (自生 as 與物爭);
  - LZ-33-005 (以明自察，量力而行);
  - LZ-36-001…004. 王弼's 因物之性，令其自戮 is a strategy. Read against the commentary as "every end is preceded by a rise" (`«亡»` → `«有前»`), it would be false (`«生亡并之例»`).
- **Qualities, rates and magnitudes of bodies** (10):
  - 虛, 濁清 and 徐 (LZ-05-004, LZ-15-004, -005);
  - 柔脆, 枯槁 and 堅強 (LZ-76-001…003);
  - wind and rain lasting less than a morning (LZ-23-002);
  - great and small (LZ-63-004);
  - 清寧靈盈 and the office of 侯王 (LZ-39-001, -002).
- **勝 between qualities or parties** (6): LZ-36-006, LZ-43-001, LZ-45-006, LZ-76-004, LZ-78-001 and -002. Read as a contest, the Y would rank outcomes.
- **Social mechanisms and specific kinds** (5): ruler and people (LZ-75-001…003); armies, land, rain and people (LZ-30-003, LZ-32-003).
- **Amounts** (5):
  - 有餘 and 不足 (LZ-77-004, -005), which are laws of the World model with natural-number amounts, not of the grammar;
  - 段食 and 增長 (CWS-P6+P7+P8-072);
  - 偏勝, a comparison of degree (CWS-P6+P7+P8-073);
  - the force of long practice (QXL-JS-196).
- **Agents' acts, practices, psychology and attainments** (5):
  - a ruler's naming practice (XZ-ZM-026);
  - desire and belief moving to seeking (XZ-ZM-143);
  - volition moving to action (ZL-17-013);
  - affect and perception (XZ-ZM-183);
  - a knower's attainment (QXL-JS-048).
- **Relations the grammar does not state** (4):
  - 俱生俱滅 → 熏習義成 (CWS-P3-074);
  - 人功 → 火不異可燃 (ZL-10-043);
  - a dialectical consequence inside the opponent's system (ZL-17-077);
  - 陰陽合德、剛柔有體, which has no relational reading that the commentary fixes (XCX-05-004).

**Definitions (5).** 等流 and 自類相生 are continuation under the class of one's kind (CWS-P2-006, CWS-P3-078). 因緣 and 增上緣 are two kinds of condition, which in the grammar are two relations, given apart (CWS-P3-039, -040). 攝藏 is holding the seeds (CWS-P5-006).

## New Lean, in scratch

**The patches** ([kit/patches](kit/patches/README.md)) are exact diffs against main at 248122055. There Grammar.lean and GrammarReadings.lean are as they were at a85edc40c. A generalizing law goes below, into the module of the law it generalizes, and the old law becomes its case:

| patch | new | becomes a case | unchanged |
|---|---|---|---|
| Grammar | `«位核含于逆核»`: `«则» («位核» R E) («核» («逆» R) E)`; `«生于逆核下不变»`: `«类» E`, `«核» («逆» R) E y y'` and `«生» R E y` give `«生» R E y'` | `«生于位核下不变»`, through `«位核含于逆核»` | `«位同则生亡同»` and every other use |
| GrammarReadings | `«两向有常有前则通»`: `«类» E`, `«有常» R E`, `«有常» («逆» R) E` and `«有前» R E x` give `«通» R E x` | `«两向有常则通»`, at `hx.1` | `«有常而不通»`, `«昼夜往来不穷»` |

Each old law keeps its statement. The leaf cites the new laws and does not restate them. The patches' README gives:

- the proofs;
- the commands that check the patches;
- the texts outside the package that name the two laws. Among them is the OU plan's line on beginning, which the Grammar patch makes inexact.

**The proposal module** is `Becoming.GrammarConditionals`, proposed for the core. It imports `Becoming.GrammarCandidates` and `Becoming.GrammarLaws`. It needs GrammarMap's `«全生成»` and short line, and GrammarLaws' pigeonhole and finite lines. It holds 41 declarations:

- 11 laws;
- the definition `«依»`;
- the instance `«昼夜全生成»`;
- the helper `counting_reach_lt`;
- 27 witnesses.

A definitional or corollary law is a lemma here only where a family's "Y 当且仅当 Z" or "Z 则 Y" needs it to be stated exactly. The rest are text in the home section.

| declaration | statement | depth | family |
|---|---|---|---|
| `«亡者异当且仅当有后»` | for `«亡» R E x`: `(∃ y, «异» R F E x y) ↔ «有后» R F x` | def. | G01 |
| `«皆有后而步皆分则全生成»` | `∀ y, «有后» R L y` and `∀ a b, R a b → ¬ E a b` give `«全生成» R L E x` | new | G02 |
| `«昼夜全生成»` | day and night are 全生成 under the one and identity | instance | G02 |
| `«线不返则短于所列»` | no place `g i` (`i ≤ n`) has `«相续» R E (g i) (g i)`; `n` continuation steps; places in `l`: `n < l.length` | new | G03 |
| `«不返而有限则非不穷»` | no place on the line from `x` reaches itself; `l` holds the line: `¬ «不穷» R E x` | new | G03 |
| `counting_reach_lt` | reach along the successor of counting rises | helper | G03, G04 |
| `«无异当且仅当不分续»` | `(∀ x y, ¬ «异» R E F x y) ↔ ∀ x y, «续» R E x y → ¬¬ F x y` | def. | G05 |
| `«皆不生当且仅当皆非无缘»` | `(∀ y, ¬ «生» R «一» y) ↔ ∀ y, ¬¬ ∃ x, R x y` | def. | G08 |
| `«依»` (definition) | `∀ y, Q y → ∃ x, R x y ∧ P x` | definition | G09 |
| `«所依无则依者无»` | `«依» R P Q` and `¬ ∃ x, P x` give `¬ ∃ y, Q y` | def. | G09 |
| `«依之传»` | `«依» R P Q` and `«依» R' Q S` give `«依» («而» R R') P S`, so that a chain (QXL-JS-197, ZL-24-041) is one law | def. | G09 |
| `«无环则无俱有»` | `«无环» R` gives `¬ «俱有» R x y`: G10's net where Z fails, for every net without cycles | cor. | G10 |
| `«类内有常则线相随»` | for `«类» E`, `S` within `E` and constant under 缘: a line under `E` from `u'` is matched from any `u` with `S u' u`, its end `S`-related to the matched end | new (helper) | G15 |
| `«核同则同不穷»` | `«类» E`, `«核» R E y y'` and `«不穷» R E y` give `«不穷» R E y'` | new | G15 |

**Witnesses** (27), so that every family has a net in the core where Z fails. Thirteen were in the reviewed design. The other fourteen were added after the decisions: twelve replace checks, and two are instances of checks that stay. OU's owner confirmed their names on 31 October.

| witness | statement | family | from |
|---|---|---|---|
| the reviewed design's 13 | `«亡而息之例»`, `«两向有常而无前不通之例»`, `«无环而不穷之例»`, `«返而不穷之例»`, `«有限遍后而不返之例»`, `«遍后定前而无环之例»`, `«静分续而有异之例»`, `«非有常之类不含于核之例»`, `«不依之例»`, `«生于核下可变之例»`, `«无始而有终之例»`, `«依于无始而有始之例»`, `«相须之例»` | as in the family table | — |
| `«不有常而通之例»` | on `Option Bool`: `¬ «有常» R «一»`, `«亡» R «静» (some false)`, `«异» R «一» «静» (some false) (some true)` and `«通» R «一» (some true)` | G01, G06 | `check_tong_without_constancy` |
| `«有亡而不全生成之例»` | `«亡» Map.short «一» true ∧ ¬ «全生成» Map.short «一» «静» false` | G02 | `check_short_not_generating` |
| `«步不分而不全生成之例»` | `Map.still () () ∧ «一» () () ∧ ¬ «全生成» Map.still «一» «一» ()` | G02 | `check_still_not_generating` |
| `«生亡并之例»` | on `Unit`: `«生» R «一» () ∧ «亡» R «一» ()` | G08, G13, G16 | `check_end_without_rise` |
| `«亡于静而住于一之例»` | on `Nat`: `«亡» R «静» x ∧ «住» R «一» x` (counting, at one) | G13, G16 | `check_impermanent_continuing` |
| `«无缘不住而他有后之例»` | on `Nat`: `(∀ x, ¬ R x 2) ∧ (∀ E, ¬ «住» R E 2) ∧ «有后» R «一» 0` | G13 | `check_result_without_deed` |
| `«自缘而不生之例»` | on `Unit`: `R () () ∧ ∀ E, «类» E → ¬ «生» R E ()` | G16 | an instance of `check_own_condition_no_beginning` |
| `«有前不有常而亡之例»` | `«有前» Map.short «一» true ∧ ¬ «有常» Map.short «一» ∧ «亡» Map.short «一» true` | G11, G14, G20 | `check_short_end_true`, `check_short_not_constant` |
| `«不有常而不穷之例»` | on `Option Nat`: `¬ «有常» R «一» ∧ «有前» R «一» (some 1) ∧ «不穷» R «一» (some 1)` | G11, G14 | `check_not_constant_yet_endless` |
| `«不穷与亡不同核之例»` | on `Option Unit`: `«不穷» R «一» (some ()) ∧ «亡» R «一» none ∧ ¬ «核» R «一» (some ()) none` | G15 | `check_endless_beside_ending` |
| `«逆核不含于核之例»` | on `Nat`: `«核» («逆» R) «一» 0 1 ∧ ¬ «核» R «一» 0 1` | G15 | `check_converse_core_wider` |
| `«无相而非亦无相之例»` | on `Unit`: `¬ «有相» P ∧ ¬ «有相» (fun x => ¬ P x)` | G18 | an instance of `check_everywhere_no_mark_both` |
| `«无能无所之例»` | on `Unit`: `(¬ ∃ x, «能» R x) ∧ ¬ ∃ y, «所» R y` | G19 | `check_empty_net` |
| `«像不保之例»` | the image of "heavier than" under reversal is not within "hangs lower than" | G22 | `check_reversing_balance` |

Four declarations of the reviewed draft's module are dropped:

- `«亡而续于他类则异»` and `«亡而续于两向有常之类则异通不穷»` are now text, for G01;
- `«两向有常有前则通»` and `«生于逆核下不变»` went below, by the patches.

**The checks module** is `Becoming.GrammarConditionalsChecks`. It stays in scratch. It imports the proposal module and `Becoming.GrammarTesting`, which the proposal module does not reach. Its 17 theorems are compositions of package laws one or two steps long, which the home section states as text. They include the checks the review asked for: `check_stage_eq_inquiry` with its two lemmas, `check_tong_is_unending_bian`, `check_dependence_within_region` and `check_dependence_outside_region`. The reviewed design had 31. Thirteen of them became the twelve witnesses above, and `check_position_core_within_converse_core` became the patch's `«位核含于逆核»`. The checks' names are English, as the package's helpers are.

**Build.** Apply the patches to copies of main's Grammar.lean and GrammarReadings.lean in a scratch tree, and add the two modules. Then run `python3 -B scratch_build.py TREE Becoming.Grammar Becoming.GrammarReadings Becoming.GrammarConditionals Becoming.GrammarConditionalsChecks` from the package folder. The commands are in [kit/patches/README.md](kit/patches/README.md). Nothing is unclean and every axiom report is empty ([BUILD.json](tree/BUILD.json)):

| module | declarations |
|---|---|
| Grammar | 120 |
| GrammarReadings | 18 |
| the proposal module | 41 |
| the checks | 17 |

The proofs use no `simp`, `omega` or `decide`.

## Names

A general law's name states its statement in the grammar's words. Which corpus unit it reads is AI reconstruction, so the reading stands in the law's docstring, marked [AI reading], and in 06's home section, not in the name. A witness keeps `…之例`, with the grammar's words inside. OU's owner decided the names on 31 October, and on the same day confirmed the ones the review's findings changed or added:

| name | why | was |
|---|---|---|
| `«线不返则短于所列»` | the premise is now local to the line (finding 10) | `«无环之线短于所列»` |
| `«不返而有限则非不穷»` | the same | `«无环有限则非不穷»` |
| `«无异当且仅当不分续»` | `F` need not be a class (finding 23) | `«无异当且仅当类不分续»` |
| `«皆不生当且仅当皆非无缘»` | the statement is `¬¬ ∃` (finding 23) | `«皆不生当且仅当皆有缘»` |
| `«生于逆核下不变»` | new (finding 1); by OU's owner's decision it generalizes `«生于位核下不变»` in Grammar, by the patch, under this name | — |
| `«核同则同不穷»` | waited already; carries `«类» E` as `«亡于核下不变»` does | — |
| `«类内有常则线相随»` | waited already; it holds for any relation within the class constant under 缘, not only along the core, and needs no symmetry (finding 13) | `«核下线相随»` |
| `«异而不通之例»` | dropped: it repeated `«有常而不通»` (finding 14) | — |

**Confirmed later on 31 October**: the 14 witnesses added after the decisions ([New Lean](#new-lean-in-scratch)), and the patches' names: `«位核含于逆核»` (the twin of `«位核含于核»`), `«生于逆核下不变»` with `«生于位核下不变»` as its case, and `«两向有常有前则通»` with `«两向有常则通»` as its case. 并 keeps the grammar's sense of "together", as in `«…不并»`.

## Decisions (31 October)

OU's owner decided on the reviewed design:

- **The id.** The item is OU7, with this workspace.
- **Names.** The names the review changed or added are confirmed ([Names](#names)).
- **General laws go below.** `«生于位核下不变»` is generalized in Grammar to the core of the converse net, with the old law as its case. `«两向有常则通»` with a predecessor goes into GrammarReadings in the same rebuild. Both are written as exact patches against main ([kit/patches](kit/patches/README.md)), and OU's owner applies them. The leaf imports both and does not restate them.
- **What lands in the core.**
  - The new laws land: G02, G03, G15 and `«依»`.
  - The witnesses land with them. Step 5 needs a net where Z fails for every family, including the 12 whose laws already exist.
  - Definitional unfoldings and corollaries become lemmas only where a family's "Y 当且仅当 Z" needs them to be stated exactly. Otherwise they are text in the home section.
- **G01's conjunction is not a law.** It goes into 06 as text, and 06's open item is restated.
- **06's home section** gets one table, family by family: Z, Y, the law, the counterexample and the standing. Beside it go the units false as read, the premises and the units not expressible, each with its reason. Step 5 gets one record, with 06 as its home.
- **The checks module stays in scratch.**
- **The doubts stay open** ([Open](#open)), each with its AI-reading label, here and in the home section's open lines.
- **Next.** This part merges with part B's design, which another session is writing. One landing kit then carries the core leaf and the two patches, rehearsed after RV21c lands. No Lean goes to main until OU's owner gives the word for the rebuild slot.

**What changed for them.**

- The leaf now holds only what lands, 41 declarations:
  - `«亡而续于他类则异»` is text;
  - G01's conjunction is text for 06;
  - the patches took `«两向有常有前则通»` and `«生于逆核下不变»` below.
- Fourteen witnesses were added, so that no family's net where Z fails is only a scratch check. The checks module went from 31 to 17.
- G02's standing now reads "sufficient; the converse is not claimed". The design gave no net for "not necessary".
- Once the Grammar patch lands, the OU plan's line 「生只在双向之核下不变」 is no longer exact. A replacement is in the [patches' README](kit/patches/README.md#texts-that-name-the-two-laws), for the plan's owner.

**Later on 31 October.**

- Every name is confirmed: the patches' and the 14 witnesses'.
- The OU plan's replacement line is accepted. It goes into the same landing as the Grammar patch, as [PLAN.patch](kit/patches/PLAN.patch).
- Once part B's review is in, the two parts go on one branch as one landing kit. It holds:
  - the leaves;
  - the Grammar and GrammarReadings patches;
  - the record or records, with the home table in 06;
  - the PLAN.md edit;
  - the study section;
  - a land script in stages, on the pattern of U1b's (`development/u1-balance-under-units/u1b/land_u1b.sh`, landed with U1b).
- The grammar's owner's held items from HE2 and BD2 join the same rebuild, as patches in the kit: the GrammarLaws header now ([01-GrammarLaws-header.patch](kit/patches/owner/01-GrammarLaws-header.patch), comments only); `«不出»` into GrammarLaws and `Flow.Cut` once BD2 has landed.
- The near-full rebuild comes last in the core round, after UE26, BD2, EL and UE27. No Lean is run for it until OU's owner says, and a rehearsal stays in a scratch tree.
- Part A's pieces of the kit are drafted ([kit](kit/README.md)). They are:
  - the leaf, moved into the kit;
  - 06's home section in Chinese;
  - the record's text and its maker;
  - an integrate script and a land script in stages, on U1b's pattern, with HE2's re-point.

  They were checked in Python only, on main at 8a1b06a3a.
- Part B's pieces are joined to the kit's scripts and read where its review left them (`check/kit/`, `check/scratch/Becoming/`). They are:
  - its two leaves and their joins, after RegimeMargin's, with Chinese README rows and scope sentences written for them;
  - its record's maker, [make_record_ou7b.py](kit/make_record_ou7b.py);
  - its home section in 03 §3, its GrammarTesting clause and its register entries.

  The notes saying what imports MapRegions, GrammarTesting, GrammarReadings and HeldPossible change with the leaves' imports. A dry run of both parts ([dry_run.py](kit/dry_run.py)), in Python only, passed on main at 753460b81.

**1 November.** The choices left open are now decided in the kit, each with its reason ([kit README](kit/README.md#decided-on-1-november)):
- each general law is stated where the law it generalizes is, and OU7's record binds only its leaf;
- part B goes in the instance ring;
- MapRegions is no longer called a leaf: a fourth patch changes its doc, comments only, and the record stage corrects one record's words;
- GrammarReadings' note and scope sentence state the general law;
- the toy's line in 03 §3 points to its derivation.

BD2 landed the same day (f1ea9546d). The grammar's owner's three items held for it are now patches in the kit, as OU's owner specified them on 1 November ([kit/patches/README.md](kit/patches/README.md#the-grammars-owners-patches)); what was held is kept in [kit/patches/history/HELD.md](kit/patches/history/HELD.md):
- `«不出»`, `«闭则不出»` and `«所闭不出»` move unchanged from GrammarCrossing into GrammarLaws, after the closure law `«所闭之界»`, whose docstring says that `«所闭不出»` is it read through `«不出»`;
- `Flow.Cut` is defined as `«不出»` at the valuation's relation, its old body unfolded, and `Flow.cut_iff_notGoingOut` holds by definition;
- BD2's two equivalences read a region not crossed as one not gone out of either way and as one closed both ways, so the two count laws read as one law (master-laws-on-the-grammar's law 4 and 01 §7, with a history note).

The rehearsal of the owner's patches built them with GrammarPath, BalanceRegions and four name checks, 53 modules, nothing unclean, every axiom report empty ([kit/REHEARSAL.json](kit/REHEARSAL.json)). The first rehearsal built the kit's own patches and the three leaves, 145 modules ([kit/history/REHEARSAL.json](kit/history/REHEARSAL.json)). A dry run of the whole kit passed on main at a91c84d35. The rebuild still comes last in the core round.

Other items ride in the same rebuild as stages of the kit ([kit/stages/README.md](kit/stages/README.md)): U4c's census laws, then ND's names, each its owner's patch series, applied patch by patch after the kit's joins. A stage that is empty or does not apply stops `apply`, nothing of it written; a skipped stage leaves OU7 to land without it (R10). The audit and the register take each stage's expectations, and the re-point is one pass for all.

## Open

Each item below is an AI reading. Each stays open, with this label, here and in the home section's open lines.

**Read in the corpus, 5 November 2026 (board item RAE3, AA's E26).** A note, not an edit of the items below: G22, G15 and G01 were read in the corpus and the home section states the result (06-CLASSICAL-TEXTS §四 and its 未决). G22: by Xunzi's own sentence 衡不正 reverses the pair weighed (杨倞's gloss, outside the corpus, reads it otherwise); the unit stays definitional. G15: the 起信论's accord sense of 相應 is read as one class of the forward core, by fit; whether 無明 is among its 煩惱染法 the text does not settle, and the carry-over to JS-324 fails either way, so JS-324's row below no longer rests on it. G01: which 變 the text means it does not settle. Each is `[AI reading, new]` there.

**A correction, and the sentence's own place, 6 November 2026 (board item RAE5, ED4's classical reader's E4C-01, E4C-02, E4C-20 to E4C-55).** A note, not an edit of the items above or below, which stay this design's text of their dates. Where they say 通 is not reached through 变, that the three are a conjunction, or that there is no order to find, they are wrong: what has ended passes through under another class only by altering (`«亡而通则异»`), altering gives passing through under that class constant both ways, a sufficient premise the text does not state (`«异而两向有常则通»`, `«不有常而异且通之例»`), and for what has ended, under it, having a successor, altering, passing through and never ending going are one (`«有后而两向有常则通»`, `«亡而两向有常则异当且仅当通»`), with the nets `«异而不通之例»` and `«通而不异之例»`. The grammar gives implications, with no order in time; each step with only its own premise need not reverse. What survives is that what has not ended under the parting class can pass through unaltered, that the parting does no work in the step to 通, and, for what has ended with the premises joined, that the four have no direction among them. Short derivations; the design missed them by reading «两向有常有前则通»'s 不论其异否 as if it spoke to what has ended, where every continuation under the second class is an alteration. RAE3's reading of G01 weighed the commentators where they use 易窮則變 elsewhere and left out its own place, 系辞下, whose 注疏 the corpus does not hold. Read from an electronic copy of 《周易注疏》 (四库全书本, Wikisource revision 9685969, kept in `review-packet/editions/`; not collated with a print), 孔疏 there states the order with a reason and reads change at the limit, as its gloss on 通其變 above it does, and its example at 上十二 runs from 亢 to 通. Under alternation at every step every place has ended under the parting class (`«步皆分则皆亡»`), so 窮 holds everywhere and selects no place. So RAE3's 文本不能定, as a balance, does not stand: the text does not say whether 窮 lies at the limit or at every step, and the glosses lean. Change at the limit need not be once: the 疏 has 隨時 and 日新. The 音義 there records a recension without 變則通, so the step from 變 to 通 is the received text's. `data/groups.tsv`'s rows for XCX-02-008, QXL-JS-326, XZ-ZM-164 and XZ-ZM-165 still gave the readings as they stood before RAE3, and now give §四's; no group, disposition or count changed.

- **G22** [AI reading]: does 衡不正 reverse the balance, or only fail to keep the order? If it reverses, the unit is definitional (`«保之像»`, with `«像不保之例»` as its net). If it only fails to keep the order, 重縣於仰 does not follow. The corpus gives no commentary.
- **G15, JS-326** [AI reading]: is 相應 lying in one class of the core? A survey of the 起信论's uses of 相應, JS-318 among them, would settle it.
- **G15, JS-318** [AI reading]: is 無明 among its 煩惱染法? If it is, JS-318 denies the premise that JS-326's reading uses. The 起信论's 熏習 sections would settle it.
- **G01, 06's open item, restated** [AI reading]: which 變 does the text mean? Read as one alteration, 變 gives no order 穷 → 变 → 通 to find. Read as 一闔一闢, the step to 通 is definitional.

## What this design does not do

- No package file changes: the patches are diffs in the kit, for OU's owner to apply in the rebuild slot. Part B is untouched.
- It does not say what any text means. A reading stands or is revised by its place in one account, and each reading here keeps its AI label. The classifier's confidence is kept: a 低 unit in a family is the family's weakest evidence that the law is the text's.
- The 181 乙 candidates of the three added texts (06 §四) are outside OU7.

## Review

One independent review of the first draft (committed at 40118c083) read the design, the data, the scratch Lean, the package and the corpus. Its report is kept verbatim in [review/FINDINGS.md](review/FINDINGS.md), and its scratch Lean in [review/ReviewChecks.lean](review/ReviewChecks.lean). The report found 24 problems: 5 blocking, 6 that should be fixed and 13 minor. It also checked these and found them sound:

- the counts;
- the build and the audit;
- every existing theorem the draft cited;
- the links.

All 24 were taken. The table gives the names of the reviewed revision (2d896554a). Some checks it names have since become witnesses, or the Grammar patch's `«位核含于逆核»` ([New Lean](#new-lean-in-scratch)).

| # | finding | how it was taken |
|---|---|---|
| 1 | Blocking. G15's asymmetry between 前際 and 後際 is false: a beginning is kept along the core of the converse net, which is not within the two-way core, and like for like the two sides mirror each other. | G15 is restated as four mirrored statements, and `«生于逆核下不变»`† is added. The words "only" and "not symmetric" are gone. JS-324 is false as read through dependence, with JS-318 cited. The four review checks are carried into the checks module, with `check_endless_beside_ending` added. An offer goes to Grammar's owner. |
| 2 | Blocking. G01: the Lean gives no order from 變 to 通, so "exactly" and "closes 06 未决" overclaim, and two-way constancy is not necessary. | The conjunction is stated as a conjunction. "Exactly" and "closes" are gone. The text says 變 does not enter 通 on that reading. XCS-11-009's 變 is checked (`check_tong_is_unending_bian`). `check_tong_without_constancy` shows constancy is not necessary. 06's open item stays open, and the conjunction is recommended not to land. |
| 3 | Blocking. G08 gave no statement in the grammar for 10 of its 13 units. | The nine production, sufficiency and 所緣 units went to not expressible under rule 4. QXL-JS-214 went to G09 as a dependence on a second kind of condition. |
| 4 | Blocking. G16 read ZL-01-099 backwards, and 斷 was used in two senses. | ZL-01-099 is false as read (`check_unconditioned_not_abiding`, with the lone occurrence ending). ZL-17-051 is read on its own terms, false as read (`check_result_without_deed`), in G13. 斷 has one sense in G13 and G16. ZL-02-070 is false as read (`check_own_condition_no_beginning`). |
| 5 | Blocking. G21's XZ-ZM-044 states the converse of `«可分则不在核»`. | XZ-ZM-044's law is the converse under its premise (`check_telling_apart_needs_a_stage`). `«致诘不尽»` is where the premise fails. XZ-ZM-043 is a premise along `«而»`. |
| 6 | Several "new" laws were definitional unfoldings or one-line compositions. | Every law carries its depth. Only G02, G03 and G15 (with `«依»`) count as new. An offer goes to GrammarReadings' owner. |
| 7 | The method statements did not hold: groups held several laws, some countermodels were not of the stated kind or lived in the package, and G12 had none. | Groups are now families of several laws. Every law names a net where Z fails and Y fails, and package declarations are allowed. G12 is dissolved. G14 uses `true` (`check_short_end_true`). G18 states that Y fails (`check_everywhere_no_mark_both`). G19 uses the empty net (`check_empty_net`). The gate is left to OU's owner. |
| 8 | Some units stated another law's conditional, or inverted this one. | Moves: CWS-P3-074 to not expressible; G12's units to G09 (QXL-JS-058, -167) and G13 (ZL-02-091); ZL-10-043, QXL-JS-086 and ZL-17-013 to not expressible; ZL-02-070 to G16; LZ-63-004 to not expressible; QXL-JS-012 and -252 to G09 under rule 5. G13 lists `«住亡不并»`, `«断则无相续»` and `«住因于续»` as its own laws. ZL-21-113 and CWS-P6+P7+P8-020 are false as read. QXL-JS-123 is read as temporal, on a region. |
| 9 | Some dispositions broke the design's own rules. | Five rules are written in the kit and applied to every unit. QXL-JS-195 went to 丁. CWS-P6+P7+P8-043 is placed by its structural clause, with its 丁 part noted. LZ-39-001/-002, XCS-06-004/-005, LZ-23-002 and LZ-63-004 went to not expressible. XZ-ZM-016 stays a premise, its Z being the fixing of names, not a ruler. Under rule 1, LZ-33-005, LZ-07-002 and LZ-36-001…004 went to not expressible and LZ-22-001 stays 丁. CWS-P1-030 is split under rule 2. |
| 10 | More overclaims in the prose. | The prose now says "相推 gives 全生成". G03's laws are local to the line. On 早已, no end is exhibited. G04 cites `«线有限不并则返»`, which gives `«及» R x x`, not `«复»`. G05 says "parts no continuation's ends", and its 息 is not the grammar's `«息»`. G09's region premise is stated and checked, and "within the region" replaces "co-present". |
| 11 | Provenance. | The 韩注 quotation for G07 is dropped, since it is in no source. "OU6's candidates" is now the candidate theorems (GrammarCandidates, landed with OU2c in 706b80293). The board-id clash is noted at the top. |
| 12 | The witness count was wrong. | It now reads 13, after `«异而不通之例»` was dropped. |
| 13 | "Symmetric" was claimed of the line-matching helper. | The docstring is fixed, and the helper is renamed `«类内有常则线相随»`. |
| 14 | Two witnesses did not state that Z fails. | `«有限遍后而不返之例»` states ¬`«定前»`. `«异而不通之例»` gave way to `«有常而不通»`. |
| 15 | `«相须之例»` was degenerate (the joint class was equality). | A three-bit witness replaces it, and its joint class puts two distinct points together. |
| 16 | `«依于无始而有始之例»` depends on `E` telling the kinds apart. | Its docstring says so, and `check_kinds_told_apart` checks it. |
| 17 | G20 loses the difference between perceivers and percepts. | The loss is stated under G20. |
| 18 | G21 mixed `«层»` and `«诘»`. | `check_stage_eq_inquiry` shows they are one relation at every stage. |
| 19 | LZ-28-006's generative reading was lost and not listed. | It is listed under G17. |
| 20 | G24's false law is `«亡»` → `«有前»`, not G03's converse. | G24 is dissolved. Its units went to not expressible under rule 1, and the structural false reading is noted. |
| 21 | "Alters" pointed opposite ways. | `«异»` now names its two classes everywhere: `«异» R F E` in G01 and `«异» R E F` in G05. |
| 22 | Some readings in groups.tsv did not fit their unit. | LZ-39-002, QXL-JS-123 and JSZ-P-07-032 are reread. |
| 23 | Names used corpus words, or said more than the statement. | OU's owner renamed them on 31 October. `«亡而息之例»` states `«息»`. The ¬¬ and the "not a class" names are in the table above. `«依»` is to be checked against the registered one-way 所依. |
| 24 | Readings carried only a blanket AI label. | Every reading in groups.tsv carries "[AI reading]". |

**What the review moved.** 40 units changed family or disposition:

- 25 went to not expressible;
- 1 went to 丁;
- 6 became false as read;
- 7 moved between families;
- 1 law became a premise (XZ-ZM-043).

Each is listed in [groups.tsv](data/groups.tsv). The kit's earlier output is in git at 40118c083.

**Doubts not settled.** They are in [Open](#open), each with its AI-reading label.

## Files

- [data/units.tsv](data/units.tsv): the 219 丙一 rows, with their classification fields.
- [data/groups.tsv](data/groups.tsv): each unit's family, disposition and labelled reading.
- [kit/assign.py](kit/assign.py): writes groups.tsv from units.tsv, states the dispositions and rules, and checks that every unit is placed once.
- [kit/patches/](kit/patches/README.md): the patches for Grammar, GrammarReadings and MapRegions and the OU plan's edit, what each changes, and how to check them; the grammar's owner's patches and the items held until BD2 lands.
- [kit/](kit/README.md): the landing kit, both parts. It holds the core leaf ([kit/Becoming/GrammarConditionals.lean](kit/Becoming/GrammarConditionals.lean)), the patches, 06's home section, the records' makers, and the integrate and land scripts. It says what has been checked, what was decided and what waits.
- [tree/Becoming/GrammarConditionalsChecks.lean](tree/Becoming/GrammarConditionalsChecks.lean): the checks, which stay in scratch.
- [tree/BUILD.json](tree/BUILD.json): the build of the patched modules with both scratch modules.
- [review/](review/): the independent review's report and its scratch Lean.

## Corrections of 3 November 2026

Independent readers of the classical and Buddhist dossiers found three sentences that said more than the study shows. The chapter, the table's row and the record were corrected on the dossiers' re-sync; the text above stays as designed.

- **ZL-17-051.** "A result with no deed among its conditions abides under no class" is not what `«无缘不住而他有后之例»` states: its result has no condition at all, and a result with another condition can abide. The witness shows only that such a line need not be 常 or 斷.
- **JS-318.** "Denies the premise JS-326's reading uses" reads as undermining JS-326, whose premise is about 涅槃. JS-318 is about the 染法: if 無明 is among them, 無明 never 相應 with 如來藏, so JS-326's reading cannot be carried over to JS-324.
- **The 219.** Only the 128 units in families are written as laws; the chapter's opening and home section had said it of all 219, where the record's statement already said 128.
- **LZ-30-008, left as it stands.** Rule 1 says a structural reading against the commentary is noted, not placed. This unit is placed, with 王弼's 暴 not read, and under his note it looks not expressible like LZ-23-002, which that note cites. No count was changed: the classical dossier's C-39 now says so and asks the reader.
