#!/usr/bin/env python3
"""GC3, third pass: the re-check's findings (reviews/recheck.json) taken, each read against its source first.

Finding ids are in the comments. Each edit replaces text that occurs exactly once in its field and asserts so. Run once,
from the checkout root, on the data apply_review.py left.
usage: python3 -B <kit>/apply_recheck.py"""
import json
import re
from pathlib import Path

DATA = Path('theories/becoming/results/data/generativity-chain.json')
RECORD = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md')
NONE_EN = 'on request, with no argument given'
NONE_ZH = '应请求，未给论证'

# R5: true of the page, and no more than the rule says.
OPEN = [
    ('scope_en', 'An argument an entry gives is the work\'s present reason, not the history of the step.',
     'An argument an entry gives is the work\'s reason at the scope the entry states; it need not be why the step was '
     'taken at the time.'),
    ('scope_zh', '条目给出的论证是工作现今的理由，不是这一步的历史。', '条目给出的论证是工作在条目所述范围内的理由，未必是这一步当时所以走的原因。'),
]

# R1: the lack of a guarantee is a reason for the question studied, not for a name.
RESPONSIVE_EN = ('Since no unconditional guarantee holds through changing understanding and circumstances, the primary '
                 'term is responsive transformation (an AI working name), studying conditions and direction through '
                 'that change;',
                 'A local mechanism may guarantee an effect within its range without that range persisting through '
                 'every later change, so the question studied is conditions and direction through changing '
                 'understanding and circumstances; the primary term is responsive transformation (an AI working name), '
                 'since it presupposes no separate corrector and corrected object;')
RESPONSIVE_ZH = ('认知与处境变化之中没有无条件的保证，所以主词是因应转化（AI 所取的工作名），研究其中的边界条件和方向；',
                 '局部机制可以在其范围内保证某一效果，而这一范围未必在此后每次变化中都持续，所以所研究的是认知与处境变化之中的边界条件和方向；'
                 '主词是因应转化（AI 所取的工作名），因为它不预设分开的纠正者与被纠正者；')

