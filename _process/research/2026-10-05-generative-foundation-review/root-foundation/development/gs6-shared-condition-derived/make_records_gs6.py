#!/usr/bin/env python3
"""GS6 records. reach-through-a-shared-condition re-bound: its second and third laws' declarations change
(affecting_member_step, affecting_member_stays, fed_step and fed_stays out; firstFamily, first_left_into_condition and
first_never_left in), it gains a dependency on what-a-line-holds-and-a-regularity-takes-in, its does_not_show is scoped
to its net, and its validation scope, next step and history follow; statement, laws' text and hypotheses unchanged.
what-a-line-holds-and-a-regularity-takes-in: the corollary leaves its next step, its related entry says the witness is
derived, a history line; edited by exact substrings so that PF2's edits to the same record compose. The other records
bound to the two modules are re-pointed with repoint.py.
usage (from the checkout root, after texts_gs6.py): python3 -B make_records_gs6.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
CASES = f'{PKG}/Becoming/GrammarCases.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
SC = 'Becoming.SharedCondition.'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.GrammarCases'] == sha(CASES)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.GrammarCases')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
theorems = mod['theorems'] if isinstance(mod['theorems'], int) else len(mod['theorems'])
GONE = {SC + n for n in ('affecting_member_step', 'affecting_member_stays', 'fed_step', 'fed_stays')}
assert not (GONE & names)
LAW2 = {SC + n for n in ('affecting_member_outside', 'living', 'firstFamily', 'first_left_into_condition')}
LAW3 = {SC + n for n in ('fed', 'fed_outside', 'firstFamily', 'first_never_left')}
assert LAW2 | LAW3 <= names

# reach-through-a-shared-condition
path = RECORDS / 'reach-through-a-shared-condition.json'
r = json.loads(path.read_text(encoding='utf-8'))
assert SC + 'affecting_member_outside' in r['laws'][1]['declarations'] and SC + 'fed_outside' in r['laws'][2]['declarations']
r['laws'][1]['declarations'] = sorted(LAW2)
r['laws'][2]['declarations'] = sorted(LAW3)
proof = next(x for x in r['references'] if x['role'] == 'proof')
assert proof['path'] == CASES and GONE <= set(proof['declarations'])
in_namespace = sorted(n for n in names if n.startswith(SC))
proof['declarations'] = in_namespace
assert set().union(*(set(l['declarations']) for l in r['laws'])) == set(in_namespace)
proof['sha256'] = sha(CASES)
r['references'] = [x for x in r['references'] if x['role'] != 'receipt']
at = next(i for i, x in enumerate(r['references']) if x['role'] == 'integration')
r['references'].insert(at, {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
for x in r['references']:
    if x['role'] == 'integration':
        assert x['path'] == STUDY
        x['sha256'] = sha(STUDY)
    if x['role'] == 'statement':
        assert x['path'] == CH7
        x['sha256'] = sha(CH7)
assert len(r['proof_bindings']) == 1 and r['proof_bindings'][0]['source'] == CASES
r['proof_bindings'][0]['receipt'] = RECEIPT
dep = next(d for d in r['dependencies'] if d['id'] == 'continuation-relative-to-a-class')
assert dep['detail']['en'] == '«续», «相续», «一».'
dep['detail'] = {'en': '«续», «相续», «一», «一为类», «及之单调».', 'zh': '«续»、«相续»、«一»、«一为类»、«及之单调»。'}
assert not any(d['id'] == 'what-a-line-holds-and-a-regularity-takes-in' for d in r['dependencies'])
r['dependencies'].append({
    'id': 'what-a-line-holds-and-a-regularity-takes-in', 'relation': 'formal-reuse',
    'detail': {'en': '«所经不同则不及», by which both negative results are proved.',
               'zh': '«所经不同则不及»，二否定之结果皆由之而证。'}})
dns = next(d for d in r['does_not_show'] if d['en'].startswith('A class narrower than the one'))
assert dns['en'] == 'A class narrower than the one whose line reaches the other family, a core, or amounts and depletion.'
dns['en'] = 'In this net, a class narrower than the one whose line reaches the other family, or a core; amounts and depletion.'
dns['zh'] = '于此网中，较一为窄而其线及于他家之类，或核；量与耗竭。'
r['reviewed_at_utc'] = NOW
r['validation_scope'] = {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarCases, '
          f'{theorems} theorems in {len(names)} declarations, every declaration with an empty axiom report; this record '
          f'cites the {len(in_namespace)} of namespace SharedCondition. Author review in study sections 394 and {N}.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarCases，{len(names)} 项声明中 {theorems} 条定理，'
          f'公理报告皆空；本记录引 SharedCondition 命名空间之 {len(in_namespace)} 项。作者审查见研究第 394 与 {N} 节。'}
r['next_delta'] = {
    'en': 'In this net, a class narrower than the one whose line reaches the other family through the condition, with '
          'its core (other nets give such classes: ThirdThing.fixed_class_reaches, the class of being joined, constant, '
          'its core continuing the first step; ThirdAffects.finer_class_reaches; FiniteSharedCondition); amounts and '
          'depletion.',
    'zh': '于此网中，较一为窄、其线经条件及于他家之类，连同其核（他网给此类：ThirdThing.fixed_class_reaches，相连之类，'
          '有常，其核续首步；ThirdAffects.finer_class_reaches；FiniteSharedCondition）；量与耗竭。'}
r['history'].append({
    'en': f'25 October 2026: both negative results proved from «所经不同则不及» (GS6, board rule 9, on PF\'s proposal and '
          f'its review); affecting_member_step, affecting_member_stays, fed_step and fed_stays replaced by firstFamily, '
          f'first_left_into_condition and first_never_left, statements unchanged; the next step\'s general form of the '
          f'member-class result is that law (Becoming.GrammarPath), not restated for this net, and leaves the next step; '
          f'does_not_show scoped to this net; study section {N}.',
    'zh': f'2026年10月25日：二否定之结果皆由 «所经不同则不及» 证得（GS6，看板第九条，依 PF 之提议及其审查）；'
          f'affecting_member_step、affecting_member_stays、fed_step、fed_stays 代以 firstFamily、first_left_into_condition、'
          f'first_never_left，陈述不变；后续之「成员之类之结果之一般形式」即此律（Becoming.GrammarPath），不于此网重述，'
          f'故去之；does_not_show 限于此网；研究第 {N} 节。'})
path.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record: reach-through-a-shared-condition re-bound,', len(in_namespace), 'declarations cited,', theorems,
      'theorems in', len(names))

# what-a-line-holds-and-a-regularity-takes-in (PF's): exact substrings, so PF2's edits compose
path = RECORDS / 'what-a-line-holds-and-a-regularity-takes-in.json'
p = json.loads(path.read_text(encoding='utf-8'))
cut = {'en': '; SharedCondition.affecting_member_outside as a corollary of «所经不同则不及», with its owner',
       'zh': '；SharedCondition.affecting_member_outside 作为 «所经不同则不及» 之推论，由其主决'}
for lang, s in cut.items():
    assert p['next_delta'][lang].count(s) == 1, (lang, 'the corollary clause was reworded; edit by hand')
    p['next_delta'][lang] = p['next_delta'][lang].replace(s, '')
    assert 'affecting_member_outside' not in p['next_delta'][lang]
rel = next(x for x in p['related'] if x['id'] == 'reach-through-a-shared-condition')
if rel['detail']['en'] == "Its affecting_member_outside is the first law's case.":
    rel['detail'] = {'en': "Its affecting_member_outside and fed_outside are proved from the first law (GS6).",
                     'zh': '其 affecting_member_outside 与 fed_outside 皆由首律证得（GS6）。'}
p['history'].append({
    'en': f'25 October 2026: SharedCondition.affecting_member_outside and fed_outside proved from «所经不同则不及» in '
          f'Becoming.GrammarCases, which now imports this module (GS6); the corollary leaves the next step; study '
          f'section {N}.',
    'zh': f'2026年10月25日：SharedCondition.affecting_member_outside 与 fed_outside 于 Becoming.GrammarCases 中由 '
          f'«所经不同则不及» 证得，彼模块今引此模块（GS6）；此推论去后续；研究第 {N} 节。'})
for x in p['references']:
    if x['role'] == 'integration' and x['path'] == STUDY:
        x['sha256'] = sha(STUDY)
    if x['role'] == 'statement' and x['path'] == CH7:
        x['sha256'] = sha(CH7)
path.write_text(json.dumps(p, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record: what-a-line-holds-and-a-regularity-takes-in, the corollary done')

# the three records whose proofs changed, statements and declarations unchanged: dependency details and a history line
extra = {
    'the-source-texts-test-systems': ('continuation-relative-to-a-class',
        '«有常», «核», «根», «亡于核下不变», «类有常当且仅当含于核», «无环», «异».',
        ('«有常», «核», «根», «亡于核下不变», «类有常当且仅当含于核», «无环», «异», «线内同类», «及之单调».',
         '«有常»、«核»、«根»、«亡于核下不变»、«类有常当且仅当含于核»、«无环»、«异»、«线内同类»、«及之单调»。'),
        ('TwoLines.line_in_family', '«线内同类»')),
    'reach-past-ones-own-end': ('continuation-relative-to-a-class',
        '«有常», «核», «类有常当且仅当含于核», «一为类».',
        ('«有常», «核», «类有常当且仅当含于核», «一为类», «线内同类».',
         '«有常»、«核»、«类有常当且仅当含于核»、«一为类»、«线内同类»。'),
        ('LineOfDescent.Endless.member_line', '«线内同类»')),
}
for rid, (dep_id, old_en, (en, zh), (decl, law)) in extra.items():
    path = RECORDS / f'{rid}.json'
    q = json.loads(path.read_text(encoding='utf-8'))
    dep = next(d for d in q['dependencies'] if d['id'] == dep_id)
    assert dep['detail']['en'] == old_en, rid
    dep['detail'] = {'en': en, 'zh': zh}
    q['history'].append({
        'en': f'25 October 2026: {decl} proved by {law} (GS6, board rule 9), its statement unchanged; the dependency '
              f'detail names the law; study section {N}.',
        'zh': f'2026年10月25日：{decl} 由 {law} 证得（GS6，看板第九条），陈述不变；依赖之说明列此律；研究第 {N} 节。'})
    path.write_text(json.dumps(q, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', rid, 'dependency detail and history')
path = RECORDS / 'the-class-of-being-joined.json'
q = json.loads(path.read_text(encoding='utf-8'))
assert not any(d['id'] == 'wen-in-the-grammar' for d in q['dependencies'])
q['dependencies'].append({'id': 'wen-in-the-grammar', 'relation': 'formal-reuse',
                          'detail': {'en': 'sameValue, sameValue_class.', 'zh': 'sameValue、sameValue_class。'}})
q['history'].append({
    'en': f'25 October 2026: ThirdThing.family_keeps_third proved by «续即缘当且仅当含族» (GS6, board rule 9), its statement '
          f'unchanged; the dependency on wen-in-the-grammar (sameValue, sameValue_class), which ThirdAffects already used, '
          f'recorded; study section {N}.',
    'zh': f'2026年10月25日：ThirdThing.family_keeps_third 由 «续即缘当且仅当含族» 证得（GS6，看板第九条），陈述不变；'
          f'记其对 wen-in-the-grammar 之依赖（sameValue、sameValue_class，ThirdAffects 已用之）；研究第 {N} 节。'})
path.write_text(json.dumps(q, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record: the-class-of-being-joined dependency and history')
