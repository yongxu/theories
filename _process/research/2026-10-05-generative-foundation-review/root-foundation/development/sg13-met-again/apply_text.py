#!/usr/bin/env python3
"""SG13 landing text: the study section, the significance review's met-again check, the chapter (EN: section 3.4's horizon
paragraph, section 7.1's far-sighted objection, the relation-to-known-results row 6, the standing clause, section 8.1's
item 10, the record table and section 9's receipt, counts and audit sentence; ZH: the same places) and the board row
moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

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
RID = 'steps-met-again-after-a-fall'
SG12 = 'valuing-what-is-left-at-any-worth'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA294 = f'{STUDY_LINK}#294-a-coupling-added-for-each-step-a-dependence-is-kept-sg7'
receipt_id, conn_log, base, previous = sys.argv[1:5]


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
              'by a law that is, the witness on the flow; register check passes')
study = (HERE / 'study_sg13.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{DECLS}': d_new, '{THEOREMS}': n_new,
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
assert study.count('```') % 2 == 0
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-steps-met-again-after-a-fall-sg13', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="met-again-check"' not in rtext

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = 'and at most one a step breaks it, `logistic_stepwise`).'
NEW34 = (OLD34 + ' Counted at every step the need is met, wherever those steps fall, each met step still forgoes at '
         'least `r - q` (`Optimum.shortfall_count_ge`, of which `Optimum.shortfall_ge` is the case; '
         '`Optimum.met_count_drawn_le`), so every optimum keeps the need where `r + e < q + c + m` and `e < c`, and the '
         'keeping course is an optimum where `r ≤ q + c` and `m ≤ c` (`Optimum.frontier_keeps_met`, '
         '`Optimum.continued_met_frontier`, `Web.frontier_met_kept`): a fall met again loses the coupling only at the '
         'steps below, so the threshold rises above the count from the start (in `Optimum.Holding`, under a burst '
         'renewing four at one, four a step keeps the dweller counted from the start, while counted at every step met '
         f'a course falling once and met again is an optimum, `burst_met`; SG13, [study §{N}]({SA})).')
OLD71 = f'`Web.frontier_breaks_last`, SG7, [study §294]({SA294})); '
NEW71 = (f'`Web.frontier_breaks_last`, SG7, [study §294]({SA294})); counted at every step the need is met rather '
         'than from the start, the coupling can be had by a course that falls and recovers, so it keeps the dependence '
         'only where it exceeds the renewal forgone a step outright, by the end\'s excess over the need '
         f'(`Optimum.frontier_keeps_met`, `Optimum.Holding.burst_met`, SG13, [study §{N}]({SA})); ')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = '*Open:* a worth on what is left where the most a course can leave is not regrown in one step,'
NEW10a = (f'Landed (SG13, [study §{N}]({SA})): counted at every step met, wherever, a coupling a step keeps the need '
          'under every optimum where `r + e < q + c + m` and `e < c`, strictly above the count from the start, a fall '
          'met again losing the coupling only at the steps below (`Optimum.frontier_keeps_met`, '
          '`Optimum.continued_met_frontier`, `Optimum.Holding.burst_met`). *Open:* a worth on what is left where the '
          'most a course can leave is not regrown in one step,')
OLD10b = ' steps met again after a fall,'
OLD10c = f'[{SG12}](../results/records/{SG12}.md).'
assert OLD10.count(OLD10a) == 1 and OLD10.count(OLD10b) == 1 and OLD10.endswith(OLD10c)
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10b, '')[:-1] + f', {REC}.'
OLD_ROW = line_from(ch0, f'| [Valuing what is left at any worth](../results/records/{SG12}.md) |') + '\n'
NEW_ROW = (f'| [Steps met again after a fall](../results/records/{RID}.md) | theorem under stated premises | a renewal law '
           'of the level, at most `r` at every level, at most `q` at every level at or above a need `m` and `q` at some `y` '
           'within the start with what is given there; a start meeting `m`; courses open from it ranked over a horizon by '
           'a worth adding at least `c` a step to a keeping course and at most `c` for each step met, wherever; a capacity '
           'covering the keeping course ending at `e` | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG13 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD10, NEW10),
         (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '每步至多一则打破它，`logistic_stepwise`）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_keeps_met`（按每个被满足的步计数而不论其位置时，每个被满足的步仍至少放弃 `r - q`，'
          '`Optimum.shortfall_count_ge`（`Optimum.shortfall_ge` 是其情形）、`Optimum.met_count_drawn_le`；故在 `r + e < q + c + m` 且 '
          '`e < c` 时每个最优都保持所需，`Web.frontier_met_kept`，在 `r ≤ q + c` 且 `m ≤ c` 时保持的进程是最优，'
          '`Optimum.continued_met_frontier`：跌落后再被满足只在其下各步失去耦合，故门槛高于自起点计数的门槛；在 `Optimum.Holding` 中，'
          '在一处更新四、别处不更新的爆发之下，每步四在自起点计数时保持居者，而按每个被满足的步计数时跌落一次再被满足的进程也是最优，'
          f'`burst_met`；SG13，[研究第 {N} 节]({SA})）、')
OLDZ71 = f'`Web.frontier_breaks_last`，SG7，[研究第 294 节]({SA294})）；'
NEWZ71 = (OLDZ71 + '若按每个被满足的步而非自起点计数，跌落后恢复的进程也能得到这一耦合，故它只在超过每步放弃的更新本身、再加终了高于所需之量时才保持依存'
          f'（`Optimum.frontier_keeps_met`、`Optimum.Holding.burst_met`，SG13，[研究第 {N} 节]({SA})）；')
OLDZ10 = '*开放：*最多所留不能在一步内从最大更新水平再生时对所留计值之序、'
NEWZ10 = (f'已落地（SG13，[研究第 {N} 节]({SA})）：按每个被满足的步计数而不论其位置时，每步的耦合在 `r + e < q + c + m` 且 `e < c` 时使每个最优都保持所需，'
          '严格高于自起点计数的门槛，跌落后再被满足只在其下各步失去耦合（`Optimum.frontier_keeps_met`、`Optimum.continued_met_frontier`、'
          '`Optimum.Holding.burst_met`）。' + OLDZ10)
OLDZ10b = '跌落后再被满足的步、'
OLDZROW = line_from(z, f'| [以任一价值对所留计值](../results/records/{SG12}.md) |') + '\n'
NEWZROW = (f'| [跌落后再被满足的步](../results/records/{RID}.md) | 在所述前提下的定理 | 水平的更新之律，各水平至多 `r`，所需 `m` 及以上至多 `q`，在起始加所给之内的某 `y` 处为 `q`；'
           '起点满足 `m`；自起点开放的过程，在视野上按一个价值排序：对保持的进程每步至少加 `c`，对每个被满足的步（不论位置）至多加 `c`；容量足以承担终于 `e` '
           '的保持进程 | §3.4、§7.1、§8.1 |\n')
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
zpairs = [(OLDZ34, NEWZ34), (OLDZ71, NEWZ71), (OLDZ10, NEWZ10), (OLDZ10b, ''),
          (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg13.txt').read_text(encoding='utf-8').rstrip('\n')
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
