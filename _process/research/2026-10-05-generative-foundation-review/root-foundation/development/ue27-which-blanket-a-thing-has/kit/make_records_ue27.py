#!/usr/bin/env python3
"""UE27's records: a-formations-couplings-as-its-blanket (Becoming.BlanketCouplings, home 03 §1 after the blanket's
reading), each declaration of the module cited once; and the blanket's record the-markov-blanket-as-a-coupling-structure
amended: its does_not_show entry on a World formation in general narrowed to the formation's own record as the internal
part, its next_delta brought to what UE27 leaves, a related entry and a history entry (no statement, law or declaration
changed). Asserts the core receipt's hash of BlanketCouplings and Blanket and the module's empty axiom reports, and the
style caps and lint (tools/research/style.py) on every field written. Mirrors UE26's make_records_ue26.py.
usage (from the checkout root, after the texts are in place): python3 -B make_records_ue27.py CORE N
       python3 -B make_records_ue27.py --caps [PREVIEW]  (caps, lint and declaration cover against the scratch audit;
                                                writes nothing, or with PREVIEW the two records into that folder)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
if CAPS_ONLY:
    CORE_ID_R, N = '20261101T000000.000000Z', 490
else:
    CORE_ID_R, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
WORK = RFD + 'development/ue27-which-blanket-a-thing-has/'
DESIGN, REVIEW, LEANREVIEW = WORK + 'DESIGN.md', WORK + 'REVIEW-UE27-DESIGN.md', WORK + 'REVIEW-UE27-LEAN.md'
LANDREVIEW = WORK + 'REVIEW-UE27-LANDING.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
PAGE = 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
LEAN = f'{PKG}/Becoming/BlanketCouplings.lean'
BLANKET = f'{PKG}/Becoming/Blanket.lean'
CORE_RECEIPT = f'{PKG}/becoming-checks/{CORE_ID_R}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
RID = 'a-formations-couplings-as-its-blanket'
BLANKET_RID = 'the-markov-blanket-as-a-coupling-structure'
P = 'Becoming.BlanketCouplings.'


def sha(path):
    if CAPS_ONLY and not (ROOT / path).exists():
        return '0' * 64
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


OVER = []


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    if not (len(pair['en']) <= en and len(pair['zh']) <= zh):
        OVER.append((field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60]))
    return pair


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


audit = (HERE.parent / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean').read_text(encoding='utf-8')
core_names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
COUNT = (99, 99)  # for --caps, counts of the width the receipt gives
if not CAPS_ONLY:
    core = json.loads((ROOT / CORE_RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.BlanketCouplings'] == sha(LEAN)
    assert core['source_sha256']['Becoming.Blanket'] == sha(BLANKET)
    mod = next(x for x in core['modules'] if x['module'] == 'Becoming.BlanketCouplings')
    assert not any(mod['axiom_dependencies'].values())
    assert {d['name'] for d in mod['declarations']} == core_names, 'the receipt and the scratch audit differ'
    COUNT = (mod['theorems'], len(mod['declarations']))


def law(en, zh, *decls):
    return capped('laws', {'en': en, 'zh': zh, 'declarations': [P + d for d in decls]}, item=True)


def pair(en, zh, field, item=False, **extra):
    return capped(field, {'en': en, 'zh': zh, **extra}, item=item)


LAWS = [
    law("The coupling law: where a formation's couplings give the values of what couples into it, any model and policy, "
        "and any environment, which may read the act, make a blanketed law whose sensory part's next state is the value "
        "of what couples in at the step, the step on the world's side; its sensory course is the formation's own "
        "course through its couplings under its own level history (sensory_course and four more).",
        "耦合之律：一形成之耦合予耦合入者之值，则任一模型、策略与环境（可读其作为）成一毯化之律，感官部分之次态为当步耦合入者之值，步在世界一侧；其感官历程即该形成于"
        "自身层级历史下经其耦合之自身历程（sensory_course 等五项）。",
        'couplingLaw', 'startAt', 'clock', 'ownLevels', 'sensory_course'),
    law("Two of its courses from one agent are alike on the blanket before n + 2 exactly where their own level "
        "histories are alike through the couplings up to n, the environment reading the act or not; then their "
        "internal courses agree up to n + 2. In the closed loop both sides are read off one course "
        "(blanket_iff_through, internal_through_couplings).",
        "同一主体之二历程于 n + 2 前于毯上相同，恰当其自身层级历史至 n 经耦合相同，环境读其作为与否皆然；此时其内部历程至 n + 2 相合。闭环中两侧读自同一历程"
        "（blanket_iff_through、internal_through_couplings）。",
        'blanket_iff_through', 'internal_through_couplings'),
    law("In the open loop, the act moving no level, every reading of the internal course up to n + 2 is a selection "
        "through the formation's couplings up to n, whatever the model and the policy "
        "(internal_selectsThrough and five more).",
        "开环中（作为不移层级），无论模型与策略，内部历程至 n + 2 之每一读皆为经该形成之耦合至 n 之选择（internal_selectsThrough 等六项）。",
        'levelsAt', 'levelsStay', 'openLoop', 'open_external', 'open_levels', 'internal_selectsThrough'),
    law("The threshold witness's join is its case: at the witness's web, with the supply as the environment state beside the "
        "step, the two courses correspond part by part and the witness's blanket_iff_through follows "
        "(ThresholdCase.threshold_case and ten more).",
        "阈之例之相接为其一例：于例之网，供给为步旁之环境态，二历程逐部分相应，例之 blanket_iff_through 由之而得（ThresholdCase.threshold_case 等十一项）。",
        'ThresholdCase.value', 'ThresholdCase.lev', 'ThresholdCase.env', 'ThresholdCase.update', 'ThresholdCase.policy',
        'ThresholdCase.band_congr', 'ThresholdCase.admits_iff', 'ThresholdCase.values', 'ThresholdCase.corr',
        'ThresholdCase.own_eq', 'ThresholdCase.threshold_case'),
    law("A part of the next configuration depends only on a reading where configurations agreeing under one map go, "
        "under one move, to ones agreeing under another; DependsOnlyOn and GoAlike are cases by definition, and "
        "Determined is equivalent to the case where both are the identity; the law a family shows has such a part exactly where the family is consistent under the "
        "two maps (shownBy_partDependsOnlyOn_iff and five more).",
        "次构型之一部分唯依一读：于一映射下相合之构型，经同一移，至于另一映射下相合者；DependsOnlyOn 与 GoAlike 依定义为其例，Determined 等价于二映射皆为恒等之例；族所示之律有此部分，"
        "恰当族于二映射下一致（shownBy_partDependsOnlyOn_iff 等六项）。",
        'PartDependsOnlyOn', 'partDependsOnlyOn_id_iff', 'PartConsistentFamily', 'shownBy_partDependsOnlyOn_iff',
        'PartDependsOnlyOn.of_le', 'PartConsistentFamily.mono'),
    law("A law determined part by part, the agent's parts by what the agent reads and the world's by what the world "
        "reads, moves kept, partial or not, is the blanket's form on the law a family shows: a family is admitted by "
        "one exactly where it is consistent part by part, and such a law is determined (admitted_iff and six more).",
        "逐部分确定之律（主体诸部分依主体所读，世界诸部分依世界所读，保留诸移，偏或全）为族所示之律上之毯之形：一族为此律所容，恰当其逐部分一致；此律确定"
        "（admitted_iff 等七项）。",
        'BlanketDetermined', 'BlanketConsistentFamily', 'shownBy_blanketDetermined_iff', 'BlanketDetermined.of_le',
        'BlanketConsistentFamily.mono', 'admitted_iff', 'BlanketDetermined.determined'),
    law("A blanketed law, read as a process with the trivial move, is determined part by part, and its courses form "
        "a family consistent part by part; the converse needs a next state at every reading no course shows, and is "
        "not stated (blanketed_courses_consistent and two more).",
        "毯化之律作为平凡之移之过程逐部分确定，其诸历程成逐部分一致之族；逆向需于无历程所示之每一读择一次态，未陈（blanketed_courses_consistent 等三项）。",
        'blanketed_determined', 'blanketed_step_alike', 'blanketed_courses_consistent'),
    law("Parts and pairs agreeing piece by piece are one; what each side reads and its parts "
        "(parts_eq and six more).",
        "诸部分与对逐件相合则为一；每侧所读及其诸部分（parts_eq 等七项）。",
        'parts_eq', 'pair_eq', 'unit_eq', 'agentReads', 'agentParts', 'worldReads', 'worldParts'),
    law("Readings of the course: with which course and the step in the external part, every family of courses is a blanketed law's "
        "course family, consistent or not; a reading of the course's future, no clock, does it for every course; with "
        "the step alone two courses alike at steps 0 and 1 parting at 2 have no law determined part by part "
        "(clock_only_fails and twelve more).",
        "历程之读：外部持哪一历程与步，则每一历程之族皆为一毯化之律之历程族，一致与否；读历程之未来（无时钟）亦于每一历程然；唯持步，则于第 0、1 步相同、第 2 步分离之二历程"
        "无逐部分确定之律（clock_only_fails 等十三项）。",
        'clocked', 'clocked_course', 'clocked_consistent', 'parting', 'clocked_witness', 'partingLate',
        'clock_only_fails', 'shift', 'suffix', 'suffix_apply', 'suffix_zero', 'future', 'future_course'),
    law("Readings of the configuration: the constant reading gives every family the blanket's form, the whole "
        "configuration as the internal part exactly the families whose law is determined; any injective reading gives "
        "it only where the law is determined, and not always there (whole_iff and five more).",
        "构型之读：常值之读予每一族以毯之形，整个构型为内部部分则恰予其律确定之族；任一单射之读唯于律确定处予之，且其处未必予（whole_iff 等六项）。",
        'readFamily', 'const_consistent', 'injective_consistent', 'whole', 'whole_iff', 'injective_converse_fails'),
    law("A sparse partition fixed apart from the family, on a law the same at every step, can be refuted by one run: "
        "in a run whose internal part's next state is whether the external part, cycling through three values, is at "
        "its first, the run is the course of no blanketed law on its four parts, while the whole configuration reads it "
        "in the blanket's form (ReadsExternal.not_blanketed and nine more).",
        "独立于族而定之稀疏之分，于每步皆同之律，可为一运行所驳：内部部分读外部部分（三值循环）是否处其首之运行，于其自身之分下非其四部分上任一毯化之律之历程，于整个构型下则成毯之形"
        "（ReadsExternal.not_blanketed 等十项）。",
        'ReadsExternal.Three', 'ReadsExternal.next', 'ReadsExternal.isFirst', 'ReadsExternal.step',
        'ReadsExternal.start', 'ReadsExternal.run', 'ReadsExternal.internal_course', 'ReadsExternal.not_consistent',
        'ReadsExternal.not_blanketed', 'ReadsExternal.whole_consistent'),
]
assert len(LAWS) == 11
cited = [d for x in LAWS for d in x['declarations']]
assert len(cited) == len(set(cited)), 'a declaration cited twice'
assert set(cited) == core_names, (sorted(core_names - set(cited)), sorted(set(cited) - core_names))
core_cited = sorted(cited)
cc = f'{COUNT[0]} theorems in {COUNT[1]} declarations' if COUNT else 'the theorems'
cc_zh = f'{COUNT[0]} 条定理，{COUNT[1]} 项声明' if COUNT else '诸定理'
REVIEWED = ("Reviewed by other AI agents: the design (REVIEW-UE27-DESIGN, fifteen findings), the scratch Lean "
            "(REVIEW-UE27-LEAN, fifteen, with its probe) and the landing texts and records (REVIEW-UE27-LANDING, "
            "twenty-two), every finding taken")
REVIEWED_ZH = ('他 AI 代理审之：设计（REVIEW-UE27-DESIGN，十五条）、草稿 Lean（REVIEW-UE27-LEAN，十五条）、落地文本与记录'
               '（REVIEW-UE27-LANDING，二十二条），凡所见皆取')

record = {
    'schema_version': 2, 'id': RID,
    'title': pair("A formation's couplings as its blanket, and when a blanket constrains",
                  '形成之耦合为其毯，及毯何时有所约束', 'title'),
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': pair(
        "Any model fed by what couples into a formation is by construction the agent of a blanketed law whose "
        "sensory course is the formation's own course; a degenerate reading refutes no family whose law is "
        "determined, while a sparse partition fixed apart from the family can be refuted by one run.",
        '以耦合入一形成者为食之任一模型，依构造为一毯化之律之主体，其感官历程即该形成之自身历程；退化之读不驳任何其律确定之族，而独立于族而定之稀疏之分可为一运行所驳。',
        'statement'),
    'laws': LAWS,
    'hypotheses': [
        pair("No axiom. Any web, formation and couplings by level, supplied, whose values the web's admission and "
             "the levels give (ValuesThrough); any model, policy, environment state, levels and environment step.",
             '不加公理。任一网、形成与所给之层级耦合，其值由网之准入与层级所予（ValuesThrough）；任一模型、策略、环境态、层级与环境之步。',
             'hypotheses', item=True),
        pair("For the readings: any family of courses with moves, and any map from configurations to four parts, "
             "read by one map at every step of a law the same at every step.",
             '诸读：任一带移之历程之族，及自构型至四部分之任一映射，于每步皆同之律之每一步以同一映射读之。', 'hypotheses', item=True),
        pair("Modelling choices: discrete synchronous steps; determined laws; the four parts of types in Type; the "
             "blanket as sparse coupling, not conditional independence; which map a thing's partition is read by is "
             "not derived.",
             '建模之选择：离散同步之步；确定之律；四部分之类型在 Type；毯为稀疏耦合，非条件独立；物之分以何映射而读，未推出。',
             'hypotheses', item=True),
    ],
    'does_not_show': [
        pair("That having the coupling law constrains a formation's course: it is a construction, the step on the "
             "world's side and the environment arbitrary.",
             '具耦合之律约束形成之历程：此为构造，步在世界一侧，环境任意。', 'does_not_show', item=True,
             kind='non-implication'),
        pair("The formation's own record as the internal part: the agent is a model fed by what couples in.",
             '形成自身之记录为内部部分：主体乃以耦合入者为食之模型。', 'does_not_show', item=True, kind='scope'),
        pair("The World's own exchange as an environment: the World's case is the open loop, the closed loop a model "
             "beside it.",
             '世界自身之交换为环境：世界之情形为开环，闭环为其旁之模型。', 'does_not_show', item=True, kind='scope'),
        pair("A blanketed law for every family consistent part by part: a next state at every reading no course "
             "shows is needed.",
             '每一逐部分一致之族皆有毯化之律：需于无历程所示之每一读择一次态。', 'does_not_show', item=True, kind='scope'),
        pair("That the principle is wrong: no sentence of its literature is forbidden here.",
             '原理有误：此处不禁其文献之任何语句。', 'does_not_show', item=True, kind='non-implication'),
    ],
    'counterexamples': [
        {'path': LEAN, 'detail': {
            'en': "The run whose internal part's next state is whether the external part, cycling through three "
                  "values, is at its first is the course of no blanketed law on its four parts "
                  "(ReadsExternal.not_blanketed).",
            'zh': '内部部分之次态为外部部分（三值循环）是否处其首之运行，非其四部分上任一毯化之律之历程（ReadsExternal.not_blanketed）。'}},
        {'path': LEAN, 'detail': {
            'en': "With the step but not which course outside, two courses alike at steps 0 and 1 and parting at 2 "
                  "have no law determined part by part (clock_only_fails).",
            'zh': '外部持步而不持哪一历程，则于第 0、1 步相同、第 2 步分离之二历程无逐部分确定之律（clock_only_fails）。'}},
        {'path': LEAN, 'detail': {
            'en': "Under the identity reading, injective, a run whose law is determined is not consistent part by part "
                  "(injective_converse_fails).",
            'zh': '于恒等之读（单射）下，律确定之运行非逐部分一致（injective_converse_fails）。'}},
        {'path': LEAN, 'detail': {
            'en': "Two courses from one value parting at their first step: the family is not consistent, its clocked "
                  "reading consistent part by part (clocked_witness).",
            'zh': '自一值出发、于首步分离之二历程：族不一致，而其带时钟之读逐部分一致（clocked_witness）。'}},
    ],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': pair(
        f"Pure core, every axiom report empty (core receipt {CORE_ID_R}): BlanketCouplings ({cc}) imports Blanket, "
        "Histories and IdentificationRuns, a leaf; comparisons by matching and congrArg, no decide. One result in three "
        "parts, each near-definitional; the classification is the delta. " + REVIEWED + f"; study section {N}; not "
        "reviewed by a person.",
        f'纯核，公理报告皆空（核心回执 {CORE_ID_R}）：BlanketCouplings（{cc_zh}）引 Blanket、Histories 与 IdentificationRuns，为叶。'
        '一结果三部分，皆近乎定义；分类为其增量。' + REVIEWED_ZH + f'；研究第 {N} 节；未经人审。',
        'validation_scope'),
    'next_delta': pair(
        "The formation's own record as the internal part of a blanketed law; a blanketed law for a family consistent "
        "part by part, with a choice at the readings no course shows; review by a person.",
        '形成自身之记录为毯化之律之内部部分；逐部分一致之族之毯化之律（于无历程所示之读择之）；人之审查。',
        'next_delta'),
    'correspondence': pair(
        "The principle defines a thing by its Markov blanket (Friston 2013, 2019; Kirchhoff, Parr, Palacios, Friston "
        "and Kiverstein 2018). That a blanket depends on how a partition is read is argued in words: Pearl's blankets, "
        "fixed within a model, against Friston's, read as a thing's boundary (Bruineberg, Dołęga, Dewhurst and Baltieri "
        "2022). The wider criticism: a formalism applying to any domain is a narrower account of life and mind than "
        "claimed (Raja, Valluri, Baggs, Chemero and Anderson 2021); the statistical and dynamical definitions are not "
        "equivalent (Biehl, Pollock and Kanai 2021); the proponents class the existence claim with principles of "
        "stationary action, not falsifiable strictly speaking (Ramstead and others 2023). The coupling form is the "
        "deterministic case of the time-unrolled blanket (Virgo, Rosas and Biehl 2022); since that blanket compares "
        "courses from one start, a single run constrains nothing under it. The single-run witness is of the kind of "
        "Hexagram.runsOrder_reads. AI reading: which blanket a thing has is how its parts are read; the join is a "
        "construction and forbids nothing of the formation's course. The readings are the AI's, in DESIGN.md.",
        '原理以马尔可夫毯定一物（Friston 2013、2019；Kirchhoff、Parr、Palacios、Friston、Kiverstein 2018）。毯依分之读法，已以言论之：Pearl 之毯定于模型之内，'
        '与 Friston 之毯读为物之界相对（Bruineberg、Dołęga、Dewhurst、Baltieri 2022）。更广之批评：适用于任何领域之形式，作为生命与心智之说明较所称者为窄（Raja 等 2021）；'
        '统计与动力之定义不等价（Biehl、Pollock、Kanai 2021）；倡之者将存在之主张归于驻定作用之原理，严格言之不可证伪（Ramstead 等 2023）。耦合之形即时间展开之毯之确定情形'
        '（Virgo、Rosas、Biehl 2022）；该毯比较同一起点之诸历程，故其下单一运行无所约束。单一运行之见证与 Hexagram.runsOrder_reads 同类。AI 之读：物有何毯，在其诸部分如何读；'
        '相接乃构造，不禁该形成之历程之任何事。读法皆 AI 之读，载于 DESIGN.md。',
        'correspondence'),
    'canonical_source': LEAN,
    'aliases': ["A formation's couplings as its blanket", '形成之耦合为其毯', 'which blanket a thing has',
                'when a blanket constrains', 'Becoming.BlanketCouplings.blanket_iff_through',
                'Becoming.BlanketCouplings.ReadsExternal.not_blanketed'],
    'dependencies': [
        {'id': BLANKET_RID, 'relation': 'formal-reuse', 'detail': {
            'en': 'Blanket.Blanketed, its course, agent_through_sensory and internal_through_blanket; '
                  'ThresholdDrain, whose join is the coupling law\'s case.',
            'zh': 'Blanket.Blanketed、其历程、agent_through_sensory 与 internal_through_blanket；ThresholdDrain，其相接为耦合之律之一例。'}},
        {'id': 'a-formations-own-course', 'relation': 'formal-reuse', 'detail': {
            'en': 'Web.ValuesThrough, courseThrough, AlikeThroughUpTo, SelectsThrough and alikeThrough_iff: the '
                  'formation\'s own course through its couplings, which the sensory course is.',
            'zh': 'Web.ValuesThrough、courseThrough、AlikeThroughUpTo、SelectsThrough 与 alikeThrough_iff：形成经其耦合之自身历程，即感官历程。'}},
        {'id': 'histories-fix-law-up-to-dead-ends', 'relation': 'formal-reuse', 'detail': {
            'en': 'ShownBy, ConsistentFamily, Admits, shownBy_le_iff and shownBy_determined_iff: the law a family shows, '
                  'read part by part.',
            'zh': 'ShownBy、ConsistentFamily、Admits、shownBy_le_iff 与 shownBy_determined_iff：族所示之律，逐部分而读。'}},
    ],
    'related': [
        {'id': 'hexagram-arrangements-and-laws', 'detail': {
            'en': 'Hexagram.runsOrder_reads: a line-by-line reading of a law the same at every step refuted, the same '
                  'kind of witness as ReadsExternal.',
            'zh': 'Hexagram.runsOrder_reads：逐爻之读于每步皆同之律上被驳，与 ReadsExternal 同类之见证。'}},
        {'id': 'the-blanket-at-a-steady-state', 'detail': {
            'en': 'The blanket\'s statistical form; this record states the coupling form\'s existence and when it '
                  'constrains.',
            'zh': '毯之统计之形；本记录陈耦合之形之存在及其何时有所约束。'}},
        {'id': 'what-the-existence-claim-forbids', 'detail': {
            'en': 'The existence claim\'s weighting form, which forbids only with a weighting fixed apart from the '
                  'course; the coupling form is refuted under a sparse partition fixed apart from the family, a '
                  'degenerate reading refuting no family whose law is determined.',
            'zh': '存在之主张之权之形，唯以独立于历程而定之权禁之；耦合之形于独立于族而定之稀疏之分下被驳，退化之读不驳任何其律确定之族。'}},
    ],
    'references': [{'path': LEAN, 'role': 'proof', 'declarations': core_cited, 'sha256': sha(LEAN)},
                   {'path': CORE_RECEIPT, 'role': 'receipt', 'sha256': sha(CORE_RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': LEANREVIEW, 'role': 'integration', 'sha256': sha(LEANREVIEW)},
                   {'path': LANDREVIEW, 'role': 'integration', 'sha256': sha(LANDREVIEW)},
                   {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)},
                   {'path': PAGE, 'role': 'integration', 'sha256': sha(PAGE)}],
    'proof_bindings': [{'source': LEAN, 'receipt': CORE_RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.BlanketCouplings',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (UE27), which blanket a thing has: any model fed by what couples into a '
                       'formation is by construction the agent of a blanketed law whose sensory course is the '
                       'formation\'s own course, the threshold witness\'s join its case; the three levels at which a '
                       'blanket\'s existence constrains; after reviews of the design, the Lean and the landing texts, '
                       f'every finding taken; study section {N}.',
                 'zh': f'{DATE_ZH}：新增（UE27），物有何毯：以耦合入一形成者为食之任一模型依构造为一毯化之律之主体，其感官历程即该形成之自身历程，阈之例之相接为其一例；'
                       f'毯之存在有所约束之三层；经设计、Lean 与落地文本之审查，凡所见皆取；研究第 {N} 节。'}],
}
assert not lint_errors({k: record[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                               'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                       | {'counterexamples': [{'detail': x['detail']} for x in record['counterexamples']]}), RID
for x in record['related'] + record['dependencies']:
    assert (RECORDS / f"{x['id']}.json").exists(), x['id']

# --- the blanket's record: the World formation in general narrowed -------------------------------------------------
path = RECORDS / f'{BLANKET_RID}.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert RID not in {x['id'] for x in d['related']}
OLD_DNS = "A World formation in general as the agent of a blanketed law: the join is proved for the witness only."
at = [i for i, x in enumerate(d['does_not_show']) if x['en'] == OLD_DNS]
assert len(at) == 1, at
d['does_not_show'][at[0]] = pair(
    "A formation's own record as the internal part of a blanketed law: for any formation the agent is a model fed by "
    "what couples in (a-formations-couplings-as-its-blanket).",
    '形成自身之记录为毯化之律之内部部分：于任一形成，主体乃以耦合入者为食之模型（a-formations-couplings-as-its-blanket）。',
    'does_not_show', item=True, kind='scope')
OLD_ND = ("A World formation in general as the agent of a blanketed law, its sensory course its own course; the "
          "threshold-reading policy unable to draw on a larger supply; review by a person.")
assert d['next_delta']['en'] == OLD_ND, d['next_delta']['en']
d['next_delta'] = pair(
    "A formation's own record as the internal part of a blanketed law; the threshold-reading policy unable to draw "
    "on a larger supply; review by a person.",
    '形成自身之记录为毯化之律之内部部分；以阈读之策略不能取用更大之供给；人之审查。', 'next_delta')
d['related'].append({'id': RID, 'detail': {
    'en': 'A formation\'s couplings as its blanket, any model fed by them the agent by construction, the witness\'s '
          'join its case; and when a blanket\'s existence constrains.',
    'zh': '形成之耦合为其毯，以之为食之任一模型依构造为主体，例之相接为其一例；及毯之存在何时有所约束。'}})
d['history'].append({
    'en': f'{DATE_EN}, board item UE27 (study section {N}): the World formation in general, not shown, narrowed to a '
          f'formation\'s own record as the internal part, any model fed by a formation\'s couplings being the agent '
          f'of a blanketed law by construction ({RID}); next step brought to it; related to {RID}; no statement, law or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE27（研究第 {N} 节）：一般之世界形成（未示）收窄为形成自身之记录为内部部分，以形成之耦合为食之任一模型依构造为一毯化之律之主体（{RID}）；'
          f'下一步随之；与 {RID} 相关联；无一陈述、律或声明改变。'})
assert not lint_errors({k: d[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                          'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                       | {'counterexamples': [{'detail': x['detail']} for x in d['counterexamples']]}), BLANKET_RID
assert not OVER, OVER
print(f'caps: {RID} ok, {len(core_cited)} declarations in {len(LAWS)} laws; {BLANKET_RID} ok')
if CAPS_ONLY and len(sys.argv) > 2:  # --caps PREVIEW: the two records written to PREVIEW for review
    preview = Path(sys.argv[2])
    preview.mkdir(parents=True, exist_ok=True)
    for rec in (record, d):
        (preview / f"{rec['id']}.json").write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n',
                                                  encoding='utf-8')
    print('preview written to', preview)
if CAPS_ONLY:
    raise SystemExit(0)

path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record amended:', BLANKET_RID)
out = RECORDS / f'{RID}.json'
assert not out.exists(), out
out.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID)
