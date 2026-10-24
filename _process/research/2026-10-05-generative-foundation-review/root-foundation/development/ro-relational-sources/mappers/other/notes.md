# The "other" slice on the Becoming spine: notes

AI-written. Every reading here and in `entries.json` is the AI's. Ren's thesis, that one relational ontology runs from the sources of Chinese thought through the later systems, is treated as a claim to test. It is not a premise.

**Slice:** 庄子 and 玄学 (郭象, 裴頠); 墨家 and 墨辩; 名家 (公孙龙, plus 惠施 as reported in 天下); 兵家 (孙子); 法家 (韩非, 商君书); 管子 轻重 (国蓄); 纵横 (鬼谷子); the Buddhist lines as received in China (杂阿含, 中论, 成唯识论, 华严五教章, 坛经); 道教 (清静经); 嵇康 and 王充. The atlas's 29 mechanisms and 34 bridges are covered in §6.

**Output:** 50 entries: 21 agreement, 14 scope, 15 divergence.
- Every fragment was checked with an exact count against its `.txt` in atlas v9.1. The one exception is 惠施, which is in neither atlas and carries `needs_source`.
- Every declaration was checked against an index of the 281 modules on main at 39d18c449, and every record id against `theories/becoming/results/records/`.
- Every atlas id was checked to be evidenced by the entry's own source. One wrong id (KR4079, which belongs to 名实论) was replaced by the sense C0061-S001.

## 1. The slice's relational structure

The slice is not one tradition. It is a set of positions that often answer one another, and they relate to a relational ontology in three ways.

**(a) Relational at the root, with the relation stated as structure.**
- 齐物论 makes 彼 and 是 arise through each other and reads 生/死 and 可/不可 as one change from two sides.
- The 墨经 defines 小故 as a condition "without which not". Its 同 and 异 are each split into kinds of relation (重, 体, 合, 类).
- 杂阿含 states dependent arising as a pair: "此有故彼有" and "此無故彼無".
- 中论 makes the name a designation over conditions.
- 华严's 六相 keeps the rafter a rafter inside the house.
- 嵇康 makes 哀乐 a relation between sound and hearer.

In these texts what is primary is a relation, and the terms differentiate within it. This is the strongest support for Ren's thesis, and it is spread across 道, 墨, 名 and 佛, not confined to one lineage.

**(b) Relational in method, with the relation used as an instrument.** 兵家, 法家, 管子 轻重 and 鬼谷子 read situations relationally. 势 is a configuration, not a person's virtue. 参 is a pooling of channels. 余缺 is a relation of stock to need at each step. 捭阖 is opening and closing an exchange. They then direct that reading at one standpoint's position over another's:
- 屈人之兵;
- 君反制于臣 as the danger;
- 民弱国强;
- 民无不累于上;
- 计谋不两忠.

The ontology here is relational, but the joint activity starts from opposed interests and a contest for position. AGENTS.md names exactly this as the framing the theory does not start from. These texts are where the thesis needs the most care: "relational" is true of their method and false of their direction.

**(c) Strands that are not relational at the point cited.**
- 郭象's 独化 denies dependence outright (玄合而非待).
- 墨子's 天志 grounds the norm in a willing Heaven with sanctions.
- The 墨经's 利 is a getter's pleasure, summed across persons.
- 坛经's 自性 is originally pure, unborn and generative, and covered like the sun by cloud.
- 唯识 places objects below consciousness (外境…非有如识).
- 嵇康, having made 哀乐 relational, places 善恶 in the sound itself (此物之自然).
- 清静经's 男清女浊 assigns fixed natures by sex.

These seven are the main counterexamples. Each occurs inside a tradition that elsewhere states the relational view well, so the thesis holds as a dominant thread, not as a property of every system.

## 2. The strongest correspondences

These are ranked by how exactly the structure matches: the same relation, condition and direction.

