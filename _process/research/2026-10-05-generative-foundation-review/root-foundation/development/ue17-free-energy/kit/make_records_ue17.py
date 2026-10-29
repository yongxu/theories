#!/usr/bin/env python3
"""UE17 record: write free-energy-bounds-surprisal (the periphery module FreeEnergyReals, homed in 03 after
conditioning by restriction), each declaration of the module cited once; relate conditioning-by-restriction and
capture-by-counted-choices to it, each with a related entry and a history note; conditioning-by-restriction's next
step, correspondence and third does-not-show item are brought to UE17; neither record's statement or declarations
change. Asserts the periphery receipt's status, the module's hash and that every declaration depends on
Lean's three standard axioms at most, and the style caps and lint (tools/research/style.py) on every field written.
The core module it reads, ConditionalWeights, is bound to the latest passed core receipt holding its current bytes.
Mirrors UE15's make_records_ue15.py and the periphery record regime-in-any-amounts.
usage (from the checkout root, after texts_ue17.py): python3 -B make_records_ue17.py RECEIPT N
       python3 -B make_records_ue17.py --caps RECEIPT  (the caps, lint and the declaration cover; writes nothing;
                                                         RECEIPT `source` reads the declarations from the source)"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID = sys.argv[2] if CAPS_ONLY else sys.argv[1]
N = 450 if CAPS_ONLY else int(sys.argv[2])
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
FE = f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue17-free-energy/'
NOTE, REVIEW = KITD + 'NOTE.md', KITD + 'REVIEW-UE17.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
MODULE = f'{FE}/FreeEnergyReals.lean'
CHECKER = f'{FE}/check_free_energy_reals.py'
CW = f'{PKG}/Becoming/ConditionalWeights.lean'
RECEIPT = f'{FE}/free-energy-reals-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'free-energy-bounds-surprisal'
RIDC = 'conditioning-by-restriction'
RIDU = 'capture-by-counted-choices'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 47
STANDARD = {'propext', 'Classical.choice', 'Quot.sound'}


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


def source_names():
    """The module's declarations read from its source (for --caps before a receipt holds its bytes)."""
    import re
    found, spaces = set(), []
    for line in (ROOT / MODULE).read_text(encoding='utf-8').split('\n'):
        m = re.match(r'(namespace|end) (\S+)$', line)
        if m and m.group(1) == 'namespace':
            spaces.append(m.group(2))
        elif m and spaces and spaces[-1] == m.group(2):
            spaces.pop()
        m = re.match(r'(?:theorem|noncomputable def|def) (\S+)', line)
        if m:
            n = m.group(1)
            found.add(n[len('_root_.'):] if n.startswith('_root_.') else '.'.join(spaces + [n]))
    return found


if CAPS_ONLY and RECEIPT_ID == 'source':
    names = source_names()
else:
    receipt = json.loads((ROOT / RECEIPT).read_text())
    assert receipt['status'] == 'passed' and receipt['bridge_module'] == 'FreeEnergyReals'
    assert receipt['source_sha256']['FreeEnergyReals'] == sha(MODULE), 'the module changed since the receipt'
    mod = next(x for x in receipt['modules'] if x['module'] == 'FreeEnergyReals')
    names = {d['name'] for d in mod['declarations']}
    deps = mod['axiom_dependencies']
    assert set(deps) == names, sorted(names ^ set(deps))
    for name, axioms in deps.items():
        assert set(axioms) <= STANDARD, (name, axioms)
assert len(names) == COUNT, (len(names), sorted(names))


