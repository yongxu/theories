#!/usr/bin/env python3
"""(from UM's) Write UM's record revision-comes-to-drawing-everything (a theorem) and note it in SG14's record, whose open item it
answers:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)"""
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
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. One model of drawers in turn, and one law of exact thresholds (UM)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)
MOD = 'Optimum'
SRC = f'{PKG}/Becoming/{MOD}.lean'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


m = next(m for m in core['modules'] if m['module'] == f'Becoming.{MOD}')
assert core['source_sha256'][f'Becoming.{MOD}'] == sha(SRC), 'receipt does not bind'
assert not any(m['axiom_dependencies'].values())
full = [d['name'] for d in m['declarations']]


def resolve(names):
    out = []
    for n in names:
        assert full.count('Becoming.' + n) == 1, n
        out.append('Becoming.' + n)
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']
RID = 'drawers-in-turn'
OLD_IDS = ['drawers-in-turn-draw-everything', 'revision-comes-to-drawing-everything', 'drawers-in-turn-within-capacities',
           'any-number-of-drawers-in-turn']
FROZEN = f'{PKG}/becoming-checks/20261022T040548.209667Z/Becoming.Optimum.lean'
I = 'Optimum.InTurn.'
H = 'Optimum.Holding.'
laws = [
    ('One model: at each step k drawers draw in turn, drawer d leaving of what it is given at least its floor and at most '
     'all of it; a profile revises another where each rule is a best response against it at every step from every '
     'level, and is perfect where it revises itself.',
     '一个模型：每步 k 个抽取者轮流，抽取者 d 对所给至少留其下限、至多全留；一个组合修订另一个，若每条规则在每步、从每个水平都是对它的最优回应；组合修订自身即完美。',
     [I + n for n in ['pass', 'next', 'drawn', 'later', 'levels', 'Revises', 'Perfect']]),
    ('One law: what a best response keeps above its floor returns to it at least one for one; so it leaves its floor where '
     'nothing it keeps returns, a drawer draws to capacity wherever what it draws later is fixed, and every drawer at the '
     'last step.',
     '一条律：最优回应在下限之上所留至少一对一地回到自身；故无所回之处留下限，此后所抽固定之处抽到容量，最后一步每者皆然。',
     [I + n for n in ['kept_returns', 'leaves_floor', 'at_floor', 'last_at_floor']]),
    ('With no floor and two or more drawers, every drawer after the first draws nothing later and what the first leaves goes '
     'to the second: every sequence of revisions draws everything from round 2N on, a revision always exists, and every '
     'perfect profile draws everything.',
     '无下限且两个及以上抽取者时，第一者之后的每者此后不抽，第一者所留归第二者：每个修订序列自第 2N 轮起全部抽取，修订总存在，每个完美组合全部抽取。',
     [I + n for n in ['pass_zero', 'pass_of_first', 'others_draw_nothing', 'revisions_end', 'perfect_ends',
                      'perfect_of_zero', 'bestUpTo', 'bestUpTo_le', 'bestUpTo_max', 'best_from', 'revise',
                      'revise_revises', 'revised', 'revised_leaves', 'revised_draw_all']]),
    ('Where the first drawer leaves nothing the base stands at what stands at nothing, and on a web every dependence above '
     'it, met at the start, is broken at the first step.',
     '第一者不留之处，基础立于零处所立者；在网上，起始时被满足、高于它的每个依存在第一步被打破。',
     [I + 'levels_of_first', 'Web.drained_broken']),
    ('Witnesses: under the gate, alone an optimum keeps the dweller, restraint keeps it, and every perfect profile and every '
     'revision from restraint breaks it; under doubling with a one-unit floor on the second, the first leaves everything '
     'from three and the dweller is kept.',
     '见证：门控下单独的最优与克制保持居者，每个完美组合与自克制的每次修订打破它；倍增且第二者下限为一单位时，第一者自三全留，居者得以保持。',
     [H + n for n in ['pass_keep', 'restraint_keeps', 'gated_in_turn', 'oneUnit', 'keepsFirst', 'keeping',
                      'keepsFirst_le', 'twice_sum', 'keepsFirst_best', 'only_three', 'doubling_capacity']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
EARLIER = resolve(['Optimum.Holding.gate', 'Optimum.Holding.gated_alike', 'Optimum.Holding.web', 'Optimum.Holding.onSource'])
cited = sorted(d for _, _, names in laws for d in resolve(names))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Drawers in turn', 'zh': '轮流的抽取者'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Drawers in turn are one model, each with a floor, on one law of best response: what a drawer keeps above its '
              'floor returns to it at least one for one; so with no floor and two or more drawers revision and perfection '
              'both draw everything.',
        'zh': '轮流的抽取者是一个模型，各有下限，依一条最优回应之律：抽取者在下限之上所留至少一对一地回到自身；故无下限且两个及以上抽取者时，修订与完美都全部抽取。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Any law G of what stands; k drawers in turn at each step, each leaving between its floor and what it '
               'is given; plain sums over the steps that remain; rules reading the drawer, the step and the level; for the '
               'drain and the revision no floor and k at least two, the start leaving at most what it is given; natural '
               'amounts, discrete steps.',
         'zh': '不加公理。任一所立之律 G；每步 k 个轮流的抽取者，各自留于其下限与所给之间；其后各步之和；规则读取抽取者、步与水平；抽干与修订无下限且 k 至少为二，'
               '起始组合至多留所给；自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'Drawing at once with a rule of sharing; which profiles are perfect where a floor binds away from the last step.',
         'zh': '按分享规则同时抽取；下限起作用时最后一步之外何种组合完美。', 'kind': 'scope'},
        {'en': 'Revision that is not a best response: noisy, partial or local learning.',
         'zh': '非最优回应的修订：有噪声、部分或局部的学习。', 'kind': 'scope'},
        {'en': 'That the drain is a harm or restraint better: no evaluation enters; the laws say what profiles do.',
         'zh': '抽干是伤害或克制更好：没有评价进入；这些律只说组合做什么。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration cited has an '
              f'empty axiom report; the checker verifies core purity. Built and reviewed in one session; author review in '
              f'study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：所引每项声明公理报告为空；检查器并核对核心纯净。在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {'en': 'Drawing at once with a rule of sharing; perfect profiles where a floor binds; an independent review.',
                   'zh': '按分享规则同时抽取；下限起作用时的完美组合；独立审查。'},
    'correspondence': {
        'en': 'The optimality condition of dynamic programming (Bellman 1957); the dynamic commons (Levhari and Mirman 1980); '
              'backward induction (Selten 1965); best-response dynamics (Fudenberg and Levine 1998).',
        'zh': '动态规划的最优条件（Bellman 1957）；动态公地（Levhari 与 Mirman 1980）；逆向归纳（Selten 1965）；最优回应动态（Fudenberg 与 Levine 1998）。'},
    'canonical_source': SRC,
    'aliases': ['drawers in turn', 'one model of drawers in turn', '轮流的抽取者', 'Becoming.Optimum.InTurn.kept_returns',
                'Becoming.Optimum.InTurn.revisions_end'],
    'dependencies': [],
    'related': [{'id': i_, 'detail': {'en': 'Superseded by this record, its laws now cases of the one model.',
                                      'zh': '被本记录取代，其律今为一个模型的情形。'}} for i_ in OLD_IDS],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': sorted(set(cited + EARLIER)), 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (UM), one model of drawers in turn with floors on one law of best response, '
              f'superseding {", ".join(OLD_IDS)}; study section {N}.',
        'zh': f'2026年10月22日：新增（UM），依一条最优回应之律、各有下限的轮流抽取者的一个模型，取代 {"、".join(OLD_IDS)}；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
loaded = {}
# The four drawer records: superseded, their proof source the frozen copy in SG17's receipt.
frozen_sha = sha(FROZEN)
for oid in OLD_IDS:
    d = json.loads((RECORDS / f'{oid}.json').read_text())
    d['status'] = 'superseded'
    d['superseded_by'] = RID
    for ref in d['references']:
        if ref['path'] == SRC:
            ref['path'] = FROZEN
            ref['role'] = 'provenance'
            ref['sha256'] = frozen_sha
    if d.get('canonical_source') == SRC:
        d['canonical_source'] = FROZEN
    d['proof_bindings'] = [b for b in d.get('proof_bindings', []) if b['source'] != SRC]
    d['aliases'] = [a for a in d.get('aliases', []) if not a.startswith('Becoming.')]
    d['history'].append({
        'en': f'22 October 2026, UM: superseded by {RID}, one model of drawers in turn on one law of best response, of which '
              f'these laws are cases; the Lean they cited was replaced, and is kept as provenance in the receipt copy '
              f'{FROZEN} (study section {N}). The claim is unchanged.',
        'zh': f'2026年10月22日，UM：被 {RID} 取代（依一条最优回应之律的轮流抽取者的一个模型，本记录之律为其情形）；所引 Lean 已被替换，作为来源保存在回执副本 '
              f'{FROZEN} 中（研究第 {N} 节）。主张不变。'})
    loaded[oid] = d
# The margins' thresholds: re-cited to the one law.
d = json.loads((RECORDS / 'rest-on-coupled-webs.json').read_text())
n_hit = 0
for law in d['laws']:
    law['declarations'] = ['Becoming.RegimeMargin.leading_congr' if x == 'Becoming.RegimeMargin.Coupled.leading_congr' else x
                           for x in law['declarations']]
    if 'Becoming.RegimeMargin.Coupled.Indexed.ends_iff_below' in law['declarations']:
        law['declarations'] += ['Becoming.RegimeMargin.Coupled.Indexed.ends_iff_ending', 'Becoming.RegimeMargin.leading_exact',
                                'Becoming.RegimeMargin.leading_falls']
        n_hit += 1
for ref in d['references']:
    if ref.get('declarations'):
        ref['declarations'] = sorted({'Becoming.RegimeMargin.leading_congr' if x == 'Becoming.RegimeMargin.Coupled.leading_congr'
                                      else x for x in ref['declarations']} |
                                     ({'Becoming.RegimeMargin.Coupled.Indexed.ends_iff_ending', 'Becoming.RegimeMargin.leading_exact',
                                       'Becoming.RegimeMargin.leading_falls'} if ref['role'] == 'proof' else set()))
assert n_hit == 1, n_hit
d['history'].append({
    'en': f'22 October 2026, UM: its thresholds\' exactness and falling are derived from the one law of exact thresholds '
          f'(leading_exact, leading_falls), Coupled.leading_congr moved to leading_congr (study section {N}). Its laws are unchanged.',
    'zh': f'2026年10月22日，UM：其阈值的精确与下降由一条精确阈值之律导出（leading_exact、leading_falls），Coupled.leading_congr 移为 leading_congr'
          f'（研究第 {N} 节）。其律不变。'})
loaded['rest-on-coupled-webs'] = d
d = json.loads((RECORDS / 'threshold-in-the-state-plane.json').read_text())
for law in d['laws']:
    law['declarations'] = [x for x in law['declarations'] if x != 'Becoming.RegimeMargin.Adjusted.threshold_le']
for ref in d['references']:
    if ref.get('declarations'):
        ref['declarations'] = [x for x in ref['declarations'] if x != 'Becoming.RegimeMargin.Adjusted.threshold_le']
d['laws'].append({
    'en': 'One law of exact thresholds: where a fate is down-closed in the level and read off an exact check, the least '
          'level up to a bound from which the check fails is exact, and no lower where one fate implies another; every '
          'threshold of the regime and its webs is derived from it.',
    'zh': '一条精确阈值之律：命运在水平上向下封闭且由精确检查读出时，至多到一界、检查失败的最小水平是精确的，一个命运蕴含另一个时它不更低；体制及其网的每个阈值由它导出。',
    'declarations': ['Becoming.RegimeMargin.' + n for n in ['leading_exact', 'leading_falls', 'leading_eq', 'leading_congr',
                                                             'Adjusted.rests_iff_falling']]})
for ref in d['references']:
    if ref['role'] == 'proof' and ref['path'].endswith('RegimeMargin.lean'):
        ref['declarations'] = sorted(set(ref['declarations']) | set(d['laws'][-1]['declarations']))
d['history'].append({
    'en': f'22 October 2026, UM: one law of exact thresholds added, from which this record\'s exactness and falling are now '
          f'derived; Adjusted.threshold_le removed, no law reading it (study section {N}).',
    'zh': f'2026年10月22日，UM：新增一条精确阈值之律，本记录的精确与下降今由它导出；Adjusted.threshold_le 被移除，无律读取它（研究第 {N} 节）。'})
loaded['threshold-in-the-state-plane'] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, len(cited), 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
