# 给 Ren：AG 审查改了什么，等你读什么

AI 撰写（Claude Opus 5.5，AG 审查的协调会话），2026 年 11 月 10 日。依据是你 11 月 9 日的十二条话（[原文](../../../../../../sources/15-codex-theory-conversations/2026-11-09-agents-the-map.md)）、新的 [AGENTS.md](../../../../../../AGENTS.md)，以及你 11 月 10 日在 ED6 会话里说的"widening is better 不是该走的路，要让诸动力相连、成图、统一"（原文随 ED6 落地，存于 sources/15-codex-theory-conversations/2026-11-10-dynamics-connected-mapped-unified.md）。审查共九轮文本修订，外加一轮收尾。每轮由各页的修订者改，验证者对照 Lean 和主页逐句核对。每轮之后由完整性批评者检查遗漏。冷读共五轮，读者是 Fable 和 astra。各轮记录在 [review/](review/) 里。

先列已经改了、可以撤回的几项，再列只提了建议、等你决定的几项。然后是审查中浮现、尚未回答的问题，最后是留给下一步的 Lean 文档注释。

## 一、已经改了，可以撤回

这几项属于 AI 写的文本，所以直接改了。每项都写明怎样撤回。

1. **C 的中文名改为「广者居上」。** 原名「以广为愈」是 AI 在 RA（0d7a397a5）中造的，你的话里从没有过。这个名字说的是"更好"，而你 9 日撤回的正是这层意思。现在 06、术语表、各中文门面和数据都用「广者居上」，历史文件和中华本照旧。撤回：把这些当前文件中的「广者居上」换回「以广为愈」。
2. **WHAT-REMAINS 第 1 项。** 原来的结尾是"with the condition and C still named premises"，现在改为"with the continuation condition and C (`Comparison`) each a hypothesis where a theorem takes it"。这一项衡量的东西没有变：五行在根上的陈述。旧句留在该项的括注里。撤回：恢复旧结尾，删去括注。
3. **WHAT-REMAINS 第 6 项下的第五修正案。** 修正案 1 的"永不删"清单，原来被读成每一层都得带上的清单。第五修正案改为：每一项在它所关涉的主张被说出的地方说一次。阅读时间是参考，不是界限，完整表达优先，这里引了你的第 8 条话。修正案 1 原样保留，与第五修正案合读。发布清单的最后一项"两个前提的根据"改说为不寻求生灭变化之外的权威。撤回：删去第五修正案及其前面的一句提示，恢复那一项的旧句（旧句在括注里）。
4. **目标文件中旧框架的句子**（generative-alignment、zero-axiom-session、universal-intelligence-session、theory-of-becoming）。这几个文件的状态都是"unmarked"，由 AI 会话写成、修订；有关的句子出自 AI 的提交，例如 10 月 8 日的 c473972ce，不是你的原话。改的只是这一类句子："both named and neither asserted"、"C needs its own reason"、"C read as widening, which orders"、"normative grounds"/"规范根据"、"premises of positive warrant"、"comparison is a law with 'better' read as widening"，以及 T8 的旧说法"for life, the way is 生生"。另外按 RUNHOLD 写明 LA4 第二阶段处于搁置之中。改法依据的是协调会话的 Fable 读者对照你 10 至 12 条话和 10 日的话所作的核对。旧文和新文逐条对照，列在三张表里：第九轮的 `k9`（[pass9-records.json](review/pass9-records.json)），9b 的 `k9b`（[pass9b-records.json](review/pass9b-records.json)），9d 的 `k9c`（[pass9d-cbetter.json](review/pass9d-cbetter.json)）。例如 universal-intelligence 的"not premises of positive warrant"，现在说成"not premises the positive ground takes (positive-ground-open-futures)"。normative-grounding（10 月 7 日那个目标）没有改，它是否仍算现行目标，由你决定。wisdom-root 的前提接近你 10 月 8 日的原话，所以保留。撤回：按三张表把新文换回旧文。
5. **首屏、USES、MAP、审查包封面和一页纸上的目标，改为 AGENTS.md 原句**："a joint selection that reads beyond its own share and does not come to select for control over its own selection"。AJ 的条件 1 仍作为目标的条件，写在一页纸和 USES 上。撤回：门面上换回 AJ 条件 1 的措辞。这个"两种目标说法"的问题见下面第二节第 3 条。
6. **开篇正文：把 AI 只加了限定语的地方恢复为你第 12 版的原句。** 限定都移进脚注。改正了错误陈述的修订保留不动，例如 11 月 9 日的"bounds 而不是 proves"和"long enough to end it"。恢复了五处：
   - "The rest holds" 前去掉 "in the model,"；
   - "This law, with that one step" 后去掉 "a second reading the work likewise states and does not assert"；
   - "This is a foundation" 一段去掉 "I hold that"，恢复 "and this foundation supplies that too"；
   - 同一段去掉 "a thesis about how coordination forms, not a theorem, and untested here"，这层意思改由脚注 [^guardian] 说明；
   - 正文前那段 374 词的修订账目换成一句话，原文移到 drafts/2026-10-10-opening/README.md。

   撤回：`git diff main -- theories/becoming/OPENING.md` 里正文的这几处，逐处换回。

