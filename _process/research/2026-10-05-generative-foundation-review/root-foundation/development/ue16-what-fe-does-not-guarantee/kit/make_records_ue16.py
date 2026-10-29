#!/usr/bin/env python3
"""UE16 records: write identical-cells-under-a-descent-treating-them-alike (homed at 05 §9 after the swap-symmetric assignment)
and risk-minimization-on-a-shared-renewal (homed at 05 §1 after the rest outrunning the renewal), from
Becoming.FreeEnergyGuarantees, each declaration of the module cited once across the two; relate
what-a-commuting-law-keeps-apart, the-rest-outruns-the-renewal and own-count-misses-joint-excess to them, each with a
related entry and a history note; bring UE1's record, capture-by-counted-choices, to a containment with third parts
(its correspondence's last sentence and its next step, with a related entry to each and a history note; its statement
and declarations unchanged). Asserts the receipt's hash and empty axiom reports for the module, and the style caps and
lint (tools/research/style.py) on every field written. Mirrors UE15's make_records_ue15.py; no landed module changes,
so no record is re-pointed for Lean.
usage (from the checkout root, after texts_ue16.py): python3 -B make_records_ue16.py RECEIPT N
       python3 -B make_records_ue16.py --caps  (the caps, lint and the declaration cover against the kit's scratch
                                                audit; writes nothing)"""
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
RECEIPT_ID, N = ('20261029T000000.000000Z', 446) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue16-what-fe-does-not-guarantee/'
NOTE, REVIEW = KITD + 'NOTE.md', KITD + 'REVIEW-UE16.md'
SEARCH = RF + 'development/ue1-fep-bridge/THIRD-PART-SEARCH.md'
CH5 = 'theories/becoming/chapters/05-COLLECTIVES.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('FreeEnergyGuarantees', 'Commuting', 'Exclusion', 'Continuation',
                                               'SetPointOptimum')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDA = 'identical-cells-under-a-descent-treating-them-alike'
RIDB = 'risk-minimization-on-a-shared-renewal'
RIDC = 'what-a-commuting-law-keeps-apart'
RIDO = 'the-rest-outruns-the-renewal'
RIDJ = 'own-count-misses-joint-excess'
RIDU = 'capture-by-counted-choices'
RIDS = 'support-from-the-supported'
RIDH = 'what-a-set-point-optimum-does-beyond'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 98
M = 'Becoming.FreeEnergyGuarantees'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingFreeEnergyGuaranteesAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256'][M] == sha(LEAN['FreeEnergyGuarantees']), M
    mod = next(x for x in core['modules'] if x['module'] == M)
    assert not any(mod['axiom_dependencies'].values()), M
    names = {d['name'] for d in mod['declarations']}
assert len(names) == COUNT, len(names)


