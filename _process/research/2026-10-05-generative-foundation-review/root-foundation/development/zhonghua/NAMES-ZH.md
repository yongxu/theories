# 名表（中华本所用之名）

AI 所定（board item ZH），2026 年 10 月 21 日。每个理论概念一个名；名用简体（「闢」除外），繁体附后。「锚」是 Lean 声明或模块（`Becoming.` 前缀省去）；「出处」引自《中华思想脉络》v1.0 的冻结文本，〔〕内为其来源编号；「式」：古＝单字古名，复＝有出处之复词，新＝新组合（约定）。「注」写明此名不带之义与分工。

## C01 一元与展开

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 大化 | 展开（the one unfolding） | `World.run_world` | 「阴阳大化」〔RU2-S-XZ17〕 | 复 | 不带荀子天论中阴阳二气之本体义；只取一切变化合为一个展开；先秦唯一用例（荀子天论）为谓语；名词义「整体之展开」是本编的约定 |
| 变化（變化） | 生成／变化（becoming）：关系的形成、维持、转化、退化与消解 | `Web.change_readings` | 「刚柔相推而生变化」〔DS02〕 | 复 | 不带易传中与吉凶占断相连之义；单说「生」指生成（与退化相对），不指变化全体 |
| 物 | 关系项（relatum） | `Web.roles` | 「物，謂之而然」〔ZH1-S02〕 | 古 | 物只是关系项，不是先于关系的实体 |
| 待者 | 形成（formation）：关系项依存并汲取他者的角色 | `Web.roles` | 「吾有待而然者邪」〔ZH1-S02〕 | 新 | 待＋者；与所待成对，是同一关系项的两种角色 |
| 所待 | 条件（condition）：他者所依存者这一角色中的关系项 | `Web.roles`；`Flow.roles` | 「吾所待，又有待而然者邪」〔ZH1-S02〕 | 复 | 所X只指单步之所X；「所待又有待」即一关系项兼两角色 |
| 状（狀） | 构形（configuration）：展开在一步之所是，它怎样相关 | `Alike` | 「状变而实无别而为异者」〔RU2-S-XZ22〕 | 古 | 取荀子正名「狀／實」之分；狀为构形，實为跨步所认之同一 |
| 动（動） | 动作（move）：律在一步所留开者 | `withMove` | 「動，或徙也」〔MI1-S-JS〕 | 古 | 墨经义：或徙，一种可能的移易；不带「动静」形上义 |
| 步 | 步（step）：自然数步的共同索引 | `World.run_world` | 「不積跬步」〔RU2-S-XZ01〕 | 古 | 只作离散的共同索引；时之义见「時」 |
| 行 | 运行（run）：一个过程无穷的实际执行，唯一的基底 | `Run`；`World.run_world` | 「道，行之而成」〔ZH1-S02〕 | 古 | 取「道行之而成」：所显之法由运行而成；不带「五行」「德行」义 |
| 变（變） | 过程（process）：可容许的变化，动作读入构形 | `Generative.Process` | 「化而裁之谓之变」〔DS02〕 | 古 | 取系辞：化而裁之为变（裁成步）；与变化（展开全体）同取「变」义而层次不同 |
| 系辞（繫辭） | 框架（frame）：过程加上每个构形所实现的主张 | `Frame` | 「系辞焉而明吉凶」〔DS02〕 | 新 | 系辞＝系辞于卦：辞系于每个构形；书名作《系辞》加书名号以别；不带占断 |
| 辞（辭） | 主张（claim） | `Frame` | 「系辞焉而明吉凶」〔DS02〕 | 古 | 一个构形所实现、可以成立或不成立者 |
| 宇 | 世界（world）：一类关系项，带流与依存网，是容许每一步之过程的运行 | `World`；`World.run_world` | 「宇，彌異所也」〔MI1-S-JS〕 | 古 | 墨经义：遍及异所；每个宇是一观，回到展开；不带「宇宙」为实体之义 |
| 观（觀） | 观（view）：过程、框架、世界的总名 | `Generative.Process`；`Frame`；`World` | 「观其会通」〔DS02〕 | 古 | 观只指视图；读法另名「讀」 |
| 其余（其餘） | 整体的其余（the rest of the whole read as one relatum） | `World.withRest` | — | 新 | 其余从不施动；取代「大块」 |
| 诸宇（諸宇） | 空间（space）：所表示世界之类 | — | — | 新 | 諸＋宇 |
| 法 | 律（law）：确定的过程，从它所支配的历史读出 | `Law` | 「法，所若而然也」〔MI1-S-JS〕；「有物有则」〔RU2-S-MZ〕 | 古 | 墨经之法是所若而然之标准；理论以法名律（确定的过程，从其所支配之历史读出）是 AI 之延伸；孟子引诗「有物有則」为物与则不二之对照；不带法家之法令、佛法义 |
| 自然之法 | 所显之律（law shown）：一段历史是其运行的最小之律 | `Shown`；`shown_le_iff` | 「道法自然」〔DS01〕 | 复 | 取王弼「在方而法方，在圆而法圆」：法随所然；不带自然作本原 |
| 兩行 | 语境中的读法共成一个世界（contextual readings compose one world） | `Contextual.world`；`Contextual.fitsFree_iff` | 「是之謂兩行」〔ZH1-S02〕 | 复 | 齐物论；诸读法各在其语境中成立而共成一个世界，不须先合为一 |

## C02 关系、依存与条件

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 待 | 依存（dependence）：一个形成所需者及其多少，以阈给出 | `Web` | 「吾有待而然者邪」〔ZH1-S02〕 | 古 | 待是关系谓词，不是物 |
| 待网（待網） | 依存网（web）：持有水平、活动、所需、需要量与汲取 | `Web` | — | 新 | 待＋网；与「流」（Flow）并列而不同 |
| 足 | 满足：一个依存之需被一个水平满足（need ≤ level） | — | 「足食，足兵」〔RU1-S-LY〕 | 古 | 足只指单个所需被满足；每个所需都被满足名「容」；够名「足而止」；不带「知足」之修养义 |
| 资（資） | 汲取（draws） | `Web` | 「萬物資生」〔YD-HX01〕 | 古 | 资是关系名；王弼注「资，取也」；财货义（资斧）不取 |
| 食 | 以之为生（lives on） | `Web.LivesOn` | — | 古 | — |
| 交 | 交互（interacts） | `Web.Interacts` | 「相與交食乎地而交樂乎天」〔ZH1-S23〕 | 古 | 一义：Web.Interacts（两向对称，经一个条件）；与 Hexagram.meets 不同构，易章之交作「卦交」；泰彖之交读作输 |
| 相待 | 相互依存（mutual dependence） | `Flow.MutuallyDependent` | 「離居不相待則窮」〔RU2-S-XZ10〕 | 复 | — |
| 持 | 维持（kept） | `Web.Kept` | 「相持而长」〔RU2-S-XZ19〕 | 古 | 与「絶」成对 |
| 绝（絶） | 断裂（broken） | `Web.Broken` | 「糧食輟絕而不繼」〔MO1-S-C18〕 | 古 | 与「持」成对；绝生之「绝」同义（断）；渡义（绝江河）、竭义不入 |
| 结（結） | 关系之形成（forms） | `Web.Forms` | 「物有結之」〔ZH1-S06〕 | 古 | 与「解」成对 |
| 解 | 消解（dissolves） | `Web.Dissolves` | 「物有結之」〔ZH1-S06〕 | 古 | 与「結」成对 |
| 俱亡 | 共灭（coextinct） | `Web.coextinct` | 「虢朝亡而虞夕從之」〔FA1-S-H10〕 | 新 | 新名，不承先秦「俱亡」（都失去）之义；十过一句为依存而随亡之结构出处 |
| 蓄 | 储备（carries） | `Web.Carries` | — | 古 | — |
| 自持 | 承担自身（self-bearing） | `Web.SelfBearing` | — | 新 | 取代「自待」；随条件之标法而定（Mutualism.apart_relabelled），不是独立性质；不立先秦之引 |
| 截 | 切口（cut） | `Flow.Cut` | — | 古 | 取代「不交」，使「交」只有一义 |
| 小故 | 必要条件 | — | 「小故，有之不必然，無之必不然」〔MI1-S-SS〕 | 古 | 墨辩：无之必不然；结构见「有待」（Web.Dependent）与 Hibernation.readings 之见证；大故于脊柱暂无锚 |
| 大故 | 充分且必要之条件 | — | 「大故，有之必然，無之必不然」〔MI1-S-SS〕 | 古 | 墨辩 |
| 有力 | 差别制造（makes a difference）：一个依存之断的但书 | `Dependence.MakesDifference` | — | 新 | 复词；先秦「有力」是力量义，不承；以论语「微管仲，吾其被髮左衽矣」之「微」为但书结构的对照 |
| 有待 | 活动则受支撑（Web.Dependent 之为前提） | `Web.Dependent` | 「吾有待而然者邪」〔ZH1-S02〕 | 复 | 齐物论；有待只名此前提；小故以之为锚而另有见证 |
| 有形 | 有形（embodied）：活动恰在水平为正之处 | `Web.Embodied`；`World.Embodied` | — | 新 | 取代以「体」名体现；World.ArisingEmbodied 同族 |
| 正需 | 所需为正之依存（Web.Bearing） | `Web.Bearing` | — | 新 | — |

