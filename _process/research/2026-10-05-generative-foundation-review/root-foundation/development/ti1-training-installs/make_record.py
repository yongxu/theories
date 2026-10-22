#!/usr/bin/env python3
"""Write TI1's record (what-training-installs):
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.Training (a short name must
match exactly one declaration by suffix), and the receipt must bind the module's current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
MOD = 'Training'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. What training installs: a law is installed only along its own courses (TI1, TI2)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    return m


def resolve(mod, names):
    full = [d['name'] for d in decls(mod)['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.' + n or f.endswith('.' + n)]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


m = decls(MOD)
assert not any(m['axiom_dependencies'].values())
n_decl, n_thm = len(m['declarations']), sum(1 for d in m['declarations'] if d.get('kind') == 'theorem')

BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'what-training-installs'
T = 'Training.'
K = 'Training.Commons.'
laws = [
    ('A law is fixed by what it does along its own course: two laws of what has stood that exchange alike along the '
     'levels the first generates generate the same levels, with no premise of feasibility.',
     '一个律由它沿自身进程所做者确定：两个读已立者的律沿第一个所生成的水平交换相同时，生成相同的水平，不需可行的前提。',
     ['ExchangeLaw.AlongAlike', 'ExchangeLaw.exchange_along', 'ExchangeLaw.levels_agree_of_along']),
    ('Training read as a selection over a learner\'s candidate act laws through the courses each generates, a '
     'situation fixing the others\' law (a realization of their noise), the start and the execution: two candidates '
     'giving alike, for the part, along the course the first generates in each situation have the same courses, and '
     'every training reading candidates through their courses trains them alike.',
     '把训练读作对学习者候选动作律的选择，经每个候选所生成的进程，一个情形确定他者之律（其噪声的一个实现）、起点与执行：沿第一个在每个'
     '情形中所生成的进程对部分给出相同的两个候选有相同的进程，每个经进程读候选的训练都把它们训练得相同。',
     [T + 'levels', T + 'course', T + 'SameCourses', T + 'Reads', T + 'same_courses_of_along',
      T + 'trained_alike_of_along']),
    ('Exploration: a law explored on a schedule acts by an exploring law at the steps the schedule marks; two laws '
     'giving alike at the steps left to them along the explored courses have the same explored courses, so what the '
     'law does at an exploring step, or under a history no explored course passes, is installed by no training.',
     '探索：按日程探索的律在日程所标之步按探索之律行动；沿被探索的进程在留给它们的步上给出相同的两个律有相同的被探索进程，所以律在探索之步，'
     '或在被探索进程都不经过的历史之下所做的，没有训练安装。',
     [T + 'explore', T + 'explore_nonanticipating', T + 'explored_same_courses']),
    ('Off its courses, within the laws reading through a lumping of histories (a representation; the part\'s coupling '
     'and agreement itself are lumpings): two with the same courses take and give alike at every history the lumping '
     'lumps with one of the courses.',
     '在进程之外，在经历史之归并（一个表示；部分的耦合与一致本身都是归并）而读的律中：进程相同的两个律，在此归并与某个进程归为一类的每段'
     '历史上，取与给都相同。',
     [T + 'Lumping', T + 'agree_symm', T + 'alike_of_agree', T + 'Lumping.coupling', T + 'Lumping.agreement',
      T + 'ReadsThrough', T + 'ReadsThrough.of_through', T + 'ReadsThrough.through',
      T + 'ReadsThrough.of_nonanticipating', T + 'installed_where_lumped', T + 'installed_where_alike']),
    ('At a history the lumping lumps with no course (decided), for every amount some law reading what has stood and '
     'through the lumping, with the same courses, takes it there; given a history the lumping separates from it, '
     'some such law takes alike under the two and some differently. The coupling and agreement are cases: nothing '
     'is installed off the courses beyond what the representation lumps with them.',
     '在此归并不与任何进程归为一类的历史处（与之归类已判定），对每个量都有读已立者、经此归并而读、进程相同的律在那里取该量；给定此归并与之'
     '分开的历史，有这样的律在两者之下取得相同，也有取得不同的。部分的耦合与一致是其情形：在进程之外，表示所归入者之外没有任何东西被安装。',
     [T + 'setOn', T + 'setOn_take_off', T + 'setOn_take_at', T + 'setOn_respects', T + 'setOn_lumped',
      T + 'free_where_unlumped', T + 'response_free_where_unlumped', T + 'response_free_where_apart',
      T + 'response_free_off_courses']),
    ('A training through a selector r\'s couplings up to T selects alike candidates whose levels are alike through '
     'them in every situation; every such training reads the courses, and two candidates are trained alike by every '
     'one exactly when their levels are alike through r\'s couplings in every situation (by construction, as '
     'Web.selects_alike_iff).',
     '到 T 为止经选择者 r 之耦合的训练，把水平在每个情形中经这些耦合无别的候选选得相同；每个这样的训练都经进程读候选，两个候选被每个'
     '这样的训练训练得相同，恰当其水平在每个情形中经 r 的耦合无别（依构造，如 Web.selects_alike_iff）。',
     [T + 'TrainsThrough', T + 'TrainsThrough.reads', T + 'trained_alike_iff']),
    ('What a reward through r\'s couplings settles on, its optimum among the candidates, is such a training; a score '
     'of level histories through them read in one situation is such a reward; and with the class decided, where two '
     'candidates\' levels are apart through r\'s couplings in one situation some such reward settles on the first and '
     'not on the second.',
     '经 r 之耦合的奖励所选定者，即其在候选中的最优，是这样的训练；在一个情形中读出、经这些耦合的水平历史之得分是这样的奖励；类已判定时，'
     '两个候选的水平在一个情形中经 r 的耦合有别，就有这样的奖励选定第一个而不选定第二个。',
     [T + 'RewardsThrough', T + 'Settles', T + 'settles_through', T + 'score_rewards', T + 'settles_apart']),
    ('A search step improving for a reward stays or moves to a candidate rewarded more; every candidate the reward '
     'settles on is a rest of every improving search, which started there stays; under a reward at most B it rests '
     'from every start by step B + 1, so the basin of a start is its orbit there.',
     '对奖励改进的搜索步要么不动，要么移到奖励更多的候选；奖励所选定的每个候选都是每个改进搜索的静止点，从那里起始的搜索留在那里；奖励至多为 '
     'B 时，它从每个起点在第 B + 1 步前静止，所以一个起点的吸引域就是其轨道在那里所在。',
     [T + 'Improving', T + 'settled_rests', T + 'settled_stays', T + 'rested_or_risen', T + 'comes_to_rest']),
    ('A local search over a neighbourhood relation, its parameterization, rests exactly where no neighbour is rewarded '
     'more, and with every candidate a neighbour exactly where the reward settles: the rests a narrower neighbourhood '
     'adds are its implicit bias.',
     '在一个邻域关系（即其参数化）上的局部搜索，恰在没有邻居被奖励更多之处静止；每个候选都是邻居时，恰在奖励所选定之处：更窄的邻域所加的'
     '静止点是其隐含偏置。',
     [T + 'LocalSearch', T + 'LocalSearch.improving', T + 'LocalSearch.rests_iff',
      T + 'LocalSearch.rests_iff_settles']),
    ('With the situations\' laws reading what has stood and through coupling, both candidates reading what has stood, '
     'the first through its members\' coupling, and both courses feasible in every situation, two candidates agreeing '
     'on every condition coupled into r\'s coupling closure, drawn through their two courses, are trained alike by '
     'every training through r\'s couplings.',
     '各情形之律读已立者并经耦合而读，两个候选都读已立者、第一个经其成员的耦合而读，两条进程在每个情形中都可行时，在耦合入 r 之耦合闭包'
     '（经两条进程所取）的每个条件上一致的两个候选，被每个经 r 之耦合的训练训练得相同。',
     [T + 'trained_alike_beyond_closure']),
    ('A reading the same for every candidate leaves the optimum at any weight: a reward adding it settles exactly '
     'where the reward without it settles. Where in every candidate\'s course renewal is gated at need one and the '
     'rest takes jointly more than is given at each of n steps from T, from a level at most n, every score reading '
     'the condition only from T + n on is such a reading.',
     '对每个候选都相同的读数在任何权重下都不移动最优：加上它的奖励恰在不加它的奖励所选定处选定。每个候选的进程中更新在需要一处门控、'
     '其余者从至多 n 的水平起在自 T 的 n 步每步合取多于所给时，只读该条件自 T + n 起之水平的每个得分都是这样的读数。',
     [T + 'settles_weighted_iff', T + 'outrun_reading_same', T + 'outrun_settles_iff']),
    ('A computed commons: the learner\'s reward reads its store and the stock at step four through its coupling, by '
     'level, into both. Where the rest draws within the renewal, restraint is settled exactly at weights of at least '
     'one; where it outruns the renewal, restraint is settled at no weight and the drawing law at every weight.',
     '一个算出的公地：学习者的奖励经其以水平耦合入两者的耦合，读第四步的存量与库存。其余者的汲取在更新之内时，克制恰在权重至少为一时'
     '被选定；超出更新时，克制在任何权重下都不被选定，汲取之律在每个权重下都被选定。',
     [K + 'Member', K + 'present', K + 'others', K + 'drawing', K + 'restraint', K + 'cand', K + 'part', K + 'start',
      K + 'lev', K + 'reward', K + 'obs', K + 'web', K + 'reward_through', K + 'couples_into_stock',
      K + 'renewed_restraint_reward', K + 'renewed_drawing_reward', K + 'outrun_restraint_reward',
      K + 'outrun_drawing_reward', K + 'one_le_of_le', K + 'renewed_restraint_settles_iff',
      K + 'outrun_restraint_unsettled', K + 'outrun_drawing_settles']),
    ('In the same commons at weight one, with the rest within the renewal, both laws are settled, the drawing law '
     'responding to the stock and restraint not, and every improving search keeps the one it starts from; where the '
     'rest outruns it, a search with empty neighbourhoods rests at restraint, which no weight settles on, and one with '
     'every candidate a neighbour leaves it.',
     '同一公地中，权重为一、其余者在更新之内时，两个律都被选定，汲取之律回应库存而克制不回应，每个改进搜索都留在它起始的那个；其余者超出'
     '更新时，邻域为空的搜索停在克制（没有权重选定它），每个候选都是邻居的搜索离开它。',
     [K + 'renewed_both_settle', K + 'drawing_responds', K + 'start_decides', K + 'outrun_neighbourhood_decides']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

COURSE_DEP = dep('counterfactual-is-the-course', 'formal-reuse',
                 'Reuses ExchangeLaw, Nonanticipating, withAct, levels, course, history_agree, levels_succ, Feasible '
                 'and withAct_nonanticipating; the delta fixes a law\'s generated levels by what it does along them, '
                 'with no premise of feasibility (course_unique gives this for a feasible course).',
                 '复用 ExchangeLaw、Nonanticipating、withAct、levels、course、history_agree、levels_succ、Feasible 与 '
                 'withAct_nonanticipating；增量是由一个律沿其所生成之水平所做者确定这些水平，不需可行的前提（course_unique 对可行的进程给出这一点）。',
                 'The course a law of exchange generates from the starting levels.', '交换之律自起始水平所生成的进程。',
                 'A learner\'s courses, one per candidate act law and situation, and their fixing by what the candidate '
                 'does along them.',
                 '学习者的进程，每个候选动作律与情形一条，以及它们由候选沿其所做者确定。',
                 'Laws reading what has stood; discrete steps, whole-number amounts.', '读已立者的律；离散步、整数量。',
                 src('Counterfactual'))
SELECT_DEP = dep('selection-through-couplings', 'formal-reuse',
                 'Reuses Web.SelectsThrough, Web.ScoresThrough, Web.AlikeThroughUpTo, Web.class_selects and the '
                 'structure of Web.selects_alike_iff; the delta reads a selection over candidates through the levels '
                 'their courses generate.',
                 '复用 Web.SelectsThrough、Web.ScoresThrough、Web.AlikeThroughUpTo、Web.class_selects 与 Web.selects_alike_iff 的结构；'
                 '增量是把对候选的选择读作经其进程所生成之水平的选择。',
                 'A selection through a formation\'s couplings reaches exactly what couples into it.',
                 '经一个形成之耦合的选择恰及于耦合入它者。',
                 'A training through a reward\'s couplings on the learner\'s own courses.', '在学习者自身进程上经奖励之耦合的训练。',
                 'That a given training goes through those couplings is supplied.', '一个给定的训练经这些耦合，这一点为所给。',
                 src('Selection'))
GAP_DEP = dep('the-gap-for-ones-own-act', 'formal-reuse',
              'Reuses act_courses_unselected: with both acts laws, a selection through the coupling of a formation '
              'within the closure selects the two courses alike; the delta reads it with the reward as that formation '
              'and the training as the selection.',
              '复用 act_courses_unselected：两个动作都是律时，经闭包之内一个形成之耦合的选择把两条进程选得相同；增量是把奖励读作该形成、'
              '把训练读作该选择。',
              'The gap for one\'s own act, with nothing supplied.', '自身动作的缺口，不另给任何东西。',
              'Candidates agreeing on what couples into the reward\'s closure are trained alike.',
              '在耦合入奖励闭包者上一致的候选被训练得相同。',
              'The rest\'s law reads what has stood and through coupling; the candidates read what has stood, the first '
              'through its members\' coupling; both courses feasible.',
              '其余者的律读已立者并经耦合而读；候选读已立者，第一个经其成员的耦合而读；两条进程可行。', src('SelectionGap'))
OUTRUN_DEP = dep('the-rest-outruns-the-renewal', 'formal-reuse',
                 'Reuses Flow.outrun_reading_alike on every candidate\'s course; the delta adds that a reading the same '
                 'for every candidate moves no optimum at any weight.',
                 '在每个候选的进程上复用 Flow.outrun_reading_alike；增量是对每个候选都相同的读数在任何权重下都不移动最优。',
                 'Every reading after the rest\'s end is alike under a member\'s acts.', '其余者终止之后的每个读数在成员的动作之下相同。',
                 'A reward adding such a reading settles where the reward without it settles.',
                 '加上这样读数的奖励在不加它的奖励所选定处选定。',
                 'Balance, only active formations giving, activity needing support, renewal gated at need one, the rest '
                 'outrunning from a level at most n, in every candidate\'s course.',
                 '每个候选的进程中：平衡，只有活跃的构成给予，活动需要支持，更新在需要一处门控，其余者从至多 n 的水平起超出。',
                 src('Exclusion'))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'What training installs', 'zh': '训练安装什么'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Training read as a selection over act laws through the courses each generates installs a law only '
              'along its own courses and as far as the learner\'s representation lumps them, through a reward only '
              'where its couplings separate, and among settled laws by the search\'s start and neighbourhoods.',
        'zh': '把训练读作对动作律的选择，经每个律所生成的进程：它只沿律自身的进程、并在学习者的表示把它们归并所及之处安装律；'
              '经奖励，只在其耦合分开之处；在被选定的几个律中，由搜索的起点与邻域决定。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(MOD, names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. The situations\' laws and the candidates read what has stood wherever the on-course, '
              'exploration and off-course laws enter; for the off-course laws, the law reading through a lumping and '
              'being lumped with the history decided; for the closure law, the situations\' laws reading through '
              'coupling and both courses feasible; for the outrun laws, outrun_below\'s premises in every candidate\'s '
              'course; for the basin law, a bound on the reward. A training reads each candidate through its own '
              'courses, as the optimum of any reward does.',
        'zh': '不加公理。凡进程上、探索与进程外的规律进入之处，各情形之律与候选都读已立者；进程外的规律需律经一个归并而读、与该历史归类已判定；'
              '闭包之律需各情形之律经耦合而读、两条进程可行；超出之律需每个候选进程中 outrun_below 的前提；吸引域之律需奖励有界。训练经每个'
              '候选自身的进程读它，如任何奖励的最优所做。'}],
    'does_not_show': [
        {'en': 'Which lumping an actual architecture\'s representation makes, or which neighbourhoods its updates '
               'search: the laws say what any lumping installs and where any neighbourhood rests, not which a given '
               'system has, which is read empirically.',
         'zh': '实际架构的表示作哪个归并，或其更新搜索哪些邻域：这些规律说任何归并安装什么、任何邻域在何处静止，不说一个给定系统有哪个，'
               '那要经验地读出。',
         'kind': 'scope'},
        {'en': 'The weights a training gives noise realizations or explored courses: they change which candidate is '
               'rewarded more, not what a training can install; and which basin a particular start lies in, beyond '
               'that it is reached within the bound.',
         'zh': '训练给噪声实现或被探索进程的权重：它们改变哪个候选被奖励更多，不改变训练能安装什么；以及一个具体起点落在哪个吸引域，除了'
               '在界内到达之外。',
         'kind': 'scope'},
        {'en': 'The evidence that an actual system was trained this way.',
         'zh': '一个实际系统如此被训练的证据。',
         'kind': 'scope'},
        {'en': 'That a learner ought to respond to what it couples into, or that restraint is better: the laws say '
               'what a training can install, not what it should.',
         'zh': '学习者应当回应它所耦合入者，或克制更好：这些规律说训练能安装什么，不是应当安装什么。',
         'kind': 'non-implication'}],
    'counterexamples': [{'path': src(MOD), 'detail': {
        'en': 'Training.Commons: the learner\'s reward couples into the stock by level and reads it at step four, '
              'yet where the rest draws two a step against a renewal of one, restraint is settled at no weight and the '
              'drawing law at every weight (outrun_restraint_unsettled, outrun_drawing_settles): coupling into a '
              'condition does not install a response to it. With the rest drawing one, the same reward settles on '
              'restraint from weight one (renewed_restraint_settles_iff).',
        'zh': 'Training.Commons：学习者的奖励以水平耦合入库存并在第四步读它，然而其余者每步汲取二、更新为一时，克制在任何权重下都不被'
              '选定，汲取之律在每个权重下都被选定（outrun_restraint_unsettled、outrun_drawing_settles）：耦合入一个条件并不安装对它的回应。'
              '其余者汲取一时，同一奖励自权重一起选定克制（renewed_restraint_settles_iff）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_decl} declarations of '
              f'Becoming.{MOD}, {n_thm} of them theorems, have empty axiom reports; the checker verifies core purity. '
              f'Built and reviewed in one session, with no separate reviewer; author review in study section {N}; not '
              'independently reviewed.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.{MOD} 的 {n_decl} 项声明（{n_thm} 项定理）公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经独立审查。'},
    'next_delta': {
        'en': 'The lumping and neighbourhoods of an actual architecture, read empirically; the basins of CG1 and '
              'CG2\'s learners under their own update laws; an independent review.',
        'zh': '实际架构的归并与邻域，经验地读出；CG1 与 CG2 的学习者在其自身更新律下的吸引域；独立审查。'},
    'correspondence': {
        'en': 'Chapter section 7.7 left open how training installs a law that responds to what it couples into, and '
              'section 8.1 item 7 how a member\'s law forms; CG2\'s X2 found that weighting the end reading sixteen '
              'times more changed nothing. The on-course law is the on-policy point of imitation learning (Ross, '
              'Gordon and Bagnell 2011) and the formal kernel of goal misgeneralization (Langosco, Koch, Sharkey, Pfau '
              'and Krueger 2022; Shah et al. 2022); the outrun law is pivotality (Palfrey and Rosenthal 1984) read on '
              'a reward; among settled laws stochastic stability (Kandori, Mailath and Rob 1993; Young 1993) is one '
              'rule selecting a basin, by noise, cited. Reading (the AI\'s, with the scope of chapter section 7, D45): '
              'training reaches only along the learner\'s own courses, as far as its representation lumps them, and only '
              'through what the reward couples into; where the reading falls against what the rest does decides, not '
              'its weight, and among equally rewarded laws the search\'s start decides.',
        'zh': '本章第 7.7 节留下开放：训练怎样安装一个回应其所耦合入者的律；第 8.1 节第 7 项：成员的律怎样形成；CG2 的 X2 发现把终末读数'
              '加权十六倍不改变任何东西。进程上的规律是模仿学习的在策略要点（Ross、Gordon 与 Bagnell 2011），也是目标误泛化的形式核心'
              '（Langosco、Koch、Sharkey、Pfau 与 Krueger 2022；Shah 等 2022）；超出之律是关键性（Palfrey 与 Rosenthal 1984）在奖励上的读法；'
              '在被选定的律之间，随机稳定性（Kandori、Mailath 与 Rob 1993；Young 1993）是以噪声选择吸引域的一种规则，仅引用。'
              '读法（AI 的，以本章第 7 节的范围，D45）：训练只沿学习者自身的进程、只经奖励所耦合入者而及；起决定作用的是读数相对于其余者'
              '所为落在何处，不是其权重。'},
    'canonical_source': src(MOD),
    'aliases': ['what training installs', '训练安装什么', 'a law is installed only along its own courses',
                'training through a learner\'s own courses', 'Becoming.Training.trained_alike_of_along',
                'Becoming.Training.response_free_off_courses', 'Becoming.Training.outrun_settles_iff'],
    'dependencies': [COURSE_DEP, SELECT_DEP, GAP_DEP, OUTRUN_DEP],
    'related': [
        {'id': 'generalization-through-lumping', 'detail': {
            'en': 'Training.fit_right_iff and Training.unselected_beyond_data hold for data fixed in advance; here the '
                  'data are the courses the candidate itself generates, and the same boundary falls on them.',
            'zh': 'Training.fit_right_iff 与 Training.unselected_beyond_data 对预先固定的数据成立；这里数据是候选自己所生成的进程，'
                  '同一界线落在其上。'}},
        {'id': 'what-a-pools-acts-respond-to', 'detail': {
            'en': 'Coupling bounds response and does not fix it (ExchangeLaw.response_not_fixed_by_coupling); here '
                  'what a training through a reward can fix within that bound.',
            'zh': '耦合界定回应而不确定回应（ExchangeLaw.response_not_fixed_by_coupling）；这里是经奖励的训练在此界之内能确定什么。'}}],
    'references': [{'path': src(MOD), 'role': 'proof', 'declarations': sorted(d['name'] for d in m['declarations']),
                    'sha256': sha(src(MOD))},
                   {'path': src('Counterfactual'), 'role': 'proof', 'sha256': sha(src('Counterfactual'))},
                   {'path': src('Selection'), 'role': 'proof', 'sha256': sha(src('Selection'))},
                   {'path': src('SelectionGap'), 'role': 'proof', 'sha256': sha(src('SelectionGap'))},
                   {'path': src('Exclusion'), 'role': 'proof', 'sha256': sha(src('Exclusion'))},
                   {'path': 'experiments/commons-outrun/README.md', 'role': 'integration',
                    'sha256': sha('experiments/commons-outrun/README.md')},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(MOD), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (TI1, with TI2: any lumping, noise and exploration, local search and basins), on '
              f'chapter section 7.7\'s open item of how training installs a law and section 8.1 item 7; study section {N}.',
        'zh': f'2026年10月22日：新增（TI1，连同 TI2：任何归并、噪声与探索、局部搜索与吸引域），针对本章第 7.7 节训练怎样安装一个律的开放项'
              f'与第 8.1 节第 7 项；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_thm, n_decl)