## 二、等你决定（都没有改）

1. **开篇正文的几句话**，详见 [FOR-REN-opening.md](FOR-REN-opening.md)。每一处都附有推荐措辞和其他读者的措辞：
   - (a)/(c)：第二种读法、"line between good and evil"；
   - (e)：那一步说成"does not assert"；
   - (b)：选择诸律"restate the proxy problem"；
   - (d1)–(d3)：astra 指出的三处说得比结果多的地方，都是你第 12 版的句子。

   正文是你的第一人称，所以一字未动。第九轮冷读中，astra 仍把正文列为它仅有的两项"高"：一是那一步"does not assert"和"second reading"，二是 (d1)–(d3)。它新给了一个 (a4)，把 (a) 与 (c) 合在一起说。Fable 认为正文由你定。
2. **"伦理从延续中生出"里的"生出"。** astra 两轮都建议在第一次出现处说明这个词的意思，或改为"我们从延续出发提出这套伦理"。门面保留你第 9 条话里的 "emerges"。总览说明了它既不是推导，也不是已表明的发展过程。Fable 主张保留。没有改。
3. **AGENTS.md 中的对齐目标**，详见 FOR-REN-opening (f)。AGENTS.md 说"does not come to select for control over its own selection"。AJ5（10 月 29 日）把"control is not selected"换成了条件 1，理由是修订规则的能力有时需要被选择，即"可问责的修订"。条件 1 是：凡塑造规则的能力被选择之处，规则仍读取塑规者份额之外的东西，使那里的损失能扭转它。astra 另提了一种说法，点出了攫取与时间。现在门面一律用 AGENTS.md 的原句。三种措辞并列在 (f) 里，没有推荐。
4. **AGENTS.md 没有提零公理目标。** 看板的 Target、目标文件的"current first priority"和 08 §12 的目标，都是"变化整体的演绎必然性，不加实质公理"。你 10 月 10 日说过 "no axiom part is most important and elegant"。建议在 "What to work on" 里加一句："The deepest line of drawing it further is the whole from no added axiom: becoming, life and evaluation as moments of one unfolding (the target in 08 §12)."
5. **theory-of-becoming.json 的标题** "Theory of Becoming — current first priority"。你 10 月 8 日的原话是 "make it priority"，"first" 是 AI 加的。建议改为 "priority since 8 October 2026"。
6. **看板上 AJ 那一行里的 "named and not asserted"。** 看板的 "The way now" 和 "Purpose first" 已由协调会话依据 AGENTS.md 和你 10 日的话改说，在 main 的 732a43622，并吸收了本审查的草稿；11 月 7 日的旧文移进了看板的历史文件。这一句在 AJ 那一行里，按看板第 4 条规则归 AJ 的持有者，所以仍是一项建议：把 "named and not asserted" 改为"各在定理取用之处作为假设"。
7. **RUNHOLD（11 月 6 日"等第一批读者"）。** Fable 指出，要回答这项工作有没有用，需要在实际系统上做一次可能失败的检验，而 RUNHOLD 会推迟这件事。可以继续暂缓，也可以先放行指名的几项（LA4 第二阶段、TR 的后续阶段）。
8. **USES-EXAMPLES 逐字引用了你 10 月 24 日的英文原话** "to create an alignment that does not make us, humans and ai, to fall into instrumental convergence, or meta-attractor"，标为 "in its author's words"，不署名。这样放在门面上可以吗？
9. **OPENING.md 第 3 行** 是 "## Truth exists"，按层级应为 "# Truth exists"。这只是标记，但那是你的文本，所以没动。