## C03 生灭与变化之读

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 兼 | 整体（whole）：同一展开中的一切 | `Web.Whole`；`World.withRest` | 「體，分於兼也」〔MI1-S-JS〕 | 古 | 取墨经兼体之兼（整体）；墨子「兼以易别」之兼另作对照条目（见「盡」） |
| 体（體） | 部分（part） | `Web.Whole` | 「體，分於兼也」〔MI1-S-JS〕 | 古 | 墨经义：体是兼之一分；不带体用之本原义（体用另作相分条目）；体只作部分；体用之「體」只在引文中出现 |
| 作 | 生起（arising）：活动跨一步开始 | `Web.Arises` | 「万物并作」〔DS01〕 | 古 | 取老子十六章「并作」；不用「生」（生只指生成） |
| 已 | 止息（ceasing）：活动跨一步停止 | `Web.Ceases` | 「學不可以已」〔RU2-S-XZ01〕 | 古 | 已只指止息；墨经「已，成、亡」只作成、毁之旁证 |
| 成 | 开始成立（comes to hold） | `ComesToBe` | 「其分也，成也；其成也，毀也」〔ZH1-S02〕 | 古 | 与「毁」成对；成生、成闭之「成」同义（成就） |
| 毁（毀） | 不再成立（ceases to hold） | `CeasesToBe` | 「其分也，成也；其成也，毀也」〔ZH1-S02〕 | 古 | 与「成」成对 |
| 聚 | 开始作为条件而在（comes to stand as a condition） | `Web.ComesToStand` | — | 古 | 与「散」成对；不带「气之聚」之本体义 |
| 散 | 不再作为条件而在 | `Web.ComesToStand` | — | 古 | 与「聚」成对 |
| 相代 | 同步（keep pace）：生起与止息相差不过成员之数 | `keep_pace` | 「日夜相代乎前」〔ZH1-S02〕 | 复 | — |
| 消息 | 普查平衡（census balance over a stretch） | `held_over_stretch` | 「君子尚消息盈虛」〔YD-HX01〕 | 复 | 消息之「息」为长，与「不息」之「息」（止）异义；只作复词；与易学十二消息卦（Hexagram.waxWane）之消长不同；waxWane 写作「消长环」；消息之「息」为长，与「不息」之「息」异义 |
| 列 | 普查（census）：每步成立者的列表，各一次 | `Web.Census` | — | 古 | 与「數」分名 |
| 数（數） | 计数（count）：恰在所计者已定之处存在 | `counts_iff_decided` | — | 古 | 只作计数，不带定数、命数义 |
| 定数（定數） | 列一次即判定同一（lists once iff decided） | `listsOnce_iff_decided` | 「此事之所以稽实定数也」〔RU2-S-XZ22〕 | 复 | 荀子正名；荀子之定数是动宾（定其数）；只取先定实之同异而后能数，不取命数义 |
| 不息 | 不息（unceasing）：生起无止地复现 | `Web.Unceasing` | — | 古 | 一名一锚，C03 与 C05 合为一条；与消息之息（长）、孟子「日夜之所息」（长）异义；比较 Recycle.closed_unceasing（有不息而无生生）与 Web.unceasing_iff_covering |
| 止 | 停息（coming to rest）：从某步起无物生起 | `World.RestsFrom`；`World.comes_to_rest_unrefuted` | 「物不可以終止」〔YD-OW-XG〕 | 古 | 止只指停；墨经「止，以久也」是一段停顿（有久之不止），不入；序卦此句之全称作定域条目 |
| 静（靜） | 静（holds at a time）：一时成立者（D45） | `Law.rests_iff` | — | 古 | 静不是停；不带「主静」修养义；律所不改变之构形（D49：极）；与「止」（停息）分开 |
| 化 | 构形改变而同一不别 | `Web.Continues` | 「状变而实无别而为异者，谓之化」〔RU2-S-XZ22〕 | 古 | 构形改变（不 Alike）而续不断；荀子正名之定义 |
| 相续（相續） | 延续关系（continuation relation） | `Web.Continues` | — | 复 | 延续关系本身（Web.Continues 所据之关系 R）；古代用例为一对一之流 |
| 无间（無閒） | 连续（continuity） | `Reidentify.KeepsActive` | — | 复 | 墨经「有闲／无闲」 |
| 继（繼） | 接续：由先后相继之源供给 | `Succession` | — | 古 | 不锚 KeepsTenure；承继另名「因」；中庸之继志留作缺口 |
| 蛰（蟄） | 休眠（dormancy） | `Hibernation.readings`；`Web.Holds`；`Web.waking_not_arising` | 「龙蛇之蛰，以存身也」〔DS03〕 | 古 | —；有所持守之休眠；Dormancy（无持守）作反衬 |
| 存 | 持存（holds, persists） | `Web.Holds` | — | 古 | —；存是一步之持存；跨步之持续名「久」 |
| 裂 | 分裂（split） | `Web.NoSplit` | — | 古 | 取代「分」，使「分」只给足迹 |
| 合 | 并合（merge，形成之并合） | `Web.NoMerge` | — | 古 | 取代「并」（简体与「並」同形）；与构形之「同归」分开 |
| 亡 | 终止（ends）：自某步起永不活动 | `Web.Ends` | 「死而不亡者寿」〔YD-LAO-BASE〕 | 古 | 亡只指终而不复；俱亡同义 |
| 新作 | 新起（arises from nothing it continues） | `Web.ArisesFrom` | — | 新 | 跨步后活跃，且不延续任何此前活跃之形成 |
| 火传（火傳） | 样式经由传递而延续（a pattern lasts through passing） | `Web.ByPassing` | 「指窮於爲薪，火傳也」〔ZH1-S03〕 | 复 | 养生主：薪是载者各自终止，火是样式经递接而不尽 |
| 升 | 水平之升（rises） | `Web.Rises` | — | 古 | 与「降」成对 |
| 降 | 水平之降（falls） | `Web.Falls` | — | 古 | 与「升」成对 |

