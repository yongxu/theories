#!/usr/bin/env python3
"""OC1 record: write constancy-read-at-a-members-class (the declarations Becoming.GrammarPath gained in OC1), and mark
the next step of what-leaves-a-class-follows-its-line answered. The records bound to the module are re-pointed with
repoint_oc1.sh.
usage (from the checkout root, after texts_oc1.py): python3 -B make_record_oc1.py RECEIPT N"""
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
REVIEW = RF + 'development/iv3-dependence/REVIEW-PF2.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PATH = f'{PKG}/Becoming/GrammarPath.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
RID = 'constancy-read-at-a-members-class'
PF, PF2 = 'what-a-line-holds-and-a-regularity-takes-in', 'what-leaves-a-class-follows-its-line'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def proof_declarations(rid):
    record = json.loads((RECORDS / f'{rid}.json').read_text())
    return set(next(r for r in record['references'] if r['role'] == 'proof')['declarations'])


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed' and core['source_sha256']['Becoming.GrammarPath'] == sha(PATH)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.GrammarPath')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
old = proof_declarations(PF) | proof_declarations(PF2)
assert old <= names, sorted(old - names)
new = names - old
B = 'Becoming.'
AT = [B + '«本类至终有常»', B + '«至终有常则本类至终有常»', B + '«至终有常之逐类»']
PATHLAWS = [B + '«本类常闭则所缘同类»', B + '«本类常闭则后皆续»', B + '«本类常闭则所及皆及»', B + '«本类常则闭当且仅当后皆同类»',
            B + '«本类出类随行»', B + '«本类出类随线»', B + '«出类不随则本类不至终有常»']
ENDS = [B + '«亡而网续则本类不至终有常»', B + 'FiniteFamilies.member_class', B + 'FiniteFamilies.member_not_constant_at',
        B + 'FiniteSharedCondition.member_class', B + 'FiniteSharedCondition.member_not_constant_at']
IDLE = [B + '«闭则外分无关»']
SPLIT = [B + '«外合不失本类之常»', B + '«二分»', B + '«二分为类»', B + '«异三则同»', B + '«本类之常至二分»',
         B + '«二分本类常当且仅当内外皆随»']