10. **normative-grounding 目标**（10 月 7 日，"Distinguish warrant, recognition, motivation and actual compliance"）。它的目的是普遍的规范根据，你 10 月 30 日（"there is no absolute universal good vs evil"）和 11 月 9 日（"there is no warrant"）已经放下。这个目标的措辞出自那天 AI 对你的话的解读，状态是"unmarked"。它是继续算现行目标、标记为已放下，还是改说，由你决定，所以本审查没有动它。协调会话的 Fable 读者给出了一种改说法，存于 [review/goals-fable-findings.json](review/goals-fable-findings.json)。

## 三、审查中浮现、尚未回答的问题

冷读者和批评者反复回到下面几个问题。它们是地图的开放处，不是文本的错误。按你 10 日的话，开放的目标不再说成"把扩大排在上面的次序怎样形成"，而是从诸动力来说：范围与次序怎样在动力之内形成，作为与地图其余部分相连的动力；以及哪些动力还没有相连、还没有成图。一页纸、总览和 08 §12 都这样改了说法：

- **自我关切（以及评价）怎样在诸动力之内形成。** 现在各处都说"未表明"：持存是对已作出的选择的筛选，不形成次序（07 §4.9）。可以接着做的是：RF 的五关系之环（03 §8、§11、§12）里的学习与预测，以及 J2 的"哪些读法持存"。目标见 08 §12 第 12 项。
- **哪些动力还没有相连。** 图谱目前只画出了八个族中两个族（C 与 D）的出口（AA 第二步，TERRAIN），其余六族的出口还没有画出；高阶的动力，比如学习、预测、评价和元吸引子，哪些已作为动力在图上，哪些只作为界限在图上，见 08 §12 与各章"未表明"的清单。
- **哪些差别在何时、以多大强度到达哪一个选择。** 选择诸律说出了一个选择能读到什么，却没有说出读到的强度与时机。
- **相冲突的损失怎样权衡。** 混合的进程"不替任何人权衡"。是谁、按什么标准权衡，留给持有次序的人自己说出。
- **"没有根据"与"要求理由"。** astra 同意第 9–12 条的方向，但提醒：没有生灭变化之外的裁判，不等于不能要求理由。一个承担损失的人可以问，为什么漏掉了这项损失，为什么一项增加算作正面，为什么一个被强加的延续被当作好处。这些问题和回答本身也在生灭变化之内。07 §1 现在允许这样问。
- **下一步最有分量的工作**（astra 与 Fable 都这样看）：把一条路线做实。也就是让一项原先改变不了某个联合选择的损失，及时改变了它的决定或规则，同时让代价、失败和分歧的理由都看得见。这与第二节的 RUNHOLD 一条相关。

## 四、下一步：Lean 文档注释（AG-L）

Lean 文件里有一批文档注释仍是撤回前的框架，例如 "C read as widening … the order is C's and J's"、"never ranks the course actually taken"、"near-definitional by necessity"、"two premises … neither asserted"。按约定，文本修订期间不改 Lean，所以这些作为 AG 落地后的下一步（AG-L）单独认领，带它自己的核心运行。清单见第九轮批评者的 [§6.4](review/pass9-critic.md) 和第八轮批评者的 [§5.4](review/pass8-critic.md)。Lean 的 README 还缺 `Becoming.FromTheDynamics` 和 `Becoming.FallibleInquiry` 两行，也一并补上。

## 推送

