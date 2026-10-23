#!/usr/bin/env python3
"""GS2 records: write the-continuation-condition-on-the-root and reach-past-ones-own-end (together every declaration
Becoming.GrammarScope has), and add a related entry and a history line to what-the-step-across-standpoints-reaches,
whose table carries ownClosure_unrestricted_iff. Adapted from GS1's.
usage (from the checkout root, after texts_gs2.py): python3 -B make_records_gs2.py RECEIPT N"""
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
SRC = f'{PKG}/Becoming/GrammarScope.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
MOD = 'Becoming.GrammarScope'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256'][MOD] == sha(SRC)
module = next(m for m in core['modules'] if m['module'] == MOD)
assert not any(module['axiom_dependencies'].values())
names = {d['name'] for d in module['declarations']}
THEOREMS, DECLS = module['theorems'], len(names)


def R(*short):
    out = ['Becoming.' + s for s in short]
    assert all(n in names for n in out), [n for n in out if n not in names]
    return out


# the record whose home is §4.2's table of what the step reaches, holding ownClosure_unrestricted_iff
OWN = 'what-the-step-across-standpoints-reaches'
assert 'Becoming.ownClosure_unrestricted_iff' in (RECORDS / f'{OWN}.json').read_text(encoding='utf-8')

E = 'LineOfDescent.Endless.'
L = 'LineOfDescent.Last.'
cond_laws = [
    ("Given a net R, a class E and each standpoint's center, the condition along the net is that every occurrence is "
     "reached on every center's line under E, and in families that every occurrence lies in every center's family "
     "under E; what a line reaches lies in its family, so the first gives the second.",
     '给定网 R、类 E 与各立场之中心：沿网之条件为凡事皆在每一中心于 E 下之线所及；族之条件为凡事皆在每一中心于 E 下之族中；'
     '线之所及皆在其族，故前者蕴族者。',
     R('«续无外»', '«族无外»', '«相续则同族»', '«所及则同族»', '«续无外则族无外»')),
    ("Under a coarser class every family holds the finer class's family, and the condition along the net or in "
     "families at a class gives it at every coarser class.",
     '较粗之类下，每一族含较细之类之族；条件于一类下（沿网或族）成立，则于每一较粗之类下亦成立。',
     R('«同族之粗化»', '«续无外之粗化»', '«族无外之粗化»')),
    ("Lying within a closure along a relation is being reached on a line under the one of that relation; so the "
     "condition held de se along a relation is exactly the root's condition at the one of that relation taken as the "
     "net, and on the own-closure reading of claims living significance follows, with S0, both neutralities and, "
     "where something lives, a seed.",
     '在一关系之闭包内，即在该关系之一下之线所及；故依一关系 de se 而持之条件，恰即以该关系为网、于其一下之根之条件；'
     '以自闭包读断言者，生之有义由之，并自之有义、二中立，有生则有种。',
     R('withinClosure_of_line', 'withinClosure_iff_reached', 'ownClosure_unrestricted_iff_noOutside',
       'premises_of_noOutside')),
    ("Along a net with no cycle the condition holds only with one center: two centers each reached from the other "
     "would lie on a cycle, and nothing conditions that center.",
     '无环之网中，此条件唯于一中心成立：二中心互相所及则成环，且无物为此中心之缘。',
     R('«续无外则同一中心»', '«续无外则中心无缘»')),
]
reach_laws = [
    ("On a line under a class L from a center, what continues under L an occurrence at which the line under a relation "
     "O ends is reached on the line under L and lies on no line under O from that occurrence; a class's core continues "
     "something exactly where some line under it goes on without end, so with no such line it continues nothing.",
     '自一中心于类 L 下之线上，凡于 L 下续一事、而某关系 O 下之线于此事终者，皆在 L 下之线所及，且不在自此事起之任何 O 下之线上；'
     '一类之核有续，恰当其下有一线不尽；无此线则核无续。',
     R('«过亡而续»', '«核有续当且仅当有不穷»', '«无不穷则核无续»')),
    ("In endless descent, each member young, then old, then the parent of the next, every occurrence conditions a "
     "successor, so the one is constant; its core continues through each birth, and its line under the core goes on "
     "for good from each birth, while the member's line ends at old age; with the first birth as the only center the "
     "condition holds under the one and fails under the member's class.",
     '无尽之传承（每一成员先少后老，老而为次一成员之亲）：凡事皆为一后继之缘，故一有常；其核于每一出生处续，自每一出生起核下之续不尽，'
     '而成员之线终于老；以首次出生为唯一之中心，一之下条件成立，成员之类下不成立。',
     R(E + 'Occ', E + 'step', E + 'member', E + 'member_class', E + 'total', E + 'member_ends', E + 'descent_constant',
       E + 'core_through_birth', E + 'descent_unending', E + 'descent_reaches_both', E + 'descent_reaches',
       E + 'descent_no_outside', E + 'member_line', E + 'member_outside')),
    ("In descent that ends, two members with the second childless, no line under any relation goes on without end, so "
     "no class's core continues anything, while the one reaches the second member past the first's end.",
     '有尽之传承（二成员，次者无子）：任一关系下皆无不尽之线，故无类之核有续；而一过首成员之终、及于次成员。',
     R(L + 'Occ', L + 'step', L + 'last_ends', L + 'never_unending', L + 'core_no_continuation', L + 'descent_past_end')),
]
cond_names = set().union(*(set(l[2]) for l in cond_laws))
reach_names = set().union(*(set(l[2]) for l in reach_laws))
assert not (cond_names & reach_names)
assert cond_names | reach_names == names, (sorted(names - cond_names - reach_names),)

