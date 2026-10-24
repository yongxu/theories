#!/usr/bin/env python3
"""GS5 record: write the-class-of-being-joined (the new declarations of Becoming.GrammarScope and the ThirdThing,
ThirdAffects and ThirdFed declarations of Becoming.GrammarCases). The four earlier records bound to these modules are
re-pointed with repoint.py.
usage (from the checkout root, after texts_gs5.py): python3 -B make_records_gs5.py RECEIPT N"""
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
SCOPE, CASES = f'{PKG}/Becoming/GrammarScope.lean', f'{PKG}/Becoming/GrammarCases.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.GrammarScope'] == sha(SCOPE)
assert core['source_sha256']['Becoming.GrammarCases'] == sha(CASES)
mods = {m['module']: m for m in core['modules'] if m['module'] in ('Becoming.GrammarScope', 'Becoming.GrammarCases')}
for m in mods.values():
    assert not any(m['axiom_dependencies'].values())
scope_names = {d['name'] for d in mods['Becoming.GrammarScope']['declarations']}
cases_names = {d['name'] for d in mods['Becoming.GrammarCases']['declarations']}
NEW_SCOPE = ['Becoming.' + n for n in ('«缘在族中»', '«族之续即缘»', '«族之所及即一之所及»', '«续即缘当且仅当含族»',
                                        '«遍有后则族有常»', '«遍有后则缘在族核»', '«遍有后则核之所及即一之所及»')]
NEW_CASES = sorted(n for n in cases_names if n.startswith(('Becoming.ThirdThing.', 'Becoming.ThirdAffects.',
                                                           'Becoming.ThirdFed.')))
assert set(NEW_SCOPE) <= scope_names and NEW_CASES


def proof_decls(rid):
    d = json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))
    return set(next(r for r in d['references'] if r['role'] == 'proof')['declarations'])


old_scope = proof_decls('the-continuation-condition-on-the-root') | proof_decls('reach-past-ones-own-end')
old_cases = proof_decls('the-source-texts-test-systems') | proof_decls('reach-through-a-shared-condition')
assert old_scope <= scope_names and not (old_scope & set(NEW_SCOPE))
assert old_cases <= cases_names and not (old_cases & set(NEW_CASES))
assert old_scope | set(NEW_SCOPE) == scope_names, sorted(scope_names - old_scope - set(NEW_SCOPE))
assert old_cases | set(NEW_CASES) == cases_names, sorted(cases_names - old_cases - set(NEW_CASES))


def G(prefix):
    out = [n for n in NEW_CASES if n.startswith('Becoming.' + prefix + '.')]
    assert out, prefix
    return out


