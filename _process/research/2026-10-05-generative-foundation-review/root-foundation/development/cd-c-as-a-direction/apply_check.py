#!/usr/bin/env python3
"""CD's second round: the independent check's findings taken (DESIGN.md §7, reviews/independent-check.json), applied
exactly after apply_cd.py and the renames. Each old text must occur once, or its replacement must already stand.

usage: python3 -B apply_check.py ROOT
Documents, record texts, one tool's docstring and one region note only: no Lean, no record's claim changed. Then run
tools/research/shared_laws.py and render.
"""
import json
import sys

C7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
C8 = 'theories/becoming/chapters/08-METHOD.md'
C1 = 'theories/becoming/chapters/01-ROOT.md'
CD = 'theories/becoming/COLLECTIVE-DIRECTION.md'
REC = 'theories/becoming/results/records/'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
DATE = '3 November 2026, CD (board item CD)'
DATE_ZH = '2026年11月3日，工作板条目 CD'

ONE_SENSE = ('Under the glossary\'s one sense, ranking and order (the ethics\' role word) say which course is better, '
             'and widening says which admits more, with no premise')
ONE_SENSE_ZH = '按词汇表的单一词义，排序与次序（伦理的角色词）说哪个进程更好，扩大说哪个所纳更多，不需前提'
PUT = ('an order defined with no premise, the lagged, tail or lexical order among them, puts one course above another, '
       'and ranks only where it is read as a ranking, in C\'s slot or as a premise')
PUT_ZH = '无前提而定义之序（滞后之序、尾序或字典序等）把一进程置于另一进程之上，唯作为排序读时（于 C 之位或作为前提）才排序'