def C(*short):
    out = [f'{M}.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


I = 'IdenticalCells.'
P = 'IdenticalCells.TwoCells.'
K = 'RiskAndNeeds.'
U = 'RiskAndNeeds.Outrun.'
S = 'SharedModels.'
O = 'SharedModels.OneGoal.'
groups_a = [
    ("Exchanging cells k and k + 1 of a configuration, the list of the cells' states, keeps their number, leaves a total "
     "over the cells unchanged and commutes with mapping every cell (exchangeAt and three more).",
     "交换构型（诸细胞状态之列）之第 k 与 k + 1 细胞，保持其数，不改诸细胞之总量，且与逐细胞映射可交换（exchangeAt 等四项）。",
     C(I + 'exchangeAt', I + 'total_exchangeAt', I + 'map_exchangeAt', I + 'length_exchangeAt')),
    ("Under a descent moving every cell by one rule from its own state and a field reading no cell's number, two "
     "neighbouring cells alike at the start are alike at every step, and all cells alike stay all alike: equal states "
     "get equal successors (two_alike_stay_alike, all_alike_stay_alike, nth_map, nth_replicate).",
     "于以一规则依细胞自身状态与不读细胞编号之场移动每一细胞之下降，起点相同之二相邻细胞每步皆相同，诸细胞皆同则保持皆同：相同之状态得相同之后继"
     "（two_alike_stay_alike、all_alike_stay_alike、nth_map、nth_replicate）。",
     C(I + 'two_alike_stay_alike', I + 'all_alike_stay_alike', I + 'nth_map', I + 'nth_replicate')),
    ("Where no exchange of cells changes the field, as the summed field of the other cells does not, the descent "
     "commutes with exchanging two neighbouring cells (descent, Exchangeable, othersField, othersField_exchangeable, "
     "descent_commutes).",
     "场不为任何细胞交换所改（如他细胞之场之和），则下降与交换二相邻细胞可交换（descent、Exchangeable、othersField、othersField_exchangeable、"
     "descent_commutes）。",
     C(I + 'descent', I + 'Exchangeable', I + 'othersField', I + 'othersField_exchangeable', I + 'descent_commutes')),
    ("The commuting law applied: a start the exchange fixes stays fixed along the run (keeps_exchange_fixed, by "
     "Law.Commutes.keeps_fixed); the run from the exchanged start is the exchanged run, and rests come in exchanged "
     "pairs (exchanged_run, by Law.Commutes.iterate; rests_exchanged); a configuration is exchange-fixed exactly where "
     "the two cells are alike (alike_of_fixed, fixed_of_alike).",
     "可交换律之应用：交换所固定之起点保持固定（keeps_exchange_fixed）；自交换之起点之运行即交换后之运行，静止成对（exchanged_run，依 "
     "Law.Commutes.iterate；rests_exchanged）；构型为交换所固定恰当二细胞相同（alike_of_fixed、fixed_of_alike）。",
     C(I + 'keeps_exchange_fixed', I + 'exchanged_run', I + 'rests_exchanged', I + 'alike_of_fixed',
       I + 'fixed_of_alike')),
    ("Among configurations of one number of cells, the minima of a free energy symmetric in the cells, as one summed "
     "from each cell's own at an exchangeable field is, come in exchanged pairs, and a unique minimum has its cells "
     "alike; across numbers of cells a summed free energy is uniquely least only at no cells (Symmetric and six more).",
     "于同一细胞数之诸构型中，于诸细胞对称之自由能（如于可交换之场逐细胞自由能之和）之极小成交换之对，唯一之极小其细胞相同；跨细胞数，求和之自由能唯于无细胞处唯一最小"
     "（Symmetric 等七项）。",
     C(I + 'Symmetric', I + 'freeEnergy', I + 'freeEnergy_symmetric', I + 'minimum_exchanged',
       I + 'unique_minimum_alike', I + 'apart_not_unique', I + 'unique_across_sizes_empty')),
    ("In TwoCells each of two cells moves one unit away from the other's expectation, staying at a tie, and the step "
     "commutes with the exchange; from [1, 1] the cells rest, and from any two alike cells the free energy is six at "
     "every step, above the nothing of [0, 3] (give and ten more).",
     "TwoCells 中二细胞各离他者之期望一单位，相同则不动，其步与交换可交换；自 [1, 1] 起诸细胞静止，自任二相同细胞起每步自由能皆为六，高于 [0, 3] 之零"
     "（give 等十一项）。",
     C(P + 'give', P + 'field', P + 'away', P + 'step', P + 'energy', P + 'step_commutes', P + 'alike_rests',
       P + 'alike_energy', P + 'pair_of_alike', P + 'alike_never_least', I + 'run_length')),
    ("From [1, 2] the cells are at [0, 3] from step one on, from [2, 1] at [3, 0]; both have free energy nothing, the "
     "least, so no two-cell configuration is the unique minimum among two-cell configurations; other configurations "
     "reach nothing too (parts, exchanged_parts, minima, other_minima).",
     "自 [1, 2] 起，诸细胞自第一步起在 [0, 3]，自 [2, 1] 起在 [3, 0]；二者自由能皆为零，最小，故无二细胞构型为二细胞构型中唯一之极小；他构型亦可达零"
     "（parts、exchanged_parts、minima、other_minima）。",
     C(P + 'parts', P + 'exchanged_parts', P + 'minima', P + 'other_minima')),
]
groups_b = [
    ("Counting helpers: the first element of least score scores no more than any element and is among them "
     "(le_of_blt_false, firstMin, firstMin_le, firstMin_mem).",
     "计数之助：得分最少之首元素不多于任一元素，且在其中（le_of_blt_false、firstMin、firstMin_le、firstMin_mem）。",
     C('le_of_blt_false', 'firstMin', 'firstMin_le', 'firstMin_mem')),
    ("A chooser has the amounts it may take, a generative model predicting the level after a step from what it reads "
     "and takes, and a preferred level; its risk is the predicted distance from that level (gap), and its choice the "
     "first amount of least risk; restraint, taking only nothing, is one chooser (Chooser and six more).",
     "选择者有可取之量、依所读与所取预测一步后水平之生成模型、及偏好之水平；其风险为预测与该水平之距离（gap），其选择为风险最少之首量；克制（唯取零）为一选择者"
     "（Chooser 等七项）。",
     C(K + 'Chooser', K + 'Chooser.risk', K + 'Chooser.chosen', K + 'Chooser.chosen_minimizes', K + 'Chooser.chosen_mem',
       K + 'Chooser.restraint', K + 'Chooser.restraint_chosen')),
    ("The holder reads its own store, loses one a step and prefers one; in the held pair each holder takes, at the two "
     "steps they take part, its choice of least risk at its own store, a condition, at no risk, predicting its next "
     "level, each store at its set point at every step, while together they end the pool's renewal, unseen (holder, "
     "heldPair_choices, held_not_one).",
     "持守者读其自身之储量，每步失一，偏好为一；于持守之对，各持守者于其参与之二步，于其自身储量（一条件）无风险地取其风险最少之选择，预测其下一水平，"
     "各储量每步皆在设定点，而共同终结池之更新，不可见（holder、heldPair_choices、held_not_one）。",
     C(S + 'holder', S + 'heldPair_choices', S + 'held_not_one')),
    ("The forager reads a stipulated store of three, uses two a step and prefers three, so takes two at no risk; the "
     "takes of Exceeding's two takers are its choices at the two steps they take part, and the same forager ends with "
     "the pair and continues alone (forager and five more).",
     "觅食者读规定之储量三，每步用二，偏好为三，故无风险地取二；Exceeding 二取者于其参与之二步所取即其选择，同一觅食者成对则终结、独处则延续"
     "（forager 等六项）。",
     C(K + 'forager', K + 'forager_choice', S + 'store', S + 'exceeding_choices', S + 'store_kept',
       S + 'alike_not_one')),
    ("Under the World premises, the gate at need m and the rest taking jointly more than a step gives at each of n "
     "steps from a level below n + m, a member outside the rest depending at a need of at least m is inactive from "
     "then on, whatever chooser gives its takes (need_ends, by Flow.outrun_below and Flow.outrun_ends).",
     "世界之前提、门控于需求 m、及他者于 n 步之每步共取多于一步所给（起于低于 n + m 之水平）之下，以至少 m 之需求依赖之他者之外之成员此后不活动，"
     "无论何选择者给其所取（need_ends，依 Flow.outrun_below 与 Flow.outrun_ends）。",
     C(K + 'need_ends')),
    ("With need one, every score reading the condition only from the rest's end on scores alike the course in which a "
     "member outside the rest takes a chooser's choice and the course in which it takes nothing; at the last outrun "
     "step, from a level of at most one, such a member takes nothing (restraint_unread, by Flow.outrun_reading_alike; "
     "outside_takes_nothing).",
     "需求为一时，凡仅自他者之终起读条件之评分，于他者之外之成员取选择者之选择与其不取之历程评分相同；于最后超出之步，水平至多为一时，此成员不取"
     "（restraint_unread，依 Flow.outrun_reading_alike；outside_takes_nothing）。",
     C(K + 'restraint_unread', K + 'outside_takes_nothing')),
    ("Where a chooser reading the level predicts, at no risk, a level at least the need, the level reached across the "
     "step is below the prediction, at every step from the rest's end on (expectation_not_course).",
     "读水平之选择者无风险地预测至少为需求之水平，则自他者之终起每步，该步所达之水平低于其预测（expectation_not_course）。",
     C(K + 'expectation_not_course')),
    ("A witness at need three: the forager takes two at no risk, the rest takes three against a renewal of two, and "
     "from step one the forager is inactive, by need_ends, as it is restrained (Outrun: ends_either_way and thirteen "
     "more).",
     "需求为三之例：觅食者无风险地取二，他者取三而更新为二，自第一步起觅食者不活动（依 need_ends），克制亦然（Outrun：ends_either_way 等十四项）。",
     C(U + 'present', U + 'flow', U + 'restrained', U + 'web', U + 'balances', U + 'restrained_balances', U + 'acting',
       U + 'restrained_acting', U + 'dependent', U + 'gated', U + 'distinct', U + 'rest_present', U + 'outside',
       U + 'ends_either_way')),
    ("A goal over the shared level: two regulators reading the level and preferring four, each counting only its own "
     "take, continue with every member active (OneGoal: continues and ten more).",
     "对共享水平之一目标：二调节者读水平而偏好其为四，各只计己取，延续，每一成员皆活动（OneGoal：continues 等十一项）。",
     C(O + 'regulator', O + 'regulator_choice', O + 'level', O + 'flow', O + 'web', O + 'balances', O + 'level_two',
       O + 'dependent', O + 'acting', O + 'gated', O + 'continues')),
    ("Three such regulators each take two at no risk, each within what is given, while together they take six against "
     "a level of four and a renewal of two, and from step one no member is active (three_end and eight more).",
     "三如此之调节者各无风险地取二，各在所给之内，而共取六，水平为四、更新为二，自第一步起无成员活动（three_end 等九项）。",
     C(O + 'Three', O + 'threeLevel', O + 'threeFlow', O + 'threeWeb', O + 'threeBalances', O + 'threeActing',
       O + 'threeDependent', O + 'threeGated', O + 'three_end')),
]
cited_a = [d for _, _, ds in groups_a for d in ds]
cited_b = [d for _, _, ds in groups_b for d in ds]
cited = cited_a + cited_b
assert len(cited) == len(set(cited)) == COUNT, (len(cited), len(set(cited)))
assert set(cited) == names, sorted(names - set(cited))

laws_a = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups_a]
laws_b = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups_b]
assert max(len(laws_a), len(laws_b)) <= style.ITEM_CAPS_V2['laws'][2]