1. **墨经 小故 / 大故 ↔ `Web.Dependent` and `Determined`** (`mojing-gu-xiao-da`, scope).
   - 小故, "有之不必然，无之必不然", is the spine's dependence word for word: active only where supported.
   - 大故, "有之必然", is sufficiency, which the spine never derives from support. It holds only under a determined law.
   - The 说 layer makes the very distinction the spine makes.
2. **杂阿含 此有/此无 ↔ `Web.Dependent`, `Web.coextinct`, `Web.change_readings`** (`zaahan-ci-you-gu-bi-you`). "此无故彼无" is coextinction along dependence. Seeing arising and ceasing together removes "is" and "is not" as fixed views, matching arising and ceasing as one change read two ways.
3. **齐物 彼是 / 两行 / 道枢 ↔ `Contextual.indexed_fits`, `glues_iff_agree`, `Specker.noGlobal`.**
   - Each 是非 is a context's verdict.
   - The indexed frame fits all that is shown.
   - A context-free verdict exists exactly where the contexts glue.

   公孙龙's 坚白 (离) and the 墨经's 坚白在石 (盈) then come out as two scopes of one law (`gongsunlong-jian-bai`), and 嵇康's 哀乐 as a reading that does not glue across hearers (`jikang-sheng-wu-ai-le`).
4. **墨子 先从事 ↔ `Withholding.Ring.givesFirst_restores`, `Tolerance.restores_iff`, `Tolerance.worst_start`** (`mozi-jianai-xia-xian-cong-shi`).
   - From total withholding, waiting-on-giving never restores.
   - Someone has to give first, and restoring is exactly the absence of a clear chain of waits.
   - 墨子's own warrant, the return, is an exchange argument the theorem does not need.
5. **墨辩 其然同所以然不必同 / 以类取 / 侔有所至而正 ↔ `Confound.*` and `Learning.lumped_right_iff`.** The 小取 is a method of inference whose limits are the spine's limits: same outcome with different routes is a confound that only variation excludes, and transfer by kind is right exactly where the world goes alike across the lumping.
6. **华严 六相 ↔ `whole_not_in_pairs`, `separation_faithful_iff`.** The house holds a relation no two parts hold; the parts' description loses it; the rafter must stay a rafter.
7. **唯识 种现互熏 / 损力益能 / 转舍转得 ↔ loops forming by closing (`onLoop_succ_iff`, `responds_to_own_level`) and closing a difference (`Widening.closing_needs_less`).** The atlas's KR9467 ("损力益能不能等同永断") matches the spine's distinction between a loop that closes a difference and the end of the relation.
8. **two arrows (杂阿含 470) and 坛经 無念 ↔ `responds_to_own_level` and `closing_needs_less`.**
   - The second arrow is a response to one's own response, a loop of one.
   - 不思酬害 is the link that gives back less, which a loop needs if a difference is to close.
   - 当令念绝 is called bondage, matching `Whole.needs_arising`.
9. **管子 计本量委则足…谷有所藏 ↔ `Web.supported_iff_admits`, `Stock.covered_iff_prefix`.** Enough in total is not support for each at each step.
10. **孙子 怒可复喜…亡国不可复存** is the clean case of `Law.drawn_iff_not_returns` and `Branching.loss_passes_juncture`. It was cut for count; the structure is the one in `zhuangzi-qiwu-fen-cheng-hui`.

## 3. Divergences and non-relational strands, with passages

Each is a divergence because the passage asserts what the theory does not, or points the opposite way. None is a missing word.

- **郭象注, 注 layer** (`guoxiang-zhu-du-hua`): "彼我相因形景俱生虽复玄合而非待也", "物各反所宗于体中而不待乎外".
  - It keeps correlation and denies dependence, which conflicts with `Web.Dependent` and `Flow.fed_from_beyond`.
  - "无主" agrees: a law is read off the history (`exists_law_iff`).
  - 裴頠's "偏無自足，故憑乎外資" (`peiwei-chongyou-pian-wu-zi-zu`) is the same period's counter, and it agrees.
  - This is the 注 layer, not 庄子.
