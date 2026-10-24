# 早期《生生不息》仓库审读：哪些可以并入生成／变化之论

2026年10月19日。审读对象：`/Users/ren/repos/生生不息`（SSBX），HEAD `094db61b`，2026年5月7日至21日共 1,090 次提交。内容包括：

- Lean 4 + Mathlib 的形式化：`formal/` 下 743 个文件，约二十万行；
- 102 篇义理（`义理/`）；
- 史料（v9–v14 手稿、三本文、间生论、daoli-v12）；
- `docs-next/`、六表，以及「文」的语言线。

**方法**

- 六路并行通读，只读，不运行任何构建：伦理与对齐、史料与间生论、各域推导与边界、物理桥、易的代数、文的语言。每一路都对照现行章节和声明索引（[becoming-core](../../../../theories/becoming/results/lean-declarations/becoming-core.md)）作对应。
- 文中引到的现行声明与模块共 45 个，逐一在索引中查到。
- 卦的计数全部用穷举重算过：互卦、消息律的轨道与守恒量、爻位分布。
- 关键缺陷都回到源码核对过：Kernel 的塌缩、`Reachable` 恒真、`KleeneInverter` 可驳、虚词别名。
- 本文的对应与读法都是 AI 的读法。

**已有的工作**

- 该仓库的文档已逐字节保存在 [sources/07-shengsheng-buxi/ssbx-repo](../../../../sources/07-shengsheng-buxi/ssbx-repo/)；其 Lean 未保存，只有 `R/` 一组保存在 [sources/26](../../../../sources/26-deeper-root-code-audit-2026-10-06/README.md)。
- 三篇综述在 [history/lineage/shengsheng-buxi](../../../../theories/becoming/history/lineage/shengsheng-buxi/)。
- 十月的 R 塔审查在 [DEEPER-ROOT-GENEALOGY](../history/root-foundation/DEEPER-ROOT-GENEALOGY.md)。

本文新增三样：逐项到现行脊柱的对应、可以并入的定理候选、不应并入的清单。

## 1. 总判断

**Lean 几乎都不能原样并入。** 原因都已在源码中核实：

- **Kernel 塌缩了**（`Foundation/Wen/Kernel.lean`）。
  - 「动」是与一个非零格 `c_motion` 的异或（l.152–157）。于是「极」（`motion s = s`）无一居者（`terminus_uninhabited`），「中」对一切状态成立（`center_universal`）。
  - 又有 `good := center`，所以一切状态皆「善」。
  - 凡以「极」为靶的反驳都在反驳一个空谓词：霍布斯、Moloch、例外状态、Goodhart、reward hacking。
  - 异或一个常数两步即回，所以形式上的「中」恰恰是归的。这与九句「动而不归者谓之中」相反。
- **判词写进了定义。**
  - 仁 := 两状态不等（`benevolence`，l.625）；
  - 同根诸定理只是定义的逆否；
  - `Truth/` 的账本每项填 `True` 即得 `AbsoluteTruth`。
- **物理桥。**
  - `Reachable`（`Modern/QuantumRelativityMarkovBridge.lean:46`）对任意两态成立：`ProcessPath` 的 `valid : Prop` 可取 `True`。所以 `causalBefore` 是全关系。
  - 「Born 规则推导」逐点假设了结论。
  - NoGo 只是两个构造子互不相等。
- **图灵／哥德尔线。**
  - 机器状态只有一个有限格、一个栈和程序计数器，是下推机而非图灵机。
  - 一切 `_under_kleene` 定理都以 `KleeneInverter` 为前提。在该库的经典逻辑下，这个前提可驳：用经典可判定性得到停机的 Bool 判定器，再代入其自己的 `cuoInvariant_of_decides_halts` 与 `halts_undecidable_under_kleene`，即得矛盾。所以这些定理只说「此前提为假」。
- **「自描述完备」。**
  - `R8OperatorComplete := ∀ a b, ∃ f, f a = b` 对任何类型都由常函数成立，文件本身就是这样证的。
  - 「|S| = |transforms(S)|」在 |S| ≥ 2 时为假。
