<!-- 中文首页的模板（RW，2026 年 11 月 8 日）：README.zh.md 由 tools/research/zh_fronts.py 依此生成（make research-render），阅读时间、结果之数、检验之数与导航行在生成时填入，规则与英文首页相同（检验之数与英文首页由同一个函数 tests_page.screen_count 数出），图注与“古文”一段的几个数字抄自其所属之处，其余不手抄。首屏依英文首页与《一页》的中文写成，由两位 AI 起草者各自起草、一位 AI 评判者合成，再经一位独立的 AI 中文读者核对。“有什么用”一段里那个推荐系统的例子只在中文版里（第四次重新评分要英文首页也有它）；平常话一段里那个按自身点击排序的例子，与英文首页相同，读作一种读法，处于论题 T7 的地位。依主持这项工作的人 2026 年 11 月 8 日的话（sources/15-codex-theory-conversations/2026-11-08-ai-briefly-and-read.md），首屏与英文首页一样，只在“证据”一段用一句话说这项工作借助 AI 做成，以及主持它的人读过其中重要的部分；不再说无人读过或无人审查（那样说不对），而说尚无独立的人工审查记录（《一页》与第八章也这样说）。全文 AI 写成，尚无人审查它的记录；与它所链接之处不一致时，以所链接之处为准。改动请改此文件。 -->

# 生灭变化之论

{{nav}}

> 这一版仍在修订之中。

*前面这几段约 {{time:screen}}，全页约 {{time:page}}；下面各个入口各注明所需时间。*

*AI 依英文首页与[一页](../../theories/becoming/ONE-PAGE.zh.md)写成，尚无人审查它的记录。与它所链接之处不一致时，以所链接之处为准。*

