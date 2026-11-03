#!/usr/bin/env python3
"""GC3: each step that stood on a name given its argument, or marked as resting on none yet.

Each edit replaces text that occurs exactly once in its field and asserts so. Source files are not touched: the words
stay verbatim there, and each link still reaches them. Run once from the checkout root.
usage: python3 -B <kit>/apply_steps.py"""
import json
import re
from pathlib import Path

DATA = Path('theories/becoming/results/data/generativity-chain.json')
NONE_EN = 'on request, with no argument given'
NONE_ZH = '应请求，未给论证'

KEY_AFTER_EN = '([08 §8](../chapters/08-METHOD.md#known-results)).'
KEY_EN = (' The words that asked for a step stand in the linked sources, kept as provenance, and are no step\'s warrant: '
          f'an entry gives the step\'s argument, or says "{NONE_EN}" where it rests on none yet.')
KEY_AFTER_ZH = '（[08 §8](../chapters/08-METHOD.md#known-results)）。'
KEY_ZH = f'请求某一步的原话保存在所链来源中，只作来源，不作任何一步的根据：条目或给出这一步的论证，或在尚无论证之处写“{NONE_ZH}”。'

# (entry, field, old, new)
TEXT = [
    # A step set on request, with nothing argued for it: say so.
    ('C01', 'scope_en', 'Ren subsequently requires every foundational claim to be deductively necessary.',
     f'The standard then set, that every foundational claim be deductively necessary, was set {NONE_EN}: it says what '
     'this target asks, not why it should ask it.'),
    ('C01', 'scope_zh', 'Ren随后明确每项根基主张须演绎必然；',
     f'随后设定的标准（每项根基主张须演绎必然）系{NONE_ZH}：它说的是此目标所要求者，不是此目标何以应作此要求；'),
    ('C03', 'scope_en', 'Direction stated by Ren;',
     'Stated first as a direction, with no argument given; thesis T8 now argues it under both premises, with its '
     'warrant open (07 §8);'),
    ('C03', 'scope_zh', 'Ren 明确正面方向；', '最初作为方向提出，未给论证；论题 T8 现今在两条前提之下论证它，其根据仍开放（07 §8）；'),
    ('C20', 'claim_en', 'On 13 October 2026 Ren explicitly focuses this chat on universal normative grounding;',
     f'On 13 October 2026 this chat focuses on universal normative grounding, {NONE_EN};'),
    ('C20', 'claim_zh', '2026-10-13，Ren明确将本会话重心放回普遍规范奠基；', f'2026-10-13，本会话重心放回普遍规范奠基，系{NONE_ZH}；'),
    ('M15', 'scope_en', 'Ren subsequently fixes proving “the root of wisdom” as this session’s objective:',
     f'The objective then set for this session, proving “the root of wisdom”, was set {NONE_EN}, and setting it makes '
     'nothing so:'),
    ('M15', 'scope_zh', 'Ren 随后明确以证明“the root of wisdom”为本会话目标：',
     f'随后设定的本会话目标（证明“the root of wisdom”）系{NONE_ZH}，设定它也不使之成立：'),
    ('M20', 'connection_en', 'Ren subsequently requested investigation of next routes; the inquiry resumed and route selection is complete.',
     f'The inquiry resumed with next routes, {NONE_EN}; route selection is complete.'),
    ('M20', 'connection_zh', 'Ren随后要求研究后续路线，本会话已继续并完成排序；', f'本会话继续研究后续路线，系{NONE_ZH}，并已完成排序；'),

    # A step with an argument: the argument in place of the name.
    ('C01', 'scope_en', 'Ren’s whole/manifold correction withdraws universal generativity as a completion gate for Becoming.',
     'Degeneration, dissolution and persistence lie within the same unfolding, so generativity is not a condition every '
     'becoming must satisfy; universal generativity is withdrawn as a completion gate for Becoming.'),
    ('C01', 'scope_zh', 'Ren的整体／manifold修正撤回将普遍生成性作为Becoming完成门槛的做法；',
     '退化、消散与持存都在同一展开之内，所以生成性不是每个生成／变化都须满足的条件；撤回将普遍生成性作为Becoming完成门槛的做法；'),
    ('C14', 'claim_en', 'Ren now directs a theoretical focus: reuse formation, reconstruction, updater and goal-revision results, compare their independent premises and added explanation, and selected recovery of a specific connectionist learning result.',
     'A theoretical focus follows, since comparing premises and added explanation needs no new measurement: reuse '
     'formation, reconstruction, updater and goal-revision results, compare their independent premises and added '
     'explanation, and recover a specific connectionist learning result selected at the time.'),
    ('C14', 'claim_zh', 'Ren现明确要求聚焦理论：', '比较前提与额外解释不需要新的测量，所以转而聚焦理论：'),
    ('C14', 'claim_zh', '10月9日按Ren的系统／子系统纠正：', '10月9日的系统／子系统纠正：'),
    ('C17', 'scope_en', 'Ren later reopened zero-axiom grounding in the Practical judgment chat, preserving other routes.',
     'With that starting point unproved, zero-axiom grounding was later reopened in the Practical judgment chat, '
     'preserving other routes.'),
    ('C17', 'scope_zh', 'Ren 后续在实践判断聊天重新开启零公理目标，其他路线保留。', '起点既未得证，后续在实践判断聊天重新开启零公理目标，其他路线保留。'),
    ('C20', 'claim_en', 'Ren subsequently corrects the dualist regression: explain',
     'The question as then put separated neutral fact, value and independent positions of response and asked for an '
     'external link between them, a dualist regression against the account\'s method (08 §4); it is corrected: explain'),
    ('C20', 'claim_zh', 'Ren随后要求纠正二元回退：在同一活动中',
     '当时的问法先分开中性事实、价值及独立的回应位置，再求其外部连接，这是违背本理论方法（08 §4）的二元回退；予以纠正：在同一活动中'),
    ('C20', 'scope_en', 'Universal grounding is neither proved nor shown impossible; Ren later explicitly reopened zero-axiom Practical judgment while preserving the completed conditional route.',
     'Universal grounding is neither proved nor shown impossible, so zero-axiom Practical judgment was later reopened, '
     'preserving the completed conditional route.'),
    ('C20', 'scope_zh', '普遍目标未证明也未证明不可能；Ren 后续明确重新开启零公理实践判断，', '普遍目标未证明也未证明不可能，所以后续重新开启零公理实践判断，'),
    ('C26', 'claim_en', 'Following Ren’s nondual correction, unfold living, understanding, purposes, evaluation and response within one activity, withdrawing a mandatory external bridge between pre-separated fact and value.',
     'A mandatory external bridge presupposes fact and value already apart, which the account\'s method does not begin '
     'from (08 §4); so unfold living, understanding, purposes, evaluation and response within one activity, the bridge '
     'withdrawn.'),
    ('C26', 'claim_zh', '按Ren的一元关系纠正，从同一活动展开生活、理解、目的、评价与回应，',
     '强制的外部桥梁预设事实与价值已先分立，而本理论的方法不从此开始（08 §4）；所以从同一活动展开生活、理解、目的、评价与回应，'),
    ('C30', 'claim_en', 'Following Ren’s nondual objection, the counterexample', 'Corrected: the counterexample'),
    ('C30', 'claim_zh', 'Ren 非二元批评后的纠正：原反例', '纠正：原反例'),
    ('F22', 'claim_en', 'Following Ren’s nondual objection, the counterexample', 'Corrected: the counterexample'),
    ('F22', 'claim_zh', 'Ren 非二元批评后的纠正：原反例', '纠正：原反例'),
    ('M15', 'claim_en', 'Ren subsequently directs morality as appraisal of becoming through this theory’s universal generative principles;',
     'Since morality weighs what follows from a change, it is read as a judgment of becoming, appraised through this '
     'theory’s universal generative principles (a reading; that those principles suffice for it is not shown here);'),
    ('M15', 'claim_zh', 'Ren随后明确道德判断becoming，应由本理论普遍生成原则支撑；',
     '道德所考虑的是变化之后的结果，故读作对becoming的判断，由本理论普遍生成原则支撑（这是读法，这些原则足以支撑它在此未证）；'),
    ('M15', 'claim_en', 'Section 23 implements Ren’s one-theory correction: four pure adapters',
     'Section 23 reuses rather than rebuilds, since a connection already given within the one theory needs no parallel '
     'model: four pure adapters'),
    ('M15', 'claim_zh', '第23节按Ren的统一理论纠正，直接连接P91的接纳内容与P93的选择保留：',
     '第23节直接连接P91的接纳内容与P93的选择保留，因为一个理论之内已给出的连接不需要平行模型：'),
    ('M15', 'claim_en', 'not the record (Ren, 16 October 2026: “it is about the cognitive model, not just record”): with', 'not the record: with'),
    ('M15', 'claim_zh', '不经记录（Ren 2026-10-16：“it is about the cognitive model, not just record”）：模型', '不经记录：模型'),
    ('M15', 'scope_en', 'Following Ren’s correction, the next central test fixes',
     'Agreement with maxims found afterwards does not explain why the core\'s inferences would find them, so the next '
     'central test fixes'),
    ('M15', 'scope_zh', '按 Ren 纠正，下一中心检验是', '与事后找到的格言相合，不能解释本核心的推论何以能找出它们，所以下一中心检验是'),
    ('M15', 'scope_en', 'is the AI\'s reading of Ren\'s correction, stated in the reframing Ren approved on 16 October 2026 (“go ahead with the reframing”);',
     'is an AI reading: perfect memory cannot separate alternatives whose histories are alike, and where it does separate '
     'them the law says nothing of whether that difference matters;'),
    ('M15', 'scope_zh', '是 AI 对 Ren 这一更正的读法，写在 Ren 2026-10-16 认可的重构中（“go ahead with the reframing”）；',
     '是 AI 读法：完美记忆不能分开历史相同的备择，记忆分开之处，规律也不说这一差别是否要紧；'),
    ('M15', 'scope_en', 'Ren took this link on 18 October 2026 (D43).',
     'This link adds no premise and changes no theorem; its place here rests on the laws stated (D43).'),
    ('M15', 'scope_zh', '这一环节由 Ren 2026-10-18 取（D43）。', '这一环节不加前提，不改定理；其位置依于所述规律（D43）。'),
    ('M20', 'claim_en', 'Ren’s correction clarifies that unavailable history need not prevent',
     'Recovering an earlier history and acquiring fresh grounds are different things, so unavailable history need not prevent'),
    ('M20', 'claim_zh', 'Ren 后续指出，历史区别无法恢复，不阻止', '恢复过去的历史与取得新根据是两件事，所以历史区别无法恢复，不阻止'),
    ('M20', 'claim_en', 'Under Ren’s correction, §§75–77 appraise organization through whole generative goodness.',
     '§§75–77 appraise organization through whole generative goodness, under the G0 route then taken, before any '
     'presumption against power: contraction is not good merely for reducing a controller\'s reach.'),
    ('M20', 'claim_zh', '依 Ren 最新纠正，§§75–77先以整体生成之善评价组织；',
     '§§75–77在当时所取的 G0 路线之下先以整体生成之善评价组织，不先设对权力的反对：收缩并不因缩小控制者的范围而成为善；'),
    ('M20', 'claim_en', 'Ren’s subsequent correction establishes the positive target: one response',
     'The positive target is then corrected: a positive ground need not wait on a complete ranking of the whole, so under '
     'G0 one response'),
    ('M20', 'claim_zh', 'Ren随后纠正正面目标：同一回应', '正面目标随后得到纠正：正面根据不必等待对整体的完备排序，所以在 G0 之下，同一回应'),
    ('M20', 'connection_en', 'its broader use as a stopping reason is withdrawn following Ren’s correction.',
     'its broader use as a stopping reason is withdrawn, since a limit on recovering the past does not bound what future '
     'events can ground.'),
    ('M20', 'connection_zh', '此前用作较广停止理由的推断已依 Ren 纠正撤回。', '此前用作较广停止理由的推断已撤回，因为追溯过去的界限不限定未来事件能提供的根据。'),
    ('M20', 'connection_zh', '本次依Ren指示在可靠形成连接处停止；', '本次应请求的接续在可靠形成连接处停止；'),
    ('M21', 'scope_en', 'Under Ren’s revised direction, the full scientific foundation remains a revisable hypothesis.',
     'The full scientific foundation remains a revisable hypothesis, since inquiry must allow that the whole core holds, '
     'that only part of it is necessary, or that some commitment needs revising, and may not presuppose the strongest '
     'conclusion.'),
    ('M21', 'scope_zh', '按Ren的新方向，完整科学基础保留为可修正假说。',
     '完整科学基础保留为可修正假说，因为研究须容许完整核心成立、只有部分核心具有必要性或某项承诺需修正，不能预设最强结论。'),
    ('M26', 'scope_en', 'shows, as Ren took it on 18 October 2026 (D43);',
     'shows, since that observation is no second relation beside dependence goes beyond the theorem (D43);'),
    ('M26', 'scope_zh', '所表明的，由 Ren 2026-10-18 取（D43）；', '所表明的，因为观察不是依赖之外的第二种关系这一说法超出该定理（D43）；'),
    ('M26', 'scope_en', 'Ren took both links on 18 October 2026 (D43).',
     'Both links add no premise and change no theorem; their place here rests on the laws stated (D43).'),
    ('M26', 'scope_zh', '两个环节由 Ren 2026-10-18 取（D43）。', '两个环节不加前提，不改定理；其位置依于所述规律（D43）。'),

    ('C01', 'scope_en', 'reaches the user\'s requested wall:', 'reaches the requested wall:'),

    # Provenance entry: it stays provenance, and says it warrants nothing.
    ('E01', 'title_en', 'Ren’s nondual method and generative direction',
     'The nondual method and the generative direction: their source directives'),
    ('E01', 'title_zh', 'Ren 的非二元方法与生生方向', '非二元方法与生生方向：来源中的指令'),
    ('E01', 'claim_en', 'The directives require explaining', 'The directives asked for explaining'),
    ('E01', 'claim_zh', '原话规定从', '原话请求从'),
    ('E01', 'scope_en', 'User research directives and theoretical sources; instructions are not proofs.',
     'Research directives and theoretical sources, kept as provenance: instructions are not proofs and warrant no step.'),
    ('E01', 'scope_zh', '用户研究指令与理论来源；指令本身不计作证明。', '研究指令与理论来源，只作来源：指令不计作证明，也不作任何一步的根据。'),
]