def C(*short):
    out = [s if s.startswith('Becoming.') else 'Becoming.FreeEnergy.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("The quantities over a finite set of causes: variational free energy, the q-average of log q less log p, which is "
     "the divergence from the joint weights and the energy less the entropy; surprisal, the negative logarithm; the "
     "posterior, p over its total; the free energy reads a belief only at the causes (freeEnergy and six more).",
     "有限诸因上之量：变分自由能，即 q 加权之 log q 减 log p，亦即对联合权重之散度、能量减熵；惊异，即负对数；后验，即 p 除以其总和；"
     "自由能只读信念于诸因（freeEnergy 等七项）。",
     C('freeEnergy', 'divergence', 'surprisal', 'posterior', 'freeEnergy_congr', 'freeEnergy_eq_divergence',
       'freeEnergy_eq_energy_sub_entropy')),
    ("The bound, Gibbs' inequality: where q is nonnegative with total one, p nonnegative and q zero wherever p is, the "
     "surprisal of the total of p is at most the free energy, the total then positive; term by term from log x ≤ x − 1 "
     "(surprisal_le_freeEnergy, total_pos, term_le and two sums).",
     "界，即 Gibbs 不等式：q 非负且总和为一，p 非负，且 p 为零处 q 亦为零，则 p 之总和之惊异至多为自由能，其时总和为正；逐项由 log x ≤ x − 1"
     "（surprisal_le_freeEnergy、total_pos、term_le 及二和式）。",
     C('surprisal_le_freeEnergy', 'total_pos', 'term_le', 'sum_terms', 'sum_normalized_sub')),
    ("Equality exactly at the posterior: the bound is met exactly where q is the posterior, at which the free energy is "
     "the surprisal, and the posterior alone has the least free energy among beliefs zero wherever p is, where it is "
     "finite; off that support the bound fails under the convention log 0 = 0 (freeEnergy_eq_surprisal_iff and nine "
     "more).",
     "等号恰于后验：界恰于 q 为后验处取等，其时自由能即惊异，且于 p 为零处为零之诸信念中唯后验自由能最小；出此支撑，依 log 0 = 0 之约定界不成立"
     "（freeEnergy_eq_surprisal_iff 等十项）。",
     C('freeEnergy_eq_surprisal_iff', 'freeEnergy_eq_surprisal_iff_of_pos', 'term_eq_iff', 'term_eq_iff_of_pos',
       'posterior_nonneg', 'posterior_eq_zero', 'sum_posterior', 'freeEnergy_posterior', 'minimizes_iff_posterior',
       'Witness.bound_fails_off_support')),
    ("Divergence from the posterior plus surprisal: with no sign hypothesis the free energy is the divergence of the belief "
     "from the posterior plus the surprisal, the divergence nonnegative and zero exactly at the posterior, and between any "
     "two distributions likewise (freeEnergy_eq_divergence_add_surprisal and four more).",
     "对后验之散度加惊异：无符号假设，自由能即信念对后验之散度加惊异；散度非负，恰于后验为零；任二分布之间亦然"
     "（freeEnergy_eq_divergence_add_surprisal 等五项）。",
     C('freeEnergy_eq_divergence_add_surprisal', 'divergence_nonneg', 'divergence_eq_zero_iff',
       'divergence_posterior_nonneg', 'divergence_posterior_eq_zero_iff')),
    ("Complexity less accuracy: where p is a prior times a likelihood and q is zero wherever p is, the free energy is the "
     "divergence from the prior less the expected log-likelihood (freeEnergy_eq_complexity_sub_accuracy).",
     "复杂度减准确度：p 为先验乘似然，且 p 为零处 q 亦为零，则自由能即对先验之散度减期望对数似然（freeEnergy_eq_complexity_sub_accuracy）。",
     C('freeEnergy_eq_complexity_sub_accuracy')),
    ("The join to the core: a share read as part over whole; in a core generative model the joint weight of a hypothesis "
     "is the share of its courses whose record agrees, the joint weights sum to the record's share, and their posterior "
     "is the core's share given the record (givenShare_eq_posterior and eleven more).",
     "与核心相接：份额读作部分除以整体；于核心之生成模型，一假设之联合权重即其记录相符之诸历程之份额，诸联合权重之和即记录之份额，其后验即核心于"
     "记录下之份额（givenShare_eq_posterior 等十二项）。",
     C('Becoming.ConditionalWeights.Share.toReal', 'Becoming.ConditionalWeights.Share.toReal_nonneg', 'share_toReal_pos',
       'Becoming.ConditionalWeights.Share.toReal_mul', 'cast_mass_eq_sum',
       'jointShare_part', 'jointShare_toReal', 'recordShare_toReal', 'sum_jointShare', 'givenShare_toReal',
       'givenShare_eq_posterior', 'weight_zero_of_jointShare_zero')),
    ("In the core's terms, for beliefs zero where the prior or the record rules a hypothesis out, which exist only "
     "where the record weighs something: the record's surprisal is at most a belief's free energy, equal exactly at the "
     "core's share given the record, which alone has the least free energy (minimizes_iff_givenShare and four more).",
     "以核心之语，就先验或记录所排除之假设处为零之信念（唯记录有权重时有之）：记录之惊异至多为一信念之自由能，恰于核心之记录下份额取等，唯该份额"
     "自由能最小（minimizes_iff_givenShare 等五项）。",
     C('record_pos_of_belief', 'record_surprisal_le_freeEnergy', 'freeEnergy_eq_record_surprisal_iff',
       'freeEnergy_givenShare', 'minimizes_iff_givenShare')),
    ("Surprisal adds over independent parts, read from the core's product of shares, and the surprisal of a share is the "
     "logarithm of its reciprocal (surprisal_product, surprisal_eq_log_reciprocal).",
     "独立之部分上惊异相加，读自核心之份额之积；一份额之惊异即其倒数之对数（surprisal_product、surprisal_eq_log_reciprocal）。",
     C('surprisal_product', 'surprisal_eq_log_reciprocal')),
]
cited = [d for _, _, ds in groups for d in ds]
assert len(cited) == len(set(cited)) == COUNT, (len(cited), len(set(cited)))
assert set(cited) == names, sorted(names - set(cited))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