# (entry, field, old, new)
TEXT = [
    ('C33', 'claim_en', *RESPONSIVE_EN), ('C33', 'claim_zh', *RESPONSIVE_ZH),
    ('M23', 'claim_en', *RESPONSIVE_EN), ('M23', 'claim_zh', *RESPONSIVE_ZH),
    ('F29', 'claim_en', *RESPONSIVE_EN), ('F29', 'claim_zh', *RESPONSIVE_ZH),
    # R2: the source gives an argument for this step, so it is a reading with both premises unargued, not a mark.
    ('M15', 'claim_en',
     'it is read as a judgment of becoming (a reading, its premise not argued here). Its appraisal through this theory’s '
     f'universal generative principles was set {NONE_EN}; that those principles',
     'it is read as a judgment of becoming, and since the theory’s model can judge becoming, as appraised through its '
     'universal generative principles (a reading, both premises not argued here); that those principles'),
    ('M15', 'claim_zh',
     f'故读作对becoming的判断（这是读法，其前提在此未论证）。由本理论普遍生成原则评价它，系{NONE_ZH}；这些原则',
     '故读作对becoming的判断，又因本理论的模型可以判断becoming，故读作由其普遍生成原则评价（这是读法，两项前提在此都未论证）；这些原则'),
    # R3: a requirement of method, as 08 §1 holds it, not a fact about parts.
    ('C14', 'claim_en', 'since parts are not first given independently and joined afterward (08 §1);',
     'since the account\'s method does not begin from parts given independently and joined afterward (08 §1);'),
    ('C14', 'claim_zh', '因为各部分不是先各自给定、事后才连接（08 §1）；', '因为本理论的方法不从各自给定、事后才连接的部分开始（08 §1）；'),
    # R4: taking G0 stays unargued in this entry; the reasons in the source of 7 October are not argued here.
    ('C17', 'claim_en', 'explicitly as G0, the starting point of common comparative',
     f'explicitly as G0, {NONE_EN} here, the starting point of common comparative'),
    ('C17', 'claim_zh', '明确作为 G0 起点，推进共同的比较', f'明确作为 G0 起点，系应请求，此处未给论证，推进共同的比较'),
    # R10: both halves, as C20 has them.
    ('C17', 'scope_en', 'its starting point is not proved premise-free, so a premise-free ground',
     'its starting point is not proved premise-free, nor is such a proof shown impossible, so a premise-free ground'),
    ('C17', 'scope_zh', '不声称起点无前提得证，所以无前提的根据', '不声称起点无前提得证，也未证明其不可能，所以无前提的根据'),
    # R6: the words set the proof; the rest is the AI's working statement of it.
    ('M15', 'scope_en',
     'The objective then set for this session, to establish constitutive necessity and connect the formation of wisdom, '
     f'proving “the root of wisdom”, was set {NONE_EN}, and setting it makes nothing so.',
     f'The objective then set for this session, proving “the root of wisdom”, was set {NONE_EN}, and setting it makes '
     'nothing so; the AI\'s working statement of it is to establish constitutive necessity and connect the formation of '
     'wisdom.'),
    ('M15', 'scope_zh',
     f'随后设定的本会话目标，即建立构成必要性并接通智慧的生成说明，证明“the root of wisdom”，系{NONE_ZH}，设定它也不使之成立。',
     f'随后设定的本会话目标，即证明“the root of wisdom”，系{NONE_ZH}，设定它也不使之成立；其 AI 工作表述是建立构成必要性并接通智慧的生成说明。'),
    # R7: the answer states a direction; it does not say to investigate one.
    ('E01', 'claim_en',
     'The sources state the nondual method as a correction and direction, and the generative direction as an answer: '
     'explain differentiation within one unfolding, retain multiple ranges of life/formation and investigate Shengsheng '
     'as a favorable direction. Both',
     'The sources state the nondual method as a correction and direction, explaining differentiation within one '
     'unfolding, and the generative direction as an answer: Shengsheng is a good direction, with multiple ranges of '
     'life/formation retained. Both'),
    ('E01', 'claim_zh',
     '来源把非二元方法记为纠正与方向，把生生方向记为一次回答：从同一生成展开解释关系分化，保留多个“生”的研究范围，并正面研究生生的伦理方向。二者',
     '来源把非二元方法记为纠正与方向，即从同一生成展开解释关系分化；把生生方向记为一次回答：生生是好的方向，保留多个“生”的研究范围。二者'),
    # R11: the reopening's own date. 08 §1 states the method's limit.
    ('C20', 'scope_en', 'Zero-axiom Practical judgment was later reopened, on request',
     'Zero-axiom Practical judgment was reopened on 8 October 2026, on request'),
    ('C20', 'scope_zh', '后续重新开启零公理实践判断，系应请求', '2026-10-08 重新开启零公理实践判断，系应请求'),
    ('C20', 'scope_en', 'does not by itself complete a proof of normative necessity.',
     'does not by itself complete a proof of normative necessity (08 §1).'),
    ('C20', 'scope_zh', '一元方法不自动完成规范必要性证明。', '一元方法不自动完成规范必要性证明（08 §1）。'),
    # R12, R13: the pairs.
    ('C20', 'claim_en', 'the alignment task of that time proceeded from explicit G0.',
     'the alignment task of that time instead proceeded from explicit G0.'),
    ('C01', 'scope_zh', '实际角色与普遍过程法则仍须根据。', '实际角色与普遍过程法则按上述演绎标准仍须根据。'),
]