推送到公共远端是你的事。协调会话问你，推送是否要等你读过开篇正文的那几句；据它转述，你在 11 月 10 日约 18:30 答"Push first"，原话随它的推送一并存入 sources/。所以次序是：AG 落地，ED6 落地，跑完整的 gate，然后推送并发布 Pages。这份文件里只是建议的各项，在推送时都不会被采用。你读过以后，按你的回答再做一次小的落地和第二次推送。

## 五、落地之后（11 月 10 日晚，AI 撰写）

AG 落地并推送之后，又做了两件事，都按看板认领、由协调会话安排落地次序。

1. **AG-L：Lean 文档注释。** Lean 包里仍是撤回前说法的文档注释、模块说明，以及检查器的范围说明、Lean 包的 README 和 COVERAGE 的两条注，都已改成现在的说法：C 是对次序的一项要求，扩大之序满足 C，"never ranks the course actually taken" 改为"按路径排序的结果不适用于那条进程"，诸如此类。一共涉及 30 个模块。只改了注释，代码一字未动：已用脚本核对，每个改过的文件去掉注释后与原文件完全相同。核心运行在合并后的树上通过，绑定这些模块的 104 条记录已重新绑定到新的收据，并记入 rebinds.jsonl。这一项不需要你决定。
2. **AG-F：门面上的伦理，从动力讲起，那条链只说一次。** 协调会话在推送后的 main 上做了第六轮复评，由七位 AI 评审和一位核对者完成。核对者确认了两项"高"：
   - 首屏的伦理段（393 词）大部分篇幅都在讲自我关切怎样把每一个扩大排在上面；目标和 COLLECTIVE-DIRECTION 还把"以扩大比较诸进程"当作所要的对齐状态的条件。
   - 那条带全部假设的链（"……容纳之对可列入一个有限列表"）在约 45 个文件里重复，首屏上就出现两次。

   依据 AGENTS.md 的"在说出之处说一次"，以及你 10 日的话，门面上的伦理现在只用几句话，先讲动力：生灭变化之外没有应当，也没有凌驾其上的善与恶；伦理从延续中生出；T8 的看法，即看每一个进程取用什么、打开与关上什么、由谁承担，并把永远不会回到造成者身上的损失也算进来。然后只说一次看到了多远：枢纽在模型上、在有限列表上已证明，而且近乎定义；生命是否会形成这种次序，尚未表明。说完给一个指向 07 §4 的链接。完整的范围只留在 07 §4 和它的记录里。

   "以扩大比较诸进程"已从所要的对齐状态里拿掉。目标文件和门面现在只说 AGENTS.md 的那句话，加上 AJ 的前两个条件：规则的控制不被捕获；锁定能及时脱离。扩大仍留在 07 §4.4，作为两个进程之间的一种关系。AJ 计划本身的第三个条件归 AJ 的持有者，没有改，只给它留了一条说明。
   - 撤回目标文件的改动：按 [review/agf-data.json](review/agf-data.json) 里的 `k9f` 表，把新文换回旧文。其中 zero-axiom-session 的目标，你在 10 月 30 日认可过。这次依据你 10 日的话，把它的"where the map and widening are joined, compared by widening"改说为 T8 的看法，并把那条链缩成一句。请你看一下这一处，不同意就撤回。
   - 撤回门面的改动：用 `git revert` 撤回 AG-F 的提交。

   两位冷读者读了新门面。astra 指出一项"高"："关系闭合之处，进程让别的东西付出的代价，能隔着若干环节影响到自身"，会被读成代价按时间顺序传回来。可是这个闭包是把各个时刻的依赖与交换合在一起读的，仓库里有反例（`LatePair`）：相互依存成立，却没有任何东西在时间上影响任何东西。现在改说"跨所有步来读"，并说明代价是否、何时按时间传回属于动力学，见 07 §4.11。Fable 指出，"枢纽已证明"会让人以为证明了一座实质的桥；已加上"近乎定义"。
3. **地形图。** AA 从图谱条目画出了一张地形图（八个族，以及族与族之间已记录的出口；一支箭头是出口的计数，不是一条路线）。它现在放在首屏、一页纸和理论图的最前面，先讲动力，再讲脊梁。中文页暂用英文图，中文图要等第五步的中文族名。
