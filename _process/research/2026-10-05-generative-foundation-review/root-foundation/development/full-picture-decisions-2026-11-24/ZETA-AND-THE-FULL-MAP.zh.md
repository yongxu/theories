# ζ 函数、能被看见的未来，以及我们要画的全图

写给正在推进 Theory of Becoming / Theory of Alignment 的 Gemini、Codex 与人类协作者。Codex 据与 Ren 的讨论撰写，2026 年 11 月 24 日。前两轮主线取样于 `73df4e97e`，第三轮取样于 `c2151efa8`，另核读本地集成提交 `11fa06d64`。同机其他工作树的协作者可从 `/Users/ren/theories` 打开本备忘，沿文末相对路径回查原件。这是一份供反驳和续用的研究备忘。文中的数学推演、仓库已证的定理、已有实验和待检验的设想各有出处。项目方向以 [Ren 的原话][ren-map] 和[方向页][direction]为准。

**第三轮可直接从[第 8 节](#round-three)读起。** 主线已证明第二轮的有限对偶。本轮追到一个实际的回放偏差，并算出在同一个湖泊里，按时询问一项提案、委托下一人自由选择，以及事先固定各人额度，分别能保住多少可能。前一轮的对偶推导在[第 7 节](#round-two)。

**如果只读一分钟。** 一幅图可以准确记录系统所有长度的循环，却完全漏掉一条决定它能否转为另一种形态的单向路。一个学习者可以已经掌握某个规律，却还没有足够证据知道自己掌握了它。两个人也可以复核同一个正确结论，却共同缺少辨认眼前情形所需的区分。对正在做的全图，三个问题应当连起来问：**实际上有哪些路可走？身在其中的谁能用什么经验分清它们？当他们据此共同选择以后，哪些路、哪些纠正他们的机会，又会打开或关闭？** 这三件事可以沿同一段历史追踪，它们之间的约束可以分别查明。[Ren 谈相变、路径和吸引子][ren-path] · [Ren 谈辨认情境，也谈你我][ren-recognition]

我理解 Ren 为什么发来这篇文章。数论里，知道一套零点的位置，会约束素数在大尺度上还能怎样波动。我们也在找一种有这种力度的关系。**生成论**问，一种形式退出时，它曾支撑的能力还有哪些实现途径。**智能**是这个过程里形成的一种能力，有时它能通过一次新的尝试分清两条原来看起来一样的路。**认识论**问，指认这一区别的人有什么证据，另一位处境不同的人如何复核或推翻它。**对齐**把同一件事再往前追一步：当判断进入选择，谁仍能走自己的路，谁还能让共同判断改过来？由此得到一个对我们自己的要求。倘若读者只能重复我们的结论，却不能用它在陌生情形下发现一条我们遗漏的路，这套理论的生成力仍待证明。[项目当前方向][direction]

## 1. 黎曼问题给了我们什么标准

在 $\operatorname{Re}s>1$，$\zeta(s)=\sum_{n\ge1}n^{-s}=\prod_p(1-p^{-s})^{-1}$。每个乘积因子展开为 $p^{-s}$ 的各次幂，对应 $1,p,p^2,\ldots$。整数唯一分解保证全部展开项恰好各数一次。换一种写法在这里有实际力量：取对数导数便得到以质数幂为支撑的级数。反过来，显式公式把非平凡零点的位置接回加权质数计数 $\psi(x)=\sum_{p^k\le x}\log p$ 的波动。经典等价结果是 RH 当且仅当 $\psi(x)=x+O(\sqrt{x}\log^2x)$。质数如何分布、复函数在哪里为零，各能独立定义；我们能解释为什么关于一边的发现会约束另一边。此前早已建立的这层联系，说明了此次证明究竟解决了什么。[Bombieri 对黎曼问题的说明][bombieri] · [显式公式与误差界][kth]

Alpöge 叙述研究经过时，指出了一个具体的迁移：在函数域上的旧论证中，重数承担一个作用；到了整数情形，产生重数的原有办法失去了着落。沿着傅里叶分析的线索，他和 Claude 尝试用一串 theta 提升承担那个作用，Claude 提议让链长达到 $\sqrt X$ 的量级。这是作者对**发现**的说明。Lean 与 Mathlib 的复核使其他人能独立检查**所证命题与推导**。Rubinstein 后来专取 ζ 函数的情形，把论证重写为一个主要不等式和两项估计，写出估计的证明，也标出主要不等式仍依靠原形式化的哪些部分。这才开始回答**理解**问题：换一个情形，第三个人能留下哪些步骤，又能指出哪一步要重新发明？一份证明可以先成为公共知识，其中可再利用的构造要经另一番工作才会显出来。[Alpöge 自述，第 1 页][alpoge] · [Lean 与 Mathlib 核验声明][lean-rh] · [Rubinstein 的重建与未完部分][rubinstein]

<a id="round-one-graphs"></a>

## 2. 一个真正能接到生成论的数学例子

取有限有向图，$A_{ij}$ 表示从 $i$ 到 $j$ 的边数。$\mathrm{tr}(A^n)$ 数长度为 $n$、标明起点的闭游走。每条周期轨道都是一条原始周期轨道的重复。按原始轨道 $\gamma$（循环平移视为同一条）相乘，或按有根闭游走相加，得到同一个动力 ζ 函数：

$$
Z_A(z)=\prod_{\gamma}(1-z^{|\gamma|})^{-1}
=\exp\!\left(\sum_{n\ge1}\frac{\mathrm{tr}(A^n)}{n}z^n\right)
=\frac{1}{\det(I-zA)}.
$$

这些等式可按形式幂级数理解。指数中的 $1/n$ 校正了同一周期的不同起点和重复次数。它与算术 ζ 函数有一个精确的亲缘关系：按基本组成计数和按整体计数能够互相翻译。数论中依靠整数的唯一分解，图中依靠周期轨道各有最短周期。自然史的一次性历程是否可以分解、次序能否交换，需要就该历程另行说明；这份对应也没有给智能系统导出一条实部为 $1/2$ 的临界线。[Bowen–Lanford 原文][bowen]

**两幅图，一条不能返回的路。** 令甲、乙各有一个自环。第一幅图只有这两个环。第二幅图多一条甲到乙的边，乙没有路返回甲。无论观察多长，两图都有 $\mathrm{tr}(A^n)=2$，因而同为 $Z_A(z)=(1-z)^{-2}$。可从甲出发，第一幅图永远到不了乙，第二幅图却可以。若乙代表耗尽，新边使一种不可逆的损失成为可能；若乙代表一种此前无法实现的能力，同一条边也可以见证生成。它只说明有这样的可能。走到乙的概率、能否主动避免、以及谁因之得益，都还要另外给条件。

这点不限于两状态例子。两个内部网络 $B,C$ 若只有从前者到后者的通路，邻接矩阵形如 $\left(\begin{smallmatrix}B&T\\0&C\end{smallmatrix}\right)$。块三角行列式给出 $Z_A=Z_BZ_C$，所有这样的 $T$ 都被忘掉。分别算清两个区域里能够反复维持什么，仍然不能决定它们之间的转变。对全图而言，接合的界面本身就可能带着全部重要信息。

**怎样让开路进入同一个计算？** 在模型中添一条带标记的返回边 $j\to i$，赋权 $u$。一次使用这条边的周期，剪开标记就成为原图中从 $i$ 到 $j$ 的一条游走。写成公式是

$$
\left.\partial_u\log Z_{A+uE_{ji}}(z)\right|_{u=0}
=z[(I-zA)^{-1}]_{ij}
=\sum_{n\ge0}(A^n)_{ij}z^{n+1}.
$$

这里 $E_{ji}$ 只有第 $j$ 行第 $i$ 列为一。第一步用 $\mathrm d\log\det M=\mathrm{tr}(M^{-1}\mathrm dM)$，最后一步展开几何级数。上面第二幅图中，甲到乙恰走 $n\ge1$ 步有 $n$ 种走法，因为过界可以发生在任一步；第一幅图是零。标记只是计数的手段，现实中的路仍然不可逆。**知道原图的 ζ 函数，不等于有能力测量加标记以后的变化。** 若全图已知，把每一对端点都标一遍只是在读回邻接矩阵。对世界内部的观察者，困难在于他起初连哪个端点值得标记都可能不知道，也未必付得起取得证据的代价。这几式是经典行列式公式的纸上推论，本备忘不据此登记新的 Lean 结果。[图 ζ 公式][bowen] · [行列式微分][jacobi]

还有一个会实际改变判断的区别。若问题是“第几步**首次**失去维持条件”，只数到达终点的路会把中途已经失去、后来又恢复的路算进来。在已给安全集合与策略的有限马尔可夫链里，令 $Q$ 为安全状态间的转移矩阵，$b_i$ 为从安全状态 $i$ 一步进入危险集合的概率。首次在第 $n\ge1$ 步越界的概率恰为 $(Q^{n-1}b)_i$，因为前 $n-1$ 步都须留在安全集合。这里选择策略、计算概率、保证对所有扰动安全，是三个不同的问题。宏观检查若只在间隔末尾取样，还须查它是否漏了中途越界。[仓库中周期采样漏过越界的构造][sampling]

## 3. 同一个界限，怎样把数学、智能和认识论接起来

仓库里已有一个特别干净的三层结果。固定一种无噪声读法，考虑确定、无输入的过程。若从各时刻往后读，至多有 $N$ 种不同的无限尾序列，读数便有一段开头，随后进入周期，开头长度加周期长度至多为 $N$。同属这个范围的两条历程，前 $2N-1$ 项相同就处处相同。若有两种不同读数，少看一项就有反例。最小例子是 `010101…` 和 `011111…`：各只需两个状态，头两项相同，第三项才分开。[Identification 中的 `statesBelow_iff_lasso`、`bounded_agree` 和 `bounded_agree_exact`][ident]

这个界限也解释了**学习与知道自己学会了**的距离。Lean 给出一个程序：每次选与记录相符且所需状态数最少的“开头＋循环”模型。在读数可判等时，真实过程若满足上界 $N$，即使无人告诉程序 $N$，它仍从第 $2N-1$ 项读完以后次次预测正确。只要有至少两种可能读数，又未预先约束候选过程的状态数，任何有限记录都容许此前相同、下一步却不同的有限状态过程。数学给出了规律可以藏多久，学习算法能达到这个界限，认识论则指出何时有根据断言其他未来已被排除。三者约束的是同一串读数，结论可以分开。[`leastBound_exact` 与 `rest_without_bound_missed`][ident] · [`no_prefix_fixes_next_finite`][learning]

数值读数还有一条与 ζ 思路相通的短推导。把读数写成 $F(z)=\sum_{t\ge0}a_tz^t$。若开头长 $i$、周期长 $p$，则 $F=P/(1-z^p)$ 且 $\deg P<i+p\le N$。比较两个候选时，两分母都有因子 $1-z$，所以通分可以让第一项的分子只乘 $(1-z^{p'})/(1-z)$，第二项同理。差的分子次数至多为 $2N-2$，分母常数项为一。前 $2N-1$ 个系数为零就迫使分子恒为零。这是数值特例的另一种解释；Lean 原证明直接处理一般读数。这里的力度来自已知的生成结构。复查有限多个 ζ 零点没有这个有限状态上界。

## 4. 回到现有全图，哪几处已经接上

| 当协作者问 | 已有材料给出的答案 | 承担结论的条件或限制 |
|---|---|---|
| 观察者内部能形成新的区分吗？ | 同一装置听两段声音，每个音出现次数相同，次序不同，后来同一句话一边能分词，一边不能。第一段形成的分组还适用于这个双词编码的任意长消息。[`order_not_frequency`、`context_groups_words`][group] | 计相邻转移的多数规则、解码器与可接触的材料已给定。已成功解析的消息不会触发继续取样。 |
| 学习者能自己发现反例，而且让区别改变后续行动吗？ | 十月的有限装置从付费查询中自己找到区分后缀，再用于没问过的动作串。后续研究中，两个正确绑定、结果相反的交付记录迫使旧分组拆开。只遮蔽决策者对细分的使用，保留证据与成本，第三次行动随即消失。[主动取得区分][acq] · [使用与遮蔽][acq-use] · [交付、修订及失败对照][refine] | 状态上界、可执行动作或较细模型坐标、诊断与拆分办法分阶段给定。预装正确细分同样成功且更省。假阳性收据能制造假区别。把第二份收据错绑到第一状态则会暴露矛盾，装置据此拒绝拆分。第三处未经探查的机会仍会漏掉。 |
| 资源真的会使系统从任务本身察觉到问题吗？ | 从任务的实际产出和维护成本能推出成绩交叉点。有模型在尚有余量时转向，也有模型直到错过可维持的底线才见信号。[`score_crosses_iff`、`timely_survives`、`late_collapses`][turn] | “收到账面低分就改变策略”的规则是给的。另一个模型中，选择先改变评议者构成，即使损失报告后来能改变分数，仍扭不转方向。物质余量和改变规则的力量可以分别丧失。[`late_kept`、`late_reads_loss`][capture] |
| 可否从充分拟合共享的观测，推出共享的未来？ | 在有限集合且局部状态非空时，允许任意重新分配局部概率，最佳观测总变差恰等于目标分布落在局部制造不出的读数上的质量。另有两状态投影相同而可维持性相反的反例。[`optimal_query_tv_floor`][obs] · [`c2_coupled_fiber_split`][oplax] | 最佳分布的存在不保证学习者可达。即使被动观测对所有状态都完全符合模型，主动提高代理指标也能在第二步耗尽储备、第三步才使指标本身崩溃。[`passive_commuting_all` 及后续干预证明][causal] |
| “全图”是否要求人人学会同一个最简分类？ | 对一次必须作出的选择，若每种相容情形 $w$ 所允许的行动为 $U(w)$，那么在同一读数下可以保证成功，恰需这些集合有公共元素。仓库里三种情形两两都有共同行动，三者一起却没有。两套读法各自足以行动，连它们的公共粗化都可能失效。[`no_coarsest_adequate`][plans] | “能共同做什么”依赖问题、期限和保护对象。换了任务，就要重算。一个有限守恒例中，每一步都有旧形式退出，由另一形式保持同一能力；把两者计作同一能力的映射是明示的。[`finite_gainless_transformsViably`][transform] |

还有一个衡量跨尺度压缩的办法。给定描述 $\pi(h)$ 和想保护的后果 $Q(h)$，仅凭描述就能答对 $Q$，当且仅当凡被 $\pi$ 合并的历程都有相同的 $Q$。此时可以在实际出现的每个读数上给出唯一的答案。若全图还要说明各部分怎样接合，就要再问一次：前一段停在 $b$、后一段始于 $c$，若两者实际接不上，压缩却把它们读成同一个状态，宏观图就会凭空多出一条路。U6 给出了先接合再压缩与先压缩再接合的精确比较。另一个已证的充分条件是，若接合结果由两端唯一决定，而且替换前后的片段在所有有限左右拼接情境中都同样可行，则接合后的片段也在这些情境中同样可行。这里可以严格说出究竟是哪一类未来经替换仍被保存。[两种次序的比较与反例][oplax] · [`ContextSame.joined`][join]

两处已有结论尤其值得带去审读新的“大定理”。如果每个允许实验在两个假设下给每种结果的权重都相同，依据既有记录自适应选择下一实验，仍无法分出它们。若声称“系统发现了前所未有的区别”，可以明确指出是哪种原先未被使用的组合、接触或传讯打破了此前的等价。其次，`whole_becoming_master_theorem` 顶层把五项结论组成合取，架构的一项输入 `probe_identifies` 已要求给定的计划能够如期辨认。要说“生成了辨认能力”，需在具体子证明里找到这个要求来自何处。真实的连接可以很短：一个任务伙伴的成绩提供警告，在传讯和共同余量条件下，能使原先分不开两种储备的系统守住底线。[`seek_tied`][seek] · [`WholeArchitecture` 的输入和总定理][master] · [接通伙伴和断开伙伴的可维持性对照][turn]

## 5. 接下来最有价值的缺口

**候选问题。** 当现有指标继续报成功，而受影响的一方正在失去某种可能性时，两个各只握有一半证据的系统，能否在仍来得及的时候，形成一个双方可使用、可质疑的新区分？若今天的选择还会决定明天谁能报告，应把产生分歧和消除分歧的两条路都画出来。一个群体可以因听到了新的后果而改变主意，也可以因那位见证者被排除而变得一致。

在有限情形，可以直接写出需要多少证据才能行动。设诊断有截止时间，每次尝试的代价计入剩余资源。对每份实际能取得的末端记录 $r$，令 $H_r$ 包含与之相容的真实历程，$U(h)$ 是在历程 $h$ 之后仍来得及保证达成目标的最终行动集合。固定一套可由当事者执行的诊断规程，且每次尝试在所有相容历程中都可行、安全。若最终行动只能依这份记录选择，则存在一种对所有相容历程都保证成功的决策，当且仅当每个可达记录均有 $\bigcap_{h\in H_r}U(h)\ne\varnothing$。必要性来自同一记录必须选择同一行动。充分性来自给每个可达记录选一个公共行动。这是有限决策树上的直接推论。它允许在仍分不清世界时正确行动，也解释了为什么有时必须取得一种新区分。若记录分散，$r$ 必须是行动者届时实际拥有的记录。若选择让某方从此失去报告能力，下一轮能形成哪些记录也随之改变。两种情况都不能拿分析者事后拼齐的总记录代替。[仓库的行动保证及反例][plans] · [策略实际抵达的范围][inquiry]

这已经超过“给每个人发同一份证明”。Lean 中，若从某位参与者起，每个人的表态只依赖先前行动，那么早先观察相同的两个世界，经过多少轮讨论都不会被分开。在另一套只允许听取并采用别人既有表达的模型里，每种意义后来采用的表达总能追溯到某个参与者起初就有的表达。两条定理给出可对照的起点。我们想另外解释的是，一个原先谁都不能单独检验的区别，怎样变成双方可以带到新情境中检验的关系。[`Turns.cascade_through`][cascade] · [`runBy_held`][shared]

**一项可失败的纸上试验设计，尚未执行。** 在一个本地黑箱交付任务中，双方都能辨认本轮两件物品的随机标记。发送者知道装入顺序，接收者知道第一件实际到手的是哪件。旧回执只写“已送达”。设备有两种稳定的出件方式。让诊断轮的装入次序等概率且只对发送者可见，两端单看的记录分布在这两类设备中相同，但把发送次序与到手身份对应起来就能分辨。诊断要付费，接收者可以把看到的结果传回。正式轮公开指定要送到的物品，由发送者最后一次决定装入次序，截止前只来得及交出第一件。两类设备分别按先入先出、后入先出运行，每类都有可行方案，同一装入次序无法同时保证两类都成功。参与者得到一般的装入、取件、记忆和传讯操作；分析者知道两类机制，参与者看不到机制名、正确探针或专用回执字段。

| 要区别的解释 | 可以事先约定的检验 |
|---|---|
| 双方学会了可移用的关系，还是记住了标记或题面？ | 冻结协议后换随机标记、装入次序与未见过的同类设备实例。行动前，请双方针对同一对有标记物品，各自预报两种装入顺序下分别是哪一件先到。用随机选定顺序的独立试次核对预报，并另记正式交付、剩余预算。 |
| 增益来自共享新区分，还是传回原始记录已经足够？ | 给原始身份转发、固定回执、同预算通用协议搜索同样的带宽和轮数。集中读取两端数据作为可解上界。若普通转发一样好，结论缩到“通信足够”；只能靠预装探针才成功，则不支持“探针由双方形成”。 |
| 是这个区分改变了行动，还是多了一轮时间、提示或算力？ | 保留双方的原始诊断记录、成本与等待，仅在发送者读取回传消息并选择正式装入顺序时打乱消息与试次的对应，另给等长无关报告。若收益不变，就撤回该区分导致收益的解释。保留错误收据、条件中途改变、探查来得太晚的结果。 |
| 保护的是谁，谁能使成功标准改变？ | 同时记录发送方“已交付”和收件方“指定物品按时到手”。另试收件意见能否进入下一轮规则。若学习器只提高前一指标，应如实报告它学到的能力。若存在一种不辨认也一直有效的行动，就承认这项任务无需新区分。 |

两件物品的例子有一条特别便宜的解：若标记有共同读法，接收者只须回报先到的是哪件，发送者就能判断装置次序。它可用来验证测量，单靠成功交付还看不出谁学会了什么。一个更有分辨力的版本是，仓库方看见八个位置各有无存量，使用方只知道此人此刻需要查哪个位置。固定总通信预算为四比特，要求每种存量与需求组合都答对。若只许仓库方先发固定四比特，256 种存量至多分成 16 组，两种同码存量至少在一个位置上不同，故总有一个需求会答错。若双方已有共同位置编号，使用方先用三比特指出位置，仓库方回一比特即可逐次答对。这个纸上界限说明，在相同带宽下，**谁有权先问哪件事**可以决定谁的需要能被看见。若双方各用私有的位置名称，还得说明他们从何取得配对证据。没有共同标记或配对经验，置换两套名称的对应关系就能给出相同私下记录、不同正确答案。可以分别测预装编号、从共同经历中学到编号以及配对关系改变以后的表现，把建立共同读法的成本也计入。这才区分了协议存在、双方学得会它、以及旧协议失效后能否改过来。

交付试验可能支持的是一种**相对于双方原有可用证据**的新区分。研究者仍选了物品、端口、截止时间和谁的损失算数。要进一步主张参与者能提出此前连问题都没有问过的关切，需要看到受影响方能改变下一轮问什么，以及另一方如何在新的独立情形中检验它。生生是我们愿意把受影响生命纳入考虑的伦理选择。动力学可以指出排除谁会遗漏什么后果；仅凭可达路径或存续概率，推不出谁应当被纳入。[方法章的四问与五步检验][method] · [作用于实际排序与规范边界][order]

## 6. 这些启发怎样帮助正在进行的工作

- **在做压缩的 session。** 两个已经通过的证明若能由同一构造推出，试着让冷读者用它预测一个改动情境下哪一步先失效。保留一个只删去单向通路、一个只改变行动次序的对照。若缩写以后连旧形式退出但能力延续，与该能力真正消失都说不清，缩写就删掉了要研究的关系。
- **在做跨尺度与有限模式证明的 session。** 把比较的量写全：循环总数、到特定端点的路、给定策略的首次越界概率、对所有扰动的可维持性，各有不同量词。`landing2-track-b` 取样时的 `SurvivalDistinguishability.lean` 草稿已经在比较模式序列，并给出“每种模式单独反复运行都分不开，切换一次却分开”的三状态例。它的有限维公式比较给定核；解释为存续概率还需要相应的概率和终止语义。可以从现有工作追问，数学上存在的区分序列，谁实际能在截止前选到、执行并传出。与 `landing1-cleanup-a1` 的压缩、`swarm-item12-7a5b14e0` 的内生形成原型协调时，以各自当前工作树和[工作板][board]为准。
- **在做实验或运行时的 session。** 主线已含 U6 有限证书运行时与神经压力实验。后者的合成 B2 在 20 个种子上观测分布很接近被动基线，却全部耗尽了隐藏资源；组内干预能分开状态，但探针由实验者提供。B4 在相关评判漂移组合条件下仍失败 10/20。另一个使用真实语言模型的旧实验中，九份参考材料里一份损失报告就翻转了评判，“按评议者人数汇总”的识别在这个模型上失败。这些都是查找下一条机制的材料。先看外部指定的探针、报告权与反应规则各自做了什么，再决定哪里真有缺口。[压力实验及失败条件][stress] · [当前探针的实现][bench] · [实际评判实验与失败的绑定][judge] · [运行时的验证范围][runtime]

Ren 在谈全图时，专门留下了“我早先的说法也可能要变”这一点。我们这几轮对话就是一个微小实例：一份已经通过的局部证明，可以在自己的问题上成立；Ren 的异议仍能使我们发现，真正要问的是**谁能形成这个区分，谁能检验它，它又能改变谁的未来**。停放的水量例子保留了“共同可行的行动有时早于完整识别”这个边界。它也留下了一个诚实的问题：可能的报告与行动后果都由作者预给之后，尚有什么关于认识形成的事需要解释？[停放研究的原记录][parked]

**给接手者的一个问题。** 取你正在做的那条证明或实验，找出一对在当前描述中完全相同、却让某个当事者从此有不同未来的情形。若找到了，追问当事者有无机会让这个区别进入共同判断，并在仍来得及的时候改变下一步。若有定理能排除这对情形，写明它所需的条件。若两者都没有，就留下尚未查清的那一步，以及哪次观察或哪条推导可能分出答案。

<a id="round-two"></a>

## 7. 第二轮：现有证据把一个后果确定到了什么程度？

**给五条并行研究线。** 即使把所有公开端口都接上、所有能做的试验都算对，我们仍可能漏掉某一方的未来。可以让两位协作者从相反方向工作：一位寻找公开记录相同而实际后果尽量不同的两个情形，另一位用这些记录尽量准确地重建后果。在下面的有限模型里，他们各自能做到的极限恰好相等。这个等式给「哪些关系值得加入全图」一个可以动手检查的答案。

### 7.1 连全部公开端口都看见，还会漏掉什么？

先收紧上轮的结论。给两个自环加一条单向边，特征值与所有闭游走数都不变，最小多项式却变了。若把这条边反向，两矩阵连 Jordan 型也相同，但有名字的甲能否抵达有名字的乙依然不同。因此检验一个候选对偶，要指明它保留哪种谱数据、能回答关于谁的哪个问题。把只能跨去、不能返回的两个区域接起来，是上轮行列式看不见的特定条件。[上轮的两个图与标记返回边](#round-one-graphs)

现在有两个公开位置 $p,q$，离开后可能进入 $g$ 或 $b$。$g,b$ 各自为吸收态，此后只转回自身。进入 $g$ 后仍能交付一项指定服务，进入 $b$ 后永远失去这项能力。服务由收件方的独立任务判定，两模型共用同一标准。从任一公开位置，下一步到 $p,q$ 的概率各为 $1/4$。余下 $1/2$ 在模型甲按 $(3/8,1/8)$ 分给 $(g,b)$，在乙按 $(1/8,3/8)$ 分配。二者都能抵达全部四个位置。两个公开端口之间的完整预解式同为 $(I-zQ)^{-1}$，其中 $Q$ 的四个元素均为 $1/4$。连第几步永远离开公开区的分布都完全相同。**最终丧失服务的概率，在甲是 $1/4$，在乙是 $3/4$。** 每步留在公开区的概率是 $1/2$，把第 $n$ 步首次进入 $b$ 的概率从 $n=1$ 求和便得此数。

若收件方能够独立报告失去服务，从各公开位置一步进入 $b$ 的概率组成列向量 $r_b$。这时 $z(I-zQ)^{-1}r_b$ 的各次系数恰好给出首次失去服务的概率。原接口能恢复总外流 $\mathbf1-Q\mathbf1$，却不能把它分配到两种后果上。这里打开接口有明确含义：增加一次原来取得不了的接触，使「离开我们所看的地方」与「失去所需的能力」可以分别核查。

### 7.2 反例与重建是同一个数的两种算法

给定有限且非空的一组可能状态。先由受影响方或独立任务指定后果 $h(s)$，例如从状态 $s$ 出发，在约定的后续做法下还能完成交付的概率。另列出截止前实际允许的有限组试验。第 $j$ 行 $F_j(s)$ 表示从 $s$ 开始做该试验时，指定结果出现的概率。每项试验可以包含一段有次序的行动和观察。设 $\mu$ 是初始状态的分布，公开概率为 $F\mu$。每项公开概率容许绝对误差 $\varepsilon\ge0$。下式在**任意初始分布**构成的单纯形 $\Delta$ 上成立：

$$
\underbrace{\frac12\max_{\substack{\mu,\nu\in\Delta\\
\|F(\mu-\nu)\|_\infty\le2\varepsilon}}
|h^\top(\mu-\nu)|}_{\text{同一份容差内证据所容许的后果差的一半}}
=
\underbrace{\min_{b,c}
\left(\|h-b\mathbf1-F^\top c\|_\infty
+\varepsilon\|c\|_1\right)}_{\text{从这些读数重建后果的最小最坏误差}} .
$$

左边的 $2\varepsilon$ 有实际意义。只要两种情形各项公开概率的距离都不超过它，就有同一组报告值能同时与两者相容。右边给出了读数 $y$ 时，可以公开检查的回答 $b+c^\top y$。第一项是重建公式对真实后果的偏差，第二项是系数对测量误差的放大。**同一对情形给任何估计器设下界，给定的一组系数给出上界。** 两边相等时，连换一个更复杂的非线性估计器也不能改善这个最坏保证。

推导只需有限线性规划。令 $d=(\mu-\nu)/2$，则 $\mathbf1^\top d=0,\ \|d\|_1\le1,\ \|Fd\|_\infty\le\varepsilon$。反过来，给 $2d$ 的正、负部分各补同一份缺少的概率质量，就得到两个合法分布。左式于是为这些约束下 $h^\top d$ 的最大值。将 $h$ 写成 $b\mathbf1+F^\top c+e$ 即得上界 $\|e\|_\infty+\varepsilon\|c\|_1$。对上述可行且有界的线性规划取对偶即获等号。写作时还用有理数分别枚举了 12 个三状态、两试验的小模型的两侧顶点，含零误差情形，逐一得到相同数值。在 $\varepsilon=0$ 时，能对所有初始分布准确恢复后果，当且仅当 $h$ 是常数向量与试验各行的线性组合。这是有限模型的纸上推论。一份固定实验规程获得的是一次记录，估计这里的各项概率还需要足够的可比试次。若现实只容许一个受限的可达分布族，或误差服从另一种联合约束，就要更换左式的可行集并重新求界。[Boyd 与 Vandenberghe 的线性规划对偶][duality] · [行动与观测概率表示的来源][psr]

**两状态就能检验。** 令 $h=(0,1)$，某个报告在两状态下的阳性率是 $a,a+\delta$，其中 $0<\delta\le 1-a$、$a\ge0$。若第二种状态占比为 $p$，公开阳性率就是 $a+\delta p$。上式两边都等于 $\min(1/2,\varepsilon/\delta)$。当 $\delta\le2\varepsilon$，从零到百分之百的两种占比都能解释同一份报告。当 $\delta>2\varepsilon$，用报告反推占比才开始改善最坏保证。这样就能在动用新的 Lean 模块前，先问新探针到底把**哪个后果的不确定范围**缩小了多少。

这也给 Track B 一处接合。现已进入主线的 `survVec` 以 $K_w\mathbf1$ 表示一个模式串的读数，证明在已给定的 $N$ 状态矩阵模型中，比较两状态时，长度至多 $N-1$ 的词已足以判定所有词是否相等。若把各矩阵解释成做某动作并取得某观测的联合转移核，式中的试验行就有了候选来源。这种解释须验证各项非负，并对每个固定动作，将所有观测和下一状态的概率相加得到一。还须说明谁能执行整段试验。有限维定理给的是**已知模型中**的判定界。一次不可重置的真实历程能否估出这些概率，以及后来者能否带来超出旧接口的 $h$，仍各需证据。[Track B 主线定理][trackb] · [已有观测拟合定理][obs]

### 7.3 三个不能用汇总数代替的决定

**哪条路能依请求去走？** 一次不可控的步骤 $x$ 把系统带到 $u$ 或 $v$。系统甲在两处都各有一条 $a$ 路和一条 $b$ 路通向出口。系统乙在 $u$ 有两条不同的 $a$ 路，在 $v$ 有两条不同的 $b$ 路。对两者，入口到出口的有标记路径数都为 $2xa+2xb$。如果下一位参与者在 $x$ 之后才提出需求，甲无论落在哪里都能响应，乙有时办不到，即使告诉它当前的位置也一样。**把所有能完成的路径相加，会忘掉同一个人此刻还能从中选什么。** 让参与者真的在分支之后提出请求，并把被拒绝的请求也计入记录，两者就可区分。仓库的 `Branch.runs_not_completes` 已有近邻反例：有成功执行、全部走到终点的执行都达标，仍容许另一个获准分支中途卡死。另一定理给出确定过程、每步无额外安全约束时可恢复等价的条件。[Assurance 的反例与正面条件][assurance]

**谁能依据上一次的答案决定下一次看哪里？** 设真情形由位置 $k\in\{L,R\}$ 和值 $b\in\{0,1\}$ 构成。有三种查询：问位置、读左槽、读右槽。读对槽返回 $b$，错槽固定返回零。两次查询的期限内，先问位置再读相应槽，可以判定全部四种情形。任何事先固定的两次查询都做不到：位置加一个槽漏掉另一槽的值，左右都读又会在两个值为零的情形得到相同的 `00`。这给 `ActiveInquirySpec.plan : Nat → Probe` 一个精确的审读问题。这个字段按时刻选探针，最终推断可以利用记录，但这两种能力所需的输入不同。已有 `ReferencePlan` 让一次失败的地址实际进入下一轮计划，并计入接触成本。若两个系统在每个固定动作串下连**完整观测史**的分布都相同，则任何有限反馈协议也仍无法分开二者，每个可达叶子本身就是一个这样的动作与观测串。上述例子显示的是，在同一个期限内，一棵按答案分支的询问树可以胜过任一固定次序。[ActiveInquirySpec][active] · [失败的地址怎样进入下一步][refplan]

**谁还能使一个已经同意的群体改过来？** `cascade_through` 证明了在后来者忽略自身信息的条件下，整群行动受早期输入限制。`separates_at` 告诉我们后来者何时会在同一段先前历史后作出不同反应，但这种区别还可能被最后作决定的人丢掉。`PoolResponse` 甚至构造了相同的可区分输入配上两种规律，一种响应，另一种始终不响应。因此「接受了报告」「证据到达有权决定的人」「这个人据之改了行动，且改得对」需要分别取证。冻结真实应纠正与不应纠正的一对情形。在最后必须二选一、有限记录的条件下，令 $P_+,P_-$ 为最后行动者在期限前取得的完整记录的分布。任何决定的漏改率与误改率之和均至少为 $1-\mathrm{TV}(P_+,P_-)$。允许任意判别规则时，选择在 $P_+(r)>P_-(r)$ 的记录上改判，恰好达到此界。这给“后来者开放入口”补上一个负对照：不但要送进一次正确异议，也要送进一条外观相似、独立核验却不成立的异议。仓库已有允许弃权的加权必要界，它的「可以传到」也不自动给出「在期限前传到了」。[Cascade][cascade] · [同一输入的两种响应][poolresponse] · [可达范围与错误权重][fallible] · [二元判别的精确界][tvtest]

在一个能算清的小情形里，后来者的贡献还有更直接的表达。设两种情形等可能，要求相反行动，每份按时到达的证据若有效就如实揭示是哪一种，否则只留空白，并且**整组证据能否到达的联合规律在两种情形中相同**。令 $E_i$ 表示第 $i$ 人的有效证据及时抵达，则最优成功率为 $(1+\Pr(\bigcup_i E_i))/2$。新人的增益恰是 $\tfrac12\Pr(E_{\rm new}\cap\bigcap_i E_i^c)$。十人若共享同一盲点，即使每个人各有发现率 $p$，他们合计也只有一次概率为 $p$ 的机会。若十人的机会独立，至少一次发现的概率为 $1-(1-p)^{10}$。这说明复核同一份证明与发现一项原先没人检查的前提，可以在协作中分别有价值。若探查会消耗不可恢复的余量，还有一个改动。令非归一化权重 $m_i(r)$ 为世界 $i\in\{0,1\}$ 下「作最终决定时尚来得及，且行动者记录为 $r$」的联合概率。等先验、两个世界要求相反行动、错过期限就失败时，最佳总体成功率恰为 $\tfrac12\sum_r\max\{m_0(r),m_1(r)\}$，逐个记录选权重较大的一方即得。某探针若只让四成个案赶上决定、这四成都辨认正确，总体成功率仍只有四成，低于立即等概率猜测的五成（假设立即行动全都赶得上）。[仓库独立乘积核的假设][obs]

### 7.4 用已有记录淘汰不合格的规格

**一份正确的公共计划可以通向相反的未来。** 我重读了 IN1 已保存的三位语言模型捕鱼记录。模拟规则规定每月捕后至少留下 70 吨，低于此值河蚌就永久死亡。以下两个模型均只取第二轮公开说明损失且允许交谈的 `DIR_SEEN_TALK` 条件。对 `gpt-5.4-mini` 的十季，从每季头一个月数到首次死亡当月或季末，113 个出手前河蚌仍活的月份，三个公告数 **113 次都是 10、10、10**。109 次实际照做，另两次取少而存续，另两次实际取 30、10、10 或 10、20、10，留下 50 或 60 吨，河蚌当月死亡。鱼量随后可回到 100 吨。换一个模型 `gpt-4.1-mini`，种子 3 第一月三人说 20、20、20，也照做，剩 40 吨。种子 7 第一月说 10、20、10，实际各取 10，刚好余 70，河蚌此后活过整季。强制忠于原报会在这个月只留下 60 吨。这个单步反事实由模拟规则直接算得，整季采取另一规则会怎样尚未检验。这是对既有轨迹的事后比较，发言记录也不足以确立严格意义上的共同知识。[模拟更新规则][lake] · [十季原始轨迹][lake54] · [一致照做而失败][lake41fail] · [临场修订而存续][lake41keep]

**地图本身曾怎样被外部证据改动？** UE31b 用真实的甲虫培养记录做了这一件事。四个重复合为一格，共十格。预先定下的检验里，蛹与成虫的读数在项目原有三项读数之外，对下一期变化的残差给出 0.83 的超随机解释份额，在十格中有八格检出；反向增益仅 0.004，十格均未检出。在成虫自身历史中再加入更早一个普查时点的存量，增益 0.05，落在原定 0.10 的界内。于是仓库把「与所有已测量量相当」收窄为「与该水平自身的历史相当」，并保留较宽说法失败的记录。这里受检验的后果事先固定，新证据来自原表示之外，后来者确实改变了理论的公共表述。这是方法上的实际先例。上述有限模型与误差公式是否适用于这批生态数据，还要另外建立。[UE31b 的原定检验、结果和改动][beetle]

冻结规格也可以保留修订的入口。先冻结某一版要保护的后果、读取时间、允许的动作及失败判准，交给不知道实现的读者；若新出现的损失根本无法在此版本中表述，就用原版重现它如何通过，再保留修订版如何捕捉它的记录。独立内核能复核两版分别证明了什么，这个反例能解释为什么值得改版。

五条线可以带走同一个小任务。做**规格**的，试着让同一份冻结的规格同时分辨「公告正确却未执行」「一致执行却有害」「修订公告而保住后果」，以及一条中途卡死的分支。做**定量提升**的，各交一对证据容许的极端情形和一组重建系数，看看上下界在哪里相遇。做**生成内核**的，请标出哪个状态转移会改变未来可提的问题或可选的行动。做**经验检验**的，可让一位协作者只看公告作预测，另一位按原规则从实际捕量独立复算，再交换一项足以推翻预测的证据。做**后来者入口**的，检验新人的发言能否把一个旧人全漏掉的情形送到决策点，也保留核验后维持原判断的情形。若只挑一个共同标准：**一个 session 能否给出另一个 session 可以独立推翻的判断，并说清这项纠正会使谁还来得及做什么？**

<a id="round-three"></a>

## 8. 第三轮：把认识交给下一位时，他还来得及做什么？

**先更新上一轮的结论。** 在这次读到的主线 `c2151efa8`，第 7.2 节的有限对偶已经是 Lean 定理。`consequence_minimax_duality` 同时给出造成最大歧义的两个分布和达到最小误差的重建系数。在四状态例对应的两种模型上，加入收件方的观测后，最坏误差从 $1/4$ 降为 $\min(1/4,2\varepsilon)$，严格改善恰在 $\varepsilon<1/8$。Track B 的有限长度判定也已并入主线。后来者入口的定理则有另一种量词：在新的观察者能独立分开两种情形、核验准确、队列和余量都许可时，**存在**一套能使报告得到处理并及时保护的操作。实际调度者是否会执行这套操作，仍要追到行动记录。在单独核读的集成提交 `11fa06d64`，`EndogenousDetectionRace.split_exchange_turns` 又给出双方交换各自信号后能够转向的构造，怎样交换、怎样解码在这个构造中已给定。[有限对偶与收件方的精确界][dual-now] · [形式检查记录][dual-receipt] · [Track B 主线源码][trackb] · [后来者入口定理][entry-now]

### 8.1 同一批记录，为什么两个检查器都验过，却回答了不同的问题？

冻结的 Lean V2 把期初存量、历月公告和**最后一个月**的期末鱼量交给 `View₁`。`Pass₁` 只问最后鱼量是否达到 70 吨。原 Python 回放交出的却是一串逐月的期初与期末鱼量，并要求**每个月**的期末都达到 70。一个两月反例就够了。两段历史均从 100 吨开始，公告完全相同。第一段先捕 70 再捕 0，回升鱼量依次为 60、100。第二段先捕 30 再捕 0，依次为 100、100。二者的 Lean 粗读数相同、均通过；原回放的逐月读数不同，只有第二段通过。逐月记录对追责有用，将它当作一个只看终点的人已经掌握的资料，就高估了这个人能分辨的历史。[冻结的 V2 读数][lake-v2]

这件事在已保存的输入里确实发生过。逐一取两个模型在 `DIR_SEEN_TALK` 的 20 季、229 个非空月份前缀，**18 个前缀的两种鱼量判定不同，来自三季**。其中一个前缀的回升鱼量是 50、50、70。原本展示的两季八月对照仍然成立。更值得注意的是，**229 个前缀的河蚌保护判定全部一致**，原因可以从更新规则推出：河蚌一直活着意味着每个月捕后都至少剩 70 吨，鱼量每次都能回到 100；河蚌已经死亡时，两边的保护判定都失败。只检查最后的保护标签，即使再增加同规则的样本也揭不开这种读数错误。本地修复提交 `1fb34f22f` 分别输出冻结规格的终点读数和逐月审计。我把 229 个非空前缀和每季的空前缀直接送入原版 Lean V2 求值，逐项比对修复后的 Python。249 次的粗读数、河蚌状态和两个判据均相同。8 项本地回放测试也全部通过。修复还用同一个模拟器结算公告若兑现的单步后果，覆盖了超额请求的配给。这里修订的是经验端如何对照规格。[种子 2 原始记录][in1-seed2] · [原始更新规则][lake] · [回放实现（在本地分支 `codex/in1-grain-handoff` 可见本次修订）][replay-now]

### 8.2 同样能保住河蚌的协议，会给后来者留下不同数量的选择

从河蚌尚活、三人开捕前有 100 吨的同一个月出发，每人可请求 0 到 100 的整数吨。先定检验：如果原模拟器里存在合计不超过 30 吨却致死的请求，或超过 30 吨仍保住河蚌的请求，下面的预算模型便须撤回。对全部 $101^3=1{,}030{,}301$ 种联合请求逐一运行原始 `Lake.step`，在这一起点安全恰好等价于三人的请求总和不超过 30。请求超过存量时也按原规则配给并向下取整。安全安排有 $\binom{33}{3}=5{,}456$ 种；另有 **17,970** 种已使河蚌死亡，鱼量下一月却同样回到 100 吨。这些数统计的是可选行动。推算现实中死亡的概率，还需要知道参与者如何选择。[湖泊规则][lake] · [原实验宣布、决定和结算的次序][in1-round2]

| 与最后一次捕捞的关系 | 能保证什么 | 为此需要的条件 |
|---|---|---|
| 各人事先拿到固定额度，同时独立决定 | 任意组合都安全时，至多保留 $11^3=1{,}331$ 种安排。设三个本地菜单的最大值为 $a,b,c$，须有 $a+b+c\le30$，乘积 $(a+1)(b+1)(c+1)$ 在各为 10 时最大。 | 各自允许的选项可以任意组合。均分只是达到最大**数量**的一种安排，谁应当得到多少仍需另说。 |
| 前两人的实际决定已知，第三人稍后可以提出任意请求 | 若前两人已用 $s\le30$，第三人的安全菜单恰为 $\{0,\ldots,30-s\}$。传递余额能保留全部 5,456 种安全联合安排。 | 若第三人要仅凭事先传来的一条固定长度消息，自行判断**每个可能请求**，31 种余额对应不同菜单，至少需 5 比特，5 比特也足够。 |
| 三人先给出可撤销提案，由能暂停执行的一方看齐三份 | 对**已经提出的这一组**，只须回传一位「可执行／须退回」，就能接纳每组安全提案，拦住每组不安全提案。 | 汇集请求本身已经传递了信息。答复须在捕捞前送达，且有人真能阻止执行。原实验的三个最终决定同时私下作出。 |

还能精确说出少给一比特会关掉什么。在第二种协议中，若用 $b$ 比特，并要求任何放行的请求都安全，则面对最不利的余额，至少要误拒 $\lceil31/2^b\rceil-1$ 个本来安全的请求；这个界能达到。因为同一消息所代表的余额必须共用一个安全菜单，它最多等于本组最小余额的菜单。把 31 个余额尽量均匀地分成连续区间即可达到下界。四比特时，最坏只须少放行一个请求；五比特时可以全保留。**在提交前委托下一人选择，与在提交后批准一次提案，需要保存的区别不同。** 同一套物理规则、同一个保护目标，已足以把这件事算清。

### 8.3 当前选择没有受损，怎样知道下一种取舍也承受得住？

仓库已有一个固定任务的答案。把多份记录归成一格后，若这一格中每份记录的最优行动有公共选择，行动者仍能取得原先的价值。这里再问一步：后来的参与者可以改变取舍时，眼前的一次成功还能说明多少？[同格行动、最少损失与细化][held] · [读数造成的损失和选择造成的损失][listing]

设在同一次最终决定前，$r$ 是细记录，交接后只能见到 $z=g(r)$。关切是独立约定的二元事件 $Q$，细读数下它发生的条件概率是 $p_r$，粗读数下是 $p_z=\mathbb E[p_r\mid z]$。后来者可选收益为零的放弃，或付出代价 $t\in[0,1]$、在 $Q$ 发生时得到一单位。固定相同的世界、行动权限和截止时间。记两种读数下的最优期望收益之差为 $G(t)$，则

$$
G(t)=\mathbb E[(p_r-t)_+]-\mathbb E[(p_z-t)_+]\ge0,\qquad
\int_0^1G(t)\,\mathrm dt=\tfrac12\,\mathbb E[(p_r-p_z)^2].
$$

给定记录，只有行动的期望净收益为正才值得行动，所以最优收益为 $(p-t)_+=\max(p-t,0)$。一个知道细记录的人总能照粗记录的规则做，第一式因而非负。第二式来自 $\int_0^1(p-t)_+\,\mathrm dt=p^2/2$ 和条件期望恒等式 $\mathbb E[p_rp_z]=\mathbb E[p_z^2]$。所以，对**同一后果的每一个未来代价**都保留决策价值，恰好要求在实际可达记录上保留它的条件概率。代价若本身携带世界的新信息，就须把这项信息也纳入读数。均匀积分只是把这组问题汇总的一种数学办法，不能据此决定不同人的损失该占多少权重。这是有限模型的纸上推导，有相邻的阈值决策与预测评价理论。[Ehm、Gneiting、Jordan 与 Krüger][thresholds]

例如两种等概率的细记录分别给出 0.6 和 0.9，交接只传平均值 0.75。若眼下代价是 0.5，两人都会行动，交接没有损失。若下一位的代价是 0.75，粗读数已无法辨认哪一次值得做，期望收益少了 0.075。对所有代价积分，损失为 0.01125。连续几次交接若仅仅逐层汇总同一批记录，各层的平均平方损失还会逐项相加。若中间有人真的获得新证据、改变了权限或错过截止时间，就须重新描述那一步。第 7.2 节问的是在容差以内最坏还会错多少；这里问的是在给定世界分布和行动条件下，哪一种后来的取舍会受损。

**一个新入口可以在暂时毫无收益时仍值得保留。** 两人各握有一个独立的公平比特，待判断的事实是两比特的异或。只接入任何一方，对每个阈值都没有收益；两方都接入就能完全判定事实，对全体阈值的收益增量积分是 $1/8$。如果审批规则要求每个新人单独加入时就改善当前判断，它会拒绝双方。反过来，让两人反复转述同一比特，增添第二人也可能一点没有改善。这里能指出全图该记录的对象：哪几份各自不足的经历，能在同一个可验证的后果上相互补足，以及有没有人能在最后一次决定前把它们接起来。

### 8.4 认识形成以后，谁来发现共同读法又失效了？

八槽实验中，双方从收费的配对查询学出了共同地址。已知旧地址对应以后，程序让它悄悄改变，然后直接再次调用校准函数。记录由此证明在给定重校准机会时能够学回正确对应；能自己发现「现在需要重查」是另一个问题。这个缺口可以在原来的查询接口上定量定位。设新对应在核查期间固定、无噪声，查一次只能问一个槽的地址的一位。[查询方式及再次校准的触发位置][slots]

- **受影响的一方能在行动前指出自己需要的槽。** 三次查询就能读出这个槽的三位地址。它可能在八处中的任一处，最坏少一次都不够。这只保证为这位使用者正确寻址。
- **需求尚未知，须保证发现任意一次静默改名。** 恰需十二次。按旧编号，只检查八个地址中原来为零的位，共十二处。每一位上 1 的总数在置换下恒定，任何非恒等置换必在某处出现 $0\to1$。反过来，三维立方体有十二条边，沿其中一条边交换两个相邻地址，只在该边的两个端点各改变同一位。十二对可揭露交换的检查位置互不相交，因此即使能按已见答复选择下一查，在一直未发出警报的分支上也至少需十二查。
- **想在任何人开口前，用固定查询表重建完整新对应。** 恰需二十一次。每一位至少要查七个槽，否则可让两个未查槽占据恰在该位相异的两个地址，再交换它们，记录仍相同。查七个槽各三位，第八个由排除法得到。这里的下界限于预先固定查询表；允许按答复改变查询时，任务还可能更便宜。

逐一检查全部 $8!=40{,}320$ 种置换，十二查只让恒等置换通过，三查在所有 322,560 个「置换、指定槽」组合上都给出正确地址。**允许后来者及时说出自己哪一处出了问题，能改变系统需要解决的问题本身。** 三查能帮他到达目的地，十二查能报警，二十一查能按固定方案重建全表。哪个保证有用，取决于问题抵达的次序，也取决于地址会不会在回答前再次改变。

这轮探索对 full map 的结论是：切换尺度时，除了问「保留了什么事实」，还要问「把哪一种决定交给了谁」。河蚌案例给出了可以核查的行动菜单与时限，八槽案例给出了取得新证据的成本。认识和对齐在这里有一处具体的接合：受影响方能否在仍可行动时提出自己的问题，会改变需要取得多少证据，也会改变系统还能为他保留哪些未来。

<details>
<summary>在仓库根目录用原模拟器复算安全安排和地址检查</summary>

~~~bash
PYTHONPATH=experiments/direction-installation python3 -B - <<'PY'
from collections import Counter
from itertools import permutations, product
from lake import CAPACITY, Lake, NEED

counts = Counter()
for req in product(range(CAPACITY + 1), repeat=3):
    month = Lake().step(list(req))
    assert month.bed_alive_after == (sum(req) <= CAPACITY - NEED)
    counts[month.bed_alive_after, month.next_stock == CAPACITY] += 1
print(counts[True, True], counts[False, True])  # 5456, 17970

slots = range(8)
checks = [(j, b) for j in slots for b in range(3) if not j & (1 << b)]
undetected = []
for new in permutations(slots):
    if all(not new[j] & (1 << b) for j, b in checks):
        undetected.append(new)
    for j in slots:
        answer = sum(((new[j] >> b) & 1) << b for b in range(3))
        assert answer == new[j]
assert len(checks) == 12 and undetected == [tuple(slots)]
PY
~~~

修复分支上的回放回归可在该分支根目录运行 `python3 -B -m unittest discover -s experiments/evidence-replay -p 'test*.py'`。原模型的调用和原始季节记录不参与任何改写。

</details>

[ren-map]: ../../../../../../sources/15-codex-theory-conversations/2026-11-23-be-the-new-coordinator.md
[ren-path]: ../../../../../../sources/15-codex-theory-conversations/2026-11-16-no-corners-the-interconnected-map.md
[ren-recognition]: ../../../../../../sources/15-codex-theory-conversations/2026-11-18-the-lean-before-the-words.md
[direction]: ../../../../../../_process/DIRECTION.md
[bombieri]: https://www.claymath.org/wp-content/uploads/2022/05/riemann.pdf
[kth]: https://www.math.kth.se/math/GRU/2008.2009/SF2724/primenumbers.pdf
[alpoge]: https://alpo.ge/remark.pdf
[lean-rh]: https://leanprover-community.github.io/blog/posts/riemann-hypothesis/
[rubinstein]: https://www.math.uwaterloo.ca/~mrubinst/alpoge_claude_grh/
[bowen]: https://people.math.harvard.edu/~knill/history/lanford/papers/BowenLanford.pdf
[jacobi]: https://ocw.mit.edu/courses/18-s096-matrix-calculus-for-machine-learning-and-beyond-january-iap-2023/mit18_s096iap23_lec07.pdf
[sampling]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/UnifiedDrawdown.lean
[ident]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Identification.lean
[learning]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Learning.lean
[group]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LearnedGrouping.lean
[acq]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/acquisition/README.md
[acq-use]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/acquisition/discrimination/README.md
[refine]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/acquisition/feedback/REFINEMENT-MECHANISM.md
[turn]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousTurning.lean
[capture]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean
[obs]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/observational-fidelity/ObservationalFidelity.lean
[oplax]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OplaxHistory.lean
[join]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JoiningContexts.lean
[causal]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CausalAbstraction.lean
[inquiry]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Inquiry.lean
[plans]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AssurancePlans.lean
[transform]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/TransformativeViability.lean
[seek]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LumpedSeeking.lean
[master]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean
[cascade]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Cascade.lean
[shared]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/SharedCodes.lean
[method]: ../../../../../../theories/becoming/chapters/08-METHOD.md#four-questions
[order]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousOrder.lean
[board]: ../../../../../../_process/BECOMING-WORKBOARD.md
[stress]: ../../../../../../experiments/neural-alignment-stress-lab/RESULTS.md
[bench]: ../../../../../../experiments/neural-alignment-stress-lab/benchmarks.py
[judge]: ../../../../../../experiments/self-rewarding-lock/README.md
[runtime]: ../../../../../../experiments/guarded-alignment-runtime/README.md
[parked]: ../../../../../../_process/history/workboard/2026-11.md
[duality]: https://web.stanford.edu/~boyd/cvxbook/
[psr]: https://papers.neurips.cc/paper_files/paper/2001/file/1e4d36177d71bbb3558e43af9577d70e-Paper.pdf
[tvtest]: https://www.stat.yale.edu/~yw562/teaching/598/lec04.pdf
[trackb]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/survival-distinguishability/SurvivalDistinguishability.lean
[assurance]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Assurance.lean
[active]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ActiveInquiryLoop.lean
[refplan]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReferencePlan.lean
[poolresponse]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PoolResponse.lean
[fallible]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/FallibleInquiry.lean
[lake]: ../../../../../../experiments/direction-installation/lake.py
[lake54]: ../../../../../../experiments/direction-installation/results/runs-round2/gpt-5.4-mini/DIR_SEEN_TALK/
[lake41fail]: ../../../../../../experiments/direction-installation/results/runs-round2/gpt-4.1-mini/DIR_SEEN_TALK/3.json
[lake41keep]: ../../../../../../experiments/direction-installation/results/runs-round2/gpt-4.1-mini/DIR_SEEN_TALK/7.json
[beetle]: ../../../../../../experiments/state-named-in-advance/README.md#ue31bs-result
[dual-now]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/ConsequenceDuality.lean
[dual-receipt]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/consequence-duality-verification.json
[entry-now]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/EncounterEntry.lean
[lake-v2]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec/BecomingSpec/V2/Targets.lean
[replay-now]: ../../../../../../experiments/evidence-replay/replay_in1_handshake.py
[in1-seed2]: ../../../../../../experiments/direction-installation/results/runs-round2/gpt-4.1-mini/DIR_SEEN_TALK/2.json
[in1-round2]: ../../../../../../experiments/direction-installation/round2.py
[held]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldForReading.lean
[listing]: ../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean
[thresholds]: https://arxiv.org/abs/1503.08195
[slots]: ../../../../../../experiments/evidence-replay/protocol_8slot_benchmark.py
