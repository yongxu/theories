# 易传与生成／变化之论：周易的构形在脊柱上

2026年10月19日。回应 Ren 的提问与要求（[原话](../../../sources/15-codex-theory-conversations/2026-10-19-the-changes-on-the-spine.md)）：我们的工作与周易、尤其易传的关系能否看见、能否建立；建立起来，成为库的一部分，在脊柱上有明确的对应。本章由 AI 撰写；Ren 的原话另存，是来源，不是任何主张的根据。表中与正文的每一条读法都是 AI 读法，依 [D47](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d47-易传在脊柱上的读法--the-readings-of-the-yi-zhuan-on-the-spine) 、[D50](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d50-爻位之关系的读法--the-readings-of-the-relations-of-the-places)、[D51](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d51-卦之诸律的读法--the-readings-of-the-hexagram-laws)、[D53](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d53-初上无位与独应之读--the-readings-of-the-fixed-places-and-the-sole-line) 与 [D55](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d55-传中诸排列之读--the-readings-of-the-arrangements-of-the-傳) 在理论的一个说明之中成立或修改。

**建成了什么。** 一是周易所描述的构形本身：六爻、每爻刚柔二值、一爻之变、消息之律、所传卦序，作为脊柱上的一个世界写入纯核心模块 [`Becoming.Hexagrams`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Hexagrams.lean)（71 条定理，无公理），脊柱对一切世界证明的律在这些构形上被检查，而不只是被断言。二是爻位之间的关系：正、应、比（承、乘）、中，作为在位上成立、带语境索引的读法，写入纯核心模块 [`Becoming.HexagramPlaces`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramPlaces.lean)（108 条定理，无公理），并证明它们在错、综、一爻之变与消息之律之下怎样变，诸律都在脊柱的运行上读出（§2）。三是另外四条律与消息之律的普查：互、老少之爻与之卦、錯綜四对称、加一之律，以及消息之律的六条轨道，写入纯核心模块 [`Becoming.HexagramLaws`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramLaws.lean)（130 条定理，无公理），诸律也在脊柱的运行上读出（§2）。四是王弼《周易略例》之读：初、上两位无定位，作为二至五位上的第二个关系；一爻与其余五爻皆相应（独应），作为一爻与其余诸爻之关系；两者写入纯核心模块 [`Becoming.HexagramSites`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramSites.lean)（103 条定理，无公理），王弼于《辯位》所举之两难在其上证明，诸律也在脊柱的运行上读出（§2）。五是传中诸排列何者是律：所传卦序、卦变、阳爻之数的奇偶、杂卦与说卦第五章之八站，写入纯核心模块 [`Becoming.HexagramSequences`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramSequences.lean)（98 条定理，无公理）：卦序是一个律的运行，但运行它的律只能是一张表，每一爻皆读每一爻，不与任何对称交换；卦变是上下两卦之间交换律的一步；阳爻之数的奇偶是律所同行的归并；杂卦保留同样的三十二对；诸律也在脊柱的运行上读出（§2 末）。六是逐句对应：易传、经文、两种注疏与王弼《周易略例》的 90 段文字，逐字取自保存下来的维基文库版本，每段标明它与理论的关系（相合 51、定域 27、相分 12）和它对应的脊柱声明（相合的 51 段中，33 段只经卦的编码上的事实，8 段经一般律，10 段兼有；律的层次由校验脚本算出）；序卦、杂卦、说卦与彖中言排列的其余段落，在[中国思想章](CHINESE-SOURCES-AND-BECOMING.md)的对应中，引自其所存之文；另有十二项普查，把彖、小象、爻辭与大象中某类关于位或中的明言逐一找出，在其卦上检查。七是检查：[`verify_mapping.py`](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/y1-changes/verify_mapping.py) 核对每段文字在所存版本中逐字出现、每个声明在核心检查的审计清单之中、卦序与所存六十四页逐卦一致、所命名之卦与其页一致、各项普查与 Lean 的清单或脚本所记之例外一致、模块所列杂卦之序与所存杂卦逐卦一致、模块之八站与说卦第五章一致、本章的对应表与对应文件一致。结果记录是 [hexagrams-on-the-spine](../results/records/hexagrams-on-the-spine.md)、[place-relations-in-context](../results/records/place-relations-in-context.md)、[hexagram-world-laws](../results/records/hexagram-world-laws.md)、[fixed-places-and-sole-lines](../results/records/fixed-places-and-sole-lines.md) 与 [hexagram-arrangements-and-laws](../results/records/hexagram-arrangements-and-laws.md)。

**没有建成什么。** 这不是对周易整体的解释，也不说易传作者意谓这些律。吉凶悔吝的判断、说卦的取象与八站所配之时与方、三材的指认、序卦为卦序所给的理由（模块只证明何种律运行卦序）、位的尊卑、卦主之“治”、占筮与数术，都不在模块之中；相分之处保留为相分。

## 1. 文本与版本

文本取自中文维基文库，2026年10月19日经 MediaWiki 接口取得，原样保存在 [`sources/zhouyi-yizhuan/`](../../../sources/zhouyi-yizhuan/PROVENANCE.json)，每页记有版本号、版本时间与 SHA-256。这是带标点、分章的电子版，不是影印本，未与任何刻本对校；章次依此版。版本中的繁简异体标记（`-{无}-`）在读时去掉。

| 篇 | 维基文库页面 | 版本号 | 版本时间（UTC） |
|---|---|---:|---|
| 繫辭上 | 易傳/繫辭上 | 2611140 | 2025-11-02 |
| 繫辭下 | 易傳/繫辭下 | 2611136 | 2025-11-02 |
| 序卦 | 易傳/序卦 | 2611127 | 2025-11-02 |
| 說卦 | 易傳/說卦 | 2614055 | 2025-11-09 |
| 文言 | 周易/文言 | 2615215 | 2025-11-11 |
| 六十四卦（卦辭、爻辭、彖、象，乾坤含文言） | 周易/乾 至 周易/未濟，循每页的“下一卦”链接 | 各页见清单 | 2022-02-16 至 2026-09-27 |
| 孔穎達《周易正義》 | 周易正義/10 | 2384519 | 2024-04-01 |
| 王夫之《周易外傳》卷五 | 船山遺書/周易外傳卷五 | 2633077 | 2025-12-14 |
| 王弼《周易略例》（目录） | 周易略例 | 1381183 | 2018-03-10 |
| 明彖 | 周易略例/明彖 | 2201353 | 2022-12-11 |
| 明爻通變 | 周易略例/明爻通變 | 1161705 | 2017-07-22 |
| 明卦適變通爻 | 周易略例/明卦適變通爻 | 194050 | 2009-02-13 |
| 明象 | 周易略例/明象 | 389845 | 2013-07-30 |
| 辯位 | 周易略例/辯位 | 194052 | 2009-02-13 |
| 略例下 | 周易略例/略例下 | 194053 | 2009-02-13 |
| 卦略 | 周易略例/卦略 | 194054 | 2009-02-13 |

王弼《周易略例》八页于同日 08:40（UTC）以同一接口取得。此版于王弼之文的段落之后附邢璹之注，只有明彖以模板 `{{yw|…}}` 标出王弼之文（读时去掉模板）；本章所引皆王弼之段，邢璹之注只在一处读法中提及。此版“云”作“雲”、“繫辭”作“系辭”，略例下“為兌之主”作“為為兌之主”，引文照录。

## 2. 卦的世界

模块所写的，都是经文本身描述的结构；它对每一种结构证明的，是脊柱对一切世界证明之律在此的实例，或是有限的计算。

- **六十四种构形。** 一卦是自下而上的六爻，每爻为阳（刚，`true`）或阴（柔，`false`）（`Hexagram`、`Hexagram.line`）。相等与属于逐爻判定，不用任何公理（`eqb`、`mem_of_memb`）。所传卦序由各卦的下卦、上卦逐一写出（`order`），长六十四，含全部构形（`order_length`、`mem_order`）；两两成对，每对之后一卦是前一卦倒转，倒转不变者则六爻皆变（`order_paired`），即孔穎達所说“非覆即變”。检查脚本另行核对：卦序第 n 项的六爻，正是所存第 n 页“X下Y上”所给的六爻。
- **一爻之变。** 一步把一个位置上的爻变为其反（`flip`、`changes`）。任一构形可由任一构形得到（`reach_every`），每一构形皆复返（`changes_returns`），不失任何可能，而过程有合并（`changes_merges`、`changes_keeps`）：在历程分叉之处，复返不等于不合并（`Branching.keeps_of_returns`）。
- **消息之律。** 每爻升一位，上爻出而以其反入初位（`waxWane`）；逆行则每爻降一位（`unwaxWane`）。此律不合并（`waxWane_lossless`），所以依 `Law.lossless_iff_returns`，每一构形皆复返（`waxWane_returns`）。六步之后六爻皆变，即至错卦（`six_steps`、`run_six_steps`）；十二步之后复得原卦（`twelve_steps`）。自坤起，阳爻自下逐步而上：坤、復、臨、泰、大壯、夬、乾（`waxing`）；自乾起，阴爻同样自下而上：乾、姤、遯、否、觀、剝、坤（`waning`）。这就是十二消息卦之环：坤首次复至坤在第十二步（`first_return`），自乾第七步一阳复生为復（`seventh_step`）。它只是此律的一轨：隨四步即返而两步不返（`fourth_step`），其轨为隨、中孚、蠱、小過。
- **有合并之律。** 若上爻出后入初位的只是阴爻（`wane`），律便合并：剝与坤都走到坤（`wane_merges`）。六步之后一切皆坤（`wane_six`），律不再离开坤（`allBroken_absorbing`），其他构形都被吸入、永不回来、不复返（`wane_drawn`、`wane_never_back`、`wane_not_returns`），可能有所永失（`wane_loses`）。对六十四卦上的一切律，每一构形皆复返，恰当此律不合并（`every_returns_iff`）。
- **对称与读法。** 律与错（六爻皆变）交换（`waxWane_complement`），倒转一卦则律逆行（`reverse_wax`、`reverse_waxWane`）。把一卦与其错卦合为一对，是律在其上同行的归并（`pairs_lumped`、`pairs_goAlike`，经 `Learning.goAlike_iff_lumped`）；按阳爻之数归并则不是（`yang_not_lumped`、`yang_not_goAlike`）。
- **爻作为主张、框架与世界。** 沿律读之，某位之主张实现，恰当该位之爻为阳（`lines`）。沿律的每一运行，某爻在任意晚的步上转为阳（`arising_recurs`），依 `Frame.claims_recur_iff` 也在任意晚的步上止于阳（`ceasing_recurs`）；读作此框架的世界，诸位在任意晚的步上生起与止息（`world_arising_recurs`、`world_ceasing_recurs`）。
- **在六十四之内往下走。** 任一过程下，任一运行的前六十五个状态中必有重访（`revisits_within_order`），一爻之变的每一运行从每一步往后都有重访（`changes_run_revisits`）；而带着历史的律不被任何清单所含（`kept_history_unlisted`）。

### 爻位之间的关系：在位上读

以下声明在 [`Becoming.HexagramPlaces`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramPlaces.lean)，前缀 `Becoming.Hexagram.`。