def validation(count):
    return capped('validation_scope', {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {count} of the {COUNT} '
              f'declarations of {M}, the rest cited by its sibling record, each with an empty axiom report. Drafted by '
              f'an AI agent and read in the session; an independent read-only review by another AI agent (REVIEW-UE16) '
              f'and a re-check, study section {N}; not reviewed by a person. The laws apply landed theorems.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{M} 之 {COUNT} 项声明中之 {count} 项，余者由其姊妹记录引用，公理报告皆空。'
              f'由一 AI 代理起草，会话中审读；另一 AI 代理作独立只读审查（REVIEW-UE16）并复查，见研究第 {N} 节；未经人审。诸律应用已落地之定理。'})


title_a = capped('title', {'en': 'Identical cells under a descent that treats them alike', 'zh': '同等相待之下降中之同一细胞'})
statement_a = capped('statement', {
    'en': "Under a descent moving every cell by one rule from its own state and a field read off the states alone, "
          "cells alike at the start stay alike; with the field exchangeable, among configurations of one size the "
          "minima of a symmetric free energy come in exchanged pairs, a unique one with its cells alike.",
    'zh': '于以一规则依细胞自身状态与只读诸状态之场移动每一细胞之下降，起点相同之细胞保持相同；场可交换时，同一细胞数中对称自由能之极小成交换之对，故唯一者其细胞相同。'})
