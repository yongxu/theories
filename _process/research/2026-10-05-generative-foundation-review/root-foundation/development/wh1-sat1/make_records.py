#!/usr/bin/env python3
"""Write WH1's record a-whole-of-every-part and SAT1's record a-coupling-saturated-by-what-it-has-carried (theorems),
and note them in the records whole-persists-through-generation, how-often-couplings-act and
civilization-thought-on-the-spine (whose gap list they shorten):
python3 -B make_records.py CORE_RECEIPT WH1_SECTION SAT1_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.Wholes and Becoming.Frequency gained since the previous receipt (the
receipt lists source declarations only); every cited declaration is resolved
against the receipt's audited declarations, and the receipt must bind the modules' current bytes. Every edit is checked
before anything is written."""
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
MAPCH = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
ZHMAP = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N_WH, N_SA, previous = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
stext = (ROOT / STUDY).read_text()
for n, head in ((N_WH, 'A whole of every part, and a graded whole (WH1)'),
                (N_SA, 'A coupling saturated by what it has carried (SAT1)')):
    assert re.search('^' + re.escape(f'## {n}. {head}') + '$', stext, re.M), head
P = json.loads(Path(previous).read_text())


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def module(mod):
    src = f'{PKG}/Becoming/{mod}.lean'
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src), 'receipt does not bind ' + mod
    assert not any(m['axiom_dependencies'].values())
    full = [d['name'] for d in m['declarations']]
    old = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{mod}')['declarations']}
    assert not (old - set(full)), old - set(full)
    new = sorted(d for d in full if d not in old)
    return src, full, new


def resolver(full):
    def resolve(names):
        out = []
        for n in names:
            assert full.count('Becoming.' + n) == 1, n
            out.append('Becoming.' + n)
        return out
    return resolve


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']

