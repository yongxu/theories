#!/usr/bin/env python3
"""Write RM8's record rest-on-coupled-webs (a theorem), note it in RM7's record (whose open item it answers) and re-point
RM6's record coupled-regimes from the pair-only helpers removed to the web laws:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.RegimeMargin gained since the previous receipt; every cited declaration
is resolved against the receipt's audited declarations, and the receipt must bind the module's current bytes. Every edit
is checked before anything is written."""
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
HEAD = f"## {N}. Rest and points of no return on coupled webs (RM8)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)
MOD = 'RegimeMargin'
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
RID = 'rest-on-coupled-webs'
RM7 = 'coupled-webs'
RM6 = 'coupled-regimes'
W = 'RegimeMargin.Coupled.Indexed.'
PAIR = 'RegimeMargin.Coupled.'
laws = [
    ('Under mutual support a giving respects what is left condition by condition, by antisymmetry, so states the draws '
     'leave alike at every condition step alike, their runs stay alike, a condition ends from one exactly where from the '
     'other, and the run from the state after a step is the run one step on: no equality of functions is assumed.',
     '相互支持下，所给按反对称逐条件地尊重所余，故汲取所余在每个条件上相同的状态步也相同，其运行保持相同，一个条件从一个状态终结恰当它从另一个终结；'
     '自一步之后的状态出发的运行即运行之后一步：不假设函数相等。',
     [W + n for n in ['respects', 'step_alike', 'run_alike', 'ends_alike', 'run_shift']]),
    ('Within a band the step keeps, each condition gives within its draw at every state in the band, a run stays in the '
     'band, what the draws leave of each never rises along it, and the run is still condition by condition once that '
     'repeats.',
     '在步保持的带内，每个条件在带内每个状态的所给不超过其汲取，运行留在带内，汲取所余沿运行从不上升，重复时运行逐条件静止。',
     [W + n for n in ['Band', 'within_draw', 'run_within', 'left_falls', 'still_of_left']]),
    ('For finitely many conditions listed by a covering list, what is left of them, added, falls strictly at every step '
     'that changes it and is at most the count times hi; so a run from the band is still from some step at most the count '
     'times hi with one, and whether a condition ends is decided at that step.',
     '对由覆盖列表列出的有限多个条件，其所余之和在每个改变它的步严格下降，且至多为条件数乘 hi；故自带内出发的运行至多自条件数乘 hi 再加一步起静止，'
     '一个条件是否终结在该步判定。',
     [W + n for n in ['leftOver', 'leftOver_le', 'leftOver_lt', 'leftOver_bound', 'alikeOn', 'alikeOn_true',
                      'alikeOn_false', 'rests_by', 'comes_to_rest', 'ends_iff']]),
    ("Each condition's point of no return, the others' levels given, is a least level up to hi + 1 below which exactly it "
     'ends; every state has its fate by it; and it does not rise as any other level rises.',
     '每个条件在其他水平给定时的不可回返点，是至多 hi + 1 的最小水平，恰在其下它终结；每个状态按它得其命运；它不随任何其他水平上升而上升。',
     [W + n for n in ['setAt', 'setAt_below', 'setAt_within', 'ending', 'threshold', 'ends_iff_below',
                      'threshold_falls', 'fates']]),
    ("The pair's rest and points of no return are these laws read for two: the pair's band is the web's, the pair is still "
     'where its web is, and its threshold is the web\'s with the partner at its level.',
     '一对的静止与不可回返点是这些律对两个条件的读法：一对的带是网的带，网静止处一对静止，其阈值是伙伴处于其水平时网的阈值。',
     [PAIR + n for n in ['covers_pair', 'pair_count', 'band_web', 'pair_within', 'pair_still', 'pair_at', 'leading_congr',
                      'setAt_pair', 'threshold_pair']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
GONE = {f'Becoming.RegimeMargin.Coupled.{n}' for n in ['within_draw', 'run_within', 'left_falls', 'still_of_left',
                                                      'step_of_left']}
assert old_names - set(full) == GONE, (old_names - set(full)) ^ GONE
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve([W + 'step', W + 'step_mono', W + 'ends_of_below', W + 'Ends', W + 'Rises', W + 'Below',
                   PAIR + 'given_within', PAIR + 'left_le', PAIR + 'pair_run', PAIR + 'ends_pair', PAIR + 'pair_rises',
                   PAIR + 'rests_by', PAIR + 'comes_to_rest', PAIR + 'ends_iff', PAIR + 'ending', PAIR + 'threshold',
                   PAIR + 'ends_iff_below', PAIR + 'threshold_falls', PAIR + 'fates', PAIR + 'Band', 'RegimeMargin.leading',
                   'RegimeMargin.leading_true', 'RegimeMargin.leading_false'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Rest and points of no return on coupled webs', 'zh': '耦合之网的静止与不可回返点'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': "For finitely many coupled conditions within a band under mutual support, a run comes to rest, and each "
              "condition's point of no return, given the others, is exact and does not rise as any other level rises.",
        'zh': '对带内相互支持下有限多个耦合条件，运行静止，每个条件在其他给定时的不可回返点是精确的，且不随任何其他水平上升而上升。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Whole numbers; finitely many conditions listed by a list covering them; draws taken first, as '
               'much as there is; each giving a law of what is left of all, rising with each (mutual support); a band up '
               'to hi the step keeps; states compared condition by condition; discrete steps.',
         'zh': '不加公理。整数；由覆盖列表列出的有限多个条件；汲取先取，有多少取多少；各所给是所有所余之律，且随每个上升（相互支持）；步保持至多 hi 的带；'
               '状态逐条件比较；离散步。'}],
    'does_not_show': [
        {'en': 'Infinitely many conditions: the decision whether a step changes what is left runs over the covering list.',
         'zh': '无穷多个条件：判定一步是否改变所余要遍历覆盖列表。', 'kind': 'scope'},
        {'en': 'Thresholds beyond a band; webs with a recent giving; amounts beyond whole numbers.',
         'zh': '带外的阈值；带近来所给的网；整数之外的量。', 'kind': 'scope'},
        {'en': 'That measured webs meet mutual support and a band: how far a field web\'s thresholds fall is untested.',
         'zh': '所测的网满足相互支持与带：野外之网的阈值下降多远未经检验。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core purity. Built and reviewed '
              f'in one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.RegimeMargin 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Thresholds beyond a band, with a bound on the run in its place; webs with a recent giving; a field web whose '
              'couplings are measured; an independent review.',
        'zh': '带外的阈值，以运行之界代替带；带近来所给的网；耦合经测量的野外之网；独立审查。'},
    'correspondence': {
        'en': 'A monotone map on a finite ordered set iterated from a state it does not raise reaches a fixed point within '
              "the set's height (Kleene; Tarski 1955); monotone systems keep the order of solutions, the comparison "
              'principle (Hirsch 1985; Smith 1995).',
        'zh': '有限有序集上的单调映射自其不升高的状态迭代，在集合高度之内达到不动点（Kleene；Tarski 1955）；单调系统保持解之序，即比较原理（Hirsch 1985；Smith 1995）。'},
    'canonical_source': SRC,
    'aliases': ['rest and points of no return on coupled webs', 'coupled webs come to rest', '耦合之网的静止',
                'Becoming.RegimeMargin.Coupled.Indexed.comes_to_rest', 'Becoming.RegimeMargin.Coupled.Indexed.threshold_falls'],
    'dependencies': [
        {'id': RM7, 'relation': 'formal-reuse',
         'detail': {'en': "The web's step, its order and its ending are reused; the rest and thresholds its open item names "
                          'are stated.',
                    'zh': '沿用网之步、其序与其终结；陈述了其开放项所列的静止与阈值。'},
         'interface': {
             'output': {'en': 'step, step_mono, ends_of_below, pair_run, ends_pair.', 'zh': 'step、step_mono、ends_of_below、pair_run、ends_pair。'},
             'input': {'en': 'Rest and points of no return on webs.', 'zh': '网上的静止与不可回返点。'},
             'conditions': {'en': 'Finitely many conditions; a band.', 'zh': '有限多个条件；带。'},
             'evidence': SRC}},
        {'id': RM6, 'relation': 'formal-reuse',
         'detail': {'en': "The pair's rest and thresholds are derived from the web's; its pair-only helpers are removed.",
                    'zh': '一对的静止与阈值由网的导出；其只对一对的辅助引理被移除。'},
         'interface': {
             'output': {'en': 'Band, given_within, left_le, rests_by, threshold.', 'zh': 'Band、given_within、left_le、rests_by、threshold。'},
             'input': {'en': 'The pair read as the web indexed by Bool.', 'zh': '一对读作以 Bool 为指标的网。'},
             'conditions': {'en': 'Mutual support; a band.', 'zh': '相互支持；带。'},
             'evidence': SRC}}],
    'related': [],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (RM8), rest and points of no return on coupled webs of finitely many conditions, '
              f'stated condition by condition; the pair\'s laws derived from them; study section {N}.',
        'zh': f'2026年10月22日：新增（RM8），有限多个条件的耦合之网的静止与不可回返点，逐条件陈述；一对的律由其导出；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
REMAP = {f'Becoming.RegimeMargin.Coupled.{n}': f'Becoming.RegimeMargin.Coupled.Indexed.{n}'
         for n in ['within_draw', 'run_within', 'left_falls', 'still_of_left']}
REMAP['Becoming.RegimeMargin.Coupled.step_of_left'] = 'Becoming.RegimeMargin.Coupled.Indexed.step_alike'
for target in REMAP.values():
    assert target in full, target
loaded = {}
d = json.loads((RECORDS / f'{RM7}.json').read_text())
dns = [x for x in d['does_not_show'] if x['en'].startswith('Rest and thresholds of webs:')]
assert len(dns) == 1
dns[0]['en'] = ('Rest and thresholds of webs of infinitely many conditions: for finitely many, listed, they are stated '
                '(record ' + RID + ').')
dns[0]['zh'] = '无穷多个条件之网的静止与阈值：有限多个（列出）的已陈述（记录 ' + RID + '）。'
for lang, old_ in (('en', 'Rest and thresholds of webs (stated on finitely many conditions read as a list); '),
                   ('zh', '网的静止与阈值（以列表读出的有限多个条件上陈述）；')):
    assert d['next_delta'][lang].count(old_) == 1, (RM7, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': "For finitely many conditions within a band, a web's run comes to rest and each condition's point of no return "
          'does not rise as any other level rises.',
    'zh': '对带内有限多个条件，网的运行静止，每个条件的不可回返点不随任何其他水平上升而上升。'}}]
d['history'].append({
    'en': f'22 October 2026, RM8: the rest and thresholds of webs are stated for finitely many conditions (record {RID}, '
          f'study section {N}); its open item says so. Its laws are unchanged.',
    'zh': f'2026年10月22日，RM8：有限多个条件之网的静止与阈值已陈述（记录 {RID}，研究第 {N} 节）；其开放项如此说明。其规律不变。'})
loaded[RM7] = d
d = json.loads((RECORDS / f'{RM6}.json').read_text())
law0 = d['laws'][0]
for lang, old_, new_ in (('en', 'the step reads a state only through what the draws leave.',
                          'under mutual support, states the draws leave alike step alike.'),
                         ('zh', '步只经由汲取所余读取状态。', '相互支持下，汲取所余相同的状态步也相同。')):
    assert law0[lang].count(old_) == 1, (RM6, lang)
    law0[lang] = law0[lang].replace(old_, new_)
hits = 0
for law in d['laws']:
    for k, name in enumerate(law['declarations']):
        if name in REMAP:
            law['declarations'][k] = REMAP[name]
            hits += 1
assert hits == 5, hits
ref = d['references'][0]
assert all(n in ref['declarations'] for n in REMAP)
ref['declarations'] = sorted({REMAP.get(n, n) for n in ref['declarations']})
for lang, old_ in (('en', 'rest and thresholds of webs; '), ('zh', '网的静止与阈值；')):
    assert d['next_delta'][lang].count(old_) == 1, (RM6, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': "The pair's rest and points of no return are the web's laws read for two.",
    'zh': '一对的静止与不可回返点是网之律对两个条件的读法。'}}]
d['history'].append({
    'en': f'22 October 2026, RM8: the pair\'s rest and thresholds derived from the web\'s (record {RID}, study section '
          f'{N}); within_draw, run_within, left_falls and still_of_left now cited in their web form, step_of_left as '
          f'Coupled.Indexed.step_alike under mutual support; the statements of its laws are unchanged.',
    'zh': f'2026年10月22日，RM8：一对的静止与阈值由网的导出（记录 {RID}，研究第 {N} 节）；within_draw、run_within、left_falls 与 still_of_left '
          f'今以其网的形式引用，step_of_left 以相互支持下的 Coupled.Indexed.step_alike 引用；其律的陈述不变。'})
loaded[RM6] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
