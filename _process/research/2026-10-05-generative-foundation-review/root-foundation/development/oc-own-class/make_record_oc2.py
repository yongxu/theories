#!/usr/bin/env python3
"""OC2 records: correct and extend constancy-read-at-a-members-class with what the independent review of OC1 found
(its statement, laws, correspondence, what it does not show, next step, validation scope and history; the declarations
OC2 added cited with OC1's), and restate the next step of what-leaves-a-class-follows-its-line. The records bound to
the module are re-pointed with repoint_oc2.sh.
usage (from the checkout root, after texts_oc2.py): python3 -B make_record_oc2.py RECEIPT N"""
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
REVIEW = RF + 'development/oc-own-class/REVIEW-OC1.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PATH = f'{PKG}/Becoming/GrammarPath.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
RID = 'constancy-read-at-a-members-class'
PF, PF2 = 'what-a-line-holds-and-a-regularity-takes-in', 'what-leaves-a-class-follows-its-line'
B = 'Becoming.'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def proof_declarations(record):
    return set(next(r for r in record['references'] if r['role'] == 'proof')['declarations'])


def read(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed' and core['source_sha256']['Becoming.GrammarPath'] == sha(PATH)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.GrammarPath')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
r = read(RID)
oc1 = proof_declarations(r)
old = proof_declarations(read(PF)) | proof_declarations(read(PF2)) | oc1
assert old <= names and len(oc1) == 43, sorted(old - names)
new = names - old
ENDS = [B + 'CleanStep.not_constant_at', B + 'CleanStep.ends_where_net_ends', B + 'Inconstant.not_constant_at']
IDLE = [B + '«外分唯系出类之同»']
SPLIT = [B + '«内外皆缘则二分本类常»']
WAKE = sorted(n for n in new if n.startswith(B + 'FinerWake.'))
assert len(WAKE) == 9 and new == set(ENDS + IDLE + SPLIT + WAKE), sorted(new ^ set(ENDS + IDLE + SPLIT + WAKE))
assert [len(x['declarations']) for x in r['laws']] == [3, 7, 5, 1, 6, 10, 11]

r['reviewed_at_utc'] = NOW
r['statement'] = {
    'en': "Constancy up to the net's end asked only at a member's class carries the path's laws and fails where a line "
          "ends at an occurrence still conditioning something; how what lies outside is divided bears only through "
          "effects leaving the class, and where a predicate decides the class the split asks least.",
    'zh': '只问于一员之类之至网之终有常，足承此路诸律，线亡于仍有所缘者处则不成；类外之分唯经出类之效而入，一谓词判员之类时二分所问最少。'}
assert len(r['statement']['en']) <= 300
law = r['laws']
law[1]['en'] = ("Each law of the path that asks constancy up to the net's end holds at the member's class, and PF's and "
                "PF2's forms are its corollaries: where a member conditions something and the class holds its effects, "
                "what is alike to it conditions only what is alike to it, everything downstream is on its line, and what "
                "a line reaches it carries on; holding the effects is everything downstream being alike; and what leaves "
                "the class follows every alike occurrence that conditions anything.")
law[1]['zh'] = ('此路诸问至网之终有常之律，皆于员之类成立，PF 与 PF2 之形为其推论：一员有所缘而类持其所缘时，与之同类者唯缘同类者，'
                '其下游皆在其线上，线所及者延至其后；持所缘即下游皆同类；出类者随每一有所缘之同类者。')
law[2]['en'] = ("A line that ends while it still conditions something fails the condition at its class, and the condition "
                "asks more than that a line end only where the net does; the organism's class fails it at the first "
                "member in both finite witnesses, and the class that holds a member's effects without the regularity "
                "fails it at the member.")
law[2]['zh'] = ('线亡而仍有所缘者，于其类不成此条件，而此条件所问多于线唯于网终处亡；两有限见证中，个体之类于首员处不成之；'
                '持员之所缘而无此理之类，于此员处不成之。')
