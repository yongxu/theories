#!/usr/bin/env python3
"""CD's text changes: names that state a wrong meaning under the glossary's one sense of ranking and order, from the
names test (names-test.json), applied exactly. Each old text must occur once, or its replacement must already stand.

usage: python3 -B apply_cd.py ROOT
Documents, record texts and one tool's display name only: no Lean, no record's claim changed. Run on 049e14ca1 before the record
renames (renames.tsv, research.py rename-id); apply_check.py then takes the independent check's findings.
"""
import json
import sys

C7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
C8 = 'theories/becoming/chapters/08-METHOD.md'
C1 = 'theories/becoming/chapters/01-ROOT.md'
CD = 'theories/becoming/COLLECTIVE-DIRECTION.md'
REC = 'theories/becoming/results/records/'
DATE = '3 November 2026, CD (board item CD)'
DATE_ZH = '2026年11月3日，工作板条目 CD'

TEXT = {
    C7: [
        # widening named as an order or a ranking, where under the one sense it says which admits more
        ('With no premise, widening what can form is an order, and alignment is first what a selection reaches.',
         'With no premise, the laws give how two courses differ in what they admit (one widens the other, they admit the '
         'same, or they are mixed), and alignment is first what a selection reaches.'),
        ('## 2. The order with no premise\n', '## 2. How two courses differ, with no premise\n'),
        ('do not alone decide the order:', 'do not alone decide whether a part narrows, keeps or widens what can form:'),
        ('Where widening orders a pair, eventual widening agrees', 'Where one course of a pair widens the other, eventual '
         'widening agrees'),
        ('and the two readings rank a pair oppositely, so the choice between them is a premise',
         'and the two readings hold of a pair in opposite directions, so the choice between them is a premise'),
        ('widening what can be reached does not rank the other above it (`Reaching.not_widens_of_wider_now`), nor, with '
         'the courses read as realized starting at their configurations, does the lexical order below '
         '(`Reaching.not_above_wider_now`)',
         'the other does not widen what can be reached over it (`Reaching.not_widens_of_wider_now`), nor, with the '
         'courses read as realized starting at their configurations, is the other above it in the lexical order below '
         '(`Reaching.not_above_wider_now`)'),
        ('that never ranks a configuration above one covering it', 'that never puts a configuration above one covering it'),
        ('along a course it ranks a successor above its predecessor', 'along a course it puts a successor above its '
         'predecessor'),
        ('it ranks the climb above the other while', 'it puts the climb above the other while'),
        ('it ranks the other above, as it must', 'it puts the other above, as it must'),
        ('so a range that keeps widening is never ranked above one wider now that starts a course',
         'so a range that keeps widening is never put above one wider now that starts a course'),
        ('it ranks some such pairs and not every one', 'it decides some such pairs and not every one'),
        ('the realized course and the courses kept reachable rank a pair oppositely, so an account holding both needs',
         'realized widening and widening what can be reached hold of a pair in opposite directions, so an account '
         'holding both needs'),
        ('which ranks a delivered output above its input on one process (`RiseTask.widens`) and below it on another '
         '(`FallTask.widens_back`), and on the catalytic cycle, where no configuration starts a course, it ranks nothing '
         '(`Catalysis.not_widensOrLater`)',
         'which puts a delivered output above its input on one process (`RiseTask.widens`) and below it on another '
         '(`FallTask.widens_back`), and on the catalytic cycle, where no configuration starts a course, holds of no '
         'pair (`Catalysis.not_widensOrLater`)'),
        ('so it is not the order they carry', 'so they do not carry it'),
        ('widening loses precedence and ranks highest the course in which nothing conditions anything, where nothing '
         'continues; read on what continues, the chain.',
         'widening loses precedence: the course in which nothing conditions anything, where nothing continues, widens '
         'every course from the empty set with a precedence pair (`CausalGrowth.antichain_rangeWidens`); read on what '
         'continues, the chain widens every course from the empty set lacking one of its pairs '
         '(`CausalGrowth.chain_rangeWidens_continuing`).'),
        ('it is not the order read on what can be born next', 'it is not widening read on what can be born next'),
        ('on the own-condition web widening with a lag and eventual widening rank a pair oppositely',
         'on the own-condition web widening with a lag and eventual widening hold of a pair in opposite directions'),
        ('so widening what can be reached never ranks a configuration above one that starts a course and admits now '
         'what it does not',
         'so widening what can be reached never puts a configuration above one that starts a course and admits now '
         'what it does not'),
        ('on a branching witness realized and reachable widening rank a pair oppositely, so no strict partial order '
         'there contains both',
         'on a branching witness realized and reachable widening hold of a pair in opposite directions, so no strict '
         'partial order there contains both'),
        ('on what can be born next it ranks highest the course in which nothing continues, on what continues the chain, '
         'no strict order contains both',
         'on what can be born next the course in which nothing continues widens every course from the empty set with a '
         'precedence pair, on what continues the chain widens every course from the empty set lacking one of its pairs, '
         'and no strict order contains both widenings'),
        # C's own sentence in §5: C ranks only where one course widens the other
        ('C ranks courses; choices take more,', 'C ranks a course above each course it widens and decides no other pair; choices take more,'),
    ],
    C8: [
        ('| `Comparison` | the only premise that ranks courses; warrant open |',
         '| `Comparison` | gives order, in general alone (self-concern ranks one case with no C); warrant open |'),
        ('| Order | widening is retaining and adding;', '| Widening | widening is retaining and adding;'),
        ('1 of 8 on order', '1 of 8 on widening'),
    ],
    C1: [('- *Order.* Widening of relations', '- *Widening.* Widening of relations')],
    '_process/RESULT-WORKFLOW.md': [('(closure, balance, finite runs, lumping, order)',
                                     '(closure, balance, finite runs, lumping, widening)')],
    'theories/becoming/results/completion/COVERAGE.json': [('"id": "order",\n      "name": "Order",',
                                                            '"id": "order",\n      "name": "Widening",')],
    'tools/research/shared_laws.py': [("'lumping': 'lumping', 'order': 'order'}", "'lumping': 'lumping', 'order': 'widening'}")],
    CD: [('- **a direction**, widening, which every weighting positive on the listed items ranks higher, and which is '
          'silent where a comparison is mixed (§1);',
          '- **a criterion**, widening, which every weighting positive on the listed items ranks higher, and which is '
          'silent where a comparison is mixed; it is the title\'s generative direction only under the two premises '
          '(§1);')],
}