title = capped('title', {'en': 'Variational free energy bounds surprisal', 'zh': '变分自由能为惊异之界'})
statement = capped('statement', {
    'en': "Over finitely many causes, a belief zero where the joint weight is has variational free energy at least the "
          "record's surprisal, equal exactly at the posterior; in a core generative model that is the share given the "
          "record, so minimizing free energy over such beliefs is conditioning.",
    'zh': '于有限诸因之上，于联合权重为零处为零之信念，其变分自由能至少为记录之惊异，恰于后验取等；于核心之生成模型，此即记录下之份额，故于此等信念上最小化自由能即条件化。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "In the periphery, on Mathlib's reals: each declaration depends on Lean's three standard axioms at most, "
           "reported by the module's checker, Share.toReal and its two lemmas among them, periphery definitions in the "
           "core's namespace; the core laws it reads have empty axiom reports.",
     'zh': '于外围，基于 Mathlib 之实数：每一声明至多依赖 Lean 之三条标准公理，由本模块之检查器报告，Share.toReal 及其二引理亦然，为置于核心命名空间之外围定义；'
           '其所读之核心之律公理报告皆空。'},
    {'en': "The belief is nonnegative with total one and zero wherever the joint weight is, where its free energy is "
           "finite as usually defined; equality and the posterior's value need the joint weights' total not zero; such a "
           "belief over the core's hypotheses exists only where the record weighs something (record_pos_of_belief).",
     'zh': '信念非负且总和为一，于联合权重为零处为零，其处自由能依通常定义为有限；等号与后验之值需联合权重之总和不为零；于核心之假设上，如此之信念唯记录有权重时有之'
           '（record_pos_of_belief）。'},
    {'en': "Modelling choices: a finite set of causes; real beliefs and joint weights; in the core, natural weights and "
           "Boolean records, hypotheses listed without repetition; Mathlib's conventions log 0 = 0 and x / 0 = 0.",
     'zh': '建模之选：有限诸因；实数之信念与联合权重；于核心，自然数权重与布尔记录，假设列而不重；Mathlib 之约定 log 0 = 0 与 x / 0 = 0。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "Densities, continuous causes or continuous time.",
     'zh': '密度、连续之因或连续时间。', 'kind': 'scope'},
    {'en': "Expected free energy, or any process by which a system lowers its free energy, such as a gradient descent or "
           "message passing.",
     'zh': '期望自由能，或系统降低其自由能之任何过程，如梯度下降或消息传递。', 'kind': 'scope'},
    {'en': "That any system minimizes free energy.",
     'zh': '任一系统使自由能最小。', 'kind': 'non-implication'},
    {'en': "The bound's counting form for beliefs with natural counts, N^N·∏ a^n ≤ A^N·∏ n^n, or complexity and accuracy "
           "read from the core's own prior and likelihood shares.",
     'zh': '自然数计数之信念之界之计数形式 N^N·∏ a^n ≤ A^N·∏ n^n，或由核心自身之先验与似然份额读出之复杂度与准确度。', 'kind': 'scope'},
    {'en': "Beliefs confined to a family (mean-field, the Laplace approximation's Gaussian), whose least free energy "
           "exceeds the surprisal by the family's divergence from the posterior.",
     'zh': '限于一族之信念（平均场、拉普拉斯近似之高斯），其最小自由能超出惊异之量为该族对后验之散度。', 'kind': 'scope'},
    {'en': "Free energy as a bound on the long-run average of surprisal, the entropy of sensory states, or free energy "
           "over parameters and models, as in learning and model comparison.",
     'zh': '自由能作为长期平均惊异（感官状态之熵）之界，或参数与模型上之自由能，如学习与模型比较。', 'kind': 'scope'})]
