#!/usr/bin/env python3
"""LC3 landing text after the checker run: the study section; the chapter (EN: the modelling-choices row, section
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
RID = 'rest-exactly-where-falls-stop'
REC2 = '[rest-theorem-in-any-amounts](../results/records/rest-theorem-in-any-amounts.md)'
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
study = (HERE / 'study_lc3.txt').read_text(encoding='utf-8')
study = (study.replace('{N}', str(N)).replace('{RECEIPT}', receipt_id).replace('{THEOREMS}', str(n_mod_thm))
         .replace('{DECLS}', str(n_mod_decl)).replace('{LL_THEOREMS}', str(ll['theorems']))
         .replace('{APART}', apart_text).replace('{CORE_LINE}', core_line))
assert '{' not in re.sub(r'`[^`]*`', '', study.split('```')[1]), 'unfilled placeholder'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-one-rest-theorem-over-any-amounts-exactly-where-the-total-stops-falling-lc3'
SA = f'../../../{STUDY}#{SLUG}'

# Chapter, English.
MC_OLD = ("read in any amounts, the rest theorem needs instead that the census's total be read off finitely many "
          "configurations (`World.InAmounts.rests_unrefuted_enclosed`), and with neither a world in dense amounts need "
          "not rest (`HalvingPass.never_rests`).")
MC_NEW = ("read in any amounts, the rest theorem needs exactly that the census's total stop falling "
          "(`World.InAmounts.change_stops_iff`, `World.InAmounts.rests_unrefuted_enclosed_of_stops`), which a finite "
          "reading or a least fall in Archimedean amounts gives, and along an amount falling at every step a world need "
          "not rest (`Pass.endless_keeps_from_rest`).")
B_OLD = ("Whole-number worlds are the instance (`World.rests_unrefuted_enclosed_read`), and a standing halving as it "
         "passes between two relata meets every other premise and arises and ceases without end, its levels held by no "
         "list (`HalvingPass.never_rests`, `HalvingPass.levels_unlisted`; " + REC2 + ").")
B_NEW = ("Its one premise is that the census's total stops falling: a family balanced and dissipated on stops changing "
         "exactly where its total stops falling (`World.InAmounts.change_stops_iff`), and a world whose census's total "
         "stops falling rests (`World.InAmounts.rests_unrefuted_enclosed_of_stops`). A finite reading gives it, and so "
         "do amounts in which no amount falls without end, which a least fall in Archimedean amounts gives "
         "(`Amounts.noEndlessFall_of_fallsAtLeast`); whole-number worlds are the instance with their own premises and "
         "nothing more (`World.rests_unrefuted_enclosed_whole`, `World.rests_unrefuted_whole`). Along any amount falling "
         "at every step a standing passing between two relata meets every other premise and never rests, its levels "
         "held by no list (`Pass.endless_keeps_from_rest`, `Pass.levels_unlisted`); so dyadic amounts (no least fall) "
         "and layered amounts (not Archimedean) each carry a world that never rests, and rest over every world in given "
         "amounts lies between no endless fall and none at every step (`Amounts.worldsRest_of_noEndlessFall`, "
         f"`Amounts.not_endlessFall_of_worldsRest`; {REC2}, {REC}).")
ROW_2 = (f"| [The rest theorem in any amounts, read finitely](../results/records/rest-theorem-in-any-amounts.md) | theorem "
         "under stated premises | dissipation | §1.3 |\n")
ROW_N = (f"| [Rest exactly where the total stops falling](../results/records/{RID}.md) | theorem under stated premises "
         "| dissipation | §1.3 |\n")
K4_OLD = "chip-firing (Björner, Lovász and Shor 1991), its dense counterexample a discrete Zeno behaviour |"
K4_NEW = ("chip-firing (Björner, Lovász and Shor 1991), its dense counterexample a discrete Zeno behaviour; rest over every "
          "world in given amounts is the well-foundedness of their strict order, as in Floyd's (1967) termination by "
          "well-founded sets, and a least fall in Archimedean amounts is the discrete case of Hölder's (1901) theorem |")
I6_OLD = ("and the rest theorem holds over any amounts where the census's total is read off finitely many configurations, "
          "and need not otherwise, `World.InAmounts.rests_unrefuted_enclosed`, `HalvingPass.never_rests`, [study §267]")
I6_NEW = ("and the rest theorem holds over any amounts exactly where the census's total stops falling, which a finite "
          "reading or a least fall in Archimedean amounts gives, and along an endless fall it fails, "
          "`World.InAmounts.change_stops_iff`, `World.InAmounts.rests_unrefuted_enclosed_of_stops`, "
          "`Amounts.noEndlessFall_of_fallsAtLeast`, `Pass.endless_keeps_from_rest`, "
          f"[study §{N}]({SA}), [study §267]")
I6O_OLD = "the other laws of the flow, web and world over any amounts (the rest theorem is stated;"
I6O_NEW = ("whether rest over every world in given amounts is, constructively, the absence of an endless fall (between them "
           "lies choosing the steps at which an amount falls); the other laws of the flow, web and world over any amounts "
           "(the rest theorem is stated with its one premise;")
REC_L_OLD = f"{REC2}, "
REC_L_NEW = f"{REC2}, {REC}, "
ch = (ROOT / CH).read_text(encoding='utf-8')
assert ch.count(REC_L_OLD) == 2, ch.count(REC_L_OLD)
ch = ch.replace(REC_L_OLD, REC_L_NEW)
(ROOT / CH).write_text(ch, encoding='utf-8')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch).group(0)
L2 = int(re.search(r'L2, the (\d+) modules whose source names the condition', ch).group(1))
L1 = mods['core'] - 1 - 3 - L2
OLD_L1 = re.search(r'L1, the other (\d+) of the core,', ch).group(0)
i = ch.index('**The current receipt** is run [`')
OLD_RECEIPT = ch[i:ch.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with LC3 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(MC_OLD, MC_NEW), (B_OLD, B_NEW), (ROW_2, ROW_2 + ROW_N), (K4_OLD, K4_NEW), (I6_OLD, I6_NEW),
         (I6O_OLD, I6O_NEW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))
if OLD_L1 != f'L1, the other {L1} of the core,':
    pairs.append((OLD_L1, f'L1, the other {L1} of the core,'))
edit(CH, pairs)

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
ZM_OLD = ("以任何量读取时，停息定理改为需要普查的总量读自有限多个构形（`World.InAmounts.rests_unrefuted_enclosed`），两者皆无时，"
          "稠密量中的世界不必停息（`HalvingPass.never_rests`）。")
ZM_NEW = ("以任何量读取时，停息定理恰好需要普查的总量停止下降（`World.InAmounts.change_stops_iff`、"
          "`World.InAmounts.rests_unrefuted_enclosed_of_stops`），有限的读取或阿基米德量中的最小下降给出这一点；沿着每步都下降的量，"
          "世界不必停息（`Pass.endless_keeps_from_rest`）。")
ZROW_2 = "| [任何量中的停息定理，有限地读取](../results/records/rest-theorem-in-any-amounts.md) | 在所述前提下的定理 | 耗散 | §1.3 |\n"
ZROW_N = f"| [恰在总量停止下降之处停息](../results/records/{RID}.md) | 在所述前提下的定理 | 耗散 | §1.3 |\n"
ZK4_OLD = "其稠密反例是离散的 Zeno 行为 |"
ZK4_NEW = ("其稠密反例是离散的 Zeno 行为；给定的量中每个世界都停息，即其严格序的良基性，如 Floyd（1967）以良基集证明终止；"
           "阿基米德量中的最小下降是 Hölder（1901）定理的离散情形 |")
ZI6_OLD = ("停息定理在普查的总量读自有限多个构形之处对任何量成立，否则不必，`World.InAmounts.rests_unrefuted_enclosed`、"
           "`HalvingPass.never_rests`，[研究第 267 节]")
ZI6_NEW = ("停息定理恰在普查的总量停止下降之处对任何量成立，有限的读取或阿基米德量中的最小下降给出这一点，沿着无尽的下降则不成立，"
           "`World.InAmounts.change_stops_iff`、`World.InAmounts.rests_unrefuted_enclosed_of_stops`、"
           f"`Amounts.noEndlessFall_of_fallsAtLeast`、`Pass.endless_keeps_from_rest`，[研究第 {N} 节]({SA})、[研究第 267 节]")
ZI6O_OLD = "任何量上的流、依存网与世界的其他规律（停息定理已陈述）；"
ZI6O_NEW = ("给定的量中每个世界都停息，在构造上是否就是没有无尽的下降（两者之间是选取量下降的那些步）；"
            "任何量上的流、依存网与世界的其他规律（停息定理已以其唯一前提陈述）；")
ZBR_OLD = f"{REC2}、"
ZBR_NEW = f"{REC2}、{REC}、"
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
edit(ZH, [(ZM_OLD, ZM_NEW), (ZROW_2, ZROW_2 + ZROW_N), (ZK4_OLD, ZK4_NEW), (ZI6_OLD, ZI6_NEW), (ZI6O_OLD, ZI6O_NEW),
          (ZBR_OLD, ZBR_NEW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **LC3: one rest theorem over any amounts')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; Becoming.InAmounts {n_mod_thm} theorems and '
            f'Becoming.LeastLoss {ll["theorems"]}, empty axiom reports; record {RID}; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d+ October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is LC3's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
landed = (f'LC3 landed (one rest theorem over any amounts, exactly where the total stops falling: a least fall in '
          f'Archimedean amounts or a finite reading gives it, an endless fall keeps a world from rest; `{MOD}`, '
          f'`Becoming.LeastLoss`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + landed + '; ' + m.group(1))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
