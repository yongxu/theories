#!/usr/bin/env python3
"""RS1 landing text: the study section, the significance review's reading-schedule check, the chapter (EN: section 4.4's
bullet and records, section 7.3's bullet and records, the constraint table's row 7, the relation to known results, the
record table and section 9's receipt, counts and audit sentence; ZH: section 4.4's theorem list and records, the record
table and section 9) and the board row moved to the history file with the queue and receipt sentences. Every edit must
match exactly once.

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
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.ReadingSchedule'
RID = 'one-reader-several-conditions'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW_LINK = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/'
               'BECOMING-SIGNIFICANCE-REVIEW.md#reading-schedule-check')
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


def line_from(text, start):
    i = text.index(start)
    assert text.count(start) == 1, start
    return text[i:text.index('\n', i)]


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
mod = next(m for m in R['modules'] if m['module'] == MOD)
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
assert not conn['apart_roots_unclassified'] and not conn['register_entries_not_apart_roots']
mod_apart = conn['apart_by_module'].get(MOD, [0])[0]

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart, {mod_apart} of the module\'s {n_mod_thm}; register check passes')
study = (HERE / 'study_rs1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_mod_thm, '{DECLS}': n_mod_decl, '{APART}': apart_text,
             '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG.startswith(f'{N}-one-reader-several-conditions'), SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[one-reader-several-conditions](../results/records/{RID}.md)'

# Significance review: the reading-schedule check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="reading-schedule-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n' + (HERE / 'review_section.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD44 = line_from(ch0, '- `Flow.withinGap_iff_between` with `Regulation.no_narrower_band`:') + '\n'
NEW44 = OLD44 + (
    '- `ReadingSchedule.keeps_iff_within`: one reader for several levels. A schedule reads one condition a step, and a '
    'draw on a condition is withdrawn `ℓ` steps after a step that reads it. With `(a + ℓ) d ≤ m < (a + 1 + ℓ) d`, the '
    'schedule keeps the condition within the margin `m`, against every balanced flow\'s draws of at most `d` a step, '
    'exactly where it reads it within every `a` steps (`Flow.Balances.retains_of_read`; the witness '
    '`ReadingSchedule.within_of_keeps`). What one reader keeps is then a question of windows (§7.3; '
    f'[study §{N}]({SA})).\n')
OLD44R = ('[two-sided-regulation-and-late-reading](../results/records/two-sided-regulation-and-late-reading.md)')
OLD44RL = line_from(ch0, 'Records: [giving-that-waits-on-giving](../results/records/giving-that-waits-on-giving.md)')
assert OLD44RL.count(OLD44R) == 1
NEW44RL = OLD44RL.replace(OLD44R, OLD44R + ', ' + REC)
OLD73 = line_from(ch0, '- **Measurement.** Where a formation observes a stock,') + '\n'
NEW73 = OLD73 + (
    '- **How often, and how many.** A reader that reads one condition a step keeps each condition exactly where it '
    'reads it within the window its margin, draw and lateness give (`ReadingSchedule.keeps_iff_within`, §4.4); each step '
    'of lateness shortens every window by one. What one reader can keep is a question of windows: their reciprocals sum '
    'to at most one (`ReadingSchedule.keeps_density`; a pool naming `k` a step, `k`), yet below one need not suffice: '
    'windows 2, 3 and any `M` are never kept together though a sixth of the reader, less `1/M`, is idle '
    '(`ReadingSchedule.spare_not_enough`); at most one half suffices, by a dyadic code (`ReadingSchedule.keeps_of_half`). '
    '*Limit:* this is pinwheel scheduling (Holte et al. 1989), whose exact threshold, five sixths, is Kawamura\'s (2024) '
    f'and is cited, not proved; the draw is diffuse, a bounded amount a step ([reading-schedule check]({REVIEW_LINK})).\n')
OLD73R = line_from(ch0, 'Records: [what-pooled-coupling-reaches](../results/records/what-pooled-coupling-reaches.md), '
                   '[observation-is-a-route]')
NEW73R = OLD73R.removesuffix('.') + ', ' + REC + '.'
OLD7 = ('a rule reading `ℓ` steps late needs a band at least `2 (ℓ + 1) d` wide (`Becoming.Regulation`). | Many levels, noisy '
        'rules and one policy keeping a band from every start under late reading are open. |')
NEW7 = ('a rule reading `ℓ` steps late needs a band at least `2 (ℓ + 1) d` wide (`Becoming.Regulation`); one reader keeps '
        'several levels exactly where it reads each within its window, and what it can keep is a pinwheel density '
        '(`Becoming.ReadingSchedule`). | The lumping of many levels into one, noisy rules and one policy keeping a band '
        'from every start under late reading are open. |')
OLDK = 'Results outside the ten: the laws fed from beyond'
NEWK = ('Results outside the ten: one reader keeping several conditions (`Becoming.ReadingSchedule`) is pinwheel '
        'scheduling (Holte, Mok, Rosier, Tulchinsky and Varvel 1989), the counting bound, the instance 2, 3, M and the '
        'one-half theorem restated, the five-sixths threshold Kawamura\'s (2024), cited, and keeping as reading within the '
        f'window the oversight check\'s delay observability ([reading-schedule check]({REVIEW_LINK})); the laws fed from beyond')
OLD_ROW = line_from(ch0, '| [Two-sided regulation, and regulation that reads late](../results/records/two-sided-regulation-and-late-reading.md) |') + '\n'
NEW_ROW = (f'| [One reader, several conditions](../results/records/{RID}.md) | theorem under stated premises | balance; a '
           'draw bounded a step, withdrawn a fixed number of steps after a reading; one reading a step; for the half '
           'theorem, whole weights within a power of two | §4.4, §7.3 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with RS1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD44, NEW44), (OLD44RL, NEW44RL), (OLD73, NEW73), (OLD73R, NEW73R), (OLD7, NEW7), (OLDK, NEWK),
         (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))
L2m = re.search(r'L2, the (\d+) modules whose source names the condition', ch0)
OLD_L1m = re.search(r'L1, the other (\d+) of the core,', ch0)
if L2m and OLD_L1m:
    L1 = mods['core'] - 1 - 3 - int(L2m.group(1))
    if OLD_L1m.group(0) != f'L1, the other {L1} of the core,':
        pairs.append((OLD_L1m.group(0), f'L1, the other {L1} of the core,'))
edit(CH, pairs)

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ44 = '`Flow.withinGap_iff_between`、`Regulation.no_narrower_band`；完整陈述见[英文版 §4.4]'
NEWZ44 = ('`Flow.withinGap_iff_between`、`Regulation.no_narrower_band`、`ReadingSchedule.keeps_iff_within`（每步读一个条件的日程，'
          '恰在每个窗口内读到一个条件时才使它保持在余量之内；一个读者能保持的窗口倒数之和至多为一，低于一未必足够，二分之一足够，'
          '即轮转调度，`ReadingSchedule.spare_not_enough`、`ReadingSchedule.keeps_of_half`）；完整陈述见[英文版 §4.4]')
OLDZR44 = ('[two-sided-regulation-and-late-reading](../results/records/two-sided-regulation-and-late-reading.md)。')
NEWZR44 = ('[two-sided-regulation-and-late-reading](../results/records/two-sided-regulation-and-late-reading.md)、'
           f'[{RID}](../results/records/{RID}.md)。')
OLDZROW = line_from(z, '| [双向调节，与迟读的调节](../results/records/two-sided-regulation-and-late-reading.md) |') + '\n'
NEWZROW = (f'| [一个读者，多个条件](../results/records/{RID}.md) | 在所述前提下的定理 | 平衡；每步汲取有界，读到后固定步数撤回；'
           '每步读一个；半数定理需整数权重在二的幂之内 | §4.4、§7.3 |\n')
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
edit(ZH, [(OLDZ44, NEWZ44), (OLDZR44, NEWZR44), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **RS1: one reader, several conditions**')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; new core module Becoming.ReadingSchedule, {n_mod_thm} '
            f'theorems in {n_mod_decl} declarations, empty axiom reports; record {RID}; study §{N}; prior art in the '
            'significance review (reading-schedule-check)')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is RS1's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('RS1 ')]
landed = (f'RS1 landed (one reader, several conditions: a schedule keeps a condition within its margin exactly where it '
          f'reads it within its window; the windows\' reciprocals sum to at most one, below one need not suffice, one half '
          f'suffices by a dyadic code; pinwheel scheduling read as a selection that only withdraws, the five-sixths '
          f'threshold cited; `Becoming.ReadingSchedule`, core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
