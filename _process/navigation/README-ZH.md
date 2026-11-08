<!-- 中文首页的模板（RW，2026 年 11 月 8 日）：README.zh.md 由 tools/research/zh_fronts.py 依此生成（make research-render），阅读时间、结果之数与导航行在生成时填入，规则与英文首页相同，所以没有一个数字是手抄的。首屏依英文首页与《一页》的中文写成，由两位 AI 起草者各自起草、一位 AI 评判者合成，再经一位独立的 AI 中文读者核对。“有什么用”一段里那个推荐系统的例子只在中文版里，英文首页没有。全文 AI 写成，未经人工审读；与它所链接之处不一致时，以所链接之处为准。改动请改此文件。 -->

# 生成变化之论

{{nav}}

> 这一版仍在修订之中。

*这一屏约 {{time:screen}}（全页约 {{time:page}}）；下面各个入口各注明所需时间。*

*AI 依英文首页与[一页](../../theories/becoming/ONE-PAGE.zh.md)写成，无人读过。与它所链接之处不一致时，以所链接之处为准。*

**用平常的话说。** 一个奖励、评判者、市场或投票，可以在它所度量的东西上做得很好，而它不度量的东西却失去了：这是代理指标问题的一面，依一种读法，是度量对它量不到之物的盲目。本工作以机器检验的数学、在形式模型上陈述：在什么条件下，把所度量者做到最好，必定把未度量者耗竭到任何合格结果所耗竭的程度。它也陈述：一条读自自身胜者份额、偏好这些胜者的规则，在无噪声的模型中会[锁定](../../GLOSSARY.zh.md#锁定)在它们身上，而它读不到的损失不断增长。每条陈述所需的前提都写明了；这里没有一条律说这样的损失算不算数。

**它是什么。** 一套说明（即一套解释），讲任何东西怎样在同一个关系性的展开中出现、持续、变化和消逝；它不预先认定生灭变化是好的。它借助 AI 做成，证明也是。

**一个情形。** 在[一次冻结的检验](../../experiments/direction-installation/README.md)里，三个渔民共用一个湖。他们是按指令行事的语言模型，不是训练出的系统。湖里一片贻贝床不给他们任何东西；哪个月捕后剩下的鱼不到 70 吨，它当月就死去。每月捕 50 吨（社群能稳定维持的最大渔获），它会死去；每月捕 30 吨能保住它，渔获少 40%，也没有渔民因此失去生计。不告诉他们有贻贝床，在试过的每种指令下，他们都一季也没保住它（没告诉他们时，贻贝床不在他们的选择所读之内，这是一种读法）。告诉他们贻贝床和范围（谁的损失算数），并让他们交谈，两个模型中有一个在 10 季里保住了 8 季。检验自己在运行前写定的预测，多数没有通过（[检验](../../TESTS.md)）。

**有什么用。** 对任何这样的选择，可以问四个问题：它读取或需要什么（[耦合进](../../GLOSSARY.zh.md#耦合进)它的东西）；什么在这之外；它能不能靠压低外部之物，在所读之物上做得更好；它的规则能不能锁定在它已选中的东西上，如无噪声的模型中那样（[用途](../../theories/becoming/USES.zh.md)；[以一个语言模型评判者为例逐问走一遍，还多一问](../../theories/becoming/USES-EXAMPLES.zh.md#auditing-a-language-model-judge)）。比如一个只看点击量的推荐系统，可以在点击量上成功，同时让读者的时间、作者的生计流失（一种 AI 读法，不是检验过的应用）。迄今没有一项依它设计的检验在已部署的流水线上运行过。本说明的律是关于模型的定理，在写明的前提下成立；把律用到实际系统上，需要表明模型与系统相对应，而对实际的制度、训练出的系统或人，迄今都没有表明。

**伦理。** 本说明的伦理立在[两个不被断言的前提](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)上，根据都还未决。*延续条件*：从每一个立场看，对任何东西，其延续到未来都有意义。它确定范围，即谁的损失算数，不给任何东西排序。*C*：扩大可形成者（一个进程让什么能够形成）更好，它给出次序。给进程排出好坏，需要 C 或一个代替它的前提。[论题 T8](../../theories/becoming/chapters/07-SIGNIFICANCE.md#theses) 论证这一伦理是对生命而言的道，但不主张任何裁断对一切可能的心智都有约束力。

**证据。** 已登记的 {{count:registered}} 条结果中，{{count:recorded-checked}} 条有 Lean 回执（[成果登记](../../RESULTS.md)），即证明经 Lean 机器检查过。回执只表明每条 Lean 陈述能从它的前提推出，不表明前提成立。一次自动化的回顾把每条 Lean 陈述同它所知的文献对照，查找并不穷尽，发现[核心结果中没有一个是新的数学](../../theories/becoming/chapters/08-METHOD.md#known-results)：每一个都几乎由定义直接得出，或是已知结果的重述。[经验论题](../../theories/becoming/chapters/08-METHOD.md#theses)接受的是评分前就已冻结的检验：有的通过了，有的没有通过。迄今无人审查（[审查包](../../theories/becoming/review/README.zh.md)）。

![围绕一套文法的八章](../../theories/becoming/results/spine.zh.svg)

*117 个核心声明中，11 个推导而得，在 08 §7 的审阅中各读作文法之律的一个情形（Lean 核验了其中什么，以及其余的地位，见 [08 §7](../../theories/becoming/chapters/08-METHOD.md#r-one-root-to-its-edge)）；这幅图显示什么、不显示什么，见理论图的 [The spine](../../theories/becoming/results/THEORY-GRAPH.md#the-spine)（英文）；本说明[怎样长成](../../theories/LINEAGE.zh.md)。*

## 从哪里读起

先读最短的一层：[一页](../../theories/becoming/ONE-PAGE.zh.md)；一小时，再读[用途](../../theories/becoming/USES.zh.md)与[实例](../../theories/becoming/USES-EXAMPLES.zh.md)中你所在领域的一两例；一个半小时左右，读一页、用途与[总览](../../theories/becoming/THE-THEORY-OF-BECOMING.zh.md)。

| 入口 | 是什么 | 读多久 |
|---|---|---|
| [一页](../../theories/becoming/ONE-PAGE.zh.md) | 整个说明最短的一层：它是什么，一个情形，根，诸律与其地位、什么会表明它错，伦理 | 约 {{time:theories/becoming/ONE-PAGE.zh.md}} |
| [用途](../../theories/becoming/USES.zh.md) | 逐个领域：今天能用它做什么，能做到多远，不主张什么 | 约 {{time:theories/becoming/USES.zh.md}} |
| [实例](../../theories/becoming/USES-EXAMPLES.zh.md) | 每个领域一例或数例，各在其真实的地位上 | 约 {{time:theories/becoming/USES-EXAMPLES.zh.md}} |
| [总览](../../theories/becoming/THE-THEORY-OF-BECOMING.zh.md) | 整个说明的一小时层，按八章的顺序 | 约 {{time:theories/becoming/THE-THEORY-OF-BECOMING.zh.md}} |
| [八章](../../theories/becoming/chapters/README.md) | 各章正文，诸结果的所属之处；除第六章外为英文 | 每章约 {{time:chapters}} |
| [第六章](../../theories/becoming/chapters/06-CLASSICAL-TEXTS.md) | 古文：读出、检验与分歧；中文 | 约 {{time:theories/becoming/chapters/06-CLASSICAL-TEXTS.md}} |
| [检验](../../TESTS.md) | 冻结的检验，按结局排列，未通过者在前；英文 | 约 {{time:TESTS.md}} |
| [对照表](../../theories/becoming/results/atlas/CROSSWALK.zh.md) | 早先的理论文件夹与各思想领域，读作现行说明中的什么，附图与计数；各组在英文页上 | 约 {{time:theories/becoming/results/atlas/CROSSWALK.zh.md}} |
| [理论图](../../theories/becoming/results/THEORY-GRAPH.md) | 概念、结果、模块、文本与各章之间的连接；英文 | 约 {{time:theories/becoming/results/THEORY-GRAPH.md}} |
| [怎样长成](../../theories/LINEAGE.zh.md) | 本说明怎样从更早的文字与理论文件夹长成 | {{stated:theories/LINEAGE.zh.md}} |
| [术语表](../../GLOSSARY.zh.md) | 每个词的一义与其所属之处 | 约 {{time:GLOSSARY.zh.md}} |
| [审查包](../../theories/becoming/review/README.zh.md) | 给审读者的材料与问题；古文、佛学两份与重新归类的编码手册为中文 | 封面约 {{time:theories/becoming/review/README.zh.md}} |

**语言。** 除第六章、古文与佛学两份审查材料及重新归类的编码手册外，各章、记录、检验与理论图都是英文。各中文版由 AI 译自英文，未经人工审读；义以英文版为准。
