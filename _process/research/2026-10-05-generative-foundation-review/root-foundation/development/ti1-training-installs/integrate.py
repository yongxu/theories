#!/usr/bin/env python3
"""Join TI1's module Becoming.Training to the core package: copy it in, import it after Becoming.PoolResponse, add its
root doc bullet after PoolResponse's, its CORE entry and scope text in check_becoming.py, and its README rows (EN after
PoolResponse's, ZH after Learning's, the Chinese table having no PoolResponse row).
usage: python3 -B integrate.py   (TI1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['TI1_ROOT']).resolve() if os.environ.get('TI1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Training.lean', PKG / 'Becoming' / 'Training.lean')

DOC = (
    '* `Becoming.Training` (L1): what a selection over act laws installs. Training is read as a\n'
    '  selection over a learner\'s candidate act laws through the courses each generates, a situation\n'
    '  fixing the others\' law (a realization of their noise), the start and the execution. Two laws of\n'
    '  what has stood exchanging alike along the levels the first generates generate the same levels,\n'
    '  so candidates giving alike along the first\'s courses are trained alike by every training: a law\n'
    '  is installed only along its own courses, and an explored law only where it acts on an explored\n'
    '  course. Off them, within the laws reading through a lumping of histories (a representation; the\n'
    '  coupling and agreement are lumpings), it is installed exactly where the lumping cannot tell a\n'
    '  history from a course, and elsewhere a law of the class with the same courses takes any amount\n'
    '  and responds or not. Through a reward\'s couplings, candidates are trained alike exactly where\n'
    '  their levels are alike through them (by construction, as `Web.selects_alike_iff`), and a\n'
    '  difference in the act is installed only where it reaches what couples into the reward\'s\n'
    '  closure. Every settled candidate is a rest of every improving search, which under a bounded\n'
    '  reward rests within the bound; a local search rests exactly where no neighbour is rewarded more,\n'
    '  and with every candidate a neighbour exactly where the reward settles. A reading the same for\n'
    '  every candidate leaves the optimum at any weight, as a reading after the rest\'s end does where\n'
    '  the rest outruns the renewal. In `Training.Commons` restraint is settled exactly at weights of at\n'
    '  least one where the rest stays within the renewal and at no weight where it outruns it; at\n'
    '  weight one the start decides, and where the rest outruns it a neighbourhood can install\n'
    '  restraint that no weight installs.\n')
SCOPE = (
    '    "Training: two laws of what has stood exchanging alike along the levels the first generates "\n'
    '    "generate the same levels; candidates giving alike along the course the first generates in each "\n'
    '    "situation, a situation fixing the others\' law, the start and the execution, have the same courses and "\n'
    '    "are trained alike by every training reading candidates through their courses, and an explored law is "\n'
    '    "fixed only at the steps left to it; within the laws reading through a lumping of histories, two with "\n'
    '    "the same courses exchange alike at every history it lumps with a course, and at a history it lumps "\n'
    '    "with no course a law of the class with the same courses takes any amount, responding there or not, "\n'
    '    "the coupling and agreement being lumpings; a training through a reward\'s couplings trains two "\n'
    '    "candidates alike exactly where their levels are alike through them, the optimum of a reward through "\n'
    '    "them is one, with the classes decided some such reward settles on one of two candidates apart "\n'
    '    "through them, and candidates agreeing on what couples into the reward\'s closure are trained alike; "\n'
    '    "every settled candidate is a rest of every improving search, which under a reward at most B rests by "\n'
    '    "step B + 1; a local search rests exactly where no neighbour is rewarded more, and with every candidate "\n'
    '    "a neighbour exactly where the reward settles; a reading the same for every candidate leaves the "\n'
    '    "optimum at any weight, as a reading after the rest\'s end does where the rest outruns a gated renewal "\n'
    '    "in every candidate\'s course; in the computed commons restraint is settled exactly at weights of at "\n'
    '    "least one where the rest takes no more than the renewal and at no weight where it takes more, at "\n'
    '    "weight one every improving search keeps the law it starts from, and where the rest outruns the "\n'
    '    "renewal a search with empty neighbourhoods rests at restraint. "\n')
README_ROW = (
    '| L1 | [`Becoming.Training`](Becoming/Training.lean) | what training installs (no axiom; the laws read what has '
    'stood, feasibility, reading through coupling, decidedness, the outrun premises and a reward bound are hypotheses '
    'where they enter): training read as a selection over a learner\'s candidate act laws through the courses each '
    'generates, a situation fixing the others\' law, the start and the execution; a law is fixed by what it does '
    'along its own course (`ExchangeLaw.levels_agree_of_along`), so candidates giving alike along the first\'s '
    'courses are trained alike (`Training.same_courses_of_along`, `Training.trained_alike_of_along`), an explored law '
    'only where it acts (`Training.explored_same_courses`); within the laws reading through a lumping of histories '
    '(`Training.Lumping`), installed exactly where the lumping cannot tell a history from a course '
    '(`Training.installed_where_lumped`) and free elsewhere, responding or not (`Training.free_where_unlumped`, '
    '`Training.response_free_where_unlumped`, one construction `Training.setOn`), the coupling and agreement its cases '
    '(`Training.installed_where_alike`, `Training.response_free_where_apart`, `Training.response_free_off_courses`); '
    'through a reward\'s couplings exactly where the levels are alike through them (`Training.trained_alike_iff`, by '
    'construction; `Training.settles_through`, `Training.settles_apart`), and alike where the acts agree on what '
    'couples into the reward\'s closure (`Training.trained_alike_beyond_closure`); every settled candidate a rest of '
    'every improving search (`Training.settled_stays`), which rests within a reward bound (`Training.comes_to_rest`); a '
    'local search rests exactly where no neighbour is rewarded more (`Training.LocalSearch.rests_iff`, '
    '`Training.LocalSearch.rests_iff_settles`); a reading the same for every candidate leaves the optimum at any weight '
    '(`Training.settles_weighted_iff`), as one after the rest\'s end does where the rest outruns the renewal '
    '(`Training.outrun_settles_iff`); in `Training.Commons` restraint is settled exactly at weights of at least one '
    'where the rest stays within the renewal, at no weight where it outruns it, at weight one the start decides, and a '
    'neighbourhood can install restraint no weight installs (`Commons.renewed_restraint_settles_iff`, '
    '`Commons.outrun_restraint_unsettled`, `Commons.start_decides`, `Commons.outrun_neighbourhood_decides`) '
    '([what-training-installs](../../../../../../theories/becoming/results/records/what-training-installs.md)) |')
README_ZH_ROW = (
    '| L1 | [`Becoming.Training`](Becoming/Training.lean) | 训练安装什么（不加公理；读已立者、可行、经耦合而读、已判定、超出的'
    '前提与奖励之界在其进入之处都是假设）：把训练读作对学习者候选动作律的选择，经每个候选所生成的进程，一个情形确定他者之律、起点与执行；'
    '一个律由它沿自身进程所做者确定（`ExchangeLaw.levels_agree_of_along`），所以沿第一个的进程给出相同的候选被训练得相同'
    '（`Training.trained_alike_of_along`），被探索的律只在它行动之处（`Training.explored_same_courses`）；在经历史之归并'
    '（`Training.Lumping`）而读的律中，恰在归并不能把一段历史与某个进程分开之处被安装（`Training.installed_where_lumped`），'
    '其余处自由，回应与否皆可（`Training.response_free_where_unlumped`），耦合与一致是其情形；经奖励的耦合，恰在水平经其无别之处'
    '训练得相同（`Training.trained_alike_iff`，依构造）；每个被选定的候选都是每个改进搜索的静止点（`Training.settled_stays`），'
    '奖励有界时在界内静止（`Training.comes_to_rest`）；局部搜索恰在没有邻居被奖励更多之处静止（`Training.LocalSearch.rests_iff`）；'
    '对每个候选都相同的读数在任何权重下都不移动最优（`Training.outrun_settles_iff`）；在 `Training.Commons` 中，克制恰在权重至少为一时'
    '被选定，其余者超出更新时在任何权重下都不被选定，权重为一时由起点决定，邻域能安装任何权重都不安装的克制 |')

root = (PKG / 'Becoming.lean').read_text()
assert 'import Becoming.Training\n' not in root, 'already integrated'
root = once(root, 'import Becoming.PoolResponse\n', 'import Becoming.PoolResponse\nimport Becoming.Training\n')
root = once(root, '* `Becoming.Rejoining` (L1): where the courses with and without an act rejoin.',
            DOC + '* `Becoming.Rejoining` (L1): where the courses with and without an act rejoin.')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '"Becoming.PoolResponse", ', '"Becoming.PoolResponse", "Becoming.Training", ')
chk = once(chk, '    "Rejoining: a difference between the courses with and without an act opens or closes at a "\n',
           SCOPE + '    "Rejoining: a difference between the courses with and without an act opens or closes at a "\n')
(PKG / 'check_becoming.py').write_text(chk)

for name, row, anchor in (
        ('README.md', README_ROW, '| L1 | [`Becoming.PoolResponse`](Becoming/PoolResponse.lean) |'),
        ('README.zh.md', README_ZH_ROW, '| L1 | [`Becoming.Learning`](Becoming/Learning.lean) |')):
    rd = (PKG / name).read_text()
    lines = rd.split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith(anchor)]
    assert len(idx) == 1, (name, idx)
    lines[idx[0] + 1:idx[0] + 1] = [row]
    (PKG / name).write_text('\n'.join(lines))
print('integrated')
