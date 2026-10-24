#!/usr/bin/env python3
"""GS1 records: write a-regularity-kept-and-changed and rules-that-change-themselves-in-the-grammar (together every
declaration Becoming.GrammarRegularity has), and add a related entry and a history line to closed-capture and to
projection-carrying-a-law. Adapted from WL3's make_records.py.
usage (from the checkout root, after texts_gs1.py): python3 -B make_records_gs1.py RECEIPT N

Every cited declaration is resolved against the receipt, the receipt must bind the module's current bytes, and the two
records together cite exactly the module's declarations."""
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
CH1 = 'theories/becoming/chapters/01-ROOT.md'
CH2 = 'theories/becoming/chapters/02-MAP.md'
SRC = f'{PKG}/Becoming/GrammarRegularity.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
MOD = 'Becoming.GrammarRegularity'


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


CC = 'ClosedCapture.'
kept_laws = [
    ("From a step continuing under the core of a relation, every occurrence its line under the core reaches has a "
     "successor under the core; a line along which the core is kept leaves its last occurrence continued under the "
     "class; the first occurrence of a line is continued, and its last is reached by a step from the first or from "
     "an occurrence the line reaches.",
     '自核下之一步起，其核下之续所及者皆于核下有后；守核之线，其末于类下仍有后；一线之始有后，其末由一步而至，此步出自其始或其所及者。',
     R('«守理则不穷»', '«守理之线不亡»', '«相续之始有后»', '«相续之末步»')),
    ("For every relation E, a step into an end under E leaves the core, and so does the last step of every line under E "
     "that ends; where E is a class, the two ends of such a line lie in different classes of the core.",
     '对一切关系 E：于 E 下入亡之一步离核，凡于 E 下终之线之末步亦然；E 为类时，此线两端在核之不同类中。',
     R('«亡前理变»', '«有亡之线末步离核»', '«有亡之线两端理异»')),
    ("Along a determined law's step a line under any relation never ends exactly where every step of the orbit "
     "continues under it, and under a class such a line keeps every configuration of the orbit alike with its start.",
     '沿一确定之法之步，任一关系下之续不尽，恰当其轨之每一步皆于此关系下续；于类下，此续使轨上每一状皆与其始同类。',
     R('Law.unending_iff_steps', 'Law.unending_alike')),
]
rules_laws = [
    ("A move of a process read as a relation: where every move is possible from every configuration, a process going "
     "alike by a map has the map's class constant under every move; where the process is determined, the converse; "
     "a determined process with every move possible goes alike exactly then.",
     '以动为际：凡动于凡状皆可行时，依象同行之变，其象之类于每一动下有常；变确定时其逆亦然；确定且凡动可行之变，依象同行恰当如此。',
     R('moveRel', 'constant_of_goAlike', 'goAlike_of_constant', 'goAlike_iff_constant')),
    ("For a state going on under a rule that itself goes on, the state's class is constant under every move, and is "
     "its own core under every move, exactly where the rule makes no difference to the state; where two rules take one "
     "state by one move to different states, the core of the state's class under that move tells them apart.",
     '状依一自行之则而行：状之类于每一动下有常、且于每一动下即其核，恰当则于状无别；二则以一动将一状引至不同之状时，此动下状之类之核分二构形。',
     R('adaptive_constant_iff', 'adaptive_core_iff', 'adaptive_core_apart')),
    ("In closed capture the class of share, rule and step count is constant under the two-level step along every "
     "schedule exactly where nothing beyond the share is read.",
     '闭合之捕获：份额、规则与步数之类于二层之步下、于每一读之时序皆有常，恰当份额之外无所读。',
     R(CC + 'constant_iff_unread')),
    ("Under the premises of lock_outlives_loss, from a locked start the line under being locked or not never ends "
     "along the joined two-level step, each step altering the loss; along a joined step whose reading favours at no "
     "loss past a bound, with a reading step past it, the line under favouring or not from a favouring start is not "
     "unending; in the witness the closed line never ends and the open one ends at its first step.",
     '于 lock_outlives_loss 之前提下，自锁住之始，锁与否之类下之续沿合并之二层之步不尽，其每一步于损下皆异；读于过界之损皆不偏向、'
     '且有读之步过界者，自偏向之始，偏向与否之类下之续非不尽；见证中闭者续不尽，开者于首步终。',
     R(CC + 'favouredAlike', CC + 'favouredAlike_class', CC + 'lockedAlike', CC + 'lockedAlike_class', CC + 'loss',
       CC + 'turn_fast', CC + 'orbit_paced', CC + 'loss_alters', CC + 'lock_line', CC + 'loss_ends_line',
       CC + 'Beyond.closed_line', CC + 'Beyond.open_line_ends')),
]
kept_names = set().union(*(set(l[2]) for l in kept_laws))
rules_names = set().union(*(set(l[2]) for l in rules_laws))
assert not (kept_names & rules_names)
assert kept_names | rules_names == names, (sorted(names - kept_names - rules_names),)

