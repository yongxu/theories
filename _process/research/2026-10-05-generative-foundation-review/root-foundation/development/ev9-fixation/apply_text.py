#!/usr/bin/env python3
"""EV9 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt and counts), the evolution chapter (the drift bullet, the recovery table row and next connection
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
RID = 'fixation-by-drift'
EV8RID = 'drift-offspring-sampled'
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
study = (HERE / 'study_ev9.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_thm, '{DECLS}': n_decl, '{APART}': apart_text,
             '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert '{' not in study.split('```')[1], 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-fixation-by-drift-ev9'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
EV8REC = f'[{EV8RID}](../results/records/{EV8RID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD_B = 'Counting weighs the samplings and does not say which happens.\n'
NEW_B = ('Counting weighs the samplings and does not say which happens. Over many generations, each sampled from the last '
         '(`Drift.sampled`), the final count summed over the histories is its start times the whole weight '
         '(`Drift.sampled_count`), the ends absorb (`Drift.sampled_none`, `Drift.sampled_all`), the histories still varied '
         'after k generations weigh at most r^k with r + 2 = N^N (`Drift.varied_vanishes`), and the histories fixing the '
         'first kind have, times N, a share within N·r^k/(N^N)^k below h (`Drift.fixation`): drift alone ends variation '
         'and fixes each kind with its starting share h/N.\n')
OLD_RECS = f'{EV8REC}, [transmission'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
i = ch0.index(f'| [Drift: offspring sampled rather than listed](../results/records/{EV8RID}.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROW = (f'| [Fixation by drift](../results/records/{RID}.md) | theorem under stated premises | two kinds; a constant '
           'population of N, each generation N draws from the last with no selection or mutation in the draw; N at least '
           'two for the rate | §2.4 |\n')
i = ch0.index("9. **Evolution's selection term** (further proof).")
OLD9 = ch0[i:ch0.index('\n', i)]
OLD9a = 'and at least q^n, `Becoming.Drift`.)'
NEW9a = ('and at least q^n, and over many sampled generations the count kept on average, variation ending and each kind '
         'fixed with its starting share, `Becoming.Drift`.)')
OLD9b = 'fixation and loss over many sampled generations, and mutation (transmission not exact);'
NEW9b = 'drift with selection in one draw, and mutation (transmission not exact);'
assert OLD9.count(OLD9a) == 1 and OLD9.count(OLD9b) == 1, (OLD9.count(OLD9a), OLD9.count(OLD9b))
NEW9 = OLD9.replace(OLD9a, NEW9a).replace(OLD9b, NEW9b).replace(OLD_RECS, f'{EV8REC}, {REC}, [transmission')
i = ch0.index('Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
OLD_RECLINE = ch0[i:ch0.index('\n', i)]
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, f'{EV8REC}, {REC}, [transmission')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV9 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD_B, NEW_B), (OLD9, NEW9), (OLD_RECLINE, NEW_RECLINE), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ24 = '计数为各抽样加权，不说哪一种发生）、'
NEWZ24 = ('计数为各抽样加权，不说哪一种发生；多代中每代从上一代抽样（`Drift.sampled`），各历史的最终计数之和为起点乘总权重'
          '（`Drift.sampled_count`），两端吸收（`Drift.sampled_none`、`Drift.sampled_all`），k 代后仍有差异的历史之权重至多为 r^k、'
          '其中 r + 2 = N^N（`Drift.varied_vanishes`），固定第一类的历史乘以 N 在 h 乘总权重之下 N·r^k 之内（`Drift.fixation`）：'
          '单凭漂变即终结差异，并以起始份额 h/N 固定各类）、')
i = z.index(f'| [漂变：从后代中抽样而非列出](../results/records/{EV8RID}.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROW = (f'| [漂变导致的固定](../results/records/{RID}.md) | 在所述前提下的定理 | 两类；种群大小 N 不变，每代从上一代有放回地抽取 N 次，'
           '抽取中无选择与突变；速率需 N 至少为二 | §2.4 |\n')
i = z.index('9. **演化的选择项**（进一步的证明）。')
OLDZ9 = z[i:z.index('\n', i)]
OLDZ9a = '至少为 q^n，`Becoming.Drift`。）'
NEWZ9a = '至少为 q^n；多代抽样中平均保持计数、终结差异并以起始份额固定各类，`Becoming.Drift`。）'
OLDZ9b = '多代抽样中的固定与丢失，以及突变（不精确的传递）；'
NEWZ9b = '同一次抽取中的漂变与选择，以及突变（不精确的传递）；'
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
OLD_D = 'Counting weighs the samplings; it does not say which happens.\n'
NEW_D = ('Counting weighs the samplings; it does not say which happens. Over many generations, each sampled from the last, '
         'drift keeps the count on average and gives no direction, but it ends variation: the histories still varied '
         'vanish geometrically, and each kind is fixed with exactly its starting share in the limit, the neutral fixation '
         f'probability ({REC}).\n')
OLD_TAB = ('one generation of offspring sampled rather than listed, the Wright–Fisher sampling, with its spread and a bound '
           f'on undoing selection ({EV8REC})')
NEW_TAB = ('offspring sampled rather than listed, the Wright–Fisher sampling, with its spread, a bound on undoing selection, '
           f'and over many generations the neutral fixation probability ({EV8REC}, {REC})')
OLD_TAB2 = 'mutation, drift over many generations and movement are not covered there.'
NEW_TAB2 = 'mutation, drift with selection in one draw and movement are not covered there.'
OLD_TAB3 = 'on the spine, inexact transmission, fixation over sampled generations, the additive part'
NEW_TAB3 = 'on the spine, inexact transmission, drift with selection in one draw, the additive part'
OLD_C3 = ('Open are fixation and loss over many sampled '
          'generations (a course of samplings each drawn from the last), drift and selection in one draw, and mutation:')
NEW_C3 = ('Over many generations each sampled from the last, drift keeps the count on average, ends variation and fixes each '
          f'kind with its starting share ({REC}). Open are drift and selection in one draw (where the fixation share is no '
          'longer the starting share), and mutation:')
edit(EVO, [(OLD_D, NEW_D), (OLD_TAB, NEW_TAB), (OLD_TAB2, NEW_TAB2), (OLD_TAB3, NEW_TAB3), (OLD_C3, NEW_C3)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_thm': n_thm})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