- **位与其所在。** 一卦有三个高度（初与四、二与五、三与上）、两卦（下卦、上卦），每一位是一卦之一高度（`Height`、`Half`、`place`、`heightOf`）；相邻两位相接于一缝（`Seam`、`below`、`above`）。六位奇偶相间，每一缝两侧奇偶相反（`odd`、`odd_above`）。
- **四种关系。** 爻之值与其位之奇偶相合，为正、当位：奇位阳，偶位阴（`inPhase`）。同一高度上下两爻相异为应，相同为敌应（`opposed`）。相邻两爻相异为比（`alternates`）；自下而上，阴下阳上为承（`rises`），阳下阴上为乘（`falls`）。中是两卦的中之高度，即二、五两位（`middle`）。
- **在位上成立：带语境的读法。** 这些关系都在一位、一高度或一缝上成立，不是一爻孤立的性质，所以写作脊柱上的语境读法（`Contextual`）。一关系在其各处所示，是对一个主张（整卦）的语境读法（`atSites`）；它粘合为对整卦的一个读法，恰当各处所示相同（`atSites_glues_iff`）。各位之正只在既濟、未濟粘合（`phases_glue_iff`）；各缝之比只在乾、坤、既濟、未濟（`seams_glue_iff`）；各高度之应只在三处皆应（上下卦互为错卦）或三处皆不应（重卦）之处（`oppositions_glue_iff`）。把上下两卦读作两个语境，每卦示其各高度之爻（`halves`），两卦粘合恰当没有一个高度相应（`halves_glues_iff`）：应正是两个语境在一个高度上所示相异之处，这一高度之爻在两卦中是两个主张。所以没有去语境的框架在任何过程之下合于诸高度，带语境索引的框架则合（`halves_no_free_frame`、`halves_indexed`，经 `Contextual.fitsFree_iff` 与 `Contextual.indexed_fits`）。
- **应由正而定。** 同一高度的两位奇偶相反，所以两爻相应，恰当二者同正或同不正（`opposed_iff_phase`）：两个中位皆正，则中之高度相应（`middle_phase_opposed`）；六爻皆不正或皆正，则三处皆应（`out_of_phase_opposed`、`in_phase_opposed`）。居中之阳爻有应与居中之阴爻有应，所指是同一些构形，即中之高度相应（`middleUnbrokenOpposed_eq`、`middleBrokenOpposed_eq`）：一个关系，从其两端读。
- **在错、综与一爻之变之下。** 错使每一爻之正翻转，保持每一处应与比，交换承与乘（`inPhase_complement`、`phaseCount_complement`、`opposed_complement`、`alternates_complement`、`rises_complement`）；综在镜像之处作同样的事（`inPhase_reverse`、`phaseCount_reverse`、`opposed_reverse`、`rises_reverse`）。一爻之变翻转该位之正与其高度之应，其余不动（`inPhase_flip_self`、`inPhase_flip_other`、`opposed_flip_self`、`opposed_flip_other`），当位之数增或减一（`phaseCount_flip`）。
- **在消息之律之下。** 每爻带着其值跨过一缝上升（`line_waxWane_above`），所以每升一位其正即翻转，只在上爻以其反入初位之处保持（`inPhase_waxWane_above`、`inPhase_waxWane_bottom`）。一步前后的当位之数相加为五，上爻当位时为七（`phaseCount_waxWane`），所以当位之数每一步都改变奇偶（`phaseCount_parity`、`phase_parity_along_run`）；自乾十二步依次为三、二、三、二、三、二、三、四、三、四、三、四（`phase_qian_orbit`）：阴爻上升时在三与二之间，阳爻上升时在三与四之间，既不到六，也不到零。当位之数不是律所同行的归并：乾、坤各有三，下一步分别为二与四（`phaseCount_not_lumped`、`phaseCount_not_goAlike`）。比随其两爻而行（`alternates_carried`、`rises_carried`、`falls_carried`）。三个高度之应也随其两爻而行，到绕回之处翻转：它们服从三格上的同一个消息之律（`opposition_waxWane`、`waxWane3`），所以是律所同行的归并（`opposition_lumped`、`opposition_goAlike`）。三步使每一处应翻转（`opposed_three_steps`），六步复原（`opposition_six`）；八种应之格局中，六种成一个六步之环，经过三处皆应与三处皆不应（`opposition_cycle`、`waxWane3_moves`），另两种（初四与三上应而二五不应，或反之）两步即返（`opposition_two_iff`）。重卦三步之后三处皆应（`halves_glue_three`）：乾三步至否，坤三步至泰。
- **承与乘。** 承之数加初爻，等于乘之数加上爻（`rises_falls_ends`）：自下而上，阳之起与落的次数只差首尾两爻。
- **沿展开读。** 以上诸律都在脊柱的运行上读出，不只是构形的性质。各位之正、各高度之应、各缝之比，在任何过程之下都没有去语境的框架与之相合，带语境索引的框架则合（`phases_no_free_frame`、`oppositions_no_free_frame`、`seams_no_free_frame`、`atSites_indexed`）。沿消息之律的每一运行（`Law.run`），每爻上升时其正翻转（`run_phase_rises`、`run_phase_enters`、`run_phaseCount`），比随其两爻而行（`run_carried`）；六步之后每一爻之正皆翻转，而应由正而定，所以每一处应皆保持（`run_six_turns`、`run_six_keeps`）；三步之后每一处应皆翻转（`run_three_turns`、`run_doubled_three`）；应之格局每一步都变，两步复得恰在两种相间的格局，自三处皆应六步一周（`run_opposition_moves`、`run_opposition_two_iff`、`run_opposition_cycle`）。沿一爻之变的每一运行，每一步翻转所变之爻的正与其高度之应，其余不动（`changes_run_phase`、`changes_run_opposition`）。倒转消息之律的运行，即是自倒转之卦逆行的运行，其上每一关系皆在镜像之处（`backward_run`、`backward_relations`）。任一过程的运行在任一步所示之卦，应皆由正而定（`shown_along_run`）。
- **经文所说的构形与四项普查。** 逐句对应所引之卦，以其在所传卦序中的序数命名（`number`、`jiJi` 等；检查脚本核对其名与所存之页），经文所说其爻位之关系在其上检查（`jiJi_inPhase`、`weiJi_opposed`、`heng_opposed`、`xian_opposed`、`gen_halves_glue`、`tongRen_second`、`xiaoXu_fourth`、`daYou_fifth`、`guiMei_falls`、`guai_falls`）。四项普查列出经文中一类明言的全部：小象明言位者（`placeStatements`）、言中正或正中者（`centreStatements`）、言乘刚者（`fallStatements`），彖言剛中而應者（`middleOppositionStatements`）。检查脚本在所存六十四页中找出每一处，与 Lean 的清单比较；Lean 在其卦上检查清单的每一项（`placeStatements_agree`、`centreStatements_agree`、`fallStatements_agree`、`middleOppositionStatements_agree`）。经文与关系相分之处，构形如其所是地写出（`xu_top_inPhase`、`gen_fifth_out_of_phase`）。

### 互、之卦、錯綜、加一与消息之六轨

以下声明在 [`Becoming.HexagramLaws`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramLaws.lean)，前缀 `Becoming.Hexagram.`；诸律都写在脊柱的运行上（`Law.run`、`Law.process`）。

- **互。** 互以二、三、四爻为下卦，三、四、五爻为上卦（`nuclear`）。互之所成由中爻（二至五爻）定（`nuclear_inner`），所以起点中爻相同的两个运行自第一步起即为一个运行（`run_inner`）；初、上两爻一步即失：此律合并，永失一种可能（`nuclear_merges`、`nuclear_loses`）。两步之后只余三、四两爻，三叠成卦（`nuclear_two`、`run_two_middle`）。三、四两爻每步互换，是律所同行的归并（`innerPair_goAlike`）；阳爻之数不是：剝与比阳爻皆一，互之后一为坤、一为剝（`nuclear_yang_not_goAlike`）。
- **互所归。** 乾、坤不动，既濟、未濟相代（`nuclear_two_fixed_one_cycle`）；运行停在起点，恰当起点为乾或坤（`nuclear_rests_iff`）。每一运行自第二步起在此四者之中，不再离开（`nuclear_two_attractor`、`attractor_absorbing`、`run_in_attractor`），其余构形皆被吸入而不复返（`outside_drawn`、`outside_not_returns`，经 `Law.Drawn.not_returns`），所以恰此四者复返（`returns_iff_attractor`、`nuclear_process_returns_iff`）：它们恰是所传卦序的首二卦与末二卦（`process_returns_iff_ends`）。四卦本在其中，十二卦第一步进入，四十八卦第二步进入（`entry_counts`）。归于何处由三、四两爻定：两爻皆阳者十六卦归乾，皆阴者十六卦归坤，相异者三十二卦入既濟、未濟之相代（`basin_iff`、`qian_basin`、`kun_basin`、`cycle_basin`、`basin_counts`、`run_rests_at`）。与消息之律（不合并，皆复返）、只入阴爻之律（尽归坤）并列，这是第三种形态：两个不动之卦加一个二步之环。
- **錯綜四对称。** 不变、錯、綜、錯而綜（`Symmetry`、`Symmetry.act`）成一四元群：各为自身之逆，两两可交换（`Symmetry.act_comp`、`Symmetry.comp_self`、`Symmetry.comp_comm`）。互与四者皆交换（`nuclear_act`），故四者各把互的每一运行送为互的运行（`nuclear_run_act`，经 `Law.Commutes.iterate`）；錯移动每一构形，没有构形是自身之錯（`complement_moves`），所以一卦与其錯卦的运行永不相遇（`run_complement_apart`，即交换之律所保持之分离 `Law.Commutes.apart` 的一例）。以二进制值最小之卦为名（`classOf`），两卦同类恰当某一对称把一卦送为另一卦（`classOf_eq_iff`）：共二十类，八类各二卦，十二类各四卦（`class_census`）。诸类是互所同行的归并（`classes_goAlike`）；消息之律不同行于诸类，因为倒转使它逆行（`classes_not_goAlike_waxWane`）。倒转不变之八卦（乾坤、頤大過、坎離、中孚小過），恰是卦序以錯相配者；倒转与錯所得相同之八卦，恰是卦序中两者兼合之四对（泰否、隨蠱、漸歸妹、既濟未濟）（`turn_fixed_iff`、`both_fixed_iff`）。
- **老少与之卦。** 一爻或老或少（`Marked`）；下一步老爻变为其反而不再变，少爻如故（`MarkedLines.settle`）。此律合并（`MarkedLines.settle_merges`），一步即定：沿每一运行自第一步起诸爻已定，运行静止（`MarkedLines.run_settled`、`MarkedLines.run_rests`）；有老爻者被吸入无老爻者之中（`MarkedLines.drawn`），所以一构形复返，恰当无一爻为老（`MarkedLines.returns_iff`、`MarkedLines.process_returns_iff`）。本卦（`MarkedLines.shown`）不是此律所同行的归并：六爻皆少之乾与初爻为老之乾，分别至乾与姤（`MarkedLines.shown_not_goAlike`）；之卦（`MarkedLines.onward`）是（`MarkedLines.onward_goAlike`）。六爻皆老阳示乾，自第一步起运行所示为坤；皆老阴则反之（`MarkedLines.all_nines`、`MarkedLines.all_sixes`）。
- **加一。** 以初爻为最低位，加一使最低之阴爻变阳、其下诸阳爻变阴（`addOne`、`carryAt`）；减一还原之，此律不合并（`addOne_lossless`）。它只有一条六十四步之轨：任一构形可由任一构形得到，每一构形首次复返在第六十四步（`addOne_reach`、`addOne_one_orbit`）。沿每一运行，2^(k−1) 步之后第 k 爻翻转，其下诸爻如故（`line_turns`）。
- **消息之六轨。** 各缝之承与乘（`riseCount`、`fallCount`），加上初、上两爻相同之处，数出绕行一周的爻变（`changesAround`）；消息之律沿每一运行保持此数（`changesAround_run`、`changesAround_invariant`），其值为一、三或五，分别在十二、四十、十二个构形上（`changesAround_values`、`changesAround_counts`），所以此律虽不合并，乾不能至既濟（`qian_not_reach_jiJi`、`waxWane_not_reach_every`）。每一构形在六个起点之一的轨道上：乾、屯、蒙、需、隨、既濟（`orbitStarts`、`on_an_orbit`），各于第十二步首次复返，隨于第四步（`starts_return`）；轨道是律所同行的归并，律之所及保持轨道（`orbitIndex_goAlike`、`reach_keeps_orbit`）；六轨各含十二、十二、十二、十二、四、十二个构形，绕行一周之爻变为一、三、三、三、三、五（`orbit_census`）。

### 王弼之读：初上无位与一爻之独应

以下声明在 [`Becoming.HexagramSites`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramSites.lean)，前缀 `Becoming.Hexagram.`。

- **第二个关系：初上无位。** 二至五位依其奇偶有定位，初、上两位无定位（`betweenEnds`、`Between`）。一位之定位之正，在两端没有，在其间即其奇偶之正（`fixedPhase`、`fixedPhase_between`、`fixedPhase_end`）；一爻在位，恰当它在两端之间而当位（`holdsPlace`、`holdsPlace_iff`、`holdsPlace_inPhase`、`holdsPlace_ends`）。这是 `inPhase` 之旁的另一关系：在二至五位与之相同，在两端不说。
- **王弼之两难。** 文言说乾上九“貴而无位”，小象说需上六“雖不當位”；二者一阳一阴，给上位任一奇偶，必有一个当位，没有一个奇偶使二者都不当位（`top_no_parity`）。二至五位之奇偶则由经文定出：小象之言定三、四、五位，中正之言定二位（`statements_fix_parity`、`centre_fixes_parity`，经 `parity_of_statement`）。小象明言位者二十六处皆在二至五位（`placeStatements_between`）；连同乾上九与需上六，二十八处在第二个关系下皆成立（`placeStatements_hold`、`xu_top_no_place`、`qian_top`）。
- **彖言之位。** 彖言一爻之位者九处，皆在二至五位，皆与之相合（`tuanPlaceStatements`、`tuanPlaceStatements_agree`）；言整卦之位者五处（蹇、漸、歸妹、既濟、未濟），以二至五位读皆合，以六位读只既濟、未濟合（`tuanWholeStatements`、`tuanWhole_between`、`tuanWhole_six`）。中间四爻皆当位者恰是既濟、蹇、漸、家人，皆不当位者恰是未濟、歸妹、解、睽（`allHold_iff`、`noneHold_iff`）。
- **在位上读。** 二至五位之定位是在四处的语境读法（`betweenPhase`）；它粘合为对整卦的读法，恰在中间四爻皆当位或皆不当位之处，没有去语境的框架在任何过程之下与之相合（`allHold_sites`、`noneHold_sites`、`between_glues_iff`、`between_no_free_frame`）。
- **定位所示的与所不示的。** 两卦定位相同，二至五位之爻便相同（`SameBetween`、`sameBetween_phase`）；所以中间三缝之承、乘、比与中之高度之应皆由定位而定（`falls_iff_phase`、`rises_iff_phase`、`alternates_iff_phase`、`opposed_mid_told`、`inner_seams_told`）。初、上两爻变，定位不动，而其旁之缝与其高度之应翻转（`sameBetween_flip_end`、`alternates_flip_bottom`、`alternates_flip_top`、`ends_not_told`）。错使每一定位之正翻转，综在镜像之处翻转（`fixedPhase_complement`、`fixedPhase_reverse`、`fixedPhase_flip_self`）；互为错卦的两卦，在位之爻数相加为四（`placedCount`、`placedCount_complement`）。
- **在消息之律之下。** 初位之爻升至二位，才取得定位之正，是它在初位之奇偶之反；二至五位之间，每升一位其定位之正翻转（`fixedPhase_waxWane_enters`、`fixedPhase_waxWane_rises`）。一步前后在位之爻数相加，再加初爻之正，等于四加五位之正（`placedCount_waxWane`）；一爻自二升至五，恰在其中两位在位（`course_between`）。定位之正不是律所同行的归并（`betweenPhases`、`betweenPhases_not_lumped`、`betweenPhases_not_goAlike`）：要跟随它，须看初位所入之爻。
- **一爻之独应。** 两爻相应，是其值相异，不依其距（`answers`、`answers_symm`、`answers_self`、`answers_complement`）；对应之位之应与相邻之比，都是这个关系（`opposed_answers`、`alternates_answers`）。一爻与其余五爻皆相应，为独应（`others`、`sole`、`sole_answered`、`sole_of_answered`）：恰在五阳一阴或五阴一阳之卦（`sole_count`、`soleAny`、`soleAny_count`、`sole_any`、`none_sole`），其爻唯一（`sole_unique`），即纯卦之一爻变（`uniform`、`sole_iff_flip`、`sole_flip`）。错、综保持之（`sole_complement`、`sole_reverse`）。十二卦中，在二至五位当位者四、不当位者四，在两端者四（`soleList`、`sole_places`、`sole_any_phase`）：独应不依位与正。独应之卦只在其爻之高度相应（`sole_opposition`、`heightMark`），节之应同样只在一个高度，而无独应（`jie_one_opposed`）。独阴之下为乘、之上为承，独阳反之，其余之缝无起落（`sole_broken_seams`、`sole_unbroken_seams`）；上爻为独阴者恰是夬（`guai_iff`、`guai_sole`）。
- **独应在消息之律之下。** 有独应之卦，一步之后没有独应（`soleAny_waxWane`、`sole_waxWane_none`），六步之后在原位复回（`sole_six`）；上位之独爻升出，留下纯卦，两步之后独爻自初位复入（`sole_top_passes`）。
- **普查。** 彖言“上下應”者三处，皆是独应之爻（`answeredStatements`、`answeredStatements_sole`、`xiaoXu_answered`、`daYou_answered`）；履六三是独应之爻（`lv`、`lv_sole`），豐没有（`feng`、`feng_no_sole`）。爻辭言“中”者十一爻，皆在二至五位，五爻居中；言“中行”者五爻，居中者二（`lineTextMiddle`、`middleCourseLines`、`lineTextMiddle_places`）。爻辭言位只萃九五，在位（`lineTextPlace`、`lineTextPlace_holds`）。大象言“中”与“位”之处、小象言“中”之处，由检查脚本找出，与其所记之例外比较（§5）。
- **沿展开读。** 以上诸律都在脊柱的运行上读出。沿消息之律的每一运行，定位之正随爻上升，六步之后皆翻转，一爻自二至五恰两处在位（`run_between_rises`、`run_placedCount`、`run_between_six`、`run_course_between`）；独应不延续一步，六步复回，在上者两步后自初复入（`run_sole`）；倒转之运行在镜像之处（`backward_between`、`backward_sole`）。沿一爻之变的每一运行，一步在两端，定位不动，只翻转其旁之缝与其高度之应；在其间，翻转该位之定位（`changes_run_between`、`changes_run_ends`）；变独爻即得纯卦，纯卦变一爻即得独应（`changes_run_sole`）。任一过程的运行在任一步所示之卦，定位与独应之诸律皆成立（`between_shown_along_runs`、`between_glue_along_run`、`sole_shown_along_run`、`answers_shown_along_run`）。