TEXT = {
    C7: [
        # 07 §1: "it" had two antecedents, the thesis and the unfolding
        ('positions, regions and standards form within it; none outside it owns value.',
         'positions, regions and standards form within the unfolding; none outside it owns value.'),
        # §6 states the thesis as §1 now does (the philosophy dossier's P-25 follows at the freeze)
        ('A person, an AI system and a training process are formations within one unfolding, each coupling',
         'On the thesis of one relational unfolding ([§1](#evaluation)), a person, an AI system and a training process '
         'are formations within the unfolding, each coupling'),
        # §2: a fourth case (mixed) was left out; name the question, not three of its answers
        ('do not alone decide whether a part narrows, keeps or widens what can form:',
         'do not alone decide how a part changes what can form:'),
        # §2: premise-free lagged and tail orders put above, as UE10's already did
        ('What a course keeps reachable ranks a range that keeps widening above one wider now',
         'What a course keeps reachable puts a range that keeps widening above one wider now'),
        ('the tail order ranks a course above one that admitted a formation it never admits '
         '(`TailAndLag.tailOrder_loses`), and widening or widening with a lag never ranks so',
         'the tail order puts a course above one that admitted a formation it never admits '
         '(`TailAndLag.tailOrder_loses`), and widening or widening with a lag never does so'),
        ('the order of a lag varying with the formation and the tail order rank only so',
         'the order of a lag varying with the formation and the tail order put a course above another only so'),
        # §2: one 全生成 already reads two grains; the relay's law gives two orders of grain (02 §1)
        ('every supported occurrence is 全生成 at two grains along passing',
         'every supported occurrence is 全生成 at two orders of grain along passing'),
        # §2, causal sets: the Lean needs both courses from the empty set
        ('there no course widens another, two courses differing by a pair are mixed,',
         'there neither of two courses from the empty set widens the other, two such courses differing by a pair are '
         'mixed,'),
        ('read on stems, ranks nothing above the antichain (`CausalGrowth.not_above_antichain`)',
         'read on stems, ranks no course from the empty set with a precedence pair above the antichain '
         '(`CausalGrowth.not_above_antichain`)'),
        # §5: C ranks by extension on the reading it is read on; only on what a course admits is that widening
        ('C ranks a course above each course it widens and decides no other pair; choices take more, following from '
         'neither the condition nor C: a reading of `living` (which events a course includes), the lifting L and the '
         'commitments J1–J4.',
         'On a reading of `living`, C ranks a course above each course it extends there, including every event the '
         'other includes and one more, and decides no other pair; read on what a course admits, as the possibility '
         'reading is, those are the courses it widens (`Web.paths_extension_iff_widens`, `Ranking.possible_course_iff`), '
         'and the readings below decide some pairs differently. Choices take more, following from neither the '
         'condition nor C: which reading of `living` (which events a course includes), the lifting L and the '
         'commitments J1–J4.'),
        # §5's table: restraint extends overdraw only where it includes what overdraw withholds (an iff in the Lean)
        ('| Reading | What easing withdraws | With the restraint hypotheses above, restraint over any number of drawers '
         'extends overdraw, and C ranks it higher, where it also | Lean |',
         '| Reading | What easing withdraws | With the restraint hypotheses above, restraint over any number of drawers '
         'extends overdraw exactly where it includes an event (relation-level: a relation) overdraw withholds, and C '
         'then ranks it higher, where it also | Lean |'),
        # open items: punctuation, and the start C's verdict needs
        ('on what can be born next the course in which nothing continues widens every course from the empty set with a '
         'precedence pair, on what continues the chain widens every course from the empty set lacking one of its pairs, '
         'and no strict order contains both widenings, and with every continuation\'s losses counted the reading is on '
         'both together, where C ranks no two courses.',
         'on what can be born next the course in which nothing continues, the antichain, widens every course from the '
         'empty set with a precedence pair; on what continues the chain widens every course from the empty set lacking '
         'one of its pairs; no strict order contains both widenings; and with every continuation\'s losses counted the '
         'reading is on both together, where C ranks no two courses from the empty set.'),
    ],
    C8: [
        ('| Widening | widening is retaining and adding; the ethics adds the condition for scope and C for order |',
         '| Widening | widening (including and exceeding) is irreflexive, one-way and transitive; under the continuation '
         'condition it is retaining and adding; the ethics adds the condition for scope and C for order |'),
        ('| [The order of what can form](07-SIGNIFICANCE.md#r-four-cases-of-a-part) |',
         '| [How two courses differ in what can form](07-SIGNIFICANCE.md#r-four-cases-of-a-part) |'),
        ('ranking a delivered output above its input on one witness and below it on another',
         'putting a delivered output above its input on one witness and below it on another'),
        ('what widening is read on decides what it ranks.', 'what widening is read on decides which course widens which.'),
        ('- the order of what can form, weakly:', '- how a part changes what can form, weakly:'),
        ('which generation at two grains does not give', 'which generation at two orders of grain does not give'),
    ],
    C1: [('generation at two grains and renewal without end can hold',
          'generation at two orders of grain and renewal without end can hold')],
    'GLOSSARY.md': [('generation can go on at two grains while what can form only returns',
                     'generation can go on at two orders of grain while what can form only returns')],
    CD: [('which is silent where a comparison is mixed; it is the title\'s generative direction only under the two '
          'premises (§1);',
          'which is silent where a comparison is mixed (§1); it is the question\'s generative direction only under the '
          'two premises ("A generative direction", read here, below);'),
         ('is generation at two grains along passing', 'is generation at two orders of grain along passing')],
    'theories/becoming/results/completion/COVERAGE.json': [
        ('"statement": "widening is retaining and adding; the ethics adds two premises,',
         '"statement": "widening (including and exceeding) is irreflexive, one-way and transitive; under the '
         'continuation condition it is retaining and adding; the ethics adds two premises,')],
    'tools/research/shared_laws.py': [('(closure, balance, finite runs, lumping, order)',
                                       '(closure, balance, finite runs, lumping, widening)')],
    'theories/becoming/results/data/regions.json': [('finite runs and rest, lumping, order; below the frame',
                                                     'finite runs and rest, lumping, widening; below the frame')],
    'theories/becoming/review/LOGIC.md': [('07-SIGNIFICANCE.md#r-widening-as-what-every-weighting-ranks)',
                                           '07-SIGNIFICANCE.md#r-widening-as-what-every-positive-weighting-ranks)')],
    # P-02's quotation of 07 §1 follows its text; the rest of P-02 and P-07 are the dossier's owner's at the freeze
    'theories/becoming/review/PHILOSOPHY.md': [
        ('"positions, regions and standards form within it; none outside it owns value."',
         '"positions, regions and standards form within the unfolding; none outside it owns value."')],
    DEV + 'ue8-sciences-dossier/SCIENCES.md': [('the order of what can form, weakly (07; not treated here)',
                                                'how a part changes what can form, weakly (07; not treated here)')],
    # the reading register's paraphrase of 07's thesis line; its source hash is left for the register's reread
    'theories/becoming/results/data/arguments-a-l.json': [
        ('不加前提，扩大即一种次序；', '不加前提，诸律给出两个进程在所纳上如何不同；'),
        ('with no premise widening is an order;', 'with no premise the laws give how two courses differ in what they admit;')],
    DEV + 'cd-c-as-a-direction/sweep.py': [
        ('read in the sentence; the decision is in DESIGN.md §6',
         'read in the sentence; DESIGN.md §6 gives the counts and the two that needed action, names-test.json the '
         'judged names')],
}