next_delta = capped('next_delta', {
    'en': "Expected free energy and its epistemic term within a lumping (UE19); a core form of the bound, N^N·∏ a^n ≤ "
          "A^N·∏ n^n for beliefs with natural counts, equal, where the record weighs something, exactly at the share "
          "given the record; complexity and accuracy from the core's own shares; review by a person.",
    'zh': '期望自由能及其于一合并中之认知项（UE19）；界之核心形式：自然数计数之信念 N^N·∏ a^n ≤ A^N·∏ n^n，记录有权重时恰于记录下之份额取等；由核心自身份额读出之复杂度与准确度；人之审查。'})
correspondence = capped('correspondence', {
    'en': "Gibbs' inequality (Gibbs 1902) and the divergence of Kullback and Leibler (1951); the variational bound on the "
          "log evidence of variational Bayes (Hinton and van Camp 1993; Neal and Hinton 1998; the Helmholtz machine of "
          "Dayan, Hinton, Neal and Zemel 1995), the free-energy principle's variational free energy (Friston 2005, 2010), "
          "with the decompositions into divergence plus surprisal and into complexity less accuracy. Gibbs' inequality "
          "and its equality case are classical; the decompositions and the join are near-definitional. New is the join: "
          "the core states the posterior by counting, the periphery characterizes it as the one minimizer of free "
          "energy among the beliefs where it is finite. Graded in UE17's NOTE.",
    'zh': 'Gibbs 不等式（Gibbs 1902）与 Kullback、Leibler 之散度（1951）；变分贝叶斯之对数证据之变分界（Hinton、van Camp 1993；Neal、Hinton 1998；'
          'Dayan、Hinton、Neal、Zemel 之 Helmholtz 机 1995），即自由能原理之变分自由能（Friston 2005、2010），及散度加惊异、复杂度减准确度二分解。'
          'Gibbs 不等式及其取等之情形为经典；二分解与相接近乎定义。新者为相接：核心以计数述后验，外围刻画其为自由能唯一之最小者。分级见 UE17 之 NOTE。'})
validation = capped('validation_scope', {
    'en': f'Machine-checked by the periphery checker check_free_energy_reals.py with Lean 4.30.0-rc2 and the pinned Mathlib '
          f'(receipt {RECEIPT_ID}): all {COUNT} declarations of FreeEnergyReals, each on Lean\'s standard axioms only, every '
          f'core module of its closure matching a passed core receipt. An independent review by another AI agent '
          f'(REVIEW-UE17) and a re-check, study section {N}; not reviewed by a person.',
    'zh': f'外围检查器 check_free_energy_reals.py 以 Lean 4.30.0-rc2 与固定之 Mathlib 实查（回执 {RECEIPT_ID}）：FreeEnergyReals 之全部 {COUNT} '
          f'项声明，皆只依 Lean 之标准公理，其闭包之每一核心模块皆合于已通过之核心回执。另一 AI 代理作独立审查（REVIEW-UE17）并复查，见研究第 {N} 节；'
          f'未经人审。'})
