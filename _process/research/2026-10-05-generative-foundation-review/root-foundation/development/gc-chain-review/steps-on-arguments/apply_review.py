#!/usr/bin/env python3
"""GC3, second pass: the independent read's findings (reviews/argument.json, reviews/exactness.json) taken.

Finding ids are in the comments. Each edit replaces text that occurs exactly once in its field and asserts so. Run once,
from the checkout root, on the data apply_steps.py left.
usage: python3 -B <kit>/apply_review.py"""
import json
import re
from pathlib import Path

DATA = Path('theories/becoming/results/data/generativity-chain.json')
CHOICES = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md')
SOURCES = 'sources/15-codex-theory-conversations/'
NONE_EN = 'on request, with no argument given'
NONE_ZH = '应请求，未给论证'

# The opening scope: A5, and the key, A10, A11, E10, E12.
OPEN = [
    ('scope_en', 'This table covers the requested connected chain:', 'This table covers one connected chain:'),
    ('scope_zh', '本表覆盖你指定的完整理论链：', '本表覆盖一条相连的理论链：'),
    ('scope_en',
     'The words that asked for a step stand in the linked sources, kept as provenance, and are no step\'s warrant: an '
     f'entry gives the step\'s argument, or says "{NONE_EN}" where it rests on none yet.',
     'Words that asked for a step are kept in the linked sources as provenance and warrant no step. An argument an '
     'entry gives is the work\'s present reason, not the history of the step. Where an entry marks a step as resting '
     f'on none yet, it says "with no argument given" or "{NONE_EN}"; a step it neither argues nor marks has not yet '
     'been read for this.'),
    ('scope_zh',
     f'请求某一步的原话保存在所链来源中，只作来源，不作任何一步的根据：条目或给出这一步的论证，或在尚无论证之处写“{NONE_ZH}”。',
     '请求某一步的原话保存在所链来源中，只作来源，不作任何一步的根据。条目给出的论证是工作现今的理由，不是这一步的历史。'
     f'条目标明尚无论证之处，写“未给论证”或“{NONE_ZH}”；既未论证也未标明的步骤，尚未为此读过。'),
]

RESPONSIVE_EN = ('The 9 October clarification uses responsive transformation as the primary term, studying conditions '
                 'and direction through changing understanding and circumstances;',
                 'Since no unconditional guarantee holds through changing understanding and circumstances, the primary '
                 'term is responsive transformation (an AI working name), studying conditions and direction through '
                 'that change;')
RESPONSIVE_ZH = ('9日澄清以因应转化为主词，研究认知与处境变化中的边界条件和方向；',
                 '认知与处境变化之中没有无条件的保证，所以主词是因应转化（AI 所取的工作名），研究其中的边界条件和方向；')