- **墨经 利** (`mojing-li-suo-de-er-xi`): "利，所得而喜也。"
  - Value is located in a getter's response and then summed (亏人愈多，其不仁兹甚).
  - Mixed parts stay unordered without a measure (`Transfer.unordered`, `Web.mixed_iff_adds`).
  - In the same text, "仁，体爱也" agrees.
- **天志** (`mozi-tianzhi`): "顺天意者，兼相爱、交相利，必得赏；反天意者…必得罚。" A personal will plus sanctions is the warrant. That merges warrant, motivation and compliance, which the theory keeps distinct, and the theory asserts no ethical axiom.
- **孙子 不战而屈人之兵** (`sunzi-bu-zhan-er-qu-ren`).
  - 全国为上 minimizes destruction, but the aim is relative position.
  - Relative position is now on the spine as a counting law (Z1, `RelativePosition`): a rise needs a fall, and no change raises everyone.
  - 孙子 optimizes within the contest; the theory states the contest's laws and does not take position as its direction.
- **诡道** (`sunzi-gui-dao`): "能而示之不能", "形人而我无形". The structure is on the spine (a selection reaches exactly what couples in). The direction is to narrow the other's 明.
- **韩非 二柄** (`hanfei-er-bing`): "杀戮之谓刑，庆赏之谓德", "人臣之情非必能爱其君也，为重利之故也". The relation is read as control between opposed interests, and 德 is narrowed to reward. It also names the loop the spine lacks (§5).
- **商君书 禁使** (`shangjunshu-jin-shi`): "夫事合而利异者，先王之所以为端也". It rightly sees that a monitor coupled like the monitored adds nothing (`Web.pooled_iff_member`), but designs the difference as opposed gains. On the spine the gap for an act closes by pooling with those whose admission the act changes (`Clearing.pool_closes_gap`).
- **商君书 弱民** (`shangjunshu-ruo-min`): "民弱国强…务在弱民", "利出一孔".
  - It reads whole and part as rival positions; the whole's stock is not a position (`Flow.Balances.rise_paid_from_beyond`).
  - It hangs everything on one giver (`Withholding.withholding_absorbs`), whereas two feeders would each suffice (`Redundant.either_suffices`).
  - 道 is used to name this.
- **商君书 壹** (`shangjunshu-yi-shang-yi-xing-yi-jiao`): "壹赏，壹刑，壹教". Every selection passes through one reading, so the reach of 明 narrows by design.
- **管子 国蓄** (`guanzi-guoxu-ju-you-yu`): "據有餘而制不足，故民無不累於上也", "利出於一孔者，其國無敵". This is the single-giver structure used for dependence on the center, together with the contest aim.
- **鬼谷子 捭阖** (`guiguzi-bai-he`): opening and closing as moves to probe and steer. 阴阳 names two moves of persuasion.
- **杂阿含 苦灭** (`zaahan-ku-mie`): "當來有愛…無餘斷…是名苦滅", "有滅則生滅".
  - The chain agrees; the direction, non-continuation as release, runs against the continuation condition (§6.15) and against `Whole.needs_arising`.
  - Scope: the target is a craving-driven loop, not 生生 in the whole.
  - 坛经 ("一念絕即死，別處受生，是為大錯", in a broken line not quoted as a fragment) and 唯识 转舍转得 push back from inside the received tradition.
- **坛经 自性** (`tanjing-zi-xing`): "何期自性，本自清淨；何期自性，本不生滅；", "自性，能生萬法。", "被妄念浮雲蓋覆自性". This is a prior ground with a covering model. It is in tension with 中论 and with the 坛经's own 无住.
- **唯识 无境** (`weishi-wei-shi-wu-jing`): "外境隨情而施設故，非有如識". Knowing is placed before the known, while on the spine observation is a route downstream of what it observes (`apart_only_downstream`).
- **嵇康 五声有善恶** (`jikang-wu-sheng-shan-e`): "此物之自然也". Intrinsic value appears inside the slice's most relational essay.
- **清静经 男清女浊**: a fixed-nature strand, recorded inside the scope entry `qingjing-jing`.

