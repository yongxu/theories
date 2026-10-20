#!/usr/bin/env python3
"""Write EV10's record, note it in the record it continues (what-bounds-offspring-numbers), and give the coverage
file's evolution row its record:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.Reproduction (a short name must
match exactly one declaration by suffix), and the receipt must bind the module's current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. The additive part of Fisher\'s theorem (EV10)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return m


def resolve(names):
    full = [d['name'] for d in decls('Reproduction')['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.Reproduction.' + n] or [f for f in full if f.endswith('.' + n)]
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'additive-part-of-offspring-variance'
WB = 'what-bounds-offspring-numbers'
STG = 'selection-term-over-generations'
USED = {'SelectionTerm': ['Becoming.SelectionTerm.concord', 'Becoming.SelectionTerm.discord',
                          'Becoming.SelectionTerm.pairs_cross', 'Becoming.SelectionTerm.pairs_cross\'',
                          'Becoming.SelectionTerm.pairs_add', 'Becoming.SelectionTerm.discord_swap',
                          'Becoming.SelectionTerm.concord_swap', 'Becoming.SelectionTerm.Generations.mean_step',
                          'Becoming.SelectionTerm.raised_exact', 'Becoming.SelectionTerm.lowered_exact']}
laws = [
    ('Cauchy-Schwarz, counted: over any finite list the square of the total of products is at most the product of the '
     'totals of the squares.',
     '计数形式的 Cauchy-Schwarz：在任一有限列表上，乘积之和的平方至多为平方之和的乘积。',
     ['twice_le_of_le', 'twice_le', 'square_mul', 'cross_mul', 'bound_sq']),
    ('Over ordered pairs, how far apart the weights are times how far apart the amounts are totals twice the concordance '
     'with the discordance.',
     '在有序对上，权重之差距乘量之差距的总和为一致度加不一致度的两倍。',
     ['pairsOf', 'total_bind', 'total_pairsOf', 'dist', 'dist_mul', 'total_dist']),
    ('The additive part is at most the whole: the concordance with the discordance of offspring number with any carried '
     'amount, squared, is at most the squared differences of offspring numbers over pairs times those of the amount, and '
     'so is the covariance either way; all of it where the amount is offspring number itself.',
     '加性部分至多为全部：后代数与任一所载之量的一致度加不一致度的平方，至多为后代数各对差的平方之和乘该量的；协方差无论哪个方向亦然；该量即后代数本身时取等。',
     ['twice_mul', 'additive_le', 'covariance_sq_le', 'additive_self']),
    ('Over generations with exact transmission of the amount, the cross-multiplied rise or fall of its mean, squared, is '
     'at most that product.',
     '世代上该量传递精确时，其均值经交叉相乘的升或降之平方至多为该乘积。',
     ['sub_le_of_le_add', 'Generations.response_sq_le']),
    ('Witness: offspring numbers one, two, three, the middle member alone carrying an amount: concordance and discordance '
     'one each, no covariance, while offspring number and the amount both vary.',
     '见证：后代数为一、二、三，只有中间成员携带一个量：一致度与不一致度各为一，无协方差，而后代数与该量都有变化。',
     ['Unrelated.amount', 'Unrelated.unrelated']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'The additive part of the variance in offspring number', 'zh': '后代数方差的加性部分'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'The squared covariance of offspring number with any carried amount is at most the product of their '
              'variances, counted over pairs: Fisher\'s additive part through the amount is at most the whole variance, '
              'all of it where the amount is offspring number itself.',
        'zh': '在各对上计数，后代数与任一所载之量的协方差平方至多为两者方差之积：经由该量的 Fisher 加性部分至多为全部方差，该量即后代数本身时为全部。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom and no premise for the bounds: natural-number weights and amounts over a finite list. Over '
              'generations, exact transmission of the amount at the step.',
        'zh': '不加公理，界不加前提：有限列表上的自然数权重与量。世代上需该步中该量传递精确。'}],
    'does_not_show': [
        {'en': 'Several carried amounts at once (the breeding value, a multiple regression) and Fisher\'s identity itself '
               '(the predicted mean rising by the additive variance over the mean offspring number), which needs the '
               'regression coefficient, a ratio, are not stated.',
         'zh': '同时经由多个所载之量（育种值，多元回归），以及需要回归系数（一个比值）的 Fisher 恒等式本身（预测均值按加性方差除以平均后代数上升），未陈述。', 'kind': 'scope'},
        {'en': 'The equality case beyond the top: that the bound is attained exactly where offspring number is affine in '
               'the amount pair by pair (Lagrange\'s identity) is not stated.',
         'zh': '顶端之外的取等情形：恰在后代数逐对为该量的仿射函数处取等（Lagrange 恒等式），未陈述。', 'kind': 'scope'},
        {'en': 'Offspring number is a weight and a reading, not a measure of worth: that an amount is carried with more '
               'offspring says nothing about what ought to be.',
         'zh': '后代数是权重与读数，不是价值的度量：一个量随更多后代而被携带，不说明应当如何。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('Reproduction'), 'detail': {
        'en': 'Variation in offspring number need not be carried by a varying amount: in Unrelated both vary while the '
              'covariance is nothing (Unrelated.unrelated), so the additive part through that amount is nothing.',
        'zh': '后代数的变化不必由一个变化的量携带：Unrelated 中两者都变化而协方差为零（Unrelated.unrelated），故经由该量的加性部分为零。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.Reproduction has an empty axiom report; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently reviewed by '
              'a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Reproduction 的每项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Several carried amounts at once (the breeding value); the equality case; Fisher\'s identity with rational '
              'amounts; an independent review.',
        'zh': '同时经由多个所载之量（育种值）；取等情形；以有理数的量陈述的 Fisher 恒等式；独立审查。'},
    'correspondence': {
        'en': 'Fisher 1930\'s fundamental theorem in its general form, read by Price 1972: the change in mean fitness by '
              'selection is the additive genetic variance in fitness over mean fitness, the additive variance being the '
              'variance of the regression of fitness on what is carried. Through one carried amount the additive variance '
              'is Cov(w, a)^2 / Var(a), at most Var(w) by Cauchy-Schwarz, equal where fitness is affine in the amount. '
              'Readings (the AI\'s): how fast selection moves what is carried is bounded by how much offspring numbers and '
              'the amount vary.',
        'zh': 'Fisher 1930 的自然选择基本定理之一般形式，按 Price 1972 读：选择造成的平均适合度变化等于适合度的加性遗传方差除以平均适合度，加性方差即适合度对所载之物回归的方差。经由一个所载之量，加性方差为 Cov(w, a)^2 / Var(a)，由 Cauchy-Schwarz 至多为 Var(w)，在适合度为该量的仿射函数处相等。读法（AI 的）：选择移动所载之物的快慢受后代数与该量之变化程度约束。'},
    'canonical_source': src('Reproduction'),
    'aliases': ['additive part of Fisher\'s theorem', 'additive genetic variance', 'Cauchy-Schwarz counted',
                '后代数方差的加性部分', 'Becoming.Reproduction.additive_le', 'Becoming.Reproduction.bound_sq',
                'Becoming.Reproduction.Generations.response_sq_le'],
    'dependencies': [
        dep(WB, 'formal-reuse',
            'The bound lies below Becoming.Reproduction\'s variance form: discord_self makes the weights\' own spread '
            'their concordance, and additive_self is variation\'s case.',
            '界位于 Becoming.Reproduction 的方差形式之下：discord_self 使权重自身的离散度即其一致度，additive_self 即 variation 的情形。',
            'Selection on offspring number itself, the variance form.', '对后代数本身的选择，方差形式。',
            'The additive part through any carried amount.', '经由任一所载之量的加性部分。',
            'Natural-number weights over a finite list.', '有限列表上的自然数权重。', src('Reproduction')),
        dep(STG, 'formal-reuse',
            'Concordance and discordance are SelectionTerm\'s, read from either member of a pair (concord_swap, '
            'discord_swap); over generations mean_step with exact transmission gives the rise.',
            '一致度与不一致度即 SelectionTerm 的，可从对的任一成员读出（concord_swap、discord_swap）；世代上传递精确的 mean_step 给出上升。',
            'The selection term proper over pairs and generations.', '在对与世代上的真正选择项。',
            'The bound on the covariance and on the response.', '协方差与响应之界。',
            'Exact transmission for the course over generations.', '世代进程需传递精确。', src('SelectionTerm'))],
    'related': [
        {'id': WB, 'detail': {'en': 'Fisher\'s exact case, the top of this bound.', 'zh': 'Fisher 的精确情形，即本界的顶端。'}},
        {'id': STG, 'detail': {'en': 'The selection term proper, bounded here by the spreads.', 'zh': '真正的选择项，此处受离散度约束。'}}],
    'references': [{'path': src('Reproduction'), 'role': 'proof',
                    'declarations': sorted(d['name'] for d in decls('Reproduction')['declarations']),
                    'sha256': sha(src('Reproduction'))},
                  ] + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                       for mod, names in USED.items()] + [
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'} for mod in ['Reproduction'] + list(USED)],
    'history': [{
        'en': f'20 October 2026: added (EV10), the additive part of Fisher\'s theorem through one carried amount: counted '
              f'Cauchy-Schwarz, the additive variance at most the whole, the response over generations bounded; study '
              f'section {N}.',
        'zh': f'2026年10月20日：新增（EV10），经由一个所载之量的 Fisher 定理加性部分：计数形式的 Cauchy-Schwarz、加性方差至多为全部、世代响应有界；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
for mod, names in USED.items():
    have = {d['name'] for d in decls(mod)['declarations']}
    assert set(names) <= have, (mod, set(names) - have)
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

p = RECORDS / f'{WB}.json'
d = json.loads(p.read_text())
d['related'].append({'id': RID, 'detail': {'en': 'The additive part through any carried amount, of which this record\'s '
                                                 'exact case is the top.',
                                           'zh': '经由任一所载之量的加性部分，本记录的精确情形是其顶端。'}})
item = d['does_not_show'][0]
assert item['en'].startswith("Fisher's theorem in general: the additive part"), item
item['en'] = (f"Fisher's theorem in general: the additive part through one carried amount is stated in record {RID} (at "
              "most the whole variance, this record's case its top); several amounts at once and the rational reading "
              "(variance over mean) are not stated; the statement here is the case of exact transmission.")
item['zh'] = f'一般的 Fisher 定理：经由一个所载之量的加性部分陈述于记录 {RID}（至多为全部方差，本记录的情形是其顶端）；同时经由多个量与有理数读法（方差除以均值）未陈述；此处陈述的是传递精确的情形。'
nd = d['next_delta']
assert nd['en'].startswith("The additive part of Fisher's theorem (a regression read in counting form); "), nd
nd['en'] = nd['en'].replace("The additive part of Fisher's theorem (a regression read in counting form); ",
                            "The additive part through several carried amounts at once; ")
nd['zh'] = nd['zh'].replace('Fisher 定理的加性部分（以计数形式读出的回归）；', '同时经由多个所载之量的加性部分；')
d['history'].append({
    'en': f'20 October 2026, EV10: Becoming.Reproduction gains the additive part through one carried amount (record {RID}, '
          f'study section {N}); this record\'s first open item is answered there for one amount, its does-not-show item and '
          'next delta updated; its laws and their statements are unchanged.',
    'zh': f'2026年10月20日，EV10：Becoming.Reproduction 增加经由一个所载之量的加性部分（记录 {RID}，研究第 {N} 节）；本记录的第一个开放项在那里就一个量得到回答，其“未表明”项与下一步已更新；定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', WB)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index(WB) + 1, RID)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')