## C04 流、交换、平衡、耗散与停息

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 流 | 流（flow）：每个形成跨一步从每个条件取与给 | `Flow` | 「盛衰之殺，變化之流也」〔ZH1-S13〕 | 古 | 流是 Flow，不是待网；流淫义不入 |
| 取 | 取用（uptake） | `Flow` | — | 古 | — |
| 与（與） | 补充（replenishment，给） | `Flow` | — | 古 | — |
| 取与（取與） | 一次交换（one exchange） | `Flow` | — | 复 | — |
| 取者 | 取用者（takers） | `Flow.takers` | — | 复 | — |
| 衡 | 平衡（balance）：水平的每次变化恰是所取与所给 | `Flow.Balances` | — | 古 | —；墨经之衡是杠杆之平、荀子之衡是标准，都不入 |
| 耗 | 耗散（dissipation） | `Flow.Dissipative` | — | 古 | —；先秦「秏」义为乱、虚竭（荀子修身「多而亂曰秏」），耗散是转义 |
| 端 | 最小损失、最小之量（least loss） | `Amounts.rests` | 「非半弗𣃈，則不動，說在端」〔MI1-S-JX〕 | 古 | 墨经义；与「萌」（种子）分开；墨经之端是不可再分之点，脊柱之端是损失之下界，二者只在整数之量中重合 |
| 积小以高大（積小以高大） | 阿基米德的量（Archimedean amounts） | — | 「積小以高大」〔YD-HX02〕 | 复 | AI 强读：书证言积累，读作阿基米德之量；反面见证 Layered.not_archimedean |
| 输（輸） | 输送（conveying） | `Flow` | — | 古 | — |
| 自外来（自外來） | 从其外得到供给（fed from beyond） | `Flow.FedFromBeyond`；`Flow.fed_from_beyond` | — | 复 | — |
| 汲 | 汲入（drawing in） | `Flow.taking_draws_in` | 「夫山居而谷汲者」〔FA1-S-H49〕 | 古 | 与「自外来」在可判定相等时等价（Flow.inward_iff_not_fed） |
| 多而无已（多而無已） | 不止地更多（more without end） | — | — | 新 | 「已」同「止息」义 |
| 损（損） | 下降（depletion） | — | 「損 、益 ，盛衰之始也」〔YD-OW-ZG〕 | 古 | 「損，偏去也」只给「偏去」；与「益」成对 |
| 封 | 封闭（closed：家族跨一步不与外交换） | — | 「夫道未始有封」〔ZH1-S02〕 | 古 | 取代「闭关」，使「闭」只指吸收区域 |
| 围（圍） | 围住（enclosed around） | — | — | 古 | — |
| 开（開） | 开放（openness）：超出每个有限家族的交换 | `World.arising_opens` | — | 古 | 只对应 Ren 的「开」之「未」一相；未、可、应、转见对照表；只锚 arising_opens；Seeking.more_needs_open 之 open 是另一结构，不借此名 |
| 衰 | 衰（runs down）：家族衡且耗而总量下降之一步 | `Flow.RunsDownOn` | 「盛衰之殺，變化之流也」〔ZH1-S13〕 | 古 | — |
| 与如其取（與如其取） | 守恒（conserving）：所给恰等所取 | `Flow.ConservingOn` | — | 新 | 固定短语 |
| 与不过取（與不過取） | 无中不生（第一定律，gainless）：所给不多于所取 | `Flow.GainlessOn` | — | 新 | 固定短语 |
| 共取过与（共取過與） | 联合超出（joint excess） | `Flow.excess_bounded`；`Flow.joint_excess_ends` | — | 新 | 原拟「合取過與」；「合取」在逻辑中是 ∧，易误 |
| 与之者（與之者） | 补充者（renewers） | `Flow.renewers` | — | 复 | 原拟「與者」；读 yǔ；「与者」易读作参与者 |
| 全取 | 取到所与之全部（takes all） | `Flow.TakesAll` | — | 新 | — |
| 趨而不至 | 趋停而不至（approaches rest without reaching it） | `Halving.approaches_without_reaching`；`Amounts.few_large_losses_of_archimedean` | — | 新 | 与「止」分开 |
| 涸 | 耗尽：一个存量降至零 | — | 「泉涸，魚相與處於陸」〔ZH1-S06〕 | 古 | 大宗师 |

## C05 持续、更新、回返与复

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 久 | 通过变化之持续（persisting through change） | `Web.Whole.arises_within`；`Web.Whole.needs_arising`；`Web.ByPassing.passes_within` | 「久，彌異時也」〔MI1-S-JS〕；「四時變化而能久成」〔YD-HX01〕 | 古 | 脊柱无单一之久；整体经由部分之生起而久，样式经由传递而久；孙子「久暴師」之久不入 |
| 续（續） | 延续（continuation）：一个形成延续一个前者，跨步之同一 | `Web.Continues` | 「有化而无别，谓之一实」〔RU2-S-XZ22〕 | 古 | 荀子之「一实」即续：状变而实无别；续之补短义（断长续短）不入 |
| 恒（恆） | 更新（renewing）：所参与的每个条件都继续支持每个依存者 | `Web.RenewingIn` | 「天地之道恆久而不已也」〔YD-HX01〕 | 古 | 运行之类；易传之「恆」读为久；名表之恒只名运行之类 |
| 复（復） | 返回（return of a configuration） | `Branching.Returns` | 「反復其道，七日來復」〔V3D03〕 | 古 | 只指构形再得 |
| 期 | 回程之期（return bound） | `Web.RestoredWithin`；`Web.RenewedWithin` | — | 古 | 读 qī（期限），只指上界；确切步数不名期 |
| 同归（同歸） | 合并（merge of courses） | `Law.Merges` | 「天下同归而殊途」〔DS03〕 | 复 | —；王弼四十七章注之单一中心义、九句之「歸」（无损之复）不入 |
| 藏往 | 带着历史（kept history） | `Law.withHistory` | 「知以藏往」〔DS02〕 | 复 | —；「積」（量之累积）不入 |
| 剥（剝） | 侵蚀（undermining） | `Web.UnderminingOn` | — | 古 | —；经文之判（凶、蔑贞）、剥削之社会义、「自下而剝」之次第不入 |
| 恒持（恆持） | 每个依存每步皆持（Web.Renewed，恒之条件层） | `Web.Renewed` | — | 新 | 恒＋持 |
| 竭 | 消耗（consuming）：所汲取之某条件对某依存者竭，永久失去支持 | `Web.ConsumingIn` | — | 古 | 不是恒之否定（fluctuating_neither） |
| 终足（終足） | 回程（restored）：每个依存在其后某步被满足（不要求此前已满足） | `Web.Restored` | — | 新 | 復＋足；原拟「復足」；不用「复」，因 Restored 不要求此前已满足；D49 以「转」兼名复与终足，对照表注明 |
| 终不足（終不足） | 某依存此后永不再被满足（Web.Consumed） | `Web.Consumed` | — | 新 | 与「终足」成对 |
| 绝而终不足（絶而終不足） | 满足过而断、此后不再满足（Web.Lost） | `Web.Lost` | — | 新 | 絶＝Web.Broken |
| 初不定终（初不定終） | 任何有限之往都不定运行之类 | `Renewable.prefix_does_not_decide` | 「靡不有初，鮮克有終」〔YWH-Q〕 | 复 | 王弼乾文言注引诗（大雅·荡，先秦） |

