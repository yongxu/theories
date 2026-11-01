#!/usr/bin/env python3
"""GC2's second pass: the independent read's findings taken (reviews/exactness.json E*, reviews/argument.json G*).

Each edit replaces text that occurs exactly once in its field (or, for the standard clause, once in each of the five
entries that carry it) and asserts so; nothing else in the data changes. Run once from the checkout root, after
apply_text.py and renames.py.
usage: python3 -B <kit>/apply_review.py"""
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from apply_text import S_EN, S_ZH, SCOPE_EN, SCOPE_ZH  # noqa: E402  (the first pass's texts, replaced here)

DATA = Path('theories/becoming/results/data/generativity-chain.json')

# E1/G1, E2/G2, E3, E4/G17, E5: the clause names both senses of G0 and states 07 §3.1 without equating further
# generation with 生生; the zh takes the live zh editions' terms (存活之意义, 活的主张, 扩大, 生发).
S_EN2 = ('living significance (every living claim has significance from every standpoint), the Lean `G0` under its '
         'present name (08 §10), follows under the continuation condition, which the theory does not assert (07 §3); '
         'the favorable significance of whole life and further generation that G0 stated says more: no reading of '
         'living includes further generation, 生生, the object of the direction, is compared by widening, and ranking '
         'rests on C, widening what can form is better, also not asserted (07 §4)')
S_ZH2 = ('存活之意义（每一个活的主张从每一个立场看都有意义），即今名之下的 Lean `G0`（08 §10），在延续条件之下得出（理论不断言，'
         '07 §3）；G0 所述整体中的生及继续生成的正面意义所说更多：活的任一读法都不含继续生发，生生作为方向之所向，以扩大相'
         '比较，排序依于 C，即扩大可形成者更好，亦不断言（07 §4）')
SCOPE_EN2 = (' The entries keep the labels of their time; [08 §10](../chapters/08-METHOD.md#retired-labels) explains '
             'them once. There G0 maps to living significance (`LivingSignificance`), the present name of the Lean '
             '`G0`; in the entries\' prose G0 also names what it stated, the favorable significance of whole life and '
             'further generation, once taken as a starting point, which says more. Living significance follows under '
             'the continuation condition; what G0 stated beyond it is no premise of the current account: no reading '
             'of living includes further generation, 生生, the object of the direction, is compared by widening, and '
             'ranking rests on C, neither premise asserted ([07 §3](../chapters/07-SIGNIFICANCE.md#condition), '
             '[07 §4](../chapters/07-SIGNIFICANCE.md#scope-and-order)). J1–J4 are the practical commitments, and '
             'P-numbers name the board items of their time. None of the theory\'s central results, as 08 §8 ranks '
             'them, is new mathematics: each is near-definitional or a known result restated, by an AI review whose '
             'search was not exhaustive ([08 §8](../chapters/08-METHOD.md#known-results)).')
SCOPE_ZH2 = ('各条目保留其时的标签，[08 §10](../chapters/08-METHOD.md#retired-labels) 一次说明。该处 G0 对应存活之意义'
             '（`LivingSignificance`），即 Lean `G0` 的今名；条目文字中的 G0 也指它所述者，即整体中的生及继续生成的正面意义，'
             '曾取作起点，所说更多。存活之意义在延续条件之下得出；G0 所述多于它者不是现论的前提：活的任一读法都不含继续生发，'
             '生生作为方向之所向，以扩大相比较，排序依于 C，两条前提都不断言（[07 §3](../chapters/07-SIGNIFICANCE.md#condition)、'
             '[07 §4](../chapters/07-SIGNIFICANCE.md#scope-and-order)）。J1–J4 是实践承诺，P 编号是其时的工作板条目。'
             '本理论的核心成果（08 §8 所列）都不是新数学：每项近于定义，或是已知成果的重述；这一判断出自一次 AI 审查，'
             '其检索并不穷尽（[08 §8](../chapters/08-METHOD.md#known-results)）。')

