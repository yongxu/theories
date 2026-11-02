#!/usr/bin/env python3
"""GC2: the chain's open proposals decided, the entries' text changes (A1-A8, the batch-B scope sentence, B1, B3's
labels, B4 at the two renamed records, B6, the key of retired labels). Each change replaces one exact string that must
occur exactly once in its field, before and never after; the run refuses otherwise and writes nothing.

usage (from the checkout root): python3 -B apply_text.py [--dry-run]
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
DATA = ROOT / 'theories/becoming/results/data/generativity-chain.json'

S_EN = ('living significance (every living claim has significance from every standpoint) follows under the '
        'continuation condition, which the theory does not assert (07 §3); the favourable significance of life and its '
        'further generation that G0 stated is not that significance: further generation is 生生, compared by widening, '
        'and ranking rests on C, widening what can form is better, also not asserted (07 §4)')
S_ZH = ('在延续条件之下（理论不断言，07 §3）得出生的意义，即每一生的主张从每一立场都有意义；G0 所述生及其继续生成的正面意义'
        '并非这一意义：继续生成是生生，以拓宽相比较，排序依于 C，即拓宽可形成者为更好，亦不断言（07 §4）')

# (proposal, entries, field, old, new)
EDITS = [
    # A1: the status clause, and §6.15 as 07 §3
    ('A1', ['C03'], 'scope_en',
     "G0 is no longer an axiom: it is a theorem with Ren's proposed axiom as its condition, a condition the theory does "
     "not assert (section 6.15), without claiming a premise-free proof of that starting point",
     'G0, once a starting point, is no premise of the current account: ' + S_EN +
     '; no premise-free proof of either premise is claimed'),
    ('A1', ['C03'], 'scope_zh',
     'G0 不再是公理：以 Ren 提议的一条公理为条件，它是定理（理论不断言这一条件，§6.15），不宣称起点已无前提得证',
     'G0 曾为起点，今不是现论的前提：' + S_ZH + '；不宣称任一前提已无前提得证'),
    ('A1', ['C17'], 'claim_en',
     'G0, once adopted as an axiom for the alignment task, is now a theorem with the condition of section 6.15 '
     '(Unrestricted, which the theory does not assert), and a premise-free proof of it is not a completion gate for this '
     'route.',
     'G0, once adopted as an axiom for the alignment task, is no premise of the current account: ' + S_EN +
     '; a premise-free proof of either premise is not a completion gate for this route.'),
    ('A1', ['C17'], 'claim_zh',
     'G0 曾作为 alignment 任务的公理采用，现为以§6.15之条件（Unrestricted，理论不断言）为条件的定理，其无前提证明不是这一路线的完成门槛。',
     'G0 曾作为 alignment 任务的公理采用，今不是现论的前提：' + S_ZH + '；任一前提的无前提证明都不是这一路线的完成门槛。'),
    ('A1', ['C24'], 'scope_en',
     'Complete general candidate under the disclosed J1–J4 and G0, now a theorem with the condition of section 6.15 '
     '(Unrestricted, which the theory does not assert);',
     'Complete general candidate under the disclosed J1–J4 and G0, then a starting point (in the current account ' +
     S_EN + ');'),
    ('A1', ['C24'], 'scope_zh',
     '在公开的 J1–J4 与 G0（现为以§6.15之条件（Unrestricted，理论不断言）为条件的定理）之下的完整一般候选；',
     '在公开的 J1–J4 与当时作为起点的 G0 之下的完整一般候选（现论中，' + S_ZH + '）；'),
    ('A1', ['M15'], 'scope_en',
     'G0 is now a theorem with the condition of section 6.15 (Unrestricted, which the theory does not assert), with '
     'practical commitments and E disclosed.',
     'G0 is no premise of the current account: ' + S_EN + '; practical commitments and E stay disclosed.'),
    ('A1', ['M15'], 'scope_zh',
     'G0当前是以§6.15之条件（Unrestricted，理论不断言）为条件的定理，实践承诺与E明示。',
     'G0 今不是现论的前提：' + S_ZH + '；实践承诺与E明示。'),
    ('A1', ['M20'], 'scope_en',
     '(G0 now a theorem with the condition of section 6.15, Unrestricted, which the theory does not assert)',
     '(G0 then a starting point; in the current account ' + S_EN + ')'),
    ('A1', ['M20'], 'scope_zh',
     '（在 G0 与 J1–J4 之下；G0 现为以§6.15之条件（Unrestricted，理论不断言）为条件的定理）',
     '（在 G0 与 J1–J4 之下；G0 当时为起点，现论中' + S_ZH + '）'),
    ('A1', ['M20'], 'claim_en',
     'then actual generative correspondence feeds G0 positive ground.',
     'then, where each completion corresponds to new living content, the run realizes such content, which under the '
     'continuation condition falls under the relevance read from significance (07 §3.2).'),
    ('A1', ['M20'], 'claim_zh',
     '再以实际生成对应接入G0正面根据',
     '再在每次完成对应新的生的内容时实现这种内容，它在延续条件之下落入由意义读出的相关性（07 §3.2）'),
    ('A1', ['M20'], 'claim_en',
     'inherited generation actually feeds the positive-ground interface obtaining G0,',
     'inherited generation actually realizes new living content, which under the continuation condition falls under '
     'the relevance read from significance,'),
    ('A1', ['M20'], 'claim_zh',
     '旧生成输出实际进入取得G0的正面根据接口',
     '旧生成输出实际实现新的生的内容，它在延续条件之下落入由意义读出的相关性'),
    ('A1', ['M21'], 'claim_en',
     'Under G0, consciousness differentiates living significance and new living can count positively without assigning '
     'a specific duty.',
     'Read with the direction of 生生, consciousness differentiates living significance, and new living can count '
     'positively, a count that rests on C (07 §4), without assigning a specific duty.'),
    ('A1', ['M21'], 'claim_zh',
     'G0下意识分化生的意义，新的生也可有正面意义且不自动产生特定义务。',
     '以生生的方向读之，意识分化生的意义，新的生也可计为正面，此计依于 C（07 §4），且不自动产生特定义务。'),
    ('A1', ['M21'], 'claim_en',
     'that conditional difference does not prove G0 or the condition it follows from (section 6.15, which the theory '
     'does not assert).',
     'that conditional difference does not prove G0, nor the continuation condition or C, neither of which the theory '
     'asserts (07 §3–§4).'),
    ('A1', ['M21'], 'claim_zh',
     '条件性选择差异不反过来证明 G0 或其所出的条件（§6.15，理论不断言）。',
     '条件性选择差异不反过来证明 G0，也不证明延续条件或 C，二者理论都不断言（07 §3–§4）。'),
    ('A1', ['M21'], 'scope_en',
     'criticism of a restriction does not prove its opposite, G0, which is now a theorem with the condition of section '
     '6.15 (Unrestricted, which the theory does not assert).',
     'criticism of a restriction does not prove its opposite, G0, which is no premise of the current account '
     '(07 §3–§4).'),
    ('A1', ['M21'], 'scope_zh',
     '批评限制不等于证明其反面 G0；G0 现为以§6.15之条件（Unrestricted，理论不断言）为条件的定理。',
     '批评限制不等于证明其反面 G0；G0 今不是现论的前提（07 §3–§4）。'),
    ('A1', ['M21'], 'scope_en',
     'under the continuation condition of section 6.15',
     'under the continuation condition (07 §3)'),
    ('A1', ['M21'], 'scope_zh',
     '在§6.15的延续条件之下',
     '在延续条件之下（07 §3）'),
    # A2: the decisions M26's binding laws take
    ('A2', ['M26'], 'claim_en',
     'a form resolves to a meaning in a repertoire without repeats exactly when',
     'with meanings compared decidedly, a form resolves to a meaning in a repertoire without repeats exactly when'),
    ('A2', ['M26'], 'claim_zh',
     '形式在不重复的候选范围中解析为某意义',
     '意义可判定地比较时，形式在不重复的候选范围中解析为某意义'),
    ('A2', ['M26'], 'claim_en',
     "and dated records settle an earlier record's content",
     "and, with reports and contents compared decidedly, dated records settle an earlier record's content"),
    ('A2', ['M26'], 'claim_zh',
     '日期化记录在一族历史中确定旧记录的内容',
     '报告与内容可判定地比较时，日期化记录在一族历史中确定旧记录的内容'),
    # A3: observation and dependence, settled
    ('A3', ['M26'], 'scope_en',
     'that observation is no second relation beside dependence is a conjecture and is not part of this link.',
     'whether observation is a second relation beside dependence is settled at the step of the exchange: dependence '
     'alone carries exactly the responses rising with a level, and a fall only where some level falls '
     '(what-dependence-alone-carries-of-a-level), and observation and dependence are both coupling, by level and by '
     'threshold (where-a-level-couples, D45); neither result is part of this link.'),
    ('A3', ['M26'], 'scope_zh',
     '“观察不是依赖之外的第二种关系”是猜想，不在这一环节之内。',
     '观察是否为依赖之外的第二种关系，已在交换之步解决：单凭依赖恰好带出随某水平上升的回应，只在某水平下降处带出下降'
     '（what-dependence-alone-carries-of-a-level）；观察与依赖都是耦合，分别依水平与依阈值（where-a-level-couples，D45）；'
     '二者都不在这一环节之内。'),
    # A4: the range of the partial-correction boundary
    ('A4', ['M20'], 'claim_en',
     'all positive renewal states in the original zero-error model reach protection in finite time iff beta<=5/12',
     'for 0 ≤ beta ≤ 3/4, all positive renewal states in the original zero-error model reach protection in finite time '
     'iff beta<=5/12'),
    ('A4', ['M20'], 'claim_zh',
     '原无误差模型所有正维护初态均有限进入保护区，当且仅当β≤5/12',
     '0≤β≤3/4时，原无误差模型所有正维护初态均有限进入保护区，当且仅当β≤5/12'),
    # A5: the decisions the extreme classifications take
    ('A5', ['M20'], 'claim_en',
     'Classification-robust comparison is now proved: strict agreement at the all-secondary and all-basic endpoints',
     'Classification-robust comparison is now proved: where the realizations compared are decided, strict agreement at '
     'the all-secondary and all-basic endpoints'),
    ('A5', ['M20'], 'claim_zh',
     '分类稳健比较现已证明：新内容全部列一般与全部列基本这两个端点同向严格改善',
     '分类稳健比较现已证明：所比较的实现可判定时，新内容全部列一般与全部列基本这两个端点同向严格改善'),
    # The batch-B option: decided completion named in M20's scope
    ('A1+', ['M20'], 'scope_en',
     'Execution, handoff, generative correspondence and Unrestricted remain explicit.',
     'Decided completion, execution, handoff, generative correspondence and Unrestricted remain explicit.'),
    ('A1+', ['M20'], 'scope_zh',
     '运行、交接、生成对应与Unrestricted保持显式。',
     '完成可判定、运行、交接、生成对应与Unrestricted保持显式。'),
    # A6: the excluded middle some joining and granularity laws take (C30 and F22 carry the same sentences)
    ('A6', ['C30', 'F22'], 'claim_en',
     'Receiving-side finite branching and translated-answer agreement match histories with different native lengths.',
     'Under excluded middle, receiving-side finite branching and translated-answer agreement match histories with '
     'different native lengths.'),
    ('A6', ['C30', 'F22'], 'claim_zh',
     '接收侧有限分支及翻译问答一致迫出不同原生步数的有限历史匹配。',
     '在排中律下，接收侧有限分支及翻译问答一致迫出不同原生步数的有限历史匹配。'),
    ('A6', ['C30', 'F22'], 'scope_en',
     'Fixed finite expansion, complete question agreement and actual correspondence remain explicit.',
     'Fixed finite expansion, complete question agreement, excluded middle and actual correspondence remain explicit.'),
    ('A6', ['C30', 'F22'], 'scope_zh',
     '固定有限展开、问答一致与实际对应明示',
     '固定有限展开、问答一致、排中律与实际对应明示'),
    ('A6', ['C30', 'F22'], 'claim_en',
     'Across different fragment carriers, incidence agreement yields a common refinement with one-position lifting and '
     'a unique join-preserving factor commuting with given projections.',
     'Across different fragment carriers, roots alike through their incidence roles yield, with no finiteness or '
     'decision, a common refinement with one-position lifting and a unique join-preserving factor commuting with given '
     'projections; roots agreeing on every incidence question do so under excluded middle with local finiteness.'),
    ('A6', ['C30', 'F22'], 'claim_zh',
     '不共用片段载体时，关联同测可导出单位置接合的共同细化及与既有投影相容的唯一保接合因子；',
     '不共用片段载体时，经关联角色相似的根无需有限或判定即可导出单位置接合的共同细化及与既有投影相容的唯一保接合因子；'
     '在排中律及局部有限下，关联同测的根亦然；'),
    ('A6', ['C30', 'F22'], 'scope_en',
     'Incidence refinement uses local finiteness and connectivity; reference repair uses equal initial slot counts, '
     'complete answer agreement and finite fixed-pair outcomes.',
     'Incidence refinement uses connectivity, and from roots agreeing on incidence questions also local finiteness and '
     'excluded middle; reference repair uses equal initial slot counts with alike starts, or complete answer agreement '
     'with finite fixed-pair outcomes and excluded middle.'),
    ('A6', ['C30', 'F22'], 'scope_zh',
     '关联细化用局部有限及连通；引用修复用初始位置数相同、完整问答一致及固定输入对有限结果。',
     '关联细化用连通，以关联同测的根时另用局部有限及排中律；引用修复用初始位置数相同及相似的起点，或完整问答一致、'
     '固定输入对有限结果及排中律。'),
    ('A6', ['C30', 'F22'], 'claim_en',
     'The continuation permits multivalued joining itself: finite outcome fibers and richer branch questions force a '
     'common joining relation; each code result lifts from the originally specified inputs.',
     'The continuation permits multivalued joining itself: under excluded middle, finite outcome fibers and richer '
     'branch questions force a common joining relation, and each code result lifts from the originally specified '
     "inputs; where the descriptions' one kernel is a bisimulation of the joining, both hold with no premise."),
    ('A6', ['C30', 'F22'], 'claim_zh',
     '后续允许接合本身有多个结果：有限结果纤维及更丰富的分支问答迫出共同接合关系，原指定输入能实现每个代码结果；',
     '后续允许接合本身有多个结果：在排中律下，有限结果纤维及更丰富的分支问答迫出共同接合关系，原指定输入能实现每个代码结果；'
     '描述的共同核是接合的互模拟时，二者无需前提即成立；'),
    ('A6', ['C30', 'F22'], 'claim_en',
     'Beyond macro recovery, common syntax and complete native-answer agreement match partial histories with residuals '
     'retained.',
     'Beyond macro recovery, common syntax and alike starts match partial histories with residuals retained, as does '
     'complete native-answer agreement under excluded middle with receiving-side finite branching.'),
    ('A6', ['C30', 'F22'], 'claim_zh',
     '宏问答恢复之外，相同语法与全部原生问答同测可匹配每个部分历史并保留余项。',
     '宏问答恢复之外，相同语法与相似的起点可匹配每个部分历史并保留余项；在排中律及接收侧有限分支下，全部原生问答同测亦然。'),
    # A7: the decided equality the copying laws take; B4 at the renamed record: the contact machine
    ('A7', ['C14'], 'claim_en',
     'The structural, registration, correction and chain-assembly machines are instances of general copying laws for '
     'every alphabet and law of draws:',
     'The structural, contact, correction and chain-assembly machines are instances of general copying laws for every '
     'alphabet with decidable equality and every law of draws:'),
    ('A7', ['C14'], 'claim_zh',
     '结构复制、配准、纠正与链组装机都是对每个字母表与汲取律成立的一般复制律的实例',
     '结构复制、接触、纠正与链组装机都是对每个相等可判定的字母表与每个汲取律成立的一般复制律的实例'),
    ('A7', ['C14'], 'claim_en',
     'inspecting a site against a reference never increases defects exactly when the reference agrees with the '
     'template there.',
     'inspecting a site against a reference never increases defects exactly when, wherever both have a token there, '
     'the reference agrees with the template.'),
    ('A7', ['C14'], 'claim_zh',
     '在某位对照参考检查不增加缺陷，当且仅当参考在该位与模板一致。',
     '在某位对照参考检查不增加缺陷，当且仅当参考与模板在该位都有记号时二者一致。'),
    ('B4', ['C14'], 'claim_en',
     'Registration contacts now form through connector- and support-consuming docking;',
     'Contacts now form through connector- and support-consuming docking;'),
    ('B4', ['C14'], 'claim_zh',
     '配准连接现在由消耗连接件与支持的对接形成',
     '接触现在由消耗连接件与支持的对接形成'),
    ('B4', ['C14'], 'scope_en',
     'formed-copying-registration: 33 new theorems',
     'formed-contacts-change-copying-fidelity: 33 new theorems'),
    ('B4', ['C14'], 'scope_zh',
     'formed-copying-registration：33项新定理',
     'formed-contacts-change-copying-fidelity：33项新定理'),
    ('B4', ['C14'], 'scope_en',
     'Complete stable registration recovers prior copying;',
     'Complete stable contacts recover prior copying;'),
    ('B4', ['C14'], 'scope_zh',
     '完整稳定配准接回旧复制',
     '完整稳定的接触接回旧复制'),
    # B4 at the other renamed record: the lumping and the process
    ('B4', ['M24'], 'claim_en',
     'exactly when the registration admits it and the stock covers it',
     'exactly when the process admits it and the stock covers it'),
    ('B4', ['M24'], 'claim_zh',
     '恰当登记容许且存量覆盖',
     '恰当过程容许且存量覆盖'),
    ('B4', ['M24'], 'scope_en',
     'preserving all old selections under registration change',
     'preserving all old selections when the lumping changes'),
    ('B4', ['M24'], 'scope_zh',
     'P93 给出登记变化保留全部旧选择的精确条件',
     'P93 给出归并改变时保留全部旧选择的精确条件'),
    # A8: C20's scope notes the restatement
    ('A8', ['C20'], 'scope_en',
     'while preserving the completed conditional route.',
     'while preserving the completed conditional route. On 30 October 2026 the record universal-practical-warrant was '
     'restated as the question whether practical reasons have a warrant binding every possible mind; it stays open, '
     "and the ethics, life's stance, does not wait on it."),
    ('A8', ['C20'], 'scope_zh',
     '公理路线的历史完成范围保留。',
     '公理路线的历史完成范围保留。2026 年 10 月 30 日，记录 universal-practical-warrant 重述为问题：实践理由是否有对一切'
     '可能心智都有约束力的根据；它保持开放，伦理作为生命的立场不待其解决。'),
    # B1: formation, not generative mechanisms
    ('B1', ['C01'], 'claim_en',
     'Within generative mechanisms, activity forms and transforms conditions of further activity;',
     'Within formation, generative and degenerative alike, activity forms and transforms conditions of further '
     'activity;'),
    ('B1', ['C01'], 'claim_zh',
     '在生成机制中，活动形成并转化后续活动的条件；',
     '在形成之中，生成与退化皆然，活动形成并转化后续活动的条件；'),
]

# The chain's opening scope: the key of retired labels (the 19 October relabelling, option (b)) and B6's pointer.
SCOPE_EN = (' The entries keep the labels of their time; [08 §10](../chapters/08-METHOD.md#retired-labels) explains '
            'them once. G0 in them is the favourable significance of life and its further generation, once taken as a '
            'starting point. It is no premise of the current account: living significance follows under the '
            'continuation condition, further generation is 生生, compared by widening, and ranking rests on C, neither '
            'premise asserted ([07 §3](../chapters/07-SIGNIFICANCE.md#condition), '
            '[07 §4](../chapters/07-SIGNIFICANCE.md#scope-and-order)). J1–J4 are the practical commitments, and '
            'P-numbers name the board items of their time. None of the central results is new mathematics: each is '
            'near-definitional or a known result restated, by an AI review whose search was not exhaustive '
            '([08 §8](../chapters/08-METHOD.md#known-results)).')
SCOPE_ZH = ('各条目保留其时的标签，[08 §10](../chapters/08-METHOD.md#retired-labels) 一次说明。其中 G0 指生及其继续生成的'
            '正面意义，曾取作起点；它不是现论的前提：在延续条件之下得出生的意义，继续生成是生生，以拓宽相比较，排序依于 C，'
            '两条前提都不断言（[07 §3](../chapters/07-SIGNIFICANCE.md#condition)、'
            '[07 §4](../chapters/07-SIGNIFICANCE.md#scope-and-order)）。J1–J4 是实践承诺，P 编号是其时的工作板条目。'
            '核心成果都不是新数学：每项近于定义，或是已知成果的重述；这一判断出自一次 AI 审查，其检索并不穷尽'
            '（[08 §8](../chapters/08-METHOD.md#known-results)）。')

# B3: links to retired texts labelled "current" read "as reviewed".
LABELS = {
    ('Current statement and scope', '当前表述与范围'): ('Statement and scope as reviewed', '复核时的表述与范围'),
    ('Current responsive-transformation account', '因应转化的当前表述'):
        ('Responsive-transformation account as reviewed', '复核时的因应转化表述'),
    ('Current practical candidate status', '新实践候选的当前状态'):
        ('Practical candidate status as reviewed', '复核时新实践候选的状态'),
    ('Current account', '当前理论'): ('Account as reviewed', '复核时的理论'),
    ('The Theory of Becoming: current chapter and formal spine', '生成／变化之论：当前章节与形式脊柱'):
        ('The Theory of Becoming: chapter and formal spine as reviewed', '生成／变化之论：复核时的章节与形式脊柱'),
    ('Current self-grounding wall', '自我奠基路线的当前障碍'): ('Self-grounding wall as reviewed', '复核时自我奠基路线的障碍'),
    ('Current account', '当前论述'): ('Account as reviewed', '复核时的论述'),
    ('Current-provision proof and premises', '当前供给证明与前提'):
        ('Current-provision proof and premises as reviewed', '复核时的当前供给证明与前提'),
    ('Current bilingual account', '当前双语论述'): ('Bilingual account as reviewed', '复核时的双语论述'),
    ('Current theory', '当前理论'): ('Theory as reviewed', '复核时的理论'),
    ('Current task correction', '当前任务纠正'): ('Task correction as reviewed', '复核时的任务纠正'),
    ('Current theoretical continuation', '最新理论接续'): ('Theoretical continuation as reviewed', '复核时的理论接续'),
    ('Current integrated conclusion', '当前接续结论'): ('Integrated conclusion as reviewed', '复核时的接续结论'),
    ('Scope of the current axiom route', '当前公理路线的范围'): ('Scope of the axiom route as reviewed', '复核时公理路线的范围'),
    ('Current bilingual theory', '当前双语理论'): ('Bilingual theory as reviewed', '复核时的双语理论'),
    ('Current bilingual investigation', '当前双语研究'): ('Bilingual investigation as reviewed', '复核时的双语研究'),
    ('Current universal-ground candidate', '普遍根据的当前候选'):
        ('Universal-ground candidate as reviewed', '复核时普遍根据的候选'),
    ('Connection audit and current account', '连接核查与当前理论'):
        ('Connection audit and account as reviewed', '连接核查与复核时的理论'),
    ('Current bilingual direction argument', '当前双语方向论证'):
        ('Bilingual direction argument as reviewed', '复核时的双语方向论证'),
    ('Current priority and unresolved connection', '当前首要方向与未解连接'):
        ('Priority and unresolved connection as reviewed', '复核时的首要方向与未解连接'),
    ('Current argument for acquired basic conditions', '后天基本条件的当前论证'):
        ('Argument for acquired basic conditions as reviewed', '复核时后天基本条件的论证'),
    ('Developmental conditions and present wall', '关切形成的条件与当前墙'):
        ('Developmental conditions and wall as reviewed', '复核时关切形成的条件与墙'),
    ('Current account', '当前知识章'): ('Account as reviewed', '复核时的知识章'),
    ('Current alignment account', '当前对齐表述'): ('Alignment account as reviewed', '复核时的对齐表述'),
    ('Account and full objective', '当前理论与完整目标'): ('Account and full objective as reviewed', '复核时的理论与完整目标'),
    ('Generated-logic account', '生成逻辑当前说明'): ('Generated-logic account as reviewed', '复核时的生成逻辑说明'),
    ('Current substantive review', '本轮实质反审'): ('Substantive review as reviewed', '复核时的实质反审'),
}
# Kept: a frontier counterexample is not a claim of currency in the retired sense.
KEEP_LABELS = {('Executable repair and current-theorem counterexample', '可执行修复与前沿反例')}


def main():
    dry = '--dry-run' in sys.argv
    data = json.loads(DATA.read_text())
    entries = {e['id']: e for s in data['sections'] for e in s['entries']}
    count = {}
    for proposal, ids, field, old, new in EDITS:
        for i in ids:
            text = entries[i][field]
            assert text.count(old) == 1, (proposal, i, field, text.count(old), old[:80])
            assert new not in text, (proposal, i, field, 'already applied')
            entries[i][field] = text.replace(old, new)
            count[proposal] = count.get(proposal, 0) + 1
    for field, extra in (('scope_en', SCOPE_EN), ('scope_zh', SCOPE_ZH)):
        assert 'retired-labels' not in data[field]
        data[field] = data[field].rstrip() + extra
    relabelled = 0
    for e in entries.values():
        for link in e['links']:
            key = (link['label_en'], link['label_zh'])
            current = re.search(r'\bcurrent\b', key[0], re.I) or '当前' in key[1] or key in LABELS
            if '/history/' not in link['path'] or not current or key in KEEP_LABELS:
                continue
            assert key in LABELS, key
            link['label_en'], link['label_zh'] = LABELS[key]
            relabelled += 1
    left = [(e['id'], f) for e in entries.values() for f in ('claim_en', 'claim_zh', 'scope_en', 'scope_zh')
            if '6.15' in e[f]]
    assert not left, left
    print(json.dumps({'edits': count, 'labels_relabelled': relabelled}, indent=1))
    if not dry:
        DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')


if __name__ == '__main__':
    main()
