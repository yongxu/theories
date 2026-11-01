<a id="可判定性清点--decidability-inventory-p58"></a>
# 可判定性清点

> **中文版（2026-10-17）。** 正典文本是[英文版](DECIDABILITY-INVENTORY.md)；本版由重构时从双语原文拆出，不与英文同步维护，两者有出入时以英文为准。

生成：`DECIDABILITY-INVENTORY.py` 在合并检查器回执 `20261016T124157.989030Z` 所检查的核心上运行 `DECIDABILITY-INVENTORY.lean`（源字节与回执一致；外围工具，导入 Lean 自身的库，核心从不导入它）。每一行由 Lean 读出：绑定的类型是否为可判定族、已判定的命题（对给定的 `p` 有 `p ∨ ¬ p`，如核心的 `Decided p`）或排中律（对约束所涉的每个命题或谓词，完全或受限的形式）、陈述是否依赖它、证明是否用到它。Ren 2026-10-11：“i intuitively feel decidability is too dualist”，并以“please”接受把它局部化（[原话](../../../../sources/15-codex-theory-conversations/2026-10-11-decidability-local-imbalance-relatum.md)）。

<a id="总数--totals"></a>
## 总数

| 类 | 数 |
|---|---:|
| 陈述依赖它（计数或构造），可判定是该陈述自己的条件 | 437 |
| 只在证明中用到 | 263 |
| 不用到 | 0 |
| 排中律或其受限形式作为假设（边界定理） | 34 |
| 计数而可判定被证明，不是假设 | 94 |
| 证明可判定的定义与实例 | 149 |
| 取可判定族的定义（计数的原语） | 117 |

<a id="理由--reasons"></a>
## 理由

陈述依赖可判定性时，理由由 Lean 读出的、陈述提到的取可判定族的定义给出；只在证明中用到时，理由逐条分类，生成时断言每条都已分类。

| 理由 | 说明 | 定理数 |
|---|---|---:|
| 计数 | 计数：计数存在恰当所计数者已定（`counts_iff_decided`） | 77 |
| 较粗的读法 | 较粗的读法：粗步内每个关系项只列一次，需分辨关系项的相同 | 88 |
| 抬高一个条件 | 抬高一个条件：需分辨条件的相同 | 8 |
| 移开依存 | 在不被支持之步移开依存：支持已定 | 3 |
| 保留的列表 | 按规定保留的列表：对其成员已定 | 9 |
| 按否证学习 | 按否证学习：判定主张是否被否证，以保留假设或选出记录所支持的假设，需分辨值的相同 | 26 |
| 首个符合者 | 选出首个符合者：依次判定列表成员是否满足规定 | 16 |
| 另一个值 | 另一个值：取与给定值不同的值，需分辨值的相同 | 1 |
| 不重复的列表 | 不重复的列表：成员关系已定 | 7 |
| 逐个条件换入 | 逐个条件换入另一段历史：需分辨条件的相同 | 8 |
| 交换两个值 | 交换两个值：需分辨输入是否为其中任一值 | 40 |
| 列表成员判定 | 列表成员的布尔判定：需逐项分辨值的相同 | 1 |
| 分辨相同 | 分辨相同：证明按两个条件、关系项、值或输入是否相同、或条件是否在家族中分情形 | 203 |
| 造出指示 | 造出指示：证明以已定命题的标记（成立为一、不成立为零）作为一个数，例如一个分数 | 51 |
| 分情形 | 按规定分情形：证明分别用规定成立与不成立的情形 | 35 |
| 守护之步 | 守护之步：每步判定守护是否成立，不成立处停止 | 10 |
| 可达 | 可达：证明以已定的步与所识的值造出被给予世界的学习者 | 11 |
| 找出 | 找出一步或一个成员：陈述断言其存在，不给已定时它只是不能被否证 | 90 |
| 造出列表 | 造出列表：普查或不重复的列表由已定的成员造出 | 16 |

<a id="陈述依赖可判定性的定理计数或构造--theorems-whose-statements-depend-on-decidedness-counting-or-construction"></a>
## 陈述依赖可判定性的定理（计数或构造）

