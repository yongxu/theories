#!/usr/bin/env python3
"""UE19 records: write expected-free-energy-and-its-terms (the periphery module ExpectedFreeEnergyReals) and
what-seeking-cannot-separate (the core module Becoming.LumpedSeeking), both homed at 03 §6, each declaration of each
module cited once by its record; relate free-energy-bounds-surprisal, conditioning-by-restriction,
generalization-through-lumping, selection-under-registration-revision, capture-by-counted-choices and
risk-minimization-on-a-shared-renewal to them, each with a related entry and a history note; free-energy-bounds-surprisal's
next step and second does-not-show item, and risk-minimization-on-a-shared-renewal's next step, are brought to UE19, no
statement or declaration of theirs changing. Asserts both receipts' status, the modules' hashes,
empty axiom reports for the core module and at most Lean's three standard axioms for the periphery module, and the
style caps and lint on every field written. Mirrors UE18's make_records_ue18.py and UE17's make_records_ue17.py.
usage (from the checkout root, after texts_ue19.py): python3 -B make_records_ue19.py CORE_RECEIPT PERIPHERY_RECEIPT N
       python3 -B make_records_ue19.py --caps  (the caps, lint and the declaration cover against the kit's scratch
                                                audit and probe; writes nothing)"""
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
    RECEIPT_ID, PRECEIPT_ID, N = '20261029T000000.000000Z', '20261029T000000.000001Z', 452