# (entry, field, old, new)
TEXT = [
    # C01. A6, E5: no request in the sentence. A21, A22, E11, E12: the source is an answer.
    ('C01', 'scope_en', f'was set {NONE_EN}: it says what this target asks,',
     'was set in an answer to a clarifying question, with no argument given: it says what the foundation\'s target asks,'),
    ('C01', 'scope_zh', f'系{NONE_ZH}：它说的是此目标所要求者，不是此目标何以应作此要求；',
     '出于对一次澄清提问的回答，未给论证：它说的是根基目标所要求者，不是这一目标何以应作此要求；'),
    ('C01', 'scope_en', 'continuation reaches the requested wall:', 'continuation stops at a wall:'),
    ('C01', 'scope_zh', '本次自我奠基接续按用户指示到墙：', '本次自我奠基接续到墙：'),
    ('C01', 'scope_en', 'remain ungrounded at the requested deductive scope.',
     'remain ungrounded at the deductive standard above.'),
    # C03. E2: not the first statement; earlier ones carry reasons.
    ('C03', 'scope_en', 'Stated first as a direction, with no argument given;',
     'Stated on 7 October 2026 as a direction, in an answer, with no argument given;'),
    ('C03', 'scope_zh', '最初作为方向提出，未给论证；', '2026-10-07 在一次回答中作为方向提出，未给论证；'),
    # C14. A3, E15: the reason shows the focus can proceed, not why it was taken. A17: the argument of the 9 October step.
    # A15, E5: the scope.
    ('C14', 'claim_en',
     'A theoretical focus follows, since comparing premises and added explanation needs no new measurement:',
     f'A theoretical focus follows, {NONE_EN}; comparing premises and added explanation needs no new measurement, so '
     'it can proceed without one:'),
    ('C14', 'claim_zh', '比较前提与额外解释不需要新的测量，所以转而聚焦理论：',
     f'转而聚焦理论，系{NONE_ZH}；比较前提与额外解释不需要新的测量，所以无新测量也可进行：'),
    ('C14', 'claim_en',
     'The 9 October systems/subsystems correction explains continuation through differentiation and reciprocal '
     'maintenance/transformation within common activity;',
     'Continuation is explained through differentiation and reciprocal maintenance/transformation within common '
     'activity, since parts are not first given independently and joined afterward (08 §1);'),
    ('C14', 'claim_zh', '10月9日的系统／子系统纠正：从共同活动中分化、相互维持和改变的反馈解释接续；',
     '接续由共同活动中分化、相互维持和改变的反馈解释，因为各部分不是先各自给定、事后才连接（08 §1）；'),
    ('C14', 'scope_en', 'The focused account is complete at the selected scope:',
     'The focused account is complete at the scope stated:'),
    ('C14', 'scope_zh', '聚焦说明现按用户选定范围完成：', '聚焦说明在所述范围内完成：'),
    # C17. A16: the argument for a route on a stated premise (the AI note of 8 October). A4, E6: status and step apart.
    ('C17', 'claim_en', 'a premise-free proof of either premise is not a completion gate for this route.',
     'a premise-free proof of either premise is not a completion gate for this route, since a route that reports its '
     'results only under a stated premise needs that premise stated, not proved.'),
    ('C17', 'claim_zh', '任一前提的无前提证明都不是这一路线的完成门槛。',
     '任一前提的无前提证明都不是这一路线的完成门槛，因为只在所述前提之下报告结果的路线，需要写明前提，不需要证明前提。'),
    ('C17', 'scope_en',
     'its starting point is not proved premise-free. With that starting point unproved, zero-axiom grounding was later '
     'reopened in the Practical judgment chat, preserving other routes.',
     'its starting point is not proved premise-free, so a premise-free ground stays an open target. Zero-axiom grounding '
     f'was later reopened in the Practical judgment chat, {NONE_EN}, preserving other routes.'),
    ('C17', 'scope_zh', '不声称起点无前提得证。起点既未得证，后续在实践判断聊天重新开启零公理目标，其他路线保留。',
     f'不声称起点无前提得证，所以无前提的根据仍是开放目标。后续在实践判断聊天重新开启零公理目标，系{NONE_ZH}，其他路线保留。'),
    # C20. A23: tense and the chat. A1, E1: 08 §1. E7: a tendency, not what the words say. A4, E6: status and step apart.
    # E3, A20: the method proves no ground (the AI note of 13 October), now said here.
    ('C20', 'claim_en', 'the current alignment task instead proceeds from explicit G0.',
     'the alignment task of that time proceeded from explicit G0.'),
    ('C20', 'claim_zh', '当前 alignment 任务改沿明示 G0 推导。', '当时的 alignment 任务改沿明示 G0 推导。'),
    ('C20', 'claim_en', f'On 13 October 2026 this chat focuses on universal normative grounding, {NONE_EN};',
     f'On 13 October 2026 the research chat of that day takes universal normative grounding as its focus, {NONE_EN};'),
    ('C20', 'claim_zh', f'2026-10-13，本会话重心放回普遍规范奠基，系{NONE_ZH}；',
     f'2026-10-13，当日研究会话以普遍规范奠基为重心，系{NONE_ZH}；'),
    ('C20', 'claim_en',
     'The question as then put separated neutral fact, value and independent positions of response and asked for an '
     'external link between them, a dualist regression against the account\'s method (08 §4); it is corrected: explain',
     'The question as then put tended to separate neutral fact, value and independent positions of response and then '
     'ask for an external link between them, which is not how the account\'s method begins: before two terms are treated '
     'as independently given, the relation said to join them is reconstructed (08 §1). So the question is restated: '
     'explain'),
    ('C20', 'claim_zh',
     '当时的问法先分开中性事实、价值及独立的回应位置，再求其外部连接，这是违背本理论方法（08 §4）的二元回退；予以纠正：',
     '当时的问法倾向于先分开中性事实、价值及独立的回应位置，再求其外部连接，而本理论的方法不从此开始：在把两项当作各自给定之前，'
     '先重构所说连接二者的关系（08 §1）。所以改问：'),
    ('C20', 'scope_en',
     'Universal grounding is neither proved nor shown impossible, so zero-axiom Practical judgment was later reopened, '
     'preserving the completed conditional route.',
     'Universal grounding is neither proved nor shown impossible, so the target stays open. Zero-axiom Practical judgment '
     f'was later reopened, {NONE_EN}, preserving the completed conditional route. The nondual method does not by itself '
     'complete a proof of normative necessity.'),
    ('C20', 'scope_zh', '普遍目标未证明也未证明不可能，所以后续重新开启零公理实践判断，公理路线的历史完成范围保留。',
     f'普遍目标未证明也未证明不可能，所以目标保持开放。后续重新开启零公理实践判断，系{NONE_ZH}，公理路线的历史完成范围保留。'
     '一元方法不自动完成规范必要性证明。'),
    # C26. A1, E1.
    ('C26', 'claim_en', '(08 §4)', '(08 §1)'),
    ('C26', 'claim_zh', '（08 §4）', '（08 §1）'),
    # C32. A21: the three named, and the English says what the Chinese says.
    ('C32', 'scope_en', 'The three requested kinds of integration are complete together here.',
     'The three kinds of integration (composing existing results, explaining a supplied premise, establishing real-world '
     'correspondence) are complete together here and independently accepted.'),
    ('C32', 'scope_zh', '三类整合在此范围完成并获独立验收；', '三类整合（组合既有成果、解释所给前提、建立现实对应）在此范围完成并获独立验收；'),
    # C33, M23, F29. A18: the argument (the AI note of 9 October) in place of the date.
    ('C33', 'claim_en', *RESPONSIVE_EN), ('C33', 'claim_zh', *RESPONSIVE_ZH),
    ('M23', 'claim_en', *RESPONSIVE_EN), ('M23', 'claim_zh', *RESPONSIVE_ZH),
    ('F29', 'claim_en', *RESPONSIVE_EN), ('F29', 'claim_zh', *RESPONSIVE_ZH),
    # E01. E9: the sources state, and the second is an answer.
    ('E01', 'title_en', 'The nondual method and the generative direction: their source directives',
     'The nondual method and the generative direction: their sources'),
    ('E01', 'title_zh', '非二元方法与生生方向：来源中的指令', '非二元方法与生生方向：其来源'),
    ('E01', 'claim_en',
     'The directives asked for explaining differentiation within one unfolding, retaining multiple ranges of '
     'life/formation and investigating Shengsheng as a favorable direction.',
     'The sources state the nondual method as a correction and direction, and the generative direction as an answer: '
     'explain differentiation within one unfolding, retain multiple ranges of life/formation and investigate Shengsheng '
     'as a favorable direction. Both are kept as provenance.'),
    ('E01', 'claim_zh', '原话请求从同一生成展开解释关系分化，保留多个“生”的研究范围，并正面研究生生的伦理方向。',
     '来源把非二元方法记为纠正与方向，把生生方向记为一次回答：从同一生成展开解释关系分化，保留多个“生”的研究范围，并正面研究生生的伦理方向。'
     '二者只作来源。'),
    ('E01', 'scope_en', 'Research directives and theoretical sources, kept as provenance: instructions are not proofs and warrant no step.',
     'Research instructions, answers and theoretical sources, kept as provenance: they are not proofs and warrant no step.'),
    ('E01', 'scope_zh', '研究指令与理论来源，只作来源：指令不计作证明，也不作任何一步的根据。',
     '研究指令、回答与理论来源，只作来源：它们不计作证明，也不作任何一步的根据。'),
    # E02. A19, E5.
    ('E02', 'claim_zh', '同时按当前要求继续更强的零公理理论；', '同时继续更强的零公理理论；'),
    ('E02', 'scope_en', 'Direct messages and execution scope; success of one route',
     'Direct messages and execution scope, kept as provenance: they warrant no step; success of one route'),
    ('E02', 'scope_zh', '原话与执行范围；不能把一条路线', '原话与执行范围，只作来源，不作任何一步的根据；不能把一条路线'),
    # M15. A12: the reading kept, the appraisal marked, both premises named. E16: §23's subject. E14, A24, E11, A2, E8.
    ('M15', 'claim_en',
     'it is read as a judgment of becoming, appraised through this theory’s universal generative principles (a reading; '
     'that those principles suffice for it is not shown here); varied responses',
     'it is read as a judgment of becoming (a reading, its premise not argued here). Its appraisal through this theory’s '
     f'universal generative principles was set {NONE_EN}; that those principles suffice for it is not shown here, and the '
     'ethics’ scope is the continuation condition’s and its order C’s, neither asserted (07 §4). Varied responses'),
    ('M15', 'claim_zh',
     '故读作对becoming的判断，由本理论普遍生成原则支撑（这是读法，这些原则足以支撑它在此未证）；不同回应',
     f'故读作对becoming的判断（这是读法，其前提在此未论证）。由本理论普遍生成原则评价它，系{NONE_ZH}；这些原则足以评价它在此未证，'
     '伦理的范围出于延续条件，次序出于 C，二者都不断言（07 §4）。不同回应'),
    ('M15', 'claim_zh',
     '第23节直接连接P91的接纳内容与P93的选择保留，因为一个理论之内已给出的连接不需要平行模型：四项纯核心适配给出',
     '第23节复用而不重建，因为一个理论之内已给出的连接不需要平行模型：四项纯核心适配直接连接P91的接纳内容与P93的选择保留，给出'),
    ('M15', 'scope_en', 'does not explain why the core\'s inferences', 'does not explain whether or why the core\'s inferences'),
    ('M15', 'scope_zh', '不能解释本核心的推论何以能找出它们', '不能解释本核心的推论是否以及何以能找出它们'),
    ('M15', 'scope_en',
     f'The objective then set for this session, proving “the root of wisdom”, was set {NONE_EN}, and setting it makes '
     'nothing so: establish constitutive necessity and connect the formation of wisdom.',
     'The objective then set for this session, to establish constitutive necessity and connect the formation of wisdom, '
     f'proving “the root of wisdom”, was set {NONE_EN}, and setting it makes nothing so.'),
    ('M15', 'scope_zh',
     f'随后设定的本会话目标（证明“the root of wisdom”）系{NONE_ZH}，设定它也不使之成立：须建立构成必要性并接通智慧的生成说明。',
     f'随后设定的本会话目标，即建立构成必要性并接通智慧的生成说明，证明“the root of wisdom”，系{NONE_ZH}，设定它也不使之成立。'),
    ('M15', 'scope_en',
     'whether that difference matters; This link adds no premise and changes no theorem; its place here rests on the laws '
     'stated (D43).',
     'whether that difference matters. This link adds no premise and changes no theorem (D43); it has its place here since '
     'a selection is as good as the model it goes through, and whether that model is right is its fit to what matters, '
     'which is wisdom, not memory (an AI reading).'),
    ('M15', 'scope_zh', '规律也不说这一差别是否要紧；这一环节不加前提，不改定理；其位置依于所述规律（D43）。',
     '规律也不说这一差别是否要紧。这一环节不加前提，不改定理（D43）；它在此处，因为选择的好坏取决于所经的模型，而模型是否正确在于它与要紧者的相合，'
     '这是智慧，不是记忆（AI 读法）。'),
    # M20. A8: the title and the mark. A9: new generative content is the study's supplied premise, not a consequence.
    # A14: the home's own reason. A7, E5: no request in the sentence.
    ('M20', 'title_en', 'Generative alignment: a current primary direction', 'Generative alignment'),
    ('M20', 'title_zh', '生成性对齐：当前首要方向之一', '生成性对齐'),
    ('M20', 'scope_en', 'A current primary direction. The direction argument',
     f'Taken as a primary direction on 8 October 2026, {NONE_EN}. The direction argument'),
    ('M20', 'scope_zh', '当前首要方向之一；方向论证', f'2026-10-08 取作首要方向之一，系{NONE_ZH}；方向论证'),
    ('M20', 'claim_en',
     'The positive target is then corrected: a positive ground need not wait on a complete ranking of the whole, so under '
     'G0 one response can secure some new generative good throughout supported visible continuations without fixing one '
     'common form.',
     'The positive target is then corrected, under the G0 route then taken: a positive ground need not wait on a complete '
     'ranking of the whole; where every supported visible continuation of one response forms some new generative content, '
     'that response has a positive ground without fixing one common form.'),
    ('M20', 'claim_zh',
     '正面目标随后得到纠正：正面根据不必等待对整体的完备排序，所以在 G0 之下，同一回应在当前有根据的每条接续中可以确定形成某种生成善，而无需预定同一种形态。',
     '正面目标随后在当时所取的 G0 路线之下得到纠正：正面根据不必等待对整体的完备排序；同一回应若在当前有根据的每条接续中都形成某种新的生成内容，'
     '它便有正面根据，而无需预定同一种形态。'),
    ('M20', 'claim_en',
     'before any presumption against power: contraction is not good merely for reducing a controller\'s reach. Expanded '
     'coordination and action can be positive achievements; expansion, maintenance and contraction have no preset ranking. '
     'The former foundational authority wall is withdrawn.',
     'before any presumption against power, since a threshold of first authorization would raise the authority premises '
     'of local mechanisms into a prior judge of the whole theory: institutions have no a priori duty to contract, and more '
     'power or less power cannot replace the comparison. Expanded coordination and action can be positive achievements; '
     'expansion, maintenance and contraction have no preset ranking. So the former foundational authority wall is '
     'withdrawn.'),
    ('M20', 'claim_zh',
     '不先设对权力的反对：收缩并不因缩小控制者的范围而成为善；协调和行动能力的扩大可以是正面成果，扩大、维持或收缩均无预设优先。旧授权之墙的基础地位已撤回。',
     '不先设对权力的反对，因为以首次授权为门槛，会把局部机制的权限前提抬成全理论的先决裁判：组织没有先验的收缩义务，权力多少不能代替这一比较；'
     '协调和行动能力的扩大可以是正面成果，扩大、维持或收缩均无预设优先。所以旧授权之墙的基础地位已撤回。'),
    ('M20', 'claim_zh', '按后续指示完成路线比较：以已有局部关切取得新关系内容并重组目的为理论主线，',
     '后续路线评估以已有局部关切取得新关系内容并重组目的为理论主线，'),
    ('M20', 'connection_en', 'This requested continuation stops at', 'This continuation stops at'),
    ('M20', 'connection_zh', '本次应请求的接续在可靠形成连接处停止', '本次接续在可靠形成连接处停止'),
    ('M20', 'connection_en', 'The previously requested concrete candidate and contrasts',
     'The concrete candidate and contrasts named in the previous round'),
    # M21. A13: the reason for the hypothesis, then what follows from it.
    ('M21', 'scope_en', 'remains a revisable hypothesis, since inquiry must allow',
     'remains a revisable hypothesis, since a local necessity proof and compatibility with the core do not show the whole '
     'core indispensable; so inquiry must allow'),
    ('M21', 'scope_zh', '完整科学基础保留为可修正假说，因为研究须容许',
     '完整科学基础保留为可修正假说，因为局部必要性证明及与核心的相容，不表明整个核心不可缺少；所以研究须容许'),
    # M26. A24, E11. A2, E8: D43 gives no argument for the place; its proposal was the AI's (the brief's item 19).
    ('M26', 'scope_en', 'since that observation is no second relation', 'since the claim that observation is no second relation'),
    ('M26', 'scope_en', 'Both links add no premise and change no theorem; their place here rests on the laws stated (D43).',
     'Both links add no premise and change no theorem (D43); their place in this entry is an AI proposal, with no argument '
     'given.'),
    ('M26', 'scope_zh', '两个环节不加前提，不改定理；其位置依于所述规律（D43）。',
     '两个环节不加前提，不改定理（D43）；它们在本条目中的位置是 AI 的提议，未给论证。'),
]

