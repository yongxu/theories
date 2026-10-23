#!/usr/bin/env python3
"""IV3: write the records self-concern-through-dependence and what-self-concern-alone-ranks. No existing record changes
here: the records that cite Becoming.Weightings drift only by bytes the module gained, and repoint.sh re-points them.
usage (from the checkout root, after apply_text.py): python3 -B make_records.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
REVIEW = RF + 'BECOMING-SIGNIFICANCE-REVIEW.md'
CHOICES = RF + 'DELEGATED-CHOICES.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
STEP = 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
WORDS = 'sources/15-codex-theory-conversations/2026-10-23-one-system.md'
MODULE = 'Becoming.Weightings'
SOURCE = f'{PKG}/Becoming/Weightings.lean'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
assert f'## {N}. Self-concern through dependence (IV3)' in (ROOT / STUDY).read_text()
assert '<a id="dependence-check"></a>' in (ROOT / REVIEW).read_text()
assert '<a id="d64-the-readings-of-self-concern-through-dependence"></a>' in (ROOT / CHOICES).read_text()
assert '### 4.4 Where the centers depend on one another' in (ROOT / STEP).read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE = '23 October 2026'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


found = [m for m in R['modules'] if m['module'] == MODULE]
assert len(found) == 1
assert not any(found[0]['axiom_dependencies'].values())
HAVE = {d['name'] for d in found[0]['declarations']}
assert R['source_sha256'][MODULE] == sha(SOURCE)


def need(names):
    for n in names:
        assert n in HAVE, n
    return names


def t(en, zh):
    return {'en': en, 'zh': zh}


B, W, CP = 'Becoming.', 'Becoming.Weighting.', 'Becoming.Copies.'
SHARED = need([B + n for n in ['CentersWithin', 'withinClosure_iff_of_centersWithin',
                               'ownClosure_standpointInvariant_iff_centersWithin',
                               'selfAscribed_iff_withinSome_iff_centersWithin']])
COMMON = need([B + 'Flow.' + n for n in ['centersWithin_feeding_of_common', 'centersWithin_influence_of_common',
                                         'ownClosure_feeding_invariant_of_common',
                                         'ownClosure_influence_invariant_of_common']])
NEED = need([B + n for n in ['Needs', 'Needs.refl', 'Needs.trans', 'withinClosure_needs_iff', 'forced_needs_iff']])
ONLY = need([B + n for n in ['NeedsSome', 'CarriesAlone', 'needs_iff_only', 'forced_member_iff_only']])
COPIES = need([CP + n for n in ['Part', 'copies', 'possible', 'withFirst', 'withSecond', 'user_not_copy', 'needsSome',
                                'carriesAlone', 'two_copies']])
OWN = need([W + n for n in ['AddsOwn', 'IncreasingInOwn', 'increasingInOwn_of_increasing',
                            'increasingInOwn_iff_increasing']])
SHARE = need([W + n for n in ['widensOwn_iff_every_increasingInOwn', 'every_increasingInOwn_iff_includes',
                              'some_increasingInOwn_reverses']])
ENDED = need([W + n for n in ['includes_of_ended', 'ended_below']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    f'significance review\'s dependence check. Author review in study section {N}; not independently reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 {N} 节；未经独立审查。')


def references(declarations):
    return [
        {'path': SOURCE, 'role': 'proof', 'declarations': sorted(declarations), 'sha256': sha(SOURCE)},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
        {'path': CHOICES, 'role': 'integration', 'sha256': sha(CHOICES)},
        {'path': STEP, 'role': 'statement', 'sha256': sha(STEP)},
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
        {'path': WORDS, 'role': 'provenance', 'sha256': sha(WORDS)},
    ]


BINDING = {'source': SOURCE, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{MODULE}',
           'success_pointer': '/status', 'success_value': 'passed'}

scope = {
    'schema_version': 2,
    'id': 'self-concern-through-dependence',
    'title': t('Self-concern through dependence', '经由依存的自我关切'),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': t('Held de se, self-concern is the same from every standpoint exactly where the centers lie within one '
                   'another\'s closures, as centers sharing one condition do; drawn along need, it reaches a copy of what '
                   'it needs exactly where that copy is the only one.',
                   '从己地持有，自我关切恰在诸中心彼此位于对方闭包之内处对每个立场都相同，共有一个条件的诸中心即如此；沿“所需”来画，它恰在'
                   '某个副本是唯一者处达到其所需的该副本。'),
    'laws': [
        {**t('Held de se, the presupposition about the own closure along a relation is standpoint-invariant, and the de se '
             'and de dicto readings give significance alike, exactly where every center lies within every center\'s '
             'closure; the centers then have one closure, and the whole need not lie within it.',
             '从己地持有，关于沿一个关系的自身闭包的预设对立场不变，且从己与从言两种读法给出相同的意义，恰在每个中心都位于每个中心的闭包'
             '之内处；诸中心于是有同一个闭包，而整体不必在其中。'), 'declarations': SHARED},
        {**t('Centers that at one step take part, require one condition and give to it lie within one another\'s feeding '
             'closures; centers that depend on one condition and exchange with it lie within one another\'s influence '
             'closures. So self-concern held de se along feeding, or along being affected, is one from all of them.',
             '在某一步都在场、都需要同一个条件并都给予它的诸中心，彼此位于对方的供养闭包之内；都依存于同一个条件并与之交换的诸中心，彼此'
             '位于对方的影响闭包之内。所以沿供养或沿受影响从己持有的自我关切，从它们每一个看都相同。'), 'declarations': COMMON},
        {**t('Over possible courses, a formation needs another where the other continues on every course on which it does. '
             'Need is its own closure, so drawn along need a standpoint\'s presupposition reaches exactly what its '
             'continuation needs.',
             '在可能的进程上，一个构成需要另一个，指在它延续的每条进程上另一个都延续。“所需”即其自身的闭包，所以沿“所需”来画，立场的预设'
             '恰达到其延续所需者。'), 'declarations': NEED},
        {**t('Where a formation needs some member of a class and each member can carry its continuation alone, it needs a '
             'member exactly where that member is the only one, and the presupposition drawn along need reaches it exactly '
             'then. Witness: with two copies the user needs some copy and neither of the two.',
             '一个构成需要某类中的某个成员、且每个成员都能单独承载其延续时，它恰在某成员是唯一者时需要该成员，沿“所需”来画的预设也恰在此时'
             '达到它。见证：有两个副本时，使用者需要某个副本，而两个都不需要。'), 'declarations': ONLY + COPIES},
    ],
    'hypotheses': [t(
        'No axiom. Standpoints and formations as types, each standpoint\'s center given as a function; the relation a self '
        'is drawn along supplied, its base instances feeding and being affected; possible courses a supplied predicate on '
        'markings of the formations that continue; the presupposition a hypothesis of the laws it appears in, never '
        'asserted.',
        '不加公理。立场与构成为类型，每个立场的中心由一个函数给出；画自我所沿的关系是给定的，其基底实例为供养与受影响；可能的进程是对'
        '“哪些构成延续”之标记的给定谓词；预设只作为出现它的规律的假设，从不断言。')],
    'does_not_show': [
        {**t('The step of invariance where it is still needed: what lies beyond every center\'s closure, and each center '
             'counting from another\'s standpoint beyond its part as a condition.',
             '不变之步仍被需要之处：位于每个中心闭包之外者，以及每个中心在作为条件之外、从他者立场算数。'), 'kind': 'non-implication'},
        {**t('That actual centers depend on one another, or that a condition they all need has no second copy: both are '
             'empirical.', '实际的诸中心彼此依存，或它们都需要的某个条件没有第二个副本：二者都是经验问题。'), 'kind': 'correspondence'},
        {**t('That the self is drawn along feeding or need rather than a narrower relation: that reading is argued, and the '
             'de se question stays open outside the common closure.',
             '自我沿供养或“所需”来画，而不是沿更窄的关系：这一读法是论证出来的；在共同闭包之外，从己问题仍未定。'),
         'kind': 'non-implication'},
        {**t('What the class\'s continuation is owed when there are copies: the law says which members are reached, and no '
             'significance of a single formation states the class.',
             '有多个副本时，类的延续应得什么：此律只说哪些成员被达到，单个构成的意义不陈述类。'), 'kind': 'scope',
         'witness': CP + 'two_copies'},
        {**t('That along being affected the shared scope carries the means-end warrant: what affects a continuation need not '
             'be needed by it.', '沿受影响时共有的范围带有手段与目的之依据：影响一个延续者，未必为它所需。'), 'kind': 'scope'},
        {**t('Any order: scope fixes whose losses count; ranking is left to C or to self-concern\'s monotonicity.',
             '任何次序：范围只定谁的损失算数；排序留给 C 或自我关切的单调性。'), 'kind': 'non-implication'},
    ],
    'counterexamples': [
        {'path': SOURCE, 'detail': t(
            'Copies: the user continues with the first copy alone on one possible course and with the second alone on the '
            'other, so it needs some copy and neither copy (Copies.two_copies).',
            'Copies：在一条可能的进程上使用者只与第一个副本一同延续，在另一条上只与第二个，故它需要某个副本，而两个都不需要'
            '（Copies.two_copies）。')},
        {'path': SOURCE, 'detail': t(
            'Divided: two standpoints, each its own center along the empty relation; their closures differ, and the de se '
            'and de dicto readings part (Divided.selfAscribed_not_invariant).',
            'Divided：沿空关系各自为中心的两个立场；其闭包不同，从己与从言两种读法分开（Divided.selfAscribed_not_invariant）。')},
    ],
    'standard_boundaries': ['significance-related-not-asserted', 'no-ethical-premise', 'conditional-not-universal',
                            'no-definition-by-verdict', 'names-provisional', 'formal-not-empirical'],
    'validation_scope': SCOPE,
    'next_delta': t('A predicate of possible courses read off a web, so that need and copies are stated on the base; graded '
                    'need, under which a copy is needed in degree and the class\'s continuation is stated; an independent '
                    'review.',
                    '从依存网读出可能进程的谓词，使“所需”与副本在基底上陈述；分级的“所需”，使副本按程度被需要、类的延续得以陈述；独立审查。'),
    'correspondence': t(
        'The ecological Self (Næss 1987): self-concern for a self drawn widely is care for all; here only the centers need '
        'depend on one another. The convergence hypothesis (Norton 1984, 1991) and its critics (Steverson 1995; Westra '
        '1997): anthropocentric and nonanthropocentric policy converge within what humans need and part beyond it; here '
        'the de se and de dicto readings agree within the common closure. Transmission of reasons to necessary means '
        '(Kiesewetter 2015) against facilitative means (Raz 2005): need against feeding, parting exactly at copies. '
        'Ecological redundancy (Walker 1992, 1995). Reading (the AI\'s, D64): human beings now plausibly lie within one '
        'another\'s feeding closures through one atmosphere, one biosphere and one economy.',
        '生态的大我（Næss 1987）：为画得足够宽的自我而有的自我关切即对一切的关切；此处只需诸中心彼此依存。趋同假说（Norton 1984、'
        '1991）及其批评（Steverson 1995；Westra 1997）：人类中心与非人类中心的政策在人所需者之内趋同、在其外分开；此处从己与从言两种'
        '读法在共同闭包之内一致。理由向必要手段传递（Kiesewetter 2015）与向促成手段传递（Raz 2005）：“所需”与供养，恰在副本处分开。'
        '生态冗余（Walker 1992、1995）。解读（AI 的，D64）：经由同一个大气、同一个生物圈与同一个经济，人类如今大概彼此位于对方的'
        '供养闭包之内。'),
    'canonical_source': SOURCE,
    'aliases': ['self-concern through dependence', '经由依存的自我关切', B + 'ownClosure_standpointInvariant_iff_centersWithin',
                B + 'selfAscribed_iff_withinSome_iff_centersWithin', B + 'forced_member_iff_only'],
    'dependencies': [
        {'id': 'what-the-step-across-standpoints-reaches', 'relation': 'formal-reuse',
         'detail': t('Reuses the own closure held de se and where the de se and de dicto readings agree '
                     '(ownClosure_standpointInvariant_iff, selfAscribed_iff_withinSome) and what a standpoint\'s own '
                     'presupposition forces (forced_iff_within).',
                     '复用从己持有的自身闭包、从己与从言两种读法一致之处（ownClosure_standpointInvariant_iff、'
                     'selfAscribed_iff_withinSome）以及立场自身的预设所迫使者（forced_iff_within）。'),
         'interface': {'output': t('The de se readings agree where whatever lies within one center\'s closure lies within '
                                   'every center\'s; a presupposition at a closure forces exactly the closure.',
                                   '凡在一个中心闭包之内者都在每个中心闭包之内处，从己读法一致；闭包处的预设恰迫使该闭包。'),
                       'input': t('Centers within one another\'s closures; the closure under need.',
                                  '彼此位于对方闭包之内的诸中心；“所需”之下的闭包。'),
                       'conditions': t('None.', '无。'),
                       'evidence': SOURCE}},
        {'id': 'levels-of-closure', 'relation': 'formal-reuse',
         'detail': t('Reuses being affected and being fed from (Flow.AffectedBy, Flow.FedFrom) and their closures.',
                     '复用受影响与受供养（Flow.AffectedBy、Flow.FedFrom）及其闭包。'),
         'interface': {'output': t('The influence and feeding closures of a formation on a flow.',
                                   '流上一个构成的影响闭包与供养闭包。'),
                       'input': t('Centers sharing one condition within one another\'s closures.',
                                  '共有一个条件、彼此位于对方闭包之内的诸中心。'),
                       'conditions': t('The common condition depended on and exchanged with, or required and given to at '
                                       'one step.', '共同条件被依存并被交换，或在某一步被需要并被给予。'),
                       'evidence': SOURCE}},
    ],
    'related': [
        {'id': 'mutual-dependence-and-its-pace', 'detail': t(
            'The whole-world case: on a mutually dependent or mutually fed flow, significance bounded by each center\'s '
            'closure is the continuation condition; here only the centers need depend on one another.',
            '整体的情形：在彼此依存或彼此供养的流上，以各中心闭包为界的意义即延续条件；此处只需诸中心彼此依存。')},
        {'id': 'presupposition-scopes', 'detail': t(
            'The two scopes of the presupposition; here the narrow scope, held de se, is the wide one within the centers\' '
            'common closure.', '预设的两种范围；此处在诸中心的共同闭包之内，从己持有的窄范围即宽范围。')},
        {'id': 'loss-beyond-a-region', 'detail': t(
            'What lies beyond every center\'s closure, as Clearing\'s dweller does, is left to the step.',
            '位于每个中心闭包之外者（如 Clearing 中的居者）留给那一步。')},
        {'id': 'what-self-concern-alone-ranks', 'detail': t(
            'The same route\'s order: what self-concern alone ranks, given the scope fixed here.',
            '同一路线上的序：在此处所定的范围下，单凭自我关切排出什么。')},
    ],
    'references': references(SHARED + COMMON + NEED + ONLY + COPIES),
    'proof_bindings': [BINDING],
    'history': [t(f'{DATE}: added (IV3): the route through dependence, the relation a self is drawn along read as one its '
                  f'continuation is carried along; the de se and de dicto readings agree exactly where the centers lie within '
                  f'one another\'s closures; need and copies; after a literature check (significance review, dependence '
                  f'check); study section {N}.',
                  f'2026年10月23日：新增（IV3）：经由依存的路线，把画自我所沿的关系读作其延续所凭借者；从己与从言两种读法恰在诸中心彼此'
                  f'位于对方闭包之内处一致；“所需”与副本；附文献核查（显著性审查“依存”核查）；研究第 {N} 节。')],
}

order = {
    'schema_version': 2,
    'id': 'what-self-concern-alone-ranks',
    'title': t('What self-concern alone ranks', '单凭自我关切排出什么'),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': t('An order that ranks higher every widening adding to its own continuation ranks a course that adds to it '
                   'above another exactly where the other keeps nothing beyond it; so the ending of what everything needs '
                   'is ranked below from every standpoint.',
                   '把每个增加其自身延续的扩大都排得更高的次序，恰在另一条进程不保住任何超出者时，把增加其延续的进程排在上面；所以一切所需者'
                   '的终结从每个立场都被排在下面。'),
    'laws': [
        {**t('An order is increasing in its own continuation when it ranks higher every widening that adds to the items its '
             'continuation marks. Every order increasing in admission is one, and the two coincide exactly where its own '
             'continuation is every listed item: there self-concern\'s monotonicity is C\'s premise.',
             '一个次序在其自身延续上递增，指它把每个增加其延续所标记之项的扩大都排得更高。每个随接纳递增的次序都是如此，而二者恰在其自身'
             '延续即每个所列项时重合：在那里，自我关切的单调性就是 C 的前提。'), 'declarations': OWN},
        {**t('What every such order shares is exactly the widenings that add to its own continuation. Where one course adds '
             'to it, every such order ranks it above the other exactly where the other keeps nothing beyond it; where the '
             'other keeps an item beyond, some positive weighting, such an order, ranks the other higher.',
             '每个这样的次序所共有者，恰是增加其自身延续的扩大。一条进程增加其延续时，每个这样的次序恰在另一条不保住任何超出者时把前者排在'
             '上面；另一条保住某个超出的项时，某个正的加权（也是这样的次序）把另一条排得更高。'), 'declarations': SHARE},
        {**t('A course that admits nothing from an ending on, and agrees with another before it, keeps nothing beyond it; so '
             'from every standpoint whose own continuation the other adds to, every order increasing in its own '
             'continuation ranks the ending below.',
             '自某一终结起什么也不接纳、此前与另一条一致的进程，不保住任何超出另一条者；所以从另一条增加其自身延续的每个立场看，每个在自身'
             '延续上递增的次序都把这一终结排在下面。'), 'declarations': ENDED},
    ],
    'hypotheses': [t(
        'No axiom. A finite listing of items; two-valued admission; an order a relation on courses, not assumed complete, '
        'transitive or additive; a standpoint\'s own continuation a supplied marking of items, and the ending a supplied '
        'marking of the items from the ending on.',
        '不加公理。项的有限列举；二值接纳；次序是进程上的关系，不设其完备、传递或可加；立场的自身延续是对项的给定标记，终结是对自终结'
        '起各项的给定标记。')],
    'does_not_show': [
        {**t('That a standpoint\'s order is increasing in its own continuation: a premise, weaker than C\'s.',
             '立场的次序在其自身延续上递增：这是前提，比 C 的前提弱。'), 'kind': 'non-implication'},
        {**t('Comparisons in which the other course keeps something beyond, as a copy continuing without the ended '
             'condition does: some such order ranks them either way.',
             '另一条进程保住某个超出者的比较，如不靠所终结的条件而延续的副本：某个这样的次序可以把它们排成任一方向。'), 'kind': 'scope',
         'witness': W + 'some_increasingInOwn_reverses'},
        {**t('That the dynamics give a course admitting nothing from an ending on: coupled groups ending together gives it '
             'where every formation depends on the coupled family, joined here by argument, not by one theorem.',
             '动力学给出自某一终结起什么也不接纳的进程：诸条件耦合的群体一同终结，在每个构成都依存于该耦合族处给出它；此处以论证而非'
             '单一定理连接。'), 'kind': 'correspondence'},
        {**t('That a risk of ending recurring along one run, with nothing to average over, comes to an ending: not '
             'formalized here.', '沿一条运行反复出现、无可平均的终结风险终将导致终结：此处未形式化。'), 'kind': 'scope'},
        {**t('That widening is better, or that a ranking obliges anyone: an order is from a standpoint.',
             '扩大更好，或某个排序约束任何人：次序是从一个立场而言的。'), 'kind': 'non-implication'},
    ],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'decidability', 'no-definition-by-verdict',
                            'names-provisional', 'formal-not-empirical'],
    'validation_scope': SCOPE,
    'next_delta': t('The ending stated on the base in one theorem with the dynamics of coupled ending; graded orders, how much '
                    'a standpoint\'s own continuation weighs, under which comparisons near an ending are decided; an '
                    'independent review.',
                    '在基底上以一个定理把终结与耦合终结的动力学连起来陈述；分级的次序（立场自身延续的权重多少），以裁定终结附近的比较；独立审查。'),
    'correspondence': t(
        'Monotonicity in the opportunity-set literature, relocated to one\'s own continuation. Jonas (1979): the existence '
        'of the whole is never to be staked; here a condition everyone needs, with no second copy, has its ending ranked '
        'below by every standpoint\'s self-concern, with no impartial premise. Ergodicity (Peters 2019) and systemic ruin '
        '(Taleb and others 2014): with one copy there is no average over copies; not formalized here. Reading (the '
        'AI\'s, D64): an order increasing in its own continuation is the monotonicity of a self-concerned standpoint.',
        '机会集文献中的单调性，移到自身的延续上。Jonas（1979）：整体的存在绝不可作赌注；此处一个人人所需、无第二副本的条件，其终结由每个'
        '立场的自我关切排在下面，不用任何公正的前提。遍历性（Peters 2019）与系统性毁灭（Taleb 等 2014）：只有一个副本时，没有跨副本的平均；'
        '此处未形式化。解读（AI 的，D64）：在自身延续上递增的次序，是有自我关切之立场的单调性。'),
    'canonical_source': SOURCE,
    'aliases': ['what self-concern alone ranks', '单凭自我关切排出什么', W + 'IncreasingInOwn',
                W + 'every_increasingInOwn_iff_includes', W + 'ended_below'],
    'dependencies': [
        {'id': 'widening-as-what-every-weighting-ranks', 'relation': 'formal-reuse',
         'detail': t('Reuses widening on listed items and orders increasing in admission (WidensOn, Increasing, '
                     'increasing_ranks) and the positive weighting that ranks a course admitting more higher (outweighs).',
                     '复用所列项上的扩大与随接纳递增的次序（WidensOn、Increasing、increasing_ranks），以及把多接纳者排得更高的正加权'
                     '（outweighs）。'),
         'interface': {'output': t('Widening, orders increasing in admission, and a positive weighting deciding a mixed pair.',
                                   '扩大、随接纳递增的次序，以及裁定混合一对的正加权。'),
                       'input': t('Orders increasing in their own continuation, a weaker class.',
                                  '在自身延续上递增的次序，一个更弱的类。'),
                       'conditions': t('Finite listing, two-valued admission.', '有限列举，二值接纳。'),
                       'evidence': SOURCE}},
    ],
    'related': [
        {'id': 'groups-whose-conditions-are-coupled', 'detail': t(
            'The dynamic half: groups whose conditions are coupled end together, nothing selected among them, which gives '
            'the course admitting nothing from the ending on.',
            '动力学的一半：诸条件耦合的群体一同终结，其间无所选择，这给出自终结起什么也不接纳的进程。')},
        {'id': 'confined-rise-within-a-whole', 'detail': t(
            'After a family of conditions is drawn beyond its renewal only what depended on none of it leaves descendants: '
            'an independent copy, which makes the comparison mixed.',
            '一族条件被汲取超出其更新之后，只有不依存于其中任何一个者留下后代：独立的副本，它使比较成为混合的。')},
        {'id': 'self-concern-through-dependence', 'detail': t(
            'The same route\'s scope, which this order takes as fixed.', '同一路线上的范围，此序以之为定。')},
    ],
    'references': references(OWN + SHARE + ENDED),
    'proof_bindings': [BINDING],
    'history': [t(f'{DATE}: added (IV3): what an order increasing only in its own continuation ranks, the ending of what '
                  f'everything needs below from every standpoint, an independent copy making the comparison mixed, and C\'s '
                  f'premise where its own continuation is everything; after a literature check (significance review, '
                  f'dependence check); study section {N}.',
                  f'2026年10月23日：新增（IV3）：只在自身延续上递增的次序排出什么：一切所需者的终结从每个立场都被排在下面，独立的副本使'
                  f'比较成为混合的，其自身延续为一切时即 C 的前提；附文献核查（显著性审查“依存”核查）；研究第 {N} 节。')],
}

for record in (scope, order):
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
    print('wrote', record['id'])