FINER = sorted(n for n in new if n.startswith(B + 'FinerOutside.'))
UNEVEN = sorted(n for n in new if n.startswith(B + 'UnevenOutside.'))
groups = [AT, PATHLAWS, ENDS, IDLE, SPLIT, FINER, UNEVEN]
assert FINER and UNEVEN and new == set().union(*map(set, groups)), sorted(new ^ set().union(*map(set, groups)))
laws = [
    ("Constancy up to the net's end asked only of the occurrences alike to a member is that condition at the member's "
     "class; constancy up to the net's end is that at every member's class.",
     '只问与一员同类者之至网之终有常，为于此员之类之至网之终有常；至网之终有常即于每一员之类皆然。', AT),
    ("Each law of the path that asks constancy up to the net's end holds at the member's class, and PF's and PF2's forms "
     "are its corollaries: what is alike to a member whose effects the class holds conditions only what is alike to it, "
     "everything downstream is on its line, what a line reaches it carries on, holding the effects is everything "
     "downstream being alike, and what leaves the class follows every alike step that goes on.",
     '此路诸问至网之终有常之律，皆于员之类成立，PF 与 PF2 之形为其推论：与类持其所缘之员同类者唯缘同类者，其下游皆在其线上，'
     '线所及者延至其后，持所缘即下游皆同类，出类者随每一同类而有所缘之步。', PATHLAWS),
    ("A line that ends while it still conditions something fails the condition at its class; the organism's class fails "
     "it at the first member in both finite witnesses.",
     '线亡而仍有所缘者，于其类不成此条件；两有限见证中，个体之类于首员处不成之。', ENDS),
    ("Where the class holds the effects of a member that conditions something, every class giving the member the same "
     "class gives the same verdict: how what lies outside is divided is idle.",
     '类持一有所缘之员之所缘时，凡予此员同一类者，判同：类外如何分无关。', IDLE),
    ("Merging what lies outside keeps the condition, so where a predicate decides the member's class the split of that "
     "class from the rest asks least; under the split the condition is that what stays and what leaves follow every "
     "alike step that goes on.",
     '合类外者不失此条件，故一谓词判员之类时，以此类与其余二分者所问最少；二分之下，此条件即留者与出者皆随每一同类而有所缘之步。',
     SPLIT),
    ("Dividing what lies outside more finely can break the condition; a witness where the split meets it without holding "
     "the member's effects.",
     '细分类外者可破此条件；见证中二分成之而不持员之所缘。', FINER),
    ("Constancy up to the net's end can fail under the split while the member's class keeps the condition and holds the "
     "member's effects, where alike occurrences outside differ in what they condition in it; a finer division is "
     "constant up to the net's end.",
     '类外同类者于员之类中所缘不一时，二分可不至网之终有常，而员之类仍成此条件、持其所缘；更细之分则至网之终有常。', UNEVEN),
]
record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': "Constancy read at a member's class, and how what lies outside it is divided",
              'zh': '于员之类之至终有常，与类外之分'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Constancy up to the net's end asked only at a member's class carries the path's laws and fails where a line ends while the net goes on; where the class holds the member's effects how what lies outside is divided is idle, and otherwise the split asks least.",
        'zh': '只问于一员之类之至网之终有常，足承此路诸律，线亡网续处不成；类持员之所缘时类外之分无关，否则二分所问最少。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in laws],
    'hypotheses': [{
        'en': "No axiom and no premise beyond each law's own: for every carrier, relation and class, the split given by a "
              "decided predicate; the witnesses' nets supplied, with discrete steps and equality on their carriers.",
        'zh': '不加公理，除各律所带者外不加前提：对一切载体、关系与类，二分由可判之谓词给出；见证之网为所给，设离散之步与载体上之相等。'}],
    'does_not_show': [
        {'en': "That P2 should be read at one's own class, or with the split: that is argued as a reading, not proved.",
         'zh': 'P2 应读于自之类、应取二分：此作为读法论之，非证得。', 'kind': 'non-implication'},
        {'en': "Which effects are one's own (the path's P4).",
         'zh': '何效为己之效（此路之 P4）。', 'kind': 'non-implication'},
        {'en': 'That the steps of actual agents each leave something outside the class of their line (a correspondence).',
         'zh': '实际行动者之每一步皆有出其线之类者（一对应）。', 'kind': 'non-implication'},
        {'en': 'That the split is the only division worth reading: finer divisions sort effects by kind, which other '
               'questions may need.',
         'zh': '二分为唯一可读之分：更细之分按种类分效，他问或需之。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarPath, every '
              f'declaration with an empty axiom report; this record cites the {len(new)} declarations OC1 added. PF\'s and '
              f'PF2\'s statements are unchanged, their proofs now through the forms at a member\'s class. Author review in '
              f'study section {N}; no independent review.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarPath，公理报告皆空；本记录引 OC1 所增之 {len(new)} 项。'
              f'PF 与 PF2 之陈述未变，其证明今经于员之类之形。作者审查见研究第 {N} 节；无独立审查。'},
    'next_delta': {
        'en': "A correspondence: whether the steps of actual agents each leave something outside the class of their line, so that P2 read at one's own class passes a self drawn by intention in actual nets. The crux, P4, is put to philosophers.",
        'zh': '一对应：实际行动者之每一步是否皆有出其线之类者，从而读于自之类之 P2 于实际之网中通过以所意划之自。关键 P4 交哲学家。'},
    'correspondence': {
        'en': "Read with the path's P2: a self's regularity of its own is constancy up to the net's end at its own class. "
              "Under the split of oneself from the rest it asks of a self that holds its effects only that its line go on "
              "at every alike step that goes on, and of a self drawn by intention, besides, that something leave at every "
              "alike step that goes on wherever one does; the reading is the AI's.",
        'zh': '以此路之 P2 读之：自之自有之理，即于其自之类之至网之终有常。以自与其余二分，于持其所缘之自，唯问其线于每一同类而有所缘之步皆续；'
              '于以所意划之自，另问凡有一步出类，则每一同类而有所缘之步皆有出者；读法为 AI 之。'},
    'canonical_source': PATH,
    'aliases': ["Constancy read at a member's class", '于员之类之至终有常', 'Becoming.«本类至终有常»',
                'Becoming.«二分本类常当且仅当内外皆随»'],
    'dependencies': [
        {'id': PF, 'relation': 'formal-reuse',
         'detail': {'en': "«至终有常», «所缘同于», the witnesses FiniteFamilies and FiniteSharedCondition, the module's "
                          "conventions; its laws under constancy up to the net's end are now corollaries of the forms "
                          "at a member's class.",
                    'zh': '«至终有常»、«所缘同于»、见证 FiniteFamilies 与 FiniteSharedCondition、本模块之约定；其至网之终有常下之律今为于员之类之形之推论。'}}],
    'related': [
        {'id': PF2,
         'detail': {'en': "Its laws are now corollaries of the forms at a member's class, and its next step (which class "
                          "P2 reads, and a two-block characterization with the blocks given decidably) is answered here.",
                    'zh': '其律今为于员之类之形之推论，其下一步（P2 读何类，及块可判给出时之二块刻画）于此得答。'}}],
    'references': [{'path': PATH, 'role': 'proof', 'declarations': sorted(new), 'sha256': sha(PATH)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'provenance', 'sha256': sha(REVIEW)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': PATH, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarPath',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'25 October 2026: added (OC1), answering 07 §4.6\'s Open item on which class P2 reads and how '
                       f'finely it divides what one leaves out; study section {N}.',
                 'zh': f'2026年10月25日：新增（OC1），答 07 §4.6 关于 P2 读何类、如何细分所遗于外者之开放问题；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# PF2's record: its next step is answered here
p2 = RECORDS / f'{PF2}.json'
r2 = json.loads(p2.read_text(encoding='utf-8'))
assert r2['next_delta']['en'].startswith('How finely the class P2 reads should divide what a self leaves out'), r2['next_delta']
r2['next_delta'] = {
    'en': f"Answered for P2 in {RID} (OC1): read at one's own class, with the split asking least, P2 asks of a class that "
          f"does not hold a member's effects only that what stays and what leaves follow every alike step that goes on. "
          f"What remains is P4's question, put to philosophers.",
    'zh': f'P2 之问于 {RID}（OC1）得答：读于自之类、二分所问最少时，P2 于不持员之所缘之类唯问留者与出者皆随每一同类而有所缘之步。'
          f'所余为 P4 之问，交哲学家。'}
r2['history'].append({'en': f'25 October 2026: next step answered by {RID} (OC1); the laws now corollaries of the forms at '
                            f'a member\'s class, statements unchanged; study section {N}.',
                      'zh': f'2026年10月25日：下一步由 {RID}（OC1）答；诸律今为于员之类之形之推论，陈述未变；研究第 {N} 节。'})
p2.write_text(json.dumps(r2, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(new), '; next step of', PF2, 'answered')