### 传中诸排列：卦序、卦变、奇偶、杂卦与八站

以下声明在 [`Becoming.HexagramSequences`](../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramSequences.lean)，前缀 `Becoming.Hexagram.`。序卦把六十四卦排为一序，杂卦排为另一序，彖以泰、否两爻相易读損、益、恒、咸，繫辭下以爻之数分阳卦阴卦，说卦第五章把八卦置于八站（帝出乎震）。模块问每一种排列有多少能由律承载，不加前提。

- **卦序是一个律的运行，而且只是一张表。** 一律运行所传卦序，是说它自乾起的运行依次经过六十四卦（`RunsOrder`、`runsOrder_iff`）。这样的律有（`orderNext`、`orderNext_runsOrder`），而且除未濟一处外都相同（`runsOrder_agrees`）；其中恰有一律不合并，即以未濟复归乾者（`runsOrder_lossless_iff`），它只有一轨，长六十四（`orderNext_one_orbit`）。但每一运行卦序之律，每一爻皆读每一爻：改变一卦的任一爻，在某处会改变下一卦的任一给定之爻（`runsOrder_reads`）；所以不看某一爻的读法定不了下一卦的任何一爻（`runsOrder_blind_not_lumped`），三格之局部规则不论首尾直接或倒转相接，都不运行卦序（`ringRule_not_runsOrder`、`twistedRule_not_runsOrder`），消息之律也在其中（`waxWane_twisted`、`waxWane_not_runsOrder`）。卦序中有一步是这种规则的一步：剝至復，是直接相接之移位，“剝窮上反下”；消息之律则经坤（`bo_fu`）。
- **卦序不保持任何对称。** 运行卦序之律，不与錯、綜或錯而綜交换（`runsOrder_not_commutes`）：卦序每一对是其中一种对称的一步，与此对称交换而沿其一步走的律，下一步即走回（`Follows.back`，经 `Law.Commutes.paired_halfway`）。把诸位重排再以一掩码变某些爻的律，都与錯交换（`rearrange_complement`），所以没有一个运行卦序（`rearrange_not_runsOrder`）；运行卦序之律也不同行于錯卦之对或阳爻之数的奇偶（`runsOrder_not_lumped`），而消息之律同行于二者。所以卦序不是任何只读一卦之一部分、或保持构形的任何对称之律的轨道；序卦以言说给出卦序的理由，不以律。
- **卦变：两爻相易。** 两位之爻相易，阳爻之数不变（`swap`、`yang_swap`）。下卦一爻与上卦一爻相易，是两卦之间交换之律的一步，其所移是一阳上行、一阳下行或无（`across`、`passing`、`across_exchange`）：損是泰之一阳上行（損下益上），益是否之一阳下行（損上益下），恒、咸是在另两端的同样相易（剛上而柔下、柔上而剛下）（`named_exchanges`）。三阳三阴之卦二十，恰是泰、否与由之一次上下相易所得之十八卦（`three_iff`、`three_census`）。一切相易之历程保持阳爻之数（`exchanges_keep`、`exchanges_run_total`），所以自泰、否起不出此二十卦（`exchanges_from_tai_pi`）；两卦各自之数按交换之律而行（`exchangesRun`），读为世界则平衡：一卦之数每一升皆有所给，每一降皆有所取（`exchangeWorld_balances`、`exchangeWorld_rise_fall`）。
- **奇偶。** 消息之律每一步、一爻之变每一步，都使阳爻之数改变奇偶，錯则保持之（`yangOdd_waxWane`、`yangOdd_flip`、`yangOdd_complement`）；所以奇偶是二者所同行的归并，阳爻之数本身不是（`yangOdd_lumped`、`yangOdd_goAlike`、`yangOdd_goAlike_changes`），沿其运行每一步翻转（`run_yangOdd`、`changes_run_yangOdd`）；互之律不同行于奇偶（`nuclear_yangOdd_not_lumped`、`nuclear_yangOdd_not_goAlike`）。三爻之卦，阳爻之数为奇，恰是乾或由坤变一爻者（震、坎、艮），为偶恰是坤或由乾变一爻者（巽、離、兌）；以阴爻为两画计画数，奇偶相同（`odd3_iff`）：“陽卦奇，陰卦偶”读作爻之数。两卦各自之数是全卦之数的部分（`halfYang_trigram`、`halfYang_total`）；一爻之变使其所在之卦由阳卦为阴卦或反之，另一卦不动（`trigramOdd_flip`、`changes_run_trigram`）。
- **杂卦：同样的对，另一次序。** 杂卦每卦恰列一次（`zagua_every`）。一卦之配是其倒转，倒转不变者则是六爻皆变（`partner`、`paired_iff_partner`、`partner_partner`），取其配之律的每一运行两步即返（`partner_run`）。所传卦序与杂卦之前五十六卦，都把每卦置于其配之旁（`order_partners`、`zagua_partners`）；杂卦之末八卦含其余四对，无一卦在其配之旁（`zagua_last_eight`）。杂卦之序也不是任何与錯、綜或二者交换之律的运行（`zagua_not_commutes`）。
- **消息无止。** 没有构形是消息之律的静止之处（`waxWane_moves`）：其任一运行在任一步都不静止，既濟亦然，也不从某步起归于静止（`run_never_rests`、`never_comes_to_rest`）；一爻之变的任一历程在任一步都不静止（`changes_run_never_rests`）。
- **说卦第五章之八站。** 自震起运行八站之律，不与三爻之錯、綜、二者或三爻之轮转交换（`Trigram.stations_not_commutes`），所以三格局部规则不论首尾如何相接，都不运行八站，诸高度之重排加掩码也不（`Trigram.stations_not_rules`、`Trigram.rearrange3_not_stations`）；八站相对的四对中只有離、坎互为錯，说卦第三章的四对则皆是（`Trigram.opposite_stations`）。
- **交。** 否是泰六爻皆变再倒转（`pi_of_tai`），所以凡錯所保持的读法，沿二者在消息之律下的每一运行，都把二者读为相同（`kept_alike`，经 `Law.Commutes.iterate`）；交，即某一高度下卦之爻为阳、上卦之爻为阴，在泰的每一高度成立，在否的任一高度都不成立（`meets`、`meets_tai_pi`）：这是在两值之间读入一个方向的读法，錯不保持它。沿两个运行，应、比、所属錯卦之对与奇偶每一步都相同，交则区分二者之起点（`tai_pi_runs`）。

## 3. 三种关系

- **相合**：经文所说的结构，脊柱上有已检查之律与之对应。
- **定域**：脊柱给出此句成立的确切范围，并修正其全称形式。
- **相分**：经文所断言者理论不断言，或与理论的结构名称冲突。

相合不是印证：律的成立不靠经文，经文的意义也不由律穷尽。定域不是否定：它说出在哪里成立。相分各保其说。

## 4. 逐句对应

表由[对应文件](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/y1-changes/passages.json)生成，检查脚本核对两者一致；改动应改对应文件，再以 `--table` 重印此表。声明名省去前缀 `Becoming.`。

“律的层次”由校验脚本从所引声明算出，不存于对应表中：所引声明全在 `Becoming.Hexagram` 命名空间（卦的编码上的事实：`Fin 64` 上的引理、表、`decide`）为“编码”，全不在为“一般律”（对每个过程、网、流、世界或交换之律成立的律），两者都有为“兼有”。