## C06 生成、退化与生生之向

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 容 | 支持、容纳（support, admission）：水平满足一个形成在一步的每个所需 | `Web.Admits`；`Web.Supported` | 「窮，或有前不容尺也」〔MI1-S-JS〕 | 古 | 空间之容，只取关系形式（水平与所需）；包容之品行义不携带；所容为约定：此刻诸水平所容许者之全体 |
| 生生 | 生生：整体中的生及其继续生成（D1）；方向以扩大比较 | `Web.Widens` | 「生生之谓易」〔DS02〕 | 复 | 不带老子五十章「生生之厚」之执生义；不是谓词 living |
| 生 | 生成（generation），与退化相对 | — | — | 古 | 生只指生成；生起另名「作」 |
| 成生 | 生成的（generative）：部分扩大之处 | `Web.Widens` | — | 新 | Ren 之词 |
| 绝生（絶生） | 退化的（degenerative） | — | — | 新 | Ren 之词；绝生不含永久；不可再得者名成闭 |
| 所容 | 生成的空间（the generative space） | — | — | 复 | — |
| 赅（賅） | 包含（includes） | — | — | 古 | 冻结语料只见「該」（天下「不該不徧」） |
| 有所长（有所長） | 超出（exceeds） | — | — | 复 | 长不含优劣，只指在某步容许对方所不容许者 |
| 广（廣） | 扩大（widens） | `Web.Widens` | — | 古 | 广只名扩大序，不带「更好」；排序另名 |
| 狭（狹） | 缩小（narrows） | — | — | 古 | — |
| 相赅（相賅） | 保持（keeps：互相包含） | `Web.Keeps` | — | 复 | — |
| 偏去 | 扣留一个部分（a part withheld） | — | 「損，偏去也」〔MI1-S-JS〕 | 复 | 墨经 |
| 余地（餘地） | 余量（margin） | `Flow.Balances.supported_iff_within_margin` | 「恢恢乎其於遊刃必有餘地矣」〔ZH1-S03〕 | 复 | 余只在复词中：其余、余地、所失各不相借 |
| 阖（闔） | 闭合（closing） | `Flow.Balances.supported_of_net_give`；`Flow.Balances.closes_nothing` | 「一阖一辟谓之变」〔DS02〕 | 古 | 一部分之阖需净汲取；引文所说是时间上的交替，作对照 |
| 闢 | 开启（opening） | `Flow.Balances.admits_of_net_draw`；`Flow.Balances.opens_nothing` | 「一阖一辟谓之变」〔DS02〕 | 古 | 一部分之辟需净给与；正文保留「闢」字形，免与「辟」（譬）相撞 |
| 日新 | 新（novelty）：从某步起每一构形皆异于先前 | `unheld_of_new`；`Law.withHistory_new` | 「日新之谓盛德」〔DS02〕 | 复 | 只名新；不带朱熹「自新」之德性义 |
| 益 | 增益（gain）：一族跨一步之存量上升 | `Gain` | — | 古 | 与「损」成对；增之、有助之义不入 |
| 复归（復歸） | 扰而复归（perturbation reabsorbed） | `Law.perturbation_reabsorbed` | 「夫物芸芸，各复归其根」〔DS01〕 | 复 | 取代「稳」「元闭」二名的结构义；稳、元闭只留在对照表中；不带回到先在之本或未分之初（老子二十八章、王弼十六章注）；老子十六章言各返其根，未言扰动，作对照；只名「只扰状态者被吸回」，ClosedCapture 另名 |
| 互有所长（互有所長） | 混合（mixed） | `Web.Mixed` | — | 新 | 原拟「各有所長」；「各有所长」首见唐宗密，带评价义 |
| 盈科 | 上升之阈：升到阈值而后形成新的耦合 | `Closing.Threshold` | 「盈科而后进」〔RU2-S-MZ〕 | 复 | 孟子 |

## C07 规律、理、常与吸引

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 闭（閉） | 闭：律从不离开的区域（吸收区域；对过程是不变量） | `Law.Absorbing`；`Law.drawn_iff_not_returns` | — | 古 | Ren 之词；确定之法下与「常」相同（Law.absorbing_iff_invariant）；不带负价值 |
| 成闭（成閉） | 成闭（锁定，lock-in） | `Law.DrawnInto.never_back`；`Run.locked_in` | — | 新 | Ren 之词 |
| 护闭（護閉） | 护闭（关节处的保持，keeping） | `Junctures` | — | 新 | Ren 之词；D52 |
| 机（機） | 机（关节，juncture） | `Junctures` | 「節如發機」〔BI1-S-SZ〕 | 古 | D52；「節如發機」只出发机不可收之义，关节之读出于 D52；至乐「萬物皆出於機」（本原）、大学「其機如此」（发动之枢）不入 |
| 常 | 不变量（invariant） | `Invariant` | 「复命曰常」〔DS01〕 | 古 | 与「久」分开 |
| 同 | 相同／互模拟（alike, bisimulation） | `Alike` | 「同，異而俱於之一也」〔MI1-S-JS〕 | 古 | 墨经 |
| 类（類） | 归并（lumping）：读法及其所分之类 | `Learning.Lumped` | 「以類取，以類予」〔MI1-S-XQ〕 | 古 | 墨辩；Learning.Lumped π g 读作「随类而同」 |
| 推类（推類） | 经由归并而推广（generalization through lumping） | `Learning.determines_lumped_iff` | 「謀而不得，則以往知來」〔MO1-S-C18〕 | 复 | 合「推」于此；墨子非攻中所引古语之结构是经归并之迁移 |
| 理 | 理：对结构与变化之律的建模 | `Learning.goAlike_iff_lumped`；`carries_law_iff` | 「理者，成物之文也」〔CV1-S-JL〕 | 古 | 已采；凡理皆类，类不皆理；不带「理先气后」；先秦给「分」（解老），魏晋注给「变化」（韩康伯「盡聚散之理」）；携带律是理论另加的条件 |
| 势（勢） | 吸引域（basin） | `Hexagram.qian_basin`；`Hexagram.cycle_basin` | 「如轉圓石於千仞之山者，勢也」〔BI1-S-SZ〕 | 古 | 只取盆地义；兵家位势作条目；只在互卦之法上有证；一般之势分划是缺口；位势、蓄势、阵势、外加之境不入 |
| 入 | 被吸入（drawn into） | `Law.DrawnInto` | — | 古 | 或入、必入以「或」「必」组合 |
| 所归（所歸） | 吸引子（attractor） | `Law.drawnInto_returning` | — | 复 | — |
| 并行不悖（並行不悖） | 诸语境之拼合：恰在相交处一致时拼合 | `Contextual.glues_iff_agree` | 「道並行而不相悖」〔RU1-S-ZY〕 | 复 | 中庸；Law.Commutes（律与对称交换）不借此名，平语写之 |
| 未定 | 未定（undecided） | — | — | 复 | 未只作虚词 |
| 奇偶 | 奇偶（parity） | — | — | 复 | — |
| 矛盾 | 奇偶系统中的矛盾 | — | — | 复 | — |
| 随类而同（隨類而同） | 随类而同（Lumped π g）：g 在 π 之每一类上取一值 | `Learning.Lumped` | — | 新 | — |
| 知几（知幾） | 及早被读到的水平耦合 | `Web.observed_level_couples` | 「几者，动之微，吉之先见者也」〔DS03〕 | 古 | 以 observed_raise_couples 为其一例；与「明」分锚 |