**Not a divergence: the variant line.** The 清静经 line "靜者動之基" also stands in the vertical edition as "動者靜之基" (R5DY004 has both), so no "stillness is the root" divergence can rest on it.

**Moved from divergence to scope: 华严 十玄** (`huayan-shi-xuan`).
- Read as "each holds every reading of all", 因陀罗 mutual reflection would conflict with the diagonal law (`Diagonal.claims_incomplete`, `Frame.self_incomplete`).
- 法藏 qualifies it himself: "重重隱映" (layers hidden and shown) and "仍體不同" (bodies stay distinct). That is the side the diagonal law allows.
- The atlas's own note on "同时相应…无有前后" (KR9488) reads it as denying a sequence among the ten gates, not denying before and after in the world.

## 4. Where the spine gives the scope

The 14 scope entries each correct a universal form:
- "凡物无成与毁" holds as one change read twice, not as the absence of loss (`Law.lost_stays`).
- 应而不藏 suffices off loops, not on them (`Withholding.withholding_returns`).
- 墨子's "必从而" holds only where each link of the loop gives back what it receives.
- 兼 orders nothing without the comparison commitment C.
- 尚同 holds where reports are full and 规谏 is open.
- 白马非马 is non-identity of selections.
- 奇正 循环 and 战胜不复 hold at configuration and history level respectively.
- 百战不殆 holds only within the coupling closure.
- 惠施's 天地一体 ⇒ 氾爱 holds only under a common feeding condition.

## 5. Candidate gaps, ranked

1. **Capture through the rule.** This is the one real gap; it is on `hanfei-er-bing`.
   - **What it is:** the selected come to write the selection rule. It appears as 韩非's 君反制于臣, 管子's 据有余而制不足, the force of 壹, and the meta-attractor.
   - **What is checked to be absent:**
     - `Capture`'s header lists "that winners shape the rule" as not derived.
     - `Captured` is a two-state example in which the rule keeps itself rather than being written from the state.
     - `Pace` (the only module using `paced`) has the rule read the fast level at reading steps, but with no share and no selection.
     - `CaptureWorlds` joins Capture to world flows, not to rules.
   - **Proposed statement:** given in the entry. A paced course whose fast step is a selection with margin `m`, and whose rule at reading steps is `h(share)` monotone, has a non-decreasing share and a non-decreasing margin at reading steps. A change of the margin alone is re-absorbed at the next reading step, so leaving a rising margin needs `h` changed.
   - **Why it matters:** it would give the 6 October study's question ("谁有权修正规则") its live, rights-free form: escape needs a change of the rule's reading, not of the state.
2. **Zero-sum of relative position: closed during mapping.** Z1 landed `Becoming.RelativePosition` (record `relative-position-is-zero-sum`). It carries 不战而屈人, 民弱国强 and the contest aims of 管子 and 鬼谷子. It is not proposed.
3. **Simultaneous mutual support (因果俱时, 芦束互依; 华严 同时相应): not proposed, routed.**
   - The spine is stepwise by modelling choice.
   - 唯识 itself separates simultaneous 俱有因 from sequential 同类因 (KR9456).
   - The board item MD1 ("mutual dependence and the pace it gives") is the claimed place, so this goes to MD1's owner.

Checked and not gaps:
- A **single-giver ending** (利出一孔). It is an instance of `Flow.Balances.consumption_ends_with_feeders` applied to each member, plus `Withholding.withholding_absorbs`, so a theorem for it would be a wrapper.
- A **uniform-verdict pool** (尚同, 壹). It is an instance of `Web.pooled_iff_member` with `ExchangeLaw.Through.selectsThroughAll`.

