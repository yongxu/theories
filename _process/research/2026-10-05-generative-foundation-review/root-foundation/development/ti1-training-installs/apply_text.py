#!/usr/bin/env python3
"""TI1 landing text: the study section; the chapter (EN: section 7.1's Training bullet and the proxy paragraph, section
7.7's coupling bullet, response bullet and records, section 8.1 item 7, the relation to known results, the glossary row
"training", the record table and section 9's receipt, counts and audit sentence; ZH: section 7.1's theorem line, 7.7's
records, 8.1 item 7, the glossary row, the record table and section 9) and the board row moved to the history file with
the queue and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE
Prints the study section number."""
import json
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Training'
RID = 'what-training-installs'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
receipt_id, conn_log, base = sys.argv[1], sys.argv[2], sys.argv[3]


def edit(path, pairs):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    for old, new in pairs:
        k = text.count(old)
        if k != 1:
            sys.exit(f'{path}: expected one match, found {k}: {old[:100]!r}')
        text = text.replace(old, new)
    p.write_text(text, encoding='utf-8')
    print('edited', path, len(pairs))


def line_from(text, start):
    i = text.index(start)
    assert text.count(start) == 1, start
    return text[i:text.index('\n', i)]


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
mod = next(m for m in R['modules'] if m['module'] == MOD)
n_mod_thm, n_mod_decl = mod['theorems'], len(mod['declarations'])
mods, thms = Counter(), Counter()
for m in R['modules']:
    mods[m['layer']] += 1
    thms[m['layer']] += m['theorems']
spine_decls = sum(len(m['declarations']) for m in R['modules'] if m['spine'])
spine_thms = sum(m['theorems'] for m in R['modules'] if m['spine'])
closure = len(R['core_closure'])
closure_thms = sum(m['theorems'] for m in R['modules'] if m['module'] in R['core_closure'])
injeq = len(R.get('generated_axiom_dependencies', {}))
ran, reused = len(R['lean_steps']['ran']), len(R['lean_steps']['reused'])
fmt = lambda n: f'{n:,}'
t = Path(conn_log).read_text() if conn_log.startswith('/') else (ROOT / conn_log).read_text()
conn = json.loads(t[t.index('{'):t.rindex('}') + 1])
apart = sum(v for k, v in conn['classes'].items() if k.startswith('apart'))
assert conn['spine_theorems'] == spine_thms, (conn['spine_theorems'], spine_thms)
assert not conn['apart_roots_unclassified'] and not conn['register_entries_not_apart_roots']
mod_apart = conn['apart_by_module'].get(MOD, [0])[0]

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
apart_text = (f'The connectivity rerun counts {apart} of {fmt(spine_thms)} spine theorems apart, {mod_apart} of the '
              f'module\'s {n_mod_thm}; the register check passes.')
study = (HERE / 'study_ti1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{NTHM}': n_mod_thm, '{NDECL}': n_mod_decl, '{APART}': apart_text,
             '{RAN}': ran, '{REUSED}': fmt(reused)}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG.startswith(f'{N}-what-training-installs'), SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD71 = line_from(ch0, '- `Training.fit_right_iff` (§3.3): training is selection through the data,')
NEW71 = OLD71 + (
    ' A learner acting in a world is not given its data: they are the courses its own act law generates with '
    'everything else, so a training reading candidates through their courses fixes a law only along them '
    '(`Training.trained_alike_of_along`, §7.7).')
OLDPX = 'and they add nothing about which law training installs (§7.7) or a mechanism of alignment'
NEWPX = ('and they add nothing about which law training installs beyond where it can install one, along the '
         'learner\'s own courses and through what the reward couples into (§7.7), or about a mechanism of alignment')
