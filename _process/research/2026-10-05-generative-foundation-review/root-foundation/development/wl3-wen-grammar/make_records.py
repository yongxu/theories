#!/usr/bin/env python3
"""WL3 records: write wen-in-the-grammar (every declaration Becoming.GrammarCourse gained), and add a related entry and a
history line to wenli-on-the-spine.
usage (from the checkout root, after apply_text.py and the chapter rebuild): python3 -B make_records.py RECEIPT N

Every cited declaration is resolved against the receipt, the receipt must bind the module's current bytes, and the
record cites exactly the module's declarations."""
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
MAPPING = RF + 'development/wl3-wen-grammar/MAPPING.md'
WL = 'theories/becoming/chapters/WENLI-AND-BECOMING.md'
SRC = f'{PKG}/Becoming/GrammarCourse.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.GrammarCourse'] == sha(SRC)
module = next(m for m in core['modules'] if m['module'] == 'Becoming.GrammarCourse')
assert not any(module['axiom_dependencies'].values())
names = {d['name'] for d in module['declarations']}
THEOREMS, DECLS = module['theorems'], len(names)


def R(*short):
    out = ['Becoming.' + s for s in short]
    assert all(n in names for n in out), [n for n in out if n not in names]
    return out


laws = [
    ("A determined law's step is 缘 and a map's values a class: a relation is constant under the step exactly where "
     "the law keeps it, and a class keeps the values and carries the law exactly where it lies in the value class "
     "and is constant.",
     '法之步为缘，象之值同为类：一关系于步有常，恰当法守之；一类守值而载法，恰当它在值之类之内且有常。',
     R('Law.step', 'sameValue', 'sameValue_class', 'Law.step_hasSucc_iff', 'Law.constant_iff_keeps', 'Law.kept_along',
       'Law.keepsAndCarries_iff')),
    ("The same course through the map (文同) is the core of the value class under the law's step, and likeness by "
     "bisimulation in the frame by the map is that core; a class keeping the values and carrying the law contains "
     "the core exactly where it is the core, a symmetric constant relation inside a class containing its core "
     "exactly where it is the core.",
     '经象文同即法之步下值之类之核，象所示之系辞中之同即此核；守值载法之类含核，恰当它即是核：类内对称有常之关系含其核，恰当它即是核。',
     R('Law.core_is_sameFuture', 'Law.alike_iff_core', 'Law.coarsest_iff_core', 'contains_core_iff')),
    ("Under the value class a configuration's line ends exactly where the value changes at the next step, every "
     "line runs along the orbit, and the line never ends exactly where the course is constant from there; a step "
     "continues under the core exactly where the line under the value class never ends; the value class is "
     "constant exactly where it is its own core, and then a course keeping its value for one step keeps it for "
     "good.",
     '值之类下，一状之续于次步值变处终；凡续皆沿其轨；续不尽，恰当文自此恒定；一步于核下续至次步，恰当值之类下之续自此不尽；'
     '值之类有常，恰当它即其核，此时文守值一步则永守之。',
     R('Law.ends_iff_changes', 'Law.line_on_orbit', 'Law.reached_while_same', 'Law.unending_iff',
       'Law.continues_in_core_iff', 'Law.constant_iff_core', 'Law.stays_of_constant')),
    ("Two moments of a 文 are one state exactly where they lie in one class of the core of its value class along "
     "the steps, the steps being the successor law's; a state goes on as itself by the core's constancy; along a "
     "law's course the core on moments is the core on configurations; a 文 with a new value at every moment has "
     "no continuation under its core.",
     '步之相继即后继之法之步；文之二步为一状，恰当它们在沿步值之类之核之一类中；状依自身而行，由核之有常；沿法之轨，步之核即状之核；'
     '每步之值皆新之文，于其核下无续。',
     R('Steps.next_is_step', 'SameAhead.is_core', 'SameAhead.next_by_root', 'course_core_iff',
       'SameAhead.no_continuation')),
    ("With at most N states the core of a 文 is read off N + N - 1 steps, and at most N states is at most N "
     "classes of the core, each met before N; for a law on a listed world the core is read off N + N - 1 steps, N "
     "the list's length. Two 文 read as one net on the sum of their moments have two moments in one class of the "
     "core exactly where the courses agree from there; with at most N and N' states, exactly where they agree "
     "before N + N' - 1, a length that is exact.",
     '状不过 N 种之文，其核读自 N＋N－1 步，状不过 N 种即核不过 N 类、各见于 N 步之前；一列表尽其状之法，其核读自 N＋N－1 步（N 为列表之长）。'
     '二文合其步为一网，二步在核之一类中，恰当二文自此皆同；状各不过 N、N′ 种时，恰当 N＋N′－1 步前皆同，此长确切。',
     R('core_iff_below', 'statesBelow_iff_core', 'Law.core_iff_below', 'TwoCourses.next', 'TwoCourses.value',
       'TwoCourses.orbit_inl', 'TwoCourses.orbit_inr', 'TwoCourses.core_iff', 'TwoCourses.core_iff_bounded',
       'TwoCourses.core_exact')),
    ("In a world a list holds, a feature is learnable through a map exactly where configurations in one class of "
     "the core of the map's value class have features that agree from some step on; a feature whose class "
     "contains that core is learnable, and a core lies in another class's core exactly where it lies in that "
     "class.",
     '一列表尽其状时，一状值经一象可知，恰当象之值之类之核之一类中诸状，其状值自某步起逐步相同；状值之类含此核者可知；'
     '一核在另一类之核内，恰当它在该类之内。',
     R('Law.learnable_iff_core', 'Law.learnable_of_core_within', 'core_within_core_iff')),
]
cited = set().union(*(set(l[2]) for l in laws))
assert cited == names, (sorted(names - cited), sorted(cited - names))