RESTRAINT_REL = ('restraint that keeps taking part extends overdraw under it too where it includes a relation overdraw '
                 'withholds, and C ranks it above.')
RESTRAINT_REL_ZH = '仍参与的节制在它之下也扩展过度汲取，恰在它记入过度汲取扣下的某个关系之处，C 把它排在其上。'
REACH_LAG = ('so it puts a range that keeps widening above one wider now that starts a course only read with a lag, and '
             'not every such pair.')
REACH_LAG_ZH = '故仅带滞后读时把持续扩大之范围置于起进程且当下更宽者之上，且非每一此种对。'

RECORDS = {
    'what-a-course-keeps-reachable': {
        'replace': [
            ('so only with a lag does it put a range', 'so only the lagged order puts a range'),
            ('故仅带滞后时才把持续扩大的范围置于', '故仅带滞后之序才把持续扩大的范围置于'),
            ("widening what can be reached does not rank s above s', nor, the realized courses starting at their "
             "configurations, does the lexical order.",
             "s does not widen what can be reached over s', nor, the realized courses starting at their configurations, "
             "is s above s' in the lexical order."),
            ("可达之扩大不把 s 排在 s' 之上；实现之进程起于其构型时，字典序亦然。",
             "s 不扩大可达者于 s' 之上；实现之进程起于其构型时，于字典序中 s 亦不在 s' 之上。"),
            ('a strict partial order ranking no configuration above one covering it',
             'a strict partial order putting no configuration above one covering it'),
            ('从不把构型排在覆盖它者之上', '从不把构型置于覆盖它者之上'),
            ('widening with a lag never ranks a configuration above its predecessor, so the lagged order ranks a '
             'successor above it',
             'widening with a lag never puts a configuration above its predecessor, so the lagged order puts a successor '
             'above it'),
            ('带滞后之扩大从不把构型排在其前驱之上，故滞后之序把后继排在前驱之上',
             '带滞后之扩大从不把构型置于其前驱之上，故滞后之序把后继置于前驱之上'),
            ('the lagged order ranks the climb above none', 'the lagged order puts the climb above none'),
            ('滞后之序把攀升排在 none 之上而非反之', '滞后之序把攀升置于 none 之上而非反之'),
            ('it ranks none above the climb, as it must', 'it puts none above the climb, as it must'),
            ('它把 none 排在攀升之上，理当如此', '它把 none 置于攀升之上，理当如此'),
            ('Realized and reachable widening rank a pair oppositely, on this witness:',
             'Realized and reachable widening hold of a pair in opposite directions, on this witness:'),
            ('于此见证上，实现之扩大与可达之扩大对一对排序相反：', '于此见证上，实现之扩大与可达之扩大于一对进程方向相反：'),
            ('It ranks k above single, with the same realized ranges, which realized widening leaves unranked.',
             'It puts k above single, with the same realized ranges, a pair realized widening leaves undecided.'),
            ('它把 k 排在 single 之上，二者实现范围相同，实现之扩大不排之。',
             '它把 k 置于 single 之上，二者实现范围相同，实现之扩大于此不定。'),
            ('it ranks that configuration above (WiderNow.Full.not_silent)',
             'it puts that configuration above (WiderNow.Full.not_silent)'),
            ('它把该构型排在上（WiderNow.Full.not_silent）', '它把该构型置于其上（WiderNow.Full.not_silent）'),
            ('widening what can be reached ranks a climb that keeps widening above it',
             'a climb that keeps widening widens what can be reached over it'),
            ('可达之扩大把持续扩大之攀升排在其上', '持续扩大之攀升扩大可达者于其上'),
            ('so what a course keeps reachable ranks a range that keeps widening above one wider now that starts a '
             'course only with a lag',
             'so what a course keeps reachable puts a range that keeps widening above one wider now that starts a course '
             'only read with a lag'),
            ('故进程保持可达者仅带滞后时把持续扩大之范围排在起进程且当下更宽者之上',
             '故进程保持可达者仅带滞后读时把持续扩大之范围置于起进程且当下更宽者之上')],
        'note': {'en': f'{DATE}: the statement says that only the lagged order puts a range that keeps widening above one '
                       'wider now that starts a course, and that realized and reachable widening relate a pair '
                       'oppositely, not that they rank it; laws 3, 6 to 9, 18 and 19, two counterexamples and a related '
                       'line say likewise what covering, the lagged order and the lexical order put above, as its home '
                       f'section in 07 §2 does. {ONE_SENSE}; {PUT}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述改说仅带滞后之序才把持续扩大之范围置于起进程且当下更宽者之上，且实现之扩大与可达之扩大于'
                       '一对进程方向相反，而非对之排序；律 3、6 至 9、18 与 19，两个反例与一条相关说明亦改说覆盖、滞后之序与字典序'
                       f'把何者置于何者之上，与 07 §2 的本节相同。{ONE_SENSE_ZH}；{PUT_ZH}。主张不变。'},
    },
    'tasks-and-what-performs-them': {
        'replace': [
            ("So widening with a lag never ranks what a configuration reaches above it, and UE10's lagged order ranks it "
             "above exactly",
             "So widening with a lag never puts what a configuration reaches above it, and UE10's lagged order puts it "
             "above exactly"),
            ('故带滞后之扩大从不将一构型所达者排于其上，UE10 之滞后之序排之于上恰当',
             '故带滞后之扩大从不将一构型所达者置于其上，UE10 之滞后之序置之于上恰当'),
            ("and UE10's lagged order ranks nothing there,", "and UE10's lagged order holds of no pair there,"),
            ('UE10 之滞后之序于彼无所排', 'UE10 之滞后之序于彼于任何一对皆不成立'),
            ('Widening can rank the output above the input.', 'Widening can put the output above the input.'),
            ("so UE10's lagged order ranks the output above.", "so UE10's lagged order puts the output above."),
            ('扩大可排输出于输入之上。', '扩大可置输出于输入之上。'),
            ('故 UE10 之滞后之序排输出于上。', '故 UE10 之滞后之序置输出于上。'),
            ("so UE10's lagged order ranks the input above:", "so UE10's lagged order puts the input above:"),
            ('或排输入于输出之上。', '或置输入于输出之上。'),
            ('故 UE10 之滞后之序排输入于上：', '故 UE10 之滞后之序置输入于上：'),
            ('A delivered input ranked above its output by same-offset widening',
             'A delivered input put above its output by same-offset widening'),
            ('排于其输出之上（FallTask.widens_back）', '置于其输出之上（FallTask.widens_back）'),
            ("while UE10's lagged order ranks nothing (Catalysis", "while UE10's lagged order holds of no pair (Catalysis"),
            ('而 UE10 之滞后之序无所排（', '而 UE10 之滞后之序于任何一对皆不成立（'),
            ("so a delivery's output is never ranked above its input by widening with a lag, and its lagged order there "
             "is same-offset widening, which ranks a delivered output above its input",
             "so a delivery's output is never put above its input by widening with a lag, and its lagged order there is "
             "same-offset widening, which puts a delivered output above its input"),
            ('故带滞后之扩大从不将交付之输出排于其输入之上；其滞后之序于彼即同偏移之扩大，于一见证上排交付之输出于其输入之上，'
             '于另一见证上排于其下。',
             '故带滞后之扩大从不将交付之输出置于其输入之上；其滞后之序于彼即同偏移之扩大，于一见证上置交付之输出于其输入之上，'
             '于另一见证上置于其下。')],
        'note': {'en': f'{DATE}: laws 32 and 35 to 37, two counterexamples and a related line say that widening and UE10\'s '
                       'lagged order put a delivered output above its input, or its input above it, or hold of no pair, '
                       f'not that they rank them, as the home section in 07 §2 says. {ONE_SENSE}; {PUT}. The claim is '
                       'unchanged.',
                 'zh': f'{DATE_ZH}：律 32 与 35 至 37、两个反例与一条相关说明改说扩大与 UE10 之滞后之序把交付之输出置于其输入之上、'
                       f'或把输入置于其上、或于任何一对皆不成立，而非对之排序，与 07 §2 的本节相同。{ONE_SENSE_ZH}；{PUT_ZH}。'
                       '主张不变。'},
    },
    'eventual-widening': {
        'replace': [
            ('where widening orders a pair, eventual widening agrees there',
             'where one course of a pair widens the other, eventual widening agrees there'),
            ('扩大排序一对之处', '一对进程中一者扩大另一者之处'),
            ('which rank a pair oppositely, so choosing is a premise', 'which relate a pair oppositely, so choosing is a '
             'premise'),
            ('二者对一对排序相反', '二者于一对方向相反'),
            ('and widening with a lag and eventual widening rank a pair oppositely.',
             'and widening with a lag and eventual widening hold of a pair in opposite directions.'),
            ('而带滞后的扩大与最终扩大对一对进程排序相反。', '而带滞后的扩大与最终扩大于一对进程方向相反。'),
            ('so it ranks a range that keeps widening above one wider now that starts a course only with a lag, and not '
             'every such pair.', REACH_LAG),
            ('故仅带滞后时把持续扩大之范围排在起进程且当下更宽者之上，且非每一此种对。', REACH_LAG_ZH)],
        'note': {'en': f'{DATE}: law 2 says where one course of a pair widens the other, not where widening orders it, as '
                       'the home section in 07 §2 says; the next step and two related lines say that widening with a lag '
                       'and eventual widening relate a pair oppositely, not that they rank it, and what the lagged order on '
                       f'what a course keeps reachable puts above. {ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：律 2 改说一对进程中一者扩大另一者之处，而非扩大排序一对之处，与 07 §2 的本节相同；下一步与两条'
                       '相关说明改说带滞后的扩大与最终扩大于一对进程方向相反，及进程保持可达者之滞后之序把何者置于何者之上。'
                       f'{ONE_SENSE_ZH}。主张不变。'},
    },
    'the-run-classes-and-widening': {
        'replace': [
            ("Arising is where a part's place in the order begins.",
             'Arising is where it begins how a part changes what can form.'),
            ('生起是一个部分在次序中位置的开始。', '生起是一个部分如何改变能形成者的开始。'),
            ('The arising class does not decide the order:', 'The arising class does not decide how a part changes what '
             'can form:'),
            ('生起之类不定次序：', '生起之类不定部分如何改变能形成者：'),
            ('The order on what can form and when a part opens nothing.',
             'How a part changes what can form, and when it opens nothing.'),
            ('能形成者上的次序，及部分何时不打开什么。', '部分如何改变能形成者，及部分何时不打开什么。'),
            ('the run classes are related to that order here.', 'the run classes are related to it here.'),
            ('这里整段的类与这一次序相关。', '这里整段的类与之相关。'),
            ('related to the order by these laws', 'related to how a part changes what can form by these laws'),
            ('经这些规律与次序相关', '经这些规律与部分如何改变能形成者相关')],
        'note': {'en': f'{DATE}: laws 5 and 6, the dependency\'s output, a related line and the correspondence speak of how '
                       'a part changes what can form, not of its place in an order, as the home section in 07 §2 now says. '
                       f'{ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：律 5 与 6、依赖之输出、一条相关说明与对应改说部分如何改变能形成者，而非其在次序中之位置，与 07 §2 '
                       f'的本节现今所说相同。{ONE_SENSE_ZH}。主张不变。'},
    },
    'what-can-be-born-next': {
        'replace': [
            ('Read on what continues the order reverses;', 'Read on what continues the inclusion reverses;'),
            ('扩大不增相续。读于相续则序反转', '扩大不增相续。读于相续则包含反转'),
            ('one ranks the antichain above the chain, the other the chain above the antichain',
             'one puts the antichain above the chain, the other the chain above the antichain'),
            ('where C ranks no two courses; ordering them', 'where C ranks no two courses from the empty set; ordering them'),
            ('C 于此不排任何二历程', 'C 于此不排任何二自空集起之历程'),
            ('The antichain and the chain rank each other on the two readings',
             'The antichain and the chain each widen the other on one of the two readings'),
            ('反链与链于二读上互为高下', '反链与链各于二读之一上扩大对方')],
        'note': {'en': f'{DATE}: the statement says that read on what continues the inclusion reverses, not the order; law '
                       '16 and a counterexample say that the two widenings put the antichain and the chain above each '
                       'other, not that they rank them; what the record does not show names the start C\'s verdict on both '
                       'readings together needs, from the empty set (Starts.not_rangeWidens_formsOrContinues_needs_starts). '
                       f'{ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述改说读于相续则包含反转，而非序反转；律 16 与一个反例改说二种扩大把反链与链互置于对方之上，而非'
                       '对之排序；本记录未表明者写明 C 于兼读二者时之判定所需之起点，即自空集起'
                       f'（Starts.not_rangeWidens_formsOrContinues_needs_starts）。{ONE_SENSE_ZH}。主张不变。'},
    },
    'comparing-two-courses-on-what-they-admit': {
        'replace': [
            ('the tail order ranks the course ahead above the early one', 'the tail order puts the course ahead above the '
             'early one'),
            ('widening or widening with a lag never ranks a course above one that admitted what it never admits.',
             'widening or widening with a lag never puts a course above one that admitted what it never admits.'),
            ('尾序把领先之进程排在早先之进程之上', '尾序把领先之进程置于早先之进程之上'),
            ('从不把一进程排在纳过其从不纳者之进程之上', '从不把一进程置于纳过其从不纳者之进程之上'),
            ('and the tail order, rank a course above another only where it keeps what the other keeps;',
             'and the tail order, put a course above another only where it keeps what the other keeps;'),
            ('只在此条件下把一进程排在另一进程之上', '只在此条件下把一进程置于另一进程之上'),
            ('its order ranks the course admitting', 'its order puts the course admitting'),
            ('the other orders do not rank them so.', 'the other orders do not put them so.'),
            ('并于第 0 步纳构成 1 的进程，排在每步皆纳', '并于第 0 步纳构成 1 的进程，置于每步皆纳'),
            ('其余诸序不如此排。', '其余诸序不如此置。'),
            ('widening with a lag ranks by what each keeps', 'widening with a lag compares by what each keeps'),
            ('按各自随时间保有对方所纳者而排序', '按各自随时间保有对方所纳者而比较'),
            ('can rank a course above one keeping a formation it drops', 'can put a course above one keeping a formation '
             'it drops'),
            ('可把一进程排在保有其所舍构成者之上', '可把一进程置于保有其所舍构成者之上'),
            ('ranks a course above one that keeps a formation it drops', 'puts a course above one that keeps a formation '
             'it drops'),
            ('把一进程排在保有其所舍构成者之上（Each', '把一进程置于保有其所舍构成者之上（Each'),
            ('the two rank a pair oppositely.', 'the two hold of a pair in opposite directions.'),
            ('二者对一对进程排序相反。', '二者于一对进程方向相反。')],
        'note': {'en': f'{DATE}: the last clause of the statement says that widening with a lag and eventual widening relate '
                       'one pair oppositely, not that they rank it; laws 19 to 21, two items it does not show, a '
                       'counterexample and a related line say what widening with a lag, the tail order and the order of a '
                       f'lag for each admission put above, as the home section in 07 §2 now says. {ONE_SENSE}; {PUT}. The '
                       'claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述末句改说带滞后的扩大与最终扩大于一对进程方向相反，而非对之排序；律 19 至 21、两条未表明者、一个'
                       '反例与一条相关说明改说带滞后的扩大、尾序与每次所纳各自之滞后的序把何者置于何者之上，与 07 §2 的本节现今所说'
                       f'相同。{ONE_SENSE_ZH}；{PUT_ZH}。主张不变。'},
    },
    'stepwise-law-of-easing': {
        'replace': [
            ('so restraint that takes within what it gives extends overdraw for any number of drawers under the stepwise '
             'reading too, and C ranks it above.',
             'so restraint taking within what it gives extends overdraw for any number of drawers where it includes an '
             'event overdraw withholds, and C ranks it above.'),
            ('所以所取不超过所给的节制在逐步读法下也对任意多个汲取者扩展过度汲取，C 把它排在其上。',
             '所以所取不超过所给的节制对任意多个汲取者扩展过度汲取，在它记入过度汲取扣下的某个事件之处，C 把它排在其上。'),
            ('the laws rank courses under each reading.', 'the laws give which course extends which under each reading, '
             'and C ranks only those pairs.'),
            ('这些规律只在各读法下给进程排序。', '这些规律只在各读法下给出何者扩展何者，C 只对这些对排序。'),
            ('restraint that keeps taking part ranks above overdraw under it too.', RESTRAINT_REL),
            ('仍参与的节制在它之下也排在过度汲取之上。', RESTRAINT_REL_ZH)],
        'note': {'en': f'{DATE}: the statement says that restraint extends overdraw exactly where it includes an event '
                       'overdraw withholds, law 4\'s condition, which needs no premise, and that C ranks it above, as its '
                       'home row in 07 §5 says; what it does not show and a related line say likewise. '
                       f'{ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述改说节制扩展过度汲取，恰在它记入过度汲取扣下的某个事件之处（律 4 之条件，不需前提），且 C 把它'
                       f'排在其上，与 07 §5 的本节一行相同；一条未表明者与一条相关说明亦然。{ONE_SENSE_ZH}。主张不变。'},
    },
    'relation-level-law-of-easing': {
        'replace': [
            ('restraint that lets no level fall and keeps taking part ranks above overdraw for any number of drawers '
             'under the relation-level reading too.',
             'restraint that lets no level fall and keeps taking part extends overdraw for any number of drawers exactly '
             'where it includes a relation overdraw withholds, and C ranks it above.'),
            ('不让任何水平下降且仍参与的节制，在关系层读法下也对任意多个汲取者排在过度汲取之上。',
             '不让任何水平下降且仍参与的节制对任意多个汲取者扩展过度汲取，恰在它记入过度汲取扣下的某个关系之处，C 把它排在其上。'),
            ('so this law does not rank it.', 'so this law does not show that it extends overdraw.'),
            ('故本律不对它排序。', '故本律不表明它扩展过度汲取。')],
        'note': {'en': f'{DATE}: the statement says that restraint extends overdraw exactly where it includes a relation '
                       'overdraw withholds, law 5\'s condition, which needs no premise, and that C ranks it above, as its '
                       'home row in 07 §5 says; what it does not show says likewise. '
                       f'{ONE_SENSE}. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：陈述改说节制扩展过度汲取，恰在它记入过度汲取扣下的某个关系之处（律 5 之条件，不需前提），且 C 把它'
                       f'排在其上，与 07 §5 的本节一行相同；一条未表明者亦然。{ONE_SENSE_ZH}。主张不变。'},
    },
    'ranking-under-readings': {
        'replace': [
            ('restraint that takes within what it gives ranks above overdraw for any number of drawers under the stepwise '
             'reading.',
             'restraint that takes within what it gives extends overdraw for any number of drawers where it includes an '
             'event overdraw withholds, and C ranks it above.'),
            ('所取不超过所给的节制在逐步读法下对任意多个汲取者排在过度汲取之上。',
             '所取不超过所给的节制对任意多个汲取者扩展过度汲取，恰在它记入过度汲取扣下的某个事件之处，C 把它排在其上。'),
            ('restraint that keeps taking part ranks above overdraw under it too.', RESTRAINT_REL),
            ('仍参与的节制在它之下也排在过度汲取之上。', RESTRAINT_REL_ZH)],
        'note': {'en': f'{DATE}: two related lines follow the restated statements of the stepwise and relation-level laws '
                       'of easing: restraint extends overdraw exactly where it includes an event, or a relation, overdraw '
                       'withholds, and C ranks it above. The claim is unchanged.',
                 'zh': f'{DATE_ZH}：两条相关说明随逐步与关系层缓和之律重述后的陈述：节制扩展过度汲取，恰在它记入过度汲取扣下的某个事件'
                       '或关系之处，C 把它排在其上。主张不变。'},
    },
    'what-keeping-widening-needs': {
        'replace': [
            ('全生成 at two grains and renewal without end hold', '全生成 at two orders of grain and renewal without end hold'),
            ('于种类接力上，两种粒度之全生成', '于种类接力上，粒度两阶之全生成'),
            ('so it ranks a range that keeps widening above one wider now that starts a course only with a lag, and not '
             'every such pair.', REACH_LAG),
            ('故仅带滞后时把持续扩大之范围排在起进程且当下更宽者之上，且非每一此种对。', REACH_LAG_ZH)],
        'note': {'en': f'{DATE}: in what the record does not show, "全生成 at two orders" reads "at two orders of grain", '
                       'the phrase of 02 §1\'s law of orders: one 全生成 already reads two grains, and the relay\'s law gives '
                       'it at orders 0 and 1 over three; under the glossary\'s one sense, order alone says which course is '
                       'better. A related line says what the lagged order on what a course keeps reachable puts above. '
                       'The claim is unchanged.',
                 'zh': f'{DATE_ZH}：在本记录未表明者中，“二阶之全生成”改为“粒度两阶之全生成”，即 02 §1 阶之律之语：一个全生成已读两种'
                       '粒度，接力之律在三种粒度上给出第 0 阶与第 1 阶；按词汇表的单一词义，单说次序即说哪个进程更好。一条相关说明改说'
                       '进程保持可达者之滞后之序把何者置于何者之上。主张不变。'},
    },
    'whole-and-regions-and-bounded-centers': {
        'replace': [('"en": "The whole first and the free rider\'s loss."',
                     '"en": "Retaining in the whole and in every region, and the free rider\'s loss."'),
                    ('"zh": "整体优先与搭便车者的失去。"', '"zh": "整体与各区域中的保留，与搭便车者的失去。"')],
        'append': {'en': ' The input of its dependency on significance-retained-within-margin, which still said "the '
                         'whole first", follows the title.',
                   'zh': '其对 significance-retained-within-margin 之依赖的输入原仍作“整体优先”，今随标题。'},
    },
    'widening-as-what-every-positive-weighting-ranks': {
        'replace': [('"C as the order every weighting shares"', '"C as the order every positive weighting shares"')],
        'append': {'en': ' Its alias "C as the order every weighting shares" says "every positive weighting"; the former '
                         'title stays an alias for search.',
                   'zh': '其别名“C as the order every weighting shares”改作“every positive weighting”；旧标题留作检索之别名。'},
    },
}


