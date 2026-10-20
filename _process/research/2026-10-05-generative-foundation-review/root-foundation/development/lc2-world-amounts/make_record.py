#!/usr/bin/env python3
"""Write LC2's record (rest-theorem-in-any-amounts) and update the records it continues (rest-from-a-finite-reading,
least-loss-rest), with history notes saying what changed:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after land_text.py)

Every declaration cited is resolved against the receipt's audited declarations, and the receipt must bind the
modules' current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = f'{RF}/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'rest-theorem-in-any-amounts'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. The rest theorem over any amounts, read finitely (LC2)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M), HEAD


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def names(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    return [d['name'] if isinstance(d, dict) else d for d in m['declarations']]


IN, LL = names('InAmounts'), names('LeastLoss')


def full(short):
    hits = [d for d in IN + LL if d == 'Becoming.' + short]
    assert len(hits) == 1, (short, hits)
    return hits[0]


def law(en, zh, decls):
    return {'en': en, 'zh': zh, 'declarations': [full(d) for d in decls]}


def T(en, zh):
    return {'en': en, 'zh': zh}


VALID = T(f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the declarations of '
          'Becoming.InAmounts and Becoming.LeastLoss have empty axiom reports; the checker verifies core purity. Built and '
          f'reviewed in one session, with no separate reviewer; author review and the literature check in study section {N}; '
          'not independently reviewed by a person.',
          f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.InAmounts 与 Becoming.LeastLoss 的声明公理报告为空；检查器核验核心的纯粹性。'
          f'在一个会话中构建与审查，没有另外的审查者；作者自审与文献检查见研究第 {N} 节；未经人独立审查。')
STD = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
       'omission-not-refutation']

L_TOTALS = ['Amounts.totalOf', 'Amounts.totalOf_le', 'Amounts.totalOf_add', 'Amounts.totalOf_swap', 'Amounts.le_totalOf',
            'Amounts.le_of_totalOf_le', 'Amounts.totalOf_support', 'Amounts.totalOf_whole']
L_STEP = ['World.InAmounts', 'World.InAmounts.BalancesOn', 'World.InAmounts.DissipatesOn', 'World.InAmounts.stock_still',
          'World.InAmounts.steady_of_stock_le', 'World.InAmounts.change_lowers']
L_REST = ['Amounts.rests_unrefuted_of_finite_reading', 'World.InAmounts.change_stops_unrefuted',
          'World.InAmounts.Enclosed.around_not_not', 'World.InAmounts.stock_census',
          'World.InAmounts.rests_unrefuted_enclosed', 'World.InAmounts.rests_unrefuted_covering',
          'World.InAmounts.rests_unrefuted_reading', 'World.InAmounts.rests_unrefuted']
L_WHOLE = ['World.wholeAmounts', 'World.balanced_whole', 'World.dissipative_whole', 'World.embodied_whole',
           'World.arisingEmbodied_whole', 'World.enclosed_whole', 'World.rests_unrefuted_enclosed_read',
           'World.rests_unrefuted_listed']
L_WIT = ['HalvingPass.balances', 'HalvingPass.dissipates', 'HalvingPass.embodied', 'HalvingPass.never_rests',
         'HalvingPass.levels_unlisted']

rec = {
    'schema_version': 2, 'id': RID,
    'title': T('The rest theorem in any amounts, read finitely', '任何量中的停息定理，有限地读取'),
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': T('Read a world\'s standings and exchanges in any amounts. Balanced and dissipated on, a family\'s total '
                   'falls strictly at every change of a level, with no least loss; where the census\'s total is read off '
                   'configurations a list holds, the rest theorem holds there.',
                   '以任何量读世界的水平与交换。平衡且被耗散时，一个族的总量在任何水平的每次变化处严格下降，不需要最小损失；'
                   '普查的总量读自一个列表所容纳的构形之处，停息定理在那里成立。'),
    'laws': [
        law('Totals over any amounts keep the order, split over addition and exchange two lists; where each member\'s '
            'amount b is within its a and the total of a is within the total of b, each member\'s a is within its b '
            '(no member strictly larger while the total is not); over a family and a part of it holding every member '
            'not within nothing the two totals are each within the other, as far as can be refuted.',
            '任何量上的总量保持序、对加法可分、可交换两个列表；每个成员的 b 在其 a 之内而 a 的总量在 b 的总量之内时，每个成员的 a 在其 b 之内'
            '（总量不严格大时没有成员严格大）；对一个族和它的一个容纳每个不在无之内的成员的部分，两个总量在可否证的范围内互在对方之内。',
            L_TOTALS),
        law('A world in amounts reads its standings, takes and gives in any amounts, its activity and what takes part '
            'its own. A family balances where each level after the step with what is taken is within the level before '
            'with what is given (no amount made), and is dissipated on where every relatum taking part gives the family '
            'no more than it takes and whatever gives back all it takes takes nothing. Then the family\'s total does not '
            'rise, and where it does not fall strictly no member\'s level changes either way; so every change lowers '
            'the total strictly, with no least loss.',
            '任何量中的世界以任何量读其水平、取用与给予，其活动与参与者是它自己的。一个族平衡：步后的水平加上所取者在步前的水平加上所给者之内'
            '（不产生量）；被耗散：每个参与者给族的不多于取自族的，而给回全部所取者什么也没取。于是族的总量不上升，而它不严格下降之处，'
            '没有成员的水平向任何一方变化；所以每次变化都严格降低总量，不需要最小损失。',
            L_STEP),
        law('Where the family\'s total is read off configurations a list holds from T on, that its changes stop cannot '
            'be refuted. In a world with a census of its active relata, all embodied, a balanced and dissipative flow, '
            'every step from T on enclosed, and the census\'s total read off configurations a list holds, that the '
            'world rests from some step on cannot be refuted: the enclosing family is widened, as far as can be refuted, '
            'to hold what is active before and after the step, and its total is the census\'s each way. The same holds '
            'where one family holds what is active from T on, balanced and dissipated on, with whatever arises embodied; '
            'it is enough that its levels are read off configurations a list holds, and in a finite world that its '
            'level functions are among those a list holds.',
            '一个族的总量从 T 起读自一个列表所容纳的构形之处，其变化停止不可否证。在一个有其活动关系项普查、全部具身、流平衡且耗散、'
            '从 T 起每步被围合、且普查的总量读自一个列表所容纳的构形的世界中，世界从某步起停息不可否证：围合的族在可否证的范围内被扩大，'
            '以容纳步前与步后活动者，其总量与普查的总量互在对方之内。一个族从 T 起容纳活动者、在其上平衡且被耗散、所生起者具身之处同样成立；'
            '只需其水平读自一个列表所容纳的构形，在有限世界中只需其水平函数在一个列表所容纳者之中。',
            L_REST),
        law('Every world is a world in whole-number amounts whose balance, dissipation, embodiment and enclosure are the '
            'world\'s own; so by the laws over any amounts a world meeting the premises of World.rests_unrefuted_enclosed '
            'whose census total is read off configurations a list holds rests, unrefuted, as does a finite world whose '
            'level functions a list holds. In whole numbers the reading is not needed: the least loss of one carries '
            'the whole-number laws.',
            '每个世界都是自然数量中的世界，其平衡、耗散、具身与围合就是世界自己的；所以由任何量上的规律，满足 World.rests_unrefuted_enclosed '
            '前提、且普查总量读自一个列表所容纳的构形的世界停息（不可否证），水平函数由一个列表容纳的有限世界也一样。在自然数中不需要这种读取：'
            '一个单位的最小损失承载了自然数的规律。',
            L_WHOLE),
        law('In dyadic amounts a standing halving as it passes between two relata meets every other premise of the '
            'covering form (balanced and dissipated on the pair, whatever arises embodied, every active relatum in the '
            'pair), and one relatum arises and the other ceases at every step; no list holds its levels.',
            '在二进量中，在两个关系项之间传递、每传一次减半的水平满足覆盖形式的其他每个前提（在这一对上平衡且被耗散，生起者具身，'
            '每个活动关系项都在这一对中），而每一步都有一个关系项生起、另一个止息；没有列表容纳它的水平。',
            L_WIT)],
    'hypotheses': [T('No axiom. Amounts are any Amounts (a cancellative preordered commutative monoid with nothing least). '
                     'Named where they enter: a list holding the configurations the total is read off (finiteness as a '
                     'list, nothing decided about the configurations), balance with no amount made, dissipation read as '
                     'whatever gives back all it takes takes nothing, embodiment, and a census with enclosure from T on or '
                     'one family covering activity. Equality of relata is not decided: membership in the enclosing family '
                     'is decided only as far as can be refuted.',
                     '不用公理。量是任何 Amounts（可消去的、有序的交换幺半群，无为最小）。在进入处列出：一个列表容纳总量所读自的构形（有限性作为列表，'
                     '构形上不作判定）、不产生量的平衡、读作给回全部所取者什么也没取的耗散、具身，以及从 T 起的普查与围合或一个覆盖活动的族。'
                     '关系项的相等不作判定：在围合族中的成员关系只在可否证的范围内判定。')],
    'does_not_show': [
        {**T('That the configurations of any actual system are finitely many at the resolution its total is read: '
             'finiteness is a premise (a list), not derived.',
             '任何实际系统在其总量被读取的分辨率下构形有限：有限性是前提（一个列表），不是推出的。'), 'kind': 'scope'},
        {**T('The other natural-number laws of flows, webs and worlds over any amounts (needs, support, gain, loops): '
             'only the rest theorem and the law of one step on which it turns are stated here.',
             '流、依存网与世界的其他自然数规律在任何量上的形式（所需、支持、增益、回路）：这里只陈述停息定理及其所依的一步之律。'),
         'kind': 'scope'},
        {**T('That a least loss is derived: where the reading is finite none is needed; where it is not, as in '
             'HalvingPass, the world need not rest.',
             '最小损失被推出：读取有限之处不需要它；不有限之处，如 HalvingPass，世界不必停息。'),
         'kind': 'non-implication'},
        {**T('How soon the world rests, or naming the step: that is a principle of omniscience '
             '(World.lpo_of_finite_ends), and the law bounds how often the total falls strictly by the list\'s length, '
             'not when.',
             '世界多快停息，或指名那一步：那是一个全知原理（World.lpo_of_finite_ends）；这条规律以列表的长度界定总量严格下降的次数，而不是何时。'),
         'kind': 'scope'}],
    'counterexamples': [{'path': src('InAmounts'), 'detail': T(
        'HalvingPass.never_rests: in dyadic amounts a standing halving as it passes between two relata is balanced and '
        'dissipated on the pair, whatever arises is embodied and every active relatum is in the pair, and one relatum '
        'arises and the other ceases at every step; HalvingPass.levels_unlisted: no list holds its levels.',
        'HalvingPass.never_rests：在二进量中，在两个关系项之间传递、每次减半的水平，在这一对上平衡且被耗散，生起者具身，每个活动关系项都在这一对中，'
        '而每一步都有一个生起、另一个止息；HalvingPass.levels_unlisted：没有列表容纳它的水平。')}],
    'standard_boundaries': STD,
    'validation_scope': VALID,
    'next_delta': T('The other laws of flows, webs and worlds over any amounts where a law needs more than the order of '
                    'its amounts (needs and support, gain, the doubling of loops); a finite reading derived for a '
                    'physical class of systems rather than supplied; an independent review.',
                    '流、依存网与世界的其他规律在任何量上的形式，凡规律需要量的序以外者（所需与支持、增益、回路的倍增）；为某类物理系统推出而非给出有限读取；独立审查。'),
    'correspondence': T('Termination of a finite-state system under a potential that never rises and falls strictly at '
                        'every change: a ranking function on a finite state space (Floyd 1967), the discrete LaSalle '
                        'principle with a Lyapunov function (LaSalle 1976; Mei and Bullo 2017, arXiv 1710.03710), the '
                        'potential arguments for chip-firing termination (Björner, Lovász and Shor 1991). The dense '
                        'counterexample is a discrete Zeno behaviour: infinitely many switches with summable losses. '
                        'Physically: a dissipative system with finitely many distinguishable states at the resolution '
                        'its total is read stops changing; one whose losses shrink without floor and whose states are '
                        'ever finer distinctions need not. Reading (the AI\'s): the rest theorem needs whole numbers only '
                        'where its total is read off configurations no list holds.',
                        '在一个永不上升、并在每次变化处严格下降的势下，有限状态系统的终止：有限状态空间上的排序函数（Floyd 1967），带 Lyapunov 函数的离散 '
                        'LaSalle 原理（LaSalle 1976；Mei 与 Bullo 2017，arXiv 1710.03710），筹码发射终止的势论证（Björner、Lovász 与 Shor 1991）。'
                        '稠密的反例是离散的 Zeno 行为：损失可求和的无穷多次切换。物理上：在其总量被读取的分辨率下只有有限多个可区分状态的耗散系统停止变化；'
                        '损失无下限地缩小、状态是越来越细的区分的系统则不必。读法（AI 的）：停息定理只在其总量读自没有列表容纳的构形之处需要自然数。'),
    'canonical_source': src('InAmounts'),
    'aliases': ['rest theorem in any amounts', '任何量中的停息定理', 'world in amounts', '任何量中的世界',
                'rest with no least loss for worlds', 'Becoming.World.InAmounts',
                'Becoming.World.InAmounts.rests_unrefuted_enclosed', 'Becoming.HalvingPass.never_rests'],
    'dependencies': [
        {'id': 'rest-from-a-finite-reading', 'relation': 'formal-reuse',
         'detail': T('Uses Amounts.rests_unrefuted_of_finite_reading, the unrefuted form of rest from a finite reading, '
                     'generalized here (the list held from T on, the amount\'s not rising only not refuted).',
                     '使用 Amounts.rests_unrefuted_of_finite_reading，由有限读取而停息的不可否证形式，此处推广（列表从 T 起容纳，量不上升只需不被否证）。'),
         'interface': {'output': T('Strict falls of an amount read off configurations a list holds stop, unrefuted.',
                                   '读自列表所容纳构形的量的严格下降停止，不可否证。'),
                       'input': T('The census\'s total, read off configurations a list holds, does not rise and falls '
                                  'strictly at every arising or ceasing.',
                                  '读自列表所容纳构形的普查总量不上升，并在每次生起或止息处严格下降。'),
                       'conditions': T('Balance, dissipation, enclosure, census and embodiment from T on.',
                                       '从 T 起的平衡、耗散、围合、普查与具身。'),
                       'evidence': src('LeastLoss')}},
        {'id': 'least-loss-rest', 'relation': 'formal-reuse',
         'detail': T('Uses the Amounts structure and its order laws, and the dyadic amounts and halving stock of '
                     'Becoming.LeastLoss for the witness.',
                     '使用 Amounts 结构及其序的规律，以及 Becoming.LeastLoss 的二进量与折半存量作为见证。'),
         'interface': {'output': T('Amounts that may be dense; a stock halving at every step.', '可稠密的量；每步减半的存量。'),
                       'input': T('Levels, takes and gives in any amounts; a standing halving as it passes.',
                                  '任何量中的水平、取用与给予；传递中减半的水平。'),
                       'conditions': T('None beyond the Amounts laws.', '除 Amounts 的规律外没有。'),
                       'evidence': src('Amounts')}}],
    'related': [
        {'id': 'rest-from-a-finite-reading', 'detail': T('There the step on which rest turns, read finitely; here the rest '
                                                         'theorem of worlds from it.',
                                                         '那里是停息所依的一步，有限地读取；这里是由它得出的世界的停息定理。')},
        {'id': 'least-loss-rest', 'detail': T('There rest needs a least loss over dense amounts; here a world in them rests '
                                              'read finitely, and need not otherwise.',
                                              '那里在稠密的量上停息需要最小损失；这里其中的世界在有限读取时停息，否则不必。')},
        {'id': 'space-and-its-parts', 'detail': T('The rest theorem there in whole numbers is the case this one reads in '
                                                  'any amounts.', '那里自然数中的停息定理，是这里在任何量中读出的情形。')}],
    'references': [
        {'path': src('InAmounts'), 'role': 'proof', 'declarations': [full(d) for d in L_TOTALS + L_STEP + L_REST[1:] + L_WHOLE + L_WIT],
         'sha256': sha(src('InAmounts'))},
        {'path': src('LeastLoss'), 'role': 'proof', 'declarations': [full('Amounts.rests_unrefuted_of_finite_reading')],
         'sha256': sha(src('LeastLoss'))},
        {'path': src('Space'), 'role': 'proof', 'sha256': sha(src('Space'))},
        {'path': src('Amounts'), 'role': 'proof', 'sha256': sha(src('Amounts'))},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [
        {'source': src(m), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
         'success_pointer': '/status', 'success_value': 'passed'} for m in ('InAmounts', 'LeastLoss')],
    'history': [T(f'20 October 2026: added (LC2), section 8.1 item 6: the rest theorem over any amounts where the levels '
                  f'are read finitely; study section {N}.',
                  f'2026年10月20日：新增（LC2），第 8.1 节第 6 项：水平有限读取之处任何量上的停息定理；研究第 {N} 节。')],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)


def update(rid, next_delta, note, extra_decls=()):
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    for b in d['proof_bindings']:
        if b['source'] == src('LeastLoss'):
            b['receipt'] = RECEIPT
    for r in d['references']:
        if r['path'] in (src('LeastLoss'), CHAPTER, STUDY):
            r['sha256'] = sha(r['path'])
        if r['path'] == src('LeastLoss') and extra_decls:
            r['declarations'] = r.get('declarations', []) + [full(x) for x in extra_decls]
    if not any(r['path'] == RECEIPT for r in d['references']):
        d['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
    if next_delta:
        d['next_delta'] = next_delta
    d['related'].append({'id': RID, 'detail': T('The rest theorem of worlds over any amounts, read finitely.',
                                                '任何量上世界的停息定理，有限地读取。')})
    d['history'].append(note)
    d['reviewed_at_utc'] = NOW
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('updated', rid)


update('rest-from-a-finite-reading',
       T('Recurrence\'s Marks law derived as a case (board rule 9) at that module\'s next change; an independent review.',
         '在 Recurrence 下一次改动时把其 Marks 规律作为特例推出（工作板规则 9）；独立审查。'),
       T(f'20 October 2026, LC2: the law generalized below (board rule 9): the list need hold the configurations only from '
         f'T on, and Amounts.rests_unrefuted_of_finite_reading states the stronger form, with the amount\'s not rising and '
         f'the falls only not refuted, from which rests_of_finite_reading follows; falls_within_reading takes the same '
         f'premises; the rest theorem of worlds over any amounts is built on it (record {RID}). The proof binding '
         f're-pointed to receipt {core_id} after reading the change; the statement is unchanged, the declarations gain '
         f'the unrefuted form; study section {N}.',
         f'2026年10月20日，LC2：规律向下推广（工作板规则 9）：列表只需从 T 起容纳构形，Amounts.rests_unrefuted_of_finite_reading 陈述更强的形式，'
         f'量不上升与下降都只需不被否证，rests_of_finite_reading 由之得出；falls_within_reading 取同样的前提；任何量上世界的停息定理建立其上'
         f'（记录 {RID}）。阅读改动后证明绑定改指回执 {core_id}；陈述不变，声明增加不可否证的形式；研究第 {N} 节。'),
       extra_decls=('Amounts.rests_unrefuted_of_finite_reading', 'Amounts.extend_falls', 'Amounts.from_start'))
update('least-loss-rest',
       T('The other laws of flows and worlds over any amounts where a law needs more than the order of its amounts; an '
         'independent review.',
         '流与世界的其他规律在任何量上的形式，凡规律需要量的序以外者；独立审查。'),
       T(f'20 October 2026, LC2: the next step this record named, the rest theorem over any amounts with a finite reading '
         f'as the premise, is stated (record {RID}); Becoming.LeastLoss changed only in the finite-reading law, generalized '
         f'below; this record\'s declarations and statements unchanged; the proof binding re-pointed to receipt {core_id} '
         f'after reading the change; study section {N}.',
         f'2026年10月20日，LC2：本记录所列的下一步，以有限读取为前提的任何量上的停息定理，已陈述（记录 {RID}）；Becoming.LeastLoss 只在有限读取的规律上改动，'
         f'向下推广；本记录的声明与陈述不变；阅读改动后证明绑定改指回执 {core_id}；研究第 {N} 节。'))