## C08 识、知、察与验

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 读（讀） | 读法（reading）：带地位的解释；量从其构成者读出 | — | 「桓公讀書於堂上」〔ZH1-S13〕 | 古 | 读法标「讀（AI）」；不指诵读 |
| 识（識） | 识：一个形成自身的进一步历程，经由其耦合所作的归并而分解（D45） | `Web.SelectsThrough` | 「然今天下之情僞，未可得而識也」〔MO1-S-C36〕 | 古 | 已采；去「登记」义；记取义（多见而识之）归「往」；识是形成自身之历程经其耦合所作之归并而分解（D45）；与缘感而择同据 SelectsThrough 之归并而所名不同 |
| 往 | 记录、历程之前段（record, course prefix） | `Learning.prefixOf`；`Run.Fixes` | 「彰往而察来」〔DS03〕 | 古 | 往只指过去之历程；「过此以往」（此后）与「不保其往」二读不入；带着历史名「藏往」 |
| 数往（數往） | 回读（retrodiction） | — | 「数往者顺，知来者逆」〔DS04〕 | 复 | — |
| 验（驗） | 检验（testing） | `Web.Excludes` | 「結智者事發而驗」〔FA1-S-H48〕 | 古 | — |
| 征（徵） | 验证（verification） | `Verification` | 「足，則吾能徵之矣」〔RU1-S-LY〕 | 古 | — |
| 试（試） | 实验（experiment） | `Experiment` | 「其有所試矣」〔RU1-S-LY〕 | 古 | — |
| 相若 | 对照（control） | `FactorsThrough`；`Run.generalizes` | 「權重相若也」〔MI1-S-SX〕 | 复 | 相若是所给之控制，不是被证之无别（同）；Confound.confounded 为其边界 |
| 察 | 敏感性：读有限多条件之律之最小耦合（sensitivity） | `Sensitivity` | — | 古 | 察看、苛察、心之察（分辨）、监察不入 |
| 可知 | 可学（learnable） | `Learnable` | — | 复 | — |
| 习（習） | 训练（training） | `Learning.Training.fit_right_iff` | — | 古 | — |
| 过则改（過則改） | 排除法外推（extrapolation by elimination） | `Learning.byElimination` | 「古之君子，过则改之」〔RU2-S-MZ〕 | 复 | 过失之道德义不入 |
| 符 | 相符／不符（accords／misses） | `Learning.Accords`；`Learning.Misses` | — | 古 | 相符：在每一出值处无失误（不出值亦相符）；韩非「四徵者符」不作此名之引 |
| 终而复始（終而復始） | 套索程（lasso） | `Learning.Lasso` | 「終而復始，日月是也」〔BI1-S-SZ〕 | 复 | 套索是历程之性质；环是耦合之回路；复是构形之返回 |
| 参验（參驗） | 以可错之见证交叉核验 | `WitnessRefinement.complete_diagnosability_iff_cross_separation` | 「無參驗而必之者，愚也」〔FA1-S-H50〕 | 复 | 荀子之「參」训三，不入 |
| 断（斷） | 判断过程（judgment process） | `judgeProcess` | — | 古 | 系辞「断其吉凶」之评价义不入 |
| 衢 | 运行分开（runs part） | `Parting.PartAt` | 「此亦荣辱、安危、存亡之衢已」〔RU2-S-XZ11〕 | 古 | — |
| 大率 | 典型（typicality by counting） | `Typicality` | — | 复 | — |
| 闻见（聞見） | 观察（observation）：从所观察者出发的读法之路线（长为零者是亲见，余为传受） | `apart_only_downstream` | 「知，聞、說、親」〔MI1-S-JS〕 | 古 | 墨经「知：闻、说、亲」之闻只是其中经他者之一类 |
| 知来（知來） | 外推（extrapolation） | `Learning.byElimination`；`Learning.diagonal_misses` | 「数往者顺，知来者逆」〔DS04〕 | 复 | 说卦；墨子「以往知来」之结构是推类，移作推类之引 |
| 阙（闕） | 沉默（silence） | `PartialReadout.silent_sound` | 「蓋闕如也」〔RU1-S-LY〕 | 古 | 原拟「默」；不能确定处不出值；荀子「默而當」是言谈之节，不入 |
| 所至 | 所见范围（scope of an inquiry） | `Scope` | 「知之所至」〔ZH1-S25〕 | 复 | 取代「涯」之一义；原拟「所見」；则阳 |
| 不测（不測） | 对角序列（diagonal course）：在每一外推之对角处失误 | `Learning.diagonal` | 「阴阳不测之谓神」〔DS02〕 | 复 | 沿用易章；阴阳、神之义不入 |

## C09 名、实、类与约定

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 重同 | 一步之内二名一实（每次改认在一步给出的对应） | `Reidentify` | 「二名一實，重同也」〔MI1-S-SS〕 | 复 | 墨经；改名须每步同一，文本无此条；经下「殺狗非殺犬也」与经说下相反，换名保值只对由关系定义的读数成立 |
| 名 | 名（name） | — | 「名，達、類、私」〔MI1-S-JS〕 | 古 | 墨经 |
| 私名 | 一步之内一一对应的名 | — | 「名，達、類、私」〔MI1-S-JS〕 | 复 | —；「私」之偏私义先秦已有，不入 |
| 达名（達名） | 什么都不分开的读法（常值归并） | — | — | 复 | — |
| 名无固宜（名無固宜） | 标签不携带关系 | — | 「名无固宜」〔RU2-S-XZ22〕 | 复 | 荀子正名 |
| 约定俗成（約定俗成） | 共享码（shared codes） | `SharedCodes` | 「约定俗成谓之宜」〔RU2-S-XZ22〕 | 复 | 已采；把约定俗成读作听的次序是 AI 之结构读法；荀子中约定从属于王者制名 |
| 制名 | 外加码（imposed code） | `SharedCodes.run_from_imposition`；`SharedCodes.outside_returns` | — | 复 | 一个码被加于诸形成者；不带王者之中心，不含造新名 |
| 正名 | 有意义的描述 | — | — | 复 | — |
| 贯（貫） | 跨情境成立（cross-situational standing） | `CrossSituational.stands_iff` | 「吾道一以貫之」〔RU1-S-LY〕 | 古 | 只取「通贯诸情境」之结构；「吾道一以贯之」之单一原则中心不入 |
| 知名 | 码的获得 | — | — | 复 | — |
| 改认（改認） | 改认（reidentification）：两套命名之间每步给出的对应 | `Reidentify` | — | 新 | 沿用中文版「改认」；重同只名一步之内二名一实 |
| 喻 | 读出（reads）：读者之码分开诸义项，且两码在该处一致 | `SharedCodes.reads_iff` | 「名闻而实喻」〔RU2-S-XZ22〕 | 古 | 只取晓、读出之义，不带譬喻义 |
| 辨 | 码分开诸义项（tells apart） | `SharedCodes.TellsApart` | 「名定而实辨」〔RU2-S-XZ22〕 | 古 | 与「别」分开 |
| 通意 | 义项之消解（resolves）：只剩一个候选义项 | `CrossSituational.resolves_iff` | 「通意後對」〔MI1-S-JX〕 | 复 | 墨经 |

