#!/usr/bin/env python3
"""SG10 landing text: the study section, the significance review's drawn-first check, the chapter (EN, ZH: section 3.4's
statement and records, two lemmas cited by their general forms, section 7.1's others drawing first ending what far-sight
alone rebuilds, section 8.1 item 10, the
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
RID = 'others-drawing-first-end-the-base'
SG9 = 'optima-rebuild-a-depleted-base'
SA296 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#296-rebuilding-from-below-sg9')
# The renewal forms of lemmas no law reads any more, and the definition `drawable`: their general forms replace them.
GONE = ['weighted_add_left', 'drawable_step', 'drawable_le_of_gains', 'drawable_lt_of_gains', 'weighted_of_ends',
        'weighted_le_of_gains', 'weighted_lt_of_gains', 'outpaced_greatest', 'outpaced_above', 'ended_outdrawn',
        'stays_empty', 'rise_succ', 'rise_le', 'rise_le_top', 'rise_within', 'rise_of_below', 'rise_at_top',
        'rise_below_before', 'le_rise', 'rebuilding_before', 'rebuilding_after', 'rebuilding_at', 'rebuilding_within',
        'rebuilding_le_cap', 'rebuilding_open', 'rebuilding_gainsMost', 'drawable']
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
removed = old_names - {d['name'] for d in om['declarations']}
assert removed == {f'{MOD}.{n}' for n in GONE}, removed ^ {f'{MOD}.{n}' for n in GONE}
n_new_thms = sum(d['kind'] == 'theorem' for d in new_decls)
removed_thms = sum(d['kind'] == 'theorem' for d in pm['declarations'] if d['name'] in removed)
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
              'the web or used by one that is, the witnesses through the general laws, and the renewal forms no law reads any '
              'more removed rather than registered; register check passes')
study = (HERE / 'study_sg10.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_new_thms, '{DECLS}': len(new_decls),
             '{OLD}': len(pm['declarations']), '{REMOVED}': len(removed), '{REMOVED_THMS}': removed_thms, '{TOTAL}': len(om['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-over-every-law-of-what-stands-sg10', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG9}](../results/records/{SG9}.md)'

# Significance review: the drawn-first check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="drawn-first-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg10.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = ('restored at the first step, `doubling_rebuilds`). Where the eligible outcomes are supplied otherwise,')
NEW34 = ('restored at the first step, `doubling_rebuilds`). Each of these laws uses only what stands to be drawn at each '
         'step, so each holds over any law `G` of what stands, a level `z` at the step from `t` giving `G t z`, which may '
         'change with the step and give less than the level or more; the renewal law `z + R z` is the case, and holding '
         'or rising to `y` needs only `y ≤ G t y` (`Optimum.Next`, `Web.Next`). Where others first draw from the level '
         'an optimizer leaves, leaving `K t z`, which renews by `R`, what stands for it is `K t z + R (K t z)` '
         '(`Optimum.Next.leftBy`); where what stands at each level is at most the level, every optimum of every order '
         'rising with the weighted draw whose weighting falls at every step, however slightly, stands at nothing at '
         'every step from the first to the horizon\'s last (`Optimum.Next.frontier_ends_of_le`, '
         '`Optimum.Next.frontier_ends_drawn_first`), and where it is less than every positive level, so does every '
         'optimum under positive weights rising at no step (`Optimum.Next.frontier_ends_of_lt`, '
         '`Optimum.Next.frontier_ends_drawn_more`), each breaking at the first step every dependence on the base with a '
         'positive need met at the start (`Web.Next.frontier_ends_drawn_first`, `Web.Next.frontier_ends_drawn_more`; in '
         '`Optimum.Holding`, from two, a source doubling up to eight is rebuilt to four and eight by every optimum alone '
         'under weights rising at no step and falling less than twofold, and ended at once by every optimum of the same '
         'order with others first drawing all but a quarter of what is left, `doubling_drawn_first`, '
         '`doubling_drawn_first_linear`). Where the eligible outcomes are supplied otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'`Web.frontier_rebuilds`, SG9, [study §296]({SA296}));'
NEW71 = (OLD71 + ' and what far-sight keeps or rebuilds is not the optimizer\'s alone to give: where others first draw from '
         'what it leaves at least what the remainder renews, what it leaves stands no higher at the next step, and every '
         'optimum of every order whose weighting falls at every step, however slightly, ends the base at once, the same '
         'order that rebuilds it alone, as open access dissipates a common stock '
         f'(`Optimum.Next.frontier_ends_drawn_first`, `Web.Next.frontier_ends_drawn_first`, SG10, [study §{N}]({SA}));')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = ('`Web.frontier_rebuilds`). *Open:* an order valuing what is left at the horizon, the optimum where a level of '
          'greatest gain is out of reach and the next level does not rise with the level, steps met again after a fall, '
          'several optimizers ranking courses, and how optimizers come to a mutual best response;')
NEW10a = (f'`Web.frontier_rebuilds`). Landed (SG10, [study §{N}]({SA})): these laws hold over any law of what stands, '
          'the renewal law the case; where others first draw from what an optimizer leaves at least what the remainder '
          'renews, every optimum of an order whose weighting falls at every step ends the base at once, and where they '
          'draw more, every optimum under positive weights rising at no step, the same order that rebuilds the base alone '
          'ending it among others (`Optimum.Next.frontier_ends_drawn_first`, `Optimum.Next.frontier_ends_drawn_more`, '
          '`Web.Next.frontier_ends_drawn_first`). *Open:* an order valuing what is left at the horizon, the optimum where '
          'a level of greatest gain is out of reach and the next level does not rise with the level, holding a level '
          'where what stands at it falls below it, steps met again after a fall, whether others\' draws, supplied as a '
          'rule reading the level, are themselves a best response, so several optimizers each ranking courses at a '
          'mutual best response, and how optimizers come to one;')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10c, NEW10c)
OLD6 = '(`Optimum.frontier_rebuilds`, `Web.frontier_rebuilds`) |'
NEW6 = ('(`Optimum.frontier_rebuilds`, `Web.frontier_rebuilds`), and, over any law of what stands, others drawing first '
        'from what an optimizer leaves at least what the remainder renews having every optimum of every weighting '
        'falling at every step end the base at once, the same order that rebuilds it alone '
        '(`Optimum.Next.frontier_ends_drawn_first`, `Web.Next.frontier_ends_drawn_first`) |')
OLD_ROW = line_from(ch0, f'| [Every optimum rebuilds a depleted base](../results/records/{SG9}.md) |') + '\n'
NEW_ROW = (f'| [Others drawing first end the base](../results/records/{RID}.md) | theorem under stated premises | any law of '
           'what stands, a level at a step giving what stands to be drawn or left; courses open under it from a start, '
           'ranked over a horizon by an order rising with the weighted draw; for holding or rising to `y`, what stands at '
           '`y` at least `y`, otherwise SG8\'s and SG9\'s premises with that law for the renewal; for others drawing '
           'first, what they leave of each level with its renewal at most the level and a weighting falling at every '
           'step, or less than every positive level and positive weights rising at no step; a capacity covering what '
           'stands at the start and at nothing; for the web laws, a dependence met at the start with a positive need | '
           '§3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG10 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [('(`Optimum.drawable_step`)', '(`Optimum.Next.drawable_step`)'), ('(`Optimum.le_rise`)', '(`Optimum.Next.le_rise`)'),
          (OLD34, NEW34), (OLD34R, NEW34R), (OLD71, NEW71), (OLD10, NEW10),
          (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '居者在第一步恢复，`doubling_rebuilds`）、'
NEWZ34 = (OLDZ34 + '`Optimum.Next.frontier_ends_drawn_first`（这些规律都只用每步可抽取的所立者，故对任一“所立之律” `G` 成立：水平 `z` 在自 `t` '
          '之步给出 `G t z`，可随步变化，可少于水平或多于水平；更新之律 `z + R z` 是其情形，保持或升至 `y` 只需 `y ≤ G t y`，'
          '`Optimum.Next`、`Web.Next`；他者先从优化者所留水平中抽取、留下 `K t z` 并按 `R` 更新时，对它所立者为 `K t z + R (K t z)`，'
          '`Optimum.Next.leftBy`；各水平处所立者不超过水平时，随加权抽取升高、权重每步下降（无论多少）之序的每个最优自第一步至视野最后一步都处于零，'
          '`Optimum.Next.frontier_ends_of_le`；少于每个正水平时，权重为正且不上升之序的每个最优亦然，`Optimum.Next.frontier_ends_of_lt`、'
          '`Optimum.Next.frontier_ends_drawn_more`；并在第一步打破起始时被满足、需要为正的对基础的每个依存，`Web.Next.frontier_ends_drawn_first`、'
          '`Web.Next.frontier_ends_drawn_more`；在 `Optimum.Holding` 中，自二出发、每级翻倍至八的源，在权重不上升且下降不到两倍时被单独的每个最优'
          '重建到四与八，他者先抽取到只剩所留的四分之一时被同一序的每个最优立即终结，`doubling_drawn_first`、`doubling_drawn_first_linear`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'`Web.frontier_rebuilds`，SG9，[研究第 296 节]({SA296})）；'
NEWZ71 = (OLDZ71 + '而远见所保持或重建的并非优化者单独所能给予：他者先从它所留中抽取不少于剩余之更新时，它所留在下一步不会更高，权重每步下降（无论多少）'
          '之序的每个最优都立即终结基础，单独时重建它的同一序亦然，正如开放进入耗散共有存量（`Optimum.Next.frontier_ends_drawn_first`、'
          f'`Web.Next.frontier_ends_drawn_first`，SG10，[研究第 {N} 节]({SA})）；')
OLDZ10a = ('`Web.frontier_rebuilds`）。*开放：*对视野末所留赋值之序、最大增益水平不可及且下一水平不随水平上升时的最优、跌落后再被满足的步、'
           '多个对过程排序的优化者、优化者如何达到相互最优回应；')
NEWZ10a = (f'`Web.frontier_rebuilds`）。已落地（SG10，[研究第 {N} 节]({SA})）：这些规律对任一所立之律成立，更新之律是其情形；他者先从优化者所留中'
           '抽取不少于剩余之更新时，权重每步下降之序的每个最优立即终结基础，抽取更多时，权重为正且不上升之序的每个最优亦然，单独时重建基础的同一序在他者'
           '之中终结它（`Optimum.Next.frontier_ends_drawn_first`、`Optimum.Next.frontier_ends_drawn_more`、`Web.Next.frontier_ends_drawn_first`）。'
           '*开放：*对视野末所留赋值之序、最大增益水平不可及且下一水平不随水平上升时的最优、在其处所立者低于它的水平上保持、跌落后再被满足的步、'
           '作为读取水平的规则给出的他者抽取本身是否是最优回应，从而多个各自对过程排序的优化者的相互最优回应、优化者如何达到它；')
OLDZ6 = '（`Optimum.frontier_rebuilds`、`Web.frontier_rebuilds`） |'
NEWZ6 = ('（`Optimum.frontier_rebuilds`、`Web.frontier_rebuilds`），对任一所立之律，他者先从优化者所留中抽取不少于剩余之更新时，权重每步下降之序的'
         '每个最优都立即终结基础，单独时重建它的同一序亦然（`Optimum.Next.frontier_ends_drawn_first`、`Web.Next.frontier_ends_drawn_first`） |')
OLDZROW = line_from(z, f'| [每个最优都重建耗竭的基础](../results/records/{SG9}.md) |') + '\n'
NEWZROW = (f'| [他者先抽取则终结基础](../results/records/{RID}.md) | 在所述前提下的定理 | 任一所立之律，水平在一步给出可抽取或留下者；在其下自起点开放的过程，'
           '在视野上按随加权抽取升高之序排序；保持或升至 `y` 时 `y` 处所立者不少于 `y`，其余为 SG8、SG9 之前提，以该律代更新；他者先抽取时，'
           '所留连同更新不超过各水平且权重每步下降，或少于每个正水平且权重为正不上升；容量足以承担起点处与零处所立者；对网之律，起始时被满足、需要为正的依存 | '
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
edit(ZH, [('`Optimum.drawable_step`', '`Optimum.Next.drawable_step`'), ('`Optimum.le_rise`', '`Optimum.Next.le_rise`'),
          (OLDZ34, NEWZ34), (OLDZ34R, NEWZ34R), (OLDZ71, NEWZ71), (OLDZ10a, NEWZ10a),
          (OLDZ6, NEWZ6), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls), 'removed': len(removed),
                                           'removed_thms': removed_thms})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'removed', len(removed), 'apart', apart,
      'spine theorems', spine_thms)
print('STUDY_SECTION', N)
