#!/usr/bin/env python3
"""LC2 landing text after the checker run: the study section; the chapter (EN: the modelling-choices row, section
1.3's bullet and records, the theorem-map row, the relation to known results, section 8.1 item 6, section 9's receipt,
counts and layers; ZH: the same rows, item 6 and section 9); the board row moved to the history file and the queue and
receipt sentences. Every edit must match exactly once (adapted from LC1's land_text.py).

usage (from the checkout root): python3 -B land_text.py RECEIPT CONNECTIVITY_LOG BASE
Prints the study section number."""
import json
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = f'{RF}/BECOMING-RENEWAL-READING.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.InAmounts'
RID = 'rest-theorem-in-any-amounts'
REC = f'[{RID}](../results/records/{RID}.md)'
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
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
core = [m for m in R['modules'] if m['layer'] == 'core']
mod = next(m for m in core if m['module'] == MOD)
ll = next(m for m in core if m['module'] == 'Becoming.LeastLoss')
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
mod_apart = conn['apart_by_module'].get(MOD, [0])[0]

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart, {mod_apart} of the module\'s {n_mod_thm}; no new apart root')
study = (HERE / 'study_lc2.txt').read_text(encoding='utf-8')
study = (study.replace('{N}', str(N)).replace('{RECEIPT}', receipt_id).replace('{THEOREMS}', str(n_mod_thm))
         .replace('{DECLS}', str(n_mod_decl)).replace('{LL_THEOREMS}', str(ll['theorems']))
         .replace('{APART}', apart_text).replace('{CORE_LINE}', core_line))
assert '{' not in re.sub(r'`[^`]*`', '', study.split('```')[1]), 'unfilled placeholder'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-the-rest-theorem-over-any-amounts-read-finitely-lc2'
SA = f'../../../{STUDY}#{SLUG}'

# Chapter, English.
MC_OLD = ("of which `falls_not_recurring` is the whole-number instance (§1.3). The second law supplies no least loss per "
          "step.")
MC_NEW = ("of which `falls_not_recurring` is the whole-number instance (§1.3); read in any amounts, the rest theorem needs "
          "instead that the census's total be read off finitely many configurations "
          "(`World.InAmounts.rests_unrefuted_enclosed`), and with neither a world in dense amounts need not rest "
          "(`HalvingPass.never_rests`). The second law supplies no least loss per step.")
MCC_OLD = "dense amounts in `Becoming.Amounts`, each premise needed (`Becoming.LeastLoss`) |"
MCC_NEW = ("dense amounts in `Becoming.Amounts`, each premise needed (`Becoming.LeastLoss`), worlds in any amounts in "
           "`Becoming.InAmounts` |")
B_OLD = ("This is Landauer's count, with no energy ([rest-from-a-finite-reading](../results/records/rest-from-a-finite-reading.md), "
         "[merge-of-a-part-kept-by-the-rest](../results/records/merge-of-a-part-kept-by-the-rest.md)).")
B_NEW = (B_OLD + " The rest theorem itself holds over any amounts read finitely. Read a world's standings, takes and gives "
         "in any amounts (`World.InAmounts`): balanced (no amount made) and dissipated on (whatever gives back all it "
         "takes takes nothing), a family's total does not rise and falls strictly at every change of a level, with no "
         "least loss (`World.InAmounts.change_lowers`); so where the census's total is read off configurations a list "
         "holds, a world with a census, every relatum embodied, balanced, dissipative and enclosed from some step on "
         "rests, unrefuted (`World.InAmounts.rests_unrefuted_enclosed`; covered by one family "
         "`World.InAmounts.rests_unrefuted_covering`, finite `World.InAmounts.rests_unrefuted`). Whole-number worlds are "
         "the instance (`World.rests_unrefuted_enclosed_read`), and a standing halving as it passes between two relata "
         "meets every other premise and arises and ceases without end, its levels held by no list "
         f"(`HalvingPass.never_rests`, `HalvingPass.levels_unlisted`; {REC}).")
BR_OLD = ("[least-loss-from-entropy-production](../results/records/least-loss-from-entropy-production.md), "
          "[continuing-self-fed-from-beyond]")
BR_NEW = ("[least-loss-from-entropy-production](../results/records/least-loss-from-entropy-production.md), "
          f"{REC}, [continuing-self-fed-from-beyond]")
ROW_F = "| [Rest from a finite reading](../results/records/rest-from-a-finite-reading.md) | theorem without premise | — | §1.3 |\n"
ROW_N = (f"| [The rest theorem in any amounts, read finitely](../results/records/{RID}.md) | theorem under stated premises "
         "| dissipation | §1.3 |\n")
K4_OLD = "a part's merge kept by the rest is Landauer's (1961) phase-space count |"
K4_NEW = ("a part's merge kept by the rest is Landauer's (1961) phase-space count; the rest theorem over any amounts read "
          "finitely is the finite-state LaSalle argument (LaSalle 1976; Mei and Bullo 2017) and the termination of "
          "chip-firing (Björner, Lovász and Shor 1991), its dense counterexample a discrete Zeno behaviour |")
