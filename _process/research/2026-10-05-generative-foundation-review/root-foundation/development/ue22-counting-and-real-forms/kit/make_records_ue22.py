#!/usr/bin/env python3
"""UE22 records: free-energy-bounds-surprisal gains the join of the counting form and the real form (four laws citing
the 29 new declarations of FreeEnergyReals, each once, a hypothesis, a does-not-show item, two counterexamples, a
formal-reuse dependency on free-energy-bound-in-counts and a binding to the core receipt for Becoming.FreeEnergyCounting;
its first hypothesis counts Share.toReal's three lemmas, and its UE17 counterexample and third law say the bound "can
fail" off the support, as the witnesses show), its validation scope, references and binding moved to the new
receipt, with a history note; free-energy-bound-in-counts's first does-not-show item becomes the boundary off the
support, its next step drops the join and its second hypothesis, correspondence and related entry name the theorem,
with a history note. Asserts the receipt's hash, the standard axioms only and the declaration cover, and the style caps
and lint on every field written. Mirrors UE21's make_records_ue21.py.
usage (from the checkout root, after texts_ue22.py): python3 -B make_records_ue22.py RECEIPT_FE N
       python3 -B make_records_ue22.py --caps RECEIPT_FE  (caps, lint and cover against that receipt; writes nothing)"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = (sys.argv[2], 462) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG, FEP = f'{LEANR}/becoming', f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue22-counting-and-real-forms/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE22.md', KITD + 'RECHECK-UE22.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
MODULE = f'{FEP}/FreeEnergyReals.lean'
CHECKER = f'{FEP}/check_free_energy_reals.py'
COUNTING = f'{PKG}/Becoming/FreeEnergyCounting.lean'
CORE_RECEIPT = f'{PKG}/becoming-checks/20261029T210603.495422Z/verification.json'
RECEIPT = f'{FEP}/free-energy-reals-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDFE, RIDC = 'free-energy-bounds-surprisal', 'free-energy-bound-in-counts'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
M = 'Becoming.FreeEnergy.'
STANDARD = {'propext', 'Classical.choice', 'Quot.sound'}


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


receipt = json.loads((ROOT / RECEIPT).read_text())
assert receipt['status'] == 'passed' and receipt['bridge_module'] == 'FreeEnergyReals'
assert receipt['source_sha256']['FreeEnergyReals'] == sha(MODULE), 'the receipt binds another FreeEnergyReals'
assert receipt['source_sha256']['Becoming.FreeEnergyCounting'] == sha(COUNTING)
mod = receipt['modules'][0]
assert all(set(a) <= STANDARD for a in mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
assert len(names) == 76, len(names)
core = json.loads((ROOT / CORE_RECEIPT).read_text())
assert core['status'] == 'passed' and core['source_sha256']['Becoming.FreeEnergyCounting'] == sha(COUNTING)


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def C(*short):
    out = [M + s if not s.startswith('Becoming.') else s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


d = load(RIDFE)
old = [x for law in d['laws'] for x in law['declarations']]
assert len(old) == len(set(old)) == 47 and set(old) <= names
groups = [
    ("The counting form through the logarithm: for counts n over hypotheses listed once, total N positive, none where a "
     "natural weight is nothing, N times the free energy of n / N less the surprisal of the total weight is "
     "log (A^N·∏ n^n) − log (N^N·∏ a^n); the log ratio is N times the divergence from the posterior, the two sides "
     "differing by the exponential of N times it (gap_counts and eleven more).",
     "经对数之计数形式：列而不重之假设上计数 n，总数 N 为正，自然数权重为零处无计数，则 N 乘 n / N 之自由能减总权重之惊异等于 "
     "log (A^N·∏ n^n) − log (N^N·∏ a^n)；此对数比为 N 乘对后验之散度，两边相差 N 乘之之指数（gap_counts 等十二项）。",
     C('countBelief', 'cast_total', 'cast_powerProduct', 'total_pos_of_counts', 'powerProduct_pos', 'countBelief_nonneg',
       'sum_countBelief', 'countBelief_support', 'self_pow_ne_zero', 'gap_counts', 'divergence_counts',
       'counts_eq_mul_exp')),
    ("The two bounds are one at such a belief, each holding exactly where the other does; from the core's counting "
     "laws, not through UE17's Gibbs lemmas (a dependency audit), the bound holds, is met exactly where the counts are "
     "in proportion to the weights, which is where the belief is the posterior, and is strict elsewhere "
     "(surprisal_le_freeEnergy_iff_bound and five more).",
     "于此等信念二界为一，各恰于彼成立处成立；由核心之计数之律，不经 UE17 之 Gibbs 引理（依赖审查），界成立，恰于计数与权重成比例处取等，"
     "即信念为后验之处，余处严格（surprisal_le_freeEnergy_iff_bound 等六项）。",
     C('counting_lhs_pos', 'surprisal_le_freeEnergy_iff_bound', 'surprisal_le_freeEnergy_of_counts',
       'freeEnergy_eq_surprisal_iff_of_counts', 'surprisal_lt_freeEnergy_of_counts', 'proportional_iff_posterior')),
    ("The gap reads the joint weights up to a factor, so in a core generative model, against the joint shares and the "
     "record's share, N times the gap is the log ratio of bound_given_record's two sides; from the core's laws the "
     "bound holds, is met exactly where each count over the total is the same ratio as, and as a real number equal to, "
     "the share given the record, and is strict elsewhere (gap_div and seven more).",
     "差距读联合权重至一因子，故于核心之生成模型，对联合份额与记录之份额，N 乘差距为 bound_given_record 两边之对数比；由核心之律，界成立，"
     "恰于每一计数比总数与记录下之份额同比、作为实数相等处取等，余处严格（gap_div 等八项）。",
     C('freeEnergy_congr_weights', 'gap_div', 'gap_counts_given_record',
       'Becoming.ConditionalWeights.Share.same_iff_toReal_eq', 'freeEnergy_eq_record_surprisal_iff_of_counts',
       'freeEnergy_eq_record_surprisal_iff_toReal_of_counts', 'record_surprisal_le_freeEnergy_of_counts',
       'record_surprisal_lt_freeEnergy_of_counts')),
    ("The identity can fail off the support (counts one and one against weights nothing and one: N times the gap "
     "−2 log 2, the core's bound strict) and with a hypothesis listed twice; at one count off the support it holds, "
     "and against weights totalling one the real form is at equality while the core's bound is strict "
     "(Witness.gap_counts_off_support and two more).",
     "离支撑恒等式或不成立（计数一与一对权重零与一：N 乘差距为 −2 log 2，核心之界严格），假设列二次亦然；离支撑一计数时恒等式成立，权重总和为一时"
     "实数形式取等而核心之界严格（Witness.gap_counts_off_support 等三项）。",
     C('Witness.gap_counts_off_support', 'Witness.one_count_off_support', 'Witness.gap_counts_duplicate')),
]
new = [x for _, _, ds in groups for x in ds]
assert len(new) == len(set(new)) == 29 and not set(new) & set(old), new
assert set(old) | set(new) == names, sorted(names - set(old) - set(new))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]
hypothesis = capped('hypotheses', {
    'en': "For the counting form: natural counts over hypotheses listed once, with a positive total and no count where "
          "the natural joint weight is nothing, the belief read as n / N; in the generative model, no count where a "
          "hypothesis's prior weight times the record's weight under it is nothing.",
    'zh': '计数形式需：列而不重之假设上之自然数计数，总数为正，自然数联合权重为零处无计数，信念读作 n / N；于生成模型，假设之先验权重乘记录于其下之权重为零处无计数。'},
    item=True)
dns3 = capped('does_not_show', {
    'en': "Complexity and accuracy read from the core's own prior and likelihood shares.",
    'zh': '由核心自身之先验与似然份额读出之复杂度与准确度。'}, item=True)
dns_new = capped('does_not_show', {
    'en': "Read from the core: beliefs whose shares are not ratios of counts (their bound rests on log x ≤ x − 1, "
          "term_le), joint weights with irrational ratios, a listing with a hypothesis repeated, or a record of weight "
          "nothing (excluded).",
    'zh': '由核心读出者：份额非计数之比之信念（其界依 log x ≤ x − 1，term_le）、比为无理数之联合权重、某假设重复之列表，或前提所排除之无权重记录。',
    'kind': 'scope'}, item=True)
counterexamples_new = [
    {'path': MODULE, 'detail': {
        'en': "Off the support the counting identity can fail: counts one and one against weights nothing and one give N "
              "times the gap −2 log 2 under log 0 = 0, against a log ratio of 0, the counting bound's sides being nothing "
              "and one (Witness.gap_counts_off_support); at one count it holds, and against weights totalling one the "
              "real form is at equality (Witness.one_count_off_support).",
        'zh': '离支撑计数之恒等式或不成立：计数一与一对权重零与一，依 log 0 = 0，N 乘差距为 −2 log 2，而对数比为 0，计数之界两边为零与一'
              '（Witness.gap_counts_off_support）；一计数时成立，权重总和为一时实数形式取等（Witness.one_count_off_support）。'}},
    {'path': MODULE, 'detail': {
        'en': "With true listed twice and every count and weight one, N times the gap is −log 2 while the log ratio is 0: "
              "the real side sums over the set of hypotheses, the core's over the listing (Witness.gap_counts_duplicate).",
        'zh': 'true 列二次且计数与权重皆一时，N 乘差距为 −log 2 而对数比为 0：实数一侧于假设之集合上求和，核心一侧于列表上求和'
              '（Witness.gap_counts_duplicate）。'}}]
validation = capped('validation_scope', {
    'en': f"Machine-checked by the periphery checker check_free_energy_reals.py with Lean 4.30.0-rc2 and the pinned "
          f"Mathlib (receipt {RECEIPT_ID}): all 76 declarations of FreeEnergyReals, each on Lean's standard axioms only, "
          f"every core module of its closure matching a passed core receipt. Independent reviews by other AI agents "
          f"(REVIEW-UE17; REVIEW-UE22 and RECHECK-UE22 for the counting form), study sections 450 and {N}; not reviewed "
          f"by a person.",
    'zh': f'外围检查器 check_free_energy_reals.py 以 Lean 4.30.0-rc2 与固定之 Mathlib 实查（回执 {RECEIPT_ID}）：FreeEnergyReals 之全部 76 项'
          f'声明，皆只依 Lean 之标准公理，其闭包之每一核心模块皆合于已通过之核心回执。另有 AI 代理作独立审查（REVIEW-UE17；计数形式见 '
          f'REVIEW-UE22 与 RECHECK-UE22），见研究第 450 与 {N} 节；未经人审。'})
related_c = {'en': "The free-energy bound in counts: the bound and its equality for count beliefs in the pure core, with "
                   "no axiom and no support condition; on the support, over hypotheses listed once, this bound is it "
                   "through the logarithm (gap_counts).",
             'zh': '计数之自由能界：纯核心中计数信念之界及其取等，无公理，无支撑条件；于支撑上且假设列而不重时，此界即彼界取对数（gap_counts）。'}

# the counting record's fields, before anything is written
c = load(RIDC)
assert c['does_not_show'][0]['en'].startswith("A theorem joining it to FreeEnergyReals' bound for count beliefs")
c_dns0 = capped('does_not_show', {
    'en': "One law off the support: the identity joining the two can fail there (FreeEnergy.Witness.gap_counts_off_support), "
          "and at one count, where it holds, the real form can be at equality while this bound is strict.",
    'zh': '离支撑为一律：相接二者之恒等式于彼或不成立（FreeEnergy.Witness.gap_counts_off_support），一计数时虽成立，实数形式可取等而此界严格。',
    'kind': 'scope'}, item=True)
OLD_NEXT = {'en': "The periphery theorem joining it to FreeEnergyReals' bound for count beliefs with a positive total on "
                  "the support; complexity",
            'zh': '外围之定理：于总数为正且在支撑上之计数信念，与 FreeEnergyReals 之界相接；由核心'}
NEW_NEXT = {'en': 'Complexity', 'zh': '由核心'}
OLD_HYP = {'en': "Read as the free-energy bound for the belief n / N with a positive total, as UE17's real form on the "
                 "support;",
           'zh': '于总数为正时读作信念 n / N 之自由能界，于支撑上与 UE17 之实数形式相合；'}
NEW_HYP = {'en': "Read as the free-energy bound for the belief n / N with a positive total, on the support and with the "
                 "hypotheses listed once UE17's real form through the logarithm (FreeEnergy.gap_counts);",
           'zh': '于总数为正时读作信念 n / N 之自由能界，于支撑上且假设列而不重时即 UE17 之实数形式取对数（FreeEnergy.gap_counts）；'}
OLD_COR = {'en': "equivalently Gibbs' inequality (Gibbs 1902) and the nonnegativity of the divergence (Kullback and "
                 "Leibler 1951) for rational distributions,",
           'zh': '等价于有理分布之 Gibbs 不等式（Gibbs 1902）与散度之非负（Kullback、Leibler 1951），'}
NEW_COR = {'en': "equivalently, through the logarithm (FreeEnergy.gap_counts), Gibbs' inequality (Gibbs 1902) and the "
                 "nonnegativity of the divergence (Kullback and Leibler 1951) for rational distributions,",
           'zh': '经对数（FreeEnergy.gap_counts）等价于有理分布之 Gibbs 不等式（Gibbs 1902）与散度之非负（Kullback、Leibler 1951），'}
for lang in ('en', 'zh'):
    assert c['next_delta'][lang].count(OLD_NEXT[lang]) == 1, ('next', lang)
    assert c['hypotheses'][1][lang].count(OLD_HYP[lang]) == 1, ('hyp', lang)
    assert c['correspondence'][lang].count(OLD_COR[lang]) == 1, ('cor', lang)
c_next = capped('next_delta', {k: c['next_delta'][k].replace(OLD_NEXT[k], NEW_NEXT[k]) for k in ('en', 'zh')})
c_hyp = capped('hypotheses', {k: c['hypotheses'][1][k].replace(OLD_HYP[k], NEW_HYP[k]) for k in ('en', 'zh')}, item=True)
c_cor = capped('correspondence', {k: c['correspondence'][k].replace(OLD_COR[k], NEW_COR[k]) for k in ('en', 'zh')})
related_fe = {'en': "Variational free energy bounds surprisal: its bound over the reals, for count beliefs with a "
                    "positive total on the support, over hypotheses listed once, this one through the logarithm, proved there "
                    "(gap_counts).",
              'zh': '变分自由能为惊异之界：其实数上之界，于总数为正、在支撑上且假设列而不重之计数信念，即此界取对数，证于彼处（gap_counts）。'}


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


UE17_FIXES = [
    (d['laws'][2], 'en', 'off that support the bound fails under the convention log 0 = 0',
     'off that support the bound can fail under the convention log 0 = 0'),
    (d['laws'][2], 'zh', '出此支撑，依 log 0 = 0 之约定界不成立', '出此支撑，依 log 0 = 0 之约定界或不成立'),
    (d['hypotheses'][0], 'en', 'Share.toReal and its two lemmas among them', 'Share.toReal and its three lemmas among them'),
    (d['hypotheses'][0], 'zh', 'Share.toReal 及其二引理亦然', 'Share.toReal 及其三引理亦然'),
    (d['counterexamples'][0]['detail'], 'en', 'the bound fails under Mathlib', 'the bound can fail under Mathlib'),
    (d['counterexamples'][0]['detail'], 'zh', '依 Mathlib 之 log 0 = 0 界不成立', '依 Mathlib 之 log 0 = 0 界或不成立'),
]
for obj, lang, a, b in UE17_FIXES:
    assert obj[lang].count(a) == 1, (lang, a)
    obj[lang] = obj[lang].replace(a, b)
capped('laws', d['laws'][2], item=True)
capped('hypotheses', d['hypotheses'][0], item=True)
fe_counter = d['counterexamples'] + counterexamples_new
fe_hyp = d['hypotheses'] + [hypothesis]
fe_dns = d['does_not_show'][:3] + [dict(dns3, kind=d['does_not_show'][3]['kind'])] + d['does_not_show'][4:] + [dns_new]
assert len(fe_hyp) <= style.ITEM_CAPS_V2['hypotheses'][2] and len(fe_dns) <= style.ITEM_CAPS_V2['does_not_show'][2]
assert len(d['laws']) + len(laws) <= style.ITEM_CAPS_V2['laws'][2]
assert d['does_not_show'][3]['en'].startswith("Complexity and accuracy read from the core's own prior and likelihood")
assert not lint_errors({'schema_version': 2, 'id': RIDFE, 'title': d['title'], 'statement': d['statement'],
                        'laws': d['laws'] + laws, 'hypotheses': fe_hyp, 'does_not_show': fe_dns,
                        'counterexamples': fe_counter, 'validation_scope': validation,
                        'next_delta': d['next_delta'], 'correspondence': d['correspondence']})
assert not lint_errors({'schema_version': 2, 'id': RIDC, 'title': c['title'], 'statement': c['statement'],
                        'laws': c['laws'], 'hypotheses': c['hypotheses'][:1] + [c_hyp] + c['hypotheses'][2:],
                        'does_not_show': [c_dns0] + c['does_not_show'][1:], 'counterexamples': c['counterexamples'],
                        'validation_scope': c['validation_scope'], 'next_delta': c_next, 'correspondence': c_cor})
if CAPS_ONLY:
    print(f'caps: ok; 29 new declarations in {len(laws)} laws over 76; laws max',
          max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws), '; validation', len(validation['en']),
          len(validation['zh']), '; correspondence (counts)', len(c_cor['en']), len(c_cor['zh']))
    raise SystemExit(0)

# free-energy-bounds-surprisal
d['laws'] += laws
d['hypotheses'] = fe_hyp
d['does_not_show'] = fe_dns
d['counterexamples'] = fe_counter
d['validation_scope'] = validation
d['reviewed_at_utc'] = NOW
for b in d['proof_bindings']:
    if b['source'] == MODULE:
        b['receipt'] = RECEIPT
assert not [b for b in d['proof_bindings'] if b['source'] == COUNTING]
d['proof_bindings'].append({'source': COUNTING, 'receipt': CORE_RECEIPT,
                            'sha256_pointer': '/source_sha256/Becoming.FreeEnergyCounting',
                            'success_pointer': '/status', 'success_value': 'passed'})
refs = d['references']
old_receipts = [r for r in refs if r['role'] == 'receipt' and '/free-energy-reals-checks/' in r['path']]
assert len(old_receipts) == 1
refs.remove(old_receipts[0])
for r in refs:
    if r['path'] == MODULE:
        r['declarations'] = sorted(names)
for path, role in [(COUNTING, 'proof'), (RECEIPT, 'receipt'), (CORE_RECEIPT, 'receipt'), (NOTE, 'integration'),
                   (REVIEW, 'integration'), (RECHECK, 'integration')]:
    assert not [r for r in refs if r['path'] == path], path
    refs.append({'path': path, 'role': role, 'sha256': sha(path)})
for r in refs:
    r['sha256'] = sha(r['path'])
d['aliases'].append(M + 'gap_counts')
assert RIDC not in [x['id'] for x in d['dependencies']]
d['dependencies'].append({'id': RIDC, 'relation': 'formal-reuse', 'detail': {
    'en': "powerProduct, self_pow_pos, powerProduct_self_pos, bound, bound_eq_iff, bound_lt_of_not_proportional, joint, "
          "record_total, bound_given_record, given_record_eq_iff_share and the witnesses' counts: the bound in counts, "
          "read through the logarithm.",
    'zh': 'powerProduct、self_pow_pos、powerProduct_self_pos、bound、bound_eq_iff、bound_lt_of_not_proportional、joint、record_total、'
          'bound_given_record、given_record_eq_iff_share 与见证之计数：取对数而读之计数之界。'}})
for x in d['related']:
    if x['id'] == RIDC:
        x['detail'] = related_c
d['history'].append({
    'en': f'{DATE_EN}, board item UE22 (study section {N}): the counting form joined to the real form, four laws citing '
          f'the 29 new declarations of FreeEnergyReals (gap_counts, the two bounds as one, the bound, equality and '
          f'strictness from the core\'s counting laws, the divergence and exponential forms, the generative model with the '
          f'whole weight dropping out, three witnesses), a hypothesis, a does-not-show item, two counterexamples, a '
          f'formal-reuse dependency and a binding to the core receipt for Becoming.FreeEnergyCounting; the fourth '
          f'does-not-show item no longer names the counting form\'s record; the third law, the first hypothesis and the '
          f'first counterexample brought to the witnesses (the bound can fail off the support) and to Share.toReal\'s three '
          f'lemmas; '
          f'receipt {RECEIPT_ID}; after a review and a re-check. No earlier statement or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE22（研究第 {N} 节）：计数形式与实数形式相接，四律引 FreeEnergyReals 之 29 项新声明（gap_counts、二界为一、'
          f'由核心计数之律所得之界、取等与严格、散度与指数之形式、整体权重消去之生成模型、三见证），一前提、一所不示、二反例、一形式复用之依赖，并绑定 '
          f'Becoming.FreeEnergyCounting 之核心回执；所不示之第四项不再指明计数形式之记录；第三律、第一前提与第一反例依见证（离支撑界或不成立）与 '
          f'Share.toReal 之三引理修订；回执 {RECEIPT_ID}；经审查与复查。先前之陈述与声明'
          f'皆未改变。'})
save(RIDFE, d)

# free-energy-bound-in-counts
c['does_not_show'][0] = c_dns0
c['next_delta'] = c_next
c['hypotheses'][1] = c_hyp
c['correspondence'] = c_cor
for x in c['related']:
    if x['id'] == RIDFE:
        x['detail'] = related_fe
assert not [r for r in c['references'] if r['path'] == NOTE]
c['references'].append({'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)})
for r in c['references']:
    if r['path'] in (CH3, STUDY):
        r['sha256'] = sha(r['path'])
c['history'].append({
    'en': f'{DATE_EN}, board item UE22 (study section {N}): the theorem joining this bound to FreeEnergyReals\' is proved '
          f'there (gap_counts, in free-energy-bounds-surprisal); the first does-not-show item becomes the boundary off '
          f'the support, the next step drops the join, and the second hypothesis, the correspondence and the related '
          f'entry name the theorem. No statement, law or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE22（研究第 {N} 节）：此界与 FreeEnergyReals 之界相接之定理证于彼处（gap_counts，见 '
          f'free-energy-bounds-surprisal）；所不示之第一项改为离支撑之界限，下一步删去相接，第二前提、对应与关联条目指明此定理。无一陈述、律或'
          f'声明改变。'})
save(RIDC, c)
print('records:', RIDFE, '(4 laws, 29 declarations over 76)', RIDC, '(boundary, next step, hypothesis, correspondence)')