def once(text, old, new, where):
    n = text.count(old)
    if n == 1:
        return text.replace(old, new), 1
    if n == 0 and new in text:
        return text, 0
    raise SystemExit(f'{where}: {n} occurrences of {old[:70]!r}')


def cd_note(history):
    notes = [h for h in history if h.get('en', '').startswith(DATE)]
    assert len(notes) <= 1, notes
    return notes[0] if notes else None


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
        for old, new in spec['replace']:
            text, k = once(text, old, new, rid)
            changed += k
        d = json.loads(text)
        note = cd_note(d.setdefault('history', []))
        if 'note' in spec:
            if note is None:
                d['history'].append(dict(spec['note']))
            else:
                note.update(spec['note'])
            changed += 1
        if 'append' in spec and spec['append']['en'] not in note['en']:
            # before the note's last sentence, which says the claim is unchanged
            end, end_zh = ' The claim is unchanged.', '主张不变。'
            assert note['en'].endswith(end) and note['zh'].endswith(end_zh), rid
            note['en'] = note['en'][:-len(end)] + spec['append']['en'] + end
            note['zh'] = note['zh'][:-len(end_zh)] + spec['append']['zh'] + end_zh
            changed += 1
        open(p, 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    # every CD history note opens in Chinese in its Chinese text, as the records' other notes do
    import glob
    for p in sorted(glob.glob(f'{root}/{REC}*.json')):
        d = json.load(open(p, encoding='utf-8'))
        note = cd_note(d.get('history', []))
        if note and note.get('zh', '').startswith(DATE):
            note['zh'] = DATE_ZH + note['zh'][len(DATE):]
            open(p, 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
            changed += 1
    print(changed, 'changes applied')


if __name__ == '__main__':
    main()