## C10 耦合、选择、明与无明

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 感 | 耦合（coupling；couples into） | `Web.CoupledInto` | 「天地感而萬物化生」〔V3D02〕 | 古 | 感是关系谓词；方向（条件耦合入形成）是使用者之间的约定；荀子性恶「感而自然」为受动义之佐证 |
| 应（應） | 回应（responds to） | `ExchangeLaw.RespondsTo` | — | 古 | 单用只作回应；爻之关系作「相應」 |
| 资域（資域） | 供给闭包（feeding closure） | `Flow.WithinFeeding` | 「财非其类以养其类」〔RU2-S-XZ17〕 | 新 | 闭包统一以「域」：资域、扰域、及域、感域、群域 |
| 扰域（擾域） | 影响闭包（influence closure） | `Flow.WithinInfluence` | 「知風之自」〔RU1-S-ZY〕 | 新 | — |
| 及域 | 所及闭包（reach closure） | `Flow.WithinReach` | 「知遠之近」〔RU1-S-ZY〕 | 新 | — |
| 感域 | 耦合闭包（coupling closure） | `Flow.WithinCoupling` | — | 新 | — |
| 群域 | 系统闭包（system closure） | `Flow.WithinSystem` | — | 新 | — |
| 所及 | 部分所及（what a part reaches） | — | — | 复 | 单步之所及 |
| 择（擇） | 选择（selection）：关于水平历史的任何主张 | — | — | 古 | — |
| 缘感而择（緣感而擇） | 经耦合的选择（selection through couplings） | `Web.SelectsThrough` | — | 新 | Web.selects_alike_iff 是其定义等价（定义律） |
| 及而不感 | 选择的缺口：所及闭包中不在耦合闭包内者 | `SelectionGap`；`Flow.act_unselected`；`Flow.consequence_unselected` | — | 新 | 取代「蔽」作界限之名 |
| 无明（無明） | 无明：锁定在不能停息之目标上的寻求 | `Law.aboveAll_never_rests`；`more_needs_open`；`Law.rests_iff` | — | 复 | 已采；不同于十二因缘之首支；rests_iff 是其边界 |
| 明 | 明：耦合接上一个及于支持所不标记者的选择 | `Web.observed_raise_couples` | 「浸潤之譖，膚受之愬，不行焉，可謂明也已矣」〔RU1-S-LY〕 | 古 | 已采；「知常曰明」对应「常」，不作明之引 |
| 兼感 | 合用耦合（pooled coupling） | `SelectionPool` | — | 新 | 兼取「合为整体」义 |
| 劫 | 经规则的劫持（capture through the rule）：规则从它所选者的份额读出 | `RuleCapture` | 「凡劫有三」〔FA1-S-H16〕 | 古 | 君臣框架不入 |
| 与时转（與時轉） | 规则改变之速（pace） | `Pace`；`Pace.pace_law` | 「法與時轉則治」〔FA1-S-H54〕 | 复 | 韩非子心度 |
| 应域（應域） | 回应闭包（response closure） | `Flow.WithinResponse` | — | 新 | 感域之对偶（Flow.withinResponse_iff_coupling） |
| 择者（擇者） | 选择者（selector）：选择所经耦合的那个形成 | — | — | 新 | 依待者、取者之式 |
| 执（執） | 规则持住结果（capture） | `Capture` | 「為者敗之執者失之」〔V130-LAO-MA〕 | 古 | 老子六十四章此句作条目 |
| 劫及其读（劫及其讀） | 读法本身由份额形成时，读法之变也被吸收（closed capture） | `ClosedCapture` | — | 新 | — |
| 时稽（時稽） | 读取步（the reading step of a pace） | `Pace` | 「兼听而时稽之」〔RU2-S-XZ09〕 | 复 | 荀子王制 |

## C11 回路、反馈、阈值与调节

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 环（環） | 回路（loop） | `OnLoop` | — | 古 | — |
| 成环（成環） | 成环（closing） | `Closing` | — | 新 | — |
| 还（還） | 反馈（feedback） | — | — | 古 | 回馈义始见于注层（河上公、苏辙）；先秦对应句曾子「出乎尔者，反乎尔者也」 |
| 报（報） | 环返映射：各环节回应复合后交回起点之量 | `LoopReturn.returnMap` | — | 古 | 单环节之回应用「应」；报答、交易义不入 |
| 滋 | 失控（runaway through a loop） | `LoopReturn.runs_away`；`LoopReturn.runs_away_unbounded` | — | 古 | 循环失控义是约定，滋本义为滋长；polynomial_iff_no_loop 之前提照记 |
| 未兆 | 断裂之前未被读到（the break not read before it） | `Web.break_not_bounded` | 「其未兆易謀」〔FA1-S-H21〕 | 复 | —；老子六十四章只给「未兆」之词义（尚无征兆），其句之结构是机之前护闭，作对照 |
| 穷（窮） | 断点（the break）：存量降到阈下，律由不读转为读 | `ExchangeLaw.ReadsBelow` | — | 古 | 只名降到阈下之断裂；系辞之穷（不能再续）、序卦之窮（终尽）、墨经空间之穷不入 |
| 频数（頻數） | 耦合的频度（frequency） | `Frequency` | — | 复 | 约定，低置信；古之頻數多作副词 |
| 不已 | 复现（a coupling recurs） | `CouplingRecurs` | 「惟天之命，於穆不已」〔RU1-S-ZY〕 | 复 | 已为止息，不已即不止而复现 |
| 所失 | 截断于某阶所未计入之量 | `Remainder` | — | 复 | 取代「余」 |
| 应倍（應倍） | 耦合强度（coupling strength） | — | — | 新 | — |
| 中和 | 中和（two-sided regulation） | `Regulation` | 「致中和」〔RU1-S-ZY〕 | 复 | 已采 |
| 中节（中節） | 界恰为无过冲 | `Regulation` | 「發而皆中節，謂之和」〔RU1-S-ZY〕 | 复 | — |
| 过正（過正） | 过冲（overshoot） | `Regulation` | — | 复 | — |
| 一偏 | 只对一侧回应（单侧前提，不是调节） | `Regulation` | — | 复 | Regulation.OneSided 是空流见证；有交换的单侧之律是缺口 |
| 识不早（識不早） | 迟读（reading late） | `Regulation.no_narrower_band` | — | 新 | 只名迟读（Regulation.ReadsLate）；未读入用「未兆」或平语 |
| 不求备（不求備） | 容差（tolerance） | `Tolerance.tolerating`；`Tolerance.web_tolerating` | 「無求備於一人」〔RU1-S-LY〕 | 复 | 只名 tol≥1；tol=0 即不念旧恶之律 |
| 有以待之 | 从每个起点恢复（restoring from every start） | `Tolerance.worst_start`；`Tolerance.restored_stays` | 「恃吾有以待之」〔BI1-S-SZ〕 | 复 | 此处「待」为应对义，与依存之「待」异义，只在此成语中 |
| 先施 | 持续先给（每步都给，不看所等待者） | `Withholding.Ring.givesFirst_restores`；`Tolerance.restores_iff`；`Tolerance.givesFirst_restores_of_answers` | 「所求乎朋友，先施之」〔RU1-S-ZY〕 | 复 | 中庸 |
| 可致 | 所携带的量（carried amount） | `carried`；`most_difference_arrives` | — | 复 | 原拟「所致」；先秦「所致」多作因果归属 |
| 抑举（抑舉） | 接力（the relay） | `Regulation.relay`；`Regulation.relay_threshold` | 「高者抑之，下者举之」〔DS01〕 | 复 | 老子七十七章 |

## C12 演化、世系与传递

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 所出 | 世系（descent） | `Flow.DescendsAt` | — | 复 | 方向：「x 出于 g」，「x 之所出」＝给予者 g；后代写作「出于 g 者」；出随聚，不随作 |
| 因 | 承继（inheritance） | `Web.InheritsAt` | 「殷因於夏禮，所損益可知也」〔RU1-S-LY〕 | 古 | 与「损益」同出论语 |
| 传（傳） | 传递（transmission） | `Flow.TransmitsWithin` | — | 古 | 只取「因而所需有界」一构；古书「傳」多指递接，那一构名「火传」；层次标签之「传」是文献层 |
| 损益（損益） | 变异（variation：升与降） | — | 「殷因於夏禮，所損益可知也」〔RU1-S-LY〕 | 复 | 后代之量对其亲代之量之升与降；与「损」「益」之单字（一族跨步之水平改动）构造不同；Price 等式名「损益之计」 |
| 传择（傳擇） | 经世系之演化：只有被支持者有后代；界内所传之所需在界内被选出 | `Evolution` | — | 新 | 此「择」是经支持之有无而选出，不是缘感而择 |
| 益之者 | 净给予者（net giver） | `Flow.NetGiver` | 「或益之」〔DS13〕 | 复 | — |
| 象 | 模型：映射本身（r : K → V） | `Relabel.selected_alike_iff` | 「象也者，像也」〔DS03〕 | 古 | 择之象是一个择所经之象 |
| 取法 | 经他者实际回应之学 | `ResponseLearning.learn_through_interface` | 「有王者起，必来取法」〔RU2-S-MZ〕 | 复 | 「大匠取法焉」（核对参照）与佛典执取义不入 |