hypotheses_a = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. A configuration is the list of the cells' states, of any type; the descent is any rule from a "
           "cell's own state and the field it senses; the field reads the configuration, never a cell's number, and is "
           "exchangeable where a law says so.",
     'zh': '不加公理。构型为诸细胞状态之列，状态可为任何类型；下降为依细胞自身状态与其所感之场之任一规则；场读构型而不读细胞之编号，律需之处场可交换。'},
    {'en': "Modelling choices: discrete synchronous steps; exchanges of neighbouring cells only; minima compared among "
           "configurations of one number of cells, since a summed free energy is least at no cells; natural-number free "
           "energies; the witness's states from nothing to three; pointwise, with no function extensionality.",
     'zh': '建模之选：离散同步之步；仅交换相邻细胞；极小于同一细胞数之构型中比较，因求和之自由能于无细胞处最小；自由能为自然数；例之状态为零至三；皆逐点，不用函数外延性。'})]
does_not_show_a = [capped('does_not_show', x, item=True) for x in (
    {'en': "That the 2015 paper's simulations fail: they break the symmetry by random initial expectations.",
     'zh': '2015 年论文之模拟失败：其以随机之初始期望破对称。', 'kind': 'non-implication'},
    {'en': "Anything of densities, variational free energy, noise or continuous time: independent fluctuations break "
           "the symmetry almost surely, and the law then does not apply.",
     'zh': '关于密度、变分自由能、噪声或连续时间之任何事：独立之涨落几乎必然破对称，此律遂不适用。', 'kind': 'scope'},
    {'en': "Exchanges of other than neighbouring cells, or which asymmetry differentiates actual cells.",
     'zh': '非相邻细胞之交换，或何种不对称分化实际之细胞。', 'kind': 'scope'},
    {'en': "Which configuration, differentiated or not, is better.",
     'zh': '何构型（分化与否）更好。', 'kind': 'non-implication'})]
next_delta_a = capped('next_delta', {
    'en': "A frozen run of the 2015 scheme from exactly identical expectations with no noise; exchanges of any two "
          "cells; review by a person.",
    'zh': '2015 年方案自完全相同之期望、无噪声之冻结运行；任二细胞之交换；人之审查。'})
correspondence_a = capped('correspondence', {
    'en': "Symmetry breaking needs an asymmetric cause (Curie 1894, Journal de Physique 3); morphogenesis from a "
          "homogeneous state needs disturbances an instability amplifies (Turing 1952, Philosophical Transactions B "
          "237). Against Friston, Levin, Sengupta and Pezzulo (2015, Journal of the Royal Society Interface 12, "
          "20141383), whose identical cells minimizing free energy from one location are said to be guaranteed unique "
          "places; their simulations start from random expectations, so the law forbids the guarantee read for a "
          "deterministic descent from a symmetric start, not the simulations (UE1's search, candidate 1, graded b). "
          "Never parting needs only a descent reading no cell's number; the commuting law (what-a-commuting-law-keeps-"
          "apart) gives the exchanged run and the paired minima, beside the obstruction for codes and roles in 05 §9; "
          "uniqueness is symmetric choice (Angluin 1980; Relabel.EquivariantChoice.withholds_of_full_tie). Graded in "
          "UE16's NOTE.",
    'zh': '破对称需不对称之因（Curie 1894，Journal de Physique 3）；自均匀态之形态发生需不稳定性放大之扰动（Turing 1952，Philosophical Transactions B 237）。'
          '针对 Friston、Levin、Sengupta、Pezzulo（2015，Journal of the Royal Society Interface 12，20141383）：其称自一处最小化自由能之同一细胞必得唯一之位；'
          '其模拟始于随机之期望，故此律所禁者为自对称起点之确定性下降之保证，非其模拟（UE1 之搜索，候选 1，b 级）。不分离只需下降不读细胞编号；可交换律给出交换之运行与成对之极小，'
          '与 05 §9 之码与角色之阻碍并列；唯一性即对称之选择（Angluin 1980；Relabel.EquivariantChoice.withholds_of_full_tie）。分级见 UE16 之 NOTE。'})
counterexamples_a = [
    {'en': "In TwoCells two cells at [1, 1] rest where they started (TwoCells.alike_rests), and from any two alike cells "
           "the free energy stays at six, above the nothing of [0, 3] (TwoCells.alike_never_least), while a start "
           "differing by one unit parts them to either end (TwoCells.parts).",
     'zh': 'TwoCells 中 [1, 1] 之二细胞静止于起点（TwoCells.alike_rests），自任二相同细胞起自由能恒为六，高于 [0, 3] 之零（TwoCells.alike_never_least）；'
           '而相差一单位之起点使其分至两端（TwoCells.parts）。'}]

title_b = capped('title', {'en': 'Risk minimization on a shared renewal', 'zh': '共享更新上之风险最小化'})
statement_b = capped('statement', {
    'en': "Holders of one generative model, each taking its choice of least risk at its own store, each store at its "
          "set point at every step, together end the renewal they share; a member outside a rest that outruns a gated "
          "renewal has its need end whatever its model and preference.",
    'zh': '一生成模型之诸持守者，各于其自身储量取风险最少之选择，各储量每步皆在设定点，共同终结其所共享之更新；他者超出门控之更新时，他者之外之成员无论其模型与偏好，其需求皆终结。'})
