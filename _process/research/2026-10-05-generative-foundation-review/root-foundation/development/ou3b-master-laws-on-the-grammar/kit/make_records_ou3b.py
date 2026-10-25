#!/usr/bin/env python3
"""OU3b record: write master-laws-on-the-grammar, citing every declaration of Becoming.GrammarLaws and every
representation or bridge declaration OU3b adds to the fourteen changed modules (asserted to be exactly the
declarations the landing's receipt has and main's receipt lacks), and the originals now proved from the grammar's
laws (statements unchanged). Asserts the receipt binds the current sources, every axiom report is empty and every
text field is within the schema-2 limits. Mirrors UE4's make_records_ue4.py.
usage (from the checkout root, after texts_ou3b.py): python3 -B <kit>/make_records_ou3b.py RECEIPT N"""
import datetime
import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
DEV = RF + 'development/ou3b-master-laws-on-the-grammar/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
CH1 = 'theories/becoming/chapters/01-ROOT.md'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'master-laws-on-the-grammar'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DAY_EN, DAY_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
CHANGED = ('Frame', 'Recurrence', 'Attraction', 'Laws', 'Mechanism', 'IdentificationRuns', 'GrammarRegularity',
           'GrammarScope', 'Regions', 'Admission', 'Flow', 'Amounts', 'InAmounts', 'Weightings')
MODULES = ('GrammarLaws',) + CHANGED


def lean(m):
    return f'{PKG}/Becoming/{m}.lean'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
old = json.loads(subprocess.run(['git', 'show', f'HEAD:{PKG}/becoming-verification.json'], cwd=ROOT,
                                capture_output=True, text=True, check=True).stdout)