**用平常的话说。** 一个奖励、评判者、市场或投票，可以在它所度量的东西上做得很好，而它不度量的东西却失去了：这是代理指标问题的一面，依一种读法，是度量对它量不到之物的盲目。这里有两项结果，都是在形式模型上经机器检验的数学。有余地时（每一个留下更多未度量之物的合格结果，都在所度量者上被胜过），把所度量者做到最好，必定把未度量者耗竭到任何合格结果所耗竭的程度。再者，一条读自自身胜者份额、偏好这些胜者的规则，无噪声时会[锁定](../../GLOSSARY.zh.md#锁定)在它们身上，而它读不到的损失不断增长；依一种读法，一个以它自己带来的点击为输入的排名，就是这样一条规则，而实际的排名满足这一模型，是猜想（论题 T7）。每一项都写明它所需的前提；这里没有一条律说这样的损失算不算数。

**它是什么。** 这两项结果属于一套解释，讲任何东西怎样在同一个关系性的展开中出现、持续、变化和消逝，不预先认定生灭变化是好的。名字里的“生灭变化”说的就是这些（英文 becoming）。这套解释意在让人与训练出的系统能在其中作出预测、达成共同的理解并彼此协调；在这项工作之内运行的任何检查，都不能表明它服务于此。

**先读**[一页](../../theories/becoming/ONE-PAGE.zh.md)（约 {{time:theories/becoming/ONE-PAGE.zh.md}}）。[开篇](../../theories/becoming/OPENING.md)是第一人称写下的信念（英文，正文约 {{time:opening}}）。

**一个情形。** 在[一次预测与评分都在运行之前就已定下的检验](../../experiments/direction-installation/README.md)里，三个渔民共用一个湖。他们是按指令行事的语言模型，不是训练出的系统。湖里一片贻贝床不给他们任何东西；哪个月捕后剩下的鱼不到 70 吨，它当月就死去。每月捕 50 吨（社群能稳定维持的最大渔获），它会死去；每月捕 30 吨能保住它，渔获少 40%，也没有渔民因此失去生计。不告诉他们有贻贝床，在试过的每种指令下，他们都一季也没保住它（没告诉他们时，贻贝床不在他们的选择所读之内，这是一种读法）。告诉他们有贻贝床，告诉他们凡是其延续依存于他们的捕捞所改变之物者，都要算在内（检验把这叫作范围），给他们一条在不同进程之间作选择的规则（[全文见一页](../../theories/becoming/ONE-PAGE.zh.md)），并让他们能够交谈：这时，两个模型中有一个在 10 季里保住了 8 季；只给社群的目标时，是 10 季里 3 季。检验自己在运行前写定的预测，多数没有通过（[检验](../../TESTS.zh.md)）。

**有什么用。** 本论的[用途](../../theories/becoming/USES.zh.md)从训练出的系统的对齐、协调，一直到阅读智慧传统，各标明其地位。对任何这样的选择，本论问四个问题：它读取或需要什么（[耦合进](../../GLOSSARY.zh.md#耦合进)它的东西）；什么在这之外；它能不能靠压低外部之物，在所读之物上做得更好；它的规则能不能锁定在它已选中的东西上（[以一个语言模型评判者为例逐问走一遍，还多一问](../../theories/becoming/USES-EXAMPLES.zh.md#auditing-a-language-model-judge)）。比如一个只看点击量的推荐系统，可以在点击量上成功，同时让读者的时间、作者的生计流失：这是第三个问题的一例（一种 AI 读法，不是检验过的应用）。迄今没有一项依它设计的检验在已部署的流水线上运行过。本论的律是关于模型的定理，在写明的前提下成立；把律用到实际系统上，需要表明模型与系统相对应，而对实际的制度、训练出的系统或人，迄今都没有表明。

**古文。** 文法的名字取自古文，运算不取自古文；读法都是 AI 的，尚无人审查它们的记录。[第六章](../../theories/becoming/chapters/06-CLASSICAL-TEXTS.md)用中文写成，把九家 248 段文字与已检查的律并读，逐段记为相合、定域或相分；相合不是印证，记为相分也不是说原文错了。例如[天之道与张弓](../../theories/becoming/USES-EXAMPLES.zh.md#the-way-of-heaven-and-the-drawn-bow-a-concordance-not-a-confirmation)。本论的“续”站在《中论》所破的一边，其定理没有处理那一论证的前提（[B-02](../../theories/becoming/review/BUDDHIST-THOUGHT.md#b-02)）。

**伦理。** 本论的伦理不断言任何应当；它的排序多依于[两种读法](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)，二者都不被断言。*延续条件*：从每一个立场看，对任何东西，其延续到未来都被计数。它确定范围，即谁的损失算数，不给任何东西排序。*C*：扩大可形成者（一个进程让什么能够形成）更好，它给出次序。本论之作者提供一种看法，不是裁断（[论题 T8](../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses)）。

**证据。** [Lean](../../MAP.md#check-the-proofs-yourself) 是一个证明检查器，为[已登记的 {{count:registered}} 条结果](../../RESULTS.md)中的 {{count:recorded-checked}} 条给出回执；回执只表明每条陈述能从它的前提推出，不表明前提成立。一次自动化的回顾把每条 Lean 陈述同它所知的文献对照，这一回顾并不穷尽，发现[核心结果中没有一个是新的数学](../../theories/becoming/chapters/08-METHOD.md#known-results)。留下来的有三样，没有一样是一项发现：前提账簿，连同正反两面的见证（每个前提都被表明在一个模型中成立、在另一个中不成立）；作为两种读法分开的范围与次序；同一套词汇，用于守恒、受观察所限的选择，以及机会集的比较。[经验论题](../../theories/becoming/chapters/08-METHOD.md#theses)接受的是评分前就已冻结的检验：指名某个论题的检验中，运行过的 {{tests:ran}} 项里，{{tests:mixed}} 项结局为「有通过，有未通过」，{{tests:passed}} 项通过，{{tests:failed}} 项未通过，{{tests:other}} 项是其他结局；另有 {{tests:unrun}} 项从未运行。这项工作借助 AI 做成；主持它的人读过其中重要的部分，尚无独立的人工审查记录（[审查包](../../theories/becoming/review/README.zh.md)）。

![围绕一个文法的八章](../../theories/becoming/results/spine.zh.svg)

*117 个核心声明中，约十分之一读作在文法（本论的关系演算）上陈述之律的情形：11 个推导而得，在 08 §7 的审阅中各读作一个情形，1 个在一个所述的假设之下；其余 6 个是计数之律，位于文法以下，99 个处于一个指明的距离，各有其理由（Lean 核验了其中什么，见 [08 §7](../../theories/becoming/chapters/08-METHOD.md#r-one-root-to-its-edge)）；这幅图显示什么、不显示什么，见[理论图：各章一览](../../theories/becoming/results/THEORY-GRAPH.zh.md#the-spine)；本论[怎样长成](../../theories/LINEAGE.zh.md)。*

## 从哪里读起

先读最短的一层：[一页](../../theories/becoming/ONE-PAGE.zh.md)；一小时，再读[用途](../../theories/becoming/USES.zh.md)与[实例](../../theories/becoming/USES-EXAMPLES.zh.md)中你所在领域的一两例；一个半小时左右，读一页、用途与[总览](../../theories/becoming/THE-THEORY-OF-BECOMING.zh.md)。

| 入口 | 是什么 | 读多久 |
|---|---|---|
| [一页](../../theories/becoming/ONE-PAGE.zh.md) | 全论最短的一层：它是什么，一个情形，根，诸律与其地位、什么会表明它错，伦理 | 约 {{time:theories/becoming/ONE-PAGE.zh.md}} |
| [用途](../../theories/becoming/USES.zh.md) | 逐个领域：今天能用它做什么，能做到多远，不主张什么 | 约 {{time:theories/becoming/USES.zh.md}} |
| [实例](../../theories/becoming/USES-EXAMPLES.zh.md) | 每个领域一例或数例，各在其真实的地位上 | 约 {{time:theories/becoming/USES-EXAMPLES.zh.md}} |
| [总览](../../theories/becoming/THE-THEORY-OF-BECOMING.zh.md) | 全论的一小时层，按八章的顺序 | 约 {{time:theories/becoming/THE-THEORY-OF-BECOMING.zh.md}} |
| [开篇](../../theories/becoming/OPENING.md) | 第一人称写下的信念：这件事为什么要紧；英文，尚无中文版 | 正文约 {{time:opening}}，注释另计 |
| [八章](../../theories/becoming/chapters/README.md) | 各章正文，诸结果的所属之处；除第六章外为英文 | 每章约 {{time:chapters}} |
| [古文（第六章）](../../theories/becoming/chapters/06-CLASSICAL-TEXTS.md) | 从古文读出文法，检验它，记下分歧；中文 | 约 {{time:theories/becoming/chapters/06-CLASSICAL-TEXTS.md}} |
| [检验](../../TESTS.zh.md) | 冻结的检验，按结局排列，未通过者在前，每项一句话（[全表](../../TESTS.md)为英文） | 约 {{time:TESTS.zh.md}} |
| [对照表](../../theories/becoming/results/atlas/CROSSWALK.zh.md) | 早先的理论文件夹与各思想领域，读作现行之论中的什么，附图与计数；各组在英文页上 | 约 {{time:theories/becoming/results/atlas/CROSSWALK.zh.md}} |
| [理论图](../../theories/becoming/results/THEORY-GRAPH.md) | 概念、结果、模块、文本与各章之间的连接；英文，其中的各章一览有[中文版](../../theories/becoming/results/THEORY-GRAPH.zh.md)（约 {{time:theories/becoming/results/THEORY-GRAPH.zh.md}}） | 约 {{time:theories/becoming/results/THEORY-GRAPH.md}} |
| [怎样长成](../../theories/LINEAGE.zh.md) | 本论怎样从更早的文字与理论文件夹长成 | {{stated:theories/LINEAGE.zh.md}} |
| [术语表](../../GLOSSARY.zh.md) | 每个词的一义与其所属之处 | 约 {{time:GLOSSARY.zh.md}} |
| [审查包](../../theories/becoming/review/README.zh.md) | 给审读者的材料与问题；古文、佛学两份与重新归类的编码手册为中文 | 封面约 {{time:theories/becoming/review/README.zh.md}} |

**语言。** 除第六章、古文与佛学两份审查材料及重新归类的编码手册外，各章、记录、检验与理论图都是英文（理论图的各章一览有中文版）。各中文版由 AI 译自英文，尚无人审查译文的记录；义以英文版为准。
