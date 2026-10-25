#!/usr/bin/env python3
"""PF record: write what-a-line-holds-and-a-regularity-takes-in (every declaration of Becoming.GrammarPath).
usage (from the checkout root, after texts_pf.py): python3 -B make_records_pf.py RECEIPT N"""
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
PHIL = RF + 'development/pf-path-and-crux/PHILOSOPHY-ROUND-1.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
PATH = f'{PKG}/Becoming/GrammarPath.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
RID = 'what-a-line-holds-and-a-regularity-takes-in'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.GrammarPath'] == sha(PATH)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.GrammarPath')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}


def B(*xs):
    out = ['Becoming.' + x for x in xs]
    assert set(out) <= names, sorted(set(out) - names)
    return out


def G(prefix):
    out = sorted(n for n in names if n.startswith('Becoming.' + prefix + '.'))
    assert out, prefix
    return out


laws = [
    ("Where a region, given by a decided predicate, is left under a class only into a set, a line under that class from "
     "inside the region to outside holds a member of that set alike to its start, and reaches it; where the class holds "
     "none of them alike to the start, nothing outside is reached.",
     '一域以可判之谓词给出，于一类下出此域唯经一集时，该类下自域内至域外之线，含该集中与其始同类之一员，且及之；该类若不使其中任何者与始同类，则域外无所及。',
     B('«所经必同»', '«所经不同则不及»')),
    ("A class holds a member's effects where everything the member conditions is alike to it. Under a constant class, "
     "everything downstream of anything alike to such a member is alike to it and lies on a line under the class from "
     "there, so a line that reaches it reaches all that follows; given constancy, holding a member's effects is "
     "equivalent to everything downstream of it being alike to it.",
     '一类持一员之所缘，谓凡此员所缘者皆与之同类。于有常之类下，凡与此员同类者之后皆与之同类，且自彼在该类下之线上，故及之之线及其后之一切；有常之下，持一员之所缘，等价于其后之一切皆与之同类。',
     B('«所缘同于»', '«常闭则所缘同类»', '«常闭则后皆续»', '«常闭则所及皆及»', '«常类之闭当且仅当后皆同类»',
       '«有常则同类者有所缘»')),
    ("A class is constant up to the net's end where whatever an alike occurrence conditions, this one conditions something "
     "alike to it unless it conditions nothing. Constancy gives it; a relation under which a line ends at an occurrence "
     "that still conditions something lacks it; under it the same laws hold, for a member that conditions something "
     "where the start is another occurrence alike to it.",
     '一类至网之终有常，谓凡同类者所缘者，此者亦缘一与之同类者，除非此者无所缘。有常则然；一线亡于仍有所缘之事之关系则否；其下同律亦成，若起点为与之同类之他事，则须此员有所缘。',
     B('«至终有常»', '«有常则至终有常»', '«亡而网续则不至终有常»', '«至终常闭则所缘同类»', '«至终常闭则后皆续»',
       '«至终常闭则所及皆及»', '«至终常类之闭当且仅当后皆同类»')),
    ("Neither premise can be dropped: where a member's line runs through a condition but its effects leave its class, a "
     "constant class holding the member with the condition does not reach what the condition feeds; where the class is "
     "not constant even up to the net's end, holding a member's effects need not make what follows them alike to it.",
     '二前提皆不可去：一员之线经一条件而其所缘出其类时，含此员与此条件之有常之类不及此条件所养者；类至网之终亦不有常时，持一员之所缘，其后者未必与之同类。',
     G('Unclosed') + G('Inconstant')),
    ("In a finite net with two families, each of two members in turn: the one is not constant; the class of one family, "
     "narrower than the one, is constant up to the net's end, takes in everything downstream of the family's first birth "
     "and reaches nothing of the other family; the organism's class is not constant up to the net's end.",
     '二家各有二员相继之有限之网中：一不有常；一家之类窄于一，至网之终有常，纳其家首生之后之一切，而不及他家；一员之类至网之终不有常。',
     G('FiniteFamilies')),
]
covered = set().union(*(set(d) for _, _, d in laws))
assert covered == names, sorted(names - covered)
record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'What a line must hold, and what a regularity takes in', 'zh': '线所必含，与理之所纳'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "A line under a class that must pass through a set holds a member of it alike to its start; under a class "
              "constant, or constant up to the net's end, everything downstream of a member whose effects the class "
              "holds lies on its line, and given the regularity that is equivalent to holding the effects; a relation "
              "under which a line ends where the net goes on is not constant up to the net's end.",
        'zh': '一类下必经一集之线，含该集中与其始同类者；于有常或至网之终有常之类下，类持其所缘之员之后皆在其线上，有此理则与持其所缘等价；网续而线亡之关系，不至网之终有常。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in laws],
    'hypotheses': [{
        'en': "No axiom and no premise beyond each law's own: for every carrier, relation and class; the region in the first "
              "law decided; the witnesses' nets supplied, with discrete steps and equality on their carriers.",
        'zh': '不加公理，除各律所带者外不加前提：对一切载体、关系与类；首律之域可判；见证之网为所给，设离散之步与载体上之相等。'}],
    'does_not_show': [
        {'en': "That a self's own line runs under a class constant up to the net's end, or that its class holds its effects "
               "(07 §4.6's P2 and P4: the de se question as two questions).",
         'zh': '一自之线在至网之终有常之类下，或其类持其所缘（07 §4.6 之 P2、P4：de se 之问分为二问）。',
         'kind': 'non-implication'},
        {'en': 'That a class holding only a member\'s intended effects can, or cannot, be constant up to the net\'s end.',
         'zh': '唯持一员所意之所缘之类，能否至网之终有常。', 'kind': 'non-implication'},
        {'en': 'That one\'s line runs through the conditions one affects (P3) for actual selves.',
         'zh': '实有之自，其线经其所影响之条件（P3）。', 'kind': 'correspondence'},
        {'en': 'Any duty or blame: holding one\'s effects is read as whose losses count, not what one answers for.',
         'zh': '任何义务或归责：持己之所缘读为谁之所失计入，非己之所当担。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarPath, every '
              f'declaration with an empty axiom report; this record cites all {len(names)} of its declarations. Independent '
              f'AI review and author review in study section {N}.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarPath，公理报告皆空；本记录引其全部 {len(names)} 项。'
              f'独立 AI 审查与作者审查见研究第 {N} 节。'},
    'next_delta': {
        'en': "A witness or law on whether a class holding a member's intended effects, and not its other effects, can be "
              "constant up to the net's end; SharedCondition.affecting_member_outside as a corollary of «所经不同则不及», "
              "with its owner.",
        'zh': '唯持一员所意之所缘、不持其余之类能否至网之终有常之见证或律；SharedCondition.affecting_member_outside 作为 «所经不同则不及» 之推论，由其主决。'},
    'correspondence': {
        'en': "07 §4.6's steps 3 and 4 in general form; its P2 read as constancy up to the net's end; holding one's effects "
              "its P4, read as whose losses count. A first round of philosophical work is in the PF study.",
        'zh': '07 §4.6 第三、四步之一般形式；其 P2 读为至网之终有常；持己之所缘为其 P4，读为谁之所失计入。哲学之初轮工作见 PF 之研究。'},
    'canonical_source': PATH,
    'aliases': ['What a line must hold, and what a regularity takes in', '线所必含，与理之所纳', 'Becoming.«常闭则后皆续»',
                'Becoming.«所经必同»', 'Becoming.«至终有常»'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«续», «相续», «及», «类», «有常», «有常之逐点», «亡», «线内同类», «一»; «所及» from the map.',
                    'zh': '«续»、«相续»、«及»、«类»、«有常»、«有常之逐点»、«亡»、«线内同类»、«一»；«所及» 出自图。'}},
    ],
    'related': [
        {'id': 'reach-through-a-shared-condition',
         'detail': {'en': 'Its affecting_member_outside is the first law\'s case.', 'zh': '其 affecting_member_outside 为首律之一例。'}},
        {'id': 'the-class-of-being-joined',
         'detail': {'en': 'ThirdFed there is a one-step instance of constancy; the second law adds what holding a member\'s effects carries on.',
                    'zh': '彼处 ThirdFed 为有常之一步之例；第二律加之以持一员之所缘所延续者。'}},
        {'id': 'reach-past-ones-own-end',
         'detail': {'en': 'A line past a member\'s end; here the class that carries it, in a finite net too.',
                    'zh': '过一员之亡而续之线；此处为载之之类，于有限之网中亦然。'}}],
    'references': [{'path': PATH, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(PATH)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': PHIL, 'role': 'provenance', 'sha256': sha(PHIL)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': PATH, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarPath',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'25 October 2026: added (PF), finishing 07 §4.6\'s steps 3 and 4; study section {N}.',
                 'zh': f'2026年10月25日：新增（PF），完成 07 §4.6 之第三、四步；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', record['id'], len(names))