- **文的虚词。**
  - `Operators.lean` 把 故≡则（`gu_eq_ze : … := Iff.rfl`）、未≡不、以≡之≡函数应用都合并了。
  - 「375 个算子皆有定理支撑」靠的是恒等或占位的函数体。
- **证明基底。**
  - 大量计数用 `native_decide`，依赖 `Lean.ofReduceBool`；此外依赖 Mathlib 与经典逻辑。
  - R 族的 `Fin 6 → Bool` 编码要比较两个函数是否相等，须用函数外延，而它依赖 `Quot.sound`。
  - 因此仓库中「0 axiom」的说法在纯核心的标准下都不成立。

**思想多可并入，而且现行脊柱往往已以更强的形式、不把判词写入定义地证出。** 价值分三类：

- **(A) 读法**：把早期的词汇接到已落地的律上，其中几项正好填上现行章节自己承认的缺口；
- **(B) 十余条新的纯核心定理候选**，多为有限、可构造的小律；
- **(C) 方法上的教训。**

这个对比本身就是收获：早期的工作问对了问题，词汇也大多是对的。把它们变成结果的，是现行的方法：一个展开在先；律是构形上的变化律；判词不入定义；公理报告为空。

## 2. 可并入的读法

| # | 项 | 早期出处 | 现行脊柱上的对应 | 去处 | 注意 |
|---|---|---|---|---|---|
| A1 | **闭的词汇对照**：伪开三型（I 局部开而全局闭；II 短期开而长期闭；III 表开而元闭），以及成闭、护闭、元闭 | 间生论·四；补篇一 §十一；正篇 卷六 | I：`Becoming.Continuation`、`Coarse`、`Switching`；II：`Becoming.Horizon`、`Web.break_not_bounded`；III：`Law.rule_absorbing`、`Captured.state_perturbation_drawn`、`Law.perturbation_reabsorbed`；成闭：`Law.DrawnInto.never_back` | 章节词汇表。现行章节自承三套闭的词汇「without a crosswalk. This table does not resolve that」（[THE-THEORY-OF-BECOMING.md](../../../../theories/becoming/history/THE-THEORY-OF-BECOMING.md) l.1791） | 去掉按焦点分配的开度 O_a（分配给各自独立的所有者），只留结构类型 |
| A2 | **开 = 未·可·应·转** | 间生论·四；补篇一 §十；正篇 六一 | 未／开维：`World.arising_opens`、`Flow.new_beyond_every`；可：`Onward.run_iff_continues`；应：`ExchangeLaw.RespondsTo`；转：`Returns`、`Becoming.Dependence`、`Becoming.Rejoining`；「开非更多」：`Branching.Transit.keeps_not_returns` | 词汇表对照行，加一条读法 | 现行的 openness 只对应「未／开维」。若把「转」读作回归，它蕴含「可」，四者便不独立。「稳」（扰后不坍，判为好）与「元闭」（判为坏）是同一结构，都是扰动被吸回；价值写在定义里，正说明价值只应经 §6.15 进入 |
| A3 | **九句的「归／不归」** | README 古文前言 | 脊柱把它分为三种：无损的回归（`Lossless.returns`）有不息而无生生；被吸引者不归（`Law.Drawn.not_returns`、`Law.drawn_iff_lost`），是「收」；永不重访只在开放世界中可能（`unheld_of_new`、`more_needs_open`），这才是「续而生」 | 章节 D5 旁的读法。九句原文逐字保留，读法标 AI | 早期的二分把回归与被吸引混在一起。「极」若读作静，并不是「熄」（静≠停） |
| A4 | **反诛心**：评判只可比较言与行，不可推断内心；不一致时应当问，而不是判 | `Core/Sincerity.lean`；义理 U | `Web.selects_alike_iff`（两段历史在评判者的耦合下相同，则一切经由这些耦合的选择都同样对待它们）；问 = 把被评判者纳入合耦（`Web.separates_all_iff_member`）；`Web.class_judge_iff` | §7.3、§3 的读法；可选一个实例模块（世界含言、行、内情三项） | `ConsentedSincerity` 是同意／权利的框架，不取 |
| A5 | **和而不同；同化；四校与伪校** | 间生论·五、六；补篇一 §十七、§二十 | 合耦只在成员有差处添选择（`Web.pool_adds`）；同化即合并，合并必失（`Law.Merges.not_both_return`）；同源的校验者不添分辨（`withinClosureOf_iff`、`Web.separates_all_iff_member`）；排除受影响者，恰好去掉能分辨此举的成员（`Flow.act_selected_by_pool`） | §7.3–7.4 的读法；也回应「人类命运共同体」的呼应 | 去掉「和」所需的标量阈值 ‖势‖ ≥ θ |
| A6 | **间** | 间生论全篇；补篇一·序 | 律对其历史的余量：历史之外，律只添拼接与无历史显示的死路（`Becoming.Unfolding`、D32）；其余整体作为一个关系项（`World.withRest`） | §1 读法，不作原始概念 | 与现行的四处差别：<br>1. 实在在先，而非可能在先；<br>2. 关系项只有一种，而非先有焦点、后有关系；<br>3. 没有「外」，而非区分生与外乱；<br>4. 不把合法、响应、评价打包在一处 |
| A7 | **边界图谱**：知、感、行、证、名、量、测、推 | `义理/边界/` | 知·明 Observation；辨 Distinguishing；述 `Law.name_identifiesAlike`；贯 Context、Gluing；存 Lasting、Remainder；测 Testing、Readout、Experiment；实数相等不可判 Sensitivity、Tail；统一边界 Diagonal | §3 加一小节「知之所不能」，逐轴指向已落地的律 | 缺：校准（§8.2 已列为 open）、现象性、担保。「可知 = 可说」与「观察者在系统外」与现行冲突 |
| A8 | **同根的三义** | Kernel `sameRoot`；义理 W；恕 | 一律适用于一切历程，即一个展开（零前提）；一举在各处落得相同，不真；意义对视角不变，即 §6.11 的不变性一步（`unrestricted_iff_presupposed`、`Clearing.without_invariance`） | §6.11 加一条说明 | 若引入第二义，便把伦理重量藏进了定义 |
| A9 | **一举所及的三层**：态、可行之步、规则 | 补篇一 §三十七、§四十 | `adaptive_state_law_iff`（D25）；§7.4「只及于态的改变会被吸回」 | §7 | 去掉「责」的定义式（章节已说明责任不由这些律推出） |
| A10 | **人类命运共同体的三条件**：共开、共续、非夺共续 | `Core/Renlei.lean`；共同体之证 | 共开即合耦；共续即整体层面的生生不息（D5）；非夺共续即不取他者之续所依（`Flow.favours_reaching_beyond`） | §4 读法 | 早期是三个 Bool 字段，判词内置；共同体不可先立为实体 |
| A11 | **墨经的四同、小故与大故** | 义理·形式逻辑 | 重同 `name_identifiesAlike`；体同 Wholes、Joining；合同 Situations；类同 Lumped；小故大故 Counterfactual、Dependence | 读法：每一种「同」都写明其关系依据 | 「合同」读作同处一境，不读作空间上同处 |
| A12 | **积与礼：塑形与锁定；混→沌→灭** | 间生论·三、七、十二；补篇一 §二十六 | 锁定即 Capture 的吸收规则区；速率见 Frequency；损失之后的三种出路见 Dependence；`Law.lost_stays` | 读法 | 「德 := 积朝向护开」把价值写进了定义 |
| A13 | **虚词表与「是」的拆分** | `wenyan-operators.md` §十一（l.715–853）、以（l.544）、isness（l.847） | 中文版已大量使用这些虚词：之 1,565、所 1,372、者 1,113、以 760、于 495、而 407、则 195、故 13 次；[HANZI-AND-THEORY-TREE](../../../../theories/becoming/history/HANZI-AND-THEORY-TREE-2026-10-23.md) §6 说还需要关系标记 | 命名研究加一节：每个虚词在本理论中的一种结构关系，按 HANZI §5 的四条验收 | 早期 Lean 把 故≡则、未≡不 合并，正是这张表要防的。学派、五伦等行不取 |
| A14 | **社会吸引子笔记**（原仓库未提交，字节相同的副本已存于 [sources/07](../../../../sources/07-shengsheng-buxi/ssbx-repo/docs-next/10_formal_形式/r-attractor-capitalism.md)） | `docs-next/10_formal_形式/r-attractor-capitalism.md` | 吸引子只在给定更新律之后出现；有限的非单射律成盆，可逆律成环：Recurrence、Attraction；`q ∘ f = g ∘ q`：`Learning.goAlike_iff_lumped`；「看得见的相等不是全部相等」：Remainder；规则吸收：Capture | 应用读法，放在 §7 或应用章节。它把科层、法律、社交媒体、学术、军令与资本都读作「投影→选择→递归」 | 定理名不取金融或社会词；此为应用，不是核心 |

