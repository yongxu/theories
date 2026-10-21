#!/usr/bin/env python3
"""Write RM9's record thresholds-beyond-a-band (a theorem) and note it in RM8's record rest-on-coupled-webs, whose open
item it answers:
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
HEAD = f"## {N}. Thresholds beyond a band: a bound on the run in its place (RM9)"
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
RID = 'thresholds-beyond-a-band'
RM8 = 'rest-on-coupled-webs'
RM7 = 'coupled-webs'
W = 'RegimeMargin.Coupled.Indexed.'
PAIR = 'RegimeMargin.Coupled.'
laws = [
    ('A giving reads what is left condition by condition where what is left alike at every condition gives alike; mutual '
     'support does so, and the laws that states alike step, run and end alike take this premise.',
     '所余在每个条件上相同则所给相同时，所给逐条件读取所余；相互支持如此，状态相同则步、运行与终结相同的律以此为前提。',
     [W + n for n in ['Pointwise', 'pointwise_of_rises']]),
    ('A state is read through the list of its listed levels; the (B + 1)^n lists of n levels within B are listed, every '
     'state within B has its levels among them, and two states with the same levels are alike at every condition.',
     '状态经其所列水平的列表读取；n 个至多 B 的水平的 (B + 1)^n 个列表被列出，至多 B 的每个状态的水平在其中，水平相同的两个状态在每个条件上相同。',
     [W + n for n in ['levels', 'levels_alike', 'withFirst', 'withFirstUpTo', 'levelLists', 'withFirst_length',
                      'withFirstUpTo_length', 'levelLists_length', 'mem_withFirst', 'mem_withFirstUpTo', 'levels_mem']]),
    ('A run that stays within B comes back, at some step at most (B + 1)^n, to the state of an earlier step, and where '
     'giving reads condition by condition it repeats from there; under mutual support every run below one within B stays '
     'within it.',
     '保持在 B 之内的运行，在至多 (B + 1)^n 的某步回到较早一步的状态；所给逐条件读取时由此重复；相互支持下，在 B 之内的运行之下的每个运行都保持在其内。',
     [W + n for n in ['StaysWithin', 'within_below', 'returns_within', 'repeats', 'repeats_mul', 'zero_from_window']]),
    ('Where giving reads condition by condition and the run stays within B, a condition ends exactly where it is nothing '
     'at every step from L = (B + 1)^n to 2 L, and where it ends it is nothing from L on: a finite check, with no band and '
     'no order of states.',
     '所给逐条件读取且运行保持在 B 之内时，条件恰在其于 L = (B + 1)^n 到 2 L 的每一步为零时终结，终结则自 L 起为零：有限检查，不需带，不需状态之序。',
     [W + n for n in ['ends_iff_within', 'below_of', 'endingWithin', 'ending_iff']]),
    ("Under mutual support, where the run from a condition's top level hi, the others given, stays within B, its point of "
     'no return up to hi + 1 is exact, and others\' levels lower give a threshold no lower: beyond any band.',
     '相互支持下，条件自其顶水平 hi（其他给定）的运行保持在 B 之内时，其至多 hi + 1 的不可回返点是精确的，其他水平更低则阈值不更低：在任何带之外。',
     [W + n for n in ['thresholdWithin', 'ends_iff_below_within', 'threshold_falls_within']]),
    ('Relay keeps no band from three up, yet from two with its partner at three its run stays within three; its first '
     "condition's threshold is three with the partner at two and two with the partner at three.",
     'Relay 自三起不保持任何带，但自二、伙伴在三的运行保持在三之内；其第一条件的阈值，伙伴在二时为三，伙伴在三时为二。',
     [PAIR + n for n in ['Relay.ends_set', 'Relay.threshold_beyond_band']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert not (old_names - set(full)), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve([W + 'step', W + 'Ends', W + 'Rises', W + 'Below', W + 'run_below', W + 'ends_of_below',
                   W + 'respects', W + 'step_alike', W + 'run_alike', W + 'ends_alike', W + 'setAt', W + 'setAt_below',
                   W + 'Band', W + 'threshold', W + 'ends_iff_below', PAIR + 'pair_run', PAIR + 'ends_pair',
                   PAIR + 'pair_rises', PAIR + 'setAt_pair', PAIR + 'covers_pair', PAIR + 'Relay.between',
                   PAIR + 'Relay.cycles', 'RegimeMargin.leading', 'RegimeMargin.leading_true', 'RegimeMargin.leading_false',
                   'RegimeMargin.leading_le', 'RegimeMargin.below', 'RegimeMargin.below_spec'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Thresholds beyond a band', 'zh': '带外的阈值'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': "Beyond a band, a bound on the run decides by a finite check whether a condition of a finite web ends, "
              "and under mutual support each point of no return is exact and at most what it was as any other level rises.",
        'zh': '在带之外，运行之界以有限检查判定有限之网的条件是否终结；相互支持下，每个不可回返点是精确的，且在任何其他水平上升时至多为原值。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Whole numbers; finitely many conditions listed by a list covering them; draws taken first, as '
               'much as there is; each giving a law of what is left of all, read condition by condition (for the decision) '
               'and rising with each (mutual support, for the threshold); the run from the top level considered within a '
               'bound B; discrete steps.',
         'zh': '不加公理。整数；由覆盖列表列出的有限多个条件；汲取先取，有多少取多少；各所给是所有所余之律，逐条件读取（用于判定），且随每个上升（相互支持，用于阈值）；'
               '自所考虑顶水平的运行在界 B 之内；离散步。'}],
    'does_not_show': [
        {'en': 'Runs that grow without bound: there whether a condition ends is not decided here.',
         'zh': '无界增长的运行：在那里条件是否终结此处不判定。', 'kind': 'scope'},
        {'en': "That the decision's step count, (B + 1) to the conditions' count, is tight; webs with a recent giving; "
               'amounts beyond whole numbers.',
         'zh': '判定的步数 (B + 1) 的条件数次方是紧的；带近来所给的网；整数之外的量。', 'kind': 'scope'},
        {'en': 'That measured webs stay within a bound or meet mutual support.',
         'zh': '所测的网保持在一个界之内或满足相互支持。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core purity. Built and reviewed '
              f'in one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.RegimeMargin 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Webs with a recent giving; a field web whose couplings are measured; an independent review.',
        'zh': '带近来所给的网；耦合经测量的野外之网；独立审查。'},
    'correspondence': {
        'en': 'A deterministic map on a finite set is eventually periodic within its size (pigeonhole); finite-state '
              'properties are decided by bounded checks (bounded model checking, Biere et al. 1999); the comparison '
              'principle of monotone systems (Hirsch 1985; Smith 1995).',
        'zh': '有限集上的确定映射在其大小之内终归周期（鸽巢）；有限状态的性质由有界检查判定（有界模型检验，Biere 等 1999）；单调系统的比较原理（Hirsch 1985；Smith 1995）。'},
    'canonical_source': SRC,
    'aliases': ['thresholds beyond a band', 'a bound on the run in place of the band', '带外的阈值',
                'Becoming.RegimeMargin.Coupled.Indexed.ends_iff_within',
                'Becoming.RegimeMargin.Coupled.Indexed.ends_iff_below_within'],
    'dependencies': [
        {'id': RM8, 'relation': 'formal-reuse',
         'detail': {'en': "The web's alike laws, setAt and the threshold's search are reused; the thresholds beyond a band "
                          'its open item names are stated.',
                    'zh': '沿用网的相同律、setAt 与阈值的搜索；陈述了其开放项所列的带外阈值。'},
         'interface': {
             'output': {'en': 'step_alike, run_alike, ends_alike, setAt, setAt_below, leading.',
                        'zh': 'step_alike、run_alike、ends_alike、setAt、setAt_below、leading。'},
             'input': {'en': 'Ending and thresholds where a run is bounded but no band holds.',
                       'zh': '运行有界而无带时的终结与阈值。'},
             'conditions': {'en': 'Finitely many conditions; a bound on the run.', 'zh': '有限多个条件；运行之界。'},
             'evidence': SRC}},
        {'id': RM7, 'relation': 'formal-reuse',
         'detail': {'en': "The web's order and ending are reused for the threshold.",
                    'zh': '阈值沿用网之序与终结。'},
         'interface': {
             'output': {'en': 'run_below, ends_of_below, Ends.', 'zh': 'run_below、ends_of_below、Ends。'},
             'input': {'en': 'Down-closure of ending under mutual support.', 'zh': '相互支持下终结的向下封闭。'},
             'conditions': {'en': 'Mutual support.', 'zh': '相互支持。'},
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
        'en': f'22 October 2026: added (RM9), thresholds on coupled webs beyond a band, a bound on the run in its place; the '
              f'web\'s alike laws stated for pointwise reading; study section {N}.',
        'zh': f'2026年10月22日：新增（RM9），带外的耦合之网阈值，以运行之界代替带；网的相同律以逐条件读取陈述；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
loaded = {}
d = json.loads((RECORDS / f'{RM8}.json').read_text())
dns = [x for x in d['does_not_show'] if x['en'] == 'Thresholds beyond a band; webs with a recent giving; amounts beyond whole numbers.']
assert len(dns) == 1
dns[0]['en'] = ('Webs with a recent giving; amounts beyond whole numbers. Thresholds beyond a band, a bound on the run in '
                'its place, are stated (record ' + RID + ').')
dns[0]['zh'] = '带近来所给的网；整数之外的量。带外的阈值（以运行之界代替带）已陈述（记录 ' + RID + '）。'
for lang, old_ in (('en', 'Thresholds beyond a band, with a bound on the run in its place; '),
                   ('zh', '带外的阈值，以运行之界代替带；')):
    assert d['next_delta'][lang].count(old_) == 1, (RM8, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['next_delta']['en'] = d['next_delta']['en'][0].upper() + d['next_delta']['en'][1:]
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'Beyond a band, a bound on the run decides ending by a finite check, and each threshold is exact and falls as '
          'others rise.',
    'zh': '在带之外，运行之界以有限检查判定终结，每个阈值是精确的且随其他上升而下降。'}}]
d['history'].append({
    'en': f'22 October 2026, RM9: thresholds beyond a band are stated with a bound on the run in its place (record {RID}, '
          f'study section {N}); step_alike, run_alike and ends_alike now take pointwise reading, of which mutual support '
          f'is the case. The statements of its laws are unchanged.',
    'zh': f'2026年10月22日，RM9：以运行之界代替带陈述了带外的阈值（记录 {RID}，研究第 {N} 节）；step_alike、run_alike 与 ends_alike '
          f'今以逐条件读取为前提，相互支持是其情形。其律的陈述不变。'})
loaded[RM8] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