OLD77 = line_from(ch0, '- **Coupling is not compliance.** Coupling bounds what a member\'s acts respond to, exactly,')
NEW77 = (
    '- **Coupling is not compliance.** Coupling bounds what a member\'s acts respond to, exactly, and fixes nothing '
    'within the bound (`ExchangeLaw.response_not_fixed_by_coupling`). What training can install within it is stated '
    '(TI1, TI2, '
    f'[study §{N}]({SA})), training read as a selection over a learner\'s candidate act laws through the courses each '
    'generates, a situation fixing the others\' law (one realization of their noise), the start and the execution. A '
    'law is installed only along its own courses: candidates giving alike along the first\'s courses generate the '
    'same courses and every training trains them alike (`Training.trained_alike_of_along`), and an explored law only '
    'at the steps left to it (`Training.explored_same_courses`). Off them, a law reading through a lumping of '
    'histories, a representation, is installed exactly where the lumping cannot tell a history from a course, and '
    'elsewhere a law of the class with the same courses takes anything, responding or not '
    '(`Training.installed_where_lumped`, `Training.response_free_where_unlumped`); the coupling and agreement are '
    'cases, the latter saying that nothing is installed off the courses (`Training.response_free_off_courses`). '
    'Through a reward\'s couplings, candidates are trained alike exactly where their levels are alike through them, '
    'and a difference in what the act does is installed only where it reaches what couples into the reward\'s closure '
    '(`Training.trained_alike_iff`, by construction; `Training.settles_apart`, `Training.trained_alike_beyond_closure`). '
    'Among laws a reward settles on, an improving search keeps the one it starts from and under a bounded reward '
    'rests within the bound; a local search rests exactly where no neighbour is rewarded more, so the rests a narrow '
    'neighbourhood adds are its implicit bias (`Training.settled_stays`, `Training.comes_to_rest`, '
    '`Training.LocalSearch.rests_iff`). In a commons the bound is exact: where the others alone outrun the renewal, '
    'a reward adding an end reading at any weight settles exactly where the reward without it settles '
    '(`Training.outrun_settles_iff`; in `Training.Commons`, with the learner coupled into the stock by level, restraint '
    'is settled from weight one where the rest draws within the renewal and at no weight where it outruns it, while a '
    'search whose neighbourhoods do not reach the drawing law keeps restraint there); tabular learners followed that '
    'boundary, while learners that generalize across states reached restraint in three settings where it is no best '
    'response against a harvesting rest (EM1), which the lumping law reads as their representation installing at one '
    'state what the reward selects at another [AI reading, untested] (CG1, CG2, §7.5). What remains is empirical: which lumping an actual system\'s representation makes, '
    'which neighbourhoods its updates search, which law its acts follow, and the evidence for an identified '
    'installation (§7.6, §8.7).')
OLDRS = 'How a member\'s law comes to be and differences at many conditions at once are open (§8.1).'
NEWRS = ('How a member\'s law comes to be off its own courses and differences at many conditions at once are open '
         '(§8.1).')
OLD77R = line_from(ch0, 'Records: [where-two-courses-rejoin](../results/records/where-two-courses-rejoin.md), '
                   '[target-capture](../results/records/target-capture.md)')
NEW77R = OLD77R.removesuffix('.') + ', ' + REC + '.'
OLD81 = ('`ExchangeLaw.Through.anticipated`). *Open:* the law of exchange itself, a law with noise and its course; how '
         'a member\'s law forms and comes to respond to what it couples into; ')
NEW81 = (
    '`ExchangeLaw.Through.anticipated`); and (TI1, TI2, '
    f'[study §{N}]({SA})) training read as a selection over a learner\'s candidate act laws through the courses each '
    'generates: a law is installed only along its own courses, with noise along its realizations and with '
    'exploration at the steps left to it (`ExchangeLaw.levels_agree_of_along`, `Training.trained_alike_of_along`, '
    '`Training.explored_same_courses`); off them, within the laws reading through a lumping of histories, exactly '
    'where the lumping cannot tell a history from a course, free elsewhere, responding or not '
    '(`Training.installed_where_lumped`, `Training.response_free_where_unlumped`); through a reward\'s couplings '
    'exactly where the levels are alike through them and wherever the acts agree on what couples into the reward\'s '
    'closure (`Training.trained_alike_iff`, `Training.trained_alike_beyond_closure`); among settled laws by the '
    'search\'s start and neighbourhoods, within a reward bound (`Training.settled_stays`, `Training.comes_to_rest`, '
    '`Training.LocalSearch.rests_iff`); and where the rest outruns the renewal, a reading after its end, at any '
    'weight, moves no optimum (`Training.outrun_settles_iff`, computed in `Training.Commons`). *Open:* the law of '
    'exchange itself, a law with noise and its course; the lumping and neighbourhoods of an actual system, read '
    'empirically; ')