hypotheses_b = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. For the ending: the World premises (balance, activity needing support, only active giving), the "
           "gate at need m, the rest listed without repetition, present where it takes, taking jointly more than a step "
           "gives at each of n steps from a level below n + m, and a member outside the rest.",
     'zh': '不加公理。终结所需：世界之前提（平衡、活动需支持、唯活动者给予）、需求 m 之门控、他者无重复列出、取时在场、于 n 步之每步共取多于一步所给，'
           '起于低于 n + m 之水平，及他者之外之成员。'},
    {'en': "The chooser's own hypotheses enter no premise of the ending: its takes may be any. The unread law takes need "
           "one; at the last outrun step, from a level of at most one, a member outside the rest that takes part takes "
           "nothing. The held pair's laws are those of the landed set point, its holders taking part at two steps.",
     'zh': '选择者自身之假设不入终结之前提：其所取可为任何。不可读之律需需求为一；于最后超出之步，水平至多为一时，他者之外之参与成员不取。持守之对之律即已落地之设定点之律，其持守者参与二步。'},
    {'en': "Modelling choices: a chooser of one step, its model a point prediction with no probability, its risk the "
           "distance of the prediction from its preferred level, ties to the earlier amount; natural-number levels "
           "and amounts; the holders' stores conditions of the web, the foragers' stores stipulated readings.",
     'zh': '建模之选：一步之选择者，其模型为无概率之点预测，其风险为预测与偏好水平之距离，平局取较前之量；水平与量为自然数；持守者之储量为网之条件，觅食者之储量为规定之读数。'})]
does_not_show_b = [capped('does_not_show', x, item=True) for x in (
    {'en': "That the papers' simulations fail: they have no shared draw.",
     'zh': '诸论文之模拟失败：其无共享之汲取。', 'kind': 'non-implication'},
    {'en': "Anything of expected free energy beyond risk in counting form: ambiguity, the epistemic term, precision, "
           "the softmax over policies, policies over more than one step, learning.",
     'zh': '计数形式之风险以外之期望自由能：模糊性、认知项、精度、策略之 softmax、多步策略、学习。', 'kind': 'scope'},
    {'en': "That a goal over the shared level keeps a collective going: two regulators each counting only its own take "
           "continue, three end at the first step.",
     'zh': '对共享水平之目标使集体延续：各只计己取之二调节者延续，三者于第一步终结。', 'kind': 'non-implication'},
    {'en': "That the outrun law forbids the authors' gloss of risk minimization: it forbids only the wording that risk "
           "minimization ensures needs are met.",
     'zh': '超出律禁作者对风险最小化之注解：其所禁唯风险最小化保证需求得满足之措辞。', 'kind': 'non-implication'},
    {'en': "Who ought to take less, or that the ending is a loss: no evaluation enters.",
     'zh': '谁应少取，或终结为损失：不涉评价。', 'kind': 'non-implication'})]
next_delta_b = capped('next_delta', {
    'en': "Expected free energy with its ambiguity term within a lumping (UE19); conditions under which a shared "
          "reading of the joint outcome keeps a collective going; review by a person.",
    'zh': '于归并之内带模糊项之期望自由能（UE19）；对共同结果之共享读取使集体延续之条件；人之审查。'})
correspondence_b = capped('correspondence', {
    'en': "The commons (Lloyd 1833; Hardin 1968, Science 162) and pivotality (Palfrey and Rosenthal 1984). Against "
          "Albarracin and others (2024, Systems 12, 163), "
          "where risk minimization ensures that an agent's needs are met, and Friston, Ramstead and others (2024, "
          "Collective Intelligence 3) with Da Costa and others (2025, arXiv:2410.00258), where with one generative "
          "model and one set of preferences each agent's goal is the group's: read as guarantees, both fail where the "
          "rest outruns a gated renewal, or alike preferences are indexical; their simulations have no shared draw "
          "(UE1's search, candidates 2 and 3, graded b; candidate 2 weak). Claim 3's forbidding is the landed held "
          "pair (what-a-set-point-optimum-does-beyond), here with each take a generative model's least-risk choice; "
          "the others apply the outrun law and joint excess. Graded in UE16's NOTE.",
    'zh': '公地（Lloyd 1833；Hardin 1968，Science 162）与关键性（Palfrey、Rosenthal 1984）。针对 Albarracin 等（2024，Systems 12，163）：风险最小化保证主体之需求得满足；及 Friston、Ramstead 等'
          '（2024，Collective Intelligence 3）与 Da Costa 等（2025，arXiv:2410.00258）：一生成模型与一组偏好使每一主体之目标即群体之目标。作保证读，'
          '二者于他者超出门控之更新、或相同之偏好为指己时皆失效；其模拟无共享之汲取（UE1 之搜索，候选 2 与 3，b 级；候选 2 弱）。候选 3 之禁即已落地之持守之对，'
          '此处每一所取为生成模型之最少风险之选择；余者应用超出律与共同超出。分级见 UE16 之 NOTE。'})
