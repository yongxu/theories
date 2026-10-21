#!/usr/bin/env python3
"""Write RM6's record coupled-regimes (a theorem), note it in the five regime records that left coupled conditions open
(margin-of-a-regime, regime-point-under-adjusting-giving, where-a-run-of-a-regime-comes-to-rest,
threshold-in-the-state-plane, regime-in-any-amounts), and give the coverage file's degeneration row the record and its
threshold law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.RegimeMargin gained since the previous receipt. Every declaration cited
is resolved against the receipt's audited declarations, and the receipt must bind each cited module's current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. Coupled regimes: a margin that is not its own (RM6)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == f'Becoming.{mod}.' + n]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']

RID = 'coupled-regimes'
RM1 = 'margin-of-a-regime'
RM2 = 'regime-point-under-adjusting-giving'
RM3 = 'where-a-run-of-a-regime-comes-to-rest'
RM4 = 'threshold-in-the-state-plane'
RM5 = 'regime-in-any-amounts'
L1 = 'the-last-change-of-a-run'
RM = 'RegimeMargin'
C = 'Coupled.'
MA, MI, RL = C + 'MutualActivation.', C + 'MutualInhibition.', C + 'Relay.'

laws = [
    ('Two conditions under draws taken first, as much as there is, each giving a law of what is left of both, in any '
     'amounts with a draw; the step reads a state only through what the draws leave. Exchanging the two exchanges the '
     'levels at every step, and a condition whose giving reads only what is left of itself runs as the regime.',
     '两个条件各在汲取之下（汲取先取，有多少取多少），各所给是两者所余之律，在任何带汲取的量中；步只经由汲取所余读取状态。交换两者则每步交换水平；'
     '所给只读自身所余的条件按体制运行。',
     [(RM, [C + n for n in ['left', 'step', 'Ends', 'step_of_left', 'run_swap', 'ends_swap', 'first_regime']])]),
    ('Under mutual support, each giving rising with what is left of each, the coupled step keeps the order of states, '
     'along runs too, so a condition that ends (nothing from some step on) from a state ends from every state at or below '
     'it in both levels.',
     '相互支持下（各所给随两者所余而升），耦合之步保持状态之序，沿运行亦然，故自一状态终结（自某步起为无）的条件，自两个水平上皆处于或低于它的每个状态终结。',
     [(RM, [C + n for n in ['step_mono', 'run_below', 'ends_of_below']])]),
    ('Within a band the coupled step keeps, mutual support gives within each draw, so what the draws leave of each never '
     'rises along a run, and the run is still once it repeats; a state the step leaves as it is stays. In whole numbers a '
     'run from the band is still from some step at most 2 hi + 1.',
     '在耦合之步保持的带内，相互支持下各所给不超过其汲取，故汲取所余沿运行从不上升，重复时运行即静止；步所不动的状态停留。在整数中，自带内出发的运行至多自第 '
     '2 hi + 1 步起静止。',
     [(RM, [C + n for n in ['Band', 'given_within', 'within_draw', 'left_le', 'run_within', 'left_falls',
                            'still_of_left', 'rests_by', 'comes_to_rest', 'stays', 'stays_from']])]),
    ('Within a band under mutual support, in whole numbers, whether the first condition ends is decided at step 2 hi + 1; '
     'for each partner\'s level up to hi it ends exactly below a least level found by a finite search, which does not rise '
     'as the partner\'s level rises; at its rest the first is nothing below it and something from it on.',
     '带内、相互支持下、在整数中，第一个条件是否终结在第 2 hi + 1 步可判定；对至 hi 的每个伙伴水平，它恰在有限搜索找到的最小水平之下终结，该水平不随伙伴水平上升而升；'
     '在其静止处，第一个条件在其下为无，自其起为有。',
     [(RM, [C + n for n in ['ends_iff', 'ending', 'threshold', 'ends_iff_below', 'threshold_falls', 'fates']])]),
    ('Where the second gives nothing wherever nothing is left of the first, while the first stays within its draw the '
     'second\'s next level is what its draw leaves of it; in whole numbers it falls by its draw at every step and, the draw '
     'positive, is nothing within as many steps as its level, so the first\'s end ends it; under dependence both ways the '
     'two end together.',
     '第二个条件在第一个一无所余处给无时，只要第一个留在其汲取之内，第二个的下一水平即其汲取所余；在整数中它每步按汲取下降，汲取为正时至多经其水平之步数即为无，'
     '故第一个的终结终结它；双向依赖时两者同终。',
     [(RM, [C + n for n in ['drains', 'ends_after', 'ends_of_partner', 'ends_together']])]),
    ('Witness, support saves: giving of one where at least one is left of each, draws of one, a band up to two. From two '
     'the first ends with its partner at nothing and holds with its partner at two; its threshold is three, beyond the '
     'band, at a partner of nothing and two at a partner of two.',
     '见证，支持挽救：两者所余皆至少为一处给一，汲取为一，带至二。自二出发，伙伴为无时第一个终结，伙伴为二时它维持；其阈值在伙伴为无时为三（带外），伙伴为二时为二。',
     [(RM, [MA + n for n in ['giving', 'giving_rises', 'giving_le', 'band', 'saves']])]),
    ('Witness, inhibition: each gives one only where nothing is left of the other, within a band up to two. Each holds at '
     'two alone and from two and two both end, so the first ends from a state above one from which it holds, and its '
     'threshold rises from two to three as its partner rises from nothing to two.',
     '见证，抑制：各只在对方一无所余处给一，带至二。各自单独在二处维持，自二与二出发两者皆终结，故第一个自高于它维持之状态的一个状态终结，其阈值随伙伴自无升至二而自二升至三。',
     [(RM, [MI + n for n in ['first', 'second', 'first_le', 'second_le', 'band', 'breaks_order']])]),
    ('Witness, a band without support: giving two from nothing and nothing from more, read as the first\'s with the second '
     'giving nothing, keeps a band up to two under draws of one, yet the coupled run from one and nothing is never still.',
     '见证，无支持之带：自无给二、自更多给无的所给作为第一个的所给、第二个给无，在汲取为一下保持至二的带，但自一与无出发的耦合运行从不静止。',
     [(RM, [C + 'alternation_never_rests'])]),
    ('Witness, a cycle under support beyond a band: each gives two only where enough is left of the other; both rise with '
     'what is left of each and give nothing where nothing is left of the other. Under draws of one each alone ends from '
     'every level, while from two and three the run moves between two and three and three and two for ever.',
     '见证，带外支持下的循环：各只在对方所余足够处给二；两者皆随两者所余而升，在对方一无所余处给无。汲取为一下各自单独自每个水平终结，而自二与三出发的运行永远在二与三、'
     '三与二之间往返。',
     [(RM, [RL + n for n in ['first', 'second', 'first_rises', 'second_rises', 'first_zero', 'first_of_zero',
                             'second_zero', 'second_of_zero', 'first_alone', 'second_alone', 'between', 'cycles']])]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
new_by = {}
for mod in [RM]:
    old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{mod}')['declarations']}
    full = decls(mod)
    assert old_names <= set(full), old_names - set(full)
    new = sorted(d for d in full if d not in old_names)
    cited = sorted(d for _, _, groups in laws for m, names in groups if m == mod for d in resolve(mod, names))
    assert cited == new, (mod, set(new) - set(cited), set(cited) - set(new))
    new_by[mod] = new
EARLIER = {RM: ['Becoming.RegimeMargin.step', 'Becoming.RegimeMargin.Drawn', 'Becoming.RegimeMargin.Drawn.Rises',
                'Becoming.RegimeMargin.Drawn.Below', 'Becoming.RegimeMargin.Drawn.sub_mono',
                'Becoming.RegimeMargin.Drawn.add_cancel', 'Becoming.RegimeMargin.Drawn.whole',
                'Becoming.RegimeMargin.leading', 'Becoming.RegimeMargin.leading_le', 'Becoming.RegimeMargin.leading_true',
                'Becoming.RegimeMargin.leading_false', 'Becoming.RegimeMargin.Adjusted.sum_lt_of_below',
                'Becoming.RegimeMargin.Alternation.giving', 'Becoming.RegimeMargin.Alternation.keeps',
                'Becoming.RegimeMargin.Alternation.alternates']}
for mod, names in EARLIER.items():
    assert set(names) <= set(decls(mod)), set(names) - set(decls(mod))
USED = {'LastChange': ['Becoming.LastChange.StillFrom', 'Becoming.LastChange.still_stays',
                       'Becoming.LastChange.still_succ'],
        'Recurrence': ['Becoming.Law.orbit', 'Becoming.Law.orbit_add', 'Becoming.Law.orbit_mul', 'Becoming.Law.run'],
        'Lasting': ['Becoming.Lasting.orbit_mono'],
        'Amounts': ['Becoming.Amounts.add_le_add_left', 'Becoming.Amounts.add_zero', 'Becoming.Amounts.le_of_eq'],
        'Prelude': ['Becoming.add_sub_of_le', 'Becoming.sub_eq_zero_of_le', 'Becoming.Naturals.sub_sub',
                    'Becoming.Naturals.succ_ne_zero']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
n_new = sum(len(v) for v in new_by.values())
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Coupled regimes: a margin that is not its own', 'zh': '耦合的体制：不属于自身的余量'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Two conditions under draws, each giving from what is left of both: under mutual support the order of '
              'states is kept and ending is down-closed; within a band in whole numbers runs rest and a condition\'s '
              'point of no return falls as its partner rises; a dependent ends after its partner.',
        'zh': '两个条件各在汲取之下，各从两者所余中给出：相互支持下状态之序得保持，终结向下封闭；在整数的带内运行静止，一个条件的不归点随伙伴上升而降；依赖者在其伙伴之后终结。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [d for m, names in groups for d in resolve(m, names)]}
             for en, zh, groups in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps; two conditions; each draw taken first, as much as there is; each giving a law '
               'of what is left of both; amounts linearly ordered with a truncated difference, whole numbers for rest, '
               'the threshold and the drain\'s count; each law\'s own premises as hypotheses: mutual support, a band the '
               'coupled step keeps, the dependent giving nothing where nothing is left of its partner, a positive draw.',
         'zh': '不加公理。离散步；两个条件；各汲取先取，有多少取多少；各所给是两者所余之律；量线性有序且有截断差，静止、阈值与流尽之计数需整数；各律自身的前提为假设：'
               '相互支持、耦合之步所保持的带、依赖者在伙伴一无所余处给无、汲取为正。'}],
    'does_not_show': [
        {'en': 'Thresholds beyond a band: within one, mutual support gives within each draw; beyond it only the cycle is '
               'stated, and no bound on a run decides ending.',
         'zh': '带外的阈值：带内相互支持下各所给不超过汲取；带外只陈述了循环，没有运行之界来判定终结。', 'kind': 'scope'},
        {'en': 'More than two conditions, a web of them; coupled conditions with a recent giving (the adjusted step); '
               'the reals and continuous time.',
         'zh': '多于两个条件或其网；带近来所给的耦合条件（调整之步）；实数与连续时间。', 'kind': 'scope'},
        {'en': 'That measured conditions are coupled by mutual support, or how strongly: a partner\'s level would be a '
               'fourth variable in T2\'s state; how strong coupling is in the field is untested.',
         'zh': '所测的条件由相互支持耦合，或其强弱：伙伴的水平将是 T2 状态中的第四个变量；野外耦合多强未经检验。', 'kind': 'non-implication'}],
    'counterexamples': [
        {'path': src(RM), 'detail': {
            'en': 'MutualInhibition.breaks_order: where each gives only where nothing is left of the other, within a band '
                  'the first ends from two and two yet holds from two and nothing, below it: no down-closure without '
                  'mutual support, and the threshold rises with the partner.',
            'zh': 'MutualInhibition.breaks_order：各只在对方一无所余处给出时，带内第一个自二与二终结，却自其下的二与无维持：无相互支持则无向下封闭，阈值随伙伴上升。'}},
        {'path': src(RM), 'detail': {
            'en': 'Coupled.alternation_never_rests: a band without mutual support gives no rest.',
            'zh': 'Coupled.alternation_never_rests：无相互支持的带不给出静止。'}},
        {'path': src(RM), 'detail': {
            'en': 'Relay.cycles: mutual support without a band gives no rest; a pair each of which ends alone cycles for '
                  'ever between two unordered states.',
            'zh': 'Relay.cycles：无带的相互支持不给出静止；各自单独皆终结的一对永远在两个无序状态之间循环。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core purity. Built and reviewed '
              f'in one session, with no separate reviewer; author review in study section {N}; not independently '
              f'reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.RegimeMargin 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Thresholds beyond a band, with a bound on the run in its place; more than two conditions, a web; coupled '
              'conditions with a recent giving; over the reals; a frozen field test of whether a partner\'s level adds to '
              'T2\'s state for coupled conditions; an independent review.',
        'zh': '带外的阈值，以运行之界代替带；多于两个条件、其网；带近来所给的耦合条件；实数上；冻结的野外检验：对耦合条件，伙伴的水平是否加入 T2 的状态；独立审查。'},
    'correspondence': {
        'en': 'Cooperative (monotone) dynamical systems keep the order of states and their extinction sets are down-closed '
              '(Smith 1995; Hirsch and Smith 2005); in obligate mutualism a threshold curve separates extinction from '
              'persistence, each partner needing less as the other has more (Dean 1983), and dependents are lost with '
              'their partner (coextinction, Koh et al. 2004); competitive maps keep the order with one coordinate '
              'reversed, and planar cooperative maps are eventually monotone only under regularity conditions (Smith '
              '1998). On the spine, constructive and exact in its premises: the threshold for each partner\'s level is '
              'the least level a finite search finds within a band, the dependent\'s drain is counted, and the uncoupled '
              'case is the regime itself; mutual support and the band are each shown needed by a witness.',
        'zh': '合作（单调）动力系统保持状态之序，其灭绝集向下封闭（Smith 1995；Hirsch 与 Smith 2005）；在专性互利中，一条阈值曲线分开灭绝与持续，各方在对方较多时所需较少'
              '（Dean 1983），依赖者随其伙伴而失（共灭绝，Koh 等 2004）；竞争映射在一个坐标反向下保持序，平面合作映射只在正则条件下最终单调（Smith 1998）。在脊柱上，'
              '构造性且在其前提上精确：对每个伙伴水平，阈值是带内有限搜索找到的最小水平，依赖者的流尽可计数，未耦合情形即体制本身；相互支持与带各由见证表明不可少。'},
    'canonical_source': src(RM),
    'aliases': ['coupled regimes', 'a margin that is not its own', 'the point of no return of a coupled condition',
                'coextinction under a draw', '耦合的体制', 'Becoming.RegimeMargin.Coupled.ends_iff_below',
                'Becoming.RegimeMargin.Coupled.threshold_falls', 'Becoming.RegimeMargin.Coupled.ends_after'],
    'dependencies': [
        {'id': RM1, 'relation': 'formal-reuse',
         'detail': {'en': 'The regime\'s step is the uncoupled case: a condition whose giving reads only what is left of '
                          'itself runs as the regime, whatever its partner does.',
                    'zh': '体制之步是未耦合情形：所给只读自身所余的条件按体制运行，无论伙伴如何。'},
         'interface': {
             'output': {'en': 'step.', 'zh': 'step。'},
             'input': {'en': 'Coupled.first_regime: RM1\'s laws hold of an uncoupled condition in the pair.',
                       'zh': 'Coupled.first_regime：RM1 之律对一对中未耦合的条件成立。'},
             'conditions': {'en': 'Whole-number amounts; the first\'s giving reading only what is left of itself.',
                            'zh': '整数量；第一个的所给只读自身所余。'},
             'evidence': src(RM)}},
        {'id': RM5, 'relation': 'formal-reuse',
         'detail': {'en': 'Amounts with a draw, rising giving, the order of states, sub_mono and add_cancel are reused; '
                          'the coupled step is stated in them, whole numbers an instance.',
                    'zh': '沿用带汲取的量、上升的所给、状态之序、sub_mono 与 add_cancel；耦合之步在其中陈述，整数为其实例。'},
         'interface': {
             'output': {'en': 'Drawn, Drawn.Rises, Drawn.Below, Drawn.sub_mono, Drawn.add_cancel and Drawn.whole.',
                        'zh': 'Drawn、Drawn.Rises、Drawn.Below、Drawn.sub_mono、Drawn.add_cancel 与 Drawn.whole。'},
             'input': {'en': 'The coupled step and its order under mutual support in any amounts with a draw.',
                       'zh': '任何带汲取的量中的耦合之步及其在相互支持下之序。'},
             'conditions': {'en': 'Linearly ordered amounts with a truncated difference.', 'zh': '带截断差的线性有序量。'},
             'evidence': src(RM)}},
        {'id': RM4, 'relation': 'formal-reuse',
         'detail': {'en': 'The threshold by a finite search (leading) is reused for each partner\'s level.',
                    'zh': '沿用以有限搜索（leading）求阈值，用于每个伙伴水平。'},
         'interface': {
             'output': {'en': 'leading, leading_le, leading_true and leading_false.',
                        'zh': 'leading、leading_le、leading_true 与 leading_false。'},
             'input': {'en': 'A least level for each partner\'s level, below which exactly the first condition ends.',
                       'zh': '对每个伙伴水平的一个最小水平，恰在其下第一个条件终结。'},
             'conditions': {'en': 'Ending decided at a fixed step.', 'zh': '终结在固定步可判定。'},
             'evidence': src(RM)}},
        {'id': RM3, 'relation': 'formal-reuse',
         'detail': {'en': 'The strict fall of a sum of two whole numbers below an ordered pair, and Alternation\'s giving '
                          'as a witness that a band without support gives no rest.',
                    'zh': '沿用有序对下两个整数之和的严格下降，以及 Alternation 的所给作为无支持之带不给出静止的见证。'},
         'interface': {
             'output': {'en': 'Adjusted.sum_lt_of_below, Alternation.giving, Alternation.keeps and Alternation.alternates.',
                        'zh': 'Adjusted.sum_lt_of_below、Alternation.giving、Alternation.keeps 与 Alternation.alternates。'},
             'input': {'en': 'Rest within 2 hi + 1 steps; the band without mutual support.',
                       'zh': '2 hi + 1 步内的静止；无相互支持的带。'},
             'conditions': {'en': 'Whole-number amounts.', 'zh': '整数量。'},
             'evidence': src(RM)}},
        {'id': L1, 'relation': 'formal-reuse',
         'detail': {'en': 'StillFrom, still_succ and still_stays are reused for the rest of a coupled run.',
                    'zh': '沿用 StillFrom、still_succ 与 still_stays 于耦合运行的静止。'},
         'interface': {
             'output': {'en': 'StillFrom, still_succ and still_stays.', 'zh': 'StillFrom、still_succ 与 still_stays。'},
             'input': {'en': 'A coupled run still from a step stays there, so ending is read at its rest.',
                       'zh': '自某步起静止的耦合运行停留于此，故终结在其静止处读出。'},
             'conditions': {'en': 'A run of any process.', 'zh': '任一过程的运行。'},
             'evidence': f'{PKG}/Becoming/LastChange.lean'}}],
    'related': [{'id': 'groups-whose-conditions-are-coupled', 'detail': {
        'en': 'That record reads a family of coupled conditions as one, under balance, and ends it by joint excess; here '
              'each of two conditions keeps its own giving law of what is left of both, and a condition\'s point of no '
              'return is read against its partner\'s level.',
        'zh': '该记录在平衡下把一族耦合条件读作一个，以联合超出终结之；此处两个条件各保有以两者所余为变元的所给之律，一个条件的不归点对照其伙伴的水平读出。'}}],
    'references': [{'path': src(RM), 'role': 'proof', 'declarations': sorted(new_by[RM] + EARLIER[RM]), 'sha256': sha(src(RM))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [RM] + [m for m, _ in refs_used]],
    'history': [{
        'en': f'21 October 2026: added (RM6), coupled regimes: two conditions under draws, each giving from what is left '
              f'of both; under mutual support the order of states is kept and ending is down-closed; within a band in '
              f'whole numbers runs rest within 2 hi + 1 steps and the first condition ends exactly below a least level '
              f'that does not rise as its partner rises; a dependent drains by its draw once its partner has nothing '
              f'left; study section {N}.',
        'zh': f'2026年10月21日：新增（RM6），耦合的体制：两个条件各在汲取之下，各从两者所余中给出；相互支持下状态之序得保持，终结向下封闭；在整数的带内运行在 2 hi + 1 '
              f'步内静止，第一个条件恰在一个不随伙伴上升而升的最小水平之下终结；依赖者在伙伴一无所余后按汲取流尽；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500, (
    len(rec['correspondence']['en']), len(rec['correspondence']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
assert len(rec['validation_scope']['zh']) <= 260, len(rec['validation_scope']['zh'])
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')

# The five regime records that left coupled conditions open.
DNS_EN = ('coupled conditions.', f'coupled conditions with a recent giving (record {RID} states two under the regime\'s '
                                 'step).')
DNS_EN2 = ('coupled conditions; ', f'coupled conditions with a recent giving (record {RID} states two under the '
                                   'regime\'s step); ')
DNS_ZH = ('相互耦合的条件', f'带近来所给的相互耦合条件（记录 {RID} 陈述体制之步下的两个）')
ND_EN = ('coupled conditions; ', 'coupled conditions with a recent giving, or more than two; ')
ND_ZH = ('相互耦合的条件；', '带近来所给或多于两个的相互耦合条件；')
notes = {
    RM1: dict(nd=[('coupled conditions; ', 'webs of conditions; '),  # its next delta is at the 400 limit
                  ('相互耦合的条件；', '条件之网；')], dns=[]),
    RM2: dict(nd=[], dns=[('coupled conditions.', 'coupled adjusted conditions.'),
                          ('相互耦合的条件', '调整所给的相互耦合条件')]),
    RM3: dict(nd=[ND_EN, ND_ZH], dns=[DNS_EN, DNS_ZH]),
    RM4: dict(nd=[ND_EN, ND_ZH], dns=[DNS_EN, DNS_ZH]),
    RM5: dict(nd=[ND_EN, ND_ZH], dns=[DNS_EN2, DNS_ZH]),
}
for rid, how in notes.items():
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    for old, new in how['dns']:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        hits = [x for x in d['does_not_show'] if old in x[lang]]
        assert len(hits) == 1 and hits[0][lang].count(old) == 1, (rid, old, len(hits))
        hits[0][lang] = hits[0][lang].replace(old, new)
        if lang == 'en':
            assert len(hits[0]['en']) <= 240, (rid, len(hits[0]['en']))
    for old, new in how['nd']:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        assert d['next_delta'][lang].count(old) == 1, (rid, lang, old)
        d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
    if rid in (RM1, RM4):
        assert all(r['id'] != RID for r in d.get('related', []))
        d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
            'en': 'Two conditions each giving from what is left of both: under mutual support within a band a condition\'s '
                  'point of no return is a least level that does not rise as its partner rises; a dependent ends after its '
                  'partner; the regime is the uncoupled case.',
            'zh': '两个条件各从两者所余中给出：带内相互支持下，一个条件的不归点是不随伙伴上升而升的最小水平；依赖者在其伙伴之后终结；体制即未耦合情形。'}}]
    said_en = ' and '.join(x for x, on in [('what this record does not show', how['dns']), ('its next delta', how['nd'])] if on)
    said_zh = '与'.join(x for x, on in [('本记录所不表明者', how['dns']), ('其下一步', how['nd'])] if on)
    verb = 'say' if how['dns'] and how['nd'] else 'says'
    d['history'].append({
        'en': f'21 October 2026, RM6: coupled conditions, left open here, are stated for two conditions under the regime\'s '
              f'step (record {RID}, study section {N}); {said_en} now {verb} what stays open. Its laws are unchanged.',
        'zh': f'2026年10月21日，RM6：此处留下的相互耦合条件，对体制之步下的两个条件已陈述（记录 {RID}，研究第 {N} 节）；{said_zh}现已说明仍开放者。'
              f'其规律不变。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'degeneration')
assert RID not in row['records'] and RM5 in row['records']
row['records'].insert(row['records'].index(RM5) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.RegimeMargin.Drawn.run_shape') + 1,
                           'Becoming.RegimeMargin.Coupled.threshold_falls')
print('coverage row degeneration')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
