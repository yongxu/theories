#!/usr/bin/env python3
"""After merging main into RM6 and re-running the core checker on the merged tree: rewrite the receipt-dependent text
(chapter section 9's receipt line, counts table, steps and audit sentence, EN and ZH; the board's receipt sentence and
RM6's queue entry; RM6's row in the history file) for the new receipt.
usage (from the checkout root): python3 -B receipt_text.py RECEIPT OLD_RECEIPT BASE STUDY_SECTION"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
receipt_id, old_id, base, N = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
SA = f'{STUDY_LINK}#{N}-coupled-regimes-a-margin-that-is-not-its-own-rm6'
R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
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


def line_from(text, start):
    i = text.index(start)
    assert text.count(start) == 1, start
    return text[i:text.index('\n', i)]


ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with RM6 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
               "check and the core with the ring compiled from the prelude.")
i = ch0.index('| Core modules (with the root `Becoming`, 0 theorems) |')
j = ch0.index('\n', ch0.index('| Generated `injEq` lemmas on `propext` |', i))
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
ch = ch0.replace(OLD_RECEIPT, NEW_RECEIPT)
ch = ch[:ch.index('| Core modules (with the root `Becoming`, 0 theorems) |')] + NEW_TABLE + ch[ch.index('\n', ch.index('| Generated `injEq` lemmas on `propext` |', ch.index('| Core modules (with the root `Becoming`, 0 theorems) |'))):]
ch = re.sub(r'The run reused [\d,]+ cached Lean steps from `~/.cache/becoming-lean` and ran \d+;',
            f'The run reused {fmt(reused)} cached Lean steps from `~/.cache/becoming-lean` and ran {ran};', ch)
ch = re.sub(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.',
            f"with the base and its layers: {mods['core']} modules counting the root `Becoming`.", ch)
(ROOT / CH).write_text(ch, encoding='utf-8')
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
print('chapter EN')

z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZR = line_from(z, '**当前回执**是运行 [`')
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SA})）。")
i = z.index('| 核心模块（含根 `Becoming`） |')
j = z.index('\n', z.index('| 被取代的外围模块', i))
NEWZT = f"""| 核心模块（含根 `Becoming`） | {mods['core']} 个模块，{fmt(thms['core'])} 条定理 |
| 实例模块 | {mods['instance']} 个模块，{fmt(thms['instance'])} 条定理 |
| 应用模块 | {mods['application']} 个模块，{fmt(thms['application'])} 条定理 |
| 根基模块 | {mods['foundation']} 个模块，{thms['foundation']} 条定理 |
| 闭包（核心、环与根基） | {closure} 个模块，{fmt(closure_thms)} 条定理 |
| 审计的脊柱声明 | {fmt(spine_decls)} |
| 在 `propext` 上的生成的 `injEq` 引理 | 闭包中 {injeq} 条 |
| 被取代的外围模块（不在运行中，字节保留） | {len(R['superseded_modules'])} |"""
z = z.replace(OLDZR, NEWZR)
z = z[:i] + NEWZT + z[j:]
(ROOT / ZH).write_text(z, encoding='utf-8')
print('chapter ZH')

b = (ROOT / BOARD).read_text(encoding='utf-8')
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", b)
assert m
b = b.replace(m.group(0), f"the latest core receipt is RM6's `{receipt_id}` (21 October 2026)")
i = b.index('RM6 landed ('); j = b.index('row in the history file)', i)
seg = b[i:j]; assert seg.count(old_id) == 1
b = b[:i] + seg.replace(f'core receipt `{old_id}`', f'core receipt `{receipt_id}` (first run `{old_id}`)') + b[j:]
(ROOT / BOARD).write_text(b, encoding='utf-8')
h = (ROOT / HISTORY).read_text(encoding='utf-8').split('\n')
k = [i for i, l in enumerate(h) if l.startswith('| **RM6: coupled regimes')]; assert len(k) == 1
assert h[k[0]].count(f'core receipt `{old_id}`') == 1
h[k[0]] = h[k[0]].replace(f'core receipt `{old_id}`', f'core receipt `{receipt_id}` on the merged tree (first run `{old_id}`)')
(ROOT / HISTORY).write_text('\n'.join(h), encoding='utf-8')
print('board, history; spine theorems', spine_thms)