law[2]['declarations'] = sorted(law[2]['declarations'] + ENDS)
law[3]['en'] = ("How what lies outside is divided bears on the condition only through what is alike to an effect that "
                "leaves the member's class; so where the class holds the effects of a member that conditions something, "
                "every class giving the member the same class gives the same verdict: how what lies outside is divided "
                "is idle.")
law[3]['zh'] = '类外之分唯经与出员之类之效同类者而系于此条件；故类持一有所缘之员之所缘时，凡予此员同一类者，判同：类外如何分无关。'
law[3]['declarations'] = sorted(law[3]['declarations'] + IDLE)
law[4]['en'] = ("Merging what lies outside keeps the condition, so where a predicate decides the member's class the split "
                "of that class from the rest asks least; under the split the condition is that what stays and what leaves "
                "follow every alike occurrence that conditions anything, and it holds where every such occurrence "
                "conditions something in the class and something outside.")
law[4]['zh'] = ('合类外者不失此条件，故一谓词判员之类时，以此类与其余二分者所问最少；二分之下，此条件即留者与出者皆随每一有所缘之同类者，'
                '凡此等者皆既缘类内者又缘类外者时即成。')
law[4]['declarations'] = sorted(law[4]['declarations'] + SPLIT)
law[5]['en'] = ("Dividing what lies outside more finely can break the condition, even where every alike occurrence that "
                "conditions anything conditions something in the class and something outside; witnesses where the split "
                "meets it.")
law[5]['zh'] = '细分类外者可破此条件，即使每一有所缘之同类者皆既缘类内者又缘类外者；见证中二分成之。'
law[5]['declarations'] = sorted(law[5]['declarations'] + WAKE)
dns = r['does_not_show']
assert dns[2]['en'].startswith('That the steps of actual agents')
dns[2] = {'en': "That every occurrence alike to an actual agent that conditions anything both conditions something in the "
                "class of its line and leaves something outside it (a correspondence).",
          'zh': '实际行动者之每一有所缘之同类者，皆既缘其线之类内者又有出其类者（一对应）。', 'kind': 'non-implication'}
dns.append({'en': "That a class under which every line from a member ends only where the net does meets the condition at "
                  "the member: in CleanStep it does not.",
            'zh': '自一员出之线皆唯于网终处亡之类，于此员处成此条件：CleanStep 中不成。', 'kind': 'converse'})
r['validation_scope'] = {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarPath, every '
          f'declaration with an empty axiom report; this record cites the {len(oc1) + len(new)} declarations OC1 and OC2 '
          f'added. PF\'s and PF2\'s statements are unchanged, their proofs now through the forms at a member\'s class. '
          f'Author review in study section 408; an independent review (one reviewer, read-only) and its fixes in study '
          f'section {N}.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarPath，公理报告皆空；本记录引 OC1 与 OC2 所增之 '
          f'{len(oc1) + len(new)} 项。PF 与 PF2 之陈述未变，其证明今经于员之类之形。作者审查见研究第 408 节；独立审查（一审者，只读）'
          f'及其修正见研究第 {N} 节。'}
r['next_delta'] = {
    'en': "A correspondence: whether every occurrence alike to an actual agent that conditions anything both conditions "
          "something in the class of its line and leaves something outside it, so that P2, read with the split of that "
          "class from the rest, passes a self drawn by intention in actual nets. The crux, P4, is put to philosophers.",
    'zh': '一对应：实际行动者之每一有所缘之同类者，是否皆既缘其线之类内者又有出其类者，从而以此类与其余二分读之之 P2 '
          '于实际之网中通过以所意划之自。关键 P4 交哲学家。'}
