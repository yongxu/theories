#!/usr/bin/env python3
"""SG6 landing text: the study section, the significance review's keeping check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's coupling a far-sighted optimizer outweighs, T3's standing, section 8.1 item 10,
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
RID = 'keeping-forgoes-the-renewal-at-the-need'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SA292 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#292-courses-ranked-over-a-horizon-sg5')
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
study = (HERE / 'study_sg6.txt').read_text(encoding='utf-8')
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
assert SLUG == f'{N}-what-keeping-a-dependence-forgoes-over-a-horizon-sg6', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG5}](../results/records/{SG5}.md)'

# Significance review: the keeping check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="keeping-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg6.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = 'both optima, taking the same, `gated_alike`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('both optima, taking the same, `gated_alike`). Kept at a need `m` through the horizon, where what is given at or '
         'above `m` is at most `q`, a course draws, with what it leaves, at most the start with what is given there and '
         '`q` a step (`Optimum.keeping_le_most`, `Flow.Balances.keeping_taken_le`), and every optimum among the keeping '
         'courses of every order rising with the draw holds where `q` is given and leaves exactly `m` '
         '(`Optimum.frontier_keeps`, `Web.frontier_keeps`; attained, `Optimum.continued_keeping_frontier`); so keeping '
         'forgoes, against the course holding a level of greatest renewal and leaving nothing, `(r − q) n + m`, the '
         'renewal given up at the need for each step and the need left at the end. An order adding to what a keeping '
         'course draws a coupling below that has only optima breaking the dependence within the horizon, one adding '
         'more to a keeping course and nothing to a course falling below the need only optima keeping it, and both have '
         'optima (`Optimum.frontier_breaks_below`, `Optimum.frontier_keeps_above`, `Web.frontier_breaks_below`, '
         '`Web.frontier_keeps_above`, `Optimum.continued_breaking_frontier`, `Optimum.continued_kept_frontier`); where '
         'the capacity cannot draw down to nothing or to the need, the end it reaches enters the thresholds. Where '
         '`q < r` the amount grows with the horizon and outweighs every coupling short of the horizon with the need '
         '(`Optimum.forgone_grows`, `Web.frontier_breaks_long`; in `Optimum.Holding`, under the logistic law keeping '
         'the dweller through `n + 2` steps forgoes `n + 3`, `logistic_coupled`). Where the eligible outcomes are '
         'supplied otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'`Optimum.Holding.gated_alike`, SG5, [study §292]({SA292}));'
NEW71 = (OLD71 + ' a coupling of such a dependence into the order keeps it exactly where it exceeds what keeping '
         'forgoes, the renewal given up at the need for each step and the need left at the end, an amount that grows '
         'with the horizon where the need lies above every level of greatest renewal, so that far-sight outweighs every '
         'coupling fixed in total (`Optimum.frontier_breaks_below`, `Optimum.frontier_keeps_above`, '
         f'`Web.frontier_breaks_long`, SG6, [study §{N}]({SA}));')
OLDT3S = ('over a horizon, a dependence above every level of greatest renewal broken at the first step '
          '(`Optimum.frontier_holds`, `Web.frontier_broken`);')
NEWT3S = ('over a horizon, a dependence above every level of greatest renewal broken at the first step '
          '(`Optimum.frontier_holds`, `Web.frontier_broken`), and with a coupling of the dependence broken within the '
          'horizon by every optimum wherever the coupling falls short of what keeping forgoes, which grows with the '
          'horizon (`Optimum.frontier_breaks_below`, `Web.frontier_breaks_long`);')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = ('*Open:* an order valuing what is left at the horizon or discounting later draws, the optimum where no level of '
          'greatest renewal is within reach, several optimizers ranking courses, and how optimizers come to a mutual '
          'best response;')
NEW10a = (f'Landed (SG6, [study §{N}]({SA})): what keeping a dependence forgoes over a horizon: where what is given at or '
          'above the need is at most `q`, keeping forgoes, against the course holding the greatest renewal `r` and '
          'leaving nothing, `(r − q) n` and the need; a coupling of the dependence below that leaves only optima '
          'breaking it within the horizon, one beyond it only optima keeping it, both with optima, and where the need '
          'lies above every level of greatest renewal the amount grows with the horizon (`Optimum.frontier_keeps`, '
          '`Optimum.frontier_breaks_below`, `Optimum.frontier_keeps_above`, `Web.frontier_breaks_long`). *Open:* an '
          'order valuing what is left at the horizon or discounting later draws, the optimum where no level of greatest '
          'renewal is within reach, a coupling added step by step rather than for the whole keeping, several optimizers '
          'ranking courses, and how optimizers come to a mutual best response;')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10c, NEW10c)
OLD6K = 'Scott 1955; Clark 1976) |'
NEW6K = ('Scott 1955; Clark 1976); the yield given up to leave a prey for its predators (May and others 1979; Pikitch '
         'and others 2012) and impact penalties for side effects (Krakovna and others 2019; Turner, Hadfield-Menell and '
         'Tadepalli 2020) |')
OLD6 = 'breaking at the first step a dependence above every such level (`Optimum.frontier_holds`, `Web.frontier_broken`) |'
NEW6 = ('breaking at the first step a dependence above every such level (`Optimum.frontier_holds`, `Web.frontier_broken`), '
        'and a coupling of the dependence keeping it exactly beyond what keeping forgoes, which grows with the horizon '
        'where the need lies above every level of greatest renewal (`Optimum.frontier_breaks_below`, '
        '`Optimum.frontier_keeps_above`, `Web.frontier_breaks_long`) |')
OLD_ROW = line_from(ch0, f'| [Over a horizon, optima hold the greatest renewal](../results/records/{SG5}.md) |') + '\n'
NEW_ROW = (f'| [Keeping a dependence forgoes the renewal at its need](../results/records/{RID}.md) | theorem under stated '
           'premises | courses open from a start, ranked over a horizon of at least two steps by an order rising with '
           'what is drawn, or with what is drawn and a coupling of keeping a need through the horizon; a renewal given by '
           'a law of the level, at most `r`, at most `q` at or above the need, `r` and `q` at levels within reach; '
           'capacities covering the first step\'s draw down to the level held and that level with its renewal down to '
           'the end; for the web laws, a dependence at the need at every step, met at the start | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG6 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLDZ34 = '被它们都满足的依存保持到视野最后一步并在其末被打破，`Web.frontier_kept`）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_breaks_below`（在视野内把条件保持在所需 `m` 之上、不低于 `m` 处所给至多 `q` 时，过程所汲取加所留至多是起始加那里所给与每步 '
          '`q`，`Optimum.keeping_le_most`、`Flow.Balances.keeping_taken_le`；保持的过程中随汲取升高之序的每个最优都停在给出 `q` 的水平、终点恰留 `m`，'
          '`Optimum.frontier_keeps`、`Web.frontier_keeps`，且有这样的最优，`Optimum.continued_keeping_frontier`；故相对于保持在最大更新、终了不留的过程，'
          '保持放弃 `(r − q) n + m`，即所需处每步放弃的更新与终了所留的所需：对保持的过程所加耦合低于此量时只有在视野内打破依存的最优，'
          '对保持的过程加得更多、对落到所需之下的过程不加时只有保持它的最优，两者都有最优，`Optimum.frontier_keeps_above`、`Web.frontier_breaks_below`、'
          '`Web.frontier_keeps_above`、`Optimum.continued_breaking_frontier`、`Optimum.continued_kept_frontier`；容量不能降到零或所需时，它可及的终点进入阈值；'
          '`q < r` 时此量随视野增长，胜过每个短于视野加所需的耦合，`Optimum.forgone_grows`、`Web.frontier_breaks_long`；在 `Optimum.Holding` 中，'
          '逻辑斯谛律下把居者保持 `n + 2` 步放弃 `n + 3`，`logistic_coupled`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'`Optimum.Holding.gated_alike`，SG5，[研究第 292 节]({SA292})）；'
NEWZ71 = (OLDZ71 + '把这样的依存耦合进序时，恰在耦合超过保持所放弃者时它被保持：所放弃者即所需处每步放弃的更新与终了所留的所需，所需高于每个最大更新的水平时'
          '此量随视野增长，故远见胜过每个总量固定的耦合（`Optimum.frontier_breaks_below`、`Optimum.frontier_keeps_above`、`Web.frontier_breaks_long`，'
          f'SG6，[研究第 {N} 节]({SA})）；')
OLDZT3 = '高于每个最大更新水平的依存在第一步被打破（`Optimum.frontier_holds`、`Web.frontier_broken`）；'
NEWZT3 = ('高于每个最大更新水平的依存在第一步被打破（`Optimum.frontier_holds`、`Web.frontier_broken`），带有对依存的耦合时，耦合不及保持所放弃者处'
          '每个最优都在视野内打破它，而此量随视野增长（`Optimum.frontier_breaks_below`、`Web.frontier_breaks_long`）；')
OLDZ10a = ('*开放：*对视野末所留赋值或对后来汲取折现之序、没有可及的最大更新水平时的最优、多个对过程排序的优化者、优化者如何达到相互最优回应；')
NEWZ10a = (f'已落地（SG6，[研究第 {N} 节]({SA})）：在视野上保持依存所放弃者：不低于所需处所给至多 `q` 时，相对于保持在最大更新 `r`、终了不留的过程，'
           '保持放弃 `(r − q) n` 加所需；对依存的耦合低于此量时只有在视野内打破它的最优，高于此量时只有保持它的最优，两者都有最优；所需高于每个最大更新'
           '的水平时此量随视野增长（`Optimum.frontier_keeps`、`Optimum.frontier_breaks_below`、`Optimum.frontier_keeps_above`、`Web.frontier_breaks_long`）。'
           '*开放：*对视野末所留赋值或对后来汲取折现之序、没有可及的最大更新水平时的最优、按步而非对整个保持加入的耦合、多个对过程排序的优化者、'
           '优化者如何达到相互最优回应；')
OLDZ6K = 'Scott 1955；Clark 1976） |'
NEWZ6K = ('Scott 1955；Clark 1976）；为捕食者留下猎物所放弃的产量（May 等 1979；Pikitch 等 2012）与副作用的影响惩罚（Krakovna 等 2019；'
          'Turner、Hadfield-Menell 与 Tadepalli 2020） |')
OLDZ6 = '在第一步打破高于每个这样水平的依存（`Optimum.frontier_holds`、`Web.frontier_broken`） |'
NEWZ6 = ('在第一步打破高于每个这样水平的依存（`Optimum.frontier_holds`、`Web.frontier_broken`），对依存的耦合恰在超过保持所放弃者时保持它，'
         '所需高于每个最大更新的水平时此量随视野增长（`Optimum.frontier_breaks_below`、`Optimum.frontier_keeps_above`、`Web.frontier_breaks_long`） |')
OLDZROW = line_from(z, f'| [在视野上，最优保持在最大更新处](../results/records/{SG5}.md) |') + '\n'
NEWZROW = (f'| [保持依存放弃其所需处的更新](../results/records/{RID}.md) | 在所述前提下的定理 | 自起点开放的过程，在至少两步的视野上按随所汲取、'
           '或随所汲取与在视野内保持需要的耦合升高之序排序；由水平之律给出的更新，至多 `r`，不低于所需处至多 `q`，`r` 与 `q` 在可及的水平处取得；'
           '容量足以在第一步降到所保持的水平并承担它加其更新降到终点；对网之律，每步需要处的依存，起始时被满足 | §3.4、§7.1、§8.1 |\n')
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