OLD81R = ('[reading-anothers-couplings-is-pooling](../results/records/reading-anothers-couplings-is-pooling.md).')
line81 = line_from(ch0, '7. **Which law holds, and how a member\'s law comes about** (further proof).')
assert line81.count(OLD81) == 1 and line81.endswith(OLD81R)
NEW81L = line81.replace(OLD81, NEW81).removesuffix('.') + ', ' + REC + '.'
OLDK = 'Results outside the ten: '
NEWK = ('Results outside the ten: training through a learner\'s own courses (`Becoming.Training`) is the on-policy '
        'point of imitation learning (Ross, Gordon and Bagnell 2011), a learner meeting the histories its own law '
        'generates, and the formal kernel of goal misgeneralization (Langosco, Koch, Sharkey, Pfau and Krueger 2022; '
        'Shah et al. 2022), a policy whose behaviour off its training courses the reward did not fix; which of several '
        'settled laws is reached is a basin of the search, the rests a local search adds its implicit bias, and among the basins stochastic stability (Kandori, Mailath and Rob '
        '1993; Young 1993) selects by noise, cited; restraint left '
        'unselected by a reading after the rest\'s end at any weight is pivotality (Palfrey and Rosenthal 1984) read on '
        'a reward; ')
OLDG = ('| training (训练) | Selection through the data: functions agreeing on the data are selected alike. | '
        '`Training.Through`, `Training.loss_through`, `Training.fit_right_iff` |')
NEWG = ('| training (训练) | Selection through the data: functions agreeing on the data are selected alike; for a learner '
        'acting in a world, a selection over act laws through the courses each generates, which fixes a law only '
        'along them. | `Training.Through`, `Training.loss_through`, `Training.fit_right_iff`, '
        '`Training.trained_alike_of_along`, `Training.trained_alike_iff` |')
OLD_ROW = line_from(ch0, '| [What a pool\'s acts respond to](../results/records/what-a-pools-acts-respond-to.md) |') + '\n'
NEW_ROW = (f'| [What training installs](../results/records/{RID}.md) | theorem under stated premises | laws reading what '
           'has stood; trainings reading each candidate through its own courses; for the closure law, reading through '
           'coupling and feasibility; for the outrun law, its premises in every candidate\'s course | §7.1, §7.7 |\n')
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with TI1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
               "check and the core with the ring compiled from the prelude.")
i = ch0.index('| Core modules (with the root `Becoming`, 0 theorems) |')
j = ch0.index('\n', ch0.index('| Generated `injEq` lemmas on `propext` |', i))
OLD_TABLE = ch0[i:j]
NEW_TABLE = f"""| Core modules (with the root `Becoming`, 0 theorems) | {mods['core']} modules, {fmt(thms['core'])} theorems |
| Instance modules | {mods['instance']} modules, {fmt(thms['instance'])} theorems |
| Application modules | {mods['application']} modules, {fmt(thms['application'])} theorems |
| Foundation modules | {mods['foundation']} modules, {thms['foundation']} theorems |
| Closure (core, ring and foundation) | {closure} modules, {fmt(closure_thms)} theorems |
| Spine (the core and the ring; no bridge since F3) | {fmt(spine_thms)} theorems |
| Audited spine declarations | {fmt(spine_decls)} |
| Inherited modules bound to passed receipts by hash | 3 (the foundation) |
| Superseded periphery modules (out of the run, bytes kept) | {len(R['superseded_modules'])} |
| Modules in the compile order | {len(R['compile_order'])} |
| Generated `injEq` lemmas on `propext` | {injeq} in the closure |"""
OLD_STEPS = re.search(r'The run reused [\d,]+ cached Lean steps from `~/.cache/becoming-lean` and ran \d+;', ch0).group(0)
NEW_STEPS = f'The run reused {fmt(reused)} cached Lean steps from `~/.cache/becoming-lean` and ran {ran};'
OLD75 = ('Open: how learners come to one outcome where several are self-consistent; a learner\'s own later acts are '
         'not such a rest, and its failures there are of sampling its own courses')