names_of, old_names = {}, {}
for m in MODULES:
    module = 'Becoming.' + m
    assert core['source_sha256'][module] == sha(lean(m)), module
    mod = next(x for x in core['modules'] if x['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names_of[m] = {d['name'] for d in mod['declarations']}
    prev = next((x for x in old['modules'] if x['module'] == module), None)
    old_names[m] = {d['name'] for d in prev['declarations']} if prev else set()
assert not old_names['GrammarLaws']
added = {m: names_of[m] - old_names[m] for m in CHANGED}
assert all(not (old_names[m] - names_of[m]) for m in CHANGED), 'a declaration of a changed module is gone'
everything = set().union(*names_of.values())


def D(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in everything]
    assert not missing, missing
    return out


# (en, zh, declarations): the laws of Becoming.GrammarLaws and the bridges, each declaration once
groups = [
    ("Closure. Lying within a relation's closure (every region closed under it that holds x holds y) is being x or "
     "reached from x. The closure is reflexive, transitive, holds every step, grows with the relation, is symmetric "
     "for a symmetric one and closed, nothing within it bears the relation beyond it, and a region is x's closure "
     "exactly where it holds x, is closed and lies within it.",
     '闭包：在一关系之闭包内（凡对其封闭而含 x 之域皆含 y），即是 x 本身或为 x 所及。闭包自反、可传递、含每一步、随关系增大、'
     '对称关系下对称、自身封闭，其内者不以此关系及于其外；一域恰在含 x、封闭且在闭包内时为 x 之闭包。',
     D('«闭»', '«所闭»', '«所闭之自反»', '«所闭之传递»', '«缘在所闭»', '«所闭之闭»', '«所闭之单调»', '«所闭之对称»',
       '«所闭之界»', '«闭含所闭»', '«所闭之证»', '«闭而外则不所闭»', '«闭之及»', '«及之所闭»', '«所闭当且仅当同一或及»',
       '«及当且仅当一步而所闭»')),
    ("The frame's closed region and closure are the grammar's, by definition, and lying within a closure along a "
     "relation is being the start or reached on a line under the one of it.",
     '框架之封闭域与闭包即文法之所闭，依定义；沿一关系在闭包之内，即是起点本身或在其「一」之下的相续上为其所及。',
     D('closedUnder_iff_closed', 'withinClosure_iff_within', 'eq_or_reach_iff_reached')),
    ("Lemmas on numbers and lists that the line laws use, each proved once here, below the frame: pigeonhole with no "
     "decidability (a list holding the first l.length + 1 values of a sequence holds two at one place), the numbers "
     "other than a given one, splitting a joined list, a value put in front of a sequence, and totals that agree "
     "pointwise.",
     '诸线律所用的数与列表之引理，各于此（框架之下）证一次：无须可判定的鸽笼（持一序列前 l.length + 1 个值之列表在同一位持其二）、'
     '异于某一给定数之诸数、拆分相接之列表、置于序列之前的一值、逐点相同之总和。',
     D('GrammarLaws.length_insert', 'GrammarLaws.length_replicate', 'GrammarLaws.le_succ_cases',
       'GrammarLaws.gap_of_lt', 'GrammarLaws.mem_cons_split', 'GrammarLaws.skipAt', 'GrammarLaws.skipAt_ne',
       'GrammarLaws.skipAt_le', 'GrammarLaws.skipAt_lt', 'GrammarLaws.split_at_head', 'GrammarLaws.revisits_within',
       'GrammarLaws.split_append', 'GrammarLaws.prepend', 'GrammarLaws.total_congr')),
    ("Balance at one step. A perfect pairing of two finite lists under a relation conserves count; under the one it "
     "is exactly equal count, and under the empty relation equal count gives none. Lists paired from what comes in "
     "(before, given) to what goes on (after, taken) have after + taken = before + given, and every four numbers with "
     "that equation are lengths of unit lists so paired under the one. Near-definitional.",
     '一步之平衡：一关系下两有限列表之完全配对守其数；在「一」之下恰是等长，在空关系下等长不给配对。自所入（先前、所给）至所续'
     '（其后、所取）配对之列表有 后 + 取 = 先 + 给，凡合此式之四数皆为「一」下如此配对的单位列表之长。近乎定义。',
     D('«对»', '«对之长»', '«等长则一对»', '«一之对»', '«对之单调»', '«对之自反»', '«对之左插»', '«对则守数»',
       '«守数当且仅当可对»', '«等长而不对之例»')),
    ("Pairings read backward are pairings under the converse; they compose under the composite (under a transitive "
     "relation, under itself), join, and swap under a reflexive one; over a finite family the members' pairings "
     "gather; over a stretch, pairings at each step under R give one under R's closure; and the count law over a "
     "stretch is exactly a pairing of units over it.",
     '配对逆读即逆关系下之配对；配对在复合关系下可接（可传递关系下即在其自身之下），可并，在自反关系下可换；有限一族中诸成员之配对'
     '可聚；一段中每步于 R 下之配对给出 R 之闭包下的一个配对；一段上之守数律恰是该段上单位之配对。',
     D('«对之逆»', '«对之取»', '«对之接»', '«对之传»', '«对之并»', '«对之换»', '«聚»', '«对之族»', '«对之程»',
       '«聚之长»', '«程守数当且仅当可对»')),
    ("Balance represented in Flow, both ways: a flow balances exactly where, at each step and condition, the units "
     "of the level before and what is given pair one to one with those of the level after and what is taken; so at "
     "a family's members and over the family, the members' pairings gathered; under any relation a pairing gives "
     "balance. Represented, not derived: the consumers stay arithmetic.",
     'Flow 中平衡之表示，两向：一流平衡，恰在每步每条件上先前水平与所给之单位与其后水平与所取之单位一一配对；于一族之诸成员及整族'
     '亦然，诸成员之配对相聚；任一关系下之配对给出平衡。表示而不推出：其消费者仍用算术。',
     D('Flow.balances_iff_units', 'Flow.balances_of_matched', 'Flow.balancesOn_iff_units', 'Flow.over_iff_units',
       'Flow.BalancesOn.units_over')),
    ("Steps: the successor fixed, the predecessor fixed (merging nothing, a fixed successor read backward), n steps "
     "as the n-fold composite, reaching as some positive number of steps, steps composing, a loop of p steps a loop "
     "of every multiple; with the successor fixed at what x reaches, n steps from x lead to one place, and merging "
     "nothing, n steps to one place come from one.",
     '诸步：定后、定前（不并，即逆读之定后）、n 步即 n 重复合、及即若干正数步、步可接、p 步之环即其每一倍数步之环；于 x 所及处定后，'
     '自 x 之 n 步至于一处；不并时，至一处之 n 步来自一处。',
     D('«定后»', '«定前»', '«定后之逐点»', '«定前之逐点»', '«定前即逆之定后»', '«迭»', '«迭则及»', '«及即迭»',
       '«迭之接»', '«迭之周»', '«定后于»', '«定后则定后于»', '«定后于之后»', '«迭之定于»', '«迭之定»', '«迭之定前»')),
    ("Being drawn. For every relation, x is drawn in exactly where it reaches something that does not reach back, and "
     "with a successor that does not reach itself it is drawn. With the successor fixed at what x reaches, x reaching "
     "itself is not drawn, and with some successor drawn is not reaching itself; the global forms follow. "
     "Witnesses: neither hypothesis can be omitted, and the global one is more than the law uses.",
     '入：对每一关系，x 恰在及于不返者时入；有后而不自返则入。于 x 所及处定后，自返之 x 不入；有后时入即不自返；全局之形为推论。'
     '见证：二假设皆不可省，全局之假设多于此律所用。',
     D('«入»', '«入当且仅当有不返»', '«定后于环则所及皆返»', '«定后环则所及皆返»', '«定后于则返者不入»',
       '«定后则返者不入»', '«有后不返则入»', '«定后于有后则入当且仅当不返»', '«定后有后则入当且仅当不返»',
       '«无后者不入亦不返»', '«入而返之例»', '«非定后返而不入之例»')),
    ("Return. Along a line whose places a list holds, merging nothing at its places brings it back to its start "
     "within the list's length, by pigeonhole with no decidability, so its start reaches itself; with the successor "
     "fixed at what its start reaches, its last place does. On a listed carrier with a successor everywhere, merging "
     "nothing makes every place reach itself, and under a fixed successor the two are one.",
     '返：列表持其诸位之线，若于其诸位不并，则在列表之长内回到其始（无须可判定的鸽笼），故其始自返；于其始所及处定后，其末位自返。'
     '于有列表、处处有后之载体上，不并则每处自返，定后之下二者为一。',
     D('«遍后则有线»', '«线不并»', '«定前则线不并»', '«线不并则可退»', '«定前则线可退»', '«线则及»', '«线则所闭»',
       '«线有限不并则回»', '«线有限不并则返»', '«线有限定前则返»', '«定后于线有限则末返»', '«有限遍后定前则皆返»',
       '«定后于二返则不并»', '«皆返定后则定前»', '«有限遍后定后则定前当且仅当皆返»')),
    ("Return and being drawn read on the models, both ways: a process's return is reaching itself under its steps "
     "and merging nothing is its predecessor fixed; a law's orbit is its line, reaching is some orbit and return is "
     "reaching; absorbing is closed and being drawn is the grammar's. A total lossless process within a list "
     "returns everywhere.",
     '于模型上读返与入，两向：过程之返即在其步下自及，不并即其定前；一律之轨道即其线，及即某一轨道，返即及；吸收即封闭，'
     '入即文法之入。在一列表内、全而不并之过程处处返。',
     D('Branching.returns_iff_reaches', 'Branching.lossless_iff_fixedBefore', 'Branching.Lossless.returns_of_total',
       'Law.next_fixed', 'Law.next_total', 'Law.reaches_of_orbit', 'Law.reaches_iff_orbit', 'Law.returns_iff_reaches',
       'Law.lossless_iff_fixedBefore', 'Law.steps_orbit', 'Law.step_fixed', 'Law.absorbing_iff_closed',
       'Law.drawn_iff_drawnIn')),
    ("Rest. Where the steps of a line from T are steps of Q (no rise), and every course of Q steps then an F step (a "
     "least fall) ends from its place there, the F steps do not recur, as far as can be refuted and outright, with no "
     "decision and no choice. The ending is sufficient, not what rest is. Rest is not being drawn either way: a "
     "fixed point at rest and not drawn, a place drawn while its marked steps recur.",
     '止：一线自 T 起之步皆为 Q 之步（不升），且自其处每一「若干 Q 步继以一 F 步（最小之降）」之程皆尽，则 F 之步不复屡，'
     '就可驳而言及径直皆然，无判定无选择。尽为充分，非止本身。止非入，两向：不动点止而不入；一处入而其所标之步屡见。',
     D('«屡»', '«或屡»', '«屡则或屡»', '«线或在所闭»', '«尽则不或屡»', '«尽则不屡»', '«止而不入之例»', '«入而屡之例»')),
    ("Rest at amounts: within fewer than m least losses, every course of no rise then a least fall ends, so the law "
     "of rest over amounts is the grammar's; an amount's strict falls stopping is, by definition, their "
     "non-recurrence on the grammar, and falls whose courses end stop. No converse is established.",
     '量上之止：在少于 m 个最小损失之内，每一「不升继以最小之降」之程皆尽，故量上之止律即文法之止律；一量之严格下降停止，'
     '依定义即其在文法上不复屡；诸程皆尽之降停止。未立其逆。',
     D('Amounts.falls_end', 'Amounts.fallsStop_iff', 'Amounts.fallsStop_of_ends')),
    ("Lumping. E goes alike under R (R˘;E;R ⊆ E) where E-alike places go to E-alike ones. With the successor fixed "
     "where E leads, constancy is exactly going alike with a successor available there; the global forms are "
     "corollaries. A class going alike lies in its core, going alike keeps lines of every length alike, and a map's "
     "image has a fixed successor exactly where sameness under the map goes alike.",
     '归并：E 在 R 下同行（R˘;E;R ⊆ E），即 E 下相同者去往 E 下相同者。于 E 所至处定后，有常恰是同行而彼处有后可续；全局之形为推论。'
     '同行之类含于其核；同行使每一长度之线保持相同；映射之像定后，恰在其下之同同行。',
     D('«同行»', '«同行之逐点»', '«有常局定后则同行»', '«有常定后则同行»', '«有常则可续»', '«同行可续则有常»',
       '«同行遍后则有常»', '«局定后则有常当且仅当同行可续»', '«同行当且仅当有常»', '«类同行遍后则含于核»',
       '«同行之迭»', '«同行于迭»', '«像»', '«像定后当且仅当同行»')),
    ("Lumping read on the models: a determined process has a fixed successor at each move, a description goes alike "
     "under a process exactly where it goes alike at each move, and the image of a step along a projection is the "
     "grammar's image.",
     '于模型上读归并：确定之过程在每一移动上定后；一描述在一过程下同行，恰在其于每一移动上同行；一步沿投影之像即文法之像。',
     D('determined_iff_fixed', 'goAlikeUnder_iff_alike', 'image_step_iff')),
    ("Order. Widening of relations (including and exceeding) is irreflexive, one-way and transitive and excludes "
     "keeping the same and being mixed; keeping is pointwise equivalence and symmetric, mixed symmetric. Where "
     "inclusion or exceeding is decided both ways one of the four cases holds, and deciding it for every pair of "
     "relations is exactly excluded middle.",
     '序：关系之扩大（包含且逾越）非自反、单向、可传递，排除保持相同与相杂；保持相同即逐点等价且对称，相杂对称。包含或逾越两向'
     '可判定之处，四种情形之一成立；对每一对关系皆可判定，恰是排中律。',
     D('«逾»', '«广»', '«齐»', '«杂»', '«逾则不则»', '«广则不则»', '«广非自»', '«广不可逆»', '«广之传递»', '«齐即谓»',
       '«齐之对称»', '«杂之对称»', '«广则非齐»', '«广则非杂»', '«齐则非杂»', '«四比之周»', '«则逾之定当且仅当排中»')),
    ("Order read on the models, both ways: what a level path admits, and what a course admits among listed items, "
     "is a coreflexive relation (a partial identity), and the models' inclusion, exceeding, widening, keeping and "
     "mixing are the grammar's of these; widening over a listing goes one way and is transitive, from the "
     "grammar's laws.",
     '于模型上读序，两向：一水平路径所纳者，及一进程于所列诸项中所纳者，皆为余自反关系（部分同一）；模型之包含、逾越、扩大、'
     '保持与相杂即文法对之所言；列表上之扩大单向且可传递，由文法之律而得。',
     D('Web.admitted', 'Web.includes_iff', 'Web.exceeds_iff', 'Web.widens_iff', 'Web.keeps_iff', 'Web.mixed_iff',
       'Weighting.admittedOn', 'Weighting.includesOn_iff', 'Weighting.exceedsOn_iff', 'Weighting.widensOn_iff',
       'Weighting.mixedOn_iff', 'Weighting.WidensOn.not_reverse', 'Weighting.WidensOn.trans')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited))
own = names_of['GrammarLaws'] | set().union(*added.values())
assert set(cited) == own, (sorted(own - set(cited)), sorted(set(cited) - own))

# the originals now proved from the grammar's laws, statements unchanged (rule 9), named once more as one law
derived = D('WithinClosure.refl', 'WithinClosure.trans', 'WithinClosure.of_rel', 'WithinClosure.mono',
            'WithinClosure.symm', 'WithinClosure.not_rel', 'closedUnder_withinClosure', 'closure_iff_certified',
            'not_within_of_closed', 'withinClosure_iff_reached', 'withinClosure_of_line',
            'Law.lossless_iff_returns', 'Law.Lossless.returns', 'Law.lossless_of_returns', 'Law.Lossless.cancel',
            'Law.returns_of_reachable', 'Law.orbit_mul', 'Branching.Lossless.returns', 'Branching.Lossless.cancel',
            'Branching.Lossless.comes_back', 'Law.drawn_iff_not_returns', 'Law.Drawn.not_returns',
            'Amounts.rests_unrefuted', 'image_determined_iff', 'constant_of_goAlike', 'goAlike_of_constant',
            'Law.sameFuture_of_goAlike', 'Web.Includes.refl', 'Web.Includes.trans', 'Web.Includes.not_exceeded',
            'Web.Widens.not_reverse', 'Web.Widens.trans', 'Web.Widens.not_keeps', 'Web.Widens.not_mixed',
            'Web.Keeps.not_mixed', 'Web.Keeps.symm', 'Web.Mixed.symm',
            # the list lemmas Recurrence and Flow held, now aliases with the grammar's one proof
            'le_succ_cases', 'gap_of_lt', 'mem_cons_split', 'skipAt', 'skipAt_ne', 'skipAt_le', 'skipAt_lt',
            'split_at_head', 'revisits_within', 'total_congr')
assert not (set(derived) & own)
laws = [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in groups]
laws.append({'en': "The models' laws of closure, return, being drawn, rest at amounts, lumping and order are proved "
                   "from these in their own modules, each keeping its name and statement: board rule 9, the general "
                   "law below proving the special one, with no second proof left beside it. The list lemmas the "
                   "models held, pigeonhole among them, are now names of the grammar's one proof.",
             'zh': '模型上闭包、返、入、量上之止、归并与序之律，皆在其本模块中由此诸律证出，各保其名与陈述：即板规九，下层之通律证其特例，'
                   '旁无第二证明。模型原有之列表引理（鸽笼在内）今为文法唯一证明之别名。',
             'declarations': derived})
module_of = {}
for m in MODULES:
    for n in names_of[m]:
        module_of[n] = m
by_module = {m: sorted(n for n in set(cited) | set(derived) if module_of.get(n) == m) for m in MODULES}
assert all(by_module[m] for m in MODULES), [m for m in MODULES if not by_module[m]]

LIMITS = {'title': (100, 40), 'statement': (300, 150), 'laws': (420, 190), 'hypotheses': (420, 190),
          'does_not_show': (240, 110), 'validation_scope': (600, 260), 'next_delta': (400, 180),
          'correspondence': (1200, 500)}


over = []


def check(field, text):
    en, zh = LIMITS[field]
    if len(text['en']) > en:
        over.append((field, 'en', len(text['en']), en, text['en'][:50]))
    if len(text['zh']) > zh:
        over.append((field, 'zh', len(text['zh']), zh, text['zh'][:20]))


theorems = sum(1 for d in next(x for x in core['modules'] if x['module'] == 'Becoming.GrammarLaws')['declarations']
               if d['kind'] == 'theorem')
bridges = sum(len(v) for v in added.values())
record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'The master laws on the grammar', 'zh': '文法上的主律'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "The five master laws hold on the grammar for every carrier and relation: closure, finite runs (return, "
              "being drawn, rest), lumping and order, with the models' laws proved from them. Balance is represented "
              "both ways as pairings of unit lists, near-definitional, and not derived.",
        'zh': '五条主律对每一载体与关系在文法上成立：闭包、有限运行（返、入、止）、归并与序，模型之律由之证出。平衡以单位列表之配对两向表示，'
              '近乎定义，不推出。'},
    'laws': laws,
    'hypotheses': [
        {'en': "None beyond the grammar and the models' representation: every carrier and relation, counting entering "
               "only through finite lists as in the models. Each global form takes a fixed successor, merging "
               "nothing, a successor everywhere or a list of the carrier, as a corollary of a local form that asks it "
               "only where the proof uses it.",
         'zh': '除文法与诸模型之表示外不加前提：对每一载体与关系，计数只经有限列表而入，如诸模型。每一全局之形取定后、不并、处处有后或载体之列表，'
               '为一局部之形之推论，后者只在证明所用之处要求之。'},
        {'en': "The bridges read each anchor at its model's relation: a process's steps, a law's map, what a level "
               "path or a listed course admits as a coreflexive relation, a flow's levels, takes and gives as lists of "
               "units, and an amount's no rise and least fall as steps.",
         'zh': '诸桥于其模型之关系上读每一锚：过程之步、律之映射、水平路径或所列进程之所纳（作为余自反关系）、流之水平与取给（作为单位列表）、'
               '量之不升与最小之降（作为步）。'}],
    'does_not_show': [
        {'en': "That any model's relation is functional, total or listed: the models supply these, and the global "
               "forms take them as hypotheses.",
         'zh': '任一模型之关系为函数、为全或有列表：此由模型提供，全局之形以之为假设。', 'kind': 'scope'},
        {'en': "A derivation of balance: the pairing is supplied by the representation rather than drawn from "
               "the unfolding, and gives no trajectory of units; balance's consumers keep their arithmetic.",
         'zh': '平衡之推出：配对由表示给定，而非得自展开，不给出单位之轨迹；平衡之消费者仍用算术。', 'kind': 'non-implication'},
        {'en': "A converse of the law of rest, from rest along a line to the ending of the courses: none is "
               "established, and one would have to say which step relations it compares and on what logic.",
         'zh': '止律之逆，即由沿线之止至诸程之尽：未立；若立之，须说明所比之步关系及所用之逻辑。', 'kind': 'converse',
         'witness': 'Becoming.«尽则不或屡»'},
        {'en': "That rest is a case of being drawn, or being drawn a case of rest.",
         'zh': '止为入之一例，或入为止之一例。', 'kind': 'non-implication', 'witness': 'Becoming.«止而不入之例»'},
        {'en': "That a pairing under continuation adds anything to equal count, or the n-step law for lines of "
               "different lengths.",
         'zh': '续之下之配对于等长之外有所增益，或不同长度之线的 n 步之律。', 'kind': 'scope'},
        {'en': "The models' other laws on the grammar: they are proved on their models and not yet restated on it.",
         'zh': '诸模型之其他律在文法上：它们在其模型上证明，尚未在文法上重述。', 'kind': 'scope'}],
    'counterexamples': [
        {'path': lean('GrammarLaws'), 'detail': {
            'en': 'Equal count without a pairing: under the empty relation two one-place lists have one length and no '
                  'pairing («等长而不对之例»).',
            'zh': '等长而无配对：空关系下两个单位列表等长而无配对（«等长而不对之例»）。'}},
        {'path': lean('GrammarLaws'), 'detail': {
            'en': 'Drawn and returning where the successor is not fixed («入而返之例»); returning and not drawn with no '
                  'fixed successor anywhere («非定后返而不入之例»).',
            'zh': '后不定处既入且返（«入而返之例»）；处处不定后而返且不入（«非定后返而不入之例»）。'}},
        {'path': lean('GrammarLaws'), 'detail': {
            'en': 'Rest is not being drawn: a fixed point is at rest and not drawn («止而不入之例»), and along the '
                  'successor on the whole numbers 0 is drawn while its marked steps recur («入而屡之例»).',
            'zh': '止非入：不动点止而不入（«止而不入之例»）；沿自然数之后继，0 入而其所标之步屡见（«入而屡之例»）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, '
              f'{theorems} theorems in {len(names_of["GrammarLaws"])} declarations, and {bridges} representation and '
              f'bridge declarations in fourteen model modules, every one with an empty axiom report, all cited; every '
              f'theorem of the fourteen keeps its printed statement. Three independent read-only AI reviews, every '
              f'finding taken, in study section {N}; not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(names_of["GrammarLaws"])} 项声明中 '
              f'{theorems} 条定理，及十四个模型模块中 {bridges} 项表示与桥接声明，公理报告皆空，本记录全引；十四模块之每条定理其所印陈述不变。'
              f'三次独立只读 AI 审查，所见皆采，见研究第 {N} 节；未经人审。'},
    'next_delta': {
        'en': "A derivation of balance where a model's balance is read under a relation other than the one, pairings "
              "composing along a supplied conditioning; the models' other central laws restated on the grammar; a "
              "converse of the law of rest with the step relations it compares and its logic stated; review by a "
              "person.",
        'zh': '平衡之推出：在模型之平衡于「一」以外之关系下读出之处，配对沿给定之缘而接；诸模型其他核心律在文法上重述；止律之逆，'
              '须说明所比之步关系及其逻辑；人之审查。'},
    'correspondence': {
        'en': "Closure is the reflexive-transitive closure of a relation read as the least closed region; balance on "
              "the grammar is the cardinality reading of a natural-number equation by a bijection of finite lists; "
              "return and being drawn are the finite-state facts of a relation's paths, by pigeonhole; going alike "
              "(R˘;E;R ⊆ E) is the relational condition under which a quotient of a deterministic system is again "
              "one, as in lumpability; widening is strict inclusion with a witness. The readings are the AI's, in "
              "development/ou3b-master-laws-on-the-grammar (DESIGN, OU3b2-NOTES, AUDIT), with its three reviews.",
        'zh': '闭包即关系之自反传递闭包，读作最小封闭域；文法上之平衡，以有限列表之双射读自然数等式之基数；返与入即关系路径之有限状态事实（鸽笼）；'
              '同行（R˘;E;R ⊆ E）即确定系统之商仍为确定系统之关系条件，如可归并性；扩大即带见证之严格包含。读法皆 AI 之读，载于 '
              'development/ou3b-master-laws-on-the-grammar（DESIGN、OU3b2-NOTES、AUDIT），附其三次审查。'},
    'canonical_source': lean('GrammarLaws'),
    'aliases': ['The master laws on the grammar', '文法上的主律', 'master laws on the grammar', 'the five master laws on the grammar',
                'Becoming.«所闭当且仅当同一或及»', 'Becoming.«守数当且仅当可对»', 'Becoming.«尽则不或屡»',
                'Becoming.«像定后当且仅当同行»', 'Becoming.«广之传递»'],
    'dependencies': [
        {'id': 'continuation-relative-to-a-class', 'relation': 'formal-reuse',
         'detail': {'en': "Becoming.Grammar's relations, the one, reach, composition, the converse, constancy and the "
                          "core, in which every law here is stated.",
                    'zh': 'Becoming.Grammar 之关系、「一」、及、复合、逆、有常与核，此处诸律皆以之陈述。'}},
        {'id': 'generation-and-degeneration-at-two-grains', 'relation': 'formal-reuse',
         'detail': {'en': 'Ending on every branch («尽»), the premise of the law of rest.',
                    'zh': '诸支皆尽（«尽»），止律之前提。'}},
        {'id': 'levels-of-closure', 'relation': 'formal-reuse',
         'detail': {'en': "ClosedUnder and WithinClosure at the frame, now the grammar's «闭» and «所闭» by definition; "
                          "their laws proved from the grammar's.",
                    'zh': '框架之 ClosedUnder 与 WithinClosure，今依定义即文法之 «闭» 与 «所闭»；其律由文法之律证出。'}},
        {'id': 'the-continuation-condition-on-the-root', 'relation': 'formal-reuse',
         'detail': {'en': 'withinClosure_iff_reached and withinClosure_of_line, proved from «所闭当且仅当同一或及».',
                    'zh': 'withinClosure_iff_reached 与 withinClosure_of_line，由 «所闭当且仅当同一或及» 证出。'}},
        {'id': 'census-balance', 'relation': 'formal-reuse',
         'detail': {'en': 'balance_over_stretch_on, the one stretch balance, represented by «程守数当且仅当可对».',
                    'zh': 'balance_over_stretch_on，唯一之跨段平衡，以 «程守数当且仅当可对» 表示。'}},
        {'id': 'more-needs-renewers', 'relation': 'formal-reuse',
         'detail': {'en': 'Flow.Balances, Flow.BalancesOn and Flow.Balances.over, represented as pairings of units.',
                    'zh': 'Flow.Balances、Flow.BalancesOn 与 Flow.Balances.over，以单位之配对表示。'}},
        {'id': 'recurrence-without-premise', 'relation': 'formal-reuse',
         'detail': {'en': 'Law.lossless_iff_returns, revisits_within and the orbit laws, now proved from the line laws.',
                    'zh': 'Law.lossless_iff_returns、revisits_within 与诸轨道之律，今由诸线律证出。'}},
        {'id': 'where-a-run-goes-on', 'relation': 'formal-reuse',
         'detail': {'en': 'Branching.Returns and Branching.Lossless, read as reaching itself and the predecessor fixed.',
                    'zh': 'Branching.Returns 与 Branching.Lossless，读作自及与定前。'}},
        {'id': 'attraction-is-not-returning', 'relation': 'formal-reuse',
         'detail': {'en': "Law.Drawn and Law.drawn_iff_not_returns, now the grammar's «入» and its law.",
                    'zh': 'Law.Drawn 与 Law.drawn_iff_not_returns，今即文法之 «入» 及其律。'}},
        {'id': 'least-loss-rest', 'relation': 'formal-reuse',
         'detail': {'en': "Amounts.rests_unrefuted and Amounts.rests, now proved from «尽则不或屡» with Amounts.falls_end.",
                    'zh': 'Amounts.rests_unrefuted 与 Amounts.rests，今由 «尽则不或屡» 与 Amounts.falls_end 证出。'}},
        {'id': 'rest-exactly-where-falls-stop', 'relation': 'formal-reuse',
         'detail': {'en': "Amounts.FallsStop, by definition the grammar's non-recurrence of strict falls.",
                    'zh': 'Amounts.FallsStop，依定义即文法上严格下降之不复屡。'}},
        {'id': 'projection-carrying-a-law', 'relation': 'formal-reuse',
         'detail': {'en': 'GoAlikeUnder, image_determined_iff and carries_law_iff, now from «像定后当且仅当同行».',
                    'zh': 'GoAlikeUnder、image_determined_iff 与 carries_law_iff，今由 «像定后当且仅当同行» 而得。'}},
        {'id': 'rules-that-change-themselves-in-the-grammar', 'relation': 'formal-reuse',
         'detail': {'en': 'constant_of_goAlike and goAlike_of_constant, now from the lumping laws.',
                    'zh': 'constant_of_goAlike 与 goAlike_of_constant，今由归并之律而得。'}},
        {'id': 'four-cases-of-a-part', 'relation': 'formal-reuse',
         'detail': {'en': "Web.Includes, Web.Exceeds and Web.Admits, read as the grammar's comparisons of coreflexive "
                          "relations.",
                    'zh': 'Web.Includes、Web.Exceeds 与 Web.Admits，读作文法对余自反关系之比较。'}},
        {'id': 'widening-as-what-every-weighting-ranks', 'relation': 'formal-reuse',
         'detail': {'en': "Weighting.IncludesOn, ExceedsOn, WidensOn and MixedOn, read as the grammar's over the listed "
                          "items.",
                    'zh': 'Weighting.IncludesOn、ExceedsOn、WidensOn 与 MixedOn，读作文法于所列诸项上之比较。'}}],
    'related': [
        {'id': 'balance-from-conservation-along-a-relation',
         'detail': {'en': 'Transfers along a relation balance a step exactly where the total is conserved on every family '
                          'it closes: where a derivation of balance under a relation other than the one would begin.',
                    'zh': '沿一关系之转移平衡一步，恰在其所闭之每一族上总量守恒之处：于「一」以外之关系下推出平衡，当由此始。'}}],
    'references': (
        [{'path': lean(m), 'role': 'proof', 'declarations': by_module[m], 'sha256': sha(lean(m))} for m in MODULES]
        + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
           {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
           {'path': DEV + 'OU3b2-NOTES.md', 'role': 'integration', 'sha256': sha(DEV + 'OU3b2-NOTES.md')},
           {'path': DEV + 'AUDIT.md', 'role': 'integration', 'sha256': sha(DEV + 'AUDIT.md')},
           {'path': DEV + 'REVIEW-OU3b2.md', 'role': 'review', 'sha256': sha(DEV + 'REVIEW-OU3b2.md')},
           {'path': DEV + 'REVIEW-ASTRA-A.md', 'role': 'review', 'sha256': sha(DEV + 'REVIEW-ASTRA-A.md')},
           {'path': DEV + 'REVIEW-ASTRA-3.md', 'role': 'review', 'sha256': sha(DEV + 'REVIEW-ASTRA-3.md')},
           {'path': CH1, 'role': 'statement', 'sha256': sha(CH1)}]),
    'proof_bindings': [{'source': lean(m), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
                        'success_pointer': '/status', 'success_value': 'passed'} for m in MODULES],
    'history': [{'en': f'{DAY_EN}: added (OU3b, with OU3b-2 and OU3b-3), the five master laws on the grammar and '
                       f'the models\' laws proved from them, balance represented and not derived; three independent '
                       f'reviews taken; study section {N}.',
                 'zh': f'{DAY_ZH}：新增（OU3b，含 OU3b-2 与 OU3b-3），文法上之五条主律，模型之律由之证出，平衡表示而不推出；'
                       f'三次独立审查皆采；研究第 {N} 节。'}],
}
for field in ('title', 'statement', 'validation_scope', 'next_delta', 'correspondence'):
    check(field, record[field])
for field in ('laws', 'hypotheses', 'does_not_show'):
    for item in record[field]:
        check(field, item)
assert not over, '\n'.join(map(str, over))
for dep in record['dependencies'] + record['related']:
    assert (RECORDS / f'{dep["id"]}.json').exists(), dep['id']
taken = set()
for f in RECORDS.glob('*.json'):
    taken |= set(json.loads(f.read_text(encoding='utf-8')).get('aliases', []))
assert not (taken & set(record['aliases'])), taken & set(record['aliases'])
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations of its own and', len(derived), 'derived originals cited;',
      theorems, 'theorems in', len(names_of['GrammarLaws']), 'declarations of Becoming.GrammarLaws,', bridges, 'bridges')
