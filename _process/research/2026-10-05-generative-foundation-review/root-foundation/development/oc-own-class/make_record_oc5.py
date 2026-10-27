#!/usr/bin/env python3
"""OC5 record: extend constancy-read-at-a-members-class with the laws OC5 added to Becoming.GrammarPath (the condition
where the member acts and the division through its own leaving effects, in its fourth law; what the reach asks of the
class, the witnesses OtherLeaves and FiniteFamilies.member_no_reach, as an eighth; FinerWake.finer_class in its sixth),
with its title, statement, what it does not show, next step, correspondence, validation scope and history, as OC5's
review left them (REVIEW-OC5.md, findings 1, 2, 5, 9, 12, 14 and 19). The records bound to the module are re-pointed
with repoint_oc5.sh. `--draft` writes the record to OUT without the receipt, for a review.
usage (from the checkout root, after texts_oc5.py): python3 -B make_record_oc5.py RECEIPT N | --draft OUT"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
DRAFT = sys.argv[1] == '--draft'
RECEIPT_ID, N = ('RECEIPT', 0) if DRAFT else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
REVIEW = RF + 'development/oc-own-class/REVIEW-OC5.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PATH = f'{PKG}/Becoming/GrammarPath.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
RID = 'constancy-read-at-a-members-class'
B = 'Becoming.'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


r = json.loads((RECORDS / f'{RID}.json').read_text(encoding='utf-8'))
proof = next(x for x in r['references'] if x['role'] == 'proof')
before = set(proof['declarations'])
assert len(before) == 57, len(before)
REACH = [B + '«后皆同类则后皆续»', B + '«后皆续当且仅当后皆同类»', B + '«后皆续则所缘同于»', B + '«后皆续当且仅当自与线皆闭»',
         B + '«亡而网续则后不皆续»']
OWN = [B + '«本类常当且仅当与己相随»', B + '«外分唯系己出之同»']
OTHER = [B + 'OtherLeaves.' + n for n in ('Occ', 'step', 'inClass', 'reached', 'reached_step', 'reached_after',
                                          'all_alike', 'not_constant_at', 'other_not_held', 'other_off_line',
                                          'reach_without_condition')]
FAMILIES = [B + 'FiniteFamilies.member_no_reach']
FINER = [B + 'FinerWake.finer_class']
new = set(REACH + OWN + OTHER + FAMILIES + FINER)
assert len(new) == 20 and not new & before
if not DRAFT:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed' and core['source_sha256']['Becoming.GrammarPath'] == sha(PATH)
    mod = next(m for m in core['modules'] if m['module'] == 'Becoming.GrammarPath')
    assert not any(mod['axiom_dependencies'].values())
    names = {d['name'] for d in mod['declarations']}
    assert before | new <= names, sorted((before | new) - names)
assert [len(x['declarations']) for x in r['laws']] == [3, 7, 8, 2, 7, 19, 11]

r['reviewed_at_utc'] = NOW
assert r['title']['en'] == "Constancy read at a member's class, and how what lies outside it is divided"
r['title'] = {'en': "Constancy read at a member's class, what the reach asks of the class, and how what lies outside it "
                    "is divided",
              'zh': '于员之类之至终有常，此及所须，与类外之分'}
r['statement'] = {
    'en': "Constancy up to the net's end at a member's class carries the path's laws; the reach needs only that the class "
          "hold the effects of the member and its line. Where the member acts, it and alike occurrences must follow each "
          "other, so the division outside bears only through its own leaving effects.",
    'zh': '于员之类之至网之终有常足承此路诸律；此及唯须类持员及其线之所缘。员有所缘时，员与同类者须相随，故类外之分唯经其己出类之效而入。'}
assert len(r['statement']['en']) <= 300, len(r['statement']['en'])
law = r['laws']
assert law[3]['en'].startswith('How what lies outside is divided bears on the condition only through')
law[3] = {
    'en': "How what lies outside is divided bears on the condition only through what is alike to an effect that leaves "
          "the member's class. Where the member conditions something, the condition is that whatever an alike occurrence "
          "conditions is alike to something the member conditions, and whatever the member conditions, each alike "
          "occurrence that conditions anything conditions something alike to it; so how what lies outside is divided "
          "bears on it only through what is alike to the member's own effects that leave the class, and is idle where "
          "the class holds the member's effects.",
    'zh': '类外之分唯经与出员之类之效同类者而系于此条件。员有所缘时，此条件即：同类者之所缘皆与员之某所缘同类，而员之每一所缘，'
          '每一有所缘之同类者皆缘与之同类者；故类外之分唯经与员己出类之效同类者系于此条件，类持员之所缘时，类外如何分无关。',
    'declarations': sorted(law[3]['declarations'] + OWN)}
law[5]['declarations'] = sorted(law[5]['declarations'] + FINER)
law.append({
    'en': "Everything downstream of a member lies on its line under a class exactly where everything downstream of it is "
          "alike to it, that is, where the class holds the effects of the member and of each stage of its line, with no "
          "regularity assumed; so the reach needs the member's effects held, and it excludes a line from the member that "
          "ends while its last stage still conditions something, as the organism's class shows. With them, where the "
          "member conditions something, the condition at the member's class gives the reach and holds the effects of "
          "every alike occurrence; but the reach does not need it: in a witness the class holds the member's effects and "
          "everything downstream of the member lies on its line, while the class fails the condition at the member and "
          "does not hold the effects of an alike occurrence off that line.",
    'zh': '一员之后皆在其类下之线上，当且仅当其后皆与之同类，即类持员及其线上每一阶之所缘，不设有常；故此及须持员之所缘，且不容'
          '自员之线亡而其末阶犹有所缘，如有机体之类。持之，员有所缘时，员之类之至终有常足致此及，并持每一同类者之所缘；而此及不须'
          '之：见证中类持员之所缘，员之后皆在其线上，而此类于此员处不成此条件，亦不持其线外一同类者之所缘。',
    'declarations': sorted(REACH + OTHER + FAMILIES)})
dns = r['does_not_show']
dns.append({'en': "That the class of an actual agent's line holds the effects of each stage of its line, with P2 or "
                  "without it (a correspondence).",
            'zh': '实际行动者之线之类，有此理或无之，皆持其线之每一阶之所缘（一对应）。', 'kind': 'non-implication'})
r['next_delta'] = {
    'en': "A correspondence: whether every occurrence alike to an actual agent that conditions anything both conditions "
          "something in the class of its line and leaves something outside it, so that P2, read with the split of that "
          "class from the rest, passes a self drawn by intention in actual nets; and whether the class of an actual "
          "agent's line holds the effects of each stage of its line, which is what the path needs, with P2 or without "
          "it. Whether one presupposes P2, or only what the path needs, is put to philosophers (P-20, question 6); so is "
          "the crux, P4 (question 2).",
    'zh': '一对应：实际行动者之每一有所缘之同类者，是否皆既缘其线之类内者又有出其类者，从而以此类与其余二分读之之 P2 '
          '于实际之网中通过以所意划之自；及实际行动者之线之类，有此理或无之，是否持其线之每一阶之所缘，此即此路所须。'
          '所预设者为 P2 抑或仅此路所须，交哲学家（P-20 第 6 问）；关键 P4 亦交之（第 2 问）。'}
corr = r['correspondence']
assert corr['en'].endswith(' The reading is the AI\'s.') and corr['zh'].endswith('读法为 AI 之。')
corr['en'] = corr['en'][:-len(' The reading is the AI\'s.')] + (
    " The path itself asks less: that the class hold the effects of the self and of each stage of its line; given "
    "that the self holds its effects and acts, P2 gives this and also holds the effects of every occurrence alike to the "
    "self, off its line included. The reading is the AI's.")
corr['zh'] = corr['zh'][:-len('读法为 AI 之。')] + (
    '此路自身所问较少：类持自及其线之每一阶之所缘；自持其所缘且有所缘时，P2 致此，并持与自同类之每一者之所缘，其线外者亦然。'
    '读法为 AI 之。')
if not DRAFT:
    r['validation_scope'] = {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarPath, '
              f'every declaration with an empty axiom report; this record cites the 57 declarations OC1 and OC2 added and '
              f'the 20 OC5 added. PF\'s and PF2\'s statements are unchanged, their proofs now through the forms at a '
              f'member\'s class; «本类常闭则后皆续» takes its line from «后皆同类则后皆续», and «闭则外分无关» follows '
              f'from «外分唯系己出之同», their statements unchanged. Author review in study section 408; an independent '
              f'review (one reviewer, read-only) and its fixes in study section 411; OC5\'s laws and texts reviewed the '
              f'same way before landing, study section {N}.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarPath，公理报告皆空；本记录引 OC1 与 OC2 所增之 57 项'
              f'及 OC5 所增之 20 项。PF 与 PF2 之陈述未变，其证明今经于员之类之形；«本类常闭则后皆续» 之线取自 «后皆同类则后皆续»，'
              f'«闭则外分无关» 由 «外分唯系己出之同» 得，陈述皆未变。作者审查见研究第 408 节；独立审查（一审者，只读）及其修正见研究第 '
              f'411 节；OC5 之律与文于落地前同样审查，见研究第 {N} 节。'}
    refs = r['references']
    assert [x['role'] for x in refs][:3] == ['proof', 'receipt', 'integration'], [x['role'] for x in refs]
    refs[0] = {'path': PATH, 'role': 'proof', 'declarations': sorted(before | new), 'sha256': sha(PATH)}
    refs[1] = {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)}
    refs[2] = {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)}
    for x in refs:
        if x['role'] == 'statement' and x['path'] == CH7:
            x['sha256'] = sha(CH7)
    if not any(x['path'] == REVIEW for x in refs):
        refs.append({'path': REVIEW, 'role': 'review', 'sha256': sha(REVIEW)})
    r['proof_bindings'] = [{'source': PATH, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarPath',
                            'success_pointer': '/status', 'success_value': 'passed'}]
r['aliases'] = r['aliases'] + [a for a in (B + '«本类常当且仅当与己相随»', B + '«后皆续当且仅当后皆同类»',
                                             B + '«后皆续当且仅当自与线皆闭»') if a not in r['aliases']]
r['history'].append({
    'en': f'27 October 2026: extended (OC5): where the member conditions something, the condition at its class is that '
          f'it and each alike occurrence follow each other, so how what lies outside is divided bears only through the '
          f'member\'s own leaving effects; the reach asks only that the class hold the effects of the member and of '
          f'each stage of its line, which the condition gives with the member\'s effects held, but the reach does not '
          f'need the condition (OtherLeaves), and it excludes a line that ends while its last stage still conditions '
          f'something (FiniteFamilies.member_no_reach); «本类常闭则后皆续» and «闭则外分无关» now derived from the new '
          f'laws; FinerWake.finer_class. Title and statement extended. Study section {N}.',
    'zh': f'2026年10月27日：扩充（OC5）：员有所缘时，员之类之此条件即员与每一同类者相随，故类外之分唯经员己出类之效而入；'
          f'此及唯须类持员及其线上每一阶之所缘，此条件偕持员之所缘致之，而此及不须此条件（OtherLeaves），且不容线亡而其末阶犹有所缘'
          f'（FiniteFamilies.member_no_reach）；«本类常闭则后皆续» 与 «闭则外分无关» 今由新律得；FinerWake.finer_class。'
          f'题与陈述随之扩充。研究第 {N} 节。'})
out = Path(sys.argv[2]) if DRAFT else RECORDS / f'{RID}.json'
out.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(before), '+', len(new), 'declarations', '(draft)' if DRAFT else '')