else:
    RECEIPT_ID, PRECEIPT_ID, N = sys.argv[1], sys.argv[2], int(sys.argv[3])
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
FE = f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue19-expected-free-energy/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE19.md', KITD + 'RECHECK-UE19.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
CORE_MODULE = f'{PKG}/Becoming/LumpedSeeking.lean'
CW = f'{PKG}/Becoming/ConditionalWeights.lean'
PMODULE = f'{FE}/ExpectedFreeEnergyReals.lean'
FER = f'{FE}/FreeEnergyReals.lean'
CHECKER = f'{FE}/check_expected_free_energy_reals.py'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
PRECEIPT = f'{FE}/expected-free-energy-reals-checks/{PRECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDE = 'expected-free-energy-and-its-terms'
RIDS = 'what-seeking-cannot-separate'
RIDFE = 'free-energy-bounds-surprisal'
RIDCOND = 'conditioning-by-restriction'
RIDLUMP = 'generalization-through-lumping'
RIDREV = 'selection-under-registration-revision'
RIDU1 = 'capture-by-counted-choices'
RIDRISK = 'risk-minimization-on-a-shared-renewal'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT, PCOUNT = 27, 21
M, PM = 'Becoming.LumpedSeeking', 'ExpectedFreeEnergyReals'
STANDARD = {'propext', 'Classical.choice', 'Quot.sound'}


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingLumpedSeekingAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
    probe = (HERE.parent / 'periphery/probe-3.log').read_text(encoding='utf-8')
    pnames = set(re.findall(r"^'(Becoming\.ExpectedFreeEnergy\.\S+)' depends on axioms", probe, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256'][M] == sha(CORE_MODULE), M
    mod = next(x for x in core['modules'] if x['module'] == M)
    assert not any(mod['axiom_dependencies'].values()), M
    names = {d['name'] for d in mod['declarations']}
    periphery = json.loads((ROOT / PRECEIPT).read_text())
    assert periphery['status'] == 'passed' and periphery['bridge_module'] == PM
    assert periphery['source_sha256'][PM] == sha(PMODULE), 'the periphery module changed since the receipt'
    assert periphery['source_sha256']['FreeEnergyReals'] == sha(FER), 'FreeEnergyReals changed since the receipt'
    pmod = next(x for x in periphery['modules'] if x['module'] == PM)
    pnames = {d['name'] for d in pmod['declarations']}
    deps = pmod['axiom_dependencies']
    assert set(deps) == pnames, sorted(pnames ^ set(deps))
    for name, axioms in deps.items():
        assert set(axioms) <= STANDARD, (name, axioms)
assert len(names) == COUNT, len(names)
assert len(pnames) == PCOUNT, len(pnames)


def C(*short):
    out = [f'{M}.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


def P(*short):
    out = ['Becoming.ExpectedFreeEnergy.' + s for s in short]
    missing = [n for n in out if n not in pnames]
    assert not missing, missing
    return out


A = 'Agree.'
groups_s = [
    ("Two hypotheses a likelihood ties: its weights agree on them at every value of the record, so every record "
     "weighs alike under them (Tied, tied_mass).",
     "似然所并之二假设：其权重于记录之每一值皆相同，故每一记录于其下权重相同（Tied、tied_mass）。",
     C('Tied', 'tied_mass')),
    ("Given a record weighing something under a tied pair listed once, the share of one given it is at most the "
     "other's exactly where its prior weight is; where the record weighs nothing in the whole, the first's prior "
     "weight is nothing and both sides hold (single_le_evidence, posterior_le_iff_prior).",
     "记录于列而不重之受并二假设下有权重，则其一于记录下之份额至多为另一之份额，恰当其先验权重至多为之；记录于整体无权重时，前者之先验权重为零，两边皆成立"
     "（single_le_evidence、posterior_le_iff_prior）。",
     C('single_le_evidence', 'posterior_le_iff_prior')),
    ("The shares of a tied pair given any record stand as the prior weights do; where the prior weighs the false one "
     "strictly above the true one, every record weighing something under them leaves it above (posterior_ratio_kept, "
     "order_kept).",
     "受并二假设于任一记录下之份额，如其先验权重之比；先验置假者严格高于真者时，每一于其下有权重之记录皆令其仍居上（posterior_ratio_kept、order_kept）。",
     C('posterior_ratio_kept', 'order_kept')),
    ("A course of seeking weighs, at each step, the weight of choosing the experiment, read from the course so far, "
     "times the outcome's weight under it; a pair tied under every experiment is tied over every course (seekWeight, "
     "seek_tied).",
     "探求之历程于每一步之权重，为依迄今之历程选取实验之权重乘以结果于该实验下之权重；每一实验皆并之二假设，于每一历程皆并（seekWeight、seek_tied）。",
     C('seekWeight', 'seek_tied')),
    ("Where every experiment ties the true hypothesis and the false one and the prior weighs the false one strictly "
     "above, every record of courses of seeking weighing something under them leaves it above, whatever the policy "
     "of choice (seeking_keeps_order).",
     "每一实验皆并真假二假设，且先验置假者严格居上，则每一于其下有权重之探求历程之记录皆令其仍居上，无论择取之策略（seeking_keeps_order）。",
     C('seeking_keeps_order')),
    ("The witness: three coins, biased toward heads (true), fair and biased toward tails, with prior weights 5, 6 and "
     "7; a model reading only whether two tosses agree ties the biases, its weights totalling sixteen under each "
     "(Agree.Bias and eight more).",
     "例：三枚硬币，偏正面（真）、均匀、偏反面，先验权重为 5、6、7；唯读两次投掷是否相同之模型并二偏，其权重于每一者之下总和为十六（Agree.Bias 等九项）。",
     C(A + 'Bias', A + 'hypotheses', A + 'distinct', A + 'prior', A + 'outcomes', A + 'twoHeads', A + 'agreeing',
       A + 'ties', A + 'totals')),
    ("Given two heads, the true coin comes above the fair one, the wrong order the model separates turning, while the "
     "tails-biased one stays above the true one (Agree.turns_fair, Agree.keeps_tails).",
     "两次正面之下，真币升至均匀者之上，模型所分之误序得转；偏反面者仍居真币之上（Agree.turns_fair、Agree.keeps_tails）。",
     C(A + 'turns_fair', A + 'keeps_tails')),
    ("With only the experiment reading agreement, a course of two heads keeps the tails-biased coin above the true one "
     "(Agree.agreeCourse, Agree.seeking_keeps_tails).",
     "唯有读相同与否之实验时，两次正面之历程令偏反面者仍居真币之上（Agree.agreeCourse、Agree.seeking_keeps_tails）。",
     C(A + 'agreeCourse', A + 'seeking_keeps_tails')),
    ("With two experiments, reading both tosses or only whether they agree, and a policy choosing the first, the same "
     "outcome turns that order (Agree.readBoth, Agree.experiment, Agree.pickReading, Agree.readCourse, "
     "Agree.seeking_turns_tails).",
     "有二实验，读两次投掷或唯读其相同与否，策略择前者，则同一结果转此序（Agree.readBoth、Agree.experiment、Agree.pickReading、Agree.readCourse、"
     "Agree.seeking_turns_tails）。",
     C(A + 'readBoth', A + 'experiment', A + 'pickReading', A + 'readCourse', A + 'seeking_turns_tails')),
]
groups_e = [
    ("For finite states and outcomes, one policy's predicted distribution over states given: the predicted outcomes, "
     "risk (the divergence of the predicted outcomes from the preferred ones), ambiguity (the expected entropy of the "
     "likelihood), expected free energy, pragmatic and epistemic value (predicted and five more).",
     "于有限之状态与结果，给定一策略对状态之预测分布：预测之结果、风险（预测结果对偏好结果之散度）、模糊（似然之期望熵）、期望自由能、实用价值与认知价值"
     "（predicted 等六项）。",
     P('predicted', 'risk', 'ambiguity', 'expectedFreeEnergy', 'pragmatic', 'epistemic')),
    ("Risk plus ambiguity is the negative of the epistemic value less the pragmatic value, with no hypothesis "
     "(expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic).",
     "风险加模糊等于认知价值减实用价值之负，无任何假设（expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic）。",
     P('expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic')),
    ("The epistemic value is the divergence of the joint weights of states and outcomes from the product of the "
     "states' weights and the predicted outcomes, nonnegative where these are distributions (joint, product, "
     "epistemic_eq_divergence, epistemic_nonneg).",
     "认知价值为状态与结果之联合权重对状态权重与预测结果之积之散度，于其为分布处非负（joint、product、epistemic_eq_divergence、epistemic_nonneg）。",
     P('joint', 'product', 'epistemic_eq_divergence', 'epistemic_nonneg')),
    ("The epistemic value is the predicted outcomes' average of the divergence of FreeEnergyReals' posterior given "
     "each outcome from the states' weights, the expected information gain (gain_term, epistemic_eq_expected_gain).",
     "认知价值为 FreeEnergyReals 之后验于每一结果下对状态权重之散度，按预测结果之平均，即期望信息增益（gain_term、epistemic_eq_expected_gain）。",
     P('gain_term', 'epistemic_eq_expected_gain')),
    ("Where the likelihood reads a state only through its class, the predicted outcomes, the epistemic value and the "
     "expected free energy are the classes', with their total weights (coarse, sum_through, predicted_through, "
     "epistemic_through, expectedFreeEnergy_through).",
     "似然唯经其类读状态时，预测之结果、认知价值与期望自由能即诸类之值，以其总权重计（coarse、sum_through、predicted_through、epistemic_through、"
     "expectedFreeEnergy_through）。",
     P('coarse', 'sum_through', 'predicted_through', 'epistemic_through', 'expectedFreeEnergy_through')),
    ("So two beliefs alike on the classes have one expected free energy, under every likelihood reading through the "
     "classes and every preference (expectedFreeEnergy_same_of_coarse).",
     "故于诸类相同之二信念，于每一经类而读之似然与每一偏好下，有同一期望自由能（expectedFreeEnergy_same_of_coarse）。",
     P('expectedFreeEnergy_same_of_coarse')),
    ("One likelihood for every state the policy may reach gives epistemic value nothing; two states of one likelihood "
     "keep their prior ratio in the posterior under every outcome (epistemic_eq_zero_of_lumped, "
     "posterior_ratio_of_lumped).",
     "策略可达之每一状态皆同一似然，则认知价值为零；同一似然之二状态，于每一结果下其后验保先验之比（epistemic_eq_zero_of_lumped、"
     "posterior_ratio_of_lumped）。",
     P('epistemic_eq_zero_of_lumped', 'posterior_ratio_of_lumped')),
]
cited_s = [d for _, _, ds in groups_s for d in ds]
cited_e = [d for _, _, ds in groups_e for d in ds]
assert len(cited_s) == len(set(cited_s)) == COUNT and set(cited_s) == names, sorted(names - set(cited_s))
assert len(cited_e) == len(set(cited_e)) == PCOUNT and set(cited_e) == pnames, sorted(pnames - set(cited_e))
laws_s = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups_s]
laws_e = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups_e]

validation_s = capped('validation_scope', {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): all {COUNT} declarations of '
          f'{M}, each with an empty axiom report. Drafted by an AI agent; an independent read-only review by another AI '
          f'agent (REVIEW-UE19) and a re-check (RECHECK-UE19), study section {N}; not reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{M} 之全部 {COUNT} 项声明，公理报告皆空。由一 AI 代理起草；另一 AI 代理作独立只读审查'
          f'（REVIEW-UE19）并复查（RECHECK-UE19），见研究第 {N} 节；未经人审。'})
