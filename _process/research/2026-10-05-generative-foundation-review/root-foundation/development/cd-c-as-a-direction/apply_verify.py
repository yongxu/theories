#!/usr/bin/env python3
"""CD's third round: the verification of the second round taken (DESIGN.md §8, reviews/second-round-check.json),
with two places that stated less than the Lean proves, which the fronts' owner reported. Applied exactly after
apply_check.py, by its own procedure: each old text must occur once, or its replacement must already stand.

usage: python3 -B apply_verify.py ROOT
Documents, record texts and one region note only: no Lean, no record's claim changed. Then render.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import apply_check as ac  # noqa: E402

DATE, DATE_ZH, ONE_SENSE, ONE_SENSE_ZH = ac.DATE, ac.DATE_ZH, ac.ONE_SENSE, ac.ONE_SENSE_ZH

ac.TEXT = {
    ac.C7: [
        # the causal-set Theorem paragraph, what-can-be-born-next's home, names the start its laws need, as §2's
        # reading and the open item already do (the second check's Lean finding 0)
        ('on what can be born next the course of births with empty pasts is above every course with a pair, and',
         'on what can be born next the course of births with empty pasts widens every course from the empty set '
         'with a pair, and'),
        ('read on both together neither of two such courses widens the other, and two courses one of which lacks a '
         'pair of the other are mixed',
         'read on both together neither of two courses from the empty set widens the other, and two such courses '
         'one of which lacks a pair of the other are mixed'),
        # the record says abstaining restraint is not shown to extend overdraw, not that it is unranked
        ('restraint by abstaining is not ranked under the relation-level reading',
         'restraint by abstaining is not shown to extend overdraw under the relation-level reading'),
        # the four cases cover wherever inclusion against exceeding is decided both ways, a root law
        ('`Web.Keeps.not_mixed`); that every comparison falls under one is classical.',
         '`Web.Keeps.not_mixed`), and wherever inclusion or exceeding is decided both ways one of them holds, a root '
         'law for every relation (`«四比之周»`); that every comparison falls under one is classical.'),
    ],
    ac.C1: [
        ('(`«广非自»`, `«广不可逆»`, `«广之传递»`) and excludes keeping the same and being mixed; deciding inclusion '
         'against exceeding for every pair of relations is exactly excluded middle',
         '(`«广非自»`, `«广不可逆»`, `«广之传递»`) and excludes keeping the same and being mixed, as keeping the same '
         'excludes being mixed (`«广则非齐»`, `«广则非杂»`, `«齐则非杂»`); where inclusion or exceeding is decided '
         'both ways, one of the four cases holds (`«四比之周»`), and deciding inclusion against exceeding for every '
         'pair of relations is exactly excluded middle'),
    ],
    'theories/becoming/ONE-ARGUMENT.md': [
        ('Restraint taking from no condition more than it gives is ranked stepwise too (',
         'Restraint taking from no condition more than it gives is ranked stepwise too where it includes an event '
         'overdraw withholds ('),
    ],
    'theories/becoming/results/data/regions.json': [
        ('read on what continues the order reverses, no strict order holds both',
         'read on what continues the inclusion reverses, no strict order holds both'),
    ],
}

ac.RECORDS = {
    'stepwise-law-of-easing': {'replace': [
        # the statement carries the iff its note, its home row and law 4 give, within the cap
        ('Under easing the stepwise reading withdraws exactly the events the easing course undermines; a course whose '
         'levels never fall undermines nothing, so restraint taking within what it gives extends overdraw for any '
         'number of drawers where it includes',
         'Read stepwise, easing withdraws exactly the events the easing course undermines; a course whose levels never '
         'fall undermines nothing, so restraint taking within what it gives extends overdraw for any number of drawers '
         'exactly where it includes'),
        ('扩展过度汲取，在它记入过度汲取扣下的某个事件之处', '扩展过度汲取，恰在它记入过度汲取扣下的某个事件之处'),
        ('extends overdraw under it too where it includes a relation',
         'extends overdraw under it too exactly where it includes a relation'),
    ]},
    'ranking-under-readings': {'replace': [
        ('for any number of drawers where it includes an event', 'for any number of drawers exactly where it includes an event'),
        ('extends overdraw under it too where it includes a relation',
         'extends overdraw under it too exactly where it includes a relation'),
    ]},
    'the-run-classes-and-widening': {'replace': [
        # arising is needed for a part not active at the start to change what can form, not sufficient (law 5)
        ('Arising is where it begins how a part changes what can form.',
         'Arising is where a part not active at the start can begin to change what can form.'),
        ('生起是一个部分如何改变能形成者的开始。', '生起是起点不活动的部分得以开始改变能形成者之处。'),
    ]},
    'significance-retained-within-margin': {
        'replace': [
            ('The whole-run classes (renewing, consuming, arising) related to the order on what can form:',
             'The whole-run classes (renewing, consuming, arising) and how a part changes what can form:'),
            ('整段类别（更新、消耗、生起）与能形成者之序的关系：', '整段类别（更新、消耗、生起）与部分如何改变能形成者：'),
        ],
        'note': {
            'en': f'{DATE}: a related line on the-run-classes-and-widening says how a part changes what can form, as '
                  f'that record and its home section in 07 §2 now say, not the order on what can form. {ONE_SENSE}. '
                  'The claim is unchanged.',
            'zh': f'{DATE_ZH}：一条关于 the-run-classes-and-widening 的相关说明改说部分如何改变能形成者，与该记录及 07 §2 的'
                  f'本节现今所说相同，而非能形成者之序。{ONE_SENSE_ZH}。主张不变。',
        },
    },
    'what-a-course-keeps-reachable': {'replace': [
        # covering is a preorder and puts nothing above; the note's second clause had made it a subject that puts
        ('say likewise what covering, the lagged order and the lexical order put above, as its home section in 07 §2 does',
         'say likewise what widening what can be reached, widening with a lag, the lagged order and the lexical order '
         'do with a pair, as its home section in 07 §2 does'),
        ('亦改说覆盖、滞后之序与字典序把何者置于何者之上，与 07 §2 的本节相同',
         '亦改说可达之扩大、带滞后之扩大、滞后之序与字典序于一对进程何为，与 07 §2 的本节相同'),
    ]},
    'whole-and-regions-and-bounded-centers': {
        'replace': [
            ("for every family of regions: the whole's judgment decides every narrower one, whether the region is a "
             "system's or a self's;",
             "for every family of regions, whether the region is a system's or a self's;"),
            ('对每个区域族都从 p 保留：整体的判断决定每个较窄的判断，无论区域是系统的还是自身的；',
             '对每个区域族都从 p 保留，无论区域是系统的还是自身的；'),
            ("The whole's judgment decides every narrower one.", 'What retains in the whole retains in every region.'),
            ('整体的判断决定每个较窄的判断。', '在整体中保留的在每个区域内保留。'),
        ],
        'append': {
            'en': " Law 3 and the input of its dependency on continuation-condition-yields-living-significance said "
                  "that the whole's judgment decides every narrower one, which holds of retaining only (a losing "
                  "verdict of the whole decides nothing narrower, laws 4 to 6); they now say that what retains in the "
                  "whole retains in every region.",
            'zh': '律 3 与其对 continuation-condition-yields-living-significance 之依赖的输入原说整体的判断决定每个较窄的'
                  '判断，此仅于保留成立（整体判为失者不决定任何较窄者，律 4 至 6）；今改说在整体中保留的在每个区域内保留。',
        },
    },
    'four-cases-of-a-part': {
        'replace': [
            ('the split into four cases is classical logic over the two inclusions, not a Lean theorem.',
             'wherever inclusion or exceeding is decided both ways one of the four cases holds, a root law '
             '(`«四比之周»`), and deciding it for every pair is exactly excluded middle (`«则逾之定当且仅当排中»`).'),
            ('分为四种情形是对两个包含的经典逻辑，不是 Lean 定理。',
             '包含或超出两向皆已判定之处，四种情形必居其一，是根律（`«四比之周»`）；对每一对皆作此判定恰是排中律'
             '（`«则逾之定当且仅当排中»`）。'),
        ],
        'note': {
            'en': f'{DATE}: a hypothesis said that the split into four cases is classical logic, not a Lean theorem. '
                  'Wherever inclusion or exceeding is decided both ways one of the cases holds by a root law for every '
                  'relation (`«四比之周»`), and only deciding it for every pair is excluded middle; the hypothesis and '
                  'its home section in 07 §2 now say so. The claim is unchanged.',
            'zh': f'{DATE_ZH}：一条假设原说分为四种情形是经典逻辑，不是 Lean 定理。包含或超出两向皆已判定之处，由对每个关系皆'
                  '成立的根律（`«四比之周»`），四种情形必居其一，唯对每一对皆作此判定方为排中律；该假设与 07 §2 的本节今如'
                  '此说。主张不变。',
        },
    },
}

if __name__ == '__main__':
    ac.main()