counterexamples_b = [
    {'en': "In the held pair each holder takes its choice of least risk at its own store at no risk at the two steps they "
           "take part, each store at its set point at every step, while the pool's renewal ends from step two, unseen "
           "by either (held_not_one).",
     'zh': '于持守之对，各持守者于其参与之二步，于其自身储量无风险地取风险最少之选择，各储量每步皆在设定点，而池之更新自第二步起终结，二者皆不见（held_not_one）。'},
    {'en': "Three regulators of the shared level, each counting only its own take, end at the first step "
           "(OneGoal.three_end).",
     'zh': '共享水平之三调节者，各只计己取，于第一步终结（OneGoal.three_end）。'},
    {'en': "In Exceeding each forager takes its choice of least risk at no risk and its predicted store is kept, while "
           "from step two no member is active, the renewer included (alike_not_one, store_kept).",
     'zh': 'Exceeding 中每一觅食者无风险地取其风险最少之选择，其预测之储量得保持，而自第二步起无成员活动，更新者亦然（alike_not_one、store_kept）。'},
    {'en': "In OneGoal two takers read the shared level and prefer it at four, and every member continues, by what both "
           "read of the level (OneGoal.continues).",
     'zh': 'OneGoal 中二取者皆读共享之水平而偏好其为四，每一成员皆延续，凭二者所读之水平（OneGoal.continues）。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


for rid, title, statement, laws, hypotheses, dns, cex, nd, corr, count in (
        (RIDA, title_a, statement_a, laws_a, hypotheses_a, does_not_show_a, counterexamples_a, next_delta_a,
         correspondence_a, len(cited_a)),
        (RIDB, title_b, statement_b, laws_b, hypotheses_b, does_not_show_b, counterexamples_b, next_delta_b,
         correspondence_b, len(cited_b))):
    assert not lint_errors({'schema_version': 2, 'id': rid, 'title': title, 'statement': statement, 'laws': laws,
                            'hypotheses': hypotheses, 'does_not_show': dns,
                            'counterexamples': [{'detail': x} for x in cex],
                            'validation_scope': validation(count), 'next_delta': nd, 'correspondence': corr})

# UE1's record, brought to a containment with third parts
UE1_CORR_OLD = ("A restatement with its third part open; the readings are the AI's, stated in "
                "development/ue1-fep-bridge/NOTE.md with the sources read and the review in REVIEW-UE1.md.")
UE1_CORR_NEW = ("Its own laws restate; the containment's third parts are UE16's two related records, on identical "
                "cells and on risk minimization. The readings are the AI's, in development/ue1-fep-bridge/NOTE.md, the "
                "review in REVIEW-UE1.md.")
UE1_CORR_ZH_OLD = "为一重述，其第三部分未定；读法皆 AI 之读，载于 development/ue1-fep-bridge/NOTE.md 并列所读之源，审查见 REVIEW-UE1.md。"
UE1_CORR_ZH_NEW = "其自身之律为重述；包含之第三部分为 UE16 之二相关记录，论同一细胞与风险最小化。读法皆 AI 之读，载于 development/ue1-fep-bridge/NOTE.md，审查见 REVIEW-UE1.md。"
UE1_NEXT_OLD = ("A third part against the free-energy principle, the first candidate a claim that belief sharing lets a "
                "collective respond to what no member couples to; a law")
UE1_NEXT_NEW = "A law"
UE1_NEXT_ZH_OLD = "对自由能原理之第三部分：其文献中理论所禁之陈述，首一候选为信念共享使集体回应无一成员所耦合者之说；"

if CAPS_ONLY:
    d = json.loads((RECORDS / f'{RIDU}.json').read_text(encoding='utf-8'))
    assert d['correspondence']['en'].count(UE1_CORR_OLD) == 1 and d['correspondence']['zh'].count(UE1_CORR_ZH_OLD) == 1
    assert d['next_delta']['en'].startswith(UE1_NEXT_OLD) and d['next_delta']['zh'].startswith(UE1_NEXT_ZH_OLD)
    corr = d['correspondence']['en'].replace(UE1_CORR_OLD, UE1_CORR_NEW)
    print(f'caps: ok; {len(cited_a)} + {len(cited_b)} declarations in {len(laws_a)} + {len(laws_b)} laws; statements',
          len(statement_a['en']), len(statement_a['zh']), len(statement_b['en']), len(statement_b['zh']),
          '; correspondences', len(correspondence_a['en']), len(correspondence_a['zh']), len(correspondence_b['en']),
          len(correspondence_b['zh']), "; UE1's correspondence", len(d['correspondence']['en']), '->', len(corr),
          '; laws max', max(len(x['en']) for x in laws_a + laws_b), max(len(x['zh']) for x in laws_a + laws_b))
    raise SystemExit(0)

common_refs = [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
               {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
               {'path': SEARCH, 'role': 'integration', 'sha256': sha(SEARCH)},
               {'path': CH5, 'role': 'statement', 'sha256': sha(CH5)}]
binding = [{'source': LEAN['FreeEnergyGuarantees'], 'receipt': RECEIPT,
            'sha256_pointer': f'/source_sha256/{M}',
            'success_pointer': '/status', 'success_value': 'passed'}]
history_new = {
    RIDA: {'en': f'{DATE_EN}: added (UE16), identical cells under a descent that treats them alike: under any descent '
                 f'reading no cell\'s number alike cells stay alike; with an exchangeable field the descent commutes with '
                 f'exchanging neighbouring cells, and among configurations of one size a symmetric free energy has its '
                 f'minima in exchanged pairs; the witness TwoCells; against guaranteed differentiation (Friston and '
                 f'others 2015, candidate 1); after a review and a re-check; study section {N}.',
           'zh': f'{DATE_ZH}：新增（UE16），同等相待之下降中之同一细胞：于不读细胞编号之任一下降，相同之细胞保持相同；场可交换时下降与交换相邻细胞可交换，'
                 f'同一细胞数中对称之自由能其极小成交换之对；例 TwoCells；针对必得分化之说（Friston 等 2015，候选 1）；经审查与复查；研究第 {N} 节。'},
    RIDB: {'en': f'{DATE_EN}: added (UE16), risk minimization on a shared renewal: a chooser of least risk has its need '
                 f'end where the rest outruns a gated renewal, unread after and below what it expects; alike '
                 f'preferences for own stores are not one goal, and a goal over the joint level no guarantee either (two '
                 f'regulators continue, three end); against risk minimization ensuring needs and shared preferences '
                 f'making a group goal (candidates 2 and 3); after a review and a re-check; study section {N}.',
           'zh': f'{DATE_ZH}：新增（UE16），共享更新上之风险最小化：他者超出门控之更新时，风险最少之选择者其需求终结，此后不可读，且低于其所预期；'
                 f'对各自储量之相同偏好非一目标，对共同水平之目标亦无保证（二调节者延续，三者终结）；针对风险最小化保证需求与共享偏好成群体目标之说（候选 2 与 3）；经审查与复查；研究第 {N} 节。'},
}
dependencies = {
    RIDA: [{'id': RIDC, 'relation': 'formal-reuse',
            'detail': {'en': 'Law.Commutes, Law.Commutes.keeps_fixed, Law.Commutes.iterate and Law.run: the commuting '
                             'law and the run of a law.',
                       'zh': 'Law.Commutes、Law.Commutes.keeps_fixed、Law.Commutes.iterate 与 Law.run：可交换律与律之运行。'}}],
    RIDB: [{'id': RIDO, 'relation': 'formal-reuse',
            'detail': {'en': 'Flow.outrun_below, Flow.outrun_ends and Flow.outrun_reading_alike: the rest outrunning '
                             'a gated renewal.',
                       'zh': 'Flow.outrun_below、Flow.outrun_ends 与 Flow.outrun_reading_alike：他者超出门控之更新。'}},
           {'id': RIDJ, 'relation': 'formal-reuse',
            'detail': {'en': 'Exceeding, Alone, Flow.WithinOwn, Flow.WithinJoint, Flow.Balances and Flow.Acting: joint '
                             'excess and its witnesses.',
                       'zh': 'Exceeding、Alone、Flow.WithinOwn、Flow.WithinJoint、Flow.Balances 与 Flow.Acting：共同超出及其例。'}},
           {'id': RIDS, 'relation': 'formal-reuse',
            'detail': {'en': 'Web.Dependent and Web.Supported: activity needing support, met by the witness.',
                       'zh': 'Web.Dependent 与 Web.Supported：活动需支持，例中满足之。'}},
           {'id': RIDH, 'relation': 'formal-reuse',
            'detail': {'en': 'Optimum.HeldPair and its held_end, by Flow.held_excess_ends: two holders at set points '
                             'end the pool\'s renewal; gap, the distance.',
                       'zh': 'Optimum.HeldPair 及其 held_end（依 Flow.held_excess_ends）：二持守者于设定点终结池之更新；gap 即距离。'}}],
}
aliases = {
    RIDA: ['Identical cells under a descent that treats them alike', '同等相待之下降中之同一细胞',
           'identical cells stay alike', 'guaranteed differentiation', 'symmetric free energy', 'TwoCells',
           f'{M}.IdenticalCells.all_alike_stay_alike', f'{M}.IdenticalCells.unique_minimum_alike'],
    RIDB: ['Risk minimization on a shared renewal', '共享更新上之风险最小化', 'risk minimization and needs',
           'alike preferences are not one goal', 'shared generative models', f'{M}.RiskAndNeeds.need_ends',
           f'{M}.SharedModels.held_not_one', f'{M}.SharedModels.alike_not_one'],
}
spec = {RIDA: (title_a, statement_a, laws_a, hypotheses_a, does_not_show_a, counterexamples_a, next_delta_a,
               correspondence_a, cited_a, [LEAN['Commuting']]),
        RIDB: (title_b, statement_b, laws_b, hypotheses_b, does_not_show_b, counterexamples_b, next_delta_b,
               correspondence_b, cited_b, [LEAN['Exclusion'], LEAN['Continuation'], LEAN['SetPointOptimum']])}
for rid, (title, statement, laws, hypotheses, dns, cex, nd, corr, decl, lean) in spec.items():
    record = {
        'schema_version': 2,
        'id': rid,
        'title': title,
        'kind': 'theorem',
        'status': 'recorded-checked',
        'family': 'F01',
        'reviewed_at_utc': NOW,
        'statement': statement,
        'laws': laws,
        'hypotheses': hypotheses,
        'does_not_show': dns,
        'counterexamples': [{'path': LEAN['FreeEnergyGuarantees'], 'detail': x} for x in cex],
        'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                                'omission-not-refutation'],
        'validation_scope': validation(len(decl)),
        'next_delta': nd,
        'correspondence': corr,
        'canonical_source': LEAN['FreeEnergyGuarantees'],
        'aliases': aliases[rid],
        'dependencies': dependencies[rid],
        'related': [{'id': RIDB if rid == RIDA else RIDA,
                     'detail': {'en': 'The other third part of the free-energy principle stated in the same module.',
                                'zh': '同一模块所陈自由能原理之另一第三部分。'}}],
        'references': [{'path': LEAN['FreeEnergyGuarantees'], 'role': 'proof', 'declarations': sorted(decl),
                        'sha256': sha(LEAN['FreeEnergyGuarantees'])}]
                      + [{'path': p, 'role': 'proof', 'sha256': sha(p)} for p in lean] + common_refs,
        'proof_bindings': binding,
        'history': [history_new[rid]],
    }
    for dep in [x['id'] for x in record['dependencies']]:
        assert (RECORDS / f'{dep}.json').exists(), dep
    path = RECORDS / f'{rid}.json'
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', rid, len(decl), 'declarations in', len(laws), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def history(d, en, zh):
    d['history'].append({'en': f'{DATE_EN}, board item UE16 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE16（研究第 {N} 节）：{zh}'})


RELATED = {
    RIDC: [(RIDA, {'en': 'Identical cells under a descent that treats them alike: with an exchangeable field the '
                         'commuting law gives the exchanged run and the paired minima of a free-energy descent; never '
                         'parting needs only a descent reading no cell\'s number.',
                   'zh': '同等相待之下降中之同一细胞：场可交换时，可交换律给出自由能下降之交换之运行与成对之极小；不分离只需下降不读细胞编号。'})],
    RIDO: [(RIDB, {'en': 'Risk minimization on a shared renewal: the outrun law read on a chooser of least risk, '
                         'against risk minimization ensuring needs.',
                   'zh': '共享更新上之风险最小化：超出律读于风险最少之选择者，针对风险最小化保证需求之说。'})],
    RIDJ: [(RIDB, {'en': 'Risk minimization on a shared renewal: joint excess read on foragers of one model with alike '
                         'preferences, against shared preferences making a group goal.',
                   'zh': '共享更新上之风险最小化：共同超出读于一模型且偏好相同之觅食者，针对共享偏好成群体目标之说。'})],
    RIDH: [(RIDB, {'en': 'Risk minimization on a shared renewal: the held pair\'s takes are one generative model\'s '
                         'choices of least risk at each holder\'s own store, against shared preferences making a group '
                         'goal.',
                   'zh': '共享更新上之风险最小化：持守之对之所取即一生成模型于各持守者自身储量之最少风险之选择，针对共享偏好成群体目标之说。'})],
}
for rid, entries in RELATED.items():
    d = load(rid)
    for new, detail in entries:
        assert new not in [x['id'] for x in d['related']]
        d['related'].append({'id': new, 'detail': detail})
    history(d, f'related to {", ".join(n for n, _ in entries)}; no statement, next step or declaration changed.',
            f'与 {"、".join(n for n, _ in entries)} 相关联；无一陈述、下一步或声明改变。')
    save(rid, d)

d = load(RIDU)
assert d['correspondence']['en'].count(UE1_CORR_OLD) == 1 and d['correspondence']['zh'].count(UE1_CORR_ZH_OLD) == 1
d['correspondence']['en'] = d['correspondence']['en'].replace(UE1_CORR_OLD, UE1_CORR_NEW)
d['correspondence']['zh'] = d['correspondence']['zh'].replace(UE1_CORR_ZH_OLD, UE1_CORR_ZH_NEW)
assert d['next_delta']['en'].startswith(UE1_NEXT_OLD) and d['next_delta']['zh'].startswith(UE1_NEXT_ZH_OLD)
d['next_delta']['en'] = UE1_NEXT_NEW + d['next_delta']['en'][len(UE1_NEXT_OLD):]
d['next_delta']['zh'] = d['next_delta']['zh'][len(UE1_NEXT_ZH_OLD):]
for new in (RIDA, RIDB):
    assert new not in [x['id'] for x in d['related']]
    d['related'].append({'id': new, 'detail': {
        'en': 'A third part of the free-energy principle\'s containment: a statement of its literature, read as a '
              'guarantee, that a landed law forbids on a model in its terms.',
        'zh': '自由能原理之包含之第三部分：其文献中作保证读之一陈述，已落地之律于其语汇之模型上禁之。'}})
history(d, 'the containment now has third parts (identical-cells-under-a-descent-treating-them-alike, '
           'risk-minimization-on-a-shared-renewal): the correspondence\'s last sentence and the next step brought to '
           'them, each related here; no statement or declaration changed.',
        '包含今有第三部分（identical-cells-under-a-descent-treating-them-alike、risk-minimization-on-a-shared-renewal）：对应之末句与下一步随之更新，'
        '二者于此相关联；无一陈述或声明改变。')
save(RIDU, d)
print('records related here:', RIDC, RIDO, RIDJ, RIDH, RIDU)