# ---------------------------------------------------------------- WH1
SRC_W, FULL_W, NEW_W = module('Wholes')
rw = resolver(FULL_W)
W = 'Web.'
laws_w = [
    ('A formation is the whole of every part when it is active exactly while every part is; every formation is that of '
     'itself. It is inactive wherever one part is, so it ends as soon as one part ends, with no listing and nothing of '
     'arising, and persists exactly while every part does; a whole of a brief part is brief.',
     '一个形成恰在每个部分都活跃时活跃，即为每个部分之整体；每个形成都是其自身的这种整体。它在任一部分不活跃之处不活跃，故一个部分终结它即终结，'
     '无须列举，也无关生起；它恰在每个部分都持续时持续；一个短暂部分之整体是短暂的。',
     [W + n for n in ['AllWhole', 'allWhole_self', 'AllWhole.inactive_of_part', 'AllWhole.ends_of_part',
                      'AllWhole.persists_iff', 'AllWhole.brief_of_part']]),
    ('A whole of some part ceases only as some part ceases, dually to its arising. With some part, the whole of every part '
     'is active only where the whole of some part is, and the two coincide exactly where the parts are in step; with no '
     'part they part entirely.',
     '某部分之整体只经由某部分之止息而止息，与其生起对偶。有部分时，每个部分之整体只在某部分之整体活跃处活跃，二者恰在诸部分同步之处相合；'
     '无部分时二者全然分开。',
     [W + n for n in ['Whole.ceases_part', 'AllWhole.active_whole', 'InStep', 'Whole.same_iff_inStep',
                      'AllWhole.active_of_none']]),
    ('The grade of listed parts at a step is a count of their activity, existing exactly where it is decided: positive '
     'exactly where some is active, the number listed exactly where every one is, short of it wherever one is not. Across '
     'a step it gains what arises and loses what ceases, so it rises only as a listed part arises and falls only as one '
     'ceases.',
     '所列部分在一步的等级是其活动之计数，恰在活动可判定之处存在：恰在某部分活跃时为正，恰在每个部分都活跃时等于所列之数，任一部分不活跃即不足。'
     '跨一步它增其生起者、减其止息者，故只在某所列部分生起时上升，只在某一止息时下降。',
     [W + n for n in ['Grade', 'Grade.pos_iff', 'Grade.eq_length_iff', 'Grade.lt_length_of_inactive',
                      'Grade.across_step', 'Grade.arises_of_lt', 'Grade.ceases_of_lt']]
     + ['Counts.lt_length_of_fails', 'Counts.all_of_eq_length']),
    ('A formation active exactly where the grade is at least j arises and ceases only through a listed part. At j one it '
     'is the whole of some listed part, at the number listed the whole of every one, and conversely where activity is '
     'decided; so a whole of every listed part arises and ceases only through a listed part.',
     '恰在等级至少为 j 时活跃的形成，只经由所列部分之生起与止息而生起与止息。j 为一时它是某所列部分之整体，j 为所列之数时是每个部分之整体，'
     '活动可判定时反之亦然；故每个所列部分之整体只经由所列部分而生起与止息。',
     [W + n for n in ['AtLeastWhole', 'AtLeastWhole.arises_part', 'AtLeastWhole.ceases_part', 'AtLeastWhole.whole',
                      'Whole.atLeastWhole', 'AtLeastWhole.allWhole', 'AllWhole.atLeastWhole', 'AllWhole.arises_part',
                      'AllWhole.ceases_part']]),
    ('The whole is diminished where some listed parts are active and not all: where their activity is decided, exactly '
     'where the whole of some is active and the whole of every one is not.',
     '某些所列部分活跃而非全部时，整体是减损的：活动可判定之处，恰是某部分之整体活跃而每个部分之整体不活跃。',
     [W + n for n in ['Diminished', 'Grade.diminished_iff', 'diminished_iff']]),
    ('Witnesses: the lineage of Generations is active at every step while no whole of every member is active at any; a '
     'house of three rafters, the first taken after the first step, ceases with it, and from then on two of three are '
     'active, the whole diminished, what is left standing and the house not.',
     '见证：Generations 的世系每步活跃，而任何每个成员之整体在任何一步都不活跃；三椽之舍，第一椽在第一步之后被取去，舍随之止息，此后三椽中二椽活跃，'
     '整体减损，所余者立而舍不立。',
     ['Generations.allWhole_never'] + ['Rafters.' + n for n in ['Formation', 'rafters', 'web', 'house', 'remains',
                                                                 'decided', 'grade_two', 'taken']]),
]
cited_w = sorted(d for _, _, names in laws_w for d in rw(names))
assert cited_w == NEW_W, (set(NEW_W) - set(cited_w), set(cited_w) - set(NEW_W))
EARLIER_W = rw(['Web.Whole', 'Web.whole_self', 'Web.Whole.arises_part', 'Web.Whole.ends_without_arising',
                'Web.Whole.needs_arising', 'Web.Ends', 'Web.Brief', 'Generations.whole', 'Generations.generations'])

