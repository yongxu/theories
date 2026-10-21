#!/usr/bin/env python3
"""SG11 landing text: the study section, the significance review's left check, the chapter (EN: section 3.4's horizon
paragraph, section 7.1's far-sighted objection, the relation-to-known-results row 6, the standing clause, section 8.1's
item 10, the record table and section 9's receipt, counts and audit sentence; ZH: the same places) and the board row
moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT FIRST_RECEIPT
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
RID = 'valuing-what-is-left-at-the-horizon'
SG10 = 'others-drawing-first-end-the-base'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA292 = f'{STUDY_LINK}#292-courses-ranked-over-a-horizon-sg5'
receipt_id, conn_log, base, previous, first = sys.argv[1:6]


def edit(path, pairs):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    for old, new in pairs:
        k = text.count(old)
        if k != 1:
            sys.exit(f'{path}: expected one match, found {k}: {old[:100]!r}')
    for old, new in pairs:
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
assert old_names <= {d['name'] for d in om['declarations']}, 'a declaration was removed'
new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
d_new = len(new_decls)
n_new = sum(d['kind'] == 'theorem' for d in new_decls)
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the web or read '
              'by a law that is, the witnesses on the flow; register check passes')
study = (HERE / 'study_sg11.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{FIRST}': first, '{DECLS}': d_new, '{THEOREMS}': n_new,
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
assert study.count('```') % 2 == 0
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-valuing-what-is-left-at-the-horizon-sg11', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="left-check"' not in rtext

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = 'taking the same, `gated_alike`). Kept at a need `m`'
NEW34 = ('taking the same, `gated_alike`). Valuing what is left after the horizon alike with what is drawn '
         '(`Optimum.byDrawnLeft`), a course draws with what it leaves at most the start with what is given there and `r` '
         'a step after, exactly where `r` is given at every step after the first, whatever it leaves '
         '(`Optimum.most_left_iff`); where the capacity covers what the first step draws down to a level `y` of greatest '
         'renewal and `r`, over any horizon, every optimum of every order rising with what is drawn and left stands at a '
         'level of greatest renewal at every step to the horizon, and the optima of the order by what is drawn and left '
         'are exactly the open courses doing so (`Optimum.frontier_holds_left`, `Optimum.frontier_left_iff`): the course '
         'keeping `y` through and past the horizon is one, the course draining it at the end too, and keeping is no '
         'optimum of the order by the draw alone (`Optimum.keeping_frontier_left`, `Optimum.holding_frontier_left`, '
         '`Optimum.keeping_not_frontier`); a dependence every such level meets stands through the horizon under every such '
         'optimum, and one above every such level is broken at the first step as before (`Web.frontier_kept_left`, '
         '`Web.frontier_broken_left`; in `Optimum.Holding`, under a gate, keeping the source at the dweller\'s need through '
         'and past the horizon is an optimum keeping the dweller at every step, `gated_left`, and under the logistic law '
         'every such optimum breaks the dweller at the first step, `logistic_left`; SG11, '
         f'[study §{N}]({SA})). Kept at a need `m`')
OLD71 = (f'(`Optimum.frontier_holds`, `Web.frontier_broken`, `Optimum.Holding.gated_alike`, SG5, [study §292]({SA292}));')
NEW71 = (OLD71 + ' valuing what is left at the horizon as much as what is drawn, the repair the objection suggests, removes '
         'only the end\'s drain: the course keeping a level of greatest renewal through and past the horizon is then an '
         'optimum, and a dependence needing more is still broken at the first step under every optimum, since the value '
         'attaches to the stock left, not to what its levels meet (`Optimum.frontier_holds_left`, '
         f'`Web.frontier_broken_left`, `Optimum.Holding.gated_left`, SG11, [study §{N}]({SA}));')
OLD_ROW6 = ('breaking at the first step a dependence above every such level (`Optimum.frontier_holds`, '
            '`Web.frontier_broken`), and a coupling')
NEW_ROW6 = ('breaking at the first step a dependence above every such level (`Optimum.frontier_holds`, '
            '`Web.frontier_broken`), a value on what is left at the horizon removing only the drain at its end '
            '(`Optimum.frontier_holds_left`, `Web.frontier_broken_left`), and a coupling')
OLD_STAND = ('a dependence above every level of greatest renewal broken at the first step (`Optimum.frontier_holds`, '
             '`Web.frontier_broken`), and with a coupling')
NEW_STAND = ('a dependence above every level of greatest renewal broken at the first step (`Optimum.frontier_holds`, '
             '`Web.frontier_broken`), also where what is left at the horizon is valued alike with what is drawn '
             '(`Web.frontier_broken_left`), and with a coupling')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = '*Open:* an order valuing what is left at the horizon, the optimum where'
NEW10a = (f'Landed (SG11, [study §{N}]({SA})): with what is left after the horizon valued one for one with what is '
          'drawn, every optimum of every order rising with what is drawn and left holds a level of greatest renewal to '
          'the horizon, the optima of that order being exactly the open courses doing so, so the drain at the end is no '
          'longer forced and the course keeping that level past the horizon is an optimum; a dependence above every such '
          'level is still broken at the first step (`Optimum.frontier_holds_left`, `Optimum.frontier_left_iff`, '
          '`Web.frontier_broken_left`). *Open:* an order valuing what is left at the horizon at another worth than what '
          'is drawn, the optimum where')
OLD10c = f'[{SG10}](../results/records/{SG10}.md).'
assert OLD10.count(OLD10a) == 1 and OLD10.endswith(OLD10c)
NEW10 = OLD10.replace(OLD10a, NEW10a)[:-1] + f', {REC}.'
OLD_ROW = line_from(ch0, f'| [Others drawing first end the base](../results/records/{SG10}.md) |') + '\n'
NEW_ROW = (f'| [Valuing what is left at the horizon](../results/records/{RID}.md) | theorem under stated premises | a '
           'renewal law of the level, at most `r` at every level and `r` at some `y` within the start with what is given '
           'there; courses open from a start, ranked over a horizon by an order rising with what is drawn and what is left '
           'after the horizon, valued alike; a capacity covering what the first step draws down to `y` and `r` (for the '
           'course draining at the end, `y` with `r`, over at least two steps); for the web laws, a dependence met at the '
           'start | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG11 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD_ROW6, NEW_ROW6), (OLD_STAND, NEW_STAND), (OLD10, NEW10),
         (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '被它们都满足的依存保持到视野最后一步并在其末被打破，`Web.frontier_kept`）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_holds_left`（视野之后所留与所抽取同等计值时，`Optimum.byDrawnLeft`，进程所抽取与所留下之和至多是起始加所给'
          '再加每步 `r`，恰在第一步之后每步都给出 `r` 时取等，不论所留多少，`Optimum.most_left_iff`；容量足以承担第一步降到最大更新水平 `y` 的抽取与 '
          '`r` 时，在任何视野上，随所抽取与所留下升高之序的每个最优都在视野内每步保持在最大更新的水平，该序的最优恰是如此的开放进程，'
          '`Optimum.frontier_left_iff`；把 `y` 保持到视野之后的进程是最优，`Optimum.keeping_frontier_left`，在终了抽干的进程亦是，'
          '`Optimum.holding_frontier_left`，而只按汲取排序时保持者不是最优，`Optimum.keeping_not_frontier`；被这些水平都满足的依存在视野内'
          '被保持，`Web.frontier_kept_left`，高于它们全部的依存仍在第一步被打破，`Web.frontier_broken_left`；在 `Optimum.Holding` 中，'
          '门控下从居者所需处出发、保持到视野之后的进程是最优并在每步保持居者，`gated_left`，逻辑斯谛律下每个这样的最优仍在第一步打破居者，'
          f'`logistic_left`；SG11，[研究第 {N} 节]({SA})）、')
OLDZ71 = f'（`Optimum.frontier_holds`、`Web.frontier_broken`、`Optimum.Holding.gated_alike`，SG5，[研究第 292 节]({SA292})）；'
NEWZ71 = (OLDZ71 + '对视野末所留与所抽取同等计值，即这一异议所提示的补救，只去掉终了的抽干：把最大更新的水平保持到视野之后的进程于是是最优，'
          '而需要更多的依存仍在每个最优下于第一步被打破，因为此值附着于所留的存量，而不是其水平所满足者（`Optimum.frontier_holds_left`、'
          f'`Web.frontier_broken_left`、`Optimum.Holding.gated_left`，SG11，[研究第 {N} 节]({SA})）；')
OLDZ6 = '在第一步打破高于每个这样水平的依存（`Optimum.frontier_holds`、`Web.frontier_broken`），'
NEWZ6 = (OLDZ6 + '对视野末所留的计值只去掉终了的抽干（`Optimum.frontier_holds_left`、`Web.frontier_broken_left`），')
OLDZS = '高于每个最大更新水平的依存在第一步被打破（`Optimum.frontier_holds`、`Web.frontier_broken`），'
NEWZS = (OLDZS + '视野末所留与所抽取同等计值时亦然（`Web.frontier_broken_left`），')
OLDZ10 = '*开放：*对视野末所留赋值之序、'
NEWZ10 = (f'已落地（SG11，[研究第 {N} 节]({SA})）：视野之后所留与所抽取同等计值时，随所抽取与所留下升高之序的每个最优都在视野内保持在最大更新的'
          '水平，该序的最优恰是如此的开放进程，故终了的抽干不再被迫，把该水平保持到视野之后的进程是最优；高于每个这样水平的依存仍在第一步被打破'
          '（`Optimum.frontier_holds_left`、`Optimum.frontier_left_iff`、`Web.frontier_broken_left`）。*开放：*以不同于所汲取之价值对视野末所留'
          '赋值之序、')
OLDZROW = line_from(z, f'| [他者先抽取则终结基础](../results/records/{SG10}.md) |') + '\n'
NEWZROW = (f'| [对视野末所留的计值](../results/records/{RID}.md) | 在所述前提下的定理 | 水平的更新之律，各水平至多 `r`，在起始加所给之内的某 `y` 处为 `r`；'
           '自起点开放的过程，在视野上按随所抽取与视野之后所留（同等计值）升高之序排序；容量足以承担第一步降到 `y` 的抽取与 `r`（终了抽干的进程需承担 `y` '
           '加 `r`，视野至少两步）；对网之律，起始时被满足的依存 | §3.4、§7.1、§8.1 |\n')
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
zpairs = [(OLDZ34, NEWZ34), (OLDZ71, NEWZ71), (OLDZ6, NEWZ6), (OLDZS, NEWZS), (OLDZ10, NEWZ10),
          (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg11.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)
edit(CH, pairs)
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new, 'd_new': d_new})
print('new declarations', d_new, 'new theorems', n_new, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