## C13 群、分与共同

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 同力 | 合起来造成的差别（difference made together） | `Dependence.MakesDifferenceTogether` | — | 新 | 与「有力」成对 |
| 群 | 群（collective） | `Flow.WithinSystem`；`Flow.system_whole_of_common` | 「群居而無分則爭」〔RU2-S-XZ10〕 | 古 | 群域之群居加「分」之足迹之界 |
| 分 | 分（exclusive footprints） | `JointPlan.supports_of_realizes` | 「群而无分则争」〔RU2-S-XZ09〕 | 古 | 分只给足迹 |
| 分数（分數） | 联合计划（joint plan） | `JointPlans` | 「凡治衆如治寡，分數是也」〔BI1-S-SZ〕 | 复 | 孙子 |
| 出入相掩（出入相揜） | 在一个条件上，一步之所取不多于所给 | `Flow.WithinJoint`；`Flow.joint_keeps` | — | 复 | 荀子原文在等级比例框架中，不入 |
| 争（爭） | 在共享条件处的竞逐（race at a shared condition） | `Flow.joint_excess_ends`；`Flow.race_ends_greatest` | — | 古 | — |
| 称（稱） | 相对位置（relative position） | `RelativePosition.positions_balance`；`RelativePosition.change_opposed` | — | 古 | 只名对全族之和之相对位置；相称、比例之义不入；相轧作对照条目 |
| 同患 | 共同条件（a condition every formation shares） | `Flow.mutuallyDependent_of_common` | 「當其同舟而濟」〔BI1-S-SZ〕 | 复 | — |
| 交相资（交相資） | 互相供给（mutual feeding） | `Flow.MutuallyFed` | 「兼相愛、交相利」〔MO1-S-C15〕 | 新 | 取代「交相利」；利之价值义不携带 |
| 和而不同 | 合用之所增（what pooling adds） | `Web.pool_adds`；`Web.separates_all_iff` | 「君子和而不同」〔RU1-S-LY〕 | 复 | — |
| 同而不和 | 等于一个成员的合用 | `Web.pooled_iff_member` | 「小人同而不和」〔RU1-S-LY〕 | 复 | 不带君子／小人之品第 |
| 念旧恶（念舊惡） | 有记忆的等待之给 | `Withholding.waitsAll` | 「伯夷、叔齊，不念舊惡」〔RU1-S-LY〕 | 复 | 肯定式由「不念旧恶」反推 |
| 不念旧恶（不念舊惡） | 无记忆的等待之给 | `Withholding.answers`；`Withholding.withholding_returns`；`Withholding.Ring.answers_circulates` | 「伯夷、叔齊，不念舊惡」〔RU1-S-LY〕 | 复 | — |
| 得兼 | 诸条件同时保持 | `Viability.kernel_and_iff` | 「二者不可得兼」〔RU2-S-MZ〕 | 复 | 兼取「合」义，与整体之兼同字 |
| 合致而无独致（合致而無獨致） | 多重决定：合起来造成而无一部分单独造成 | `Dependence.DifferenceOnlyTogether` | — | 新 | — |
| 為天下先 | 在一切之上之目标（the target above all others） | `aboveAll_unique`；`Law.aboveAll_never_rests` | 「不敢為天下先」〔V130-LAO-MA〕 | 复 | 老子六十七章；与「无明」相邻 |
| 不校 | 闭合的一环：交回少于所受 | `LoopReturn` | 「犯而不校」〔RU1-S-LY〕 | 古 | 论语 |

## C14 意义、评价与延续之条件

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 顾（顧） | 意义（significance）：唯一给出的评价参数 | — | 「長慮顧後而保萬世」〔RU2-S-XZ04〕 | 古 | 注视、知觉、看中其用（匠伯不顾）、照料不入 |
| 顾式（顧式） | 评价（valuation） | `Valuation` | — | 新 | — |
| 活 | 活的（living） | — | — | 古 | —；存活、使活不入；活不是生生 |
| 活皆有顾（活皆有顧） | 生命意义（living significance） | `LivingSignificance`；`Valuation.significant_iff` | — | 新 | 取代「仁」；仁作相分条目 |
| 凡续皆有顾（凡續皆有顧） | 延续条件（the continuation condition）：陈述而不断言；定范围，不排序 | `Unrestricted` | — | 新 | 设，不断言；取代「无弃」 |
| 方 | 立场（standpoint） | — | — | 古 | 取方所、所在之义为立场；「方生方死」之「方」（方且）、方术、方法、方向不入 |
| 我 | 中心（center，评价之中心） | — | — | 古 | 修订者核对 center_not_derived 之结构 |
| 己 | 自身区域（own region） | — | — | 古 | — |
| 萌 | 种子（seed） | — | 「而莫知其所萌」〔ZH1-S02〕 | 古 | 取代「端」之种子义；自长义不入 |
| 自顾（自顧） | 自身意义（self-significance） | — | — | 新 | 取代「自爱」 |
| 无亲（無親） | 关系中立（relational neutrality） | — | 「至仁无親」〔ZH1-S14〕 | 复 | 不带「常与善人」 |
| 无方（無方） | 立场中立与立场不变（standpoint neutrality） | — | 「是謂无方」〔ZH1-S17〕 | 复 | 秋水；立贤无方、无方之民不入 |
| 尽（盡） | 中立（Neutral：∀） | `Neutral` | 「盡，莫不然也」〔MI1-S-JS〕 | 古 | 墨经；兼爱「兼以易别」作对照条目 |
| 别（別） | 有界之顾（bounded significance）：在区域内有意义，在外无 | — | — | 古 | 墨子之「别」 |
| 畛 | 自身的边界（the boundary of a self） | — | 「爲是而有畛也」〔ZH1-S02〕 | 古 | 齐物论 |
| 畛内之顾（畛內之顧） | 预设（the presupposition） | `SignificantWithin` | — | 新 | — |
| 不易乎畛 | 不变的一步（the step of invariance）：预设不随边界怎样划而改变 | `BoundaryInvariant` | 「不易乎世」〔DS10〕 | 新 | 只定范围，不排序；无己作相分条目 |
| 皆顾之活（皆顧之活） | 从意义读出的正面相关 | — | — | 新 | 内容须是已实现者 |
| 畛内皆然（畛內皆然） | 有界规则（Within）：只在一个已形成之界内被接受之规则 | `Within` | — | 新 | — |
| 皆在己 | 被持有（held） | — | — | 复 | 原拟「在己」；荀子「在己者」之控制义不入 |