<!-- passage-map:begin -->
| 经文 | 出处 | 关系 | 律的层次 | 脊柱上的声明 | 读法（AI） |
|---|---|---|---|---|---|
| <a id="p-chonggua"></a>「八卦成列，象在其中矣；因而重之，爻在其中矣」 | 《繫辭下》第一章 | 相合 | 编码 | `Hexagram`<br>`Hexagram.line`<br>`Hexagram.order`<br>`Hexagram.order_length`<br>`Hexagram.mem_order` | 卦由下卦、上卦相重而成，六爻各取刚柔二值；所传卦序长六十四，含全部构形。 |
| <a id="p-sancai"></a>「兼三材而兩之，故六」 | 《繫辭下》第八章 | 相合 | 编码 | `Hexagram.Place`<br>`Hexagram.places`<br>`Hexagram.line` | 六位，每位二值；把六位两两分作天、地、人三材，不在模块之内。 |
| <a id="p-taiji"></a>「是故易有太極，是生兩儀，兩儀生四象，四象生八卦」 | 《繫辭上》第十一章 | 定域 | 兼有 | `Hexagram.order_length`<br>`World.unity`<br>`Hexagram.addOne`<br>`Hexagram.addOne_one_orbit`<br>`Hexagram.line_turns` | 每加一个二值之分，构形加倍，至六分而六十四；脊柱把它读作一个展开之上逐层的区分，不是时间中的先后产生。加一之律依次经过全部六十四构形而后复返，只此一轨；第 k 爻每 2^(k−1) 步一变：逐层之分读作数位。 |
| <a id="p-feifu"></a>「今驗六十四卦，二二相耦，非覆即變」 | 孔穎達《周易正義》（序卦疏） | 相合 | 编码 | `Hexagram.reverse`<br>`Hexagram.complement`<br>`Hexagram.Paired`<br>`Hexagram.pairs`<br>`Hexagram.order_paired`<br>`Hexagram.order_paired_by_law`<br>`Hexagram.six_steps`<br>`Hexagram.turn_fixed_iff`<br>`Hexagram.both_fixed_iff` | 对所传卦序逐对检验：每对之后一卦是前一卦倒转（覆），倒转不变者则六爻皆变（變）。倒转不变者八卦（乾坤、頤大過、坎離、中孚小過），恰是卦序以變相配者；倒转与六爻皆变所得相同者，恰是卦序中覆、變两者兼合之对（泰否、隨蠱、漸歸妹、既濟未濟）。其中之“變”经消息之律读出：六爻皆变即沿消息之律走六步（six_steps），故所传每对之后一卦，或为前一卦之覆，或在倒转不变时为前一卦沿消息之律六步所至（order_paired_by_law）。 |
| <a id="p-qiankun-chenglie"></a>「乾坤成列，而易立乎其中矣」 | 《繫辭上》第十二章 | 相合 | 编码 | `Hexagram.waxing`<br>`Hexagram.waning`<br>`Hexagram.six_steps` | 消息之律下，坤六步至乾，乾六步至坤；任一构形六步即至其错卦。 |
| <a id="p-gangrou"></a>「剛柔相推而生變化」 | 《繫辭上》第二章 | 相合 | 兼有 | `Hexagram.flip`<br>`Hexagram.changes`<br>`Hexagram.reach_every`<br>`Hexagram.changes_returns`<br>`Hexagram.changes_keeps`<br>`Hexagram.changes_merges`<br>`Branching.keeps_of_returns` | 一爻之变：任一构形可由任一构形得到，每一构形皆复返，不失任何可能；而此过程有合并，可见复返不等于无合并。 |
| <a id="p-wuwang-bufu"></a>「无平不陂，无往不復」……「无往不復，天地際也」 | 泰·九三、象 | 定域 | 兼有 | `Law.lossless_iff_returns`<br>`Hexagram.every_returns_iff`<br>`Hexagram.waxWane_returns`<br>`Hexagram.wane_not_returns`<br>`Law.drawn_iff_not_returns` | 有限构形之内，一律之下每一构形皆复返，恰当此律不合并；律有合并处，被吸入者不复返。 |
| <a id="p-qiri-laifu"></a>「反復其道，七日來復」 | 復·卦辭、彖 | 相合 | 编码 | `Hexagram.rising`<br>`Hexagram.falling`<br>`Hexagram.waning`<br>`Hexagram.seventh_step` | 依消息卦的读法：自乾起，一阴生为姤，第六步至坤，第七步一阳复生为復。 |
| <a id="p-tiandi-zhixin"></a>「復其見天地之心乎」 | 復·彖 | 相分 | 兼有 | `Hexagram.waxWane_returns`<br>`Web.significance_undetermined` | 复返是不合并之律的定理；把复返读作天地之心（意向或关切），律不支持，动力学不决定意义。 |
| <a id="p-xiaoxi"></a>「日中則昃，月盈則食，天地盈虛，與時消息」 | 豐·彖 | 相合 | 编码 | `Hexagram.waxWane`<br>`Hexagram.waxing`<br>`Hexagram.waning`<br>`Hexagram.twelve_steps`<br>`Hexagram.first_return` | 消息之律：每爻升一位，上爻出而以其反入初位；盈（乾）之后即消，虚（坤）之后即息，自坤十二步首次复至坤。 |
| <a id="p-shang-xiaoxi"></a>「君子尚消息盈虛，天行也」 | 剝·彖 | 相合 | 编码 | `Hexagram.waxWane_lossless`<br>`Hexagram.twelve_steps`<br>`Hexagram.fourth_step`<br>`Hexagram.changesAround`<br>`Hexagram.changesAround_values`<br>`Hexagram.changesAround_counts`<br>`Hexagram.qian_not_reach_jiJi`<br>`Hexagram.starts_return`<br>`Hexagram.orbit_census` | 消息盈虚是一个不合并之律的运行；十二消息卦之环只是其中一轨，隨、中孚、蠱、小過四步即返。消息之律分六十四构形为六轨：五轨十二步，一轨四步；承、乘之数加首尾相同之处，沿每一历程不变，为一、三或五，分别在十二、四十、十二个构形上，故乾不能至既濟。 |
| <a id="p-wanglai-butong"></a>「闔戶謂之坤，闢戶謂之乾，一闔一闢謂之變；往來不窮謂之通」 | 《繫辭上》第十一章 | 定域 | 编码 | `Hexagram.waxWane_returns`<br>`Hexagram.every_returns_iff`<br>`Hexagram.allBroken_absorbing` | 往来不穷，恰在律不合并之处；只入阴爻之律下坤为吸收态，往而不来。 |
| <a id="p-riyue"></a>「日往則月來，月往則日來，日月相推而明生焉」……「往者，屈也；來者，信也。屈信相感而利生焉」 | 《繫辭下》第四章 | 相合 | 兼有 | `Hexagram.arising_recurs`<br>`Hexagram.ceasing_recurs`<br>`Frame.claims_recur_iff` | 沿律之每一运行，一爻在任意晚的步上转为阳，也在任意晚的步上止于阳；“利生焉”是评价，不在律中。 |
| <a id="p-yiyin-yiyang"></a>「一陰一陽之謂道」 | 《繫辭上》第五章 | 定域 | 兼有 | `Web.change_readings`<br>`World.arising_iff_ceasing`<br>`World.law_iff_em`<br>`Hexagram.world_arising_recurs`<br>`Hexagram.world_ceasing_recurs` | 生起与止息是一个变化的两种读法；有限且活动可判定的世界中二者同时反复；不经判定而对一切有限世界断言之，等价于排中律。 |
| <a id="p-jizhi-shan"></a>「繼之者善也，成之者性也」 | 《繫辭上》第五章 | 相分 | 一般律 | `Web.significance_undetermined`<br>`Unrestricted`<br>`livingSignificance_of_unrestricted` | 易传断言继之者善；理论中动力学不决定意义，生命意义只在延续条件之下是定理，此条件明示而不断言。 |
| <a id="p-gu-wanwu"></a>「鼓萬物而不與聖人同憂」 | 《繫辭上》第五章 | 相合 | 一般律 | `Web.significance_undetermined` | 律鼓动万物，自身不带关切：无物有意义与万物有意义，动力学两者都不排除。 |
| <a id="p-jianzhi"></a>「仁者見之謂之仁，知者見之謂之知」 | 《繫辭上》第五章 | 相合 | 兼有 | `Web.change_readings`<br>`Learning.goAlike_iff_lumped`<br>`Hexagram.pairs_goAlike`<br>`Hexagram.yang_not_goAlike` | 同一展开有多种读法；一种读法承载律，恰当律在其归并上同行：错卦之对承载，阳爻之数不承载。 |
| <a id="p-rixin"></a>「富有之謂大業，日新之謂盛德」 | 《繫辭上》第五章 | 相合 | 兼有 | `Hexagram.waxWane_returns`<br>`Law.withHistory_never_returns`<br>`Hexagram.kept_history_unlisted` | 构形皆复返，而带着历史的展开永不复返，不被任何清单所含：无往不复与日新是同一律的两层读法；大业、盛德之评价不在律中。 |
| <a id="p-shengsheng"></a>「生生之謂易」 | 《繫辭上》第五章 | 定域 | 兼有 | `Hexagram.wane_drawn`<br>`Hexagram.wane_loses`<br>`World.living_crosses`<br>`World.arising_opens`<br>`Web.embodiedArising_fed_from_beyond` | 脊柱上的变化比生生宽：它也含合并与可能之失；生生作为生成之持续，需要开放，并由外部供给。 |
| <a id="p-jishu-zhilai"></a>「極數知來之謂占」 | 《繫辭上》第五章 | 定域 | 一般律 | `Learning.no_prefix_fixes_next`<br>`Learning.diagonal_misses`<br>`Identification.bounded_agree`<br>`Learning.goAlike_iff_lumped` | 一般而言没有有限前缀定得下一步；知来只在历程有界、读法为律所同行之处成立；以数占筮不被支持。 |
| <a id="p-buce"></a>「陰陽不測之謂神」 | 《繫辭上》第五章 | 相合 | 一般律 | `Learning.diagonal_misses`<br>`Web.tail_unexcluded` | 对任一外推，皆有其失误的历程；没有模型时，有限前缀不排除其后的任何走向。 |
| <a id="p-gantong"></a>「易，无思也，无為也，寂然不動，感而遂通天下之故」 | 《繫辭上》第十章 | 定域 | 一般律 | `Web.observed_level_couples`<br>`Flow.uncoupled_beyond_coupling` | 感即耦合：经耦合而入的差别得以传达；耦合闭包之外者不被区分，“通天下”恰止于耦合所及。 |
| <a id="p-xian-gan"></a>「咸，感也」……「觀其所感，而天地萬物之情可見矣」 | 咸·彖 | 相合 | 一般律 | `Web.observed_level_couples`<br>`Flow.uncoupled_beyond_coupling`<br>`Flow.unselected_beyond_coupling` | 所见即所感：一个形成所显示的，是其耦合所携带的；闭包之外的部分，选择也不能及。 |
| <a id="p-yanji"></a>「夫易，聖人之所以極深而研幾也」 | 《繫辭上》第十章 | 定域 | 一般律 | `Web.observed_level_couples`<br>`Web.break_not_bounded` | 研几只能经由耦合而入者：依水平耦合的条件，其差别传入；断裂所系的条件若不耦合，断裂之前无物界定其远近。 |
| <a id="p-zhiji"></a>「知幾其神乎」……「幾者，動之微，吉之先見者也」 | 《繫辭下》第四章 | 定域 | 一般律 | `Web.break_not_bounded`<br>`Web.observed_level_couples`<br>`Flow.policy_uses_after_failure` | 几之先见恰在相关条件耦合入读法之处；否则断裂前无可登记，经耦合的策略只在失败之后才动用更大的储备。 |
| <a id="p-qiong-bian"></a>「易窮則變，變則通，通則久」 | 《繫辭下》第二章 | 定域 | 兼有 | `Hexagram.waxing`<br>`Hexagram.waning`<br>`Hexagram.allBroken_absorbing`<br>`Web.consumed_ends_when_fixed`<br>`Web.consumed_continues_transformed`<br>`Hexagram.MarkedLines.run_settled`<br>`Hexagram.MarkedLines.run_rests` | 消息之律下极则转；只入阴爻之律下坤为吸收态，穷而不变。失而不复之后，依存不变者不能延续，延续者已改变其依存：穷则变不是普遍律。之卦之律下，老爻（九、六）一变即为少爻，此后不再变：在此律之内，“窮”读作老，变之后即久。 |
| <a id="p-kanglong"></a>「上九：亢龍，有悔」……「亢龍有悔，盈不可久也」……「「亢龍有悔」，窮之災也」……「「亢龍有悔」，與時偕極」 | 乾·上九、象、文言 | 相合 | 一般律 | `Law.more_never_rests`<br>`Flow.takesAll_of_more`<br>`Flow.more_exhausted` | 以多于现在为目标者永不止息；供给有界时，递增之取终取尽所予；封闭之下，多于现在必竭。 |
| <a id="p-kang-zhiwei-yan"></a>「亢之為言也。知進而不知退。知存而不知亡。知得而不知喪」 | 《文言》（乾） | 相合 | 一般律 | `Flow.policy_uses_after_failure`<br>`Web.break_not_bounded` | 只知进者，所失只在断裂时登记：经耦合的策略只在失败之后动用更大储备；断裂之前，耦合所入者不界定其远近。 |
| <a id="p-gen-zhi"></a>「艮，止也。時止則止，時行則行，動靜不失其時」 | 艮·彖 | 相合 | 一般律 | `Law.rests_iff`<br>`World.rests_unrefuted_enclosed` | 止是相对于律而言：轨道止于其目标，恰当它到达律所不变之态；静不是世界停止。 |
| <a id="p-lishuang"></a>「履霜，堅冰至」……「履霜堅冰，陰始凝也。馴致其道，至堅冰也」 | 坤·初六、象 | 相合 | 兼有 | `Hexagram.wane`<br>`Hexagram.wane_six`<br>`Hexagram.wane_drawn`<br>`Hexagram.wane_never_back`<br>`Law.DrawnInto.never_back` | 只入阴爻之律：每步多一阴爻，六步皆阴而不复离，被吸入者永不回来；在消息之律下坤并非吸收态，坚冰是否长存在律不在卦。 |
| <a id="p-weiji"></a>「物不可窮也，故受之以未濟；終焉」 | 《序卦》 | 相合 | 兼有 | `Law.withHistory_unlisted`<br>`Hexagram.kept_history_unlisted`<br>`World.arising_opens`<br>`Onward.run_iff_continues` | 卦序终于未济：带着历史的展开不被任何清单所含；生起无尽须开放；有限构形之内，运行恰是长如清单之历程。 |
| <a id="p-ziqiang"></a>「天行健，君子以自強不息」 | 乾·象 | 定域 | 一般律 | `Flow.fed_from_beyond`<br>`Web.embodiedArising_fed_from_beyond` | 平衡而耗散的交换中，持续者由外部供给，封闭的部分不能只凭自身不息；自强读作耦合之中自身之分则相合，读作自足则相分。 |
| <a id="p-yuanshi"></a>「原始反終，故知死生之說」 | 《繫辭上》第四章 | 相合 | 一般律 | `Frame.arises_iff`<br>`Frame.novel_iff_arises`<br>`World.living_crosses` | 生起是一主张被新实现；活着跨越生起与止息，不由二者之反复决定。 |
| <a id="p-xiang"></a>「是故易者，象也。象也者，像也」 | 《繫辭下》第三章 | 定域 | 兼有 | `Learning.goAlike_iff_lumped`<br>`Hexagram.pairs_goAlike`<br>`Hexagram.yang_not_goAlike` | 象是一种归并的读法；它承载律，恰当律在其上同行。 |
| <a id="p-yijian"></a>「易簡，而天下之理得矣」 | 《繫辭上》第一章 | 定域 | 兼有 | `Learning.goAlike_iff_lumped`<br>`Hexagram.pairs_lumped`<br>`Hexagram.yang_not_lumped` | 更简的读法保留律，恰当它是律所同行的归并：六十四归为三十二对仍成律，按阳爻之数归并则不成；并非任何简化皆得理。 |
| <a id="p-daoqi"></a>「是故形而上者謂之道，形而下者謂之器」 | 《繫辭上》第十二章 | 定域 | 一般律 | `exists_law_iff`<br>`shown_le_iff`<br>`Run.keepHistory_shown` | 律由展开读出：一历史所显之律是它所属的最小律；某一决定之律容纳此历史，恰当此历史自洽。把形而上读作器外另一实在，则相分。 |
| <a id="p-wang-qi"></a>「天下惟器而已矣。道者器之道，器者不可謂之道之器也」……「無其器則無其道」 | 王夫之《周易外傳》卷五 | 相合 | 一般律 | `exists_law_iff`<br>`shown_le_iff`<br>`Run.keepHistory_shown` | 道是器之道：一历史所显之律只容纳此历史，律不先于其所行之展开。 |
| <a id="p-biandong"></a>「變動不居，周流六虛，上下无常，剛柔相易，不可為典要，唯變所適」 | 《繫辭下》第七章 | 相合 | 兼有 | `Hexagram.run_six_steps`<br>`Hexagram.twelve_steps`<br>`Learning.no_prefix_fixes_next`<br>`Contextual.fitsFree_iff` | 消息之律下每爻周流六位；没有有限前缀定得下一步；去语境的读法，恰在各语境相接处一致时才合。 |
| <a id="p-liuyao-xiangza"></a>「六爻相雜，唯其時物也」 | 《繫辭下》第七章 | 相合 | 兼有 | `Contextual.indexed_fits`<br>`Contextual.glues_iff_agree`<br>`Hexagram.halves_indexed`<br>`Hexagram.atSites_glues_iff`<br>`Hexagram.inPhase_waxWane_above` | 一爻之义随其位与时：带语境索引的框架合于所示的一切；各语境所示能粘合，恰当它们在相接处一致。爻位之间的关系（正、应、比、中）都在位上成立：同一爻沿消息之律升一位，其正即翻转。 |
| <a id="p-zhen-fu-yi"></a>「天下之動，貞夫一者也」 | 《繫辭下》第一章 | 定域 | 一般律 | `World.unity`<br>`World.withRest_balanced`<br>`Flow.changeReadings_glue_everywhere_iff`<br>`World.withRest_closed_iff` | 每一世界是交换律的一次运行；算入其余，其变化的读法每步粘合，这由构造对一切世界成立。有内容的是：世界自身的读法处处粘合，恰当它平衡，平衡恰当其余从不活跃。所以“贞夫一”读作诸读法之粘合，恰在平衡处成立；“以一为准”的标准义脊柱不给，“一”不立为先在之实体。 |
| <a id="p-dieyong-gangrou"></a>「分陰分陽，迭用柔剛，故易六位而成章」 | 《說卦》第二章 | 相合 | 编码 | `Hexagram.odd`<br>`Hexagram.odd_above`<br>`Hexagram.inPhase`<br>`Hexagram.inPhase_all_iff`<br>`Hexagram.alternates_all_iff` | 六位奇偶相间：每一相邻两位，奇偶相反。一爻之值与其位之奇偶相合为正；六爻皆正恰是既濟，每一相邻两爻皆相异恰是既濟与未濟。 |
| <a id="p-zhengwei"></a>「剛柔正而位當也」 | 既濟·彖 | 相合 | 编码 | `Hexagram.inPhase`<br>`Hexagram.jiJi_inPhase`<br>`Hexagram.inPhase_all_iff`<br>`Hexagram.atSites`<br>`Hexagram.phases_glue_iff` | 正是一爻与其位的关系，在位上成立。各位之正读作一个带语境的读法，它粘合为对整卦的一个读法，恰在六爻皆正（既濟）或皆不正（未濟）之处；彖于既濟说整卦“剛柔正而位當”，正在其一。 |
| <a id="p-weiji-ying"></a>「雖不當位，剛柔應也」 | 未濟·彖 | 定域 | 编码 | `Hexagram.weiJi_out_of_phase`<br>`Hexagram.weiJi_opposed`<br>`Hexagram.opposed_iff_phase`<br>`Hexagram.out_of_phase_opposed` | 同一高度的两位奇偶相反，所以两爻相应，恰当二者同正或同不正；六爻皆不当位，三对便皆相应。“雖”把两者读作相反，律中则是前者蕴涵后者。 |
| <a id="p-heng-jieying"></a>「剛柔皆應」 | 恒·彖 | 相合 | 编码 | `Hexagram.opposed`<br>`Hexagram.heng_opposed`<br>`Hexagram.oppositions_glue_iff` | 恒三个高度皆相应，下卦是上卦之错；各高度之应在此粘合为对整卦的一个读法。 |
| <a id="p-xian-ganying"></a>「二氣感應以相與」 | 咸·彖 | 相合 | 编码 | `Hexagram.xian_opposed`<br>`Hexagram.oppositions_glue_iff`<br>`Hexagram.halves_glues_iff` | 咸三个高度皆相应：以上下两卦为两个语境，每一高度两卦所示皆相异。“相與”在此读作经由相异而相应，不读作两卦合一。 |
| <a id="p-gen-diying"></a>「上下敵應，不相與也」 | 艮·彖 | 相合 | 兼有 | `Hexagram.halves`<br>`Hexagram.halves_glues_iff`<br>`Hexagram.gen_halves_glue`<br>`Hexagram.halves_no_free_frame`<br>`Hexagram.halves_indexed`<br>`Contextual.indexed_fits` | 敵應：每一高度两爻相同，上下两卦作为语境处处所示一致而粘合，没有一处相应，故“不相與”。相应之处，一个高度之爻在两卦中是两个主张；没有去语境的读法合于所有构形，带语境索引的读法则合。 |
| <a id="p-gangzhong-erying"></a>「剛中而應」 | 師·彖 | 相合 | 编码 | `Hexagram.middleUnbrokenOpposed`<br>`Hexagram.middleUnbrokenOpposed_eq`<br>`Hexagram.middleBrokenOpposed_eq`<br>`Hexagram.middleOppositionStatements`<br>`Hexagram.middleOppositionStatements_agree` | 彖言“剛中而應”者五卦：師、臨、无妄、萃、升；检查脚本在所存六十四页中找出全部五处，每卦居中之阳爻皆有应。剛中而應恰是中之高度相应，与“柔中而應”所指相同：一个关系，从其两端读。 |
| <a id="p-tongren-dezhong"></a>「柔得位得中，而應乎乾」 | 同人·彖 | 相合 | 编码 | `Hexagram.tongRen_second`<br>`Hexagram.inPhase`<br>`Hexagram.middle`<br>`Hexagram.opposed` | 六二为阴，当位，居中，其高度与上卦乾之九五相应。 |
| <a id="p-xiaoxu-shangxia"></a>「柔得位而上下應之」 | 小畜·彖 | 相合 | 编码 | `Hexagram.xiaoXu_fourth`<br>`Hexagram.opposed`<br>`Hexagram.sole`<br>`Hexagram.xiaoXu_answered`<br>`Hexagram.answeredStatements_sole` | 六四为阴而当位；以对应之位论，只初九与之相应。“上下應之”读作一个阴爻与其余五个阳爻皆相异：小畜六四是卦中唯一之阴爻，其余五爻皆与之相应。 |
| <a id="p-dayou-zunwei"></a>「柔得尊位，大中而上下應之」 | 大有·彖 | 相分 | 编码 | `Hexagram.daYou_fifth`<br>`Hexagram.middle`<br>`Hexagram.inPhase`<br>`Hexagram.opposed`<br>`Hexagram.sole`<br>`Hexagram.daYou_answered` | 六五居中而不当位，以对应之位论只与九二相应；“上下應之”是六五与其余五个阳爻皆相异，在律中。“尊位”是位的等级，理论不采（与《繫辭》“貴賤”之相分同），所以仍为相分。 |
| <a id="p-guimei-chenggang"></a>「柔乘剛也」 | 歸妹·彖 | 相合 | 编码 | `Hexagram.falls`<br>`Hexagram.guiMei_falls`<br>`Hexagram.rises_falls_ends` | 六三在九二之上，六五在九四之上，两处柔乘刚。自下而上，阳之起（承）与落（乘）次数之差由首尾两爻定：承之数加初爻，等于乘之数加上爻。 |
| <a id="p-guai-chengwugang"></a>「柔乘五剛也」 | 夬·彖 | 相合 | 编码 | `Hexagram.guai_falls`<br>`Hexagram.falls`<br>`Hexagram.guai_iff`<br>`Hexagram.guai_sole`<br>`Hexagram.sole_broken_seams` | 以相邻之位论，上六只乘九五一刚，诸位之间只此一处落；“乘五剛”读作上六与其下五个阳爻皆相异：上爻为阴而与其余五爻皆相异者恰是夬，此阴爻之下是唯一之落。 |
| <a id="p-lv-weibudang"></a>「咥人之凶，位不當也」 | 履·六三·象 | 相合 | 编码 | `Hexagram.placeStatements`<br>`Hexagram.placeStatements_agree`<br>`Hexagram.inPhase`<br>`Hexagram.xu_top_inPhase`<br>`Hexagram.placeStatements_between`<br>`Hexagram.placeStatements_hold`<br>`Hexagram.holdsPlace` | 小象明言位者二十七处（位不當、不當位、未當位、未得位；位正當、位當、當位），检查脚本在所存六十四页中逐一找出：二十六处在三、四、五位，与其爻是否当位相合；需上六一处在上位。以初上无位之读，二十七处与《文言》乾上九“貴而无位”皆相合，没有例外。“凶”是判断，不在律中。 |
| <a id="p-xu-shangliu"></a>「雖不當位，未大失也」 | 需·上六·象 | 相合 | 编码 | `Hexagram.xu_top_inPhase`<br>`Hexagram.inPhase`<br>`Hexagram.xu_top_no_place`<br>`Hexagram.top_no_parity`<br>`Hexagram.holdsPlace`<br>`Hexagram.fixedPhase` | 上六阴居偶位，依六位之奇偶是当位，象却说不当位。王弼《周易略例·辯位》以此句与乾上九“貴而无位”为初、上无定位之证。模块有两个关系：依六位之奇偶，此处相分；依初上无位之读，上六无定位而不在位，象之言相合。 |
| <a id="p-xu-zhongzheng"></a>「酒食，貞吉，以中正也」 | 需·九五·象 | 相合 | 编码 | `Hexagram.centreStatements`<br>`Hexagram.centreStatements_agree`<br>`Hexagram.middle`<br>`Hexagram.inPhase`<br>`Hexagram.gen_fifth_out_of_phase` | 小象言“中正”“正中”者十处，检查脚本逐一找出：九处是居中而当位之爻；只有艮六五一处相分（见下）。 |
| <a id="p-gen-zhongzheng"></a>「艮其輔，以中正也」 | 艮·六五·象 | 相分 | 编码 | `Hexagram.gen_fifth_out_of_phase`<br>`Hexagram.middle`<br>`Hexagram.inPhase` | 六五居中，阴居奇位，依奇偶不当位，象却说中正：此处的“正”读作因得中而正，不是位之奇偶。模块不以中代正，所以相分。 |
| <a id="p-tun-chenggang"></a>「六二之難，乘剛也」 | 屯·六二·象 | 相合 | 编码 | `Hexagram.fallStatements`<br>`Hexagram.fallStatements_agree`<br>`Hexagram.falls` | 小象言“乘剛”者五处（屯六二、豫六五、噬嗑六二、困六三、震六二），检查脚本逐一找出：每处都是阴爻在阳爻之上，即其下之缝为落。 |
| <a id="p-liuwei-shicheng"></a>「大明終始，六位時成」 | 乾·彖 | 定域 | 编码 | `Hexagram.line_waxWane_above`<br>`Hexagram.inPhase_waxWane_above`<br>`Hexagram.phaseCount_parity`<br>`Hexagram.phase_qian_orbit` | 消息之律下，每爻逐步升经六位，其值不变，其正每升一位即翻转：一爻所示依其所处之位与时。当位之数每步改变奇偶，自乾十二步为三、二、三、二、三、二、三、四、三、四、三、四。“大明”之读不在律中。 |
| <a id="p-tonggong-yiwei"></a>「二與四同功而異位，其善不同：二多譽，四多懼，近也」 | 《繫辭下》第八章 | 定域 | 编码 | `Hexagram.odd`<br>`Hexagram.heightOf`<br>`Hexagram.middle`<br>`Hexagram.Seam` | 二、四同为偶位（同功）；二居下卦之中，四居上卦之下（異位）。“多譽”“多懼”是判断，“近”指四近于五，皆不在模块之中。 |
| <a id="p-jian-dangwei"></a>「當位貞吉，以正邦也」 | 蹇·彖 | 相合 | 编码 | `Hexagram.tuanWholeStatements`<br>`Hexagram.tuanWhole_between`<br>`Hexagram.tuanWhole_six`<br>`Hexagram.allHold_iff`<br>`Hexagram.jian3`<br>`Hexagram.holdsPlace` | 彖言整卦之位者五处（蹇“當位”、漸“進得位”、歸妹“位不當”、既濟“剛柔正而位當”、未濟“不當位”），检查脚本在所存六十四页中逐一找出。以二至五位读，五处皆合；以六位之奇偶读，只既濟、未濟两处合：蹇、漸初爻不当位，漸上爻亦然。中间四爻皆当位者恰是既濟、蹇、漸、家人四卦，彖于四卦皆言位或正。“貞吉”“正邦”是判断，不在律中。 |
| <a id="p-guimei-weibudang"></a>「征凶，位不當也」 | 歸妹·彖 | 相合 | 编码 | `Hexagram.noneHold_iff`<br>`Hexagram.tuanWhole_between`<br>`Hexagram.tuanWhole_six`<br>`Hexagram.holdsPlace` | 歸妹中间四爻皆不当位；中间四爻皆不当位者恰是未濟、歸妹、解、睽四卦。其初九、上六依六位之奇偶反而当位，所以此句只在初上无位之读下对整卦成立。“征凶”是判断，不在律中。 |
| <a id="p-bi-shangxiaying"></a>「不寧方來，上下應也」 | 比·彖 | 相合 | 编码 | `Hexagram.answeredStatements`<br>`Hexagram.answeredStatements_sole`<br>`Hexagram.sole`<br>`Hexagram.sole_answered`<br>`Hexagram.sole_unique` | 彖言“上下應”者三处（比、小畜、大有），检查脚本逐一找出：每处所说之爻都是卦中唯一之阳爻或阴爻（比九五、小畜六四、大有六五），与其余五爻皆相异，其余五爻亦各与之相应。这是一爻与其余诸爻之关系，比对应之位宽；有此一爻之卦恰十二，其爻唯一。 |
| <a id="p-cui-youwei"></a>「萃有位，无咎」 | 萃·九五 | 相合 | 编码 | `Hexagram.lineTextPlace`<br>`Hexagram.lineTextPlace_holds`<br>`Hexagram.holdsPlace`<br>`Hexagram.middle` | 爻辭明言位者只此一处，检查脚本在所存六十四页之爻辭中找出：九五居中，阳居奇位，当位，在初上之间而有定位。“无咎”是判断，不在律中。 |
| <a id="p-tai-zhongxing"></a>「得尚于中行」 | 泰·九二 | 定域 | 编码 | `Hexagram.lineTextMiddle`<br>`Hexagram.middleCourseLines`<br>`Hexagram.lineTextMiddle_places`<br>`Hexagram.betweenEnds`<br>`Hexagram.middle` | 爻辭言“中”者十一爻，检查脚本逐一找出：皆在二至五位，初上无一；其中居中者五（師九二、泰九二、家人六二、夬九五、豐六二）。言“中行”者五爻（泰九二、復六四、益六三、益六四、夬九五），居中者只泰九二、夬九五：爻辭之“中”多是中间，不都是居中之位。 |
| <a id="p-xu-yanzaizhong"></a>「需于沙，衍在中也」 | 需·九二·象 | 定域 | 编码 | `Hexagram.middle`<br>`Hexagram.betweenEnds` | 小象言“中”者五十一爻，检查脚本逐一找出：四十七爻居中（二、五位）；其余四处不是居中之读：泰六四“中心”、復六四“中行”、震上六“中未得”、豐九四“日中”。需九二居中。 |
| <a id="p-shi-daxiang"></a>「地中有水，師」 | 師·象 | 定域 | 编码 | `Hexagram.halves`<br>`Hexagram.middle` | 大象言“中”者八处（師、謙、隨、復、大畜、明夷、升、革），检查脚本逐一找出：每处都是下卦之象在上卦之象之中，是上下两体之关系，不是居中之位；言“位”者二处（鼎“正位凝命”、艮“思不出其位”），是君子之位，不是爻位。大象不言爻位之关系。 |
| <a id="p-lueli-bianwei-top"></a>「唯《乾》上九《文言》雲：「貴而無位」，《需》上六雲：「雖不當位」。若以上為陰位邪？則《需》上六不得雲不當位也。若以上陽位邪？則《乾》上九不得雲貴而無位也」 | 王弼《周易略例·辯位》 | 相合 | 编码 | `Hexagram.top_no_parity`<br>`Hexagram.qian_top`<br>`Hexagram.xu_top_no_place`<br>`Hexagram.fixedPhase`<br>`Hexagram.holdsPlace` | 王弼之两难：乾上九为阳，需上六为阴，文言与小象皆说其不在位；给上位任一奇偶，二者必有一个当位，没有一个奇偶使二者都不当位。以初上无位读之，二者皆不在位。所存本“云”作“雲”，照录。 |
| <a id="p-lueli-bianwei-noplace"></a>「《象》無初上得位失位之文，又《系辭》但論三五、二四同功異位，亦不及初上」……「初上無陰陽定位，亦以明矣」 | 王弼《周易略例·辯位》 | 相合 | 编码 | `Hexagram.betweenEnds`<br>`Hexagram.fixedPhase`<br>`Hexagram.fixedPhase_end`<br>`Hexagram.holdsPlace_iff`<br>`Hexagram.holdsPlace_ends`<br>`Hexagram.placeStatements_between`<br>`Hexagram.placeStatements_hold`<br>`Hexagram.statements_fix_parity`<br>`Hexagram.centre_fixes_parity` | 第二个关系：二至五位依奇偶有定位，初、上无定位，在两端之爻不在位。小象明言位者二十六处在三、四、五位，无一在初；需上六一处在上。以此读之，二十七处与文言乾上九“貴而无位”皆相合，没有例外。二至五位之奇偶亦由所言之位定出：小象之言定三、四、五位，中正之言定二位，与奇偶相合。 |
| <a id="p-lueli-bianwei-zhongshi"></a>「然事不可無終始，卦不可無六爻，初上雖無陰陽本位，是終始之地也」……「卦以六爻為成，則不得不謂之六位時成也」 | 王弼《周易略例·辯位》 | 相合 | 编码 | `Hexagram.fixedPhase_waxWane_enters`<br>`Hexagram.changes_run_ends`<br>`Hexagram.sole_top_passes`<br>`Hexagram.sole_six`<br>`Hexagram.sole_waxWane_none`<br>`Hexagram.run_between_six` | 初、上无定位，却是一爻进入与离开之处：消息之律下，新爻自初位入，升至二位才取得定位之正；一爻在初或上变动，二至五位之定位皆不变，只改变其旁之应与比。一爻对其余五爻之独应不能延续一步，六步后复回；在上之独爻升出，留下六爻皆同之卦，两步后自初位复入：终始之地。 |
| <a id="p-lueli-shibian-xiang"></a>「夫應者，同誌之象也；位者，爻所處之象也；承乘者，逆順之象也；遠近者，險易之象也；內外者，出處之象也；初上者，始終之象也」 | 王弼《周易略例·明卦適變通爻》 | 定域 | 编码 | `Hexagram.opposed`<br>`Hexagram.holdsPlace`<br>`Hexagram.rises`<br>`Hexagram.falls`<br>`Hexagram.halves`<br>`Hexagram.betweenEnds`<br>`Hexagram.answers`<br>`Hexagram.sole_top_passes` | 六种关系在律中各有其结构：應是同一高度两爻相异；位是二至五位上爻与奇偶相合；承乘是缝之起落；內外是上下两体；初上是无定位之两端，一爻自此入、自此出。遠近只是两位之距，律中两爻之关系不依距离。“同志”“逆順”“險易”“出處”是读法，不在律中。 |
| <a id="p-lueli-tongbian-yingbi"></a>「近不必比，遠不必乖。同聲相應，高下不必均也」 | 王弼《周易略例·明爻通變》 | 相合 | 编码 | `Hexagram.answers`<br>`Hexagram.answers_symm`<br>`Hexagram.opposed_answers`<br>`Hexagram.alternates_answers`<br>`Hexagram.opposed` | 两爻之相应只依其值相异，不依其距：对应之位（相距三）之应与相邻之比，是同一关系在不同两位上的读法，近者不必相应，远者可以相应。邢璹注以初四、二五、三上为“同聲相應”：在两体中同一高度，高下在不同之体。 |
| <a id="p-lueli-mingtuan-zhu"></a>「一卦五陽而一陰，則一陰為之主矣。五陰而一陽，則一陽為之主矣」……「故陰爻雖賤，而為一卦之主者，處其至少之地也」 | 王弼《周易略例·明彖》 | 相合 | 编码 | `Hexagram.sole`<br>`Hexagram.sole_count`<br>`Hexagram.soleAny_count`<br>`Hexagram.sole_unique`<br>`Hexagram.sole_iff_flip`<br>`Hexagram.sole_places`<br>`Hexagram.sole_any_phase` | 一爻与其余五爻皆相异，恰在五阳一阴或五阴一阳之卦；此爻唯一，十二卦即纯卦之一爻变，六位各二。十二之中，在二至五位而当位者四，不当位者四，在初上者四：此关系不依位与正。“主”在此读作其余诸爻皆与之相应之爻；“賤”是等级，不在律中。 |
| <a id="p-lueli-xia-yiti"></a>「凡《彖》者，通論一卦之體者也。一卦之體，必由一爻為主。則指明一爻之美，以統一卦之義，大有之類是也。卦體不由乎一爻，則全以二體之義明之，豐卦之類是也」 | 王弼《周易略例·略例下》 | 定域 | 编码 | `Hexagram.daYou_answered`<br>`Hexagram.feng_no_sole`<br>`Hexagram.soleAny_count`<br>`Hexagram.none_sole`<br>`Hexagram.halves` | 大有六五与其余五爻皆相异；豐无此爻，彖以上下两体读之。律中有独应之爻者只十二卦，其余五十二卦没有：“必由一爻為主”在此十二卦成立；王弼于他卦所举之主（居中、得位、有应之爻）是其他关系。“美”“統”不在律中。 |
| <a id="p-lueli-lv"></a>「故《履》卦六三，為為兌之主，以應於《乾》。成卦之體，在斯一爻」 | 王弼《周易略例·略例下》 | 相合 | 编码 | `Hexagram.lv_sole`<br>`Hexagram.sole`<br>`Hexagram.answeredStatements_sole` | 履六三是卦中唯一之阴爻，与其余五爻皆相异；彖“說而應乎乾”读作此爻与上体乾之三爻皆相应。所存本作“為為兌之主”，衍一“為”字，照录。 |
| <a id="p-lueli-mingxiang"></a>「得意在忘象，得象在忘言」……「義茍在健，何必馬乎？類茍在順，何必牛乎？」 | 王弼《周易略例·明象》 | 定域 | 兼有 | `Learning.goAlike_iff_lumped`<br>`Hexagram.pairs_goAlike`<br>`Hexagram.yang_not_goAlike`<br>`Hexagram.betweenPhases_not_goAlike` | 意读作一个读法所能跟随者：一个读法可以只记其值而忘其构形，恰当律沿此读法同行（可归并）。一卦与其错之对是这样的读法；阳爻之数不是，二至五位之定位之正亦不是，后者须看初位所入之爻。“得意忘象”在律中只对同行之读法成立；马、牛之类的象不在模块之中。 |
| <a id="p-lueli-bianwei-rank"></a>「夫位者，列貴賤之地，待才用之宅也」……「位有尊卑，爻有陰陽」 | 王弼《周易略例·辯位》 | 相分 | 兼有 | `Hexagram.holdsPlace`<br>`Hexagram.atSites_glues_iff`<br>`Contextual.indexed_fits`<br>`Web.significance_undetermined` | 王弼以位为贵贱之列、才用之宅，位有尊卑。模块中的位是语境之索引，爻与位之关系（定位、当位）不带等级与判断，律亦不决定意义；理论不采贵贱尊卑之读（与《繫辭》“貴賤”“天尊地卑”之相分同）。 |
| <a id="p-lueli-mingtuan-zhizhong"></a>「夫眾不能治眾，治眾者，至寡者也」……「故眾之所以得咸存者，主必致一也」 | 王弼《周易略例·明彖》 | 相分 | 编码 | `Hexagram.answers_symm`<br>`Hexagram.sole_answered`<br>`Hexagram.sole_unique`<br>`Hexagram.answers_shown_along_run` | 律中一爻与其余五爻之关系是对称的：它与五爻皆相异，五爻亦各与它相异；关系中没有“治”之方向，也没有一个律使众爻之存依赖于此一爻。“治眾”“主必致一”是统治之读，理论不采；理论读关系本身。 |
| <a id="p-lueli-guale-yinwei"></a>「陽處陰位，謙也。故此一卦，皆以陽處陰為美也」……「故陽爻皆以居陰位為美」 | 王弼《周易略例·卦略》（履、大過） | 相分 | 兼有 | `Hexagram.inPhase`<br>`Hexagram.holdsPlace`<br>`Web.significance_undetermined` | 小象多以不当位为失，王弼于履、大過、大壯则以阳居阴位为美：同一关系（阳爻不当位）在不同之卦得相反之判断。律中只有关系，判断不由关系定；理论不采“美”之判断。 |
| <a id="p-wen-budang"></a>「道有變動，故曰爻；爻有等，故曰物；物相雜，故曰文；文不當，故吉凶生焉」 | 《繫辭下》第八章 | 相分 | 兼有 | `Hexagram.inPhase`<br>`Hexagram.atSites_glues_iff`<br>`Web.significance_undetermined` | 爻与位相当与否，是带位之索引的关系（正）。“爻有等”是等级；“文不當，故吉凶生焉”把不当读作吉凶之源。律中的关系不带判断，动力学不决定意义。 |
| <a id="p-zhongyao"></a>「若夫雜物撰德，辨是與非，則非其中爻不備」 | 《繫辭下》第七章 | 相合 | 编码 | `Hexagram.nuclear`<br>`Hexagram.inner`<br>`Hexagram.nuclear_inner`<br>`Hexagram.run_inner`<br>`Hexagram.nuclear_merges`<br>`Hexagram.nuclear_loses` | 中爻是第二至第五爻。互卦以二、三、四爻为下卦，三、四、五爻为上卦：互之所成恰由中爻定，起点中爻相同的两个历程自第一步起即为一个历程；初、上两爻一步即失，此律合并，永失一种可能。“辨是與非”是判断，不在律中：律所说的只是互卦所读之处，恰是中爻。 |
| <a id="p-xugua-shouwei"></a>「有天地，然後萬物生焉」……「物不可窮也，故受之以未濟；終焉」 | 《序卦》首尾 | 相合 | 编码 | `Hexagram.process_returns_iff_ends`<br>`Hexagram.nuclear_rests_iff`<br>`Hexagram.nuclear_two_fixed_one_cycle`<br>`Hexagram.run_in_attractor`<br>`Hexagram.entry_counts`<br>`Hexagram.basin_counts` | 互之律下恰有四个构形复返：乾、坤不变，既濟、未濟相代；一切构形至迟第二步即入此四者，不再离开，依三、四两爻，十六归乾，十六归坤，三十二入既濟、未濟之相代。此四者恰是所传卦序首二卦与末二卦。序卦以天地始，以未濟终而说“物不可窮”：互之律下，既濟、未濟相代而不止，不是静止。 |
| <a id="p-cuozong"></a>「參伍以變，錯綜其數」 | 《繫辭上》第十章 | 定域 | 编码 | `Hexagram.Symmetry`<br>`Hexagram.Symmetry.act`<br>`Hexagram.Symmetry.act_comp`<br>`Hexagram.Symmetry.comp_self`<br>`Hexagram.Symmetry.comp_comm`<br>`Hexagram.nuclear_act`<br>`Hexagram.nuclear_run_act`<br>`Hexagram.run_complement_apart`<br>`Hexagram.classOf_eq_iff`<br>`Hexagram.class_census`<br>`Hexagram.classes_goAlike`<br>`Hexagram.classes_not_goAlike_waxWane` | 经文的“錯綜”说的是数的交错综合；以“錯”名六爻皆变、以“綜”名倒转，是后世注家之用（明来知德）。脊柱所证的是后者：不变、錯、綜、錯而綜四者成一群，各为自身之逆，两两可交换；互之律与四者皆可交换，故四者各把互的每一历程送为互的历程，一卦与其錯卦的历程永不相遇；六十四卦分为二十类，八类各二卦，十二类各四卦，互同行于诸类之上，消息之律则否：倒转使它逆行。 |
| <a id="p-heng-gangshang"></a>「剛上而柔下」 | 恒·彖 | 相合 | 兼有 | `Hexagram.swap`<br>`Hexagram.yang_swap`<br>`Hexagram.across`<br>`Hexagram.passing`<br>`Hexagram.passUp`<br>`Hexagram.across_exchange`<br>`Hexagram.exchanges`<br>`Hexagram.named_exchanges`<br>`Hexagram.exchangesRun`<br>`Hexagram.exchangeWorld_balances`<br>`Hexagram.exchangeWorld_rise_fall`<br>`World.balances_iff_exchange` | 恒是泰之初、四两爻相易：初九之刚上至四，六四之柔下至初，一阳爻自下卦入上卦。两爻相易保持阳爻之数；下卦与上卦之间的相易是两卦之间交换之律的一步，其所移即一阳上行、下行或无；一切相易之历程读为世界皆平衡，一卦之数每一升皆有所给，每一降皆有所取。損是泰之三、上两爻相易，同为一阳上行（損下益上），其彖见[中国思想章](CHINESE-SOURCES-AND-BECOMING.md#p-tuan-sun-yi)。 |
| <a id="p-xian-roushang"></a>「柔上而剛下」 | 咸·彖 | 相合 | 编码 | `Hexagram.named_exchanges`<br>`Hexagram.passDown`<br>`Hexagram.three_iff`<br>`Hexagram.three_census`<br>`Hexagram.exchanges_keep`<br>`Hexagram.exchanges_run_total`<br>`Hexagram.exchanges_from_tai_pi` | 咸是否之三、上两爻相易：六三之柔上至上，上九之刚下至三，一阳爻自上卦入下卦；益是否之初、四两爻相易，同为一阳下行（損上益下）。三阳三阴之卦二十，恰是泰、否与由之下卦一爻、上卦一爻相易所得之十八卦，两两不同；自泰或否起，一切相易之历程不出此二十卦，两卦之数之和恒为三。彖于哪一卦取哪一种易，是读法，不在律中。 |
| <a id="p-yongjiu"></a>「用九：見羣龍无首，吉」……「用九，天德不可為首也」 | 乾·用九、象 | 定域 | 编码 | `Hexagram.Marked`<br>`Hexagram.Marked.settle`<br>`Hexagram.MarkedLines.settle`<br>`Hexagram.MarkedLines.shown`<br>`Hexagram.MarkedLines.onward`<br>`Hexagram.MarkedLines.all_nines`<br>`Hexagram.MarkedLines.settle_merges`<br>`Hexagram.MarkedLines.run_settled`<br>`Hexagram.MarkedLines.returns_iff`<br>`Hexagram.MarkedLines.drawn`<br>`Hexagram.MarkedLines.shown_not_goAlike`<br>`Hexagram.MarkedLines.onward_goAlike` | 用九读作六爻皆为老阳（九）之时（《左傳》昭公二十九年称此辞为“乾之坤”，未存于本库）：老爻变为其反而不再变，少爻不变，一步即定，此后历程静止；所示本卦乾，自第一步起历程所示为坤（之卦）。律对任一卦之老少皆成立，用九只是六爻皆变之一例。本卦不是此律所同行的归并：本卦相同，之卦可异；之卦则是。“見羣龍无首”“吉”是象与判断，不在律中。 |
| <a id="p-yongliu"></a>「用六：利永貞」……「用六永貞，以大終也」 | 坤·用六、象 | 定域 | 编码 | `Hexagram.MarkedLines.all_sixes`<br>`Hexagram.MarkedLines.run_settled`<br>`Hexagram.MarkedLines.returns_iff`<br>`Hexagram.MarkedLines.onward` | 用六读作六爻皆为老阴（六）：所示本卦坤，自第一步起历程所示为乾。《象》“以大終”读作终于阳（乾）；“利永貞”是判断，不在律中。 |
| <a id="p-tianzun"></a>「天尊地卑，乾坤定矣。卑高以陳，貴賤位矣」 | 《繫辭上》第一章 | 相分 | 编码 | `Hexagram.complement_complement`<br>`Hexagram.waxWane_complement`<br>`Hexagram.reverse_waxWane` | 构形中乾坤互为错卦，律与错交换、倒转则律逆行：结构不含尊卑；贵贱之位是理论不采的等级。 |
| <a id="p-guijian"></a>「三與五同功而異位，其遇不同：三多凶，五多功，貴賤之等也」 | 《繫辭下》第八章 | 相分 | 兼有 | `Hexagram.Place`<br>`Contextual.indexed_fits`<br>`Hexagram.odd`<br>`Hexagram.middle` | 位有别，是语境之索引：三、五同为奇位（同功），五居中而三不居中（異位）；位无等级。 |
| <a id="p-dade"></a>「天地之大德曰生，聖人之大寶曰位」 | 《繫辭下》第一章 | 相分 | 一般律 | `World.living_crosses`<br>`Web.significance_undetermined`<br>`livingSignificance_of_unrestricted` | 大德曰生是断言；理论中生起不定活着，生命意义只在延续条件之下成立；大宝曰位是等级。 |
| <a id="p-dayan"></a>「大衍之數五十，其用四十有九」……「以卜筮者尚其占」 | 《繫辭上》第九章、第十章 | 相分 | 一般律 | `Learning.no_prefix_fixes_next`<br>`Learning.diagonal_misses` | 数术不在脊柱之中：任一由有限记录给出预言的程序，都有其失误的历程。 |
<!-- passage-map:end -->

## 5. 几处要点

**无往不复与日新，是同一律的两层。** 泰九三“无往不復”，在有限构形之内，恰是律不合并时的定理（`Law.lossless_iff_returns`）：消息之律下每卦皆返。同一律带着历史读，则永不复返，也不被任何清单所含（`Law.withHistory_never_returns`、`Hexagram.kept_history_unlisted`）：构形复返，历史日新。两句不冲突，因为说的是同一展开的两种读法。律一旦合并，“无往不復”即失效：只入阴爻之律下，被吸入坤者不再回来（`wane_not_returns`）；“无往不復”的成立范围，就是不合并。

**穷则变不是普遍律。** 消息之律下，极则必转：乾之后即姤，坤之后即復。只入阴爻之律下，坤是吸收态，穷而不变。在依存之网上，失而不复之后，依存不变的形成不能延续（`Web.consumed_ends_when_fixed`），延续的形成必已改变其依存（`Web.consumed_continues_transformed`）。所以“變則通，通則久”的一半有律：能久者已变；“窮則變”的另一半没有：穷不保证变，也可以是终。

**一阴一阳的强度。** 生起与止息是一个变化的两种读法（`Web.change_readings`，依定义）。有限且活动可判定的世界中，生起反复恰当止息反复（`World.arising_iff_ceasing`）；把这一律不经判定地断言于一切有限世界，等价于排中律（`World.law_iff_em`）。若把“一陰一陽之謂道”读作对一切世界的全称之律，它恰与排中律一样强；在六十四卦这样逐爻可判定的世界上，它是定理（`Hexagram.world_arising_recurs`、`Hexagram.world_ceasing_recurs`）。

**象与易简：哪些读法承载律。** 象是一种归并。一种读法承载律，恰当律在其归并上同行（`Learning.goAlike_iff_lumped`）。六十四卦归为三十二对错卦，律仍是律（`pairs_goAlike`）；按阳爻多少归并，律就不再是律（`yang_not_goAlike`）：阳爻同为三的泰与否，下一步分属阳爻四与阳爻二。“易簡而天下之理得”在这里有确切的范围：简化得理，恰当简化是律所同行的归并。

**感与几：止于耦合所及。** 咸彖“咸，感也”与繫辭“感而遂通”，读作耦合：经水平耦合的条件，差别传入（`Web.observed_level_couples`）；耦合闭包之外，什么也不被区分（`Flow.uncoupled_beyond_coupling`），选择也不能及（`Flow.unselected_beyond_coupling`）。“通天下之故”于是恰止于耦合所及。几也是一样：断裂所系的条件若不以水平耦合入读法，则断裂之前，没有经耦合而入的东西界定断裂有多远（`Web.break_not_bounded`），经耦合的策略只在失败之后动用更大储备（`Flow.policy_uses_after_failure`）。“知幾其神乎”说的难处，在这里是一条律：几的先见，只在相关条件已耦合入读法时可能。这也是文言“亢之為言也，知進而不知退”的结构：只知进者，所失只在断裂时登记。

**生生之谓易：变化比生生宽。** 理论中的变化包括生成与退化，两者不重叠；生生是生成之持续（D1），不是任何新的组织。只入阴爻之律是一种变化，它合并、失去可能（`wane_drawn`、`wane_loses`）。活着跨越生起与止息，不由二者的反复决定（`World.living_crosses`）。生成之持续有其条件：在有计数、有承载、平衡且耗散的世界中，无尽的生起排除从某步起每步封闭（`World.arising_opens`）；耗散、被围住而成员不断生起的有限族，不能从某步起每步都无外部供给（`Web.embodiedArising_fed_from_beyond`，双重否定的形式）。所以“生生之謂易”在理论中是定域：易（变化）不尽是生生；生生是变化中的一种历程，有它的条件。

**自强不息与外部供给。** “天行健，君子以自強不息”是劝勉，不是本体论断。若把“自强”读作只凭自身而不息，平衡而耗散的交换中没有这样的部分：持续者由外部供给（`Flow.fed_from_beyond`）。若读作在耦合之中尽其自身之分，则与理论相合。

**道器：律由展开读出。** 一历史所显之律，是它所属的最小律（`shown_le_iff`）；带着历史的运行所显之律，只容纳此历史（`Run.keepHistory_shown`）；某一决定之律容纳一历史，恰当此历史自洽（`exists_law_iff`）。律不先于其所行之展开，也不在展开之外另成一实在。这与王夫之“道者器之道”相合；“形而上者謂之道”读作器外另一实在，则与理论相分。

**正是位与爻的关系，不是爻的性质。** 一爻之值不变，其正随其位：消息之律下每爻带着其值上升，每升一位其正即翻转，只在上爻以其反入初位之处保持（`inPhase_waxWane_above`、`inPhase_waxWane_bottom`）。乾彖“六位時成”在这里有确切的读法：一爻所示，依其所处之位与时。所以正写作在位上成立的语境读法（`atSites`），它粘合为对整卦的一个读法，只在六爻皆正（既濟）或皆不正（未濟）之处（`phases_glue_iff`）。

**应由正而定。** 同一高度的两位奇偶相反，所以两爻相应，恰当二者同正或同不正（`opposed_iff_phase`）。未濟彖“雖不當位，剛柔應也”所说成立，“雖”所设的对立则不成立：六爻皆不当位，三对便皆相应（`out_of_phase_opposed`），前者蕴涵后者。这是定域。

**应是两个语境之间的差。** 把下卦与上卦读作两个语境，每卦示其各高度之爻（`halves`），两卦粘合，恰当没有一个高度相应（`halves_glues_iff`）。艮彖“上下敵應，不相與也”是粘合的一面：两卦处处所示一致，没有一处相应。咸彖“二氣感應以相與”是另一面：三个高度皆相应，两卦处处所示相异，“相與”经由相异，而不是合一。相应之处，一个高度之爻在两卦中是两个主张；所以任何过程之下，没有去语境的框架合于诸高度，带语境索引的框架则合（`halves_no_free_frame`、`halves_indexed`）。应不是一个语境之内的矛盾，而是两个语境在一处的差。

**哪一种位之读法承载律。** 当位之数每一步改变奇偶，自乾依次为三、二、三……（`phase_qian_orbit`），却不是律所同行的归并（`phaseCount_not_goAlike`）：乾、坤各有三爻当位，下一步一为二、一为四。三处之应则服从三格上的同一消息之律（`opposition_waxWane`），是律所同行的归并（`opposition_goAlike`）：三步使每一处应翻转，六步复原。这与上面“象与易简”是同一条律：一种读法承载律，恰当律在其归并上同行。逐位之正所失太多，逐高度之应恰好不失。

**错与一爻之变。** 错使每一爻之正翻转，而保持每一处应与比（`inPhase_complement`、`opposed_complement`、`alternates_complement`）：互为错卦的两卦，当位之数相加为六，应之格局相同。一爻之变只动该位之正与其高度之应（`inPhase_flip_self`、`opposed_flip_self`、`opposed_flip_other`）。

**四项普查：经文在这些关系上是否一致。** 小象明言位者二十七处，二十六处与奇偶相合，且都在三、四、五位；言中正、正中者十处，九处是居中而当位之爻；言乘刚者五处，皆是阴在阳上；彖言剛中而應者五处，皆是中之高度相应。普查由检查脚本在所存六十四页中找出这四类明言的全部，与 Lean 的清单逐一比较，Lean 在其卦上检查清单的每一项（`placeStatements_agree` 等）。所以这不是挑选出的例证：除两处之外，经文在这四类明言中一致使用这些关系。两处例外是需上六与艮六五，见 §6；需上六在第二个关系下相合，见下。

**初上无位：经文言位所用的关系。** 王弼《辯位》说：文言谓乾上九“貴而无位”，小象谓需上六“雖不當位”，一阳一阴；上位若有奇偶，二者必有一个当位（`top_no_parity`）。所以初、上无定位。模块把它写作二至五位上的第二个关系（`fixedPhase`、`holdsPlace`），在 `inPhase` 之旁，不取代它。以此读之，小象明言位者二十七处与乾上九皆成立，没有例外（`placeStatements_hold`）；彖言整卦之位者五处皆成立，以六位之奇偶读则只成立两处：蹇“當位”、漸“進得位”之初爻不当位，歸妹“位不當”之初、上两爻反而当位（`tuanWhole_between`、`tuanWhole_six`）。中间四爻皆当位者四卦（既濟、蹇、漸、家人），彖于四卦皆言位或正（`allHold_iff`）。二至五位之奇偶也由经文之言定出（`statements_fix_parity`、`centre_fixes_parity`）。所以彖与象言位，用的是第二个关系。需上六依六位之奇偶当位，与象相分（`xu_top_inPhase`）；依第二个关系不在位，与象相合（`xu_top_no_place`）：表中由相分改为相合。两个关系不互相修正，`inPhase` 说六位之奇偶，`holdsPlace` 说经文言位所用之关系。

**两端是出入之处。** 定位不说两端，两端却不是无关：一爻在初或上变动，二至五位之定位不动，其旁之缝与其高度之应翻转（`ends_not_told`、`changes_run_ends`）；消息之律下，初位所入之爻升至二位，才取得定位之正，其正是它在初位之奇偶之反（`fixedPhase_waxWane_enters`），此后升至五，恰在两位在位（`run_course_between`）。所以定位之正不是律所同行的归并（`betweenPhases_not_goAlike`）：要跟随它，须看两端。王弼说“初上者，始終之象也”“是終始之地也”，在这里读作：两端不定位，而是一爻进入与离开之处，定位之变由此而来。

**一爻与其余诸爻：独应。** 两爻之应只依其值相异，不依其距（`answers`）；对应之位之应与相邻之比都是它（`opposed_answers`、`alternates_answers`）。一爻与其余五爻皆相异，恰在五阳一阴或五阴一阳之卦，其爻唯一（`sole_count`、`sole_unique`）。小畜、大有之“上下應之”，比之“上下應”，夬之“柔乘五剛”，履六三之“成卦之體，在斯一爻”，都是这一关系（`answeredStatements_sole`、`guai_iff`、`lv_sole`）。它比对应之位与相邻之位宽；Y2 写为定域的小畜、夬两段现在相合，大有一段因“尊位”仍为相分。独应不依位与正：十二卦中，在二至五位当位者四、不当位者四，在两端者四（`sole_places`）。

**独应不延续一步。** 消息之律下，有独应之卦一步之后没有独应（`soleAny_waxWane`），六步之后在原位复回（`sole_six`）；在上位之独爻升出，留下六爻皆同的纯卦，两步之后独爻自初位复入（`sole_top_passes`）。一爻之变下，变独爻即得纯卦，纯卦变一爻即得独应（`changes_run_sole`）。王弼以“主”读独应之爻：“夫眾不能治眾，治眾者，至寡者也”。律中此关系是对称的，此爻与五爻皆相异，五爻亦各与此爻相异（`answers_symm`）；没有“治”之方向，“主必致一”也不在律中：五十二卦没有独应之爻，王弼于此以“二體”读之，豐是其例（`feng_no_sole`）。所以表中“主”之读分为两段：一爻与其余诸爻之关系相合，“治眾”相分。

**爻辭与大象：言中、言位之处。** 爻辭言“中”者十一爻，皆在二至五位，五爻居中；言“中行”者五爻，只泰九二、夬九五居中（`lineTextMiddle_places`）：爻辭之“中”多是中间，不都是居中之位。爻辭言位只萃九五“萃有位”，在位（`lineTextPlace_holds`）。大象言“中”者八处，每处是下卦之象在上卦之象之中（地中有水、澤中有雷之类），是两体之关系；言“位”者二处，鼎“正位凝命”、艮“思不出其位”，是君子之位，不是爻位。小象言“中”者五十一爻，四十七爻居中，其余四处（泰六四“中心”、復六四“中行”、震上六“中未得”、豐九四“日中”）不是居中之读。这些普查由检查脚本在所存六十四页中找出：彖与爻辭之清单与 Lean 的清单比较，大象与小象之“中”与脚本所记之例外比较；每项都以变异检验过。

**中爻与互：一卦所归，由三、四两爻定。** 繫辭下“若夫雜物撰德，辨是與非，則非其中爻不備”，在互之律中有确切的读法：互之所成恰由中爻定，初、上两爻一步即失（`nuclear_inner`、`nuclear_merges`）；再一步，二、五两爻也失，只余三、四（`nuclear_two`）。所以一卦在互之下归于何处，由三、四两爻定：乾、坤，或既濟、未濟之相代（`basin_iff`）。“辨是與非”是判断，不在律中。互的这四个归宿恰是卦序首尾四卦（`process_returns_iff_ends`）：序卦以天地始，以未濟终而说“物不可窮也”，而互之律下既濟、未濟相代不止，是环而不是静止。这只是卦序上检查过的事实，不说卦序由互而排。

**之卦：本卦不承载律，之卦承载。** 老爻变而少爻不变，一步即定（`MarkedLines.run_settled`）。本卦相同，之卦可异：乾而六爻皆少，仍为乾；乾而初爻为老，则为姤（`MarkedLines.shown_not_goAlike`）。所以占得之本卦，对此律不是足够的读法，之卦是（`MarkedLines.onward_goAlike`）。这与“象与易简”是同一条律：一种读法承载律，恰当律在其归并上同行。“易窮則變，變則通，通則久”在此律之内成立：老（穷）则变，变后为少，不再变（久）；它在一切律上不成立，见上文“穷则变不是普遍律”。

**錯綜：同一组对称，对一律是归并，对另一律不是。** 互与錯、綜皆交换，所以二十类是互所同行的归并（`classes_goAlike`）；消息之律与錯交换，倒转却使它逆行，所以它不同行于诸类（`classes_not_goAlike_waxWane`）。读法是否承载律，取决于律。孔穎達“非覆即變”在此更确切：倒转不变之八卦，恰是卦序以變相配者（`turn_fixed_iff`）。

**不合并保证复返，不保证可达。** 消息之律不合并，每卦皆返，却分为六轨：绕行一周之爻变是守恒之数，取一、三、五（`changesAround_values`），所以十二消息卦之轨到不了既濟（`qian_not_reach_jiJi`）。加一之律同样不合并，却只一轨，任一构形可由任一构形得到（`addOne_reach`）。

**卦序：有律运行它，但只是一张表。** 卦序每卦恰列一次，所以取每卦至其下一卦之律运行它（`orderNext_runsOrder`），以未濟复归乾者不合并，六十四卦成一轨（`orderNext_one_orbit`）；本章先前在 §8 说“卦序本身不是任何律的轨道”，此说不确。确切的说法是：运行卦序之律除未濟一处外都相同（`runsOrder_agrees`），每一爻皆读每一爻（`runsOrder_reads`），不与錯、綜或二者交换（`runsOrder_not_commutes`），所以三格局部之律、消息之律、诸位重排加掩码之律都不运行它（`ringRule_not_runsOrder`、`waxWane_not_runsOrder`、`rearrange_not_runsOrder`）。对内每一步是一种对称的一步（“非覆即變”），对与对之间没有对称可循：序卦“物不可以終否，故受之以同人”一类，是加在次序上的言说之理，不是构形承载的律（[对间之句](CHINESE-SOURCES-AND-BECOMING.md#p-xugua-between-pairs)）。序卦在对内所说则与律相合：“剝窮上反下”是直接轮转六位的一步，由剝至復（`bo_fu`），与倒转所得相同（[对内之句](CHINESE-SOURCES-AND-BECOMING.md#p-xugua-within-pairs)）。

**卦变是交换之律的一步。** 損彖“損下益上”、益彖“損上益下”、恒彖“剛上而柔下”、咸彖“柔上而剛下”，都是上下两卦各一爻相易：阳爻之数不变，其所移是一阳上行或下行（`named_exchanges`、`across_exchange`）。这正是脊柱上两者之间交换之律的一步：一卦所得即另一卦所失，相易之历程读为世界则平衡（`exchangeWorld_balances`、`exchangeWorld_rise_fall`）。損、益之名说的是上下两卦之得失，全卦之数不变（[損益彖](CHINESE-SOURCES-AND-BECOMING.md#p-tuan-sun-yi)）。三阳三阴之二十卦恰由泰、否一易而得（`three_iff`）。彖于哪一卦取哪一种易是读法，不在律中；后世卦变之说未存于本库（§8）。

**奇偶承载律，数不承载。** 按阳爻之数归并，消息之律不同行（`yang_not_goAlike`）；按其奇偶归并，消息之律与一爻之变都同行，因为每一步奇偶皆翻转（`yangOdd_goAlike`、`yangOdd_goAlike_changes`）。这与上文“象与易简”是同一条律：所失更多的读法反而承载律。繫辭下“陽卦多陰，陰卦多陽，其故何也？陽卦奇，陰卦偶”，在三爻之卦上恰是阳爻之数的奇偶，以画数计亦同（`odd3_iff`）；一爻之变使其所在之卦阴阳互换，另一卦不动（`changes_run_trigram`）。“多陰”“多陽”说数，不承载律；“奇”“偶”承载（[繫辭下第三章](CHINESE-SOURCES-AND-BECOMING.md#p-xici-yanggua-qi)）。互之律不同行于奇偶（`nuclear_yangOdd_not_goAlike`）：一种读法承载哪一律，依律而定。

**杂卦与八站：两种排列，一种结构。** 杂卦保留所传卦序的三十二对，只换对与对之间的次序，末八卦把四对交错（`zagua_partners`、`zagua_last_eight`，[杂卦](CHINESE-SOURCES-AND-BECOMING.md#p-zagua-pairs)）：对是两种次序共有的结构，对与对之间的次序是各自的排列。说卦第三章“天地定位，山澤通氣，雷風相薄，水火不相射”的四对皆是錯；第五章“帝出乎震”之八站，相对的四对只有離、坎是（`Trigram.opposite_stations`），运行八站之律也不与任何对称交换（`Trigram.stations_not_commutes`，[帝出乎震](CHINESE-SOURCES-AND-BECOMING.md#p-shuogua-di-chu-zhen)）。同一说卦之中，第三章的排列承载錯之结构，第五章的不承载。

**消息无止；泰否之交。** 消息之律没有静止之处，其运行不在任何一步静止，也不从某步起归于静止（`never_comes_to_rest`）：既濟彖“終止則亂”所说的止，在此律中不出现（[既濟未濟彖](CHINESE-SOURCES-AND-BECOMING.md#p-tuan-jiji-weiji)）。泰彖“天地交而萬物通”、否彖“天地不交而萬物不通”：否是泰之錯再倒转，凡錯所保持的读法（应、比、所属之对、奇偶）沿二者之运行每一步都读二者为相同（`kept_alike`、`tai_pi_runs`）；交读下卦之阳与上卦之阴为一个方向，才区分二者（`meets_tai_pi`）。泰否之别不在錯所保持的任何结构中，而在读入两值的上下之向（[泰否彖](CHINESE-SOURCES-AND-BECOMING.md#p-tuan-tai-pi-jiao)）。

## 6. 相分之处

- **继之者善，天地之大德曰生，復见天地之心。** 易传把善、大德与心归于天地之行。理论中动力学不决定意义：无物有意义与万物有意义，动力学两者都不排除（`Web.significance_undetermined`）。生命意义只在延续条件（`Unrestricted`）之下是定理（`livingSignificance_of_unrestricted`），此条件在理论中明示而不断言，其根据开放。
- **天尊地卑，贵贱位矣；三多凶，五多功，贵贱之等；圣人之大宝曰位。** 构形之中乾坤互为错卦，律与错交换，倒转则律逆行：结构里没有尊卑。位有别，是语境的索引（`Contextual.indexed_fits`），不是等级。贵贱之位是社会等级，理论不采。
- **柔得尊位；爻有等，文不當，故吉凶生焉。** 大有彖以五为尊位，繫辭下以爻有等级、文之不当为吉凶之源。模块中，正是爻与位之间不带判断的关系，位之有别是语境的索引；动力学不决定意义（`Web.significance_undetermined`）。与上一条贵贱之位同，不采。
- **需上六“雖不當位”，依六位之奇偶。** 上六阴居偶位，依六位之奇偶当位（`xu_top_inPhase`），象却说不当位。王弼《辯位》以此与乾上九“貴而无位”为初、上无定位之证；模块把初上无位写作二至五位上的第二个关系，此句在其下相合（`xu_top_no_place`，§5），表中为相合。依六位之奇偶的相分如其所是地保留。
- **艮六五“以中正也”。** 六五阴居奇位，依奇偶不当位（`gen_fifth_out_of_phase`）；此“正”读作因得中而正。模块中中与正是两个关系，不以中代正。
- **位者，列貴賤之地；眾不能治眾，治眾者，至寡者也。** 王弼以位为贵贱之列、才用之宅，以独应之爻为“主”而“治眾”。模块中位是语境的索引，独应是对称的关系，没有治之方向（`answers_symm`）；与上面贵贱之位同，不采。
- **陽處陰位為美。** 卦略于履、大過、大壯以阳居阴位为美，与小象多以不当位为失相反：同一关系在不同之卦得相反之判断。判断不由关系定（`Web.significance_undetermined`），理论不采。
- **大衍之数，卜筮尚占。** 数术与占筮不在脊柱之中。任一由有限记录给出下一步的程序，都有它失误的历程（`Learning.no_prefix_fixes_next`、`Learning.diagonal_misses`）；知来只在历程有界、读法为律所同行之处成立。

## 7. 读法的标注与依据

本章的读法都是 AI 读法。它们依 D45 在理论的一个说明中成立：经文是这些词句意义的证据，读法是否站得住，由它在理论中的位置论证。Ren 的话是来源。“七日來復”依消息卦的读法，这只是诸读法之一；“周流六虛”读作消息之律下爻的升降，“兼三材而兩之”只取六位二值的结构。爻位之关系：正依位之奇偶，六位一律；应依同一高度的上下两位；比依相邻两位之间的缝，承、乘依其方向；中依二、五两位。初上无位依王弼《辯位》读作二至五位上的第二个关系，在六位之奇偶之旁；小畜、大有、比之“上下應”，夬之“柔乘五剛”与履六三之“成卦之體”，读作一爻与其余五爻皆相异之独应；“主”只取此关系，不取“治”（[D53](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d53-初上无位与独应之读--the-readings-of-the-fixed-places-and-the-sole-line)）。凡读法超出 Lean 所证者，表中写明不在律中。互、之卦与錯綜之读（[D51](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d51-卦之诸律的读法--the-readings-of-the-hexagram-laws)）：中爻依二至五爻；互读作律而迭用，传统多只取一步；老少依九、六为老、七、八为少，用九、用六读作六爻皆老（《左傳》昭公二十九年称乾之用九为“乾之坤”，未存于本库，未核对）；錯、綜之名依后世注家（明来知德），经文“錯綜其數”说的是数，表中写为定域。传中诸排列之读（[D55](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md#d55-传中诸排列之读--the-readings-of-the-arrangements-of-the-傳)）：序卦在对与对之间的理由读作加在清单上的言说，不读作构形承载之律；彖之“損下益上”“剛上而柔下”之类读作上下两卦各一爻相易，損、益之名读作两卦之得失；“陽卦奇，陰卦偶”读作阳爻之数的奇偶；“交”读作在两值之间读入的上下之向（下阳上阴）；说卦第五章之八站只取其次序，不取其时与方。

## 8. 未做之事

- 序卦为卦序所给的理由：模块已证明何种律运行卦序（§2 末、§5），以及首尾四卦恰是互之律下复返者（`process_returns_iff_ends`）；对与对之间的理由是言说，不在律中。脚本另算的部分相合（三格局部规则最多 63 步中 9 步，置换加掩码之律最多 28 步；八站分别为 8 步中 5 步与 4 步）未写成 Lean。
- 大衍筮法中老少之爻的概率：之卦之律只说老少已定之后；《左傳》、京房的互体与卦变之说（模块只写两爻相易之律与彖所名四卦），以及来知德的錯綜之说，未存于本库。
- 邵雍先天之序（以初爻为最高位的加一之律，自乾逐一递减至坤）只在模块文档中说明，未写成定理；互在 Y2 之位上的读法。
- 吉凶悔吝与卦爻辞的判断、说卦的取象与方位、卦气与纳甲。
- 王弼《周易略例》已存入本库（§1），“初上无位”与“一爻为主”之读已写入并与其文对照（§2、§5）。未做的：王弼《周易注》未存，其逐爻之读未对照；邢璹之注除明彖外未与王弼之文分开标记；王弼于独应之外所举之主（居中、得位、有应之爻），以及“時”与“位”合读（明卦適變通爻“卦者，時也”），未写入；明象之“忘象”只在一条读法中对照。
- 普查已及彖、小象、爻辭与大象中言位、言中之处；文言中言位、言中之处未普查。
- 与刻本的对校；历代注疏的系统比较（王弼、程颐、朱熹的读法未逐一对照）。
- 一个独立的审读。

## 9. 怎样检查

```bash
python3 -B _process/research/2026-10-05-generative-foundation-review/root-foundation/development/y1-changes/verify_mapping.py
```

模块的证明由核心检查器检查（`check_becoming.py`），其收据列出每个声明与空的公理依赖。
