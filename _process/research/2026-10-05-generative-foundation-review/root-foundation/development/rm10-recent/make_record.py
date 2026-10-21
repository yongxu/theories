#!/usr/bin/env python3
"""Write RM10's record webs-with-a-recent-giving (a theorem) and note it in the records thresholds-beyond-a-band and
rest-on-coupled-webs, whose open items it answers:
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
HEAD = f"## {N}. Webs with a recent giving (RM10)"
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
RID = 'webs-with-a-recent-giving'
RM9 = 'thresholds-beyond-a-band'
RM8 = 'rest-on-coupled-webs'
W = 'RegimeMargin.Coupled.Indexed.'
R = W + 'Recent.'
M = R + 'Momentum.'
laws = [
    ('A law of states reads them condition by condition where states alike at every condition go to states alike; runs '
     'of such a law stay alike, and the web\'s step is one; the web\'s run_alike is now this law\'s case.',
     '状态在每个条件上相同则去往相同的状态时，状态之律逐条件读取它们；此律的运行保持相同，网之步即是一个；网的 run_alike 今为其情形。',
     [W + n for n in ['ReadsPointwise', 'run_alike_of', 'pointwise_step']]),
    ('Ending under a law; a law keeping the order of states reads them condition by condition, by antisymmetry; the '
     'web\'s step keeps it under mutual support; runs keep the order, ending is down-closed, and a run reaching a state '
     'its law leaves as it is stays there.',
     '律下的终结；保持状态之序的律以反对称逐条件读取它们；相互支持下网之步保持之；运行保持序，终结向下封闭，到达律所不动之状态的运行停在那里。',
     [W + n for n in ['EndsUnder', 'KeepsBelow', 'step_keepsBelow', 'reads_of_keepsBelow', 'run_below_of',
                      'endsUnder_of_below', 'stays_at']]),
    ('A web with a recent giving holds each condition\'s level and what it gave last, its giving a law of what is left '
     'of all and what each gave; under mutual support it keeps the order of states, so RM9\'s bounded laws hold of it.',
     '带近来所给的网持有每个条件的水平与其上次所给，其所给是所有所余与各自所给之律；相互支持下它保持状态之序，故 RM9 的有界之律对它成立。',
     [R + n for n in ['step', 'Rises', 'keepsBelow', 'both', 'mem_both', 'covers_both']]),
    ('Where giving reads nothing of what was given, its levels run as the plain web\'s; one condition is the adjusted '
     'regime, level and recent giving at every step.',
     '所给不读取已给者时，其水平如普通之网运行；一个条件即调整的体制，每步的水平与近来所给皆同。',
     [R + n for n in ['plain', 'ofAdjusted', 'adjusted']]),
    ('Witness: one condition under a draw of two gives one where something is left and nothing was given last, two '
     'where something was; its threshold, levels up to four, is four having given nothing and three having given one.',
     '见证：汲取为二的一个条件，有所余而上次未给时给一，上次有给时给二；其阈值（水平至多四）在未给时为四，给一时为三。',
     [M + n for n in ['gives', 'giving', 'gives_rises', 'rises', 'at_', 'ramp', 'set_at', 'ends_from', 'holds_from',
                      'threshold_falls_with_recent']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert not (old_names - set(full)), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve([W + 'StaysWithin', W + 'within_below', W + 'returns_within', W + 'repeats', W + 'ends_iff_within',
                   W + 'endingWithin', W + 'thresholdWithin', W + 'ending_iff', W + 'ends_iff_below_within',
                   W + 'threshold_falls_within', W + 'run_alike', W + 'step_alike', W + 'Pointwise', W + 'setAt',
                   W + 'setAt_below', W + 'step', W + 'Below', 'RegimeMargin.Adjusted.step',
                   'RegimeMargin.Coupled.Relay.threshold_beyond_band'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Webs with a recent giving', 'zh': '带近来所给的网'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': "A web whose giving reads what each condition gave last keeps the order of states under mutual support, so its "
              "bounded runs have ending decided and each threshold exact and at most what it was as any level or recent "
              "giving rises; what was given can lower a threshold.",
        'zh': '所给读取各条件上次所给的网，在相互支持下保持状态之序，故其有界运行的终结可判定，每个阈值精确，且在任何水平或近来所给上升时至多为原值；所给可降低阈值。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Whole numbers; finitely many conditions listed by a list covering them; draws taken first, as '
               'much as there is; each giving a law of what is left of all and what each gave last, read condition by '
               'condition (for the decision) and rising with each (mutual support, for the threshold); the run from the top '
               'level considered within a bound B; discrete steps.',
         'zh': '不加公理。整数；由覆盖列表列出的有限多个条件；汲取先取，有多少取多少；各所给是所有所余与各自上次所给之律，逐条件读取（用于判定），且随每个上升'
               '（相互支持，用于阈值）；自所考虑顶水平的运行在界 B 之内；离散步。'}],
    'does_not_show': [
        {'en': 'Rest within a band for webs with a recent giving: RM3\'s measure for one condition is not lifted to webs.',
         'zh': '带近来所给之网在带内的静止：RM3 对一个条件的度量未提升到网。', 'kind': 'scope'},
        {'en': 'Giving reading more than the last step; runs without bound; amounts beyond whole numbers.',
         'zh': '读取多于上一步的所给；无界的运行；整数之外的量。', 'kind': 'scope'},
        {'en': 'That measured conditions give by what they gave last, or by how much.',
         'zh': '所测的条件按其上次所给而给，或给多少。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core purity. Built and reviewed '
              f'in one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.RegimeMargin 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Rest within a band for webs with a recent giving; a field web whose couplings are measured; an independent review.',
        'zh': '带近来所给之网在带内的静止；耦合经测量的野外之网；独立审查。'},
    'correspondence': {
        'en': 'State augmentation gives a system memory and keeps it monotone where output rises with state and past (Smith '
              '1995, on monotone systems with delay); history-dependent response is hysteresis (Mayergoyz 2003).',
        'zh': '状态扩充赋予系统记忆，输出随状态与过去上升时保持单调（Smith 1995，关于有延迟的单调系统）；依赖历史的响应即滞后（Mayergoyz 2003）。'},
    'canonical_source': SRC,
    'aliases': ['webs with a recent giving', 'coupled webs with memory', '带近来所给的网',
                'Becoming.RegimeMargin.Coupled.Indexed.Recent.keepsBelow',
                'Becoming.RegimeMargin.Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent'],
    'dependencies': [
        {'id': RM9, 'relation': 'formal-reuse',
         'detail': {'en': 'Its bounded laws are stated for any law read condition by condition and applied to the web with a '
                          'recent giving; its open item is answered.',
                    'zh': '其有界之律对任何逐条件读取之律陈述，并用于带近来所给的网；回答其开放项。'},
         'interface': {
             'output': {'en': 'StaysWithin, ends_iff_within, thresholdWithin, ends_iff_below_within, threshold_falls_within.',
                        'zh': 'StaysWithin、ends_iff_within、thresholdWithin、ends_iff_below_within、threshold_falls_within。'},
             'input': {'en': 'A law of states read condition by condition, keeping their order.',
                       'zh': '逐条件读取并保持状态之序的律。'},
             'conditions': {'en': 'Finitely many parts; a bound on the run.', 'zh': '有限多个部分；运行之界。'},
             'evidence': SRC}},
        {'id': RM8, 'relation': 'formal-reuse',
         'detail': {'en': 'setAt and the web\'s alike laws are reused; run_alike is derived from the general law.',
                    'zh': '沿用 setAt 与网的相同律；run_alike 由一般之律导出。'},
         'interface': {
             'output': {'en': 'setAt, setAt_below, step_alike, run_alike.', 'zh': 'setAt、setAt_below、step_alike、run_alike。'},
             'input': {'en': 'The web\'s step as one law read condition by condition.', 'zh': '网之步作为一个逐条件读取之律。'},
             'conditions': {'en': 'Pointwise reading.', 'zh': '逐条件读取。'},
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
        'en': f'22 October 2026: added (RM10), webs with a recent giving; RM9\'s bounded laws stated for any law read condition '
              f'by condition; study section {N}.',
        'zh': f'2026年10月22日：新增（RM10），带近来所给的网；RM9 的有界之律对任何逐条件读取之律陈述；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
loaded = {}
d = json.loads((RECORDS / f'{RM9}.json').read_text())
hits = [x for x in d['does_not_show'] if 'webs with a recent giving' in x['en']]
assert len(hits) == 1, len(hits)
hits[0]['en'] = hits[0]['en'].replace('webs with a recent giving; ', '')
hits[0]['zh'] = hits[0]['zh'].replace('带近来所给的网；', '')
for lang, old_ in (('en', 'Webs with a recent giving; '), ('zh', '带近来所给的网；')):
    assert d['next_delta'][lang].count(old_) == 1, (RM9, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['next_delta']['en'] = d['next_delta']['en'][0].upper() + d['next_delta']['en'][1:]
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'Its bounded laws are stated for any law read condition by condition, and hold of webs with a recent giving.',
    'zh': '其有界之律对任何逐条件读取之律陈述，并对带近来所给的网成立。'}}]
d['history'].append({
    'en': f'22 October 2026, RM10: its bounded laws are now stated for any law of states read condition by condition, the '
          f'web\'s step an instance, and applied to webs with a recent giving (record {RID}, study section {N}). Their content '
          f'for the web is unchanged.',
    'zh': f'2026年10月22日，RM10：其有界之律今对任何逐条件读取状态之律陈述，网之步是其实例，并用于带近来所给的网（记录 {RID}，研究第 {N} 节）。'
          f'其对网的内容不变。'})
loaded[RM9] = d
d = json.loads((RECORDS / f'{RM8}.json').read_text())
hits = [x for x in d['does_not_show'] if x['en'].startswith('Webs with a recent giving; amounts beyond whole numbers.')]
assert len(hits) == 1, len(hits)
hits[0]['en'] = ('Amounts beyond whole numbers; rest within a band with a recent giving. Thresholds beyond a band and webs '
                 'with a recent giving are stated (records ' + RM9 + ', ' + RID + ').')
hits[0]['zh'] = '整数之外的量；带近来所给时带内的静止。带外的阈值与带近来所给的网已陈述（记录 ' + RM9 + '、' + RID + '）。'
for lang, old_ in (('en', 'Webs with a recent giving; '), ('zh', '带近来所给的网；')):
    assert d['next_delta'][lang].count(old_) == 1, (RM8, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['next_delta']['en'] = d['next_delta']['en'][0].upper() + d['next_delta']['en'][1:]
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'Webs with a recent giving keep the order under mutual support; their bounded runs have ending decided and exact thresholds.',
    'zh': '带近来所给的网在相互支持下保持序；其有界运行的终结可判定，阈值精确。'}}]
d['history'].append({
    'en': f'22 October 2026, RM10: webs with a recent giving are stated (record {RID}, study section {N}); run_alike is now '
          f'derived from run_alike_of. The statements of its laws are unchanged.',
    'zh': f'2026年10月22日，RM10：带近来所给的网已陈述（记录 {RID}，研究第 {N} 节）；run_alike 今由 run_alike_of 导出。其律的陈述不变。'})
loaded[RM8] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
