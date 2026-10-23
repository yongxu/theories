#!/usr/bin/env python3
"""GS4 record: write lines-joined-through-a-shared-condition (the SharedCondition declarations of Becoming.GrammarCases).
the-source-texts-test-systems, whose declarations are unchanged, is re-pointed separately with repoint.py.
usage (from the checkout root, after texts_gs4.py): python3 -B make_records_gs4.py RECEIPT N"""
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
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
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
names = sorted(d['name'] for d in module['declarations'] if d['name'].startswith('Becoming.SharedCondition.'))
old = json.loads((RECORDS / 'the-source-texts-test-systems.json').read_text(encoding='utf-8'))
old_names = set(next(r for r in old['references'] if r['role'] == 'proof')['declarations'])
assert not (set(names) & old_names)
assert old_names | set(names) == {d['name'] for d in module['declarations']}
THEOREMS, DECLS = module['theorems'], len(module['declarations'])
S = 'Becoming.SharedCondition.'


def R(*short):
    out = [S + s for s in short]
    assert all(n in names for n in out), [n for n in out if n not in names]
    return out


laws = [
    ("Two family lines and a condition feeding both: where the members affect it, each a condition of its next state, "
     "the line under the one from the first family's first member reaches the second family's member two generations "
     "on, through the condition.",
     '二家族之线与养二者之一条件：成员影响之，各为其次态之缘；自首家首成员，一之下之线经此条件及于次家二代后之成员。',
     R('Occ', 'affecting', 'affecting_reaches_other')),
    ("Under the class \"a member or not\", which holds both families' members alike and the condition apart, the line "
     "from the first family's first member reaches no member of the second family.",
     '于「成员与否」之类下（二家成员同类，条件别于成员），自首家首成员之线不及次家之任何成员。',
     R('living', 'affecting_member_step', 'affecting_member_stays', 'affecting_member_outside')),
    ("Where the members only feed from a condition they do not affect, the line from the first family's first member, "
     "under any relation, reaches no member of the second family.",
     '成员唯受养于其所不影响之条件时，自首家首成员之线，于任何关系下，皆不及次家之任何成员。',
     R('fed', 'fed_step', 'fed_stays', 'fed_outside')),
]
cited = set().union(*(set(l[2]) for l in laws))
assert cited == set(names), (sorted(set(names) - cited),)

record = {
    'schema_version': 2,
    'id': 'reach-through-a-shared-condition',
    'title': {'en': 'One line reaching another through a shared condition', 'zh': '经共之条件一线及于他线'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "In witnesses of two family lines, one line's future reaches the other's along 缘 through a condition its "
              "members affect and that feeds the other, under the one and not under the class \"a member or not\"; "
              "through a common source none of them affects, under no relation.",
        'zh': '于二家族之线之见证中：一线成员所影响、而养他线之条件，使一线之未来沿缘及于他线，于一之下而不于「成员与否」之类下；无一成员影响之共源，则于任何关系下皆不及。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in laws],
    'hypotheses': [{
        'en': 'No axiom; each net supplied: one shared condition, one-step affecting (a member a condition of the '
              'condition\'s next state, no amounts) and one-step feeding (the condition a condition of the next '
              'generation of both); discrete steps and equality on the carrier.',
        'zh': '不加公理；各网为所给：一共之条件，一步之影响（成员为此条件次态之缘，不设量）与一步之养（此条件为二线次代之缘）；离散之步与载体上之相等。'}],
    'does_not_show': [
        {'en': 'That this holds of every net, or that every later member of the other line is reached: the witness gives '
               'one pair.',
         'zh': '此于一切网皆然，或他线之每一后来成员皆被及：见证只给一对。', 'kind': 'scope'},
        {'en': 'That self-concern is held along a class holding the shared condition: the open de se question.',
         'zh': '自之关切沿含共之条件之类而持：未决之 de se 之问。', 'kind': 'non-implication'},
        {'en': 'A class narrower than the one whose line reaches the other family, a core, or amounts and depletion.',
         'zh': '较一为窄而其线及于他家之类、核，或量与耗竭。', 'kind': 'scope'},
        {'en': 'That an actual commons puts those it feeds on the line of whatever acts on it.',
         'zh': '实有之共有物使其所养者在影响之者之线上。', 'kind': 'correspondence'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {MOD}, {THEOREMS} theorems '
              f'in {DECLS} declarations, every declaration with an empty axiom report; this record cites the '
              f'{len(names)} of namespace SharedCondition. Author review in study section {N}.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{MOD}，{DECLS} 项声明中 {THEOREMS} 条定理，公理报告皆空；'
              f'本记录引 SharedCondition 命名空间之 {len(names)} 项。作者审查见研究第 {N} 节。'},
    'next_delta': {
        'en': 'A class strictly between a member\'s and the one whose line reaches the other family through the condition, '
              'with its core; the general form of the member-class result for any class holding the condition apart '
              'from the members.',
        'zh': '严在成员之类与一之间、其线经条件及于他家之类，连同其核；成员之类之结果对凡别条件于成员之类之一般形式。'},
    'correspondence': {
        'en': 'PW NOTE §7 item 4: its first alternative answered at the one; its second for a condition the members do not '
              'affect.',
        'zh': 'PW NOTE §7 第四项：其第一可能于一之下得答；其第二于成员所不影响之条件得答。'},
    'canonical_source': SRC,
    'aliases': ['One line reaching another through a shared condition', '经共之条件一线及于他线',
                'Becoming.SharedCondition.affecting_reaches_other'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«续», «相续», «一».', 'zh': '«续»、«相续»、«一»。'}},
        {'id': 'generation-and-degeneration-at-two-grains', 'relation': 'formal-reuse',
         'detail': {'en': '«所及».', 'zh': '«所及»。'}},
        {'id': 'wen-in-the-grammar', 'relation': 'formal-reuse',
         'detail': {'en': 'sameValue, sameValue_class.', 'zh': 'sameValue、sameValue_class。'}}],
    'related': [
        {'id': 'the-source-texts-test-systems',
         'detail': {'en': 'Two family lines that share nothing reach nothing of each other (TwoLines).',
                    'zh': '无所共之二家族之线，彼此不相及（TwoLines）。'}},
        {'id': 'reach-past-ones-own-end',
         'detail': {'en': 'The reach past one\'s own end along a line under a class.', 'zh': '沿一类下之线过己之终之所及。'}}],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': names, 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'24 October 2026: added (GS4), PW\'s item 4; study section {N}.',
                 'zh': f'2026年10月24日：新增（GS4），PW 之第四项；研究第 {N} 节。'}],
}
path = RECORDS / 'reach-through-a-shared-condition.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', record['id'], len(names), 'declarations')