# (entry, old_en, new_en, old_zh, new_zh): a label says what the link holds. The file reached is unchanged.
LABELS = [
    ('C01', 'Ren: whole and generative manifold', 'Source: whole and generative manifold', 'Ren：整体与生成形态', '来源：整体与生成形态'),
    ('C14', 'Ren’s theoretical-focus instruction', 'Source: the request for a theoretical focus', 'Ren的理论重点指令', '来源：聚焦理论的请求'),
    ('C17', 'Ren’s directive and scope', 'Source: the directive and its scope', 'Ren 原话与执行范围', '来源：原话与执行范围'),
    ('C26', 'Ren’s later directive', 'Source: the later directive', 'Ren 后续原话', '来源：后续原话'),
    ('C26', 'Ren’s nondual correction', 'Source: the nondual objection', 'Ren的一元关系纠正', '来源：一元关系的异议'),
    ('C26', 'Ren: one theory', 'Source: one theory', 'Ren：就是一个理论', '来源：就是一个理论'),
    ('C30', 'Ren’s direction', 'Source: the direction and the objection', 'Ren 原话', '来源：方向与异议'),
    ('C33', 'Ren’s direction', 'Source: the direction', 'Ren原话', '来源：原话'),
    ('M15', 'Ren’s paper direction and correction', 'Source: the paper direction and its correction', 'Ren 的论文方向与纠正', '来源：论文方向与纠正'),
    ('M15', 'Ren: these form one theory', 'Source: these form one theory', 'Ren：这些就是一个理论', '来源：这些就是一个理论'),
    ('M15', 'Ren: the cognitive model, not just record', 'Source: the cognitive model, not just record', 'Ren：认知模型，不只是记录', '来源：认知模型，不只是记录'),
    ('M15', 'The link Ren took (D43)', 'This link\'s place (D43)', 'Ren 所取的这一环节（D43）', '这一环节的位置（D43）'),
    ('M20', 'Ren’s priority and completion rule', 'Source: the priority and completion rule', 'Ren的优先级及完成规则', '来源：优先级及完成规则'),
    ('M20', 'Ren’s correction to the stopping inference', 'Source: the objection to the stopping inference', 'Ren对停止推断的纠正', '来源：对停止推断的异议'),
    ('M20', 'Ren’s next-route request', 'Source: the request for next routes', 'Ren要求研究后续路线', '来源：研究后续路线的请求'),
    ('M20', 'Ren’s continuation along the selected route', 'Source: continuing along the selected route', 'Ren要求沿选定路线继续', '来源：沿选定路线继续'),
    ('M20', 'Ren requests Lean continuation', 'Source: the request to continue in Lean', 'Ren要求Lean接续', '来源：Lean接续的请求'),
    ('M21', 'Ren’s words and goal', 'Source: the words and the goal', 'Ren的原话与目标', '来源：原话与目标'),
    ('M23', 'Ren’s clarification', 'Source: the clarification', 'Ren的澄清', '来源：澄清'),
    ('M26', "Ren's objective", 'Source: the objective', 'Ren 的目标', '来源：目标'),
    ('M26', 'Ren’s completion instruction', 'Source: the completion instruction', 'Ren的完成指令', '来源：完成指令'),
    ('M26', 'The readings and links Ren took (D43)', 'These readings and links (D43)', 'Ren 所取的读法与环节（D43）', '这些读法与环节（D43）'),
]