# (entry, label_en, new_label_en, old_label_zh, new_label_zh). E16: the Chinese aligned with the English. E8: M15's label.
LABELS = [
    ('C17', 'Source: the directive and its scope', 'Source: the directive and its scope', '来源：原话与执行范围', '来源：指示与执行范围'),
    ('C26', 'Source: the later directive', 'Source: the later directive', '来源：后续原话', '来源：后续指示'),
    ('C33', 'Source: the direction', 'Source: the direction', '来源：原话', '来源：方向'),
    ('M15', "This link's place (D43)", 'The decision on this link (D43)', '这一环节的位置（D43）', '这一环节的决定（D43）'),
]

# (entry, label_en, label_zh, file). E13, A22: the words a mark refers to are linked. Each file is already reviewed.
LINKS = [
    ('C03', 'Source: the answer', '来源：回答', '2026-10-07-shengsheng-ethical-direction.md'),
    ('C17', 'Source: the reopening', '来源：重新开启', '2026-10-08-zero-axiom-practical-judgment.md'),
    ('C20', 'Source: the focus', '来源：重心', '2026-10-13-universal-normative-grounding-focus.md'),
    ('C20', 'Source: the reopening', '来源：重新开启', '2026-10-08-zero-axiom-practical-judgment.md'),
]