## 3. 纯核心的定理候选

以下都是有限的，并可构造地陈述。凡标「已穷举」者，计数已用全部 64 卦重算。早期证明多用 `native_decide`，须重证；其中 64 路 `cases … <;> decide` 的全称陈述可以直接移植。

### 3.1 卦（`Becoming.Hexagrams`，须与正在进行的 Y2 协调）

- **H1 互卦（nuclear）律。**
  - 定义 ⟨a,b,c,d,e,f⟩ ↦ ⟨b,c,d,c,d,e⟩。这条律合并：64 卦映到 16，16 再映到 4。
  - 回归者恰为 {乾, 坤, 既济, 未济}：乾、坤不动，既济↔未济成环。
  - 进入核心所需步数：0 步 4 卦，1 步 12 卦，2 步 48 卦。
  - 归宿由三、四两爻决定：16 卦归乾，16 卦归坤，32 卦入既济／未济之环。
  - 互与錯、綜都交换。三、四爻这一聚合能承载此律，阳爻数不能。（已穷举；早期见 `Classical/Core/Yi.lean` l.224–760。）
  - 它与消息律（无损，皆回归）和只进阴的律（尽归坤）构成第三种形态：两个定点加一个环。
  - 读法：繫辭下「雜物撰德，辨是與非，則非其中爻不備」。
