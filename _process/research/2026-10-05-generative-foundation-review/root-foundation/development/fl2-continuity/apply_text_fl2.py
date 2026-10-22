#!/usr/bin/env python3
"""FL2 landing text: the study section; the significance review's continuity check; the chapter (EN: premise card C,
§8.7's balance bullet and records, the relation to known results, the record table with FL1's missing row, and section
9; ZH: §8.7's clause, the record table and section 9); the connectivity register (the two Teleport witnesses); and the
board (the FL2 row moves to the history file, FL1's row moved before the lapsed claims where its landing appended it;
the queue and the receipt sentence name the landing). Every edit must match exactly once.

usage (from the checkout root): python3 -B apply_text_fl2.py RECEIPT CONNECTIVITY_LOG BASE
Prints the study section number and slug."""
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
REVIEW = f'{RF}/BECOMING-SIGNIFICANCE-REVIEW.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HIST = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
RID = 'balance-from-conservation-along-a-relation'
REC = f'[{RID}](../results/records/{RID}.md)'
REVIEW_LINK = f'../../../{REVIEW}#continuity-check'
receipt_id, conn_log, base = sys.argv[1:4]


def edit(path, pairs):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    for old, _ in pairs:
        k = text.count(old)
        if k != 1:
            sys.exit(f'{path}: expected one match, found {k}: {old[:100]!r}')
    for old, new in pairs:
        text = text.replace(old, new)
    p.write_text(text, encoding='utf-8')
    print('edited', path, len(pairs))


def line_from(text, start):
    assert text.count(start) == 1, start
    i = text.index(start)
    return text[i:text.index('\n', i)]


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Continuity')
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
t = (ROOT / conn_log).read_text()
conn = json.loads(t[t.index('{'):t.rindex('}') + 1])
apart = sum(v for k, v in conn['classes'].items() if k.startswith('apart'))
assert conn['spine_theorems'] == spine_thms, (conn['spine_theorems'], spine_thms)
mine = [n for n in conn['apart_roots_unclassified'] if n.startswith('Becoming.Continuity.')]
assert not mine, mine
mod_apart = conn['apart_by_module'].get('Becoming.Continuity', [0])[0]

# --- the study section
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
others = list(conn['apart_roots_unclassified'])
apart_text = (f'{apart} of {fmt(spine_thms)} apart, {mod_apart} of the module\'s {n_thm}; its two apart roots, the '
              'Teleport witnesses, registered (model witness)'
              + (f'; unregistered roots of other landings, not FL2\'s: {", ".join(others)}' if others else ''))
s = (HERE / 'study_fl2.txt').read_text(encoding='utf-8')
for a, b in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_thm, '{DECLS}': n_decl, '{APART}': apart_text,
             '{CORE_LINE}': core_line}.items():
    s = s.replace(a, str(b))
assert not re.search(r'\{[A-Z_]+\}', s) and s.count('```') % 2 == 0
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug  # noqa: E402
slug = github_slug(s.split('\n', 1)[0].lstrip('# ').strip())
assert slug.startswith(f'{N}-balance-from-conservation-along-a-relation'), slug
SL = f'../../../{STUDY}#{slug}'

# --- the chapter, EN
ch0 = (ROOT / CH).read_text(encoding='utf-8')
C_OLD = ('Read physically, it is the first law with locality: in available work, the levels balance exactly where no '
         'store generates entropy (`balances_iff_stores_generate_nothing`, §8.7).')
C_NEW = C_OLD + (' Locality need not be read off transfers: over finitely many relata, transfers along a relation that '
                 'balance a step exist exactly where the total is conserved on every family the relation closes, and a '
                 'law that reads only related relata and conserves its total conserves it on every such family '
                 f'(`Continuity.balancing_iff`, `Continuity.conservedOn_of_law`; [study §{N}]({SL})).')
L_OLD = 'Locality and the reading are the correspondence.\n'
L_NEW = ('Locality and the reading are the correspondence; on the core, the transfers themselves follow from conservation '
         'on every family a relation closes, which a law reading only related relata and conserving its total gives '
         '(`Continuity.balancing_iff`, `Continuity.balancesOn_of_law`), and the swap of two levels balances along the '
         'relation it reads and not along the empty one (`Continuity.Teleport`).\n')
R_OLD = 'Records: [balance-from-the-first-law](../results/records/balance-from-the-first-law.md), '
R_NEW = R_OLD + REC + ', '
K_OLD = 'Results outside the ten: '
K_NEW = K_OLD + ('balance along a relation as conservation on every family it closes (`Becoming.Continuity`) is the '
                 'network-flow fact that a prescribed divergence is a flow exactly where it sums to zero on each '
                 'component; the local flux of a conserved quantity, known for cellular automata on lattices (Hattori and '
                 'Takesue 1991; Pivato 2002), is not reproduced '
                 f'([continuity check]({REVIEW_LINK})); ')