ONE_SENSE = ('Under the glossary\'s one sense, ranking and order (the ethics\' role word) say which course is better, '
             'and widening says which admits more, with no premise')
ONE_SENSE_ZH = '按词汇表的单一词义，排序与次序（伦理的角色词）说哪个进程更好，扩大说哪个所纳更多，不需前提'

RECORDS = {
    'shared-laws-on-the-grammar': {
        'replace': [('"en": "Order. Widening of relations', '"en": "Widening. Widening of relations'),
                    ('"en": "Order read on the models, both ways', '"en": "Widening read on the models, both ways'),
                    ('rest at amounts, lumping and order are proved', 'rest at amounts, lumping and widening are proved'),
                    ('lumping and order, with the models', 'lumping and widening, with the models'),
                    ('"zh": "序：关系之扩大', '"zh": "扩大：关系之扩大'),
                    ('于模型上读序，两向', '于模型上读扩大，两向'),
                    ('归并与序之律', '归并与扩大之律'),
                    ('归并与序，模型之律', '归并与扩大，模型之律')],
        'note': {'en': f'{DATE}: the shared law labelled "order" is labelled "widening" in the statement and in laws 17, 18 '
                       f'and 20, with 01 §7, 08 §7 and the view\'s display name. {ONE_SENSE}; this law is widening and its '
                       'laws as a strict partial order. Its content, laws, anchors and key are unchanged.',
                 'zh': f'{DATE_ZH}：标为“序”的共律，于陈述及律 17、18、20 中改标为“扩大”，与 01 §7、08 §7 及视图的显示名一致。'
                       f'{ONE_SENSE_ZH}；此律即扩大及其作为严格偏序之律。内容、诸律、锚点与键不变。'},
    },
    'stepwise-law-of-easing': {
        'replace': [('so restraint that takes within what it gives ranks above overdraw for any number of drawers under '
                     'the stepwise reading too.',
                     'so restraint that takes within what it gives extends overdraw for any number of drawers under the '
                     'stepwise reading too, and C ranks it above.'),
                    ('所以所取不超过所给的节制在逐步读法下也对任意多个汲取者排在过度汲取之上。',
                     '所以所取不超过所给的节制在逐步读法下也对任意多个汲取者扩展过度汲取，C 把它排在其上。')],
        'note': {'en': f'{DATE}: the statement says that restraint extends overdraw, which needs no premise, and that C '
                       f'ranks it above, as its home row in 07 §5 says. {ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述改说节制扩展过度汲取（不需前提），且 C 把它排在其上，与 07 §5 的本节一行相同。'
                       f'{ONE_SENSE_ZH}。主张不变。'},
    },
    'comparing-two-courses-on-what-they-admit': {
        'replace': [('it and eventual widening rank a pair oppositely.',
                     'it and eventual widening relate one pair oppositely.'),
                    ('带滞后的扩大与最终扩大对一对进程排序相反。', '带滞后的扩大与最终扩大于一对进程方向相反。')],
        'note': {'en': f'{DATE}: the last clause says that widening with a lag and eventual widening relate one pair '
                       f'oppositely, not that they rank it. {ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：末句改说带滞后的扩大与最终扩大于一对进程方向相反，而非对之排序。{ONE_SENSE_ZH}。主张不变。'},
    },
    'what-a-course-keeps-reachable': {
        'replace': [('only with a lag does it rank a range', 'only with a lag does it put a range'),
                    ('realized and reachable widening rank a pair oppositely.',
                     'realized and reachable widening relate a pair oppositely.'),
                    ('故仅带滞后时才把持续扩大的范围排在起进程且当下更宽者之上', '故仅带滞后时才把持续扩大的范围置于起进程且当下更宽者之上'),
                    ('实现之扩大与可达之扩大对一对排序相反。', '实现之扩大与可达之扩大于一对进程方向相反。')],
        'note': {'en': f'{DATE}: the statement says that covering with a lag puts a range above another, and that realized '
                       f'and reachable widening relate a pair oppositely, not that they rank it, as its home section in 07 '
                       f'§2 says. {ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述改说带滞后的覆盖把一个范围置于另一个之上，且实现之扩大与可达之扩大于一对进程方向相反，'
                       f'而非对之排序，与 07 §2 的本节相同。{ONE_SENSE_ZH}。主张不变。'},
    },
    'horizon-optima-hold-the-greatest-renewal': {
        'replace': [('"en": "Ranked over a horizon, what a course draws', '"en": "Over a horizon, what a course draws'),
                    ('"zh": "在视野上排序时，过程所汲取', '"zh": "在视野上，过程所汲取')],
        'note': {'en': f'{DATE}: "ranked" dropped from the statement\'s first clause, an identity of amounts with no order '
                       'in it; the orders enter in the next clause, which names them. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述首句删去“排序时”：该句是量的恒等式，其中无序；诸序在下一句进入并有其名。主张不变。'},
    },
    'widening-as-what-every-weighting-ranks': {
        'replace': [('"en": "Widening as what every weighting ranks"', '"en": "Widening as what every positive weighting ranks"'),
                    ('"zh": "扩大即每个加权所排者"', '"zh": "扩大即每个正的加权所排者"')],
        'note': {'en': f'{DATE}: retitled "Widening as what every positive weighting ranks", and the id renamed to '
                       'widening-as-what-every-positive-weighting-ranks, the old id kept. A weighting is any natural weight '
                       'on the listed items and a zero weight ties, as the statement says, so "every weighting" stated a '
                       'universal the record refutes; positivity is where C\'s premise is relocated. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：标题改为“扩大即每个正的加权所排者”，标识改为 widening-as-what-every-positive-weighting-ranks，'
                       '旧标识保留。加权是所列诸项上的任意自然数权重，零权持平，如陈述所言，故“每个加权”所说的全称为本记录所否；'
                       '正性正是 C 之前提的移置之处。主张不变。'},
    },
    'whole-first-and-bounded-centers': {
        'replace': [('"zh": "整体优先，与以依存为界的中心"', '"zh": "整体与其区域，与以依存为界的中心"'),
                    ('"en": "The whole first, and centers bounded by dependence"',
                     '"en": "The whole and its regions, and centers bounded by dependence"')],
        'note': {'en': f'{DATE}: retitled "The whole and its regions, and centers bounded by dependence", and the id renamed '
                       'to whole-and-regions-and-bounded-centers, the old id kept. "The whole first" (优先) stated a '
                       'priority; the record shows that under the continuation condition what retains in the whole '
                       'retains in every region, not conversely, and no priority. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：标题改为“整体与其区域，与以依存为界的中心”，标识改为 whole-and-regions-and-bounded-centers，'
                       '旧标识保留。“整体优先”说的是一种优先；本记录所示是：延续条件之下在整体中保留的在每个区域内保留，'
                       '反过来不成立，而非优先。主张不变。'},
    },
}


def once(text, old, new, where):
    n = text.count(old)
    if n == 1:
        return text.replace(old, new), 1
    if n == 0 and new in text:
        return text, 0
    raise SystemExit(f'{where}: {n} occurrences of {old[:70]!r}')


def main():
    root = sys.argv[1]
    changed = 0
    for path, pairs in TEXT.items():
        p = f'{root}/{path}'
        text = open(p, encoding='utf-8').read()
        for old, new in pairs:
            text, k = once(text, old, new, path)
            changed += k
        open(p, 'w', encoding='utf-8').write(text)
    for rid, spec in RECORDS.items():
        p = f'{root}/{REC}{rid}.json'
        text = open(p, encoding='utf-8').read()
        k_all = 0
        for old, new in spec['replace']:
            text, k = once(text, old, new, rid)
            k_all += k
        d = json.loads(text)
        if not any(h.get('en', '').startswith(DATE) for h in d.get('history', [])):
            d.setdefault('history', []).append(spec['note'])
            k_all += 1
        open(p, 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
        changed += k_all
    print(changed, 'changes applied')


if __name__ == '__main__':
    main()