validation_e = capped('validation_scope', {
    'en': f'Machine-checked by the periphery checker check_expected_free_energy_reals.py with Lean 4.30.0-rc2 and the '
          f'pinned Mathlib (receipt {PRECEIPT_ID}): all {PCOUNT} declarations of {PM}, each on Lean\'s standard axioms '
          f'only, FreeEnergyReals and every core module of its closure matching a passed receipt. An independent review '
          f'by another AI agent (REVIEW-UE19) and a re-check, study section {N}; not reviewed by a person.',
    'zh': f'外围检查器 check_expected_free_energy_reals.py 以 Lean 4.30.0-rc2 与固定之 Mathlib 实查（回执 {PRECEIPT_ID}）：{PM} 之全部 '
          f'{PCOUNT} 项声明，皆只依 Lean 之标准公理，FreeEnergyReals 与其闭包之每一核心模块皆合于已通过之回执。另一 AI 代理作独立审查（REVIEW-UE19）'
          f'并复查，见研究第 {N} 节；未经人审。'})

title_s = capped('title', {'en': 'What seeking cannot separate', 'zh': '探求所不能分者'})
statement_s = capped('statement', {
    'en': "Two hypotheses every experiment ties keep their prior order under every course of seeking, however each "
          "experiment is chosen from the course so far; seeking corrects an order only where some experiment it can "
          "choose separates the pair.",
    'zh': '每一实验皆并之二假设，于每一探求历程下保其先验之序，无论每一实验如何依迄今之历程而选；探求唯于其可选之某一实验分此二者之处，方能纠正其序。'})