- **H2 消息律的轨道普查与守恒量。**
  - 消息律有六条轨道：五条 12 环、一条 4 环。乾的轨道值 1，既济的轨道值 5，隨的 4 环与另三条 12 环值 3。现行模块只有乾的轨道和隨的环。
  - （承 + 乘）+ [初 = 上] 守恒，取值 1、3、5，分别出现在 12、40、12 卦上。（已穷举。）
- **H3 老少与之卦。**
  - 「老变少不变」是一条合并的律，一步即定。
  - 本卦不是一个聚合，因为它不决定之卦，与 `yang_not_lumped` 同类。
  - 读法：「窮則變」。早期见 `Yi.lean` l.412–530。
- **H4 錯綜的 Klein 四元群与 20 类。**
  - 8 类大小为 2，12 类大小为 4。
  - 綜不动的 8 卦，恰是通行卦序以錯相配的那些；錯綜不动的 8 卦是泰否、隨蠱、漸歸妹、既未濟。
  - 互与四元皆交换。
- **H5 「加一」计数律。**
  - 无损，只有一条 64 环。第 k 爻每 2^(k−1) 步翻一次，可接 Frequency。
  - 与消息律对照：两者都是「皆回归」，但只有它是单轨道。
- **H6 爻位（已交给 Y2）。**
  - 当位数 = 6 − d(s, 既济)，d 为相异爻数，分布 1/6/15/20/15/6/1；錯与綜都给出 6 − 当位数。
  - 应的数目 = 上下卦相异之爻的数目。
  - 承 − 乘 = [上为阳] − [初为阳]。
  - 这些计数都不是消息律可承载的聚合，所以是带索引的读法。
  - 早期 `biCount` 把同性相邻称作「亲比」，与传统相反（同性相邻为不相得）。（已穷举。）

### 3.2 一般律

- **G1 机即关节（juncture）。** 在 `Becoming.Branching` 上，该模块中尚无同类定义。
  - 定义：x 是对 s 的关节，当且仅当 x 可回到 s，并且 x 既有能回到 s 的步，也有不能回到 s 的步。
  - 定理：一切对 s 的失去都经过一个关节，表为 ¬¬∃；若构形可列、步可判定，则为 ∃。
  - 定义 `keeping P s`：只保留能回到 s 的步。它保住 s，并且是一切保住 s 的子过程中最大者。
  - 读法：护闭即在关节处去掉失去之步，成闭即去掉保持之步；二者都不带价值。选项多不等于关节，即「多选项之闭」。
  - 记录须说明 ¬¬ 对展开的意义：找到关节，就是判定 s 是否仍可再得。