# (finding, entries, field, old, new)
EDITS = [
    ('E6/G5', ['M20'], 'claim_en',
     'inherited generation actually realizes new living content, which under the continuation condition falls under '
     'the relevance read from significance,',
     'the inherited output feeds the relevance interface, so that, where each completion corresponds to new living '
     'content, '
     'the content formed falls under the relevance read from significance under the continuation condition,'),
    ('E6/G5, E5', ['M20'], 'claim_zh',
     '旧生成输出实际实现新的生的内容，它在延续条件之下落入由意义读出的相关性，',
     '旧输出接入相关性接口，使得在每次完成都对应新的活的内容之处，所形成的内容在延续条件之下落入由意义读出的相关性，'),
    ('E5', ['M20'], 'claim_zh', '再在每次完成对应新的生的内容时实现这种内容', '再在每次完成对应新的活的内容时实现这种内容'),
    ('E11', ['M20'], 'claim_zh', '所比较的实现可判定时', '所比较的实现已判定时'),
    ('E5', ['M21'], 'claim_zh', '以生生的方向读之，意识分化生的意义', '以生生的方向读之，意识分化存活之意义'),
    ('E7, G18', ['M26'], 'scope_en',
     'whether observation is a second relation beside dependence is settled at the step of the exchange: dependence '
     'alone carries exactly the responses rising with a level, and a fall only where some level falls '
     '(what-dependence-alone-carries-of-a-level), and observation and dependence are both coupling, by level and by '
     'threshold (where-a-level-couples, D45); neither result is part of this link.',
     'whether observation could be derived from dependence is settled at the step of the exchange: with equality of '
     'conditions decided and activity needing support, dependence alone carries of a level exactly the responses '
     'rising with it up to a bound, and with a complement at a fixed total every response, so observation is '
     'genuinely second only for a falling response with no complement (what-dependence-alone-carries-of-a-level); '
     'in the sense that both are coupling, observation by level and dependence by threshold, it is no second '
     'relation, a reading adopted in D45 (where-a-level-couples); neither is part of this link.'),
    ('E7', ['M26'], 'scope_zh',
     '观察是否为依赖之外的第二种关系，已在交换之步解决：单凭依赖恰好带出随某水平上升的回应，只在某水平下降处带出下降'
     '（what-dependence-alone-carries-of-a-level）；观察与依赖都是耦合，分别依水平与依阈值（where-a-level-couples，D45）；'
     '二者都不在这一环节之内。',
     '观察能否由依赖推出，已在交换之步解决：条件的相等可判定、活动需要支持时，单凭依赖恰好带出随某水平上升至一界的回应，'
     '有总量固定的补时带出每个回应，所以观察只对没有补的下降回应才真是第二种关系（what-dependence-alone-carries-of-a-level）；'
     '在二者都是耦合、观察依水平而依赖依阈值的意义上，它不是第二种关系，这是 D45 采用的读法（where-a-level-couples）；'
     '二者都不在这一环节之内。'),
    ('E8', ['M24'], 'claim_en', 'exactly when the process admits it and the stock covers it',
     'exactly when the link process admits it and the stock covers it'),
    ('E8', ['M24'], 'claim_zh', '恰当过程容许且存量覆盖', '恰当关联过程容许且存量覆盖'),
    ('E9', ['C30', 'F22'], 'scope_en',
     'reference repair uses equal initial slot counts with alike starts, or complete answer agreement with finite '
     'fixed-pair outcomes and excluded middle.',
     'reference repair uses equal initial slot counts, with alike starts, or with complete answer agreement, finite '
     'fixed-pair outcomes and excluded middle.'),
    ('E9', ['C30', 'F22'], 'scope_zh',
     '引用修复用初始位置数相同及相似的起点，或完整问答一致、固定输入对有限结果及排中律。',
     '引用修复用初始位置数相同，并用相似的起点，或用完整问答一致、固定输入对有限结果及排中律。'),
    ('E12/G10', ['C20'], 'scope_en', 'whether practical reasons have a warrant binding every possible mind;',
     'whether practical reasons have a warrant binding every possible mind, with zero substantive premises;'),
    ('E12/G10', ['C20'], 'scope_zh', '实践理由是否有对一切可能心智都有约束力的根据；',
     '实践理由是否有一个零实质前提、对一切可能心智都有约束力的根据；'),
    ('E17', ['C01'], 'claim_zh', '在形成之中，生成与退化皆然，活动形成', '在形成之中（生成与退化皆然），活动形成'),
    ('G3 (B2)', ['C01'], 'scope_en', 'The direct inclusion-to-constitution argument remains incomplete;',
     'The direct inclusion-to-constitution argument remains incomplete: since 22 October it is argued, as a '
     'reading, for the World premises read off one exchange, where the central laws hold of what is read off it '
     '(central-laws-over-every-exchange); that every becoming has such an exchange, and the warrant of locality, '
     'stay open;'),
    ('G3 (B2)', ['C01'], 'scope_zh', '从包容到构成的直接论证仍未完成；',
     '从包容到构成的直接论证仍未完成：自 10 月 22 日起，它作为读法，对从一次交换读出的世界前提已得论证，在那里中心规律对'
     '从交换读出者成立（central-laws-over-every-exchange）；每个生成／变化都有这样的交换、以及局部性的根据，仍然开放；'),
]
B2_LINK = {'label_zh': '中心规律对每个交换关系成立', 'label_en': 'The central laws over every relation of exchange',
           'path': 'theories/becoming/results/records/central-laws-over-every-exchange.json'}
B2_AFTER = 'theories/becoming/results/records/derived-history-law-exactness.json'
CLAUSE = ['C03', 'C17', 'C24', 'M15', 'M20']


def once(text, old, new, where):
    assert text.count(old) == 1, (where, text.count(old), old[:80])
    return text.replace(old, new)


def main():
    data = json.loads(DATA.read_text())
    entries = {e['id']: e for s in data['sections'] for e in s['entries']}
    for key, old, new in (('scope_en', SCOPE_EN, SCOPE_EN2), ('scope_zh', SCOPE_ZH, SCOPE_ZH2)):
        data[key] = once(data[key], old, new, 'opening ' + key)
    for i in CLAUSE:
        e = entries[i]
        for lang, old, new in (('en', S_EN, S_EN2), ('zh', S_ZH, S_ZH2)):
            fields = [f for f in ('claim_' + lang, 'scope_' + lang) if old in e[f]]
            assert len(fields) == 1, (i, lang, fields)
            e[fields[0]] = once(e[fields[0]], old, new, (i, fields[0]))
    for finding, ids, field, old, new in EDITS:
        for i in ids:
            entries[i][field] = once(entries[i][field], old, new, (finding, i, field))
    links = entries['C01']['links']
    assert not any(l['path'] == B2_LINK['path'] for l in links)
    at = [k for k, l in enumerate(links) if l['path'] == B2_AFTER]
    assert len(at) == 1, at
    links.insert(at[0] + 1, B2_LINK)
    text = json.dumps(data, ensure_ascii=False)
    for gone in ('继续生成是生生', 'further generation is 生生', '拓宽', '每一生的主张', '新的生的内容'):
        assert gone not in text, gone
    DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')
    print('applied', len(EDITS), 'edits, the clause in', len(CLAUSE), 'entries, the key, and C01\'s link')


if __name__ == '__main__':
    main()
