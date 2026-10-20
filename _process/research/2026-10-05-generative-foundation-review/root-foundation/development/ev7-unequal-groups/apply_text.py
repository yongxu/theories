#!/usr/bin/env python3
"""EV7 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt and counts), the evolution chapter (its summary and next connection 1), the coverage file's
evolution row, the board row moved to the history file and the queue and receipt sentences. Every edit
must match exactly once.

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
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD, SLM = 'Becoming.GroupEnding', 'Becoming.SelectionLevels'
RID = 'selection-within-and-among-groups-of-any-sizes'
EV6RID = 'groups-whose-conditions-are-coupled'
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
slm = next(m for m in core if m['module'] == SLM)
n_mod_thm, n_mod_decl = mod['theorems'], len(mod['declarations'])
n_sl_thm, n_sl_decl = slm['theorems'], len(slm['declarations'])
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
apart_text = f'{apart} of {fmt(spine_thms)} apart, no new apart root; register check passes'
study = (HERE / 'study_ev7.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_mod_thm, '{DECLS}': n_mod_decl,
             '{SL_THEOREMS}': n_sl_thm, '{SL_DECLS}': n_sl_decl, '{APART}': apart_text,
             '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert '{' not in study.split('```')[1].replace('{N}', ''), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-groups-of-any-sizes-and-regrouping-ev7'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
EV6REC = f'[{EV6RID}](../results/records/{EV6RID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
i = ch0.index('- `SelectionLevels.levels`: selection within groups and among them,')
OLD_AFTER = ch0[i:ch0.index('\n', i) + 1]
NEW_BULLET = (
    "- `SelectionLevels.levels_sized`: selection within groups and among them for groups of any sizes. With n a common "
    "multiple of the sizes and each group's own term by n over its size, n squared times the whole's term balances n "
    "times the whole's size times the groups' own terms with the term of the groups' means read member by member; "
    "divided through, the whole's covariance is the size-weighted mean of the groups' covariances with the "
    "size-weighted covariance of their means, and `SelectionLevels.levels` is its case with equal sizes. Read by their "
    "totals, groups of unequal size can show nothing among them while their means carry all the whole's selection "
    "(`SelectionLevels.ByMeans.by_means`). Where the groups' means are alike nothing is selected among them, so a "
    "generation listed as groups alike in mean raises its mean exactly as selection within them goes "
    "(`SelectionLevels.rises_exact_iff_within_of_alike`): how the next generation is listed does not enter a step, "
    "but it fixes the next step's among-group part. Ending fixes that part for any sizes "
    "(`GroupEnding.Flow.rises_iff_inactive_sized`), and can use it up: with two keeping groups beside a group leaving "
    "nothing, holding back rises by selection among groups, the offspring of each keeping group form groups alike in "
    "it, and at the next step it falls below where it started (`GroupEnding.Exhausted.next_step`).\n")
OLD_RECS = f'{EV6REC}, [transmission'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
i = ch0.index(f'| [Groups whose conditions are coupled](../results/records/{EV6RID}.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROW = (f'| [Selection within and among groups of any sizes](../results/records/{RID}.md) | theorem under stated premises | '
           'a common multiple of the groups\' sizes; exact transmission and the generation listed as the groups for the '
           'course over generations; for ending, the groups with a lower mean leaving nothing | §2.4 |\n')
i = ch0.index("9. **Evolution's selection term** (further proof).")
OLD9 = ch0[i:ch0.index('\n', i)]
NEW9 = OLD9.replace('selection within groups and among them, for groups of equal size, `Becoming.SelectionLevels`;',
                    'selection within groups and among them, for groups of any sizes, the among-group part read by the '
                    'groups\' means, and groups alike in mean leaving selection within alone, `Becoming.SelectionLevels`;')
NEW9 = NEW9.replace('groups of unequal size, mixing between groups, and how groups and their couplings form;',
                    'mixing between groups beyond how the next generation is listed (transmission not exact across '
                    'groups), and how groups and their couplings form and keep their differences;')
NEW9 = NEW9.replace(f'{EV6REC}, [transmission', f'{EV6REC}, {REC}, [transmission')
assert NEW9.count(REC) == 1 and 'groups of any sizes' in NEW9 and 'keep their differences' in NEW9, NEW9[-500:]
i = ch0.index('Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
OLD_RECLINE = ch0[i:ch0.index('\n', i)]
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, f'{EV6REC}, {REC}, [transmission')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV7 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLDZ24 = '`GroupEnding.Flow.coupled_end_together`（成员依存于同一个这样的族的各组一同终结，组间无选择；故终止只在族与族之间选择组）、'
NEWZ24 = (OLDZ24 + '`SelectionLevels.levels_sized`（各组大小任意：取各组大小的公倍数 n，各组自身之项乘以 n 除以其大小，n 的平方乘整体之项，'
          '与 n 乘整体大小乘各组自身之项、以及逐成员读出的组均值之项相平衡；即以大小加权的总协方差律，大小相等时即 `SelectionLevels.levels`）、'
          '`SelectionLevels.ByMeans.by_means`（按总量读，大小不等的组间可能看不出任何选择，而其均值承载了整体的全部选择）、'
          '`SelectionLevels.rises_exact_iff_within_of_alike`（下一代列为均值相同的组时，均值恰按组内选择变化：下一代如何列出不进入这一步，却决定下一步的组间部分）、'
          '`GroupEnding.Exhausted.next_step`（两个保留之组旁有一个不留后代之组：保留经由组间选择上升，各保留之组的后代组成的组在保留上相同，下一步保留降到起点以下；终止耗尽它所作用的组间差异）、')
i = z.index(f'| [条件相互耦合的组](../results/records/{EV6RID}.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROW = (f'| [大小任意之组的组内与组间选择](../results/records/{RID}.md) | 在所述前提下的定理 | 各组大小的公倍数；世代进程需传递精确、该代列为这些组；'
           '终止需均值较低之组不留后代 | §2.4 |\n')
i = z.index('9. **演化的选择项**（进一步的证明）。')
OLDZ9 = z[i:z.index('\n', i)]
NEWZ9 = OLDZ9.replace('组内选择与组间选择，`Becoming.SelectionLevels`；',
                      '组内选择与组间选择（各组大小任意，组间部分以各组均值读出；各组均值相同时只剩组内选择），`Becoming.SelectionLevels`；')
NEWZ9 = NEWZ9.replace('大小不等的组、组间混合，以及组与其耦合如何形成；',
                      '下一代列法之外的组间混合（跨组不精确的传递），以及组与其耦合如何形成并保持其差异；')
assert '各组大小任意' in NEWZ9 and '保持其差异' in NEWZ9, NEWZ9[:300]
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
OLD_SUM = ("For a family listed as groups of equal size the selection term divides exactly into the groups' own and the "
           "term among groups read by their totals, the multilevel form of Price's equation;")
NEW_SUM = ("For a family listed as groups of any sizes the selection term divides exactly into the groups' own terms and "
           "the term of the groups' means, the multilevel form of Price's equation (with equal sizes, the term among "
           "groups read by their totals);")
OLD_SUM2 = f'a patch renewed by its neighbour showing none read alone ({EV6REC}).'
NEW_SUM2 = (OLD_SUM2 + ' Selection among groups acts only while the groups differ: a generation listed as groups alike '
            'in mean selects by selection within them alone, and ending among groups can leave the surviving groups '
            f'alike, so that what it raised falls back at the next step ({REC}).')
OLD_C1 = ('Open are mixing between groups (transmission that is not exact across groups), how groups and their couplings '
          'form, and families read partly:')
NEW_C1 = ('Groups of any sizes divide the same way, the among-group part read by the groups\' means, and how the next '
          'generation is listed fixes the next step\'s among-group part: groups alike in mean leave selection within '
          'alone, and ending among groups can leave the survivors alike, using up what it acted on '
          f'({REC}). Open are how groups and their couplings form and keep their differences (assortment), transmission '
          'that is not exact across groups, and families read partly:')
evo = (ROOT / EVO).read_text(encoding='utf-8')
edit(EVO, [(OLD_SUM, NEW_SUM), (OLD_SUM2, NEW_SUM2), (OLD_C1, NEW_C1)])

# Coverage: the evolution row reads the new record; the general division replaces its equal-size case.
cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index(EV6RID) + 1, RID)
k = row['declarations'].index('Becoming.SelectionLevels.levels')
row['declarations'][k] = 'Becoming.SelectionLevels.levels_sized'
inst = row['instances']
assert 'Becoming.SelectionLevels.levels' in inst
inst.pop('Becoming.SelectionLevels.levels')
inst['Becoming.SelectionLevels.levels_sized'] = ['Becoming.GroupEnding.Flow.rises_iff_inactive_sized']
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **EV7: groups of unequal size')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-20, core receipt `{receipt_id}`; {n_sl_thm} theorems in Becoming.SelectionLevels and '
            f'{n_mod_thm} in Becoming.GroupEnding (no new module, rule 9), empty axiom reports; record {RID}; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(20 October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is EV7's `{receipt_id}` (20 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('EV7 ')]
landed = (f'EV7 landed (groups of any sizes and regrouping: the sized division in `Becoming.SelectionLevels`, ending for '
          f'any sizes in `Becoming.GroupEnding`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