Not checked to absence, so not proposed: a general **responsive rest** (常应常静, 应而不藏, 无念), meaning a state at rest that re-absorbs every perturbation while responding. `Law.perturbation_reabsorbed` and `Tolerance.restores_iff` cover two cases; Lasting and Tolerance should be searched before anyone claims it.

## 6. The atlas's mechanisms and bridges

The atlas labels its 29 mechanisms `modern_editorial_model`, "不构成古人共有体系". All 34 bridges are editorial: 32 are `modern_comparison` and 2 are `shared_material`. They are reading aids, not evidence, and no entry rests on them. The table lists the nearest spine laws; † marks a mechanism that belongs mainly to another slice.

| Mechanism | Spine laws (nearest) |
|---|---|
| MG6101 信息越查越失真 | `Web.pooled_iff_member`, `pool_adds` (禁使, 尚同, 参) |
| MG6102 承诺、结果与授权 | selection through a record (`share_rises_through`); the capture gap |
| MG6103 激励制造规避 | `share_rises_through` with `Learning.selects_right_through` (selection is right only where what matters goes alike across what it reads) |
| MG6104 余缺、收放与依附 | `Withholding.withholding_absorbs`, `consumption_ends_with_feeders`, `Redundant.either_suffices`; the capture gap |
| MG7101 越代办越难问责 | `Flow.act_unselected`, `Clearing.pool_closes_gap` |
| MD6401 视角、尺度与任务 | standpoint readings; `selects_not_right_of_parted`; `Diagonal.Unfolds.unheld` |
| MD6402 固定策略为何失效 | `Parting.not_right_on_both`, `Viability.ChoicePoint.each_not_joint` |
| MD6403 时位判断与解释纠错 † | `Pace`, `Parting` (Yi slice) |
| MD6404 把去执的方法再审 | `Web.excludesWithin_iff_conjunction`, `Stationary.model_error` |
| MB6201 互熏如何转成修证 | `onLoop_succ_iff`, `responds_to_own_level`, `Widening.closing_needs_less` |
| MB6202 方法也要查 | as MD6404 (天台 能破如所破 fits here; cut for count) |
| MB6203 整体成立，差异仍在 | `whole_not_in_pairs`, `separation_faithful_iff` |
| MB6204 空如何避免新执 | `identifiesAlike_iff`; the diagonal law (a reading of everything is itself one more reading) |
| MB7101 受苦之后仍有分岔 | `responds_to_own_level`, `response_not_fixed_by_coupling` |
| MA7101 同声欢戚不同 | `Contextual.glues_iff_agree`, `fitsFree_iff` |
| MC6303 类推怎样接受检验 | `Learning.lumped_right_iff`, `Confound.varied_refutes` |
| ML6701 三表与因三相 | testing through coupled difference (`Web.Excludes.not_of_alike`); no single law |
| ML6702 依法不依人 | `Excludes.not_of_alike` (exclusion comes from the difference, not from who reports it); 商君书's 朋党背书 (KR3095) is a pool reduced to one member |
| MC6301 权变 †, MC6302 差等到协作 †, MC6304 实践教人 † | `lumped_right_iff`; `Viability.kernel_and_iff`, `Pair.own_not_joint`; `Run.not_fixes_of_untaken` (Ru slice) |
| ME6501–ME6504 史料与方法 † | `Stationary.model_error`, `lumped_right_iff` (ME6503: writing the conditions of a method into it is stating its lumping) (Ru slice) |
| MS6601–MS6603 修养 † | MS6602 (knowing and not doing) needs the distinction between recognition, motivation and compliance; no law. MS6603 (no selfish motive, still wrong): `Stationary.model_error` (Ru slice) |
| MC7101 教学为何失效 † | `Learning.determines_lumped_iff` (Ru slice) |

## 7. How the earlier repo studies stand