- **G2 无定点对称不被抹去。**
  - 若 T ∘ σ = σ ∘ T，且 σ 无定点，则对一切 n、x，有 Tⁿ(σ x) ≠ Tⁿ x。
  - 推论：没有常值律；静止点与环都成 σ 对。
  - 实例：消息律与互都和錯交换；尽归坤的律必破此对称。
  - 读法：要抹去一个由对称承载的差别，律必须破此对称。（来源：义理·拓扑 l.84–114、l.271–308。）
- **G3 第三值与修订（Kleene–Kripke）。**
  - 取值 t、u、f，信息序上 u 低于 t 与 f。
  - 由 ¬、∧、∨ 构成、不含常量的项，在输入全为 u 时取 u。
  - 求值对信息序单调。
  - N 个句子的单调修订，从全 u 出发，在 N 步内停于最小不动点；说谎者句停在 u。
  - 它补 `Diagonal.revision_never_rests`：缺口不会消失，而是表现为未决。（来源：`Eight/LuoJi.lean`、义理·形式逻辑；早期只证了实例。）
- **G4 尺度不传递。**
  - 若 p ∘ next = q ∘ p，则 next 下回归可推出 q 下回归。
  - 另有一个见证：p s 在 q 下回归，而 s 在 next 下被吸引。即：在一个粒度上延续，不担保在另一个粒度上延续。
  - 先查 Learning 与 ProjectedLaws 是否已有。
- **G5 校准（可选）。** 读数若只差一个值上的双射，便支持相同的「相同」判断。值的断言须耦合进一个参照读数。先对照 `relabel` 前提与 Description。

### 3.3 加权与路径（Routes、Quantum、Observation）

- **W1 一切加权的支撑可靠性。** 可能性的转移为假时，加权转移为零。它是 `Interference.unseen` 的反向搭档。
- **W2 在中间时刻分拆。** transfer (m+n) = transfer m ∘ transfer n，并给出拼接历程上的 `along`。现行 `Weighted.lean` 中没有这条；它可能接近按定义成立。
- **W3 可交换的权重与重排。** 加 `Weights.Comm`、核内的 `Perm`、和对置换不变，然后按响应次数分组。这正是 Routes 文件头所列「未推出、需要可交换的选项」的那一项。
- **W4 区间局部性。** 两个加权若在 a 与 c 之间的区间内处处一致，从 a 到 c 的转移就相同；所携带的量只依赖区间内的耦合。不可沿用早期的 `causalBefore`。
- **W5 Pauli 相位律。**
  - phase p q = sgn σ(p,q) · phase q p；交换当且仅当 σ = false。
  - 由此从算子一般地得到奇偶系统：Mermin–Peres 可由此推出，GHZ 星形是新实例。
  - 来源：`Wen/Embeddings/PhasedPauli.lean`、`StabilizerQM.lean`。
- **W6 作用量给出相位。**
  - 核内：总作用量的奇偶给出符号。
  - 外围：复权重 exp(iS) 与 Born 权重 normSq，补章节 l.1281 的开放行。
- **外围** 有 ZMod p 上的 Heisenberg–Weyl 算子（`HeisenbergWeylOperators.lean`），可作为高维的算子层。它不含情境性定理。

## 4. 方法上的教训