I6_OLD = "heat, `Amounts.rests_of_finite_reading`, `Law.Lossless.narrowing_spreads`. Every physical"
I6_NEW = ("heat, `Amounts.rests_of_finite_reading`, `Law.Lossless.narrowing_spreads`; and the rest theorem holds over any "
          "amounts where the census's total is read off finitely many configurations, and need not otherwise, "
          f"`World.InAmounts.rests_unrefuted_enclosed`, `HalvingPass.never_rests`, [study §{N}]({SA}). Every physical")
I6O_OLD = "the flow, web and world over any amounts (each natural-number law"
I6O_NEW = "the other laws of the flow, web and world over any amounts (the rest theorem is stated; each natural-number law"
I6R_OLD = ("[merge-of-a-part-kept-by-the-rest](../results/records/merge-of-a-part-kept-by-the-rest.md), "
           "[entropy-history-and-record]")
I6R_NEW = ("[merge-of-a-part-kept-by-the-rest](../results/records/merge-of-a-part-kept-by-the-rest.md), "
           f"{REC}, [entropy-history-and-record]")
ch = (ROOT / CH).read_text(encoding='utf-8')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch).group(0)
L2 = int(re.search(r'L2, the (\d+) modules whose source names the condition', ch).group(1))
L1 = mods['core'] - 1 - 3 - L2
OLD_L1 = re.search(r'L1, the other (\d+) of the core,', ch).group(0)
i = ch.index('**The current receipt** is run [`')
OLD_RECEIPT = ch[i:ch.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with LC2 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
               "check and the core with the ring compiled from the prelude.")
i = ch.index('| Core modules (with the root `Becoming`, 0 theorems) |')
j = ch.index('\n', ch.index('| Generated `injEq` lemmas on `propext` |', i))
OLD_TABLE = ch[i:j]
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
OLD_STEPS = re.search(r'The run reused [\d,]+ cached Lean steps from `~/.cache/becoming-lean` and ran \d+;', ch).group(0)
NEW_STEPS = f'The run reused {fmt(reused)} cached Lean steps from `~/.cache/becoming-lean` and ran {ran};'
edit(CH, [(MC_OLD, MC_NEW), (MCC_OLD, MCC_NEW), (B_OLD, B_NEW), (BR_OLD, BR_NEW), (ROW_F, ROW_F + ROW_N),
          (K4_OLD, K4_NEW), (I6_OLD, I6_NEW), (I6O_OLD, I6O_NEW), (I6R_OLD, I6R_NEW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_L1, f'L1, the other {L1} of the core,'),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
ZM_OLD = "一般形式是最小损失之律（`Amounts.rests`）。"
ZM_NEW = ("一般形式是最小损失之律（`Amounts.rests`）；以任何量读取时，停息定理改为需要普查的总量读自有限多个构形"
          "（`World.InAmounts.rests_unrefuted_enclosed`），两者皆无时，稠密量中的世界不必停息（`HalvingPass.never_rests`）。")
ZROW_F = "| [由有限的读取而停息](../results/records/rest-from-a-finite-reading.md) | 不加前提的定理 | — | §1.3 |\n"
ZROW_N = f"| [任何量中的停息定理，有限地读取](../results/records/{RID}.md) | 在所述前提下的定理 | 耗散 | §1.3 |\n"
ZK4_OLD = "部分的合并由其余部分承接是 Landauer（1961）的相空间计数 |"
ZK4_NEW = ("部分的合并由其余部分承接是 Landauer（1961）的相空间计数；任何量上有限读取时的停息定理是有限状态的 LaSalle 论证"
           "（LaSalle 1976；Mei 与 Bullo 2017）与筹码发射的终止（Björner、Lovász 与 Shor 1991），其稠密反例是离散的 Zeno 行为 |")
ZI6_OLD = "`Law.Lossless.narrowing_spreads`。物理给出的"
ZI6_NEW = ("`Law.Lossless.narrowing_spreads`；停息定理在普查的总量读自有限多个构形之处对任何量成立，否则不必，"
           f"`World.InAmounts.rests_unrefuted_enclosed`、`HalvingPass.never_rests`，[研究第 {N} 节]({SA})。物理给出的")
ZI6O_OLD = "任何量上的流、依存网与世界；"
ZI6O_NEW = "任何量上的流、依存网与世界的其他规律（停息定理已陈述）；"
ZBR_OLD = "[least-loss-from-entropy-production](../results/records/least-loss-from-entropy-production.md)、"
ZBR_NEW = f"[least-loss-from-entropy-production](../results/records/least-loss-from-entropy-production.md)、{REC}、"
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
edit(ZH, [(ZM_OLD, ZM_NEW), (ZROW_F, ZROW_F + ZROW_N), (ZK4_OLD, ZK4_NEW), (ZI6_OLD, ZI6_NEW), (ZI6O_OLD, ZI6O_NEW),
          (ZBR_OLD, ZBR_NEW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **LC2: the rest theorem over any amounts')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-20, core receipt `{receipt_id}`; new core module {MOD}, {n_mod_thm} theorems, and '
            f'Becoming.LeastLoss {ll["theorems"]}, empty axiom reports; record {RID}; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(20 October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is LC2's `{receipt_id}` (20 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
landed = (f'LC2 landed (the rest theorem over any amounts where the census\'s total is read finitely, `{MOD}`; core '
          f'receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + landed + '; ' + m.group(1))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
