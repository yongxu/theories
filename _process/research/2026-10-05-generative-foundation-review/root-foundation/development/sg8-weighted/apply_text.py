#!/usr/bin/env python3
"""SG8 landing text: the study section, the significance review's weighted check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's far-sight bounded by the weighting, T3's standing, section 8.1 item 10, the
relation-to-known-results row 6, the record table and section 9's receipt, counts and audit sentence) and the board
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
RID = 'a-weighting-faster-than-renewal-ends-the-base'
SG7 = 'a-step-coupling-keeps-at-every-horizon'
SA294 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#294-a-coupling-added-for-each-step-a-dependence-is-kept-sg7')
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
study = (HERE / 'study_sg8.txt').read_text(encoding='utf-8')
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
assert SLUG == f'{N}-an-order-weighting-later-draws-less-sg8', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG7}](../results/records/{SG7}.md)'

# Significance review: the weighted check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="weighted-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg8.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = '`logistic_stepwise`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('`logistic_stepwise`). Where the order weights the draw of the step from `t` by `w t`, any weighting, what a '
         'course could draw at a step, with what it drew before, changes by what the level it leaves gains, `w (t + 1)` '
         'on it with its renewal against `w t` on it held (`Optimum.drawable_step`); so every optimum of every order '
         'rising with the weighted draw gains at each step what an open course of greatest weighted gain leaving nothing '
         'gains, and leaves nothing weighted (`Optimum.frontier_gains_weighted`, `Optimum.weighted_frontier`), breaking '
         'at the first step a dependence above every level of greatest weighted gain '
         '(`Web.frontier_broken_weighted`); where the weighting falls faster than every positive level renews, '
         '`w (t + 1) (z + R z) < w t z`, every optimum ends its own base at the first step, breaking every dependence '
         'on it (`Optimum.frontier_exhausts`, `Web.frontier_exhausts`), and where some level within reach renews '
         'faster, none does (`Optimum.frontier_leaves`, `Web.frontier_leaves`; in `Optimum.Holding`, under the logistic '
         'law a weighting falling more than twofold a step ends the source, less than twofold holds it at one, and at '
         'twofold both are optima, `logistic_weighted`). Where the eligible outcomes are supplied otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'`Web.frontier_breaks_last`, SG7, [study §294]({SA294}));'
NEW71 = (OLD71 + ' and far-sight keeps even the optimizer\'s own base only where its order weights later draws by at '
         'least what the base returns: a weighting falling faster than every positive level renews has every optimum '
         'end the base at the first step, however long the horizon, as a discount rate above the greatest rate of '
         'renewal makes extinction optimal (`Optimum.frontier_exhausts`, `Web.frontier_exhausts`, '
         f'`Optimum.frontier_leaves`, SG8, [study §{N}]({SA}));')
OLDT3S = ('while a coupling a step covering the renewal forgone a step and exceeding the need keeps it at every horizon '
          '(`Optimum.frontier_keeps_stepwise`, `Web.frontier_keeps_stepwise`);')
NEWT3S = ('while a coupling a step covering the renewal forgone a step and exceeding the need keeps it at every horizon '
          '(`Optimum.frontier_keeps_stepwise`, `Web.frontier_keeps_stepwise`), and under an order weighting later draws '
          'less, falling faster than every positive level renews, every optimum ends even its own base at the first '
          'step (`Optimum.frontier_exhausts`, `Web.frontier_exhausts`);')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = ('`Web.frontier_breaks_stepwise_long`). *Open:* an order valuing what is left at the horizon or discounting '
          'later draws, the optimum where no level of greatest renewal is within reach, steps met again after a fall, '
          'several optimizers')
NEW10a = (f'`Web.frontier_breaks_stepwise_long`). Landed (SG8, [study §{N}]({SA})): under an order weighting later draws '
          'less, every optimum gains at each step what a course of greatest weighted gain does; where the weighting '
          'falls faster than every positive level renews, every optimum ends its own base at the first step, and where '
          'some level within reach renews faster, none does (`Optimum.frontier_gains_weighted`, '
          '`Optimum.frontier_exhausts`, `Web.frontier_exhausts`, `Optimum.frontier_leaves`). *Open:* an order valuing '
          'what is left at the horizon, the optimum where no level of greatest renewal or weighted gain is within '
          'reach, steps met again after a fall, several optimizers')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10c, NEW10c)
OLD6K = '(Luce and Raiffa 1957; Selten 1978) |'
NEW6K = ('(Luce and Raiffa 1957; Selten 1978); discounting, the modified golden rule and optimal extinction (Ramsey '
         '1928; Clark 1973; Clark and Munro 1975) |')
OLD6 = '(`Optimum.frontier_keeps_stepwise`, `Web.frontier_breaks_last`) |'
NEW6 = ('(`Optimum.frontier_keeps_stepwise`, `Web.frontier_breaks_last`), and under an order weighting later draws less '
        'every optimum gaining what a course of greatest weighted gain does, ending its own base at the first step '
        'where the weighting falls faster than every positive level renews (`Optimum.frontier_gains_weighted`, '
        '`Web.frontier_exhausts`) |')
OLD_ROW = line_from(ch0, f'| [A coupling a step keeps a dependence at every horizon](../results/records/{SG7}.md) |') + '\n'
NEW_ROW = (f'| [A weighting falling faster than renewal ends the base](../results/records/{RID}.md) | theorem under stated '
           'premises | courses open from a start, ranked over a horizon of at least two steps by an order rising with '
           'what is drawn, the draw of each step weighted by a natural weight; a renewal given by a law of the level; '
           'an open reference course leaving nothing whose level gains the most at each step, or the weighting falling '
           'faster than every positive level renews, or a level within reach renewing faster with nothing given at '
           'nothing; capacities covering the first step\'s draw; for the web laws, a dependence met at the start | '
           '§3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG8 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLDZ34 = '每步至多一则打破它，`logistic_stepwise`）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_gains_weighted`（以 `w t` 加权自 `t` 起一步的抽取，任意权重：进程在一步可抽取的连同之前所抽取的，'
          '逐步变化的量是它留下的水平的增益，`w (t + 1)` 乘该水平加其更新对 `w t` 乘该水平，`Optimum.drawable_step`；故随加权抽取升高之序的每个最优'
          '每步增益等于一个开放、最后不留、加权增益最大的进程的增益，且最后不留加权之物，`Optimum.weighted_frontier`，在第一步打破所需高于每个最大加权增益水平的依存，'
          '`Web.frontier_broken_weighted`；权重下降快于每个正水平的更新，`w (t + 1) (z + R z) < w t z` 时，每个最优在第一步终结自己的基础、'
          '打破对它的每个依存，`Optimum.frontier_exhausts`、`Web.frontier_exhausts`；可及的某水平更新更快时没有最优这样做，'
          '`Optimum.frontier_leaves`、`Web.frontier_leaves`；在 `Optimum.Holding` 中，逻辑斯谛律下权重每步下降超过两倍时终结源，不到两倍时保持在一，'
          '恰为两倍时两者都是最优，`logistic_weighted`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'`Web.frontier_breaks_last`，SG7，[研究第 294 节]({SA294})）；'
NEWZ71 = (OLDZ71 + '而远见只在序对后来汲取的加权不低于基础的回报时才保住优化者自身的基础：权重下降快于每个正水平的更新时，无论视野多长，每个最优都在第一步终结基础，'
          '正如折现率高于最大更新率使灭绝成为最优（`Optimum.frontier_exhausts`、`Web.frontier_exhausts`、`Optimum.frontier_leaves`，'
          f'SG8，[研究第 {N} 节]({SA})）；')
OLDZT3 = ('而覆盖每步放弃的更新且高于所需的每步耦合在每个视野都保持它（`Optimum.frontier_keeps_stepwise`、`Web.frontier_keeps_stepwise`）；')
NEWZT3 = ('而覆盖每步放弃的更新且高于所需的每步耦合在每个视野都保持它（`Optimum.frontier_keeps_stepwise`、`Web.frontier_keeps_stepwise`），'
          '而在后来的汲取权重更小之序下，权重下降快于每个正水平的更新时，每个最优甚至在第一步终结自己的基础（`Optimum.frontier_exhausts`、'
          '`Web.frontier_exhausts`）；')
OLDZ10a = ('`Web.frontier_breaks_stepwise_long`）。*开放：*对视野末所留赋值或对后来汲取折现之序、没有可及的最大更新水平时的最优、')
NEWZ10a = (f'`Web.frontier_breaks_stepwise_long`）。已落地（SG8，[研究第 {N} 节]({SA})）：在后来的汲取权重更小之序下，每个最优每步的增益等于最大加权增益进程的增益；'
           '权重下降快于每个正水平的更新时，每个最优在第一步终结自己的基础，可及的某水平更新更快时没有最优这样做（`Optimum.frontier_gains_weighted`、'
           '`Optimum.frontier_exhausts`、`Web.frontier_exhausts`、`Optimum.frontier_leaves`）。*开放：*对视野末所留赋值之序、没有可及的最大更新或最大加权增益水平时的最优、')
OLDZ6K = '（Luce 与 Raiffa 1957；Selten 1978） |'
NEWZ6K = '（Luce 与 Raiffa 1957；Selten 1978）；折现、修正黄金律与最优灭绝（Ramsey 1928；Clark 1973；Clark 与 Munro 1975） |'
OLDZ6 = '（`Optimum.frontier_keeps_stepwise`、`Web.frontier_breaks_last`） |'
NEWZ6 = ('（`Optimum.frontier_keeps_stepwise`、`Web.frontier_breaks_last`），在后来的汲取权重更小之序下每个最优的增益等于最大加权增益进程的增益，'
         '权重下降快于每个正水平的更新时在第一步终结自己的基础（`Optimum.frontier_gains_weighted`、`Web.frontier_exhausts`） |')
OLDZROW = line_from(z, f'| [每步的耦合在每个视野都保持依存](../results/records/{SG7}.md) |') + '\n'
NEWZROW = (f'| [权重下降快于更新时终结基础](../results/records/{RID}.md) | 在所述前提下的定理 | 自起点开放的过程，在至少两步的视野上按随所汲取升高之序排序，'
           '每步的抽取以自然数权重加权；由水平之律给出的更新；开放、最后不留、每步水平增益最大的参照进程，或权重下降快于每个正水平的更新，'
           '或可及的某水平更新更快且零处无所给；容量足以承担第一步的抽取；对网之律，起始时被满足的依存 | §3.4、§7.1、§8.1 |\n')
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
