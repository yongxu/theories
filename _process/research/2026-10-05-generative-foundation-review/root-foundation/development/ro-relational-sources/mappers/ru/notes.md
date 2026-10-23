# The 儒家 line, 论语 to 戴震, mapped onto the Becoming spine (slice `ru`)

AI mapping, read-only, 19 October 2026. Every reading here is the AI's. Fragments are copied from the 观其会通 atlas v9.1 (`evidence/texts/*.txt`) or the 易道 package v1.3; one fragment, 郑玄's note, is not in either atlas and carries `needs_source`. All declarations were checked against the current `Becoming/*.lean` files (index rebuilt after `RelativePosition` landed), and all record ids against `theories/becoming/results/records/`. `entries.json` has 50 entries: 17 agreement, 21 scope and 12 divergence, three of them with gaps.

## 1. The slice's relational structure

The thesis under test is that one relational ontology runs through Chinese thought. In this line it holds for the **starting point** and fails for **three recurring overlays**.

**The starting point is relational, and consistently so.** 仁 is placed in persons relating, not in a person:
- 仁者人也 (中庸), with 郑玄's gloss of 人 as the 人 of 相人偶;
- 谭嗣同's "人於人不相偶，尚安有世界";
- 己欲立而立人 and 能近取譬 (论语);
- the response to the child at the well (孟子);
- 推恩 and 扩而充之.

The Song–Ming writers widen the relation to the whole:
- 民吾同胞，物吾与也;
- 仁者以天地万物为一体;
- 天地之间，只有一个感与应而已;
- 太虚即气, where gathering and dispersing are one continuum.

荀子 and 戴震 add the most structural relational claims:
- names have no fixed fit (名无固宜);
- seeking without a measured bound exhausts what it draws on (求而无度量分界则不能不争);
- the joint holds through division (群…分);
- nature is formed by accumulated practice (虑积焉，能习焉，而后成谓之伪);
- 理 is the rule of desires themselves and feelings not missing (欲，其物；理，其则; 理也者，情之不爽失也).

**Three overlays recur, and they are where the thesis fails.**

1. **A centred gradient.** The relations are real, but a measure centred on a self or a rank is laid over them:
   - 亲亲之杀，尊贤之等，礼所生也 (中庸);
   - 亲亲而仁民，仁民而爱物 (孟子);
   - 贵贱有等 (荀子 礼论);
   - the household ranking that follows 民吾同胞 in the 西铭.