record = {
    'schema_version': 2,
    'id': 'wen-in-the-grammar',
    'title': {'en': '文 in the grammar of continuation', 'zh': '文入续之文法'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Read with a law's step as 缘 and a map's values as a class, 文同 is the core of the value class and so is likeness by bisimulation; the coarsest value-keeping class is the core; the states of a 文 are its core along the steps; the bounded laws and learnability are restated through the core.",
        'zh': '以法之步为缘、象之值同为类而读：经象文同即值之类之核，系辞中之同即此核，守值之最粗之类即核，文之二步为一状恰当它们在其沿步之核之一类中；'
              '有界之律与可知经核而述。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(decls)} for en, zh, decls in laws],
    'hypotheses': [{
        'en': 'No axiom and no premise beyond each law\'s own: a determined law (a function) and a map; for the bounded '
              'laws at most N (and N\') states or a list holding every configuration closed under the law; for '
              'learnability a list holding every configuration and decided equality of the map\'s values. Equality '
              'of values is the model\'s commitment; discrete steps.',
        'zh': '不加公理，除各律所带者外不加前提：一确定之法（函数）与一象；有界之律设状不过 N（与 N′）种，或一列表尽其状而闭于法；可知设一列表尽其状，'
              '且象之值之同异定然否。值之相等是拟之承诺；离散之步。'}],
    'does_not_show': [
        {'en': 'That 文同 is a continuation: it is the core; continuation under the value class is one step that '
               'keeps the value, and continuation under the core is a course constant from there.',
         'zh': '文同是续：它是核；值之类下之续只是守值之一步，核下之续是自此恒定之文。', 'kind': 'non-implication'},
        {'en': 'Instances for classes that are not kernels of maps, for a relation that is not a function (the '
               'branching of a nondeterministic process), or for the two-valued class of Arising and Change, which '
               'compares by ↔ and would need propext to be a map\'s kernel.',
         'zh': '非象之核之类、非函数之关系（不定之变之分支），或 Arising 与 Change 之二值之类（以 ↔ 比较，作象之核须 propext）之例。',
         'kind': 'scope'},
        {'en': 'The prefix (往), the bounds as numbers, the extrapolations and learnability\'s "from some step on" in '
               'the grammar\'s own terms: the grammar has no counting or lists, and these are stated beside the core.',
         'zh': '以文法自身之名述往、界之数、知来与可知之「自某步起」：文法无计数与列表，这些在核旁陈述。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarCourse, '
              f'{THEOREMS} theorems in {DECLS} declarations, every declaration with an empty axiom report; the checker '
              f'verifies core purity. Author review in study section {N}; not independently reviewed.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarCourse，{DECLS} 项声明中 {THEOREMS} 条定理，'
              f'公理报告皆空；检查器并核对核心纯净。作者审查见研究第 {N} 节；未经独立审查。'},
    'next_delta': {
        'en': 'The two grammar laws (core_within_core_iff, contains_core_iff) moved into Becoming.Grammar if its owner '
              'agrees; a net of possibilities for the branching of a nondeterministic process; an independent review.',
        'zh': '二条文法之律（core_within_core_iff、contains_core_iff）经其主同意后移入 Becoming.Grammar；不定之变之分支作可能之网；独立审查。'},
    'correspondence': {
        'en': '文 and 文同 (D63) read in the grammar of the one-unfolding root: 文同 is the core (核) of the class of '
              'values, the 理 of that class in the plan\'s sense; constancy of a class for a law is bisimulation.',
        'zh': '文与文同（D63）于一元之根之文法中读：文同是值之类之核，即计划所言此类之理；一类于法有常即互模拟。'},
    'canonical_source': SRC,
    'aliases': ['文 in the grammar of continuation', '文入续之文法', 'Becoming.Law.core_is_sameFuture'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«续», «有常», «核», «根», «类有常当且仅当含于核», «有常之逐点», «及之传递».',
                    'zh': '«续»、«有常»、«核»、«根»、«类有常当且仅当含于核»、«有常之逐点»、«及之传递»。'}},
        {'id': 'the-split-that-makes-sense', 'relation': 'formal-reuse',
         'detail': {'en': 'Law.sameFuture_coarsest, Law.KeepsRelation, Law.KeepsAndCarries, sameAhead_orbit_iff.',
                    'zh': 'Law.sameFuture_coarsest、Law.KeepsRelation、Law.KeepsAndCarries、sameAhead_orbit_iff。'}},
        {'id': 'configurations-alike-by-relation', 'relation': 'formal-reuse',
         'detail': {'en': 'Law.alike_iff_sameFuture.', 'zh': 'Law.alike_iff_sameFuture。'}},
        {'id': 'identification-where-bounded', 'relation': 'formal-reuse',
         'detail': {'en': 'Identification.sameAhead_iff_below, bounded_agree, bounded_agree_exact, statesBelow_shift, '
                          'prefix_eq_iff and Law.sameFuture_iff_below.',
                    'zh': 'Identification.sameAhead_iff_below、bounded_agree、bounded_agree_exact、statesBelow_shift、'
                          'prefix_eq_iff 与 Law.sameFuture_iff_below。'}},
        {'id': 'learnable-through-a-map', 'relation': 'formal-reuse',
         'detail': {'en': 'Learnable.learnable_iff.', 'zh': 'Learnable.learnable_iff。'}}],
    'related': [
        {'id': 'wenli-on-the-spine',
         'detail': {'en': 'The 文 line whose sameness and states this record reads in the grammar.',
                    'zh': '本记录于文法中所读之文同与状，出自此线。'}}],
    'references': [
        {'path': SRC, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(SRC)},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': MAPPING, 'role': 'integration', 'sha256': sha(MAPPING)},
        {'path': WL, 'role': 'statement', 'sha256': sha(WL)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.GrammarCourse',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'23 October 2026: added (WL3), the 文 line joined to the one-unfolding root; study section {N}.',
                 'zh': f'2026年10月23日：新增（WL3），文之线接于一元之根；研究第 {N} 节。'}],
}
path = RECORDS / 'wen-in-the-grammar.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# --- wenli-on-the-spine: related and history
p = RECORDS / 'wenli-on-the-spine.json'
d = json.loads(p.read_text(encoding='utf-8'))
assert not any(r['id'] == 'wen-in-the-grammar' for r in d['related'])
d['related'].append({'id': 'wen-in-the-grammar',
                     'detail': {'en': '文同 and the states of a 文 read in the grammar of continuation: the core (WL3).',
                                'zh': '文同与文之状于续之文法中读：核（WL3）。'}})
d['history'].append({'en': f'23 October 2026, WL3: the 文 line joined to the one-unfolding root (record wen-in-the-grammar, '
                           f'study section {N}); the chapter gained a paragraph in §一 and a bullet in its head.',
                     'zh': f'2026年10月23日，WL3：文之线接于一元之根（记录 wen-in-the-grammar，研究第 {N} 节）；本章 §一 增一段，章首增一条。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records: wen-in-the-grammar written,', len(names), 'declarations cited; wenli-on-the-spine noted')