hypotheses_s = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Natural weights; hypotheses listed once and records listed, equality of hypotheses decided; for "
           "seeking, experiments and outcomes of any types.",
     'zh': '不加公理。自然数权重；假设列而不重，记录列出，假设之相等可判定；于探求，实验与结果为任意类型。'},
    {'en': "The tie is pointwise, the likelihood's weights agreeing on the pair at every value of the record, under every "
           "experiment for seeking; the record weighs something under the pair.",
     'zh': '并为逐点：似然之权重于记录之每一值于此二者皆相同，于探求则于每一实验皆然；记录于此二者下有权重。'},
    {'en': "Modelling choices: exact posteriors, shares compared by cross-multiplication; Boolean records; a policy of "
           "choice as a weight on each experiment read from the course so far; no logarithm and no transitions.",
     'zh': '建模之选：精确之后验，份额以交叉相乘比较；布尔记录；择取之策略为依迄今之历程置于每一实验之权重；无对数，无转移。'})]
does_not_show_s = [capped('does_not_show', x, item=True) for x in (
    {'en': "That seeking never corrects: within what some experiment separates it can (Agree.seeking_turns_tails; the "
           "principle's T-maze).",
     'zh': '探求从不纠正：于某一实验所分之内，探求能纠正（Agree.seeking_turns_tails；原理之 T 迷宫）。', 'kind': 'non-implication'},
    {'en': "Expected free energy itself, the softmax over policies, precision, multi-step policies with transitions, or "
           "novelty and structure learning.",
     'zh': '期望自由能本身、策略之 softmax、精度、具转移之多步策略，或新奇与结构之学习。', 'kind': 'scope'},
    {'en': "A theorem joining it to the periphery's expected free energy through the share given the record.",
     'zh': '经记录下之份额与外围之期望自由能相接之定理。', 'kind': 'scope'},
    {'en': "That actual agents' likelihoods tie what matters, or that a design built on the epistemic drive fails.",
     'zh': '实际主体之似然并其所关切者，或基于认知驱动之设计失败。', 'kind': 'non-implication'})]
next_delta_s = capped('next_delta', {
    'en': "A many-step form with lumpable transitions; the join to the periphery's expected free energy through "
          "givenShare_eq_posterior; novelty and structure learning as conditioning in a larger model; review by a "
          "person.",
    'zh': '具可归并转移之多步形式；经 givenShare_eq_posterior 与外围之期望自由能相接；新奇与结构之学习作为更大模型中之条件化；人之审查。'})
correspondence_s = capped('correspondence', {
    'en': "Identification (Rothenberg 1971, Econometrica 39) in its Bayesian form (Poirier 1998, Econometric Theory 14): "
          "a likelihood flat across parameters leaves their prior ratio unchanged by any data. In active inference the "
          "epistemic term draws an agent to the cue of the T-maze, where seeking corrects (Friston, Rigoli, Ognibene, "
          "Mathys, FitzGerald and Pezzulo 2015); one proposal reads it as inherent self-verification and "
          "self-correction (Wen 2025, arXiv:2508.05766; candidate 7 of UE1's search, graded (b), weak). The law forbids "
          "that wording unqualified, not active inference's account, which adds novelty and structure learning "
          "(Friston, Lin, Frith, Pezzulo, Hobson and Ondobaka 2017; Da Costa and others 2020). The posterior laws are "
          "corollaries of posterior_single and posterior_le_iff; new is the seeking form. Graded in UE19's NOTE.",
    'zh': '识别（Rothenberg 1971，Econometrica 39）之贝叶斯形式（Poirier 1998，Econometric Theory 14）：似然于诸参数间平坦，则任何数据皆不改其先验之比。'
          '于主动推断，认知项引主体至 T 迷宫之提示处，探求于彼纠正（Friston、Rigoli、Ognibene、Mathys、FitzGerald、Pezzulo 2015）；一提议读之为内在之'
          '自我验证与自我纠正（Wen 2025，arXiv:2508.05766；UE1 搜索之候选 7，评为 (b)，弱）。此律禁其不加限定之措辞，不禁主动推断之说明，后者另加新奇与'
          '结构之学习（Friston、Lin、Frith、Pezzulo、Hobson、Ondobaka 2017；Da Costa 等 2020）。后验之律为 posterior_single 与 posterior_le_iff 之'
          '推论；新者为探求之形式。分级见 UE19 之 NOTE。'})
counterexamples_s = [
    {'en': "Given two heads, under the model reading only whether two tosses agree, the tails-biased coin stays above the "
           "true one (Agree.keeps_tails), and with only that experiment, so does seeking (Agree.seeking_keeps_tails).",
     'zh': '两次正面之下，于唯读两次投掷是否相同之模型，偏反面者仍居真币之上（Agree.keeps_tails）；唯有此实验时，探求亦然（Agree.seeking_keeps_tails）。'}]

