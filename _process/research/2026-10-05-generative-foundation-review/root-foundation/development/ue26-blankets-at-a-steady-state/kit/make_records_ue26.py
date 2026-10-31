#!/usr/bin/env python3
"""UE26's records: the-blanket-at-a-steady-state (Becoming.BlanketWeights, home 03 §1 after the blanket) and
the-blanket-in-a-linear-steady-state (the periphery's LinearBlankets, beside it), each declaration of each module
cited once; and the blanket's record the-markov-blanket-as-a-coupling-structure naming both (related entries and a
history entry; no statement, next step or declaration changed). Asserts the core receipt's hash of BlanketWeights and
its empty axiom reports, the periphery receipt's hashes of LinearBlankets and Becoming.Blanket, its declarations
against periphery/declarations.txt and their standard axioms, and the style caps and lint (tools/research/style.py) on
every field written. Mirrors UE25's make_records_ue25.py and UE24's make_records_ue24.py.
usage (from the checkout root, after the texts are in place): python3 -B make_records_ue26.py CORE LINEAR N
       python3 -B make_records_ue26.py --caps [PREVIEW]  (caps, lint and declaration cover against the kit's scratch
                                                audit and periphery/declarations.txt; writes nothing, or with PREVIEW
                                                the three records into that folder, outside the records)"""
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
    CORE_ID_R, LINEAR_ID_R, N = '20261101T000000.000000Z', '20261101T000000.000000Z', 480
else:
    CORE_ID_R, LINEAR_ID_R, N = sys.argv[1], sys.argv[2], int(sys.argv[3])
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG, FE = f'{LEANR}/becoming', f'{LEANR}/free-energy'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
WORK = RFD + 'development/ue26-blankets-at-a-steady-state/'
LANDREVIEW = WORK + 'REVIEW-UE26-LANDING.md'
DESIGN, REVIEW, RECHECK, LIT = (WORK + 'DESIGN.md', WORK + 'REVIEW-UE26-DESIGN.md', WORK + 'RECHECK-UE26.md',
                                WORK + 'LITERATURE-CHECK.md')
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
PAGE = 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
LEAN = f'{PKG}/Becoming/BlanketWeights.lean'
BLANKET = f'{PKG}/Becoming/Blanket.lean'
LINEAR = f'{FE}/LinearBlankets.lean'
CORE_RECEIPT = f'{PKG}/becoming-checks/{CORE_ID_R}/verification.json'
LINEAR_RECEIPT = f'{FE}/linear-blankets-checks/{LINEAR_ID_R}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
CORE_RID, LINEAR_RID = 'the-blanket-at-a-steady-state', 'the-blanket-in-a-linear-steady-state'
BLANKET_RID = 'the-markov-blanket-as-a-coupling-structure'
P, L = 'Becoming.BlanketWeights.', 'Becoming.LinearBlankets.'
STANDARD = {'propext', 'Classical.choice', 'Quot.sound'}


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


