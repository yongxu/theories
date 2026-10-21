#!/usr/bin/env python3
"""SG9 landing text: the study section, the significance review's rebuilding check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's far-sight rebuilding a depleted base, section 8.1 item 10, the
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
RID = 'optima-rebuild-a-depleted-base'
SG8 = 'a-weighting-faster-than-renewal-ends-the-base'
SA295 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#295-an-order-weighting-later-draws-less-sg8')
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
study = (HERE / 'study_sg9.txt').read_text(encoding='utf-8')
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
assert SLUG == f'{N}-rebuilding-from-below-sg9', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG8}](../results/records/{SG8}.md)'

# Significance review: the rebuilding check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="rebuilding-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg9.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = 'twofold both are optima, `logistic_weighted`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('twofold both are optima, `logistic_weighted`). Where the start lies below a level `y` it cannot reach in one '
         'step, and the next level rises with the level below `y`, nothing open rises faster than the course rising as '
         'fast as what is given allows (`Optimum.le_rise`); a course gaining, weighted, at least what any open course\'s '
         'level gains is an optimum and every optimum gains what it does (`Optimum.frontier_of_gainsMost`, '
         '`Optimum.frontier_gains_of_most`), so where the weighted gain rises with the level up to `y` and is greatest '
         'there, the rebuilding course is an optimum (`Optimum.rebuilding_frontier`), and where it rises strictly, every '
         'optimum stands at its level, drawing nothing, while it is below `y`, restoring every dependence whose need '
         'that level meets (`Optimum.frontier_rebuilds`, `Web.frontier_rebuilds`), and stands at `y` after where `y` '
         'gains the most strictly (`Optimum.frontier_rebuilt`; in `Optimum.Holding`, a source doubling up to eight, from '
         'one, is rebuilt to two, four and eight by every optimum under weights falling less than twofold, the dweller '
         'restored at the first step, `doubling_rebuilds`). Where the eligible outcomes are supplied otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'`Optimum.frontier_leaves`, SG8, [study §295]({SA295}));'
NEW71 = (OLD71 + ' and where the base has been drawn below a level of greatest weighted gain out of one step\'s reach, '
         'and the weighted gain rises strictly with the level up to it, far-sight rebuilds it: every optimum draws '
         'nothing while the base regrows as fast as it renews, and restores on the way every dependence whose need the '
         f'regrowing level meets (`Optimum.frontier_rebuilds`, `Web.frontier_rebuilds`, SG9, [study §{N}]({SA}));')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = ('`Optimum.frontier_leaves`). *Open:* an order valuing what is left at the horizon, the optimum where no level '
          'of greatest renewal or weighted gain is within reach, steps met again after a fall, several optimizers')
NEW10a = (f'`Optimum.frontier_leaves`). Landed (SG9, [study §{N}]({SA})): below a level of greatest gain out of one '
          'step\'s reach, where the next level and the weighted gain rise with the level, every optimum rebuilds the base '
          'as fast as it renews, drawing nothing, and restores every dependence the rising level meets '
          '(`Optimum.rebuilding_frontier`, `Optimum.frontier_rebuilds`, `Web.frontier_rebuilds`). *Open:* an order '
          'valuing what is left at the horizon, the optimum where a level of greatest gain is out of reach and the next '
          'level does not rise with the level, steps met again after a fall, several optimizers')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10c, NEW10c)
OLD6K = 'Clark and Munro 1975) |'
NEW6K = 'Clark and Munro 1975); the most rapid approach path (Spence and Starrett 1975) |'
OLD6 = '(`Optimum.frontier_gains_weighted`, `Web.frontier_exhausts`) |'
NEW6 = ('(`Optimum.frontier_gains_weighted`, `Web.frontier_exhausts`), and, where the weighted gain rises strictly '
        'with the level up to a level out of one step\'s reach, every optimum rebuilding a depleted base as fast as it '
        'renews, drawing nothing, restoring every dependence the rising level meets '
        '(`Optimum.frontier_rebuilds`, `Web.frontier_rebuilds`) |')
OLD_ROW = line_from(ch0, f'| [A weighting falling faster than renewal ends the base](../results/records/{SG8}.md) |') + '\n'
NEW_ROW = (f'| [Every optimum rebuilds a depleted base](../results/records/{RID}.md) | theorem under stated premises | '
           'courses open from a start below a level `y` out of one step\'s reach, ranked over a horizon by an order '
           'rising with the weighted draw; a renewal law whose next level rises with the level below `y`; the weighted '
           'gain rising with the level up to `y` (strictly, for every optimum) and greatest at `y`; a capacity covering '
           '`y` with its renewal and what is given at nothing; for the web law, a dependence as it stands at the start | '
           '§3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG9 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD34, NEW34), (OLD34R, NEW34R), (OLD71, NEW71), (OLD10, NEW10),
          (OLD6K, NEW6K), (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '恰为两倍时两者都是最优，`logistic_weighted`）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_rebuilds`（起点低于一步不可及的水平 `y`、下一水平在 `y` 之下随水平上升时，没有开放进程比按所给尽快上升的进程升得更快，'
          '`Optimum.le_rise`；每步加权增益不少于任一开放进程水平之增益的进程是最优，每个最优的增益与它相同，`Optimum.frontier_of_gainsMost`、'
          '`Optimum.frontier_gains_of_most`；故加权增益随水平升至 `y` 且在那里最大时，重建的进程是最优，`Optimum.rebuilding_frontier`；严格上升时，'
          '每个最优在低于 `y` 时都处于它的水平、不抽取，恢复其需要为该水平所满足的每个依存，`Web.frontier_rebuilds`；`y` 的增益严格最大时此后处于 `y`，'
          '`Optimum.frontier_rebuilt`；在 `Optimum.Holding` 中，每级翻倍至八的源自一出发，在权重下降不到两倍时被每个最优重建到二、四、八，居者在第一步恢复，'
          '`doubling_rebuilds`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'`Optimum.frontier_leaves`，SG8，[研究第 295 节]({SA295})）；'
NEWZ71 = (OLDZ71 + '而基础已被抽到一步不可及的最大加权增益水平之下、加权增益随水平严格升至该水平时，远见重建它：每个最优在基础按其更新尽快回升时不抽取，'
          f'并在途中恢复其需要为回升水平所满足的每个依存（`Optimum.frontier_rebuilds`、`Web.frontier_rebuilds`，SG9，[研究第 {N} 节]({SA})）；')
OLDZ10a = ('`Optimum.frontier_leaves`）。*开放：*对视野末所留赋值之序、没有可及的最大更新或最大加权增益水平时的最优、')
NEWZ10a = (f'`Optimum.frontier_leaves`）。已落地（SG9，[研究第 {N} 节]({SA})）：在一步不可及的最大增益水平之下，下一水平与加权增益随水平上升时，'
           '每个最优都按基础的更新尽快重建它、不抽取，并恢复上升水平所满足的每个依存（`Optimum.rebuilding_frontier`、`Optimum.frontier_rebuilds`、'
           '`Web.frontier_rebuilds`）。*开放：*对视野末所留赋值之序、最大增益水平不可及且下一水平不随水平上升时的最优、')
OLDZ6K = 'Clark 与 Munro 1975） |'
NEWZ6K = 'Clark 与 Munro 1975）；最快趋近路径（Spence 与 Starrett 1975） |'
OLDZ6 = '（`Optimum.frontier_gains_weighted`、`Web.frontier_exhausts`） |'
NEWZ6 = ('（`Optimum.frontier_gains_weighted`、`Web.frontier_exhausts`），加权增益随水平严格升至一步不可及的水平时，每个最优按更新尽快重建耗竭的基础、不抽取，恢复上升水平所满足的每个依存'
         '（`Optimum.frontier_rebuilds`、`Web.frontier_rebuilds`） |')
OLDZROW = line_from(z, f'| [权重下降快于更新时终结基础](../results/records/{SG8}.md) |') + '\n'
NEWZROW = (f'| [每个最优都重建耗竭的基础](../results/records/{RID}.md) | 在所述前提下的定理 | 自低于一步不可及水平 `y` 的起点开放的过程，在视野上按随加权抽取升高之序排序；'
           '下一水平在 `y` 之下随水平上升的更新之律；加权增益随水平升至 `y`（对每个最优须严格）且在 `y` 最大；容量足以承担 `y` 加其更新与零处所给；'
           '对网之律，起始时的依存 | §3.4、§7.1、§8.1 |\n')
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
edit(ZH, [(OLDZ34, NEWZ34), (OLDZ34R, NEWZ34R), (OLDZ71, NEWZ71), (OLDZ10a, NEWZ10a),
          (OLDZ6K, NEWZ6K), (OLDZ6, NEWZ6), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls)})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