**`theories/becoming/history/PRE-QIN-AND-WENYAN-2026-10-23.md` (6 October).**
- *Kept:* the findings and the counterexamples it keeps: 《二柄》 德 = 庆赏, 《弱民》 以有道称弱民, the 察今 contrast and the 维摩经 reading.
- *Superseded:*
  - its framing as "竞争解释" among positions;
  - its rights wording ("谁有权修正规则", "修订权"), which is outside the current vocabulary (relations, not rights).
- *Live replacements:* pooled coupling (`Clearing.pool_closes_gap`, `Flow.act_selected_by_pool`), Pace (a fast difference reaches a rule only at a reading step), RelativePosition, and the capture gap above.

**`WENYAN-MOHIST-POLITICAL.md` (history).**
- *Kept:* its eight arguments (兼爱, 尚同, 天志, 非命, 二柄, 五蠹, 弱民, 白马) and its five challenges.
- *Extended:*
  - by Tolerance (先从事);
  - by SelectionPool (尚同, 禁使);
  - by RelativePosition (弱民);
  - by Context (白马 and 坚白, now scoped rather than cautioned against).

**`WENYAN-LATER-TRANSFORMATIONS.md`.**
- *Kept:* the 王充 reading, which the Learning laws extend.
- *Belong to the Ru slice:* 韩愈, 张载, 王阳明, 黄宗羲.

**Status line for all three.** Earlier work holds where it stated what the texts say. Its comparisons are replaced by laws that landed after 6 October: SelectionPool, Withholding and Tolerance, Widening, Loops, RelativePosition, Context and Gluing, and Diagonal.

## 8. Counter-review: where this mapping may match words, not structure

- **Generic laws.** The Learning and Context modules match many texts because they are general. A match there shows that a text uses inference by kinds or indexed verdicts; it does not show a shared ontology. The discriminating evidence is in the divergences and in the scope corrections.
- **浑沌 → `Web.break_not_bounded`.** I use the form only. The theorem's hypotheses (a stock coupled by threshold, the only possibly unmet requirement) are not in the fable. The first two declarations carry the entry.
- **庖丁 族 → `Branching.loss_passes_juncture`.** The theorem concerns returning configurations. The knot is a place of difficulty in a story, which risks a word match on "juncture".
- **两箭 and 無念 → `responds_to_own_level`.** The theorem is about an exchange's coupling coming to read the level it gives. The correspondence is the loop's shape, not a psychology of rumination.
- **尚同.** Conforming verdicts is not conforming couplings. I read the verdicts as the selections that do work, and if verdicts are only spoken, the pool law says less than the entry implies.
- **不战而屈人 → RelativePosition.** The law counts rises and falls. 屈 is not a count; the match is the zero-sum of standing, not of losses.
- **郭象.** Some readers take 独化 as denying a maker rather than denying relation. "玄合而非待" denies 待 in so many words, so the divergence is kept, at the 注 layer only.
- **苦灭.** Whether release is non-continuation depends on how 涅槃 is read. The entry limits the divergence to that reading.
- **坛经 自性.** If 自性 is read as 空性, the divergence weakens. "能生萬法" and "蓋覆" support the ground-and-cover reading. The text is the late 宗宝本, not the 敦煌本.
- **华严.** "同时" first looked like a denial of time. The atlas's note shows it is about the order of the gates, and I corrected the entry to scope.
- **Skipped as too contested to map structurally:** 物化 (butterfly), where identity across steps tempts but the text stresses "必有分"; 指物论; 天台 一念三千, where "the three thousand in one moment of mind" is Diagonal-relevant but its sense is disputed.
- **Considered and dropped:** `Motion.neither_alone` for 常/断. It concerns describing a motion by standing or passing alone, so using it would be a word match.
- **Layers.**
  - 天下 reports 惠施; the fragments are given as known, with `needs_source`.
  - 清静经 and 坛经 宗宝本 are late.
  - 墨经 说 entries are marked as the 说 layer.
  - 公孙龙's 〈〉 注 is excluded.