title_e = capped('title', {'en': 'Expected free energy and its terms', 'zh': '期望自由能及其诸项'})
statement_e = capped('statement', {
    'en': "Expected free energy, risk plus ambiguity, is the negative of epistemic less pragmatic value, the epistemic "
          "value an expected information gain; where the likelihood reads states only through classes it is the "
          "classes', so beliefs alike on the classes have one expected free energy.",
    'zh': '期望自由能（风险加模糊）即认知价值减实用价值之负，认知价值为期望信息增益；似然唯经类读状态时，其值即诸类之值，故于诸类相同之信念有同一期望自由能。'})
hypotheses_e = [capped('hypotheses', x, item=True) for x in (
    {'en': "In the periphery, on Mathlib's reals: each declaration depends on Lean's three standard axioms at most, "
           "reported by the module's checker; FreeEnergyReals' divergence and posterior are read unchanged.",
     'zh': '于外围，基于 Mathlib 之实数：每一声明至多依赖 Lean 之三条标准公理，由本模块之检查器报告；FreeEnergyReals 之散度与后验不加改动而读之。'},
    {'en': "The decompositions need no hypothesis; the divergence and gain forms need nonnegative weights, "
           "nonnegativity distributions; the forms through the lumping need the likelihood to read a state only through "
           "its class.",
     'zh': '二分解无需假设；散度与增益之形式需权重非负，非负性需分布；经归并之形式需似然唯经其类读状态。'},
    {'en': "Modelling choices: finite states and outcomes; real distributions; one step and one policy, its predicted "
           "distribution over states given; risk over outcomes; Mathlib's conventions log 0 = 0 and x / 0 = 0.",
     'zh': '建模之选：有限之状态与结果；实数之分布；一步一策略，给定其对状态之预测分布；风险取于结果之上；Mathlib 之约定 log 0 = 0 与 x / 0 = 0。'})]
does_not_show_e = [capped('does_not_show', x, item=True) for x in (
    {'en': "The softmax over policies, precision, multi-step policies with transitions, learning of the likelihood, "
           "novelty terms, or any process by which an agent reaches its choice.",
     'zh': '策略之 softmax、精度、具转移之多步策略、似然之学习、新奇项，或主体达成其选择之任何过程。', 'kind': 'scope'},
    {'en': "The data-processing bound: that a policy's epistemic value is at least its classes', the excess being what "
           "it tells about the split within a class.",
     'zh': '数据处理之界：策略之认知价值至少为其诸类之值，超出者即其所告类内之分。', 'kind': 'scope'},
    {'en': "A theorem joining it to the core's counting form: its ratio law is stated on FreeEnergyReals' posterior.",
     'zh': '与核心之计数形式相接之定理：其比之律述于 FreeEnergyReals 之后验之上。', 'kind': 'scope'},
    {'en': "Risk and pragmatic value as usually defined where the predicted outcomes weigh an outcome of preference "
           "nothing: infinite there, finite here by Mathlib's conventions.",
     'zh': '预测结果于偏好为零之结果有权重时，通常定义之风险与实用价值：彼处为无穷，此处依 Mathlib 之约定为有限。', 'kind': 'scope'},
    {'en': "That any agent chooses by expected free energy, or that its likelihood ties what matters.",
     'zh': '任一主体依期望自由能而选，或其似然并其所关切者。', 'kind': 'non-implication'})]
next_delta_e = capped('next_delta', {
    'en': "The data-processing bound; the join to the core's counting form through givenShare_eq_posterior; a many-step "
          "form with lumpable transitions; review by a person.",
    'zh': '数据处理之界；经 givenShare_eq_posterior 与核心之计数形式相接；具可归并转移之多步形式；人之审查。'})
correspondence_e = capped('correspondence', {
    'en': "Expected free energy as defined by Parr and Friston (2019, Biological Cybernetics 113): risk over outcomes "
          "plus ambiguity, equivalently the negative of epistemic value, the mutual information of states and outcomes, "
          "less pragmatic value, the expected log preference. Friston, Rigoli, Ognibene, Mathys, FitzGerald and "
          "Pezzulo (2015) split a policy's quality into extrinsic and epistemic value; Da Costa and others (2020) take "
          "risk over states and reach this form approximately. The expected information gain is the form Wen (2025, "
          "arXiv:2508.05766) names. The decompositions are the principle's definitions and the gain form is known; "
          "the forms through the lumping are near-definitional, new here in the principle's terms. Graded in UE19's "
          "NOTE.",
    'zh': '期望自由能依 Parr 与 Friston（2019，Biological Cybernetics 113）之定义：结果上之风险加模糊，等价于认知价值（状态与结果之互信息）减实用价值'
          '（期望对数偏好）之负。Friston、Rigoli、Ognibene、Mathys、FitzGerald、Pezzulo（2015）分策略之质为外在价值与认知价值；Da Costa 等（2020）'
          '取状态上之风险，近似得此形式。期望信息增益为 Wen（2025，arXiv:2508.05766）所称之形式。二分解为原理之定义，增益之形式已知；经归并之形式近乎定义，'
          '于原理之语汇中为新。分级见 UE19 之 NOTE。'})