laws = [
    ("Every condition joins its two ends in one family under the one; under that class, the class of being joined, "
     "continuation is 缘 itself, and its lines reach exactly what the one's reach.",
     '凡缘皆使其两端在一之下之同族中；于此类（相连之类）下，续即缘本身，其线之所及恰即一之线之所及。',
     NEW_SCOPE[:3]),
    ("A class has 缘 as its continuation exactly where it contains the class of being joined by 缘 read either way: "
     "that class is the finest under which every condition is a continuation.",
     '一类以缘为其续，恰当其含以缘相连（正反皆读）之类：此类为凡缘皆为续之最细之类。',
     NEW_SCOPE[3:4]),
    ("Where every occurrence conditions something, the class of being joined is constant, its core holds both ends of "
     "every condition, and a line under the core reaches exactly what a line under the one reaches.",
     '凡事皆为某事之缘时，相连之类有常，其核含每一缘之两端，核下之线之所及恰即一之线之所及。',
     NEW_SCOPE[4:]),
    ("With a third thing joined to nothing beside two families and their shared condition, the class of being joined "
     "holds the first family's first member with the condition and with the second family's member two generations "
     "on and keeps every stage of the third thing apart, so it is narrower than the one; it is constant and its line "
     "reaches the second family's member.",
     '二家与其共之条件之旁，另有一与诸事皆不相连之第三物：相连之类含首家首成员与此条件及次家二代后之成员，而别第三物之每一阶段，故窄于一；此类有常，其线及于次家之成员。',
     G('ThirdThing')),
    ("With the third thing affecting the shared condition, the class of being joined is the one, while the constant "
     "class \"the third thing or not\" leaves it out and its line from the first family's first member reaches the "
     "second family's member two generations on.",
     '第三物影响共之条件时，相连之类即一；而「第三物与否」之类有常，不含第三物，其线自首家首成员及于次家二代后之成员。',
     G('ThirdAffects')),
    ("With the shared condition feeding the third thing, every constant class holding a stage of the condition with a "
     "member takes in the stage the condition feeds, alike with the member's next generation or the condition's next "
     "stage.",
     '共之条件养第三物时，凡含条件之一阶段与一成员之有常之类，皆纳此条件所养之阶段，与成员之次代或条件之次态同类。',
     G('ThirdFed')),
]
record = {
    'schema_version': 2,
    'id': 'the-class-of-being-joined',
    'title': {'en': 'The class of being joined', 'zh': '相连之类'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "The class of being joined by 缘 read either way has 缘 as its continuation and is the finest class that "
              "does; where every occurrence conditions something it is constant and its core holds every condition; a "
              "finer constant class can reach as far, depending on how the rest is joined.",
        'zh': '以缘相连（正反皆读）之类以缘为其续，为如此之最细之类；凡事皆为某事之缘时，此类有常，其核含每一缘；较细之有常之类亦可及同远，视余者如何相连。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in laws],
    'hypotheses': [{
        'en': 'No axiom and no premise beyond each law\'s own: for every carrier and relation; for constancy and the core, '
              'every occurrence conditions something; the witness\'s net supplied, with discrete steps and equality on '
              'its carrier.',
        'zh': '不加公理，除各律所带者外不加前提：对一切载体与关系；有常与核设凡事皆为某事之缘；见证之网为所给，设离散之步与载体上之相等。'}],
    'does_not_show': [
        {'en': 'That a center\'s own line runs under the class of being joined rather than a finer one: the de se question.',
         'zh': '中心之自线在相连之类下而非较细之类下：de se 之问。', 'kind': 'non-implication'},
        {'en': 'That the class of being joined is the only class that reaches: a finer constant class can, where a third thing '
               'affects the shared condition.',
         'zh': '相连之类为唯一能及之类：第三物影响共之条件时，较细之有常之类亦能。', 'kind': 'non-implication'},
        {'en': 'That the actual unfolding is joined, so that the class it fixes is the one.',
         'zh': '实有之展开为相连者，故其所定之类即一。', 'kind': 'correspondence'},
        {'en': 'Constancy where some occurrence conditions nothing.',
         'zh': '有事不为任何事之缘时之有常。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarScope and '
              f'Becoming.GrammarCases, every declaration with an empty axiom report; this record cites {len(NEW_SCOPE)} '
              f'declarations of the first and {len(NEW_CASES)} of the second. Author review in study section {N}.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarScope 与 Becoming.GrammarCases，公理报告皆空；'
              f'本记录引前者 {len(NEW_SCOPE)} 项、后者 {len(NEW_CASES)} 项。作者审查见研究第 {N} 节。'},
    'next_delta': {
        'en': 'Constancy of the class of being joined where some occurrences condition nothing; a law over every net of the '
              'directional cases: which constant classes leave out what affects a shared condition, and which must take '
              'in what it feeds.',
        'zh': '有事不为任何事之缘时，相连之类之有常；对一切网之方向之律：何种有常之类别影响共之条件者，何种必纳其所养者。'},
    'correspondence': {
        'en': 'PW NOTE §7 item 5, in part: the class of being joined holds the living with the conditions they affect and are '
              'fed by, and with everything any chain of 缘 joins to these; narrower than the one only where the net has '
              'unjoined parts; which constant class singles out the living with their conditions turns on how the rest '
              'is joined.',
        'zh': 'PW NOTE §7 第五项之一部：相连之类含生者及其所影响与所受养之条件，并含任何缘之链所连者；唯网有不相连之部分时窄于一；何种有常之类单取生者与其条件，视余者如何相连。'},
    'canonical_source': SCOPE,
    'aliases': ['The class of being joined', '相连之类', 'Becoming.«续即缘当且仅当含族»'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«同族», «同族为类», «一», «有常之逐点», «类有常当且仅当含于核», «及之单调».',
                    'zh': '«同族»、«同族为类»、«一»、«有常之逐点»、«类有常当且仅当含于核»、«及之单调»。'}},
    ],
    'related': [
        {'id': 'the-continuation-condition-on-the-root',
         'detail': {'en': 'The condition along the net, read with the class of being joined.', 'zh': '以相连之类读沿网之条件。'}},
        {'id': 'reach-through-a-shared-condition',
         'detail': {'en': 'The two families and their shared condition, here with a third thing joined three ways.', 'zh': '二家及其共之条件，此处另加以三种方式相连之第三物。'}}],
    'references': [{'path': SCOPE, 'role': 'proof', 'declarations': sorted(NEW_SCOPE), 'sha256': sha(SCOPE)},
                   {'path': CASES, 'role': 'proof', 'declarations': NEW_CASES, 'sha256': sha(CASES)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': SCOPE, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarScope',
                        'success_pointer': '/status', 'success_value': 'passed'},
                       {'source': CASES, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarCases',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'24 October 2026: added (GS5), PW\'s item 5; study section {N}.',
                 'zh': f'2026年10月24日：新增（GS5），PW 之第五项；研究第 {N} 节。'}],
}
path = RECORDS / 'the-class-of-being-joined.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', record['id'], len(NEW_SCOPE), '+', len(NEW_CASES))