# ---------------------------------------------------------------- SAT1
SRC_S, FULL_S, NEW_S = module('Frequency')
rs = resolver(FULL_S)
S = 'Saturation.'
laws_s = [
    ('What has passed from d into c before a step is defined by recursion, each step\'s strengths read off what had passed '
     'before it; strengths read off it read the levels before, so the carrying law with them generates a course, and what '
     'has passed never falls.',
     '自 d 入 c 在一步之前已传之量以递归定义，每步之强度读自其前已传之量；读自它的强度读先前之水平，故以之为强度的携带之律生成一个进程；已传之量不降。',
     [S + n for n in ['passingAt', 'passed', 'strengths', 'Antitone', 'ZeroFrom', 'scaled',
                      'Antitone.zeroFrom', 'passingAt_congr', 'passed_congr', 'readsBefore', 'passed_le_succ',
                      'passed_le_add', 'passed_mono']]),
    ('Where the strengths are zero once A has passed and A has passed by step N, the coupling stops by N: it does not '
     'recur, nothing more passes, and where every coupling has so saturated a finite order is exact. Where no step passes '
     'more than m, what passes in all is below A + m.',
     '强度在已传 A 之后为零、且至第 N 步已传 A 时，耦合至 N 停止：不复现，无所再传；诸耦合皆如此饱和则有限阶精确。每步所传不过 m 时，所传总量少于 A + m。',
     [S + n for n in ['passingAt_zero', 'stops', 'not_recurs', 'exact', 'passed_from', 'passed_lt']]),
    ('A coupling acting at each step until saturated, from a level that stands, passes one more at each step, so it has '
     'passed A by step A and stops by step A. With strengths f a times a coupling acting at each step, f not rising, it '
     'stops by step A where f is zero at A, and exactly where f reaches zero; floored at one it recurs, and coupled into itself leaves every finite order '
     'inexact.',
     '未饱和时每步作用、源之水平常在的耦合，每步至少多传一，故至第 A 步已传 A 并至第 A 步停止。强度为 f a 乘以每步作用之耦合、f 不升时，'
     '它恰在 f 归零处停止；以一为下限则复现，自耦合时无有限阶处处精确。',
     [S + n for n in ['one_le_passingAt', 'climbs', 'stops_by', 'stops_by_zero', 'stops_iff', 'floored',
                      'floored_inexact']]),
    ('In the formed course, what the formations give splits into the part\'s gaps and what passes through each coupling, '
     'so what has passed is what the course carries through the coupling; a level standing at the start stands '
     'throughout; the coupling stops by its threshold as a step and does not recur, stops exactly where its response '
     'reaches zero, and with the response A - a stops by step A.',
     '在所成进程中，诸形成所给分为部分之差与经每一耦合所传，故已传之量即进程经该耦合所携；起始常在之水平始终常在，耦合至阈值之步停止而不复现，恰在响应归零处停止，响应为 A - a 时至第 A 步停止。',
     [S + n for n in ['carriedGive_split', 'total_carriedGive', 'course_succ', 'course_stands', 'course_stops_by',
                      'course_stops_iff', 'wearing_stops']]),
]
cited_s = sorted(d for _, _, names in laws_s for d in rs(names))
assert cited_s == NEW_S, (set(NEW_S) - set(cited_s), set(cited_s) - set(NEW_S))
EARLIER_S = rs(['StopsBy', 'StopsBy.not_recurs'])
for laws in (laws_w, laws_s):
    for en, zh, _ in laws:
        assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))