def once(text, old, new, where):
    assert text.count(old) == 1, (where, text.count(old), old[:80])
    return text.replace(old, new)


def main():
    data = json.loads(DATA.read_text())
    entries = {e['id']: e for s in data['sections'] for e in s['entries']}
    data['scope_en'] = once(data['scope_en'], KEY_AFTER_EN, KEY_AFTER_EN + KEY_EN, 'key en')
    data['scope_zh'] = once(data['scope_zh'], KEY_AFTER_ZH, KEY_AFTER_ZH + KEY_ZH, 'key zh')
    for entry, field, old, new in TEXT:
        entries[entry][field] = once(entries[entry][field], old, new, (entry, field))
    for entry, old_en, new_en, old_zh, new_zh in LABELS:
        links = [l for l in entries[entry]['links'] if l['label_en'] == old_en]
        assert len(links) == 1 and links[0]['label_zh'] == old_zh, (entry, old_en, [l['label_zh'] for l in links])
        links[0]['label_en'], links[0]['label_zh'] = new_en, new_zh
    text = json.dumps(data, ensure_ascii=False)
    # Latin letters only as neighbours: `\b` finds no boundary between a name and a Chinese character.
    left = [text[max(0, m.start() - 30):m.end() + 30] for m in re.finditer(r'(?<![A-Za-z])Ren(?![A-Za-z])', text)]
    assert not left, left[:5]
    DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    print('applied', len(TEXT), 'text edits and', len(LABELS), 'label pairs; the name occurs nowhere in the data')


if __name__ == '__main__':
    main()
