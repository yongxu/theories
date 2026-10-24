#!/usr/bin/env python3
"""IV3b: extend the records self-concern-through-dependence (need over any courses with two readings; need on the base
and the Feeders witness) and what-self-concern-alone-ranks (the coupled ending ranked in one theorem). Each record
gains laws, its references are re-hashed to the new receipt, and it gets one history note.
usage (from the checkout root, after apply_text_b.py): python3 -B update_records_b.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
MODULE = 'Becoming.Weightings'
SOURCE = f'{PKG}/Becoming/Weightings.lean'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
assert f'## {N}. Need on the base, and the coupled ending ranked in one theorem (IV3b)' in (ROOT / STUDY).read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE = '23 October 2026'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


found = [m for m in R['modules'] if m['module'] == MODULE]
assert len(found) == 1 and not any(found[0]['axiom_dependencies'].values())
HAVE = {d['name'] for d in found[0]['declarations']}
assert R['source_sha256'][MODULE] == sha(SOURCE)


def need(names):
    for n in names:
        assert n in HAVE, n
    return names


def t(en, zh):
    return {'en': en, 'zh': zh}


B, W, FD = 'Becoming.', 'Becoming.Weighting.', 'Becoming.Feeders.'
PART = need([B + n for n in ['NeedsPart', 'NeedsSomePart', 'PartAlone', 'needsPart_iff_only', 'Marked']])
BASE = need([B + 'Flow.' + n for n in ['FedOnlyBy', 'DrawsPast', 'GivesWithin', 'needsSome_of_drawsPast',
                                       'needs_giver_iff_only']])
FEED = need([FD + n for n in ['withFirst', 'withSecond', 'web', 'mem_pair', 'fedOnlyBy_withFirst', 'fedOnlyBy_withSecond',
                              'drawsPast_withFirst', 'drawsPast_withSecond', 'partAlone', 'two_feeders']])
JOINED = need([B + 'Flow.coupled_ending_ranked_below'])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    f'significance review\'s dependence check. Author review in study sections 373 and {N}; not independently reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373 与 {N} 节；未经独立审查。')


def rehash(record, extra):
    for ref in record['references']:
        if ref['path'] == SOURCE and ref['role'] == 'proof':
            ref['declarations'] = sorted(set(ref['declarations']) | set(extra))
            ref['sha256'] = sha(SOURCE)
        elif ref['role'] == 'receipt':
            ref['path'] = RECEIPT
            ref['sha256'] = sha(RECEIPT)
        else:
            ref['sha256'] = sha(ref['path'])
    for binding in record['proof_bindings']:
        if binding['source'] == SOURCE:
            binding['receipt'] = RECEIPT


# ---- self-concern-through-dependence -------------------------------------------------------------------------
path = RECORDS / 'self-concern-through-dependence.json'
scope = json.loads(path.read_text(encoding='utf-8'))
assert len(scope['laws']) == 4 and not any(B + 'NeedsPart' in law['declarations'] for law in scope['laws'])
scope['laws'] += [
    {**t('Over possible courses of any type, a formation\'s continuation needs another\'s part where that part is taken '
         'on every possible course on which the first continues, the two read off the course. Where it needs the part '
         'of some member of a class and each member can take it alone, it needs a member\'s part exactly where that '
         'member is the only one; one reading for both is the marking case.',
         '在任何类型的可能进程上，一个构成的延续需要另一个的份，指在前者延续的每条可能进程上后者都尽其份，二者从进程读出。它需要某类中'
         '某成员的份、且每个成员都能单独尽之时，恰在某成员是唯一者时需要该成员的份；两者用同一读法，是标记的情形。'),
     'declarations': PART},
    {**t('On the base, over the flows with their webs that balance, in which only active formations give and only a '
         'class gives to a family of conditions, a formation drawing past the family\'s stock across a stretch has some '
         'member of the class giving to the family within it, and needs a given feeder\'s giving exactly where that '
         'feeder is the only one. Witness: two flows of one condition, each fed by one copy.',
         '在基底上，就平衡、只有活跃构成给予、且只有某一类给予某条件族的流及其依存网而言，在一段步上汲取超出该族存量的构成，在这段'
         '之内有该类的某成员给予该族；它恰在某供给者是唯一者时需要该供给者的给予。见证：同一条件的两个流，各由一个副本供给。'),
     'declarations': BASE + FEED},
]
scope['hypotheses'].append(t(
    'On the base: flows with their webs that balance and in which only active formations give; the class of possible '
    'feeders of a family supplied, and that each can feed it alone (PartAlone) supplied; a consumer drawing past the '
    'stock across a stretch longer than the stock.',
    '在基底上：平衡且只有活跃构成给予的流及其依存网；某条件族可能的供给者之类是给定的，每个能否单独供给（PartAlone）也是给定的；'
    '消耗者在长于存量的一段步上汲取超出存量。'))
scope['does_not_show'] += [
    {**t('Which flows are possible, or that a given feeder can feed a family alone: both are premises, supplied with the class of feeders.',
         '哪些流是可能的，或某供给者能单独供给某族：二者都是前提，与供给者之类一同给定。'), 'kind': 'scope'},
    {**t('Need without end: on the base a continuation is read as drawing past the stock within a stretch; that drawing '
         'without end needs giving without end holds in the core only doubly negated.',
         '无尽的“所需”：在基底上，延续读作在一段步之内汲取超出存量；无尽的汲取需要无尽的给予，在核心中只以双重否定成立。'),
     'kind': 'scope'},
]
assert len(scope['does_not_show']) <= 8
scope['counterexamples'].append({'path': SOURCE, 'detail': t(
    'Feeders: one condition, the user taking a unit at every step, fed in one possible flow by the first copy alone and '
    'in another by the second alone; the user needs some feeder\'s giving and neither feeder\'s (Feeders.two_feeders).',
    'Feeders：一个条件，使用者每步取一单位，在一个可能的流中只由第一个副本供给，在另一个中只由第二个供给；使用者需要某个供给者的'
    '给予，而两个都不需要（Feeders.two_feeders）。')})
scope['next_delta'] = t(
    'The possible flows read off a web, so that which feeders can feed a family alone is derived; graded need, under '
    'which a feeder is needed in degree and the class\'s continuation is stated; an independent review.',
    '从依存网读出可能的流，使哪些供给者能单独供给某族得以导出；分级的“所需”，使供给者按程度被需要、类的延续得以陈述；独立审查。')
scope['validation_scope'] = SCOPE
scope['reviewed_at_utc'] = NOW
rehash(scope, PART + BASE + FEED)
scope['history'].append(t(
    f'{DATE}: extended (IV3b): need stated for any courses with two readings, the marking case being the earlier need; '
    f'need on the base over balanced flows fed only from a class, with the Feeders witness; study section {N}.',
    f'2026年10月23日：扩展（IV3b）：“所需”对任意进程以两种读法陈述，先前的“所需”是标记的情形；基底上的“所需”，就只由某一类'
    f'供给的平衡流而言，附 Feeders 见证；研究第 {N} 节。'))
path.write_text(json.dumps(scope, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', scope['id'])

# ---- what-self-concern-alone-ranks ---------------------------------------------------------------------------
path = RECORDS / 'what-self-concern-alone-ranks.json'
order = json.loads(path.read_text(encoding='utf-8'))
assert len(order['laws']) == 3
order['laws'].append(
    {**t('Joined with coupled ending in one theorem: where a family of conditions with gated renewal is drawn beyond '
         'it over a stretch and every member of every later generation depends on the family, no later generation has a '
         'member, and the generations\' course is ranked below, by every order increasing in a standpoint\'s own '
         'continuation, every course agreeing with it up to the ending and adding to that continuation.',
         '与耦合的终结合为一个定理：某条件族的更新受门控、在一段步上被汲取超出更新，且其后每一代的每个成员都依存于该族时，其后各代都'
         '没有成员；各代的进程被每个在立场自身延续上递增的次序，排在每条终结前与之一致、并增加该立场延续的进程之下。'),
     'declarations': JOINED})
old = [i for i, item in enumerate(order['does_not_show']) if item['kind'] == 'correspondence']
assert len(old) == 1, old
order['does_not_show'][old[0]] = {**t(
    'That every member of every later generation depends on the coupled family: the joined theorem takes it as a '
    'premise, the one-copy case; with an independent member the comparison is mixed.',
    '其后每一代的每个成员都依存于耦合的族：合并的定理以此为前提，即只有一个副本的情形；有一个独立成员时，比较是混合的。'),
    'kind': 'scope'}
order['hypotheses'].append(t(
    'For the joined theorem: the premises of coupled ending (balance, only active formations giving, activity needing '
    'support, renewal gated on the family, excess over a stretch from a stock below it and the least need), every later '
    'member depending on the family, a course admitting only members of their generation, agreement before the ending.',
    '就合并的定理：耦合终结的前提（平衡、只有活跃构成给予、活动需要支持、更新以族为门、自低于其与最低需要之和的存量起一段步的超出），'
    '其后每个成员都依存于该族，进程只接纳其世代的成员，终结前一致。'))
order['related'] = [r for r in order['related'] if r['id'] != 'groups-whose-conditions-are-coupled']
order['dependencies'].append(
    {'id': 'groups-whose-conditions-are-coupled', 'relation': 'formal-reuse',
     'detail': t('The joined theorem uses that a member depending on a family drawn beyond its gated renewal leaves no '
                 'descendant (GroupEnding.Flow.family_childless).',
                 '合并的定理用到：依存于被汲取超出其门控更新之族的成员不留后代（GroupEnding.Flow.family_childless）。'),
     'interface': {'output': t('No member of a generation from the excess on that depends on the family leaves a descendant.',
                               '自超出起，依存于该族的世代成员都不留后代。'),
                   'input': t('Every later member coupled to the family: no later generation has a member.',
                              '其后每个成员都耦合于该族：其后各代都没有成员。'),
                   'conditions': t('Balance, only active formations giving, activity needing support, gated renewal, '
                                   'excess from a low stock; descent.',
                                   '平衡、只有活跃构成给予、活动需要支持、门控的更新、自低存量起的超出；世代承传。'),
                   'evidence': SOURCE}})
order['next_delta'] = t(
    'Graded orders, how much a standpoint\'s own continuation weighs, under which comparisons near an ending are decided; '
    'the joined theorem with some members independent of the family; an independent review.',
    '分级的次序（立场自身延续的权重多少），以裁定终结附近的比较；部分成员独立于该族时的合并定理；独立审查。')
order['validation_scope'] = SCOPE
order['reviewed_at_utc'] = NOW
rehash(order, JOINED)
order['history'].append(t(
    f'{DATE}: extended (IV3b): the ranking of the ending joined with coupled ending in one theorem, replacing the joining '
    f'by argument; groups-whose-conditions-are-coupled moved from related to a formal-reuse dependency; study section {N}.',
    f'2026年10月23日：扩展（IV3b）：终结的排序与耦合的终结合为一个定理，取代以论证连接；groups-whose-conditions-are-coupled '
    f'由相关移为形式复用的依赖；研究第 {N} 节。'))
path.write_text(json.dumps(order, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', order['id'])