def references(src, decls, n):
    return [{'path': src, 'role': 'proof', 'declarations': decls, 'sha256': sha(src)},
            {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
            {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
            {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
            {'path': ZHMAP, 'role': 'integration', 'sha256': sha(ZHMAP)},
            {'path': MAPCH, 'role': 'statement', 'sha256': sha(MAPCH)},
            {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}]


def binding(mod, src):
    return [{'source': src, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
             'success_pointer': '/status', 'success_value': 'passed'}]


def validation(mod, n_new, n):
    return {'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
                  f'Becoming.{mod} gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
                  f'one session; author review in study section {n}; not independently reviewed by a person.',
            'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.{mod} 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
                  f'在一个会话中构建并审查；作者审查见研究第 {n} 节；未经人的独立审查。'}


RID_W = 'a-whole-of-every-part'
RID_S = 'a-coupling-saturated-by-what-it-has-carried'
ZH_REC = 'civilization-thought-on-the-spine'
rec_w = {
    'schema_version': 2, 'id': RID_W,
    'title': {'en': 'A whole of every part, and a graded whole', 'zh': '每个部分之整体与分级之整体'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'A whole active while every part is ends as soon as one part ends; between it and a whole of some part, '
              'the grade of listed parts gains what arises and loses what ceases, so a whole of at least j of them arises '
              'and ceases only through one, and the whole is diminished where some are active, not all.',
        'zh': '每个部分都活跃时才活跃的整体，一个部分终结即终结；它与某部分之整体之间，所列部分之等级增其生起者、减其止息者，故至少 j 个之整体只经由其一生起与止息，'
              '某些活跃而非全部时整体减损。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': rw(names)} for en, zh, names in laws_w],
    'hypotheses': [
        {'en': 'No axiom. Activity a proposition at each step; for the grade, finitely many listed parts whose activity is '
               'decided where the grade is taken (the whole of at least j parts asks a grade at every step, and the '
               'converses from the two wholes ask decided activity); some part where the two wholes are compared; '
               'discrete steps.',
         'zh': '不加公理。每步之活动是一个命题；等级须有限个所列部分，其活动在取等级之处可判定（至少 j 个部分之整体每步要求一个等级，由两种整体之反向要求活动可判定）；'
               '比较两种整体时须有某部分；离散步。'}],
    'does_not_show': [
        {'en': 'Weighted parts, wholes of wholes, or the grade of infinitely many parts.',
         'zh': '加权的部分、整体之整体，或无穷多部分之等级。', 'kind': 'scope'},
        {'en': 'Which whole a given formation is, or which formations are its parts: these are readings.',
         'zh': '某个形成是哪一种整体，或哪些形成是其部分：这些是读法。', 'kind': 'non-implication'},
        {'en': 'That any of the three wholes is constitution rather than coincidence of activity.',
         'zh': '三种整体中任何一种是构成而非活动之相合。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': validation('Wholes', len(NEW_W), N_WH),
    'next_delta': {
        'en': 'Weighted parts and wholes of wholes; an independent review.',
        'zh': '加权的部分与整体之整体；独立审查。'},
    'correspondence': {
        'en': 'Series, parallel and k-out-of-n systems of reliability theory, the life of a series system the least of its '
              'components\' lives (Barlow and Proschan 1975); threshold functions of Boolean logic.',
        'zh': '可靠性理论中的串联、并联与 n 中取 k 系统，串联系统之寿命为诸部件寿命之最小者（Barlow 与 Proschan 1975）；布尔逻辑的阈值函数。'},
    'canonical_source': SRC_W,
    'aliases': ['a whole of every part', 'conjunctive whole', 'graded whole', 'diminished whole', '每个部分之整体',
                '合取的整体', '分级的整体', '减损之整体', 'Becoming.Web.AllWhole', 'Becoming.Web.AtLeastWhole',
                'Becoming.Web.diminished_iff'],
    'dependencies': [
        {'id': 'whole-persists-through-generation', 'relation': 'formal-reuse',
         'detail': {'en': 'Its whole of some part is compared with the whole of every part; its witness Generations shows '
                          'the two apart.',
                    'zh': '其某部分之整体与每个部分之整体相比较；其见证 Generations 显示二者之别。'},
         'interface': {
             'output': {'en': 'Web.Whole, Web.Ends, Web.Brief, Generations.', 'zh': 'Web.Whole、Web.Ends、Web.Brief、Generations。'},
             'input': {'en': 'The whole of some part, with its arising through a part.', 'zh': '某部分之整体及其经由部分之生起。'},
             'conditions': {'en': 'Some part, for the comparison.', 'zh': '比较时须有某部分。'},
             'evidence': SRC_W}}],
    'related': [{'id': ZH_REC, 'detail': {
        'en': 'States the gap its map found in 华严六相 and 墨经「損」 (entries huayan-liu-xiang, mojing-sun-jian-ti, '
              'suzhe-che-bu-ke-shu).',
        'zh': '陈述其对应在华严六相与墨经「損」中发现的缺口（条目 huayan-liu-xiang、mojing-sun-jian-ti、suzhe-che-bu-ke-shu）。'}}],
    'references': references(SRC_W, sorted(NEW_W + EARLIER_W), N_WH),
    'proof_bindings': binding('Wholes', SRC_W),
    'history': [{
        'en': f'22 October 2026: added (WH1), the whole of every part, the grade and the diminished whole, for the gap the '
              f'ZH reading raised; study section {N_WH}.',
        'zh': f'2026年10月22日：新增（WH1），每个部分之整体、等级与减损之整体，补中华思想脉络之读所提出的缺口；研究第 {N_WH} 节。'}],
}
rec_s = {
    'schema_version': 2, 'id': RID_S,
    'title': {'en': 'A coupling saturated by what it has carried', 'zh': '为所传之量所饱和的耦合'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Strengths read off what has passed through a coupling read the levels before; where they are zero once A '
              'has passed, the coupling stops by the step A has passed and a finite order is exact; it stops exactly where '
              'its response reaches zero, and floored at one it recurs.',
        'zh': '读自经耦合已传之量的强度读先前之水平；强度在已传 A 后为零时，耦合至已传 A 之步停止，有限阶精确；耦合恰在其响应归零处停止，以一为下限则复现。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': rs(names)} for en, zh, names in laws_s],
    'hypotheses': [
        {'en': 'No axiom. Whole-number amounts and strengths; strengths read off what has passed, per coupling, the '
               'response given (sat, or f times k); for stopping by the threshold as a step, a coupling acting at each '
               'step until saturated and a level that stands; for the exact line, f not rising; discrete steps.',
         'zh': '不加公理。整数之量与强度；强度按耦合读自已传之量，响应给定（sat，或 f 乘以 k）；至阈值之步停止，须未饱和时每步作用、源之水平常在；'
               '恰在归零处停止，须 f 不升；离散步。'}],
    'does_not_show': [
        {'en': 'That a non-rising response never reaching zero settles at a known step: that needs the limited principle of '
               'omniscience, and is not stated.',
         'zh': '不升而不归零之响应在已知之步定住：这需要有限全知原则，不陈述。', 'kind': 'scope'},
        {'en': 'Recovery after rest; strengths read off what passed through other couplings; amounts beyond whole numbers.',
         'zh': '休止后之恢复；读自经其他耦合所传之量的强度；整数之外的量。', 'kind': 'scope'},
        {'en': 'That use wears any actual coupling this way, or how fast.',
         'zh': '实际的任何耦合因使用而如此耗损，或耗损多快。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': validation('Frequency', len(NEW_S), N_SA),
    'next_delta': {
        'en': 'Recovery after rest; responses to what passed through other couplings; an independent review.',
        'zh': '休止后之恢复；对经其他耦合所传之量的响应；独立审查。'},
    'correspondence': {
        'en': 'Habituation, a response decrement with repeated stimulation (Thompson and Spencer 1966); short-term synaptic '
              'depression, efficacy spent by transmission (Tsodyks and Markram 1997); a budget spent by use.',
        'zh': '习惯化，重复刺激下之反应递减（Thompson 与 Spencer 1966）；突触短时抑制，效能为传递所耗（Tsodyks 与 Markram 1997）；为使用所耗之预算。'},
    'canonical_source': SRC_S,
    'aliases': ['a coupling saturated by what it has carried', 'saturation of a coupling', 'habituation of a coupling',
                '为所传之量所饱和的耦合', '耦合之饱和', 'Becoming.Saturation.stops', 'Becoming.Saturation.stops_iff'],
    'dependencies': [
        {'id': 'how-often-couplings-act', 'relation': 'formal-reuse',
         'detail': {'en': 'A saturated coupling stops by its threshold (StopsBy) and so does not recur.',
                    'zh': '饱和的耦合至其阈值停止（StopsBy），故不复现。'},
         'interface': {
             'output': {'en': 'StopsBy, StopsBy.not_recurs.', 'zh': 'StopsBy、StopsBy.not_recurs。'},
             'input': {'en': 'Strengths read off what has passed.', 'zh': '读自已传之量的强度。'},
             'conditions': {'en': 'The strengths zero from an amount on, that amount passed.', 'zh': '强度自某量起为零，且该量已传。'},
             'evidence': SRC_S}},
        {'id': 'what-a-cut-loses', 'relation': 'formal-reuse',
         'detail': {'en': 'Where every coupling has saturated, a finite order is exact (exact_of_reading_before); a floored '
                          'self-coupling leaves every one inexact (unbounded_of_recurring_loop).',
                    'zh': '诸耦合皆饱和时有限阶精确（exact_of_reading_before）；以一为下限的自耦合使每一有限阶都不精确（unbounded_of_recurring_loop）。'},
         'interface': {
             'output': {'en': 'exact_of_reading_before, unbounded_of_recurring_loop.',
                        'zh': 'exact_of_reading_before、unbounded_of_recurring_loop。'},
             'input': {'en': 'Couplings stopping by a step, or recurring.', 'zh': '至某步停止或复现的耦合。'},
             'conditions': {'en': 'As each law states.', 'zh': '如各律所述。'},
             'evidence': SRC_S}},
        {'id': 'how-loops-form', 'relation': 'formal-reuse',
         'detail': {'en': 'The saturated strengths read before, so the carrying law with them generates a course '
                          '(formedCourse_succ).',
                    'zh': '饱和之强度读先前，故以之为强度的携带之律生成一个进程（formedCourse_succ）。'},
         'interface': {
             'output': {'en': 'ReadsBefore, formedCourse, formedCourse_succ.', 'zh': 'ReadsBefore、formedCourse、formedCourse_succ。'},
             'input': {'en': 'Strengths read off what has passed.', 'zh': '读自已传之量的强度。'},
             'conditions': {'en': 'Reading before.', 'zh': '读先前。'},
             'evidence': SRC_S}}],
    'related': [{'id': ZH_REC, 'detail': {
        'en': 'States the gap its map found in 老子七十二章 and 韩非解老 (entries lao-72-min-bu-wei-wei, '
              'jielao-shi-qiang-mu-buming).',
        'zh': '陈述其对应在老子七十二章与韩非解老中发现的缺口（条目 lao-72-min-bu-wei-wei、jielao-shi-qiang-mu-buming）。'}}],
    'references': references(SRC_S, sorted(NEW_S + EARLIER_S), N_SA),
    'proof_bindings': binding('Frequency', SRC_S),
    'history': [{
        'en': f'22 October 2026: added (SAT1), strengths read off what has passed through each coupling, and when the '
              f'coupling stops, for the gap the ZH reading raised; study section {N_SA}.',
        'zh': f'2026年10月22日：新增（SAT1），读自经每一耦合已传之量的强度，及耦合何时停止，补中华思想脉络之读所提出的缺口；研究第 {N_SA} 节。'}],
}
for rec in (rec_w, rec_s):
    assert not (RECORDS / f'{rec["id"]}.json').exists(), 'record exists'
    assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (
        rec['id'], len(rec['statement']['en']), len(rec['statement']['zh']))
    for h in rec['hypotheses']:
        assert len(h['en']) <= 420, len(h['en'])
    for h in rec['does_not_show']:
        assert len(h['en']) <= 240, len(h['en'])

loaded = {}
for rid, other, en, zh, section in (
        ('whole-persists-through-generation', RID_W,
         'The whole of every part, beside this whole of some part: it ends as soon as one part ends; the grade and the '
         'diminished whole lie between them.',
         '每个部分之整体，与此某部分之整体并立：一个部分终结它即终结；等级与减损之整体在二者之间。', N_WH),
        ('how-often-couplings-act', RID_S,
         'A coupling saturated by what it has carried stops by the step its strength reaches zero (StopsBy), and floored at '
         'one recurs.',
         '为所传之量所饱和的耦合至其强度归零之步停止（StopsBy），以一为下限则复现。', N_SA)):
    d = json.loads((RECORDS / f'{rid}.json').read_text())
    d['related'] = d.get('related', []) + [{'id': other, 'detail': {'en': en, 'zh': zh}}]
    d['history'].append({
        'en': f'22 October 2026: related to {other} (study section {section}); its statements are unchanged.',
        'zh': f'2026年10月22日：与 {other} 相关（研究第 {section} 节）；其陈述不变。'})
    loaded[rid] = d
d = json.loads((RECORDS / f'{ZH_REC}.json').read_text())
for lang, old_ in (('en', 'a conjunctive or graded whole; saturation of a coupling by what it has carried; '),
                   ('zh', '合取或分级的整体；耦合随已传之量而饱和；')):
    assert d['next_delta'][lang].count(old_) == 1, (ZH_REC, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['related'] = d.get('related', []) + [
    {'id': RID_W, 'detail': {'en': 'States the conjunctive and the graded whole its map found missing (WH1).',
                             'zh': '陈述其对应所缺的合取与分级之整体（WH1）。'}},
    {'id': RID_S, 'detail': {'en': 'States the saturation of a coupling its map found missing (SAT1).',
                             'zh': '陈述其对应所缺的耦合之饱和（SAT1）。'}}]
d['history'].append({
    'en': f'22 October 2026, WH1 and SAT1: the first two gaps, a conjunctive or graded whole and saturation of a coupling, '
          f'are stated (records {RID_W}, {RID_S}; study sections {N_WH} and {N_SA}); the five entries naming them read the '
          f'new laws and their gap notes point to them. The map\'s kinds and counts are unchanged.',
    'zh': f'2026年10月22日，WH1 与 SAT1：前两个缺口，合取或分级之整体与耦合之饱和，已陈述（记录 {RID_W}、{RID_S}；研究第 {N_WH}、{N_SA} 节）；'
          f'述及它们的五个条目读新律，其 gap 注指向新律。对应之类别与计数不变。'})
loaded[ZH_REC] = d

for rec in (rec_w, rec_s):
    (RECORDS / f'{rec["id"]}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('written', rec['id'], len(rec['references'][0]['declarations']), 'declarations cited')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