STD = ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional', 'omission-not-refutation']


def scope(n):
    return {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {MOD}, {THEOREMS} '
              f'theorems in {DECLS} declarations, every declaration with an empty axiom report; the checker verifies '
              f'core purity. This record cites {n} of them. Author review in study section {N}; not independently '
              f'reviewed.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{MOD}，{DECLS} 项声明中 {THEOREMS} 条定理，公理报告皆空；'
              f'检查器并核对核心纯净。本记录引其中 {n} 项。作者审查见研究第 {N} 节；未经独立审查。'}


def refs(decls, chapter):
    return [{'path': SRC, 'role': 'proof', 'declarations': sorted(decls), 'sha256': sha(SRC)},
            {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
            {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
            {'path': chapter, 'role': 'statement', 'sha256': sha(chapter)}]


BINDING = [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{MOD}',
            'success_pointer': '/status', 'success_value': 'passed'}]
HISTORY = {'en': f'24 October 2026: added (GS1), from the review of the root against its two source texts; study section {N}.',
           'zh': f'2026年10月24日：新增（GS1），出自根与其二篇来源之对照审查；研究第 {N} 节。'}

kept = {
    'schema_version': 2,
    'id': 'a-regularity-kept-and-changed',
    'title': {'en': 'A regularity kept and left along its own line', 'zh': '理之守与离'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "From a step under a relation's core, every occurrence its line under the core reaches is continued under "
              "it, so a kept regularity can always be kept; a line ends only by a step that leaves the core, its last "
              "step leaving it, found with no decision.",
        'zh': '自关系之核下之一步起，其核下之续所及者皆于核下有后，故所守之理总可再守；一线之终，必由离核之一步，其末步即离核，无须判定而得。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in kept_laws],
    'hypotheses': [{
        'en': 'No axiom and no premise beyond each law\'s own: for every carrier and relation; E a class only for the '
              'two ends of a line lying apart in the core; for the orbit laws a determined law (a function) and, for '
              'the second, a class. The general laws are corollaries of the root theorem, constancy never letting a '
              'continuation end, and ending not told apart by the core.',
        'zh': '不加公理，除各律所带者外不加前提：对一切载体与关系；唯「终线两端在核之不同类」设 E 为类；轨之律设一确定之法（函数），其二并设一类。'
              '诸一般之律是根定理、「有常则续不尽」与「亡于核下不变」之推论。'}],
    'does_not_show': [
        {'en': 'That every successor of an occurrence kept under the core keeps it: under the core a continuation '
               'exists, which in a branching net is not every branch.',
         'zh': '核下所守之事之每一后继皆守之：核下有续存在，分支之网中非每一枝皆然。', 'kind': 'scope'},
        {'en': 'Where a longer line first leaves its start\'s class of the core: the last step is found with no '
               'decision, the first only where the core is decided at each step («两端分则中有标»).',
         'zh': '较长之线首离其始之核类于何步：末步无须判定而得，首步唯于每步核之然否已定时由 «两端分则中有标» 得。', 'kind': 'non-implication'},
        {'en': 'Which class carries an actual pattern\'s regularity, or that a line ending is a loss.',
         'zh': '实有之样式之理在何类，或一线之终为损。', 'kind': 'correspondence'}],
    'counterexamples': [],
    'standard_boundaries': STD,
    'validation_scope': scope(len(kept_names)),
    'next_delta': {
        'en': 'The general laws moved into Becoming.Grammar if its owner agrees; the first step leaving the core placed '
              'where the core is decided along the line; the possibilities reading of the net, where the course taken '
              'can leave a core that an alternative keeps.',
        'zh': '诸一般之律经其主同意后移入 Becoming.Grammar；沿线核之然否已定时，述首离核之步；可能之网之读法下，所行之途可离核而另一途守之。'},
    'correspondence': {
        'en': 'The source texts\' "a regularity can be temporarily self-maintaining without being eternal" read in the '
              'grammar, one-history reading: what goes on for a while and then ends is a class that does not hold by '
              'itself, and its core always admits continuation; the core is the plan\'s 理 of the class.',
        'zh': '来源二篇之「理可暂自持而非永恒」于文法中读（一史之读法）：暂行而终者，是不自持之类；其核总容续；核即计划所言类之理。'},
    'canonical_source': SRC,
    'aliases': ['A regularity kept and left along its own line', '理之守与离', 'Becoming.«有亡之线末步离核»'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«根», «有常则续不尽», «有常则相续不尽», «亡于核下不变», «粗化», «及之传递».',
                    'zh': '«根»、«有常则续不尽»、«有常则相续不尽»、«亡于核下不变»、«粗化»、«及之传递»。'}},
        {'id': 'wen-in-the-grammar', 'relation': 'formal-reuse',
         'detail': {'en': 'Law.step, Law.step_hasSucc_iff, Law.line_on_orbit.',
                    'zh': 'Law.step、Law.step_hasSucc_iff、Law.line_on_orbit。'}}],
    'related': [
        {'id': 'rules-that-change-themselves-in-the-grammar',
         'detail': {'en': 'The same module reads two-level steps, closed capture among them, as models; the lock line uses '
                          'the orbit laws here.',
                    'zh': '同一模块以二层之步（含闭合之捕获）为模型；锁之续用此处轨之律。'}}],
    'references': refs(kept_names, CH1),
    'proof_bindings': BINDING,
    'history': [HISTORY],
}