r['correspondence'] = {
    'en': "Read with the path's P2: a self's regularity of its own is constancy up to the net's end at its own class. Of "
          "a self that acts and holds its effects it requires, however what one leaves out is divided, that every "
          "occurrence alike to it condition only what is alike to it, so its line continues from every alike occurrence "
          "that conditions anything. Of a self drawn by intention, read with the split of itself from the rest, it "
          "requires that where any alike occurrence conditions something in its class, or something outside, every alike "
          "occurrence that conditions anything does too, which holds where each both conditions something in its class "
          "and leaves something outside. The reading is the AI's.",
    'zh': '以此路之 P2 读之：自之自有之理，即于其自之类之至网之终有常。于有所缘且持其所缘之自，无论所遗于外者如何分，要求与之同类者'
          '皆唯缘同类者，故其线于每一有所缘之同类者皆续。于以所意划之自，以自与其余二分读之，要求凡有一同类者缘类内者或缘类外者，'
          '则每一有所缘之同类者亦然；每一者皆既缘类内者又有出类者时即成。读法为 AI 之。'}
refs = r['references']
assert [x['role'] for x in refs] == ['proof', 'receipt', 'integration', 'provenance', 'statement']
refs[0] = {'path': PATH, 'role': 'proof', 'declarations': sorted(oc1 | new), 'sha256': sha(PATH)}
refs[1] = {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)}
refs[2] = {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)}
refs[4] = {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}
refs.insert(4, {'path': REVIEW, 'role': 'review', 'sha256': sha(REVIEW)})
r['proof_bindings'] = [{'source': PATH, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarPath',
                        'success_pointer': '/status', 'success_value': 'passed'}]
r['history'].append({
    'en': f'25 October 2026: reviewed independently (OC2): 4 errors, 9 imprecisions and 4 clarity points in its texts, no '
          f'proof wrong, all fixed; the laws extended (what lies outside bears only through effects leaving the class; a '
          f'sufficient condition under the split; the condition asks more than line-ending; the witnesses at the member\'s '
          f'class; FinerWake). The Open item it answered: its formal part by laws, the choice of class by a labelled '
          f'reading. Study section {N}.',
    'zh': f'2026年10月25日：独立审查（OC2）：其文中四误、九不确、四欠明，证明无误，皆已修正；诸律扩充（类外之分唯经出类之效；'
          f'二分下之充分条件；此条件所问多于线唯于网终处亡；见证于员之类；FinerWake）。其所答之开放问题：形式部分以律答之，'
          f'读何类以标明之读法答之。研究第 {N} 节。'})
(RECORDS / f'{RID}.json').write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# PF2's record: its next step restated
r2 = read(PF2)
assert r2['next_delta']['en'].startswith(f'Answered for P2 in {RID} (OC1)'), r2['next_delta']
r2['next_delta'] = {
    'en': f"Answered for P2 in {RID} (OC1, reviewed in OC2): read at one's own class with the split, which asks least "
          f"where a predicate decides the class, P2 asks exactly that what stays and what leaves follow every alike "
          f"occurrence that conditions anything. Reading P2 so is argued, not proved; whether actual agents meet it is a "
          f"correspondence; P4's question is put to philosophers.",
    'zh': f'P2 之问于 {RID}（OC1，OC2 复审）得答：读于自之类、取二分（一谓词判其类时所问最少），P2 所问恰为留者与出者皆随每一'
          f'有所缘之同类者。如此读 P2 乃论之，非证得；实际行动者是否合之为一对应；P4 之问交哲学家。'}
r2['history'].append({
    'en': f'25 October 2026: the answer to its next step reviewed independently (OC2): its formal part is answered by '
          f'laws, the choice of class by a labelled reading; study section {N}.',
    'zh': f'2026年10月25日：其下一步之答经独立审查（OC2）：形式部分以律答之，读何类以标明之读法答之；研究第 {N} 节。'})
(RECORDS / f'{PF2}.json').write_text(json.dumps(r2, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(oc1), '+', len(new), 'declarations; next step of', PF2, 'restated')
