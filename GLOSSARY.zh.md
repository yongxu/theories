<!-- GLOSSARY.md 的中文版（RW，2026 年 11 月 8 日，AI 译自英文版，未经人工审读）。义以英文版为准；英文版改动时，本版随之修订。 -->
# 术语表

[English](GLOSSARY.md) · [首页](README.zh.md) · [一页](theories/becoming/ONE-PAGE.zh.md) · [用途](theories/becoming/USES.zh.md) · [实例](theories/becoming/USES-EXAMPLES.zh.md) · [总览](theories/becoming/THE-THEORY-OF-BECOMING.zh.md) · [第六章](theories/becoming/chapters/06-CLASSICAL-TEXTS.md) · [怎样长成](theories/LINEAGE.zh.md) · **术语表** · [审查包](theories/becoming/review/README.zh.md)

生成变化之论的词语，每一个只有一义、一个所属之处：定义它的那一章的那一节。别处用到一个词，都取这一义，并链接到那里。汉语术语在引入之处释义一次，并附拼音。除第六章外，各章与理论图皆为英文。文法的每一个概念及其 Lean 名称，都列在[理论图](theories/becoming/results/THEORY-GRAPH.md#the-grammars-concepts)中；较早文本所用的标签与现行术语的对照，见[方法一章](theories/becoming/chapters/08-METHOD.md#names)。本页所取代的术语表（规范章的 §10，连同其形式术语索引及其与语料词汇的对照）与该章一同保存在历史之中；九月的语料术语表（192 个词条）保存在[它自己的历史](_process/history/2026-09-consolidation/GLOSSARY.md)中。

## 根

| 术语 | 义 | 出处 |
|---|---|---|
| 际（relation） | 一个载体上的二元谓词，唯一的一种符号 | [第一章 §1](theories/becoming/chapters/01-ROOT.md#one-kind-of-symbol) |
| 缘（condition） | 关系的主要读法：`R x y`，`x` 是 `y` 的缘；也指一个关系项在世界模型中的角色 | [第一章 §1](theories/becoming/chapters/01-ROOT.md#one-kind-of-symbol) |
| 类（class） | 一个等价关系：诸发生在其中相同的那一方面 | [第一章 §2](theories/becoming/chapters/01-ROOT.md#class-and-continuation) |
| 续（continuation） | 一个缘，加上在一个类之下的同一：`y` 在 `E` 下续 `x` | [第一章 §2](theories/becoming/chapters/01-ROOT.md#class-and-continuation) |
| 相续、同族（line, family） | 续的所及；它的等价闭包 | [第一章 §2](theories/becoming/chapters/01-ROOT.md#class-and-continuation) |
| 四相：生、住、异、亡（the four marks） | 开始、持续、变化、终止：在一个类之下一条相续中的位置，没有一个单独成立 | [第一章 §3](theories/becoming/chapters/01-ROOT.md#four-marks) |
| 有常（constancy） | 类由关系承载：`E˘;R ⊆ R;E˘` | [第一章 §4](theories/becoming/chapters/01-ROOT.md#constancy-and-core) |
| 核（the core） | 一个类之内、关系从不区分开的最大的对称关系 | [第一章 §4](theories/becoming/chapters/01-ROOT.md#constancy-and-core) |
| 复生、`«生生»`（renewal, renewal without end） | 由另一条开启、并继续下去的一条相续；不断复生的最大的同族。文法之词一律写作 `«生生»`，与其 Lean 名称的写法相同；它不是伦理的生生（见下），而复生也不是第二章所说的、一个形成所取用者的更新 | [第一章 §6](theories/becoming/chapters/01-ROOT.md#renewal-and-grains) |
| 移动上的门（gate (on moves)） | 一个过程诸移动上的一个已判定的标记；它定位变化可以从何处进入一条相续。不是更新之门 | [第一章](theories/becoming/chapters/01-ROOT.md#r-every-origin-passes-the-gate) |
| 及（reach） | 一个关系的传递闭包 | [第一章 §1](theories/becoming/chapters/01-ROOT.md#one-kind-of-symbol) |
| 边界（boundary） | 一个区域与其余部分、内与外的划分，由该区域给出：位于其中者就是该区域，它所在之处就是内与外相接之处，而一个关系在把内部之物关联到外部之物之处跨越它。沿一个关系，一个形成的边界由一个包含该形成、并在该关系之下封闭的区域给出，于是该关系从不跨越它：闭包是最小的这样的区域，整体是最大的，而较小的关系有更多这样的区域。一个律的裁断在其中成立的构形或参数之区域的边界（第三章 §8、第五章 §10）是同一义；第二章 §1 中继续与终止之间的边界，位于二者都未判定之处；第四章 §1 的割（`Cut`）是没有任何已形成的关系跨越的区域，即文法的不出（`«不出»`） | [第七章 §4.1](theories/becoming/chapters/07-SIGNIFICANCE.md#decomposition)，读于[第一章 §9.9](theories/becoming/chapters/01-ROOT.md#boundaries)，[不出](theories/becoming/chapters/01-ROOT.md#r-not-going-out-of-a-region) |
| 模型；世界模型（model; the World model） | 一个载体、一个读作缘的关系以及所用的诸类；世界模型是带有流、依存网（`Web`）、自然数之量与离散步的那个模型 | [第一章 §8](theories/becoming/chapters/01-ROOT.md#models) |
| 发生模型（occurrence model） | 一个世界模型所确定的文法模型：它的诸发生（处于某一步的一个关系项），带有“处于同一步”这一类，带有作为部分同一的守恒之步、活动、存量与在场，以及一步之内的五个关系，与名之步并列 | [第一章 §8.6](theories/becoming/chapters/01-ROOT.md#r-the-world-represented-both-ways) |
| 诸移动之关系（the moves' relations）`moveRel` | 在文法中读出的一个过程：每一个移动一个关系，在该移动把 `s` 带到 `t` 之处关联 `s` 与 `t`；它们的并就是诸步，而把移动纳入其内的模型，在带有移动的构形上读它们 | [第一章 §8.1](theories/becoming/chapters/01-ROOT.md#r-processes-represented-both-ways) |
| 观（view） | 过程、框架与世界，各是文法的一个模型，被读作同一个展开的诸观（第八章的论题，已论证，未证明） | [第一章 §9](theories/becoming/chapters/01-ROOT.md#laws-on-every-model) |

## 地图

| 术语 | 义 | 出处 |
|---|---|---|
| 传（carrying renewal） | 粗的样式继续下去，而一条细的相续开始（火传） | [第二章 §1](theories/becoming/chapters/02-MAP.md#branches) |
| 延、尽（goes on, ends） | 沿某一分支继续下去；在每一分支上都终止 | [第二章 §1](theories/becoming/chapters/02-MAP.md#branches) |
| 生成、守、退化（generation, keeping, degeneration） | 一个样式经由传而继续下去；不经由传而继续下去；在每一分支上都终止。“生成”从不指生起，也不指任何新的组织，它也不是生生：生生的英文释义“continuing generation”（持续的生发，第七章 §2）说的是生发，不是这一义：生成可以在两个粒度层级上继续下去，而可形成者只是回返。自某一点起守（后守）容许在该点之前有复生；有了它，再加上排中律，诸区域便覆盖全体。在一个进程的诸时刻上读，在判定的前提之下，保持扩大就是在一无所失的那一个之下的生成 | [第二章 §1](theories/becoming/chapters/02-MAP.md#branches)，[第七章 §2](theories/becoming/chapters/07-SIGNIFICANCE.md#r-keeping-widening-is-generation-losing-nothing) |
| 更新、耗用（renewal, consumption） | 就一个形成沿一次运行而言：它所取用者被归还，或被用尽。不是复生，即由另一条开启的一条相续（第一章 §6） | [第二章](theories/becoming/chapters/02-MAP.md#renewal) |
| 静止（rest） | 变化自某一步起停止 | [第二章](theories/becoming/chapters/02-MAP.md#rest) |
| 余裕、取用、给予（margin, draw, giving） | 一个水平高出一个需要多远；所取者；所给者 | [第二章](theories/becoming/chapters/02-MAP.md#margin) |
| 机（juncture） | 一个损失经过之处 | [第二章](theories/becoming/chapters/02-MAP.md#return) |
| 环、耦合、所携之量（loop, coupling, carried amount） | 影响的一条闭合路径；一个水平对另一个水平反应的强度；一个差异沿一条路径所携带的东西 | [第二章](theories/becoming/chapters/02-MAP.md#loops) |
| 第一律（first law） | `Flow.Gainless` 的脊柱之名：一个没有重复的封闭同族，所得回的至多是从它所取走的；在㶲平衡之下，以可用功读出的热力学第二定律给出它（`EntropyProduction.gainless_of_secondLaw`）。热力学第一定律，即能量守恒，总是以全名称之 | [第二章](theories/becoming/chapters/02-MAP.md#how-to-read) |
| 元吸引子（meta-attractor） | 封闭的捕获：一个选择之环，其规则与其对规则的读取都由它所选择的份额形成，环中没有任何东西读取份额之外者。它从不指语料的工作定义，即一种活动的反复出现的组织，其后果有助于在其具体承载者的变化之中再生产选择这一组织的条件：那是另一义，二者都未被表明包含对方：形式的元吸引子不说及承载者，所以一个捕获之环在某一对类上是否生成，仍属未决 | [第二章](theories/becoming/chapters/02-MAP.md#capture) |

## 认知

| 术语 | 义 | 出处 |
|---|---|---|
| 耦合进（couples into） | 经由一个选择者的诸耦合而到达它的东西（从不说“记录到”，即 registers） | [第三章 §1](theories/becoming/chapters/03-KNOWING.md#selection) |
| 选择（selection） | 经由选择者的诸耦合而进行；世界模型诸前提的一个子集，称为“前提的一种选取”（a choice of premises） | [第三章 §1](theories/becoming/chapters/03-KNOWING.md#selection) |
| 无明、明（*wúmíng*、*míng*） | 锁定于一个在静止中无法达到之目标的寻求，植根于每一个形成由之选择的那个位置，却与之不同；耦合与一个选择相结合，使之到达支持所不标记的东西 | [第三章](theories/becoming/chapters/03-KNOWING.md#learning) |
| 验、层（testing, stages） | 在网之内作区分；核的有限逼近 | [第三章](theories/becoming/chapters/03-KNOWING.md#testing) |
| 理（*lǐ*） | 一种同时为结构与变化建模的归并：步跨越它同样进行的归并（`«同行»`）。在步的后继确定之处（`«定后»`），一个类的[核](theories/becoming/chapters/01-ROOT.md#constancy-and-core)是一个理；在每一个发生又都有后继之处，它是该类之内最粗的那个理，即该类之理（`«定后则类之核同行»`, `«定后遍后则核为其内最粗同行之类»`） | [第三章](theories/becoming/chapters/03-KNOWING.md#li) |
| 文（*wén*） | 一次运行的诸状态经由一个映射的历程 | [第三章](theories/becoming/chapters/03-KNOWING.md#wen) |

## 集体与意义

| 术语 | 义 | 出处 |
|---|---|---|
| 更新之门、门控更新（the gate (of a renewal), gated renewal） | 给予一个缘的每一个形成，都以至少 `m` 的需要依存于它，于是更新依存于它所更新者。不是移动上的门 | [第五章](theories/becoming/chapters/05-COLLECTIVES.md#collectives) |
| 最优解、取用者、池、共有的编码（optimum, drawer, pool, shared code） | 各依其引入之处的定义 | [第五章](theories/becoming/chapters/05-COLLECTIVES.md) |
| 意义（significance）`sig` | 对一个立场、一个步与一个形成而言，那一延续是否有意义：一个命题，不是一个数；以从己方式（de se）读，即它位于该中心沿一个关系与之一同继续的东西之内 | [第七章 §1](theories/becoming/chapters/07-SIGNIFICANCE.md#evaluation) |
| 中心（center） | 作为立场的一个形成 | [第七章 §1](theories/becoming/chapters/07-SIGNIFICANCE.md#evaluation) |
| 标准（standard） | 衡量某物所依据的东西，使它可以被达到或未被达到：对一个水平的要求、一个可接受的行为集、一项任务。一条选择规则、一种编码或从所作的抉择中读出的一个次序，只有在某种读法之下才是一个标准。一个标准被达到，并不说明达到它是否有意义 | [第七章 §1](theories/becoming/chapters/07-SIGNIFICANCE.md#what-forms-and-what-is-supplied) |
| 扩大（widening） | 在每一步都容纳另一者所容纳的每一个形成，并在某一步多容纳一个 | [第七章 §2](theories/becoming/chapters/07-SIGNIFICANCE.md#order) |
| 排序、次序（哪一个进程更好）（ranking, order (which course is better)） | 把诸选项比较为更好或更坏；伦理中担任这一角色的词*次序*指的就是它。动力学没有一条律给出排序：诸律给出的是诸进程在所容纳者上如何不同，一个扩大另一个，二者保持相同，或者混合，这不需前提（[第七章 §2](theories/becoming/chapters/07-SIGNIFICANCE.md#order)）；扩大是单向且传递的（数学意义上的严格偏序），说的是哪一个容纳更多，不是哪一个更好。伦理的排序需要 C 或一个代替它的前提，凡用之处都是假设。C 的排序只读一个进程是否保有另一个的全部主张并增加一个活的主张，不判定任何混合的比较；判定混合比较的权重、等级或优先，是[一个进一步的前提](theories/becoming/chapters/07-SIGNIFICANCE.md#r-widening-as-what-every-positive-weighting-ranks)。是否有任何排序具有对一切可能的心智都有约束力的根据，未决。一个形成所持有的排序，是在展开之中形成的（[第七章 §1](theories/becoming/chapters/07-SIGNIFICANCE.md#what-forms-and-what-is-supplied)）：它的行为只在[第三章 §11](theories/becoming/chapters/03-KNOWING.md#r-what-choices-show-of-an-order)所说的范围内显示它；据之而行，它就[选择](theories/becoming/chapters/03-KNOWING.md#selection)，所以接下来形成什么可以依赖于它；而从它所提高的份额读出时，它可以[锁定](theories/becoming/chapters/02-MAP.md#r-capture-through-the-rule) | [第七章 §4](theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order) |
| 延续条件（the continuation condition）`Unrestricted` | 从每一个立场看，对任何东西，其延续到未来都有意义；陈述而不断言；它确定范围 | [第七章 §3](theories/becoming/chapters/07-SIGNIFICANCE.md#condition) |
| 自闭包读法、全闭包条件（the own-closure reading, the whole-closure condition） | 把“有意义”读作位于一个中心沿一个关系与之一同继续的东西之内；延续条件在这一读法之下所成为的：每一个中心沿该关系的闭包都是整体。这是一个关于关系的陈述，有的网满足它，有的网不满足，而不是意义保持自由时的那个前提 | [第七章 §4.5](theories/becoming/chapters/07-SIGNIFICANCE.md#r-the-continuation-condition-on-the-root) |
| C | 扩大之比较：扩大可形成者更好；它给出次序；对诸进程的排序需要它，或一个代替它的前提（单凭自我关切，无需 C 便排定一种情形） | [第七章 §4](theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order) |
| 延续之条件（第六章之名） | 第六章以古典之词称延续条件；义即延续条件（见上），只有一义 | [第六章](theories/becoming/chapters/06-CLASSICAL-TEXTS.md#thesis) |
| 以广为愈（第六章之名） | 第六章以古典之词称 C（扩大可形成者更好）；义即 C（见上），只有一义 | [第六章](theories/becoming/chapters/06-CLASSICAL-TEXTS.md#thesis) |
| 不变之步（the step of invariance） | 延续条件在自我之预设以外的内容 | [第七章 §4](theories/becoming/chapters/07-SIGNIFICANCE.md#step) |
| 存活之意义（living significance） | 该条件所给出的：活下去者的意义 | [第七章 §3](theories/becoming/chapters/07-SIGNIFICANCE.md#living-significance) |
| 生生（*shēngshēng*） | 整体之中的生命及其持续的生发［AI 读法，D1］。T8 论证，它就是对生命而言的道，以扩大可形成者来比较，以延续条件定范围，以 C 定次序。它既不是文法的 `«生生»`（无尽的复生），也不是第二章的生成本身（生成容许损失），也不是任何新的组织。读作扩大时，在一个进程的诸时刻上、在判定的前提之下，它是可能者的生成，且不失去其中任何一个［AI 读法，D45］ | [第七章 §2](theories/becoming/chapters/07-SIGNIFICANCE.md#order) |

## 方法

| 术语 | 义 | 出处 |
|---|---|---|
| 地位（standing） | 一个陈述是哪一种主张：定义、连同其基的定理、有条件者、校准、论题、评估、读法、未决 | [第八章 §2](theories/becoming/chapters/08-METHOD.md#standings-and-bases) |
| 基（base） | 一条定理在何处被证明：根、任一过程、任一类型、世界模型、一个具名的模型、外围 | [第八章 §2](theories/becoming/chapters/08-METHOD.md#standings-and-bases) |
| 纯核；外围（the pure core; the periphery） | `Becoming` 的核心模块，它们只引入基础层与彼此（根模块 `Becoming` 还引入实例与应用之环），在去掉基础层的 `import Std` 之后，单凭 Lean 的前奏即可编译，每一个源声明的公理报告都为空；Mathlib 诸叶、较早的模块与 Python 实验，它们可以使用任何工具，依赖关系指向纯核，其结果保有各自的回执并列出其公理。三个基础模块（`GenerativeCore`、`InquirySufficiency`、`RelationalRenewal`，不是纯核的 L0 层）以及实例与应用之环，与纯核一同检查，满足纯核的条件，却不计入纯核；二者也都不是外围 | [第八章 §3](theories/becoming/chapters/08-METHOD.md#pure-core-and-periphery) |
| 脊柱（spine） | 由其检查器所运行的 Lean 包 `Becoming`（纯核以及实例与应用之环，立于三个基础模块之上，后者与它一同检查而不计入其中），新的结果扩展它；*脊柱之名*是在那里使用的一个名称，*前脊柱*标记运行之外的一个较早的模块，连同其范围保存。脊柱上的一条律立于其标签所指的基上，并不因此就在根上 | [第八章 §3](theories/becoming/chapters/08-METHOD.md#pure-core-and-periphery) |
| 校准（calibration） | 一条律在何处需要一个全知原理，以及这一需要关于展开说出了什么 | [第八章 §5](theories/becoming/chapters/08-METHOD.md#calibrations) |
| 假设（hypotheses） | 一条律自身的局部前提（有限、已列出、已判定……），写进其陈述之中 | [第八章 §2](theories/becoming/chapters/08-METHOD.md#standings-and-bases) |
| 律（law） | 一个陈述，对其假设所容许的每一个关系、载体或模型都成立，从它所成立的对象上读出，而不是加于其上；只经由其假设而有内容。`Law` 是一个确定之步的脊柱之名，即一个关系（`next x = y`），不是其构形所遵从的一条规则；一门科学的律，冠以该科学之名 | [第八章 §10](theories/becoming/chapters/08-METHOD.md#law) |
| 共律（shared law） | 许多核心结果共有、并经由它而证明的一条律，在持有它的最低一层只陈述一次：闭包、平衡、有限运行、归并、扩大。它不给任何律排序，也不统辖任何东西；旧称“master law”（主律），这一名称只保留在它被匹配而不被阅读之处（一个旧 id、旧锚点）以及历史之中 | [第八章 §7](theories/becoming/chapters/08-METHOD.md#shared-laws-and-connectivity) |