counterexamples = [
    {'en': 'With a belief putting weight on a cause of joint weight zero, the bound fails under Mathlib\'s log 0 = 0: the '
           'free energy as usually defined is then infinite (Witness.bound_fails_off_support).',
     'zh': '信念置权于联合权重为零之因时，依 Mathlib 之 log 0 = 0 界不成立：其时通常定义之自由能为无穷（Witness.bound_fails_off_support）。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


assert not lint_errors({'schema_version': 2, 'id': RID, 'title': title, 'statement': statement, 'laws': laws,
                        'hypotheses': hypotheses, 'does_not_show': does_not_show,
                        'counterexamples': [{'detail': x} for x in counterexamples],
                        'validation_scope': validation, 'next_delta': next_delta,
                        'correspondence': correspondence})
if CAPS_ONLY:
    print(f'caps: ok; {len(cited)} declarations in {len(laws)} laws; statement', len(statement['en']),
          len(statement['zh']), '; correspondence', len(correspondence['en']), len(correspondence['zh']),
          '; laws max', max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws))
    raise SystemExit(0)


def core_receipt_for(module, path):
    """The latest passed core receipt holding the module's current bytes."""
    digest = sha(path)
    runs = sorted((ROOT / PKG / 'becoming-checks').glob('2*/verification.json'), reverse=True)
    for run in runs:
        data = json.loads(run.read_text())
        if data.get('status') == 'passed' and data.get('source_sha256', {}).get(module) == digest:
            return str(run.relative_to(ROOT))
    raise SystemExit(f'no passed core receipt holds {module} as it is')


core_receipt = core_receipt_for('Becoming.ConditionalWeights', CW)
record = {
    'schema_version': 2,
    'id': RID,
    'title': title,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': statement,
    'laws': laws,
    'hypotheses': hypotheses,
    'does_not_show': does_not_show,
    'counterexamples': [{'path': MODULE, 'detail': x} for x in counterexamples],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': MODULE,
    'aliases': ['Variational free energy bounds surprisal', '变分自由能为惊异之界', 'variational free energy',
                'the free-energy bound', 'Gibbs inequality', 'perception as conditioning',
                'Becoming.FreeEnergy.surprisal_le_freeEnergy', 'Becoming.FreeEnergy.minimizes_iff_givenShare'],
    'dependencies': [
        {'id': RIDC, 'relation': 'formal-reuse',
         'detail': {'en': 'Share, share, restrict, pairWeight, evidence, posterior_single, share_product and '
                          'Share.reciprocal: conditioning by restriction and a generative model\'s share given a record.',
                    'zh': 'Share、share、restrict、pairWeight、evidence、posterior_single、share_product 与 Share.reciprocal：'
                          '以限制为条件，及生成模型于记录下之份额。'}}],
    'related': [],
    'references': [{'path': MODULE, 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(MODULE)},
                   {'path': CW, 'role': 'proof', 'sha256': sha(CW)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': core_receipt, 'role': 'receipt', 'sha256': sha(core_receipt)},
                   {'path': CHECKER, 'role': 'integration', 'sha256': sha(CHECKER)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)}],
    'proof_bindings': [
        {'source': CW, 'receipt': core_receipt, 'sha256_pointer': '/source_sha256/Becoming.ConditionalWeights',
         'success_pointer': '/status', 'success_value': 'passed'},
        {'source': MODULE, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/FreeEnergyReals',
         'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'{DATE_EN}: added (UE17), variational free energy and its bound in the periphery: Gibbs\' inequality, '
              f'equality exactly at the posterior, the three decompositions, and the join, the minimizer the core\'s '
              f'share given the record; after a review and a re-check; study section {N}.',
        'zh': f'{DATE_ZH}：新增（UE17），外围之变分自由能及其界：Gibbs 不等式，恰于后验取等，三分解，及相接：其最小者即核心之记录下份额；经审查与复查；'
              f'研究第 {N} 节。'}],
}
for rid in [x['id'] for x in record['dependencies']]:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists(), path
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(groups), 'laws; core receipt', core_receipt)


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