NEW75 = ('Where several outcomes are self-consistent, each is a rest of every improving search, and under a bounded '
         'reward every search comes to one of them within the bound, so which one learners come to is fixed by where '
         'they start and what their search compares, not by their rewards (`Training.settled_stays`, '
         '`Training.comes_to_rest`, `Training.LocalSearch.rests_iff`, TI1, TI2); which basin CG1\'s and CG2\'s '
         'learners lie in under their own update laws is empirical; a learner\'s own later acts are not such a rest, '
         'and its failures there are of sampling its own courses')
pairs = [(OLD75, NEW75), (OLD71, NEW71), (OLDPX, NEWPX), (OLD77, NEW77), (OLDRS, NEWRS), (OLD77R, NEW77R), (line81, NEW81L),
         (OLDK, NEWK), (OLDG, NEWG), (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE),
         (OLD_STEPS, NEW_STEPS)]
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0)
if OLD_CORE:
    new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
    if OLD_CORE.group(0) != new_core:
        pairs.append((OLD_CORE.group(0), new_core))
L2m = re.search(r'L2, the (\d+) modules whose source names the condition', ch0)
OLD_L1m = re.search(r'L1, the other (\d+) of the core,', ch0)
if L2m and OLD_L1m:
    L1 = mods['core'] - 1 - 3 - int(L2m.group(1))
    if OLD_L1m.group(0) != f'L1, the other {L1} of the core,':
        pairs.append((OLD_L1m.group(0), f'L1, the other {L1} of the core,'))
edit(CH, pairs)

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ71 = '**定理。** 本节陈述 `Web.selects_alike_iff`、`Training.fit_right_iff`、`apart_only_downstream`；'
NEWZ71 = ('**定理。** 本节陈述 `Web.selects_alike_iff`、`Training.fit_right_iff`（在世界中行动的学习者，其数据是它自己的动作律'
          '与其余一切所生成的进程，所以经进程读候选的训练只沿这些进程确定一个律，`Training.trained_alike_of_along`，§7.7）、'
          '`apart_only_downstream`；')
OLDZ77R = ('记录：[where-two-courses-rejoin](../results/records/where-two-courses-rejoin.md)、'
           '[target-capture](../results/records/target-capture.md)。')
NEWZ77R = OLDZ77R.removesuffix('。') + f'、[{RID}](../results/records/{RID}.md)。'
OLDZ81 = ('`ExchangeLaw.Through.anticipated`）。*开放：*交换之律本身，带噪声的律及其历程；成员的律怎样形成、怎样回应它所耦合'
          '入者；')
NEWZ81 = (f'`ExchangeLaw.Through.anticipated`）；以及（TI1、TI2，[研究第 {N} 节]({SA})）把训练读作对学习者候选动作律的选择，'
          '经每个候选所生成的进程：一个律只沿它自己的进程被安装，有噪声时沿其实现，有探索时只在留给它的步上（`ExchangeLaw.levels_agree_of_along`、'
          '`Training.trained_alike_of_along`、`Training.explored_same_courses`）；在进程之外，在经历史之归并而读的律中，恰在归并不能把一段历史'
          '与某个进程分开之处被安装，其余处自由，回应与否皆可（`Training.installed_where_lumped`、`Training.response_free_where_unlumped`）；'
          '经奖励的耦合，恰在水平经其无别之处、以及动作在耦合入奖励闭包者上一致之处被训练得相同（`Training.trained_alike_iff`、'
          '`Training.trained_alike_beyond_closure`）；在被选定的律中，由搜索的起点与邻域决定，在奖励之界内（`Training.settled_stays`、'
          '`Training.comes_to_rest`、`Training.LocalSearch.rests_iff`）；其余者超出更新时，在其终止之后对条件的读数，任何权重下都不移动最优'
          '（`Training.outrun_settles_iff`，在 `Training.Commons` 中算出）。*开放：*交换之律本身，带噪声的律及其历程；实际系统的归并与邻域，'
          '经验地读出；')