ROW_OLD = line_from(ch0, '| [The least loss from entropy production](../results/records/least-loss-from-entropy-production.md) |') + '\n'
ROW_NEW = ROW_OLD + (
    '| [Balance from the first law](../results/records/balance-from-the-first-law.md) | theorem under stated premises '
    '(periphery) | available work relative to one environment; locality; the first law and the entropy balance at '
    'stores and exchanges | §0, §8.7 |\n'
    f'| [Balance from conservation along a relation](../results/records/{RID}.md) | theorem under stated premises | '
    'finitely many relata; a decided relation; for the law, conservation from every configuration | §0, §8.7 |\n')
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with FL2 in the working tree ([study §{N}]({SL})). It passed, the source unchanged during "
               "the check and the core with the ring compiled from the prelude.")
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
pairs = [(C_OLD, C_NEW), (L_OLD, L_NEW), (R_OLD, R_NEW), (K_OLD, K_NEW), (ROW_OLD, ROW_NEW), (OLD_RECEIPT, NEW_RECEIPT),
         (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# --- the chapter, ZH
z = (ROOT / ZH).read_text(encoding='utf-8')
Z_OLD = '故平衡与耗散出自同一读法；'
Z_NEW = (Z_OLD + '在核心上，沿一个关系使一步平衡的转移，恰在总量于该关系封闭的每个家族上守恒时存在，只读相关关系项、守恒总量的规律给出这一守恒'
         '（`Continuity.balancing_iff`、`Continuity.conservedOn_of_law`）；')
ZROW_OLD = line_from(z, '| [熵产生给出的最小损失](../results/records/least-loss-from-entropy-production.md) |') + '\n'
ZROW_NEW = ZROW_OLD + (
    '| [第一定律给出的平衡](../results/records/balance-from-the-first-law.md) | 在所述前提下的定理（外围） | 相对于一个环境的可用功；'
    '局部性；储存与交换处的第一定律与熵平衡 | §0、§8.7 |\n'
    f'| [沿关系的守恒给出的平衡](../results/records/{RID}.md) | 在所述前提下的定理 | 有限多个关系项；可判定的关系；对规律，从每个配置守恒 '
    '| §0、§8.7 |\n')
OLDZR = line_from(z, '**当前回执**是运行 [`')
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SL})）。")
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
zpairs = [(Z_OLD, Z_NEW), (ZROW_OLD, ZROW_NEW), (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

# --- write: study, review, chapter EN and ZH
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + s.rstrip('\n') + '\n', encoding='utf-8')
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="continuity-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'review_section.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
edit(CH, pairs)
exec((ROOT / f'{RF}/development/rm10-recent/section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)

# --- the board
board = (ROOT / BOARD).read_text(encoding='utf-8')
lines = board.split('\n')
k = [i for i, l in enumerate(lines) if l.startswith('| **FL2: ')]
assert len(k) == 1
cells = lines[k[0]].split(' | ')
cells[2] = (f'claimed 2026-10-22 on `1a9c65707`; landed, core receipt `{receipt_id}`; new core module Becoming.Continuity, '
            f'{n_thm} theorems in {n_decl} declarations, empty axiom reports; record {RID}; study §{N}; prior art in the '
            'significance review (continuity-check)')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
del lines[k[0]]
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is FL2's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
landed = (f'FL2 landed (balance from conservation along a relation: transfers along a relation balancing a step exist '
          f'exactly where the total is conserved on every family it closes, and a law reading only related relata and '
          f'conserving its total gives that; `Becoming.Continuity`, core receipt `{receipt_id}`, study §{N}, record {RID}; '
          'row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + landed + '; ' + m.group(1))
(ROOT / BOARD).write_text(board, encoding='utf-8')
h = (ROOT / HIST).read_text(encoding='utf-8')
anchor = '\n## Lapsed claims (18 October 2026)'
assert h.count(anchor) == 1
# FL1's row was appended after the lapsed claims; it belongs with the landed rows
hl = h.split('\n')
fl1 = [i for i, l in enumerate(hl) if l.startswith('| **FL1: ')]
fl1_row = None
if fl1 and fl1[0] > hl.index(anchor.strip('\n')):
    fl1_row = hl.pop(fl1[0])
h = '\n'.join(hl)
i = h.index(anchor)
h = h[:i].rstrip('\n') + '\n' + (fl1_row + '\n' if fl1_row else '') + row + '\n' + h[i:]
(ROOT / HIST).write_text(h.rstrip('\n') + '\n', encoding='utf-8')
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
print('STUDY_SLUG', slug)