STD = ['no-evaluation', 'formal-not-empirical', 'names-provisional', 'omission-not-refutation']


def scope(n):
    return {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {MOD}, {THEOREMS} '
              f'theorems in {DECLS} declarations, every declaration with an empty axiom report; the checker verifies '
              f'core purity. This record cites {n} of them. Author review in study section {N}.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{MOD}，{DECLS} 项声明中 {THEOREMS} 条定理，公理报告皆空；'
              f'检查器并核对核心纯净。本记录引其中 {n} 项。作者审查见研究第 {N} 节。'}


def refs(decls):
    return [{'path': SRC, 'role': 'proof', 'declarations': sorted(decls), 'sha256': sha(SRC)},
            {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
            {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
            {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}]


BINDING = [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{MOD}',
            'success_pointer': '/status', 'success_value': 'passed'}]
HISTORY = {'en': f'24 October 2026: added (GS2), from the review of the root against its two source texts, with SW\'s '
                 f'proposal 3 and PW\'s item 3; study section {N}.',
           'zh': f'2026年10月24日：新增（GS2），出自根与其二篇来源之对照审查，并取 SW 之提议三与 PW 之第三项；研究第 {N} 节。'}

cond = {
    'schema_version': 2,
    'id': 'the-continuation-condition-on-the-root',
    'title': {'en': 'The continuation condition on the root', 'zh': '根上之续存条件'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Stated on continuation relative to a class, the condition is that every occurrence lies within every "
              "center's continuing under the class; held de se along a relation, it is exactly the root's condition at "
              "the one of that relation taken as the net.",
        'zh': '以相对于类之续而述，条件为：凡事皆在每一中心于此类下之续中；依一关系 de se 而持，恰即以该关系为网、于其一下之根之条件。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in cond_laws],
    'hypotheses': [{
        'en': 'No axiom and no premise beyond each law\'s own: for every carrier, relation and class; the class and the '
              'standpoints\' centers supplied, not read off the net; for the de se instance a relation on formations '
              'taken as the net; for living significance, a reading of claims through the own closure (reads); for the '
              'one-center laws, a net with no cycle.',
        'zh': '不加公理，除各律所带者外不加前提：对一切载体、关系与类；各立场之中心给定；世界之例设形成上之一关系与有义之 de se 自闭包之读；'
              '生之有义设 Valuation.premises_of_unrestricted 之断言之读。'}],
    'does_not_show': [
        {'en': 'That any actual net meets the condition at any class, which class a center\'s own line runs under, or which '
               'occurrences are centers.',
         'zh': '实有之网于某类下满足此条件，中心之自线在何类下，或何事为中心。', 'kind': 'non-implication'},
        {'en': 'That the relations a self is drawn along run with 缘: feeding and influence run to conditions, so read along '
               'them the condition reaches what one depends on, not what follows.',
         'zh': '自所沿之关系与缘同向：馈与影响向条件而行，沿之读，条件及所依者，非所随者。', 'kind': 'correspondence'},
        {'en': 'The free significance parameter of the condition, on the root: it is not lifted, and its non-entailment '
               'holds by construction of that parameter.',
         'zh': '条件之自由之有义参数于根上：未提升，其不蕴涵由该参数之构造而成立。', 'kind': 'scope'},
        {'en': 'The warrant of the condition, or anything about C, which alone orders.',
         'zh': '条件之根据，或关于唯一排序之 C 之任何事。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': STD,
    'validation_scope': scope(len(cond_names)),
    'next_delta': {
        'en': 'The chapter\'s other theorems that take the condition stated as instances through the root\'s; the condition '
              'for many centers in families; which class a center\'s own line runs under, argued or modelled.',
        'zh': '本章以条件为前提之其他定理，经根之条件述为其例；多中心之族之条件；中心之自线在何类下，论证或建模。'},
    'correspondence': {
        'en': 'SW §3\'s structural reading (what counts for a center is what lies within its continuing along a '
              'relation) carried to the root; the source\'s "for anything, its continuation into the future has '
              'significance" read as "nothing lies outside every center\'s continuing".',
        'zh': 'SW §3 之结构之读（中心之所计，在其沿一关系之续中者）移于根上；来源之「凡物之续入未来皆有义」读为「凡中心之续无外」。'},
    'canonical_source': SRC,
    'aliases': ['The continuation condition on the root', '根上之续存条件', 'Becoming.«续无外»'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«同族», «粗化», «及之单调», «一».', 'zh': '«同族»、«粗化»、«及之单调»、«一»。'}},
        {'id': OWN, 'relation': 'formal-reuse',
         'detail': {'en': 'ownClosure_unrestricted_iff, selfAscribed, ownClosure.',
                    'zh': 'ownClosure_unrestricted_iff、selfAscribed、ownClosure。'}}],
    'related': [
        {'id': 'reach-past-ones-own-end',
         'detail': {'en': 'Which class a center\'s own line runs under, and when the dynamics fix it.',
                    'zh': '中心之自线在何类下，及动力何时定之。'}}],
    'references': refs(cond_names),
    'proof_bindings': BINDING,
    'history': [HISTORY],
}

reach = {
    'schema_version': 2,
    'id': 'reach-past-ones-own-end',
    'title': {'en': 'Past one\'s own end: the reach of a line under a class', 'zh': '过己之亡：一类下之线之所及'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "On a line under a class, what continues past the end of a finer line lies within the line's continuing; "
              "a class's core continues something exactly where some line under it goes on without end.",
        'zh': '一类下之线上，凡过较细之线之终而续者，皆在此线之续中；一类之核有续，恰当其下有一线不尽。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in reach_laws],
    'hypotheses': [{
        'en': 'No axiom and no premise beyond each law\'s own: for every carrier and relation; the witnesses commit to '
              'discrete steps and to equality on their carriers.',
        'zh': '不加公理，除各律所带者外不加前提：对一切载体与关系；见证设离散之步与载体上之相等。'}],
    'does_not_show': [
        {'en': 'That one\'s own line runs under a class coarser than one\'s organism: the reach is conditional on the '
               'class.',
         'zh': '自线在较己之生体为粗之类下：所及以类为条件。', 'kind': 'non-implication'},
        {'en': 'That any actual lineage is endless, or that its core continues through births.',
         'zh': '实有之传承无尽，或其核于出生处续。', 'kind': 'correspondence'},
        {'en': 'A class narrower than the one and wider than the member\'s whose core goes on: both models use the one.',
         'zh': '较一为窄、较成员之类为宽、而其核不尽之类：二模型皆用一。', 'kind': 'scope'},
        {'en': 'That a class whose core does not carry a step past one\'s end is thereby chosen.',
         'zh': '其核不载过己之终之一步之类，即为所择。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': STD + ['discrete-steps'],
    'validation_scope': scope(len(reach_names)),
    'next_delta': {
        'en': 'A model of an actual lineage or practice with its class read off the net; the step of invariance asked of '
              'classes: whether a class narrower than the one is a center\'s own.',
        'zh': '实有之传承或实践之模型，其类读自网；以类问不变之步：较一为窄之类是否中心之所自有。'},
    'correspondence': {
        'en': 'PW §4-§5: the self as a line, and whether a living line\'s core is wider than its organism; made exact here, '
              'not answered: the core carries a line past a member\'s end only where its line from there never ends, both '
              'cases witnessed with the one.',
        'zh': 'PW §4-§5：自为一线，及生之线之核是否宽于其生体；此处使之精确而未答：核载线过成员之终，唯于其自此不尽处；二情形以一为见证。'},
    'canonical_source': SRC,
    'aliases': ['Past one\'s own end', '过己之亡', 'Becoming.«过亡而续»'],
    'dependencies': [
        {'id': 'a-regularity-kept-and-changed', 'relation': 'formal-reuse',
         'detail': {'en': '«守理则不穷», «相续之始有后».', 'zh': '«守理则不穷»、«相续之始有后»。'}},
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«有常», «核», «类有常当且仅当含于核», «一为类».', 'zh': '«有常»、«核»、«类有常当且仅当含于核»、«一为类»。'}},
        {'id': 'generation-and-degeneration-at-two-grains', 'relation': 'formal-reuse',
         'detail': {'en': '«所及», «相续之续».', 'zh': '«所及»、«相续之续»。'}}],
    'related': [
        {'id': 'the-continuation-condition-on-the-root',
         'detail': {'en': 'The condition on the root, of which this is the question of the class.',
                    'zh': '根上之条件；此为其类之问。'}}],
    'references': refs(reach_names),
    'proof_bindings': BINDING,
    'history': [HISTORY],
}

for rec in (cond, reach):
    path = RECORDS / f"{rec['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

p = RECORDS / f'{OWN}.json'
d = json.loads(p.read_text(encoding='utf-8'))
d.setdefault('related', [])
assert not any(r['id'] == 'the-continuation-condition-on-the-root' for r in d['related'])
d['related'].append({'id': 'the-continuation-condition-on-the-root',
                     'detail': {'en': 'The de se own-closure condition read on the root: the root\'s condition at the one of '
                                      'the relation (GS2).',
                                'zh': 'de se 之自闭包之条件于根上读：根于该关系之一下之条件（GS2）。'}})
d['history'].append({'en': f'24 October 2026, GS2: read on the root (record the-continuation-condition-on-the-root, study '
                           f'section {N}); no statement of this record changed.',
                     'zh': f'2026年10月24日，GS2：于根上读（记录 the-continuation-condition-on-the-root，研究第 {N} 节）；本记录之陈述未变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records:', cond['id'], len(cond_names), 'and', reach['id'], len(reach_names), 'of', DECLS, '; related on', OWN)