# E18: D43's reason for the chain's item is outgrown, as D45's was (GC2).
D43_AFTER = 'D45 records the answer: the register is decided as one account, and Part D within it.\n'
D43_LINE = ('\n**Outgrown in part** (2 November 2026, board item GC3). The last sentence of the item on the generativity chain '
            'is history. Since 31 October the chain changes through its maintenance record on argument, not as a curated '
            'argument of one person (AGENTS.md); GC3 gave each step that stood on a name its argument, or marked it as '
            'resting on none yet ([the record](GENERATIVITY-CHAIN-INDEX-RECORD.md#gc3-steps-on-their-arguments-2-november-2026)). '
            'The rest of the decision is kept.\n')

# What may no longer occur in the words of an entry. F01's "every requested step" and "每个请求步骤" are the model's.
ASKED = re.compile(r'用户|你指定|按[^。；]{0,8}(?:指示|要求)|requested|08 §4')
ALLOWED = {('F01', 'every requested step')}


def once(text, old, new, where):
    assert text.count(old) == 1, (where, text.count(old), old[:80])
    return text.replace(old, new)


def main():
    data = json.loads(DATA.read_text())
    entries = {e['id']: e for s in data['sections'] for e in s['entries']}
    for field, old, new in OPEN:
        data[field] = once(data[field], old, new, ('opening', field))
    for entry, field, old, new in TEXT:
        entries[entry][field] = once(entries[entry][field], old, new, (entry, field))
    for entry, old_en, new_en, old_zh, new_zh in LABELS:
        links = [l for l in entries[entry]['links'] if l['label_en'] == old_en]
        assert len(links) == 1 and links[0]['label_zh'] == old_zh, (entry, old_en, [l['label_zh'] for l in links])
        links[0]['label_en'], links[0]['label_zh'] = new_en, new_zh
    for entry, label_en, label_zh, name in LINKS:
        assert SOURCES + name in data['reviewed_sources'], name
        assert all(l['path'] != SOURCES + name for l in entries[entry]['links']), (entry, name)
        entries[entry]['links'].append({'label_en': label_en, 'label_zh': label_zh, 'path': SOURCES + name})
    left = []
    for fields, where in [((data,), 'opening')] + [((e,), e['id']) for e in entries.values()]:
        for field in ('title_en', 'title_zh', 'claim_en', 'claim_zh', 'scope_en', 'scope_zh', 'connection_en', 'connection_zh'):
            text = fields[0].get(field, '')
            for m in ASKED.finditer(text):
                near = text[max(0, m.start() - 6):m.end() + 6]
                if not any(where == e and a in text[max(0, m.start() - 8):m.end() + 8] for e, a in ALLOWED):
                    left.append((where, field, near))
    assert not left, left
    # Latin letters only as neighbours: `\b` finds no boundary between a name and a Chinese character.
    name = [m.start() for m in re.finditer(r'(?<![A-Za-z])Ren(?![A-Za-z])', json.dumps(data, ensure_ascii=False))]
    assert not name, name[:5]
    choices = CHOICES.read_text()
    assert choices.count(D43_AFTER) == 1
    updated = choices.replace(D43_AFTER, D43_AFTER + D43_LINE)
    assert len(updated) == len(choices) + len(D43_LINE)
    DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    CHOICES.write_text(updated)
    print('applied', len(OPEN) + len(TEXT), 'text edits,', len(LABELS), 'labels,', len(LINKS), 'links; D43 dated')


if __name__ == '__main__':
    main()
