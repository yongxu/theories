#!/usr/bin/env python3
"""SG7 landing text: the study section, the significance review's stepwise check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's coupling a step no horizon outweighs, T3's standing, section 8.1 item 10,
the relation-to-known-results row 6, the record table and section 9's receipt, counts and audit sentence) and the board
row moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT
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
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Optimum'
RID = 'a-step-coupling-keeps-at-every-horizon'
SG6 = 'keeping-forgoes-the-renewal-at-the-need'
SA293 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#293-what-keeping-a-dependence-forgoes-over-a-horizon-sg6')
receipt_id, conn_log, base, previous = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]


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
P = json.loads(Path(previous).read_text())
om = next(m for m in R['modules'] if m['module'] == MOD)
pm = next(m for m in P['modules'] if m['module'] == MOD)
old_names = {d['name'] for d in pm['declarations']}
new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
assert old_names <= {d['name'] for d in om['declarations']}, 'a declaration was removed'
n_new_thms = om['theorems'] - pm['theorems']
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

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the flow and '
              'the web or used by one that is, the witnesses through the general laws; register check passes')
study = (HERE / 'study_sg7.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_new_thms, '{DECLS}': len(new_decls),
             '{OLD}': len(pm['declarations']), '{TOTAL}': len(om['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-a-coupling-added-for-each-step-a-dependence-is-kept-sg7', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG6}](../results/records/{SG6}.md)'

# Significance review: the stepwise check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="stepwise-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg7.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = '`logistic_coupled`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('`logistic_coupled`). Added instead for each step the need stays met from the start, a coupling `c` does not '
         'erode so: a course met through `j` steps draws, with `r` for each of them, at most the start with what is '
         'given there, `r` a step and `q` for each of them (`Optimum.met_drawn_le`, `Flow.Balances.met_taken_le`), so '
         'every optimum of every order rising with the worth keeps the need through every horizon where `r ≤ q + c` and '
         '`c` exceeds the end the keeping course reaches (`Optimum.frontier_keeps_stepwise`, '
         '`Web.frontier_keeps_stepwise`), and meets it to the last step where `r < q + c` '
         '(`Optimum.frontier_met_before_end`, `Web.frontier_met_before_end`); where `c` with the end the capacity '
         'reaches is below the need, the horizon\'s end breaks the dependence, at the last step alone where also '
         '`r < q + c` (`Optimum.frontier_breaks_at_end`, `Web.frontier_breaks_at_end`, `Web.frontier_breaks_last`); '
         'where `q + c < r` a long horizon outweighs it (`Optimum.outweighed_stepwise`, '
         '`Web.frontier_breaks_stepwise_long`); optima exist in every case (`Optimum.continued_stepwise_frontier`, '
         '`Optimum.continued_ending_stepwise_frontier`, `Optimum.continued_holding_stepwise_frontier`; in '
         '`Optimum.Holding`, under the logistic law three a step keeps the dweller at every horizon, two a step to the '
         'last step, and at most one a step breaks it, `logistic_stepwise`). Where the eligible outcomes are supplied '
         'otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'`Web.frontier_breaks_long`, SG6, [study §293]({SA293}));'
NEW71 = (OLD71 + ' a coupling added instead for each step the dependence is kept is not outrun: at a rate covering the '
         'renewal forgone at the need a step and above the need it keeps the dependence at every horizon, and below the '
         'need the horizon\'s end breaks it, at the last step alone where the rate is exceeded '
         '(`Optimum.frontier_keeps_stepwise`, `Optimum.frontier_met_before_end`, `Web.frontier_breaks_last`, SG7, '
         f'[study §{N}]({SA}));')
OLDT3S = 'which grows with the horizon (`Optimum.frontier_breaks_below`, `Web.frontier_breaks_long`);'
NEWT3S = ('which grows with the horizon (`Optimum.frontier_breaks_below`, `Web.frontier_breaks_long`), while a coupling a '
          'step covering the renewal forgone a step and exceeding the need keeps it at every horizon '
          '(`Optimum.frontier_keeps_stepwise`, `Web.frontier_keeps_stepwise`);')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = ('`Web.frontier_breaks_long`). *Open:* an order valuing what is left at the horizon or discounting later draws, '
          'the optimum where no level of greatest renewal is within reach, a coupling added step by step rather than '
          'for the whole keeping, several optimizers')
NEW10a = (f'`Web.frontier_breaks_long`). Landed (SG7, [study §{N}]({SA})): a coupling added for each step the dependence '
          'is kept keeps it at every horizon where it covers the renewal forgone a step and exceeds the need; below the '
          'need the horizon\'s end breaks it, at the last step alone where the coupling exceeds the renewal forgone a '
          'step; below the renewal forgone a long horizon outweighs it (`Optimum.frontier_keeps_stepwise`, '
          '`Optimum.frontier_met_before_end`, `Web.frontier_breaks_last`, `Web.frontier_breaks_stepwise_long`). '
          '*Open:* an order valuing what is left at the horizon or discounting later draws, the optimum where no level '
          'of greatest renewal is within reach, steps met again after a fall, several optimizers')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10c, NEW10c)
OLD6K = 'Tadepalli 2020) |'
NEW6K = 'Tadepalli 2020); the end-game effect of finitely repeated play (Luce and Raiffa 1957; Selten 1978) |'
OLD6 = '`Optimum.frontier_keeps_above`, `Web.frontier_breaks_long`) |'
NEW6 = ('`Optimum.frontier_keeps_above`, `Web.frontier_breaks_long`), and a coupling a step keeping it at every horizon '
        'at the renewal forgone a step, the horizon\'s end breaking it at the last step alone '
        '(`Optimum.frontier_keeps_stepwise`, `Web.frontier_breaks_last`) |')
OLD_ROW = line_from(ch0, f'| [Keeping a dependence forgoes the renewal at its need](../results/records/{SG6}.md) |') + '\n'
NEW_ROW = (f'| [A coupling a step keeps a dependence at every horizon](../results/records/{RID}.md) | theorem under stated '
           'premises | courses open from a start, ranked over a horizon of at least two steps by an order rising with a '
           'worth bounded by what is drawn and a coupling for each step a need stays met from the start; a renewal '
           'given by a law of the level, at most `r`, at most `q` at or above the need, `q` (or `r`) at a level within '
           'reach; capacities covering the first step\'s draw down to the level held and that level with its renewal '
           'down to the end; for the web laws, a dependence at the need at every step, met at the start | §3.4, §7.1, '
           '§8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG7 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD34, NEW34), (OLD34R, NEW34R), (OLD71, NEW71), (OLDT3S, NEWT3S), (OLD10, NEW10),
          (OLD6K, NEW6K), (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '逻辑斯谛律下把居者保持 `n + 2` 步放弃 `n + 3`，`logistic_coupled`）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_keeps_stepwise`（耦合改为在所需从起点起每被满足一步加 `c` 时不再被侵蚀：在所需之上维持 `j` 步的进程，'
          '加上这些步每步 `r`，所抽取至多是起点加那里所给、每步 `r` 与这些步每步 `q`，`Optimum.met_drawn_le`、`Flow.Balances.met_taken_le`；'
          '故 `r ≤ q + c` 且 `c` 超过保持的过程可及的终点时，随该值升高之序的每个最优在每个视野都保持所需，`Web.frontier_keeps_stepwise`；'
          '`r < q + c` 时保持到最后一步，`Optimum.frontier_met_before_end`、`Web.frontier_met_before_end`；`c` 加容量可及的终点低于所需时，'
          '视野之末打破依存，`r < q + c` 时只在最后一步，`Optimum.frontier_breaks_at_end`、`Web.frontier_breaks_at_end`、'
          '`Web.frontier_breaks_last`；`q + c < r` 时长视野压过它，`Optimum.outweighed_stepwise`、`Web.frontier_breaks_stepwise_long`；'
          '每种情形都有最优，`Optimum.continued_stepwise_frontier`、`Optimum.continued_ending_stepwise_frontier`、'
          '`Optimum.continued_holding_stepwise_frontier`；在 `Optimum.Holding` 中，逻辑斯谛律下每步三在每个视野都保持居者，每步二保持到最后一步，'
          '每步至多一则打破它，`logistic_stepwise`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'`Web.frontier_breaks_long`，SG6，[研究第 293 节]({SA293})）；'
NEWZ71 = (OLDZ71 + '改为每保持一步加入的耦合则不被超过：其速率覆盖所需处每步放弃的更新且高于所需时，它在每个视野都保持依存；低于所需时视野之末打破它，'
          '速率被超过时只在最后一步（`Optimum.frontier_keeps_stepwise`、`Optimum.frontier_met_before_end`、`Web.frontier_breaks_last`，'
          f'SG7，[研究第 {N} 节]({SA})）；')
OLDZT3 = '而此量随视野增长（`Optimum.frontier_breaks_below`、`Web.frontier_breaks_long`）；'
NEWZT3 = ('而此量随视野增长（`Optimum.frontier_breaks_below`、`Web.frontier_breaks_long`），而覆盖每步放弃的更新且高于所需的每步耦合在每个视野'
          '都保持它（`Optimum.frontier_keeps_stepwise`、`Web.frontier_keeps_stepwise`）；')
OLDZ10a = ('`Web.frontier_breaks_long`）。*开放：*对视野末所留赋值或对后来汲取折现之序、没有可及的最大更新水平时的最优、'
           '按步而非对整个保持加入的耦合、')
NEWZ10a = (f'`Web.frontier_breaks_long`）。已落地（SG7，[研究第 {N} 节]({SA})）：每保持依存一步加入的耦合，覆盖每步放弃的更新且高于所需时在每个视野'
           '都保持它；低于所需时视野之末打破它，耦合超过每步放弃的更新时只在最后一步；低于每步放弃的更新时长视野压过它'
           '（`Optimum.frontier_keeps_stepwise`、`Optimum.frontier_met_before_end`、`Web.frontier_breaks_last`、'
           '`Web.frontier_breaks_stepwise_long`）。*开放：*对视野末所留赋值或对后来汲取折现之序、没有可及的最大更新水平时的最优、'
           '跌落后再被满足的步、')
OLDZ6K = 'Tadepalli 2020） |'
NEWZ6K = 'Tadepalli 2020）；有限重复博弈的终局效应（Luce 与 Raiffa 1957；Selten 1978） |'
OLDZ6 = '`Optimum.frontier_keeps_above`、`Web.frontier_breaks_long`） |'
NEWZ6 = ('`Optimum.frontier_keeps_above`、`Web.frontier_breaks_long`），每步的耦合以每步放弃的更新为率在每个视野都保持它，视野之末只在'
         '最后一步打破它（`Optimum.frontier_keeps_stepwise`、`Web.frontier_breaks_last`） |')
OLDZROW = line_from(z, f'| [保持依存放弃其所需处的更新](../results/records/{SG6}.md) |') + '\n'
NEWZROW = (f'| [每步的耦合在每个视野都保持依存](../results/records/{RID}.md) | 在所述前提下的定理 | 自起点开放的过程，在至少两步的视野上按随一个值'
           '升高之序排序，该值以所汲取与所需从起点起每被满足一步的耦合为界；由水平之律给出的更新，至多 `r`，不低于所需处至多 `q`，`q`（或 `r`）'
           '在可及的水平处取得；容量足以在第一步降到所保持的水平并承担它加其更新降到终点；对网之律，每步需要处的依存，起始时被满足 | '
           '§3.4、§7.1、§8.1 |\n')
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
edit(ZH, [(OLDZ34, NEWZ34), (OLDZ34R, NEWZ34R), (OLDZ71, NEWZ71), (OLDZT3, NEWZT3), (OLDZ10a, NEWZ10a),
          (OLDZ6K, NEWZ6K), (OLDZ6, NEWZ6), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls)})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
