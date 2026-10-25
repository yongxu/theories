#!/usr/bin/env python3
"""PF2 record: write what-leaves-a-class-follows-its-line (the declarations Becoming.GrammarPath gained in PF2). The
record what-a-line-holds-and-a-regularity-takes-in, bound to the same module, is re-pointed with tools/research/repoint.py.
usage (from the checkout root, after texts_pf2.py): python3 -B make_records_pf2.py RECEIPT N"""
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
PHIL = RF + 'development/pf-path-and-crux/PHILOSOPHY-ROUND-2.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PATH = f'{PKG}/Becoming/GrammarPath.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
RID = 'what-leaves-a-class-follows-its-line'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed' and core['source_sha256']['Becoming.GrammarPath'] == sha(PATH)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.GrammarPath')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
old = set(next(r for r in json.loads((RECORDS / 'what-a-line-holds-and-a-regularity-takes-in.json').read_text())['references']
               if r['role'] == 'proof')['declarations'])
assert old <= names
new = names - old
LAWS = ['Becoming.«出类随行»', 'Becoming.«出类随线»', 'Becoming.«出类不随则不至终有常»']
CLEAN = sorted(n for n in new if n.startswith('Becoming.CleanStep.'))
WAKE = sorted(n for n in new if n.startswith('Becoming.FiniteWake.'))
assert set(LAWS) <= new and CLEAN and WAKE and new == set(LAWS) | set(CLEAN) | set(WAKE), sorted(new)
laws = [
    ("Under a class constant up to the net's end, where a member conditions something not alike to it, every occurrence "
     "alike to the member that conditions anything conditions something alike to that effect and outside the class, "
     "every one on its line in particular. This is nearly the definition read at a member the class does not close.",
     '于至网之终有常之类下，一员缘一不与之同类者时，凡与此员同类而有所缘者，皆缘一与该者同类而在类外者，其线上之每一者尤然。此几即定义，读于类所不闭之员。',
     LAWS[:2]),
    ("Where an occurrence alike to such a member conditions something but nothing alike to its outside effect, the class "
     "is not constant up to the net's end; a witness.",
     '与此员同类之一事有所缘而无与其类外之效同类者时，该类不至网之终有常；有见证。',
     LAWS[2:] + CLEAN),
    ("In a finite net without cycles, a class holding a member and part of what follows it is constant up to the net's "
     "end though not constant, does not hold the member's effects, and something outside it follows every step of its "
     "line that goes on.",
     '于无环之有限之网中，含一员及其后之一部之类，至网之终有常而非有常，不持此员之所缘，其线上每一有所缘之步皆有类外者随之。',
     WAKE),
]
record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'What leaves a class follows its line', 'zh': '出类者随其线'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Under a class constant up to the net's end, what leaves the class at a member follows every alike step that "
              "goes on, and a step with nothing outside breaks constancy; such a class can leave a member's effects out.",
        'zh': '于至网之终有常之类下，一员处出类者随每一同类而有所缘之步，无类外者之步破其有常；此类可不持一员之所缘。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in laws],
    'hypotheses': [{
        'en': "No axiom and no premise beyond each law's own: for every carrier, relation and class; the witnesses' nets "
              "supplied, with discrete steps and equality on their carriers.",
        'zh': '不加公理，除各律所带者外不加前提：对一切载体、关系与类；见证之网为所给，设离散之步与载体上之相等。'}],
    'does_not_show': [
        {'en': 'That any effect is intended: the laws concern any class that does not hold a member\'s effects, and the agent '
               'reading is a reading.',
         'zh': '任何效为所意：诸律关乎任何不持一员所缘之类，以之读行动者为一读法。', 'kind': 'non-implication'},
        {'en': 'That what leaves the class is of one kind beyond what the class distinguishes, or forms a regularity of its own.',
         'zh': '出类者于类所别之外为同一种，或自成一理。', 'kind': 'non-implication'},
        {'en': 'That the necessary condition suffices for constancy up to the net\'s end where the class divides the outside '
               'finely.',
         'zh': '类细分其外时，此必要条件足以至网之终有常。', 'kind': 'converse'},
        {'en': 'Whether intention fixes whose losses count (the path\'s P4).',
         'zh': '所意能否定谁之所失计入（此路之 P4）。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarPath, every '
              f'declaration with an empty axiom report; this record cites the {len(new)} declarations PF2 added. Independent '
              f'AI review and author review in study section {N}.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarPath，公理报告皆空；本记录引 PF2 所增之 {len(new)} 项。'
              f'独立 AI 审查与作者审查见研究第 {N} 节。'},
    'next_delta': {
        'en': 'Whether a condition weaker than the counterpart for what the class holds suffices for constancy up to the net\'s '
              'end, for classes dividing the outside finely.',
        'zh': '类细分其外时，较弱于类所持者之对应条件之条件，能否足以至网之终有常。'},
    'correspondence': {
        'en': 'Read with a class drawn by what a member intends, the agential self of the path: it can pass P2, and then is '
              'never clean, so P2 does not exclude it and P4 carries the crux. A second round of philosophical work is in '
              'the PF2 study.',
        'zh': '以所意划之类读之，即此路之行动者之自：可过 P2，过则必不净，故 P2 不排除之，关键在 P4。哲学之第二轮工作见 PF2 之研究。'},
    'canonical_source': PATH,
    'aliases': ['What leaves a class follows its line', '出类者随其线', 'Becoming.«出类随线»', 'Becoming.«出类随行»'],
    'dependencies': [
        {'id': 'what-a-line-holds-and-a-regularity-takes-in', 'relation': 'formal-reuse',
         'detail': {'en': '«至终有常», «线内同类» through it, the module\'s conventions.', 'zh': '«至终有常»、经之之 «线内同类»、本模块之约定。'}}],
    'related': [
        {'id': 'continuation-relative-to-a-class',
         'detail': {'en': 'Constancy, read at a member the class does not close.', 'zh': '有常，读于类所不闭之员。'}}],
    'references': [{'path': PATH, 'role': 'proof', 'declarations': sorted(new), 'sha256': sha(PATH)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': PHIL, 'role': 'provenance', 'sha256': sha(PHIL)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': PATH, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarPath',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'25 October 2026: added (PF2), answering the path\'s Open item on a class that holds only intended '
                       f'effects; study section {N}.',
                 'zh': f'2026年10月25日：新增（PF2），答此路关于唯持所意之效之类之开放问题；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(new))