2. **A prior, valued nature or a prior 理.** A value or a law is fixed before any relation:
   - 人性之善也，犹水之就下也;
   - 人之性恶 (with 杨倞's gloss 矫其本性);
   - 性即理也…未有不善;
   - 朱熹's 理与气决是二物 and 先有理后有气.
3. **天 as a will or a single centre:**
   - 董仲舒's 天意, which installs 王 to complete everyone's nature;
   - 荀子's own 制天命而用之, which turns the relation to the rest into mastery;
   - in a weaker grammar, 朱熹's 安得谓天地无心.

So, read in its own texts, the line is relational in what it starts from and what it observes. It is often non-relational in how it measures and grounds. The line also contains its own correctives, which makes the test sharper:
- 荀子's 天行有常 and 孟子's 天不言，以行与事示之 answer 天 as will;
- 牛山 and 王夫之's 命日新而性富有 answer the fixed nature;
- 戴震 answers 朱熹's 理 and the 以理杀人 that a centred 理 licenses;
- 王夫之's 目所不见非无色也 answers 心外无事.

## 2. The strongest correspondences

These are structural matches: the same relation, condition and direction, not shared words.

- **荀子 礼论's bound (`ru-xunzi-li-qi-yu-fen`).** "求而无度量分界，则不能不争；争则乱，乱则穷" together with "两者相持而长" is the spine's joint-excess law and its converse.
  - Each step of joint excess lowers the level and ends what depends on the condition (`Flow.joint_excess_ends`).
  - Own counts miss joint excess (`Exceeding.own_not_joint`).
  - Joint taking within what is given keeps the level (`Flow.level_kept`).
  - 荀子 also locates the bound on the relation between 欲 and 物, not on either side, as the spine does.
- **荀子 名无固宜 with 同则同之，异则异之 (`ru-xunzi-ming-wu-gu-yi`).** Both halves have laws, and they do not conflict.
  - Labels carry nothing: a renaming keeps every relationally defined reading (`Web.rename_*`).
  - A naming that tells apart what is alike in every relation does not make sense (`Twins.naming_not_identifiesAlike`).
  - A description carries a law exactly where what it lumps goes alike (`carries_law_iff`).
- **荀子's 伪 as formed rule (`ru-xunzi-zheng-ming-wei-cheng`).** The rule changes only at reading steps (`Pace.rule_at_reading`), and the state has a law of its own only where the rule makes no difference (`adaptive_state_law_iff`). This is the cleanest answer the line gives to "fixed or formed": formed.
- **戴震 on 理 (`ru-daizhen-li-qing-yu`, `ru-daizhen-yi-li-sha-ren`).**
  - 理 as the rule of 欲 is a law read off what happens, not a second reality.
  - 理 as 情之不爽失 is a lumping that is right exactly where what it lumps goes alike (`Learning.lumped_right_iff`). A 理 that ties together what feelings separate cannot select rightly (`selects_not_right_of_parted`).
  - 以理杀人 is one position's model applied with the others' registration cut off (不能以天下之同情…达之于上). Pooling the others' coupling closes that gap (`Clearing.pool_closes_gap`).
  - This is the line's internal answer to 朱熹.
- **周敦颐 势 (`ru-zhoudunyi-shi`).** Three parts of the passage each have a law.
  - "极重不可反" is attraction: what is drawn in never returns (`Law.DrawnInto.never_back`).
  - "识不早，力不易" is closing a difference within as many turns as the difference, with that bound exact (`Widening.closes_within`, `closes_within_exact`).
  - The difficulty of recognizing is that nothing coupled in bounds the distance to the break (`Web.break_not_bounded`).
- **见牛未见羊 (`ru-mengzi-jian-niu-wei-jian-yang`).** Selection is blind beyond the coupling closure, the actor's own act included (`Flow.unselected_beyond_coupling`, `Flow.act_unselected`). Mencius' advice to keep away from the kitchen is the spine's narrowing of coupling: it keeps no ox or sheep alive and only keeps the response from forming.
- **和而不同 (`ru-lunyu-he-er-bu-tong`).** Difference is what a pool adds (`Web.pool_adds`), while merging loses a possibility (`Law.Merges.loses`). 学记's 相观而善 and 独学而无友则孤陋 have the same structure; they are not entered separately.
- **The 大学 chain, split by direction (`ru-daxue-ben-mo`).**
  - The necessity direction holds: "其本乱而末治者否矣" follows because what holds within a region holds within every region inside it (`Web.AdmitsWithin.narrow`).
  - The sufficiency direction ("身修而后家齐…") fails in general. A part can keep everything within itself and its source while losing beyond (`Clearing.loses_beyond`). Guards keepable each need not be keepable jointly (`ChoicePoint`). An outer relation can be held by the whole and by no part (`whole_not_in_pairs`).
  - This splits the passage exactly. It also agrees with the atlas's own caution that the order is not an empirically shown universal causal chain.

## 3. Divergences and non-relational strands

- **差等 (`ru-zhongyong-qinqin-zhi-sha`, `ru-mengzi-qinqin-renmin-aiwu`).**
  - The nesting is real: the feeding closure lies within the influence closure.
  - Reading the nesting as a gradient of significance is not a theorem. Under the continuation condition mixed parts are unordered (`Transfer.unordered`, "ordering it needs a measure"). Bounded centres disagree (`Clearing.centers_disagree`). Under the invariance step, significance within a boundary holds only by holding for everything.
  - Mencius' series does reach 物 and excludes nothing, so it is wider than a self-bounded reading. The divergence is the grading, not the scope.
- **荀子 贵贱有等 (`ru-xunzi-gui-jian-you-deng`).** 礼 is said to keep rank as well as nurture. On the spine:
  - relative position is zero-sum by counting (`RelativePosition.positions_balance`, `rise_needs_fall`);
  - what ends a part in a race is its dependence, not its position (`Flow.ends_at_race_end`);
  - continuation needs only joint taking within what is given.

  "分" (dividing what each takes and does) is kept apart from "等" (rank). Only the second diverges.
- **Valued natures (`ru-mengzi-xing-shan`, `ru-xunzi-xing-e`, `ru-chengyi-xing-ji-li`).**
  - 性善, 性恶 and 性即理…未有不善 all give the given a value before relations. The represented dynamics fix no significance (`Web.significance_undetermined`).
  - The divergence is symmetric between 孟子 and 荀子, and each answers itself elsewhere: 孟子 with 牛山 ("此岂山之性也哉", agreement), 荀子 with 化性起伪.
  - 杨倞's 注 "矫其本性" is stronger than 荀子's 经 and is kept as a separate layer inside the entry.
- **理先气后 (`ru-zhuxi-li-qi-er-wu`).** This is the clearest two-realities structure in the slice, cited through 戴震's 注 from 朱子's 语录:
  - "理與氣決是二物";
  - "疑此氣是依傍道理行";
  - "若有理則止是個淨潔空闊底世界".

  On the spine, process and frame are readings of one unfolding. A law given before the histories adds only steps never taken (`same_histories_iff`). 朱熹 hedges ("不消如此說…皆不可得而推究"), so the priority is logical, not temporal, but even logical priority is not something the theory sets up. The 本义 line "隂陽迭運者氣也其理則所謂道" reads 理 as the pattern of the course and is entered as scope. 朱熹's placing of 理 above form (CL-ZX-014) is the divergent half.
- **天 as will (`ru-dongzhongshu-tian-yi`).** "王承天意以成民之性為任者也" makes 天 an agent with intent and gives the formation of others' nature to one centre. This is the opposite of 荀子 天论 (agreement) and of 孟子 万章上 (agreement with the 天与之 grammar left over). 朱熹's "无心之心" sits between them and is entered as scope.
- **Mastery (`ru-xunzi-zhi-tian-ming`).** "制天命而用之" reads the rest as material for one part. It conflicts with the reach laws (`Flow.beyond_influence`, `Clearing.loses_beyond`). This is a case of what the brief calls "a contest to win" toward the rest, not toward other people.
- **The self containing the whole (`ru-wangyangming-xin-wai-wu-li`, and in part `ru-mengzi-wanwu-jiebei-jinxin`).**
  - 心外无事, as a general claim, diverges: a difference nothing reads is still there though carried nowhere (`unread_carried_nowhere`), and no frame realizes every claim about itself (`Frame.self_incomplete`).
  - 万物皆备于我 is split. The self made of its relations holds (`Flow.region_not_a_cut`). The self's reading exhausting the whole does not.
  - 陆九渊's 宇宙便是吾心 has the same structure. It is not entered, to stay within 50 entries.
- **Status, not content (`ru-chenghao-yi-ti`, `ru-chenghao-sheng-yi`).**
  - 程颢's 一体 and "万物之生意最可观…斯可谓仁也" agree in content with what holds under the continuation condition (`unrestricted_iff_presupposed_along`, `g0_of_unrestricted`, `Web.widens_iff_retains_adds`).
  - They diverge in status. 程颢 states as recognized fact what the theory holds as an unasserted condition plus the step of invariance. The condition orders nothing by itself; ranking lies in C and in invariance.
  - 王夫之's citation "程子謂「雞雛可以觀仁」，觀天地化機之仁也" (V4SO001) is the same move on another layer. 程颢's own text of 观鸡雏 is not in the atlas.

## 4. How the earlier repository studies stand

All three were written 6–7 October in older vocabulary, before the spine's present modules. They are kept as scope and history. They are superseded as entry points for the passages entered here.

- **[WANG-YANGMING.md](../../../../../../../../theories/becoming/history/WANG-YANGMING-2026-10-23.md)**
  - What it is: a holistic reconstruction of 致良知, 知行合一 and 心即理. It rests on `SituatedPractice.lean` (under `experiments/integrated-correction/general-framework/generative-basis/noninstrumental-concern/`), which has 12 declarations, 8 of them with empty axiom reports, and a `Fits` judgement on whole histories whose ethical standing the chapter itself says the definition does not establish.
  - **Kept:** its main finding, that the 心即理 of conduct concerns the responding side of a relation and is not an ontology of mind, and its counter-reading section.
  - **Extended:** 知行合一 now links to the experiment laws (a move taken is fixed, an untaken one is not; `ru-wangyangming-zhi-xing-he-yi`). The general form of 心外无事 is recorded as a divergence with spine witnesses (`ru-wangyangming-xin-wai-wu-li`).
  - **Superseded:** its non-spine module and older terms ("本然良知", "生成核心") as the formal entry point. A spine port of `SituatedPractice` would be needed before the chapter's formal claims could be cited as spine results.
- **[LIANGZHI-EVOLUTION.md](../../../../../../../../theories/becoming/history/LIANGZHI-EVOLUTION.md)**
  - What it is: the evolution of 良知 through transmission, development and handoff, with 19, 17 and 20 Lean declarations in `ConsequenceTransmission`, `DevelopedResponse` and `SupportHandoff` under `experiments/shared-renewal-capability/…`, outside the spine.
  - **Kept** as an empirical-and-mechanism study. It says itself that a supplied repair reaction does not represent 仁.
  - Its question, how responsiveness forms, now has spine neighbours:
    - `Closing.responds_to_own_level`: a loop forms when an exchange comes to respond to its own level;
    - `PoolResponse`: coupling does not fix response;
    - `Descent`.
  - **Not superseded**: the spine has no theorem on the formation of response to another's loss, and by design takes response as a premise (see `ru-mengzi-ce-yin`). The chapter's modules would join the spine by instance theorems, not be replaced.
- **[WENYAN-CONFUCIAN.md](../../../../../../../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/WENYAN-CONFUCIAN.md)**
  - What it is: the 6 October first round, with three routes (论语 relation-practice, 孟子 端 and 推扩, 荀子 性 and 伪).
  - Its diagnoses are now spine-checked one by one:

    | Diagnosis | Spine result | Entry |
    |---|---|---|
    | 恕's limits | `Learning.selects_not_right_of_parted`, `Relabel.valued_alike_iff` | `ru-lunyu-shu` |
    | 见牛未见羊 as salience | `SelectionGap` | `ru-mengzi-jian-niu-wei-jian-yang` |
    | 牛山 as history | `Roles` and `Experiment` | `ru-mengzi-niu-shan` |
    | 正名 and authority | `Identity`, `Unfolding`, `Mechanism` | `ru-lunyu-zheng-ming`, `ru-xunzi-ming-wu-gu-yi` |
    | 礼论 hierarchy | `RelativePosition` | `ru-xunzi-gui-jian-you-deng` |
    | 天论 non-reward | `Significance`, `Unfolding` | `ru-xunzi-tian-xing-you-chang` |

  - **Superseded** as a working map. **Kept** as history, being already in `history/`. Its three-route frame survives as the observation that 论语, 孟子 and 荀子 put the relation in practice, in beginnings, and in formed rule respectively, which the entries above keep text-scoped.

## 5. Candidate gaps, ranked

Each candidate was searched in the module and record digests and in the Lean index (names and docstrings) before being proposed.

1. **A graded order by closure level, and whether it is the same from every standpoint** (on `ru-mengzi-qinqin-renmin-aiwu`).
   - What exists: the two-tier lexical order `Lexical.Above` as a definition, the witnesses `Transfer.unordered` and `Clearing.centers_disagree`, and `BoundaryInvariant`.
   - What is absent: any order tiered by closure level from a centre, and any theorem on when two centres' tiered orders agree. Searching names and digests for tier, graded and lexical found only `Lexical` (two tiers, basic claims and then gains) and the protection-priority record.
   - Why it ranks first: 差等 is the most used relational ethic of this line, and the theorem would decide exactly which part survives the invariance step. Attention graded by reach would survive. A standpoint-relative measure of significance would not.
2. **Division across several conditions** (on `ru-xunzi-qun-fen-yi`).
   - What exists: one-condition laws (`Flow.WithinJoint`, `level_kept`, `joint_excess_ends`) and the two-taker witness `Excluding.three_courses`.
   - What is absent: any law of dividing needs across several conditions. The record `relative-position-is-zero-sum` lists "several shared conditions with different needs" as next work. Searches for Hall-type, assignment and division laws found only `Requirement.Assigned`, which is task assignment in plans, not division of takings.
   - Why it matters: 荀子's 人何以能群？曰：分 is the classical claim that a joint lasts through differentiation. The proposed statement is a decided, constructive Hall-type condition for finite lists.
3. **How a shared naming forms and holds through use** (on `ru-xunzi-ming-wu-gu-yi`).
   - What exists: the spine proves labels carry nothing and that names must follow likeness.
   - What is absent: no consensus, convention or adoption-of-names law. Only `Flow.adopt`, which re-identifies flows, and `RuleHandoff` turned up.
   - Why it matters: 约定俗成 is a joint process that 荀子 himself hands to a single centre (王者制名, 其民莫敢托为奇辞以乱正名). Shared readings between people, and between people and AI systems, are such namings.

**Checked and rejected as gaps**, because the spine already holds them:
- The 大学's outward keeping. The certificate law of `Viability` gives the exact condition for any guard, and the witnesses refute the general step.
- 感应不已. `Widening.loop_kept`, `closing_needs_less` and `nothing_between` give the exact condition.
- 恻隐's universality. Response is a supplied premise by design. Coupling is necessary (`Web.observed_level_couples`) and does not fix response, per `PoolResponse`, so this is scope, not a gap.
- 势 and 识不早. Covered by `Attraction`, `Widening` and `Runaway`.
- 学记's 发然后禁. Covered by `Closing` (polynomial before the loop forms, doubling after).

## 6. Counter-review of this mapping

- **Pattern-matching risk on 和.** 和而不同 is a judgement about how a 君子 relates to others. `Web.pool_adds` is about selections through pooled coupling. The structural link (keeping differences adds reach; making alike merges) is real, but the passage is not about reach. A stricter reader could call this scope, not agreement.
- **The 恕 and 能近取譬 readings lean on `Learning`.** The Learning laws are about transferring values across a lumping of inputs. Reading "myself as the model for another" as a lumping is the AI's reading. If 恕 is read as a practice of attention rather than a model, the mapping weakens.
- **周敦颐's 力 is not a turn count.** `Widening.closes_within` counts turns of a return map. 力不易 may mean force, not time. The structure matches only if "harder" is read as more turns of closing.
- **Rank versus division in 荀子.** `RelativePosition` counts amounts. 荀子's 贵贱有等 concerns positions of honour, and 荀子 may see rank as one form of 分 (role division). Separating 分 from 等 is the AI's cut, defended by the text's own pairing of 养 and 别, but contestable.
- **Status-divergence entries risk a double standard.** 程颢 and 戴震 ("仁者，生生之德也") are both marked as asserting what the theory conditions. The theory's own condition, `Unrestricted`, is unasserted and its warrant is open. Marking them divergent is not a judgement that they are wrong, only that they assert what the theory does not.
- **Atlas dependence.** Several passages come through later layers:
  - 郑玄 is reached through 谭嗣同, plus a `needs_source` entry whose wikisource URL the integrator should confirm;
  - 程颢's 鸡雏 is reached through 王夫之;
  - 朱熹's 理气 sayings are reached through 戴震's 注.

  Each entry names its layer, but a reader checking 朱熹's position on 理先气后 should read 语类 卷一 directly, which is not in the atlas.
- **Selection bias.** The slice favours passages with structure. The ritual detail of 礼, filial duties (孝经) and 春秋 judgements are not mapped. These are the non-relational or role-bound strata most likely to diverge further. The count of 12 divergences understates how much of the line's practical content is a role order rather than an analysis of relations.

## 7. Layer and source notes

- **经, 传 and 注 are kept apart in each entry:**
  - 中庸 经 against 郑注 and 朱熹 章句;
  - 荀子 经 against 杨倞 注;
  - 大学 经 against 朱熹's 补传;
  - 国语 史伯 against 韦昭 注 (not entered; 和实生物 is pre-Confucian and appears here only in this note);
  - 朱熹's own words against 戴震's citation of them.
- `ru-zhengxuan-ren-zhe-ren-ye` has `text_path: null` and `needs_source` set to 禮記正義 卷五十二 on zh.wikisource. The fragment "人也，讀如相人偶之人，以人意相存問之言。" is given from the standard 注 text and should be preserved against that page.
- **Simplified and traditional forms follow each atlas file:**
  - R02 writes 茍, not 苟;
  - S01 writes 有无之闲;
  - S05's heading appears as 干称 (a conversion artefact for 乾称), which the locator notes.
- **Not entered for count, but worth a later pass:**
  - 程颐 否卦注 "天地不交則不生萬物" (YD-CYSK, agreement with `Flow.new_from_rest_or_open`);
  - 黄宗羲 "有治法而後有治人" (agreement with `Law.perturbation_reabsorbed` and `Captured.rule_perturbation_changes`);
  - 孟子 权 (嫂溺援之以手, agreement with `Pace`);
  - 孟子 上下交征利 (agreement with `Flow.joint_excess_ends` and `RelativePosition`);
  - 程颐 时中 (agreement with `Contextual.indexed_fits`);
  - 王守仁 明镜 (agreement with `Withholding` without memory);
  - 陆九渊 宇宙便是吾心 (divergence, `Diagonal`);
  - 董仲舒 名生於真 (divergence with 名无固宜);
  - 学记's 相观而善 and 发然后禁.
