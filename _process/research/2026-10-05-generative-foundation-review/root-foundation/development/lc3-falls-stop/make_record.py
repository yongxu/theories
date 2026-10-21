#!/usr/bin/env python3
"""Write LC3's record (rest-exactly-where-falls-stop) and update the records it continues (rest-theorem-in-any-amounts,
rest-from-a-finite-reading, least-loss-rest), with history notes saying what changed:
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
RID = 'rest-exactly-where-falls-stop'
R2 = 'rest-theorem-in-any-amounts'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. One rest theorem over any amounts, exactly where the total stops falling (LC3)'
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

L_ONE = ['Amounts.FallsStop', 'Amounts.fallsStop_congr', 'Amounts.not_not_totalOf_le',
         'World.InAmounts.change_stops_iff']
L_REST = ['World.InAmounts.rests_unrefuted_of_stops', 'World.InAmounts.Enclosed.around_census',
          'World.InAmounts.census_still', 'World.InAmounts.census_falls',
          'World.InAmounts.rests_unrefuted_enclosed_of_stops', 'World.InAmounts.stops_of_reading']
L_AMTS = ['Amounts.NoEndlessFall', 'Amounts.EndlessFall', 'Amounts.FallsAtLeast',
          'Amounts.noEndlessFall_of_fallsAtLeast', 'Amounts.whole_fallsAtLeast', 'Amounts.whole_noEndlessFall',
          'Halving.falls_back', 'Halving.endless', 'Halving.no_least_fall', 'Layered.endless', 'Layered.fallsAtLeast',
          'World.InAmounts.rests_unrefuted_enclosed_of_noEndlessFall']
L_WHOLE = ['World.rests_unrefuted_whole', 'World.rests_unrefuted_enclosed_whole']
L_PASS = ['Pass.amounts', 'Pass.dissipative', 'Pass.census', 'Pass.embodied', 'Pass.balanced', 'Pass.enclosed',
          'Pass.never_rests', 'Pass.endless_keeps_from_rest', 'Pass.levels_unlisted', 'Amounts.totalOf_single']
L_ALL = ['Amounts.WorldsRest', 'Amounts.worldsRest_of_noEndlessFall', 'Amounts.not_endlessFall_of_worldsRest',
         'Amounts.whole_worldsRest', 'Halving.worlds_need_not_rest', 'Layered.worlds_need_not_rest']

rec = {
    'schema_version': 2, 'id': RID,
    'title': T('Rest exactly where the total stops falling', '恰在总量停止下降之处停息'),
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': T('Over any amounts, a balanced, dissipated family stops changing exactly where its total stops '
                   'falling, and a world rests where its census total does. A least fall in Archimedean amounts or a '
                   'finite reading gives this; along an amount falling at every step a world never rests.',
                   '在任何量上，平衡且被耗散的族恰在其总量停止下降之处停止变化，普查总量停止下降之处世界停息。'
                   '阿基米德量中的最小下降或有限的读取给出这一点；沿着每步都下降的量，世界从不停息。'),
    'laws': [
        law('One premise: an amount\'s strict falls stop from T on, as far as can be refuted (it is not the case that '
            'after every step from T on a later strict fall stays unrefuted). Balanced and dissipated on from T on, a '
            'family\'s levels stop changing, as far as can be refuted, exactly where its total\'s strict falls stop: one '
            'way needs neither premise (across a strict fall of the total some member\'s level falls, as far as can be '
            'refuted), the other is the law of one step.',
            '唯一的前提：一个量的严格下降从 T 起停止，在可否证的范围内（并非从 T 起每一步之后都有不被否证的更晚的严格下降）。'
            '从 T 起平衡且被耗散时，一个族的水平在可否证的范围内停止变化，恰在其总量的严格下降停止之处：一个方向不需要任何前提'
            '（总量严格下降时，在可否证的范围内有成员的水平下降），另一方向是一步之律。',
            L_ONE),
        law('The rest theorem with that one premise: a world whose active relata lie from T on in one family, balanced and '
            'dissipated on, whose arising is embodied and whose family total stops falling rests from some step on, '
            'unrefuted; so does a world with a census of its active relata, all embodied, a balanced and dissipative '
            'flow and every step from T on enclosed, whose census\'s total stops falling, since across an enclosed step '
            'the census\'s total does not rise and falls strictly at each arising or ceasing. A total read off '
            'configurations a list holds stops falling.',
            '以这一前提陈述的停息定理：活动关系项从 T 起都在一个族中、在其上平衡且被耗散、生起者具身、族总量停止下降的世界，从某步起停息，'
            '不可否证；有其活动关系项普查、全部具身、流平衡且耗散、从 T 起每步被围合、普查总量停止下降的世界也一样，因为在被围合的一步上，'
            '普查总量不上升，并在每次生起或止息处严格下降。读自列表所容纳构形的总量停止下降。',
            L_REST),
        law('Amounts in which every amount not rising stops falling have no endless fall. A least fall (every strict '
            'fall by at least ε above nothing) in Archimedean amounts gives it, and whole numbers are the instance; in '
            'such amounts every world with a census, embodied, balanced, dissipative and enclosed from some step on '
            'rests. Each premise is needed: dyadic amounts are Archimedean with no least fall, layered amounts have a '
            'least fall and are not Archimedean, and in both some amount falls strictly at every step.',
            '每个不上升的量都停止下降的量，没有无尽的下降。阿基米德量中的最小下降（每次严格下降至少是一个在无之上的 ε）给出这一点，'
            '自然数是其实例；在这样的量中，每个有普查、具身、平衡、耗散且从某步起被围合的世界都停息。每个前提都需要：二进量是阿基米德的而没有最小下降，'
            '分层量有最小下降而不是阿基米德的，两者中都有每步严格下降的量。',
            L_AMTS),
        law('Whole-number worlds are the instance with their own premises and nothing more: a finite world whose flow '
            'balances and dissipates and whose arising is embodied, and a counted world, embodied, balanced, '
            'dissipative and enclosed from some step on, rest, unrefuted, by the law over any amounts.',
            '自然数的世界是实例，只用它们自己的前提：流平衡且耗散、生起者具身的有限世界，以及被计数、具身、平衡、耗散且从某步起被围合的世界，'
            '由任何量上的规律停息，不可否证。',
            L_WHOLE),
        law('An endless fall keeps a world from rest: along any amount d falling strictly at every step, in any amounts, a '
            'standing passing between two relata (the holder at d t takes it all from itself and gives d (t + 1) to the '
            'other) has a census of its active relata, every relatum embodied, a balanced and dissipative flow and every '
            'step enclosed, and one relatum arises and the other ceases at every step; no list holds its levels.',
            '无尽的下降使世界不能停息：在任何量中，沿着每步严格下降的任何量 d，在两个关系项之间传递的水平（持有者在 d t，取自身的全部，'
            '给另一个 d (t + 1)）有其活动关系项的普查，每个关系项具身，流平衡且耗散，每步被围合，而每一步都有一个关系项生起、另一个止息；'
            '没有列表容纳它的水平。',
            L_PASS),
        law('Rest over every world in given amounts (every world with the enclosed premises rests) follows from no '
            'endless fall and leaves no amount falling at every step; so in dyadic and in layered amounts some world '
            'never rests, and in whole numbers every such world rests.',
            '给定量中所有世界的停息（每个满足围合前提的世界都停息）由没有无尽的下降得出，并使没有量每步都下降；'
            '所以在二进量与分层量中都有从不停息的世界，而在自然数中每个这样的世界都停息。',
            L_ALL)],
    'hypotheses': [T('No axiom. Amounts are any Amounts (a cancellative preordered commutative monoid with nothing least). '
                     'Named where they enter: that the total\'s strict falls stop, balance with no amount made, '
                     'dissipation read as whatever gives back all it takes takes nothing, embodiment, a census with '
                     'enclosure from T on or one family covering activity; for the amounts, a least fall above nothing '
                     'and the Archimedean property; for the converse, an amount falling strictly at every step. Equality '
                     'of relata is not decided.',
                     '不用公理。量是任何 Amounts（可消去的、有序的交换幺半群，无为最小）。在进入处列出：总量的严格下降停止、不产生量的平衡、'
                     '读作给回全部所取者什么也没取的耗散、具身、从 T 起的普查与围合或一个覆盖活动的族；对量而言，一个在无之上的最小下降与阿基米德性；'
                     '对反面而言，一个每步严格下降的量。关系项的相等不作判定。')],
    'does_not_show': [
        {**T('That rest over every world in given amounts is, constructively, the absence of an endless fall: from an '
             'amount whose falls recur only as far as can be refuted, an amount falling at every step is not built '
             'without choosing the steps at which it falls; classically, with dependent choice, the conditions coincide.',
             '给定量中所有世界的停息在构造上就是没有无尽的下降：从一个其下降只在可否证范围内反复出现的量，不选取它下降的那些步，'
             '就造不出每步都下降的量；在经典逻辑中，借助依赖选择，这些条件重合。'), 'kind': 'non-implication'},
        {**T('That the whole-number rest theorems are derived from the law over any amounts: they keep their own proofs '
             'below Becoming.InAmounts, which reads World; the instance shows their premises are exactly what the '
             'general law needs in whole numbers.',
             '自然数的停息定理由任何量上的规律推出：它们在读取 World 的 Becoming.InAmounts 之下保留自己的证明；实例表明，它们的前提恰是一般规律在自然数中所需。'),
         'kind': 'scope'},
        {**T('That any physical system has a least fall or a finite reading: both are premises.',
             '任何物理系统有最小下降或有限的读取：两者都是前提。'), 'kind': 'scope'},
        {**T('How soon the world rests, or naming the step: that is a principle of omniscience '
             '(World.lpo_of_finite_ends).',
             '世界多快停息，或指名那一步：那是一个全知原理（World.lpo_of_finite_ends）。'), 'kind': 'scope'}],
    'counterexamples': [
        {'path': src('InAmounts'), 'detail': T(
            'Pass.endless_keeps_from_rest: along any amount falling strictly at every step a standing passing between two '
            'relata meets every premise of the enclosed rest theorem but the stopping of the falls, and never rests; '
            'Halving.worlds_need_not_rest and Layered.worlds_need_not_rest: in dyadic amounts (no least fall) and in '
            'layered amounts (not Archimedean) some world never rests.',
            'Pass.endless_keeps_from_rest：沿着每步严格下降的任何量，在两个关系项之间传递的水平满足围合停息定理除下降停止外的每个前提，而从不停息；'
            'Halving.worlds_need_not_rest 与 Layered.worlds_need_not_rest：在二进量（没有最小下降）与分层量（不是阿基米德的）中都有从不停息的世界。')}],
    'standard_boundaries': STD,
    'validation_scope': VALID,
    'next_delta': T('A constructive equivalence of rest over every world with a property of the amounts, or a proof that '
                    'it needs choice; the other laws of flows, webs and worlds over any amounts; an independent review.',
                    '所有世界的停息与量的某一性质的构造等价，或证明它需要选择；流、依存网与世界的其他规律在任何量上的形式；独立审查。'),
    'correspondence': T('Well-foundedness of a strict order, read for dissipative worlds: with dependent choice it is the '
                        'absence of an infinite descending chain, constructively it is stronger (nLab, "well-founded '
                        'relation"). Termination by a potential in a well-founded set is Floyd\'s (1967) method, after '
                        'Turing (1949), and its completeness is the classical form of the converse here. A least fall in '
                        'Archimedean amounts is the discrete case of Hölder\'s (1901) theorem; the layered amounts are '
                        'the lexicographic order, the standard non-Archimedean example. Reading (the AI\'s): what the '
                        'whole numbers carry in the rest family is one property of the amounts, that nothing in them '
                        'falls without end.',
                        '严格序的良基性，为耗散世界而读：借助依赖选择，它就是没有无穷下降链；在构造上它更强（nLab，"well-founded relation"）。'
                        '以良基集中的势证明终止是 Floyd（1967）的方法，在 Turing（1949）之后，其完备性是这里反面的经典形式。'
                        '阿基米德量中的最小下降是 Hölder（1901）定理的离散情形；分层量是字典序，标准的非阿基米德例子。'
                        '读法（AI 的）：自然数在停息族中承载的，是量的一个性质：其中没有什么无尽地下降。'),
    'canonical_source': src('InAmounts'),
    'aliases': ['rest exactly where falls stop', '恰在下降停止之处停息', 'no endless fall', '没有无尽的下降',
                'one premise of rest', '停息的唯一前提', 'Becoming.World.InAmounts.change_stops_iff',
                'Becoming.Amounts.NoEndlessFall', 'Becoming.Pass.endless_keeps_from_rest'],
    'dependencies': [
        {'id': R2, 'relation': 'formal-reuse',
         'detail': T('Uses the world in amounts, its law of one step and its census laws; LC2\'s read forms are now '
                     'corollaries of the one-premise law.',
                     '使用任何量中的世界、其一步之律与普查规律；LC2 的读取形式现在是唯一前提规律的推论。'),
         'interface': {'output': T('A family\'s total does not rise and falls strictly at every change of a level.',
                                   '族的总量不上升，并在水平的每次变化处严格下降。'),
                       'input': T('The family\'s rest is exactly its total\'s.', '族的停息恰是其总量的停息。'),
                       'conditions': T('Balance and dissipation from T on.', '从 T 起的平衡与耗散。'),
                       'evidence': src('InAmounts')}},
        {'id': 'least-loss-rest', 'relation': 'formal-reuse',
         'detail': T('Uses the least-loss law of rest with the falls themselves as the steps counted, and the dyadic and '
                     'layered amounts as witnesses.',
                     '使用最小损失的停息之律，以下降本身作为所计的步，并以二进量与分层量为见证。'),
         'interface': {'output': T('Steps losing at least ε from a stock within finitely many ε do not recur.',
                                   '从在有限多个 ε 之内的存量中每步至少损失 ε 的步不反复出现。'),
                       'input': T('A least fall in Archimedean amounts leaves no endless fall.',
                                  '阿基米德量中的最小下降不留下无尽的下降。'),
                       'conditions': T('A least fall above nothing; the Archimedean property.',
                                       '一个在无之上的最小下降；阿基米德性。'),
                       'evidence': src('Amounts')}}],
    'related': [
        {'id': R2, 'detail': T('There the rest theorem over any amounts read finitely; here its one premise, exactly.',
                               '那里是有限读取时任何量上的停息定理；这里是它唯一的、恰好的前提。')},
        {'id': 'rest-from-a-finite-reading', 'detail': T('A finite reading is one of the two routes to the premise.',
                                                         '有限的读取是通往这一前提的两条途径之一。')},
        {'id': 'least-loss-rest', 'detail': T('A least fall in Archimedean amounts is the other.', '阿基米德量中的最小下降是另一条。')},
        {'id': 'space-and-its-parts', 'detail': T('Its whole-number rest theorem is the instance here with its own premises.',
                                                  '它的自然数停息定理在这里以其自己的前提成为实例。')}],
    'references': [
        {'path': src('InAmounts'), 'role': 'proof',
         'declarations': [full(d) for d in L_ONE + L_REST + L_AMTS + L_WHOLE + L_PASS + L_ALL if 'InAmounts' in full(d)
                          or full(d) in IN],
         'sha256': sha(src('InAmounts'))},
        {'path': src('LeastLoss'), 'role': 'proof',
         'declarations': [full(d) for d in L_ONE + L_AMTS if full(d) in LL], 'sha256': sha(src('LeastLoss'))},
        {'path': src('Amounts'), 'role': 'proof', 'sha256': sha(src('Amounts'))},
        {'path': src('Space'), 'role': 'proof', 'sha256': sha(src('Space'))},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [
        {'source': src(m), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
         'success_pointer': '/status', 'success_value': 'passed'} for m in ('InAmounts', 'LeastLoss')],
    'history': [T(f'21 October 2026: added (LC3), section 8.1 item 6: one rest theorem over any amounts, exactly where the '
                  f'total stops falling; study section {N}.',
                  f'2026年10月21日：新增（LC3），第 8.1 节第 6 项：任何量上唯一的停息定理，恰在总量停止下降之处；研究第 {N} 节。')],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)


def rebind(d):
    for b in d['proof_bindings']:
        if b['source'] in (src('LeastLoss'), src('InAmounts')):
            b['receipt'] = RECEIPT
    for r in d['references']:
        if r['path'] in (src('LeastLoss'), src('InAmounts'), CHAPTER, STUDY):
            r['sha256'] = sha(r['path'])
    if not any(r['path'] == RECEIPT for r in d['references']):
        d['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
    d['related'].append({'id': RID, 'detail': T('Rest over any amounts, exactly where the total stops falling.',
                                                '任何量上的停息，恰在总量停止下降之处。')})
    d['reviewed_at_utc'] = NOW


# LC2's record: its whole-number and witness laws are superseded by exact forms here.
p = RECORDS / f'{R2}.json'
d = json.loads(p.read_text())
assert len(d['laws']) == 5
d['laws'][3] = law(
    'Every world is a world in whole-number amounts whose balance, dissipation, embodiment and enclosure are the '
    'world\'s own; so the laws over any amounts apply to it with its own premises (record ' + RID + ': with those '
    'premises and nothing more, it rests).',
    '每个世界都是自然数量中的世界，其平衡、耗散、具身与围合就是世界自己的；所以任何量上的规律以其自己的前提适用于它（记录 ' + RID +
    '：只用这些前提，它停息）。',
    ['World.wholeAmounts', 'World.balanced_whole', 'World.dissipative_whole', 'World.embodied_whole',
     'World.arisingEmbodied_whole', 'World.enclosed_whole'])
d['laws'][4] = law(
    'Along an amount falling at every step, as the halving stock in dyadic amounts, a standing passing between two '
    'relata meets every other premise of the covering form and one relatum arises and the other ceases at every step; '
    'no list holds its levels.',
    '沿着每步都下降的量，如二进量中减半的存量，在两个关系项之间传递的水平满足覆盖形式的其他每个前提，而每一步都有一个关系项生起、另一个止息；'
    '没有列表容纳它的水平。',
    ['Pass.balanced', 'Pass.dissipative', 'Pass.embodied', 'Pass.never_rests', 'Pass.levels_unlisted'])
d['does_not_show'][2] = {**T('That a least loss is derived: where the reading is finite none is needed; where it is not, '
                             'as along an amount falling at every step (Pass), the world need not rest.',
                             '最小损失被推出：读取有限之处不需要它；不有限之处，如沿着每步都下降的量（Pass），世界不必停息。'),
                         'kind': 'non-implication'}
d['counterexamples'] = [{'path': src('InAmounts'), 'detail': T(
    'Pass.endless_keeps_from_rest: along any amount falling at every step, as the halving stock in dyadic amounts, a '
    'standing passing between two relata meets every other premise and arises and ceases at every step; '
    'Pass.levels_unlisted: no list holds its levels.',
    'Pass.endless_keeps_from_rest：沿着每步都下降的任何量，如二进量中减半的存量，在两个关系项之间传递的水平满足其他每个前提，'
    '而每一步都生起与止息；Pass.levels_unlisted：没有列表容纳它的水平。')}]
d['aliases'] = [a for a in d['aliases'] if a != 'Becoming.HalvingPass.never_rests'] + ['Becoming.Pass.never_rests']
for r in d['references']:
    if r['path'] == src('InAmounts'):
        keep = [x for x in r['declarations'] if x in IN]
        r['declarations'] = keep + [x for law_ in d['laws'] for x in law_['declarations'] if x in IN and x not in keep]
d['next_delta'] = T('The other laws of flows, webs and worlds over any amounts where a law needs more than the order of '
                    'its amounts; an independent review.',
                    '流、依存网与世界的其他规律在任何量上的形式，凡规律需要量的序以外者；独立审查。')
rebind(d)
d['history'].append(T(
    f'21 October 2026, LC3: the rest theorem takes one premise, that the census\'s total stops falling (record {RID}), '
    'and this record\'s read forms are its corollaries with their statements unchanged. The whole-number instances '
    'World.rests_unrefuted_enclosed_read and World.rests_unrefuted_listed, which also asked for a reading, are '
    'superseded by World.rests_unrefuted_enclosed_whole and World.rests_unrefuted_whole, which ask only the world\'s '
    'own premises (law 4 restated); HalvingPass is generalized below to Pass, along any amount falling at every step '
    f'(law 5 restated; board rule 9). Proof bindings re-pointed to receipt {core_id}; study section {N}.',
    f'2026年10月21日，LC3：停息定理只取一个前提，普查的总量停止下降（记录 {RID}），本记录的读取形式是其推论，陈述不变。'
    '同样要求读取的自然数实例 World.rests_unrefuted_enclosed_read 与 World.rests_unrefuted_listed，被只要求世界自身前提的 '
    'World.rests_unrefuted_enclosed_whole 与 World.rests_unrefuted_whole 取代（第 4 条规律重述）；HalvingPass 向下推广为 Pass，'
    f'沿着每步都下降的任何量（第 5 条规律重述；工作板规则 9）。证明绑定改指回执 {core_id}；研究第 {N} 节。'))
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('updated', R2)

for rid, note in [
    ('rest-from-a-finite-reading', T(
        f'21 October 2026, LC3: Amounts.rests_unrefuted_of_finite_reading states its conclusion as Amounts.FallsStop, '
        f'the one premise of rest over any amounts (record {RID}), the same proposition by definition; statements and '
        f'declarations otherwise unchanged; the proof binding re-pointed to receipt {core_id} after reading the change; '
        f'study section {N}.',
        f'2026年10月21日，LC3：Amounts.rests_unrefuted_of_finite_reading 以 Amounts.FallsStop 陈述其结论，即任何量上停息的唯一前提'
        f'（记录 {RID}），按定义是同一命题；陈述与声明其余不变；阅读改动后证明绑定改指回执 {core_id}；研究第 {N} 节。')),
    ('least-loss-rest', T(
        f'21 October 2026, LC3: Becoming.LeastLoss gains the one premise both rest routes give (Amounts.FallsStop) and '
        f'the amounts with no endless fall, which a least fall in Archimedean amounts gives, the dyadic and layered '
        f'amounts showing each premise needed for every amount, not only for one stock (record {RID}); this record\'s '
        f'declarations and statements unchanged; the proof binding re-pointed to receipt {core_id} after reading the '
        f'change; study section {N}.',
        f'2026年10月21日，LC3：Becoming.LeastLoss 增加两条停息途径共同给出的唯一前提（Amounts.FallsStop），以及没有无尽下降的量，'
        f'阿基米德量中的最小下降给出它，二进量与分层量表明每个前提对每个量都需要，而不只是对一个存量（记录 {RID}）；本记录的声明与陈述不变；'
        f'阅读改动后证明绑定改指回执 {core_id}；研究第 {N} 节。'))]:
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    rebind(d)
    d['history'].append(note)
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('updated', rid)