# The record's section, brought to what now stands. (old, new)
REC = [
    # The marked list: M15's appraisal out (R2), C17's taking of G0 in (R4). Eleven stands.
    ('C14 转向理论，C17 与 C20 重新开启零公理目标，', 'C14 转向理论，C17 取 G0 为起点（来源 2026-10-07 中的理由未在此条目论证，所以写“此处”），C17 与 C20 重新开启零公理目标，'),
    ('M15 的目标（证明“the root of wisdom”），M15 以普遍生成原则评价道德，M20 取作首要方向，', 'M15 的目标（证明“the root of wisdom”），M20 取作首要方向，'),
    ('C14\'s turn to theory, the reopening of the zero-axiom target in C17 and in C20,',
     'C14\'s turn to theory, C17\'s taking of G0 as its starting point (the reasons in the source of 7 October are not argued in this entry, hence "here"), the reopening of the zero-axiom target in C17 and in C20,'),
    ('M15\'s objective (proving "the root of wisdom"), M15\'s appraisal of morality through the generative principles, M20\'s taking',
     'M15\'s objective (proving "the root of wisdom"), M20\'s taking'),
    # R3.
    ('各部分不是先各自给定、事后才连接（2026-10-09 的 AI 说明，08 §1）。', '本理论的方法不从各自给定、事后才连接的部分开始（2026-10-09 的 AI 说明，08 §1）。'),
    ('parts are not first given independently and joined afterward (the AI note of 9 October, 08 §1).',
     'the account\'s method does not begin from parts given independently and joined afterward (the AI note of 9 October, 08 §1).'),
    # R9, R10.
    ('需要写明前提，不需要证明前提（2026-10-08 的 AI 说明）。C17、C20：起点未得证，普遍目标未证明也未证明不可能，所以目标保持开放（条目自身）；',
     '需要写明前提，不需要证明前提（由 2026-10-08 的 AI 说明重述，该说明给出各部分，未给此理由）。C17、C20：无前提的证明与普遍目标，都既未证明，也未证明不可能，所以目标保持开放（条目自身）；'),
    ('needs that premise stated, not proved (the AI note of 8 October). C17, C20: the starting point is unproved, and universal grounding neither proved nor shown impossible, so the target stays open (each entry itself);',
     'needs that premise stated, not proved (restated from the AI note of 8 October, which gives the parts and not the reason). C17, C20: a premise-free proof and universal grounding are each neither proved nor shown impossible, so the target stays open (each entry itself);'),
    # The method's limit, in 08 §1 itself.
    ('方法不证明任何根据：C20 的范围现已写明（2026-10-13 的 AI 说明）。', '方法不证明任何根据：C20 的范围现已写明（2026-10-13 的 AI 说明，08 §1）。'),
    ('The method proves no ground, which C20\'s scope now says (the AI note of 13 October).', 'The method proves no ground, which C20\'s scope now says (the AI note of 13 October, 08 §1).'),
    # R1.
    ('C33、M23、F29：认知与处境变化之中没有无条件的保证（2026-10-09 的 AI 说明），因应转化是 AI 所取的工作名。',
     'C33、M23、F29：局部保证未必在此后每次变化中都持续（PLURAL-SYSTEMS-AND-CORRECTION §15），这是所研究问题的理由；主词不预设分开的纠正者（VERSIONED-CORRECTION-INTEGRATION §8）；因应转化是 AI 所取的工作名。'),
    ('C33, M23, F29: no unconditional guarantee holds through changing understanding and circumstances (the AI note of 9 October), and responsive transformation is an AI working name.',
     'C33, M23, F29: a local guarantee need not persist through every later change (PLURAL-SYSTEMS-AND-CORRECTION §15), which is the reason for the question studied, and the term presupposes no separate corrector (VERSIONED-CORRECTION-INTEGRATION §8); responsive transformation is an AI working name.'),
    # R2.
    ('M15：道德考虑变化之后的结果，故读作对 becoming 的判断（来源本身的话重述，标为读法，前提未论证）；',
     'M15：道德考虑变化之后的结果，故读作对 becoming 的判断，又因模型可以判断 becoming，故读作由普遍生成原则评价（来源本身的话重述，标为读法，两项前提未论证）；'),
    ('M15: morality weighs what follows from a change, so it is read as a judgment of becoming (the source\'s own words restated, marked a reading, its premise not argued);',
     'M15: morality weighs what follows from a change, so it is read as a judgment of becoming, and since the model can judge becoming, as appraised through the generative principles (the source\'s own words restated, marked a reading, both premises not argued);'),
    # R8.
    ('M21：局部必要性证明及与核心的相容，不表明整个核心不可缺少（条目自身）；所以研究须容许完整核心成立、只有部分必要或需修正（来源的 AI 说明）。',
     'M21：局部必要性证明及与核心的相容，不表明整个核心不可缺少；所以研究须容许完整核心成立、只有部分必要或需修正（都是来源的 AI 说明）。'),
    ('M21: a local necessity proof and compatibility with the core do not show the whole core indispensable (the entry itself); so inquiry must allow that the whole core holds, that only part is necessary or that some commitment needs revising (the source\'s AI note).',
     'M21: a local necessity proof and compatibility with the core do not show the whole core indispensable; so inquiry must allow that the whole core holds, that only part is necessary or that some commitment needs revising (both the source\'s AI note).'),
    # R5, the key's bullet.
    ('条目给出的论证是现今的理由，不是这一步的历史；', '条目给出的论证是工作在条目所述范围内的理由，未必是这一步当时所以走的原因；'),
    ('an argument given is the present reason, not the history of the step;', 'an argument given is the work\'s reason at the scope the entry states, and need not be why the step was taken at the time;'),
    ('这里写出的论证，是工作现今给这一步的理由，不主张当时这一步就是因此而走的。', '这里写出的论证，是工作在条目所述范围内给这一步的理由，不主张当时这一步就是因此而走的。'),
    ('An argument written here is the work\'s present reason for the step. It does not claim', 'An argument written here is the work\'s reason for the step at the scope the entry states. It does not claim'),
    # The tools and the re-check.
    ('`apply_steps.py` 是第一遍，`apply_review.py` 接纳独立阅读的所见。', '`apply_steps.py` 是第一遍，`apply_review.py` 接纳独立阅读的所见，`apply_recheck.py` 接纳复查的所见。'),
    ('`apply_steps.py` is the first pass, `apply_review.py` takes the independent read\'s findings.', '`apply_steps.py` is the first pass, `apply_review.py` takes the independent read\'s findings, and `apply_recheck.py` takes the re-check\'s.'),
    ('阻断、修正与备注全部接纳，有的换了说法；每一项先对照其来源或归属章节。',
     '阻断、修正与备注全部接纳，有的换了说法；每一项先对照其来源或归属章节。一个 AI 读者复查第二遍改动的句子（约 26 万 token，`recheck.json`）：13 项所见，1 项阻断、7 项修正、5 项备注，同样先对照来源，全部接纳。所见里最要紧的：一个新的“因为”把来源中的意见硬化，又够不到它要支持的主词；M15 的一个标记对其来源不实；总说明的一句对整页仍不成立。'),
    ('Blockers, fixes and notes are all taken, some in other words, each first checked against its source or home section.',
     'Blockers, fixes and notes are all taken, some in other words, each first checked against its source or home section. One AI reader then re-checked the sentences the second pass changed (about 257,000 tokens, `recheck.json`): 13 findings, 1 blocker, 7 fixes and 5 notes, each checked against its source in the same way and all taken. Chiefly: a new "since" hardened an opinion in the source and did not reach the term it was meant to support; one of M15\'s marks was false of its source; and one sentence of the key was still not true of the whole page.'),
    # The Chinese of that clause read 所以, not 因为.
    ('一个新的“因为”把来源中的意见硬化，', '一个新的“所以”把来源中的意见硬化，'),
]

ASKED = re.compile(r'用户|你指定|按[^。；]{0,8}(?:指示|要求)|requested|08 §4')


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
    left = []
    for where, item in [('opening', data)] + list(entries.items()):
        for field in ('title_en', 'title_zh', 'claim_en', 'claim_zh', 'scope_en', 'scope_zh', 'connection_en', 'connection_zh'):
            for m in ASKED.finditer(item.get(field, '')):
                near = item[field][max(0, m.start() - 8):m.end() + 8]
                if not (where == 'F01' and 'every requested step' in near):
                    left.append((where, field, near))
    assert not left, left
    name = [m.start() for m in re.finditer(r'(?<![A-Za-z])Ren(?![A-Za-z])', json.dumps(data, ensure_ascii=False))]
    assert not name, name[:5]
    record = RECORD.read_text()
    for old, new in REC:
        record = once(record, old, new, 'record')
    DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    RECORD.write_text(record)
    print('applied', len(OPEN) + len(TEXT), 'text edits;', len(REC), 'record edits')


if __name__ == '__main__':
    main()