counterexamples_e = [
    {'en': "Two beliefs splitting a class's weight differently, alike on the classes, have one expected free energy "
           "(expectedFreeEnergy_same_of_coarse): no choice by expected free energy tells them apart.",
     'zh': '二信念于一类内分其权重不同，而于诸类相同，有同一期望自由能（expectedFreeEnergy_same_of_coarse）：依期望自由能之选择不分二者。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


for rid, title, statement, laws, hypotheses, dns, cex, validation, nd, corr in (
        (RIDS, title_s, statement_s, laws_s, hypotheses_s, does_not_show_s, counterexamples_s, validation_s,
         next_delta_s, correspondence_s),
        (RIDE, title_e, statement_e, laws_e, hypotheses_e, does_not_show_e, counterexamples_e, validation_e,
         next_delta_e, correspondence_e)):
    assert not lint_errors({'schema_version': 2, 'id': rid, 'title': title, 'statement': statement, 'laws': laws,
                            'hypotheses': hypotheses, 'does_not_show': dns,
                            'counterexamples': [{'detail': x} for x in cex],
                            'validation_scope': validation, 'next_delta': nd, 'correspondence': corr})

if CAPS_ONLY:
    print(f'caps: ok; {len(cited_s)} + {len(cited_e)} declarations in {len(laws_s)} + {len(laws_e)} laws; statements',
          len(statement_s['en']), len(statement_s['zh']), len(statement_e['en']), len(statement_e['zh']),
          '; correspondences', len(correspondence_s['en']), len(correspondence_s['zh']), len(correspondence_e['en']),
          len(correspondence_e['zh']), '; laws max', max(len(x['en']) for x in laws_s + laws_e),
          max(len(x['zh']) for x in laws_s + laws_e))
    raise SystemExit(0)


def passed_run_for(folder, module, path):
    """The latest passed run of a checker holding the module's current bytes."""
    digest = sha(path)
    for run in sorted((ROOT / folder).glob('2*/verification.json'), reverse=True):
        data = json.loads(run.read_text())
        if data.get('status') == 'passed' and data.get('source_sha256', {}).get(module) == digest:
            return str(run.relative_to(ROOT))
    raise SystemExit(f'no passed receipt holds {module} as it is')


fe_receipt = passed_run_for(f'{FE}/free-energy-reals-checks', 'FreeEnergyReals', FER)
common_refs = [{'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
               {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
               {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)}]
spec = {
    RIDS: dict(
        title=title_s, statement=statement_s, laws=laws_s, hypotheses=hypotheses_s, does_not_show=does_not_show_s,
        counterexamples=[{'path': CORE_MODULE, 'detail': x} for x in counterexamples_s], validation_scope=validation_s,
        next_delta=next_delta_s, correspondence=correspondence_s, canonical_source=CORE_MODULE,
        aliases=['What seeking cannot separate', '探求所不能分者', 'identification under seeking', 'epistemic value',
                 'self-correction by seeking information', f'{M}.seeking_keeps_order', f'{M}.order_kept'],
        dependencies=[{'id': RIDCOND, 'relation': 'formal-reuse',
                       'detail': {'en': 'posterior_le_iff, posterior_single, evidence, mass_single, mass_mono, mass_congr '
                                        'and whole_restrict: shares given a record in a generative model.',
                                  'zh': 'posterior_le_iff、posterior_single、evidence、mass_single、mass_mono、mass_congr 与 '
                                        'whole_restrict：生成模型中记录下之份额。'}}],
        related=[{'id': RIDE, 'detail': {'en': 'Expected free energy and its terms: the epistemic value over the reals, '
                                               'read only through the lumping the likelihood makes.',
                                         'zh': '期望自由能及其诸项：实数上之认知价值，唯经似然所成之归并而读。'}}],
        references=[{'path': CORE_MODULE, 'role': 'proof', 'declarations': sorted(cited_s), 'sha256': sha(CORE_MODULE)},
                    {'path': CW, 'role': 'proof', 'sha256': sha(CW)},
                    {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)}] + common_refs,
        proof_bindings=[{'source': CORE_MODULE, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{M}',
                         'success_pointer': '/status', 'success_value': 'passed'}],
        history=[{'en': f'{DATE_EN}: added (UE19), what seeking cannot separate: a tied pair keeps its prior order given '
                        f'every record, and a pair every experiment ties over every course of seeking, whatever the '
                        f'policy of choice; in the witness, seeking turns the order once an experiment separating it is '
                        f'chosen; after a review and a re-check; study section {N}.',
                  'zh': f'{DATE_ZH}：新增（UE19），探求所不能分者：受并之二假设于每一记录下保其先验之序，每一实验皆并之二假设于每一探求历程下亦然，无论择取之'
                        f'策略；于例，一旦择取能分之实验，探求即转其序；经审查与复查；研究第 {N} 节。'}]),
    RIDE: dict(
        title=title_e, statement=statement_e, laws=laws_e, hypotheses=hypotheses_e, does_not_show=does_not_show_e,
        counterexamples=[{'path': PMODULE, 'detail': x} for x in counterexamples_e], validation_scope=validation_e,
        next_delta=next_delta_e, correspondence=correspondence_e, canonical_source=PMODULE,
        aliases=['Expected free energy and its terms', '期望自由能及其诸项', 'expected free energy', 'risk and ambiguity',
                 'epistemic and pragmatic value', 'expected information gain',
                 'Becoming.ExpectedFreeEnergy.expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic',
                 'Becoming.ExpectedFreeEnergy.expectedFreeEnergy_same_of_coarse'],
        dependencies=[{'id': RIDFE, 'relation': 'formal-reuse',
                       'detail': {'en': 'divergence and posterior: the divergence and the posterior of FreeEnergyReals.',
                                  'zh': 'divergence 与 posterior：FreeEnergyReals 之散度与后验。'}}],
        related=[{'id': RIDS, 'detail': {'en': 'What seeking cannot separate: in counting form, in the pure core, a pair '
                                               'every experiment ties keeps its prior order under every course of '
                                               'seeking.',
                                         'zh': '探求所不能分者：于纯核心之计数形式，每一实验皆并之二假设于每一探求历程下保其先验之序。'}}],
        references=[{'path': PMODULE, 'role': 'proof', 'declarations': sorted(cited_e), 'sha256': sha(PMODULE)},
                    {'path': FER, 'role': 'proof', 'sha256': sha(FER)},
                    {'path': PRECEIPT, 'role': 'receipt', 'sha256': sha(PRECEIPT)},
                    {'path': fe_receipt, 'role': 'receipt', 'sha256': sha(fe_receipt)},
                    {'path': CHECKER, 'role': 'integration', 'sha256': sha(CHECKER)}] + common_refs,
        proof_bindings=[{'source': FER, 'receipt': fe_receipt, 'sha256_pointer': '/source_sha256/FreeEnergyReals',
                         'success_pointer': '/status', 'success_value': 'passed'},
                        {'source': PMODULE, 'receipt': PRECEIPT, 'sha256_pointer': f'/source_sha256/{PM}',
                         'success_pointer': '/status', 'success_value': 'passed'}],
        history=[{'en': f'{DATE_EN}: added (UE19), expected free energy and its terms in the periphery: risk plus '
                        f'ambiguity as the negative of epistemic less pragmatic value, the epistemic value a divergence '
                        f'and an expected information gain, and expected free energy read only through the lumping its '
                        f'likelihood makes; after a review and a re-check; study section {N}.',
                  'zh': f'{DATE_ZH}：新增（UE19），外围之期望自由能及其诸项：风险加模糊即认知价值减实用价值之负，认知价值为散度与期望信息增益，期望自由能唯经其'
                        f'似然所成之归并而读；经审查与复查；研究第 {N} 节。'}]),
}
for rid, fields in spec.items():
    record = {'schema_version': 2, 'id': rid, 'title': fields['title'], 'kind': 'theorem', 'status': 'recorded-checked',
              'family': 'F01', 'reviewed_at_utc': NOW}
    for key in ('statement', 'laws', 'hypotheses', 'does_not_show', 'counterexamples'):
        record[key] = fields[key]
    record['standard_boundaries'] = ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                                     'omission-not-refutation']
    for key in ('validation_scope', 'next_delta', 'correspondence', 'canonical_source', 'aliases', 'dependencies',
                'related', 'references', 'proof_bindings', 'history'):
        record[key] = fields[key]
    for dep in [x['id'] for x in record['dependencies']]:
        assert (RECORDS / f'{dep}.json').exists(), dep
    path = RECORDS / f'{rid}.json'
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', rid, len(fields['references'][0]['declarations']), 'declarations in', len(fields['laws']), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


RELATED = {
    RIDFE: (RIDE, {'en': 'Expected free energy and its terms: risk, ambiguity, epistemic and pragmatic value stated beside '
                         'free energy, the epistemic value an expected information gain through this posterior.',
                   'zh': '期望自由能及其诸项：风险、模糊、认知价值与实用价值述于自由能之旁，认知价值为经此后验之期望信息增益。'}),
    RIDCOND: (RIDS, {'en': 'What seeking cannot separate: a tied pair keeps its prior order given every record, a '
                           'corollary of posterior_single and posterior_le_iff, and over every course of seeking.',
                     'zh': '探求所不能分者：受并之二假设于每一记录下保其先验之序，为 posterior_single 与 posterior_le_iff 之推论，于每一探求历程亦然。'}),
    RIDLUMP: (RIDE, {'en': 'Expected free energy and its terms: expected free energy reads beliefs only through the lumping '
                           'its likelihood makes.',
                     'zh': '期望自由能及其诸项：期望自由能唯经其似然所成之归并而读信念。'}),
    RIDREV: (RIDS, {'en': 'What seeking cannot separate: what every experiment ties stays in the prior\'s order; what '
                          'changes a tie couples in from beyond the model, as a revised lumping does.',
                    'zh': '探求所不能分者：每一实验皆并者保先验之序；改变此并者，自模型之外耦合而入，如修订之归并。'}),
    RIDU1: (RIDS, {'en': 'What seeking cannot separate: the third part against the unqualified wording of inherent '
                         'self-correction by seeking information (candidate 7).',
                   'zh': '探求所不能分者：针对“经探求信息而内在自我纠正”之不加限定措辞之第三部分（候选 7）。'}),
    RIDRISK: (RIDE, {'en': 'Expected free energy and its terms: risk and ambiguity over the reals; the chooser here takes '
                           'risk alone, as a distance from a point prediction.',
                     'zh': '期望自由能及其诸项：实数上之风险与模糊；此处之选择者唯取风险，为点预测之距离。'}),
}
# capture-by-counted-choices (UE1's record): its third parts named with UE19's, the length kept, asserted once
U1_EDITS = [
    ('en', "Its own laws restate; the containment's third parts are UE16's two related records, on identical cells and "
           "on risk minimization.",
     "Its own laws restate; its third parts are related records: identical cells, risk minimization and what seeking "
     "cannot separate."),
    ('zh', '其自身之律为重述；包含之第三部分为 UE16 之二相关记录，论同一细胞与风险最小化。',
     '其自身之律为重述；包含之第三部分为相关之记录：同一细胞、风险最小化与探求所不能分者。'),
]
# risk-minimization-on-a-shared-renewal: the next step brought to UE19, asserted to change once
RISK_EDITS = [
    ('next_delta', 'en', 'Expected free energy with its ambiguity term within a lumping (UE19); conditions under which',
     'Conditions under which'),
    ('next_delta', 'zh', '于归并之内带模糊项之期望自由能（UE19）；对共同结果', '对共同结果'),
]
# free-energy-bounds-surprisal: the next step and the second does-not-show item brought to UE19, each asserted once
FE_EDITS = [
    ('next_delta', 'en', 'Expected free energy and its epistemic term within a lumping (UE19); a core form of the bound',
     'A core form of the bound'),
    ('next_delta', 'zh', '期望自由能及其于一合并中之认知项（UE19）；界之核心形式', '界之核心形式'),
]
DNS1 = ('Expected free energy, or any process by which a system lowers its free energy, such as a gradient descent or '
        'message passing.',
        'Any process by which a system lowers its free energy, such as a gradient descent or message passing; expected '
        'free energy is stated in expected-free-energy-and-its-terms.',
        '期望自由能，或系统降低其自由能之任何过程，如梯度下降或消息传递。',
        '系统降低其自由能之任何过程，如梯度下降或消息传递；期望自由能述于 expected-free-energy-and-its-terms。')
for rid, (new, detail) in RELATED.items():
    d = load(rid)
    assert new not in [x['id'] for x in d['related']]
    d['related'].append({'id': new, 'detail': detail})
    if rid == RIDFE:
        for field, lang, old, repl in FE_EDITS:
            assert d[field][lang].count(old) == 1, (field, lang, old[:50])
            d[field][lang] = d[field][lang].replace(old, repl)
        x = d['does_not_show'][1]
        assert x['en'] == DNS1[0] and x['zh'] == DNS1[2], 'does_not_show[1]'
        x['en'], x['zh'] = capped('does_not_show', {'en': DNS1[1], 'zh': DNS1[3]}, item=True).values()
        capped('next_delta', d['next_delta'])
        en = (f'related to {new}; the next step drops expected free energy, now stated, and the second item of what it '
              f'does not show names the record that states it; no statement or declaration changed.')
        zh = f'与 {new} 相关联；下一步删去期望自由能（已述），所不示之第二项指明述之之记录；无一陈述或声明改变。'
    elif rid == RIDU1:
        for lang, old, repl in U1_EDITS:
            assert d['correspondence'][lang].count(old) == 1, (lang, old[:50])
            d['correspondence'][lang] = d['correspondence'][lang].replace(old, repl)
        en = (f'related to {new}; the correspondence names the containment\'s third parts, UE19\'s among them, by their '
              f'records; no statement, next step or declaration changed.')
        zh = f'与 {new} 相关联；对应以其记录指明包含之第三部分，UE19 者在其中；无一陈述、下一步或声明改变。'
    elif rid == RIDRISK:
        for field, lang, old, repl in RISK_EDITS:
            assert d[field][lang].count(old) == 1, (field, lang, old[:50])
            d[field][lang] = d[field][lang].replace(old, repl)
        en = f'related to {new}; the next step drops expected free energy, now stated; no statement or declaration changed.'
        zh = f'与 {new} 相关联；下一步删去期望自由能（已述）；无一陈述或声明改变。'
    else:
        en = f'related to {new}; no statement, next step or declaration changed.'
        zh = f'与 {new} 相关联；无一陈述、下一步或声明改变。'
    d['history'].append({'en': f'{DATE_EN}, board item UE19 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE19（研究第 {N} 节）：{zh}'})
    save(rid, d)
print('records related here:', ', '.join(RELATED))
