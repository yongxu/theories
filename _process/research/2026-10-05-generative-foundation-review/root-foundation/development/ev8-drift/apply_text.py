#!/usr/bin/env python3
"""EV8 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt and counts), the evolution chapter (a summary bullet, the recovery table row and next connection
3), the board row moved to the history file and the queue and receipt sentences. Every edit must match exactly once.

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
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Drift'
RID = 'drift-offspring-sampled'
EV7RID = 'selection-within-and-among-groups-of-any-sizes'
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


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
core = [m for m in R['modules'] if m['layer'] == 'core']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
mod = next(m for m in core if m['module'] == MOD)
n_thm, n_decl = mod['theorems'], len(mod['declarations'])
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

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = f'{apart} of {fmt(spine_thms)} apart; the new apart roots registered; register check passes'
study = (HERE / 'study_ev8.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_thm, '{DECLS}': n_decl, '{APART}': apart_text,
             '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert '{' not in study.split('```')[1], 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-drift-offspring-sampled-rather-than-listed-ev8'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
EV7REC = f'[{EV7RID}](../results/records/{EV7RID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
i = ch0.index('- `Flow.family_excess_ends`, `GroupEnding.Flow.coupled_end_together`: groups whose conditions are coupled.')
OLD_AFTER = ch0[i:ch0.index('\n', i) + 1]
NEW_BULLET = (
    "- `Drift.falls_back`: drift, offspring sampled rather than listed. A next generation of two kinds drawn n times "
    "from p listed offspring of the first kind and q of the second, each sampling a course of `Typicality` weighed by "
    "the ways of drawing it: on average the sampled share is the listed share (`Drift.expected_ones`), and the squared "
    "deviations add to n·p·q·(p+q)^n (`Typicality.spread`). Where a listed step raises the share from h/N to p/(p+q) "
    "by the gap g = N·p − (p+q)·h, the samplings falling back to h/N or below weigh, times n²·g², at most "
    "N²·n·p·q·(p+q)^n: out of the whole, at most p·q/((p+q)²·δ²·n) with δ = p/(p+q) − h/N. They weigh at least q^n, "
    "the samplings losing the first kind (`Drift.lost_weight`, `Drift.falls_back_ge`), so undoing selection is rare "
    "as the sample grows and at no size ruled out. Over listed generations the same holds for a step raising the mean "
    "of an amount held or not (`Drift.Generations.raised_falls_back`), and on the base where that step is ending among "
    "groups (`Drift.Flow.ended_falls_back`). Counting weighs the samplings and does not say which happens.\n")
OLD_RECS = f'{EV7REC}, [transmission'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
i = ch0.index(f'| [Selection within and among groups of any sizes](../results/records/{EV7RID}.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROW = (f'| [Drift: offspring sampled rather than listed](../results/records/{RID}.md) | theorem under stated premises | '
           'two kinds drawn with replacement from the listed offspring; over generations the amount read as held or '
           'not; on the base, the groups with less of it not active | §2.4 |\n')
i = ch0.index("9. **Evolution's selection term** (further proof).")
OLD9 = ch0[i:ch0.index('\n', i)]
OLD9a = 'groups whose conditions are coupled ending together, on the family laws of `Becoming.Continuation`.)'
NEW9a = ('groups whose conditions are coupled ending together, on the family laws of `Becoming.Continuation`; offspring '
         'sampled rather than listed, unbiased on average with an exact spread, the samplings undoing a step\'s '
         'selection, ending among groups included, weighing at most a share falling as 1/n and at least q^n, '
         '`Becoming.Drift`.)')
OLD9b = 'dependences newly formed by descent;'
NEW9b = ('dependences newly formed by descent; fixation and loss over many sampled generations, and mutation '
         '(transmission not exact);')
assert OLD9.count(OLD9a) == 1 and OLD9.count(OLD9b) == 1, (OLD9.count(OLD9a), OLD9.count(OLD9b))
NEW9 = OLD9.replace(OLD9a, NEW9a).replace(OLD9b, NEW9b).replace(OLD_RECS, f'{EV7REC}, {REC}, [transmission')
i = ch0.index('Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
OLD_RECLINE = ch0[i:ch0.index('\n', i)]
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, f'{EV7REC}, {REC}, [transmission')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV8 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD_AFTER, OLD_AFTER + NEW_BULLET), (OLD9, NEW9), (OLD_RECLINE, NEW_RECLINE), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ24 = '下一步保留降到起点以下；终止耗尽它所作用的组间差异）、'
NEWZ24 = (OLDZ24 + '`Drift.falls_back`（从所列后代中抽样而非列出：两类的下一代从 p 个第一类、q 个第二类的所列后代中抽取 n 次，'
          '每种抽样以抽出它的方式数为权重；平均而言抽样份额即所列份额（`Drift.expected_ones`），偏差平方之和为 n·p·q·(p+q)^n'
          '（`Typicality.spread`）；所列的一步把份额从 h/N 升至 p/(p+q)、差距 g = N·p − (p+q)·h 时，退回到 h/N 或以下的抽样之权重乘以 n²·g² '
          '至多为 N²·n·p·q·(p+q)^n，且至少为 q^n，即失去第一类的抽样（`Drift.falls_back_ge`）：撤销选择随样本增大而稀少，'
          '在任何大小下都不被排除；在所列世代上与流上组间终止使均值上升之处亦然，`Drift.Generations.raised_falls_back`、'
          '`Drift.Flow.ended_falls_back`；计数为各抽样加权，不说哪一种发生）、')
i = z.index(f'| [大小任意之组的组内与组间选择](../results/records/{EV7RID}.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROW = (f'| [漂变：从后代中抽样而非列出](../results/records/{RID}.md) | 在所述前提下的定理 | 两类，从所列后代中有放回地抽取；'
           '世代上该量读作持有或不持有；在流上，持有较少之组不活跃 | §2.4 |\n')
i = z.index('9. **演化的选择项**（进一步的证明）。')
OLDZ9 = z[i:z.index('\n', i)]
OLDZ9a = '条件相互耦合的组一同终结，基于 `Becoming.Continuation` 的条件族定律。）'
NEWZ9a = ('条件相互耦合的组一同终结，基于 `Becoming.Continuation` 的条件族定律；从后代中抽样而非列出：平均无偏、离散度精确，'
          '撤销一步之选择（包括组间终止）的抽样之权重至多为随 1/n 下降的份额、至少为 q^n，`Becoming.Drift`。）')
OLDZ9b = '世系新形成的依存；'
NEWZ9b = '世系新形成的依存；多代抽样中的固定与丢失，以及突变（不精确的传递）；'
assert OLDZ9.count(OLDZ9a) == 1 and OLDZ9.count(OLDZ9b) == 1, (OLDZ9.count(OLDZ9a), OLDZ9.count(OLDZ9b))
NEWZ9 = OLDZ9.replace(OLDZ9a, NEWZ9a).replace(OLDZ9b, NEWZ9b)
i = z.index('**当前回执**是运行 [`')
OLDZR = z[i:z.index('\n', i)]
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
edit(ZH, [(OLDZ24, NEWZ24), (OLDZROW, OLDZROW + NEWZROW), (OLDZ9, NEWZ9), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The evolution chapter.
evo = (ROOT / EVO).read_text(encoding='utf-8')
i = evo.index('- **What selection sees and what a rise draws from.**')
OLD_SEES = evo[i:evo.index('\n', i) + 1]
NEW_DRIFT = (
    '- **Offspring sampled rather than listed.** Where the next generation is drawn from the listed offspring rather '
    'than being them, the sampled share is the listed share on average and its spread is exact; the samplings that undo '
    'a step\'s selection, a rise by ending among groups included, weigh at most a share falling as one over the sample '
    'size for a fixed gap, and at least the samplings that lose the favoured kind outright, so drift makes undoing '
    f'selection rare in large samples and never impossible ({REC}). Counting weighs the samplings; it does not say '
    'which happens.\n')
OLD_TAB = 'the multilevel form for groups of equal size ([selection-within-and-among-groups](../results/records/selection-within-and-among-groups.md)). Each is a known result restated; fitness is not defined, and mutation, drift and movement are not covered there.'
NEW_TAB = ('the multilevel form for groups of any sizes ([selection-within-and-among-groups](../results/records/selection-within-and-among-groups.md), '
           f'{EV7REC.replace("../results", "../results")}); one generation of offspring sampled rather than listed, the Wright–Fisher sampling, '
           f'with its spread and a bound on undoing selection ({REC}). Each is a known result restated; fitness is not '
           'defined, and mutation, drift over many generations and movement are not covered there.')
OLD_TAB2 = 'on the spine, inexact transmission and sampled offspring, the additive part of Fisher\'s theorem, unequal group sizes and rational amounts.'
NEW_TAB2 = ('on the spine, inexact transmission, fixation over sampled generations, the additive part of Fisher\'s theorem '
            'and rational amounts.')
OLD_C3 = ('3. **Mutation and drift.** Transmission that is not exact, read through the transmission term of the selection '
          'term\'s course over generations, and offspring sampled rather than listed.')
NEW_C3 = ('3. **Mutation and drift.** One generation of offspring sampled rather than listed is on the spine: unbiased, '
          'with an exact spread, undoing a step\'s selection with a weight between the samplings losing the favoured '
          f'kind and a share falling as one over the sample size ({REC}). Open are fixation and loss over many sampled '
          'generations (a course of samplings each drawn from the last), drift and selection in one draw, and mutation: '
          'transmission that is not exact, read through the transmission term of the selection term\'s course over '
          'generations.')
edit(EVO, [(OLD_SEES, NEW_DRIFT + OLD_SEES), (OLD_TAB, NEW_TAB), (OLD_TAB2, NEW_TAB2), (OLD_C3, NEW_C3)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_thm': n_thm})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