RELATED = {
    RIDC: {'en': 'Variational free energy bounds surprisal: over the reals, in the periphery, exact minimization of free '
                 'energy over beliefs with no weight on a hypothesis the prior or the record rules out gives the share '
                 'given the record.',
           'zh': '变分自由能为惊异之界：于外围之实数上，于先验或记录所排除之假设处无权重之信念上精确最小化自由能，即得记录下之份额。'},
    RIDU: {'en': 'Variational free energy bounds surprisal: the free-energy principle\'s central quantity, its bound and '
                 'its minimizer stated in the periphery and joined to the core\'s conditioning.',
           'zh': '变分自由能为惊异之界：自由能原理之核心之量、其界与其最小者述于外围，并与核心之以限制为条件相接。'}}
# conditioning-by-restriction: the fields UE17 completes (REVIEW-UE17 F7(b)), each asserted to change once
COND = [
    ('next_delta', 'en', 'graded records on a general domain; the join to the periphery\'s variational bound once it has '
                         'a receipt; review', 'graded records on a general domain; review'),
    ('next_delta', 'zh', '一般域上之分级记录；外围变分界有回执后与之相接；人之审查', '一般域上之分级记录；人之审查'),
    ('correspondence', 'en', 'Entropy and free energy, averages of logarithms, have no such form; free energy and its bound '
                             'are drafted for the periphery with no receipt.',
     'Entropy and free energy, averages of logarithms, are not the logarithm of one reciprocal share; free energy and its '
     'bound are stated in the periphery and joined to posterior_single there (free-energy-bounds-surprisal).'),
    ('correspondence', 'zh', '熵与自由能为对数之平均，无此形式；自由能及其界拟于外围，无回执。',
     '熵与自由能为对数之平均，非一倒数份额之对数；自由能及其界述于外围，并于彼处与 posterior_single 相接（free-energy-bounds-surprisal）。'),
]
DNS2 = ('but averages of logarithms have no reciprocal-share form.',
        'but an average of logarithms is not the logarithm of one reciprocal share.',
        '而对数之平均无倒数份额之形式。', '而对数之平均非一倒数份额之对数。')
for rid, detail in RELATED.items():
    d = load(rid)
    assert RID not in [x['id'] for x in d['related']]
    d['related'].append({'id': RID, 'detail': detail})
    if rid == RIDC:
        for field, lang, old, new in COND:
            assert d[field][lang].count(old) == 1, (field, lang, old[:50])
            d[field][lang] = d[field][lang].replace(old, new)
        x = d['does_not_show'][2]
        assert x['en'].count(DNS2[0]) == 1 and x['zh'].count(DNS2[2]) == 1, 'does_not_show[2]'
        x['en'], x['zh'] = x['en'].replace(DNS2[0], DNS2[1]), x['zh'].replace(DNS2[2], DNS2[3])
        en = (f'related to {RID}; the next step drops the join to the periphery\'s bound, now done, and the '
              f'correspondence and the third item of what it does not show say that free energy, an average of '
              f'logarithms, is not the logarithm of one reciprocal share and is stated in the periphery; no statement '
              f'or declaration changed.')
        zh = (f'与 {RID} 相关联；下一步删去与外围之界相接（已成），对应与所不示之第三项改称自由能为对数之平均，非一倒数份额之对数，述于外围；'
              f'无一陈述或声明改变。')
    else:
        en = f'related to {RID}; no statement, next step or declaration changed.'
        zh = f'与 {RID} 相关联；无一陈述、下一步或声明改变。'
    d['history'].append({'en': f'{DATE_EN}, board item UE17 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 UE17（研究第 {N} 节）：{zh}'})
    save(rid, d)
print('records related here:', RIDC, RIDU)
