#!/usr/bin/env python3
"""UE23 records: expected-free-energy-and-its-terms gains seeking by expected free energy, joined to the core's seeking
(its statement extended to the course form, five laws citing the new declarations of ExpectedFreeEnergyReals, each
once, a hypothesis, three counterexamples, a formal-reuse dependency on what-seeking-cannot-separate and a binding to the
core receipt for Becoming.LumpedSeeking; its first and third does-not-show items and its next step brought to the join),
its validation scope, references and binding moved to the new receipt, with a history note; what-seeking-cannot-separate's
second and third does-not-show items, next step and related entry name the join, with a history note. Asserts the
receipt's hash, the standard axioms only and the declaration cover, and the style caps and lint on every field written.
Mirrors UE22's make_records_ue22.py.
usage (from the checkout root, after texts_ue23.py): python3 -B make_records_ue23.py RECEIPT_EFE N
       python3 -B make_records_ue23.py --caps RECEIPT_EFE  (caps, lint and cover against that receipt; writes nothing)"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = (sys.argv[2], 464) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG, FEP = f'{LEANR}/becoming', f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue23-seeking-by-expected-free-energy/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE23.md', KITD + 'RECHECK-UE23.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
MODULE = f'{FEP}/ExpectedFreeEnergyReals.lean'
SEEKING = f'{PKG}/Becoming/LumpedSeeking.lean'
CORE_RECEIPT = f'{PKG}/becoming-checks/20261029T164943.729811Z/verification.json'
RECEIPT = f'{FEP}/expected-free-energy-reals-checks/{RECEIPT_ID}/verification.json'
OLD_RECEIPT = f'{FEP}/expected-free-energy-reals-checks/20261030T043340.180184Z/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDE, RIDS = 'expected-free-energy-and-its-terms', 'what-seeking-cannot-separate'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
M = 'Becoming.ExpectedFreeEnergy.'
STANDARD = {'propext', 'Classical.choice', 'Quot.sound'}
HAS_RECHECK = (ROOT / RECHECK).exists()
assert 'RECHECK-PARAGRAPH' not in (ROOT / NOTE).read_text(encoding='utf-8'), 'a placeholder left in NOTE'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


receipt = json.loads((ROOT / RECEIPT).read_text())
assert receipt['status'] == 'passed' and receipt['bridge_module'] == 'ExpectedFreeEnergyReals'
assert receipt['source_sha256']['ExpectedFreeEnergyReals'] == sha(MODULE), 'the receipt binds another module'
assert receipt['source_sha256']['Becoming.LumpedSeeking'] == sha(SEEKING)
mod = receipt['modules'][0]
assert all(set(a) <= STANDARD for a in mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
TOTAL = len(names)
core = json.loads((ROOT / CORE_RECEIPT).read_text())
assert core['status'] == 'passed' and core['source_sha256']['Becoming.LumpedSeeking'] == sha(SEEKING)


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def C(*short):
    out = [M + s if not s.startswith('Becoming.') else s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


d = load(RIDE)
old = [x for law in d['laws'] for x in law['declarations']]
assert len(old) == len(set(old)) == 21 and set(old) <= names
groups = [
    ("A course of seeking, each experiment chosen from the course so far: the posterior after it, the prior times its "
     "likelihood normalized, is, with nonnegative weights and where the course weighs something, the belief of least "
     "free energy among those zero wherever the joint weights are; choice weights that weigh something, or each "
     "experiment's nonzero scale, drop out of it (coursePosterior_minimizes and nine more).",
     "探求之历程（每一实验依迄今之历程而选）：其后之后验，即先验乘其似然而归一，于权重非负且历程有权重处，于联合权重为零处亦为零之信念中自由能最小；"
     "历程上有权重之择取权重，或每一实验之非零尺度，皆于其中消去（coursePosterior_minimizes 等十项）。",
     C('courseLik', 'choiceWeight', 'coursePosterior', 'courseLik_nonneg', 'courseLik_pos', 'coursePosterior_minimizes',
       'posterior_choice_eq_coursePosterior', 'choiceWeight_ne_zero', 'courseLik_rescale', 'coursePosterior_rescale')),
    ("With natural weights and the hypotheses listed once, the core's share given a listed course is, as a real "
     "number, the posterior after it where the choices along it weigh something, however often the course is listed, "
     "and the core's order of two shares given it is the posterior's order; where the choices weigh nothing the share "
     "is 0 (givenCourse_eq_coursePosterior and six more).",
     "自然数权重且假设列而不重时，核心于所列历程下之份额作为实数即其后之后验，于其上之择取有权重处，无论此历程列几次；核心于其下二份额之序即后验之序；"
     "择取无权重处份额为 0（givenCourse_eq_coursePosterior 等七项）。",
     C('cast_seekWeight', 'mass_count', 'givenCourse_eq_coursePosterior', 'unchosen_share_zero',
       'share_le_iff_toReal_le', 'givenCourse_le_iff', 'Witness.unchosen_course')),
    ("Choice by a rule with natural weights reading the experiments' expected free energies is among the core's "
     "policies, so the core's law holds at it whatever the agent's model (an instance); over the reals a tied pair "
     "keeps its prior ratio, and its strict order where the course is possible under it, under every policy weighing "
     "the course something, the softmax among them (coursePosterior_order_kept and twelve more).",
     "依读诸实验之期望自由能之自然数权重规则以择实验，为核心之一策略，故无论主体之模型如何，核心之律于其成立（一实例）；于实数，每一实验皆并之二状态于每一历程后保其先验之比，"
     "于历程于其下可能处保其严格之序，于予此历程以权重之每一策略下，softmax 在其中（coursePosterior_order_kept 等十三项）。",
     C('courseWeight', 'efeChoice', 'softmax', 'softmax_pos', 'sum_softmax', 'softmax_choiceWeight_pos',
       'efe_seeking_keeps_order', 'courseLik_tied', 'coursePosterior_ratio_kept', 'coursePosterior_order_kept',
       'softmax_order_kept', 'Witness.agreeing_pos', 'Witness.separating_turns')),
    ("Where every likelihood reads a state only through its class, conditioning commutes with the lumping: at every "
     "step expected free energy and epistemic value are the classes', and priors alike on the classes choose alike "
     "under every rule and give every course one predictive weight; for any likelihoods, seeking by it reads the "
     "prior only through each likelihood profile's weight (seeking_reads_profiles and nine more).",
     "每一实验之似然唯经其类读状态时，条件化与归并可交换，故每一步之期望自由能与认知价值即诸类之值，于诸类相同之二先验于每一规则下择取相同、予每一历程同一预测权重；"
     "于任意似然，依之探求唯经其予每一似然轮廓之权重读先验（seeking_reads_profiles 等十项）。",
     C('courseLik_through', 'coarse_div', 'coarse_coursePosterior', 'efe_through_course', 'epistemic_through_course',
       'courseWeight_through', 'efeChoice_same_of_coarse', 'seeking_blind_to_split', 'softmax_blind_to_split',
       'seeking_reads_profiles')),
    ("The blindness bites: with an experiment reading agreement and one telling nothing, the coin's prior and the one "
     "exchanging the two biases' weights are alike on the classes, so after two heads their posteriors differ (25 and "
     "35 in 84) while under every rule, set of outcomes and preference they weigh both experiments alike at every "
     "course and every course alike (Witness.split_unseen and six more).",
     "盲之实效：有读是否相同之实验与一无所告之实验，硬币之先验与互换二偏币权重之先验于诸类相同，故两次正面后二者之后验不同（84 中之 25 与 35），而于每一规则、"
     "结果集与偏好下，二者于每一历程予二实验同一权重、予每一历程同一权重（Witness.split_unseen 等七项）。",
     C('Witness.biasClass', 'Witness.agreeOrNothing', 'Witness.agreeOrNothingByClass', 'Witness.swappedPrior',
       'Witness.agreeOrNothing_through', 'Witness.priors_alike', 'Witness.split_unseen')),
]
new = [x for _, _, ds in groups for x in ds]
assert not set(new) & set(old) and len(new) == len(set(new)), new
assert set(old) | set(new) == names, sorted(names - set(old) - set(new))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]
statement = capped('statement', {
    'en': "Expected free energy, risk plus ambiguity, is the negative of epistemic less pragmatic value, epistemic "
          "value an information gain; it reads beliefs only through the likelihood's classes, and seeking by it, its "
          "posterior the core's share given the course, reads the prior only through those classes.",
    'zh': '期望自由能（风险加模糊）即认知价值减实用价值之负，认知价值为信息增益；其唯经似然所成之类读信念，依之探求（其后验即核心于历程下之份额）亦唯经此诸类读先验。'})
hypothesis = capped('hypotheses', {
    'en': "For seeking: a policy is one experiment, the hidden state fixed over a course, the preferences one for every "
          "experiment, a rule reading the expected free energies and the experiment (so a fixed habit), with natural "
          "weights for the core's law; the join takes natural weights, hypotheses listed once, and a listed course its "
          "policy chooses with some weight; profiles compared classically.",
    'zh': '于探求：一策略即一实验，隐状态于历程中不变，偏好于每一实验相同，规则读期望自由能与实验（故含固定之习惯），核心之律需其为自然数权重；相接需自然数权重、'
          '假设列而不重、策略以某权重所选之所列历程；轮廓之比较为经典。'}, item=True)
dns0 = capped('does_not_show', {
    'en': "Precision as a belief, multi-step policies with transitions, habits learned from the course, learning of the "
          "likelihood, novelty terms, or any process by which an agent reaches its choice; the softmax only as one rule.",
    'zh': '作为信念之精度、具转移之多步策略、自历程习得之习惯、似然之学习、新奇项，或主体达成其选择之任何过程；softmax 仅作一规则。'}, item=True)
dns2 = capped('does_not_show', {
    'en': "Whether, or how often, an agent choosing by expected free energy chooses an experiment that separates: that "
          "turns on its preferences, its posterior and the experiments' information.",
    'zh': '依期望自由能而选之主体是否、或多常选取能分之实验：此取决于其偏好、其后验与诸实验之信息。'}, item=True)
counterexamples_new = [
    {'path': MODULE, 'detail': {
        'en': "Where an experiment separates, the posterior turns: with the coin's prior 5, 6 and 7, two heads read by "
              "the experiment reading both tosses put the true coin above the tails-biased one, which every course of "
              "the experiment reading agreement alone leaves above (Witness.separating_turns).",
        'zh': '实验能分处后验翻转：硬币之先验为 5、6、7，读两次投掷之实验读得两次正面，置真币于偏反面者之上，而唯读是否相同之实验之每一历程'
              '皆令后者居上（Witness.separating_turns）。'}},
    {'path': MODULE, 'detail': {
        'en': "A course the policy never chooses: the policy choosing the experiment reading both tosses never chooses "
              "two heads read by agreement, so the core's share given that course is 0 as a real number, while the "
              "posterior after it is not (Witness.unchosen_course).",
        'zh': '策略从不选之历程：选读两次投掷之实验之策略从不选唯读是否相同所读之两次正面，故核心于此历程下之份额作为实数为 0，而其后之后验不然'
              '（Witness.unchosen_course）。'}},
    {'path': MODULE, 'detail': {
        'en': "Two priors whose posteriors differ seek alike: with an experiment reading agreement and one telling "
              "nothing, the priors 5, 6, 7 and 7, 6, 5 give the heads-biased coin 25 and 35 in 84 after two heads, yet "
              "weigh both experiments alike at every course under every rule reading expected free energy "
              "(Witness.split_unseen).",
        'zh': '后验不同之二先验探求相同：有读是否相同之实验与一无所告之实验，先验 5、6、7 与 7、6、5 于两次正面后予偏正面之币 84 中之 25 与 35，'
              '而于读期望自由能之每一规则下于每一历程予二实验同一权重（Witness.split_unseen）。'}}]
OLD_NEXT_E = {'en': "the join to the core's counting form through givenShare_eq_posterior; ",
              'zh': '经 givenShare_eq_posterior 与核心之计数形式相接；'}
for lang in ('en', 'zh'):
    assert d['next_delta'][lang].count(OLD_NEXT_E[lang]) == 1, ('next', lang)
next_e = capped('next_delta', {k: d['next_delta'][k].replace(OLD_NEXT_E[k], '') for k in ('en', 'zh')})
COR_ADD = {'en': " For seeking: that data leave a prior's split within a class of observationally equivalent states "
                 "unchanged is Bayesian non-identification (Kadane 1974, Poirier 1998), the blindness of seeking its "
                 "corollary for designs whose criterion reads the posterior only through the classes; the softmax over "
                 "expected free energy is the principle's rule (Da Costa and others 2020); new is the join to the "
                 "core's seeking. Graded in UE23's NOTE.",
           'zh': '于探求：数据不改先验于观测等价之状态之类内之分，即贝叶斯之不可识别（Kadane 1974，Poirier 1998），探求之盲为其于准则唯经诸类读后验之'
                 '设计之推论；期望自由能之 softmax 为原理之规则（Da Costa 等 2020）；新者为与核心之探求相接。分级见 UE23 之 NOTE。'}
cor_e = capped('correspondence', {k: d['correspondence'][k] + COR_ADD[k] for k in ('en', 'zh')})
validation = capped('validation_scope', {
    'en': f"Machine-checked by the periphery checker check_expected_free_energy_reals.py with Lean 4.30.0-rc2 and the "
          f"pinned Mathlib (receipt {RECEIPT_ID}): all {TOTAL} declarations of ExpectedFreeEnergyReals, each on Lean's "
          f"standard axioms only, FreeEnergyReals and every core module of its closure, Becoming.LumpedSeeking among "
          f"them, matching a passed receipt. Independent reviews by other AI agents (REVIEW-UE19; REVIEW-UE23"
          f"{' and RECHECK-UE23' if HAS_RECHECK else ''} for seeking), study sections 453 and {N}; not reviewed by a "
          f"person.",
    'zh': f'外围检查器 check_expected_free_energy_reals.py 以 Lean 4.30.0-rc2 与定版 Mathlib 实查（回执 {RECEIPT_ID}）：'
          f'ExpectedFreeEnergyReals 全部 {TOTAL} 项声明只依标准公理，FreeEnergyReals 与闭包之核心模块（含 LumpedSeeking）'
          f'合于已通过之回执。AI 独立审查（REVIEW-UE19；REVIEW-UE23{"、RECHECK-UE23" if HAS_RECHECK else ""}），'
          f'研究第 453 与 {N} 节；未经人审。'})
related_s = {'en': "What seeking cannot separate: in counting form, in the pure core, a pair every experiment ties keeps "
                   "its prior order under every course of seeking; choice by expected free energy with natural weights "
                   "is among its policies (efe_seeking_keeps_order, an instance).",
             'zh': '探求所不能分者：于纯核心之计数形式，每一实验皆并之二假设于每一探求历程下保其先验之序；依期望自由能之择取为其一策略'
                   '（自然数权重者；efe_seeking_keeps_order，一实例）。'}

# the seeking record's fields, before anything is written
s = load(RIDS)
assert s['does_not_show'][1]['en'].startswith('Expected free energy itself, the softmax over policies')
assert s['does_not_show'][2]['en'].startswith("A theorem joining it to the periphery's expected free energy")
s_dns1 = capped('does_not_show', {
    'en': "Precision, multi-step policies with transitions, or novelty and structure learning; expected free energy "
          "enters in the periphery (efe_seeking_keeps_order with natural weights; the softmax over the reals, "
          "softmax_order_kept).",
    'zh': '精度、具转移之多步策略，或新奇与结构之学习；期望自由能于外围而入（自然数权重者 efe_seeking_keeps_order；softmax 于实数，softmax_order_kept）。',
    'kind': 'scope'}, item=True)
s_dns2 = capped('does_not_show', {
    'en': "Whether, or how often, an agent choosing by expected free energy chooses an experiment that separates: that "
          "turns on its preferences, its posterior and the experiments' information.",
    'zh': '依期望自由能而选之主体是否、或多常选取能分之实验：此取决于其偏好、其后验与诸实验之信息。', 'kind': 'scope'}, item=True)
OLD_NEXT_S = {'en': "the join to the periphery's expected free energy through givenShare_eq_posterior; ",
              'zh': '经 givenShare_eq_posterior 与外围之期望自由能相接；'}
for lang in ('en', 'zh'):
    assert s['next_delta'][lang].count(OLD_NEXT_S[lang]) == 1, ('next s', lang)
s_next = capped('next_delta', {k: s['next_delta'][k].replace(OLD_NEXT_S[k], '') for k in ('en', 'zh')})
related_e = {'en': "Expected free energy and its terms: over the reals, read only through the lumping the likelihood "
                   "makes; seeking by it with natural weights is among this law's policies (an instance), and where the "
                   "agent's model is the core's, its posterior is the core's share given the course "
                   "(givenCourse_eq_coursePosterior).",
             'zh': '期望自由能及其诸项：于实数，唯经似然所成之归并而读；依之以自然数权重探求为此律之一策略（一实例），主体之模型即核心之模型时，其后验即核心于历程下之份额'
                   '（givenCourse_eq_coursePosterior）。'}


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


e_hyp = d['hypotheses'] + [hypothesis]
assert d['does_not_show'][0]['en'].startswith('The softmax over policies, precision')
assert d['does_not_show'][2]['en'].startswith("A theorem joining it to the core's counting form")
e_dns = [dict(dns0, kind=d['does_not_show'][0]['kind'])] + d['does_not_show'][1:2] + \
    [dict(dns2, kind='scope')] + d['does_not_show'][3:]
e_counter = d['counterexamples'] + counterexamples_new
assert len(e_hyp) <= style.ITEM_CAPS_V2['hypotheses'][2] and len(e_dns) <= style.ITEM_CAPS_V2['does_not_show'][2]
assert len(d['laws']) + len(laws) <= style.ITEM_CAPS_V2['laws'][2]
assert not lint_errors({'schema_version': 2, 'id': RIDE, 'title': d['title'], 'statement': statement,
                        'laws': d['laws'] + laws, 'hypotheses': e_hyp, 'does_not_show': e_dns,
                        'counterexamples': e_counter, 'validation_scope': validation,
                        'next_delta': next_e, 'correspondence': cor_e})
assert not lint_errors({'schema_version': 2, 'id': RIDS, 'title': s['title'], 'statement': s['statement'],
                        'laws': s['laws'], 'hypotheses': s['hypotheses'],
                        'does_not_show': s['does_not_show'][:1] + [s_dns1, s_dns2] + s['does_not_show'][3:],
                        'counterexamples': s['counterexamples'], 'validation_scope': s['validation_scope'],
                        'next_delta': s_next, 'correspondence': s['correspondence']})
if CAPS_ONLY:
    print(f'caps: ok; {len(new)} new declarations in {len(laws)} laws over {TOTAL}; laws max',
          max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws), '; validation', len(validation['en']),
          len(validation['zh']), '; correspondence', len(cor_e['en']), len(cor_e['zh']), '; statement',
          len(statement['en']), len(statement['zh']))
    raise SystemExit(0)

# expected-free-energy-and-its-terms
d['statement'] = statement
d['laws'] += laws
d['hypotheses'] = e_hyp
d['does_not_show'] = e_dns
d['counterexamples'] = e_counter
d['validation_scope'] = validation
d['next_delta'] = next_e
d['correspondence'] = cor_e
d['reviewed_at_utc'] = NOW
for b in d['proof_bindings']:
    if b['source'] == MODULE:
        b['receipt'] = RECEIPT
assert not [b for b in d['proof_bindings'] if b['source'] == SEEKING]
d['proof_bindings'].append({'source': SEEKING, 'receipt': CORE_RECEIPT,
                            'sha256_pointer': '/source_sha256/Becoming.LumpedSeeking',
                            'success_pointer': '/status', 'success_value': 'passed'})
refs = d['references']
olds = [r for r in refs if r['path'] == OLD_RECEIPT]
assert len(olds) == 1
refs.remove(olds[0])
for r in refs:
    if r['path'] == MODULE and 'declarations' in r:
        r['declarations'] = sorted(names)
for path, role in [(SEEKING, 'proof'), (RECEIPT, 'receipt'), (CORE_RECEIPT, 'receipt'), (NOTE, 'integration'),
                   (REVIEW, 'integration')] + ([(RECHECK, 'integration')] if HAS_RECHECK else []):
    assert not [r for r in refs if r['path'] == path], path
    refs.append({'path': path, 'role': role, 'sha256': sha(path)})
for r in refs:
    r['sha256'] = sha(r['path'])
d['aliases'].append(M + 'seeking_reads_profiles')
assert RIDS not in [x['id'] for x in d['dependencies']]
d['dependencies'].append({'id': RIDS, 'relation': 'formal-reuse', 'detail': {
    'en': "seekWeight, Tied, seeking_keeps_order and the coin of Agree: the core's course of seeking, read over the "
          "reals with choice by expected free energy as its policy.",
    'zh': 'seekWeight、Tied、seeking_keeps_order 与 Agree 之硬币：核心之探求历程，以依期望自由能之择取为其策略，于实数读之。'}})
for x in d['related']:
    if x['id'] == RIDS:
        x['detail'] = related_s
d['history'].append({
    'en': f'{DATE_EN}, board item UE23 (study section {N}): seeking by expected free energy, joined to the core\'s seeking; '
          f'the statement extended to the course form; five laws citing the {len(new)} new declarations of '
          f'ExpectedFreeEnergyReals (the posterior after a course and its least free energy, the core\'s share given '
          f'the course as that posterior and the two orders as one, choice by expected free energy with natural weights '
          f'among the core\'s policies, the tie over the reals under every policy weighing the course something, the '
          f'course through the lumping and for any likelihoods, three witnesses), a hypothesis, three counterexamples, a formal-reuse dependency and a binding to the core '
          f'receipt for Becoming.LumpedSeeking; the first and third does-not-show items and the next step brought to the '
          f'join; receipt {RECEIPT_ID}; after an independent review{" and its recheck" if HAS_RECHECK else ""}, every '
          f'point taken. No earlier declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE23（研究第 {N} 节）：依期望自由能之探求与核心之探求相接；陈述扩至历程形式；五律引 ExpectedFreeEnergyReals 之 '
          f'{len(new)} 项新声明（历程后之后验及其自由能最小、核心于历程下之份额即此后验且二序为一、依期望自由能之自然数权重择取为核心之一策略、实数上予历程以权重之每一策略下之并、'
          f'经归并及于任意似然之历程、三见证），一前提、三反例、一形式复用之依赖，并绑定 Becoming.LumpedSeeking 之核心回执；所不示之第一与第三项及下一步依相接修订；'
          f'回执 {RECEIPT_ID}；经独立审查{"及复查" if HAS_RECHECK else ""}，诸点皆采。先前之声明皆未改变。'})
save(RIDE, d)

# what-seeking-cannot-separate
s['does_not_show'][1] = s_dns1
s['does_not_show'][2] = s_dns2
s['next_delta'] = s_next
for x in s['related']:
    if x['id'] == RIDE:
        x['detail'] = related_e
assert not [r for r in s['references'] if r['path'] == NOTE]
s['references'].append({'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)})
for r in s['references']:
    if r['path'] in (CH3, STUDY):
        r['sha256'] = sha(r['path'])
s['history'].append({
    'en': f'{DATE_EN}, board item UE23 (study section {N}): the theorem joining this law to the periphery\'s expected free '
          f'energy is proved there (givenCourse_eq_coursePosterior, givenCourse_le_iff, efe_seeking_keeps_order, in '
          f'expected-free-energy-and-its-terms); '
          f'the second and third does-not-show items, the next step and the related entry name the join. No statement, '
          f'law or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE23（研究第 {N} 节）：此律与外围之期望自由能相接之定理证于彼处（efe_seeking_keeps_order、'
          f'givenCourse_eq_coursePosterior、givenCourse_le_iff，见 expected-free-energy-and-its-terms）；所不示之第二与第三项、下一步与关联条目指明此相接。无一陈述、律或声明改变。'})
save(RIDS, s)
print('records:', RIDE, f'(statement, 5 laws, {len(new)} declarations over {TOTAL})', RIDS,
      '(does-not-show, next step, related)')