audit = (HERE / 'tree/.build/BecomingBlanketWeightsAxiomAudit.lean').read_text(encoding='utf-8')
core_names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
linear_names = set((HERE / 'periphery/declarations.txt').read_text(encoding='utf-8').split())
COUNT_CORE = COUNT_LINEAR = None
if not CAPS_ONLY:
    core = json.loads((ROOT / CORE_RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.BlanketWeights'] == sha(LEAN)
    assert core['source_sha256']['Becoming.Blanket'] == sha(BLANKET)
    mod = next(x for x in core['modules'] if x['module'] == 'Becoming.BlanketWeights')
    assert not any(mod['axiom_dependencies'].values())
    assert {d['name'] for d in mod['declarations']} == core_names, 'the receipt and the kit\'s audit differ'
    COUNT_CORE = (mod['theorems'], len(mod['declarations']))
    lin = json.loads((ROOT / LINEAR_RECEIPT).read_text())
    assert lin['status'] == 'passed' and lin['bridge_module'] == 'LinearBlankets'
    assert lin['source_sha256']['LinearBlankets'] == sha(LINEAR), 'the module changed since the receipt'
    assert lin['source_sha256']['Becoming.Blanket'] == sha(BLANKET)
    lmod = lin['modules'][0]
    assert {d['name'] for d in lmod['declarations']} == linear_names, 'the periphery receipt and the kit differ'
    assert all(set(a) <= STANDARD for a in lmod['axiom_dependencies'].values())
    COUNT_LINEAR = (lmod['theorems'], len(lmod['declarations']))


def law(prefix, en, zh, *decls):
    return capped('laws', {'en': en, 'zh': zh, 'declarations': [prefix + d for d in decls]}, item=True)


def pair(en, zh, field, item=False, **extra):
    return capped(field, {'en': en, 'zh': zh, **extra}, item=item)


CORE_LAWS = [
    law(P,  "The cross form: at each blanket state, two internal states' weights with two external states "
           "cross-multiply equally; detailed balance of the internal moves, at each blanket and external state. For "
           "a move in detailed balance at two external states, equal rate ratios give the cross form at its ends "
           "given positive rates, and back given positive weights; it passes through positive weight (cross_of_move "
           "and five more).",
        "交叉形式：于每一毯态，二内部态与二外部态之权交叉相乘相等。内部诸移于每一毯态与外部态细致平衡。一移于二外部态细致平衡时，所需之率为正则率比相等予其两端之"
        "交叉形式，所需之权为正则反之；交叉形式经正权之态而传（cross_of_move 等六项）。",
        'CrossForm', 'DetailedBalance', 'cross_of_move', 'ratio_of_cross', 'cross_trans', 'pos_of_mul_eq'),
    law(P,  "With positive weights, internal states at each blanket state within one closure of moves at positive "
           "rate at every external state, each move's rate ratio reading no external state, internal detailed "
           "balance gives the cross form, no steady state assumed; rates reading none qualify. Conversely, positive "
           "weights in detailed balance and cross form have ratios reading none (crossForm_of_detailedBalance and "
           "three more).",
        "内部诸移之细致平衡予交叉形式：权皆正，每一毯态之内部诸态处于每一外部态皆以正率在之诸移之一闭包（«所闭»）内，每移之率比不读外部态；不设稳态；"
        "不读外部态之率满足率比之条件；反之，细致平衡之正权成交叉形式，则每一率比不读外部态（crossForm_of_detailedBalance 等四项）。",
        'cross_of_closure', 'crossForm_of_detailedBalance', 'crossForm_of_detailedBalance_unread',
        'ratio_of_crossForm'),
    law(P,  "On listed states the joint weight factors given the blanket where each pair's weight times the blanket "
           "state's is the internal weight there times the external weight; that is the cross form on the listed "
           "states, repeated states and blanket states weighing nothing included; the cross form over the types "
           "gives it on any listings and follows on listings covering the types (factorsGiven_of_crossFormOn and "
           "eleven more).",
        "于所列之态：每一所列之对之权乘毯态之权，等于彼处内部态之权乘外部态之权，则联合之权予毯而分解；此即所列诸态之交叉形式，重复之态与权为零之毯态皆含；"
        "类型上之交叉形式于任一列予之，于涵盖类型之列由之而得（factorsGiven_of_crossFormOn 等十二项）。",
        'internalWeight', 'externalWeight', 'blanketWeight', 'FactorsGiven', 'CrossFormOn', 'crossFormOn_of_crossForm',
        'crossForm_of_crossFormOn', 'total_congr_mem', 'total_mul_total', 'factorsGiven_of_crossFormOn',
        'whole_zero_entry', 'crossFormOn_of_factorsGiven'),
    law(P,  "Independence given the blanket on the theory's conditioning: at each blanket state, an internal event's "
           "share under the weighting restricted to an external record is its share, as ratios. Factoring "
           "gives it on any listings and follows from it where each state is listed once, so it is the cross form "
           "there, given by detailed balance under the second law's conditions (independentGiven_of_crossFormOn and "
           "nine more).",
        "依理论之条件化予毯之条件独立：于每一毯态，内部之一事于限于外部之一记录之权下之份额即其份额（以比计）。分解之形于任一列予之，于每态列一次之列由之而得，"
        "故即所列诸态之交叉形式，内部诸移之细致平衡依第二律之条件予之（independentGiven_of_crossFormOn 等十项）。",
        'atBlanket', 'IndependentGiven', 'mass_whole', 'mass_atBlanket', 'scaled_of_factorsGiven',
        'independentGiven_of_factorsGiven', 'factorsGiven_of_independentGiven', 'independentGiven_of_crossFormOn',
        'crossFormOn_of_independentGiven', 'independentGiven_of_detailedBalance'),
    law(P, "Product weights at one blanket state are in cross form, and independence given the blanket there is the "
           "product law of conditioning by restriction (ConditionalWeights.restrict_independent), which the law "
           "generalizes (restrict_independent_case, crossForm_product).",
        "一毯态处之积权成交叉形式，彼处予毯之独立即限制之条件化之积律（ConditionalWeights.restrict_independent），本律推广之"
        "（restrict_independent_case、crossForm_product）。",
        'crossForm_product', 'restrict_independent_case'),
    law(P, "Witness, a lag relay: external, blanket and internal bits each flip alone, the blanket towards the "
           "external bit and the internal bit towards the blanket at rate 3, away at 1, the internal rates reading no "
           "external state; its weights 31, 15, 9, 17, 17, 9, 15, 31 are steady and not independent given the "
           "blanket, so its internal moves are not in detailed balance (LagRelay.not_independentGiven and ten more).",
        "见证（滞后之传递）：外部、毯与内部之位各自独翻，毯趋外部之位、内部之位趋毯以率 3，离之以 1，内部之率不读外部态；其权 31, 15, 9, 17, 17, 9, 15, 31 "
        "为稳态而予毯不独立，故内部诸移不细致平衡（LagRelay.not_independentGiven 等十一项）。",
        'LagRelay.State', 'LagRelay.rate', 'LagRelay.fullRate', 'LagRelay.weight', 'LagRelay.w', 'LagRelay.flips',
        'LagRelay.inflow', 'LagRelay.outflow', 'LagRelay.steady', 'LagRelay.not_independentGiven',
        'LagRelay.circulates'),
    law(P, "Witness, a turning chain: the internal part turns through three states one way only, reading nothing, "
           "while the blanket and external bits flip; the uniform weights are steady and independent given the "
           "blanket on any listings, and the internal moves are not in detailed balance: circulation need not lose "
           "the blanket (Turning.independentGiven and eleven more).",
        "见证（转动之链）：内部部分单向转过三态而不读任何，毯与外部之位各翻；均匀之权为稳态，于任一列予毯独立，而内部诸移不细致平衡：环流未必失毯"
        "（Turning.independentGiven 等十二项）。",
        'Turning.Phase', 'Turning.rate', 'Turning.same', 'Turning.State', 'Turning.fullRate', 'Turning.w',
        'Turning.states', 'Turning.inflow', 'Turning.outflow', 'Turning.steady', 'Turning.circulates',
        'Turning.independentGiven'),
    law(P, "Witness, rates reading the external state: the internal bit flips at 1 where the external bit is off and "
           "at 2 where it is on, in detailed balance with uniform weights, which are in cross form: a rate reading "
           "the external state does not by itself lose the blanket (ReadsDirectly.crossForm and four more).",
        "见证（读外部态之率）：外部之位为关时内部之位以 1 翻，为开时以 2，与均匀之权细致平衡，其权成交叉形式：读外部态之率不自失毯"
        "（ReadsDirectly.crossForm 等五项）。",
        'ReadsDirectly.rate', 'ReadsDirectly.w', 'ReadsDirectly.balanced', 'ReadsDirectly.crossForm',
        'ReadsDirectly.reads_external'),
    law(P, "Witness, moves reading the external state: a positive weighting whose internal moves are in detailed "
           "balance, joined at each external state by different moves, those present at both having one rate ratio "
           "at both, is not in cross form: the moves present at every external state cannot be dropped, what remains "
           "of Kelly's condition (ii) (MovesReadExternal.not_crossForm and five more).",
        "见证（读外部态之移）：正权，内部诸移细致平衡，于每一外部态由相异之移相连，二外部态皆在之移于二者率比相同，则不成交叉形式：每一外部态皆在之移不可去，"
        "即 Kelly 条件 (ii) 之余（MovesReadExternal.not_crossForm 等六项）。",
        'MovesReadExternal.rate', 'MovesReadExternal.w', 'MovesReadExternal.balanced', 'MovesReadExternal.joined',
        'MovesReadExternal.ratio', 'MovesReadExternal.not_crossForm'),
    law(P, "Witness, a synchronous blanket: all parts move at once, each by a factor reading what the "
           "blanketed law lets it read, by construction; the external bit stays at 3 and flips at 1, the sensory bit "
           "copies it, the internal bit copies the sensory bit. With the copy exact the steady weights are "
           "independent given the blanket; with a miss in four, not "
           "(SynchronousCopy.noisy_not_independentGiven and twelve more).",
        "见证（同步之毯）：诸部分同时而移，各依一因子，依核之构造只读毯化之律所许者；外部之位以 3 留、以 1 翻，感官之位复制之，内部之位复制感官之位。"
        "复制精确时稳态之权予毯独立；四中有一失则否（SynchronousCopy.noisy_not_independentGiven 等十三项）。",
        'SynchronousCopy.externalStep', 'SynchronousCopy.sensoryStep', 'SynchronousCopy.internalStep',
        'SynchronousCopy.kernel', 'SynchronousCopy.states', 'SynchronousCopy.exactWeight',
        'SynchronousCopy.noisyWeight', 'SynchronousCopy.exactW', 'SynchronousCopy.noisyW',
        'SynchronousCopy.exact_steady', 'SynchronousCopy.noisy_steady', 'SynchronousCopy.exact_independentGiven',
        'SynchronousCopy.noisy_not_independentGiven'),
    law(P, "Witness, a determined blanketed run: the sensory part reads the upper bit of a four-state external counter "
           "and the internal part copies it; the occupation weighting over one period is not in cross form, while "
           "the coupling form holds on every run (Cycle.not_crossForm and five more).",
        "见证（确定之毯化运行）：感官部分读四态外部计数之高位，内部部分复制之；一周期之占据之权不成交叉形式，而耦合之形于每一运行皆成"
        "（Cycle.not_crossForm 等六项）。",
        'Cycle.law', 'Cycle.start', 'Cycle.run', 'Cycle.w', 'Cycle.periodic', 'Cycle.not_crossForm'),
    law(P, "Witness, listings not covering the types: a weighting in cross form on listings of one state is not in "
           "cross form over the types (Uncovered.not_crossForm and two more).",
        "见证（不涵盖类型之列）：于一态之列成交叉形式之权，于类型上不成交叉形式（Uncovered.not_crossForm 等三项）。",
        'Uncovered.w', 'Uncovered.crossFormOn', 'Uncovered.not_crossForm'),
]

LINEAR_LAWS = [
    law(L, "The Helmholtz form is the Lyapunov equation: with S symmetric and invertible, B S + S Bᵀ = 2D gives "
           "B = (D − Q)S⁻¹ with Q antisymmetric; with Q antisymmetric, D symmetric and Π symmetric and invertible, "
           "B = (D − Q)Π gives the Lyapunov equation for Π⁻¹; the parts are unique (helmholtz_of_lyapunov and four "
           "more).",
        "Helmholtz 之形即 Lyapunov 方程：S 对称可逆时，B S + S Bᵀ = 2D 予 B = (D − Q)S⁻¹，Q 反对称；Q 反对称、D 对称、Π 对称可逆时，"
        "B = (D − Q)Π 予 Π⁻¹ 之 Lyapunov 方程；其部分唯一（helmholtz_of_lyapunov 等五项）。",
        'helmholtz_of_lyapunov', 'lyapunov_of_helmholtz', 'helmholtz_unique', 'entry_symm', 'entry_anti'),
    law(L, "No circulation through a coordinate: with Π invertible, row i of QΠ vanishes exactly where row i of Q "
           "does; with diagonal positive noise and no solenoidal flow through i, the drift at i reads j exactly where "
           "Π i j ≠ 0; where it does not read j, Π i j ≠ 0 exactly where (QΠ) i j ≠ 0, Heins and Da Costa's eq. 13, scalar case (zero_iff_solenoidal and "
           "two more).",
        "无经一坐标之环流：Π 可逆时，QΠ 之第 i 行恰于 Q 之第 i 行为零处为零；噪声对角为正且无螺线之流经 i 时，i 处之漂移读 j 恰当二者之精度之项不为零；"
        "i 处之漂移不读 j 时，二者之精度之项不为零恰当 (QΠ) i j 不为零，即 Heins 与 Da Costa 方程 13 之标量情形（zero_iff_solenoidal 等三项）。",
        'row_zero_iff', 'drift_zero_iff', 'zero_iff_solenoidal'),
    law(L,  "Footnote 13 as a law: with diagonal positive noise, Q antisymmetric and vanishing between a set of "
           "coordinates and the rest, and no coordinate of the set reading j, Π is zero between the set and j, D − Q "
           "being positive on the set; in the four parts, the internal and active coordinates "
           "autonomous, sparse coupling gives them zero precision entries with the external ones "
           "(precision_zero_of_footnote13 and two more).",
        "脚注 13 为律：噪声对角为正，Q 反对称且于一组坐标与其余之间为零，组中无坐标读 j，则组与 j 间精度之项皆为零，以 D − Q 于组上为正；于四部分，"
        "内部与主动坐标自主，稀疏耦合予其与外部坐标间精度之项为零（precision_zero_of_footnote13 等三项）。",
        'quad_antisymm', 'precision_zero_of_autonomous', 'precision_zero_of_footnote13'),
    law(L, "Term by term (the 2023 paper's eq. 9, linear case, with constant Q, noise and Hessian, the noise "
           "and Hessian diagonals positive): an absent influence has no Hessian and no solenoidal entry (eqs. 9–10), "
           "so the zero "
           "precision entry is one of its terms; the reverse influence runs only through solenoidal "
           "flow to third states; a state no other state reads reads no other state (reverse_through_third and three "
           "more).",
        "逐项而言，于线性情形（2023 年论文之方程 9，螺线部分、噪声与 Hessian 皆常，噪声与 Hessian 之对角为正）：缺之影响无 Hessian 亦无螺线之项（论文方程 9–10），故零精度之项即定义之一项；"
        "反向之影响唯经螺线之流至第三态；无他态读之态不读他态（reverse_through_third 等四项）。",
        'TermwiseUnread', 'unread_zero', 'reverse_through_third', 'reads_nothing_of_unread'),
    law(L, "Witness, a linear lag relay: internal coordinate 0 reads blanket coordinate 1, which reads external "
           "coordinate 2, noise one at each; sparse both ways as zero drift entries, it has Π 0 2 = 4/109 and it circulates through the internal coordinate; the internal drift's zero entry at the "
           "external coordinate is a cancellation, so it is not sparse term by term (LagRelay.precision_nonzero and twelve "
           "more).",
        "见证（线性滞后之传递）：内部坐标 0 读毯坐标 1，1 读外部坐标 2，各噪声为一；以漂移之零项计两向皆稀疏，其 0 与 2 间精度之项为 4/109，且经内部坐标环流；"
        "内部漂移于外部坐标之零项为相消，故非逐项稀疏（LagRelay.precision_nonzero 等十三项）。",
        'LagRelay.B', 'LagRelay.BT', 'LagRelay.S', 'LagRelay.P', 'LagRelay.Q', 'LagRelay.transpose_B',
        'LagRelay.lyapunov', 'LagRelay.inverse', 'LagRelay.helmholtz', 'LagRelay.sparse', 'LagRelay.precision_nonzero',
        'LagRelay.circulates', 'LagRelay.not_termwise'),
    law(L, "Witness, circulation keeping the zero: a steady state circulating through the internal coordinate, with "
           "solenoidal coupling to both other coordinates, sparse both ways as zero drift entries, keeps the zero "
           "precision entry between internal and external coordinates; its zero drift entry is a cancellation too "
           "(Circulating.circulates_and_precision_zero and six more).",
        "见证（环流而保零）：经内部坐标环流、与另二坐标皆有螺线耦合之稳态，以漂移之零项计两向稀疏，保内部与外部坐标间之零精度；其漂移之零项亦为相消"
        "（Circulating.circulates_and_precision_zero 等七项）。",
        'Circulating.P', 'Circulating.Q', 'Circulating.B', 'Circulating.helmholtz', 'Circulating.antisymmetric',
        'Circulating.circulates_and_precision_zero', 'Circulating.not_termwise'),
    law(L, "Witness, a zero precision entry while the internal drift reads the external coordinate (Da Costa, "
           "Friston, Heins and Pavliotis 2021, Remark 3.1) (Unsparse.precision_zero_and_read and five more).",
        "见证：内部漂移读外部坐标而精度之项为零（Da Costa、Friston、Heins、Pavliotis 2021，注 3.1）（Unsparse.precision_zero_and_read 等六项）。",
        'Unsparse.P', 'Unsparse.Q', 'Unsparse.B', 'Unsparse.helmholtz', 'Unsparse.antisymmetric',
        'Unsparse.precision_zero_and_read'),
    law(L, "The internal mode given blanket and external states, the stationary point of the quadratic form in the "
           "internal coordinates, reads no external state exactly where the internal–external block of the precision "
           "is zero; a mode where the internal block is positive definite; elementary Gaussian conditioning "
           "(mode_unread_iff and two more).",
        "予毯与外部态之内部众数，即内部坐标之二次形之驻点，恰于精度之内外块为零处不读外部态；内部块正定时为众数；初等之高斯条件化（mode_unread_iff 等三项）。",
        'mode', 'mode_stationary', 'mode_unread_iff'),
    law(L, "Joined to the core: under the principle's sparse coupling of a linear drift, internal and active "
           "coordinates reading no external one and sensory and external coordinates no internal one, the Euler step "
           "is a blanketed law part by part (Becoming.Blanket), so Euler runs from one internal and active state, "
           "alike on the sensory coordinates, are alike on the internal and active ones (split_euler and twelve "
           "more).",
        "接于核心：于线性漂移之原理之稀疏耦合下（内部与主动坐标不读外部，感官与外部坐标不读内部），Euler 之步逐部分为毯化之律（Becoming.Blanket），故自同一内部"
        "与主动态、于感官坐标相同之 Euler 运行，于内部与主动坐标相同（split_euler 等十三项）。",
        'Part', 'SparseCoupling', 'euler', 'euler_congr', 'Coords', 'glue', 'split', 'eulerLaw',
        'glue_split_of_ne_external', 'glue_split_of_ne_internal', 'split_euler', 'split_euler_iterate',
        'euler_agent_through_sensory'),
    law(L, "With additive noise as each coordinate's own input, the agent's course is fixed by its start, its own "
           "noise course and the sensory course: two Euler–Maruyama runs with one noise course at the internal and "
           "active coordinates, alike on the sensory coordinates before t, are alike on the internal and active ones "
           "at t, pathwise, circulating or not (em_agent_through_sensory, emRun).",
        "以加性噪声为每一坐标自身之输入，主体之历程由其起点、其自身噪声之历程与感官历程所定：内部与主动坐标噪声历程相同、t 前于感官坐标相同之二 Euler–Maruyama "
        "运行，于 t 时内部与主动坐标相同，逐路径而言，环流与否皆然（em_agent_through_sensory、emRun）。",
        'emRun', 'em_agent_through_sensory'),
    law(L, "The synchronous scheme without circulation: for the drift −DΠx, D and Π symmetric, a matrix inverse to "
           "Π − (h/2)ΠDΠ is carried to itself by one step with noise 2hD, the known order-h bias; with D diagonal and "
           "positive and the four-part sparse coupling, its internal–external entries are zero and its "
           "active–external entries are −h/2 times a sum through the sensory coordinates (em_steady and three more).",
        "无环流之同步之法：漂移 −DΠx，D 与 Π 对称，Π − (h/2)ΠDΠ 之逆为噪声 2hD 之一步所保，即已知之 h 阶偏差；D 对角为正且四部分稀疏耦合时，其内外之项为零，"
        "主动与外部之项为 −h/2 乘经感官坐标之和（em_steady 等四项）。",
        'em_steady', 'precision_zero_of_drift', 'em_keeps_four_part', 'em_active_external'),
    law(L, "Witness, four parts circulating: external, sensory, active and internal coordinates, circulation between "
           "the internal and active and between the external and sensory ones, sparse term by term, footnote 13's "
           "condition met; Π is zero between the external coordinate and the internal and active ones, while the "
           "internal drift reads the sensory one only through circulation (Autonomous.precision_zero and "
           "ten more).",
        "见证（四部分环流）：外部、感官、主动与内部坐标，内部与主动之间、外部与感官之间环流，逐项稀疏，满足脚注 13 之条件；外部坐标与内部、主动坐标间精度之项皆为零，"
        "而内部漂移唯经环流读感官坐标（Autonomous.precision_zero 等十一项）。",
        'Autonomous.part', 'Autonomous.P', 'Autonomous.Q', 'Autonomous.B', 'Autonomous.helmholtz',
        'Autonomous.antisymmetric', 'Autonomous.sparse', 'Autonomous.autonomous', 'Autonomous.precision_zero',
        'Autonomous.circulates', 'Autonomous.termwise'),
    law(L, "Witness, the synchronous scheme in the four parts: with circulation, at h = 1/10, the steady precision "
           "has internal–external entry −27800/984581, the flow's being zero, while the coupling form holds on the runs; "
           "without circulation, on the same precision, the internal–external zero stays and the active–external "
           "entry is −h/2 (Autonomous.em_loses_internal_external and nine more).",
        "见证（四部分之同步之法）：有环流时，于 h = 1/10，稳态精度之内外之项为 −27800/984581（流之精度为零），而耦合之形于诸运行皆成；无环流时，于同一精度，"
        "内外之零保持，主动与外部之项为 −h/2（Autonomous.em_loses_internal_external 等十项）。",
        'Autonomous.em_coupling_form', 'Autonomous.emA', 'Autonomous.emS', 'Autonomous.emM',
        'Autonomous.emS_steady', 'Autonomous.emS_inverse', 'Autonomous.em_loses_internal_external', 'Autonomous.still_sparse',
        'Autonomous.em_keeps', 'Autonomous.em_loses_active_external'),
    law(L, "Witness, three parts: a chain whose middle coordinate reads and is read by both ends, sparsely coupled "
           "under no assignment to the four parts with its ends internal and external; without circulation the entry of Π − (h/2)Π² between its ends "
           "is −h/2 at every h, the steady precision for 0 < h < 2/(2 + √2), while the flow's is zero "
           "(ThreePart.em_loses_zero and seven more).",
        "见证（三部分）：中间坐标读两端且为两端所读之链，无一对四部分、两端为内部与外部之指派使之稀疏耦合；无环流时 Π − (h/2)Π² 于两端间之项于每一 h 为 −h/2，"
        "于 0 < h < 2/(2 + √2) 为稳态精度，而流之精度为零（ThreePart.em_loses_zero 等八项）。",
        'ThreePart.P', 'ThreePart.S', 'ThreePart.symm', 'ThreePart.inverse', "ThreePart.inverse'", 'ThreePart.steady',
        'ThreePart.no_four_part', 'ThreePart.em_loses_zero'),
]
assert len(CORE_LAWS) == 12 and len(LINEAR_LAWS) == 14
for laws, names, label in ((CORE_LAWS, core_names, 'core'), (LINEAR_LAWS, linear_names, 'linear')):
    cited = [d for x in laws for d in x['declarations']]
    assert len(cited) == len(set(cited)), (label, 'a declaration cited twice')
    assert set(cited) == names, (label, sorted(names - set(cited)), sorted(set(cited) - names))
core_cited = sorted(d for x in CORE_LAWS for d in x['declarations'])
linear_cited = sorted(d for x in LINEAR_LAWS for d in x['declarations'])
cc = f'{COUNT_CORE[0]} theorems in {COUNT_CORE[1]} declarations' if COUNT_CORE else 'the theorems'
lc = f'{COUNT_LINEAR[0]} theorems in {COUNT_LINEAR[1]} declarations' if COUNT_LINEAR else 'the declarations'
REVIEWED = ("Reviewed by other AI agents: the design (REVIEW-UE26-DESIGN, fifteen findings), the literature, the "
            "revised kit (RECHECK-UE26, twelve) and the Lean and landing texts (REVIEW-UE26-LANDING, nineteen, and its recheck, six), every "
            "finding taken")
REVIEWED_ZH = ('他 AI 代理审之：设计（REVIEW-UE26-DESIGN，十五条）、文献、修订之件（RECHECK-UE26，十二条）、Lean 与落地文本'
               '（REVIEW-UE26-LANDING，十九条，复核六条），凡所见皆取')

core_record = {
    'schema_version': 2, 'id': CORE_RID,
    'title': pair('The blanket at a steady state: conditional independence and what holds it',
                  '稳态之毯：条件独立及其所以成立', 'title'),
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': pair(
        "Independence given the blanket is the cross form on states each listed once; positive weights with the "
        "internal moves in detailed balance, joined by moves present at every external state whose rate ratios read "
        "none, give it; circulation can lose it and need not.",
        '于每态列一次之列，予毯之独立即交叉形式；权皆正，内部诸移细致平衡，由每一外部态皆在、率比不读外部态之移相连，则予之；环流能失之，亦未必失之。',
        'statement'),
    'laws': CORE_LAWS,
    'hypotheses': [
        pair("No axiom. Natural weights on internal, blanket and external states of any types, read on listed states; "
             "conditioning by restriction (ConditionalWeights).",
             '不加公理。任意类型之内部、毯与外部诸态上之自然数之权，于所列之态而读；以限制为条件化（ConditionalWeights）。', 'hypotheses', item=True),
        pair("For the sufficient condition: positive weights; the internal moves in detailed balance at each blanket and "
             "external state; at each blanket state a relation of moves present at positive rate at every external "
             "state, whose closure holds the internal states; each such move's rate ratio reading no external state. No "
             "steady state is assumed.",
             '充分条件：权皆正；内部诸移于每一毯态与外部态细致平衡；于每一毯态，有于每一外部态皆以正率在之诸移之关系，其闭包含诸内部态；每移之率比不读外部态。不设稳态。',
             'hypotheses', item=True),
        pair("Modelling choices: discrete states; the asynchronous chain, one part moving at a time, read through its "
             "rates with no clock, a model beside the blanketed law, whose parts move at once; steady weights by global "
             "balance, or for the synchronous law carried to themselves by one step; the blanket one part.",
             '建模之选择：离散之态；异步之链，一时一部分移，以其率读之而无时钟，为毯化之律（诸部分同时而移）旁之模型；稳态之权依全局平衡，同步之律则为一步所保；毯为一部分。',
             'hypotheses', item=True),
        pair("The steady weights of the lag relay and the synchronous copy are proved steady; their uniqueness up to "
             "scale is a correspondence, checked by exact solves in the study's probes.",
             '滞后之传递与同步复制之稳态之权证为稳态；其于比例下之唯一为对应，以研究之探针精确求解而核。', 'hypotheses', item=True),
    ],
    'does_not_show': [
        pair("That independence given the blanket needs detailed balance: circulation can keep it "
             "(Turning.independentGiven).",
             '予毯之独立需细致平衡：环流能保之（Turning.independentGiven）。', 'does_not_show', item=True,
             kind='non-implication'),
        pair("Densities, Langevin flows, continuous states or time; the linear case is the sibling record's.",
             '密度、Langevin 流、连续之态或时间；线性情形属同辈之记录。', 'does_not_show', item=True, kind='scope'),
        pair("That a chain's steady weights are unique, or how to compute them from its rates.",
             '一链之稳态之权唯一，或如何自其率求之。', 'does_not_show', item=True, kind='scope'),
        pair("That the synchronous copy's kernel is a blanketed law by a theorem: its factor structure is by "
             "construction.",
             '同步复制之核以定理为毯化之律：其因子之结构出于构造。', 'does_not_show', item=True, kind='scope'),
        pair("A discrete law for footnote 13's set of internal and active states.",
             '脚注 13 之内部与主动诸态之集之离散之律。', 'does_not_show', item=True, kind='scope'),
    ],
    'counterexamples': [
        {'path': LEAN, 'detail': {
            'en': "The lag relay's steady weights are not independent given the blanket, its internal rates reading "
                  "no external state (LagRelay.not_independentGiven).",
            'zh': '滞后之传递之稳态之权予毯不独立，其内部之率不读外部态（LagRelay.not_independentGiven）。'}},
        {'path': LEAN, 'detail': {
            'en': "Moves present at both external states with one rate ratio, the joining moves differing, give no "
                  "cross form (MovesReadExternal.not_crossForm).",
            'zh': '二外部态皆在之移率比相同，而相连之移相异，不予交叉形式（MovesReadExternal.not_crossForm）。'}},
        {'path': LEAN, 'detail': {
            'en': "A synchronous copy with a miss in four: steady weights not independent given the blanket "
                  "(SynchronousCopy.noisy_not_independentGiven).",
            'zh': '同步复制四中有一失：稳态之权予毯不独立（SynchronousCopy.noisy_not_independentGiven）。'}},
        {'path': LEAN, 'detail': {
            'en': "A determined blanketed run's occupation weighting is not in cross form (Cycle.not_crossForm).",
            'zh': '确定之毯化运行之占据之权不成交叉形式（Cycle.not_crossForm）。'}},
    ],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': pair(
        f"Pure core, every axiom report empty (core receipt {CORE_ID_R}): BlanketWeights ({cc}) imports Blanket and "
        "Flow, a leaf; the witnesses evaluate by decide over full nested matches. " + REVIEWED + f"; study section {N}; "
        "not reviewed by a person.",
        f'纯核，公理报告皆空（核心回执 {CORE_ID_R}）：BlanketWeights 引 Blanket 与 Flow，为叶；见证以 decide 于完整之嵌套匹配求值。' + REVIEWED_ZH
        + f'；研究第 {N} 节；未经人审。',
        'validation_scope'),
    'next_delta': pair(
        "Entropy production of the lag relay, joining EntropyProduction; a discrete law for footnote 13's set of "
        "internal and active states; a chain's steady weights computed from its rates; review by a person.",
        '滞后之传递之熵产生，接于 EntropyProduction；脚注 13 之内部与主动诸态之集之离散之律；自一链之率求其稳态之权；人之审查。',
        'next_delta'),
    'correspondence': pair(
        "The principle's statistical blanket (Friston 2019; Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and "
        "Parr 2023, Physics Reports, §4): internal and external states independent given the present blanket state at "
        "a steady state. The sufficient condition is Kelly's proof that the equilibrium of a reversible spatial process "
        "is a Markov field (Kelly 1979, Theorem 9.3; Liggett 1985, §IV.2) at the internal site, with rate ratios: the "
        "closure is his condition (iii), the moves present at every external state what remains of (ii). The relay's "
        "loss: sparse coupling without the statistical blanket is known (Biehl, Pollock and Kanai 2021, Observation 1; "
        "Aguilera, Millidge, Tschantz and Buckley 2022), and the relay is a witness of it. "
        "The coupling form is the deterministic case of the time-unrolled blanket (Virgo, Rosas and Biehl 2022). AI "
        "reading: the theory's agent laws need only the coupling form; the principle's inference reading needs the "
        "statistical form, which holds under conditions each of which is known. The readings are the AI's, in "
        "development/ue26-blankets-at-a-steady-state/DESIGN.md.",
        '原理之统计之毯（Friston 2019；Friston、Da Costa、Sajid、Heins、Ueltzhöffer、Pavliotis、Parr 2023，Physics Reports，§4）：稳态时予当下毯态'
        '内部与外部诸态独立。充分条件即 Kelly 证可逆空间过程之平衡为 Markov 场（Kelly 1979，定理 9.3；Liggett 1985，§IV.2）于内部之位、以率比而行：闭包即其条件 '
        '(iii)，每一外部态皆在之移即 (ii) 之余。传递之失：稀疏耦合而无统计之毯已知（Biehl、Pollock、Kanai 2021，观察 1；Aguilera 等 2022），传递为其见证。耦合之形即时间展开之毯之确定'
        '情形（Virgo、Rosas、Biehl 2022）。AI 之读：理论之主体之律唯需耦合之形；原理之推断之读需统计之形，其成立之条件皆已知。读法皆 AI 之读，载于 DESIGN.md。',
        'correspondence'),
    'canonical_source': LEAN,
    'aliases': ['The blanket at a steady state', '稳态之毯', 'statistical blanket', 'conditional independence given the '
                'blanket', 'detailed balance of the internal moves', 'Becoming.BlanketWeights.crossForm_of_detailedBalance',
                'Becoming.BlanketWeights.independentGiven_of_crossFormOn'],
    'dependencies': [
        {'id': 'conditioning-by-restriction', 'relation': 'formal-reuse', 'detail': {
            'en': 'ConditionalWeights.restrict, share, Share.Same, total and restrict_independent: independence given '
                  'the blanket stated on the theory\'s conditioning, the product law its case at one blanket state.',
            'zh': 'ConditionalWeights.restrict、share、Share.Same、total 与 restrict_independent：予毯之独立依理论之条件化而陈，积律为其一毯态之情形。'}},
        {'id': 'master-laws-on-the-grammar', 'relation': 'formal-reuse', 'detail': {
            'en': '«所闭»: the closure of the internal moves on the grammar.',
            'zh': '«所闭»：内部诸移于语法上之闭包。'}},
        {'id': BLANKET_RID, 'relation': 'formal-reuse', 'detail': {
            'en': 'Blanket.Blanketed and its course: the determined blanketed law whose occupation weighting the '
                  'witness Cycle reads.',
            'zh': 'Blanket.Blanketed 及其历程：见证 Cycle 所读其占据之权之确定之毯化之律。'}},
        {'id': 'what-the-existence-claim-forbids', 'relation': 'formal-reuse', 'detail': {
            'en': 'Blanket.visits: the occupation weighting read off a run.',
            'zh': 'Blanket.visits：自运行读出之占据之权。'}},
    ],
    'related': [
        {'id': LINEAR_RID, 'detail': {
            'en': 'The linear case over the reals: the Helmholtz form, footnote 13 as a law and the synchronous scheme.',
            'zh': '实数上之线性情形：Helmholtz 之形、脚注 13 为律与同步之法。'}},
    ],
    'references': [{'path': LEAN, 'role': 'proof', 'declarations': core_cited, 'sha256': sha(LEAN)},
                   {'path': CORE_RECEIPT, 'role': 'receipt', 'sha256': sha(CORE_RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': LIT, 'role': 'integration', 'sha256': sha(LIT)},
                   {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
                   {'path': LANDREVIEW, 'role': 'integration', 'sha256': sha(LANDREVIEW)},
                   {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)},
                   {'path': PAGE, 'role': 'integration', 'sha256': sha(PAGE)}],
    'proof_bindings': [{'source': LEAN, 'receipt': CORE_RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.BlanketWeights',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (UE26), the principle\'s statistical blanket on the theory\'s conditioning: '
                       'independence given the blanket as the cross form on listings listing each state once; detailed balance of the '
                       'internal moves with positive weights, within one closure of moves present at every external '
                       'state, each such move\'s rate ratio reading no external state, gives it, Kelly\'s proof at the '
                       'internal site; witnesses on either side, a synchronous copy among '
                       f'them; after a review, a literature check, a recheck and a review of the landing texts, every finding taken; study section {N}.',
                 'zh': f'{DATE_ZH}：新增（UE26），依理论之条件化之原理之统计之毯：予毯之独立即于每态列一次之列之交叉形式；权皆正，内部诸移于每一外部态皆在之移之一闭包内细致平衡，'
                       f'每移之率比不读外部态，则予之，即 Kelly 之证于内部之位；两侧之见证，同步复制在其中；经审查、文献核对、复核与落地文本之审查，凡所见皆取；研究第 {N} 节。'}],
}

linear_record = {
    'schema_version': 2, 'id': LINEAR_RID,
    'title': pair('The blanket in a linear steady state: the coupling form and the statistical form',
                  '线性稳态之毯：耦合之形与统计之形', 'title'),
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': pair(
        "In the linear steady state the Helmholtz form is the Lyapunov equation and footnote 13's law gives the "
        "zero precision block; sparsely coupled Euler–Maruyama runs keep the coupling form pathwise, while their "
        "steady law can lose the four-part zero with circulation (a witness at h = 1/10).",
        '于线性稳态，Helmholtz 之形即 Lyapunov 方程，脚注 13 之律予零精度之块；稀疏耦合之 Euler–Maruyama 运行逐路径保耦合之形，而其稳态之律于有环流时可失四部分之零（h = 1/10 之见证）。',
        'statement'),
    'laws': LINEAR_LAWS,
    'hypotheses': [
        pair("In the periphery, on Mathlib's reals: each declaration depends on Lean's three standard axioms at most, "
             "reported by the module's checker; the core module it reads, Becoming.Blanket, has empty axiom reports.",
             '于外围，基于 Mathlib 之实数：每一声明至多依赖 Lean 之三条标准公理，由本模块之检查器报告；其所读之核心模块 Becoming.Blanket 公理报告皆空。',
             'hypotheses', item=True),
        pair("Stated algebraically for finitely many coordinates; the correspondences stated, not proved: the Lyapunov "
             "equation as stationarity for B stable, a zero precision entry as conditional independence for a "
             "Gaussian, the steady current QΠx times the density, the discrete Lyapunov equation as the synchronous "
             "recursion's stationarity where its step has spectral radius below 1.",
             '于有限多坐标以代数陈之；对应陈而未证：B 稳定时 Lyapunov 方程即平稳，高斯时零精度之项即条件独立，稳态之流即 QΠx 乘密度，步之谱半径小于 1 时离散 '
             'Lyapunov 方程即同步递推之平稳。', 'hypotheses', item=True),
        pair("For footnote 13's law: diagonal positive noise, Q antisymmetric and vanishing between the set and the "
             "rest, no coordinate of the set reading the coordinate. For the term-by-term laws: eq. 9 with constant Q, "
             "noise and Hessian, with positive diagonals.",
             '脚注 13 之律：噪声对角为正，Q 反对称且于组与其余之间为零，组中无坐标读该坐标。逐项之律：Q、噪声与 Hessian 皆常之方程 9，对角为正。',
             'hypotheses', item=True),
        pair("For the stochastic time-unrolled blanket, a correspondence: the agent's noise independent of the rest's "
             "and of the start, and the agent's start held fixed or independent of the world's.",
             '随机之时间展开之毯（对应）：主体之噪声独立于其余之噪声与起点，主体之起点固定或独立于世界之起点。', 'hypotheses', item=True),
        pair("For the synchronous law: no circulation, B = DΠ with D and Π symmetric; for the four-part zero, D "
             "diagonal and positive and the principle's sparse coupling.",
             '同步之律：无环流，B = DΠ，D 与 Π 对称；四部分之零需 D 对角为正且原理之稀疏耦合。', 'hypotheses', item=True),
    ],
    'does_not_show': [
        pair("Nonlinear Langevin flows, non-Gaussian densities or the Fokker–Planck current.",
             '非线性之 Langevin 流、非高斯之密度或 Fokker–Planck 之流。', 'does_not_show', item=True, kind='scope'),
        pair("The stochastic time-unrolled blanket as a theorem on path measures: its assumptions are stated.",
             '随机之时间展开之毯作为路径测度之定理：其假设陈之而已。', 'does_not_show', item=True, kind='scope'),
        pair("That the zero precision entry needs no solenoidal coupling: the circulating witness keeps it.",
             '零精度之项需无螺线之耦合：环流之见证保之。', 'does_not_show', item=True, kind='non-implication'),
        pair("That the 2023 paper's continuous-time blanket fails: the loss with circulation is the synchronous "
             "scheme's.",
             '2023 年论文之连续时间之毯失效：有环流之失属同步之法。', 'does_not_show', item=True, kind='non-implication'),
        pair("How often cancellation occurs in high-dimensional random systems.",
             '高维随机系统中相消之频率。', 'does_not_show', item=True, kind='scope'),
        pair("Whether Friston 2019 states the term-by-term corollaries' general form: it was not checked.",
             'Friston 2019 是否陈逐项推论之一般形式：未核。', 'does_not_show', item=True, kind='scope'),
    ],
    'counterexamples': [
        {'path': LINEAR, 'detail': {
            'en': "The linear lag relay, sparse both ways as zero drift entries, has precision entry 4/109 between its "
                  "internal and external coordinates (LagRelay.precision_nonzero).",
            'zh': '线性滞后之传递，以漂移之零项计两向稀疏，其内部与外部坐标间之精度之项为 4/109（LagRelay.precision_nonzero）。'}},
        {'path': LINEAR, 'detail': {
            'en': "With circulation, at h = 1/10, the synchronous scheme's steady precision has a nonzero entry "
                  "between the internal and external coordinates of a term-by-term sparse drift meeting footnote 13 "
                  "(Autonomous.em_loses_internal_external).",
            'zh': '有环流时，于 h = 1/10，满足脚注 13 之逐项稀疏漂移之同步之法之稳态精度，其内部与外部坐标间之项不为零（Autonomous.em_loses_internal_external）。'}},
        {'path': LINEAR, 'detail': {
            'en': "A three-coordinate chain, not sparsely coupled with its ends internal and external, has synchronous "
                  "entry −h/2 between its ends without circulation (ThreePart.em_loses_zero).",
            'zh': '三坐标之链（两端为内部与外部时不稀疏耦合）无环流时两端间之同步之项为 −h/2（ThreePart.em_loses_zero）。'}},
    ],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': pair(
        "Machine-checked by the periphery checker check_linear_blankets.py with Lean 4.30.0-rc2 and the pinned Mathlib "
        f"(receipt {LINEAR_ID_R}): {lc} of LinearBlankets, each on Lean's standard axioms only, every core module "
        "of its closure matching a passed core receipt. " + REVIEWED + f"; study section {N}; not reviewed by a person.",
        f'外围检查器 check_linear_blankets.py 以 Lean 4.30.0-rc2 与固定之 Mathlib 实查（回执 {LINEAR_ID_R}）：LinearBlankets 诸声明，各仅依标准公理，'
        '闭包之核心模块皆合通过之回执。' + REVIEWED_ZH + f'；研究第 {N} 节；未经人审。',
        'validation_scope'),
    'next_delta': pair(
        "Nonlinear flows and densities; the stochastic time-unrolled blanket on path measures; the exact time-h map; "
        "how often cancellation occurs; Friston 2019 checked for the term-by-term corollaries; review by a person.",
        '非线性之流与密度；路径测度上之随机之时间展开之毯；精确之时间 h 映射；相消之频率；核 Friston 2019 之逐项推论；人之审查。', 'next_delta'),
    'correspondence': pair(
        "The Ornstein–Uhlenbeck steady state: the Lyapunov equation and the Helmholtz form (standard); a zero precision "
        "entry as Gaussian conditional independence (Lauritzen 1996); Heins and Da Costa 2022, eq. 13 (its scalar case) "
        "and eq. 14 (the normal form) with the condition under it, eq. 15; the 2023 paper's eq. 9 and footnotes 10 and "
        "13 (Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr 2023); sparse coupling without the "
        "statistical blanket (Biehl, Pollock and Kanai 2021, Observation 1), of which the relay is a witness; a zero entry with "
        "the drift reading across (Da Costa, Friston, Heins and Pavliotis 2021, Remark 3.1); the Euler–Maruyama steady "
        "law's order-h bias (standard). AI reading: under the paper's own term-by-term definition the linear zero is "
        "definitional, and the losses are where sparse coupling is read as a zero drift entry and in the theory's "
        "synchronous steps. The readings are the AI's, in development/ue26-blankets-at-a-steady-state/DESIGN.md.",
        'Ornstein–Uhlenbeck 之稳态：Lyapunov 方程与 Helmholtz 之形（标准）；零精度之项即高斯之条件独立（Lauritzen 1996）；Heins 与 Da Costa 2022 方程 13'
        '（其标量情形）与方程 14 之标准形及其下之条件方程 15；2023 年论文之方程 9 与脚注 10、13；稀疏耦合而无统计之毯（Biehl、Pollock、Kanai 2021，观察 1），传递为其见证；漂移读对侧而零项（Da Costa 等 2021，注 3.1）；'
        'Euler–Maruyama 稳态之律之 h 阶偏差（标准）。AI 之读：依论文自身之逐项定义，线性之零出于定义，其失在以漂移之零项读稀疏耦合处及理论之同步之步。读法皆 AI 之读，'
        '载于 DESIGN.md。',
        'correspondence'),
    'canonical_source': LINEAR,
    'aliases': ['The blanket in a linear steady state', '线性稳态之毯', 'Helmholtz decomposition', 'footnote 13',
                'sparse coupling term by term', 'Euler–Maruyama steady law', 'Becoming.LinearBlankets.precision_zero_of_footnote13',
                'Becoming.LinearBlankets.Autonomous.em_loses_internal_external'],
    'dependencies': [
        {'id': BLANKET_RID, 'relation': 'formal-reuse', 'detail': {
            'en': 'Blanket.Blanketed, Parts, step, course and agent_through_sensory: the Euler step of a sparsely '
                  'coupled drift read as a blanketed law, and its runs as the law\'s courses.',
            'zh': 'Blanket.Blanketed、Parts、step、course 与 agent_through_sensory：稀疏耦合之漂移之 Euler 步读作毯化之律，其运行即律之历程。'}},
    ],
    'related': [
        {'id': CORE_RID, 'detail': {
            'en': 'The statistical blanket in counts, in the pure core: row_zero_iff is the counterpart of detailed '
                  'balance of the internal moves.',
            'zh': '纯核中计数之统计之毯：row_zero_iff 即内部诸移之细致平衡之对应。'}},
    ],
    'references': [{'path': LINEAR, 'role': 'proof', 'declarations': linear_cited, 'sha256': sha(LINEAR)},
                   {'path': LINEAR_RECEIPT, 'role': 'receipt', 'sha256': sha(LINEAR_RECEIPT)},
                   {'path': BLANKET, 'role': 'proof', 'sha256': sha(BLANKET)},
                   {'path': CORE_RECEIPT, 'role': 'receipt', 'sha256': sha(CORE_RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': LIT, 'role': 'integration', 'sha256': sha(LIT)},
                   {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
                   {'path': LANDREVIEW, 'role': 'integration', 'sha256': sha(LANDREVIEW)},
                   {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)},
                   {'path': PAGE, 'role': 'integration', 'sha256': sha(PAGE)}],
    'proof_bindings': [
        {'source': BLANKET, 'receipt': CORE_RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.Blanket',
         'success_pointer': '/status', 'success_value': 'passed'},
        {'source': LINEAR, 'receipt': LINEAR_RECEIPT, 'sha256_pointer': '/source_sha256/LinearBlankets',
         'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (UE26), the blanket in a linear steady state in the periphery: the Helmholtz '
                       'form as the Lyapunov equation; footnote 13 as a law for any set of coordinates; the term-by-term '
                       'corollaries in the linear case; the Euler step joined to the blanketed law, with noise; the '
                       'synchronous scheme keeping the four-part zero without circulation and, in a circulating '
                       f'witness, losing it; after a review, a literature check, a recheck and a review of the landing texts, every finding taken; study '
                       f'section {N}.',
                 'zh': f'{DATE_ZH}：新增（UE26），外围之线性稳态之毯：Helmholtz 之形即 Lyapunov 方程；脚注 13 为任一组坐标之律；线性情形之逐项推论；Euler 之步接于'
                       f'毯化之律（含噪声）；同步之法无环流时保四部分之零，于一环流之见证中失之；经审查、文献核对、复核与落地文本之审查，凡所见皆取；研究第 {N} 节。'}],
}

for record in (core_record, linear_record):
    assert not lint_errors({k: record[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                                   'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                           | {'counterexamples': [{'detail': x['detail']} for x in record['counterexamples']]}), record['id']
    for x in record['related'] + record['dependencies']:
        assert x['id'] in (CORE_RID, LINEAR_RID) or (RECORDS / f"{x['id']}.json").exists(), x['id']
assert not OVER, OVER
print(f'caps: {CORE_RID} ok, {len(core_cited)} declarations in {len(CORE_LAWS)} laws; {LINEAR_RID} ok, '
      f'{len(linear_cited)} declarations in {len(LINEAR_LAWS)} laws')

# --- the blanket's record: naming both ------------------------------------------------------------------------------
path = RECORDS / f'{BLANKET_RID}.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert not {CORE_RID, LINEAR_RID} & {x['id'] for x in d['related']}
d['related'] += [
    {'id': CORE_RID, 'detail': {
        'en': 'The blanket at a steady state: the statistical form, conditional independence given the blanket, '
              'which detailed balance of the internal moves gives with positive weights, moves present at every '
              'external state and rate ratios reading none; the coupling form holds on every run.',
        'zh': '稳态之毯：统计之形（予毯之条件独立），权皆正、移于每一外部态皆在、率比不读外部态时，内部诸移之细致平衡予之；耦合之形于每一运行皆成。'}},
    {'id': LINEAR_RID, 'detail': {
        'en': 'The linear case: the Euler step of a sparsely coupled drift as a blanketed law, with noise, and the '
              'synchronous scheme against the statistical form.',
        'zh': '线性情形：稀疏耦合之漂移之 Euler 步为毯化之律（含噪声），及同步之法与统计之形之关系。'}}]
d['history'].append({
    'en': f'{DATE_EN}, board item UE26 (study section {N}): related to {CORE_RID} and {LINEAR_RID}; no statement, next '
          'step or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE26（研究第 {N} 节）：与 {CORE_RID}、{LINEAR_RID} 相关联；无一陈述、下一步或声明改变。'})
assert not lint_errors({k: d[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                          'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                       | {'counterexamples': [{'detail': x['detail']} for x in d['counterexamples']]}), BLANKET_RID
print(f'caps: {BLANKET_RID} ok')
if CAPS_ONLY and len(sys.argv) > 2:  # --caps PREVIEW: the three records written to PREVIEW for review
    preview = Path(sys.argv[2])
    preview.mkdir(parents=True, exist_ok=True)
    for record in (core_record, linear_record, d):
        (preview / f"{record['id']}.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n',
                                                     encoding='utf-8')
    print('preview written to', preview)
if CAPS_ONLY:
    raise SystemExit(0)

path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record amended:', BLANKET_RID)
for record in (core_record, linear_record):
    out = RECORDS / f"{record['id']}.json"
    assert not out.exists(), out
    out.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', record['id'])
