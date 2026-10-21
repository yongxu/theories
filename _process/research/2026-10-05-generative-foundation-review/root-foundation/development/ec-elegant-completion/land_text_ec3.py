#!/usr/bin/env python3
"""EC3 landing text (adapted from EC2's) after the checker run: the study section; the chapter's theorem-map row for the new record (EN,
ZH) and section 9's receipt and counts (no new module, layers unchanged); the argument chapter's IV2 results marked
landed; D60's study section filled in; the coverage file's evaluation row lists the base instance of its central
declaration; the board row moved to the history file and the queue and receipt sentences. Every edit must match
exactly once (adapted from IV1's land_text.py).

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
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.InAmounts'
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
study = (HERE / 'study_ec3.txt').read_text(encoding='utf-8').replace('@N@', str(N)).replace('@RECEIPT@', receipt_id)
core_line = (f'\n**The run.** Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} '
             f'and {thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps '
             f'ran, {fmt(reused)} reused. {n_mod_decl} declarations of {MOD}, {n_mod_thm} of them theorems, all with empty '
             f'axiom reports. Connectivity: {apart} of {fmt(spine_thms)} apart, {mod_apart} of the module\'s {n_mod_thm}; '
             'register check passes.\n')
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n' + core_line, encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-one-rest-theorem-below-the-worlds-that-use-it-ec3'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'

# Chapter, English: section 9.
ch = (ROOT / CH).read_text(encoding='utf-8')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch).group(0)
L2 = int(re.search(r'L2, the (\d+) modules whose source names the condition', ch).group(1))
L1 = mods['core'] - 1 - 3 - L2
OLD_L1 = re.search(r'L1, the other (\d+) of the core,', ch).group(0)
i = ch.index('**The current receipt** is run [`')
OLD_RECEIPT = ch[i:ch.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EC3 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_L1, f'L1, the other {L1} of the core,'),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese: section 9.
z = (ROOT / ZH).read_text(encoding='utf-8')
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
edit(ZH, [(OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: EC's row says EC3 landed; the receipt and queue sentences.
b = (ROOT / BOARD).read_text(encoding='utf-8')
i = b.index('| **EC: an elegant completion**')
row = b[i:b.index('\n', i) + 1]
s = row.index('**EC3 (now): one rest theorem, below the worlds that use it.**')
e = row.index('its direct proof gone; ', s) + len('its direct proof gone; ')
new_row = row[:s] + (f'**EC3 landed** (one rest theorem below the worlds that use it: `Becoming.InAmounts` below `Becoming.Space`, '
                     f'`World.rests_unrefuted` and `World.rests_unrefuted_enclosed` its whole-number cases, two direct proofs and two '
                     f'duplicate names gone; core receipt `{receipt_id}`, study §{N}); ') + row[e:]
new_row = re.sub(r'EC3 claimed 2026-10-21 on `[0-9a-f]+`', f'EC3 landed 2026-10-21 (receipt `{receipt_id}`, study §{N})', new_row)
b = b.replace(row, new_row)
OLDR = re.search(r"the latest core receipt is [^`]*`[^`]+` \(\d+ October 2026\)\.", b).group(0)
b = b.replace(OLDR, f"the latest core receipt is EC3's `{receipt_id}` (21 October 2026).")
assert b.count('- **Queue:** ') == 1
b = b.replace('- **Queue:** ', f'- **Queue:** EC3 landed (one rest theorem below the worlds that use it: `Becoming.InAmounts` below `Becoming.Space`; core receipt `{receipt_id}`, study §{N}); ')
(ROOT / BOARD).write_text(b, encoding='utf-8')
print('board row updated; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