| 模块 | 定理 | 可判定 | 理由 | 另一形式 |
|---|---|---|---|---|
| Change | `Web.activity_over_stretch` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Change | `excess_mark` | `Decidable p`；`Decidable q` | 计数 | 可判定是它自己的条件 |
| Change | `fall_mark` | `(t : Nat) → Decidable (p t)` | 计数 | 可判定是它自己的条件 |
| Change | `held_over_stretch` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | `Counts.over_stretch`（无前提 |
| Change | `keep_pace` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | `CountsAcross.keep_pace`（无前提 |
| Change | `mark_cases` | `Decidable p` | 计数 | 可判定是它自己的条件 |
| Change | `mark_iff` | `Decidable p`；`Decidable q` | 计数 | 可判定是它自己的条件 |
| Change | `mark_le_one` | `Decidable p` | 计数 | 可判定是它自己的条件 |
| Change | `mark_pos` | `Decidable p` | 计数 | 可判定是它自己的条件 |
| Change | `marks_within` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | `Counts.le_length`（无前提 |
| Change | `rise_mark` | `(t : Nat) → Decidable (p t)` | 计数 | 可判定是它自己的条件 |
| Contacts | `Contacts.agree_spot` | `DecidableEq I` | 造出指示 | 可判定是它自己的条件 |
| Contacts | `Contacts.spot_other` | `DecidableEq I` | 造出指示 | 可判定是它自己的条件 |
| Contacts | `Contacts.spot_self` | `DecidableEq I` | 造出指示 | 可判定是它自己的条件 |
| Copying | `Copying.batch_all_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.batch_all_swap` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.built_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.completes_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.copies` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_append` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_joinAll_replicate` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_joinAll_swap` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_other` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_remove` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_removeAll` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_remove_other` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_remove_self` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_self` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.countOf_setAt` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.defects_beyond` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.defects_break` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.defects_fix` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.defects_self` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.defects_zero_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.empties_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.exchange_keeps_counts` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.exchange_le` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.inspect_keeps_counts` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.inspect_le` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.inspect_le_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.inspect_matches_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.ite_cases` | `Decidable c` | 分情形 | 可判定是它自己的条件 |
| Copying | `Copying.lineage_all_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.nil_iff_countOf_zero` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.pos_of_supplies` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.readStep_extends` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.readSteps_extends` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.readSteps_fixed` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.reading_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.releases_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.scan_le` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.steps_fixed` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.supplied_of_completes` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.supplies_append_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.supplies_cons_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.supplies_nil` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.tick_cons` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.use_lt_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.use_midpoint` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.use_pair` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Copying | `Copying.use_word` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Counterfactual | `mixIn_alike` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Counterfactual | `mixIn_either` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Counterfactual | `mixIn_listed` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Counterfactual | `swap_alike` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Counting | `World.binds_arising` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Counting | `World.counts_arising` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Counting | `World.enclosed_binds_counting` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Counting | `World.enclosure_bounds_change` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Counting | `World.finite_binding_census` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Counting | `World.taking_binds_counting` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Coupling | `policyUpto_agrees` | `DecidableEq K` | 分辨相同 | 可判定是它自己的条件 |
| Coupling | `policyUpto_taken` | `DecidableEq K` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.copy_built_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.copy_completes_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.copy_empties_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.copy_grows` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.every_released_iff_course` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.inspection_course_le` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.inspection_le_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.lineage_course_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.no_run_record_groups` | `DecidableEq A` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.readSteps_orbit` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.reading_completes_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.release_course_iff` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.run_settles` | `DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.runs_settle_iff` | `DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.steps_orbit` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Courses | `Courses.tick_extends` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Decidedness | `ceasings_counts` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Decidedness | `comings_counts` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Decidedness | `counts_total` | `(a : α) → Decidable (q a)` | 计数 | 可判定是它自己的条件 |
| Decidedness | `indicates_mark` | `Decidable p` | 计数 | 可判定是它自己的条件 |
| Dissipation | `adjoin_spec` | `DecidableEq α` | 不重复的列表 | 可判定是它自己的条件 |
| Dissipation | `insertNew_spec` | `Decidable (a ∈ l)` | 不重复的列表 | 可判定是它自己的条件 |
| Entropy | `mark_mono` | `Decidable p`；`Decidable q` | 计数 | 可判定是它自己的条件 |
| Identification | `Identification.answer_exceeds_bound` | `DecidableEq O` | 首个符合者 | 可判定是它自己的条件 |
| Identification | `Identification.firstFit_found` | `(a : α) → Decidable (p a)` | 首个符合者 | 可判定是它自己的条件 |
| Identification | `Identification.firstFit_sound` | `(a : α) → Decidable (p a)` | 首个符合者 | 可判定是它自己的条件 |
| Identification | `Identification.held_learner_rests` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Identification | `Identification.learner_rests` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Identification | `Identification.leastBound_exact` | `DecidableEq O` | 首个符合者 | 可判定是它自己的条件 |
| Identification | `Identification.leastFit_sound` | `DecidableEq O` | 首个符合者 | 可判定是它自己的条件 |
| Identification | `Identification.leastFit_within` | `DecidableEq O` | 首个符合者 | 可判定是它自己的条件 |
| Identification | `Identification.moved_on` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Identification | `Identification.rests_of_lasso` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Identification | `Identification.run_kept` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Identification | `Identification.withBound_exact` | `DecidableEq O` | 首个符合者 | 可判定是它自己的条件 |
| Identification | `Identification.withBound_holds` | `DecidableEq O` | 首个符合者 | 可判定是它自己的条件 |
| Identity | `Web.Census.balanceFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 计数 | 可判定是它自己的条件 |
| Identity | `Web.Census.balanceFrom_at` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 计数 | 可判定是它自己的条件 |
| Identity | `Web.Census.balanceFrom_eq` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 计数 | 可判定是它自己的条件 |
| Identity | `Web.Census.balanceFrom_eq_at` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 计数 | 可判定是它自己的条件 |
| Lasting | `Lasting.guarded_agrees` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Lasting | `Lasting.guarded_none_iff` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Lasting | `Lasting.guarded_upto_iff` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Lasting | `Lasting.guarded_within` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Lasting | `Lasting.hitTime_lowers` | `DecidablePred target` | 首个符合者 | 可判定是它自己的条件 |
| Lasting | `Lasting.hitTime_of_reaches` | `DecidablePred target` | 首个符合者 | 可判定是它自己的条件 |
| Lasting | `Lasting.hitTime_stable` | `DecidablePred target` | 首个符合者 | 可判定是它自己的条件 |
| Lasting | `Lasting.hitTime_succ` | `DecidablePred target` | 首个符合者 | 可判定是它自己的条件 |
| Learnable | `Learnable.firstFit_congr` | `(a : α) → Decidable (p a)`；`(a : α) → Decidable (q a)` | 首个符合者 | 可判定是它自己的条件 |
| Learnable | `Learnable.predicts_through` | `DecidableEq R` | 按否证学习 | 可判定是它自己的条件 |
| LearnableRuns | `LearnableRuns.predicts_through` | `DecidableEq R` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.diagonal_not_lasso` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.held_learner_bounded` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.held_rest_unrefuted` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_kept` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_le_of_holds` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_le_succ` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_mono` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_mono_le` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_refuted` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_succ_le` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.index_unbounded` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.lasso_learner_bounded` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.lasso_of_rest` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.learner_through_record` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.merged_bound` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.merged_unrested` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.refutations_not_recurring` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.refuted_before` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.rest_unrefuted` | `DecidableEq O` | 按否证学习 | 可判定是它自己的条件 |
| Learning | `Learning.selects_not_right_of_parted` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Learning | `Learning.selects_right_of_reads` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Learning | `Learning.selects_right_through` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Learning | `Learning.selects_through_lumping` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Learning | `Learning.swapTo_moves` | `DecidableEq O` | 另一个值 | 可判定是它自己的条件 |
| Learning | `Learning.values_lumped` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Learning | `Learning.values_not_right_of_parted` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Learning | `Learning.values_right_lumped` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Learning | `Learning.values_right_of_reads` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Listing | `Flow.BalancesOn.sample_byOccurrence` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Listing | `Listed.of_listing` | `(t : Nat) → (a b : α) → a ∈ l t → b ∈ l t → Decidable (a = b)` | 不重复的列表 | 可判定是它自己的条件 |
| Listing | `keepFresh_spec` | `Decidable (a ∈ l)` | 不重复的列表 | 可判定是它自己的条件 |
| Listing | `listOnce_listsOnce` | `(a b : α) → a ∈ l → b ∈ l → Decidable (a = b)` | 不重复的列表 | 可判定是它自己的条件 |
| Locality | `ceasing_needs_arising` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Locality | `cohort_closes_iff` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| LossMatching | `Frame.StrictLossMatch.classCount_le` | `DecidableEq K` | 计数 | 可判定是它自己的条件 |
| LossMatching | `Frame.distinct_lostOf` | `(c : C) → Decidable (F.realized s c)` | 保留的列表 | 可判定是它自己的条件 |
| LossMatching | `Frame.lossesListed_lostOf` | `(c : C) → Decidable (F.realized s c)` | 保留的列表 | 可判定是它自己的条件 |
| LossMatching | `Frame.matching_of_counts` | `DecidableEq C`；`DecidableEq K` | 计数 | 可判定是它自己的条件 |
| LossMatching | `Frame.mem_lostOf` | `(c : C) → Decidable (F.realized s c)` | 保留的列表 | 可判定是它自己的条件 |
| LossMatching | `Frame.strictLossMatch_iff_counts` | `DecidableEq C`；`DecidableEq K` | 计数 | 可判定是它自己的条件 |
| LossMatching | `Frame.strictLossMatch_of_counts` | `DecidableEq C`；`DecidableEq K` | 计数 | 可判定是它自己的条件 |
| Onward | `Onward.decidedTest_finds` | `(s : S) → (a : A) → (t : S) → Decidable (P.step s a t)`；`(s : S) → Decidable (K s)` | 造出指示 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_balancesOn` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_closedAt` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_dissipatesOn` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_enclosed` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_give` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_not_descends` | `DecidableEq X` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_present` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_runsDownOn` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_take` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_idle_takers` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_acting_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_balancesOn_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_closedAt_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_descends_iff` | `DecidableEq X` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_dissipatesOn_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_give` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_given` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_mem` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_runsDownOn_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_take` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_taken` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_moves_taking_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.sample_not_more` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.stutter_acting_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.stutter_balances_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.stutter_dissipative_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.stutter_given` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.stutter_taken` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.stutter_taking_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Flow.stutter_transmitsWithin_iff` | `DecidableEq X` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `Reorders.counts` | `(n : Nat) → (x : X) → Decidable (W'.active n x)`；`(n : Nat) → (x : X) → Decidable (W.active n x)` | 计数 | 可判定是它自己的条件 |
| Order | `World.commute_counts` | `(n : Nat) → (x : (w.commute t side).Relatum) → Decidable ((w.commute t side).web.active n x)`；`(n : Nat) → (x : w.Relatum) → Decidable (w.web.active n x)` | 计数 | 可判定是它自己的条件 |
| Order | `World.stutter_arisingRecurs_iff` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `World.stutter_ceasingRecurs_iff` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `World.stutter_change_recurs_iff` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `World.stutter_counted` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `World.stutter_counted_of_section` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `World.stutter_premises_iff` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Order | `World.withoutIdle_counts` | `(n : Nat) → (x : v.Relatum) → Decidable (v.web.active n x)` | 计数 | 可判定是它自己的条件 |
| Order | `ceasings_moved` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (p' a n)` | 计数 | 可判定是它自己的条件 |
| Order | `ceasings_of_iff` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (q a n)` | 计数 | 可判定是它自己的条件 |
| Order | `comings_moved` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (p' a n)` | 计数 | 可判定是它自己的条件 |
| Order | `comings_of_iff` | `(a : α) → (n : Nat) → Decidable (p a n)`；`(a : α) → (n : Nat) → Decidable (q a n)` | 计数 | 可判定是它自己的条件 |
| Order | `stutter_ceasings` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Order | `stutter_comings` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| OrderNormal | `Footprinted.inList_iff` | `DecidableEq X` | 列表成员判定 | 可判定是它自己的条件 |
| Parting | `Parting.candidates_run` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.firstLive_found` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.firstLive_spec` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.late_right` | `DecidableEq R` | 首个符合者 | 可判定是它自己的条件 |
| Parting | `Parting.leastBound_right` | `DecidableEq R` | 首个符合者 | 可判定是它自己的条件 |
| Parting | `Parting.live_iff_continues` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.live_of_run` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.live_persists` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.live_succ_iff` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.run_in_candidates` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.world_right` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | 可达 | 可判定是它自己的条件 |
| Parting | `Parting.world_right_iff` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | 可达 | 可判定是它自己的条件 |
| Persistence | `Reidentify.exchangeAfter_across` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `Reidentify.exchangeAfter_at` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `Reidentify.exchangeAfter_elsewhere` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `Reidentify.exchangeAfter_next` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `World.exchangeAfter_balanced` | `DecidableEq w.Relatum` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `transpose_alike` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `transpose_left` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `transpose_other` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `transpose_right` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Persistence | `transpose_transpose` | `DecidableEq X` | 交换两个值 | 可判定是它自己的条件 |
| Population | `Listed.across` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | `Counts.listed_across`（无前提 |
| Population | `Listed.across_at` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | `Counts.listed_across`（无前提 |
| Population | `Listed.ceasing_iff_shortfall` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.ceasing_iff_shortfall_from` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.ceasing_of_outpacing` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.ceasings_within` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.coming_iff_excess` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.coming_iff_excess_from` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.comings_within` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.keeps` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.keeps_at` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Listed.over_stretch` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | `Counts.listed_over_stretch`（无前提 |
| Population | `Listed.over_stretch_on` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | `Counts.listed_over_stretch`（无前提 |
| Population | `Listed.tally` | `(a : α) → (t : Nat) → Decidable (p a t)` | 计数 | 可判定是它自己的条件 |
| Population | `Web.Census.over_stretch` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Population | `Web.Census.over_stretch_on` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Population | `Web.DependenceCensus.over_stretch` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | 计数 | 可判定是它自己的条件 |
| Population | `Web.DependenceCensus.over_stretch_on` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | 计数 | 可判定是它自己的条件 |
| Population | `mark_add_not` | `Decidable q`；`Decidable r` | 计数 | 可判定是它自己的条件 |
| Population | `mark_le_total` | `(a : α) → Decidable (q a)`；`Decidable P` | 计数 | 可判定是它自己的条件 |
| Population | `mark_one` | `Decidable p` | 计数 | 可判定是它自己的条件 |
| Population | `mark_turn` | `Decidable p`；`Decidable q` | 计数 | 可判定是它自己的条件 |
| Population | `mark_zero` | `Decidable p` | 计数 | 可判定是它自己的条件 |
| Population | `marks_le_of_sub` | `(a : α) → Decidable (q a)`；`(a : α) → Decidable (r a)` | 计数 | 可判定是它自己的条件 |
| Population | `total_le_mark` | `(a : α) → Decidable (q a)`；`Decidable P` | 计数 | 可判定是它自己的条件 |
| Premises | `World.keep_lists` | `(x : w.Relatum) → Decidable (w.web.active t x)` | 保留的列表 | 可判定是它自己的条件 |
| Premises | `keep_distinct` | `(a : α) → Decidable (p a)` | 保留的列表 | 可判定是它自己的条件 |
| Premises | `listed_of_ever` | `(a : α) → (t : Nat) → Decidable (p a t)` | 保留的列表 | 可判定是它自己的条件 |
| Premises | `mem_keep` | `(a : α) → Decidable (p a)` | 保留的列表 | 可判定是它自己的条件 |
| Propagation | `ExchangeLaw.exchangeGap_le_mixCells` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Propagation | `mixCells_either` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Propagation | `mixCells_listed` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Reading | `Flow.adopt_census` | `(t : Nat) → (f : Option F) → Decidable ((L.withImbalance W).Exchanging t f)` | 保留的列表 | 可判定是它自己的条件 |
| Reading | `Flow.readOff_census` | `(t : Nat) → (f : F) → Decidable (L.Exchanging t f)` | 保留的列表 | 可判定是它自己的条件 |
| Readout | `Readout.firstJudge_judges` | `DecidableEq K` | 首个符合者 | 可判定是它自己的条件 |
| Readout | `Readout.pick_of` | `Decidable p` | 造出指示 | 可判定是它自己的条件 |
| Readout | `Readout.pick_of_not` | `Decidable p` | 造出指示 | 可判定是它自己的条件 |
| Regrouping | `Web.admits_iff_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | 造出指示 | 可判定是它自己的条件 |
| Regrouping | `Web.admits_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | 造出指示 | 可判定是它自己的条件 |
| Regrouping | `Web.regroup_faithful_iff_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | 造出指示 | 可判定是它自己的条件 |
| Regrouping | `Web.same_admission_iff_requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | 造出指示 | 可判定是它自己的条件 |
| RegroupingSelection | `Web.group_keeps_selections_iff_faithful` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | 造出指示 | 可判定是它自己的条件 |
| RegroupingSelection | `Web.merged_requirement_loses_selection` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` | 造出指示 | 可判定是它自己的条件 |
| Reserve | `Web.Carries.lasts` | `(t : Nat) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Reserve | `Web.Carries.lasts_within` | `(t : Nat) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Reserve | `Web.Carries.step` | `Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Reserve | `Web.CarriesAcross.step` | `Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Reserve | `Web.lasts_on` | `(t : Nat) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Reserve | `Web.redirect_dependent` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` | 移开依存 | 可判定是它自己的条件 |
| Reserve | `Web.redirect_same` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` | 移开依存 | 可判定是它自己的条件 |
| Reserve | `Web.redirect_supported_at` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` | 移开依存 | 可判定是它自己的条件 |
| Resolution | `Web.CarriesAt.lasts` | `(t : Nat) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Resolution | `Web.CarriesIn.lasts_unrefined` | `(t : Nat) → Decidable (W.active t f)` | 计数 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.bracket` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.bracket_settles_iff` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.change_unlocated` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.changes_const` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.changes_le` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.changes_split` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.excursion_changes` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.moved_changes` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Retrodiction | `Retrodiction.step_changes` | `DecidableEq R` | 分辨相同 | 可判定是它自己的条件 |
| Runaway | `Flow.BalancesOn.raise` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Runaway | `Web.Dependent.raise` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Runaway | `Web.Supported.raise` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Runaway | `Web.break_not_bounded` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Runaway | `Web.le_raise` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Runaway | `Web.observed_raise_registers` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Runaway | `Web.raise_other` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Runaway | `Web.registersAlike_raise` | `DecidableEq C` | 抬高一个条件 | 可判定是它自己的条件 |
| Sampling | `Flow.BalancesOn.sample` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.DissipatesOn.sample` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.RunsDownOn.sample` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.RunsDownOn.sample_of_fine` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.gateBy_dissipates` | `Decidable p` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.pos_of_gated` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_acting` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_acting_on` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_balances` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_closed` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_closedAt_iff` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_dissipative` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_give_total` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_given` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_given_on` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_once` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_take_total` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_taken` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_taken_on` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_taking` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.sample_taking_on` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `Flow.unionPresent_spec` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_acting` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_arisingRecurs` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)`；`DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_balanced` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_ceasingRecurs` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)`；`DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_counted` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_dependent` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_dissipative` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_embodied` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_finite` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_rests_unrefuted` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_survives` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `World.sample_taking` | `DecidableEq w.Relatum` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `gateBy_of` | `Decidable p` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `gateBy_of_not` | `Decidable p` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `gateBy_zero` | `Decidable p` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `gate_mem` | `DecidableEq α` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `mem_adjoin` | `DecidableEq α` | 不重复的列表 | 可判定是它自己的条件 |
| Sampling | `mem_insertNew` | `Decidable (a ∈ l)` | 不重复的列表 | 可判定是它自己的条件 |
| Sampling | `mem_of_gateBy_pos` | `Decidable p` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `mem_of_gate_pos` | `DecidableEq α` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `total_gate` | `DecidableEq α` | 较粗的读法 | 可判定是它自己的条件 |
| Sampling | `total_gateBy` | `Decidable p` | 较粗的读法 | 可判定是它自己的条件 |
| Segmentation | `Segmentation.bond_unique` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Segmentation | `Segmentation.no_record_groups` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Segmentation | `Segmentation.transitions_le` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Selection | `Relabel.Equivariant.none_of_full_tie` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.Equivariant.tied` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.Equivariant.untied` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.EquivariantChoice.selects` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.EquivariantChoice.untied` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.EquivariantChoice.withholds_of_full_tie` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.EquivariantValue.const` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.EquivariantValue.full_tie` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.EquivariantValue.level` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.EquivariantValue.tied` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.alone_equivariant` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.entry_equivariant` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.fixed_of_tied` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.map_swap_eq_some` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.selected_alike_iff` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.singled_iff_untied` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.swap_inj` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.swap_left` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.swap_other` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.swap_right` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.swap_swap` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Selection | `Relabel.valued_alike_iff` | `DecidableEq K` | 交换两个值 | 可判定是它自己的条件 |
| Sensitivity | `mixIn_alike_of_insensitiveAt` | `DecidableEq C` | 逐个条件换入 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_differs` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_insensitive` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_no_least_registration` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_nonanticipating` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_not_readsFinitely` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_not_sensitive` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_not_through` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_not_through_sensitive` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_reads_from` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `tailLaw_through_from` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `vanishIndicator_eq_of_agree` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `vanishIndicator_eq_one` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `vanishIndicator_eq_zero` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `vanishIndicator_ones` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Sensitivity | `vanishIndicator_zeros` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Situations | `Situations.mul_indicator` | `Decidable c` | 分情形 | 可判定是它自己的条件 |
| Situations | `Situations.occ_courses` | `DecidableEq A`；`DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Situations | `Situations.occ_courses_once` | `DecidableEq A`；`DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Situations | `Situations.occ_map_cons` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Situations | `Situations.occ_map_pair` | `DecidableEq A`；`DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Situations | `Situations.occ_openSteps` | `DecidableEq A`；`DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Situations | `Situations.situations_of_course_listed` | `DecidableEq A`；`DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Situations | `Situations.situations_take` | `DecidableEq A`；`DecidableEq S` | 分辨相同 | 可判定是它自己的条件 |
| Situations | `Situations.sum_only` | `DecidableEq α` | 分辨相同 | 可判定是它自己的条件 |
| Standing | `World.Embodied.standingMarksHold_iff` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Standing | `World.Embodied.tally_of_stands` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 计数 | 可判定是它自己的条件 |
| Standing | `ceasings_congr` | `(a : α) → (t : Nat) → Decidable (p a t)`；`(a : α) → (t : Nat) → Decidable (q a t)` | 计数 | 可判定是它自己的条件 |
| Standing | `comings_congr` | `(a : α) → (t : Nat) → Decidable (p a t)`；`(a : α) → (t : Nat) → Decidable (q a t)` | 计数 | 可判定是它自己的条件 |
| Tail | `neverIndicator_add_vanishIndicator` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)`；`(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverIndicator_changedByNoCondition` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverIndicator_eq_of_agree` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverIndicator_eq_one` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverIndicator_eq_zero` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverIndicator_ones` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverIndicator_zeros` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverLaw_differs` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverLaw_insensitive` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverLaw_nonanticipating` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `neverLaw_not_sensitive` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `raisedFrom_false` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `raisedFrom_of` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `tailLaw_eq_wholeLaw` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `vanishIndicator_changedByNoCondition` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `vanishesFrom_never_iff` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `vanishesFrom_of` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tail | `vanishesFrom_true` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 造出指示 | 可判定是它自己的条件 |
| Tower | `Tower.balances_coarser` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.changes_within` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.dissipative_coarser` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.flow_sample` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.level_zero` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.reads_strict` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.strict` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.web_sample` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Tower | `Tower.web_zero` | `DecidableEq F` | 较粗的读法 | 可判定是它自己的条件 |
| Viability | `Viability.agrees_of_within` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Viability | `Viability.guardedStep_none` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Viability | `Viability.guarded_iff` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Viability | `Viability.guarded_never_fails_iff` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Viability | `Viability.ready_of_step` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Viability | `Viability.step_of_ready` | `DecidablePred guard` | 守护之步 | 可判定是它自己的条件 |
| Weighted | `mass_dirac_pos` | `DecidableEq Ω` | 分辨相同 | 可判定是它自己的条件 |
| Weighted | `mem_of_mass_dirac_pos` | `DecidableEq Ω` | 分辨相同 | 可判定是它自己的条件 |

<a id="只在证明中用到可判定性的定理--theorems-using-decidability-only-in-proofs"></a>
## 只在证明中用到可判定性的定理

| 模块 | 定理 | 可判定 | 理由 | 另一形式 |
|---|---|---|---|---|
| Attraction | `Law.lossless_iff_none_drawn` | `DecidableEq S` | 分辨相同 | `Law.Lossless.not_drawn`、`Law.none_drawn_merges_nothing`（不判定 |
| Attraction | `Law.none_drawn_lossless` | `DecidableEq S` | 分辨相同 | `Law.none_drawn_merges_nothing`（不判定 |
| Change | `Web.arising_recurs_iff` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | 同上 |
| Change | `Web.unceasing_iff` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | `Web.unceasing_iff_decided`（从某步起已定 |
| Change | `Web.unceasing_iff_covering` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Change | `coming_recurs_iff` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | `Recurs.ceasing_not_stopping`、`Recurs.coming_not_stopping`（无前提 / no premise）；`coming_recurs_iff_decided`（从某步起已定 / decided from some step on） |
| Change | `persists` | `(t : Nat) → Decidable (p t)` | 分情形 | `stays_failing`（不成立的持续，不判定 / failing persists, no decision）；`persists_of_em` 示其需要 / shows the need |
| Contacts | `Contacts.added_gains` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.answers_iff` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.blind_misses` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.keeps_data_iff` | `DecidableEq I`；`∀ (i : I), D t i ∨ ¬D t i` | 分辨相同 | — |
| Contacts | `Contacts.keeps_iff_retains` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.mem_or_not` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.retired_loses` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.selections_survive_iff` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.survive_data_iff` | `DecidableEq I`；`∀ (i : I), D t i ∨ ¬D t i` | 分辨相同 | — |
| Contacts | `Contacts.through_at_iff` | `DecidableEq I` | 分辨相同 | — |
| Contacts | `Contacts.through_data_iff` | `DecidableEq I`；`∀ (i : I), D i ∨ ¬D i` | 分辨相同 | — |
| Contacts | `Contacts.trace_keeps_of_retains` | `DecidableEq I` | 分辨相同 | — |
| Continuation | `Flow.fed_from_beyond` | `DecidableEq C` | 分辨相同 | — |
| Continuation | `Flow.fed_from_beyond_from` | `DecidableEq C` | 分辨相同 | — |
| Continuation | `Flow.fed_of_not_inward` | `DecidableEq C` | 分辨相同 | — |
| Continuation | `Flow.inward_iff_not_fed` | `DecidableEq C` | 分辨相同 | — |
| Continuation | `Flow.inward_of_not_fed` | `DecidableEq C` | 分辨相同 | — |
| Continuation | `Flow.rising_fed_from_beyond` | `DecidableEq C` | 分辨相同 | — |
| Continuation | `Flow.rising_fed_from_beyond_from` | `DecidableEq C` | 分辨相同 | — |
| Continuation | `Web.embodiedArising_fed_from_beyond` | `DecidableEq X` | 分辨相同 | — |
| Counterfactual | `ExchangeLaw.Nonanticipating.through_of_observed` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.Nonanticipating.through_all`（不判定 / no decision, P80）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Counterfactual | `ExchangeLaw.Nonanticipating.through_sensitive` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.Nonanticipating.through_all`（不判定 / no decision, P80）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Counterfactual | `alike_of_sensitive_agree` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 |
| Counterfactual | `comparison_through_sensitivity` | `DecidableEq C` | 分辨相同 | `comparison_of_courses`（经律所经的识，不判定 |
| Coupling | `lumped_upto_iff` | `DecidableEq K` | 分辨相同 | — |
| Coupling | `no_policy_upto_iff` | `DecidableEq A`；`DecidableEq K` | 找出 | — |
| Coupling | `throughout_or_fails` | `(n : Nat) → Decidable (p n)` | 找出 | — |
| CourseWorlds | `TwoActs.gap_le_carried` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `TwoActs.gap_le_carried_read` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `TwoActs.gap_le_count` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `TwoActs.gap_le_polynomial` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `TwoActs.gap_le_polynomial_before` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `TwoActs.gap_le_polynomial_from` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `carrying_twoActs` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `gap_polynomial_iff_no_loop_worlds` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `gap_within_order_iff_worlds` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `most_difference_courses_worlds` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `most_difference_within_worlds` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `most_difference_worlds` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `runaway_worlds` | `DecidableEq C` | 分辨相同 | — |
| CourseWorlds | `worlds_iff_flows` | `DecidableEq C` | 分辨相同 | — |
| Courses | `Courses.claims_every_weighting_iff` | `DecidableEq S` | 造出指示 | — |
| Courses | `Courses.course_reaches_iff_variant` | `DecidablePred target` | 造出指示 | — |
| Courses | `Courses.course_resolves_every_iff` | `DecidableEq M` | 分辨相同 | — |
| Courses | `Courses.extension_frontier_exists` | `∀ (a b : S), a ∈ x :: rest → b ∈ x :: rest → Becoming.WeaklyDecided (Becoming.Extension F living b a)` | 找出 | — |
| Courses | `Courses.extension_frontier_has_iff` | `∀ (a : S), a ∈ menu → Becoming.Decided (task a)`；`∀ (a b : S), a ∈ menu → b ∈ menu → Becoming.Decided (Becoming.Extension F living b a)` | 找出 | — |
| Courses | `Courses.run_judges_iff` | `DecidableEq K` | 找出 | — |
| Courses | `Courses.run_resolves_explained_iff` | `DecidableEq M` | 分辨相同 | — |
| Courses | `Courses.run_resolves_iff` | `DecidableEq M` | 分辨相同 | — |
| Courses | `Courses.runs_look_right_iff` | `DecidableEq O`；`DecidableEq V` | 分辨相同 | — |
| Courses | `Courses.runs_reading_right_iff` | `DecidableEq O`；`DecidableEq V` | 分辨相同 | — |
| CrossSituational | `CrossSituational.candidates_eq_iff` | `DecidableEq M` | 分辨相同 | — |
| CrossSituational | `CrossSituational.reads_every_iff` | `DecidableEq M` | 分辨相同 | — |
| CrossSituational | `CrossSituational.resolves_explained_iff` | `DecidableEq M` | 分辨相同 | — |
| CrossSituational | `CrossSituational.resolves_iff` | `DecidableEq M` | 分辨相同 | — |
| Decidedness | `Counts.over_stretch_decided` | `∀ (a : α), a ∈ as → ∀ (t : Nat), t ∈ Becoming.steps S (n + 1) → Becoming.Decided (p a t)` | 分情形 | — |
| Decidedness | `Decided.and` | `Becoming.Decided p`；`Becoming.Decided q` | 分情形 | — |
| Decidedness | `Decided.exists_below` | `∀ (t : Nat), M ≤ t → t < U → Becoming.Decided (P t)` | 分情形 | — |
| Decidedness | `Decided.exists_mem` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | 分情形 | — |
| Decidedness | `Decided.not` | `Becoming.Decided p` | 分情形 | — |
| Decidedness | `Decided.of_not_not` | `Becoming.Decided p` | 分情形 | — |
| Decidedness | `Decided.weakly` | `Becoming.Decided p` | 分情形 | — |
| Decidedness | `World.arising_iff_ceasing_of_decidable` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | — |
| Decidedness | `bettered_of_undominated_has` | `∀ (a b : β), a ∈ menu → b ∈ menu → Becoming.Decided (better a b)` | 找出 | — |
| Decidedness | `exists_undominated` | `∀ (a b : β), a ∈ x :: rest → b ∈ x :: rest → Becoming.WeaklyDecided (better a b)` | 找出 | — |
| Decidedness | `undominated_has` | `∀ (a : β), a ∈ menu → Becoming.Decided (P a)` | 分情形 | — |
| Decidedness | `undominated_has_iff` | `∀ (a : β), a ∈ menu → Becoming.Decided (P a)`；`∀ (a b : β), a ∈ menu → b ∈ menu → Becoming.Decided (better a b)` | 找出 | — |
| Diagonal | `Diagonal.alike_of_complete` | `(x : B) → Decidable (x = b)` | 分辨相同 | — |
| Diagonal | `Diagonal.complete_iff_alike` | `DecidableEq B` | 分辨相同 | — |
| Dissipation | `Flow.Enclosed.around` | `DecidableEq C` | 造出列表 | `Flow.Enclosed.around_not_not`（不判定 |
| Distinguishing | `Law.labelled_finite` | `DecidableEq A`；`DecidableEq S` | 分辨相同 | — |
| Feedback | `Flow.Balances.adds_iff_exceeds_of_decidable` | `(t : Nat) → (g : F) → Decidable (sig p t g)` | 分情形 | — |
| Frequency | `gap_le_count` | `DecidableEq C` | 分辨相同 | — |
| Gated | `Gated.change_located` | `DecidableEq R` | 分辨相同 | — |
| Gated | `Gated.origin_of_decides` | `∀ (a : A), gate a ∨ ¬gate a` | 分情形 | — |
| Gluing | `ParityConstraint.met_or_contradicts` | `DecidableEq C` | 分辨相同 | — |
| Gluing | `ParitySystem.global_or_contradicts` | `DecidableEq C` | 分辨相同 | — |
| Gluing | `ParitySystem.glues_iff` | `DecidableEq C` | 分辨相同 | — |
| Gluing | `ParitySystem.noGlobal_iff` | `DecidableEq C` | 分辨相同 | — |
| Granularity | `Frame.byRecipes_translates` | `Becoming.TestsDecided F` | 找出 | — |
| Granularity | `Frame.holds_byRecipes` | `Becoming.TestsDecided F` | 找出 | — |
| Granularity | `Recipe.holds_after` | `Becoming.TestsDecided F` | 找出 | — |
| Granularity | `Recipe.outcomes` | `Becoming.TestsDecided F` | 造出列表 | — |
| Identification | `Identification.bounded_induction` | `DecidableEq O` | 分辨相同 | — |
| Identification | `Identification.fits_of_unrefuted` | `DecidableEq O` | 分辨相同 | — |
| Identification | `Identification.sameAhead_iff_classes` | `∀ (n m : Nat), Becoming.Decided (o n = o m)` | 分辨相同 | `Identification.sameAhead_iff_within`（N − 1，无前提，判定位置 / no premise, positions decided）；`Identification.sameAhead_iff_below`（2N − 1，无前提 / no premise） |
| Identification | `Identification.unrefuted_persists` | `DecidableEq O` | 分辨相同 | — |
| Identification | `Law.AgreeTo.decided` | `∀ (s s' : S), s ∈ l → s' ∈ l → Becoming.Decided (o s = o s')` | 分情形 | — |
| Identification | `Law.sameFuture_iff_classes` | `∀ (s s' : S), s ∈ l → s' ∈ l → Becoming.Decided (o s = o s')` | 分辨相同 | `Law.sameFuture_iff_within`（N − 1，无前提，判定位置 / no premise, positions decided）；`Law.sameFuture_classes_unrefuted`（不判定，不被否证 / no decision, refuted by nothing）；`Law.sameFuture_iff_below`（2N − 1，无前提 / no premise） |
| Identity | `Flow.More.unceasingFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)` | 找出 | — |
| Identity | `Flow.More.unceasing_reidentified` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Identity | `Flow.More.unceasing_reidentified_covering` | `(s : Nat) → (f : F) → S ≤ s → Decidable (W.active s f)` | 找出 | — |
| Identity | `Web.Census.arisingFrom_of_ceasingFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 找出 | — |
| Identity | `Web.Census.arisingFrom_of_ceasingFrom_from` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 找出 | — |
| Identity | `Web.Census.ceasingFrom_of_arisingFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 找出 | — |
| Identity | `Web.Census.ceasingFrom_of_arisingFrom_from` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 找出 | — |
| Identity | `Web.arisesFrom_of_more` | `(f : F) → Decidable (W.Continues R t f)` | 找出 | — |
| Identity | `Web.unceasingFrom_of_growth` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)` | 找出 | — |
| Identity | `forces_iff_noSplit` | `DecidableEq F` | 分辨相同 | — |
| Lasting | `Lasting.TwoChains.branching` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | 造出列表 | — |
| Lasting | `Lasting.list_throughout_not_not` | `∀ (k : Nat) (b : β), Becoming.Decided (Q k b)` | 分情形 | — |
| Lasting | `Lasting.orbit_reaches_iff_variant` | `DecidablePred target` | 造出指示 | — |
| Lasting | `Lasting.reaches_iff_histories` | `DecidablePred target` | 找出 | — |
| Lasting | `Lasting.reaches_iff_not_lasts` | `DecidablePred target` | 找出 | — |
| Lasting | `Lasting.reaches_of_histories` | `DecidablePred target` | 找出 | — |
| Lasting | `Lasting.reaches_of_not_lasts` | `DecidablePred target` | 找出 | — |
| Learnable | `Learnable.learnable_iff` | `DecidableEq R` | 找出 | `Learnable.agree_of_predicts_both`（必要一侧，对每个学习者，不判定 |
| Learnable | `Learnable.learnable_of_lumped` | `DecidableEq R` | 找出 | — |
| Learnable | `Learnable.refuted_on_one` | `DecidableEq V` | 分辨相同 | `Learnable.claim_not_right_on_both`（无前提：主张不在两者上都对 |
| Learnable | `Learnable.still_learnable_iff_lumped` | `DecidableEq R` | 找出 | `Learnable.still_lumped_of_predicts`（必要一侧，不判定 |
| LearnableRuns | `LearnableRuns.learnable_iff` | `DecidableEq R` | 找出 | — |
| LearnableRuns | `LearnableRuns.still_learnable_iff_lumped` | `DecidableEq R` | 找出 | — |
| Learning | `Learning.claim_refuted_on_one` | `DecidableEq O` | 分辨相同 | `Learning.no_record_fixes_next`（无前提：主张不在两者上都对 |
| Learning | `Learning.determines_lumped_iff` | `DecidableEq K` | 找出 | `Learning.lumped_determines`（无前提的一个方向 |
| Learning | `Learning.eq_of_not_refuted` | `DecidableEq O` | 分辨相同 | — |
| Learning | `Learning.every_determines_nothing` | `DecidableEq I` | 分辨相同 | — |
| Learning | `Learning.every_free` | `DecidableEq I` | 分辨相同 | — |
| Likeness | `BranchingTest.apart_from_listed` | `∀ (y : S'), Becoming.Decided (q y)` | 找出 | — |
| Likeness | `Chains.outcomes` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | 造出列表 | — |
| Likeness | `Chains.outcomesListed` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | 造出列表 | — |
| Likeness | `Decided.exists_listed` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | 分情形 | — |
| Likeness | `Decided.exists_not_in` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | 找出 | — |
| Likeness | `Decided.exists_not_of_listed` | `∀ (b : β), Becoming.Decided (P b)` | 找出 | — |
| Likeness | `Decided.exists_of_listed` | `∀ (b : β), Becoming.Decided (P b)` | 分情形 | — |
| Likeness | `Decided.forall_in` | `∀ (b : β), b ∈ l → Becoming.Decided (P b)` | 分情形 | — |
| Likeness | `Decided.forall_of_listed` | `∀ (b : β), Becoming.Decided (P b)` | 分情形 | — |
| Likeness | `Decided.iff` | `Becoming.Decided p`；`Becoming.Decided q` | 分情形 | — |
| Likeness | `Decided.imp` | `Becoming.Decided p`；`Becoming.Decided q` | 分情形 | — |
| Likeness | `EitherThroughout.list` | `∀ (k : Nat) (b : β), Becoming.Decided (P k b)` | 找出 | — |
| Likeness | `LLPO.FirstAt.decided` | `∀ (k : Nat), Becoming.Decided (α k)` | 分情形 | — |
| Likeness | `LLPO.FirstAt.of_holds` | `∀ (k : Nat), Becoming.Decided (α k)` | 找出 | — |
| Likeness | `LLPO.Interleave.decided` | `∀ (k : Nat), Becoming.Decided (α k)`；`∀ (k : Nat), Becoming.Decided (β k)` | 分情形 | — |
| Likeness | `LLPO.decidable` | `(n : Nat) → Decidable (γ n)` | 造出指示 | — |
| Likeness | `OutcomesListed.forth_decided` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | 分情形 | — |
| Likeness | `OutcomesListed.matched_decided` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | 分情形 | — |
| Likeness | `OutcomesListed.unmatched` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | 找出 | — |
| Likeness | `drops_somewhere` | `∀ (k : Nat), Becoming.Decided (P k x)` | 找出 | — |
| Likeness | `forth_decided` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | 分情形 | — |
| Likeness | `stops_decreasing` | `∀ (k : Nat) (x : X), Becoming.Decided (P k x)` | 找出 | — |
| Likeness | `unmatched_of_not_forth` | `∀ (t : S) (t' : S'), Becoming.Decided (R t t')` | 找出 | — |
| Listing | `Flow.standing_lowers_decided` | `Becoming.IdentityDecided ds` | 造出列表 | — |
| Listing | `Web.arising_of_ceasing_listing` | `(t : Nat) → (a b : F) → a ∈ l t → b ∈ l t → Decidable (a = b)`；`(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | `Web.arising_of_ceasing`（给定普查；此处还用 `listOnce` 造普查 |
| Listing | `listsOnceBy_of_decided` | `∀ (a b : α), a ∈ l → b ∈ l → Becoming.Decided (R a b)` | 造出列表 | — |
| Listing | `listsOnce_of_decided` | `Becoming.IdentityDecided l` | 造出列表 | — |
| Listing | `of_listsOnce` | `Becoming.IdentityDecided l` | 造出列表 | — |
| Locality | `Covers.coming_from_of_ceasing` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | `Covers.not_not_coming_from`（无前提 |
| Locality | `Covers.within` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | — |
| Locality | `coming_of_ceasing_covered` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | `Covers.not_not_coming_from`、`Covers.ceasing_not_recurring`（无前提 |
| Loops | `gap_le_polynomial` | `DecidableEq C` | 分辨相同 | — |
| Loops | `gap_polynomial_iff_no_loop` | `DecidableEq C` | 分辨相同 | — |
| Loops | `most_difference_within` | `DecidableEq C` | 分辨相同 | — |
| LossMatching | `Frame.exists_fresh` | `DecidableEq C` | 找出 | — |
| LossMatching | `Frame.strictLossMatch_iff_length_of_alike` | `DecidableEq C` | 分辨相同 | — |
| Novelty | `upto_or_fails` | `(n : Nat) → Decidable (p n)` | 找出 | — |
| Openness | `Flow.Enclosed.aroundStanding` | `DecidableEq C` | 造出列表 | `Flow.Enclosed.aroundStanding_not_not`（不判定 |
| Openness | `Listed.few_of_quiet` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | `Listed.few_of_stop_unrefuted`（不判定 |
| Openness | `World.CountedBy.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | — |
| Openness | `World.CountedWithin.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | — |
| Openness | `World.Finite.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | — |
| Openness | `World.Finite.countedWithin` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 造出列表 | — |
| Openness | `World.arising_of_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | — |
| Openness | `World.few_active` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | `Listed.few_of_stop_unrefuted`、`World.rest_few`（不判定 |
| Openness | `comes_after` | `(t : Nat) → Decidable (p t)` | 找出 | `comes_after_unrefuted`（不判定，那一步不能被否证 |
| OrderNormal | `Footprinted.decidesIdle_iff` | `DecidableEq X` | 分辨相同 | — |
| OrderNormal | `Footprinted.least_exists_iff` | `DecidableEq X` | 分辨相同 | — |
| ParityReadings | `ParitySystem.freeFrame_iff` | `DecidableEq C` | 分辨相同 | — |
| ParityReadings | `ParitySystem.world_free_iff` | `DecidableEq C` | 分辨相同 | — |
| Parting | `Parting.free_open` | `DecidableEq V` | 分辨相同 | `Parting.free_parts_after` 与 `Parting.not_right_on_both`（无前提：不在两个运行上都对 |
| Parting | `Parting.late_statesBelow` | `DecidableEq R` | 分辨相同 | — |
| Parting | `Parting.some_right_iff` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` | 可达 | — |
| Parting | `Parting.unparted_at_of_late` | `DecidableEq R` | 分辨相同 | — |
| Parting | `Parting.unparted_iff` | `DecidableEq R` | 分辨相同 | `Parting.unparted_iff` 的正向与 `Parting.not_right_on_both`（不判定 |
| Persistence | `Web.persisting_census` | `(t : Nat) → (f : F) → Decidable ((W.persisting h).Continues R t f)`；`(t : Nat) → (f : F) → Decidable ((W.persisting h).active t f)`；`(t : Nat) → (g : F) → Decidable ((W.persisting h).Continued R t g)`；`(t : Nat) → (g f : F) → Decidable (R t g f)` | 找出 | — |
| Persistence | `World.arises_fixed_iff` | `DecidableEq w.Relatum` | 分辨相同 | — |
| Persistence | `World.ceases_fixed_iff` | `DecidableEq w.Relatum` | 分辨相同 | — |
| Persistence | `World.fixed_iff` | `DecidableEq w.Relatum` | 分辨相同 | — |
| Population | `Flow.More.unceasing` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Population | `Flow.More.unceasing_covering` | `(s : Nat) → (f : F) → S ≤ s → Decidable (W.active s f)` | 找出 | — |
| Population | `Listed.ceasing_of_coming` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | — |
| Population | `Listed.ceasing_of_returning` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | — |
| Population | `Listed.coming_iff_ceasing` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | — |
| Population | `Listed.coming_of_ceasing` | `(a : α) → (t : Nat) → Decidable (p a t)` | 找出 | — |
| Population | `Web.DependenceCensus.forming_iff_dissolving` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | 找出 | — |
| Population | `Web.DependenceCensus.forming_of_dissolving` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` | 找出 | — |
| Population | `Web.arises_of_more` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Population | `Web.arising_of_ceasing` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Population | `Web.ceasing_of_arising` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Population | `Web.unceasing_iff_bounded` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Population | `Web.unceasing_of_growth` | `(t : Nat) → (f : F) → Decidable (W.active t f)` | 找出 | — |
| Population | `came_between` | `(t : Nat) → Decidable (q t)` | 找出 | — |
| Population | `came_between_from` | `(s : Nat) → S ≤ s → Decidable (q s)` | 找出 | — |
| Population | `search` | `(a : α) → Decidable (p a)` | 找出 | — |
| Premises | `World.Finite.counted` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 造出列表 | — |
| Premises | `World.counted_of_ever` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 造出列表 | — |
| Propagation | `ExchangeLaw.carrying_respondsWithin` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `ExchangeLaw.exchangeGap_le_shares` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `ExchangeLaw.exchangeGap_le_strengths` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `ExchangeLaw.exchangeGap_le_strengths_listed` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `ExchangeLaw.insensitiveAt_iff_strength_zero` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `ExchangeLaw.sensitive_iff_strength` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `gap_le_carried` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `levels_alike_of_not_conveyed` | `DecidableEq C` | 分辨相同 | — |
| Propagation | `most_difference_arrives` | `DecidableEq C` | 分辨相同 | — |
| Readout | `Readout.commonWitness_or_covered` | `DecidableEq D` | 找出 | — |
| Readout | `Readout.judges_iff_lumpedOn` | `DecidableEq K` | 找出 | — |
| Readout | `Readout.no_common_report_envelopes_iff` | `DecidableEq D` | 找出 | — |
| Readout | `Readout.no_common_report_iff` | `DecidableEq D` | 找出 | — |
| Refinement | `Decided.exists_within` | `∀ (x : X), x ∈ l → Becoming.Decided (P x)` | 分情形 | — |
| Refinement | `Refining.grow` | `∀ (k : Nat) (x y : X), x ∈ l → y ∈ l → Becoming.Decided (R k x y)` | 分情形 | — |
| Refinement | `Refining.steady_or_grown` | `∀ (k : Nat) (x y : X), x ∈ l → y ∈ l → Becoming.Decided (R k x y)` | 找出 | — |
| Refinement | `Refining.steady_within` | `∀ (k : Nat) (x y : X), x ∈ l → y ∈ l → Becoming.Decided (R k x y)` | 找出 | — |
| Remainder | `gap_within_order_iff` | `DecidableEq C` | 分辨相同 | — |
| Response | `Flow.Balances.comparison_within_response_of_decidable` | `(g : F) → Decidable (L.WithinResponse L' W obs part g)` | 分辨相同 | `Flow.Balances.comparison_within_response`（覆盖不被否证在回应所及之内者，不判定 |
| Retrodiction | `Retrodiction.fits_or_separated` | `DecidableEq O` | 分辨相同 | — |
| Retrodiction | `Retrodiction.look_right_iff` | `DecidableEq O`；`DecidableEq V` | 分辨相同 | — |
| Retrodiction | `Retrodiction.reading_right_iff` | `DecidableEq O`；`DecidableEq V` | 分辨相同 | — |
| Runaway | `Flow.exchangeFollows_of_policy` | `DecidableEq F` | 分辨相同 | — |
| Runaway | `Flow.policy_keeps_difference` | `DecidableEq C`；`DecidableEq F` | 分辨相同 | — |
| Runaway | `Flow.policy_uses_after_failure` | `DecidableEq F` | 分辨相同 | — |
| Sampling | `Flow.sample_ceasesToStand_iff` | `DecidableEq F` | 造出列表 | — |
| Sampling | `Flow.sample_changes_iff` | `DecidableEq F` | 造出列表 | — |
| Sampling | `Flow.sample_comesToStand_iff` | `DecidableEq F` | 造出列表 | — |
| Sampling | `Web.sample_arises` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | 找出 | — |
| Sampling | `Web.sample_ceases` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | 找出 | — |
| Sampling | `Web.sample_ceasing` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | 找出 | — |
| Sampling | `Web.sample_unceasing` | `(t : Nat) → (x : F) → Decidable (W.active t x)` | 找出 | — |
| Sampling | `arises_within` | `(n : Nat) → Decidable (p n)` | 找出 | — |
| Sampling | `ceases_within` | `(n : Nat) → Decidable (p n)` | 找出 | — |
| Selection | `Relabel.alone_single` | `DecidableEq K` | 分辨相同 | — |
| Selection | `Web.scores_alike_iff` | `(m : Nat → C → Nat) → Decidable (W.RegistersAlikeUpTo obs g l m t)` | 造出指示 | `Web.selects_alike_iff`（选择而非分数，不判定 |
| Sensitivity | `ExchangeLaw.Nonanticipating.through_sensitive_of_every` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `ExchangeLaw.ReadsFinitely.alike_of_insensitive` | `DecidableEq C` | 分辨相同 | — |
| Sensitivity | `ExchangeLaw.ReadsFinitely.least_registration` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `ExchangeLaw.ReadsFinitely.through_of_observed` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `ExchangeLaw.ReadsFinitely.through_sensitive` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `alike_of_insensitiveAt_within` | `DecidableEq C` | 分辨相同 | — |
| Sensitivity | `alike_of_sensitive_agree_within` | `DecidableEq C` | 分辨相同 | `ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision） |
| Sensitivity | `comparison_through_sensitivity_of_readsFinitely` | `DecidableEq C` | 分辨相同 | `comparison_of_courses`（经律所经的识，不判定 |
| Sensitivity | `lpo_of_vanish_decided` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` | 分情形 | — |
| Space | `World.arising_iff_ceasing` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | `World.ceasing_not_stopping`、`World.arising_not_stopping`（无前提 / no premise）；`World.arising_iff_ceasing_decided`（从某步起已定 / decided from some step on） |
| Space | `World.arising_iff_ceasing_covering` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` | 找出 | — |
| Standpoints | `Flow.boundary_crossed` | `DecidableEq X` | 分辨相同 | — |
| Standpoints | `Flow.region_not_a_cut` | `DecidableEq X` | 分辨相同 | — |
| Standpoints | `Valuation.significant_iff_reached` | `(c : C) → Decidable (∃ p, V.own p c)` | 分情形 | — |
| Substitution | `ceasing_step` | `DecidablePred p` | 找出 | — |
| Tail | `LPO.of_rule` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` | 分情形 | — |
| Tail | `WLPO.of_rule` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` | 分情形 | — |
| Testing | `Flow.subthreshold_alike` | `DecidableEq C` | 分辨相同 | — |
| Testing | `Flow.subthreshold_alike_always` | `DecidableEq C` | 分辨相同 | — |
| Testing | `Web.alike_of_threshold` | `DecidableEq C` | 分辨相同 | — |
| Testing | `Web.tail_unrefuted` | `DecidableEq C` | 分辨相同 | — |
| TimedResponse | `TimedResponse.different_answers_require_reached` | `Decidable (Becoming.TimedResponse.ReachedBy L L' W obs source g D)` | 分情形 | — |
| Transmission | `Flow.transmitsWithin_iff_split` | `(t : Nat) → (x : X) → Decidable (W.requires t x c)` | 分情形 | — |
| Transmission | `Web.inheritsAt_of_split` | `Decidable (W.requires t x c)` | 分情形 | `Web.inheritsAt_not_not`（不判定时继承不能被否证 |
| Unfolding | `Frame.claims_recur_iff` | `(c : C) → (t : Nat) → Decidable (F.realized (r.state t) c)` | 找出 | — |
| Weighted | `every_weighting_iff` | `DecidableEq Ω` | 造出指示 | — |

<a id="排中律或其受限形式作为假设--excluded-middle-in-full-or-restricted-form-as-a-hypothesis"></a>
## 排中律或其受限形式作为假设

这些是边界定理：它们表明排中律或其受限形式（例如 `NowhereDecided`：一个已判定的族是否处处不成立已判定）给出什么，配合 `World.law_iff_em`、`World.law_decides`、`World.lpo_of_finite_ends`、`Listed.lpo_of_few`、`Web.lpo_of_ending`、`ChangeBound.lpo_of_ends`、`alike_decided_iff_em`、`alike_of_sameBranchingTests_iff_em`、`alike_of_sameBranchingTests_decided_steps_iff_em`、`alike_of_sameBranchingTests_outcomes_iff`、`matchesParts_of_compact_iff_em`、`jointAlike_of_sameJointTests_iff_em`、`Recipe.holds_after_iff_em`、`exists_undominated_iff_weakly`、`undominated_has_iff_em`、`Gated.origin_of_propositions_iff`、`refutable_passes_iff_markov`、`Lasting.step_iff_either`，表明命名一步、对每个世界要求复现、由检验判定相同、把配方读作一个检验、找出不被胜过的选项、在门上定位起源、由前缀检验否证、或在有限分支处找到无界的后继的形式需要可判定性。

<a id="计数而可判定被证明--counting-with-decidedness-proved"></a>
## 计数而可判定被证明

这些定理的陈述计数，但不以可判定为假设：可判定由见证世界或体现证明（例如 `Embodied.decided`）。按模块计：

- LossMatching: 1

<a id="计数的原语--counting-primitives"></a>
## 计数的原语

| 模块 | 定义 | 可判定 |
|---|---|---|
| Change | `Web.instDecidableArises` | `(t : Nat) → (f : F) → Decidable (W.active t f)` |
| Change | `Web.instDecidableCeases` | `(t : Nat) → (f : F) → Decidable (W.active t f)` |
| Change | `ceasings` | `(a : α) → (t : Nat) → Decidable (p a t)` |
| Change | `comings` | `(a : α) → (t : Nat) → Decidable (p a t)` |
| Change | `instDecidableCeasesToBe` | `(t : Nat) → Decidable (p t)` |
| Change | `instDecidableComesToBe` | `(t : Nat) → Decidable (p t)` |
| Change | `mark` | `Decidable p` |
| Contacts | `Contacts.spot` | `DecidableEq I` |
| Copying | `Copying.Supplies` | `DecidableEq α` |
| Copying | `Copying.batch` | `DecidableEq α` |
| Copying | `Copying.countOf` | `DecidableEq α` |
| Copying | `Copying.defects` | `DecidableEq α` |
| Copying | `Copying.exchange` | `DecidableEq α` |
| Copying | `Copying.exchangeAt` | `DecidableEq α` |
| Copying | `Copying.inspect` | `DecidableEq α` |
| Copying | `Copying.inspectAt` | `DecidableEq α` |
| Copying | `Copying.pairDraw` | `DecidableEq α` |
| Copying | `Copying.readStep` | `DecidableEq α` |
| Copying | `Copying.readSteps` | `DecidableEq α` |
| Copying | `Copying.readTick` | `DecidableEq α` |
| Copying | `Copying.remove` | `DecidableEq α` |
| Copying | `Copying.removeAll` | `DecidableEq α` |
| Copying | `Copying.scanSites` | `DecidableEq α` |
| Copying | `Copying.steps` | `DecidableEq α` |
| Copying | `Copying.tick` | `DecidableEq α` |
| Copying | `Copying.unlikeFrom` | `DecidableEq α` |
| Counterfactual | `mixIn` | `DecidableEq C` |
| Counting | `World.CensusMarksHold` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` |
| Counting | `World.saturated_decided` | `(t : Nat) → (x : w.Relatum) → Decidable (w.web.active t x)` |
| Coupling | `policyUpto` | `DecidableEq K` |
| Courses | `Courses.inspection` | `DecidableEq α` |
| Courses | `Courses.release` | `DecidableEq α` |
| Dissipation | `adjoin` | `DecidableEq α` |
| Dissipation | `decideMem` | `DecidableEq α` |
| Dissipation | `insertNew` | `Decidable (a ∈ l)` |
| Identification | `Identification.decBorneOut` | `DecidableEq O` |
| Identification | `Identification.decFits` | `DecidableEq O` |
| Identification | `Identification.firstFit` | `(a : α) → Decidable (p a)` |
| Identification | `Identification.leastBound` | `DecidableEq O` |
| Identification | `Identification.leastFit` | `DecidableEq O` |
| Identification | `Identification.withBound` | `DecidableEq O` |
| Identification | `Law.decideAlike` | `DecidableEq R` |
| Identity | `Web.Census.decideContinued` | `(t : Nat) → (g f : F) → Decidable (R t g f)` |
| Identity | `Web.Census.decideContinues` | `(t : Nat) → (g f : F) → Decidable (R t g f)` |
| Identity | `Web.instDecidableArisesFrom` | `(t : Nat) → (f : F) → Decidable (W.Continues R t f)`；`(t : Nat) → (f : F) → Decidable (W.active t f)` |
| Identity | `Web.instDecidableCeasesFrom` | `(t : Nat) → (f : F) → Decidable (W.active t f)`；`(t : Nat) → (g : F) → Decidable (W.Continued R t g)` |
| Lasting | `Lasting.hitTime` | `DecidablePred target` |
| Learnable | `Learnable.withWorld` | `DecidableEq R` |
| Learnable | `Learnable.withWorldAt` | `DecidableEq R` |
| Learning | `Learning.decRefuted` | `DecidableEq O` |
| Learning | `Learning.decRefutedAt` | `DecidableEq O` |
| Learning | `Learning.decideSeen` | `DecidableEq K` |
| Learning | `Learning.index` | `DecidableEq O` |
| Learning | `Learning.indexOn` | `DecidableEq O` |
| Learning | `Learning.learner` | `DecidableEq O` |
| Learning | `Learning.swapTo` | `DecidableEq O` |
| Listing | `decideIn` | `(b : α) → b ∈ l → Decidable (a = b)` |
| Listing | `keepFresh` | `Decidable P` |
| Listing | `listOnce` | `(a b : α) → a ∈ l → b ∈ l → Decidable (a = b)` |
| LossMatching | `Frame.classCount` | `DecidableEq K` |
| LossMatching | `Frame.lostOf` | `(c : C) → Decidable (F.realized s c)` |
| LossMatching | `LossMatching.decideDistinct` | `DecidableEq α` |
| Onward | `Onward.decidedTest` | `(s : S) → (a : A) → (t : S) → Decidable (P.step s a t)`；`(s : S) → Decidable (K s)` |
| Order | `Web.commuteDecided` | `(n : Nat) → (f : F) → Decidable (W.active n f)` |
| OrderNormal | `Footprinted.inList` | `DecidableEq X` |
| Parting | `Parting.advance` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.advanced` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.candidates` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` |
| Parting | `Parting.firstLive` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.live` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.liveRun` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)` |
| Parting | `Parting.worldLearner` | `(x : S) → (a : A) → (y : S) → Decidable (P.step x a y)`；`DecidableEq R` |
| Persistence | `Reidentify.exchangeAfter` | `DecidableEq X` |
| Persistence | `transpose` | `DecidableEq X` |
| Population | `Web.decideDissolves` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` |
| Population | `Web.decideForms` | `(t : Nat) → (g : F) → (c : C) → Decidable (W.requires t g c)` |
| Population | `decideSome` | `(a : α) → Decidable (p a)` |
| Premises | `keep` | `(a : α) → Decidable (p a)` |
| Propagation | `mixCells` | `DecidableEq C` |
| Readout | `Readout.blame` | `DecidableEq D` |
| Readout | `Readout.firstJudge` | `DecidableEq K` |
| Readout | `Readout.pick` | `Decidable p` |
| Regrouping | `Web.requiredLevel` | `(t : Nat) → (f : F) → (c : C) → Decidable (W.requires t f c)` |
| Reserve | `Web.redirect` | `(t : Nat) → (f : F) → Decidable (W.Supported t f)` |
| Retrodiction | `Retrodiction.changes` | `DecidableEq R` |
| Runaway | `Web.raise` | `DecidableEq C` |
| Sampling | `Flow.sample` | `DecidableEq F` |
| Sampling | `Flow.unionPresent` | `DecidableEq F` |
| Sampling | `World.sample` | `DecidableEq w.Relatum` |
| Sampling | `gate` | `DecidableEq α` |
| Sampling | `gateBy` | `Decidable p` |
| Segmentation | `Segmentation.bond` | `DecidableEq α` |
| Segmentation | `Segmentation.departures` | `DecidableEq α` |
| Segmentation | `Segmentation.transitions` | `DecidableEq α` |
| Selection | `Relabel.Equivariant` | `DecidableEq K` |
| Selection | `Relabel.EquivariantChoice` | `DecidableEq K` |
| Selection | `Relabel.EquivariantValue` | `DecidableEq K` |
| Selection | `Relabel.swap` | `DecidableEq K` |
| Sensitivity | `tailLaw` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` |
| Sensitivity | `vanishIndicator` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` |
| Situations | `Situations.occ` | `DecidableEq α` |
| Standing | `World.DependenceMarksHold` | `(t : Nat) → (f c : w.Relatum) → Decidable (w.web.requires t f c)` |
| Tail | `lpoRuleOfVanishDecision` | `(α : Nat → Nat) → Decidable (Becoming.VanishFrom α)` |
| Tail | `neverIndicator` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` |
| Tail | `neverLaw` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` |
| Tail | `raisedFrom` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` |
| Tail | `vanishDecisionOfLPORule` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` |
| Tail | `vanishesFrom` | `(s : Nat → Bool) → Decidable (∀ (n : Nat), s n = false)` |
| Tail | `wlpoRuleOfLPORule` | `(s : Nat → Bool) → Decidable (∃ n, s n = true)` |
| Testing | `recordThen` | `DecidableEq C` |
| Tower | `Tower.flow` | `DecidableEq F` |
| Tower | `Tower.reads` | `DecidableEq F` |
| Tower | `Tower.refine` | `DecidableEq F` |
| Tower | `Tower.web` | `DecidableEq F` |
| Viability | `Viability.guardedHistory` | `DecidablePred guard` |
| Viability | `Viability.guardedStep` | `DecidablePred guard` |
| Weighted | `dirac` | `DecidableEq Ω` |

另：一个部分以 `part : F → Bool` 给出，它的切分由类型定下（`Becoming.Admission`、`Becoming.Significance`）；这是比较的参数，不是关于世界的前提。