rules = {
    'schema_version': 2,
    'id': 'rules-that-change-themselves-in-the-grammar',
    'title': {'en': 'Rules that change themselves, read in the grammar', 'zh': '自改其则者于文法中读'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "A move of a process is a relation; a state going on under a rule that changes itself has a class "
              "constant under every move exactly where the rule makes no difference to it; in closed capture the "
              "locked course's line goes on while every step alters the loss.",
        'zh': '变之一动为一际；依自改之则而行之状，其类于每一动下有常，恰当则于状无别；闭合之捕获中，锁住之途其续不尽而损每步皆异。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': sorted(d)} for en, zh, d in rules_laws],
    'hypotheses': [
        {'en': 'For moves: every move possible from every configuration (one direction), the process determined (the '
               'other).',
         'zh': '动之律：凡动于凡状可行（一向），变确定（另一向）。'},
        {'en': 'The adaptive process of Becoming.Mechanism: the state stepped by the rule and the move, the rule by '
               'the rule and the state.',
         'zh': 'Becoming.Mechanism 之自适之变：状依则与动而行，则依则与状而行。'},
        {'en': 'For the lock line, the premises of lock_outlives_loss (selection not lowering the share under a '
               'favouring rule, the rule read monotonically from the share, favouring kept upward, every step adding '
               'to the loss); for the line under favouring, those of turned_by_loss (any reading favouring at no loss '
               'past a bound, a reading step past it, a favouring start); discrete steps and natural-number losses.',
         'zh': '锁之续设 lock_outlives_loss 之前提（偏向之则下选择不降份额，则之读随份额单调，偏向向上保持，每步增损）；偏向之续设 '
               'turned_by_loss 之前提（读于过界之损皆不偏向，有读之步过界，始而偏向）；离散之步，损为自然数。'}],
    'does_not_show': [
        {'en': 'The lock and absorption laws, and readers formed from the share, in the grammar\'s own terms: two lock '
               'laws are used as lemmas, the rest not used.',
         'zh': '以文法自身之名述锁与吸回之律及由份额形成之读者：二条锁之律作引理被用，余者未用。', 'kind': 'scope'},
        {'en': 'Selection of selection as a law relating two grains: here the two levels are one law on one joint '
               'carrier, read at one grain.',
         'zh': '选择之被选择作为联系两种粒度之律：此处二层是一联合载体上之一法，于一种粒度读。', 'kind': 'non-implication'},
        {'en': 'A change of the law of change with no fixed law above it, or a space of rules not given with the carrier.',
         'zh': '无更上之定法之变法之变，或不随载体给出之规则之空间。', 'kind': 'scope'},
        {'en': 'That an actual rule is read from what it selects, or that the coordinate beyond the share, named the '
               'loss, is a loss to any formation.',
         'zh': '实有之则读自其所选，或份额之外名为损之坐标对任何形成为损。', 'kind': 'correspondence'}],
    'counterexamples': [],
    'standard_boundaries': STD + ['discrete-steps'],
    'validation_scope': scope(len(rules_names)),
    'next_delta': {
        'en': 'RuleCapture\'s lock and absorption laws stated on the grammar\'s classes; the reading formed from the '
              'share (both_reads) and readers formed from the selected (MA2) read in the grammar; selection of selection '
              'as a law of the coarse net at two grains.',
        'zh': '以文法之类述 RuleCapture 之锁与吸回之律；于文法中读由份额形成之读（both_reads）与由所选形成之读者（MA2）；以粗网之两种粒度述选择之被选择。'},
    'correspondence': {
        'en': 'The root chapter\'s open item on self-changing conditions, narrowed: a rule changing by a fixed law is '
              'stated by taking the rule into the occurrence, the carrier being a parameter; capture through the rule '
              'is a course whose line under being locked goes on while the coordinate it does not read alters at every '
              'step.',
        'zh': '根章关于自改之条件之未决项，范围收窄：依定法而变之则，取则入事即可述，载体为参数；经由规则之捕获，是锁之续不尽、而其所不读之坐标每步皆异之途。'},
    'canonical_source': SRC,
    'aliases': ['Rules that change themselves, read in the grammar', '自改其则者于文法中读',
                'Becoming.ClosedCapture.lock_line'],
    'dependencies': [
        {'id': 'closed-capture', 'relation': 'formal-reuse',
         'detail': {'en': 'Unread, loopPart, identifiesAlike_iff_unread, goAlike_of_unread, join, joinRead, Accrues, '
                          'Locked, lock_outlives_loss, turned_by_loss and the Beyond witness.',
                    'zh': 'Unread、loopPart、identifiesAlike_iff_unread、goAlike_of_unread、join、joinRead、Accrues、'
                          'lock_outlives_loss、turned_by_loss 与 Beyond 之见证。'}},
        {'id': 'projection-carrying-a-law', 'relation': 'formal-reuse',
         'detail': {'en': 'adaptive, adaptive_determined, adaptive_state_law_iff.',
                    'zh': 'adaptive、adaptive_determined、adaptive_state_law_iff。'}},
        {'id': 'wen-in-the-grammar', 'relation': 'formal-reuse',
         'detail': {'en': 'sameValue, sameValue_class, Law.step, Law.constant_iff_keeps.',
                    'zh': 'sameValue、sameValue_class、Law.step、Law.constant_iff_keeps。'}},
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': '«有常之逐点», «类有常当且仅当含于核».', 'zh': '«有常之逐点»、«类有常当且仅当含于核»。'}},
        {'id': 'a-regularity-kept-and-changed', 'relation': 'formal-reuse',
         'detail': {'en': 'Law.unending_iff_steps, Law.unending_alike.', 'zh': 'Law.unending_iff_steps、Law.unending_alike。'}}],
    'related': [],
    'references': refs(rules_names, CH2),
    'proof_bindings': BINDING,
    'history': [HISTORY],
}