OLDZG = ('| 训练（training） | 经数据的选择：在数据上一致的函数被选得相同。 | `Training.Through`、`Training.loss_through`、'
         '`Training.fit_right_iff` |')
NEWZG = ('| 训练（training） | 经数据的选择：在数据上一致的函数被选得相同；对在世界中行动的学习者，是对动作律的选择，经每个律所'
         '生成的进程，只沿这些进程确定一个律。 | `Training.Through`、`Training.loss_through`、`Training.fit_right_iff`、'
         '`Training.trained_alike_of_along`、`Training.trained_alike_iff` |')
OLDZROW = line_from(z, '| [一组的动作回应什么](../results/records/what-a-pools-acts-respond-to.md) |') + '\n'
NEWZROW = (f'| [训练安装什么](../results/records/{RID}.md) | 在所述前提下的定理 | 读已立者的律；经每个候选自身的进程读它的训练；'
           '闭包之律需经耦合而读与可行；超出之律需每个候选进程中的其前提 | §7.1、§7.7 |\n')
OLDZR = line_from(z, '**当前回执**是运行 [`')
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SA})）。")
i = z.index('| 核心模块（含根 `Becoming`） |')
j = z.index('\n', z.index('| 被取代的外围模块', i))
OLDZT = z[i:j]
NEWZT = f"""| 核心模块（含根 `Becoming`） | {mods['core']} 个模块，{fmt(thms['core'])} 条定理 |
| 实例模块 | {mods['instance']} 个模块，{fmt(thms['instance'])} 条定理 |
| 应用模块 | {mods['application']} 个模块，{fmt(thms['application'])} 条定理 |
| 根基模块 | {mods['foundation']} 个模块，{thms['foundation']} 条定理 |
| 闭包（核心、环与根基） | {closure} 个模块，{fmt(closure_thms)} 条定理 |
| 审计的脊柱声明 | {fmt(spine_decls)} |
| 在 `propext` 上的生成的 `injEq` 引理 | 闭包中 {injeq} 条 |
| 被取代的外围模块（不在运行中，字节保留） | {len(R['superseded_modules'])} |"""
edit(ZH, [(OLDZ71, NEWZ71), (OLDZ77R, NEWZ77R), (OLDZ81, NEWZ81), (OLDZG, NEWZG), (OLDZROW, OLDZROW + NEWZROW),
          (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
hist = history.split('\n')
for item in ('TI1: what training installs**', 'TI2: what training installs, the remainder**'):
    rows = [i for i, line in enumerate(lines) if line.startswith('| **' + item)]
    assert len(rows) == 1, (item, rows)
    row = lines.pop(rows[0])
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed 2026-10-22 with TI1 and TI2 together, core receipt `{receipt_id}`; new core module '
                f'Becoming.Training, {n_mod_thm} theorems in {n_mod_decl} declarations, empty axiom reports; record '
                f'{RID}; study §{N}')
    row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
    stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
    lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
    hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is TI1's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('TI1 ') and not p.startswith('TI2 ')]
landed = (f'TI1 and TI2 landed (what training installs: training read as a selection over a learner\'s candidate act '
          f'laws through the courses each generates; a law installed only along its own courses, with noise along its '
          f'realizations, with exploration at the steps left to it, off them exactly as far as its representation '
          f'lumps; through a reward\'s couplings exactly where the levels are alike through them; among settled laws '
          f'the search\'s start and neighbourhoods, within a reward bound; a reading after the rest\'s end moves no '
          f'optimum at any weight, CG2\'s X2 computed; `Becoming.Training`, core receipt `{receipt_id}`, study §{N}, '
          f'rows in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
