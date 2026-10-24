#!/usr/bin/env python3
"""GS3 record: write the-source-texts-test-systems (every declaration Becoming.GrammarCases has, grouped by model).
Adapted from GS2's make_records_gs2.py.
usage (from the checkout root, after texts_gs3.py): python3 -B make_records_gs3.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
CH1 = 'theories/becoming/chapters/01-ROOT.md'
SRC = f'{PKG}/Becoming/GrammarCases.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
MOD = 'Becoming.GrammarCases'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256'][MOD] == sha(SRC)
module = next(m for m in core['modules'] if m['module'] == MOD)
assert not any(module['axiom_dependencies'].values())
names = {d['name'] for d in module['declarations']}
THEOREMS, DECLS = module['theorems'], len(names)


def group(prefix):
    out = sorted(n for n in names if n.startswith('Becoming.' + prefix + '.'))
    assert out, prefix
    return out


laws = [
    ("Decay: in a net where no occurrence reaches itself, the decay is an alteration under the one; in the net of "
     "possibilities, both stay and decay open at every intact moment, \"intact or not\" is constant and every two "
     "intact moments are alike in its core; a history within that net, decaying at its second step, has its two intact "
     "moments apart in that core.",
     '衰变：无事自及之网中，衰变为一之下之异；可能之网中，每一完之时刻皆可完可变，「完与否」有常，任二完之时刻于其核中同；'
     '此网内一史于第二步衰变，其二完之时刻于此核中分。',
     group('Decay')),
    ("No clear boundary: two overlapping identities, each a class; an occurrence ends under one and begins under the "
     "other; their union is not a class, and its line from the first occurrence reaches the third with its ends apart.",
     '无清楚之界：二相交之同一，各为类；一事于其一下终而于其二下生；二者之并非类，其线自首事及于第三事而两端分。',
     group('Overlap')),
    ("A line of descent generates at two grains: on the endless line of descent, the line under the one never ends and "
     "ahead of every point a member begins.",
     '传承之线于两种粒度生成：无尽之传承之线上，一下之续不尽，每一点之前皆有一成员始生。',
     ['Becoming.LineOfDescent.Endless.generates']),
    ("Two family lines: the class of one family line lies strictly between a member's class and the one, is constant, "
     "and its core goes on through each birth while the member's line ends; from one family's first birth no member "
     "of the other family is reached, even under the one.",
     '二家族之线：一家之线之类严在成员之类与一之间，有常，其核于每一出生处续而成员之线终；自一家之首次出生，即于一之下，亦不及他家之任何成员。',
     group('TwoLines')),
    ("A belief whose rate of spread grows with its number: on the step one holder at rate 0 goes to one holder at rate "
     "1, and one holder at rates 0 and 1 lie apart in the core of same number.",
     '传播之率随其数而增之信念：一步之中，一持者率零至一持者率一；一持者于率零与率一，于「同数」之核中分。',
     group('Belief')),
]
cited = set().union(*(set(l[2]) for l in laws))
assert cited == names, (sorted(names - cited), sorted(cited - names))

record = {
    'schema_version': 2,
    'id': 'the-source-texts-test-systems',
    'title': {'en': 'Test systems of the source texts as small witnesses', 'zh': '来源二篇之检验系统之小见证'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Small witnesses in the grammar show decay and overlapping identities, two of the source texts' test "
              "systems, and narrower stand-ins: a line of descent, two family lines and a belief whose rate grows with "
              "its number, each with what the grammar tells apart in it.",
        'zh': '来源二篇之检验系统中之衰变与无清楚之界，及较窄之代者（传承之线、二家族之线、传播之率随其数而增之信念），于文法中皆有小见证，各示文法于其中所分。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': d} for en, zh, d in laws],
    'hypotheses': [{
        'en': 'No axiom; each net is supplied with the behaviour in question (decay possible at every intact moment; '
              'every occurrence of descent with a successor); discrete steps and equality on the carriers; for the '
              'belief, natural-number counts and the linear laws held + rate and rate + held, read through the adaptive '
              'process of Becoming.Mechanism.',
        'zh': '不加公理；各网连同所问之行为给出（每一完之时刻皆可变；传承之每一事皆有后继）；离散之步与载体上之相等；信念设自然数之计与线性之律 '
              'held + rate、rate + held，经 Becoming.Mechanism 之自适之变而读。'}],
    'does_not_show': [
        {'en': 'That any actual nucleus, lineage or belief is so, or which net an actual decay is.',
         'zh': '实有之核、传承或信念如此，或实有之衰变是何网。', 'kind': 'correspondence'},
        {'en': 'Probabilities of decay, a vortex, a graded boundary, or an institution\'s identity through replaced people, '
               'rules and purposes.',
         'zh': '衰变之概率、涡、渐变之界，或机构经人、规与目的之替换而存之同一。', 'kind': 'scope'},
        {'en': 'Self-maintenance and adaptive regulation, or an organism that ends: the line of descent cannot end.',
         'zh': '自持与自适之调节，或有终之生体：传承之线不能终。', 'kind': 'scope'},
        {'en': 'A belief system whose content or law of spread changes: the laws here are supplied and fixed.',
         'zh': '其内容或传播之律有变之信念体系：此处之律为所给而定。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {MOD}, {THEOREMS} theorems '
              f'in {DECLS} declarations, every declaration with an empty axiom report; the checker verifies core purity. '
              f'Author review in study section {N}.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{MOD}，{DECLS} 项声明中 {THEOREMS} 条定理，公理报告皆空；'
              f'检查器并核对核心纯净。作者审查见研究第 {N} 节。'},
    'next_delta': {
        'en': 'A vortex; an institution\'s identity through replaced parts; an organism that renews its parts and ends; a '
              'model read off actual data for one system; decay with its probabilities in the periphery.',
        'zh': '涡；机构经部分之替换而存之同一；更新其部分而有终之生体；读自实有之数据之某一系统之模型；外围中带概率之衰变。'},
    'correspondence': {
        'en': 'The test systems of the first source text (§7): decay and the system with no clear boundary as stated; the '
              'organism and the belief system by narrower stand-ins; the second text\'s pair of observationally '
              'equivalent institutions is the thermostat witness read socially, not restated.',
        'zh': '第一篇来源之检验系统（§7）：衰变与无清楚之界如所述；生体与信念体系以较窄之代者；第二篇之二观察等价之机构，是以社会读之恒温之见证，未重述。'},
    'canonical_source': SRC,
    'aliases': ['Test systems of the source texts as small witnesses', '来源二篇之检验系统之小见证',
                'Becoming.Decay.time_not_in_core'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«有常», «核», «根», «亡于核下不变», «类有常当且仅当含于核», «无环», «异».',
                    'zh': '«有常»、«核»、«根»、«亡于核下不变»、«类有常当且仅当含于核»、«无环»、«异»。'}},
        {'id': 'generation-and-degeneration-at-two-grains', 'relation': 'formal-reuse',
         'detail': {'en': '«全生成», «传».', 'zh': '«全生成»、«传»。'}},
        {'id': 'reach-past-ones-own-end', 'relation': 'formal-reuse',
         'detail': {'en': 'LineOfDescent.Endless.', 'zh': 'LineOfDescent.Endless。'}},
        {'id': 'rules-that-change-themselves-in-the-grammar', 'relation': 'formal-reuse',
         'detail': {'en': 'moveRel, adaptive_core_apart.', 'zh': 'moveRel、adaptive_core_apart。'}}],
    'related': [
        {'id': 'testing-within-the-net',
         'detail': {'en': 'The thermostat witness, of which an institution kept by consent or by penalty is a social reading.',
                    'zh': '恒温之见证；以同意或以惩罚而持之机构是其社会之读。'}}],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CH1, 'role': 'statement', 'sha256': sha(CH1)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'24 October 2026: added (GS3), from the review of the root against its two source texts; study section {N}.',
                 'zh': f'2026年10月24日：新增（GS3），出自根与其二篇来源之对照审查；研究第 {N} 节。'}],
}
path = RECORDS / 'the-source-texts-test-systems.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record: the-source-texts-test-systems,', len(names), 'declarations')