for rec in (kept, rules):
    path = RECORDS / f"{rec['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

for rid, en, zh in (
        ('closed-capture',
         'Read in the grammar: the class of share, rule and step count constant along every schedule exactly where '
         'nothing beyond is read, and the locked line unending while the loss alters (GS1).',
         '于文法中读：份额、规则与步数之类于每一读之时序皆有常，恰当份额之外无所读；锁之续不尽而损每步皆异（GS1）。'),
        ('projection-carrying-a-law',
         'A system changing its own rule read in the grammar: the state\'s class constant under every move exactly where '
         'the rule makes no difference to it (GS1).',
         '改变自身规则之系统于文法中读：状之类于每一动下有常，恰当则于状无别（GS1）。')):
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    assert not any(r['id'] == 'rules-that-change-themselves-in-the-grammar' for r in d['related'])
    d['related'].append({'id': 'rules-that-change-themselves-in-the-grammar', 'detail': {'en': en, 'zh': zh}})
    d['history'].append({'en': f'24 October 2026, GS1: read in the grammar (record rules-that-change-themselves-in-the-grammar, '
                               f'study section {N}); no statement of this record changed.',
                         'zh': f'2026年10月24日，GS1：于文法中读（记录 rules-that-change-themselves-in-the-grammar，研究第 {N} 节）；本记录之陈述未变。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records:', kept['id'], len(kept_names), 'and', rules['id'], len(rules_names), 'of', DECLS,
      'declarations; closed-capture and projection-carrying-a-law noted')
