#!/usr/bin/env python3
"""EV11 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt and counts), the evolution chapter (its summary, the recovery table row and next connection 1), the board row moved to the history file and the queue and receipt sentences. Every edit must match exactly once.

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
MODS = ['Becoming.SelectionLevels', 'Becoming.GroupEnding']
RID = 'groups-formed-by-descent'
EV10RID = 'additive-part-of-offspring-variance'
ANYRID = 'selection-within-and-among-groups-of-any-sizes'
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
sl = next(m for m in core if m['module'] == MODS[0])
ge = next(m for m in core if m['module'] == MODS[1])
n_thm = sl['theorems'] + ge['theorems']
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
study = (HERE / 'study_ev11.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS_SL}': sl['theorems'], '{DECLS_SL}': len(sl['declarations']),
             '{THEOREMS_GE}': ge['theorems'], '{DECLS_GE}': len(ge['declarations']), '{APART}': apart_text,
             '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert '{' not in study.split('```')[1], 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-groups-formed-by-descent-ev11'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
EV10REC = f'[{EV10RID}](../results/records/{EV10RID}.md)'
ANYREC = f'[{ANYRID}](../results/records/{ANYRID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD_B = ('holding back rises by selection among groups, the offspring of each keeping group form groups alike in it, and '
         'at the next step it falls below where it started (`GroupEnding.Exhausted.next_step`).\n')
NEW_B = ('holding back rises by selection among groups, the offspring of each keeping group form groups alike in it, and '
         'at the next step it falls below where it started (`GroupEnding.Exhausted.next_step`). Groups formed by descent '
         'keep it: with exact transmission the lineages of groups uniform in an amount keep the value each was founded at '
         '(`SelectionLevels.lineage_value`) and list every later generation (`SelectionLevels.lineages_whole`), so nothing '
         'is selected within them and the mean rises exactly where the lineages\' means select for the amount '
         '(`SelectionLevels.rises_iff_lineages`), the complete-assortment end of reading group selection by assortment '
         '(Hamilton 1975). On the base, where at each step the lineages founded lower are not active, the mean never falls '
         'below where it started, over any number of steps (`GroupEnding.Flow.lineages_not_lower`), and rises wherever a '
         'higher lineage leaves offspring beside a lower one (`GroupEnding.Flow.lineages_raises`); with the groups of '
         '`Exhausted` formed by descent instead, holding back rises and stays (`GroupEnding.Assorted.kept`). Whether '
         'selection among groups accumulates or falls back is fixed by how the next groups are formed.\n')
OLD_RECS = f'{EV10REC}, [transmission'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
i = ch0.index(f'| [The additive part of the variance in offspring number](../results/records/{EV10RID}.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROW = (f'| [Groups formed by descent](../results/records/{RID}.md) | theorem under stated premises '
           '| exact transmission at every step; on the base, the lineages founded lower not active at each step | §2.4 |\n')
i = ch0.index("9. **Evolution's selection term** (further proof).")
OLD9 = ch0[i:ch0.index('\n', i)]
OLD9a = 'the among-group part fixed by ending, where a group\'s own condition ran into joint excess, `Becoming.GroupEnding`;'
NEW9a = ('the among-group part fixed by ending, where a group\'s own condition ran into joint excess, `Becoming.GroupEnding`; '
         'groups formed by descent from groups uniform in an amount keeping their differences, selection then among the '
         'lineages alone and, where the lower lineages end, the mean never falling below where it started, '
         '`Becoming.SelectionLevels` and `Becoming.GroupEnding`;')
OLD9b = ('mixing between groups beyond how the next generation is listed (transmission not exact across groups), and how '
         'groups and their couplings form and keep their differences;')
NEW9b = ('mixing between groups beyond how the next generation is listed (transmission not exact across groups), groups '
         'founded mixed (assortment below one, where selection within re-enters at each step), and how couplings form;')
assert OLD9.count(OLD9a) == 1 and OLD9.count(OLD9b) == 1, (OLD9.count(OLD9a), OLD9.count(OLD9b))
NEW9 = OLD9.replace(OLD9a, NEW9a).replace(OLD9b, NEW9b).replace(OLD_RECS, f'{EV10REC}, {REC}, [transmission')
i = ch0.index('Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
OLD_RECLINE = ch0[i:ch0.index('\n', i)]
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, f'{EV10REC}, {REC}, [transmission')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV11 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLDZ24 = '下一步保留降到起点以下；终止耗尽它所作用的组间差异）、'
NEWZ24 = ('下一步保留降到起点以下；终止耗尽它所作用的组间差异）、`SelectionLevels.rises_iff_lineages`（由世系形成的组保持差异：'
          '传递精确时，在某量上均匀之组的世系保持各自建立时的值（`SelectionLevels.lineage_value`）并列出此后每一代'
          '（`SelectionLevels.lineages_whole`），故世系内无选择，均值恰在各世系均值选择该量时上升，即按同类聚合读组选择时完全聚合的一端'
          '（Hamilton 1975））、`GroupEnding.Flow.lineages_not_lower`（在基上，若每一步建立值较低的世系皆不活跃，任意步数后均值不低于起点，'
          '较高世系在较低世系旁留下后代时均值上升（`GroupEnding.Flow.lineages_raises`）；把 `Exhausted` 的组改为由世系形成，保留上升并保持'
          '（`GroupEnding.Assorted.kept`）：组间选择是积累还是回落，由下一代的组如何形成决定）、')
i = z.index(f'| [后代数方差的加性部分](../results/records/{EV10RID}.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROW = (f'| [由世系形成的组](../results/records/{RID}.md) | 在所述前提下的定理 | 每一步传递精确；在基上，每一步建立值较低的世系不活跃 | §2.4 |\n')
i = z.index('9. **演化的选择项**（进一步的证明）。')
OLDZ9 = z[i:z.index('\n', i)]
OLDZ9a = '由各组自身条件遭遇共同过度的终止所定的组间部分，`Becoming.GroupEnding`；'
NEWZ9a = ('由各组自身条件遭遇共同过度的终止所定的组间部分，`Becoming.GroupEnding`；由在某量上均匀之组的世系形成的组保持差异，此时选择只在世系之间，'
          '较低世系终止时均值从不低于起点，`Becoming.SelectionLevels` 与 `Becoming.GroupEnding`；')
OLDZ9b = '下一代列法之外的组间混合（跨组不精确的传递），以及组与其耦合如何形成并保持其差异；'
NEWZ9b = '下一代列法之外的组间混合（跨组不精确的传递），混合建立的组（聚合低于一，组内选择每一步重新进入），以及耦合如何形成；'
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
OLD_S = ('ending among groups can leave the surviving groups alike, so that what it raised falls back at the next step '
         f'({ANYREC}).')
NEW_S = ('ending among groups can leave the surviving groups alike, so that what it raised falls back at the next step '
         f'({ANYREC}). Groups formed by descent from groups uniform in an amount keep their differences: with exact '
         'transmission each lineage keeps the value it was founded at, nothing is selected within the lineages, and where '
         'the lower lineages end the mean never falls back, so whether selection among groups accumulates is fixed by how '
         f'the next groups are formed ({REC}).')
OLD_TAB = f'the multilevel form for groups of any sizes ([selection-within-and-among-groups](../results/records/selection-within-and-among-groups.md), {ANYREC});'
NEW_TAB = (f'the multilevel form for groups of any sizes ([selection-within-and-among-groups](../results/records/selection-within-and-among-groups.md), {ANYREC}), '
           f'and its complete-assortment end, groups formed by descent selected among alone ({REC});')
OLD_C1 = ('Open are how groups and their couplings form and keep their differences (assortment), transmission that is not '
          'exact across groups, and families read partly:')
NEW_C1 = ('Groups formed by descent from groups uniform in an amount keep their differences, selection is then among the '
          'lineages alone, and where the lower lineages end the mean never falls back: the complete-assortment end '
          f'({REC}). Open are groups founded mixed (assortment below one), how couplings form, transmission that is not '
          'exact across groups, and families read partly:')
edit(EVO, [(OLD_S, NEW_S), (OLD_TAB, NEW_TAB), (OLD_C1, NEW_C1)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_thm': n_thm})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
