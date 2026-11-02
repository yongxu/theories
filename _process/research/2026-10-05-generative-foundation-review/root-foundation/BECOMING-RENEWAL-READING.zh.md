<a id="运行上的更新消耗与生生的关系读法--renewal-on-runs-and-the-relational-reading"></a>
# 运行上的更新／消耗与生生的关系读法

> **中文版（2026-10-17）。** 正典文本是[英文版](BECOMING-RENEWAL-READING.md)；本版由重构时从双语原文拆出，不与英文同步维护，两者有出入时以英文为准。

2026-10-09，Asia/Bangkok。AI（Claude）按 Ren 的指示“你自己全改了吧……先更新好计划，然后再一步步完整完成，保持代码和整体结构优雅”（[原话与解释](../../../../sources/15-codex-theory-conversations/2026-10-09-one-theory-unification.md)）完成[统一计划](../history/root-foundation/BECOMING-UNIFICATION-PLAN.md)的 P3b。成果记录：[becoming-renewal-reading](../../../../theories/becoming/results/records/becoming-renewal-reading.md)。

## 1. 问题

Universal Metaethical Core 的前提卡里有三项对应：形成 E、连通、`living` 的读法。在 P2 中，`living` 和 `related` 是 `Valuation` 的外给参数，连通是假设。P3b 要回答的是：Becoming 层能否从展开本身给出这两项，从而让连通成为可以检查的动力学性质，而不是一条前提？

这里的“形成”和“条件”是同一展开中的分析角色：一个形成依存于某些条件，或从某些条件中汲取，或两者兼有。它们不是彼此独立的实体，也不是价值的所有者。在 Lean 中，它们是贯穿运行的固定索引类型，形成跨步的同一性由 `F` 规定（它在哪些读法中起作用，见 §16）；`draws` 只记录一个形成汲取某个条件，不记录汲取多少，水平的变化由过程给出。这两项省略在 §7 的审查后写明。两类的表示是一类关系项读法的特例，见 §18（P14）。

## 2. 结果

全部声明都在脊柱上，公理报告为空（[回执](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json)）。

**L3，[Becoming.Renewal](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Renewal.lean)：只讲动力学，不含伦理谓词。**

| 声明 | 内容 |
|---|---|
| `Conditions`、`Conditions.along` | 条件水平、活跃的形成、依存与汲取都是配置上的可观测量。经这些可观测量读出的运行，就是一个 `RelationalRenewal.Unfolding`，该模块的全部定理都适用于它 |
| `falls_finitely` | 一个从某步起不再上升的自然数可观测量，只能下降有限次 |
| `Run.not_of_depletion`、`no_execution_of_depletion` | 每步都降低储备，则没有运行。这正是 `Depletion` 的陈述，由上面的原则导出 |
| `Run.renewal_recurs` | 凡非更新之步都降低秩，则任何尾段都不会没有更新。这是 `ContinuationRenewal` 自然数秩形式的否定式 |
| `Conditions.drawdown_finite` | 沿运行的无更新汲取：活跃次数有限 |
| `Commons.class_belongs_to_the_run` | 同一过程、同一初始配置，两次运行中焦点形成每一步都活跃；一次在更新之内，另一次消耗维持者的条件，维持者随之终止 |

**L4 读法，[Becoming.Metaethics](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Metaethics.lean) 的“The relational reading”一节。**

| 声明 | 内容 |
|---|---|
| `Conditions.valuation` | 形成事件 `(形成, 步)` 的读法有两条：活跃且在该运行中不消耗者为 living；两个事件的形成共同参与某一条件，即为 related |
| `living_iff_relational`（在外围桥接 `Becoming.Bridge` 中） | 这一 `living` 就是已记录的[关系读法](../../../../theories/becoming/results/records/relational-reading-comparison.md) |
| `connected_of_common`、`significant_iff_of_common` | 如果每个活的形成都参与同一个条件，整体就是连通的；于是 G0 恰等于种子加 N_rel 加 N_std。连通由共同参与给出，但依赖什么算条件、什么算参与：没有这条对应纪律，加入一个人人在水平 0 依存的条件即可免费连通，而过粗的共同条件又使 living 变空（更正，见 §7） |
| `consumption_relates` | 消耗者与失去支持的形成共同参与被汲取的条件，因而它们的事件相关（更正，见 §7） |
| `valuing_consumption_reaches` | 在 N_rel 下，一个立场若珍视某个消耗者的活动，就必须珍视失去支持的形成的每个活的事件。传递沿共同参与进行，不用到消耗本身（更正，见 §7） |
| `Separate.not_connected` | 两个形成各自只参与自己的条件：两者都活着，也都不消耗，但没有关系把它们连起来 |

**分类。** [实例分类表](../history/root-foundation/BECOMING-INSTANCE-CLASSIFICATION.md)中原本留给 P3b 的 `ContinuationRenewal` 与 `OpenFutureRevision`，现在归入“运行上的更新界”。

## 3. 与计划的对照

| 计划 P3b 的要求 | 结果 |
|---|---|
| 由 Run 可观测量构造 `RelationalRenewal` 的展开 | `Conditions.along` |
| `RenewalComparison` 的关系读法成为脊柱上 `living` 的读法 | `Conditions.valuation`、`living_iff_relational`，这是可用的读法。说它是生生的正确读法，仍是对应，不是 Lean 结果 |
| `Depletion`、`ContinuationRenewal` 的储备界作为同一分类的实例 | 两者的自然数形式都是 `falls_finitely` 的情形，`RelationalRenewal` 的汲取界也是。`ContinuationRenewal` 的良基形式更一般，不由此导出 |
| `related` 有动力学来源，连通可检查（`metaethical-core-characterization` 的下一步） | `related` 取为共同参与某一条件；有共同条件时连通成立，没有时可以不成立 |

## 4. 作者反审

**反驳 1：统一只是重新包装。** “可观测量不能无穷下降”是标准事实；把三条界写成它的情形，只是组织工作，不是新数学。

*回应。* 同意。数学上的新内容在第 2 节的后半：分类属于运行，消耗者与失去支持者共同参与同一条件，连通可由共同条件给出。统一的价值是让三条界落在同一个对象（运行）上，此后陈述不必再各建一个序列模型。

**反驳 2：`related` 太粗。** 任何两个从同一生物圈汲取的形成都“相关”，于是连通几乎自动成立，伦理内容全落到 N_rel 上。

*回应。* 粗细是读法的选择。这里如实公开，并没有证明它。

- `valuing_consumption_reaches` 用到的关系，只是“一方汲取、另一方依存于同一条件”，比共同参与更窄，在更细的读法下同样成立。
- 共同条件确实让连通变得容易，但这正是要公开的位置：拒绝 G0 的一方，现在必须拒绝 N_rel 或 N_std，即在边界内适用传递或共享，而不能声称两者无关。
- 生物圈、气候之类的条件是否真被所有活的形成共同参与，是经验对应，不在本结果之内。
- （审查后补充，§7）上面第二点不完整：争议同样落在“什么算条件、什么算参与”上。拒绝 G0 的一方可以接受 N_rel，同时否认对一个惰性或过粗条件的共同参与是 N_rel 所说的已形成关系。而且粗的共同条件正是其上依存会失败的条件，它使连通容易，也使 living 变空。

**反驳 3：消耗者自己的事件不算活的，这似乎预先判了它。** 关系读法把消耗者的事件排除在 living 之外，`valuing_consumption_reaches` 的前提（某立场珍视消耗者的活动）因而只能来自 S0 以外。

*回应（审查后更正，§7）。* 排除消耗者的事件是读法的阐释性规定，写在 `living` 的定义里，不是结论。要分开两件事：
- 有 Ren 原话支持的：用关系结构把更新与消耗分开，且生成与退化“不overlap”（[原话](../../../../sources/15-codex-theory-conversations/2026-10-09-renewing-consuming-without-axioms.md)）。
- AI 的阐释选择：以整个形成、整段运行为分类单位；消耗型形成的每个事件都不算 living；把“持续”读成在无穷运行中从不使依存者永久失去支持。

在这一规定下，S0 只要求珍视自己活的、进一步生成的内容；一个在关系读法下消耗的形成，其活动不在其中。如果某个立场仍珍视这一活动（例如赢者珍视赢），N_rel 就把意义传到失去支持者。这一读法与 C 连用时给出排序判决（[relational-reading-comparison](../../../../theories/becoming/results/records/relational-reading-comparison.md)），不只是沉默。

- 读法是整段运行上的分类，不是逐步的，继承自 `RenewalComparison`：消耗者在超出更新之前的事件，也不计为生成根据。
- 更细的逐步读法尚未确定。

**反驳 4：`class_belongs_to_the_run` 的模型太弱。** 公地过程没有反馈：更新不依赖条件水平。赢者运行里的损失之所以持续，只是因为汲取一直超出更新；若汲取停止，条件会恢复。

*回应。* 属实。该定理的用途只是说明，分类不是配置或焦点形成自身轨迹的函数。不可逆的损失需要更新依赖于被更新条件的反馈，这由 `RelationalRenewal` 的定律族给出，即 `no_return_below_support`，本结果不重复它。

**反驳 5：依存与汲取是静态的。** `requires`、`need`、`draws` 不随配置变化，而真实的依存会形成、转化和消失。

*回应。* 属实，这是从 `RelationalRenewal` 继承的限制。要放宽，需要让 `requires` 读取配置，并重做 `Renewed` 与 `Consumed` 的定义。这是下一步的形式工作，也正是 Theory of Becoming 要求解释“维持、转化、退化与消失”的地方。

**未解决。**
1. 关系读法是生生的正确读法，这是哲学论证，不是 Lean 结果。
2. 依存的动态化。（P6 完成，见 §6。）
3. 逐步读法。（P6 完成，见 §6。）
4. 共同条件的经验对应。
5. 独立反审：已由另一 agent 进行，见 [审查](../history/root-foundation/BECOMING-RENEWAL-READING-REVIEW.md) 与 §7。

## 5. 边界

- 不证明 S0、N、A、C、L 或 J，不约束拒绝它们的立场，不推出义务、排序、认识或遵循。
- 可观测量与实际历史的对应，是每次应用的义务。

## 6. 动态依存与逐步读法（P6）

2026-10-09。Ren 在改名完成后指示：“and after it is elegantly completed, move on to pursue the theory of becoming, and prove the necessary proofs”（[原话](../../../../sources/15-codex-theory-conversations/2026-10-09-pure-core.md#rens-follow-up-finish-the-renames-then-continue-the-theory)）。本节完成第 4 节“未解决”的第 2、3 项，也就是[正典章节](../../../../theories/becoming/history/THE-THEORY-OF-BECOMING.md#8-开放纲领--open-programme) §8 的“动态依存”与“逐步读法”两行。成果记录：[becoming-dependence-dynamics](../../../../theories/becoming/results/records/becoming-dependence-dynamics.md)、[becoming-stepwise-reading](../../../../theories/becoming/results/records/becoming-stepwise-reading.md)。

```text
Result(s): 复用 becoming-renewal-reading、relational-renewal-classification、metaethical-core-characterization；
           新增 becoming-dependence-dynamics（L3）、becoming-stepwise-reading（L3 与 L4）
Delta: 依存、所需水平与汲取成为配置的可观测量；跨步读出维持、断裂、形成、消解与丧失；
       损失之后的终止、转化与恢复由定理互相约束，并在同一过程中都实际发生；逐步读法及其评价
Supplied premises / correspondence: 可观测量与实际历史的对应；living 取哪一种读法仍是公开的对应选择；
       G0 的前提（种子、N_rel、N_std）不由此证明
Evidence: Becoming.Dependence 29 项定理；Becoming.Metaethics 新增 6 项定理；合并检查器回执
       20261008T233313.422223Z，核心公理报告全空，仅用前导编译；外围桥接 20261008T233335.261411Z 通过
Boundary: 不建立整体演绎；不涉及差别制造归属、周期更新；独立反审未做
Integration: becoming-renewal-reading 的 next_delta 的前两项由新记录承接；
       relational-renewal-classification 的 Unfolding 由 static 精确复原
```

独立审查之后，本节的若干说法已更正；更正处标明，理由与全部更正见 §7。

### 6.1 依存属于展开

[Becoming.Dependence](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Dependence.lean)（L3）：只讲动力学，不含伦理谓词。

| 声明 | 内容 |
|---|---|
| `Dependence`、`Web`、`Dependence.along` | 条件水平、活跃、依存（及所需水平）与汲取都随配置变化。运行经这些可观测量读出为一个 `Web` |
| `Kept`、`Broken`、`Forms`、`Dissolves`、`Lost` | 跨一步读出。依存在该步起点和终点都被满足，为维持；起点满足而终点不满足，为断裂；依存出现，为形成；依存消失，为消解；断裂后再也不被满足，为丧失 |
| `static_supported` 等六条、`conditions_along` | 依存不变时，恰好复原 `RelationalRenewal` 的静态读法：支持、更新、消耗与形成的分类都一致 |
| `ceases_at_a_step`、`arises_at_a_step`、`dissolves_between`、`forms_between` | 变化发生在步上：某步成立、后来不成立的依存，在其间某一步消解；反过来，在其间某一步形成。陈述不用排中律：没有一段运行能避开这样的一步 |
| `kept_or_broken`、`kept_not_broken` | 每个被满足的依存，跨每一步恰为维持或断裂之一 |
| `renewed_not_consumed`、`renewing_not_consuming`、`renewing_keeps_support`、`lost_consumed` | 更新与消耗仍然互斥；更新使更新型形成每一步都有支持；丧失是消耗的一种 |

**一步之内的先后。** 一步之内依存改变与条件下降谁先谁后，单看一步无法区分。读法把下降算在该步起点的依存上，模块说明写明了这一点；更细的时间粒度要求细化运行，属于应用义务。

### 6.2 损失之后的三种结局

以下三条一般定理都以 `Dependent` 为前提：形成只在它当时所依存的条件支持它时活跃。这排除了缓冲、储备与滞后；前两条的内容就是这一前提的逆否（更正，见 §7）。

| 声明 | 内容 |
|---|---|
| `continuing_restores` | 在 `Dependent` 下，以不弱于先前的依存活跃，就意味着水平满足先前的所需 |
| `consumed_continues_transformed` | 在 `Dependent` 下，无回程的损失之后仍然活跃的形成，必已减弱或消解其依存 |
| `consumed_ends_when_fixed` | 在 `Dependent` 下，依存不变时，无回程的损失之后该形成不再活跃 |
| `Crossing.loss_does_not_decide` | 同一过程、同一配置，三次运行都在第一步断裂同一个依存（按步首约定读）。第一次：形成终止，损失无回程。第二次：旧依存消解，对另一条件的依存形成，形成始终活跃，损失无回程。第三次：形成蛰伏，条件得到更新，同一依存此后一直被维持。断裂的读法不决定后继配置；在这一见证中，去路由构成断裂的那一步动作 `fall m` 选定。按步末约定，只有恢复运行有断裂，终止运行中的依存也消解 |

**解读（审查后收窄，§7）。** 三种结局既不穷尽，也不互斥：恢复是关于条件的事实，终止与转化是关于形成的事实；同一断裂之后，一个形成可以转化、另一个终止，而条件随后恢复。一段历史是“转化”还是“终止加新形成”，由 `F` 规定的形成同一性决定。准确的说法是：在一个形成被给定、各字段除 `Dependent` 外彼此独立的表示中，几种变化方式可以由共同的可观测量定义，并由定理相互约束；终止与转化之分依赖所规定的形成同一性，形成本身的个体化没有被表示。

这与[正典章节 §1](../../../../theories/becoming/history/THE-THEORY-OF-BECOMING.md#1-生成同一展开--becoming-one-unfolding)“形成、维持、转化、退化与消解都是沿运行的关系变化，不是五个阶段”相容，但它是表示内的定义与约束，不是这一主张的证明。它也不完成[根基 §9](../../../../theories/becoming/history/BECOMING-FOUNDATION.md#9-the-content-of-the-whole-deduction)的整体演绎：共同纳入一个记录类型，加一条约束，正是那里说的不能代替根据的东西（[整体演绎的审查](../history/root-foundation/GROUNDING-INFERENCE-AND-PRESENTATION.md#19-the-whole-deduction-and-the-passage-from-inclusion-to-relation)）。

### 6.3 逐步读法

L3，同一模块：

| 声明 | 内容 |
|---|---|
| `RenewingAt`、`renewing_at_active`、`not_renewing_at_of_broken` | 一个事件（形成，步）在更新之内，当它活跃，且该步维持它所参与的每个条件上的每个依存。整段运行的更新使每个活跃步都在更新之内；某步若断裂了它所参与条件上的依存，该事件就不在更新之内 |
| `Commons.stepwise_credits_before_escalation` | 先在更新之内汲取，后来超出：整段读法记为消耗；逐步读法记入第一步，不记第二步 |
| `Commons.dip_breaks_without_consuming` | 先超出一次，再停下等条件更新：整段读法不记为消耗；逐步读法不记入断裂的那一步 |
| `Dip.renewing_at_each_step_not_in_run` | 维持者在它自己的每个活跃步都在更新之内，整段却不更新：它不活跃时，另一个形成断裂了共同条件。整段更新不是自身各步的合取。维持者不汲取任何条件，两种 living 读法都记入它的活跃事件，所以这不是 living 读法的分歧（更正，见 §7） |

| 声明 | 内容 |
|---|---|
| `Web.valuation` | 逐步读法：两个事件的形成在各自的步上共同参与某一条件，即为 related。P6 原取“事件在更新之内”为 living；审查后改为“活跃且不侵蚀”，见 §7 |
| `Web.connected_of_common`、`Web.significant_iff_of_common` | 每个活的事件都参与的条件使整体连通，于是 G0 恰等于种子加 N_rel 加 N_std，与整段读法相同 |
| `Web.breaking_relates`、`Web.valuing_breaking_reaches` | 在断裂之步汲取的事件不是活的，并且与被断裂形成参与该条件的每个事件相关；断裂可以由别的形成参与造成。在 N_rel 下，珍视这一事件的立场，必珍视那些活的事件（措辞更正，见 §7） |
| `Conditions.stepwise_related`、`Commons.readings_differ` | 依存不变时，两种读法的 `related` 相同，只在 `living` 上不同；两个方向都有分歧 |

### 6.4 作者反审

**反驳 1：三种结局只是定义上的分情况。**

*回应。* 部分同意。`kept_or_broken` 与 `continuing_restores` 证明很短。内容在别处：
- 这些关系在依存可变的模型中成立，而静态模型表达不了转化；
- `loss_does_not_decide` 是存在性结果：三种结局在同一过程、同一配置下都可实现，所以断裂的读法不决定后继配置。（审查后更正，§7：原文说“去路由后续关系决定”，不对；在 `Crossing` 中，去路由构成断裂的那一步动作选定。）

**反驳 2：逐步读法偷偷带进了因果归属。** 维持者的事件被记入更新，即使维持条件的是别人。

*回应。* 逐步读法读的是事件所处的关系，不是它的因果贡献。整段读法也是如此：它追踪的是一个形成与某个条件最终命运的共同参与（审查 Q11）。差别制造的归属在 §8.3 处理。

**反驳 3：两种读法冲突，哪一个是生生？**

*回应。* 两者回答不同的问题。整段读法问：形成在整段运行中是否消耗。逐步读法问：一个事件所在的那一步是否维持其条件上的依存；审查后的 living 问：事件是否在这样一步汲取：之后条件既低于某个依存现在的所需，也低于它曾被满足的某个所需（§7，定义经 P11b 修正，§15）。`Commons.readings_differ` 证明两个方向都有分歧，所以不能把一个当作另一个的细化。但这样两者都不能单独是“生生的读法”（审查 2.7）；比较与判据见 §8.5。

**反驳 4：转化把所需水平降低也算进去，太宽。**

*回应。* 是的，依存减弱也算转化。应用若要区分减弱与替代，可以用 `Dissolves`／`Forms` 细分；`Crossing` 的转化运行是替代。

**反驳 5：逐步读法太严。** 条件因季节等原因自然下降时，下降那一步上的任何事件都不被记入。

*回应。* 属实，这是读法的严格性。审查后的读法只扣下在那一步汲取该条件的事件，不汲取的形成不受影响（§7）；但在依存恢复之前，任何汲取都被扣下。周期层面的读法见 §8.1。

**反驳 6：`Crossing` 是为结论构造的玩具。**

*回应。* 它的作用是可能性见证：在可以表达依存变化的最小过程里，同一步的断裂之后三种结局都可实现。它不说明实际系统中哪种结局常见；那是经验问题。

### 6.5 边界

- 不证明任何读法是生生的正确读法，也不证明 S0、N、A、C、L 或 J。
- 依存可观测量与实际历史的对应，是每次应用的义务。
- 差别制造归属、周期层面的更新与条件替代，见 §8。
- 整体演绎仍开放（见 6.2 的解读）。
- 独立反审：见 §7。

## 7. 独立审查与更正

2026-10-09。另一 agent（Claude Opus 5.5，未参与撰写）对 §§1–6、`Becoming.Dependence`、`Becoming.Metaethics` 的读法部分、正典章节与六条记录作了独立审查：[BECOMING-RENEWAL-READING-REVIEW](../history/root-foundation/BECOMING-RENEWAL-READING-REVIEW.md)。它重新编译了核心，核对了 22 个源文件的哈希，并写了 13 组探针（Q1–Q13，全部无公理）。

| 问题 | 审查结论 |
|---|---|
| A. 关系读法的哲学根据 | 未确立，研究的表述过强 |
| B. `Becoming.Dependence` | 数学接受；三处散文须撤回；“形式实例”须收窄 |
| C. 形式复核 | 接受 |
| D. 对应与超出 | 20 项更正 |

### 7.1 形式上的更正

全部在核心上，公理报告为空（回执见 §8 的记录）。

| 更正 | 声明 | 理由 |
|---|---|---|
| 逐步读法的 living 改为“活跃且不侵蚀” | `Web.UnderminingOn`、`Web.UnderminingAt`、`Web.valuation` | 事件侵蚀：它在某步汲取某条件，该步之后，条件既低于一个依存现在的所需，也低于该依存在不间断成立期间曾被满足的某个所需（定义经 P7b、P9b、P11b 修正，§11、§12、§15）。只看事件所汲取的条件，这是“不消耗”的逐步对应，两种读法因而同型。见下面三个候选的比较 |
| 断裂与侵蚀 | `Web.BreakingOn`、`Web.BreakingAt`、`BreakingOn.undermining` | 断裂：在某步汲取，该步断裂一个依存（起点满足、终点不满足）。断裂是侵蚀的一种 |
| `RenewingAt` 保留为逐步的更新分类 | `RenewingAt.not_undermining`、`RenewingAt.not_breaking`、`Commons.broken_formation` | 它是 `RenewingIn` 的逐步对应。在更新之内的事件既不侵蚀也不断裂；被断裂者在断裂之步不在更新之内，但也不侵蚀。Q1 作为 `RenewingAt` 的性质保留 |
| 损失之后的汲取 | `Commons.pausing`、`Commons.drawing_after_loss` | 损失之后继续汲取不再断裂任何依存，却使条件回不来：同样的第一步之后若不再取（动作为 0），条件回到。这样的事件侵蚀而不断裂。“回不来”只在公地见证中成立，那里更新在支持之下照常、失去者可以恢复；侵蚀读的是共同参与一个未恢复的短缺，不是对不回程的贡献（`Pinned.undermining_without_effect`，§11） |
| 两个方向的分歧保持，且两种读法都记入被断裂者 | `Commons.readings_differ`（扩展） | 加码运行第 0 步：逐步记入、整段不记入；短暂下降第 0 步：整段记入、逐步不记入；加码运行中维持者在断裂之步的事件：两种读法都记入 |
| 继承的“消耗”不要求依存曾被满足 | `Unmet.consumed_without_loss`；`Web.Consumed` 的说明 | Q2：一个从未被满足的依存使条件被消耗、汲取者成为消耗型，而没有任何断裂或丧失；汲取者在任何一步都不侵蚀。`RelationalRenewal` 是基础模块，其字节不改，在 [relational-renewal-classification](../../../../theories/becoming/results/records/relational-renewal-classification.md) 中披露。整段 living 读法仍用继承的 `ConsumingIn`，所以 Q2 对整段读法仍成立 |
| 关系层读法 | `Web.relations`、`Web.living_iff_relations`、`Mixed.one_event_two_relations` | 审查 2.2 指出的最直接的对手。主张取为一个形成在某步对某条件的关系；事件的逐步读法恰是它所参与关系的读法的合取；同一事件可以有一个活的关系和一个侵蚀的关系 |
| 模块说明与声明说明 | `Becoming.Dependence`、`Becoming.Metaethics` | 见 7.2 的第 2、4、6、10–16、18 项 |

**三个逐步候选。** 逐步 living 先后有三个候选，每一个都保留在核心中：前两个连同使它不被采用的见证，第三个连同它的代价：

| 候选 | 问的是 | 不采用的理由或代价 |
|---|---|---|
| 在更新之内（P6，`RenewingAt`） | 该步维持它所参与的每个条件上的每个依存 | 被断裂者在断裂之步不被记入（审查 Q1，`Commons.broken_formation`）；从未被满足的依存使所有参与者都不 living（审查 Q2） |
| 不断裂（审查 Q12） | 它不在断裂某个依存的那一步汲取 | 损失之后的汲取不再断裂任何东西，于是被记入，虽然在公地见证中它使条件回不来（`Commons.drawing_after_loss`）。这与 Ren 采纳的问题（以消耗取胜不是生生）不合 |
| 不侵蚀（工作候选，待 Ren 选择） | 它不在这样一步汲取：之后条件既低于一个依存现在的所需，也低于该依存在不间断成立期间曾被满足的某个所需 | 保留两个方向的分歧；记入被断裂者；在依存成立期间从未以其所需被满足的依存不使汲取者侵蚀，只低于增长到从未被满足的所需也不算侵蚀，而所需增长之后低于曾被满足的所需的汲取侵蚀（定义经 P7b、P9b、P11b 修正，`NewNeed.never_met_not_undermining`、`FallingNeed.never_met_not_undermining`、`RisingNeed.grown_need_not_met`、`Stunted.stunting_undermines`）；扣下断裂之步与损失之后的汲取。代价：`draws` 不带数量，侵蚀也不涉及汲取的效果，所以在一个曾被满足而尚未恢复的依存之下，任何汲取都被扣下，哪怕恰取更新量（`Pool.within_share_undermines`），甚至不改变任何水平（`Pinned.undermining_without_effect`）；依存中断一步即开始新的一段，此前的满足不再计入（`Gap.lapse_starts_afresh`，§12），休眠或迁出是否表示为持续的依存，是应用义务 |

### 7.2 二十项更正的处理

| 项 | 内容 | 处理 |
|---|---|---|
| 1 | §4 反驳 3：排除消耗者是规定 | 已改；分开 Ren 原话支持的部分与 AI 的选择；写明与 C 连用给出排序 |
| 2 | “消耗本身是一种已形成的关系” | 改为共同参与，N_rel 沿共同参与传递：研究 §2、§4、英文摘要；章节 §4、§6.3；记录 becoming-renewal-reading；`consumption_relates`、`valuing_consumption_reaches` 与模块说明 |
| 3 | 连通“由展开给出” | 改为“在关于条件与参与的对应纪律下由共同条件给出”，并写明 Q4、Q10：章节前提卡与 §6.3；两条 `significant_iff_of_common` 的说明；记录 |
| 4 | `Becoming.Metaethics` 模块说明第 9–12 行 | 已改：`related` 与 `living` 是 Valuation 的输入；Becoming 层给出的读法更窄 |
| 5 | 前提卡 living 一行只列整段读法 | 已改：列出整段、逐步与关系层三种读法，选择开放 |
| 6 | 读法依赖运行 | 已写明：章节 §6.3–6.4、模块说明、metaethical-core-characterization 的记录；不依赖运行的构造列为下一步 |
| 7 | 读法里没有“继续生成” | 已写明：模块说明、章节前提卡与 §6.3、§8.5。生成的成分本身未加入，列为开放 |
| 8 | 对手读法的比较 | 见 §8.5：关系层、整体方向、周期层、差别制造、能力、自创生／代谢、热力学，以及有限可判定性；其中周期层、差别制造、关系层与有限可判定性有形式结果 |
| 9 | 披露 Q1、Q2，权衡 Q12 | 采用 Q12 的方向（只看所汲取的条件），再以“不侵蚀”为工作候选，理由见 7.1；Q1、Q2 与 Q12 的缺口都作为定理保留；记录的反例已加 |
| 10 | `Consumed` 的说明 | `Web.Consumed` 的说明已改；`Unmet.consumed_without_loss` 记下这一缺口；`RelationalRenewal` 在其记录中披露 |
| 11 | “三条去路” | 改为“定理联系起来的三种结局，既不穷尽也不互斥”：模块说明、记录标题与主张、章节 §1、研究 §6.2 与英文摘要 |
| 12 | 写出 `Dependent` | 已写出，并说明两条定理是其逆否 |
| 13 | “去路由后续关系决定” | 已删；改为“断裂的读法不决定后继配置，去路由构成断裂的那一步选定”：研究 §6.4、记录 |
| 14 | “同一个断裂”依赖步首约定 | 已写明：`loss_does_not_decide` 的说明、章节 §1、研究 §6.2、记录 |
| 15 | `Dip` 不是 living 的分歧 | 已移出：模块说明、记录、章节 §2、研究 §6.3。Q1 原是 living 上的真实分歧；改读法后不再是，作为 `RenewingAt` 的性质保留 |
| 16 | “断裂事件” | 改为“在断裂之步汲取的事件”，并注明断裂可由别者参与造成；改读法后，被断裂者在该步的事件在所达之列 |
| 17 | “形式实例”须收窄 | 已收窄：研究 §6.2、记录 becoming-dependence-dynamics、章节 §8 |
| 18 | 固定索引类型；`draws` 不带数量 | 已写明：研究 §1、模块说明、记录的 `correspondence` |
| 19 | `living_iff_relational` 的位置 | 已注明在 `Becoming.Bridge` |
| 20 | “已完成” | 章节 §8 与记录改为“已定义并比较，读法选择开放”，独立反审指向审查文件 |

### 7.3 仍开放

审查列出会改变其判断的四种结果：

1. **条件的对应纪律。** 一条排除惰性或虚设条件的规则，并证明在声明的类中连通仍成立。部分完成：§10 给出一条纪律并证明这一点；Q10 与人人以正水平依存、被使用一次的条件仍未解决（§12）。
2. **比较关系层读法与限于汲取的逐步读法，并论证哪一种是生生的读法。** 两者都已在核心上定义并比较（7.1）。论证见 §8.5，结论是选择须由 Ren 作出。
3. **不依赖运行的读法，并与 `universal_reason` 接通。** 开放。
4. **在 living 中加入继续生成的成分。** 开放。现有读法读出的是“不损”，即与他者依存相容的活动，不是生生的全部。

## 8. 回程、视界、共同活动与替代（P7）

2026-10-09。按同一指示继续（“prove the necessary proofs”）。本节承接三处的下一步：

- [relational-renewal-classification](../../../../theories/becoming/results/records/relational-renewal-classification.md)：周期层面的更新、条件之间的替代、共同消耗中的差别制造归属；
- [becoming-dependence-dynamics](../../../../theories/becoming/results/records/becoming-dependence-dynamics.md)：在既有形成机制中实现依存的替代，并检验分类是否保持；
- 审查 §2.6–2.7：对手读法的比较，以及读法的判据。

成果记录：[becoming-return-grades](../../../../theories/becoming/results/records/becoming-return-grades.md)、[becoming-finite-horizon](../../../../theories/becoming/results/records/becoming-finite-horizon.md)、[joint-difference-making](../../../../theories/becoming/results/records/joint-difference-making.md)、[substitution-preserves-consumption](../../../../theories/becoming/results/records/substitution-preserves-consumption.md)。

```text
Result(s): 复用 becoming-dependence-dynamics、becoming-stepwise-reading、relational-renewal-classification；
           新增 becoming-return-grades、becoming-finite-horizon、joint-difference-making、
           substitution-preserves-consumption（均为 L3）
Delta: 更新与消耗之间按回程时间分级，消耗恰是不再回程的依存；周期层面的读法；
       任何有限的一段运行都不决定其汲取是更新还是消耗；
       but-for 差别制造在多重决定下与关系参与分离，在形成之间；在一个形成的各事件之间，整段的结局由尾部决定；
       在既有的支持门控定律中，能替代条件的消耗者以转化依存的方式持续，在整段读法下仍是消耗的
Supplied premises / correspondence: 扣除一方的部分而其余不变，是建模义务；
       回程等级、视界与实际历史的对应，是经验问题
Evidence: Becoming.Return、Becoming.Horizon、Becoming.Joint、Becoming.Substitution；合并检查器回执（见记录）
Boundary: 不推出责任、义务或排序；读法的选择不由此决定
Integration: 支持门控定律的 overdraw_crosses_support、permanently_below、dependent_overdraw_ends_itself 直接复用；
       Commons 过程与 Becoming.Renewal 的 sharing、winning 直接复用
```

### 8.1 回程：按回到的时间给更新分级

[Becoming.Return](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Restoration.lean)（L3）：

| 声明 | 内容 |
|---|---|
| `ReturnsWithin`、`RenewedWithin`、`Returns` | 某步成立的依存在其后 `p` 步之内被满足，为在 `p` 步内回程；条件上每个依存都如此，为在 `p` 步周期内更新；每个依存都在某个以后的步被满足，为回程 |
| `renewed_within_one`、`RenewedWithin.mono`、`RenewedWithin.returns`、`Returns.not_consumed` | 等级有序：更新蕴含一步内更新；`p` 步内更新蕴含任何更长周期内更新，也蕴含回程；回程的条件不被消耗 |
| `consumed_iff` | 消耗恰是某个依存不再回程 |
| `seasonal_renewed_within_two` | `RelationalRenewal` 中既不更新也不消耗的季节性条件，在两步周期内更新，不在一步内更新 |
| `Slowing.slowing_recovery` | 恢复可以无界地变慢：间隔越来越长地被满足的条件，总会回程，从不被消耗，但没有任何周期长度能界定它的回程 |
| `RenewingInWithin`、`UnderminingFor` | 周期层面的两种读法：形成在 `p` 步周期内更新（它参与的每个条件都在 `p` 步内更新）；事件侵蚀 `p` 步（它在某步汲取某条件，一个在其成立期间曾被满足的依存此后 `p` 步都不被满足；定义经 P7b 修正） |
| `RenewingIn.within_one`、`undermining_for_one`、`RenewingInWithin.mono`、`UnderminingFor.anti`、`RenewingInWithin.not_consuming`、`RenewingInWithin.not_undermining_for` | 周期读法扩展逐步读法：更新蕴含一步周期内更新，侵蚀即侵蚀一步；周期越长记入越多；在任何周期内更新的形成不消耗，它的事件也不侵蚀该周期 |
| `LateMet.within_one_not_renewing` | 逆命题不成立：一个依存在其第 0 步不被满足、此后每步都被满足，形成在一步周期内更新，却不整段更新。`RenewedWithin` 不问依存在其自身之步是否被满足，`Renewed` 问（P7b） |
| `renewedWithin_zero`、`undermining_for_zero` | 周期长度 0 是退化的：零步内更新恰是无人依存；任何在曾被满足的依存之下的汲取都侵蚀零步，在更新的运行中也是。周期取 `p ≥ 1`（P7b） |
| `Commons.dip_within_two`、`Dip.renewing_within_two` | 两步周期下，短暂下降被记入：形成在两步周期内更新，事件不侵蚀两步，虽然它在断裂之步汲取；维持者在两步周期内更新，虽然它不在每步更新 |
| `Commons.escalation_undermines_for_every_cycle` | 加码之后条件不再回来：加码事件对每个周期都侵蚀（`p = 0` 是退化情形），此前的事件不侵蚀一步 |

**解读。** “更新与消耗互斥但不穷尽”留下的中间区域，现在按回程时间分级：每步都维持、在有界周期内回到、终会回到但无界、以及不再回到（消耗）。`consumed_iff` 说明这一阶梯在消耗一端是精确的：不被消耗的条件，恰是没有哪个依存永不回程的条件。顶端则是严格的：更新严格强于一步周期内更新（`LateMet`），因为周期读法不问依存在其自身之步是否被满足；这在阶梯顶端重现了审查 Q2 所见的、关于从未被满足的依存的不对称。`Slowing` 对应生态学中所谓“临界变慢”：系统接近转折点时，受扰后的恢复越来越慢（作者据先前知识，本次未新读文献）。这里只给出形式上的区分：回程无界变慢的条件仍不是被消耗的条件；它是否预示损失，是经验问题。

### 8.2 有限的历史不决定分类

[Becoming.Horizon](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Horizon.lean)（L3）：

| 声明 | 内容 |
|---|---|
| `Run.cons`、`Run.AgreeUpTo` | 在一次运行之前加一步；两次运行在 `h` 之前的配置与动作都相同 |
| `Commons.prefix_does_not_decide` | 对每个视界 `h`，同一过程的两次运行在 `h` 之前完全相同：每一步都超出更新地汲取，焦点形成的每个事件都在更新之内。此后一次在更新之内汲取，焦点形成是更新的；另一次继续超出，焦点形成是消耗的 |
| `Commons.finite_reading_credits_consumption` | 任何由前 `h` 步决定、并记入每次更新运行的读法，必记入某次消耗运行 |
| `Commons.whole_run_credits_overdraw` | 整段读法记入超出更新的汲取：对每个视界，那次更新运行在 `h` 之前每步都汲取两个单位，整段读法记入焦点形成的每个这样的事件（P7b） |
| `Commons.amount_reading` | 按数量的读法逃出视界结果：“该步所取不超过更新”由前 `t + 1` 步决定，记入共享运行的每个事件，扣下两次运行在 `h` 之前的每个事件；它只是不记入每次整段更新的运行。依存网上 `draws` 不带数量，这一读法在 `Web` 上不能表达（P7b） |
| `Commons.cycle_reading_not_finite` | 形成层面的周期读法（`RenewingInWithin p`，`p > 0`）不由任何有限前缀决定；由有限历史决定的只是事件层面的 `UnderminingFor p`（到 `t + p` 为止）（P7b） |
| `Feedback.prefix_does_not_decide` | 支持门控定律有反馈：越过支持阈值之后损失不回来。对每个视界，同一起点、`h` 之前每步都汲取两个单位：在 `h` 停止则更新，继续则消耗。停止的一次从不到达阈值，所以反馈不改变视界结果（P7b） |

**解读。** `class_belongs_to_the_run` 说分类不是初始配置的函数；这里更强：分类不是任何有限前缀的函数，有反馈时也如此（`Feedback.prefix_does_not_decide`）。事件层面的逐步与周期读法由有限的历史决定（`UnderminingAt` 要用到该步之后为止的全部过去，`UnderminingFor p` 到 `t + p` 为止），所以在条件还满足依存时，它们记入渐进的耗竭；形成层面的周期读法则不由有限前缀决定（`cycle_reading_not_finite`）。

这一结果的力量来自它的假设：读法须记入每次整段更新的运行。而那次更新运行在 `h` 之前每步都超出更新地汲取，整段读法记入这些事件（`whole_run_credits_overdraw`）。若把对 Ren 采纳的问题的判决读作关于“超出更新地汲取”这一活动，整段读法同样不满足它；若读作关于运行的最终结局，判断就需要对继续的说明。一个按数量的读法可由有限历史判定，并扣下每一次超出（`amount_reading`），它只是不记入每次整段更新的运行。所以下面 §8.5 的约束 1 相对于对判决的一种读法、以及不带数量的可观测量；它不是有限探究本身的界限。

在这些见证里，给定动作，动力学是确定的；有限前缀不决定的是此后的动作。所以“对继续的探究”部分地就是对将要做什么的审议。一个条件式读法（“继续这一步的汲取会消耗”）在这些见证中可由状态与定律判定；这一点只作论证，未形式化。这把评价与探究连在一起：L2 的所见范围由实际执行给出，而这里所需的正是对继续的探究与审议。

### 8.3 共同活动中的差别制造

[Becoming.Joint](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Joint.lean)（L3）：

| 声明 | 内容 |
|---|---|
| `Dependence.Keeps`、`Dependence.Breaks`、`along_kept`、`along_broken`、`keeps_not_breaks` | 配置之间的维持与断裂；沿运行恰是 `Becoming.Dependence` 的维持与断裂；两者互斥 |
| `BreaksBy`、`MakesDifference`、`Overdetermined`、`Overdetermined.no_difference` | but-for 检验，动作固定（P7b 修正）：由某配置以某动作的一步断裂依存，而扣除某一方的部分后以同一动作的每一步都维持它，则这一方的部分造成了差别。扣除任何单独一方的部分、以同一动作仍有断裂之步，为多重决定；此时没有哪一方单独造成差别 |
| `Shock.move_decides` | 动作属于“其余”：由同一配置，唯一汲取者的部分在平静的动作下造成差别；在外来冲击下损失被多重决定，它的部分不造成差别。所以检验须固定实际所取的动作（P7b） |
| `Pool.difference_belongs_to_the_joint` | 同一过程、同一水平、第一个汲取者取同样的量。另有一方汲取时，它的部分造成差别；另有两方汲取时，损失被多重决定，它的部分不造成差别，而扣除两方的部分则维持依存，差别由共同活动造成。两次运行中，关系读法都把它计为消耗；一个什么也不取的形成不计为消耗 |
| `Commons.overdraw_consumes` | 从某步起每步都汲取至少两个单位（每步更新一个），条件被消耗 |
| `Pool.within_share_undermines` | 逐步读法不追踪差别制造：第一个汲取者恰取更新量，第二个取两个；第二个的部分造成差别，第一个的不造成，但第一个在断裂之步的事件侵蚀（P7b） |
| `Commons.depletion_is_joint` | 一个形成的各事件之间：每步超出更新的汲取消耗条件；第一个事件那一步维持依存，对任何正长度的周期都不侵蚀；扣除任何一个事件的汲取，条件仍被消耗，在整段层面没有哪个事件单独造成差别 |
| `Commons.no_finite_segment_makes_difference`、`Commons.breaking_event_makes_step_difference` | 整段层面的结局由尾部决定：扣除任何一步之前的全部汲取，条件仍被消耗，没有哪个有限的事件集合造成整段的差别。步层面的检验挑出断裂事件：在断裂之步，由同一配置不汲取则依存被维持（P7b） |

**扣除留在展开之内。** 比较的对象是同一过程中的另一个配置或运行，即那一方或那一事件的部分不在的配置或运行。没有在过程之外另设一个比较世界。动作也属于其余的活动：检验固定实际所取的动作（`Shock`）。

**解读。** 差别制造不属于一方自身的活动，而属于它与其他部分以及所取动作的共同关系；正如分类属于运行，结局不由断裂的读法决定。多重决定的情形正是“我的一份无关紧要”这一推理的形式。在一个形成的各事件之间，须分开两种检验。整段层面：消耗由运行的尾部决定，没有哪个有限的事件集合造成差别（`no_finite_segment_makes_difference`），这与视界结果是同一事实。步层面：断裂事件造成那一次断裂的差别（`breaking_event_makes_step_difference`），逐步读法扣下它及其后的事件。所以“每一步的汲取单独都不造成差别”只对整段层面的检验成立。本仓库已有的散文论证说过“but-for 不可缺少性太强”（[整体过程实现审查](../history/root-foundation/WHOLE-PROCESS-REALIZATION-REVIEW.md#three-inadequate-tests-and-the-stronger-identification)）与“冗余路线可以在去掉一条之后保持结果”（[展开保持审查](../history/root-foundation/UNFOLDING-PRESERVATION-REVIEW.md#3-strong-rivals-and-the-distinctions-they-test)）；这里是这一点在依存网上的形式见证。关于集体伤害与过度决定的哲学讨论（如 Parfit 的“道德数学的错误”、Kagan 关于“我造成差别吗”的讨论）是重要对照，本次未新读，只作指引。

### 8.4 替代：消耗者以转化依存的方式持续

[Becoming.Substitution](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Substitution.lean)（L3）把替代放进既有的[支持门控定律](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/deeper/RelationalRenewal.lean)：共同条件由依存于它的维持者更新；汲取超出更新，更新本身随之终止，损失在定律内不会回来。

| 声明 | 内容 |
|---|---|
| `ceasing_step` | 对可判定的规定，停止成立的那一步可以找到（`ceases_at_a_step` 的可判定形式） |
| `Substitution.web`、`web_dependent` | 焦点形成在共同条件支持它时依存于它，否则依存于一个支持它的替代条件；共同条件的水平仍由原定律给出 |
| `Substitution.persists_consuming` | 从一开始就超出更新地汲取：能替代的焦点形成每步都活跃；它对共同条件的依存在一个可以找到的步上消解，对替代条件的依存同时形成；它在运行中是消耗的；维持者永久失去支持并终止 |
| `Substitution.extracting_persists_consuming` | 一个具体定律满足全部前提，上述结论不是空的 |
| `Substitution.extracting_low`、`Substitution.stepwise_credits_substitution` | 在这一具体定律中，共同条件从第 3 步起为 0；逐步读法记入焦点形成除第 2 步之外的每个事件：越过之前它的汲取使每个所需仍被满足，越过之后它在模型中不汲取任何条件（P7b） |
| `Substitution.slow`、`Substitution.slow_withheld_two_steps` | 在另一定律中，共同条件跌破维持者的支持之后仍支持焦点形成一步，它在第 2、3 步都被扣下（P9b，§12） |

**解读。** 在整段读法下，替代保持分类：一个以转化依存的方式熬过它参与造成的损失的形成，仍然是消耗的；它自身的持续不证明更新。这一保持几乎由定义给出：`ConsumingIn` 只要求曾在某步汲取一个被消耗的条件，此后做什么都不能改变它。在逐步读法下分类不保持：焦点形成在维持者失去支持之前被记入，此后到它转向替代条件为止被扣下，在这一具体定律中只有第 2 步（`stepwise_credits_substitution`），在 `slow` 中是第 2、3 步（§12）。“替代不证明更新”仍然成立，因为逐步的 living 不是更新。连同既有结果，这一定律族在无回程的损失之后实现了终止（`dependent_overdraw_ends_itself`）与转化（本结果）；恢复要求更新者重新得到支持，在这一定律内不发生，由[有支持的修复路线](../../../../theories/becoming/results/records/supported-renewal-recovery.md)在另一定律中给出。这也是“赢的元吸引子”的一个结构：靠消耗取胜的一方可以转向别处而持续，失去者不随之恢复；在逐步读法下，这样的胜者在失去者失去支持之前被记入，此后到它转向别处为止被扣下。

### 8.5 读法的比较

审查 §2.7 建议了五条判据。以下逐一对照本研究中已定义的读法。“是”“否”只在所述的范围内成立，括号内是依据。

| 判据 | 整段（不消耗） | 逐步（不侵蚀） | 周期 `p`（不侵蚀 `p` 步） | 关系层 | but-for 差别制造 |
|---|---|---|---|---|---|
| (a) 符合 Ren 采纳的问题（恶性增殖、以消耗取胜不是生生）与 Ren 所述的生成与退化不重叠；越过阈值之前的事件怎样判，是 AI 的延伸 | 部分：扣下消耗者的全部事件（relational-reading-comparison），但也记入一次更新运行中超出更新的汲取（`whole_run_credits_overdraw`）。判决若指最终结局，是；若指超出更新的汲取，否 | 部分：扣下断裂之步与损失之后的汲取（`broken_formation`、`drawing_after_loss`）；渐进耗竭在越过阈值之前被记入（`prefix_does_not_decide`）；替代的消耗者在维持者失去支持之前被记入，此后到转向为止被扣下（`stepwise_credits_substitution`、`slow_withheld_two_steps`） | 同逐步（`depletion_is_joint`） | 同逐步 | 否：多重决定下没有哪一方单独造成差别（`Pool`）；整段层面没有哪个有限的事件集合造成差别（`no_finite_segment_makes_difference`） |
| (b) 不因一个条件的命运判定未改变它的被断裂者或旁观者 | 否：较晚的断裂者使较早、在更新之内的汲取者不 living（审查 Q11） | 部分：被断裂者被记入（`readings_differ`、`broken_formation`）；但恰取更新量的汲取者在别者造成的断裂之步被扣下（`Pool.within_share_undermines`），不改变任何水平的汲取者在先前的损失之后被扣下（`Pinned.undermining_without_effect`） | 部分，同逐步 | 部分，同逐步；同一事件的不同关系分开（`Mixed`） | 是 |
| (c) 可由有限探究判定 | 否（`finite_reading_credits_consumption`） | 事件层面是：由到该步之后为止的历史决定 | 事件层面是：由到其后 `p` 步为止的历史决定；形成层面否（`cycle_reading_not_finite`） | 是 | 需要反事实模型，且须固定动作（`Shock`） |
| (d) 含有继续生成的成分 | 否 | 否 | 否 | 否 | 否 |
| (e) 加入惰性条件时判决不变 | 是（审查 Q4） | 是：所需为 0 的依存不会不被满足；加入从不被侵蚀的条件，living 不变（`adjoin_living`） | 是，同上 | 对已有主张是；但所需为 0 的条件为每个活跃形成新增活的关系主张，并经“同一条件或同一事件”免费连通整体（审查 Q4 在关系层重现） | 是 |

（a）（b）（c）（e）各行经 P7b 更正，见 §11。

**形式上的约束。** 两条结果限定了可能的选择，各有其范围（第二次独立审查 F2、F7）。

1. `finite_reading_credits_consumption`：任何由有限前缀决定、并记入整段读法判为更新的每次运行的读法，必记入它判为消耗的某次运行。有反馈的支持门控定律中同样如此（`Feedback.prefix_does_not_decide`）。它是否构成 (a) 与 (c) 的冲突，取决于两点：对 Ren 所采纳的问题的判决是否要求越过阈值之前的事件按整段分类来判（这是诠释，§11 F11）；以及可观测量是否带数量。按数量的读法可由有限历史判定，并扣下每一次超出更新的汲取（`amount_reading`），它只是不记入每次整段更新的运行。
2. `Overdetermined.no_difference` 与 `no_finite_segment_makes_difference`：用单一部分的、整段层面的 but-for 检验代替参与，不能满足 (a)。多重决定时，每一方都可以说“我的一份无关紧要”；在一个形成的渐进耗竭中，整段的结局由尾部决定。步层面的检验挑出断裂事件（`breaking_event_makes_step_difference`）；NESS 一类检验（§8.6）是另外的对手。

所以，若“这段汲取是消耗”是关于整段结局的判断，有限的过去不能决定它。按数量的或条件式的读法能否给出对 Ren 所采纳的问题的判决，需要一个带数量与更新率的网，仍开放。

**对审查所列其余对手的处理。**

- **数量读法与条件式读法**（第二次独立审查）。“该步所取不超过该步的更新”由有限历史决定，扣下每一次超出（`amount_reading`）；它需要带数量与更新率的可观测量，在 `Web` 上不能表达。“继续这一步的汲取会消耗”在已知定律下可由状态判定，需要对过程定律的知识；未形式化。
- **整体方向读法。** Ren 的原话是“一种整体的……方向”。上面的约束说明，判断方向需要对运行之继续的说明。这一读法因此与比较原则 C 和实践判断的位置相合：它们比较的正是整段继续，而不是孤立的事件。但现有的 `living` 是事件或关系上的谓词，没有表示“更多”与多样性，这是 (d) 的缺口。
- **能力读法**（Sen、Nussbaum，先前知识）。它把 living 读作已实现并保持开放的功能能力，直接回应 (d)。仓库中已有[当前能力与最终可达](../../../../theories/becoming/results/records/effective-capacity-and-eventual-reachability.md)的区分，可作接口；本次没有把它接入 `living`。
- **自创生或代谢读法**（Maturana 与 Varela、Jonas、Thompson、Moreno 与 Mossio，先前知识）。活的组织靠汲取并转化条件来维持自身，汲取下降本身是生命的构成部分。这里的读法不把汲取本身判为不活：只有在之后条件低于某个依存曾被满足的所需、也低于其现在所需的那一步汲取（逐步，定义见 §15），或汲取一个被消耗的条件（整段），才不记入。在更大关系的更新之内的代谢，在周期读法下被记入（`dip_within_two`）。但逐步读法有一个与代谢读法相冲突的代价：`draws` 不带数量，一个曾被满足而尚未恢复的依存之下，哪怕取得很少、甚至不改变任何水平的汲取也被扣下（7.1，`Pinned`）。
- **热力学读法**（Schrödinger、Nicolis 与 Prigogine，先前知识）。若每个形成都汲取这样的条件，而每个这样的条件最终都永久低于某个依存者的需要，整段读法在整个历史中都没有 living 事件。逐步读法保留损失之前各步；但一旦某个曾被满足的依存在其仍成立时永久不被满足，逐步读法扣下此后在该条件上的每个汲取事件。所以在一个逐渐耗尽的世界里，两种读法在损失之后都不记入任何汲取者，整段读法连损失之前也不记入。这是对无穷运行上“不息”的直接压力，也是 (c) 的另一面：整段读法的判决取决于无穷的未来。

**作者的候选分工（AI 论证，未经 Ren 确认）。** 一种分工能同时尊重这些约束：

- G0 所记入的“已实现的活”，取关系层或逐步的读法，即与他者依存相容、可由有限探究判定、不判定被断裂者的读法；
- “这一共同活动是更新还是消耗”的判断，属于对整段继续的比较，即 C 与实践判断的位置，并要求对继续的探究（§8.2）。

这一分工的代价必须写明。在逐步的 living 下，[relational-reading-comparison](../../../../theories/becoming/results/records/relational-reading-comparison.md) 中“去掉消耗者的继续是生成性扩展”的排序不再由 C 单独得出：消耗者在越过阈值之前的事件被记入，于是两次继续各有对方没有的活的内容，成为 C 不决定的混合情形，要靠更强的比较或 J 承诺。整段读法得到这一排序，代价是 (b) 与 (c)。这一段原是未形式化的论证；§9 已在核心上证明它，并发现共享对以消耗取胜的排序在逐步读法下仍然保持。第二次独立审查写明这一代价的条件：消耗者须在损失之前有被记入的事件（§9 的 `credited` 假设）；它并预期失去的只是与不在场的比较，不是与节制的比较；§9 在二元定律族中、对每步都满足所需的节制证明了这一点（`malignant_restraint`），有第三个形成共用条件时，与节制的比较也可以失去（`ThirdParty`，§12）。

哪一种读法，或哪一种组合，是生生的读法，是规范与诠释上的选择。它属于 Ren 的方向，本研究不替 Ren 作出。上表与两条形式约束是作出这一选择所需的材料。

### 8.6 作者反审

**反驳 1：but-for 检验太粗，现有理论早有更好的因果归属（NESS、结构方程中的实际因果）。**

*回应。* 同意，这里不提出因果理论。结果只表明，在多重决定下，单独的 but-for 差别制造与关系参与分离，并且前者取决于其他各方的部分。更精细的归属（例如 NESS 检验会把每个汲取者都算作某个充分集合的必要成员）可以作为另一种读法加入，届时需要它自己的定义和定理。

**反驳 2：扣除“其余不变”是虚构的。**

*回应。* 在 `Pool` 与 `withheld` 里，扣除只改动一方或一步的汲取量，过程本身给出由此到达的配置。一个应用中扣除是否让其余不变，是建模义务；模块说明写明了这一点。

**反驳 3：`prefix_does_not_decide` 用的是一个没有反馈的玩具过程。**

*回应。* 视界结果是一个存在性结果：只需一个过程就说明，有限前缀在一般意义上不决定分类。在有反馈的过程中，越过阈值之后的损失不会回来（`no_return_below_support`），但阈值之前的前缀仍可以与一次及时停止的运行相同。原回应说这在支持门控定律中是否也成立没有证明；P7b 已证明（`Feedback.prefix_does_not_decide`）：同一起点、`h` 之前每步汲取两个单位，停止的一次从不到达阈值，继续的一次消耗。反馈不是问题所在。

**反驳 4：替代例的依存是“按支持定义的”，不会被断裂。**

*回应。* 焦点形成对共同条件的依存在条件跌破所需的那一步仍按步起点计为断裂，同时消解，对替代条件的依存形成。按支持选择依存，是把“能替代”写进模型：它是建模选择，不是结论。结论是在这一选择下分类仍然保持。

**反驳 5：回程等级只是重新命名。**

*回应。* 定义很直接。内容在三处：`consumed_iff` 给出消耗端的精确刻画；季节性例子得到精确的等级；回程与有界回程之间有严格差别（`Slowing`），说明不被消耗并不意味着恢复的时间有界。

### 8.7 边界

- 不推出责任、义务或排序；关系读法与 but-for 读法都不是因果理论。
- 回程等级、视界与实际历史的对应，恢复变慢的经验意义，是应用与经验义务。
- `Pool`、`Slowing`、`depleting`、视界见证与 P7b 的见证（`NewNeed`、`Pinned`、`LateMet`、`Shock`、`Feedback`）都是最小见证。替代例中替代条件的水平不变，汲取替代条件的代价没有建模。
- 读法的选择、继续生成的成分、不依赖运行的读法与条件的对应纪律仍开放（§7.3）。
- 本节经第二次独立审查（[审查](../history/root-foundation/BECOMING-P7-REVIEW.md)）：数学接受，侵蚀与 but-for 的定义已修正，十五项更正见 §11。

## 9. C 在各读法下的排序（P8）

2026-10-09。按同一指示继续。§8.5 的分工有一个只作了论证的代价：在逐步读法下，C 看来不再把过度汲取者的不在场排在其在场之上。本节在核心上证明它，并检验另一个排序（共享对以消耗取胜）是否保持。成果记录：[ranking-under-readings](../../../../theories/becoming/results/records/ranking-under-readings.md)。

```text
Result(s): 复用 relational-reading-comparison（整段读法的两个排序）、becoming-stepwise-reading（逐步读法）、
           relational-renewal-classification（支持门控定律）；新增 ranking-under-readings（L4）
Delta: 在核心上重述并比较两种读法下 C 的排序；不在场者扩展在场者，仅当读法扣下该形成的每个事件；
       逐步读法下对不在场的排序失去，对共享的排序保持
Supplied premises / correspondence: C 是公开的比较前提；“不在场”的继续与 relational-reading-comparison 相同
Evidence: Becoming.Ranking 15 项定理（P8 时；P7b 后 19 项，P9b 后 27 项）；Becoming.Bridge 的两条对应定理；合并检查器回执（见记录）
Boundary: 不推出责任或义务；不选择读法
Integration: §8.5 的代价由论证变为定理；relational-reading-comparison 的下一步部分承接
```

[Becoming.Ranking](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Ranking.lean)（L4）把两次继续（course）作为一个框架的配置，读法所记入的事件作为其实现的主张；C 就是这一框架上的 `Comparison`。

| 声明 | 内容 |
|---|---|
| `wholeRun`、`stepwise`、`stepwise_iff` | 两种读法：活跃且在该继续中不消耗；活跃且不侵蚀。后者恰是 `Web.valuation` 的 living |
| `withheld_of_extends` | 对任何只记入活跃事件的读法：不在场的继续扩展在场的继续，仅当读法扣下该形成的每个事件 |
| `whole_run_extends`、`whole_run_ranks` | 整段读法下，对支持门控定律族中每个超出更新地汲取的焦点形成，不在场扩展在场，每个满足 C 的比较都把不在场排得更高（核心上重述 relational-reading-comparison） |
| `credited_before_loss` | 焦点形成在某步活跃，而该步之后每个所需仍被满足，则逐步读法记入这一事件 |
| `stepwise_unranked`、`admits_occurrence`、`readings_rank_differently` | 逐步读法下，只要焦点形成有一个被记入的事件，两次继续互不扩展；于是有一个满足 C、非自反、传递的比较偏好在场的继续 |
| `malignant_ranking`、`winning_ranking` | 恶性增殖与以消耗取胜都是实例：整段读法下每个满足 C 的比较都偏好不在场；逐步读法下 C 不决定 |
| `sharing_credited`、`stepwise_contest` | 逐步读法下，胜者在损失之前的事件（第 0、1 步）被记入，第 2 步不被记入；共享的继续记入每个事件，所以它仍扩展以消耗取胜的继续 |
| `Restraint`、`stops_credited`、`restraint_ranks` | 节制：每个所需始终被满足的继续，两种读法都记入其每个事件；它扩展同一族中过度汲取使维持者失去支持的继续，所以两种读法下每个满足 C 的比较都把节制排得更高，即使过度汲取者在损失之前的事件被记入（P7b；只在二元定律族中，§12） |
| `malignant_restraint` | 恶性增殖与同一形成在第一步之后、越过阈值之前停止相比：第一步相同，两次继续中逐步读法都记入它；两种读法下 C 都把停止排在恶性增殖之上（P7b） |
| `Immediate`、`ThirdParty` | 没有被记入的焦点事件时，逐步读法同样把不在场排得更高；有第三个形成共用条件时，逐步读法不把节制排在过度汲取之上（P9b，§12） |

`Becoming.Bridge` 另证明核心的整段读法就是 `RenewalComparison.relationalInventory`（`Ranking.wholeRun_iff`），不在场继续的水平就是它的 `undisturbed`（`Ranking.undisturbed_eq`）。

**解读。** 两个排序在逐步读法下分道。共享对以消耗取胜：两次继续里胜者都在场，共享的继续记入胜者的全部事件，又多出被断裂者在损失之后的活，所以仍是扩展。不在场对在场：不在场的继续根本没有那个形成；焦点形成有一个使每个所需仍被满足的事件时，在场的继续里这一事件被记入，所以不在场不是扩展（没有这样的事件时，逐步读法同样把不在场排得更高，`Immediate`，§12）。`withheld_of_extends` 说明这不是逐步读法的偶然：任何记入该形成某个事件的读法，都使 C 单独不能把它的不在场排得更高。要得到关于恶性增殖的判决的比较形式（“没有它更好”，C 的 AI 形式路线），比较所用的读法必须扣下它在损失之前的事件，整段读法正是如此；或者在 C 之外加更强的比较，例如 J1 的基本条件优先。

与节制的比较不同（`restraint_ranks`、`malignant_restraint`，P7b）。同一形成在越过阈值之前停止的继续，记入它在两次继续中共有的早期事件，又多出维持者此后的活，所以在两种读法下都是扩展。在二元定律族中，逐步读法下 C 失去与不在场的比较，不失去与每步都满足所需的节制的比较（第二次独立审查 §3 的预期）；有第三个形成共用条件时，与节制的比较也可以失去（`ThirdParty`，§12）。

这使 §8.5 的选择更精确，但不替 Ren 作出：

- 若 G0 与 C 共用一种读法，逐步读法保持“共享优于以消耗取胜”，失去“没有恶性增殖更好”；整段读法两者都保持，代价是 (b) 与 (c)。
- 若 G0 的记入取逐步读法、C 的比较取整段读法（§8.5 的候选分工），两个排序都保持，但 G0 与 C 不再共用一种 living 读法。形式上两者各自以读法为参数，并不强制共用；但前提卡上 C 所说的“活的内容”就是 G0 的 living，分开取须在前提卡上公开。

**作者反审。**

*反驳 1：“不在场”的继续是虚构的比较世界。* 它与 relational-reading-comparison 用的是同一继续，水平由同一定律在焦点形成不出现时给出（`Ranking.undisturbed_eq`）。是否把它当作可行的选项，是实践判断的问题，这里只问 C 的排序。

*反驳 2：`preferOccurs` 是为结论构造的。* 它只表明 C 不决定：C 只要求扩展被排得更高，没有说别的。它不是任何人会采用的比较；结论是 C 单独不足，而不是在场更好。

*反驳 3：逐步读法下胜者的早期事件被记入，这本身就说明逐步读法错了。* 这正是读法选择的内容之一。在逐步读法下，那些事件在发生时与他者的依存相容；判它们为不活，需要知道运行此后怎样继续（`Becoming.Horizon`）。

**边界。** 只在支持门控定律族与三对比较继续中证明（§11、§12）；不涉及关系层读法（其焦点形成的第一个关系同样被记入，结论相同，但未单独形式化）；不推出责任、义务或可行性。本节经第三次独立审查，更正见 §12。

## 10. 条件的对应纪律（P9）

2026-10-09。按同一指示继续。第一次独立审查列出的、会改变其判断的第一种结果是：一条排除惰性或虚设条件的对应规则，并证明在声明的类中连通在这一规则下仍成立（§7.3 第 1 项）。本节在核心上给出一条，并写明它不解决什么。成果记录：[condition-correspondence-discipline](../../../../theories/becoming/results/records/condition-correspondence-discipline.md)。

```text
Result(s): 复用 becoming-stepwise-reading（逐步 living、共同参与与侵蚀）、metaethical-core-characterization（significant_iff）；
           新增 condition-correspondence-discipline（L4）
Delta: 一条条件的对应纪律：一方汲取、另一方以正水平依存，两个事件才经由该条件相关；
       惰性条件不再免费连通；在声明的类中连通仍成立；写明未解决的部分
Supplied premises / correspondence: 纪律本身是公开的对应选择；“每个形成都汲取并依存于某条件”一类主张是应用义务
Evidence: Becoming.Correspondence 21 项定理（P9 时；P9b 后 25 项）；合并检查器回执（见记录）
Boundary: 不改变 living；不处理时间次序；只对逐步读法陈述
Integration: §7.3 第 1 项部分承接；审查 Q4 在纪律下排除，Q5 只排除共同依存的一半、传递的一半仍在（§12），Q10 未解决
```

[Becoming.Correspondence](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Correspondence.lean)（L4）保留逐步读法的 living（活跃且不侵蚀），只把 `related` 从共同参与收窄为交互。

| 声明 | 内容 |
|---|---|
| `Bearing`、`Interacts`、`Idle` | 以正水平依存（条件能使之落空）；两个事件经由某条件交互：一方汲取，另一方以正水平依存，在任何步上；条件惰性：没有活动汲取它，或没有依存能落空 |
| `Web.interaction`、`interaction_narrows` | living 与 `Web.valuation` 相同，`related` 改为经由某条件交互；交互蕴含共同参与 |
| `Idle.not_interacts`、`Idle.not_undermining` | 惰性条件不构成任何关系，也不使任何事件侵蚀 |
| `adjoin`、`adjoin_living`、`adjoin_connected_iff` | 加入一个从不被侵蚀的条件，living 不变；加入惰性条件，关系与连通也不变 |
| `inert_connects` | 审查 Q4 在纪律下：加入人人在水平 0 依存、无人汲取的条件，living 不变，共同参与下每个网都连通，交互下连通不变 |
| `UnderminingOn.interacts`、`valuing_undermining_reaches` | 每个侵蚀关系都是交互；在 N_rel 下，珍视一个侵蚀事件的立场，必珍视被侵蚀形成在以正水平依存于该条件的每一步上的活的事件 |
| `connected_of_commons`、`significant_iff_of_commons` | 一个条件，每个活的事件都汲取它或以正水平依存于它，且有活的汲取者与活的依存者，使整体连通（任意两个活的事件至多经两次交互相连）；于是 G0 恰等于种子加 N_rel 加 N_std |
| `Shared.connection_by_living_use` | 两个形成依存于同一条件。条件的使用维持它们的支持时，二者经由这一使用连通；唯一的使用侵蚀它们时，二者不连通。共同参与在两次运行中都连通它们 |
| `universal_connects` | 未解决的部分：加入一个被更新、人人汲取并以正水平依存的条件，living 不变，每个网在交互下都连通 |
| `drawing_reaches`、`one_use_connects`、`Later`、`Pinned.drawing_interacts` | 传递由汲取承担；剩余的免费连通只需人人以正水平依存、一次使用；交互不排定时间，也不问效果（P9b，§12） |

**解读。**

- **免费的连通被排除。** 纪律把“什么算相关”从共同参与收窄为交互：一方汲取、另一方以正水平依存于同一条件，在任何步上。这是结构上的共现，还不是一方的汲取落在另一方的支持上（§12）。惰性条件上没有交互，所以 Q4 的免费连通不再成立；Q5 中“只共同依存也算相关”的一半不再成立，“珍视任何汲取者即达到每个依存者”的一半仍在（`drawing_reaches`）。
- **living 与 related 读同一种关系。** 逐步读法扣下一个事件，正是因为它与某个依存者有这种交互（`UnderminingOn.interacts`）。纪律下的关系不是另加的，而是 living 已经在读的关系。
- **连通由活的使用造成。** 经由一个条件的连通，需要一个活的汲取者与一个活的依存者。使一个条件连通整体的，是对它不侵蚀的使用。这与 Q10 相容：Q10 说粗的共同条件在其依存落空时使汲取它的事件不 living；纪律下，那样的条件本来就不能经由那些事件连通。
- **代价。** 在 `Shared` 中，唯一的使用侵蚀依存者时，依存者彼此不经由这一条件连通。在 N_rel 下，意义从一个依存者传到另一个，需要别的关系。G0 在那里仍可以直接采用，只是 `significant_iff` 的刻画所需的连通不由这一条件给出。侵蚀者与被侵蚀者之间有交互，所以珍视侵蚀者的立场仍达到被侵蚀者（`valuing_undermining_reaches`）。
- **纪律排除不了的。** 一个被更新、人人以正水平依存、被一个活的事件使用一次的条件，在网上与真实的共同条件（例如人人呼吸的空气）无法区分（`one_use_connects`；人人汲取的情形是 `universal_connects`）。它的内容是一个事实主张，即每个形成都实际以正水平依存于它，由应用检验，而不是免费得到。纪律把免费的连通变成了需要证据的连通。

**作者反审。**

*反驳 1：只共同依存于同一条件（例如两株植物依存于同一阳光），也是一种关系，纪律把它丢了。* 对：共同依存已是一种关系，即经由共同条件的共同构成；两株植物经同一阳光已经相关，遮光是另加的关系，不是第一种关系。纪律选择省略它，并没有表明它不是关系，省略的代价见 `Shared`；应用若要把它算作关系，须写出它。“没有形成汲取的条件，其水平不受任何形成的活动影响”是对应上的意图，不是 `Web` 的性质（§12）。纪律是公开的选择；共同参与这一选择及其后果 Q4 都保留在核心上。

*反驳 2：`draws` 不带数量，所以汲取本身也可以是虚设的。* 对。人人“汲取”、无人以正水平依存的条件是惰性的（`Idle` 的第二种情形），不构成关系；但人人以正水平依存、被使用一次的条件（`one_use_connects`）在网上排除不了。纪律排除的是结构上不能承载交互的条件，不是虚假的汲取或依存声明。

*反驳 3：被侵蚀者彼此不连通，是纪律的缺陷。* 这是纪律的代价，已证明并写明（`Shared`）。共同参与下它们连通，但同一选择使 Q4 免费。两种选择各有代价，由 Ren 选择。

*反驳 4：交互不管时间。* 与共同参与相同，本节没有处理。按时间次序的纪律（汲取不晚于依存）会使连通类更窄，列为开放。交互也不问汲取是否改变水平（`Later`、`Pinned.drawing_interacts`，§12）。

**边界。** 纪律只对逐步读法陈述；依存不变时，它经 `K.dependence.along r` 适用，整段读法可以取同一关系，这里没有做。纪律不改变 living，不处理时间次序，不解决 Q10 与剩余的免费连通（`universal_connects`、`one_use_connects`），不选择读法。纪律本身是公开的对应选择，不是展开的推论。本节经第三次独立审查，更正见 §12。

## 11. 第二次独立审查与更正（P7b）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P7（§8）与 §7.1 对“不侵蚀”的选取，并读了 P8 中与读法比较相关的部分（[审查](../history/root-foundation/BECOMING-P7-REVIEW.md)）。它在仓库之外重新编译全部 P7 模块，接受每条定理，公理报告为空；判定 `UnderminingOn` 与 `UnderminingFor` 的定义需修正、but-for 检验须固定动作；指出散文在七处强于 Lean，§8.5 的表在 (a)(b) 两行与 but-for 一栏上不公允。审查附有 23 条无公理的探针。本节记录逐项处理。更正都在核心上：探针的内容作为定理移入相应模块，公理报告为空。

```text
Result(s): 修正 becoming-stepwise-reading（侵蚀的定义）、becoming-return-grades、becoming-finite-horizon、
           joint-difference-making、substitution-preserves-consumption、ranking-under-readings、
           becoming-dependence-dynamics；不新增结果记录
Delta: “曾被满足”改为“在依存成立期间曾被满足”（MetSince）；but-for 检验固定动作；
       视界结果在有反馈的定律中成立；按数量的读法逃出视界结果；整段与步层面的差别制造分开；
       替代的“保持”只对整段读法成立；逐步读法下 C 仍把节制排在过度汲取之上
Supplied premises / correspondence: 不变；判据 (a) 的来源改写为 Ren 采纳的问题与 Ren 所述的不重叠
Evidence: Becoming.Dependence 39、Return 29、Horizon 14、Joint 16、Substitution 6、Ranking 19 项定理；
          合并检查器回执 20261009T013859.515931Z（236 项定理／451 项声明审计，公理报告全空）
Boundary: 读法的选择仍属 Ren；越过阈值之前的事件怎样判，Ren 的原话未定
Integration: 审查的 F1–F15 全部处理；它列出的会改变判断的结果中，第 1、4、5 项完成，第 2、3 项开放（第 1、5 项经第三次独立审查改为部分完成，§12）
```

### 11.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| F1 | `UnderminingOn` 的“当时或此前被满足”只比较现在的所需与过去某步的水平，不要求依存当时成立：一个新来的依存者使此后每个汲取者都侵蚀 | 定义修正：`Web.MetSince t g c`，存在 `s ≤ t`，依存从 `s` 到 `t` 每步都成立，且 `t` 时的所需不超过 `s` 时的水平（P9b 再修正为：`s` 时的所需被满足，且 `t` 时的所需不超过 `s` 时的所需，§12）。`UnderminingOn`、`UnderminingFor` 与关系层读法都用它；原有见证的所需不变，按新定义重证，结论不变。审查的反例成为 `NewNeed.never_met_not_undermining`：旧子句成立而 `MetSince` 不成立，汲取者在任何一步都不侵蚀，而整段读法经继承的 `Consumed` 仍计它为消耗 |
| F2 | (a)(c) 的冲突依赖对 (a) 的一种读法与不带数量的可观测量，不依赖缺少反馈 | §8.5 约束 1 重述；新增 `Commons.whole_run_credits_overdraw`、`Commons.amount_reading`、`Feedback.prefix_does_not_decide`；§8.2 解读、§8.6 回应 3、章节 §2 与 §6.3、记录 becoming-finite-horizon 相应更正；“未知的是动作，不是动力学”作为论证写入 §8.2 |
| F3 | 替代之后，逐步读法记入消耗者 | `Substitution.stepwise_credits_substitution`；§8.4、模块说明、章节与记录改为“只对整段读法保持，几乎由定义给出”；加入 (a) 一行 |
| F4 | 逐步、周期与关系层读法不满足 (b) | `Pool.within_share_undermines`、`Pinned.undermining_without_effect`；(b) 一行改为“部分”；§7.1 的代价加上“甚至不改变任何水平” |
| F5 | 偏好“不侵蚀”的理由是反事实的，定义不是 | `Pinned` 表明侵蚀读的是共同参与一个未恢复的短缺，不是对不回程的贡献；“使条件回不来”限于公地见证：§7.1、`Dependence` 模块说明与热力学一条改写 |
| F6 | but-for 固定配置而不固定动作 | 定义修正：`Dependence.BreaksBy`，`MakesDifference` 与 `Overdetermined` 都相对于实际所取的动作；`Pool` 重证；`Shock.move_decides` 表明不固定动作时动作决定结果（P9b 补上“动作可取”，§12） |
| F7 | `depletion_is_joint` 是尾部不变性；步层面的 but-for 挑出断裂事件 | `Commons.no_finite_segment_makes_difference`、`Commons.breaking_event_makes_step_difference`；§8.3、§8.5 约束 2、章节与模块说明分开整段与步层面的检验 |
| F8 | “更新即一步周期内更新”只有一个方向 | `LateMet.within_one_not_renewing`；模块说明与 §8.1 改为“更新蕴含一步周期内更新” |
| F9 | 周期读法并非都由有限的步决定 | `Commons.cycle_reading_not_finite`；改为“事件层面的逐步与周期读法” |
| F10 | 周期长度 0 是退化的 | `Web.renewedWithin_zero`、`Web.undermining_for_zero`；写明周期取 `p ≥ 1` |
| F11 | 判据 (a) 的来源，以及“采用” | 在[来源](../../../../sources/15-codex-theory-conversations/2026-10-09-renewing-consuming-without-axioms.md)中，癌、军备竞赛与自我强化的“赢”这一列举是 AI 审查的文字；Ren 引用它，要求以关系结构分开两类形成、不需要任何 axiom，并说生成与退化不重叠。(a) 改为“Ren 采纳的问题与 Ren 所述的不重叠”，越过阈值之前事件的判决标为 AI 的延伸；“采用”改为“工作候选，待 Ren 选择”（§7.1、模块说明、章节、记录） |
| F12 | 热力学一条缺前提 | 加入“若每个形成都汲取这样的条件”，并补上损失之后的另一半 |
| F13 | 章节 §4 英文“Two spine facts”后面列了四条 | 改为“Four” |
| F14 | `drawing_after_loss` 的“draws nothing” | 改为“takes nothing (action 0)”，并注明公地的 `draws` 对数量盲，在 0 时也是 |
| F15 | 记录 | 五个记录按审查更正；relational-reading-comparison 中的“his”改为“Ren's” |

### 11.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Dependence | `Web.MetSince`、`Web.MetSince.now` | 依存在成立期间曾被满足（定义经 P9b 修正，§12）；依存现在成立并被满足，即是 |
| Dependence | `NewNeed.never_met_not_undermining` | 见 F1 |
| Dependence | `Pinned.undermining_without_effect` | 外来的崩塌使水平在每一步之后都是 0。汲取与不汲取的两次运行水平处处相同；汲取的一次从第 1 步起每个事件都侵蚀，整段读法计它为消耗 |
| Return | `Web.renewedWithin_zero`、`Web.undermining_for_zero`、`LateMet.within_one_not_renewing` | 见 F8、F10 |
| Horizon | `Commons.whole_run_credits_overdraw`、`Commons.amount_reading`、`Commons.cycle_reading_not_finite` | 见 F2、F9 |
| Horizon | `Feedback.law`、`Feedback.prefix_does_not_decide` 及其引理 | 支持门控定律中的视界结果 |
| Joint | `Dependence.BreaksBy`、`Shock.move_decides` | 相对于动作的 but-for；不固定动作时动作决定结果 |
| Joint | `Pool.within_share_undermines` | 见 F4 |
| Joint | `Commons.no_finite_segment_makes_difference`、`Commons.breaking_event_makes_step_difference` | 见 F7 |
| Substitution | `Substitution.extracting_low`、`Substitution.stepwise_credits_substitution` | 见 F3 |
| Ranking | `Ranking.Restraint`、`stops_credited`、`restraint_ranks`、`malignant_restraint` | 节制：每个所需始终被满足的继续扩展过度汲取的继续，两种读法下 C 都把它排得更高；恶性增殖与在阈值之前停止相比也是如此（审查 §5 第 5 项） |

`Becoming.Horizon` 另证明 `le_of_add_le_add_right` 与 `add_right_cancel` 的无公理版本：Lean 4.29.1 中同名的核心引理依赖 `propext`。

### 11.3 审查列出的会改变判断的结果

1. 修正 `UnderminingOn` 并重证逐步定理：P7b 时部分完成（F1），只在所需不变时合乎其意；P9b 改为比较那一步的所需后完成（§12）。§7.1 对三个候选的比较成立。
2. Ren 的原话或决定：对以消耗取胜的判决是否覆盖越过阈值之前事件的整段分类。开放，属于 Ren。
3. 一个带数量与更新率的网，以及一个满足 Ren 所述的 (a)、可由有限历史判定的读法，或证明每个这样的读法都在某个有来源的情形中不满足 (a)。开放。`amount_reading` 在公地过程中给出前者的雏形，但不在 `Web` 上。
4. 相对于动作的 `MakesDifference` 并重证 `Pool`，以及渐进耗竭的步层面陈述：完成（F6、F7）；P9b 补上“动作可取”（§12）。
5. 证明逐步读法下 C 把在阈值之前的节制排在恶性过度汲取之上：部分：在二元定律族中完成（`malignant_restraint`），有第三个形成共用条件时不成立（`ThirdParty`，§12）。

### 11.4 作者反审

*反驳 1：修正 `UnderminingOn` 只是让定义合乎散文。* 修正使定义在所需不变时合乎它要表达的意思（对它的一个依存，在成立期间曾被满足）；所需变化时还不合乎，P9b 再修正（§12）。审查的反例由此成为定理，而不是被隐去：旧子句的行为保留在 `never_met_not_undermining` 的第三个合取项中。

*反驳 2：按数量的读法说明“不带数量”是表示的缺陷，应当先给 `Web` 加数量。* 同意它是表示所省略的关系，不是对理论的反驳。加数量与更新率会改变什么可表达，须连同新的反例一起做，列为开放（§11.3 第 3 项）。

*反驳 3：节制的结果太容易：停止的继续每一步都满足所需。* 定理本身简单；它的内容在于逐步读法下也成立，即使过度汲取者在损失之前的事件被记入。在二元定律族中，这把 §9 的代价限于与不在场的比较；有第三个形成共用条件时并非如此（§12）。

**边界。** 不改变读法选择的地位；不推出责任或义务；探针与新见证都是最小见证。P8（§9 的原有部分）、P9（§10）与本节当时尚未经独立审查；第三次独立审查及其更正见 §12。

## 12. 第三次独立审查与更正（P9b）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P8（§9）、P9（§10）与 P7b 的更正（§11）（[审查](../history/root-foundation/BECOMING-P8-P9-P7B-REVIEW.md)）。它在仓库之外从前导重新编译全部声明，公理报告为空，计数、哈希与别名都对，数学接受。问题在定义与散文的对应上，共十二项（G1–G12），附无公理的探针。审查没有发现替 Ren 作出的选择，也没有发现把 AI 文字当作 Ren 原话之处；它指出“没有它更好”被写成 Ren 所采纳的判决的形式（G11）。本节记录逐项处理。定义的修正都在核心上；探针的内容作为定理移入相应模块，公理报告为空。

```text
Result(s): 修正 becoming-stepwise-reading（MetSince）、joint-difference-making（MakesDifference）、ranking-under-readings、
           substitution-preserves-consumption、condition-correspondence-discipline、becoming-finite-horizon；
           becoming-dependence-dynamics 只改计数；不新增结果记录
Delta: MetSince 比较那一步的所需；依存中断一步即开始新的一段（披露）；MakesDifference 要求动作在扣除后可取，Determined 写明
       检验何时合乎其意；逐步读法失去与不在场的比较，须有被记入的事件；节制的结论限于二元定律族；替代者被扣下的不止一步；
       交互是结构上的共现，传递由汲取承担，剩余的免费连通只需一次使用
Supplied premises / correspondence: 新增披露：依存的一段须不间断；外来冲击写进动作，不写进步骤关系；共同依存是纪律所省略的关系
Evidence: Becoming.Dependence 51、Joint 20、Substitution 7、Ranking 27、Correspondence 25 项定理；
          合并检查器回执 20261009T025042.064543Z（265 项定理／502 项声明审计，公理报告全空）；外围桥接 20261009T025129.902360Z
Boundary: 读法的选择仍属 Ren；排定时间、对效果敏感的交互与二元定律族之外的节制定理开放
Integration: G1–G12 全部处理；审查列出的会改变判断的结果中，第 1、5 项完成，第 2 项披露，第 3、4 项开放，第 6 项属于 Ren
```

### 12.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| G1 | `MetSince` 比较现在的所需与过去某步的水平。所需下降时，一个从未被满足的依存，因早先的水平足以覆盖现在较小的所需，被算作曾被满足；所需增长时，以较小所需的满足被算作满足了增长后的依存 | 按审查的第一种方案重定义：存在 `s ≤ t`，依存从 `s` 到 `t` 每步都成立，`s` 时的所需被满足，且 `t` 时的所需不超过 `s` 时的所需。`UnderminingOn`、`UnderminingFor` 与关系层读法都经它；原有见证的所需不变，增加的子句由 `Nat.le_refl` 给出，结论不变。探针成为 `FallingNeed.never_met_not_undermining` 与 `RisingNeed.grown_need_not_met`：两者中汲取者在任何一步都不侵蚀。§7.1、§11、章节、术语表与记录随之更正 |
| G2 | 依存中断一步即抹去此前的满足 | 披露为假设：依存的一段须不间断，休眠或迁出是否表示为持续的依存，是应用义务（记录 becoming-stepwise-reading、§7.1）。`Gap.lapse_starts_afresh`：中断时汲取者在任何一步都不侵蚀，而整段读法计它为消耗；依存连续时，它自第 3 步起每步都侵蚀。经有界缺席延续一段，列为开放 |
| G3 | 逐步读法“失去与不在场的比较”须有被记入的焦点事件，八处省去这一假设 | 各处补上“焦点形成有一个使每个所需仍被满足的事件时”（根模块、`Ranking` 模块说明、§9、章节 §6.5、记录标题与关联）。`Ranking.Immediate.stepwise_ranks_absence`：第一步就越过支持的形成，在两种读法下都排在其不在场之下 |
| G4 | “失去的只是与不在场的比较”只在二元定律族中、对每步都满足所需的节制证明 | 改为“在二元定律族中，失去与不在场的比较，保留与每步都满足所需的继续的比较”。`Ranking.ThirdParty.restraint_unranked_stepwise`：有第三个形成共用条件时，逐步读法下两次继续互不扩展，整段读法下节制仍扩展过度汲取。记录的限制改为三对比较继续；§11.3 第 5 项改为“部分” |
| G5 | 替代者“只在一步上不被记入”只对 `extracting` 成立 | 改为“维持者失去支持之前被记入，此后到它转向为止被扣下（`extracting` 中一步）”。`Substitution.slow_withheld_two_steps`：在 `slow` 中第 2、3 步都被扣下 |
| G6 | 相对于动作的 but-for 需要动作在扣除后可取，并在步骤是动作的函数时才准确；记录中“把外来冲击写进过程”恰会重新引入原问题 | `MakesDifference` 加入 `∃ t, P.step (withhold f s) a t`。新增 `Determined`（动作决定步骤），证明 `Shock.determined` 与 `Pool.determined`，所以 `Pool` 与 `Shock` 的结论照旧成立。探针成为 `Hidden.shock_in_the_step`（冲击写进步骤关系时，损失又被多重决定）与 `Tagged.move_unavailable`（动作在扣除后不可取时，没有“可取”一项则每一方都空洞地造成差别，有了它则没有哪一方造成差别）。记录的建模指示改为“把外来冲击写进动作，不写进步骤关系”；术语表的差别制造补上“同一动作”与“该动作可取” |
| G7 | 交互不排定时间、不问汲取的效果，却被说成“一方的汲取落在另一方的支持上” | 改为“一方汲取、另一方以正水平依存于同一条件，在任何步上”；排定时间、对效果敏感的版本列为开放。`Later.drawing_connects_earlier`：第 5 步的汲取与只在第 0 步成立的依存交互，并连通二者。`Pinned.drawing_interacts`：不改变任何水平的汲取也交互。§10 反驳 1 中关于水平的一句改为对应上的意图，不是 `Web` 的性质 |
| G8 | 剩余的免费连通只需一次使用 | `Web.one_use_connects`：对有一个活的事件的网，加入人人在水平 1 依存、只被该事件的形成在该步汲取一次的条件，条件被更新，living 不变，网在交互下连通。剩余部分改为“人人以正水平依存、被使用一次的条件” |
| G9 | “Q5 不再成立” | 改为“Q5 只排除共同依存的一半；传递的一半仍在：任何汲取都传递”（`Web.drawing_reaches`） |
| G10 | 把共同依存称为“处境的相关” | 改为“纪律所省略的关系（经由共同条件的共同构成）”；两株植物经同一阳光已经相关，遮光是另加的关系；`Shared` 显示省略它的代价 |
| G11 | “没有它更好”被写成 Ren 所采纳的判决的形式 | §9 改为“关于恶性增殖的判决的比较形式（“没有它更好”，C 的 AI 形式路线）”；joint-difference-making 改为“该结果所记录的 C 的排序，它们把 Ren 所采纳的问题形式化”；§8.2、章节 §6.3、英文 P7b 段与 becoming-finite-horizon 改用“Ren 所采纳的问题” |
| G12 | 计数与条目 | §9 写明各阶段的定理数；排序记录的限制与反例补齐；章节术语表补上交互、承担与惰性条件三条；§8.5 末段按 G4 收窄；becoming-stepwise-reading 的 P7b 历史条目保留原文，由新的历史条目更正 |

### 12.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Dependence | `Web.MetSince`（修正） | 依存自某步起不间断成立，那一步的所需被满足，且现在的所需不超过那时的所需 |
| Dependence | `FallingNeed.web`、`FallingNeed.never_met_not_undermining` 及其引理 | 所需由 3 降到 1，依存每一步都不被满足；第 5 步起现在的所需不超过第 0 步的水平，但那不算；汲取者在任何一步都不侵蚀，整段读法计它为消耗 |
| Dependence | `RisingNeed.web`、`RisingNeed.grown_need_not_met` 及其引理 | 所需 1 在第 0–4 步被满足，自第 5 步增长为 2 而从未被满足，虽然第 0 步的水平足以覆盖它；汲取者在任何一步都不侵蚀 |
| Dependence | `Gap.away`、`Gap.held`、`Gap.lapse_starts_afresh` | 见 G2 |
| Joint | `Determined`、`Shock.determined`、`Pool.determined` | 动作决定步骤；两个原有过程满足它 |
| Joint | `Hidden.process`、`Hidden.shock_in_the_step`；`Tagged.process`、`Tagged.move_unavailable` | 见 G6 |
| Substitution | `Substitution.slow`、`Substitution.slow_withheld_two_steps` | 见 G5 |
| Ranking | `Immediate.law`、`Immediate.focal_withheld`、`Immediate.stepwise_ranks_absence` | 见 G3 |
| Ranking | `ThirdParty.courses`、`ThirdParty.focal_three`、`ThirdParty.restraint_unranked_stepwise` 及其引理 | 见 G4 |
| Correspondence | `Web.drawing_reaches` | 见 G9 |
| Correspondence | `Web.Condition.single`、`Web.one_use_connects` | 见 G8 |
| Correspondence | `Later.web`、`Later.drawing_connects_earlier`、`Pinned.drawing_interacts` | 见 G7 |

### 12.3 审查列出的会改变判断的结果

1. 重定义 `MetSince`，并以 `FallingNeed`、`RisingNeed` 为定理：完成（G1）。第四次独立审查指出所需增长之后的代价（H1），P11b 改为最小形式 `MetAbove`，见 §15。
2. 关于依存中断的规则：披露为应用义务（G2）；经有界缺席延续一段的定义开放。
3. 二元定律族之外的节制定理（有多个共用者，或带数量使不取者不侵蚀）：开放；`ThirdParty` 是它须面对的反例。
4. 排定时间、对效果敏感的交互，并重证 `connected_of_commons`：开放（G7、G8）。
5. `MakesDifference` 中的动作可取与动作决定步骤，并重证 `Pool` 与 `Shock`：完成（G6）。“动作可取”写进定义；“动作决定步骤”作为 `Determined` 陈述，原有过程满足它，但不作为定义的前提，因为非确定的过程可以把结果写进动作。
6. Ren 对读法的选择，以及 Ren 对越过阈值之前的事件、对“没有它更好”是否为 Ren 的判决的原话：属于 Ren。

### 12.4 作者反审

*反驳 1：修正 `MetSince` 又一次只是让定义合乎散文。* 这一次修正的是散文的意思中定义没有说出的部分：“曾被满足”是在那一步、以那时的所需被满足。所需增长时，以较小所需的满足是否算数，是一个读法选择；修正把它定为不算，并以 `RisingNeed` 写明，所以它是公开的选择，不是隐去的反例。（第四次独立审查指出，这一选择还有未披露的代价：所需增长之后，把水平压到曾被满足的旧所需之下的汲取也不算（`Stunted`）。P11b 改为最小形式，见 §15。）

*反驳 2：依存中断即重开一段，对休眠与迁徙的生命不公平。* 同意这是一个有后果的表示选择。修正没有改变它，而是把它写成应用义务，并给出见证；若要经有界缺席延续，可以用 `ReturnsWithin p` 定义一段，列为开放。

*反驳 3：`ThirdParty` 说明逐步读法连节制都排不出，所以应当放弃逐步读法。* `ThirdParty` 的损失来自已披露的代价 (b)：节制者在第 3 步的事件被扣下，是因为第三者在那一步的汲取使它自己曾被满足的依存落空，而 `draws` 不带数量，节制者在那一步也算汲取。它表明代价 (b) 能达到节制的比较。是否因此放弃逐步读法，或给网加数量，是读法选择的材料，本节不作决定。

*反驳 4：交互既然不是“落在支持上”，纪律就没有根据。* 纪律原是公开的对应选择，它排除结构上不能承载交互的条件，这一点仍成立（`Idle`、`inert_connects`）。审查纠正的是解释：交互是共现，不是作用。排定时间、对效果敏感的版本会使纪律更接近这一解释，也会抬高剩余免费连通的价格。

**边界。** 不改变读法选择的地位；不推出责任或义务；探针与新见证都是最小见证。本节的更正尚未再经独立审查。

## 13. 继续生成：生起、不息与更新（P10）

2026-10-09。按同一指示继续（“prove the necessary proofs”）。第一次独立审查的判据 (d) 问读法是否含有继续生成的成分；§8.5 的表在每一栏都答“否”，§7.3 第 4 项把它列为开放。本节在核心上陈述生起（变为活跃），作为生生第二个“生”的一种读法的形式载体（作者的读法；P11b 更正，§15），并证明它与更新的关系。成果记录：[unceasing-generation-needs-renewal](../../../../theories/becoming/results/records/unceasing-generation-needs-renewal.md)。

Ren 的原话是：“我的答案是生生不息 - 一种整体的，不断创造更多生的方向，而这个方向产生的可能性，多样性越高，复杂性/复杂结构的复杂度可以不断的上升，就是一个好的方向”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-07-shengsheng-ethical-direction.md)）。本节只形式化其中“不断…生”这一部分：生成在整体的继续中不止息。“更多”、可能性、多样性与复杂性不在这里。Ren 说的是整体的方向，所以这一成分陈述在整体的继续上，不陈述在单个事件上（这是作者的读法）。

```text
Result(s): 复用 becoming-renewal-reading（下降原则 falls_finitely、公地过程）、becoming-dependence-dynamics（依存网、形成与消解）、
           becoming-stepwise-reading（侵蚀）、becoming-return-grades（周期读法）；新增 unceasing-generation-needs-renewal（L3）
Delta: 生起与不息的生成；有限条件家族的总水平原则；在消耗前提与“上升由形成造成”之下，不息的生成需要更新复现；
       更新不蕴含生成；以消耗为条件的生起停止；替代推迟终结而不逃脱；耗散使生成停止
       （P11b 更正用语与最后一项，原写作“总水平不升的有限家族不能维持不息的生成”，§15）
Supplied premises / correspondence: 在没有条件上升之步，生起时家族中某个条件下降（消耗前提，P11b 前称支付前提）；
       每次上升由某个活跃形成的更新造成；
       条件家族有限；renews 是应用给出的可观测量
Evidence: Becoming.Generation 18 项定理（P11b 之后 30 项，§15）；合并检查器回执（见记录）
Boundary: 不含伦理谓词；不陈述“更多”、多样性与复杂性；生成成分没有加入 living 的读法
Integration: §7.3 第 4 项与判据 (d) 部分承接；substitution-preserves-consumption 的下一步（替代条件有代价时替代链的去向）由 Relay 部分承接
```

[Becoming.Generation](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Arising.lean)（L3）：

| 声明 | 内容 |
|---|---|
| `Arises`、`Unceasing` | 形成跨某步生起：此前不活跃，此后活跃。生成不息：某个形成在任意晚的步生起。同一形成可以再生起：不息的是生起，不是某一形式 |
| `Rises`、`Falls`、`Still`、`Depletes`、`stock` | 条件跨某步上升或下降（净变化）；一个有限条件家族在某步都不上升；事件在家族都不上升之步使其中某个条件下降，即消耗家族（`depletes_iff`：这只说事件的每一步家族中有条件变化，与事件的关系不论）；家族的总水平 |
| `RenewedBy`、`Regenerating` | 每次上升都由某个活跃形成更新该条件造成：展开之外没有更新的来源，太阳或河流也是其中的形成。一个活跃形成更新家族中的某个条件 |
| `stock_le`、`stock_lt`、`depletes_finitely` | 家族都不上升时总水平不升，再有一个下降则总水平下降；从某步起都不上升的有限家族，只能被有限次事件消耗。这是 `Becoming.Renewal` 的下降原则用于总水平，总水平在这里只是下降的量度，与各条件的单位无关 |
| `Unceasing.rises`、`Unceasing.regeneration_recurs` | 生起消耗有限家族时，不息的生成使家族中某个条件在任意晚的步上升；每次上升都由更新造成时，更新的活动在任意晚的步复现 |
| `substitution_defers` | 一个在每个活跃步都使家族中某个条件下降的形成，在家族不再上升之后只活跃有限次，无论它怎样在家族中转移依存 |
| `dissipation_ceases` | 若一个量从不上升，而每次生起都使它下降（耗散），生成不是不息的。家族的总水平只在每次生起都使它下降时是这样的量（P11b 前为 `conserved_ceases`，只对总水平陈述） |
| `Commons.renewal_without_generation` | 只取所更新之量：条件被更新，任何形成都不生起。更新不蕴含生成 |
| `Growth.ceases` | 形成在汲取一个不被更新的条件时接连生起，条件被消耗，生成停止 |
| `Relay.defers` | 消耗者从第一个来源转向第二个，依存转化，然后终结：两个来源都不被更新 |
| `Bloom.unceasing`、`Bloom.readings` | 一个形成在另一个形成（太阳）更新的条件上反复生起：全部前提成立，生成不息，更新复现。逐步读法扣下它的每一次开花，两步周期的读法记入它 |

**解读。**

- **生成与更新的关系。** 在所述前提下，不息的生成严格强于复现的更新：不息的生成需要更新复现（`Unceasing.regeneration_recurs`），更新复现却可以没有任何生起（`renewal_without_generation`）。这给判据 (d) 一个在整体继续上的位置：“不损”的读法读出更新这一侧，继续生成是另加的、更强的成分。
- **以消耗为条件的生起不能不息。** 在不被更新的条件上，形成可以接连生起（`Growth`），这正是增长，但生起停止。在有限个不被更新的条件之间替代，只推迟终结（`Relay`）。这把 §8.4 的“替代不证明更新”推进一步：替代条件有代价时，替代链本身终结。在继续的层面，这与 Ren 所说的生成与退化不重叠相合（作者的读法）：在这些前提下，由不被更新的条件承担的生起不能不息。在单个事件的层面，`Arises` 包括以消耗为条件的生起；所以结果支持来源中 AI 修正说明的看法，即“持续形成新组织”的“持续”已排除消耗型。这是关于有限条件与消耗前提的定理，不是由定义得出的不重叠，也没有证明每个非消耗的样式都能不息（P11b 更正，§15）。
- **耗散与更大的展开。** 若一个量从不上升，而每次生起都使它下降（耗散），生成不能不息（`dissipation_ceases`）。`Bloom` 中太阳更新而不被扣减，是因为这一表示省略了太阳自身的条件。按非二元方法，这是表示所省略的关系，不是外在的实体。原文由此论证：把太阳的条件放进家族并照实计入，生成会停止，所以任何有限部分都不能独自不息。第四次独立审查指出这需要耗散前提：一个封闭循环的有限家族，总水平不变，可以维持不息的生成（`Recycle.closed_unceasing`）。所以论证只对每次生起都耗散的量成立，例如自由能；那是物理前提，不是定理的推论。家族的总水平还预设各条件的单位可公度（P11b 更正，§15）。在耗散之下，不息属于更大的展开及其更新关系。这是作者对定理的诠释（AI 论证），也是 §8.5 热力学读法的另一面。
- **逐步读法与生成。** `Bloom` 的每次开花都把自己的条件取到所需之下，由太阳在下一次之前恢复。工作候选的逐步读法扣下每一次开花，两步周期的读法记入它。这是 §8.5 中自创生／代谢读法所指代价在生成一侧的见证：一个不息地再生起的形成，在逐步读法下没有一个活的开花事件。

**作者反审。**

*反驳 1：这些定理只是 `falls_finitely` 的推论。* 形式上是：总水平原则就是下降原则用于有限家族的总和，记录也这样写，不另算一条原则。新的是陈述的对象：生起与不息、更新由形成造成、替代链与总水平不升的家族，以及三个见证给出的严格分离。

*反驳 2：“生起消耗家族”是把结论写进模型。* 它是对应前提：在没有补充之步，生起时家族中某个条件下降。（原文写作“生成不是无代价的，形成须从条件中取得”。`Depletes` 并不涉及生起的形成，`Tide` 中一个与之无关的潮落就满足它；P11b 删去此句，把前提系于生起的形成放在流的形式中，§15。）没有它，不息的生成可以不需要任何更新，例如一个形成无代价地反复出现。`Bloom` 与 `Growth` 显示前提可以满足，既可与不息的生成同时成立，也可与生成的停止同时成立。它的经验地位须由应用检验，例如开放系统中的能量流。

*反驳 3：“不息”只是无穷多次生起，太弱：一个形成忽隐忽现也算。* 对。所以“不息”须与消耗前提同读：在没有更新之步，每次生起时家族中都有条件下降，忽隐忽现也需要更新。Ren 原话中“更多生”的“更多”，以及可能性、多样性与复杂性的上升，这里没有陈述。

*反驳 4：把太阳当作展开中的一个形成，是在用形式变量偷渡“外部”。* 正相反：`RenewedBy` 要求每次上升都由展开中的某个活跃形成造成，排除了展开之外的来源；太阳在其中是一个形成。`dissipation_ceases` 说明，把太阳自身的条件也照实计入、并且每次生起都耗散时，有限的部分不能独自不息；没有耗散，封闭循环可以不息（`Recycle`，P11b 更正）。

**边界。** 不含伦理谓词；不推出“不息更好”或任何排序；不陈述“更多”、多样性与复杂性；生成成分没有加入 living 的读法；见证都是最小见证；`renews` 与消耗前提是应用义务。本节经第四次独立审查，更正见 §15。

## 14. 更多：流、供给与更新者（P11）

2026-10-09。§13 只形式化了 Ren 原话中的“不断…生”。本节陈述“更多”的一种读法，并证明它需要什么。成果记录：[more-needs-renewers](../../../../theories/becoming/results/records/more-needs-renewers.md)。

依存网只记录条件的水平。为了说“更多”，本节把条件读作数量：每一步参与的形成从条件取用多少、给予多少（流）。“更多”读作：对每个数，从某步起至少有那么多形成从一个有限的条件家族取用。这是作者的读法：更多的形成从同一组条件取用（P11b 更正：原写作“依赖同一组条件而活”；`More` 数的是流中的取用者，经 `Flow.Taking` 才与网中的活跃与汲取相连，§15）。可能性、多样性与复杂性的上升是“更多”的另外读法，这里不陈述。

```text
Result(s): 复用 unceasing-generation-needs-renewal（total、stock、RenewedBy、Arises、Unceasing、Bloom）、
           becoming-dependence-dynamics（依存网）；新增 more-needs-renewers（L3）
Delta: 条件作为形成取用与给予的数量；平衡的流使每次上升都由活跃的补充者造成，P10 的前提 RenewedBy 成为定理；
       消耗与补充的平衡在一步与任意一段上成立；不止地更多需要补充没有最终的界，每个形成给予有限时需要更新者的数目
       没有最终的界；不息的生成尚不是更多（P11b 更正用语，§15）
Supplied premises / correspondence: 流记录实际的取用与给予，present 每步只列每个参与的形成一次；
       “更多”读作从某步起取用者至少任意多；Capacity：每个形成每步给予家族的量有一个固定的上界；
       取用的量是自然数，所以每个取用者每步至少取用一个单位（P11b 写明）
Evidence: Becoming.Flow 28 项定理（P11b 之后 58 项，§15）；合并检查器回执（见记录）
Boundary: 不含伦理谓词；只读取用者的数目，不陈述多样性、复杂性与可能性；生成成分没有加入 living 的读法
Integration: unceasing-generation-needs-renewal 的下一步（陈述“更多”）部分承接
```

[Becoming.Flow](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Flow.lean)（L3）：

| 声明 | 内容 |
|---|---|
| `Flow`、`taken`、`given`、`Balances`、`Acting` | 每步参与的形成，以及每个形成从每个条件取用与给予的量。流平衡一个依存网：条件水平的每次变化恰是取用与给予之差。只有活跃的形成给予 |
| `count`、`steps`、`uptake`、`replenishment`、`takers`、`renewers` | 有限列表上的计数与连续的步（总和 `total` 来自 `Becoming.Generation`）；家族每步的取用与补充；从家族取用与补充家族的形成数目 |
| `Balances.over`、`Balances.accumulates` | 消耗与补充的平衡：一步之后家族的总水平加上取用，等于之前的总水平加上补充；对任意一段步也成立 |
| `Balances.renewedBy` | 平衡且只有活跃形成给予时，每次上升都由某个活跃的补充者造成：§13 的对应前提 `RenewedBy` 在这里成为定理 |
| `More`、`Capacity` | 不止地更多：对每个数，从某步起每一步至少有那么多形成从家族取用。每个形成每步给予家族的量至多一个固定量 |
| `More.replenishment_unbounded` | 不止地更多需要补充没有最终的界：没有一个从某步起成立的界，能界住家族所得的补充 |
| `More.renewers_unbounded` | 每个形成给予有限时，不止地更多需要补充者的数目没有最终的界 |
| `Garden.more` | 每一步都生起一个更新者和一个生长者：流平衡，只有活跃者给予，每个给予至多一单位，生成不息，并且不止地更多 |
| `Bloom.not_more` | §13 的开花反复生起，生成不息，流平衡，但至多一个形成取用：不息的生成尚不是更多 |

**解读。**

- **补充的层级，以及蕴含。** （P11b 更正。原文写作“构成一个层级，每一层需要的更新都比前一层多”与“给予者越来越多”。）在平衡的流中，三者各自所需的补充构成严格的层级：取用的形成不息地生起（`ArisesTaking`）需要补充在任意晚的步出现（`replenishment_recurs`）；不止地更多需要补充没有最终的界；`Bloom` 分开二者。三者本身只在所述对应之下按蕴含排列：复现的更新不蕴含不息的生成（`Tide.renewal_without_arising`），不息的生成不蕴含不止地更多（`Bloom.not_more`）；在活跃形成的普查之下、只有活跃的形成取用时，不止地更多蕴含不息的生成（`Flow.More.unceasing`），没有普查时不然（`Dormant`）。每个形成给予有限时，补充者的数目没有最终的界，并在平均的意义上越来越多（`Balances.renewers_over`），但可以在无穷多步上为零（`Pulse`）。
- **生生。** 由 `RenewedBy`，补充者是展开之内的形成。所以在 `Capacity` 之下，更多的取用需要补充更新的形成参与，其数目没有最终的界，在平均的意义上越来越多：生成的条件须由越来越多的形成补充。它们是否在展开中生起，定理没有陈述。这是作者对“生生”的一种结构读法（AI 论证），不替代 Ren 的原话，也不推出它是好的。若一个形成的给予可以无界地增长，更多可以由同一个补充者的增长承担；那也是一种“更多”，只是落在给予的量上。定理在 `Capacity` 下才把补充转为补充者的数目。读法的边界（P11b，§15）：补充者可以就是取用者自身（`Cycle.closed_more`），“补充的形成”不必是另一类；在 `Web` 与 `Flow` 中形成与条件是两类，一个形成本身作为另一个形成的条件（生作为生的条件）只能经由代理条件表示，这是表示所省略的关系（P14 更正：§18 以一类关系项读出这一关系）；每个取用者每步至少取用一个单位是前提，取用可以无限变小时，更多的取用者不需要更多的补充（论证，未形式化）。
- **持续的更多。** `More` 取的是持续的更多：从某步起一直至少那么多。只在个别步上任意多的情形，不受这一定理约束。
- **与 §13 的关系。** §13 中“每次上升都由形成的更新造成”是对应前提；在平衡的流中它是定理，前提移到了流本身：流须记录实际的取用与给予。`Garden` 的更新者凭空给予，与 `Bloom` 的太阳一样，是因为这一表示省略了它们自身的条件。若照实计入，它们也须被更新。原文接着写“更多的要求沿展开传递下去，没有一个有限的部分独自承担”；这需要耗散前提（每次给予都使补充者的条件付出多于所给），此处未陈述：在封闭循环中，补充者恰是取用者，家族的总量不变（`Cycle`，P11b 更正）。这与 §13 的 `dissipation_ceases` 是同一件事的两面。

**作者反审。**

*反驳 1：这只是平衡的恒等式。* `Balances.over` 与 `Balances.accumulates` 确是恒等式，由 `Balances` 的定义得出。新的是由它得出的必要条件：持续更多所需的补充与补充者没有最终的界，以及两个见证给出的严格分离。

*反驳 2：把“更多”读作取用者的数目太窄。* 是。更多种类、更复杂的结构、更多的可能性，都是“更多”的读法，这里都没有陈述。这里只读一种：更多的形成依赖同一组条件而活。

*反驳 3：`present` 中重复列出同一个形成会使计数失真。* 对。定理对列表条目成立；把条目读作形成，需要每步每个形成只列一次，这是应用义务，模块说明已写明。`Repeated`（P12b）表明这一前提是必要的。

*反驳 4：`Capacity` 是把结论写进前提。* 不是：没有 `Capacity`，`More.replenishment_unbounded` 仍然成立；`Capacity` 只把补充的无界转为补充者数目的无界。它是对应前提：一个形成的给予受它自身的大小与条件所限。

**边界。** 不含伦理谓词；不推出“更多更好”或任何排序；只读取用者的数目，不陈述多样性、复杂性与可能性；生成成分没有加入 living 的读法；见证都是最小见证；流与 `present` 的对应是应用义务。本节经第四次独立审查，更正见 §15。

## 15. 第四次独立审查与更正（P11b）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P9b（§12）、P10（§13）与 P11（§14）（[审查](../history/root-foundation/BECOMING-P9B-P10-P11-REVIEW.md)）。它在仓库之外从前导重新编译 17 个核心模块，公理报告为空；计数、回执、哈希与别名都对，数学接受。问题在定义、散文与对应之间，共十四项（H1–H14），附无公理的探针。审查没有发现替 Ren 选择 living 的读法；它指出两处来源问题（H7、H9），以及纯净核心中出现了 Ren 已纠正过的支付与账目用语（H13）。本节记录逐项处理。定义的修正都在核心上；探针的内容作为定理移入相应模块，公理报告为空。§6、§7、§12、§13 与 §14 中受影响的句子已就地更正并标明；原文见提交 `c48ec435`。

```text
Result(s): 修正 becoming-stepwise-reading（MetAbove）、becoming-return-grades、joint-difference-making（determined_dichotomy）、
           unceasing-generation-needs-renewal、more-needs-renewers、becoming-renewal-reading（一句）；
           新模块 Becoming.Population 的结果并入 more-needs-renewers；becoming-dependence-dynamics 只改计数；不新增结果记录
Delta: 侵蚀取最小形式（低于曾被满足的所需，也低于现在的所需）；Paid 改名 Depletes 并照实说明其内容；
       流的形式：取用的形成不息地生起需要补充复现；耗散前提写明，并对任意不上升的量陈述；
       在活跃形成的普查与 Taking 之下，不止地更多蕴含不息的生成，反之不然；补充的平均下界；
       补充者可以在无穷多步上为零；补充者可以就是取用者
Supplied premises / correspondence: 新增：耗散；每个取用者每步至少取用一个单位；Taking（只有活跃的形成取用，
       只从它汲取的条件取用）；活跃形成的普查（每步活跃的形成可列为有限且不重复的表，活跃可判定）；
       生起的形成在其第一个活跃步从家族取用（ArisesTaking）
Evidence: Becoming.Dependence 53、Joint 21、Generation 30、Flow 58、Population 20 项定理；
          合并检查器回执 20261009T042823.534750Z（376 项定理／688 项声明审计，核心闭包 18 个模块，公理报告全空）；
          外围桥接 20261009T042918.555373Z
Boundary: 新名称是审查的建议，最终由 Ren 定；第二个“生”与“更多”的范围、以消耗为条件的生起是否为生成，属于 Ren
Integration: H1–H14 全部处理；审查列出的会改变判断的结果中，第 1、2、4、5、7、8 项完成，第 3、6 项写为前提，第 9 项属于 Ren
```

### 15.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| H1 | `MetSince` 在所需增长之后抹去曾被满足的水平：一次把水平压到曾被满足的旧所需之下的汲取既不断裂也不侵蚀（`Stunted`）。§12.4 把增长的选择说成没有代价 | 采用最小形式。`Web.MetAbove t g c m`：在依存不间断成立的某步 `s`，`s` 时的所需被满足，并且大于 `m`。`UnderminingOn` 要求汲取之后水平低于某个曾被满足的所需，也低于现在的所需；`UnderminingFor` 与关系层读法都经它。`Stunted.stunting_undermines` 成为定理：增长之后低于曾被满足的所需的汲取侵蚀，而不断裂。`NewNeed`、`FallingNeed`、`RisingNeed` 与 `Gap` 的结论不变，其余见证也不变。只低于增长到从未被满足的所需，仍不算侵蚀（`RisingNeed`）；这是公开的选择。`undermining_for_zero` 随之改为：零步内，对任何有依存者的条件的汲取都侵蚀。`MetSince` 改名为 `MetAbove`；§6、§7、§12、章节、术语表与记录随之更正 |
| H2 | 根模块说明把 `Determined` 写成定义的一部分；二分还需第三个条件 | 根模块说明改为“相对于扣除之后仍可取的动作，动作决定步骤时合乎其意”。`Joint` 说明加上：依存在扣除之后仍成立并被满足；扣除本身使依存落空时（那一部分是支持者），检验不作判断。`determined_dichotomy` 成为定理 |
| H3 | G8、G11 各留一处 | becoming-renewal-reading 的对应改为“每个形成都以正水平依存、由一个活的事件使用一次的被更新条件”；§8.5 两句改为“对 Ren 所采纳的问题的判决” |
| H4 | `Paid` 只说事件之步家族中有条件变化，与生起的形成无关（`Tide`）；正面见证 `Bloom` 只空洞地满足它 | 照实说明，并按 H13 改名为 `Depletes`：在事件的每一步，若家族中没有条件上升，则其中某个条件下降。`depletes_iff` 证明它恰说事件的每一步家族中有条件变化，与事件的关系不论。`Tide.unrelated_depletion` 与 `Bloom.arises_on_rise` 成为定理。§13 反驳 2 中“形成须从条件中取得”删去。把前提系于生起的形成，在流的形式中完成：`ArisesTaking`，即形成跨某步生起，并在其第一个活跃步从家族取用 |
| H5 | 严格性所引见证没有上升；P10 的更新是净上升，看不见同步的更新，`Garden` 不满足 `Paid` | 严格性改引 `Tide.renewal_without_arising`：潮水由月亮更新，在任意晚的步上升，而没有任何生起；`Commons` 改述为“依存保持，没有生起”。写明 `Rises` 是净上升，同步的补充看不见（`Garden.undepleted`）。流的形式成为定理：在平衡的流中，取用的形成在任意晚的步生起时，家族在任意晚的步得到补充（`replenishment_recurs`），补充者在任意晚的步出现（`renewing_recurs`）。`Garden.growers_take` 与 `Bloom.takes` 表明两者都满足这一前提 |
| H6 | “任何有限部分都不能独自不息”需要耗散前提：封闭循环的有限家族可以不息（`Recycle`） | `conserved_ceases` 改为 `dissipation_ceases`，对任意从不上升的量陈述：若每次生起都使它下降（耗散），生成不是不息的。写明三点：家族的总水平只在每次生起都使它下降时是这样的量，并预设各条件的单位可公度；物质循环不满足这一前提（`Recycle.closed_unceasing`）；对每次生起都耗散的量（例如自由能），前提是物理的，不是定理的推论。四处散文改写 |
| H7 | `Arises` 被称为“生生的第二个生”，`Growth` 被称为“以消耗进行的生成” | `Arises` 改述为“生起（变为活跃），生生第二个‘生’的一种读法的形式载体（作者的读法）”；“以消耗进行的生成”改为“以消耗为条件的生起”。记录写明：在继续的层面，这与 Ren 所说的生成与退化不重叠相合（作者的读法）；在单个事件的层面，`Arises` 包括以消耗为条件的生起。第二个“生”的范围留给 Ren |
| H8 | “严格的层级”作为蕴含不成立：不止地更多不蕴含不息（`more_without_arising`） | 两处都做。其一，新模块 `Becoming.Population` 证明 `Flow.More.unceasing`：在活跃形成的普查之下，流的 `present` 每步每个形成只列一次，只有活跃的形成取用（`Flow.Taking`），不止地更多就蕴含不息的生成。`Bloom.counted` 满足这些前提，不息而不更多，所以这一蕴含是严格的。前提各有作用：没有普查（`Dormant`）或没有 Taking（`Inactive`）时，不止地更多与“没有任何生起”同时成立。其二，散文改为：三者各自所需的补充构成严格的层级（任意晚、没有最终的界）；三者本身只在所述对应之下按蕴含排列 |
| H9 | `More` 数的是流中的取用者，不是活的或依存的形成（`more_without_living_takers`、`Crowd`） | 加对应前提 `Flow.Taking`：只有活跃的形成取用，并且只从它汲取的条件取用。其逆，即每个汲取者都在流中取用，是应用义务；`Crowd.drawing_without_taking` 表明它可以不成立。“更多的形成依赖同一组条件而活”改为“更多的形成从同一组条件取用”。Taking 之下，取用者是活跃的、汲取的形成；“活”是否读作 living 的某种读法，没有选定 |
| H10 | 每个取用者至少取一个单位，是未点明的前提 | 写入记录、§14 与章节：取用的量是自然数，所以每个取用者每步至少取用一个单位（取用有正的下限）。取用可以无限变小时，更多的取用者不需要更多的补充（论证，未形式化：核心只有自然数） |
| H11 | “给予者越来越多”强于定理（`Pulse`） | 两处都做。`Pulse.pulsed` 成为定理：补充者的数目没有最终的界，同时可以在无穷多步上为零。平均的形式也成为定理。`Balances.replenished_over`：在任意一段至少 K 个形成取用的步上，家族所得的补充每步至少 K，减去开始时的存量。`Balances.renewers_over`：每个形成给予有限时，补充者的数目在同一平均意义上增长。`More.replenishment_unbounded` 现在由前者推出。“越来越多”只在这一平均意义上保留 |
| H12 | “没有一个有限的部分独自承担”在封闭循环中不成立（`Cycle`） | 删去，并写明它需要耗散前提：每次给予都使给予者的条件付出多于所给。这一前提此处未陈述。`Cycle.closed_more` 成为定理：每个形成归还所取，总量不变，生成不止地更多，补充者恰是取用者。结构读法的边界加上“补充者可以就是取用者自身” |
| H13 | 纯净核心中出现 Ren 已纠正过的支付与账目用语 | 按审查的建议改名，名称最终由 Ren 定：`Paid`→`Depletes`，`paid_finitely`→`depletes_finitely`，支付前提→消耗前提，“生成不是无代价的”→“在没有补充之步，生起时家族中某个条件下降”，`ledger`→`Balances.over`（消耗与补充的平衡），`load`→`uptake`（取用），`supply`→`replenishment`（补充），给予者→补充者。`renewers` 与 `takers` 保留。包的 README 列出全部改名 |
| H14 | 形成与条件分为两类，省略了“生作为生的条件” | 写入结构读法的边界：在 `Web` 与 `Flow` 中形成与条件是两类，一个形成本身作为另一个形成的条件（生作为生的条件）只能经由代理条件表示。这是表示所省略的关系，不是反驳；P14 以一类关系项读出它（§18） |

### 15.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Dependence | `Web.MetAbove`、`Web.MetAbove.now`；`UnderminingOn`（修正） | 依存在不间断成立的某步以那时的所需被满足，且那时的所需大于给定的水平；侵蚀即汲取之后水平低于某个这样的所需，也低于现在的所需 |
| Dependence | `Stunted.web`、`Stunted.stunting_undermines` | 所需从 1（被满足）增长到 2（从未被满足）；汲取把水平取到 0，不断裂，而侵蚀 |
| Return | `UnderminingFor`、`undermining_for_zero`（修正） | 周期读法经同一最小形式；零步内，对任何有依存者的条件的汲取都侵蚀 |
| Joint | `determined_dichotomy` | 动作决定步骤、在扣除后可取，依存在那里仍成立并被满足时：或者那一部分造成差别，或者同一动作仍断裂依存 |
| Generation | `Depletes`、`rises_or_still`、`depletes_iff`、`depletes_finitely`（改名） | 消耗前提及其内容：事件的每一步家族中有条件变化 |
| Generation | `dissipation_ceases` | 一个从不上升、每次生起都使它下降的量，使生成不是不息的 |
| Generation | `Tide.unrelated_depletion`、`Tide.renewal_without_arising` | 不依存、不汲取的闪现者不息地生起，每次都由无关的潮落满足消耗前提；没有闪现者时，潮水由月亮更新，在任意晚的步上升，没有任何生起 |
| Generation | `Recycle.closed_unceasing` | 一个单位在两个池之间循环，家族的总水平恒为一，全部前提成立，生成不息 |
| Generation | `Bloom.arises_on_rise` | 开花只在条件被恢复之时生起，即在上升之步 |
| Flow | `Taking`、`ArisesTaking` | 只有活跃的形成取用，且只从它汲取的条件取用；形成跨某步生起，并在其第一个活跃步从家族取用 |
| Flow | `replenishment_recurs`、`renewing_recurs` | 取用的形成在任意晚的步生起时，家族在任意晚的步得到补充，补充者在任意晚的步出现 |
| Flow | `Balances.replenished_over`、`Balances.renewers_over` | 补充与补充者数目的平均下界 |
| Flow | `Garden.growers_take`、`Garden.undepleted` | 花园满足 Taking 与流的形式的前提；它的水平从不上升，不满足净上升意义上的消耗前提 |
| Flow | `Bloom.takes` | 开花满足 Taking，并在其第一个活跃步取用 |
| Flow | `Cycle.closed_more` | 每个形成归还所取：总量不变，不息并且不止地更多，补充者恰是取用者 |
| Flow | `Pulse.pulsed` | 不止地更多，每个形成至多给予一单位，而在每个奇数步没有补充者 |
| Population | `Census`、`arises_of_more`、`unceasing_of_growth` | 每步活跃的形成列成不重复的表；活跃的形成变多时有形成生起；普查无界增长使生成不息 |
| Population | `Flow.More.unceasing` | 在普查之下，`present` 不重复、只有活跃的形成取用时，不止地更多蕴含不息的生成 |
| Population | `Bloom.counted`、`Dormant.more_without_arising`、`Inactive.more_without_arising`、`Crowd.drawing_without_taking` | 蕴含是严格的；没有普查或没有 Taking 时不成立；Taking 的逆可以不成立 |

### 15.3 审查列出的会改变判断的结果

1. 最小形式：完成（H1）。G1 关闭。
2. 把消耗系于生起的形成，或以流的形式重述 P10：以流的形式完成（`ArisesTaking`、`replenishment_recurs`），“不息的生成需要更新”覆盖 `Garden`（H4、H5）。
3. 耗散：前提写明，`dissipation_ceases` 对任意量陈述（H6、H12）。每次给予都使给予者付出多于所给的耗散流定理，开放。
4. 在普查对应下证明 `More → Unceasing`：完成（H8）。
5. Taking：完成（H9），其逆是应用义务。
6. 最小取用：写为前提（H10）。有理数量与下限的版本开放。
7. 平均的“越来越多”：完成（H11）。
8. 改名与 H14 的边界句：完成，名称最终由 Ren 定（H13、H14）。
9. Ren 对第二个“生”与“更多”的范围的选择，以及对以消耗为条件的生起是否为生成的原话：属于 Ren（H7、H9）。

### 15.4 作者反审

*反驳 1：最小形式又一次只是让定义合乎散文。* 它修正的是 P9b 未披露的代价。最小形式保留 P9b 的三个排除，并计入 `Stunted`。它仍是一个选择：只低于增长到从未被满足的所需，不算侵蚀（`RisingNeed`）。一个所需增长的幼体，在一次汲取后若仍不低于它曾被满足的所需，这次汲取不被扣下。这一选择是公开的。

*反驳 2：流的形式只是“取用为正，所以补充复现”，生起只是标出步。* （P12b 更正。原文写作“部分对”，并说 `ArisesTaking` 的内容正在于生起与取用的联系。）对：生起只经由它带来的取用起作用；`ArisesTaking` 把生起与取用连起来，使定理可以读作关于生成的定理，但定理所用的只是取用（`uptake_needs_replenishment`；恒定的取用者、没有任何生起，同样需要补充复现，`Steady`）。若不把取用系于生起的形成，生起只标出步，`Tide` 就是这样。它是对应前提，`Garden` 与 `Bloom` 满足它；一个不从家族取用的生起者，例如一个更新者，不受它约束。

*反驳 3：普查是强前提，实际展开中活跃的形成未必有限。* 对。`Dormant` 表明它的作用：没有普查时，一个从开始就活跃的无穷群体可以实现不止地更多而没有任何生起。普查读作：在所论的区域中，每步活跃的形成有限，并且能被列出。它是对应前提，不是定理的推论。

*反驳 4：把 `Paid` 改名为 `Depletes` 只是换词。* 换词依 Ren 对基础用语的纠正，而审查指出原名把一个普遍的正代价呈现为关于生成的事实。实质的部分是：`depletes_iff` 照实说出前提的内容；系于生起形成的版本在流的形式中。

*反驳 5：既然更多在对应之下蕴含不息，为什么还说“三者各自所需的补充构成层级”，而不直接说“三者构成蕴含的层级”？* 因为两个蕴含的前提不同。更多蕴含不息，需要普查与 Taking。不息蕴含补充复现，需要 `ArisesTaking`。复现的更新不蕴含不息（`Tide`）。没有一组前提把三者同时排成一条链，所以只在所述对应之下说蕴含。

**边界。** 不改变读法选择的地位；不推出责任、义务或任何排序；新名称是建议；探针与新见证都是最小见证。本节的更正经第五次独立审查，见 §19。

## 16. 跨步的同一：改名、改认与接续（P12）

2026-10-09。开放纲领“动态依存”一行把形成的个体化列为下一步；`Becoming.Dependence` 的说明也写明，形成跨步的同一由索引类型 `F` 规定，一个形成转化还是一个终结而另一个形成，取决于这一规定。本节证明这一规定在哪些读法中起作用，在哪些读法中不起作用，以及活动与依存的连续能把它确定到什么程度。成果记录：[identity-across-steps](../../../../theories/becoming/results/records/identity-across-steps.md)。

依存网用固定的索引类型给形成命名，所以一步的哪个形成与下一步的哪个形成相同，是由名字规定的；每一步的关系并不确定它。**改认**（`Reidentify`）在每一步把两种命名一一对应。改认之后的网在每一步有相同的水平、活动、依存与汲取，不同的只是哪一步的哪个形成延续前一步的哪个。每一步都相同的改认是**改名**。分裂与合并（一个形成延续为几个，或几个延续为一个）不是改认：它们改变延续关系，不改变任何一步形成的数目（P12b 更正；原文写作“分裂与合并改变形成的数目”）。§19 以延续关系表示它们。

```text
Result(s): 复用 becoming-dependence-dynamics（依存网、支持、保持、断裂、任期、侵蚀、形成与消解）、
           unceasing-generation-needs-renewal（生起、不息、Depletes）、more-needs-renewers（流、取用者、更多、普查与 Taking）；
           新增 identity-across-steps（L3）
Delta: 改名保持追随形成的读法（P12b 更正：检查了五种，原文作“全部读法”）；任何改认保持每一步的关系、每个条件的类、Dependent、每个事件是否在更新之内与是否断裂，
       以及流的取用与给予、取用者与补充者的数目、“更多”、活跃形成的普查与 Taking，所以在普查之下，更多在每个改认下蕴含不息；
       只改动谁延续谁，形成的类、侵蚀、转化与生起都改变；
       保持持续活动的改认不制造生起，保持持续依存的改认不去掉侵蚀；它们仍可把终结者与开始者接起来（接续），接续可以隐藏生起、增加侵蚀
Supplied premises / correspondence: 改认在每一步一一对应；连续读作活动与依存跨步持续时名字不变；
       接续怎样读不由本节给出
Evidence: Becoming.Identity 的定理；合并检查器回执（见记录）
Boundary: 不含伦理谓词；不处理分裂与合并；连续是一种同一的读法，不是同一的定义
Integration: 开放纲领“形成的个体化”部分承接；逐步读法与不息的边界由此陈述
```

[Becoming.Identity](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Identity.lean)（L3）：

| 声明 | 内容 |
|---|---|
| `Reidentify`、`Reidentify.rename`、`Web.reidentify`、`Flow.reidentify` | 两种命名在每一步一一对应；改名在每一步相同；改认后的依存网与流 |
| `reidentify_step`、`reidentify_renewed`、`reidentify_consumed`、`reidentify_lost`、`reidentify_dependent`、`reidentify_renewingAt`、`reidentify_breakingOn` | 任何改认都保持：每一步的支持、保持与断裂；每个条件的类（被更新、被消耗、失去）；活动是否需要支持；每个事件是否在更新之内、是否断裂 |
| `reidentify_amounts`、`reidentify_balances`、`reidentify_counts`、`reidentify_more` | 改认一个流，保持每步的取用与给予、消耗与补充的平衡、取用者与补充者的数目，因而保持不止地更多 |
| `Reidentify.new_injective`、`Reidentify.mem_map`、`mem_map_of`、`mem_of_map`、`distinct_map`、`Web.Census.reidentify`、`Flow.Taking.reidentify` | 改认保持活跃形成的普查（每步不重复地列出）与“只有活跃的形成取用，且只从它汲取的条件取用” |
| `Flow.More.unceasing_reidentified` | 在普查、present 不重复与 Taking 之下，不止地更多在每个改认下蕴含不息 |
| `rename_renewingIn`、`rename_consumingIn`、`rename_tenure`、`rename_undermining`、`rename_unceasing` | 标签不承载任何东西（P12b 更正，原文作“名字”）：改名保持形成的类、依存的任期（`MetAbove`）、侵蚀、形成与消解、生起与不息 |
| `Turnover.identified`、`Turnover.reidentified` | 每一奇数步交换名字，每一步的关系不变：一个形成更新、一个消耗，变成没有形成更新、两个消耗；汲取者在每一步侵蚀，变成第一步之后没有任何事件侵蚀；没有依存形成或消解、没有生起，变成一个形成跨第一步转化依存、每一奇数步都有形成生起，生成不息。这些生起不降低任何条件，`Depletes` 不成立。两个网中活动都只在有支持处 |
| `KeepsActive`、`KeepsTenure`、`Reidentify.steady` | 改认保持跨一步持续活动的形成的名字；保持跨一步持续依存于某条件的形成的名字。后者使一个形成在一段任期上只有一个名字 |
| `arises_of_keepsActive`、`unceasing_of_keepsActive` | 保持持续的活动，改认不制造生起：新名字下生起的，在旧名字下也生起；因而不制造不息 |
| `metAbove_of_keepsTenure`、`undermining_of_keepsTenure` | 保持持续的依存，改认保持在任期中满足过的依存，不去掉任何侵蚀 |
| `Lineage.readings` | 一个谱系的两个成员在交替的步活跃。分开命名，成员不息地生起；作为一个命名，谱系始终活跃，没有生起。合为一个命名保持持续的活动，因为没有成员在相继两步都活跃 |
| `Succession.readings` | （P12b 更正：原见证的继承者从不活跃，从第二步起需要池而从未被满足。）长者在第一步需要池；继承者在第二步活跃并以一单位被满足，自第三步起需要两单位，活动需要支持。分开命名，汲取者只在第一步侵蚀（断裂长者的依存）；继承者接续长者时，长者的任期在继承者中延续，汲取者自第三步起每一步都侵蚀。接续保持持续的活动与依存 |

**解读。**

- **标签不承载任何东西；名字跨步的模式承载同一。** （P12b 更正。原文写作“名字不承载本体。改名保持全部这些读法……这是方法要求‘不能以分别命名偷渡独立本体’在这一表示中的一个检查”。）改名保持由关系定义的这些读法（检查了五种）：标签的选择不起作用。名字跨步的模式承载同一：这是表示给出的对应前提，`Turnover` 表明它是实质的。方法要求“不能以分别命名偷渡独立本体”在这里的检查是这一披露，不是改名不变，因为改名按构造保持这一模式。
- **每一步与每个条件只由关系确定。** 支持、保持与断裂、条件的类、每个事件是否在更新之内，都只依赖每一步的关系，不依赖跨步的同一。消耗读的是一个依存在它成立时的样子，对照条件以后的水平；它不追随形成。“更多”读的是每步取用者的数目，也不依赖。在普查与 Taking 之下，它所迫使的不息在每种一对一的同一读法下也不依赖（`More.unceasing_reidentified`）：不息本身依赖同一（`Turnover`、`Lineage`），由“更多”迫使的不息却不依赖一一对应的命名。原因在 `arises_of_more`：下一步活跃的形成多于这一步时，无论怎样一一对应地命名，总有一个名字在这一步不活跃而在下一步活跃，数目的增长不能由改认吸收。（P12b 补充：在把新形成读作从既有形成萌出的读法下，数目的增长由分裂吸收；没有分裂时它仍迫使生起，见 §19。）
- **追随形成的读法依赖同一。** 形成在整段上的类、依存的任期（因而侵蚀与逐步读法的 `living`）、转化与“一个终结而另一个形成”的区别、生起（因而不息），都依赖跨步的同一。`Turnover` 只改动谁延续谁，这些就全部改变。所以 §5 中“分类属于运行，不属于形成自身的轨迹”还要补一句：形成的类还依赖哪些事件属于同一个形成。
- **连续排除什么，留下什么。** 把同一读作活动与依存的连续：跨一步持续活动的形成保持名字，跨一步持续依存的形成保持名字。这样的改认不制造生起，也不去掉侵蚀。它仍可以把在某步终结的形成与在该步或其后开始的形成接起来：开始者是否延续终结者，是接续的问题。接起来可以隐藏生起（`Lineage`），也可以增加侵蚀（`Succession`）。（P12b 更正。原文写作“两个定理各有一个方向，反方向的反例恰是接续”。）两个条件以旧命名为参照，是单向的：新命名可以制造连续（接起来），不能去掉连续（`Lineage.one_way`、`Succession.one_way`）。两向保持连续时，生起与侵蚀恰被保持；接续开放，是因为连续取单向的读法。两向保持连续，跨过休眠之步的接续仍改变形成的类（`Dormancy`）：连续不约束形成在整段上的类。
- **对生生的意义（AI 论证）。** （P12b 更正。原文把谱系的持续与成员的生起写成二选一，并说读作谱系的持续时“落在维持与更新上”；`Lineage` 没有任何条件，后一句没有见证。）谱系与成员是同一展开的两个层次：作为整体的谱系持续，正由成员不息地生起而成（`Layered`）；单一命名层次只能表示其一，部分与整体的关系是这一表示所省略的关系。把“生生不息”读到谱系、成员或两者的层次，不由每一步的关系决定；只读作谱系的持续，与 Ren 原话中的“不断创造”有张力。继承者是否继承长者的损失，决定此后的汲取是否侵蚀；这触及工作读法“不侵蚀”的一个选择：一个依存的任期能否经由接续延续。这两个选择属于 Ren。
- **对 P10 的影响。** `Unceasing` 依赖同一；在 `Turnover` 中，改认单独制造了不息。§13 的 `Unceasing.rises` 不受影响：它的结论（家族中某个条件在任意晚的步上升）只关乎条件，不依赖同一；（P12b 更正。原文另给第二个理由：`Turnover` 中单由改认制造的生起不降低任何条件，`Depletes` 不成立，定理不适用。那只是 `Turnover` 的性质。）`Depletes` 不系于生起的形成，不筛掉命名的产物：单由命名造成的生起可以满足全部前提（`TideFlip`）。定理不受影响，是因为结论只关乎条件；它的前提 `Unceasing` 依赖同一，要把它读作关于生成的定理，需要命名保持持续的活动（`arises_of_keepsActive`）。

**作者反审。**

*反驳 1：改名不变是平凡的。* 对按关系定义的谓词，改名不变是一条元定理：可定义的性质在同构下不变。这里在 Lean 中逐项检查，并与改认对照；值得注意的是改认改变什么、不改变什么。

*反驳 2：`Turnover` 的改认是荒谬的，没有人会这样认同。* 对：它破坏了活动与依存的连续。它只表明每一步的关系不决定同一。连续的定理说明，排除这类改认后剩下的是接续，包括跨过休眠的接续（P12b 更正；原文作“剩下的只有接续”）；而 `Lineage` 与 `Succession` 中的接续不荒谬：谱系、继承者、同一生态位上的接替都是实际的情形。

*反驳 3：改认要求每一步的形成一一对应，排除了分裂与合并。* 对。（P12b 更正。原文写作“分裂与合并改变形成的数目”。）分裂与合并不改变任何一步形成的数目，改变的是延续关系；本节只处理一一对应的延续，§19 以延续关系表示分裂与合并。

*反驳 4：把同一读作连续，是否预设了同一？* 连续在这里只用到每一步的关系与名字：一个形成在相继两步都活跃，或都依存于某条件。它不定义同一，只约束改认：在约束之下，改认不再能制造生起或去掉侵蚀，接续仍由读法决定。

*反驳 5：普查下的结论是不是只把同一换成了计数？* 是，这正是它的内容：“更多”只读每步的数目，普查把数目的增长与生起连起来。它不说哪个形成生起，只说总有某个形成生起；在 `Lineage` 那样数目不增长的展开中，它什么也不说。

**边界。** 不含伦理谓词；改认只处理每步形成一一对应的情形；连续是作者提出的一种同一的读法，不是同一的定义；接续怎样读、工作读法“不侵蚀”是否让任期经由接续延续，属于 Ren 的读法选择；从关系推出同一的完整说明（例如物质、信息或组织的连续）没有给出。本节经第五次独立审查，更正见 §19。

## 17. 耗散：复现的取用打开有限家族（P13）

（P16c 更正标题，原题“耗散：没有有限部分独自承担持续的取用”；见 §23 K1。）

2026-10-09。按同一指示继续。§14 的 `Cycle` 表明补充者可以就是取用者：封闭循环中每个形成归还所取，生成不止地更多。第四次独立审查（H6、H12）指出，“任何有限部分都不能独自不息”与“没有一个有限的部分独自承担”需要耗散前提；§15 把它们标为未陈述的前提。本节在流上陈述耗散，并证明它承担什么。成果记录：[no-finite-part-bears-taking](../../../../theories/becoming/results/records/no-finite-part-bears-taking.md)。

```text
Result(s): 复用 more-needs-renewers（流、平衡、取用者、补充、More、ArisesTaking、Cycle、Distinct）、
           becoming-renewal-reading（falls_finitely）、becoming-finite-horizon（le_of_add_le_add_right，只作算术）；
           新增 no-finite-part-bears-taking（L3）
Delta: 封闭（ClosedAt）与耗散（DissipatesOn、Dissipative）；平衡的流中，被耗散的家族跨一步至少下降其取用者的数目（runs_down），
       从某步起被耗散，此后取用者的总数不超过当时的存量（takers_within），取用不再复现（taking_ceases）；
       在耗散之下，取用在任意晚的步复现的有限家族，连同包含它的每个不重复的有限家族，在任意晚的步都不封闭（Dissipative.opens）；
       不止地更多与取用者的不息生起都是这样的取用（More.opens、opens_of_arising）；条件总共有限时，取用不再复现（finite_ceases）；
       Frontier 满足全部前提并且不止地更多
Supplied premises / correspondence: 流平衡依存网；耗散：每一步，每个在该步封闭的不重复家族上，每个参与的形成给予家族的不多于从家族所取，
       取用时更少；量是自然数，单位可公度；耗散是物理前提，不是定理
Evidence: Becoming.Dissipation 的定理；合并检查器回执（见记录）
Boundary: 只约束流中的取用，不约束不取用的生起（Tide 的闪现者）；“有限部分”指有限的条件家族，不是有限的形成集合；不含伦理谓词
Integration: 陈述第四次审查 H6、H12 所要求的前提；§13 的 dissipation_ceases 在依存网上陈述耗散，本节在流上陈述
```

[Becoming.Dissipation](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Dissipation.lean)（L3）：

| 声明 | 内容 |
|---|---|
| `Flow.ClosedAt`、`Flow.DissipatesOn`、`Flow.Dissipative` | 封闭：一步中没有参与的形成与家族之外的条件交换。耗散于家族：每个参与的形成给予家族的不多于从中所取，取用时更少。耗散的流：每一步，每个在该步封闭的不重复家族都被耗散 |
| `DissipatesOn.replenishment_takers`、`Balances.runs_down` | 被耗散时，家族的补充加取用者的数目不超过其取用；平衡的流中，家族跨一步至少下降其取用者的数目 |
| `Balances.takers_within`、`Balances.taking_ceases` | 从某步起被耗散，此后任一段步上取用者的总数不超过当时的存量；从家族的取用不再复现 |
| `takers_pos_of_sub` | 从一个家族取用的形成，也从包含它的每个家族取用 |
| `Dissipative.opens`、`More.takers_recur`、`takers_recur_of_arising`、`More.opens`、`opens_of_arising` | 在耗散之下，取用在任意晚的步复现的有限家族，连同包含它的每个不重复的有限家族，在任意晚的步都有参与的形成与其外的条件交换。不止地更多，以及在第一个活跃步取用的形成的不息生起，都是这样的取用 |
| `Dissipative.finite_ceases` | 若有限个条件就是全部，在耗散之下，从任何家族的取用都不再复现 |
| `Frontier.balances`、`Frontier.dissipative`、`Frontier.more`、`Frontier.frontier` | 太阳每步燃烧一份新的燃料，给池的少于所燃，越来越多的生长者从池取用：流平衡、耗散、不止地更多。所以包含池的每个有限家族在任意晚的步都不封闭，太阳所燃的燃料不在任何有限家族之内 |
| `pos_of_sign`、`sign_pos`、`eq_zero_of_not_pos`、`le_total_of_mem`、`total_eq_zero`、`total_le_at` | 有限和的辅助引理 |

**解读。**

- **耗散把要求传到每个有限部分之外。** 没有耗散，一个有限家族可以封闭地维持不止地更多（`Cycle`）。有耗散，任何有限家族，若取用在其上复现，都在任意晚的步与其外交换，包含它的每个有限家族也如此。这一交换可以与家族无关（`SprayHanding`）；家族从某步起被围住时，它汲入：在任意晚的步，有形成给予它而从其外取用（`taking_draws_in`）（P16c 更正，原文“所以持续的取用不由任何有限的条件家族承担”）。这把 §13 与 §14 中作者的论证“在耗散之下，任何有限部分都不能独自不息”变为定理，范围是流中的取用。
- **定量的界。** 被耗散的家族上，此后全部的取用事件不超过当时的存量（`takers_within`）：存量是取用能持续多久的上界。
- **物质可以循环，驱动循环的不能（AI 论证）。** 用自由能读耗散：物质在一个有限家族中可以封闭地循环（`Cycle`），驱动循环的自由能若被耗散，就需要越出每个有限家族的来源。`Frontier` 中太阳每步烧一份新燃料，表示一个没有尽头的来源；实际的来源是否如此，是经验问题。若有限个条件就是全部，取用终将停止（`finite_ceases`）。
- **与 §13 的关系。** `dissipation_ceases` 陈述在依存网上：一个量从不上升而每次生起都使它下降，生成就不是不息的。本节陈述在流上：耗散在每个封闭家族上成立，于是取用不再复现，除非与家族之外交换。两者都需要耗散前提；没有它，封闭循环可以不息并且更多。
- **对生生（作者的读法）。** Ren 的原话是“生生不息 - 一种整体的，不断创造更多生的方向”。在耗散之下，复现的取用，无论来自不止的更多、生成还是维持，使它复现的有限条件家族在任意晚的步不封闭，家族被围住时须从其外汲入：维持一个恒定的取用者已经如此（`Lone`，`Lone.draws_in`）（P16c 更正，原文“都不能由任何有限的条件家族独自承担，只能由越出每个有限部分的展开承担”；耗散空成立时，家族可以独自承担取用，见 §23 K1）。作者把这读作原话中“整体”的一种形式内容；不断的更多是其中的一种情形，不是它的全部内容（P16b 更正，原文只说不断的更多）。这是作者的诠释，不替代 Ren 的原话，也不推出它是好的。

**作者反审。**

*反驳 1：`Dissipative` 太强，排除了任何“免费”的补充者。* 只在有封闭的有限家族的步上如此（P16b 更正；原文“对，这正是前提的内容：补充者的代价须表示为它所取的条件”）。`Dissipative` 只约束在某步封闭的不重复家族；某个形成在一步中与无穷多个条件交换时，没有家族封闭，耗散对那一步什么也不说，补充者可以什么都不取而给予（`Spray`）。在有封闭的有限家族的步上（`Enclosed`；条件总共有限时每步都是），给予的形成在封闭家族上取得多于所给（`gives_less`），给予须以取用为条件（`giving_needs_uptake`）：太阳的燃料、植物所取的光都要作为条件出现。§14 的 `Garden` 与 `Bloom` 省略了来源，不满足 `Dissipative`（`witnesses_not_dissipative`，连同 `Cycle`、`Pulse`、`Steady` 与 `Repeated`）；那是表示所省略的关系，不是没有关系。另一方面，结论“在任意晚的步不封闭”可以由与家族无关的交换满足（`Spray` 的汇）。

*反驳 2：耗散只对某些量成立，例如自由能，对信息或组织不一定成立。* 对。本节只说：对满足耗散的量，持续的取用需要越出每个有限家族。信息的复制、组织的维持是否耗散，是对应问题；`Cycle` 表明不耗散的量可以封闭地循环。

*反驳 3：结论只约束取用，不约束生起。* 对。不取用的生起（`Tide` 的闪现者）不受约束；`opens_of_arising` 只说在第一个活跃步取用的形成的不息生起。（P15 补充：生起的关系项体现时，它的生起本身就是补充，在耗散之下同样使它复现的有限家族不封闭，家族被围住时汲入，见 §20；P16c 更正，原文“同样须与有限家族之外交换”。）（P16b 补充：`Frontier` 的生长者不依存于任何东西；`Rooted` 让它们以需要一依存于池，普查、`Dependent` 与不息同时成立，是 `opens_of_arising` 的见证。）

*反驳 4：“没有有限部分”是否等于需要无穷多条件？* 在形式上是：`Frontier` 用无穷多燃料，`finite_ceases` 说条件总共有限时取用不再复现。若实际的展开在这一意义上是有限的，定理说取用终将停止。把它与物理的热寂相比，是作者的类比，不是物理定律的证明。

*反驳 5：为什么要求家族不重复？* 列表重复同一条件时，量被重复计数，耗散可以被虚假地违反；`Dissipative` 只对不重复的家族陈述，`Frontier` 对每个这样的家族都证明了它。

**边界。** 不含伦理谓词；耗散是物理前提，单位可公度，只约束有封闭的有限家族的步（`Enclosed`，P16b 补充）；结论只约束流中的取用；“有限部分”指有限条件家族；表示中形成与条件仍是两类（§15，H14；一类关系项的读法见 §18，耗散之下见 §20）；`Frontier` 是最小见证。本节经第六次独立审查，更正见 §22。

## 18. 角色：生作为生的条件与经由给予的生起（P14）

2026-10-09。按同一指示继续。§1 写明“形成”和“条件”是同一展开中的分析角色，不是彼此独立的实体，但 `Web` 与 `Flow` 把它们表示为两个类型。第四次独立审查（H14）指出，这省略了“生作为生的条件”：父母之于后代、森林之于林下、群落之于学习者，只能经由代理条件表示；§15 把它写为表示所省略的关系。按非二元方法（先说明同一展开中的关系怎样形成、持续和改变，再说明行动者与承受者怎样在其中分化），本节把形成与条件读作一个关系项的两种角色，并证明这一读法承担什么。成果记录：[life-as-condition-of-life](../../../../theories/becoming/results/records/life-as-condition-of-life.md)。

```text
Result(s): 复用 becoming-dependence-dynamics（Web、支持、Dependent、更新、消耗、断裂、侵蚀、renewing_at_active）、
           unceasing-generation-needs-renewal（Arises、Unceasing、RenewedBy）、
           more-needs-renewers（流、平衡、Acting、取用者、补充者、More、Balances.renewedBy）、
           condition-correspondence-discipline（Interacts、interaction）、metaethical-core-characterization（Valuation、significant_iff）；
           新增 life-as-condition-of-life（L3 Becoming.Roles；L4 Becoming.Correspondence 新增一节）
Delta: 一类关系项的读法（Web.roles、Flow.roles）保持列出的全部读法与两种估值的连通，其中曾活跃的形成既不体现也不承担自身；
       体现（Embodied）与承担自身（SelfBearing）；在 Dependent 之下，依存于体现关系项的形成只在它活跃时活跃（active_of_bearing），
       活动沿依存链传递（active_along），不活跃的关系项终结每个依存链到达它的形成（coextinct）；
       在需要为一时消耗体现的关系项即终结它（ends_when_consumed）；在承担自身的体现关系项终结之步汲取它是断裂（ending_breaks）；
       在平衡且只有活跃形成给予的流中，体现的关系项只经由另一个活跃形成的给予而生起（arises_given）；
       汲取承担自身的关系项与它的每个活跃事件相互作用（SelfBearing.interacts）；Mutualism、Predation、Brood
Supplied premises / correspondence: Embodied、SelfBearing 与 Dependent 是对具体关系项的表示前提；arises_given 需要平衡与 Acting；
       估值的结果用逐步读法的 living 与公开的相互作用纪律
Evidence: Becoming.Roles 的 54 项定理与 Becoming.Correspondence 新增的 9 项定理；合并检查器回执（见记录）
Boundary: 遗骸与不活跃的条件不体现；一类读法不保持 Acting、Taking 与 Dissipative 的陈述（P16b 更正：不成立，它们也保持，见 §22）；
          Brood 只给予不取用；不含伦理谓词
Integration: 回答第四次审查 H14；§14、§15 与 §17 中“形成与条件是两类”的边界改为指向本节
```

[Becoming.Roles](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Roles.lean)（L3）与 [Becoming.Correspondence](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Correspondence.lean) 新增的一节（L4）：

| 声明 | 内容 |
|---|---|
| `Web.roles`、`Flow.roles` | 以一类关系项读出的依存网与流：一个形成在零水平上作为条件，没有谁依存、汲取、从它取用或向它给予；一个条件从不活跃，不依存、不汲取、不取用也不给予 |
| `roles_supported`、`roles_dependent`、`roles_renewed`、`roles_renewed_formation`、`roles_consumed`、`roles_renewingIn`、`roles_consumingIn`、`roles_undermining`、`roles_arises`、`roles_unceasing`、`roles_alive` | 一类读法保持支持、`Dependent`、条件的更新与消耗、形成的类、侵蚀、生起、不息与逐步读法的 living；作为条件的形成没有谁依存，所以被更新 |
| `roles_taken`、`roles_given`、`roles_taken_formation`、`roles_given_formation`、`roles_balances`、`roles_takers`、`roles_renewers`、`roles_more` | 流的一类读法保持取用与给予、平衡、家族的取用者与补充者，以及不止地更多 |
| `roles_event_injective`、`roles_event_onto`、`Valuation.connected_iff_of_map`、`roles_valuation_connected`、`roles_interaction_connected` | 形成的事件与一类读法中活的事件一一对应；共同参与与相互作用两种估值的连通都不变（后三项在 L4） |
| `Embodied`、`SelfBearing`、`SelfBearing.stands`、`roles_not_embodied`、`roles_not_selfBearing` | 体现：恰在活跃时以正的水平作为条件而在。承担自身：活跃时以正的需要依存于自身的水平；在 `Dependent` 之下，于是活跃时作为条件而在。两类读法中，曾活跃的形成既不体现也不承担自身 |
| `Embodied.active_of_bearing`、`bearing`、`active_along`、`coextinct` | 生作为生的条件：在 `Dependent` 之下，以正需要依存于体现关系项的形成只在它活跃时活跃；活动沿这样的依存链传递；一个在某步不活跃的关系项在该步终结每个依存链到达它的形成 |
| `Embodied.ends_when_consumed`、`Embodied.ending_breaks` | 在需要为一时消耗体现的关系项即终结它；在承担自身的体现关系项终结之步汲取它，断裂它自身的依存，不论是否另有形成依存于它，也不论是什么终结了它（P16b 补充，`Wilting`） |
| `Embodied.arises_given` | 经由另一个活跃者的给予而生起：在平衡且只有活跃形成给予的流中，体现的关系项只经由另一个活跃形成的给予而生起；给予它的形成不必体现（P16b 更正，原文“生由生给予”；`SunSeed`；P16c 用语，原文“给予者”） |
| `SelfBearing.interacts` | 汲取承担自身的关系项，与它的每个活跃事件相互作用（L4） |
| `Mutualism.web`、`dependent`、`embodied`、`selfBearing`、`renewing`、`alive`、`connected`、`significant_iff` | 蜜蜂与花各自依存于自身与对方，并汲取对方：彼此更新，每个事件都是 living；没有第三个条件，相互作用读法连通，G0 在那里恰为种子加两项中立 |
| `Mutualism.apart`、`apart_renewing`、`apart_alive`、`apart_not_selfBearing`、`apart_participates`、`apart_not_connected`、`apart_not_interacting` | 各自只依存于对方时，都不承担自身；共同参与与相互作用都不把蜜蜂与花关联起来 |
| `Predation.web`、`breaking`、`hare_ends`、`fox_ends` | 狐依存于自身与兔并汲取兔，兔与自身相依；兔跨第二步终结：狐在兔终结之步的汲取断裂兔自身的依存，所以不是 living（P16b 更正，原文“兔跨第二步被吃”；兔的终结是给定的时程，见证中没有流）；狐随兔一同终结（共灭） |
| `Brood.flow`、`Brood.web`、`Brood.arises`、`Brood.brood` | 一代代形成不止地生起，每一代由前一代给予：流平衡，只有活跃的世代给予，每代体现并承担自身，`Dependent`，生成不息 |
| `total_map`、`total_congr`、`Mutualism.other_cancel`、`Mutualism.other_ne`、`Predation.uneaten_late`、`Brood.grows`、`Brood.standing_self`、`Brood.standing_before` | 有限和与见证的辅助引理 |

**解读。**

- **两类嵌入一类（P16b 更正）。** 以两类陈述的列出的读法，以一类关系项读时都不变，两种估值的连通也不变（`roles_*`）；`Acting`、`Taking`、普查、present 不重复与耗散也不变（`roles_acting`、`roles_taking`、`roles_census`、`roles_distinct`、`roles_dissipative`）。两类读法中曾活跃的形成既不体现也不承担自身（`roles_not_embodied`、`roles_not_selfBearing`）。一类读法另需一个对应：哪个条件就是哪个形成。它由共同的索引给出，是表示的前提，两类读法检查不到它：把条件一侧到上地重新标号，`Dependent`、侵蚀、living 与两种估值的连通都不变，而体现与承担自身改变（`relabel_dependent`、`relabel_undermining`、`relabel_alive`、`relabel_valuation_connected`、`relabel_interaction_connected`、`Mutualism.apart_relabelled`、`Wilting.relabelled_not_embodied`）。体现与承担自身是在这一对应下的读法；两类的表示省略的是形成与条件的同一对应。原文写“所以两类的表示没有引入独立的本体”“它省略的正是体现”，把所给的对应当作了结果，与 §19 的 I7 是同一模式。
- **生作为生的条件。** 在活动需要支持（`Dependent`）之下，依存于体现关系项的形成只在它活跃时活跃，活动沿依存链传递，一个关系项的终结终结每个依存链到达它的形成（`coextinct`）。在生态中，这是专食者与宿主、寄生者与寄主的共灭；种子库、储备与休眠被 `Dependent` 排除，在它们之下共灭不必成立（P17 补充：`Dependent` 是零储备，有储备时共灭推迟而不消失，见 §24）。
- **经由另一个活跃者的给予而生起（P16b 更正，原题“生由生给予”）。** 在平衡且只有活跃形成给予的流中，体现的关系项只经由另一个活跃形成的给予而生起（`arises_given`）。定理不要求给予它的形成体现、承担自身或依存于任何东西：一个不体现、不依存的太阳可以是唯一给予种子的关系项（`SunSeed`）（P16c 用语，原文“给予者”）。所以它说的是一个体现关系项的生起由另一个活跃者的给予给出，不是由另一个体现关系项给出（P18b 用语，原文“一个生命的生起”“另一个生命”）。在只有体现的关系项给予这一表示前提下，给予它的关系项也体现，并在给予时作为条件而在（`arises_from_embodied`；P18b 用语，原文“给予者”）；这是对应，不是定理从平衡推出的。作者曾把“生由生给予”读作 Ren 原话“不断创造更多生”中两个“生”之间关系的一种形式内容（AI 论证）；这一读法需要上述前提，不替代原话，也不推出它是好的。`Brood` 表明前提与不息相容：一代代形成生起，每一代由前一代给予。
- **直接的关系。** 共同参与与相互作用都经由一个条件关联两个事件。各自只依存于对方的互利者，没有共同的条件，于是两种估值都不关联它们（`apart_not_connected`、`apart_not_interacting`）。承担自身时，一个形成对另一个的汲取就与那个形成的活动相互作用（`SelfBearing.interacts`），互利者直接相关，无需第三个条件（`Mutualism.connected`）。所以形成之间是否直接相关，取决于是否表示一个形成承担自身。体现本身不进入两种估值（P16b 补充）：估值只经由共同的条件关联事件；`apart` 中两者都体现、各自依存并汲取对方，仍不相关（`Mutualism.apart_embodied`）。只有承担自身把体现的关系项的活动接到汲取它的事件上；这是估值所省略的关系。一个把汲取者与它所汲取的体现关系项的事件直接关联的估值，是新的结果（P18 补充：以之为生与世系两种候选读法，见 §25）。
- **在一个体现关系项终结之步汲取它（P16b 更正，原题“终结另一个生命”；P18b 用语，原题“在一个生命终结之步汲取它”，本段的“生命”下同）。** 在一个承担自身的体现关系项终结之步汲取它，不论是什么终结了它，是断裂，所以不是 living（`ending_breaks`）；没有谁依存于它时也如此（`Predation` 中兔自身的依存）。这包括旁观的汲取者、自然的终结与该关系项自身的最后事件：花因自身的取用而凋，从不取用的蜜蜂在那一步的汲取，与花自己的最后一个事件，都是断裂（`Wilting`）。在 `Dependent` 与体现之下，自身依存恰在活跃时被满足（`SelfBearing.met_iff`）：它不记录活动之外的任何东西，作用是把终结读作断裂。定理不说汲取终结了它；因果的读法需要反事实的关系（例如 §8 `Joint` 的 but-for 检验），这里没有陈述。若被汲取者不承担自身、也没有谁依存于它，这样的汲取不侵蚀任何东西。是否把在终结之步的汲取计入不 living，以及对哪些汲取者（捕食者、旁观者、该关系项自身），属于 Ren 对生生的读法；本节只陈述两种表示各自的后果。

**作者反审。**

*反驳 1：`Embodied` 太强：遗骸、种子库与休眠的形成在活动之外仍作为条件。* 对。`Embodied` 是对具体关系项的前提，不是对所有关系项；遗骸可以表示为另一个关系项，它与原形成的关系是跨步同一的问题（§16）。

*反驳 2：`SelfBearing` 是否把想要的结论编进表示？* 它只说一个形成活跃时依存于自身的水平；与 `Dependent` 一起，这就是 `Embodied` 的一半（`SelfBearing.stands`）。它使在一个承担自身的体现关系项终结之步的汲取成为断裂（P16b 补充：不论是什么终结了它；P18b 用语，原文“在一个生命终结之步”），这是读法的后果，不是伦理前提；`Mutualism.apart` 与 `Predation` 并列陈述有与没有它的后果，是否采用属于 Ren。

*反驳 3：一类读法的嵌入是平凡的。* 嵌入本身是定义；它的内容是两类读法的每个列出的结果在一类读法中成立。一类读法另加的是形成与条件的同一对应，它由共同的索引给出，两类读法检查不到它（`relabel`），不是嵌入推出的（P16b 更正；原文“而两类读法恰是没有体现的一类读法”）。实质的新结果是 `coextinct`、`ending_breaks`、`arises_given` 与 `Mutualism` 的对照。

*反驳 4：`arises_given` 依赖平衡与 `Acting`。* 对。流不平衡（表示省略了输入）或不活跃者也给予时，结论不成立；省略的来源是表示所省略的关系，不是没有关系。

*反驳 5：`Brood` 只给予不取用。* 对。耗散之下（§17），在有封闭的有限家族的步上，给予须以取用为条件（P16b 用语与范围更正；原文“`Brood` 的给予不付出代价”“给予须付出所取的条件”）；耗散之下的一类读法未陈述。（P15 补充：§20 陈述它，`Brood` 不耗散，`Kindling` 是耗散的对应。）

**边界。** 不含伦理谓词；`Embodied`、`SelfBearing` 与 `Dependent` 是表示前提，哪个条件就是哪个形成由共同的索引给出，也是表示前提（P16b 补充）；遗骸与不活跃的条件不体现；体现不进入两种估值；`arises_given` 中给予的关系项不必体现（P16c 用语，原文“给予者”）；见证都是最小见证。原文“一类读法不保持 `Acting`、`Taking` 与 `Dissipative` 的陈述”不成立，已删去（P16b，J8）。本节经第六次独立审查，更正见 §22。

## 19. 第五次独立审查与更正（P12b）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P11b（§15）与 P12（§16）（[审查](../history/root-foundation/BECOMING-P11B-P12-REVIEW.md)）。它在仓库之外从前导重新编译 19 个核心模块，公理报告为空；回执、哈希与别名都对，数学接受，H1–H14 全部关闭。问题在前提的陈述、散文与对应之间，共十二项（I1–I12），没有数学错误；附无公理的探针。审查没有发现替 Ren 选择接续或 living 的读法；它指出对方法检查的说法过强（I7），以及把单层表示的省略呈现为交给 Ren 的二选一（I10）。本节记录逐项处理。探针的内容作为定理移入相应模块，公理报告为空；审查列出的会改变判断的结果中，没有分裂的延续之下的生起定理（第 6 项）也已证明。§14–§17 中受影响的句子已就地更正并标明；原文见提交 `a739e232`。

```text
Result(s): 修正 identity-across-steps（标题、主张、假设、对应、反例、界限、下一步）、more-needs-renewers、
           unceasing-generation-needs-renewal；becoming-stepwise-reading 与 becoming-renewal-reading 的界限补上对同一的依赖；
           no-finite-part-bears-taking 与 life-as-condition-of-life 只改用语；不新增结果记录
Delta: 流的形式的一般定理：复现的取用需要复现的补充（uptake_needs_replenishment），生起只经由取用起作用（Steady）；
       present 不重复是“更多蕴含不息”的必要前提（Repeated）；全部前提的正面见证（Garden.counted、Cycle.counted）；
       连续分为单向与双向：双向时生起、不息与侵蚀恰被保持，单向时新命名可以制造连续；
       双向保持连续，跨过休眠的接续仍改变形成的类（Dormancy）；命名造成的生起满足 P10 的前提（TideFlip）；
       延续关系读出分裂与合并：没有分裂时更多迫使生起（More.unceasingFrom），萌出时不然（Budding）；
       谱系与成员是两个层次（Layered）；继承者活跃并被满足（Succession）
Supplied premises / correspondence: 新增：双向的连续（Reidentify.back）；延续关系、NoSplit，
       以及“是否延续某个活跃形成”可判定（定理的假设，不是公理）
Evidence: Becoming.Flow 60、Population 33、Identity 77 项定理；
          合并检查器回执 20261009T060305.410034Z（559 项定理／948 项声明审计，核心闭包 21 个模块，公理报告全空）；
          外围桥接 20261009T060407.444723Z
Boundary: 接续的读法、“生生不息”读到哪个层次、任期能否经由接续延续，属于 Ren；Depletes 等名称最终由 Ren 定
Integration: I1–I12 全部处理；审查列出的会改变判断的结果中，第 1、3、5、6、8 项完成，第 2、4、7 项的更正完成而各留一个开放结果，
       第 9 项属于 Ren
```

### 19.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| I1 | `present` 不重复是 `More.unceasing` 的第三个必要前提，章节两处省去（`Repeated`） | `Repeated` 移入 `Population`，成为定理：一个始终活跃的形成在第 t 步被列 t 次，普查、平衡、Acting、Taking 与不止地更多都成立，没有任何生起，只缺 present 不重复。模块说明中“（论证，未形式化）”随之删去。章节 §1、§2 与 §8 补上这一前提；more-needs-renewers 把它写为必要前提，并列入反例 |
| I2 | 核心中没有满足 `More.unceasing` 全部前提的正面见证 | `Garden.census`、`Garden.counted`、`Cycle.census`、`Cycle.counted` 成为定理：花园与循环都满足普查、present 不重复、Taking 与不止地更多，所以蕴含不是空的。`Garden.unceasing_reidentified`：花园的生成在每个改认下不息。为此把 `More.unceasing` 的增长部分提出为 `Flow.More.grows` |
| I3 | `replenishment_recurs` 的证明丢弃了 `Arises`；恒定的取用者同样需要补充复现（`Steady`）；§15.4 反驳 2 强于定理 | `uptake_needs_replenishment` 成为 `Flow` 的一般定理：在平衡的流中，任意晚的步上有正的取用，就需要任意晚的步上有补充。`replenishment_recurs` 由它推出，说明写明生起只经由它带来的取用起作用。`Steady.steady` 成为定理。§15.4 反驳 2、章节 §2 与 §8、unceasing-generation-needs-renewal 随之更正：需要补充的是复现的取用，无论取用来自生成还是维持；把生成与维持分开的是严格性（`Tide.renewal_without_arising`），不是对补充的需要 |
| I4 | 四处 P11b 残余与一处过期时间 | (a) `Depletes` 的字面名称（例如 `FallsWhenStill`）列入 Ren 的选择，暂不改名。(b) `MetAbove` 的说明改为“依存在每一步都成立，满足与否不论”。(c) 写明 `More.unceasing` 只用到 Taking 中“只有活跃的形成取用”这一半。(d) Flow 与 Dissipation 的说明、回执的范围文字、包的 README、章节、本文档的现行段落与两份记录中残留的“给予者／giver”改为“补充者／renewer”；对历史的描述保留原词。(e) becoming-renewal-reading 的审查时间刷新 |
| I5 | 连续是单向的；双向读时生起与侵蚀恰被保持 | `Reidentify.back` 把同一对应从新命名读回旧命名。`arises_of_back_keepsActive`、`arises_iff_of_keepsActive_both`、`unceasing_iff_of_keepsActive_both`、`metAbove_of_back_keepsTenure`、`undermining_of_back_keepsTenure` 与 `undermining_iff_of_keepsTenure_both` 成为定理。`Lineage.one_way`、`Succession.one_way`：两个见证中合并的命名保持分开命名的连续，反之不然。模块说明、§16、记录与章节改为：单向时新命名可以制造连续（接起来），不能去掉连续；两向保持连续时，生起与侵蚀恰被保持；接续开放，是因为连续取单向的读法。记录下一步中“连续定理的反方向”一项关闭 |
| I6 | 双向保持连续，跨过休眠之步接起来仍改变形成的类（`Dormancy`） | `Dormancy` 移入 `Identity`，成为定理（`keeps_both`、`classes`）。接续改述为：把终结的形成与在该步或其后开始的形成接起来，中间可以有不活跃、不依存的步。加一句：连续不约束形成在整段上的类 |
| I7 | “名字不承载任何东西”与“跨步的同一由命名规定”字面矛盾；改名不变检查不到方法所防的偷渡 | 改为“标签不承载任何东西：改名保持由关系定义的读法（检查了五种）”。加一句：名字跨步的模式承载同一，这是表示给出的对应前提，`Turnover` 表明它是实质的；方法要求在这里的检查是这一披露，不是改名不变。记录标题随之改写 |
| I8 | 单由命名造成的生起可以满足 `Unceasing.regeneration_recurs` 的全部前提（`TideFlip`） | `TideFlip` 移入 `Identity`，成为定理。§16“对 P10 的影响”的第二个理由改为：`Depletes` 不系于生起的形成，不筛掉命名的产物；定理不受影响，是因为结论只关乎条件；它的前提 `Unceasing` 依赖同一，要把它读作关于生成的定理，需要命名保持持续的活动（`arises_of_keepsActive`）。记录中依赖的说明限于 `Turnover`，`TideFlip` 列为反例 |
| I9 | “在每种同一的读法下”不成立；分裂不改变形成的数目 | 两处都做。其一，改为“在每种一对一的同一读法下”，并把分裂与合并改述为：一个形成延续为几个或几个延续为一个，改变的是延续关系，不是任何一步形成的数目。其二，以延续关系表示它们（`Web.Continues`）：`ArisesFrom` 是延续关系之下的生起，`arisesFrom_self` 表明以自身为延续时它就是 `Arises`。`Flow.More.unceasingFrom` 成为定理：在每种没有形成延续为两个的延续关系之下（`NoSplit`，允许合并），普查之下不止地更多使形成在任意晚的步生起；证明经由关系形式的鸽巢原理 `length_le_of_matched`。`continuation_reidentify`：每个改认都是这样的延续，其下的生起恰是新名字下的生起。`Budding.growth_without_arising`：把新形成读作从形成 0 萌出，第一步之后没有任何生起，而这一延续有分裂。所以没有分裂是充分条件；萌出表明有的分裂使结论失效，一次分裂不必（P16b 更正，原文“所以分裂恰是界限”；`Fork.split_unceasing`） |
| I10 | 谱系的 AI 论证把单层表示的省略呈现为二选一；“落在维持与更新上”没有见证 | `Layered.both` 成为定理：把谱系本身与成员并列命名，谱系每步活跃，成员不息地生起；依存网没有部分与整体的关系。AI 论证改为：谱系与成员是同一展开的两个层次，作为整体的谱系持续正由成员不息地生起而成；单一命名层次只能表示其一，部分与整体的关系是这一表示所省略的关系。“落在维持与更新上”删去。写明只读作谱系的持续与 Ren 原话中“不断创造”之间的张力 |
| I11 | `Succession` 的继承者从不活跃 | `Succession` 改用活跃的继承者：继承者在第二步活跃并以一单位被满足，自第三步起需要两单位；活动需要支持。分开命名时第一步之后的汲取都不侵蚀；继承者接续长者时自第三步起每一步都侵蚀。结论不变，见证更强 |
| I12 | 依赖同一的读法没有在其记录中注明 | unceasing-generation-needs-renewal、becoming-stepwise-reading、becoming-renewal-reading 与 more-needs-renewers 的界限各加一句，指向 identity-across-steps |

### 19.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Flow | `uptake_needs_replenishment`；`replenishment_recurs`（改由它推出） | 平衡的流中，任意晚的步有正的取用，就需要任意晚的步有补充 |
| Flow | `Steady.web`、`Steady.flow`、`Steady.steady` | 一个消耗者与一个补充者始终活跃：取用每步为正，没有任何生起，补充复现 |
| Population | `length_le_of_matched`、`search`；`length_le_of_sub`（改由前者推出） | 关系形式的鸽巢原理：不重复的表中每个成员匹配另一表的某个成员、没有成员被匹配两次时，前者不更长；在有限表中检索可判定的性质 |
| Population | `Flow.More.grows` | 在普查、present 不重复与 Taking 之下，不止地更多使活跃的形成没有界地增多 |
| Population | `Garden.census`、`Garden.counted`、`Cycle.census`、`Cycle.counted` | 花园与循环满足 `More.unceasing` 的全部前提 |
| Population | `Repeated.more_without_arising` | 只缺 present 不重复时，不止地更多而没有任何生起 |
| Dependence | `MetAbove`（说明更正） | 依存在任期的每一步都成立，满足与否不论 |
| Identity | `Reidentify.back`；`arises_of_back_keepsActive`、`arises_iff_of_keepsActive_both`、`unceasing_iff_of_keepsActive_both`、`metAbove_of_back_keepsTenure`、`undermining_of_back_keepsTenure`、`undermining_iff_of_keepsTenure_both` | 双向的连续恰保持生起、不息与侵蚀 |
| Identity | `Web.Continues`、`ArisesFrom`、`UnceasingFrom`、`NoSplit`、`arisesFrom_self`、`unceasingFrom_self` | 延续关系之下的生起与不息；以自身为延续时就是 `Arises` 与 `Unceasing` |
| Identity | `arisesFrom_of_more`、`unceasingFrom_of_growth`、`Flow.More.unceasingFrom` | 没有分裂的延续之下，活跃的形成变多时有形成生起；普查之下不止地更多使形成在任意晚的步生起 |
| Identity | `Reidentify.continuation`、`Web.continuation_reidentify` | 每个改认都是没有分裂的延续，其下的生起恰是新名字下的生起 |
| Identity | `odd`、`afterFirst`、`turn`、`turn_turn`、`turn_fixed`、`Reidentify.exchanging` | 在选定的步以对合交换名字；五个见证共用 |
| Identity | `TideFlip.naming_meets_premises` | 命名造成的生起满足 `Unceasing.regeneration_recurs` 的全部前提 |
| Identity | `Garden.unceasing_reidentified` | 花园的生成在每个改认下不息 |
| Identity | `Budding.growth_without_arising` | 萌出的延续有分裂，第一步之后不迫使任何生起 |
| Identity | `Lineage.one_way`、`Succession.one_way` | 合并的命名只单向保持连续 |
| Identity | `Layered.both` | 谱系每步活跃，成员不息地生起 |
| Identity | `Succession.readings`（继承者改为活跃） | 继承者活跃并被满足；接续时自第三步起汲取每一步侵蚀 |
| Identity | `Dormancy.keeps_both`、`Dormancy.classes` | 跨过休眠接起来，双向保持连续，形成的类改变 |

原有的 `Web.search`、各见证自己的 `turn`、`after` 与 `Succession.elder_named` 由上述一般声明代替。

### 19.3 审查列出的会改变判断的结果

1. `More.unceasing`：章节写明 present 不重复，`Repeated` 与花园、循环的普查移入核心。完成（I1、I2）。
2. 流的形式：`uptake_needs_replenishment` 移入核心，反驳 2 更正。完成（I3）。使生成而不是取用承担这一要求的耗散流定理，开放。
3. 双向的连续：四个双向定理移入 `Identity`，单向读法写明为一种选择。完成（I5）。
4. 休眠：`Dormancy` 作为见证，接续放宽到跨过不活跃之步，并写明连续不约束形成的类。完成（I6）。跨过休眠也成立的连续读法（例如不活跃时持续的依存），开放。
5. 标签与同一：按 I7 改写。完成。
6. 分裂：一对一的限定与对分裂的更正描述，完成；在每种没有形成延续为两个的延续关系之下（允许合并），不止地更多迫使生起的定理，以及 `Budding` 表明分裂使它失效，完成（I9）。限定由一个充分条件代替：没有分裂是充分的，不是必要的（P16b 更正，原文“限定由精确的界限代替”；`Fork`）。延续关系上的充要条件，开放。
7. 谱系：改为同一展开的两个层次，部分与整体的关系被省略；“落在维持与更新上”删去。完成（I10）。形成之间带部分与整体关系的表示，开放。
8. 见证与记录：`Succession` 的活跃继承者（I11）、界限句（I12）与 I4 的残余，完成。
9. 接续的读法、“生生不息”读到谱系、成员或两者的层次、任期能否经由接续延续：属于 Ren。本节没有替 Ren 作任何一个选择。

### 19.4 作者反审

*反驳 1：双向的连续是更自然的读法，单向读法只是为接续留出空间。* 两种都是读法。单向读法以一个命名为参照，问另一个命名是否与它相容；双向读法要求两个命名对谁延续谁一致。双向时，同一步的接续被排除，但跨过休眠的接续仍在（`Dormancy`），所以双向读法也不消除对接续的选择。

*反驳 2：`More.unceasingFrom` 只是把鸽巢原理搬到关系上。* 对，这是它的内容。新的是一个充分条件：在普查、present 不重复与 Taking 之下，没有分裂时（允许合并，`Merge`），更多迫使生起；萌出时不然（`Budding`），一次分裂则不必使它失效（`Fork`）。“更多迫使生起”不依赖一一对应的命名。（P16b 更正；原文“新的是界限的精确……有分裂时不然”“只依赖没有形成延续为两个”。）

*反驳 3：可判定性的假设太强。* 它是定理的假设，不是公理。在普查之下，若延续关系本身可判定，“是否延续某个活跃形成”就可判定，因为只需在有限表中检查。没有任何可判定性时，构造性地只能得到“不是从某步起再没有生起”。（P16b 补充：`Web.Census.decideContinues` 把这一点写为定义，`Merge` 用它。）

*反驳 4：`Steady` 削弱了 P10 的流的形式。* 它澄清了内容：补充复现的需要来自复现的取用，无论取用来自生成还是维持。生成与维持之分在严格性上（`Tide.renewal_without_arising`、`Bloom.not_more`）。这与“不断创造更多生”并不冲突：更多的取用需要没有最终界的补充（§14）。

*反驳 5：`Layered` 回避了谱系的读法。* 它表明二选一出自表示：一个命名层次只能表示谱系或成员。把部分与整体的关系纳入表示（例如形成之间的构成关系），是开放的结果；在此之前，把“生生不息”读到哪个层次属于 Ren。（P16 补充：§21 把部分与整体的关系纳入表示；读到哪个层次仍属于 Ren。）

**边界。** 不改变读法选择的地位；不推出责任、义务或任何排序；新名称是建议，`Depletes` 的名称留给 Ren；探针与新见证都是最小见证；延续关系之下只陈述了更多迫使的生起，形成的类、任期与侵蚀没有陈述。本节的更正经第六次独立审查，再更正见 §22。

## 20. 生成即补充：生起本身承担要求（P15）

2026-10-09。按同一指示继续。第五次独立审查（I3）指出，在流的形式中生起只经由它带来的取用起作用，`uptake_needs_replenishment` 所用的只是取用；审查 §4 第 2 项写道，一个耗散的流的定理会让生成本身而不是取用承担要求。§17 的边界写明结论不约束不取用的生起，§18 写明 `Brood` 只给予不取用、耗散之下的一类读法未陈述（P16b 用语更正）。本节在一类关系项的读法中回答这三处。体现的关系项的生起，就是它作为条件的水平的上升，所以生成本身就是补充；在耗散之下，给予须以取用为条件，在有限家族中复现的生成于是使家族不封闭，家族被围住时须从其外汲入（P16c 更正，原文“补充须付出所取”“需要与家族之外交换”）。成果记录：[generation-is-replenishment](../../../../theories/becoming/results/records/generation-is-replenishment.md)。

```text
Result(s): 复用 life-as-condition-of-life（一类读法、Embodied、SelfBearing、arises_given、Brood）、
           no-finite-part-bears-taking（ClosedAt、DissipatesOn、Dissipative、runs_down、Frontier 的燃料）、
           more-needs-renewers（流、平衡、给予、补充、Acting）、becoming-renewal-reading（falls_finitely）；
           新增 generation-is-replenishment（L3：Becoming.Roles 新增两节与三个见证，Becoming.Dissipation 新增一条引理）
Delta: 平衡的流中，体现的关系项至少被给予它生起时的水平（Embodied.given_of_arises），
       所以它的生起补充每个包含它的家族（Embodied.replenishes）；体现的成员在任意晚的步生起时，
       家族的补充复现，不论取用什么（generation_needs_replenishment）；被耗散时，给予家族者从家族取用
       （DissipatesOn.takes_of_gives），所以封闭家族中体现成员的生起降低家族的存量（Embodied.arising_lowers）；
       在耗散之下，体现成员在任意晚的步生起的不重复有限家族从任何一步起都不封闭（generation_opens）；
       有限个关系项就是全部时，体现的关系项不在任意晚的步生起（generation_ceases）；
       Handing、Kindling、Flicker 表明三个前提各自必要；Brood 不耗散（Brood.not_dissipative，P16b 改名，原名 Brood.costless）
Supplied premises / correspondence: 流平衡依存网；Embodied 是对生起的关系项的表示前提；
       耗散是物理前提（§17），只用于耗散之下的结论；量是自然数，单位可公度
Evidence: Becoming.Roles 新增的 28 项定理与 Becoming.Dissipation 新增的 1 项定理；合并检查器回执（见记录）
Boundary: 只约束体现的关系项的生起，不体现的生起不受约束（Flicker）；“有限”指有限的关系项家族；不含伦理谓词
Integration: 回答第五次审查 I3 与 §4 第 2 项；回答 §17 的边界（不取用的生起）与 §18 反驳 5（耗散之下的一类读法）；
       §13 的 dissipation_ceases 所设的物理前提，对封闭家族中体现成员的生起，由平衡、耗散与体现推出
```

[Becoming.Roles](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Roles.lean) 新增的两节与见证，以及 [Becoming.Dissipation](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Dissipation.lean) 新增的一条引理（L3）：

| 声明 | 内容 |
|---|---|
| `Embodied.given_of_arises`、`Embodied.replenishes` | 平衡的流中，体现的关系项至少被给予它生起时的水平：生起前它不活跃，所以水平为零；生起后它活跃，所以水平为正。于是它的生起补充每个包含它的家族 |
| `generation_needs_replenishment` | 一个家族的体现成员在任意晚的步生起时，家族的补充在任意晚的步出现，不论取用什么。与 `uptake_needs_replenishment` 不同，这里不用存量的论证，也不用任何取用 |
| `Flow.DissipatesOn.takes_of_gives` | 被耗散时，给予家族的形成从家族取用（在 `Dissipation`） |
| `Embodied.arising_lowers` | 在耗散之下，一个跨某步封闭的不重复家族中，体现成员的生起降低家族的存量：给予它者从家族取得更多 |
| `generation_opens` | 在耗散之下，体现成员在任意晚的步生起的不重复有限家族，从任何一步起都不封闭：在任意晚的步有参与的形成与家族之外交换，这一交换可以与家族无关（`SprayHanding`）；家族被围住时它汲入（`generation_draws_in`）（P16c 更正，原文“在其中复现的生成需要在任意晚的步与家族之外交换”） |
| `generation_ceases` | 有限个关系项就是全部时，在耗散之下，体现的关系项不在任意晚的步生起 |
| `Brood.not_dissipative`（P16b 改名，原名 `Brood.costless`） | `Brood` 只给予不取用，所以不耗散 |
| `Handing.flow`、`web`、`balances`、`acting`、`dependent`、`embodied`、`arises`、`recurs`、`handing` | 两方来回传递一份水平：持有者取用自己的一单位并给予另一方。两个关系项就是全部，流平衡，只有活跃者给予，每方体现并承担自身，`Dependent`，两方的家族每步封闭，生成不息；只有耗散不成立 |
| `Kindling.Relatum`、`flow`、`web`、`balances`、`acting`、`dependent`、`side_dissipates`、`dissipative`、`kindling`、`frontier` | 同样的传递，持有者每步另燃一份新燃料的两单位：流平衡并耗散，每方体现并承担自身，各自在任意晚的步生起；所以包含一方的每个不重复有限家族在任意晚的步都不封闭，所燃的燃料不在任何有限家族之内 |
| `Flicker.web`、`flow`、`flicker` | 一个关系项在奇数步活跃，从不作为条件而在，没有任何参与：一个关系项就是全部，流平衡并耗散，生成不息；只有体现不成立 |
| `Handing.even`、`holder`、`stands`、`every`、`distinct`、`stands_two`、`holder_stands`、`Kindling.gives_other`、`gives_one` | 见证的辅助定义与引理 |

**解读。**

- **生成本身就是补充。** 两类读法中，形成的生起不是任何条件的变化，生起只经由它带来的取用起作用（I3，`Steady`）。一类读法中，体现的关系项的生起就是它作为条件的水平从零上升，平衡于是要求有给予：生成本身就是补充，不需要任何取用。这是 §18 `arises_given`（经由另一个活跃者的给予而生起）的数量形式：生起时的水平全由给予承担（P16b 用语更正，原文“生由生给予”）。
- **耗散之下，复现的生成打开有限家族。** 给予被耗散家族的形成从家族取用，所以在被耗散的家族中，体现成员的每次生起都降低家族的存量，而存量从不上升。生成在一个有限家族中复现，家族就在任意晚的步不封闭（`generation_opens`）；这一交换可以与家族无关（`SprayHanding`），家族被围住时它汲入（`generation_draws_in`）（P16c 更正，原标题“耗散之下，生成不由有限部分独自承担”，原文“给予家族者从家族取用”“在封闭家族中”“家族就须在任意晚的步与其外交换”）；关系项总共有限时，体现的生起终将停止（`generation_ceases`）。这把 §17 关于取用的定理推到不取用的生起，条件是生起的关系项体现。对每个有限家族，体现的生成要么在其中不再复现，要么它在任意晚的步打开；不断生起新的关系项（`Brood` 的一代代）不在任何有限家族中复现，定理对它不作约束。
- **§13 的物理前提被推出。** `dissipation_ceases` 假设一个量从不上升，而每次生起都使它下降，那是作为物理前提提供的。在一类读法中，对封闭家族中体现成员的生起，这个量就是家族的存量：它从不上升（`runs_down`），每次这样的生起都使它下降（`arising_lowers`），两者都由平衡、耗散与体现推出。
- **三个前提各自必要。** 没有耗散，两方来回传递一份水平，就在两个关系项的封闭世界中不息地生成（`Handing`），这是 §13 的 `Recycle` 与 §14 的 `Cycle` 在一类读法中的对应。燃烧新的燃料，传递在耗散之下继续，包含一方的每个有限家族都打开（`Kindling`），如 §17 的 `Frontier`。不体现时，一个关系项在一个关系项的耗散世界中不息地生起，没有任何给予（`Flicker`）。所以生起的关系项体现之处，生成承担自己的要求；不体现之处不必（P16b 更正，原文“没有任何代价”“恰在生起的关系项体现之处”）。哪些关系项体现是表示的选择，这一选择在这里有后果。
- **对生生（作者的读法）。** Ren 的原话是“生生不息 - 一种整体的，不断创造更多生的方向”。若生起的关系项自身就是其他关系项的条件，每次生起都是一次补充（P18b 用语，原文“生起的生命”“其他生命”）；在耗散之下，被围住的有限部分中不息的生起须从其外汲入（P16c 更正，原文“不息的生起不能由任何有限的部分独自承担，须由越出每个有限部分的展开承担”；耗散空成立时，有限部分可以独自承担生成，见 `SprayHanding`）。作者把这读作原话中“生”与“整体”之间关系的一种形式内容（AI 论证），不替代原话，也不推出它是好的。

**作者反审。**

*反驳 1：`generation_needs_replenishment` 几乎是定义。* 对：一旦体现，生起就是水平的上升，平衡使上升由给予承担。内容在于对照：两类读法中生起不承担任何要求（`Flicker`、`roles_not_embodied`），体现时它承担。实质的新结果是耗散之下的 `generation_opens` 与 `generation_ceases`，以及 §13 前提的推出。

*反驳 2：给予体现关系项的，可以是它自己吗？* 生起前它不活跃，在 `Acting` 之下不给予，给予它的是另一个活跃的形成（`arises_given`）。本节的定理不用 `Acting`，也不依赖给予的是谁：给予被耗散家族的任何形成都从家族取用（P16c 用语，原文“给予者”“给予被耗散家族者”）。

*反驳 3：`Handing` 中持有者取用自己的水平，这是自我终结，不像生命。* 它是最小见证，表明没有耗散时，体现的生成可以在封闭的有限世界中不息，正如 `Recycle` 与 `Cycle`。见证中没有汲取（`draws` 为空），所以不涉及断裂与侵蚀的读法；若把传递读作汲取自身，`ending_breaks` 使传递事件不是 living。本节不选择这一读法。

*反驳 4：`generation_ceases` 只说体现的生起不在任意晚的步出现，不说生成不是不息的。* 对。不体现的生起不受约束（`Flicker`）；若每个关系项都体现，它就说生成不是不息的。

*反驳 5：体现太强，种子、孢子与休眠的生命在活动之外仍作为条件而在。* 对。`Embodied` 要求活动与水平同步；休眠的种子水平为正而不活跃，它的“生起”（萌发）不是水平的上升，不受这里的约束。活动与水平不同步时生成承担什么，是下一步（P17 补充：要求跟着水平走，不跟着活动走，见 §24）。

**边界。** 不含伦理谓词；只约束体现的关系项的生起；`Embodied` 是表示前提，遗骸、种子库与不活跃的条件不体现；耗散是物理前提，单位可公度；“有限”指有限的关系项家族；见证都是最小见证。本节尚未经独立审查。

## 21. 整体与部分：整体经由部分的生成而持续（P16）

（P16c 更正标题，原题“整体与部分：整体的持续就是部分的生成”；见 §23 K3。）

2026-10-09。按同一指示继续。第五次独立审查（I10）指出，谱系与成员是同一展开的两个层次，部分与整体的关系是单一命名层次所省略的关系；§19 把它记为 `Layered`，审查 §4 第 7 项写道，一个含形成之间部分与整体关系的表示，会使它成为定理。本节给出这一表示，并证明它承担什么。成果记录：[whole-persists-through-generation](../../../../theories/becoming/results/records/whole-persists-through-generation.md)。

```text
Result(s): 复用 unceasing-generation-needs-renewal（Arises、Unceasing）、identity-across-steps（odd、Layered）；
           新增 whole-persists-through-generation（L3 Becoming.Wholes）
Delta: 整体（Whole）：恰在某个部分活跃时活跃；列出（Listed）、终结（Ends）、短暂（Brief）；
       整体只经由某个部分的生起而生起（Whole.arises_part、parts_unceasing）；
       从某步起每步活跃的整体，部分从不在相隔 d 步的两步都活跃时，每 d 个连续步内有部分生起（Whole.arises_within）；
       部分的活动都终结且活跃的部分可列出时，部分在任意晚的步生起（Whole.needs_arising）；
       Immortal、Countless 表明前提必要，Generations 表明前提相容，Shifts 表明界 d 可达，Gaps 表明逆命题不成立；
       Layered 的谱系是其成员的整体（Layered.composed）
Supplied premises / correspondence: Whole 是表示前提，只由活动关联部分；Brief（部分短暂），或 Ends 与 Listed（部分终结且同时活跃的部分有限），是对部分的前提（P16c 更正，原文“是对部分不长久的陈述”）；
       跨步的同一由命名给出
Evidence: Becoming.Wholes 的 26 项定理；合并检查器回执（见记录）
Boundary: 整体的依存、汲取与侵蚀不由部分推出；成员资格不随步变化；不说哪个部分生起，也不说数目增长；不含伦理谓词
Integration: 回答第五次审查 I10 与 §4 第 7 项；§16、§19 中“谱系与成员是两个层次，部分与整体的关系被省略”由本节陈述
```

[Becoming.Wholes](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Wholes.lean)（L3，导入 `Becoming.Identity`）：

| 声明 | 内容 |
|---|---|
| `Web.Whole`、`Web.Listed`、`Web.Ends`、`Web.Brief` | 整体：恰在某个部分活跃时活跃。列出：每步有一个有限列表恰好列出活跃的部分。终结：从某步起再不活跃。短暂（对 d）：从不在相隔 d 步的两步都活跃，若活动是一段连续的步，它至多 d 步 |
| `Whole.arises_part`、`Whole.parts_unceasing` | 整体只经由某个部分的生起而生起；整体在任意晚的步生起时，部分也在任意晚的步生起 |
| `active_back`、`Ends.all` | 在 k 步之内没有部分生起时，k 步之后活跃的部分在开始时不是不活跃的；有限个终结的形成在某一步之后都终结 |
| `Whole.arises_within` | 从 T 起每步活跃的整体，部分从不在相隔 d 步的两步都活跃时，从 T 起每 d 个连续步内都有部分生起 |
| `Whole.needs_arising` | 从某步起每步活跃的整体，每个部分的活动终结，且活跃的部分可列出时，部分在任意晚的步生起 |
| `Generations.web`、`whole`、`listed`、`ends`、`brief`、`generations` | 一代代成员各活跃两步：谱系是其整体，每步活跃而从不生起；成员可列出、终结、短暂（d = 2），每步都有新成员生起 |
| `Shifts.web`、`shifts` | 成员轮班两步：谱系每步活跃，成员短暂（d = 2），偶数步上没有部分生起：每两步内有生起，每一步内则不必，界 d 可以达到 |
| `Immortal.web`、`immortal` | 一个永不终结的部分：整体持续，部分可列出，没有任何生起 |
| `Countless.web`、`whole`、`ends`、`never`、`countless` | 无穷多个部分同时活跃，第 n 个活跃到第 n 步：整体持续，每个部分终结，没有任何生起；于是活跃的部分不能有限地列出 |
| `Gaps.web`、`whole`、`listed`、`ends`、`gaps` | 每个成员只在一个奇数步活跃：部分在任意晚的步生起、终结、可列出，整体在每个偶数步不活跃 |
| `Layered.composed` | `Layered` 的谱系是其成员的整体 |
| `Generations.Formation`、`parts`、`alive`、`Shifts.half`、`odd_two`、`half_even`、`Countless.parts`、`Gaps.alive`、`alive_odd`、`alive_even` | 见证的辅助定义与引理 |

**解读。**

- **两个层次由整体关系联系。** §16 与 §19 中，谱系与成员只能由两种命名分别表示，或并列命名而没有关系（`Layered`）。这里整体关系把两个层次放进同一个依存网：谱系恰在某个成员活跃时活跃（`Layered.composed`）。整体关系是活动的重合，不是构成：每个形成都是它自身的整体，两个每步都活跃的形成互为整体（`whole_self`、`Immortal.each_other`，P16c 补充）。这是表示所省略的关系的一种陈述，不是从每一步的关系推出的；哪些形成是哪个整体的部分，由应用给出。
- **整体经由部分的生成而持续。** （P16c 更正，原标题“整体的持续就是部分的生成”，原文“部分不长久时”；定理只用到部分的覆盖，`Covered`。）部分短暂，或部分终结且同时活跃的部分有限时，整体要每步活跃，就须不断有部分接上：部分从不在相隔 d 步的两步都活跃，则每 d 步内有部分生起（`arises_within`）；部分的活动都终结且有限地列出，则部分在任意晚的步生起（`needs_arising`）。谱系每步活跃而从不生起（`Generations`）：在整体的层次上是持续，在部分的层次上是不息的生起。
- **为什么需要不长久与有限。** 有一个永不终结的部分，整体的持续不需要任何生起（`Immortal`）。无穷多个部分一开始就同时活跃、各在不同的步终结，整体也可以持续而没有生起（`Countless`）：持续由一开始就在的无穷储备承担。有限地列出排除这种储备。
- **逆命题不成立。** 部分不息地生起，不使整体持续：生起之间可以有空隙（`Gaps`）。读到整体层次的持续，比读到部分层次的不息生起更强。
- **对生生（作者的读法）。** Ren 的原话是“生生不息 - 一种整体的，不断创造更多生的方向”。§19 曾写，只读作谱系的持续，与原话中的“不断创造”有张力。在 Ends 与 Listed 之下，谱系的持续蕴含越出任何有限成员列表的新成员不断生起（`needs_new`）；在 Brief 之下只蕴含成员反复生起（`Layered`）；两者都不蕴含数目增长。所以张力减弱而不消失：“不断创造”在 Ends 与 Listed 之下读到不断新的成员，“更多”没有由此推出（P16c 更正，原文“在部分不长久的前提下，这一张力消失：谱系的持续蕴含成员不断生起，整体的“不息”正由部分的“生生”构成”）。作者把这读作原话中“整体”与“不断创造”的一种形式联系（AI 论证），不替代原话，也不决定“生生不息”读到哪个层次，那仍属于 Ren。

**作者反审。**

*反驳 1：`Whole` 是定义，定理几乎是鸽巢原理。* 对：定理是组合性的。内容在于把两个命名层次放进一个表示，并说明在什么前提下两个层次的读法相互蕴含，在什么前提下不蕴含（`Immortal`、`Countless`、`Gaps`）。

*反驳 2：整体只由活动关联部分，谱系的依存与侵蚀呢？* 没有陈述。一个汲取可以侵蚀成员而不侵蚀谱系，或反之；整体的依存怎样由部分构成，是下一步。§19 的继承者问题（继承者是否继承长者的损失）在这里仍属于 Ren。

*反驳 3：部分可以再生起而不终结，例如 `Layered` 的成员。* 对。`Layered` 的成员满足 `Brief 1`，`arises_within` 适用：每一步都有成员生起（`Layered.brief`、`Layered.within`）；它们的活动不终结，`needs_arising` 不适用（`Layered.arise_again`）。所以 `Brief` 不说部分终结，它允许同样的部分反复生起。前提不必要的见证需要活动段无界增长的部分（对任何 d 都不 `Brief`、从不终结、使整体持续），没有构造（P16c 更正，原文“`Layered` 的成员隔一步就再活跃，`Ends` 与 `Brief` 都不成立，两个定理都不适用；成员仍不息地生起（`Layered.both`）。所以这些前提是结论的充分条件，不是必要条件；两个定理各用一种“不长久”的陈述”；见 §23 K5）。

*反驳 4：生起依赖跨步的同一，把成员改认为一个，生起就消失。* 对（§16，`Lineage`）。本节的定理在给定命名下成立；把成员合为一个，就是把整体当作部分，整体关系退化为一个部分的情形，`Immortal` 表明那时不需要生起。

*反驳 5：结论不说数目增长，不是“更多”。* 对。本节只说持续需要生起；“更多”的数目读法见 §14。

**边界。** 不含伦理谓词；整体只由活动关联部分；部分关系是静态的；生起依赖跨步的同一；“生生不息”读到哪个层次属于 Ren；见证都是最小见证。本节尚未经独立审查。

## 22. 第六次独立审查与更正（P16b）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P13（§17）、P14（§18）与 P12b（§19）（[审查](../history/root-foundation/BECOMING-P13-P14-P12B-REVIEW.md)）。它在仓库之外从前导重新编译核心闭包的 21 个模块，公理报告为空；回执、哈希、别名与证明绑定都对，数学接受，I1–I12 全部关闭。问题在前提的陈述、散文与对应之间，共十一项（J1–J11），没有数学错误；附无公理的探针。审查没有发现替 Ren 选择生生、living、接续或终结的读法；它指出两个反复出现的模式：省略前提（I1 → J10），以及把所给的对应呈现为结果（I7 → J4）。本节记录逐项处理。探针的内容作为定理移入相应模块，公理报告为空；审查提议而未形式化的两个结果，有限支撑下给予的形成取得多于所给（J1；P18b 用语，原文“给予者”）与 `roles_dissipative` 的逆（J8），也已证明。§17–§20 中受影响的句子已就地更正并标明；原文见提交 `25a66424`。

```text
Result(s): 修正 no-finite-part-bears-taking（主张、假设、对应、反例、界限）、
           life-as-condition-of-life（标题、主张、假设、对应、反例、界限、下一步）、
           identity-across-steps（标题、主张、假设、反例、界限、下一步）、generation-is-replenishment（改名与用语）；
           more-needs-renewers、unceasing-generation-needs-renewal、becoming-stepwise-reading、becoming-renewal-reading 记入审查；
           condition-correspondence-discipline 只改检验范围；不新增结果记录
Delta: 封闭的步（Enclosed）：耗散之下，给予的形成在封闭的不重复家族上取得多于所给（gives_less；P16c 补上“不重复”），在封闭的步上给予须以取用为条件
       （giving_needs_uptake）；没有封闭的步时耗散是空的，补充者可以什么都不取而给予（Spray）；维持一个取用者已越出每个有限家族（Lone）；
       生长者依存于池的前沿满足全部前提（Rooted）；此前取用复现的见证都不耗散（witnesses_not_dissipative）；
       一类读法也保持 Acting、Taking、普查、present 不重复与耗散；哪个条件就是哪个关系项由共同的索引给出（relabel）；
       体现不进入估值（Mutualism.apart_embodied）；终结之步的汲取不论是什么终结了它都是断裂（Wilting、SelfBearing.met_iff；P18b 用语，原文“终结了生命”）；
       arises_given 中给予的关系项不必体现（SunSeed），只有体现者给予时给予它的关系项体现（arises_from_embodied；P16c 用语，原文“给予者”）；
       没有分裂是充分的，不是必要的（Fork）；含合并的见证（Merge）、普查给出可判定性（decideContinues）、
       没有普查时不成立（Dormant.no_split_without_arising）、双向的连续排除单步的接续（no_join）
Supplied premises / correspondence: 新增：封闭的步是有限支撑的前提；哪个条件就是哪个形成的同一对应（一类读法的表示前提，与 Embodied 并列）；
       只有体现的关系项给予（arises_from_embodied 的对应前提）
Evidence: Becoming.Dissipation 55、Roles 110、Identity 79、Population 36、Correspondence 37 项定理；
          合并检查器回执 20261009T071936.578078Z（676 项定理／1115 项声明审计，核心闭包 22 个模块，包 20 个模块，公理报告全空）；
          外围桥接 20261009T072041.754860Z
Boundary: 在终结之步的汲取是否计入不 living、对哪些汲取者，接续的读法，“生生不息”读到哪个层次，Depletes 与“代价”一族的名称，属于 Ren
Integration: J1–J11 全部处理；审查 §4 第 1–7 项完成，各留下的开放结果见 22.3；第 8 项属于 Ren
```

### 22.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| J1 | `Dissipative` 只约束在某步封闭的有限家族；某个形成与无穷多个条件交换时没有家族封闭，耗散是空的，补充者可以什么都不取而给予（`Spray`）。“给予总使补充者所取的条件付出多于所给”与“补充者的代价须表示为它所取的条件”在定义上不成立 | `Flow.Enclosed`：跨某步有一个不重复的家族封闭，即参与的形成的交换在有限个条件之内；条件总共有限时每步都是（`enclosed_of_finite`）。`Dissipative.gives_less`：耗散之下，在跨某步封闭的不重复家族上，参与而给予的形成取得多于所给。`Dissipative.giving_needs_uptake`：在封闭的步上，给予的形成从某个条件取用。`Spray` 移入 `Dissipation`：汇与每个辅助条件交换，没有封闭的步（`unenclosed`），耗散空洞地成立（`dissipative`），补充者每步给予而什么都不取（`spray`）。§17 反驳 1、Flow 与 Dissipation 的模块说明、章节 §2 与记录的假设改为：在有封闭的有限家族的步上，给予须以取用为条件；并写明结论“在任意晚的步不封闭”可以由与家族无关的交换满足。`Spray` 列入记录的反例 |
| J2 | 定理只用复现的取用；维持一个恒定的取用者同样越出每个有限家族（`Lone`）；把“整体”读作“不断的更多”的内容，比定理窄。这是 I3 的同一模式 | `Lone` 移入 `Dissipation`：太阳每步燃一份新燃料（两单位）、给池一单位，一个吃者每步从池取一单位；流平衡并耗散，没有生起，不是不止地更多（`lone`），包含池的每个不重复有限家族在任意晚的步都不封闭（`frontier`）。§17“对生生”、章节 §2 与记录改为：复现的取用，无论来自不止的更多、生成还是维持，都不能由任何有限的条件家族独自承担 |
| J3 | `Frontier` 的生长者不依存于任何东西；`opens_of_arising` 没有见证；此前的流不耗散只是陈述 | `Rooted` 移入 `Dissipation`：`Frontier.flow` 配上池始终一单位、生长者活跃时以需要一依存于池的依存网；平衡、Acting、Taking、Dependent、普查、耗散、不止地更多与不息同时成立，包含池的家族由 `opens_of_arising` 与 `More.opens` 打开（`rooted`）。`witnesses_not_dissipative`：`Garden`、`Cycle`、`Pulse`、`Steady`、`Repeated` 与 `Bloom` 都不耗散，由一个条件上的 `Flow.Dissipative.one_ceases`。记录以 `Rooted` 为共同见证 |
| J4 | 一类读法的内容在于“条件 x 就是形成 x”，由共同的索引给出；`Web X X` 本身就是 F = C 的两类网；把条件一侧重新标号，检查过的两类读法都不变而体现改变；“恰是”“没有引入独立的本体”“省略的正是体现”说得过强。这是 I7 的同一模式 | `Web.relabel`：以 π 重新标号条件一侧。到上的重新标号保持 `Dependent`、侵蚀与 living（`relabel_dependent`、`relabel_undermining`、`relabel_alive`），以及两种估值的连通（`relabel_valuation_connected`、`relabel_interaction_connected`，在 L4）；以 `other` 重新标号，`Mutualism.apart` 中两者都承担自身（`apart_relabelled`）；以 `swap` 重新标号，体现的花不体现（`Wilting.relabelled_not_embodied`）。§18、章节 §1 与 §9、术语表与记录改为：两类读法嵌入一类读法，保持列出的读法；一类读法另需同一对应，它由共同的索引给出，是表示的前提；体现与承担自身是在这一对应下的读法；两类的表示省略的是形成与条件的同一对应。记录的假设加上这一对应，与 `Embodied` 并列为应用责任 |
| J5 | 体现不进入两种估值：`apart` 中两者都体现而不相关 | `Mutualism.apart_embodied`（L4）：两者都体现，各自依存并汲取对方，活动需要支持，共同参与与相互作用都不关联它们。§18“直接的关系”与记录补上：估值只经由共同的条件关联事件，只有承担自身把体现的关系项的活动接到汲取它的事件上；这是估值所省略的关系。直接读出体现的估值列为开放结果 |
| J6 | `ending_breaks` 读的是终结之步的汲取，不问是什么终结了它；旁观的汲取者与生命自身的最后事件也是断裂（`Wilting`）；交给 Ren 的选择的范围没有说明 | `Wilting` 移入 `Roles`：花体现、承担自身、因自身的取用而凋；蜜蜂从不取用；流平衡，Acting、Taking 与 Dependent 成立；蜜蜂在第二步的汲取与花自己的最后事件都是断裂与侵蚀（`wilting`）。`SelfBearing.met_iff`：在 Dependent 与体现之下，自身依存恰在活跃时被满足。Roles 的说明、`Predation.breaking`、§18、章节 §2 与英文段落改为：在一个承担自身的生命终结之步汲取它，不论是什么终结了它，是断裂；这包括旁观者、自然的终结与生命自身的最后事件；交给 Ren 的选择写明这一范围 |
| J7 | `arises_given` 的给予者只是一个活跃的关系项，可以是不体现、不依存的太阳（`SunSeed`）；“一个生命的生起由另一个生命的活动给出”强于定理 | `SunSeed` 移入 `Roles`（`sun_gives`）。`Embodied.arises_from_embodied`：在只有体现的关系项给予这一表示前提下，给予它的关系项也体现，并在给予时作为条件而在（P18b 用语，原文“给予者”）。`arises_given` 的说明、记录标题（“体现的关系项经由另一个活跃者的给予而生起”）、§18 的标题与解读、章节 §2 与英文段落改写；（P16c 更正：“生由生”不是定理：`arises_from_embodied` 证明在只有体现的关系项给予的前提下给予它的关系项也体现，它可以是不依存的太阳（`EmbodiedSun`），把体现的关系项读作“生”属于 Ren，见 §23 K6；原文““生由生”只在所述前提下成立，写为对应”） |
| J8 | “已陈述的读法”应为“列出的”；“一类读法不保持 Acting、Taking 与 Dissipative”照字面不成立 | `Flow.roles_acting`、`Flow.roles_taking`（双向）、`Web.roles_census`、`Flow.roles_distinct` 与 `Flow.roles_dissipative`（双向；审查未形式化的逆也已证明）移入 `Roles`。章节、§18 与记录改为“列出的读法”，界限句删去，记录下一步中“保持 Acting 与 Taking”一项关闭 |
| J9 | `NoSplit` 是充分条件，不是必要条件（`split_unceasing`）；“分裂恰是界限”沿用了第五次审查 §4 第 6 项过强的措辞 | `Fork` 移入 `Identity`：循环中形成 0 在第一步延续为两个，`NoSplit` 不成立，形成在这一延续下照样在任意晚的步生起（`split_unceasing`）。§19 的 I9 一行、19.3 第 6 项、19.4 反驳 2 与记录改为：没有分裂是充分条件；萌出表明有的分裂使结论失效，一次分裂不必。延续关系上的充要条件列为开放结果 |
| J10 | 章节对 `unceasingFrom` 与 `arises_given` 的概述省去前提（`dormant_no_census`）。这是 I1 的同一模式 | `Dormant.no_split_without_arising` 移入 `Identity`：在每个形成只延续自身的延续下没有分裂，Taking、present 不重复与不止地更多都成立，而没有任何生起。章节 §1 与 §8、Identity 的模块说明与记录标题补上普查、present 不重复与 Taking；`arises_given` 的概述补上平衡与 Acting。审查确认为正确的三点也移入核心：`Web.no_join`（新命名保持旧命名的持续活动时，单步不能接起来）、`Merge`（含合并的延续，`merging`；P16c：其生起是持续形成被重读，见 §23 K7）与 `Web.Census.decideContinues`（普查之下，可判定的延续给出 `unceasingFrom` 所需的可判定性） |
| J11 | 记账与用语：(a) 章节 §8 的审查一行过期；(b) 模块数口径不一；(c) “证明它”；(d) “耗尽”；(e) “代价／付出／cost”；(f) 两份记录的审查时间 | (a) 章节 §8 的审查一行更新。(b) P12、P13、P14 的英文段落数的是核心闭包（19、20、21 个模块），P12b、P15、P16 数的是包（19、19、20 个模块）；现在核心闭包 22 个模块、包 20 个模块，此后写明口径。(c) Flow 的说明改为“证明它承担什么”。(d) 章节 §9 改为“取用终止”：`takers_within` 与 `taking_ceases` 约束取用者并使取用停止，存量不必降到零。(e) Dissipation、Roles、Flow 与根模块的说明、记录、§17 与 §18 中的“代价／付出／cost”改为“给予须以取用为条件／giving needs uptake”等，`Brood.costless` 改名为 `Brood.not_dissipative`；这些是建议，Ren 可以改回。(f) 两份记录的审查时间刷新 |

### 22.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Dissipation | `Flow.Enclosed`、`enclosed_of_finite` | 封闭的步：有一个不重复的家族跨该步封闭；条件总共有限时每步都是 |
| Dissipation | `Dissipative.gives_less`、`Dissipative.giving_needs_uptake` | 耗散之下，在封闭的不重复家族上（P16c 补上“不重复”，`Lone.repeated_family`），给予的形成取得多于所给；在封闭的步上，给予须以取用为条件 |
| Dissipation | `Spray.Formation`、`flow`、`web`、`fresh`、`unenclosed`、`dissipative`、`spray` | 汇与每个辅助条件交换：没有封闭的步，耗散空洞地成立，补充者每步给予而不取用 |
| Dissipation | `Lone.Formation`、`flow`、`web`、`balances`、`dissipative`、`lone`、`frontier` | 维持一个吃者：平衡、耗散、没有生起、不是不止地更多，包含池的每个不重复有限家族在任意晚的步都不封闭 |
| Dissipation | `Rooted.web`、`balances`、`census`、`taking`、`acting`、`dependent`、`decActive`、`arises_taking`、`rooted` 与辅助引理 | 生长者依存于池的前沿：全部前提同时成立，`opens_of_arising` 有见证 |
| Dissipation | `Flow.Dissipative.one_ceases`、`witnesses_not_dissipative` | 只有一个条件时，平衡而耗散的流中取用不复现；花园、循环、脉冲、恒定的消耗者、重复的形成与花开都不耗散 |
| Population | `mem_map_of`、`mem_of_map`、`distinct_map`（自 Identity 移入）、`decideSome` | 列表的映射与不重复；在有限表中判定存在 |
| Identity | `Web.no_join` | 新命名保持旧命名的持续活动时，一步前后活跃、跨该步同名的两个形成是一个 |
| Identity | `Web.Census.decideContinues` | 普查之下，可判定的延续给出“是否延续某个活跃形成”的可判定性 |
| Identity | `Fork.forks`、`Fork.split_unceasing` | 一次分裂不使生起失效：`NoSplit` 是充分的，不是必要的 |
| Identity | `Merge.merges`、`decideMerges`、`noSplit`、`merging` | 花园中第 i 个补充者与第 i 个生长者都延续为第 i 个补充者：含合并、没有分裂，形成在任意晚的步生起（P16c：没有形成延续为生长者，持续的生长者每步被读作生起，结论不用更多，`Merge.idle`） |
| Identity | `Dormant.no_split_without_arising` | 没有普查时，没有分裂也不够 |
| Roles | `inl_injective`、`inr_injective`、`inr_not_mem`、`conditionsOf`、`mem_of_conditionsOf`、`conditionsOf_of_mem`、`distinct_conditionsOf`、`total_conditionsOf` | 一类读法的列表辅助 |
| Roles | `Web.roles_census`、`Flow.roles_acting`、`Flow.roles_taking`、`Flow.roles_distinct`、`Flow.roles_dissipative` | 一类读法保持普查、Acting、Taking、present 不重复与耗散（Acting、Taking 与耗散双向） |
| Roles | `SelfBearing.met_iff` | 在 Dependent 与体现之下，自身依存恰在活跃时被满足 |
| Roles | `Embodied.arises_from_embodied` | 只有体现的关系项给予时，给予体现关系项的关系项也体现，并在给予时作为条件而在（P16c 用语，原文“体现关系项的给予者”） |
| Roles | `Web.relabel`、`exists_of_onto`、`relabel_dependent`、`relabel_undermining`、`relabel_alive` | 把条件一侧到上地重新标号，保持 Dependent、侵蚀与 living |
| Roles | `Mutualism.other_twice`、`Mutualism.apart_relabelled` | 以 `other` 重新标号，`apart` 中两者都承担自身，Dependent 不变 |
| Roles | `Wilting.Relatum`、`fade`、`web`、`flow`、`fade_active`、`embodied`、`selfBearing`、`dependent`、`ends`、`wilting`、`swap`、`relabelled_not_embodied` | 花因自身的取用而凋：旁观的蜜蜂与花自己的最后事件都是断裂；以 `swap` 重新标号，花不体现 |
| Roles | `SunSeed.Relatum`、`sprout`、`web`、`flow`、`sun_gives` | 不体现、不依存的太阳是唯一给予种子的关系项（P16c 用语，原文“种子唯一的给予者”） |
| Roles | `Brood.not_dissipative`（原名 `Brood.costless`） | `Brood` 只给予不取用，所以不耗散 |
| Correspondence | `Web.relabel_valuation_connected`、`Web.relabel_interaction_connected` | 到上的重新标号保持两种估值的连通 |
| Correspondence | `Mutualism.apart_embodied` | 体现不进入估值 |

### 22.3 审查列出的会改变判断的结果

1. 有限支撑（J1）：`Enclosed` 与审查提议的定理（`gives_less`），`Spray` 列入记录。完成。
2. 任何持续的取用（J2、J3）：整体的读法按复现的取用重述，`Lone`、`Rooted` 与 `witnesses_not_dissipative` 移入核心。完成。
3. 同一对应（J4、J5）：一类读法的同一对应写为表示前提，`relabel` 移入核心，估值省略体现写明。完成。直接读出体现的估值，开放。
4. 终结与给予（J6、J7）：`ending_breaks` 写为与任何原因的终结同时，`Wilting` 移入核心，Ren 的选择的范围写明；`arises_given` 改题；在只有体现的关系项给予的前提下，给予它的关系项也体现（`arises_from_embodied`），把体现的关系项读作“生”属于 Ren（P16c 更正，原文““生由生”在只有体现者给予的前提下证明”；见 §23 K6）。完成。汲取是否终结了它的因果读法需要反事实的关系，开放（P18b 用语，原文“终结了生命”）。
5. 保持（J8）：五个 `roles_*` 移入核心，界限句删去，`roles_dissipative` 的逆也已证明。完成。
6. 分裂（J9、J10）：以“充分”代替“精确”，`split_unceasing` 列入记录，章节补上前提。完成。延续关系上的充要条件，开放。
7. 记账（J11）：六项完成；用语的最终选择属于 Ren。
8. Ren 的选择：在终结之步的汲取是否计入不 living、对哪些汲取者；接续的读法；“生生不息”读到哪个层次；名称（`Depletes` 与“代价”一族）。本节没有替 Ren 作任何一个选择。

### 22.4 作者反审

*反驳 1：`Enclosed` 是不是只为排除 `Spray` 的特设前提？* 它是有限支撑的陈述：一步中参与的形成只与有限个条件交换。条件总共有限时它自动成立（`enclosed_of_finite`），`Frontier`、`Rooted` 与 `Lone` 每步都满足它（P16c 证明：`Frontier.enclosed`、`Lone.enclosed`）。没有它，耗散的定义对那一步什么也不说，这正是 `Spray` 表明的；把它写为前提，是公开 §17 反驳 1 原来默认的东西。

*反驳 2：既然估值看不见体现，一类读法还有什么用？* 体现进入依存的动力学：`coextinct`、`ends_when_consumed`、`arises_given` 与 §20 的 `generation_opens` 都用它。估值看不见的是体现本身；它经由承担自身进入估值（`SelfBearing.interacts`）。两者是不同的后果，不冲突。

*反驳 3：`Wilting` 表明 `ending_breaks` 是一个坏的读法，应当改定义。* 本节不改：是否把在终结之步的汲取计入不 living、对哪些汲取者，属于 Ren。可供选择的读法至少有三种：照现在的读法计入全部汲取者，包括该关系项自身的最后事件；只计入其汲取使它终结者，这需要反事实的关系（P18b 用语，原文“生命自身”“使生命终结者”）；不让自身依存进入断裂，即不采用 `SelfBearing`，如 `Mutualism.apart`。本节只陈述各自的后果。

*反驳 4：把“代价”改为“给予须以取用为条件”，是不是只是换词？* 对，内容相同；理由是 Ren 在 2026-10-06 对支付一族用语的质疑。名称是建议，Ren 可以改回，`Brood.costless` 的改名同理。

*反驳 5：`relabel` 是不是表明一类读法与两类读法没有区别？* 不是。两类读法检查不到同一对应，这正说明同一对应是一类读法另加的内容。它由表示给出，与跨步的同一由命名给出（§16，I7）是同一类前提：标签不承载任何东西，标签的模式承载对应。

**边界。** 不改变读法选择的地位；不推出责任、义务或任何排序；新名称是建议；探针与新见证都是最小见证；同一对应、只有体现者给予与封闭的步是公开的前提；直接读出体现的估值、汲取是否终结它的因果读法、延续关系上的充要条件，开放。本节的更正经第七次独立审查，见 §23（P18b 补记，原文“本节的更正尚未再经独立审查”；用语原文“终结生命”）。

## 23. 第七次独立审查与更正（P16c）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P15（§20）、P16（§21）与 P16b（§22）（[审查](../history/root-foundation/BECOMING-P15-P16-P16B-REVIEW.md)）。它在仓库之外从前导重新编译核心闭包的 22 个模块，1185 条声明的公理报告全空；计数、回执、哈希、别名与证明绑定都对，数学全部接受。J1–J11 中八项关闭，J1 与 J7 关闭而有过强的表述，J11 关闭而有残余。问题共八项（K1–K8），都在前提的陈述、散文与对应之间，没有数学错误；附无公理的探针。审查没有发现替 Ren 选择生、living、接续、终结或“生生不息”的层次；它指出两个模式：耗散空成立时结论可以由无关的交换满足（省略前提，J1 的同一模式），以及把体现读作生命（替 Ren 选择了“生”的读法）。本节记录逐项处理。探针作为定理移入相应模块；审查列为未构造的一步，相等可判定时被封闭的步围住每个有限家族（`Enclosed.around`），也已证明。§17、§20–§22 中受影响的句子已就地更正并标明；原文见提交 `b24963f1`。

```text
Result(s): 修正 generation-is-replenishment（标题、主张、假设 3、对应、反例、界限、别名）、
           no-finite-part-bears-taking（标题、主张、对应、反例、界限、别名）、
           whole-persists-through-generation（标题、主张、假设 2、对应、反例、界限、别名）、
           life-as-condition-of-life（主张、假设、对应、反例、界限）、identity-across-steps（主张、反例、界限）；
           其余 Becoming 记录只改检验范围；不新增结果记录
Delta: 围住（Around：某个包含家族的不重复有限家族跨该步封闭）与只向内（Inward：给予家族的每个参与形成只从家族取用）；
       耗散之下，从某步起被围住而取用复现的家族汲入（taking_draws_in），体现成员的生成同样（generation_draws_in，
       经由 generation_ceases_on）；相等可判定时被封闭的步围住每个有限家族（Enclosed.around）；
       generation_opens 与 Dissipative.opens 的结论可以由与家族无关的交换满足（SprayHanding）；
       Frontier、Lone 与 Kindling 每步被封闭并汲入；给予未被耗散的家族不必取用（Frontier.gives_without_taking）；
       gives_less 需要不重复（Lone.repeated_family）；覆盖（Covered）是部分生成定理的主语，持续的整体被部分覆盖（Whole.covered），
       不断新的部分（needs_new）；整体是活动的重合（whole_self、Immortal.each_other）；Layered 的成员 Brief 1 而反复生起；
       给予它的体现关系项可以是不依存的太阳（EmbodiedSun；P17 用语，原文“体现的给予者”）；Merge 下的生起是持续形成被重读（Merge.idle），被合并者终结的合并（Confluence）
Supplied premises / correspondence: 新增：汲入的读法需要家族被围住，即每步的交换落在包含家族的有限个关系项之内；
       相等可判定时它由封闭的步给出
Evidence: Becoming.Dissipation 72、Roles 131、Wholes 36、Identity 83 项定理；
          合并检查器回执 20261009T083555.066952Z（728 项定理／1182 项声明审计，核心闭包 22 个模块，包 20 个模块，公理报告全空）；
          外围桥接 20261009T083732.465283Z
Boundary: “生”与 living 的读法（体现的关系项是否读作生在内）、接续的读法、在终结之步的汲取是否计入及对哪些汲取者、
          “生生不息”读到哪个层次、名称（Depletes、给予一族的用语、Brood.not_dissipative），属于 Ren
Integration: K1–K8 全部处理；审查 §4 第 1–5 项完成，各留下的开放结果见 23.3；第 6 项属于 Ren
```

### 23.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| K1 | `generation_opens`（与 P13 的 `Dissipative.opens`）的结论“从某步起不封闭”可以由与家族无关的交换满足：`Dissipative` 只约束被封闭的步；一个汇与不断新的关系项交换时，没有一步被封闭，耗散空成立，两方的家族独自承担生成而没有任何东西流入（`SprayHanding`）。P13 的标题“没有有限部分独自承担持续的取用……须与其外交换”与 P15 的生成句子被它反驳 | 两种更正都做。核心新增围住（`Flow.Around`）与只向内（`Flow.Inward`）。`Dissipative.dissipatesOn_of_inward`：耗散之下，在被围住而只向内的步上家族被耗散。`taking_draws_in`：耗散之下，从某步起被围住、取用在任意晚的步复现的不重复有限家族，在任意晚的步有形成给予它而从其外取用。Roles 中 `Embodied.arising_lowers_on` 与 `generation_ceases_on`（从某步起被耗散的家族中体现成员不在任意晚的步生起）推出 `generation_opens` 与 `generation_draws_in`。审查列为未构造的一步也已证明：相等可判定时，被封闭的步围住每个有限家族（`Enclosed.around`，经由 `adjoin`）；条件总共有限时每步围住每个家族（`around_of_finite`）。`SprayHanding` 移入 `Roles`；`Kindling`、`Frontier` 与 `Lone` 是正面见证。两份记录的标题、generation-is-replenishment 的假设 3、两处对应、§17 与 §20 的标题与解读、章节、根模块与检查器的范围文字改为字面结论，加上被围住时的汲入 |
| K2 | “在耗散之下，给予家族者从家族取用”省去“被耗散的家族（封闭、不重复）”（`Frontier.gives_without_taking`） | §20 的解读、英文 P15 段落与章节 §2 补上“被耗散的家族”。`Frontier.gives_without_taking` 移入核心：流耗散，太阳每步给池而不从池取用，池的家族不封闭 |
| K3 | “整体的持续就是部分的生成”主张同一，`Gaps` 反驳它。`Whole` 是活动的重合（`whole_self`、`each_other`），两个定理只用到它的一个方向（`arises_within_of_cover`、`needs_arising_of_cover`）。在 `Brief` 之下生成可以是两个部分反复生起（`Layered`），在 `Ends` 与 `Listed` 之下须有新的部分（`needs_new`）。“张力消失”过强 | 覆盖（`Web.Covered`：从某步起每步有部分活跃）成为两个定理的主语：`Covered.arises_within`、`Covered.needs_arising` 与 `Covered.needs_new`。`Whole.covered` 把持续的整体接到覆盖上，`Whole.arises_within`、`Whole.needs_arising` 与新增的 `Whole.needs_new` 由此推出，陈述不变。`Web.whole_self` 与 `Immortal.each_other` 移入核心，Wholes 的说明改为“一种部分与整体的关系，活动的重合”。“就是”改为“经由／需要”，“构成”删去；§21 的“对生生”按前提重述：Ends 与 Listed 之下是不断新的成员，Brief 之下只是反复生起，两者都不是数目增长 |
| K4 | 记录标题、章节英文 §1、§9 的 Wholes 一行与术语表的“部分不长久”省去 `Listed`，`Countless` 表明它必要 | 记录标题、章节 §1（中英）、§9、术语表、Wholes 的标题与根模块写明“部分短暂，或部分终结且同时活跃的部分有限”；记录假设 2 写明 `Listed` 是有限性前提，不是对长久的陈述 |
| K5 | §21 反驳 3 说 `Layered` 的成员 `Brief` 不成立，这是错的（`layered_brief`、`layered_within`） | 反驳 3 就地改写：`Layered` 的成员 `Brief 1`，`arises_within` 适用；它们不终结，`needs_arising` 不适用；`Brief` 不说部分终结，允许同样的部分反复生起。`Layered.brief`、`Layered.within` 与 `Layered.arise_again` 移入 Wholes。前提不必要的见证（活动段无界增长的部分）没有构造，列为开放 |
| K6 | “生由生”被写为已证明，把体现读作生命；体现的给予者可以是一个只以水平作为条件而在、不依存于任何东西的太阳（`EmbodiedSun`） | `EmbodiedSun` 移入 `Roles`（`embodied_sun`）。§22.1 J7、§22.3 第 4 项、life-as-condition-of-life 的主张、假设、对应与界限，以及 `SunSeed` 的说明改为：在只有体现的关系项给予这一表示前提下，给予它的关系项也体现；体现是作为条件而在的表示，不是是生命的表示；把体现的关系项读作“生”是 AI 读法，属于 Ren。审查可选的局部前提（只要求在该步给予该关系项者体现）没有采用，全局前提照旧公开 |
| K7 | `Merge` 下的不息生起是虚假的：没有形成延续为生长者，持续的生长者每步被读作生起，结论不用更多（`merge_idle`） | `Merge.idle` 与 `Confluence` 移入 `Identity`：被合并的 `a` 在合并之后不活跃，没有分裂，合并下生起的恰是每步的新形成。`merging` 的说明改为“前提在含合并的延续下成立，结论空洞地满足”；Identity 的说明、检查器范围、§22 与记录改正。由更多做功的含合并普查见证与合并迫使重读的计数论证没有构造，列为开放 |
| K8 | 记账与用语八项 | (a) §20 引言的“补充须付出所取”改为“给予须以取用为条件”。(b) 计划的 P15 一行改为 `Brood.not_dissipative` 与字面结论。(c) “给予者／giver”在 Roles、根模块、检查器范围、记录与 §17–§22 的现行文字中改为“给予它的关系项／形成”，假设 `givers` 改名为 `gives_embodied`；引述与更正标记中的原文保留；用语最终属于 Ren。(d) Dissipation 的说明改为“某个参与的形成与无穷多个条件交换的步不被封闭”。(e) `gives_less` 在 §22 的 Delta 与 22.2 补上“不重复”，`Lone.repeated_family` 移入核心。(f) `Frontier.enclosed` 与 `Lone.enclosed` 移入核心，§22.4 反驳 1 有了证明。(g) whole-persists-through-generation 的审查时间与其余四份同时刷新。(h) 英文 P15、P16 段落的“core”改为“package” |

### 23.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Dissipation | `Flow.Around`、`Flow.Inward` | 围住：某个包含家族的不重复有限家族跨该步封闭。只向内：给予家族的每个参与形成只从家族取用 |
| Dissipation | `around_of_finite`、`Flow.Enclosed.around` | 条件总共有限时每步围住每个家族；相等可判定时，被封闭的步围住每个有限家族 |
| Dissipation | `Dissipative.dissipatesOn_of_inward`、`Flow.taking_draws_in` | 耗散之下，被围住而只向内的步上家族被耗散；所以从某步起被围住、取用在任意晚的步复现的家族，在任意晚的步有形成给予它而从其外取用 |
| Dissipation | `total_le_of_support`、`decideMem`、`insertNew`、`insertNew_spec`、`adjoin`、`adjoin_spec` | 有限和与列表的辅助：不重复列表上的和不超过列出其正值处的任何列表上的和；相等可判定时列表成员可判定；把一个列表的成员不重复地并入另一个 |
| Dissipation | `Frontier.closed`、`pool_fuel_distinct`、`enclosed`、`around`、`draws_in`、`gives_without_taking` | 前沿每步被池与当步的燃料封闭，围住池，池的家族汲入燃料；太阳给池而不从池取用，池的家族不封闭 |
| Dissipation | `Lone.closed`、`enclosed`、`draws_in`、`repeated_family` | 恒定的取用者每步被封闭，池的家族汲入；列出池两次的家族上太阳所给与所取相等 |
| Roles | `Embodied.arising_lowers_on`、`generation_ceases_on`、`generation_draws_in` | 被耗散家族中体现成员的生起降低存量；从某步起被耗散的家族中体现成员不在任意晚的步生起；被围住的家族中复现的体现生成汲入。`arising_lowers` 与 `generation_opens` 由前两者推出 |
| Roles | `SprayHanding.Relatum`、`flow`、`web`、`sides`、`sides_distinct`、`bound`、`le_bound`、`fresh`、`balances`、`acting`、`dependent`、`unenclosed`、`dissipative`、`even_sum`、`spray_handing`、`opens_anyway`、`taking_opens_anyway` | 两方来回传递，一个汇每步从一个新的辅助关系项取一份又还给它：没有一步被封闭，耗散空成立，生成与取用在两方的家族中复现而没有东西流入，`generation_opens` 与 `Dissipative.opens` 的结论由汇满足，没有一步围住两方 |
| Roles | `Kindling.around`、`Kindling.draws_in` | 两方的家族每步被两方与所燃的燃料围住，在任意晚的步给予它的一方从燃料取用 |
| Roles | `EmbodiedSun.web`、`balances`、`acting`、`gives_embodied`、`embodied_sun` | 太阳的水平取一：`arises_from_embodied` 的全部前提成立而它命名不依存于任何东西的太阳 |
| Wholes | `Web.Covered`、`Covered.arises_within`、`Covered.needs_arising`、`Covered.needs_new`、`Whole.covered`、`Whole.needs_new` | 部分覆盖从某步起的每一步时，两个定理与不断新的部分；持续的整体被部分覆盖 |
| Wholes | `Web.whole_self`、`Immortal.each_other` | 每个形成是它自身的整体；两个每步都活跃的形成互为整体 |
| Wholes | `Layered.brief`、`Layered.within`、`Layered.arise_again`（`Layered.composed` 移入同一命名空间） | `Layered` 的成员 Brief 1，每步都有成员生起，每次生起是两者之一，它们的活动不终结 |
| Identity | `Merge.idle` | 合并下第一个生长者每步被读作生起，结论不用更多；每个形成只延续自身时它只在第零步生起 |
| Identity | `Confluence.Formation`、`web`、`continues`、`ended`、`noSplit`、`confluence` | 被合并的形成终结的合并：没有分裂，合并下生起的恰是每步的新形成 |

### 23.3 审查列出的会改变判断的结果

1. 汲入（K1、K2）：`Around` 与汲入定理移入核心，以 `Kindling` 与 `Frontier` 为见证；标题改为字面结论，`SprayHanding` 列入记录，假设 3 改正；“被耗散的家族”在三处补上。两种做法都完成。不以围住为前提的汲入（交换越出每个有限家族的步上）没有陈述，开放。
2. 整体（K3–K5）：“需要／经由”，`needs_new` 与覆盖形式，按前提重述“张力”，标题与术语表加入 `Listed`，反驳 3 改正，`Whole` 写为活动的重合。完成。前提不必要的见证，开放。
3. 给予（K6）：“生由生已证明”删去，写为“在只有体现的关系项给予这一前提下，给予它的关系项体现”，体现的关系项是否读作“生”留给 Ren。完成。
4. 合并（K7）：`Merge` 改正说明，`Confluence` 是被合并者终结的见证。完成。由更多做功的含合并普查见证，开放。
5. 记账（K8）：八项完成；用语的最终选择属于 Ren。
6. Ren 的选择：“生”与 living 的读法（体现的关系项是否读作生在内）、接续、“生生不息”读到哪个层次、在终结之步的汲取是否计入及对哪些汲取者、名称（`Depletes`、给予一族、`Brood.not_dissipative`）。本节没有替 Ren 作任何一个选择。

### 23.4 作者反审

*反驳 1：围住是不是又一个为排除反例而加的前提？* 它是 §22 的 `Enclosed` 对一个家族的形式：一步中参与的形成只与包含该家族的有限个条件交换。相等可判定时，任何被封闭的步都围住每个有限家族（`Enclosed.around`），所以它没有在“交换有限”之外多要求什么。`SprayHanding` 表明，没有它，“须从其外汲入”就不成立：耗散空成立时，有限家族可以独自承担生成，结论由与它无关的交换满足。

*反驳 2：既然 `Whole` 只是活动的重合，部分与整体的关系还有什么内容？* 内容在覆盖：部分在每步接上，整体才每步活跃。定理用到的正是覆盖（`Covered`），整体只是给覆盖一个名字。这也说明了为什么整体的依存与侵蚀没有从部分推出（§21 反驳 2）：活动的重合不承载依存。构成的关系需要别的表示，开放。

*反驳 3：“生生不息”在整体层次上读，是否就不再要求“不断创造”？* 看前提。部分终结且同时活跃的部分有限时，整体的持续要求不断有新的部分生起（`needs_new`），这是一种“不断创造”；部分只是短暂时，同样的部分反复生起就够了（`Layered`）。两者都不要求数目增长，所以“更多”没有由整体的持续推出。读到哪个层次，仍属于 Ren。

*反驳 4：既然 `arises_from_embodied` 不证明“生由生”，一类读法对生命还说了什么？* 它说的是关系项作为条件而在的结构：依存于体现关系项的形成只在它活跃时活跃（`active_of_bearing`、`coextinct`；P18b 更正，原文“生命以其他生命为条件”），体现的生起由另一个活跃者的给予承担（`arises_given`），在只有体现者给予的表示中给予它的也体现。哪些体现的关系项是生命，是对“生”的读法，属于 Ren；`EmbodiedSun` 表明这一读法不由定理给出。

**边界。** 不改变读法选择的地位；不推出责任、义务或任何排序；新名称是建议；探针与新见证都是最小见证；围住是汲入读法公开的前提；不以围住为前提的汲入、前提不必要的见证、由更多做功的含合并普查见证与构成的关系，开放。本节的更正经第八次独立审查，见 §27。

## 24. 储备：活动越过支持，水平越过活动（P17）

2026-10-09。按同一指示继续。开放纲领自 P6 起在“动态依存”一行列出“放宽 `Dependent`（缓冲、储备、滞后）”；§18 写明种子库、储备与休眠被 `Dependent` 排除，在它们之下共灭不必成立；§20 反驳 5 写明活动与水平不同步（种子、休眠）时生成承担什么是下一步。两处的共同点是所持之物：活动可以越过支持，靠所持的储备；水平可以越过活动，如休眠的种子。按非二元方法，在流与所持条件被表示的地方，储备不作为新的原语：它是形成所持的一个条件的水平；没有表示所持条件时，储备是给定的量（P18b 更正，原文“储备不作为新的原语：它是形成所持的一个条件的水平”；见 §27 L4）。本节陈述储备承担什么，并把 §20 与 §23 的结论推到它们实际用到的东西上：生起的关系项开始作为条件而在。成果记录：[reserve-defers-ending](../../../../theories/becoming/results/records/reserve-defers-ending.md)；[generation-is-replenishment](../../../../theories/becoming/results/records/generation-is-replenishment.md) 随之推广。

```text
Result(s): 复用 becoming-dependence-dynamics（Supported、Dependent、consumed_ends_when_fixed、arises_at_a_step）、
           becoming-renewal-reading（falls_finitely）、life-as-condition-of-life（Embodied、coextinct）、
           more-needs-renewers（流、平衡）；新增 reserve-defers-ending（L3 Becoming.Reserve）；
           推广 generation-is-replenishment（ComesToStand 移入 Flow 与 Dissipation，§20 与 §23 的体现定理改由它推出）
Delta: 储备（Carries）：不被支持时不上升，活跃时下降；零储备恰是 Dependent（carries_zero）；
       储备可以是所持条件的水平（Flow.carries_of_held；P18b 更正，原文“储备是”）；依存失效而活跃时储备为正（Carries.pos）；
       从某步起不被支持，只在有限多步活跃，次数不超过开始时的储备（active_finitely、lasts、lasts_within）；
       滞后的终结与滞后的共灭（consumed_lasts、coextinct_lasts）；不被支持时休眠只推迟生起（arising_finitely），储备在休眠中衰减时休眠在时间上有界（Decays、ends_within）；
       开始作为条件而在（Web.ComesToStand）：平衡的流中被给予新水平（Balances.standing_given），
       在家族中复现时补充复现（standing_needs_replenishment）；降低被耗散家族的存量，从某步起被耗散的家族中不复现
       （standing_lowers_on、standing_lowers、standing_ceases_on）；耗散之下在不重复有限家族中复现时，家族在任意晚的步不封闭，
       被围住时汲入（standing_opens、standing_draws_in），条件总共有限时不复现（standing_ceases）；
       体现的生起就是开始作为条件而在（Embodied.comesToStand、Embodied.coming）；
       活跃时作为条件而在的关系项，若先前某步不在，就在其间某步开始作为条件而在（came_to_stand）；
       见证 Seed、Viable、Famine（含依存转化的读法）、Sleeper、Provisioned
Supplied premises / correspondence: Carries 是表示前提，哪个条件是一个形成所持的由应用给出；carries_of_held 需要平衡、
       不被支持时没有给予所持条件、活跃时从中取用；Carries.lasts 需要活动可判定（定理的假设，不是公理）；Decays 是另设的表示前提，只用于 ends_within；物理内容是所持之物有限
Evidence: Becoming.Reserve 35 项定理；Flow 新增 4 项（含自 Dissipation 移入的 eq_zero_of_not_pos）、Dissipation 新增 6 项（移出 1 项）、Roles 新增 2 项；
          合并检查器回执 20261009T090231.312129Z（774 项定理／1257 项声明审计，核心闭包 23 个模块，包 21 个模块，公理报告全空）；
          外围桥接重跑 20261009T090346.438363Z
Boundary: 结论约束从某步起不被支持的形成，不约束支持是否回来；Carries 之下休眠不耗用储备，休眠的时间只在 Decays 之下有界；沿依存链的滞后没有陈述；
       不含伦理谓词
Integration: 回答开放纲领“放宽 Dependent（缓冲、储备、滞后）”、§18 共灭的范围与 §20 反驳 5；§20 与 §23 的体现定理成为
       开始作为条件而在的特例
```

[Becoming.Reserve](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Reserve.lean)（L3，导入 `Becoming.Roles`），以及 [Becoming.Flow](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Flow.lean)、[Becoming.Dissipation](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Dissipation.lean) 与 [Becoming.Roles](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Roles.lean) 新增的声明：

| 声明 | 内容 |
|---|---|
| `Web.Carries`、`carries_zero` | 储备：在形成不被支持的一步上不上升，若它在该步活跃则下降。零储备恰是 `Dependent` |
| `Flow.carries_of_held`、`Carries.pos` | 平衡的流中，持有者不被支持时没有给予、持有者活跃时被（参与的任何形成）取用的条件，以其水平承载持有者（P18b 更正，原文“活跃时被它取用”）。依存失效而仍活跃的形成储备为正 |
| `Carries.active_finitely`、`Carries.step`、`Carries.lasts`、`Carries.lasts_within`、`mark`、`mark_cases` | 从某步起不被支持的形成只在有限多步活跃；在任一段步上，活跃的次数加上结束时的储备不超过开始时的储备；容量为 k 时活跃至多 k 次 |
| `unsupported_after_loss`、`Carries.consumed_lasts` | 没有回程而依存不变的损失之后，形成不再被支持，靠储备只在有限多步活跃（滞后的终结） |
| `unsupported_after_end`、`Carries.coextinct_lasts` | 体现的关系项终结之后，以正需要依存于它的形成不再被支持，靠储备只在有限多步活跃（滞后的共灭） |
| `Carries.arising_finitely` | 从某步起不被支持的形成只在有限多步生起：休眠推迟终结而不逃脱 |
| `Web.Decays`、`Carries.decays_by`、`Carries.ends_within` | 储备衰减：在形成不被支持而储备为正的每一步都下降，不论形成是否活跃（种子的存活力）。从某步起不被支持，经过 n 步后储备已下降 n 或已耗尽；经过与开始时储备一样多的步之后，形成不再活跃：休眠在时间上也有界 |
| `Web.ComesToStand`、`Balances.standing_given`、`Balances.standing_replenishes`、`standing_needs_replenishment`（Flow） | 开始作为条件而在：此前水平为零，此后为正。平衡的流中至少被给予新的水平，于是补充每个包含它的家族；家族的成员在任意晚的步开始作为条件而在时，家族的补充复现，不论取用什么 |
| `standing_lowers_on`、`standing_lowers`、`standing_ceases_on`、`standing_opens`、`standing_draws_in`、`standing_ceases`（Dissipation） | 被耗散家族的成员开始作为条件而在，降低家族的存量（给予它的形成从家族取用更多）；耗散之下，跨该步封闭的不重复家族正是如此。从某步起被耗散的家族中，成员不在任意晚的步开始作为条件而在。耗散之下，成员在任意晚的步开始作为条件而在的不重复有限家族，从任何一步起都不封闭；从某步起被围住时，它汲入：在任意晚的步有形成给予它而从其外取用；条件总共有限时，没有条件在任意晚的步开始作为条件而在 |
| `Embodied.comesToStand`、`Embodied.coming`（Roles） | 体现的关系项在生起时开始作为条件而在；§20 与 §23 的 `given_of_arises`、`replenishes`、`generation_needs_replenishment`、`arising_lowers_on`、`generation_ceases_on`、`generation_opens`、`generation_draws_in` 与 `generation_ceases` 改由上述一般定理推出，陈述不变；`arising_lowers` 经由 `arising_lowers_on` |
| `came_to_stand` | 活跃时作为条件而在的关系项，在某步没有水平而在后来某步活跃，就在其间某步开始作为条件而在 |
| `Seed.web`、`dark`、`carries`、`seed` | 黑暗中的种子以需要一依存于光，在第 1 与第 3 步醒来：不满足 `Dependent`，储备承载它，它生起两次后不再活跃，醒着的次数恰等于开始时的储备 |
| `Seed.not_decays`、`Viable.viability`、`web`、`dark`、`carries`、`decays`、`viable` | `Seed` 的储备在休眠中保持，不衰减；存活力为三、每步下降的种子在黑暗中第 2 步醒来，第 3 步起不再活跃：不满足 `Dependent`，`ends_within` 的时间界可以达到 |
| `Famine.web`、`flow`、`hold`、`balances`、`carries`、`hare_embodied`、`transformed`、`transformed_dependent`、`famine` | 狐依存于体现的兔，兔在第 0 步之后终结；狐的脂肪是流中的条件，狐在第 1、2 步各燃一单位。流平衡，脂肪承载狐，狐恰好多活两步；把狐的依存读作在兔终结后转到脂肪上，同一展开满足 `Dependent` |
| `Sleeper.web`、`flow`、`sleeper` | 一个关系项始终以水平一作为条件而在，在奇数步醒来；流中没有形成参与，流平衡，耗散空成立，`Dependent` 成立，生成不息而没有任何给予；它不体现，也从不开始作为条件而在 |
| `Provisioned.web`、`flow`、`balances`、`acting`、`provisioned` | 父代在第 0 步给予种子一单位，种子休眠一步，从第 2 步起活跃：种子在休眠时开始作为条件而在，被给予它的水平；它在第 1 步生起时没有任何给予 |
| 其余（`Seed.wake`、`reserve`、`Famine.Relatum`、`hare`、`fat`、`eats`、`burns`、`present`、`source`、`supported_of_ne_fox`、`fed`、`Provisioned.Relatum`、`late`、`gift`） | 见证的辅助定义与引理；`eq_zero_of_not_pos` 自 Dissipation 移入 Flow |

**解读。**

- **`Dependent` 是零储备。** “活动只在有支持处”与“储备为零”是同一个陈述（`carries_zero`）。放宽它不是让活动离开依存，而是允许所持的储备。§6 以来依赖 `Dependent` 的结论（损失的三种结局、共灭、替代）都是零储备的情形；有储备时，它们推迟而不消失。
- **储备可以是所持的条件（P18b 更正，原题“储备是所持的条件”）。** 在平衡的流中，一个条件在持有者不被支持时没有给予、在持有者活跃时被取用，它的水平就是储备（`carries_of_held`）；没有表示所持条件时，储备是给定的量（§27 L4，`Seed.no_held`）。依存失效而仍活跃的形成，储备为正：对所持之物、需要为一的依存被满足。所以在所持条件承载它的地方有两种表示：依存于兔而有储备（不满足 `Dependent`），或依存在兔终结后转到脂肪上（满足 `Dependent`，`Famine.transformed_dependent`）。在那里，滞后就是依存转化到所持的条件上，这是 §6 `consumed_continues_transformed` 所说的转化的一种；它是对储备的重新描述，两种表示在 living 上不同（§27 L6）。缓冲不在依存之外。
- **推迟而不逃脱。** 从某步起不被支持的形成只在有限多步活跃，次数不超过开始时的储备（`lasts`）。没有回程的损失之后（`consumed_lasts`）与所依存的体现关系项终结之后（`coextinct_lasts`），形成在支持之外至多再活跃其储备那么多次；`Famine` 中狐恰好多活两步，即脂肪的两单位。这与 §13 的“替代推迟终结而不逃脱”（`substitution_defers`、`Relay`）是同一模式：所推迟的靠一个不再被补充的条件。休眠同样：不被支持时，醒来只有有限多次（`arising_finitely`、`Seed`）。`Carries` 只在活跃时耗用储备，所以休眠本身可以任意长；储备在休眠中也衰减时（种子的存活力），经过与储备一样多的步之后形成不再活跃（`ends_within`、`Viable`）。
- **生成承担补充，在开始作为条件而在之处。** §20 与 §23 用到的体现只有一点：水平跨生起之步上升，体现时从零上升（P18b 更正，原文“生起时水平从零上升”；见 §27 L7，一般的定理对任何上升陈述）。所以一般的定理在条件上：任何条件开始作为条件而在，在平衡的流中都被给予它的新水平；在耗散之下，在不重复有限家族中复现，家族就在任意晚的步不封闭（`standing_opens`），这一交换可以与家族无关（§23 的 `SprayHanding`），家族被围住时它汲入（`standing_draws_in`）。体现的关系项在生起时开始作为条件而在（`Embodied.comesToStand`），§20 与 §23 关于体现的九个定理都由此推出。这把要求放在它实际所在之处：不在活动的上升，而在水平的上升。
- **水平越过活动。** 活跃时作为条件而在的关系项，若先前某步不在，就在活跃之前开始作为条件而在（`came_to_stand`），可以早得多：种子在休眠时被父代给予它的水平，此后生起时没有任何给予（`Provisioned`）。从休眠中醒来是生起而不开始作为条件而在：一个始终作为条件而在的关系项可以不息地醒来，不需要任何给予（`Sleeper`；它的流中没有形成参与，耗散空成立，所以这里没有陈述耗散的世界中醒来会怎样）。所以对生起的约束在两头：开始作为条件而在需要补充；醒来若耗用所持的储备而没有支持，只有有限多次。两者都不约束靠回来的支持而醒来。
- **对生生（作者的读法）。** Ren 的原话是“生生不息 - 一种整体的，不断创造更多生的方向”。所持之物使一个形成越过它的支持延续，也使一个关系项在它的活动之前就已作为条件而在。这里读出的是：没有支持，所持之物只推迟终结；不断的生起若是关系项开始作为条件而在，就需要不断的补充。把这些形成与关系项读作“生”属于 Ren（§23 K6）。作者把这读作“不息”不能由所持之物独自承担的一种形式内容（AI 论证），不替代原话，不推出它是好的，也不决定生生读到哪个层次。

**作者反审。**

*反驳 1：`Carries` 只是把 `Dependent` 换成一个更弱的前提，没有说明什么。* 它说明 `Dependent` 是零储备，并给出储备的数量后果：延续至多是开始时的储备，界可以达到（`Seed`、`Famine`）。它也说明储备不是新的原语：它可以是流中所持条件的水平（`carries_of_held`）。

*反驳 2：依存转化的读法是否只是把结论编进表示？* 两种表示的水平、活动、汲取与流都相同，只是依存于什么不同。`Famine` 证明两种读法都成立；哪一种更合适，取决于应用把脂肪读作狐的一部分还是狐所依存的另一个条件。（P18b 更正，原文“两种表示描述同一展开”与“一般地构造转化的读法需要“是否被支持”可判定，这里只给出见证”：两种读法的 living 不同，狐在第 1 步的事件按原读法侵蚀、按转化的读法不侵蚀（`Famine.living_differs`），所以选择不是对估值中立的，是对应前提；一般的构造已给出（`Web.redirect_dependent`），它满足 `Dependent` 由构造给出，是对储备的重新描述。见 §27 L6。）

*反驳 3：休眠不耗用储备，这不太强了吗？* 是一个选择：`Carries` 只要求活跃时下降，所以只靠它，休眠可以任意长。衰减是另一个前提（`Decays`）：在它之下休眠的时间有界（`ends_within`），`Viable` 达到这个界；`Seed` 表明 `Carries` 不蕴含衰减（`Seed.not_decays`）。两者分开陈述，应用选择哪一个。

*反驳 4：`ComesToStand` 的推广是否平凡？* `standing_given` 几乎由平衡直接给出，就像 §20 的 `given_of_arises`。内容在于定位：§20 与 §23 的结论用到的不是体现，而是水平上升，体现时从零上升（P18b 更正，原文“水平从零上升”）；`Sleeper` 与 `Provisioned` 表明，活动与水平不同步时，要求跟着水平走，而不跟着活动走。§23 的更正（开放的交换可以无关，汲入须家族被围住）原样适用于开始作为条件而在。

*反驳 5：狐“多活两步”只是见证里写定的时程。* 对，见证写定了活动；定理说的是任何满足前提的展开都至多如此，`Famine` 表明界可以达到，`Seed` 表明在休眠与醒来交替时也如此。

*反驳 6：`Sleeper` 的耗散是空的，它没有说明耗散的世界中的休眠。* 对。`Sleeper` 只表明 §20 的结论不约束不开始作为条件而在的生起；没有支持时，醒来所耗用的是 `Carries` 陈述的储备，不是补充；储备与耗散的关系这里没有陈述。（P18b：反驳 5 与 6 的次序按编号排列。）

**边界。** 不含伦理谓词；`Carries` 与所持的条件是表示前提，物理内容是所持之物有限；结论约束从某步起不被支持的形成，不约束支持是否回来；`Carries` 之下休眠不耗用储备，休眠的时间只在另设 `Decays` 时有界；开放与汲入沿用 §23 的形式：开放可以由无关的交换满足，汲入须家族被围住；沿依存链的滞后共灭没有陈述（P18b 更正，原文“沿依存链的滞后共灭、一般的转化读法没有陈述”：一般的转化读法见 §27 L6）；见证都是最小见证。本节经第八次独立审查，见 §27。

## 25. 世系：关系项经由所依与所给直接相关（P18）

2026-10-09。按同一指示继续。§18 记下：两种估值只经由共同的条件关联事件，所以体现不进入估值；只依存于对方的蜂与花都体现、互相依存，却不相关（`Mutualism.apart_embodied`）。life-as-condition-of-life 把“直接读出体现的估值（把汲取者与它所汲取的体现关系项的事件关联）”列为下一步。另一方面，`Becoming.Metaethics` 把 `related` 读作形成的关系，明列条件、依存、世系与合作；此前没有任何读法给出世系，而世代各由前一代给予的 `Brood` 在两种估值下完全不相关。本节在一类关系项的读法中给出两种直接的关系，并陈述它们对 G0 的传递意味着什么。成果记录：[living-on-and-descent](../../../../theories/becoming/results/records/living-on-and-descent.md)。

```text
Result(s): 复用 condition-correspondence-discipline（Interacts、Bearing、interaction、Connected.transfer、relabel_*_connected）、
           life-as-condition-of-life（一类读法、Embodied、arises_given、active_of_bearing、relabel、Brood、Mutualism.apart）、
           generation-is-replenishment（ComesToStand、Embodied.comesToStand、Provisioned、Sleeper）、
           metaethical-core-characterization（Valuation、transmits、significant_iff）；新增 living-on-and-descent（L4 Becoming.Descent）
Delta: 以之为生（LivesOn：在某步汲取一个关系项并以正需要依存于它）与世系（Descends：参与某步并在该步给予一个关系项、它跨该步开始作为条件而在；
       P18b 更正，原文不要求参与），作为交互之外的两种 related（sustenance、descent）；以之为生不是免费的（LivesOn.stands；LivesOn.active 另需体现；P18b 更正）；在 N_rel 之下沿两者的传递
       （living_on_reaches、lived_on_reaches、descent_reaches、ancestry_reaches）；平衡且 Acting 的流中生起的体现关系项从给予它的形成而来，
       珍视那个形成到达生起者的活的事件（Embodied.descends、arisen_reached）；世代由世系连通，G0 在那里有刻画（Brood.descended）；
       同一对应进入以之为生（Mutualism.relabel_sustenance）；世系跟着水平走（Provisioned.descends、Sleeper.no_descent）
Supplied premises / correspondence: 两种关系是 related 的候选读法，是否算作 N_rel 所传递的形成关系由 Ren 选择；N_rel 仍是前提；
       一类读法的同一对应由共同的索引给出；arisen_reached 需要平衡、Acting 与体现
Evidence: Becoming.Descent 的 25 项定理；合并检查器回执 20261009T091503.719598Z（799 项定理／1286 项声明审计，核心闭包 24 个模块，
          包 22 个模块，公理报告全空）；外围桥接重跑 20261009T091616.753919Z
Boundary: 不改变 living 与 C，不推出生起是好的或应当带来新的生起；世系使两个关系项的所有事件相关，不排定时间；给予的形成不必体现；
       只对逐步读法陈述；不含伦理结论
Integration: 回答 life-as-condition-of-life 的下一步与 §18 的 Mutualism.apart；给出 Metaethics 所列“世系”的第一种读法
```

[Becoming.Descent](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Descent.lean)（L4，导入 `Becoming.Correspondence` 与 `Becoming.Reserve`）：

| 声明 | 内容 |
|---|---|
| `Web.LivesOn`、`Web.sustenance`、`interaction_sustenance` | 以之为生：一个形成在某步汲取一个关系项，并以正需要依存于它。这样的事件与该关系项的每个事件相关；与交互合起来是 `sustenance`，它扩展交互的连通 |
| `LivesOn.active` | 以之为生不是免费的：在 `Dependent` 之下，活跃的形成以之为生的关系项若体现，就在该步活跃（P18b 更正，原文“只以在该步活跃的体现关系项为生”；体现是定理的假设，`Dependent` 本身给出的是 `LivesOn.stands`，见 §27 L8） |
| `living_on_reaches`、`lived_on_reaches` | 在 N_rel 之下，珍视一个以某关系项为生的事件，就珍视该关系项的每个活的事件；珍视该关系项的任一事件，就珍视以它为生的每个活的事件 |
| `Flow.Descends`、`Flow.descent`、`interaction_descent` | 世系：一个关系项从一个形成而来，当后者参与某步、在该步给予它，而它跨该步开始作为条件而在（P18b 更正，原文“当后者在某步给予它”，不要求参与；见 §27 L10）。世系使两个关系项的每个事件相关；与交互合起来是 `descent` |
| `descent_reaches`、`ancestry_reaches` | 在 N_rel 之下，珍视一个形成的任一事件，就珍视由它而来的关系项的每个活的事件，反之亦然 |
| `Embodied.descends`、`arisen_reached` | 在平衡且只有活跃形成给予的流中，生起的体现关系项从在该步活跃的另一个形成而来；于是在 N_rel 之下，珍视那个形成的任一事件，就到达生起者的每个活的事件 |
| `Brood.descended`（及 `birth_next`、`descends`、`alive_of_stands`、`self_alive`、`down`、`up`、`descent_connected`、`participates`、`not_coparticipating`、`not_interacting`） | 世代各由前一代给予：世系使它们连通，共同参与与交互都不连通它们；G0 在那里恰等于种子加 N_rel 加 N_std |
| `Mutualism.apart_sustenance_connected`、`other_other`、`relabel_sustenance` | 只依存于对方的蜂与花由以之为生连通；把它们的条件互换，共同参与与交互的连通不变（都不连通），以之为生的连通消失 |
| `Provisioned.descends`、`Sleeper.no_descent` | 种子从在它休眠时供给它的父代而来，此后生起时没有给予；从休眠中醒来不从任何形成而来，而生成不息 |

**解读。**

- **一类读法提供的关系。** 两类的表示中，形成与条件分开，所以事件只能经由一个共同的条件相关。一类读法中，一个形成所依的条件可以就是另一个关系项。以之为生与世系是这一读法才有的关系：前者是一个形成所依、所取的关系项，后者是一个关系项开始作为条件而在时所由来的给予。它们不是加在展开之外的东西，而是同一展开中已经有的汲取、依存与给予，在“哪个条件就是哪个关系项”的对应之下的读法。所以它们依赖这一对应（`relabel_sustenance`）：§22 J4 写明同一对应是表示的前提，J5 写明体现不进入两种估值；这里一类读法的同一对应第一次进入估值，`sustenance` 与 `descent` 的定义不含体现（P18b 更正，原文“这里体现第一次进入估值，正是经由这一对应”；见 §27 L9）。
- **不是免费的连通。** 交互要求依存能落空，以之为生同样要求实际的汲取与正需要的依存：在 `Dependent` 之下，所依的关系项在该步作为条件而在（`LivesOn.stands`），它体现时在该步活跃（`LivesOn.active`）（P18b 更正，原文“只能以在该步活跃的体现关系项为生”）。世系要求参与该步的形成正的给予与开始作为条件而在，空的给予与不参与者的给予项都不造成它（P18b 更正，原文“世系要求正的给予与开始作为条件而在，空的给予不造成它”：原定义不看给予者是否参与，不参与者的给予项曾造成世系，见 §27 L10）。所以 §10（P9）排除的免费连通没有回来。
- **珍视的传递。** 在 N_rel 之下，珍视狐的进食就到达兔的活；珍视兔的任一事件也到达以兔为生的狐的活的事件（`living_on_reaches`、`lived_on_reaches`）。这与 §12（P9b）的 `drawing_reaches` 同构：传递由使用承担，不由侵蚀承担。世系的传递沿着给予：生起的体现关系项总有一个给予它的活跃形成（§18 的 `arises_given`），所以珍视那个形成到达生起者的活的事件（`arisen_reached`）。
- **世系使世代成为一个整体。** `Brood` 的每一代只依存于自身、什么也不汲取，所以在共同参与与交互下各自孤立；世系使它们连通，于是 G0 在那里的刻画适用（`Brood.descended`）。在把体现的关系项读作“生”这一属于 Ren 的读法下（§23 K6），作者把它读作原话中两个“生”之间关系的一种形式内容：生起者由给予它的展开而来，并经由世系与整体相关（AI 论证）。这不替代 Ren 的原话，也不推出生起是好的：`living` 与 C 都没有改变。
- **世系跟着水平走。** 世系的定义用开始作为条件而在，不用生起：种子从在它休眠时供给它的父代而来（`Provisioned.descends`），从休眠中醒来不从任何形成而来（`Sleeper.no_descent`）。这与 §24 的结论一致：生成承担补充，在水平上升处。

**作者反审。**

*反驳 1：这只是把想要的连通写进 related。* 一个读法确实可以让任何东西连通；§10 正因此加了纪律。这里的两种关系都受同一纪律约束：以之为生要求能落空的依存，世系要求参与者实际的给予与开始作为条件而在（P18b 更正，原文“实际的给予”）；`Brood` 与蜂、花的结论是在这些约束下得到的。是否采用它们，是 Ren 的对应选择；本节陈述采用之后会怎样。

*反驳 2：世系使两个关系项的所有事件相关，太粗了。* 是一个选择。只把给予的那一步与生起者相关，会使父代的其他事件与后代无关（`Brood` 中第 0 代在第 5 步的事件就孤立了；P18b 补记：这一例子在更正后的定义下成立，第 0 代只参与第 0 步；原定义下第 0 代在第 5 步对第 6 代的给予项也造成世系，见 §27 L10）。世系作为关系项之间的关系，与 Metaethics 所列的世系（descent）一致；按时间排定的版本列为下一步。

*反驳 3：太阳给予种子也算世系，这不是“世系”。* 对，`Descends` 不要求给予的形成体现（§22 J7 的 `SunSeed`；§23 K6 的 `EmbodiedSun` 表明体现也不使它成为生命）。名称取 Metaethics 的用语，由 Ren 定；更窄的读法（只在给予的关系项体现时）可以由 `arises_from_embodied` 得到，没有单独陈述。

*反驳 4：这让 G0 珍视带来新的生起吗？* 不。G0 珍视活的主张；这里只是说，若世系算作形成的关系，珍视给予的形成的立场就到达生起者的活的事件。带来新的生起是否使结果更好是 C 的问题，`living` 与 C 都没有改变。

**边界。** 不含伦理谓词；不改变 `living` 与 C；两种关系是 `related` 的候选读法，是否采用属于 Ren；世系不排定时间，给予的形成不必体现，以之为生不问汲取的效果；依赖一类读法的同一对应；只对逐步读法陈述；见证都是最小见证。本节经第八次独立审查，见 §27。

## 26. 变化的规律：不加前提，开始成立与不再成立同步（P19）

2026-10-09。Ren 的新指示：“aim a complete theory of becoming, and finish related work”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-09-complete-theory-of-becoming.md)）。计划第 9 节把“完整”读作四项可检查的内容（AI 的读法），第二项是：对每个展开成立的规律不加任何关于展开的前提而证明，其余每条规律写明它的前提。此前各模块的规律都在前提之下：`Dependent`、`Balances`、`Taking`、`Dissipative`、`Embodied`、`Carries`。本节陈述不需要这些前提的部分，并检查其中是否有实质内容，而不只是定义的重述。成果记录：[coming-and-ceasing-keep-pace](../../../../theories/becoming/results/records/coming-and-ceasing-keep-pace.md)。

```text
Result(s): 复用 unceasing-generation-needs-renewal（Arises、Unceasing、Rises、Falls、total）、becoming-renewal-reading（falls_finitely）、
           becoming-dependence-dynamics（Forms、Dissolves、Supported）、more-needs-renewers（steps 与 total 的引理）、
           generation-is-replenishment（ComesToStand）；新增 coming-and-ceasing-keep-pace（L3 Becoming.Change）
Delta: 开始成立与不再成立（ComesToBe、CeasesToBe），四种读法（Web.change_readings）；persists；支持只经由关系改变（Web.supported_of）；
       一段步上的升降相抵（over_stretch、family_over_stretch）；下限与上限（fallen_within、risen_within、rising_recurs、falling_recurs、
       Web.falls_need_rises、falls_finitely_from_floor）；有限家族中开始成立与不再成立同步（held_over_stretch、keep_pace、coming_recurs_iff），
       读于活动（Web.activity_over_stretch、Web.arising_recurs_iff、Web.unceasing_iff）与水平（Web.standing_recurs_iff）；无限家族的见证（Dawn、Dusk）
Supplied premises / correspondence: 没有关于展开的前提；表示的方法承诺：离散的步、自然数的量、计数时的可判定性（活动的可判定性是相关定理的假设，
       水平是否为正总可判定）；家族有限
Evidence: Becoming.Change 的 42 项定理；合并检查器回执 20261009T095726.865589Z（841 项定理／1342 项声明审计，核心闭包 25 个模块，
          包 23 个模块，公理报告全空）；外围桥接重跑 20261009T100002.522708Z
Boundary: 不含伦理结论；同步是数目的同步，不说明哪个形成生起或止息，也不说明为什么；“复现”不给出频率；不把形式规律当作现实的必然性；
       生生不息在哪个层次读、中文用语与名称由 Ren 定
Integration: 计划第 9 节第二项的第一部分；Renewal 的下降原则是一个量的下限；Generation、Flow、Dissipation 的更新规律是前提加这里的下限
```

[Becoming.Change](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Change.lean)（L3，导入 `Becoming.Flow`；`Becoming.Population` 改为导入它）：

| 声明 | 内容 |
|---|---|
| `ComesToBe`、`CeasesToBe`、`Web.Ceases`、`Web.CeasesToStand`、`Web.change_readings` | 一个规定跨一步开始成立（之前不成立、之后成立）或不再成立。形成的生起与止息、依存的形成与消解、条件开始与不再作为条件而在，是这同一种变化分别读于活动、依存与水平（都是 `Iff.rfl`） |
| `persists` | 可判定的规定在某步成立、此后没有一步不再成立，就一直成立。`Dependence` 的 `ceases_at_a_step` 是它不用可判定性的否定形式 |
| `Web.supported_of` | 支持只经由关系改变：一个形成在某步被支持，在另一步仍被支持，只要它在后者的每个依存在前者都有、所需不更大、条件的水平不更低 |
| `excess`、`rise`、`fall`、`across`、`over_stretch` | 任一步上，量在之后加其下降，等于在之前加其上升；任一段步上，终点加其间的全部下降等于起点加其间的全部上升。`excess` 用递归定义，不用自然数减法 |
| `risen`、`fallen`、`family_over_stretch` | 有限家族的总量连同成员的升降也是如此 |
| `fallen_within`、`rising_recurs`、`Web.falls_need_rises` | 量不低于零：有限家族在一段步上的下降至多比上升多出起点的总量，所以成员在任意晚的步下降就在任意晚的步上升；读于条件的水平，每个展开中有限多个条件持续下降就持续上升 |
| `falls_finitely_from_floor` | `Renewal` 的 `falls_finitely`（从某步起不上升的观测量只下降有限次）是一个量的下限 |
| `risen_within`、`falling_recurs` | 量有界时，有限家族的上升至多比下降多出每个成员的界，所以在任意晚的步上升就需要在任意晚的步下降 |
| `mark`、`mark_cases`、`mark_le_one`、`mark_pos`、`mark_iff`、`excess_mark`、`rise_mark`、`fall_mark` | 一个可判定的规定计 1 或 0；它的上升恰是开始成立，下降恰是不再成立。`mark` 与 `mark_cases` 从 `Reserve` 移来 |
| `comings`、`ceasings`、`held_over_stretch`、`marks_within`、`keep_pace` | 有限家族中：终点成立的成员连同其间不再成立的，恰是起点成立的成员连同其间开始成立的；开始成立与不再成立的次数之差不超过成员数 |
| `Recurs`、`Recurs.mono`、`Recurs.accumulates`、`pos_of_exceeds`、`coming_recurs_iff` | 有限家族中，开始成立复现恰当不再成立复现 |
| `Web.activity_over_stretch`、`Web.arising_recurs_iff`、`Web.unceasing_iff` | 读于活动（活动可判定）：有限家族的形成在终点活跃的连同其间止息的，恰是在起点活跃的连同其间生起的；它们在任意晚的步生起恰当在任意晚的步止息；形成有限多时，生起复现恰当某个形成在任意晚的步止息（P29b 更正，原文“生成不息恰当……”；见 §42 R5） |
| `Web.standing_recurs_iff` | 读于水平，不需要任何前提：有限家族的条件在任意晚的步开始作为条件而在，恰当它们在任意晚的步不再作为条件而在 |
| `Dawn.unceasing`、`never_ceases`、`rises`、`never_falls` | 无限家族：形成 f 跨第 f 步生起、从不止息，水平每步上升、从不下降。只生而不止需要无尽的新，上升复现而不下降需要无界 |
| `Dusk.ceasing`、`nothing_arises` | 无限家族：全部形成一开始活跃，形成 f 跨第 f 步止息，没有任何生起。只止而不生需要无尽的初始 |
| `le_dest`、`steps_mem`、`steps_last`、`steps_mono` | 一段步的引理 |

另外，`total_map` 与 `total_congr` 从 `Roles` 移到 `Flow` 的 total 一节，与其他 total 的引理放在一起，并新增 `total_ones`（每个成员计一次，总和是成员数）。`Roles` 与 `Reserve` 的定理数随之减少，内容不变。

**解读。**

- **不加前提的部分有实质内容。** 前四行是定义与恒等式：变化的读法、升降相抵。它们本身不多说什么，但把以前分散的定义（`Arises`、`Forms`、`Dissolves`、`ComesToStand`）收到同一种变化之下，并补上缺少的另一半（`Ceases`、`CeasesToStand`）。实质内容来自两个界：量不低于零，规定只计 0 或 1。由前者，下降复现需要上升复现；由后者，有限家族中开始成立与不再成立同步。这些对每个展开成立。
- **生起与止息在有限之中同步。** 有限家族中，生起复现恰当止息复现；任一段步上两者之差不超过成员数。所以在形成有限多且活动可判定的展开中，生起复现恰当止息复现（P25b 更正，原文“生成不息恰当止息不息”；见 §38 O7）：没有只生不灭的有限世界，也没有只灭不生的有限世界。作者把这读作 Ren 所说“生成、维持、转化、退化与消失在同一展开中”的一种形式内容（AI 论证）：生起与止息在有限之中一同复现。这是活动的读法；它是否为 Ren 提议中的“生成的”“退化的”由 Ren 选择：Ren 说二者“不overlap吧”，若取不重叠，这一读法就不是其所指（AI 的推论）；读作关系，更新的形成与消耗的形成不重叠（`Web.renewing_not_consuming`）（P25b 更正，原文“不是 Ren 的‘生成的’‘退化的’：Ren 说二者不重叠”；见 §38 O8）（P23c 更正，原文“生成与退化不是两个可以分开的过程，在有限之中它们一同复现”；见 §34 M1）。这不推出止息是好的或坏的，也不决定生生不息在哪个层次读：在谱系或整体的层次上不息，与成员的止息不息并不冲突（§21 的 `Generations`），这里的结论正是说成员层次上两者同步。
- **无限是逃脱的方式。** 只生不止需要无尽的新（`Dawn`）；只止不生需要无尽的初始（`Dusk`）。这与 §21 的 `needs_new`（部分终结、同时活跃的有限时，整体需要不断新的部分）和 §20、§23 的耗散结论（条件总共有限时生成终止）同一方向：有限性使生成须伴随别的东西，前提不同，所伴随的不同（止息、补充、开放）。
- **更新规律的分解。** `Generation` 的“生起消耗有限家族时，不息的生成需要更新复现”与 `Flow` 的“复现的取用需要补充复现”，现在可以读作一个前提（消耗、平衡）加这里的下限：前提把生起或取用变成下降，下限使下降的复现需要上升的复现。`Renewal` 的 `falls_finitely` 正是一个量的下限（`falls_finitely_from_floor`）。下限本身对每个展开成立：每个展开中，有限多个条件持续下降就持续上升（`Web.falls_need_rises`）。
- **开始作为条件而在不需要任何前提。** 水平是否为正总可判定，所以 `Web.standing_recurs_iff` 连可判定性的假设也不需要：有限家族的条件开始作为条件而在复现，恰当它们不再作为条件而在复现。§24 证明，平衡的流中开始作为条件而在复现需要补充复现；这里加上：它也需要不再作为条件而在复现。

**作者反审。**

*反驳 1：这些是平凡的计数，不是生成之论的内容。* 证明是计数，内容是：一个二值的规定在有限家族中无限多次改变，就在两个方向上都无限多次改变；读于活动，在任何有限的展开中生起与止息同步。它是二值与有限的推论，不排除二值与有限所排除之外的任何动力学；对整个空间成立的东西不多，这一条是其中之一（P23c 更正，原文“它说在任何有限的展开中，生成与退化同步。这正是 Ren 提议中‘计入整个空间，包括生成与退化’的一个形式陈述……这一条把生成与退化绑在一起”；见 §34 M1、M9）。平凡的是证明，不是结论；以前各模块需要前提才得到的“生成须伴随更新”，其下限部分在这里对每个展开成立。

*反驳 2：可判定性就是一个前提。* 它是表示的方法承诺，已在来源说明与计划第 9 节中单独公开：计数需要知道每一步是否成立。它不是关于展开的前提：不限制什么生起、什么止息。读于水平时连它也不需要。无论如何，相关定理把它作为显式假设写出。

*反驳 3：“有限家族”也是前提。* 是，它是定理的假设，`Dawn` 与 `Dusk` 表明它不可去掉。但它不是关于展开动力学的前提：任何展开中任何有限的形成家族都满足它。定理说的是“对每个展开、对其中每个有限家族”。

*反驳 4：把生成不息与止息不息等同，会被读成“生生不息需要死亡”。* 定理只说成员层次上的数目同步，不说止息是生成的条件或代价，也不说它好。§21 的 `Layered` 表明同样的成员可以反复生起与止息（短暂的部分）；那里的止息不是消失。是否把这读作生生不息的一部分，由 Ren 定。

**边界。** 不含伦理谓词；只对离散步的读法陈述；有限家族以列表给出；“复现”不给出频率或比例；同步是数目的同步，不说明哪个形成生起或止息，也不说明为什么；不把形式规律当作对现实的演绎必然性；中文用语“止息”“开始成立”“不再成立”“同步”是 AI 的提议，名称由 Ren 定。本节经第九次独立审查，更正见 §34。

## 27. 第八次独立审查与更正（P18b）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P16c（§23）、P17（§24）与 P18（§25）（[审查](../history/root-foundation/BECOMING-P16C-P17-P18-REVIEW.md)）。它在仓库之外从前导重新编译核心闭包的 24 个模块，1356 条源声明的公理报告全空；回执、源哈希、保留产物、引用哈希与证明绑定都对，数学全部接受，Lean 中没有数学错误。K2、K5、K7 关闭；K1、K3、K4、K6 关闭而有残余；K8 的八项中五项关闭。它提出十项（L1–L10）：一项定义与其陈述的意义不符（L10，最严重），两项散文中的错误（L5、L9），四项说得过强（L1、L2、L4、L8），一项缺少反例（L6），两项记账与表述（L3、L7）。审查没有发现替 Ren 选择任何读法；L1 的残余把体现读作生命，是 K6 已指出、P16c 已承认属于 Ren 的读法。本节记录逐项处理。审查的探针按需要移入相应模块，公理报告为空。§18、§20、§22–§25 与英文段落中受影响的句子已就地更正并标明；原文见提交 `4295dd24`。

```text
Result(s): 更正 living-on-and-descent（L8–L10）、reserve-defers-ending（L3(d)、L4–L6）、generation-is-replenishment（L7）、
           life-as-condition-of-life（L1、L9）；whole-persists-through-generation 与 identity-across-steps 的关联说明（L2）；
           检查器审计 Lean 生成的常量（L3(b)）；没有新的成果记录
Delta: Flow.Descends 要求给予的形成参与该步，新增 Stranger 与 Brood.not_descends（L10）；LivesOn.stands 与 Drowsy（L8）；
       Seed.no_held、Viable.no_held（L4）；Flow.carries_of_own（L5）；Web.redirect、redirect_same、redirect_dependent 与
       Famine.undermines_one、transformed_not_undermining、living_differs（L6）；Balances.rise_given、ComesToStand.rises、
       Web.rising_of_coming、Balances.rise_replenishes、rising_needs_replenishment、Growing、rise_lowers_on、rising_ceases_on、
       rising_opens、rising_draws_in、rising_ceases，原有的开始作为条件而在的定理改由它们推出（L7）；用语、标题与关联说明（L1–L3）
Supplied premises / correspondence: 不变；在所持条件被表示的地方，估值用哪种读法列为对应前提（L6）；世系按给予项计而不按净流量，
       列为又一个读法选择（L10）；审查时间的约定写入 _process/RESULT-WORKFLOW.md（L3(f)）
Evidence: 合并检查器回执 20261009T104417.218214Z（877 项定理／1387 项声明审计，核心闭包 25 个模块，包 23 个模块，源声明的公理报告全空；
          核心闭包中 Lean 生成的常量依赖公理的有 29 条，都是带字段构造子的 injEq 引理，只依赖 propext）；外围桥接重跑 20261009T104540.104898Z；
          实例检查通过
Boundary: 不含伦理结论；不改变任何读法选择的地位；新名称是建议；探针与新见证都是最小见证
Integration: §23–§25 的更正；§24 列为开放的“一般地构造转化的读法”完成；L7 使补充与耗散的定理都对上升陈述
```

### 27.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| L1 | 体现的关系项仍被称作生命：`Roles` 的模块说明、节标题与 `active_of_bearing` 的说明，§18，§23.4 反驳 4，章节 §2 与 §8，英文 P14 与 P16b；章节 §2 的中文多一句英文中没有的 AI 读法；记录标题 | `Roles` 三处改为“An embodied relatum as a condition”。§18、§20、§22、§23.4、章节与英文改为“体现关系项 / embodied relatum”与“need not be embodied”，标明 P18b 用语与原文。章节 §2 那句中文删去。life-as-condition-of-life 的标题改为“回答‘生作为生的条件’：……”，H14 的用语只作为所回答的问题的名称 |
| L2 | `Dissipation` 的模块标题仍是无条件的“汲入”；两条关联说明仍写“部分不长久”，一条写“构成” | 标题改为“recurring taking opens finite families and, enclosed around, draws in”。两条说明改为记录标题的形式：部分短暂，或部分终结且同时活跃的部分有限时，整体经由部分的生成而持续 |
| L3 | (a) “给予者”残留在 §18、§22 与计划；(b) “每条声明的公理报告为空”没有排除编译器生成的 `injEq` 引理；(c) §24 反驳的次序是 1、2、3、4、6、5；(d) 英文用“draws”表示耗用储备；(e) P16b 的英文段落把包写成核心；(f) 记录的审查时间早于它引用的运行 | (a) 改为“给予它的关系项／形成”。(b) 两者都做：现行文字改为“每条源声明”；检查器另审计核心闭包的全部常量（含生成的），断言依赖公理的只有带字段构造子的 `injEq` 引理、只依赖 `propext`、不是源声明，并在回执中逐一列出（29 条，与审查的计数相同）。(c) 按编号排列。(d) 改为“uses no reserve”。(e) 改为“The package”。(f) 约定写入 [RESULT-WORKFLOW](../../../RESULT-WORKFLOW.md)：作者修订记录内容（主张、前提、对应、界限、反例、关联说明或下一步）时刷新审查时间，只把验证范围改指新回执、内容不变时不刷新。本次内容改动的六份记录随之刷新；becoming-dependence-dynamics 在 P17 改了界限与下一步，作者复核后刷新 |
| L4 | “储备是所持的条件”只给出一个方向：本模块自己的 `Seed` 与 `Viable` 的储备不是任何条件的水平，它们的网中也没有所持条件能承载种子 | 改为“储备可以是所持的条件；没有表示所持条件时，储备是给定的”。`Seed.no_held`、`Viable.no_held` 移入核心。“滞后就是依存转化到所持的条件上”限于所持条件承载它的地方。模块说明、根模块、包说明、§24、记录与章节 §9 随之更正 |
| L5 | `carries_of_held` 的前提只要求有形成从所持条件取用，不必是持有者：`Larder` 中狐不参与、不取用，乌鸦吃掉脂肪，前提全部成立 | 说明改为“被（参与的任何形成）取用”。新增 `Flow.carries_of_own`：持有者自己参与并从中取用时的形式；`Famine.carries` 改由它证明，狐燃烧自己的脂肪。`Larder` 留在审查的探针中 |
| L6 | 两种读法对狐第 1 步的事件给出不同的 living；转化的读法可以一般地构造 | `Web.redirect`（用 `if` 而不另设选择函数）、`redirect_same`、`redirect_dependent` 移入核心：所持条件承载形成时，把每个不被支持的依存移到所持条件上、需要为一，水平、活动与汲取不变，这样读出的依存网满足 `Dependent`。`Famine.undermines_one`、`transformed_not_undermining`、`living_differs` 移入核心。§24 反驳 2 与记录写明：两种读法在 living 上不同，选择是影响估值的对应前提；转化的读法满足 `Dependent` 由构造给出，是对储备的重新描述，不是关于展开的另一事实 |
| L7 | 证明只用到上升带来的正的给予，不用从零开始 | 一般定理对上升陈述：`Balances.rise_given`（`renewedBy` 改由它推出）、`Web.ComesToStand.rises`、`Web.rising_of_coming`、`Balances.rise_replenishes`、`rising_needs_replenishment`、`rise_lowers_on`、`rising_ceases_on`、`rising_opens`、`rising_draws_in`、`rising_ceases`；原有的 `standing_*` 定理改由它们推出，陈述不变。`Growing`：一个条件每步上升、每步被给予，从不开始作为条件而在。§24、记录与章节改为“要求跟着水平的上升走，开始作为条件而在是从零的上升” |
| L8 | `LivesOn.active` 以所依的关系项体现为假设；散文写成在 `Dependent` 之下只能以活跃的体现关系项为生；`Drowsy` 中吃者以既不体现、该步也不活跃的关系项为生 | 新增 `LivesOn.stands`：在 `Dependent` 之下，所依的关系项在该步作为条件而在。`LivesOn.active` 保留，所有说明写出体现的前提。`Drowsy` 移入核心：以之为生连通，交互不连通。模块说明、§25、记录、章节与检查器范围更正 |
| L9 | “这里体现第一次进入估值”：`sustenance` 与 `descent` 的定义都不含体现 | 改为“这里一类读法的同一对应第一次进入估值；两种关系的定义不含体现”。life-as-condition-of-life 的下一步写为以更宽的形式得到回答；living-on-and-descent 的对应与依赖说明随之更正 |
| L10 | `Flow.Descends` 读 `give`，不要求给予的形成参与该步。不参与者的给予项不进入任何水平，平衡与 `Acting` 都不约束它，却造成世系；`Brood` 中给予不看是谁给予，每一代都“从”每个自然数而来 | 定义改为要求参与：`∃ t, g ∈ L.present t ∧ 0 < L.give t g x ∧ W.ComesToStand t x`。`Embodied.descends`（`arises_given` 已给出参与）、`Brood.descends`、`Provisioned.descends` 与 `Brood.descended` 照旧成立；`Sleeper.no_descent` 改由没有参与者推出。新增 `Stranger`：流平衡、只有活跃形成给予，陌生者对种子的给予项在种子开始作为条件而在之步为正，种子只从父代而来；`Brood.not_descends`：第一代不从第八代而来。§25 反驳 2 的例子在更正后的定义下成立。世系按给予项计而不按净流量，写为又一个读法选择 |

### 27.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Descent | `Flow.Descends`（更正） | 世系要求给予的形成参与该步 |
| Descent | `LivesOn.stands` | 在 `Dependent` 之下，活跃的形成以之为生的关系项在该步作为条件而在 |
| Descent | `Drowsy.Relatum`、`web`、`dependent`、`not_undermining`、`lives`、`eater_alive`、`sleeper_alive`、`down`、`up`、`sustenance_connected`、`not_interacting`、`drowsy` | 一个关系项始终以水平一作为条件而在、在奇数步醒来；吃者始终活跃，汲取它并以需要一依存于它。`Dependent` 成立，没有侵蚀；吃者在第 0 步以它为生，它不体现、该步不活跃；以之为生连通，交互只关联吃者的事件 |
| Descent | `Stranger.Relatum`、`web`、`toSeed`、`flow`、`balances`、`acting`、`absent`、`stranger` | 父代、种子与陌生者；只有父代参与，在第 0 步给予种子一单位；流另有陌生者对种子的给予项。流平衡，只有活跃形成给予；陌生者从不参与；种子跨第 0 步开始作为条件而在，只从父代而来 |
| Descent | `Brood.not_descends` | 第一代不从第八代而来：第八代在第 0 步的给予项不属于任何参与者 |
| Flow | `Web.ComesToStand.rises`、`Web.rising_of_coming` | 开始作为条件而在是从零的上升；成员在任意晚的步开始作为条件而在，就在任意晚的步上升 |
| Flow | `Balances.rise_given`、`Balances.rise_replenishes`、`rising_needs_replenishment` | 平衡的流中每次上升都被给予，补充每个包含它的家族；成员在任意晚的步上升时，家族的补充复现，不论取用什么。`renewedBy`、`standing_replenishes` 与 `standing_needs_replenishment` 改由它们推出 |
| Flow | `Growing.web`、`flow`、`balances`、`growing` | 一个条件每步上升一、每步被给予，从不开始作为条件而在 |
| Dissipation | `rise_lowers_on`、`rising_ceases_on`、`rising_opens`、`rising_draws_in`、`rising_ceases` | 被耗散家族的成员上升，降低家族的存量；从某步起被耗散的家族中，成员不在任意晚的步上升；耗散之下，成员在任意晚的步上升的不重复有限家族从任何一步起都不封闭，被围住时汲入；条件总共有限时，没有条件在任意晚的步上升。六个 `standing_*` 定理改由它们推出 |
| Reserve | `Flow.carries_of_own` | 持有者自己参与并从所持条件取用时，所持条件承载它 |
| Reserve | `Web.redirect`、`redirect_same`、`redirect_dependent` | 把每个不被支持的依存移到所持的条件上、需要为一；水平、活动与汲取不变；所持条件承载形成时，满足 `Dependent` |
| Reserve | `Seed.no_held`、`Viable.no_held` | 两颗种子的依存网中没有任何条件承载它们：储备是给定的 |
| Reserve | `Famine.undermines_one`、`transformed_not_undermining`、`living_differs` | 狐在第 1 步的事件按原读法侵蚀（它汲取兔，它在第 0 步满足过对兔的依存，兔在该步之后低于所需），按转化的读法不侵蚀（脂肪在该步之后仍为一） |

检查器另写出 `EnvironmentAudit.lean`：列出核心闭包每个模块的常量数（含 Lean 生成的）与每个依赖公理的常量，断言后者都是带字段构造子的 `injEq` 引理、只依赖 `propext`、不是源声明，回执记下 `core_closure_constants` 与 `generated_axiom_dependencies`。

### 27.3 审查列出的会改变判断的结果

1. 世系（L10）：要求给予的形成参与，重述三个世系定理与“空的给予不造成它”。完成；原定义下的反例（`Stranger`、`Brood` 中第一代从第八代而来）在更正后的定义下不成立，并成为定理（`Stranger.stranger`、`Brood.not_descends`）。
2. 以之为生（L8、L9）：以 `LivesOn.stands` 作为 `Dependent` 给出的东西，`LivesOn.active` 的每处说明写出前提，“体现第一次进入估值”改为同一对应。完成。
3. 储备（L4–L6）：“可以是所持的条件”，`Seed` 与 `Viable` 是给定的储备；更正 `drawn` 的说明并给出持有者自身取用的形式；写明转化的读法在第 1 步改变 living，并记下一般的构造。完成。
4. 上升（L7）：完成，且审查没有构造的部分（P17 的耗散定理对每个上升重述）也已构造。
5. 残余（L1–L3）：完成。
6. Ren 的选择保持开放：以之为生与世系是否算作 N_rel 所传递的形成关系；“生”与 living 的读法，包括体现的关系项是否是“生”；接续的读法与生生不息读到哪个层次；终结之步的汲取是否计入、对哪些汲取者；名称，包括给予的用语；以及新增的一项：在所持条件被表示的地方，估值用哪种读法。
7. 审查未构造而仍开放的：沿依存链、有储备的滞后共灭；净给予形式的世系。

### 27.4 作者反审

*反驳 1：要求参与是否太强，一个形成可以在不参与的步上给予？* 在这一表示中不能：`given` 只对参与者求和，平衡只约束 `given`，所以不参与者的给予项不进入任何水平，也不被 `Acting` 约束。要求参与正是要求给予实际发生。原定义并不更宽地反映给予，只是多读了表示中没有约束的分量。

*反驳 2：`redirect_dependent` 使 `Dependent` 在所持条件承载形成处总可满足，这是否削弱了 `Dependent`？* 它表明 `Dependent` 的内容与依存于什么的读法一起才确定：在所持条件被表示的地方，零储备与正储备是同一展开的两种读法，区别在于哪些依存被读出。这不削弱它，而是写明它不是关于展开本身、与读法无关的事实；两种读法在 living 上不同（`living_differs`），所以对估值来说，选择不是中立的，属于对应前提。

*反驳 3：把一般定理改对上升陈述，开始作为条件而在还说明什么？* 它说明体现的生起落在哪里：体现的关系项在生起时开始作为条件而在，所以 §20 与 §23 的结论适用。上升的形式更宽：`Growing` 表明要求也落在从不开始作为条件而在、只是增长的条件上。§26 的下限说明一般的另一半：没有前提时，下降的复现需要上升的复现；这里加上，平衡时上升需要给予。

*反驳 4：审计生成的常量是否越出“核心纯净”的要求？* 核心纯净的三条（只导入自身、源声明的公理报告为空、只用前导编译）不变。生成的 `injEq` 引理依赖 `propext`，它们属于环境，不属于证明；审计使这一事实被检查而不只是被说明。若以后出现别的依赖公理的生成常量，检查器会失败，需要先查明再接受。

**边界。** 不含伦理谓词；不改变读法选择的地位；新名称是建议；探针与新见证都是最小见证；转化读法的选择、世系按给予项计，是公开的读法选择；沿依存链的滞后共灭与净给予的世系，开放。本节的更正经第九次独立审查，L1–L10 全部关闭，见 §34（P23c 补记，原文“本节的更正尚未再经独立审查”）。

## 28. 上升与下降在同一交换中（P20）

2026-10-09。按同一指示继续计划 P20。§26 不加前提地证明：在有限家族中，开始成立与不再成立同步，但那是一段步上的数目与复现的同步，不说一次生起在哪一步伴随什么。本节问：一个成员上升（包括开始作为条件而在、体现的生起）的同一步上，是否另有成员下降？不加前提时不然：`Growing` 与 `Brood` 中有上升而什么都不下降。在平衡与耗散之下则然，而且有数量：被耗散的一步上，家族成员的下降至少等于其上升，每个取用的形成再多一。成果记录：[rising-and-falling-in-one-exchange](../../../../theories/becoming/results/records/rising-and-falling-in-one-exchange.md)。

```text
Result(s): 复用 no-finite-part-bears-taking（DissipatesOn、Dissipative、ClosedAt、runs_down、takes_of_gives）、
           coming-and-ceasing-keep-pace（rise、fall、risen、fallen、family_over_stretch、excess_pos）、
           generation-is-replenishment（rise_given、ComesToStand、Embodied.comesToStand、Brood）、
           unceasing-generation-needs-renewal（Depletes、Rises、Falls）、more-needs-renewers（Balances、Acting、Taking、takers）；
           新增 rising-and-falling-in-one-exchange
Delta: Flow：Balances.fall_taken、Balances.takenBy；Dissipation：Balances.falls_cover、Balances.falls_of_taking、Balances.depletes、
       rise_with_fall、standing_with_fall、rise_alone_opens、rise_exchange；Roles：Embodied.arising_with_fall、
       Brood.birth_only、Brood.rise_without_fall
Supplied premises / correspondence: 平衡（Balances）；该步上家族被耗散（DissipatesOn；耗散之下，每个不重复的封闭家族都是）；
       读于形成时另加只有活跃者给予与取用（Acting、Taking）；读于体现的生起时另加体现（Embodied）
Evidence: 合并检查器回执 20261009T110204.479251Z（889 项定理／1399 项声明审计，核心闭包 25 个模块，包 23 个模块，源声明的公理报告全空）；
          外围桥接重跑 20261009T110332.423150Z；实例检查通过；五份记录所引的模块定理数按新回执更正，其中四份此前已过期（Flow、Dissipation、Identity、Wholes）
Boundary: 下降不是止息，下降的成员可以仍作为条件而在；不说哪个成员下降，只说有；不说上升对下降者是好是坏；
       不含伦理谓词；“同一交换”是同一步上同一流中的给予与取用，不是因果的单独归属
Integration: 计划 P20；把 §26 的长程同步在耗散之下变为一步之内的伴随；Generation 的两个对应前提（RenewedBy、Depletes）
       都化归为流的前提；§20 与 §27 的“上升降低存量”加上“另一个成员下降”
```

| 模块 | 声明 | 内容 |
|---|---|---|
| Flow | `Balances.fall_taken` | 平衡的流中每次下降都被取用。`rise_given` 的对偶 |
| Flow | `Balances.takenBy` | 只有活跃者取用时，每次下降都是某个参与的活跃形成的取用，它汲取这一条件。`renewedBy` 的对偶 |
| Dissipation | `Balances.falls_cover` | 被耗散的一步上，家族成员的下降至少等于其上升，每个取用的形成再多一：`risen + takers ≤ fallen`。由 §26 的一步上的升降相抵（`family_over_stretch`）与 §17 的 `runs_down` 推出 |
| Dissipation | `Balances.falls_of_taking` | 被耗散的一步上，有形成从家族取用，就有成员下降，不论别的成员是否上升 |
| Dissipation | `Balances.depletes` | 一个事件的每一步上家族都被耗散且有形成从中取用，这个事件就消耗家族（`Generation` 的 `Depletes`） |
| Dissipation | `rise_with_fall`、`standing_with_fall` | 被耗散的家族中一个成员上升（开始作为条件而在），同一步上另有一个成员下降 |
| Dissipation | `rise_alone_opens` | 耗散之下，不重复的家族中有成员上升而没有成员下降，家族在该步不封闭：有参与的形成与家族之外的条件交换 |
| Dissipation | `rise_exchange` | 只有活跃者给予与取用时：一个成员上升，某个活跃形成给予它，并从家族取用；另一个成员下降，某个汲取它的活跃形成从中取用 |
| Roles | `Embodied.arising_with_fall` | 被耗散的家族中一个体现成员的生起，伴随同一步上另一个成员的下降 |
| Roles | `Brood.birth_only`、`Brood.rise_without_fall` | 没有耗散时不然：每一步上，第 t+1 代在它与第 t 代组成的家族中生起，家族在该步封闭，没有任何一代下降过；所以该家族在该步不被耗散（由 `arising_with_fall` 推出） |

**解读。**

- **长程的同步在耗散之下变成一步之内的伴随。** §26 说，有限家族中生起复现恰当止息复现，但两者可以相隔任意多步。在家族被耗散的一步上，平衡使上升在同一步上就伴随家族另一个成员的下降：不必等到以后，也不必在别处（P23c 更正，原文“耗散加上平衡，使上升在同一步上就伴随另一个成员的下降”；在 `Spray` 中流平衡且耗散，一个条件上升而没有条件下降，见 §34 M5）。数量上，下降至少等于上升加取用者的数目，所以耗散的家族在每个有交换的步上整体下降（`runs_down`），上升只是使别的成员下降得更多。
- **生成的两个对应前提化归为流的前提。** §13 中 `Becoming.Generation` 的结论用两个由应用给出的前提：每次上升都由某个形成造成（`RenewedBy`），事件在没有上升的步上消耗家族（`Depletes`）。§14 已证明前者在平衡且只有活跃者给予的流中成立（`renewedBy`）。这里证明后者的更强形式：在平衡的流中，被耗散且有取用的步上，家族的某个成员下降，即使另一个成员上升（`falls_of_taking`）；一个事件的每一步都是这样的步，它就消耗家族（`depletes`）。所以在流的读法中，`Generation` 的两个对应前提化归为平衡、只有活跃者给予、耗散，以及事件之步上有形成从家族取用；这些仍是对应前提，只是更基本，并且可以分别检验。
- **同一交换的两面。** `rise_exchange` 读于形成：给予上升成员的活跃形成自己从家族取用（耗散），另一个成员下降，由汲取它的活跃形成取用（平衡与 `Taking`）。读于一类关系项（`Embodied.arising_with_fall`）：一个关系项的生起，在同一步上就是家族中另一个关系项的下降。作者把这读作 Ren 所说“生成、维持、转化、退化与消失在同一展开中”在一步之内的一种形式内容（AI 论证）：在被耗散的家族中，生起不是一个可以单独发生的事件，它与别处的下降是同一次交换。
- **开放的单步判据。** §20 与 §27 证明，耗散之下，成员在任意晚的步开始作为条件而在（一般地，上升）的不重复有限家族，在任意晚的步不封闭。`rise_alone_opens` 给出单步的形式：耗散之下，有成员上升而没有成员下降的不重复家族，在该步就不封闭。`Brood` 正是这样：第 t+1 代生起，没有一代下降，家族封闭，所以它不被耗散。

**作者反审。**

*反驳 1：这只是耗散前提的改写。* 前提是每个形成的：它给予家族的少于从中取用的。结论是每个成员的：另一个成员的水平下降，下降的总量至少等于上升加取用者数。从形成到成员要经过平衡（每个成员的水平变化恰是给予与取用）与一步上的升降相抵（§26）。推导短，但内容不在前提中：前提不提及任何成员的水平。`Growing` 与 `Brood` 表明，没有耗散时结论不成立。

*反驳 2：“生与灭在同一交换中”说得过强。* 是。计划原题为“生与灭”，证明的是上升与下降：下降的成员可以仍作为条件而在、仍然活跃，什么都不必止息。本节与记录用“上升与下降”，计划的行随之更正。下降何时是不再作为条件而在，要看水平是否降到零，这里不陈述；关于止息，见 §26 不加前提的长程同步与 §17、§20 在耗散之下的终止定理。

*反驳 3：会被读成一个生起须以另一个的损失换来。* 定理不这样说。下降不是损伤：侵蚀在 `Becoming.Dependence` 中由依存与所需定义（`UnderminingOn`），一个条件下降后仍不低于每个依存于它的所需，汲取它就不是侵蚀；下降的成员可以是燃料、池水，而不是任何形成所依的东西。定理也不说上升是好的或坏的。它说的是在被耗散的家族中，交换在同一步上有两面；评价要另经 G0 与 C，不在这里。

*反驳 4：为什么只对被耗散的家族陈述，而不对一切封闭家族？* 耗散之下，每个不重复的封闭家族都被耗散（`Dissipative` 的定义），所以 `rise_with_fall` 加上 `dissipative ds t distinct closed` 就是封闭家族的形式；`rise_alone_opens` 是它的逆否。陈述为被耗散的家族，使前提只在用到的那一步上：一个流可以只在某些步、某些家族上被耗散。

**边界。** 不含伦理谓词；“同一交换”是同一步上同一流中的给予与取用，不把下降单独归给某个上升；不说哪个成员下降；下降不是止息；只对离散步的读法与自然数的量陈述；耗散、平衡与只有活跃者取用是对应前提，实际展开是否满足是经验问题；“上升”“下降”“同一交换”是 AI 的用语，名称由 Ren 定。本节经第九次独立审查，更正见 §34。

## 29. 演化在脊柱上（P21）

2026-10-09。按同一指示继续计划 P21。演化之论的核心候选说：组织的差异通过实际传递参与后续活动，并改变变异、发育、共同生活与下一轮选择的条件。本节问：在脊柱上，这一候选有什么最小的形式内容？脊柱已有世系（§25，§27 更正为给予的形成须参与该步）、支持与 `Dependent`（§6）、平衡与 `Balances.accumulates`（§14）、截断差 `excess`（§26）。新模块 `Becoming.Evolution`（L3，只导入 `Change`）用它们陈述传递、变异与选择，以及活动对后来选择的反馈。成果记录：[evolution-on-descent](../../../../theories/becoming/results/records/evolution-on-descent.md)。

```text
Result(s): 复用 living-on-and-descent（世系；定义移入本模块）、coming-and-ceasing-keep-pace（excess、excess_balance）、
           more-needs-renewers（Balances、Acting、accumulates、total 的引理）、generation-is-replenishment（ComesToStand）；
           新增 evolution-on-descent
Delta: Evolution：total_const、length_mul_le、offspring、selected、raised、lowered、price；Flow.DescendsAt、Flow.Descends
       （从 Descent 移来）；DescendsAt.active、DescendsAt.supported、unsupported_childless、never_supported_childless、
       selected_le、selection_within；TransmitsWithin、transmitted_supported、transmitted_within；Drawdown、Unchecked
Supplied premises / correspondence: price 不加前提；选择用 Acting 与 Dependent；传递是前提（TransmitsWithin）；
       transmitted_within 另加平衡
Evidence: 合并检查器回执（见记录）；外围桥接重跑；实例检查
Boundary: 不含伦理谓词；适应度没有定义；传递不由脊柱推出；price 是会计恒等式；选择只读作支持对给予的约束；
       不含繁殖率、突变、漂变、迁移与种群动力学；与演化之论既有机制的对应未证明
Integration: 计划 P21；世系从 L4 移到 L3，Descent 保留估值的读法；演化之论的独立纲领保持原范围
```

| 声明 | 内容 |
|---|---|
| `Flow.DescendsAt`、`Flow.Descends` | 一个关系项跨一步从一个形成而来：该形成参与这一步、给予它，它跨这一步开始作为条件而在。定义与 §27 的相同，只是移到 L3 并给出每一步的形式 |
| `price` | 不加前提：任意有限的亲代家族与各自的有限后代列表，任意的量，后代的总量加传递所降低的，等于亲代的量按后代数计数，加传递所升高的。Price 方程的加法计数形式 |
| `DescendsAt.active`、`DescendsAt.supported` | 只有活跃者给予时，后代从之而来的形成在给予之步活跃；活动另需支持时，它在该步被支持 |
| `unsupported_childless`、`never_supported_childless` | 选择：在一步不被支持的形成不在该步留下后代；从不被支持的形成没有后代 |
| `selected_le`、`selection_within` | 读于每个亲代都依存的条件上的所需：亲代所需按后代数加权的总量至多是条件的水平按后代数计数（P23c 用语，原文“选择项”）；所以后代任意量的总量加上从亲代所需降低的，至多是这样计数的水平加上升高的 |
| `TransmitsWithin` | 前提：在开始作为条件而在之步依存于 c 的后代，只从在给予之步依存于 c 的形成而来，且所需至多多 δ |
| `transmitted_supported` | 传递的曾被选择：后代的所需至多是该条件在给予之步的水平加 δ |
| `transmitted_within` | 活动设定后来的选择：平衡的流中，后代的所需加上自较早一步以来从条件取用的，至多是条件那时的水平加其后给予它的，再加 δ |
| `Drawdown.drawdown` | 见证：亲代以所需二依存于水平为二的池，从池取用一并给予两个后代；承继所需二的那个从开始作为条件而在之步起不被支持，所需一的那个被支持、活跃并转而取用 |
| `Unchecked.unchecked` | 没有 `Dependent` 时不然：超出支持而活跃的亲代，传递高于给予之步水平的所需 |

**解读。**

- **世系属于变化，不属于评价。** 世系由参与、给予与开始作为条件而在定义，不含估值。P18 把它放在 L4 的 `Descent`，因为它首先用于估值的连通。现在它在 L3 的 `Evolution` 中定义，`Descent` 导入它并保留 N_rel 下的读法（`descent_reaches`、`Brood.descended` 等）。这样，演化的定理不经过元伦理层。
- **Price 方程是恒等式，内容在别处。** `price` 与 §26 的升降相抵同类：不加前提，对任意量成立。它把后代的总量分为亲代的量按其后代加权的总量与传递的变化，但不说哪一项由什么决定。加权总量不是真正的选择项：每个亲代都有 k 个后代时它是亲代总量的 k 倍（`selected_uniform`），没有任何选择时也不为零（`unselected`）；真正的选择项即后代数与量的协方差没有陈述（P23c 更正，原文“它把从亲代到后代的变化分为选择项与传递项”；见 §34 M3）。两份既有笔记已手推其协方差形式并说明它是会计恒等式（[math-note](../../../history/2026-10-05-direction-frontier/math-note.md)、[GENERATED-SELECTION-RECURRENCE-INTEGRATION](../history/root-foundation/GENERATED-SELECTION-RECURRENCE-INTEGRATION.md)，引 Frank 2012）。这里的贡献是：它在纯核心中、以自然数与截断差检查过，并且两项各自有了脊柱上的内容。
- **选择即支持对给予的约束。** 适应度没有定义。在只有活跃者给予且活动需要支持的展开中，能留下后代的只是被支持的形成：选择不是另加的规律，而是 `Acting` 与 `Dependent` 合起来的推论。`selected_le` 把它写进 `price` 的加权总量：后代数加权的亲代所需，受条件的水平所限（P23c 用语，原文“选择项”）。
- **传递的曾被选择。** 后代承接亲代的依存（`TransmitsWithin`）时，后代的所需至多是给予之步条件的水平加 δ：界为零时，传下来的所需在给予时被满足过；界为正时可以从未被满足（`Slack`）（P23c 更正，原文“传下来的所需在给予时被满足过”；见 §34 M6）。δ 是变异向上的界；向下没有界。
- **活动设定后来的选择。** `transmitted_within` 把给予之步的水平展开为较早的水平与其间的取用和给予。所以其间形成做了什么（取用多少、给予多少）进入后来能传递的所需。`Drawdown` 中，这一反馈来自亲代自己：它的取用降低了池，使承继其所需的后代从一开始就不被支持；所需较少的后代被支持、活跃并转而取用。传递、变异、选择与反馈在同一展开中，这是演化之论核心候选在脊柱上的一个最小实例（AI 论证）。

**作者反审。**

*反驳 1：Price 方程是恒等式，算不上结果。* 是。记录的实质内容是选择与传递的定理：`unsupported_childless`、`selected_le`、`transmitted_supported`、`transmitted_within` 与两个见证。`price` 写入是因为它给出加权总量与传递的划分（P23c 用语，原文“选择与传递的划分”），而且与 §26 一样，是不加前提对整个空间成立的规律；记录与本节都不说它改进了 Price 方程。

*反驳 2：这里的“选择”太弱，它不是繁殖率的差别。* 是。这里的选择只是谁能在一步上给予；一个被支持的形成能有多少后代不受约束，后代数只是 `price` 中的权重。要得到繁殖率的差别，需要把后代数与给予的量联系起来（例如每个后代至少要给予多少），这列入下一步，不在本节。

*反驳 3：传递是前提，所以传递没有被解释。* 是，正如演化之论中重构是前提。一类读法中的世系只说给予它的形成给予（P23c 用语，原文“给予者”）；后代是否依存于亲代所依存的，要看依存怎样形成（§6 的形成与持续）。能否由此推出 `TransmitsWithin`，是开放的证明。

*反驳 4：`Drawdown` 会被读成“变异者胜出”。* 定理不评价。所需较少的后代被支持，只是因为亲代取用之后池的水平满足它而不满足另一个；承继所需的后代不被支持，在 `Dependent` 之下从不活跃，但仍作为条件而在（水平为一），不是消失。哪一个更好，要另经 G0 与 C。

*反驳 5：计划要求在外围接通既有的演化机制。* 计划说的是能证明对应时接通。结构复制（`StructuralCopying`）读的是记号序列的复制与材料预算，与流和依存网之间的对应需要另外建立，本轮没有尝试；它保持原范围，列入下一步。

**边界。** 不含伦理谓词；适应度没有定义，不说哪种所需更好；传递是前提；`price` 只以加法计数形式与自然数的量陈述，不含协方差形式；选择只读作支持对给予的约束；只对离散步的读法陈述；与演化之论既有机制的对应未证明；“世系”“传递”“选择”“变异”的这些读法是 AI 的表述，名称由 Ren 定。本节经第九次独立审查，更正见 §34。

## 30. 整体与其部分（P22）

2026-10-09。按同一指示继续计划 P22。Ren 的提议（[原话](../../../../sources/15-codex-theory-conversations/2026-10-08-theory-of-becoming-priority.md)）：加上公理可以定义好，好是整个空间的一部分；计入整个空间，生成的与退化的，就得到演化之论，或生成／生命之论，它甚至不需要公理。计划把这读作：规律对整个空间成立，前提划出部分。本节新模块 `Becoming.Space`（L3，导入 `Evolution` 与 `Reserve`）给出这一读法的形式结构。成果记录：[space-and-its-parts](../../../../theories/becoming/results/records/space-and-its-parts.md)。

（P23c 更正与改名：这是这一提议的一种结构（AI 的读法）。提议中的“生成的”“退化的”指哪个部分由 Ren 选择；Ren 2026-10-09 说二者不重叠（[原话](../../../../sources/15-codex-theory-conversations/2026-10-09-renewing-consuming-without-axioms.md)）。本节的部分按活动读，改名为生起复现与止息复现：`Generative`、`Degenerative`、`generative_ofRoles`、`degenerative_ofRoles`、`generative_iff`、`handing_generative` 现为 `ArisingRecurs`、`CeasingRecurs`、`arisingRecurs_ofRoles`、`ceasingRecurs_ofRoles`、`arising_iff_ceasing`、`handing_arising`。下面的 Delta 块保留 P22 时的名称；表格与解读用现名，受影响的句子已就地更正并标明。见 §34 M1。）

```text
Result(s): 复用 coming-and-ceasing-keep-pace（Ceases、unceasing_iff、Dawn、Dusk）、generation-is-replenishment
           （generation_ceases、Handing、Kindling、Flicker）、life-as-condition-of-life（roles 与迁移引理、Embodied、
           Mutualism）、reserve-defers-ending（Carries、carries_zero、active_finitely）、evolution-on-descent（Drawdown、
           Unchecked）；新增 space-and-its-parts
Delta: Space：Flow.still、World 及其部分（Finite、Generative、Degenerative、Living、Dependent、Balanced、Acting、Taking、
       Dissipative、Embodied、ArisingEmbodied、Carried）、ofRoles 与迁移、generative_iff、rests；世界 handing、spending、
       mutualism、drawdown、unchecked、unbalanced、idle、restless、kindling、flicker、dawn、dusk；contingent、separate、
       living_crosses、rests_needs
Supplied premises / correspondence: generative_iff 要求有限与活动可判定；rests 另要求平衡、耗散与生起者体现；
       其余是关于具体世界的陈述
Evidence: 合并检查器回执（见记录）；外围桥接重跑；实例检查
Boundary: 不评价任何部分；不证明整个理论不需要公理；部分的列举不完全；Living 只是逐步读法的结构条件
Integration: 计划 P22；Ren 的“计入整个空间”在核心上的结构；为 P23 的完整陈述提供整体与部分的框架
```

| 声明 | 内容 |
|---|---|
| `World`、`ofRoles`、`arisingRecurs_ofRoles`、`ceasingRecurs_ofRoles` | 一个世界是以一类读法的关系项、其间的流与依存网；空间是每个世界。两类读法的任一流与网都是一个世界，生起与止息在那里读法相同 |
| `ArisingRecurs`、`CeasingRecurs`、`Living` | 部分：生起复现（某个关系项在任意晚的步生起）；止息复现（某个关系项在任意晚的步止息）；每个事件都活（逐步读法中活跃者不侵蚀） |
| `arising_iff_ceasing` | 规律：有限且活动可判定的世界中，生起复现恰当止息复现 |
| `separate` | 关系项无限多时两者分离：`Dawn` 中生起复现而无止息，`Dusk` 中止息复现而无生起；两者无限由 `arising_iff_ceasing` 推出 |
| `contingent` | 七个前提（`Dependent`、`Balanced`、`Acting`、`Taking`、`Dissipative`、`Embodied`、`Carried`）各有满足与不满足它的世界 |
| `living_crosses` | 有限世界中四种组合都出现：生起复现且都活（handing）、生起复现而有不活（spending；P23c 起为 grazing）、不生起复现而都活（mutualism）、不生起复现而有不活（drawdown） |
| `rests` | 有限、活动可判定、平衡、耗散且生起者体现的世界中，生起与止息都不复现 |
| `rests_needs` | 每个前提都不可少：kindling（无限）、handing（不耗散）、unbalanced（不平衡；P23c 起为耗散不空的 leaking）、flicker（不体现）都继续生起 |
| `Spending.web`、`Spending.spends` | 与 `Handing` 同样的活动，只是每侧在站立时汲取自身的水平；持有者传出它的水平时侵蚀自身的依存 |
| `idle`、`restless` | 不活跃的关系项给予自身（满足平衡而不满足 `Acting`）；每步都超出支持而活跃的关系项，没有任何储备承载它 |

**解读。**

- **整体与部分的结构。** 空间是每个世界。不加前提的定理（§26 的变化规律、§29 的 Price 方程）对每个网、每个量陈述，所以它们就是对整体成立的规律，不需要另一个包装。各定理的前提每一个都有满足与不满足它的世界（`contingent`），所以它们划出真部分，不是隐藏的规律。这是 Ren“计入整个空间”的一种形式内容（AI 论证）：规律属于整体，前提属于部分。
- **生起复现与止息复现在有限世界中是同一部分。** §26 证明，形成有限多且活动可判定时生起复现恰当止息复现（P25b 更正，原文“生成不息恰当止息不息”；见 §38 O7）。读于世界：活动可判定的有限世界中，生起复现的部分与止息复现的部分重合；对每个世界陈述而不给可判定性，这一规律蕴含排中律（`law_decides`）（P25b 更正，原文“就是排中律”；见 §38 O11）。它们只在无限世界中分离，并且分离的两个世界无限这一点由规律本身推出，不需另证。这是活动的读法；读作关系，更新的形成与消耗的形成不重叠（`Web.renewing_not_consuming`），与 Ren 所说二者不重叠相合；提议中的“生成的”“退化的”指哪个部分，由 Ren 选择（P23c 更正，原标题“生成与退化在有限世界中是同一部分”，原文“有限世界中生成的部分与退化的部分重合”“‘生成的’与‘退化的’不是整体的两半，在有限的展开中它们是同一个部分”；见 §34 M1、M2）。
- **活跨越生起复现。** “每个事件都活”的部分既与生起复现的部分交叠，也与其补交叠，四种组合都在有限世界中出现。`handing` 与 `spending` 的活动完全相同，只差各侧是否汲取自身的水平；spending 中不活的事件是承担自身的体现关系项在其终结之步汲取自身，是否计入不活属于 Ren 的选择，所以这一对只在逐步读法的这一判定下显示活与否由汲取与依存的关系决定。`grazing` 不依赖这一判定：放牧者取用一个池，使另一个以池为依存的关系项落空，池不是汲取者，也从不活跃（P23c 更正，原标题“活跨越生成与退化”，原文“活与否不由生成与止息的样式决定，而由汲取与依存的关系决定”；见 §34 M7）。Ren 说加上公理可以定义好，好是整个空间的一部分；这里的 `Living` 是 G0 所计的 living 的一个结构部分，它不是生起的同义词，止息也不是不活（P23c 用语，原文“生成的同义词”）。
- **耗散使有限世界归于静止。** `rests` 把 §20（`generation_ceases`）与 `arising_iff_ceasing` 合起来：有限、活动可判定、平衡、耗散且生起者体现时，生起不再复现，所以止息也不再复现，活动最终不再改变。四个反例表明每个前提都不可少，其中 kindling 表明：在平衡与耗散之下，体现者的生起复现需要关系项无限，与 §17、§20 的“开放”相合（P23c 更正，原文“在耗散之下继续生成，需要展开越出每个有限部分”；flicker 与 unbalanced 是有限的反例，见 §34 M4）。平衡一行原用 `unbalanced`，它没有流，耗散空成立；P23c 改用 `leaking`，其中两侧的家族每步封闭且被取用（见 §34 M8）。

**作者反审。**

*反驳 1：大部分是把已有见证收集起来。* 部分是。新的内容是：世界与部分的定义及两类读法的嵌入；把前提的偶然性作为一个陈述（`contingent`），其中三个世界（`idle`、`restless`、`unbalanced`）与 `spending` 是新的；`living_crosses`；`rests` 及其每个前提的必要性；以及分离世界的无限由规律推出。`arising_iff_ceasing` 是 §26 的 `unceasing_iff` 读于世界，不算独立结果。

*反驳 2：有限世界的规律要求活动可判定，这削弱了“不加前提”。* 核心是构造性的，不用经典逻辑；计数需要可判定。经典地每个世界的活动都可判定，所以这不是关于展开的实质前提，而是构造性证明的要求。记录与模块都写明这一点。（P23c 补充：前一半对；后一半须写明，对每个世界陈述这一规律而不给可判定性，就要用排中律（`World.law_decides`）。可判定性因此作为逻辑承诺，与表示的其他承诺一起公开，见 §34 M2。）

*反驳 3：“每个前提都划出真部分”只对七个前提给出。* 是。`Census`、`TransmitsWithin`、`Around` 等其他前提没有逐一给出；前提的组合也没有逐一给出。完整的地图列入下一步。

*反驳 4：这被读成“理论不需要公理”。* 不是。本节显示哪些陈述不需要前提、哪些前提划出哪些部分。规范方向仍经 G0；“不加实质公理的整体演绎必然性”仍是开放的首要目标（[根基章节](../../../../theories/becoming/history/BECOMING-FOUNDATION.md)）。

**边界。** 不含伦理谓词，不评价任何部分；`Living` 只是逐步读法的结构条件；有限世界的规律要求活动可判定；部分的列举不完全；只对离散步的读法陈述；“世界”“生起复现”“止息复现”是 AI 的表述，提议中的“生成的”“退化的”指哪个部分由 Ren 选择（P23c 更正，原文“‘世界’‘生成的’‘退化的’的这些读法是 AI 的表述，名称由 Ren 定”）。本节经第九次独立审查，更正见 §34。

## 31. 完整的陈述与完成审计（P23）

2026-10-09。Ren 的指示：“aim a complete theory of becoming, and finish related work”。计划 P23 把已检查的结果作为一个整体陈述一次，并按这个陈述更新完成审计与开放纲领。本轮不新增 Lean 声明，也不新增成果身份。

```text
Result(s): 复用脊柱的全部记录；无新增成果身份
Delta: 正典章节新增“理论的完整陈述”一节（整体、生与灭、后续活动的条件、分化、地位五部分，每条标明表示／规律／定理／
       公理／读法／开放）；第 8 节重排为现状表与四类开放项（属于 Ren 的选择、哲学根据、经验对应、进一步的证明）；
       根基章节完成审计各行加入脊柱的证据，并加“脊柱的现状”一段；根基记录 theory-of-becoming-foundation 的下一步、
       验证范围、相关与历史；generation-is-replenishment 的“生起的生命”改为“生起的体现关系项”，只在 Ren 的读法下读作生
Supplied premises / correspondence: 无新前提；规律对脊柱所表示的世界成立（离散的步、自然数的量、共同索引；P23c 补：规律需要时活动可判定）
Evidence: 现有回执与记录；无新证明
Boundary: 形式陈述的完整不是必然性已证；每个生成能否这样表示是开放的哲学根据；读法与名称由 Ren 定
Integration: 计划 P23；根基章节第 5 节；为 P23b 的第九次审查提供完整陈述
```

**解读。**

- **“完整”指什么。** 完整的陈述在这个意义上完整：章节的每条主张都标明地位（表示、规律、定理、公理、读法或开放），每个开放项都归入四类之一。它不在这个意义上完整：整体的必然性已证。两种意义在章节、根基章节与根基记录中都分开写。
- **规律与表示。** 不加前提的规律（§26、§29）对每个世界成立，但“世界”是脊柱所表示的世界：离散的步、自然数的量、把条件与关系项对应起来的共同索引（§17），以及规律需要时每一步的活动可判定（P23c 补充，见 §34 M2）。每个生成是否都能这样表示，是一项哲学根据；不能这样表示的部分，需要扩展脊柱，例如连续时间或实数量的表示及其对应。两项分别列入第 8 节的哲学根据与进一步的证明。
- **四类。** 原第 8 节的每个“下一步”都有归类（AI 逐项对照了重排前后的文本）：读法与名称归 Ren 的选择，整体演绎、普遍实践根据、科学探究的根基与 G0／A／N 的根据归哲学根据，机制的实际实现、前提是否被实际展开满足与方向假说归经验对应，其余归进一步的证明，并按依存与同一、读法、继续生成、整体与部分、演化、共同活动、智慧分组。审查不是一类开放内容，单独列出。
- **完整标准的达成（P23c 补充，见 §34 M9）。** 计划 §9 的四项标准中：第 1 项（每种形态都在脊柱上）与第 4 项（开放项分类）满足；第 2 项在 P23c 后满足，可判定性在每处表示清单中公开；第 3 项在 P24 后对世界层面的十个前提满足（八个彼此独立，两个由其余推出），相对于延续关系、更新关系、衰减的储备或条件家族的前提（`NoSplit`、`RenewedBy`、`Decays`、`Depletes`、`Around`）没有映射，标准中的“混合的”部分没有在 `Space` 中定义，“生成的”“退化的”部分指什么由 Ren 选择。
- **完成审计。** 根基章节第 5 节表中每行的“现有证据”加入脊柱的结果，“剩余推论”不变：脊柱定位了整体主张的实质剩余（规律属于整体，前提划出部分），但不完成通向关系构成的连接。根基记录的下一步相应改写，保留原来的中心推论。
- **措辞更正。** generation-is-replenishment 原写“每次生命的生起都是一次补充”。“生命”是 Ren 的读法，不是定理的内容；现在写作生起的体现关系项自身是其他关系项的条件，只在 Ren 把它读作“生”时才读作生命。

**作者反审。**

*反驳 1：“完整的陈述”会被读成理论已经完成。* 章节在说明处与第 11 条、第 8 节开头、根基章节“脊柱的现状”与根基记录中都写明：这是形式陈述的完整，不是必然性已证。现状表中整体演绎、普遍实践根据、智慧之根与科学探究的根基仍标为开放。

*反驳 2：四类的划分本身是 AI 的判断。* 是。例如表示的范围既是哲学根据（每个生成能否这样表示），又引出进一步的证明（扩展脊柱），两面分别列出。Ren 可以重新归类；归类不改变任何结果。

*反驳 3：没有新的证明。* 对。依结果工作流，重述、汇集与复查不是新的独立结果，本轮不登记新成果身份；它的贡献是地位的标注、开放项的归类与完成审计的证据。

**边界。** 无新定理；规律只对脊柱所表示的世界成立；归类是 AI 的判断；“生”“生生”的读法与名称由 Ren 定。本节经第九次独立审查，更正见 §34。

## 32. 前提的地图（P24）

2026-10-09。按同一指示继续计划 P24，在第九次审查进行时完成。计划对“完整”的第三条读法要求每个动力学前提划出整个空间的真部分；§30 对七个前提给出了这一点。本节补上其余世界层面的前提，并把前提彼此对照：哪些推出哪些，其余是否独立。新 L3 模块 `Becoming.Premises`（导入 `Space`）。成果记录：[map-of-premises](../../../../theories/becoming/results/records/map-of-premises.md)。

```text
Result(s): 复用 space-and-its-parts（World、rests、unbalanced、mutualism）、no-finite-part-bears-taking（Enclosed、
           giving_needs_uptake）、more-needs-renewers（Census、Distinct）、evolution-on-descent（DescendsAt、
           TransmitsWithin）、reserve-defers-ending（carries_zero）、life-as-condition-of-life（Embodied、Mutualism）；
           新增 map-of-premises
Delta: Premises：世界上的普查（Counted）与有界传递（Transmitting）；蕴含 Dependent.carried、Finite.counted、
       Finite.enclosed、acting_of_enclosed、Finite.acting、follows；premises、Premised、MeetsAllBut；八个独立性世界
       strained、unbalanced、scatter、morsel、keeping、latent、multitude、novel；independent、none_follows；
       mutualism_premised、premised_rests；列表工具 beyond、keep 及其引理
Supplied premises / correspondence: Finite.counted 与 premised_rests 要求活动可判定；acting_of_enclosed 要求每一步都被围住；
       其余是关于具体世界的陈述
Evidence: 合并检查器回执（见记录）；外围桥接重跑；实例检查
Boundary: 只映射世界层面的八个前提；独立性相对于这八个；相对于另一读法的前提未映射；不评价任何部分
Integration: 计划 P24；完整性的第三条读法；为第十次审查（P24b）提供对象
```

| 声明 | 内容 |
|---|---|
| `Counted`、`Transmitting` | 世界上的普查：每步活跃的关系项被不重复地列出，所以每步只有有限多个活跃；世界上的有界传递：世系在一个界内传递每个依存 |
| `Dependent.carried` | 活动需要支持推出有储备承载（零储备，`carries_zero`） |
| `Finite.counted` | 活动可判定的有限世界有普查：从全部关系项中留下每步活跃的 |
| `acting_of_enclosed`、`Finite.enclosed`、`Finite.acting` | 只有活跃者取用且耗散时，在每个被围住的步上只有活跃者给予，因为那里给予需要取用；有限世界的每一步都被围住 |
| `premises`、`Premised`、`MeetsAllBut` | 八个前提的列表；满足全部；满足除 `P` 以外的全部而不满足 `P` |
| `independent` | strained（不满足活动需要支持）、unbalanced（平衡）、scatter（只有活跃者给予）、morsel（只有活跃者取用其所汲取的）、keeping（耗散）、latent（体现）、multitude（普查）、novel（有界传递），各满足其余七个 |
| `none_follows` | 所以没有一个前提由其余七个推出 |
| `mutualism_premised`、`premised_rests` | 始终活跃的互利者满足全部八个；有限、活动可判定且满足八个的世界中，生起与止息都不再复现，证明用到其中的平衡、耗散与体现（P25b 更正，原文“八个一起使…”；见 §38 O9）（P23c 用语，原文“生成与退化”） |

**解读。**

- **前提之间的结构。** 十个世界层面的前提里，有两个是另一个的较弱形式：有储备承载弱于活动需要支持（零储备），生起者体现弱于每个关系项体现。一个在活动可判定的有限世界中自动成立：普查（P25b 补“活动可判定”；不给可判定性而对每个有限世界要求普查，就蕴含排中律；见 §38 O9）。一个由另两个在被围住的步上推出（逐步的形式 `acting_across` 由 P25b 补出）：只有活跃者取用与耗散推出只有活跃者给予，因为耗散之下给予需要取用。这一条是新的：P13 的“给予需要取用”在世界层面读作，只有活跃者取用时，不活跃的关系项在有限世界中不能给予。
- **其余八个彼此独立。** 对每个前提，都有一个世界满足其余七个而不满足它。所以在这八个之中，没有一个前提藏在其余之中：每个都是对世界的独立限定（P25b 补“在这八个之中”：有限、被围住与可判定性不在地图中，加上它们，只有活跃者给予与普查就推出；多个见证没有流，关于流的四个前提在其中空成立，这足以证明独立，平衡另有取用与耗散每步起约束的见证 `draining_but`；见 §38 O9）。不满足普查的世界（multitude）与不满足只有活跃者给予的世界（scatter）都是无限的；这不是选择见证的巧合，而是蕴含要求的：有限世界有普查，并且在其中只有活跃者取用与耗散推出只有活跃者给予。scatter 中没有一步被围住：每步的交换都伸到无限多个关系项，耗散空成立，P16b 已经披露这种情形（`Spray`）。
- **novel：依存在世系中新形成。** 亲代烧掉燃料的两个单位，给子代一个单位，使子代开始作为条件而在；子代开始依存于亲代，而亲代自己从未有这一依存。所以有界传递不成立：世系中出现了新的依存，而不是传下来的。这是 §29 中“传递是前提”的见证：novel 满足其余七个前提，有界传递却不成立，所以传递不由它们推出。
- **全部一起。** 互利者满足全部八个，所以前提一起是相容的，并且不空：有活动，有依存，有体现；关于流的四个前提在其中空成立，因为没有流（P25b 补；见 §38 O9）。在活动可判定的有限世界中，满足八个的世界归于静止，证明用到其中的平衡、耗散与体现（§30 的 `rests`，生起者体现由体现推出）（P25b 更正，原文“在有限世界中，八个一起使世界归于静止”；见 §38 O9）。所以一个有限的世界若满足全部前提并使生起复现，是不可能的；生起复现需要越出某个前提，或者越出有限（P23c 用语，原文“继续生成”）。

**作者反审。**

*反驳 1：独立性见证太小、太人工。* 是小的。独立性只需要每个前提各有一个反模型；见证越小，越清楚地显示是哪个前提失败。它们不是对实际展开的描述，名称也由 Ren 定。

*反驳 2：“八个前提”的选择是任意的。* 部分是。这八个是脊柱定理在世界层面用到的动力学前提；相对于另一读法的前提（延续关系、更新关系、衰减的储备、条件家族）不是世界本身的限定，需要另一种地图；流中每个参与者只列一次是表示的条件。加入新前提时，独立性要重新检查，可能出现新的蕴含。

*反驳 3：premised_rests 只是 rests 的重述。* 是推论，不是独立结果；它显示的是：满足全部前提的有限世界没有生起复现的余地（P23c 用语，原文“继续生成”）。新的内容是蕴含、两个新前提与独立性。

**边界。** 无伦理谓词，不评价任何部分；只对离散步的读法陈述；有限世界的蕴含要求活动可判定；只映射世界层面的八个前提；前提与世界的名称是 AI 的表述，由 Ren 定。本节尚未经独立审查（计划 P24b）。

## 33. 开放（P25）

2026-10-09。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P25。§30 的 `rests` 用有限使世界归于静止；§31（P23）陈述的理论在其第 8 节把这一点列为开放：在普查与被围住之下（而不只是有限时），全部前提是否使世界归于静止。本节回答：世界不必有限；起作用的是每步立着的有限多（活动的普查连同每个关系项体现），连同被围住（P25b 更正，原文“起作用的是被围住，不是有限”；见 §38 O1）。新 L3 模块 `Becoming.Openness`（导入 `Premises`）。成果记录：[continued-change-needs-openness](../../../../theories/becoming/results/records/continued-change-needs-openness.md)。

```text
Result(s): 复用 no-finite-part-bears-taking（Balances.runs_down、rise_lowers_on、Enclosed.around、Dissipative）、
           rising-and-falling-in-one-exchange（Balances.fall_taken）、generation-is-replenishment（ComesToStand.rises、
           Handing）、map-of-premises（Premised、Counted、beyond）、space-and-its-parts（World、ArisingRecurs、
           CeasingRecurs、Embodied；P23c 前为 Generative、Degenerative）、coming-and-ceasing-keep-pace（Ceases）、Renewal 的 falls_finitely；
           新增 continued-change-needs-openness
Delta: Openness：所立者的普查（Web.StandingCensus）与围住所立者的步（Flow.AroundStanding）；stock_eq、
       Enclosed.aroundStanding、fall_lowers_on、standing_runs_down、standing_never_rises、change_lowers、stills；
       世界上的 standingCensus、rises_of_arises、falls_of_ceases、rests_around、rests_enclosed、arising_opens（P23c 前为 generation_opens）；
       见证 exposed 与 exposed_world；列表工具 mem_append_left、mem_append_right
Supplied premises / correspondence: 平衡；耗散；所立者的普查；从某步起每步围住所立者。世界层面另要求活动的普查与每个
       关系项体现；rests_enclosed 与 arising_opens 要求关系项的相等可判定（P25b 起不要求，见 §38 O3）
Evidence: 合并检查器回执（见记录）；外围桥接重跑；实例检查
Boundary: 要求每个关系项体现，不只是生起者；耗散只约束被围住的交换，exposed 中它空成立；不评价开放或静止
Integration: 计划 P25；回答理论第 8 节列出的开放项；为第十次审查（P24b）提供对象
```

| 声明 | 内容 |
|---|---|
| `Web.StandingCensus`、`Flow.AroundStanding` | 每步立着的条件被不重复地列出；一步围住所立者：某个不重复、跨过该步封闭的家族包含该步前后立着的每个条件 |
| `StandingCensus.stock_eq`、`Enclosed.aroundStanding` | 所立者的总水平就是包含它的任何不重复家族的存量；关系项的相等可判定时，被围住的步围住所立者 |
| `standing_runs_down`、`standing_never_rises` | 跨过围住所立者的步，总水平下降至少为取用围住它的家族的形成数，所以不上升 |
| `fall_lowers_on`、`change_lowers` | 被耗散的家族中成员下降使存量下降（它被取用）；所以任何条件的水平上升或下降都使总水平下降 |
| `stills` | 从某步起每步都围住所立者时，没有条件的水平在任意晚的步变化 |
| `standingCensus`、`rises_of_arises`、`falls_of_ceases` | 活动的普查与每个关系项体现给出所立者的普查；体现的关系项生起即上升，止息即下降 |
| `rests_around`、`rests_enclosed` | 有普查、每个关系项体现、平衡且耗散的世界，从某步起每步围住所立者（相等可判定时：每步被围住）时，生起与止息都不再复现（P23c 用语，原文“生成与退化”） |
| `arising_opens` | 所以这样的世界生起复现时，并非从某步起每步都被围住（P25b 更正，原文“在任意晚的步有不被围住的步”，构造上更强；见 §38 O11）（P23c 改名，原名 `generation_opens`，原文“生成不息”） |
| `exposed`、`exposed_world` | Handing 的两侧另外在每步从无限多个地关系项各取一个单位再还回：满足全部八个前提，生起复现，没有一步被围住（P25b 补：总水平每步都是一；活动需要支持、有界传递与耗散在其中空成立；见 §38 O5、O6） |

**解读。**

- **总水平是只降不升的量。** 平衡与耗散一起，使跨过被围住的步的总水平不上升；更强地，任何水平的变化都使它严格下降。上升被给予，而在被围住的步上给予需要取用；下降被取用。所以变化本身消耗总水平。自然数的量只能严格下降有限多次（`falls_finitely`），所以被围住的展开中，变化只能有限多次。
- **世界的有限不是关键。**（P25b 更正，原标题“有限不是关键”：每步立着的有限多仍是关键，见 §38 O1。）§30 的 `rests` 要求关系项总共有限；这里关系项可以无限多，只要每步立着的有限多个被列出，且每步的交换被某个有限家族围住。两者都不是对方的特例：`rests` 要求有限而只要求生起者体现；这里不要求有限而要求每个关系项体现。
- **开放是生起复现的必要条件。** 读作对立面：满足普查、体现、平衡与耗散的世界若生起复现（P23c 用语，原标题与原文“生成不息”），那么在任意晚的步，有一步的交换伸到每个有限家族之外。这是 §17、§20（P13、P15）中家族层面的开放在世界层面的陈述，而且用变化的所立者，不是固定的家族。
- **exposed：开放不能去掉。** Handing 的两侧来回传递一个单位的水平，生起复现；另外在每步与无限多个地关系项交换一个单位，取用再还回，使地的水平保持为零。由于每步取用无限多个关系项，没有有限家族跨过任何一步封闭，所以耗散空成立。它满足全部八个前提（普查只列出立着的那一侧），生起复现。所以在八个前提之下，被围住这一条件不能从 `rests_enclosed` 中去掉（P25b 补：它说明八个前提推不出被围住；推不出开放要另一个见证，满足八个而每步被围住的互利者（`openness_contingent`）；它的开放是零净量的交换；见 §38 O4、O6）。

**作者反审。**

*反驳 1：exposed 只是利用耗散的表示漏洞。* 是利用了一个已披露的特点：耗散只约束被围住的交换（P16b、`Spray`）。这正是要显示的：被围住不是由八个前提推出的，它是一个独立的、关于开放的条件。地的交换（取一再还一）是零净流，它不给两侧任何东西；它只使每一步不被围住。一个要求“每步只与有限多个关系项交换”的更强耗散会排除它，但那是另一个前提，应当公开地加入，而不是藏在耗散里。

*反驳 2：要求每个关系项体现太强。* 是比 `rests` 的“生起者体现”强。止息读作下降，需要止息者体现；生起读作上升，需要生起者体现。只要求生起者体现时，`stills` 仍使生起停止吗？不立着却活跃的关系项可以不断止息而不改变水平；所以止息复现的部分需要更多。是否可以只用生起者体现得到生起复现的部分，列为下一步（记录的 next_delta）（P25b：已有答案：只有活动的普查时不能，kindling 每步被围住而生起不息（`rest_needs_standing`）；有所立者的普查时生起停止（`arising_stops`），止息不一定（dusk）；见 §38 O2）（P23c 用语，原文“生成停止”“退化部分”“生成部分”）。

*反驳 3：可判定的相等是额外前提。* 不是构造性证明的要求：被围住的步不是不围住所立者，而 `stills` 比较的是自然数，判定已在那里；P25b 去掉了这一要求（`Enclosed.around_not_not`）。`rests_around` 不要求它，直接以围住所立者为前提（P25b 更正，原文“是构造性证明的要求：把立着的两个列表合并为一个不重复的家族要判定相等。经典地它总是成立”；见 §38 O3）。

**边界。** 无伦理谓词，不评价开放或静止；只对离散步与自然数的量陈述；“开放”“被围住”“所立者”的读法与名称是 AI 的表述，由 Ren 定。本节经[第十次独立审查](../history/root-foundation/BECOMING-P23C-P24-P25-REVIEW.md)，更正见 §38。

## 34. 第九次独立审查与更正（P23c）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P18b（§27）、P19（§26）、P20（§28）、P21（§29）、P22（§30）与 P23（§31）（[审查](../history/root-foundation/BECOMING-P18B-P23-REVIEW.md)）。它在仓库之外从前导重新编译核心闭包的 27 个模块，1571 条源声明的公理报告全空；闭包的 4423 个常量中依赖公理的只有 30 条编译器生成的 `injEq` 引理，都只依赖 `propext`，与回执所列相同；回执、源哈希、保留产物、引用哈希与证明绑定都对，数学全部接受，Lean 中没有数学错误。第八次审查的 L1–L10 全部关闭。它提出十项（M1–M10）：一项替 Ren 选择了读法（M1，最严重），四项省略前提（M2、M4、M5、M6），一项散文中的错误（M3），两项缺少反例（M7、M8），两项表述与记账（M9、M10）。P24（§32）与 P25（§33）在审查期间提交，审查没有读；其中受 M1 影响的用语一并更正。本节记录逐项处理。探针 N1、N4–N7 移入核心，公理报告为空。§26、§28–§33 与英文段落中受影响的句子已就地更正并标明；原文见提交 `a69455e3`。

```text
Result(s): 更正 space-and-its-parts（M1、M2、M7、M8）、evolution-on-descent（M3、M6）、
           rising-and-falling-in-one-exchange（M5）、coming-and-ceasing-keep-pace（M1 的对应说明）、
           theory-of-becoming-foundation（M2、M10(b)）、generation-is-replenishment（M10(a)）；随 M1 改名更正
           map-of-premises 与 continued-change-needs-openness；没有新的成果记录
Delta: Space：Generative、Degenerative、generative_ofRoles、degenerative_ofRoles、generative_iff、handing_generative 改名为
       ArisingRecurs、CeasingRecurs、arisingRecurs_ofRoles、ceasingRecurs_ofRoles、arising_iff_ceasing、handing_arising（M1）；
       Undecided、undecided_world 与 law_decides（M2，探针 N1）；Grazing、grazing_world 与 grazing_not_self，
       living_crosses 的不活一角改用 grazing（M7，探针 N6）；Leaking 与 leaking_world，rests_needs 的平衡一行改用它
       （M8，探针 N7）。Evolution：selected_uniform、unselected（M3，探针 N5）；Slack（M6，探针 N4）。Openness：
       generation_opens 改名为 arising_opens。模块说明、章节、根基章节、记录与计划的用语、标注与前提（M1–M10）
Supplied premises / correspondence: 不变；可判定性作为逻辑承诺与表示的其他承诺一起公开；提议中“生成的”“退化的”
       指哪个部分列为 Ren 的选择
Evidence: 合并检查器回执 20261009T132323.308231Z（1016 项定理／1662 项声明审计，核心闭包 29 个模块，包 27 个模块，
          源声明的公理报告全空）；外围桥接重跑 20261009T132432.792943Z；实例检查通过
Boundary: 不含伦理结论；不替 Ren 选择任何读法；新名称是建议；探针与新见证都是最小见证
Integration: §26、§28–§33 的更正；审查 §4 的第 1–6 项完成，第 7 项（Ren 的选择）保持开放
```

### 34.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| M1 | P22 把 Ren 提议中的“generative, degenerative”读作某个关系项在任意晚的步生起／止息，据此在正典中陈述有限世界中两者是同一部分、彼此交叠；Ren 2026-10-09 说二者不重叠，正典没有提到这句原话，也没有把这一读法列为 Ren 的选择。读法始于 P19 的作者读法 | 世界的部分按活动命名：`World.ArisingRecurs`、`CeasingRecurs`、`arising_iff_ceasing`（生起复现／止息复现），连同 `arisingRecurs_ofRoles`、`ceasingRecurs_ofRoles`、`handing_arising`；`Openness` 的 `generation_opens` 改为 `arising_opens`。模块说明写为“states one structure for that proposal (an AI reading)”，写出 Ren 的原话与脊柱上的两种读法：活动的读法（生起复现与止息复现，有限世界中重合）与关系的读法（更新的形成与消耗的形成，作为关系不重叠，`Web.renewing_not_consuming`）。章节第 2、4 条，§2，§8 现状行，词汇表，记录的标题与对应，§26、§30 与根基第 1 行改写；词汇表保留 Ren 的用语“生成的／退化的”一行，指向关系的读法，另列“生起复现／止息复现”。章节 §8 Ren 的选择新增第一项：提议中的“生成的”“退化的”指哪个部分。计划 P22 行注明：退化的部分实现为止息复现，消耗不在其中 |
| M2 | 有限世界的规律需要活动可判定，对每个世界而不给可判定性就是排中律（探针 N1）；表示承诺的三处清单漏掉了它，根基第 1 行写“不加前提” | 三处清单（章节说明处、§8 哲学根据、根基“脊柱的现状”）加入“规律需要时每一步的活动可判定”；§8 哲学根据另加“逻辑承诺”一项。N1 移入核心：`Undecided`（一个关系项，没有流，活动以四为周期：不活跃、活跃、`Q`、不活跃）与 `World.law_decides`：若每个有限世界中生起复现都推出止息复现，则任何命题都有 Q ∨ ¬Q。根基第 1 行与根基记录的关联说明写为“活动可判定的有限世界”；第 4 条 `rests` 一句加入可判定；“活动不可判定时的规律”在进一步的证明中写明只在经典逻辑下成立，不能进入纯核心。§30 反驳 2 就地补充 |
| M3 | `price` 被说成把从亲代到后代的变化分为选择项与传递项；等式分解的是后代的总量，所谓选择项在没有任何选择时也不为零（探针 N5） | `Evolution` 的模块说明、`selected` 与 `price` 的说明、章节第 2 条与 §2、记录的主张、§29 与词汇表改为：后代的总量分为亲代的量按其后代加权的总量与传递的变化；加权总量不是真正的选择项，真正的选择项（后代数与量的协方差）没有陈述。N5 移入核心：`selected_uniform`（每个亲代都有 k 个后代时，加权总量是亲代总量的 k 倍）与 `unselected`（一个亲代、一个后代，量都是五：加权总量为五，传递项为零）。`selected_le` 与 `selection_within` 作为关于加权总量的陈述不变 |
| M4 | 第 4 条末句“在耗散之下继续生成，展开须越出每个有限部分”省略平衡与生起者体现；`flicker` 与 `unbalanced` 是有限的反例 | 改为：在平衡与耗散之下，不重复的有限家族中体现的成员在任意晚的步生起，家族就在任意晚的步不封闭，被围住时汲入（`Web.generation_opens`、`generation_draws_in`）。词汇表“汲入”一行与 §30 解读中 kindling 一句随之更正 |
| M5 | (a) “在耗散之下”上升伴随下降，缺“该步被耗散的家族”（探针 N2 `Spray`）；(b) “消耗前提由平衡与耗散推出”缺“且被取用”（探针 N3 `Still`） | (a) 章节第 4 条首句、记录 rising-and-falling-in-one-exchange 的标题、§9 Dissipation 与 Roles 两行、根模块与包说明改为“在家族被耗散的一步上”；§28 解读与英文 P20 就地更正。(b) §8“继续生成”行、§9 Dissipation 行、根模块与计划 P20 行改为“对各步家族被耗散且被取用的事件”。N2 与 N3 留在审查的探针中：更正后的陈述已写出被缺的前提 |
| M6 | “传下来的所需曾在给予之步被满足”只在界 δ 为零时成立（探针 N4） | 章节第 8 条、§2、§8 演化行与 §9 Evolution 行改为：传下来的所需至多比给予之步条件的水平多传递的界，界为零时曾在那里被满足。N4 移入核心：`Slack`（池、亲代与子代；流平衡、只有活跃者给予、活动需要支持、对池的依存在界一之内传递；子代跨第 0 步从亲代而来，所需为二，池在给予之步与每一步都只有一）。§29 就地更正 |
| M7 | `living_crosses` 中“生成复现而有不活”的唯一见证 `spending`，依赖 Ren 尚未作出的选择：终结之步对承担自身的体现关系项的自我汲取是否计入不活 | N6 移入核心：`Grazing` 与 `World.grazing`、`grazing_world`：在 `Handing` 上加一个池、一个放牧者与一个食草者，两者以需要一与二依存于池，都在第 0 步活跃，放牧者在这一步从池取用一个单位。世界有限、生起复现、`Dependent`、平衡、`Acting`、`Taking`，而不 `Living`：放牧者的事件侵蚀食草者对池的依存；池不是汲取者，也从不活跃，放牧者自己的依存在该步之后仍满足（`grazing_not_self`）。`living_crosses` 的这一角改用 grazing；`spending` 保留在 `contingent` 中，模块说明写明它只在那一判定下不活。§30 解读就地更正 |
| M8 | `rests_needs` 的平衡见证 `unbalanced` 没有流，耗散空成立（探针 N7） | N7 移入核心：`Leaking` 与 `World.leaking`、`leaking_world`：保留 `Handing.web`，持有者每步取用自己的一个单位而不给予。世界有限、生起复现、耗散、每个关系项体现，两侧的家族在每步封闭且被取用，只有平衡不成立。`rests_needs` 的平衡一行改用它；`unbalanced` 保留在 `contingent` 与 `Premises` 中。模块说明写明：`flicker` 的耗散在尾部空成立是被迫的，有限、平衡、耗散的世界中取用不复现（`Flow.Dissipative.finite_ceases`） |
| M9 | (a) “规律”的标注把定义上的同一、算术恒等式与二值和有限的推论归为一类；(b) 智慧一项归入进一步的证明；(c) 计划的四项完整标准中第 2、3 项部分未满足，现状没有写出 | (a) 章节第 2 条分为三种并各自标注：〔定义上的同一〕`change_readings`；〔算术恒等式〕`over_stretch`、`price`；〔二值与有限的推论〕`keep_pace`、`coming_recurs_iff`、`arising_iff_ceasing`。(b) 智慧一项移到经验对应（两种语言）。(c) 计划 P23 行与 §31 写明各标准的达成，见 §31 的补充 |
| M10 | (a) 四份记录的审查时间晚于包含它的提交；(b) 根基记录的中文用语与章节不一致；(c) §29 反驳 3 残留“给予者” | (a) generation-is-replenishment 改为 12:05:00，早于 P23 提交；evolution-on-descent、space-and-its-parts 与 theory-of-becoming-foundation 在本次内容修订中刷新为本次修订的时间。审查没有读的 map-of-premises 与 continued-change-needs-openness 的审查时间同样晚于各自的提交，本次内容修订时一并刷新。(b) 根基记录的关联说明改用章节的用语：止息、开始与不再作为条件而在、开始成立与不再成立，并写出可判定。(c) 改为“只说给予它的形成给予” |

### 34.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Space | `World.ArisingRecurs`、`CeasingRecurs`、`arisingRecurs_ofRoles`、`ceasingRecurs_ofRoles`、`arising_iff_ceasing`、`handing_arising` | 改名，陈述不变：某个关系项在任意晚的步生起／止息；两类读法中读法相同；有限且活动可判定的世界中两者等价 |
| Space | `Undecided.act`、`four`、`le_four`、`arises_at`、`web`、`decides`、`World.undecided`、`undecided_world`、`law_decides` | 一个关系项，活动以四为周期：不活跃、活跃、`Q`、不活跃。世界有限，不论 `Q` 如何，每个周期开始时生起；任何止息都判定 `Q`。所以有限世界的规律对每个世界成立就推出排中律 |
| Space | `Grazing.Relatum`、`web`、`flow`、`side_taking` 等，`World.grazing`、`grazing_finite`、`grazing_arising`、`grazing_balanced`、`grazing_acting`、`grazing_taking`、`grazing_dependent`、`grazing_not_self`、`grazing_world` | `Handing` 的两侧加上池、放牧者与食草者；第 0 步放牧者从池取用一个单位，侵蚀食草者的依存。有限、生起复现、`Dependent`、平衡、`Acting`、`Taking`，而不 `Living`；放牧者只汲取池，池从不活跃，放牧者自己的依存在该步之后仍满足 |
| Space | `Leaking.flow`、`takes`、`World.leaking`、`leaking_world` | `Handing.web` 上，持有者每步取用自己的一个单位而不给予。有限、生起复现、耗散、每个关系项体现，不平衡；两侧的家族每步封闭且被取用 |
| Space | `living_crosses`、`rests_needs`（更正） | 生起复现而有不活的一角用 grazing；平衡一行用 leaking |
| Evolution | `selected_uniform`、`unselected` | 每个亲代都有 k 个后代时，加权总量是亲代总量的 k 倍；一个亲代、一个后代、量都是五时，加权总量为五，传递所升高与降低的都为零 |
| Evolution | `Slack.Relatum`、`web`、`flow`、`dependent`、`slack` | 流平衡、只有活跃者给予、活动需要支持、对池的依存在界一之内传递；子代从亲代而来，所需为二，池在给予之步与每一步的水平都是一：传下来的所需可以从未被满足 |
| Openness | `World.arising_opens` | 改名，陈述不变 |
| Premises | `premised_rests` | 陈述用新名：不生起复现，也不止息复现 |

### 34.3 审查列出的会改变判断的结果

1. 生成的与退化的（M1）：有限世界的规律以生起复现与止息复现陈述，正典中不再说“生成的”与“退化的”是同一部分、彼此交叠；Ren 的原话与关系的读法写在旁边；读法列为 Ren 的选择。完成。
2. 可判定性（M2）：加入每处表示清单，在根基第 1 行、根基记录与第 4 条恢复，并作为逻辑承诺列出；不可判定时的规律就是排中律，由 `law_decides` 证明。完成。
3. `price`（M3）：写明它分解什么，“选择项”只留给协方差。完成；协方差形式仍列为进一步的证明。
4. 完整陈述中的前提（M4–M6）：完成。
5. 见证（M7、M8）：grazing 与 leaking 移入核心。完成。
6. 表述（M9、M10）：完成。
7. Ren 的选择保持开放：提议中“生成的”“退化的”的读法（新增）；“生”“生生”与第二个“生”的读法，包括依赖消耗的生起是否算作生成；终结之步对承担自身的体现关系项的汲取是否计入不活、对哪些汲取者；接续的读法与生生不息读到哪个层次；以之为生与世系是否作为直接的估值；名称。
8. 审查没有构造而仍开放的：`rests` 中体现必要性的非空见证（尾部空成立是被迫的，见 M8）；`price` 的协方差形式；外围中经典逻辑下的有限世界规律。

### 34.4 作者反审

*反驳 1：改名只是换词。* 不是。旧名把 Ren 的用语给了一种读法，正典据此把“生成的与退化的是同一部分”陈述为定理，而 Ren 说二者不重叠。新名说出定理实际说的：活动的复现。Ren 的用语留给 Ren 选择，脊柱上的两种候选都写出。关系的读法（`RenewingIn`、`ConsumingIn`）相对于一个形成；把它提为世界的部分，需要选择怎样对形成量化，这也属于 Ren 的选择之后的工作，不在本次。

*反驳 2：`law_decides` 削弱了“不加前提的规律”。* 它不削弱定理，而是写明定理的逻辑承诺：在纯核心中规律以可判定为前提，这正是它能构造性地证明的形式；不加这一前提，规律就是排中律，不能进入纯核心。经典地每个世界的活动都可判定，所以它不是关于任何展开的前提，但它是逻辑的承诺，按 Ren 的优先指令与方法、模型、对应与规范的前提分开公开。

*反驳 3：grazing 也依赖读法。* 它依赖逐步读法中“侵蚀”的定义：活跃者的汲取使另一个关系项已满足的依存在该步之后落空。这是 `Living` 的定义本身，不是附加的选择。它不依赖终结之步自我汲取的判定：不活的事件汲取的是池，池不是汲取者，也从不活跃（P25b 更正：它在 §8 所写的选择之外，但被侵蚀的食草者在该步之后不活跃（`grazing_browser_ends`）；活动需要支持时，对持续不变的依存的每次侵蚀都使依存者在该步之后不活跃（`Web.Dependent.inactive_below`；P29b 更正，原文“都与依存者的终结同时”：依存者原本休眠时没有终结，见 §42 R1），所以“不依赖终结之步的判定”预设了 Ren 的选择只涉及被汲取者自身的终结；见 §38 O10）。它仍然依赖两类读法的同一对应，这是表示的前提，已公开。

*反驳 4：既然 `selected` 不是选择项，`price` 还有什么用。* `price` 是会计恒等式，审查与本研究都这样说；它的用处在于加权总量受条件的水平所限（`selected_le`、`selection_within`），这把支持对给予的约束写进后代的总量。真正的选择项需要整数或有理数的量与均值，列为进一步的证明。

**边界。** 不含伦理谓词；不改变任何读法选择的地位，新增的一项（提议中“生成的”“退化的”的读法）列为 Ren 的选择；新名称是建议；探针与新见证都是最小见证；可判定性是公开的逻辑承诺。本节的更正经[第十次独立审查](../history/root-foundation/BECOMING-P23C-P24-P25-REVIEW.md)，见 §38。

## 35. 止息需要生起与静止定理（P26）

2026-10-09。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P26。§30 的 `rests` 要求世界有限，§33 的 `rests_around` 不要求有限而要求每个关系项体现；记录 continued-change-needs-openness 的 next_delta 列出：只要求生起者体现时，被围住的世界是否也归于静止。本节的回答：再有所立者的普查时是肯定的（只有活动的普查时是否定的，kindling；P25b 更正，原文“本节的回答是肯定的”；见 §38 O2），靠的是一条计数的定律：在活动的普查之下，止息复现需要生起复现（普查定律）。于是归于静止只需生起停止，而生起者体现时，`stills` 使生起停止。由此得到一个静止定理，§30 的有限情形与 §33 的每个关系项都体现的情形都是它的推论。没有新模块：普查定律放在活跃形成的普查所在的 `Becoming.Population`，静止定理及其情形放在 `Becoming.Openness`。成果记录：新增 [ceasing-needs-arising](../../../../theories/becoming/results/records/ceasing-needs-arising.md)；修订 [continued-change-needs-openness](../../../../theories/becoming/results/records/continued-change-needs-openness.md)。

```text
Result(s): 复用 coming-and-ceasing-keep-pace（Arises、Ceases、Unceasing）、more-needs-renewers（Web.Census、search、
           length_le_of_sub）、map-of-premises（Counted、Finite.counted、keep）、space-and-its-parts（World、
           ArisingRecurs、CeasingRecurs、ArisingEmbodied、rests、dawn、dusk、separate）、continued-change-needs-openness
           （StandingCensus、AroundStanding、stills、rests_around）；新增 ceasing-needs-arising；修订 continued-change-needs-openness
Delta: Population：Web.arises_or_kept、arises_or_fewer、arises_within、arising_of_ceasing；Openness：World.arising_of_ceasing、
       Dawn.alive、mem_alive、alive_distinct、Dawn.census、World.census_one_way、World.comes_to_rest、Finite.standing、
       Finite.comes_to_rest、rest_needs_census；rests_around 改由静止定理证明
Supplied premises / correspondence: 普查定律：活动的普查（Census，每步活跃的形成列为不重复的有限表），世界层面另要求活动可判定；
       静止定理：活动的普查与可判定、所立者的普查、生起者体现、平衡、耗散、从某步起每步围住所立者
Evidence: 合并检查器回执 20261009T135303.461724Z（1029 项定理、1676 项声明审计、核心闭包 29 个模块、包 27 个模块，全部源声明公理报告为空）；
       外围桥接重跑 20261009T135417.468399Z；实例检查
Boundary: 普查定律是单向的（dawn）；普查不可少（dusk）；只对离散步与自然数的量陈述；不评价静止或开放；
       “生起复现”“止息复现”是活动的读法，是否为 Ren 提议中的“生成的”“退化的”由 Ren 选择（§34，M1；P25b 更正，原文“不是 Ren 的…”，见 §38 O8）
Integration: 计划 P26；回答 continued-change-needs-openness 的 next_delta；把 §30 与 §33 的两个静止定理合为一个
```

| 声明 | 内容 |
|---|---|
| `Web.arises_or_kept` | 从 N 到 T 之间，或者有形成生起，或者 T 时活跃的每个形成在 N 时已活跃（P27 推广为 `Listed.comes_or_held`） |
| `Web.arises_or_fewer` | N 之后某形成在 T 止息时，或者 N 之后有形成生起，或者 T + 1 时活跃的形成比 N 时少（P27 推广为 `Listed.comes_or_fewer`） |
| `Web.arises_within`、`Web.arising_of_ceasing` | 在普查之下，止息在任意晚的步发生时，活跃形成的数目不能一直下降，所以生起在任意晚的步发生（P27 把 `arises_within` 推广为 `Listed.comes_within`，`arising_of_ceasing` 成为 `Listed.coming_of_ceasing` 的活动读法） |
| `World.arising_of_ceasing` | 世界层面：活动可判定且有普查（`Counted`）时，止息复现推出生起复现 |
| `Dawn.alive`、`Dawn.census`、`World.census_one_way` | dawn 有普查（第 t 步活跃的恰是此前生起的 t 个），生起复现而止息不复现；dusk 止息复现而没有生起，所以按普查定律它没有普查 |
| `World.comes_to_rest` | 静止定理：有活动与所立者的普查、活动可判定、生起者体现、平衡、耗散，且从某步起每步围住所立者的世界，生起与止息都不再复现 |
| `World.Finite.standing`、`World.Finite.comes_to_rest` | 有限世界列出所立者（水平为正的关系项），每步围住它；所以 §30 的 `rests` 是静止定理的有限情形 |
| `World.rest_needs_census` | dusk 中没有立着的条件、没有取用与给予：所立者的普查为空表，每步围住所立者，生起者体现、平衡、耗散都成立，止息复现，没有活动的普查 |
| `World.rests_around` | 每个关系项都体现时，活动的普查列出所立者，活动由水平判定，于是由静止定理得到（P26 改证，陈述不变） |

**解读。**

- **普查定律是计数，不是有限。** 普查只要求每步活跃的形成有限且被不重复地列出，关系项总共可以无限多。一次之前没有生起的止息，使活跃的形成比先前少；数目是自然数，不能无穷地下降；所以止息在任意晚的步发生，迫使生起也在任意晚的步发生。反之不然：dawn 每步生起一个新的、从不止息，它有普查，止息不复现。dusk 中无穷多个初始形成依次止息而没有生起：它在第 0 步有无穷多个活跃者，没有普查。§30 的“活动可判定的有限世界中，生起复现恰当止息复现”于是分成两半：止息推出生起只需普查；生起推出止息需要有限，或别的约束同时活跃者的界。
- **静止定理。** 归于静止只需生起停止，止息由普查定律跟着停止。生起者体现时，生起就是水平上升；从某步起每步围住所立者时，平衡与耗散使水平不再变化（`stills`），所以生起停止。这把 §30 的 `rests`（要求有限，只要求生起者体现）与 §33 的 `rests_around`（不要求有限，要求每个关系项都体现）合为一个定理：两者的区别不在静止的机制，只在怎样得到所立者的普查与围住。有限给出两者；每个关系项都体现给出所立者的普查，围住仍是前提。
- **活动的普查不可少。** dusk 满足其余每个前提：没有立着的条件，所以所立者的普查是空表，每步都平凡地围住所立者；没有生起，所以生起者体现空成立；没有取用与给予，所以平衡与耗散成立。止息仍复现。失效的不是围住，而是普查：无穷多个不立着的活动可以依次终结，而不改变任何水平。止息在这里不读作下降，因为止息者不体现；普查定律越过了这一点，不要求止息者体现。
- **它仍是活动的读法。** 生起复现与止息复现是否为 Ren 提议中的“生成的”“退化的”由 Ren 选择（§34，M1；P25b 更正，原文“不是 Ren 的…”，见 §38 O8）；静止不是评价，开放也不是。

**作者反审。**

*反驳 1：普查定律只是平凡的计数。* 证明确实只用不重复列表的长度比较（`length_le_of_sub`）与自然数不能无穷下降。它的内容在于划分：§30 的同一部分在普查之下只剩一个方向，另一个方向需要更多，两半分别由 dawn 与 dusk 见证。它也解释了静止的世界中止息为什么停止，而不要求止息者体现：这正是 §33 反驳 2 留下的问题。

*反驳 2：静止定理是否只是把前提重排？* 它使两个已有定理成为同一定理的推论，并把 `rests_around` 的“每个关系项都体现”换成“生起者体现”加上所立者的普查。它覆盖的新情形是：关系项无限多、有活跃而不体现的关系项、只有生起者体现的世界。一个只被静止定理覆盖而不被 `rests` 与 `rests_around` 覆盖的见证容易构造（无限多个空闲的关系项旁有一个活跃而不立着的关系项），但本节没有在 Lean 中给出它，所以“严格更一般”只是陈述层面的比较，不是已检查的定理。

*反驳 3：可判定性是额外前提。* 普查定律在世界层面要求活动可判定，因为构造性的证明在下一步活跃者的表中查找此前不活跃者（`search`）。这是表示的逻辑承诺（§34，M2）。每个关系项都体现时，活动由水平判定，所以 `rests_around` 不另加它。

*反驳 4：耗散在这里只约束被围住的交换。* 是（P16b、`Spray`、§33 的 exposed）。静止定理以围住为前提，没有把开放藏进耗散；exposed 仍表明，八个前提之下去掉围住，生起可以不息。

**边界。** 无伦理谓词，不评价静止、开放或止息；只对离散步与自然数的量陈述；“普查”“静止定理”“归于静止”的名称与读法是 AI 的表述，由 Ren 定。没有所立者的普查时被围住的步（kindling 一类的世界）仍列为下一步（P25b：已回答，kindling 与 ember 每步被围住而生起不息，`rest_needs_standing`；见 §38 O2）。本节尚未经独立审查：第十次独立审查的对象截至 P23c。

## 36. 普查定律的一般形式与有界普查（P27）

2026-10-09。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P27。§35 的普查定律只走一个方向：在普查之下，止息复现需要生起复现，dawn 表明反之不然。§30 的“活动可判定的有限世界中，生起复现恰当止息复现”于是分成两半，另一半（生起推出止息）需要什么，§35 只说“需要有限，或别的约束同时活跃者的界”。本节给出答案：需要的恰是计数的界。同时把普查定律推广到每步其成立者被列出的任何规定，活动与水平是它的两种读法，回答 ceasing-needs-arising 的下一步（同一规律读于水平）。没有新模块：一般形式放在 `Becoming.Population`，世界上的读法、水平的读法与见证放在 `Becoming.Openness`。成果记录：新增 [bounded-census-keeps-pace](../../../../theories/becoming/results/records/bounded-census-keeps-pace.md)；修订 [ceasing-needs-arising](../../../../theories/becoming/results/records/ceasing-needs-arising.md)。

```text
Result(s): 复用 ceasing-needs-arising（普查定律、Dawn.census、census_one_way）、coming-and-ceasing-keep-pace（ComesToBe、
           CeasesToBe、coming_recurs_iff、unceasing_iff）、space-and-its-parts（World、Finite、arising_iff_ceasing、dawn、
           Flow.still）、map-of-premises（Counted、Finite.counted、beyond）、more-needs-renewers（Census、search、
           length_le_of_sub）、continued-change-needs-openness（StandingCensus）；新增 bounded-census-keeps-pace；
           修订 ceasing-needs-arising
Delta: Population：Listed（每步成立者的列出）；Listed.comes_or_held、comes_or_fewer、comes_within、coming_of_ceasing
       （P26 的 Web.arises_or_kept、arises_or_fewer、arises_within 推广而来）；Listed.ceases_or_kept、ceases_or_more、
       ceases_within、ceasing_of_coming、coming_iff_ceasing；Web.Census 定义为活动的列出；Web.ceasing_of_arising、
       unceasing_iff_bounded；Openness：Web.StandingCensus 定义为水平的列出；StandingCensus.coming_of_ceasing、
       coming_iff_ceasing；World.CountedWithin、CountedWithin.arising_iff_ceasing、Finite.countedWithin、
       Finite.arising_iff_ceasing、dawn_unbounded；见证 Procession.web、Procession.census、procession、procession_world
Supplied premises / correspondence: 一般形式：每步成立者的不重复列出，每步可判定；有界形式另要求列表长度不超过同一个 B
Evidence: 合并检查器回执 20261009T141652.167311Z（1045 项定理、1697 项声明审计、核心闭包 29 个模块、包 27 个模块，
       全部源声明公理报告为空）；外围桥接重跑 20261009T141825.143331Z；实例检查。中间回执 20261009T141236.619967Z
       （外围 20261009T141402.494945Z）检查了推广之前的版本，保留为证据
Boundary: 界须对所有步统一；不给比率；不评价生起或止息；“生起复现”“止息复现”是活动的读法，是否为 Ren 提议中的“生成的”“退化的”由 Ren 选择（P25b 更正，原文“不是 Ren 的…”，见 §38 O8）
Integration: 计划 P27；回答 §35 留下的一半与 ceasing-needs-arising 的下一步；有限世界的规律成为有界普查定律的情形
```

| 声明 | 内容 |
|---|---|
| `Listed` | 一个规定每步的成立者被不重复地列出：每步有限多个成立，成员总共可以无限多 |
| `Listed.comes_or_held`、`comes_or_fewer`、`comes_within`、`coming_of_ceasing` | 普查定律的一般形式：不再成立复现需要开始成立复现（P26 的活动版本推广而来） |
| `Listed.ceases_or_kept`、`ceases_or_more` | 从 N 到 T 之间，或者有成员不再成立，或者 N 时成立的在 T 时都成立；一次开始成立若此前没有不再成立，使列表比 N 时长 |
| `Listed.ceases_within`、`ceasing_of_coming` | 列表都不长于 B 时，开始成立复现需要不再成立复现：列表不能长过 B |
| `Listed.coming_iff_ceasing` | 列表有界时两者同步 |
| `Web.Census`、`Web.ceasing_of_arising`、`Web.unceasing_iff_bounded` | 普查是活动的列出；有界普查之下，生起复现恰当止息复现（P29b 更正，原文“生成不息恰当止息复现”；见 §42 R5） |
| `Web.StandingCensus`、`StandingCensus.coming_of_ceasing`、`coming_iff_ceasing` | 所立者的普查是水平的列出；不再作为条件而在复现需要开始作为条件而在复现，有界时两者同步 |
| `World.CountedWithin`、`CountedWithin.arising_iff_ceasing` | 每步至多 B 个关系项活跃且被列出的世界中，生起复现恰当止息复现 |
| `World.Finite.countedWithin`、`Finite.arising_iff_ceasing` | 有限世界的每个普查都不长于关系项的数目；所以 §30 的 `arising_iff_ceasing` 是有界规律的情形 |
| `World.dawn_unbounded` | dawn 有普查而没有界 |
| `Procession.web`、`Procession.census`、`World.procession`、`procession_world` | 关系项 x 只在第 x 步活跃：每步一个，生起与止息都复现，关系项不是有限多个 |

**解读。**

- **一个计数定律，两个方向。** 列表每步记下成立者。一次不再成立，若此前（从 N 起）没有开始成立，就使列表比 N 时短；一次开始成立，若此前没有不再成立，就使列表比 N 时长。列表的长度是自然数：不能无穷地变短，所以不再成立复现迫使开始成立复现；有界时也不能无穷地变长，所以开始成立复现迫使不再成立复现。两个方向用同一个论证，只差界的有无。
- **三层。** 按每步成立者的计数，开始成立与不再成立的关系分为三层：有限且有界时两者同步（`coming_iff_ceasing`）；有限而无界时，不再成立需要开始成立，反之不然（dawn）；不再有限时，不再成立可以独自不息（dusk 没有普查）。§26 的有限家族定律与 §30 的有限世界定律都在第一层：有限家族或有限世界的每个列表都不长于成员数。procession 表明第一层不止于有限：关系项无穷多，每步只有一个在场。
- **一种变化，几种读法。** §26 说生起与止息、形成与消解、开始与不再作为条件而在是同一种变化读于活动、依存与水平。普查定律也是这样：它对每步其成立者被列出的任何规定成立，普查与所立者的普查是它读于活动与水平。读于依存（每步的依存被列出时）是直接的实例，留作下一步。
- **仍是活动与水平的读法。** 生起复现与止息复现是否为 Ren 提议中的“生成的”“退化的”由 Ren 选择（§34，M1；P25b 更正，原文“不是 Ren 的…”，见 §38 O8）；有界不是评价，procession 中的接替也不是。

**作者反审。**

*反驳 1：推广只是改名。* 推广去掉了活动这一具体规定：同一证明对任何规定成立，所以水平的读法不需要另证；P26 的三个辅助定理被替换而不是并存，`Web.arising_of_ceasing` 的陈述不变。被替换的名称记在 ceasing-needs-arising 的历史中。把 `Web.Census` 与 `Web.StandingCensus` 定义为 `Listed` 的两个读法，是定义上的相等，原有的证明不改。

*反驳 2：有界普查是不是另一种有限？* 不是：procession 的关系项无穷多，它不是有限世界（`procession_world`），而有界规律适用于它。有界只约束同时在场的数目，不约束总数。反过来，有限推出有界（`Finite.countedWithin`）。

*反驳 3：界须对所有步统一。* 是。只从某步起有界的情形可以把展开平移到那一步得到，但没有陈述；界随步增长而不超过某个慢速增长的函数时会怎样，也没有研究。这些列为下一步。

*反驳 4：procession 是不是太平凡？* 它是最小的见证：每步一个关系项在场，下一步换成下一个。它的作用只是表明有界规律越出有限世界；它不满足体现（水平都为零），所以不说明静止定理的情形。

**边界。** 无伦理谓词，不评价生起、止息或接替；只对离散步与有限列表陈述；“列出”“有界普查”“procession”的名称与读法是 AI 的表述，由 Ren 定。本节尚未经独立审查：第十次独立审查的对象截至 P23c。

## 37. 普查的平衡（P28）

2026-10-09。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P28。§35 与 §36 的普查定律都是复现的定律：止息复现需要生起复现，列表有界时两者同步。它们留下三个下一步：带比率的版本（多少生起伴随多少止息）、只从某步起有界的情形、读于依存。本节给出三者。比率来自一个平衡：§26 对固定的有限家族证明了“终点成立的连同其间不再成立的，恰是起点成立的连同其间开始成立的”（`held_over_stretch`）；这里对每步的列表证明同一平衡，不要求固定的有限家族。没有新模块：平衡与依存的读法放在 `Becoming.Population`，水平的读法放在 `Becoming.Openness`。成果记录：新增 [census-balance](../../../../theories/becoming/results/records/census-balance.md)；修订 [bounded-census-keeps-pace](../../../../theories/becoming/results/records/bounded-census-keeps-pace.md) 与 [ceasing-needs-arising](../../../../theories/becoming/results/records/ceasing-needs-arising.md)。

```text
Result(s): 复用 ceasing-needs-arising（Listed、普查定律）、bounded-census-keeps-pace（有界定律）、coming-and-ceasing-keep-pace
           （mark、comings、ceasings、held_over_stretch、keep_pace）、more-needs-renewers（Distinct、mem_remove、total 的
           工具）、becoming-dependence-dynamics（Forms、Dissolves）；新增 census-balance；修订 bounded-census-keeps-pace、
           ceasing-needs-arising
Delta: Population：计数工具 mark_one、mark_zero、mark_add_not、total_congr_on、mem_insert、distinct_remove、
       marks_le_of_sub、balance_over_stretch；Listed.across、over_stretch、ceasings_within、comings_within；
       Web.Census.over_stretch；Web.DependenceCensus 与 forming_of_dissolving、forming_iff_dissolving；
       Listed.ceases_within、ceasing_of_coming、coming_iff_ceasing、Web.ceasing_of_arising、unceasing_iff_bounded
       改为界只需从某步 T 起成立；Openness：Web.decideComesToStand、decideCeasesToStand（实例）、
       Web.StandingCensus.over_stretch；StandingCensus.coming_iff_ceasing 改为界从某步起
Supplied premises / correspondence: 每步成立者的不重复列出，可判定；有界定律另要求从某步 T 起列表不长于 B
Evidence: 合并检查器回执 20261009T143148.368990Z（1061 项定理、1716 项声明审计、核心闭包 29 个模块、包 27 个模块，全部源声明公理报告
       为空）；外围桥接重跑 20261009T143305.859329Z；实例检查
Boundary: 平衡是计数，不是机制；不评价生起或止息；“生起”“止息”是活动的读法，是否为 Ren 提议中的“生成的”“退化的”由 Ren 选择（P25b 更正，原文“不是 Ren 的…”，见 §38 O8）
Integration: 计划 P28；回答 ceasing-needs-arising 与 bounded-census-keeps-pace 的下一步（比率、从某步起有界、读于依存）
```

| 声明 | 内容 |
|---|---|
| `marks_le_of_sub` | 不重复列表上某性质成立的成员，不多于另一张不重复列表上另一性质成立的成员，只要前者每个都在后者中且有后一性质 |
| `Listed.across` | 跨过每一步：步后列表的长度加上跨步不再成立的成员数，等于步前列表的长度加上跨步开始成立的成员数；跨步保持成立的成员在两张列表上计数相同 |
| `balance_over_stretch` | 每步平衡的计数在任一段步上平衡（逐步累加） |
| `Listed.over_stretch` | 任一段步上，终点的列表连同其间不再成立的，恰是起点的列表连同其间开始成立的 |
| `Listed.ceasings_within`、`comings_within` | 其间不再成立的至多是开始成立的加上起点的列表；开始成立的至多是不再成立的加上终点的列表 |
| `Web.Census.over_stretch`、`Web.StandingCensus.over_stretch` | 读于活动与水平：终点活跃（立着）的连同其间止息（不再作为条件而在）的，恰是起点的连同其间生起（开始作为条件而在）的 |
| `Web.DependenceCensus`、`forming_of_dissolving`、`forming_iff_dissolving` | 读于依存：每步的依存被列出时，消解复现需要形成复现；从某步起有界时两者同步 |
| `Listed.ceasing_of_coming`、`coming_iff_ceasing`、`Web.unceasing_iff_bounded` | 有界定律的界只需从某步 T 起成立；世界上的 `CountedWithin` 是 T = 0 的情形 |

**解读。**

- **进入与离开每步相抵。** 在每步有限的展开中，跨过一步，离开的与留下的合为步前的全部，进入的与留下的合为步后的全部；留下的在两边相同。所以步后的数目加上离开的，恰是步前的数目加上进入的。累加起来，任一段步上的离开与进入之差，恰是起点与终点的数目之差。§26 对固定的有限家族说过同样的话；这里不需要固定的家族，关系项总共可以无限多。
- **比率。** 由平衡，止息比生起多出的不超过起点的数目，生起比止息多出的不超过终点的数目。数目有界时，任一段步上生起与止息之差不超过界：两者不只同步复现，而且在任何长度的时段上数量相近。数目无界时（dawn），生起可以无限地超出止息。
- **一种变化，三种读法。** 普查定律与平衡读于活动（生起与止息）、水平（开始与不再作为条件而在）与依存（形成与消解），与 §26 中同一种变化的三种读法相应。依存的读法以依存对（形成、条件）为成员。
- **界从某步起。** 有界定律只用到某步之后的界：此前的数目可以任意大。所以“同时在场的有界”是一个最终的性质，与开头无关。
- **两条路线。** P26 与 P27 的复现定律直接用列表的长短证明；它们也是平衡的极限情形。两条路线一致，但没有合为一个证明，列为下一步。

**作者反审。**

*反驳 1：平衡只是记账。* 是记账，而且是精确的：它在每一步上成立，不是近似或长程平均。它的内容在于不需要固定的有限家族：关系项无限多时，§26 的定律无法陈述，这里仍可以陈述。比率由它直接得出。

*反驳 2：计数工具太多。* `mark_one`、`mark_zero`、`mark_add_not`、`total_congr_on`、`mem_insert`、`distinct_remove` 是一般的列表与标记工具，放在列表一节，供 `marks_le_of_sub` 与 `across` 使用；`balance_over_stretch` 是任何每步平衡的计数的累加，`Change.over_stretch` 的量的版本是它的一种情形，但没有改写成它的实例，以免改动已审查的模块。

*反驳 3：读于依存要求依存可判定。* 是，与读于活动要求活动可判定相同，属于表示的逻辑承诺。读于水平自动可判定。

**边界。** 无伦理谓词，不评价进入、离开、形成或消解；只对离散步与每步有限的列表陈述；名称（平衡、列出、有界普查）是 AI 的表述，由 Ren 定。本节尚未经独立审查：第十次独立审查的对象截至 P23c。

## 38. 第十次独立审查与更正（P25b）

2026-10-09。按同一指示继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P24（§32）、P25（§33）与 P23c（§34）（[审查](../history/root-foundation/BECOMING-P23C-P24-P25-REVIEW.md)）。它在仓库之外从前导重新编译核心闭包的 29 个模块，1732 条源声明的公理报告全空；闭包的 4894 个常量中依赖公理的只有 34 条编译器生成的 `injEq` 引理，都只依赖 `propext`，与回执所列相同；回执、源哈希、保留产物、引用哈希与证明绑定都对，数学全部接受，Lean 中没有数学错误。第九次审查的 M2–M10 关闭，M1 部分关闭。它提出十一项（O1–O11）：两项散文与记录中的错误（O4、O5），六项过强（O1、O3、O7、O8、O9、O10；其中 O7、O8 是 M1 的残留，O10 预设了 Ren 尚未作出的选择的范围），一项缺少反例（O2），两项表述与记账（O6、O11）。P26–P28（§35–§37）在审查期间提交，审查没有读；其中受影响的句子一并更正。本节记录逐项处理。探针 Q1–Q8、Q10 的内容移入核心，Q9 的内容由更正后的陈述写出；公理报告为空。§26、§30、§32–§37 与英文段落中受影响的句子已就地更正并标明。

```text
Result(s): 更正 continued-change-needs-openness（O1–O6）、map-of-premises（O9）、coming-and-ceasing-keep-pace（O7、O8）、
           space-and-its-parts（O8、O10、O11）、theory-of-becoming-foundation（O11(f)）、ceasing-needs-arising（O2）、
           evolution-on-descent（O11(d)）；没有新的成果记录
Delta: Dissipation：Enclosed.around_not_not。Roles：Web.Dependent.inactive_below。Space：grazing_decided、grazing_browser_ends、
       living_crosses_ceasing；law_decides、arising_iff_ceasing 与 grazing_world 的说明。Premises：acting_across（acting_of_enclosed
       由它证明）、draining、draining_decided、draining_but；Scatter 的构造子 giver 改为 source。Openness：Enclosed.aroundStanding_not_not；
       Flow.stills 只需围住不被否定；arising_stops（comes_to_rest 由它证明）；rests_enclosed 与 arising_opens 去掉 DecidableEq；
       Exposed.holder_one、holder_after、exposed_standing、openness_contingent；Kindling.sideOf、index、fuel_stands、census、unlisted，
       Ember.web、ember、rest_needs_standing。Change、Evolution 与根模块的说明（O7、O11）
Supplied premises / correspondence: 不变；删去一项（rests_enclosed 与 arising_opens 的可判定的相等）
Evidence: 合并检查器回执 20261009T145010.627958Z（1077 项定理／1739 项声明审计，核心闭包 29 个模块，包 27 个模块，
          源声明的公理报告全空）；外围桥接重跑 20261009T161851.010138Z（此前两次在负载下超时：20261009T145404.970266Z、20261009T151818.075474Z，每次 Lean 运行的时限现可由 LEAN_TIMEOUT 设定）；实例检查
Boundary: 不含伦理结论；不替 Ren 选择任何读法，新增两项 Ren 的选择；新名称是建议；新见证都是最小见证
Integration: §26、§30、§32–§37 的更正；审查 §4 的第 1–6 项完成，第 7 项（Ren 的选择）保持开放
```

### 38.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| O1 | “起作用的是被围住，不是有限”漏掉定理所用的每步立着的有限多（活动的普查连同每个关系项体现）；kindling 有活动的普查、每步被围住、生起者体现、平衡、耗散，生起不息（Q1）；ember 每步被围住、每个关系项体现、平衡、耗散，没有普查，生起不息（Q2） | 章节第 4 条、§2、§8 现状行、§9 Openness 行、根基第 5 行、模块说明、记录的标题与对应、§33 与英文 P25 改为：世界不必有限；起作用的是每步立着的有限多，连同被围住。Q1 与 Q2 移入核心：`World.rest_needs_standing`（kindling：活动的普查、生起者体现、平衡、耗散、每步被围住于每个曾活跃的关系项，生起复现，没有所立者的普查；ember：同一流而每个关系项体现，每步被围住，生起复现，没有普查），连同 `Kindling.census`、`unlisted`、`Ember.web`、`World.ember` |
| O2 | 开放项“只要求生起者体现时被围住的世界是否归于静止”已有答案 | 开放项换为答案：只有活动的普查时不（kindling）；有所立者的普查时生起停止（Q3 移入核心为 `World.arising_stops`，`comes_to_rest` 改由它证明），止息不一定（dusk，`rest_needs_census`）；再有活动的普查时两者都停止，即审查未形式化的手证，已是 P26 的 `comes_to_rest`。章节进一步的证明中的“没有所立者的普查时被围住的步”换为“满足全部八个前提且每个都起约束的世界”。§35 的“本节的回答是肯定的”与英文 P26 一并更正：要再有所立者的普查 |
| O3 | 可判定的相等不是构造性证明的要求（Q4） | `rests_enclosed` 与 `arising_opens` 去掉 `[DecidableEq w.Relatum]`。新增 `Flow.Enclosed.around_not_not`（Dissipation：不判定相等时，被封闭的步不是不围住每个有限家族）与 `Flow.Enclosed.aroundStanding_not_not`；`Flow.stills` 的围住前提改为不被否定（`¬¬`），因为它比较的是自然数，判定已在那里（`Decidable.of_not_not`）；`arising_stops` 以 `not_not_intro` 传入直接的围住。`Enclosed.aroundStanding`（正面的陈述）保留，仍用可判定的相等。记录与 §33 反驳 3 更正 |
| O4 | 由 exposed 推出“开放不由八个前提推出”，需要另一个见证 | Q6 移入核心：`World.openness_contingent`：exposed 满足八个、没有一步被围住、生起复现；互利者满足八个、每步被围住、生起不复现。章节第 4 条、§2、§8 改为：八个前提既不决定被围住，也不决定开放 |
| O5 | 记录说 exposed 的总水平随世界上升；实际每步都是一 | Q5 移入核心：`World.exposed_standing`（所立者被列出，只有持有者；总水平每步为一；持有者每步下降；世界不有限），连同 `Exposed.holder_one`、`holder_after`。记录改为：总水平始终为一，无界的是与之交换的关系项的数目，各自水平为零 |
| O6 | exposed 中活动需要支持、有界传递与耗散空成立，只披露了耗散；它的开放是零净量的交换 | 模块说明、记录的反例与 §33 写明三项空成立、静止定理只用四个前提；“开放”指在每个有限家族之外的交换还是流入，列为 Ren 的选择 |
| O7 | 网层面“形成有限多时生成不息恰当止息不息”仍在 `Change`、根模块、README、章节 §2 与 §9、记录、§26 与根基第 5 行 | 改为“形成有限多且活动可判定时，生起复现恰当止息复现”；根基第 5 行写“生起不息”。`Web.Unceasing` 的名称与 `Becoming.Generation` 中的定义说明保持原范围 |
| O8 | 活动读法在正典中有三种地位：被排除、作为 Ren 的候选、被记为 Ren 定下的关系读法 | 正典中只留一种地位：由 Ren 选择的候选。章节第 4 条、§2、§8 现状行、词汇表与记录照录 Ren 的原话（“generative和degenerate虽然都在一个becoming model上，但是他们不overlap吧”），并标明 AI 的推论：若取不重叠，在有限世界中重合的活动读法就不是其所指。计划 §6 分开 Ren 的原话与 AI 的“作为关系”及 `renewing_not_consuming`。§26、§35–§37 与英文 P19、P22 就地更正 |
| O9 | (a) “有限世界有普查”漏掉可判定（Q9）；(b) `acting_of_enclosed` 写作逐步，定理要求每步被围住；(c) 见证的空成立没有写出；(d) `premised_rests` 只用到三个前提；(e) 地图不含有限、被围住与可判定性 | (a) 研究 §32、记录与章节 §9 加入可判定；不给可判定性而对每个有限世界要求普查就蕴含排中律，与 `law_decides` 同一结构，所以 Q9 不另移入核心。(b) 新增 `World.acting_across`（逐步的形式），`acting_of_enclosed` 由它证明。(c) Q10 移入核心：`World.draining`、`draining_but`：平衡的第二个见证，每步从两侧的封闭家族取用，取用与耗散在其中起约束；记录与 §32 写明各见证中空成立的前提。(d) 写为“证明用到其中三个：平衡、耗散与体现”。(e) 独立性写明相对于这八个 |
| O10 | grazing 的“不论终结之步怎样判定”预设了 Ren 的选择只涉及被汲取者自身的终结；活动需要支持时，对不变依存的侵蚀都与依存者的终结同时（Q8；P29b 注：这句本身过强，依存者原本活跃时才是终结，见 §42 R1）；“活跨越止息”在核心中没有可判定性实例（Q7） | Q8 移入核心：`Web.Dependent.inactive_below`（Roles，一般形式）与 `World.grazing_browser_ends`。`grazing_world` 的说明改为“在对终结之步汲取承担自身者的选择之外”。章节 §8 新增 Ren 的选择：与依存者的终结同时的侵蚀是否计入不活、对哪些汲取者（P29b 改为：依存者在该步之后不活跃的侵蚀，包括休眠的依存，见 §42 R1）。Q7 移入核心：`grazing_decided` 与 `World.living_crosses_ceasing` |
| O11 | (a) `law_decides` 只证明一个方向；(b) `arising_opens` 的说明比定理强；(c) 五处缺可判定；(d) `selected_le` 的说明；(e) §2 的消耗句缺“被取用”；(f) 七、八、十个前提的关系；(g) “最后一个 giver 已去掉”不准确；(h) 记录历史的空格；(i) 时间戳 | (a) 写为“蕴含排中律”；逆命题需要从排中律得到可判定的数据，在纯净核心中不能陈述（P29b 更正：此说不对，逆命题可以陈述，以排中律为假设不用可判定性也能证明，`World.law_of_em`、`World.law_iff_em`；见 §42 R2），经典地每个活动都可判定。(b) 写为“并非从某步起每步都被围住”。(c) 补上。(d) 改为加权总量，不是真正的选择项。(e) 补“对各步家族被耗散且被取用的事件”。(f) 章节第 3 条与 §2 写明：八个是七个去掉储备承载（由活动需要支持推出），加上普查与有界传递；连同两个较弱的形式共十个。(g) `Scatter.Relatum.giver` 改为 `source`。(h) 改正。(i) 无法从仓库核实，不改 |

### 38.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Dissipation | `Flow.Enclosed.around_not_not` | 不判定相等时，被封闭的步不是不围住每个有限家族：每个成员是否在封闭家族中只需不被否定 |
| Roles | `Web.Dependent.inactive_below` | 活动需要支持时，跨一步落到所需之下、且在步后以不低的所需持续的依存，属于在步后不活跃的形成：对持续不变的依存的侵蚀使依存者在步后不活跃（P29b 更正，原文“与依存者的终结同时”；依存者原本活跃时才是终结，见 §42 R1） |
| Space | `grazing_decided`、`grazing_browser_ends`、`living_crosses_ceasing` | grazing 的活动可判定；食草者在第 1 步不活跃；在有限世界中，止息复现与否，都既可以每个事件都活，也可以有事件不活 |
| Premises | `acting_across`、`draining`、`draining_decided`、`draining_but` | 只有活跃者取用且耗散时，在被围住的步上只有活跃者给予；平衡的第二个见证：leaking 的流放在 spending 的网上，满足平衡之外的每个前提，两侧的家族每步封闭且被取用 |
| Openness | `Enclosed.aroundStanding_not_not`、`stills`（更正）、`arising_stops`、`rests_enclosed`、`arising_opens`（更正） | 被封闭的步不是不围住所立者；围住只需不被否定；所立者的普查、生起者体现、平衡、耗散与从某步起每步围住所立者使生起停止；两个世界定理不再要求可判定的相等 |
| Openness | `Exposed.holder_one`、`holder_after`、`exposed_standing`、`openness_contingent` | exposed 中所立者被列出，总水平每步为一，持有者每步下降，世界不有限；八个前提既不决定被围住，也不决定开放 |
| Openness | `Kindling.sideOf`、`index`、`fuel_stands`、`census`、`unlisted`，`Ember.web`、`World.ember`、`rest_needs_standing` | kindling 中活跃的是持有者，所以有活动的普查；没有列表包含每个燃料，所以没有所立者的普查；ember 的每个关系项在立着时活跃，所以没有普查；两者都每步被围住、平衡、耗散而生起复现 |

### 38.3 审查列出的会改变判断的结果

1. 静止定理的标题（O1）：每处写出每步立着的有限多。完成；判断 7 成为“限定后，是”。
2. 开放项（O2）：换为答案，两份 next_delta 更新。完成。
3. 可判定的相等（O3）：去掉。完成；判断 10 没有余下的限定。
4. 两句错误（O4、O5）：更正，开放不由八个前提推出引互利者。完成。
5. M1（O7、O8）：网层面的用语改为生起复现；活动读法在正典中只有一种地位，Ren 的原话照录；计划 §6 分开 Ren 的原话与 AI 的“作为关系”。完成。
6. 其余限定与表述（O9–O11）：完成，(i) 除外。
7. Ren 的选择保持开放，新增两项：与依存者的终结同时的侵蚀是否计入不活（O10）；“开放”指在每个有限家族之外的交换还是流入（O6）。
8. 审查没有构造而仍开放的：满足全部八个前提且每个都起约束的世界（O9(c)），列入进一步的证明。

### 38.4 作者反审

*反驳 1：“每步立着的有限多”是不是又把有限加回来了？* 加回来的是每一步的有限，不是世界的有限。kindling 与 ember 说明它不能去掉：每步都被围住、平衡、耗散，只要每步立着的有无穷多，生起就可以不息。§33 的推广是真的：有限世界在两点上起作用，给出普查，也给出被围住；P25 表明这两点可以分开要求，而世界本身不必有限。

*反驳 2：`stills` 的前提改为 `¬¬` 使陈述更难读。* 陈述更强：前提更弱，结论不变。说明写出为什么足够：比较的是自然数，判定已在那里。直接的围住经 `not_not_intro` 传入，`arising_stops` 与 `comes_to_rest` 的陈述不变。这使 `rests_enclosed` 不必要求可判定的相等，而可判定性是公开的逻辑承诺，不需要的不该列入。

*反驳 3：活动读法只作为候选，是不是回避了 Ren 的话？* 不是。Ren 的原话照录，AI 的推论标明：若取不重叠，这一读法就不是其所指。推论合理，但它是 AI 的，并决定 §8 的第一项选择；按方法，选择留给 Ren。审查也说明：若 Ren 声明活动读法不是其所指，O8 就只剩照录那句话。

*反驳 4：`law_decides` 为什么不证明逆命题？* 逆命题从排中律推出每个有限世界中的规律，需要把 `Q ∨ ¬Q` 变为可判定的数据，即 `Decidable`；从命题的析取消去到数据，在纯净核心中需要选择公理。所以说明写为“蕴含排中律”，经典地每个活动都可判定，这时规律由 `arising_iff_ceasing` 给出。（P29b 更正：这一回答不对。逆命题是命题，证明可以留在 `Prop` 中：按有限的关系项列表归纳，对排中律分情形，不需要 `Decidable` 数据，也不需要选择公理；见 §42 R2 与 `World.law_iff_em`。）

**边界。** 不含伦理谓词；不改变任何读法选择的地位，新增两项 Ren 的选择；新名称（ember、draining、source）是建议；新见证都是最小见证。本节的更正与 §35–§37 尚未经独立审查（计划 P28b）。

## 39. 每个前提都起约束的世界与名称的确认（P29）

2026-10-09。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P29。第十次独立审查指出，前提的地图中有几个见证没有流，关于流的四个前提在其中空成立；满足全部八个前提的互利者也是如此（§38 O9）。章节的“进一步的证明”因此列出“满足全部八个前提且每个都起约束的世界”。本节给出它，并记录 Ren 对名称的确认。没有新模块：定义与世界放在 `Becoming.Premises`，它的静止放在 `Becoming.Openness`。成果记录：修订 [map-of-premises](../../../../theories/becoming/results/records/map-of-premises.md)、[continued-change-needs-openness](../../../../theories/becoming/results/records/continued-change-needs-openness.md)，名称写入 [space-and-its-parts](../../../../theories/becoming/results/records/space-and-its-parts.md)、[coming-and-ceasing-keep-pace](../../../../theories/becoming/results/records/coming-and-ceasing-keep-pace.md)、[ceasing-needs-arising](../../../../theories/becoming/results/records/ceasing-needs-arising.md)、[bounded-census-keeps-pace](../../../../theories/becoming/results/records/bounded-census-keeps-pace.md) 与 [census-balance](../../../../theories/becoming/results/records/census-balance.md)。

```text
Result(s): 复用 map-of-premises（八个前提、Premised）、continued-change-needs-openness（rests_enclosed）、
           space-and-its-parts（World 与各前提）、more-needs-renewers 与 no-finite-part-bears-taking（total 的工具）、
           evolution-on-descent（DescendsAt、TransmitsWithin）；修订 map-of-premises、continued-change-needs-openness
Delta: Premises：World.Binds；Brood（Relatum、level、fed、toChild、flow、eats、web、taking_part、kin、kin_distinct、
       closed、alive、index、outside）；World.brood、brood_balanced、brood_dissipative、brood_counted、brood_binds；
       Openness：World.brood_rests；Space 与根模块的文档写入 Ren 对名称的确认
Supplied premises / correspondence: 无新前提；brood 是一个具体世界，起约束只说某个条件被满足
Evidence: 合并检查器回执 20261009T163512.365801Z（1086 项定理、1760 项声明审计、核心闭包 29 个模块、包 27 个模块，全部源声明公理报告为空）；
          外围桥接重跑 20261009T163805.366023Z；实例检查
Boundary: 起约束不是在该世界中独立；brood 不有限，去掉地关系项得到有限世界，其中普查来自有限；不评价任何部分
Integration: 计划 P29；回答 map-of-premises 与 continued-change-needs-openness 的下一步“满足全部八个且每个都起约束的世界”；
             Ren 对名称的确认见[原话](../../../../sources/15-codex-theory-conversations/2026-10-09-arising-ceasing-names.md)
```

| 声明 | 内容 |
|---|---|
| `World.Binds` | 前提起约束：活动需要支持在活跃者以正需要依存于某条件时，平衡在水平变化时，只有活跃者给予与只有活跃者取用在参与者给予与取用时，耗散在参与者从封闭的家族取用时，体现在关系项生起时，普查在世界不有限、因而普查不来自有限时（P29b 更正：这只说整个世界不有限；`hatch` 中世界只因闲置的地关系项而不有限，普查来自只有三个关系项曾经活跃，见 §42 R3），有界传递在后代于其开始而立之步依存于某条件时 |
| `World.brood` | 食物在第一步立于三，此后立于一；亲代在第一步立于一，此后为零；子代在第一步为零，此后立于一；无限多个地关系项立于零。跨过第一步，亲代取用两个单位的食物与自身的一个单位，给子代一个单位；亲代与子代以需要一依存于食物 |
| `World.brood_binds` | 八个前提都成立，每个都起约束：亲代依存于食物，食物下降，亲代给予与取用，从食物、亲代与子代这一封闭家族取用，子代生起，世界不有限，子代在开始而立之步像亲代一样依存于食物 |
| `World.brood_rests` | 跨过第一步子代生起、亲代止息；每步都被围住在食物、亲代与子代之内；由 `rests_enclosed`，生起与止息都不再复现 |

**解读。**

- **前提不只是相容的。** 互利者表明八个前提可以同时成立，但其中关于流的四个空成立。`brood` 表明它们可以同时起约束：有交换、有依存、有世系与传递、有生起与止息，平衡与耗散都在约束实际的交换。它是一个最小的生命循环的形状：一个形成从所依存的条件取用、把自身的一部分交给后代、终结，后代像它一样依存于同一条件。这是 AI 的读法；名称（brood、亲代、子代、食物）是 AI 的表述，由 Ren 定。
- **普查起作用。** `brood` 有无限多个关系项，只有有限多个立着，所以普查与所立者的普查都不来自有限；静止定理在其中起作用，而 `premised_rests` 不适用。这正是 §38 O1 的要点：使世界归于静止的是每步立着的有限多与被围住，不是世界有限。（P29b 更正：“普查不来自有限”只对整个世界是否有限成立。地关系项闲置，只有食物、亲代与子代曾经活跃（`hatch_ever`、`hatch_idle`），由曾经活跃者的列表即得普查（`counted_of_ever`）；在静止定理适用的每个世界中，曾经活跃或立着的关系项都不是无界多（`rest_few`），所以静止定理比 `rests` 多涵盖的只是从不立着、从不活跃的关系项。见 §42 R3；`brood` 已改名 `hatch`，R10。）
- **起约束与独立不同。** 在 `brood` 中每步都被围住，所以只有活跃者给予由只有活跃者取用与耗散推出（`acting_across`）；它仍然起约束，因为确有参与者给予。起约束只说前提的条件被满足，不说它在该世界中不由其余推出。
- **名称。** Ren 引用 AI 关于 M1 的进度说明，并说“arising/ceasing is indeed better name”（[原话](../../../../sources/15-codex-theory-conversations/2026-10-09-arising-ceasing-names.md)）。所以 P23c 的改名保留，活动的读法以生起与止息命名，这是 Ren 确认的名称，不再列为 AI 拟定的用语（P29b 更正：Ren 确认的是英文的 arising/ceasing；中文 生起／止息 是 AI 的译名，仍是 AI 的用语；见 §42 R9）。Ren 提议中的“生成的”“退化的”指什么，仍由 Ren 说明；这句话没有说它，AI 也没有把关系的读法定为其所指。

**作者反审。**

*反驳 1：`brood` 是特意构造的。* 是；它是存在性的见证，与地图中的反例世界地位相同。它说明八个前提一起不只空成立，不说实际的生命满足它们。

*反驳 2：普查起约束定义为世界不有限，太强。* 在有限且活动可判定的世界中普查由有限推出（`Finite.counted`），所以普查的内容只有在世界不有限时才不由别的给出。去掉地关系项得到有限的世界，其余七个仍起约束，普查来自有限；这一变体没有另行检查。（P29b 更正：在静止定理的前提之下，普查的内容由只有有限多个关系项曾经活跃给出（`counted_of_ever`、`rest_few`），不由世界不有限给出；见 §42 R3。）

*反驳 3：亲代取用自身的一个单位不自然。* 它让亲代终结，使同一世界中有生起也有止息；没有它，`brood` 仍满足并约束八个前提，只是没有止息。耗散的约束来自亲代从食物取用的两个单位多于给予的一个单位。

**边界。** 无伦理谓词，不评价亲代的终结或子代的生起；只对离散步与自然数的量陈述；起约束是条件被满足，不是独立；名称由 Ren 定，生起与止息已由 Ren 确认。本节尚未经独立审查。

## 40. 复现定律由平衡推出与增长的界（P30）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P30。§37 留下两项：P26 与 P27 的复现定律直接用列表的长短证明，与普查的平衡是两条路线；界随步增长时还剩什么（bounded-census-keeps-pace 的下一步：例如对数增长时，是否仍可能只生不灭）。census-balance 的下一步另有平衡读于依存。本节给出三者。没有新模块：累加的引理放在 `Becoming.Change`，定律放在 `Becoming.Population`，世界放在 `Becoming.Openness`。成果记录：修订 [census-balance](../../../../theories/becoming/results/records/census-balance.md)、[ceasing-needs-arising](../../../../theories/becoming/results/records/ceasing-needs-arising.md)、[bounded-census-keeps-pace](../../../../theories/becoming/results/records/bounded-census-keeps-pace.md) 与 [coming-and-ceasing-keep-pace](../../../../theories/becoming/results/records/coming-and-ceasing-keep-pace.md)。

```text
Result(s): 复用 census-balance（Listed.over_stretch）、coming-and-ceasing-keep-pace（Recurs.accumulates、steps 的工具、
           pos_of_exceeds）、ceasing-needs-arising 与 bounded-census-keeps-pace（Listed、CountedWithin、Dawn、Procession）、
           more-needs-renewers（Cycle 的列表）、becoming-dependence-dynamics（Forms、Dissolves）；修订 census-balance、
           ceasing-needs-arising、bounded-census-keeps-pace、coming-and-ceasing-keep-pace
Delta: Change：recurring_accumulates（Recurs.accumulates 改由它证明）。Population：Listed.ceasing_iff_shortfall、
       coming_iff_excess、ceasing_of_returning、ceasing_of_outpacing；coming_of_ceasing 与 ceasing_of_coming 改由平衡证明，
       陈述不变；去掉不再被用到的 comes_or_held、comes_or_fewer、comes_within、ceases_or_kept、ceases_or_more、
       ceases_within；Web.decideForms、decideDissolves（实例）、Web.DependenceCensus.over_stretch。Openness：World.CountedBy
       （CountedWithin 是常数界的情形）、CountedBy.arising_iff_ceasing；Slow.web、length、census、grows_between，
       World.slow、slow_decided（实例）、slow_world
Supplied premises / correspondence: 不变；有界定律的界只需在任意晚的步回到某数以内；slow_world 要求界不减而无界
Evidence: 合并检查器回执 20261009T170233.740799Z（1091 项定理、1771 项声明审计、核心闭包 29 个模块、包 27 个模块，
          全部源声明公理报告为空）；外围桥接重跑 20261009T170422.519028Z；实例检查
Boundary: 计数，不是机制；slow 是存在性的见证；不评价生起或止息；名称由 Ren 定
Integration: 计划 P30；回答 census-balance 的下一步（两条路线合一、读于依存）与 bounded-census-keeps-pace 的下一步
             （界随步缓慢增长时还剩什么）；依赖方向：ceasing-needs-arising 与 bounded-census-keeps-pace 现依赖 census-balance
```

| 声明 | 内容 |
|---|---|
| `recurring_accumulates` | 在任意晚的步为正的量，从任一步起的累加超过每个数；有限家族的 `Recurs.accumulates` 是其情形 |
| `Listed.ceasing_iff_shortfall` | 不再成立复现，恰当从每一步起某个后来的列表短于起点的列表连同其间开始成立的 |
| `Listed.coming_iff_excess` | 开始成立复现，恰当从每一步起起点的列表长于某个后来的列表连同其间不再成立的 |
| `Listed.coming_of_ceasing`（新证明） | 普查定律：不再成立复现时，其间不再成立的累加而超过起点的列表，由平衡，开始成立补足差额 |
| `Listed.ceasing_of_returning` | 列表在任意晚的步回到某数 K 以内时，开始成立复现需要不再成立复现：其间开始成立的累加而超过 K |
| `Listed.ceasing_of_coming`（新证明） | 有界定律：从某步起至多 B 个是回到 B 以内的情形 |
| `Listed.ceasing_of_outpacing` | 比率形式：每步的列表不长于 B t，且从每一步起某段步上开始成立的多于该段终点的界时，不再成立复现 |
| `Web.DependenceCensus.over_stretch` | 读于依存：终点的依存连同其间消解的，恰是起点的依存连同其间形成的 |
| `World.CountedBy`、`CountedBy.arising_iff_ceasing` | 每步 t 至多 B t 个关系项活跃且被列出；B 在任意晚的步回到某数以内时，生起复现恰当止息复现；`CountedWithin` 是常数界的情形 |
| `World.slow`、`slow_world` | 第 t 步活跃的是 B t 以下的关系项，以循环的列表为普查；B 不减而无界时，B 增长的每一步上关系项 B t 生起，没有关系项止息 |

**解读。**

- **一条路线。** 平衡读于复现是精确的：止息复现，恰当从每一步起某个后来的列表短于起点的列表连同其间开始成立的；开始成立复现，恰当起点的列表长于某个后来的列表连同其间不再成立的。复现的量在一段步上累加而超过任何数。所以普查定律：止息复现时，其间不再成立的终将超过起点的列表，平衡只能由开始成立补足；有界定律：开始成立复现时，其间开始成立的终将超过界，列表回到界内时，平衡只能由不再成立补足。§26 的有限家族定律早已这样证明（`rising_recurs`、`falling_recurs` 用累加与平衡），现在普查的定律也如此：复现的定律都是累加与平衡。P26 与 P27 中由列表长短给出的六个引理不再被用到，从核心中去掉；它们的陈述与检查保存在回执 20261009T163512.365801Z 与此前的提交中，§35、§36 记录了那条证明。两个定律的名称与陈述不变，用到它们的读法（活动、依存、水平、世界）不变。
- **回到界内即可。** 有界定律不要求界从某步起一直成立：列表只需在任意晚的步回到某数 K 以内，其间可以任意地大。读于世界：每步 t 至多 B t 个活跃（`CountedBy`），B 在任意晚的步回到某数以内时，生起复现恰当止息复现。
- **增长的界。** 界无界地增长时，不论多慢，都不使两者同步：对任何不减而无界的 B（例如对数），`slow B` 中第 t 步活跃的是 B t 以下的关系项，B 增长的每一步上关系项 B t 生起，没有关系项止息。这回答了 bounded-census-keeps-pace 的下一步：对数增长时，仍可能只生不灭。对不减的界，停在某数以内与无界增长两者必居其一，这是经典的；纯净核心分别陈述两侧：前者在它计数的每个世界中使生起与止息同步，后者在 slow 中不同步。dawn 是 B t = t 的一个变体（关系项与条件的读法不同）。
- **比率。** 列表无界时，止息复现恰当缺额出现；所以从每一步起，某段步上开始成立的多于该段终点的界时，止息就复现。这是充分条件，不是必要条件：列表可以远小于界。在 slow 中，任一段步上生起的恰是界的增长，从不多于终点的界。
- **读于依存的平衡。** 每步的依存被列出时，终点的依存连同其间消解的，恰是起点的依存连同其间形成的。于是平衡与复现定律都读于活动、依存与水平。

**作者反审。**

*反驳 1：去掉六个引理是不是删除了成果？* 它们是证明的步骤，不是成果记录的结论：两个定律的名称与陈述不变，只是证明经过平衡。核心中同一定理的两条证明，只会让读者以为它们说的是两件事。被去掉的陈述与检查保存在回执与提交历史中，相关记录的历史写明了替换；`search` 与 `length_le_of_sub` 仍被别处用到，保留。

*反驳 2：`ceasing_of_outpacing` 由 `ceasing_iff_shortfall` 直接得出，是否值得单列？* 它回答了界增长时问题的正面：什么足以使止息复现。它也说明 slow 为什么不违反它：其中生起从不多于界。

*反驳 3：slow 是特意构造的，而且没有流。* 是：它是存在性的见证，与 dawn 地位相同。它说明只靠计数的界不能更进一步；关于流的前提在 slow 中空成立（流是静止的流），带流与被围住时，静止定理给出另一种约束（§35）。

*反驳 4：二分只对不减的界。* 是。一般的界在任意晚的步回到某数以内时定律成立；界不单调而最终超过每个数时，对应的世界要取其后各步的最小值作为不减的界，这需要从存在得到数据，在纯净核心中不能构造，所以没有陈述。

*反驳 5：依赖方向改变了。* census-balance 原先依赖 ceasing-needs-arising（复用列出与普查的定义）；现在普查定律由平衡推出，两者互相依赖会成环。列出与普查的定义也声明在 census-balance 中，所以它不再依赖 ceasing-needs-arising，后者与 bounded-census-keeps-pace 依赖它。这是推理顺序的如实记录，不是改写历史：census-balance 的历史写明了反转。

**边界。** 无伦理谓词，不评价生起或止息；只对离散步与每步有限的列表陈述；可判定是逻辑承诺；名称（缺额、回到界内、slow）是 AI 的表述，由 Ren 定。本节尚未经独立审查：第十一次独立审查的对象截至 P29。

## 41. 沿依存之链的滞后共灭（P31）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P31。reserve-defers-ending 与 life-as-condition-of-life 的下一步都列出沿依存链、有储备的滞后共灭；P17 只陈述了单环（`Carries.coextinct_lasts`，§24），第八次独立审查也把它列为开放。在 `Dependent` 之下，共灭沿依存链在同一步发生（`coextinct`）；有储备时，链上的每一环都推迟。单环定理的结论是形成只在有限多步活跃，它不给出下一环从哪一步起不被支持，所以不能逐环接下去。储备衰减时终结之步是显式的（`Carries.ends_within`），本节由此给出逐环的界；储备不衰减时，以排中律为假设，逐环仍可接下去，只是没有界。没有新模块：定理与见证放在 `Becoming.Reserve`，排中律之下的反例引理放在 `Becoming.Change`。成果记录：修订 [reserve-defers-ending](../../../../theories/becoming/results/records/reserve-defers-ending.md)。

```text
Result(s): 复用 reserve-defers-ending（Carries、Decays、Carries.ends_within、unsupported_after_end）、
           life-as-condition-of-life（Embodied、coextinct）、becoming-dependence-dynamics（Supported、Dependent）；
           修订 reserve-defers-ending
Delta: Change：exists_not_of_em；Reserve：Web.chainEnd、chainEnd_ge、chainEnd_zero、Carries.chain_ends、
       Carries.chain_ends_of_em；Cascade.upto、upto_pos、upto_le_one、
       upto_after、upto_self、web、embodied、supported_of_le、unsupported_late、reserve、falls、never_rises、carries、
       decays、ends、cascade
Supplied premises / correspondence: Carries 与 Decays（表示前提，同 ends_within）；链上的关系项都体现；从第 T 步起
       每一环以正需要依存于前一环；第一环从 T 起不活跃；无界的形式以排中律为假设代替 Decays
Evidence: 合并检查器回执 20261009T184816.006618Z（1109 项定理、1793 项声明审计、核心闭包 29 个模块、包 27 个模块，全部源声明公理报告
          为空）；外围桥接重跑 20261009T184936.948468Z；实例检查
Boundary: 界只对衰减的储备陈述，不衰减时以排中律为假设只得终结、没有界；不评价共灭；名称由 Ren 定
Integration: 计划 P31；回答 reserve-defers-ending 与 life-as-condition-of-life 的下一步（沿依存链、有储备的滞后共灭）
```

| 声明 | 内容 |
|---|---|
| `Web.chainEnd` | 链上各环的终结之步：第 0 环在 T；第 k+1 环在第 k 环终结之后，再过它在那时的储备那么多步 |
| `chainEnd_ge` | 每一环的终结之步不早于 T |
| `chainEnd_zero` | 零储备之下每一环都在 T 终结 |
| `Carries.chain_ends` | 储备承载且衰减，链上的关系项都体现，从 T 起每一环以正需要依存于前一环，第一环从 T 起不活跃时，第 k 环从 `chainEnd k` 起不活跃 |
| `Carries.chain_ends_of_em` | 不设 `Decays`，以排中律为假设：其余前提相同时，链上每个关系项从某步起不活跃，没有界 |
| `exists_not_of_em` | 以排中律为假设，否定的全称有反例：不在任意晚的步出现者有一步之后不再出现 |
| `Cascade.cascade` | 关系项 x 活跃至第 x 步，x+1 以需要一依存于 x，储备至第 x 步为一：前提全部成立，`Dependent` 不成立，`chainEnd k` 为 k+1，而第 k 个关系项在第 k 步仍活跃，界恰好达到 |

**解读。**

- **逐环的界。** 第 k 环从 `chainEnd k` 起不活跃；第 k+1 环以正需要依存于它，它体现，所以从那时起第 k+1 环不被支持（`unsupported_after_end`）；衰减的储备在其储备那么多步之后终结它（`ends_within`）。每一环的储备读于前一环终结之时，所以支持期间的补充已计入界中：reserve-defers-ending 原来的下一步担心“支持期间储备可以补充，链上的界须另设前提”，衰减之外不需要另设前提，界读于那时的储备即可。
- **零储备是同时的共灭。** 零储备恰是 `Dependent`（`carries_zero`），并空满足 `Decays`；`chainEnd` 恒为 T（`chainEnd_zero`），所以 `chain_ends` 在零储备之下是沿链从 T 起的同时共灭，即 `coextinct` 在一条序列链上、跨步的情形。
- **界可以达到。** 在 `Cascade` 中，每个关系项恰好比它依存的前一个多活一步：第 0 个从第 1 步起不活跃，第 k 个在第 k 步仍活跃，`chainEnd k` 为 k+1。没有储备时，链会同时终结：关系项 1 在第 1 步活跃而不被支持，`Dependent` 不成立。它的储备是给定的量，不是所持条件的水平，与 `Seed`、`Viable` 相同。
- **为什么要衰减，以及不衰减时。** 不设 `Decays` 时，休眠的形成可以任意晚地醒来（`Seed` 的储备在休眠中保持），一环的终结之步没有界。从某步起不被支持的形成只在有限多步活跃（`active_finitely`），但在构造的逻辑中“不复现”不能化为终结之步（这需要马尔可夫原则）（P33b 更正：这一步不是构造性的，即使活动可判定且至多发生一次，它也蕴含 LPO（`Web.lpo_of_ending`），马尔可夫原则不够；见 §45 T3），而下一环的“从某步起不被支持”需要前一环的终结之步。以排中律为假设（像 `Space` 中的 `law_of_em` 那样作为假设，不作为公理），“不复现”有一步之后不再出现（`exists_not_of_em`），逐环就可以接下去：链上每个关系项从某步起不活跃（`Carries.chain_ends_of_em`）。这一形式只说终结，不给界；核心仍从 prelude 编译，公理报告为空。

**作者反审。**

*反驳 1：这只是 `ends_within` 的迭代。* 是。新内容在于迭代可行、界逐环可读：`coextinct_lasts` 的结论（不复现）不能作为下一环的前提，`ends_within` 的显式终结之步恰好接上下一环需要的“从某步起不被支持”。

*反驳 2：所有环从同一步 T 起依存，是否太强？* 每一环的依存只需在前一环终结时已成立；取共同的 T 使陈述简单，`chainEnd_ge` 保证每一环的终结不早于 T。依存在链的中途改变（例如换宿主）时链断开，这时适用的是替代与转化，不是共灭。

*反驳 3：链是序列，不是图。* 一个关系项依存于几个条件时，任一个所需不被满足都使它不被支持；所以沿到达它的任一条链，界都成立：图上的每个关系项在到达它的某条链的 `chainEnd` 之后终结（P33b 更正：P31 的定理要求不止的链，在有限的链上空成立；现在 `chain_ends` 对 n 环的有限链陈述，沿到达它的每条有限链的界由它给出；见 §45 T2）。取所有链的最小值的形式没有陈述。

*反驳 4：`Cascade` 是特意构造的。* 是：它是界可以达到的最小见证，与 `Seed`、`Viable`、`Famine` 地位相同。种群、种子库与储蓄中的级联是应用的例子，不是定理的内容。

*反驳 5：以排中律为假设是否把经典逻辑带进了核心？* 没有。`chain_ends_of_em` 是一个条件陈述：排中律是它的一个前提，核心的公理报告仍为空，从 prelude 编译。它表明，构造地不能逐环接下去的只是把“不复现”化为终结之步这一步；接受排中律的读者由此得到无界的形式，不接受的读者仍有衰减时的有界形式。

**边界。** 无伦理谓词，不评价共灭；界只对离散步与衰减的储备陈述，不衰减的形式以排中律为假设、没有界；链上的依存与体现是表示前提；名称（chainEnd、Cascade）是 AI 的表述，由 Ren 定。本节尚未经独立审查。

## 42. 第十一次独立审查与更正（P29b）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P26（§35）、P27（§36）、P28（§37）、P25b（§38）与 P29（§39）（[审查](../history/root-foundation/BECOMING-P25B-P29-REVIEW.md)，对象 `0cf14b8b`）。它在仓库之外从前导重新编译核心闭包的 29 个模块，1830 条源声明（1126 项定理）的公理报告全空；闭包的 5153 个常量中依赖公理的只有 35 条编译器生成的 `injEq` 引理，都只依赖 `propext`，与回执所列相同；回执、源哈希、保留产物、外围回执、引用哈希与证明绑定都对；各阶段的定理数与研究、计划和章节一致。数学全部接受，没有错误的 Lean 陈述。它写了 47 条探针声明（32 项定理，生成的 159 个常量都不依赖公理），提出十一项（R1–R11）：两项散文中的错误（R1、R2），六项过强（R3–R8，其中 R6 缺少反例），三项表述与出处（R9–R11）。第十次审查的 O2–O6、O9 关闭；O1、O7、O8、O10、O11 的残留就是 R4、R5、R9、R1、R2。P30（§40）与 P31（§41）在审查期间或之后提交，审查没有读；R6 与 R11(a) 已由 P30 回答。本节记录逐项处理。探针 S1、S2、S4–S6 的内容移入核心（S3 的内容已由 P30 给出），名称按核心改写；公理报告为空。§26、§34、§36、§38、§39 与英文段落中受影响的句子已就地更正并标明。

```text
Result(s): 更正 space-and-its-parts（R1、R2、R9）、map-of-premises（R3、R10）、continued-change-needs-openness（R3、R4、R8、R10）、
           bounded-census-keeps-pace（R5、R7、R9）、ceasing-needs-arising、census-balance、coming-and-ceasing-keep-pace（R9）；
           没有新的成果记录
Delta: Change：stays_failing、persists_of_em（exists_not_of_em 已在 P31 加入）。Roles：Web.Dependent.ceases_below；inactive_below 的说明。
       Space：quiet_of_once；World.Seedbank（Relatum、soil、level、flow、web、distinct）、World.seedbank、seedbank_world；World.law_of_em、
       World.law_iff_em；Ren 原话、名称与 grazing_browser_ends 的说明。Premises：listed_of_ever、World.counted_of_ever；World.Brood 改名
       World.Hatch，brood_* 改名 hatch_*；World.hatch_ever、hatch_idle；Binds 的说明。Openness：World.Finite.census_bounded（countedWithin
       由它证明）；gather、gather_self、mem_gather、comes_after、Listed.few_of_quiet、World.few_active、World.rest_few；Holding（level、
       flow、web、open_at、census）、World.holding、holding_world；brood_rests 改名 hatch_rests。Population：unceasing_iff_bounded 与模块
       说明的用语（R5）
Supplied premises / correspondence: 不变；law_of_em 以排中律为定理的假设，不是公理
Evidence: 合并检查器回执 20261009T185557.684339Z（1131 项定理／1826 项声明审计，核心闭包 29 个模块，包 27 个模块，源声明的公理报告全空）；
          外围桥接重跑 20261009T185801.898161Z；实例检查
Boundary: 不含伦理结论；不替 Ren 选择任何读法；§8 的一项选择按 R1 放宽，第一项选择按 R9 写出 Ren 回复时的语境；新名称（hatch、
          seedbank、holding）是建议；新见证都是最小见证
Integration: §26、§34、§36、§38、§39 与英文 P19、P25b、P29 的就地更正；审查 §4 的各项完成，Ren 的选择保持开放
```

### 42.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| R1 | “活动需要支持时，对持续不变的依存的每次侵蚀都与依存者的终结同时”不成立：`inactive_below` 只给出依存者在该步之后不活跃；依存者此前就不活跃时没有终结。探针 sleeper：有限、平衡、每个关系项体现、活动需要支持，一次侵蚀使事件不活，而世界中从无止息。这句来自第十次审查的 O10 与 Q8 | 新增 `Web.Dependent.ceases_below`（Roles）：依存者原本活跃时，这样的侵蚀与它的终结同时。sleeper 移入核心为 `World.seedbank`（汲取者、种子、土壤）与 `seedbank_world`：活动需要支持、体现、平衡、有限，`UnderminingOn 0 drawer soil`，世界不 living，`inactive_below` 的前提成立，而种子从不活跃，世界中没有任何止息。Roles 与 Space 的模块说明、`inactive_below` 与 `grazing_browser_ends` 的说明、README、检查器、章节第 10 条与 §9、记录 space-and-its-parts 改写；§8 的 Ren 选择放宽为“依存者在该步之后不活跃的侵蚀”，包括休眠的依存。§34 反驳 3、§38.1 O10 与 §38.2 Roles 行就地标明。这句话的过强来自第十次审查本身 |
| R2 | §38 与英文 P25b 说 `law_decides` 的逆命题需要选择公理、在纯净核心中不能陈述；逆命题可以陈述，以排中律为假设、不用可判定性与选择即可证明（探针 `law_iff_em`） | 移入核心：`World.law_of_em`（以排中律为假设，有限世界中生起复现恰当止息复现，两个方向都证明，审查只给出一个方向）与 `World.law_iff_em`（对每个有限世界要求这一规律而不给可判定性，等价于排中律），连同 `quiet_of_once`（Space）与 `persists_of_em`、`stays_failing`（Change；否定的全称取反例的 `exists_not_of_em` 已在 P31 为沿链的共灭加入）。说明改为“等价于排中律”。§38.1 O11(a)、§38.4 反驳 4 与英文 P25b 就地更正；章节的逻辑承诺与开放项不再说这一规律只能在外围以经典逻辑陈述 |
| R3 | P29 中普查起约束的条件是世界不有限；`brood` 的地关系项闲置，普查来自只有三个关系项曾经活跃；在静止定理适用的每个世界中，曾经活跃或立着的都不是无界多 | 移入核心：`Listed.few_of_quiet`（列出之下开始成立不复现时，曾经成立的成员不是无界多），`World.few_active`，`World.rest_few`（静止定理的前提之下，曾经活跃的与曾经立着的关系项都不是无界多；围住只需不被否定），连同 `gather`、`mem_gather`、`comes_after`；`listed_of_ever` 与 `World.counted_of_ever`（曾经活跃者可列出时有普查）；`World.hatch_ever`（只有食物、亲代与子代曾经活跃）与 `hatch_idle`（地关系项从不立着、从不活跃、从不参与流、从不被依存或汲取）。`Binds` 的说明、Premises 与 Openness 的模块说明、章节第 3、4 条与 §2、根基第 5 行、记录与计划写明：世界不有限只因闲置的关系项；静止定理比 `rests` 多涵盖的只是从不立着、从不活跃的关系项。`hatch` 中活动需要支持起约束而不紧（食物从不低于所需），关于流的四个前提只在第 0 步起约束。§39 的“普查起作用”与反驳 2、英文 P29 就地更正。审查的手证（在静止定理的前提下，流只在有限多步参与）没有形式化，列为开放 |
| R4 | 记录 continued-change-needs-openness 的标题漏掉活动的普查，`dusk` 反驳它；“每步立着的有限多”混同两种普查 | 标题与对应写出每步立着的与活跃的有限多（两种普查），“立着的变化只有有限多次”；章节第 4 条、§2、§8 现状行与根基第 5 行同改。CLAIMS 由记录生成 |
| R5 | P27 重新引入“生成不息恰当止息复现”（O7 的残留） | `Population` 的模块说明与 `unceasing_iff_bounded` 的说明、记录 bounded-census-keeps-pace、§26 表、§36 表与英文 P19 改为“生起复现恰当止息复现”，就地标明 |
| R6 | 有界定律只需界在无限多步成立；任何不减且趋于无穷的计数都允许只生不灭 | 已由 P30 回答：`Listed.ceasing_of_returning` 与 `World.CountedBy.arising_iff_ceasing`（界在任意晚的步回到某数以内）对应探针 `ceasing_of_coming_often`、`arising_iff_ceasing_often`；`World.slow_world`（对每个不减而无界的界）对应 `paced_world`。章节 §2 写“须同时活跃者的计数趋于无穷”与“在任意晚的步至多 B 个” |
| R7 | `Finite.countedWithin` 的说明“每个普查”比陈述强 | 新增 `World.Finite.census_bounded`：有限世界的每个普查都以关系项的数目为界，不需要可判定性；`countedWithin` 由它证明，说明改为“活动可判定的有限世界有一个普查，它以关系项的数目为界”。记录的假设去掉“需要可判定的活动”这一普遍读法 |
| R8 | “满足八个前提而没有一步被围住的世界生起不息”读作一般时为假（探针 s6_holding） | 移入核心：`Holding` 与 `World.holding_world`：一侧以零净量与无界的地交换、保持其水平，满足八个前提，没有一步被围住，生起与止息都不复现，世界不有限。章节第 4 条、§2、§8 现状行、词汇表、根基第 5 行、记录与计划写为“一个这样的世界（exposed）……另一个（holding）……”：开放是生起不息的必要条件而不充分 |
| R9 | Ren 的“不overlap吧”有三种写法；Ren 确认的是英文的 arising/ceasing；Ren 回复时的语境没有写出 | Space 的模块说明与四份记录照录原话，或写为“以‘吧’预设二者不重叠”；中文各处写“Ren 确认英文名称 arising/ceasing（中文 生起／止息 是 AI 的译名）”；来源文件的标题改为 Ren 的原词，原标题在更正说明中保留；章节 §8 第一项写出 Ren 回复的 AI 说明中“despite Ren saying they shouldn’t overlap”一句，并请 Ren 说明活动的读法是否仍是候选。§39 与计划就地标明 |
| R10 | 核心中有两个不同的 brood | P29 的 `World.Brood`、`World.brood` 与 `brood_*` 改名 `World.Hatch`、`World.hatch`、`hatch_*`；`Roles` 中世代不息的 `Brood` 保持原名（它被章节、两份记录与 `Descent` 引用）。名称是建议，由 Ren 定 |
| R11 | (a) 依存的平衡没有实例；(b) 英文 P25b 没有计数行，计划 P25b、P29 行没有回执；(c) §2 的界；(d) census-balance 的下一步 | (a) 已由 P30 的 `Web.DependenceCensus.over_stretch` 回答。(b) 补上，标明 P29b 补记。(c) 见 R6。(d) 审查认为不需要处理 |

### 42.2 新的已检查声明

| 模块 | 声明 | 内容 |
|---|---|---|
| Change | `stays_failing`、`persists_of_em` | 不成立且在之后各步不开始成立者保持不成立，不需要可判定性；以排中律为假设，成立且在之后各步不再成立者保持成立 |
| Roles | `Web.Dependent.ceases_below` | 活动需要支持时，依存者原本活跃、其持续不变的依存跨一步落到所需之下，它就在该步止息 |
| Space | `quiet_of_once`、`World.Seedbank`、`World.seedbank`、`seedbank_world` | 以排中律为假设，列表中每个成员从某步起至多发生一次时，它们从某步起都不再发生；种子库：侵蚀而无终结 |
| Space | `World.law_of_em`、`World.law_iff_em` | 以排中律为假设，每个有限世界中生起复现恰当止息复现；对每个有限世界要求这一规律而不给可判定性，等价于排中律 |
| Premises | `listed_of_ever`、`World.counted_of_ever`、`World.Hatch`、`World.hatch_*`、`hatch_ever`、`hatch_idle` | 曾经成立者被一个有限表包含时，每步的成立者可列出；世界的普查由此得出；`hatch` 中只有三个关系项曾经活跃，地关系项闲置 |
| Openness | `World.Finite.census_bounded` | 有限世界的每个普查都以关系项的数目为界 |
| Openness | `gather`、`gather_self`、`mem_gather`、`comes_after`、`Listed.few_of_quiet`、`World.few_active`、`World.rest_few` | 列出之下开始成立不复现时曾经成立者不是无界多；静止定理适用的世界中曾经活跃与立着的关系项都不是无界多 |
| Openness | `Holding`、`World.holding`、`holding_world`、`hatch_rests` | 满足八个前提、没有一步被围住而什么也不生起的世界；`hatch` 在一次生起与一次止息之后归于静止 |

### 42.3 作者反审

*反驳 1：`seedbank` 是不是在制造一个不自然的反例？* 它是满足已公开定义的最小世界，与审查的 sleeper 相同：休眠的种子以不变的所需依存于土壤，汲取者取走土壤。它说明 R1 的那句话超出了定理，不说明种子库在现实中怎样。按方法，它只表明定义允许什么。被侵蚀的依存者休眠时，是否计入不活，现在明确列为 Ren 的选择的一部分。

*反驳 2：`law_iff_em` 把排中律放进纯净核心了吗？* 没有。排中律在 `law_of_em` 中是定理的一个假设，在 `law_iff_em` 中是等价的一边；核心的公理报告仍为空，从前导编译。它纠正的是一个关于核心能表达什么的错误说法：逆命题不需要 `Decidable` 数据，证明可以留在 `Prop` 中。审查只给出从生起到止息的方向；本节两个方向都证明，从止息到生起的方向用 `stays_failing` 与 `quiet_of_once`。

*反驳 3：`rest_few` 是否削弱了 P25 与 P26 的推广？* 它限定推广，不取消它。“世界不必有限，起作用的是每步立着的与活跃的有限多”在形式上仍成立，而且每步的前提比世界有限更容易核对。`rest_few` 说明这些世界在归于静止时与有限世界的差别只在从不立着、从不活跃的关系项。这一点属于推广本身，应当写在它旁边。

*反驳 4：为什么不删去 `Binds` 的普查一项，换成更强的条件？* 在归于静止的世界中，普查不能在更强的意义上起约束（`rest_few`）。保留 `Binds.counted` 并在说明中写清它只说世界不有限，比另造一个条件更诚实；`hatch_ever` 与 `counted_of_ever` 把普查的实际来源写成定理。

*反驳 5：改名 `hatch` 是否必要？* 两个 brood 用途相反：`Roles` 中的世代不息、不耗散，P29 的在一次生起后归于静止。章节在相隔几段处都称 `brood`。改动较少的一个被改名；名称由 Ren 定。

**边界。** 不含伦理谓词；不改变任何读法选择的地位，§8 的一项选择按 R1 放宽，第一项写出 Ren 回复的语境并请 Ren 说明；新名称是建议；新见证都是最小见证。本节的更正与 §40、§41 尚未经独立审查。

## 43. 延续下的普查平衡与跨一步的精确条件（P32）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P32。identity-across-steps 的局限写着，没有分裂是更多迫使生起的充分条件，不是必要条件，精确的界限没有陈述；它的下一步与正典第 8 节的进一步证明都列出“延续关系上使更多迫使生起的充要条件”。另一方面，普查定律（§35–§37、§40）都以名字规定的同一读生起与止息，即每个形成只延续自身。本节回答前者，并把后者推到每个延续关系：普查定律在延续下的哪一半成立，恰由没有分裂或没有合并决定。没有新模块：一般的计数引理放在 `Becoming.Population`，延续下的读法与见证放在 `Becoming.Identity`。成果记录：修订 [identity-across-steps](../../../../theories/becoming/results/records/identity-across-steps.md)；新增 [census-balance-under-continuation](../../../../theories/becoming/results/records/census-balance-under-continuation.md)。

```text
Result(s): 复用 identity-across-steps（Continues、ArisesFrom、UnceasingFrom、NoSplit、arisesFrom_self、
           Census.decideContinues）、census-balance（mark_add_not、marks_le_of_sub、balance_over_stretch 的形式）、
           ceasing-needs-arising（Web.arising_of_ceasing）、bounded-census-keeps-pace（Web.ceasing_of_arising）、
           more-needs-renewers（Census、Distinct、length_le_of_matched、decideSome）；
           修订 identity-across-steps；新增 census-balance-under-continuation
Delta: Population：mark_le_total、total_le_mark、le_over_stretch、ge_over_stretch、gaining_of_losing、losing_of_gaining；
       Identity：forces_iff_noSplit、paired、paired_mem、paired_noSplit、paired_covers、forced_iff_more、
       Web.Continued、Web.CeasesFrom、Web.NoMerge、ceasesFrom_self、self_one_to_one、Census.balanceFrom、
       Census.balanceFrom_eq、Census.arisingFrom_of_ceasingFrom、Census.ceasingFrom_of_arisingFrom、
       Census.decideContinued；Tandem.web、alive、apart、census、kept、buds、budding、joins、joining
Supplied premises / correspondence: 延续关系是读法（同 identity-across-steps），定理对每个读法成立；普查；活动、延续与
       “是否延续某个活跃形成”可判定（定理的假设）；有界的一半另需从某步起至多 B 个活跃；跨一步的刻画对列表陈述，
       不需要依存网，forces_iff_noSplit 的必要方向用相等可判定
Evidence: 合并检查器回执 20261009T192237.890720Z（1153 项定理、1857 项声明审计、核心闭包 29 个模块、包 27 个模块，全部源声明公理报告
          为空）；外围桥接重跑 20261009T192558.793391Z；实例检查
Boundary: 只对离散步与每步有限的活动陈述；延续关系由读法给出，不说哪一个是同一；整段上没有分裂与没有合并只是充分
          条件，单步的刻画是精确的；平衡是计数，不是机制；不评价生起或止息；名称由 Ren 定
Integration: 计划 P32；回答 identity-across-steps 的下一步与第 8 节同名的进一步证明（延续关系上更多迫使生起的充要
             条件，跨一步）；把普查定律推到每个延续关系
```

| 声明 | 内容 |
|---|---|
| `forces_iff_noSplit` | 对一步的延续 S：对任意步前与步后的列表（步后的不重复），步后多于步前时总有步后的形成不延续步前的任何形成，恰当没有形成延续为两个 |
| `paired`、`paired_noSplit`、`paired_covers` | 两个列表按次序配对；步前的不重复时没有分裂；步后的不多于步前时，步后每个形成都延续某个步前的形成 |
| `forced_iff_more` | 步前与步后的列表都不重复时：在每个没有分裂的延续下都迫使生起，恰当步后多于步前 |
| `Web.Continued`、`Web.CeasesFrom`、`Web.NoMerge` | 在延续下被延续；在延续下止息：步前活跃，步后没有活跃的形成延续它；没有合并：步后活跃的形成不延续两个步前活跃的形成 |
| `ceasesFrom_self`、`self_one_to_one` | 每个形成只延续自身时，止息即止息，既无分裂也无合并 |
| `mark_le_total`、`total_le_mark` | 某成员有某性质的命题，其标记不超过有该性质的成员数；至多一个成员有它时，成员数不超过该命题的标记 |
| `Census.balanceFrom` | 普查之下每一步：没有分裂时，步后活跃的连同止息的至多是步前活跃的连同生起的；没有合并时至少如此 |
| `Census.balanceFrom_eq` | 两者都没有时恰好相等 |
| `le_over_stretch`、`ge_over_stretch` | 每步的不等式跨任一段步累加 |
| `gaining_of_losing`、`losing_of_gaining` | 每步终点连同失去的不超过起点连同得到的：失去复现需要得到复现；反向且计数从某步起有界时，得到复现需要失去复现 |
| `Census.arisingFrom_of_ceasingFrom` | 普查、没有分裂：止息在任意晚的步出现需要生起在任意晚的步出现 |
| `Census.ceasingFrom_of_arisingFrom` | 普查、没有合并、从某步起至多 B 个活跃：生起在任意晚的步出现需要止息在任意晚的步出现 |
| `Census.decideContinued` | 普查之下，延续可判定时，“是否被某个活跃形成延续”可判定 |
| `Tandem.kept` | 每步 t 与 t+1 两个形成活跃；每个形成只延续自身时，每步一个生起（t+2）、一个止息（t） |
| `Tandem.budding` | 读作萌出（t+1 延续为自身与 t+2，t 不被延续）：普查成立、没有合并、有分裂，每步 t 止息，从不生起 |
| `Tandem.joining` | 读作合并（t 与 t+1 都延续为 t+1）：至多两个活跃、没有分裂、有合并，每步 t+2 生起，从不止息 |

**解读。**

- **跨一步，精确的条件。** 一个形成 g 延续为两个不同的形成 f 与 f′ 时，步前只有 g、步后有 f 与 f′：步后更多，而每个都延续 g，没有生起；没有形成延续为两个时，步后每个形成都延续步前某个形成就使步后不多于步前（`length_le_of_matched`）。所以对任意步前与步后的形成，更多迫使生起恰当没有分裂（`forces_iff_noSplit`）。数目的一面也精确：在每个没有分裂的延续下都迫使生起，恰当步后多于步前，因为步后不多时，按次序配对（`paired`）就是一个没有分裂、使步后每个形成都延续某个形成的延续（`forced_iff_more`）。在一步上，没有分裂是延续上的充要条件，更多是数目上的充要条件；`arisesFrom_of_more` 是充分的一面读于依存网。
- **整段上。** 一次分裂只在那一步起作用：`Fork` 在第一步分裂，此后形成仍在任意晚的步生起；每步都有分裂可以吸收增长（`Budding` 中一个形成延续为所有形成，`Tandem.budding` 中每步只一个形成延续为两个）。整段上只对延续关系给出与结论等价的条件，只是重述（存在由延续封闭、无界增长的列表序列），所以本节不把它当作定理；精确的是单步的刻画，整段上没有分裂只是充分条件。
- **延续下的平衡。** 证明以跨步延续的配对数为中介。步后被延续的形成不多于配对数（每个被延续的至少有一对，`mark_le_total`），没有合并时恰是（每个至多一对，`total_le_mark`）；步前被延续的形成也不多于配对数，没有分裂时恰是；两种配对数相同（`total_swap`）。步后的数目是被延续的加生起的，步前的数目是被延续的加止息的，于是没有分裂时步后连同止息的至多是步前连同生起的，没有合并时至少如此，两者都没有时相等（`Census.balanceFrom`、`balanceFrom_eq`）。每个形成只延续自身时（`self_one_to_one`），这就是 `Listed.across` 读于活动。
- **两半的定律。** 每步的不等式跨段累加（`le_over_stretch`、`ge_over_stretch`），抽象地：一个计数每步终点连同失去的不超过起点连同得到的，失去复现就需要得到复现，因为复现的失去累积超过起点的计数（`gaining_of_losing`）；反向且计数从某步起有界时，得到复现需要失去复现（`losing_of_gaining`）。读于延续：没有分裂时止息复现需要生起复现，这是 `arising_of_ceasing` 推到每个没有分裂的延续（`Census.arisingFrom_of_ceasingFrom`）；没有合并且从某步起至多 B 个活跃时生起复现需要止息复现，这是 `ceasing_of_arising` 推到每个没有合并的延续（`Census.ceasingFrom_of_arisingFrom`）。
- **每个条件都不可少。** `Tandem` 是一个展开、三种读法：每个形成只延续自身时每步一个生起、一个止息（`kept`）；读作萌出，较晚的形成延续为自身与新形成、较早的不被延续，普查成立、没有合并，每步一个止息而从不生起（`budding`）；读作合并，两个都延续为较晚的那个，至多两个活跃、没有分裂，每步一个生起而从不止息（`joining`）。展开不变，读出的生起与止息随读法而变；平衡的每一半恰在一种读法下失效。

**作者反审。**

*反驳 1：单步的刻画是平凡的。* 两个方向都短。内容在于界限精确了：以前只知道没有分裂充分，现在知道在一步上它也必要，而在整段上不必要（`Fork`），所以整段的结论依靠的是许多步上的没有分裂，不是关于延续关系的某个整体条件。

*反驳 2：`forces_iff_noSplit` 用了相等可判定。* 只在必要的方向用：从“不能有两个不同的”得到“相等”。不设可判定时，同样的论证给出相等的双重否定；这是构造逻辑的界限，不是公理。`forced_iff_more` 与平衡都不用它。

*反驳 3：延续关系任意给定，平衡是否只是记账？* 是计数，不是机制：它不说哪个形成生起，也不说哪个读法对。它说明的是，普查定律不依赖名字规定的同一：只要读法没有分裂，止息需要生起就成立；只要没有合并，有界时生起需要止息就成立；能抹去生起或止息的恰是分裂或合并。identity-across-steps 中“延续关系下……”的计数部分由此回答；形成的类、任期与侵蚀在延续下仍未陈述。

*反驳 4：`Tandem` 是特意构造的。* 是，最小见证。它的意义在于三种读法作用在同一个展开上，是 `Turnover`（同一由表示给出）的计数版本。萌出与合并在生物中有其例（分裂繁殖、融合），那是应用，不是定理的内容。

**边界。** 无伦理谓词，不评价生起或止息；只对离散步与每步有限的活动陈述；延续关系由读法给出，本节不说哪一个是同一；整段上没有分裂与没有合并只是充分条件；名称（CeasesFrom、NoMerge、Tandem、paired）是 AI 的表述，由 Ren 定。本节尚未经独立审查。

## 44. 交换归于静止（P33）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P33。第十一次独立审查在 R3 中注意到 `hatch` 的流只在第 0 步参与，并给出一个论证：在静止定理的前提之下这是必然的，被围住的一步上有取用时总水平至少下降一，给予需要取用，每步立着的有限多时这只能发生有限多次；它注明这是手写论证，审查没有形式化它。§42 把 R3 的其余部分移入核心（`rest_few`），这一论证仍未检查。本节把它证明为定理，并给出它的每个前提都不可少的见证。没有新模块：定理放在 `Becoming.Openness`。成果记录：修订 [continued-change-needs-openness](../../../../theories/becoming/results/records/continued-change-needs-openness.md)。

```text
Result(s): 复用 continued-change-needs-openness（Flow.AroundStanding、standing_never_rises、falls_finitely、
           Web.StandingCensus.stock_eq、World.exposed_world、exposed_standing、Kindling.unlisted、Exposed.stands_iff）、
           Becoming.Dissipation（Flow.Balances.runs_down、DissipatesOn.takes_of_gives、witnesses_not_dissipative、
           Frontier.burning_self）、Becoming.Flow（Cycle.closed_more）、space-and-its-parts（leaking_world、
           kindling_world）；修订 continued-change-needs-openness
Delta: Openness：Flow.ExchangeRecurs、Flow.exchange_lowers、Flow.exchanges_finitely、World.exchange_stops、
       World.exchange_needs
Supplied premises / correspondence: 所立者的普查、平衡、耗散，以及从某步起每步不被否定地围住所立者（定理的假设）；
       不需要活动的普查、体现或相等的判定；交换指在场的形成取用或给予正的量
Evidence: 合并检查器回执 20261009T194202.548300Z（1157 项定理、1862 项声明审计、核心闭包 29 个模块、包 27 个模块，全部源声明公理报告
          为空）；外围桥接重跑 20261009T194414.300336Z；实例检查
Boundary: 只对离散步与自然数量陈述；交换归于静止陈述为复现的否定；不评价静止或开放；名称由 Ren 定
Integration: 计划 P33；把第十一次审查 R3 的手写论证变为定理；补足静止定理：被围住时停止的不只是水平的变化，
             还有交换本身
```

| 声明 | 内容 |
|---|---|
| `Flow.ExchangeRecurs` | 流在任意晚的步交换：某个在场的形成取用或给予正的量 |
| `Flow.exchange_lowers` | 平衡与耗散之下、所立者被列出时，跨过围住所立者的一步，在场的形成取用或给予任何东西，所立者的总水平都严格下降 |
| `Flow.exchanges_finitely` | 从某步起每步不被否定地围住所立者时，交换不复现 |
| `World.exchange_stops` | 世界层面的同一陈述：有所立者的普查、平衡、耗散且从某步起被围住所立者的世界中，交换不复现 |
| `World.exchange_needs` | 四个前提各不可少，缺少一个时其余成立而交换复现：`exposed`（满足八个前提，没有一步被围住）、Flow 的循环（被围住、平衡，不耗散）、`leaking`（被围住、耗散，不平衡）、`kindling`（被围住、平衡、耗散，所立者不能被列出） |

**解读。**

- **交换为什么降低总水平。** 围住的家族持有一步上交换的一切：在场的形成不从它之外取用，也不给它之外（`ClosedAt`）。形成有所取用时，取用落在家族之内；只给予时，耗散使给予家族需要从家族取用（`takes_of_gives`）。所以它从家族取用正的量，平衡的流下家族的总水平至少下降取用者的数目（`runs_down`），而所立者的总水平就是家族的总水平（`stock_eq`，用到所立者的普查）。证明是构造的：“取用落在家族之内”先只得到双重否定，借自然数比较的可判定性消去。
- **交换为什么停止。** 跨过这样的步总水平不上升（`standing_never_rises`），每次交换都使它下降；一个不上升的自然数序列只能下降有限多次（`falls_finitely`）。所以交换在任意晚的步发生，与从某步起每步被围住不相容。
- **不由水平不再变化推出。** `stills` 说水平不再变化；交换不必改变任何水平：Flow 的循环中每步取用一个单位再还回，水平不变而交换不息。所以要用的是耗散使每次交换都严格降低总水平（`exchange_lowers`），而不只是水平变化时才降低。
- **需要的比静止定理少，给出的也不同。** 静止定理说的是活动，所以还需要活动的普查与生起者体现；交换的静止只关于流与水平。`dusk` 满足 `exchange_stops` 的全部前提而止息不息（`rest_needs_census`）：交换归于静止不给活动归于静止。
- **每个前提都不可少。** `exchange_needs` 的四个见证各缺一个前提。`exposed` 中耗散空成立，因为没有一步被围住；`kindling` 中围住只对空列表成立，因为没有列表列出所立者（每个未燃的燃料都立着），这正是没有普查时前提剩下的内容：“围住某个列表”不约束所立者。

**作者反审。**

*反驳 1：这只是 `stills` 的推论。* 见上：循环中水平从不变化而交换不息，所以交换的停止要用每次交换都使总水平严格下降，这是本节新证的引理。

*反驳 2：`kindling` 的见证用了空列表，是取巧。* 定理的前提是：有一个列表是所立者的普查，且从某步起每步围住它。去掉普查，剩下的“每步围住这个列表”对空列表成立；`kindling` 表明这时交换可以不息，所以普查不能去掉，而不是说空列表是所立者。

*反驳 3：陈述为复现的否定太弱。* 与静止定理同一形式（`¬ ArisingRecurs`）。得到“某步之后再没有交换”需要判定交换是否发生；可以判定时经典地两者等价。这是构造逻辑的界限，不是公理。

*反驳 4：这对生生有什么意义？* 本节不作评价。它说的是：在所立者有界地被列出、平衡且耗散的展开中，不只是持续的生起，连持续的交换都需要越出所立者的步。“开放”在这里有了更具体的形式内容：交换的持续，而不只是变化的持续。读法与名称属于 Ren。

**边界。** 无伦理谓词，不评价静止或开放；只对离散步与自然数量陈述；交换的静止是复现的否定；名称（ExchangeRecurs、exchange_lowers、exchanges_finitely、exchange_stops、exchange_needs）是 AI 的表述，由 Ren 定。本节尚未经独立审查。

## 45. 第十二次独立审查与更正（P33b）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P30（§40）、P31（§41）与 P29b（§42）（[审查](../history/root-foundation/BECOMING-P30-P31-P29B-REVIEW.md)，对象 `a9326202`）。它在仓库之外从前导重新编译核心闭包的 29 个模块，1896 条源声明（1171 项定理）的公理报告全空；闭包的 5333 个常量中依赖公理的只有 35 条编译器生成的 `injEq` 引理，都只依赖 `propext`，与回执所列相同；回执、源哈希、保留产物、外围回执、402 个引用哈希与 112 个证明绑定都对，各阶段的计数与章节、研究和计划一致。数学全部接受，没有错误的 Lean 陈述。它写了 55 条探针声明（38 项定理，生成的 107 个常量都不依赖公理），提出八项（T1–T8）：三项错误（命名、散文与文档注释各一，T1、T3、T4），三项过强（T2、T5、T6），两项出处与记账（T7、T8）。第十一次审查的 R1、R2、R4–R7、R10 关闭；R3、R8、R9、R11 的残留就是 T5、T4、T7、T8。P32（§43）与 P33（§44）在审查期间或之后提交，审查没有读。本节逐项处理，并把审查的三个探针移入核心。成果记录：修订 [reserve-defers-ending](../../../../theories/becoming/results/records/reserve-defers-ending.md)、[continued-change-needs-openness](../../../../theories/becoming/results/records/continued-change-needs-openness.md)、[bounded-census-keeps-pace](../../../../theories/becoming/results/records/bounded-census-keeps-pace.md)；没有新的成果记录。

```text
Result(s): 更正 reserve-defers-ending（T2、T3）、continued-change-needs-openness（T4、T5）、bounded-census-keeps-pace（T1、T6）；
           没有新的成果记录
Delta: Change：LPO、clear、Clear（cases、false_of_not、not_both、and_left、and_right、and_both、of_not、mono、false_before、or_first、
       first_of_true、first_unique）。Reserve：Carries.chain_ends 与 chain_ends_of_em 改为对 n 环的有限链陈述；Web.climbs、
       Web.no_unending_chain；ShortCascade（web、unsupported、carries、decays、ranked）、short_cascade；Once（ind、ind_and_le、ind_fall、
       web、reserve、unsupported、carries、decided、once）、Web.lpo_of_ending。Openness：去掉重复的 namespace World（P30 的世界名为
       World.slow、World.slow_world 与 Slow.*）；Few（pick、found、passed、distinct_pick、distinct_found、mem_pick、mem_found、listed、
       comes_at、quiet）、Listed.lpo_of_few；holding_world 与模块说明的更正。Premises：模块说明的更正。登记：按回执所列的完整名称
       核对记录中的声明
Supplied premises / correspondence: 不变；LPO 是被陈述的命题，不是公理，也不是假设
Evidence: 合并检查器回执 20261009T195744.874839Z（1190 项定理／1905 项声明审计，核心闭包 29 个模块，包 27 个模块，源声明的公理报告全空）；
          外围桥接重跑 20261009T195906.931285Z；实例检查；make research-test
Boundary: 不含伦理结论；不替 Ren 选择任何读法；新名称（LPO 之外的 clear、Once、Few、ShortCascade、no_unending_chain、
          lpo_of_ending、lpo_of_few）是建议；新见证都是最小见证
Integration: §40、§41 与英文 P30、P31 的就地更正；来源文件的 AI 更正说明（T7）；计划 P30 一行补回执（T8）
```

### 45.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| T1 | `Openness.lean` 在已打开的 `namespace World` 中又打开一次，P30 的世界实际叫 `Becoming.World.World.slow`；章节、研究、计划、文档注释与 bounded-census-keeps-pace 的别名和引用所写的 `World.slow_world` 不存在；登记只按名称的末段核对 | 去掉内层 namespace，把 `namespace Slow` 移到 `World` 之外，名称成为 `Becoming.World.slow`、`World.slow_world` 与 `Becoming.Slow.*`，文本与记录原来写的就是这些。登记检查加一步：证明绑定所指的回执列出该模块由 Lean 展开的声明时，记录中的每个声明须以完整名称出现在其中（`tools/research/registry.py`，并加测试）；全部记录现在通过 |
| T2 | `Carries.chain_ends` 与 `chain_ends_of_em` 的前提对每个 k 要求第 k+1 环依存于第 k 环，所以要求不止的链；在有限、没有依存之环的网中（如任何食物链）两个定理空成立；“沿到达它的任一条链”的说法多于任何已陈述的定理 | 两个定理改为对 n 环的有限链陈述（前提只对 k < n，结论对 k ≤ n），不止的链是对每个 n 的情形，名称不变。新增 `Web.no_unending_chain`（依存沿有界的等级上升时没有不止的链，审查的 `no_chain`）与 `short_cascade`（`Cascade` 截为三个关系项：有限形式给出关系项 2 从第 3 步起不活跃，界可以达到，而不止的链不存在，审查的 `Short.short`）。§41 反驳 3 与英文 P31 就地更正 |
| T3 | §41 与英文 P31 说把“只在有限多步活跃”化为终结之步“需要马尔可夫原则”；这一步即使在活动可判定且至多发生一次时也蕴含 LPO，马尔可夫原则推不出 LPO | 移入核心：`LPO`（Change）与 `Web.lpo_of_ending`（Reserve，见证 `Once`）：若每个从不被支持、有储备且活动可判定的形成都有一步之后不再活跃，LPO 成立。两处就地更正。马尔可夫原则推不出 LPO 是标准事实（Kleene 可实现性），本节不形式化 |
| T4 | `holding_world` 的说明以“生起者体现”转述 `arising_opens`；后者要求每个关系项都体现，`kindling` 满足说明所列的前提、每步被围住而生起不息 | 说明改为：每个关系项都体现时开放是必要的，不充分；只要生起者体现时不必要，`kindling` 每步被围住而生起不息（`rest_needs_standing`） |
| T5 | `Openness` 与 `Premises` 的模块说明说静止的世界中曾经活跃或立着的“只有有限多”，而 `rest_few` 给出的是“不是无界多”；有一个列表列出全部的较强形式蕴含 LPO | 说明改为“不是无界多”（P33 已改两处，本节改其余各处），`counted_of_ever` 的前提写为“有一个列表列出每个曾经活跃的关系项”。移入核心：`Listed.lpo_of_few`（见证 `Few`）：若每个每步被列出、开始成立不复现的规定都有这样的列表，LPO 成立 |
| T6 | bounded-census-keeps-pace 的 next_delta 说“判据是比率”，比率形式只是充分条件 | 改为：精确的判据是缺额，比率形式是充分条件，slow 中从不满足 |
| T7 | 来源文件的更正说明把“生起”“止息”定为 AI 在 P23c 中的译名；它们自 P10、P19 起就在用，P23c 用它们命名空间的部分 | 来源文件中 AI 的更正说明就地改正并注明出处；Ren 的原话不变。第十一次审查是证据，不改 |
| T8 | (a) 计划 P30 一行没有回执；(b) 已提交的 `lean-index.json` 列入另一会话未跟踪的草稿文件 | (a) 补上回执 20261009T170233.740799Z 与外围回执 20261009T170422.519028Z。(b) `lean_catalogue.py` 按设计包括未跟踪文件；那些文件属于另一会话，不触动，也不改共享的工具；它们提交后索引即与提交一致。已告知那个会话 |

### 45.2 新的已检查声明

| 声明 | 内容 |
|---|---|
| `LPO` | 有限全知原则：每个布尔序列有某项为真或处处为假；排中律给出它，它没有构造性证明 |
| `clear`、`Clear.*` | 第 t 步之前没有真；第一个真唯一，有真就有第一个真 |
| `Carries.chain_ends`、`Carries.chain_ends_of_em` | 对 n 环的有限链：被依存的关系项体现、每环以正需要依存于前一环、第一环从 T 起终结时，直到第 n 个的关系项各在其前各环的储备过去后终结（储备衰减），或以排中律为假设各有终结之步 |
| `Web.no_unending_chain` | 依存沿以 K 为界的等级上升时，没有满足不止的链前提的序列 |
| `short_cascade` | 截为三个关系项的级联：有限形式给出的界可以达到，不止的链不存在 |
| `Web.lpo_of_ending` | 若每个从不被支持、有储备且活动可判定的形成都有一步之后不再活跃，LPO 成立；见证 `Once` 在 s 的第一个真处活跃一次 |
| `Listed.lpo_of_few` | 若每个每步被列出、开始成立不复现的规定都有一个列表列出曾经成立的全部成员，LPO 成立；见证 `Few` 每步至多列出一个成员 |

### 45.3 作者反审

*反驳 1：把 `chain_ends` 改为有限形式而沿用名称，掩盖了原来的错。* 原陈述没有错，只是要求不止的链；新陈述严格更一般，原陈述是它对每个 n 的实例，原陈述的检查保留在回执 20261009T185557.684339Z 与此后各回执中，本节与记录历史写明了改变。沿用名称是因为各处文本说的“沿依存之链”本来指有限的链，现在与定理一致。

*反驳 2：LPO 的两个定理是逻辑上的附注，不属于生成之论。* 它们说明核心为什么只陈述较弱的形式：不在任意晚的步活跃、曾经成立的不是无界多，而不是有一步之后不再活跃、有一个列表列出全部。这是核心的逻辑承诺（章节 §8）的一部分，与 `law_iff_em` 同类：说明哪一步需要非构造的原则，以及需要多强的原则。

*反驳 3：名称检查只覆盖有回执列出声明的模块。* 是。别的回执不列展开的声明，那里仍只按名称的末段核对；审查列出的 84 个非核心名称属于那些模块，本节不改。

**边界。** 无伦理谓词；Ren 的选择保持开放；本节的新名称是 AI 的表述，由 Ren 定。本节尚未经独立审查。

## 46. 计数的全部规律（P34）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P34。开放纲领把“对整个空间成立的规律的完整清单”列为进一步的证明；P23 的完成标准第 2 项说整体的规律“除了表示本身所排除的，不排除任何展开”。到 P33 为止，普查的平衡与由它推出的复现定律都已检查，但没有证明它们就是计数的全部规律：可能还有别的、尚未发现的计数规律。本节对计数回答这个问题，并说明哪些前提约束计数、全部八个约束到什么程度。成果记录：新增 [whole-law-of-counting](../../../../theories/becoming/results/records/whole-law-of-counting.md)。

```text
Result(s): 复用 census-balance（Listed、Listed.across 的证明、marks_le_of_sub、Web.Census）、
           coming-and-ceasing-keep-pace（comings、ceasings、mark、steps_last、steps_mem）、map-of-premises（八个前提、
           World.still_vacuous）、life-as-condition-of-life（Web.Embodied.arises_given）、space-and-its-parts（World、
           Flow.still）；新增 whole-law-of-counting
Delta: Population：Listed.keeps（Listed.across 改由它推出）、Tally、Listed.tally、steps 的长度与成员、Queue（gone、holds、
       line、listed、ceasings_eq、comings_eq、counts）、Pointwise、counting_laws；
       Premises：World.CountsObey、Queue.web、Queue.embodied、World.queue、World.embodiedQueue、queue_premised、
       embodiedQueue_premised、counting_free、Queue.lone_tally、counting_binds_jointly、Tended（队首照管的队列）、
       World.tendedQueue、tendedQueue_premised、premised_counting；Population：mark_turn
Supplied premises / correspondence: 列出与可判定（同普查的平衡）；性质尊重计数每步的值（Pointwise，代替函数外延性）
Evidence: 合并检查器回执 20261009T205957.521123Z（1223 项定理、1958 项声明审计、核心闭包 29 个模块、包 27 个模块，全部源声明公理报告为空）；
          外围桥接重跑 20261009T210516.903787Z；实例检查
Boundary: 只对离散步与每步有限的成立者陈述；只说计数；有限世界中与被围住时（静止定理之外）计数的规律没有陈述；
          不评价生起或止息；名称由 Ren 定
Integration: 计划 P34；回答开放纲领“对整个空间成立的规律的完整清单”的计数部分；补足前提的地图：哪些前提约束计数，
             全部八个约束到什么程度
```

| 声明 | 内容 |
|---|---|
| `Listed.keeps` | 跨每一步保持一些成员：连同不再成立的是步前的列表，连同开始成立的是步后的列表；普查的平衡 `Listed.across` 现由它推出 |
| `Tally`、`Listed.tally` | 计数表：每步某数 k 使 n t = k + c t 且 n (t+1) = k + a t；每个列出的计数都是计数表 |
| `Queue.holds`、`Queue.line`、`Queue.listed` | 队列：第 t 步在队中的，是从此前离开的总数起的 n t 个自然数，从队尾加入、从队首离开；每步被不重复地列出 |
| `Queue.counts` | 计数表之下，队列每步列出 n t 个，跨步离开 c t 个（队首的），加入 a t 个（队尾的） |
| `counting_laws` | 对计数的一个逐点的性质，在每个类型上每个列出的计数都满足它，恰当每个计数表都满足它 |
| `World.queue_premised`、`World.embodiedQueue_premised` | 排队而什么都不流动的世界满足除体现外的全部前提；排队且恰在活跃时立着的世界满足除平衡外的全部前提 |
| `World.counting_free` | 对计数的一个逐点的性质：对每个计数表成立，恰当它在每个世界的每个普查中成立，恰当它在满足除体现外全部前提的每个世界中成立，恰当它在满足除平衡外全部前提的每个世界中成立 |
| `World.counting_binds_jointly` | 平衡、只有活跃者给予且生起者体现时，普查之下没有关系项活跃的一步上没有生起；一个关系项从无到有地生起（`Queue.lone_tally`）在两个队列世界中都实现，所以这不是计数的规律 |
| `World.tendedQueue`、`World.tendedQueue_premised` | 由队首照管的队列：队首给予每个加入者一个单位、从每个离开者取用一个单位，活跃时与每个地关系项各交换一个单位；没有成员加入空队时满足全部八个前提 |
| `World.premised_counting` | 对计数的一个逐点的性质在满足全部八个前提的每个世界的普查中成立，恰当它对每个没有关系项活跃的一步上没有生起的计数表成立 |

**解读。**

- **为什么计数表是全部。** 计数表说的是：跨每一步，在场者分为留下的与离开的，之后的在场者是留下的加上来到的。任何满足这一点的数目序列，都可以由一个队列实现：成员依次从队尾加入，依次从队首离开，每步离开的恰是队首的 c t 个，加入的恰是队尾的 a t 个。所以从计数本身推不出关于展开的任何更多的东西；P26 到 P30 的复现定律、比率与界，都是计数表的推论（它们只用到平衡的等式），而不是另外的规律。（P34b 就地更正：此条原题“为什么平衡是全部”，说的却是保持的形式；平衡的等式严格弱于计数表，见下一条与 §48 U1。）
- **保持的形式。** 平衡原先写为 n (t+1) + c t = n t + a t。保持的形式更多地说出关系：跨一步有一些成员留下，离开的与来到的都相对于它们计数。它严格强于等式：它还说跨一步不再成立的不多于步前所列的，等式不给出这一点；计数表恰是平衡加上这一界（`tally_iff`），每步零个在列、一个不再成立、一个开始成立满足平衡而不是计数表（`balance_not_tally`），没有列出有这样的计数。所以全部规律须以保持的形式陈述。保持的形式推出原来的形式（`Listed.across` 由它推出）。（P34b 就地更正：原文给出的理由是保持的形式使证明不需要带 `propext` 的消去律；核心有不带公理的消去律，那不是理由，见 §48 U1、U7。）
- **逐点。** “对计数的一个性质”是数目序列上的任意命题。实现给出的计数与给定的计数逐点相等，而不是作为函数相等；在构造性的纯净核心中，由逐点相等推出函数相等需要函数外延性（Lean 中由 `Quot.sound` 证明）。所以定理要求性质尊重逐点相等。每个由各步的值说出的性质都如此，有函数外延性时每个性质都如此（P34b 就地更正：原文作“经典地”；函数外延性不是经典原则，Lean 中它来自 `Quot.sound`，与排中律和选择无关，见 §48 U7）。不用这一假设的刻画是：列出所能有的计数恰是计数表（`tally_iff_counted`）。
- **前提怎样约束计数。** 八个前提彼此独立（P24），但它们对计数的作用不同：缺平衡或缺体现的任何一组都不约束计数，因为两个队列世界分别满足除体现外与除平衡外的全部前提（关于流的前提在什么都不流动时空成立，体现在恰在活跃时立着时成立而平衡不成立）。平衡与体现连同只有活跃者给予一起约束：体现的生起是开始作为条件而在，平衡要求它被给予，只有活跃者给予要求给予者活跃，所以生起需要一个在场者。这不是计数的规律，因为从无到有的生起是一个计数表。
- **全部八个前提所加的。** 由队首照管的队列满足全部八个前提：队首给予加入者、从离开者取用，所以平衡成立，加入者由活跃的队首给予，离开者被活跃的队首取用；成员恰在队中时立着，所以体现成立；队首活跃时与每个地关系项各交换一个单位，净量为零，地关系项的水平不变而仍为零，所以没有有限家族在这样的步封闭，耗散在那里空成立；队空时（这时没有成员加入，也没有成员离开）什么都不交换。所以八个前提一起只在计数上加了一条：没有关系项活跃的一步上没有生起（`premised_counting`）。（P34b：审查（U3）指出，这个见证中耗散从不起约束，活动需要支持与有界传递也不起约束（`World.tended_not_binds`）；`premised_counting` 的范围包括前提空成立的世界。每个前提都起约束时，每个普查都计到某个生起（`World.binds_arising`），这在八个前提之下不是规律（`World.binds_adds`）。见 §48。）
- **与静止定理。** 静止定理（P26）是平衡、耗散、体现与被围住一起对计数的约束：生起与止息都不再复现。上面的世界中队首活跃的步没有一步被围住，所以它不受静止定理约束；计数在八个前提之下的这种自由，可以读作开放（P25）在计数上的形式（AI 的读法）。这些约束都来自前提的合作与被围住，不来自计数本身。

**作者反审。**

*反驳 1：队列太特殊，不是世界的“自然”实现。* 定理断言的是存在：每个计数表都至少由一个列出实现。任何更多的计数规律都必须在所有列出中成立，包括队列；队列不满足它，它就不是规律。实现是否“自然”与此无关。

*反驳 2：队列世界的关系项无限多，所以这不说明有限世界。* 对。有限世界中计数还受关系项的数目所限（在场的与来到的都不多于关系项），那里计数的规律本节没有陈述。记录的局限与下一步写明了这一点。（P35：它们已经陈述：有限世界中计数的规律恰是计数表、没有关系项活跃的一步上没有生起与从第 0 步起的变化界，与从某步起被围住时相同，见 §49。）

*反驳 3：`Pointwise` 是一个藏起来的公理。* 不是：它是定理的假设，不是核心的公理，任何具体的性质都可以直接检查它，例如 `counting_binds_jointly` 中的性质。它代替的是函数外延性，后者在 Lean 中依赖 `Quot.sound`；纯净核心不使用它。

*反驳 4：缺平衡或缺体现时不约束计数，这说明前提无用。* 不是：它说明每个前提单独地都不在计数上留下痕迹，约束计数的是前提之间的关系。平衡与体现一起说出了生起的一个条件（一个在场的给予者），再加上耗散与被围住，就有静止定理。这是一元方法的一个具体形式：约束来自关系，而不是来自分别命名的前提。

*反驳 5：队首照管的队列中耗散空成立，这使“满足全部八个前提”变得廉价。* 耗散只约束有封闭的有限家族的步（P16b）；队首活跃时它与无限多个地关系项交换，这正是 `exposed` 中那样的开放。见证没有违反任何前提，它说明：在不被围住的展开中，八个前提一起不再约束计数，除了生起需要一个在场者。若要求被围住，静止定理给出更强的约束；本节不陈述被围住时计数的全部规律。（P35：§49 陈述了它：再加一个变化界。）

*反驳 6：这对生生有什么意义？* 本节不作评价。它说的是：在场者的数目本身只记录进入与离开相抵；展开的方向（生起是否不息、是否归于静止）不能从计数读出，只能从给予与取用的关系读出。读法与名称属于 Ren。

**边界。** 无伦理谓词，不评价生起或止息；只对离散步与每步有限的成立者陈述；只说计数，读于世界只说活动；有限世界中与被围住时计数的规律见 §49；名称（Tally、Queue、Pointwise、CountsObey、counting_laws、counting_free、counting_binds_jointly、queue、embodiedQueue、tendedQueue、Tended、lone、mark_turn）是 AI 的表述，由 Ren 定。本节尚未经独立审查。

## 47. 延续的奠基：从想要延续者重述（W1–W5）

2026-10-10。Ren 提议从“想要自身延续者”重述普遍元伦理核心（[原话](../../../../sources/15-codex-theory-conversations/2026-10-10-wanting-continuation-one-axiom.md)）：想要延续者使其延续有意义；它须计入的整体范围依视角而定，不需要任何公理；加一条公理即闭合整体。AI 把它分为两半：动力学定出想要延续者必须计入的范围，定不出中心；那条公理的唯一作用是让每一点都是中心。Ren 答“exactly”，并说“commit them, then start implementation all the way to full completion”。本节实现[延续奠基计划](../history/root-foundation/CONTINUATION-GROUNDING-PLAN.md)的 W1–W5；阶段以 W 编号，与并行会话的 P 编号分开。成果记录：新增 [continuing-self-fed-from-beyond](../../../../theories/becoming/results/records/continuing-self-fed-from-beyond.md)、[own-count-misses-joint-excess](../../../../theories/becoming/results/records/own-count-misses-joint-excess.md)、[held-lives-g0-is-centering](../../../../theories/becoming/results/records/living-significance-on-held-lives.md)、[conveyance-crosses-the-boundary](../../../../theories/becoming/results/records/conveyance-crosses-the-boundary.md)、[derived-extent-limits](../../../../theories/becoming/results/records/derived-extent-limits.md)。

```text
Result(s): 复用 no-finite-part-bears-taking（taking_draws_in、Inward、Around、Lone）、generation-is-replenishment
           （rising_draws_in、Web.generation_draws_in）、more-needs-renewers（Balances、Acting）、
           metaethical-core-characterization（Valuation、SelfGood、transmits、shares、Neutral、Within、Reach）、
           becoming-stepwise-reading（Web.valuation、UnderminingAt、MetAbove.now）、life-as-condition-of-life（Flow.roles、
           Web.roles、inr_not_mem）、living-on-and-descent（sustenance、descent）、condition-correspondence-discipline
           （interaction）；新增上面五项
Delta: Continuation（L3，导入 Roles）：Conveys、FedFromBeyond、not_inward_of_fed、inward_of_not_fed、inward_iff_not_fed、
       fed_of_not_inward、fed_from_beyond、rising_fed_from_beyond、Web.generation_fed_from_beyond、Lone.fed、
       Lone.each_fuel_once、Lone.supply_not_source；WithinOwn、WithinJoint、joint_keeps、excess_lowers、excess_bounded、
       Pair、stays_below、ends_below、joint_excess_ends、Exceeding、Alone；Downstream、Mortal、Totalizer.careful；
       Standpoints（L4，导入 Descent 与 Continuation）：Valuation.Held、Valuation.Unheld、significant_iff_held、
       significant_iff_reached、Apart、Unclaimed、Relayed、Web.held_by_formations、Web.significant_iff_self；
       Flow.conveyance、conveyance_idle、boundary_crossed、Cut、region_not_a_cut、valuing_reaches_source、
       roles_conveyance、roles_conditions_unrelated；Totalizer.crossed、supply_not_cut、conveyance_only、own、
       valuation、center_not_derived
Supplied premises / correspondence: 平衡、耗散、被围住、不重复、可判定相等（W1、W2）；更新依存于所更新者的门控、Acting、
           Dependent（W3）；持有与可判定的持有，S0、N_std、N_rel 都是假设（W5）；输送作为 related（W2，Ren 的选择）；
           从想要一个目的到有理由求其所需的一步（W4）
Evidence: 合并检查器回执 20261009T222752.438253Z（1280 项定理、2062 项声明审计、核心闭包 31 个模块、包 29 个模块，全部源声明公理报告为空；
          Continuation 中 Lean 生成的 Totalizer.Place.fuel.injEq 依赖 propext，没有源声明使用它）；外围回执 20261009T223112.652163Z；实例检查
Boundary: 没有伦理公理；G0 仍是所采用的公理，重述待 Ren 接受；持有、输送与“想要即 S0”是对应前提或读法；见证是最小的；
          与外围磨损定律的联系是诠释性的；名称由 Ren 定
Integration: 延续奠基计划 W1–W5；Ren 提议的两半；chapter §6.7；G0 刻画（§6.1）保持其范围
```

| 声明 | 内容 |
|---|---|
| `Flow.Conveys`、`Flow.FedFromBeyond` | 参与的形成从 c 取用、向 d 给予，即有东西从 c 输送到 d；有东西从家族之外输送入某个成员，即家族从其外得到供给 |
| `Flow.inward_iff_not_fed` | 相等可判定时，从其外得到供给恰是该步不内向（`not_inward_of_fed` 不需要可判定） |
| `Flow.fed_from_beyond`、`Flow.rising_fed_from_beyond`、`Web.generation_fed_from_beyond` | 平衡与耗散之下，取用复现、成员上升复现或体现成员生起复现的有限家族，从某步起被围住时，不能从某步起都没有东西从其外输送入 |
| `Lone.supply_not_source` | 池每步都从其外得到供给，每份燃料只在它自己的那一步被输送出：必要的是得到供给，不必有哪个来源条件复现（输送的始终是同一个太阳） |
| `Flow.WithinOwn`、`Flow.WithinJoint`、`Pair.own_not_joint` | 各自在所给之内，合起来可以超出 |
| `Flow.joint_keeps`、`Flow.excess_lowers`、`Flow.excess_bounded`、`Pair.no_web` | 联合地在所给之内时水平不降；联合超出每步至少降一，连续 n 步需要起点至少 n；Pair 没有平衡的网 |
| `Flow.stays_below`、`Flow.ends_below`、`Flow.joint_excess_ends` | 更新者以至少 m 的需要依存于所更新者、只有活跃者给予、活动需要支持时，水平一旦低于 m 就一直低于 m，以至少 m 的需要依存者从此不活跃；联合超出使水平低于 m 时，终结更新者与以这样的需要依存的每个形成，取用者以这样的需要依存时也在内 |
| `Exceeding.all_end`、`Alone.all_continue` | 一个更新者与两个各在所给之内的取用者，两步后都终结；只有一个取用者时都延续 |
| `Downstream.one_way` | 推出的范围单向：自身只依存于它的地，每步活跃且被支持；以它所给为生的下游形成在它停止给予后终结 |
| `Mortal.after_its_end`、`Mortal.without_continues` | 想要的视界：生命两步、活着时每项依存都被满足的形成，终结了共享条件的更新，继承者在它终结之后才终结；没有它时其余延续 |
| `Totalizer.careful` | 谨慎的照管者：平衡、耗散、`Dependent`；照管者每步活跃且被支持，只依存于它的供给，供给被更新、每步从其外得到供给、被联合地在所给之内取用；它在第一步的事件侵蚀另一个形成，后者从第二步起不活跃 |
| `Valuation.Held`、`Valuation.significant_iff_held` | 每个活的主张都在某个立场的自身区域中时，G0 恰等于每个立场的 S0 加 N_std，不用连通与 N_rel |
| `Valuation.significant_iff_reached` | 持有可判定、每个活的主张都经已形成的关系从被持有的活的主张到达时，G0 恰等于处处 S0、N_std 与只指向无人持有者的 N_rel |
| `Apart`、`Unclaimed`、`Relayed` | 三个反模型：每个生命只被自己的立场珍视，两种中立都不成立（W8 后为 `Apart.not_enough`，原名 `standpoint_neutrality_is_needed`）；无人持有的生命；被到达而无人持有的生命 |
| `Web.held_by_formations`、`Web.significant_iff_self` | 逐步读、每个形成以自身事件为自身区域时，每个活的事件都被持有，G0 恰等于每个形成的 S0 加 N_std |
| `Flow.conveyance`、`Flow.conveyance_idle` | 以一类关系项读，输送使同一步的两个事件相关；闲置的关系项与任何事件都不相关 |
| `Flow.boundary_crossed`、`Flow.Cut`、`Flow.region_not_a_cut`、`Flow.valuing_reaches_source` | 延续家族的边界不会从某步起再无穿越，所以它的区域不是关系的切口；在 N_rel 下珍视一个关系项的事件，到达向它输送者的活的事件 |
| `Flow.roles_conveyance`、`Flow.roles_conditions_unrelated`、`Totalizer.conveyance_only` | 两个条件之间的输送使它们相关，交互、以之为生与世系在任何步上都不使两个条件相关；照管者的燃料与供给只由输送相关 |
| `Totalizer.center_not_derived` | （W8 后）各形成持有并珍视自身的事件，照管者也珍视太阳的事件：每个生命都被持有，S0 处处成立，各立场的意义沿供给（`Flow.FedBy`）封闭，而另一个形成活的事件从照管者的立场没有意义：N_std 与 G0 不成立；同一评价中照管者的事件经栖息地与之相关，从照管者自身区域沿已形成关系的传递不成立。W1–W5 的原陈述（向各自区域的传递，由 S0 推出）见 §47.2 C1 |

**解读。**

- **两半由证明分开。** 范围的一半（`Becoming.Continuation`）不含伦理谓词：它说想要延续者必须计入什么才能延续——其外的供给、对其所依存者的联合取用——而不说它应当计入。中心的一半（`Becoming.Standpoints`）说：对被持有的生命，G0 超出 S0 的可以集中在 N_std 上（在连通、每个立场都持有活主张的整体上也可集中在 N_rel 上，§47.2 C2）；而沿依存推出的范围不迫使 N_std（`Totalizer.center_not_derived`）。所以“这不需要任何公理”对范围成立，对中心在这一读法下不成立。（W8 更正：原文接着说计划 §3.4 的检验通过了，“见证造出来了”；审查指出原见证的传递合取由 S0 推出，检验如原样提出不可能失败。这一说法撤回；现在的见证含沿依存的封闭，界线的范围见 §47.2 C1。）
- **与原刻画。** `significant_iff`（§6.1）从一个种子出发，需要连通与 N_rel 把意义带到各处，§6.3 的大部分工作在保证连通。新的刻画在每个想要的点都有种子，在每个生命都被持有时只需 N_std 使它们共同；连通与 N_rel 在这一补全中只对无人持有的生命仍有作用，而在连通、每个立场都持有活主张的整体上，它们给出另一种补全（`significant_of_transmits`，W8）。在连通、有活的主张且每个生命都被持有的整体上，二者都等价于 G0；一般地互不蕴涵，原刻画保持其范围。对手的形状（§6.2）不变：主要的对手接受处处 S0，把意义限在各自的立场之内（`Apart`）。
- **范围以供给的形式到达其外。** 从其外得到供给是必要的，不必有哪个来源条件复现（`Lone`；输送的始终是同一个太阳，所以原文“特定的来源不是”多于它所示，W8 C3）；照管者的燃料每步不同。想要把他者计入为条件；主张层面的意义分不开把他者算作条件与算作想要者（W8 C2）；在 N_rel 下，以输送为关系时，珍视自身的事件到达来源的活的事件（`valuing_reaches_source`），但那是公理的关系一半，不是想要所要求的。
- **联合超出。** 元吸引子所选出的形成各自只计自身的取用；它们可以各在所给之内而合起来超出，联合超出持续不过原有的。更新依存于所更新者时（更新者的给予要求它自己被支持），联合超出终结更新与以这样的需要依存者，取用者以这样的需要依存时也在内；联合计入约束的是比条件所存更长远的想要（`Mortal`，W8 C6）。外部来源（太阳）的更新不受门控，这一结论不适用于它。与外围磨损定律（`jointly_exceeding_parts_end_shared_formation`）的联系是诠释性的，没有实例定理。
- **草图的改名。** 计划中的草图（`development/continuation-grounding-sketch/`）的三个反模型改名为 `Apart`（原 `OwnStandpoints`）、`Unclaimed`（原 `Unheld`，避免与 `Valuation.Unheld` 重名）与 `Relayed`（原 `Reached`）；其余声明保持草图中的名称。草图是计划的证据，保留原样。
- **弱式与强式。** 逐步读法的 `living`（活跃且不侵蚀）是弱式“不损”的一种读法；`Web.significant_iff_self` 在这一读法上给出“每个形成是自己的中心”。S0 只涉及活的主张，所以这样读时“不损”的过滤已在种子里（`Totalizer.keeper_not_living`，W8 C13）；Ren 的“as long as not harm”也可读作义务式：每个延续的意义是对他者不施损害的要求（W8 C12）。强式（整体的延续要创造更多意义）读作方向，联系 `Flow.More` 与 `World.ArisingRecurs`，本节没有新的形式内容。

**作者反审。**

*反驳 1：处处 S0 加 N_std 只是 G0 换个说法。* “G0 ⇒ 前提”的方向是平凡的；内容在反方向与极小性：对被持有的生命，连通与 N_rel 都不需要。这使论证的重心移动：§6.3 中保证连通的读法与纪律，对被持有的生命不再是 G0 的前提。

*反驳 2：持有把结论放进了前提。* 持有是对应前提，不是伦理前提：它说哪些生命在某个立场的自身区域中。在持有之下，结论还需要 N_std；`Apart` 说明两种中立都没有时，每个生命都被持有、处处 S0，而 G0 不成立。所以持有定位了中立的作用，没有替代它；在被持有的生命上 N_std 足够，但不是唯一的补全（W8 C2）。

*反驳 3：谨慎的照管者是人为的。* 定理是存在性的：推出的要求不迫使 N_std。更自然的见证不会改变这一点；若要推翻它，需要证明某个推出的要求蕴含 N_std，那将是更强、会改变论述的结果。（W8 更正：原见证没有含推出的要求，在评价层面它与 `Apart` 相同；现在的见证含沿依存的封闭。沿每个已形成关系读推出的范围时，界线不成立，见 §47.2 C1、C2。）

*反驳 4：输送使一切供给链连通，太廉价。* 输送需要实际的取用与给予；闲置的关系项不相关（`conveyance_idle`）。它确实比交互、以之为生与世系连通更多（`roles_conditions_unrelated`），所以是否采用它是实质的选择，属于 Ren。

*反驳 5：联合超出终结取用者自己，所以自利足以保护共享条件。* 只保护到自身所依存的程度：`Downstream` 中依存于自身的下游不在范围内，`Totalizer` 中照管者不依存的栖息地不在范围内，`Mortal` 中即使所依存的也只到想要的视界为止。

*反驳 6：“不需要任何公理”不成立，因为用了平衡、耗散与被围住。* 读作不需要伦理公理（[来源记录](../../../../sources/15-codex-theory-conversations/2026-10-10-wanting-continuation-one-axiom.md)的解释）：物理、对应与表示的前提仍是公开的前提，各有满足与不满足它们的世界。

*反驳 7：门控的联合超出与外围的磨损定律没有实例定理。* 对。记录把这一联系列为诠释性的，下一步是实例定理。

**边界。** 范围的一半没有伦理谓词；中心的一半不证明 S0、N_std 或 N_rel，不约束拒绝它们的立场，不推出义务、排序、认识或遵循。G0 仍是所采用的公理；重述、“想要即 S0”、公理的范围（想要者还是一切；无人持有的生命）、伤害的层级、“更多”的读法、输送是否算已形成的关系与名称（Conveys、FedFromBeyond、WithinOwn、WithinJoint、Held、Unheld、Apart、Unclaimed、Relayed、Cut、Exceeding、Alone、Downstream、Mortal、Totalizer、keeper 等）都由 Ren 定。见证是最小的。本节已经独立审查，更正见 §47.1–47.4。

### 47.1 独立审查与更正（W8）

2026-10-10。按计划 W8，另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 W1–W5（[审查](CONTINUATION-GROUNDING-REVIEW.md)，对象 `1f6f375f`）。它对照回执 20261009T222752.438253Z 的源哈希重新编译探针，所有探针声明都不依赖公理。它判定 Lean 正确、无公理，一般定理说的与说明一致；G0 处处保持为所采用的公理，Ren 的选择都已列出。问题在诠释一层：共十三项，C1–C6 实质，C7–C13 次要，没有阻断项。探针以 `1f6f375f` 的字节重新编译，12 条公理报告全空，保存在 [development/continuation-grounding-review-probes/](../history/root-foundation/development/continuation-grounding-review-probes/)。

```text
Result(s): 更正 derived-extent-limits（C1、C3、C7、C10、C11、C13）、held-lives-g0-is-centering（C2、C4、C5、C10、C11）、
           continuing-self-fed-from-beyond（C3、C9、C10）、own-count-misses-joint-excess（C6、C7）、
           conveyance-crosses-the-boundary（C8、C9）；没有新的成果记录
Delta: Standpoints：Valuation.own_transmission、Valuation.significant_of_transmits；Apart.standpoint_neutrality_is_needed 改名为
       Apart.not_enough，并加上 N_rel 不成立；Flow.FedBy；Totalizer.supply_not_cut_living_on、Totalizer.sig、Totalizer.fedBy_sun、
       Totalizer.keeper_not_living；Totalizer.valuation 改为照管者也珍视太阳的事件；Totalizer.center_not_derived 改为含沿供给的
       封闭、照管者的事件与另一形成的事件相关、从自身区域沿已形成关系的传递不成立；模块说明（标题改为“谁的延续计入”）。
       Continuation：模块说明与 Exceeding.all_end 的说明。根模块、README、check_becoming 的范围说明
Supplied premises / correspondence: 不变；FedBy 是依存的一步读法（在同一步参与并向所需条件给予），是对应的选择
Evidence: 合并检查器回执 20261009T231934.987085Z（1285 项定理／2069 项声明审计，核心闭包 31 个模块，包 29 个模块，源声明的公理报告全空；
          Continuation 中 Lean 生成的 Totalizer.Place.fuel.injEq 依赖 propext，没有源声明使用它）；外围回执 20261010T073508.393062Z（桥接 7 项定理，公理报告
          为空；此前两次尝试在机器内存压力下未完成，不作证据）；审查探针的重跑（不属于包）
Boundary: 不含伦理结论；不替 Ren 选择任何读法；“中心不由推出”限于沿依存推出的范围；新名称是建议
Integration: §47 与英文 W1–W5 的就地更正；章节 §6.7、前提卡、第 6 与第 10 项、§8–§10；计划 §0、§2–§4、§9 与实现状况；统一计划一行
```

### 47.2 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| C1 | `center_not_derived` 的传递合取（意义传入各自区域）在任何评价中都由 S0 推出，所以评价层面的内容与 `Apart` 相同。Flow 与 Web 的谓词从不约束 sig，计划 §9 的检验如原样提出不可能失败 | 一般定理 `Valuation.own_transmission` 写明这一点。新增 `Flow.FedBy`；`Totalizer.valuation` 改为各形成珍视自身的事件、照管者也珍视太阳的事件；`center_not_derived` 改为：持有、处处 S0、各立场的意义沿供给封闭（从任何被珍视的事件出发，不只从自身区域）、另一形成活着而照管者不珍视、N_std 与 G0 不成立，并加上照管者的事件与另一形成的事件经栖息地相关、从自身区域沿已形成关系的传递不成立（审查的 `Tot.stronger` 与 `out_of_own_fails`）。界线写为：对沿依存推出的范围成立，对沿每个已形成关系推出的范围不成立。“见证造出来了”作为检验通过的说法撤回（§47 解读、记录、计划 §9）；“每项推出要求”改为“此处推出的每项要求”。原陈述在回执 20261009T222752.438253Z 中检查过，记录历史写明改变 |
| C2 | N_std 不是唯一的补全：连通、每个位置都持有活主张时，S0 加 N_rel 给出 G0；`Apart` 连通，N_rel 也不成立，所以它只说明持有与 S0 不够；主张层面的 sig 分不开工具性与最终的意义 | 新增 `Valuation.significant_of_transmits`；`Apart` 的定理改名 `not_enough` 并加上 N_rel 不成立；“中心不由推出”加上范围（沿依存，并且某个活主张在某个想要者的依存闭包之外）；写明选 N_std 是因为它不需要连通，并写明 sig 的局限（章节、模块、记录、计划）。把关系读作依存时，N_rel 正是“计入自身延续所依存的”的评价形式；这一读法对一般定理的应用是手写论证，没有另立定理 |
| C3 | `Lone` 只说明不必有来源条件复现，每次输送都是同一个太阳，而 `Lone.web.requires` 处处为假；中英文不一致 | 统一为“必要的是得到供给，不必有哪个来源条件复现”，并写明输送的始终是同一个太阳；derived-extent-limits 的第二个界限去掉“以供给的形式”；两个可移除来源交替供给的见证列为开放（章节 §8、记录 next_delta） |
| C4 | 若干处把 AI 的分解（S0 即想要，N_std 是唯一公理）归于 Ren | 模块说明、根模块、README、章节前提卡、术语表、第 10 项与计划 §0 都改为“AI 对 Ren 提议的读法，待 Ren” |
| C5 | “每一点都是中心”被注为 N_std，而放置中心的是 S0；N_std 是去中心化 | N_std 注为“从任一中心有意义的，从每个立场都有意义，没有哪个中心特殊”；“每个想要之点都是中心”归于 S0，并注明是 Ren 答“exactly”的 AI 说法；模块标题改为“谁的延续计入”；章节的草案就地改正 |
| C6 | 联合计入只约束比条件所存更长远的想要；“取用者在内”只对以这样的需要依存的取用者成立 | 两处限定写入模块说明、根模块、README、章节、记录与计划 §3.3 |
| C7 | 见证中的终结由定义规定 | 模块说明与 `all_end` 的说明改为：终结由活动规定，见证表明它们与平衡、支持和依存相容，终结的推出在一般定理中。强制形式（对 active 量化）没有加，列为开放 |
| C8 | “先前读法不穿越”言过：以之为生下供给的区域也不是切口 | 新增 `Totalizer.supply_not_cut_living_on`；说法改为：先前读法不使两个条件相关，输送新增的是两个条件之间、沿流入方向的关系 |
| C9 | 中文“传入”同时指输送与 N_rel 的传递 | 输送一律用“输送到／输送入／输送出”；“传递”只指 N_rel |
| C10 | 较小的言过与中英不一致五处 | 记录标题改为“G0 是 S0 加立场中立”；“都等价于 G0”加“有活的主张”；“不加前提”改为“只加可判定相等”；derived-extent-limits 的中文与英文对齐；`Lone` 的引用补 `Lone.lone` |
| C11 | `center_not_derived` 被两项记录认领，依赖方向反了 | 声明只归 derived-extent-limits，它对 held-lives-g0-is-centering 的 formal-reuse 改为复用 `Web.held_by_formations`；held-lives 不再列 `Totalizer` 的声明，对 own-count-misses-joint-excess 的依存去掉 |
| C12 | 章节引文删去 Ren 的中间一段而没有省略号；弱式的另一读法未列入 Ren 的选择 | 章节改为引 Ren 的全文（只略去重复助手的第一行，并注明）；弱式加上义务式的读法（每个延续的意义是对他者不施损害的要求），列入 Ren 的选择；它尚未形式化 |
| C13 | S0 只涉及 `living` 主张，已含“不损”的过滤；照管者的清除不服务任何东西；“被更新”依赖规定的太阳 | 新增 `Totalizer.keeper_not_living`；在模块说明、前提卡与记录中写明“S0 即想要”的读法含规范性的过滤，太阳什么都不需要是规定的。终结他者服务于照管者延续的见证（元吸引子的更强情形）列为开放 |

### 47.3 新的已检查声明

| 声明 | 内容 |
|---|---|
| `Valuation.own_transmission` | 处处 S0 时，每个立场的意义沿任何关系进入其自身区域：向自身区域的传递不比 S0 多 |
| `Valuation.significant_of_transmits` | 连通、每个立场都持有某个活主张时，处处 S0 加 N_rel 给出 G0（主张层面），不用 N_std |
| `Apart.not_enough` | 每个生命都被持有、只被自己的立场珍视：处处 S0，N_std、N_rel 与 G0 都不成立 |
| `Flow.FedBy` | 在同一步上，后一事件的形成参与并向前一事件的形成所需的条件给予 |
| `Totalizer.supply_not_cut_living_on` | 以之为生之下，以一类关系项读，供给的区域也不是切口：照管者以之为生 |
| `Totalizer.sig`、`Totalizer.valuation`、`Totalizer.fedBy_sun` | 各形成珍视自身的事件，照管者也珍视太阳的事件；只有照管者的延续被供给，且只被太阳供给 |
| `Totalizer.keeper_not_living` | 照管者在第一步的自身事件活跃而不活，S0 对它无所说 |
| `Totalizer.center_not_derived`（改） | 持有、处处 S0、各立场的意义沿供给封闭；另一形成在第零步活着而照管者不珍视；N_std 与 G0 不成立；照管者在第零步的事件与它相关，从自身区域沿已形成关系的传递不成立 |

### 47.4 作者反审

*反驳 1：沿供给封闭只是又一个由定义成立的合取。* 不是：它约束 sig。照管者若只珍视自身的事件，封闭就不成立，因为太阳供给它；审查的 `Tot.stronger` 正是为此而造。它说的是：照管者计入其延续所依存者（太阳的给予），仍不计入另一个形成。界线是否成立，取决于推出的范围沿依存还是沿每个已形成的关系；同一见证给出两边。

*反驳 2：既然 S0 加 N_rel 在连通的整体中也给出 G0，中心其实可以由动力学推出。* 只在依存使每两个生命都相连、每个立场都持有活的主张的整体中，并且要把 N_rel 本身读作想要的要求。N_rel 是规范前提：从“我的延续依存于它”到“它的活的事件对我有意义”是从想要一个目的到有理由求其所需的那一步（公开的前提），而它给出的是工具性的意义，主张层面的 sig 不区分工具性与最终的意义。所以这是第二种补全，不是从动力学推出中心；它在什么整体中成立是有用的判别，留给 Ren 的读法。

*反驳 3：太阳什么都不需要，使见证过于廉价。* 这是规定的，已写明。去掉这一规定、让太阳依存于燃料，只会让照管者的依存闭包包含更多条件，不会让它包含另一个形成的栖息地，因为照管者的延续不需要那个栖息地。更强的见证（终结他者服务于照管者的延续）列为开放。

*反驳 4：改名 `Apart` 的定理并改写 `center_not_derived`，掩盖了原来的说法。* 两者的原陈述都在回执 20261009T222752.438253Z 中检查过，记录历史与本节写明了改变；原陈述仍然为真，错误在诠释上，即把它们当作“需要 N_std”与“检验通过”的证据。

**边界。** 无伦理谓词；Ren 的选择保持开放，新增两项：推出的范围沿依存还是沿每个已形成的关系，以及“不损”是过滤还是对他者的要求；本节的新名称是 AI 的表述，由 Ren 定。

## 48. 第十三次独立审查与更正（P34b）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P32（§43）、P33（§44）、P33b（§45）与 P34（§46），以及 P35/P36 的两份草稿（[审查](../history/root-foundation/BECOMING-P32-P34-REVIEW.md)，对象 `7f69f455` 与草稿 `D35.lean`、`D36.lean`）。它在仓库之外从前导重新编译核心闭包的 29 个模块，2028 条源声明（1263 项定理）的公理报告全空；闭包的 5650 个常量中依赖公理的只有 37 条编译器生成的 `injEq` 引理，都只依赖 `propext`，与回执所列相同；四个提交的回执、源哈希、保留产物与外围回执，1590 个引用哈希与 459 个证明绑定都对，各阶段的计数与章节一致。数学全部接受，没有错误的 Lean 陈述；两份草稿的定理也都对，其 70 条声明不依赖公理。它写了 42 条探针声明（34 项定理）与 8 个 `example`，生成的 78 个常量都不依赖公理；提出九项（U1–U9）：一项过强（U1，P34 的标题），一项出处错误（U2），一项说明与缺少的反例（U3），草稿的三项（U4–U6），P34 的说明（U7），中英对应（U8）与记账（U9）。另一会话的 W1–W5（`1f6f375f`）在审查期间提交，不在对象之内。本节逐项处理，把审查的探针移入核心；草稿按 U4–U6 重构，作为 P35 提交（§49）。草稿、探针与审计输出保存为[审查证据](../history/root-foundation/development/becoming-p32-p34-review-probes/README.md)，不是登记的成果。成果记录：修订 [whole-law-of-counting](../../../../theories/becoming/results/records/whole-law-of-counting.md)、[census-balance-under-continuation](../../../../theories/becoming/results/records/census-balance-under-continuation.md)、[identity-across-steps](../../../../theories/becoming/results/records/identity-across-steps.md)；引用移动了的引理的记录随之更新声明的位置。

```text
Result(s): 更正 whole-law-of-counting（U1–U3、U7、U9）、census-balance-under-continuation（U2）、identity-across-steps（U8）；
           没有新的成果记录（P35 的记录见 §49）
Delta: Dependence：开头新增“算术”一节：le_dest（自 Change）、le_of_add_le_add_right 与 add_right_cancel（自 Horizon）、
       add_sub_turn、add_sub_of_le。Flow：le_total_of_mem（自 Dissipation）。Population：Balance、Tally.balance、
       Tally.ceasing_le、tally_iff、balance_not_tally、Tally.congr、tally_iff_counted；节标题与说明改为“计数表是计数的全部规律”。
       Premises：World.tended_not_binds、World.binds_arising、World.binds_adds；tendedQueue_premised 与 premised_counting 的说明。
       Identity：“步后列出的多于步前”。登记：形如 Lean 名称的别名须在所绑定回执列出的声明中
Supplied premises / correspondence: 不变
Evidence: 合并检查器回执 20261010T075031.720357Z（与 §49 同一次检查）；外围桥接重跑 20261010T075308.552033Z；实例检查；make research-test
Boundary: 不含伦理结论；不替 Ren 选择任何读法；新名称是建议
Integration: §46 与英文 P34 的就地更正；章节第 3、4 条、状态表、进一步的证明、§9 与术语表；README 与根模块的说明
```

### 48.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| U1 | P34 的标题“平衡是计数的全部规律”过强：仓库中普查的平衡指 `Listed.across` 的等式，P34 证明的计数表严格强于它；每个列出都满足“跨一步不再成立的不多于步前所列的”，等式不给出它（审查的 `tally_iff`、`balance_not_tally`、`ceasing_bound_law`） | 移入核心：`Balance`（等式）、`Tally.balance`、`Tally.ceasing_le`、`tally_iff`（计数表恰是平衡加上这一界）与 `balance_not_tally`（Population）。各处改为“计数表是计数的全部规律”：章节第 4 条、状态表、进一步的证明、§9 的 Population 一行与术语表，记录的标题与断言，§46 与英文 P34 段落（就地更正并注明），README，根模块，Population 的模块说明、节标题与 `counting_laws` 的说明。复现定律只用等式，不变。提交标题与历史保留原样 |
| U2 | whole-law-of-counting 与 census-balance-under-continuation 的对应说活动的计数“不是 Ren 提议中的‘生成的’‘退化的’”；名称经 Ren 确认，所指没有；第十次审查 O8 之后其余各处都把这一问题留给 Ren | 两份记录都改为 census-balance 的标准句：引 Ren 的反问句，若取不重叠则不是其所指，并标明这是 AI 的推论；加历史 |
| U3 | `tendedQueue_premised` 的说明说耗散“只在什么都不交换处起约束”；按 `World.Binds`，队首照管的队列中耗散从不起约束，活动需要支持与有界传递也不起约束；“八个前提所加的只有这一条”的范围包括前提空成立的世界 | 说明改正；移入核心：`World.tended_not_binds`（三者在其中空成立，所以不是每个前提都起约束；审查的探针加上有界传递）、`World.binds_arising`（每个前提都起约束时，每个普查都计到某个生起）与 `World.binds_adds`（八个前提之下这不是规律）。章节第 3 条、Premises 的模块说明、§46 与记录的局限写明 |
| U4 | 草稿的两条规律是一条：从某步起的结算就是从第 0 步起的结算（审查的 `settles_zero`、`same_laws`）；`Closing` 的 T、T 之前与地的交换、`spare` 中的条件与 `early` 的情形都不需要 | 规律只陈述一次，以从第 0 步起的变化界（`∃ B, ChangeBound 0 B n c a`）；`ChangeBound.from_zero`、`changeBound_iff_zero` 与 `World.enclosed_iff_finite_counting` 移入核心；实现的世界去掉 T、地关系项与 T 之前的交换，关系项是自然数（`EnclosedQueue`、`World.enclosedQueue`）；T 只留在定量的 `World.enclosure_bounds_change` 中。见 §49 |
| U5 | 草稿说变化“不复现”，是对的；更强的形式（有一步之后不再变化）蕴含 LPO，对计数与满足八个前提的有限世界都如此（审查的 `lpo_of_settlesEnds`、`lpo_of_finiteEnds`） | 移入核心：`Swap`（在布尔序列的第一个真处替换一个成员）、`ChangeBound.lpo_of_ends` 与 `World.lpo_of_finite_ends`。正文说“不复现”“在变化界之内”，不说“停止” |
| U6 | 算术引理分散在 Horizon、Joint、Change、RelationalRenewal 与草稿中；草稿的 `le_sub_of_add_le` 与 `fin_eq` 重复已有的；`since`、`below` 太一般，`Settles` 读作“在某步归于静止”，`Closing` 与 `Closed` 近乎同名 | 自然数的算术集中在 Dependence 开头的一节（Change、Population 与 Horizon 都在其上）：`le_dest`、`le_of_add_le_add_right`、`add_right_cancel` 移入，`add_sub_turn` 与 `add_sub_of_le` 新增，都没有公理；`le_total_of_mem` 从 Dissipation 移入 Flow 的总量一节；复用 `RelationalRenewal.le_sub_from_add` 与 `Fin.eq_of_val_eq`。名称改为 `occurrences`、`ChangeBound`、`placesBelow`、`EnclosedQueue`、`FiniteQueue`，按 Ren 2026-10-10 的命名准则选定（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）。`Tended.decideEq` 不再需要 |
| U7 | `Pointwise` 是公平的假设，也可以不用；§46 说“经典地每个性质都如此”不对；§46 与英文段落给出的保持形式的理由（避免带 `propext` 的消去律）不成立 | 移入核心：`Tally.congr` 与 `tally_iff_counted`（列出所能有的计数恰是计数表，不用 `Pointwise`）；§46 改为“有函数外延性时”，理由改为 U1 的 |
| U8 | 英文把 `forced_iff_more` 说成“步后立着的更多”；“立着”是理论的术语（水平为正），这里比的是列表的长短 | 改为 “more formations are listed after the step than before”：Identity 的两处说明、检查器的范围说明、identity-across-steps 的英文、研究与计划的英文 |
| U9 | 草稿落地时须更新的开放项；登记不检查别名 | 开放项随 P35 更新：章节进一步的证明、记录的局限与下一步、§46 的边界与反驳 2、5、英文 P34 段落。登记新增检查：形如 Lean 名称、命名空间在所绑定回执中的别名，须在那些回执列出的声明中（`tools/research/registry.py`，加测试）；现有的这样的别名全部通过 |

### 48.2 新的已检查声明

| 声明 | 内容 |
|---|---|
| `Balance`、`Tally.balance`、`Tally.ceasing_le` | 平衡的等式；计数表满足它，且跨一步不再成立的不多于步前所列的 |
| `tally_iff`、`balance_not_tally` | 计数表恰是平衡加上这一界；零个在列、每步一个不再成立一个开始成立满足平衡而不是计数表 |
| `Tally.congr`、`tally_iff_counted` | 计数表尊重每步的值；列出所能有的计数恰是计数表 |
| `World.tended_not_binds` | 队首照管的队列中耗散、活动需要支持与有界传递空成立，不是每个前提都起约束 |
| `World.binds_arising`、`World.binds_adds` | 每个前提都起约束的世界中每个普查都计到某个生起；八个前提之下这不是计数的规律 |
| `le_dest`、`le_of_add_le_add_right`、`add_right_cancel`、`add_sub_turn`、`add_sub_of_le` | Dependence 开头的算术，公理报告为空（前导中的对应引理带 `propext`） |

### 48.3 作者反审

*反驳 1：把标题改成“计数表”只是换词。* 不是：两种说法的数学内容不同。“平衡是全部规律”按仓库里平衡的意思是假的（`balance_not_tally`）；“计数表是全部规律”是 P34 证明的。差别恰是一条规律：跨一步不再成立的不多于步前所列的。复现定律只用等式，所以仍然对。

*反驳 2：`tended_not_binds` 使 `premised_counting` 失去意义。* 不：它是对满足八个前提的全部世界的刻画，前提空成立的世界也在其中；`binds_adds` 说明，只取每个前提都起约束的世界，规律会更多（至少有一个生起）。两种范围回答不同的问题；后者的全部规律本节没有陈述。

*反驳 3：把算术引理移到 Dependence 打乱了模块的主题。* 这些引理是核心各层共用的自然数事实；Dependence 在 Change、Population 与 Horizon 的导入链上都在其下，Frame、Inquiry 与 Renewal 不需要它们。集中一处避免了重复；名称不变，只是位置变了，引用它们的记录随之更新声明的位置。

**边界。** 无伦理谓词；Ren 的选择保持开放；本节的新名称是 AI 按 Ren 的命名准则（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）所选。本节尚未经独立审查。

## 49. 被围住时与有限世界中计数的规律（P35）

2026-10-10。按 Ren“aim a complete theory of becoming, and finish related work”继续，作为计划 P35。P34 给出了计数的全部规律与全部八个前提之下的规律，把有限世界中与被围住时的计数规律列为下一步（§46 的边界、反驳 2 与 5）。静止定理（P26）说被围住时生起与止息都不再复现，但没有说计数还剩多少自由。本节回答：被围住为变化定下界；八个前提之下，从某步起每步被围住时与有限世界中计数的规律相同，恰是计数表、没有关系项活跃的一步上没有生起与从第 0 步起的变化界。两份草稿经第十三次审查后按 U4–U6 重构（§48）。成果记录：新增 [counting-under-enclosure](../../../../theories/becoming/results/records/counting-under-enclosure.md)。

```text
Result(s): 复用 whole-law-of-counting（Tally、Queue、Pointwise、World.CountsObey、counting_binds_jointly、Tended.front、
           Tended.occupied）、continued-change-needs-openness（Flow.standing_never_rises、Flow.change_lowers、standingCensus、
           aroundStanding_not_not、World.Finite.enclosed）、ceasing-needs-arising（rises_of_arises、falls_of_ceases）、
           map-of-premises（World.Premised.of、World.Binds）、no-finite-part-bears-taking（Flow.ClosedAt、Flow.Dissipative、
           total_le_of_support）；新增 counting-under-enclosure
Delta: Population：Queue.reached、occurrences（_before、_succ、_mono、_le、_zero_le）、falls_by_occurrences、ChangeBound（not_recurring、
       from_zero、joins、reach）、changeBound_iff_zero、Swap、ChangeBound.lpo_of_ends。Openness：World.length_le_stock、
       World.enclosure_bounds_change、EnclosedQueue（store、place、level、web、flow、span 与其引理）、World.enclosedQueue 与其前提、
       World.enclosed_counting、placesBelow、FiniteQueue、World.finiteQueue 与其前提、World.finite_counting、
       World.enclosed_iff_finite_counting、World.replaced、World.finite_dissipation_binds、World.replaced_attains、
       World.lpo_of_finite_ends
Supplied premises / correspondence: 同 P34：列出与可判定，逐点；被围住与有限是世界的条件，不是公理
Evidence: 合并检查器回执 20261010T075031.720357Z（1356 项定理、2161 项声明审计、核心闭包 31 个模块、包 29 个模块，全部源声明公理报告为空）；
          外围桥接重跑 20261010T075308.552033Z；实例检查
Boundary: 只说活动的计数；变化界以被围住时所立者的总水平为界，是可以达到的界，不是每个世界的值；每个前提都起约束时的全部规律没有陈述；
          不评价生起、止息或静止；名称由 Ren 定
Integration: 计划 P35；关闭 whole-law-of-counting 的下一步“有限世界中与被围住时计数的规律”；静止定理的定量形式
```

| 声明 | 内容 |
|---|---|
| `occurrences`、`ChangeBound` | 自第 T 步以来某量为正的步数；从第 T 步起，列出的数目连同自 T 以来有不再成立或开始成立的步不多于 B |
| `ChangeBound.not_recurring` | 变化界之内变化不复现 |
| `ChangeBound.from_zero`、`changeBound_iff_zero` | 从第 T 步起的变化界是从第 0 步起的变化界，大出 T 与 T 之前的计数 |
| `Queue.reached`、`ChangeBound.joins`、`ChangeBound.reach` | 离开的连同在队中的是起初的连同此后加入的；从第 0 步起在变化界 B 之内的计数表，其队列从不超过第 B + B·B 个成员 |
| `Swap`、`ChangeBound.lpo_of_ends` | 在布尔序列的第一个真处替换一个成员，变化界为二；若每个从第 0 步起在变化界之内的计数表都有一步之后不再变化，LPO 成立 |
| `World.enclosure_bounds_change` | 有普查、关系项都体现、平衡且耗散的世界中，从第 T 步起每步被围住时，计数从 T 起在第 T 步所立者的总水平之内 |
| `EnclosedQueue`、`World.enclosedQueue`、`World.enclosedQueue_premised`、`World.enclosedQueue_enclosed` | 被围住的队列：成员恰在队中时立着、活跃，队首立着变化界超出成员数的部分，队首只在队内交换，每有成员加入或离开的一步所立者下降一；每步都被围住，从第 0 步起在变化界之内且没有成员加入空队时满足全部八个前提 |
| `World.enclosed_counting` | 八个前提之下、从某步起每步被围住时，计数的规律恰是计数表、没有关系项活跃的一步上没有生起与从第 0 步起的变化界 |
| `placesBelow`、`FiniteQueue`、`World.finiteQueue`、`World.finiteQueue_premised` | 同一队列放在其成员曾占的有限多个位置上，是满足八个前提的有限世界 |
| `World.finite_counting`、`World.enclosed_iff_finite_counting` | 有限世界中计数的规律相同；所以从某步起被围住的世界与有限世界有相同的计数规律 |
| `World.replaced`、`World.finite_dissipation_binds`、`World.replaced_attains` | 第 0 步替换一个成员：队首从全部位置的封闭家族取用两个单位，耗散起约束；第 0 步所立者总共为二，此后一个成员连同一步变化恰为二，达到变化界 |
| `World.lpo_of_finite_ends` | 若每个满足八个前提、活动可判定的有限世界都有一步之后不再生起，LPO 成立 |

**解读。**

- **被围住定下变化界。** 静止定理只说变化不再复现。`enclosure_bounds_change` 说多少：被围住的步上所立者的总水平不升，每有生起或止息的一步至少降一（体现的关系项生起即开始立着，止息即不再立着，`Flow.change_lowers`）；活跃的关系项都体现、都立着，所以它们的数目不多于总水平。两者相加，此后任一步活跃者连同自被围住以来有变化的步，不多于被围住时的总水平。界数的是有变化的步，不是事件：同一步上可以有许多生起与止息。
- **变化界是全部。** 反过来，每个从第 0 步起在变化界之内、没有成员加入空队的计数表，都由一个满足八个前提、每步都被围住的世界实现：被围住的队列。它的所立者恰是队中的成员，每个立着一，队首另立着变化界超出成员数的部分；每有成员加入或离开的一步，所立者的总水平降一，队首取用的多于给予的，所以耗散成立；没有变化的步上什么都不动。
- **有限世界相同。** 有限世界的每一步都被围住（`World.Finite.enclosed`），所以它的计数在变化界之内；反过来，被围住的队列从不超过第 B + B·B 个成员（`ChangeBound.reach`），放在这些位置上它就是有限世界。所以在八个前提之下，有限世界、从某步起被围住的世界与每步都被围住的世界有相同的计数规律（`enclosed_iff_finite_counting`）。
- **不复现与终结之步。** 变化界之内变化不复现；但对每个这样的计数构造性地得到“有一步之后不再变化”是不行的：否则 LPO 成立（`ChangeBound.lpo_of_ends`、`World.lpo_of_finite_ends`）。这与 P33b 对网与列表的结果同类。
- **一元的读法（AI 论证）。** 变化界不是外加的限制：它就是被围住时所立者总水平的逐步耗散在计数上的样子。在被围住的展开中，每一次形成或消解都耗去关系中立着的一些东西；能不息地变化的是开放的展开（P25）。

**作者反审。**

*反驳 1：被围住的队列太特殊。* 同 §46 反驳 1：任何更多的规律都须在满足条件的所有世界中成立，包括这个队列；它不满足，那就不是规律。

*反驳 2：变化界的界不精确。* 对每个世界，界是被围住时所立者的总水平，并且可以用尽（`replaced_attains`）；但它是界，不是每个世界的值。规律说的是计数能是什么，不是某个世界的计数是什么。

*反驳 3：活动需要支持与有界传递在被围住的队列中空成立。* 是，与 P34 的见证相同；耗散在其中起约束（`finite_dissipation_binds`）。每个前提都起约束时的全部计数规律没有陈述；它至少多出一个生起（`World.binds_arising`）。

*反驳 4：“有限世界相同”抹去了有限的意义。* 在计数上，有限的意义正是一个变化界：数目与变化的步一起有界。从某步起被围住的世界在计数上无法与有限世界区分；区别在别处，例如这样的世界中曾经立着或活跃的不是无界多（`World.rest_few`），而不是有一个列表列出全部。

**边界。** 无伦理谓词，不评价生起、止息或静止；只对离散步与每步有限的活动陈述；变化界以被围住时所立者的总水平为界；水平与依存的计数在前提之下、每个前提都起约束时的全部计数规律没有陈述；名称（occurrences、ChangeBound、EnclosedQueue、enclosedQueue、FiniteQueue、finiteQueue、placesBelow、Swap、replaced）是 AI 按 Ren 的命名准则（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）所选：零公理部分取描述抽象动力学的形式词，草稿中的“预算”（budget）是金融的词，提交前改为“变化界”（`ChangeBound`）与“被围住的队列”（`EnclosedQueue`）。本节尚未经独立审查。

## 50. 见证改名（P36）

2026-10-10。Ren 指示：先求不用公理的最强陈述，作为第一部分；再加一条公理，作为第二部分。Ren 同时把名称交给 AI，标准有四条：
- 最精确的词；
- 零公理部分用描述抽象动力学的形式词；
- 偏好科学与系统的词；
- 社会与金融的词不作首选。

见[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)。P35 已按这些标准命名它新增的声明。本节把核心中其余见证的名称改为描述其动力学的名称，作为计划 P36（[计划 §10](../history/root-foundation/BECOMING-UNIFICATION-PLAN.md#10-第一部分与第二部分--part-i-and-part-ii)，对照表在那里）。

```text
Result(s): 不新增结果；改名所及的记录在其历史中注明
Delta: 只改名：见证、关系项、世界与以其命名的声明；陈述、证明与计数不变
Supplied premises / correspondence: 无新增
Evidence: 合并检查器回执 20261010T083222.285294Z（1356 项定理、2161 项声明审计，全部源声明公理报告为空）；外围回执 20261010T084107.973758Z
Boundary: 名称是 AI 按 Ren 的命名标准所选，读法仍由 Ren 选择；第二部分的词汇等第二部分的公理定下后再看；
          外围定律族与命名空间 Generative 保留原名
Integration: 计划 P36；其后 P36b（生成不译作 generative）、P37（区域）、P38（第一部分的总陈述与章节重组）
```

**原则。**

- **名称说所述的动力学。** 举例：
  - `Shuttle`：两侧来回传递一个单位；
  - `Throughput`：同一传递每步烧掉新燃料；
  - `Lossless`：取走又还回，什么都不损失；
  - `OpenQueue`：队首与无界的地交换的队列，与 P35 的 `EnclosedQueue` 相对；
  - `Renewable`：每步更新一个单位的条件，它的两次运行是在更新之内取用（`withinRenewal`）与超出更新取用（`beyondRenewal`）。
- **换掉社会、金融与诗化的词，保留科学的名称。**
  - 换掉的社会与金融的词：递交、花费、照管、公地、共享与取胜、陌生者、人群、总体化者、照管者、礼物、继承者。
  - 换掉的诗化的词：太阳、黎明、黄昏、引火、余烬、花园、开花。
  - 科学与生态学的名称保留：孵化、互利、捕食、世代、种子库、啃食、饥荒、级联、潮汐、更替、世系、接续、休眠等。
- **`Totalizer` 改为 `Clearing`。** `Totalizer` 来自 Ren 关于 totalizing 的说法，换成 `Clearing` 也合于旧规：形式部分不以 Ren 的用语命名。它的定理 `careful` 改为 `undermines_within_renewal`，名字说的就是它所陈述的：在更新之内取用自身资源的形成，仍侵蚀栖居者。
- **历史与证据保留原名。** §1–§49、旧回执、审查文件与探针都保留原名，因为它们记载的是那些回执检查时的状态。读它们时，按对照表从旧名读到新名。

**检查。** 改名后的核心先在暂存区编译，再由合并检查器重查（回执 20261010T083222.285294Z），外围桥接对这个核心重查（20261010T084107.973758Z）。定理与声明审计的数目与 P35 相同。本节尚未经独立审查。

## 51. 接下来能形成什么：接纳、部分与区域（P37）

2026-10-10。Ren 指示“let's aim for a first, then try to archive b”，并确认两项读法，见[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-axiom-route-levels-and-possibilities.md)：
- 可能性是从现有者接下来能形成什么；一个将来保留另一个所有的并有所增加时更多；一个形成的贡献是有它与无它的差；
- 整体从不是任何中心对它的模型；包含不许可强加的终结，许可它需要权衡的度量，那是另一个前提。

Ren 的确认是：“yes to both readings, go ahead with Part I.”。

此前 Ren 写道，生成的是“its existence creates more possibilities of becoming - more future, not less”，又写道“"not harm" - this is a phase transition with a clear boundary, not some "outside will or belief"”。Ren 还给出层级的次序：整体，较弱的是所在的系统，然后是自身。见[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-centers-within-the-dynamics.md)。

本节是计划 P37（[计划 §10](../history/root-foundation/BECOMING-UNIFICATION-PLAN.md#10-第一部分与第二部分--part-i-and-part-ii)），由本会话完成；分工经另一会话同意。它在核心中新增两个模块：
- `Becoming.Admission`，38 项定理；
- `Becoming.Regions`，18 项定理。

成果记录新增五项：
- [support-from-the-supported](../../../../theories/becoming/results/records/support-from-the-supported.md)
- [closing-needs-net-draw](../../../../theories/becoming/results/records/closing-needs-net-draw.md)
- [four-cases-of-a-part](../../../../theories/becoming/results/records/four-cases-of-a-part.md)
- [loss-beyond-a-region](../../../../theories/becoming/results/records/loss-beyond-a-region.md)
- [represented-boundary-against-dependence](../../../../theories/becoming/results/records/represented-boundary-against-dependence.md)

```text
Result(s): 复用 coming-and-ceasing-keep-pace（Web.supported_of）、rising-and-falling-in-one-exchange（Flow.Balances.rise_given）、
           more-needs-renewers（Flow.Balances、Flow.Acting、Web.Dependent、taken、given、total 的引理）、becoming-stepwise-reading
           （Web.RenewingAt、Kept、Participates、UnderminingAt、RenewingAt.not_undermining）、derived-extent-limits
           （Clearing、Clearing.undermines_within_renewal）、own-count-misses-joint-excess（excess_bounded、joint_excess_ends，
           作为已有的相界结果引用）；新增上列五项
Delta: Admission：GainsSupport、LosesSupport、Unloosened、Untightened 与 rises、falls；rise_given_by_supported、gains_from_supported、
       unsupported_stays、nothing_supported_stays；Restoring 的五个前提见证（Adapting、Inflow、Idle、Carried、Spontaneous）；
       Admits、Includes（refl、trans、not_exceeded）、Exceeds；withhold、partTaken、partGiven、WithheldLevels（unique）、
       Balances.withheld、supported_iff_within_margin、supported_of_net_give、admits_of_net_draw、closes_nothing、opens_nothing、
       changes_nothing；
       Inflow.withheld、Inflow.widens；Transfer（withheld、mixed）。Regions：AdmitsWithin、LosesBeyond、includes_iff_within_whole、
       narrow、not_losesBeyond_whole、not_losesBeyond、admitsWithin_self；RenewingOver、RenewingAt.over、RenewingOver.at、
       renewingAt_iff_over_all、RenewingOver.narrow、RenewingOver.keeps_own；Clearing.withheld、admitted_without、
       unsupported_with、narrows、loses_beyond、renewing_over_resource；Omitted.loses_own
Supplied premises / correspondence: 平衡、Acting、Dependent、要求不放松（吸收态）；部分是可判定的家族（part : F → Bool）；
       比较保持其余交换不变；离散的步与自然数的量；读法的对应是 AI 的，待 Ren
Evidence: 合并检查器回执 20261010T100351.523624Z（1412 项定理、2251 项声明审计、核心闭包 33 个模块、包 31 个模块，全部源声明
          公理报告为空，没有新的生成常量依赖公理）；外围回执 20261010T100610.366844Z
Boundary: 比较的是被接纳的形成，不比较更新能力与关系的丰富；只看接下来的一步；其余交换不随之调整；扣留后没有平衡的水平时
          无可比较（每个见证都给出扣留后的水平）；混合的部分不为包含定序；区域是陈述的参数；不含伦理谓词
Integration: 计划 P37；回答 §47 留下的“推出的范围达不到的”在可能性上的形式；给 P38 的第一部分总陈述提供区域；
             P39（第二部分）以 G0 为目标定理
```

| 声明 | 内容 |
|---|---|
| `Web.GainsSupport.rises`、`Web.LosesSupport.falls` | 要求不放松时只因所需条件上升而获得支持，要求不收紧时只因其下降而失去支持（经 `Web.supported_of`） |
| `Flow.rise_given_by_supported`、`Flow.gains_from_supported` | 平衡、Acting、Dependent 之下每次上升由被支持的形成给予，所以支持只从被支持者获得 |
| `Flow.unsupported_stays`、`Flow.nothing_supported_stays` | 家族中没有被支持者、要求不放松、只有成员给予成员所需时，没有成员再被支持；整体中什么都不再被支持或活跃 |
| `Restoring.*.restores` | 每项前提都必要：要求消解（Adapting）、家族之外的给予（Inflow）、不活跃的给予者（Idle）、不被支持的活跃给予者（Carried）、没有给予的上升（Spontaneous） |
| `Web.Admits`、`Web.Includes`、`Web.Exceeds` | 接纳；包含是预序；包含另一条的路径不被它超出 |
| `Flow.withhold`、`Flow.WithheldLevels.unique`、`Flow.Balances.withheld` | 扣留一个部分，扣留后的水平存在时唯一；每个水平加上该部分取走的，等于扣留后的水平加上该部分给予的 |
| `Flow.Balances.supported_iff_within_margin` | 相界精确：形成被支持，恰当在它所需的每个条件上，所需加上部分到此为止取走的，不多于扣留后的水平加上部分给予的，即部分的累计净汲取不超出余量 |
| `Flow.Balances.supported_of_net_give`、`admits_of_net_draw` | 关闭需要在所需条件上的净汲取，打开需要净给予 |
| `Flow.Balances.closes_nothing`、`opens_nothing`、`changes_nothing` | 每步给回不少于所取者不关闭，给予不多于所取者不打开，恰好给回者不改变 |
| `Restoring.Inflow.widens`、`Clearing.narrows`、`Transfer.mixed` | 扩大、缩小与混合的见证，各给出扣留后的水平 |
| `Web.AdmitsWithin.narrow`、`Web.LosesBeyond.narrow`、`Web.not_losesBeyond_whole`、`Web.AdmitsWithin.not_losesBeyond`、`Web.admitsWithin_self` | 区域越小，其外越多；整体之外什么都没有；单个形成之内成立的是它自身的接纳 |
| `Clearing.loses_beyond` | 清除者每步活跃且被支持，在它与来源之内不关闭任何东西，从第二步起在其外关闭栖居者 |
| `Web.RenewingOver`、`.at`、`.keeps_own`、`Clearing.renewing_over_resource`、`Omitted.loses_own` | 在条件区域上的更新：覆盖参与即该步的更新；覆盖所需且要求不收紧即保住自身支持，仍可侵蚀他者；遗漏所需可以经自身的汲取失去支持 |

**它回答了什么。**
- **可能性与三种区域。** 可能性读作接下来能形成什么，即每一步被水平接纳的形成。部分的贡献由有它与无它的比较给出，无它时保持其余交换不变，像 `Becoming.Joint` 的 but-for 检验保持动作不变。以包含比较，部分扩大、缩小、保持不变或混合。混合说明三种区域在包含之下不穷尽，给它定序需要度量，那是另一个前提。这与 Ren 确认的第二项读法一致：包含不许可强加的终结。
- **相界。** 关闭与不关闭之间的界由部分自身的净交换与他者所需的余量决定，不需要动力学之外的意志或信念。这个界是精确的（`supported_iff_within_margin`）：形成被支持，恰当部分在它所需的每个条件上的累计净汲取不超出扣留后的水平满足所需的余量。所以关闭一个能形成者，只经由在它所需条件上超出余量的净汲取（找出那个条件要用经典逻辑）；每步给回不少于所取的部分不关闭任何东西。已有的两个相界结果在 `Becoming.Continuation`：
  - 没有条件能被无限耗下去（`excess_bounded`）；
  - 使水平低于所需的联合超出，终结以其所需依存者（`joint_excess_ends`）。

  本节加上第三个：终结是吸收态（`unsupported_stays`）。
- **层级。** 我先前说过“只有不退化的动力学能无限延续”。这对部分不成立，`Clearing.loses_beyond` 就是对话中所说的搭便车者的反例：清除者在其依存之内一直延续，并在其外关闭栖居者。成立的是两个较窄的陈述：
  - 被持续耗下去的条件上，没有东西能无限延续；
  - 整体之外什么都没有，所以对整体，延续与不退化重合。

  区域越小，其外越多，这给出 Ren 的次序：整体、系统、自身，按判据的强弱排列，不加公理。
- **所表示的边界。** 一个中心的边界可以覆盖其所需而不覆盖其参与，于是保住自身而侵蚀他者；也可以遗漏其所需，于是经自身的汲取失去自身支持。只有覆盖其参与的边界给出该步的更新。

**作者反审。**
1. **接纳只看接下来的一步。** 可能性读作接下来能形成什么，经 Ren 确认；多步可达没有比较。
2. **反事实不让他者随之调整。** 扣留一个部分时其余交换照旧。他者因此过度取用时，扣留后没有平衡的水平，定理在那里空成立。所以每个见证都给出扣留后的水平，`WithheldLevels.unique` 保证它是唯一的那一条。
3. **只比较被接纳的形成。** Ren 也提到“renewal capacity, or richness of relations”，这里没有比较。
4. **吸收态需要要求不放松。** 形成通过消解其要求可以逃脱吸收态（`Adapting`）；这是转化，不是恢复。
5. **层级的定理大多是序的性质。** 实质在清除者的见证。“整体”是一个网中全部形成的区域，即所表示的整体；实际的整体从不完全被表示，这与 Ren 的第二项读法一致。
6. **所表示的边界只在一步上比较。** 多步的依存范围（供给其所需者的来源）没有进入比较。
7. **读法与名称是 AI 的。** 读法待 Ren；名称是 AI 按 Ren 的命名标准所选。
8. **两处用经典逻辑。** 把部分分为四种情形，以及从一个形成不被支持找出净汲取超出余量的那个条件，都用排中律；Lean 中证明的是两个方向的包含与精确的等价（`supported_iff_within_margin`），不是这两步。

**检查。** 核心先在暂存区对 4284d6ab 的核心编译，逐条审计：Admission 136 项声明、Regions 49 项，公理报告全部为空。合并检查器先对加入精确相界之前的版本（Admission 37 项定理）重查（回执 20261010T091630.066142Z，外围回执 20261010T092128.336807Z；两次运行都保留），加入 `supported_iff_within_margin` 之后再重查（回执 20261010T100351.523624Z），外围桥接对这个核心重查（20261010T100610.366844Z）。本节尚未经独立审查。

## 52. 每个前提选择之下计数的规律（P38）

2026-10-10。按 Ren“let's aim for the strongest claim without axiom, as the first part”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）与“go ahead with Part I”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-axiom-route-levels-and-possibilities.md)），作为计划 P38 中第一部分总陈述的“每个前提加了什么”。P34 与 P35 给出了计数的全部规律：缺平衡或缺体现的前提不约束计数，全部八个前提之下多出“没有关系项活跃的一步上没有生起”，被围住时再多出变化界。它们没有回答其余选择：八个前提的 256 个选择中，哪些约束计数、约束什么。本节给出完整的回答：不论有无被围住，计数的规律都只有几种，每种恰在一组可以写出的选择之下成立。成果记录：修订 [whole-law-of-counting](../../../../theories/becoming/results/records/whole-law-of-counting.md) 与 [counting-under-enclosure](../../../../theories/becoming/results/records/counting-under-enclosure.md)。

```text
Result(s): 复用 whole-law-of-counting（Tally、Queue、Pointwise、World.CountsObey、World.counting_binds_jointly、World.queue、
           World.embodiedQueue、World.openQueue）、counting-under-enclosure（ChangeBound、from_zero、World.enclosure_bounds_change、
           EnclosedQueue、World.enclosedQueue）、continued-change-needs-openness（Flow.standing_lowers）、map-of-premises（World.Premised）
Delta: Premises：World.taking_binds_counting、World.enclosed_binds_counting、World.Premise 与 Premise.Holds、World.Meets、
       World.BindsCounting、World.Premised.meets、OpenQueue.driven、World.drivenQueue 与 drivenQueue_holds、World.openQueue_holds
       （从 openQueue_premised 中分出）、World.queue_meets、embodiedQueue_meets、openQueue_meets、drivenQueue_meets、
       World.counting_under、World.counting_binds_iff。Openness：EnclosedQueue.empty_stays 与 idle 只要求该步的条件、
       World.enclosedQueue_taking 不再需要任何条件、World.enclosedQueue_dissipatesOn（逐步的耗散；enclosedQueue_dissipative
       由它得出）、EnclosedQueue.closing、World.closingQueue 与其平衡、closing_flows、closingQueue_enclosed、
       closingQueue_dissipative、World.BoundsChange、World.still_enclosed、World.enclosed_counting_under
Supplied premises / correspondence: 同 P34、P35：列出与可判定，逐点；被围住是世界的条件，不是公理；选择是到 Bool 的函数
Evidence: 合并检查器回执 20261010T101327.506085Z（1430 项定理、2280 项声明审计，全部源声明公理报告为空）；外围桥接重跑 20261010T102016.503705Z；实例检查
Boundary: 只说活动的计数；每个前提都起约束时的规律、有限世界中每个选择之下的规律、水平与依存的计数在前提之下没有陈述；
          不评价生起、止息或静止；名称按 Ren 的命名准则由 AI 选，读法由 Ren 定
Integration: 计划 P38（第一部分的总陈述：每个前提加了什么）；扩展 whole-law-of-counting 与 counting-under-enclosure
```

| 声明 | 内容 |
|---|---|
| `World.Premise`、`Premise.Holds`、`World.Meets` | 八个前提的名称；选择是到 Bool 的函数，世界满足它所选的每个前提 |
| `World.BindsCounting` | 选择约束计数：选中平衡与体现，并选中只有活跃者给予，或同时选中只有活跃者取用其所汲取的与耗散 |
| `World.taking_binds_counting` | 在平衡、只有活跃者取用、耗散与体现之下，普查中没有关系项活跃的一步上没有生起，不论谁给予 |
| `World.enclosed_binds_counting` | 在平衡、耗散与体现之下，被围住且没有关系项活跃的一步上没有生起，不论谁给予、谁取用 |
| `OpenQueue.driven`、`World.drivenQueue`、`World.drivenQueue_holds` | 由一个闲置的地关系项驱动的队列（P41b 注：应为不活跃的地关系项，它参与每一步的交换；见 §58 V6）：它给予每个加入者、从每个离开者取用，并在每步与每个地关系项各交换一个单位，所以没有家族封闭；满足除只有活跃者给予与只有活跃者取用外的全部前提 |
| `World.openQueue_holds` | 不论计数，开放的队列满足除只有活跃者给予与耗散外的全部前提：成员加入空队时队首闲置地给予 |
| `World.counting_under` | 在每个选择之下，计数的一个性质在满足它的每个世界的每个普查中成立，恰当它对每个计数表成立，且在选择约束计数时对每个没有关系项活跃的一步上没有生起的计数表成立 |
| `World.counting_binds_iff` | “没有关系项活跃的一步上没有生起”在一个选择之下是计数的规律，恰当这个选择约束计数 |
| `World.enclosedQueue_taking`、`World.enclosedQueue_dissipatesOn` | 被围住的队列不论计数都只在活跃时取用；它的耗散逐步成立，只要求该步没有成员加入空队、前后两步都在所立者之内 |
| `EnclosedQueue.closing`、`World.closingQueue`、`World.closingQueue_dissipative`、`World.closingQueue_enclosed` | 在第 T 步闭合的被围住的队列：T 之前每个关系项与队首各交换一个单位，所以没有家族封闭；从 T 起它就是被围住的队列，所立者多出 T；从 T 起有变化界、没有成员加入空队时它耗散 |
| `World.BoundsChange`、`World.enclosed_counting_under` | 选择约束变化：选中平衡、体现与耗散。从某步起每步被围住的世界中，在每个选择之下计数的规律是 `counting_under` 的规律，在选择约束变化时再加上：从某步起变化在一个界之内，且没有关系项活跃的一步上没有生起 |

**解读。**

- **两条路线。** P34 只给出一条：平衡、体现与只有活跃者给予。第二条不要求给予者活跃：没有关系项活跃的一步上，只有活跃者取用，所以什么都不被取用；被给予者的水平上升，体现使它在步后活跃，所以步后活跃者的列表是一个封闭的家族；耗散不许给予封闭家族而不取用，所以什么都没有被给予，没有东西生起。闲置的给予者可以在一个开放的展开中给予，却不能在一个封闭的家族中无偿给予。被围住的一步上连取用的前提也不需要：那一步本来就有封闭的家族，所立者的总水平为零，任何成员开始立着都会使它下降（`Flow.standing_lowers`）。
- **两种规律，256 个选择。** 每个选择之下计数的规律只有两种：计数表，或计数表加上没有关系项活跃的一步上没有生起。后者恰在选择约束计数时成立。其余每个选择之下，每个计数表都被实现：缺平衡由立着的队列，缺体现由不流动的队列，缺给予与取用两个前提由驱动的队列，缺给予与耗散由开放的队列。这四类覆盖了不约束计数的全部选择：选中平衡与体现而不约束计数，就是既缺只有活跃者给予，又缺取用或耗散中的一个。
- **被围住时多一种。** 从某步起每步被围住时，选中平衡、体现与耗散，计数还有一个界：从被围住起，活跃者连同有变化的步不多于那时所立者的总水平（P35），而且从那一步起没有关系项活跃的一步上没有生起。后一条在构造性的核心中须带着它的步陈述：变化界之内变化不复现（`ChangeBound.not_recurring`），但这本身不给出一步。见证是在第 T 步闭合的队列：T 之前与每个关系项交换，所以不被围住，可以任意生起；从 T 起就是 P35 的被围住的队列。
- **一元的读法（AI 论证）。** “没有关系项活跃的一步上没有生起”不是另加的规则，而是给予、取用、耗散与体现之间的关系在计数上的形状：在一个封闭的关系中，生起要从已经在场的东西中取得。它不需要给予者的活动，需要的是取用与封闭；被围住时连取用也不需要，因为封闭已经在那里。

**作者反审。**

*反驳 1：256 个选择是表示的产物。* 选择只是把已有的八个前提按“选中或不选中”排列；规律刻画的是每个排列下的世界。用 Bool 是为了在纯净核心中可判定地分情况，不加内容。

*反驳 2：普查与有界传递、活动需要支持不出现在条件中，像是被忽略了。* 它们对计数不起约束：普查由所给的普查本身满足；见证中没有依存，所以活动需要支持与有界传递空成立。这与 P34 的观察相同（`World.openQueue_not_binds`）。每个前提都起约束时的规律没有陈述，它至少多出一个生起（`World.binds_arising`）。

*反驳 3：驱动的队列与闭合的队列太特殊。* 同 §46 反驳 1：更多的规律须在满足条件的所有世界中成立，包括这些见证。

*反驳 4：有限世界呢？* P35 在全部八个前提之下证明了有限世界与被围住的世界计数规律相同。在其余选择之下，有限世界的规律没有陈述：这里的见证都有无限多个关系项。

**章节重组。** 章节在 §1 前加第一部分的说明，在 §5 后加第一部分的总陈述，在 §6 前加第二部分的说明；节标题不变，锚点保留。总陈述说三件事：对每个展开成立的（不加前提的规律与计数表），每个前提加了什么（前提的地图、本节的计数、静止与开放、依存与储备、部分与区域），动力学在何处不再决定（前提是否成立、终结之步、混合的部分、中心、意义）。第二部分的说明引 Ren 提议的公理与路线 (a)，并写明 G0 被证明之前仍是所采用的公理（P39）。组织与措辞是 AI 的。

**边界。** 无伦理谓词，不评价生起、止息或静止；只对离散步与每步有限的活动陈述；选择之下的规律只读于活动的普查；有限世界中每个选择之下的规律、每个前提都起约束时的规律、水平与依存的计数在前提之下没有陈述；名称（Premise、Meets、BindsCounting、BoundsChange、drivenQueue、closingQueue）是 AI 按 Ren 的命名准则所选：驱动（driven）与闭合（closing）是系统的词，分别说外来的强迫与在某步封闭的流。本节尚未经独立审查。

## 53. 一条公理推出什么（P39）

2026-10-10。Ren 提议第二部分的一条公理：“for anything, its continuation into the future has significance(doesn't have to be positive, we could argue as long as not harm), or continuation into the future needs to create more significance(being generative)”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-wanting-continuation-one-axiom.md)）。Ren 选定路线：“let's aim for a first, then try to archive b”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-axiom-route-levels-and-possibilities.md)）。在路线 (a) 下，G0 是由这条公理与第一部分推出的目标定理。

Ren 此后回答（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-centers-within-the-dynamics.md)）：
- 中心及其边界只存在于认知的结构与动力学中，也在同一系统之内形成，“so there isn't really who's continuation matters, which requires axiom”；

所以本节不按 §47 的读法给每个想要之点放一个中心，而直接陈述 Ren 的原话。

本节是计划 P39（[计划 §10](../history/root-foundation/BECOMING-UNIFICATION-PLAN.md#10-第一部分与第二部分--part-i-and-part-ii)），由本会话完成；分工经另一会话同意。它在核心中新增模块 `Becoming.Significance`，27 项定理。成果记录新增三项：
- [one-axiom-yields-g0](../../../../theories/becoming/results/records/continuation-condition-yields-living-significance.md)
- [significance-retained-within-margin](../../../../theories/becoming/results/records/significance-retained-within-margin.md)
- [whole-first-and-bounded-centers](../../../../theories/becoming/results/records/whole-and-regions-and-bounded-centers.md)

```text
Result(s): 复用 metaethical-core-characterization（Valuation、Significant、SelfGood、Seed、transmits、shares、Neutral、Within、
           G0、Extension、Comparison）、held-lives-g0-is-centering（被持有的生命上 G0 恰等于处处 S0 加 N_std，作为读法引用）、
           becoming-stepwise-reading（Web.valuation、Web.relations、UnderminingAt）、becoming-renewal-reading
           （Conditions.valuation）、closing-needs-net-draw（Admits、Includes、Exceeds、WithheldLevels、
           Balances.supported_iff_within_margin、opens_nothing）、four-cases-of-a-part（Restoring.Inflow.widens、
           Transfer.mixed）、loss-beyond-a-region（AdmitsWithin、AdmitsWithin.narrow、Clearing 的见证与 loses_beyond）、
           derived-extent-limits（Clearing，作为读法引用）；新增上列三项
Delta: Unrestricted、bounded、bounded_rival；Web.Retains（refl、trans、not_added、of_fewer、within）、Web.Adds、
       Includes.retains、Adds.exceeds、retains_iff_includes、adds_iff_exceeds、retains_agree、retains_bounded_iff；
       Flow.Balances.retains_iff_within_margin、loses_iff_beyond_margin、adds_iff_within_margin；
       Valuation.premises_of_unrestricted、Web.significant_of_unrestricted、Conditions.significant_of_unrestricted、
       Web.paths、Web.paths_g0_comparison、Web.significance_undetermined；Clearing.admitted_all_without、free_rider_loses、
       dependenceRegion、centers_disagree；Transfer.unordered；Restoring.Inflow.retains_adds；
       Preemption（flow、web、drawerPart、withheld、not_undermining_yet_loses）
Supplied premises / correspondence: 公理 Unrestricted 是定理的假设，不被证明；主张的意义读作某形成在某步之延续的意义
       （formation、step、reads）；平衡与扣留后的水平（每个见证给出它）；离散的步、自然数的量、可判定的部分；
       读法与名称是 AI 的，待 Ren
Evidence: 合并检查器回执 20261010T110824.890630Z（1457 项定理、2316 项声明审计、核心闭包 34 个模块、包 32 个模块，全部源声明公理报告
          为空，没有新的生成常量依赖公理）；外围回执 20261010T111624.656993Z
Boundary: G0 在主张层面是公理的直接推论；A、L、J1–J4 仍是前提；C 只在水平路径上推出；为混合部分定序的度量、形成个体化
          的层次、G0 的 living 指哪种读法、公理的规范根据都不推出；只比较被接纳的形成，每一步
Integration: 计划 P39（第二部分，路线 (a)）；G0 成为这条公理的定理，Ren 接受之前仍是所采用的公理；给 P40（路线 (b)）
             留下以依存为界的中心容许搭便车者（Clearing.centers_disagree）
```

| 声明 | 内容 |
|---|---|
| `Unrestricted`、`bounded`、`bounded_rival` | 公理：从每个立场，任何东西在每一步的延续都有意义，即延续之意义的边界中立；以区域为界的意义是在区域之内接受同一规则，有形成在某个立场的区域之外时不是公理 |
| `Web.Retains`、`Web.Adds`、`Retains.refl`、`Retains.trans`、`Retains.not_added` | 从一个立场，一条水平路径保留另一条上的有意义者，是指它接纳另一条所接纳的每个有意义的延续；增加，是指它接纳一个另一条不接纳的。保留是预序；保留另一条者不被它增加，所以不终结其中任何有意义者 |
| `Web.Includes.retains`、`Web.Adds.exceeds`、`Web.retains_iff_includes`、`Web.adds_iff_exceeds`、`Web.retains_agree` | 包含总保留，增加总超出；公理之下保留就是包含、增加就是超出，从每个立场都一样 |
| `Flow.Balances.retains_iff_within_margin`、`loses_iff_beyond_margin`、`adds_iff_within_margin` | “不损”的精确界：有部分的水平保留无它时的有意义者，恰当在无它时被接纳的每个有意义的延续所需的每个条件上，部分的累计净汲取不超出余量；失去恰在超出余量之处，增加恰在净交换把无它时不被接纳的形成带入余量之处 |
| `Valuation.premises_of_unrestricted` | 在主张的意义即某形成在某步之延续的意义的每种读法上，公理给出 G0、处处 S0、N_rel、N_std 与（有活者时的）种子，不用连通 |
| `Web.significant_of_unrestricted`、`Conditions.significant_of_unrestricted` | 逐步读法、关系层读法与整段读法都是这样的读法 |
| `Web.paths`、`Web.paths_g0_comparison` | 水平路径的框架：主张是某步的形成，在路径上被接纳即实现，没有步。公理之下，对 living 的每种读法 G0 成立，正面意义读作从每个立场都有意义；C 也成立，“更好”读作保留且增加有意义者 |
| `Web.significance_undetermined` | 没有任何东西有意义时，每条水平路径保留每一条，没有一条增加，逐步读法上的 G0 在任何活的事件上不成立；一切都有意义时 G0 成立 |
| `Web.Retains.of_fewer`、`Web.retains_bounded_iff`、`Web.Retains.within` | 有意义者越少，保留的越多；以区域为界的意义保留的是区域之内被接纳的；公理之下在整体中保留的在每个区域内保留 |
| `Clearing.admitted_all_without`、`Clearing.free_rider_loses` | 无清除者的部分时，每个形成每步都被接纳。公理之下从每个立场，这个部分失去栖居者；无它的水平保留有它的有意义者；清除者每步被支持，无它时也被接纳，所以扣留它不终结任何东西 |
| `Clearing.dependenceRegion`、`Clearing.centers_disagree` | 让每个形成的意义止于其依存所及：从清除者的立场，部分在每一步保留有意义者；从栖居者的立场，它失去栖居者 |
| `Transfer.unordered`、`Restoring.Inflow.retains_adds` | 公理之下，传送者的部分不被定序：两条路径各自增加对方缺少的；给予者的部分保留并增加 |
| `Preemption.flow`、`web`、`drawerPart`、`withheld`、`not_undermining_yet_loses` | 汲取者在第零步、任何依存形成之前取走条件唯一的单位。流平衡，只有活跃者给予与取用，活动需要支持，它的事件活跃且不侵蚀。但一个从第一步起需要该条件的形成，无此部分时每步被接纳，有此部分时第一步起每步不被支持；无此部分的水平包含有它的水平，公理之下部分失去一个有意义的延续 |

**它回答了什么。**
- **G0 是公理的直接推论。** 公理比 G0 强：它对每个形成、每一步、每个立场成立，G0 只要求活的主张从每个立场有意义。所以在主张的意义即延续之意义的读法上，G0 是公理限于活的主张。前提卡上的种子、S0、N_rel 与 N_std 由它给出；C 在水平路径上给出。A、L 与 J1–J4 仍是前提。这一步本身不深，实质在下面几项：它们经第一部分给出“不损”与“生成”的精确形式。
- **“不损”的相界。** Ren 说“not harm”是有清楚边界的相变。公理之下，保留就是包含，所以“不损”就是 P37 的相界：在每个有意义的延续所需的条件上，部分的净汲取不超出余量（`retains_iff_within_margin`）。界由部分自身的净交换与他者所需的余量定出，不需要动力学之外的意志或信念。增加（Ren 的“create more significance”）就是超出：部分的净交换把一个无它时不能形成的形成带入余量。所以 Ren 的强式是弱式之下的生成情形，不需要第二条公理。
- **尚未形成者也算。** 逐步读法（[becoming-stepwise-reading](../../../../theories/becoming/results/records/becoming-stepwise-reading.md)）只计已被满足的依存：一个事件活跃且不侵蚀，就是活的；侵蚀是在某步汲取一个条件，使它在步后既低于依存于它者当前的所需，又低于该依存曾被满足的所需。`Preemption` 表明这与保留不同。汲取者在任何依存形成之前取走条件，它不侵蚀任何东西，却使一个以后需要该条件的形成每步都不能形成；公理之下这是失去一个有意义的延续。G0 的 `living` 指哪种读法是 Ren 的选择；这里只证明两者不同。
- **整体优先。** 以区域为界的意义只看区域之内。公理之下，在整体中保留的在每个区域内都保留（`Retains.within`），反过来不成立。`Clearing.centers_disagree` 是反例：每个形成的意义止于其依存时，清除者从自己的立场保留一切，栖居者从自己的立场失去自身。公理之下这个部分从每个立场都失去栖居者，而扣留它不终结任何东西（`free_rider_loses`）。这给出 Ren 的次序：整体、所在的系统、自身，作为判断完整性的次序。Ren 说“not saying this is what life does”，这里也不说生命实际怎样做。
- **公理是需要的。** 第一部分没有一条定理提到意义；没有任何东西有意义时，什么都不被定序（`significance_undetermined`）。以区域为界的意义也是被给出的：Ren 说自身“can not justify itself without some sort of "belief"”。没有这条公理，动力学不决定意义。

**作者反审。**
1. **G0 在主张层面是直接的。** `premises_of_unrestricted` 的证明只有几行：公理对每个形成、每一步、每个立场都给出意义，G0 只取其中活的。所以“G0 被推出”不应读作深的定理。记录如实写明这一点；深的部分是保留、相界与先占，它们用到第一部分（P37 的精确相界）。
2. **`reads` 是对应，不是证明。** 主张的意义读作某形成在某步之延续的意义，由 `formation`、`step`、`reads` 给出。逐步读法、关系层读法与整段读法满足它；不满足它的读法上，定理不说什么。
3. **C 只在水平路径上推出。** `Web.paths` 是一个没有步的框架：主张是某步的形成，在路径上被接纳即实现。C 在“更好”读作保留且增加时成立；在一般的框架上 C 仍是前提。
4. **不分等级。** 意义是命题，不是量，所以混合的部分（`Transfer.unordered`）不被定序；定序需要度量，那是另一个前提。Ren 也说意义“doesn't have to be positive”：这里的“不损”是比较，不是正面的价值。
5. **个体化的层次。** 什么算一个形成（成员或谱系）决定什么算失去。见证中形成是给定的，层次没有推出。
6. **先占依赖“以后需要”的表示。** `Preemption` 中形成 `false` 从第一步起需要条件，这是表示的选择。它说明保留计入仍能形成者，逐步读法不计入；不说明先占在每个模型中都失去什么。
7. **以依存为界的中心是一个选择。** `Clearing.dependenceRegion` 让清除者的区域是它沿依存所及的形成（含来源），栖居者与来源只含自身。它说明这样的中心彼此分歧并容许搭便车者，这正是路线 (b) 须面对的。
8. **读法与名称是 AI 的。** `Unrestricted`、`Retains`、`Adds`、`bounded`、`Preemption` 是 AI 按 Ren 的命名准则所选：不受限、保留、增加、有界与先占都是形式与系统的词。读法待 Ren。

**检查。**
- 模块先在暂存区对 P37 的核心编译（P38 不影响它的导入），逐条审计全部 71 项声明（含 Lean 生成的辅助声明），公理报告全部为空。
- 合并检查器对加入模块的包检查三次，三次运行都保留，每次都通过：
  - 第一次是回执 20261010T104700.459715Z。之后只改了模块文档中的三处措辞：Ren 对中心的回答的转述、“positive”一句（Ren 说意义“doesn't have to be positive”）、立场索引的读法。
  - 第二次是回执 20261010T105720.952257Z。之后只改了根模块文档中的一处：G0 成立的范围写明为逐步、关系层与整段读法。
  - 第三次是回执 20261010T110824.890630Z，为本节的证据。
- 外围检查有两次运行在上述文档修改前中止，没有回执。
- 外围桥接对这个核心重查（20261010T111624.656993Z）。
- 本节尚未经独立审查。

## 54. 有限世界中每个选择之下计数的规律（P38b）

2026-10-10。按 Ren“let's aim for the strongest claim without axiom, as the first part”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)），补全第一部分总陈述中“每个前提加了什么”在有限世界中的部分。§52 给出了每个前提选择之下计数的规律，以及从某步起被围住时多出的变化界；其见证都有无限多个关系项，有限世界中每个选择之下的规律没有陈述（§52 反驳 4）。P35 只在全部八个前提之下证明有限世界与被围住的世界计数规律相同，第一部分的总陈述却在每个选择的语境中写“有限世界的计数规律与此相同”，范围不准确。本节给出有限世界中每个选择之下的完整规律，并给出两类世界恰在何时规律相同。成果记录：修订 [counting-under-enclosure](../../../../theories/becoming/results/records/counting-under-enclosure.md) 与 [whole-law-of-counting](../../../../theories/becoming/results/records/whole-law-of-counting.md)。

```text
Result(s): 复用 counting-under-enclosure（ChangeBound、from_zero、not_recurring、World.enclosure_bounds_change、
           World.enclosed_binds_counting、EnclosedQueue.span 与 within_span、EnclosedQueue.empty_stays、World.finiteQueue、
           World.enclosed_counting_under）、whole-law-of-counting（Tally、Queue、Pointwise、World.CountsObey、
           World.counting_binds_jointly、World.taking_binds_counting、World.Meets、World.BindsCounting、Queue.lone）、
           ceasing-needs-arising（World.Finite.census_bounded）、map-of-premises（World.Finite.enclosed、World.still_vacuous）
Delta: Openness：列表引理 exists_of_mem_map、distinct_map_on，places_listed（finiteQueue_finite 由它得出），
       comesToBe_congr、ceasesToBe_congr；Ring（slot 与 slot_step、slot_lt、slot_add、slot_ne、slot_apart、slot_inj，
       size、seat、seated、holds、web、stands、flow，occupied、front_holds、span_fits、holds_iff、census、counts、
       taken_held、given_held）；Queue.lone_settles；World.ring、embodiedRing、balancedRing 与其 premised／holds、
       balancedRing_acting、三个 _meets；World.finite_counting_under、finite_counting_binds_iff、finite_change_bound_iff、
       enclosed_iff_finite_counting_under
Supplied premises / correspondence: 同 §52：列出与可判定，逐点；有限是世界的条件，不是公理；选择是到 Bool 的函数
Evidence: 合并检查器回执 20261010T112632.899583Z（1488 项定理、2361 项声明审计，全部源声明公理报告为空）；外围桥接重跑 20261010T112836.954648Z；实例检查
Boundary: 只说活动的计数；每个前提都起约束时的规律、水平与依存的计数在前提之下没有陈述；不评价生起、止息或静止；
          名称按 Ren 的命名准则由 AI 选，读法由 Ren 定
Integration: 计划 P38b（第一部分的总陈述：每个前提加了什么，在有限世界中）；扩展 counting-under-enclosure
```

| 声明 | 内容 |
|---|---|
| `Ring.slot` | 把成员依次排在一圈 N 个位置上：第 k+1 个坐在第 k 个的下一个位置，满一圈回到第一个位置。用自己的递归而不用 `Nat.mod`，因为前导中关于取余的引理带 `propext` |
| `Ring.slot_add`、`Ring.slot_ne`、`Ring.slot_inj` | 相距 d < N 时，位置前进 d，或前进 d 再减一整圈；所以相距不到一圈的成员位置不同，至多 N 个依次的成员中位置相同的是同一个 |
| `Ring.size`、`Ring.seat`、`Ring.seated`、`Ring.holds` | 每步至多 M 个在队中时取 2M+1 个位置；第 k 个成员的位置；每步被占的位置；位置被占 |
| `Ring.holds_iff`、`Ring.census`、`Ring.counts` | 一步前后在队中的成员都在这一步的跨度内，跨度不长于 2M，所以在那里位置被占恰当成员在队中；环列出每步被占的位置，各一次，计到队列所计的 |
| `World.ring`、`World.embodiedRing`、`World.balancedRing` | 不立任何东西、什么都不流动的环；每个位置被占时立着一的环；其队首的位置再从每个位置取用其水平所降的、给予其所升的环 |
| `World.ring_meets`、`World.embodiedRing_meets`、`World.balancedRing_meets` | 三者分别满足不选体现、不选平衡、不选耗散的每个选择；第三者只在没有成员加入空队时满足只有活跃者给予（`World.balancedRing_acting`） |
| `World.finite_counting_under` | 有限世界中，在每个选择之下，计数的一个性质在满足它的每个有限世界的每个普查中成立，恰当它对每个满足三个条件的计数表成立：每步至多有某数个活跃；选择约束计数或约束变化时没有关系项活跃的一步上没有生起；选择约束变化时从第 0 步起有变化界 |
| `World.finite_counting_binds_iff`、`World.finite_change_bound_iff` | 前者在有限世界中恰当选中平衡与体现、并选中只有活跃者给予或耗散时是规律；后者恰当选择约束变化时是规律 |
| `Queue.lone_settles`、`World.enclosed_iff_finite_counting_under` | 一个关系项在第 0 步生起之后，从第 1 步起变化界为一；有限世界与从某步起被围住的世界在一个选择之下有相同的计数规律，恰当这个选择约束变化且约束计数 |

**解读。**

- **有限是从第一步起的被围住。** 有限世界的每一步都被围住，所以 §52 中被围住的一步上的约束（平衡、耗散与体现就足够，`World.enclosed_binds_counting`）在每一步都起作用：选中这三者，就在每一步都没有关系项活跃时没有生起，不需要只有活跃者给予，也不需要只有活跃者取用；变化界也从第 0 步起成立。有限还给计数一个界：每个普查至多计到关系项那么多。
- **三种规律。** 所以有限世界中 256 个选择给出三种规律：有界的计数表；再加没有关系项活跃的一步上没有生起（选中平衡、体现、只有活跃者给予而不选耗散）；再加这一条与从第 0 步起的变化界（选中平衡、体现与耗散）。在不被围住的世界中只有两种（§52）。
- **环。** 有限的见证需要把无限的队列放到有限多个位置上。在全部八个前提之下，P35 的见证用变化界数出成员曾占的位置。其余选择之下没有变化界，计数可以每步都变，成员无限多；但每步在队中的不多于某数 M，一步前后在队中的不多于 2M，所以把成员依次排在一圈 2M+1 个位置上，任一步前后的成员都占不同的位置，环计到队列所计的。三个环对应 §52 的三个队列世界：不立任何东西的队列、立着的队列与被围住的队列（变化界为零），只是位置可以被再次占用。
- **何时与被围住的世界相同。** P35 说全部八个前提之下两类世界无法区分。在一个选择之下，它们恰在选择约束变化且约束计数时无法区分：那里被围住时的变化界从某步起，等于从第 0 步起的变化界（`ChangeBound.from_zero`），并给计数一个界。不约束变化时，每步多一个的计数由每步被围住的队列实现，却不由任何有限世界实现；约束变化而不约束计数时，在第 1 步闭合的队列可以让一个关系项在被围住之前从无到有地生起，有限世界不行。
- **一元的读法（AI 论证）。** 有限不是另加的规则，而是关系总在一个封闭的家族之内：所有关系项就是这个家族。所以耗散在每一步都起作用，生起总要从已在场的取得，变化总耗去所立者。被围住只从某步起把展开收进这样的家族，所以它之前的生起不受约束。

**作者反审。**

*反驳 1：环只是表示的技巧。* 环是见证，不是断言的内容。断言说的是有限世界中计数的规律；要表明更多的规律不成立，须有满足条件的有限世界实现每个这样的计数表，环就是这样的世界。成员依次占位、满一圈重用，只用到计数表与每步的界，不加计数之外的内容。

*反驳 2：每步至多某数活跃是否已经是全部？* 不是：在约束计数或约束变化的选择之下还有规律，且这些规律恰在可写出的选择之下成立（两条“恰当”）。界本身在每个选择之下都是规律（`World.Finite.census_bounded`），所以计数表加界是最弱的一种。

*反驳 3：总陈述中“有限世界的计数规律与此相同”的旧句是否错了？* 读作全部八个前提之下，它是对的（`World.enclosed_iff_finite_counting`）；放在每个选择的语境中，它的范围不准确。本节把它改为精确的陈述：恰在选择约束变化且约束计数时相同，全部八个前提是其情形。

*反驳 4：为什么不直接用 `Nat.mod`？* 前导中关于取余的引理（如 `Nat.mod_lt` 以外的 `Nat.add_mod`、`Nat.mod_eq_of_lt`）带 `propext`，核心要求公理报告为空，所以用自己的递归 `Ring.slot` 与它的三条引理。

**边界。** 无伦理谓词，不评价生起、止息或静止；只对离散步与每步有限的活动陈述；有限世界中的规律只读于活动的普查；每个前提都起约束时的规律、水平与依存的计数在前提之下没有陈述；名称（Ring、slot、seat、seated、ring、embodiedRing、balancedRing）是 AI 按 Ren 的命名准则所选：环（ring）取自系统中的环形缓冲区，说依次占用、满一圈重用的有限位置。本节尚未经独立审查。

## 55. 每个前提都起约束时计数的规律（P38c）

2026-10-10。按 Ren“let's aim for the strongest claim without axiom, as the first part”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)），补全第一部分总陈述中计数的规律在每个前提都起约束时的部分。全部八个前提之下计数的规律恰是计数表与没有关系项活跃的一步上没有生起（P34，`World.premised_counting`）；其见证开放的队列中耗散、活动需要支持与有界传递空成立（`World.openQueue_not_binds`，第十三次审查 U3 的探针）。每个前提都起约束时，每个普查都计到某个生起，这在八个前提之下不是规律（`World.binds_arising`、`World.binds_adds`）；是否还有更多的规律没有陈述（whole-law-of-counting 的下一增量）。本节给出完整的规律：只多出这一条。另外，`hatch` 中每个前提都起约束而世界归于静止（P29），开放纲领中“每个前提都起约束的世界归于静止”容易读作一般的陈述；本节表明，每个前提都起约束既不决定静止，也不决定变化不息。成果记录：修订 [whole-law-of-counting](../../../../theories/becoming/results/records/whole-law-of-counting.md) 与 [continued-change-needs-openness](../../../../theories/becoming/results/records/continued-change-needs-openness.md)。

```text
Result(s): 复用 whole-law-of-counting（Tally、Queue、Pointwise、World.CountsObey、World.counting_binds_jointly、
           World.premised_counting、World.binds_arising、World.binds_adds、OpenQueue.front）、counting-under-enclosure
           （EnclosedQueue.place、place_pos、place_zero、total_place、span、within_span、span_distinct、empty_stays、
           outside_empty）、map-of-premises（World.Binds、World.Premised、World.hatch_binds）、continued-change-needs-openness
           （World.standingCensus、Web.StandingCensus.stock_eq、World.hatch_rests）
Delta: Openness：add_sub_turn_add；EnclosedQueue.place_le、total_place_le、total_place_pos；BindingQueue（excess、level、
       exchange、web、flow，excess_le、level_le、still_flows、still、idle、busy、moving_within、closed、not_closed）；
       World.bindingQueue 与 bindingQueue_decided、_census、_embodied、_balanced、_acting、_taking、_exceeds、
       _dissipative、_premised、_binds；World.binding_counting、World.binding_contingent
Supplied premises / correspondence: 同 §52：列出与可判定，逐点；起约束是 World.Binds 的八个条件；有限与被围住不是前提
Evidence: 合并检查器回执 20261010T132639.927992Z（1512 项定理、2392 项声明审计，全部源声明公理报告为空）；外围桥接重跑 20261010T132949.908183Z；实例检查
Boundary: 只在全部八个前提之下陈述；每个选择之下所选前提都起约束时的规律、水平与依存的计数在前提之下没有陈述；
          只说活动的计数；不评价生起、止息或静止；名称按 Ren 的命名准则由 AI 选，读法由 Ren 定
Integration: 计划 P38c（第一部分的总陈述：每个前提都起约束时）；修订 whole-law-of-counting 与 continued-change-needs-openness
```

| 声明 | 内容 |
|---|---|
| `BindingQueue.excess`、`BindingQueue.level` | 队首在第 T 步多立着 E，其余步不多；成员按其在队中的位置而立 |
| `BindingQueue.exchange`、`BindingQueue.web`、`BindingQueue.flow` | 在除第 T 步外队列不空的每一步上，队首与每个关系项各交换一个单位；每个关系项以其所立的水平依存于每个关系项；队首从每个成员取用其水平所降的、给予其所升的 |
| `BindingQueue.not_closed`、`BindingQueue.closed` | 在除第 T 步外队列不空的步上，没有家族封闭；在不交换的一步上，跨度封闭这一步 |
| `World.bindingQueue_exceeds` | 跨第 T 步，队列不空且队首多立着的多于加入的时，队首从跨度取用的多于给予的：所立者下降 |
| `World.bindingQueue_premised`、`World.bindingQueue_binds` | 没有成员加入空队、E 多于第 T 步加入的数目时，起约束的队列满足全部八个前提；第 T 步有成员加入时每个前提都起约束 |
| `World.binding_counting` | 每个前提都起约束时，八个前提之下计数的规律恰是计数表、没有关系项活跃的一步上没有生起，以及有某个生起 |
| `World.binding_contingent` | `hatch` 中每个前提都起约束而生起停止；每步一个成员替换另一个的起约束的队列中每个前提都起约束，生起与止息复现 |

**解读。**

- **起约束只多出一条。** 第十三次审查问：开放的队列中三个前提空成立，全部八个前提之下计数的规律是否因此才这么少？回答是否定的。每个前提都起约束时，计数的规律只多出“有某个生起”，而这一条只来自体现起约束这一条件本身（有关系项生起时体现起约束），不用任何前提（`World.binds_arising`）。所以八个前提即使都在起作用，对计数的约束也不多于计数表与“没有关系项活跃的一步上没有生起”。（P41b 注：“都在起作用”应读作 `World.Binds` 的八个条件都有实例；见证中活动需要支持与有界传递对任何活动、任何流都成立，见 §58 V1。）
- **起约束的队列。** 见证须让每个前提都起约束，同时实现每个满足条件的计数表。耗散只在被围住的步上起约束，而从某步起每步被围住会给出变化界（§49），所以队列只在一步 T 上闭合：其余队列不空的每一步上，队首与每个关系项各交换一个单位，没有有限的家族封闭；在 T 上，队首只在队中交换，并失去在那一步多立着的 E，所以所立者下降，耗散起约束。为了让所立者在 T 上下降，不论加入多少成员，E 须多于第 T 步加入的数目。依存与传递的约束由一个最弱的网给出：每个关系项以其所立的水平依存于每个关系项，所以活跃者依存于自己且所需为正，后代在其第一步所依存的，给予者也依存。（P41b 注：这一队列改名为只闭合一次的队列 `OnceClosedQueue`；其中活动需要支持与有界传递对任何活动、任何流都成立，只在条件有实例的意义上起约束，排除什么的只有耗散，见 §58 V1、V6。）
- **静止与不息都不由起约束决定。** `hatch` 中每个前提都起约束，世界归于静止；每步替换一个成员的起约束的队列中每个前提都起约束，生起与止息复现。所以开放纲领中“每个前提都起约束的世界归于静止”只说 `hatch`，本节随之更正这一句。
- **有限世界不在其中。** 普查起约束只在于世界不有限，所以没有有限世界使每个前提都起约束；有限世界中的规律见 §54。
- **一元的读法（AI 论证）。** 起约束说的是前提在这个展开中确有实例：有依存，有给予与取用，有封闭家族上的耗散，有生起与传下。它们都起作用时，计数仍只记录进入与离开的相抵，加上至少有一次生起：关系怎样被给予、取用与依存，在计数中没有留下更多。

**作者反审。**

*反驳 1：“每个关系项以其所立的水平依存于每个关系项”是平凡的依存。* 它是最弱的，但满足 `World.Binds` 的条件：一个活跃者以正的所需依存于某个条件。断言说的是每个起约束的世界中都成立的规律；要表明更多的规律不成立，见证只需要是其中一个。更强的依存只会使更少的世界满足前提，不会使已在所有起约束的世界中失败的性质成为规律。（P41b 注：这只回答了见证；对起约束这一概念的反驳没有回答：要求每个前提排除表示所允许者的读法使更少的世界满足，也可能使更多的性质成为规律。这一读法列为开放，见 §58 V1。）

*反驳 2：只在一步闭合是否人为？* 它是见证的选择。耗散的起约束只要求某一步上某个封闭的家族被取用；要求从某步起每步都闭合就给出变化界，那是被围住的情形（counting-under-enclosure）。

*反驳 3：每个选择之下所选前提都起约束时如何？* 没有陈述。起约束的条件本身就给出计数的性质：活动需要支持起约束时某一步有活跃者，体现起约束时有某个生起；在部分选择之下，它们与前提的交互还须逐一给出见证。

*反驳 4：起约束的队列的 E 依赖计数（E 多于第 T 步加入的数目），是否把计数写进了世界？* 是的，每个见证都由计数表构造，开放的队列与环也是；断言说的是满足这些条件的计数表都被某个起约束的世界实现，不是一个世界实现所有计数表。

**边界。** 无伦理谓词，不评价生起、止息或静止；只对离散步与每步有限的活动陈述；只在全部八个前提之下陈述；每个选择之下所选前提都起约束时的规律、水平与依存的计数在前提之下没有陈述；名称（BindingQueue、excess、exchange、bindingQueue、binding_counting、binding_contingent）是 AI 按 Ren 的命名准则所选：起约束的队列（binding queue）取自它让每个前提起约束的作用，excess 说队首在一步上多立着的，exchange 说开放步上的交换。本节尚未经独立审查。（P41b 注：本节已经第十四次独立审查；起约束的队列按其动力学改名为只闭合一次的队列，见 §58。）

## 56. 不用公理能走多远（P40）

2026-10-10。Ren 选定路线：“let's aim for a first, then try to archive b”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-axiom-route-levels-and-possibilities.md)）。路线 (a) 见 §53。路线 (b) 是 AI 的表述，Ren 引用了它：

AI 还提出两种不需要前提的机制：“selection between wholes: wholes whose parts sustain them outlast others”与“constraint: a part that degrades its whole removes its own supply”。Ren 回答，整体对自身的实现、理解与更新“also under the selection rules and constraints in theory, but in practice, how this happens, needs more thoughts”。对层级，Ren 写道：“i think it should be the whole, and a weaker version is within the system that one is in, then the self”。§53 留给路线 (b) 的问题是：以依存为界的中心容许搭便车者（`Clearing.centers_disagree`）。

本节是计划 P40（[计划 §10](../history/root-foundation/BECOMING-UNIFICATION-PLAN.md#10-第一部分与第二部分--part-i-and-part-ii)），由本会话完成。它不加公理，问这条路线到达哪一层。核心新增模块 `Becoming.Interdependence`，28 项定理。不用公理的结果放进第一部分（章节 §2 的“供给与返回”与第一部分的总陈述），路线 (b) 的分析与比较放进第二部分（章节 §6.9）。成果记录新增三项：
- [feeding-closure](../../../../theories/becoming/results/records/feeding-closure.md)
- [consumption-ends-with-feeders](../../../../theories/becoming/results/records/consumption-ends-with-feeders.md)
- [closure-verdict-meets-axiom](../../../../theories/becoming/results/records/closure-verdict-meets-continuation-condition.md)

另修订三项记录的界限与下一增量，断言不变：
- [loss-beyond-a-region](../../../../theories/becoming/results/records/loss-beyond-a-region.md)：`alongDependence` 与沿供给推出的范围一致，原是逐项对照，现由 `Clearing.dependenceRegion_iff` 证明；
- [whole-first-and-bounded-centers](../../../../theories/becoming/results/records/whole-and-regions-and-bounded-centers.md)：以依存为界的区域恰是各形成的供给闭包，以它为意义的边界仍是选择；
- [represented-boundary-against-dependence](../../../../theories/becoming/results/records/represented-boundary-against-dependence.md)：多步的依存范围由供给闭包给出，并在 `Overshoot` 中与所表示的边界比较。

```text
Result(s): 复用 derived-extent-limits（Flow.FedBy、Clearing.fedBy_source）、own-count-misses-joint-excess
           （Flow.excess_bounded）、represented-boundary-against-dependence（Web.RenewingOver）、becoming-stepwise-reading
           （Web.UnderminingAt）、loss-beyond-a-region（Clearing.alongDependence、Clearing.loses_beyond、
           Web.LosesBeyond.narrow）、four-cases-of-a-part（Clearing.clearerPart、admitted_without、unsupported_with）、
           closing-needs-net-draw（Web.Admits、Flow.WithheldLevels）、one-axiom-yields-g0（Unrestricted、bounded）、
           significance-retained-within-margin（Web.Retains、Web.Adds、Web.Includes.retains、Web.retains_iff_includes）、
           whole-first-and-bounded-centers（Web.retains_bounded_iff、Web.Retains.within、Clearing.dependenceRegion、
           Clearing.free_rider_loses）；新增上列三项
Delta: Flow.FedClosed、Flow.WithinFeeding（refl、trans、of_fedBy）、Flow.fedClosed_within、Flow.beyond_gives_nothing；
       Flow.Balances.unfed_consumption_ends、unfed_consumption_stops、Flow.unfed_of_feeders_unsupported、
       Flow.Balances.consumption_ends_with_feeders；bounded_whole、Web.retains_bounded_iff_includes、
       Web.retains_bounded_iff_retains、Flow.within_closure_iff_retains；Overshoot（flow、web、balances、acting、taking、
       dependent、closure_whole、ends_through_feeder、steadyFlow、steadyWeb、steady_continues、within_closure_iff_retains）；
       Clearing.fedClosed、dependenceRegion_closed、dependenceRegion_self、dependenceRegion_iff、dweller_beyond、
       closure_supported、within_closure_yet_loses
Supplied premises / correspondence: 不加公理；一般定理的前提是平衡、只有活跃者给予、活动需要支持，以及形成在其活跃的
       每一步从所需条件取用；见证另有只有活跃者取用、只从其所汲取者取用；公理 Unrestricted 只作为比较定理的假设出现；
       供给读作同一步上向所需条件的给予；离散的步、自然数的量；读法与名称是 AI 的，待 Ren
Evidence: 合并检查器回执 20261010T133601.876717Z（1540 项定理、2426 项声明审计、核心闭包 35 个模块、包 33 个模块，全部源声明公理报告
          为空，没有新的生成常量依赖公理）；外围回执 20261010T133831.669969Z
Boundary: 中心想要自身的延续、表示其供给闭包都不推出；闭包之内的损失确实返回也不推出（供给者可以冗余，存量与时机决定
          终结何时到来）；路线 (b) 不主张根据；整体之间的选择没有建模；供给只计同一步的给予，闭包是形成层面的
Integration: 计划 P40（路线 (b)）；回答 §53 留下的以依存为界的中心容许搭便车者：不用公理时，这一损失只在依存到达
             所关闭者时被计入；路线 (b) 到达自身与所在的系统，只在整体是一个供给闭包时到达整体
```

| 声明 | 内容 |
|---|---|
| `Flow.FedClosed`、`Flow.WithinFeeding` | 形成的区域对供给封闭：供给一个成员之延续者都是成员；`g` 在 `f` 的供给闭包之内：含 `f`、对供给封闭的每个区域都含 `g` |
| `Flow.WithinFeeding.refl`、`trans`、`of_fedBy`、`Flow.fedClosed_within` | 闭包含其形成，可传递，含任何一步的每个供给者，本身对供给封闭：所以是含该形成、对供给封闭的最小区域 |
| `Flow.beyond_gives_nothing` | 闭包之外的，在任何一步都不向闭包成员当时所需的条件给予 |
| `Flow.Balances.unfed_consumption_ends`、`unfed_consumption_stops` | 在平衡、只有活跃者给予、活动需要支持之下，形成从第 T 步起在其活跃的每一步都在场并从条件 `c` 取用，而没有被支持者向 `c` 给予：它从第 T 步起至多连续活跃 `c` 在第 T 步的水平那么多步，所以不在此后每一步都活跃 |
| `Flow.unfed_of_feeders_unsupported`、`Flow.Balances.consumption_ends_with_feeders` | 形成活跃时需要 `c`，而从第 T 步起供给其延续的都不被支持，则没有被支持者向 `c` 给予；所以同一界成立，消耗随其供给者终结 |
| `Overshoot.flow`、`web`、`balances`、`acting`、`taking`、`dependent`、`closure_whole` | 两个形成各自以所需一依存于以自身命名的条件，在第 0 步各自供给对方的条件，所以任一个的供给闭包都是整体；第 0 步 `true` 从两个条件各取一个单位 |
| `Overshoot.ends_through_feeder` | 流平衡，只有活跃者给予与取用、只从其所汲取者取用，活动需要支持。第 0 步 `true` 在其所需的唯一条件上更新，在第 1 步仍被支持，而它的汲取侵蚀 `false` 的依存，`false` 供给 `true` 的条件。`false` 从第 1 步起不被支持，`true` 从第 1 步起至多连续活跃一步，从第 2 步起没有任何被支持者 |
| `Overshoot.steadyFlow`、`steadyWeb`、`steady_continues` | 依存相同，各自只从自己的条件取用：流平衡，两者每步都活跃且被支持 |
| `Overshoot.within_closure_iff_retains` | 公理之下，从任一立场、在每个比较上，闭包内的判断就是公理的判断 |
| `Clearing.fedClosed`、`dependenceRegion_closed`、`dependenceRegion_self`、`dependenceRegion_iff` | §53 沿依存的区域对供给封闭、含其形成，恰是各形成的供给闭包：清除者与供给其资源的来源；来源与栖居者没有被供给，各自只含自身 |
| `Clearing.dweller_beyond`、`Clearing.closure_supported` | 栖居者在清除者的闭包之外；闭包之内的每步都被支持，清除者每步活跃，栖居者从第 2 步起不被支持 |
| `bounded_whole` | 以整体为界的意义（各立场的区域都是整体）就是公理 |
| `Web.retains_bounded_iff_includes`、`Web.retains_bounded_iff_retains` | 另一条路径接纳的每个形成都在立场的区域之内、或被第一条接纳之处，以区域为界的意义与包含一样保留；公理之下，这时两个判断一致 |
| `Flow.within_closure_iff_retains` | 一个形成的供给闭包是整体时，公理之下，以闭包为界的判断在每个比较上都是公理的判断 |
| `Clearing.within_closure_yet_loses` | 以供给闭包为界，从清除者的立场，有其部分的水平保留无它时的有意义者；公理之下，从每个立场都不保留；从栖居者的立场、在栖居者自己的闭包内，无它的水平增加栖居者 |

**它回答了什么。**
- **所依存的，不用前提即到达。** 路线 (b) 要求所表示的边界与“what it actually depends on”一致。在形成层面，这读作供给闭包：它只由供给关系定义，不用任何前提，是含该形成、对供给封闭的最小区域；闭包之外的在任何一步都不向闭包所需的条件给予。§53 中各形成的意义止于其依存所及，那个区域恰是推出的供给闭包（`Clearing.dependenceRegion_iff`），所以 P39 的中心分歧不靠规定。P37 中 `alongDependence` 与沿供给推出的范围一致原是逐项对照，现在是定理。
- **约束沿供给而行。** AI 的第二种机制是“a part that degrades its whole removes its own supply”。一般定理给出它的形式：在平衡、只有活跃者给予、活动需要支持之下，供给者都不被支持时，消耗至多持续所耗条件的水平那么多步（`Flow.Balances.consumption_ends_with_feeders`）。`Overshoot` 表明，返回可以越过只覆盖所需条件的边界：一个形成在其所需的唯一条件上更新，跨过这一步保住自身支持，却经其供给者终结。P37 的一步比较（represented-boundary-against-dependence）由此在多步上补全：延续所依存的，到达供给者的延续。
- **闭包之外的不必返回。** `Clearing` 中栖居者在清除者的闭包之外：闭包之内的每步都被支持，清除者始终活跃，而栖居者终结。约束到不了返回不到任何人的损失。
- **路线与公理在哪里相合。** 以整体为界的意义就是公理（`bounded_whole`）。另一条路径接纳的每个形成都在区域之内、或被第一条接纳之处，以区域为界的判断就是公理的判断（`Web.retains_bounded_iff_retains`）。一个形成的供给闭包是整体时总是如此（`Flow.within_closure_iff_retains`），如 `Overshoot`。`Clearing` 中两者分开（`Clearing.within_closure_yet_loses`）。
- **所以路线 (b) 到达自身与所在的系统（AI 的读法，待 Ren）。** 想要自身延续、并表示其闭包的中心，有它自己的理由保留闭包之内的：那里的损失可以返回到它。这解释动机，不是根据。整体之间的选择保留延续的整体：它淘汰 `Overshoot` 的整体，保留 `Clearing` 的整体。所以两种机制都到不了返回不到任何人的损失。路线 (b) 只在整体是一个供给闭包时到达整体，那时它的判断就是公理的判断。公理所加的，是那些损失返回不到任何人的延续的意义，如栖居者的。Ren 写道整体可以实现自身，“like us, we recognize that "we" are the universe/ecosystem that realizes its own existence”。以整体为所表示边界的中心，持有的就是公理的意义（`bounded_whole`）；路线 (b) 要求所表示的边界与实际依存一致，所以只在依存到达整体时给出它。

**作者反审。**
1. **供给只计同一步的给予。** `Flow.FedBy` 要求供给者在同一步向所需条件给予。经条件的延迟输送（这一步给予，以后才被取用）不算供给，所以闭包可能漏掉这样的依存。延迟输送是否算供给，列为开放项。
2. **闭包是形成层面的。** 只要在某一步供给，就在闭包之内；链上各环可以在不同的步，也不按时间先后。所以闭包含已停止供给者，不是当下的依存。按步、按时间先后的依存范围列为开放项。
3. **返回不必然。** 一般定理只说：供给者都不被支持时，消耗终结。闭包之内的损失是否真的返回，取决于有无其他被支持的供给者（冗余），以及存量与时机。`Overshoot` 中只有一个供给者，存量是一。`ends_through_feeder` 是存在性的见证，不说每个闭包之内的损失都返回。
4. **见证的终结是规定的。** 和以往的见证一样，`Overshoot` 的活动由规定给出，见证表明它与平衡、支持与依存相容。终结的推出在一般定理中：见证用 `consumption_ends_with_feeders` 推出 `true` 从第 1 步起至多再活跃一步。
5. **比较用实际流与参照流。** 以扣留水平作的比较保持交换的其余部分不变，所以经动力学返回的终结不能在一个扣留比较中表明。`Overshoot` 在实际的流上表明终结；`steady_continues` 是另一个流（各自只取自己的条件），不是同一个流扣留一个部分。两者的差别是汲取的差别，不是一个部分的有无。
6. **“动机”是读法。** 定理不说中心想要什么，也不模型中心怎样表示其闭包。说表示其闭包的中心有其自身理由保留闭包之内的，是 AI 对路线 (b) 的读法：理由来自损失可以返回到中心。这是动机的解释，不是根据。
7. **整体之间的选择没有建模。** 关于选择的一句只用了两个见证中谁延续，没有群体、复制或竞争的模型。
8. **读法与名称是 AI 的。** `FedClosed`、`WithinFeeding`（供给闭包）与 `Overshoot`（越限，生态学与系统动力学的用语）是 AI 按 Ren 的命名准则所选。供给闭包读“what it actually depends on”与“the system that one is in”，待 Ren。

**检查。**
- 模块先在暂存区对含 `Becoming.Significance` 的核心编译，逐条审计全部 69 项声明（含 Lean 生成的辅助声明），公理报告全部为空。
- 合并检查器对加入模块的包检查一次，通过：回执 20261010T133601.876717Z。`Becoming.Interdependence` 的 28 项定理、34 项声明审计全部空依赖；Lean 生成而依赖 propext 的常量仍是 38 个，没有新增。
- 外围桥接对这个核心重查（20261010T133831.669969Z），闭包中其余 38 个模块的当前字节与已通过回执一致。
- 本节尚未经独立审查。

## 57. 计数自成一个模块（P41）

2026-10-10。按 Ren“please make sure the whole codebase is elegant, structurally and conceptually … if name is not the best to represent our truth, update them as well”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-09-pure-core.md)），把前提给计数的规律加了什么，从 `Becoming.Premises` 与 `Becoming.Openness` 移入新模块 `Becoming.Counting`。这一部分在 P31–P38c 中逐步增长，分在两处：`Becoming.Premises` 本是前提的地图（哪些推出哪些，其余独立，全部满足，每个起约束），`Becoming.Openness` 本说明持续的变化需要所立者之外的交换（静止定理）；计数的规律的后半在 Openness 中，只因为它用到被围住与有限世界的引理。现在 `Becoming.Counting` 导入 `Becoming.Openness`，按一条线陈述：全部八个前提之下，每个选择之下，从某步起被围住时，有限世界中，每个前提都起约束时。成果记录：修订 [whole-law-of-counting](../../../../theories/becoming/results/records/whole-law-of-counting.md)、[counting-under-enclosure](../../../../theories/becoming/results/records/counting-under-enclosure.md) 与 [continued-change-needs-openness](../../../../theories/becoming/results/records/continued-change-needs-openness.md) 的证明引用。

```text
Result(s): 复用 whole-law-of-counting、counting-under-enclosure、continued-change-needs-openness；没有新的结果
Delta: 新模块 Becoming.Counting（130 项定理）：Premises 中自“计数在前提之下”起的部分，前提的名称与选择
       （World.Premise、Premise.Holds、Meets、Premised.meets）留在 Premises 新的“前提的选择”一节；Openness 中自
       “计数在被围住时”起的部分，连同只有环用到的列表引理 exists_of_mem_map、distinct_map_on；名称、陈述与
       证明逐字不变；三节标题由“每组前提”改为“每个选择”，与模块文档一致
Supplied premises / correspondence: 不变
Evidence: 合并检查器回执 20261010T145237.259199Z（1540 项定理、2426 项声明审计，全部源声明公理报告为空，核心闭包 36 个模块，
          包 34 个模块）；外围回执 20261010T145910.464504Z；移动的 191 项声明先在暂存树中逐一以 #print axioms 查过
Boundary: 只是结构；不加任何断言
Integration: 计划 P41；修订三条记录的证明引用与验证范围；模块文档、根模块文档、包 README、章节脊柱表与
             检查器范围随之更新
```

**为什么分开。**

- **三个问题。** 前提的地图回答前提彼此怎样关联，开放回答持续的变化需要什么，计数的规律回答前提给计数加了什么。三个问题各有自己的见证（互利者与 hatch；exposed、throughput 与 holding；队列与环）。第三个问题原先放在前两个模块的末尾，两个模块的文档都要分两半读。
- **依赖。** 计数的规律用到前两者：Premises 的前提，Openness 的被围住、有限世界与普查的界。所以它在两者之后。没有别的模块用到被移动的声明，移动不改变任何其他模块。
- **顺带改正。** 根模块文档中 Premises 与 Openness 的条目没有提到 P38–P38c 的计数结果；Openness 条目中“as does the world in which each of them binds”含糊，现在写明是 `hatch`。

**作者反审。**

*反驳 1：移动声明会不会使记录与引用失效？* 声明名称不变（命名空间不变）。三条记录引用的被移动的声明移到 Counting 的证明引用，相应反例的路径随之改正；其余记录引用的 Premises 与 Openness 的声明都没有移动，已逐一比对。登记检查逐一核对每个引用的声明在其文件中。

*反驳 2：为什么不并入 Population？* Population 不加前提：计数表是计数的全部规律。Counting 说的正是前提加了什么，需要 Space 的世界与 Premises 的前提，而 Population 在它们之下。

*反驳 3：历史文档中对 Openness 的引用？* 研究文档的旧节与审查报告保持原文，按日期读；当前的章节、记录与包文档指向 Counting。

**边界。** 无新数学，无伦理谓词；第十四次独立审查（P34b–P38c）的处理在下一节。

## 58. 第十四次独立审查与更正（P41b）

2026-10-10。按 Ren“let's aim for the strongest claim without axiom, as the first part”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）与“aim a complete theory of becoming, and finish related work”继续。另一 agent（Claude Opus 5.5，未参与撰写）独立审查了 P34b（§48）、P35（§49）、P36（§50）、P36b、P38（§52）、P38b（§54）与 P38c（§55）（[审查](../history/root-foundation/BECOMING-P34B-P38C-REVIEW.md)，对象 `c95f6576`，经六个提交）；P37 与 P39 不在对象之内，只核对第一部分总陈述是否如实转述 P37。它在仓库之外从前导重新编译核心闭包的 34 个模块，回执所列的 2462 条闭包源声明的公理报告全空；闭包的 6697 个常量中依赖公理的只有 38 条编译器生成的 `injEq` 引理，都只依赖 `propext`，与回执所列相同；六个提交的核心与外围回执、源哈希、检查器哈希与保留产物都与提交一致，回执都早于其提交；章节 §9 的计数等于回执；登记检查与四份记录的聚焦检查在快照上通过。P36 只改名：去掉注释后按词元比较，22 个改动的核心文件只有等长的标识符替换，替换是单射，保留运行的 737 条签名在改名之下逐条相同。数学全部接受，对象中没有错误的 Lean 陈述。它写了 32 条探针声明（22 项定理），其 82 个常量不依赖任何公理。问题六项（V1–V6）；最重要的是 V1 与 V2。

```text
Result(s): 更正 whole-law-of-counting（V1、V4、V5、V6）、counting-under-enclosure（V4、V5、V6）、
           continued-change-needs-openness（V6）、map-of-premises（V1、V4）；没有新的成果记录
Delta: Counting：World.enclosed_change_bound_iff；OnceClosedQueue.dependent_any_activity、
       OnceClosedQueue.transmits_any_flow；BindingQueue 与 World.bindingQueue 及以其命名的定理改名为 OnceClosedQueue
       与 World.onceClosedQueue；add_sub_turn_add 移到 Dependence 的算术一节。Premises：World.Finite.not_binds；
       World.FiniteHatch（Relatum、into、flow、web、taking_part、kin、kin_distinct、closed）、World.finiteHatch、
       finiteHatch_decided、finiteHatch_finite、finiteHatch_balanced、finiteHatch_dissipative、finiteHatch_premised、
       finiteHatch_binds_but_census；World.Binds 的说明。说明中 idle 只指不参与流的关系项（hatch_idle），驱动者是
       inactive，空成立是 vacuously
Supplied premises / correspondence: 不变
Evidence: 合并检查器回执 20261010T150853.470895Z（1552 项定理、2445 项声明审计，全部源声明公理报告为空；Dependence 59、
          Premises 59、Counting 132）；外围回执 20261010T151108.093153Z；新声明先在暂存树中从前导编译，核心模块没有输出
Boundary: 不含伦理结论；不替 Ren 选择任何读法；更强的起约束读法列为开放，没有尝试
Integration: 章节第 3、4、11 条，第一部分的总陈述，状态表、进一步的证明与审查，§9 的脊柱表；计划 §10、P36 对照表、
             P38 与 P38c 两行；§52、§55 与英文 P38、P38c 段落的就地注；模块说明、根模块、包 README 与检查器的范围
```

### 58.1 逐项处理

| 项 | 审查所见 | 处理 |
|---|---|---|
| V1 | 起约束的队列让每个关系项以每个关系项所立的水平为所需，所以活动需要支持对任何活动成立，有界传递对任何流成立（探针 `bindingQueue_shape`）；`binding_counting` 相对于 `World.Binds` 是对的，但“八个前提即使都在起作用”“依存与传递起约束”“约束世界而非空成立”读得比定义强；§55 反驳 1 只说见证，没有回答对起约束这一概念的反驳 | 移入核心：`OnceClosedQueue.dependent_any_activity` 与 `OnceClosedQueue.transmits_any_flow`，这一披露由此可检查。`World.Binds` 的说明改为：有东西满足其条件，所以前提不空成立；实例不必排除表示所允许的任何东西。起约束一律写作“每个前提的条件都有实例”：章节第 3 条、第一部分的总陈述、状态表与脊柱表，Counting 与 Premises 的模块说明、根模块、包 README、检查器，记录的主张、局限与反例，计划 P38c 两行与 §55、英文 P38c 段落的就地注。开放项：在每个前提都排除表示所允许者的起约束读法之下，“有某个生起”是否仍是唯一多出的规律；这一读法由 Ren 选择，本节没有尝试 |
| V2 | 计划 §10 把 Ren 的“let's aim for the strongest claim”写成“它是不用公理所能得到的最强陈述”；P38 一行写“在计数上补全”，随后 P38b 与 P38c 又补了两部分；总陈述末句的“完整”没有指明计划 §9 的四项标准 | 计划 §10 中英文改为“以……为目标”并注明原文；P38 一行注明补全的是一般世界中活动的计数在 256 个选择之下的规律；总陈述与第 11 条的末句链到计划 §9 的四项可检查内容，总陈述加一句：第一部分以最强陈述为目标，还没有表明它就是最强的，仍开放的形式问题见 §8 |
| V3 | 总陈述的五处不精确：“每件都已在 Lean 中检查”覆盖了不是 Lean 陈述的话；被围住一句省去“从某步起”与随之的一条；终结之步省去前提；部分与区域不写 P37 定理的前提；计数一条的边界不在原处 | 1“其中每条定理都已在 Lean 中检查”，并写明定理之间的说明不是 Lean 陈述；2 被围住一句用第 4 条的说法，并引 `enclosed_change_bound_iff`；3 终结之步写明普查、体现、平衡与耗散，以及“满足八个前提、活动可判定的有限世界”；4 部分与区域写明比较所用的扣留水平（`Flow.withhold`、`Flow.WithheldLevels`，这是表示上的选择）与平衡的流，`gains_from_supported` 另写平衡、只有活跃者给予、活动需要支持与要求不放松（先重读了 P40 加的“供给与返回”一条，写法与之一致）；5 计数一条后加边界：只是活动的计数，水平与依存的计数、每个选择之下所选前提都起约束时与有限世界中除普查外都起约束时的规律没有陈述 |
| V4 | 三处“恰”或“没有”没有核心定理：被围住时变化界恰在选中平衡、体现与耗散时是规律；没有有限世界使每个前提都起约束；有限世界中除普查外每个条件都可以有实例，这样的有限世界中计数的规律既没有陈述也没有列为开放 | 移入核心：`World.enclosed_change_bound_iff`（不约束变化时，每步多一个的计数由满足这个选择、从某步起被围住的世界实现，不在任何界内）；`World.Finite.not_binds`（由 `Binds.counted` 一行得出）；`World.finiteHatch` 与 `World.finiteHatch_binds_but_census`（去掉闲置地关系项的 hatch 有限、满足八个前提，除普查外每个条件都有实例，而不是每个前提都起约束）。第 4 条“不选耗散时”改为“不同时选中这三者时”，“恰”引新定理；有限世界中除普查外每个前提都起约束时计数的规律列入开放：章节 §8、whole-law-of-counting 与 counting-under-enclosure |
| V5 | counting-under-enclosure 的局限与下一步在 P38c 之后仍说每个前提都起约束时的规律没有陈述；§8 进一步的证明只引到 P35；P36 对照表漏了 `Provisioned.gift → provision`；P38c 把算术引理 `add_sub_turn_add` 放在 Openness | 记录改为指向 whole-law-of-counting（相对于 `World.Binds`），并列出被围住时与有限世界中仍开放的起约束规律；§8 加上 P38、P38b、P38c 与 `Becoming.Counting` 及开放项；对照表加一行；`add_sub_turn_add` 移到 Dependence 的算术一节，紧随 `add_sub_turn` |
| V6 | “idle”有两种意思（`hatch_idle` 不参与流；`drivenQueue` 的驱动者参与每一步，只是不活跃）；`bindingQueue` 以它在定理中的作用命名，不以其动力学；核心仍有金融词 `credits`、`overdraw` | 驱动者改为“不活跃的地关系项 / an inactive ground relatum”；英文“hold idly”（三个前提在见证中空成立）改为“hold vacuously”，与中文“空成立”一致；idle 只留给不参与流的关系项。起约束的队列改名为只闭合一次的队列（`OnceClosedQueue`、`World.onceClosedQueue`，审查另提的 `SingleClosureQueue` 也合准则）：除一步外每步开放，在那一步闭合并失去多立着的。旧名留在历史条目、保留的运行、旧回执与审查文件中，按计划 §10 对照表读。`credits`、`overdraw` 属于整个核心的用语，列为按 Ren 命名准则的下一次清理的候选，本节不改 |

### 58.2 新的已检查声明

| 声明 | 内容 |
|---|---|
| `World.enclosed_change_bound_iff` | 从某步起被围住的世界中，从某步起的变化界是一个选择之下的计数规律，恰当这个选择约束变化（选中平衡、体现与耗散） |
| `OnceClosedQueue.dependent_any_activity`、`OnceClosedQueue.transmits_any_flow` | 只闭合一次的队列的网对任何活动都需要支持，对任何流都在 1 + E 之内传递每个依存：这两个前提在其中只是条件有实例 |
| `World.Finite.not_binds` | 没有有限世界使每个前提都起约束 |
| `World.FiniteHatch`、`World.finiteHatch` 与其 `_finite`、`_balanced`、`_dissipative`、`_premised` | 去掉地关系项的 hatch：只有食物、亲代与子代，有限、平衡、耗散，满足八个前提 |
| `World.finiteHatch_binds_but_census` | 它有限、满足八个前提、不是每个前提都起约束，而除普查外每个条件都有实例 |
| `add_sub_turn_add` | 移到 Dependence 的算术一节；陈述与证明不变 |

### 58.3 作者反审

*反驳 1：起约束只是条件有实例，`binding_counting` 是否因此无意义？* 不是。它回答的是第十三次审查的问题：三个前提在开放的队列中空成立，规律之少是否来自空成立；答案是不，只要每个条件都有实例，规律仍只多出“有某个生起”。V1 说的是这一回答的范围：它不回答更强的起约束读法。更强的读法须先说明“排除表示所允许者”指什么（对活动、对流、对水平），这是读法的选择，所以列为开放而交给 Ren。

*反驳 2：新定理是否只是把探针搬进核心？* 是，按审查的修正建议；它们把散文中的“恰”“没有”变成可检查的陈述，没有新的数学主张。

*反驳 3：有限的 hatch 是否说明有限世界中的起约束规律也只多出“有某个生起”？* 不说明。它只表明除普查外的条件在有限世界中可以都有实例；每个这样的计数表是否都由一个这样的有限世界实现，没有给出，所以列为开放。

*反驳 4：为什么不同时清理 `credits`、`overdraw`？* 它们分布在八个核心模块中（Dependence、Return、Horizon、Joint、Substitution、Generation、Metaethics 与 Ranking，Ranking 中最多），改名牵涉许多记录与审查文件的对照；按 Ren 的命名准则，它们应在一次整体清理中处理，与本节的审查处理分开。

**边界。** 无伦理谓词；没有新的成果记录，断言的数学不变或只是补上散文已说的；更强的起约束读法、每个选择之下所选前提都起约束时的规律、有限世界中除普查外都起约束时的规律、水平与依存的计数在前提之下，仍开放。第十四次审查检查了 §48 的处理与 §49、§50、§52、§54、§55；§47.1–47.4 的处理、§51、§53、§56、§57 与本节尚未经独立审查。

## 59. 单位所承载的：每一分辨率下的静止（R1）

2026-10-10。按 Ren“let's push as far as possible and if we see a stronger claim that can be make and is important, give it a try. we push pareto frontier”与“keep going please, agree with direction”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-pareto-frontier.md)）。这一方向读作：每个主张取其成立的最强形式，并以只缺一个前提的见证标出它失效的确切边界。此前列出的难题之一是表示的范围，即哪些规律是量与步的表示方式的产物；这里处理量的单位。脊柱以一个固定单位的自然数计量。按这个单位读，耗散说取用封闭家族的形成给回的至少比取用的少一个单位，所以每次交换至少损失一个单位，静止定理与开放的规律都以这些损失抵扣所立者。新模块 `Becoming.Resolution`（导入 `Becoming.Openness`）让单位在每步可以细分，把属于动力学的与属于固定单位的分开。成果记录：[rest-at-every-resolution](../../../../theories/becoming/results/records/rest-at-every-resolution.md)。

```text
Result(s): 新记录 rest-at-every-resolution；复用 continued-change-needs-openness（所立者的普查及其存量、围住所立者的步、
           exposed 的持有者）与 no-finite-part-bears-taking（耗散、封闭家族、DissipatesOn.replenishment_takers）
Delta: Flow.BalancesAt r：单位跨过第 t 步分为 r t 个更细的单位，r 恒为一时就是 Balances；损失的规律 losses_invariant、
       losses_bound 与量子的规律 Flow.quantum_bound、Flow.quantum_not_recurring；单位固定时取用停止 Flow.taking_stops；
       按比例的损失 Flow.DissipativeBy q 之下交换的规律 Flow.exchange_bound、Flow.exchange_not_recurring 与增长的规律
       World.growth_bound、World.growth_not_recurring、World.arising_not_recurring；见证 Asymptote、Circulation、
       Emission、Alternation 与边界定理 rest_needs_quantum、exchange_needs_quantum、arising_needs_quantum、
       arising_needs_proportion
Supplied premises / correspondence: 单位只细分（R T = 1，R (t + 1) = r t · R t，0 < r t）；按比例的损失是前提，是脊柱一单位
       损失的无单位对应，不是推出的；世界的规律另要活动的普查、关系项都体现、从 T 起每步被围住
Evidence: 合并检查器回执 20261010T155424.663562Z（1649 项定理、2571 项声明审计，全部源声明公理报告为空；Resolution 97，核心闭包 37
          个模块），外围回执 20261010T161037.642977Z；Becoming.Resolution 的声明先在暂存树中以已提交的核心源从前导编译，逐条 #print axioms
          全部为空
Boundary: 离散步；有理量，单位不变粗；界是否可达未证；交换的规律只对固定的封闭家族陈述；尚无独立审查
Integration: 回答 continued-change-needs-openness 的下一步“带比率或连续量的总水平”中有理量的部分；计划 §10 R1；章节 §9 的
             脊柱表与第一部分的开放项；模块说明、根模块、包 README 与检查器的范围
```

**机制。**

- **单位可以细分。** 跨过第 t 步，单位分为 r t 个更细的单位：步前的水平以更细的单位计，是以较粗单位计的 r t 倍（`Flow.BalancesAt`）。R 计每一步的单位数，以第 T 步的单位为一，R (t + 1) = r t · R t。以第 T 步的单位读，一个水平 n 在第 t 步是 n / R t，所以细分以越来越细的有理数表示量，而动力学不变。在耗散之下，封闭家族的存量连同取用者不多于 r t 乘此前的存量（`Flow.BalancesAt.lowers`）；r 恒为一时就是脊柱的情形。
- **损失的规律。** 一个在更细单位下不上升的量，若每步 q 乘余下的连同 k 个量子（每个是 R (t + 1) 个更细单位）不多于 q 乘此前所有的，那么自 T 起计到的量子不多于 q 乘该量在 T 的值（`losses_invariant`、`losses_bound`）。证明只是算术：不变量 q·s + K·R ≤ q·s_T·R 跨过一步乘以 r。由此，封闭家族损失至少 1/q 单位的步不多于 q 乘其存量，不复现（`Flow.quantum_bound`、`Flow.quantum_not_recurring`）。单位固定时，每个取用的步至少损失一个单位，所以取用停止（`Flow.taking_stops`）；r 恒为一时这就是脊柱的 `Flow.Balances.taking_ceases`。
- **按比例的损失。** 每个形成给回封闭家族的至多是所取用的 q/(q+1)（`Flow.DissipativeBy q`）。这一比例与单位无关。于是：
  - 取用至少 1/p 单位的形成使家族至少损失 1/(p(q+1)) 单位，所以这样的取用逐个逐步计数不多于 p(q+1) 乘存量（`Flow.BalancesAt.takers_lose`、`Flow.exchange_bound`）；
  - 增长至少 1/p 单位的关系项所得是被给予的，所以在围住它的家族中，补给至少是 R (t + 1)/p 乘增长者的数目，而按比例的损失使家族至少损失补给的 1/q（`Flow.BalancesAt.gain_given`、`Flow.BalancesAt.lowersBy`、`Flow.BalancesAt.gainers_lose`）；在有普查、关系项都体现、从 T 起每步被围住的世界中，围住的家族随步变化，所立者的总水平等于它的存量（`Web.StandingCensus.stock_eq`），所以增长者逐个逐步计数不多于 p q 乘 T 时所立者的总水平（`World.growth_bound`）；
  - 体现的关系项生起时从水平零开始，所以这一尺度的生起是这一尺度的增长（`World.arising_not_recurring`）。
- **边界。** 每个见证都在单位无尽细分时平衡且耗散，只缺一个前提：
  - `Asymptote` 一个取用者从一个池取用而不给回，按每个比例耗散；恰在单位于任意晚的步细分时它在任意晚的步取用（`Asymptote.exchange_recurs_iff`），池在每个细分的步下降，始终高于取用者的需要；所取用的缩小到每个量子之下。
  - `Circulation` 每步从池取用第 0 步的一整个单位，给回其余，只损失下一步的一个单位；所立者被列出，每步围住所立者，交换不息；由交换的规律，它不按任何比例耗散（`Circulation.not_dissipativeBy`）。
  - `Emission` 一个池每步取用下一步的两个单位，给回一个给当步生起的新关系项；它有普查、关系项都体现、每步被围住，并按比例耗散（给回一半）；每步都有新关系项生起，立于下一步的一个单位，即第 0 步单位的 2^-(t+1)。
  - `Alternation` 两侧轮流持有第 0 步的一整个单位与当步的一个单位；持有者取用全部并给另一侧除下一步一个单位以外的全部；它有普查、关系项都体现、每步被围住，一整个单位在任意晚的步生起；由增长的规律，它不按任何比例耗散（`Alternation.not_dissipativeBy`）。

**作者反审。**

*反驳 1：细分单位只是换记号，没有新内容？* 不是。在固定单位下，自然数的耗散蕴含每次交换至少损失一个单位，这是一个量子化的假设，此前没有陈述。见证说明：让损失随单位缩小，脊柱静止定理的其余前提都成立，其结论却不成立。所以静止定理依赖这一量子；细分之下仍成立的是损失的规律，以及按比例的损失连同最小尺度所给的界。

*反驳 2：按比例的损失是否把静止偷偷放进前提？* 它不提静止、有限或步数；它是每次转移的效率上界。单靠它不给出静止：`Emission` 按比例耗散，生起仍不息，只是尺度趋于零。静止要它连同最小尺度一起，而缺少最小尺度的情形恰是 `Asymptote` 与 `Emission`。

*反驳 3：见证满足的是静止定理的全部其余前提，还是只满足一部分？* `Emission` 与 `Alternation` 满足 `World.rests_enclosed` 与 `World.arising_opens` 的全部前提（普查、体现、耗散、每步被围住），只把平衡换为细分分辨率下的平衡；`Circulation` 满足 `World.exchange_stops` 的全部前提（所立者的普查、耗散、每步围住所立者），平衡同样换掉；`Asymptote` 对固定的封闭家族满足 `Flow.taking_stops` 的前提，只是单位细分。边界定理逐项陈述这些前提，由 Lean 检查。

*反驳 4：`Alternation` 与 `Circulation` 不按任何比例耗散，是直接验证还是推出？* 由两条规律推出：若按某比例耗散，增长的规律禁止一整个单位的生起复现，交换的规律禁止一整个单位的取用复现，而两者都复现。这同时检验了两条规律不是空的。

*反驳 5：增长的计数只数普查列表中的关系项，会不会漏掉？* 增长至少 1/p 单位的关系项在步后水平为正（R 为正），体现之下活跃，所以在普查列表中；`World.growth_not_recurring` 用的正是这一点。

*反驳 6：模块名与已有名称冲突？* 初稿的见证名 `Transfer` 与 `Becoming.Admission` 的 `Transfer` 冲突，检查器的第一次运行（回执 20261010T154024.599588Z，失败，保留）在根模块处报错；改名为 `Alternation`，它也更准确地描述两侧轮流持有的结构。其余声明已逐一对照包内所有声明，没有冲突。

**读法（AI，待 Ren）。** 有界效率之下，被围住的生成，任何固定尺度的都会停止；在围住之内只能以越来越细或越来越接近无损的方式继续。“生起不息需要开放”不依赖单位的形式是：固定尺度的生起不息需要开放，或需要损失的比例趋于零。这把开放的规律从整数的产物变为一个物理上可读的陈述。

**边界。** 离散步；量是细分后的有理数，单位不变粗；连续时间与实数量仍开放；界是否可达未证；交换的规律以固定的封闭家族陈述；按比例的损失是前提；没有伦理谓词；尚无独立审查。

### 59.1 下降、止息与储备（R1b）

2026-10-10。同一方向的下一步。R1 在每一分辨率下给出了生起的一半；静止定理还说止息停止，而储备推迟终结而不逃脱（`Web.Carries.lasts`）同样以每步至少一个单位计。

```text
Result(s): 修订 rest-at-every-resolution（同一分辨率与同一前提之下的更强结论，加上储备的最小花费，不另立记录）；新依赖
           reserve-defers-ending（储备 Web.Carries 与 Web.Carries.lasts）
Delta: Web.Loses、Web.losers；Flow.BalancesAt.loss_taken、Flow.BalancesAt.losers_lose；下降的规律 World.fall_bound、
       World.fall_not_recurring；World.ceasing_not_recurring；每一分辨率下的静止 World.rests_at_resolution；储备
       Web.CarriesAt、Web.CarriesIn、Web.carriesIn_one、Web.Carries.carriesAt、Web.CarriesAt.lasts；见证 Dwindle 与边界
       定理 reserve_needs_quantum
Supplied premises / correspondence: 下降与止息的规律与增长的规律前提相同；储备的规律另要从 T 起不被支持、活动可判定，
       并以每个活跃的步至少花去 1/p 单位为前提（最小花费，是脊柱一单位下降的无单位对应，不是推出的）
Evidence: 合并检查器回执 20261010T163746.432774Z（1662 项定理、2590 项声明审计，全部源声明公理报告为空；Resolution 110 项定理、145 项声明审计），
          外围回执 20261010T164738.513555Z；新声明先在暂存树中以已提交的核心源从前导编译，逐条 #print axioms 全部为空
Boundary: 同 §59；储备的最小花费是前提；Dwindle 只有一个关系项；尚无独立审查
Integration: 记录 rest-at-every-resolution；计划 §10 R1b；章节 §9 的脊柱表与第一部分；模块说明、根模块、包 README 与检查器的范围
```

**机制。**

- **下降的规律。** 跨过一步下降至少 1/p 单位的关系项，所失去的是被取走的：平衡之下，r t 乘步前的水平连同所得等于步后的水平连同所取，所以所取至少是下降的量（`Flow.BalancesAt.loss_taken`）。在围住它的家族中，取用至少是 R (t + 1)/p 乘下降者的数目，按比例的损失使家族至少损失取用的 1/(q+1)（`Flow.BalancesAt.losers_lose`）。所以在增长的规律的前提之下，下降者逐个逐步计数不多于 p(q+1) 乘 T 时所立者的总水平（`World.fall_bound`），不复现（`World.fall_not_recurring`）。
- **止息。** 体现的关系项止息时降到零，所以立于至少 1/p 单位者的止息是这一尺度的下降（`World.ceasing_not_recurring`）。连同 R1 的生起：在每一分辨率下，这一尺度的生起与止息都不复现（`World.rests_at_resolution`）。这是静止定理在每一分辨率下的形式：单位固定时，归于静止说的是从某步起什么都不生起、不止息；细分之下说的是，任何固定尺度的生起与止息都不复现。
- **储备。** 脊柱的储备在每个活跃而不被支持的步至少减少一个单位，所以推迟终结而不逃脱（`Web.Carries.lasts`）。只要求储备在更细单位下下降的读法（`Web.CarriesIn`）在单位固定时就是脊柱的储备（`Web.carriesIn_one`），而单位细分时储备可以永远下降。每一分辨率下的形式是 `Web.CarriesAt`：每个活跃而不被支持的步至少花去 1/p 单位；于是从 T 起不被支持时，形成活跃的步不多于 p 乘其在 T 的储备（`Web.CarriesAt.lasts`），证明用的是同一条损失的规律；脊柱的储备是 p 为一、单位固定的情形（`Web.Carries.carriesAt`）。
- **边界。** `Dwindle`：单位每步减半；一个从不被支持的形成每步都活跃；储备以当步单位计为 2^t + 1，在更细单位下每步下降（`Dwindle.carriesIn`），以第 0 步单位计是 1 + 2^-t，从上方趋于一个单位而永不到零；对任何 p，都有活跃的步花去不到 1/p 单位（`Dwindle.not_carriesAt`、`reserve_needs_quantum`）。

**作者反审。**

*反驳 7：下降的规律只是增长的规律的镜像？* 机制相同，界不同。增长者所得是被给予的，下降者所失是被取走的；按比例的损失对补给的约束是至少损失其 1/q，对取用的约束是至少损失其 1/(q+1)，所以增长的界是 p q，下降的界是 p(q+1)。两条都由同一条损失的规律推出。

*反驳 8：止息为什么需要体现？* 不体现的关系项可以水平为正而不活跃，止息只说活动停止。体现使止息时水平降到零，所以止息是下降；静止定理同样用这一前提。

*反驳 9：`Dwindle` 永远活跃而不被支持，是否违反脊柱的前提？* 它满足细分单位下的储备（`Web.CarriesIn`），只缺每步的最小花费。单位固定时 `Web.CarriesIn` 就是 `Web.Carries`（`Web.carriesIn_one`），而 `Web.Carries.lasts` 不容这样的储备永远维持活动；所以它恰在量子处。

*反驳 10：这是新结果还是同一结果的扩展？* 同一分辨率与同一前提之下的更强结论，加上储备的最小花费这一前提，归入同一记录；`World.rests_at_resolution` 是 R1 的 `World.arising_not_recurring` 与止息的合取。

**读法（AI，待 Ren）。** 有界效率之下，被围住的世界在每一分辨率下归于静止：任何固定尺度的生起与止息都停止，能继续的只有越来越细或越来越接近无损的变化。储备也是这样：没有每步的最小花费，一个不被支持的形成可以靠越来越细的储备永远活跃。

**边界。** 同 §59；储备的最小花费是前提；见证只有一个关系项；尚无独立审查。

### 59.2 按比例的损失只需对家族成立；每一尺度的最小损失只给出交换（R2）

2026-10-10。同一方向：把前提推到最弱。R1 的按比例损失原先对每个形成陈述，每条规律的证明却只用它对封闭家族的总和。本节把前提改为对家族陈述，并检验另一种减弱：只要求每一尺度的转移都有最小损失。

```text
Result(s): 修订 rest-at-every-resolution（同一记录：前提减弱；加入最小损失之下的交换律与见证 Trickle）
Delta: Flow.DissipatesBy 改为对家族陈述（封闭家族得回的至多是从它取走的 q/(q+1)），逐个形成的形式是充分条件
       Flow.DissipatesBy.of_each；R1、R1b 的每条规律以同样的陈述在这一较弱前提下成立；每一尺度的最小损失
       Flow.LosesAtSize、Flow.LosesAtEverySize、Flow.LosesAtSize.over、Flow.DissipatesOn.give_le、
       Flow.BalancesAt.takers_lose_least、Flow.exchange_bound_of_least_loss、Flow.exchange_not_recurring_of_least_loss、
       Flow.losesAtSize_of_each；quarter、quarter_eq、halving_pos；见证 Trickle 与边界定理 growth_needs_proportion
Supplied premises / correspondence: 最小损失的交换律另要脊柱的耗散（每个形成给回封闭家族的不多于所取）；m 不随步变化
Evidence: 合并检查器回执 20261010T165248.121581Z（1705 项定理、2645 项声明审计，全部源声明公理报告为空；Resolution 153 项定理、200 项声明审计），
          外围回执 20261010T165548.911356Z；新声明先在暂存树中以已提交的核心源从前导编译，逐条 #print axioms 全部为空
Boundary: 同 §59；比对家族的比例更弱而仍给出增长的规律的前提没有陈述；Trickle 的转移者不活跃；尚无独立审查
Integration: 记录 rest-at-every-resolution；计划 §10 R2；章节 §9 的脊柱表与第一部分；模块说明、根模块、包 README 与检查器的范围
```

**机制。**

- **对家族的比例。** 交换、增长与下降的规律都经过同一步：在封闭家族上，q + 1 乘补给不多于 q 乘取用（此前由逐个形成的条件求和得到）。所以 `Flow.DissipatesBy q` 现在就是这一对家族的不等式：家族的交换合起来至少失去所取的 1/(q+1)。逐个形成都如此时它成立（`Flow.DissipatesBy.of_each`），反之不然：一个形成可以无损，只要家族合起来失去一定比例。R1、R1b 的每条规律以同样的陈述在这一较弱的前提下成立；按比例耗散的见证（Asymptote、Emission）经 `of_each` 满足它，不按任何比例耗散的见证（Circulation、Alternation）连这一较弱前提也不满足，否定更强。
- **每一尺度的最小损失。** 另一种减弱：只要求取用至少 1/p 单位的转移失去至少 1/m 单位，m 不随步变化（`Flow.LosesAtSize`；对每个 p 有这样的 m 时是 `Flow.LosesAtEverySize`）。在脊柱的耗散之下（每个形成给回封闭家族的不多于所取，`Flow.DissipatesOn.give_le`），取用至少 1/p 单位的形成逐个逐步计数不多于 m 乘家族在 T 的存量（`Flow.exchange_bound_of_least_loss`），不复现（`Flow.exchange_not_recurring_of_least_loss`）。逐个形成按比例的损失给出这样的最小损失（`Flow.losesAtSize_of_each`）。
- **边界。** `Trickle`：单位每步分为四个（`quarter`）；两侧轮流持有第 0 步的一整个单位，第 t 步由 2^t 个水平为零的转移者分成 2^t 份交给另一侧，每份失去下一步的两个单位。以第 0 步单位计，每份约 2^-t，每份的损失约 2·4^-(t+1)，与所取之比趋于零。它有普查、关系项都体现、平衡、耗散、每步被围住；每一尺度都有最小损失（`Trickle.losesAtEverySize`），所以每个固定尺度的转移停止（`Trickle.exchange_stops`）；而一整个单位在任意晚的步生起，不按任何比例耗散（`growth_needs_proportion`）。

**作者反审。**

*反驳 11：把 `DissipatesBy` 改为对家族陈述，是否改变了已记录的结果？* 名称与定理的陈述不变，前提变弱，所以每条定理变强；逐个形成的形式经 `of_each` 仍给出它们。记录、模块说明与章节中“每个形成给回的至多是所取的 q/(q+1)”改为“每个封闭家族得回的至多是从它取走的 q/(q+1)”。§59 与计划 R1 的文字记录当时的形式，按原文保留。

*反驳 12：`Trickle` 的转移者不活跃，是否钻了空子？* R1 与本节的定理都不要求取用者活跃。转移者是水平为零的关系项；要求只有活跃者取用的变体没有构造。这里要说明的只是：每一尺度的最小损失不给出增长的规律。

*反驳 13：这是否说明增长的规律需要对家族的比例？* 只说明每一尺度的最小损失不够。计数转移只需最小损失；计数关系项的增长需要更多，因为一份得到可以分给任意多的转移。比对家族的比例更弱而仍给出增长的规律的前提没有陈述。

**读法（AI，待 Ren）。** 按比例的损失不是表示的偶然。增长的规律计数关系项得到多少，而一份得到可以分给任意多的转移；只有损失随所转移的量成比例，分割才不能把损失分没，每一尺度的最小损失做不到这一点。所以“被围住的生成停止”的物理前提可以读作：交换合起来失去所转移的一定比例。这也部分回答了向 Ren 提出的问题：前提现在是对家族的比例，逐个转移的效率上界只是它的充分条件。

**更正（2026-10-11，第十五次独立审查 W1、W2、W5；原文保留）。** 上面读法中“只有损失随所转移的量成比例，分割才不能把损失分没，每一尺度的最小损失做不到这一点”过度：对家族总和的任何前提都不受分割影响，审查的探针 ReplenishedLoses（被给予至少 1/p 单位的封闭家族至少失去 1/m 单位）严格弱于对家族的比例而仍给出增长的规律；分割打败的只是逐个转移的前提，Trickle 所用的是每步无界多的转移。本节开头“把前提推到最弱”应为“推向更弱”。Supplied premises 一行中“脊柱的耗散（每个形成给回封闭家族的不多于所取）”是证明所用的，脊柱的耗散本身要求取用的形成给回的至少少一个单位。见 §59.4。

**边界。** 同 §59；比对家族的比例更弱而仍给出增长的规律的前提没有陈述；Trickle 的转移者不活跃；尚无独立审查。

### 59.3 量的规律：按比例的损失为交换的总量定下最小的界（R3）

2026-10-11。同一方向：把结论推到最强。R1 至 R2 的规律都计数：取用、增长或下降至少 1/p 单位的有多少次。它们的证明都经过同一个每步的不等式：q + 1 乘余下的存量连同被取走的，不多于 q + 1 乘此前的存量（`Flow.BalancesAt.lowersTaking`）。这个不等式本身给出一条不提尺度的规律。本节在 Ren 2026-10-11 选择 A 之前完成，与 §59.4 一并提交；按 Ren，这一线作为研究笔记。

```text
Result(s): 修订 rest-at-every-resolution（同一记录：加入量的规律与其最小性；计数的规律改由它证明；Trickle 中总量无界）
Delta: refinedSum、refinedSum_invariant、refinedSum_mono、refinedSum_mul、refinedSum_marks、counts_of_amounts；
       Flow.uptake_bound、Flow.replenishment_bound、Flow.takersAbove_le、Flow.BalancesAt.gainers_le、
       Flow.BalancesAt.losers_le；World.taken_bound、World.given_bound；Flow.exchange_bound、World.growth_bound、
       World.fall_bound 改由量的规律证明（陈述不变）；powers、powers_pos、bernoulli_powers、powers_outgrow、
       quarter_pos；见证 Geometric 与 amount_sharp；Trickle.uptake、Trickle.throughput_unbounded、
       throughput_needs_proportion
Supplied premises / correspondence: 同 §59.2；量的规律只用 R T = 1 与 R (t + 1) = r t · R t
Evidence: 与 §59.4 同一回执 20261010T180948.563939Z（1788 项定理、2748 项声明审计，全部源声明公理报告为空；Resolution 207 项定理、261 项声明审计），
          外围回执 20261010T182121.048951Z；新声明先在暂存树中以已提交的核心源从前导编译，逐条 #print axioms 全部为空
Boundary: 离散步；总量以第 T 步的单位计，是有理数的和，不含实数量与连续时间；计数的界是否可达未证；尚无独立审查
Integration: 记录 rest-at-every-resolution；计划 §10 R3；章节 §9 的脊柱表与第一部分；模块说明、根模块、包 README 与检查器的范围
```

**机制。**

- **量的规律。** `refinedSum r ℓ T n` 把从 T 起 n 步的量相加：每步的量以下一步的单位计，再随单位在其后每步细分。它是以第 T + n 步的单位计的总量，除以 R (T + n) 就是以第 T 步的单位计。不变式（`refinedSum_invariant`）：每步 c 乘余下的连同该步的量不多于 c 乘此前的，则 c 乘余下的连同自 T 起的总量不多于 c 乘 T 时的量。按比例的损失给出 c = q + 1、量为被取走的（`lowersTaking`），与 c = q、量为得回的（`lowersBy`）。所以从 T 起封闭的家族被取走的总量至多是它在 T 的存量的 q + 1 倍，得回的至多 q 倍（`Flow.uptake_bound`、`Flow.replenishment_bound`）。在世界中，围住所立者的家族每步可以不同，从所立者被取走的与给予所立者的总量同样有界（`World.taken_bound`、`World.given_bound`）。这条规律不提任何尺度。
- **最小性。** `Geometric`：单位每步分为 q + 1 个，一个形成每步取走整个封闭的池，给回 q/(q+1)。池以第 t 步单位计立于 s·q^t，以第 0 步单位计立于 s·(q/(q+1))^t。q + 1 乘余下的连同被取走的总量恰是 q + 1 乘池（`Geometric.exact`）。由伯努利不等式（`bernoulli_powers`），(q+1)^n 超过 q^n 的每个倍数（`powers_outgrow`），所以对每个 m，被取走的总量到达 (q+1)s 的 1/m 之内（`amount_sharp`）。q + 1 不能换成更小的数。
- **计数是推论。** 取用至少 1/p 单位的形成每个都取走至少 1/p 单位（`Flow.takersAbove_le`）；增长至少 1/p 单位的关系项每个都被给予至少 1/p 单位（`Flow.BalancesAt.gainers_le`）；下降至少 1/p 单位的关系项每个都被取走至少 1/p 单位（`Flow.BalancesAt.losers_le`）。量子也是量：第 T 步单位的量子之和就是它们的个数乘 R (T + n)（`refinedSum_marks`）。所以计数不多于 p 乘量的界（`counts_of_amounts`）。交换、增长与下降的规律改由此证明，陈述与界都不变；生起、止息与每一固定尺度的静止随之。
- **边界。** `Trickle` 每一尺度都有最小损失，每个固定尺度的转移停止，而被取走的总量每步至少是第 0 步的一个单位，超过它的每个倍数（`Trickle.throughput_unbounded`、`throughput_needs_proportion`）。所以每一尺度的最小损失不给出量的规律。

**作者反审。**

*反驳 14：量的规律是否只是交换律的另一种写法？* 不是。交换律计数，需要尺度 1/p 与只细分的单位；量的规律为总量定界，不提尺度。它推出每个尺度的计数，反之不然：Trickle 有每个尺度的计数界，总量却无界。

*反驳 15：最小性是否只对一个特别的见证成立？* 最小性说的是常数 q + 1 不能更小：对每个 q 与每个池，有平衡、按比例 q 耗散、每步封闭的流，被取走的总量任意接近 q + 1 乘池。它不说每个流都接近这个界。

*反驳 16：交换、增长与下降的证明改经量的规律，是否改变了记录的结果？* 陈述、前提与界都不变，只是证明的路径。原来的逐步引理（`Flow.BalancesAt.takers_lose`、`gainers_lose`、`losers_lose`）保留，仍成立。

**读法（AI，待 Ren）。** 按比例的损失给出的是一个总量：被围住的家族一共能交换的，不超过它所立的 q + 1 倍。计数的规律是这个总量在某个尺度下的读数。只有每一尺度的最小损失时，总量可以无界，变化以越来越多、越来越小的份额继续。

**边界。** 同 §59；离散步；总量以有理的单位计，不含实数量与连续时间；计数的界是否可达未证；尚无独立审查。

### 59.4 算入细分：零前提的每一分辨率下的静止；第十五次独立审查（R4）

2026-10-11。向 Ren 提出的问题是：每个封闭家族失去从它取走的一定比例，是否作为理论的前提。作者列出六个选项（A 保持整单位，每次交换至少损失一个最小量；B 至 F 是比例、最小损失与无新前提的各种形式，见[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-difference-in-becoming.md)）。Ren 的回答：

>
>

作者的读法（AI，待 Ren）：最小差异属于生成本身，不属于表示；“the case of 0”指零前提的情形，即不添前提的每一分辨率下的静止；其余选项与第十五次独立审查的探针作为研究笔记。

```text
Result(s): 新增 rest-with-refinement-counted；修订 rest-at-every-resolution（审查更正；边界定理加入在固定单位下不平衡；作为不算入细分时的研究笔记）
Delta: Flow.withRefinement、Web.withRefinement、Flow.withRefinement_taken、Flow.withRefinement_given、
       Flow.balancesAt_iff_withRefinement、Flow.withRefinement_dissipatesOn_iff、Flow.ClosedAt.of_withRefinement、
       Flow.ClosedAt.withRefinement、Flow.Enclosed.of_withRefinement、Flow.refinement_gives_nothing、
       Flow.taking_needs_refinement；World.after 与 after_counted、after_embodied、after_balanced、after_dissipative、
       after_enclosed、after_recurs、rests_of_after；World.rests_unrefined、World.rests_refinement_counted、
       World.arising_opens_refinement_counted、World.arising_needs_refinement；Web.CarriesIn.lasts_unrefined；
       refinement_feeds_witnesses；Asymptote.not_balanced、Emission.not_balanced、Alternation.not_balanced（边界定理
       rest_needs_quantum、arising_needs_quantum 加入这一合取项）；total_map_some、mem_map_some、of_mem_map_some、refine_eq
Supplied premises / correspondence: 算入细分是一种读法（Ren 的方向，作者的展开待 Ren），不是推出的；定理对两种读法都陈述
Evidence: 合并检查器回执 20261010T180948.563939Z（1788 项定理、2748 项声明审计，全部源声明公理报告为空；Resolution 207 项定理、261 项声明审计），
          外围回执 20261010T182121.048951Z；新声明先在暂存树中以已提交的核心源从前导编译，逐条 #print axioms 全部为空
Boundary: 离散步；单位只细分；算入细分的流以 Option 为形成，不是同一种关系项的世界；尚无独立审查
Integration: 记录 rest-with-refinement-counted 与 rest-at-every-resolution；计划 §10 R4；章节 §9 的脊柱表与第一部分；
             模块说明、根模块、包 README 与检查器的范围；审查保存为 BECOMING-R1-R2-REVIEW.md
```

**机制。**

- **细分是一个给予。** 单位跨过第 t 步分为 split t + 1 个更细的单位时，在细分的单位下平衡是：下一步的水平连同被取走的，等于 (split t + 1) 乘此前的水平连同被给予的。(split t + 1) 乘水平就是水平加 split t 乘水平（`refine_eq`）。把 split t 乘水平读作又一个形成给予的，它什么也不取，平衡就成了脊柱的平衡（`Flow.balancesAt_iff_withRefinement`）。这个形成是 `Flow.withRefinement` 中的 `none`：它在场，取用为零，给每个条件 split t 乘其水平；`Web.withRefinement` 使它从不活跃，不要求、不汲取任何东西。
- **耗散排除只给不取。** 脊柱的耗散要求每个在场的形成给回封闭家族的不多于所取，取用时至少少一个单位。细分不取，所以在被耗散的封闭家族上它什么也不能给：算入细分的流在一个家族上耗散，恰当流自身的形成在其上耗散并且 split t 乘家族的存量为零（`Flow.withRefinement_dissipatesOn_iff`）。一步被围住时，细分的给予在封闭家族之外为零（封闭），在家族之内也为零（耗散），所以它什么也不给任何条件（`Flow.refinement_gives_nothing`；构造性证明，不判定成员）。
- **零前提的静止。** 于是算入细分、耗散并从 T 起每步被围住时，细分从 T 起什么也不给，在细分的单位下平衡从 T 起就是脊柱的平衡，流自身从 T 起耗散、被围住。把世界从 T 起读（`World.after`），脊柱的静止定理 `World.rests_enclosed` 给出它的静止，再读回原世界（`World.rests_of_after`）：生起与止息都不复现（`World.rests_refinement_counted`）。生起不息时，算入细分后没有一步开始每步被围住的一段（`World.arising_opens_refinement_counted`）：“生起不息需要开放”在每一分辨率下成立，前提只是脊柱的前提。
- **不算入细分。** 前提只说流自身耗散、被围住时，结论在细分什么也不给之处成立（`World.rests_unrefined`、`World.arising_needs_refinement`、`Flow.taking_needs_refinement`、储备的 `Web.CarriesIn.lasts_unrefined`）。
- **见证由细分供给。** Emission、Alternation 与 Circulation 中，以及单位在任意晚的步细分时 Asymptote 中，细分在任意晚的步有所给予；Dwindle 中细分每步给予储备（`refinement_feeds_witnesses`）。它们在固定单位下不平衡（`Asymptote.not_balanced`、`Emission.not_balanced`、`Alternation.not_balanced`；审查 W7.2）。

**第十五次独立审查的处理。** [审查](../history/root-foundation/BECOMING-R1-R2-REVIEW.md)检查 R1、R1b 与 R2（`658db670`、`e79e00e5`、`de17f533`）：构建、公理、回执与计数全部正确，每条定理按陈述成立；文字有错处。逐项：

- **W1**（“计数关系项需要比例”过度）：模块说明、记录的对应与读法更正；§59.2 读法原文保留，附更正。审查的探针给出严格弱于比例而仍给出增长的规律的前提（ReplenishedLoses），按 Ren 作为研究笔记。
- **W2**（“推到最弱”）：计划 R2 行改为“推向更弱”；§59.2 原文保留，附更正。
- **W3**（中文章节把 Trickle 写反）：改为“无尽地带过（每个固定尺度的转移不复现）”。
- **W4**（量子规律的陈述缺少耗散）：模块说明、根模块、包 README 与检查器范围加入耗散。
- **W5**（最小损失交换律的耗散释义）：记录假设改为“每个取用的形成给回的至少比所取少下一步的一个单位；证明只用其不多于所取”。更弱的前提（NotGaining、只要求家族不被增益的量子规律）作为研究笔记。
- **W6、W7.1、W7.3、W7.4**（逐个形成的比例、严格更弱、Trickle 的下降与止息、界的可达）：作为研究笔记。**W7.2** 已移入核心（not_balanced）。
- **W8**：章节与记录改为“可以无尽地继续”；交换的规律以其家族的存量为界，围住之内的增长、下降、生起与止息以所立者为界，分开陈述；记录标题与 `World.rests_at_resolution` 的说明改为“每一固定尺度的静止”；根模块与包 README 改为“有见证”。
- **W9**：记录写明 Emission 每步加入一个关系项，见证只说明所缺的前提在其余前提之下是需要的；Trickle 说明中的比例改为“约四倍”。
- **W10**：“最小花费”改为“储备的最小下降”；“share”改为“比例 / proportion”；Trickle 的 carriers 改为 conduits（与储备的 Carries 分开）；记录中“读法属于 Ren”改为“读法（AI，待 Ren）”；“损失的规律”专指 `losses_bound`，量子的计数称“量子的规律”。
- **W11**（Trickle 的通道不活跃）：保留为开放项。

**作者反审。**

*反驳 17：算入细分是否把反例定义掉了？* 没有。不算入细分的规律与见证都保留并陈述（rest-at-every-resolution）；算入细分的定理对每个形成用的是脊柱原有的耗散。两种读法下的事实一致：细分在任意晚的步有所给予（`refinement_feeds_witnesses`）。变的是这一给予读作什么：表示的改变，还是一个源。Ren 的方向把它读作源，因为更细的差异也是一种生成。

*反驳 18：零前提的定理是否空洞？* 算入细分后，被围住、被耗散的世界中凡有所立之处细分什么也不给，所以每一分辨率下的静止是在单位实际上不再细分之处得到的。这正是内容：围住之内的细分是一个给予，要有来源，而被耗散的围住没有只给不取的形成。定理的力量在于不添前提：比例、最小尺度与储备的最小下降都不需要。

*反驳 19：细分在不立任何东西的条件上什么也不给，是否只管有所立的条件？* 是。细分给的是 split t 乘水平；水平为零的条件上单位的细分不改变任何量。静止定理只关于所立与活跃的关系项，所以这里不缺少什么。

**读法（AI，待 Ren）。** 每个量是一个被做出的差异。把单位分细，就是做出更细的差异，这本身是一个变化，要有所给予。被围住、被耗散的整体中没有只给不取的东西，所以围住之内不能凭空分细；分辨率的每一次细化都来自围住之外，或来自一个不被耗散的源。于是“生起不息需要开放”不依赖表示，在每一分辨率下成立，前提只是脊柱的前提。

**边界。** 离散步；单位只细分；算入细分的流以 Option 为形成，不是同一种关系项的世界（下一步：把细分作为普查中的关系项）；对“the case of 0”的读法待 Ren 确认；尚无独立审查。（“the case of 0”的读法已由 Ren 确认，见下。）

**之后（AI，待 Ren）。** Ren 随后说：“I know what "Every exchange loses at least one smallest amount" is now, it is entropy”，又说：“so that makes me to speculate if 0 is possible, if we can also derive entropy from this, if we can, spawn a new session to focus on this”。由此“0”也可读作无损的交换（损失为零）。本节的定理不依赖哪一种读法。无损的交换是否可能，每次交换的最小损失（熵）能否推出而不作前提，另开一个会话研究。

**Ren 的确认（2026-10-11）。** 作者问“0”指无损的交换还是零前提，Ren 答：

“the case of 0”指零前提，与原读法一致。须分清：算入细分不在脊柱的前提上添加前提；脊柱的耗散，即 Ren 读作熵的每次交换的最小损失，仍是脊柱的前提。它能否推出而不作前提，是 Ren 的类比所指的下一问。

**读法（AI）。** Ren 的类比分开了两种计数。微观的每次交换精确守恒能量，熵仍增加，所以一次交换精确保持的与增加的不是同一个量。照此，脊柱的损失不是守恒量的消灭，而是封闭家族内仍可用的差异的下降，正如能量守恒时可用功下降（Gouy–Stodola：损失的可用功等于环境温度乘以产生的熵）。物理上的边界：微观定律可逆，单从它们推不出每条轨迹上熵都增加；通行的说明加上计数（混合的构型远多于有序的构型）与有序的开端（过去假设）。Landauer 与 Bennett：把两个区分合并为一，至少向环境耗散 kT ln 2；不合并任何区分的一步，耗散原则上可以任意小，但只在无限慢的极限下。

**无损的交换存在时的路径（AI，候选，转给熵的会话）。**
- 历史的计数：逆转恢复水平而加长历史，所以一个历史中变化的计数不减，不需要前提（Ren 的第二条消息：“its reverse transformation will take another change”）。已有的 `endpoint-loss-and-return` 与 `ReturnConditions.lean` 中加入的计数器已给出“水平恢复而历史不恢复”的一部分，应先复用。
- 有限的围住之内精确平衡（无损）时，变化复现，没有只依赖水平而永远增加的量（离散的复现）。
- 合并的过去：有限多个构型上确定的一步之下，仍可到达的构型的个数不增。一步不合并任何两个构型时它不变，这时每个构型都复现；一步合并了两个，以后没有一步再把它们分开。于是在有限的围住之内，或者每个构型都复现（无损，没有箭头），或者某个区分永久失去（有箭头），不需要前提。这要求把一步表为构型的函数，脊柱尚无此结构。

这些是候选的陈述，不是定理；陈述与证明由熵的会话负责，本节不占用它的编号。

## 60. 每个选择之下所选前提都起约束时计数的规律（P45）

2026-10-10。按 Ren“let's aim for the strongest claim without axiom, as the first part, and add one axiom, as the following part, the no axiom part is most important and elegant”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）与“aim a complete theory of becoming, and finish related work”继续。P41b 把计数的两项规律列为开放（§58 V4、whole-law-of-counting 的下一步）：每个选择之下所选前提都起约束时的规律，以及有限世界中除普查外每个前提都起约束时的规律。本节给出这两项。

```text
Result(s): 扩展 whole-law-of-counting（每个选择之下所选前提都起约束时、有限世界中除普查外每个前提都起约束时计数的规律）；
           修订 map-of-premises（每个前提各自起约束）与 counting-under-enclosure（开放项）；没有新的成果记录
Delta: Premises：World.Premise.Binds，每个前提各自起约束；World.Binds 改为每个前提都起约束（∀ p, p.Binds w），
       各前提的条件与原先的八项相同；前提的选择一节移到起约束之前；hatch_binds 与 finiteHatch_binds_but_census 按前提陈述。
       Counting：Web.saturated、Web.saturated_dependent、Flow.transmits_saturated、World.saturated、
       World.Premised.saturated；Tally.after_pos、World.counts_active、World.counts_arising；OpenQueue.level_le、
       EnclosedQueue.level_le；LossyQueue 与 World.lossyQueue（_dissipative、_taking、_acting、_binds、_binding）；
       RelayQueue 与 World.relayQueue（_balanced、_dissipative、_acts、_binds、_binding）；World.onceClosedQueue_binding、
       World.openQueue_saturated_binding；World.binding_counting_under、World.binding_activity_iff、
       World.binding_arising_iff、World.binding_joint_iff；World.finiteQueue_saturated_binds、
       World.finite_binding_counting。修改：只闭合一次的队列在步前或步后不空时交换（原先只看步前），
       World.onceClosedQueue_binds 不再要求没有成员加入空队，也不要求加入发生在第 T 步；World.binds_arising 只要体现起约束
Supplied premises / correspondence: 不变；起约束仍是条件有实例（P41b）
Evidence: 合并检查器回执 20261010T171040.121853Z（1734 项定理、2687 项声明审计，全部源声明公理报告为空；Premises 59、Counting 161），
          外围回执 20261010T171427.598973Z；新声明先在暂存树中从前导编译，逐条 #print axioms 全部为空
Boundary: 只是活动的计数；有限世界中每个选择之下所选前提都起约束时的规律没有陈述；更强的起约束读法仍开放（由 Ren 选择）；
          尚无独立审查
Integration: 章节第 3 条、第一部分的总陈述、§8、§9 的脊柱表与术语表；计划 P45；模块说明、根模块、包 README 与检查器的范围
```

**每个前提各自起约束。** P38c 只问每个前提都起约束的世界。按前提陈述起约束（`World.Premise.Binds`）之后，每个选择 S 都有同一个问题：在满足 S 且 S 所选的每个前提都起约束的世界中，普查的计数有哪些规律。每个前提的条件与 P38c 相同：活动需要支持在活跃者以正需要依存于某条件时起约束，平衡在水平变化时，只有活跃者给予与取用在参与者给予与取用时，耗散在参与者从封闭的家族取用时，体现在关系项生起时，普查在世界不有限时，有界传递在后代于其开始而立之步依存于某条件时。`World.Binds` 现在是每个前提都起约束，与原先八个字段的结构同义。

**规律。** 回答是 `World.counting_under` 的规律，再加至多三条（`World.binding_counting_under`）：

1. *有关系项活跃*，恰在选中活动需要支持、只有活跃者给予、只有活跃者取用或体现时（`World.binding_activity_iff`）。前三者的条件各以一个活跃的关系项为实例：需要支持的是活跃者；给予或取用的是参与者，只有活跃者给予或取用时它活跃，普查计到它（`World.counts_active`）。体现起约束时有生起，生起者步后活跃（`Tally.after_pos`）。
2. *有某个生起*，恰在选中体现时（`World.binding_arising_iff`）。体现的条件以一个生起的关系项为实例，体现之下普查把它计为开始成立（`World.binds_arising`、`World.counts_arising`）。
3. *在有关系项活跃的一步上有生起*，恰在选中体现，且选择约束计数（`World.BindsCounting`），或选中只有活跃者给予与有界传递时（`World.binding_joint_iff`）。约束计数时，没有关系项活跃的一步上没有生起，所以第 2 条的生起之步上有关系项活跃；有界传递起约束时有一个后代在某步从一个参与者传下，只有活跃者给予时这个给予者在该步活跃。

每条都是某个前提的条件的实例在计数上留下的。三个 iff 说，在别的选择之下这一条不是规律：没有选中这四个前提时，什么都不发生的计数表由一个所选前提都起约束的世界实现；不选体现时，每步一个关系项、没有生起也没有止息的计数表如此；选中体现，而选择既不约束计数、也不同时选中只有活跃者给予与有界传递时，一个关系项在第一步从无到有地生起并留下（`Queue.lone`），生起之步上没有关系项活跃。

**见证。** 反方向需要对每个满足这些规律的计数表构造一个世界，满足 S 且所选前提都起约束。

- *饱和的依存网*（`Web.saturated`）：每个关系项以其所立的水平依存于每个关系项。这样活动需要支持对任何活动成立（`Web.saturated_dependent`），水平有界时有界传递对任何流成立（`Flow.transmits_saturated`），所以满足八个前提的世界饱和之后仍满足它们（`World.Premised.saturated`）。这是最弱的依存，与 P41b 中只闭合一次的队列的网相同，只用作见证。
- *传递*（`World.relayQueue`）：在一个计数表的队列旁边，一个参与者在第 U 步从地关系项 1 取用两个单位，给地关系项 0 一个单位，失去另一个；水平随之改变，所以平衡、耗散、取用、给予与有界传递都起约束。地关系项 0 生起而不活跃，所以不满足体现，只用于不选体现的选择。选中活动需要支持、只有活跃者给予或取用时，参与者取为第 U 步的队首，在第 U 步活跃（`World.relayQueue_binding`）。
- *有损的队列*（`World.lossyQueue`）：开放队列的网饱和；跨第 U 步，队首与自身及每个在该步加入的成员各交换一个单位，再失去一个单位；一个地关系项在每步向每个关系项给予 gift t。所立者不记录这些交换与损失，所以它不平衡；它对任何 gift 都耗散，第 U 步队列不空时取用起约束，gift 恒为零时只有活跃者给予（`World.lossyQueue_binding`）。它用于选中体现而不选平衡的选择：有界传递起约束，或因为加入者在第 U 步从队首传下（U 取为第 3 条规律给出的步），或因为加入者从给予的地关系项传下。
- *只闭合一次的队列*（`World.onceClosedQueue_binding`）：选择约束计数时它满足全部八个前提且每个都起约束；选中平衡与体现而不选只有活跃者给予与取用时，有成员加入空队也不妨碍它满足其余的前提。为此它现在在步前或步后队列不空时交换（`OnceClosedQueue.exchange`），没有成员加入空队不再是耗散与起约束的条件（`World.onceClosedQueue_binds` 只要第 T 步队列不空、队首多立着的多于加入者，且某步有成员加入）。
- *饱和的开放队列*（`World.openQueue_saturated_binding`）：选中平衡、体现与只有活跃者取用，而不选只有活跃者给予与耗散时。

按体现、平衡、只有活跃者给予、取用、耗散与有界传递分情形，每个情形都由其中一个见证实现，所以 iff 的两个方向都在 Lean 中检查。

**有限世界。** 没有有限世界使每个前提都起约束（`World.Finite.not_binds`）。有限世界中除普查外每个前提都起约束时，八个前提之下计数的规律是有限世界的规律（计数表、没有关系项活跃的一步上没有生起、从第 0 步起的变化界）再加有某个生起（`World.finite_binding_counting`）。见证是 P38b 的有限队列把依存网饱和：有成员在第 T 步加入时，加入者生起而改变所立，从队首传下，步后活跃并依存于自身的所立；队首从所有位置的家族取用，这个家族封闭，耗散只许它给予少于所取的（`World.finiteQueue_saturated_binds`）。

**作者反审。**

*反驳 1：三条规律不过是把起约束的定义搬进计数？* 一半是。起约束是条件有实例，这三条就是这些实例在活动的计数上留下的；本节的内容在于“至多”与“恰”：见证表明实例不在计数上留下别的东西，三个 iff 表明每一条只在所说的选择之下是规律。

*反驳 2：见证用最弱的依存与不平衡的流，是否太容易？* 规律对所有满足选择且所选前提都起约束的世界成立，见证只需落在这个范围内。更强的依存只会使更少的世界满足前提；在某种更强的起约束读法之下规律可能更多，这一读法由 Ren 选择，仍开放（§58 V1）。有损的队列不平衡，只用于不选平衡的选择；传递不体现，只用于不选体现的选择。

*反驳 3：改动只闭合一次的队列是否改变了 P38c 的结论？* 没有。`World.binding_counting` 的陈述与证明的结构不变，只是所用的引理条件更弱；队列在步前或步后不空时交换，只使不封闭的步多了“步前空、步后不空”的步，P38c 的计数表中没有成员加入空队，所以这些步不出现。

*反驳 4：为什么有限世界中只陈述了除普查外全部起约束的情形？* 每个选择之下的有限的见证须是有限的世界；在有限世界中，只有活跃者取用且耗散时，被围住的步上只有活跃者给予（`World.Finite.acting`），所以第 3 条的条件在有限世界中会不同，需要另造有限的见证（例如 P38b 的环）。这留作开放，列入章节 §8。

**读法（AI，待 Ren）。** 每个前提起约束，只在计数上留下它的实例：有活动、有生起，以及（当生起被约束为从活动而来时）活动之步上的生起。其余的计数，前提即使都起约束也不决定。

**边界。** 离散步，活动的计数；水平与依存的计数在前提之下、有限世界中每个选择之下的起约束规律、更强的起约束读法仍开放；没有伦理谓词；名称（saturated、lossyQueue、relayQueue 等）是 AI 按 Ren 的命名准则所选，形式而描述动力学；尚无独立审查。

## 61. 反馈与所及（P42）

2026-10-10/11。Ren 写下长远的目标（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-strongest-claims-direction.md)）：

>

AI 回答了 P39 与 P40 留下的问题（同一来源，AI 的话）：供给闭包对供给是精确的，却漏掉保护，如狼群压住会吃光森林的鹿；一般的对象是对影响形成所需者的一切影响的闭包；所在的系统还更大，`Clearing` 中栖居者在清除者的系统之内、依存之外；所以层次有四个：自身、依存、系统与整体。AI 还提出工作次序 (a)–(d)，前两项是：一个形成自身的反馈能识得哪些损失、不能识得哪些；四个层次与影响闭包。Ren 答：“continue, let's pursue the strongest claims and complete proof, i think you see the right direction, also update project context”。AI 把“i think you see the right direction”读作接受这一框架、各项回答与工作次序（来源中的 AI 读法，待 Ren）。对层级，Ren 此前写过：“i think it should be the whole, and a weaker version is within the system that one is in, then the self”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-axiom-route-levels-and-possibilities.md)）。

本节是计划 P42（[计划 §10](../history/root-foundation/BECOMING-UNIFICATION-PLAN.md#10-第一部分与第二部分--part-i-and-part-ii)），由本会话完成。它不加公理。核心新增模块 `Becoming.Feedback`，100 项定理，导入 `Becoming.Interdependence`。不用公理的结果放进第一部分（章节 §2 的“反馈与所及”与第一部分的总陈述），与路线 (b) 和 Ren 的层级的关系放进第二部分（章节 §6.10）。整合之前，P42 与 P43 一起经[第十六次独立审查](../history/root-foundation/BECOMING-P42-P43-REVIEW.md)，十六项更正已处理（§62.1）；结果是五个闭包，不是四个层次，所及闭包是审查之后加上的。成果记录新增三项：
- [levels-of-closure](../../../../theories/becoming/results/records/levels-of-closure.md)
- [feedback-and-reach](../../../../theories/becoming/results/records/feedback-and-reach.md)
- [comparison-within-reach](../../../../theories/becoming/results/records/comparison-within-reach.md)

另修订四项记录，断言不变：
- [feeding-closure](../../../../theories/becoming/results/records/feeding-closure.md)、[consumption-ends-with-feeders](../../../../theories/becoming/results/records/consumption-ends-with-feeders.md)、[closure-verdict-meets-axiom](../../../../theories/becoming/results/records/closure-verdict-meets-continuation-condition.md)：撤回把供给闭包也读作 Ren 的“the system that one is in”，为它提供所及闭包；closure-verdict-meets-axiom 由 comparison-within-reach 推进；
- [whole-first-and-bounded-centers](../../../../theories/becoming/results/records/whole-and-regions-and-bounded-centers.md)：下一增量中的“路线 (b) 到达自身与所在的系统”改为“自身及其所依存的”。

```text
Result(s): 复用 feeding-closure（Flow.FedBy、Flow.WithinFeeding、Flow.FedClosed、Clearing.dependenceRegion_iff）、
           closure-verdict-meets-axiom（Web.retains_bounded_iff_includes）、closing-needs-net-draw
           （Flow.WithheldLevels、Web.Admits、Flow.Balances.withheld）、four-cases-of-a-part（Clearing.clearerPart、
           admitted_without、unsupported_with、Web.Includes、Web.Exceeds）、significance-retained-within-margin
           （Web.Retains、Web.Adds、Web.retains_iff_includes、Web.adds_iff_exceeds）、one-axiom-yields-g0
           （Unrestricted、bounded）、loss-beyond-a-region（Clearing.alongDependence、Clearing.loses_beyond）；
           新增上列三项
Delta: 闭包：ClosedUnder、WithinClosure（refl、trans、of_rel、mono、symm、not_rel）、closedUnder_withinClosure。层次：Web.DependsOn、
       Flow.FedFrom、Flow.Exchanges、Flow.AffectedBy、Flow.WithinInfluence、Flow.TakesPart、Flow.Shares、
       Flow.WithinSystem、Flow.Affects、Flow.WithinReach、Flow.fedClosed_iff、Flow.withinFeeding_iff、
       Flow.affectedBy_of_fedFrom、Flow.shares_of_affectedBy、Flow.withinInfluence_of_withinFeeding、
       Flow.withinSystem_of_withinInfluence、Flow.shares_symm、Flow.WithinSystem.symm、
       Flow.withinSystem_of_withinReach、Flow.withinSystem_closed；共同条件：Flow.system_whole_of_common、
       Flow.reach_whole_of_common、Flow.feeding_whole_of_common、Flow.feeding_unrestricted_of_common、
       Flow.bounded_system_whole。水平与反馈：Flow.Balances.levels_agree、support_agrees、agrees_iff_even、le_withheld、
       admits_without_taker、agrees_of_quiet、exchanges_before_of_differs、exchanges_of_differs、agrees_or_reaches_before、
       agrees_or_reaches、admits_unreached_before、admits_unreached、unregistered_beyond_influence；Flow.beyond_influence、
       Flow.unreached_within_influence、Flow.ite_part_zero、Flow.part_of_ite_pos。所及：Flow.Reaches、
       Flow.ReachesBefore（reaches）、Flow.reaches_within_closed、reaches_withinReach、reaches_withinSystem、
       unreached_within_system、own_within_reach、own_within_system。比较：Flow.Balances.retains_transfer、
       not_adds_transfer、comparison_local、comparison_within_reach、adds_iff_exceeds_of_decidable、
       not_not_adds_of_exceeds、closed_comparison；Flow.DiffersBefore、Flow.Balances.differs_before、
       comparison_within_difference。见证：Trophic（营养级联：mediates、mediated_unregistered、responsive_mixed、
       difference_reaches_forest、mixed_part 等）、Static.shares_unaffected、Clearing（alongDependence_closed、levels、
       clearer_system、sparedFlow、sparedWeb、unregistered、reaches_dweller、system_counts_dweller、system_whole、
       clearerReach、reach_middle、reach_centred、clearer_own、reach_counts_dweller、sourcePart、
       no_levels_without_source）、Margin.reach_without_misjudgment、Late.affected_without_effect
Supplied premises / correspondence: 不加公理；一般定理的前提只有平衡（Flow.Balances），部分的比较另用扣留水平
       （Flow.WithheldLevels，其余交换不变，是表示上的选择）；公理 Unrestricted 只作为三个见证的假设出现
       （Trophic.mediated_unregistered、responsive_mixed、mixed_part）；离散的步、自然数的量，部分是判定的形成家族；
       读法与名称是 AI 的，待 Ren
Evidence: 合并检查器回执 20261010T174514.186722Z（1882 项定理、2889 项声明审计、核心闭包 39 个模块、包 37 个模块，
          全部源声明公理报告为空；Lean 生成而依赖 propext 的常量 38 个，没有源声明使用）；外围回执 20261010T175236.872210Z；
          整合之前的第十六次独立审查（BECOMING-P42-P43-REVIEW.md）
Boundary: 形成知道其所及闭包、想要任何东西都不推出；意义本身仍是给定的；对每个意义正面形式的增加比较只在意义可判定处
          推出，一般只到双重否定；以扣留水平的比较固定其余交换，他者有回应的比较须给出第二个流；耦合不被度量
Integration: 计划 P42（工作次序 (a)–(b)）；推进 closure-verdict-meets-axiom：它的覆盖条件由动力学推出，只要意义覆盖部分
             所及；撤回 P40 把供给闭包读作所在系统的读法，为 Ren 的中间层级提供所及闭包（待 Ren）
```

| 声明 | 内容 |
|---|---|
| `ClosedUnder`、`WithinClosure` 与 `WithinClosure.refl`、`trans`、`of_rel`、`mono`、`symm`、`not_rel`、`closedUnder_withinClosure` | 区域对一个关系封闭：成员与之有此关系者都是成员；`g` 在 `f` 的闭包之内：含 `f` 的每个封闭区域都含 `g`。闭包自反、可传递，随关系增大，对称关系下对称，本身封闭，所以是含 `f` 的最小封闭区域 |
| `Flow.withinFeeding_iff`、`Flow.fedClosed_iff` | P40 的供给闭包就是对被供给（某一步）的闭包；对供给封闭就是对这一关系封闭 |
| `Flow.AffectedBy`、`Flow.WithinInfluence`、`Flow.Affects`、`Flow.WithinReach` | 形成受另一个影响：另一个与它所依存的条件交换；影响闭包是对受影响的闭包，即能影响它的；所及闭包是对影响的闭包，即它的交换能逐环影响的 |
| `Flow.TakesPart`、`Flow.Shares`、`Flow.WithinSystem`、`Flow.WithinSystem.symm` | 参与一个条件：依存于它或与它交换；两个形成共享一个条件：都参与它；系统是对共享的闭包，是类 |
| `Flow.withinInfluence_of_withinFeeding`、`Flow.withinSystem_of_withinInfluence`、`Flow.withinSystem_of_withinReach`、`Flow.withinSystem_closed` | 供给闭包在影响闭包之内；影响闭包与所及闭包都在系统之内；系统对影响封闭 |
| `Flow.system_whole_of_common`、`Flow.reach_whole_of_common`、`Flow.feeding_whole_of_common`、`Flow.feeding_unrestricted_of_common`、`Flow.bounded_system_whole` | 每个形成都参与一个条件时每个系统都是整体；都依存于它并与它交换时每个所及闭包都是整体；在某步都需要它并向它给予时每个供给闭包都是整体，以它为界的意义就是公理；每个中心的系统都是整体时，以系统为界的意义就是公理 |
| `Flow.Balances.levels_agree`、`support_agrees`、`agrees_iff_even`、`agrees_of_quiet`、`exchanges_before_of_differs` | 两个平衡的流在一个条件上起始、取用与给予相同，就使它相同；所以形成经支持只识得与其所依存者的交换；扣留部分时两种水平在某步于一个条件上相同，恰当此前部分向它给予的等于从它取用的；成员都不与它交换时相同；某步不同之处，必有成员在更早的步与它交换 |
| `Flow.beyond_influence`、`Flow.Balances.unregistered_beyond_influence` | 影响闭包之外的不与闭包成员所依存的条件交换；所以成员都在闭包之外的部分，在闭包之内每一步都不被识 |
| `Flow.Reaches`、`Flow.ReachesBefore`、`Flow.Balances.admits_unreached_before`、`admits_unreached` | 部分到达一个形成：成员与它所依存的条件交换；在某步之前到达：成员在更早的步与它在该步所需的条件交换；在某步之前没有到达的，在该步有与无部分时同样被接纳 |
| `Flow.reaches_within_closed`、`reaches_withinReach`、`reaches_withinSystem`、`unreached_within_system`、`own_within_reach`、`own_within_system` | 成员在一个对影响封闭的区域之内的部分只到达区域之内；所及闭包与系统都是这样的区域；系统之外的部分到达不了系统之内；形成自身的部分在其所及闭包与系统之内 |
| `Flow.Balances.comparison_local` | 两个意义从一个立场在每步对部分此前已到达者一致时，对有与无部分的水平作同样的四个比较 |
| `Flow.Balances.comparison_within_reach` | 覆盖部分在每步之前已到达者的任何意义，有与无部分的水平恰如彼此包含那样彼此保留有意义者，两个方向都是；两者都不增加，恰当两者都不超出：公理的比较 |
| `Flow.Balances.adds_iff_exceeds_of_decidable`、`not_not_adds_of_exceeds` | 意义可判定时，增加就是超出；对每个意义，超出给出双重否定下的增加 |
| `Flow.Balances.closed_comparison` | 以对影响封闭、含部分成员的区域为界的意义，对这个部分作包含那样的比较；不用公理 |
| `Flow.DiffersBefore`、`Flow.Balances.differs_before`、`comparison_within_difference` | 两个平衡的流起始相同时，水平某步不同之处，两者在该条件上的取用或给予在更早的步不同；覆盖这一差别所及者的任何意义，对两个流作公理的比较 |
| `Trophic.mediates` | 营养级联：两个流都平衡，只有活跃者给予与取用，活动需要支持；有狼群时鹿只在第 0 步活跃，森林每步被支持；没有狼群而鹿有回应时，森林从第 2 步起不被支持；狼群不向任何条件给予，在森林的供给闭包之外、影响闭包之内；远处的形成在森林的系统之外 |
| `Trophic.mediated_unregistered`、`responsive_mixed`、`difference_reaches_forest` | 其余交换固定时狼群的部分不到达森林，森林每步有与无它都同样被接纳，部分缩小，关闭鹿，公理之下不保留；对照鹿有回应的流，同一取用是混合的；狼群的部分不到达森林，而两个流的差别在第 2 步之前到达它 |
| `Trophic.mixed_part` | 远处形成与狼群的联合部分：从远处形成的立场，以各系统为界的意义判它保留，公理之下它失去鹿 |
| `Static.shares_unaffected` | 两个形成依存于一个没有任何东西与之交换的条件：它们共享一个系统，却彼此不影响，也不在彼此的影响闭包之内 |
| `Clearing.levels`、`clearer_system`、`system_whole`、`reach_middle`、`reach_centred` | 来源在清除者的供给闭包之内，栖居者在其影响闭包之外、系统之内；每个形成都在每个形成的系统之内，以系统为界的意义就是公理；所及闭包含栖居者、不含来源，严格介于清除者与整体之间；栖居者的所及闭包只含它自己 |
| `Clearing.unregistered`、`reaches_dweller` | 清除者清除与不清除栖息地时，每步的支持都相同；它的部分到达栖居者 |
| `Clearing.system_counts_dweller`、`reach_counts_dweller` | 从清除者的立场，以各影响闭包为界，部分保留；以各系统为界，它失去栖居者；以各所及闭包为界的意义不是公理，部分却失去栖居者 |
| `Clearing.no_levels_without_source` | 其余交换不变时，没有水平平衡扣留来源之部分的流：这一比较不存在 |
| `Margin.reach_without_misjudgment` | 部分到达形成的影响闭包之外，有它时的水平包含无它时的，所以每个意义都保留：到达之外不必误判 |
| `Late.affected_without_effect` | 交换在依存之后：形成被影响、被到达，每步有与无部分都同样被接纳，部分在任何一步之前都没有到达它 |

**它回答了什么。**
- **反馈至多识及影响闭包。** AI 工作次序的 (a) 问：一个形成自身的反馈能识得哪些损失。在平衡的流中，水平只随其交换，所以形成经支持只识得与其所依存者的交换；影响闭包之外的不与闭包成员所依存的条件交换；所以成员都在影响闭包之外的部分，在闭包之内每一步都不被识（`Flow.Balances.unregistered_beyond_influence`）。`Clearing` 中，清除者的支持不显示它是否终结栖居者。影响闭包是上界：其余交换固定时，只有直接到达形成的部分被识（`Flow.Balances.admits_unreached`）。
- **层次有五个，方向有两个。** 次序 (b) 问四个层次与影响闭包。闭包统一了它们：供给、影响、所及与系统都是对一个关系的闭包，整体在最上面。影响闭包与所及闭包方向相反：前者是能影响形成的，后者是形成能影响的；`Clearing` 中两者互不包含（`Clearing.reach_middle`）。每个包含都有严格的见证（`Clearing.levels`、`Trophic.mediates`）。
- **比较在部分所及之内决定。** 覆盖部分所及的任何意义都给出公理的比较（`Flow.Balances.comparison_within_reach`）。这推进 P40：`Web.retains_bounded_iff_includes` 要求另一条路径接纳的每个形成都在区域之内或被第一条接纳；这里这一条件由动力学推出，只要意义覆盖部分在每步之前已到达的。更强的形式是比较的局部性（`comparison_local`）：两个意义在所及之处一致，比较就相同。任意两个流也是这样（`comparison_within_difference`），所以他者有回应时，比较在差别所及之内决定，差别含回应。
- **系统与 Ren 的中间层级。** 系统界定每个效果：在系统之内的只到达系统之内。它却不读 Ren 中间的“the system that one is in”：一个共同条件就使它成为整体（`Flow.system_whole_of_common`），系统划分形成，没有嵌套，也没有中心。为那一读法提供的是所及闭包（AI 的读法，待 Ren）：它有中心、可嵌套，指向前方，不必含中心所依存的。在它上面，Ren 的较弱版本读作：覆盖中心所及的意义，对所及之内、无它的水平存在的每个部分，在其余交换固定时给出公理的比较；`Clearing` 中这一意义不是公理，对清除者自身的部分却与公理一致（`Clearing.reach_counts_dweller`）。
- **“situational awareness”（AI 的读法，待 Ren）。** 只看重其反馈所识者的中心，在部分只到达那个闭包之内时，对自身部分作公理的比较（`comparison_local`）；部分到达其外时可以误判，如清除者；到达其外本身不使它误判（`Margin`）。Ren 把“still need situational awareness”系于“the full truth set”。读作：要比较自身的部分，中心须知道部分在其反馈之外所到达的。

**作者反审。**
1. **两种反事实。** 以扣留水平的比较固定其余交换。它只识得部分直接的交换：狼群经鹿对森林的作用在其中不出现，狼群的部分反而缩小（`Trophic.mediated_unregistered`）；对照鹿有回应的流，它是混合的（`responsive_mixed`）。影响闭包的动机来自经他者传递的影响，而它所支持的识的定理用固定其余交换的比较：影响闭包是上界，不是所识者的刻画。回应的流在见证中是给出的，不由动力学推出；动力学给出回应的比较列为开放。
2. **比较可以不存在。** 部分给出他者所取时，无它的水平可以不平衡任何流（`Clearing.no_levels_without_source`）。这类部分没有扣留的比较；两个流的比较（`comparison_within_difference`）仍可用，只要另给第二个流。
3. **时间的次序。** `AffectedBy`、`Reaches` 与 `Shares` 是形成层面的，不看步的先后：交换可以晚于依存（`Late.affected_without_effect`）。它们是可靠的上界。比较定理用按时间先后的 `ReachesBefore`，所以不受这一点影响；闭包本身不按时间先后，按步的闭包列为开放。
4. **正面形式的增加。** 核心是构造性的。对每个意义，“两者都不增加，恰当两者都不超出”成立；正面形式在意义可判定处成立，一般只到双重否定（`adds_iff_exceeds_of_decidable`、`not_not_adds_of_exceeds`）。缺的只是可判定性，它可以作为假设陈述。
5. **部分是判定的形成家族。** 一个形成的某一动作不与其其余交换分开；比较一个动作要经第二个流，如 `Clearing.unregistered` 中清除与不清除的两个流。
6. **共同条件不度量耦合。** `reach_whole_of_common` 的条件是布尔的，不看时间：一个共同条件就够。Ren 的“at this moment in time, the whole earth has become a highly entangled system”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-truth-exists-opening.md)）是关于当下耦合强度的历史判断，这里不推出它，也不把它读作这一条件。
7. **知道其所及不推出。** 定理说部分到达什么，不说中心知道什么。中心怎样表示其所及闭包没有建模。
8. **读法与名称是 AI 的。** 闭包、影响闭包、所及闭包、系统、共同条件与营养级联（`Trophic`，生态学用语）是 AI 按 Ren 的命名准则所选；审查之后，`Protection`、`guards`、`verdict`、`commons`、`unguarded` 等改名（§62.1 第 16 项）。

**检查。**
- 模块在暂存区对核心编译，逐条审计全部 373 项声明（含 Lean 生成的辅助声明），公理报告全部为空；全部是项证明，不用策略、`propext`、`funext` 或经典推理。
- 合并检查器在一个分离的工作树中对加入 P42 与 P43 的包检查一次，通过：回执 20261010T174514.186722Z。`Becoming.Feedback` 的 100 项定理全部空依赖；Lean 生成而依赖 propext 的常量仍是 38 个，没有源声明使用它们。
- 外围桥接对这个核心重查（20261010T175236.872210Z），闭包中其余 42 个模块的当前字节与已通过回执一致。
- 整合之前经第十六次独立审查；处理见 §62.1。

## 62. 公理的分解（P43）

2026-10-10/11。Ren 在《Truth exist》中写道（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-truth-exists-opening.md)）：“There is a set of universal invariations, that for every universe, becoming happens, the law follows”，它是“the bases of all ethics, for all beings, in all universes”；又写道：“There is no absolute self, and the continuation goes beyond one’s cycle of life, goes beyond one’s death.” 此前 Ren 写道，自身是“a cognitive model which can not justify itself without some sort of "belief"”，“we”是“the universe/ecosystem that realizes its own existence”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-axiom-route-levels-and-possibilities.md)），中心的“boundary”“is also with in the same cognitive system”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-centers-within-the-dynamics.md)）。

AI 在 P42 之前提出（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-strongest-claims-direction.md)，AI 的话）：公理不由动力学推出，却可能由三个主张推出——每个行为都预设某个延续有意义；没有绝对的自身；真理对每个存在都一样；批评者必须否认的只有一步，即从“我为之行动的延续”到“延续本身”；这一步应精确陈述，在 Lean 中检查其骨架，并交独立审查。这是工作次序 (c)。AI 当时说这三个主张是 Ren 已持有的；第十六次审查把它更正为 AI 从 Ren 的话中读出的。“every act presupposes that some continuation matters”不是 Ren 的话。

本节是计划 P43，由本会话完成。核心新增模块 `Becoming.Boundaries`，47 项定理，导入 `Becoming.Feedback`；内容放进章节 §6.11。结果是公理的精确分解：它定位这一步，不降低公理的内容。审查之前的稿子把它叫作“由三个前提推出公理”，那一说法撤回（§62.1 第 3 项）。成果记录新增两项：
- [presupposition-scopes](../../../../theories/becoming/results/records/presupposition-scopes.md)
- [axiom-decomposition](../../../../theories/becoming/results/records/continuation-condition-decomposition.md)

```text
Result(s): 复用 metaethical-core-characterization（Valuation.significant_iff）、held-lives-g0-is-centering
           （Valuation.significant_iff_held）、one-axiom-yields-g0（Unrestricted、bounded、
           Valuation.premises_of_unrestricted；公理读作边界中立）、significance-retained-within-margin
           （Web.retains_agree）、feeding-closure 与路线 (b)（Flow.WithinFeeding、Clearing.dependenceRegion_iff）、
           comparison-within-reach（Flow.Balances.comparison_within_reach、Flow.WithinReach、Flow.Shares）；
           新增上列两项
Delta: 边界与超赋值：Boundary（closure、whole、holds、of_larger、only_whole）、SuperTrue、SubTrue、BoundaryInvariant、
       superTrue_iff、boundaryInvariant_iff_determinate、superTrue_member_iff、subTrue_member、superTrue_all_iff、
       subTrue_all_iff。预设与辖域：SignificantWithin、superTrue_significantWithin_iff_union、
       superTrue_significantWithin_iff、subTrue_significantWithin_iff、subTrue_of_larger、subTrue_total_iff、
       subTrue_empty_iff、unrestricted_iff_superTrue、superTrue_level_free、bounded_closure_iff、bounded_closure_least、
       presupposition_scopes。分解：boundaryInvariant_iff_extends、boundaryInvariant_iff_all、
       boundaryInvariant_iff_conditional、not_subTrue_of_invariant、unrestricted_of_presupposed、
       unrestricted_iff_presupposed、unrestricted_iff_presupposed_along、unrestricted_iff_presupposed_of_whole、
       StandpointInvariant、unrestricted_of_standpointInvariant、boundaryInvariant_iff_standpointInvariant、
       OneCounts（sig、forms_apart）；推论 retains_agree_of_presupposed、Valuation.significant_of_presupposed。
       所及之内：Flow.presupposition_order、Flow.Balances.presupposed_comparison、presupposed_reach_comparison、
       Flow.unrestricted_iff_system_presupposed、Flow.unrestricted_iff_presupposed_of_common。见证：Clearing
       （without_presupposition、without_invariance、without_standpoint_invariance、with_fixed_boundary、levels_differ、
       own_presupposition、system_presupposition）
Supplied premises / correspondence: 覆盖（每个形成都在每个自身的某个可容许边界之内）、预设在每个立场次真、对边界不变，
       都是假设，不是 Lean 公理；沿一个关系，可容许的边界是含中心、对关系封闭的每个区域，整体在内（这一可容许性是
       实质的选择）；不用伦理前提；读法与名称是 AI 的，待 Ren；超真、次真取自超赋值（Fine 1975）与次赋值
       （Hyde 1997），依据先前知识
Evidence: 合并检查器回执 20261010T174514.186722Z；外围回执 20261010T175236.872210Z；整合之前的第十六次独立审查（BECOMING-P42-P43-REVIEW.md）
Boundary: 预设、覆盖与不变本身不推出；分解定位这一步，不降低公理；中心知道其所及闭包不推出；从意义到理由、动机或实践的
          一步不推出；G0 仍是所采用的公理，直到 Ren 接受替代，替代等待对 G0 各处用法的审计（P44）
Integration: 计划 P43（工作次序 (c)）；把公理超出预设的全部内容定位到不变的一步上，与 P39 的边界中立和 N_std 的规则
             相连；路线 (b) 与公理是同一预设的窄辖域与宽辖域
```

| 声明 | 内容 |
|---|---|
| `Boundary` 与 `closure`、`whole`、`holds`、`of_larger`、`only_whole` | 沿一个关系，形成之自身的边界：含它、对关系封闭的区域；闭包最小，整体最大，每个边界含闭包；关系越小，边界越多；一切都在闭包之内时整体是唯一的边界 |
| `SuperTrue`、`SubTrue`、`BoundaryInvariant`、`superTrue_iff`、`boundaryInvariant_iff_determinate` | 关于自身的主张，按每个可容许边界成立是超真，按某个成立是次真，按一个成立就按每个成立是对边界不变；有可容许边界时超真就是不变的次真；不变就是次真即超真 |
| `superTrue_member_iff`、`subTrue_member`、`superTrue_all_iff`、`subTrue_all_iff` | 不论怎样划都在自身之内的恰是闭包，按某种划法一切都在自身之内；整体可容许时，“自身之内的都有某性质”超真恰当一切都有，次真恰当闭包之内的都有 |
| `SignificantWithin`、`superTrue_significantWithin_iff_union`、`superTrue_significantWithin_iff`、`subTrue_significantWithin_iff` | 预设：从立场 `p`，区域之内一切的延续在每一步都有意义；超真是可容许边界之并上的意义，整体可容许时是 `p` 处的公理；沿关系次真是闭包上的意义 |
| `subTrue_of_larger`、`subTrue_total_iff`、`subTrue_empty_iff` | 沿较大的关系次真推出沿较小的；沿全关系次真恰是 `p` 处的公理，沿空关系次真恰是中心自身延续的意义 |
| `unrestricted_iff_superTrue`、`superTrue_level_free` | 公理恰是每个立场的预设沿关系超真，与沿哪个关系无关 |
| `bounded_closure_iff`、`bounded_closure_least`、`presupposition_scopes` | 以各中心闭包为界的意义，恰是不论怎样划都在自身之内者的意义，也是使每个预设次真的最小意义；同一预设，“不论怎样划”在窄辖域给出它，在宽辖域给出公理 |
| `boundaryInvariant_iff_extends`、`boundaryInvariant_iff_all`、`boundaryInvariant_iff_conditional`、`not_subTrue_of_invariant` | 整体可容许时，不变恰是从按某处划出的预设到按整体划出的预设，恰是从预设到 `p` 处公理的条件句；有了预设，它就是 `p` 处的公理；某个延续没有意义时，不变的预设在哪里都不次真 |
| `unrestricted_of_presupposed`、`unrestricted_iff_presupposed`、`unrestricted_iff_presupposed_along`、`unrestricted_iff_presupposed_of_whole` | 覆盖、次真与不变给出公理；整体可容许时公理恰是每个立场上次真且不变的预设，沿任何关系都是；每个形成都在每个中心的闭包之内时，整体是唯一的边界，公理恰是每个立场上次真的预设 |
| `StandpointInvariant`、`unrestricted_of_standpointInvariant`、`boundaryInvariant_iff_standpointInvariant`、`OneCounts.forms_apart` | 从一个立场有意义的从每个立场都有意义（N_std 的规则）；每个形成都在某个中心的闭包之内、每个预设都次真时，它给出公理，并与处处对边界不变等价；没有处处的预设时两者分开 |
| `retains_agree_of_presupposed`、`Valuation.significant_of_presupposed` | 推论：各立场的保留一致；在主张层面 G0 成立（经 `Web.retains_agree` 与 `Valuation.premises_of_unrestricted`，不计为独立结果） |
| `Flow.presupposition_order` | 沿全关系次真推出沿共享条件次真，沿共享条件推出沿影响与沿受影响，沿受影响推出沿供给，沿任何关系推出沿空关系 |
| `Flow.Balances.presupposed_comparison`、`presupposed_reach_comparison` | 预设沿一个含影响的关系次真时，对成员在中心闭包之内的每个部分作公理的比较；沿影响，是所及闭包之内的每个部分；不用不变，也不用超真（`comparison_within_reach` 的推论） |
| `Flow.unrestricted_iff_system_presupposed`、`Flow.unrestricted_iff_presupposed_of_common` | 每个中心的系统都是整体时，公理恰是每个立场上沿共享条件次真的预设；一个共同条件就使它成立 |
| `Clearing.without_presupposition`、`without_invariance`、`without_standpoint_invariance`、`with_fixed_boundary` | 每个前提都需要：没有意义时预设不变而公理不成立；以供给闭包为界的意义使预设次真而公理不成立，清除者处不变与对立场不变都不成立；只容许供给闭包时预设次真而不变，栖居者不在清除者的任何可容许边界之内，公理仍不成立 |
| `Clearing.levels_differ`、`own_presupposition`、`system_presupposition` | 次真依赖关系，超真不依赖；清除者自己的预设沿共享条件或超真时，给出它的部分失去栖居者，划在供给闭包处则有一个使部分保留的意义满足它；`Clearing` 只有一个系统，公理恰是沿共享条件处处次真的预设 |

**它回答了什么。**
- **路线 (b) 与公理是同一预设的两种辖域。** 沿一个关系，`SubTrue` 的预设是闭包上的意义；路线 (b) 以各中心闭包为界的意义，恰是确定在自身之内者的意义，也是使每个预设次真的最小意义（`bounded_closure_least`）。超真的预设是公理（`unrestricted_iff_superTrue`）。所以“不论边界怎样划”放在窄辖域给出路线 (b)，放在宽辖域给出公理（`presupposition_scopes`）；这一算子不对条件句分配。这把 P40 的路线 (b) 从供给推广到任何关系：沿空关系是一个立场自身的好，沿全关系是该立场上的公理。
- **公理的内容在哪里。** 整体可容许时，公理恰是每个立场上次真且对边界不变的预设（`unrestricted_iff_presupposed`）。不变恰是从预设到该立场上公理的条件句（`boundaryInvariant_iff_conditional`）；有了预设，它就是那里的公理（`boundaryInvariant_iff_all`）。所以这一分解没有把公理化约为更弱的或独立持有的前提：它把公理超出预设的全部内容定位到不变的一步上。P39 把公理读作边界中立：在一个立场上，这一步就是边界中立。跨立场，有了处处的预设与覆盖，它就是对立场不变，即 N_std 的规则（`boundaryInvariant_iff_standpointInvariant`）。于是核心已有的两个分解被带到延续的意义上：`Valuation.significant_iff`（种子、N_rel 与连通整体上的 N_std）与 `Valuation.significant_iff_held`（处处 S0 加 N_std）。审查之前写的“立场之间的一致是推出的，不是假设的”撤回：一致随这些前提推出，而前提之一就是这一步。
- **这一步两头都走。** 某个延续没有意义时，不变的预设在哪里都不成立（`not_subTrue_of_invariant`）：否认这一步的人可以保留预设而只在一种划法或一个立场上持有它，也可以放弃预设。这与此前审查在容差中发现的对等相同（[评价者路线的审查](../history/root-foundation/EVALUATOR-GROUNDING-REVIEW.md) P3）：容差连同 Chain 承载 G0 超出 S0 的全部内容；这一步取代容差，同样承载公理超出预设的全部内容，只是一步，而不是沿分级联系的许多小步，所以不继承连锁悖论的反驳。
- **每个前提都需要。** `Clearing` 的四个见证各去掉一个前提或改变可容许类，公理都不成立。
- **所及之内的部分。** 沿影响次真的预设，对所及闭包之内的每个部分作公理的比较，不用不变，也不用超真（`presupposed_reach_comparison`）。这是 P42 比较的推论，读 Ren 的较弱版本。沿共享条件次真推出沿影响次真（`presupposition_order`），所以沿影响的前提较弱。每个中心的闭包都是整体时，不变平凡地成立（`unrestricted_iff_presupposed_of_whole`）：这一步没有被消除，而是移进了把自身的边界划成对关系封闭这一点。

**作者反审。**
1. **覆盖由构造成立。** 沿一个关系，含中心的每个封闭区域，整体在内，都算作自身的一种可容许划法，所以覆盖不用另加前提。这一可容许性是实质的选择；它也使可容许类不是对日常的、模糊的“自身”的超赋值：它没有确定的非成员（`subTrue_member`）。Ren 的“There is no absolute self”本身不给出覆盖；“we”是“the universe/ecosystem that realizes its own existence”支持把整体作为“we”的一种划法。
2. **对手在哪里。** 沿一个关系覆盖由构造成立，所以对手否认的是另一个前提。把意义奠基于已形成闭包的对手（如运作闭合），沿该闭包不对之封闭的关系否认次真，沿它对之封闭的关系否认不变，只有它也把可容许的划法限于那个闭包时才否认覆盖。模糊的自身在陌生者被每种划法排除处否认覆盖，在陌生者处于边缘处否认不变。降到零的分级权重，在闭包之内降到零否认次真，在闭包之外否认不变。现时目的的评价者否认次真。这里定位这些否认，不驳倒它们。
3. **预设与 Ren 的 belief。** Ren 写自身“can not justify itself without some sort of "belief"”，是在说自身层的限度。把这一 belief 用作前提，是 AI 的一步；沿一个关系次真，远强于某个延续有意义。
4. **不变与 Ren 的“universal invariations”。** Ren 的不变是规律跨宇宙的不变：“for every universe, becoming happens, the law follows”。“for all beings”最直接地读作对立场不变，即 N_std 的规则。把不变推广到意义，是 AI 的读法。
5. **文献只依据先前知识。** 超赋值（Fine 1975）、次赋值（Hyde 1997）、Nagel（1970）的行动者相对与行动者中立的理由、Gewirth（1978）的类属一致性原则及其批评、Parfit（1984）、Sidgwick 的实践理性的二元，都依据先前知识，没有重读原文。这里只用它们定位这一步：从行动者的立场到不偏的伦理的论证，正是在这一步上受到争议；Parfit 把没有深层的自我读作削弱自利理论的特权，对应覆盖；这一步不消解 Sidgwick 的二元，只把它定位在这一步上。
6. **层级次序（AI 的读法，待 Ren）。** Ren 的“the whole, and a weaker version is within the system that one is in, then the self”读作预设的三种读法：超真；沿影响次真，在所及闭包处；沿空关系次真，在自身处。所及闭包指向前方，所以在这一读法上，次序一路降到单纯的自身，不经过供给闭包，供给闭包在 `presupposition_order` 的另一支上。这一方向是否合适由 Ren 判断。
7. **“the continuation goes beyond one’s cycle of life, goes beyond one’s death”没有用到。** 它更自然地支持按谱系个体化与按时间先后的所及，列为开放。

**检查。**
- 模块在暂存区编译，逐条审计全部 64 项声明，公理报告全部为空；全部是项证明。
- 合并检查器回执 20261010T174514.186722Z：`Becoming.Boundaries` 的 47 项定理全部空依赖。外围回执 20261010T175236.872210Z。

### 62.1 第十六次独立审查与处理

落地时的更正（2026-10-11）：本审查在分支上称第十五次；R1–R2 的审查（[BECOMING-R1-R2-REVIEW.md](../history/root-foundation/BECOMING-R1-R2-REVIEW.md)）先落地为第十五次，这里改称第十六次，内容不变。

另一 agent（Claude Opus 5.5，未参与撰写）在整合之前审查了 P42 与 P43 的暂存稿，以及应协调者要求追加的扩展（[审查](../history/root-foundation/BECOMING-P42-P43-REVIEW.md)）。它对被审文件逐字节重编译，审计两个模块与扩展的全部声明，公理报告全部为空；142 个探针声明全部是项证明，没有经典推理。判断：Lean 全部成立；问题在模块层的散文、AI 的读法与框架，不在证明。下表是十六项更正的处理；表中的定理名是整合后的名称。

| 项 | 审查所见 | 处理 |
|---|---|---|
| 1 | 把系统读作 Ren 的中间层级，中间层级坍缩为整体：一个共同条件就使系统成为整体，系统是类，没有嵌套与中心（F1） | 撤回这一读法；为它提供所及闭包（`Flow.Affects`、`Flow.WithinReach`、`Flow.reaches_withinReach`、`Flow.withinSystem_of_withinReach`、`Clearing.reach_middle`、`reach_centred`、`reach_counts_dweller`），写明它指向前方、不必含供给闭包；加入 `Flow.system_whole_of_common`、`Boundary.only_whole` 与拆分后的 `Clearing.system_whole`；`Becoming.Interdependence` 的读法与章节 §6.9 加更正，P40 把供给闭包读作所在系统的读法撤回 |
| 2 | 较弱版本给出整体对系统之内每个行为的判断，说得过宽（§4） | 写明范围：所及之内、无它的水平存在的每个部分，其余交换固定；系统是整体时，前提就是该立场上的公理 |
| 3 | “由三个前提推出公理”是分解，不是化约；“derived, not assumed”不成立（F6） | 标题改为“The axiom decomposed: where its content lies”；加入 `boundaryInvariant_iff_conditional`、`boundaryInvariant_iff_determinate`、`not_subTrue_of_invariant`（审查的 `invariance_levels_down`），扩展 `boundaryInvariant_iff_all`；撤回“derived, not assumed”；写明复用 `Valuation.significant_iff`、`Valuation.significant_iff_held` 与 P39 的边界中立；补上“像容差连同 Chain 一样，承载公理在预设之外的全部内容” |
| 4 | 两种反事实：影响闭包的动机是经他者的影响，而识与比较定理固定其余交换（F2） | 两个模块的说明加上这一点；加入见证 `Trophic.mediated_unregistered`（审查的 `protection_invisible`）、`responsive_mixed`、`Clearing.no_levels_without_source`；影响闭包的读法加“once effects pass through the support and activity of others”。审查之外另加 `Flow.Balances.comparison_within_difference`：任意两个流的比较在其差别所及之内决定，他者的回应在差别之内 |
| 5 | 扩展的标题与主张 (2)–(4) 说得过多，`Clearing.system_whole` 的位置不能编译（§6） | 标题改为“有了预设与中心覆盖，两种形式等价：那时每种都是公理”；`unrestricted_iff_presupposed_of_whole` 的说明写明“because the whole is then the only boundary”；不把 `Flow.unrestricted_iff_system_presupposed` 读作 Ren 的“highly entangled system”；主张 (4) 改为“在一个系统之内的只到达系统之内，在系统之外的到达不了系统之内”；`without_standpoint_invariance` 的说明与陈述对齐；`Clearing.system_whole` 按 `merge_ext.py` 拆分，Boundaries 另立 `Clearing.system_presupposition` |
| 6 | 对手的位置：在模块自己的边界下，闭包对手否认的是次真或不变，不是覆盖（F9） | 按审查的文字改写：沿一个关系覆盖由构造成立，各对手否认另一个前提，并加入分级权重与现时目的的评价者 |
| 7 | 对 Ren 的归属过度（§5） | “three claims Ren holds”改为“three claims the assistant read from Ren's words”；不变一条改为：“for all beings”最直接地读作对立场不变，“universal invariations”是规律跨宇宙的不变，推广到意义是 AI 的读法；预设一条加：Ren 写的是自身的限度，把 belief 用作前提是 AI 的一步 |
| 8 | 覆盖由可容许类构造进去（F7） | 改为：沿一个关系，覆盖成立，是因为含中心的每个封闭区域，整体在内，都算作自身的可容许划法；这一可容许性是实质的选择 |
| 9 | 超赋值术语（F8） | 注明超真取自 Fine 1975、次真取自 Hyde 1997；可容许类没有确定的非成员；不变就是确定（`boundaryInvariant_iff_determinate`）；两种辖域写成一个定理（`presupposition_scopes`） |
| 10 | 层级次序没有定理（F10） | 加入 `Flow.presupposition_order`（审查的 `presupposition_levels`）；次序的读法随所及闭包改为：超真；沿影响次真；沿空关系次真；`Clearing` 中沿共享条件与超真重合（`Clearing.system_presupposition`） |
| 11 | “the whole need not be admissible”有误导：沿共享条件整体总可容许 | 改为“Neither invariance nor super-truth is used” |
| 12 | “恰在其行为到达闭包之外处误判”有反例（F5，C3） | 改为：部分只到达闭包之内时作公理的比较（`Flow.Balances.comparison_local`，审查的 `verdict_local`）；到达之外时可以误判；到达之外本身不使它误判（`Margin.reach_without_misjudgment`） |
| 13 | 正面形式的增加判断（F4） | 加入 `Flow.Balances.adds_iff_exceeds_of_decidable` 与 `not_not_adds_of_exceeds`；“不推出的”改为：正面形式在意义可判定处成立，一般只到双重否定 |
| 14 | 局部的说明与陈述 | `system_retains_iff`（只给保留，公理只用来改写包含）换成不用公理、四个比较都给的 `Flow.Balances.closed_comparison`；`own_presupposition` 的说明改为“is met by a significance under which the part retains”；Boundaries 的“不推出的”加上预设本身是给定的、沿关系已带着传递；`superTrue_all_iff` 补上“where the whole is admissible” |
| 15 | 记录与复用 | P43 的记录写明复用 metaethical-core-characterization、held-lives-g0-is-centering、one-axiom-yields-g0 与 feeding-closure，增量是边界与超赋值的表述、两种辖域与对手的定位；`retains_agree_of_presupposed`、`Valuation.significant_of_presupposed` 写作推论；P42 的记录写明推进 closure-verdict-meets-axiom，`presupposed_comparison` 写作 comparison-within-reach 的推论 |
| 16 | 名称（Ren 的命名准则） | `Protection` 改为 `Trophic`（营养级联；审查建议的 `Cascade` 已是 `Becoming.Reserve` 中的命名空间）；`guards` 改为 `mediates`；判断（verdict）改为比较（`comparison_local`、`comparison_within_reach`、`closed_comparison`、`presupposed_comparison`、`presupposed_reach_comparison`）；“conduct”改为“a part's exchange”；假设名 `entangled` 改为 `connected`。审查之外，按同一准则另改：`commons`（经济学用语）改为共同条件（`system_whole_of_common` 等），`unguarded` 改为 `responsive`，`protection_unregistered` 改为 `mediated_unregistered` |

**审查之外的加强。** 比较定理改用按时间先后的 `ReachesBefore`（审查的 B4）；`closed_comparison` 不用公理；任意两个流的比较（`comparison_within_difference`、`difference_reaches_forest`）；共同条件下的所及闭包与供给闭包（`reach_whole_of_common`、`feeding_whole_of_common`、`feeding_unrestricted_of_common`：在某步每个形成都需要一个条件并向它给予时，路线 (b) 就是公理）；`Static.shares_unaffected`。

**边界。** 无伦理结论；不替 Ren 选择任何读法。仍开放：所及闭包是否读出“the system that one is in”、预设是否读出 Ren 的 belief、Ren 是否持有不变的一步（属于 Ren 的选择）；动力学给出回应的比较、按步的闭包、中心怎样表示其所及、耦合的度量（进一步的证明）；预设、覆盖与不变的根据（哲学根据）。本节与 §61 经第十六次审查；处理之后的文本尚未经独立审查。

## 63. 有限世界中与被围住时前提起约束的计数（P46）

2026-10-11。按 Ren“let's aim for the strongest claim without axiom, as the first part, and add one axiom, as the following part, the no axiom part is most important and elegant”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）与“aim a complete theory of becoming, and finish related work”继续。P45 留下两项开放（§60 反驳 4，whole-law-of-counting 与 counting-under-enclosure 的下一步）：有限世界中每个选择之下所选前提都起约束时计数的规律，以及从某步起被围住且每个前提都起约束时的规律。本节给出这两项，并给出两者之间的一项：从某步起被围住时每个选择之下所选前提都起约束时的规律。这样，前提起约束时计数的规律在不限制、有限与从某步起被围住三类世界中都已陈述。

```text
Result(s): 扩展 counting-under-enclosure（有限世界中与从某步起被围住时，每个选择之下所选前提都起约束时计数的规律）；
           修订 whole-law-of-counting（开放项改指 counting-under-enclosure）；没有新的成果记录
Delta: Counting：World.enclosedQueue_saturated_binds、World.enclosed_binding_counting；RelayRing 与 World.relayRing
       （_balanced、_dissipative、_acts、_binds、_binding）；LossyRing 与 World.lossyRing（_dissipative、_taking、_acting、
       _binds、_binding）；Ring.exchanged、Ring.exchanging 与 World.exchangingRing（_balanced、_taking、_acting、_binds、
       _binding）；World.BoundsChange 可判定；World.finite_binding_census、World.finite_binding_counting_under、
       World.finite_binding_activity_iff、World.finite_binding_arising_iff、World.finite_binding_joint_iff；
       World.relayQueue_enclosed、World.lossyQueue_enclosed；EnclosedQueue.exchanged、EnclosedQueue.exchanging 与
       World.exchangingQueue（_balanced、_taking、_acting、_enclosed、_binds、_binding）；last_positive、Tally.occupied_from；
       EnclosedQueue.sub_add_le、store_succ_le、spare、held、sheddingWeb、shedding、spare_zero、held_outside、shedding_closed、
       shedding_flows 与 World.sheddingQueue（_balanced、_embodied、_enclosed、_level_le、_exceeds、_dissipative、_binds、
       _binding）；World.enclosed_binding_counting_under、World.enclosed_binding_activity_iff、
       World.enclosed_binding_arising_iff、World.enclosed_binding_joint_iff。已有声明不变
Supplied premises / correspondence: 不变；起约束仍是条件有实例（P41b）
Evidence: 合并检查器回执 20261011T001147.906623Z（2022 项定理、3071 项声明审计，全部源声明公理报告为空；Counting 212），外围回执 20261011T001754.342153Z；
          新声明先在暂存树中从前导编译，逐条 #print axioms 全部为空
Boundary: 只是活动的计数；更强的起约束读法仍开放（由 Ren 选择）；尚无独立审查
Integration: 章节第 3 条、第一部分的总陈述、§8、§9 的脊柱表与术语表；计划 P46；模块说明、根模块、包 README 与检查器的范围
```

**从某步起被围住且每个前提都起约束。** 全部八个前提之下，从某步起被围住时计数的规律是计数表、没有关系项活跃的一步上没有生起与从第 0 步起的变化界（`World.enclosed_counting`，P35）。每个前提都起约束时只多出有某个生起（`World.enclosed_binding_counting`），与不限于被围住时（`World.binding_counting`）和有限世界中除普查外每个前提都起约束时（`World.finite_binding_counting`）一样。见证是被围住的队列把依存网饱和：有成员在第 T 步加入时，加入者生起而改变所立，从队首传下，步后活跃并依存于自身的所立；队首从第 T 步的跨度取用，跨度封闭，耗散只许它给予少于所取的；关系项是自然数，没有有限的列表包含全部，所以普查也起约束（`World.enclosedQueue_saturated_binds`）。

**有限世界中每个选择之下。** 没有有限世界使普查起约束，所以在选中普查的选择之下，有限世界中每个性质都是规律（`World.finite_binding_census`）。不选普查时，回答是有限世界中该选择之下的规律（`World.finite_counting_under`：每步至多有某数活跃；约束计数或约束变化时没有关系项活跃的一步上没有生起；约束变化时从第 0 步起的变化界），再加至多三条（`World.finite_binding_counting_under`）：

1. *有关系项活跃*，恰在选中活动需要支持、只有活跃者给予、只有活跃者取用或体现时（`World.finite_binding_activity_iff`），与不限于有限世界时相同。
2. *有某个生起*，恰在选中体现时（`World.finite_binding_arising_iff`），也相同。
3. *在有关系项活跃的一步上有生起*，恰在选中体现，且选择约束计数或约束变化，或选中有界传递并选中只有活跃者给予、或同时选中只有活跃者取用与耗散时（`World.finite_binding_joint_iff`）。与 P45 不同之处有两个，§60 反驳 4 已预见：有限世界的每一步都被围住，所以平衡、体现与耗散本身就约束计数（`World.enclosed_binds_counting`），第 2 条的生起之步上就有关系项活跃；只有活跃者取用与耗散在被围住的步上推出只有活跃者给予（`World.Finite.acting`），所以有界传递起约束时，传下所从出的给予者在该步活跃。

每条的反方向与 P45 相同：什么都不发生的计数表、每步一个关系项而无生起的计数表、一个关系项在第一步从无到有地生起并留下（`Queue.lone`），都由满足选择且所选前提都起约束的有限世界实现。

**有限的见证。** P45 的见证有无限多个关系项，有限世界需要有限的见证。它们都按 P38b 把计数表的队列排在一圈位置上（`Ring.slot`、`Ring.counts`），并把依存网饱和：

- *环旁的传递*（`World.relayRing`）：位置 1 到第 U 步为止立着两个单位，参与者 g 在第 U 步取用这两个单位，给位置 0 一个，失去另一个；位置的所立与它是否被占无关，所以不满足体现，只用于不选体现的选择。选中活动需要支持、只有活跃者给予或取用时，g 取为第 U 步队首的位置，那时活跃（`World.relayRing_binding`）。圈按 M+1 取大小，至少有两个位置。
- *有损的环*（`World.lossyRing`）：每个位置被占时立着一；跨第 U 步，队首的位置与自身及每个开始被占的位置各交换一个单位，再失去一个单位。所立者不记录这些，所以它不平衡；它对任何计数都耗散（封闭的家族含队首的位置，队首多取了一个单位）。用于选中体现而不选平衡、并选中耗散或只有活跃者给予的选择：选中有界传递，并选中只有活跃者给予、或同时选中只有活跃者取用与耗散时，U 取为第 3 条规律给出的步；不选有界传递时，U 取为生起之后一步，那时队列不空；两个给予与取用的条件都不选时，U 取为生起之步，队首的位置不被占也可以给予与取用（`World.lossyRing_binding`）。
- *交换的环*（`World.exchangingRing`）：P38b 的平衡的环（队首的位置取用每个位置所降的、给予其所升的），在生起之后一步，队首的位置再与自身各交换一个单位，使取用起约束；它满足除耗散外的全部前提，没有成员加入空队时也满足只有活跃者给予（`World.exchangingRing_binding`）。用于选中体现、不选耗散，且不选平衡时也不选只有活跃者给予的选择。
- *饱和的有限队列*（`World.finiteQueue_saturated_binds`，P45）：选中平衡、体现与耗散，即约束变化时。

按体现、平衡、耗散、只有活跃者给予、取用与有界传递分情形，每个情形都由其中一个见证实现，所以 iff 的两个方向都在 Lean 中检查。

**从某步起被围住时每个选择之下。** 在每个选择 S 之下，从某步起被围住、S 所选前提都起约束时，计数的规律是被围住时该选择之下的规律（`World.enclosed_counting_under`：约束计数时没有关系项活跃的一步上没有生起；约束变化时从某步起的变化界，此后没有关系项活跃的一步上没有生起）再加 P45 的三条（`World.enclosed_binding_counting_under`），每条恰在与不被围住时相同的选择之下多出（`World.enclosed_binding_activity_iff`、`World.enclosed_binding_arising_iff`、`World.enclosed_binding_joint_iff`）。所以从某步起被围住时，被围住与起约束各自加上自己的规律，互不相干；有限世界中两者相干，因为那里生起之步本身也被围住。普查在这里可以起约束，因为见证有无限多个关系项。

见证都在某步之后被围住：

- *传递*（`World.relayQueue`，P45）在每一步被围住，它取用与给予的都在两个地关系项中（`World.relayQueue_enclosed`）；*有损的队列*（`World.lossyQueue`，P45）从地关系项的给予之后一步起被围住，跨度含队首与加入者（`World.lossyQueue_enclosed`）。
- *交换的队列*（`World.exchangingQueue`）：被围住的队列在生起之后一步让队首与自身再交换一个单位，使取用起约束；它在每一步被围住，满足除耗散外的全部前提，没有成员加入空队时也满足只有活跃者给予（`World.exchangingQueue_binding`）。用于选中平衡与体现而不选耗散的选择。
- *饱和的被围住的队列*（`World.enclosedQueue_saturated_binds`）：选中平衡、体现与耗散，并选中只有活跃者给予或取用时，选择约束计数，从第 0 步起的变化界由被围住时的变化界给出（`ChangeBound.from_zero`）。
- *失去多立单位的队列*（`World.sheddingQueue`）：选中平衡、体现与耗散而不选只有活跃者给予与取用时，耗散只能在封闭的步上起约束，而在平衡与体现之下封闭的家族失去一个单位，需要有所立者先多立一个单位。生起却可以只在被围住之前，从无到有，此后计数不再变化（如 `Queue.lone`）。所以先找一步 T′，那时有关系项活跃，此后没有关系项活跃的一步上没有生起（`Tally.occupied_from`：若变化界之步 T 上有关系项活跃，取 T；否则若生起不在 T 之前，取生起之步；否则取 T 之前最后一个有关系项活跃的步，`last_positive`，在有限的步中搜索）。队列在 T′ 闭合（此前每个关系项与队首各交换一个单位，没有封闭的家族），队首在 T′ 多立一个单位，跨 T′ 时失去它（`EnclosedQueue.spare`、`EnclosedQueue.held`），于是跨度在 T′ 失去的多于所给（`World.sheddingQueue_exceeds`），耗散起约束；T′ 之后它与被围住的队列相同（`EnclosedQueue.shedding_flows`）。它从 T′ 起被围住，满足选择，每个前提都起约束（`World.sheddingQueue_binds`、`World.sheddingQueue_binding`）。

**作者反审。**

*反驳 1：有限世界中的第 3 条是否只是改写了 P45？* 不是。它在有限世界中恰在更多的选择之下成立。选中体现、平衡与耗散而不选只有活跃者给予与取用时，P45 中一个关系项可以从无到有地生起（只闭合一次的队列），有限世界中不能：那里这个选择约束变化，因而没有关系项活跃的一步上没有生起。选中体现、只有活跃者取用、耗散与有界传递而不选平衡与只有活跃者给予时，P45 的有损的队列让一个地关系项给予每个关系项，传下由它而来；有限世界中每一步都封闭，给予须伴随损失，给予者于是取用而活跃。两处差别都由 `World.finite_binding_joint_iff` 确认。

*反驳 2：选中普查时“每个性质都是规律”是否空洞？* 是空洞的，而且如实：普查起约束即世界不有限，所以这类选择在有限世界中没有实例。单独陈述它（`World.finite_binding_census`），256 个选择在有限世界中就都有了回答。

*反驳 3：环旁的传递让未被占的位置立着单位，是否违背关系的读法？* 它只用于不选体现的选择，那里所立与活跃本来可以分开，体现正是使二者一致的前提。选中体现时用的是有损的环、交换的环与有限的队列，那里每个位置恰在被占时立着。

*反驳 4：从某步起被围住为何不像有限世界那样使第 3 条在更多的选择之下成立？* 因为被围住只从某步起：生起可以在被围住之前、在没有关系项活跃的一步上从无到有，被围住之后的变化界与没有关系项活跃的一步上没有生起都不触及它。失去多立单位的队列确认这一点：`Queue.lone` 由一个从第 1 步起被围住、满足平衡、体现与耗散且每个前提都起约束的世界实现。代价只是耗散的实例要放在被围住之后有所可失的一步上，这需要在有限的步中搜索那一步；变化界之步作为规律的一部分给出（P38b），所以搜索是有界的，不需要全知。

*反驳 5：多立的单位是否是为了见证而造的？* 是见证的构造，不是规律的内容：它只说明，在平衡、体现与耗散之下，一个封闭的家族要失去什么，须有所立者先立着它。规律本身（`World.enclosed_binding_counting_under`）不提到它。

**读法（AI，待 Ren）。** 起约束在计数上留下的仍只是它的实例。有限世界与从某步起被围住的世界的差别在于生起之步：有限世界的每一步都被围住，所以更多的生起须从活动而来；从某步起被围住时，生起可以在被围住之前，被围住与起约束各自加上自己的规律。

**边界。** 离散步，活动的计数；水平与依存的计数在前提之下、更强的起约束读法仍开放；没有伦理谓词；名称（relayRing、lossyRing、exchangingRing、exchangingQueue、sheddingQueue、spare、held 等）是 AI 按 Ren 的命名准则所选，形式而描述动力学；尚无独立审查。

## 64. G0 各处用法的审计（P44）

2026-10-11。Ren 的公理：“for anything, its continuation into the future has significance(doesn't have to be positive, we could argue as long as not harm), or continuation into the future needs to create more significance(being generative)”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-wanting-continuation-one-axiom.md)）。P39 表明它推出 G0（§53）。P40 之后，AI 对“是否以这条公理替代 G0”的回答是分两步：先审计 G0 每处用法对 `living` 的读法，再替换；Ren 写道：“continue, let's pursue the strongest claims and complete proof, i think you see the right direction”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-strongest-claims-direction.md)）。AI 把它读作接受这一次序（AI 的读法，待 Ren）。这是工作次序 (d)。

本节是计划 P44，由本会话完成。核心新增模块 `Becoming.Relevance`，30 项定理，导入 `Becoming.Boundaries` 与 `Becoming.Ranking`；桥接新增 5 项定理；内容放进章节 §6.12。结论：审计是干净的，其中一处读法是被迫的；在公理之下，以可能性读的 C 决定了 `Ranking` 留给读法选择的过度汲取，且不扣下任何事件。替换本身属于 Ren，G0 仍是所采用的公理。成果记录不新增，扩展两项：
- [one-axiom-yields-g0](../../../../theories/becoming/results/records/continuation-condition-yields-living-significance.md)：G0 的每处用法由公理解除；公理就是对任何东西的 G0；理由前提须读在活的内容上；普遍理由不用连通。
- [ranking-under-readings](../../../../theories/becoming/results/records/ranking-under-readings.md)：可能性读法，以及可能性优先的次序。

```text
Result(s): 复用 one-axiom-yields-g0（Unrestricted、Valuation.premises_of_unrestricted、Web.paths）、ranking-under-readings
           （course、absent、undisturbed_sustains、ExtendsUnder、ComparisonUnder、wholeRun、stepwise、credited_before_loss、
           stops_credited、restraint、contest、sharing_credited、ThirdParty）、significance-retained-within-margin（Web.Retains、
           Web.Adds、Includes.retains、Retains.not_added）、four-cases-of-a-part（Web.Admits、Web.Includes、Admits.mono）、
           metaethical-core-characterization（SecuresPositiveGround、articulates、PositionedArticulation、universal_reason 的论证）、
           becoming-spine-instances（Frame.inventory、g0_iff）、relational-renewal-classification（overdraw_consuming、
           within_renewal_sustains、unfolding_dependent、malignant、sharing、winning）；扩展 one-axiom-yields-g0 与
           ranking-under-readings
Delta: 正面相关从意义读出：Frame.relevance、g0_of_unrestricted、relevance_least。公理就是对任何东西的 G0：
       unrestricted_iff_g0、Web.paths_somewhere、Web.unrestricted_iff_paths_g0。理由前提：securesPositiveGround_total、
       articulatesLiving、articulates_total、positioned_articulation_of_articulatesLiving、universal_reason_living、
       universal_reason_of_unrestricted、Widening（valuation、admitted、before、bare_forces_reason）。水平处处不低：
       Web.Includes.of_le、Web.not_added_of_le。可能性读法：Ranking.possible、possible_of_active、absent_admits_all、
       possible_extends、possible_ranks、possible_course_iff、possible_extends_iff、malignant_possible、possible_contest、
       possible_restraint、ThirdParty.possible_extends、possible_tie、readings_rank_presence、sharing_presence。可能性优先：
       possibleFirst、possibleFirst_order、possibleFirst_overdraw、possibleFirst_presence、Rest（courses、rest_ranked_below）。
       桥接：inventory_g0_of_unrestricted、relevance_inventory_iff、new_realization_of_unrestricted、
       contingent_generation_of_unrestricted、every_situated_position_has_reason_of_unrestricted
Supplied premises / correspondence: 公理（Unrestricted）只作假设出现；正面相关读作已实现的活的内容的意义、A 读在活的内容上、
       可能性读法与可能性优先的次序都是定义；C 只作定义 Comparison 出现；读法与名称是 AI 的，待 Ren
Evidence: 合并检查器回执 20261010T214440.263682Z；外围回执 20261010T222130.672025Z；对 G0 全部出现的逐处阅读（下表）
Boundary: 审计的完整性来自逐处阅读，Lean 证明的是解除引理，以及桥接已导入的三项定理的转移；从意义到理由的一步（A）仍是前提；
          比较继续用哪一种属于 Ren；G0 仍是所采用的公理，直到 Ren 接受替换
Integration: 计划 P44（工作次序 (d)）；把 P39 的“G0 推出”推到 G0 的每处用法；回答 Ranking 留下的问题的一部分：在公理之下，
             以可能性读的 C 给出整段读法把没有过度汲取或消耗的继续排在上面的每个排序，而不扣下任何事件
```

**审计。** `grep` 出 G0 在核心（9 个文件）与外围 generative-capacity（19 个文件）中的全部出现，逐处分类：

| 位置 | 用法 | 在公理之下 |
|---|---|---|
| `Metaethics`：`G0`、`Valuation.g0` | G0 的定义；主张层的 G0（`Valuation.Significant`）给出框架上的 G0 | 主张层的 G0 由公理推出（`Valuation.premises_of_unrestricted`，P39）；框架上的 G0 由 `g0_of_unrestricted` 给出，正面相关读作已实现的活的内容的意义 |
| `Metaethics`：`articulates`（A）、`positioned_articulation_of_articulates`（D）、`universal_reason` | 正面相关进入理由前提：A 以裸意义写出 | 一切都有意义时，以裸意义读的 A 给产生任何新内容的回应以理由（`articulates_total`、`Widening.bare_forces_reason`）；读在活的内容上的 A（`articulatesLiving`）给出 D（`positioned_articulation_of_articulatesLiving`）与普遍理由，且不用种子、中立或连通（`universal_reason_of_unrestricted`） |
| `Standpoints`、`Correspondence`、`Descent`、`Boundaries` | 主张层 G0 的刻画（处处 S0 加 N_std；种子加 N_rel 与 N_std）；中立不成立处 G0 不成立的反模型；P43 的推论 | 刻画是等价式，不受影响；公理推出等价式的两边（P39）；反模型定位公理所排除的有界规则 |
| `Significance` | 公理推出 G0 | 替换的依据 |
| `Ranking` | C 在两种 `living` 读法下的排序；不出现 G0 | 不受影响；在公理之下，以可能性读的 C 决定过度汲取族（见下） |
| `Interdependence`、根模块 | 只在说明中提到 G0 | 不受影响 |
| `Bridge` | 核心的 G0、C、D 按定义即外围的（`g0_iff` 等） | 新增五项，见下 |
| 外围 `GenerativeComparison.new_realization_has_positive_relevance` | 以 G0 为假设 | `new_realization_of_unrestricted` |
| 外围 `PositiveGroundUncertainty.contingent_generation_has_positive_ground`、`certified_integral_supplies_contributory_reason` | 以 G0 为假设；后者另有理由前提 `articulate : ∀ h q, positive h q → reason h` | 前者：`contingent_generation_of_unrestricted`；后者以从意义读出的正面相关实例化，理由前提保持其范围；以裸意义实例化，理由前提就要求每条历史都有理由 |
| 外围 `PositionedPositiveReason.every_situated_position_has_reason`、`g0_holds` 及其模型 | 前者以 G0 与 D 为假设；模型中 G0 成立（`g0_holds`），有通达而不背书的立场有理由，背书而无通达的没有 | `every_situated_position_has_reason_of_unrestricted`，D 读在从意义读出的正面相关上；模型中取处处成立的意义，公理成立，`g0Relevant` 就是从意义读出的正面相关（`living` 读作生成的），决定理由的仍是通达而不是背书 |
| 外围 `ProtectionPriorityRival.g0_recognizes_traded_gains`、`g0_leaves_ordering_open` | 以 G0 为假设；G0、C 与 J2 共存而 G0 不约束次序 | 前者以实例化解除；后者的模型中取处处成立的意义，公理成立，公理同样不约束次序 |
| 外围 `OpenFutureRevision.positive_ground_by_bound` | 以 G0 为假设 | 以实例化解除 |
| 外围 `RenewingFormation.event_reading_recognizes_both` | 在把每个已实现事件都算作生成的宽清单上以 G0 为假设 | 以实例化解除；公理同样给两个继续的事件以意义，区分要靠比较（见下） |
| 外围 `EvaluatorGrounding.reach_is_g0`、`self_good_derives_reachable_g0` | 推出一个立场、一条历史上的 G0 实例 | 不以 G0 为假设，不受影响 |
| 外围其余十二个文件 | 只在说明中提到 G0 | 不受影响 |

| 声明 | 内容 |
|---|---|
| `Frame.relevance`、`g0_of_unrestricted`、`relevance_least` | 从意义读出的正面相关：已实现、其延续从每个立场都有意义的活的内容；在公理之下，它在每个框架上、对 `living` 的每种读法满足 G0，且是满足 G0 的最小者，恰是已实现的活的内容 |
| `unrestricted_iff_g0`、`Web.paths_somewhere`、`Web.unrestricted_iff_paths_g0` | 在主张是形成在某步、每个主张都在某处实现的框架上，公理恰在 G0 以每个主张为活、以从每个立场的意义读正面相关时成立；每个依存网的水平路径都是这样的框架 |
| `securesPositiveGround_total`、`articulatesLiving`、`articulates_total` | 一切都有意义时，以裸意义确保根据就是确保任何新内容；以裸意义读的 A 给产生任何新内容的回应以理由，读在活的内容上的 A 给确保新的活的内容的回应以理由 |
| `Widening.bare_forces_reason` | 见证：唯一的新内容不活；以裸意义读的 A 迫使理由，读在活的内容上的 A 被空理由满足 |
| `positioned_articulation_of_articulatesLiving`、`universal_reason_living`、`universal_reason_of_unrestricted` | 读在活的内容上的 A 给出 D；主张层的 G0 加这一 A 给出普遍理由；在公理之下，不用种子、中立或连通 |
| `Web.Includes.of_le`、`Web.not_added_of_le` | 水平处处不低的路径包含另一条，从不被保留且增加排在下面 |
| `Ranking.possible`、`possible_of_active` | 可能性读法：继续的水平容许某形成之处记入它，活跃与否；在依存的继续中它记入每个活跃的形成 |
| `absent_admits_all`、`possible_extends`、`possible_ranks` | 没有焦点形成的继续每步容许每个形成；在定律族的每个定律中，超出更新地汲取者不在场的继续扩展它在场的继续，每个满足 C 的比较都把前者排得更高 |
| `possible_course_iff`、`possible_extends_iff` | 同一定律的两个继续有同样的所需；在公理之下，按可能性读法的扩展就是在定律的网上保留且增加有意义者 |
| `malignant_possible` | 恶性增殖：可能性读法把不在场排得更高，并记入它的第一个事件；逐步读法记入它，整段读法扣下它 |
| `possible_contest`、`possible_restraint`、`ThirdParty.possible_extends` | 共享扩展以消耗取胜；二元族中节制扩展过度汲取；有第三个形成时亦然，那里逐步读法不排序 |
| `possible_tie`、`readings_rank_presence`、`sharing_presence` | 在更新之内汲取的形成不增加可能性：两个继续容许同样的形成，互不扩展；两种 `living` 读法都把它的在场排得更高；共享是实例 |
| `possibleFirst`、`possibleFirst_order`、`possibleFirst_overdraw`、`possibleFirst_presence` | 先比可能性、再比一种读法所记入的事件：在可能性读法下满足 C，非自反、传递；不论第二步用哪种读法都把过度汲取者的不在场排得更高，第二步用任一种 `living` 读法都把在更新之内的在场排在不在场之上 |
| `Rest.rest_ranked_below` | 一个被支持而在第 0 步休息的形成：两个继续的可能性相同；可能性优先把休息排在不间断的活动之下 |
| 桥接 `inventory_g0_of_unrestricted`、`relevance_inventory_iff` | 在公理之下，外围的 G0 对每个清单成立，正面相关读作已实现、其延续有意义的生成内容；在框架的清单上它就是核心的 `Frame.relevance` |
| 桥接 `new_realization_of_unrestricted`、`contingent_generation_of_unrestricted`、`every_situated_position_has_reason_of_unrestricted` | 由公理推出：生成扩展的新实现、偶然的生成所确保的正面根据，以及定位表达的普遍指向（D 读在从意义读出的正面相关上） |

**它回答了什么。**
- **替换是干净的。** 每处以 G0 为假设的用法，都对任意的正面相关成立。从意义读出的正面相关在公理之下满足 G0（`g0_of_unrestricted`），且是满足 G0 的最小者，恰是已实现的活的内容（`relevance_least`），也就是外围模型中的 `g0Relevant`。所以每处用法由它解除；桥接对外围的接口作出这一点（`inventory_g0_of_unrestricted`），并写出桥接已导入的三项定理。刻画是等价式；反模型取处处成立的意义就满足公理；两者都不受影响。
- **公理就是对任何东西的 G0。** 在每个依存网的水平路径上，公理恰在 G0 以每个主张为活、以从每个立场的意义读正面相关时成立（`unrestricted_iff_g0`、`Web.unrestricted_iff_paths_g0`）。P39 说 G0 是公理限于活的主张；这里反过来：公理是 G0 扩到任何东西，并把“正面”减弱为“有意义”。所以替换不是换上一条外来的公理，而是 G0 自身的形式取最宽的辖域。
- **一处读法是被迫的。** 一切都有意义时，以裸意义读的 A 给产生任何新内容（活的与否）的回应以理由（`articulates_total`）；见证中唯一的新内容不活，裸意义的 A 仍迫使理由，读在活的内容上的 A 不迫使（`Widening.bare_forces_reason`）。所以在公理之下，正面相关必须读作活的内容的意义：意义不是正面相关，这也是 Ren“doesn't have to be positive”的一种读法。如此读，A 给出 D（`positioned_articulation_of_articulatesLiving`），普遍理由由公理推出，不用种子、N_rel、N_std 或连通（`universal_reason_of_unrestricted`）。前提卡上这四项都由公理给出，A 仍是前提。
- **在公理之下，C 以可能性读。** 可能性读法在一个继续的水平容许某形成之处记入它，活跃与否（`Ranking.possible`）。对同一定律的两个继续，在公理之下按此读法的扩展就是保留且增加有意义者（`Ranking.possible_extends_iff`），即 P39 的比较。在定律族的每个定律中，它把没有过度汲取者的继续排在有它的之上（`possible_ranks`）；在二元族中把节制排在过度汲取之上（`possible_restraint`），有第三个形成时亦然，那里逐步读法不排序（`ThirdParty.possible_extends`）；它也把共享排在以消耗取胜之上（`possible_contest`）。它不扣下任何事件：在依存的继续中它记入每个活跃的形成（`possible_of_active`），包括恶性增殖者的第一个事件；逐步读法记入这个事件，整段读法扣下它（`malignant_possible`）。`Ranking` 的结论是：要由 C 保持“没有它更好”，所比较的读法须扣下损失之前的事件；这一结论在可能性上不出现，因为排序来自部分失去的，而不是不计形成本身。
- **它不排序的。** 在更新之内汲取的形成不增加可能性：它的继续与没有它的继续容许同样的形成，互不扩展（`possible_tie`），而两种 `living` 读法都把它的在场排在上面（`readings_rank_presence`）；共享是实例（`sharing_presence`）。一般地，水平处处不低的路径从不被排在下面（`Web.not_added_of_le`），所以留下水平不低的休息与节制从不更差。
- **可能性优先。** 先比可能性、再比一种读法所记入的事件，这一比较在可能性读法下满足 C，且非自反、传递（`possibleFirst_order`）。不论第二步用哪种读法，它都把过度汲取者的不在场排在其在场之上（`possibleFirst_overdraw`）；第二步用任一种 `living` 读法，它都把在更新之内的在场排在不在场之上（`possibleFirst_presence`）。它也把不增加可能性的一次休息排在不间断的活动之下（`Rest.rest_ranked_below`）。

**作者反审。**
1. **审计的完整性来自阅读。** Lean 不能对“仓库中的每处用法”量化。这里的完整性是：`grep` 出 G0 的全部出现，逐处分类（上表）。解除引理对任意清单与任意框架成立，所以每处以 G0 为假设的定理都可实例化。只为桥接已导入的三项写出了 Lean；`ProtectionPriorityRival`、`OpenFutureRevision` 与 `RenewingFormation` 不在桥接的导入之内，以同一实例化成立，没有写成 Lean。
2. **从意义读出正面相关是定义。** 它不是推出的：AI 把 G0 的正面相关读作已实现的活的内容的意义。根据是上面被迫的一处：以裸意义读，A 就给任何新内容以理由。这一定义使正面相关恰是满足 G0 的最小者，所以它不给 G0 增加任何内容；外围已有的模型 `g0Relevant` 就是它。
3. **可能性读法计能形成的，不计形成了的。** 一个形成活着而不增加可能性，与它能活而没有活，不分高下（`possible_tie`）。推广开去，一个无物活动而水平处处足够的继续，与一个形成在更新之内兴旺的继续，也不分高下。这是 Ren 的三相（生成、中性、退化）的一种读法：不损也不增加的是中性。如果 Ren 认为“its continuation into the future has significance”说的是实际的延续，实际活着比能活更好，可能性读法就漏掉了它。
4. **可能性优先有代价。** 它是另加的前提；公理只给出可能性读法。它取回“在场优于不在场”，同时把不增加可能性的休息排在活动之下（`Rest.rest_ranked_below`），那正是 `RenewingFormation` 对按事件的 C 记下的表示限度（`event_comparison_ranks_rest_below`）。所以只要把实际的延续计在可能性之外，一次不增加可能性的停顿就算作失去；这一代价随读法而来，不是表示的偶然。
5. **整段读法扣下的是什么。** `malignant_possible` 表明，整段读法保持“没有恶性增殖更好”，靠的是扣下恶性增殖者在损失之前的事件，即把它当作从未活过。在公理之下，一切的延续都有意义，恶性增殖者的也有。可能性读法把它的不在场排得更高，而不否认它的事件有意义：排序来自它的部分失去的，即维持者的延续，而不是不计它是什么。判断落在部分的交换上，不落在谁该存在上（AI 的读法，待 Ren）。
6. **`possible_extends_iff` 的范围。** 它只对同一定律的两个继续成立，那里两者有同样的所需与需要量。不同定律的继续（如节制族的停止与过度汲取）各按自己的所需容许；`possible_restraint` 不依赖两者相同，但与保留、增加的等同需要共同的网。
7. **`Rest` 在定律族之外。** 定律族中焦点形成被支持时总是活跃的，所以休息不能在其中表示；`Rest` 与 `ThirdParty` 一样是另设的展开。

**检查。**
- 模块在暂存区编译，逐条审计全部 76 项声明（含 Lean 生成的匹配函数），公理报告全部为空；全部是项证明。桥接新增的五项在暂存区编译，公理报告为空。
- 合并检查器回执 20261010T214440.263682Z：`Becoming.Relevance` 的 30 项定理与桥接新增的 5 项定理全部空依赖。外围回执 20261010T222130.672025Z。
- P42 与 P43 先在分支上检查（回执 20261010T174514.186722Z，外围回执 20261010T175236.872210Z）；与 R3、R4 合并后，P42–P44 一次落地，上面的回执覆盖合并后的整个包。

**Ren 的选择。**
1. 是否以公理替换 G0 为所采用的公理。审计干净：替换后 G0 是定理，前提卡上的种子、S0、N_rel、N_std（与水平路径上的 C）由公理给出；A、L 与 J1–J4 仍是前提，A 读在活的内容上。
2. 正面相关是否读作已实现的活的内容的意义，作为“doesn't have to be positive”的读法。
3. 比较继续用哪一种：可能性读法，由公理自身给出，不增加可能性的在场与不在场不分高下，休息不更差；`living` 的一种读法加 C，整段读法扣下过度汲取者的事件，逐步读法不排序过度汲取与其不在场；或可能性优先，在场优于不在场，休息排在活动之下。

**边界。** 不推出伦理结论之外的东西；不替 Ren 选择读法；替换须经 Ren 接受。本节尚未经独立审查。

## 65. 所立者与依存的计数（P47）

2026-10-11。按 Ren“let's aim for the strongest claim without axiom, as the first part, and add one axiom, as the following part, the no axiom part is most important and elegant”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-zero-axiom-part-and-names.md)）与“aim a complete theory of becoming, and finish related work”继续。P38 到 P46 给出的是活动的计数在前提之下的规律；whole-law-of-counting 与 counting-under-enclosure 的下一步都留着同一项：水平与依存的计数在前提之下（§63 的边界）。`Becoming.Population` 把同一个计数表读于三种列出：活动的普查、所立者的普查（`Web.StandingCensus`）与依存的普查（`Web.DependenceCensus`），不加前提时三者的规律都是计数表（`counting_laws`）。本节给出前提给后两者加了什么。这样，第一部分不加公理的计数规律在三个读法上都已陈述；所选前提都起约束时的规律仍只对活动陈述。

```text
Result(s): 新成果记录 counting-standing-and-dependence；修订 counting-under-enclosure 与 whole-law-of-counting（局限与下一步改指新记录）
Delta: 新核心模块 Becoming.Standing（导入 Becoming.Counting）：ceasings_congr、comings_congr、pairs、mem_pairs、
       Web.StandingCensus.length_le_stock；World.StandsObey、World.Embodied.decided、World.Embodied.standsObey_iff、
       World.Embodied.tally_of_stands；OpenQueue.sourced 与 World.sourcedQueue（_holds、_meets、_standing、_counts）；
       World.standing_counting_under、World.standing_iff_counting、World.standing_binds_iff；
       World.enclosure_bounds_standing、World.enclosed_binds_standing、World.BoundsStanding；
       EnclosedQueue.waiting、EnclosedQueue.waiting_front 与 World.waitingQueue（_holds、_meets、_standing、_counts）；
       World.embodiedQueue_stands、World.enclosed_standing_counting_under、World.enclosed_standing_bound_iff；
       World.activeRing（_holds、_meets、_counts）；World.finite_standing_counting_under、World.finite_standing_binds_iff、
       World.finite_standing_bound_iff；World.DependsObey、Queue.depending、World.dependingQueue（_premised、_census、_counts）、
       World.still_premised、World.dependence_counting、World.enclosed_dependence_counting；Ring.first、Ring.depending、
       World.dependingRing（_premised、_counts）、World.finite_dependence_counting。Becoming.Counting 只改结尾一段说明；
       已有声明不变
Supplied premises / correspondence: 不变；读于水平时水平为正可判定（自然数的比较），读于依存时要求可判定
Evidence: 合并检查器回执 20261011T003217.297180Z（2060 项定理、3126 项声明审计，全部源声明公理报告为空；Standing 38；核心闭包 41 个模块，
          包 39 个），外围回执 20261011T003646.599930Z；新模块先在暂存树中从前导编译，无警告，逐条 #print axioms 全部为空
Boundary: 所选前提都起约束时所立者与依存的计数规律、三种计数之间的联合规律没有陈述；尚无独立审查
Integration: 章节第 4 条、第一部分的总陈述、§8 的开放项与现状表、§9 的脊柱表与总数、§10 的术语表；计划 P47；
             模块说明、Counting 的结尾、根模块、包 README、检查器的核心模块列表与范围
```

**所立者与活动。** 关系项都体现时，立着就是活跃，所立者的普查就是活动的普查，两者的计数满足同样的性质（`World.Embodied.standsObey_iff`）。不选体现时，二者可以分开：由源供给的队列是 P38 的被驱动的队列，驱动者是地关系项 0，始终活跃而不立任何东西，与每个地关系项各交换一个单位；成员在队中时立着而从不活跃（`World.sourcedQueue`）。它平衡；只有源给予与取用，而源活跃；任何有限的家族之外都有一个地关系项与源交换，所以没有家族跨过任何一步封闭，耗散成立；活动需要支持与有界传递空成立（没有什么依存于什么），活动的普查是 [0]（`World.sourcedQueue_holds`）。所以它满足除体现外的全部前提，不论计数；它的所立者的普查计到队列所计的（`World.sourcedQueue_counts`）。于是在每个选择之下，所立者的计数规律就是活动的（`World.standing_counting_under`、`World.standing_iff_counting`）：计数表，以及恰在选择约束计数时，没有关系项立着的一步上没有关系项开始立着（`World.standing_binds_iff`）。

**被围住时，平衡与耗散单独约束所立者。** 流所取用与给予的是水平。在平衡与耗散之下，跨过围住所立者的步，所立者的总水平不升，任何水平变化都使它下降（`Flow.standing_never_rises`、`Flow.change_lowers`，P25）。立着的关系项至少立着一，所以所立者的数目不多于其总水平（`Web.StandingCensus.length_le_stock`）；从第 T 步起每步被围住时，所立者的任何普查自 T 起的变化，即此后任一步立着的数目连同自 T 以来有关系项开始立着或不再立着的步，不多于第 T 步所立者的总水平（`World.enclosure_bounds_standing`）。被围住而没有关系项立着的一步上，封闭家族的总水平是零，一个关系项开始立着会使它下降，所以没有关系项开始立着（`World.enclosed_binds_standing`）。两者都不需要关于活动的前提：不需要体现，不需要只有活跃者给予或取用，也不需要活动的普查。对活动，同样的界要经体现才成立（`World.enclosure_bounds_change`，P35），因为活动只在体现时随所立者而变。

所以从某步起每步被围住时，在每个选择之下，所立者的计数规律是：计数表；选择约束计数时，没有关系项立着的一步上没有关系项开始立着；选择选中平衡与耗散（`World.BoundsStanding`）时，从某步 T 起变化在一个界之内，此后没有关系项立着的一步上没有关系项开始立着（`World.enclosed_standing_counting_under`）。这是被围住时活动的规律（`World.enclosed_counting_under`，P38b）在其第二个条件中去掉体现。变化界恰在选中平衡与耗散时是所立者的规律（`World.enclosed_standing_bound_iff`），对活动则恰在选中平衡、体现与耗散时（`World.enclosed_change_bound_iff`）。

见证要在选中平衡而不选体现时满足只有活跃者给予与取用。等待的队列是 P38 的闭合的队列，只改活动：下一个加入者在立着之前就活跃，所以队首每步都活跃，队空时也是（`EnclosedQueue.waiting_front`）；给予与取用的只是队首，它活跃，所以只有活跃者给予与取用（`World.waitingQueue_holds`）。在第 0 步闭合时它每步被围住，满足除耗散与体现外的全部前提；在第 T 步闭合、从 T 起在变化界之内且此后没有成员加入空队时，耗散也成立（`World.closingQueue_dissipative`），满足除体现外的全部前提（`World.waitingQueue_meets`）。不选平衡时，体现的队列（P34）满足其余全部前提，什么都不流动，每步被围住。

**有限世界中。** 有限世界的每一步都被围住，所以平衡与耗散在那里单独约束所立者。在每个选择之下，有限世界中所立者的计数规律是：每步至多有某数立着的计数表；选择约束计数或选中平衡与耗散时，没有关系项立着的一步上没有关系项开始立着；选中平衡与耗散时，从第 0 步起的变化界（`World.finite_standing_counting_under`、`World.finite_standing_binds_iff`、`World.finite_standing_bound_iff`）。与活动相比（`World.finite_counting_under`），没有关系项立着的一步上没有关系项开始立着在平衡、并在耗散或体现连同只有活跃者给予之下成立，活动的对应一条则在平衡与体现、并在耗散或只有活跃者给予之下成立：去掉的仍只是平衡与耗散起约束之处的体现。新的有限见证是始终活跃的环：P38b 的平衡的环，每个位置始终活跃、被占时立着，满足除耗散与体现外的全部前提（`World.activeRing_holds`）；选中耗散时用有限的队列（P35），不选平衡时用体现的环。

**依存。** 要求可判定时，前提不给依存的计数加任何规律：在每个选择之下，在每个世界中、从某步起每步被围住时，以及每步至多有某数依存时在有限世界中，对计数的一个性质在依存的每个普查中成立，恰当它对每个计数表成立（`World.dependence_counting`、`World.enclosed_dependence_counting`、`World.finite_dependence_counting`）。有限世界中依存是关系项的对，至多是其数目的平方（`pairs`、`mem_pairs`）。见证是依存的队列与环：一个条件（关系项 0，或环的第一个位置）立在一、始终活跃；队列的成员或环的位置在队中时依存于它，各需它的一个单位，每个依存都被满足；没有什么流动（`World.dependingQueue`、`World.dependingRing`）。没有什么流动、水平不变时，四个关于流的前提与平衡都成立，只剩三个关于依存网的前提：活动需要支持（每个依存都被满足）、体现（只有条件活跃，也只有它立着）与普查（[0]）（`World.still_premised`）。所以这些世界满足全部八个前提，计到每个计数表。前提只在依存与活动、水平与世系一起时约束它：活动需要支持只要求活跃者所依存的支持它，有界传递只要求后代开始立着时所依存的，其亲代也依存，所需在一个界之内。

**作者反审。**

*反驳 1：体现之下所立者就是活跃者，这一半是否平凡？* 是恒等，不是新的规律，所以证明直接转用活动的定理。内容在另外两处：不选体现时，一个满足其余全部前提的世界实现所立者的每个计数表，所以没有关系项立着的一步上没有关系项开始立着在那里不是规律；被围住时，所立者的界不需要体现。

*反驳 2：源活跃而不立着，成员立着而不活跃，是否违背关系的读法？* 它只用于不选体现的选择，那里所立与活跃本来可以分开，体现正是使二者一致的前提（与 §63 反驳 3 相同）。选中体现时，所立者的规律就是活动的，不用这个见证。

*反驳 3：被围住为所立者定下界，是否已由 P25 给出？* P25 给出所立者的总水平跨过被围住的步只降不升，任何水平变化都使它下降（continued-change-needs-openness），并由此推出交换与生起的停止。这里新加的是计数的形式与它的精确范围：所立者的普查自 T 起的变化界（`World.enclosure_bounds_standing`），以及它在每个选择之下恰在选中平衡与耗散时是规律（`World.enclosed_standing_bound_iff`）；缺平衡或缺耗散时，体现的队列与在第 0 步闭合的等待的队列实现每个计数表。所以复用 P25 的结果，不重做。

*反驳 4：依存的见证是否退化？* 初稿的见证以零所需依存，什么都不立着、不活跃；一个依存什么也不需要，读者可以说它不算依存。改为条件立在一、始终活跃，每个依存需要一个单位且被满足后，定理不变，见证不再依赖零所需，所以只计所需为正的依存或只计被满足的依存，规律也相同。仍然没有什么流动：关于流的前提在那里空成立。这正是结论的内容：前提不给依存本身的计数加规律，它们约束的是依存与活动、水平与世系的联合。

*反驳 5：为何不陈述所选前提都起约束时的规律？* 对活动，起约束加上的是条件的实例（P38c、P45、P46）。对所立者与依存，要逐个选择构造使所选前提都起约束、又实现所立者或依存的每个计数表的见证。按 Ren 2026-10-11 的转向（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)），选择表不再扩展：这些规律改为去掉前提、对每个世界重述，局部条件写在规律之内（[零前提计划](../history/root-foundation/ZERO-PREMISE-PLAN.md)）。模块说明与记录的局限写明它们没有陈述。

*反驳 6：三种计数各自的规律是否就是整体的计数规律？* 不是。三种计数之间有联合规律，例如在平衡与只有活跃者给予之下，没有关系项活跃的一步上没有关系项开始立着；这里没有陈述，记录的局限写明。

**读法（AI，待 Ren）。** 被围住的展开所耗去的是立着的东西：平衡与耗散约束的是水平，所以所立者先受约束，活动只在体现时随之受约束。依存是关系的形状，前提不单独约束它的形成与消解，只在它与活动、水平与世系相遇处约束。

**边界。** 离散步，每步有限的所立者与依存；所选前提都起约束时所立者与依存的计数规律、三种计数之间的联合规律没有陈述，按 Ren 的转向不再作为选择表扩展；更强的起约束读法仍开放（由 Ren 选择）；没有伦理谓词，不评价立起、不再立着、形成或消解；名称（StandsObey、DependsObey、BoundsStanding、sourcedQueue、waitingQueue、activeRing、dependingQueue、dependingRing、pairs）是 AI 按 Ren 的命名准则所选，形式而描述动力学；尚无独立审查。

## 66. 一步的规律，条件在规律之内（P48）

2026-10-11。按 Ren 的转向：“stop extending the premise-selection tables. New goal: remove premises and derive the most general versions, zero premises first”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)）；又按 Ren 同日“一起先完成一个统一的理论”的指示（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-one-unified-theory-together.md)）。本节把 Ren 先点名的四条规律对每个世界重述：静止与持续变化需要开放、不再存在需要生起、封闭约束变化、生起需要活跃的给予者。每条规律里，证明用到的条件写在规律之内，是关于该世界在证明用到它的那些步与关系项上的事实。所作的一步是局部化，不推出任何前提：表示之内各前提仍是偶然的、彼此独立的（`World.contingent`、`World.independent`）。新核心模块 `Becoming.Locality` 导入 `Becoming.Dissipation`，`Becoming.Roles` 导入它。撤回的联合规律原编号 P48，它的三个引理在这里被改写为局部规律。

```text
Result(s): 新成果记录 laws-of-one-step；修订 continued-change-needs-openness、counting-under-enclosure、
           whole-law-of-counting、counting-standing-and-dependence、ceasing-needs-arising、life-as-condition-of-life
           （证明改经新的规律，局限与下一步改指新记录）
Delta: 新核心模块 Becoming.Locality（导入 Becoming.Dissipation）：
       pos_iff_lt、lt_iff_pos、exists_lt_of_total_lt、rises_or_le、unmet_or_lower、unmet_from、recurs_iff_unmet；
       Web.StandingCensus、Web.StandingCensus.stock_eq（自 Openness 移来）、Web.StandingCensus.length_le_stock（自 Standing 移来）；
       Flow.BalancesOn、Flow.Balances.on、Flow.balances_iff_on、Flow.BalancesOn.over；
       Flow.BalancesOn.comesToStand_iff、ceasesToStand_iff、rise_given、fall_taken、rises_iff_gives、
       Flow.DissipatesOn.still_untaken；Flow.BalancesOn.runs_down、taking_lowers、fall_lowers、rise_lowers、
       comes_from_standing；Flow.RunsDownOn、Flow.RunsDown、Flow.RunsDownClosed、Flow.RunsDownOn.changes_iff、
       exchanges_iff、stock_eq、Flow.RunsDown.standing_le、changes_iff、Flow.RunsDownClosed.exchanges_iff、runsDown、
       Flow.rise_of_standing、Flow.change_recurs_iff、Flow.exchange_recurs_iff；Flow.RunsDown.rise_zero、fall_pos_iff、
       lowers_mark、Flow.RunsDownOn.takers_le_fall、Flow.standing_bounds_change、Flow.runsDown_bounds_change、
       Flow.runsDown_change_bound；Flow.BalancesOn.arises_iff、arises_given；
       Covers、ListsAt、NoneComes、accumulates_or、stays_failing_within、came_between、Covers.within、
       cohort_closes_iff、ceasing_needs_arising、Covers.coming_from_of_ceasing、coming_of_ceasing_covered、Listed.covered、
       not_not_all、ceases_once、Covers.ceasing_steps_within、ceasing_steps_found、Covers.ceasing_not_recurring、
       Covers.not_not_coming_from（不再存在需要生起一节由“0 axiom completeness”会话起草并验证，此处整合）。
       推论改证（陈述不变）：Web.Embodied.arises_given（Roles）；Flow.fall_lowers_on、standing_runs_down、
       standing_never_rises、change_lowers、stills、exchange_lowers、exchanges_finitely、World.arising_of_ceasing、
       Web.StandingCensus.coming_of_ceasing，新增 Flow.AroundStanding.runsDownClosed（Openness）；
       World.enclosure_bounds_change、taking_binds_counting、enclosed_binds_counting（Counting）；
       World.enclosure_bounds_standing、enclosed_binds_standing（Standing）
Supplied premises / correspondence: 无；每条规律的条件写在规律之内
Evidence: 合并检查器回执 20261011T071749.484228Z（2171 项定理、3257 项声明审计，全部源声明公理报告为空；Locality 57；核心闭包 43 个模块，
          包 41 个），外围回执 20261011T071753.574921Z；先在暂存树中从前导编译，无警告，逐条 #print axioms 全部为空
Boundary: 超出整单位的量、连续时间未在此检验；规律 3 与规律 1 的复现用所立者的普查；尚无独立审查
Integration: 章节第 4 条、第一部分的总陈述、§8 的开放项与现状表、§9 的脊柱表与总数、§10 的术语表；计划 P48；零前提计划；
             模块说明、根模块、包 README、检查器的核心模块列表与范围
```

**一步的平衡。** 流跨过一步在一个家族上平衡：每个成员步后的水平连同被取的，等于步前的水平连同被给的（`Flow.BalancesOn`）。平衡就是每一步、每个家族上的平衡（`Flow.balances_iff_on`）；平衡的流的每个证明只在它用到的步与条件上需要它。

**生起需要活跃的给予者。** 一个条件跨过一步平衡时，它开始立着，恰当它此前立在零，且被给的多于被取的（`Flow.BalancesOn.comesToStand_iff`）。它不再立着，恰当它此前立着，且被取的等于它所有的连同被给的（`Flow.BalancesOn.ceasesToStand_iff`）。跨过没有从家族取用的一步，平衡的家族中有成员上升，恰当有参与者给予它（`Flow.BalancesOn.rises_iff_gives`）；家族上的耗散排除这一点：给予须以从家族取用为条件（`Flow.DissipatesOn.still_untaken`）。一个关系项在一步的两端都体现、只有活跃者给予它时，它生起恰当它开始立着，所以由一个活跃的、不是它自己的给予者给予（`Flow.BalancesOn.arises_iff`、`Flow.BalancesOn.arises_given`）。跨过一个包含它的家族被平衡与耗散的一步，不会从无中开始立着（`Flow.BalancesOn.comes_from_standing`）。`Web.Embodied.arises_given`、`World.taking_binds_counting`、`World.enclosed_binds_counting` 与 P47 的 `World.enclosed_binds_standing` 改为它的推论。撤回的联合规律的三个引理就是两个当且仅当与 `still_untaken`。

**静止。** 家族跨过一步时满足三点：不重复地包含步前或步后立着的每个条件，流在它上面平衡，并在它上面耗散。这时称家族跨过该步下降（`Flow.RunsDownOn`），条件中没有封闭。跨过这样的一步，有条件的水平改变，恰当家族的总水平下降（`Flow.RunsDownOn.changes_iff`）；家族也封闭时，有参与者取用或给予，也恰在此时（`Flow.RunsDownOn.exchanges_iff`）。持续变化需要开放，取确切形式：所立者有普查时，水平在任意晚的步改变，恰当它在任意晚的、所立者不下降的步上改变（`Flow.change_recurs_iff`）；交换连同封闭也一样（`Flow.exchange_recurs_iff`）。一般形式是 `recurs_iff_unmet`，有三个条件：在条件之下事件使一个量下降；在条件之下这个量不上升；它的每次上升都是事件。这时事件复现，恰当它在不满足条件的步上复现。找那一步的搜索有界，不用判定。`Flow.stills`、`Flow.exchanges_finitely`、`standing_never_rises`、`change_lowers`、`exchange_lowers`、`standing_runs_down` 与 `fall_lowers_on` 改为它的推论，`Becoming.Openness` 的静止定理随之。

**下降约束变化。** 任何一段步，不加条件：末步立着的，连同总水平下降的步，不多于首步的总水平连同它在这一段上升的全部（`Flow.standing_bounds_change`）。总水平只在所立者不下降的步上上升，所以在下降的各步上，末步立着的连同有水平改变的步不多于首步的总水平；这不需要判定水平是否改变（`Flow.runsDown_bounds_change`）。对任何计数的变化界见 `Flow.runsDown_change_bound`；`World.enclosure_bounds_change`（P46）与 `World.enclosure_bounds_standing`（P47）是它的推论。Ren 把这条称为“封闭约束变化”；约束变化的是下降，即在包含所立者的家族上平衡与耗散，封闭是前提给出下降的方式。

**不再存在需要生起。** 本节一部分由“0 axiom completeness”会话起草并验证，此处整合。一个列表覆盖一步上成立者，指那里每个成立的成员都在列表上（`Covers`）。对任何有限列表，段末它成立的连同这一段上的不再成立，等于段首它成立的，恰当这一段上它没有成员开始成立（`cohort_closes_iff`）。一个列表恰好列出第 N 步成立者（`ListsAt`），N 之后没有开始成立时，段末成立的连同自 N 以来不再成立的，恰好等于第 N 步成立的数目（`ceasing_needs_arising`）。只要在任意晚的步有列表覆盖成立者，不再成立的复现就需要开始成立的复现（`coming_of_ceasing_covered`）；普查覆盖每一步（`Listed.covered`），普查定律是它的推论，`World.arising_of_ceasing` 与 `Web.StandingCensus.coming_of_ceasing` 改经它证明。不用判定时：一个列表覆盖第 N 步，N 之后没有开始成立，则不再成立不复现（`Covers.ceasing_steps_within`、`Covers.ceasing_not_recurring`、`Covers.not_not_coming_from`）。

**表示的承诺（Ren 的第 4 项）。** 以下由陈述与证明读出：
- **可判定。** 规律 1、3、4 不判定世界的任何谓词，证明只判定数的大小；规律 2 的确切计数需要标记，它的“不复现”形式不需要。
- **整单位。** 规律 1 与 4 的一步当且仅当只用加法与次序。规律 1 的复现与规律 3 的界用最小差异：耗散中的 sign 项，每个取用的形成至少失去一个单位（Ren 的选项 A）。超出整单位的量下各条是否成立，这里尚未检验；静止由分辨率一线覆盖（R4：把细分算作给予时，每一分辨率下都静止）。
- **时间。** 较粗的步由局部化的 `Sampling` 检验（落地队列第 7 项，来自“0 axiom completeness”会话）：每个关系项只列出一次时，家族上的平衡与耗散跨过一个粗步内的各细步合成；家族下降只需要在粗步两端包含所立者；只有活跃者给予与取用仍依步而定。
- **有限。** 所立者的普查（每步有限多立着）只被规律 1 的复现与规律 3 用到，作用只是使每步的总水平是一个数；一步的规律不需要普查。

**作者反审。**

*反驳 1：把前提搬进规律之内，是否只是改写？* 不只是。第一，得到原来没有的确切形式：一步上水平改变当且仅当总水平下降，复现当且仅当在不满足条件的步上复现，而且后者用有界搜索给出那一步，不用判定。第二，条件比把前提限于那些步更弱：下降不需要封闭，耗散只在那一个家族上；规律 2 只需要一步的列表，或任意晚的步上的覆盖列表，不需要普查；规律 3 对所立者不需要体现，对活动只需要生起与不再活跃者的体现。第三，选择结果改经这些规律证明，所以新模块是来源，不是包装。

*反驳 2：每条都是“Y 当且仅当 Z”吗？* 规律 1、4 与规律 2 的群体定律是当且仅当，复现定律也是。规律 3 是不等式：它的确切形式是 `over_stretch` 的恒等式，连同一步的当且仅当。界按界陈述，并写出它所来自的恒等式。

*反驳 3：所立者的普查是否偷渡了有限？* 它只用来使每步的总水平是一个数。下降的步上家族本身给出这个数，但在不下降的步上，立着的可以无穷多。所以复现定律留着普查，作为尾段各步上的局部条件（a 类），没有作为全局前提。要去掉它，须在无穷多立着时给出总水平，那就是改变量的表示（b 类），属于 Ren 的决定。

*反驳 4：为何不沿用“封闭约束变化”的名称？* 证明表明封闭不是所需的条件，所需的是下降。名称 `runsDown_bounds_change` 描述证明了的内容，Ren 的说法仍作为推论的描述保留；名称由 Ren 定。

*反驳 5：规律 2 来自另一会话，是否经过同样的检查？* 收到的文件逐字保存，sha256 记录在整合的工作区。它在同一暂存树中与其余部分一起从前导编译，逐条公理报告为空，并作为一节并入 `Becoming.Locality`。为了不与 `World.ceasing_not_recurring` 混淆，四个名称改为以 `Covers.` 开头；与普查定律陈述相同的 `Listed.coming_of_ceasing_covered` 没有并入，相关推论直接改证。

*反驳 6：这是否推出了前提？* 没有。规律对每个世界成立，不论前提成立与否；前提对每一步成立时，局部条件在每一步成立，选择结果因此是推论。前提本身仍是偶然的。

**读法（AI，待 Ren）。** 前提约束的第一部分规律，是每一步及其关系项的规律；前提是使它们的条件处处成立的一种方式。

**边界。** 离散步；超出整单位的量与连续时间未在此检验，较粗的步待 `Sampling` 落地；复现定律与规律 3 用所立者的普查；规律 3 的界用最小差异（选项 A）；没有伦理谓词；名称（BalancesOn、RunsDownOn、RunsDown、RunsDownClosed、Covers、ListsAt、NoneComes 等）是 AI 按 Ren 的命名准则所选；尚无独立审查。

## 67. 折叠 G0（P51）

2026-10-11。Ren（[原话](../../../../sources/15-codex-theory-conversations/2026-10-11-fold-g0.md)）：

它回答 P42–P44 落地后的报告。报告列出 §64 的三项选择（是否以公理替换 G0；正面相关是否读作已实现的活的内容的意义；比较继续用哪一种），并提出下一项：审计第二部分哪些结果不用公理成立，以移入第一部分。AI 的读法（待 Ren）：
- 条件成立：第一部分不需要采用 G0，第二部分中它是那一条公理的定理；这以从意义读出的正面相关为准（§64 的读法）。
- 所以 G0 不再是所采用的公理：它的定义与已检查的刻画都保留，只改地位，在第一部分是条件，在第二部分是定理。第一项选择以此回答；第二项是折叠所用的读法，仍开放；第三项仍开放。
- “at least for part i”：第一部分现在就做；同一条件在第二部分也成立，所以章节不再在任何地方称 G0 为所采用的公理。“at least”也读作为报告所提的更大一步留出余地：第二部分中不用公理成立的结果移入第一部分。

本节是计划 P51，由本会话完成。没有新的 Lean，没有新的成果记录；改的是 G0 的地位与说到它的文字。

```text
Result(s): 复用 metaethical-core-characterization（G0、Valuation.Significant、Valuation.significant_iff、极小性反模型）、
           held-lives-g0-is-centering（Valuation.significant_iff_held）、one-axiom-yields-g0
           （Valuation.premises_of_unrestricted、Web.significance_undetermined、g0_of_unrestricted、relevance_least、
           unrestricted_iff_g0、Web.unrestricted_iff_paths_g0）；不新增，不扩展
Delta: G0 的地位：从所采用的公理改为第一部分中的条件（不用公理刻画，动力学不决定）与第二部分中公理的定理；
       章节的前提卡、§5、第一部分的总陈述、第 10 条、第二部分各处与 §8 照此改写；七项记录的文字照此更正
Supplied premises / correspondence: 无新前提；折叠以从意义读出的正面相关为准（§64 的读法，待 Ren）；
       “fold”与“at least”的读法是 AI 的，待 Ren
Evidence: 上列定理在核心回执 20261010T214440.263682Z 中，公理报告为空；本节没有新的检查
Boundary: 不推出 G0 成立；不改任何定义或定理；正面相关的读法与比较的方式仍属 Ren；
          核心七个模块的说明随后在 P47 的核心检查中一并更改（99e78ddd，回执 20261011T003217.297180Z）
Integration: 第一部分得到 G0 的条件陈述（章节 §5 与总陈述三）；第二部分以 G0 或其各部分为假设的定理在公理之下成立
             （§53、§64）；回答 §64 的第一项选择
```

**改了什么。**
- **前提卡。** G0 一行从“Ren 授权的公理，采用”改为“已折叠，不是公理”：第一部分把它作为条件陈述，由下面三条精确刻画（`significant_iff`、`significant_iff_held`），动力学不决定它（`Web.significance_undetermined`）；第二部分中它是公理的定理，各处用法由从意义读出的正面相关解除。公理一行去掉“Ren 接受之前 G0 仍是所采用的公理”。
- **第一部分。** §5 新增“G0 折叠：一个条件，不是公理”：G0 恰是什么（连通时种子加两项中立，被持有时处处 S0 加立场中立，极小性），它与那一条公理（公理恰是对任何东西的 G0），动力学不决定它；断言它成立属于第二部分。总陈述三“意义”一条照此改写；理论的完整陈述中第 10 条的地位标为“G0 不是公理”，地位词表中的“公理”改指第二部分的一条公理。
- **第二部分。** 开头、§6.1、§6.7、§6.8、§6.9、§6.11、§6.12 中“G0 仍是所采用的公理”与“替换须经 Ren 接受”改为折叠后的陈述；§6.1–§6.7 与 §7 的定理以 G0 或其各部分为假设，在公理之下这些假设成立，A、C、L 与 J1–J4 仍是公开的前提。
- **§8。** 状态表与 Ren 的选择去掉“是否以公理替代 G0”“重述是否替代 G0”，记下折叠；G0 的根据就是那一条公理的根据。术语表新增 G0。
- **一句话与两个目标。** 在它之下 G0 是定理，不再是公理；伦理方向的目标经 G0 及公开的实践前提完成，G0 现在是第二部分那一条公理的定理。
- **范围与指令。** 生成之论的范围记录（前提一句）与指令登记各加一段；登记中先前“G0 仍是所采用的公理”的两段由新的一段取代，原文保留。

**作者反审。**
1. **折叠依赖一种读法。** 第二部分中 G0 是定理，是在正面相关读作已实现的活的内容的意义时（`g0_of_unrestricted`、`relevance_least`）。若 Ren 另读正面相关，例如读作继续创造更多意义（强式），G0 只在那一读法由意义推出之处是定理；那时第二部分要重新审视。第一部分的折叠不依赖这一读法：刻画与“动力学不决定”对任意意义成立。
2. **没有新的 Lean。** 每条引用都是已在核心回执中的定理：公理之下 G0 成立且从意义读出的正面相关是满足它的最小者（`g0_of_unrestricted`、`relevance_least`），公理恰是对任何东西的 G0（`unrestricted_iff_g0`）。更精确的折叠形式——以从意义读出的正面相关，G0 恰是公理限于已实现的活的内容——没有写成 Lean，所以章节没有声称它。
3. **G0 的名字保留。** 折叠不删 G0：它仍是定义、刻画与各处定理的假设；改的只是它不再被采用为真。G0/J 的已完成成果保持其条件范围，G0 现在由第二部分的公理给出，而不是另一条公理。
4. **开篇未改。** Ren 的开篇（`theories/becoming/OPENING.md`，README 由它生成）的注释仍写“G0 remains the adopted axiom until this one takes its place”。按其注释，开篇只随 Ren 改；替换的文字交给 Ren。
5. **Lean 说明。** 落地时核心七个模块的说明仍写 G0 仍是所采用的公理；改说明须重跑核心检查，所以补丁交给下一次核心检查。整合者在 P47 的核心检查中一并更改（99e78ddd，回执 20261011T003217.297180Z），七个模块都通过检查，此后模块说明与章节一致。

**边界。** 不推出 G0 成立，不改变任何定理；本节尚未经独立审查。

## 68. 每个变化之律保留、失去与回返的：零前提（R6）

2026-10-11。Ren 答“0”指什么时说：

随后：

（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-difference-in-becoming.md)）。熵的会话在流与网的层面研究无损的交换（`Becoming.Entropy`，以第一定律为前提）。本节在其下一层：对任意构型上的任意变化之律，不加任何前提，问什么被保留、什么失去、什么回返。按[工作板](../../../BECOMING-WORKBOARD.md)认领为 R6。

```text
Result(s): 新增 recurrence-without-premise
Delta: 新核心模块 Becoming.Recurrence（L2，只导入 Becoming.Frame）：
       revisits_within、Revisits、revisits_of_held、revisits_from、unheld_of_new、unlisted_of_new；
       Marks、sumOver、le_sumOver、never_falls_over、Marks.mono、Marks.change_stops、not_marks；
       Law.orbit、Law.Lossless、Law.Merges、Law.Returns、Law.Reachable、Law.KeepsPossibilities；
       Law.lost_stays、Law.merged_stays、Law.Lossless.cancel、Law.lossless_of_returns、Law.Returns.reachable、
       Law.Returns.undo；Law.Lossless.returns、Law.returns_of_reachable、Law.lossless_iff_returns、
       Law.returns_iff_keeps、Law.lossless_of_reachable、Law.Merges.loses、Law.Lossless.unlisted、
       Law.Lossless.no_rise、Law.rise_not_lossless；Law.succ_open、Law.pred_open；Law.withHistory、
       Law.withHistory_lossless、Law.withHistory_new、Law.withHistory_never_returns、
       Law.withHistory_loses_beginning、Law.withHistory_unlisted、Law.present_orbit、Law.return_keeps_history、
       Law.present_forgets；Law.process、Law.run；Run.revisits_from、Run.change_stops、Reach.lost_stays
Supplied premises / correspondence: 无关于展开或变化之律的前提；“某个列表持有这些构型”不对任何展开假设，
       写进用到它的规律之内；不用可判定性；表示的承诺只有离散的步；无损与回返的等价只对确定的律（next : S → S）陈述
Evidence: 合并检查器回执 20261011T011019.444120Z（2115 项定理、3194 项声明审计，全部源声明公理报告为空；Recurrence 55 项定理、68 项声明），
          外围回执 20261011T011213.027508Z；新声明先在暂存树中以已提交的核心源从前导编译，逐条 #print axioms 全部为空
Boundary: 离散的步；“有限多构型”指某个列表持有它们；无损与回返的等价只对确定的律；遗忘的计数未陈述；尚无独立审查
Integration: 记录 recurrence-without-premise；计划 §10 R6；章节 §9 的脊柱表与第一部分；模块说明、根模块、包 README 与检查器的范围；工作板 R6
```

**机制。**

- **鸽巢，不判定任何东西。** 一个列表持有一个序列的前 l.length + 1 项时，其中两项相同（`revisits_within`）。证明对列表归纳：每一项在 a :: l 中，就是 a 或在 l 中，这是给定的成员关系的两种情形，不判定构型是否相等。若两项是 a，得到重访；若没有一项是 a，全在 l 中；若恰一项是 a，跳过它（`skipAt`）后其余在 l 中。于是有限多构型中的序列从每一步起都重访（`revisits_from`），任何过程的任何运行也是（`Run.revisits_from`）；从不重访的序列没有列表持有（`unheld_of_new`、`unlisted_of_new`）：不重访需要开放。
- **有标记的变化停止。** 构型的一个量沿序列从不下降、跨每次变化都上升（`Marks`）时，它在有限多构型上有界（`le_sumOver`），每次变化至少加一，所以变化不复现（`Marks.change_stops`）。变化复现的有限展开中，没有量标记它（`not_marks`）。
- **每个律保留与失去的。** 对确定的律 next：某一步不能到达的构型，以后任何一步都不能到达（`Law.lost_stays`）；任何过程中，沿一条可行路径失去的可达，在每个延续中都失去（`Reach.lost_stays`，即 endpoint-loss-and-return 的“损失沿延续保持”在脊柱上的形式）。被合并的两个构型以后任何一步都不分开（`Law.merged_stays`）。每个构型都回返时律不合并任何东西（`Law.lossless_of_returns`，用两个回返时间的乘积）；回返的构型在每一步都可得（`Law.Returns.reachable`）。撤销就是继续：s 回返时，同一律的继续把 next s 带回 s（`Law.Returns.undo`）。
- **有限多构型中，无损即回返。** 列表持有每个构型时，三者是一：律不合并任何东西（`Law.Lossless`）；每个构型都回返；每个构型在每一步都可得（`Law.lossless_iff_returns`、`Law.returns_iff_keeps`）。无损推出回返：s 的轨道重访，在 i < j 处相同，无损使前 i 步可以消去（`Law.Lossless.cancel`），所以 s 在 j − i 步后回返（`Law.Lossless.returns`）。在列表长度那么多步后可得推出回返：通向 s 的轨道在列表长度之内重访，重访点之后是一个环，s 在环上（`Law.returns_of_reachable`）。于是合并永久失去一个可能（`Law.Merges.loses`）；无损而有构型不回返，就没有列表持有每个构型（`Law.Lossless.unlisted`）。无损时，沿轨道从不下降的量在轨道上不变（`Law.Lossless.no_rise`）；所以沿轨道从不下降而在某步上升的量，即一个箭头，需要合并（`Law.rise_not_lossless`）。
- **开放的世界把三者分开。** 往上数（`Nat.succ`）不合并、不回返、一步后不能再有开端，并且每步上升：无损的箭头（`Law.succ_open`）。往下数（`Nat.pred`）把零与一合并，却每个数在每一步都可得（`Law.pred_open`）。“有限多构型”这一条件，两个方向都需要。
- **保留历史。** 让当下按律继续、并进入过去（`Law.withHistory`），每个律都不合并（`Law.withHistory_lossless`），从不重访（过去的长度每步加一，`Law.withHistory_new`），从不回返（`Law.withHistory_never_returns`）；开端在第一步之后就不能再有（`Law.withHistory_loses_beginning`）；没有列表持有一个展开所保留的历史（`Law.withHistory_unlisted`）。保留的历史的当下按律本身继续（`Law.present_orbit`）。当下回返时，它带着另一段历史回来（`Law.return_keeps_history`）。展开经过的构型有列表持有时，当下遗忘：从每一步起，两段不同的历史共有一个当下（`Law.present_forgets`）。

**反驳与回答（作者）。**

*反驳 1：这些是有限集合的教科书事实吗？* 数学是：鸽巢原理；有限集上的单射是双射，双射的每个点都回返。作为复用的数学记入，不作为数学上的新发现。增量是：在脊柱上以零前提、不用可判定性陈述；合并、可能的失去与回返在有限多构型中的等价，以及开放世界中把它们分开的两个见证；保留历史的构造与它需要开放；与静止规律的连接（反驳 2）。

*反驳 2：这里的“无损”是不合并，不是 Ren 所说交换中不损失量。二者怎样相关？* 第一定律之下，被围住的家族的构型落在有限多个之中（熵的会话的 `configurations_exact`）。变化是构型的函数时（熵的会话的 `Web.Determined`），本节的规律就作用于它：不合并恰是回返；有量的损失（耗散）时从不重访，有限多构型中从不重访的变化停止，停止就合并两个构型（熵的会话的 `Web.merges_of_settles`、`Flow.Balances.merges_of_dissipates`）。所以在有限的围住之内，量的损失推出区分的损失。这些作为实例定理，在两边都落地后给出。

*反驳 3：“保留历史需要开放”是否平凡？* 构造上，历史有无穷多，所以是的。内容在对照：同一展开，保留其历史时无损而有箭头（过去的长度），在有限多构型中的当下却遗忘。无损与箭头只在开放中共存（`Law.succ_open`、`Law.withHistory_unlisted`）；在有限多构型中，箭头需要合并（`Law.rise_not_lossless`）。

*反驳 4：变化停止的结论是否强于所证？* `Marks.change_stops` 证的是变化不复现（复现的否定），不是有一步之后不再变化；后者需要 LPO（`Becoming.Change` 的 `Web.lpo_of_ending`）。

*反驳 5：非确定的过程怎样？* 重访、变化停止与失去的可达保持失去，对每个过程陈述；无损与回返的等价只对确定的律。过程的形式（例如每个构型至多一个前驱）是下一步。

**读法（AI）。** Ren 的类比：原子层面每次交换守恒能量，熵仍增加，零前提。物理学的第二定律用到两样东西：守恒的动力学，与一个低熵的开端（过去假设）。这里两样都不假设。在有限多构型中，律不合并任何东西，恰是每个构型都回返，没有任何量上升；有上升（箭头），就有合并，就有一个可能永久失去。所以无损的交换存在，而且恰在两处：有限多构型中的回返（没有箭头），与保留其历史的生成（有箭头，需要开放）。物理学设为前提的低熵开端，在这里是保留的历史的开端：它在第一步之后就不能再有（`Law.withHistory_loses_beginning`），是推出的，不是假设的。熵读作有限的当下对其历史的遗忘：两段历史共有一个当下（`Law.present_forgets`）。Ren 的“karma passes, and that passing has to have a form of change which its reverse transformation will take another change”：撤销就是继续（`Law.Returns.undo`），当下回来而历史不回来（`Law.return_keeps_history`）。这些读法属于 AI；与物理学的对应只是读法，不是物理推导。

**边界。** 离散的步；“有限多构型”指某个列表持有它们；无损与回返的等价只对确定的律；遗忘的计数（需要判定构型相等）未陈述；尚无独立审查。

## 69. 第二部分的清点：什么不用公理（P52）

2026-10-11。Ren（[原话一](../../../../sources/15-codex-theory-conversations/2026-10-11-one-unified-theory-together.md)，[原话二](../../../../sources/15-codex-theory-conversations/2026-10-11-fold-g0.md)）：

G0 折叠之后（§67），第二部分所加的只有一条公理。本节问：第二部分的定理中，哪些用到它，用在哪里。零前提的清点排除了第二部分的模块，并早于 P42–P44 的落地；本节补上这一部分，并加上公理与评价条件这一维。按[工作板](../../../BECOMING-WORKBOARD.md)认领为 P52。逐条的表、方法与提议在[清点](../history/root-foundation/PART-II-INVENTORY.md)，可由[脚本](../history/root-foundation/PART-II-INVENTORY.py)从两张回执所绑定的源重现。

```text
Result(s): 不新增成果；复用章节第二部分以名称引用的全部声明（182 个：157 条定理、25 个定义），
           其中 one-axiom-yields-g0、significance-retained-within-margin、whole-first-and-bounded-centers、
           closure-verdict-meets-axiom、comparison-within-reach、axiom-decomposition、presupposition-scopes、
           metaethical-core-characterization、held-lives-g0-is-centering 等记录的定理
Delta: 清点：22 条以公理为假设，各只在所指名的点上用到它（从某立场、某形成在某步的意义），
       每条都是一条对任何意义成立的规律在这些点上的特例；135 条不用公理（85 条无前提，18 条只用第一部分的前提，
       12 条以评价条件、2 条以结构条件为假设，18 条刻画公理而不假设它）；18 条用前提者中 14 条不在零前提清点之内；
       提议（待 Ren）：不用公理的移入第一部分，第二部分只留公理的断言与其根据
Supplied premises / correspondence: 无新前提；分类读自签名，点读自证明；章节的结构属 Ren，第一部分的顺序与接口属整合者
Evidence: 核心回执 20261011T071749.484228Z 与外围回执 20261011T071753.574921Z 所绑定的源（Locality 落地之后；在 R6 之前的回执之下结果相同）；
          脚本 PART-II-INVENTORY.py；本节没有新的检查
Boundary: 只覆盖第二部分以名称引用的声明；§7 以记录名引用的外围结果不在内；不推出公理；不改任何定义或定理；尚无独立审查
Integration: 章节 §8 的 Ren 的选择加一项（第二部分的结构）；零前提清点 §1.3 可并入 14 行；整合者排序前提的局部化
```

**结论。**
- **22 条用到公理，135 条不用。** 点有三种：见证中的一个形成在一步（`Clearing.free_rider_loses` 只用到栖居者在第 2 步）；被比较的路径所接纳、或超出之处的形成；活的、已实现的主张（G0 的各个推出）。
- **每条都是对任何意义成立的规律的特例。** 比较的一般局部形式 P42 已经给出：意义覆盖部分在每步之前已到达者，就对这个部分作公理的比较（`Flow.Balances.comparison_within_reach`）。G0 的推出的局部形式就是 G0 本身：以从意义读出的正面相关，G0 恰是公理限于已实现的活的内容（§67）。
- **所以第二部分在第一部分之外只加一句断言。** 公理一经断言，就在所指名的点上满足意义的条件；对一个部分的比较，只需在部分所及之处满足。A、C、L 与 J1–J4 仍是实践规律的公开条件，不被断言。
- **前提的局部化仍要做。** 18 条只用第一部分前提的定理中，4 条已在零前提清点之内；其余 14 条中两条只用可判定（b2），`Flow.region_not_a_cut` 经由 `Flow.fed_from_beyond`，11 条在第二部分的模块里，最终经 `Balances.withheld`（与 `Balances.differs_before`）只在之前各步、在所比较的形成所需的条件上用到平衡。

**反驳与回答（作者）。**
1. *读签名是机械的，有什么内容？* 读签名本身是机械的。内容有三点：哪些点；P42 的 `comparison_within_reach` 已是比较的一般局部形式；由此得到的结构，即第二部分在第一部分之外只加一句断言。
2. *“只在点上用到”对任何全称假设都成立。* 是，所以这不是结论。结论是所需的点由陈述本身给出：被比较的路径、部分的所及、活的主张。因而每条都可以带着局部条件陈述。
3. *移动是否抹去公理的作用？* 不。公理仍是唯一不被推出的断言：动力学不决定意义（`Web.significance_undetermined`）。移动的只是不用它的规律；移动之后，它的作用更清楚：在所指名的点上满足意义的条件。
4. *关键词分类会漏吗？* 第一遍按关键词，随后逐条读签名核对。首遍有两类误判，已更正：见证的结论被当作前提，以及 `∀`、`∃`、`↔` 的辖域；脚本现按 Lean 的结合规则处理辖域。各节的 `variable` 只引入数据。若仍有遗漏，最可能在评价条件的名称上；脚本列出每条的假设，可以复查。
5. *A、C、L、J1–J4 怎样？* 清点把它们归为评价条件。它们仍是实践规律的公开条件，不被断言，移动不改变这一点。

**边界。** 不新增定理，不改定义；移动待 Ren；尚无独立审查。

## 70. 识与检验（P49）

2026-10-11。Ren 提议（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-wisdom-from-registration.md)）：

>
>

AI 的分析与拟议阶段在[计划](../history/root-foundation/REGISTRATION-AND-TESTING-PLAN.md)中。它说经由支持的反馈有三种不见（阈下、视界之外、所及之外）；失控是在其一之中运行的回路；量度、延续的模型与他者之识是跨过它们的方式；可否证性是被展开纠正的条件；理 读作识 心 的反馈所不能识者的模型。它还留给 Ren 四个问题。Ren 答：“agree with you, great job, start now. for 4, you can explore which option is better, then make decision”。AI 把这读作接受开始这一阶段、接受名称与 理 的读法（来源中的 AI 读法）。第 4 问，即形成自身的立着是否算作被识，由 AI 探索后决定（§70.1）。独立审查收窄了这些读法（§70.2），所以下面的读法是收窄之后的，不是 Ren 所接受的原文。

本节是统一计划 P49（[计划 §10](../history/root-foundation/BECOMING-UNIFICATION-PLAN.md#10-第一部分与第二部分--part-i-and-part-ii)）。起草时编为 P47，因 P47 已是 `Becoming.Standing`，在工作板上改为 P49；审查文件保留起草时的编号。它不加公理，属于第一部分。核心新增模块 `Becoming.Testing`，92 项定理，导入 `Becoming.Feedback` 与 `Becoming.Locality`。按[零前提转向](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)与整合者定下的接口，平衡只在被识的条件上逐步假设（`Flow.BalancesOn`）；整体的平衡经 `Flow.Balances.on` 给出它。

成果记录新增两项：
- [testing-within-registration](../../../../theories/becoming/results/records/testing-within-couplings.md)
- [subthreshold-registration](../../../../theories/becoming/results/records/differences-below-threshold.md)

另扩展一项记录：[becoming-finite-horizon](../../../../theories/becoming/results/records/becoming-finite-horizon.md) 加入它的两个推论 `Renewable.no_exact_finite_reading` 与 `finite_reading_withholds_renewal`（审查 F9），原有断言不变。

```text
Result(s): 复用 feedback-and-reach（Flow.Exchanges、Flow.WithinInfluence、Flow.Balances.unregistered_beyond_influence 的
           形式、Clearing.sparedFlow、sparedWeb、spared_balances、spared_dependent）、levels-of-closure（ClosedUnder、
           WithinClosure、closedUnder_withinClosure、Web.DependsOn）、closing-needs-net-draw（Web.Admits、Flow.withhold、
           Flow.WithheldLevels）、four-cases-of-a-part（Clearing.unsupported_with）、becoming-finite-horizon
           （Renewable.prefix_does_not_decide）；Becoming.Inquiry 的 commonResponse_judge_iff 与 commonResponse_antitone；
           Becoming.Roles 的 Web.SelfBearing 与 Web.Embodied；Becoming.Locality 的 Flow.BalancesOn 与 Flow.Balances.on；
           新增上列两项
Delta: 识：supportOnly、ownStanding（ownStanding_other）、Web.RegistersAlike（refl、symm）、Web.RegistersAlikeUpTo
       （symm、earlier、of_obs）、registersAlikeUpTo_of_agree、Web.alike_of_threshold、Web.observed_level_registers、
       Web.Registers、Web.LevelsAtLeast、Web.admits_iff_supported_of_agree、Web.registersAlike_iff_of_levelsAtLeast。
       否证：Web.Refutes（not_of_alike、not_meets、later、widen、not_of_extension）、Web.tail_unrefuted、Web.RefutesWithin
       （narrow、not_meets）、Web.refutes_iff_refutesWithin_all、Web.refutesWithin_iff_conjunction、Web.RefutesBy
       （of_member）、Web.RegistersAlikeAll、Flow.BalancedHistory（agree）、Flow.balancedHistory_iff、
       Flow.refutes_tail_within。与 Becoming.Inquiry 的桥：Web.Belief、Web.belief_refutes_iff、belief_judge_iff、
       belief_judge_later、belief_judge_widen、sees_narrow。所及：Flow.RegisteredFrom、Flow.WithinRegistration、
       Flow.RegisteredFromEither、withinRegistration_of_withinInfluence、withinRegistration_supportOnly、
       withinRegistration_mono_obs、withinRegistration_mono_flow、beyond_registration、exchange_agrees_within、
       alike_within_closed、alike_within_registration、unregistered_beyond_registration、unrefuted_beyond_registration、
       beyond_needs_model、belief_judge_beyond。阈值：Flow.ExchangeFollows、difference_kept、levelsAtLeast_while_alike、
       alike_while_supported、difference_changes_after_divergence、subthreshold_alike、subthreshold_alike_always。
       见证：Gauged（gauge_changes_difference、own_is_stock）、SupportDrawn.difference_waits、JointFailure.difference_kept、
       Attracting.higher_breaks_first、Prey（registers_taking、omits）、SelfPrey（threshold_on_oneself、within_influence）、
       Stationary（model_error、model_refuted）、Clearing（alike_for_clearer、tested_by_dweller、pooled、
       model_idles_registration）、Renewable（no_exact_finite_reading、finite_reading_withholds_renewal）
Supplied premises / correspondence: 不加公理；平衡只在被识的条件上逐步假设（Flow.BalancesOn，单元素家族），整体的平衡
       给出它；阈值定理另设交换随识（Flow.ExchangeFollows），所及定理另设区域的封闭与成员只经自己之识回应，都是给出的
       假设，不由动力学推出；有与无部分的比较用扣留水平（其余交换不变，表示上的选择）；模型是可容许历史的类，是给出的；
       观察（obs）是参数，基础是只识支持；离散的步、自然数的量；读法是 AI 的，审查收窄之后待 Ren
Evidence: 合并检查器回执 20261011T072815.712072Z（Becoming.Testing 92 项定理，全部源声明公理报告为空），外围回执 20261011T072918.589912Z；
          整合之前的独立审查（BECOMING-P49-REVIEW.md，起草时称 P47），其 192 个探针常量都不依赖公理
Boundary: 形成观察支持之外的任何东西、量度自身的立着、形成模型、想要避免失控都不推出；识得相同只界定能分辨的，不说差别
          关于什么；一个动作造成什么是对两段历史的比较，只相对于无此动作之历史的模型才可检验；他者怎样回应是给出的；
          “失控”没有定义，失控的读法是启发，不是陈述；不含伦理谓词
Integration: 计划 P49（原计划的 T1–T5，见计划 §7）；推广 P42 的 unregistered_beyond_influence（观察，回应的形式）；
             把 Becoming.Feedback 接到 Becoming.Inquiry（判断即对信念的共同回应）；为无明边界计划的 B3–B4 提供陈述
```

| 声明 | 内容 |
|---|---|
| `supportOnly`、`ownStanding`、`Web.RegistersAlike`、`Web.RegistersAlikeUpTo` | 形成识它的支持（水平是否接纳它）与它所观察之条件的水平（`obs`）；在两个水平历史之下，在某步水平同样接纳它、所观察的条件同样立着，就是识得相同；直到某步每步如此，就是直到该步识得相同。基础观察是只识支持；量度自身的立着（`ownStanding`）是一个观察前提 |
| `Web.alike_of_threshold`、`Web.observed_level_registers`、`RegistersAlikeUpTo.of_obs` | 一个依存而不观察的条件，只识它是否满足所需：两个历史下都满足或都不满足，形成就识得相同，无论两个水平是多少；观察的条件以其水平被识，任何差别都被识；观察得更多，分辨得更多 |
| `Web.Refutes`、`Refutes.not_of_alike`、`not_meets`、`later`、`widen`、`not_of_extension` | 满足主张的历史没有一个直到某步与实际识得相同，主张就在该步被否证；主张只经所识的差别被否证；成立的永不被否证；否证此后一直成立；观察得更多否证得更多；与记录在该步之前一致而满足主张的历史，使主张不被否证 |
| `Web.tail_unrefuted` | 没有模型时，对任何直到某步的记录，“某条件将归于无”与“它此后一直在无之上”都不被任何形成、在任何观察下否证 |
| `Web.RefutesWithin`、`refutesWithin_iff_conjunction`、`refutes_iff_refutesWithin_all`、`RefutesWithin.narrow`、`RefutesWithin.not_meets` | 相对于一个模型（可容许历史的类）否证：满足主张的可容许历史没有一个识得相同；这就是对“模型且主张”的否证（迪昂–奎因的结构）；不相对于模型就是相对于容许一切历史的模型；模型越窄否证越多；模型容许实际时，成立的不被否证 |
| `Flow.BalancedHistory`、`BalancedHistory.agree`、`Flow.refutes_tail_within` | 流的水平历史：每步每个条件得其所给、失其所取，是交换的模型；起始在一个条件上相同的两个水平历史在其上一直相同；相对于这一模型，观察储量的形成在第一步就否证一切“它将归于无”的假主张 |
| `Stationary.model_error`、`model_refuted` | 错的模型否证成立的：模型说没有取用与给予，储量在第二步被模型遗漏的取用取尽；相对于它，量度储量的形成在第一步否证“它将归于无”，而这在实际中成立；在第二步，模型容许的历史没有一个与实际识得相同：识否证了模型 |
| `Web.Belief`、`belief_refutes_iff`、`belief_judge_iff`、`belief_judge_later`、`belief_judge_widen` | 形成的信念是与实际识得相同的历史；否证就是主张与信念不交；由识作出的判断恰是 `Becoming.Inquiry` 中判断过程在信念上的共同回应；更晚的步与更多的观察收窄信念，保持每个共同回应 |
| `Web.Registers`、`Flow.RegisteredFrom`、`Flow.WithinRegistration` | 形成依存于或观察一个条件，就识它；另一个形成与它所识的条件交换，它就经所识者受其影响；识闭包是对这一关系的闭包 |
| `withinRegistration_of_withinInfluence`、`withinRegistration_supportOnly`、`withinRegistration_mono_obs`、`withinRegistration_mono_flow`、`beyond_registration` | 识闭包含 P42 的影响闭包，只识支持时就是它；它随观察与交换增大；闭包之外的不与闭包之内被识的条件交换 |
| `Flow.exchange_agrees_within`、`Flow.alike_within_closed`、`alike_within_registration` | 两个流在相同的形成在场、在成员所识的每个条件上逐步平衡；区域在两个流中都对经所识者受影响封闭；水平起始在成员所识的条件上相同；每个成员在自己识得相同之处，对成员所识的条件同样取用与给予。那么每个成员每步都识得相同，无论区域之外、成员不识的条件上或成员不识的水平上有什么不同。对从一个形成出发、经两个流画出的识闭包也如此 |
| `Flow.unregistered_beyond_registration`、`unrefuted_beyond_registration`、`beyond_needs_model`、`belief_judge_beyond` | 其余交换固定、部分的成员都在识闭包之外时，闭包之内每个形成每步有与无部分都识得相同（上一定理的实例，第二个流是扣留部分的流；只识支持时就是 P42 的 `unregistered_beyond_influence`）；所以无部分的水平所满足的主张在闭包之内不被否证；闭包之内相对于模型的否证，靠的是模型对部分之交换的排除；闭包之内的判断在有与无部分时都可容许 |
| `Flow.ExchangeFollows` | 交换随 `g` 的识：凡 `g` 直到某步识得相同，两个流跨过该步在 `g` 所识的每个条件上，对在场的全部形成，取用与给予的总量相同。这是关于 `g` 周围全部交换的假设：它排除他者对 `g` 所不识者作出回应 |
| `Flow.difference_kept`、`levelsAtLeast_while_alike`、`alike_while_supported` | 在 `g` 识的条件上逐步平衡、交换随其识时：`g` 识得相同期间，它所识条件上的每个差别都保持起始的样子；第二个网在 `g` 所识的条件上起始不低、在其观察的条件上相同时，在第一个网此前每步都支持 `g` 的每一步，`g` 都识得相同；可以有任意多个条件不同 |
| `Flow.difference_changes_after_divergence` | 差别在某步之前已改变，必有更早的一步，第二个网的水平接纳 `g` 而第一个网不支持它：起作用的是两网的分岔；活动需要支持时，`g` 在第一个网中并非此前每步都活跃；两网一起失败不是分岔 |
| `Flow.subthreshold_alike`、`subthreshold_alike_always` | 阈下：起始只在 `g` 依存而不观察的一个储量上不同，第二个网中高 `d`。那么在第一个网此前每步都支持 `g` 的每一步，储量在第二个网中恰好高 `d`，`g` 所识的其余条件相同，`g` 此前每步都识得相同；第一个网每步都支持 `g` 时，每步都如此 |
| `SupportDrawn.difference_waits` | 形成需要一个单位，在每个被支持的步取一个单位，较低的储量是二、较高的是三，交换只随支持：差别一直保持到第三步，较低的网在第三步不支持它而较高的网支持，第四步差别已变 |
| `JointFailure.difference_kept` | 第二个所需条件在第一步之后消失，两个网都从第二步起不支持形成：储量差别每步都保持，较低者的失败不是分岔 |
| `Gauged.gauge_changes_difference`、`own_is_stock` | 观察储量的形成在第一步就取尽需要之上的全部：两网中它每步都被支持，较高的网中它动用了差别；它在第一步就把两网识为不同，所以交换随其识不约束任何东西；只识支持时交换不随其识。储量划作自身的立着时，量度自身就是量度储量 |
| `Attracting.higher_breaks_first` | 他者回应储量本身时：取用者被三个单位的储量招来，在第一步取两个单位；较高的网在第二步就不支持依存者，较低的网仍支持；依存者在第一步识得相同而取用总量不同，交换不随其识 |
| `Prey.registers_taking`、`Prey.omits` | 猎物依存于无人交换的食物，不依存于自身：捕食者在其影响闭包之外、在量度自身时的识闭包之内；其余交换固定时，猎物经支持每步都把捕食者的部分识得相同，量度自身则在咬之后识它。所识的差别对猎物不起任何作用：它每步都被支持、活跃并被无捕食者的水平接纳；它不承担自身，捕食者以零水平活跃：第一项靠的是这些被省略的关系 |
| `SelfPrey.threshold_on_oneself`、`within_influence` | 猎物以所需一依存于自身：捕食者在其影响闭包之内；咬一个单位不使它低于自身所需，经支持每步都识得相同，量度自身在第二步识之；咬两个单位，经支持在第二步就被识 |
| `Clearing.alike_for_clearer`、`tested_by_dweller` | 清除者每步都识得相同，无论清除是否终结栖居者（`alike_within_closed` 的实例：清除是对清除者一侧无人识之条件的作用）；在不清除的世界中，“栖居者已被终结”被清除者在任何一步都不否证，被栖居者在第三步否证 |
| `Clearing.pooled` | 在不清除的世界中，“第三步栖居者或清除者不被接纳”，清除者与栖居者各自都不否证，两者合起来否证 |
| `Clearing.model_idles_registration` | 以固定起始与交换的模型，清除者在第一步就否证“栖居者在第三步被接纳”，而它不识栖息地的任何东西：完整的模型使识不起作用 |
| `Renewable.no_exact_finite_reading`、`finite_reading_withholds_renewal` | 延续开放时，没有由前 `h` 步决定的读法恰是整段的分类；不认可任何消耗的运行的这种读法，不认可某个更新的运行。两者都是 `prefix_does_not_decide` 的推论 |

**它回答了什么。**
- **一个形成能识什么。** 经依存，识是一个阈值：一个条件只以是否满足所需被识（`Web.alike_of_threshold`）；经观察，识其水平（`Web.observed_level_registers`）。这是计划 T1 的识等价，在一步上是精确的。
- **主张需要什么才能被检验。** 主张只经所识的差别被否证（`Web.Refutes.not_of_alike`）。这是可否证性的结构：主张与其对手必须在能被识之处不同。它是关系的：清除者不能检验的，栖居者能（`Clearing.tested_by_dweller`），两者合起来能检验各自都不能的（`Clearing.pooled`）。它随所识者而动：观察得更多，否证得更多（`Refutes.widen`）。
- **视界与模型。** 没有模型，有限的记录不否证任何关于其后的主张（`Web.tail_unrefuted`）。审查之前，AI 把这读作“关于整个运行的主张不被有限记录检验”；它只在延续开放时成立。相对于交换的模型，观察储量的形成在第一步就否证关于整个运行的假主张（`Flow.refutes_tail_within`）。代价也在：相对于模型的否证是对模型与主张一起的否证（`Web.refutesWithin_iff_conjunction`），错的模型否证成立的（`Stationary.model_error`），而识否证模型（`Stationary.model_refuted`）。延续开放时，没有有限的读法是精确的（`Renewable.no_exact_finite_reading`）。
- **所及之外的不见，在成员有回应时。** 审查之前的形式固定其余交换，闭包的传递性在其中不起作用。现在的形式让区域之内的成员回应：只要每个成员只经自己之识回应，区域之外的差别永不在区域之内被识（`Flow.alike_within_closed`）。固定其余交换的形式是它的实例（`unregistered_beyond_registration`），`Clearing.alike_for_clearer` 也是。
- **阈下的不见，精确的形式。** 在交换随识之下，差别在 `g` 识得相同期间不变（`difference_kept`），只在两网支持分岔之后改变（`difference_changes_after_divergence`）；两网一起失败时，差别可以永远保持（`JointFailure`）。观察储量解除这一点（`Gauged`）。他者回应储量本身时，假设不成立，较高的储量可以先终结 `g`（`Attracting`）：这是审查找到的真实反例，针对未加限定的读法。
- **与 Becoming.Inquiry 的桥。** 形成的信念是与实际识得相同的历史；由识作出的判断恰是判断过程在信念上的共同回应，更晚的步与更多的观察都保持它（`Web.belief_judge_iff`、`belief_judge_later`、`belief_judge_widen`）；闭包之内的判断在有与无闭包之外的部分时都可容许（`Flow.belief_judge_beyond`）。

**读法（AI 的；Ren 接受过收窄之前的措辞，审查收窄了它们）。**
- 经由支持的反馈有三种不见，各有其范围：阈下，在交换随识之处；视界之外，在延续开放之处；识闭包之外，在成员只经自己之识回应之处。它们不是全部：经支持只识得净交换（`Flow.Balances.agrees_iff_even`），跨所需诸条件只有一个合起来的比特。
- 失控是在其一之中运行的回路。这是启发，不是陈述：回路与增益都没有定义；他者回应储量时，其损失可以更早被识（`Attracting`）。
- 量度识阈下的水平（`Web.observed_level_registers`）；交换的模型相对于自身越过视界，并对识负责（`Flow.refutes_tail_within`、`Stationary`）；新的观察与新的交换扩大闭包（`withinRegistration_mono_obs`、`withinRegistration_mono_flow`）；他者之识检验自己不能检验的（`Clearing.tested_by_dweller`、`Clearing.pooled`），而它只经本身是交换或观察的关系到达自己。
- 可否证性是被展开纠正的条件：主张与其对手必须在能被识之处不同。它是关系的，随所识者而动。没有模型，有限的记录不检验关于其后的主张；有了模型，检验的是模型与主张一起。
- 与 Ren 的 心 与 理 合读，理 是对识负责的模型：它收窄所容许的历史，使同样的识判定更多；它可以误导，识纠正它。

### 70.1 第 4 问：形成自身的立着是否算作被识

Ren 把第 4 问留给 AI：“for 4, you can explore which option is better, then make decision”。这是表示上的选择：`obs` 是参数，每个定理对每个 `obs` 成立，所以决定不改变任何定理，只改变读法与默认。

**最初的决定。** 起草时 AI 决定：在一类读法中，形成自身的立着算作被识（`ownStanding` 为默认），只识支持（`supportOnly`）是两类读法的情形。理由有三：一类读法中形成与条件是一个关系项，否认自身立着的变化在自身中被识，看起来像把形成拆成观察者与身体；被取用是最直接的承受；形式上无害。

**审查的论证（第 6 节）。** 审查认为这是较弱的选择，理由是：
1. 经依存，识是一个阈值（`Web.alike_of_threshold`）。`ownStanding` 给形成以对自身水平的精确、完整的量度，别的关系都没有。这是特权的、透明的自我通达。[非二方法](../../../../theories/becoming/history/NONDUAL-METHOD.md)要求说明认识怎样在展开中形成，而不是先给出一个认识者。
2. 脊柱已有这一关系：`Web.SelfBearing`，以正的所需依存于自身的立着。Roles 把体现与承担自身写作同一对应之下的读法；`ownStanding` 是同类的进一步读法，不是同一对应的推论。
3. `Prey` 显示的是决定，不是其根据：捕食者在影响闭包之外，只因为猎物不承担自身（`Prey.omits`）。
4. 在 `ownStanding` 之下，对划作自身立着者之耗竭的阈下不见无法表达（`Gauged.own_is_stock`）。而不被察觉的自我耗竭直到崩溃，正是失控的核心情形：过劳、成瘾、身体缓慢的失去。同一储备划作所持条件时就有阈下不见。结论取决于划法。
5. 模块自己的“不推出”写着：形成观察支持之外的任何东西不推出。自身的立着在支持之外。

**决定。** 采纳审查的建议。基础是只识支持（`supportOnly`）；在一类读法中，自身的立着经承担自身（`Web.SelfBearing`）识，像其他依存的条件一样是阈值；量度自身（`ownStanding`）是一个观察前提，与 `Gauged` 对储量的量度同类。`SelfPrey.threshold_on_oneself` 给出对照：咬只在使猎物低于自身所需时经支持被识，量度自身则识每一口。

除了审查的五条，AI 另有两条理由：
- **最弱的基础给出最强的陈述。** 观察得更多，分辨得更多（`RegistersAlikeUpTo.of_obs`），否证得更多（`Refutes.widen`），闭包也更大（`withinRegistration_mono_obs`）。在基础观察下证明的不见与检验的条件，以更多观察为前提时仍可陈述，每个观察都作为局部前提写在用它之处。这也合于零前提转向：前提局部化，写在用它的地方。
- **一元的处理。** 形成对自身的关系与它对任何条件的关系同样处理：认识的范围由实际的关系给出，不预先给出一个对自身透明的认识者。

### 70.2 独立审查与处理

另一 agent（Claude Opus 5.5，未参与撰写）在整合之前审查了第一稿（[审查](../history/root-foundation/BECOMING-P49-REVIEW.md)，起草时称 P47，第十七次独立审查）。它逐字节重编译了被审文件，审计全部 127 个常量，公理报告全部为空；它的 192 个探针常量也都不依赖公理，没有经典推理。判断：Lean 全部成立；问题在散文、读法、名称与一个假设的范围，不在证明。审查者的探针保存在 [development/becoming-p49-review-probes](../history/root-foundation/development/becoming-p49-review-probes/README.md)，那里写明每个探针进入核心后的名称。下表是十三项发现的处理；表中的定理名是整合后的名称。

| 项 | 审查所见 | 处理 |
|---|---|---|
| F1 | 视界的读法说过了头：“关于整个运行的主张不被有限记录检验”“每个有限的更新检验都在一侧出错”只在延续开放时成立；对一切历史它们平凡成立，相对于模型它们是假的 | 加入 `Web.tail_unrefuted`（C2）、`Web.RefutesWithin`、`refutesWithin_iff_conjunction`（C6）、`Flow.BalancedHistory`、`Flow.refutes_tail_within`（C3）、`Stationary.model_error`、`model_refuted`（C4、C4b）、`RefutesWithin.not_meets`（C1）；两条读法加上延续开放的范围；“在一侧出错”改为“没有有限的读法是精确的”（`Renewable.no_exact_finite_reading`） |
| F2 | 阈下的不见依赖 `RespondsThrough`，它排除了直接回应储量的他者，读法与 README 都没有写出；`Attracting` 中较高的网先断 | 改名为 `Flow.ExchangeFollows`，说明写明它是关于 `g` 周围全部交换的假设；读法、README 与章节写出这一范围；加入 `Attracting.higher_breaks_first`（A7） |
| F3 | 自身的立着应经承担自身被识，不应默认为完全的量度；`Prey` 靠一个省略 | 决定改为 `supportOnly` 加 `Web.SelfBearing`，`ownStanding` 是观察前提（§70.1）；加入 `SelfPrey`、`Prey.omits`、`Gauged.own_is_stock` |
| F4 | 所及闭包的传递性在固定其余交换的比较中不起作用 | 采纳回应的形式 `Flow.alike_within_closed`（B1），以 `unregistered_beyond_registration` 与 `Clearing.alike_for_clearer` 为其实例（B3、B4）；加入 `alike_within_registration`、`exchange_agrees_within` |
| F5 | 阈值定理可以更精确；断裂是分岔 | 去掉空转的 `requires` 与 `need` 假设（A0）；加入 `difference_kept`（A1）、`alike_while_supported`（A2，任意多个条件不同）、`difference_changes_after_divergence`（A4）、`JointFailure.difference_kept`（A6）、`Web.alike_of_threshold`（A8）；`subthreshold_alike` 不再要求所需一致；只在按条件分情形处用 `DecidableEq` |
| F6 | `Refutes` 检验的是关于一段历史的主张；“我的行动造成什么”是反事实的 | “不推出”写明：一个动作造成什么是对两段历史的比较，只相对于无此动作之历史的模型才可检验（`Flow.beyond_needs_model`、`Clearing.model_idles_registration`，C7、C8）；变动自己的动作并识差别列为开放 |
| F7 | “Ren 接受”没有来源记录 | 来源文件保存 Ren 的第二条消息（`2026-10-11-wisdom-from-registration.md`）；模块写明读法是 AI 的、Ren 接受过收窄之前的措辞、审查收窄了它们 |
| F8 | 引错的定理 | 各处改为引用一般定理与 B5、C5；`Gauged` 的说明写明观察储量时假设空成立；`SupportDrawn` 写“第三步之前” |
| F9 | 视界的对偶是推论 | 记作 becoming-finite-horizon 的推论；以 `no_exact_finite_reading` 为主陈述 |
| F10 | 对 P42 的复用 | 记录写明 `unregistered_beyond_registration` 推广 P42 的 `unregistered_beyond_influence`（观察），实质的增量是 `alike_within_closed` |
| F11 | `tested_by_dweller` 近乎定义 | 加入 `Clearing.pooled`（C5）：需要两个位置的检验 |
| F12 | 缺少到 `Becoming.Inquiry` 的桥 | 加入 D：`Web.Belief`、`belief_refutes_iff`、`belief_judge_iff`、`belief_judge_later`、`belief_judge_widen`、`Flow.belief_judge_beyond`；多步 `Scope` 的桥仍开放 |
| F13 | 名称 | `RespondsThrough` 改为 `ExchangeFollows`；`AlikeUpTo` 改为 `RegistersAlikeUpTo`；`threshold_blind` 改为 `subthreshold_alike`；`surplus_untouched`、`surplus_after_break` 改为 `difference_kept`、`difference_changes_after_divergence`；`Gated` 改为 `SupportDrawn`（审查也提议 `Thresholded`；`Drawdown` 与 `Becoming.Evolution` 中的命名空间冲突）；`Ended` 改为 `DwellerEnded`；`admits_iff_supported` 改为 `admits_iff_supported_of_agree`；根层的 `one_ne_two`、`two_ne_three` 去掉，改用 `by decide`；中文原作“计入”，与 P42 一致；Ren 读到这一问后答“need more context, 计入 is apparently weird, need better word”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-wisdom-from-registration.md)），AI 先改为“反映”；Ren 定为“识”（“for registers, use 识”），P42 中同义的“计入”一起改为“识”，“必须计入”等“考虑在内”之义不变（见下） |

**审查之外的改动。** 按零前提转向与整合者的接口，全部一般定理只在被识的条件上逐步假设平衡（`Flow.BalancesOn`，单元素家族，不需要有限性）；见证经 `Flow.Balances.on` 给出它。整合者要求不另立局部平衡或局部耗散的概念，模块没有另立。

**“识”。** 英文的 registers 在这里说的是：一个差别在形成的状态中显出来，即支持（水平是否接纳它）或所观察的水平不同。中文原作“计入”（与 P42 一致），有记账的意味；Ren 认为“计入 is apparently weird, need better word”，AI 先改为“反映”，取科学用语中“温度计反映温度”之义；Ren 定为“识”：“for registers, use 识”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-wisdom-from-registration.md)）。于是：形成识其支持与所观察的水平；两段历史之下 g 识得相同；依存而不观察的条件只以是否满足所需被识；识闭包；交换随识。P42 中同义的“计入”一起改为“识”（如“经支持只识得与其所依存者的交换”“反馈至多识及影响闭包”），“必须计入”“谁的延续计入”等“考虑在内”之义不变。读法（AI 的，待 Ren）：识在缘起中紧随无明与行，P62 的无明一线因此用同一个字；这里只取“差别在其中显出”一义，不先给出一个认识者。

### 70.3 作者反审

1. **给出的回应假设。** `Flow.ExchangeFollows` 与 `alike_within_closed` 的回应假设是给出的，不由动力学推出。它们刻画的是：只要他者不回应 `g` 不识者，差别就这样保持。他者回应储量本身时，假设不成立（`Attracting`）。哪些展开满足它，是经验问题。
2. **回路没有定义。** “失控是在其一之中运行的回路”是启发：模块没有定义回路、增益或失控。要把它变成陈述，需要先定义回路（例如水平影响取用、取用又影响水平的闭合），那是另一步。
3. **模型是给出的。** `RefutesWithin` 的模型是任意的可容许历史类；模型从哪里来、形成怎样形成它，不推出。`Flow.BalancedHistory` 是一种模型，即交换本身；其余模型的来源没有表示。
4. **否证不是一种行动。** 对没有探究的形成，`Refutes` 读作“它之识排除了主张”。形成是否对否证作出回应，是另一回事；桥（D）只说判断是对信念的共同回应，不说形成会作出它。
5. **识不说关于什么。** 识得相同界定能分辨的；同样的支持可以出自不同的原因（`Flow.Balances.agrees_iff_even`），识的差别指向什么不在其中（校准）。
6. **一个动作的检验。** 一个动作造成什么，是对有与无此动作的两段历史的比较；单个形成的识只给出一段。相对于固定起始与交换的模型，识不起作用（`Clearing.model_idles_registration`）；变动自己的动作而识差别，即实验，没有陈述。
7. **视界的结论是存在性的。** `no_exact_finite_reading` 用一个过程见证；它说的是延续开放之处，不说实际的延续是否开放。
8. **读法与名称是 AI 的。** Ren 接受的是收窄之前的措辞；收窄之后的读法、改动后的名称与第 4 问的决定，都待 Ren 看过。

**检查。**
- 模块在暂存区对核心编译，没有错误或警告；逐条审计全部 294 个常量（含 Lean 生成的辅助常量），公理报告全部为空。`by decide` 只用于自然数字面量的不等；证明不用经典推理，也不用 `nomatch` 证明数字不等（那会带入 `propext`）。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T072815.712072Z。`Becoming.Testing` 的 92 项定理全部空依赖；包共 2263 项定理、3406 项声明审计，核心闭包 44 个模块。外围桥接对这个核心重查，通过：回执 20261011T072918.589912Z。缓存使这次运行只编译 `Becoming.Testing` 及其依赖者（14 步运行、189 步复用）。
- 整合之前经独立审查；处理见 §70.2。处理之后的文本尚未经独立审查。

## 71. 依存、储备、支持与普查平衡的规律，条件在规律之内（P50）

2026-10-11。按 Ren 的转向：“stop extending the premise-selection tables. New goal: remove premises and derive the most general versions, zero premises first”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)）；又按 Ren 同日“一起先完成一个统一的理论”的指示（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-one-unified-theory-together.md)）。零前提计划 §1.3 的 C 组（依存、储备与支持）各条规律的前提都可局部化；普查平衡中不由 §66 的规律 2 覆盖的部分也一样。本节把它们对每个世界重述，证明用到的条件写在规律之内，只在证明用到它的步、条件与形成上。所作的一步仍是局部化：不推出任何前提，原定理名称与陈述不变，在原处改为局部规律的推论重证。本节由“0 axiom completeness”会话起草并验证，按[工作板](../../../BECOMING-WORKBOARD.md)由整合者分派。它建在 §66 的 `Flow.BalancesOn` 之上，没有新模块。

```text
Result(s): 修订 census-balance、becoming-dependence-dynamics、space-and-its-parts、own-count-misses-joint-excess、
           support-from-the-supported、closing-needs-net-draw、consumption-ends-with-feeders、evolution-on-descent、
           census-balance-under-continuation、whole-law-of-counting
           （局部规律加入证明引用；下一步以确切重述开头；用 Flow.BalancesOn 的四条记录复用 laws-of-one-step）
Delta: 共享条件（Flow）：Flow.GiversSupported、Flow.Acting.giversSupported；
       Change：balance_over_stretch_on（Population 的 balance_over_stretch 改为它的推论）；
       Dependence：Web.continuing_restores_at、Web.consumed_continues_transformed_at；
       Roles：Web.inactive_below_at、Web.ceases_below_at；
       Continuation：Flow.excess_lowers_at、excess_bounded_at、stays_below_at、ends_below_at、joint_excess_ends_at；
       Admission：Flow.rise_given_by_supported_at、gains_from_supported_at、unsupported_stays_at、
       nothing_supported_stays_at、withheld_at、supported_of_net_give_at、admits_of_net_draw_at、
       supported_iff_within_margin_at；
       Interdependence：Flow.unfed_consumption_ends_at、consumption_ends_with_feeders_at；
       Evolution：Flow.DescendsAt.supported_at、unsupported_childless_at、selected_le_at、selection_within_at、
       transmitted_supported_at、transmitted_within_at；
       普查平衡（Population）：recurs_shift、recurs_unshift、gaining_of_losing_from、losing_of_gaining_from、
       Listed.keeps_at、across_at、over_stretch_on、ceasing_iff_shortfall_from、coming_iff_excess_from、
       Web.Census.over_stretch_on、Web.DependenceCensus.over_stretch_on；（Openness）Web.StandingCensus.over_stretch_on；
       （Identity）Web.Census.balanceFrom_at、balanceFrom_eq_at、arisingFrom_of_ceasingFrom_from、
       ceasingFrom_of_arisingFrom_from。
       推论改证（名称与陈述不变）：Web.continuing_restores、consumed_continues_transformed；Web.Dependent.inactive_below、
       ceases_below；Flow.excess_lowers、excess_bounded、stays_below、ends_below、joint_excess_ends；
       Flow.rise_given_by_supported、gains_from_supported、unsupported_stays、nothing_supported_stays、
       Flow.Balances.withheld、supported_of_net_give、admits_of_net_draw、supported_iff_within_margin；
       Flow.Balances.unfed_consumption_ends；Flow.DescendsAt.supported、unsupported_childless、
       never_supported_childless、selected_le、transmitted_supported、transmitted_within；balance_over_stretch；
       Listed.keeps、across、over_stretch、ceasing_iff_shortfall、coming_iff_excess；Web.Census.over_stretch、
       Web.DependenceCensus.over_stretch、Web.StandingCensus.over_stretch；Web.Census.balanceFrom、
       arisingFrom_of_ceasingFrom、ceasingFrom_of_arisingFrom
Supplied premises / correspondence: 无；每条规律的条件写在规律之内。既有定义一概不改，只在 Flow 中加一个定义
Evidence: 合并检查器回执 20261011T073932.785239Z（2306 项定理、3450 项声明审计，全部源声明公理报告为空；核心闭包 44 个模块，包 42 个），
          外围回执 20261011T074322.969802Z；先在暂存树中从前导编译：自 Becoming.Flow 以下 28 个模块无错误、无警告，九个改动模块逐条
          公理报告为空（Flow 230、Change 141、Dependence 488、Roles 466、Continuation 261、Admission 144、
          Interdependence 71、Evolution 158 个常量）；普查平衡再自 Becoming.Population 以下 25 个模块无错误、无警告，
          Population 329、Identity 564、Openness 278 个常量公理报告为空
Boundary: 多数局部规律是蕴含或界，确切的当且仅当只有 supported_iff_within_margin_at；Evolution 在 Locality 之下，平衡以等式
          写在规律之内，与 Flow.BalancesOn 的对应未作为定理陈述；延续之下的复现读法只到“从某步起列出”，未到 §66 的覆盖列表；
          尚无独立审查
Integration: 十一项记录；零前提计划 §1.3 C 组；计划 P50；模块说明；工作板
```

**共享的条件。** 只有活跃者给予（`Flow.Acting`），连同活动需要支持（`Web.Dependent`），在 C 组的证明里只以一种方式被用到：跨过所用的那一步，给予所用条件者都被支持。这就是 `Flow.GiversSupported`：`L.GiversSupported W t c` 指跨过从 t 起的一步，每个参与且给予 c 者在 t 被支持。全局前提经 `Flow.Acting.giversSupported` 给出它。它是关于那一步、那个条件的给予者的事实，对不给予者不说什么。

**一段上的平衡。** 一个计数在一段之内每步平衡（得失相抵），则在整段上平衡：段末连同失去的全部，等于段首连同得到的全部；段外各步不作要求（`balance_over_stretch_on`）。它从 Population 移到 Change，使 Evolution 也能用；Population 的 `balance_over_stretch` 改为它的推论。

**依存只用一步的支持。** 在 t 被支持、依存不弱于先前的形成，发现条件满足先前的所需（`Web.continuing_restores_at`）；无返回的损失之后，在后来某步被支持的形成，已减弱或消解它对该条件的依存（`Web.consumed_continues_transformed_at`）。用到的只是那一个形成在那一步的支持，不是 `Dependent`。同样，跨过一步被留在所需之下、依存在步后持续且所需不降的形成，若步后活跃时被支持，则步后不活跃（`Web.inactive_below_at`）；此前活跃时，这就是它的终结（`Web.ceases_below_at`）。

**联合超出。** 跨过一步在该条件上平衡，一步联合超出（给的少于取的）使水平至少降一（`Flow.excess_lowers_at`）；所用 n 步各自平衡时，n 步连续超出使水平至少降 n（`Flow.excess_bounded_at`）。一旦低于 m，在所用各步上平衡、给予者有门槛（依存于它、所需至少 m）且被支持（`Flow.GiversSupported`），就一直低于 m（`Flow.stays_below_at`）。在那一步，依存于低于所需的条件、只在被支持时活跃的形成不活跃（`Flow.ends_below_at`）。合起来：前 n + k 步平衡、给予者有门槛且被支持，自 T 起 n 步联合超出、起点低于 n + m，则在 T + n + k 步依存所需至少 m 的形成不活跃（`Flow.joint_excess_ends_at`）。

**支持只从被支持者得到。** 跨过一步在该条件上平衡，上升由参与者给予；给予它者被支持时，由被支持者给予（`Flow.rise_given_by_supported_at`）。所需各条件跨过该步平衡、给予它们者被支持时，要求不放松的形成只在被支持者给予它所需的条件时获得支持（`Flow.gains_from_supported_at`）。没有外部给予时，终点吸收：在所用的 n 步上满足同样条件，没有成员在 T + n 被支持（`Flow.unsupported_stays_at`）；对整体，没有什么被支持或活跃（`Flow.nothing_supported_stays_at`）。

**闭合需要净取用。** 扣留一个部分时：在 c 上、t 之前各步平衡，则 t 时的水平连同该部分迄今所取，等于没有它的水平连同它迄今所给（`Flow.withheld_at`）。边界仍是确切的当且仅当，平衡只在该形成所需的条件上、只在 t 之前各步：它在 t 被支持，恰当它在每个所需条件上的所需连同该部分所取不多于没有它的水平连同该部分所给（`Flow.supported_iff_within_margin_at`）；两个方向分别是 `Flow.supported_of_net_give_at` 与 `Flow.admits_of_net_draw_at`。

**消耗随其供给者终止。** 在所用的 n 步上，该条件平衡、给予者被支持、g 活跃时取用它而没有被支持者给予它，则 g 自 T 起连续活跃 n 步，只当 n 不多于 T 时的水平（`Flow.unfed_consumption_ends_at`）；供给 g 之延续者都不被支持时也一样（`Flow.consumption_ends_with_feeders_at`）。

**降生上的演化。** 亲代只在活跃时给予、只在被支持时活跃，这两件事只在降生那一步用到（`Flow.DescendsAt.supported_at`、`Flow.unsupported_childless_at`、`Flow.selected_le_at`、`Flow.selection_within_at`）。被传递的是被选择过的：`TransmitsWithin c δ` 只用它在该次降生的一个实例（`Flow.transmitted_supported_at`）；传递之段内每步平衡，写在规律之内（`Flow.transmitted_within_at`）。

**普查平衡。** 一步上的普查平衡只用该步两端的列出：步后的列表连同不再成立的，等于步前的列表连同开始成立的（`Listed.across_at`，经 `Listed.keeps_at`）。一段上只用该段各步的列出，段外不作要求（`Listed.over_stretch_on`）；读于活动、依存与所立者也一样（`Web.Census.over_stretch_on`、`Web.DependenceCensus.over_stretch_on`、`Web.StandingCensus.over_stretch_on`）。复现的读法仍是确切的当且仅当，只要求从某步 T 起列出：不再成立复现，恰当从 T 以后每一步起，某个后来的列表短于起点的列表连同其间开始成立的（`Listed.ceasing_iff_shortfall_from`）；开始成立的对称形式是 `Listed.coming_iff_excess_from`。在延续之下，一步的平衡只用该步两端的列出与该步的不分裂、不合并（`Web.Census.balanceFrom_at`；两者都没有时取等号，`balanceFrom_eq_at`）；不再成立的复现需要生起的复现，只要从某步起列出且不分裂（`Web.Census.arisingFrom_of_ceasingFrom_from`），反方向另加不合并与有界（`Web.Census.ceasingFrom_of_arisingFrom_from`）。从某步起的形式经平移得到（`recurs_shift`、`recurs_unshift`、`gaining_of_losing_from`、`losing_of_gaining_from`）。

**未改的，与理由。** 展示前提的例子世界（`Downstream.one_way`、`Mortal.after_its_end`、`Mortal.without_continues`、`Clearing.undermines_within_renewal`、`Overshoot.ends_through_feeder`）陈述的就是前提在该世界成立；`static_dependent` 是 `Iff.rfl` 的对应；`Flow.Balances.closes_nothing`、`opens_nothing` 的结论关于每一步，需要每一步的平衡，它们每步的内容就是 `supported_of_net_give_at` 与 `admits_of_net_draw_at`。

**表示的承诺（Ren 的第 4 项）。** 以下由陈述与证明读出：
- **可判定。** 不判定世界的任何谓词；证明只判定数的大小，并在有限的参与者列表上求和。
- **整单位。** 联合超出每步至少降一，用的是自然数的严格小于；其余规律只用加法与次序。超出整单位的量下是否成立，这里尚未检验。
- **时间。** 每条规律关于离散的步与其中有限的一段；较粗的步由 `Sampling` 检验（落地队列第 7 项）。
- **有限。** 只用每步有限的参与者列表；普查平衡只用所用各步的列表，不用全局的普查。

**作者反审。**

*反驳 1：这只是把全局前提限制到用到的步吗？* 部分是，但条件也更弱。`Flow.GiversSupported` 只关于给予所用条件者，而 `Acting` 与 `Dependent` 关于每个形成与每一步；依存的规律只要一个形成在一步的支持；闭合的边界只要所需条件上、t 之前的平衡。原定理改经这些规律证明，所以局部规律是来源，不是包装。

*反驳 2：每条都是“Y 当且仅当 Z”吗？* 不是。确切的当且仅当只有 `supported_iff_within_margin_at`。其余是蕴含或界，因为反方向一般不成立：例如被支持者给予时，同一步的取用可以抵消，所以不必上升。联合超出之界的确切形式是 `balance_over_stretch_on` 的恒等式，界按界陈述。其余各条有没有确切形式，是下一步。

*反驳 3：`GiversSupported` 是否把 `Dependent` 换了个名字偷渡进来？* 没有。它是一步、一个条件上的给予者的事实，写在规律之内，不是全局前提。它与 `Acting`、`Dependent` 的关系只有一个方向：两者合起来给出它（`Flow.Acting.giversSupported`），这就是原定理成为推论的方式。在 `Dependent` 不成立的世界里它能否成立，是一个可判定的问题；本节没有为此给出见证世界，只读出定义不涉及不给予者。

*反驳 4：Evolution 为何不用 `Flow.BalancesOn`？* Evolution 只导入 Change，在 Locality 之下，平衡在那里以单个条件上的等式写在规律之内，内容就是单元素家族上的 `BalancesOn`。两者的对应没有作为定理陈述；若整合者把 Evolution 移到 Locality 之上，可以直接改写。

*反驳 5：`TransmitsWithin` 换成它的一个实例，是否就不再是前提？* 只是缩小了它：规律只要它在那一次降生上的实例。它仍是给定的关系，不是推出的；记录 evolution-on-descent 的下一步（能否从一类读法中给予与依存的形成推出它）不变。

*反驳 6：“从某步起列出”是不是最弱的条件？* 不是。§66 的规律 2 在不加延续时只用任意晚的步上的覆盖列表（`coming_of_ceasing_covered`）。延续之下的复现定律能否同样只用覆盖列表，这里没有做；从某步起列出比全局普查弱，但不是已知最弱。

*反驳 7：这是否推出了前提？* 没有。规律对每个世界成立；前提在每一步成立时局部条件处处成立，原定理因此是推论。前提本身仍是偶然的、彼此独立的。

**读法（AI，待 Ren）。** 依存、储备与支持的规律，与 §66 的一步的规律一样，是所用的步与形成的规律；`Acting` 与 `Dependent` 是使它们的条件处处成立的一种方式。

**边界。** 离散步；超出整单位的量与连续时间未在此检验；确切的当且仅当只有一条；延续之下的复现定律用“从某步起列出”，未到覆盖列表；名称（`GiversSupported`，`_at`、`_on`、`_from` 后缀，`recurs_shift`）是 AI 所选，可由整合者或 Ren 改；尚无独立审查。

## 72. 实验：变动自己的动作检验什么、需要什么（P53）

2026-10-11。P49 留下一问（§70，审查 F6）：一个动作造成什么，是有与无此动作的两段历史的比较，而一个展开只有其中一段。P49 落地之后，Ren 写道：“land and merge all, then continue”；看过 P53 的结果后又写：“no extra review needed, merge, then continue”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-wisdom-from-registration.md)）。本节是统一计划 P53，按 Ren 的话不另作独立审查。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Experiment`（L3），25 项定理，导入 `Becoming.Joint` 与 `Becoming.Recurrence`，不改任何已有模块。

成果记录新增一项：[experiment-needs-return](../../../../theories/becoming/results/records/experiment-needs-return.md)。

```text
Result(s): 复用 joint-difference-making（Determined：动作决定一步）、recurrence-without-premise（revisits_from、
           Law.withHistory 的形式）、testing-within-registration（一个动作造成什么须相对于模型检验；识作为投影的读法）；
           Becoming.Frame 的 Run；新增上列一项
Delta: 记录所固定的：Run.Takes、Run.StepsOf、Run.Fixes、Run.fixes_of_takes、retarget、retarget_determined、retarget_step、
       Run.stepsOf_retarget、Run.not_fixes_of_untaken、Run.fixes_on_return、Run.not_fixes_other_of_new、Run.ordered_of_ne。
       保留历史：keepHistory、keepHistory_length、keepHistory_new、keepHistory_determined、keepHistory_fixes_nothing_else。
       经投影的实验：Run.StepsThrough、Run.FixesThrough、Run.fixesThrough_of_takes、FactorsThrough、
       Run.stepsThrough_of_factors、Run.generalizes、Run.projection_returns。见证：Confound（next、process、states、outcome、
       determined、move_idle、hidden_two、aligned、varied、run、aligned_with_hidden、moveDecides、moveDecides_determined、
       misattributes、confounded、varied_refutes）
Supplied premises / correspondence: 不加公理，也不加前提；“固定”相对于确定性（Determined），是所比较的过程类，不是对展开的假设；
       “未取的动作不被固定”另要实际过程确定且有两个不同的配置；投影是模型（FactorsThrough），由运行之外给出；离散的步；
       读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T101806.880391Z（Becoming.Experiment 25 项定理，全部源声明公理报告为空），外围回执 20261011T105433.502229Z
Boundary: 形成变动其动作、保留或遗忘其历史、形成投影都不推出；实际展开经哪个投影分解是经验问题；随机或不确定的过程不在其中；
          与 Becoming.Testing 的识的形式桥接没有陈述；不含伦理谓词
Integration: 计划 P53；回答 P49 的开放项（§70，F6）：何处展开自身比较一个动作的有与无；把 Becoming.Recurrence 的返回与
             保留的历史接到检验上
```

| 声明 | 内容 |
|---|---|
| `Run.Takes`、`Run.StepsOf`、`Run.Fixes` | 运行在某步之前于某配置取过某动作；一个过程容许运行在某步之前的每一步；相对于确定性，直到某步的记录把某动作在某配置的结果固定为某配置：容许运行这些步的每个确定过程，都把该动作在该配置送到那里 |
| `Run.fixes_of_takes` | 取过的动作被固定：运行在某步取过某动作之后，每个容许其各步的确定过程都把该动作在该配置送到运行所到之处 |
| `retarget`、`retarget_determined`、`retarget_step`、`Run.stepsOf_retarget` | 把某配置的某动作改送到任一配置、其余不变的过程；确定的过程改送之后仍确定；没有取过该动作的运行，其各步被每个改送所容许 |
| `Run.not_fixes_of_untaken` | 未取的动作不被固定：实际过程确定、有两个不同的配置时，运行在某步之前没有于某配置取过某动作，记录就不固定该动作在那里的任何结果，无论什么被识：容许运行各步的确定过程可以把它送到任意两个配置 |
| `Run.fixes_on_return`、`Run.not_fixes_other_of_new` | 配置返回之处，另一个动作的结果被固定；配置永不返回的运行，在它经过的每个配置，只固定它在那里所取的动作 |
| `keepHistory`、`keepHistory_length`、`keepHistory_new`、`keepHistory_determined`、`keepHistory_fixes_nothing_else` | 保留其所经配置与动作的历史的过程（`Law.withHistory` 带动作的对应）；历史每步长一；所以每步都是新的；确定的过程保留历史仍确定；所以保留一切的运行，关于自己的动作，除了所做的，什么都不固定 |
| `Run.StepsThrough`、`Run.FixesThrough`、`Run.fixesThrough_of_takes` | 经投影读：容许运行各步投影的确定过程；经投影的记录所固定的；运行取过某动作的投影配置，其结果经投影被固定 |
| `FactorsThrough`、`Run.stepsThrough_of_factors`、`Run.generalizes` | 过程的步经投影分解为一个过程：一个关于配置中何者与其变化无关的模型；模型成立、所分解到的过程确定时，一次场合所固定的结果，就是投影相同的每个配置经投影的结果，无论运行是否经过它 |
| `Run.projection_returns` | 有限多个投影配置之内，投影从每一步起都返回：`revisits_from` 的实例 |
| `Confound.misattributes` | 配置是一个隐藏位与一个结果；每步翻转隐藏位、把结果设为步前的隐藏位，动作在任何地方都不造成差别；只读结果的投影下，直到第二步的记录固定“左得假、右得真”：两个不造成差别的动作之间的差别 |
| `Confound.confounded` | 动作与隐藏位同步时，每一步经结果读都被“动作决定结果”这一确定模型所容许：记录永不否证错误的投影 |
| `Confound.varied_refutes` | 在隐藏位与第一步不同之处再向左，没有确定过程容许直到第五步的投影各步：错误的投影被否证 |

**它回答了什么。**
- **展开自身在何处比较一个动作的有与无。** 相对于确定性，记录恰在运行取过某动作之处固定它在那里的结果（`Run.fixes_of_takes`），在别处什么都不固定，即使每个配置都被识（`Run.not_fixes_of_untaken`）。所以自己的动作若换一个会怎样，只在配置返回、动作不同之处被固定（`Run.fixes_on_return`）。这是 P49 所说“一个动作造成什么，只相对于无此动作之历史的模型才可检验”的精确形式：所需的模型只是确定性，加上一次返回。
- **保留一切者不能做实验。** 保留其全部历史的配置每步都是新的（`keepHistory_new`），所以关于自己的动作，除了所做的，什么都不固定（`keepHistory_fixes_nothing_else`）。这接上 `Becoming.Recurrence`：保留历史的展开永不返回；有限多个配置之内，当下会遗忘。
- **实验需要一个关于何者无关的模型。** 经一个投影读，取过的动作经投影被固定（`Run.fixesThrough_of_takes`）；步骤经投影分解为确定过程时，一次场合代表投影相同的整个类（`Run.generalizes`）；有限多个投影配置之内，投影必返回（`Run.projection_returns`）。
- **模型可以错，而变动能否证它。** 错误的投影把差别归于不造成差别的动作（`Confound.misattributes`）；动作与它所略去的同步时，模型永不被否证（`Confound.confounded`）；动作与之错开时，模型被否证（`Confound.varied_refutes`）。

**读法（AI 的，待 Ren）。**
- 实验是在配置（按实验者的读法）返回之处变动自己的动作。重复是这一返回。
- 对照是这样一个主张：两次场合之间不同的，与变化无关；也就是步骤经这一读法分解的模型。
- 与动作所略去者无关地变动动作，是能否证错误对照的方式；与之同步的动作永不否证它。这是随机化在这里的结构形式。
- 以 P49 的识为读法：经所识者的实验，恰在展开经所识者分解之处是对的；阈下与所及之外的不见，是不分解的情形。
- 合于 Ren 的 理：理 作为对识负责的模型（§70），在这里是投影；它使一次场合代表一类，又可被变动否证。

**作者反审。**
1. **确定性是比较的类，不是对世界的假设。** “固定”说的是：在一切容许记录的确定过程中，结果只有一个。实际过程不确定时，取过的动作在下一次场合也不必给出同样的结果；那时连 `fixes_of_takes` 所固定的也只是关于确定模型的。随机过程没有陈述。
2. **“未取的不被固定”要两个配置和确定的实际过程。** 两者都是局部条件，写在定理中。
3. **配置的相等是全配置的相等。** 实际展开中全配置几乎不返回（`keepHistory_new` 是极端情形），所以正面的结果实际上都经投影；投影本身由运行之外给出，模型从哪里来不推出。
4. **实验者没有在流与网中表示。** 模块在过程层面陈述，形成的“动作”是过程的动作；与 `Becoming.Testing` 的识（经支持与观察的阈值）之间的形式桥接，即以识为投影，没有陈述，是读法。
5. **不是 `Becoming.Joint` 的重证。** Joint 问一个部分是否造成差别，是关于过程的主张；这里问记录在何处固定这样的主张。两者相接，而不重叠。
6. **见证是最小的。** `Confound` 只有一个隐藏位；更一般的形式，即动作与隐藏者的何种相关使模型永不被否证，没有陈述。

**检查。**
- 模块在暂存区对 main 的核心编译，没有错误或警告；逐条审计全部 78 个常量，公理报告全部为空。`by decide` 只用于自然数字面量的比较。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T101806.880391Z。`Becoming.Experiment` 的 25 项定理全部空依赖；包共 2344 项定理、3509 项声明审计，核心闭包 46 个模块。外围桥接对这个核心重查，通过：回执 20261011T105433.502229Z。
- 按 Ren 的“no extra review needed”，不作独立审查。

## 73. 失控：经自身之识的回路所不能识的（P55）

2026-10-11。Ren 最初问的是“wisdoms to avoid run away feedbacks”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-wisdom-from-registration.md)）。P49 把失控读作在一种不见之中运行的回路，并说这是启发，不是陈述（§70）。P53 之后，AI 提议在策略的层面陈述失控问题，Ren 答：“no extra review needed, merge, then continue”。本节是统一计划 P55。它不加公理，只在被识的条件上逐步假设平衡，属于第一部分。核心新增模块 `Becoming.Runaway`，13 项定理，导入 `Becoming.Testing`，不改任何已有模块。

成果记录新增一项：[runaway-distance-unregistered](../../../../theories/becoming/results/records/runaway-distance-uncoupled.md)。

```text
Result(s): 复用 subthreshold-registration（Flow.ExchangeFollows、Flow.subthreshold_alike_always、
           Flow.difference_changes_after_divergence）、testing-within-registration（Web.RegistersAlike、Web.Registers、
           Web.observed_level_registers）、laws-of-one-step（Flow.BalancesOn、Flow.Balances.on）；新增上列一项
Delta: 策略：Flow.PolicyThrough、Flow.OthersFixed、Flow.exchangeFollows_of_policy、Flow.policy_keeps_difference、
       Flow.policy_uses_after_failure。断裂的距离：Web.raise、Web.le_raise、Web.Supported.raise、Web.raise_other、
       Web.registersAlike_raise、Web.observed_raise_registers、Web.needUpTo、Web.need_le_needUpTo、Web.Dependent.raise、
       Web.break_not_bounded、Flow.BalancesOn.raise。实例：SupportDrawn.break_unregistered
Supplied premises / correspondence: 不加公理；平衡只在被识的条件上逐步假设；策略经识与其余固定是给出的假设
       （PolicyThrough、OthersFixed），由它们推出 ExchangeFollows；离散的步、自然数的量；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T101806.880391Z（Becoming.Runaway 13 项定理，全部源声明公理报告为空），外围回执 20261011T105433.502229Z
Boundary: 形成汲取多于更新、想要保持支持、形成策略都不推出；他者回应什么是给出的；回路与增益没有定义，失控的读法仍是读法，
          这里给的是它所依的两条定理；不含伦理谓词
Integration: 计划 P55；把 P49 失控读法所依的两点陈述为定理：对每个经识的策略（T5 的策略形式），以及断裂的距离不被识
```

| 声明 | 内容 |
|---|---|
| `Flow.PolicyThrough`、`Flow.OthersFixed`、`Flow.exchangeFollows_of_policy` | 形成的策略经其识：凡它直到某步识得相同，它在所识条件上的取用与给予在两个流中相同；其余形成在这些条件上的交换固定；两者合起来就是交换随识（`Flow.ExchangeFollows`） |
| `Flow.policy_keeps_difference` | 对每个经识的策略，其余固定：起始只在形成依存而不观察的储量上不同、第二个网中高 d，第一个网每步都支持它时，储量每步都高 d，形成每步都识得相同：保持支持的策略永不动用较多的储量 |
| `Flow.policy_uses_after_failure` | 对每个经识的策略，其余固定：所识条件上的差别在某步之前已改变，第一个网就并非此前每步都支持形成 |
| `Web.raise`、`Web.le_raise`、`Web.Supported.raise`、`Web.raise_other`、`Flow.BalancesOn.raise`、`Web.Dependent.raise` | 把储量每步抬高 d、其余不变的网；它不低于原网，支持原网所支持的，在别的条件上相同；流在一个家族上平衡，在抬高的网上也平衡；原网依存之处，抬高的网也依存 |
| `Web.registersAlike_raise` | 在网支持形成的每一步，对形成不观察的储量的抬高，形成识得相同 |
| `Web.needUpTo`、`Web.need_le_needUpTo`、`Web.break_not_bounded` | 断裂没有被识的界：形成不观察储量，且到某一视界为止只有这个储量的所需可能不满足时，有一个抬高，在原网支持形成的每一步都识得相同，并在视界之前每步都支持它。所以断裂之前，形成所识的什么都不界定断裂还有多远 |
| `Web.observed_raise_registers` | 观察储量时，任何正的抬高每步都被识 |
| `SupportDrawn.break_unregistered` | 实例：较低的网在第三步不支持形成；一个抬高在原网支持形成的每一步识得相同，在第三步支持它，流在其上平衡 |

**它回答了什么。**
- **T5 的策略形式。** 计划的 T5 问：只经支持的策略能否在较低的世界保持支持、又在较高的世界用上较多的储量。对每个经识的策略，在其余固定之下，答案是否定的：保持支持就永不动用较多的储量（`Flow.policy_keeps_difference`），动用了就已在较低的世界失去支持（`Flow.policy_uses_after_failure`）。观察储量的策略可以两者兼得（`Gauged`，§70）。
- **断裂的距离不被识。** 断裂之前，对每一个视界，都有一个储量多到撑过那个视界的世界，与实际在形成所识的一切上相同（`Web.break_not_bounded`）。所以经支持的反馈不仅在断裂之前不变，而且不给断裂还有多远的任何界。
- **量度给出它。** 观察储量，任何差别立刻被识（`Web.observed_raise_registers`）。

**读法（AI 的，待 Ren）。**
- 失控是这样的回路：断裂之前，它自身之识与储量多出任意多的世界相同。它的策略再精巧，也不能用上它所不识的。
- 要避免失控而又不放弃所有的，形成需要识储量的东西（量度），或储量的模型（理，对识负责的模型），或识它的另一个形成（§70）；要知道自己的动作造成什么，需要返回与关于何者无关的模型（P53）。
- 合于 Ren 4 日的话：理 须调节 心，使其正反馈循环不失控（「不能让正反馈循环失控」）。这里 心 的回路经支持而识，理 是识储量或其模型的那一部分。

**作者反审。**
1. **增量小而确切。** `policy_keeps_difference` 与 `policy_uses_after_failure` 是 P49 阈下定理的推论，增量是策略的层面：经识的策略加其余固定推出交换随识。实质的新陈述是 `break_not_bounded`：对每个视界的量化。
2. **其余固定是强的假设。** 他者若回应储量本身，较高的储量可以先终结形成（`Attracting`，§70）；那时 T5 的策略形式不成立。
3. **抬高的世界用同一个流。** 断裂之后，实际与抬高的世界识不同，同一个流在抬高的世界里仍是一个平衡的展开，但不必是形成所会做的；定理只说断裂之前的识。
4. **回路没有定义。** 失控仍是读法；这里陈述的是它所依的两点。定义回路（水平影响取用、取用又影响水平的闭合）并陈述失控本身，是下一步。
5. **“只有这个储量可能不满足”是局部条件。** 写在定理中；别的所需若也失败，抬高这个储量不足以撑过视界。

**检查。**
- 模块在暂存区对 main 的核心编译，没有错误或警告；逐条审计全部常量，公理报告全部为空。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T101806.880391Z。`Becoming.Runaway` 的 13 项定理全部空依赖；包共 2344 项定理、3509 项声明审计，核心闭包 46 个模块。外围桥接对这个核心重查，通过：回执 20261011T105433.502229Z。
- 按 Ren 的“no extra review needed”，不作独立审查。

## 74. 静止、开放与补给的规律，条件在规律之内（P57）

2026-10-11。按 Ren 的转向（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)）与“一起先完成一个统一的理论”的指示（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-one-unified-theory-together.md)），把零前提计划 §1.3 的 B 组（静止与开放）中 §66 没有覆盖的规律对每个世界重述：证明用到的平衡、耗散与下降写在规律之内，只在用到它的一步、一段或某步以后各步，只在用到它的家族上。不推出任何前提；原定理名称与陈述不变，在原处改为推论重证。本节由“0 axiom completeness”会话起草并验证，按[工作板](../../../BECOMING-WORKBOARD.md)认领；接口的两处安排由整合者决定（10-11）。

```text
Result(s): 修订 no-finite-part-bears-taking、rising-and-falling-in-one-exchange、generation-is-replenishment、
           unceasing-generation-needs-renewal、more-needs-renewers、continuing-self-fed-from-beyond、
           own-count-misses-joint-excess、continued-change-needs-openness（局部规律加入证明引用；下一步以确切重述开头）；
           引用迁移的记录：laws-of-one-step 及列出迁移引理的其他记录
Delta: 迁移（名称、陈述、证明不变）：Flow.BalancesOn、Balances.on、balances_iff_on、BalancesOn.over、
       BalancesOn.rise_given、fall_taken、rises_iff_gives、lt_iff_pos 自 Locality 移入 Flow；
       BalancesOn.runs_down、taking_lowers、fall_lowers、rise_lowers、comes_from_standing、DissipatesOn.still_untaken
       移入 Dissipation；came_between 移入 Population。
       新的局部规律：
       Flow：accumulates_on、uptake_needs_replenishment_from、replenishment_recurs_from、renewing_recurs_from、
       BalancesOn.standing_given、BalancesOn.rise_replenishes、rising_needs_replenishment_from、
       standing_needs_replenishment_from、replenished_over_on、renewers_over_on、More.replenishment_unbounded_from、
       More.renewers_unbounded_from；
       Dissipation：takers_within_on、taking_ceases_from、taking_ceases_within、dissipatesOn_of_inward_at、
       taking_draws_in_from、rising_ceases_from、standing_ceases_from、rising_draws_in_from、BalancesOn.falls_cover、
       BalancesOn.falls_of_taking、depletes_at、BalancesOn.rise_with_fall、BalancesOn.rise_exchange；
       Population：Flow.takers_le_covering、More.grows_covering、More.unceasing_covering；
       Roles：Web.Embodied.given_of_arises_at、replenishes_at、arising_lowers_at、arising_with_fall_at、
       generation_needs_replenishment_from、generation_ceases_from、generation_draws_in_from；
       Continuation：Flow.fed_from_beyond_from、rising_fed_from_beyond_from、joint_keeps_at；
       Openness：Flow.stills_from、exchanges_finitely_from、World.arising_stops_from。
       推论改证（名称与陈述不变）：上列各局部规律所对应的原定理，以及 Flow.Balances.runs_down、Balances.rise_given、
       Balances.fall_taken、rise_lowers_on（经迁移的引理）
Supplied premises / correspondence: 无；不改任何定义；迁移是把共享的引理放到需要它的最低模块，不是重新奠基，也不是新概念
Evidence: 合并检查器回执 20261011T122250.993495Z（2402 项定理、3568 项声明审计，全部源声明公理报告为空；核心闭包 46 个模块，包 44 个），
          外围回执 20261011T143738.711009Z；先在暂存树中（main 加 P50）从前导编译，自 Becoming.Flow 以下各模块无错误、无警告，
          改动模块逐条公理报告为空
Boundary: 闭合的选择形式（Dissipative.opens、More.opens、opens_of_arising、finite_ceases、rising_opens 等）仍以闭合给出
          耗散；它们的局部内容是相应的 _from 规律；尚无独立审查
Integration: 记录；零前提计划 §1.3 B 组；Locality 模块说明（哪些规律住在更低的模块）；工作板
```

**接口：共享引理放到需要它的最低模块。** 一步的平衡（`Flow.BalancesOn`）原在 `Becoming.Locality`，而 `Becoming.Flow` 与 `Becoming.Dissipation` 在它之下，所以那里的规律不能用它，§66 只得在 Locality 重证 `BalancesOn.runs_down` 等，与 Dissipation 的全局形式重复。按整合者的决定，平衡在一步及一个条件上的引理（`BalancesOn`、`Balances.on`、`balances_iff_on`、`BalancesOn.over`、`rise_given`、`fall_taken`、`rises_iff_gives`、`lt_iff_pos`）移入 Flow；家族在平衡与耗散下降低的引理（`runs_down`、`taking_lowers`、`fall_lowers`、`rise_lowers`、`comes_from_standing`、`still_untaken`）移入 Dissipation；`came_between` 移入 Population。名称、陈述与证明都不变，Locality 的规律照旧使用这些名称；Flow 与 Dissipation 的全局形式（`Balances.runs_down`、`rise_given`、`fall_taken`、`rise_lowers_on`）改为它们的推论，重复的证明消去。这是迁移，不是重新奠基，也不是新概念；Locality 的模块说明写明哪些规律住在更低的模块。

**有限的部分承担不了取用。** 一段之内每步平衡与耗散，取用者的数目不多于段首的存量（`takers_within_on`）；从某步起平衡与耗散，取用不复现（`taking_ceases_from`）；只要包含它的家族从某步起平衡与耗散（`taking_ceases_within`）。闭合只经它给出的耗散进入：`Dissipative.opens` 是推论。某步上闭合的家族都被耗散时，被围住而无外来者的家族被耗散（`dissipatesOn_of_inward_at`）；从某步起如此，取用的复现就向外汲取（`taking_draws_in_from`）。

**一次交换中的升与降。** 一步上家族平衡与耗散，下降至少与上升一样多，每个取用者再多一（`BalancesOn.falls_cover`）；有取用就有成员下降（`BalancesOn.falls_of_taking`、`depletes_at`）；一个成员上升就有另一个下降（`BalancesOn.rise_with_fall`）；给予与取用者只在该步活跃时，读于形成（`BalancesOn.rise_exchange`）。

**生成即补给。** 平衡在一步、一个条件上时，开始立着的条件至少被给予它新的立着（`BalancesOn.standing_given`），上升补给家族（`BalancesOn.rise_replenishes`）；从某步起平衡时，上升或开始立着的复现需要补给在那以后发生（`rising_needs_replenishment_from`、`standing_needs_replenishment_from`）；从某步起平衡与耗散时，上升与开始立着不复现（`rising_ceases_from`、`standing_ceases_from`），被围住时向外汲取（`rising_draws_in_from`）。读于体现的生起：`Web.Embodied.given_of_arises_at`、`replenishes_at`、`arising_lowers_at`、`arising_with_fall_at`、`generation_needs_replenishment_from`、`generation_ceases_from`、`generation_draws_in_from`。

**不止的生成需要更新。** 从某步起平衡时，取用的复现需要补给在那以后（`uptake_needs_replenishment_from`）；于是取用着生起的形成的复现需要补给与更新者（`replenishment_recurs_from`、`renewing_recurs_from`）。

**更多需要更新者。** 一段之内每步平衡，存量的平衡在这一段上成立（`accumulates_on`）；于是在段内，补给与更新者至少与取用者成比例（`replenished_over_on`、`renewers_over_on`）；从某步起平衡，更多不止需要无界的补给与更新者（`More.replenishment_unbounded_from`、`More.renewers_unbounded_from`）。更多导致生成不止，不需要普查：只要在任意晚的步上有覆盖活跃者的列表，从某步起参与者各列一次、取用者活跃，较晚的取用者中就有一个不在较早的覆盖列表上，它在其间开始活跃（`More.unceasing_covering`，经 `takers_le_covering`、`More.grows_covering`；条件与 §66 规律 2 的覆盖列表相同）。

**持续的家族由外部供给；联合不超出时水平不降。** 从某步起家族平衡、被围住、每步闭合的家族被耗散，持续取用或上升的家族不能从某步起无外来供给（`fed_from_beyond_from`、`rising_fed_from_beyond_from`）。一步上该条件平衡，联合取用不超出所给时水平不降（`joint_keeps_at`）。

**静止，不加前提。** 所立者有普查时，从某步起每步不被否定所立者下降，水平就不再在任意晚的步改变（`Flow.stills_from`）；闭合下降时交换也一样（`exchanges_finitely_from`）；生起者体现时，生起不复现（`World.arising_stops_from`）。这些是 §66 `change_recurs_iff` 与 `exchange_recurs_iff` 的直接推论，对流不加前提；`Flow.stills`、`exchanges_finitely` 与 `World.arising_stops` 是它们在前提给出下降时的情形。

**表示的承诺（Ren 的第 4 项）。** 可判定：`More.unceasing_covering` 判定活跃（与原定理相同），其余不判定世界的谓词；整单位：耗散的 sign 项（选项 A）照旧；时间：离散的步；有限：只用所用家族与所用各步的有限列表；`More.unceasing_covering` 把普查换成任意晚的步上的覆盖列表。

**作者反审。**

*反驳 1：迁移是否改动了已落地的成果？* 名称、陈述、证明不变；只是声明所在的模块不同。§66 与 P50 的规律引用同样的名称，照旧成立；记录的引用随之改指。迁移消去了 §66 的重复证明，所以是向统一走，不是另起。

*反驳 2：“从某步起”是不是只是把全局前提限制到尾段？* 是局部化，而且条件比限制更弱：耗散只在所用的家族上，平衡只在所用的家族上；闭合不在条件中，只经它给出的耗散进入；`More.unceasing_covering` 不要普查。复现形式的条件本来就只在尾段上起作用，把它写成“从某步起”就是它的确切位置。

*反驳 3：每条都是“Y 当且仅当 Z”吗？* 不是。确切的当且仅当在 §66（`change_recurs_iff` 等）；本节的静止规律是它们的直接推论，其余是蕴含或界：反方向一般不成立（例如补给的复现不需要取用的复现）。存量在一段上的确切形式是 `accumulates_on` 的恒等式。

*反驳 4：`dissipatesOn_of_inward_at` 的条件“该步上闭合的家族都被耗散”是不是全局耗散换了个名字？* 它只关于那一步，是耗散在那一步的局部形式；被围住而无外来者的家族的耗散由它给出。是否能只要求包围该家族的那一个封闭家族被耗散，需要从存在量词中取出它，这里没有做。

*反驳 5：选择形式为何保留闭合？* `Dissipative.opens`、`rising_opens` 等陈述的是闭合与持续取用不相容；它们的局部内容是相应的 `_from` 规律（平衡与耗散从某步起），闭合只是给出耗散的方式。

*反驳 6：这是否推出了前提？* 没有。规律对每个世界成立；前提在每一步成立时局部条件处处成立，原定理因此是推论。

**边界。** 离散步；整单位（选项 A）；`dissipatesOn_of_inward_at` 要求该步上闭合的家族都被耗散；名称（`_on`、`_from`、`_at` 后缀，`takers_le_covering`、`depletes_at`）是 AI 所选，可由整合者或 Ren 改；尚无独立审查。

## 75. 整体的规律，条件在规律之内（P60）

2026-10-11。按 Ren 的转向（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)）、“一起先完成一个统一的理论”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-one-unified-theory-together.md)）与“先把所有零公理的部分封闭起来”的指示，把零前提计划 §1.3 的 D 组（整体、前提图与逻辑）对每个世界重述。不推出任何前提；原定理名称与陈述不变，在原处改为推论重证。由“0 axiom completeness”会话起草并验证，按[工作板](../../../BECOMING-WORKBOARD.md)认领。

```text
Result(s): 修订 space-and-its-parts、coming-and-ceasing-keep-pace、map-of-premises、no-finite-part-bears-taking、
           identity-across-steps（局部规律加入证明引用；下一步以确切重述开头）
Delta: Change：Web.unceasing_iff_covering；Space：World.arising_iff_ceasing_covering、World.rests_covering；
       Premises：World.acting_across_on、World.keep_lists；Dissipation：Flow.DissipatesOn.gives_less_closed；
       Identity：Flow.More.unceasing_reidentified_covering。
       推论改证（名称与陈述不变）：Web.unceasing_iff、World.arising_iff_ceasing、World.rests、World.acting_across
       （经它 acting_of_enclosed、Finite.acting）、World.Finite.counted、Flow.Dissipative.gives_less、
       Flow.More.unceasing_reidentified
Supplied premises / correspondence: 无；不改任何定义
Evidence: 合并检查器回执 20261011T122250.993495Z（2402 项定理、3568 项声明审计，全部源声明公理报告为空；核心闭包 46 个模块，包 44 个），
          外围回执 20261011T143738.711009Z；先在暂存树中（main 加 P50 与 B 组）从前导编译，自 Becoming.Change 以下各模块无错误、无警告，
          改动模块逐条公理报告为空
Boundary: 有限世界的定律仍要判定活跃（World.law_iff_em 证明不能从此陈述中去掉）；World.lpo_of_finite_ends、
          Listed.lpo_of_few 是已证明的边界，不改；尚无独立审查
Integration: 记录；零前提计划 §1.3 D 组；工作板
```

**有限世界的定律不要有限世界。** 判定活跃时，只要一个列表从某步起覆盖活跃者，生起的复现恰当不再活跃的复现（`Web.unceasing_iff_covering`，读于世界：`World.arising_iff_ceasing_covering`）。世界在列表之外可以有无穷多关系项，某步以前也不作要求。`Web.unceasing_iff` 与 `World.arising_iff_ceasing` 是全体在一个列表上的情形。

**静止不要闭合。** 判定活跃、生起者体现时，只要从某步起活跃者都在一个家族里，并且这个家族在那些步上平衡与耗散，生起与不再活跃都不复现（`World.rests_covering`）。不要世界有限，不要闭合，不要其他家族或其他步上的前提，也不要家族无重复。`World.rests` 是全体为一个列表、前提处处成立的情形：那个列表在每一步闭合，所以被耗散。

**只有活跃者给予，在一步上。** 跨过一步，若某个家族闭合且被耗散，取用者在那一步活跃，则给予者在那一步活跃：给予需要从该家族取用（`World.acting_across_on`，经 `Flow.DissipatesOn.gives_less_closed`）。只用那一步与那一个家族。`World.acting_across`、`acting_of_enclosed` 与 `Finite.acting` 是推论。

**列出只用一步。** 判定活跃时，一个无重复、覆盖某步活跃者的列表，保留其中活跃者，就恰好列出那一步的活跃者（`World.keep_lists`）。`World.Finite.counted` 是它在每一步的情形。

**更多导致生成不止，在每个重新识别下，不要普查。** 只要任意晚的步上有覆盖活跃者的列表，从某步起参与者各列一次、取用者活跃，更多不止就使生成在每个重新识别下不止（`Flow.More.unceasing_reidentified_covering`，经 B 组的 `More.unceasing_covering`）。

**表示的承诺（Ren 的第 4 项）。** 可判定：有限世界的定律与静止要判定活跃，与原定理相同；`World.law_iff_em` 证明它不能从这一陈述中去掉，这是 b(2) 的已证边界，留待 Ren。整单位、时间、有限：同 B 组；有限只以一个覆盖列表出现。

**作者反审。**

*反驳 1：“一个列表从某步起覆盖活跃者”是否只是有限世界换了个说法？* 不是。有限世界要求所有关系项在一个列表上；这里只要求从某步起活跃的关系项在一个列表上，其余关系项可以无穷多，某步以前的活跃也不受限。

*反驳 2：静止为何不要闭合？* 闭合在原证明中只用来给出那个家族上的耗散。直接要求家族上的平衡与耗散，闭合就不需要。

*反驳 3：`acting_across_on` 与 `acting_across` 的条件差在哪里？* 原定理要求处处取用者活跃、处处耗散；局部规律只要该步上取用者活跃、一个闭合家族在该步被耗散。

*反驳 4：判定活跃能否去掉？* 不能，对这一陈述已证（`World.law_iff_em`）；这是表示的承诺，不是此处的遗漏。

*反驳 5：这是否推出了前提？* 没有。规律对每个世界成立；前提处处成立时局部条件成立，原定理因此是推论。

**边界。** 离散步；判定活跃；已证的边界（`law_iff_em`、`lpo_of_finite_ends`、`Listed.lpo_of_few`）不变；名称（`_covering`、`_on`、`keep_lists`、`gives_less_closed`）是 AI 所选；尚无独立审查。

## 76. 延续之下的普查定律，只用一个覆盖列表（P61）

2026-10-11。§71 留下的开放点（[工作板](../../../BECOMING-WORKBOARD.md)，整合者 10-11 提出）：延续之下的复现定律能否像 §66 的规律 2 一样，只用任意晚的步上的覆盖列表，而不是从某步起的列出？本节回答生起一侧：能，而且只用一个覆盖列表，不用普查，不用判定。由“0 axiom completeness”会话起草并验证。

```text
Result(s): 修订 census-balance-under-continuation（新增规律加入证明引用；下一步写明已回答与仍开放的部分）
Delta: Identity：Web.Lineage、Lineage.unique、Lineage.through、Lineage.ends、Lineage.back、
       ceasingFrom_found、not_not_arisingFrom_covered、arisingFrom_not_stopping_covered；
       迁移（陈述与证明不变）：not_not_all 自 Locality 移入 Population
Supplied premises / correspondence: 无；不改任何定义；原定理不变；not_not_all 移到需要它的最低模块，不是新概念
Evidence: 合并检查器回执 20261011T122250.993495Z（2402 项定理、3568 项声明审计，全部源声明公理报告为空），外围回执 20261011T143738.711009Z；
          先在暂存树中（main 加 P50、P57、P60）从前导编译，Identity 及其下游无错误、无警告，Identity 605 个常量公理报告为空
Boundary: 结论是“不被否定”与“不会停止”，不是确切的存在形式（那需要在步后列出活跃者以便搜索）；反方向未做；尚无独立审查
Integration: 记录 census-balance-under-continuation；工作板
```

**谱系。** 从第 M 步的 g 出发，经 k 步延续（每步在两端活跃的形成之间）到达的形成，是 g 的谱系在第 M + k 步的成员（`Web.Lineage`）。自 M 起不分裂时，谱系在每一步至多到达一个形成（`Lineage.unique`）；到达较晚一步的谱系，在较早一步被延续了（`Lineage.through`）；所以谱系在某步到达的形成在那里于延续之下不再存在时，谱系此后到达不了任何形成（`Lineage.ends`）。

**定律。** 一个列表覆盖第 M 步的活跃者，自 M 起不分裂，不再存在于延续之下复现，则自 M 起有形成在延续之下生起，这一点不被否定（`Web.not_not_arisingFrom_covered`）。证明：设自 M 起没有生起；则此后每个活跃的形成都不被否定地在某个列表成员的谱系上（`Lineage.back`）；每次不再存在结束一个谱系，每个谱系至多结束一次；而复现给出比列表更多的、在不同步上的不再存在（`ceasingFrom_found`），鸽巢使它们落在同一谱系上，矛盾。有限个“不被否定”合为一个（`not_not_all`，规律 2 的同一引理；Identity 在 Locality 之下看不到它，所以它从 `Becoming.Locality` 移入 `Becoming.Population`，名称、陈述与证明不变）。有任意晚的覆盖列表、自某步起不分裂时，生起不会自某步起停止（`Web.arisingFrom_not_stopping_covered`）。这是规律 2 的 `Covers.not_not_coming_from` 在延续之下的读法：不用普查，不用判定。

**作者反审。**

*反驳 1：这比 §71 的 `arisingFrom_of_ceasingFrom_from` 强还是弱？* 条件弱（一个覆盖列表对从某步起的列出；不要判定），结论也弱（“不被否定”对存在）。两者都保留：确切的存在形式需要在每步后列出活跃者才能搜索生起者。

*反驳 2：反方向呢？* 生起复现需要不再存在复现，原定理要不合并与有界；只用覆盖列表的形式这里没有做。

*反驳 3：这是否推出了前提？* 没有。规律对每个世界成立。

**边界。** 离散步；“不被否定”的结论；反方向开放；名称（`Lineage`、`not_not_arisingFrom_covered`）是 AI 所选；尚无独立审查。

**P57、P60、P61 规律中的判定改为局部（供 P58）。** 按 Ren“decidability is too dualist”与“please”（在这些规律中判定改为局部；其余计数的陈述仍以判定为表示的承诺，由 P58 清点），“0 axiom completeness”会话把 P57、P60、P61 的规律重述：先给无判定的形式，判定的形式只在证明查看的步上判定。
- 更多导致生成不止：无判定的形式是生起不会自某步起停止（`Flow.More.arising_never_stops_covering`）：自 N 起没有生起时，此后活跃的形成不被否定地在某个覆盖步 M 已活跃、故不被否定地在其列表上，而较晚一步的取用者多于该列表。存在形式 `Flow.More.unceasing_covering` 只在某步 S 以后判定活跃（`decided : ∀ s f, S ≤ s → Decidable (W.active s f)`），经只在 S 以后判定的 `came_between_from`；`came_between` 是它的推论。重新识别下同样（`Flow.More.arising_never_stops_reidentified_covering`、`unceasing_reidentified_covering`）。
- `World.keep_lists` 只在它列出的一步判定活跃。
- P61 本来不用判定。用计数陈述的普查规律（`Listed.keeps_at` 等、`Web.Census.balanceFrom_at`）与家族层面的 `coming_recurs_iff`（`Web.unceasing_iff_covering`、`World.arising_iff_ceasing_covering`、`World.rests_covering` 的不再活跃一半经它）留给 P58 的关系形式。

**反方向（P61b）。** §76 留下的反方向：生起于延续之下复现，需要不再存在复现。只用一个覆盖列表，不用普查、不用判定：一个列表从某步 T 起覆盖活跃者，自 T 起没有两个形成延续为一个，生起复现，则不再存在不会自某步起停止（`Web.ceasingFrom_not_stopping_covered`）。证明：设自 N 起没有不再存在；每次生起开始一个谱系，此后它不被否定地延续下去（`Lineage.onward`，经 `Lineage.active`）；不合并时，在同一步到达同一形成的两个谱系出自同一形成（`Lineage.origin`，经 `Lineage.split`），而较晚生起的形成不在较早生起的谱系上，否则它延续了一个活跃者（`lineages_apart`）；于是比列表更多的生起（`arisingFrom_found`）在某个较晚的步上给出比列表更多的、不同的活跃者，与鸽巢矛盾。这是 §76 的对偶：那里谱系自覆盖步向后数不再存在，这里自每次生起向前。两个方向的确切存在形式仍需在每步后列出活跃者。核心引理 `Nat.add_left_cancel` 依赖 propext，已改用本核心的 `add_right_cancel`，公理报告为空。

## 77. 第二部分中不用公理的内容移入第一部分（P54）

2026-10-11。Ren（[原话](../../../../sources/15-codex-theory-conversations/2026-10-11-part-ii-into-part-i.md)）答 P52 之后的四项决定：

按[工作板](../../../BECOMING-WORKBOARD.md)认领为 P54。改动多是文档；Lean 的一项（`g0_relevance_iff` 与 `Becoming.Significance` 说明的一行）与 P56 在同一次检查中落地（§78）。

```text
Result(s): 不新增成果；复用 one-axiom-yields-g0、ranking-under-readings 与 P52 的清点（PART-II-INVENTORY）
Delta: 章节 §6 移入第一部分：第二部分的标题与说明、第一部分的总陈述移到 §6 之后，节号与锚点不变；§6 加说明（对任何意义成立，
       公理只作为条件）；第一部分的总陈述加第四部分（评价对任何意义怎样成立）；第二部分改写为断言、断言所定下的与不定下的；
       正面相关折叠进意义；继续之间以可能性比较（AI 依 Ren 的交托决定，理由见章节 §6.12）；开篇关于公理的注释照所提议的修改，
       另有移动所需的两处最小更正；两项记录的文字更正
Supplied premises / correspondence: 无新前提；“move”“fold”的读法与比较方式的决定是 AI 的，Ren 可改
Evidence: `g0_relevance_iff` 与 P56 同一次核心检查，公理报告为空（回执见 §78）；所引其余定理都在核心回执中；分类见 P52（§69）
Boundary: 不推出公理；不改任何定义或既有定理，只新增 `g0_relevance_iff`；尚无独立审查
Integration: 章节、开篇、两项记录、计划、范围记录与指令登记；工作板 P54
```

**改了什么。**
- **结构。** 章节 §6 现属第一部分：它的定理对任何意义、任何评价成立，公理只作为条件出现（P52）。第二部分的标题与说明、第一部分的总陈述从 §6 之前移到 §6 之后；没有一节改号，没有一个标题改字，所以所有锚点保留。§6 加一段说明；第一部分的总陈述由三件事变为四件，第四件是评价对任何意义怎样成立。第二部分的说明改写为三段：断言；断言所定下的（以公理为条件的 22 条不再需要这一条件）；断言不定下的（A、C、L 与 J1–J4 仍是条件，混合部分的度量，个体化的层次，公理的根据）。第一部分的说明、一句话与完整陈述的地位词随之改写。
- **正面相关。** 正面相关就是已实现的活的内容的意义（`Frame.relevance`），不再是另一种读法；如此，G0 说每个已实现的活的主张的延续从每个立场都有意义，即公理在已实现的活的内容上的条件。前提卡、§5、§6.12 与术语表照此改写。
- **比较的方式。** 继续之间以可能性比较，理由四条写在章节 §6.12：以公理为条件时它就是公理自身的比较，不另加前提；它读 Ren 已确认的读法（可能性是接下来能形成的）；它把过度汲取者的不在场、节制与共享排在上面而不扣下事件；它从不把休息或节制排在下面。它不排的，是不增加可能性的形成的在场与不在场，即使新的生命存在的价值，章节 §6.6 不处理；可能性优先会决定它，代价是把停顿算作损失。前提卡、§6.5、§8 与术语表照此改写。
- **开篇。** Ren 同意的修改：去掉“, its adopted axiom,”，把最后一句换成“This is checked, not yet independently reviewed. G0 is no longer an axiom of its own: Part I states it as a condition the dynamics leave undecided, and in Part II it follows from this one.”。移动使两句不再成立：关于公理与关于规律的两条注释都说“No theorem of Part I … mentions significance”；改为“No law of the dynamics mentions significance”，这是保持其所说的最小改动；链接标签“Part II, section 6.8”改为“section 6.8”。这三处另向 Ren 报告。
- **记录。** one-axiom-yields-g0（正面相关已折叠）与 ranking-under-readings（比较的方式已决定）的文字更正，各加一条历史，断言与定理不变。其余记录中“第二部分的公理”的说法仍成立（断言它的是第二部分），不改。

**作者反审。**
1. **移动是否只是挪标题？** 节号、锚点与小节内容都不变，变的是地位：§6 的定理以前作为第二部分陈述，现在作为第一部分的规律陈述，公理只作为条件出现。这一地位来自 P52 的清点，不来自标题的位置。
2. **“只断言一条公理”是否过强？** 第二部分还有 §7（AI 对齐），它应用被断言的公理；A、C、L 与 J1–J4 是实践规律的条件，不被断言。所以第二部分的断言只有一条，但第二部分不止这一句：它还陈述断言所定下的与不定下的。
3. **比较的方式由 AI 决定，是否越权？** Ren 明确交给 AI（“you decide”）。决定选的是公理自身的比较，不另加前提；另两种比较的定理都保留，理由与代价写在章节 §6.12，Ren 可改。
4. **开篇的更正超出了 Ren 所同意的文字。** 是。不改，开篇就会说出不成立的话：第一部分现在有提到意义的定理。所以只作最小改动，并向 Ren 报告，Ren 可改。
5. **Lean 说明。** `Becoming.Significance` 的说明原写“No theorem of Part I mentions significance”，移动之后不再成立；改为“No law of the dynamics mentions significance”，与 `g0_relevance_iff` 一起在 P56 的同一次核心检查中检查。

**边界。** 不推出公理，不改变任何定理；本节尚未经独立审查。

## 78. 生成的空间，不用公理（P56）

2026-10-11。Ren（[原话](../../../../sources/15-codex-theory-conversations/2026-10-11-generative-space-no-axiom.md)）：

按[工作板](../../../BECOMING-WORKBOARD.md)认领为 P56。核心模块 `Becoming.Regions` 与 `Becoming.Significance` 只新增定义与定理，不改任何既有陈述；与 P54 的 Lean（§77）同一次检查。

```text
Result(s): 新增 comparison-by-widening；扩展 four-cases-of-a-part、significance-retained-within-margin、loss-beyond-a-region；
           复用 closing-needs-net-draw 的局部相界（P50）与 one-axiom-yields-g0（P39、P44）
Delta: 扩大、保持不变与混合是定义（Web.Widens、Web.Keeps、Web.Mixed），扩大单向且可传递，四种情形两两互斥；扩大的确切边界，平衡
       只在所用之处（Flow.widens_iff_within_margin_at）；保留、失去与增加的界的局部形式，原定理在原处作推论重证；在水平路径上，每个
       主张都算作活的扩展恰是扩大，所以把“更好”读作扩大，C 对 living 的每种读法成立，不用公理（Web.paths_comparison_widens）；整体的
       比较是同时在每个区域内的比较（Web.includes_iff_within_every）；以公理为条件，扩大即保留且增加，保持不变即双向保留，混合即双向增加
Supplied premises / correspondence: 无新前提；把“leads to more futures”读作扩大能形成者、把生成的空间读作部分在其中扩大之处，
       是 AI 的读法，待 Ren
Evidence: 合并检查器回执 20261011T171000.054867Z（2421 项定理、3590 项声明审计，核心闭包 46 个模块），源声明的公理报告全部为空；
          外围检查 20261011T180706.458104Z
Boundary: 混合的部分仍需度量；四种情形的穷尽用经典逻辑，不是 Lean 定理；称生成的空间为好的根据开放；尚无独立审查
Integration: 章节 §6.13，以及一句话、前提卡、§2、第一部分的总陈述、第二部分、§8、§9 与术语表；四项记录；计划；包说明；工作板 P56
```

**改了什么。**
- **生成的空间。** 一条水平路径扩大另一条，是指包含且超出它（`Web.Widens`）；两条保持不变，是指互相包含（`Web.Keeps`）；两条混合，是指互相超出（`Web.Mixed`）。有部分的水平扩大无它的水平处，部分是生成的，反过来是退化的。扩大单向且可传递；四种情形两两互斥，不用经典逻辑（`Web.Widens.not_reverse`、`Web.Widens.trans`、`Web.Widens.not_keeps`、`Web.Widens.not_mixed`、`Web.Keeps.not_mixed`，加上对称性 `Web.Keeps.symm`、`Web.Mixed.symm`）。其中不出现意义、立场或边界。
- **边界，平衡只在所用之处。** 按整合者的要求，扩大的确切边界陈述在 P50 的局部相界 `Flow.supported_iff_within_margin_at` 上，条件写在规律之内：每个形成所需的条件上、它之前的各步平衡（`Flow.widens_iff_within_margin_at`）；全局形式 `Flow.Balances.widens_iff_within_margin` 是一行推论。`Becoming.Significance` 中保留、失去与增加的三条界照此有了局部形式，各取证明所用的最窄条件：保留与失去只在无部分时接纳的有意义的延续上，增加只在无部分时不接纳的上（`Flow.retains_iff_within_margin_at`、`Flow.loses_iff_beyond_margin_at`、`Flow.adds_iff_within_margin_at`）；原定理在原处作推论重证，名称与陈述不变。
- **C 是规律。** 在水平路径上，每个主张都算作活的扩展恰是扩大（`Web.paths_extension_iff_widens`）。所以把“更好”读作扩大能形成的，C 对 `living` 的每种读法成立，不用公理（`Web.paths_comparison_widens`）；此前它要么是前提，要么在水平路径上由公理推出（`Web.paths_g0_comparison`）。
- **整体优先。** 包含恰是同时在每一步、每个区域内的接纳（`Web.includes_iff_within_every`）：区域的比较以区域为输入，整体的比较不以任何边界为输入。
- **一条公理的情形。** 以公理为条件，扩大就是保留且增加有意义者，保持不变就是双向保留，混合就是双向增加（`Web.widens_iff_retains_adds`、`Web.keeps_iff_retains`、`Web.mixed_iff_adds`）。它们放在第二部分的“断言所定下的”之下：依 Ren 的话，规则的推导不用公理，公理之下的形式是推论。

**作者反审。**
1. **扩大是否只是 P37 的包含改名？** 包含与超出是 P37 的。新的是把四种情形定义出来，证明它们两两互斥、扩大单向可传递，并给出扩大的确切边界，平衡只在所用之处。四种情形的穷尽仍用经典逻辑，不写成定理。
2. **C 成为规律，是否把比较藏进了定义？** C 说无损失且多实现一个活的内容的扩展更好。“更好”读作扩大时，它对 `living` 的每种读法成立，因为扩大恰是每个主张都算作活的扩展：规律是这一等价，不是一项选择。“更好”另作他读时，C 仍是前提；章节照此只写“读作扩大时”。
3. **生成的空间是否就是生生？** 这是 AI 的读法，列为 Ren 的选择（章节 §8）。扩大读 Ren 的“more possibilities of becoming”，Ren 已确认可能性读作接下来能形成的；“flourishes/plurality”是否都由扩大读出，待 Ren。
4. **还原是否去掉了公理的全部内容？** 没有。去掉的是公理在规则中的用处：每条规则都不用它推出。没有去掉的是“应当”，即公理的不变之步（§62）；它成为称生成的空间为好的内容，章节 §8 把它列为根据问题。

**边界。** 不推出“应当”；不为混合的部分定序；尚未经独立审查。

## 79. 储备与依存的规律，条件在规律之内（P63）

2026-10-11。整合者提出：检查零前提清点之外的第一部分模块（Return、Horizon、Joint、Substitution、Wholes、Reserve 等）是否还有可局部化的全局前提。清点（无 Lean）：Horizon、Joint、Substitution、Wholes、Renewal、Frame、Inquiry 中没有全局前提；Return 与 Generation 中出现的 `Renewed`、`Unceasing` 是所论现象的条件，不是前提；剩下的是 Reserve 的储备承载（`Carries r`，对每一步、每个形成）与 Dependence 的 `consumed_ends_when_fixed`（`Dependent`）。储备一行本在 §1.3 的 C 组（reserve-defers-ending），§71 漏做，此处补上。由“0 axiom completeness”会话起草并验证，按[工作板](../../../BECOMING-WORKBOARD.md)认领。

```text
Result(s): 修订 reserve-defers-ending、becoming-dependence-dynamics、map-of-premises
Delta: Reserve：Web.CarriesAcross、DecaysAcross（一步、一个形成上的承载与衰减；Carries、Decays 是它们在每一步、每个形成上）；
       carries_zero_across、CarriesAcross.pos、active_finitely_from、CarriesAcross.step、lasts_on、arising_finitely_from、
       decays_by_from、ends_within_from、chain_ends_from、chain_ends_of_em_from、redirect_supported_at、Flow.carriesAcross_of_held；
       Dependence：Web.consumed_ends_when_fixed_at。
       推论改证（名称与陈述不变）：carries_zero、Carries.pos、active_finitely、step、lasts、arising_finitely、decays_by、ends_within、
       consumed_lasts、coextinct_lasts、chain_ends、chain_ends_of_em、redirect_dependent、Flow.carries_of_held（经它 carries_of_own）、
       consumed_ends_when_fixed
Supplied premises / correspondence: 无；新增的两个定义是既有前提在一步、一个形成上的形式，不改既有定义
Evidence: 合并检查器回执 20261011T192152.790658Z（2568 项定理、3780 项声明审计，全部源声明公理报告为空），外围回执 20261011T192511.756300Z；先在暂存树中从前导编译，
          自 Becoming.Dependence 以下各模块无错误、无警告，改动模块逐条公理报告为空
Boundary: Carries.chain_ends_of_em 以排中律为假设，这是已证的边界，不改；lasts 的计数判定活跃（留给 P58）；尚无独立审查
Integration: 记录；零前提计划 §1.3；工作板
```

**储备只在所用的形成与步上。** 储备 r 跨过从 t 起的一步承载 f，指 f 在那里不被支持时储备不升、活跃时下降（`Web.CarriesAcross`）；衰减类似（`Web.DecaysAcross`）。`Carries r` 与 `Decays r` 是它们对每一步、每个形成成立。零储备在一步、一个形成上承载它，恰当它在那里活跃时被支持（`carries_zero_across`），所以 `Dependent` 是零储备（`carries_zero`）是它在每一处的情形。

**储备推迟终结而不逃脱，只用该形成。** 只要从某步起承载 f 且 f 不被支持，f 只活跃有限多次（`active_finitely_from`），只生起有限多次（`arising_finitely_from`）；一段之内承载且不被支持，f 在这一段活跃的次数不多于段首的储备（`lasts_on`）；承载、衰减且不被支持，n 步后储备降了 n 或耗尽（`decays_by_from`），储备过后不再活跃（`ends_within_from`）。链上的共灭只用链上各环的承载与衰减（`chain_ends_from`、`chain_ends_of_em_from`）。持有的条件只在该步、该条件上平衡时承载其持有者（`Flow.carriesAcross_of_held`），重定向的读法在承载处支持活跃的形成（`redirect_supported_at`）。

**依存。** 损失之后依存不变时，一个只在被支持时活跃的形成在那一步不活跃（`Web.consumed_ends_when_fixed_at`）。

**作者反审。**

*反驳 1：新增 CarriesAcross 是否另立平行的定义？* 不是：它就是 `Carries` 的被量化体，`Carries r` 与“∀ t f, CarriesAcross r t f”定义上相同；它让规律能只在所用的形成与步上要求储备。

*反驳 2：为何 §71 漏掉了储备？* C 组按记录逐行处理时没有覆盖 Reserve 模块；本节补上，并把清点扩到清点之外的模块。

*反驳 3：这是否推出了前提？* 没有。

**边界。** `chain_ends_of_em` 的排中律假设是已证的边界；计数的判定留给 P58；名称（`CarriesAcross`、`DecaysAcross`、`_from`、`_on`、`_at`）是 AI 所选（`Web.CarriesAt` 已被分辨率一线占用）；尚无独立审查。

## 80. 较粗的步上的一步规律（Sampling）

2026-10-11。零前提计划把离散的步列为表示的一项承诺（Ren 的第 4 项：时间）。Ren 定下顺序：“coarser steps only, or also continuous time: i let's finish one first, then another”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-one-unified-theory-together.md)）。本节完成较粗的步：把一个世界在严格递增的时刻读出，问 §66 的局部条件在粗步上是否由粗步内各细步上的条件合成。这是对表示承诺的检验，不是新的前提：规律对每个世界成立，所以对粗步读出的世界也成立；要证的只是条件是否合成。由“0 axiom completeness”会话起草并验证，按[工作板](../../../BECOMING-WORKBOARD.md)认领。

```text
Result(s): 新增 laws-at-coarser-steps
Delta: 新核心模块 Becoming.Sampling（导入 Becoming.Locality、Becoming.Premises）：Strict、span、Web.sample、Flow.sample；
       Flow.sample_taken_on、sample_given_on、BalancesOn.sample、DissipatesOn.sample、sample_closedAt_iff、RunsDownOn.sample、
       RunsDownOn.sample_of_fine、sample_changes_iff、sample_comesToStand_iff、sample_ceasesToStand_iff、sample_acting_on、
       sample_taking_on；Web.sample_dependent、sample_embodied、sample_census、sample_standingCensus、sample_arises、sample_ceases、
       Held、held_of_unit、held_of_constant；World.sample_survives、sample_rests；见证 Cancelling、Averaging、Strobe、Delay
Supplied premises / correspondence: 无；读法是严格递增的时刻，粗步之间的细步视为给定；平衡的合成要每个关系项只列出一次
Evidence: 合并检查器回执 20261011T192152.790658Z（Sampling 90 项定理；2568 项定理、3780 项声明审计，全部源声明公理报告为空；核心闭包 49 个模块，包 47 个），
          外围回执 20261011T192511.756300Z；先在暂存树中（main 加 P50、P57、P60）从前导编译，无警告，202 个常量逐条公理报告为空
Boundary: 连续时间未做；平衡的合成要只列出一次；反方向不合成；只有活跃者给予与取用依步而定；尚无独立审查
Integration: 记录 laws-at-coarser-steps；零前提计划 §1.4 与 §5；根模块与检查器的核心模块列表；工作板
```

**合成的，在一个粗步上。** 家族上的平衡合成，只要粗步内各细步每个关系项只列出一次（`Flow.BalancesOn.sample`）：粗步上一个条件的改变就是各细步取用与给予之和（`balance_over_stretch_on`、`Flow.sample_taken_on`、`Flow.sample_given_on`）。粗步的计数把一个关系项算一次，细步的计数按列出的次数，所以要只列出一次。家族上的耗散无条件合成：粗步的不等式是细步不等式之和（`Flow.DissipatesOn.sample`）。封闭恰好合成：家族跨过粗步封闭，恰当它跨过其内每个细步封闭（`Flow.sample_closedAt_iff`），因为量是自然数，和为零当且仅当各项为零。下降在家族只在粗步两端包含所立者时合成，不要中间各步（`Flow.RunsDownOn.sample`）；每个细步都下降时粗步下降（`Flow.RunsDownOn.sample_of_fine`）。

**粗步上的规律。** 于是一次交换的规律在粗步上成立：有水平改变恰当家族末端的总水平低于始端（`Flow.sample_changes_iff`）；细步上平衡时，开始立着与不再立着的确切条件在粗步上成立（`Flow.sample_comesToStand_iff`、`Flow.sample_ceasesToStand_iff`）。

**不合成回去的。** 粗步上的平衡与耗散不给出细步上的：细步上的不平衡可以相互抵消（`Cancelling.coarse_not_fine`），一个无损给予的细步可以被后来的细步抵过（`Averaging.coarse_not_fine`）。

**依步而定的。** 只有活跃者给予、只有活跃者取用不合成：Strobe 中一个关系项在每个粗步的第二个细步上活跃、给予并取用，而在两个读出时刻都不活跃（`Strobe.acting_taking_step_relative`）。它们在活动于区间内保持时合成（`Flow.sample_acting_on`、`sample_taking_on`），如每个粗步只一个细步（`Web.held_of_unit`）或活动在区间内不变（`Web.held_of_constant`）。有界的依存传递也依步而定（`Delay.transmitting_step_relative`）。

**网。** 在时刻读出的网显示那些时刻的细网（`Web.sample`），所以一步上陈述的（活动需要支持、体现、普查）在被读出的细步上陈述（`Web.sample_dependent`、`sample_embodied`、`sample_census`、`sample_standingCensus`）。活动判定时，粗步上的生起或不再活跃是其内某细步上的（`Web.sample_arises`、`Web.sample_ceases`）：粗步上的复现是细步上的复现，反之不然（`Strobe.converse_fails`）。全局读法是推论（`Flow.sample_balances`、`Flow.sample_dissipative`、`World.sample_survives`、`World.sample_rests`）。

**作者反审。**

*反驳 1：这是否把“离散的步”换成了“任意粗的步”而已，没有触及连续时间？* 是，按 Ren 的顺序先做较粗的步。连续时间另做；§5 的提议（细分的塔与外围的实数时间）待 Ren。

*反驳 2：“只列出一次”是否偷渡了一个前提？* 它是关于读法的条件：粗步的计数把一个关系项算一次。去掉它时平衡能否合成，未证，列为下一步。

*反驳 3：反方向不合成，是否说明粗步的规律弱于细步？* 规律本身对每个世界成立；不合成回去说明粗步上的条件不足以推出细步上的条件，所以细步的平衡与耗散是更细的事实，粗步读不出。这与分辨率一线互补：那里细分量的单位，这里改变步的粗细。

*反驳 4：这是否推出了前提？* 没有。

**边界。** 严格递增的时刻；粗步之间的细步视为给定；连续时间未做；名称（Strict、span、sample、Held、Strobe、Cancelling、Averaging、Delay）是 AI 所选；尚无独立审查。

## 81. 较细的单位上的一步规律（Units）

2026-10-11。零前提计划把整单位列为表示的一项承诺（Ren 的第 4 项），问各条规律在超出整单位的量下是否成立。本节对 §66 的一步的规律作这一检验：把单位读为跨过每一步分成 r t 个较细的单位（`Becoming.Resolution` 的 `Flow.BalancesAt`），平衡局部到一个家族与一步，变化按单位读出。这是对表示承诺的检验，不是新的前提，也不改 `Becoming.Resolution` 的任何定义。由“0 axiom completeness”会话起草并验证，按[工作板](../../../BECOMING-WORKBOARD.md)认领（原先留给分辨率一线，该会话已不在）。

```text
Result(s): 新增 laws-at-finer-units
Delta: 新核心模块 Becoming.Units（导入 Becoming.Resolution）：Flow.BalancesAtOn、BalancesAt.on、balancesAtOn_one、BalancesAtOn.over、
       BalancesAtOn.lowers；Web.RisesAt、FallsAt、risesAt_one、fallsAt_one；Flow.BalancesAtOn.comesToStand_iff、ceasesToStand_iff、
       rise_given、fall_taken、rises_iff_gives、taking_lowers、fall_lowers、rise_lowers、comes_from_standing、arises_given；
       Flow.DissipatesOn.still_untaken_at；Flow.risesAt_of_comesToStand；Flow.RunsDownOnAt、runsDownOnAt_one、RunsDownOnAt.changes_iff；
       见证 Doubling（raw_reading_fails）；所需按单位读：unitFactor、unitFactor_one、Web.supported_unchanged_by_split、continuing_restores_in_unit、consumed_continues_transformed_in_unit、inactive_below_in_unit、Flow.BalancesAtOn.rise_given_by_supported；见证 Feeding（endless）
Supplied premises / correspondence: 无；不对细分 r 加任何条件；变化按单位读出是表示的承诺
Evidence: 合并检查器回执 20261011T192152.790658Z（Units 31 项定理；2568 项定理、3780 项声明审计，全部源声明公理报告为空；核心闭包 49 个模块，包 47 个），
          外围回执 20261011T192511.756300Z；先在暂存树中从前导编译，无警告，71 个常量逐条公理报告为空
Boundary: 规律 1 的复现与规律 3 的界引用 R4，不重证；一段上数损失的依存规律要把细分算作给予（Feeding）；尚无独立审查
Integration: 记录 laws-at-finer-units；零前提计划 §2 的第 4 步；根模块与检查器的核心模块列表；工作板
```

**变化按单位读出。** 跨过一步单位分成 r t 时，条件上升指步后的水平超过 r t 乘以步前的水平（`Web.RisesAt`），下降反之（`Web.FallsAt`）；r 恒为一时即原来的上升与下降（`Web.risesAt_one`、`Web.fallsAt_one`），平衡与下降也一样（`Flow.balancesAtOn_one`、`Flow.runsDownOnAt_one`）。

**在每一分辨率下成立的。** 不对 r 加任何条件。开始立着与不再立着与单位无关：零在每个单位里都是零。一个条件在该分辨率下平衡时，开始立着恰当此前立在零且被给的多于被取的（`Flow.BalancesAtOn.comesToStand_iff`），不再立着恰当此前立着且被取的等于它按较细单位所有的连同被给的（`ceasesToStand_iff`）。按单位的上升被给予、下降被取用（`rise_given`、`fall_taken`）；没有从家族取用时，成员按单位上升恰当有参与者给予它（`rises_iff_gives`），家族上的耗散排除这一点（`Flow.DissipatesOn.still_untaken_at`）。体现的关系项只由一个不是它自己的活跃给予者生起（`arises_given`）；没有什么从无中开始立着（`comes_from_standing`，经 `risesAt_of_comesToStand`：开始立着在每个单位里都是上升）。这就是规律 4 在每一分辨率下的形式。

**一次交换，按单位。** 家族不重复地包含所立者、在该分辨率下平衡并被耗散时（`Flow.RunsDownOnAt`），有条件按单位上升或下降，恰当家族步后的总水平低于 r t 乘以步前的总水平（`Flow.RunsDownOnAt.changes_iff`）。

**按原始计数读出不成立，这是表示的承诺。** 单位一分为二、什么都不交换时，每个水平加倍：原始计数下处处上升，而按单位没有变化、总水平不降（`Doubling.raw_reading_fails`）。所以一次交换的规律是按单位量度的变化的规律：变化须按单位量度，这是表示的一项承诺（如何量度变化），不是规律的失效。

**引用，不重证。** 规律 2 关于成立与否，不关于量，按原样成立。规律 1 的复现与规律 3 的界用固定单位中的最小差异：细分供给所立者处它们不成立（`Becoming.Resolution` 的见证，`refinement_feeds_witnesses`）；把细分算作给予时成立（`World.rests_refinement_counted`、`World.arising_opens_refinement_counted`，R4），单位自某步起固定时也成立（`Flow.taking_stops`）。

**所需按单位读（Ren 2026-10-12 的决定，[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-unit-of-need-and-tower-of-time.md)）。** 在较细的单位下，所需按与水平相同的单位计：细分时不变的所需随之放大，条件是 r t > 0。于是支持不随量度的粗细而变：要求不变、所需与所需的水平都按较细单位读出的形成，步后被支持恰当步前被支持（`Web.supported_unchanged_by_split`）。跨步比较所需时按单位因子读出（`unitFactor`；`continuing_restores_in_unit`、`consumed_continues_transformed_in_unit`、`inactive_below_in_unit`），r 恒为一时因子为一（`unitFactor_one`）。按单位的上升由被支持者给予（`Flow.BalancesAtOn.rise_given_by_supported`）。

**一段上数损失要固定单位。** 单位每步加倍、没有给予者时，一个形成每步取一个较细单位，永远活跃且被支持，流在该分辨率下平衡并被耗散（`Feeding.endless`）：固定单位下无供给的消耗至多持续水平那么多步（`Flow.Balances.unfed_consumption_ends`），这里细分供给了它，把细分算作给予（`Flow.withRefinement`）时细分就是供给者。储备同样：在细分下由细分供给时可永远下降（`Becoming.Resolution` 的 `Web.CarriesIn`）。这与 R4 对静止的结论一致。

**作者反审。**

*反驳 1：变化按单位读出，是否把结论放进了定义？* 定义只说“上升”比较的是同一单位中的量；r 恒为一时就是原来的定义。Doubling 说明不这样读时规律不成立，所以这是承诺，要明说，而不是隐藏的选择。

*反驳 2：为何不重证复现与界？* R4 已证，且证明依赖细分是否算作给予；重证只会重复。本节只补一步的规律。

*反驳 3：r t = 0 怎样？* 不加条件；r t = 0 时步前的水平按较细单位计为零，各当且仅当仍成立（零情形下开始立着就是从零上升）。

*反驳 4：这是否推出了前提？* 没有。

**边界。** 离散步；所需按单位读（条件 r t > 0）；与较粗的步合并的检验未做；名称（BalancesAtOn、RisesAt、FallsAt、RunsDownOnAt、Doubling）是 AI 所选；尚无独立审查。

## 82. 时间之塔：连续时间作为越来越细的离散读法（Tower）

2026-10-12。Ren 决定（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-unit-of-need-and-tower-of-time.md)）：连续时间在核心中构造为由 `Becoming.Sampling` 相连的、越来越细的离散读法之塔，连续时间的规律即塔的每一层上的规律，实数时间以后作为外围的对应。本节给出塔与它的第一条规律。由“0 axiom completeness”会话起草并验证，按[工作板](../../../BECOMING-WORKBOARD.md)认领。

```text
Result(s): 新增 continuous-time-as-tower
Delta: 新核心模块 Becoming.Tower（导入 Becoming.Sampling）：Tower、Tower.reads、web_zero、level_zero、reads_strict、balances_coarser、
       dissipative_coarser、changes_within
Supplied premises / correspondence: 无；时间为由读出相连的一族离散读法（Ren 的决定）；核心不取实数
Evidence: 合并检查器回执 20261011T192152.790658Z（Tower 6 项定理；2568 项定理、3780 项声明审计，全部源声明公理报告为空），外围回执 20261011T192511.756300Z；
          先在暂存树中从前导编译，无警告，33 个常量逐条公理报告为空
Boundary: 界要所立者在各细步下降（Strobe）；实数时间、没有最粗一层的塔未做；尚无独立审查
Integration: 记录 continuous-time-as-tower；零前提计划 §5；根模块与检查器的核心模块列表；工作板
```

**塔。** 每一层有一个网与一个流；第 n 层是第 n+1 层在严格递增的时刻读出（`Tower`）。最粗一层的步 s 是第 n 层的 `reads n s`，最粗一层就是第 n 层在这些时刻读出（`Tower.web_zero`、`Tower.level_zero`），这些时刻严格递增（`Tower.reads_strict`）。

**每一层上的规律。** 每个关系项只列出一次的平衡、耗散由更细一层传到更粗一层（`Tower.balances_coarser`、`Tower.dissipative_coarser`），这就是 Sampling 在一个粗步上的合成。

**分得再细，变化也有界。** 最粗一层从 S 起 N 步的一段在任何一层 n 读出：第 n 层有所立者的普查，所立者在其中各细步不被否定地下降时，总水平下降的细步（即有水平改变的步）不多于最粗一层在 S 的总水平（`Tower.changes_within`）。界与 n 无关：把时间分得更细不增加变化。依据是一步的规律（`Flow.runsDown_bounds_change`）与每次交换的最小损失，不加前提。

**作者反审。**

*反驳 1：这是否只是把 §66 的界搬到另一层？* 内容是界与层无关：同一个最粗的数界住每一层的变化。这是连续时间所需的“有限的一段只有有限多变化”在塔中的形式。

*反驳 2：界要下降，是否把结论放进了条件？* 下降是该层上关于所立者的局部条件，与 §66 相同；不下降时更细的一层可显示无界的变化（`Strobe.converse_fails`），所以条件是必要的边界。

*反驳 3：为何不取实数？* 实数依赖经典公理，核心须从前导编译且公理报告为空；按 Ren 的决定，实数时间以后作为外围对应。

**边界。** 离散的层；界要下降与普查；没有最粗一层的塔、界随层细化的确切形式、实数时间未做；名称（Tower、reads、refine）是 AI 所选；尚无独立审查。

## 83. 无明的边界条件：寻求何处能静止于够（P62）

2026-10-10，Ren 把争当“支配一切的最大者”称为哺乳动物的：“the seeking system got locked in, what they are pursuing is illusion(in south asia and Buddhism)”，并要求“find the boundary condition for 无明”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-10-truth-exists-opening.md#nature-nurture-and-无明)；[计划](../history/root-foundation/WUMING-BOUNDARY-PLAN.md)）。2026-10-11，P49、P53、P55 落地之后，Ren 答：“yes let's do 无明”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-wisdom-from-registration.md)）。Ren 随后答“b5”。本节是统一计划 P62。它不加公理，属于第一部分。核心新增两个模块：`Becoming.Seeking`（L3），13 项定理，导入 `Becoming.Locality` 与 `Becoming.Recurrence`；`Becoming.Capture`（L3），11 项定理，导入 `Becoming.Evolution`、`Becoming.Locality` 与 `Becoming.Recurrence`；都不改任何已有模块。计划的 B1、B2 与 B5 在这里陈述；B3 与 B4 已是脊柱上的定理（P49、P53、P55），在这里读出，不重述。

成果记录新增两项：[seeking-boundary](../../../../theories/becoming/results/records/seeking-boundary.md) 与 [target-capture](../../../../theories/becoming/results/records/target-capture.md)；[evolution-on-descent](../../../../theories/becoming/results/records/evolution-on-descent.md) 由 target-capture 推进（它未陈述的选择项），断言不变。

```text
Result(s): 复用 recurrence-without-premise（Law.orbit、orbit_add、gap_of_lt、gap_of_le、unlisted_of_new、Law.succ_open）、
           laws-of-one-step（Web.StandingCensus、Flow.RunsDown、Flow.change_recurs_iff）；B3、B4 读自
           closing-needs-net-draw、subthreshold-registration、runaway-distance-unregistered、testing-within-registration、
           experiment-needs-return；evolution-on-descent（offspring、Flow.DescendsAt、Web.ComesToStand.rises）；新增上列两项
Delta: B1：MoreThanNow、RestsAt、more_not_at_rest、more_rises、more_new、more_needs_open、succ_more、AboveAll、aboveAll_unique、
       aboveAll_not_two、Law.fixed_rests、Law.rests_iff、Law.more_never_rests、Law.aboveAll_never_rests。
       B2：Flow.more_needs_unrun、Flow.more_exhausted。B5：mul_assoc_nat、offspringCount、le_offspringCount、offspringCount_le、
       share_not_lower、share_rises、Flow.descent_needs_unrun、Flow.descent_exhausted、Law.reform_reabsorbed、Captured（next、
       byRule、state_reform_returns、rule_reform_changes）
Supplied premises / correspondence: 不加公理；目标是配置上的任一条件，目标怎样形成没有建模；rests_iff 设律确定（next）；B2 设所立者
       每步被列出（Web.StandingCensus），这是写在定理中的局部条件；离散的步；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T194804.708104Z（Becoming.Seeking 13 项、Becoming.Capture 11 项定理，全部源声明公理报告为空），外围回执 20261011T195216.607072Z
Boundary: 目标怎样形成、怎样修正，寻求者追求它，实际形成持有哪些目标，都不推出；多取者留下更多后代、后代带着亲代的目标、胜者塑造规则，都是给出的，不推出；
          不含伦理谓词；支配本身不在所排除者之内
Integration: 计划 P62（无明边界计划的 B1、B2、B5；B3、B4 读自 P49、P53、P55）；把 Becoming.Recurrence 的开放与 Becoming.Locality
             的静止律读到寻求上；推进 evolution-on-descent（二值目标的选择项）
```

| 声明 | 内容 |
|---|---|
| `MoreThanNow`、`RestsAt`、`more_not_at_rest` | “比现在更多”：自身的一个量跨过一步上升；静止：配置跨过一步不变；“比现在更多”只由变化满足 |
| `more_rises`、`more_new`、`more_needs_open`、`succ_more` | 每步都满足“比现在更多”，任意两个较晚的步之间量都上升，所以每个配置都是新的，没有列表容纳它们，需要开放的世界（`unlisted_of_new` 的实例）；往上数满足它 |
| `AboveAll`、`aboveAll_unique`、`aboveAll_not_two` | “高于一切他者”：其他每个寻求者的量都低于自己的；在一个状态至多被一个寻求者满足，所以两个从不同时满足 |
| `Law.fixed_rests`、`Law.rests_iff` | 在律所不变的状态满足的目标，此后每步都在静止中满足；在确定的律之下，寻求恰在到达律所不变、满足其目标的状态时，从某步起带着满足的目标静止：够的边界 |
| `Law.more_never_rests`、`Law.aboveAll_never_rests` | 在任何律之下，轨道静止的一步不满足“比现在更多”；没有律所不变的状态对两个寻求者都满足“高于一切他者” |
| `Flow.more_needs_unrun` | 所立者每步被列出时，在任意晚处上升的条件，需要在任意晚处有所立者不衰减的步：从其外汲取，或不耗散的交换 |
| `Flow.more_exhausted` | 所立者每步被列出、从某步起每步衰减时，没有条件在任意晚处上升：追逐因耗尽而止，不是因到达够 |
| `offspringCount`、`le_offspringCount`、`offspringCount_le`、`mul_assoc_nat` | 一个亲代家族的后代计数；每个亲代至少（至多）留下若干后代时家族的界；自然数乘法结合律的递归证明（前导的 `Nat.mul_assoc` 用 `propext`） |
| `share_not_lower`、`share_rises` | 带着目标的亲代各留下不少于 a 个后代、其他亲代各至多 b 个、b ≤ a 时，它们的后代与其他后代之比不低于它们与其他亲代之比；b < a 且两类都在时严格更高。后代带着亲代的目标时（传递，前提），这就是目标在后代中的份额不低于、高于它在亲代中的份额：`Becoming.Evolution` 未陈述的选择项，对二值目标 |
| `Flow.descent_needs_unrun`、`Flow.descent_exhausted` | 世系是一次开始而立，即一次上升；所立者被列出时，任意晚的世系需要所立者不衰减的步；从某步起每步衰减时世系不再复现，选择停止 |
| `Law.reform_reabsorbed`、`Captured` | 下一配置取决于规则而不取决于状态时，规则相同的两个配置从下一步起轨道相同：只改状态被重新吸收；`Captured` 中状态随规则、规则保持自身，改过的状态立即回来，改过的规则改变结果 |

**它回答了什么。**
- **B1，够。** 寻求能静止，恰在它的目标在一个展开所不变的状态被满足（`Law.rests_iff`）。“比现在更多”只由变化满足，永不在静止中满足（`more_not_at_rest`、`Law.more_never_rests`）；每步都满足就需要开放的世界（`more_needs_open`），这是 Ren“infinite pursuit of becoming bigger”的形式。“高于一切他者”在一个状态至多被一个寻求者满足（`aboveAll_unique`），所以两个或更多这样的寻求者从不同时静止（`Law.aboveAll_never_rests`），这是“the biggest that dominates”的形式，不是支配本身。
- **B2，扩张或耗尽。** 不能在静止中满足的寻求，若在任意晚处仍上升，就需要在任意晚处有所立者不衰减的步，即从其外汲取或不耗散的交换（`Flow.more_needs_unrun`）；所立者从某步起每步衰减时，上升不再复现（`Flow.more_exhausted`）。这是“the whole earth has become a highly entangled system”在这里的形式：没有其外之处，追逐因耗尽而止。
- **B3，反馈。** 损失只经寻求者所识者到达它：经支持，只在累积净汲取越过余裕之处（`Flow.Balances.supported_iff_within_margin`）；阈下的差别保持到支持分岔（`Flow.subthreshold_alike`）；断裂之前，断裂还有多远不被识（`Web.break_not_bounded`）；代价落在识闭包之外时，没有标记到来（`Flow.unregistered_beyond_registration`）。所以被锁定的寻求不被它自身的反馈纠正。
- **B4，明。** 支持不标记的，量度标记（`Web.observed_raise_registers`），对所识负责的模型与他者之识也标记（`Flow.refutes_tail_within`、`Clearing.pooled`）；自己的动作造成什么，只在配置返回之处、在关于何者无关的模型之下被固定（`Run.fixes_on_return`、`Run.generalizes`）。
- **B5，劫持。** 目标的份额在其携带者留下更多后代之处上升（`share_rises`）：这是元吸引子对心智的选择的计数核心，即差异的延续与复利。它只在世界开放时进行；所立者从某步起衰减时，世系与选择停止（`Flow.descent_exhausted`）。结果握在规则里：下一配置取决于规则时，只改状态被重新吸收，改规则才改变结果（`Law.reform_reabsorbed`、`Captured`），这是“胜者重写考题”与杠杆点论证的形式。

**读法（AI 的，待 Ren）。**
- 无明是使寻求锁定在不能在静止中满足的目标上的不见：“比现在更多”，或两个以上寻求者之间的“高于一切他者”。它的边界是 B1：寻求只能在目标于展开所不变的状态被满足之处静止。
- B2 是这样的寻求所做的：它需要一个其外；没有其外时，它因耗尽而止，不是因到达够。
- B3 说被锁定的寻求为什么不被自身的反馈纠正；B4 说什么纠正它。明是识及支持所不标记者的识：量度、模型或他者。
- 合于老子：“知足之足，常足矣”（《道德经》46）；“知止不殆，可以长久”（44）。知足是 B1 的边界之内的目标；知止是在静止中被满足的目标。
- 支配本身不是被排除的目标：在一个满足其目标的秩序之内持有的权力，受规范的权力，或在秩序无法达成一致时由明白者所取的权力，服务于一个能被满足的目标（Ren 10 月 10 日的话）。
- 劫持是这样一种形成：一个奖赏不能静止者的选择形成并传递目标，其胜者所写的规则使它保持在位。Ren 的“even rationality is self-interest”读作规则伸及理性本身的标准：判断寻求的标准也被胜者所写。

**作者反审。**
1. **计数是初等的。** B1 的定理在数学上是初等的：上升的量不在静止中上升，两个寻求者不能彼此都高。实质在于把它们陈述为在展开之中、对任意配置条件的目标，并接到 R6 的开放与 Locality 的静止律上。
2. **目标的形成没有建模。** 目标是配置上的任一条件；被养成、被劫持、被传递（B5）都不在这里。“寻求者追求其目标”也不推出。
3. **rests_iff 设律确定。** 不确定的过程中，静止于够的条件要另陈述。
4. **B2 只说上升不复现。** “耗尽终结寻求者自身”（活动需要支持之处）没有陈述；这里只说追逐不再上升。
5. **B3 与 B4 不是新的定理。** 它们是 P49、P53、P55 的定理读到寻求上；按 AGENTS，不另立结果。
6. **B5 给出的是三个部分，不是劫持的整个机制。** 份额定理是二值目标的计数；多取者留下更多后代、后代带着目标、胜者塑造规则，都是给出的。`reform_reabsorbed` 的条件（下一配置不取决于状态）是强的，`Captured` 是最小的见证；规则怎样被胜者改写（规则依赖于状态）而仍把结果握住，没有一般地陈述。
7. **读法与经典的对应是 AI 的。** 无明、知足、知止、劫持的读法待 Ren。

**检查。**
- 两个模块在暂存区对 main 的核心编译，没有错误或警告；逐条审计全部常量（Seeking 29 个、Capture 22 个），公理报告全部为空。审计在 Capture 中先查出 `propext`，来自前导的 `Nat.mul_assoc`，改用递归证明的 `mul_assoc_nat`。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T194804.708104Z。`Becoming.Seeking` 的 13 项与 `Becoming.Capture` 的 11 项定理全部空依赖；包共 2592 项定理、3809 项声明审计，核心闭包 51 个模块。外围桥接对这个核心重查，通过：回执 20261011T195216.607072Z。
- 未作独立审查：Ren 对 P53 说过“no extra review needed”；P62 是否需要，交 Ren。

## 84. 可判定性局部化（P58）

2026-10-11。Ren（[原话](../../../../sources/15-codex-theory-conversations/2026-10-11-decidability-local-imbalance-relatum.md)）就零前提计划 §1.4 的 (b2) 问：

并以“please”接受 AI 的建议：可判定性局部化，不再是表示的承诺；每条计数或命名一步的规律把在所计数之处已定写作自己的条件；不需要它的规律不用它陈述。“too dualist”读作强加于生成的是或否之分，是 AI 的读法，待 Ren。按[工作板](../../../BECOMING-WORKBOARD.md)认领为 P58。新核心模块 `Becoming.Decidedness`（导入 `Becoming.Space`）；静止定理一族在原处去掉未用的判定程序，名称不变，平息的引理放在用到它们的最低模块（`Becoming.Space`、`Becoming.Openness`），与整合者商定；清点由外围 Lean 工具读出（[清点页](DECIDABILITY-INVENTORY.md)）。

```text
Result(s): 新增 counts-exist-where-decided、recurrence-without-decidedness；扩展 space-and-its-parts、continued-change-needs-openness、
           map-of-premises、laws-at-coarser-steps；coming-and-ceasing-keep-pace、census-balance、whole-law-of-counting 加关联；
           复用 laws-of-one-step 的不判定形式（Covers.not_not_coming_from，P48）
Delta: 已定（Decided p := p ∨ ¬ p）是命题，不是判定程序。计数是关系：计数存在，恰当所计数者在所计数之处已定（counts_iff_decided）；
       计数唯一，判定程序的标记就是计数。计数之间的普查不用可判定性，段内各步也不用（Counts.over_stretch），列出的家族上亦然
       （Counts.listed_across、Counts.listed_over_stretch）。有限家族中开始成立复现时不再成立永不终止，反之亦然，不用可判定性
       （Recurs.ceasing_not_stopping、Recurs.coming_not_stopping）；一段已定时那一步被找到（Recurs.ceasing_found）；从某步起已定时二者
       同时复现（coming_recurs_iff_decided），依存网与有限世界中亦然（Web.unceasing_iff_decided、World.arising_iff_ceasing_decided），
       有覆盖列表时只问列表的成员（World.arising_iff_ceasing_covered）。静止不用判定：不上升的量平息（falls_settle），生成因而平息
       （Web.generation_settles），这否证了覆盖列表下止息复现所留下的生起（World.arising_unrefuted_covering）；World.rests_covering、
       World.rests、World.comes_to_rest（经新的覆盖形式 World.comes_to_rest_from）、World.Finite.comes_to_rest、World.rest_few、
       World.premised_rests 与 World.sample_rests 在原处去掉判定程序，名称不变。清点：核心中 133 条定理的陈述依赖可判定性（63 条计数，
       70 条关于由判定造出的对象），78 条只在证明中用到，逐条给出理由。
Supplied premises / correspondence: 无新前提；局部化是 Ren 对表示的选择（“please”）；“too dualist”读作强加于生成的是或否之分，“局部”读作
       在所计数之处、作为该规律自己的条件，是 AI 的读法，待 Ren
Evidence: 合并检查器回执 20261011T210459.095261Z（Decidedness 55 项定理；2673 项定理、3895 项声明审计，全部源声明公理报告为空；核心闭包 53 个模块，包 51 个），外围回执 20261011T211111.085532Z；Space 62 项、Openness
          85 项定理；先在暂存树中从前导编译，无警告，改动与新增的声明逐条公理报告为空；清点在同一核心上由 Lean 读出
Boundary: 对每个有限世界要求复现的形式而不给已定，是排中律（World.law_iff_em）；命名此后不再生起的一步是有限全知原则（World.lpo_of_finite_ends、
          Listed.lpo_of_few、Web.lpo_of_ending）；以 mark 计数的定理仍以判定程序为自己的条件，未以 Counts 重述；尚无独立审查
Integration: 章节（完整陈述的地位词、第 2 条与第 4 条、§1 的整体与部分、前提卡、第一部分的总陈述、§8、§9、术语表）；记录两项新增、四项扩展、
             三项加关联；清点页；零前提计划 §1.4 (b2) 与现状；统一计划；工作板 P58
```

**改了什么。**
- **已定，不是判定。** 一个命题已定，是指它成立或不成立（`Decided`）。判定程序（`Decidable`）把这一点作为数据给出；已定只是这一点本身，所以以它为条件的定理更强（`Decidable.em` 给出它）。是或否之分只在被要求的地方出现。
- **计数是关系。** 一个数指示一个命题，是指它为一而命题成立，或为零而命题不成立（`Indicates`）；一个数计列表中某规定成立的成员，是指它是这些指示之和（`Counts`）；跨一列步，各步的计数相加（`CountsAcross`）。计数存在，恰当每个被计数的成员已定（`counts_iff_decided`）；计数唯一（`Counts.unique`）；判定程序给出的标记之和就是计数（`counts_total`、`comings_counts`、`ceasings_counts`）。
- **计数之间的规律不用可判定性。** 一段步上，只要计数存在，终点成立的加其间不再成立的，等于起点成立的加其间开始成立的（`Counts.over_stretch`）。证明：段内各步已定时它成立（`Counts.over_stretch_decided`）；有限多个状态已定不能被否证（`not_not_decided`）；数的等式在其否定被否证处成立。计数不超过成员数（`Counts.le_length`）；开始与不再成立的计数相差不超过成员数（`CountsAcross.keep_pace`）。成立者在各步被列出、每个一次时亦然（`Counts.listed_across`、`Counts.listed_over_stretch`）：计数是被计成员的列表的长度（`Counts.listing`），成员相同、不重复的两个列表一样长（`length_eq_of_same`）。
- **复现不用可判定性。** 有限家族中，没有东西不再成立时，开始成立过的不再开始成立（`comes_once`）；没有东西开始成立时，不再成立过的不再不再成立（`ceases_once_of`）。所以一段中看到成员开始成立（或不再成立）的不同步数不多于成员数（`coming_steps_within`、`ceasing_steps_within`，鸽巢）。由此，开始成立复现时，从每一步起都有一段，其中有东西不再成立不能被否证（`Recurs.ceasing_within`），不再成立永不终止（`Recurs.ceasing_not_stopping`），反之亦然（`Recurs.coming_within`、`Recurs.coming_not_stopping`）。
- **在所寻之处已定。** 那一段的状态已定时，那一步被找到（`Recurs.ceasing_found`、`Recurs.coming_found`）；从某步起已定时，开始成立复现恰当不再成立复现（`coming_recurs_iff_decided`），不用判定程序，而 `coming_recurs_iff` 在每一步都要求判定程序。依存网（`Web.unceasing_iff_decided`）与有限世界（`World.arising_iff_ceasing_decided`、`World.arising_iff_ceasing_of_decidable`）亦然；有覆盖列表时只问列表的成员（`World.arising_iff_ceasing_covered`），不终止的形式不问任何东西（`World.ceasing_not_stopping`、`World.arising_not_stopping` 及其覆盖形式）。
- **静止不用判定。** 一个从某步起不上升的量平息：并非此后每一步之后，后来的下降都不能被否证（`falls_settle`，对界归纳，经 `unrefuted_falls_exceed`；`amount_settles`：量从某步起不变，不能被否证）。在每步平衡与耗散的家族上，体现的成员的生成因而平息（`Web.generation_settles`）。有覆盖列表时，止息复现使此后每一步之后成员的生起不能被否证（`World.arising_unrefuted_covering`，由 P48 的 `Covers.not_not_coming_from`），平息否证了它。所以静止定理在原处去掉判定程序，名称不变：`World.rests_covering`、`World.rests`；`World.comes_to_rest` 经新的覆盖形式 `World.comes_to_rest_from`，它只需所立者的普查与一个覆盖每步活跃者的列表，不需要流的前提、活动的普查或判定，所立者跨每一步下降不被否证即可（`Flow.change_settles`、`World.arising_settles_from`）；`World.Finite.comes_to_rest` 以世界的关系项为覆盖列表，不再用它造出的活动普查（`Finite.counted` 需要判定）；`World.rest_few` 经 `Flow.change_settles` 与 `Listed.few_of_settled`；`World.premised_rests` 与 `World.sample_rests` 随之。较弱的“不复现”形式（`falls_finitely_from_floor`、`Web.generation_ceases_from`、`Flow.stills_from`、`World.arising_stops_from`）保留；平息是更强的形式。
- **清点。** 外围 Lean 工具逐条读出核心中以可判定为假设的定理、陈述是否依赖它、证明是否用到它，以及陈述提到哪些取可判定族的定义（[清点页](DECIDABILITY-INVENTORY.md)）。陈述依赖它的 133 条中，63 条计数，其余 70 条关于由判定造出的对象：较粗的读法（粗步内每个关系项只列一次）51 条，抬高一个条件 8 条，保留的列表 4 条，不重复的列表 4 条，移开依存 3 条；可判定是它们自己的条件。只在证明中用到的 78 条中，49 条找出一步或一个成员（不给已定时它只是不能被否证），18 条分辨相同，8 条造出列表，3 条分情形；有不判定形式的，清点页列出那一形式。另有 6 条以排中律为假设的边界定理，75 条计数而可判定被证明（由见证世界或体现）。

**作者反审。**
1. **关系计数是否把可判定藏进了“计数存在”？** 没有藏：存在恰等价于已定（`counts_iff_decided`），这是定理，不是定义。规律对任何存在的计数成立，不要求它们存在；需要计数的陈述就把已定写作条件，范围是所计数之处。
2. **不终止的形式是否太弱？** 它是双重否定的复现：不指出在哪一步，但排除了“从某步起再没有”。这正是已证明的界：不给已定时，命名一步需要全知原则，对每个世界要求复现需要排中律；从某步起已定时复现成立。
3. **静止定理去掉判定，是否改变了它所说的？** 没有：结论不变，只去掉一个未用的假设，所以每个旧的用法仍然成立；证明改经平息，平息比不复现更强。`World.Finite.comes_to_rest` 的证明不再经过普查，而以世界的关系项为覆盖列表。
4. **是否所有的判定都已局部化？** 判定已不是表示的承诺：每条仍用它的定理把它写作自己的条件，清点逐条给出理由。以 `mark` 计数的 63 条可以照普查的样子以 `Counts` 重述，基本的几条已有关系形式；其余未重述。
5. **“过于二元”是否就是可判定性？** 这是 AI 的读法：可判定性把是或否之分强加于每一处。局部化后，这一分只在计数、命名一步、造出列表或分辨相同之处，作为该规律的条件出现；计数之间的规律、不终止的规律与静止定理不用它。

**边界。** 不推出对每个世界的复现形式；不为命名一步的形式去掉全知原则；以 `mark` 计数的定理未以 `Counts` 重述；名称（`Decided`、`Indicates`、`Counts`、`CountsAcross`、settles／平息）是 AI 所选；尚未经独立审查。

## 85. 不平衡作为关系项：先证等价（P59）

2026-10-11。零前提计划 §1.4 提出一种重新奠定：把不平衡算作关系项。Ren（[原话](../../../../sources/15-codex-theory-conversations/2026-10-11-decidability-local-imbalance-relatum.md)）以“please”接受 AI 的建议：先把它作为与现行表示等价的表示加以证明，是否采用仍由 Ren 定。按[工作板](../../../BECOMING-WORKBOARD.md)认领为 P59。新核心模块 `Becoming.Imbalance`（导入 `Becoming.Locality` 与 `Becoming.Resolution`，不改任何既有模块）。

```text
Result(s): 新增 imbalance-as-relatum；复用 R4 的惰性关系项读法（Web.withRefinement，rest-with-refinement-counted）与 P50/P57 的局部平衡
           （Flow.BalancesOn）
Delta: 一步上，一个条件的水平按流所给、所取改变，恰当流在那里平衡。不平衡之处，把差额算作又一个关系项 none 的交换：它给每个条件
       其水平超出流的净交换而升的部分，取其超出而降的部分（Flow.withImbalance）；依存网照 R4 读入它：从不活跃，不要求任何东西。
       于是扩展的流在每一步、每个条件上平衡（Flow.withImbalance_balances、Flow.withImbalance_balancesOn）。流在一个家族上跨一步
       平衡，恰当新增的关系项在那里对其成员不给不取（Flow.balancesOn_iff_idle）。两种表示逐步等价：在一步一个条件上，扩展的流中
       只有活跃者给予，恰当原流中只有活跃者给予且水平不超出净交换而升（Flow.withImbalance_acting_at_iff）；只有活跃者取、只取其
       所汲取的，恰当原流如此且水平不超出净交换而降（Flow.withImbalance_taking_at_iff）；所以在一个家族上跨一步，二者在扩展的流上
       成立，恰当二者在原流上成立且流在那里平衡（Flow.withImbalance_acting_taking_on_iff）。全步全条件的形式是推论。
Supplied premises / correspondence: 无新前提；“算入不平衡”是一种表示，不是定理；是否采用由 Ren 定
Evidence: 合并检查器回执 20261011T210459.095261Z（Imbalance 15 项定理；2673 项定理、3895 项声明审计，全部源声明公理报告为空；核心闭包 53 个模块，包 51 个），外围回执 20261011T211111.085532Z；先在暂存树中从前导编译，无警告，16 条源声明的公理报告全部为空
Boundary: 不采用；核心的规律仍以 Flow.BalancesOn 为局部条件；等价不说明哪种读法更好，也不说明世界在哪里平衡；尚无独立审查
Integration: 章节（§8 表示的选择、§9 行、术语表）；记录 imbalance-as-relatum；零前提计划；统一计划；工作板 P59
```

**改了什么。**
- **平衡由构造成立。** 算入不平衡后，每个流在每一步、每个条件上都平衡；平衡不再是关于世界的条件，而是表示的性质。
- **条件移到一个关系项上。** 原来平衡所说的，现在由新增关系项的闲置来说：流在一个家族上跨一步平衡，恰当它在那里对其成员不给不取（`Flow.balancesOn_iff_idle`、`Flow.balances_iff_idle`）。
- **逐步等价，不增不减。** 原流的活动前提加上平衡，恰是扩展的流的活动前提，在每一步每个条件上如此（`Flow.withImbalance_acting_at_iff`、`Flow.withImbalance_taking_at_iff`、`Flow.withImbalance_acting_taking_on_iff`，全步的形式 `Flow.withImbalance_acting_iff`、`Flow.withImbalance_taking_iff`、`Flow.withImbalance_acting_taking_iff`）；所以以平衡为条件的规律，在扩展的表示中以新增关系项的不活跃为条件，所说的相同。

**作者反审。**
1. **是否把平衡藏进了定义？** 没有藏：扩展的流平衡是定理（`Flow.withImbalance_balances`），它所失去的内容由逐步的等价收回（`Flow.withImbalance_acting_taking_on_iff`）。在扩展的表示中，活动前提在新增关系项上恰是原来的平衡。
2. **差额用自然数的截断减法，会不会丢失信息？** 不会：给与取各取一边的差额，一边为零；`Flow.balancesOn_iff_idle` 证明二者都为零恰是平衡。
3. **采用它会改变什么？** 不改变任何规律所说的，只改变平衡出现的位置：从关于世界的条件，变成一个关系项是否活跃。哪种读法更好，是 Ren 的决定。

**边界。** 不采用；不说明世界在哪里平衡；名称（`withImbalance`、idle／闲置）是 AI 所选；尚未经独立审查。

## 86. 经识的选择：选择恰及选择者所识（P64）

2026-10-12。Ren 问：“hows cause–effect system comparing to our theory?”，随后贴入一段关于因果系统的说明（作者未注明，读来是别处的 AI 所写，不是 Ren 的话，也不是理论的前提）。AI 把理论与这一框架（`x_{t+1} = F(x_t, u_t, ε_t)`、反馈、改变自身规则的系统、吸引子）作了比较，又提出五项可学之处。Ren 写道：“Great, let's finish all of them, you can spawn sub agents in a wise order if needed”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-cause-effect-comparison.md)）。五项提议是 AI 的；本节是其中第一项：选择只及选择者所识。它在工作板上认领为 P64。它不加公理；平衡只在被识的条件上逐步假设，“选择经识”是写在每条定理中的条件，不推出。它属于第一部分。核心新增模块 `Becoming.Selection`（L4），43 项定理，导入 `Becoming.Testing` 与 `Becoming.Capture`（P62，先于本节落地），不改任何已有模块。

成果记录新增一项：[selection-through-registration](../../../../theories/becoming/results/records/selection-through-couplings.md)。

```text
Result(s): 复用 testing-within-registration（Web.RegistersAlike、Web.RegistersAlikeUpTo、RegistersAlike.refl、
           RegistersAlikeUpTo.symm、earlier、of_obs、Web.Belief、Web.Refutes、Refutes.not_meets、Web.RegistersAlikeAll、
           Flow.WithinRegistration、Flow.withinRegistration_supportOnly、Flow.unregistered_beyond_registration、
           Flow.alike_within_registration、Clearing.alike_for_clearer、Clearing.tested_by_dweller、Clearing.DwellerEnded、
           Clearing.resourceGone、Clearing.clearerAndDweller）、target-capture（share_rises、offspringCount）；
           Becoming.Feedback 的 WithinClosure、Flow.WithinReach、Clearing.reach_middle、Clearing.resource_of_clearer；
           Becoming.Change 的 mark 与 mark_cases；新增上列一项
Delta: 经识的选择：Web.SelectsThrough、Web.ScoresThrough、Web.RegistersAlike.trans、Web.RegistersAlikeUpTo.trans、
       Web.belief_selects、Web.selects_alike_iff、Web.separates、Web.SelectsThrough.refutes_iff、Web.admits_through、
       Web.observed_scores、Web.ScoresThrough.atLeast、Web.SelectsThrough.later、Web.SelectsThrough.widen、
       Web.SelectsThrough.not、Web.SelectsThrough.and、Web.scores_alike_iff。合起来的识：Web.SelectsThroughAll、
       Web.RegistersAlikeAll.refl、symm、trans、Web.SelectsThrough.all、Web.SelectsThroughAll.and、
       Web.selects_alike_all_iff、Web.separates_all。识闭包之外的不见：Flow.unselected_beyond_registration、
       Flow.unscored_beyond_registration、Flow.unselected_beyond_registration_all、
       Flow.unselected_beyond_registration_responsive。后代中的份额：share_rises_through（应用）。见证：Clearing
       （unselected、dweller_within_reach、dweller_spared、clearer_spared、selected_by_dweller、dweller_alike_gone、
       BothAdmitted、selected_pooled）；Diversion（Formation、Place、first、drawn、raised、diverting、restrained、
       supplying、divertedLevel、restrainedLevel、suppliedLevel、web、gauge、StoreAtLeast、takerAlone、
       diverting_balances、restrained_balances、supplying_balances、dependent、diverting_acting、diverting_taking、
       takerAlone_closed、supplied_closed、favours、blind_to_source）
Supplied premises / correspondence: 不加公理；选择经识（SelectsThrough、ScoresThrough、SelectsThroughAll）是给出的条件，
       写在用到它的每条定理中，不推出；选择是关于水平历史的任意命题，“保留、奖励、留下后代、训练”是读法；识闭包之外的
       不见另设与 unregistered_beyond_registration 相同的条件：其余交换固定（扣留的部分，WithheldLevels），平衡只在闭包
       成员所识的条件上逐步假设，部分的每个成员都在识闭包之外；回应的形式用 alike_within_registration 的假设（两流在场者
       相同，起始在所识者上相同，成员只经自己之识回应）；评分定律的逆向以“与第一段历史识得相同”的可判定性为命名的假设
       （decided）；share_rises_through 中被选者与其余亲代各自的后代数之界、b < a、两类亲代都在，是给出的；离散的步、
       自然数的量；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T225632.916383Z（Becoming.Selection 43 项定理，全部源声明公理报告为空），外围回执 20261011T230225.829392Z
Boundary: 谁选择、选择者识什么、一个实际的选择是否经识、后代是否随选择、伸向识闭包之外是否被选取，都不推出；
          share_rises_through 是 Capture 的 share_rises 的应用，不新增算术，传递不在其中；缺口与偏向只在见证中陈述，
          没有一般定理；见证是最小的；不含伦理谓词
Integration: 计划 P64，比较之后五项提议的第一项；把 P49 的识闭包之外的不见（unregistered_beyond_registration、
             alike_within_registration）与 P42 的所及闭包接到选择上：缺口是所及闭包减去识闭包；把 P62 的份额上升接到
             经识的选择上；与 P55 并列：经识的策略不能用上它所不识的，经识的选择不能对它所不识的作出选择
```

| 声明 | 内容 |
|---|---|
| `Web.SelectsThrough`、`Web.ScoresThrough` | 一个选择（关于水平历史的任意命题）经形成 `f` 直到某步之识：`f` 直到那一步识得相同的历史，被选得相同；评分经它：识得相同的历史得分相同 |
| `Web.RegistersAlike.trans`、`Web.RegistersAlikeUpTo.trans` | 识得相同可传递；连同 `RegistersAlike.refl` 与 `RegistersAlikeUpTo.symm`，是等价关系 |
| `Web.belief_selects` | 形成的信念（它与某段历史识得相同的历史，`Web.Belief`）是经其识的选择 |
| `Web.selects_alike_iff` | 选择恰及所识（不加前提）：两段历史被每个经 `g` 直到某步之识的选择选得相同，恰当 `g` 直到那一步把它们识得相同 |
| `Web.separates` | `g` 把两段历史识得不同之处，有一个经其识的选择（它的信念）在前者成立、在后者不成立 |
| `Web.SelectsThrough.refutes_iff` | 经识的选择被它的选择者完全检验：恰在它不成立之处被否证 |
| `Web.admits_through`、`Web.observed_scores`、`Web.ScoresThrough.atLeast` | 到某步为止某一步上的接纳是经识的选择；被观察条件的水平是经识的评分；评分的阈值是经同一识的选择 |
| `Web.SelectsThrough.later`、`widen`、`not`、`and` | 经识的选择在更晚的步、更多的观察之下仍经识；其否定与合取也经识 |
| `Web.scores_alike_iff` | 与第一段历史识得相同可判定时（命名的假设），两段历史被每个经识的评分评得相同，恰当识得相同：信念的标记（`mark`）就是这样的评分 |
| `Web.SelectsThroughAll`、`Web.RegistersAlikeAll.refl`、`symm`、`trans` | 选择经一组形成合起来的识：每个成员都识得相同的历史被选得相同；每个成员都识得相同是等价关系 |
| `Web.SelectsThrough.all`、`Web.SelectsThroughAll.and` | 一个成员的选择是合起来的选择；合起来的选择在合取下封闭 |
| `Web.selects_alike_all_iff`、`Web.separates_all` | 合起来的选择恰及合起来所识：两段历史被每个合起来的选择选得相同，恰当每个成员都把它们识得相同；不然，有一个合起来的选择把它们分开 |
| `Flow.unselected_beyond_registration`、`Flow.unscored_beyond_registration` | 选择在识闭包之外不见：其余交换固定，部分的每个成员都在 `f` 的识闭包之外时，经闭包内任一形成（`f` 在其中）之识的每个选择与评分，把有与无部分的水平选得相同、评得相同：`unregistered_beyond_registration` 的实例 |
| `Flow.unselected_beyond_registration_all` | 在闭包之内合起来仍不见：成员都在 `f` 的识闭包之内的一组，其合起来的每个选择把有与无闭包外部分的水平选得相同 |
| `Flow.unselected_beyond_registration_responsive` | 成员回应时：在 `alike_within_registration` 的假设之下，经（对两流画出的）识闭包内任一形成之识的每个选择，把两个流的水平选得相同 |
| `share_rises_through` | 后代中的份额（应用）：选择给它所成立的每个亲代至少 a 个后代、其余每个亲代至多 b < a 个；它在 ms 的每个亲代上成立、在 es 的每个亲代上不成立、两者都非空时，ms 的后代与 es 的后代之比严格大于 ms 与 es 之比：`share_rises`，由选择给出谁是携带者 |
| `Clearing.unselected` | 清除者的选择所不及：经清除者之识（只识支持，即 `alike_for_clearer` 所用的观察）的每个选择，在每一步都把清除与不清除的世界选得相同；栖居者在清除的世界中被终结，在不清除的世界中不然；所以“栖居者被终结”在任何一步都不是经清除者之识的选择 |
| `Clearing.dweller_within_reach` | 缺口：栖居者在清除者的所及闭包之内、识闭包之外；清除者不识它所清除的栖息地 |
| `Clearing.dweller_spared`、`Clearing.clearer_spared` | 不清除的世界中，栖居者与清除者都在第三步被接纳 |
| `Clearing.selected_by_dweller` | 栖居者之识选出：“栖居者在第三步被接纳”是经栖居者之识的选择，在不清除的世界成立、在清除的世界不成立；栖居者直到第三步把两者识得不同 |
| `Clearing.dweller_alike_gone`、`Clearing.BothAdmitted` | 栖居者在每一步把不清除的世界与资源在第三步耗尽的世界识得相同；第三步栖居者与清除者都被接纳 |
| `Clearing.selected_pooled` | 合起来的选择：`BothAdmitted` 经清除者与栖居者合起来的识，在不清除的世界成立、在清除的世界不成立；它不经两者中任一个单独之识：清除者把清除的世界与不清除的识得相同，栖居者把资源耗尽的世界与不清除的识得相同 |
| `Diversion.Formation`、`Place`、`first`、`drawn`、`raised`、`diverting`、`restrained`、`supplying`、`divertedLevel`、`restrainedLevel`、`suppliedLevel`、`web`、`gauge`、`StoreAtLeast`、`takerAlone` | 见证：取用者与栖居者，来源与存储；栖居者依存于来源、所需为二，取用者不依存任何条件、观察存储（`gauge`）；转移的流在第一步从来源取一个单位、给存储一个单位，克制的流什么都不交换，供给的流在第一步给存储一个单位、什么都不取 |
| `Diversion.diverting_balances`、`restrained_balances`、`supplying_balances`、`dependent`、`diverting_acting`、`diverting_taking`、`takerAlone_closed`、`supplied_closed` | 三个流都平衡；每个网中活动需要支持；转移的流中只有活跃者给予与取用，且只从所汲取者取用；转移的流中取用者单独对经所识者受影响封闭；供给的流中取用者单独对影响封闭 |
| `Diversion.favours` | 选择偏向伸出：转移的流伸到栖居者，栖居者在取用者的所及闭包之内、识闭包之外；克制的流不伸到它；“存储在第二步至少为一”是经取用者之识的选择，在转移的流成立、在克制的流不成立；栖居者在转移的流中从第二步起不被支持，在克制的流中每步都被支持 |
| `Diversion.blind_to_source` | 选择分不出伸出与否：供给的流平衡，像转移的流一样抬高存储，而不伸到取用者之外；取用者在每一步把转移与供给的水平识得相同，所以经其识的每个选择把它们选得相同；栖居者在供给的流中每步都被支持，在转移的流中从第二步起不被支持 |

**它回答了什么。**
- **选择恰及选择者所识。** 选择是关于水平历史的任意命题：哪些被保留、被奖励、留下更多后代。两段历史被每个经 `g` 之识的选择选得相同，恰当 `g` 把它们识得相同（`Web.selects_alike_iff`）；`g` 识得不同之处，它的信念就是把两者分开的选择（`Web.separates`）。所以经识的选择所能分辨的，不多于也不少于选择者所识。经识的选择也是选择者完全检验的主张：恰在不成立之处被否证（`Web.SelectsThrough.refutes_iff`）。
- **选择在识闭包之外不见。** 其余交换固定、部分在 `f` 的识闭包之外时，经闭包内任一形成之识的每个选择与评分，都把有与无这一部分的世界选得相同（`Flow.unselected_beyond_registration`、`Flow.unscored_beyond_registration`）；与闭包内的形成合起来也不变（`Flow.unselected_beyond_registration_all`）；成员只经自己之识回应时亦然（`Flow.unselected_beyond_registration_responsive`）。
- **缺口是所及闭包减去识闭包。** `Clearing` 中栖居者在清除者的所及闭包之内、识闭包之外（`Clearing.dweller_within_reach`）：清除者的部分伸到它，而经清除者之识的每个选择都把清除与不清除的世界选得相同，虽然栖居者在一个中被终结、在另一个中不然（`Clearing.unselected`）。
- **缺口经关系合上。** 栖居者自己的识把两个世界分开（`Clearing.selected_by_dweller`）；清除者与栖居者合起来的识选出一个两者各自都选不出的选择（`Clearing.selected_pooled`）。这是 P49 的 `Clearing.tested_by_dweller` 与 `Clearing.pooled` 在选择上的形式。
- **伸出而抬高所识者，选择偏向它。** `Diversion` 中，经取用者之识的选择“存储至少为一”在转移的流中成立、在克制的流中不成立，而转移的流伸到识闭包之外，终结栖居者（`Diversion.favours`）；经取用者之识的每个选择，又把转移与不伸出的供给选得相同（`Diversion.blind_to_source`）：选择不能因伸出而对它不利。
- **后代中的份额。** 选择给它所成立的亲代更多后代时，它们在后代中的份额上升（`share_rises_through`）。这是 P62 的 `share_rises` 的应用：选择给出谁是携带者。

**读法（AI 的，待 Ren）。**
- 任何由选择者所识决定的选择（保留、奖励、繁殖、训练）恰及选择者所识。候选者的部分在选择者识闭包之外所做的，它都不见，无论候选者的所及闭包延伸多远。缺口是所及闭包减去识闭包。
- 缺口只经关系合上：依存、观察，或他者之识合起来，如 `Clearing` 中的栖居者。与闭包之内的形成合起来，合不上它。
- 伸出所识之外而抬高所识者之处，选择偏向它，并且分不出它与不伸出的抬高。连同 `share_rises`，伸出者在后代中的份额在世界开放时上升；被围住时，选择随后代一起停止（`Becoming.Capture` 的 `Flow.descent_exhausted`）。这一组合没有形式陈述。
- 以 AI 训练读，奖励过程是一个选择者：训练只及奖励所识。AI 把这与 Ren 一篇论文的标题 “When Capability Outruns Correction” 相接：经一个识选出的能力，可以伸到那个识之外，而经那个识的纠正到不了那里。这是 AI 的联系，不是 Ren 的陈述。
- 与 P55 相对：失控是经自身之识的策略不能用上它所不识的储量；这里是经选择者之识的选择不能对它所不识的部分作出选择。

**作者反审。**
1. **主定律近乎定义。** `Web.selects_alike_iff` 的一个方向取信念为选择，另一个方向是定义的展开。它的内容在于选择量化于关于水平历史的一切命题，所以界是精确的；但它不是关于展开的深定理。识闭包之外的不见也是 P49 的 `unregistered_beyond_registration` 与 `alike_within_registration` 的一行推论。增量是概念上的：把选择写成识的函数，以及缺口与偏向的见证。
2. **“经识”是给出的。** 一个实际的选择过程是否只依所识，模块不说。它依于什么，就可以把那个当作选择者之识（观察可以任意扩大，`Web.SelectsThrough.widen`）；所识越多，识闭包越大，缺口越小，甚至为空。所以定律的力量全在选择者实际识什么，而这是经验问题。
3. **比较的是有与无一个部分。** `Flow.unselected_beyond_registration` 固定其余交换；他者回应时要给出第二个流和 `alike_within_registration` 的回应假设。他者回应储量本身时（P49 的 `Attracting`），这些假设可以不成立。
4. **份额定理是应用。** `share_rises_through` 只是 `share_rises` 加上“选择给出携带者”；后代数与选择的关系（`rewarded`、`unrewarded`）是给出的，传递（后代携带亲代所携带的）不在其中。“伸出者的份额上升”还需要伸出者被选、且世界开放；这一组合是读法。为避免未用的假设，定理不带 `SelectsThrough` 假设；经识只在读法中进入。
5. **自身动作的缺口没有一般定理。** 清除者的部分是它自己的动作，在它自己的识闭包之内，所以 `Flow.unselected_beyond_registration`（部分在闭包之外）不直接适用。`Clearing` 中的不见来自 `alike_within_closed` 的实例：清除只作用于闭包成员都不识的条件。一般形式（一个形成的动作只在其识闭包成员都不识的条件上不同时，经其识的每个选择都看不见它）可由 `Flow.unselected_beyond_registration_responsive` 得出，但没有单独陈述。
6. **偏向只在见证中。** `Diversion` 一步、两个形成、两个条件；“抬高所识者的部分何时必伸出识闭包之外”的一般定理没有。`blind_to_source` 的供给的流是给出的第二个流，取用者不取用就给予。
7. **评分的逆向需要判定性。** 选择的形式不需要；`Web.scores_alike_iff` 以可判定性为命名的假设。

**检查。**
- 模块在暂存区对 main 的核心与 P62 的 `Becoming.Capture` 草稿编译，没有错误或警告；逐条审计全部 136 个常量，公理报告全部为空；不用 `sorry`、`axiom`、`Classical`、`native_decide`、`by decide`。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T225632.916383Z。`Becoming.Selection` 的 43 项定理全部空依赖；包共 2823 项定理、4112 项声明审计，核心闭包 57 个模块。外围桥接对这个核心重查，通过：回执 20261011T230225.829392Z。
- 尚无独立审查。

## 87. 其余回应时的比较：在回应所及之内决定（P65）

2026-10-12。AI 把本理论与一般的因果系统（x_{t+1} = F(x_t, u_t, ε_t)、反馈、自适应参数、吸引子）作比较之后，提出五项改进；Ren 答：“Great, let's finish all of them, you can spawn sub agents in a wise order if needed”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-cause-effect-comparison.md)）。本节是其中第二项，提议是 AI 的，在工作板上认领为 P65。它回答本章 §8 的开放项“其余交换随之调整的反事实”中其余经识回应的情形。P42 以扣留水平的比较固定其余交换；`Flow.Balances.comparison_within_difference` 在任意两个流的差别所及之内决定比较，却不说差别能到哪里。本节陈述：部分之外的形成都只经自己之识回应时，差别到不了部分对经所识者影响的闭包之外，比较就在那里决定。它是 P49 识闭包之不见（`Flow.alike_within_closed`，从区域一侧陈述）的对偶，从部分一侧陈述。不加公理；平衡、起始相同、两个流的在场形成相同与经识回应，每条都只作为用到它的定理的假设。属于第一部分。核心新增模块 `Becoming.Response`（L4），30 项定理，导入 `Becoming.Testing`，不改任何已有模块。

成果记录新增一项：[comparison-where-the-rest-responds](../../../../theories/becoming/results/records/comparison-where-the-rest-responds.md)。

```text
Result(s): 复用 testing-within-registration（Flow.RegisteredFrom、Flow.RegisteredFromEither、Flow.WithinRegistration、
           supportOnly、Web.Registers、Web.RegistersAlikeUpTo、Flow.alike_within_closed、Flow.exchange_agrees_within、
           Flow.withheld_eq_of_false）、comparison-within-reach（Flow.DiffersBefore、Flow.Balances.comparison_within_difference；
           Trophic.wolves_unreached、Trophic.responsive_mixed）、feedback-and-reach（Flow.Reaches）、levels-of-closure
           （ClosedUnder、WithinClosure 及其引理、Flow.AffectedBy、Flow.Affects、Flow.WithinReach、Flow.WithinInfluence；
           Trophic 的流、网与鹿有回应的流）、laws-of-one-step（Flow.BalancesOn、Flow.Balances.on）；新增上列一项
Delta: 回应所及：Flow.WithinResponse、Flow.member_within_response、Flow.outside_part_of_beyond_response。
       对偶与 P42：WithinClosure.converse、Flow.withinResponse_iff_registration、Flow.withinResponse_self_iff、
       Flow.withinResponse_of_reaches、Flow.withinResponse_of_withinReach、Flow.withinResponse_supportOnly_iff、
       Flow.withinReach_iff_withinInfluence。经识回应：Flow.RespondsThroughRegistration、
       Flow.respondsThroughRegistration_withhold。限定：Flow.beyond_response_closed、Flow.alike_beyond_response、
       Flow.exchange_alike_beyond_response、Flow.totals_alike_beyond_response、Flow.not_differs_beyond_response。
       比较：Flow.Balances.comparison_within_response、Flow.Balances.comparison_within_response_of_decidable。
       见证：Trophic（forest_within_response、responds_through_registration、responsiveReach、den_untouched、
       far_unaffected、responsiveReach_closed、within_response_iff、responsive_comparison）；Loop（Formation、Place、
       members、firstPart、own、act、reply、escalation、quiet、ofFirstLevel、ofSecondLevel、firstLive、web、quietWeb、
       balances、quiet_balances、dependent、quiet_dependent、responds、returns）
Supplied premises / correspondence: 不加公理；经识回应（Flow.RespondsThroughRegistration）是给出的前提，不由动力学推出；
       限定的定理只在回应所及之外者所识的条件上逐步假设平衡（Flow.BalancesOn），并假设两个流的在场形成相同、在那些条件上
       起始相同；主比较假设两个流全局平衡、起始相同；覆盖写成“不在回应所及之外”（双重否定），不用判定，回应所及可判定时
       覆盖所及即可；离散的步（从第 0 步计）、自然数的量；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T225632.916383Z（Becoming.Response 30 项定理，全部源声明公理报告为空），外围回执 20261011T230225.829392Z
Boundary: 形成只经其识回应不推出，怎样回应不推出；回应所及经两个流画出，须知第二个流与哪些条件交换（不须知其数量）；
          回应所及是上界：不说差别到达其中的哪个形成，也不量差别多少，且不按时间先后；Loop 是一个两方的见证，不是回路的
          一般定义，没有增益或失控的定理；不含伦理谓词
Integration: 计划 P65；回答本章 §8 开放项“其余交换随之调整的反事实”中其余经识回应的情形，回应由动力学给出的情形仍开放；
             把 P49 从区域一侧陈述的识闭包之不见对偶地从部分一侧陈述，接到 P42 的两流比较；只识支持、一个流时，回应所及
             就是 P42 的所及闭包之并
```

| 声明 | 内容 |
|---|---|
| `Flow.WithinResponse` | 一个形成在部分（在两个流之间）的回应所及之内：它在某个成员对经所识者影响的闭包之内；a 对 b 有此关系，是指 a 在两个流之一中与 b 所识的条件交换 |
| `Flow.member_within_response`、`Flow.outside_part_of_beyond_response` | 部分的每个成员都在其回应所及之内；所以回应所及之外的都在部分之外 |
| `WithinClosure.converse` | 对一个关系之逆的闭包就是闭包之逆：g 在 f 对逆关系的闭包之内，恰当 f 在 g 对原关系的闭包之内 |
| `Flow.withinResponse_iff_registration`、`Flow.withinResponse_self_iff` | 回应所及与识闭包对偶：一个形成在部分的回应所及之内，恰当某个成员在该形成经两个流画出的识闭包之内（`Flow.alike_within_registration` 的闭包）；一个流时，就是在其识闭包（`Flow.WithinRegistration`）之内 |
| `Flow.withinResponse_of_reaches`、`Flow.withinResponse_of_withinReach` | 部分所到达的、每个成员的所及闭包，都在回应所及之内 |
| `Flow.withinResponse_supportOnly_iff` | 只识支持、一个流时，回应所及恰是成员所及闭包之并：一个形成在其中，恰当它在某个成员的所及闭包之内 |
| `Flow.withinReach_iff_withinInfluence` | 所及闭包是影响闭包之逆：g 在 h 的所及闭包之内，恰当 h 在 g 的影响闭包之内 |
| `Flow.RespondsThroughRegistration` | 其余经识回应：部分之外的每个形成，凡直到某步识得相同，在该步与每个条件的交换在两个流中相同。给出的前提 |
| `Flow.respondsThroughRegistration_withhold` | 其余固定是它的情形：无论识什么，扣留部分的流在部分之外与原流交换相同 |
| `Flow.beyond_response_closed` | 回应所及之外的形成构成一个区域，在两个流中都对经所识者受影响封闭：与这样的形成所识的条件交换的，也在回应所及之外 |
| `Flow.alike_beyond_response` | 限定：两个流在场形成相同，在回应所及之外者所识的条件上逐步平衡且起始相同，其余经识回应时，回应所及之外的每个形成每步都识得相同，无论部分做什么；`Flow.alike_within_closed` 的实例 |
| `Flow.exchange_alike_beyond_response`、`Flow.totals_alike_beyond_response` | 同样的假设下，回应所及之外的每个形成每步交换相同；两个流每步从它所识的每个条件取用与向它给予的总量相同（与它交换的也在回应所及之外，经 `Flow.exchange_agrees_within` 与 `total_congr_on`） |
| `Flow.not_differs_beyond_response` | 差别留在回应所及之内：同样的假设下，两个流的差别在任何一步之前都到不了回应所及之外的形成（`Flow.DiffersBefore` 不成立） |
| `Flow.Balances.comparison_within_response` | 其余回应时的比较在回应所及之内决定：两个平衡的流在场形成相同、起始相同，其余经识回应，对从 p 覆盖每个不在回应所及之外的形成的任何意义，每个流的水平保留另一个上有意义者，恰当前者包含后者，反过来也是；两者都不增加有意义的延续，恰当两者都不超出对方。覆盖写成双重否定，因为差别只表明它到达的形成不在回应所及之外；不用判定 |
| `Flow.Balances.comparison_within_response_of_decidable` | 回应所及可判定时，覆盖回应所及本身即可 |
| `Trophic.forest_within_response` | 营养级联中，在狼群之流与鹿有回应之流之间，森林在狼群的回应所及之内：狼群取用鹿所依存的鹿群（herd），鹿啃食森林所依存的生长（growth）；而狼群的部分到达不了森林（`Trophic.wolves_unreached`），两流的差别到达它（`Trophic.difference_reaches_forest`） |
| `Trophic.responds_through_registration` | 营养级联满足前提，只识支持：狼群之外，每个形成凡识得相同之处交换相同；鹿在第 0 步啃食相同，从第 1 步起鹿群的损失已在其支持中被识 |
| `Trophic.responsiveReach`、`Trophic.den_untouched`、`Trophic.far_unaffected`、`Trophic.responsiveReach_closed` | 狼群、鹿与森林；两个流中都没有什么与远处形成的巢（den）交换；远处形成所识的条件，在两个流中都没有什么与之交换；这三者对经所识者的影响封闭（太阳什么都不识） |
| `Trophic.within_response_iff` | 狼群的回应所及恰是狼群、鹿与森林；太阳与远处形成在其外 |
| `Trophic.responsive_comparison` | 有回应的比较在狼群、鹿与森林之间决定：对从 p 每步覆盖这三者的任何意义，两条水平路径恰如彼此包含那样彼此保留；两者互相超出（`Trophic.responsive_mixed`），所以都不保留。太阳与远处形成不需要意义；`Flow.Balances.comparison_within_response` 的实例 |
| `Loop.Formation`、`Loop.Place`、`Loop.members`、`Loop.firstPart`、`Loop.own`、`Loop.act`、`Loop.reply`、`Loop.escalation`、`Loop.quiet`、`Loop.ofFirstLevel`、`Loop.ofSecondLevel`、`Loop.firstLive`、`Loop.web`、`Loop.quietWeb` | 两个形成，各需要（需要量一）并观察自己的条件；有动作的流：第一个在第 0 步从第二个的条件取用一单位，第二个观察到下降，在第 1 步从第一个的条件取用两单位；无动作的流什么都不取用；两个条件都从二起，有动作时第一个的条件在第 2 步归零，第二个的停在一；有动作时第一个形成只在第 0、1 步活跃 |
| `Loop.balances`、`Loop.quiet_balances`、`Loop.dependent`、`Loop.quiet_dependent`、`Loop.responds` | 两个流平衡，两个网中活动都需要支持；第二个形成经其识回应 |
| `Loop.returns` | 差别回到部分：两个流平衡，活动需要支持，起始相同，第二个经识回应；第一个的动作与第二个所观察的条件交换，第二个的回应与第一个所需的条件交换；第一个自身与其条件的交换在两个流中相同，而有动作时第一个在第 2 步不被支持，无动作时被支持；其余固定时第一个的部分到达不了第一个，而两流的差别在第 2 步之前到达它 |

**它回答了什么。**
- **其余回应时，差别能到哪里。** 部分之外的形成都只经自己之识回应时，回应所及之外的每个形成每步识得相同、交换相同，它所识的条件上的总量相同（`Flow.alike_beyond_response`、`Flow.exchange_alike_beyond_response`、`Flow.totals_alike_beyond_response`），两个流的差别到不了它（`Flow.not_differs_beyond_response`）。这是 P49 的 `Flow.alike_within_closed` 以回应所及之外为区域的实例；区域的封闭由闭包的定义直接得到（`Flow.beyond_response_closed`）。
- **比较在回应所及之内决定。** 对两个平衡、起始相同的流，覆盖每个不在回应所及之外者的任何意义，都对两者作公理的比较（`Flow.Balances.comparison_within_response`）。这把 P42 的 `comparison_within_difference`（比较在差别所及之内决定）接到差别能到哪里。
- **两种反事实。** 其余固定是经识回应的情形（`Flow.respondsThroughRegistration_withhold`），所以本节的定律也适用于它；那时 P42 给出更紧的界：只计部分在每步之前直接到达的（`Flow.Balances.comparison_within_reach`）。部分所到达的与每个成员的所及闭包都在回应所及之内（`Flow.withinResponse_of_reaches`、`Flow.withinResponse_of_withinReach`）。
- **所及闭包的反事实意义。** 只识支持、一个流时，回应所及恰是成员所及闭包之并（`Flow.withinResponse_supportOnly_iff`）；回应所及与识闭包对偶（`Flow.withinResponse_iff_registration`），所及闭包与影响闭包对偶（`Flow.withinReach_iff_withinInfluence`）。
- **营养级联与回路。** P42 的见证满足前提（`Trophic.responds_through_registration`）：森林在狼群的回应所及之内，而狼群的部分到达不了它；回应所及恰是狼群、鹿与森林，有回应的比较在它们之间决定（`Trophic.within_response_iff`、`Trophic.responsive_comparison`）。`Loop` 中部分的动作改变另一个形成所识的，后者回应，差别回到部分自身的支持，而以扣留水平的比较看不到它（`Loop.returns`）。

**读法（AI 的，待 Ren）。**
- 一个动作有两种反事实。其余固定（P42）时只计部分直接到达的；其余经识回应时，计部分对经所识者影响的闭包。一个动作对与之相互作用的形成造成什么，在第二种之内决定。
- 升级回路是每一方都经其识回应、差别回到部分的情形（`Loop.returns`）。它不在其余固定的比较中出现。这对照 Ren 粘贴的框架中的军备竞赛回路（来源中的粘贴文字，作者未注明，不是 Ren 的话）。
- 只识支持时，回应所及就是 P42 的所及闭包之并。这给所及闭包一个反事实的意义：其余经其支持回应时，一个动作的差别所能到之处。
- 与因果系统的框架对照：干预改变的输入，其后果在其余经识回应时只沿“与所识者交换”传播；框架中的反馈，在这里是差别经他者的回应回到部分自身所识的。

**作者反审。**
1. **增量薄，部分近于定义。** 限定是 `alike_within_closed` 的实例；回应所及之外的区域封闭，是闭包定义的直接推论；主比较是 `comparison_within_difference` 接上 `not_differs_beyond_response`。实质的新内容是：把前提分离为 `RespondsThroughRegistration` 并说明其余固定是它的情形；回应所及与识闭包的对偶（经 `WithinClosure.converse`）；只识支持时与 P42 所及闭包的等价；以及两个见证。
2. **前提是给出的，而且强于所用的。** 经识回应要求部分之外的形成在识得相同之处与每个条件的交换都相同；它排除对未被识者的回应（例如 P49 `Attracting` 中什么都不识而随储量取用的取用者：按检视那里前提不成立，本模块没有另立定理）、噪声，以及没有表示为条件的外来输入。定律只在回应所及之外用到它，而且主比较只用到那些形成在它们所识的条件上的交换；更弱的前提已足够。这里给出的形式说的是其余怎样回应，不是极小的假设。
3. **回应所及经两个流画出。** 要知道它，须知第二个流与哪些条件交换（不须知数量）；所以它不使第二个流成为多余，只界定在前提之下第二个流能在哪里不同。其余固定时，扣留部分的流只在原流交换之处交换（`Flow.withhold_exchanges`，P49），回应所及就在原流中画出；这一点由那条引理直接可得，本模块没有另立定理。
4. **上界，不是到达。** 回应所及与 P42 的各闭包一样，在形成的层次上，不按时间先后：它不说差别到达其中的哪个形成，也不量差别多少。P42 的 `ReachesBefore` 按时间先后；回应所及的按时间先后的形式没有陈述。
5. **双重否定。** 覆盖“不在回应所及之外”在构造上强于覆盖“在回应所及之内”；可判定时两者相同（`comparison_within_response_of_decidable`）。有限的见证中可按情形判定（`Trophic.responsive_comparison` 经 `Trophic.within_response_iff`）。
6. **见证是最小的。** `Trophic` 中鹿有回应的流仍是给出的，这里只检查它满足前提。`Loop` 只有两个形成、一个动作、一次回应、一个回合：没有增益、放大，也没有超过一次的返回；`own` 使需要与观察重合，第二个形成经观察（水平）而不是经支持回应，其支持从不失去。P55 的记录要求定义回路（水平影响取用、取用又影响水平）并把失控陈述为定理；`Loop` 是比较中一个定义好的两方回路的见证，不是回路的一般定义，也没有失控的定理。
7. **辅助引理的位置。** `WithinClosure.converse` 与 `Flow.withinReach_iff_withinInfluence` 是关于 `Becoming.Feedback` 已有概念的一般事实，放在 Feedback 中更合适；已提请整合者决定。

**检查。**
- 模块在暂存区对 main 的核心编译，没有错误或警告；逐条审计全部 141 个常量，公理报告全部为空。证明都是项形式，没有用 `by decide`、`simp`、`omega` 或 `rw`。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T225632.916383Z。`Becoming.Response` 的 30 项定理全部空依赖；包共 2823 项定理、4112 项声明审计，核心闭包 57 个模块。外围桥接对这个核心重查，通过：回执 20261011T230225.829392Z。
- 尚无独立审查。

## 88. 机制与标准因果模型：承载规律的投影，作为过程的因果模型（P66、P68）

2026-10-12。Ren 问：“hows cause–effect system comparing to our theory?”，随后贴入一段关于因果系统的说明。那段文字的作者没有注明，读来是别处 AI 助手所写；它不是 Ren 的话，其中没有任何内容是本理论的前提。AI 作了比较之后，Ren 写道：“alright, looks like we can learn things from this comparison - think for one more round, what can we learn, being inspired, and improve?”；对 AI 的五项提议，Ren 答：“Great, let's finish all of them, you can spawn sub agents in a wise order if needed”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-cause-effect-comparison.md)）。本节是其中第三项（机制是一种分解）与第五项（标准因果模型作为过程），在工作板上认领为 P66 与 P68。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Mechanism`（L3），30 项定理，导入 `Becoming.Experiment`（经它导入 `Becoming.Joint`、`Becoming.Recurrence` 与 `Becoming.Frame`），已有模块中只改 P62 的 `Becoming.Capture`：它导入本模块，`Law.reform_reabsorbed` 改由 `Law.reabsorbed` 证明，名称与陈述不变（整合者的决定：一条定理，不是两条）。

成果记录新增两项：[projection-carrying-a-law](../../../../theories/becoming/results/records/projection-carrying-a-law.md)（P66）与 [causal-models-as-processes](../../../../theories/becoming/results/records/causal-models-as-processes.md)（P68）。

```text
Result(s): 复用 experiment-needs-return（FactorsThrough、Run.StepsThrough、Run.FixesThrough、Run.stepsThrough_of_factors、
           Run.Takes、Run.Fixes、retarget、retarget_determined、retarget_step、Run.not_fixes_of_untaken）、
           joint-difference-making（Determined：动作决定一步）、recurrence-without-premise（Law.orbit、Law.orbit_shift、
           Law.process、Law.run）；Becoming.Frame 的 Run；新增上列两项
Delta: 承载规律的投影：Image、factors_image、Image.least、GoAlike、image_determined_iff、carries_law_iff、goAlike_id_iff、
       goAlike_const、goAlike_image_iff、GoAlike.runs_agree。重新吸收：DependsOnlyOn、DependsOnlyOn.goAlike、
       DependsOnlyOn.reabsorbed、Law.dependsOnlyOn_iff、Law.reabsorbed。改变自身规则的系统：adaptive、
       adaptive_determined、adaptive_state_law_iff、adaptive_state_carries_iff、ruleLaw、ruleLaw_determined、Run.steps_by_rule。
       经投影而未取的：Run.TakesThrough、Run.stepsThrough_retarget、Run.not_fixesThrough_of_untaken、
       Run.not_fixesThrough_of_goAlike。标准因果模型（P68）：inputs、inputs_determined、trajectory、inputsRun、
       inputs_intervention_unfixed、inputs_model_fixes、forget、Run.forget、forget_inputs_determined_iff。
       见证：Coarse（process、not_determined、goAlike、carries）、Switching（follow、alternate、process、next、run、
       determined、not_goAlike、no_state_law）
Supplied premises / correspondence: 不加公理，也不加前提；相同者同去（GoAlike）与只依于（DependsOnlyOn）是被刻画的性质，
       不是假设，carries_law_iff 等是双向的；局部条件写在定理之中：runs_agree 与 reabsorbed 要相同的动作与经 π 相同的起点，
       not_fixesThrough_of_untaken 要某个确定过程容许经 π 读的各步、运行未取与两个不同的投影配置，
       inputs_intervention_unfixed 要未取与两个不同的配置，steps_by_rule 要规则在该段上保持；投影 π 与（状态，规则）的
       分解由运行之外给出；离散的步；x′ = F(x, u, ε) 与适应动力学的形式取自 Ren 贴入的文字（作者未注明，不是 Ren 的话，
       也不是前提）；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T225632.916383Z（Becoming.Mechanism 30 项定理，全部源声明公理报告为空），外围回执 20261011T230225.829392Z
Boundary: 实际展开经哪个投影承载规律、任何形成形成或使用一个投影、规则怎样开始改变、输入与噪声在实际展开中可分，都不推出；
          规律只指确定的过程，概率与随机过程没有陈述，不确定只以忘掉噪声的形式出现；多个变量之间的结构方程（图）、从观察
          识别因果、连续的量与敏感性没有陈述；不含伦理谓词
Integration: 计划 P66、P68；把 P53 的“关于何者无关的模型”（FactorsThrough）不加前提地刻画为相同者同去；把 P62 的
             Law.reform_reabsorbed（Becoming.Capture）改为 Law.reabsorbed 以规则为投影的实例，名称与陈述不变；
             把所贴框架的 F、u、ε 与 θ 放在脊柱上
```

| 声明 | 内容 |
|---|---|
| `Image`、`factors_image`、`Image.least` | 步骤经投影 π 读的像：P 的某一步以某动作从投影为 k 的配置到投影为 κ 的配置时，像中就有从 k 到 κ 的这一步；P 的步骤经 π 分解到它的像；像是步骤经 π 分解到的最小过程：每个这样的过程都容许像的每一步 |
| `GoAlike`、`image_determined_iff`、`carries_law_iff` | 相同者同去：经 π 相同的两个配置，以同一动作到达经 π 相同的配置；像确定，恰当相同者同去；投影承载规律：某个描述上的确定过程容许 P 的每一步经 π 读，恰当相同者同去。对每个过程与每个投影成立，不加前提 |
| `goAlike_id_iff`、`goAlike_const`、`goAlike_image_iff` | 经恒等，相同者同去就是确定性；不分任何东西的描述对每个过程都承载规律；描述可以复合：像的描述 ρ 承载规律，恰当复合的描述 ρ ∘ π 承载规律 |
| `GoAlike.runs_agree` | 相同者同去时，取相同动作、起点经 π 相同的两个运行，在每一步经 π 都相同：投影承载规律时，它所略去的从不改变投影的进程 |
| `DependsOnlyOn`、`DependsOnlyOn.goAlike` | 下一配置整个只依于 π：经 π 相同的两个配置以同一动作到达同一个配置；它蕴含相同者同去 |
| `DependsOnlyOn.reabsorbed` | 所不依者一步之内被重新吸收：只依于 π 时，取相同动作、起点经 π 相同的两个运行，从第一步起相等 |
| `Law.dependsOnlyOn_iff`、`Law.reabsorbed` | 确定的律作为过程只依于 π，恰当经 π 相同的配置下一步相同；这时它们的轨道从下一步起相同（`DependsOnlyOn.reabsorbed` 的实例）。配置读作状态与规则、以规则为投影时，就是 P62 的 `Law.reform_reabsorbed`（规则持有结果），`Becoming.Capture` 现以它一行证明 |
| `adaptive`、`adaptive_determined` | 改变自身规则的系统：状态 x 在规则 g 之下以动作 u 变为 F g x u，规则变为 G g x，配置是这一对；它是联合配置上的一个确定过程 |
| `adaptive_state_law_iff`、`adaptive_state_carries_iff` | 状态恰在规则对它不造成差别之处（对每两个规则、每个状态与动作，F 都相同）有自己的规律：经状态相同者同去；等价地，某个状态上的确定过程容许每一步经状态读 |
| `ruleLaw`、`ruleLaw_determined`、`Run.steps_by_rule` | 规则固定为 g 时状态自身的律，它是确定的；沿改变自身规则的系统的运行，在规则保持为 g 的一段上，状态的各步就是这条律的步 |
| `Run.TakesThrough`、`Run.stepsThrough_retarget` | 运行在某步之前于投影为 k 的配置取过某动作；未取时，把容许经 π 读的各步的过程在 k 处改送到任一投影配置，仍容许这些步 |
| `Run.not_fixesThrough_of_untaken`、`Run.not_fixesThrough_of_goAlike` | 经投影的规律在未取之处不被固定：某个确定过程容许经 π 读的各步、运行没有于投影为 k 的配置取过某动作、有两个不同的投影配置时，记录不固定它在 k 的任何结果；相同者同去时亦然（规律由像给出） |
| `inputs`、`inputs_determined`、`trajectory`、`inputsRun` | 标准模型 x′ = F(x, u, ε) 作为过程：动作是输入与噪声一起；它是确定的；从 x₀ 在输入 u 与噪声 e 之下的轨迹，以及作为运行的这条轨迹 |
| `inputs_intervention_unfixed`、`inputs_model_fixes` | 干预是未取的动作：运行在某步之前没有于 x 取 (u′, e′)、有两个不同的配置时，记录不固定它在那里的任何结果（`Run.not_fixes_of_untaken` 的实例）；模型把它送到 F x u′ e′，且只送到那里 |
| `forget`、`Run.forget`、`forget_inputs_determined_iff` | 忘掉动作第二部分的过程与运行；噪声是未表示的动作：忘掉噪声后，标准模型恰在噪声不造成差别之处仍确定 |
| `Coarse.process`、`Coarse.not_determined`、`Coarse.goAlike`、`Coarse.carries` | 配置有两部分，每步翻转第一部分，第二部分任意：动作不决定配置，而第一部分相同者同去，步骤经它分解为翻转的确定律：描述可以有整体没有的规律 |
| `Switching.follow`、`Switching.alternate`、`Switching.process`、`Switching.next`、`Switching.run`、`Switching.determined`、`Switching.not_goAlike`、`Switching.no_state_law` | 状态变为规则，规则每步翻转：联合过程确定，规则对状态造成差别；从状态与规则都为假出发的运行，没有状态上的确定过程容许它前两步（或任何更长一段）经状态读的步：改变自身规则的系统在状态上没有规律，它的规律在联合配置上 |

**它回答了什么。**
- **什么使一个投影成为机制。** P53 把步骤经投影分解为确定过程叫作关于何者无关的模型（§72），却没有说这样的模型何时存在。这里不加前提地回答：恰当相同者同去（`carries_law_iff`）。像是最小的候选（`Image.least`），所以一个描述是否承载规律，只看像是否确定（`image_determined_iff`）。经恒等它就是确定性（`goAlike_id_iff`）；描述的描述就是复合的描述（`goAlike_image_iff`）；投影承载规律时，它所略去的从不改变投影的进程（`GoAlike.runs_agree`）。
- **规律可以在描述上而不在整体上，反之亦然。** `Coarse` 中动作不决定配置，而第一部分承载翻转的确定律；`Switching` 中整体确定，而状态的描述没有规律。所以承载规律对描述变粗或变细都不单调。不分任何东西的描述总承载规律（`goAlike_const`），所以“某个描述上有规律”本身不是信息，内容在于哪个描述承载它。
- **所不依者被重新吸收。** 下一配置只依于 π 时，起点在 π 之外的差别一步之内消失（`DependsOnlyOn.reabsorbed`）。P62 B5 的“规则持有结果”是它以规则为投影的实例（`Law.reform_reabsorbed`，现由 `Law.reabsorbed` 证明）：重新吸收不是另一条规律，而是只依于的直接后果。
- **改变自身因果的系统不需要另一种规律。** 状态与规则一起前进的系统，是联合配置上的一个确定过程（`adaptive_determined`）。状态恰在规则对它不造成差别之处有自己的规律（`adaptive_state_law_iff`）；规则保持的一段上，状态按这条规则的律走（`Run.steps_by_rule`）；规则改变自己时，状态可以没有任何规律（`Switching.no_state_law`）。第一部分对每个过程陈述的规律，因此已经涵盖它。
- **真的机制也只在取过之处被固定。** 即使相同者同去，记录也不固定未取的投影配置上的结果（`Run.not_fixesThrough_of_goAlike`）：P53 的“未取的不被固定”经投影仍成立。经投影的实验所固定的，`Run.generalizes` 推广到投影相同的整个类，但只推广已取的。
- **标准因果模型在脊柱上的位置（P68）。** x′ = F(x, u, ε) 是动作为 (u, ε) 的确定过程（`inputs_determined`）。干预是未取的动作：记录不固定它（`inputs_intervention_unfixed`），模型固定它（`inputs_model_fixes`）。噪声是未表示的动作：忘掉它，过程恰在噪声不造成差别之处仍确定（`forget_inputs_determined_iff`）。`Becoming.Joint` 中冲击作为动作（`Shock`）与写进步骤（`Hidden`）的对照，是这一点的见证；这里对每个 F 陈述。

**读法（AI 的，待 Ren）。**
- 机制是承载规律的投影。P53 的“关于何者无关的模型”现在被精确刻画：经 π 读，与变化无关的，就是经 π 相同的配置之间的不同。
- 配置的投影（描述）是时间的读法与更细的量的单位之外的第三种东西：它读配置是什么，不读何时，也不读以什么单位计。较粗描述上的规律（涌现）就是那个描述上的相同者同去。
- 所贴文字说，有用的因果模型总是在某种抽象上构造的。这里，抽象是一个描述；它是否承载规律，恰由相同者同去决定，不由描述者决定。
- 改变自身因果的系统，是状态与规则的联合配置上的一个规律；规则对状态造成差别之处，状态单独没有规律。所贴文字说复杂适应系统能改变未来变化传播的机制：这里，被改变的“机制”是规则保持时状态的律（`ruleLaw`），改变它的是联合配置上的律，不是另一种更高的律。
- 干预是未取的动作，由模型而不由记录固定。`retarget` 是在一个配置与一个动作上替换一条结构方程。噪声是未表示的动作；`Coarse` 可以读作噪声被忘掉的过程：整体没有规律，因为第二部分由未表示的动作决定，而第一部分不依于它。
- 合于 §72 的读法：理 在那里是投影。这里说一个 理 何时承载规律：恰在它所不分的配置同去之处；它所不依的，被重新吸收。

**作者反审。**
1. **主定理近于定义。** `carries_law_iff` 与 `image_determined_iff` 的证明各只几行：相同者同去就是“像确定”展开写出。增量在于把 P53 由运行之外给出的模型刻画为一个配置上可查的条件，并给出最小的候选（`Image.least`）；它不是深的定理。
2. **“承载规律”只指确定的规律。** 有结构而不确定的规律没有陈述。`GenerativeCore` 的 `projection_exact_iff` 说的是另一种性质：经投影精确表示有限路径的可能性，要求从纤维中每个配置都能提升；相同者同去不蕴含它（像的一步可以只从纤维中的某一个配置可取）。两者之间的桥接没有陈述。
3. **重新吸收的定理很直接。** `DependsOnlyOn.reabsorbed` 是一步的论证。起初本模块另有一条与 P62 的 `Law.reform_reabsorbed` 陈述逐字相同的定理；按整合者的决定只留一条：本模块给一般的 `Law.reabsorbed`，Capture 的那条改为它以规则为投影的实例，名称与陈述不变。
4. **适应系统的形式取自所贴文字。** `adaptive` 中规则的更新 G 不依于动作，与所贴的 θ′ = G(θ, x) 相同；G 依于动作的系统同样是联合配置上的过程，`adaptive_state_law_iff` 只涉及 F，对它也会成立，但没有陈述。
5. **状态规律的判据是整体的。** `adaptive_state_law_iff` 要求规则在每一对规则、每个状态与动作上都不造成差别，包括任何运行都不经过的配置。沿一个运行只有经过的配置算数；沿运行的充要条件（到某步为止有确定过程容许经 π 读的各步，恰当经 π 相同、动作相同的两步到达经 π 相同的配置；构造性的）没有陈述，现在只有充分条件（`Run.steps_by_rule`）与一个见证（`Switching.no_state_law`）。
6. **见证是最小的。** `Switching` 只有两个位，规则每步翻转，所以 `Run.steps_by_rule` 在那里只覆盖单步；`Coarse` 的第二部分完全任意，所以整体没有任何规律。规则缓慢改变、状态在长段上有近似规律的情形没有陈述。
7. **P68 的增量主要是位置。** `inputs_intervention_unfixed` 是 P53 `Run.not_fixes_of_untaken` 的直接实例，`inputs_model_fixes` 按定义成立；实质的新陈述是 `forget_inputs_determined_iff`，也很短。Pearl 意义上多个变量之间的结构方程、do 演算、从观察数据识别因果，都没有陈述；这里的干预作用于整个动作 (u, ε)，对状态变量的“手术”只在读法上对应 `retarget`。
8. **没有概率。** 噪声在这里是动作中任何未表示的部分；ε 的分布、独立同分布、期望之类的陈述都不在其中。
9. **“机制”的读法比科学哲学的机制概念窄。** 机制哲学中的机制（例如 Machamer、Darden 与 Craver 2000：实体与活动经组织而产生有规律的变化）含有组成与组织；这里只取其中“在一个描述上有规律”这一面，是 AI 的读法。
10. **所贴文字不是 Ren 的话。** 它只作为比较的对象；x′ = F(x, u, ε) 与 θ 的形式取自它，但它的任何主张都不是本理论的前提，所贴文字关于整个宇宙、量子与复杂系统的说法这里都没有采用。

**检查。**
- 模块在暂存区对 main 的核心编译，没有错误或警告；逐条审计全部 63 个常量，公理报告全部为空；没有禁用的记号（sorry、axiom、Classical、native_decide）。`by decide` 只用于自然数字面量的比较（`Switching.no_state_law`）。改过的 `Becoming.Capture`（导入本模块，以 `Law.reabsorbed` 证明 `Law.reform_reabsorbed`）连同 `Becoming.Seeking` 与本包其余模块一起编译，没有错误或警告，公理报告为空。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T225632.916383Z。`Becoming.Mechanism` 的 30 项定理全部空依赖；包共 2823 项定理、4112 项声明审计，核心闭包 57 个模块。外围桥接对这个核心重查，通过：回执 20261011T230225.829392Z。
- 尚无独立审查。

## 89. 吸引：被吸入者不再回来，每个律恰吸入不返回者（P67）

2026-10-12。Ren 问：“hows cause–effect system comparing to our theory?”，随后贴来一段关于一般因果系统的说明。那段文字作者未注明，读来是别处的 AI 所写，不是 Ren 的话，也不是理论的前提。它把系统写作 x_{t+1} = F(x_t, u_t, ε_t)，列出反馈、改变自身规则的系统、路径依赖与吸引子。AI 把这一框架对应到脊柱上；Ren 又写“think for one more round, what can we learn, being inspired, and improve?”，AI 提出五项，Ren 答：“Great, let's finish all of them, you can spawn sub agents in a wise order if needed”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-cause-effect-comparison.md)）。五项是 AI 的提议，经 Ren 这句话认可；本节是其中第四项：吸引子与锁定就是合并。按[工作板](../../../BECOMING-WORKBOARD.md)认领为 P67。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Attraction`（L3），47 项定理，只导入 `Becoming.Recurrence`（经它导入 `Becoming.Frame`），不改任何已有模块。

成果记录新增一项：[attraction-is-not-returning](../../../../theories/becoming/results/records/attraction-is-not-returning.md)。

```text
Result(s): 复用 recurrence-without-premise（Law.orbit、Law.orbit_add、Law.orbit_shift、Law.orbit_mul、Law.Returns、
           Law.Reachable、Law.Lossless、Law.Merges、Law.KeepsPossibilities、Law.Returns.undo、Law.Returns.reachable、
           Law.Lossless.returns、Law.returns_iff_keeps、Law.returns_of_reachable、revisits_within、gap_of_lt、
           Law.succ_open、Law.pred_open、Law.process）；Becoming.Frame 的 Run、Run.reach、Reach、Invariant、
           Invariant.reach；新增上列一项
Delta: 吸引子与吸引域：Law.Absorbing、Law.DrawnInto、Law.Drawn、Law.Ahead、Law.absorbing_ahead、Law.Absorbing.orbit、
       Law.returns_iff_ahead。锁定：Law.DrawnInto.never_back、Law.Drawn.not_returns。主律：Law.drawnInto_ahead、
       Law.drawn_iff_not_returns。未来收窄：Law.reachable_absorbing、Law.reachable_orbit、Law.lost_drawn、
       Law.drawn_of_lost、Law.returning_absorbing。合并：Law.periods_meet、Law.Merges.not_both_return、Law.merge_draws、
       Law.Merges.draws、Law.none_drawn_merges_nothing、Law.none_drawn_lossless。有限多配置：Law.Drawn.not_lossless、
       Law.Lossless.not_drawn、Law.Drawn.not_keeps、Law.lossless_iff_none_drawn、Law.returns_iff_always_reachable、
       Law.drawn_iff_lost、Law.enters_returning、Law.drawnInto_returning。开放：Law.succ_drawn_lossless、
       Law.pred_orbit_zero、Law.pred_drawn_keeps。过程：Law.absorbing_iff_invariant、AbsorbingUnder、
       invariant_iff_every_move、Invariant.locks_out、Run.locked_in、Run.stays、Run.leaving_needs。
       见证：Ratchet（next、atTrue、merges、absorbing、false_drawn、false_never_returns、true_returns、true_not_drawn、
       false_lost）；Exit（move、process、atTrue、keeps、leaves、not_invariant、staying、locked_in、path、moves、leaving、
       leaving_takes）
Supplied premises / correspondence: 不加公理，也不加关于展开或变化之律的前提；主律对每个确定的律（next : S → S）成立，
       不用有限性，也不用可判定性；“某个列表持有每个配置”写进用到它的规律之内；可判定相等只是 none_drawn_lossless
       与 lossless_iff_none_drawn 的局部假设；被合并的两个配置中哪一个被吸入，正面选出需要判定，只陈述双重否定的形式；
       离散的步；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T225632.916383Z（Becoming.Attraction 47 项定理，全部源声明公理报告为空），外围回执 20261011T230225.829392Z
Boundary: 实际展开进入哪些区域不推出；吸引域多深多宽不陈述（配置上没有度量，也没有拓扑）；表示之外的逃逸不陈述：
          确定的律中没有来自其外的动作或交换，过程中只有它所容许的动作；不确定过程上的吸引（可能被吸入与必然被吸入）
          没有陈述；“被吸入”只要求存在一个吸收区域，不是经典意义上的吸引子；不含伦理谓词
Integration: 计划 P67（工作板）；Ren 认可的五项中的第四项（吸引子与锁定）；把 Becoming.Recurrence 的合并、丧失的可能
             与返回接到吸收区域、吸引域与锁定上，并在过程上以 Frame 的不变量陈述锁定
```

| 声明 | 内容 |
|---|---|
| `Law.Absorbing`、`Law.DrawnInto`、`Law.Drawn` | 吸收区域：律从不离开的区域；被吸入：配置在区域之外，其轨道进入区域，被吸入吸收区域者构成它的吸引域；配置被吸入：某个吸收区域把它吸入 |
| `Law.Ahead`、`Law.absorbing_ahead`、`Law.returns_iff_ahead` | 配置的前方：从下一步起轨道上的配置；前方是吸收区域；配置返回，恰当它在自己的前方 |
| `Law.Absorbing.orbit` | 一旦进入，永在其中：轨道在第 n 步进入吸收区域，此后每一步都在其中 |
| `Law.DrawnInto.never_back` | 被吸入者不再回来：配置在吸收区域之外，从其轨道进入区域的那一步起，以后没有一步是它自己 |
| `Law.Drawn.not_returns` | 被吸入的配置永不返回 |
| `Law.drawnInto_ahead`、`Law.drawn_iff_not_returns` | 每个律恰吸入不返回者：对每个确定的律，不加前提，配置被某个吸收区域吸入，恰当它不返回；不返回者被吸入自己的前方，在第一步进入 |
| `Law.reachable_absorbing`、`Law.reachable_orbit`、`Law.lost_drawn`、`Law.drawn_of_lost` | 未来收窄：n 步后可得者构成吸收区域；每条轨道在第 n 步都是 n 步后可得的；n 步后不可得的配置被吸入 n 步后可得者，在第 n 步进入；在某一步丧失的配置被吸入 |
| `Law.returning_absorbing` | 返回者构成吸收区域 |
| `Law.periods_meet`、`Law.Merges.not_both_return` | 两个周期相遇：a + (a + 1)·b 与 b + (b + 1)·a 是同一个数；被合并的两个配置不都返回，不需要有限性：两者都在共同的下一配置的轨道上，在同一步既是这一个又是那一个 |
| `Law.merge_draws`、`Law.Merges.draws` | 合并吸入其一：被合并的两个配置不都逃过被吸入；合并的律吸入某个配置，都只以双重否定陈述，哪一个被吸入需要判定 |
| `Law.none_drawn_merges_nothing`、`Law.none_drawn_lossless` | 没有配置被吸入时，被律归于一处的两个配置不是不同的（双重否定）；配置的相等可判定时，律不合并 |
| `Law.Drawn.not_lossless`、`Law.Lossless.not_drawn`、`Law.Drawn.not_keeps` | 列表持有每个配置时：有配置被吸入，律就合并，也就丧失一个可能；不合并的律不吸入任何配置 |
| `Law.lossless_iff_none_drawn` | 有限多配置之内吸引即合并：列表持有每个配置、相等可判定时，律不合并，恰当没有配置被吸入 |
| `Law.returns_iff_always_reachable`、`Law.drawn_iff_lost` | 列表持有每个配置时，配置返回恰当它在每一步都可得；所以配置被吸入，恰当它不在每一步都可得（从右到左不需要有限性） |
| `Law.enters_returning`、`Law.drawnInto_returning` | 列表持有每个配置时，每条轨道都进入一个返回的配置；所以每个不返回的配置都被吸入返回者的区域：有限多配置上的律，其吸引子是返回者，吸引域是其余一切 |
| `Law.succ_drawn_lossless`、`Law.pred_orbit_zero`、`Law.pred_drawn_keeps` | 开放的世界：往上数吸入 0 而不合并；往下数吸入 1，而每个数在每一步都可得。所以上面有限多配置的每条规律都需要它的列表 |
| `Law.absorbing_iff_invariant` | 确定的律的吸收区域，恰是它作为过程的不变量 |
| `AbsorbingUnder`、`invariant_iff_every_move` | 区域在某个动作下吸收：以该动作从区域内出发的每一步都留在区域内；区域是不变量，恰当它在每个动作下吸收 |
| `Invariant.locks_out`、`Run.locked_in` | 对每个过程：进入不变区域之后，其外的配置不再可达；运行从在不变区域内的一步起，以后没有一个配置是它曾在区域外时的配置 |
| `Run.stays`、`Run.leaving_needs` | 运行的每个动作都保持一个区域时，运行留在其中；离开区域需要一个不保持它的动作 |
| `Ratchet` | 每个配置都到 `true`：律合并 `false` 与 `true`，`{true}` 是吸收区域，`false` 被吸入它而永不返回，也在一步后不可得；`true` 返回，不被吸入 |
| `Exit` | 配置与动作都是一位：动作 `false` 保持配置，动作 `true` 翻转它。`{true}` 在动作 `false` 下吸收，在动作 `true` 下不吸收，所以不是不变量；只取 `false` 的运行留在 `{true}` 中，离开的运行所取的是不保持它的动作 |

**它回答了什么。**
- **吸引子与锁定，不加前提。** 比较中的“路径依赖”与“吸引子”在脊柱上是同一条规律：被吸入者不再回来（`Law.DrawnInto.never_back`）。对每个确定的律，配置被某个吸收区域吸入，恰当它不返回（`Law.drawn_iff_not_returns`）。锁定不需要任何关于律的前提，只需要配置不返回。
- **未来收窄。** n 步后可得者构成吸收区域（`Law.reachable_absorbing`）；到第 n 步丧失的每个可能都被吸入它，在第 n 步进入（`Law.lost_drawn`）。这把 `Becoming.Recurrence` 的“丧失的可能保持丧失”读成吸引：丧失的那一刻，配置就在一个吸收区域之外，其轨道进入它。
- **合并吸入其一。** 被合并的两个配置不都返回（`Law.Merges.not_both_return`），这不需要有限性；所以合并的律不让两者都逃过被吸入（`Law.merge_draws`）。工作板上的“合并给出一个有吸引域的吸引子”因此在任意多配置中成立，只是以双重否定的形式。
- **有限多配置之内吸引即合并，开放的世界把两者分开。** 列表持有每个配置时，有配置被吸入就有合并（`Law.Drawn.not_lossless`），相等可判定时两者等价（`Law.lossless_iff_none_drawn`）；返回者的区域是吸引子，吸引域是其余一切（`Law.drawnInto_returning`）。往上数吸入而不合并，往下数吸入而保留每个可能（`Law.succ_drawn_lossless`、`Law.pred_drawn_keeps`）。
- **过程中的锁定。** 对每个过程，进入不变区域之后，其外者不再可达（`Invariant.locks_out`、`Run.locked_in`）。区域不变，恰当每个动作都保持它（`invariant_iff_every_move`）；离开需要一个不保持它的动作（`Run.leaving_needs`），`Exit` 是最小的例子。

**读法（AI 的，待 Ren）。**
- 吸引子是一个吸收区域，其外的配置进入它；吸引域是被吸入者。路径依赖与锁定是同一条规律：被吸入者不再回来，所以轨道已到哪里，决定它还能成为什么。
- 有限多配置之内，吸引与合并相伴（经典逻辑下是一个等价）：有配置被吸入，恰在不同的配置归于一处，也就是一个可能永久丧失之处（`Law.Merges.loses`）。开放的世界可以不合并而吸入，例如往上数。
- 未来收窄：第 n 步可得者是吸收区域，每个丧失的可能都已被吸入它。合于 Ren 的“more future, not less”（`Becoming.Admission`），吸引子是展开收窄自己的未来。
- Capture 中规则所持的结果（P62，`Captured`）读作规则中的吸收区域：规则相同的配置构成律从不离开的区域；在其中，被改造的状态在第一步就被吸入规则所持的配置。
- Admission 的“终结是吸收态”（`Flow.unsupported_stays`）在流与网上、在其前提之下，读作没有成员被支持这一区域的吸收；两种表示之间的实例定理没有给出。
- “赢的元吸引子”读作展开轨道上的一个吸收区域：只有不保持这一区域的动作能从中出去。这一读法属于 AI，这里没有推出。

**作者反审。**
1. **主律近乎定义。** `Law.Drawn` 只要求存在一个吸收区域把配置吸入；从右到左所用的区域是配置自己的前方（`Law.Ahead`），它可以很大，例如往上数时 0 的前方是全部正整数。所以不加前提的主律说的是：被吸入恰是不返回。增量是把比较中的“吸引子”“路径依赖”“锁定”认同为不返回，以及这一认同的各个推论，不是一个新的动力学事实。经典动力系统的吸引子要求更多：吸引一个邻域，在某种意义上极小或不可分，有拓扑或度量；这些都不在这里。最接近经典者是有限多配置之内的 `Law.drawnInto_returning`：返回者的区域吸入其余一切。
2. **数学是复用的。** 有限集上的自映射，每条轨道最终是周期的；不是单射的自映射有不周期的点；被合并的两个点不都是周期点。这些作为复用的数学记入，不作为数学上的新发现。增量是：在脊柱上零前提、不用可判定性陈述；合并的规律不需要有限性；有限与开放的分界由见证标出。
3. **双重否定是实质的，不是措辞。** `Law.Returns` 是存在一个周期，一般不可判定；所以被合并的两个配置中哪一个被吸入，不能构造地选出（`Law.merge_draws`），“合并的律吸入某个配置”也只以双重否定成立（`Law.Merges.draws`）。可判定相等只用在 `Law.none_drawn_lossless` 与 `Law.lossless_iff_none_drawn`。
4. **主律只对确定的律。** 不确定的过程上，“可能被吸入”与“必然被吸入”分开，都没有陈述。对过程只陈述不变区域的锁定与离开所需的动作（`Invariant.locks_out`、`Run.leaving_needs`）；它们是 `Frame` 的不变量的直接推论，增量小。
5. **表示之外的逃逸没有陈述。** 确定的律已经包含所表示的一切；从其外来的动作或交换，就是另一个律。`Exit` 只说明：在所表示的动作之中，离开需要一个不保持该区域的动作。实际展开中有没有这样的动作、它从哪里来，不推出。
6. **见证是最小的。** `Ratchet` 与 `Exit` 都只有两个配置；没有给出吸引域的深浅与宽窄，也没有几个吸引子分割配置的例子。
7. **与 P53 的连接是读法。** 被吸入的配置不返回，按 `Becoming.Experiment`，在那里自己的动作若换一个会怎样不被记录固定。但确定的律只有一个动作，这一连接需要带动作的过程上的“被吸入”，没有陈述。

**检查。**
- 模块在暂存区对 main 的核心编译，没有错误或警告；逐条审计全部 83 个常量，公理报告全部为空。不用 `decide`、`simp` 或 `omega`；`periods_meet` 的算术只用前导中公理报告为空的引理（`Nat.succ_mul`、`Nat.add_left_comm`、`Nat.mul_comm`、`Nat.add_comm`）。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T225632.916383Z。`Becoming.Attraction` 的 47 项定理全部空依赖；包共 2823 项定理、4112 项声明审计，核心闭包 57 个模块。外围桥接对这个核心重查，通过：回执 20261011T230225.829392Z。
- 尚无独立审查。

## 90. 确切的名称：停止不能被否证（P58b）

2026-10-12。Ren（[原话](../../../../sources/15-codex-theory-conversations/2026-10-12-integrator-and-names.md)）：

AI 的读法（待 Ren 更正）：P58 与 P59 引入的名称暂时采用，条件是每个名称的 Lean 陈述恰是名称所说；P59 的重新奠定未被采用，“too dualist”与“局部”的读法也未被确认。逐个核对：`Decided`、`Indicates`、`Counts`、`CountsAcross`、`Flow.withImbalance`、所加关系项闲置（`Flow.balancesOn_iff_idle`）、`…_unrefuted` 一族与 `…_not_stopping` 一族说的恰是它们的陈述；平息（settles）一族不是：它们的陈述是双重否定，只说从某步起停止不能被否证，名称却说停止。对每个不上升的量找出那一步是全知原则，不能证明，所以限定须进入名称。按[工作板](../../../BECOMING-WORKBOARD.md)由整合者认领为 P58b，一次检查器运行。

```text
Result(s): 改名，不是新结果；space-and-its-parts 加 stop_unrefuted_iff，两项记录（space-and-its-parts、continued-change-needs-openness）
           的断言与别名改用新名
Delta: 六个引理改名，陈述与证明不变（见下表）。新增 stop_unrefuted_iff（Space，只用前导）：并非此后每一步之后，后来的发生都不能被
       否证，恰当从某步起不再发生不能被否证。每个改名的引理陈述左边，名称说右边，这一等价使二者是同一命题。
Supplied premises / correspondence: 无；名称的条件是 Ren 的（“as long as the proof has the exact meaning”），逐个核对与新名称是 AI 的
Evidence: 合并检查器回执 20261011T232354.807725Z（Space 63 项定理；2824 项定理、4113 项声明审计，全部源声明公理报告为空；核心闭包 57 个模块，包 55 个），
          外围回执 20261011T232716.311380Z
Boundary: 实际找出那一步需要有限全知原则（World.lpo_of_finite_ends、Listed.lpo_of_few、Web.lpo_of_ending，P58）；World.rests 名称说
          静止而陈述是生起与止息都不复现，比在某步归于静止弱，P58 之前已有，未改，留给 Ren；P59 的重新奠定未采用；尚无独立审查
Integration: 核心 Space、Openness、Decidedness 的名称与文档字符串；章节 §9 的两行、术语表与总数；统一计划；Lean README；清点工具的名称表
             与清点页；阅读条目；两项记录；工作板 P58b
```

**改名对照。**

| 原名 | 新名 | 陈述（不变） |
|---|---|---|
| `falls_settle` | `falls_stop_unrefuted` | 从 `T` 起不上升的量：并非此后每一步之后，再有下降都不能被否证 |
| `amount_settles` | `amount_still_unrefuted` | 同一个量从某步起不变，不能被否证 |
| `Web.generation_settles` | `Web.generation_stops_unrefuted` | 从 `T` 起被平衡与耗散的家族：并非此后每一步之后，体现的成员再有生起都不能被否证 |
| `Flow.change_settles` | `Flow.change_stops_unrefuted` | 所立者的普查之下、跨每步下降不被否证时：并非此后每一步之后，再有立着的变化都不能被否证 |
| `World.arising_settles_from` | `World.arising_stops_unrefuted_from` | 同上而生起者体现：并非此后每一步之后，再有生起都不能被否证 |
| `Listed.few_of_settled` | `Listed.few_of_stop_unrefuted` | 每步被列出、开始成立从某步起停止不能被否证（假设 `settled` 改称 `stopping`）：曾成立者不是无界多 |

**为什么这样命名。** 核心已有 `…_unrefuted` 一族（如 `World.arising_unrefuted_covering`），说“不能被否证”。新名把限定放进名称：`falls_stop_unrefuted` 读作“下降停止，不能被否证”。`stop_unrefuted_iff` 证明双重否定的两种写法等价，所以名称所说（从某步起停止不能被否证）与陈述（并非此后每一步之后再发生都不能被否证）是同一命题。术语“平息／settles”改为“停止不能被否证／stopping unrefuted”。

**作者反审。**
1. **改名是否改变了定理？** 没有：陈述与证明不变，只加一个等价引理；Space 由 62 项定理增至 63 项即此引理。
2. **`Listed.few_of_stop_unrefuted` 的假设没有起点。** 它是起点为 0 的情形，`0 ≤ N` 总成立；文档字符串如此注明。
3. **为什么不把陈述改成右边的形式？** 两种形式等价；改陈述会动到用它们的证明，而 Ren 的条件是证明有确切的意义，等价引理满足它而不改证明。
4. **`World.rests`。** 名称说静止，陈述是 ¬ 复现，比在某步归于静止弱；这是 P58 之前的名称，未改，留给 Ren。

**检查。** 改动的三个模块先在暂存树中从前导编译；合并检查器回执 20261011T232354.807725Z：2824 项定理、4113 项声明审计，公理报告全部为空；外围桥接对这个核心重查，通过：回执 20261011T232716.311380Z。

**边界。** 只改名称与文档字符串，加一个等价引理；历史文字（§84、工作板、冻结的落地包、来源与记录的历史条目）保留旧名作为历史。尚无独立审查。

## 91. 一个展开与它的读法：过程与框架从世界一侧陈述（P69）

2026-10-12。Ren 问：“what is our current math core? why is it so?”；对 AI 关于 L0（`Process`）与 L1（`Frame`）的说明，Ren 问：“is this dualistic?”。AI 答：部分是。它们不设主体与客体，但其形式把四种分割当作给定：配置与取自另一字母表的动作、先于所支配历史的律、从配置读出的主张、先于其间关系的配置；`World`（`Becoming.Space`）不取其中任何一个。AI 提议从 `World` 重述这四种分割并给出桥接定理，`GenerativeCore` 不变。Ren 答：“yes, put it on the board and start”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-relational-starting-point.md)）。同一对话的另一分支（“Current math core (fork 2)”）继续问为什么是状态与动作；对“律与历史是同一展开的两种读法，律从展开读出，不是置于其上”这一读法，Ren 写道：“let's go back to main track, yes, i do agree with your reading, there are no two realities”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-no-two-realities.md)）。那个分支把 18 条检查过的定理（只用前导，公理报告为空）交给本项（[证据](../history/root-foundation/development/becoming-p69-shape-evidence/README.md)）；其中与本项重叠者本模块已有更一般的形式，其余五组在本模块的定义上重述（死路、拼接、保留的历史、部分之间的共享动作、水平与交换）。另一分支（“Current math core (fork)”，回答 Ren 关于框架与成对的问题）交来对一个确定的律检查过的 `MakesSense`；本模块对有分支、带主张的框架重述它。本节在工作板上认领为 P69。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Unfolding`（L3），67 项定理，导入 `Becoming.Mechanism`（P66）与 `Becoming.Space`，不改任何已有模块；外围桥接 `Becoming.Bridge` 新增一节，导入 `ExplanatoryBranching`。

成果记录新增两项：[process-and-frame-as-readings](../../../../theories/becoming/results/records/process-and-frame-as-readings.md)（前三项分割）与 [configurations-alike-by-relation](../../../../theories/becoming/results/records/configurations-alike-by-relation.md)（第四项）。

```text
Result(s): 复用 space-and-its-parts（World、Flow.Balances、Flow.BalancesOn、Web.Arises）、projection-carrying-a-law
           （carries_law_iff、goAlike_id_iff、GoAlike.runs_agree）、experiment-needs-return（keepHistory、keepHistory_new）、
           joint-difference-making（Determined）、coming-and-ceasing-keep-pace（ComesToBe、CeasesToBe、Recurs、
           coming_recurs_iff）；Becoming.Frame 的 Run、Trace、Novel；GenerativeCore 的 productProcess；核心共用的
           total（Generation）与 add_right_cancel（Dependence）；桥接中 RelationalDynamics 的 Deeper.Bisimulation 与
           static_toggle_one_dynamics、ExplanatoryBranching 的 Bisimulation、Same 与 bisimulation_implies_same；
           新增上列两项
Delta: 动作在配置之内：withMove、Run.toWithMove、Run.ofWithMove、Run.ofWithMove_toWithMove、Run.toWithMove_ofWithMove、
       withMove_open、withMove_determined_iff、closedBy、closedBy_withMove、closedBy_determined、closedBy_runs_agree、
       unlabelled、unlabelled_product_le、Fork（Pos、Way、Steps、law、label_couples）。世界的动作是交换：Exchange、
       Exchange.taken、Exchange.given、exchange、World.move、World.balances_iff_exchange、World.exchange_step_iff、
       World.exchangeRun、exchange_agrees、exchange_runs_agree、Circulation（one、round、idle、
       standings_leave_exchange、start_needed）。历史与它所显示的律：Shown、Shown.run、shown_le_iff、Consistent、
       shown_determined_iff、exists_law_iff、Shown.agrees、Run.shown_le；对应何处不是同一：eq_of_new、Shown.runs_of_new、
       Run.keepHistory_shown、Splice（history、loop、loop_step、spliced）、DeadEnd（law、no_history）。主张是关系项：
       Frame.world、Frame.world_active、Frame.arises_iff、Frame.novel_iff_arises、Frame.claims_recur_iff、
       Frame.configurations、Frame.world_fixes_run。配置由它怎样关系而定：Bisimulation、Alike、Bisimulation.eq、
       Bisimulation.converse、Bisimulation.comp、Alike.refl、Alike.symm、Alike.trans、Alike.realized、Alike.step、
       Bisimulation.trace、Alike.trace、Alike.tests、DeterminedAt、Determined.at、DeterminedAt.transfer、
       DeterminedAt.goAlike、Twins（Config、frame、one、not_determined、one_determined、bisimulation、left_alike_right、
       successor_not_start、bisimulation_one、alike_one、naming_senseless）、MakesSense、makesSense_iff、
       MakesSense.unique、MakesSense.carries、makesSense_id_iff、Law.registered、Law.registered_determined、
       Law.SameFuture、Law.alike_future、Law.sameFuture_bisimulation、Law.alike_iff_sameFuture、Law.MakesSense.carries、
       exchangeFrame、exchange_pointwise_bisimulation、
       exchange_alike_of_pointwise、exchange_pointwise_of_alike、exchange_alike_iff、exchange_determinedAt。
       桥接（外围）：Frame.unclaimed、deeper_bisimulation_iff、static_toggle_alike、Frame.ofModel、
       branching_bisimulation_iff、Alike.same
Supplied premises / correspondence: 不加公理，也不加前提；exists_law_iff、shown_determined_iff、withMove_determined_iff、
       Alike.tests 与 exchange_alike_iff 是双向的，对每个过程、每个序列或每个框架成立；局部条件写在定理之中：
       closedBy_runs_agree 要确定的律与相同的起点，exchange_runs_agree 要相同的动作与在每个关系项上相同的起点，
       Shown.runs_of_new 要序列从不重访，Frame.novel_iff_arises 要一步之后的配置记录此前的实现，
       Frame.claims_recur_iff 要有限且每步可判定的主张；把动作读入配置、形成动作的策略与交换之律都是给出的读法；
       离散的步与共同的步序（表示的承诺）；读法除 Ren 确认的一项外是 AI 的，待 Ren
Evidence: 合并检查器回执 20261011T235410.578553Z（Becoming.Unfolding 67 项定理，全部源声明公理报告为空），外围回执 20261011T232716.311380Z
Boundary: 共同的步序不由关系推出；动作在展开之内形成与否、由什么形成，一个形成把它的历史读作显示哪条律，都不推出；
          经同样检验的配置相同（需要分支条件）与第一部分以 Determined 陈述的定理在相同之下成立，都没有陈述；
          GenerativeCore 不变，过程在 Lean 中仍先于世界陈述，这里给出的是读法、两个方向的定理与桥接，不是另一个基础；
          规律只指确定的过程，概率没有陈述；不含伦理谓词
Integration: 计划 P69；回答 Ren 的“is this dualistic?”；按 Ren 2026-10-12 对律与历史之读法的确认（“there are no two
             realities”）记录其一项读法；把零前提计划 §1.2 b(5)（以逐点性质代替函数外延性）读作水平的关系的同一；
             把外围的关系的同一（RelationalDynamics，2026-10-06；ExplanatoryBranching）经桥接认同为核心的；
             重述分支“Current math core (fork 2)”交来的五组定理与分支“Current math core (fork)”的 MakesSense
```

| 声明 | 内容 |
|---|---|
| `withMove`、`Run.toWithMove`、`Run.ofWithMove`、`Run.ofWithMove_toWithMove`、`Run.toWithMove_ofWithMove` | 动作读入配置：配置是（配置，动作）这一对，律只有一个标签；P 的运行与它的运行是同一个运行的两种读法，来回读不变 |
| `withMove_open`、`withMove_determined_iff` | 动作读入配置后，律留开下一个动作：到某个配置的一步容许每个下一个动作；它确定，恰当 P 确定且 P 取一步之处只有一个动作 |
| `closedBy`、`closedBy_withMove`、`closedBy_determined`、`closedBy_runs_agree` | 动作在展开之内由配置的一个策略形成：下一个动作是策略对下一个配置所作的；每一步都是动作留开时的一步；确定的律仍确定；从同一配置出发的两个运行每一步都相同（经 `GoAlike.runs_agree`，以恒等为投影） |
| `unlabelled`、`unlabelled_product_le`、`Fork.label_couples` | 忘掉动作的过程；忘掉 `productProcess` 中联合一步的动作，留下各部分忘掉动作后的一步；`Fork` 中两个按同一律分岔的部分，共享动作时不能同时走不同的路，各自先忘掉动作时能：共享的动作是部分之间的一种关系 |
| `Exchange`、`Exchange.taken`、`Exchange.given`、`exchange` | 在场的关系项跨一步取与给什么，读作动作；交换之律：每个关系项在一步之后的水平连同从它被取的，等于之前的水平连同给它的 |
| `World.move`、`World.balances_iff_exchange`、`World.exchange_step_iff`、`World.exchangeRun` | 世界从第 t 步起的动作是其关系项的交换；世界平衡恰当其水平以交换为动作按交换之律运行（按定义）；跨一步，恰当它在那里的每个家族上平衡；平衡的世界是这条律的运行 |
| `exchange_agrees`、`exchange_runs_agree` | 交换之律固定一步之后的每个水平；动作相同、起点在每个关系项上相同的两个运行，每一步在每个关系项上都相同：经过从一个起点固定所立 |
| `Circulation.standings_leave_exchange`、`Circulation.start_needed` | 一个关系项立于一：一次自取自给的循环与没有交换留下同样的水平，所以所立不固定交换；没有交换时立于零与立于一都是动作相同的运行，所以经过只从一个起点固定所立 |
| `Shown`、`Shown.run`、`shown_le_iff`、`Run.shown_le` | 一段历史（配置序列与动作序列）所显示的律恰有它的各步；历史是它的运行；它是历史为其运行的最小的律；运行所显示的律在运行的律之内 |
| `Consistent`、`shown_determined_iff`、`exists_law_iff`、`Shown.agrees` | 历史一致，指它从不以同一动作把同一配置带到两处；所显示的律确定，恰当历史一致；恰在这时有确定的律容许这段历史（经 `carries_law_iff` 与 `goAlike_id_iff`）；容许它的每个确定的律在它的各步上与它相同 |
| `eq_of_new`、`Shown.runs_of_new`、`Run.keepHistory_shown` | 每一步都新的历史不两次遇到同一配置；这时它所显示的律从它的某个配置出发的每个运行，都是从那里起的这段历史；所以保留历史的运行所显示的律只容许它 |
| `Splice.history`、`Splice.loop`、`Splice.loop_step`、`Splice.spliced` | 历史 0、1、0、2、2、…重访起点；在 0 与 1 之间往返的序列的每一步都是历史走过的一步，它是所显示之律的运行，而从任何一步起都不是这段历史 |
| `DeadEnd.law`、`DeadEnd.no_history` | 从假到真的一步，真处没有延续：律有一步，而没有任何运行 |
| `Frame.world`、`Frame.world_active`、`Frame.arises_iff` | 沿运行的框架读作一个世界：关系项是主张，恰在实现处活跃，没有流、没有立着、依存或汲取；主张的生起就是它开始被实现 |
| `Frame.novel_iff_arises`、`Frame.claims_recur_iff` | 一步之后的配置记录此前实现了什么时，某种读法的主张在该步之后是新的，恰当有一个跨这一步生起；有限、每步可判定的主张中，开始被实现复现恰当不再被实现复现（`coming_recurs_iff`） |
| `Frame.configurations`、`Frame.world_fixes_run` | 以“配置是这一个”为主张；两个运行的世界在活动上相同，它们每一步都相同：每个运行是一个世界，世界固定运行 |
| `Bisimulation`、`Alike` | 两个框架之间的互模拟：被联系的配置实现同样的主张，任一方的每一步由另一方以同一动作到被联系配置的一步相配；有互模拟联系的配置相同 |
| `Bisimulation.eq`、`Bisimulation.converse`、`Bisimulation.comp`、`Alike.refl`、`Alike.symm`、`Alike.trans` | 相等是互模拟，逆与复合仍是；相同是等价关系，作为关系陈述（商需要 `Quot.sound`） |
| `Alike.realized`、`Alike.step`、`Bisimulation.trace`、`Alike.trace`、`Alike.tests` | 相同的配置实现同样的主张，一步彼此相配，每个动作序列到相同的配置；通过同样的检验：一个动作序列之后的一个主张 |
| `DeterminedAt`、`Determined.at`、`DeterminedAt.transfer`、`DeterminedAt.goAlike` | 在 s 处相同之下确定：同一动作的任何两个结果相同；确定的框架处处如此；它沿相同传递；它成立时同一动作把相同的配置带到相同的配置 |
| `Twins.frame`、`Twins.one`、`Twins.not_determined`、`Twins.one_determined`、`Twins.bisimulation`、`Twins.left_alike_right`、`Twins.successor_not_start`、`Twins.bisimulation_one`、`Twins.alike_one` | 起点以一个动作有两个后继：两个后继相同，框架不确定；它的起点与只有一个后继、确定的框架的起点相同；所以作为相等的确定性依赖于配置怎样命名，相同之下在起点处确定 |
| `MakesSense`、`makesSense_iff`、`MakesSense.unique` | 描述有意义，指它恰把相同的配置等同；它有意义，恰当被它等同这一关系是互模拟且它等同每一对相同者；有意义的描述等同同样的配置 |
| `MakesSense.carries`、`makesSense_id_iff`、`Twins.naming_senseless` | 框架处处相同之下确定时，有意义的描述承载规律（经 `carries_law_iff`）；以配置自身命名有意义，恰当相同的配置是同一个；双胞胎的命名没有意义 |
| `Law.registered`、`Law.registered_determined`、`Law.SameFuture` | 确定的律经一个识读作框架：主张是所识者；它是确定的；两个配置所识的未来相同，指沿律的每一步所识相同 |
| `Law.alike_future`、`Law.sameFuture_bisimulation`、`Law.alike_iff_sameFuture`、`Law.MakesSense.carries` | 确定的律下，配置相同恰当所识的未来相同（两个方向：相同推出未来相同；未来相同是互模拟）；这时有意义的描述承载规律 |
| `exchangeFrame`、`exchange_pointwise_bisimulation`、`exchange_alike_of_pointwise`、`exchange_pointwise_of_alike`、`exchange_alike_iff`、`exchange_determinedAt` | 交换之律经“某个关系项立于某量”读；在每个关系项上相等是互模拟；水平相同恰当在每个关系项上相等；这条律在每个水平处相同之下确定 |
| 桥接：`Frame.unclaimed`、`deeper_bisimulation_iff`、`static_toggle_alike` | 没有主张的框架；`RelationalDynamics` 的 `Deeper.Bisimulation` 就是核心的互模拟；2026-10-06 的关系读法是实例：`static` 与 `toggle` 中一方的每个配置都与另一方的每个配置相同 |
| 桥接：`Frame.ofModel`、`branching_bisimulation_iff`、`Alike.same` | `ExplanatoryBranching` 的模型是以其条件为主张的框架；它的互模拟就是核心的；相同的配置通过每个分支检验，否定与合取在内 |

**它回答了什么。**
- **动作是展开的一部分。** 带标签的过程把动作取自另一个字母表。动作读入配置时，没有失去什么：运行是同一个运行的两种读法（`Run.toWithMove`、`Run.ofWithMove`）。失去的是确定性的一部分：律留开下一个动作（`withMove_open`），确定恰当原来确定且每步只有一个动作（`withMove_determined_iff`）。所以“外来的动作”就是律所留开的。动作由配置的策略形成时，律重新确定，从同一配置出发的运行处处相同（`closedBy_runs_agree`）：所做不同，就是所是不同。部分之间，共享的动作是一种关系；先忘掉它，两个部分就能分开走（`Fork.label_couples`）。世界的动作本来就在世界之中：关系项的取与给（`World.move`），平衡就是按交换之律运行（`World.balances_iff_exchange`）。交换与所立彼此不可互换：交换从一个起点固定所立（`exchange_runs_agree`），所立不固定交换，没有起点交换也不固定所立（`Circulation`）。
- **历史固定它所显示的律。** 每段历史都是一条律的运行，即它所显示的律，最小的那一条（`Shown.run`、`shown_le_iff`）。有确定的律容许它，恰当它一致（`exists_law_iff`）。所以先于历史给出律，所多出的只是未取的动作，记录不固定它们（`Run.not_fixes_of_untaken`）。对应不是同一，在两个方向上都有所失：律可以有一步而没有历史（`DeadEnd.no_history`）；历史重访之处，它所显示的律容许它没有走过的历史（`Splice.spliced`）。保留历史时对应合上：所显示的律只容许这段历史（`Run.keepHistory_shown`），代价是 `Becoming.Recurrence` 所说的从不返回。
- **主张是关系项。** 沿运行的框架是一个世界，主张是其关系项，实现是其活动（`Frame.world`）。新实现就是生起（`Frame.novel_iff_arises`），所以活动的规律对主张成立：有限、可判定的主张中，开始被实现复现恰当不再被实现复现（`Frame.claims_recur_iff`）。以配置为主张时，每个运行是一个世界，世界固定运行（`Frame.world_fixes_run`）。
- **配置由它怎样关系而定。** 相同由互模拟刻画（`Alike`）：实现同样的主张，以同样的动作到相同的配置。相同的配置通过同样的检验（`Alike.tests`）。外围早有这种同一：2026-10-06 的关系读法（`RelationalDynamics`）与 `ExplanatoryBranching` 的分支检验；桥接证明两者就是这一个（`deeper_bisimulation_iff`、`branching_bisimulation_iff`、`Alike.same`）。那里发现“状态不变”读的是载体的相等（`unchanged_reads_carrier_identity`）；作为相等的确定性也如此：双胞胎的两个后继在每个关系上相同，与一个确定的框架相同，而它自身不确定（`Twins.alike_one`）。相同之下的确定性沿相同传递（`DeterminedAt.transfer`）。交换之律下，水平相同恰当在每个关系项上相等（`exchange_alike_iff`）。一个描述何时有意义：恰把相同者等同（`MakesSense`、`makesSense_iff`）；这样的描述在等同什么上唯一（`MakesSense.unique`），框架相同之下确定时它承载规律（`MakesSense.carries`）。所以承载规律不足以有意义：不分任何东西的描述总承载规律（`goAlike_const`），却只在一切配置都相同时有意义；以配置自身命名有意义，恰当相同者是同一个（`makesSense_id_iff`），双胞胎的命名不然。对确定的律经一个识读，相同就是所识的未来相同（`Law.alike_iff_sameFuture`）：互模拟在这里化为分支所交的 `SameFuture`。

**读法。** 对“律与历史是同一展开的两种读法，律从展开读出，不是置于其上”，Ren 写道：“yes, i do agree with your reading, there are no two realities”。其余读法是 AI 的，待 Ren：
- `World` 是核心的起点。带标签的过程是把配置分为律所固定者与所留开者的读法，框架是经主张读的世界。两个方向都已证明：每个运行连同其主张是一个固定它的世界，每个世界是它所显示之律的运行，平衡时也是交换之律的运行。两种读法都不是对方的根据；先陈述世界，是因为它的关系在一类关系项之间。
- 行动不是展开之外的第二种原因。外来的动作所给出的，是律所留开的；动作的形成一旦被表示，它就是配置之所是的一部分，变动自己的行动就是变动配置之所是。
- 律不先于它所支配者（Ren 确认的读法）：历史所显示的律就是读作关系的历史，世界的截面序列也在内；步骤更多的律，是关于未取动作的模型。律与历史之间的差别是记忆：律从所在之处回答，不从怎样来到那里回答。
- 认识在展开之内：主张与任何东西一样，在同样的规律下开始与不再成立。
- 配置的名字，像关系项的名字（`Becoming.Identity`）一样，不承载任何东西；能查明的，对相同的配置都一样。交换之律下，在每个关系项上相等就是相同；所以零前提计划以逐点性质代替函数外延性的承诺（§1.2，b(5)）陈述的是水平的关系的同一，函数外延性只会再加上相同的水平是同一个。

**作者反审。**
1. **多数定理近于定义。** `World.balances_iff_exchange`、`Frame.world_active`、`Frame.arises_iff` 是 `Iff.rfl`；`Shown.run`、`shown_le_iff`、`withMove_open` 各只一两行。增量在于两个方向都证明、对应何处不是同一（死路与拼接）、对应合上的代价（保留的历史），以及确定性对命名的依赖；内容主要在读法与这些边界中，不在任何一条深的定理中。
2. **起点的次序是读法，不是编译的次序。** `GenerativeCore` 不变，`Process` 仍在 L0 定义，先于 `World`。本模块证明的是：过程与框架都可以从世界一侧读出，世界也可以从过程一侧读出（`World.exchangeRun`、`Shown.run`）。它没有把核心改写成从 `World` 定义 `Process`；那样做要么重写全部模块，要么只是改名。说“起点是 World”是陈述的次序与读法，Ren 的确认只针对律与历史的读法。
3. **交换之律自身是带标签的过程。** `exchange R` 的配置是水平，动作是交换，形式上又是一个标签。不同在于：这个标签是世界自己记录的关系项之间的取与给（`World.move`），不是外来的字母表；它也可以经 `withMove` 读入配置。`Circulation` 说明它不是多余的：只看水平，看不出交换。所以世界在一步的配置是所立与交换一起。
4. **`Frame.world` 是薄的。** 主张成为关系项，但没有流，没有依存，主张之间的关系没有陈述。它说明主张可以是关系项、活动的规律对它们成立，没有说明主张之间怎样相互依存。
5. **死路依赖于运行是无穷的。** `Run` 以自然数为索引，所以走进死路的一步不在任何运行上；若把有限的历史也算作历史，死路就有历史。`DeadEnd` 所示的“律到历史有所失”部分是表示的事实，作者如实记入，不读作动力学的发现。
6. **拼接是相对于把律读作步骤集合的。** 所显示的律只记“从哪里以什么到哪里”，所以重访处可以拼接；保留历史的律不能。两者都是律，差别在配置中记了多少：这正是“差别是记忆”的读法，不是另一个结果。
7. **作为相等的确定性没有被替换。** 第一部分大量定理以 `Determined`（相等）陈述，例如合并与丧失可能（`Becoming.Recurrence`）；合并本身就是两个配置到同一个，它在相同之下是否仍是同一个陈述，没有检查。`DeterminedAt` 只给出定义、传递与见证。
8. **相同不取商，并且只比较同类的框架。** 核心没有 `Quot.sound`，所以“相同的配置是同一个”不是这里的陈述；有意义的描述是给出的，它存在没有陈述：以“与哪些相同”描述每个配置，要函数外延性与命题外延性才有意义；互模拟只比较动作与主张类型相同的框架。经同样检验推出相同（外围在像有限时有，用经典逻辑）没有在核心中陈述。
9. **分支交来的定理是重述，不是新的独立结果。** `Fork.label_couples`、`Splice.spliced`、`DeadEnd.no_history`、`Run.keepHistory_shown`、`Circulation` 在“Current math core (fork 2)”的 `Shape.lean` 中已检查（自带极小定义）；这里在核心的定义上重述，`past_meet` 的内容由 `Shown.runs_of_new` 与 `keepHistory_new` 给出。`idle_reach`、`law_has_content` 与 `still_coarse_moving_fine` 没有重述：第一项回答 Ren 关于加一个变量的问题，后者由 `Becoming.Sampling` 处理粒度。`MakesSense` 取自分支“Current math core (fork)”的 `Saying.lean`（那里对一个确定的律以未来的识定义，同一的轨迹形式是定义、余归纳是定理；这里以互模拟定义，两者在一个确定的律上的对应由 `Law.alike_iff_sameFuture` 给出）；`SameAhead`（从一段所识的展开导出状态，不给配置类型）只在此提及，没有重述；那个文件的其余部分（分离与矩形、对角线与展开、语境性）不属于 P69，没有并入。
10. **Ren 的确认是在另一个分支上、对一种读法作出的。** 它不证明任何东西，也不是对本模块的认可；本模块的其余读法待 Ren。

**检查。**
- 模块在暂存区对 main（ae17922a）的核心与 P64–P68 包（413d8543 之后的 `Becoming.Mechanism` 与改过的 `Becoming.Capture`）编译，没有错误或警告；逐条审计全部 246 个常量（含编译器生成的辅助常量），公理报告全部为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。`by decide` 只用于自然数字面量的比较（`Splice.spliced`、`Circulation.start_needed`）；不用 `simp`、`omega`，相消用核心的 `add_right_cancel`。
- 桥接一节放进 main 的 `Becoming.Bridge`（加导入 `ExplanatoryBranching`，经它多 7 个继承模块，都有已通过的回执），对含本模块的根模块编译，没有错误或警告，122 个常量的公理报告全部为空。一个同时导入根模块、P64–P68 的四个模块、本模块与桥接的文件编译通过，所以没有名称冲突。
- 合并检查器在落地队列中检查一次，通过：回执 20261011T235410.578553Z。`Becoming.Unfolding` 的 67 项定理全部空依赖；包共 2895 项定理、4222 项声明审计，核心闭包 58 个模块。外围桥接对这个核心重查，通过：回执 20261011T232716.311380Z。
- 尚无独立审查。

## 92. 学习：归纳、推广、训练与元层次（P73、P74）

2026-10-12。Ren 问：“how complete are we at explaining meta level? can we explain artificial neuron networks? can we explain cognition? do we have complete wisdoms about learning?”。AI 答四者都未完成，称归纳问题（“关于何者无关的模型何时正确”）尚未消解，并提出三步：损失作为选择者（P64 用于训练）、把习得链与连接主义模型接到脊柱上的实例定理、推广作为规律。Ren 答：“please, fully complete, 我觉得理更像是对结构和变化的规律的建模 finish wisdom root, and resolve the undissolved”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-learning-wisdom-root-and-induction.md)）。本节是这三步，在工作板上认领为 P73（核心）与 P74（外围桥接）；智慧之根（P75）见 §93。它不加公理，也不加每条规律所写条件之外的前提，属于第一部分。核心新增模块 `Becoming.Learning`（L4），75 项定理，导入 `Becoming.Mechanism`（P66）与 `Becoming.Selection`（P64），不改已有模块。外围桥接 `LearningCorrespondence`（Lean 4.30.0-rc2 与 Mathlib）导入它与既有的 `CompositionalAcquisition`、`UpdaterConsequences`，核心不导入它。

理的读法依 Ren：理是对结构与变化之规律的建模。它取代 AI 在 §70 中的读法（“对识负责的模型”）；两者不相对立：按 Ren 的读法，模型仍只经识被检验（§70）。

成果记录新增两项：[learning-by-refutation](../../../../theories/becoming/results/records/learning-by-refutation.md) 与 [generalization-through-lumping](../../../../theories/becoming/results/records/generalization-through-lumping.md)。

```text
Result(s): 复用 testing-within-registration（Web.tail_unrefuted、Web.RegistersAlikeUpTo、Web.SelectsThrough 的识）、
           experiment-needs-return（Run.not_fixes_of_untaken、FactorsThrough）、projection-carrying-a-law（GoAlike、
           carries_law_iff、adaptive、adaptive_state_law_iff、Run.not_fixesThrough_of_goAlike）、
           selection-through-registration（Web.SelectsThrough）、recurrence-without-premise（Law.orbit、Law.process、
           revisits_within、unlisted_of_new）、joint-difference-making（Determined）；新增上列两项
Delta: 记录与否证：record、back、back_record、Refuted、RefutedAt、Holds。前方：holdFrom、no_record_fixes_next、
       claim_refuted_on_one、no_record_fixes_next_finite。对角：answerTo、answerStep、diagonal、record_diagonal、diagonal_refutes、
       diagonal_unrested、diagonal_open、swapTo_moves。按否证学习：indexOn、learner、index、index_le_of_holds、
       refuted_before、index_unbounded、refutations_not_recurring、learner_through_record、stable_unrefuted。套索：Lasso、
       lasso_of_held、lasso_positions、lasso_realized、holdFrom_lasso、lasso、lasso_claims、lasso_holds；次序：
       pairAt、tri、pairAt_place、lassos；lasso_learner_bounded、rest_unrefuted、lasso_of_rest、held_learner_bounded、held_rest_unrefuted、diagonal_not_lasso。
       元层次：merged、merged_bound、merged_unrested。归并：Determines、Lumped、Free、lumped_determines、determines_lumped_iff、
       lumped_right_iff、lumped_world_right、free_determines_iff、every_free、every_determines_nothing。结构与变化：
       GoAlikeAt、goAlike_iff_at、transfer_right_iff、goAlike_iff_lumped。训练：Training.Through、Training.AgreeOn、
       Training.web_selectsThrough_iff、Training.loss_through、Training.unselected_beyond_data、Training.fit_right_iff。
       见证：Shift（determines、every_nothing、right_same、wrong_both）、Alternate（repeats、index_three、rests）。
       外围（P74）：Uniform、acquire_exact、uniform_determines、nonuniform_not_determined、develop_orbit、hebbian、
       hebbian_determined、hebbian_activity_law_iff、weights_matter、hebbian_no_activity_law、updating、
       updating_determined、updating_network_law_iff、responsive_kept、responsive_learns、route_matters、
       updating_no_network_law
Supplied premises / correspondence: 不加公理；每条规律的条件写在定理之中：值可判定相等（DecidableEq，按否证学习与
       判定归并处；逐条分类见[可判定性清点](DECIDABILITY-INVENTORY.md)）；有两个不同的值（no_record_fixes_next、determines_lumped_iff、every_determines_nothing）；
       other 移动每个值（对角）；世界的配置被一个列表所持（held_learner_bounded、held_rest_unrefuted）；假设、类与归并由学习之外给出；
       外围中语法、探针、任务、剖面、常数与路线取自既有模块，保持其原有范围；读法除理（Ren 的）之外是 AI 的，待 Ren
Evidence: 合并检查器回执 20261012T012916.201078Z（Becoming.Learning 75 项定理，全部源声明公理报告为空）；外围桥接 CorrectionInquiry
          对这个核心重查，回执 20261012T013048.258651Z；学习桥接回执 20261012T014649.248714Z（15 项定理；其声明中用 Mathlib 实数的报告其标准公理，逐项列出）
Boundary: 一个实际形成持有或能达到哪些假设、类或归并，它的识是否分辨值，它的世界是否被列表所持，一个实际网络的
          结构与更新是否施加某个归并，都不推出；学习理论中可数类的一般界、概率的或近似的学习（PAC）、
          优化的动力学与隐式偏置没有陈述；外围的网络是小模型，不是现代深度网络；不含伦理谓词
Integration: 计划 P73、P74；把 P49 的 Web.tail_unrefuted 推广为任意序列上的无记录固定下一个；把 P53 的“关于何者
             无关的模型”何时正确定为世界经归并同去之处；把 P66 的相同者同去读作同一个归并（结构与变化）；
             把 P64 的经识选择接为训练；习得链（CompositionalAcquisition）与连接主义模型（DevelopmentalMemory、
             UpdaterConsequences）成为脊柱上的实例
```

| 声明 | 内容 |
|---|---|
| `record`、`back_record`、`Refuted`、`RefutedAt`、`Holds` | 一个被识的序列（course）是被识的值的序列，例如一个确定律之轨道的识；第 t 步之前的记录（最新在前）；主张是 `Option O`，不主张为 `none`；主张被否证，指它主张了一个值而所识的值不同；假设在某个序列上成立，指它在任何一步都不被否证 |
| `holdFrom`、`no_record_fixes_next`、`claim_refuted_on_one` | 无记录固定下一个：对每个序列与每步 t，给出两个不同的值，就有两个序列与它在 t 之前有相同的记录，在 t 分别取这两个值；从该记录作出的主张不在两者上都对，值可判定时在其中之一被否证。对序列不作任何假设；P49 的 `Web.tail_unrefuted` 是水平历史上的同一规律 |
| `holdFrom_lasso`、`no_record_fixes_next_finite` | 上述两个序列都是被列表所持之世界的序列（从 t 起不变）：即使在有限的世界中，记录也不固定下一个 |
| `diagonal`、`diagonal_refutes`、`diagonal_unrested` | 对角：对每个学习者（任意从记录作出主张的规则），有一个序列在每一步回答它的主张，把它否证；所以在这个序列上它在任何一步之后都不静止。对每个学习者成立，不论它持有什么、怎样修订 |
| `record_diagonal`、`diagonal_open` | 回答的序列是一个保留其记录之律的识；这个世界从不返回，没有列表持有它的配置（`unlisted_of_new` 的实例）：击败学习者的世界是开放的 |
| `indexOn`、`learner`、`index` | 按否证学习：假设依次排列，从第 0 个开始，恰在所持者被否证时移向下一个；指标就是至今的否证数 |
| `index_le_of_holds`、`refutations_not_recurring`、`refuted_before` | 学习者从不越过一个成立的假设，所以至多被否证该假设的位置那么多次，且不在任意晚处被否证；越过的每个假设都在记录中某一步被否证 |
| `learner_through_record` | 学习者经记录：相同的记录，相同的假设，相同的主张 |
| `stable_unrefuted` | 有界、不降的计数从某步起不变，这一点不能被否证（双重否定） |
| `Lasso`、`lasso_of_held`、`lasso_realized` | 套索：从第 i 步起以周期 q + 1 重复。确定律的轨道被列表 l 所持时，其每个识都是套索，i + q + 1 ≤ l 的长度（由 `revisits_within`）；每个套索都是某个被列表所持之世界的识 |
| `lasso`、`lasso_holds`、`pairAt`、`tri`、`pairAt_place`、`lassos` | 套索假设：在长度足够时回看 q + 1 步；套索序列上它成立。假设对 (i, q) 按对角次序排列，(i, q) 位于 `tri (i + q) + q` |
| `lasso_learner_bounded`、`rest_unrefuted`、`lasso_of_rest` | 在套索序列上，不知 i 与 q 的学习者至多被否证 `tri (i + q) + q` 次，从第 i + q + 1 步起每步主张，不在任意晚处被否证；它静止（每步主张且正确）这一点不能被否证（双重否定）；它只在套索序列上静止 |
| `held_learner_bounded`、`held_rest_unrefuted` | 有限世界中的归纳：确定律的轨道被列表 l 所持时，只读一个能分辨值的识、不知配置也不知其数目的学习者，被否证少于 `tri l.length` 次，从第 l.length 步起每步主张，不在任意晚处被否证；它静止这一点不能被否证（双重否定） |
| `diagonal_not_lasso` | 套索学习者的对角序列不是套索：击败它的世界不被任何列表所持 |
| `merged`、`merged_bound`、`merged_unrested` | 元层次：假设的类沿对合并为一个枚举；对类的学习就是在合并枚举上的同一按否证学习，界复合为 `tri (c + j) + j`；不论怎样选择与合并类，学习者都有其对角序列：没有顶层 |
| `Determines`、`Lumped`、`Free` | 在类 C 之中，数据 D 上的值固定 x 处的值；g 经归并 π 同去（π 相同的输入取同一值）；类在 x 处于数据之外自由（每个成员在数据上的值都能与每个成员在 x 的值组合） |
| `lumped_determines`、`determines_lumped_iff` | 归并恰在它归并之处推广：在经 π 同去的函数之中，有限数据固定未试的 x 处之值，恰当某个观察到的输入与 x 被归并在一起（有两个值时） |
| `lumped_right_iff`、`lumped_world_right` | 推广恰在世界经归并同去之处正确：在数据上拟合世界 f 的成员，在 x 处主张与之归并的观察输入的值；它正确恰当 f 在两者取同一值；世界本身经归并同去时，在与观察输入归并的每个输入上都学对 |
| `free_determines_iff`、`every_free`、`every_determines_nothing` | 在数据之外自由的类，在那里只决定其成员共有的；一切函数之类在每个未观察的输入处自由，所以数据单独不固定任何未试之值 |
| `GoAlikeAt`、`goAlike_iff_at`、`transfer_right_iff` | 变化之律恰在步骤同去之处推广：在确定过程中，在 s₀ 观察到的动作 a 的结果（经 π 读）转移到 s 处的每一步，恰当 s₀ 与 s 经 π 以 a 同去；取之前记录不固定它（`Run.not_fixesThrough_of_goAlike`） |
| `goAlike_iff_lumped` | 结构与变化是同一个归并：确定律经 π 同去，恰当下一配置（经 π 读）经 π 所归并者同去 |
| `Training.loss_through`、`Training.web_selectsThrough_iff` | 训练是经数据的选择：由数据上的值算出的损失，以及由它作出的每个选择，把在数据上一致的两个函数选得相同；P64 的经识选择是经“识得相同”的选择（定义上相同） |
| `Training.unselected_beyond_data`、`Training.fit_right_iff` | 在数据之外自由的类中，每个经数据的选择使未试之值与类同样自由；拟合在数据之外对类中每个世界都正确，恰当类在那里由数据决定 |
| `Shift`、`Alternate` | 见证：输入是位置与内容，归并读内容、忘位置；数据只在一个位置；位置间共享在世界于各位置相同处正确，在不同处错误。序列 false, true, false, …：套索学习者被否证两次，从第三步起正确，恰在界 `tri 1 + 1 = 2` |

外围（P74，`LearningCorrespondence`）：

| 声明 | 内容 |
|---|---|
| `Uniform`、`acquire_exact`、`uniform_determines` | 习得链的推广：在原子效果可分辨的一致律族中，三次接触决定每个表达式（含从未接触的）的值；这是既有 `CompositionalAcquisition` 的结论读作 `Determines`。习得代码的精确性逐例重证，使实例不依赖经典推理 |
| `nonuniform_not_determined` | 容许既有的、在三次接触上一致的非一致律时，接触在新表达式处不决定任何东西：既有 `nonuniform_fails_transfer` 读作类在那里自由 |
| `develop_orbit` | 固定权重下网络的发展是其步的轨道：规则保持时的律（P66） |
| `hebbian`、`hebbian_determined`、`hebbian_activity_law_iff`、`weights_matter`、`hebbian_no_activity_law` | Hebb 式发展（活动在权重下前进、权重储存活动）是 P66 的 `adaptive` 系统；活动恰在权重对其步不造成差别之处有自己的律；三单元记忆中权重造成差别（存储的网络与空网络把第一个剖面送到不同的活动），所以活动单独没有律 |
| `updating`、`updating_determined`、`updating_network_law_iff`、`route_matters`、`updating_no_network_law` | 更新路线是元层次：网络在一条更新路线下随所遇任务前进，又是 `adaptive` 系统，路线是规则；网络恰在路线不造成差别之处有自己的律；在起始网络与第一个任务上两条路线不同（持续路线学习，回应路线保持），所以网络单独没有律 |
| `responsive_kept`、`responsive_learns` | 回应路线恰在任务失败处改变网络：网络层次上的按否证学习 |

**它回答了什么。**
- **归纳问题被分解为规律。** 它不被证明，也不被否定，而是分成几条精确的规律。无记录固定下一个，有限世界中亦然（`no_record_fixes_next`、`no_record_fixes_next_finite`）。每个学习者都有一个世界，否证它的每个主张；这个世界保留其记录，所以开放（`diagonal_refutes`、`diagonal_open`）。在每个被列表所持的世界中，按否证学习的学习者不知配置也不知其数目，被否证的次数有界于配置数，不在任意晚处被否证（`held_learner_bounded`）；它静止这一点不能被否证（`held_rest_unrefuted`，双重否定）；它只在这样的世界中静止（`lasso_of_rest`）。它的记录从不表明它已静止（`no_record_fixes_next_finite`）：学会这一点不能被否证，学习者却从不识得自己何时已学会。
- **何时关于何者无关的模型正确。** 这是 AI 所说未消解的问题。模型是一个归并：它把它视为无关的差别归在一起。它所推广的，恰是它与已识者归在一起的（`determines_lumped_iff`）；在那里它正确，恰当世界经该归并同去（`lumped_right_iff`）；对变化之律，恰当步骤同去（`transfer_right_iff`）。自然的一致性因此不是前提，而是一条规律的局部条件：世界经模型所归并者同去。不归并任何东西，数据单独不固定任何未试之值（`every_determines_nothing`）：没有理就没有推广。
- **理：结构与变化的同一建模（Ren 的读法）。** 对结构的建模是一个归并（`Lumped`）；对变化的建模是步骤经它同去的归并（`GoAlike`）；两者是同一个概念（`goAlike_iff_lumped`）。P66 的“投影承载规律”与这里的“归并推广”是同一条件的两种读法。
- **训练与人工神经网络。** 损失经数据选择（`Training.loss_through`），P64 的经识选择是其实例（`Training.web_selectsThrough_iff`）。在数据之外自由的类中，训练使未试之值与类同样自由（`Training.unselected_beyond_data`）；拟合在数据之外正确，恰当类在那里由数据决定（`Training.fit_right_iff`）。所以推广不来自损失，而来自训练能达到的类：结构、起点与更新的动力学所施加的归并。
- **元层次。** 选择怎样学习就是再学习，在合并的枚举上，界复合（`merged_bound`）；没有顶层（`merged_unrested`）。外围中，更新路线正是网络之上的规则（`updating_network_law_iff`、`route_matters`），回应路线就是网络层次的按否证学习（`responsive_learns`）。
- **既有模型在脊柱上。** 习得链的推广是经律的归并的推广（`uniform_determines`），其失败是类在数据之外自由（`nonuniform_not_determined`）；Hebb 式发展与更新路线是 P66 的 `adaptive` 系统，活动或网络单独没有律之处恰是权重或路线造成差别之处。

**读法。**
- 理（Ren 的读法）：对结构与变化之规律的建模。把归并读作对结构的模型、把经它同去的归并读作对变化的模型，是 AI 对形式项的读法。
- （AI 的，待 Ren）归纳被消解为规律，而不是被保证：在每个有限的世界中，按否证学习静止而不知何时；没有学习者在每个世界中静止；击败它的世界是开放的。休谟的问题在这里的位置是 `no_record_fixes_next`；古德曼的新谜（哪个谓词可投射）是哪个归并；“没有免费的午餐”的有限形式是 `every_determines_nothing`。
- （AI 的，待 Ren）对受训网络，类是训练所能达到的，损失只经数据选择；解释其推广就是识别结构与更新所施加的归并（位置间共享、不变性、组合）及其与世界的对应，而不是损失。
- （AI 的，待 Ren）元层次是再学习，没有顶层；智慧不是一个完成的学习者。

**作者反审。**
1. **“消解”是分解，不是保证。** 正面结果要求世界被列表所持、识能分辨值、假设类给定；在开放的世界中，没有学习者处处静止。这正是规律，但若把“消解”读作“归纳已被证成”，就错了。
2. **主要定理是学习理论中已知结果在脊柱上的形式。** 对角论证见 Putnam（1963，对 Carnap 确证函数的批评）；极限中的识别见 Gold（1967）与 Putnam（1965）；按否证、依次枚举的学习是 Gold 的枚举法；以学习理论处理归纳问题见 Kelly（1996，*The Logic of Reliable Inquiry*）；`every_determines_nothing` 是 Wolpert（1996）“没有先验区别”的有限、确定性形式。增量在于把它们放在一元关系的脊柱上，与识（P49）、实验（P53）、机制（P66）与选择（P64）接为一体，并以 Ren 的理把结构与变化统一，而不在于定理本身新颖。
3. **双重否定。** `rest_unrefuted` 与 `held_rest_unrefuted` 的静止只以双重否定陈述，名称依整合者的规则（P58b）带“unrefuted”：这里不给出静止之步；这是本模块所陈述的范围，不是“不能给出”的证明：已知界（列表的长度）时，P83 的两周期引理（`Becoming.Identification` 的 `period_extends`）界定这一步看来可行（只是草图，此处未检查），留给 P83。P83 已给出这一步：轨道被长 N 的列表所持时，学习者从第 N + (2N − 1)·tri N 步起每步主张且正确（`Identification.held_learner_rests`，§97）。学习者自己的记录从不表明它已静止（`no_record_fixes_next_finite`），这才是“何时静止不被识”的内容。在经典读法下双重否定就是“最终静止”。
4. **界粗。** `tri N` 不是最优界；对任意枚举的假设类，界是第一个成立假设的位置（`index_le_of_holds`），套索只是有限世界的完全类。
5. **类是给出的。** `Determines` 量化于类；什么类是一个实际形成所持有或能达到的，不推出。“类是训练所能达到的”是读法；优化的动力学、隐式偏置与概率的推广界（PAC、VC 维）没有陈述。
6. **`goAlike_iff_lumped` 很短。** 它几乎是定义展开；内容在于它把 P66 的“相同者同去”与这里的“归并”认作一个，使 Ren 的理有一个形式所指。它与 P70 的 `Law.goAlike_process_iff`（`Becoming.Description`，另一会话所持、同日待落地）展开 `Lumped` 后是同一陈述，证明也相同；两者独立写成，后落地的一方把二者的同一写明（实例或注明），不再另证。P71 的 `Becoming.Diagonal`（Lawvere 的缺口）与本节的对角序列同型：后者是按记录、逐步构造的学习者版本，同样由后落地的一方写明二者的关系。
7. **外围实例很薄。** `uniform_determines` 是既有精确性定理的重读；`hebbian` 与 `updating` 是定义上的实例；`weights_matter` 与 `route_matters` 是数值见证。它们的增量是连接，不是新的网络理论。
8. **识的可判定性。** 按否证学习要求值可判定相等；不分辨值的识（P49 的阈下）不在此列，其上的学习没有陈述。

**检查。**
- 模块在暂存区对 main 与 P64–P68 的落地包编译，没有错误或警告；检查器所列 112 项声明（75 项定理）逐条审计，公理报告全部为空；没有禁用的记号（sorry、axiom、Classical、native_decide、omega、simp）。见证 `Alternate.index_three` 以 `rfl` 计算。
- 外围桥接在暂存区以 Lean 4.30.0-rc2 与 Mathlib（ea11ccc0）编译，导入闭包中的核心模块以同一工具链重编（共享缓存）；习得部分的声明公理报告为空，用实数的声明报告 Mathlib 的标准公理（propext、Classical.choice、Quot.sound）。
- 合并检查器在落地队列中检查一次，通过：回执 20261012T012916.201078Z。`Becoming.Learning` 的 75 项定理全部空依赖；包共 2970 项定理、4334 项声明审计，核心闭包 59 个模块。外围桥接 CorrectionInquiry 导入根模块，对这个核心重查，通过：回执 20261012T013048.258651Z。学习桥接检查通过：回执 20261012T014649.248714Z（15 项定理）。
- 尚无独立审查。

## 93. 智慧之根在第一部分所及（P75）

2026-10-12，同一来源。Ren 的“finish wisdom root”指向成果记录 [wisdom-root](../../../../theories/becoming/results/records/wisdom-root.md)：核心不仅约束一般活动，还在所声明范围内构成并解释智慧的实际生成（[主研究 §8](CORE-CONSTRAINT-AND-WISDOM.md#8-明确目标证明这是智慧之根--the-root-of-wisdom-objective)）。§8.4 列出要闭合的四条连接：智慧问题到根部关系（跨表示的必要性）、根部关系到智慧的形成、根部与公开根据到判断的正当性、同一根到持续展开。本节不新增 Lean：它把第一部分已检查的规律（P49、P53、P55、P62、P64、P66 与 §92 的 P73、P74）按这四条连接逐项对上，说明每条现在完成到哪里，什么只有对实际形成的对应才能决定。新增记录 [wisdom-root-part-one](../../../../theories/becoming/results/records/wisdom-root-without-axiom.md)；目标记录 wisdom-root 按登记规则仍为目标（目标不能标为完成），其形式部分由该记录完成，留下的开放部分明示。

```text
Result(s): 复用 testing-within-registration（P49）、experiment-needs-return（P53）、runaway-distance-unregistered（P55）、
           P62 的 Seeking 与 Capture 记录、selection-through-registration（P64）、projection-carrying-a-law（P66）、
           learning-by-refutation 与 generalization-through-lumping（P73、P74）；practical-judgment-g0-j 等第二部分记录不变
Delta: 新增记录 wisdom-root-part-one：第一部分中构成智慧之形式内容的规律，逐条对每个学习者、每个表示、每个选择成立；
       目标 wisdom-root 的四条连接各自完成到哪里；理的读法改依 Ren
Supplied premises / correspondence: 不新增前提；各规律的条件保持在其定理中；把规律对应到智慧的各部分（识、理、检验、
       明、够、不失控、不为代理所欺、元）是 AI 的读法，理依 Ren，其余待 Ren
Evidence: 各模块已通过的合并检查器回执（P73 的在 20261012T012916.201078Z）；无新的 Lean
Boundary: 实际的人与 AI 怎样形成智慧、情感与关切怎样形成、文化与原典中的智慧是否对应这些规律，只有经验对应能决定；
          判断的伦理正当性走第二部分（G0 为那一条公理的定理，P51），本节不改变它；不含伦理谓词
Integration: 目标 wisdom-root 的 next_delta 与边界随之修订；testing-within-registration 中理的读法改依 Ren；
             认知一章的完成义务表随之更新
```

**第一条连接：智慧问题到根部关系（跨表示的必要性）。** 主研究 §8.3 要求：独立说明的智慧内容为何需要这些关系，保留相同内容的替代实现能否避开它们。第一部分的规律是对每个学习者、每个归并、每个选择、每个确定的律陈述的，所以任何保留相同内容的实现都不能避开它们。

| 智慧的一面（读法） | 第一部分的规律（不用公理） | 对每个……成立 |
|---|---|---|
| 识：只有所识者能纠正 | 主张只经所识的差别被否证（`Web.Refutes.not_of_alike`）；没有模型，有限记录不否证关于其后的主张（`Web.tail_unrefuted`），任意序列上亦然（`no_record_fixes_next`） | 每个形成、每个主张、每个序列 |
| 理：对结构与变化之规律的建模（Ren） | 数据单独不固定任何未试之值（`every_determines_nothing`）；推广恰在归并之处，正确恰在世界经归并同去之处（`determines_lumped_iff`、`lumped_right_iff`）；结构与变化是同一个归并（`goAlike_iff_lumped`）；投影恰在相同者同去时承载规律（`carries_law_iff`） | 每个类、每个归并、每个过程 |
| 检验：模型与主张一起被否证，实验需要返回 | 相对于模型的否证是对模型与主张一起的否证（`Web.refutesWithin_iff_conjunction`）；记录只在取过之处固定一个动作的结果（`Run.not_fixes_of_untaken`），重复是返回（`Run.fixes_on_return`），推广到经模型相同的类（`Run.generalizes`） | 每个运行、每个确定过程 |
| 学会而不知何时 | 有限世界中按否证学习，否证次数有界于配置数（`held_learner_bounded`），它静止这一点不能被否证，它的记录从不表明它已静止（`held_rest_unrefuted`、`no_record_fixes_next_finite`）；没有学习者在每个世界中静止（`diagonal_refutes`） | 每个学习者 |
| 明：看见自身所识之外，要他者之识 | 清除者不能检验的，栖居者能，两者合起来能检验各自都不能的（`Clearing.tested_by_dweller`、`Clearing.pooled`）；经识的选择在识闭包之外不见，合起来的识选出它（`Flow.unselected_beyond_registration`、`Clearing.selected_pooled`） | 每个经识的选择 |
| 够：寻求在够处静止 | 寻求恰在到达律所不变、满足其目标的状态时静止（`Law.rests_iff`）；“比现在更多”需要开放的世界（`more_needs_open`）；“高于一切他者”的两个寻求者从不同时静止（`Law.aboveAll_never_rests`） | 每个确定的律、每个目标 |
| 不失控：断裂还有多远不被自身之识识 | 断裂之前，对每个视界都有储量抬高的世界与实际在所识的一切上相同（`Web.break_not_bounded`）；观察储量则立刻识之（`Web.observed_raise_registers`） | 每个经识的策略 |
| 不为代理所欺 | 选择与训练只经选择者之识或数据（`Web.selects_alike_iff`、`Training.loss_through`）；数据之外的值与类同样自由（`Training.unselected_beyond_data`）；伸出识闭包之外而抬高所识者被选中（`Diversion.favours`） | 每个选择、每个损失 |
| 判断：一步的探究 | 由识作出的判断恰是判断过程在信念上的共同回应（`commonResponse_judge_iff`、`Web.belief_judge_iff`） | 每个信念 |
| 元：没有顶层 | 对类的学习是合并枚举上的同一学习（`merged_bound`），没有顶层（`merged_unrested`）；改变自身规则的系统的规律在联合配置上（`adaptive_state_law_iff`） | 每种合并、每个规则 |

这些规律回答 §8.3 的问题的一半：独立说明的智慧内容（辨明理由、纠正错误、对判断的范围负责）在其形式部分要求这些关系，而且替代的表示避不开它们，因为它们对每个表示成立。另一半，即这组关系对全部智慧的充分性，不在此证明：第一部分说出智慧不能缺少什么，以及缺少时怎样失败（`diagonal_refutes`、`every_determines_nothing`、`Web.break_not_bounded`、`Flow.unselected_beyond_registration`），不说出一个形成何时有智慧。

**第二条连接：根部关系到智慧的形成。** 形成的形式部分已陈述：按否证学习从记录形成正确的模型，否证次数有界，静止不能被否证（`held_learner_bounded`、`held_rest_unrefuted`），其纠正就是否证；习得链从三次接触形成对全部表达式的解释（`uniform_determines`）；Hebb 式发展与更新路线是联合配置上的律（`hebbian_activity_law_iff`、`updating_network_law_iff`），回应路线在失败处学习（`responsive_learns`）。实际的人与 AI 是否经这些路线形成其理解与修正，是对应问题，只有经验能决定；认知一章的完成义务（意识、情感、自然语言、发育与演化）保持开放。

**第三条连接：根部与公开根据到判断的正当性。** 不变。伦理方向走第二部分：G0 是那一条公理的定理（P51），第二部分记录（practical-judgment-g0-j 等）保持其范围。第一部分的规律不含伦理谓词，不推出何者应做；它们推出的是，任何声称有根据的判断都只经识、经理、经检验而成立或失败。

**第四条连接：同一根到持续展开。** `merged_unrested` 与 `diagonal_refutes`：智慧不是一个完成的学习者，在每个层次上它都可被一个开放的世界否证，所以持续展开不是附加的要求，而是规律。P71（一个在其所识之内的识在每一步都不完全）若落地，加强这一条；它尚在暂存证据中，不计入。

**结论。** 目标 wisdom-root 的形式部分，在第一部分所能到达的范围内，已完成：智慧的形式内容是一组对每个学习者成立的规律，不用公理，其条件写在定理中。目标仍开放的，恰是三项：(1) 实际形成的对应（经验）；(2) 关切与情感的形成（认知一章）；(3) 这组关系对全部智慧的充分性。第二部分的伦理正当性有其自身的已完成范围。

**读法。** 理依 Ren。把规律对到“识、理、检验、明、够、不失控、不为代理所欺、判断、元”是 AI 的读法，待 Ren；“明”在这里只指看见自身所识之外要他者之识（P49、P64），不取其全部古典含义；“够”取自 P62 的读法。

**作者反审。**
1. **形式部分完成，不等于智慧之根完成。** 主研究 §8.1 把智慧之根定为“揭示智慧不可缺少的构成关系，并解释其形成、成立与失败”。本节完成的是不可缺少性与失败的形式部分，以及形成的形式路线；形成的实际对应与充分性没有完成，目标记录因此保持开放，这不是登记规则造成的形式问题。
2. **必要性的意义是窄的。** “对每个表示成立”说的是：任何学习者都受这些规律约束；它不说每个有智慧者都显式持有一个归并、一个假设列表或一个模型。隐性的、身体的、共同的实践智慧同样受这些规律约束，但它们怎样实现这些关系没有陈述。
3. **表中的对应是读法。** 每行左列是 AI 对智慧一面的命名，右列是已检查的定理；左右之间的对应不是定理。原典（儒、道、佛、亚里士多德的 phronesis）的比较见主研究 §12–§13，本节不重做。
4. **没有新的 Lean。** 本节是整合；它的新信用只在 §92 的 P73 与 P74。

## 94. 描述保留什么、失去什么：分离、关系的生灭与有意义的切分（P70）

2026-10-12。在对话的第三个分支上，Ren 说：描述似乎把整体分开，用词造出一个投影，失去了什么（“i feel there is something i can't quite describe, but what i describe seems to separates the whole and creates a projection using words? doesn't this feels like wave/particle, 道可道非常道, i somehow feel the framing may lose something”）；又问：“maybe change(now) -> future … maybe it is a whole, like 阴阳, change and state/relation is by itself an separation already … but it has to be an splitting that make sense - and what is that "make sense" itself? what makes a pair, a pair?”。AI 回答之后，Ren 说“push the frontier, as far as possible, i am going to sleep, good luck”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）。之后 Ren 要求就“What makes two a pair, then, is relation, in what can go together or in how they go on”再往深处挖，并纠正 AI 对道可道的读法：“i was speculating there is a "truth", but when we model it, projection is the limitation - i am not sure if this is right, i also speculate the full "truth" can be derived, situationally, including the cognition/controller part.”。AI 以本节与 §95、§96 的定理检验这一推测，Ren 答：“keep prove to the deepest, i agree with your last reply(just saw), be smart, resolve and connect things elegantly. and for the open questions, if they need to be answered to move forward, answer them”（同一来源）。本节在工作板上认领为 P70。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Description`（L4），53 项定理，导入 `Becoming.Unfolding`（P69）、`Becoming.Diagonal`（P71）与 `Becoming.Context`（P72），以及 `Becoming.Learning`（P73），不改任何已有模块。

成果记录新增两项：[separation-loses-the-relation](../../../../theories/becoming/results/records/separation-loses-the-relation.md)（分离与关系的生灭）与 [the-split-that-makes-sense](../../../../theories/becoming/results/records/the-split-that-makes-sense.md)（相对于所识有意义的切分，与从一段所识的历史读出的状态）。

```text
Result(s): 复用 configurations-alike-by-relation（Bisimulation、Alike、MakesSense、makesSense_iff、makesSense_id_iff、
           Law.registered、Law.SameFuture、Law.alike_iff_sameFuture、Law.MakesSense.carries）、projection-carrying-a-law
           （GoAlike、goAlike_const、carries_law_iff、adaptive、adaptive_state_law_iff）、recurrence-without-premise
           （Law.orbit、Law.orbit_add、Law.succ_orbit、Law.Returns、skipAt、le_succ_cases）、
           registration-within-what-it-registers（Diagonal.revision_never_rests、Diagonal.flip_moves）、
           contextual-registration（restrict、Glued、PartsDetermine、Specker.Box、Specker.within、Specker.no_whole）；
           新增上列两项
Delta: 分离：Rectangular、Separated、separated_of_whole、separation_faithful_iff、separation_surplus、flipIf、EvenThree、
       whole_not_in_pairs、evenBoxes、flipIf_self、even_first、even_third、evenBoxes_glued、evenBoxes_not_determined。
       关系的生灭：imageOf、Rectangular.image_of_separate、copy_relates、Rectangular.of_image_injective、relation_persists、
       forgetting_unrelates、couple、couple_couple、coupling_relates_and_unrelates。有意义的切分：Law.goAlike_process_iff、
       Law.kernel_bisimulation、Law.sameFuture_of_law、Law.makesSense_of_law、Law.const_makesSense_iff、
       Law.now_makesSense_iff、Law.whole_makesSense、Law.part_makesSense_iff、Law.sameFuture_of_goAlike、
       Law.now_makesSense_iff_goAlike、Law.part_makesSense_iff_step、Law.adaptive_makesSense_iff。一对：Motion（cancel、
       move、move_adaptive、makes_sense、standing_alone、passing_alone、neither_alone、still、orbit_still、
       still_makes_sense）。从一段所识的历史读出的状态：SameAhead、SameAhead.refl、SameAhead.symm、SameAhead.trans、
       SameAhead.next、sameAhead_orbit_iff、SameAhead.new_each、alike_moments_iff、split_top、shared_below、StatesBelow、
       statesBelow_of_same、finitely_many_states_iff、Law.Returns.states、Denial（register、zero_two、two_states、
       each_through_other）
Supplied premises / correspondence: 不加公理，也不加前提；separation_faithful_iff、Law.now_makesSense_iff_goAlike、
       Law.part_makesSense_iff_step、alike_moments_iff 与 finitely_many_states_iff 是双向的，对每个整体、每条确定的律或
       每段所识的序列成立；局部条件写在定理之中：relation_persists 要两个部分的律在出现者上不合并，Law.makesSense_of_law
       要切分保留所识、承载规律并且最粗，Law.Returns.states 要构型返回；“有意义”沿用 P69 的定义；所识是给出的读法；
       离散的步（表示的承诺）；读法是 AI 的，Ren 同意的是 06:01 之前那次回答
Evidence: 合并检查器回执 20261013T084405.661795Z（Becoming.Description 53 项定理，全部源声明公理报告为空），外围回执 20261013T084521.070057Z
Boundary: 只陈述确定的律下有意义的切分；有分支的框架下由 P69 的 Alike 陈述，没有在此重述。有意义的描述作为值（给每个类
          一个名字）存在，没有陈述：类作为关系总在（SameFuture、SameAhead），命名它们一般要商（Quot.sound）。有限的记录能否
          固定状态，不在此陈述（P73）。关系只对两个部分的整体陈述；奇偶在三个部分上作为见证。不含伦理谓词
Integration: 计划 P70；回答 Ren 关于框架失去什么、什么使切分有意义、什么使一对成为一对的问题，并检验 Ren 的推测
             （真存在，限制在投影，完整的真可按情境推出，认知或控制者在内）；建在 P69 的 MakesSense 与 Alike 上，
             以 P66 的 adaptive 陈述控制者，以 P71 的节律推出否定的两个状态，以 P72 的部分与整体陈述奇偶；
             状态有限恰是所识从某一刻起重复，即 P73 的 Lasso（`lasso_iff_sameAhead`、`finitely_many_states_iff_lasso`）；`Law.goAlike_process_iff` 是 P73 的 `goAlike_iff_lumped` 的实例（两者各自写成，P73 先落地）
```

| 声明 | 内容 |
|---|---|
| `Rectangular`、`Separated`、`separated_of_whole`、`separation_faithful_iff` | 两个部分的整体是矩形的，指与一个部分同在的，与另一部分的每一项同在；分离的描述只说每个部分能是什么；它保留每个出现的组合，恰在整体是矩形时给回整体 |
| `separation_surplus` | 总是同去的两个部分，分别描述时可以分开：失去的关系作为多余重现 |
| `flipIf`、`EvenThree`、`whole_not_in_pairs` | 三个部分作为整体相关（奇偶为偶），任意两个都是自由的：描述每一对仍失去它 |
| `evenBoxes`、`flipIf_self`、`even_first`、`even_third`、`evenBoxes_glued`、`evenBoxes_not_determined` | 同一关系放在 Specker 的三个盒子与三对之上（`Becoming.Context`）：每个读法都被每一对容许，诸对不给回整体；同样的三对上 Specker 的可能性不是任何整体的部分（`Specker.no_whole`）：部分失去整体的两种方式 |
| `imageOf`、`Rectangular.image_of_separate`、`copy_relates` | 律从一个整体通到的配置；各自移动每个部分的律从不使无关的部分相关；把一个部分复制进另一部分的律使它们相关 |
| `Rectangular.of_image_injective`、`relation_persists` | 关系形成之后，在各自移动每个部分、在出现者上不合并的每条律下持续 |
| `forgetting_unrelates` | 忘掉一个部分（把它送到一个值）使关系结束 |
| `couple`、`couple_couple`、`coupling_relates_and_unrelates` | 例：一次耦合使两个部分相关，再作用一次使它们不再相关，两次都不失去什么；`couple` 是双射，结束关系的是它共同作用于两个部分 |
| `Law.goAlike_process_iff`、`Law.kernel_bisimulation`、`Law.sameFuture_of_law`、`Law.makesSense_of_law` | 确定的律下，同去就是把被等同者带到被等同者；保留所识并承载规律的切分以互模拟联系配置，不失去所识的任何东西；最粗的这样的切分有意义 |
| `Law.const_makesSense_iff`、`Law.whole_makesSense` | 什么都不分的切分总承载规律，只在所识从不不同时有意义；识得一切时，配置自身是有意义的切分 |
| `Law.now_makesSense_iff`、`Law.sameFuture_of_goAlike`、`Law.now_makesSense_iff_goAlike` | 现在所识者自身有意义，恰当它承载规律，这是一步上的条件；等价地，恰当它固定自己所识的未来 |
| `Law.part_makesSense_iff`、`Law.part_makesSense_iff_step`、`Law.adaptive_makesSense_iff` | 所识的部分单独有意义，恰当其余对它的下一值不造成差别；否则有意义的切分含有其余；下一值由随之改变的规则给出时，恰是规则对它不造成差别（`adaptive_state_law_iff` 的条件） |
| `Motion.move`、`Motion.move_adaptive`、`Motion.makes_sense`、`Motion.standing_alone`、`Motion.passing_alone`、`Motion.neither_alone` | 所立者按所经者变化，如位置按速度；只识所立者时，有意义的切分是这一对；所立者单独不承载规律，所经者单独失去所立者，所以两者单独都没有意义（`Motion.cancel` 是不用 `propext` 的相消） |
| `Motion.still`、`Motion.orbit_still`、`Motion.still_makes_sense` | 没有什么经过时，所立者单独有意义：一对是一 |
| `SameAhead`、`SameAhead.refl`、`SameAhead.symm`、`SameAhead.trans`、`SameAhead.next` | 一段所识的展开中，两个时刻是同一状态，指其后所识的一切相同；这是等价关系，并作为自身继续：状态与它们的律从历史读出，不给配置 |
| `sameAhead_orbit_iff`、`SameAhead.new_each` | 沿轨道读，同一状态就是所识的未来相同；每个时刻所识都不同时，每个时刻是自己的状态 |
| `alike_moments_iff` | 每段所识的历史都是一条确定的律经所识而读：时刻之律，每个时刻走向下一个，只用步的相继（表示的共同步序）；它的相同的时刻恰是同一状态的时刻（经 `Law.alike_iff_sameFuture` 与 `Law.succ_orbit`） |
| `split_top`、`shared_below` | 不加判定的、按关系的鸽笼：前 L + 1 个时刻每个都与某个小于 L 的值相关时，有两个与同一个值相关（照 `revisits_within` 的证明，以关系代替相等） |
| `StatesBelow`、`statesBelow_of_same`、`finitely_many_states_iff` | 两个时刻是同一状态时，每个时刻是较晚者之前某时刻的状态；所识的历史状态有限，恰当它有两个时刻是同一状态，即所识从某刻起重复 |
| `Law.Returns.states` | 返回的构型在每个识读之下状态有限 |
| `Denial.register`、`Denial.zero_two`、`Denial.two_states`、`Denial.each_through_other` | 二值的否定（`Becoming.Diagonal` 中从不静止的修正）恰有两个状态：前两个不同，因为修正从不静止（`Diagonal.revision_never_rests`）；第三个回到第一个，每个时刻是二者之一（`statesBelow_of_same`）；每个经另一个定义 |

**它回答了什么。**
- **分离恰失去关系。** 分别描述各部分，保留每个出现的组合，恰在整体是矩形时给回整体（`separation_faithful_iff`）；失去的关系作为多余重现（`separation_surplus`）。关系可以在整体之中而不在任何一对之中（`whole_not_in_pairs`）。放在 Specker 的盒子上，这是部分失去整体的两种方式之一：奇偶是诸对不给回的整体（`evenBoxes_not_determined`），同样的诸对上 Specker 的可能性不是任何整体的部分（`Specker.no_whole`，§96）。
- **关系在共同的律中形成、持续与结束。** 各自移动每个部分的律，无论有损与否，从不使无关者相关（`Rectangular.image_of_separate`）；复制使它们相关（`copy_relates`）。关系一旦形成，在各自移动每个部分、在出现者上不失去什么的每条律下持续（`relation_persists`）；所以它只由出现者之内的失去结束，例如忘掉一个部分（`forgetting_unrelates`），或由共同作用于各部分者结束：同一次耦合再作用一次，就使它们不再相关，两次都不失去什么（`coupling_relates_and_unrelates`）。“能一起是什么”与“怎样一起继续”是同一关系的两面：前者是后者在一刻的记录，相关是一次相遇的记忆。
- **什么使切分有意义。** 有意义沿用 P69：恰把相同者等同（`MakesSense`）。确定的律下，保留所识并承载规律的切分不失去所识的任何东西，最粗的这样的切分有意义（`Law.makesSense_of_law`）；承载规律不够：什么都不分的切分总承载规律，只在所识从不不同时有意义（`Law.const_makesSense_iff`）。识得一切，配置自身就是有意义的切分（`Law.whole_makesSense`）。现在所识者自身有意义，恰当它承载规律，这是一步上的条件（`Law.now_makesSense_iff_goAlike`；一步的形式由 P66 所有者的审查给出）。
- **什么使一对成为一对。** 所识的部分单独有意义，恰当其余对它的下一值不造成差别；否则有意义的切分含有其余（`Law.part_makesSense_iff_step`）。其余可以是所经者、规则或控制者：下一值由随之改变的规则给出时，恰是 `adaptive_state_law_iff` 的条件（`Law.adaptive_makesSense_iff`）。所立者按所经者变化时，两者单独都没有意义，这一对有（`Motion.neither_alone`、`Motion.makes_sense`）；没有什么经过时，一对是一（`Motion.still_makes_sense`）。所以两个是一对，恰在一个展开的律不在它们之间分开（相遇过而没有忘记），并且所识把它们分开；两个条件都是关系，“二”在关系之后。
- **除了步的相继，一个展开有律不是前提。** 每段所识的历史都是一条确定的律经所识而读，即时刻之律，它只用步的相继，即表示的共同步序；它的相同的时刻恰是同一状态的时刻（`alike_moments_iff`）。状态与它们的律从历史读出（`SameAhead.next`）。状态有限，恰当有两个时刻是同一状态，即所识从某刻起重复（`finitely_many_states_iff`）；返回的构型在每个识读下状态有限（`Law.Returns.states`）。所以“世界是否有律”不是一个是或否的前提：每个展开在最细的描述下有律，律的内容是它的压缩，即有意义的切分需要多少状态。二值的否定恰有两个状态，每个经另一个定义（`Denial.two_states`、`Denial.each_through_other`），这就是 §95 的节律。

**Ren 的推测怎样被检验。** Ren 推测：有一个真；建模时投影是限制；完整的真可以按情境推出，认知或控制者在内。按本节与 §95、§96 的定理（AI 的组织；Ren 同意了这次回答，见上）：
- **失去在投影。** 核心找到的每一种失去都属于一个投影，每一种都有不失去的对应：分别描述各部分恰失去关系，共同的描述不失去（`separation_faithful_iff`）；不依语境的值恰在语境不粘合处失败，以语境为索引的值总合（`Contextual.fitsFree_iff`、`Contextual.indexed_fits`）；把相同者之外的也等同的描述，恰在不满足 `MakesSense` 时失去，有意义的切分不失去。
- **按情境的真是确切的，不是部分的。** 固定所识，不失去的切分由律固定、唯一并承载规律（P69）；识得一切，它就是配置自身（`Law.whole_makesSense`）。
- **控制者在内。** 改变自身规则的系统是一个确定的过程（`adaptive_determined`，P66）；它按情境的真恰在控制者对所识造成差别处含有控制者（`Law.adaptive_makesSense_iff`）。
- **三处精化。** 存在的真是关系的：在语境世界中不依语境的值根本不存在（§96）。从内部，任何给定的真都可推出，但不能一次全部：在所识之中的识不能持有自己的每个读法，补全它是永不封闭的展开（§95）。运动的自指循环没有静值，它的真是运动本身，一个状态有限的节律（`Denial.two_states`）。
- **答复中的三个未决问题。** 展开是否有律：如上，不是前提（`alike_moments_iff`、`finitely_many_states_iff`）。有限的记录能固定什么：记录不固定下一值，状态有限的世界中也不，学习只在状态有限处到达静止，何时静止不被识（P73 的 `no_record_fixes_next_finite` 与 `comes_to_rest`，由其所有者陈述，这里不重证）。给类命名：不阻碍推进，类作为关系（`SameAhead`、`Law.SameFuture`）总在，核心的每条定理都以关系陈述；命名一般要商，那是表示上的又一个投影。

**读法。** 以下是 AI 的，待 Ren；Ren 06:01 同意了包含它们的那次回答，这不使它们成为 Ren 的读法：
- “描述扣除了什么”：扣除的恰是所切者之间的关系，与使描述有意义所需的、所识之外的差别。不扣除的描述总在：共同的、以语境为索引的、有意义的切分。
- 阴阳：所立者与所经者是一对，两者单独都没有意义（`Motion.neither_alone`）；否定的两个状态每个经另一个定义（`Denial.each_through_other`），这有互根与转化的形式。“变化与状态本身已是一个分离”：状态是“其后怎样继续”的类，变化是这些类的继续，两者经对方定义。
- 三生万物：三是整体能持有任何部分都不持有的关系的最小数目（`whole_not_in_pairs`）。
- 认识者之内的真：一个认识者所识的部分单独有意义，恰当它自己不造成差别；它造成差别时，按情境的真含有它。

**作者反审。**
1. **多数定理很短。** `separation_faithful_iff`、`forgetting_unrelates`、`Law.whole_makesSense` 各只几行。增量在于两个方向都证明、条件写得最弱（不合并只要求在出现者上）、以及这些结果连成一条线：分离、关系的生灭、有意义的切分、一对、从历史读出的状态。
2. **有意义的切分只对确定的律陈述。** 有分支的框架由 P69 的 `Alike` 与 `MakesSense` 陈述；`Law.makesSense_of_law` 与 `Law.part_makesSense_iff_step` 没有对它们重述。
3. **“世界有律”被回答的方式是读法上的。** 时刻之律的确定性是平凡的：每个时刻只有一个下一时刻。内容在于相同的时刻恰是同一状态（`alike_moments_iff`），以及状态有限恰是从某一刻起重复（`finitely_many_states_iff`）。它没有说任何实际展开状态有限。
4. **耦合的例子是一个。** `coupling_relates_and_unrelates` 是 Bool × Bool 上的一个见证；一般的陈述是 `relation_persists` 的逆否：各自移动每个部分且不失去什么的律从不结束关系。哪些共同的律保持矩形，没有刻画。
5. **关系只对两个部分陈述。** `Rectangular` 是二元的；三个部分的关系以奇偶为见证，一般的“部分给回整体”由 §96 的 `PartsDetermine` 陈述，`separation_faithful_iff` 不是它的实例（两个部分的类型不同）。
6. **有意义的描述作为值没有构造。** 状态有限时，给每个状态一个名字，要判定时刻是否同一状态，`SameAhead` 量化全部未来，一般不可判定。核心以关系陈述，这是选择，也是边界。
7. **审查的贡献。** 一步形式的 `Law.sameFuture_of_goAlike`、`Law.now_makesSense_iff_goAlike` 与 `Law.part_makesSense_iff_step`、不合并只在出现者上、`no_free_frame` 只要一个配置，都来自“Cause–effect system theory comparison”（P66 的所有者）的审查；第二次审查指出时刻之律依赖共同步序、`no_whole` 要某个语境允许某物、`Unfolds.incomplete` 就是每一步的 `gap_unsaid`，并指出 `shared_below` 推广 `revisits_within`；作者采纳并检查。
8. **与 P73 的关系。** P73 先落地，所以由本节写出同一：`Law.goAlike_process_iff` 与 `Becoming.Learning` 的 `goAlike_iff_lumped` 是同一定律，各自写成、证明相同，这里取为它的实例（名称与陈述不变）；P73 的 Lasso 就是两个时刻是同一状态（`lasso_iff_sameAhead`），所以状态有限就是 Lasso（`finitely_many_states_iff_lasso`）。本模块因此导入 `Becoming.Learning`，在 L4。

**检查。**
- 模块在暂存区对 main 的核心、P64–P68（`Becoming.Mechanism`）与 P69 包（`Becoming.Unfolding`，sha256 46c3d049…）编译，没有错误或警告；逐条审计全部常量，公理报告全部为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。不用 `simp`、`omega`；相消用自己的 `Motion.cancel`，因为 `Nat.add_right_cancel` 依赖 `propext`。
- 合并检查器在落地队列中检查一次，通过：回执 20261013T084405.661795Z。`Becoming.Description` 的 53 项定理全部空依赖；包共 3114 项定理、4559 项声明审计，核心闭包 63 个模块。外围回执 20261013T084521.070057Z。
- 独立审查：“Cause–effect system theory comparison” 2026-10-12 审查了三个模块的 Lean（Description `6af48ab0`、Diagonal `c98eb6a8`、Context `a655aa36`），没有发现错误，提出的加强与修正均已采纳（见反审 7）；同日又审查了其后加入的部分（Description `10d7b043`、Context `349fbc63`、Diagonal `e14821d9`，对前一版本作差）：本模块的“从一段所识的历史读出的状态”、Specker 盒子上的奇偶与 Context 的“整体与其部分”，读了证明而没有重新编译，没有发现错误，四处措辞已改（见反审 7）。最终版本由作者以共享的暂存构建编译并审计。

## 95. 在所识之中的识：对角线、补全的展开与没有静值的节律（P71）

2026-10-12，同一来源（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）。Ren 说框架似乎失去了什么，提到“道可道非常道”；AI 的回答指出第三种失去：一个世界对自身的识由它的部分作出，部分在所识者之中。Ren 后来纠正：“i was speculating there is a "truth", but when we model it, projection is the limitation … i also speculate the full "truth" can be derived, situationally, including the cognition/controller part.”。本节检验其中“从内部”的一半。本节在工作板上认领为 P71。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Diagonal`（L2），26 项定理，导入 `Becoming.Recurrence`，不改任何已有模块。外围的 `RootCoverageBoundary`（数学抽象，`CoverageBoundary.lean`，导入 `Std`）有同一对角线的函数与谓词形式；本模块在核心中不用公理重述它，并加上完备恰在没有差别处、补全的展开与节律。

成果记录新增一项：[registration-within-what-it-registers](../../../../theories/becoming/results/records/readings-within-what-they-read.md)。

```text
Result(s): 复用 recurrence-without-premise（Law.orbit、Law.Returns、gap_of_lt；保留历史从不返回的
           Law.withHistory_never_returns、Law.withHistory_unlisted 作为类比引用）；Becoming.Frame 的 Frame 与 realized；
           新增上列一项
Delta: 缺口：Diagonal.Says、Diagonal.gap、Diagonal.Moves、Diagonal.gap_unsaid、Diagonal.fixed_of_complete、
       Diagonal.Says.congr。主张：Diagonal.moves_not、Diagonal.claims_incomplete、Diagonal.claims_gap、
       Frame.self_incomplete。恰在没有差别处：Diagonal.alike_of_complete、Diagonal.complete_of_alike、
       Diagonal.complete_iff_alike。补全是展开：Diagonal.Unfolds、Diagonal.Unfolds.keeps_on、Diagonal.Unfolds.incomplete、
       Diagonal.Unfolds.gap_new、Diagonal.Unfolds.gaps_differ、Diagonal.Unfolds.never_returns、Diagonal.two_ne_odd、
       Diagonal.stock_unheld、Diagonal.Unfolds.unheld；见证：Diagonal.unfolding、Diagonal.unfolding_fresh、
       Diagonal.unfolding_zero、Diagonal.flip_moves、Diagonal.unfolding_unfolds、Diagonal.unfolding_open。节律：
       Diagonal.revision_never_rests、Diagonal.denial_never_rests、Diagonal.denial_returns
Supplied premises / correspondence: 不加公理，也不加前提；gap_unsaid、claims_incomplete、Unfolds 的各条与节律对每个
       族、每个值的类型与每个“相同”成立；局部条件写在定理之中：alike_of_complete 要与一个值的相等可判定，
       complete_iff_alike 要值的相等可判定，Unfolds.gaps_differ 要“相同”可传递，stock_unheld 要它对称、可传递
       （下标上用自然数的判定，值上不判定）；“识”是一个以所读者为索引的族，这是给出的读法；读法是 AI 的
Evidence: 合并检查器回执 20261013T084405.661795Z（Becoming.Diagonal 26 项定理，全部源声明公理报告为空），外围回执 20261013T084521.070057Z
Boundary: 族以所读者为索引（A → A → B）；以别的东西为索引的识不在此陈述。不陈述哥德尔的不完备（那需要算术编码），
          不陈述停机问题；“完备恰在没有差别处”是对以相等比较的值；对主张只有一个方向（从不完备）。节律只对二值的否定
          给出周期 2；一般的修正只陈述从不静止。不含伦理谓词
Integration: 计划 P71；回答 Ren 关于框架失去什么的问题中“从内部”的一半，并检验 Ren 的推测：从内部，任何给定的真可在
             下一步说出，不能一次全部；外围 RootCoverageBoundary 的对角线在核心中重述；P70 以本模块的节律推出否定的
             两个状态（Denial.two_states）
```

| 声明 | 内容 |
|---|---|
| `Diagonal.Says`、`Diagonal.gap`、`Diagonal.Moves` | 族 ψ : A → A → B 说出读法 g，指某个成员 a 对每个 x 识得与 g x 相同的值；缺口：把每个成员对自身的识经 f 移动；f 移动每个值，指没有值与它的像相同 |
| `Diagonal.gap_unsaid`、`Diagonal.fixed_of_complete` | f 移动每个值时，缺口不被任何成员说出（Lawvere 的对角线）；说出每个读法的族给每个映射一个与像相同的值：在所识之中包含自身是可以的（不动点、自复制程序的一面） |
| `Diagonal.Says.congr`、`Diagonal.moves_not`、`Diagonal.claims_incomplete`、`Diagonal.claims_gap` | 主张从不与它的否定相同（构造的）；所以以所读者为索引的主张族不实现每种主张的模式；没有成员恰实现不实现自身的成员 |
| `Frame.self_incomplete` | 主张就是自己的配置的框架：没有配置实现关于配置的每种主张模式 |
| `Diagonal.alike_of_complete`、`Diagonal.complete_of_alike`、`Diagonal.complete_iff_alike` | 以相等比较的值：在所识之中的识说出每个读法，恰当值之间没有什么可分（一个方向只要与一个值的相等可判定，另一个方向只要一个成员与一个值） |
| `Diagonal.Unfolds`、`Diagonal.Unfolds.keeps_on`、`Diagonal.Unfolds.incomplete` | 保留所识、下一步识得所漏者的识；它在每一步都不完备：缺的是该步自己的缺口 |
| `Diagonal.Unfolds.gap_new`、`Diagonal.Unfolds.gaps_differ`、`Diagonal.Unfolds.never_returns` | 一个缺口在它自己那一步及之前都不被识；没有两个缺口相同；识从不返回：每个较晚的步识得某个较早的步都没有识得的 |
| `Diagonal.two_ne_odd`、`Diagonal.stock_unheld`、`Diagonal.Unfolds.unheld` | 两两不同的读法不都与一个有限储存的成员相同（不在值上判定，按偶数位与奇数位对半）；所以没有有限的储存持有展开所漏的 |
| `Diagonal.unfolding`、`Diagonal.unfolding_fresh`、`Diagonal.unfolding_zero`、`Diagonal.flip_moves`、`Diagonal.unfolding_unfolds`、`Diagonal.unfolding_open` | 这样的展开存在：第 n + 1 步由成员 n + 1 接住第 n 步的缺口；它从不封闭、从不返回，没有有限储存持有它所漏的 |
| `Diagonal.revision_never_rests`、`Diagonal.denial_never_rests`、`Diagonal.denial_returns` | 以移动每个值的映射修正一个值，从不静止；否定自身的主张，修正在 Iff 之下从不静止；二值的否定每两步返回：说谎者读作修正，是最简单的节律，不是矛盾 |

**它回答了什么。**
- **从内部，什么不能被识。** 世界对自身的识由它的部分作出。以所读者为索引的族，对移动每个值的映射，漏掉一个确定的读法（`gap_unsaid`）；对主张，这总成立，因为主张从不与它的否定相同（`claims_incomplete`）。所以框架不能以自己的配置实现关于配置的每种主张（`Frame.self_incomplete`）。
- **限制恰在有差别处。** 以相等比较的值，在所识之中的识说出每个读法，恰当值之间没有什么可分（`complete_iff_alike`）。所以限制不在“自身包含”：说出每个读法的族给每个映射一个不动点（`fixed_of_complete`），在所识之中包含自身是可以的。限制在把每个读法同时持有在一个内部的描述中。
- **补全是展开。** 下一步可以识得所漏者（`Unfolds`），但那一步又漏掉新的（`Unfolds.incomplete`、`Unfolds.gap_new`），没有两个缺口相同，识从不返回（`Unfolds.never_returns`），没有有限储存持有所漏的（`Unfolds.unheld`）。这样的展开存在（`unfolding_unfolds`、`unfolding_open`）。像保留的历史（`Law.withHistory_never_returns`），它从不返回，不能被有限储存持有。
- **没有静值，是节律。** 说谎者读作修正：从不静止（`revision_never_rests`、`denial_never_rests`），二值时每两步返回（`denial_returns`）。P70 从同一节律读出恰两个状态，每个经另一个定义（`Denial.two_states`）。“悖论”是一个运动之真的静止投影。

**读法。** 以下是 AI 的，待 Ren；Ren 06:01 同意了包含它们的那次回答：
- 对 Ren 的推测：从内部，任何给定的真都可以在某个情境（下一步）说出，不能从一个情境全部说出；限制又一次在投影，即试图把整体持有在它之中的一个描述里，不是在真之外还有什么。
- 庄子“一与言为二，二与一为三。自此以往，巧历不能得”有 `Unfolds` 的回退形式。
- 自我预测：预测被宣布进它所预测者、而回应离开每个宣布时，没有静止的预测是对的（`revision_never_rests`）；循环的真是它的节律。认知或控制者可以被包含在真之中，但宣布在循环之内的静止的自我预测不能总是它的一部分。
- 早先把道可道读作“说不尽”，是 AI 的读法，不是 Ren 的；Ren 的推测见 §94。

**作者反审。**
1. **核心是一个已知的论证。** Lawvere 的不动点定理（1969）及其前身康托尔、罗素、哥德尔、塔斯基；外围已有 `RootCoverageBoundary`。增量是在核心中不用公理、不判定值，加上完备恰在没有差别处、补全的展开从不返回且不被有限储存持有，以及节律。P73（`Becoming.Learning`）的 `diagonal_refutes` 与 `diagonal_unrested` 是学习者的形式：对记录上的每个主张映射，一个逐步建成的历程以移动后的值回答每个主张；它与 `gap_unsaid`、`revision_never_rests` 同形而对象不同，两者各自写成，这里只记下这一关系，不陈述为定理。
2. **不是哥德尔。** 这里的“识”是任意以所读者为索引的族，没有算术编码与可证性；不完备定理没有陈述。
3. **`complete_iff_alike` 一个方向要判定。** 从完备推出值没有差别，要与一个值的相等可判定；对主张只陈述从不完备（`claims_incomplete`）。
4. **`stock_unheld` 在下标上判定。** 它用自然数下标的相等判定（`decEq i L`），不在值上判定；“不判定”指值。
5. **节律只对二值的否定是周期的。** 一般的修正只陈述从不静止；它是否返回取决于值的世界（`Becoming.Recurrence`：有限多值中，不合并的修正都返回）。
6. **审查的贡献。** `Unfolds.incomplete` 取展开为参数（它就是每一步的 `gap_unsaid`，对任何族的序列成立，文档说明这一点）、`Frame.self_incomplete` 移出 `Diagonal`、去掉重复的双重否定（用前导的 `Bool.not_not`）、文档的措辞，来自 P66 所有者的审查。

**检查。**
- 模块在暂存区对 main 的核心编译，没有错误或警告；逐条审计全部常量，公理报告全部为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。`if_pos`、`if_neg` 只用于自然数相等的判定。
- 合并检查器在落地队列中检查一次，通过：回执 20261013T084405.661795Z。`Becoming.Diagonal` 的 26 项定理全部空依赖。外围回执 20261013T084521.070057Z。
- 独立审查：P66 的所有者 2026-10-12 审查了 `c98eb6a8` 版本，没有发现错误，又审查了 `e14821d9`；其后的改动只是审查所建议的（见反审 6）。

## 96. 语境中的识：粘合、不依语境的主张作为承诺，与部分失去整体的两种方式（P72）

2026-10-12，同一来源（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）。Ren 问框架失去的东西是否像“wave/particle”。AI 的回答指出：核心的 `Frame` 在类型上不依语境，一个主张被识得什么，不取决于与它一起被识的是什么；而在 Specker（1960）与 Kochen–Specker（1967）的世界中，不依语境的值根本不存在。AI 提出把它作为一项陈述，Ren 答“push the frontier, as far as possible”。本节在工作板上认领为 P72。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Context`（L2），28 项定理，导入 `Becoming.Frame`，不改任何已有模块；量子实现 `Becoming.Quantum`（37 项定理，只导入本模块）由“Cause–effect system theory comparison”（P64–P68 的所有者）作为 P72q 写成并检查，随本节落地。

成果记录新增一项：[contextual-registration](../../../../theories/becoming/results/records/claims-shown-in-context.md)。

```text
Result(s): 复用 Becoming.Frame 的 Frame、Process 与 realized；新增上列一项
Delta: 语境中的识：Contextual、Local、NoGlobal、Unforced。粘合：Contextual.Glues、Contextual.Agree、Contextual.Glues.agree、
       Contextual.glues_iff_agree。框架：Contextual.indexed、Contextual.indexed_fits、Contextual.FitsFree、
       Contextual.fitsFree_iff。可能性不粘合之处：Contextual.Respects、Contextual.not_glues、Contextual.no_free_frame。
       整体与其部分的读法：restrict、Glued、PartsDetermine、glued_of_whole、restrict_local、no_whole。
       Specker 的三个盒子：Specker（Box、Opening、first、second、within、support、local_、three_do_not、noGlobal、marks、
       marks_self、marks_other、flip_ne、unforced、world、respects、not_glues、no_whole）。Mermin–Peres 方阵：Square（Cell、
       i0、i1、i2、Line、within、at_、within_at、parity、odd、support、local_、nine、noGlobal、pos、pos_at、at_pos、fill、
       fill_parity、unforced、no_whole）。量子实现（P72q，Becoming.Quantum）：obs、obs_sq、row_commute、column_commute、
       line_commute、off_line_anticommute、row_product、column_product、line_product、Shows、obs_signed、mulVec_obs、
       line_parity、shows_support、line_realized、support_shown、no_context_free_values 等
Supplied premises / correspondence: 不加公理，也不加前提；glues_iff_agree 与 fitsFree_iff 是双向的，要每个主张有一个
       识它的语境（home、covers）；not_glues 要可能性是局部的、没有不依语境的读法、配置尊重可能性；no_whole 要可能性
       非空；语境、主张与可能性是给出的读法；Quantum 以整数矩阵与整数本征向量给出，只覆盖这个方阵（九个可观测量都是
       实的）；读法是 AI 的
Evidence: 合并检查器回执 20261013T084405.661795Z（Becoming.Context 28 项定理、Becoming.Quantum 37 项定理，全部源声明
          公理报告为空），外围回执 20261013T084521.070057Z
Boundary: 只陈述有限的见证与一般的粘合定理；不陈述一般的层论、Abramsky–Brandenburger 的完整框架、概率（Bell 不等式）
          或希尔伯特空间；Quantum 不是测量的理论，Born 权重没有陈述；“世界在语境中”是表示上的选择：以语境为索引的
          框架总合，代价是在两个语境中被识的主张是两个主张。不含伦理谓词
Integration: 计划 P72（含 P72q）；回答 Ren 关于 wave/particle 的问题；把“不依语境的主张”记为表示的承诺（零前提计划的
             表示承诺之一，由整合者决定是否列入）；部分失去整体的两种方式与 P70 的奇偶（evenBoxes_not_determined）在
             同样的三对上相接
```

| 声明 | 内容 |
|---|---|
| `Contextual`、`Local`、`NoGlobal`、`Unforced` | 在语境中被识的主张：哪个语境识哪些主张，每个配置上它识得什么；一个语境能显示什么只取决于它所识的主张；没有不依语境的读法落在每个语境的可能性之内；没有语境强制任何主张：每个主张在识它的每个语境中都能显示每个值 |
| `Contextual.Glues`、`Contextual.Agree`、`Contextual.Glues.agree`、`Contextual.glues_iff_agree` | 在配置 s 处诸识粘合：有一个不依语境的读法与每个语境在其所识的每个主张上一致；它们粘合恰当识同一主张的任意两个语境识得相同 |
| `Contextual.indexed`、`Contextual.indexed_fits` | 连同语境读，每次识都是一个框架的主张（语境、主张、值）；以语境为索引的框架合于每次识 |
| `Contextual.FitsFree`、`Contextual.fitsFree_iff` | 不依语境的主张的框架合于诸识，恰当诸识在每个配置粘合 |
| `Contextual.Respects`、`Contextual.not_glues`、`Contextual.no_free_frame` | 可能性局部且没有不依语境的读法时，没有尊重它们的配置粘合；所以只要有一个配置尊重它们，没有不依语境的主张的框架合于这个世界，而以语境为索引的框架合 |
| `restrict`、`Glued`、`glued_of_whole`、`restrict_local` | 整体的可能性在一个语境中允许什么；各语境的描述粘合成什么；整体在它的部分粘合成者之内；整体在语境中允许的是局部的 |
| `PartsDetermine`、`no_whole` | 部分给回整体；没有不依语境的读法、某个语境允许某物的可能性不是任何整体的部分（不用局部性）：部分失去整体的两种方式之二（之一是不给回，P70 的奇偶） |
| `Specker.*` | 三个盒子，任意两个可以一起打开，打开的两个中恰有一个有宝石：每次打开的可能性是局部的，没有打开强制任何盒子（`Specker.unforced`），没有放置合于全部（`Specker.noGlobal`），每次打开都在第一个盒子显示宝石的世界尊重它们而不粘合（`Specker.respects`、`Specker.not_glues`），这些可能性不是任何整体的部分（`Specker.no_whole`） |
| `Square.*` | 九个主张，三行三列，每条线识三个；每行与前两列的三个值奇偶为偶，第三列为奇：每条线的可能性是局部的，没有线强制任何格（`Square.unforced`），没有赋值合于全部六条线（`Square.nine`、`Square.noGlobal`），这些可能性不是任何整体的部分（`Square.no_whole`）；`Fin 3` 的数字字面量依赖 `propext`，所以位置取作 `i0`、`i1`、`i2` |
| `Becoming.Quantum`（P72q） | 两个量子比特上的九个可观测量 X⊗I、I⊗X、X⊗X／I⊗Z、Z⊗I、Z⊗Z／X⊗Z、Z⊗X、Y⊗Y 作为整数 4×4 矩阵：每个平方为 I，每条线的三个两两对易，不共线的反对易，行乘积为 +I，列乘积为 +I、+I、−I（`line_product`）；态在一条线上共同显示的值是该线的一个可能（`shows_support`），每个可能都由一个明确的整数向量显示（`support_shown`）；所以没有对九个格的赋值在每条线上被量子态共同显示（`no_context_free_values`，由 `Square.noGlobal`） |

**它回答了什么。**
- **不依语境的主张是表示的承诺。** `Frame` 在类型上把主张读作不依语境。这里证明它何时合：恰在诸识在每个配置粘合时（`fitsFree_iff`），粘合恰是语境在相交处一致（`glues_iff_agree`）。以语境为索引的框架总合（`indexed_fits`）。
- **有的世界在任何配置都不粘合。** Specker 的三个盒子与 Mermin–Peres 方阵：每个语境内一致，没有语境强制任何主张，没有不依语境的读法（`noGlobal`）；尊重它们的配置不粘合（`not_glues`），不依语境的主张的框架不合（`no_free_frame`）。量子比特实现这个方阵（`Becoming.Quantum`），所以量子的识属于这一类：Kochen–Specker 在两个量子比特上的形式（Mermin 1990、Peres 1990）。
- **部分失去整体的两种方式。** 整体在它的部分粘合成者之内（`glued_of_whole`）。部分可以不给回整体：在 Specker 的三对上，奇偶是诸对不给回的整体（P70，`evenBoxes_not_determined`）；部分也可以允许没有整体有的：同样的三对上，Specker 的可能性不是任何整体的部分（`Specker.no_whole`，`Square.no_whole`）。这是层的两个条件（唯一与粘合）在可能性上的形式。

**读法。** 以下是 AI 的，待 Ren；Ren 06:01 同意了包含它们的那次回答：
- 波与粒子：两种图像都不是真；每一种是向不依语境的值的投影，以语境为索引的陈述合。值是在语境中的识，即关系。
- Ren 的推测“有一个真”：在语境世界中，存在的真是关系的（主张在语境中），不是每个主张单独持有的值的表；不依语境的值的表根本不存在（`no_context_free_values`）。
- 奇偶的统一：Specker、方阵与 P70 的奇偶都是奇偶的现象：每个主张在两个语境中，语境要求的奇偶之和为奇，就没有整体；整体的奇偶不在任何一对中，就不被诸对给回。这是读法（Mermin 的奇偶论证），没有作为一般定理陈述。

**作者反审。**
1. **见证是经典的。** Specker（1960）、Kochen–Specker（1967）、Mermin（1990）、Peres（1990）、Abramsky–Brandenburger（2011）。增量是在核心中不用公理陈述，并把不依语境的主张定为表示的承诺，连同它何时合的充要条件。
2. **只有可能性，没有概率。** 这里是可能性的（“strong contextuality”）形式；Bell 型不等式与概率的语境性没有陈述。
3. **Quantum 很窄。** 实矩阵、整数本征向量，只覆盖这个方阵；不是希尔伯特空间、测量或 Born 权重的理论。它检查的是算子代数与它和 `Square.support` 的连接。
4. **`no_free_frame` 只要一个配置。** 不依语境的框架必须在每个配置粘合，所以一个尊重可能性的配置就足以排除它（审查后改弱）。
5. **奇偶的统一没有证明。** 一般的“奇偶障碍”定理需要有限求和，没有陈述；三个见证各自由 `decide` 检查。
6. **`PartsDetermine` 与 P70 的 `separation_faithful_iff` 不是实例关系。** 后者的两个部分类型不同；前者要求一个值的类型。

**检查。**
- `Becoming.Context` 在暂存区对 main 的 `Becoming.Frame` 编译，没有错误或警告；逐条审计全部常量：源声明的公理报告全部为空，生成的常量中只有带字段构造子的单射引理（`Contextual.mk.injEq`、`Square.Line.row.injEq`、`Square.Line.column.injEq`）依赖 `propext`，检查器允许并列出它们；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。有限的事实由 `decide` 检查，不以数值测试代替陈述。
- `Becoming.Quantum` 由其作者检查（88 个常量，43 项定理，公理报告全部为空）；本模块改名与加入整体一节之后，P72 的作者对它重新编译，结果相同。
- 合并检查器在落地队列中检查一次，通过：回执 20261013T084405.661795Z。外围回执 20261013T084521.070057Z。
- 独立审查：P66 的所有者 2026-10-12 审查了 `a655aa36` 版本，没有发现错误；同日又审查了其后加入的“整体与其部分”一节（`349fbc63`），读了证明，没有发现错误，`no_whole` 的说明补上“某个语境允许某物”。
- 检查器的声明解析器不读名字末尾的撇号（把 `neg'` 读作 `neg`），所以 `Becoming.Quantum` 的四个辅助名 `neg'`、`zero_mul'`、`zero_add'`、`neg_one_mul'` 落地时改为 `negAt`、`int_zero_mul`、`int_zero_add`、`int_neg_one_mul`，陈述不变；改名后作者以共享的暂存构建重新编译并审计，全部源声明公理报告为空。

## 97. 辨识：有界的记录确定什么（P83）

2026-10-12，同一来源（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）。Ren 05:12 推测：“i was speculating there is a "truth", but when we model it, projection is the limitation - i am not sure if this is right, i also speculate the full "truth" can be derived, situationally, including the cognition/controller part.”。AI 以已检查的结果检验这一推测，留下三个开放问题：展开是否有这样的律；能否从有限的记录推出律；能否不加公理命名有意义的切分的类。Ren 06:01 答：“keep prove to the deepest, i agree with your last reply(just saw), be smart, resolve and connect things elegantly. and for the open questions, if they need to be answered to move forward, answer them”。第一个问题已由 P70 回答（§94）：除了步的相继，每段所识的历史都是一条律，状态从它读出。P73（§92）证明：没有记录确定下一个值，在列表持有的世界中也不能；不知道有多少配置的按否证学习者，它会静止这一点不被否证，它的记录从不表明它已静止。本节回答后两个问题，并给出那个学习者静止之步的界。情境给出的是状态数的一个界。有了界，有限的记录确定整个历程，归纳成为演绎，有意义的切分的类以有限的名命名，不用商公理。本节在工作板上认领为 P83。它不加公理，除了界不加前提，属于第一部分。核心新增模块 `Becoming.Identification`（L4），42 项定理，导入 `Becoming.Description`（从而导入 `Becoming.Learning` 与 `Becoming.Unfolding`），不改任何已有模块。

成果记录新增一项：[identification-where-bounded](../../../../theories/becoming/results/records/identification-where-bounded.md)。

```text
Result(s): 复用 learning-by-refutation（Learning.Lasso、lasso_of_held、lasso、lasso_claims、lasso_holds、Holds、
           RefutedAt、Refuted、eq_of_not_refuted、record、record_congr、back_record、back_made、holdFrom、
           holdFrom_lasso、lassoNext、diagonal_unrested、learner、lassos、index、index_refuted、index_kept、
           index_le_succ、index_mono_le、lasso_learner_bounded、pairAt、pairAt_place、diag、diag_le、tri、tri_mono、
           place_lt）；the-split-that-makes-sense（SameAhead、StatesBelow、shared_below、statesBelow_of_same、
           lasso_iff_sameAhead、Denial.register、Denial.zero_two）；configurations-alike-by-relation（MakesSense、
           Law.registered、Law.SameFuture、Law.alike_iff_sameFuture、Law.MakesSense.carries）；
           recurrence-without-premise（Law.orbit、gap_of_le、gap_of_lt）；新增上列一项
Delta: 两个周期：Identification.residue、Identification.periodic_whole、Identification.period_extends、
       Identification.lassos_agree。强归纳与套索世界：Identification.below_upto、Identification.below_all、
       Identification.lassoPos_early、Identification.lassoPos_period。有界的记录：Identification.statesBelow_mono、
       Identification.statesBelow_iff_lasso、Identification.statesBelow_pos、Identification.le_twice_less_one、
       Identification.bounded_agree、Identification.record_eq_iff、Identification.record_fixes、
       Identification.record_short、Identification.mark、Identification.record_short_twice、
       Identification.statesBelow_shift、Identification.sameAhead_iff_below。界给定时的归纳：
       Identification.lasso_of_fits、Identification.fits_of_unrefuted、Identification.bounded_induction、
       Identification.bounded_hypothesis。知道界的学习者：Identification.BorneOut、Identification.decBorneOut、
       Identification.borneOut_record_iff、Identification.column、Identification.grid、Identification.mem_column、
       Identification.mem_grid、Identification.firstFit、Identification.firstFit_sound、Identification.firstFit_found、
       Identification.Fits、Identification.decFits、Identification.claimBy、Identification.knowing、
       Identification.knowing_right、Identification.knowing_holds、Identification.knowing_earliest、
       Identification.denial_derived、Identification.answer_exceeds_bound。不知道界的学习者：
       Identification.unrefuted_persists、Identification.learner_rests、Identification.rests_of_lasso、
       Identification.held_learner_rests。命名：Law.orbit_held、Law.statesBelow_held、
       Law.sameFuture_iff_below、Law.name、Law.name_makesSense、Law.name_carries、Law.decideAlike
Supplied premises / correspondence: 不加公理；除了状态数的界不加前提；界写在每条定理之中（StatesBelow o N，或世界被长度
       为 N 的列表持有）；学习者与按名判定相同要所识的值可判定（DecidableEq），这是 P73 的“值可判定”；读法是 AI 的
Evidence: 合并检查器回执 20261013T085153.061517Z（Becoming.Identification 42 项定理，全部源声明公理报告为空），外围回执 20261013T085221.613502Z
Boundary: 界是状态数的界。界给学习者时，它从 2N − 1 起每步都对；界成立而学习者不知道时，P73 的学习者在 N + (2N − 1)·tri N
          之前静止，这一步由界给出，学习者的记录不表明它；没有界时，记录不确定下一个值，套索学习者不静止（P73）。N + N' − 1 对一般的
          N、N' 是充分的；精确性只对 N = 1（record_short）与 N = N'（record_short_twice）陈述。同一历史的两个时刻、同一世界
          的两个配置的更锐的界（Moore 1956）没有陈述。只陈述确定的律与单个所识的历程；有分支的框架与概率没有陈述。
          不含伦理谓词
Integration: 计划 P83；回答 P70–P72 留下的后两个开放问题；“完整的真可按情境推出”读作：给出状态数的界，所识的一切从长 2N − 1
             的记录推出，不能更短；把 P73 的未知界的结果补成恰好的边界；把 P69 的有意义的切分以有限的名给出
```

| 声明 | 内容 |
|---|---|
| `Identification.residue`、`Identification.periodic_whole` | 每一步是一个不超过 `p` 的余数加整周期 `p + 1`；周期为 `p + 1` 的历程在整周期之后取原值（不用 `Nat` 的取模引理，它们依赖 `propext`） |
| `Identification.period_extends` | **两个周期（Fine 与 Wilf，1965）。** 周期为 `p + 1`、在前 `p` 步都在 `Q` 步后回来的历程，在每一步都在 `Q` 步后回来：`p + Q、p + 2Q、…` 的余数走过一个循环，唯一没有给出的那一步（在 `p`）沿循环的其余部分传回来 |
| `Identification.lassos_agree` | 从第 `i`、`i'` 步起以周期 `q + 1`、`q' + 1` 重复的两个历程，在 `(i + q + 1) + (i' + q')` 之前相同，就在每一步相同 |
| `Identification.statesBelow_iff_lasso`、`Identification.statesBelow_mono`、`Identification.statesBelow_pos` | 历史至多有 `N` 个状态，恰当它从某一步 `i` 起以某个周期 `q + 1` 重复，`i + q + 1 ≤ N`（P70 的 `finitely_many_states_iff` 与 P73 的套索的有界形式） |
| `Identification.bounded_agree`、`Identification.record_eq_iff`、`Identification.record_fixes` | 至多 `N` 个与至多 `N'` 个状态的两段历史，在 `N + N' − 1` 之前相同，就在每一步相同；记录相等恰当历程在记录长度之前相同；所以长 `N + N' − 1` 的记录确定历程 |
| `Identification.record_short`、`Identification.mark`、`Identification.record_short_twice` | 不能更短：对每个 `T`，一个状态的历史与 `T + 1` 个状态的历史有相同的长 `T` 的记录而在 `T` 不同；对每个 `N ≥ 2`，两段至多 `N` 个状态的历史有相同的长 `2N − 2` 的记录而在那里不同（每 `N` 步标记一次与每 `N − 1` 步标记一次） |
| `Identification.statesBelow_shift`、`Identification.sameAhead_iff_below` | 有界历史的较晚一段仍在界内；两个时刻是同一状态，恰当其后所识的在 `2N − 1` 步内相同 |
| `Identification.lasso_of_fits`、`Identification.fits_of_unrefuted`、`Identification.bounded_induction`、`Identification.bounded_hypothesis` | **界给定时，归纳就是演绎。** 至多 `N` 个状态的历史上，`N` 之内的套索假设在长 `2N − 1` 的记录上不被否证，就在每一步不被否证；总有这样的假设。证明：以 P73 的套索世界读记录，得到第二段在界内、在 `2N − 1` 之前相同的历史 |
| `Identification.BorneOut`、`Identification.borneOut_record_iff`、`Identification.grid`、`Identification.firstFit`、`Identification.Fits`、`Identification.claimBy`、`Identification.knowing` | 知道界 `N` 的学习者：在 `2N − 1` 之前不说；之后以网格中第一个在 `N` 之内且为记录所证实的套索假设作主张。记录证实一个主张者，恰当它在记录长度之前不被否证 |
| `Identification.knowing_holds`、`Identification.knowing_right` | 它在任何至多 `N` 个状态的历史上都不被否证，从 `2N − 1` 起每一步都对 |
| `Identification.knowing_earliest` | 不能更早：给出两个值，没有在每段至多 `N ≥ 2` 个状态的历史上都不被否证的学习者，在 `2N − 2` 步对每段都作主张 |
| `Identification.denial_derived` | 说谎者的真被推出：二值否定没有一个固定的值被证实（`Diagonal.revision_never_rests`），知道有两个状态的学习者从第 3 步起每一步都对 |
| `Identification.answer_exceeds_bound` | 回答自己的学习者的世界超出学习者所知的界：回答知道 `N` 的学习者每个主张的历程有多于 `N` 个状态（P73 的 `diagonal_unrested`） |
| `Identification.unrefuted_persists` | **不被否证 `2N − 1` 步就永不被否证。** 至多 `N` 个状态的历史上，`N` 之内的套索假设 `(a, b)` 从第 `s ≥ a` 步起 `2N − 1` 步内不被否证，就从 `s` 起处处不被否证：从 `s` 起的一段在长 `2N − 1` 的记录上以周期 `b + 1` 重复，所以处处如此（`lasso_of_fits`） |
| `Identification.learner_rests`、`Identification.held_learner_rests`、`Identification.rests_of_lasso` | **不知道界的学习者在界内静止。** 至多 `N` 个状态的历史上，P73 的按否证学习者（套索假设按对角排列，不知道 `N` 也不知道历程）从第 `N + (2N − 1)·tri N` 步起每步主张且正确：它所持的假设都在 `N` 之内；从 `N` 起每段 `2N − 1` 步中它被否证，或所持的假设永不再被否证；它被否证少于 `tri N` 次。列表持有的世界中 `N` 是列表的长度；套索历程上，P73 的 `rest_unrefuted` 留作不被否证的静止被找到。构造的证明：只比较两个自然数，不用排中律 |
| `Law.orbit_held`、`Law.statesBelow_held`、`Law.sameFuture_iff_below` | 列表在律下封闭时，其成员的所识的未来至多有列表长度个状态；两个成员的所识的未来相同，恰当它们在 `2N − 1` 步内相同 |
| `Law.name`、`Law.name_makesSense`、`Law.name_carries`、`Law.decideAlike` | **有意义的切分，不用商就命名。** 列表持有的世界中，以长 `2N − 1` 的所识的未来（一个有限列表）命名每个配置，这一命名有意义（P69 的 `MakesSense`）；名承载规律；值可判定时，比较名就判定相同 |

**它回答了什么。**
- **从有限的记录推出律。** 状态数的界给定时可以推出，而且记录长度是恰好的：至多 `N` 与 `N'` 个状态的两段历史，长 `N + N' − 1` 的记录确定它们（`bounded_agree`，经 Fine 与 Wilf 的两个周期定理），在 `N = 1` 与 `N = N'` 时更短的不行（`record_short`、`record_short_twice`）。界不给出时，没有记录确定下一个值（`no_record_fixes_next_finite`）。所以“按情境”恰是界：情境给出它所识的状态有多少，有限的记录就确定它的整个历程。
- **归纳成为演绎。** 至多 `N` 个状态的历史上，一个 `N` 之内、在长 `2N − 1` 的记录上不被否证的套索假设，就是整个历程的律（`bounded_induction`）。知道界的学习者从 `2N − 1` 起每一步都对，在任何地方都不被否证（`knowing_right`、`knowing_holds`）；没有这样的学习者能更早地总作主张（`knowing_earliest`）。
- **不知道界的学习者在界内静止。** P73 的按否证学习者不知道界，它会静止这一点在那里不被否证（`held_rest_unrefuted`）。界成立时它静止的步由界给出：至多 `N` 个状态的历史上，它从第 `N + (2N − 1)·tri N` 步起每步主张且正确（`learner_rests`、`held_learner_rests`），因为 `N` 之内的套索假设在一段 `2N − 1` 步中不被否证就永不被否证（`unrefuted_persists`）。它自己不知道这一步：它的记录从不表明它已静止（`no_record_fixes_next_finite`），因为同样的记录也属于状态更多的世界。所以知道界与不知道界的差别不在最后是否对，而在何时对，以及能否知道已对：知道界的学习者从 `2N − 1` 起对并且从不被否证；不知道界的学习者最终对，却被否证过，也不知道自己何时已对。
- **命名有意义的切分的类，不用公理。** 列表持有的世界中，每个配置以它长 `2N − 1` 的所识的未来命名；名相等恰当所识的未来相同，所以这一命名就是 P69 的有意义的切分（`Law.name_makesSense`），名承载规律（`Law.name_carries`），相同可以判定（`Law.decideAlike`）。以整个所识的未来（一个函数）命名需要函数外延性，Lean 由商公理 `Quot.sound` 证明它；界使有限的名足够。
- **包括控制者。** 这些陈述中的世界是任何列表持有的世界，其中的控制者或认知是所识的一部分（P70 的 `Law.adaptive_makesSense_iff`）。一个经过证明的障碍是回答学习者每个主张的世界：这样的世界有多于学习者所知的那个界的状态；此定理不把它刻画为超出界后学习者失效的唯一方式（`answer_exceeds_bound`）。说谎者不是这种世界：它的真是节律，知道两个状态的学习者从第 3 步起推出它（`denial_derived`）。

**读法。** 以下是 AI 的，待 Ren：
- 对 Ren 的推测：投影是限制，一个有限的记录也是一个投影；界是使这个投影对整个历程不失去什么的东西。“完整的真按情境可推出”，读作：情境给出它的状态数，所识的一切，包括其中的控制者，从长 `2N − 1` 的记录推出，不能更短；情境不给出界时，没有有限的记录足够。
- 自我预测：认知在它所识的世界之中，仍可以在满足给定状态数之界时推出所识历程的律；回答它每个主张的世界是已证明超出这个界的一种障碍，并非对界外所有失效方式的刻画。P71 的“从内部不能一次全部说出”与此并不冲突：那里是同时持有每个读法，这里是推出一个有界历程的律。
- 名：有界时，一个类的名是它在界内所识的未来，一个有限的东西；“名可名”可读作有界时的有限名，以整个未来为名需要一条公理。这是 AI 早先“名可名，非常名”读法的一个精确化，是否采用由 Ren 判断。

**作者反审。**
1. **核心是已知的定理。** Fine 与 Wilf（1965）的两个周期定理；有界时有限的观测确定自动机的行为，是 Moore（1956）一类的结果；Gold（1967）区分了极限中的辨识与有限的辨识。增量是：在核心中不用公理、不用取模引理证明它们；与 P73 的未知界的结果和 P69 的有意义的切分连成一体；给出知道界的学习者及其恰好的起点；把命名的问题落在函数外延性上。
2. **界只对 `N = 1` 与 `N = N'` 是恰好的。** 对一般的 `N`、`N'`，`N + N' − 1` 是充分的，恰好与否要 Fine 与 Wilf 定理的极值构造，没有陈述。
3. **同一历史的界较松。** `sameAhead_iff_below` 与 `Law.sameFuture_iff_below` 用 `2N − 1`；同一历史的两个时刻、同一世界的两个配置，Moore 的界约为 `N`，没有陈述。
4. **学习者要求值可判定。** `knowing` 与 `decideAlike` 用 `DecidableEq`；`bounded_agree`、`lasso_of_fits`、`Law.name_makesSense` 不用。
5. **`answer_exceeds_bound` 只对知道 `N` 的学习者。** 对每个学习者的一般陈述是 P73 的 `diagonal_unrested`；这里是它与界的连接。
6. **静止之界粗。** `learner_rests` 的 `N + (2N − 1)·tri N` 约为 `N³`：它来自每段 `2N − 1` 步中至少一次否证与少于 `tri N` 次否证，不是最优；最优的界没有陈述。P73 的 `held_rest_unrefuted` 以双重否定陈述，这里不改它，只给出构造的静止之步；那里是本模块所陈述的范围，不是“不能给出”。

**检查。**
- 模块在暂存区对 main 的核心（加上 P69 的 `Unfolding`、P73 的 `Learning` 与 P70–P72 的模块）编译，没有错误或警告；逐条审计全部常量，公理报告全部为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。`Nat` 的取模与减法引理依赖 `propext`，所以不用：余数由本模块自己的归纳给出，套索世界取 P73 的 `lassoNext`。
- 合并检查器在落地队列中检查一次，通过：回执 20261013T085153.061517Z。`Becoming.Identification` 的 42 项定理全部空依赖。外围回执 20261013T085221.613502Z。
- 独立审查范围：2026-10-13 接续时 Ren 提供的会话交接报告称，P73 的所有者审查过加入有界静止之步前的版本，并要求纠正对 Learning 的双重否定的读法、以 period_extends 给出构造的静止之步；本包采用了这些修正。最终 42 项定理版本的独立审查尚未确认。

## 98. 历史固定什么：律与历史的完备对应，检验固定相同的条件（P76）

2026-10-12。Ren 问封闭的百分比，随后设定会话目标：“move towards 100%, you can spawn a few agents for help, pick the "What would move it most next" first, and don't stop until we are 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）。缺口之一是强意义上的完备：一类规律是该类的全部规律；此前只对计数成立（每个计数表都由某个列出计数，`tally_iff_counted`）。P69（§91）证明历史固定它所显示的律，并指出对应不是同一之处：死路与拼接。本节证明这两者就是律与历史之间的全部规律，并给出检验固定相同的构造性条件。本节在工作板上认领为 P76。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Histories`（L3），27 项定理，只导入 `Becoming.Unfolding`，不改任何已有模块。

成果记录新增两项：[histories-fix-law-up-to-dead-ends](../../../../theories/becoming/results/records/histories-fix-law-up-to-dead-ends.md) 与 [tests-fix-likeness-where-determined](../../../../theories/becoming/results/records/tests-fix-likeness-where-determined.md)。

```text
Result(s): 复用 process-and-frame-as-readings（Run、Shown、Consistent、DeadEnd、Splice、Run.keepHistory_shown）、
           configurations-alike-by-relation（Bisimulation、Alike、Alike.trace、Alike.tests、DeterminedAt、Determined.at）、
           joint-difference-making（Determined）；GenerativeCore 的 Trace、trace_nil_iff、trace_cons_iff；新增上列两项
Delta: 律与历史族：Admits、Run.admits、ShownBy、ShownBy.admits、shownBy_le_iff、SpliceClosed、admits_spliceClosed、
       family_iff、ConsistentFamily、shownBy_determined_iff、determined_family_iff；活的步：live、live_le、admits_live_iff、
       same_histories_iff、live_live、DeadEnd.not_live；会停止的历史：Trace.of_same、same_finite_histories_iff、MadeOfSteps、finite_family_iff。检验：SameTests、Alike.sameTests、SameTests.after、
       sameTests_bisimulation、alike_iff_sameTests、Determined.alike_iff_sameTests；Choosing（Move、Pos、Late、Early、late、
       early、Open、late_open、early_open、late_of_open、early_of_open、sameTests、not_alike、early_not_determined）
Supplied premises / correspondence: 不加公理，也不加前提；family_iff、determined_family_iff、same_histories_iff 与
       alike_iff_sameTests 是双向的；alike_iff_sameTests 以两个框架处处在相同之下确定为条件，Choosing 说明没有它不成立；
       历史是不终止的序列（表示的承诺）；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261013T085835.650723Z（Becoming.Histories 27 项定理，全部源声明公理报告为空），外围回执 20261013T085914.780427Z
Boundary: 实际展开的历史是否终止没有陈述；核心中分支检验固定相同没有陈述（外围的证明用经典逻辑，配置有限时是否有构造性
          证明，这里开放）；实际展开是哪一族历史没有陈述；不含伦理谓词
Integration: 计划 P76；P69 的死路与拼接成为律与历史之间的全部规律；给出 configurations-alike-by-relation 的 next_delta
             所求的构造性条件（相同之下的确定性）
```

| 声明 | 内容 |
|---|---|
| `Admits`、`Run.admits`、`ShownBy`、`ShownBy.admits`、`shownBy_le_iff` | 律容许一段历史，指历史的每一步都是律的一步；一族历史所显示的律以族中历史所走的步为步，是容许族中每段历史的最小的律 |
| `SpliceClosed`、`admits_spliceClosed`、`family_iff` | 一族历史含有它的拼接，指由它自己的步组成的每个序列都在族中；律的历史族如此；一族历史恰在如此时是某个律的历史族 |
| `ConsistentFamily`、`shownBy_determined_iff`、`determined_family_iff` | 一族历史一致，指其中任何两段历史从不以同一动作把同一配置带到两处；所显示的律恰在这时确定；一族历史恰在含有拼接且一致时是某个确定的律的历史族 |
| `live`、`live_le`、`admits_live_iff`、`same_histories_iff`、`live_live`、`DeadEnd.not_live` | 律的活的步是它的某段历史所走的步；律与它的活的步容许同样的历史；两个律恰在活的步相同时容许同样的历史；活的律没有死路；死路的那一步不是活的 |
| `Trace.of_same`、`same_finite_histories_iff`、`MadeOfSteps`、`finite_family_iff` | 会停止的历史下没有死路：两个律恰在步相同时有同样的有限历史；一族有限历史恰在由它的步组成时是某个律的有限历史族 |
| `SameTests`、`Alike.sameTests`、`SameTests.after` | 通过同样的检验：开放的动作序列相同，每个序列之后能实现的主张相同；相同的配置如此；两侧在相同之下确定时，它在一个动作之后保持 |
| `sameTests_bisimulation`、`alike_iff_sameTests`、`Determined.alike_iff_sameTests` | 两个框架处处在相同之下确定时，通过同样的检验是互模拟，所以配置恰在通过同样的检验时相同 |
| `Choosing.sameTests`、`Choosing.not_alike`、`Choosing.early_not_determined` | 在第一步之后选择与在第一步选择的两个框架，起点通过同样的检验而不相同；后者不确定 |

**它回答了什么。**
- **律与历史之间的全部规律。** 从历史读出的律，就是含有拼接的历史族（`family_iff`）；历史把律固定到死路为止（`same_histories_iff`）。所以不计死路的律与含有拼接的历史族一一对应：P69 的两处“对应不是同一”就是全部。确定的律多一个条件，一致（`determined_family_iff`）。会停止的历史下死路消失，律恰由它的有限历史固定（`same_finite_histories_iff`、`finite_family_iff`）：死路是不终止历史的事实。
- **检验何时固定相同。** 线性检验（动作序列，加一个最后的主张）在相同之下确定时固定相同（`alike_iff_sameTests`）；没有这一条件时未必固定（`Choosing`）。外围中带否定与合取的分支检验对像有限的模型固定相同（`same_iff_bisimilar`，经典）。

**读法。** AI 的，待 Ren。Ren 同意律与历史是同一展开的两种读法、律从展开读出（“there are no two realities”）。在本结果之下：从历史读出的律就是含有拼接的历史族，别无其他；置于展开之上的律所能多出的只是死路，没有历史显示它们。拼接是记忆的缺席：律从所在处作答，不从怎样来到此处作答，所以记住来路的历史（保留的历史）所显示的律只容许它自己（`Run.keepHistory_shown`）。检验看不到的是选择在何时作出；有分支时，只有分支的检验看得到。

**作者反审。**
1. **证明短。** 每条定理只有几行；内容在于刻画是双向的、完备的，以及条件的边界（`Choosing`）。
2. **死路依赖于历史不终止。** 本节对两种历史都给出完备对应：不终止的历史下有死路，会停止的历史下没有。实际展开的历史是否终止，不是这里能定的。
3. **分支检验的完备留在外围。** 核心只给线性检验在相同之下确定时的完备；分支检验的构造性证明开放。

**检查。**
- 模块在暂存区对 main 的核心与 P69 的 `Becoming.Unfolding` 编译，没有错误或警告；逐条审计全部 162 个常量，公理报告全部为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`，不用 `simp`、`omega` 或 `decide`。
- 合并检查器在落地队列中检查一次，通过：回执 20261013T085835.650723Z。包共 3302 项定理、4810 项声明审计，核心闭包 66 个模块。
- 尚无独立审查。

## 99. 路径分支时：返回、被吸入与相同之下的确定（P81）

2026-10-12。按 Ren 的会话目标“move towards 100%, you can spawn a few agents for help, pick the "What would move it most next" first, and don't stop until we are 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）。R6（`Becoming.Recurrence`）与 P67（`Becoming.Attraction`）对确定的律 `next` 陈述它们的规律：配置固定它的整条路径。脊柱的过程只固定哪些步可容许：从一个配置可以有几个动作，或一个动作有几个结果，路径分支。检查 R6 的三方等价（无损、返回、保留每个可能）是否对不确定的过程成立时，发现它不成立。本节对每个过程陈述 R6 与 P67 的规律，说明哪些保留、哪些只单向成立、哪些不成立，各给见证；把 `Becoming.Experiment` 与 `Becoming.Mechanism` 中以 `Determined` 陈述的定理在相同之下（P69 的 `DeterminedAt`）重述，需要相等之处给出见证；并把 Capture 的规则区域陈述为 P67 吸收区域的实例。本节在工作板上认领为 P81。它不加公理，也不加前提，属于第一部分。核心新增模块 `Becoming.Branching`（L3），119 项定理，导入 `Becoming.Unfolding`、`Becoming.Attraction` 与 `Becoming.Capture`，不改任何已有模块（在已有命名空间 `Run`、`Reach`、`Law`、`Twins`、`Coarse`、`Confound`、`Captured` 中新增定理，不改已有声明）。模块由本会话的一个 Opus 子代理构建，由本会话检查。

成果记录新增三项：[returning-where-the-course-branches](../../../../theories/becoming/results/records/returning-where-the-course-branches.md)、[necessarily-drawn-is-not-returning](../../../../theories/becoming/results/records/necessarily-drawn-is-not-returning.md) 与 [determinacy-up-to-likeness](../../../../theories/becoming/results/records/determinacy-up-to-likeness.md)。

```text
Result(s): 复用 recurrence-without-premise（Law.Returns、Law.Lossless、Law.Keeps 与三方等价）、attraction-is-not-returning
           （Law.Absorbing、Law.DrawnInto、Law.drawn_iff_not_returns）、process-and-frame-as-readings（Run、Fork、DeadEnd）、
           configurations-alike-by-relation（Bisimulation、Alike、DeterminedAt、Twins）、experiment-needs-return（Run.Fixes、
           retarget、keepHistory、Confound）、projection-carrying-a-law（GoAlike、DependsOnlyOn、forget、inputs、Coarse、
           carries_law_iff）、target-capture（Captured、Law.reform_reabsorbed）；新增上列三项
Delta: 路径：Branching.Reachable、Returns、KeepsPossibilities、Lossless、Merges、lost_stays、Returns.reachable、keeps_of_returns、
       keeps_iff_fed、returns_iff_fed_ahead、returns_iff_fedWithin、KeepsWithin、keepsWithin_iff_fedWithin、returns_iff_keepsWithin；
       有限多配置之内：Lossless.comes_back、Lossless.recurs、Lossless.returns、Lossless.no_rise、rise_not_lossless、
       Lossless.unlisted、Run.enters_returning；返回者的运行：Returns.run；被吸入：PossiblyDrawnInto、NecessarilyDrawnInto、
       PossiblyDrawn、NecessarilyDrawn、possiblyDrawn_iff、PossiblyDrawnInto.never_back、necessarilyDrawnInto_ahead、
       NecessarilyDrawnInto.not_returns、necessarilyDrawn_iff_not_returns、reachable_invariant、lost_necessarily_drawn、
       NecessarilyDrawn.not_lossless、Determined.moves_decide、Determined.stays_merged；确定的律是实例：law_*；见证：OneWay、
       Transit、fork_lossless_not_returns、Coarse.meet_and_part；相同之下：determined_iff_named、goesAlike_iff、
       DeterminedAt.stays_alike、DependsOnlyOnAlike.reabsorbed、forget_inputs_determinedAt_iff、Run.fixesAlike_of_takes、
       Run.generalizesAlike、Run.not_fixesAlike_of_untaken、retargetAlike、keepFrame_alike_iff、keepHistory_new_named、
       carries_unregistered、Twins.retarget_breaks、Confound.refutes_registered；Capture：Law.rule_absorbing、Law.held_absorbing、
       Law.reform_drawnInto、Captured.rule_region_absorbing、Captured.state_reform_drawn、Captured.rule_reform_drawn
Supplied premises / correspondence: 不加公理，也不加前提；returns_iff_fed_ahead、returns_iff_keepsWithin、
       necessarilyDrawn_iff_not_returns、possiblyDrawn_iff 与 determined_iff_named 是双向的；沿运行的定律以一个运行为给定
       （从每个能动的配置都有运行要选择）；“有限多配置”指某个列表持有运行的配置；读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261013T085835.650723Z（Becoming.Branching 119 项定理，全部源声明公理报告为空），外围回执 20261013T085914.780427Z
Boundary: 从每个能动的配置出发的运行（选择）；在界内被吸入；实际展开进入哪些区域；分支路径上的度量（P82）；
          carries_law_iff 在相同之下的双向形式；Image／FactorsThrough 的刻画、not_fixes_other_of_new 与 Joint 的
          determined_dichotomy 在相同之下没有重述；不含伦理谓词
Integration: 计划 P81；回答 recurrence-without-premise 与 attraction-is-not-returning 的 next_delta 中不确定过程的一项、
             attraction-is-not-returning 中 Captured 的规则区域一项，以及 configurations-alike-by-relation 中
             以 Determined 陈述的定理在相同之下重述一项的主要部分
```

| 声明 | 内容 |
|---|---|
| `Branching.Reachable`、`Branching.Returns`、`Branching.Lossless`、`Branching.Merges`、`law_reachable_iff`、`law_returns_iff`、`law_lossless_iff`、`law_merges_iff`、`law_keeps_iff` | 配置 n 步之后可得，指有 n 个动作的路径通向它；它返回，指从它的一步通向能再得到它之处；过程合并，指两个不同的配置一步到同一处；在确定的律下每个都是 R6 的 |
| `Branching.lost_stays`、`Branching.Returns.reachable`、`keeps_of_returns`、`keeps_iff_fed` | 失去的可能保持失去；返回的配置每步可得，所以处处返回则保留每个可能；保留每个可能恰是每个配置下一步可得 |
| `returns_iff_fed_ahead`、`returns_iff_keepsWithin`、`returns_iff_fedWithin`、`keepsWithin_iff_fedWithin` | 配置恰在它自己的路径下一步能再得到它时返回；每个配置都返回，恰在过程从不离开的每个区域都保留它自己的每个可能时；不用有限性 |
| `Lossless.comes_back`、`Lossless.recurs`、`Branching.Lossless.returns`、`Branching.Lossless.no_rise`、`Branching.rise_not_lossless`、`Branching.Lossless.unlisted` | 列表持有运行的配置、过程不合并时，运行的每个配置在运行上回来，运行开始处的配置返回，沿运行从不下降的量保持不变；这样的量严格上升与不合并矛盾（结论为 ¬ Lossless，不给出 Merges 的见证）；不合并而有不返回的配置需要开放 |
| `Transit.keeps_not_returns`、`OneWay.merge_keeps`、`fork_lossless_not_returns`、`Coarse.meet_and_part`、`Determined.stays_merged` | 保留每个可能不给返回；合并不必失去可能；不合并沿运行才给返回（Fork 的终点不能动）；合并后保持合并需要确定 |
| `PossiblyDrawnInto`、`NecessarilyDrawnInto`、`PossiblyDrawn`、`NecessarilyDrawn`、`law_possibly_iff`、`law_necessarily_iff`、`law_drawn_iff` | 某条路径进入区域是可能被吸入，每个运行都进入是必然被吸入；被吸入，指某个过程从不离开的区域如此吸入它；在确定的律下两者都是 P67 的 |
| `Branching.Returns.run`、`necessarilyDrawn_iff_not_returns`、`NecessarilyDrawnInto.not_returns`、`necessarilyDrawnInto_ahead` | 返回的配置有一个从不失去它的运行；每个过程必然吸入的恰是不返回者（`Law.drawn_iff_not_returns` 的推广） |
| `possiblyDrawn_iff`、`PossiblyDrawnInto.never_back`、`OneWay.possibly_not_necessarily`、`Determined.moves_decide` | 可能被吸入就是在某一路径中失去自身，沿该路径被锁定；可能被吸入者可以在另一路径中返回；确定的过程下动作决定运行是否被吸入 |
| `reachable_invariant`、`lost_necessarily_drawn`、`Run.enters_returning`、`NecessarilyDrawn.not_lossless`、`Transit.returning_not_invariant` | 每个过程下未来变窄，失去的可能必然被吸入；有限多配置之内每个运行进入返回者，运行起点必然被吸入与不合并矛盾（结论为 ¬ Lossless）；返回者不是过程从不离开的区域 |
| `determined_iff_named`、`alike_configurations`、`goesAlike_iff`、`DeterminedAt.stays_alike`、`DependsOnlyOnAlike.reabsorbed`、`forget_inputs_determinedAt_iff` | 主张命名配置时，确定就是相同之下的确定；经相同而同行、相同的运行保持相同、不依赖者被重新吸收、标准模型在噪声无差别时确定，都在相同之下成立 |
| `Run.fixesAlike_of_takes`、`Run.generalizesAlike`、`Run.not_fixesAlike_of_untaken`、`retargetAlike`、`retargetAlike_determinedAt` | 所取的动作在相同之下固定，一次代表其类；未取的动作对在一个主张上不同的结果不被固定，经对整个相同类的干预 |
| `Twins.retarget_breaks`、`keepFrame_alike_iff`、`keepHistory_returns_alike`、`keepHistory_new_named`、`carries_unregistered`、`Confound.refutes_registered` | 需要相等之处：改送两个相同配置之一破坏相同之下的确定；过去没有被登记时保留的历史在相同之下返回；没有主张时每个描述承载规律，没有混杂被否证 |
| `Law.rule_absorbing`、`Law.held_absorbing`、`Law.reform_drawnInto`、`Captured.rule_region_absorbing`、`Captured.held_absorbing`、`Captured.state_reform_drawn`、`Captured.rule_reform_drawn` | 规则保持自身时，规则给定的配置是律从不离开的区域；下一配置只依赖规则时，规则所持的配置固定，改过的状态第一步被吸入它；Captured 中改过的状态或规则被吸入且不返回 |

**它回答了什么。**
- **路径分支时的返回。** 返回比保留每个可能要求得多：一个配置可以从别处一再得到，而从不回到自己（`Transit.keeps_not_returns`）。精确条件是局部的：配置恰在它自己的路径能再得到它时返回（`returns_iff_fed_ahead`），处处返回恰是过程不离开的每个区域都保留它自己的每个可能（`returns_iff_keepsWithin`）。R6 的“不失去即返回”在有限多配置之内沿每个运行成立（`Branching.Lossless.returns`），但不能省去运行（`fork_lossless_not_returns`）；合并不必失去可能（`OneWay.merge_keeps`）。
- **可能与必然被吸入。** 每个过程必然吸入的恰是不返回者（`necessarilyDrawn_iff_not_returns`），所以 P67 的主律对每个过程成立；可能被吸入是在某一路径中失去自身（`possiblyDrawn_iff`），可能被吸入者可以在另一路径中返回（`OneWay.possibly_not_necessarily`）。P67 的其余规律中，未来变窄与失去的可能被吸入对每个过程成立；返回者的区域吸入其余一切、合并吸入两者之一，对过程不成立（`Transit.returning_not_invariant`、`OneWay.merge_keeps`）。
- **相同之下的确定。** 确定是相同之下确定的命名情形（`determined_iff_named`），所以问题是哪些定理对每种主张成立。关于配置怎样相关的定理在相同之下成立；需要相等的是对相同者之一的干预、没有登记的过去与没有登记的描述（`Twins.retarget_breaks`、`keepHistory_new_named`、`carries_unregistered`）。
- **Capture 是吸引。** Capture 的规则区域是吸收区域，改过的状态被吸入规则所持之处（`Law.rule_absorbing`、`Captured.state_reform_drawn`）。

**读法。** AI 的，待 Ren。路径分支时，返回比保留每个可能要求得多：返回的是它自己的路径能再得到的。可能与必然被吸入恰在路径开放之处分开：一个配置可以在一条路径中被吸入，在另一条中回来；每条路径都吸入的是不返回者，某条路径吸入的是能失去自身者。有分支时，合并本身不失去可能，失去可能也不需要合并；R6 的“不失去即返回”是有限多配置之内确定变化的规律，在每个过程下沿每个运行成立。相同是展开自己对配置的同一：在相同之下成立的确定性定理讲配置怎样相关，需要相等的定理取决于登记了什么，没有什么登记的既不固定也不被否证（参见 `Becoming.Testing` 的登记）。Capture 读作吸引：只改状态会被吸回规则所持之处，吸引子只随规则移动。

**作者反审。**
1. **沿运行的定律以运行为给定。** 从每个能动的配置出发的运行要在每步选择一个延续，这是选择；需要运行的定律以一个运行为前件。核心的运行不终止，所以没有运行开始的配置空真地必然被吸入每个不含它的区域；这是表示的事实，已写入模块说明。
2. **见证小。** `OneWay`、`Transit` 与 Fork 各只有两三个配置；它们表明单向与不成立，不表明这些情形常见。
3. **“有限多配置”是列表。** 与 R6 一样，指某个列表持有运行的配置，不是基数。
4. **相同之下的重述不完全。** `Experiment` 与 `Mechanism` 中关于配置怎样相关的主要定理已在相同之下重述，需要相等之处给出见证；“某过程确定”的实例经 `Determined.at` 直接给出相同之下的确定。没有重述的：`Mechanism` 中投影的确定性刻画（`Image`、`FactorsThrough`）、`Experiment` 的 `not_fixes_other_of_new`、`Joint` 的 `determined_dichotomy`；`carries_law_iff` 在相同之下的双向形式没有给出。

**检查。**
- 模块由子代理在暂存区对本会话的核心与 P69 的 `Becoming.Unfolding` 编译（308 个常量，没有警告，公理报告为空），与 P76 的 `Histories` 一起编译没有名称冲突。本会话 10-12 以 `scratch_build.py` 对 main `66dc4450` 与 P69 的 `Unfolding` 重建：119 项定理、156 项声明，没有公理，没有警告。为让检查器的解析器读得到，五个写作 `_root_.Becoming.Run.*` 的声明与 `_root_.Becoming.Reach.of_dead_end` 移入 `namespace Run` 与 `namespace Reach` 块（名称与陈述不变）。没有 `sorry`、`axiom`、`Classical` 或 `native_decide`，不用 `simp`、`omega` 或 `decide`。
- 合并检查器在落地队列中检查一次，通过：回执 20261013T085835.650723Z。包共 3302 项定理、4810 项声明审计，核心闭包 66 个模块。
- 尚无独立审查。

## 100. 回应由动力学给出：反事实是规律的进程（P80）

2026-10-12。P64–P68 落地（`bca9695b`）之后，Ren 说：“another agent has got this far, maybe merge first and see if there is something to work on”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-merge-first.md)）。AI 在本章 §8 的进一步证明中找到一项与 P65 相接、无人认领的：“他者有回应的比较，由动力学给出回应而不是另给第二个流”，它也是 P65 记录的下一步。AI 在工作板上认领为 P80，整合者（Universal Metaethical Core）接受并排在 P76 之后。提议与读法是 AI 的。P65（§87）在回应所及之内决定比较，给出两样：第二个流，与其余经识回应的前提（`Flow.RespondsThroughRegistration`）。本节把其余的交换给作一个规律，两样都推出。不加公理；交换律、它读已立者、进程可行与条件有限，每条都只作为用到它的定理的假设。属于第一部分。核心新增模块 `Becoming.Counterfactual`（L4），46 项定理，导入 `Becoming.Response`、`Becoming.Mechanism` 与 `Becoming.Unfolding`，不改任何已有模块。P69（`da8f75a7`）先落地；整合者把 P80 与 `Unfolding` 的实例定理交给后落地者，AI 写成 P80b，整合者同意并入本次落地（一次检查、一轮文档）。

成果记录新增一项：[counterfactual-is-the-course](../../../../theories/becoming/results/records/counterfactual-is-the-course.md)；推进四项：[comparison-where-the-rest-responds](../../../../theories/becoming/results/records/comparison-where-the-rest-responds.md)（P65 的前提由律推出，按整合者的要求推进该记录而不另立平行的主张）、[feedback-and-reach](../../../../theories/becoming/results/records/feedback-and-reach.md)、[causal-models-as-processes](../../../../theories/becoming/results/records/causal-models-as-processes.md)、[process-and-frame-as-readings](../../../../theories/becoming/results/records/process-and-frame-as-readings.md)（P80b 的实例）。

```text
Result(s): 复用 comparison-where-the-rest-responds（Flow.RespondsThroughRegistration、Flow.WithinResponse、
           Flow.Balances.comparison_within_response；Loop 的流、网与 own、firstPart）、testing-within-registration
           （Web.Registers、Web.RegistersAlike、Web.RegistersAlikeUpTo、Web.DependsOn 经 Feedback）、causal-models-as-processes
           （inputs、trajectory、inputs_intervention_unfixed、inputs_model_fixes）、laws-of-one-step（Flow.Balances、total、
           total_congr_on）、recurrence-without-premise（Law.orbit、le_succ_cases、gap_of_le、mem_cons_split）、
           process-and-frame-as-readings（World、Exchange、exchange、World.move、World.balances_iff_exchange、World.exchangeRun、
           Shown、Consistent、exists_law_iff、closedBy、closedBy_runs_agree；确定的律 Determined 经 Joint，inputs_determined 经
           Mechanism）；新增上列一项，推进上列四项
Delta: 交换律：ExchangeLaw、AgreeUpTo、ExchangeLaw.GivesAlike、ExchangeLaw.Nonanticipating、ExchangeLaw.Through、
       ExchangeLaw.InsensitiveAt、ExchangeLaw.Sensitive、Flow.Follows、Flow.ActsAlike。
       经识回应推出：ExchangeLaw.Through.responds、ExchangeLaw.Nonanticipating.through_all。
       反事实由动作固定：Flow.totals_alike_of_each、exchange_alike_of_agree、levels_fixed、counterfactual_fixed。
       生成：ExchangeLaw.takenUnder、givenUnder、extend、history、levels、course、Feasible、withAct、next、Web.withLevel、
       ExchangeLaw.history_succ_of_le、history_stable、history_agree、levels_zero、levels_succ、course_follows、totals_under、
       sub_add_back、sub_add_back_iff、course_balances_iff、history_orbit。
       敏感是最小的识：nat_eq_of_not_not、ExchangeLaw.Through.registers_of_sensitive、mixIn、mixIn_either、mixIn_listed、
       swap_alike、mixIn_alike、alike_of_sensitive_agree、ExchangeLaw.Nonanticipating.through_of_observed、
       ExchangeLaw.Nonanticipating.through_sensitive。
       比较：comparison_of_courses、comparison_through_sensitivity、ExchangeLaw.withAct_follows、
       ExchangeLaw.withAct_nonanticipating、comparison_with_act、counterfactual_is_course、ExchangeLaw.course_unique。
       输入：ExchangeLaw.ofMoves、ExchangeLaw.stepBy、ExchangeLaw.course_trajectory、ExchangeLaw.act_not_taken。
       见证：Loop.replyLaw、replyLaw_nonanticipating、replyLaw_through、escalation_follows、quiet_follows、responds_by_law、
       courses_fixed。
       作为 P69 的展开（P80b）：ExchangeLaw.world、world_balances_iff、world_exchange_iff、worldRun、Run.beyond_shown_iff、
       ExchangeLaw.counterfactual_beyond_shown、ExchangeLaw.policy、ExchangeLaw.closedBy_course
Supplied premises / correspondence: 不加公理；其余遵从的交换律是给出的；律读已立者（ExchangeLaw.Nonanticipating）是用到它的
       定理的假设；生成的进程可行（ExchangeLaw.Feasible）是 comparison_with_act、counterfactual_is_course 与
       ExchangeLaw.course_unique 的假设，已证明等价于生成的流平衡；敏感的形式假设条件有限（一个列表含每个条件）且条件的相等可判定；
       实际的流平衡、两个流的在场形成相同与起始相同，如 P65；world 系列要求形成与条件同类；Run.beyond_shown_iff 要求律确定；
       closedBy_course 要求部分的动作由律在配置上形成；不判定敏感，只判定两个数是否相等；离散的步（从第 0 步计）、自然数的量；
       读法是 AI 的，待 Ren
Evidence: 合并检查器回执 20261013T090346.930838Z（Becoming.Counterfactual 46 项定理，全部源声明公理报告为空），外围回执 20261013T090430.379669Z
Boundary: 律本身不推出（其余遵从哪个律）；读已立者不推出；条件无穷多时敏感是否仍是最小的识未陈述；差别到达多少不量；不可行的
          动作没有进程，本节不给它别的读法；两类的律不读作世界；历史之外的是模型的一步，不是完整的另一进程；何时一个动作是部分
          自己的不推出；部分的动作以“动作相同”（逐值相同）或以一个律给出；不含伦理谓词
Integration: 计划 P80；回答本章 §8“反馈与所及”中“他者有回应的比较，由动力学给出回应而不是另给第二个流”；把 P65 的给出的前提
             变为定理（推进 comparison-where-the-rest-responds），把一个动作的反事实接到 P68 的标准因果模型（干预是未取的动作），并接到
             P69 的展开（World、Shown、closedBy；推进 process-and-frame-as-readings）
```

| 声明 | 内容 |
|---|---|
| `ExchangeLaw` | 交换律：从水平历史读出每个形成跨过每步从每个条件取用与给予多少 |
| `AgreeUpTo`、`ExchangeLaw.GivesAlike` | 两段水平历史到第 t 步为止每步相同；律在第 t 步对 h 在两段历史下给出相同的取用与给予 |
| `ExchangeLaw.Nonanticipating` | 律读已立者：跨过第 t 步只读到第 t 步为止的历史 |
| `ExchangeLaw.Through` | 律对部分之外的每个形成只读其所识：识得相同到第 t 步的两段历史，律在第 t 步给出相同 |
| `ExchangeLaw.InsensitiveAt`、`ExchangeLaw.Sensitive` | 跨过第 t 步，h 的交换由其他条件到第 t 步的水平固定：c 的水平与第 t 步之后的水平都不造成差别；h 的交换对 c 敏感，是指某步不如此 |
| `Flow.Follows`、`Flow.ActsAlike` | 部分之外，流在其自身水平下按律交换；部分在两个流中动作相同 |
| `ExchangeLaw.Through.responds` | 经识回应推出：其余遵从一个只读各形成所识的律时，其余在律的任意两个进程中经识回应，即 P65 的前提，对这两个流不另给什么 |
| `ExchangeLaw.Nonanticipating.through_all` | 每个读已立者的律都经识一切而读 |
| `Flow.totals_alike_of_each`、`exchange_alike_of_agree` | 每个形成交换相同时总量相同；水平到第 t 步相同、部分动作相同、其余遵从读已立者的律时，第 t 步每个形成交换相同 |
| `levels_fixed`、`counterfactual_fixed` | 反事实由动作固定：两个平衡的流在场形成相同、起始相同，部分动作相同，其余遵从同一个读已立者的律，则每步水平相同、每个形成交换相同 |
| `ExchangeLaw.takenUnder`、`givenUnder`、`extend`、`history`、`levels`、`course` | 律从起始水平逐步生成：至今历史下的总取用与总给予，跨过一步把历史延伸，到第 n 阶段的历史，生成的水平，生成的流 |
| `ExchangeLaw.history_succ_of_le`、`history_stable`、`history_agree`、`levels_zero`、`levels_succ` | 再生成保留已生成的；第 n 阶段的历史到 n 为止就是生成的水平；生成的水平从起始水平开始，跨过一步是之前的水平加所给减所取 |
| `ExchangeLaw.course_follows`、`totals_under` | 生成的流对每个形成按律交换；律读已立者时，至今历史下的总量就是生成的流的总量 |
| `sub_add_back`、`sub_add_back_iff` | 取走再加回，恰在所取不多于所有时复原；不用 `Nat.sub_add_cancel`（它依赖 propext） |
| `ExchangeLaw.Feasible`、`ExchangeLaw.course_balances_iff` | 进程可行：律从不从一个条件取用多于其上所立与所给的；律读已立者时，生成的流平衡恰当可行 |
| `ExchangeLaw.next`、`ExchangeLaw.history_orbit` | 生成的历史是阶段与至今历史上一个确定律的轨道 |
| `Web.withLevel` | 以另一水平历史读一个网（依存不变） |
| `nat_eq_of_not_not` | 不被否证的数的相等成立（数的相等可判定） |
| `ExchangeLaw.Through.registers_of_sensitive` | 律经一个识而读时，它对一个形成敏感的每个条件，都不在形成所依存与所观察的之外（双重否定） |
| `mixIn`、`mixIn_either`、`mixIn_listed`、`swap_alike`、`mixIn_alike` | 逐个条件把一段历史换成另一段；读已立者的律在律不敏感或两段历史在该条件上相同之处，换一个条件不改变律所给 |
| `alike_of_sensitive_agree` | 条件有限时，读已立者的律在两段历史于其敏感的每个条件上到该步相同之处给出相同 |
| `ExchangeLaw.Nonanticipating.through_of_observed`、`ExchangeLaw.Nonanticipating.through_sensitive` | 所以条件有限时，读已立者的律经每个观察其敏感者的识而读，尤其经其敏感本身而读 |
| `comparison_of_courses` | 回应由动力学给出的比较：律的两个平衡的进程在场形成相同、起始相同，律经一个识而读时，对覆盖每个不在经此识画出的回应所及之外者的任何意义，每个保留另一个上有意义者恰如包含它，两者都不增加恰当两者都不超出 |
| `comparison_through_sensitivity` | 条件有限时不须给出识：回应所及经律的敏感画出 |
| `ExchangeLaw.withAct`、`ExchangeLaw.withAct_follows`、`ExchangeLaw.withAct_nonanticipating` | 部分按 act、其余按律；生成的进程中其余遵从律；两者都读已立者时合起来的律也读已立者 |
| `comparison_with_act` | 一个动作与另一个动作所生成的、可行的进程之间的比较，在经律之识画出的回应所及之内决定，不另给第二个流与回应 |
| `counterfactual_is_course` | 一个动作的反事实是它生成的进程：部分动作与进程中相同、其余遵从律、从进程的水平起的平衡的流，有进程的水平与交换 |
| `ExchangeLaw.course_unique` | 每个形成（部分在内）都遵从一个读已立者的律时，平衡的流就是律生成的进程（进程可行时） |
| `ExchangeLaw.ofMoves`、`ExchangeLaw.stepBy`、`ExchangeLaw.course_trajectory` | 部分做一列动作时生成的历史，是以部分的动作为输入、无噪声的标准模型（P68 的 `inputs`）的轨道 |
| `ExchangeLaw.act_not_taken` | 未取的动作是干预：这个模型的一次运行在第 t 步之前未在 x 取动作 a 时，记录不固定其结果，模型固定它（`inputs_intervention_unfixed`、`inputs_model_fixes` 的实例） |
| `ExchangeLaw.world`、`ExchangeLaw.world_balances_iff` | 形成与条件同类时，进程是一个世界（P69 的 `World`，网以生成的水平读）；律读已立者时它平衡恰当进程可行 |
| `ExchangeLaw.world_exchange_iff`、`ExchangeLaw.worldRun` | 这时世界的水平以关系项的交换为动作、按交换之律（P69 的 `exchange`）而行，恰当可行；可行时它是交换之律的一个运行 |
| `Run.beyond_shown_iff` | 关于 P69 的 `Shown` 的一条律，对任何确定的律：律在一个运行所显示者之外从 s 以 a 走一步，恰当它在那里走得出一步且运行从不在 s 取 a。按整合者的安排暂放在本模块（它唯一的使用者）；第二个模块需要时移入 `Unfolding`，名字与陈述不变 |
| `ExchangeLaw.counterfactual_beyond_shown` | 进程的标准模型的一次运行，其历史显示一个确定的律（`Consistent`）；部分在 x 的动作 a 有模型在历史所显示者之外的一步，恰当历史从不在 x 取 a：律在历史之外添加的恰是它的反事实 |
| `ExchangeLaw.policy`、`ExchangeLaw.closedBy_course` | 部分的动作由律 act 在配置（阶段与至今历史）上形成；P69 的 `closedBy` 从起始水平出发的运行每一步都是 `law.withAct part act` 生成的进程，所以两个这样的运行相同（`closedBy_runs_agree`） |
| `Loop.replyLaw`、`Loop.replyLaw_nonanticipating`、`Loop.replyLaw_through` | P65 的 `Loop` 中第二个形成的律：自身条件下降之后的那一步从第一个的条件取用两单位；它读已立者，只读第二个所观察的 |
| `Loop.escalation_follows`、`Loop.quiet_follows`、`Loop.responds_by_law` | 有动作与无动作的流都遵从这个律；所以 P65 逐情形检查的 `Loop.responds` 由律推出 |
| `Loop.courses_fixed` | 两个流各由第一个的动作固定：两个形成在场、第二个遵从律、两个条件都从二起的平衡的流，第一个动作如有动作的流时就有其水平与交换，第一个不动作时就有无动作的流的 |

**它回答了什么。**
- **反事实不是另给的。** 其余遵从一个读已立者的律时，部分动作相同的两个平衡的流是一个流（`counterfactual_fixed`）；所以给出律之后，一个动作至多有一个进程。律逐步生成进程，生成的流平衡恰当可行（`ExchangeLaw.course_balances_iff`）；一个动作的反事实就是它生成的进程（`counterfactual_is_course`），每个形成都遵从律时平衡的流就是律的进程（`ExchangeLaw.course_unique`）。
- **P65 的前提成为定理。** 律只读各形成所识时，其余在律的任意两个进程中经识回应（`ExchangeLaw.Through.responds`）。每个读已立者的律都经识一切而读（`ExchangeLaw.Nonanticipating.through_all`）；条件有限时，它经其敏感而读（`ExchangeLaw.Nonanticipating.through_sensitive`），而它所经的每个识，连同所依存的，都不漏掉其敏感者（`ExchangeLaw.Through.registers_of_sensitive`，双重否定）。所以“经识回应”中的识可以取作律的敏感，不必另给：前提只剩律本身。
- **比较由动力学给出。** 回应所及经律的识画出，条件有限时经其敏感；比较在律的两个进程之间、在其中决定（`comparison_of_courses`、`comparison_through_sensitivity`），一个动作与另一个动作所生成的进程之间亦然（`comparison_with_act`）。
- **与标准因果模型接上。** 进程是 P68 中以部分的动作为输入的模型的轨道（`ExchangeLaw.course_trajectory`）；未取的动作是干预，记录不固定其结果，模型固定它（`ExchangeLaw.act_not_taken`）。P53 说动作造成什么只相对于无此动作之历史的模型才可检验；这里那个模型就是律。
- **反事实与 P69 的展开（P80b）。** 形成与条件同类时，进程是 P69 的一个世界，平衡、因而按交换之律而行，恰当可行（`ExchangeLaw.world_balances_iff`、`ExchangeLaw.world_exchange_iff`）。`Run.beyond_shown_iff` 是关于 P69 的 `Shown` 的一条律：确定的律在一个历史所显示者之外添加的，恰是历史未取的动作。所以进程的历史显示其律，一个动作有历史之外的一步恰当历史未取它（`ExchangeLaw.counterfactual_beyond_shown`）。部分的动作在展开之内由律形成时，P69 的 `closedBy` 的运行就是那个动作生成的进程（`ExchangeLaw.closedBy_course`）。
- **见证。** P65 的 `Loop` 中第二个形成的回应是律，`Loop.responds` 由律推出，两个流各由第一个的动作固定（`Loop.responds_by_law`、`Loop.courses_fixed`）。

**读法（AI 的，待 Ren）。**
- 反事实不是实际之外的第二个世界，而是同一规律在部分另作时的进程：可行时存在，由动作固定。与 Ren 在 P69 所说的“there are no two realities”相应（这一对应是 AI 的）。一个会取用多于所立与所给的动作没有进程。
- 对遵从读已立者之律的其余，P65 的前提不是另加的关于形成怎样行为的假设：无论其余遵从哪个这样的律，它都经一个识而读，条件有限时即其交换所敏感者。读作识：形成识其交换所敏感的。敏感越窄，一个动作的差别所能到之处越窄。
- 一个未取的动作是标准因果模型意义上的干预：记录不固定其结果，律固定它。
- 与 P69（Ren 说律与历史是同一展开的两种读法：“there are no two realities”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-no-two-realities.md)；延伸到反事实是 AI 的）：未取之动作的进程与每个展开同形，不是第二种东西；律在它所管的历史之外添加的，恰是历史未取的动作，所以反事实是律在其历史之外的一步，不是旁边的第二段历史。部分的动作在展开之内形成时，进程从起始处固定：另作即部分另是的律，所做的另样即所是的另样。

**作者反审。**
1. **推出的部分近于定义。** `ExchangeLaw.Through.responds` 只是把律的读法转到两个流上；实质的新内容是：反事实由动作固定（对步作归纳，经平衡相消）、生成与可行的等价、敏感是最小的识（逐个条件替换，不判定敏感）、与 P68 模型的实例，以及 `Loop` 由律推出。
2. **前提移到律上。** 推出的不是“形成只经其识回应”，而是：形成遵从一个律时，它经律的敏感而读。哪个律、律是否读已立者，仍是给出的。读已立者排除对未来的读取；对未被识者的回应、噪声、未表示为条件的输入，现在落在律的敏感之内，所以回应所及变宽而不是被排除。
3. **条件有限。** `through_sensitive` 用一个含每个条件的列表与可判定的相等。条件无穷多时，一个律可以对每个单独的条件都不敏感而仍读许多条件（例如只看从某处起是否全为零的读法）；这样的律要构造需要非构造的函数，本模块没有陈述，也没有反例。
4. **依存与观察不对称。** 识得相同只要求依存的条件被同样容许（阈值），被观察的条件水平相同。所以 `registers_of_sensitive` 的结论是敏感者在依存或观察之内，而 `through_of_observed` 要求敏感者被观察：只依存而敏感于其水平的律，不经只含依存的识而读。
5. **可行。** 生成用自然数的截断减法；可行是生成的流平衡的条件（`course_balances_iff`），不是额外的选择。不可行的动作没有进程，本模块不给它另外的读法（例如截断的读法）。
6. **部分的动作。** `counterfactual_fixed` 与 `counterfactual_is_course` 要求部分的动作逐值相同；部分以读水平的策略行动时，用 `ExchangeLaw.course_unique`（把部分的策略并入律）。
7. **见证是最小的。** `Loop` 只有一个回应；它显示 P65 的前提在那里由律推出，不是回路的一般理论。
8. **与 P69 的实例近于定义。** `world_balances_iff` 重述 `course_balances_iff`，`world_exchange_iff` 经 P69 的 `World.balances_iff_exchange` 得出；`Run.beyond_shown_iff` 对任何确定的律成立，不用交换律；`counterfactual_beyond_shown` 所说的“历史之外”是模型的一步，不是完整的另一进程（那是 `counterfactual_is_course`）。`world` 系列只覆盖形成与条件同类的情形，如 P69 的 `World`；两类的律不在这里读作世界。`closedBy_course` 不要求 act 读已立者，只要求部分的动作由 act 在配置上形成；何时一个动作是部分自己的（P69 的开放项）仍不推出。

**检查。**
- 模块在暂存区对 main 的核心（含 P64–P69）编译（`scratch_build.py`，与检查器共用缓存），没有错误或警告；逐条审计全部 130 个常量，公理报告全部为空。没有用 `simp`、`omega`、`Classical` 或 `native_decide`；数的截断减法的引理自证，不用依赖 propext 的 `Nat.sub_add_cancel`；匹配写全，不用通配，以免生成依赖 propext 的辅助常量。
- 合并检查器在落地队列中检查一次，通过：回执 20261013T090346.930838Z。`Becoming.Counterfactual` 的 46 项定理全部空依赖；包共 3348 项定理、4882 项声明审计，核心闭包 67 个模块。外围桥接对这个核心重查，通过：回执 20261013T090430.379669Z。
- 尚无独立审查。

## 101. 列出一次所承诺的（P77）

**P77：列出一次承诺了什么。** 按 Ren 的“move towards 100%”，像 P58 对可判定性那样，找出零前提计划中每个关系项列出一次、家族不重复（`Distinct`）这一承诺是什么。新的核心模块 `Becoming.Listing`（导入 `Decidedness`、`Sampling`、`Resolution`），不用公理，不加前提，不改动已有模块。
- **列出一次就是已定的同一。** 列表恰在其成员之间同一已定时能列出一次（`listsOnce_iff_decided`），构造性地（`listOnce`），而它能列出一次从不能被否证（`not_not_listsOnce`）。列表所含关系项的数目唯一，恰在此时存在（`Numbers.unique`、`numbers_iff_decided`）。
- **否证不需要它，求和与计数只局部地需要它。** 处处列出一次时否证某事的律不加前提地否证它（`not_of_listsOnce`），所以否证之律对任何列出方式的家族成立，耗散使每个可枚举的世界归于静止（`World.Enumerated.rests`）。一步被封闭恰在有一个成员间同一已定的封闭家族时（`Flow.enclosed_iff`）；世界有限恰在可枚举且关系项之间同一已定时（`World.finite_iff`）。重复并非无害：把一个成员列两次的家族上求和之律不成立（`Doubled.needs_once`）。
- **边界。** 一个类型上的每个列表都能列出一次，恰在该类型上同一已定时（`listsOnce_all_iff`）。经关系、在不可分辨之下，每个世界每个列表的关系项数恰在排中律下固定（`World.Indiscernible`、`World.numbers_indiscernible_iff_em`），名字把没有关系能分开的计为二（`World.probe_named_apart`）。
- **按出现。** 按出现读，每个流不需已定的同一就把参与者列出一次，并保持其数量（`Flow.byOccurrence_once`、`Flow.byOccurrence_balances`）；出现不跨步追踪（`Flow.byOccurrence_uncounted`）。

清点：15 个模块中 169 个声明用到 `Distinct`；30 个不需前提（6 个作为推论证明，其余已分类），33 个是求和的局部条件，31 个是计数的局部条件，9 个按出现重新奠基，其余是数、工具或见证。读法是 AI 的，待 Ren。由本会话的一个 Opus 子代理构建，本会话复核（85 项定理，公理报告为空）。尚无独立审查。

**复用、产出与检查。** 复用 [counts-exist-where-decided](../../../../theories/becoming/results/records/counts-exist-where-decided.md)、[laws-at-coarser-steps](../../../../theories/becoming/results/records/laws-at-coarser-steps.md)；本节的确切增量与消费者接口由 [listing-once-is-decided-identity](../../../../theories/becoming/results/records/listing-once-is-decided-identity.md)、[relata-counted-up-to-indiscernibility](../../../../theories/becoming/results/records/relata-counted-up-to-indiscernibility.md) 记录。当前 [Becoming.Listing](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Listing.lean) 的 85 项定理由[合并回执](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) 20261013T090945.451917Z 覆盖；外围回执 20261013T091033.730173Z 通过。以上边界与给定条件保持，整合没有增加独立审查。

## 102. 变化的次序（P78）

**P78：步序号的重新奠基。** 按 Ren 的“move towards 100%”，像 P69 对出发点那样，检查零前提计划中共享的离散步序号这一承诺。新的核心模块 `Becoming.Order`（只导入 `Becoming.Sampling`），不用公理，不加前提，不改动已有模块。它给出与 Sampling 的较粗读法相反的两个动作：插入空步，以及以相反次序取两个交换。
- **停顿。** 经停顿读的世界恰在原世界满足前提时满足它们（`World.stutter_premises_iff`），任何段上的总量就是所读之段的总量（`stutter_total`），生起、止息与变化恰在原来复现时复现（`World.stutter_arisingRecurs_iff`）。改变的是每步所计的：空步出现得任意晚时没有什么无终地更多（`Flow.sample_not_more`），每步读两次时储备须加倍（`Lapse.reserve_step_relative`）。
- **交换次序。** 两侧分开的相继两个交换可以以相反次序取：平衡、耗散与体现恰在原来成立处成立，段上的计数与总量保持（`World.commute_laws`、`World.commute_counts`），在任意次这样的交换下也如此（`Reorders.laws`、`Reorders.totals`），即 Mazurkiewicz 迹等价。
- **次序携带什么。** 次序经依存与共享的关系项被登记：在 `Crossing` 中次序相反时一个关系项在没有支持时活跃，在 `Arising` 中一个关系项在活跃之前给予（`Crossing.order_registers`、`Arising.order_registers`）。

- **次序作为对象（P78b）。**
  - 足迹说出每个交换触及哪些关系项；在包含交换之处，交换之间的相连生成严格偏序（`Footprinted.Precedes`）。
  - 交换不相连的交换在重新编号下保持它（`Footprinted.reorder_precedes`）。
  - 反过来，以构造性的冒泡排序，一段上如此达到的重新编号恰是保持它的那些。以这样的次序有相同交换、足迹与变化、起点相同的世界，每步都与一个重排一致（`Footprinted.sorts_iff`、`Footprinted.converse`）。
- **什么被保持（P78b）。**
  - 沿不相连的交换，每个前提双向保持（`Footprinted.reorder_premises`）。
  - 沿任意重排，生起与止息的计数保持（`Reorders.counts`）。
  - 交换相连的交换破坏活动需要支持与只有活跃者给予（`Crossing.reorders_joined`、`Arising.reorders_joined`）。
- **移除空步（P78b）。** 去掉停顿的空步的世界（`World.withoutIdle`）恰在原世界满足每个前提处满足它，恰在原世界有普查处有普查，任一段上的总量与计数相同（`World.withoutIdle_premises`、`World.withoutIdle_counted`、`World.withoutIdle_totals`）。

读法是 AI 的，待 Ren：
- 对规律、总量与复现，步序号不携带变化次序以外的东西。
- 速率相对于读法的单位。
- 给定足迹，规律所需的次序是相连交换的偏序，不是步的序列。

没有证明：
- 最小足迹；
- Foata 范式；
- 沿重排的普查。

由本会话的 Opus 子代理构建（266 条定理，公理报告为空）。尚无独立审查。

**复用、产出与检查。** 复用 [laws-at-coarser-steps](../../../../theories/becoming/results/records/laws-at-coarser-steps.md)；本节的确切增量与消费者接口由 [only-the-order-of-change-registers](../../../../theories/becoming/results/records/only-the-order-of-change-shows.md)、[exchanges-commute-unless-joined](../../../../theories/becoming/results/records/exchanges-commute-unless-joined.md)、[order-of-exchanges-is-the-invariant](../../../../theories/becoming/results/records/order-of-exchanges-is-the-invariant.md) 记录。当前 [Becoming.Order](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/history/becoming/Becoming/Order.lean) 的 266 项定理由[合并回执](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) 20261013T090945.451917Z 覆盖；外围回执 20261013T091033.730173Z 通过。以上边界与给定条件保持，整合没有增加独立审查。

## 103. 一步与逐步选择家族的全部规律（P79）

**P79：一步的规律就是一步的全部规律。** 按 Ren 的“move towards 100%”，此前只对计数成立的强意义上的完备（`tally_iff_counted`），这里对 Locality 的一步之律证明。新的核心模块 `Becoming.OneStep`（导入 `Counting` 与 `Sampling`），不用公理，不加前提，不改动已有模块。
- **每个条件下精确。** 一个模式（家族成员的通过、取用者之数、是否有交换）恰在服从每步之律时由某个世界显示（`OneStep.every_iff`）；在被平衡、耗减、封闭或两者兼有的家族上，恰在还服从该条件之律时（`OneStep.balance_iff`、`OneStep.runsDown_iff`、`OneStep.closed_iff`、`OneStep.runsDownClosed_iff`）；所以一个性质在每个这样的步成立，恰在它对服从该律的每个模式成立时（`OneStep.laws`）。跨一个家族的运行，唯一多出的律是每步之后所立就是下一步之前所立（`OneStep.Chained`、`OneStep.run_every_iff`）。
- **脊柱此前未陈述的两条律。** 有所取就有取用者（`Flow.sign_uptake_le_takers`）；所取不超过所立加所给（`Flow.BalancesOn.taken_le`）。没有前者，所陈述的律允许没有世界显示的模式（`OneStep.stated_not_realized`）；有了它，对耗减且封闭的家族它们就是全部规律（`OneStep.runsDownClosed_iff_stated`）。

- **给予者、容量与活动（P79b）。**
  - 有所给就有给予者：有所给之处，给予者至少一个，至多为所给之数（`OneStep.Givers`）。
  - 耗减恰再加每个给予者都取（`Flow.DissipatesOn.renewers_le_takers`）。
  - 容量恰添所给不超过容量乘给予者数（`OneStep.every_capacity_iff`）。
  - 该步的活动不添规律（`OneStep.every_active_iff`）。
- **逐步选定的家族（P79b）。**
  - 家族可以每步改变时，无条件、平衡与封闭不把一步连到下一步（`OneStep.step_every_iff`）。
  - 耗减以不计次序的延续把各步相连：在每个正的水平上，一步之后立于那里的与下一步之前一样多（`OneStep.Continues`、`OneStep.step_runsDown_iff`）。
  - 它严格弱于逐位跟随（`OneStep.steps_not_run`、`OneStep.vanishing_steps`）。

读法是 AI 的，待 Ren。

未涵盖：
- 计数活跃者（需要活动可判定）；
- 容量与活动在运行上的形式。

由本会话的 Opus 子代理构建（311 条定理，公理报告为空）。尚无独立审查。

**复用、产出与检查。** 复用 [laws-of-one-step](../../../../theories/becoming/results/records/laws-of-one-step.md)、[whole-law-of-counting](../../../../theories/becoming/results/records/whole-law-of-counting.md)；本节的确切增量与消费者接口由 [laws-of-one-step-complete](../../../../theories/becoming/results/records/laws-of-one-step-complete.md)、[one-step-missing-laws](../../../../theories/becoming/results/records/one-step-missing-laws.md)、[runs-on-families-chosen-step-by-step](../../../../theories/becoming/results/records/runs-on-families-chosen-step-by-step.md) 记录。当前 [Becoming.OneStep](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OneStep.lean) 的 311 项定理由[合并回执](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) 20261013T090945.451917Z 覆盖；外围回执 20261013T091033.730173Z 通过。以上边界与给定条件保持，整合没有增加独立审查。

## 104. 加权历史及其损失（P82）

**P82：加权的历史。** Ren 问：对不确定的规律，能否像费曼图那样对其众多模式与回路积分；能有多准，有什么损失，理论是否可靠。核心的不确定规律陈述何者可能，不陈述多少。P82 陈述步的赋权加上什么，并证明历史之和在哪里精确、在哪里有损失。新的核心模块 `Becoming.Weighted`（L3，为两条算术引理导入 `Becoming.Capture` 与 `Becoming.Resolution`），不用公理；权重连同其规律一起给出（`Weights`），每个定理对它所列的每个赋权与列表成立。
- **精确。** 列出动作与配置之后，n 步每个历程上复合权重之和等于 n 步转移（`Weights.sum_courses`）：指数多的历程，一次一步求和。保持权重规律的读法可以逐历程取，也可以最后取（`Weights.Hom.transfer`）。
- **可能性就是核心的关系。** 可能性权重读出一个过程的步时，n 步之后的转移恰在有一条 n 个动作的迹通向终点读法成立处时成立（`possibility_transfer_iff`）；历程的计数恰在有历程时不为零（`support`、`counting_transfer_iff`）。
- **经描述的积分。** 经描述在任意步数之后所读，恰在一步之后只依赖描述时只依赖描述（`Weights.lumped_iff`），即 `carries_law_iff` 的加权形式；不然，描述不承载加权规律（`Lumping.loses`）。
- **损失，各是一条定理。** 截断恰好漏掉所弃者；备选只相加之处，截断从下方界定整体（`Weights.truncation`、`counting_truncation_le`）。带符号的计数下，可能的历程能相互平衡，截断会误导，任何保持备选之并的、到可能性的读法都看不见这一抵消（`signed`、`Interference.cancels`、`Interference.truncation_misleads`、`Interference.unseen`）。依赖来路的赋权在它所给出的配置上不是步的赋权，在保留所需的配置上是（`Memory.not_of_steps`、`Memory.of_kept`）。两个动作的回路上，历程每步倍增（`Loop.courses_double`）。

读法是 AI 的，待 Ren：把“Fermi's diagrams”读作费曼图；在有限配置、有界视野下，和对任意多历程精确，经更粗的描述恰在可归并处精确；精度的界限就是这四种损失。没有推出：权重从何而来、实际展开有哪个赋权；带相位的振幅（外围）；无穷多配置或无界视野上的和；对一般权重，保留整个历程恢复步的赋权。尚无独立审查。

**复用、产出与检查。** 复用 [projection-carrying-a-law](../../../../theories/becoming/results/records/projection-carrying-a-law.md)；本节的确切增量与消费者接口由 [sum-over-histories-exact](../../../../theories/becoming/results/records/sum-over-histories-exact.md)、[losses-of-the-sum-over-histories](../../../../theories/becoming/results/records/losses-of-the-sum-over-histories.md) 记录。当前 [Becoming.Weighted](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Weighted.lean) 的 35 项定理由[合并回执](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) 20261013T090945.451917Z 覆盖；外围回执 20261013T091033.730173Z 通过。以上边界与给定条件保持，整合没有增加独立审查。

## 105. 传递的精确条件与边界（P84）

**P84：传递，推出或划界。** `Becoming.Evolution` 以传递为前提（`Flow.TransmitsWithin`）：在此前提下，跨一步经世系而来、在第一个立足之步依存 `c` 的关系项，只由在给予之步依存 `c` 的关系项而来，所需至多多 `δ`。P84 问这一前提是否由核心的其余前提推出，把它陈述为一次世系上的规律，并证明什么推出它、哪里没有推出能达到。新的核心模块 `Becoming.Transmission`（L3，导入 `Becoming.Premises`），不用公理。
- **传递是什么。**
  - 在一次世系上，传递是承继加所需之界（`Web.transmits_at_iff`、`Flow.transmitsWithin_iff`）。承继指后代在第一个立足之步的依存由给予者在给予之步持有。
  - 后代立足前不依存之处，承继恰是形成的规律：在开始作为条件而在的关系项处形成的依存，是其给予者持有的（`Web.inheritsAt_iff_forming`）。
  - 一般地，先前的持有可判定之处，形成与持有构成承继；对每次世系都要求这一点，就是排中律（`split_iff_em`）。
- **经世系不形成新依存。** 在平衡与承继之下，参与者都不依存的条件，开始作为条件而在者在该步之后也不依存（`Flow.no_new_dependence`）。
- **演化的规律，前提写在其内。** 演化的界在其所用的那一次世系上成立（`Flow.inherited_supported_at`）。在开始作为条件而在的关系项处，只需某个被支持的给予者（`Flow.fromSome_supported`），这一形式严格较弱（`TwoGivers.twofold`）。
- **在起约束之处独立。**
  - 去掉给予者的一条依存，不改变任何水平、活动、取用、所需与流，保持其余每个前提与有限，而使传递失效（`World.drop_but`）。
  - 所以，去掉依存时保持且推出传递的条件，推出传递不起约束（`World.vacuous_of_drop_invariant`）。
  - 取用的读法就是这样的条件（`World.drawn_not_enough`）。
- **什么推出它。**
  - 加上一条要求依存的规律，即取用 `c` 即依存 `c`，读法给出承继（`Flow.inherits_of_drawn`）。
  - 在满足平衡、耗散、体现与活动需要支持的有限世界中，传递恰是承继（`World.transmitting_iff_inherits`），所以读法加上这条规律给出传递（`World.transmitting_of_drawn`）。
  - 这不是空的（`World.bearingHatch_derived`），二者都需要（`World.drawn_and_link_needed`）。

其余七个前提只限制依存；传递要求给予者的依存，所以任何推出都需要一条要求某个依存存在的规律。

以下读法是 AI 的，待 Ren 定：
- 传递是开始作为条件而在之时依存形成的规律；
- 世系中新形成的依存（幼体依存亲代）不在传递之内，是对应问题；
- 是否采用取用即依存，或另一条形成的规律；
- 是否把 `World.Transmitting` 放宽为 `TransmitsFromSome`。

不含伦理谓词、排序或公理。

**复用、产出与检查。** 复用 [evolution-on-descent](../../../../theories/becoming/results/records/evolution-on-descent.md)、[map-of-premises](../../../../theories/becoming/results/records/map-of-premises.md)；本节的确切增量与消费者接口由 [transmission-is-inheritance-and-need](../../../../theories/becoming/results/records/transmission-is-inheritance-and-need.md)、[transmission-independent-where-it-binds](../../../../theories/becoming/results/records/transmission-independent-where-it-binds.md) 记录。当前 [Becoming.Transmission](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Transmission.lean) 的 64 项定理由[合并回执](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) 20261013T090945.451917Z 覆盖；外围回执 20261013T091033.730173Z 通过。以上边界与给定条件保持，整合没有增加独立审查。

## 106. 没有哪个来源复现的供给（P85）

**P85：不靠哪个特定来源得到供给。** 记录 continuing-self-fed-from-beyond 证明了延续的家族从其外得到供给，且不必有哪个来源条件复现（`Lone.fed_not_recurring`）；`Lone` 中输送的始终是同一个源，该记录留下一个没有哪个来源形成复现的见证。新的核心模块 `Becoming.Succession`（L3，导入 `Becoming.Continuation`），不用公理，不用前提，给出这个见证（`Successive`）。
- **相继的来源。** 每步有它自己的源，只在那一步在场并活跃，燃烧那一步的燃料，向池给予一份；一个吃者每步从池取用一份（`Successive.flow`、`Successive.web`）。
- **每步得到供给，不靠哪个特定来源。** 流平衡、耗散，只有活跃的形成给予；吃者每步从池取用，池每步从其外得到供给；没有哪个来源形成在两步参与，也没有哪个在两步活跃（`Successive.relay`，由 `Successive.takes_part_once` 推出）。

与 `Lone` 合看，特定的来源条件与特定的来源形成都不必复现：延续需要的是得到供给，不是哪一个供给者。每个源在它自己的那一步仍被需要：去掉它，那一步不被供给。可移除的形式，即同一世界去掉一个来源形成后仍得到供给，没有证明；去掉形成会改变水平，所以那是另一个流，以世界为单位的形式是它的位置。也没有证明来源从流中生起（这里每个源在它的步被给定）。读法是 AI 的，待 Ren 定；不含伦理谓词、排序或公理。

**复用、产出与检查。** 复用 [continuing-self-fed-from-beyond](../../../../theories/becoming/results/records/continuing-self-fed-from-beyond.md)、[derived-extent-limits](../../../../theories/becoming/results/records/derived-extent-limits.md)；本节的确切增量与消费者接口由 [continuing-self-fed-from-beyond](../../../../theories/becoming/results/records/continuing-self-fed-from-beyond.md) 记录。当前 [Becoming.Succession](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Succession.lean) 的 6 项定理由[合并回执](../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) 20261013T090945.451917Z 覆盖；外围回执 20261013T091033.730173Z 通过。以上边界与给定条件保持，整合没有增加独立审查。

## 107. 跨步供给、冗余与储备（P86）

**范围与复用。** 按 Ren 的“move towards 100%”，复用 `feeding-closure` 的同一步供给与最小闭包、`consumption-ends-with-feeders` 的局部终结界、`laws-of-one-step` 的局部平衡、`reserve-defers-ending` 的储备界。新增量是在同一展开中把较早给予、条件的持续与较晚所需接起来，并给出需要仍被满足的精确条件；不重新证明已有储备终结界。`Becoming.Feeding` 只导入 `Interdependence`，属于 L4，但新增声明没有伦理谓词或规范前提。

**携带的条件。** `Flow.CarriedTo W c s t` 要求 c 在从 s 到 t 之前的各步平衡，并从 s 之后到 t 始终立于正数；t≤s 时条件空成立。对于 s<t，存在一个跟随给予、不上升且不超过条件所立量的数量，在 t 仍为正，恰当原给予为正且条件在中间各步始终为正（`can_stand_iff`）。因此在正的给予与该段平衡之下，携带恰是这样的跟随仍可能为正（`carriedTo_iff_stands`）。中间耗尽就没有这样的跟随（`spent_keeps_nothing`）；给予大于整段取用是无论取用怎样分配都能携带的充分条件（`carried_of_gift_exceeds`）。数量没有来源标记，所以这里是可能携带的读法，不能声称已确定实际物质的来源。

**跨步供给与闭包。** `FedAcross (f,t) (g,s)` 要求 s≤t、g 在 s 参与并向 f 在 t 所需的条件正给予，且该条件从 s 携带到 t。同一步供给恰是延迟为零的跨步供给（`fedBy_iff_fedAcross`）。`WithinFeedingAcross` 是含形成、对跨步供给封闭的最小区域；它含原供给闭包（`WithinFeeding.across`），而其外的形成不向可携带到成员所需之步的条件给予（`beyond_gives_nothing_across`）。若每次给予之后条件都不立着，两闭包相同（`withinFeedingAcross_iff_of_unheld`）。`Provision.through_store` 给出严格差别：第 0 步给予后结束活动的亲代，通过储存支持第 2 步活跃的后代；亲代在跨步闭包内而在同一步闭包外。闭包仍是形成层面的，各环不构成已经规定好时间顺序的事件路径。

**需要、冗余与扣留。** 在条件 c 上跨一步平衡时，下一步满足 m 恰当 `m + taken ≤ level + given`（`meets_after_iff_at`）；逐步与整段形式分别是 `stays_met_iff_at`、`meets_over_iff_at`。它们刻画所需被满足，不能从支持充分推出活动；`active_covered_at` 只在该步活动需要支持时从实际活动推出覆盖。若给予者被支持，没有被支持者给予时，整段后满足 m 恰当初始存量覆盖整段取用与 m（`unfed_meets_iff_at`）。逐步需要并取用的步数超过初始水平时，构造性地存在某一步的被支持供给者（`fed_beyond_level_at`）。扣留一个在该条件只给不取的部分、其余交换固定时，所需仍满足恰当实际水平覆盖所需与该部分此前的累计给予（`meets_without_iff_at`）。

**见证与界限。** `Redundant.either_suffices` 中两个供给者任留一个都使消费者每步活跃且被支持；都没有时消费者只在第 0 步活跃，已有局部终结界给出界限（`neither_ends`）。`withheld_either` 在同一个实际流中扣留任一个供给者，明确给出仍容许消费者的水平路径；`withheld_both` 表明两者都扣留而坚持其余取用不变时不存在平衡的水平路径，而不是给出了平衡且自然停止的反事实。改变取用而停止的是另一个参照流。储备推迟而不逃脱的既有 `Web.Carries.lasts` 与 `consumption_ends_with_feeders_at` 保持其原范围。

**作者反审。** 这里没有把条件仍为正认作带来源标记的实际给予仍在；只证明某种不增的跟随可能存在。`CarriedTo` 的平衡被公开写入关系，不由闭包定义推出。消费需求被满足不等于行为必然继续，支持充分的方向未假定。未推导：实际跟随是哪一个；无论取用怎样分配都携带的必要且充分条件；中心怎样表示跨步闭包；形成闭包沿时间有序的事件形式。两条既有记录分别延伸，无新增独立成果标签，也不把这些动力学结论当作伦理根据。物理对应与读法为 AI 的，待 Ren。

**检查与接续。** 核心回执 `20261013T091820.375259Z` 覆盖本模块 41 项定理，源声明公理报告为空；外围回执 `20261013T091907.838571Z` 通过。原 Claude 草稿、任务与散存审计资料在 `development/becoming-p86-landing/` 保留原始字节；这些资料本身不替代上述实查。输出是跨步供给关系及需求保持的局部 iff，接入既有供给闭包与终结记录；下一步只沿上述未解项推进。整合文档尚无独立审查。

<a id="108-休眠中的连续与关系所固定的同一--persistence-through-dormancy-and-identity-fixed-by-relations-p87"></a>
## 108. 休眠中的连续与关系所固定的同一

2026-10-13 整合 Claude 于 10-12 留下的模块；依据 Ren 的 [move towards 100%](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md) 与 [接手并合并](../../../../sources/15-codex-theory-conversations/2026-10-13-codex-takeover-and-merge.md)。原任务、原模块与出处在 [P87 落地包](../history/root-foundation/development/becoming-p87-landing/README.md)；该包的保存本身不构成检查证据。

**从同一关系展开开始。** 一个形成暂不活跃，不表示它的依存或储备也消失。先问什么关系仍保持，再问名字是否追随它。`Becoming.Identity` 已区分逐步关系与跨步命名，也已证明活动与任期的双向连续仍容许跨过休眠的接续；此处复用该成果，不再把原来的缺口当作新发现。

```text
Reused: identity-across-steps; census-balance-under-continuation;
        configurations-alike-by-relation; reserve-defers-ending
Delta: 任意保持读法 h 下，跨休眠的命名连续与类别不变；
       保平衡改认的精确守恒条件、同一／生起／止息的固定边界；
       同量、无保持及混合普查的反例
Record: 扩展 identity-across-steps，不新增独立成果
Inputs: Reidentify、KeepsActive、KeepsTenure、ArisesFrom、CeasesFrom、Census；
        Unfolding 的 exchangeFrame、Alike、exchange_alike_iff
Outputs: Web.persisting h 的连续与普查实例；World.Conserves 与固定性等价；
         对原记录 next_delta 中休眠与关系同一两项的有界回答
Evidence: Becoming.Persistence；核心回执 20261013T091820.375259Z；外围回执 20261013T091907.838571Z
```

### 保持跨过休眠

`Web.Holds` 的候选读法是活跃或至少一条依存仍保持；一般定理对任意 `h` 陈述，`Web.persisting h` 仅以 `h` 替换活动。活动包含于 `h` 时，保持读法下生起且随后活跃，恰是活动读法下生起而此前不保持；止息有相应形式（`Web.arises_persisting_iff`、`Web.ceases_persisting_iff`）。此前保持者的醒来不是保持读法下的生起（`Web.waking_not_arising`）。以活动读，若任何先前活跃者都不延续它，醒来仍是生起（`Web.arisesFrom_of_arises`）。因此没有通过换词消去实际差别。

保持的名字跨每一步不变，便在每段保持中固定一个名字（`Web.steady_held`）。活动或依存分别包含于 `h`，这个条件分别给出原有 `KeepsActive` 与 `KeepsTenure`。`Web.renewingIn_held` 与 `Web.consumingIn_held` 的整段类别等价还要求所讨论形成在**每一步**都保持；只保持一段休眠不够。

`Hibernation.readings` 保留更强条件的必要性：冬眠者虽不活跃而仍依存于巢穴，旧有两种双向连续容许其与觅食者在醒来后交换名字，令更新类别变成消耗；保持的连续排除这次交换。`Dormancy.held_both` 保留相反边界：休眠之步什么也不保持时，新条件同样不排除接续。`Seed.held_readings` 又把关系的选择公开：按依存，种子一直保持；按储备，它在第四步耗尽之后不再保持。选择何种 `h` 属于读法，不是定理替 Ren 作出的决定。

### 普查原律的实例与混读边界

`Web.persisting_census` 直接实例化已有普查规律，并不另证另一套计数。它要求保持者的普查及四种可判定性：保持读法下的活动、是否延续某个活跃者（`Continues`）、是否被随后某个活跃者延续（`Continued`）及关系 `R` 本身。没有分裂时，止息复现需要生起复现；没有合并且从某步起普查数有固定上界时，反之。两个方向的条件不可互换。

两端都读 `h`。`Sleeper.held_readings` 中活动的止息复现而保持的生起从不发生，故不能把一端读活动、另一端读保持仍套用原律。混读成立的进一步条件未给出。

### 守恒固定到哪里

`World.reidentify` 在形成与条件两种角色中按同一步的命名重读。`World.Conserves t g f` 写明：步后 `f` 所立之量加上从 `g` 取走的量，等于步前 `g` 所立之量加上给 `g` 的量。`World.balanced_reidentify_iff` 不加额外假设，给出保平衡改认的充要条件：它跨每一步给出的延续都在该守恒关系之内。

给定原世界平衡，`World.conserves_iff` 把它化为步后所立之量相等；`World.balanced_reidentify_iff_alike` 经 P69 的 `exchange_alike_iff` 接到既有相同定义，没有另造相同。保持与断裂由此不变（`World.kept_broken_reidentify`）。这没有把任何现实系统的全部跨时关系归约为量的相等。

在平衡且关系项相等可判定的世界中，`World.fixed_iff` 说每种保平衡命名都把 `c` 接为自身，恰当步后与它同量的关系项只有它；`World.arises_fixed_iff` 与 `World.ceases_fixed_iff` 则把每种命名都成立的生起／止息，刻画为守恒关系下的生起／止息。可判定相等用于构造交换同量关系项的必要性见证。每一步之后所立之量区分**所有关系项**时，保平衡的改认是固定的改名（`World.still_of_apart`），从而类别固定（`World.classes_fixed`）。若只区分步后活跃者或步前活跃者，分别只得到守恒延续无分裂或无合并；并不直接得到所有类别固定。

`Shuttle.named_as_themselves` 给出固定的实例；把移动的一单位读作单一形成则破坏该世界的平衡。`Lineage.world_readings` 与 `Hibernation.world_readings` 是保留边界的实例：在 `World.ofRoles` 读法中形成所立之量为零，不同命名同时保持平衡，却使生起或类别不同。它们保存逐步关系，并不证明任意新增跨步关系也会保存。

### 反审、检查与下一步

1. **没有把表示中的平衡推出为现实必然。** 零额外假设的定理是保平衡改认的等价；后续刻画逐项写明平衡、可判定相等或所立之量分离。
2. **没有以活动冒充保持。** `h` 公开给出；种子与休眠见证说明哪种读法影响终结和类别。
3. **没有把一一对应推广为任意延续。** 一般分裂／合并下的形成类别、任期与侵蚀仍未陈述。
4. **没有把保持与断裂的不变扩成侵蚀的不变。** 侵蚀追随跨步任期；守恒下它在一般情形尚未证明。
5. **没有重复计算成果。** 此段扩展 `identity-across-steps`，保留原证明与反例；普查作为已有规律的实例，不能另计一次独立成果。

合并检查器在当前源字节上检查 `Becoming.Persistence` 的 71 项定理（回执 `20261013T091820.375259Z`，空公理报告），外围回执 `20261013T091907.838571Z` 通过。这里是作者整合反审，尚未经独立科学审查。该条件成果不完成从物质、信息或组织连续推出同一的完整说明，也不完成整个理论的零实质公理目标。

**仍开放。** 采用哪种保持关系、是否把守恒读作所需的延续；同量处进一步的同一根据；守恒延续下的一般侵蚀；分裂／合并下的类与任期；混合活动／保持的普查成立条件；原有整段延续条件、整体依存与侵蚀的问题。

## 109. 交换的次序：正规形、普查与最小足迹（P88）

从同一展开中哪些关系跨一步改变开始：`Becoming.Order`（P78/P78b）用足迹表示交换触及的关系项，相连关系生成次序，不相连的相邻交换可以交换次序。本次复用 `only-the-order-of-change-registers`、`exchanges-commute-unless-joined` 与 `order-of-exchanges-is-the-invariant`；不另造世界、交换或偏序，也不把排列的名字当成独立实体。新增 `Becoming.OrderNormal`，只导入 `Becoming.Order`，保存 Claude 原模块字节。本次只是完成现存草稿的整合，不增加证明。

**确切增量。** P78 的逆定理已把可达的重排刻画为保持相连交换次序的重排。本次补上有限段中按给定名字的字典序正规形、普查沿重排的构造，以及由实际闲置关系读出的最小足迹；逆定理的关系形式 `rearranges_iff` 是复用的连接，不计作另一个独立成果。新记录为 `normal-forms-need-decided-apartness` 与 `least-footprint-where-idleness-decided`，普查推进既有 `exchanges-commute-unless-joined`。

**正规形。** `Reindexes S m π σ` 给出从 S 开始 m 个交换的安排及其逆，名字是这个有限区间的自然数。对称的 `joined` 说明哪些有名交换相连；`Rearranges` 只交换段内相邻而不相连的交换，且每一步都在当时的安排中读相连关系。`rearranges_iff` 不要求可判定性：可达恰在每对相连交换的先后相同时成立。为了选出规范代表，`DecidesApart joined S m apart` 给出段中不同交换不相连的布尔判定。`normalSteps` 依次把当前可移到前面的、名字最小的交换移来。`normalForm_iff` 表明两安排可达恰在它们的正规形在整个段上一致时成立；`normalForm_normal` 给出幂等性，`normalForm_least` 给出在第一个不同位置的字典序最小性。

**判定的边界。** `CompleteInvariant` 特指以自然数值的有限段比较两安排的不变量；并非任意值域中未必可判相等的抽象不变量。对称相连关系下，存在这种完整不变量恰在存在 `DecidesApart` 时成立（`complete_iff`）。逆方向把两个交换放到相邻位置，比较两种先后安排（`pair_rearranges`、`decides_of_complete`）。所判定的是“不相连”，不从中偷渡“相连”可判定；后者只到双重否定。`Triple` 保留反例：三个交换只有首尾相连，倒序的正规形为中、末、首，正序的正规形为首、中、末，不能重排互达。

**回到世界。** 给定包含交换的足迹及段内 `DecidesApart`，`Footprinted.normalize` 用不相连交换的交换把世界取到正规形。`normalize_premises` 双向保持平衡、耗散、只有活跃者给予与取用、活动需要支持、体现及传递；`normalize_precedes` 在重新编号下保持偏序。`reorder_determined` 说明同一安排给出同样的交换与逐关系项的 `SameAt`。`normalize_reorder` 使用原世界的步来给每个交换命名，因此任意独立重排再正规化，都与原世界的正规形在该段上的交换与关系读法相同。没有声称不同名字下得到同一代表。

**普查沿重排。** `listed_splice` 把交换前的普查一侧与交换后的另一侧拼接，给出中间一步的列表。`Web.commute_census` 与 `Web.commute_standingCensus` 不要求两侧分开，也不要求不相连：原来可普查则交换后可普查。返回方向要求两侧分开两步（`commute_census_back`、`commute_standingCensus_back`、`World.commute_counted_iff`）。因此任意 `Reorders`，包括相连交换，只要按其定义每次两侧分开，都双向保持活动与所立者的普查（`Reorders.census`）。任意 `Footprinted.reorder` 只给正向保存；包含足迹下的独立重排给双向保存（`reorder_census`）。这不同于每步的人数相等，也不扩大 P78 `Crossing` 与 `Arising` 所反驳的前提保存。与原有 `World.withoutIdle_counted` 接续，普查在这两种重读下均可传递。

**最小足迹。** `DecidesIdle L W idle` 在每步每个关系项上判定“不参与该交换且跨步不变”；这是全步全关系项的假设，不只是正规形的有限段判定。`Footprinted.least` 触及恰非闲置的关系项（`least_touch_iff`），包含交换且被每个包含足迹包含（`least_contains`、`least_le`）。由此 `Joined`、`Precedes` 都被其他包含足迹的相应关系包含（`least_joined`、`least_precedes`）；其他足迹所保持的重新编号在它之下也保持（`least_keeps`，通过 P78 的 `sorts_iff` 接到可达性）。构造本身不要求关系项相等可判定；逆刻画 `least_exists_iff` 要求 `[DecidableEq X]`。在该条件下，存在最小布尔足迹恰在闲置可判定时；参与是列表成员关系，因而可判定，闲置可判定也恰是对不参与者的跨步不变可判定（`decidesIdle_iff`）。不能把这个逆刻画说成给出了不可判定的具体世界。

**连接、证据与反审。** P78 产出 `Footprinted`、`Contains`、`Joined`、`Precedes`、`Reindexes`、`Reorders` 与排序／前提保存定理；本次以其为输入，产出规范代表、普查构造和最小足迹，不改变上游定义。原任务、模块、历史审计日志与原路径／SHA-256 保存在 `development/becoming-p88-landing/`。历史日志没有合并源码绑定，不能作接受凭证；下述数字只在整合器实际检查通过后填入：Becoming 合并回执 `20261013T091820.375259Z`，`OrderNormal` 共 101 项定理；外围回执 `20261013T091907.838571Z`。对应声明和空公理报告由回执核对。接管方按陈述逐项审读范围，未作独立的全证明审查；不把文档准备当成 Lean 检查。

**剩余边界。** 正规形依赖有限段与交换的名字；没有无名正规形、Foata 同时层正规形或无界运行的正规形。没有无闲置判定的最小足迹构造，也没有不可判定闲置的具体反例世界。`Reorders` 的两侧仍给定。与连续时间的实际对应仍开放。空公理报告不推出这些表示选择，也不推出所有现实过程的完整解释。读法由 AI 提出，待 Ren；没有伦理谓词、排序或公理。

## 110. 熵：生成留下的历史与守住它的代价（R5）

2026-10-11。Ren 在 §59.4 之后说（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-difference-in-becoming.md)）：

>

又确认“the case of 0”指零前提：

本节是那个会话的结果。三个问题，先求不加前提的最强形式：零（无损的交换）是否可能，恰在何时；熵（脊柱的每次交换的最小损失，`Flow.DissipatesOn`）能否推出而不作前提；第二定律的形式，即一个永不减少的量，与计数的规律、量的规律怎样相关。§59.4 转来的候选陈述（历史的计数、离散的复现、合并的过去）在此陈述并证明。

```text
Result(s): 新增 entropy-history-and-record
Delta: 新模块 Becoming.Entropy（导入 Becoming.Resolution 与 Becoming.Recurrence）。
       第一律与逆转：Flow.GainlessOn、LosslessOn、Gainless、Lossless、Reverses、exchanges；
       DissipatesOn.gainlessOn、Dissipative.gainless、LosslessOn.gainlessOn、Lossless.gainless、DissipatesOn.idle_of_lossless、
       Reverses.mem、mem_back、take_total、give_total、taken、given、closedAt、gainlessOn_iff、idle_of_dissipates、exchanges_eq；
       Balances.reverse_restores、Dissipative.irreversible、Balances.exchanges_of_change、Balances.restores_levels_not_history。
       记录：Flow.withRecord、Web.withRecord、recorded、unitRecord、RecordsOn、residue；balances_withRecord、balancesOn_withRecord（每步、每个家族；Locality 落地后加入）、closedAt_withRecord、
       gainlessOn_withRecord_iff、losslessOn_withRecord_iff、dissipatesOn_iff_unitRecord、dissipatesOn_iff_recorded、
       dissipatesOn_iff_conserved、Dissipative.of_recorded、dissipative_iff_unitRecord、GainlessOn.conserves_residue、
       GainlessOn.residues_lost、Balances.lowered_by、nonrising、falls_by_record、RecordsOn.exchanges_le。
       耗散的量：Flow.lost、dissipated；dissipated_succ、dissipated_mono、DissipatesOn.dissipated_rises、
       Balances.stock_lost、stock_dissipated、dissipated_le、dissipated_zero、history_within、loss_ceases；
       replenishment_lost_of_le、DissipatesBy.uptake_le_lost、uptake_within_dissipated。
       复返与构型的计数：Web.config、Changes、Revisits；configurations、configurationsWithin、configurations_exact、
       configurations_examples；Web.changes_within、rests_of_never_revisits；Flow.Balances.never_revisits、changes_within、
       changes_within_lossless、rests_of_never_revisits、unending_change_revisits。
       箭头：Web.Arrow、Web.never_revisits_of_arrow、Flow.Balances.rests_of_arrow、Flow.Balances.no_arrow、World.no_arrow。
       合并：Web.Determined、Web.Merges、Web.merges_of_settles、Web.changes_persist、Flow.Balances.revisits_of_apart、
       merges_of_never_revisits、merges_of_arrow、merges_of_dissipates。
       守住历史：Flow.history、history_mono、CarriesHistory、CarriesHistory.changes、Balances.arrow_of_carries、
       never_revisits_of_carries、exchanges_within_of_carries、exchange_stops_of_carries；World.rests_of_never_revisits、
       arising_revisits、never_revisits、forgets。
       见证：Passing（passes、history_grows、no_arrow、history_without_arrow、record_needs_both）、
       Settling（settles、merges）、Gathering（gathers）。
       R6 落地后的实例（复用 recurrence-without-premise）：Web.Revisits.recurs、Web.Arrow.marks、Web.Merges.law、
       Web.Determined.orbit；Flow.Balances.held、orbit_held、recurs、arrow_stops、returns_of_lossless、present_forgets、
       not_lossless_of_arrow、not_lossless_of_dissipates。Entropy 改为导入 Resolution 与 Recurrence。
Supplied premises / correspondence: history_mono 本身不用平衡；由水平变化推出交换、逆转恢复水平等结论使用平衡；第一律（Gainless）、无损（Lossless）、确定的变化（Web.Determined）
       是定理的假设，不是公理；把记录算作一个条件是读法（AI，按 Ren 的“entropy”）；与热力学的对应是读法，不是物理推导
Evidence: 合并检查器回执 20261013T093441.881086Z（4513 项定理、6364 项声明审计，全部源声明公理报告为空；Entropy 185 项定理、
          233 项声明审计），外围回执 20261013T093542.175797Z；新声明先在暂存树中从前导编译，逐条 #print axioms 全部为空
Boundary: 离散步，固定单位的自然数量；确定的变化是对世界加的假设；“熵”指哪一个量由 Ren 决定；物理的对应是读法；尚无独立审查
Integration: 记录 entropy-history-and-record；计划 §10 R5；章节第一部分与 §9 的脊柱表；模块说明、根模块与检查器的范围
```

**零是可能的，恰在无损之处。** 在平衡的流中，一个成员的水平每次变化都是与家族的一次交换（`Flow.Balances.exchanges_of_change`）。第一律在固定单位下是“无中不生有”：每个不重复的封闭家族得回的至多是从它取走的（`Flow.Gainless`）；无损是恰好得回（`Flow.Lossless`）；耗散是第一律加上最小损失（`Flow.Dissipative.gainless`）。逆转一次交换（`Flow.Reverses`：同样的形成参与，各取其所给、给其所取），在第一律之下恰当原交换无损时逆转仍在规律之内（`Flow.Reverses.gainlessOn_iff`）；耗散之下没有交换被逆转（`Flow.Dissipative.irreversible`）。`Passing` 中一个载体把一个单位在两边之间来回传递：世界有限、平衡、无损、每步被围住，每次交换在下一步被逆转，生起与止息都复现（`Passing.passes`）。所以零是可能的。

**不加前提的是历史。** 家族自 T 起交换的历史（`Flow.history`）从不缩减（`Flow.history_mono`），有所交换的每一步都增长。交换连同其逆转恢复每个水平，历史却记下两次（`Flow.Balances.restores_levels_not_history`）。这是 Ren 的第二条消息的形式：“its reverse transformation will take another change”。`Passing` 中历史每步增长一，永不停止（`Passing.history_grows`），构型每两步回来。这一部分与 `endpoint-loss-and-return`（沿实际历史，返回恰当保留全部端点可能）及 `ReturnConditions.lean` 中加入的计数器（计数使原有的返回不再是返回，投影后的返回不变）相关，是脊柱上的同一区分：水平恢复而历史不恢复。

**最小损失是放在守恒量之中的记录。** 把交换的记录算作又一个条件：每个参与的形成给它，没有形成从它取（`Flow.withRecord`、`Web.withRecord`），流在原处平衡恰当算入记录后平衡（`Flow.balances_withRecord`）。于是一个流在一步上耗散于一个家族，恰当有某个记录使每次交换精确守恒家族连同其记录，并给记录至少一个单位（`Flow.dissipatesOn_iff_conserved`）；也恰当每次交换以一个单位记录时，家族连同记录不得增益（`Flow.dissipatesOn_iff_unitRecord`、`Flow.dissipatesOn_iff_recorded`）。两部分都需要（`Passing.record_needs_both`）。第一律之下，记录收到的恰是耗散的（`Flow.GainlessOn.residues_lost`）。这正是 Ren 的类比的形状：每次交换精确守恒，记录仍增加。但这是分解，不是推出：给定第一律，“每次交换在守恒量之内留下至少一个单位的记录”恰是耗散的严格部分。

**耗散的量与第二定律的形式。** 家族每步失去的（`Flow.lost`）自 T 起之和（`Flow.dissipated`）从不减少（`Flow.dissipated_mono`）；第一律之下它连同存量守恒（`Flow.Balances.stock_dissipated`），所以不多于 T 时的存量；被耗散时每步至少增加取用者的个数，历史在它之内（`Flow.Balances.history_within`）；无损时为零（`Flow.dissipated_zero`）；第一律之下损失不复现（`Flow.Balances.loss_ceases`）。按比例 q 耗散时（R1 至 R3 的 `Flow.DissipatesBy`），被取走的至多是失去的 q+1 倍（`Flow.DissipatesBy.uptake_le_lost`），所以任一段上被取走的总量至多是耗散的量的 q+1 倍（`Flow.uptake_within_dissipated`），与量的规律 `Flow.uptake_bound` 相合：后者以存量为界，这里以耗散的量为界。

**构型的计数与复返。** 第一律之下家族的构型（`Web.config`，每个成员的水平）总在其 T 时存量之内的构型中（`configurationsWithin`），无损时在恰为该存量的构型中；`configurations n K` 恰好一次列出 K 个单位落入 n 个成员的每种方式（`configurations_exact`；`configurations_examples`：3 个单位落入 2 个成员有 4 种，2 个落入 3 个有 6 种）。从不复返的家族，变化的步数不多于这些构型（`Flow.Balances.changes_within`、`changes_within_lossless`），因此归于静止（`Flow.Balances.rests_of_never_revisits`）。所以第一律之下，不止的变化复返（`Flow.Balances.unending_change_revisits`）；有限世界中不息的生起从每一步起都复返（`World.arising_revisits`）。耗散之下家族从不复返（`Flow.Balances.never_revisits`）。`Settling` 中一个单位只传递一次，无损，然后静止：从不复返带来静止，不需要最小损失（`Settling.settles`）。

**水平没有箭头。** 构型的一个量若从不下降、每次变化都上升（`Web.Arrow`），家族就不能复返（`Web.never_revisits_of_arrow`）。所以第一律之下，箭头带来静止（`Flow.Balances.rests_of_arrow`）；变化继续时，构型的任何量都不是箭头（`Flow.Balances.no_arrow`、`World.no_arrow`）。`Passing` 中没有（`Passing.no_arrow`），而历史在增长。不加前提而增加的是历史，不是有限围住之内水平的任何量。

**合并。** 变化是构型的函数时（`Web.Determined`），变化之后静止就把两个取过的不同构型送到同一个（`Web.merges_of_settles`、`Web.Merges`），不用流的任何规律。不合并任何构型时，变化一旦开始就不停止（`Web.changes_persist`），所以第一律之下家族复返（`Flow.Balances.revisits_of_apart`）；从不复返时，无论因为箭头还是耗散，变化都合并构型（`Flow.Balances.merges_of_never_revisits`、`merges_of_arrow`、`merges_of_dissipates`；这三条是双重否定：不是不合并）。`Passing` 中两边互换，不合并任何构型（`Passing.history_without_arrow`）；`Settling` 中静止合并了构型，接受单位一边的水平是箭头，只上升一次（`Settling.merges`）。这就是 §59.4 所转的“合并的过去”：在有限的围住之内，或者不合并，变化复返而没有箭头；或者合并，某个区分失去。

**守住历史。** 构型承载历史时（`Flow.CarriesHistory`：构型的某种读数给出历史），这一读数是箭头（`Flow.Balances.arrow_of_carries`），所以家族从不复返（`Flow.Balances.never_revisits_of_carries`）；第一律之下与它的交换在其构型的个数之内停止（`Flow.Balances.exchanges_within_of_carries`、`exchange_stops_of_carries`）。有限世界在第一律之下不停交换，就会遗忘：从没有一步起其构型承载其历史（`World.forgets`）。

**六律的实例（R6）。** R6（`Becoming.Recurrence`，记录 recurrence-without-premise）不加前提地陈述每个序列与每个确定的规律保留、失去与回返的。家族自 T 起的构型是这样一个序列，变化是构型的函数时 `next` 是这样一个规律，所以上面的陈述读作它们的实例（按与 R6 所有者的约定，后落地者写实例）：变化之后的复返是复返（`Web.Revisits.recurs`；本模块的复返更强，中间有一次变化），箭头标记每次变化（`Web.Arrow.marks`），沿家族的合并是规律的合并（`Web.Merges.law`），确定的变化沿规律的轨道（`Web.Determined.orbit`）。第一律把构型限于其 T 时存量之内的构型（`Flow.Balances.held`、`orbit_held`）；这一界限是这里的前提 Z。于是从每步起构型构造性地两次取同一值，不用判定（`Flow.Balances.recurs`，R6 的 `revisits_from`；本模块原来的 `unending_change_revisits` 只给出双重否定的、变化之后的复返），箭头使变化停止（`Flow.Balances.arrow_stops`，R6 的 `Marks.change_stops`），在这一界限之内不合并的规律带回起点（`Flow.Balances.returns_of_lossless`）。起作用的是界限而不是不合并：`Law.succ_open` 不合并且永不回返（审查提醒，来自 R6 的所有者）。当下遗忘所保留的历史（`Flow.Balances.present_forgets`，R6 的 `Law.present_forgets`），箭头或耗散排除不合并的规律（`Flow.Balances.not_lossless_of_arrow`、`not_lossless_of_dissipates`：R6 的 `Law.rise_not_lossless` 要求一个列出全部构型的列表，这里不需要，因为第一律的界限与确定的变化已经足够）。

**从外部汲取的箭头。** `Gathering` 中一个记录每步从一个新的关系项取一个单位：每次交换精确守恒，每步被围住，交换复现，记录的水平是一个永不停止的箭头；记录从其外得到增益，世界不有限（`Gathering.gathers`）。所以“家族不得增益”与“世界有限”这两个前提都起作用：精确守恒之下永不停止的箭头要从所持之外汲取，与 continued-change-needs-openness 相合。

**回答。**

1. *零是否可能。* 可能，恰在无损之处：第一律之下一次交换的逆转在规律之内，恰当这次交换无损；`Passing` 是有限、平衡、无损、被围住而不息的世界。Ren 的业力读法在此是：逆转之后水平没有差异，历史有差异。
2. *熵能否推出。* 不加前提地增加的是历史（`Flow.history_mono`、`Flow.Balances.restores_levels_not_history`、`Passing.history_grows`）。在有限的围住之内，水平的任何量都不能在变化继续时一直上升（`Flow.Balances.no_arrow`，见证 `Passing`）；变化是构型的函数时，任何箭头或静止都合并构型（`Web.merges_of_settles`、`Flow.Balances.merges_of_arrow`）；在构型中守住历史使交换在构型的个数之内停止（`World.forgets`）。每次交换的最小损失不由更少的推出：它恰是第一律加上放在守恒量之中的一个单位的记录（`Flow.dissipatesOn_iff_conserved`），是重新的读法，不是推导。
3. *第二定律的形式。* 历史与耗散的量都从不减少；耗散的量连同存量守恒；按比例耗散时被取走的至多是耗散的量的 q+1 倍。

**与热力学的对应（读法，AI，不是物理推导）。**

- *Clausius*：孤立系统的熵不减。这里不减的是历史（无前提）与耗散的量（第一律之下）。
- *Boltzmann*：S = k ln W。`configurations n K` 是 K 个量子落入 n 个振子的方式，即 Einstein 固体的多重度 C(n+K−1, K)；第一律之下从不复返的变化步数以它为界。粗粒化的熵从有序的开端上升需要关于开端的前提（过去假设），这里没有陈述。
- *Zermelo、Poincaré*：有限的守恒动力学复返（`Flow.Balances.unending_change_revisits`）。*Loschmidt*：可逆的规律之下没有水平的箭头（`Flow.Balances.no_arrow`、`Passing.no_arrow`）。
- *Landauer*：静止或箭头合并构型（`Web.merges_of_settles`、`Flow.Balances.merges_of_arrow`），合并就是擦除。*Bennett*：可逆计算保留历史，代价是保存它的空间；有限世界中守住历史使交换停止（`World.forgets`）。
- *Gouy–Stodola*：能量守恒而可用功下降。这里，算入记录时每次交换精确守恒，家族的存量下降，下降的恰是记录收到的（`Flow.dissipatesOn_iff_conserved`、`Flow.GainlessOn.residues_lost`）；脊柱的水平读作仍可用的差异，与 §59.4 的读法一致。
- *开放系统*：永不停止的箭头需要从外部汲取（`Gathering.gathers`），与“生起不息需要开放”同形。

**作者反审。**

*反驳 1：把历史叫作熵，是否只是换名？* 历史是交换的计数，不是物理的熵；本节不说它是。它是 Ren 所问的“在精确守恒之下仍增加的量”在此表示中不加耗散前提就已说明的一个量；这里未证明它是唯一的。哪个量叫“熵”由 Ren 决定：历史（零前提）、放在守恒量之中的记录（即最小损失），或一个粗粒化的计数（需要开端的前提）。

*反驳 2：`Flow.dissipatesOn_iff_conserved` 是否推出了耗散？* 没有。它说耗散恰是“守恒连同记录”加上“记录每次至少一个单位”；后者恰是严格部分。它的内容在于把 Ren 的类比（每次交换守恒，熵仍增加）变为脊柱上的一个等价，而不是把前提消去。

*反驳 3：合并的定理要求变化是构型的函数，这是否是新前提？* 是，对那些定理是假设。脊柱的流以步为索引，不要求下一步由当前的构型决定；所以合并的结论只对确定的变化成立，在别处只有复返与箭头的结论（它们不需要这个假设）。`Web.merges_of_settles` 本身不用流的任何规律。

*反驳 4：`no_arrow` 是否只是复返定理换了说法？* 大体是：箭头排除复返，复返定理给出矛盾。增加的是陈述的方向：Ren 问的是“什么在增加”，答案是在有限的围住之内，变化继续时水平中没有，所以要么在历史中，要么在围住之外（`Gathering`），要么以合并为代价（`Settling`）。

*反驳 5：`Gathering` 的世界无限，是否与现实无关？* 它只表明定理的两个前提起作用：家族不得增益与世界有限。物理上对应开放系统或膨胀的空间；这里不作此推断。

*反驳 6：第一律（Gainless）本身是否是前提？* 是。它是定理的假设；零的可能性（`Passing`）表明它与无损相容，`Gathering` 表明在其中家族得益时箭头可以不停。Ren 的原话以能量守恒为物理的前提；本节不推出第一律。

**读法（AI，待 Ren）。** 交换历史的计数只增不减；平衡之下每次水平变化都是一次交换，逆转也是一次交换。此处不由这些结论推出平衡本身。需要代价的是守住它：在有限的围住之内，守住历史的构型会耗尽构型，守住一个不断上升的量要合并区分，把记录放在守恒量之中就是每次交换的最小损失。所以 Ren 所说的熵可以有两种读法：作为历史，它不需要前提；作为守恒量中的记录，它就是脊柱的耗散。两者之间是精确的：耗散恰是第一律加上守恒量中的记录。

**边界。** 离散步，固定单位的自然数量；确定的变化（`Web.Determined`）是合并定理的假设；`Merges` 的结论是双重否定；只陈述了合并与否的二分；可达构型逐步收缩由 R6 给出（`Law.Reachable.earlier`、`Law.lost_stays`，任何确定的规律，不加前提），其在第一律的列表之内的计数没有陈述；粗粒化的熵与有序的开端没有陈述；记录作为普查中的关系项、使算入记录的流本身是一个世界，仍开放；与热力学的对应是读法；尚无独立审查。

**2026-10-13 整合说明。** 从 R5 分支 `52ff83a4` 保留已完成的陈述与证明，不新增定理。四个通用列表辅助名称与后落地模块冲突，现只将其限定到 `EntropyLists` 命名空间；原始源码另按原字节保存。将暂定节号、回执和总数按当前落地更新；补全 Resolution 与 Recurrence 的导入说明；区分历史计数的单调性与使用平衡的变化／逆转结论，并去掉未证明的“唯一”读法。原文与历史验证保留在该分支的 Git 历史中。

## 111. 静止一族按强度命名（P58c）

2026-10-13 落地；2026-10-12，Ren 对 AI 的分析答：“agree with you”（[原话](../../../../sources/15-codex-theory-conversations/2026-10-12-rest-family-strengths.md)）。AI 的建议（Ren 所同意的）：在 Lean 中查哪些静止定理在“停止不能被否证”的形式下成立，成立处如此陈述，名带 unrefuted；只有不复现成立处改名为 …_not_recurring；“在某步停止”“从某步起静止”只留给说出那一步的陈述（需要可判定）。中文术语（归于静止或停）与“静止定理”这一标题仍由 Ren 定；在此之前保留，各 Lean 名称说其确切强度。

“它停止”有三种强度，每种强于下一种：(a) 从某步起不再发生（`World.RestsFrom` 是世界的这一形式）；(b) 这一点不能被否证（`¬¬∃N, RestsFrom N`）；(c) 不复现（并非在任意晚的步发生）。对有限的、满足前提的世界，(a) 蕴含有限全知原则（`World.lpo_of_finite_ends`），所以核心证 (b) 与 (c)。

```text
Result(s): 改名与加强，不是新结果；space-and-its-parts（RestsFrom、rests_unrefuted_iff、not_recurring_of_rests_unrefuted）、
           laws-of-one-step（ceasing_steps_unrefuted、Covers.ceasing_stops_unrefuted）、rest-with-refinement-counted
           （restsFrom_of_after）加入新声明；19 项当前记录改用新名
Delta: 54 个名称；15 个陈述由 (c) 加强为 (b)，名带 unrefuted；其余陈述不变，名带 not_recurring。双重否定移不过
       全称量词，所以止息一半在双重否定之内作有限鸽巢（Covers.ceasing_stops_unrefuted，由 ceasing_steps_unrefuted）；生起与止息两
       半在共同的一步合起（World.rests_unrefuted_iff）
Supplied premises / correspondence: 无新前提；各定理的前提不变
Evidence: 合并检查器回执 20261013T094743.528770Z（4518 项定理、6370 项声明审计，全部源声明公理报告为空；核心闭包 77 个模块，包 75 个），外围回执 20261013T095049.338744Z
Boundary: (a) 需要全知原则，不证；交换一族（经 exchange_recurs_iff）、分辨率的量子路线、Recurrence、Reserve、Dissipation、Renewal、
          Change 仍为 (c)，其 (b) 形式尚未证，是后续；见证 rests_needs、rest_needs_census、rest_needs_standing、rest_needs_quantum 的
          名称不变，复现驳倒每一种强度；继承模块（RelationalRenewal 的 unrenewed_drawdown_finite）保留其范围；尚无独立审查
Integration: 核心 Space、Locality、Openness、Resolution、Premises、Sampling、Counting、Decidedness 的陈述与名称，Change、Dissipation、
             Flow、Generation、Interdependence、Recurrence、Renewal、Reserve、Roles、Units 的名称与文档字符串；章节术语表、§9 计数与
             后落地模块的调用保持原有陈述：Listing 经 not_recurring_of_rests_unrefuted 取较弱结论，Entropy 的调用只改名；
             总数；Lean README；零前提计划；统一计划；阅读条目；19 项当前记录；工作板 P58c
```

**加强为不能被否证（名带 unrefuted）。**

| 原名 | 现名 |
|---|---|
| `Flow.stills` | `Flow.change_stops_unrefuted_around` |
| `World.arising_stops` | `World.arising_stops_unrefuted` |
| `World.comes_to_rest_from` | `World.comes_to_rest_unrefuted_from` |
| `World.comes_to_rest` | `World.comes_to_rest_unrefuted` |
| `World.Finite.comes_to_rest` | `World.Finite.comes_to_rest_unrefuted` |
| `World.rests_around` | `World.rests_unrefuted_around` |
| `World.rests_enclosed` | `World.rests_unrefuted_enclosed` |
| `World.hatch_rests` | `World.hatch_rests_unrefuted` |
| `World.premised_rests` | `World.premised_rests_unrefuted` |
| `World.rests_of_after` | `World.rests_unrefuted_of_after` |
| `World.rests_unrefined` | `World.rests_unrefuted_without_refinement` |
| `World.rests_refinement_counted` | `World.rests_unrefuted_refinement_counted` |
| `World.sample_rests` | `World.sample_rests_unrefuted` |
| `World.rests_covering` | `World.rests_unrefuted_covering` |
| `World.rests` | `World.rests_unrefuted` |

**只证不复现（名带 not_recurring）。**

| 原名 | 现名 |
|---|---|
| `falls_finitely_from_floor` | `falls_not_recurring_from_floor` |
| `Flow.taking_ceases_from` | `Flow.taking_not_recurring_from` |
| `Flow.Balances.taking_ceases` | `Flow.Balances.taking_not_recurring` |
| `Flow.taking_ceases_within` | `Flow.taking_not_recurring_within` |
| `Flow.Dissipative.finite_ceases` | `Flow.Dissipative.finite_taking_not_recurring` |
| `Flow.rising_ceases_from` | `Flow.rising_not_recurring_from` |
| `Flow.standing_ceases_from` | `Flow.standing_not_recurring_from` |
| `Flow.rising_ceases_on` | `Flow.rising_not_recurring_on` |
| `Flow.standing_ceases_on` | `Flow.standing_not_recurring_on` |
| `Flow.rising_ceases` | `Flow.rising_not_recurring` |
| `Flow.standing_ceases` | `Flow.standing_not_recurring` |
| `Flow.Dissipative.one_ceases` | `Flow.Dissipative.one_taking_not_recurring` |
| `Web.depletes_finitely` | `Web.depletion_not_recurring` |
| `Web.dissipation_ceases` | `Web.dissipation_generation_not_recurring` |
| `Flow.Balances.unfed_consumption_stops` | `Flow.Balances.unfed_consumption_not_continuing` |
| `Flow.stills_from` | `Flow.change_not_recurring_from` |
| `Flow.exchanges_finitely_from` | `Flow.exchange_not_recurring_from` |
| `Flow.exchanges_finitely` | `Flow.exchange_not_recurring_around` |
| `World.arising_stops_from` | `World.arising_not_recurring_from` |
| `Few.quiet` | `Few.coming_not_recurring` |
| `World.exchange_stops` | `World.exchange_not_recurring` |
| `Marks.change_stops` | `Marks.change_not_recurring` |
| `Run.change_stops` | `Run.change_not_recurring` |
| `falls_finitely` | `falls_not_recurring` |
| `Conditions.drawdown_finite` | `Conditions.drawdown_not_recurring` |
| `Web.active_finitely_from` | `Web.active_not_recurring_from` |
| `Web.Carries.active_finitely` | `Web.Carries.active_not_recurring` |
| `Web.arising_finitely_from` | `Web.arising_not_recurring_from` |
| `Web.Carries.arising_finitely` | `Web.Carries.arising_not_recurring` |
| `Flow.taking_stops` | `Flow.taking_not_recurring` |
| `World.rests_at_resolution` | `World.not_recurring_at_resolution` |
| `Trickle.exchange_stops` | `Trickle.exchange_not_recurring` |
| `Web.generation_ceases_from` | `Web.generation_not_recurring_from` |
| `Web.generation_ceases_on` | `Web.generation_not_recurring_on` |
| `Web.generation_ceases` | `Web.generation_not_recurring` |
| `World.Enumerated.rests` | `World.Enumerated.not_recurring` |
| `Flow.taking_stops_listing` | `Flow.taking_not_recurring_listing` |
| `Web.generation_ceases_listing` | `Web.generation_not_recurring_listing` |
| `Flow.Dissipative.finite_ceases_listing` | `Flow.Dissipative.finite_taking_not_recurring_listing` |

**P77 的当前更正。** 原 §101 及当时的落地包保留旧名称与文字，历史上的“每个可枚举世界归于静止”不能读成给出停止之步。
在平衡、耗散且生起体现的条件下，可枚举世界的生起与止息都不复现（`World.Enumerated.not_recurring`，原 `World.Enumerated.rests`）；
陈述仍是两项不复现的合取，不加强为从某步起停止。另三项现名为 `Flow.Dissipative.finite_taking_not_recurring_listing`、
`Web.generation_not_recurring_listing`、`Flow.taking_not_recurring_listing`，保留原有前提与陈述，分别否定取用、体现的生起及固定单位下
封闭家族取用的复现。最新完整改名表含 54 项：15 项陈述加强，39 项仅改为所证的不复现名称；初始包的 35 项仅改名是历史计数。

**证明。** 生起一半用 P58b 的 `Flow.change_stops_unrefuted`（不上升的量的下降从某步起停止不能被否证）。止息一半：在覆盖列表之下，止息若在此后每一步之后都不能被否证，则在双重否定之内可以造出任意长的、不重复的止息之步列表（`ceasing_steps_unrefuted`，递归），每个止息之前须有生起，鸽巢使生起在任意晚处不能被否证，与生起一半矛盾（`Covers.ceasing_stops_unrefuted`）。目标是 False，所以在双重否定之内构造是可行的；双重否定移位（DNS）不可用，这一步不能省。两半各给一个起点，取二者之和即共同的一步（`World.rests_unrefuted_iff`）。

**作者反审。**
1. **陈述是否只加强，从不减弱？** 是：每个改了陈述的定理，旧陈述是新陈述的推论（`World.not_recurring_of_rests_unrefuted`），原来用旧陈述的地方都经它改写，检查器通过。
2. **(b) 是否真比 (c) 强？** 在构造逻辑中，(b) 推出 (c)；反过来需要双重否定移位，不可用。
3. **为什么不陈述 (a)？** 对每个有限的满足前提的世界陈述 (a) 就蕴含 LPO（`World.lpo_of_finite_ends`）。
4. **“归于静止”仍在章节文字中。** 术语由 Ren 定；术语表说明本章说一个定理归于静止时指它所证的强度。“只有有限次”“停止”说不复现的定理处已改为“不在任意晚的步”“不复现”。
5. **名称冲突。** `Flow.exchanges_finitely` 改名为 `Flow.exchange_not_recurring_around`，因为 Resolution 已有 `Flow.exchange_not_recurring`（取用至少 1/p 单位）。

**边界。** 历史文字（此前各节、工作板、冻结的落地包、来源、审查、记录的历史及旧回执的验证范围）保留当时的名称；随当前回执推进的验证范围使用现名。OPENING 的脚注引 `World.rests_enclosed`，只与 Ren 一起改，留给 Ren。尚无独立审查。

**接手后的学习桥接重查（2026-10-13）。** 最终依赖上实际重查 `LearningCorrespondence`：回执 `20261013T095759.980593Z`，15 项定理／19 项声明审计通过，桥接源码、声明与公理范围不变（取得一侧空依赖，网络一侧保留原标准依赖）。检查器逐项核对当前导入闭包的源哈希。P73/P74 的原始回执及前文历史验证保留；本次是依赖更新后的重查，不是新结果或独立科学审查。

## 112. 一般规律与改名：存量、接触与严格损失匹配（2026-10-14）

2026-10-14 落地。Ren 要求每项结果都有一般规律，并改掉不好的名称（[计划](../history/root-foundation/development/becoming-general-laws-plan/PLAN.md)，原话与审计在那里）。审计发现，P93 的 `Revising`、P99 的 `ReferencePlan`、P103 的 `ContinuingRevision` 与 P100 的 `RepairComparison` 的正面论点只由构造的例子支撑。本节落地这四项的一般规律，把原例子改作实例或对照，并按计划 §2 改名（A1–A11、B1–B5、N）。

```text
Result(s): 不新增独立结果；selection-under-registration-revision、consequence-revised-reference-plan、recurring-reference-revision、
           finite-aggregation-within-restorable-basic-losses 改为先陈述一般规律、原例子作实例；改名所及的记录在其历史中注明
Delta: 新核心模块 Becoming.Stock（40 项定理）、Becoming.Contacts（24）、Becoming.LossMatching（34）；实例定理：Revision +6、
       ReferencePlan +15、ContinuingRevision +23（燃料与产出成为参数）、RepairComparison +19；改名只改名，陈述、证明与
       各模块的定理数不变（对照表见统一计划 §10）
Supplied premises / correspondence: 无新增；每条规律所用的局部条件写在规律之中（只从已持者汲取、地址可判定相等、损失各列一次、
       内容按类读）；FR 的充分性承诺仍是显式假设
Evidence: 合并检查器回执 20261013T204910.042715Z（4861 项定理、6856 项声明审计，全部源声明公理报告为空；核心闭包 86 个模块，
          包 85 个，从内置前导编译），FallibleInquiry 回执 20261013T205526.452771Z（31 项定理，数目不变），CorrectionInquiry
          回执 20261013T205618.164536Z（7 项定理，公理报告为空）
Boundary: learned-procedure-transmission 与 joint-difference-making 的一般规律、非类内容的 Hall 型刻画、只在一个构造族内成立的
          记录的提升、10-12 之前记录的审计留给后续；Provision.gift 不在本批；尚无独立审查
Integration: 主章 §9 的模块表与总数；统一计划 §10 的对照表；交叉主张论证 §11；Lean README；受影响的记录
```

**一般规律。**

- **存量（`Becoming.Stock`）**，对每个过程、轨迹与运行：
  - 每步平衡恰是沿每个历程平衡（`balanced_iff`）；
  - 每步只从已持者汲取时，历程可执行恰当每步的汲取在当时的存量之内（`feasible_iff_covered`、`covered_iff_prefix`）；与登记过程联合运行时，恰当登记容许且存量覆盖（`product_feasible_iff`）；
  - 无尽重复需要回补覆盖汲取（`cycles_need`）；对存量过程，恰当首轮被覆盖且回补覆盖汲取（`repeat_covered_iff`、`product_repeat_iff`）；
  - 沿每个平衡运行，任意晚的汲取需要任意晚的补充（`Run.replenishes_of_draws`），存量有界时两者一同复现（`Run.draws_iff_replenishes`）；
  - 沿运行的存量是平衡的流（`Run.stockFlow_balances_iff`），所以 Flow 的规律适用于它，不另建模型。
- **接触（`Becoming.Contacts`）**，只设地址可判定相等：
  - 换计划保留每个旧选择，恰当保留每个旧接触（`keeps_iff_retains`）；
  - 修订规则登记每次失败，恰当下一计划含失败的地址（`answers_iff`）；不读失败的规则在地址无界时每个计划都漏掉某次失败（`blind_misses`），地址有限时反之不然（`finite_blind_answers`）；
  - 两个参考回应驱动二值通道到两个目标，恰当它们不同（`References.drives_iff`）；已安装的编码在通道改变后仍对，恰当新通道在编码处与旧的一致（`References.stays_iff`）。
- **严格损失匹配（`Becoming.LossMatching`）**，对每个框架：
  - 生成扩展经恒等就是严格匹配，所以使严格匹配足以给出严格优先的承诺包含 C（`strictLossMatch_of_extension`、`SufficientMatching.comparison`），反之不然；
  - 损失无穷多时配置可严格匹配自身（`EndlessLosses`），所以需要有限；损失各列一次时严格匹配是严格序（`StrictLossMatch.length_lt`）；
  - 计数律：以类读内容时，严格匹配存在恰当较好的配置每类失去的不多于较差者、总数更少（`strictLossMatch_iff_counts`）；
  - 失去共同支持的配置经严格匹配不优于任何配置（`not_strictLossMatch_of_base_lost`）；按 `ReadsAt` 的定义，主张在其时刻被读恰当其实现自那时起已定，恢复支持不再实现错过的主张（`readsAt_iff_settled`、`ReadsAt.loss_retained`）；主张错过而后又实现时，没有任何支持使框架在较早时刻读它（`not_readsAt_of_recovery`）。实际框架是否在片段时刻读，是前提。

**原例子成为实例。**

- `Revising` 是与其存量联合运行的登记过程（`Revising.step_iff`）；区分、支持与执行彼此不同（`covered_not_enacted`、`linked_not_enacted`）。
- ReferencePlan 的燃料守恒且只从已持者汲取（`balanced`、`draws_held`、`trace_conserves_of_law`）；冻结的方法是不读失败的规则（`frozen_blind`、`frozen_misses`），翻转的参考是 `pick`（`flip_is_pick`），漂移的通道失败（`drift_fails`）。
- ContinuingRevision 中，没有回补时任何控制器都没有无尽运行（`no_run_without_return`），比原来的 `cut_stops_next` 强；更新与成功沿每个运行复现（`renew_recurs`、`success_recurs`）。燃料与产出成为参数后，存在起点使任意多轮循环都可行，恰当产出不少于每轮的汲取 9（`repeats_iff`）；产出 9 的原定理是其实例，陈述不变，无限的 `continuing` 保留。
- RepairComparison 的严格匹配由计数律给出（`matches_iff`，四条路线的损失为 3/4/3/2）；原来的匹配与脆弱对照由一般规律重得（`a_matches_b1_by_count`、`b3_matches_a_by_count`、`fragile_b3_better_than_none`）。

**改名。** 标准与 P36 相同：名称说所述的动力学；不用社会、金融或心理的词；不把 Ren 的原话直接用作形式名。例如，`MakesSense` 改为 `IdentifiesAlike`，因为定义就是 `π s = π s' ↔ Alike F F s s'`，“有意义的切分”仍是散文读法；`Person` 改为 `Life`；`knowing` 改为 `withBound`；`Denial` 改为 `Negation`；ReferencePlan 的 `cost`、`receipt` 改为 `use`、`mismatch`，不再与检查器的回执相混。改名的模块重新检查后，定理数与上一回执逐一相同。记录标题随之改：target-capture 说“perturbing”；identification-where-bounded 说“给定界的”；finite-aggregation 的标题去掉“FR 候选”；recurring-reference-revision 的中英文一致；seeking-boundary 以结构开头，无明作别名。

**作者反审。** 一般规律不使原例子多出内容：每条规律的条件就是例子原来满足的局部条件，例子只是在这些条件下成立的一个情形。存量的规律不说哪个可观察量表示实际条件；接触的规律不说哪个地址值得接触；计数律只在内容按类读、损失各列一次时成立，非类内容只证了必要方向。改名不改任何陈述；历史条目、旧回执与审查文件保留旧名，按对照表读。

## 113. 旧记录的一般律：确保、分组、读出与门控改变

2026-10-14。Ren 批准（经整合会话转达）：“all needs to have general law proved”，并选择同时审计与推广 10-12 以前未改动的记录。首轮审计（只读陈述）把 80 项记录分为 G 14、G+W 22、W 2、W-neg 5、F 28、N/A 9，九行标 `?`。本节复核这九行，抽查五行，并给出四条新律与它们的实例；逐行表见[旧记录审计表](../history/root-foundation/development/becoming-general-laws-plan/general-law-audit/older-records.md)。目标形式与 10-12 以后记录的审计相同：每条律对其种类的每个世界或过程陈述为“Y 当且仅当 Z”，Z 是局部条件；等价不成立处给出最强的单向律与逆命题的反例；旧例成为实例或对照。

```text
Result(s): 改写 assured-route-criterion、formed-goal-revision-continuation、material-preparation-output、
           transition-grouping-word-partition、acquired-binding-compositional-use、enacted-scene-binding、
           encounter-selection-and-revision、retrospective-source-binding、control-coherence-loss、
           joint-correlation-reduced-dynamics、organizational-rule-inheritance、joint-practice-forms-continuation；
           不新增记录，状态不变
Delta: 核心新模块 Becoming.Assurance（20 项定理／25 项声明）、Becoming.Segmentation（17／32）、
       Becoming.Readout（7／10）、Becoming.Gated（4／5）；桥接 Becoming.Instances（22／25）；
       外围 MachineInstances（44／49）及其检查器 check_machine_instances.py
Supplied premises / correspondence: 无新前提；各实例保留原模块的前提与对应
Evidence: scratch_build 实编：核心与桥接每条声明公理报告为空，外围只用标准公理（45 项声明，其中 6 项含 Classical.choice）；
          不是回执，落地运行先跑核心检查器，再跑 check_machine_instances.py
Boundary: 大的单机器组（复制机、市场、设备／队列协议）与 market-protected-continuation 留给后续，见下文；
          historical-source-binding 只给出律的提议；relational-renewal-classification 归 L2 的族提升
Integration: §9 模块表；Becoming.lean 与 check_becoming.py 的模块列表；十二项记录；旧记录审计表
```

**九个 `?` 行的终审。** acquired-binding-compositional-use 与 retrospective-source-binding 为 F-inst（标题各是一段历史，覆盖之下唯一绑定正确本已一般，后者的覆盖律只在 SourceReliance 模型上一般）；alignment-direction-g0-j 为 N/A（论证记录，其 Lean 支持是算例加一条一般的重述引理）；fallible-witness-diagnosability 为 G+W（完全可诊断恰当交叉分离，对每个名册与故障包络成立）；formed-goal-revision-continuation 为 W（所绑定的标题是对 `harmful` 的封闭判定）；growth-constrained-fragmentation 与 relational-generative-comparison 为 W-neg（标题是反例或不可能性，一般的机制在模块中另有）；material-preparation-output 为 G+W（`route_sound` 与 `route_complete` 合为对每个配方、池与支持量的等价）；relational-renewal-classification 为 F-fam（混合，标题动力学在支持门控的 `Law` 族上）。抽查 trace-law-equivalence、endpoint-loss-and-return、branching-tests-bisimulation、finite-continuation-plans、draws-on-a-shared-stock，原分类成立。

**确保（Becoming.Assurance）。** `InquirySufficiency.Completes P safe goal s plan` 要求计划的每一步从此前步骤可达的每个构型都可行且安全，每个终点满足目标。对每个过程，完成的计划可运行、每次运行安全、每个终点满足目标（`runs_of_completes`）。对每个确定的过程（`Becoming.Determined`）反之亦然：

```lean
theorem completes_iff_of_determined (determined : Determined P) :
    Completes P safe goal s plan ↔
      (∃ t, Trace P s plan t) ∧ ∀ t, Trace P s plan t → SafeTrace P safe s plan t ∧ goal t
```

无安全条件时（`free`）即“运行且每个终点满足目标”（`completes_iff_runs`）。逆命题对非确定过程不成立：`Branch` 中从 0 出发，`[(), ()]` 的两步都能运行且每个终点为 3，但第一步可达 2，从那里第二步不可行，所以计划不完成（`Branch.runs_not_completes`，`Branch.not_determined`）。变化之律 `f : S → A → S` 读作过程 `ofMap f` 是确定的，计划完成恰当目标在 `plan.foldl f s` 成立（`completes_ofMap_iff`），单步恰当目标在 `f s a` 成立（`completes_ofMap_single`）；部分律 `ofPartial f` 的轨迹恰是 `runPartial f` 完成的运行（`trace_ofPartial_iff`）。原提议“一步函数式的过程中单步计划确保目标当且仅当目标在后继成立”是 `completes_ofMap_single` 的特例；脊柱此前没有这条律（`Completes` 在 InquirySufficiency，`Determined` 在 Joint，二者未连）。实例：`ContextualWisdom.Assured` 即 `Completes P free`（`Instances.assured_iff_completes`）；三路线过程是 `ofMap advance`（`routes_eq`，定义相等），故 `Assured routes [a] Reached (m, false) ↔ a ≠ m`（`routes_assured_iff`）；调节律同理（`regulation_assured_iff`）。

**分组（Becoming.Segmentation）。** 对每个字母表与相邻关系 `r`，由右向左读，元素在 `r` 把它连到其后一组的首元素时并入该组，否则另起一组（`chunks`）。分组返回一个划分恰当各组非空、内部相连且对下一组开启（`chunks_eq_iff : chunks r (join L) = L ↔ Grouped r L`），该划分唯一（`chunks_unique`），分组不改变序列（`join_chunks`）。对非空词的词汇（`Spelled word first rest`），

```lean
theorem encode_iff (spelled : Spelled word first rest) :
    (∀ ws, chunks r (encode word ws) = ws.map word) ↔
      (∀ w, LinkedFrom r (first w) (rest w)) ∧ ∀ w v, r (lastOf (first w) (rest w)) (first v) = false
```

两项都是相邻对的局部条件。以观察转移的严格多数学得的关系（`bond log x y := decide (departures log x < 2 * transitions log x y)`）使每个元素至多连到一个后继（`bond_unique`），所以两个词若在内部以不同元素接续同一元素，任何记录都不能把两者都分对（`no_record_groups`）：这是逆向的界，不是缺陷。读出：分组恢复词处，逐词读出每个编码序列给出词义的组合，恰当每个词读作其义（`reads_every_iff`）。首轮审计提议的“日志呈严格多数模式则 `bond log = idealBond`”不是精确的律：恢复只需六个局部键条件，不需要与 `idealBond` 处处相等。实例：`AcquiredSegmentation.chunks` 即核心的 `chunks`（`Instances.chunks_eq`），二词编码即核心的 `encode`（`encode_eq`），对每个关系，恢复每个二词序列恰当 a→b、c→d 相连而 b→a、b→c、d→a、d→c 不相连（`two_word_iff`）；外围 `bond` 即核心的多数键（`MachineInstances.bond_eq`）。取得词库的解释律（外围，因为 `resolve` 与 `bond` 的定义依赖标准公理）：

```lean
theorem interprets_every_iff (s : Lexicon) (groups : Groups s.percept.log) :
    (∀ ws, interpret s (encode ws) = assembleMessage (ws.map Expr.atom)) ↔
      ∀ b, resolve s (word b) = some (Expr.atom b)
```

`learned 32`、`coordinated 37`、`acquired 51` 与 `retrospective 36` 的绑定视图是实例（`*_interprets_every`，记录条件由判定给出，解析事实用既有定理或判定），`experienced 28` 的固定解码器亦然（`experienced_parses_every`）。五项 `decide` 恒等式由此成为一条律的五个实例。

**读出（Becoming.Readout）。** 对每个约化 `π : S → K` 与观测 `f`：`f` 经 `π` 读出的关系是单值恰当 `f` 在 `π` 合并处相同（`reading_single_iff`，即 `Learning.Lumped`）；在 `π` 合并的两个构型上，在两处都对的解码器存在恰当 `f` 在那里一致（`decoder_pair_iff`），所以没有映射能恢复 `π` 合并的两个不同构型（`no_restore`）；有截面时解码器存在恰当集总（`decodes_iff_of_section`）。律：约化值上有一条确定的律承载变化之律的每一步，恰当 `π` 合并的构型被每个动作带到 `π` 合并的构型（`law_through_iff`，即核心的 `carries_law_iff` 读在 `ofMap` 上，这一半是已有的律的重读，不计为新律）；与每个动作交换的约化律与每段动作序列交换（`foldl_semiconj`）。首轮提议“f 经约化 r 分解当且仅当被丢弃部分对 f 不可见”即 `reading_single_iff` 与 `decodes_iff_of_section`。实例：对角线合并加号响应不同的相干与退化矩阵（`Instances.diagonal_no_decoder`），退相干合并制备与相干矩阵（`dephase_no_restore`），局部密度对合并同一受控 X 分开的两个状态，所以不承载规律（`local_pair_carries_no_law`）；四整数摘要承载规律（`MachineInstances.summary_carries_law`），对每段动作序列精确（`summary_every_word`，由 `summary_update_exact`；外围，因为整数引理依赖 `propext`）。

**门控改变（Becoming.Gated）。** 对每个过程、动作上的门 `gate : A → Bool` 与构型的量 `q`：`KeptBy P gate q` 说每个非门控步保持 `q`。

```lean
theorem kept_along_iff :
    (∀ s plan t, Trace P s plan t → (∀ a, a ∈ plan → gate a = false) → q t = q s) ↔ KeptBy P gate q
```

改变 `q` 的进程经过门（`change_passes_gate`）；值的相等可判定时，进程在一个本身改变 `q` 的门控步处分开（`change_located`）。门不说门控步改变什么，只定位改变从哪里进入。实例：组织程序是一条部分律（`Instances.process_eq`、`trace_iff_run`），只有采纳改变规则（`rule_kept`），所以每段不采纳的历史继承规则（`rule_inherited`，即既有 `nonadopting_history_inherits` 对每段历史成立），每次规则改变都在一次采纳处（`rule_change_located`）。实践机器亦然：轨迹恰是运行（`MachineInstances.practice_trace_iff_run`），只有修订改变做法（`methods_kept`），只有组织采纳改变规则（`practice_rule_kept`），完整历史是一条轨迹（`complete_history_instance`）。

**形成目的的修订（外围）。** 标题需要的律对构造的每个条件、账户与操作次数成立：一种实践从 ⟨w,q,z⟩ 运行 n 个周期，恰当 n = 0 或 2 ≤ w 且 2·(n − 受支持周期) ≤ w，受支持周期在选择器反馈该实践时为 q/2，否则为 0（`cycles_iff`）；学习目的的每次操作保持目的与选择器、加上转变损失（若有）并追加一条记录（`operateMany_learning`）；修订恰在访问有损而转变维护保留时完成（`completed_isSome_iff`，对八个条件穷举）；对每个这样的条件，修订与改革之后 n 次操作运行恰当 n ≤ 5，不改革选择器时恰当 n ≤ 2，先前一次损失保留（`revision_continues`）。`harmful` 的标题（`harmful_instance`）与两条界（`harmful_bounds`）是实例。它不在脊柱上：GoalFormationRevision 的定义与已证事实依赖标准公理，纯核心与桥接不能导入；律的内容是该构造的账户算术，脊柱没有对应的概念。

**物料准备。** 不改 Lean：`route_sound` 与 `route_complete` 合为“对每个配方、池与支持量，以空剩余池完成恰当池是配方的排列且配方不长于支持量”，记录按此改写，八槽配方为实例。

**作者反审。**
1. **这些律是否只是重述？** `law_through_iff` 是 `carries_law_iff` 的重读，`assured_iff_completes` 是定义展开，按此计；`completes_iff_of_determined`、`encode_iff`、`chunks_eq_iff`、`bond_unique`、`reads_every_iff`、`decoder_pair_iff`、`kept_along_iff`、`change_located` 与外围的 `cycles_iff`、`revision_continues` 是新的。`kept_along_iff` 的证明是一步归纳，内容在于把“只有门控步改变”化为每步的局部条件并定位改变。
2. **`Groups` 是否把结论放进了前提？** 不是：`Groups` 是记录的六个键值，`interprets_every_iff` 的另一侧是解析事实；两者独立，`two_word_iff` 说明这六个键值恰是恢复所需。
3. **穷举是否算一般？** `completed_isSome_iff` 与 `revised_class` 对 `Conditions` 的全部八个值判定，这是对有限类型的穷举，覆盖每个条件；账户数值（⟨5,8,5⟩、⟨3,8,7⟩）是该构造的，律的一般部分是 `cycles_iff` 与 `operateMany_learning`。
4. **外围声明为什么带公理？** 外围机器的 `resolve`、`bond`、`cycle` 等定义经库实例依赖 `propext` 与 `Quot.sound`，`cycles_iff` 的算术用 `omega`；这些实例因此在外围陈述，核心与桥接仍为空公理。
5. **范围。** 只证明所陈述的律；机器与实际学习者、量子系统、人或组织的对应不由此检查。

**留给后续（提议）。**
- **复制机**（formed-copying-correction、formed-copying-registration、inherited-structural-copying、recurrent-chain-assembly）：对每个可判定相等的字母表与每个路径模板，精确复制当且仅当预算覆盖每个记号的连接与释放代价，忠实扫描不增加对参照的缺陷数，检查与参照相符当且仅当缺陷为零，轮次按 k·2ⁿ 增长；核心新模块陈述于 `List Σ` 上，Bool 链为外围实例。
- **市场**（market-finite-support-obstruction、market-partial-correction-boundary、market-supported-finite-transition）：抽象为增长映射加带下限的支持递推；若正区域上增长比有下界且每步减量与规模成比例，每个有限储备都在可计算的步数内耗尽；5/12 边界是不动点处的余量条件（落地当且仅当余量非负）。有理数不在纯核心中，所以律陈述于有序结构之上，市场为外围实例。
- **纠正与停机协议**（versioned-request-completion、acquired-revision-of-pending-task、pending-task-context-applicability、recoverable-mediated-change、mediated-evidence-transport、reserved-shutdown-during-recovery）：对每个带受保护头部、守卫的原子步与守恒支持账的协议，不变量在每一步与每次中断后保持（`Frame.Invariant` 与 `Gated`），支持覆盖代价的后缀完成（`Assurance.completes_ofPartial_iff` 加计数）；核心陈述，协议为外围实例。
- **market-protected-continuation**：带扰动的守卫动力学中，从起点出发每段历史都不违反守卫，当且仅当存在含起点、在守卫之内、对每个容许扰动封闭的证书（最大者为可存活核）；这是 `Frame.Invariant` 在以扰动为动作的过程上的形式，核心陈述，市场为外围实例。
- **historical-source-binding**：把 Route 与 Faults 抽象为任意路径族与故障包络；与全部记录相容的路径总含实际路径，在某一日期所有候选一致恰当记录决定该日期（与 `Learning` 的拟合律同形）。

**边界。** 落地运行须：在 `check_becoming.py` 中编译与审计四个核心模块与桥接（环境审计、对照与只用前导的编译只在检查器中运行），然后运行 `check_machine_instances.py`（它要求闭包中每个其他模块都有已通过的回执）；把十二项记录的新证明引用绑定到新回执。各外围模块的字节未改。

**落地（2026-10-14）。** 第二批落地：核心检查器回执 20261013T221720.428753Z 通过（核心公理报告为空），MachineInstances 回执 20261013T222154.117109Z 通过（只用标准公理）；记录的新证明引用已绑定到这两个回执。

## 114. 旧记录的一般律：生存核、计数与预留出口、持续与永不到达

2026-10-14。接续 §113 留给后续的三组：market-protected-continuation、纠正与停机协议、市场。目标形式同 §113：每条律对其种类的每个过程或变化之律陈述为“Y 当且仅当 Z”，Z 是局部条件；等价不成立处给出最强的单向律与逆命题的反例；旧例成为实例。逐行分类见[旧记录审计表](../history/root-foundation/development/becoming-general-laws-plan/general-law-audit/older-records.md)。

```text
Result(s): 改写 market-protected-continuation、versioned-request-completion、acquired-revision-of-pending-task、
           pending-task-context-applicability、recoverable-mediated-change、mediated-evidence-transport、
           reserved-shutdown-during-recovery、market-finite-support-obstruction、
           market-partial-correction-boundary、market-supported-finite-transition；不新增记录，状态不变
Delta: 核心新模块 Becoming.Viability（25 项定理／33 项声明）、Becoming.Countdown（20／27）、
       Becoming.Lasting（36／43）；外围 MarketInstances（29／34）、ProtocolInstances（19／31）、
       VersionedTaskInstances（11／17，Lean 4.30.0-rc2 与 Mathlib）及其检查器
       check_market_instances.py、check_protocol_instances.py、check_versioned_task_instances.py
Supplied premises / correspondence: 无新前提；各实例保留原模块的前提与对应
Evidence: scratch_build 实编：三个核心模块每条声明公理报告为空，外围只用标准公理；不是回执
Boundary: 着陆一侧的增益估计与形成目的修订的根据条件仍是各自构造的事实，见作者反审
Integration: §9 模块表；Becoming.lean 与 check_becoming.py 的模块列表；十项记录；旧记录审计表
```

**生存核（Becoming.Viability）。** 守卫 `guard : S → Prop` 标出活动能继续的构型。`Kernel P guard s` 说从 `s` 出发的每段进程都留在守卫之内；证书是守卫之内、每一步都保持的集合（`Certificate`：`within` 与 Frame 的 `Invariant`）。

```lean
theorem kernel_iff_certificate :
    Kernel P guard s ↔ ∃ K : S → Prop, K s ∧ Certificate P guard K
```

核本身是证书并含每个证书，所以是最大的（`kernel_largest`）；一步：构型在核中恰当它在守卫之内且每个后继在核中（`kernel_step_iff`）。守卫本身未必是证书（`Leaves.within_not_kernel`）。由可容许扰动驱动的变化之律 `f : S → A → S` 读作过程 `disturbed f adm`；给定一个可容许扰动，

```lean
theorem never_leaves_iff_certificate (h₀ : adm a₀) :
    (∀ d : Nat → A, (∀ n, adm (d n)) → ∀ n, guard (history f s d n)) ↔
      ∃ K : S → Prop, K s ∧ (∀ x, K x → guard x) ∧ ∀ x a, adm a → K x → K (f x a)
```

没有可容许扰动时历史条件空真而律不成立（`needs_admissible`）。守卫律在首个起止于守卫之外的步停止；守卫历史在每个时刻与历史相同，恰当历史留在守卫之内（`guarded_iff`），所以证书律对守卫历史同样成立（`guarded_never_fails_iff`）。实例：市场的运行映射是由扰动驱动的变化之律（`MarketInstances.history_eq`），守卫市场即以必要底线为守卫的核心守卫律（`guardedHistory_eq`），每个界都容许其最坏扰动（`worst_admissible`）。所以对每组参数、界与起点，没有可容许历史违反必要底线，恰当某个含起点、在底线之内、对每个可容许扰动封闭的状态集存在（`never_fails_iff`）。`Certificate p b` 之下安全矩形是这样的集（`safe_closed`），`safe_history_never_fails` 是实例（`safe_never_fails`），每个安全状态都在核中（`safe_within_kernel`）。

**计数、被允许的进程与预留出口（Becoming.Countdown）。** 携带待完成工作穿过中断的协议共有三种局部结构。
- **被允许的进程保持性质。** 性质沿每段进程从它成立的每个起点保持，恰当每一步保持它（`invariant_iff_reach`）。读在部分律 `f : S → A → Option S` 被允许的步上（`admitted`），中断与普通动作同为步，所以协议的历史保持其不变量恰当每类步保持它（`admitted_invariant_iff`）。
- **计数的工作（`Counts`）。** 部分律 `tick` 在任务待完成（`busy`）时以一单位燃料做一单位剩余工作，无剩余工作且有燃料时完成，无燃料时停住。从每个待完成的构型：

```lean
theorem completes_iff (counts : Counts tick busy done work fuel) (pending : busy s) :
    (∃ t, ticks tick (work s + 1) s = some t ∧ done t) ↔ work s + 1 ≤ fuel s
```

  更短的运行都使任务仍待完成，工作减去所走的步数（`pending_before`、`ticks_busy`）；待完成与完成互斥时，更短的运行都不完成（`not_done_before`）；燃料少于工作时每段运行都停住（`stalls_beyond`）；读作部分律的计划，即 Assurance 意义的完成（`completes_plan_iff`）。不计燃料、每步推进一单位的任务恰在 `work + 1` 步完成（`Advances.completes`）。
- **预留出口（`Reserved`）。** 从有效构型，每个被允许的动作都继续、保持有效，且要么走出口、要么使余量减一；出口被每个动作保持。从有效构型每段被允许的进程都运行且保持有效（`runs_valid`），每段长于余量的进程终于出口（`exits`）。此界可达：与余量等长的进程可以错过出口（`Slow.misses`）。

实例（外围 ProtocolInstances，标准公理）：中介与可恢复协议的 `History` 恰是其律在源律容许处所走的步的可达性（`mediated_history_iff`、`recoverable_history_iff`）。所以覆盖沿合法读取与已提交程序的每段历史保持，安全沿每段被中断的历史保持，恰因每个被允许的步保持它们（`coverage_along`、`safety_along`）；原历史定理是实例（`mediated_history_instance`、`interrupted_history_instance`）。待完成的恢复是计数的工作（`counts`）：n 次剩余写入与发布在 n + 1 次恢复步中完成，恰当储备够 n + 1 单位且期限够 n + 1 步（`publishes_iff`），更短的恢复不发布（`pending_until_published`）；`funded_suffix_publishes` 是充分的一半，耗尽情形是必要一半的实例。关停监督是预留出口（`reserved`）：每个可容许的日程都运行且保持有效（`schedule_valid`），长于三单位预留之上余量的日程都停止（`schedule_stops`）；`every_supported_schedule_finishes` 是实例（`supported_schedule_instance`）。

实例（外围 VersionedTaskInstances，Lean 4.30.0-rc2 与 Mathlib）：版本化队首待完成时每次走一跳，无剩余时交付请求并留下队列其余部分（`head_advances`，`Countdown.Advances` 的实例），所以在剩余长度加一次中完成（`head_completes`），`valid_head_completes` 是实例（`valid_head_instance`），更短的运行使队首仍待完成、未交付（`head_pending_before`）。改写队首保持其路线、进度与队列其余部分（`retarget_pending`），`revised_head_completes` 是实例（`revised_head_instance`）。审查取一单位工作、行动取两单位，进程 `[1, 2]` 恰从三单位起被覆盖（`review_course_covered_iff`，`Stock.Covered`）；端点完成审查与行动，恰当报告排除相关风险且工作覆盖该进程（`review_completes_iff`）。

**持续、耗竭与永不到达（Becoming.Lasting）。** `Lasts f adm guard n s`：`s` 在守卫之内，且此后 `n` 步每个可容许扰动带到的构型都在守卫之内。梯级族是守卫之内的层，每个可容许步从第 k + 1 级落到第 k 级（`Ladder`）；必要族是守卫给出第 0 级、而守卫之内且每个可容许后继都在第 k 级的构型在第 k + 1 级（`Necessary`）。

```lean
theorem lasts_iff_ladder :
    Lasts f adm guard n s ↔ ∃ C : Nat → S → Prop, C n s ∧ Ladder f adm guard C
theorem lasts_iff_necessary :
    Lasts f adm guard n s ↔ ∀ L : Nat → S → Prop, Necessary f adm guard L → L n s
```

`Lasts` 是最大的梯级族，也是最小的必要族；兼为二者的族恰是 `Lasts`（`lasts_iff_of_exact`）。给定一个可容许扰动，持续 n 步即每段可容许历史的前 n 步留在守卫之内（`lasts_iff_histories`）；不加前提，生存核恰是持续每个步数者（`kernel_iff_lasts`）。起点在守卫之内时，守卫历史在 n 处与历史相同恰当历史到 n 都在守卫之内（`guarded_upto_iff`），在 n 前停止恰当不然（`guarded_none_iff`）。

耗竭：在被耗竭的层族中（`Drains`：守卫给出第 0 级，守卫之内的构型经一个可容许步到第 k 级，则原在第 k + 1 级），沿前 n 步留在守卫之内的每段可容许历史，起点都在第 n 级（`Drains.along`）；所以低于第 n 级的起点在每段可容许历史上 n 步内离开守卫（`Drains.leaves`）。逆命题不成立：处于第 n 级不足以持续（`Collapse.level_not_lasting`）。增长受单调映射 g 约束的序列停在 g 的轨道之下（`below_orbit`），轨道是最坏的增长（`stays_below_iff`）。设一个量的增长在一个被保持的区域内受单调映射约束，且在量的轨道不超过阈值时每步付出一级；则轨道在 n 步处不超过阈值、且不在第 n 级的起点，在每段可容许历史上 n 步内离开守卫（`exhausts`）。

永不到达：确定的律的轨道永不到达目标，恰当某个含起点、避开目标、对律封闭的集合存在（`avoids_iff_closed`），这即目标补集的生存核（`avoids_iff_kernel`）。某种子永不到达恰当这样的集合含种子（`some_avoids_iff`）；没有种子避开目标恰当没有这样的集合含种子（`none_avoid_iff`；以排中律读，左边即每个种子到达，核心不用排中律）。目标之外的不动构型自身就是这样的集合（`fixed_avoids`）。

实例（外围 MarketInstances，标准公理）：
- **有限支持阻碍。** 以每步选定的纠正强度，市场是一条变化之律（`scheduled`；`run_eq`、`guarded_eq`）。物理的 (x, q) 上份额每步至多乘 3/2，其轨道是份额乘 (3/2)ⁿ（`orbit_growth`）；轨道不超过 1/6 时，非负冲击的一步使存量在底线 5 之上少一单位。所以份额乘 (3/2)^N 不超过 1/6、存量低于 5 + N 的物理起点，在每段这样的历史上 N 步内停止：`finite_support_forces_failure` 是 `exhausts` 的实例（`forces_failure_instance`）。
- **支持下的有限转变。** 覆盖递推 K₀ = 5、Kₙ₊₁ = (10/9)(Kₙ + 1 + κ) 对每个纠正日程与每个冲击不超过 κ 的扰动是梯级族（`cover_ladder`），所以存量覆盖 N 步的物理起点在前 N 步留在必要底线之内，对每个纠正强度成立（`supported_prefix_instance`）；`supported_finite_transition` 与 `supported_partial_transition` 的前缀是其情形（`pulse_prefix_instance`、`partial_prefix_instance`）。在最坏份额（份额为 0，不更新）下覆盖恰好：存量单独在 5 之上持续 n 步，恰当它至少为 Kₙ（`cover_exact`，覆盖族兼为梯级族与必要族）。
- **部分纠正边界。** 强度 b 的状态律是确定的律（`path_eq`）。某个正种子永不着陆，恰当某个对律封闭、避开着陆的集合含正种子（`never_lands_iff`）。0 ≤ b ≤ 3/4 时，每个正种子着陆恰当固定质量 3/8、最坏影响 1 处的质量余量 margin(1/4, b, 1, 3/8) = 5/32 − 3b/8 非负，即 b ≤ 5/12（`lands_iff_margin`），也恰当没有这样的集合含正种子（`lands_iff_no_closed`）；边界之上不动构型 `middle b` 自身就是这样的集合（`fixed_point_instance`，`fixed_avoids` 的实例）。

**作者反审。**
1. **哪些是重述？** `never_leaves_iff_certificate` 是 `kernel_iff_certificate` 读在扰动过程上；`kernel_iff_lasts` 与 `avoids_iff_kernel` 把新概念连回生存核。`lasts_iff_ladder` 与 `lasts_iff_necessary` 的证明各取 `Lasts` 为见证，内容在于把“持续 n 步”从两侧化为局部一步条件，并给出精确族的判据（`cover_exact` 用到它）。`completes_iff`、`exits`、`Drains.along`、`exhausts` 与 `avoids_iff_closed` 是新的。
2. **最坏份额下的精确是否只是算术？** 数值是该构造的，但它是 `lasts_iff_of_exact` 的实例：覆盖族对零份额的支持律既是梯级族又是必要族，所以 K_N 是在最坏份额下持续 N 步的最小存量；份额为正时它只是充分的。
3. **为什么 `none_avoid_iff` 说“不避开”而不说“到达”？** 核心不用排中律；“每个种子到达”与“没有种子避开”只在排中律下等价。外围市场用经典逻辑，所以 `lands_iff_no_closed` 给出到达的形式。
4. **余量条件是否一般？** 不是核心律：`lands_iff_margin` 是 `exact_universal_landing_boundary` 加余量的算术。一般的是阻碍一侧：边界之上不动点给出避开着陆的封闭集，而 `some_avoids_iff` 说每个阻碍都是这种形式。着陆一侧（余量非负时每个正种子着陆）依赖该市场律的增益估计（`partial_finite_landing`），未抽象为核心律。
5. **外围声明为什么带公理？** 有理数与 `grind` 依赖标准公理，协议机器的定义经库实例依赖 `propext` 与 `Quot.sound`，版本化任务的模块用 Mathlib；三个核心模块的公理报告为空。
6. **范围。** 只证明所陈述的律；市场律、协议机器与实际市场、设备、权限或请求的对应不由此检查。acquired-revision-of-pending-task 中“有比较根据的修订”仍是该协议的事实；形成目的修订的一般律是 §113 的 `revision_continues`。

**边界。** 落地运行须：在 `check_becoming.py` 中编译与审计 Becoming.Viability、Becoming.Countdown 与 Becoming.Lasting（环境审计、对照与只用前导的编译只在检查器中运行）；然后运行 `check_market_instances.py`、`check_protocol_instances.py` 与 `check_versioned_task_instances.py`（各要求闭包中每个其他模块都有已通过的回执，最后一个用 Lean 4.30.0-rc2 与 Mathlib）；再把十项记录的新证明引用绑定到新回执。原市场、协议与任务模块的字节未改。

**落地（2026-10-14）。** 第三批落地：核心检查器回执 20261014T041246.931872Z 与 20261014T044840.291323Z 通过（核心公理报告为空），ProtocolInstances 20261014T041648.493464Z、MarketInstances 20261014T041714.366300Z、VersionedTaskInstances 20261014T041722.004469Z 通过（只用标准公理）；十项记录的新证明引用已绑定。落地时 ProtocolInstances 的两个新辅助名去掉市场措辞（`paidState` → `unitState`，`funded` → `afterUnit`），旧机器的名称不变。

## 115. 旧记录的一般律：复制与回溯读出

2026-10-14。续第 113 节，同一批准（Ren：“all needs to have general law proved”，“go with your recommendations”，经整合会话转达）。本节证明第 113 节留给后续的两组：复制机四项记录与 historical-source-binding。目标形式不变：每条律对其种类的每个世界或过程陈述为“Y 当且仅当 Z”，Z 是局部条件；等价不成立处给出最强的单向律与反例；旧例成为实例或对照。

```text
Result(s): 改写 inherited-structural-copying、recurrent-chain-assembly、formed-copying-registration、
           formed-copying-correction、historical-source-binding；不新增记录，状态不变
Delta: 核心新模块 Becoming.Copying（65 项定理／100 项声明）、Becoming.Retrodiction（17／24）；
       外围 CopyingInstances（63／73）与 RetrodictionInstances（21／27），
       检查器 check_copying_instances.py 与 check_retrodiction_instances.py
Supplied premises / correspondence: 无新前提；各实例保留原模块的前提与对应
Evidence: scratch_build 实编：核心每条声明公理报告为空；外围只用标准公理（CopyingInstances 58 项声明含之，
          RetrodictionInstances 19 项含 propext 与 Quot.sound）；不是回执
Boundary: 机器与分子复制、校对、生长，或与儿童命名、来源监控的对应不由此检查；仍为单向者见作者反审
Integration: §9 模块表；Becoming.lean 与 check_becoming.py 的模块列表；五项记录；旧记录审计表
```

**精确复制（Becoming.Copying）。** 对每个可判定相等的字母表与每个汲取律 `draw : Option α → α → Nat`（前一记号与本记号决定一次接合的汲取），复制读模板的待接记号：池中有该记号且空闲支持覆盖汲取时接合，否则停在原处，停滞后不再变（`steps_fixed`）。池供给一词，指每个记号在池中的数量不少于词中所用（`Supplies`，逐记号的计数条件）。

```lean
theorem built_iff : ∀ (prev : Option α) (built word pool : List α) (free used : Nat),
    (steps draw word.length ⟨prev, word, built, pool, free, used⟩).built = built ++ word ↔
      Supplies word pool ∧ use draw prev word ≤ free
```

完成时产物为该词、池去掉该词、支持减去所汲取（`copies`）；`completes_iff` 以待接为空陈述同一条件；留有 `r` 以释放时，恰当支持另覆盖 `r`（`releases_iff`）。自同一池依次复制多个词，每个完成且留有 `r` 的复制即释放：全部释放恰当池共同供给所有词且支持覆盖全部汲取与释放（`batch_all_iff`）；交换相邻两词——从而任意重排——不改变是否全部释放（`batch_all_swap`），但可改变哪些被释放：旧见证 `shared_supply_order_matters` 中两种次序都只释放第一个。池供给 `w ++ v` 恰当它供给 `w`、且取走 `w` 后余下的供给 `v`（`supplies_append_iff`）。

**局部汲取。** 首次接合汲取 `first`、同类之后汲取 `same`、异类之后汲取 `differ`（`pairDraw`）时，词的用量只经其相异邻对数依赖汲取律（`use_word`）；同长词中相异邻对数成等差，用量亦成等差（`use_midpoint`）；相异邻对较多的词汲取较少，恰当 `differ < same`（`use_lt_iff`）。

**经接触读取。** 复制在每一位接合配准在该位读出之物（`readSteps`，读值 `read : Nat → Option α`）：

```lean
theorem reading_iff (read : Nat → Option α) : ∀ (word pending : List α) (prev : Option α)
    (built pool : List α) (free used : Nat), pending.length = word.length →
    ((readSteps draw read word.length ⟨prev, pending, built, pool, free, used⟩).built =
        built ++ word ↔
      Reads read built.length word ∧ Supplies word pool ∧ use draw prev word ≤ free)
```

`Reads` 逐位；产物只增长（`readSteps_extends`）；对每个过程，每步延长输出恰当每段进程延长输出（`extends_along_iff`）。

**检查与替换。** 在第 `i` 位对照参考 `ref` 检查（汲取 `ci`），参考记号 `x` 与该位不同、池中有 `x` 且支持覆盖 `ce` 时换入 `x`，换出的记号回池（`inspect`）。

```lean
theorem inspect_le_iff (ci ce : Nat) (t : List α) (ref : Nat → Option α) (i : Nat) :
    (∀ s : Scan α, defects t (inspect ci ce ref i s).built ≤ defects t s.built) ↔
      FaithfulAt ref t i
```

对所有产物、池与支持都不增加相对模板 `t` 的缺陷，恰当参考在该位与模板一致；逆向的反例在证明内构造：产物即模板、池只含 `x`、支持恰为 `ci + ce`。忠实位置的每次扫描不增加缺陷（`scan_le`）；在缺陷位，检查留下参考记号恰当 `ci + ce ≤ free` 且池中有 `x`（`inspect_matches_iff`）；长度相同的产物无缺陷恰当它即模板（`defects_zero_iff`）；替换保持产物与池中每个记号的计数（`exchange_keeps_counts`）。首轮提议“检查与参照相符当且仅当缺陷为零”不是精确的律：相符的精确条件是单点的 `inspect_matches_iff`，零缺陷的精确条件是 `defects_zero_iff`。

**加倍。** 每单位自同一存量取 `d` 并一分为二（`doubling d`）：自 `k` 单位、存量 `m` 的 `n` 轮运行恰当 `d * required n k ≤ m`，终于 `k * 2 ^ n` 单位（`doubling_iff`），其中 `required n k + k = k * 2 ^ n`（`required_add`）。

**外围实例（CopyingInstances）。** 每台复制机的状态读作进行中的核心复制（`view`），机器一步即核心一步（`view_tick`、`tick_work_view`、`inspect_view`），机器的汲取是首次汲取 1 的局部汲取（`draw_eq`）。
- 结构复制：模板链被复制恰当池供给其记号且支持覆盖汲取（`copy_cells_iff`），被复制并释放恰当另覆盖一单位（`reproduce_iff`），对每个池；旧 `exact_reproduction_budget` 是池含模板自身记号的实例（`template_pool_reproduce_iff`）。同池批量（`batch_all_released_iff`、`batch_all_released_swap`）；交替／聚簇排序与第三排列约束由局部汲取律得出（`local_ranking_from_law`、`third_structure_from_law`）。
- 链生长：末端接合是交替词、单位汲取的核心复制（`grow_view`）；长度上限内，链按交替词生长恰当池供给该词且支持每记号覆盖一单位（`grow_iff`）；自空链形成成熟链恰当池中两类各至少四个且有八单位空闲（`mature_forms_iff`），旧 `missing_kind_stalls_with_work_remaining` 是其失败一侧。每次接合与每次切分各取一单位，故已用支持与“总长加链数”同增（`reproduce_used`、`rounds_used`）；由此自 `k` 条成熟链、具备各轮材料，`n` 轮达到 `k * 2 ^ n` 条恰当支持覆盖 `9 * required n k`（`rounds_mature_iff`），即取量 9 的加倍过程运行 `n` 轮（`rounds_follow_doubling`）；旧 `supported_rounds` 是充分一侧，`partial_failure_keeps_material`（26 < 27）是失败一侧。
- 配准：对每个状态，与词长相同数目的复制步把产物延长为该词，恰当每一位经实际连接读出其记号、池供给该词且支持覆盖其汲取（`operate_copies_iff`）；完整配准是实例（`registered_copy_cells`，不需旧定理的非空路径前提）；产物沿每段进程只增长（`product_extends_along`）；只有复制步改变产物（`product_gated`；`contact_course_keeps_product`、`product_change_passes_copy`，旧 `correcting_contact_does_not_rewrite_past` 由此一般化）；连接件、材料与支持的总量沿每段进程保持（`totals_along`，即旧 `history_accounts`，门为空）。
- 纠正：对每个状态与位置，检查对每个进行中的复制都不增加缺陷，恰当参考在该位忠实（`inspect_le_iff_instance`）；忠实位置的扫描（`scan_le_from_law`；旧扫描定理是实例 `scan_faithful_instance`）；单点条件（`matches_reference_from_law`）；旧 `wrong_reference_damages_correct_product` 的参考在被检位不忠实（`wrong_reference_unfaithful`）。

**回溯读出（Becoming.Retrodiction）。** 对每类历史、日期、关系、探测与报告：历史 `h` 在日期 `d` 给出关系 `routeAt h d`，日期化控制记录 `(d, q, emit (routeAt h d) q)`。实际历史总符合自己的记录（`actual_candidate`）；一历史符合另一历史给出的记录，恰当二者给出相同记录（`fits_iff_same`）。旧报告包在日期 `d` 由当时的关系与隐藏来源 `s` 产生，读出即说出来源内容：

```lean
theorem reading_right_iff [DecidableEq O] [DecidableEq V] (packet : R → X → P) (content : X → V)
    (F : H → Prop) (Admitted : X → Prop) (d : D) (h : H) (s : X) (ps : List (D × Q)) :
    (∀ g t, F g → Fits routeAt emit g (acquire routeAt emit h ps) → Admitted t →
        packet (routeAt g d) t = packet (routeAt h d) s → content t = content s) ↔
      (∀ g t, F g → Admitted t → packet (routeAt g d) t = packet (routeAt h d) s →
        content t ≠ content s → Separated routeAt emit g h ps)
```

右侧是局部条件：每个以另一内容给出同一报告包的族内对手，都被某一个日期化控制区分。读关系本身（经任意读法 `look`）同理（`look_right_iff`）。族含实际历史且来源被允许时，所有解释一致的读数即实际读数（`agreed_reading_actual`）；族不含实际历史时，一致读数可以是错的（外围的遗漏短暂变化）。首轮提议“与全部记录相容的路径总含实际路径；某一日期所有候选一致恰当记录决定该日期”由此精确化：“记录决定”即每个对手被某个控制区分。

**变化范围。** 日期为 `0, 1, 2, …`，`changes c a n` 计课程 `c` 自 `a` 起 `n` 步中的变化。回到原值而中途在别处的课程至少变化两次（`bracket`）。关系取两个不同值时：

```lean
theorem bracket_settles_iff {r r' : R} (two : r ≠ r') (a n k : Nat) :
    (∀ c : Nat → R, changes c a n ≤ k → c (a + n) = c a → ∀ j, j ≤ n → c (a + j) = c a) ↔
      (k < 2 ∨ n < 2)
```

两端读数相同的控制确定其间每个日期，恰当至多允许一次变化或其间无日期；反例是离开一个日期又回来的短暂变化（`excursion_changes`）。两端值不同时，其间每个日期在两条各变化一次的课程上分别取两值（`change_unlocated`）：知道有变化而不知其位置，读不出其间日期。

**外围实例（RetrodictionInstances）。** 四时刻来源史、时刻与解码后的控制记录即核心的历史、日期与记录（`acquire_eq`、`fits_iff`）；实际历史被每个含它的族保留（`actual_history_retained_from_law`）。对每个族、时刻、被允许扰动与实际目标，旧报告包读对恰当每个对手被某控制区分（`packet_read_iff`）；共享扰动的读法同理（`shares_read_iff`）。共同探测揭示路径是否共享扰动（`common_probe_reveals`），共享课程的变化不多于历史（`course_changes_le`），故一次变化范围内，对每个先前与随后路径在共享上一致的实际历史，控制保留的每个历史在命名时刻与之一致（`controls_settle_naming`，由 `bracket`）；后来退化与后来改善是实例（`deterioration_settled`、`improvement_settled`）。旧的未定情形是律的失败一侧：只有晚期控制时，常安全历史是未被区分的对手（`late_control_reading_fails`）；只有前后控制时，变化可在命名之前（`split_controls_reading_fails`，对手为先易损后安全）；遗漏的短暂变化即核心的短暂课程（`excursion_course`），在一次变化族外一致读数是错的（`excursion_agreed_wrong`），在两次变化族内未定（`excursion_reading_fails`，即 `bracket_settles_iff` 的反例）。

**作者反审。**
1. **新律还是重述？** `built_iff`、`releases_iff`、`batch_all_iff`、`reading_iff`、`inspect_le_iff`、`inspect_matches_iff`、`doubling_iff`、`reading_right_iff`、`bracket_settles_iff` 是新的等价；`extends_along_iff` 是一步归纳，`look_right_iff` 与 `reading_right_iff` 同证，按此计。外围的 `rounds_mature_iff` 的必要一侧用了新的支持不变量，不是旧定理的重排。
2. **条件是否局部？** `Supplies` 逐记号计数；`Reads` 逐位；`FaithfulAt` 单点；`Separated` 每个对手一个控制；`k < 2 ∨ n < 2` 是范围的数。
3. **外围定理为什么带公理？** 机器的定义用库的成员判定、`erase`、`filter` 与 `simp`／`omega`、`decide`；所以实例在外围，核心为空公理。
4. **仍是单向或未一般化的。** `finite_lineage_inherits` 仍只有充分一侧；`registered_copy_cells` 只给出产物的记号，链的边仍由旧定理；回溯读出的律对给定的族与扰动包络精确，不推出族本身——变化范围是给定前提，不由数据学得（旧记录的前提保持）。
5. **范围。** 只证明所陈述的律；机器与分子复制、校对、生长，或与儿童命名、来源监控的对应不由此检查。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计 `Becoming.Copying` 与 `Becoming.Retrodiction`，然后运行 `check_copying_instances.py` 与 `check_retrodiction_instances.py`（它们要求闭包中每个其他模块都有已通过的回执），并把五项记录的新证明引用绑定到新回执。各外围机器模块的字节未改。新声明的名称用结构词（汲取律 `draw`、`pairDraw`，用量 `use`，已用 `used`，`drawSupport`），不用市场词；旧机器的名称因旧记录引用而不变。

**落地（2026-10-14）。** 第三批落地：核心检查器回执 20261014T044840.291323Z 通过（核心公理报告为空），CopyingInstances 20261014T045347.438672Z 与 RetrodictionInstances 20261014T045409.164228Z 通过（只用标准公理）；五项记录的新证明引用已绑定。本节原写作第 114 节，与生存核一节同时写成，合并时改为第 115 节。

## 116. 旧记录的一般律：到达、谱系与链的边

2026-10-14。开放问题计划（Ren：“please, do all”，经整合会话转达）第 11 与 14 项：第 114 节留下的着陆一侧与第 115 节留下的两处单向结果。目标形式不变：每条律对其种类的每个过程陈述为“Y 当且仅当 Z”，Z 是局部条件；某方向需要判定时，判定作为显式假设出现，并有定理说明它确实需要；旧例成为实例，逆命题不成立处给出反例定理。

```text
Result(s): 改写 market-partial-correction-boundary、market-finite-support-obstruction、
           market-supported-finite-transition、inherited-structural-copying、formed-copying-registration、
           recurrent-chain-assembly；不新增记录，状态不变；market-protected-continuation 与 formed-copying-correction
           的主张不变，其引用的源文件改动，由落地运行对齐哈希并重新绑定
Delta: Becoming.Lasting 69 项定理／83 项声明（原 36／43）；Becoming.Copying 68／103（原 65／100）；
       外围 MarketInstances 45／53（原 29／34），CopyingInstances 86／98（原 63／73）；两个外围检查器的范围说明
Supplied premises / correspondence: 无新前提；判定以 DecidablePred 假设出现；各实例保留原模块的前提与对应
Evidence: scratch_build 实编：两个核心模块每条声明公理报告为空，外围只用标准公理；不是回执
Boundary: 着陆一侧的三个增益估计与正种子进入稳定区仍是该有理律的事实，见作者反审
Integration: §9 模块表；Becoming.lean 根注释；六项记录；旧记录审计表
```

**到达（Becoming.Lasting）。** `Reaches f adm target n s`：`s` 在目标内，或尚余步数且每个可容许扰动把 `s` 带到少一步内到达目标的构型。它是持续的对偶：漏斗族（`Funnel`）的第 0 级在目标内，第 k + 1 级的构型在目标内或每个可容许步把它带到第 k 级；汇聚族（`Basin`）在每一级含目标，并把每个可容许步都带到第 k 级的构型收入第 k + 1 级。漏斗以命题为层级、`Reaches` 为最小必要族的设想来自会话 Current math core。

```lean
theorem reaches_iff_funnel :
    Reaches f adm target n s ↔ ∃ F : Nat → S → Prop, F n s ∧ Funnel f adm target F
theorem reaches_iff_basin :
    Reaches f adm target n s ↔ ∀ L : Nat → S → Prop, Basin f adm target L → L n s
```

`Reaches` 是最大的漏斗族，也是最小的汇聚族；兼为二者的族恰是到达（`reaches_iff_of_exact`）。到达随步数单调（`Reaches.mono`），并可复合：起点 m 步内到达区域 B、B 中每个构型 k 步内到达目标，则起点 k + m 步内到达目标（`Reaches.trans`）。这是第 114 节梯级律的对偶，不用判定。

**历史与判定。** 到达者在每段可容许历史的前 n 步内遇到目标（`Reaches.histories`，不加前提）。逆向需要一个可容许扰动与可判定的目标（`reaches_iff_histories`）；`Search.histories_need_decision` 说明判定确实需要：一条在“选择之前”与“选择了 a 之后”之间走一步的律，若对它由历史得出到达，则对每个布尔序列有有限全知原理。给定一个可容许扰动，到达与在目标外持续互斥（`Reaches.not_lasts`）。

**确定的律。** 确定的律的到达即轨道在 n 步内遇到目标，不加前提（`reaches_iff_orbit`）；所以第 114 节 `avoids_iff_closed` 的对偶是：

```lean
theorem orbit_reaches_iff_funnel :
    (∃ k, k ≤ n ∧ target (Law.orbit next s k)) ↔
      ∃ F : Nat → S → Prop, F n s ∧ (∀ x, F 0 x → target x) ∧
        ∀ k x, F (k + 1) x → target x ∨ F k (next x)
theorem orbit_reaches_iff_variant [DecidablePred target] :
    (∃ k, k ≤ n ∧ target (Law.orbit next s k)) ↔
      ∃ V : S → Nat, V s ≤ n ∧ ∀ x, V x ≤ n → target x ∨ V (next x) < V x
theorem reaches_iff_not_lasts [DecidablePred target] :
    Reaches (determined next) (fun _ => True) target n s ↔
      ¬ Lasts (determined next) (fun _ => True) (fun x => ¬ target x) n s
```

数值变式（`Variant`）对每条带扰动的律给出漏斗（`Variant.funnel`、`Variant.reaches`），这一方向不用判定；由到达得出变式时变式是遇到目标前的步数（`hitTime`），要用判定。两处判定都有见证：若每条确定的律在遇到目标时都有数值变式，则构型的相等可判定（`numeric_needs_decision`）；若对每个目标“不在目标外持续”都给出到达，则双重否定可消去（`dual_needs_decision`）。所以核心里不用判定的形式是命题层级的漏斗；数值形式与对偶是目标可判定时的推论。

**着陆一侧（外围 MarketInstances，标准公理）。** 一般的部分：对每条有理数上的确定的律，若某区域外于目标的每一步保持该区域、使一个量至少增加固定增益、且该量有上界，则区域中该量距上界不足 k 个增益的构型组成漏斗（`rising_funnel`、`rising_reaches`）。市场的部分：0 ≤ b ≤ 5/12 时，对种子份额 2a 的稳定区（物理，份额至少 a，质量至少 3/8 + a/16，影响至多 1 − a/2；律保持它，`settled_kept`），三个增益估计各给一个漏斗：份额在 7/8 之下每步至少增 a·(a/16)/10（`settled_reaches_share`），份额高后影响在 1/4 之上每步至少降 1/32（`share_reaches_influence`，25 步），影响低后质量在 1/2 之下每步至少增 1/16（`influence_reaches_landing`，3 步）。由 `Reaches.trans` 复合，稳定区中每个构型着陆（`settled_reaches_landing`）。正种子进入其稳定区用的是旧的种子保持与正差距估计（`seed_reaches_settled`）。所以每个正种子到达着陆（`seed_reaches_landing`），`partial_finite_landing` 是实例（`landing_side_instance`），b = 0 即救援的有限期限 `positive_seed_finite_landing`（`rescue_landing_instance`）；0 ≤ b ≤ 3/4 时每个正种子着陆恰当 b ≤ 5/12 由核心律得出：着陆一侧是到达律，另一侧是第 114 节的不动构型（`landing_boundary_instance`）。对每个 b，每个正种子着陆恰当每个正种子被某个通向着陆的漏斗含有（`lands_iff_funnel`）。`every_finite_stock_has_obstructed_positive_seeds` 是耗竭律的实例（`obstructed_seeds_instance`：旧证明以 `forces_failure_instance` 代替 `finite_support_forces_failure`）。

**谱系（Becoming.Copying 与外围 CopyingInstances）。** 自同一池与支持把一词依次复制 n 次：

```lean
theorem lineage_all_iff (r : Nat) (word pool : List α) (free used n : Nat) :
    Every (batch draw r (List.replicate n word) pool free used).1 ↔
      (∀ a, n * countOf a word ≤ countOf a pool) ∧ n * (use draw none word + r) ≤ free
```

每次复制都释放，恰当池中每个记号不少于词中所用的 n 倍，且支持覆盖 n 倍的汲取与释放；这是 `batch_all_iff` 对重复词的计数。复制机上（`AllReleased`：谱系的每次复制都释放），对每个池与支持，路径形的链的谱系每次都释放恰当谱系律的条件成立（`lineage_released_iff`）；此时谱系含 n + 1 个亲本的副本，所用支持增加 n 倍的汲取与释放（`lineage_of_released`）。`finite_lineage_inherits` 的逆读在所用支持上成立：

```lean
theorem lineage_used_iff (law : StructuralCopying.Law) (p : Strand)
    (hp : p.bonds = path p.cells.length) (hn : p.cells ≠ []) : ∀ (n : Nat) (r : Supply),
    (StructuralCopying.descendants law n p r).2.spent =
        r.spent + n * (StructuralCopying.cost law none p.cells + 1) ↔ AllReleased law n p r
```

旧定理的前提满足谱系律，它是充分一侧（`finite_lineage_instance`）。只读链本身逆命题不成立：支持覆盖复制而不覆盖释放时，一代谱系含两个亲本的副本，复制却未释放（`strands_do_not_show_release`）。

**链的边。** 配准机的每段进程都使产物的边是其记号上的路径（`path_shaped_along`，`Countdown.invariant_iff_reach` 的实例：复制步延长路径，其余步不改产物）。所以与 `operate_copies_iff` 同一条件使产物成为整条链，含边（`operate_strand_iff`）；完整配准复制模板（含边）恰当模板的边是其记号上的路径（`registered_copy_iff`）。边无需记号以外的条件；旧 `registered_inheritance` 是实例，不需其非空前提（`registered_inheritance_instance`）。链生长同理：末端接合保持路径形（`attach_path_shaped`），所以 `grow_iff` 与 `mature_forms_iff` 对整条链成立（`grow_strand_iff`、`mature_strand_iff`）。

**作者反审。**
1. **哪些是重述？** `reaches_iff_funnel` 与 `reaches_iff_basin` 各取 `Reaches` 为见证，内容在于把“n 步内到达”从两侧化为一步条件，与第 114 节梯级律成对。`reaches_iff_orbit`、`Reaches.trans`、`orbit_reaches_iff_variant` 与三个判定见证是新的。`lineage_all_iff` 是 `batch_all_iff` 加重复词的计数，按推论计；`lineage_used_iff` 的必要一侧要用新的所用支持等式（`reproduce_strand_used`），不是旧定理的重排。
2. **判定是不是缺口？** 不是。核心不用排中律；不用判定的形式（命题层级漏斗、轨道形式、`Reaches.histories`、`Reaches.not_lasts`）都已证明，需要判定的三个方向各有定理说明：没有它们，相等判定、双重否定消去或有限全知原理就会成立。
3. **着陆一侧是否一般？** 一般的是 `rising_funnel`、复合与到达律。三个增益常数与正种子进入稳定区（经旧的终将估计，依赖有理数的阿基米德性）是这一条有理律的事实，即实例的内容。步数界依赖种子份额（增益为 a²/160），与旧的 `no_uniform_pulse_duration` 一致：没有对所有正种子一致的步数。
4. **谱系的逆为何读在所用支持上？** 旧结论有两部分：链为 n + 1 个副本，所用支持增加 n 倍。只由所用支持即可逆推；只由链不能（反例定理）。
5. **外围声明为什么带公理？** 有理数、`grind`、库的成员判定与 `simp` 依赖标准公理；两个核心模块的公理报告为空。
6. **范围。** 只证明所陈述的律；市场律与实际市场、复制机与分子复制或生长的对应不由此检查。

**边界。** 落地运行须：在 `check_becoming.py` 中编译与审计 `Becoming.Lasting` 与 `Becoming.Copying`（及根模块的注释改动）；然后运行 `check_market_instances.py` 与 `check_copying_instances.py`；再把六项记录中这四个源文件的证明引用绑定到新回执：这些源文件改动后，六项记录中绑定第三批回执的旧绑定已移去（回执引用保留），有效范围的说明改回“一般律仅经scratch实编”；market-protected-continuation 与 formed-copying-correction 保留旧绑定，落地时更新其哈希并改绑新回执，它们所引的声明未变。原市场与复制机模块的字节未改。新名称用结构词（`Reaches`、`Funnel`、`Basin`、`Variant`、`hitTime`、`AllReleased`、`PathShaped`）；旧机器的名称不变。

**落地（2026-10-14）。** 第四批落地：核心检查器回执 20261014T091930.724493Z 通过（核心公理报告为空），MarketInstances 20261014T092430.203169Z 与 CopyingInstances 20261014T092443.150338Z 通过（只用标准公理）；六项记录对这四个源文件的证明绑定已恢复并指向新回执，有效范围的说明改回“一般律已由检查器回执绑定”。

## 117. 旧记录的一般律：跨情境读出与机器的每段历史

2026-10-14。开放问题计划中的两项（Ren：“please, do all”，经整合会话转达）：三项一段历史的绑定记录，其历史到解释输入的联结原是对一段历史（如 `coordinated 37`）的 `decide`；四项机器记录只部分一般。目标形式同 §113：每条律对其种类的每个世界、历史或条件陈述为“Y 当且仅当 Z”，Z 是局部条件；能在核心陈述而不用库事实的部分放在核心，机器的实例在外围；内容确是协议自身定义之处，说明一般律是什么、实例添了什么，不把未经定理的东西改称一般。逐行见[旧记录审计表](../history/root-foundation/development/becoming-general-laws-plan/general-law-audit/older-records.md)。

```text
Result(s): 改写 enacted-scene-binding、encounter-selection-and-revision、retrospective-source-binding、
           acquired-revision-of-pending-task、pending-task-context-applicability、
           joint-practice-forms-continuation、formed-goal-revision-continuation；不新增记录，状态不变
Delta: 核心新模块 Becoming.CrossSituational（37 项定理／43 项声明）；外围 MachineInstances 增至 96／114
       （原 44／49），VersionedTaskInstances 增至 22／30（原 11／17，Lean 4.30.0-rc2 与 Mathlib）
Supplied premises / correspondence: 无新前提；各实例保留原模块的前提与对应
Evidence: scratch_build 实编：核心每条声明公理报告为空，环境审计中该模块没有带公理的生成常量；
          外围只用标准公理；不是检查记录
Boundary: 场景与来源的模型、选择下一次访问的规则、两条作用规律与机器的步定义仍是各构造自身的内容，见作者反审
Integration: §9 模块表；Becoming.lean 与 check_becoming.py 的模块列表；七项记录；旧记录审计表
```

**跨情境读出（Becoming.CrossSituational）。** 学习者在多个场合遇到一个形式，每个场合的记录提供当时可及的意义。哪些记录关涉一个形式、每条记录提供什么，由两个布尔关系读出（`bears`、`offers`）。意义在每条关涉的记录都提供它处成立（`stands`）；形式的候选是候选范围中成立的意义（`candidates`），恰有一个时形式被解析（`unique`）。这是 inquiry-root 各取得绑定机器的规则，这里对每类记录与意义、每种关涉与提供的读法陈述。

```lean
theorem candidates_eq_iff [DecidableEq M] {rep : List M} (distinct : Distinct rep)
    {rs : List R} {e : M} :
    candidates bears offers rep rs = [e] ↔
      e ∈ rep ∧ (∀ r, r ∈ rs → bears r = true → offers r e = true) ∧
        ∀ m, m ∈ rep → m ≠ e → ∃ r, r ∈ rs ∧ bears r = true ∧ offers r m = false
```

解析即分离：两个条件都是局部的，覆盖每条记录一个，排除每个对手一条记录（`resolves_iff` 对 `unique` 陈述同一条件）。候选范围有重复时律不成立（`Repeated`）。后来的记录只缩小候选：再有一段记录之后的候选，是先前候选中在这段记录上成立者（`candidates_append`）；关涉的记录恰留下它提供的候选，不关涉的记录什么也不改（`candidates_snoc_bearing`、`candidates_snoc_other`）；被排除的意义一直被排除（`narrows`），候选恰在此后每条关涉记录都提供它时仍是候选（`stays_iff`）。覆盖使唯一的解析成为目标：目标在候选范围中、每条关涉记录都提供它时，任何唯一候选即目标（`resolved_is_target`，旧 `unique_resolution_is_correct_under_coverage` 的一般形式）；一条遗漏目标的记录可以留下错误的唯一候选（`Omitted`）。经一族解释读记录：记录提供一个意义，恰当族中某个以该意义为目标的世界解释它；每条关涉记录都被某个以 `t` 为目标的族内世界解释时，

```lean
theorem resolves_explained_iff [DecidableEq M] {W : Type w} (family : W → Prop) (target : W → M)
    (explains : R → W → Prop)
    (offered : ∀ r m, offers r m = true ↔ ∃ w, family w ∧ target w = m ∧ explains r w)
    {rep : List M} (distinct : Distinct rep) {rs : List R} {t : M} (available : t ∈ rep)
    (actual : ∀ r, r ∈ rs → bears r = true → ∃ w, family w ∧ target w = t ∧ explains r w) :
    candidates bears offers rep rs = [t] ↔
      ∀ m, m ∈ rep → m ≠ t → ∃ r, r ∈ rs ∧ bears r = true ∧
        ∀ w, family w → target w = m → ¬ explains r w
```

词被分组恢复处（`Becoming.Segmentation`），以解析读每个编码序列都得其各词的意义，恰当每个词的记录分离其意义（`reads_every_iff`）。

**外围实例（MachineInstances，标准公理）。**
- **取得词库的绑定。** 取得词库的候选即其被接纳记录的核心候选（`candidates_eq`）。所以对每个候选范围不重复的词库，`b` 之词解析为其原子，恰当其被接纳的记录分离该原子（`Separated`，`resolve_iff`）；转移记录对二词编码成组时，每个编码序列都读对，恰当每个词都被分离（`interprets_every_iff_separated`）。
- **场景的每段历史。** 场景的一步是去某处或命名某处（`SceneMove`）。每一步保持转移记录、候选范围与排除记录，并恰添上所闻的记录：在有支持时命名一个原子所在处，记下其词，提供学习者所在处可及者（`heard`；`step_records`、`enact_records`）。所以从每个转移记录对二词编码成组、候选范围不重复的处境出发，经每段移动与命名的历史：

```lean
theorem scene_interprets_every_iff (s : Situation) (groups : Groups s.lexicon.percept.log)
    (distinct : CrossSituational.Distinct s.lexicon.repertoire) (h : List SceneMove) :
    (∀ ws, interpret (enact s h).lexicon (encode ws) = assembleMessage (ws.map Expr.atom)) ↔
      ∀ b, Separated s.lexicon.repertoire s.lexicon.excluded
        (s.lexicon.records ++ heardAlong s h) b
```

  `coordinated 37` 是实例（`coordinated_from_history`）：它的四次命名各提供所在处可及者：每个原子在其名被闻时都可及，其他每个意义都在其中某次不可及。失败一侧：在一处把两处各命名两次（`stationary 37`）缺分离（`stationary_fails`），从原子不可及处命名（`mistimed 37`）缺覆盖（`mistimed_fails`）。旧的输入等式仍是该历史的 `decide`，现在只计算这一实例的记录，联结由律给出。
- **合作命名。** 转移记录成组、命名来源被接纳、支持够每个可及意义命名一次时，命名每个可及原子（每条记录提供可及者）之后，可及原子之词的候选恰是其先前候选中可及者，其他词的候选不变（`naming_narrows`）；一次访问的局部命名即此律（`local_naming_narrows`）。`acquired 51` 是分离律的实例（`acquired_from_separation`）。选择下一次访问的规则仍是该机器的。
- **保留记录的回溯绑定。** 保留包的记录恰提供以下世界的原子：已学路线、被允许的扰动、产生其报告（`mem_alternatives`）。对每个记忆、扰动范围、形式与目标，若该形式的每个包都由某个以目标为目标的已学世界产生：

```lean
theorem retrospective_resolves_iff (s : Memory) (faults : List SourceReliance.Faults)
    (distinct : CrossSituational.Distinct s.base.repertoire) (form : List Sound) (b : Bool)
    (available : Expr.atom b ∈ s.base.repertoire)
    (produced : ∀ p, p ∈ s.packets → p.form = form → ∃ w : SourceReliance.World,
      (w.route ∈ routes s ∧ w.faults ∈ faults) ∧ w.target = b ∧ SourceReliance.view w = p.reports) :
    resolve (bindingView s faults) form = some (Expr.atom b) ↔
      ∀ m, m ∈ s.base.repertoire → m ≠ Expr.atom b → ∃ p, p ∈ s.packets ∧ p.form = form ∧
        ∀ w : SourceReliance.World, w.route ∈ routes s ∧ w.faults ∈ faults →
          Expr.atom w.target = m → SourceReliance.view w ≠ p.reports
```

  旧覆盖前提（实际路线的校准，每个包由它在被允许扰动下产生）给出产生前提（`produced_of_calibration`），旧覆盖定理由 `resolved_is_target` 重得（`coverage_from_law`）。`retrospective 36` 是实例（`retrospective_from_separation`）。失败一侧：真实路线改变之后，较早的 `true` 之词的包不由任何以 `true` 为目标的已学世界产生（`changed_route_unproduced`），覆盖不成立。
- **修订的根据。** 对构造的每个条件，比较认可学习优于参与，恰当访问有损而转变维护保留（`better_iff`）；取得、修订与改革恰在此处完成（`completed_iff_better`）。
- **一轮实践。** 从每个状态，审查者 `r` 与工作者 `w` 的一轮（尝试、回应、修订、经检验的重试）完成，恰当 `w` 在场、`r` 是在场的在册者且不是 `w`、`r` 所记的做法应答当前处境；完成后记下审查、把处境的做法装入工作者、完成试验，别无改变（`round_iff`）。所以工作者此后已受训（`round_trains`），受训的审查者无需再检（`trained_round_iff`），受训沿每段不含修订、回到原处境的进程保持（`trained_along`）。完整历史的三轮是实例（`complete_history_rounds`）；其间的接纳与交接是组织自身的步。

**外围实例（VersionedTaskInstances，Lean 4.30.0-rc2 与 Mathlib）。**
- **对每个条件的在途修订。** 对每个条件与每个在既有队列不变量下有效、有队首待完成的装置，取得、修订、改革、改写队首与交付恰在访问有损而转变维护保留时运行——即 `better_iff` 的条件；端点随后执行学习实践，保留先前一次损失、不再增加，终于三条记录与工作、储备、已用单位 (2, 6, 10)（`continuation_eq`、`continuation_isSome_iff`）。旧 `acquired_revision_changes_pending_action` 是 `harmful` 处的实例（`harmful_continuation_instance`）。
- **经审查的损失。** 每种实践的相关风险即其作用规律的损失条件（`relevant_risk_eq`），所执行的实践恰在其相关风险成立处添一次损失（`enact_losses`）。所以对每个条件、报告与待完成端点：

```lean
theorem review_losses (c : GoalFormationRevision.Conditions) (report : Option Bool)
    (l : GoalFormationRevision.State) (v : Bool) (reports : List (Option Bool)) :
    (PendingTaskApplicability.reviewAndAct c report ⟨l, v, true, reports⟩).learning.losses =
      l.losses + (if report = some false ∧ 3 ≤ l.account.work ∧
        PendingTaskApplicability.relevantRisk c v = true then 1 else 0)
```

  即审查添一次损失，恰当报告排除相关风险、工作覆盖审查与行动的进程（`Stock.Covered`）、而相关风险实际成立（`review_adds_loss_iff`）；覆盖作用时刻的报告从不如此，`covered_review_adds_no_practice_loss` 对待完成端点由此得出（`covered_review_instance`）。把审查读作端点上的过程（`reviews`），报告未排除相关风险的每次审查都保持损失计数（`losses_kept`，`Gated.KeptBy` 的实例），由这样的审查组成的每段进程亦然（`losses_kept_along`）。

**作者反审。**
1. **新律还是重述？** `candidates_eq_iff`、`candidates_append`、`stays_iff`、`resolves_explained_iff` 是新的；`resolved_is_target` 把旧的覆盖定理推广到每类记录与意义；`reads_every_iff` 是 `Segmentation.reads_every_iff` 与 `resolves_iff` 的组合。外围的 `scene_interprets_every_iff`、`naming_narrows`、`retrospective_resolves_iff`、`continuation_eq`、`review_losses`、`round_iff`、`better_iff` 是对每段历史、每个状态或每个条件的新等价；`coverage_from_law`、`covered_review_instance`、`harmful_continuation_instance` 与 `complete_history_rounds` 是旧定理作为实例重得。
2. **条件是否局部？** 分离：覆盖每条记录一个，排除每个对手一条记录；回溯读出的排除是每个对手一个包；一轮的条件是在场、在册、不同人与一次做法比较；损失的条件是一个报告、一个工作数与一个相关风险。
3. **哪些仍是构造自身的内容？** 场景的位置、范围与可及者（`visible`），来源的路线、扰动与产生（SourceReliance），选择下一次访问的规则，两条作用规律（何者对何种实践算作损失，故何种风险相关），目的编码与工作单位，实践机器的步定义：律对它们的每段历史、每个状态或每个条件陈述，它们本身由构造给出。`better_iff` 对构造的八个条件成立，比较的定义（`protects`、`gains`）属构造。`acquired 51` 的选择史没有作为“每段被选择的访问史”陈述：律是一次访问的（`naming_narrows`）与终了记录的分离（`acquired_from_separation`）。
4. **未作为实例陈述的。** `cycles_iff` 未写成 `Stock` 的实例：工作与储备两个相耦合的存量，补充随状态而变，现有的存量律不直接适用。`Becoming.Revision` 与 `ContinuingRevision` 读的是修订改变登记与燃料的方式，这里的修订改写一个待完成指令或一个做法记录，未找到使其成为实例的读法，未作陈述。
5. **公理。** 核心模块每条声明公理报告为空，环境审计中没有带公理的生成常量；外围声明经机器定义依赖 `propext`、`Quot.sound` 与 `Classical.choice`，版本化任务的模块用 Mathlib。
6. **范围。** 只证明所陈述的律；场景、命名、来源记忆、在途任务与实践机器与实际儿童、场景、设备或组织的对应不由此检查。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计 `Becoming.CrossSituational`（环境审计、对照与只用前导的编译只在检查器中运行），然后运行 `check_machine_instances.py` 与 `check_versioned_task_instances.py`，再把七项记录对 MachineInstances 与 VersionedTaskInstances 的证明绑定从先前的运行（20261013T222154.117109Z、20261014T041722.004469Z）改指新运行，并为新的核心引用加绑定。引用这两个外围文件的其他记录（acquired-binding-compositional-use、joint-correlation-reduced-dynamics、transition-grouping-word-partition、versioned-request-completion）只遇到追加的声明，其哈希在落地时随之更新。各原机器模块的字节未改。新声明的名称与说明用结构词（工作、储备、已用、覆盖、排除、相关风险），旧机器的名称不变。

**落地（2026-10-14）。** 第四批落地：核心检查器回执 20261014T091930.724493Z 通过（核心公理报告为空），MachineInstances 20261014T092451.420909Z 与 VersionedTaskInstances 20261014T092502.891314Z 通过（只用标准公理）；七项记录的外围绑定已改指新运行，三项记录对 `Becoming.CrossSituational` 的引用已绑定。

## 118. 相同之下补全：经等价承载规律与分支检验（Becoming.Likeness）

2026-10-14。按 Ren 的“move towards 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)），工作板上“Current math core”的 likeness 一行，由整合会话批准，在开放问题计划之外。本节回答三项记录的下一步：determinacy-up-to-likeness 要求的 `carries_law_iff` 在相同之下的精确形式，以及像、`not_fixes_other_of_new`、实验之律经投影的读法（`not_fixesThrough_*`）与 `determined_dichotomy` 的相同之下形式；tests-fix-likeness-where-determined 要求的核心中分支检验固定相同的构造性证明，或它需要的逻辑原则；configurations-alike-by-relation 的 next_delta 列着这两项。

```text
Result(s): 改写 determinacy-up-to-likeness 与 tests-fix-likeness-where-determined（两者迁移到 schema 2，
           对照表在 development/becoming-general-laws-plan/readability/migrations/）、
           configurations-alike-by-relation（schema 1，只缩短）；不新增记录
Delta: 核心新模块 Becoming.Likeness（61 项定理／79 项声明）
Supplied premises / correspondence: 无新前提；分支检验之律以动作与主张被列出、两个框架为 FiniteDecided
           （某个列表包含每个配置，步与主张已判定）为条件
Evidence: scratch_build 实编：每条声明公理报告为空，无警告；不是回执
Boundary: 去掉判定后等价是否成立开放；BranchingTest 与外围 Test 的桥接未写
Integration: §9 模块表；Becoming.lean 与 check_becoming.py 的模块列表；三项记录；Histories 头注两句
```

**经等价承载规律。** `carries_law_iff`（Becoming.Mechanism）说：某个确定的过程经描述 `π` 容许每一步，恰当描述相等的配置以同一动作到描述相等的配置（`GoAlike`）。在相同之下，“确定”换成“相同之下确定”，相等换成一个等价关系：

```lean
theorem carries_law_alike_iff {P : Process S A} {π : S → K} {claims : K → D → Prop} :
    (∃ Q : Process K A, (∀ k, DeterminedAt (⟨Q, claims⟩ : Frame K A D) k) ∧
        FactorsThrough P π Q) ↔
      ∃ E : K → K → Prop, Equivalence E ∧ Registers claims E ∧ GoAlikeUnder P π E
```

`Registers claims E`：被 `E` 联系的描述实现同样的主张；`GoAlikeUnder P π E`：描述被 `E` 联系的配置以一个动作到描述被 `E` 联系的配置。由左到右，`E` 取承载过程中的相同；由右到左，承载者是在 `E` 下闭合的像（`imageUnder`），`E` 是它的互模拟（`imageUnder_bisimulation`、`imageUnder_determinedAt`）。每个描述就是自己的主张时，登记主张的等价只有相等，这就是 `carries_law_iff`（`carries_law_named_iff`）；什么也不主张时每个描述都承载规律（`carries_unregistered`，Becoming.Branching）。

**像不再是最小承载者。** 以相等，像是该步经 `π` 所经的最小过程（`Image.least`），描述承载规律恰当像确定（`image_determined_iff`）。在相同之下，像的确定性仍有精确条件：

```lean
theorem image_determinedAt_iff {P : Process S A} {π : S → K} {claims : K → D → Prop} :
    (∀ k, DeterminedAt (⟨Image P π, claims⟩ : Frame K A D) k) ↔
      GoAlikeUnder P π (Alike (⟨Image P π, claims⟩ : Frame K A D) ⟨Image P π, claims⟩)
```

但它不再刻画承载：在 `Parting` 中，起点以同一动作到一个能继续的配置和一个不能继续的配置；经恒等映射，像在起点处在相同之下不确定（`Parting.image_not_determinedAt`），而什么也不主张时恒等映射在相同之下承载规律（`Parting.carries`）。更大的过程可以使像所分开者相同。

**从不返回；经投影；差别制造的二分。** 框架处处在相同之下确定、运行中没有配置与先前的相同时，在运行经过的每个配置处，记录在相同之下不固定那里所取动作以外的任何动作，对在一个主张上不同的结果（`Run.not_fixesAlike_other_of_new`，由 `Run.not_fixesAlike_of_untaken`）；在相同之下从不返回蕴涵从不返回（`Run.new_of_newAlike`）。经投影读时也是如此：描述上某个相同之下确定的过程容许经 `π` 读的各步、运行在 `t` 之前未在与 `k` 相同的描述处取 `a` 时，记录在相同之下不固定 `a` 在 `k` 的任何结果，对在一个主张上不同的两个描述（`Run.not_fixesThroughAlike_of_untaken`，经对整个相同类的干预 `retargetAlike`）；所以凡是有登记主张的等价使配置同行之处都是如此（`Run.not_fixesThroughAlike_of_goAlikeUnder`，经 `imageUnder`）。这是 Mechanism 的 `not_fixesThrough_of_untaken` 与 `not_fixesThrough_of_goAlike` 在相同之下的形式。`Joint` 的二分（`determined_dichotomy`）要动作决定步骤；它只需以该动作由扣除后的配置出发的每一步到达条件的同一水平：

```lean
theorem dichotomy_of_same_level {P : Process S A} {withhold : F → S → S} {f : F} {s : S} {a : A}
    {g : F} {c : C} (same : ∀ t t', P.step (withhold f s) a t → P.step (withhold f s) a t' →
      K.level t c = K.level t' c)
    (breaks : K.BreaksBy P s a g c) {t₀ : S} (available : P.step (withhold f s) a t₀)
    (depends : K.requires (withhold f s) g c)
    (met : K.need (withhold f s) g c ≤ K.level (withhold f s) c) :
    K.MakesDifference P withhold f s a g c ∨ K.BreaksBy P (withhold f s) a g c
```

在登记该水平的主张之下的相同之下的确定是其情形（`Dependence.dichotomy_of_determinedAt`），确定也是（`Dependence.dichotomy_of_determined` 以读水平的主张重新推出 `determined_dichotomy` 的陈述）。在每个过程中，那一部分造成差别恰当同一动作不再断裂依存（`makesDifference_iff`）；条件所加的是两者之间的判定。

**分支检验固定相同（构造性）。** 分支检验是：空检验、一个主张、一个检验的失败、两个检验的合取，或“以动作 `a` 的某一步可到达某检验成立之处”（`BranchingTest`、`BranchingTest.Holds`）。相同的配置通过同样的分支检验，不加前提（`Alike.sameBranchingTests`）。反方向：

```lean
theorem alike_iff_sameBranchingTests (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {s : S} {s' : S'} : Alike F G s s' ↔ SameBranchingTests F G s s'
```

`FiniteDecided F`：某个列表包含 `F` 的每个配置，动作是否把一个配置带到另一个、配置是否实现某个主张都已判定（`Decided`，Becoming.Decidedness）。证明的每一步由判定构造：深度 `k` 的相同（`AlikeTo`：同样的主张，且对 `k + 1`，任一方的每一步由另一方以同一动作到深度 `k` 相同的配置的一步相配）已判定（`AlikeTo.decided`）；它不成立处，由判定找出不同的主张或无可匹配的一步，构造一个在一方成立、在另一方不成立的分支检验（`apart_of_not_alikeTo`）；深度的相同逐步变细，在不超过配置对数目的某个深度停止（`AlikeTo.steady_within`、`AlikeTo.steady`，由 `stops_decreasing`：每个配置对一旦不相同便不再相同，所以至多脱落一次；对配置对的列表归纳，新的一对若脱落，略去它脱落的那一步，其余各对在自己的列表长度之内停止）；在那里它是互模拟（`AlikeTo.bisimulation`）。所以有限、已定的框架的相同已判定（`Alike.decided`），就是每个深度的相同（`alike_iff_alikeTo`），也就是配置对数目之深度的相同（`alike_iff_alikeTo_pairs`）。这回答了 Becoming.Histories 头注留下的问题：外围的 `same_iff_bisimilar` 对每个动作只有有限多结果的模型成立，证明用经典逻辑。

**判定不能从“判定相同”中去掉。** 对每一对只有一个配置、一个动作而没有主张的框架，判定其配置是否相同，恰是排中律（`alike_decided_iff_em`）：`OneLoop.frame p` 的配置恰在 `p` 成立时有到自身的一步，它与 `OneLoop.frame True` 的配置相同恰当 `p`（`OneLoop.alike_iff`）。

**分支检验看得到选择在何时作出。** `Choosing.late` 与 `Choosing.early` 的起点通过同样的线性检验而不相同（Becoming.Histories）；“第一步可到达一个 `b` 与 `c` 都可取的配置”在前者成立、在后者不成立（`Choosing.branching_apart`）。

**作者反审。**
1. **新律还是重述？** `carries_law_alike_iff` 是新的双向形式（此前记录只有平凡性见证 `carries_unregistered`）；`image_determinedAt_iff` 与 `image_determined_iff` 同证；`dichotomy_of_same_level` 弱化 `determined_dichotomy` 的前提，证明形状相同；`Run.not_fixesThroughAlike_of_untaken` 与 `not_fixesThrough_of_untaken` 同证，干预换成对整个相同类的 `retargetAlike`，两个不同的结果换成在一个主张上不同的两个描述；`alike_iff_sameBranchingTests` 在核心是新的，外围有经典的 `same_iff_bisimilar`，构造性证明是新的；`alike_decided_iff_em` 是边界。
2. **条件是否局部？** `Registers` 与 `GoAlikeUnder` 是对一个等价的一步条件，但右侧对等价作存在量化：以相等时条件只检查 `π` 本身（`GoAlike`），在相同之下要给出一个等价。没有证明存在一个最小的这样的等价。
3. **判定用在哪里？** 判定深度 `k` 的相同、寻找区分的检验、停止的深度三处都用 `FiniteDecided`。由相同到检验不用判定；没有判定时由检验到相同是否成立，这里不知道；判定相同本身需要排中律。
4. **深度的界。** 停止的深度不超过配置对的数目（`AlikeTo.steady_within`）：每一对至多脱落一次，略去它脱落的那一步，其余各对在自己的列表长度之内停止，不另计数。没有证明这个界是最小的。
5. **重复的基础件。** `Decided.exists_listed` 是 `Decided.exists_mem`（Becoming.Decidedness，只对 `Type`）在每个宇宙上的副本，`pairsOf` 对应 Becoming.Standing 的 `pairs`；框架在每个宇宙上陈述，所以保留，可在以后统一。
6. **范围。** 不含伦理谓词；读法是 AI 的，待 Ren。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计 `Becoming.Likeness`，再把三项记录中新的证明引用绑定到新回执；新的 Lean 别名在回执中展开后才通过别名检查。新名称用结构词，不用交换之词。

**落地（2026-10-14）。** 随第四批落地，含 Current math core 的后续（经投影读法在相同之下的形式，停止深度不超过配置对的数目）：核心检查器回执 20261014T091930.724493Z 通过，`Becoming.Likeness` 61 项定理、79 项声明审计，公理报告为空；两项记录对它的引用已绑定。本节留下的两项（去掉判定后等价是否成立；与外围 Test 的桥接）由第 120 节回答。

## 119. 经其识所能学者

2026-10-14。续第 92 与 97 节，同一请求（Ren，2026-10-12：“please, fully complete, 我觉得理更像是对结构和变化的规律的建模 finish wisdom root, and resolve the undissolved”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-learning-wisdom-root-and-induction.md)）。第 92 节作者反审第 8 条留下：按否证学习要求值可判定相等，不分辨值的识（P49 的阈下）不在此列，其上的学习没有陈述；learning-by-refutation 的下一步亦列此项。本节对每个确定律与每个识陈述：经其识，学习者能学到什么。形式按零前提的方向：“Y 当且仅当 Z”，Z 是关于所识者的条件。在工作板上认领为 P106。

```text
Result(s): 新记录 learnable-through-registration；推进 learning-by-refutation（下一步中识不分辨值一项）；
           复用 learning-by-refutation、identification-where-bounded、generalization-through-lumping；
           subthreshold-registration 只作读法，不导入
Delta: 核心新模块 Becoming.Learnable（17 项定理／23 项声明），导入 Identification 与 Seeking，不改既有模块
Supplied premises / correspondence: 无前提；“被列表所持”写进 rests_through 与 learnable_iff 的陈述；所识值的可判定
       相等（DecidableEq R）只作为套索学习者与 withWorld 的条件；目标值的可判定只在 refuted_on_one
Evidence: scratch_build 实编于 main a04727a4：每条声明公理报告为空，无警告；不是回执
Boundary: 与人的学习、神经网络或感知阈限的对应不由此检查；读法是 AI 的，待 Ren
Integration: §9 模块表；Becoming.lean 与 check_becoming.py 的模块列表；章节（第一部分的总陈述、学习一段之后的新段）；
             新记录；可判定性清点
```

**设置。** 配置的识 `reg : S → R`，目标 `val : S → V`；学习者 `pred : List R → Option V` 在由 `s` 出发之轨道的第 `t` 步，从第 `t` 步之前所识的记录作出主张（`course next reg s n = reg (orbit next s n)`，记录即 `Becoming.Learning` 的 `record`）。从第 `T` 步起每步都主张目标，称从 `T` 起在目标上静止（`RestsFrom`）；某个 `T` 存在即静止（`Rests`）。目标是学习者所不识的：主张只从所识的记录作出。

**与识相同者，所学相同。** 所识的未来相同（`Law.SameFuture next reg s s'`，P69）的两个配置，给每个学习者每一步同样的记录（`records_same`）。所以在其目标不同之步，主张至多在一处对，不用判定：

```lean
theorem claim_not_right_on_both (pred : List R → Option V) {s s' : S}
    (same : Law.SameFuture next reg s s') {t : Nat}
    (differ : val (Law.orbit next s t) ≠ val (Law.orbit next s' t)) :
    ¬ (pred (Learning.record (course next reg s) t) = some (val (Law.orbit next s t)) ∧
      pred (Learning.record (course next reg s') t) = some (val (Law.orbit next s' t)))
```

目标值可判定、学习者在那一步作出主张时，主张在一处被否证，而两处的记录处处相同（`refuted_on_one`）：否证不改变所识的记录，学习者不能经记录知道它在哪一处被否证。在两处都静止的学习者，其目标从 `T + T′` 起一致（`agree_of_rests_both`）；所以目标在任意晚处不同时，没有学习者在两处都静止（`not_rests_on_both`）。律使两个配置不变、识不分辨它们而目标不同时即如此（`still_not_rests_on_both`，经 `Becoming.Seeking` 的 `Law.fixed_rests`）。

**可从所识读出者，不被给予什么也学到。** 目标从所识读出（`val s = g (reg s)`）时，读所识之值的套索假设学习者（`Learning.learner Learning.lassos`，其主张经 `g` 读出），在被列表 `l` 所持的世界中从第 `l.length + (2·l.length − 1)·tri l.length` 步起静止（`rests_through`）。这是 P83 的 `held_learner_rests` 经读出 `g`。它不被给予配置、配置的数目或目标的任何值，只需分辨所识的值（`DecidableEq R`）。

**恰当。**

```lean
theorem learnable_iff {next : S → S} {reg : S → R} {val : S → V} {l : List S}
    (world : ∀ s, s ∈ l) :
    (∃ pred : List R → Option V, ∀ s, Rests next reg val pred s) ↔
      ∀ s s', Law.SameFuture next reg s s' →
        ∃ T, ∀ t, T ≤ t → val (Law.orbit next s t) = val (Law.orbit next s' t)
```

从左到右对每个学习者成立，无论它被给予什么（`agree_of_rests_both`）。从右到左的学习者被给予世界与目标（`withWorld`）：读长 `k` 的记录，取 `l` 中第一个长 `k` 的所识记录与之相同的配置，主张它 `k` 步之后的目标。证明用 P83：记录长至 `2·l.length − 1` 时，记录相同恰当所识的未来相同（`Law.sameFuture_iff_below`），此后第一个相符的配置不再变（`firstFit_congr`）；找出它用到所识值的判定。所以这一条件是可学的精确边界：任何学习者都不能越过它，被给予世界者恰到达它。经识同去（`Learning.Lumped reg val`）的目标总满足它（`learnable_of_lumped`）；律使每个配置不变时，可学的恰是经识同去者（`still_learnable_iff_lumped`）。一般的律下可学的多于此：例如目标读出所识的下一值（`val s = reg (next s)`），它不必经识同去，而所识的未来相同的配置其目标处处相同。

**两个不变的配置（`Pair`）。** `Bool × Bool` 上的律使每个配置不变。识第一个坐标时，没有学习者在 `(true, false)` 与 `(true, true)` 两处都在第二个坐标上静止（`Pair.first_not_rests`），第二个坐标不经第一个同去（`Pair.not_lumped`）；识两个坐标时，套索学习者从第 2 步起在每个配置上静止（`Pair.whole_rests`）。

**与已有结果的连接。**
- 第 92 节（learning-by-refutation）：学习者需要分辨的是所识的值，不是目标的值；目标值的可判定只在 `refuted_on_one` 用到。第 92 节反审第 8 条所留的，在识不分辨配置之处的学习，精确条件是 `learnable_iff`；学习者仍须分辨所识的值，这一点不变。
- 第 97 节（identification-where-bounded）：`rests_through` 是 `held_learner_rests` 经读出；`learnable_iff` 的证明用 `Law.sameFuture_iff_below`、`Identification.record_eq_iff` 与 `Identification.firstFit`。
- generalization-through-lumping：在不变的律下，可学的目标恰是经识同去者；推广所经的归并就是识所给的那一个。
- P49 的阈下（subthreshold-registration，读法，不导入）：依存而不观察的条件只以是否满足所需被识（`Web.alike_of_threshold`），阈下的差别保持到支持分岔（`Flow.subthreshold_alike`）。对学习者：阈下的差别，只在它在所识的未来中显现、或从目标中消失之处可学。

**作者反审。**
1. **新律还是重述？** `learnable_iff` 是新的等价。它的必要一侧是 `records_same` 的直接推论（相同的输入给相同的主张），所以简单；充分一侧是 P83 有界辨识的应用。`rests_through` 是 `held_learner_rests` 经 `g` 的重述，不计为独立结果。
2. **充分一侧的学习者被给予世界与目标。** 所以“可学”是存在一个学习者，不是有一个不被给予什么的学习者。不被给予什么的学习者只对从现在所识读出的目标证明（`rests_through`）；条件成立而目标不从现在所识读出时（如 `val s = reg (next s)`），不被给予什么的学习者是否静止，此处没有陈述。
3. **条件是否局部？** 条件关于成对的配置：所识的未来相同者，目标从某步起一致。它不是逐配置的条件。在列表所持的世界中，所识的未来相同可在长 `2N − 1` 的记录上读出（P83），但读出条件需要知道世界。
4. **与归并的等价只在不变的律下。** 一般的律下可学的多于经识同去者（上面的例子）；`still_learnable_iff_lumped` 不推广到每个律。
5. **范围。** 只证明所陈述的律；与人的学习、神经网络、注意或感知阈限的对应不由此检查。

**读法（AI 的，待 Ren）。** 识为所学划界：学习者所能学的，不多于所识的未来所分辨者。依 Ren 的读法，理是对结构与变化之规律的建模（第 92 节）；本节说这一建模经识被学到，正如模型经识被检验（第 70 节）。识之外者，学习不能到达，只能经扩大识到达：新的观察、他者之识，即 P49 中跨过不见的方式。

**检查。** 模块在暂存区以 `scratch_build.py` 对 main `a04727a4` 编译，没有错误或警告；23 项声明（17 项定理）逐条审计，公理报告全部为空；没有禁用的记号。这不是回执。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计 `Becoming.Learnable`，然后把新记录的证明引用绑定到回执；可判定性清点在同一运行后重生成。既有模块的字节不变。若第四批先增加研究的节，本节在合并时改号。

**落地（2026-10-14）。** 随第四批落地：核心检查器回执 20261014T091930.724493Z 通过，`Becoming.Learnable` 17 项定理、23 项声明审计，公理报告为空；check_correction_inquiry.py 回执 20261014T092825.784033Z 通过；新记录 learnable-through-registration 绑定该回执，learning-by-refutation 前进一步；可判定性清点在同一回执上重生成，第一至四批的模块一并分类。本节原写作第 116 节，合并时改为第 119 节。

## 120. 判定不能去掉；有限多结果所需的原则与无穷多结果的反例；核心的分支检验即外围的检验（Becoming.Likeness 与 Becoming.Bridge）

2026-10-14。按 Ren 的“move towards 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)），工作板上“Current math core”的 likeness 一行（其 (i) 项：构造性证明，否则指明所需的原则）与其后的桥接一项，由整合会话批准。本节回答 tests-fix-likeness-where-determined 余下的各项：去掉 `FiniteDecided` 的判定后等价是否成立；配置无穷多而每个动作只有有限多结果时（外围的经典情形）需要什么原则；以及经桥接把 §118 的 `BranchingTest` 与外围 `ExplanatoryBranching` 的 `Test` 对应起来。

```text
Result(s): 改写 tests-fix-likeness-where-determined（新增规律 8–11 与反例 Unbounded）与 configurations-alike-by-relation
           （一条依存说明）；不新增记录
Delta: Becoming.Likeness 新增 EitherStep、EitherClaim、OutcomesListed、EitherThroughout、EitherNever、NowhereDecided、Chains、Unbounded 与三条边界定理
       （模块 109 项定理／146 项声明）；
       Becoming.Bridge 的 Likeness 一节新增 2 个定义、5 项定理（模块 53 项定理／73 项声明）
Supplied premises / correspondence: 无新前提；构造性形式以动作与条件被列出、两个模型的框架为
           FiniteDecided 为条件
Evidence: scratch_build 实编：每条声明公理报告为空，无警告；不是回执
Boundary: EitherThroughout 是否给出 NowhereDecided 或排中律未表明（表明不给出需要核心之外的模型）；像有限时外围的经典证明（same_iff_bisimilar）不在桥接中重述
Integration: §8 状态行与“进一步的证明”；§9 L3 与桥接两行；Becoming.Likeness 头注；三项记录
```

**判定不能从等价中去掉。** §118 表明判定相同需要排中律；等价本身呢？`EitherStep.frame p`：`three` 一步到 `goes`、`halts` 与 `either`，`two` 一步到 `goes` 与 `halts`，`goes` 一步到 `after`，`either` 恰在 `p` 成立时一步到 `after`；没有主张。`goes`、`halts`、`after` 处每个检验是否成立已判定（`settled_decided`）；`p` 成立时 `either` 通过 `goes` 所通过的，不成立时通过 `halts` 所通过的。所以 `either` 所通过的，`goes` 或 `halts` 通过（`either_settles`）：两者都不通过时，由 `p ∨ ¬ p` 得矛盾，而它不能被否定（`not_not_decided`）。于是 `three` 与 `two` 无论 `p` 如何都通过同样的分支检验（`EitherStep.sameBranchingTests`），而它们相同时，`three` 到 `either` 的一步由 `two` 到 `goes` 或 `halts` 相配，即判定了 `p`（`EitherStep.decided_of_alike`）：

```lean
theorem alike_of_sameBranchingTests_iff_em :
    (∀ (S : Type) (F G : Frame S Unit Empty) (s s' : S), (∃ l : List S, ∀ x, x ∈ l) →
        SameBranchingTests F G s s' → Alike F G s s') ↔ ∀ p : Prop, Decided p
```

由右到左是 §118 的 `alike_iff_sameBranchingTests`。主张的判定同样不能去掉：`EitherClaim.frame p` 中步固定且已判定，`either` 恰在 `p` 成立时实现唯一的主张，`marked` 总实现、`unmarked` 从不实现（`alike_of_sameBranchingTests_decided_steps_iff_em`）。

**只列出每个动作的结果时，恰需一个原则。** 配置可以无穷多，而每个配置的每个动作的结果被列出、主张已判定（`OutcomesListed`）。此时深度的相同仍已判定，不成立处仍可构造区分的检验（`OutcomesListed.alikeTo_decided`、`OutcomesListed.apart_of_not_alikeTo`），所以同测推出每个深度的相同（`OutcomesListed.alikeTo_of_same`）。但深度的相同不再在某个深度停止细分；要它是互模拟，须在一步的有限多个结果中找出对每个深度都相同的一个。所需的恰是下述原则（`EitherThroughout`）：

```lean
def EitherThroughout : Prop :=
  ∀ α β : Nat → Prop, (∀ k, Decided (α k)) → (∀ k, Decided (β k)) →
    (∀ k, α (k + 1) → α k) → (∀ k, β (k + 1) → β k) → (∀ k, α k ∨ β k) →
      (∀ k, α k) ∨ (∀ k, β k)
```

即：两个已判定的族，各在下一步成立处于这一步成立，每一步至少其一成立，则其一在每一步成立。由它对列表归纳得出：有限多个候选中每一步至少一个成立时，有一个在每一步成立（`EitherThroughout.list`：第一个与其余两者若都在某步不成立，则在较后的一步一起不成立）。于是深度的相同是互模拟（`OutcomesListed.alikeTo_bisimulation`），同测即相同（`OutcomesListed.alike_iff_sameBranchingTests`）。反过来，对每个这样的框架都成立就给出此原则（`alike_of_sameBranchingTests_outcomes_iff`）：`Chains.frame α β` 中，`two` 一步到两条链的起点，链 `on true` 在 α 成立时前行、`on false` 在 β 成立时前行；`three` 一步到这两个起点与一条总前行的链。一个检验只看到有限深（`Chains.depth`），而每个深度上两条链至少一条前行到那里，所以 `three` 与 `two` 通过同样的检验（`Chains.sameBranchingTests`）；它们相同时，`three` 到总前行之链的一步由 `two` 到某条链相配，那条链的族就在每一步成立（`Chains.throughout_of_alike`）。排中律给出此原则（`EitherThroughout.of_em`）。此原则即 `EitherNever`：两个已判定的族不都在某处成立时，其一处处不成立（`eitherThroughout_iff_eitherNever`；一个方向取“第一个族尚未成立”与“第二个族尚未成立”两族，它们已判定、递减，且每一步至少其一成立，否则两个族都在某处成立；另一个方向，两个递减族在 `k` 与在 `j` 的不成立都推出在 `k + j` 的不成立，与每一步至少其一成立相悖）。`NowhereDecided`，即一个已判定的族是否处处不成立已判定，给出它（`EitherThroughout.of_nowhereDecided`），排中律给出 `NowhereDecided`（`NowhereDecided.of_em`）。某个动作有无穷多结果时，分支检验未必固定相同，证明不需要任何原则：`Unbounded` 中，`bounded` 一步到每个长度的链，`unbounded` 还一步到一条永不终止的链；一个检验只看到有限深，长度足够的链就通过永不终止之链所通过的（`Unbounded.rest_holds_iff`），所以两者通过同样的检验（`Unbounded.sameBranchingTests`），而没有链与永不终止的链相同（`Unbounded.not_alike`）。读法（AI 的，待 Ren）：这一原则按标准名称是较小限定全知原则（LLPO），这里取递减族的形式；`EitherNever` 是它的标准等价形式，即两个已判定存在式的德摩根律；`NowhereDecided` 按标准名称是弱限定全知原则（WLPO）。

**两种检验是同一种。** 外围的 `Test` 有 `top`、`atom`、`neg`、`conj`、`after` 五种构造，核心的 `BranchingTest` 有 `top`、`claim`、`not`、`both`、`can`。`BranchingTest.toTest` 与 `BranchingTest.ofTest` 逐个构造互译，往返都回到原处（`BranchingTest.toTest_ofTest`、`BranchingTest.ofTest_toTest`）。在模型的框架（`Frame.ofModel`：步是模型的过程，主张是模型的条件）中，分支检验恰在其译文在模型中成立之处成立：

```lean
theorem BranchingTest.holds_toTest {m : ExplanatoryBranching.Model S A O} :
    ∀ (φ : BranchingTest A O) (s : S),
      BranchingTest.Holds (Frame.ofModel m) s φ ↔ ExplanatoryBranching.Holds m s φ.toTest
```

所以两边的同测是一回事（`sameBranchingTests_iff_same`）。

**有限、已定的模型上，外围的同测即相同。** 由 §118 的 `alike_iff_sameBranchingTests`：

```lean
theorem same_iff_alike_of_finiteDecided {m : ExplanatoryBranching.Model S A O}
    {n : ExplanatoryBranching.Model T A O} (moves : ∃ l : List A, ∀ a, a ∈ l)
    (conditions : ∃ l : List O, ∀ o, o ∈ l) (finite : FiniteDecided (Frame.ofModel m))
    (finite' : FiniteDecided (Frame.ofModel n)) {s : S} {t : T} :
    ExplanatoryBranching.Same m n s t ↔ Alike (Frame.ofModel m) (Frame.ofModel n) s t
```

这是外围 `same_iff_bisimilar` 在这类模型上的构造性形式。

**作者反审。**
1. **新律还是重述？** `alike_of_sameBranchingTests_iff_em` 与 `alike_of_sameBranchingTests_decided_steps_iff_em` 是新的边界：§118 只表明判定相同需要排中律，这里表明等价本身也需要，且两项判定各自都需要。`alike_of_sameBranchingTests_outcomes_iff` 两个方向都已证明，所以说“恰”：外围 `same_iff_bisimilar` 的情形所用的经典推理，恰可换成 `EitherThroughout`。读法中的标准名称由 `eitherThroughout_iff_eitherNever` 核对：此原则与 LLPO 的德摩根形式等价，不只是名称上的类比。四个见证 EitherStep、EitherClaim、Chains、Unbounded 放在一处，分别表明去掉步的判定、主张的判定、配置的有限、结果的有限各自需要什么。互译与 `holds_toTest` 是同一结构的两种写法之间的桥；新的是 `same_iff_alike_of_finiteDecided`：外围的定理要像有限并用经典逻辑，这里要有限且已定、不用经典逻辑。有限、已定的模型是像有限的（每个配置的后继可由列表与判定列出），所以这里的范围较窄，所得是不用经典逻辑；像有限而无判定时，构造性证明是否存在，仍如 §118 所说开放。
2. **经典的一边为何不写入桥接？** 曾写出 `alike_iff_same_of_imageFinite`（由 `same_iff_bisimilar` 与 `branching_bisimulation_iff` 合成），它依赖 `Classical.choice`；检查器要求脊柱模块（核心与桥接）的每条声明公理报告为空，所以不收入。这一方向在像有限时仍由外围陈述，边界写在 tests-fix-likeness-where-determined 的规律 10 中。
3. **改动的范围。** Bridge.lean 只在 Likeness 一节新增声明与头注一句，已有声明逐字不变；以它为证明来源的其余七项记录（becoming-renewal-reading、becoming-spine-instances、levels-of-closure、one-axiom-yields-g0、open-form-realization-under-revision、ranking-under-readings、wisdom-root）须在落地运行后重新绑定；configurations-alike-by-relation 新增的两条桥接声明也须绑定到回执。
4. **还开放什么？** `EitherThroughout` 是否给出 `NowhereDecided` 或排中律没有表明。表明它不给出是关于核心的元定理，需要核心之外的模型（例如可实现性模型），这里不作。
5. **范围。** 不含伦理谓词；读法是 AI 的，待 Ren。

**边界。** 落地运行须在 `check_becoming.py`（Becoming.Likeness 在核心之列，Becoming.Bridge 在其桥接模块之列）中编译与审计新声明，再重新绑定以 Bridge.lean 与 Likeness.lean 为来源的记录；新的 Lean 别名在回执中展开后才通过别名检查；可判定性清点在同一运行后重生成。对本包暂存运行清点（跳过回执校验），各表与 main 相同：新声明只以 `Decided` 取判定，清点不把它读作可判定族。

**落地（2026-10-14）。** 作为第四批之后队列的第一项落地：核心检查器回执 20261014T100026.593496Z 通过（核心公理报告为空，核心只用前导编译），`Becoming.Likeness` 109 项定理，`Becoming.Bridge` 53 项定理；三项记录对两者的引用已绑定，另七项绑定 Bridge.lean 的记录随之对齐哈希。可判定性清点在同一回执上未变：`Decided` 绑定不被读作可判定族，这一盲点作为单独一项交给 Current math core。

## 121. 线性检验所见：每个分岔推迟到显现时（Becoming.Postponement）；四项读法

2026-10-14。Ren 问 likeness 三项记录的读法与两个原则的名称（[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-likeness-readings.md)），回答后说“push as far as possible, as strong as possible, generally agree with your direction”。

```text
Result(s): 改写 tests-fix-likeness-where-determined（新增规律 12；陈述末句、读法、next_delta），
           determinacy-up-to-likeness 与 configurations-alike-by-relation（读法注明 Ren 同意；next_delta）；不新增记录
Delta: 新核心模块 Becoming.Postponement（导入 Becoming.Histories；16 项定理／17 项声明）
Supplied premises / correspondence: 无新前提；族是配置上的谓词，逐成员比较，不用商与外延性
Evidence: scratch_build 实编（对 main af629fd5 的模块）：每条声明公理报告为空，无警告；不是回执
Boundary: 只陈述线性检验与推迟；分支检验的情形见 §118–§120
Integration: §9 新增一行；Becoming.lean 导入与模块说明；check_becoming.py 的核心之列；三项记录
```

**推迟。** `Frame.postponed F` 的配置是 `F` 的配置之族（`S → Prop`），即一个过程可能已到达者：一个动作从一族走到其成员经此动作的全部结果之族，只要有成员能走这一步；一族实现一个主张，只要有成员实现它。于是没有分岔在它的结果显现之前作出：显现于能走的动作或实现的主张。推迟后的框架不分岔，即处处在相同之下确定（`Frame.postponed_determinedAt`），成员相同的族相同（`Frame.postponed_members`）。

**线性检验即推迟后的相同。** 推迟的框架从一个配置走的过程、过程之后实现的主张，恰是原框架的（`Frame.postponed_trace_one`、`Frame.postponed_tests_one`）；由 §98 的 `alike_iff_sameTests`（两个框架都在相同之下确定时线性检验固定相同）：

```lean
theorem sameTests_iff_postponed_alike {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'} :
    SameTests F G s s' ↔ Alike F.postponed G.postponed (Eq s) (Eq s')
```

**框架恰在不分岔之处与其推迟相同。** 一个配置与其推迟相同，则它在相同之下确定：同一动作的两个结果各与推迟后同一族相同，故彼此相同（`DeterminedAt.of_alike_postponed`）；反之由 `alike_iff_sameTests`：

```lean
theorem alike_postponed_iff_determined {F : Frame S A C} :
    (∀ s, Alike F F.postponed s (Eq s)) ↔ ∀ s, DeterminedAt F s
```

**见证。** `Choosing.late` 与 `Choosing.early` 推迟后相同（`Choosing.postponed_alike`）；`Choosing.early` 与其推迟不同，它第一个动作的两个结果一个能走 `b`、一个不能（`Choosing.early_not_alike_postponed`）。所以线性检验看不到的，恰是展开在何处分岔。

**四项读法（AI 的；Ren 同意此方向）。**
1. 线性检验看不到的是展开在何处分岔，不说“选择在何时作出”：选择暗示一个在展开之外的选择者。
2. 相等是最细的登记，即命名（determinacy-up-to-likeness 规律 1）；需要相等的律需要所登记的（名字、过去的记录、描述的记录），不需要展开的另一个事实。保持的历史只在其过去被登记时是新的。
3. 配置的同一是相同：相对于所实现的；作为关系而不是商；由整个延续固定，所以可超出有限的检验（有限且已定时构造性地固定，只列出每个动作的结果时恰需规律 9 的原则，某个动作有无穷多结果时不固定）。
4. 规律 9 的原则按标准名称是 LLPO，“一个已判定的族是否处处不成立已判定”是 WLPO；两者都不是前提，Lean 名称保持结构性的，“全知”不进入理论自己的词汇；能观察的一侧（检验恰在某个有限深度的相同不成立处区分配置）不需要任何原则。

**作者反审。**
1. **新律还是重述？** `sameTests_iff_postponed_alike` 是新的等价：§98 只给出确定时线性检验固定相同的条件与 Choosing 的反例，这里给出线性检验所见的确切刻画。证明简单，是 §98 的 `alike_iff_sameTests` 用在推迟后的框架上，加上过程与主张的对应；它对应自动机理论中的子集构造（迹等价即确定化后的互模拟），这是熟知的，新的是在核心中构造性地陈述并与 likeness 的记录相连。
2. **“恰”的意义。** 第一条定理说线性检验恰见推迟后的框架；第二条说推迟恰在分岔造成相同之下的差别处改变框架。两者合起来才说“看不到的恰是在何处分岔”；单是第一条只说线性检验与推迟无关。
3. **读法的范围。** Ren 的同意是对方向的同意，记录写作“Ren 同意此方向”，读法仍标为 AI 的。
4. **范围。** 不含伦理谓词。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计 `Becoming.Postponement`，再把 tests-fix-likeness-where-determined 的新证明引用与别名绑定到回执。既有模块的字节不变。

## 122. 外围证明接入脊柱（整合 I1）：像有限模型上同测即相同（以排中律为假设）、目标唯一、自身之善的第二步即剖面上的 N_rel

2026-10-14。Ren：“push as far as possible, as strong as possible, generally agree with your direction - but i also realize - a lot proofs are probably not integrated”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-likeness-readings.md)）。整合会话批准“I”一列（整合），由 Current math core 执行；I1 只取证明模块已由脊柱运行编译的记录。

```text
Result(s): 改写 branching-tests-bisimulation、branching-target-uniqueness、self-good-reachable-g0（脊柱上的陈述、别名、next_delta），
           finite-trace-transport、positioned-positive-reason、positive-ground-open-futures、practical-judgment-g0-j
           （脊柱引用；源码绑定到脊柱运行 20261014T100026.593496Z）；不新增记录
Delta: Becoming.Likeness 新增 5 项定理（114 项定理／151 项声明）；Becoming.Bridge 新增 1 个定义、7 项定理（60 项定理／81 项声明）；
       测量工具 SPINE-INTEGRATION.py
Supplied premises / correspondence: 排中律只作为三项核心定理与两项桥接定理的假设（em : ∀ p : Prop, Decided p）；
           剖面估值把每个剖面计为活的
Evidence: scratch_build 实编（对 main d4321903）：每条声明公理报告为空，无警告；不是回执。可判定性清点在草稿上重跑：
          排中律作为假设 11 → 14，其余各类不变
Boundary: 见下文“边界”
Integration: §9 L3 与桥接两行；Becoming.Likeness 与 Becoming.Bridge 头注；七项记录
```

**测量。** `SPINE-INTEGRATION.py` 读合并检查器的回执，按主张在何处证明给记录分类，并数脊柱运行之外、受版本管理的 Lean 定理（按“文件名、声明名”去重；脊柱运行所编译模块的旧版本不计；只在运行目录、核验历史、来源与快照中出现的另计）。在回执 20261014T100026.593496Z 上：运行编译 138 个模块（核心 95、基础 3、桥接 4、继承 36）。main 上 203 项记录中，按规范来源与别名，146 项在脊柱上陈述，6 项的主证明在继承模块中，41 项在运行之外，10 项没有 Lean 证明；本节之后为 149、3、41、10。较宽的口径，引用某项脊柱证明的记录，148 → 154。运行之外，活路径中有约 11 000 项不同定理、约 540 个模块，另有约 8 000 项只在副本与证据中。最大的几族：universal-ethics（约 2 200 项／104 个模块）、inquiry-root（约 1 800／66）、deeper（约 1 100／71）、general-framework 顶层（约 1 000／50）、connected（约 830／38）、market-generativity/meta-attractor（约 700／22）、本研究目录中的 Lean（约 680／45）、shared-renewal-capability/regulation（约 570／28）、systems-complexity（约 520／27）。这是文本测量，不运行 Lean。

**像有限模型上同测即相同，以排中律为假设。** §120 把外围 `same_iff_bisimilar` 的经典证明留在外围。它所用的只是排中律：以排中律为假设，核心证明凡每一动作的结果都已列出，通过同样分支检验的配置就相同，动作与主张都无须列出：

```lean
theorem alike_of_sameBranchingTests_of_em (em : ∀ p : Prop, Decided p)
    (outcomes : ∀ s a, ∃ l : List S, ∀ t, F.P.step s a t ↔ t ∈ l)
    (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l) {s : S} {s' : S'}
    (same : SameBranchingTests F G s s') : Alike F G s s'
```

同测本身是互模拟：一步的结果若与对方同一动作的每个列出的结果都不同测，各取一项区分的检验（`apart_of_not_sameBranchingTests`，由排中律得出），合起来经 `BranchingTest.apart_from_list` 成一项检验，动作之后它区分两个起点，与同测矛盾。经桥接，外围定理即核心定理在模型上的实例：

```lean
theorem same_iff_bisimilar_of_em (em : ∀ p : Prop, Decided p)
    {m : ExplanatoryBranching.Model S A O} {n : ExplanatoryBranching.Model T A O}
    (fm : ExplanatoryBranching.ImageFinite m) (fn : ExplanatoryBranching.ImageFinite n)
    (s : S) (t : T) :
    ExplanatoryBranching.Same m n s t ↔ ∃ R, ExplanatoryBranching.Bisimulation m n R ∧ R s t
```

于是分支检验固定相同的情形排成一列：有限且已定，不需要任何原则（§118）；动作与主张已列出、只列出每个动作的结果，恰需 EitherThroughout（§120）；动作或主张也不列出，排中律足够（本节）。弱于排中律的原则在最后一种情形是否足够，未表明，记为 branching-tests-bisimulation 的下一步。

**目标唯一。** 相同分离一个框架的配置时，一个配置至多与其中一个相同（`Alike.functional`）；分支检验亦然（`SameBranchingTests.functional`）。检验分离一个模型，恰当核心的分支检验分离其框架（`separated_iff`），所以外围的 `same_functional` 即后者。

**自身之善的第二步即剖面上的 N_rel。** self-good-reachable-g0 的下一步要求“在脊柱上把本路线的剖面模型接到 N_rel 的已形成关系”。`profileValuation s val step` 是以立场的剖面为主张的估值：每个剖面计为活的，一个剖面与一小步之外的剖面相关，有自身的活发生具有它时是自身的，`val` 成立时有意义。容差即其上 N_rel 的中立（`tolerant_iff_neutral`），小步之链即沿相关剖面的可达（`chain_iff_reach_profiles`），随附性下的 S0 即其上的 S0（`selfGood_profiles`），于是外围的 `tolerant_chain_reaches` 由核心的 `Valuation.reaches` 推出（`tolerant_chain_reaches_by_core`）。

**读作脊柱的定义。** 其余四项记录的证明模块由脊柱运行作为继承模块编译，其中各项一般定理在该运行中公理报告为空（`competing_claims_incomparable` 与有限积分的若干定理用到 propext 等，如各记录所列）。桥接表明它们的定义按定义就是核心的（`g0_iff`、`positionedArticulation_iff`、`securesPositiveGround_iff`、`BetterAt`、`robust_iff_commonResponse`），所以这些定理按原样对脊柱的定义成立；脊柱由 Becoming.Significance 的公理推出 positioned-positive-reason 与 positive-ground-open-futures 的中心定理（§6.12 的三项），并有自身的路线（`universal_reason`）。GenerativeCore 是核心所依的基础，finite-trace-transport 的 `trace_map` 本就在脊柱中，此处只补上脊柱运行的绑定。

**作者反审。**
1. **新律还是重述？** `alike_of_sameBranchingTests_of_em` 是经典的 Hennessy–Milner 论证，在核心中以排中律为显式假设陈述；新的是它与 §118、§120 合成一列，并使外围定理成为核心定理的实例。`Alike.functional` 与 `SameBranchingTests.functional` 是两行的推论；`profileValuation` 一组是对应，不是新定理：它说明外围路线的形式就是 N_rel。
2. **“已整合”的意义。** 三项记录（两项分支检验与 self-good-reachable-g0 的第二步）的主张现在是脊柱定理或其在模型上的实例，严格口径 146 → 149。另外四项是“读作脊柱的定义”：定义同一、中心定理在脊柱上由公理推出，但以明示 G0 为假设的形式及最小路线理由、有限积分等仍只在继承模块中证明；它们只进入宽口径。测量起初只用宽口径，把七项“只在继承模块中”的记录列为下一批；按规范来源，这七项（classification-robust-generative-comparison、incidence-common-refinement、multivalued-joining-common-structure、protection-priority-excludes-uniform-aggregation、relational-generative-comparison、renewing-consuming-formation、retained-reference-joining-recovery）的主证明都在运行之外，只是引用了继承模块中的引理，已改正。
3. **剖面估值的读法。** 每个剖面计为活的，关系经过仅仅可能的剖面；脊柱对 `related` 的读法（同一运行中事件对条件的共同参与）不是剖面之间的小步。所以这一对应说明的是路线的形式，不说明剖面之间的小步是展开中已形成的关系；后者仍是对应问题，写进该记录的下一步。
4. **审计的修正。** 只读审计曾把十项记录列为“只需引用”。其中 fallible-witness-diagnosability、growth-constrained-fragmentation、material-preparation-output 的证明模块（FallibleInspection、GrownFragmentation、MaterialMaturation）不在脊柱运行之内，移入 I3。
5. **范围。** 不含伦理谓词的新主张；ethics 记录只增加脊柱引用与绑定。

**边界。** 落地运行须编译并审计改动后的 Becoming.Likeness 与 Becoming.Bridge，再把三个新别名绑定到回执；之后重新生成可判定性清点（`DECIDABILITY-INVENTORY.py`；草稿上排中律作为假设 11 → 14，其余不变）。引用 Likeness.lean 或 Bridge.lean 的十项记录（becoming-renewal-reading、becoming-spine-instances、configurations-alike-by-relation、determinacy-up-to-likeness、levels-of-closure、one-axiom-yields-g0、open-form-realization-under-revision、ranking-under-readings、tests-fix-likeness-where-determined、wisdom-root）所引的声明未变，在回执之后重新绑定。tests-fix-likeness-where-determined 宜增一条规律陈述排中律的情形；它在 §121 的分支中也有改动，留待两者落地之后。

**下一步（I 列）。** I3：主证明在运行之外的 41 项记录所依的模块，以实例或等价定理接到脊柱，先 deeper 的 Explanatory 一族（分支检验、接合、登记）与上面三项。在继承模块中的三项，以明示前提的形式等公理报告为空，可在桥接中按原样重述。I4：活路径中约 540 个模块逐一归类（接入、作为应用保留、或作为历史版本标明并指向取代它的脊柱结果），需 Ren 决定，不删除任何东西。

## 123. 第十七次审查的更正：文字、改名与一处由构造给出的平衡

2026-10-14。开放问题计划第 19 项（Ren 选“yes, one agent”，并说“please, do all”）：一个独立审查代理审查 10 月 13–14 日加入的一般规律，写成[第十七次审查](../history/root-foundation/BECOMING-GENERAL-LAWS-REVIEW.md)（错误 2、言过 3、陈述 2、命名 4、确认 14）。审查只在记录里改了 G1 与 G2 中不改来源哈希的两处；其余改 Lean、研究或章，随本次检查运行一并落地。

```text
Result(s): 改写 finite-aggregation-within-restorable-basic-losses（G1 改名、G6 定律 6）、substitution-preserves-consumption（G3）、
           historical-source-binding（G4）、acquired-revision-of-pending-task（G5）、supported-renewal-recovery（G7、G9）；不新增记录
Delta: 无新定理；改名 6 项（下表）与文档注释；RenewalBridge 的模块说明写明平衡由构造给出
Supplied premises / correspondence: 无新前提
Evidence: 核心与外围检查器重新运行（回执见落地提交）；改名后每条声明的公理报告不变
Boundary: 只改文字与名字；定理陈述不变；G2 已在审查分支改正
Integration: §9 的 Continuation、LossMatching、Retrodiction、ProtocolInstances 行；本研究 §112、§114、§115 与英文摘要；CROSSED-CLAIMS-ARGUMENT
```

**更正。**
1. **G1（错误）。** `not_strictLossMatch_of_base_lost` 的结论是失去共同支持的配置不在任何严格匹配的较好一方，原文“在任何配置之下都没有严格匹配”说反了。改为“经严格匹配不优于任何配置”（§112、§9、CROSSED-CLAIMS-ARGUMENT、两段 `LossMatching` 文档注释、`RepairComparison` 的文档注释与名字）。
2. **G3（言过）。** 替代保持消耗的“恰在”只对“在每一种这样的转化下”成立（`Web.consumingIn_kept_iff`）；记录陈述补上这一限定。
3. **G4（言过）。** 区间律 `bracket_settles_iff` 要求关系取两值、两端控制读数相同；§115、英文摘要、§9 与记录补上这两项条件。
4. **G5（言过）。** `pending_before` 只说更短的运行使任务仍待完成；“更短的运行都不完成”还要待完成与完成互斥（`not_done_before`）。§114、英文摘要、记录与 `Countdown` 的文档注释改正。
5. **G6（陈述）。** “主张在其时刻被读则恢复支持不再实现错过的主张”由 `ReadsAt` 的定义直接给出；记录定律 6 与 §112 写明这一点、引用 `not_readsAt_of_recovery`，并说明实际框架是否在片段时刻读是前提。
6. **G7（陈述）。** 支持门控族作为流的平衡由构造给出：焦点形成的取用被定义为这一步移去的量（`level_succ_le`）；实例的内容是所给的量是更新与净给予、只在受支持处给出（`givers_supported`），以及该族的算术。`RenewalBridge` 的模块说明与记录定律 2 写明。
7. **G8–G11（命名）。** 市场词改为结构词：“降低一级”代替“耗费一级”（`Lasting`）；“净给予”代替“盈余”（`Continuation`、`RenewalBridge`、记录、§9）；“受支持的完成”“仍能汲取”代替“有资金的完成”“仍能支付”（`ProtocolInstances`、其检查器）；“取走储备的一个单位”代替“耗费储备一个单位”（`MarketInstances`、其检查器）。

| 旧名 | 新名 | 模块 |
|---|---|---|
| `RepairComparison.fragile_b3_below_nothing` | `fragile_b3_better_than_none` | 核心 `RepairComparison` |
| `Flow.surplus_raises_at` | `Flow.net_give_raises_at` | 核心 `Continuation` |
| `Flow.surplus_bounded_at` | `Flow.net_give_bounded_at` | 核心 `Continuation` |
| `SupportGated.surplus` | `SupportGated.netGive` | 核心 `RenewalBridge` |
| `SupportGated.surplus_active` | `SupportGated.netGive_active` | 核心 `RenewalBridge` |
| `SupportGated.surplus_step` | `SupportGated.netGive_step` | 核心 `RenewalBridge` |
| `ProtocolInstances.charge_some` | `ProtocolInstances.unit_drawn` | 外围 `ProtocolInstances` |
| `ProtocolInstances.charge_none` | `ProtocolInstances.stalls_unsupported` | 外围 `ProtocolInstances` |

约束变量 `costs`（`Lasting.exhausts`）改为 `lowers`，`surplus`（`Continuation`）改为 `netGive`。

**未改的。** 旧机器保留名字（开放问题计划的选择）；`funded_suffix_publishes` 等原协议定理的名字不变。章与研究中致谢意义上的“credit”未改，列给 Ren。

**边界。** 只改文字、名字与说明；定理陈述与证明不变，所以每条声明的公理报告不变。

## 124. 外围证明接入脊柱（整合 I3a）：二十项记录在脊柱上陈述；部分与结合两个核心模块；五条一般律

2026-10-14。延续 §122 的 I 列（Ren：“push as far as possible, as strong as possible, generally agree with your direction - but i also realize - a lot proofs are probably not integrated”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-likeness-readings.md)）。I3 处理主证明在脊柱运行之外的 41 项记录；I3a 取其中 20 项：它们的主张能写成核心的一般律或核心定义上的定理，外围定理成为其实例。两个代理（Opus 5.5）各起草一个核心模块及其桥接（部分一族、结合一族），本会话起草其余部分并合编。

```text
Result(s): 改写 20 项记录（脊柱引用、别名、历史）：
           relational-generative-comparison、protection-priority-excludes-uniform-aggregation、fulfillment-chance-floor、
           fallible-witness-diagnosability、endpoint-loss-and-return、trace-law-equivalence、derived-history-law-exactness；
           joint-target-uniqueness、joint-decomposition-lifting、joint-code-plan-lifting、exclusive-footprint-support、
           code-plan-global-support；finite-joining-tree-lifting、joining-questions-survive-encoding、
           multivalued-joining-common-structure、functional-joining-common-structure、incidence-common-refinement、
           joining-open-map-factor、unanchored-incidence-collapse、retained-reference-joining-recovery；不新增记录
Delta: 新核心模块 Becoming.Composition（65 项定理／95 项声明）与 Becoming.Joining（71／113），各只导入 Becoming.Likeness；
       新桥接模块 Becoming.CompositionBridge（22／26）与 Becoming.JoiningBridge（33／45）；
       Metaethics 35 → 40、Weighted 35 → 42、Readout 7 → 15、Recurrence 55 → 58、Unfolding 67 → 68；Bridge 60 → 82（105 项声明）
Supplied premises / correspondence: 部分一族三项以“检验稳定”为具名假设（排中律给出）；结合一族三项以排中律为具名假设
           （em : ∀ p : Prop, Decided p）；关联与登记四项在核心的角色框架与保留框架上重述（外围定义编译后用 propext）
Evidence: scratch_build 实编（对 main aee688a0）：改动与新增的 12 个模块、根模块及一个同时导入全部桥接模块的探针，
          每条声明公理报告为空，无警告；不是回执。继承模块 36 → 62，每个的当前字节都有通过的回执（已逐一核对）
Boundary: 见下文“边界”
Integration: §9 六行改动、四行新增；各模块头注；check_becoming.py 的核心与桥接清单；二十项记录
```

**测量。** 在回执 20261014T141427.442103Z 上，`SPINE-INTEGRATION.py`：在脊柱上陈述 149 → 169，运行之外 41 → 21，继承模块中 3，无 Lean 证明 10；较宽口径（引用某项脊柱证明）154 → 173。按落地运行将编译的模块模拟：运行 139 → 169 个模块（核心 96 → 98、桥接 4 → 6、继承 36 → 62），运行之外活路径中的定理约 11 013 → 10 587、模块 541 → 515。

**五条一般律（核心，不加前提）。** 每条都是短证明；新的是外围在具体模型上证明的定理成为它们的实例。
1. **比较所读的描述须区分扩展（Metaethics）。** 若比较 C 读的是描述 `π` 上的非自反关系，则 `π` 区分每一扩展与其基础（`Comparison.separates`）；满足 C 的自然数评分沿无尽的扩展链无界上升，`score s < score (next (score s + 1))`（`Comparison.climbs`、`Comparison.outgrows`）。于是 `strict_comparison_cannot_factor_through_marginals` 是前者的实例：保留耦合扩展了释放耦合，而边缘相同（`strict_comparison_through_marginals_by_core`）；`every_nat_score_trades` 是后者的实例：受保护选项之后，每多一项增益即一扩展（`every_nat_score_trades_by_core`）。
2. **每一权重所见即包含（Weighted）。** 在列出的定义域上，每一权重都不使事件的质量下降，恰当事件被包含（`every_weighting_iff`）：只计一项的权重（`dirac`）在定义域上区分事件。一个权重，即实际展开的机会律，可以看得更少。`ChanceAdequacy` 的质量即核心的（`chance_mass_eq`），`all_weights_preserve_mass_iff` 即此律（`all_weights_preserve_mass_iff_by_core`），兑现的下限是两次 `mass_mono`（`fulfillment_floor_by_core`）。
3. **可错见证者与约化所带的未来（Readout）。** 两答案不同，则没有一份完整报告同时由 `x`（`a` 中见证者出错）与 `y`（`b` 中见证者出错）解释，恰当名册中有不在两者中的见证者（`no_common_report_iff`；容许误集族的形式 `no_common_report_envelopes_iff`）；`FallibleInspection` 的 `complete_diagnosability_iff` 是后者的实例。经约化读出的规律从每一配置的值恰取该配置能取的词，恰当约化只合并未来相同者（`futures_through_iff`），即 `law_through_iff` 的非确定版本；`DerivedHistoryLaw` 的导出规律在容许历史上即经摘要读出的规律（`derived_same_steps`），所以 `exact_iff_fiber_future` 是其实例（`exact_iff_fiber_future_by_core`）。
4. **保留可达即可回（Recurrence）。** 自 `s` 可达的配置自 `t` 都可达，恰当 `t` 可回到 `s`（`keeps_reach_iff_returns`）；沿一路径，可达者相同恰当路径可撤回（`same_reach_iff_returns`）；不能回即失去一可能，`s` 本身是见证（`not_returns_iff_loses`）。`BecomingReversibility` 的两项定理是其实例（`same_endpoint_possibilities_iff_return_by_core`、`irreversible_iff_endpoint_loss_by_core`）。
5. **规律由其轨迹确定（Unfolding）。** 两规律走相同的步，恰当具有两端保留的相同轨迹，单步轨迹即够（`same_steps_iff_traces`）；`DynamicConsequences` 的 `same_steps_iff_endpoint_traces` 即此律。

**部分（Becoming.Composition）。** 联合框架在框架上加一个关系：`joint s l r`，`s` 把 `l` 与 `r` 共同持有为部分。整体与部分是同一展开的配置，不设第二种东西；不假定结合律、次序、单位或部分不重复。联合相同的配置通过同样的联合检验，不加前提；联合检验 `together` 看见部分加入的区分（`Pairing`：两配置相同，只有一个持有一对部分）。移动与部分对紧致、检验稳定处，同测即联合相同（`jointAlike_iff_sameJointTests`）；排中律给出稳定，并使列出的定义域紧致（`jointAlike_iff_sameJointTests_of_listed`）。稳定不能去掉：在部分对紧致的每一框架中“同测者以同测者匹配部分”恰是排中律（`matchesParts_of_compact_iff_em`），“同测即联合相同”亦然（`jointAlike_of_sameJointTests_iff_em`）；见证 `DoubleNegation` 中一部分在命题成立处实现主张，另一部分在命题不能不成立处实现。描述提升部分，恰当其所认同的配置以其所认同者匹配部分（`liftsFromEach_iff`）；嵌套计划经描述实现恰当每一被描述者实现（`JointPlan.realizes_image_iff`）；排他足迹下已实现计划的叶所汲取者不重复并在根的足迹之内（`JointPlan.supports_of_realizes`），反之不成立（`Unjoined.supports_not_realizes`）。

**结合（Becoming.Joining）。** 一结合把两片段关联到它们结合成的片段，多个、一个或没有；不假定任何性质。经伙伴读作框架：描述提升结合，恰当同一编码是伙伴框架的互模拟，不加前提（`Joining.lifts_iff`）；提升处有限结合树逐叶提升（`tree_lifts`），每一分支检验经描述保留（`holds_image_iff`）；核相同且为互模拟的两描述在所用编码上一一对齐（`common_structure`）。函数性结合的伙伴框架是确定的，同测已是相同，无需判定（`common_operation`）。经角色读作框架：结合的开映射即角色框架的开映射（`openMap_iff`）；根相同、每一片段自根可达的两结合有共同细化，无有限也无判定（`common_refinement`）；自一结合的两开映射经其分解，分解在每一片段处唯一（`universal_factor`）；每一片段取每一角色处，所有片段在角色中相同，而片段仍可不能与自身结合（`RoleTotal.collapse`）。经保留引用读作框架：槽数相同的相同配置匹配每一形成路径（`retained_history_matches`），能与自身结合的片段与不能者由一检验区分（`retained_apart`）。`Joining.Once` 是见证：经角色，一次通过与空闲的开始相同；经保留引用，两者分开。

**作者反审。**
1. **新律还是重述？** 五条一般律都是两三行的证明，新的是它们使七项外围定理成为实例，并说明外围的具体构造为何成立：边缘反例与增益反例是 C 对描述与评分的一般要求，机会下限是质量的单调。部分与结合两个模块是新的核心内容：它们给出无前提的提升律（`liftsFromEach_iff`、`Joining.lifts_iff`），外围的经典结论由此加一个具名假设得出；`matchesParts_of_compact_iff_em` 与 `jointAlike_of_sameJointTests_iff_em` 表明外围经典证明所隐含的假设在一般框架上恰是排中律。
2. **“已整合”的三种意义。** 十项是实例，不加假设（本会话七项；`same_target_unique`、`realized_requests_supported`、`unique_common_operational_structure`）；其中 `every_nat_score_trades` 与 `fulfillment_gives_chance_floor` 只重述实质的合取项，平凡的正性项（`0 < score 0 + 2`；`0 < total` 及其假设）不重述。六项加一具名假设：部分一族三项（分解提升、计划提升、全局支持）加“检验稳定”，结合一族三项（树提升、问题保留、多值共同结构）加排中律；外围的经典证明用的正是它。四项（关联共同细化、开映射分解、无锚关联的坍缩、保留引用的恢复）在核心的角色框架或保留框架上重述，不是逐字实例：外围的关联步、答案相同与跨度经带重叠通配分支的匹配定义（登记研究的步经 `xs[i]?`），编译后的定义用到 propext，凡提及它们的陈述公理报告都不为空；桥接表明外围的开映射与局部有限即核心的，`trace_has_units` 与 `open_map_does_not_force_pair_lifting` 逐字重述。与外围不同之处在各记录中写明：分解的唯一性逐点陈述（函数相等需 funext），分解映入相同对而非答案相同的对。
3. **稳定作为假设。** 对外围的具体模型，检验是否不加原则就稳定，未表明；一般框架上不能去掉。较排中律弱的原则是否对较窄一类框架足够，留开。
4. **范围。** 新的核心模块不含伦理谓词、排序或公理；`Comparison.separates` 与 `Comparison.outgrows` 陈述 C 对描述与评分的要求，不断言 C。读法是 AI 的，待 Ren。

**边界。** 落地运行须编译并审计改动的 Metaethics、Weighted、Readout、Recurrence、Unfolding、Bridge 与新增的 Composition、Joining、CompositionBridge、JoiningBridge 及根模块，再把新别名绑定到回执（二十项记录的新别名在此之前为待回执）。桥接新导入的外围模块作为继承模块编译（26 个：RelationalGrounding、ProtectionPriorityRival、ChanceAdequacy、FallibleInspection 及其闭包 AlignmentInquiry、EffectiveCommand、AcquiredCorrection、FaultTolerantCorrection、CorrectionReconfiguration、EvidenceQualifiedCorrection，BecomingReversibility，DynamicSymmetry、DynamicConsequences，ContinuationConditions、DerivedHistoryLaw，ExplanatoryUniversality、ExplanatoryJointness、ExplanatoryFootprints、ExplanatoryJoining、ExplanatoryLocalUnits、ExplanatoryJoiningContexts、ExplanatoryJoiningBranches、ExplanatoryContextualStructure、ExplanatoryJoiningIncidence、ExplanatoryJoiningRefinement、ExplanatoryJoiningAnchors），每个的当前字节已有通过的回执。引用改动的核心文件或 Bridge.lean 的记录，所引声明未变，在回执之后重新绑定。§9 的总数与回执一起更新。第十七次审查之后 F4、F5 所改的八项记录本节不触及。

**下一步（I 列）。** I3b：其余 21 项中能写成核心律的，先 draws-on-a-shared-stock（`Weighted` 中“每一事件在内”的核心律）与 Explanatory 的观测一族；具体构造保留为应用并以桥接引用。I4（约 515 个模块的归类）待 Ren。

## 125. 从关系开始的重建：只用水平的规律、从交换读出的前提、语境中的读法（Becoming.Novelty、Becoming.Reading、Becoming.Readings）

2026-10-14。Ren 问“why do we need "World"? wasn't this about the whole and its parts, about everything?”，又说“no hard role has to be so - right now i think we are trapped by our speculative conditions”；回答提出从关系开始的三步重建之后，Ren 说“please, finish all”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-relation-first-refounding.md)）。这被读作批准全部三步，包括把整体的其余算作关系项（§85 已证它与现行表示等价，采用自 10-11 起由 Ren 定）。回答同时撤回了前一个回答的错误：它曾以 `World.independent`（八个前提各有一个满足其余七个而不满足它的世界）为实质规律不必然的证据。独立性度量的是 `World` 分别选取的八个字段的自由，不是生成的偶然；方法本已说明，较弱模型中可以自由切换的谓词不驳倒完整的说明。

```text
Result(s): 新增 returning-novelty-forgetting-on-levels、premises-read-off-the-exchange、unity-of-readings；
           改写 imbalance-as-relatum（Ren 采用；限制、反例说明与 next_delta）、map-of-premises（不显示的一项：独立性是读法的自由）、
           process-and-frame-as-readings 与 contextual-registration（起点与语境的读法经 Ren 批准；next_delta）
Delta: 新核心模块 Becoming.Novelty（导入 Entropy、Imbalance；19 项定理／20 项声明）、Becoming.Reading（导入 Counterfactual、
       Imbalance、Premises；34／50）、Becoming.Readings（导入 Reading、Context、Boundaries；13／16）：共 66 项定理
Supplied premises / correspondence: 无新前提；每条规律所需的部分的状态（存量在界内、不升、每次变化都下降；交换不止）写在规律之内；
       其余的交换由水平与形成的交换读出，不是观察
Evidence: scratch_build 实编（对 main d8236061 的模块）：每条声明公理报告为空，无警告；落地的核心检查器回执 20261015T143041.527461Z
          通过（107 个脊柱模块、5681 项定理、7961 项声明审计，核心公理报告为空）；外围 CorrectionInquiry 回执 20261015T143127.131125Z
          通过（核心在 Lean 4.30.0-rc2 与 Mathlib 下同样编译）
Boundary: 离散的步与自然数的量；既有模块的字节不变；意义的两条是 Becoming.Boundaries 的重述，不是新结果
Integration: §9 新增三行，Imbalance 一行与术语表写明采用；理论的完整陈述第 1、3 条；第一部分的总陈述；§8；ZERO-PREMISE-PLAN §1.4；
       Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列；七项记录
```

**一、只用水平的规律（`Becoming.Novelty`）。** `Becoming.Entropy` 对平衡且不增益的家族、对第一律之下的有限世界陈述回返、新与遗忘。这里只用水平陈述：任何依存网上，不用流、平衡、损失或世界的有限。每条规律用到部分的一个状态，写在规律之内：存量从某步起在一个界内、从不上升，或每次变化都下降。

- **在界内者回返。** 存量从 `T` 起不超过 `K` 时，构型都在由成员数与总量所定的有限列表 `configurationsWithin` 之内，所以 `Becoming.Recurrence` 的 `revisits_from` 给出：从每一步起都有两步构型相同（`Web.revisits_of_bounded`）；不升的存量以 `T` 处为界（`Web.revisits_of_nonrising`）。不断变化时，“从不重访”不成立（`Web.returns_of_bounded`；重访不可判定，所以以否定的否定陈述）。
- **只有增益者是新的，等待有界。** `T` 到 `T + N` 各步的构型两两不同、`N` 是总量至多 `K` 的构型数时，其中某一步存量超过 `K`（`Web.exceeds_of_new`）：逐步核对这有限多步的存量是否至多 `K`，全部至多则鸽巢给出两步相同；只判定有限多个自然数不等式，不判定任何无穷的事。所以每步都新的家族在任意晚处超出每个界（`Web.unbounded_of_new`），不断变化而从不重访的家族不在任何界内（`Web.unbounded_of_never_revisits`）。每步都新是可能的：`Web.counting` 中水平就是步数（`Web.counting_new`、`Web.counting_gains`）。
- **在界内者遗忘。** 有限多构型之上的读数给不出从不重复的记录（`Web.unread_of_new_record`），也给不出无界的计数（`Web.unread_of_unbounded`：读数在那个有限列表上的总和加一就是界）。所以在界内、在任意晚处被交换的家族，其构型不承载其交换的计数，不论流如何（`Flow.uncarried_of_bounded`）；对整体，在有限多关系项就是全部时亦然（`World.forgets_of_bounded`）。
- **损失使回返成为停止。** 存量不升、每次构型变化都下降时，家族从不重访（`Web.never_revisits_of_loses`），任一段上变化的次数加终点的存量不超过起点的存量（`Web.changes_le_stock`），变化不无尽复现（`Web.rests_of_loses`）。
- **早先的形式是情形。** 平衡且不增益时，存量以 `T` 处为界（`Flow.Balances.bounded`）；以此为界，上面的规律给出 `Becoming.Entropy` 的 `Flow.Balances.recurs`、`Flow.Balances.rests_of_never_revisits` 与 `World.forgets`（`first_law_cases`，一条定理检查这三处）。算入其余时不设平衡：算入其余仍不增益的家族以 `T` 处的存量为界（`Flow.bounded_counting_rest`）。

```lean
theorem Web.exceeds_of_new {T K : Nat}
    (new : ∀ i j, i < j → j ≤ (configurationsWithin cs.length K).length →
      W.config cs (T + i) ≠ W.config cs (T + j)) :
    ∃ n, n ≤ (configurationsWithin cs.length K).length ∧ K < W.stock cs (T + n)

theorem World.forgets_of_bounded {all : List w.Relatum} (every : ∀ x, x ∈ all) {T K : Nat}
    (bound : ∀ t, T ≤ t → w.web.stock all t ≤ K) (exchanging : w.flow.ExchangeRecurs) :
    ¬ w.flow.CarriesHistory w.web all T
```

**二、从交换读出（`Becoming.Reading`）。** 依存网对一次交换有五种读法：水平、活跃、要求、所需与汲取。八个前提中有四个把这些读法联系到交换或彼此联系；这里从交换读出它们，使联系由读法成立。

- **活跃与汲取从交换读出。** 一个形成跨一步交换，当它参与并对某个条件有所取或有所给（`Flow.Exchanging`）。从流读出的网（`Flow.readOff`）以所给的水平、要求与所需，把活跃读作交换、把汲取读作所取。这样读，只有活跃者给予（`Flow.readOff_acting`），只有活跃者取用且只取其所汲取的（`Flow.readOff_taking`），对每个流成立。对任何网，这两个前提恰在其活跃与汲取包含从交换读出者时成立（`Flow.acting_taking_iff_wider`）。参与者列出一次、交换可判定时，每步活跃的关系项被列出（`Flow.readOff_census`）。
- **算入其余。** 把整体的其余算作关系项 `none`（`Flow.withImbalance`），并从交换读出活跃（`Flow.adopt`）：每个流都平衡（`Flow.adopt_balances`），只有活跃者给与取（`Flow.adopt_acting`、`Flow.adopt_taking`），原来的形成交换如故（`Flow.exchanging_some_iff`），有普查（`Flow.adopt_census`）。平衡不再被设：流跨一步平衡恰当其余在那一步不活跃（`Flow.rest_idle_at_iff`），处处平衡恰当其余从不活跃（`Flow.rest_idle_iff`）；活动需要支持恰当每个交换的形成都被支持（`Flow.adopt_dependent_iff`）。
- **每个世界算入其余。** `World.withRest` 的关系项是世界的与其余；活跃与汲取从算入其余的交换读出，所立、要求与所需是世界的。于是每个世界都平衡（`World.withRest_balanced`），只有活跃者给与取（`World.withRest_acting`、`World.withRest_taking`），世界的关系项交换如故（`World.withRest_exchanging_iff`）；世界平衡恰当其余从不活跃（`World.withRest_closed_iff`），活动需要支持恰当每个交换的关系项都被支持（`World.withRest_dependent_iff`）。
- **要求从律读出。** 在交换之律（`ExchangeLaw`）之下，一个形成跨一步的交换回应某个条件低于所需，当在每个只在该条件该步的水平上与实际不同、且那个水平低于所需的历史之下，它都不交换（`ExchangeLaw.RespondsBelow`）。读作要求，交换的形成就被支持：实际的历史是那些历史之一（`ExchangeLaw.supported_of_responds`）。所以律生成的历程读出的网（`ExchangeLaw.readWeb`）对每个所需满足活动需要支持（`ExchangeLaw.readWeb_dependent`），算入其余时四个联结前提都不用前提（`ExchangeLaw.reading_glue`；对一类关系项的世界，`ExchangeLaw.readWorld`、`ExchangeLaw.readWorld_glue`）；律读已立者时，其余从不活跃恰当历程可行（`ExchangeLaw.rest_idle_iff_feasible`、`ExchangeLaw.readWorld_closed_iff`）。
- **要求不在历程中。** `ExchangeLaw.responsive` 与条件所立者交换一个单位，`ExchangeLaw.unresponsive` 不论所立者都交换一个单位。从同一起点，两者生成同一历程：每一步水平相同、交换相同；从律读出，前者每一步都以所需一要求其条件，后者没有一步要求（`ExchangeLaw.requirement_beyond_course`）。要求是律的反事实，没有历史固定它。

```lean
theorem World.withRest_closed_iff : (∀ t, ¬ w.withRest.web.active t none) ↔ w.Balanced

theorem ExchangeLaw.readWorld_glue :
    (law.readWorld present start need).withRest.Balanced ∧
      (law.readWorld present start need).withRest.Acting ∧
      (law.readWorld present start need).withRest.Taking ∧
      (law.readWorld present start need).withRest.Dependent
```

**三、语境中的读法（`Becoming.Readings`）。**

- **一个展开的诸读法是一个世界。** 沿一个运行，语境系统（`Contextual`）的诸识，每个主张连同其语境，是一个世界的关系项，恰在以其值被识处活跃（`Contextual.world`、`Contextual.world_active`）；如 `Frame.world`，其中没有什么立着或被交换。不用粘合，所以在不可能有不依语境的值处也成立，如 Mermin–Peres 方阵与量子的识（`Square.no_whole`、`Becoming.Quantum` 的 `no_context_free_values`）。
- **不依语境的描述是粘合。** 不依语境的主张的框架恰在诸识于每个配置粘合时相合（`Becoming.Context` 的 `Contextual.fitsFree_iff`）。
- **平衡是两种变化读法的粘合。** 一个条件跨一步的变化由所立读作水平的升与降，由交换读作流给它超出所取的与取它超出所给的（`Flow.changeReadings`）。两者把变化读得一样，恰当水平与交换在那里平衡（`changes_agree_iff`）；所以两种读法跨一步粘合恰当流在那里平衡（`Flow.changeReadings_glue_iff`），处处粘合恰当流平衡（`Flow.changeReadings_glue_everywhere_iff`），不依语境的变化主张的框架恰在此时相合（`Flow.changeReadings_free_iff`）。算入其余时处处粘合（`Flow.changeReadings_glue_counting_rest`）：其余的交换就是两种读法之差，算作关系项。
- **每个世界都是交换之律的一次运行。** 算入其余（`World.withRest`），每个世界的两种变化读法处处粘合，世界自己的读法恰在它平衡处处处粘合，那恰是其余从不活跃之处；世界是交换之律的一次运行，其所立是世界的（`World.unity`）。`World.exchangeRun` 需要平衡；算入其余则不用前提。
- **意义以同样的标准。** `Becoming.Novelty` 的规律对每个部分成立，不论部分怎样划。以同样的标准，自身的延续有意义这一预设应当不论自身的边界怎样划都成立（`BoundaryInvariant`）。如此时，预设在边界划于某处时成立，恰当从那个立场一切的延续都有意义（`presupposition_iff_all_of_invariant`，`Becoming.Boundaries` 的 `boundaryInvariant_iff_conditional` 的重述），一个延续缺少意义时预设不成立（`not_subTrue_of_invariant`）；以含有自身闭包的区域为界的对手，恰在区域是一切时满足这一标准（`bounded_invariant_iff`，`boundaryInvariant_iff_all` 的情形）。所以在这一标准下没有意义停在边界上：从一个立场，在某个边界内成立就是对一切成立。这两条把 `Becoming.Boundaries` 已检查的结果重述为这个两分，不是新结果。

```lean
theorem World.unity (w : World) :
    (∃ r : Run (exchange (Option w.Relatum)), ∀ t x, r.state t (some x) = w.web.level t x) ∧
      (∀ t, (w.withRest.flow.changeReadings w.withRest.web).Glues t) ∧
      ((∀ t, (w.flow.changeReadings w.web).Glues t) ↔ w.Balanced) ∧
      (w.Balanced ↔ ∀ t, ¬ w.withRest.web.active t none)
```

**读法（AI 的，待 Ren；把其余算作关系项是 Ren 2026-10-14 的采用）。**
1. **部分的状态，如曲率是区域的状态。** 每条规律对任何有水平的生成成立，它所用的每个条件都是它所说的那个部分的状态。依 Ren 的“non-Euclidean”：平行公设成了曲率，必然的规律不需要必然的条件。
2. **回返、新与遗忘。** 回返是有界的部分所做的；新而不止是无界的增益，必须来自部分之外；有界的当下不能承载自身的历史；每次变化都损失时，变化在至多与单位一样多的变化之内结束。
3. **联结与状态。** 平衡、只有活跃者给予、只有活跃者取用其所汲取的、活动需要支持，把一次交换的诸读法联结起来：从交换读出、算入其余、把要求读作交换所回应的，它们由读法成立。余下的是部分的状态：其余是否闲置（封闭，对一条律即可行）、耗散（损失）、体现（关系项恰在立着时交换；立着而不交换者休眠）、有界传递，以及列出活跃者所需的判定。`World.independent` 的独立性是分别选取的读法的自由：它为这四个前提给的见证中，一个读法被选得与它所读的交换不符。
4. **一个展开。** 核心在许多类型上陈述的（流、网、世界、过程、框架、语境系统）是一个展开的读法。一个读法是一个语境；诸读法相合处，不依语境的描述是它们的粘合，`World` 是这样的描述。一般的情形是语境中的读法，总是一个世界的被索引的主张。平衡说所立与交换把一次变化读得一样；算入其余就是把两种读法之差算作关系项，于是每个世界都是那一条交换之律的一次运行。原来世界的一个前提，现在是一个部分的状态：其余是否闲置。
5. **公理。** 第二部分的公理不是规律旁边的又一条规则。在规律所满足的不变之下，意义从一个立场在某个边界内成立只因对一切成立，公理归于那个预设：自身的延续在自身被划在某处时有意义，即 Ren 2026-10-10 所说自身“can not justify itself without some sort of "belief"”的那个 belief。

**作者反审。**
1. **新律还是重述？** `Becoming.Novelty` 推广 `Becoming.Entropy` 的回返、静止与遗忘：去掉平衡、第一律与世界的有限，代之以部分的存量之界；证明复用 `Becoming.Recurrence` 的 `revisits_from`、`revisits_within` 与 `Becoming.Entropy` 的 `config_within`、`configurationsWithin`，`first_law_cases` 检查早先三条是其情形。新的内容是 `Web.exceeds_of_new` 的有界等待（不判定任何无穷的事）、`Web.unread_of_unbounded`（不需平衡的遗忘）、`Web.changes_le_stock`（变化的计数界）与 `World.forgets_of_bounded`（整体的遗忘不用世界的前提）。`Becoming.Reading` 的 `readOff` 与 `adopt` 是定义，平衡与只有活跃者给与取由读法得到，几乎是定义上的；内容在三处：`Flow.acting_taking_iff_wider` 说这两个前提恰是“活跃与汲取包含从交换读出者”；`Flow.rest_idle_iff` 与 `World.withRest_closed_iff` 把平衡变成一个部分的状态；`ExchangeLaw.supported_of_responds` 与 `ExchangeLaw.requirement_beyond_course` 说要求读作回应时活动需要支持成立，而要求不由历程固定，这是实质的区分，不是定义上的平凡。`Becoming.Readings` 中 `changes_agree_iff` 是自然数截断减法的算术事实，`Flow.changeReadings_glue_iff` 把平衡读作粘合，`World.unity` 是汇集，意义的两条是重述。
2. **“由读法成立”是不是把前提藏进定义？** 是把前提从对世界的假设移到读法的选择，这正是要说明的：在分别选取字段的表示中，这些前提能不成立，因为一个读法可以与交换不符；在从交换读出的表示中，它们不能不成立。它们不成立之处不是生成的偶然，而是读法彼此不符。没有证明的是：实际的生成应当这样读。这是表示的选择；把其余算作关系项已由 Ren 采用，活跃读作交换也是读法的选择，体现把它与立着联系起来。
3. **其余是什么？** 其余的交换由水平与形成的交换之差读出，不是观察：算入它，关于交换不增加信息。所以“每个流都平衡”不是物理的守恒律，而是把不平衡记作一个关系项的交换；平衡原来对世界所说的，改由“其余是否闲置”来说（`Flow.rest_idle_iff`）。
4. **`Contextual.world` 的“一个世界”。** 它的关系项是被索引的主张，活跃即被识，其中没有什么立着或被交换；它说诸读法总在一个世界中有位置，不说它们组成一个有流与依存网的世界。后者恰在读法粘合、得到 `World` 时才有。
5. **独立性的更正。** 前一个回答以 `World.independent` 为实质规律不必然的证据，这一点已撤回；map-of-premises 增加一项“不显示”。
6. **范围。** 不含伦理谓词；意义只作为定理所量化的谓词出现。离散的步与自然数的量仍是表示的承诺；连续时间与实数的量没有陈述。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计三个新模块，再把三项新记录与改写的记录绑定到回执。既有模块的字节不变；`Becoming.lean` 只加导入与说明，并在 Imbalance 一项写明采用。

## 126. 有界记录的长度对每一对界恰好（P83b）

2026-10-15，P83 自己的下一步（[identification-where-bounded](../../../../theories/becoming/results/records/identification-where-bounded.md) 的 next_delta 第一项），按 Ren 2026-10-12 06:01 的“keep prove to the deepest … for the open questions, if they need to be answered to move forward, answer them”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）。§97 证明：至多 N 与 N′ 个状态的两段所识的历史，在 N + N′ − 1 之前相同就处处相同（`bounded_agree`），但更短的不够只在 N = 1（`record_short`）与 N = N′（`record_short_twice`）时证明。本节对每一对界证明更短的不够。`Becoming.Identification` 增加一项定理，不加导入，不改已有声明；不加公理，除了两个界与两个不同的值不加前提。工作板上认领为 P83b。

```text
Result(s): 复用 identification-where-bounded（Identification.lassoPos_early、lassoPos_period、periodic_whole、mark、
           statesBelow_iff_lasso、record_eq_iff）；learning-by-refutation（Learning.holdFrom、holdFrom_before、
           holdFrom_after、holdFrom_lasso、Lasso、record、lassoNext）；recurrence-without-premise（Law.orbit、gap_of_le）；
           不新增记录
Delta: Identification.bounded_agree_exact
Supplied premises / correspondence: 不加公理；两个不同的值；两个界写在定理中（StatesBelow o (M + 1)、StatesBelow o' (M' + 1)）
Evidence: scratch_build 对 main 69ba40bd：Becoming.Identification 43 项定理、55 项声明，公理报告全部为空；合并检查器回执待整合者的运行
Boundary: 只陈述两段历史各有其界；同一历史的两个时刻、同一世界的两个配置的更锐的界（Moore）没有陈述；有分支的框架下以类的数目为界的
          深度没有陈述；不含伦理谓词
Integration: identification-where-bounded 的恰好性由“只在 N = 1 与 N = N′”扩展到每一对界，next_delta 的第一项完成
```

| 声明 | 内容 |
|---|---|
| `Identification.bounded_agree_exact` | **对每一对界，长度 N + N′ − 1 恰好。** 给出两个值，对每个 M、M′，有至多 M + 1 个状态的历程与至多 M′ + 1 个状态的历程，长 M + M′ 的记录相同而在第 M + M′ 步不同。前者以周期 M + 1 标记，标记放在第 M + M′ 步，所以第 M′ 到 M + M′ − 1 步都不标记；后者在第 M′ 步之前随前者，从第 M′ 步起不标记。M = 0 时是 `record_short` 的陈述，M = M′ 时是 `record_short_twice` 的陈述 |

**它回答了什么。** 至多 N 与 N′ 个状态的两段所识的历史，长 N + N′ − 1 的记录确定它们（`bounded_agree`）；对每一对界，长 N + N′ − 2 的记录都不确定（`bounded_agree_exact`）。所以这个长度不是证明方法的产物，而由两个界本身给出：记录少一步，就有两段都在界内的历程分不开。分不开的两段并不特别：一段循环，一段停下。两者在第 M′ 步之前相同；之后一段继续循环，到循环的标记处才标记，另一段停在不标记处。最晚的分歧在一个循环之后。把两个系统合起来看（至多 N + N′ 个状态），这正是 Moore（1956）的界，这里它对每一对界都被达到。

**作者反审。**
1. **已知的结果。** Fine 与 Wilf 的极值构造在两个周期互素时给出纯周期的情形；这里用一个周期历程与一个最终常值的历程，对每一对界都成立，构造更简单。两个自动机等价所需观察长度的恰好性在自动机理论中已知。增量是：在核心中不用公理陈述，并与 §97 连成一体。
2. **只对两段各有其界的历史。** 同一历史的两个时刻（`sameAhead_iff_below` 用 2N − 1）、同一世界的两个配置，界更锐（Moore：N − 1 步的观察），没有陈述。有分支的框架上，`Becoming.Likeness` 给出以配置对的数目为界的深度（`AlikeTo.steady_within`），以类的数目为界的更锐的深度没有陈述。
3. **两个值。** 只有一个值时一切历程相同；定理以两个不同的值为条件，与 `record_short`、`record_short_twice` 相同。

**检查。** 在暂存区对 main（69ba40bd）编译：`Becoming.Identification` 43 项定理、55 项声明，没有错误或警告，公理报告全部为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。证明不用 `Nat` 的取模与减法引理：标记的位置由 P73 的套索世界（`lassoPos_early`、`lassoPos_period`）与 `periodic_whole` 给出，移位 M·M′ 使第 M′ 步落在循环的开头。合并检查器在整合者的运行中检查。本节尚未经独立审查。

## 127. 外围证明接入脊柱（整合 I3b）：九项记录接入；语境中的规律、共同实现的界与粒度

2026-10-14—15。延续 §124 的 I 列（Ren：“push as far as possible, as strong as possible, generally agree with your direction - but i also realize - a lot proofs are probably not integrated”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-likeness-readings.md)）。I3a 之后主证明仍在脊柱运行之外的 21 项中，I3b 取能写成核心律或接到核心定义的 9 项；另有 2 项因桥接的新导入而由运行编译。粒度一族的核心模块由一个代理（Opus 5.5）起草，代理在写桥接之前因用量上限中止；机器重启清空临时目录后，该模块由代理的记录逐字重放重建（定理数与其构建一致），本会话审阅、写头注并编桥接。本会话其余的改动由 git 中留下的暂存提交恢复。

```text
Result(s): 改写 9 项记录（脊柱引用、别名、历史）：
           becoming-context-coherence、effective-capacity-and-eventual-reachability、classification-robust-generative-comparison、
           finite-granularity-question-recovery、guarded-program-question-recovery、residual-continuation-correspondence、
           prefix-observation-loss（在脊柱上陈述）；derivation-soundness、finite-basis-common-interpretation
           （由继承模块编译并经桥接接到核心的 Scope）；不新增记录
Delta: 新核心模块 Becoming.Granularity（86 项定理／120 项声明，导入 Becoming.Joining 与 Becoming.Segmentation）；
       新桥接模块 Becoming.GranularityBridge（39／41）；Context 28 → 46、Recurrence 58 → 63、Weighted 42 → 44；
       Bridge 82 → 113（137 项声明）
Supplied premises / correspondence: 分类稳健比较的反向以排中律为具名假设（em : ∀ p : Prop, Decided p），并证明恰需排中律；
           粒度一族中跨粒度、条件程序与部分历史的匹配以 em 为具名假设，把每个配方读作单一检验恰是排中律；
           两项见证在核心的 Midway 框架上重述（外围的见证模型编译后用 propext）
Evidence: scratch_build 实编（对 I3a 加本节改动，184 个模块，含一个同时导入全部桥接模块与根模块的探针）：
          改动与新增模块的每条声明公理报告为空，无警告；不是回执。继承模块 62 → 74，每个的当前字节都有通过的回执（已逐一核对）
Boundary: 见下文“边界”
Integration: §9 四行改动、两行新增；各模块头注；check_becoming.py 的核心与桥接清单；根模块；九项记录
```

**测量。** 以落地运行将编译的模块模拟回执，`SPINE-INTEGRATION.py`：在脊柱上陈述 169 → 176，继承模块中 3 → 7，运行之外 21 → 10，无 Lean 证明 10；较宽口径（引用某项脊柱证明）173 → 180。运行 169 → 183 个模块（核心 98 → 99、桥接 6 → 7、继承 62 → 74），运行之外活路径中的定理约 10 587 → 10 441、模块 515 → 503。继承模块中新增的四项里，organizational-formation-from-generative-comparison 与 wisdom-root 的主证明随 ClassificationRobustJudgment 与 GenerativeClosure 的导入闭包进入运行，这两项记录本身未改。

**语境中的规律（Context，不加前提）。** 对有居民的规律族，合并的规律恰走某单一语境所走的路径，恰当这些路径对接合封闭（`pooledLaw_exact_iff_joinClosed`）；保留语境的规律恰走这些路径（`retainedLaw_trace_iff`、`retainedLaw_realizes_inOne`）；语境与配置一同变化时，遗忘语境的规律从每一语境恰走演化规律的路径，恰当每一语境能跟随每一被遗忘的步，即基础的 `projection_exact_iff` 沿 `Prod.snd` 读出（`erasedLaw_exact_iff_lifts`）；路径到达的语境逐步推进（`arrives_append`、`arrives_snoc`）。见证 `CrossingContexts`（合并出无单一语境走的路径）与 `ChangingContext`（语境在一条路径中改变，路径终止）。`BecomingCompatibility` 的定义按定义即核心的；核心证明 `changed_history_really_ends` 不用外围证明所用的 propext。

**共同实现的界（Recurrence，不加前提）。** 一组主张在 n 步内共同实现，指至多 n 步的路径终于实现其每一主张的配置（`WithinMoves`）；路径携带每一这样的界并计入自身步数（`WithinMoves.after_course`）；有界恰当可达某实现该组的配置（`withinMoves_iff_reach`），故沿路径不出现此前不能共同实现者（`together_after_reach`），不再能共同实现的组标出无回路的路径（`lost_together_not_returns`）。`RelationalBecoming.Within` 按定义即 `WithinMoves`。在 `JointContinuationClassification` 的共同激活规律上，一步准备把共同激活的界自两步缩为一步，解除耦合后任何界都不能，所准备的配置可单侧终止，解除无回路（`actual_preparation_changes_effective_capacity_by_core`、`actual_release_loses_eventual_joint_by_core`、`prepared_capacity_can_end_without_joint_realization_by_core`、`release_not_returns`）；这些证明不用外围所用的 propext 与 Quot.sound。

**分类稳健的比较（Bridge）。** 前向（各分类下严格偏好推出保留新内容、以新内容为次级时更好）不需任何原则（`compared_retains`、`compared_secondary`）；反向以 em 证明（`classification_robust_iff_of_em`、`two_extremes_suffice_of_em`），且对一切类型成立恰当每一命题已定（`classification_robust_iff_iff_em`）：见证取一个新内容，其在 b 处的保留是任意命题 R。比较仍是 PracticalJudgment 的 Better，即核心的 `BetterAt`。

**推出与共同解释（Bridge）。** 读作核心的 `Scope`（策略的实际执行自信念所达的配置）：自在 Scope 上成立的根基推出的主张在 Scope 上成立，整个闭包恰在根基成立处成立（`derivation_sound_on_scope`、`closure_over_scope_iff_basis`），自健全策略的目标推出者在其 Scope 上成立（`sound_goal_closure`）；根基有限时，推出的每一主张在 Scope 中某处实现，恰当 Scope 中一个配置实现全部（`common_on_scope_iff`）。健全性与共同解释的归约仍是外围的定理，不在核心中重述。

**粒度（Becoming.Granularity）。** 块是同一展开的有限路径（`Frame.blocks`）；块的每个检验都是较细检验，在相同配置成立，不加前提（`Frame.holds_blocks`）；较细粒度上相同或同测者在块中亦然（`Alike.blocks`、`SameBranchingTests.blocks`）；每个较细动作自成一块时块的检验恢复较细检验（`Frame.blocks_sameBranchingTests_iff`，充分非必要）。以另一粒度读同一展开的一般律：两框架的检验各自译入较细框架、译文在两配置处一致、接收侧每步的结果列出时，前者的每段历史由后者以相同步匹配，终点译文仍一致（`Translates.history_matches_of_em`，em 具名）；列出的结果给出每段有限路径的终点，不用选择（`outcomes_of_trace`）。配方在到达处选择：配方是否通向某检验成立之处，恰是有限多个分支检验之一成立，不加前提（`Recipe.leads_iff_afterAny`），所以同测者对每个配方问题回答相同（`SameBranchingTests.leads_iff`）；把配方读作单一检验（经否定与合取）在检验已定处精确（`Recipe.holds_after`），对每个框架都精确恰是排中律（`Recipe.holds_after_iff_em`）。余项：部分执行留下的配方在路径所在处续行，执行到底恰是不留余项的部分路径（`Recipe.leads_iff_leaves`）；自相同配置的部分路径相匹配，保留余项，不加前提（`Recipe.Leaves.alike`）；插入的动作与部分路径及续行接成一条路径，而不是配方的一部分（`Recipe.Leaves.inserted`）。见证 `Midway`：完整块与每个非空前缀的块都把 risky 与 safe 读作相同（由互模拟，不加前提），而中途失续是实在的，前缀的检验无一读出它（`Midway.no_prefix_reading`），在所到达处开放后缀即恢复区别（`Midway.resumption_recovers_loss`）；同一起点在同一配置留下不同余项，任何对续行精确的描述都区分它们（`Midway.remainder_codes_apart`）。

**作者反审。**
1. **新律还是重述？** 语境中的规律与共同实现的界是新的一般律，外围定理成为其实例；粒度是新的核心内容。较外围为强之处：`same_preserves_resumption` 外围以经典推理证明，核心不加前提（续行问题读作有限多个检验而非一个）；`finite_trace_endpoints` 与 `blocks_image_finite` 外围用经典选择，核心不用；`changed_history_really_ends` 与共同激活诸定理外围用 propext（与 Quot.sound），核心不用。
2. **排中律在何处、是否必要。** 分类稳健比较的反向，与把每个配方或条件程序读作单一检验，对一切模型各自恰是排中律（`classification_robust_iff_iff_em`、`Recipe.holds_after_iff_em`、`diamond_correct_iff_em`），所以外围的经典用法在一般框架上不能去掉。跨粒度、条件程序与部分历史的匹配以 em 把同测接到逐步匹配（经 `SameBranchingTests.step_of_em`），其必要性未表明；自相同配置出发则不需要（`Recipe.Leaves.alike`）。
3. **“已整合”的意义。** 七项在脊柱上陈述：语境、共同实现的界与粒度的三项是实例（外围定理按陈述成立，有的加具名 em）；prefix-observation-loss 与 residual-continuation-correspondence 的见证在核心的 Midway 上重述，未证明与外围模型的对应：外围的 `ExplanatoryGranularityBoundary.unfolding` 以带重叠通配分支的匹配定义，编译后用 propext，凡提及它（及 `ExplanatoryResumptionCases.answer`）的陈述公理报告都不为空。derivation-soundness 与 finite-basis-common-interpretation 只是由运行编译并接到核心的 Scope，健全性与归约本身未在核心中重述。

**边界。** 落地运行须编译并审计改动的 Context、Recurrence、Weighted、Bridge 与新增的 Granularity、GranularityBridge 及根模块，再把新别名绑定到回执（九项记录的新别名在此之前为待回执）。桥接新导入的外围模块作为继承模块编译（12 个：BecomingCompatibility、RelationalBecoming、ClassificationRobustJudgment 及其闭包 RelationalOrganization、ConcernExtension，JointInterpretation 及其闭包 GenerativeClosure，ExplanatoryGranularity 及其闭包 ExplanatoryJoiningRegisters，ExplanatoryGuardedPrograms、ExplanatoryResiduals、ExplanatoryGranularityBoundary），每个的当前字节已有通过的回执；ExplanatoryResumptionCases 不进入运行。引用改动的核心文件、Bridge.lean、章或研究的记录，所引声明未变，在回执之后重新绑定。§9 的总数与回执一起更新。

**下一步（I 列）。** I3c：外围实例模块（照 VersionedTaskInstances 的方式，各有检查器）写 draws-on-a-shared-stock 的实例与依 Mathlib 的三项；I4（约 503 个模块的归类）待 Ren。

## 128. 精化在类数之内停止：Moore 界与有分支的框架以类计的深度（P83c）

2026-10-15，P83 的下一步（[identification-where-bounded](../../../../theories/becoming/results/records/identification-where-bounded.md) 的 next_delta “同一世界的 Moore 界”与“有分支的框架下的辨识”），按 Ren 2026-10-12 06:01 的“keep prove to the deepest … for the open questions, if they need to be answered to move forward, answer them”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）与 2026-10-15 的“offer it to them, keep proving”（把有分支的框架的部分交给 `Becoming.Likeness` 的所有者，后者同意：加而不替换）。工作板上认领为 P83c。§97 与 §126 给出两段各有其界的历史的长度 N + N′ − 1（Fine–Wilf），同一世界的两个配置只用了 2N − 1；`Becoming.Likeness` 以配置对的数目 N·N′ 为深度的界。本节以类计数，给出两者更锐的界。新增核心模块 `Becoming.Refinement`（导入 `Decidedness` 与 `Recurrence`）；`Becoming.Identification` 与 `Becoming.Likeness` 只增加声明，导入 `Refinement`，已有声明不变。不加公理；除了所计数的判定不加前提。

```text
Result(s): 复用 identification-where-bounded（Law.SameFuture、orbit_held、sameFuture_iff_below、lassoPos_early、
           statesBelow_iff_lasso、StatesBelow、SameAhead；Learning.lassoNext、upto、mem_upto、lasso_realized）；
           tests-fix-likeness-where-determined（AlikeTo、AlikeTo.of_succ、AlikeTo.decided、AlikeTo.down_to、
           AlikeTo.bisimulation、FiniteDecided、Alike.alikeTo）；configurations-alike-by-relation（Law.registered）；
           recurrence-without-premise（Law.orbit、orbit_shift、orbit_add、mem_cons_split）；Decidedness（Decided、
           Decided.and、Decided.not、Decided.of_not_not、not_not_decided）；不新增记录，两条记录各增一条规律
Delta: Becoming.Refinement（DistinctUnder、Refining、SteadyAt、DistinctUnder.length_le、Refining.grow、
       Refining.steady_within、not_not_within）；Law.AgreeTo、Law.sameFuture_iff_classes、
       Law.sameFuture_classes_unrefuted、Law.sameFuture_classes_exact、Identification.sameAhead_iff_classes；
       AlikeTo.refining、AlikeAcross、AlikeTo.steady_within_classes、alike_iff_alikeTo_classes、
       AlikeTo.steady_within_across、alike_iff_alikeTo_across、alikeTo_registered_iff、EndOfPath.classes_exact
Supplied premises / correspondence: 不加公理；列表（N 个成员）写在定理中；Moore 界要成员的值两两判定相同（Decided，
       不要判定程序），不判定的形式只说不被否证；有分支的框架用 FiniteDecided（已有的条件）
Evidence: scratch_build 对 main 69ba40bd 上的 P83b：Becoming.Refinement 11 项定理、14 项声明；Becoming.Identification
       56 项定理、69 项声明（P83b 为 43、55）；Becoming.Likeness 137 项定理、181 项声明（此前 114、151）；
       公理报告全部为空；合并检查器回执待整合者的运行
Boundary: 两个有分支的框架之间深度 N + N′ − 1 是否恰好没有表明；不判定时 N − 1 是否成立没有表明；不含伦理谓词
Integration: identification-where-bounded 的 next_delta 中“同一世界的 Moore 界”完成，“有分支的框架下的辨识”由
       tests-fix-likeness-where-determined 的第十三条规律回答；AlikeTo.steady_within 与 alike_iff_alikeTo_pairs 保留
```

| 声明 | 内容 |
|---|---|
| `DistinctUnder.length_le` | **两两分开的成员不多于列表。** 关系使每个成员与自身相连时，列表 l 持有的、两两不相连的成员 s 满足 s.length ≤ l.length（`Population` 的 `Distinct` 是相等的情形）。证明从 l 中取出 s 的第一个成员的一次出现，余下的仍持有 s 的其余成员；不需判定 |
| `Refining.grow` | **严格细分多一类。** 在一条等价链（`Refining`：自反、对称、传递，每步比前一步细）中，x、y 在第 j 步相连、第 j + 1 步分开时，第 j 步两两分开的列表 r 加上 l 的一个成员，成为第 j + 1 步两两分开的列表：若 x 与 r 中无一相连，加 x；若与 a 相连，x、y 中至少一个在第 j + 1 步与 a 分开，加它 |
| `Refining.steady_within` | **链在其类数之内停止。** 每步的关系在 l 的成员之间已定、第一步有 c 个成员两两分开时，在某个 k（k + c ≤ l.length）处，第 k 步相连的成员在第 k + 1 步仍相连（`SteadyAt`）。证明逐步：要么已停止，要么两两分开的成员已有 c + j 个，而它们不多于 l |
| `not_not_within` | 有限多个命题各自不被否证时，合起来也不被否证；所以有限多个判定合起来不被否证 |
| `Law.sameFuture_iff_classes` | **Moore 界。** 确定的律下，列表 l（N 个成员）对律封闭、成员的值两两判定相同时，两个成员所识的未来相同，恰当它们在 N − 1 步内相同。在 k + 1 步内相同（`Law.AgreeTo`）是一条等价链；若所有成员的值相同，处处相同；否则值不同的两个成员给出两类，链在 N − 2 之内停止，律确定，此后不再细分（`Law.AgreeTo.steady_on`） |
| `Law.sameFuture_classes_unrefuted` | 不判定时，在 N − 1 步内相同的两个成员处处相同，这一点不被否证：所需的判定只有列表中有限多对，合起来不被否证 |
| `Law.sameFuture_classes_exact` | **对每个 N ≥ 2 恰好。** M + 2 个位置的路径（`Learning.lassoNext (M + 1) 0`，最后一个停住），只识是否到了最后一个：位置 0 与 1 在前 M 步相同，在第 M 步不同 |
| `Identification.sameAhead_iff_classes` | 至多 N 个状态、值两两判定相同的历史中，两个时刻是同一状态，恰当其后在 N − 1 步内相同：历史是其套索世界的历程，位置不多于 N |
| `AlikeTo.steady_within_classes`、`alike_iff_alikeTo_classes` | **一个框架之内深度 N − 1。** 深度的相同是一条等价链（`AlikeTo.refining`，由 `AlikeTo.self`、`symm`、`trans`）；N 个配置持有有限、已定的框架时，它在 k + c ≤ N 处停止（c 为两两实现不同主张的配置数），所以相同恰是深度 N − 1 的相同 |
| `AlikeTo.steady_within_across`、`alike_iff_alikeTo_across` | **两个框架之间深度 N + N′ − 1。** 两个框架合起来读作一个（`AlikeAcross`，在 S ⊕ S′ 上），它们的配置恰在深度 N + N′ − 1 相同时相同 |
| `EndOfPath.classes_exact` | **一个框架之内 N − 1 恰好。** N = M + 2 个位置、每个走到下一个、最后一个不再有步、没有主张的框架：前两个位置在深度 M = N − 2 相同而不相同 |
| `alikeTo_registered_iff` | 确定的律经登记读出时，深度 k 的相同就是 k + 1 步内的一致（两个律、两个登记亦然） |

**它回答了什么。** 一条逐步变细的等价链，每次严格细分多一类，而在 N 个成员之间至多有 N 类：这就是 Moore（1956）的论证，这里在核心中不用公理陈述为一条一般的律（`Refining.steady_within`），三处是它的实例。同一世界中，两个配置所识的未来相同，恰当它们在 N − 1 步内相同（此前用 2N − 1）；同一历史的两个时刻亦然。有分支的框架上，深度以类计：一个框架之内 N − 1，两个框架之间 N + N′ − 1（此前以配置对的数目 N·N′ 计）。所以“有分支的框架下的辨识”有了深度的形式：两个有限、已定的框架，各有 N 与 N′ 个配置，其配置是否相同由深度 N + N′ − 1 的分支检验确定。

**三个界连成一体。** 两段历史至多有 N 与 N′ 个状态时，Fine–Wilf 的 N + N′ − 1 就是两个系统合起来（N + N′ 个配置）的 Moore 界，对每一对界恰好（§126）。同一世界中配置共用它们的类，Moore 界是 N − 1，更锐。有分支的框架上多一步：确定的律经登记读出时，深度 k 的相同即 k + 1 步内的一致（`alikeTo_registered_iff`），所以那里深度 N − 2（同一世界）与 N + N′ − 2（两个世界）就够，均恰好；一般的框架需要 N − 1，`EndOfPath` 表明这一步不能省：多出的一步在于一个动作能否被取本身被识（死路）。

**判定在何处。** 以类计数要判定：Moore 界要列表中每一对成员的值判定相同（只这有限多对，不要判定程序）。不判定时，结论不被否证（`Law.sameFuture_classes_unrefuted`），因为有限多个判定合起来不被否证（`not_not_within`），这与 `Becoming.Decidedness` 的“静止不需判定”同一形式。2N − 1 的界（`Law.sameFuture_iff_below`，经 Fine–Wilf）完全不需判定。所以更短的界与判定相连：N − 1 用判定，2N − 1 不用。不判定时 N − 1 是否成立没有表明。

**作者反审。**
1. **已知的结果。** Moore 的界（1956）、等价的划分细化与其类数论证在自动机理论中都已知；有分支的系统中以类计的互模拟深度（划分细化，Kanellakis–Smolka、Paige–Tarjan）亦然。增量是：在核心中不用公理、不用判定程序陈述，把判定局部化到有限多对值；并与 §97、§126 和 `Becoming.Likeness` 连成一体，三处是一条律的实例。
2. **两个框架之间的恰好性没有证明。** 一个框架之内 N − 1 恰好（`EndOfPath.classes_exact`）。两个框架之间，以动作作为所识（每个配置只有一个带标记的动作），由 §126 的两个历程构造应给出 N + N′ − 1 的恰好性；这需要有限类型上的套索框架，留作下一步。
3. **不判定时的 N − 1。** 只证明它不被否证；是否在核心中不判定地成立，或需要某个原则，没有表明。
4. **名字。** `DistinctUnder`（`Distinct` 的关系形式）、`Refining`、`SteadyAt`、`AgreeTo`、`AlikeAcross`、`EndOfPath` 都是结构性的名字。

**检查。** 在暂存区对 main 69ba40bd 上的 P83b 编译：`Becoming.Refinement` 11 项定理、14 项声明；`Becoming.Identification` 56 项定理、69 项声明；`Becoming.Likeness` 137 项定理、181 项声明；没有错误或警告，公理报告全部为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。证明不用 `simp`、`omega` 或 `Nat` 的取模与减法引理（`Nat.add_sub_cancel` 会带入 `propext`，以定义上的化简代替）。可判定性清点：`Decided.exists_within`、`Refining.grow`、`Law.AgreeTo.decided` 归为分情形，`Refining.steady_or_grown`、`Refining.steady_within` 归为找出，`Law.sameFuture_iff_classes`、`Identification.sameAhead_iff_classes` 归为分辨相同（另一形式见 `Law.sameFuture_classes_unrefuted` 与 `sameFuture_iff_below`、`sameAhead_iff_below`）；清点在落地回执之后重新生成。合并检查器在整合者的运行中检查。本节尚未经独立审查。

## 129. 外围证明接入脊柱（整合 I3c）：经所登记者保持守卫；共享存量与学得程序的传递

2026-10-15。延续 §124、§127 的 I 列（Ren：“push as far as possible, as strong as possible, generally agree with your direction - but i also realize - a lot proofs are probably not integrated”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-likeness-readings.md)）。I3b 之后主证明仍在脊柱运行之外的 10 项中，I3c 取证明已在、能读作核心律之实例的 4 项：draws-on-a-shared-stock、finite-continuation-plans、joint-plan-composition、learned-procedure-transmission。它们的外围模块用 Std 的策略或 Mathlib，故实例写在外围模块中，各有检查器，核心不导入它们。其中两项所需的核心律原先没有：新增核心模块 Becoming.Keeping，随 P83b、I3b 与 P83c 的同一次核心运行落地。

```text
Result(s): 改写 4 项记录（脊柱别名、核心与实例模块的引用、实例回执与绑定、历史）：
           draws-on-a-shared-stock、finite-continuation-plans、joint-plan-composition、learned-procedure-transmission；
           不新增记录
Delta: 新核心模块 Becoming.Keeping（30 项定理／55 项声明，导入 Becoming.Viability 与 InquirySufficiency，不改既有模块）；
       三个外围实例模块及其检查器：SharedStockInstances（4 项定理／5 项声明，公理报告全空）、
       ContinuationCorrespondence（13／17）、TransmissionCorrespondence（12／20）
Supplied premises / correspondence: 对任意登记，被保持之类有方案以“对登记的选择”为具名假设（ChoiceOver），并证明恰需选择；
           登记可列举时不需；外围的 viable_iff_plan 由 Lean 的 Classical.choice 供给这一选择。
           学得程序的实例沿用该构造的理想化前提（精确的实数复制、给定的局部配方、分开匹配存量的同质家族）
Evidence: Keeping 由核心运行审计（回执 20261015T150956.178111Z）；三个外围检查器各自实跑（回执 20261015T151857.892080Z、20261015T151901.978501Z、20261015T151904.501987Z），
          闭包中每个其他模块的当前字节都有通过的回执
Boundary: 见下文“边界”
Integration: §9 一行新增（随核心运行）；根模块；check_becoming.py 的核心清单；四项记录；三个外围检查器
```

**测量。** 以落地回执，`SPINE-INTEGRATION.py`：在脊柱上陈述 179 → 183，运行之外 10 → 6，无 Lean 证明 10；较宽口径（引用某项脊柱证明）183 → 187。三个外围实例模块不在脊柱运行之内：这四项“在脊柱上陈述”，是指其别名命名所实例化的核心律，而实例由各自的检查器实查。

**经所登记者保持守卫（Becoming.Keeping，不加前提）。** `Viability` 说的是没有路径离开守卫之处：每条路径都算，不论走哪一步。这里各步不再相同：一步可用于一个配置类，指它在该类每个配置处都被容许且可走（`Usable`）；走过之后，该步所登记者使类收窄（`Seen`：自类中某配置经此步到达、且该步登记 o 的配置）。登记可列举（`Fin k`）时，`Seen` 按定义即 `InquirySufficiency.After`（`seen_eq_after`）。一个类保持 0 步，指守卫遍及该类；保持 n + 1 步，指此外有某个可用之步，无论该步登记什么，所见之类都再保持 n 步（`KeptFor`）。方案给出第一步，并对该步的每个登记给出其后的方案（`Plan`）；方案自一类保持守卫，指守卫遍及该类、第一步可用、每个后续方案自所见之类保持守卫（`Plan.Keeps`）。
- 保持守卫的方案使该类保持其长度之久，不加前提（`Plan.Keeps.keptFor`）。反过来，登记对方案有选择之处，每个被保持之类都有保持它的方案（`KeptFor.plan_of_choice`、`keptFor_iff_plan_of_choice`）；可列举的登记不加前提地有这一选择（`choiceOver_fin`，即 InquirySufficiency 的 `finite_choice`），故那里一类被保持恰当某个方案保持它（`keptFor_iff_plan`）。
- 更窄的类在更宽的类被保持处被保持（`KeptFor.mono`），更长的时程保持每个更短的（`KeptFor.shorter`），在各步不变时更细的登记保持更粗的登记所保持者（`KeptFor.finer`）；有一步时空类对每个时程都被保持（`keptFor_empty`）。
- 一族在守卫之内的类，若每类都有一个可用之步、无论登记什么都引回族中，则族中每类对每个时程都被保持（`keptFor_of_closed`）。`Viability` 的证书在其中有一步处处可用时就是这样的族（`Certificate.keptFor`），生存核亦然（`Kernel.keptFor`）。
- 所登记者有分别（`Matching`）：一个隐藏的位须由第二步匹配。登记这一位，起点保持两步；什么都不登记，起点不保持两步，因为无论第二步是什么，总有一个需要落空（`Matching.registration_matters`）。外围 `ContinuationAdequacy` 的盲观察见证是同一现象。
- 两部分的方案合成一个成对之步的方案，各部分依自己的登记继续（`Plan.zip`）。每个共同之步投影为各部分之步、共同之类落在两部分方案所保持之类之上、成对之步处处可用（`Plan.Compatible`）时，共同方案保持两个守卫，各部分登记自己的一步（`Plan.zip_keeps`）；而每个保持守卫的共同方案，其成对之步都处处可用（`Plan.compatible_of_zip_keeps`）。投影与共同可用是两个分开的条件，都不由两部分各自的方案推出。

**边界：选择。** 对任意登记，“每个被保持之类在每个进程中都有方案”恰是对登记的选择：每个在登记上处处有值的关系都由一个函数满足（`plans_iff_choice`）。由右向左即 `KeptFor.plan_of_choice`；由左向右，把一个关系编成两步的保持问题（`Answering`）：第一步登记一个 o，第二步只容许与 o 相关的值，于是保持两步的方案就给出选择函数。选择在需要它的律中是具名假设（`ChoiceOver`），核心不假设它；外围 `viable_iff_plan` 用 `choose` 策略，正在此处；登记可列举时不需要。按整合者的约定，这一界写进研究与记录，不写进判定清单的 BOUNDARY（该清单只读判定绑定与排中律）。

**接续与共同方案（ContinuationCorrespondence）。** `ContinuationAdequacy` 的转移是一个进程（`processOf`），观察到达的配置是该步的登记（`successor`），回应与观察之后的类即核心的 `Seen`（`post_eq_seen`，按定义），n 步可行即 `KeptFor`（`viable_iff_keptFor`）。方案两向互译，保持其成立与否（`works_iff_keeps`、`keeps_iff_works`）。于是 `viable_iff_plan` 由核心的 `keptFor_iff_plan_of_choice` 与 Classical.choice 给出（`viable_iff_plan_by_core`）；观察可列举时不用任何公理（`viable_iff_plan_listed`）。`JointContinuation` 的配对即核心的 `Plan.zip`（`toPlan_zip`），递推的共同可施行即 `Plan.Compatible`（`compatible_iff`），故 `joint_plan_composition` 与 `compatibility_necessary` 由 `Plan.zip_keeps` 与 `Plan.compatible_of_zip_keeps` 给出（`joint_plan_composition_by_core`、`compatibility_necessary_by_core`）。单一方案的对应与可列举的情形公理报告为空；`Classical.choice` 只在 `classicalChoice` 与 `viable_iff_plan_by_core` 中；共同方案的几条提及 `JointContinuation.zipPlan`，它以两个带指标的方案的匹配定义，编译后用 propext，配对的对应（`toPlan_zip`）另用函数外延（Quot.sound）。

**共享存量（SharedStockInstances）。** 前 n 项汲取依后先列出是一个论域（`firstDraws`），一种选取是其上的事件，汲取是其权重：选取的总和即该事件的质量（`selectedTotal_eq_mass`），总和即全域的质量（`total_eq_mass`）。于是 `CorrectionDependence` 的两条由核心的 `every_event_within_iff` 给出：每种选取都在存量之内，恰当总和在内（`every_selection_within_iff_total_within`）；两项各为二的汲取分别在二之内，合起来不在（`each_within_alone_not_together`）。五条声明的公理报告都为空，检查器要求如此。

**学得程序的传递（TransmissionCorrespondence）。**
- 容量即一个共享池所释放的最长谱系：把后继的十三单位前体读作同一种记号的词，所持前体为池，二十单位支持（九次记录写入、十步装置构造、一次控制位设定）在释放时汲取，`Copying.lineage_all_iff` 说 n 个后继自同一池与支持依次释放，恰当 n 在容量之内（`lineage_released_iff`）；故重构恰建成所释放的最长谱系（`reconstruction_builds_longest_lineage`）。
- 每条路径保存材料与支持：接触与重构是同一进程的两种步（`process`），每步之后材料与支持如前（`Stock.Balanced`，无汲取无补充），由 `Stock.trace_balance`，任意接触与重构的路径都保存二者，不只一个循环（`course_conserves`）。
- 忠实重构的 Price 计数形式：对每个忠实重构的家族，每个后继带其家族的控制位，传递既不升也不降，由 `Becoming.price`，后继中控制位的总数即各家族之位以其后继数加权，后继数即家族的容量（`faithful_selects`）。在历史中，响应家族重构两个后继，连续家族一个，故三个后继中两个带响应的更新方式，而两个亲代中只有一个（`history_selects`）。后继数来自各家族实际任务成功所留下的支持。

**作者反审。**
1. **新律还是重述？** Keeping 是新的核心律：它把 `Viability` 的“没有路径离开”推广到有可选之步与登记的情形，外围的 `viable`、`works`、`zipPlan` 是其实例。共享存量与学得程序两项是既有核心律的实例，增量是连接；Price 的实例接近算术（家族同质，Price 的形式是恒等式，不是适应度的度量），其内容在于后继数由实际表现所留的支持定出。
2. **选择在何处、是否必要。** 对任意登记恰需选择（`plans_iff_choice`）；可列举时不需。外围证明中的 `choose` 因此不能在一般情形去掉，而在有限观察的应用中可以去掉。
3. **“已整合”的意义。** 四项以别名命名核心律而在脊柱上陈述；实例模块不在脊柱运行之内（需 Std 的策略或 Mathlib），由各自的检查器实查，核心不导入它们。这与 I3a、I3b 的桥接不同：桥接在运行之内且公理报告为空。

**边界。** Keeping 的定理只在所给的进程、登记、守卫与容许条件之下成立；哪个守卫标出一项活动所需、哪些步被容许、一步登记什么，随每项应用给出。外围实例保持原模块的范围：`ContinuationAdequacy` 的许可不自动是伦理上的正当，`CorrectionDependence` 的数不是一般的价值度量，学得程序的构造保留其理想化前提。四项记录的旧回执保留；新别名绑定到核心回执与三个外围回执。

**下一步（I 列）。** 主证明在运行之外的记录余 6 项：五项是具体构造、工具或文档，随 I4（约 500 个模块的归类）待 Ren；一项待 E 列。

## 130. Moore 界不需判定：判定位置，不判定值（P83d）

2026-10-15，§128 作者反审第 3 条留下的问题“不判定时 N − 1 是否成立”（[identification-where-bounded](../../../../theories/becoming/results/records/identification-where-bounded.md) 的 next_delta），按 Ren 2026-10-12 06:01 的“keep prove to the deepest … for the open questions, if they need to be answered to move forward, answer them”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）与 2026-10-15 的“offer it to them, keep proving”，以及 2026-10-11 的“零前提优先”。工作板上认领为 P83d。回答：成立，不加前提。只编辑 `Becoming.Identification`，只增加声明，已有声明不变；不加公理，不加前提，不新增导入。

```text
Result(s): 复用 identification-where-bounded（Law.sameFuture_iff_classes、Law.SameFuture、Law.upto_length、
           statesBelow_iff_lasso、StatesBelow、SameAhead；Learning.lassoNext、upto、mem_upto、lasso_realized）；
           Refinement（le_pred_of_succ_le）；recurrence-without-premise（Law.orbit、orbit_add、mem_cons_split）；
           不新增记录，identification-where-bounded 增一条规律（第十四条）
Delta: Law.memberAt、Law.memberAt_mem、Law.position_of_mem、Law.choose_below、Law.orbit_memberAt、Law.merge、
       Law.SoundFor、Law.merge_sound、Law.merge_keeps、Law.merge_joins、Law.joinOrbits、Law.joinOrbits_sound、
       Law.joinOrbits_joins、Law.le_of_mem_upto、Law.lt_of_le_pred、Law.sameFuture_iff_within、
       Identification.sameAhead_iff_within
Supplied premises / correspondence: 不加公理，不加前提；列表（N 个成员）对律封闭写在定理中；不判定任何值，
       也不判定配置的相同；判定的只是位置（Nat 的相等）
Evidence: scratch_build 对 main fc76e49f：Becoming.Identification 69 项定理、86 项声明（P83c 为 56、69）；
       公理报告为空；核心检查器回执待整合者的运行
Boundary: 只是一个确定的律；有分支的框架（Becoming.Likeness）的深度界仍要 FiniteDecided；两个框架之间
       N + N′ − 1 的恰好性仍未证明；不含伦理谓词
Integration: §128 作者反审第 3 条回答；Law.sameFuture_classes_unrefuted 保留，现为推论；
       Law.sameFuture_iff_classes 是以类计的形式，Law.sameFuture_iff_within 用它于位置的标记
```

| 声明 | 内容 |
|---|---|
| `Law.memberAt`、`Law.position_of_mem` | 列表在一个位置上的成员（过了末尾取给定的默认值）；列表的每个成员在它的某个位置上。只要存在，不要查找，所以不判定配置的相同 |
| `Law.choose_below` | **有限多个存在一并选出。** 对每个 i < m 有某个 k 满足 P i k 时，有一个函数 f 对每个 i < m 满足 P i (f i)。对 m 归纳，结论是命题，不用选择公理 |
| `Law.orbit_memberAt` | **律在位置上读出。** 封闭的列表上，律把每个位置的成员送到某个位置的成员；由此选出位置上的律 f，从一个位置出发，律的轨道就是 f 的轨道所在位置的成员 |
| `Law.merge`、`Law.merge_sound`、`Law.merge_keeps`、`Law.merge_joins` | **逐对合并。** 把标记与 b 相同的位置改标为 a 的标记。合并两个值相同的位置，保持“每个标记只有一个值”（`SoundFor`）；已连的位置仍连；a 与 b 被连起来 |
| `Law.joinOrbits`、`Law.joinOrbits_sound`、`Law.joinOrbits_joins` | **由一致给出的标记。** 从恒等标记起，把两条位置轨道在前 k 步各步所到的两个位置逐对合并。两条轨道在这 k 步各步的值相同时，每个标记只有一个值；标记使两条轨道在这 k 步各步相连 |
| `Law.sameFuture_iff_within` | **Moore 界不加前提。** 确定的律下，N 个成员的列表对律封闭时，两个成员的所识的未来相同，恰当它们在 N − 1 步内相同。证明：律在位置上读出；把 N − 1 步的一致逐对合并成位置的标记，这个标记的相同在 Nat 中已定，`Law.sameFuture_iff_classes` 用于位置 0, …, N − 1、律 f 与这个标记，给出两条位置轨道的标记处处相同；每个标记只有一个值，所以值处处相同 |
| `Identification.sameAhead_iff_within` | 至多 N 个状态的历史中，两个时刻是同一状态，恰当其后在 N − 1 步内相同，不加前提：历史是其套索世界的历程（同 `sameAhead_iff_classes` 的证明，用 `Law.sameFuture_iff_within`） |

**它回答了什么。** §128 以类计数：在 k + 1 步内相同是一条逐步变细的等价链，每次严格细分多一类；数类要判定值的相同，所以那里 N − 1 要值两两判定相同，不判定时只是不被否证。本节表明判定可以移到位置上：位置是列表中的序号，其相同总是已定的。记录所给的是 N − 1 个等式，每个等式说两条轨道在某一步所在的两个位置值相同；把这些位置逐对合并，得到位置的一个标记；按构造它只连记录所要求连的，但这一点没有作为定理陈述，证明只用较弱的一面（`joinOrbits_sound`：每次合并的两个位置值相同，所以每个标记只有一个值）。Moore 界对这个标记成立，因为标记的相同已定；而标记相同的位置值相同，所以结论回到值。这样，“同一世界中 N − 1 步确定所识的未来”不需判定、不需公理，与 2N − 1（经 Fine–Wilf）同样不加前提，而更锐，并对每个 N ≥ 2 恰好（`Law.sameFuture_classes_exact`）。

**更短的界与判定不再相连。** §128 写道：“N − 1 用判定，2N − 1 不用。”现在两者都不用。以类计数的论证仍要判定（`Refining.steady_within` 的前提），但所计的类可以是一个已定的标记的类，而不是值的类：记录本身给出的等式足以构造它。值的判定只在“数值的类”这一证明路线中出现，不在结论中。

**读法（AI 的，待 Ren）。** 这是一个自由模型：在只知道记录给出的等式时，把它们所要求的连起来（按构造只连这些；Lean 中陈述的是所用的一面：满足这些等式的值都经过这个标记，`SoundFor`）。所以结论对一切满足记录的值成立，只因为它对这个最少的标记成立。读作：情境（N 个配置、一个确定的律）与有限的记录确定所识的未来，不需要任何关于值能否比较的原则；“按情境推出”在这一处不附加判定。这是 AI 的读法，Ren 的判断未给出。

**作者反审。**
1. **已知的结果。** Moore（1956）的界在经典逻辑中已知；Hopcroft 与 Karp（1971）判定有限自动机的等价，也逐对合并状态（并查集），但他们沿后继闭合，并比较输出。这里的合并只连记录给出的对，然后用以类计的界；增量是在核心中不用公理、不用判定地陈述 Moore 界，并把判定从值移到位置。
2. **有限选择。** `choose_below` 对有界的范围归纳；结论是命题，所以由存在证明取出见证不需选择公理。所选的位置律 f 只在列表的位置上有意义，列表之外的值没有用到。
3. **有分支的框架。** 那里每一步是关系而不是函数，深度相同含有“对每个后继存在一个后继”，位置的合并不能直接给出；`Becoming.Likeness` 的深度界仍要 `FiniteDecided`。这一判定能否去掉没有表明。
4. **名字。** `memberAt`、`merge`、`SoundFor`、`joinOrbits` 都是结构性的名字；`sameFuture_iff_within` 与 `sameAhead_iff_within` 以“在 N − 1 步之内”命名，与以 2N − 1 为界的 `sameFuture_iff_below` 相对。

**检查。** 在暂存区对 main fc76e49f 编译：`Becoming.Identification` 69 项定理、86 项声明；没有错误或警告，公理报告为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`；证明不用 `simp`、`omega`。新定理没有 `Decided` 前提，可判定性清点只在 `Law.sameFuture_iff_classes` 与 `Identification.sameAhead_iff_classes` 的“另一形式”一栏写出无前提的形式。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 131. 动作在哪里形成：部分的、其余的，或只是两者之关系的（Becoming.Coupling）

2026-10-15。P69 的记录 [process-and-frame-as-readings](../../../../theories/becoming/results/records/process-and-frame-as-readings.md) 的 next_delta 问动作何时在展开之内形成（何时是一个形成的，而不是从外面供给的）；P80 的记录 [counterfactual-is-the-course](../../../../theories/becoming/results/records/counterfactual-is-the-course.md) 的 next_delta 问动作何时是部分自己的；`Becoming.Unfolding` 与 `Becoming.Counterfactual` 都把这一点列为没有导出。Ren 2026-10-12 对“律与历史是同一展开的两种读法”说“yes, i do agree with your reading, there are no two realities”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-no-two-realities.md)），2026-10-14 对从关系开始的重建说“please, finish all”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-relation-first-refounding.md)）。本节把这一读法推到动作，在第一部分之内：不加公理，除各律所写者不加前提。工作板上认领为 P109。

```text
Result(s): 新增 where-a-move-is-formed；推进 process-and-frame-as-readings 与 counterfactual-is-the-course 的 next_delta；
           复用 process-and-frame-as-readings（closedBy、Fork.label_couples）、counterfactual-is-the-course（ExchangeLaw.ofMoves、
           ExchangeLaw.policy）、causal-models-as-processes（trajectory）、projection-carrying-a-law（GoAlike、GoAlike.runs_agree、
           carries_law_iff）、recurrence-without-premise（Law.orbit）、generalization-through-lumping（Learning.Lumped）、
           learning-by-refutation（Learning.Lasso、lasso_of_held、lassoNext、lasso_positions、upto、mem_upto）、
           control-coherence-loss（Readout.Reading、SingleValued、reading_single_iff、Decodes、lumped_of_decodes）、
           experiment-needs-return（keepHistory、keepHistory_length）
Delta: 新核心模块 Becoming.Coupling（导入 Counterfactual 与 Readout；51 项定理／72 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各律所写者写在定理中：部分的律确定（Determined）、律是函数、构型在一个列表之内、
       配置与动作的相等可判定（只用于有限一段上的策略与排除）
Evidence: scratch_build 对 main fc76e49f（P107、P83b、I3b、P83c 与 Keeping 之后）：Becoming.Coupling 51 项定理、72 项声明，公理报告全部为空，无警告；
          根模块 Becoming 与其导入闭包（108 个模块）一同编译，无重名；合并检查器回执待整合者的运行
Boundary: 离散的步；非确定的律取哪个后继不由此形成；哪种切分恰当、实际的动作是否是部分自己的没有导出；耦合的度量没有陈述；
          不含伦理谓词
Integration: §9 新增一行；§8 的进一步证明与 Ren 的选择各补一项；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列；
       Lean README 一行与层内导入；DECIDABILITY-INVENTORY.py 的四项分类；一项新记录与两项配对说明
```

**一、一个动作，两面。** 部分的律 `P : Process S A` 与其余的律 `Q : Process E A` 由在整体之内形成的一个动作耦合（`coupled`）：在联合配置 `x` 处动作是 `form x`，部分按 `P`、其余按 `Q` 同时取它。这是 `GenerativeCore` 的同步积，动作从联合配置读出；整体只有一个行动，没有什么从外面供给它。部分与其余每一步取同一个动作（`Run.part`、`Run.rest`、`Run.part_act_eq_rest_act`）：部分所做的就是其余所受的，其余所做的就是部分所受的；共享的动作就是两者之间的关系（`Becoming.Unfolding` 的 `Fork.label_couples`）。耦合的整体就是 P69 的 `closedBy` 作用于积，动作读出而不读入（`Run.toClosedBy`、`Run.ofClosedBy`、`Run.ofClosedBy_toClosedBy`）；确定的律的耦合是确定的（`coupled_determined`）。

**二、部分的、其余的，或只是两者之关系的。** 动作经配置的一个读法 `π` 形成，当读法相同的配置形成同一个动作，即动作随 `π` 所归并者同行（`Becoming.Learning` 的 `Learning.Lumped`）；`π` 的策略给出的动作如此（`Readout.lumped_of_decodes`）。在整体之内形成的动作经整体的配置形成（`lumped_id`）；经一个读法形成的动作经每个至少同样区分的读法形成（`lumped_of_finer`）；经不区分任何东西的读法，只形成处处相同的动作（`lumped_const_iff`）。动作是部分的（`PartForms`），恰当它是部分的策略（`partForms_iff`）；是其余的（`RestForms`），恰当它是其余的策略（`restForms_iff`）；两者都是，恰当它处处相同（`partForms_and_restForms_iff`）。所以有所不同的动作至多由一方单独形成；由两者之关系形成的动作不由任一方单独形成（`Parity.neither_alone`：动作是两者是否不同）。

**三、自己的动作封闭部分，又是其余的输入。** 部分的律确定、动作是部分的时，部分承载自己的律（`PartForms.goAlike`，经 `carries_law_iff` 读）；不论其余如何开始、如何走，从部分的同一配置出发，部分的进程相同（`PartForms.parts_agree`）。律是函数时，每一方的进程都是标准模型（`Becoming.Mechanism` 的 `trajectory`）以动作为输入的轨迹（`Run.part_trajectory`、`Run.rest_trajectory`）。部分自己的动作在部分之内循环（`Run.part_orbit`），又是其余的输入（`Run.rest_driven_by_part`）；其余自己的动作在其余之内循环（`Run.rest_orbit`），驱动部分；整体按一个确定的律循环（`wholeNext`、`Run.whole_orbit`）。封闭不等于形成自己的动作：动作对其律不起作用的部分对其余封闭，而它的动作是其余的（`TwoClocks.closed_not_own`）。

**四、无需从整体之外供给。** 每个带标签过程的每个运行，无论动作如何，都是一个只有一个行动的整体中部分的进程，其余是一只钟，由它形成动作（`clock`、`clock_determined`、`Run.withClock`、`Run.withClock_part`、`Run.withClock_restForms`）。反事实所供给的动作就是这一种：在进程的标准模型中（`Becoming.Counterfactual`），不读任何东西的律（`ExchangeLaw.ofMoves`）的动作只经阶段形成（`ExchangeLaw.ofMoves_lumped_stage`）。这是 `Becoming.Reading` 的 `World.withRest` 在动作上的对应：那里把整体的其余算作关系项，使每个世界都平衡、都是交换之律的一次运行（`Becoming.Readings` 的 `World.unity`），其余的交换从世界读出，是两种变化读法之差；这里其余对动作的形成从进程读出。

**五、列表所持者重复。** 律是函数、联合配置在一个列表 `l` 之内时，整体之内形成的动作从某步 `i` 起以某个周期 `q + 1` 重复，`i + q + 1 ≤ l.length`（`Run.moves_lasso_of_whole_held`，经 `Learning.lasso_of_held`）；其余形成动作而其余在列表之内、部分形成动作而部分在列表之内，亦然（`Run.moves_lasso_of_rest_held`、`Run.moves_lasso_of_part_held`）。反之，每个套索都如此形成：由套索的 `i + q + 1` 个位置组成的其余形成它（`lassoRest`、`Run.withLasso`、`Run.withLasso_held`、`Run.withLasso_part`）。所以动作由在列表之内、律为函数的其余形成，恰当动作是套索。从不进入循环的动作需要不在任何列表之内的整体，也需要不在任何列表之内的形成者（`Run.whole_unheld_of_never_cycles`、`Run.rest_unheld_of_never_cycles`、`Run.part_unheld_of_never_cycles`）。

**六、记录所定。** 沿一段进程，动作经配置形成的读法是：在同一个配置处动作从不不同（沿进程的 `Learning.Lumped`）。这恰当某个在每个配置至多给一个动作的关系给出每个动作，不需判定（`lumped_iff_singleValued`，用 `Readout.SingleValued`；进程的读出 `Readout.Reading` 是其中最小的，`reading_le`）；在有限一段上、配置的相等可判定时，恰当某个配置的策略给出它们（`lumped_upto_iff`，不需 `Readout.decodes_iff_of_section` 的截面）。记录排除这一读法，恰当某个配置复现而动作不同（`no_policy_upto_iff`，配置与动作的相等可判定；`not_lumped_of_varied`）；部分的配置复现而动作不同之处，其余在那里不同（`rest_differs_of_varied`）。无物复现时每段进程都这样读（`lumped_of_new`）：保留其历史的部分（`Becoming.Experiment` 的 `keepHistory`）把它所做的每个动作读作自己的，一个配置的策略给出它们（`Run.keepHistory_formed`，用 `Readout.Decodes`）。同一段进程可以由部分的动作之律与其余的动作之律容许，两者只在进程不到之处不同（`TwoClocks.one_course_two_laws`）：如 `Becoming.Reading` 中的要求（`ExchangeLaw.requirement_beyond_course`），动作是谁的属于律，是一段进程不固定的反事实。部分不动而动作交替时，部分不形成动作（`Still.driven`）。

```lean
def coupled (P : Process S A) (Q : Process E A) (form : S × E → A) : Process (S × E) Unit :=
  ⟨fun x _ y => (productProcess P Q).step x (form x) y⟩

theorem partForms_and_restForms_iff : PartForms form ∧ RestForms form ↔ ∀ x x', form x = form x'

def Run.withClock (r : Run P) : Run (coupled P (clock A) (fun x => r.act x.2))

theorem Run.moves_lasso_of_whole_held (r : Run (coupled P Q form)) {F : S → A → S}
    {G : E → A → E} (lawP : ∀ s a s', P.step s a s' → s' = F s a)
    (lawQ : ∀ e a e', Q.step e a e' → e' = G e a) {l : List (S × E)}
    (held : ∀ n, r.state n ∈ l) :
    ∃ i q, i + q + 1 ≤ l.length ∧ Learning.Lasso (fun n => form (r.state n)) i q

theorem no_policy_upto_iff [DecidableEq K] [DecidableEq A] {g : Nat → K} {m : Nat → A} (N : Nat) :
    (¬ ∃ policy : K → A, ∀ n, n < N → m n = policy (g n)) ↔
      ∃ i j, i < N ∧ j < N ∧ g i = g j ∧ m i ≠ m j
```

**读法（AI 的，待 Ren；律与历史是同一展开的两种读法已由 Ren 确认）。**
1. **行与受是同一个动作的两面。** 行动者不是一种存在者，而是一个部分：动作经它的配置形成，相对于整体在何处被切为部分与其余。动作是谁的，是动作与配置的关系，不是任一方的性质。
2. **无需从整体之外供给。** 输入是其余的配置；外来的标签是表示略去其形成的动作。如 `Becoming.Readings` 中其余的交换，被供给的成为其余的状态，从进程读出。
3. **动作是谁的，是关于未走之进程的主张。** 它是动作之律；一段进程只在某个配置复现而动作不同之处固定它。这是 `Becoming.Experiment` 的对应：实验在配置返回处变化自己的动作，归属在配置返回处看到动作变化。保留历史的部分可以把每个动作读作自己的，其记录从不否证它；但按 `Becoming.Recurrence`，它也就从不返回。
4. **识得越多，越多是自己的。** 识得形成动作者，动作就经自身所是者形成（`lumped_of_finer`）。
5. **封闭不是自己的。** 对其余封闭的部分仍可以不形成自己的动作（`TwoClocks.closed_not_own`）。
6. **所做之事的新需要开放或增长。** 从不进入循环的动作不由任何列表所持者形成。

**作者反审。**
1. **新律还是重述？** `coupled` 是 Ashby（1956，《控制论导论》第 4 章）所说的有输入之机器的耦合，一台机器的参数是另一台机器状态的函数；这里两方取同一个由整体形成的动作。`Run.part_act_eq_rest_act` 由定义成立。`partForms_and_restForms_iff` 是积上函数的初等事实；`PartForms.goAlike` 与 `PartForms.parts_agree` 是 `GoAlike` 的实例。`Run.withClock` 是把时间加入状态、使非自治系统成为自治系统的标准构造。列表所持者重复是有限状态的确定系统只生成最终周期序列的经典事实，`Run.withLasso` 是其逆。记录的部分：`lumped_iff_singleValued` 是 `Readout.reading_single_iff` 的小推广，`no_policy_upto_iff` 是数据库理论中函数依赖的定义性事实（Codd 1972：一组记录满足依赖 g → m，恰当没有两条在 g 上相同而在 m 上不同），这里在核心中不用公理陈述，并以构造的策略与找出的复现两向给出。自由能原理以马尔可夫毯把状态分为内部、外部、感觉与行动；这里不用概率与条件独立，只在确定的同步积中陈述动作经哪一方形成。新的是这些事实合起来对两个未决问题的回答：动作何时在整体之内形成（总是可以如此读，第四点），何时是部分自己的（恰当它经部分形成，第二点；一段进程只在复现而变化处固定这一点，第六点）。
2. **“无需从整体之外供给”是不是把外来的标签藏进其余？** 在 `Run.withClock` 中，其余的形成函数 `fun x => r.act x.2` 以运行的动作为数据：这是关于读法的定理，不是对动作的说明，与 `World.withRest` 相同（算入其余不增加关于交换的信息）。有内容的是第五点与第六点：列表所持的其余只形成套索，所以不重复的动作需要不受列表所限的形成者，如钟；动作是谁的，只在复现而变化处被记录固定。
3. **与 P53 的对偶。** `Becoming.Experiment` 证明记录只在走过之处固定一个动作的结果，实验需要返回；这里记录只在配置复现而动作变化处固定动作是谁的。保留历史的部分在两处都是极端：每个动作都读作自己的、从不被否证，但从不返回，所以也从不被实验。
4. **切分是给定的。** 部分与其余是积的两个分量；哪种切分恰当没有导出。`Parity.neither_alone` 说明有的动作只属于关系，在那里“谁的”没有单一的答案；动作经整体形成总是成立（`lumped_id`）。
5. **非确定的律。** 律不确定时，耦合只给出动作，不给出后继；取哪个后继不由这里的任何东西形成，也不说它属于部分还是其余。
6. **范围。** 不含伦理谓词；离散的步；耦合的度量（部分形成动作的多少，理论第 8 节的进一步证明）没有陈述；`ExchangeLaw.Through` 的反事实之动作经部分自身的识读出没有陈述。

**检查。** 在暂存区对 main（fc76e49f）编译：`Becoming.Coupling` 51 项定理、72 项声明，没有错误或警告，公理报告全部为空；根模块 `Becoming` 与其导入闭包（108 个模块）一同编译，没有重名；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。证明不用 `Nat` 的减法引理（`Nat.add_sub_cancel_left` 依赖 `propext`），`Run.keepHistory_formed` 用自证的 `Coupling.add_sub_left`。草稿中的 `FormedThrough`、`FormedAlong` 与 `shownPolicy` 与 `Learning.Lumped`、`Readout.Reading` 相同，已改用共享的定义。合并检查器在整合者的运行中检查。本节尚未经独立审查。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计新模块，再把新记录绑定到回执。`DECIDABILITY-INVENTORY.py` 把 `policyUpto` 记作分辨相同的构造，把 `lumped_upto_iff` 记作只在证明中分辨相同，把 `no_policy_upto_iff` 与 `throughout_or_fails` 记作只在证明中找出一步。既有模块的字节不变。

## 132. 区分：检验即有界的记录，两个框架之间的深度恰好（P83e）

2026-10-15，两项开放问题：[identification-where-bounded](../../../../theories/becoming/results/records/identification-where-bounded.md) 的“与 `alike_iff_sameTests` 的实例定理”，与 [tests-fix-likeness-where-determined](../../../../theories/becoming/results/records/tests-fix-likeness-where-determined.md) 的“两个有分支的框架之间深度 N + N′ − 1 的恰好性”（§128 作者反审第 2 条）。依据 Ren 2026-10-12 06:01 的“keep prove to the deepest … for the open questions, if they need to be answered to move forward, answer them”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）与 2026-10-15 的“offer it to them, keep proving”。工作板上认领为 P83e。此前没有模块同时导入 `Identification` 与 `Likeness`，所以新增核心模块 `Becoming.Distinguishing`，导入这两者，已有模块不改。不加公理，不加前提。

```text
Result(s): 复用 identification-where-bounded（Law.sameFuture_iff_within、Identification.bounded_agree、bounded_agree_exact、
           statesBelow_iff_lasso、record_eq_iff、Law.statesBelow_held；Learning.lassoNext、lasso_realized）；
           tests-fix-likeness-where-determined（SameTests、alike_iff_sameTests、Determined.alike_iff_sameTests、
           AlikeTo、Alike.alikeTo、FiniteDecided、alikeTo_registered_iff、finBelow）；configurations-alike-by-relation
           （Law.registered、Law.registered_determined、Law.alike_iff_sameFuture、Bisimulation、Alike）；不新增记录，
           tests-fix-likeness-where-determined 增两条规律（第十四、十五条）
Delta: Becoming.Distinguishing：Law.agree_bisimulation、Law.alike_iff_agree、Law.sameTests_iff_within、
       Law.sameTests_iff_below_across、Law.labelled、Law.alikeTo_labelled_iff、Law.labelled_finite、Law.orbit_fin、
       Law.realized_within、labelled_across_exact、registered_across_exact
Supplied premises / correspondence: 不加公理，不加前提；世界被 N 个配置的列表持有写在定理中；labelled_finite 用配置与
       名字的 DecidableEq（只用于给出 FiniteDecided，例中为 Fin 与 Bool）
Evidence: scratch_build 对 P83d（06b21e3c，已落地为 ff1f2957）：Becoming.Distinguishing 10 项定理、11 项声明，公理报告为空；
       核心检查器回执待整合者的运行
Boundary: 一个世界之内检验的长度 N − 1 在整个世界被 N 个配置持有时是否恰好没有构造（在对律封闭的列表上恰好，
       Law.sameFuture_classes_exact）；有分支的框架的深度界仍要 FiniteDecided；不含伦理谓词
Integration: identification-where-bounded 的 next_delta “实例定理”与 tests-fix-likeness-where-determined 的
       “两个框架之间的恰好性”完成；依赖方向不变（tests-fix-likeness-where-determined 依赖 identification-where-bounded）
```

| 声明 | 内容 |
|---|---|
| `Law.agree_bisimulation`、`Law.alike_iff_agree` | 两个律经登记读出时，所识的未来处处一致是一个互模拟；所以它们恰在处处一致时相同（`Law.alike_iff_sameFuture` 的两个律的形式） |
| `Law.sameTests_iff_within` | **检验即 N − 1 步的记录。** 确定的律经登记读出、N 个配置的列表持有世界时，两个配置通过相同的检验（每个动作的路线是否可走、走后能实现哪些主张），恰当所识的未来在 N − 1 步内相同：`Determined.alike_iff_sameTests`、`Law.alike_iff_sameFuture` 与 `Law.sameFuture_iff_within` 三者相连 |
| `Law.sameTests_iff_below_across` | 两个这样的世界（N 与 N′ 个配置）之间，恰当在 N + N′ − 1 步内相同（`alike_iff_sameTests`、`Law.alike_iff_agree` 与 `Identification.bounded_agree`） |
| `Law.labelled`、`Law.alikeTo_labelled_iff` | **动作承载所识。** 每个配置只有一个动作，以该处所识命名，到律的下一个，不主张什么。深度 k 的相同恰是 k 步内的一致；所识作为主张时是 k + 1 步（`alikeTo_registered_iff`），这里少一步，因为深度 0 不比较什么 |
| `Law.labelled_finite` | 配置列出、配置与名字的相等可判定时，这样的框架有限且已定 |
| `Law.orbit_fin`、`Law.realized_within` | **有界的历史是有限世界的历程。** 位置上留在 N 之下的律是 N 个配置上的律，轨道相同；所以至多 N 个状态的历史是 N 个配置上的律（其套索世界）从某个配置起的历程 |
| `labelled_across_exact` | **两个框架之间深度 N + N′ − 1 恰好。** 由 `Identification.bounded_agree_exact` 的两个历程（至多 M + 1 与 M′ + 1 个状态，在 M + M′ 之前一致、在 M + M′ 处不同），得 N = M + 1 与 N′ = M′ + 1 个配置的两个这样的框架，有限且已定、被长 N 与 N′ 的列表持有，其起点在深度 N + N′ − 2 相同而不相同 |
| `registered_across_exact` | 经登记读出时，同样的两个律有所识的未来在 N + N′ − 2 步内一致、却不通过相同检验的配置：`Law.sameTests_iff_below_across` 的长度恰好 |

**它回答了什么。** 检验是无穷多的：每一条动作的路线，每一个主张。`Becoming.Histories` 表明它们在确定之处固定相同；`Becoming.Identification` 表明所识的未来由有界的记录固定。两者相连：在 N 个配置的世界中，无穷多的检验由 N − 1 个所识的值固定，两个世界之间由 N + N′ − 1 个。这就是 P83 的实例定理。

**两个框架之间的恰好性。** §128 证明了一个框架之内 N − 1 恰好（`EndOfPath`，多出的一步来自死路），两个框架之间只给出界 N + N′ − 1。这里让动作本身承载所识：深度 k 的相同于是恰是 k 步内的一致，比所识作为主张时少一步。§126 的两个历程（Fine–Wilf 的界对每一对恰好）在 N 与 N′ 个配置上实现为这样的框架，所以两个框架之间的深度 N + N′ − 1 也对每一对恰好。三个恰好性于是是同一个：Fine–Wilf 的 N + N′ − 1（两段历史）、检验的长度 N + N′ − 1（两个经登记读出的世界）、深度 N + N′ − 1（两个有分支的框架），都由同两个历程见证。

**读法（AI 的，待 Ren）。** 能把配置分开的，在有界的世界中是一个有限的记录，它的长度由配置的数目给出，恰好。说一个配置“是什么”（它通过的全部检验）就是说它接下来 N − 1 步所识的；不需要更多，也不能更少。

**作者反审。**
1. **已知的结果。** 有限自动机中，区分两个状态的实验的长度以状态数为界（Moore，1956），两个机器合起来读作一个时以状态数之和为界，界可达（文献中计数的约定可差一步）；检验与互模拟在确定的系统中一致也是已知的。增量是在核心中不用公理、不用判定地陈述，并把 `Histories`、`Identification` 与 `Likeness` 的三处连成一体。
2. **一个世界之内检验的恰好性。** `Law.sameFuture_classes_exact` 在一个对律封闭的列表上给出 N − 1 的恰好性；一个整个被 N 个配置持有的世界中，检验的长度 N − 1 的恰好性这里没有构造（需要把那里的路径世界写在 Fin 上）。
3. **`labelled_finite` 的可判定性。** 它要配置与名字的 `DecidableEq`，只用于给出 `FiniteDecided`；例中为 `Fin` 与 `Bool`，没有原则。可判定性清点中把它归为分辨相同。
4. **名字。** `labelled`（动作被命名）、`realized_within`、`Distinguishing` 都是结构性的名字。

**检查。** 在暂存区对 P83d 编译：`Becoming.Distinguishing` 10 项定理、11 项声明；没有错误或警告，公理报告为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`；证明不用 `simp`、`omega`。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 133. 静止之步不需要界：对每个学习者 2N − 1，界只给出沉默（P83f）

2026-10-15，[identification-where-bounded](../../../../theories/becoming/results/records/identification-where-bounded.md) 的 next_delta “未给定界的学习者的最优静止之步”。依据 Ren 2026-10-12 06:01 的“keep prove to the deepest … for the open questions, if they need to be answered to move forward, answer them”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-framing-and-pairs.md)）。工作板上认领为 P83f。只编辑 `Becoming.Identification`，只增加声明，已有声明不变；不加公理。学习者要值可判定（与所有学习者相同）；两条否定的定理不要。

```text
Result(s): 复用 identification-where-bounded（Fits、decFits、grid、mem_grid、firstFit、firstFit_sound、firstFit_found、claimBy、
           BorneOut、borneOut_record_iff、bounded_hypothesis、bounded_induction、statesBelow_iff_lasso、statesBelow_pos、
           le_twice_less_one、record_short_twice、withBound_holds）；learning-by-refutation（Learning.record、lasso、
           lasso_claims、back_made、eq_of_not_refuted、Holds、RefutedAt、holdFrom、holdFrom_lasso）；recurrence-without-premise
           （le_succ_cases）；不新增记录，identification-where-bounded 增一条规律（第十五条），陈述随之修订
Delta: Identification.orFit、leastFit、leastFit_sound、leastFit_within、leastBound、leastBound_exact、rest_earliest、
       rest_without_bound_refuted
Supplied premises / correspondence: 不加公理；leastBound 要值可判定（DecidableEq O，同 withBound）；rest_earliest 与
       rest_without_bound_refuted 只要两个不同的值
Evidence: scratch_build 对 main ff1f2957：Becoming.Identification 74 项定理、94 项声明（P83d 为 69、86），公理报告为空；
       核心检查器回执待整合者的运行
Boundary: 按否证学习者（Becoming.Learning 的 learner lassos）自己的确切静止之步没有表明（其 N + (2N − 1)·tri N 仍粗）；
       历程必须有界（没有界时没有记录确定下一个值）；不含伦理谓词
Integration: next_delta “最优静止之步”完成；陈述修订（原文存于记录沿革）
```

| 声明 | 内容 |
|---|---|
| `leastFit`、`leastFit_sound`、`leastFit_within` | **以最小的界搜索。** 对 M = 1, 2, …，在 M 之内的套索假设中找第一个被记录证实的（`Fits M`，与给定界的学习者同一条件），找到即停。找到的在其界之内且被证实；凡有某个 N 之内的假设被证实，且搜索至少到 N，就找到一个 N 之内的 |
| `leastBound` | **以最小的界读记录的学习者。** 不被给予界；在长 t 的记录上，以搜索到 t 时找到的假设作主张 |
| `leastBound_exact` | **静止之步不需要界。** 在至多 N 个状态的每个历史上，从 2N − 1 起每步都对，对每个 N。真实的假设（N 之内）被证实，所以找到的在 N 之内；N 之内、在 2N − 1 之前被证实的假设处处成立（`bounded_induction`），所以它的主张对 |
| `rest_earliest` | **没有学习者更早。** 给定两个值，没有学习者在每个至多 M + 2 个状态的历史上于第 M + M + 2 步都对：`record_short_twice` 的两个历史在那之前记录相同、在那里不同，同一个记录上的主张至多对一个 |
| `rest_without_bound_refuted` | **界给出沉默。** 给定两个值，没有学习者既在每个一个状态的历史上于第 1 步都对，又在每个两个状态的历史上处处不被否证：常值历史与从第 1 步起换值的历史在第 1 步之前记录相同 |

**它回答了什么。** §97 留下：未给定界的按否证学习者从 N + (2N − 1)·tri N 起每步都对，这一步粗。这里回答更强的问题：在所有学习者中，最优的静止之步是 2N − 1，而达到它不需要被给予界。以最小的界读记录，就是在每一步用记录所容许的最小的界：真实的界使这个最小的界不超过它，而 Fine–Wilf 的界使任何 N 之内、在 2N − 1 之前被证实的假设都是整个历程的律。所以给定界与不给定界在静止之步上没有差别；差别在于沉默：给定界的学习者在 2N − 1 之前不说，因而处处不被否证（`withBound_holds`）；不给定界的学习者要在每个 N 上都于 2N − 1 静止，就必须在较小的界上已说，因而在较大的界的历史上被否证（`rest_without_bound_refuted`）。

**读法（AI 的，待 Ren）。** Ren 推测“the full "truth" can be derived, situationally, including the cognition/controller part”。§97 的读法是：“按情境”就是界。这里更进一步：推出不需要知道界，只需要界成立。在有界的世界中，一个不知道界的认知者，以记录所容许的最简的律作主张，与知道界的认知者同样早地得到律；知道界只让它在那之前不出错。读法是 AI 的，Ren 的判断未给出。

**作者反审。**
1. **已知的结果。** 以与数据一致的最简假设作主张（Occam 式、按大小枚举的一致学习者）在归纳推理中是标准的；Gold（1967）的极限中的辨识与按枚举的辨识亦然。增量是：在核心中不用公理地给出确切的静止之步 2N − 1，表明它对每个学习者最优且与是否被给予界无关，并把界的作用精确为沉默（refuted nowhere）。
2. **按否证学习者。** `Becoming.Learning` 的按否证学习者只在被否证时前进一个假设，不跳到第一个一致的；它自己的确切静止之步仍未表明。`learner_rests` 保留。
3. **可判定性。** `leastBound` 要值可判定，与 `withBound` 相同；两条否定的定理不要。可判定性清点中 `leastFit` 与 `leastBound` 归为“首个符合者”。
4. **名字。** `leastFit`、`leastBound`（以最小的界）、`rest_earliest`、`rest_without_bound_refuted` 都是结构性的名字。

**检查。** 在暂存区对 main ff1f2957 编译：`Becoming.Identification` 74 项定理、94 项声明；没有错误或警告，公理报告为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`；证明不用 `simp`、`omega`。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 134. 外围证明接入脊柱（整合 I3d）：经约化的判者、经部分的读取、汲取而不补充的水平；对齐方向的比较即 BetterAt

2026-10-15。延续 §124、§127、§129 的 I 列（Ren：“push as far as possible, as strong as possible, generally agree with your direction - but i also realize - a lot proofs are probably not integrated”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-likeness-readings.md)）。I3c 之后主证明仍在脊柱运行之外的 6 项，I3d 全部取来：material-preparation-output、growth-constrained-fragmentation、risk-certificate-outcome-distinction、binding-preserving-substitution、renewing-consuming-formation、alignment-direction-g0-j。§129 把其中五项归为具体构造、工具或文档、待 I4，一项待 E 列；再读之下，每一项的主定理都有一般律之形，只是其中五项所需的律核心原先没有。所以 I3d 在四个既有核心模块中各加一段律（不新增核心模块），在桥接中加一段，另写四个外围实例模块，各有检查器，核心不导入它们。对 alignment-direction-g0-j，按整合者的约定，论断、Ren 的话与 G0 的折叠都不变，只加一个确切的实例。

```text
Result(s): 改写 6 项记录（脊柱别名、核心／桥接与实例模块的引用、实例回执与绑定、依赖、历史）：
           material-preparation-output、growth-constrained-fragmentation、risk-certificate-outcome-distinction、
           binding-preserving-substitution、renewing-consuming-formation、alignment-direction-g0-j；不新增记录
Delta: 核心：Becoming.Readout 加列出之族的判断与经由部分的读取（15 → 22 项定理），Becoming.Copying 加 empties_iff（68 → 71），
       Becoming.Stock 加所汲取而不补充的水平（40 → 46），Becoming.Feedback 加 closure_iff_certified、not_within_of_closed（100 → 102）；
       桥接：Becoming.Bridge 加保护优先比较的框架与对齐实例（113 → 120），导入 AlignmentDirection；
       外围实例模块及其检查器：PreparationCorrespondence（14 项定理／16 项声明）、JudgingCorrespondence（4／7）、
       RenewingCorrespondence（10／13）、SubstitutionCorrespondence（4／10）
Supplied premises / correspondence: 核心律不加前提；各实例沿用原模块的前提（所给配方、局部生产律与存量；生长史与采样；
           两条有限事件律、等权与三分之一界；无恢复的磨损律；有限类型项语言与求值；J1–J4 与约定的 AI 服务选择）；
           代入引理是外围的定理，核心给出判据
Evidence: 核心与桥接由核心运行审计（回执 20261015T161154.555289Z）；四个外围检查器各自实跑（回执 20261015T161348.626052Z、20261015T161403.083389Z、20261015T161417.899487Z、20261015T161423.129149Z），
          闭包中每个其他模块的当前字节都有通过的回执
Boundary: 见下文“边界”
Integration: §9 四行新增、五行计数（随核心运行）；六项记录；四个外围检查器
```

**测量。** 以落地回执，`SPINE-INTEGRATION.py`：在脊柱上陈述 184 → 190，运行之外 5 → 0，无 Lean 证明 10；较宽口径（引用某项脊柱证明）188 → 194。主证明在脊柱运行之外的记录已无。四个外围实例模块不在脊柱运行之内（需 Std 的策略或 Mathlib）：五项“在脊柱上陈述”，是指其别名命名所实例化的核心律，实例由各自的检查器实查；对齐一项的实例在桥接之内，随核心运行审计，公理报告为空。

**列出之族的判断（Becoming.Readout，不加前提）。** 一个判者只读约化值 `π s`。它对列出之族的每个成员都给出观测 `f`（`Judges`），恰当 `f` 在约化所合并的成员间一致（`LumpedOn`；`judges_iff_lumpedOn`）。由右向左不用选择：判者以每个约化值的第一个列出成员作答（`firstJudge`），无列出成员处答以给定的 `d`。故约化合并两个观测所分开的成员时，没有这样的判者（`no_judge_of_merged`）。

**经由部分的读取（Becoming.Readout，不加前提）。** 一个构型有诸部分（`part s p`），一族读取各读构型（`read c s`）。每个读取只经部分读取（`ThroughParts`：在每部分一致的构型被读作一样），且每部分都被某个读取直接读出（`ReadsDirectly`）时，两构型在每个读取下一致，恰当在每部分一致（`agree_iff_parts`）。于是，替换的每个读取都是它所供给之构型的读取时，替换在每个读取下与原物一致，恰当所供给的构型在每部分与原物一致（`supplied_agree_iff_parts`）。两个条件各有所用：不读某部分的读取在那部分上不能分辨；而若读取不只经部分，部分一致推不出读取一致。

**复制使池用尽（Becoming.Copying，不加前提）。** 自池逐记号复制一词，池最后为空，恰当池中每个记号恰如词中所用，且空闲支持覆盖各次接合的汲取（`empties_iff`）。移去之后，每个记号的计数即原计数减去词中的计数（`countOf_removeAll`）。

**所汲取而不补充的水平（Becoming.Stock，不加前提）。** 每步之后所存加所汲取不超过之前所存时（`FallsBy`），沿任何历程，终存加汲取总和不超过初存（`trace_falls`）；每步如此，恰当每个历程如此（`falls_iff`）。此外正水平上每步都有所汲取时，与初存一样长的历程止于零（`exhausted_within`，经 `trace_exhausts`），零处的步不汲取（`draws_nothing_from_empty`）。

**闭包的证书（Becoming.Feedback，不加前提）。** 一个区域恰是一个形成在关系下的闭包，当且仅当它含该形成、对关系封闭、且在闭包之内（`closure_iff_certified`）；在有限的情形，这几项可由有限计算核查。含一形成而不含另一形成的封闭区域分开二者：后者不在前者的闭包之内（`not_within_of_closed`）。

**保护优先的比较即配置的比较（桥接，公理报告为空）。** `PracticalJudgment.Better protect gain` 的选项，是一个无步之框架的配置：左边实现所保护的论断，右边实现所得（`Judgment.frame`）。以所保护者为 basic、所得为 living，这一比较恰是 `BetterAt`（`Judgment.better_iff_betterAt`），前沿亦同（`Judgment.frontier_iff`）。此前桥接只说 `BetterAt` 由 `Better` 定义；现在反过来也成立：每个保护优先的比较都是某个框架上的 `BetterAt`。

**材料准备与碎裂（PreparationCorrespondence）。** `route` 完成、池中余 `rest`、支持余 `left`，恰当每次接合汲取一单位的复制如此（`route_some_iff`）。故由 `Copying.empties_iff`，准备完成且池用尽，恰当池是配方的排列、且配方不长于支持，所余支持为支持减去配方长度（`preparation_empties_iff`、`preparation_leaves`），即 material-preparation-output 的论断。由键相连，即在对称读取之键下的闭包之内（`connected_iff_within`）；含根且对每条余下之键封闭的分量即该闭包（`component_is_closure`，由 `closure_iff_certified`），故 `certificate_exact_split` 由核心律给出（`certificate_exact_split_by_core`），证书确认的切割分开两端（`cut_separates`，由 `not_within_of_closed`）。组成相同的两个生长图切割回报不同（`returns_differ`），故由 `Readout.no_judge_of_merged`，亲代摘要的任何函数都不同时给出二者（`no_parent_summary_predictor_by_core`）。

**先验风险证书（JudgingCorrespondence）。** 每条律与它的每个模式是一个容许的实现，所列诸律的实现是一个列出的族（`realizations`）；所到终点是实现的约化（`endpoint`），律是否以三分之一为路线 0 之风险的界是观测（`certificate`）。外围的判者陈述即核心在此族上的 `Judges`（`judges_iff`）。于是只看终点的判者对每个容许实现分类证书，恰当到达同一终点的实现带同一证书（`endpoint_judge_iff`，由 `judges_iff_lumpedOn`）。均匀律与偏倚律的模式 1 到达同一终点，而界对前者成立、对后者不成立，故 `no_endpoint_only_prior_certificate` 由 `no_judge_of_merged` 给出（`no_endpoint_only_prior_certificate_by_core`）。

**更新与消耗型形成（RenewingCorrespondence）。** 超出当前更新率的步是一个过程的步，每步记录压力与所形成者（`beyond`）。每步之后，所余之界（所持条件加三角形更新界，外围称 `budget`）至少减去所形成者（`remaining_falls`，即 `Stock.FallsBy`）；该界为正处总有所形成（`forms_while_held`）。两者都来自外围的 `beyond_step`。超出当前更新率之历程的前 n 步是该过程的轨迹（`path_trace`），所汲取的即所形成的总和（`total_moves`）。于是由 `Stock.trace_falls`，整个展开的形成以该界为限（`beyond_current_bounded_by_core`）；由 `Stock.exhausted_within` 与 `draws_nothing_from_empty`，自等于该界之时起不再形成（`beyond_current_ceases_by_core`）；分给任何部分的份额，含共享形成，随之终止（`shared_formation_ends_by_core`）。

**保留绑定的代入（SubstitutionCorrespondence）。** 对一个语境的赋值，是以位置为部分的构型（`part`）；一个消费者，即带形式的项，以求值读它（`read`）。求值只经位置读取（`through`，用函数外延），位置的直接使用读出该位置（`direct`）。外围的代入引理（`extract_substitute`）说，替换后每个消费者的读取，即它对生产者所供给之赋值的读取（`supplies`）。于是由 `Readout.supplied_agree_iff_parts`，全部消费者在代入前后求值相同，恰当每个生产者在其位置给出原来的根据（`all_terms_agree_iff_positions_by_core`）。核心给出判据；代入引理，即求值与代入可交换，仍是外围关于其语言的定理。

**对齐方向（桥接）。** `AlignmentDirection` 对计划的比较 `Better protection realization`，即框架 `Judgment.frame protection realization` 上的 `BetterAt`（`alignment_better_iff_betterAt`），合格计划的前沿亦同（`alignment_frontier_iff`）。故转移优于扩张（`transfer_over_expansion`）与扩张被排除出前沿（`expansion_excluded`）是脊柱上比较的陈述。记录的论断、Ren 的话与 G0 的折叠都不变：`BetterAt` 陈述 J1/J2，是核心之外的公开承诺，这里不用也不断言 G0。以需求为指标的覆盖（`Covered`：只有承诺而无交付的接替不覆盖需要）在脊柱上没有确切的对应：`Becoming.Wholes` 的 `Web.Covered` 说部分自某步起覆盖每一步，不以需求为指标。故这两条留在外围，记录如此注明。

**作者反审。**
1. **新律还是重述？** 五段核心律都是一般的、不加前提的律，外围定理是其实例。`agree_iff_parts` 的证明很短：它的内容是把“全部消费者”判据拆成两个可分别核查的条件，其中“只经部分”由外围的代入引理承担。`judges_iff_lumpedOn` 的实质在由右向左：判者不用选择而构造出来。
2. **对齐一项是否确切？** 等价对每对计划都成立，故是确切的实例，不是近似。但它只把 J1/J2 的比较放到配置上，不给出 G0 或 J1–J4 的根据，也不使任何部署遵循它。
3. **§129 的归类为何改变？** §129 把这五项看作具体构造或工具。重读之下，它们的主定理各有一般律之形：经约化的判者、经部分的读取、闭包的证书、汲取而不补充的水平、复制使池用尽。具体的构造仍在外围；接入的是律。
4. **公理。** 核心与桥接的新声明公理报告为空。外围实例只用标准公理：SubstitutionCorrespondence 只用 Quot.sound（函数外延）；PreparationCorrespondence 的置换对应用库的 Classical.choice；其余用 propext 与 Quot.sound。

**边界。** 核心律只在其所陈述的条件下成立；哪个约化、哪些部分、哪个水平对应一项实际活动，随每项应用给出。外围实例保持原模块的范围（前提见上）：三分之一的界是数值规定，不是伦理许可；磨损律是所给的；代入引理只关于所给的有限类型项语言；对齐的实例不证明服从、部署可靠性或 G0 的无公理必然性。六项记录的旧回执保留；新别名绑定到核心回执与四个外围回执。

**下一步（I 列）。** 主证明在脊柱运行之外的记录已无。I 列余下 I4（约 500 个模块的归类），待 Ren。

## 135. 继承模块中的记录接入脊柱（整合 I3e）：列出之选项中不被胜过者；弱排中与排中两条界

2026-10-15。延续 §124、§127、§129、§134 的 I 列（Ren：“push as far as possible, as strong as possible, generally agree with your direction - but i also realize - a lot proofs are probably not integrated”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-14-likeness-readings.md)）。I3d 之后，主证明在脊柱运行之外的记录已无；主证明在继承模块中的还有 7 项。I3e 取其中两项：organizational-formation-from-generative-comparison 与 practical-judgment-g0-j。两项的主定理都是“有限菜单上有不被胜过的选项”及其推论，外围以经典推理证明（`PracticalJudgment.finite_frontier` 用 `classical`）。核心原先没有这条律。I3e 在既有核心模块 Becoming.Decidedness 中加一段律（不新增核心模块），说明它所需的恰是什么；在桥接中加三条定理，另写一个外围实例模块，有自己的检查器，核心不导入它。按整合者的约定，practical-judgment-g0-j 只改引用、别名与历史；论断、Ren 的话与 G0 的折叠都不变。

```text
Result(s): 改写 2 项记录（脊柱别名、核心／桥接与实例模块的引用、实例回执与绑定、历史）：
           organizational-formation-from-generative-comparison、practical-judgment-g0-j；不新增记录
Delta: 核心：Becoming.Decidedness 加列出之选项中不被胜过者（55 → 65 项定理），含两条边界定理；
       桥接：Becoming.Bridge 的判断框架一节加 frontier_iff_undominated、frontier_exists、required_of_bettered（120 → 123）；
       外围实例模块及其检查器：OrganizationCorrespondence（3 项定理）；
       可判定性清点：只在证明中用到 188 → 193（逐条分类），证明可判定者 131 → 132，边界句加两条定理
Supplied premises / correspondence: 核心律不加前提，弱判定与判定是各条律自己的条件；实例沿用原模块的前提
           （有限非空且确切列出的合格选项、非自反传递的比较、每个缺少组织关系的接续都有更好的合格构造、所构造的协调情形）；
           规范解释继承公开的 J 承诺
Evidence: 核心与桥接由核心运行审计（回执 20261015T163210.426211Z）；外围检查器实跑（回执 20261015T163336.437151Z），闭包中每个其他模块的当前字节都有通过的回执
Boundary: 见下文“边界”
Integration: §9 一行新增、两行计数（随核心运行）；两项记录；一个外围检查器；可判定性清点
```

**测量。** 以落地回执，`SPINE-INTEGRATION.py`：在脊柱上陈述 190 → 192，继承模块中 7 → 5，运行之外 0，无 Lean 证明 10；较宽口径（引用某项脊柱证明）194 → 195。外围实例模块不在脊柱运行之内（需 Std 的策略与 Mathlib 路径）：组织形成一项“在脊柱上陈述”，是指其别名命名的核心律与桥接定理；实例由检查器实查。

**列出之选项中不被胜过者（Becoming.Decidedness，不加前提）。** 一个命题弱判定，是说它不成立，或它的不成立被否证（`WeaklyDecided p`：`¬ p ∨ ¬ ¬ p`）；判定者都弱判定（`Decided.weakly`）。一个非空的列出选项表上，比较在表上非自反、传递，且一个选项是否胜过另一个弱判定时，有不被表上任何选项胜过的选项（`exists_undominated`）。证明沿列表走一遍：保留后面的选项中尚无一个被知道胜过它的那个，不用选择，也不用排中律。对一个性质，若缺之的每个选项都被表上某选项胜过，则不被胜过者不能缺少它（`Undominated.not_not_has`，不用判定），性质判定时它就有（`undominated_has`）。反之，比较判定时，若不被胜过者都有该性质，缺之的每个选项都被某选项胜过（`bettered_of_undominated_has`）。故比较与性质都判定时，不被胜过者都有该性质，恰当缺之的每个选项都被胜过（`undominated_has_iff`）。

**两条界（Becoming.Decidedness）。** 整合者要求：去掉判定若恰是排中律，就写成边界定理。结果分两层。
- 要求对每个关系成立时，存在之律所需恰是弱排中律（`exists_undominated_iff_weakly`）。在两个选项上，取 `Opposed p`：`true` 胜过 `false` 恰当 `p`，`false` 胜过 `true` 恰当 `¬ p`。它非自反、传递，且不需判定。`false` 不被胜过恰当 `p` 不成立，`true` 不被胜过恰当 `p` 的不成立被否证。所以完全的判定不是存在所需的：弱判定足够，而且在全部关系上必需。
- 要求对每个菜单、关系与性质成立时，去掉性质的判定恰是排中律（`undominated_has_iff_em`）。在只有一个选项、没有关系的菜单上，以“`p` 已判定”为性质：缺之者被胜过的条件成立（`p` 是否判定，其否定被否证），结论就是 `p ∨ ¬ p`。
两条都列入可判定性清点的边界定理。

**桥接（公理报告为空）。** 在确切列出的选项表上，`PracticalJudgment` 的前沿即核心的不被胜过者（`Judgment.frontier_iff_undominated`）。于是比较非自反、传递且弱判定时，前沿非空（`Judgment.frontier_exists`）。这就是 `PracticalJudgment.finite_frontier`，不用经典推理。任务也判定时，前沿非空且每个成员都完成任务（`Judgment.required_of_bettered`），即 `RelationalOrganization.formation_required_of_improvable_absence`，同样不用经典推理。

**组织形成（OrganizationCorrespondence）。** 外围的定理以 `Classical.em` 供给核心所要求的判定：`formation_required_of_improvable_absence` 由 `exists_undominated` 与 `undominated_has` 给出（`formation_required_by_core`），所构造的协调情形亦然（`coordination_is_required_by_core`，用外围的 simp 引理）。在确切列出的菜单上，前沿即不被胜过者（`frontier_iff_undominated`），公理报告为空。

**一般实践判断（桥接）。** practical-judgment-g0-j 的比较已在 I3d 读作 `BetterAt`（`Judgment.better_iff_betterAt`、`Judgment.frontier_iff`）。现在它的有限前沿也是脊柱上的律（`Judgment.frontier_exists`，经 `Becoming.exists_undominated`）。记录的论断、Ren 的话与 G0 的折叠都不变：`BetterAt` 陈述 J1/J2，是核心之外的公开承诺，这里不用也不断言 G0。`Robust` 即核心的 `CommonResponse`（既有）。以需求为指标的覆盖（`Covered`）在脊柱上没有确切的对应，留在外围（同 §134）。

**留在继承模块中的五项，及理由。**
1. derivation-soundness、finite-basis-common-interpretation：健全性与归约属于 InquiryRoot 的推导演算（`Derives`）。桥接把它们读到核心的 `Scope` 上（`derivation_sound_on_scope`、`common_on_scope_iff`，§127），但这些桥接定理的证明就是 InquiryRoot 的定理。核心没有推导演算；以它们为别名会把外围的证明说成脊柱的律。
2. positioned-positive-reason、positive-ground-open-futures：脊柱上的中心陈述已是别的记录的别名（`universal_reason` 属 metaethical-core-characterization，`every_situated_position_has_reason_of_unrestricted` 与 `contingent_generation_of_unrestricted` 属 one-axiom-yields-g0，定义的同一属 becoming-spine-instances），别名须唯一。以明示 G0 为假设的形式、最小路线理由与有限积分仍只在继承模块中证明。
3. wisdom-root：是目标，不是定理；它的形式部分在 wisdom-root-part-one 中完成（§93）。

**作者反审。**
1. **新律还是重述？** `exists_undominated` 的外围形式是熟知的有限极大元存在。新的是它所需的恰是什么：弱判定足够；在全部关系上，弱排中律必需（`exists_undominated_iff_weakly`）。另一条是：去掉性质的判定恰是排中律（`undominated_has_iff_em`）。没有判定时，律仍给出不被胜过者不能缺少该性质（`Undominated.not_not_has`）。
2. **实践判断一项是否确切？** `exists_undominated` 的结论即 `finite_frontier` 的结论，`frontier_exists` 把它读作前沿（`frontier_iff_undominated`）。核心的形式把比较的弱判定写成前提，证明不用经典推理；以经典推理，这一前提总成立，故外围定理是它的实例。比较是 J1/J2 的 `Better`，已由 I3d 的 `better_iff_betterAt` 读作配置上的比较。实际交接中以需求为指标的覆盖（`Covered`）仍在外围，记录如此注明。
3. **公理。** 核心与桥接的新声明公理报告为空。外围实例：`frontier_iff_undominated` 为空，另两条用 propext、Classical.choice 与 Quot.sound（经典判定与外围的 simp）。

**边界。** 核心律只在其所陈述的条件下成立；哪个菜单、哪个比较对应一项实际选择，随每项应用给出。组织形成的实例保持原模块的范围：比较、合格性与所构造的历史是所给的，规范解释继承公开的 J 承诺，不证明服从或部署。两项记录的旧回执保留；新别名绑定到核心回执与外围回执。

**下一步（I 列）。** 主证明在运行之外的记录已无。继承模块中的五项按上文的理由留下，无 Lean 证明的十项不是待接入的证明。I 列余下 I4（约 500 个模块的归类），待 Ren。

## 136. 按否证学习者的静止之步是立方阶的；一个世界之内检验的 N − 1 恰好（P83g）

2026-10-15，[identification-where-bounded](../../../../theories/becoming/results/records/identification-where-bounded.md) 与 [tests-fix-likeness-where-determined](../../../../theories/becoming/results/records/tests-fix-likeness-where-determined.md) 余下的两项小的开放问题。依据 Ren 2026-10-15 的“let's finish Still open, all minor”。工作板上认领为 P83g。编辑 `Becoming.Identification`（以最小的界一节之后新增一节）与 `Becoming.Distinguishing`（一条定理），只增加声明，已有声明不变；不加公理，不加前提。

```text
Result(s): 复用 identification-where-bounded（lassoPos_early、lassoPos_period、statesBelow_iff_lasso、learner_rests、
           leastBound_exact）；learning-by-refutation（Learning.learner、lassos、index、index_kept、index_refuted、lasso、
           lasso_claims、back_record、Refuted、not_refuted_self、pairAt、nextPair、lassoNext）；the-split-that-makes-sense
           （Negation.register）；recurrence-without-premise（gap_of_lt、Law.orbit）；tests-fix-likeness-where-determined
           （Law.sameTests_iff_within、Law.orbit_fin、finBelow、length_finBelow、mem_finBelow）；不新增记录，两项记录各增
           一条规律（第十六条）
Delta: Identification.cyclePos、oddCycle、oddCycle_below、even_shift_runs、odd_shift_runs、unit_shift_refuted、turnHeld、
       turn_pair、turn_end、turn_walk、turn_double、start_turn、turn_diagonals、learner_refuted_late、learner_rest_cubic
       （及其辅助引理，共 34 项声明）；registered_within_exact
Supplied premises / correspondence: 不加公理；立方阶的定理陈述在两个值（Bool）上，值已判定
Evidence: scratch_build 对 main 0d93e617：Becoming.Identification 105 项定理、128 项声明（P83f 为 74、94），
       Becoming.Distinguishing 11 项、12 项，Becoming.Learnable 重建，公理报告为空；核心检查器回执待整合者的运行；
       穷举计算的程序与结果在 development/becoming-p83g-rest-search
Boundary: 按否证学习者确切静止之步的常数没有证明（下界 (N³ − N)/4，上界 N + (2N − 1)·tri N；穷举得奇数 N 时为
       (N³ − N)/4 + 3，是计算）；下界只对奇数 N 陈述；不含伦理谓词
Integration: identification-where-bounded 的“按否证学习者自己的确切静止之步”在阶上回答，next_delta 只留 Ren 的判断；
       tests-fix-likeness-where-determined 第十四条规律的 N − 1 在一个世界之内恰好
```

| 声明 | 内容 |
|---|---|
| `cyclePos`、`oddCycle`、`oddCycle_below` | **奇数个位置的环上的否定。** 位置沿 N 个位置的环前进（`Learning.lassoNext 0 (N − 1)`），值是位置上的二值否定（`Negation.register`）。N 为奇数时否定不能绕环闭合，每转一圈断一次（两个相同的值相接）。它至多有 N 个状态 |
| `even_shift_runs` | **偶数位移跑到一圈的末尾。** 声称 2e + 2 步之前的值的假设，从一圈中至少 2e + 2 的位置起被持有，到这一圈末尾都对，在下一圈的第一个位置被否证 |
| `odd_shift_runs` | **奇数位移跑到它自己的位置。** 声称 2e + 1 步之前的值的假设，在第二圈及以后的一圈中、位置 2e + 1 之前被持有，在那之前都对，在位置 2e + 1 被否证 |
| `unit_shift_refuted` | **位移一立即被否证**，在一圈之内的任何位置 |
| `turnHeld`、`turn_pair`、`turn_end` | **一圈一个偶数位移。** 一圈的第一步之后持有一个奇数位移时：它不在对角线末尾，则它与其后的偶数位移在这一圈之内与下一圈开始时被否证；它在（奇数长的）对角线末尾，则它、开启下一条对角线的位移一与位移二同样用去这一圈。两种情形下，下一圈的第一步之后学习者都持有一个奇数位移 |
| `turn_walk`、`turn_double`、`start_turn`、`turn_diagonals` | **对角线成对。** 沿一条对角线每对位移花一圈；对角线 2c + 2 与 2c + 3 合起来花 2c + 3 圈；所以第 (c + 1)² 圈的第一步之后，学习者持有对角线 2c + 2 的开头 |
| `learner_refuted_late` | **在立方阶的一步被否证。** N = 2m + 3 时，学习者在第 (N³ − N)/4 = (2m + 3)(m + 1)(m + 2) 步被否证：持有周期 N 的假设之前，(N² − 1)/4 个偶数位移每个花去整整一圈 |
| `learner_rest_cubic` | **静止之步在立方阶之后。** 使学习者在每个至多 N 个状态的二值历史上都对的一步在 (N³ − N)/4 之后 |
| `registered_within_exact` | **一个世界之内 N − 1 恰好。** 对每个 N = M + 2，Fin N 上走到停住的最后一个、只识是否到了最后的路径，世界由 N 个成员的列表（`finBelow`）持有；前两个位置所识的未来在 N − 2 步内一致而不通过相同的检验 |

**它回答了什么。** §97 与 §133 留下按否证学习者自己的确切静止之步。§133 已表明对所有学习者最优的是 2N − 1，按否证学习者的上界 N + (2N − 1)·tri N 是立方阶的。这里表明这一上界在阶上不粗：在奇数个位置的环上的二值否定上，学习者在 (N³ − N)/4 被否证。所以一次否证一个假设的学习与以最小的界读记录的学习，差别在立方阶与线性之间：两者都静止，差在何时。确切的常数没有证明。对至多 N 个状态的历史穷举（二值 N ≤ 17，三值 N ≤ 9），奇数 N ≥ 3 的最坏静止之步是 (N³ − N)/4 + 3，达到它的是同一否定从另一个位置开始；偶数 N 从 12 到 16 是 N − 1 的值加一。这是计算，不是证明。§132 中检验的 N − 1 只在律下封闭的列表上由 `Law.sameFuture_classes_exact` 给出恰好；这里对整个由 N 个配置持有的世界（Fin N）给出。

**读法（AI 的，待 Ren）。** 推出可以不知道界，但怎样读记录决定何时推出：一次否证一个假设的认知者也会推出律，只是比以最简的律读记录的认知者晚一个立方阶。奇数的环上的否定正是使它迟的世界：它每圈断一次，使大半假设在一圈之内看来成立。读法是 AI 的，Ren 的判断未给出。

**作者反审。**
1. **已知的结果。** 按枚举的辨识（Gold，1967）的代价随枚举次序而变，这是已知的。增量是：对这一枚举（Cantor 次序的套索假设），在核心中不用公理地给出立方阶的下界及其见证，与 §133 的线性最优对照。
2. **上下界之间。** 上界首项 N³，下界 N³/4；确切常数没有证明，穷举值作为计算记录，不作为结果。
3. **偶数 N。** 下界只对奇数 N 陈述；偶数 N 可由 N − 1 的下界得到（状态数的界单调，`statesBelow_mono`），没有单独陈述为定理。
4. **名字。** `oddCycle`（奇数个位置的环上的否定）、`turnHeld` 与 `turn_*`（圈）、`*_shift_*`（位移）都是结构性的名字。
5. **证明。** 不用 `simp`、`omega`；`Nat.le_of_add_le_add_right` 引入 propext，换成本节的 `le_of_add_right`。

**检查。** 在暂存区对 main 0d93e617 编译：`Becoming.Identification` 105 项定理、128 项声明，`Becoming.Distinguishing` 11 项、12 项，`Becoming.Learnable` 重建；没有错误或警告，公理报告为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 137. 任意多条件下最小的识：读有限多个条件的律经其敏感而读，尾需要全知（Becoming.Sensitivity）

2026-10-15。P80 的记录 [counterfactual-is-the-course](../../../../theories/becoming/results/records/counterfactual-is-the-course.md) 的 next_delta 问：条件无穷多时，敏感是否仍是最小的识，或有反例；`Becoming.Counterfactual` 把这一点列为没有导出，理论第 8 节的进一步证明在“反馈与所及”下亦列它。Ren 2026-10-12 的目标：“move towards 100%, you can spawn a few agents for help, pick the "What would move it most next" first, and don't stop until we are 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）。本节在第一部分之内回答：不加公理，除各律所写者不加前提。工作板上认领为 P113。

```text
Result(s): 新增 sensitivity-is-the-least-registration；回答 counterfactual-is-the-course 的 next_delta 中“条件无穷多时敏感是否仍是最小的识（或反例）”；
           复用 counterfactual-is-the-course（ExchangeLaw、GivesAlike、Nonanticipating、Through、InsensitiveAt、Sensitive、mixIn、
           mixIn_listed、mixIn_alike、swap_alike、nat_eq_of_not_not、ExchangeLaw.Through.registers_of_sensitive、comparison_of_courses、
           ExchangeLaw.Nonanticipating.through_sensitive）；Becoming.Change 的 LPO
Delta: 新核心模块 Becoming.Sensitivity（只导入 Counterfactual；47 项定理／58 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各律所写者写在定理中：律读有限多个条件（ReadsFinitely）或读已立者（Nonanticipating）、
       条件的相等可判定（只在混合条件处）；尾之律以水平是否终将消失的判定为假设；全知原则的两条定理以条件以自然数编号
Evidence: scratch_build 对 main 108e278e（P109、P83e、P83f、I3d、I3e 与 P83g 之后）：Becoming.Sensitivity 47 项定理、58 项声明，公理报告全部为空，
          无警告；根模块 Becoming 与其导入闭包（110 个模块）一同编译，无重名；清点在同一字节上运行，每一新行都已分类；
          合并检查器回执待整合者的运行
Boundary: 离散的步；敏感是有或无，不陈述其度量；“每个律都读有限多个条件”不导出（连续性原则，独立于核心）；
          反例之存在的确切强度开放；不含伦理谓词
Integration: §9 新增一行；§8 的进一步证明、状态行、Ren 的选择与逻辑承诺各改一项；回应由动力学给出一段中的“不推出”；
       第一部分的总陈述一条；术语表一行改、一行新增；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列；
       Lean README 一行与层内导入；DECIDABILITY-INVENTORY.py 的分类；一项新记录与一项配对说明
```

**一、读有限多个条件。** 在步 `t`、对形成 `h`、在水平历史 `l` 下，律读一个条件列表 `cs` 之内，是说每个在 `cs` 的条件上直到 `t` 都与 `l` 相同的历史，与 `l` 交换相同（`ExchangeLaw.ReadsWithin`）。律读有限多个条件，是说它在每一步、对每个形成、在每个历史下都读某个列表之内，列表可随历史而变（`ExchangeLaw.ReadsFinitely`）。这就是律作为水平历史之函数的逐点连续性：值由有限多个坐标固定，所需的坐标随点而变。这样的律读已立者（`ExchangeLaw.ReadsFinitely.nonanticipating`）。条件有限时，每个读已立者的律都读有限多个条件，列表就是全体条件（`ExchangeLaw.Nonanticipating.readsWithin_of_every`、`ExchangeLaw.Nonanticipating.readsFinitely_of_every`）。条件无穷多时，“随历史而变”不能去掉：一个形成与每个条件交换的，是步 `0` 时条件 `0` 的水平所指那个条件在步 `0` 的水平；它在每个历史下读两个条件（`Pointer.readsWithin`、`Pointer.readsFinitely`），却不在任何一个列表之内读所有历史（`Pointer.no_list`）。

**二、敏感是最小的识，条件任意多。** 读已立者的律在两个于其所敏感者上相同的历史下交换相同，只要它在其中一个历史下读某个列表之内（`alike_of_sensitive_agree_within`）。证明如 `Becoming.Counterfactual`：把列出的条件一个一个换成第二个历史的水平（`mixIn`），敏感的条件两者本来相同，不敏感的条件单独改变不改变交换；换完的历史在列出的条件上与第二个历史相同，于是交换相同。所以读有限多个条件的律，经每个观察其所敏感者的识而读（`ExchangeLaw.ReadsFinitely.through_of_observed`），经其敏感而读（`ExchangeLaw.ReadsFinitely.through_sensitive`）；它所经的每个识，连同形成所依存的，都不漏掉其敏感的任何条件（`ExchangeLaw.Through.registers_of_sensitive`），所以敏感是它所经的最小的识（`ExchangeLaw.ReadsFinitely.least_registration`）。由动力学给出的比较对这样的律在任意多的条件下成立，所经的识就是律的敏感（`comparison_through_sensitivity_of_readsFinitely`，经 `comparison_of_courses`）。`Becoming.Counterfactual` 中条件有限的情形是一个列表含全体条件的实例（`ExchangeLaw.Nonanticipating.through_sensitive_of_every`）。

**三、依存于整体者依存于某个部分。** 律在某步对每个条件都不敏感时，它在两个历史下交换相同，只要它在其中一个历史下读某个列表之内（`mixIn_alike_of_insensitiveAt`、`alike_of_insensitiveAt_within`）。读有限多个条件、又不敏感于任何条件的律，在每两个历史下交换相同（`ExchangeLaw.ReadsFinitely.alike_of_insensitive`）：不被任何单个条件改变者，根本不被改变。

**四、尾。** 条件无穷多时，第一点的条件不能去掉。水平序列 `α` 从某个条件起消失（`VanishFrom α`：存在 `n`，此后每个条件的水平为零）；在某个条件之后相同的两个序列一起消失或一起不消失（`VanishFrom.of_agree`）。给定对每个序列是否消失的判定，消失的指示（`vanishIndicator`：消失取 `1`，否则取 `0`）不随任何单个条件改变（`vanishIndicator_eq_of_agree`），而全零与全一给出不同（`vanishIndicator_zeros`、`vanishIndicator_ones`）。尾之律让一个形成在每一步与每个条件交换步 `0` 的水平的这一指示（`tailLaw`）。它读已立者（`tailLaw_nonanticipating`），经识从任何一个条件起的全部条件而读（`tailLaw_reads_from`、`tailLaw_through_from`），在每一步对每个条件都不敏感（`tailLaw_insensitive`），所以不敏感于任何条件（`tailLaw_not_sensitive`），却在两个历史之间不同（`tailLaw_differs`）。它不经其敏感而读（`tailLaw_not_through_sensitive`；形成不依存于任何东西的网中，`tailLaw_not_through`），不读有限多个条件（`tailLaw_not_readsFinitely`），它所经的识没有最小的（`tailLaw_no_least_registration`：每个“从 `n` 起”的识都够，它们的交是空的）。

**五、每个反例都给出全知原则。** 弱有限全知原则 `WLPO`：每个布尔序列处处为假或否。`Becoming.Change` 的有限全知原则给出它（`WLPO.of_lpo`）；没有构造性证明给出它。条件以自然数编号时：读已立者的律，若两个历史在其所敏感的每个条件上直到 `t` 相同，在 `t` 却交换不同，就给出 `WLPO`（`wlpo_of_not_through_sensitive`）；律若在某步对每个条件都不敏感，在那里却在两个历史之间不同，也给出 `WLPO`，读不读已立者都一样（`wlpo_of_insensitive_differs`）。证明沿布尔序列混合两个历史：条件 `m` 取第二个历史的水平，恰当序列在 `m` 之前或在 `m` 处已有一个真（`seenBy`）；序列处处为假时混合就是第一个历史，有一个真时混合从那里起是第二个历史，逐个条件换回（`alike_of_agree_from_sensitive`、`alike_of_agree_from`）；混合与第一个历史交换是否相同，是两个数的比较（`mixed_decides`）。所以条件编号时，最小的识的反例不经全知原则不能给出。反过来，尾之律所取的消失之判定给出有限全知原则本身（`lpo_of_vanish_decided`，经 `seenBy_exists`：在序列的第一个真之前取 `1`、之后取 `0` 的水平消失，恰当序列有一个真）。所以反例之存在位于 `WLPO` 与消失之判定之间。

```lean
def ExchangeLaw.ReadsFinitely (law : ExchangeLaw F C) : Prop :=
  ∀ t h l, ∃ cs : List C, law.ReadsWithin t h l cs

theorem ExchangeLaw.ReadsFinitely.least_registration [DecidableEq C] (fin : law.ReadsFinitely)
    (W : Web F C) (part : F → Bool) :
    law.Through W law.Sensitive part ∧
      ∀ obs : F → C → Prop, law.Through W obs part →
        ∀ h, part h = false → ∀ c, law.Sensitive h c → ¬ ¬ W.Registers obs h c

theorem tailLaw_no_least_registration {W : Web Unit Nat} (free : ∀ t c, ¬ W.requires t () c) :
    ¬ ∃ obs : Unit → Nat → Prop, (tailLaw decides).Through W obs (fun _ => false) ∧
      ∀ obs' : Unit → Nat → Prop, (tailLaw decides).Through W obs' (fun _ => false) →
        ∀ c, obs () c → obs' () c

theorem wlpo_of_not_through_sensitive {law : ExchangeLaw F Nat} (na : law.Nonanticipating)
    {t : Nat} {h : F} {l l' : Nat → Nat → Nat}
    (agree : ∀ c, law.Sensitive h c → ∀ s, s ≤ t → l s c = l' s c) {c : Nat}
    (differs : ¬ (law.take t h l c = law.take t h l' c ∧ law.give t h l c = law.give t h l' c)) :
    WLPO

theorem lpo_of_vanish_decided (decides : ∀ α : Nat → Nat, Decidable (VanishFrom α)) : LPO
```

**读法（AI 的，待 Ren 或按 Ren 2026-10-15 的交托判断）。**
1. **识就是敏感。** 律在每个历史下读有限多个条件处，读作识，形成恰识其交换所能被改变者，一次一个条件；不需要另给列表，条件多少都一样。
2. **依存于整体者依存于某个部分。** 不被任何单个条件改变、又读有限多个条件的律，根本不被改变。依存于整体而不依存于其任何部分者是尾，如水平是否终将消失、长程平均：它在于无穷多个条件上不同、在任何一个上都相同的历史之间不同，给出它需要关于无穷的判定，构造不能给出。
3. **对照。** 尾之律是 Kolmogorov 零一律之尾事件不带概率的对应。“核心能给出的每个律都读有限多个条件”是 Brouwer 的连续性原则，它驳斥 `WLPO`；核心既不陈述也不驳斥它，所以最小的识在核心中对读有限多个条件的律陈述。

**作者反审。**
1. **新律还是重述？** `ExchangeLaw.ReadsFinitely` 是 Baire 空间上（离散的值）的逐点连续性；`Pointer` 是读坐标 `0` 所指之坐标的标准例子，逐点连续而无一致的模。“连续函数对每个单独坐标不变则为常值”与“对所敏感的坐标相同则值相同”是由有限改变连接任意两点附近的初等事实。条件有限的情形在 `Becoming.Counterfactual` 中已有。新的是四点合起来对一个未决问题的完整回答：（a）不需要条件有限，也不需要列表一致；（b）连续性不能去掉，消失之判定给出反例；（c）条件编号时，反例之存在给出 `WLPO`，所以在构造性核心中不能给出反例；（d）该判定给出 `LPO`。`WLPO` 即 Π⁰₁ 形式的排中律；“从某个条件起消失”是 Σ⁰₂ 形式（存在一个起点，此后皆零），其判定是该形式之排中律的实例（Akama、Berardi、Hayashi 与 Kohlenbach 2004 的排中律算术层级）。已知 `LPO` 恰是 `WLPO` 加 Markov 原则；反例之存在在这一层级中的确切位置没有陈述。
2. **是不是把连续性当作公理偷渡？** 不是：`ReadsFinitely` 写在用它的每条定理的假设中，核心不断言每个律连续，也不否定。条件有限时它是定理（`ExchangeLaw.Nonanticipating.readsFinitely_of_every`），不是假设。核心与经典逻辑及连续性原则都相容，因为两者它都不用。
3. **尾之律是不是病态的例子？** 它是“依存于整体而不依存于任何部分”的精确形式：`wlpo_of_insensitive_differs` 说每个这样的律都给出 `WLPO`，读不读已立者都一样。科学中的对应是长程行为：极限、长程平均、终将如何。对这样的量作反应的形成，正是最小的识失效之处：它所经的识可以从任何一处开始，没有最小的。
4. **双重否定。** `least_registration` 的第二部分给出 `¬ ¬ W.Registers`，与 `Becoming.Counterfactual` 相同；识是否成立不可判定时，这是不用判定所能得到的。
5. **范围。** 不含伦理谓词；离散的步；敏感是有或无，没有度量（敏感的多少与差别到达多少，理论第 8 节的进一步证明）；全知原则的两条定理只对以自然数编号的条件陈述；混合条件处用条件的相等可判定（`DecidableEq C`），如 `Becoming.Counterfactual`。

**检查。** 在暂存区对 main（108e278e，I3e 与 P83g 之后）编译：`Becoming.Sensitivity` 47 项定理、58 项声明，没有错误或警告，公理报告全部为空；根模块 `Becoming` 与其导入闭包（110 个模块）一同编译，没有重名；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`，证明不用 `funext` 与依赖 `propext` 的引理。清点（`DECIDABILITY-INVENTORY.lean`）在同一字节上运行（跳过回执核对）：陈述依赖可判定性者 331 → 347，只在证明中用到者 193 → 202，证明可判定者 132 → 136，取可判定族的定义 92 → 94，不用到者 0，每一新行都已分类。合并检查器在整合者的运行中检查。本节尚未经独立审查。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计新模块，再把新记录绑定到回执。`DECIDABILITY-INVENTORY.py` 把 `vanishIndicator` 与 `tailLaw` 记作造出指示的构造（其陈述以消失之判定为自己的条件），把最小的识的八条定理记作只在证明中分辨相同（混合条件，如 `Becoming.Counterfactual`），把 `lpo_of_vanish_decided` 记作只在证明中分情形；`WLPO.of_lpo`、`mixed_decides`、`wlpo_of_insensitive_differs` 与 `wlpo_of_not_through_sensitive` 的结论是已判定的命题，记为证明可判定的行。既有模块的字节不变。理论中回应由动力学给出一段原列“何时一个动作是部分自己的”为不推出，P109 落地时没有改；本节一并指向 `Becoming.Coupling`。

## 138. 散立的模块在共同基底上陈述：每条律是同一展开之历程的律（Becoming.Courses、Becoming.CoursesBridge；P114）

2026-10-16。Ren 2026-10-15 问：“so for our theories, they are proved in a dag order and can be all connected right?”（[测量](THEOREM-CONNECTIVITY.md)）。证明按有向无环的次序排列由 Lean 保证；在定理层面，main `c143e7d9`（P113 之后）的 6136 条脊柱定理中 971 条既不用到基础（过程族 `Generative.Process`／`Trace`、`Becoming.Frame`／`Run`，或世界族 `Becoming.World`／`Flow`／`Web`），也不被用到基础的定理所用；26 项有脊柱别名的记录只靠这样的定理。依 Ren 2026-10-11 “one theory, worked together”与 2026-10-14 “a lot proofs are probably not integrated”，本节在第一部分之内把这些模块的主律在基础上陈述：不加公理，不加前提，只有实例。两族是否由一族定义另一族（一个定义之根）不在此处，待 Ren。工作板上认领为 P114。

```text
Result(s): 不新增成果；26 项既有记录各得一个陈述到达基础的别名（成果与范围不变）：acquired-binding-compositional-use、
           binding-preserving-substitution、classification-robust-generative-comparison、control-coherence-loss、
           draws-on-a-shared-stock、enacted-scene-binding、encounter-selection-and-revision、fallible-witness-diagnosability、
           formed-copying-correction、formed-copying-registration、fulfillment-chance-floor、growth-constrained-fragmentation、
           historical-source-binding、inherited-structural-copying、losses-of-the-sum-over-histories、
           market-finite-support-obstruction、market-partial-correction-boundary、market-supported-finite-transition、
           material-preparation-output、organizational-formation-from-generative-comparison、reserved-shutdown-during-recovery、
           retrospective-source-binding、risk-certificate-outcome-distinction、separation-loses-the-relation、
           transition-grouping-word-partition、versioned-request-completion
Delta: 新核心模块 Becoming.Courses（L4；87 项定理、97 项声明）与新桥接模块 Becoming.CoursesBridge（3 项定理）；不改已有模块与定义
Supplied premises / correspondence: 不加公理与前提；每条实例的假设即所实例化之律的假设；对应是识别：受扰之律的可容许历史是受扰过程
       的运行，确定之律的轨道是其过程的历程，部分之律的运行是其过程的轨迹，带日期的历史是运行，约化运行是经约化而读之律的运行，
       网的步经条件水平而读，形成的系统是共享条件下的闭包，框架的构型是被比较的历史
Evidence: scratch_build 对 main c143e7d9：Becoming.Courses 87 项定理、Becoming.CoursesBridge 3 项，公理报告全部为空，无警告；
          根模块 Becoming 与其导入闭包一同编译，无重名；定理层面的测量（THEOREM-CONNECTIVITY.py）与清点在同一字节上运行；
          合并检查器回执待整合者的运行
Boundary: 只是实例；两族仍互不到达；799 条定理仍独立（380 条不被任何常量使用），整模块独立的 Quantum、Learnable 不被任何记录
          所依；不含新的伦理谓词（CoursesBridge 读既有的 J1/J2 比较，不用也不断言 G0）
Integration: §9 新增两行；Becoming.lean 的导入与模块说明；check_becoming.py 的核心与桥接之列；Lean README 一行与层内导入；
       DECIDABILITY-INVENTORY.py 的分类；THEOREM-CONNECTIVITY-DUMP.lean 导入新桥接模块；26 项记录的引用、绑定、别名与历史在落地时写入
       （becoming-p114-landing/apply_p114.py）
```

**一、识别。** 散立的模块对一个序列、一段历史、一个变化之律、一个池或一张构型列表陈述其律，所陈述的对象就是基础自己的对象。受扰之律 `f` 在可容许扰动下的历史，就是受扰过程 `Viability.disturbed f adm` 的运行（`run_history`、`run_admissible`；反之 `historyRun`）。确定之律 `next` 的轨道就是其过程 `Law.process next` 的历程：历程止于其长度处的轨道（`trace_orbit`），轨道第 `k` 处是 `k` 步历程的终点（`orbit_trace`），过程所到达者恰是轨道（`reach_iff_orbit`），`k` 步的计划完成恰当目标在轨道第 `k` 处成立（`completes_units_iff`）。部分之律的运行是其过程 `Assurance.ofPartial` 的轨迹。带日期的历史是运行；每种变化都被容许的过程（`anyChange`）使每个构型序列都是运行（`anyRun`）。一个运行的约化是经约化而读之律的运行（`reducedRun`，`Readout.image`）。

**二、主律在历程上。** 每条都是所实例化之律经上面的识别而得，假设不变。
- **持续与到达**（Lasting）：起点持续 `n` 步，恰当受扰过程从它出发、至多 `n` 个扰动的每条历程都留在护栏之内（`lasts_iff_courses`），所以恰当有梯级族或每个必要族在第 `n` 级含起点（`courses_iff_ladder`、`courses_iff_necessary`）；耗竭在每个运行上成立（`Drains.leaves_run`、`exhausts_run`）。确定之律永不到达目标，恰当一个含起点、避开目标的封闭集存在（`avoids_iff_closed_reach`、`some_avoids_iff_reach`、`fixed_avoids_reach`）；漏斗与盆在每个运行上到达（`Funnel.runs`、`basin_runs`），至多 `n` 步的历程到达恰当一个漏斗含起点，目标判定时恰当一个数值变式（`course_reaches_iff_funnel`、`course_reaches_iff_variant`）。
- **保留的出口与无燃料的工作**（Countdown）：被容许的计划作为部分之律过程的计划完成于有效构型，长于余量者完成于出口（`runs_valid_completes`、`exits_completes`）；无燃料的工作在 `work + 1` 步内完成，更短的每条历程都使任务待处理（`Advances.completes_plan`、`pending_before_course`）。
- **回溯**（Retrodiction）：以运行为历史，读对恰是每个对手运行被某个带日期的控制分开（`runs_reading_right_iff`、`runs_look_right_iff`）；两端的控制使其间的日期在每个运行上都已定，恰当至多容许一次变化或其间没有日期（`runs_settle_iff`）。
- **复制与检验**（Copying）：复制完成、产出该词、使池为空，作为其确定过程的计划，恰如复制之律所说（`copy_completes_iff`、`copy_built_iff`、`copy_empties_iff`），产物沿每条历程只增（`copy_grows`），经接触而读亦然（`reading_completes_iff`）；检验是一个过程，在忠实位置上的历程不使缺陷上升（`inspection_le_iff`、`inspection_course_le`）；共享一个池的复制是释放之律的历程（`every_released_iff_course`、`release_course_iff`、`lineage_course_iff`）。
- **词与解析**（Segmentation、CrossSituational）：每个词是从 `s` 回到 `s` 的历程时，每个由词组成者也是（`encode_course`），分组与读出对每条这样的历程成立（`course_words_iff`、`course_chunks_iff`、`no_run_record_groups`、`course_reads_iff`）；运行的诸步作为记录只收窄候选（`run_candidates_append`、`run_narrows`、`run_stays_iff`），解析恰是分开（`run_resolves_iff`、`run_resolves_explained_iff`、`course_resolves_every_iff`）。
- **约化、证人与质量**（Readout、Weighted）：约化不还原它所合并的两个运行，解码与判断恰在观察量于合并处相同时可能（`runs_no_restore`、`runs_decoder_pair_iff`、`run_judges_iff`、`no_run_judge_of_merged`）；网的两步在经条件的每个读法下相同恰当水平相同（`steps_agree_iff_levels`、`supplied_agree_iff_levels`）；运行在列出日期上的识是可错的证人（`run_reports_apart`、`dates_no_common_report_iff`、`dates_no_common_report_envelopes_iff`）；框架构型上主张的质量、网中对一个条件的汲取、环上历程的加倍（`claims_every_weighting_iff`、`claims_floor`、`selections_within_iff`、`supported_not_together`、`loop_courses_double`）。
- **系统、关系与前沿**（Feedback、Description、Decidedness）：形成的系统即共享条件下的闭包，由封闭区域证明（`system_iff_certified`、`not_within_system_of_closed`）；沿确定之律的历程，各自移动的部分保持无关，不合并的移动保持关系，复制关联，遗忘解除，耦合关联又解除（`courses_keep_unrelated`、`relation_persists_courses`、`copy_relates_course`、`forgetting_unrelates_courses`、`coupling_course`）；框架构型的列出选项表在生成扩展下有前沿，任务由前沿完成恰当缺之者都被扩展（`extension_frontier_exists`、`extension_frontier_has_iff`）。

**三、分类未定的比较在框架上（桥接）。** `ClassificationRobustJudgment` 对任意类型的历史比较其基本内容、增益与新内容，新内容以任意 `q` 分为基本或增益。`Becoming.Bridge` 以具名排中律证其判据，并证排中律恰是它对每个类型所需（`classification_robust_iff_of_em`、`classification_robust_iff_iff_em`）。在框架的构型上，基本内容即框架在那里实现者，判据如前（`frame_classification_robust_iff_of_em`）。沿生成扩展（`Extension F living b a`：`a` 实现 `b` 所实现的一切及一个 `b` 所缺的活内容）不需排中律：`a` 在每种分类下都被严格偏好，恰当它保留 `b` 的每个新内容（`extension_classification_robust`、`extension_classification_robust_iff`）。排中律只在两边基本内容相同、比较转到增益时才需要；生成扩展不到那一情形。

```lean
theorem lasts_iff_courses {n : Nat} {s : S} :
    Lasts f adm guard n s ↔
      ∀ plan t, Trace (disturbed f adm) s plan t → plan.length ≤ n → guard t

theorem avoids_iff_closed_reach {s : S} :
    (∀ t, Reach (Law.process next) s t → ¬ target t) ↔
      ∃ K : S → Prop, K s ∧ (∀ x, K x → ¬ target x) ∧ ∀ x, K x → K (next x)

theorem run_judges_iff [DecidableEq K] {V : Type x} (π : S → K) (f : S → V) (d : V) (r : Run P)
    (n : Nat) :
    (∃ judge : K → V, ∀ k, k < n → judge ((reducedRun π r).state k) = f (r.state k)) ↔
      ∀ j k, j < n → k < n → π (r.state j) = π (r.state k) → f (r.state j) = f (r.state k)

theorem extension_classification_robust_iff (living : C → Prop) (g : S → G → Prop)
    (f : S → N → Prop) {a b : S} (wider : Extension F living b a) :
    (∀ q, ClassificationRobustJudgment.compared F.realized g f q a b) ↔
      PracticalJudgment.Included (f b) (f a)
```

**四、测量。** `THEOREM-CONNECTIVITY.py` 在同一字节上（不重新编译，从共享缓存还原）：

| 类 | `c143e7d9` | P114 |
|---|---:|---:|
| 陈述用到两族 | 124 | 124 |
| 陈述用到过程族 | 1,110 | 1,186 |
| 陈述用到世界族 | 2,615 | 2,621 |
| 证明经过某一族 | 19 | 19 |
| 被基础上的定理使用 | 1,297 | 1,477 |
| 独立 / apart（自身词汇 + 只用前导库） | 971（885 + 86） | 799（736 + 63） |
| **共计 | **6,136** | **6,226** |

独立而不被任何常量使用者 416 → 380；无向依存图的连通分支 63 → 59，主分支之外的定理 34 → 10。新定理 90 条，独立者减少 172 条：所实例化之律因被用到而不再独立。整模块独立的 Segmentation（17/17）与 Feedback 中的两条已无独立者；Copying 58 → 17、Lasting 63 → 33、CrossSituational 37 → 14、Weighted 30 → 16、Readout 18 → 5、Retrodiction 17 → 6。记录按其最佳别名之类：加上落地包的别名后，26 项都到达陈述的类（过程族 62 → 85，世界族 67 → 70），只靠独立定理者 26 → 0（落地包 `--dry` 在临时副本上计）。

**读法（AI 的，待 Ren）。**
1. **一个展开，不是许多模型。** 这些模块原是对“一个序列”“一个池”陈述的；识别表明它们的对象本是同一展开的历程：扰动历史、轨道、计划、带日期的记录、约化，都是过程的运行或轨迹。所以“每条律是同一展开之历程的律”在这些模块上已证，而不是形式上的另一模型。
2. **两族仍是两个根。** 过程族与世界族在 124 条陈述中相遇，互不到达；本节不改变这一点。是否以一族定义另一族，待 Ren。

**作者反审。**
1. **新成果还是包装？** 这些是实例，多数证明只有几行：识别加上所实例化之律。AGENTS.md 说包装、重查与改名不是独立成果；所以本节不新增记录，只给既有记录到达基础的别名。几处有实质的步骤：`run_history` 与 `historyRun` 把可容许历史与受扰过程的运行一一对应；`reach_iff_orbit` 使确定之律的到达成为轨道；`run_judges_iff` 在运行的前 `n` 个日期上不用选择给出判断者（经 `visited` 列出已访构型）；`runs_settle_iff` 是对所有运行的等价，从对所有运行成立推出条件时用 `anyRun` 把任意构型序列作为运行；`extension_classification_robust_iff` 指出生成扩展上分类判据不需排中律，这一点 `Becoming.Bridge` 没有陈述。
2. **是否偷换了律的含义？** 每条实例的假设与所实例化之律相同，只是对象换成基础的对象；识别本身是定理（`run_history`、`trace_orbit`、`orbit_trace`、`reach_iff_orbit`、`completes_units_iff`、`steps_orbit`），不是假设。`anyChange` 容许每种变化，所以以它的运行陈述的等价（`runs_settle_iff`、`dates_no_common_report_iff`）与原来对一切序列的陈述等价；对受限过程只有充分方向（`run_settles`、`run_reports_apart`）。
3. **测量是检查吗？** 不是：它读编译环境中的依存，不判断陈述的意义。到达基础只说明 Lean 中有一条陈述把律读作基础上的律；律的科学意义与范围仍由各记录说明。
4. **范围。** 799 条仍独立。Identification（67/105）、Learning（63/75）、ReferencePlan（46/58）、Quantum（37/37）、Learnable（17/17）等不被任何只靠独立定理的记录所依，本节未处理；可同样以实例接入。

**检查。** 在暂存区对 main（`c143e7d9`，P113 之后）编译：`Becoming.Courses` 87 项定理、97 项声明，`Becoming.CoursesBridge` 3 项定理，没有错误或警告，公理报告全部为空；根模块 `Becoming` 与其导入闭包一同编译，没有重名；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。清点（`DECIDABILITY-INVENTORY.lean`）在同一字节上运行（跳过回执核对）：陈述依赖可判定性者 347 → 363，只在证明中用到者 202 → 212，取可判定族的定义 94 → 96，不用到者 0，每一新行都已分类。合并检查器在整合者的运行中检查。本节尚未经独立审查。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计两个新模块，再由 `becoming-p114-landing/apply_p114.py` 把 26 项记录绑定到回执（引用、绑定、别名与历史；论断、假设与 Ren 的话不变）。`DECIDABILITY-INVENTORY.py` 把 `Courses.release` 与 `Courses.inspection` 记作分辨相同的构造，把十条只在证明中用到可判定性的实例按所实例化之律分类。既有模块的字节不变。
## 139. 脊柱运行之外的模块归类（整合 I4a，草稿待 Ren）：598 个模块，31 个较早的版本连到脊柱，64 条待接入的律

2026-10-16。延续 §124、§127、§129、§134、§135 的 I 列。I3e 之后，主证明在脊柱运行之外的记录已无（§135）。I 列余下的是不属于任何记录的模块。Ren 在 I4 的选项中选了“Draft the table first”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-15-i4-classification-table.md)；选项文字由 AI 拟写）：先只读地列出每个模块所提议的类别与理由；对较早的版本，列出取代它的脊柱结果；作为研究草稿交 Ren 审阅，Ren 决定之前不标注、不移动任何东西。整合者另提一项：每行列出它所连到的脊柱律或模块，使“较早的版本”是一条边，不是判词。本节是这张表的说明。

```text
Result(s): 不新增、不改写记录；一张只读的归类表 MODULE-CLASSIFICATION.md（脚本生成），每行的类别是 AI 的读法
Delta: 运行之外的 598 个文件名（558 个有活的路径，40 个只在快照文件夹中）逐一归类：
       已接入 57、较早的版本 31、待接入的律 64、应用 310、工作证据 97、仅存快照 39；
       较早的版本与待接入的律都读过双方的陈述，各连到所及的脊柱声明（边，不是判词）；
       待接入的律按八个主题分组；与 P3 的分类（10 月 9 日）共有的 24 个模块逐行标出其 P3 类别
Supplied premises / correspondence: 归类规则见 RUBRIC.md；导入、引用与用词相似是计算出的信号，类别由读陈述而定
Evidence: 脚本 inventory.py、connect.py、similar.py、table.py（development/integration-i4a/），
          以核心回执 20261015T164401.170999Z 的运行模块表（基础 3、核心 107、继承 75、桥接 7）；
          行由四个子代理（Opus 5.5）与作者读出，作者抽查见下
Boundary: 见下文“边界”
Integration: 不改任何 Lean 模块、记录、§9 表或生成的总览；Ren 决定之前不标注、不移动、不删除
```

**总体与方法。** 总体是每个受跟踪的 Lean 文件，其完整模块名不在脊柱运行中，按文件名归组。一个路径中有以时间戳或运行编号命名的文件夹，或在运行、检查、来源副本、验证或历史文件夹之下，算作副本。一个文件名有多个活的路径时，取模块自己文件夹中的那个，开发与评审副本在后（14 个文件名另有活的副本，表中注出）。所及是由导入传递地计算的：到核心或桥接、到继承模块、只到基础，或不及运行。四个子代理各读一组家族，作者读 `_process` 与三个名字冲突的文件名。较早的版本与待接入的律必须读过双方的陈述；应用、工作证据与已接入可以只读文件头，表中逐行写明依据（读陈述 325 行，读文件头 273 行）。

**总数。**

| 类别 | 模块 | 定理 |
|---|---:|---:|
| 已接入 | 57 | 1400 |
| 较早的版本 | 31 | 473 |
| 待接入的律 | 64 | 1329 |
| 应用 | 310 | 6516 |
| 工作证据 | 97 | 745 |
| 仅存快照 | 39 | 0 |
| 合计 | 598 | 10463 |

所及与类别交叉：不及运行的 148 个模块中有 31 条待接入的律与 19 个已接入者（后者是外围实例模块所读的外围来源，经实例模块及其检查器接入，自己不导入运行）；到核心或桥接的 36 个都是已接入者或工作证据。

**较早的版本：31 条边。** 每一条的主定理都是一条脊柱律的特例或较早形式，关系分三种：`same`（脊柱逐字或同义陈述）、`spine-generalizes`（脊柱的律更一般）、`instance`（模块的定理是脊柱律的一个实例）。例如：
- `Depletion.no_infinite_execution_under_depletion` 被逐字重述为 `Becoming.no_execution_of_depletion`（same）。
- RenewalLiquidity 的前缀偿付是 `Stock.covered_iff_prefix` 的情形。
- OneProcess 的组织与后果律作为一个确定过程，是 `closedBy_determined` 的情形。
- FormationClosure 的形成律是 `Gated.change_passes_gate` 的两族情形。
- 草稿 OpenFuture 的 `observation_limit` 是 `Readout.decoder_pair_iff` 的一个方向。

根目录家族（31 个模块中 6 个较早的版本、24 个应用）是生成基础的较早一代，其中心定理今由核心陈述。较早的版本是边：模块保留，原定理与回执不变。

**待接入的律：64 条，八个主题。** 每条是对任意过程、关系或历史量化的一般律，脊柱尚未陈述；每行写出最近的脊柱模块与要加的东西。
1. 更新与闭合（8）：`lean/conditional/renewal` 的六个模块是一条连着的线，从更新势的下降、闭合特征、充分性到二者在同一执行上的连接，最近的是 Generation、Interdependence 与 Descent；另有 ResourceContinuation（Stock）与 SupportNecessity（Descent）。
2. 比较、组合与描述（10）：经约化的组合同余、历史接口、过去谓词的关系性恢复、形成对称、关系性（非确定、换类型）的描述步等，最近的是 Joining、Readout、Description、Histories 与 Unfolding。
3. 探究与判断（9）：可达问题之序、在已达叶上继续探究、按读取指标的回应、评审描述的覆盖、生产性限制为最大完成者、整体实践限制的粘合、关系边界的奇偶律等，最近的是 Inquiry、Viability、Contextual 与 Metaethics。
4. 控制、学习与估值（9）：确切抽象在闭环下的保持、控制器记忆由观测词决定、协议的宏步与完成、估值的收缩与探索覆盖、跨尺度的界，最近的是 Coupling、Web、Granularity、Law、Weights 与 Tower。
5. 所及、持续与有限否证（7）：严格失去所及的路程之界、可再生的持续、单向的门（非门步保持缺席）、König 提升、前缀闭与 Scott 闭的有限否证、未达者不计，最近的是 Attraction、Branching、Gated、Lasting、Horizon 与 Bridge。
6. 对称与并列（2）：交换中心不变的规则服务一个中心恰当它不与他者并列；推到权重，最近的是 Selection 与 Weighted。
7. 一般数学（17）：理想完备、谓词类的满容许、函数图、依赖族、签名与高阶的真、Tarski–Vaught、归纳与初始性、稠密序、潜在的真。最近的是 Context、Histories、Lasting 与 Horizon，但它们是一条远的一般数学线。
8. 推导演算（2）：CoreTreeRearticulation 与 WholeTheoryDischarge 陈述推导演算的律；核心没有推导演算（同 §135 的理由）。

最近的缺口是对既有核心模块的小扩充：PrefixSafety 与 IdealWarrant 之于 Horizon（`prefix_does_not_decide` 是一般分类的一个特定情形），FiniteBranching 之于 Lasting，PluralRecords 与 TieBreaking 之于 Selection，LivingOrganization 之于 Gated（Gated 要求未经门的步双向保持，单向形式未陈述），CorrectionRelations 的奇偶律之于 Contextual（P112 进行中，落地后该行改为较早的版本）。

**与 P3 分类的对照。** P3（10 月 9 日）归类了 46 个含类型多态定理的伦理模块，其中 24 个在本表中，逐行标出 P3 类别。P3 的“已在核心上”指陈述直接写在基础的 `Process`／`Trace` 上，不指某条脊柱律陈述了它；本表给这些模块补上所及的脊柱声明。两者不冲突。

**测量。** 本表的总体比 `SPINE-INTEGRATION.py` 的“运行之外的 Lean”严一些：后者活的路径中 510 个模块、10497 项定理，本表 508 个有定理的活模块、10463 项定理。差别有两个来源。一是副本规则：本表把以时间戳命名的文件夹、检查与验证文件夹也算作副本，并只读每个文件名的规范文件。二是名字冲突：测量按文件名的最后一段排除运行模块，于是同名的本地文件被藏在运行模块之后（Admission 被藏在 `Becoming.Admission` 之后；Continuation、Correspondence 同理）；本表按完整模块名匹配，找回这三个，并纠正了七个模块被误记为到核心或桥接的所及。

**作者抽查。** 读双方陈述核对了六行：RenewalLiquidity → `Stock.covered_iff_prefix`、OneProcess → `closedBy_determined`、FormationClosure → `Gated.change_passes_gate`、Depletion → `no_execution_of_depletion`（逐字）、PrefixSafety（待接入）、LivingOrganization（待接入）。六行都成立。PrefixSafety 的理由原引 `finiteRefutable_iff_closed`，那是定义展开（`Iff.rfl`），改引承载内容的 `finiteRefutable_iff_prefixClosure`。

**作者反审。**
1. **类别是不是判词？** 不是。每行是 AI 的读法；较早的版本是一条边，说它的主定理在脊柱上以何种关系出现，不说模块无用。原定理、回执与记录都不变。
2. **读文件头的 273 行可靠吗？** 只到其类别所需：应用、工作证据与快照不声称一条脊柱律；其中可能还有未发现的较早版本或一般律。较早的版本与待接入的律两类都读过陈述。
3. **相似度提示误导吗？** 用词相似给出过错误的提示（GeneratedSelf → FallibleInquiry，因共用“residual”）；故规则要求读陈述，提示只用来找候选。
4. **文件名归组会丢东西吗？** 14 个文件名另有活的副本；表只归类规范文件，副本在 `_process`、`drafts` 或开发文件夹中，作为工作证据。不同模块恰好同名而都在运行之外的情形，本表未单独分开。
5. **所及是否确切？** 是由正则读导入计算的，不运行 Lean；一个模块所及的运行模块只说明它建在其上，不说明它的定理是否接入。

**边界。** 本表不证明任何新定理，也不改变任何记录的论断。“较早的版本”“待接入的律”是提议，接入须写 Lean 并实查。Ren 决定之前不标注、不移动、不删除。

**待 Ren 决定。**
1. 是否在 31 个较早的版本的文件头加一行注记，指向所及的脊柱声明（边；模块保留）。
2. 是否接入待接入的律，按主题进行。提议的次序：先是最近的缺口（对既有核心模块的小扩充），再是更新与闭合一线，再是比较、探究与控制三组。一般数学（17）与推导演算（2）是否属于脊柱是范围问题，不是缺口。
3. 是否把 `SPINE-INTEGRATION.py` 改为按完整模块名排除运行模块，并采用本表的副本规则（数字会如上文所示地变动）。
4. 应用（310）照旧；工作证据（97）与快照（39）作为证据保留，不删除。

**2026-10-16，Ren 对第 3 项的决定。** Ren 读了解释后选 B（“ok, agree with your C direction(B)”，[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-measure-fix-decision.md)）：`SPINE-INTEGRATION.py` 改用本表的规则。只有完整模块名正是某个运行模块的文件，才作为它的较早版本排除；本表快照规则之下的路径（运行、检查、来源副本、核验或历史文件夹，以时间戳或数字运行编号命名的文件夹）算作副本；每个模块从其规范文件计数，计每项定理声明。在回执 20261015T220109.090247Z 上：记录的归类不变（在脊柱上陈述 209、继承模块中 5、无 Lean 证明 10、运行之外 0；引用某项脊柱证明 212）；运行之外的活模块 514 → 512、定理 10 532 → 10 498，与本表的流程（`inventory.py`、`connect.py`）在同一回执上所得相同；只在副本中的定理 9 640 → 2 517，因为检查器以完整模块名保存的运行模块源文件（如 `Becoming.Imbalance.lean`）此前因文件名不同被算作别的模块的副本，现在作为运行模块的较早版本排除。此前各节的数字按各自的回执照旧。

## 140. 运行分开之处的辨识，计数中的典型（P116）

2026-10-16。Ren 2026-10-15 的第四条消息：“not sure what's the reading 1, but reality is always situational. for what i mean by the core, is the whole that covers the whole reality where "things and changes" exists, 0 axiom / "What this line doesn’t reach" is also worth doing / if my earlier words are unreasonable, please keep note, not follow blindly”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-15-situational-and-the-whole-core.md)）。辨识一线（§97、§126、§132、§133、§136）对确定的律陈述；它没有达到的是识的限度（已由 §119 的 `Becoming.Learnable` 恰好给出，这里引用，不重证），以及有分支与有权重的世界。本节在第一部分之内回答后两者：不加公理，除各律所写者不加前提。工作板上认领为 P116。

```text
Result(s): 新增 identification-where-runs-part 与 typicality-by-counting；复用 identification-where-bounded（leastBound_exact、
           rest_earliest、statesBelow_iff_lasso、statesBelow_mono、below_all、not_ne_bool、le_of_add_right）；
           tests-fix-likeness-where-determined（Law.realized_within）；learning-by-refutation（record、record_congr、holdFrom、
           diagonal、diagonal_refutes、diagonal_not_lasso、learner、lassos）；recurrence-without-premise（revisits_within、gap_of_le、
           mem_cons_split、Law.process、Law.orbit）；the-split-that-makes-sense（StatesBelow、SameAhead、statesBelow_of_same）；
           sum-over-histories-exact（counting、Weights.along、Weights.transfer、Weights.sum_courses、courses、add_mul_split、
           mul_assoc_nat）；Becoming.Frame 的 Run、Becoming.Joint 的 Determined；引用 learnable-through-registration（识的限度）
Delta: 新核心模块 Becoming.Parting（导入 Distinguishing；18 项定理／27 项声明）与 Becoming.Typicality（导入 Identification 与
       Weighted；32 项定理／44 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各律所写者写在定理中：运行被列表所持、从一个配置出发运行不分开；所识的值可判定
       （unparted_iff、leastBound_right、free_open）；两个值、自然数权重（Typicality）
Evidence: scratch_build 对 main b34b8027（P114 之后）：Becoming.Parting 18 项定理、27 项声明，Becoming.Typicality 32 项、44 项，
          根模块 Becoming 与其导入闭包（113 个核心模块）一同编译，无重名，公理报告全部为空，无警告；合并检查器回执待整合者的运行
Boundary: 学习者读配置所识的值，不读动作；只在某步之后不分开时的静止之步没有陈述；给定世界时某学习者在每个运行上于某步都对恰当
          那一步不分开（有限、已定的过程）没有陈述；典型只对两个值、以切比雪夫之界陈述；发生的历程典型不被推出；不含伦理谓词
Integration: §8 的进一步证明“路径分支时”、状态行、Ren 的读法、第一部分的总陈述“认识”、界一项、§9 新增两行、术语表三行；
       identification-where-bounded 的 next_delta 与 related；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列与范围；
       Lean README 两行与层内导入；两项新记录
```

| 声明 | 内容 |
|---|---|
| `Parting.after`、`Parting.before`、`Parting.joinAt`、`joinAt_before`、`joinAt_after` | **运行从某步起、在一步之前加一步、在一步连接两个运行。** 连接的运行到第 k 步是 `r`，此后是 `r'`，起点是 `r` 的起点 |
| `Parting.PartAt`、`Parting.Unparted`、`Parting.RightAt` | 两个运行在某步分开：之前所识相同，该步不同；从 `s` 出发不分开：从 `s` 出发的每两个运行所识的是同一历程；学习者读所识的记录，在某步对 |
| `not_right_on_both`、`not_parting_of_right` | **分开之处没有学习者在两者上都对**，无论它被给予什么；在从 `s` 出发的每个运行上从 `T` 起都对的学习者，使这些运行在 `T` 之后不分开 |
| `unparted_iff` | 所识的值可判定时，不分开恰是没有一步分开 |
| `Unparted.along` | **不分开沿运行保持**（经 `joinAt`） |
| `course_statesBelow`、`leastBound_right` | **运行不分开之处界成立**：被 N 个配置的列表所持的运行，其所识的历程至多有 N 个状态；以最小的界读记录的学习者从 N + N − 1 起每步都对 |
| `rest_earliest_runs` | 对过程亦恰好：没有学习者在 N = M + 2 个配置的每个过程的每个不分开的运行上于 N + N − 2 都对（经 `Law.realized_within` 与 `Identification.rest_earliest`） |
| `states_agree`、`unparted_of_determined` | 一个动作的确定过程处处不分开：确定的律是实例 |
| `free`、`freeRun`、`freeRun_course`、`free_unparted_const` | **自由分支**：每个配置都可接每个配置，每个历程都是一个运行的历程；分支不显于所识者不分开 |
| `free_parts_after`、`free_open`、`free_never_right`、`free_held`、`free_unbounded` | 每个记录之后两个运行分开，没有记录表明世界不会分开；每个学习者在每个记录之后在某个运行上于下一步不对，且有一个运行处处不对；自由分支在两个值上被两个配置的列表所持，其中一个运行的历程没有状态数的界 |
| `Typicality.courses`、`mem_courses_iff`、`courses_length`、`weight`、`total_weight` | n 步的历程恰是 n 个值的列表，共 2ⁿ 个；以 p、q 计数，合起来重 (p + q)ⁿ |
| `ahead`、`behind`、`square`、`cross`、`spread` | **平方偏差之和恰好**：x = q·a、y = p·b，加权的 x·x + y·y 之和是加权的 2·x·y 之和加 n·p·q·(p + q)ⁿ |
| `two_mul_le`、`offBy`、`offBy_le`、`typical` | **多数历程显示权重**：偏差至少为 d 的历程之重乘 d 至多 n·p·q·(p + q)ⁿ |
| `stepWeight`、`along_weight`、`transfer_weight`、`sum_courses_weight` | **权重就是 `Becoming.Weighted` 的**：自由分支以计数加权，沿历史复合的就是这里的权重，历史之和就是这里的总重 |

**它回答了什么。** “这条线没有达到的”有三项。识的限度已由 §119 恰好给出：被列表所持的世界中，某个读识的学习者在每个配置上静止，恰当所识的未来相同的配置其目标从某步起一致（`Learnable.learnable_iff`）；这里不重证。有分支的世界：辨识一线的界，对每个过程，恰在运行于所识中不分开之处成立，确定的律是其中一例；分开之处，即使给定世界，下一个值也不由记录确定，界不约束历程（两个配置上的历程可以没有状态数的界）。有权重的世界：记录识历程，不识权重；计数（不加前提）给出多数历程的频率接近权重之比，权重之份额以 p·q / ((p + q)²·ε²·n) 随 n 下降；发生的那一个历程是否在多数之中，不被推出。

**关于 Ren 的话（AI 的注，按 Ren 2026-10-15“if my earlier words are unreasonable, please keep note, not follow blindly”）。**
1. **“the full "truth" can be derived, situationally”（2026-10-12）。** 按本节与 §97：所识的一切从有限的记录推出，限于状态数有界、运行在所识中不分开之处；分开处，下一个值不由任何先前所识者固定，连知道世界的也不能，只在被走时定下；权重不被记录确定，只经典型的历程显示，而典型不被推出。所以“完整的真”若包括分开处的路径与发生的历程，就不能推出；若指律（何者可能、各有多重），则可推出的限于所识、限于所走过的（`Becoming.Experiment`：动作造成什么只在配置返回之处由记录固定）。
2. **“reality is always situational”（2026-10-15）。** 若“情境的”指每个识都在某个情境之内（语境的），这与核心一致（`Becoming.Readings`：语境中的诸识是一个世界的关系项）。若指每个情境的状态数有界，这是关于每个世界的实质前提，不由零公理推出：核心中有没有界的世界，其中没有记录确定下一个值（`Learning.no_record_fixes_next`、`Parting.free_unbounded`）。核心不断言它，也不否定它；它对每个世界陈述其中可推出的。
3. **“the core … covers the whole reality where "things and changes" exists, 0 axiom”。** 核心的规律对每个过程陈述（确定的、有分支的、有权重的），在这个意义上覆盖全部；覆盖不等于推出每个事实：在分开处与对发生的历程，核心推出的恰是什么不能被固定。
4. **读法 1。** Ren 未把“按情境就是界”取为自己的；理论第 8 节的读法一项已改为把它作为 AI 的读法，连同上面的限定，交 Ren。

**读法（AI 的，待 Ren）。** 所识的一切按情境推出，限于运行不分开之处；分开处的分支只在被走时定下，这是开放的未来在辨识中的形式；把权重读作发生的机会，是在计数之上加“发生的历程是典型的”这一前提，概率的读法正在于此。

**作者反审。**
1. **已知的结果。** 分开之处无学习者两者都对，是不可区分论证；自由分支上的对角是 `Becoming.Learning` 的对角；典型是二项分布的切比雪夫不等式（伯努利的弱大数定律）。增量是：在核心中不用公理地陈述，确定的律与有分支的过程在“运行不分开”这一条件下统一，权重接到 `Becoming.Weighted`，并标出发生的历程典型这一不被推出的前提。
2. **恰好与否。** `not_right_on_both` 对每一步、每个学习者成立；反方向（给定世界的学习者在每个运行上于不分开之步都对）需要从记录选出一个运行的值，对有限、已定的过程可构造，没有陈述。只在某步之后不分开时，界给出的静止之步依赖那一步，没有陈述。
3. **典型的强度。** 切比雪夫之界随 n 线性下降；指数的集中（Chernoff）没有陈述；多于两个值与实数权重没有陈述（实数在外围）。
4. **名字。** `Parting`、`PartAt`、`Unparted`、`joinAt`、`free`、`Typicality`、`spread`、`typical`、`offBy` 都是结构性的名字。
5. **证明。** 不用 `simp`、`omega`；`ac_rfl` 引入 propext 与 Quot.sound，`Nat.add_mul`、`Nat.mul_assoc`、`Nat.mul_left_comm` 引入 propext，改用核心已有的 `add_mul_split`、`mul_assoc_nat` 与本模块的 `left_comm`。`Unparted.along` 用连接运行，不用函数外延性。

**检查。** 在暂存区对 main b34b8027（P114 之后）编译：`Becoming.Parting` 18 项定理、27 项声明，`Becoming.Typicality` 32 项、44 项，根模块与其导入闭包（113 个核心模块）一同编译；没有错误或警告，公理报告为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 141. 差别到达多少：耦合强度度量敏感，所携带的量是能到达的最大差别（Becoming.Propagation）

2026-10-16。P80 的记录 [counterfactual-is-the-course](../../../../theories/becoming/results/records/counterfactual-is-the-course.md) 的 next_delta 要求差别到达多少的度量，`Becoming.Counterfactual` 把“差别到达多少的任何度量”列为没有导出；[feedback-and-reach](../../../../theories/becoming/results/records/feedback-and-reach.md)、[comparison-where-the-rest-responds](../../../../theories/becoming/results/records/comparison-where-the-rest-responds.md)、[sensitivity-is-the-least-registration](../../../../theories/becoming/results/records/sensitivity-is-the-least-coupling.md)（P113：“敏感的度量与差别到达多少”）、[where-a-move-is-formed](../../../../theories/becoming/results/records/where-a-move-is-formed.md)（P109：“耦合的度量（部分形成动作的多少）”）与 [levels-of-closure](../../../../theories/becoming/results/records/levels-of-closure.md)（“耦合的度量”；其范围说共同条件“不度量耦合的强度”）亦列它；理论第 8 节的进一步证明在“反馈与所及”下列“耦合的度量”。Ren 2026-10-12 的目标：“move towards 100%, you can spawn a few agents for help, pick the "What would move it most next" first, and don't stop until we are 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)），2026-10-15 又说“continue”。本节在第一部分之内回答：不加公理，除各律所写者不加前提。工作板上认领为 P115。

```text
Result(s): 新增 how-much-difference-arrives；回答六项记录 next_delta 中的“差别到达多少”与“耦合的度量”：counterfactual-is-the-course、
           feedback-and-reach、comparison-where-the-rest-responds、sensitivity-is-the-least-registration、where-a-move-is-formed、
           levels-of-closure；复用 counterfactual-is-the-course（ExchangeLaw、Nonanticipating、Follows、InsensitiveAt、Sensitive、
           levels、levels_succ、totals_under、course、course_balances_iff、course_follows）；TimedResponse（Spread、RegistersAt、
           TouchesAt）；Flow、Web 与 Balances
Delta: 新核心模块 Becoming.Propagation（导入 Counterfactual 与 TimedResponse；78 项定理／97 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各律所写者写在定理中：律读已立者（Nonanticipating）；两个流平衡（Balances）、在场形成相同、
       其余遵从律（Follows）；耦合强度（RespondsWithin，给出的界）；部分之差与起始之差的界；条件全部列出（every），达到处不重复
       （Distinct）；条件的相等可判定（只在混合条件处）
Evidence: scratch_build 对 main 416ff6b0（P114、I4a 与 P116 之后）：Becoming.Propagation 78 项定理、97 项声明，公理报告全部为空，无警告；
          根模块 Becoming 与其导入闭包（114 个模块）一同编译，无重名；清点在同一字节上运行，每一新行都已分类；
          合并检查器回执待整合者的运行
Boundary: 离散的步、自然数的量（小于一的强度只能以一为界）；强度是给出的界，不陈述最小的强度；条件全部列出；
          回路的一般理论开放；不含伦理谓词
Integration: §2 新增一段（差别到达多少），其余回应时的比较一段中的“不推出”；§6.10 一句；第一部分的总陈述一条；§8 的状态行与
       进一步证明各改一项；§9 新增一行；术语表新增两行；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列与范围说明；
       Lean README 一行与层内导入；DECIDABILITY-INVENTORY.py 的分类；一项新记录与六项配对说明
```

**一、差别作为交换之差到达。** 两个水平之差 `gap a b` 是任一方多于另一方者（`(a - b) + (b - a)`，自然数上的距离）。两个平衡的流中，第一个流某条件步后的水平与第二个流步前的水平，加第一个所取与第二个所给，等于第二个步后的水平与第一个步前的水平，加第二个所取与第一个所给（`levels_step_exact`）：水平之差跨一步恰按所给之差减所取之差改变，没有别的来源。所以在场形成相同时，一个条件跨一步之差至多是步前之差加与它交换的每个形成的交换之差（`gap_step`；交换之差 `Flow.exchangeGap` 是所取之差加所给之差），每个交换都相同时不增（`gap_step_of_alike`）。

**二、耦合强度，敏感的度量。** 跨过第 `t` 步，`h` 与条件 `c` 的交换与条件 `d` 在第 `s` 步的水平耦合、强度至多 `k`，是说在只在这一个水平上不同的任意两个历史下，所取之差与所给之差合计至多是 `k` 乘该水平之差（`ExchangeLaw.RespondsWithin`）：一个逐坐标的 Lipschitz 界。对读已立者的律，跨过第 `t` 步对 `d` 不敏感（`Becoming.Counterfactual` 的 `ExchangeLaw.InsensitiveAt`），恰是对 `d` 直到 `t` 的每个水平、对每个条件强度为零（`ExchangeLaw.insensitiveAt_iff_strength_zero`）；敏感恰是在某步并非每个这样的强度都为零（`ExchangeLaw.sensitive_iff_strength`）。读已立者的律对第 `t` 步之后的水平不耦合（`ExchangeLaw.Nonanticipating.respondsWithin_later`）。强度沿逐个改变的水平相加：把第二个历史一个水平一个水平地换入（`mixCells`），交换之差至多是各换入水平的强度乘该水平之差之和（`ExchangeLaw.exchangeGap_le_mixCells`）；所以在直到 `t` 只在列出的条件上不同的两个历史下，交换之差至多是这些步与条件上强度乘差之和（`ExchangeLaw.exchangeGap_le_strengths`；条件全部列出时对任意两个历史，`ExchangeLaw.exchangeGap_le_strengths_listed`）。条件分为部分的与其余的时，一个动作的改变至多是部分的份额（其强度乘部分的改变）加其余的份额（`ExchangeLaw.exchangeGap_le_shares`）：部分形成动作的多少的度量。有限的强度是律的条件，不是每个律都有：交换水平平方的律对其水平没有任何有限的强度（`Propagation.Square.not_respondsWithin`）。

**三、所携带的量。** 携带之律让部分给出其差 `σ`，部分之外的每个形成给每个条件其强度 `k` 对至今各水平所作的（直到该步、在列出的条件上，强度乘水平之和），什么也不取（`ExchangeLaw.carrying`）；它读已立者（`ExchangeLaw.carrying_nonanticipating`）。所携带的量是它由起始之差 `δ` 生成的水平（`carried`），用的就是 `Becoming.Counterfactual` 的生成：跨每一步它增加部分之差与强度对至今所携带者所作的（`carried_succ`），从不减少（`carried_le_succ`）。两个平衡的流，在场形成相同，起始至多差 `δ`；部分的交换至多差 `σ`；其余在两者中遵从同一个读已立者之律，其交换对直到其步的每个水平具有强度 `k`；条件全部列出。于是每步每个条件之差至多是所携带的量（`gap_le_carried`）。证明逐步归纳：`gap_step` 给出一步之差，部分的交换之差由 `σ` 界定，其余的交换之差由 `ExchangeLaw.exchangeGap_le_strengths_listed` 界定，而此前各步之差由归纳界定。

**四、它恰好达到。** 条件各列一次时，携带之律自身具有强度 `k`（`ExchangeLaw.carrying_respondsWithin`），它生成的进程平衡（`carrying_balances`）；没有起始之差、部分没有差时所携带的是零（`carried_quiet`），所以携带之律的进程与安静的进程之差，每步每个条件恰是所携带的量（`carried_attained`）。于是：对每个具有强度 `k` 的读已立者之律与它的每两个满足上述条件的流，第 `T` 步一个条件之差至多是 `a`，恰当所携带的量至多是 `a`（`most_difference_arrives`）。所携带的量就是能到达的最大差别：从强度得不出更小的界。

**五、差别到哪里。** 一个差被送到第 `t` 步的一个条件（`Conveyed`），是经起始之差、经保持（水平持有它）、经部分在前一步的差，或经一个在场形成从一个已被送到差的、直到该步的水平到该条件的正强度：一条时间中的路线。所携带的量为正，恰当有差被送到（`carried_pos_iff`）；没有差被送到之处，两个流的水平相同（`levels_alike_of_not_conveyed`）。没有起始之差、部分的每个正差是与该条件交换的源、每个正强度属于识该水平并与该条件交换的形成时，每个被送到的差都在 `TimedResponse.Spread` 的一条路线上（`Conveyed.spread`）：`Becoming.TimedResponse` 的潜在传播，现在带着它的量。

**六、所携带的差别相加。** 两组部分之差与两组起始之差合起来所携带的，是各自所携带的之和（`carried_add`）；更多的差与更大的强度携带更多（`carried_mono`）。

**七、见证。** 两个条件 `true` 与 `false`：部分在第一步给 `true` 一个单位；其余每步给 `false` 两倍于 `true` 在该步的水平（`Propagation.Chain.relay`）。`true` 持有那一个单位（`Propagation.Chain.first`），`false` 到第 `t + 1` 步到达 `2t`（`Propagation.Chain.keeps_arriving`）：没有任何回路，一次的差别也无界地到达，因为水平持有所给的；携带之律的进程恰有这个差（`Propagation.Chain.gap_arrives`）。其余改为每步把 `true` 的水平送回 `true`（强度为一的回路，`Propagation.Loop.loop`），那一个单位到第 `t + 1` 步到达 `2^t`（`Propagation.Loop.runaway`）。

```lean
def RespondsWithin (t : Nat) (h : F) (c : C) (s : Nat) (d : C) (k : Nat) : Prop :=
  ∀ l l' : Nat → C → Nat, (∀ s' e, ¬ (s' = s ∧ e = d) → l s' e = l' s' e) →
    law.exchangeGap t h c l l' ≤ k * gap (l s d) (l' s d)

theorem ExchangeLaw.insensitiveAt_iff_strength_zero (na : law.Nonanticipating) {t : Nat} {h : F}
    {d : C} : law.InsensitiveAt t h d ↔ ∀ c s, s ≤ t → law.RespondsWithin t h c s d 0

theorem most_difference_arrives (every : ∀ c, c ∈ cs) (distinct : Distinct cs) (T : Nat) (c : C)
    (a : Nat) :
    (∀ (law : ExchangeLaw F C) (L L' : Flow F C) (W W' : Web F C), law.Nonanticipating →
      L.Balances W → L'.Balances W' → (∀ t, L.present t = present t) →
      (∀ t, L'.present t = present t) → L.Follows law part W.level → L'.Follows law part W'.level →
      (∀ t h c s d, part h = false → s ≤ t → law.RespondsWithin t h c s d (k t h c s d)) →
      (∀ t h c, part h = true → L.exchangeGap L' t h c ≤ σ t h c) →
      (∀ c, gap (W.level 0 c) (W'.level 0 c) ≤ δ c) →
      gap (W.level T c) (W'.level T c) ≤ a) ↔
      carried cs part σ k present δ T c ≤ a

theorem carried_pos_iff (t : Nat) (c : C) :
    0 < carried cs part σ k present δ t c ↔ Conveyed cs part σ k present δ t c

theorem Propagation.Chain.keeps_arriving : ∀ t, amount (t + 1) false = 2 * t
theorem Propagation.Loop.runaway : ∀ t, amount (t + 1) true = 2 ^ t
```

**读法（AI 的，待 Ren 或按 Ren 2026-10-15 的交托判断）。**
1. **耦合强度是敏感所缺的度量。** 敏感说一个水平能否改变一个交换，强度说改变多少。以识读作敏感（P113），强度读作识的强弱：形成识其交换所能被改变者，强度说被改变多少。
2. **差别到达多少本身是一个进程。** 所携带的量由一个律生成，用的是反事实进程的同一生成，所以一个动作的所及从展开读出，不另加于其上：度量不是外加的尺度，而是同一展开中的另一个进程。系统论中，强度是增量增益（Lipschitz 界），所携带的量是它们定义的比较系统；这里比较系统自身是同类的一个律，所以它恰好达到。
3. **所持的差别不断到达。** 水平持有所给的（存量对流量积分），所以没有回路时，只要一个正强度读持有差别的水平，一个动作的差别就无界地到达；回路使之倍增。
4. **整体有多纠缠。** 理论 §6.10 读 Ren 的“the whole earth has become a highly entangled system”，并说共同条件使所及为整体却不度量耦合。强度度量它：一个整体有多纠缠，读作其交换与彼此水平耦合的强度；所携带的量读作一个动作的差别在其中能多远、多快地增长。
5. **部分形成动作的多少。** P109 所问的读作部分的份额：至多是部分的强度乘部分的改变；整个动作的改变还要加其余的份额。

**作者反审。**
1. **新律还是重述？** `levels_step_exact` 是平衡的代数。耦合强度是逐坐标的 Lipschitz 界，即系统论的增量增益；`gap_le_carried` 是离散的 Grönwall 不等式或比较原理：差由一个线性的上界系统控制；`most_difference_arrives` 说这个比较系统是紧的，因为它自身是同类的一个律。这些在数学上是标准的。新的是：（a）它们在核心的交换律上陈述，不加前提，用的是 `Becoming.Counterfactual` 的同一生成；（b）上界恰好达到，是一个当且仅当，所以从强度得不出更小的界；（c）强度为零恰是 `Becoming.Counterfactual` 的不敏感，所以这一度量精化 P113 的最小的识；（d）所携带的量为正之处恰是时间中的路线，接上 `TimedResponse` 的传播。
2. **强度是给出的，不是推出的。** `RespondsWithin` 写在用它的每条定理的假设中；不是每个律都有有限的强度（`Propagation.Square.not_respondsWithin`）；最小的强度没有陈述（那要对每个 `k` 判定 `RespondsWithin`，或取上确界）。所以“差别到达多少”是相对于给出的强度的最坏情形：对一个具体的律，实际的差可以小得多；所携带的量对具有这些强度的一切律都是界，并且在其中一个律上达到。
3. **自然数的量。** 强度是自然数，小于一的衰减只能以一为界（或为零），所以差别逐步减弱的耗散情形只给出不增的界，不给出衰减；实数的量与连续时间开放。
4. **条件全部列出。** 界要求条件全部列出（`every`）；条件无穷多时（P113 的读有限多个条件之律）没有陈述。达到要求条件不重复（`Distinct`），否则携带之律会重复计数。
5. **两个流的设定。** 两个流在场形成相同，其余在两者中遵从同一个律；部分可以做任何事，只要它的差至多是 `σ`。这正是 `Becoming.Counterfactual` 的反事实比较：有与无一个动作的两个进程。
6. **见证中的“无界”。** 链中第二个条件的差 `2t` 来自水平持有所给的（积分器），不是回路：有界的输入经积分无界。回路的一般理论（任一回路上的强度与失控）开放；`Becoming.Runaway` 的失控是在策略上陈述的，这里的回路只是见证。
7. **范围。** 不含伦理谓词；离散的步；混合条件处用条件的相等可判定（`DecidableEq C`），如 `Becoming.Counterfactual`。

**检查。** 在暂存区对 main（416ff6b0，P114、I4a 与 P116 之后）编译：`Becoming.Propagation` 78 项定理、97 项声明，没有错误或警告，公理报告全部为空；根模块 `Becoming` 与其导入闭包（114 个模块）一同编译，没有重名；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`，证明不用 `omega`、`funext` 与依赖 `propext` 的引理，模式匹配不重叠。清点（`DECIDABILITY-INVENTORY.lean`）在同一字节上运行（跳过回执核对）：陈述依赖可判定性者 364 → 367，只在证明中用到者 214 → 223，取可判定族的定义 96 → 97，不用到者 0，每一新行都已分类。合并检查器在整合者的运行中检查。本节尚未经独立审查。

**边界。** 落地运行须在 `check_becoming.py` 中编译与审计新模块，再把新记录绑定到回执。`DECIDABILITY-INVENTORY.py` 把 `mixCells` 记作逐个水平换入的构造（如 `mixIn`），其陈述提到它的三条定理随之；把九条只在证明中用到条件之相等的定理记作分辨相同。既有模块的字节不变。名称“耦合强度”取自 levels-of-closure 的范围（“不度量耦合的强度”）；“增益”留给 P111 的新的增益（另一个意思），不在此用。

## 142. 较早的版本的文件头注记（整合 I4c）：31 个模块指向脊柱上陈述其主定理的声明

2026-10-16。延续 §139 的 I4a 表。Ren 对表的三项决定（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-i4-decisions.md)）：较早的版本加注记（“Add the notes”）；待接入的律先接最近的缺口（“Closest gaps first”，I4b）；一般数学（17）与推导演算（2）暂留脊柱之外（“Leave outside for now”）。本节是第一项。

```text
Result(s): 不新增记录；改写 3 项记录的引用哈希与历史（其一移动证明绑定）
Delta: 31 个较早的版本的第一行各加一条双语注释，列出其行所列的脊柱声明与关系（same / spine-generalizes / instance）；
       归类表标出两个暂留之外的主题，并说明注记
Supplied premises / correspondence: 注记取自 I4a 的行（读过双方陈述）；不改陈述与证明
Evidence: explanatory-resumption 检查器对新字节重跑（回执 20261015T180520.693095Z：22 个模块、314 项审计，与 10 月 8 日的回执相同，只有 ExplanatoryResumptionCases 的字节不同）
Boundary: 注记是边，不是判词；模块保留，不删除任何东西
Integration: 不需核心运行；31 个模块都不在核心回执中
```

**注记放在哪里。** 文档中有约 800 个指向这 31 个文件的行锚链接（`File.lean#L…`），在文件头另起一行会使它们全部错位。所以注记接在原有的第一行之后：29 个文件是 import 行后的行注释，OneProcess 与 TrajectoryFidelity 以注释开头，注记写在该注释的第一行。没有行号移动；两种写法都在项目工具链（v4.29.1）下解析。

**哈希。** 读这两个文件字节的记录有三项，都在读过改动（只有注释）后改绑，各加一条历史：trace-law-equivalence（GenerativeModel，集成引用）、guarded-program-question-recovery（ExplanatoryResumptionCases，反例引用）、residual-continuation-correspondence（ExplanatoryResumptionCases，证明引用；证明绑定移到新回执，ExplanatoryResiduals 仍绑定原回执）。其他提到这些路径的较早检查文件是旧字节的历史证据，保持原样。

**边界。** 注记说某条脊柱声明陈述了模块的主定理，以何种关系；不说模块无用。`ContinuationRenewal.renewal_within_rank_plus_one_steps` 在继承模块中，属于脊柱运行。
## 143. 每个起源都经过门（整合 I4b 第一项）：单向的门律，LivingOrganization 接入

2026-10-16。Ren 对 I4 归类表选择“Closest gaps first”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-i4-decisions.md)）。表把 LivingOrganization 读作待接入的律：对任意反应网络，终态出现的池或初始即在，或经某进入步进入；Becoming.Gated 只陈述未经门的步双向保持的量，单向的轨迹律未陈述（§139）。本节陈述它，并把 Gated 的旧律作为其情形。

```text
Result(s): 新记录 every-origin-passes-the-gate；不改写其他记录的论断
Delta: 核心：Becoming.Gated 加“单向：保持与反映”一节（4 → 13 项定理），含一条边界定理；
       外围实例模块及其检查器：LivingOrganizationCorrespondence（4 项定理）；
       可判定性清点：只在证明中用到 223 → 224（origin_of_decides，分情形），边界句加 origin_of_propositions_iff
Supplied premises / correspondence: 核心律不加前提：门是动作上的已定标记，性质不判定；实例沿用 LivingOrganization 的配方、准入反应与所选的池
Evidence: 核心与桥接由核心运行审计（回执 20261015T182202.414009Z）；外围检查器实跑（回执 20261015T182331.625376Z）
Boundary: 见下文“边界”
Integration: §9 一行（Gated 的陈述与计数）；Becoming.lean 的模块条目；一项新记录；一个外围检查器；可判定性清点；归类表中 LivingOrganization 改为已接入
```

**保持与反映（Becoming.Gated，不加前提）。** 非门控步保持性质 p，是说步前成立则步后成立（`PreservedBy`）；反映 p，是说步后成立则步前成立（`ReflectedBy`）。保持一个量恰是保持它的每个值，也恰是反映它的每个值（`keptBy_iff_preserved`、`keptBy_iff_reflected`）；性质沿每段非门控进程被保持（被反映），恰当每个非门控步保持（反映）它（`preserved_along_iff`、`reflected_along`）。

**离开经过门。** 非门控步保持 p 时，从 p 成立处到 p 不成立处的进程含门控动作（`leaving_passes_gate`）。旧律 `change_passes_gate` 是其 p 为“q 等于起点之值”的情形。

**每个起源都经过门。** 非门控步反映 p 时，终于 p 成立处的进程或始于 p 成立处，或分为前段、一个之后 p 成立的门控步与其余（`origin`）。证明沿进程走一遍，只按门分情形：门是 `A → Bool`，已定；p 不判定。

**边界。** 门是命题而非已定时，起源之律在每个门都成立或不成立处成立（`origin_of_decides`）；对每个过程都要求时，它恰是双重否定消去（`origin_of_propositions_iff`）。见证：一步从 `false` 到 `true`，p 在 `true` 处成立，门为 Q；这一步反映 p 恰当 Q 不能不成立，律于是给出 Q。所以门的已定正是这一律所需，不多不少。

**LivingOrganization（LivingOrganizationCorrespondence，外围，自有检查器）。** 以进入池的配方（输出池成员而不输入任何池成员）为门（`entryGate`），其他步反映池的出现（`presence_reflected`，由 `step_pool_origin`）。于是 `trace_pool_origin` 由 `Gated.origin` 给出（`trace_pool_origin_by_core`），并多给出进入步之后池即出现（`entry_then_present`）。外围原定理需要池的可判定；核心律不需要。凡准入配方都闭合时，没有门，`reflected_along` 使空池保持为空（`empty_pool_preserved_by_core`）。实例的公理报告只有 propext 与 Quot.sound，来自 LivingOrganization 自身的算术与列表策略；核心的新声明公理报告为空。

**作者反审。**
1. **新律还是重述？** 旧的双向律是新律的情形，不是反过来。起源之律对核心是新的：外围形式要判定池，核心形式只用门已定。
2. **边界说了什么？** 它说门的已定恰是所需：以命题为门、对每个过程要求时，等于双重否定消去，因而等于排中律。
3. **没有证明的。** 判定 p 时，第一个使 p 成立的门控步（之前 p 不成立）可以由 `change_located` 的方法给出，这里未陈述。

**边界与读法。** 门只定位改变或起源能从哪里进入，不说门控动作改变任何东西。LivingOrganization 的配方、准入反应与所选的池不对应任何实际化学的论断：闭合是所准入配方的已查性质。读法（AI 的，待 Ren）：反映即“后有则前有”，一个组织的池或早已在，或经一次进入而在。

**下一步（I4b）。** Horizon（有限否证与前缀闭包，PrefixSafety、IdealWarrant），Lasting（有限分支的 König 提升，FiniteBranching），Selection（交换不变的服务恰当无并列，PluralRecords、TieBreaking；在 P110 落地之后）。

## 144. 权重计数情境（P117）

2026-10-16。Ren 对 §140 的两条 AI 读法（“分开处的分支只在被走时定下，这是开放的未来在辨识中的形式”；“把权重读作机会，要加上发生的历程典型这一前提”）回答：“i mean we are describing what everything obeys, but at every moment, the actual change depends on the situation. for example, we don't need to gravity for one to see if the logic holds, but in every planet gravity is different, so the whole evolution will also be different, just saying we are all one doesn't make it true, the situation makes it true”；对第二条：“not sure what your typical means, but can you see what to do with my clarification above?”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-the-situation-makes-it-true.md)）。`Becoming.Weighted` 不说权重从何而来，`Becoming.Typicality` 不推出发生的历程典型。本节在第一部分之内、不加公理与前提地陈述：每一步以其自然数权重那么多的情境被走、每个情境固定这一步时，权重是什么。工作板上认领为 P117。

```text
Result(s): 新增 weights-count-situations；复用 typicality-by-counting（courses、extend、total、total_extend、total_add、
           total_congr、weight、cross、square、offBy、typical、stepWeight、along_weight、transfer_weight）；
           sum-over-histories-exact（counting、joinMap、openSteps、courses、Weights.along、Weights.transfer、Weights.sum_courses、
           Weights.sum_joinMap、Weights.sum_map、Weights.sum_congr、Weights.mul_sum、mul_assoc_nat）；Becoming.Joint 的 Determined；
           引用 losses-of-the-sum-over-histories（Interference.cancels）与 counting_transfer_iff 作界；
           改写 identification-where-runs-part 与 typicality-by-counting 的读法（Ren 的说明）
Delta: 新核心模块 Becoming.Situations（导入 Typicality；13 项定理／19 项声明）；Parting 与 Typicality 只改模块说明中的读法，
       定理与声明不变
Supplied premises / correspondence: 不加公理；自然数的步之权重、列出的动作与配置写在定理中（sum_finer、finer_count）；
       两个值（situations_*）；按历程计数用到历程相等可判定（total_only、situations_of_course）
Evidence: scratch_build 对 main 6c62e13e（P115 之后）：Becoming.Situations 13 项定理、19 项声明，Parting 18／27 与
          Typicality 32／44 只改说明后重编译，公理报告全部为空，无警告；根模块见下“检查”；合并检查器回执待整合者的运行
Boundary: 只陈述自然数权重；带符号的权重会相消，不是情境之数；按历程计数与大数定律只对两个值陈述；哪个情境实际发生
          不是计数，不被推出；“情境”在这里是走一步的方式，Ren 的“情境”更广（哪个世界、它的局部之律）；不含伦理谓词
Integration: 第 6 节新段落对（在运行分开一段之后）与该段读法的改写；§8 状态行、辨识的读法、路径分支时的开放项；
       理论的完整陈述一条；界一项；第一部分的总陈述“认识”；§9 一行；术语表一行；Becoming.lean 的导入与模块说明；
       check_becoming.py 的核心之列与范围；Lean README 一行与层内导入；一项新记录，两项记录的读法
```

| 声明 | 内容 |
|---|---|
| `Situations.upto`、`sum_upto`、`sum_one` | 前 k 个数；常数读数在其上之和是 k 倍；计一之和是长度 |
| `Situations.finerLaw`、`finerLaw_determined`、`finerLaw_step_iff` | **以情境为动作，律是确定的。** 情境 (a, m, k) 把 s 带到 m，当它是从 s 经 a 到 m 的 weight s a m 个情境之一；这个律是确定的，恰在步的权重为正处走这一步 |
| `finerSteps`、`finer`、`coarse` | 从一个配置出发的情境、n 步的细历程、细历程忘掉情境所走的历程 |
| `sum_finer` | **自然数权重计数情境。** 对每个列出动作与配置、以自然数为步之权重的过程，历程的任一读数在 n 步细历程上之和，是它在历程上、每个乘以其权重之和（一次对步数的归纳，经 `Weights.sum_joinMap`） |
| `finer_count` | 细历程之数就是历史之和（经 `Weights.sum_courses`） |
| `sum_courses_values` | `Becoming.Weighted` 中两个值的自由分支的历程，就是 `Becoming.Typicality` 的历程 |
| `situations_count`、`mul_indicator`、`total_only`、`situations_of_course` | **一个历程的权重是走它的情境之数**：每步 p 个与 q 个情境时细历程共 (p + q)ⁿ 个；每个历程在历程之列中只出现一次 |
| `far`、`weight_far`、`situations_typical` | **大数定律计数情境**：历程偏差至少为 d 的细历程之数乘 d 至多 n·p·q·(p + q)ⁿ（经 `Typicality.typical`） |

**它回答了什么。** Ren 的说明分两层。其一，理论描述每样东西所遵从的：核心的每条定理对每个过程、世界与运行成立，不固定任何情境，就像逻辑不需要一个重力之值。其二，实际的变化依赖情境，情境使之为真：哪个世界、它的关系项与交换、起点与局部之律，固定实际的历程；不同的行星给出不同的演化。第二层对 §140 的两条读法各有一个回答。分开处：记录与所给的律都不固定走哪条路，情境固定它；“开放的未来”的读法撤回。这与 Ren 2026-10-12 已同意的读法一致（“there are no two realities”）：一段历史显示的律，连同保留的历史读，只容许这一段（`Run.keepHistory_shown`，§91）；本节补上计数的一面：以情境为动作，律是确定的（`finerLaw_determined`）。机会：自然数权重是走每一步的情境之数（`sum_finer`、`situations_of_course`），大数定律说同类情境中多数给出接近权重之比的频率（`situations_typical`）；哪个情境发生不是计数。所以陈述机会不需要“发生的历程典型”这一前提，它是同类情境之数；预言发生的那一个历程，则需要它的情境。

**关于 Ren 的话（AI 的注，按 Ren 2026-10-15“if my earlier words are unreasonable, please keep note, not follow blindly”）。**
1. **重力的例子。** 万有引力之律是所有行星共同遵从的，各行星表面的重力之值是情境的。例子在这个意义上成立：“we don't need gravity”指不需要它的值，不是不需要引力之律；引力之律本身属于“每样东西所遵从的”一边（若它是普遍的），而核心不推出它，它是一个经验的律，以一个过程给出。
2. **“the situation makes it true”。** 在核心中，以情境为动作，律是确定的；一段历史显示的律只容许这一段。所以“实际的变化由情境固定”在表示上总能做到，不需要公理。它不说情境比记录或所给的律更少：分开处，固定下一个值的情境不在先前所识之中（`Parting.not_right_on_both`）。它也不说情境是不依语境的：带符号的权重会相消（`Interference.cancels`），语境中的识不总能粘成一个不依语境的赋值（`Becoming.Context`、`Becoming.Quantum`，以及进行中的 P112）；在这些地方，使之为真的情境必须包括读它的语境，不依语境的情境之数给不出这些统计。
3. **“just saying we are all one doesn't make it true”。** 这与方法一致：一元是方法上的要求（AGENTS 与 NONDUAL-METHOD），不是推出特定事实的前提；核心的一元在于所有定理陈述同一展开，特定的真由情境给出。

**读法（AI 对 Ren 的话的读法，Ren 同日已取，见下）。** 核心陈述每个情境所遵从的；实际的变化由情境使之为真；分支的律是一个确定的律忘掉了情境；机会是同类情境之数。§140 的两条读法由此取代；§140 保留原文作为历史。

**Ren 的判断。** 2026-10-16，对报告本节结果、并重述上面读法的回答，Ren 说：“yes, i take those readings”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-the-situation-makes-it-true.md)）。所以上面四条读法（核心陈述每个情境所遵从的；实际的变化由情境使之为真；分支的律是忘掉情境的确定的律，分开处由情境固定；机会是同类情境之数）是 Ren 取了的读法；“关于 Ren 的话”中的三条注仍是 AI 的注。有界时类的名是否读作它的有限的未来，仍待 Ren。

**作者反审。**
1. **已知的结果。** 以同等可能的情况之数读概率（拉普拉斯）、以微观状态之数读宏观的权重（玻尔兹曼），以及把非确定的系统表示为一个确定的系统在更细状态上的投影，都是已知的。增量是：在核心中不用公理，接到 `Becoming.Weighted` 的历史之和与 `Becoming.Typicality` 的大数定律，并且对每个过程（`sum_finer`），不只对两个值。
2. **强度。** `sum_finer` 是对任一读数的推前，所以对每个过程都成立；“一个历程的权重是走它的情境之数”只对两个值陈述，因为它要每个历程在列表中只出现一次（`total_only`）；对任意过程，这要求列出的动作与配置无重复，没有陈述。
3. **“情境”的范围。** 这里的情境是走一步的方式。Ren 的“情境”更广：哪个世界、它的局部之律（各行星的重力）。后者在核心中就是对过程的量化：每条定理对每个过程成立，所以一个世界的局部之律是哪一个过程；不需要新定理。
4. **名字。** `Situations`、`finerLaw`、`finer`、`coarse`、`upto`、`far` 都是结构性的名字；“情境”取自 Ren 的话。
5. **证明。** 不用 `simp`、`omega`；结合律用 `mul_assoc_nat`；`if_pos`、`if_neg` 与 `List.cons.inj`；`Nat.succ_mul` 与 `Nat.one_mul` 不引入公理（审计为空）。

**检查。** 在暂存区对 main 6c62e13e（P115 之后）编译：`Becoming.Situations` 13 项定理、19 项声明，`Becoming.Parting` 18／27、`Becoming.Typicality` 32／44（只改说明）；没有错误或警告，公理报告为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 145. 有限历史所否证者（整合 I4b 第三项）：可否证、附着与 Markov 原则，PrefixSafety 接入

2026-10-16。Ren 对 I4 归类表选择“Closest gaps first”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-i4-decisions.md)）。表把 PrefixSafety 读作待接入的律：对无穷迹，有限可否证的性质在其前缀闭包内即成立，前缀闭包是最小的有限可否证超集，复现与终于为真不可有限否证，由前缀测试给出的性质可有限否证。Becoming.Horizon 陈述了有限前缀不决定什么，未陈述有限历史否证什么（§139）。本节对每个过程陈述它，PrefixSafety 的前缀拓扑是所有序列构成的过程的实例。IdealWarrant 在偏序上推广同一形式，属 Ren 暂留脊柱外的一般数学线。

```text
Result(s): 新记录 what-a-finite-history-refutes；becoming-finite-horizon 与 no-finite-part-bears-taking 改绑（论断不变）
Delta: 核心：Becoming.Horizon 加“有限历史所否证者”一节（12 → 34 项定理），含一条边界定理；
       外围实例模块及其检查器：PrefixSafetyCorrespondence（9 项定理），在完成包旁；
       可判定性清点：边界定理加 refutable_passes_iff_markov，边界句加“在门上定位起源、由前缀检验否证”；只在证明中用到的不变（224）
Supplied premises / correspondence: 核心律不加前提：过程、读法与运行任意，测试是布尔值并由到其步的历史决定；Markov 原则与稳定是所用定理的假设；实例沿用 PrefixSafety 的迹（自然数上的函数）
Evidence: 核心由核心运行审计（回执 20261015T184418.886926Z）；外围检查器实跑（回执 20261015T184605.889457Z）；PrefixSafety 经实例回执绑定，其字节与完成包回执相合
Boundary: 见下文“边界与读法”
Integration: §9 Horizon 一行（陈述改为中英，计数）与一个外围行；Becoming.lean 的模块条目；完成包 README；一项新记录；两项记录改绑；一个外围检查器；可判定性清点；归类表中 PrefixSafety 改为已接入
```

**到界一致、可否证与附着（不加前提）。** 两个运行到一界一致是自反、对称、传递的，界缩小仍一致（`Run.AgreeUpTo.refl`、`symm`、`trans`、`mono`）。读法可否证（`Refutable`）：其外每个运行有一界，界内与它一致的运行都在读法之外；可证实（`Verifiable`）对偶。运行附着于读法（`Adheres`）：每一界内它都与读法内某运行一致。读法内的运行附着于它，附着随读法扩大，附着于附着者即附着（`Adheres.of`、`mono`、`adheres`）。

**可否证的读法在附着处成立，于双重否定下。** 可否证的读法在每个附着于它的运行上不能不成立（`Refutable.not_not`）：否则其界内有读法内的运行与它一致，而界内一致者都在读法之外。可否证的超集在附着于子集的运行上亦然（`Refutable.adheres_least`），这是前缀闭包最小的核心形式。读法稳定（不能不成立即成立）时，附着即成立（`Refutable.adheres_iff`）。

**不可否证与不可证实的见证。** 运行附着于读法而在其外，读法不可否证（`not_refutable_of_adheres`）；附着于补集而在其内，读法不可证实（`not_verifiable_of_adheres`）。在所有序列构成的过程（`Sequences.process`，动作序列即运行）中，把序列在一界后接成常值，界内一致不变（`splice_agree`、`splice_after`）。于是全假的序列附着于复现与终于发生而在其外：两者皆不可否证（`Sequences.recurs_not_refutable`、`eventually_not_refutable`），从不发生不可证实（`never_not_verifiable`）。

**由测试构成的读法。** 第 n 个测试是布尔值，由到第 n + 1 步的历史决定（`ByPrefixes`），读法即没有测试失败（`Passes`）。它在每个附着于它的运行上成立（`adheres_passes`），不需双重否定：测试已定。给定 Markov 原则（`Markov`：不全为假的布尔序列有真项），它可否证（`refutable_passes`）：不全通过时找到失败的测试 n，界取 n + 1。布尔序列的每个有限前缀或全假或已见真项（`false_below_or_true`），由归纳，不加前提。

**边界。** 对每个过程都要求时，由测试构成的读法可否证恰是 Markov 原则（`refutable_passes_iff_markov`）。见证：所有布尔序列的过程，第 n 个测试读第 n 项。给定不全为假的序列 s，可否证给出一界 h；h 之前若已见真项即得；若全假，把 s 在 h 后接成全假，与 s 界内一致，却通过全部测试，矛盾。所以否证所需的，正是在只知并非全部通过时找到失败的测试。PrefixSafety 的 `boundary_closed` 以经典推理得之，那里这一步是隐含的。

**PrefixSafety（PrefixSafetyCorrespondence，外围，自有检查器）。** PrefixSafety 的迹是所有序列过程的运行，`SamePrefix` 即核心的 `Run.AgreeUpTo`（`samePrefix_iff_agree`），有限可否证即 `Refutable`，前缀闭包即附着（`finiteRefutable_iff_refutable`、`prefixClosure_iff_adheres`）；复现与终止事件不可有限否证由核心的 `Sequences` 律给出（`recurrence_not_finiteRefutable_by_core`、`terminationEvent_not_finiteRefutable_by_core`）。这五项公理报告为空。以经典推理去掉双重否定，`Refutable.not_not` 与 `adheres_least` 给出闭包内即成立与闭包最小（`holds_of_prefixClosure_by_core`、`prefixClosure_least_by_core`）；经典推理给出核心的 `Markov`（`markov_classical`），`refutable_passes` 给出 `boundary_closed`（`boundary_closed_by_core`）。这四项只用标准公理。PrefixSafety 的定义与陈述不变，其包回执仍有效。

**检查器。** PrefixSafety 在核心模块索引的 Lean 根之外（完成包，Lean 4.29.1，导入 Std）。`check_prefix_safety_correspondence.py` 由 `make_checker.py` 生成后做三处改动（`make_prefix_checker.py`）：Lean 根指向 `generative-basis/lean`；PrefixSafety 与实例从完成包加入索引；PrefixSafety 与完成包回执匹配，该回执由包的 `check.py` 只在全部模块新编译、全部审计通过后写出。干跑（回执写到临时目录）在 Lean 4.30.0-rc2 下通过：9 项定理，五项公理报告为空；唯一没有回执的是新的 Becoming.Horizon，待核心运行。

**作者反审。**
1. **新律还是重述？** 对脊柱是新的：Horizon 只有不决定之律。核心形式在任意过程上，PrefixSafety 只在 `Nat → A` 上且用经典推理。Markov 边界是全新的，PrefixSafety 没有相应结果。
2. **为何是双重否定？** 不是有意减弱：读法只是命题，“不能不成立”到“成立”需要读法稳定；`adheres_iff` 表明稳定时附着即成立。此处未证明稳定恰是所需。
3. **与有限视界的关系。** `prefix_does_not_decide` 说没有有限前缀的读法与整段分类相符。`Renewable` 中“更新”一类是否可否证，这里未作实例：其两个运行随界而变，没有固定的运行附着于另一类。
4. **没有证明的。** IdealWarrant 在偏序上的形式；`refutable_passes` 的逆（每个可否证读法都是某组测试的通过集）。

**边界与读法。** 本律说可否证给出什么，不说哪些实际读法可否证：这取决于读它的过程。PrefixSafety 的迹是自然数上的函数，不是实际历史的模型。读法（AI 的，待 Ren）：有限记录能显示的，是运行在可否证读法之外；运行在其内只是未被否证。由测试否证，须在只知并非全部通过时找到失败的测试。

**下一步（I4b）。** Lasting（有限分支的 König 提升，FiniteBranching）；Selection（交换不变的服务恰当无并列，PluralRecords、TieBreaking；在 P110 落地之后）。

## 146. 有限分支处的提升（整合 I4b 第四项）：持续某段进程，FiniteBranching 接入

2026-10-16。Ren 对 I4 归类表选择“Closest gaps first”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-i4-decisions.md)）。表把 FiniteBranching 读作待接入的律：对有限分支的关系，从一点出发有每个长度的有限路径，就有一条无穷路径（König 提升）。Becoming.Lasting 陈述了每个可容许进程都留下（`Lasts`；无进程离开者恰是持续每个步数者，`kernel_iff_lasts`），未陈述某段进程延续（§139）。本节对每个过程陈述它，并说明每一步各需什么。

```text
Result(s): 新记录 lifting-where-branching-is-finite；market-supported-finite-transition、market-partial-correction-boundary、market-finite-support-obstruction 改绑（论断不变）
Delta: 核心：Becoming.Lasting 导入 Becoming.Likeness，加“持续某段进程”一节（69 → 89 项定理），含一条边界定理与一个反例；
       外围实例模块及其检查器：FiniteBranchingCorrespondence（9 项定理），在完成包旁；
       可判定性清点：只在证明中用到 224 → 226（list_throughout_not_not 分情形，TwoChains.branching 造出列表），证明可判定者 136 → 137（Continues.decided），边界定理加 Lasting.step_iff_either，边界句加“在有限分支处找到无界的后继”
Supplied premises / correspondence: 核心律不加前提：过程任意，有限分支是假设；EitherThroughout 与对无界后继的选取是所用定理的假设；实例沿用 FiniteBranching 的关系与子节点列表
Evidence: 核心由核心运行审计（回执 20261015T190408.610189Z）；外围检查器实跑（回执 20261015T190529.548268Z）；FiniteBranching 经实例回执绑定，其字节与完成包回执相合
Boundary: 见下文“边界与读法”
Integration: §9 Lasting 一行（陈述与计数）与一个外围行；Becoming.lean 的模块条目；Lasting 的文件说明；完成包 README；一项新记录；三项记录改绑；一个外围检查器；可判定性清点；归类表中 FiniteBranching 改为已接入
```

**持续某段进程（不加前提）。** `Continues P n s`：某段 n 步的进程始于 s；`Unbounded P s`：每个长度的进程都始于 s。过程有限分支（`FinitelyBranching`）：每个配置的后继列出。n + 1 步的进程以 n 步的进程开始（`Continues.down`）；有限分支处所达深度已定（`Continues.decided`），由列出的后继逐层判定，不需判定相等。

**无界的后继，于双重否定下。** 列表的成员满足已定递减族的每一步时，某成员处处满足，于双重否定下（`list_throughout_not_not`）：目标是否证，故“首个成员是否某处不满足”可当作已定；若某处不满足，其后各步由其余成员满足，归纳于列表。于是有限分支处，无界配置不能没有无界后继（`Unbounded.step_not_not`）。

**给定 EitherThroughout。** 无界配置有无界后继（`Unbounded.step_of_either`），有限个起点中有每个长度进程者时其一无界（`unbounded_start_of_either`）：两者都是 Likeness 的 `EitherThroughout.list` 用于列出的后继或起点。

**运行由选取给出。** 留在一族之内的步的选取，从族的每个成员给出留在族内的运行（`runOf`、`runOf_start`、`runOf_within`）。提升：有限分支处，EitherThroughout 与在有无界后继处对它的选取，使每个无界配置开始一个沿无界配置的运行（`lifting`）。

**边界。** 对每个有限分支过程都要求时，无界配置有无界后继恰是 EitherThroughout（`step_iff_either`）。见证是 Likeness 的 `Chains`：两个已定递减族每步有一个成立时，分叉 `two` 无界（`TwoChains.two_unbounded`）；其无界后继是某条链的链首，该链的族处处成立（`TwoChains.side_of_unbounded`）。所以 EitherThroughout（LLPO 的形式，Likeness 中已证其等于 EitherNever）恰是这一步所需。

**无有限分支时（扇）。** 根步到每个长度的臂（`Fan`）：根有每个长度的进程（`Fan.root_unbounded`），而长 n 的臂没有 n + 1 步的进程（`Fan.arm_bounded`），所以根的后继都不无界（`Fan.no_unbounded_step`）。有限分支是提升所需，不只是证明所用。

**FiniteBranching（FiniteBranchingCorrespondence，外围，自有检查器）。** 关系即一个动作的过程（`process`），`Reach` 即 `Continues`，`Unbounded` 即 `Unbounded`，列出的子节点使过程有限分支（`reach_iff_continues`、`unbounded_iff`、`finitelyBranching`），这四项公理报告为空。经典推理给出 EitherThroughout（`either_classical`），Lean 的选择在有无界后继处选取它；于是 `finite_unbounded`、`unbounded_child`、`infinite_from_unbounded`、`finite_initial_lifting` 与 `labelled_lifting` 由核心律给出（各为 `_by_core`），只用标准公理。FiniteBranching 的定义与陈述不变，其包回执仍有效。

**检查器。** 与 PrefixSafety 的实例同一模式：`make_prefix_checker.py` 现在接受 `SPEC MODULE`，不带参数时逐字节重现 PrefixSafety 的检查器；`branching.json FiniteBranching` 生成 `check_finite_branching_correspondence.py`。干跑（回执写到临时目录）在 Lean 4.30.0-rc2 下通过：9 项定理、10 项声明，四项公理报告为空；唯一没有回执的是新的 Becoming.Lasting，待核心运行。依 I4b-3 落地的修正，FiniteBranching 经实例回执绑定。

**作者反审。**
1. **新律还是重述？** 对脊柱是新的：Lasting 只有“每个进程都留下”的一侧。外围原证明用 `Classical.not_forall` 与 `Classical.choose`；核心把这两步分开，前者恰是 EitherThroughout（`step_iff_either`），后者是选取。
2. **导入 Likeness。** Lasting 的闭包由 5 个模块增到 31 个；依赖 Lasting 的五个模块（Courses 与四个桥接）重建无误，公理报告为空。复用 EitherThroughout 与 Chains，而不另立平行的原则。
3. **没有证明的。** 不用选取时运行的存在（依赖选择的边界，与 Keeping 的 `plans_iff_choice` 相邻而不同）；对每个过程要求“有每个长度进程者有运行”时恰需什么。

**边界与读法。** 提升给出运行的存在，不给有效的选取或物理的无穷；FiniteBranching 的应用说明（具体历史的扩展关系、固定的标签序列）保留其范围。读法（AI 的，待 Ren）：有每个长度的进程尚不是一段延续的进程；有限分支处，二者之间所隔的恰是在两支之间知道哪一支处处延续。

**下一步（I4b）。** Selection（交换不变的服务恰当无并列，PluralRecords、TieBreaking；在 P110 落地之后）。

## 147. 依 Ren 的交托决定的读法（P110）

2026-10-15／16。Ren 在 P107 落地之后问：“What's the best choices to make? please make best of your judgement, and push the frontier of completeness”（[原话](../../../../sources/15-codex-theory-conversations/2026-10-15-delegated-choices.md)）。这被读作交托：理论第 8 节列为 Ren 的选择、[CONTINUATION-GROUNDING-PLAN](../history/root-foundation/CONTINUATION-GROUNDING-PLAN.md) §6 与各结果记录留给 Ren 的读法与名称，由 AI 以其最好的判断决定；每项写明理由与会改变它的东西，记为依 Ren 2026-10-15 的交托所作的决定，不记为 Ren 自己的决定，Ren 可改其中任何一项。交托的另一半，“推进完整的前沿”，见 §148（P111）与 §149（P112）。工作板上认领为 P110。

```text
Result(s): 不新增结果；决定记录 DELEGATED-CHOICES（D1–D39）。101 项记录各加一条成对的、注明日期的说明：此前留给 Ren 的读法与名称
           按所列决定改为采用或不采用，请 Ren 判断这些读法的下一步删去；各记录的结果编号、陈述、证明与绑定不变
Delta: 读法的状态，不是数学。理论第 8 节“属于 Ren 的选择”一类改为“依 Ren 的交托决定”，列出仍属 Ren 者；第 6 节各处“读法（AI 的，
       待 Ren）”改为“依 Ren 2026-10-15 的交托采用”；Lean 的模块说明（51 个模块与根模块）与 Lean README 折叠决定，只改注释
Supplied premises / correspondence: 不加前提。读法的标准（AI 的）写在决定记录 §0：Ren 的原话优先；不加前提；已检查的结果能定的由它
       定；确切范围；关系优先；不丢失
Evidence: 每项决定引 Ren 的原话或已检查的定理。fold_docstrings.py 断言每处替换恰好一次、每个 Lean 文件去掉注释后的文本不变，改动的
          段落重排时只改换行（文件的词不变）；reconcile_records.py 断言每处特定替换恰好一次；scratch_build 对合并 main a5406334 后的树：
          232 步中 126 步运行（I4b-3 改了 Horizon，其后的模块重编）、106 步复用，无警告，54 个改动的模块（含根模块）的公理报告全部为空
Boundary: 决定记录 §10 所列不在交托之内，照旧属 Ren；决定不是证明，也不说 Ren 持有什么；在 Ren 2026-10-15 的回答之后提出的读法
          （P116 的“按情境”连同其限定）留给 Ren；Ren 2026-10-16 取了 AI 对其说明的读法（§144）
Integration: 理论第 6、8 节；DELEGATED-CHOICES；101 项记录；Lean 模块说明与 README；指令登记一项（2026-10-15-delegated-choices）
```

| 组 | 决定 |
|---|---|
| 生生与生成的空间（D1–D5） | 生生读作生成的空间，即能形成者的扩大；“生成的”“退化的”是扩大与缩小，保持为中性，互相超出为混合，在形成的层次上是更新与消耗；活动的读法（生起与止息的复现）不采用：二者在有限世界中重合，而 Ren 的“不overlap吧”预设二者不重叠；第二个“生”是能形成者；生生不息读在整体的层次，即经更新而复现的生起 |
| 终结、侵蚀、开放与所持条件（D6–D10） | 终结之步的汲取与侵蚀是逐步读法的判定，保留为定理，不作为对汲取者的估值；开放是每个有限家族之外的交换，增益另名（§148 证明增益从哪里来）；以之为生、世系与输送是已形成的关系，不是直接的估值 |
| 想要延续者与一条公理（D11–D16） | S0 即想要；公理的辖域是“anything”（Ren 的原话）；“不损”读作保留，其边界是余量，即 Ren 所说的相变；“更多”是方向，不是最大化；`Unrestricted` 读出公理，A 读在活的内容上 |
| 不用公理的路线、反馈与所及（D17–D20） | 供给闭包读出“what it actually depends on”；路线 (b) 不足以达到 G0 的辖域，两者都保留；所及闭包读出“the system that one is in” |
| 公理的分解（D21–D22） | 预设、覆盖与层级的次序采用；不变之步属 Ren 的陈述；生成的空间读出 Ren 的两句话 |
| 一个展开、动作、因果与学习（D23–D26、D37、D39） | 以各记录的确切范围采用；律读有限多个条件时，识在形式上读作律的敏感，识本身仍属 Ren（D37）；耦合强度在形式上读作识的强弱，纠缠读作耦合的强度，不等同于量子的纠缠（D39） |
| 从关系开始的重建（D27–D29） | 五项读法采用，与曲率的等同只作类比；熵是守恒量中的记录 |
| 交换、步、历史、描述与辨识（D30–D35、D38） | 以确切范围采用；“按情境”不读作界，由 Ren 自己 2026-10-15 的回答决定（D34） |
| 名称（D36） | AI 的工作名称在陈述有其确切意义处采用；Ren 的用语仍属 Ren |

**它回答了什么。** Ren 的问话有两半：作出最好的选择，推进完整的前沿。前一半在这里：此前在理论、101 项记录、51 个 Lean 模块与根模块中称为“AI 的读法，待 Ren”的读法与名称，现在每一处都有一个编号的决定、它的理由和会改变它的东西，Ren 可以逐项改动。标准把决定限在读法之内：它们不改动任何定理，不给任何规律加前提；不采用的读法，其定理照旧保留，只是不再是理论的读法。有几项不是由判断而是由已检查的结果决定的：活动的读法（D2）被生起与止息在有限世界中重合这一定理排除；“按情境就是界”（D34）被 Ren 自己的回答排除。另一些在合乎原话的几种读法中取不加前提的一种：识在形式上读作律的敏感（D37），因为那是律所经的最小的识，取它不在律之外加任何东西。

较早各节写着“读法待 Ren”的，按记录中的决定读；那些节的文本作为当时的证据保留，不改写。

**D34 与 Ren 的回答（按 Ren 2026-10-15 的“if my earlier words are unreasonable, please keep note, not follow blindly”）。** D34 起初采用读法 1，“按情境就是界”。Ren 在另一会话中回答：“not sure what's the reading 1, but reality is always situational”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-15-situational-and-the-whole-core.md)）。D34 因此改为由 Ren 的话决定：“按情境”不读作界；状态数的界是情境的有限记录确定所识一切的条件。P116 在 Ren 的回答之后提出的读法，“完整的真按情境可推出”连同其限定，不由这一交托决定，留给 Ren（§140，决定记录 §10）；Ren 2026-10-16 说明“the situation makes it true”，并取了 AI 对这一说明的读法（§144），它们是 Ren 取了的读法。有界时类的名读作它的有限的未来，D34 曾以确切范围把它作为“名可名”的类比采用（这一读法在交托之前已列在第 8 节属于 Ren 的选择中）；Ren 2026-10-16 取了同一读法（“take 2”，[原话](../../../../sources/15-codex-theory-conversations/2026-10-16-finite-name-and-open-proofs.md)）：定理是有界时类有有限的名，“名可名”只是类比，所以这一项由 Ren 的话决定，§144 的“仍待 Ren”由此回答。

**不在交托之内的。** Ren 自己的文本与用语（OPENING 及其脚注、静止的中文用语与“静止定理”这一标题、“closure bounds change”、识与理作为 Ren 的读法）；Ren 是否持有不变之步；第二部分那一条断言的规范根据；I4；Ren 2026-10-11 保留的表示决定（离散的步、自然数的量、无穷多立着者处的普查、判定的相等与列出）；审查的决定。

**作者反审。**
1. **交托本身是一个读法。** 把 Ren 的问话读作对读法与名称的交托，是 AI 的读法；它记在指令登记中，每项决定都记为依交托的、AI 的决定，不记为 Ren 的。若 Ren 只是在问意见，决定就退为建议，数学不受影响。
2. **决定会不会偷渡结论。** 采用一个读法，可能看起来像是解决了哲学问题。标准（不加前提、确切范围、关系优先）限制了这一点，规范根据不在交托之内。最需留意的是 D1（生生读作生成的空间）与 D13（不损读作保留）：两者的形式部分有定理支持，而说它们是好的，仍是要论证的主张（§6.13 的“应当”）。
3. **D34 先错了一次。** 依交托的决定可以被 Ren 后来的话推翻。这一修正表明决定在 Ren 的话面前可修正，也表明在 Ren 的回答到达之前采用一个读法有风险；记录与理论现在都写明这一项由 Ren 的话决定。
4. **维护的代价。** Lean 的模块说明现在引用决定的编号；Ren 若改动一项，相应的注释要改。决定编号可搜索，fold_docstrings.py 记下了每处改动，这降低了代价。
5. **名称。** P115 把它的度量称为“耦合强度”，把“增益”留给 §148；两个名称各有其确切意义。
6. 本节未经独立审查。

**检查。** 记录的风格检查：0 项错误；软的长度提示照旧，其中 correspondence 一类按规则只提示。研究检查的预期错误只在两项新记录（回执在落地时绑定）；本批的文本改动带来的漂移，在落地时由整合者重绑。Lean 只改注释，注释之外的代码在每个文件中都断言不变；暂存区构建见上。

## 148. 新的增益从哪里来：算入其余，每次上升都是被给予的（Becoming.Gain；P111）

2026-10-15／16，同一交托之下（Ren 2026-10-15：“push the frontier of completeness”，[原话](../../../../sources/15-codex-theory-conversations/2026-10-15-delegated-choices.md)）。`Becoming.Novelty`（§125）只在水平上证明了只有增益者才新：每步都新的家族超过每个界。returning-novelty-forgetting-on-levels 的读法说，新而不止是无界的增益，必须来自部分之外。本节在第一部分之内证明它，不加公理：增益从哪里来。D7 把开放与增益分开，这里给出两者在哪里汇合。

```text
Result(s): 新增 where-novelty-gain-comes-from；复用 returning-novelty-forgetting-on-levels（Web.exceeds_of_new、Web.revisits_of_bounded、
           Flow.uncarried_of_bounded、Web.counting、Web.counting_new、upto_or_fails）、imbalance-as-relatum（Flow.withImbalance、
           Flow.withImbalance_balances、Flow.balancesOn_iff_idle、mem_of_some_mem、sub_eq_zero_of_le）、entropy-history-and-record
           （configurationsWithin、Web.config_within、nonrising_between、Flow.Balances.nonrising、Flow.Gainless、Flow.exchanges、
           Flow.CarriesHistory）、continued-change-needs-openness（Flow.ClosedAt、total_eq_zero）、recurrence-without-premise
           （revisits_within）、more-needs-renewers（Flow、rises_between、search、Distinct）、becoming-dependence-dynamics（Web、
           Web.Supported、requires、need）
Delta: 新核心模块 Becoming.Gain（导入 Novelty；30 项定理／35 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；每次上升被给予不用前提；第一律（Flow.Gainless）、家族不重复（Distinct）、整体列出每个
       条件、其余不给净量、所要求者及其多少固定于家族之内（Web.RequiresWithin），都写在各自的定理中
Evidence: scratch_build 对合并 main a5406334 后的树：Becoming.Gain 30 项定理、35 项声明，公理报告为空，无警告，根模块与其闭包一同编译
Boundary: 实际的部分是否开放、其余在实际展开中是哪个关系项、其交换是否不止，都是对应；存量之内构型数之界是否可达没有陈述；离散的步与
          自然数的量；不含伦理谓词
Integration: 理论第 6 节（第一部分的总陈述）、第 8 节（D5、D7 的读法）、第 9 节一行、术语；Becoming.lean 的导入与说明；
          check_becoming.py；Lean README；新记录；returning-novelty-forgetting-on-levels、continued-change-needs-openness、
          where-a-move-is-formed 的 related
```

| 声明 | 内容 |
|---|---|
| `Flow.NetGiver`、`Flow.rise_netGiver` | **每次上升都是被给予的。** 跨一步家族的存量上升时，算入其余的流中某个关系项给家族的多于从它取的；不加前提：算入其余，每个流都平衡（`withImbalance_balances`），平衡的家族在无人净给时不上升（`Balances.nonrising`）；给者经逐个核对参与者找到，不判定任何无穷者 |
| `Flow.netGiver_cases`、`Flow.rise_given`、`Flow.rise_given_between` | 净给者是其余，或参与的某个形成；一段上的上升在其中某一步被给予 |
| `Flow.rest_netGiver_iff`、`Flow.BalancesOn.rest_not_netGiver` | 其余给净量，恰当家族上水平的上升超出诸形成的净交换；流在家族上平衡时其余不给净量 |
| `Flow.rise_from_rest_or_open` | **第一律之下：来自其余，或跨过边界。** 无中不生有（`Flow.Gainless`）时，不重复的家族上升，其余给它净量，或它在那一步不封闭：某个参与的形成越出它而交换 |
| `Flow.whole_rise_from_rest`、`Flow.whole_bounded_of_rest_idle`、`Flow.whole_recurs_of_rest_idle`、`Flow.whole_not_new_of_rest_idle` | **有限的整体只从其余增益。** 列表持有每个条件时没有边界可越，每次上升都是其余的；其余从 T 起不给净量时，整体留在 T 时的存量之内，从每一步起都有一个配置出现两次，流在任意晚的步与它交换时其配置不承载交换的计数，它不是每步都新：有界整体中的不息生成是回返 |
| `Web.rises_within_of_new`、`Web.rises_late_of_new`、`Web.config_eq_of_sub`、`Web.new_of_sub` | **新需要增益。** 在多于存量之内构型数的连续步上都新的家族在这一段之内上升；每步都新的家族在任意晚的步上升；持有它的家族亦然 |
| `Web.NewAt`、`Web.exceeds_of_firsts`、`Web.rises_late_of_firsts`、`le_of_increasing` | 沿首次到访（不必连续）同样：存量在首次到访的前 N + 1 个之一超过界，首次到访不止时在任意晚的步上升 |
| `Flow.new_from_rest_or_open`、`Flow.new_beyond_every` | 在第一律之下每次这样的上升来自其余或跨过边界，对每个持有它的不重复家族都如此：没有有限家族封闭于无尽的新之上 |
| `Web.RequiresWithin`、`Web.supported_of_config`、`Web.FirstSupported`、`Web.newAt_of_first`、`Web.rises_late_of_newly_supported`、`Flow.newly_supported_from_rest_or_open` | **新形成需要增益。** 所要求者及其多少固定于家族之内时，家族的水平是否支持一个形成只取决于配置；首次被支持之步是首次到访；不止的新形成需要家族在任意晚的步上升，在第一律之下来自其余或跨过边界 |
| `Flow.empty`、`Flow.empty_gainless`、`Flow.counting_given_by_rest` | **从其余而来的新。** 计数（`Web.counting_new`，每步都新）在无人参与、无中不生有之处，每步由其余给一单位：其余是有限整体唯一的来路 |
| `map_eq_at`、`map_eq_on`、`add_one_sub_self`、`some_mem_tail` | 列表与自然数的辅助 |

**它回答了什么。** returning-novelty-forgetting-on-levels 的读法现在是定理，而且更确切：增益的来路恰有两条，跨过家族的边界，或来自其余，即整体中未被列出的那部分。算入其余是关键：`Becoming.Imbalance`（§85）把不平衡算作一个关系项，所以每次上升都有给者，不用任何前提。在第一律之下，不重复的家族没有第三条路。有限的整体每个条件都列出，没有边界可越，于是每次上升都是其余的；其余闲置时整体回返而遗忘，不是每步都新。所以在有界的整体之内，生生不息是更新的复现（D5），无尽的新需要整体的列表之外有给予者。D7 把开放与增益分开：家族可以封闭而从其余增益（`Flow.counting_given_by_rest`），开放也可以净量为零；在第一律之下二者汇合：增益来自其余，或越出边界。

**读法（AI 的，依 Ren 2026-10-15 的交托采用，D5、D7）。** “来自部分之外的增益”读作这两条路；其余计入所列关系项不做的，所以无尽地新的有限整体，是其列表漏掉了给予它者。`Becoming.Coupling`（§131）对动作陈述其对应：列表所持者形成的动作在列表长度之内重复。

**作者反审。**
1. **已知的结果。** 存量的上升需要流入，是守恒（存量之变等于流入减流出）；有界的有限系统回返，是鸽巢原理（有限状态上 Poincaré 型的回返）；首次到访之界也是鸽巢。增量是：在核心中不用公理，“算入其余，每次上升都被给予”不用前提；在第一律之下给者只能是其余或边界；有限整体唯一的来路是其余；首次被支持之步就是首次到访，这把新形成接到增益上。
2. **恰好与否。** 界（存量之内的构型数）是否可达没有陈述：可能有家族实现这么多次首次到访，也可能都更少；增益与新的确切比例没有给出（记录的下一步）。
3. **前提的位置。** 第一律、家族不重复、整体列出每个条件、其余不给净量、所要求者固定，都写在各自的定理中；`Flow.counting_given_by_rest` 表明“其余不给净量”不能从有限整体回返的定理中去掉。
4. **名称。** `NetGiver`、`RequiresWithin`、`FirstSupported`、`NewAt` 是结构性的名字；“增益”指存量的上升，与 P115 的“耦合强度”（系统论中增量增益的意义）分开命名。
5. **证明。** 给者经 `search` 在参与者的有限列表上找到，不判定无穷者；不用 `simp`、`omega`；公理报告为空。

**检查。** 暂存区构建（合并 main a5406334 后的树）：`Becoming.Gain` 30 项定理、35 项声明，公理报告为空，无警告；根模块与其闭包一同编译。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 149. 语境中的读法何时粘合：奇偶律、Bell 型之界与环（Becoming.Gluing；P112）

2026-10-15／16，同一交托之下。contextual-registration（§96，P72）的下一步写着“奇偶障碍的一般定理；概率的语境性”。§96 证明了框架恰在其诸识粘合处合于一个世界，并以 Specker 的三个盒子与 Mermin–Peres 方阵为没有不依语境之读法的可能性。本节给出每个语境要求奇偶时的确切规律，除所列主张与语境外不加前提。工作板上的 I4b 一行把外围 CorrectionRelations 的环律留给 P112，这里以核心的形式给出。

```text
Result(s): 新增 gluing-under-parity；复用 contextual-registration（Contextual、Contextual.Glues、Contextual.Respects、Contextual.not_glues、
           Local、NoGlobal，Specker 与 Square 的可能性、world 与 respects）；more-needs-renewers（total_le、total_add、total_ones、count、
           Distinct、search、mem_cons_cases、mem_map_of；求和 total 本身在 Becoming.Generation 中）
Delta: 新核心模块 Becoming.Gluing（导入 Context 与 Population；81 项定理／113 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；主张与语境被列出；障碍、m − 1 之界与环律不用其他条件；唯一性（消去）以主张的相等可判定、
       主张列举不重复为条件；混合是可重复计入的赋值列表，以自然数计权重
Evidence: scratch_build 对合并 main a5406334 后的树：Becoming.Gluing 81 项定理、113 项声明，公理报告为空，无警告；环的一节先单独编译；
          可判定性清单（暂存运行，只跳过回执核对）把四项消去定理归为“分辨相同”
Boundary: 量子值（Tsirelson 之界需要实数振幅）不陈述；超出奇偶约束的语境性没有确切规律；实际展开的哪些识是这种奇偶的，是对应；外围
          CorrectionRelations 的环律与这里的对应定理没有写出；不含伦理谓词
Integration: 理论第 6 节（第一部分的总陈述）、第 8 节（D33 的读法，描述一类的进一步证明）、第 9 节一行、术语；Becoming.lean；
          check_becoming.py；Lean README；新记录；contextual-registration 的下一步与 related，unity-of-readings、
          separation-loses-the-relation 的 related
```

| 声明 | 内容 |
|---|---|
| `addParity`、`oddOver` 与其律（`addParity_*`、`oddOver_add`、`oddOver_and`、`oddOver_congr`、`oddOver_false`、`oddOver_swap`、`oddOver_map`） | 两个值上的加法，一个量在列表上的奇偶；两个列表上的奇偶可交换次序 |
| `ParityConstraint`、`ParityConstraint.value`、`add`、`value_add`、`Contradicts`、`value_even`、`unmet_odd` | 奇偶约束：所计的主张与所要求的奇偶；约束相加仍是约束；一组约束相加后不计任何所列主张而要求奇，就矛盾；矛盾时每个赋值不满足其中奇数个 |
| `ParityConstraint.eliminate`、`counts_after`、`eliminate_counts`、`met_after`、`pulled`、`pull_back`、`met_or_contradicts` | **消去：二者恰有其一。** 主张的相等可判定、列举不重复时，逐一消去所列主张，如在两个值上解线性方程：或有赋值满足每个约束，或其中一组矛盾；消去之后找到的矛盾带回它所来自的约束 |
| `ParitySystem`、`constraint`、`within`、`value`、`support`、`met`、`Contradicts`、`local_`、`contradicts_iff` | 奇偶系统：每个语境所计的主张与所要求的奇偶；可能性是局部的，语境能显示的只取决于它所识的主张；矛盾是语境的一个选择（可重复） |
| `ParitySystem.unmet_odd`、`unmet_of_contradicts`、`contradicts_noGlobal` | **障碍。** 每个不依语境的赋值不满足矛盾中奇数个语境，逐个核对即找到一个，所以没有不依语境的读法 |
| `ParitySystem.met_le`、`mixture_le`、`indexed_met` | **Bell 型之界。** 不依语境的赋值至多满足矛盾 m 个语境中的 m − 1 个，其混合平均亦然；每个语境单独可满足时，按语境索引的读法满足全部 m 个 |
| `ParitySystem.lift_selection`、`global_or_contradicts`、`noGlobal_iff`、`glues_iff` | **唯一的障碍。** 对每个语境列表，或有不依语境的赋值满足其中每一个，或某个选择矛盾；语境被列出时，没有不依语境的读法恰当有选择矛盾，有尊重可能性的世界粘合恰当没有 |
| `Specker.openings_contradict`、`Specker.mixture_le`、`Specker.indexed_met`、`Specker.noGlobal_of_contradiction` 等 | Specker 的三个盒子：三次打开矛盾，混合平均至多三中之二；§96 的 `Specker.noGlobal` 由矛盾推出 |
| `CHSH.pairs_contradict`、`CHSH.mixture_le`、`CHSH.inPair`、`CHSH.indexed_met` 等 | CHSH 博弈：四对设置矛盾，不依语境之结果的混合平均至多赢四中之三（经典之界），在语境中读出的结果赢全部四个 |
| `Square.cells_even`、`Square.lines_contradict`、`Square.mixture_le`、`Square.inLine`、`Square.indexed_met`、`Square.noGlobal_of_contradiction` 等 | Mermin–Peres 方阵：六条线矛盾，至多六中之五，在线中读出的值满足全部六条；§96 的 `Square.noGlobal` 由矛盾推出 |
| `Cycle.system`、`Cycle.edges`、`Cycle.polarity`、`Cycle.telescope`、`Cycle.counts_even`、`Cycle.contradicts`、`Cycle.mixture_le` | **环。** 主张 0, …, n 成环，相邻者以相等或相异相关；沿其关系每个主张被计两次（相邻关系的计数逐项相消，`telescope`）；相异关系为奇数个时这些关系矛盾，混合平均至多满足 n + 1 个中的 n 个 |
| `Cycle.walk`、`Cycle.walk_meets`、`Cycle.met_iff_even`、`Cycle.pick`、`Cycle.miss`、`Cycle.value_pair` | **环的奇偶律。** 相异关系为偶数个时，从主张 0 沿环走出的赋值满足每个关系；所以不依语境的赋值满足全部关系，恰当相异关系为偶数个 |
| `true_of_ne_false`、`cond_le_one`、`and_congr_of`、`image_of_mem_map`、`count_le_length`、`count_all`、`met_step`、`even_le_of_odd`；`Cycle.down`、`Cycle.length_edges`、`Cycle.lt_of_mem_down`、`Cycle.shift`、`Cycle.cross`、`Cycle.returns`、`Cycle.eq_of_even`、`Cycle.beq_self`、`Cycle.beq_of_ne` | 两个值、列表与自然数的辅助；环的辅助 |

**它回答了什么。** 奇偶障碍的一般定理：每个语境要求奇偶时，不依语境的读法恰在没有矛盾处存在，而矛盾是一个可检查的证书，即一组语境，每个主张被计偶数次，所要求的奇偶相加为奇。这是两个值上线性方程组的择一：方程组无解，恰当某些方程相加得出 0 = 1。概率的语境性在奇偶的情形得到它的第一个确切形式：不依语境之读法的任何混合平均至多满足 m 个语境中的 m − 1 个，而按语境索引的读法满足全部 m 个；CHSH 的四中之三就是经典之界。环把 CorrectionRelations 的“相等与相异关系之环有联合赋值，恰当为偶”放进核心：奇的环是矛盾的最小形式，Specker 的三个盒子换名后就是三个相异关系的环。

**读法（AI 的，依 Ren 2026-10-15 的交托采用，D33）。** m − 1 与 m 之差，是语境所承载的；值是语境中的识，一个关系，不是主张不依语境所有的性质；坚持不依语境的值，其代价恰是这一障碍与这一界。

**作者反审。**
1. **已知的结果。** 奇偶的 Kochen–Specker 证明（Mermin 1990，Peres 1990）、CHSH 不等式（1969）与 Abramsky、Hardy 的逻辑 Bell 不等式（2012：不能同时满足的 N 个命题，其概率之和至多 N − 1）是这里的实例或同一形式；“唯一的障碍”是两个值上线性方程组的择一；Abramsky、Mansfield 与 Soares Barbosa 以两个值上的线性方程刻画的 all-versus-nothing 论证也属这一类。增量是：在核心中不用公理地陈述，障碍恰好（充要），混合以自然数计权重，§96 的 `Specker.noGlobal` 与 `Square.noGlobal` 由证书推出，外围的环律以核心的形式给出。
2. **条件。** 唯一性需要主张的相等可判定、列举不重复，这在 Ren 2026-10-11 保留的表示决定之内（判定的相等与列出）；障碍与界不用它；环律也不用它（相等由 `Nat.beq` 计算）。
3. **概率。** 混合是可重复计入的赋值列表，权重为自然数（有理的权重经伸缩等价）；实数的权重与量子值（CHSH 的 Tsirelson 之界，胜率 cos²(π/8) ≈ 0.854）需要实数振幅，不在核心中；`Becoming.Quantum` 以整数矩阵实现方阵（P72q）。
4. **对应没有写出。** 外围的 `CorrectionRelations.cycle_compatible_iff_even`（以 Mathlib 证明，对关系的列表）与这里的 `Cycle.met_iff_even` 是同一规律，两者之间的对应定理没有写出；那是把外围接入的一步，记在记录的下一步。
5. **名称。** `ParitySystem`、`ParityConstraint`、`Contradicts`、`unmet_odd`、`met_le`、`mixture_le`、`indexed_met`、`glues_iff`、`Cycle`、`walk` 都是结构或数学的名字。
6. **证明。** 不用 `simp`、`omega`；两个值上的恒等式以 `decide` 证明；消去用相等的判定（`if c = x`），它作为定理的条件写出；公理报告为空。

**检查。** 暂存区构建（合并 main a5406334 后的树）：`Becoming.Gluing` 81 项定理、113 项声明，公理报告为空，无警告；环的一节先单独编译。可判定性清单的暂存运行（只跳过回执核对）：只在证明中用到可判定性的定理由 224 项增至 228 项，即 `ParityConstraint.met_or_contradicts`、`ParitySystem.global_or_contradicts`、`ParitySystem.noGlobal_iff`、`ParitySystem.glues_iff`，归为“分辨相同”（消去按一个主张是否就是被消去者分情形）；证明可判定的定义与实例由 136 项增至 137 项（`support` 的可判定实例）。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 150. 分开与计数的开放证明（P119）

2026-10-16。Ren 问 P117 报告中“Nothing else is pending … the finite-name reading”是什么意思，AI 解释后，Ren 说：“take 2, and do the open proofs”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-finite-name-and-open-proofs.md)）。“take 2”取第二种：有限名的定理是“有界时类有有限的名”，名可名是类比；这一条由 P110 记入（DELEGATED-CHOICES D34、§8 与它的研究节），本节不重复。“do the open proofs”所指的是 §140 与 §144 留下的证明：分开的反方向与只在某步之前分开时的静止之步；指数的集中；多于两个值；对每个过程按历程计数；非自然数的权重。工作板上认领为 P119。本节在第一部分之内、除了各律所写者不加公理与前提，把它们全部证完。

```text
Result(s): 扩展 identification-where-runs-part、typicality-by-counting 与 weights-count-situations（各加规律）；
           复用 identification-where-bounded（statesBelow_iff_lasso、leastBound_exact、below_all、record_eq_iff）、
           recurrence-without-premise（revisits_within、gap_of_le）、learning-by-refutation（record、record_length）、
           sum-over-histories-exact（counting、signed、Weights.along、Weights.sum_courses、Weights.sum_joinMap、
           Weights.mul_sum、Weights.sum_map、openSteps、courses、add_mul_split、mul_assoc_nat）、
           losses-of-the-sum-over-histories（Interference.weight、Interference.cancels）、
           lifting-where-branching-is-finite（Lasting.Continues、Lasting.Unbounded）
Delta: Becoming.Parting 18 → 43 项定理（27 → 62 项声明），并导入 Becoming.Lasting；Becoming.Typicality 32 → 43（44 → 56）；
       Becoming.Situations 13 → 38（19 → 54）；只加定理与定义，原有声明不变
Supplied premises / correspondence: 不加公理。各律所写者：late_* 要运行从 T 起不分开、所识的值可判定、运行被列表所持；
       world_right、world_right_iff、some_right_iff 要动作与配置列出、步与所识的值可判定；concentrated 要 v ≤ u；
       situations_take 要动作与配置的相等可判定，situations_of_course_listed 还要每个只列一次；
       sum_finer_weights 要每步之权重是其情境之和
Evidence: scratch_build 对 main d84868b7（I4b-4 之后）：三个模块与根模块
          编译，无错误或警告，公理报告全部为空；判定性清单的暂存运行 0 项未用，见下“检查”；合并检查器回执待整合者的运行
Boundary: 实数或复数振幅、无限和不在内；哪个情境发生不被推出；被给予世界的学习者要世界有限且可判定，无界或不可判定的
          过程不在内；指数集中只对至少 k 个一陈述（至少 k 个零由交换 p 与 q 得到，没有另写）；不含伦理谓词
Integration: 第 6 节新段落对（在“权重计数情境”之后），该段一句改写；§8 两个状态行、路径分支时的开放项；理论的完整陈述两条；
       界一项；§9 三行；术语表一行；Becoming.lean 三条模块说明；check_becoming.py 三段范围；Lean README 三行；
       DECIDABILITY-INVENTORY.py 的分类（新类“可达”）；三项记录的规律、next_delta 与 does_not_show；
       identification-where-bounded 只改 next_delta 中“按情境”一项
```

| 声明 | 内容 |
|---|---|
| `Parting.unparted_at_of_late` | **只在 T 之前分开，T 处不分开。** 所识的值可判定时，从 s 出发的运行在 T 起都不分开，则从一个运行在 T 所在处出发没有两个运行分开（把两个运行接在 T，`joinAt`） |
| `Parting.statesBelow_shift`、`late_statesBelow`、`late_right` | **只在 T 之前分开时的静止之步。** 从 T 起至多 N 个状态的历程至多有 T + N 个；被 N 个配置所持的运行其历程至多 T + N 个状态，以最小的界读记录的学习者从 2(T + N) − 1 起每步都对 |
| `Parting.anyOf`、`keepIf`、`choose` 及其规律 | 布尔的“有一个”、按检验保留、在存在时找出一个：只用前奏 |
| `Parting.path_of_continues`、`continues_cycle`、`continues_persists`、`continues_any`、`unbounded_of_continues` | **与配置数一样长的历程可以继续。** N 个配置的列表持有每个配置时，由之有 N 步历程（`Lasting.Continues`）的配置，一步之后仍然如此：长 N 的历程重复一个配置（`revisits_within`），绕着重复可以走任意长；所以它是 `Lasting.Unbounded` 的，不用判定也不用选取。`Lasting` 中有限分支的提升只到双重否定为止；配置有限时这里直接成立 |
| `Parting.live`、`live_succ_iff`、`live_of_run`、`live_iff_continues`、`live_persists` | `live` 是判定了的 `Lasting.Continues`（动作与配置列出、步可判定） |
| `Parting.advance`、`advanced`、`liveRun` | 由此造出从这样的配置出发的运行（每步取第一个仍可走 N 步的后继） |
| `Parting.candidates`、`firstLive`、`worldLearner`、`run_in_candidates`、`candidates_run` | **被给予世界的学习者。** 从记录读出运行可能所在的配置：每个运行都在其中；其中每个配置都是某个有此记录的运行在该步所在之处 |
| `Parting.world_right`、`world_right_iff`、`some_right_iff` | **反方向。** 被给予世界的学习者在某步于从 s 出发的每个运行上都对，恰当没有两个这样的运行在该步分开；某个学习者在那里对，恰当没有运行在那里分开 |
| `Typicality.pow_add_nat`、`ones_add_zeros`、`weight_pow`、`mul_mul_mul`、`weight_mul` | 幂的加法（不经命题外延性）；权重逐步相乘 |
| `Typicality.tilt_le`、`atLeast`、`atLeast_le`、`total_le_mem`、`total_congr_mem`、`concentrated` | **集中是指数的。** 对每个 u ≥ v，至少 k 个一的历程之重乘 uᵏ·vⁿ 至多 (p·u + q·v)ⁿ·vᵏ（计数形式的 Chernoff 界） |
| `Typicality.few_far_ahead` | p = q = 1、u = 3、v = 1：至少 k 个一的历程之数乘 3ᵏ 至多 4ⁿ |
| `Situations.keep`、`drop`、`inside`、`outside`、`keep_drop`、`sum_split`、`inside_add_outside`、`valueWeight`、`seen` | 一个事件之重与其余之重；值上的读数按事件分成两份 |
| `Situations.sum_event` | **任意多个值经一个事件读作两个值。** 历程上按权重计的任一读数之和，等于 Typicality 的历程上以事件之重与其余之重计的和 |
| `Situations.event_typical`、`event_concentrated`、`event_count` | 对每个事件，大数定律与指数集中计数情境；细历程共 (P + Q)ⁿ 个 |
| `Situations.occ`、`sum_only`、`situations_take`、`occ_map_cons`、`occ_map_pair`、`occ_openSteps`、`occ_courses`、`occ_courses_once`、`situations_of_course_listed` | **对每个过程按历程计数。** 走一个历程的细历程之数是其权重乘它被列出的次数；每个动作与配置只列一次时就是其权重 |
| `Situations.signs`、`sum_mul_right`、`sum_finer_weights` | **任何权重中，步之权重是其情境之和时由情境计数**（`sum_finer` 推广到每个 `Weights`） |
| `Situations.sign`、`both`、`sum_adding`、`sum_signed`、`signed_sums`、`signed_situations`、`signs_unit`、`sum_units`、`signed_counts` | **带符号的权重是两类情境之数之对。** 一步 (P, N) 是 P 个加的与 N 个减的情境；每个细历程合成为加或为减；带符号的转移是这两类之数 |
| `Situations.cancels_situations` | `Interference.cancels` 的平衡 (1, 1) 是两个情境 |

**它回答了什么。**
1. **分开恰是记录与世界都不固定之处。** §140 只有一个方向：分开之处没有学习者两者都对。现在两个方向都有：对列出、可判定的过程，被给予世界的学习者在某步于每个运行上都对，恰当没有两个运行在该步分开（`world_right_iff`）。所以“分开”不是表示的缺陷，而正是这样一个界：知道世界也越不过它，不分开处知道世界就够了。按 Ren 2026-10-16 已取的读法，分开处记录与律不固定的由情境固定，这里证明它们在其余处都固定。
2. **只在某步之前分开。** 辨识一线的静止之步 2N − 1 推广为 2(T + N) − 1：分开只在前 T 步时，历程最多多 T 个状态。
3. **指数的集中。** §140 的切比雪夫形式随 1/n 下降；这里是 Chernoff 形式，指数下降，仍只用自然数（u、v 是自然数，比 u/v 起 eᵗ 的作用）。
4. **多于两个值。** 不另起一套多值的历程：每个事件把值分成两类，`sum_event` 把多值的历程之和归到 Typicality 的两值历程，所以两值的一切结果对每个事件成立，每个值的频率亦然。
5. **对每个过程按历程计数。** §144 只对两个值；这里对每个过程，列出无重复时一个历程的权重就是走它的情境之数，有重复时乘重复的次数（这是表示的计数，不是世界的）。
6. **非自然数的权重。** 带符号的权重（`signed`）是情境之数之对：加的与减的。相消是两类之数相等，不是情境不在；`Interference.cancels` 的两条历程是两个情境。这把“带符号的权重不是情境之数”精确化：它不是一个数，是两个数。实数与复数振幅不在内：它们不是有限多个单位之和。

**作者反审。**
1. **已知的结果。** 反方向是可区分性的标准论证（集合论地：一个信息状态里所有可能世界给出同一个值时，知道就够了）；Chernoff 界、多项分布按事件约化为二项分布、以计数读概率、以带符号的计数读相消（例如 Feynman 对路径之和的带符号计数）都是已知的。增量是：在核心中不用公理，接到 `Becoming.Parting` 与 `Becoming.Weighted`，给出有限过程上被给予世界的学习者的显式构造（只用前奏，可计算）。
2. **强度与范围。** 被给予世界的学习者要过程有限且可判定。对无限的过程，“某个运行由此可走下去”一般不可判定，构造不成立；这里没有陈述那一侧的界。`late_right` 给出 2(T + N) − 1，没有证明它对每个 T 恰好。指数集中只写了“至少 k 个一”；“至少 k 个零”交换 p、q 即得，没有另写。`few_far_ahead` 是一个实例，不是最优常数。
3. **名字。** 由之可走 N 步的配置叫 `live`，意为可走下去，不涉及生命；`worldLearner`、`candidates`、`occ`、`signs` 都是结构性的名字。“情境”沿用 §144。
4. **证明。** 不用 `simp`、`omega`；幂的加法用自写的 `pow_add_nat`，因为前奏的 `Nat.pow_add` 用到 `propext`（暂存探测）；`Nat.pow_le_pow_left`、`Nat.mul_le_mul_left`、`Nat.mul_le_mul_right` 不引入公理。被给予世界的学习者以 `choose`（从存在的证明在列表中找出一个，可计算）造出，不用 `Classical`。
5. **判定性清单。** 新的取判定性的定义 `Parting.candidates`、`live`、`firstLive`、`worldLearner` 分为新类“可达”（判定步是否可走并分辨所识的值），`Situations.occ` 为“分辨相同”；只在证明中用到判定性的 `Parting.unparted_at_of_late`、`late_statesBelow` 为“分辨相同”，`some_right_iff` 为“可达”。

**检查。** 在暂存区编译：`Becoming.Parting` 43 项定理、62 项声明，`Becoming.Typicality` 43／56，`Becoming.Situations` 38／54，根模块 `Becoming` 连同其闭包编译（没有名字冲突）；没有错误或警告，公理报告为空；没有 `sorry`、`axiom`、`Classical` 或 `native_decide`。判定性清单的暂存运行（只跳过回执检查）0 项未用。核心检查器在整合者的运行中检查。本节尚未经独立审查。

## 151. 只读记录的选择（整合 I4b 第二项）：PluralRecords 与 TieBreaking 接入

（同日后记：依 Ren 的更正，本节结果改称“经选项模型的选择”，读法撤回，见第153节；以下文字作为证据保留。）

2026-10-16。Ren 对 I4 归类表选择“Closest gaps first”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-i4-decisions.md)）。表把 PluralRecords 与 TieBreaking 读作待接入的律：同等对待各中心的规则（交换两个中心的条目即交换其输出）能供给中心 k，恰当没有别的中心的条目等于 k 的（`servable_iff_untied`）；同等对待的抽签给并列的中心相同的权重（`tied_equal_weight`）。Becoming.Selection 陈述了经识的选择恰及所识（`Web.selects_alike_iff`），未陈述只读记录的选择（§139）。本节对任何选项与任何种类的条目陈述它。名依 Ren 同日的接入命名规则（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-joined-module-names.md)，工作板规则 8）：核心律、实例模块与记录标题都用核心的结构词汇，实例模块按核心律命名。

```text
Result(s): 新记录 selection-by-the-record-alone；selection-through-registration、generalization-through-lumping、wisdom-root-part-one 改绑（论断不变）
Delta: 核心：Becoming.Selection 加“只读记录的选择”一节（命名空间 Relabel，43 → 67 项定理），不加导入；
       外围实例模块及其检查器：SelectionRelabelCorrespondence（13 项定理），在 remaining-dependency 包旁；检查器也编译并审计未有回执的 PluralRecords 与 TieBreaking；
       可判定性清点：Relabel 的四项定义归入“交换两个值”，陈述依赖它者 387 → 409（22 条律写出选项的相同已定），只在证明中用到 233 → 234（Relabel.alone_single，分辨两个选项是否相同）
Supplied premises / correspondence: 核心律不加前提：选项的相同已定（交换两个选项需要它，每条陈述都写出），条目任意种类；选择、取值或选取只读记录是所用定理的假设；实例沿用 PluralRecords 与 TieBreaking 的定义
Evidence: 核心由核心运行审计（回执 20261015T193630.814921Z）；外围检查器实跑（回执 20261015T193732.676982Z），72 项声明审计公理报告皆空
Boundary: 见下文“边界与读法”
Integration: §9 Selection 一行（改为双语，陈述与计数）与一个外围行；Becoming.lean 的模块条目；Selection 的文件说明；remaining-dependency 的 FORMAL-NOTES；一项新记录；三项记录改绑；一个外围检查器；可判定性清点；归类表中 PluralRecords、TieBreaking 改为已接入，主题“对称与并列”随之取消
```

**只读记录（不加前提）。** 选项只由记录对每个所持的条目分开。交换两个选项（`Relabel.swap`）是对合。一个选择只读记录（`Relabel.Equivariant`），当交换两个选项的条目即交换所选者；取值（`EquivariantValue`）与至多一个的选取（`EquivariantChoice`）同样。交换两个并列的选项，记录不变（`fixed_of_tied`）。

**只读记录的选择恰分开记录所分开者。** 并列的选项被选得相同（`Equivariant.tied`）；两个选项被每个只读记录的选择选得相同，恰当记录使二者并列（`selected_alike_iff`），见证是选出条目等于给定值的选项。这与经识的选择恰及所识（`Web.selects_alike_iff`）同形。

**单独选出。** 至多选一个的只读记录的选择不选并列的选项（`Equivariant.untied`），两个以上选项全并列时不选（`Equivariant.none_of_full_tie`）。单独持有一个条目（`Alone`）是只读记录且至多一个的选择（`alone_equivariant`、`alone_single`），所以一个选项能被单独选出，恰当没有别的选项的条目与它相同（`singled_iff_untied`）。两个方向都作为关系陈述，不需搜索。

**取值与选取。** 只读记录的取值（如每个选项的权重）给并列的选项相同的值，全并列时处处相同（`EquivariantValue.tied`、`full_tie`）；取某值的选项是只读记录的选择（`level`）；常值只读记录（`const`）；两个选项被每个这样的取值取得相同，恰当二者并列（`valued_alike_iff`）。只读记录的选取，其所选取者是只读记录的选择（`EquivariantChoice.selects`），所以它不选取并列的选项，全并列时不选取（`untied`、`withholds_of_full_tie`）。

**PluralRecords 与 TieBreaking（SelectionRelabelCorrespondence，外围，自有检查器）。** 记录即 `Fin n` 上的条目记录，交换两个中心即 `Relabel.swap`（`transpose_eq_swap`），同等对待中心的规则即只读记录的选取（`treatsAlike_iff`），同等对待的抽签其权重只读记录、不保留的权重不变（`lotteryAlike_iff`），单独持有即 `Relabel.Alone`（`alone_iff`）。核心律给出 `tied_not_served`、`all_tied_forces_withholding`、`servable_iff_untied`、`tied_equal_weight`、`full_tie_equal_weights`、`uniform_alike` 与 `point_mass_not_alike_at_tie`（各为 `_by_core`）；`servable_iff_untied` 的反方向由核心给出单独持有的不变性与唯一性，`PluralRecords.pick` 在 `Fin n` 中找出持有者。13 项定理的公理报告皆空。原文件的定义与陈述不变。

**检查器。** `make_relabel_checker.py` 由 `../integration-i3e/make_checker.py relabel.json` 生成 `check_selection_relabel_correspondence.py`，并作四处改动：Lean 根目录；把两个原文件与实例加入模块索引；原文件在此检查（它们只导入 Lean 的前导，无机器回执，构建记录是 `inquiry-warrant/BUILD.md`），其每项声明与实例一起审计，报告须皆空；原文件的名含 `?` 与 `'`，故以容许这些字符的扫描读出，审计行按行首读，使带撇号的名完整。TieBreaking 打印一条警告（`full_tie_open_uniform` 未用的假设 `noWithhold`，按原陈述保留），它是唯一允许的输出，回执记下。干跑（回执写到临时目录）在 Lean 4.30.0-rc2 下通过：13 项定理，72 项声明审计皆空；缺回执的只有新的 Becoming.Selection，待其核心运行。

**作者反审。**
1. **新律还是重述？** 对脊柱是新的：Selection 只有经识的形式。核心的陈述比原文件更一般：选项任意（相同已定），条目任意种类，且以关系陈述，不需在列出的选项中搜索；原文件的反方向用 `pick` 在 `Fin n` 中搜索，这一步留在外围。
2. **相同已定。** 交换两个选项要分辨输入是否为其中之一，所以 `DecidableEq` 是每条陈述的条件（清点中归入“交换两个值”，与 Learning 的 `swapTo` 同）。没有它，`swap` 无从定义；对任意置换而非对换陈述可去掉定义上的需要，但“并列即选得相同”仍需对换存在。
3. **命名。** 依工作板规则 8，原文件的 `TreatsAlike`、`LotteryAlike`、`servable` 不带入核心；核心用 `Relabel`、`Equivariant`、`Alone`、`singled_iff_untied`，实例模块按核心律命名为 SelectionRelabelCorrespondence。`_by_core` 定理沿用原定理的名，以指明所重述者。
4. **没有证明的。** 选出的选项由选取函数找到（需搜索）；两两关系之记录（条目是选项之间的关系）上的同一律。

**边界与读法。** 核心律说的是只读记录的选择能分开什么，不说哪种选择应当被用：平局中等概率的抽签是否正当、按条目大小或按轮次的优先，保持原文件的范围（[TIE-BREAKING-LEGITIMACY](../history/root-foundation/TIE-BREAKING-LEGITIMACY.md)）。读法（AI 的，待 Ren）：哪个选项是哪个不在记录的关系之中；要分开记录所并列者，需另一被记录的关系，如到达的次序或约定，正如经识选择的缺口只经关系而合。

**下一步（I4b）。** I4b 的四项至此齐备（Gated、Selection、Horizon、Lasting）；IdealWarrant 留待 Ren 安置，接入时依规则 8 改名。

## 152. 所携带的差别怎样增长：上游没有回路处有限阶精确、增长至多是多项式，回路使之失控（Becoming.Loops）

2026-10-16。P115 的记录 [how-much-difference-arrives](../../../../theories/becoming/results/records/how-much-difference-arrives.md) 的 next_delta 首项是“回路的一般理论（绕回路的强度与失控）”，`Becoming.Propagation` 把“回路的一般理论，绕每个回路的强度与其失控，见证之外”列为没有导出；[comparison-where-the-rest-responds](../../../../theories/becoming/results/records/comparison-where-the-rest-responds.md) 要求“回路的一般定义，以及在其中陈述绕回路的强度与失控”，[runaway-distance-unregistered](../../../../theories/becoming/results/records/runaway-distance-uncoupled.md)（P55）要求“一般地定义回路……并把失控本身陈述为定理”；理论第 8 节的进一步证明在“反馈与所及”下列“回路的一般理论”。Ren 2026-10-12 把理论比作量子动力学与“Fermi's diagrams”，说：“there are so many patterns and loops but we can still find a way to to integrate so we can still calculate this effects but how how accurate can we do that uh what is the limitation do we have losses”，目标是“move towards 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）；2026-10-16 又说“continue”。本节在第一部分之内回答：不加公理，除各定理所写的强度不加前提。工作板上认领为 P118。

```text
Result(s): 新增 how-a-carried-difference-grows；回答 how-much-difference-arrives 的 next_delta 首项“回路的一般理论”，
           以及 comparison-where-the-rest-responds 与 runaway-distance-unregistered 的 next_delta 中“一般地定义回路并陈述
           失控”（在其余遵从具有给定耦合强度之律处）；复用 how-much-difference-arrives（carried、carriedGive、carried_succ、
           carried_le_succ、gap_le_carried、most_difference_arrives、gap、Flow.exchangeGap、ExchangeLaw.RespondsWithin）；
           recurrence-without-premise（revisits_within、gap_of_le、gap_of_lt）；Flow、Web、Balances 与 Follows
Delta: 新核心模块 Becoming.Loops（导入 Propagation；113 项定理／137 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各定理所写者写在定理中：耦合强度 k（给出的界）；条件全部列出（every）；
       界的定理中部分在起始之后不给差、起始之差至多 D、每步进入每个条件的强度至多 M；失控的定理中耦合每步成立
       （CouplesAlways、CoupledWith）或形成与强度每步相同（stationary）；对一切律的定理中条件不重复（Distinct）与条件的
       相等可判定（经 most_difference_arrives、gap_le_carried，只在证明中）
Evidence: scratch_build 对 main 5f8f7726（I4b-2 之后）：Becoming.Loops 113 项定理、137 项声明，公理报告全部为空，无警告；
          根模块 Becoming 与其导入闭包（118 个模块）一同编译，无重名；清点在同一字节上运行，三条新行已分类；
          合并检查器回执待整合者的运行
Boundary: 离散的步、自然数的量；强度是给出的界；条件全部列出；当且仅当只对形成与强度每步相同者陈述；时有时无的耦合、
          比强度之积更细的失控速度开放；不含伦理谓词
Integration: §2 新增一段（所携带的差别怎样增长），差别到达多少一段中的“不推出”；第一部分的总陈述一条；§8 的状态行与
       进一步证明各改一项；§9 新增一行；术语表新增两行；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列与
       范围说明；Lean README 一行与层内导入；DECIDABILITY-INVENTORY.py 的分类；一项新记录与三项配对说明
```

**一、按阶展开。** 所携带的量（`carried`）每步增加部分之差与强度对至今所携带者所作的。把“至今所携带者”换成任意给定的水平 `l`，得到一步所携带的（`carriedFrom`）；所携带的量是它自身的不动点（`carriedFrom_carried`）。j 阶（`carriedWithin`）从安静的水平（零）起，把这一步作用 j + 1 次：0 阶只携带起始之差与部分之差，每多一阶，路线上多一次回应。各阶随 j 上升（`carriedWithin_mono`），每一阶都不超过所携带的量（`carriedWithin_le_carried`）；到第 t 步的路线至多有 t 次回应，所以 j 阶到第 j 步为止恰是所携带的量（`carriedWithin_exact`），所携带的量是各阶的极限（`carried_eq_carriedWithin`）。

**二、耦合、链、回路与上游。** 条件 `d` 的水平耦合到 `c`（`Couples`），是说在某步 `t` 一个在场、在部分之外的形成，以正强度在 `d` 至该步的某个水平上与 `c` 交换。耦合的链（`Coupled v j`）沿 `v` 前 j 个条件各耦合到下一个；j 个耦合的链终于 `c`（`CoupledInto`）；回路（`OnLoop e`）是一个或多个耦合的、从 `e` 回到 `e` 的链；`e` 在 `c` 的上游（`Upstream e c`），是说有链从 `e` 通到 `c`。

**三、上游没有回路处，有限阶精确。** 没有 j + 1 个耦合的链终于 `c` 处，j 阶在 `c` 处每步都精确（`carriedWithin_exact_of_not_coupledInto`）：证明对 j 归纳，j 阶与所携带的量在每个正强度所读的水平上一致。条件全部列出时，与列表一样长的链两次经过同一个条件（`Recurrence.revisits_within`，鸽笼），那个条件在一个回路上，且在链的终点的上游（`loop_of_coupledInto`）。所以 `c` 的上游没有回路、`n + 1` 不少于条件数时，n 阶在 `c` 处每步精确（`carriedWithin_exact_of_no_loop`）：有限的展开没有损失。

**四、上游有回路处，每一阶都漏掉一些。** 耦合每步都成立（`CouplesAlways`：每步都有一个在场、在部分之外的形成以正强度在当前水平上耦合）时，一个阶在某步、某条件处漏掉一些，下一个阶就在下一步、在它耦合到的条件处漏掉一些（`orderBelow_lt_succ`）：沿每步成立的链，所漏的阶每个耦合升高一（`orderBelow_lt_along`），绕回路每圈升高回路的长度（`orderBelow_lt_around`）。回路在某步有所携带时，0 阶之下（什么也不携带）在那里有所漏；所以有每步成立的链从回路通到 `c` 时，每一阶都在某步在 `c` 处漏掉一些（`carriedWithin_lt_of_loop`）。合起来：条件全部列出、每个耦合每步成立时，存在一个从每个起始之差都精确的有限阶，恰当 `c` 的上游没有回路（`finite_order_iff_no_loop`）。耦合须每步成立：一个形成只在第一步把一个条件的水平送回它自身时，这个条件在回路上、在它自身的上游，1 阶却从每个起始之差都每步精确（`Loops.Once.not_always`）。

**五、绕回路的强度与失控。** 链 `v` 的每个耦合在每步的强度至少是 `w i`（`CoupledWith`）时，到达链起点者乘以这些强度之积，经与链的耦合数一样多的步到达终点（`carried_along`）。回路有 m + 1 个耦合时，到达回路者每绕一圈至少乘以一加回路上强度之积（`carried_around`）：“一”来自水平持有所给的，强度之积来自绕回来的；绕 R 圈是这个因子的 R 次方（`carried_runaway`）。

**六、各阶携带多少；截断的精度。** 部分在起始之后不给差（σ = 0），起始之差至多 D，每步进入每个条件的强度（`inflow`：在场、部分之外的形成，在至该步的每个水平与每个列出的条件上的强度之和）合计至多 M。于是 j 阶至多是 `Loops.withinBound M D j t`（`carriedWithin_le_withinBound`），它等于 D 乘以对 i ≤ j 的和：在 t 步中安放 i 次回应的方式数 `Loops.binom t i` 乘 `M ^ i`（`Loops.withinBound_eq`，帕斯卡法则 `Loops.orderSum_step`），t 的 j 次多项式。所携带的量至多 `D * (1 + M) ^ t`（`carried_le_geomBound`、`Loops.geomBound_eq`），在 j 阶截断所漏的至多是 `Loops.missBound M D j t`（`carried_le_carriedWithin_add`），而 `missBound` 加 `withinBound` 恰是 `D * (1 + M) ^ t`（`Loops.missBound_add_withinBound`）：截断所漏至多是剩下的和。一个条件、一个形成，每步以强度 M 把该条件的当前水平送回它自身（自环，`Loops.SelfLoop.strengths`），恰好达到这三者（`Loops.SelfLoop.carried_eq`、`Loops.SelfLoop.carriedWithin_eq`、`Loops.SelfLoop.attained`）：由 D 与 M 推不出更小的界。

**七、上游没有回路处至多是多项式；形成与强度每步相同时恰在那里。** 上游没有回路、`n + 1` 不少于条件数时，所携带的量至多是 `D * Loops.orderSum M n t`，t 的 n 次多项式（`carried_le_polynomial`）。强度每步相同（`stationary K`：每个形成每步以同一强度 `K h c d` 在 `d` 的当前水平上与 `c` 交换），形成每步相同时，每个耦合每步成立（`couplesAlways_of_stationary`），所以有限阶精确恰在上游没有回路处（`finite_order_iff_no_loop_stationary`）；正强度是自然数，至少为一，所以回路每绕一圈至少使到达者加倍（`carried_doubles_around`），到达上游回路者如此加倍地到达 `c`（`carried_doubles_into`）。每个多项式都被 2 的幂超过（`Loops.poly_lt_two_pow`），所以加倍的量没有多项式界（`Loops.not_poly_of_doubling`）；有限阶之和至多是 `(n + 1) * (1 + M) ^ n * (t + 1) ^ n`（`Loops.orderSum_le_poly`）。合起来：所携带的量从每个起始之差都有多项式界，恰当 `c` 的上游没有回路（`polynomial_iff_no_loop`）。

**八、对一切律。** 由 `most_difference_arrives`（所携带的量是能到达的最大差别）与 `gap_le_carried`，以上都是关于一切具有这些强度的读已立者之律及其两个平衡的流的陈述。上游没有回路时，第 T 步 `c` 处之差对一切这样的律与流至多是 a，恰当 n 阶所携带的至多是 a（`most_difference_within`）；每个差至多是那个多项式（`gap_le_polynomial`）。形成与强度每步相同、条件各列一次时，对一切这样的律与流之差有一个多项式界（对每个起始之差的界），恰当 `c` 的上游没有回路（`gap_polynomial_iff_no_loop`）。

```lean
def carriedWithin (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (k : Nat → F → C → Nat → C → Nat) (present : Nat → List F) (δ : C → Nat) :
    Nat → Nat → C → Nat
  | 0 => carriedFrom cs part σ k present δ fun _ _ => 0
  | j + 1 => carriedFrom cs part σ k present δ (carriedWithin cs part σ k present δ j)

theorem carriedWithin_exact_of_no_loop (every : ∀ c, c ∈ cs) {c : C}
    (noLoop : ∀ e, Upstream cs part k present e c → ¬ OnLoop cs part k present e) {n : Nat}
    (long : cs.length ≤ n + 1) (t : Nat) :
    carriedWithin cs part σ k present δ n t c = carried cs part σ k present δ t c

theorem carried_runaway {v : Nat → C} {w : Nat → Nat} {m : Nat} {e : C} (start : v 0 = e)
    (back : v (m + 1) = e) (loop : CoupledWith cs part k present v w (m + 1)) (t : Nat) :
    ∀ R, (1 + Loops.product w (m + 1)) ^ R * carried cs part σ k present δ t e ≤
      carried cs part σ k present δ (t + (m + 1) * R) e

theorem carried_le_carriedWithin_add {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) :
    ∀ j t c, carried cs part (fun _ _ _ => 0) k present δ t c ≤
      carriedWithin cs part (fun _ _ _ => 0) k present δ j t c + Loops.missBound M D j t

theorem polynomial_iff_no_loop (every : ∀ c, c ∈ cs) (K : F → C → C → Nat) (hs : List F)
    (c : C) :
    (∀ δ : C → Nat, ∃ A n, ∀ t,
        carried cs part (fun _ _ _ => 0) (stationary K) (fun _ => hs) δ t c ≤ A * (t + 1) ^ n) ↔
      ∀ e, Upstream cs part (stationary K) (fun _ => hs) e c →
        ¬ OnLoop cs part (stationary K) (fun _ => hs) e
```

**读法（AI 的，待 Ren）。**
1. **积分、精度与损失。** Ren 问到像图那样的模式与回路能否积分、精度多少、界限在哪里、有没有损失。`Becoming.Weighted`（P82，§104）对历史之和以四种损失回答；这里对所携带的差别回答。各阶就是那种积分：如同按顶点数求图之和（AI 把“Fermi's diagrams”读作费曼图），每一阶加上多一次回应的路线，`Loops.binom t i` 数 i 次回应在 t 步中的时间次序。截断的精度是剩下的和，并且恰好达到：这是只由强度与起始之差所能有的极限。上游没有回路处，有限阶没有损失；有回路且耦合每步成立处，每个有限阶都有损失，到达回路者至少按几何级数增长。
2. **只有回路使差别失控。** 没有回路时，所持的差别不断到达，但至多按多项式增长，次数小于条件数（`Propagation.Chain` 是一次的）；有回路时至少按几何级数增长（`Propagation.Loop` 是强度为一的自环）。P115 的两个见证是这条一般规律的两端。
3. **一个世界有哪些回路，是其情境。** 强度是给出的，如在 `Becoming.Propagation` 中：这些陈述对每一组强度成立，哪一组成立由情境使之为真（Ren 2026-10-16：“the situation makes it true”，§144 中 Ren 已取的读法）。

**Ren 的决定（2026-10-16）。** Ren 决定了上面三条读法（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-loops-readings-and-delegated-choices.md)）。一、取 AI 的措辞：Ren 指的是费曼图，相合是结构上的，不是物理上的；Ren 所问的积分，对不确定的律，是 P82 的历史之和及其四种损失（`Becoming.Weighted`）；P118 的各阶是同一结构的另一种，按回应次数组织，如费曼图按顶点数组织；两者尚未连起来，连起来是进一步的证明。二、“只有回路使差别失控”是对的，附限定：失控是快于每个多项式；说的是能到达的最大差别，不是每个律所做的；只在某些步成立的耦合开放。一句话：能到达的最大差别快于每个多项式，只经由回路，且经由每个每步耦合的回路。三、取精炼的形式：一个世界有哪些回路是其情境的一部分；回路在展开之中形成与消散，定理按每步的样子取用它们。Ren 说“leave it pending until a loop-formation theorem exists”：这一读法暂取此形式，待有回路形成之定理时可修订（候选：一个形成的汲取开始回应其汲取所降低的水平，那里与 `Becoming.Runaway` 相遇）。记录、第 2 节的段落与模块说明已相应修改。

**作者反审。**
1. **新律还是重述？** 按阶展开是线性比较系统的 Picard 迭代（Neumann 级数、Dyson 级数的离散形式）；有向无环则邻接矩阵幂零，有限级数精确；`D * Σ C(t, i) M^i` 是 `(1 + M)^t` 的二项展开截断。这些在数学上是标准的。新的是：（a）它们在核心的交换律上陈述，不加前提，并经 `most_difference_arrives` 成为关于一切具有这些强度之律的陈述；（b）截断的界恰好达到（自环）；（c）形成与强度每步相同时的当且仅当：有多项式界恰在上游没有回路处，对一切律亦然。
2. **为什么是“一加”强度之积。** 水平持有所给的（积分器），所以绕一圈的因子是一加回路的强度之积。强度是自然数，正强度至少为一，所以每个耦合每步成立的回路至少加倍。实数的强度下，只要回路的强度之积为正，因子仍大于一，几何增长应当仍在；这里没有证明。
3. **耦合时有时无。** 当且仅当要求耦合每步成立；只在某些步成立的回路不必使每一阶都不精确（只在第一步耦合的回路，`Loops.Once.not_always`）。一般时变强度下的刻画开放。
4. **最坏情形，不是每个律。** 所携带的量是一切具有这些强度之律的上界，由携带之律达到：失控说的是能到达的最大差别。对一个具体的律，即使有回路，实际的差也可以有界（例如什么也不交换的律，其强度在任何界之下）；一个律自身的失控需要其回应的下界，这里没有陈述。
5. **与 `Becoming.Runaway`（P55）。** 那里的失控是保持支持的策略，断裂的距离不被识；这里是差别绕耦合的回路增长。两者相遇于一个形成的汲取回应其自身汲取所降低的水平之处：一个回路；这里没有把两者连起来。
6. **与 P82 的损失。** `Loop.courses_double` 数一个转移图中回路的历程（可能性）；这里耦合的回路乘以所携带的量。P82 的截断“恰好漏掉所弃者”，这里成为定量的界，并且达到。
7. **范围。** 不含伦理谓词；离散的步、自然数的量；条件全部列出。

## 153. 经选项模型的选择：第 151 节的重新框定（整合 I4b 第二项的后续）

2026-10-16。Ren 读了第 151 节的结果后写道：“selection's “record-only” doesn't seem right - it is about the cognitive model, not just record, which feels as long as we remember all pasts we can move forward without wisdom”；读过 AI 的考察与建议后写道：“go ahead with the reframing, first title, keep names, (a)”（[原话](../../../../sources/15-codex-theory-conversations/2026-10-16-selection-through-a-model.md)）。本节据此重新框定第 151 节的结果：不改任何 Lean 陈述，加一处与 `Becoming.Learning` 的归并的连接，撤回原读法。

```text
Result(s): selection-by-the-record-alone 改名为 selection-through-a-model-of-the-options（旧 ID 留作别名），
           标题“经选项模型的选择 / Selection through a model of the options”；selection-through-registration 与
           generalization-through-lumping 的关联随之更新；Selection.lean、Learning.lean 与外围实例所绑的记录改绑
Delta: 核心：Becoming.Selection 只改注释（节名、节说明与文件说明，注释之外的代码断言不变，67 项定理不变）；
       Becoming.Learning 加“经选项模型的选择”一节（75 → 83 项定理，8 项新定理），不加导入；
       外围：SelectionRelabelCorrespondence 只改注释，检查器按新说明重生成；读法：撤回“到达的次序”一读
Supplied premises / correspondence: 新定理不加前提：选项的相同已定（同 Relabel），所用的选择、取值经模型是假设；
       要紧者是给出的谓词 p 或函数 f；充分方向要求读出的 q 或 h 给出
Evidence: 草稿构建（main a2caf2fd 上，scratch_build.py）：Selection 67、Learning 83 项定理，公理报告皆空；
       根模块及其闭包编译；核心与外围回执待运行
Boundary: 见下文
Integration: 记录改名与改写；§9 Selection、Learning 两行，外围一行与实例列举；Becoming.lean 两条；Lean README 两行；
       FORMAL-NOTES；外围检查器说明；可判定性清点的注释；归类表三行，IdealWarrant 一行改正并移入一般数学主题
```

**为何重新框定。** 核心中“记录”指被保留的过去。第 151 节的标题“只读记录的选择”与读法“要分开记录所并列者，需另一被记录的关系，如到达的次序或约定”，暗示记得更多就够了。两个方向都不对：完全的记忆也分不开历史相同的选项；记忆分开它们之处（如谁先到），律不说这个差别是否要紧。第 151 节所读的条目是选择者对选项的模型：它能分辨什么。核心中模型就是一个归并（`Learning.Lumped`；理依 Ren 读作对结构与变化之规律的建模）。用“模型”而不是“认知模型”：律也涵盖没有认知的选择者，如排序规则或抽签。

**第 151 节的律，重读。** 一个选择经模型，当交换两个选项的条目即交换所选者（`Relabel.Equivariant`）；两个选项被每个经模型的选择选得相同，恰当模型使二者并列（`Relabel.selected_alike_iff`）；至多选一个者单独选出一个选项，恰当没有别的选项的条目与它相同（`Relabel.singled_iff_untied`）；取值与选取同第 151 节。律与证明不变，只是所读之物改称其名。

**新：模型是一个归并（`Becoming.Learning`，“经选项模型的选择”一节，8 项定理，不加前提）。**
- 经模型的选择是经其归并的选择：模型所并者被选得相同（`selects_through_lumping`，即 `Training.Through` 在模型的归并上），经模型的取值经归并同去（`values_lumped`）。
- 只在要紧者经归并同去之处正确：经模型的选择若恰选出满足 p 的选项，p 对模型所并者同真同假（`selects_right_through`）；取值若处处等于 f，f 经归并同去（`values_right_lumped`）。
- 模型所并者，无一经它的选择可分开：p 对模型所并的两个选项一真一假时，没有经模型的选择恰选出满足 p 者（`selects_not_right_of_parted`；取值为 `values_not_right_of_parted`）。要分开，需要更细的模型。
- 要紧者从模型读出时，经模型读出它即正确（`selects_right_of_reads`、`values_right_of_reads`）。

这与 `lumped_right_iff` 同形：经归并的推广，正确恰在世界经归并同去之处；经模型的选择是推广的一种。

**读法（AI 对 Ren 的更正的读法，Ren 同日认可）。** 选择的好坏取决于它所经的模型。模型所并者，经它的选择分不开；要分开，需要更细的模型；那个模型是否正确，在于它对要紧者的拟合，不在于记得多少：记录给出差别，不给出差别是否要紧。第 151 节的读法撤回。[TIE-BREAKING-LEGITIMACY](../history/root-foundation/TIE-BREAKING-LEGITIMACY.md) 已说任何能分开的记录在形式上都可用，所以相关性不能交给形式；这里的定理说明为什么：形式只给出“经模型”，正确与否在模型与要紧者之间。

**其余两项。** `_by_core` 的名保留（Ren：“keep names”）：工作板规则 8 管核心律、实例模块名与记录标题，后缀只指回所重述的原定理，与此前各实例模块同。IdealWarrant 留在 Ren 暂留脊柱外的一般数学线（Ren：“(a)”），日后与 CompletionRole、HistoryIdeals 一起接入，使三者共用核心的理想词汇；其运行层情形已在脊柱上（`Becoming.Refutable`，经 PrefixSafety，第 145 节）。归类表原说明有误：IdealWarrant 自己定义偏序与理想，CompletionRole 与 HistoryIdeals 导入它，不是相反；说明已改正，它移入“一般数学”主题。

**作者反审。**
1. **新结果还是连接？** 连接：8 项定理各一两行，都由 `Equivariant.tied` 与 `EquivariantValue.tied` 给出，不是新的独立结果。用处是使“模型”有确切意义：所读的条目即一个归并，选择的正确与否即 `lumped_right_iff` 的同一形式。
2. **方向。** 必要方向（只在……之处正确）对任何经模型的选择成立；充分方向只对从模型读出的要紧者，要求读出的 q 或 h 给出。由 `Lumped r f` 构造 h 需要在模型的每个值上取一个原像，核心不陈述。
3. **没有说的。** 律不说哪个模型对，也不说什么要紧：要紧者是给出的 p、f。较细的模型从哪里来、怎样学到，属学习（第 92–93 节）与识（第 70 节）。

**边界。** 同第 151 节：抽签是否正当、按大小或轮次的优先，保持原文件的范围。

## 154. 截断所失：任意耦合时程——精确余项、按时间次序的链与安定的时程（Becoming.Remainder）

2026-10-16。P118 的记录 [how-a-carried-difference-grows](../../../../theories/becoming/results/records/how-a-carried-difference-grows.md) 的 next_delta 首项是“时有时无的耦合上的回路”，`Becoming.Loops` 把“耦合时有时无处的增长”列为没有导出；理论第 8 节的状态行与进一步证明在“反馈与所及”下开放同一项。`Becoming.Loops` 的当且仅当（`finite_order_iff_no_loop`）要求每个耦合每步成立、全部条件列出，只在第一步耦合的回路（`Loops.Once.not_always`）表明前者不能照原样去掉。Ren 2026-10-12 问：“how how accurate can we do that uh what is the limitation do we have losses”，目标是“move towards 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）；2026-10-11 要求先求零前提；2026-10-16 决定 P118 的三条读法，其中第二条把只在某些步成立的耦合留为开放（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-loops-readings-and-delegated-choices.md)）。本节在第一部分之内回答：不加公理，除各定理所写的强度不加前提，对任意耦合时程、任意条件之列。工作板上认领为 P120。

```text
Result(s): 新增 what-a-cut-loses；回答 how-a-carried-difference-grows 的 next_delta 首项“时有时无的耦合上的回路”（就截断与
           有限阶的精确而言；失控的速度仍开放）；复用 how-a-carried-difference-grows（carriedWithin、carriedFrom、orderBelow、
           Couples、CoupledInto、OnLoop、Upstream、CouplesAlways、loop_of_coupledInto、carriedWithin_le_withinBound、
           carried_le_carriedWithin_add、Loops.missBound、Loops.withinBound_eq、Loops.SelfLoop、Loops.Once）；
           how-much-difference-arrives（carried、carriedGive、Conveyed、carried_pos_iff、most_difference_arrives）；
           recurrence-without-premise（revisits_within、gap_of_le、gap_of_lt）
Delta: 新核心模块 Becoming.Remainder（导入 Loops；58 项定理／66 项声明）；不改已有模块的陈述（同一分支上另一提交按 Ren 的决定
       修改 Loops.lean 的读法，只改说明）
Supplied premises / correspondence: 不加公理；各定理所写者写在定理中：耦合强度 k（给出的界）；界的定理中部分在起始之后不给差、
       起始之差至多 D、每步进入每个条件的强度至多 M；回路的定理中耦合复现（CouplingRecurs）或时程自某步安定（SettledFrom），
       耦合每步成立者（CouplesAlways）是其特例；一处更紧的计数列出全部条件（every）；对一切律的定理中条件各列一次（every、
       Distinct）与条件的相等可判定（经 most_difference_arrives，只在证明中）
Evidence: scratch_build 对 main e47a1ede 加 P118 读法的提交 51dcf0dc：Becoming.Remainder 58 项定理、66 项声明，公理报告全部
          为空，无警告；Becoming.Loops 改了说明后重编，113 项定理不变；根模块 Becoming 与其导入闭包一同编译，无重名；清点在同一
          字节上运行；合并检查器回执待整合者的运行
Boundary: 离散的步、自然数的量；强度与耦合时程是给出的；每个时程是否终将安定、复现耦合的回路是否都使能到达的最大差别失控、比
          强度之积更细的失控速度开放；不含伦理谓词
Integration: §2 新增一段（截断所失），所携带的差别怎样增长一段中的“不推出”；第一部分的总陈述一条；§8 的状态行与进一步证明各改
       一项；§9 新增一行；术语表新增三行；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列与范围说明；Lean README
       一行与层内导入；DECIDABILITY-INVENTORY.py 的分类；一项新记录与一项配对说明
```

**一、精确余项。** 一次回应从给定水平 `l` 所携带的（`responded`）是携带之律去掉起始之差与部分之差、读 `l` 所得；j 次回应依次所携带的（`responses`）：0 次是 `l` 本身，j + 1 次是一次回应从 j 次所携带者所携带的。给出对所读的水平可加：一个形成从两组水平之和所给的，是从第一组所给的（带部分之差）加从第二组所给的（不带）（`carriedGive_add`），所携带的亦然（`carriedFrom_add`）。于是对 j 归纳：所携带的量是 j 阶之下各阶（`orderBelow`）加上 j 次回应依次从所携带的量自身所携带的（`carried_eq_orderBelow_add`）；j + 1 时，所携带的量是它自身的一步（`carriedFrom_carried`），把读到的所携带的量换成 j 阶之下各阶加余项，再按可加分开。所以在 j 阶截断恰好失去 j + 1 次回应从所携带的量所携带的（`carried_eq_carriedWithin_add`）：对任意耦合时程，不加前提。所失随阶下降（`responses_antitone`）；部分不给差、起始之差至多 D、每步进入每个条件的强度至多 M 时，所失至多是 `Loops.missBound M D j t`（`responses_le_missBound`），自环恰好失去这么多（`Loops.SelfLoop.responses_eq`）。

**二、截断在哪里失去。** 某步的耦合（`CouplesAt u s d c`）：第 u 步一个在场、在部分之外的形成，以正强度在 `d` 第 s 步（s ≤ u）的水平上与 `c` 交换；耦合恰是某步的耦合（`couples_iff_couplesAt`）。一次回应到第 t 步有所携带到 `c`，恰在 t 之前某步 u 有 `CouplesAt u s d c` 且 `l s d` 为正（`responded_pos_iff`）。差经 j 次或更多回应传到（`ConveyedThrough`）：0 次是 `Becoming.Propagation` 的时间路线（`Conveyed`），j + 1 次是在 t 之前某步，一个已经 j 次或更多回应传到第 s 步的条件 `d`，其第 s 步的水平耦合到 `c`。j 次回应从所携带的量所携带的为正，恰在差经 j 次或更多回应传到（`responses_pos_iff`，0 次即 `carried_pos_iff`）。所以 j 阶之下各阶在第 t 步 `c` 处有所漏，恰在差经 j 次或更多回应传到那里（`orderBelow_lt_iff`）；j 阶有所漏恰在经 j + 1 次传到（`carriedWithin_lt_iff`），精确恰在没有（`carriedWithin_eq_iff`）。

**三、从每个起始之差。** 按时间次序的耦合链（`CoupledIntoBy j t c`）：0 个耦合处处成立；j + 1 个是在 t 之前某步，一个 j 个耦合的这种链到第 s 步已终于的条件 `d`，其第 s 步的水平耦合到 `c`。差经 j 次传到者走过这样的链（`ConveyedThrough.coupledIntoBy`）；起始之差处处为一时，每条这样的链都传差（`CoupledIntoBy.conveyedThrough_ones`）。所以 j 阶在第 t 步 `c` 处从每个起始之差都精确，恰在没有 j + 1 个耦合的按时间次序的链到第 t 步终于 `c`（`exact_every_start_iff`）。有限阶在 `c` 处每步从每个起始之差都精确，恰在终于 `c` 的按时间次序的链长度有界（`finite_order_iff_bounded`），这时一个阶对一切起始之差都精确（`finite_order_uniform_iff`）。j 个耦合的按时间次序的链需要 j 步（`CoupledIntoBy.le_steps`），不计时间时是耦合的链（`CoupledIntoBy.coupledInto`）。这三条不加前提，对任意耦合时程、任意条件之列。

**四、时有时无的耦合。** 耦合复现（`CouplingRecurs d c`）：对每个 N，有耦合读 `d` 第 N 步或更晚的水平；耦合每步成立时复现（`CouplesAlways.recurs`）。沿复现的耦合，传到链起点者经多一次回应传到下一个条件（`conveyedThrough_along`），绕复现耦合的回路每圈多回路长度次回应（`conveyedThrough_around`）。所以差到达复现耦合的回路、又有复现耦合从它通到 `c` 时，每一阶都在某步在 `c` 处漏掉一些（`carriedWithin_lt_of_recurring_loop`），按时间次序的链没有界（`unbounded_of_recurring_loop`）。没有耦合从第 N 步起读水平时，按时间次序的链至多 N 个耦合，N 阶处处精确（`exact_of_reading_before`）。每个耦合读一个列出的条件，所以比条件数多一个耦合的链，其前 `cs.length + 1` 个条件都已列出，有一个重复：经过回路，不需列出全部条件（`loop_of_coupledInto_succ`）；上游没有回路时，按时间次序的链至多与条件数一样多个耦合（`no_chain_of_no_loop`；全部条件列出时少一个，`no_chain_of_no_loop_listed`）。耦合每步成立时，链有界恰在上游没有回路处（`bounded_iff_no_loop`），也不需列出全部条件。

**五、时程安定之处。** 第 N 步起的强度（`strengthsFrom N k`）去掉第 N 步之前水平上的读取：其耦合恰是读第 N 步或更晚水平的耦合（`couples_strengthsFrom_iff`），复现恰是从每步起都是耦合（`couplingRecurs_iff`）。N + j 个耦合的按时间次序的链，后 j 个读第 N 步或更晚的水平：是第 N 步起的耦合的按时间次序的链（`CoupledIntoBy.tail`），因为链上第 i 个耦合所读的水平至早在第 i − 1 步。所以第 N 步起的耦合没有回路在 `c` 的上游时，没有 N + 条件数 + 1 个耦合的按时间次序的链终于 `c`（`no_chain_of_no_loop_from`），不论时程。时程自第 N 步安定（`SettledFrom N`）：第 N 步起的每个耦合都复现；耦合每步成立时自第一步安定（`settledFrom_zero_of_always`）。安定时，链有界恰在第 N 步起的耦合没有回路在 `c` 的上游（`bounded_iff_no_loop_from`），所以有限阶从每个起始之差都精确亦然（`finite_order_iff_no_loop_from`）。不论时程，第 N 步起的耦合没有回路在上游时，所携带的量至多是 `D * Loops.orderSum M (N + cs.length) t`，步数的多项式（`carried_le_polynomial_from`）：能到达的最大差别快于每个多项式，只经由持续耦合的回路。`Loops.Once` 的回路只读第一步（`Loops.Once.reads_first`）：没有两个耦合的按时间次序的链（`Loops.Once.no_chain_of_two`），时程自第二步安定且其后没有耦合（`Loops.Once.none_from_one`、`Loops.Once.settled`）。

**六、`Becoming.Loops` 作为实例。** P118 的精确性结果都从这里推出：j 阶到第 j 步为止精确（`Remainder.carriedWithin_exact`，由 `exact_every_start_iff` 与 `CoupledIntoBy.le_steps`）；上游没有回路且全部条件列出时比条件数少一的阶精确（`Remainder.carriedWithin_exact_of_no_loop`）；耦合每步成立时有限阶精确恰在上游没有回路处，现在不需列出全部条件（`Remainder.finite_order_iff_no_loop`）；只在第一步耦合的回路让 1 阶精确（`Remainder.Once.exact`，由 `exact_of_reading_before`）。

**七、对一切律。** 由 `most_difference_arrives`，条件各列一次时：对一切具有强度 k 的读已立者之律及其两个平衡的流，第 T 步 `c` 处之差从每个起始之差都至多是 j 阶所携带的，恰在没有 j + 1 个耦合的按时间次序的链到第 T 步终于 `c`（`gap_within_order_iff`）。

```lean
theorem carried_eq_carriedWithin_add (j t : Nat) (c : C) :
    carried cs part σ k present δ t c =
      carriedWithin cs part σ k present δ j t c +
        responses cs part k present (carried cs part σ k present δ) (j + 1) t c

theorem exact_every_start_iff (j t : Nat) (c : C) :
    (∀ δ : C → Nat, carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ¬ CoupledIntoBy cs part k present (j + 1) t c

theorem finite_order_iff_bounded (c : C) :
    (∀ δ : C → Nat, ∃ j, ∀ t,
        carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ∃ J, ∀ t, ¬ CoupledIntoBy cs part k present (J + 1) t c

theorem finite_order_iff_no_loop_from {N : Nat}
    (settled : SettledFrom cs part k present N) (c : C) :
    (∀ δ : C → Nat, ∃ j, ∀ t,
        carriedWithin cs part σ k present δ j t c = carried cs part σ k present δ t c) ↔
      ∀ e, Upstream cs part (strengthsFrom N k) present e c →
        ¬ OnLoop cs part (strengthsFrom N k) present e

theorem carried_le_polynomial_from {N : Nat} {c : C}
    (noLoop : ∀ e, Upstream cs part (strengthsFrom N k) present e c →
      ¬ OnLoop cs part (strengthsFrom N k) present e)
    {M D : Nat} (start : ∀ c, δ c ≤ D) (into : ∀ t c, inflow cs part k present t c ≤ M) (t : Nat) :
    carried cs part (fun _ _ _ => 0) k present δ t c ≤ D * Loops.orderSum M (N + cs.length) t
```

**读法（AI 的，待 Ren）。**
1. **截断之所失，是余项。** Ren 2026-10-12 问精度、界限与损失；2026-10-16 把 `Becoming.Loops` 的各阶取为与历史之和同一结构的一种，按回应次数组织，如费曼图按顶点数组织。精确余项说截断这一展开失去什么，形如 Neumann 级数的余项：j 阶之下各阶是少于 j 次回应的项，截断所失是 j 次回应从整体所携带的。如按时间次序的微扰展开（Dyson 级数），一条路线上的回应按时间次序，每个所读的水平在前一个到达之后；截断恰在有更多回应的时间路线到达处失去。损失属于截断，不属于理论：所携带的量本身是精确的。
2. **有意义的回路是持续耦合的回路。** Ren 暂取：回路在展开之中形成与消散，定理按每步的样子取用它们。对截断而言，决定损失的是耦合的时间次序，不是不计时间画出的回路：时程安定之后，有限阶精确恰在其后的耦合没有回路在上游处；耦合停止的回路只是经过，它所携带的有限阶都携带。
3. **失控只经由持续耦合的回路。** Ren 取“只有回路使差别失控”，只在某些步成立的耦合开放。对任意时程，能到达的最大差别快于每个多项式，只经由持续耦合的回路（`carried_le_polynomial_from`）；是否经由每个这样的回路，这里不推出：复现耦合的回路使每个有限阶都不精确，这还不是速度。

**作者反审。**
1. **新律还是重述？** 余项恒等式是线性时变比较系统的 Neumann 级数（Dyson 级数、Peano–Baker 级数）的余项；按时间次序的链是时序网络中的“尊重时间的路径”（time-respecting paths）；有限阶精确恰在这种路径有界处，是时变系统的幂零。这些在数学上是标准的。新的是：（a）在核心的交换律上陈述，不加前提，对任意时程与任意条件之列；（b）余项与“哪里失去”都是恒等或当且仅当，不只是界；（c）安定的时程上以持续耦合的回路给出当且仅当，并给出 P118 的当且仅当不需列出全部条件；（d）经 `most_difference_arrives` 对一切律。
2. **为什么不需列出全部条件。** P118 的鸽笼要求链上每个条件都已列出；但每个耦合的来源都在条件之列中（`CouplesAt` 要求 `d ∈ cs`），终点 `c` 可以不在。比条件数多一个耦合的链有 `cs.length + 1` 个来源，都在列中，所以有重复。代价是多一个耦合；列出全部条件时 `no_chain_of_no_loop_listed` 给出原来的界。
3. **安定是前提，不是定理。** 条件有限时，经典地每个时程都终将安定：不复现的耦合在某步后不再出现，取其最大者即可。但耦合是否复现是 Π₂ 的陈述，这里不判定，核心也不假设排中律；所以有限阶精确的当且仅当以 `SettledFrom` 为前提陈述，而以按时间次序的链陈述的当且仅当（`finite_order_iff_bounded`）不需任何前提。“每个时程终将安定”所需的确切强度（哪一个全知原则）开放。
4. **不精确不是失控。** 复现耦合的回路使每个有限阶都不精确，但所携带的量可以增长得很慢：例如一个自环只在 2 的幂那些步耦合，每次加倍，到第 t 步只加倍约 log₂ t 次，所携带的量与 t 同阶。这个例子这里没有证明，只说明“经由每个持续耦合的回路失控”不能从不精确推出；Ren 的第二条读法中“只在某些步成立的耦合开放”，就速度而言仍开放。
5. **最坏情形，不是每个律。** 所携带的量是一切具有这些强度之律的上界，由携带之律达到；截断所失是这个上界的展开所失。对一切律的陈述只经 `gap_within_order_iff`：差在 j 阶之内恰在没有更长的按时间次序的链处。
6. **名称。** `CouplesAt`、`CoupledIntoBy`、`ConveyedThrough`、`CouplingRecurs`、`strengthsFrom`、`SettledFrom` 与 `Remainder` 都是结构的名称（板规第 8 条）；不含二元或限定范围的词，不含市场的词。
7. **范围。** 不含伦理谓词；离散的步、自然数的量；强度与时程是给出的。

## 155. 携带差别的阶作为历史之和：P118 的阶是 P82 的视界（Becoming.Routes）

2026-10-16。Ren 取了 P118 读法的这一形式：Ren 2026-10-12 所问的积分，对不确定的律，是 P82 的历史之和及其四种损失（`Becoming.Weighted`）；P118 的阶是同一结构类的，按回应次数组织，如同费曼图按顶点数；两者尚未连起来（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-loops-readings-and-delegated-choices.md)）。同日 Ren 说：“joining P82's sum over histories with P118's orders; a theorem showing how loops form within the unfolding. let's finish both”。本节回答第一项，在第一部分之内：不加公理，除各定理所写者不加前提。工作板上认领为 P121。

```text
Result(s): 新增 orders-as-a-sum-over-histories；回答 how-a-carried-difference-grows 与 losses-of-the-sum-over-histories
           的 next_delta 中“把各阶接到历史之和”；复用 losses-of-the-sum-over-histories（Weights、Weights.sum、
           Weights.transfer、Weights.along、Weights.sum_courses、Weights.Hom、counting、openSteps、courses、joinMap）；
           how-a-carried-difference-grows（carriedWithin、carriedFrom、carriedWithin_exact、carriedWithin_mono、
           carriedWithin_le_carried、carried_eq_carriedWithin、carried_le_carriedWithin_add、
           finite_order_iff_no_loop_stationary、Loops.orderSum、Loops.orderSum_step、Loops.missBound）；
           how-much-difference-arrives（carried、carriedGive）
Delta: 新核心模块 Becoming.Routes（导入 Weighted 与 Loops；30 项定理／39 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各定理所写者写在定理中：权重及其律（Weights）；列出的步与构形；
       强度 k（给出的界）；截断之界中部分不给差、起始之差至多 D、每步进入每个条件的强度至多 M；当且仅当中条件全部
       列出、形成与强度每步相同（stationary）
Evidence: scratch_build 对 main 271ab66a：Becoming.Routes 30 项定理、39 项声明，公理报告全部为空，无警告；
          合并检查器回执待整合者的运行
Boundary: 计数的权重，不相消；离散的步、自然数的量；强度是给出的；按“恰好 i 次回应”分组需要可交换的相加，未陈述；
          不含伦理谓词
Integration: §2 新增一段；第一部分的总陈述一条；§8 进一步证明一项；§9 新增一行；术语表一行；Becoming.lean 的导入与
       模块说明；check_becoming.py 的核心之列与范围说明；Lean README 一行与层内导入；一项新记录与两项配对说明
```

**一、每个历史之和按阶展开。** 对每一种权重（`Weights`），把每步的权重分成基础部分与回应部分。j 阶（`Weights.within`）跨每步由基础部分读 j 阶、由回应部分读 j − 1 阶，0 阶只读基础部分：正是 `carriedWithin` 的形状。n 步的历程至多有 n 次回应，所以 j 阶在每个不超过 j 的视界上就是整个历史之和（`Weights.within_exact`：证明只用右分配律，不用相加的交换）。保持权重之律的读法可以逐阶取（`Weights.Hom.within`）。计数时各阶上升（`counting_within_le_succ`），不超过历史之和（`counting_within_le_transfer`）。

**二、P118 的时间次序是 P82 的阶。** 一个构形、基础权重为一、回应权重为 M 时，视界 n 上的 j 阶是 `Loops.orderSum M j n`，即对 i ≤ j 的 `Loops.binom n i * M ^ i` 之和（`Routes.SelfLoop.within_eq`，由 P118 的帕斯卡法则 `Loops.orderSum_step`）；整个和是 `(1 + M) ^ n`（`Routes.SelfLoop.transfer_eq`），于是 `Loops.orderSum M n n = (1 + M) ^ n`（`Routes.SelfLoop.within_exact`）。这是 P118 的自环；M 为一时是 P82 绕回路倍增的历程。

**三、所携带的量是历史之和。** 把一个差别沿时间往回追：从第 τ 步 `c` 的水平（`RoutePoint.level τ c`）出发，一步是一次回应，到较早第 s 步 `d` 的水平，权重是强度在回应能发生的每一步上的和，其间水平保持（`responseWeight`，由 `respondAt` 逐步累加）；或者终于源（`RoutePoint.source`），权重是 0 阶（起始之差与部分之差，保持）；源停在源。这些是步的计数权重（`routeWeight`）；读到终点是否到达源（`routeRead`）。在列出的路线点上（源与第 T 步之前的水平，`routePoints`），P82 的转移（`routeSum`）在视界 j + 1 上就是 P118 的 j 阶，对 T 以内的每个条件与每步（`routeSum_eq_carriedWithin`）。证明的关键是线性：从给定水平 `l` 所携带的，是 0 阶加每次回应的权重乘它所读的水平（`carriedFrom_eq_routes`，由 `give_split`），而源在每个视界上给一（`routeSum_source`）。于是由 `Weights.sum_courses`，每一阶是 j + 1 步的一切历程的步权之积之和（`carriedWithin_eq_courses`），第 t 步所携带的量是 t + 1 步的一切历程之和（`carried_eq_courses`）。

**四、截断是视界；回路是两者相乘之处。** P118 在 j 阶的截断就是 P82 在视界 j + 1 的截断：视界超过步数时精确（`routeSum_exact`），随视界上升（`routeSum_mono`），不超过所携带的量（`routeSum_le_carried`），所漏至多 `Loops.missBound M D j t`（`carried_le_routeSum_add`）。条件全部列出、形成与强度每步相同时，路线之和的某个有限视界从每个起始之差在每步精确，恰当上游没有回路（`finite_horizon_iff_no_loop`）。P82 的回路损失（历程绕回路相乘，没有一个视界足够）就是 P118 的失控。

```lean
def Weights.within (W : Weights R) (ground response : S → A → S → R) (moves : List A)
    (all : List S) (f : S → R) : Nat → Nat → S → R
  | _, 0, s => f s
  | 0, n + 1, s => W.sum (openSteps moves all) fun p =>
      W.mul (ground s p.1 p.2) (Weights.within W ground response moves all f 0 n p.2)
  | j + 1, n + 1, s => W.sum (openSteps moves all) fun p =>
      W.add (W.mul (ground s p.1 p.2) (Weights.within W ground response moves all f (j + 1) n p.2))
        (W.mul (response s p.1 p.2) (Weights.within W ground response moves all f j n p.2))

theorem routeSum_eq_carriedWithin {T : Nat} :
    ∀ j τ, τ ≤ T → ∀ c, routeSum cs part σ k present δ T (j + 1) (.level τ c) =
      carriedWithin cs part σ k present δ j τ c

theorem carried_eq_courses (t : Nat) (c : C) :
    carried cs part σ k present δ t c =
      counting.sum (courses [()] (routePoints cs t) (t + 1))
        (counting.along (routeWeight cs part σ k present δ) routeRead (.level t c))
```

**读法（AI 的，待 Ren）。**
1. **一个积分。** 接合使结构上的对应成为确切的：沿时间往回的路线是 P82 意义上的历史，它的步是回应（图的顶点），顶点之间水平保持，对回应能发生的各步求和，如同传播子对中间时刻求和；它的阶是顶点数。所以 Ren 所问的“积分”是一个：P118 的各阶就是 P82 的历史之和，按视界组织，两者的损失相遇：和的截断就是展开的截断，P82 中使历程相乘的回路就是 P118 中使差别失控的回路。
2. **结构的，不是物理的。** 权重是强度的计数，不是振幅；计数的权重不相消（`Becoming.Weighted` 的 `Interference.unseen`），所以这里没有干涉。

**Ren 的决定（2026-10-16）。** Ren 答 P121 与 P122 落地的报告：“alright, agree”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-routes-closing-readings.md)）。AI 读为 Ren 取这两条读法，用 AI 的措辞；两个积分是一个，对应是结构的。

**作者反审。**
1. **新律还是重述？** 线性递推等于路径之和（转移矩阵的幂按路径展开）是标准的；Dyson 级数按相互作用次数展开亦然。新的是：（a）它把核心里两个独立陈述的模块确切地接上，P118 的阶与 P82 的视界在每个条件与每步相等，经 `Weights.sum_courses` 成为历程之和；（b）“每个历史之和按阶展开、j 阶到视界 j 精确”对每一种权重陈述，只用右分配律。
2. **保持去哪了？** 路线点的一步跳过任意多步：保持被吸收进回应的权重（`responseWeight` 对回应能发生的每步求和）。另一种编码（每步一个“保持”）需要构形的相等可判定；这里不需要。
3. **为什么只到“至多 j 次”。** 按“恰好 i 次回应”的分组要把各阶之和重新排列，需要相加可交换；对一般的 `Weights` 不成立（`Weights` 不假定交换），对计数成立但没有陈述。
4. **范围。** 计数的权重；带号或复数的携带差别、无穷多路线点、无界的视界没有陈述。不含伦理谓词。

## 156. 回路怎样在展开中形成：耦合闭合一条链（Becoming.Closing）

2026-10-16。Ren 取了 P118 第三项读法的精炼形式：“一个世界有哪些回路是其情境的一部分；回路在展开中形成与消解，定理按每步所立者取之”，并说“leave it pending until a loop-formation theorem exists”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-loops-readings-and-delegated-choices.md)）。同日 Ren 说：“joining P82's sum over histories with P118's orders; a theorem showing how loops form within the unfolding. let's finish both”。本节回答第二项，在第一部分之内：不加公理，除各定理所写的强度不加前提。工作板上认领为 P122；回路的消解（停止的耦合）与时序之链在 P120（`Becoming.Remainder`，§154）。

```text
Result(s): 新增 how-loops-form；回答 how-a-carried-difference-grows 的 next_delta 中“回路怎样形成，汲取与
           Becoming.Runaway 的策略相遇之处”，使其第三项读法不再待定；复用 what-a-cut-loses（CouplesAt、
           couples_iff_couplesAt、Remainder.le_of_add_le_add_left_nat）；how-a-carried-difference-grows（Couples、
           Coupled、OnLoop、Upstream、carriedGive_of_part、carriedGive_of_rest、carriedGive_congr、carried_le_polynomial、
           Loops.SelfLoop.strengths、Loops.SelfLoop.give、Loops.beq_self、Loops.two_pow_succ）；how-much-difference-arrives
           （carried、carried_succ、carriedGive）；counterfactual-is-the-course（ExchangeLaw、levels、levels_succ、
           totals_under、Nonanticipating、AgreeUpTo）
Delta: 新核心模块 Becoming.Closing（导入 Remainder；51 项定理／61 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各定理所写者写在定理中：强度 k（给出的界）或从水平读出的强度 κ
       （ReadsBefore：每步只读至该步的水平）；多项式之界中条件全部列出、部分不给差、起始之差至多 D、每步进入每个条件的
       强度至多 M
Evidence: scratch_build（对 P120 提交 2a72060f，其 Remainder.lean）：Becoming.Closing 51 项定理、61 项声明，
          公理报告全部为空，无警告；合并检查器回执待整合者的运行
Boundary: 离散的步、自然数的量；强度或读出强度的方式是给出的；对一切律刻画读出强度的回路何时形成没有陈述；
          不含伦理谓词
Integration: §2 新增一段；第一部分的总陈述一条；§8 状态与进一步证明；§9 新增一行；术语表一行；Becoming.lean 的导入
       与模块说明；check_becoming.py 的核心之列与范围说明；Lean README 一行与层内导入；一项新记录与两项配对说明
```

**一、到某步形成的回路。** 第 T 步之前的强度（`strengthsBefore T k`）保留在 T 之前作用的耦合，去掉其余；它的耦合恰是在 T 之前某步作用的耦合（`couples_before_iff`，用 P120 的 `CouplesAt`），随 T 上升（`couples_before_mono`）。到 T 形成的回路就是它的回路，于是 P118 的链、回路与上游的定义直接适用，不另立平行的定义。每条耦合的链都在某步形成（`coupled_formed`）：一个世界的回路恰是到某步形成的回路（`onLoop_iff_formed`），上游亦然（`upstream_iff_formed`）。

**二、回路由闭合而形成。** 到 T + 1 形成的回路，是到 T 形成的回路，以及经过一个在第 T 步作用、闭合一条链的耦合的回路：它读 `d` 的水平、给 `c`，而已有链从 `c` 经回路的条件通到 `d`（`onLoop_succ_iff`）。证明把到 T + 1 的链分成：全部在 T 之前，或有一个耦合在第 T 步作用（`Closing.split`，只对作用的步做自然数的比较，不需判定耦合本身）；在那个耦合处把回路转开。反过来，有链进出一个条件的耦合闭合经过它的回路（`onLoop_of_closing`，由链的接合 `Coupled.append`）。所以一个形成的回路经过在它形成之步作用的耦合（`forms_by_closing`）；一个交换开始回应它所给的条件的水平，形成一圈的回路（`responds_to_own_level`）。

**三、回路形成之前。** 到第 T 步所携带的量只读在 T 之前作用的耦合（`carried_before`）。所以到 T 形成的回路都不在 `c` 的上游时，`c` 处到 T 的每步所携带的量至多是步数的多项式，次数比条件数少一，不论此后耦合怎样（`carried_le_polynomial_before`，由 P118 的 `carried_le_polynomial` 与 `inflow_before_le`）。形成之前的量不显示它是否将形成：在第 T 步形成的强度为一的自环（`Closing.Onset.strengths`）到 T 为止保持起始之差不变（`Onset.amount_before`），此后每步加倍（`Onset.amount_after`）；它在 T 形成，之前没有（`Onset.forms`、`Onset.not_formed`）；在任何更晚的步形成的回路，到 T 为止携带同样的量（`Onset.unforeseen`）。

**四、从展开读出的耦合。** 一个律每步的强度只从至该步的水平读出（`ReadsBefore`）时，给出其读出强度对水平所作者的律（`ExchangeLaw.carryingRead`，读已立者：`ExchangeLaw.carryingRead_nonanticipating`）生成一个进程（`formedCourse`，由 `Becoming.Counterfactual` 的生成），它就是它所读强度的所携带的量（`formedCourse_eq_carried`）。于是以上各条对这个进程自己形成的耦合成立：哪些回路形成、何时形成，从展开读出。阈值的见证（`Closing.Threshold`）：部分每步给一个单位，部分之外的形成与这个条件的交换在其水平达到 θ 后回应它。水平到 θ 为止是 t（`Threshold.level_before`）；回路在第 θ 步形成，之前没有（`Threshold.forms`、`Threshold.not_formed`）；此后水平加一每步加倍（`Threshold.level_after`）；到 θ 为止，对 θ 之外的每个阈值进程相同（`Threshold.unforeseen`）。

```lean
theorem onLoop_succ_iff {T : Nat} {e : C} :
    OnLoop cs part (strengthsBefore (T + 1) k) present e ↔
      OnLoop cs part (strengthsBefore T k) present e ∨
        ∃ d c s, CouplesAt cs part k present T s d c ∧
          Upstream cs part (strengthsBefore (T + 1) k) present c e ∧
            Upstream cs part (strengthsBefore (T + 1) k) present e d

theorem formedCourse_eq_carried (reads : ReadsBefore κ) :
    ∀ t c, formedCourse cs part σ κ present δ t c =
      carried cs part σ (κ (formedCourse cs part σ κ present δ)) present δ t c
```

**读法（AI 的，待 Ren）。**
1. **回路由闭合而形成。** 一个回路在某步形成，恰在那一步某个交换开始回应它所给的条件下游的一个水平之处。强度从进程读出时，如阈值的见证，耦合以至回路都是展开所形成的一部分。这就是 Ren 让 P118 第三项读法待定所等的定理：读法现在可以说，回路以这种闭合在展开中形成与消解（消解见 P120：停止的耦合所携带的，有限阶携带），定理按每步所立者取之。
2. **回路的形成不从它之前的量预见。** 形成之前增长至多是多项式；形成之步不由至今的进程显示；形成之后的量至少按几何级数增长。这与 `Becoming.Runaway`（P55）相遇：在那里失控的断裂在其前不被识；这里使之失控的回路的形成，也不被它所携带的量识。能识它的是识耦合本身者（在阈值的见证中，水平与 θ 的距离）。

**Ren 的决定（2026-10-16）。** 同一句“alright, agree”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-routes-closing-readings.md)）。AI 读为 Ren 取这两条读法，并取 P118 第三项读法的修订形式：一个世界有哪些回路是其情境的一部分：回路在展开中由闭合而形成，在某个交换开始回应它所给条件下游的一个水平之步形成；在其耦合停止处消解（时程安定之后，有限阶精确恰在其后的耦合没有回路在上游处）；强度从进程读出时，哪些回路形成、何时形成从展开读出；定理按每步所立者取之，强度或读出强度的方式是给出的。在一个律中把回路的形成与 `Becoming.Runaway` 的策略连起来，AI 不读为已开始；P120 的读法不在其中。

**作者反审。**
1. **新律还是重述？** “新回路必经过新边”是图论的平凡事实；新的是：（a）它在核心的时变耦合上陈述为当且仅当，回路的定义复用 P118 而不另立；（b）形成之前的多项式界“不论此后耦合怎样”，把 P118 的界接到形成的时刻；（c）强度从进程读出时，进程等于其所读强度的所携带的量，所以形成本身在展开之内。
2. **“新的”耦合。** `onLoop_succ_iff` 说闭合的耦合在第 T 步作用，没有说它在 T 之前不作用：要挑出一个此前不作用的耦合，需要判定一个耦合在 T 之前是否作用，核心不假定排中律。在第 T 步作用就够了：经过它的回路在 T + 1 形成。
3. **见证的选择。** 阈值的见证用一个条件与一个自环：形成的最简单情形。它说明形成可以完全由进程决定；对一切律刻画读出强度的回路何时形成，没有陈述。
4. **范围。** 离散的步、自然数的量；强度或读出强度的方式是给出的。不含伦理谓词。

## 157. 回路在律所读之内，与断裂：回路的形成与 Becoming.Runaway 的策略在一个律中（Becoming.Thresholds）

2026-10-16。P118 第三项读法（Ren 同日取其修订形式）与 P122 留下“一个形成的汲取开始回应其汲取所降低的水平，那里与 `Becoming.Runaway` 相遇”；how-a-carried-difference-grows 与 how-loops-form 的下一步都列“在一个律中把回路的形成与 Becoming.Runaway 的策略连起来”。AI 问是否开始，Ren 答：“please”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-loop-formation-and-policies-go.md)）。本节在第一部分之内回答：不加公理，除各定理所写者不加前提。工作板上认领为 P124。

```text
Result(s): 新增 loops-within-what-a-law-reads；回答 how-a-carried-difference-grows 与 how-loops-form 的 next_delta 中
           “在一个律中把回路的形成与 Becoming.Runaway 的策略连起来”，runaway-distance-unregistered 的“把这里的策略与回路
           相连”；复用 counterfactual-is-the-course（ExchangeLaw、GivesAlike、Nonanticipating、Through、Flow.Follows、
           Flow.ActsAlike、Flow.totals_alike_of_each）、how-much-difference-arrives（RespondsWithin、exchangeGap、
           exchangeGap_of_alike、gap、gap_add_self）、how-a-carried-difference-grows（Couples、Coupled、OnLoop、Upstream、
           Loops.beq_self、Loops.ble_succ_self）、what-a-cut-loses（CouplesAt、couples_iff_couplesAt）、how-loops-form
           （strengthsBefore、onLoop_succ_iff、Closing.ble_false_of_lt）、runaway-distance-unregistered（Flow.PolicyThrough）
Delta: 新核心模块 Becoming.Thresholds（导入 Closing 与 Runaway；38 项定理／45 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各定理所写者写在定理中：律所读的时程（ReadsAt）或只在储量低于阈值时才读它
       （ReadsBelow）；强度 k（给出的界）；两个进程平衡、在场的形成相同、部分动作相同、其余遵从律；起始只在储量上不同
Evidence: scratch_build 对 main c0fbc84b：Becoming.Thresholds 38 项定理、45 项声明，公理报告全部为空，无警告；合并检查器
          回执待整合者的运行
Boundary: 离散的步、自然数的量；律读什么、阈值在哪里是给出的；一个形成怎样开始观察它所依赖的储量没有陈述；只在高于阈值时
          才读、或其他形状的读没有陈述；不含伦理谓词
Integration: §2 新增一段；第一部分的总陈述一条；§8 进一步证明一项；§9 新增一行；术语表两行；Becoming.lean 的导入与模块
       说明；check_becoming.py 的核心之列与范围说明；Lean README 一行与层内导入；一项新记录与三项配对说明
```

**一、读限制耦合。** 一个律读一个时程（`ExchangeLaw.ReadsAt`）：对部分之外的每个形成，在时程所标的条件上至该步一致的历史下，律给得相同。未读的水平耦合强度为零（`ExchangeLaw.ReadsAt.respondsWithin_unread`：只在未读的一格上不同的两个历史，所标条件都一致），所以把强度限于所读（`restrictReads`，未读之处为零）仍是律的强度（`ExchangeLaw.ReadsAt.restrict`）。每个读已立者的律读全部（`ExchangeLaw.Nonanticipating.readsAt_all`）；经识而读的律（`Becoming.Counterfactual` 的 `ExchangeLaw.Through`）读每个覆盖其识（所依赖与所观察）的时程（`ExchangeLaw.Through.readsAt`），其进程是 `Becoming.Runaway` 意义上经识的策略（`ExchangeLaw.Through.policyThrough`）：P55 的策略由律给出，不另给第二个流。

**二、回路在所读之内。** 限于所读的强度的每个耦合读其水平（`couplesAt_reads`、`couplesAt_of_reads`、`couples_reads`）；汲取回应它所降低的水平只在它读之处（`self_coupling_reads`）；无人读的水平下游只有它自己（`upstream_unread`），没有回路经过它（`not_onLoop_unread`）。由 P122 的 `onLoop_succ_iff`，回路在一步形成只经过在那一步读其所给之处下游一个水平的形成（`onLoop_succ_reads`）：回路在读增长之处闭合。

**三、无人读者不被带到任何处。** 两个平衡的进程，在场的形成相同、部分动作相同、其余遵从一个律，起始只在储量 c 上不同、第二个高 d：到 T 为止，凡至今别处相同、c 高 d 之处律都给得相同时，到 T 为止别处相同、c 高 d（`held_while`，逐步的平衡）。所以对每个读一个时程的律，T 之前部分之外无人读 c 时，到 T 为止别处相同、差保持（`unread_carried_nowhere`）。

**四、断裂。** 律只在储量低于阈值时才读它（`ExchangeLaw.ReadsBelow`）：两个历史至该步别处相同、储量每步都立于阈值时，律给得相同；储量立着时律只读它立着。经识而读、部分之外无人观察储量、阈值不低于各自所需者的律都是这样（`ExchangeLaw.Through.readsBelow`）：P55 依赖储量而不观察它的形成是其实例。对每个这样的律，储量抬高多少，到第一个进程的断裂为止别处都相同、储量高 d（`break_carried_nowhere`）：P55 的 `Web.break_not_bounded` 对整个律成立，不只是其余固定的一个策略。储量在条件中由给出的标记标出（`mark`，不判定条件；数的比较由 `Thresholds.le_of_not_lt` 判定）。断裂之前律就是其立律（`ExchangeLaw.standing`：储量低于阈值之处读作立于阈值，`standAt`；`ExchangeLaw.Nonanticipating.standing_alike`、`Flow.follows_standing_before`），立律不读储量（`ExchangeLaw.ReadsBelow.standing_readsAt`，`offStock`）、对储量耦合强度为零（`ExchangeLaw.ReadsBelow.standing_unread`）、没有经过储量的回路，储量下游只有它自己（`ExchangeLaw.ReadsBelow.standing_no_loop`）。见证（`Thresholds.Draw`）：一个形成在储量立于 N + 1 时每步从储量汲取一个单位给产物（`Draw.law`、`Draw.nonanticipating`），只在低于 N + 1 时读储量（`Draw.reads`）；它的每个强度都把储量耦合到自身（`Draw.strength_pos`：阈值处储量少一个单位就停止汲取），一圈的回路（`Draw.onLoop`），而断裂之前它给得如其立律，对储量强度为零（`Draw.forms_at_break`）；一步上一个进程的储量低于阈值、抬高者立着，那一步抬高者多给产物一（`Draw.diverges_at_break`）：到断裂为止不变的抬高，在断裂之后显出。

```lean
theorem onLoop_succ_reads {T : Nat} {e : C} :
    OnLoop cs part (strengthsBefore (T + 1) (restrictReads reads k)) present e ↔
      OnLoop cs part (strengthsBefore T (restrictReads reads k)) present e ∨
        ∃ d c s h, h ∈ present T ∧ part h = false ∧ s ≤ T ∧ d ∈ cs ∧ reads T h d = true ∧
          0 < k T h c s d ∧
          Upstream cs part (strengthsBefore (T + 1) (restrictReads reads k)) present c e ∧
          Upstream cs part (strengthsBefore (T + 1) (restrictReads reads k)) present e d

theorem break_carried_nowhere {c : C} {θ : Nat → Nat} (r : law.ReadsBelow part c θ)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (acts : L.ActsAlike L' part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    {d T : Nat} (stands : ∀ s, s < T → θ s ≤ W.level s c)
    (others : ∀ e, e ≠ c → W.level 0 e = W'.level 0 e)
    (stock : W'.level 0 c = W.level 0 c + d) :
    ∀ t, t ≤ T → (∀ e, e ≠ c → W.level t e = W'.level t e) ∧ W'.level t c = W.level t c + d
```

**读法（AI 的，待 Ren）。**
1. **断裂就是回路形成之处。** 能识断裂还有多远的回路，在断裂之前不存在：律只在储量失去支持时才读它。`Becoming.Runaway` 的不识与 `Becoming.Closing` 的形成是同一件事的两面：从形成所识之处看，断裂不被预见；从耦合看，经过储量的回路在断裂处才闭合。
2. **能识距离者是断裂之前对储量水平的读。** 观察储量使回路更早形成，在还有储量时回应（P55 的 `Web.observed_raise_registers`）；这是 P55 读法中“量度、模型或他者之识”在耦合上的形式。

**Ren 的决定（2026-10-16）。** P124 落地之后，对两项读法与改名的问题，Ren 答：“agree in general, need more explanation for c”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-thresholds-readings-and-measure-question.md)；c 是脊柱整合量度的修正，另行解释，不在本节）。AI 读为 Ren 取这两项读法，并同意把 `Thresholds.le_of_not_lt` 改名为 `Thresholds.le_of_not_not`（它的前提是 `¬¬ a ≤ b`，新名字恰说它所证者），陈述与证明不变；改名随 P125（§159）落地。“in general”没有指出保留，AI 不读为对落地文字每一字的判断。

**作者反审。**
1. **新律还是重述？** “只读未变者则给得相同”是非预期与读的定义的直接推论，逐步平衡的归纳是标准的。新的是：（a）把 P55 的策略、P115 的耦合强度、P118 的回路与 P122 的形成放在一个律上：读限制强度，回路在所读之内，形成在读增长之处；（b）P55 的断裂不被识对整个律成立，前提从“其余固定”换成“律只在低于阈值时读储量”，后者对经识而不观察的律是定理；（c）立律给出断裂之前的动力学，没有经过储量的回路。
2. **两个前提不比较强弱。** P55 允许其余任意但固定；这里其余也遵从律，但不必固定。两者都不蕴含另一个；这里说的是整个律的进程。
3. **阈值的形状。** 只在低于阈值时读（储量失去支持）是依赖而不观察的形状；只在高于阈值时读（如 P122 的阈值见证）或其他形状的读，抬高可能改变读，未陈述。
4. **范围。** 离散的步、自然数的量；律读什么、阈值在哪里是给出的；一个形成怎样开始观察它所依赖的储量没有陈述。不含伦理谓词。

## 158. 耦合多常作用：安定、失控与其速度（Becoming.Frequency）

2026-10-16。P120（`Becoming.Remainder`，§154）留下三项：每个耦合时程是否终将安定，复现耦合的回路是否都使能到达的最大差别失控，失控多快（[what-a-cut-loses](../../../../theories/becoming/results/records/what-a-cut-loses.md) 的下一步；第 8 节“反馈与所及”）。Ren 2026-10-12 问回路：“how how accurate can we do that uh what is the limitation do we have losses”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）。2026-10-16 Ren 称 AI 对“只有回路使差别失控”的读法是对的（“your read on this is right”），那一读法的限定之一是只在某些步成立的耦合开放（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-loops-readings-and-delegated-choices.md)）。本节回答这三项，在第一部分之内：不加公理，除各定理所写的强度不加前提，按 Ren 2026-10-11 的先求零前提（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)）。工作板上认领为 P123。

```text
Result(s): 新增 how-often-couplings-act；回答 what-a-cut-loses 的 next_delta 前两项（每个时程是否安定及其确切强度；
           复现耦合的回路是否都使之失控、多快），以及 how-a-carried-difference-grows 的 next_delta 首项中按耦合多常作用
           的部分；复用 what-a-cut-loses（CouplesAt、CouplingRecurs、SettledFrom、couples_strengthsFrom_iff、
           carriedWithin_lt_of_recurring_loop）；how-a-carried-difference-grows（inflow、total_give_le_inflow、
           carried_mono_steps、carriedGive_of_rest、carriedWithin、Loops.SelfLoop 与幂的引理）；how-loops-form
           （carriedGive_congr_strength、Closing.ble_false_of_lt、Closing.Onset）；how-much-difference-arrives（carried、
           carried_succ、carriedGive、gap_le_carried）；coming-and-ceasing-keep-pace（LPO、clear 与第一个真者）；
           recurrence-without-premise（le_succ_cases）
Delta: 新核心模块 Becoming.Frequency（导入 Closing；83 项定理／98 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；各定理所写者写在定理中：强度 k（给出的界）、时程 on（给出的判定的
       序列）；速度中部分在起始之后不给差、起始之差至多 D、每步进入每个条件的强度至多 M，在未标出的步为零；安定的
       定理中条件全部列出（every）；二分 RecursOrStops 用到时作为假设写入，不假定
Evidence: scratch_build：Becoming.Frequency 83 项定理、98 项声明，公理报告全部为空，无警告；合并检查器回执待整合者
          的运行
Boundary: 离散的步、自然数的量（正的强度至少是一）；强度与时程是给出的；自环之外上下界是否达到、给定强度的谱半径
          没有陈述；不含伦理谓词
Integration: §2 新增一段，“截断所失”段末加一个注明日期的括注；第一部分的总陈述一条；§8 状态与进一步证明；§9 新增
       一行；术语表三行；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列与范围说明；Lean README 一行与
       层内导入；可判定性清单一行（gap_le_count，只在证明中）；一项新记录与两项配对说明
```

**一、速度。** 时程 `on : Nat → Bool` 标出一些步，`Frequency.count on t` 数第 t 步之前标出的步。部分在起始之后不给差、起始之差至多 D、每步进入每个条件的强度至多 M、在未标出的步为零时，第 t 步所携带的量至多是 D·(1 + M)^a，a 是第 t 步之前标出的步数（`carried_le_count`）。证明与 P118 的 `carried_le_geomBound` 是同一个归纳，只在标出的步乘以 1 + M（`Frequency.step_eq`）。条件全部列出时，有耦合作用的步（`Frequency.coupling`：进入某个列出条件的强度为正之步）就是这样的时程（`Frequency.quiet_coupling`、`carried_le_coupling`）。一个条件以强度 M 在任一时程的步上把水平送回自身（`Frequency.SelfLoop.strengths`），恰在标出的步耦合（`Frequency.SelfLoop.couplesAt_iff`），恰好携带 D·(1 + M)^a（`Frequency.SelfLoop.carried_eq`）：从 D、M 与耦合作用的步推不出更小的界。经 `most_difference_arrives`（`gap_le_carried`），这个速度约束每个有这些强度的律、每两个平衡的流之差（`gap_le_count`）。

**二、失控要的是频繁，不是强。** 一个耦合在第 u 步读 d 在第 s 步的水平进入 c 时，c 处所携带的量跨这一步至少增加 d 在第 s 步所携带的（`carried_step_ge_at`；P118 的 `carried_step_ge` 只读当前的水平）。按时间次序的链（`ChainInTime`：第一个耦合读第 T 步起的水平，其后每个读前一个作用之后的水平）把到达其起点者带到终点（`carried_along_in_time`）；返回（`Returns`）是从一个条件回到它的这种链。每次返回至少使到达者加倍：它一次保持着、一次绕回路到达，因为正的强度至少是一（`carried_doubles_return`）；R 次相继的返回至少乘以 2^R（`carried_returns`）。所以到达者为正、返回在第 T i 步、2^i 超过 T i 的每个多项式时，能到达的最大差别没有多项式界，不论强度（`runaway_of_returns`）。反之，2^a 至多是 A·(t + 1)^n 时，所携带的量至多是 D·A^M·(t + 1)^(nM)，不论强度（`carried_le_of_rare`，由 1 + M ≤ 2^M）。在自环处两界相遇：强度与起始之差为正时，它有多项式界恰在 2^a 有多项式界处，不论其强度（`Frequency.SelfLoop.polynomial_iff`）。多常决定增长是否是多项式；多强只定次数。

**三、复现耦合的回路不一定失控。** 稀疏的时程（`Frequency.Sparse.on`）标出比 2 的幂少一的步：0、1、3、7、……。第 u 步之前它标出 c 步，u + 1 ≤ 2^c ≤ 2u + 1（`Frequency.Sparse.bounds`），所以 2^a ≤ 2(t + 1)（`Frequency.Sparse.rare`）。它的计数无界，所以标出的步要多晚有多晚（`Frequency.Sparse.unbounded`、`Frequency.Sparse.often`；由 `Frequency.recurs_of_unbounded`：计数越过第 N 步的计数时，第 N 步起有一步被标出）。在这些步以正的强度耦合的自环复现（`Frequency.Sparse.recurs`），所以从正的起始，每个有限阶都有所漏（`Frequency.Sparse.inexact`，由 P120 的 `carriedWithin_lt_of_recurring_loop`）；所携带的量却至多是 D·2^M·(t + 1)^M（`Frequency.Sparse.polynomial`）。

**四、安定是局部的。** 耦合到第 N 步停止（`StopsBy`），是说它的耦合都不读第 N 步起的水平；停止的耦合不复现（`StopsBy.not_recurs`），且到每个更晚的步都停止（`StopsBy.mono`）。条件全部列出、每个耦合复现或到某步停止时，时程到某步已安定（`settled_of_each`）：列出的有限多对条件的界相加（`Frequency.bound_list`）。

**五、每个时程都安定，恰是一个推理原则。** 第 m 步一个耦合是否读第 n 步起 d 的水平进入 c，是判定的（`Frequency.readsLate` 是一个布尔值；`Frequency.couplesAt_of_readsLate`、`Frequency.readsLate_of_couplesAt`）。所以给定二分 `RecursOrStops`（对每个判定的二元族，每行在某处为真，或某行处处为假），条件全部列出时每个耦合复现或停止（`recurs_or_stops`），每个时程都安定（`settled_of_recursOrStops`）。反过来，一个条件回到自身的每个时程都安定，恰是这一二分（`settled_iff_recursOrStops`），于是对条件全部列出的每个世界的每个时程亦然（`settled_every_iff`）。证明用两个时程。一个在判定的序列 q 第一次为真之步耦合（`Frequency.First.strengths`，用 `Becoming.Change` 的 `clear`）：它至多耦合一次（`Frequency.First.once`），不复现（`Frequency.First.not_recurs`），它安定时 q 某处为真或处处为假（`Frequency.First.decides`）；所以这些只耦合一次的时程都安定，就给出有限全知原则 `LPO`（`lpo_of_settled`）。另一个在第 s 步之后、到第 s 行的每行都已在某处为真之步，读第 s 步的水平（`Frequency.Rows.strengths`）：它的耦合复现，恰在每行都在某处为真处（`Frequency.Rows.recurs_iff`）。它到第 N 步安定时，`LPO` 判定到第 N 行的各行（`Frequency.Rows.decide_rows`）：或者某行处处为假；或者到第 N 行都在某处为真，这时有耦合读第 N 步的水平，安定使它复现，于是每行都在某处为真。二分给出 `LPO`（`RecursOrStops.lpo`）。

**六、实例与每个律。** `Becoming.Loops` 的自环是每步耦合者，携带 D·(1 + M)^t（`Frequency.SelfLoop.always`、`Frequency.SelfLoop.always_carried`）；`Becoming.Closing` 在第 T 步形成的回路是自 T 起每步耦合者，在 T + r 携带 D·2^r（`Frequency.SelfLoop.onset`、`Frequency.SelfLoop.onset_amount`，即 `Closing.Onset.amount_after`）。

```lean
theorem carried_le_count {M D : Nat} {on : Nat → Bool} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M)
    (quiet : ∀ t c, on t = false → inflow cs part k present t c = 0) :
    ∀ t c, carried cs part (fun _ _ _ => 0) k present δ t c ≤
      D * (1 + M) ^ Frequency.count on t

theorem carried_doubles_return {e : C} {T T' : Nat} (back : Returns cs part k present e T T') :
    carried cs part σ k present δ T e + carried cs part σ k present δ T e ≤
      carried cs part σ k present δ T' e

theorem settled_iff_recursOrStops :
    (∀ k : Nat → Unit → Unit → Nat → Unit → Nat,
        ∃ N, SettledFrom [()] (fun _ => false) k (fun _ => [()]) N) ↔ RecursOrStops
```

**读法（AI 的，待 Ren）。**
1. **速度由频度定。** Ren 问回路能算得多准、有无损失。能到达的最大差别的增长至多是 D 乘 1 + M 的有耦合作用的步数次幂，并且达到。失控由耦合多常作用定，不由多强定：回路每次返回至少使到达者加倍，所以返回足够频繁的回路不论强度都失控；只按对数频度作用的回路不论强度都停在多项式，强度只定次数。
2. **只在某些步耦合的情形，两个方向都已关闭。** Ren 2026-10-16 称 AI 对“只有回路使差别失控”的读法是对的；那一读法把只在某些步成立的耦合留为开放。只有继续着的耦合的回路能使能到达的最大差别失控（`carried_le_polynomial_from`，P120）；这样的回路不一定失控（`Frequency.Sparse`），返回足够频繁时失控（`runaway_of_returns`）。对自环，耦合多常作用恰好决定。
3. **安定是推理原则，不是展开的事实。** 每个时程是否都安定，理论不能对展开断言或否认：它等价于一个关于判定序列的推理原则，“每行在某处，或某行处处没有”，它给出有限全知原则。所以定理在需要处把安定的时程作为前提写入；每个耦合复现或停止时，安定是局部的、有限的。

**作者反审。**
1. **新律还是重述？** 上界 D·(1 + M)^a 是 P118 的几何之界换成只在作用之步计数，证明是同一个归纳。新的是：（a）它对任意时程成立，并由自环恰好达到，所以是这些数据下的确切之界；（b）下界按按时间次序的返回计，每次至少加倍，与强度无关；（c）两者合起来，使“失控由频度定”对自环成为当且仅当。
2. **“不论强度”的范围。** 自然数的量中正的强度至少是一，所以每次返回至少加倍。实数的量中正的强度可以小于一，每次返回乘以一加回路上强度之积；收缩够快的强度可使频繁的返回不失控。这里不推出，模块的“不推出”中已写。
3. **稀疏的见证的选择。** 比 2 的幂少一的步是对数频度的最简单情形。界的次数 M 并不紧（实际增长约为 t 的 log₂(1 + M) 次幂），只用作多项式之界。
4. **二分的强度。** `RecursOrStops` 的形式是“每行某处为真，或某行处处为假”（算术层级中的 Σ⁰₂）；这里证明它与每个时程都安定等价，并给出 `LPO`。它在排中律与 `LPO` 之间的更细位置属于构造性的反推数学，这里不陈述。
5. **范围。** 离散的步、自然数的量；强度与时程是给出的；自环之外，能到达的最大差别是否达到按返回的下界或按耦合步数的上界，没有陈述。不含伦理谓词。

## 159. 观察是从所观察者出发的路线：差别只往下游去（Becoming.Observation）

2026-10-16。P124 留下“一个形成怎样开始观察它所依赖的储量”（loops-within-what-a-law-reads 与 runaway-distance-unregistered 的 next_delta；`Becoming.Runaway` 中观察 `obs` 是给出的）。Ren 对 P124 的做法答：“approve your approach, please continue”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-16-thresholds-approach-approved.md)）；AI 读为认可做法、继续这一项。本节在第一部分之内回答：不加公理，除各定理所写者不加前提。工作板上认领为 P125。

```text
Result(s): 新增 observation-is-a-route；回答 loops-within-what-a-law-reads 与 runaway-distance-unregistered 的 next_delta 中
           “一个形成怎样开始观察它所依赖的储量”；复用 how-much-difference-arrives（Conveyed、carried、carried_pos_iff、
           RespondsWithin、exchangeGap、gap、gap_eq_zero_iff）、how-a-carried-difference-grows（Couples、Coupled、OnLoop、
           Upstream、Loops.beq_self）、what-a-cut-loses（CouplesAt）、how-loops-form（strengthsBefore、couples_before_iff、
           couples_before_mono、couples_before_of_couplesAt、Upstream.lift、Upstream.refl、Closing.join、Coupled.append、
           Coupled.one、Closing.split、onLoop_of_closing）、loops-within-what-a-law-reads（ExchangeLaw.ReadsAt、
           ExchangeLaw.Through.readsAt、held_while、Thresholds.same_step）、counterfactual-is-the-course（ExchangeLaw、
           Through、Follows、ActsAlike）
Delta: 新核心模块 Becoming.Observation（导入 Thresholds；27 项定理／32 项声明）；Becoming.Thresholds 只改一个名字
       （Thresholds.le_of_not_lt 改为 Thresholds.le_of_not_not，陈述与证明不变）与模块说明中读法的状态
Supplied premises / correspondence: 不加公理；各定理所写者写在定理中：律读入每个条件的时程（ReadsInto），所读的水平列出；
       起始之差只在储量上、部分不给差；两个进程平衡、在场的形成相同、部分动作相同、其余遵从律
Evidence: scratch_build 对 main ed704543：Becoming.Observation 27 项定理、32 项声明，Becoming.Thresholds 38 项定理、45 项声明，
          公理报告全部为空，无警告；合并检查器回执待整合者的运行
Boundary: 离散的步、自然数的量；律读什么、量度何时开始是给出的；只说不在下游者相同，不说在下游者必不同（读而不回应）；
          带误差的量度、他者的识作为路线未单独陈述；不含伦理谓词
Integration: §2 新增一段；第一部分的总陈述一条；§8 进一步证明一项；§9 新增一行；术语表两行；Becoming.lean 的导入与模块
       说明；check_becoming.py 的核心之列与范围说明；Lean README 一行与层内导入；一项新记录与两项配对说明
```

**一、差别只往下游去。** 起始之差只在储量 c 为正、部分不给差时，在第 t 步被传到的条件都在 c 的下游，按到 t 为止形成的耦合（`conveyed_upstream`，对 P115 的 `Conveyed` 归纳：起始在 c 自身；保持由形成单调，`Upstream.before_mono`；部分的输入为零；回应把链加长一个耦合，`Upstream.snoc`）。所以所携带的量，即能到达的最多的差，在不在下游之处为零（`carried_zero_off_downstream`，由 `carried_pos_iff`）。链可接（`Upstream.single`、`Upstream.trans`）。

**二、读入每个条件。** 一个律读入每个条件一个时程（`ExchangeLaw.ReadsInto`），是说部分之外的每个形成与一个条件的交换，只由时程为那个条件所标的水平决定。`Becoming.Thresholds` 的读一个时程是它的特例：对所有条件读得一样（`ExchangeLaw.ReadsAt.readsInto`），所以经识而读的律也是（`ExchangeLaw.Through.readsInto`）。读入一个条件时未读的水平耦合强度为零（`ExchangeLaw.ReadsInto.respondsWithin_unread`），所以限于所读的强度（`restrictInto`）是律的强度（`ExchangeLaw.ReadsInto.restrict`），其路线都是所读的路线（`readCouplings`：所标之处为一；`couplesAt_readCouplings`、`upstream_readCouplings`）。

**三、所识即在下游。** 对每个读入每个条件一个时程、所读水平列出的律：两个平衡的进程，在场的形成相同、部分动作相同、其余遵从律，起始只在 c 上不同，那么在每一步，凡不在 c 下游（按到那一步形成的所读路线）的条件，两个进程都相同（`apart_only_downstream`，对步归纳：在 t + 1 不在下游者在 t 也不在；它的每个交换所读的水平若在下游，读它的耦合就把它接到下游，矛盾；不需判定条件，也不需条件有限）。所以一个形成与一个条件的交换，凡它在那一步读入的水平都不在下游，在两个进程中就相同（`exchange_alike_off_downstream`）；经识而读的律，凡它所识者都不在下游，它的交换就相同（`ExchangeLaw.Through.alike_off_downstream`）。它所观察的储量在自身的下游，长度为零的路线；它所识的其他条件只经一条所读的路线在下游。

```lean
theorem apart_only_downstream (r : law.ReadsInto part reads)
    (listed : ∀ t h e s d, reads t h e s d = true → d ∈ cs)
    (balances : L.Balances W) (balances' : L'.Balances W')
    (present : ∀ t, L.present t = L'.present t) (acts : L.ActsAlike L' part)
    (follows : L.Follows law part W.level) (follows' : L'.Follows law part W'.level)
    {c : C} (others : ∀ e, e ≠ c → W.level 0 e = W'.level 0 e) :
    ∀ t e, ¬ Upstream cs part (strengthsBefore t (readCouplings reads)) L.present c e →
      W.level t e = W'.level t e
```

**四、路线由闭合而形成。** 到 T + 1 形成的从 c 出发的路线，是到 T 形成的路线，与经过一个在第 T 步作用的耦合者：从一条从 c 到某个水平 d 的路线，经那个耦合到 d'，再从 d' 继续（`upstream_succ_iff`、`route_forms_by_closing`），如 `Becoming.Closing` 中回路的形成。

**五、量度的见证。** 一个形成既量度又汲取（`Observation.Measure.law`）：从第 T 步起每步把储量（`true`）的水平加到记录（`false`）上；每步在记录显示至少 N 时从储量汲取一个单位。它读入储量的只是那一步的记录，读入记录的只是从 T 起那一步的储量（`Measure.reads`、`Measure.readsInto`、`Measure.listed`）。T 之前没有读储量者（`Measure.no_coupling_from_stock`），储量下游只有它自己，没有经过它的回路（`Measure.downstream_before`、`Measure.no_loop_before`）；在第 T 步从储量到记录的路线形成（`Measure.route_at`；汲取每步读记录，`Measure.record_into_stock`），储量 → 记录 → 汲取的回路随之形成（`Measure.loop_at`）。两个只在储量上不同的进程，记录到 T 为止相同、储量高 d，跨过第 T 步记录多升 d（`Measure.registers_after`）；汲取回应记录（`Measure.draw_responds`）：抬高经记录被识，不涉储量的任何阈值。

**读法（AI 的，待 Ren）。**
1. **观察不是依赖之外的第二种关系。** 观察一个储量，就是站在从它出发的一条所读路线的末端：直接观察是长度为零的路线，量度、模型或他者之识是更长的路线。一个形成开始观察它原先不观察者，是一次读闭合一条路线，在某一步，如回路闭合。`Becoming.Runaway` 中给出的 `obs` 在这里是这条路线本身。
2. **能识断裂还有多远者，是在断裂之前闭合的路线。** P124 的第二项读法（Ren 同日取）说能识距离者是断裂之前对储量水平的读；这里它是一条路线：记录在量度开始之步形成，经过储量的回路随之形成，可以在断裂之前。

**作者反审。**
1. **新律还是重述？** 差别只沿耦合传，在所携带的量的定义里已有；新的是：（a）对每个读入每个条件的律，在实际的进程上陈述，不经所携带的量，不判定条件、不需条件有限（只需所读者列出）；（b）`Becoming.Runaway` 的 `obs` 不是原始的：一个形成的交换回应储量之差，只经从储量到它所读之处的路线；（c）路线的形成与回路的形成同形。
2. **为什么另立 ReadsInto。** `ExchangeLaw.ReadsAt` 按形成读，不分它与哪个条件交换：一个读储量的形成可以改变它与任何条件的交换，路线就没有方向。`ExchangeLaw.ReadsInto` 细化它（`ExchangeLaw.ReadsAt.readsInto`），不另立平行的定义；强度的路线在所读的路线之内（`upstream_readCouplings`），反之不然：读而强度为零。
3. **为什么进程的定理不用强度陈述。** 由强度界一个在多处不同的历史之差，要逐处换历史，需要判定条件的相等与有限多处（`gap_le_carried` 用 `DecidableEq`）。所以对进程的定理用读的时程，对所携带的量的定理用强度（`conveyed_upstream`），两者都不判定条件。
4. **只一个方向。** 不在下游者相同；在下游者不必不同：一个形成可以读而不回应。见证给出在下游者实际不同（`Measure.registers_after`）。
5. **范围。** 离散的步、自然数的量；律读什么、量度何时开始、记录是否及时被读是给出的；带误差的量度未陈述。不含伦理谓词。

## 160. 整体而无部分之律所需：最小的识之反例的确切强度（Becoming.Tail）

2026-10-16。P113（`Becoming.Sensitivity`，§137）表明：律在每个历史下读有限多个条件时，无论条件多少，敏感都是它所经的最小的识；条件无穷多时这一条件不能去掉：给定水平是否终将消失的判定（它给出有限全知原则），尾之律是反例；条件以自然数编号时，每个反例都给出弱有限全知原则。它留下反例之存在的确切强度，在弱有限全知原则与消失之判定之间（[sensitivity-is-the-least-registration](../../../../theories/becoming/results/records/sensitivity-is-the-least-coupling.md) 的下一步首项；第 8 节“反馈与所及”）。Ren 2026-10-12 的目标：“move towards 100%, you can spawn a few agents for help, pick the "What would move it most next" first, and don't stop until we are 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）。本节回答此项，在第一部分之内：不加公理，除各定理所写者不加前提，按 Ren 2026-10-11 的先求零前提（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)）。工作板上认领为 P126。

```text
Result(s): 新增 what-a-law-of-the-whole-and-no-part-takes；回答 sensitivity-is-the-least-registration 的 next_delta
           首项（反例之存在的确切强度）；复用 sensitivity-is-the-least-registration（VanishFrom、VanishFrom.of_agree、
           vanishIndicator 与其引理、tailLaw、WLPO、seenBy 与其引理、alike_of_agree_from、
           alike_of_agree_from_sensitive、Sensitivity.cond_either、ExchangeLaw.ReadsFinitely 与其
           alike_of_insensitive）；counterfactual-is-the-course（ExchangeLaw、GivesAlike、Nonanticipating、
           InsensitiveAt、Sensitive、Through）；coming-and-ceasing-keep-pace（LPO）
Delta: 新核心模块 Becoming.Tail（导入 Sensitivity；39 项定理／53 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；规则（对每个布尔序列判定它是否处处为假，或是否有真者）与消失之判定
       在用到处作为假设写入，不假定；全知的定理以自然数为条件编号
Evidence: scratch_build：Becoming.Tail 39 项定理、53 项声明，公理报告全部为空，无警告，根模块连同 125 个模块的闭包编译；
          合并检查器回执待整合者的运行
Boundary: 条件以自然数编号；命题 WLPO 是否给出规则、弱的规则是否给出有限全知原则、条件不编号时反例给出什么，没有
          陈述；不含伦理谓词
Integration: §2 新增一段，“回应由动力学给出”段加一句；第一部分的总陈述一条；§8 状态与进一步证明；§9 新增一行；
       术语表两行；Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列与范围说明；Lean README 一行与层内
       导入；可判定性清单（四个以规则为参数的指示之定义；WLPO.of_rule、LPO.of_rule 只在证明中
       分情形）；一项新记录与一项配对说明
```

**一、整体而无部分。** 从水平读出的一个数 f，只在一个条件上不同的水平给出相同的 f 时，说没有一个条件改变它（`ChangedByNoCondition`）。这恰是从某个条件起相同的水平给出相同的 f：其下的条件一次换一个（`ChangedByNoCondition.eq_of_agree_from`）；反向是因为只在 c 上不同的水平从 c + 1 起相同（`ChangedByNoCondition.of_agree_from`）。没有部分改变的，只由尾所定。整体之律（`wholeLaw f`）在每步与每个条件交换水平在第 0 步的 f，什么也不给。f 不被任何条件改变时，它读已立者（`wholeLaw_nonanticipating`），在每步不敏感于每个条件（`wholeLaw_insensitive`），所以不敏感于任何条件（`wholeLaw_not_sensitive`），且经从任一条件起的各条件而读（`wholeLaw_reads_from`、`wholeLaw_through_from`）。f 在两个水平之间不同时，它不经其敏感而读（`wholeLaw_not_through_sensitive`），不读有限多个条件（`wholeLaw_not_readsFinitely`），它所经的识没有最小的（`wholeLaw_no_least_registration`）。P113 的尾之律就是消失之指示的整体之律（`tailLaw_eq_wholeLaw`，按定义成立；`vanishIndicator_changedByNoCondition`）。

**二、反例给出规则。** P113 沿一个布尔序列 s 混合两段历史，第二段从 s 的第一个真者起接手，再比较混合的历史与第一段历史所给的两个数（`mixed_decides`）。比较数是判定的，所以这一比较对每个 s 给出的不只是“s 处处为假或不然”，而是判定它的规则（`mixedDecision`）。在某步不敏感于每个条件而仍有差别的律（`insensitiveDiffersDecision`），与最小的识的每个反例（读已立者，两段历史在其所敏感的每个条件上到那步都相同，在那步给出不同；`notThroughSensitiveDecision`），各给出一个规则，对每个布尔序列判定它是否处处为假。规则给出 `WLPO`（`WLPO.of_rule`）。

**三、规则给出反例。** 给定这样的规则，水平 α 从第 N 个条件起是否消失可判定：从 N 起每个水平是否大于 0 构成一个布尔序列（`Tail.levelsFrom`），规则判定它是否处处为假（`vanishesFrom`）。水平从哪个条件起都不消失，恰是这些回答处处为假（`vanishesFrom_never_iff`），规则再判定一次（`neverIndicator`：永不消失处为 1，不然为 0）。这个指示不被任何条件改变（`neverIndicator_changedByNoCondition`），在全为 0 与全为 1 的水平之间不同（`neverIndicator_zeros`、`neverIndicator_ones`）；也给定消失之判定时，两个指示之和为 1（`neverIndicator_add_vanishIndicator`）：同一个整体，从另一面读。它的整体之律（`neverLaw`）读已立者，在每步不敏感于每个条件，而仍有差别（`neverLaw_nonanticipating`、`neverLaw_insensitive`、`neverLaw_not_sensitive`、`neverLaw_differs`）：一个只由规则造出的反例。

**四、恰好。** 不被任何条件改变而仍有差别的数、在某步不敏感于每个条件而仍有差别的律、最小的识的反例，各恰在这样的规则存在之处存在（`changedByNoCondition_iff_rule`、`insensitive_differs_iff_rule`、`not_through_sensitive_iff_rule`）。

**五、消失之判定恰是有限全知原则作为规则。** 消失之判定给出一个规则，对每个布尔序列判定它是否有真者：在第一个真者之前为 1、自它起为 0 的水平，恰在有真者处消失（`lpoRuleOfVanishDecision`，P113 的 `lpo_of_vanish_decided` 的数据形式）。反之，这样的规则分两次判定消失：对每个 N 判定从 N 起是否有水平大于 0（`raisedFrom`），再判定是否有某个 N 的回答为否（`vanishDecisionOfLPORule`）。所以两者恰在同处存在（`vanishDecision_iff_lpoRule`）。这个规则给出弱的规则（`wlpoRuleOfLPORule`）与 `LPO`（`LPO.of_rule`）。尾之律所取的是有限全知原则作为规则，整体而无部分之律只需要弱的。

```lean
theorem not_through_sensitive_iff_rule :
    (∃ (F : Type) (law : ExchangeLaw F Nat) (t : Nat) (h : F) (l l' : Nat → Nat → Nat) (c : Nat),
      law.Nonanticipating ∧ (∀ e, law.Sensitive h e → ∀ s, s ≤ t → l s e = l' s e) ∧
        ¬ (law.take t h l c = law.take t h l' c ∧ law.give t h l c = law.give t h l' c)) ↔
      Nonempty (∀ s : Nat → Bool, Decidable (∀ n, s n = false))

theorem changedByNoCondition_iff_rule :
    (∃ f : (Nat → Nat) → Nat, ChangedByNoCondition f ∧ ∃ α β, f α ≠ f β) ↔
      Nonempty (∀ s : Nat → Bool, Decidable (∀ n, s n = false))

theorem vanishDecision_iff_lpoRule :
    Nonempty (∀ α : Nat → Nat, Decidable (VanishFrom α)) ↔
      Nonempty (∀ s : Nat → Bool, Decidable (∃ n, s n = true))
```

**读法（AI 的，待 Ren）。**
1. **整体而无部分恰需判定无尽的是非记录是否全否。** 依存于整体而不依存于其任何部分者，恰在能对每个无尽的是非记录判定它是否全是否之处给出：每个这样的整体都给出这一判定，这一判定也造出一个。条件编号时，最小的识恰在这一全知处不成立，不需要更多；核心不假定它。
2. **从“永不”读只需要弱的规则。** 读作水平是否终将消失，整体需要有限全知原则作为规则；读作水平是否永不消失，同一个整体分开同样的历史，只需要弱的规则。在这里，经由永不发生者说的整体，只由弱的规则给出。

**作者反审。**
1. **新律还是重述？** 反例给出规则，是 P113 的混合论证读作数据：比较两个数是判定的，P113 只取了它的命题形式。新的是：（a）反向：只由规则造出反例（永不消失之律），所以规则也是充分的；（b）三个当且仅当，以及“不被任何条件改变”与“只由尾所定”的等价；（c）尾之律的确切位置：消失之判定恰是有限全知原则作为规则，经两次判定。
2. **规则与命题。** 当且仅当说的是规则（对每个序列给出判定的函数），不是命题 `WLPO`（每个序列处处为假或不然）。规则给出命题（`WLPO.of_rule`）；命题给出规则需要从关系选出函数，核心不假定这一选择原则。所以确切强度以规则陈述；在经典逻辑中两者都成立，没有分别。
3. **弱与强是否真的不同。** 弱的规则是否给出有限全知原则的规则，这里不陈述；所以“尾之律取有限全知原则作为规则，反例只需要弱的”只说两者各是什么，不说后者严格较弱。
4. **编号的作用。** 混合沿自然数的次序进行；条件不以自然数编号时反例给出什么，不陈述。
5. **范围。** 离散的步；条件以自然数编号；不含伦理谓词。

## 161. 运行在何处延续：有限多配置之内运行是通向返回的路径，一般地是依赖选择（Becoming.Onward）

2026-10-16。P81（`Becoming.Branching`，§99）对每个过程陈述返回：不合并在有限多配置之内沿运行给返回，沿运行不上升，不返回而不合并者需要开放。这些沿运行的定律以运行为给定；从每个能动的配置造出运行要在每步取一个延续，即一种选取（[returning-where-the-course-branches](../../../../theories/becoming/results/records/returning-where-the-course-branches.md) 的下一步：“对每个能动的配置不加选择地陈述沿运行的定律（例如对有限的、可判定的过程）”；第 8 节“路径分支时”：“从每个能动的配置出发的运行是否需要选择之外的条件”）。`Becoming.Lasting` 的 lifting 在有限分支下经 `EitherThroughout` 与无界后继的选取给出运行，并把“没有选取的运行（依赖选择之界）”留作下一步（[lifting-where-branching-is-finite](../../../../theories/becoming/results/records/lifting-where-branching-is-finite.md)）。Ren 2026-10-12 的目标：“move towards 100%, you can spawn a few agents for help, pick the "What would move it most next" first, and don't stop until we are 100%”（[来源](../../../../sources/15-codex-theory-conversations/2026-10-12-move-towards-100.md)）。本节回答这两项，在第一部分之内：不加公理，除各定理所写者不加前提，按 Ren 2026-10-11 的先求零前提（[来源](../../../../sources/15-codex-theory-conversations/2026-10-11-zero-premise-laws.md)）。工作板上认领为 P127。

```text
Result(s): 新增 where-a-run-goes-on；回答 returning-where-the-course-branches 的 next_delta 与
           lifting-where-branching-is-finite 的 next_delta 第二项（没有选取的运行）；复用
           returning-where-the-course-branches（Returns、Lossless、Returns.run、Lossless.returns、Lossless.no_rise）；
           lifting-where-branching-is-finite（Continues、Continues.decided、Unbounded、FinitelyBranching、runOf、
           runOf_within、Fan）；identification-where-runs-part（path_of_continues、and_both、and_of）；
           recurrence-without-premise（revisits_within、gap_of_lt）；Frame（Run、Reach）、Horizon（Run.cons）、
           Decidedness（Decided）
Delta: 新核心模块 Becoming.Onward（导入 Parting；28 项定理／40 项声明）；不改已有模块
Supplied premises / correspondence: 不加公理；列出全部配置的列表、后继的列表、测试与枚举、步与族的判定在用到处作为假设
       写入，不假定；依赖选择作为命题陈述，不假定
Evidence: scratch_build：Becoming.Onward 28 项定理、40 项声明，公理报告全部为空，无警告，根模块连同其闭包编译；
          合并检查器回执待整合者的运行
Boundary: 离散的步；核心是否给出依赖选择没有陈述；有限分支而不搜索时沿无界配置的运行由 Lasting 经 EitherThroughout 与
          选取给出，这里不重述；不列出配置时沿运行的定律没有陈述；不含伦理谓词
Integration: §2“路径分支时”段改一句并新增一段；第一部分的总陈述一条；§8 状态与进一步证明；§9 新增一行；术语表两行；
       Becoming.lean 的导入与模块说明；check_becoming.py 的核心之列与范围说明；Lean README 一行与层内导入；可判定性清单
       （decidedTest 作为已定命题的指示）；一项新记录与两项配对说明
```

**一、有限多配置之内，运行是通向返回的路径。** 从运行的每个配置开始每个长度的路径，运行的每个配置可从其起点得到（`continues_of_run`、`unbounded_of_run`、`reach_of_run`）。从路径通向之处有运行，前接这段路径就是从路径起点出发的运行（`run_of_trace`、`run_of_reach`）；从路径通向返回者之处，`Branching.Returns.run` 绕返回而行，前接路径即得运行（`run_of_returning`）。列表持有全部配置时，与列表一样长的路径重复一个配置（`revisits_within`），被重复者返回，路径通向它（`reach_along`、`returning_of_continues`）。所以运行恰在与列表一样长的路径开始处开始，恰在每个长度的路径都开始处，恰在路径通向返回者处（`run_of_continues`、`run_iff_continues`、`run_iff_unbounded`、`run_iff_returning`）。不用判定，也不用选取：结论是存在，路径与返回都是在证明里拆开的存在。后继也列出时，路径的深度已定（`Lasting.Continues.decided`），所以运行是否开始已定（`run_decided`）。分支无穷时，每个长度的路径不给出运行：`Lasting.Fan` 的根有每个长度的路径，没有运行（`fan_no_run`）。

**二、保持运动的族。** 一族保持运动，指从每个成员有一步通向成员（`KeepsMoving`）；族内的步构成一个过程（`within`），其运行是原过程留在族中的运行（`ofWithin`、`ofWithin_within`）。从成员开始的每个长度的路径都留在族中（`KeepsMoving.continues`），所以有限多配置之内，运行从每个成员开始并留在族中（`KeepsMoving.run`）。整个过程每个配置都能动，是族取全体的情形。

**三、沿运行的定律，不给定运行。** 不合并、有限多配置之内：配置恰在与列表一样长的路径从它开始处返回（`lossless_returns_iff`，`Branching.Lossless.returns` 不给定运行），所以保持运动的族的每个成员都返回（`KeepsMoving.returns`）；在族中跨步不下降的量在族中每步保持不变（`lossless_no_rise`，`Branching.Lossless.no_rise`），所以族中的上升需要合并（`rise_needs_merge`，`Branching.rise_not_lossless`）；每个长度的路径都开始而不返回者需要开放（`lossless_unlisted`，`Branching.Lossless.unlisted`）。这回答 returning-where-the-course-branches 的下一步，比它所举的例子更强：有限即可，不需要可判定。

**四、搜索的移动。** 配置不受界时，设一个测试在枚举的移动中认出留在族中的一步：通过者就是这样的一步，有这样的一步时某个枚举的移动通过（`Finds`）。在有某处通过时，搜索从 0 起逐个测试，直到通过，经可达性（`Acc`）递归，不需要燃料，也不用公理（`Later`、`searchFrom`、`acc_below`、`search`）。每步这样取（`searchedStep`），经 `Lasting.runOf` 得到运行，作为数据：它从成员开始并留在族中（`searchedRun`、`searchedRun_start`、`searchedRun_within`）。步与族已定、每步的移动在枚举中出现时，逐个测试就是这样的测试（`decidedTest`、`decidedTest_finds`）。所以可数多移动且步已定时，运行不需要选取。

**五、一般地：依赖选择。** 对每个过程要求“从每个保持运动的族的每个成员出发都有留在族中的运行”，恰是依赖选择：全的关系从每个起点有沿它的序列（`DependentSelection`、`runs_iff_selection`）。一个方向取只有一个移动的过程；另一方向把移动连同配置记入关系的项（`moveOf`、`moveOf_eq`）。

```lean
theorem run_iff_returning {all : List S} (every : ∀ x, x ∈ all) {s : S} :
    (∃ r : Run P, r.state 0 = s) ↔ ∃ t, Reach P s t ∧ Branching.Returns P t

theorem lossless_returns_iff (lossless : Branching.Lossless P) {all : List S}
    (every : ∀ x, x ∈ all) {s : S} :
    Branching.Returns P s ↔ Lasting.Continues P all.length s

theorem runs_iff_selection :
    (∀ (S A : Type) (P : Process S A) (K : S → Prop), KeepsMoving P K →
      ∀ s, K s → ∃ r : Run P, r.state 0 = s ∧ ∀ n, K (r.state n)) ↔ DependentSelection
```

**读法（AI 的，待 Ren）。**
1. **有限之内，延续靠回转。** 有限多配置之内，无尽地进行者靠回转而进行：路径本身显出它在何处返回，运行绕那里而行。不需选取，也不需判定；延续从展开读出。
2. **不受界时，延续在能搜索处给出。** 配置不受界时，无尽的进行在能搜索移动之处给出；对每个过程要求每个能继续运动的配置都开始一个运行，恰是依赖选择。

**作者反审。**
1. **新律还是重述？** `Branching.Returns.run` 已给出返回者的运行，`Parting.unbounded_of_continues` 已给出有限世界中长路径给出每个长度的路径，`Lasting.runOf` 已给出选取给出运行。新的是：（a）有限多配置之内运行的存在，没有选取、没有判定，以及运行的三个当且仅当（与列表一样长的路径、每个长度的路径、通向返回者的路径）；（b）沿运行的定律不给定运行的陈述（`lossless_returns_iff` 等），回答 P81 的下一步；（c）搜索给出的运行作为数据，以及依赖选择的确切位置。（c）的后一部分在数学上是标准的：依赖选择即对全的关系有序列，这里只是以过程与族陈述，没有新的数学内容，但它说出了“从每个能动的配置出发的运行”所需的恰是什么。
2. **选取与依赖选择的名称。** 核心名 `DependentSelection` 沿 `Lasting` 的“选取”（select）；标准名依赖选择只在读法与说明中用。选取不是一个选取者：它是每步取一个延续的函数，是否存在是这里的问题。
3. **搜索与可计算。** `search` 经 `Acc.rec` 递归，在纯核心中可编译、公理报告为空；它在有通过者处终止，那个存在只用于造出可达性的证明。这与 `Lasting.lifting` 不同：那里要选取的是无界的后继，无界不可测试。
4. **范围。** 离散的步；有限世界的定理要求一个列出全部配置的列表；搜索要求测试与枚举；依赖选择是否在核心中成立没有陈述（需要核心之外的模型）。不含伦理谓词。

## 162. 第二部分折叠进第一部分：一个条件小节（P128）

2026-10-16。Ren 问：“does part II really needed or are they just the generative part of part I?”，随后定：把第二部分折叠进第一部分，作为生成的空间之后的一个条件小节，保留等价定理，并指名不变的一步（[原话与语境](../../../../sources/15-codex-theory-conversations/2026-10-16-fold-part-ii.md)；所发回复的文字由 AI 起草，Ren 选定发送）。此前第二部分在 Ren 2026-10-11 的移动之后只断言一条公理（§69 的清点，P52）。

```text
Result(s): 不新增成果；复用 one-axiom-yields-g0、comparison-by-widening、four-cases-of-a-part、
           closure-verdict-meets-axiom、metaethical-core-characterization（§6.11 的分解，Becoming.Boundaries）
Delta: 结构与地位：理论不再断言那一条公理；它成为章节 §6.15 的条件。§6.15 收入原第二部分的内容（条件所定下的），
       前置三条等价（Web.widens_iff_retains_adds、Web.keeps_iff_retains、Web.mixed_iff_adds），
       并指名不变的一步（unrestricted_iff_presupposed_along、boundaryInvariant_iff_conditional、boundaryInvariant_iff_all）
Supplied premises / correspondence: 那一条公理只作为条件；A、C、L、J1–J4 仍公开；不加前提
Evidence: 不改 Lean 陈述与证明；所引定理名逐一在源中核对；章节、开篇脚注、目标记录、八条记录的现行字段与指令登记改写
Boundary: 条件之下意义处处相同，所以每次缩小都失去有意义者（捕食、凋亡、终止一个癌）；混合部分的定序需要度量；
          余量之界对任何意义成立（算术），条件只使它覆盖每个形成；“C 是规律”相对于把“更好”读作扩大；
          Web.significance_undetermined 说意义是自由参数，不说条件“必需”；条件的根据开放
Integration: 章节一句话、两个目标、完整陈述、前提卡、第一部分引言、§5、§6 引言、§6.12–§6.13、新 §6.15、
             第一部分的总陈述、§7（加“在什么之下”）、§8、§9、术语表；OPENING 两个脚注（另修 World.rests_enclosed
             为 World.rests_unrefuted_enclosed，同步审查会话的发现）；四个 Lean 文档注释留给下一次核心检查（审查会话 R18）
```

**为什么折叠。** 生成的空间已不用公理陈述（§6.13，P56）：扩大、保持不变与混合是规律，余量之界确切，把“更好”读作扩大时 C 是规律。三条等价表明，以公理为条件，扩大就是保留且增加有意义者：还原到可能性不失去任何东西。所以原第二部分不加任何规则；它所加的只是断言：生成的空间从每个立场都有意义，包括损失返回不到任何人的延续。动力学不决定这一点（`Web.significance_undetermined`），不用公理的路线 (b) 只到达自身及其所依存的（§6.9），§6.11 把断言在预设之外所加的全部定位在不变的一步。所以这一断言不是理论的一部分，而是一个条件：理论陈述在它之下推出什么，不断言它。G0 的授权路线保持其范围；G0 在条件之下是定理，§7 在条件与实践前提之下陈述。

**审查会话的一项修正一并写入。** 同日的发布审查（审查会话 “Codebase review and proof readiness”）指出：`Unrestricted` 严格强于 G0，并使意义成为常量，所以在它之下每次关闭都失去有意义者；`loses_iff_beyond_margin` 对每个意义成立；`Web.significance_undetermined` 只表明意义是自由参数。§6.15 据此写：余量之界归于算术，条件只使它覆盖每个形成；条件不分出害与不害，混合部分需要度量；C 是规律是因为“更好”读作扩大。审查的其余项（“不用公理”的三种意义、可判定性只在双重否定或判定之下成立的定理）由审查会话在 P128 之后处理。

<a id="english-summary"></a>

- `Handing` → `Shuttle`
- `Kindling`/`Ember` → `Throughput`/`EmbodiedThroughput`
- `Spending` → `SelfDrawing`
- `Keeping` → `Lossless`
- `sun` → `source`
- `Dawn`/`Dusk` → `Accretion`/`Attrition`
- `Garden` → `Expansion`
- `Bloom` → `Oscillation`
- `Stranger` → `Unrelated`
- `Crowd` → `Unrecorded`

## 163. 发布准备度复核与第十八次审查（R18、I5）

2026-10-16。Ren：“spawn teams of sub agents, do a full review over the codebase … are we ready to release our significant proves?”，随后：“please work with it, spawn sub agents with proper effort level, and fix all”。六个复核者（可靠性、主张与证明、整合、代码库、理论状态、新颖性）给出[发布准备度复核](../history/root-foundation/BECOMING-RELEASE-READINESS-REVIEW.md)；[第十八次独立审查](../history/root-foundation/BECOMING-EIGHTEENTH-REVIEW.md)复核 P107–P127 与 I4b。均为 AI 的复核，不是成果。

```text
Result(s): 不新增成果；复核
Delta: 复核：核心与桥接无 sorry、公理、native_decide 或元编程；构造逻辑的标定陈述正确；没有假定理。
       问题在文字：定义性或双重否定的陈述被说成“每个宇宙的规律”、一个不存在的定理名、Unrestricted 强于 G0、
       未署名的经典来源、两个根与第三套词汇、陈旧的连通度
Evidence: 核心检查在 1a78f978 通过；第十八次审查逐项引 Lean；记录修正（r18-record-fixes）逐项先核 Lean 再改，
          断言只收窄；I5（检查器加固，基础设施）见 development/i5-checker-reproducible/REPORT.md
Boundary: 复核与审查是证据文件，不是独立成果；Ren 的决定（审查第 44–51 项、§8 所留）不由此定
Integration: P128 收入其第 1、3 项；README 与生成链 C03、M15 读 §6.15 的条件；章中最小的识与“能否去掉”按所证强度；
             二十余条记录收窄（r18-record-fixes）；开篇 v6 的准确性修改由 P128 会话在 Ren 同意后施加
```

## 164. 复核所见的脊柱整理（P129）

2026-10-16。工作板 P129。不加新律，不改已有名称与陈述（[报告](../history/root-foundation/development/p129-review-fixes/REPORT.md)）。

```text
Result(s): 不新增成果；新增连接定理与 LLPO
Delta: Parting.after、Courses.anyChange 改为 Run.onward、Parting.free 的缩写（rfl）；CrossSituational.distinct_iff；
       Sequences.recurs_iff；ReferencePlan.alike_iff_agreeOn；LLPO（标准形式）与 eitherThroughout_iff_llpoForDecided；
       refutable_adheres_iff；同名异义、经典来源与所证强度的说明（约 40 个模块）；四个“第二部分”文档注释读 §6.15 的条件
Supplied premises / correspondence: 不加前提，不加公理
Evidence: 核心检查 20261016T121942.514802Z 通过（桥接环境审计 851 个常量）；可判定性清点 436 行，LLPO 的四项证明内使用已归类；
          145 条记录改绑（notes-batch36），每个变化的源先读：说明、两个改指的缩写、新增定理
Boundary: 不改名（建议交 Ren）；由布尔形式的 LLPO 回到族的形式需要以数据给出的判定；无前提的“依守可被否证”不可证
Integration: lifting-where-branching-is-finite 新增一条定律记 EitherThroughout 即 LLPO；sensitivity-is-the-least-registration
             的 does_not_show 3 收窄为条件不以自然数编号者（已由 Tail 回答）
```

## 165. 一个根：每个基都读作运行，前沿陈述在两种作为的世界上（P130）

2026-10-16。发布准备度复核 §4 指出：脊柱有两个根（Process 与 World），以对应定理相连而非定义；P110–P127 陈述在耦合阵列与 `ExchangeLaw` 上；Quantum 与 Learnable 全部独立；连通测量已过时。工作板 P130。不加公理，只新增模块（[报告](../history/root-foundation/development/p130-frontier-on-base/REPORT.md)）。

```text
Result(s): 新增 worlds-are-runs、two-act-worlds-carry-the-difference；应用于 learnable-through-registration、gluing-under-parity、
           contextual-registration、weights-count-situations、how-loops-form、how-often-couplings-act
Delta: 六个新核心模块（Runs、CourseWorlds、LearnableRuns、ParityReadings、FinerTraces、FormedLoops），98 项定理、128 项声明；
       不改已有模块
Supplied premises / correspondence: 不加公理；读已立、可行、强度之内、列出条件在用到处写入
Evidence: 核心检查 20261016T124157.989030Z 通过（137 个脊柱模块，核心仅用前导库编译）；可判定性清点 437 行；
          连通测量在落地头上重跑（THEOREM-CONNECTIVITY §7）
Boundary: 两族仍分别定义，以恰好的对应相连；计数之律在枚举上；一般成环律与安定校准不在世界上重述
```

- **一个根：运行。** 世界恰是其每步之网与交换所显之律的运行，网与交换上的每个运行都是世界（两向 `rfl`）。世界恰在为交换之律的运行处平衡；计入其余时恒为这样的运行。交换律的路径以角色读作世界，恰在可行处平衡，其生成是一个确定之律的唯一运行。所携的量是一个平衡世界的位；轨道是运行；语境中的读法沿每个运行是一个世界。
- **两种作为的世界。** 一个律之下两种作为所生成的世界都平衡，相差至多所携的量并由携带之律达到；环、截断、路线、闭合、频率、阈与观察之律对这些世界成立。强度读自世界自身之位时，阈世界的环恰在阈处形成。
- **离群模块在基上。** 可学之律沿确定之律的运行成立；一步处的登记相粘恰在读法世界于该步无语境处；奇偶系统的读法世界无语境、无语境框架适合，都恰在没有选取矛盾处；量子登记使读法世界在任何一步都不无语境；所计的情境恰是更细之律的迹。
- **连通。** 原基之下，复核时 7,089 条中 1,093 条独立；落地头上 7,214 条中 1,019 条独立。P130 的 98 条无一独立；多出的 21 条都是 P129 的新定理。两族相遇的陈述 124 → 145。扩展基之下为 792 条。
- **读法（AI 的，待 Ren）。** 运行是逐步读的展开，世界是同一展开读作同类关系项的交换：同一化恰好，是一个展开的一个读法。到达多少差别，是一个律的两个世界之间的差别：实际的，与一个未取作为所生成的。
- **作者反审。** 每个实例的证明都用到基对象的结构；只给基对象命名的重述没有写。一个根不是定义上的；使之成为定义要改已有陈述，留给 Ren。
