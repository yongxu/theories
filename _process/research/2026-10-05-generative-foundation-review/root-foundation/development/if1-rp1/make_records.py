#!/usr/bin/env python3
"""IF1 and RP1: write the records a-rise-past-the-inflow-is-drawn-from-beyond and
a-race-for-position-draws-everything, and link the two gainless records to the first.
usage (from the checkout root, after apply_text.py): python3 -B make_records.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
assert f'## {N}. A rise past the inflow, and a race for position (IF1, RP1)' in (ROOT / STUDY).read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE = '22 October 2026'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def declared(module):
    found = [m for m in R['modules'] if m['module'] == module]
    assert len(found) == 1, module
    assert not found[0]['axiom_dependencies'], (module, found[0]['axiom_dependencies'])
    return {d['name'] for d in found[0]['declarations']}, found[0]


def need(module, names):
    have, _ = declared(module)
    for n in names:
        assert n in have, n
    return names


def src(module):
    return f'{PKG}/' + module.replace('.', '/') + '.lean'


def binding(module):
    path = src(module)
    assert R['source_sha256'][module] == sha(path), module
    return {'source': path, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{module}',
            'success_pointer': '/status', 'success_value': 'passed'}


def t(en, zh):
    return {'en': en, 'zh': zh}


F, B = 'Becoming.Flow.', 'Becoming.Flow.Balances.'
ENT = need('Becoming.Entropy', [F + 'inflow', F + 'le_add_excess', F + 'excess_le_of_le_add', F + 'gainlessOn_iff_inflow',
                                F + 'replenishment_le_inflow', F + 'gained_le_inflow', B + 'stock_gained', B + 'stock_inflow',
                                B + 'stock_over_inflow'])
SEL = need('Becoming.SelectionReach', [B + 'rise_draws_beyond_inflow', B + 'rise_le_inflow_beyond',
                                       B + 'rise_takes_beyond_inflow', F + 'favours_reaching_beyond_inflow'])
WIT = need('Becoming.SelectionReach', ['Becoming.Diversion.supplying_rises_by_inflow'])
DRA = need('Becoming.DrawnBeyond', [B + 'beyond_falls_inflow', B + 'rise_lowers_beyond_inflow', B + 'breaks_beyond_inflow',
                                    B + 'rise_breaks_beyond_inflow', F + 'favours_breaking_beyond_inflow', F + 'reaches_inflow',
                                    B + 'rise_bounded_by_beyond_inflow'])
I = 'Becoming.Optimum.InTurn.'
MODEL = need('Becoming.Optimum', [I + n for n in ['drawnAll', 'whole', 'RevisesPosition', 'PerfectPosition']])
LAW = need('Becoming.Optimum', [I + n for n in ['position_keeps_nothing', 'position_nothing_best', 'pass_le']])
STEP = need('Becoming.Optimum', [I + n for n in ['drawn_first_none', 'drawn_other_none', 'drawnAll_none', 'later_same',
                                                 'drawnAll_grows', 'position_step', 'position_last']])
DRAIN = need('Becoming.Optimum', [I + n for n in ['position_perfect_ends', 'position_perfect_draws', 'position_levels',
                                                  'zero_position_perfect']] + ['Becoming.Web.position_broken', 'Becoming.Web.drain_position_broken'])
BIND = need('Becoming.Optimum', [I + n for n in ['position_one', 'stopping', 'Stopping.not_least', 'Stopping.zero_not_perfect',
                                                 'Stopping.perfect_keeps']])
BOUNDARIES = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
              'omission-not-refutation']

inflow = {
    'schema_version': 2,
    'id': 'a-rise-past-the-inflow-is-drawn-from-beyond',
    'title': t('A rise past the inflow is drawn from beyond', '超过流入的上升取自其外'),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F04',
    'reviewed_at_utc': NOW,
    'statement': t('Across every step of a balanced flow, a family rises by at most what flows into a family containing it and '
                   'what is drawn from beyond; a rise past that inflow has a formation drawing from beyond, and a selection '
                   'rewarding it favours that draw.',
                   '平衡的流中每一步，一个族至多升高包含它的族的流入加上取自其外者；超过流入的上升有一个从其外汲取的构成，'
                   '奖励它的选择偏向这一汲取。'),
    'laws': [
        {**t('A family\'s inflow across a step is what each formation taking part gives it beyond what it takes from it, summed; '
             'it is zero exactly where the family gains nothing. In a balanced flow the stock after a step with what the family '
             'loses is the stock before with what it gains, which is at most the inflow; over a stretch the stock rises by at '
             'most the stretch\'s inflow.',
             '族在一步中的流入是参与的每个构成给它的超出从它所取者之和；恰在族无所增益时为零。平衡的流中，一步之后的存量加所失等于之前的'
             '存量加所得，所得至多是流入；一段之上存量至多升高该段的流入。'), 'declarations': ENT},
        {**t('Where a family without repetition rises across a step by more than the inflow of a family containing it, some '
             'formation taking part gives it more than it takes from it, by more than its own part of that inflow, and takes '
             'from the containing family more than from the risen one, with equality decided from a condition outside it; '
             'the stock after the step is at most the stock before, the inflow and what is taken beyond. Every selection '
             'holding only where the family rises past the inflow holds only where a formation raising it takes from a '
             'condition no member of the group couples into.',
             '无重复的族在一步中升高超过包含它的族的流入时，某个参与的构成给它的多于从它所取，超出其自身在该流入中的份，并从包含族所取多于'
             '从该族所取，判定相等时取自其外的某个条件；一步之后的存量至多是之前的存量加流入加其外所取。只在族超过流入升高处成立的每个选择，'
             '只在升高它的构成取自无一成员耦合入的条件处成立。'), 'declarations': SEL},
        {**t('With the conditions beyond listed apart, the beyond falls by at least the rise less the whole\'s inflow; a rise '
             'above the slack of the dependences beyond and the inflow breaks one of them, and a selection rewarding it favours '
             'the break; a formation raising the family by more than it adds to the whole takes from beyond; over a stretch the '
             'family rises by at most what the beyond lost and the stretch\'s inflow.',
             '其外的条件分列时，其外至少降低升高减去整体的流入；超出其外依存的余量与流入的升高打断其中一个，奖励它的选择偏向这一打断；给族的'
             '超出它给整体之增量的构成从其外汲取；一段之上族至多升高其外所失加该段的流入。'), 'declarations': DRA},
        {**t('The bound is exact: Diversion\'s supplying flow raises the store by exactly its inflow, taking nothing.',
             '界限是精确的：Diversion 的供给之流恰以其流入抬高储，不取任何东西。'), 'declarations': WIT},
    ],
    'hypotheses': [t(
        'No axiom. Balance; the risen family without repetition inside the containing family; for the condition named, '
        'equality of conditions decided and the containing family without repetition; for the selection forms, the family '
        'listing every condition the group couples into; for the breaks, a dependence named on each condition beyond, met '
        'at the step, and the beyond listed apart from the family.',
        '不加公理。平衡；上升之族无重复且在包含族内；指名条件时，条件相等可判定且包含族无重复；选择的形式需族列出群体耦合入的每个条件；'
        '打断需在其外每个条件上指名一个依存，在该步被满足，其外与族分列。')],
    'does_not_show': [
        {**t('That the formation found is the one a selection rewards: a selection reading only the rise cannot tell who drew it.',
             '所找到的构成是被选择奖励的那一个：只读上升的选择分不出是谁汲取的。'), 'kind': 'scope'},
        {**t('What an actual whole\'s inflow is: reading sunlight, imports or renewal as the inflow is a correspondence.',
             '实际整体的流入是多少：把日照、输入或更新读作流入是对应，不是规律。'), 'kind': 'correspondence'},
        {**t('That drawing from beyond is wrong, or harms what is drawn on past the slack.',
             '从其外汲取是错的，或在余量之外伤害了所依者。'), 'kind': 'non-implication'},
    ],
    'counterexamples': [{'path': src('Becoming.SelectionReach'), 'detail': t(
        'A rise up to the inflow need not reach beyond: Diversion\'s supplying flow raises the store by exactly its one unit of '
        'inflow with nothing taken (Diversion.supplying_rises_by_inflow).',
        '不超过流入的上升不必伸向其外：Diversion 的供给之流恰以一个单位的流入抬高储，不取任何东西（Diversion.supplying_rises_by_inflow）。')}],
    'standard_boundaries': BOUNDARIES,
    'validation_scope': t(
        f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the declarations named here in '
        'Becoming.Entropy, Becoming.SelectionReach and Becoming.DrawnBeyond have empty axiom reports, and the gainless laws of '
        f'those modules are derived from them as the case of no inflow; the checker verifies core purity. Author review in '
        f'study section {N}; not independently reviewed.',
        f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：此处所列 Becoming.Entropy、Becoming.SelectionReach 与 Becoming.DrawnBeyond '
        f'的声明公理报告为空，这些模块中无所增益的规律作为无流入的情形由它们导出；检查器并核对核心纯净。作者审查见研究第 {N} 节；未经独立审查。'),
    'next_delta': t('The inflow read off a law of exchange rather than supplied with the flow; which formation draws, tied to what '
                    'a selection rewards; an independent review.',
                    '流入由交换之律读出，而非随流给定；哪个构成汲取，与选择所奖励者相连；独立审查。'),
    'correspondence': t(
        'Stock accounting over an open system: a stock rises by at most what flows in and what is drawn from its surroundings, '
        'as in material-flow and energy budgets. Reading (the AI\'s): an open whole is not exempt from drawing on what lies '
        'beyond what couples in; only the part of a rise that its inflow covers need not come from beyond.',
        '开放系统上的存量记账：存量至多升高流入加上取自周围者，如物质流与能量收支。解读（AI 的）：开放的整体并不免于汲取耦合之外者；'
        '只有流入所覆盖的那部分上升不必来自其外。'),
    'canonical_source': src('Becoming.SelectionReach'),
    'aliases': ['a rise past the inflow is drawn from beyond', '超过流入的上升取自其外', 'Becoming.Flow.inflow',
                'Becoming.Flow.favours_reaching_beyond_inflow', 'Becoming.Flow.Balances.rise_draws_beyond_inflow'],
    'dependencies': [
        {'id': 'entropy-history-and-record', 'relation': 'formal-reuse',
         'detail': t('Reuses Flow.lost, Flow.GainlessOn and the balance over a family (Flow.Balances.over).',
                     '复用 Flow.lost、Flow.GainlessOn 与族上的平衡（Flow.Balances.over）。'),
         'interface': {'output': t('What a family loses across a step; the family\'s balance.', '族在一步中所失；族的平衡。'),
                       'input': t('The exact law of what a family gains and loses.', '族所得所失的精确之律。'),
                       'conditions': t('Balance.', '平衡。'), 'evidence': src('Becoming.Entropy')}},
        {'id': 'what-a-rise-draws-from-beyond', 'relation': 'formal-reuse',
         'detail': t('Reuses Web.MetOn, Web.slack and Web.MetOn.breaks_of_falls.',
                     '复用 Web.MetOn、Web.slack 与 Web.MetOn.breaks_of_falls。'),
         'interface': {'output': t('A fall of the beyond past the slack breaks a dependence there.', '其外的降低超出余量即打断那里的一个依存。'),
                       'input': t('The break past the slack and the inflow.', '超出余量与流入的打断。'),
                       'conditions': t('A dependence named on each condition beyond, met at the step.', '其外每个条件上指名一个依存，在该步被满足。'),
                       'evidence': src('Becoming.DrawnBeyond')}},
        {'id': 'selection-through-couplings', 'relation': 'formal-reuse',
         'detail': t('Reuses Web.CoupledInto and Diversion\'s supplying flow and web.', '复用 Web.CoupledInto 与 Diversion 的供给之流和网。'),
         'interface': {'output': t('Coupling into a condition; the Diversion witness.', '耦合入一个条件；Diversion 见证。'),
                       'input': t('The selection forms and the exact bound.', '选择的形式与精确的界限。'),
                       'conditions': t('None beyond the flow.', '流之外无。'), 'evidence': src('Becoming.SelectionReach')}},
    ],
    'related': [
        {'id': 'raising-what-couples-in-draws-from-beyond', 'detail': t(
            'Its gainless laws are the case of no inflow here, and are now derived from these.',
            '其无所增益的规律是此处无流入的情形，现由此导出。')},
        {'id': 'least-loss-from-entropy-production', 'detail': t(
            'There a physical reading of balance and dissipation; here the accounting where the whole gains from outside.',
            '那里是平衡与耗散的物理读法；这里是整体从外有所得时的记账。')},
    ],
    'references': [
        {'path': src('Becoming.Entropy'), 'role': 'proof', 'declarations': sorted(ENT), 'sha256': sha(src('Becoming.Entropy'))},
        {'path': src('Becoming.SelectionReach'), 'role': 'proof', 'declarations': sorted(SEL + WIT),
         'sha256': sha(src('Becoming.SelectionReach'))},
        {'path': src('Becoming.DrawnBeyond'), 'role': 'proof', 'declarations': sorted(DRA), 'sha256': sha(src('Becoming.DrawnBeyond'))},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
    ],
    'proof_bindings': [binding('Becoming.Entropy'), binding('Becoming.SelectionReach'), binding('Becoming.DrawnBeyond')],
    'history': [t(f'{DATE}: added (IF1): the gainless laws of SelectionReach and DrawnBeyond graded by the containing family\'s '
                  f'inflow, the gainless laws derived as the case of no inflow; study section {N}.',
                  f'2026年10月22日：新增（IF1）：SelectionReach 与 DrawnBeyond 中无所增益的规律按包含族的流入分级，无所增益的规律作为无流入的'
                  f'情形导出；研究第 {N} 节。')],
}

race = {
    'schema_version': 2,
    'id': 'a-race-for-position-draws-everything',
    'title': t('A race for position draws everything', '争位次的轮流抽取者全部抽取'),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': t('Drawers in turn, each ranking its position against what all draw, draw everything at every step wherever '
                   'what stands from nothing is least and there are at least two; where something left would stop what '
                   'stands next, a drawer keeps it to stop it.',
                   '轮流的抽取者各按其相对全体所抽的位次排序，凡无中所立者最少且至少有两个抽取者处，每一步都全部抽取；所留会止住下一步所立时，'
                   '抽取者留下它以止住它。'),
    'laws': [
        {**t('Drawers in turn with no floor, each leaving at most what it is given, rank what they leave by position over the steps '
             'that remain: k times their own draw against what all draw from them on. A profile revises another for position, '
             'and is perfect for position where it revises itself.',
             '无下限的轮流抽取者，各留至多所给，按其余各步上的位次排序所留：k 倍自身所抽对自其起全体所抽。一个组合为位次修订另一个，'
             '修订自身即为位次完美。'), 'declarations': MODEL},
        {**t('What a drawer keeps for position it keeps for nothing: where its own later draw is the same, what passes on of it is '
             'at most it and all draw no less later, keeping lowers k times its own draw by k times what it keeps and what all draw '
             'by at most once that, so among two drawers or more a best response keeps nothing; drawing everything then places it '
             'no lower.',
             '为位次所留即一无所得：自身此后所抽相同、所传至多所留、全体此后所抽不少时，所留使 k 倍自身所抽降低 k 倍所留，而全体所抽至多降低'
             '一倍，故两个以上抽取者时最优回应一无所留；全部抽取则位次不低。'), 'declarations': LAW},
        {**t('At the last step every best response for position draws everything, whatever stands next; at a step after which every '
             'drawer draws everything, a drawer after the first draws everything where what stands from nothing is least.',
             '最后一步每个为位次的最优回应都全部抽取，不论下一步所立；此后每个抽取者都全部抽取的一步，无中所立者最少时首个之后的抽取者全部抽取。'),
         'declarations': STEP},
        {**t('Where what stands from nothing is at most what stands from anything left and there are at least two drawers, every '
             'profile perfect for position draws everything at every step before the horizon, the base stands at what stands from '
             'nothing, a dependence above it met at the start breaking at the first step, and drawing everything is perfect.',
             '无中所立至多是任何所留所立、至少两个抽取者时，每个为位次完美的组合在视野前每一步都全部抽取，基础立于无中所立，全部抽取即完美。'),
         'declarations': DRAIN},
        {**t('Each premise binds: with one drawer every profile is perfect; in Stopping, where anything left stops what stands next, '
             'drawing everything is not perfect and every perfect profile has the second drawer keep the unit it is given at the '
             'first step.',
             '每个前提都起作用：一个抽取者时每个组合都完美；在 Stopping 中，任何所留都止住下一步所立，全部抽取不完美，每个完美组合中第二个抽取者'
             '在第一步留下所给的一个单位。'), 'declarations': BIND},
    ],
    'hypotheses': [t(
        'No axiom. k drawers in turn with no floor, each leaving at most what it is given; position over the steps that remain, '
        'k times the drawer\'s draw against what all draw; any law G of what stands next; for the drain, G t 0 ≤ G t x at every '
        'step and at least two drawers.',
        '不加公理。k 个无下限的轮流抽取者，各留至多所给；其余各步上的位次，k 倍自身所抽对全体所抽；任意下一步所立之律 G；抽干需每步 '
        'G t 0 ≤ G t x 且至少两个抽取者。')],
    'does_not_show': [
        {**t('That every race for position draws everything: where something left stops what stands next, drawing everything is '
             'not perfect.', '每个争位次者都全部抽取：所留会止住下一步所立时，全部抽取不完美。'), 'kind': 'converse',
         'witness': I + 'Stopping.zero_not_perfect'},
        {**t('Drawing at once ranking position, floors under a race for position, or a horizon the drawers do not know.',
             '为位次同时抽取、争位次下的下限，或抽取者不知的视野。'), 'kind': 'scope'},
        {**t('That actual races are played in turn by drawers ranking position alone.', '实际的竞争由只按位次排序的抽取者轮流进行。'),
         'kind': 'correspondence'},
        {**t('That drawing everything is wrong.', '全部抽取是错的。'), 'kind': 'non-implication'},
    ],
    'counterexamples': [{'path': src('Becoming.Optimum'), 'detail': t(
        'Stopping: from nothing two stand, from anything left nothing; with two drawers over two steps the second, given one unit '
        'at the first step, places itself higher by keeping it, so drawing everything is not perfect (Stopping.zero_not_perfect, '
        'Stopping.perfect_keeps). With one drawer every profile is perfect (position_one).',
        'Stopping：无中立二，有所留则无所立；两个抽取者两步，第二个在第一步得一个单位，留下它位次更高，故全部抽取不完美'
        '（Stopping.zero_not_perfect、Stopping.perfect_keeps）。一个抽取者时每个组合都完美（position_one）。')}],
    'standard_boundaries': BOUNDARIES,
    'validation_scope': t(
        f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the declarations named here in '
        f'Becoming.Optimum\'s InTurn have empty axiom reports; the checker verifies core purity. Author review in study section '
        f'{N}; not independently reviewed.',
        f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：此处所列 Becoming.Optimum 中 InTurn 的声明公理报告为空；检查器并核对核心纯净。'
        f'作者审查见研究第 {N} 节；未经独立审查。'),
    'next_delta': t('Drawing at once ranking position; floors under a race for position; drawers mixing a race for position with '
                    'their own draw.',
                    '为位次同时抽取；争位次下的下限；位次与自身所抽混合排序的抽取者。'),
    'correspondence': t(
        'The ranking is the count of RelativePosition read on the draws: a game zero-sum in positions, as relative-payoff '
        'maximizers in evolutionary game theory (Schaffer 1988) and spite (Hamilton 1970), here over a stock renewed by any law; '
        'with own draws ranked the drain is the open-access outcome of drawers in turn. Reading (the AI\'s): where position is '
        'what counts, keeping a stock for later pays no drawer, and what one leaves is kept only to deny it to another.',
        '排序是 RelativePosition 的计数读在所抽之上：位次上零和的博弈，如演化博弈论中的相对收益最大化者（Schaffer 1988）与恶意'
        '（Hamilton 1970），此处在按任意律更新的存量之上；按自身所抽排序时抽干是轮流抽取者的公地结局。解读（AI 的）：位次为准处，'
        '为以后保留存量对任何抽取者都无所得，所留只为不让给他者。'),
    'canonical_source': src('Becoming.Optimum'),
    'aliases': ['a race for position draws everything', '争位次的轮流抽取者全部抽取', I + 'PerfectPosition',
                I + 'position_perfect_ends', I + 'position_keeps_nothing'],
    'dependencies': [
        {'id': 'drawers-in-turn', 'relation': 'formal-reuse',
         'detail': t('Reuses InTurn\'s model and its laws of passing: pass, drawn, later, levels, pass_zero, pass_through, '
                     'levels_through.',
                     '复用 InTurn 的模型及其传递之律：pass、drawn、later、levels、pass_zero、pass_through、levels_through。'),
         'interface': {'output': t('What drawers in turn leave, draw and let stand; nothing passes a drawer leaving nothing.',
                                   '轮流抽取者所留、所抽与所立；一无所留的抽取者不让任何东西通过。'),
                       'input': t('The race for position on the same model.', '同一模型上的位次竞争。'),
                       'conditions': t('Drawers leaving at most what they are given.', '抽取者至多留下所给。'),
                       'evidence': src('Becoming.Optimum')}},
    ],
    'related': [
        {'id': 'relative-position-is-zero-sum', 'detail': t(
            'The count ranked here; a race of position cannot raise everyone, and this law says what drawers racing for it do to '
            'what they draw on.', '此处排序所用的计数；位次之争不能使人人上升，此律说明争位次的抽取者对所依者做什么。')},
        {'id': 'a-rise-past-the-inflow-is-drawn-from-beyond', 'detail': t(
            'Where a rise is rewarded, what passes the inflow is drawn from beyond; where position is rewarded, drawers draw '
            'everything.', '奖励上升处，超过流入者取自其外；奖励位次处，抽取者全部抽取。')},
    ],
    'references': [
        {'path': src('Becoming.Optimum'), 'role': 'proof', 'declarations': sorted(MODEL + LAW + STEP + DRAIN + BIND),
         'sha256': sha(src('Becoming.Optimum'))},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
    ],
    'proof_bindings': [binding('Becoming.Optimum')],
    'history': [t(f'{DATE}: added (RP1): drawers in turn ranking position, the race of RelativePosition read on the draws; study '
                  f'section {N}.', f'2026年10月22日：新增（RP1）：按位次排序的轮流抽取者，RelativePosition 的竞争读在所抽之上；研究第 {N} 节。')],
}

for record in (inflow, race):
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
    print('wrote', record['id'])

for rid, detail in (('raising-what-couples-in-draws-from-beyond', t(
        'Graded by the containing family\'s inflow, the laws hold without the gainless premise for a rise past the inflow; the '
        'gainless laws here are its case of no inflow and are derived from it.',
        '按包含族的流入分级，这些规律对超过流入的上升不需无所增益的前提；此处无所增益的规律是其无流入的情形，由它导出。')),
                    ('what-a-rise-draws-from-beyond', t(
        'Graded by the whole\'s inflow, the fall of the beyond, the break past the slack, reaching beyond and the bound over a '
        'stretch hold past the inflow; the gainless laws here are their case of no inflow and are derived from them.',
        '按整体的流入分级，其外的降低、超出余量的打断、伸向之外与一段之上的界限都超过流入而成立；此处无所增益的规律是其无流入的情形，由之导出。'))):
    path = RECORDS / f'{rid}.json'
    d = json.loads(path.read_text())
    assert all(r['id'] != inflow['id'] for r in d.get('related', []))
    d.setdefault('related', []).append({'id': inflow['id'], 'detail': detail})
    d['reviewed_at_utc'] = NOW
    d['history'].append(t(f'{DATE}, IF1: graded by the inflow in record {inflow["id"]}; the gainless laws of this record are now '
                          f'derived as its case of no inflow, their statements unchanged (study section {N}).',
                          f'2026年10月22日，IF1：在记录 {inflow["id"]} 中按流入分级；本记录无所增益的规律现作为其无流入的情形导出，陈述不变'
                          f'（研究第 {N} 节）。'))
    path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('linked', rid)