## C15 比较、取舍与践行

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 不行不至 | 请求的改变须是可执行的序列 | `Assurance.completes_iff_runs`；`Assurance.runs_of_completes` | 「道雖邇，不行不至」〔RU2-S-XZ02〕 | 复 | 合「法不自行」于此 |
| 权（權） | 实践判断（practical judgment） | — | 「於所體之中而權輕重，之謂權」〔MI1-S-DQ〕 | 古 | 只名在给定整体之内按所给比较定轻重；秤之全序（古今之正权）、越过常规之例外许可不入 |
| 以广为愈（以廣爲愈） | C，扩大的比较：扩大更好；唯一排序历程的前提 | `Comparison`；`Web.paths_comparison_widens` | — | 新 | 设，明载「更好」；所有说排序之处只引它 |
| 无丧（無喪） | 保留（retains） | `Web.Retains` | — | 复 | 与 Web.Retains 相合只在同类可换之交换；井卦辞「无喪无得」是水平不低于起点（Flow.level_kept），同字异构，作对照 |
| 有得 | 增加（adds） | `Web.Adds` | — | 复 | 与「无丧」成对 |
| 兼权（兼權） | J1 完全比较 | `Lexical.BasicPriority` | — | 复 | 保留损失一半以老子七十九章「和大怨，必有餘怨」为主证 |
| 无以小害大（無以小害大） | J2 基本条件优先 | `FrontierFrames.Priority` | 「无以小害大」〔RU2-S-MZ〕 | 复 | 孟子之小大是层（体之贵贱），不是量；与同类积小之「小」不同；不带「无以贱害贵」之等级义 |
| 量力而任 | J3 有界责任 | — | 「力不足者，中道而廢」〔RU1-S-LY〕 | 新 | 论语；墨经「任」（士损己而益所为）不入 |
| 同类积小（同類積小） | FR 有限回应（finite responsiveness） | — | — | 新 | FR 是可修订之承诺，不是律；同类之内不设永久之轻重词典序 |
| 足而止 | 够而停（rests exactly where the target is met） | `Law.rests_iff` | 「知足不辱，知止不殆」〔FA1-S-H46〕 | 复 | — |
| 先取 | 先占（preemption） | `Preemption.not_undermining_yet_loses`；`Flow.Balances.includes_of_renewed` | — | 新 | 取代「先占」：先取只说在依存形成之前汲取；前一锚是见证 |
| 令不必成 | 请求不等于完成 | `Countdown.exits`；`Countdown.Slow.misses` | 「使，令謂，謂也，不必成」〔MI1-S-SS〕 | 复 | 墨经 |
| 取于可得（取於可得） | J4 正当可行的选择 | `FrontierWorlds` | — | 新 | 「可得」（荀子正名「欲不待可得」）名一步可达之选项；正当一半暂缺其名 |
| 皆愈 | 提升规则 L：每一结果都好于每一结果 | `LiftBetter` | — | 新 | 设 |
| 或足 | 可能之够 | `Enough.Free.stays_meet_not_assured` | — | 新 | — |
| 必足 | 保证之够 | `Enough.assured_iff` | — | 新 | — |

## C16 推理、证明与方法

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 设（設） | 陈述而不断言者 | — | — | 古 | 延续条件、以广为愈、作为具名条件之 LPO 等；一条律的局部假设以「若」写出，不叫设 |
| 无设而然（無設而然） | 不加前提的定理 | — | — | 新 | 四种地位之一 |
| 有设而然（有設而然） | 在所述前提下的定理 | — | — | 新 | 四种地位之一 |
| 证（證） | 已检查的陈述（定理）与其检查 | — | — | 古 | 经说证三分之「证」 |
| 未决（未決） | 未决（open） | — | 「疑者未決之辭」〔YD-CY〕 | 复 | — |
| 说（說） | 推导（derivation） | `Derivation.Derives` | 「說，所以明也」〔MI1-S-JS〕 | 古 | 墨经；经说证之「说」同义（所以明） |
| 不然者 | 反例与反模型 | — | 「一然者一不然者，必不必也」〔MI1-S-SS〕 | 复 | — |
| 定然否 | 已定（decided：p 或非 p） | `Decided` | 「未可定然否也」〔RU2-S-XZ21〕 | 新 | — |
| 不可非 | 双重否定（¬¬p） | — | 「其理不可非」〔MI1-S-SX〕 | 新 | — |
| 辞皆定然否（辭皆定然否） | 排中律 | — | — | 新 | — |
| 或不当（或不當） | 弱已定（weakly decided） | `WeaklyDecided` | 「不俱當，必或不當」〔MI1-S-SS〕 | 新 | 只对相矛盾之一对辞成立；作为对一切辞之全称是弱排中律，属设 |
| 无穷可尽（無窮可盡） | LPO：每一布尔序列或有一处为真，或处处为假 | — | 「無窮不害兼」〔MI1-S-JX〕 | 新 | 出处作对照 |
| 相合 | 相合（agreement） | — | 「名實耦，合也」〔MI1-S-SS〕 | 复 | RO 三种关系 |
| 定域 | 定域（scope） | — | — | 新 | RO 三种关系 |
| 相分 | 相分（divergence） | — | — | 复 | RO 三种关系；引唯识时「相分」放在引号中并注其所缘之相义 |
| 以明 | 非二方法（the nondual method） | — | 「莫若以明」〔ZH1-S02〕 | 复 | 方法要求，不设 Lean 锚；「照之于天」之圣人中心不携带 |
| 无穷可定其皆否（無窮可定其皆否） | WLPO | — | — | 新 | — |
| 非皆否则有是（非皆否則有是） | Markov 原则 | — | — | 新 | — |
| 不可非则然（不可非則然） | 稳定（¬¬q → q） | — | — | 新 | 不用「稳」 |
| 拟（擬） | 表示（a representation an account uses） | — | 「拟之而后言」〔DS02〕 | 古 | 与象、读分开 |
| 有之必然 | 充分条件 | — | 「大故，有之必然」〔MI1-S-SS〕 | 复 | 墨经大故定义之前一半 |

## C17 时、位、势与情境

| 名 | 所名 | 锚 | 出处 | 式 | 注 |
|---|---|---|---|---|---|
| 涯 | 视界（horizon） | `Diagonal.Unfolds.unheld`；`Learning.no_prefix_fixes_next` | 「吾生也有涯，而知也无涯」〔ZH1-S03〕 | 古 | prefix_does_not_decide 是例 |
| 时（時） | 情境（situation） | `Situations` | 「夫遇不遇者，時也」〔RU2-S-XZ28〕 | 古 | 荀子宥坐；王弼「卦者，时也」之时是构形，作对照 |
| 先后（先後） | 步序 | `Interleavings` | 「行脩以久，說在先後」〔MI1-S-JX〕 | 复 | D43 |
| 位 | 位（place） | `HexagramPlaces` | — | 古 | 已有易章 |
| 当位（當位） | 当位 | `HexagramPlaces` | — | 复 | — |
| 正 | 正 | `HexagramPlaces` | — | 古 | 只名 inPhase；贞正之例不入 |
| 中位 | 中位 | `HexagramPlaces` | — | 复 | — |
| 相应（相應） | 爻之相应（opposed lines） | `Hexagram.opposed` | — | 复 | 单用「应」只作回应 |
| 比 | 比（adjacent lines） | — | — | 古 | 约定：只名相邻相异，不带亲附 |
| 承 | 承 | — | — | 古 | 只名下柔上刚之缝；在下承上之通义与「相承」相助之义不入 |
| 乘 | 乘 | — | — | 古 | 趁、驾之义不入 |
| 独异（獨異） | 独异之线（sole line） | `HexagramSites` | — | 新 | 取代「上下应」 |
| 变通（變通） | 规则读取所处之构形而变 | `Pace`；`Pace.rule_alike_until_reading` | 「变通者，趣时者也」〔DS03〕 | 复 | Switching 是例 |
| 通 | 可（the run continues） | `Onward.run_iff_continues` | 「推而行之谓之通」〔DS02〕 | 古 | 只取一构 |
| 刚柔（剛柔） | 爻值 | `Hexagram` | 「刚柔相推而生变化」〔DS02〕 | 复 | 取代阴阳作爻值之名 |
| 交错（交錯） | 交错（interleavings） | `Interleavings` | — | 新 | D43：步序是读法，只在每两次交换共享关系项处由关系推出 |
| 至期所及 | 到时限为止来源经耦合到达读者（reached by） | `TimedResponse.ReachedBy` | 「能使敵人前後不相及」〔BI1-S-SZ〕 | 新 | — |
| 位分 | 只在两端之间有定奇偶（fixed phase） | `Hexagram.fixedPhase` | 「去初上而論位分」〔YWH-LB〕 | 复 | 王弼；不带由尊卑推位之义 |
| 二体（二體） | 卦之两半（halves） | `Hexagram.halves` | 「舉二體」〔YWH-LM〕 | 古 | 王弼 |