- **占位状态与「不主张」栏。** 早期账本（`claim-status-ledger.md`）分七种状态，并设「尚不可主张」一栏。现行记录已精确写出范围，但还没有两样东西：一个「占位」类别，指在承重处为空的陈述；一个明写的「不主张」栏。还可以加一个检查启发式，标出主张有内容、函数体却是 `id`、`True` 或常值的地方。早期仓库自己违反了这条纪律，正好作为警示样本。
- **失败的模式。** 把判词写进定义、空的谓词、按定义成立却冠以大名的定理。现行的规则（判词不入定义；主张只说 Lean 所证；公理报告为空）正对着这些。
- **量子读法的护栏。** 量子 ≠ 意识，纠缠 ≠ 心灵感应，不确定 ≠ 不可知，SU(3) ≠ 八卦（`量子物理语言 · 从虚到测` §十三），可用于章节中的量子读法。
- **前人工作的分层。** `docs-next/00_start/research-position.md` 把易的形式化分为三层：已有学术成果（八卦的 (Z/2)³、序卦配对、邵雍、莱布尼茨）、边缘或启发性的、本工作原创的。[《易传与生成／变化之论》](../../../../theories/becoming/history/YI-ZHUAN-AND-BECOMING.md) 应据此注明前人：例如卦序「二二相耦，非覆即變」是孔颖达已说的。

## 5. 不应并入

- **Kernel 第 1–46 层**：模型已塌缩，判词内置，并用 `native_decide` 与 `Classical.em`。
- **`AntiSchmitt`、`AlignmentFailures`、`EconGame`**：已从原仓库删除，内容为空，并用博弈和讨价还价的框架。
- **`Truth/` 的「绝对真理」**；Alignment 的 T3 当作「施为矛盾」、T5 的 `Iff.rfl`、T6 的 `rfl`；R 篇的必然性说法（「唯一可奠基」「maximally robust」）。这些与「无伦理公理」相冲突，而 §6.11 已指出它们跳过的那一步。
- **Cayley「元 ≅ 算子」、「道 = 原点」、Pontryagin 自对偶、SelfDescription「完备」**：或平凡，或是约定的选择。
- **图灵／哥德尔线**：下推机，加上可驳的前提。
- **R 塔与 Claim Z、GUT 线**：基数双射的打包。早期账本自己就警告不可多读。
- **V₄ 时态 道／已／今／未**：重标的两个比特，可逆，与其自己的「史不可倒流」相矛盾。
- **物理桥的 NoGo、`Reachable` 与 `causalBefore`、S18 的「Born 规则推导」、S24–S26 的「作用量极值」**；以及有限集之间的双射比附（唯识四分 ≅ 四象，八卦 ≅ SU(3) 等）。
- **daoli-v12 的「公理一」与其上的 62 条法则**。其中法则 6「合成不可逆」为假：无损律皆回归。
- **把自相似读作自然变换**（Coarse、Switching 已驳）；**标量评分**（Ω、阈值、好 = [平, 和]）；**按焦点的价值谓词**（正、邪、善、仁、道、自由、繁荣）。
- **YiCore 把「生生不息」「道法自然」读作 64 步循环的定理**：这正是章节词汇表排除的误读，不息不等于生生不息。
- **标签与编码**：天道／心道、互作 Y 组合子、錯綜作 P/T/PT；R 族的 `Fin 6 → Bool` 编码；两种互相冲突的「本／征」定义，以及两种不同的「一」。

## 6. 原仓库的状态

- 26 个分支未并入其 main。多数是文的 REPL 修补与 wen-2.0 测试；另有一个 R 塔 ↔ Riemann ζ 的桥（2,089 行）、一个平方塔的 sorry 清除，以及一个移除不可靠公理 `sierpinski_cube_JT_factorization` 的分支。该公理在 main 上已由另一路径移除，`FrameBimorphism.lean` 中有注明。
- 未提交的改动有两处：`AGENTS.md` 删去两条「优雅」标准；`r-attractor-capitalism.md`，其副本已存于 sources/07。
- 现行的 Mathlib 外围以该仓库为其 Mathlib 项目（`SYSTEMS_MATHLIB_PROJECT`），所以不要随意在那里构建或改动。

## 7. 建议的次序

每一项都先在工作板上认领。

1. **闭与开的对照**（A1–A3）：一次只改文档的工作，配 D 编号。它关上章节自己列出的缺口，代价最小。
2. **卦律 H1–H5**：等 Y2 落地后，在其定义上进行，与其负责的会话协调。
3. **核心律 G1–G3**：关节与保持、无定点对称、第三值与修订。
4. **加权线 W1–W5**：交给 Routes、Quantum 与 Observation 一线。
5. **其余读法 A4–A14 与虚词表**：一次文档整理。
