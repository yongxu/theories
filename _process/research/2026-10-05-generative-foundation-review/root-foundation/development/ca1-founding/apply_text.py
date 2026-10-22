#!/usr/bin/env python3
"""CA1 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt and counts), the evolution chapter (its summary, the recovery table's row 4 and next connection 1),
OPENING's [^transitions] note, the board row moved to the history file and the queue and receipt sentences. Every edit
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
OPENING = 'theories/becoming/OPENING.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Founding'
RID = 'confined-rise-within-a-whole'
GFD = 'groups-formed-by-descent'
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
fm = next(m for m in core if m['module'] == MOD)
n_thm = fm['theorems']
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
study = (HERE / 'study_ca1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_thm, '{DECLS}': len(fm['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert '{' not in study.split('```')[1], 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-what-cancer-is-and-what-keeps-a-part-from-turning-back-ca1'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
GFDREC = f'[{GFD}](../results/records/{GFD}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
i = ch0.index('- `Flow.family_excess_ends`, `GroupEnding.Flow.coupled_end_together`: groups whose conditions are coupled.')
OLD_B = ch0[i:ch0.index('\n', i) + 1]
NEW_B = OLD_B + (
    '- `Founding.Flow.confined_ends`: selection within a whole and a lineage confined to it. Where a family of '
    'conditions ran into excess under the coupled gate, every member of a later generation of descent is the offspring '
    'of a member that depended on no condition of the family at the gate\'s need (`Founding.Flow.survivors_independent`), '
    'and a lineage every later member of which depends on the family has no member after its end, however far selection '
    'within had raised it. A rise (`Founding.Flow.Rise`: an amount marking the lineage that selection within goes for, '
    'the lineage taking from the family during its excess) whose lineage is confined to the family '
    '(`Founding.Flow.ConfinedRise`) ends so (`Founding.Flow.ConfinedRise.ends`; the rise\'s other clauses do not enter). '
    'In `Founding.Body` two lineages each meet every clause of a rise on one body (`Founding.Body.confined_rise`, '
    '`Founding.Body.spread_rise`); the confined one ends (`Founding.Body.confined_ended`), and the one whose descendant '
    'depends on a condition outside the body still has a member a generation after every part depending on the body has '
    'ended (`Founding.Body.spread_unconfined`, `Founding.Body.spread_outlasts`). In generations founded uniform, '
    'selection within at a step needs transmission that raised or lowered the amount at some step before it '
    '(`Founding.varied_before`). Read over wholes each founded by one part (`Founding.Nested.Founded`), what '
    'transmission raised and lowered across a generation of wholes is how far the next founders moved from their '
    'founder within the whole (`Founding.Nested.raises_iff_carried`, the transmission term of Price 1970); where every '
    'next founder carries its founder\'s value (`Founding.Nested.Sequestered`), the mean founding value rises exactly '
    'where selection among wholes goes for it, whatever happened within (`Founding.Nested.raises_iff_among`, the exact '
    'case of `Generations.raises_exact_iff`), and without that the change within can outweigh selection among wholes '
    '(`Founding.Germline.unsequestered_falls`). Read (the AI\'s reading) as cancer and as a germ line, these are known '
    'results (Buss 1987; Michod 1999; Michod and Roze 2001; Aktipis et al. 2015) restated with the flow; removal of parts '
    'by the whole\'s rule, and how parts first come to live as one, are not stated.\n')
SWR = 'selection-with-returns-to-groupmates'
OLD_RECS = f'[{SWR}](../results/records/{SWR}.md), '
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
i = ch0.index(f'| [Groups formed by descent](../results/records/{GFD}.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROW = (f'| [A confined rise within a whole, and what a founding carries](../results/records/{RID}.md) | theorem '
           'under stated premises | on the base, balance, acting, dependence, descent, the coupled gate and the family\'s '
           'excess, and confinement; for the founding laws, one founder per whole and, for the among-wholes law, '
           'sequestration | §2.4 |\n')
i = ch0.index("9. **Evolution's selection term** (further proof).")
OLD9 = ch0[i:ch0.index('\n', i)]
OLD9a = 'groups whose conditions are coupled ending together, on the family laws of `Becoming.Continuation`;'
NEW9a = (OLD9a + ' a lineage confined to a family of conditions in excess having no member after its end whatever '
         'selection within had raised it to, selection within a whole founded uniform needing variation arisen in it, '
         'and, where every next founder carries its founder\'s value, the mean founding value rising exactly where '
         'selection among wholes goes for it, `Becoming.Founding`;')
OLD9b = 'rational amounts beyond a common denominator;'
NEW9b = ('wholes founded by several parts, removal of parts by the whole\'s rule, and how parts first come to live as '
         'one; rational amounts beyond a common denominator;')
assert OLD9.count(OLD9a) == 1 and OLD9.count(OLD9b) == 1, (OLD9.count(OLD9a), OLD9.count(OLD9b))
NEW9 = OLD9.replace(OLD9a, NEW9a).replace(OLD9b, NEW9b).replace(OLD_RECS, OLD_RECS + f'{REC}, ')
i = ch0.index('Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
OLD_RECLINE = ch0[i:ch0.index('\n', i)]
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, OLD_RECS + f'{REC}, ')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with CA1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLDZ24 = '组间选择是积累还是回落，由下一代的组如何形成决定）、'
NEWZ24 = (OLDZ24 + '`Founding.Flow.confined_ends`（整体内的选择与局限于整体的世系：一族条件在耦合门控下遭遇过度后，此后各代的每个成员都是某个'
          '在门控之需上不依存于该族任何条件之成员的后代（`Founding.Flow.survivors_independent`），此后每个成员都依存于该族的世系在其终结后'
          '不再有成员，无论组内选择曾把它抬到多高；上升（`Founding.Flow.Rise`：标记该世系且组内选择所偏向之量，世系在该族过度期间汲取它）'
          '而其世系局限于该族者（`Founding.Flow.ConfinedRise`）如此终结（`Founding.Flow.ConfinedRise.ends`）；`Founding.Body` 中两个世系'
          '都满足上升的每一条件，局限者终结（`Founding.Body.confined_ended`），后代依存于身体之外条件者在依存于身体的一切部分终结之后仍有成员'
          '（`Founding.Body.spread_outlasts`）；由均匀者奠基的世代中，某步的组内选择需要此前某步传递升高或降低了该量（`Founding.varied_before`）；'
          '在每个整体由一个部分奠基的读法中，跨整体世代的传递即下一批奠基者在整体内离开其奠基者的距离（`Founding.Nested.raises_iff_carried`），'
          '下一批奠基者携带原奠基者之值时，平均奠基值恰在整体间选择为它时上升，无论整体内发生什么（`Founding.Nested.raises_iff_among`），'
          '否则整体内的变化可以压过整体间选择（`Founding.Germline.unsequestered_falls`）；读作（AI 的读法）癌与生殖系，是以流重述的已知结果'
          '（Buss 1987；Michod 1999；Michod 与 Roze 2001；Aktipis 等 2015）；整体之规则移除部分，以及部分如何初次成为一体，未陈述）、')
i = z.index(f'| [由世系形成的组](../results/records/{GFD}.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROW = (f'| [整体内局限的上升与一次奠基所携带者](../results/records/{RID}.md) | 在所述前提下的定理 | 在基上，平衡、行动、依存、世系、'
           '耦合门控与该族的过度，以及局限；奠基定律需每个整体一个奠基者，整体间定律另需隔离 | §2.4 |\n')
i = z.index('9. **演化的选择项**（进一步的证明）。')
OLDZ9 = z[i:z.index('\n', i)]
OLDZ9a = '条件相互耦合的组一同终结，基于 `Becoming.Continuation` 的条件族定律；'
NEWZ9a = (OLDZ9a + '局限于过度之条件族的世系在其终结后不再有成员，无论组内选择曾把它抬到多高；由均匀者奠基的整体内的选择需要在其中产生的变异；'
          '下一批奠基者携带原奠基者之值时，平均奠基值恰在整体间选择为它时上升，`Becoming.Founding`；')
OLDZ9b = '公分母之外的有理数的量；'
NEWZ9b = '由多个部分奠基的整体、整体之规则移除部分，以及部分如何初次成为一体；公分母之外的有理数的量；'
assert OLDZ9.count(OLDZ9a) == 1 and OLDZ9.count(OLDZ9b) == 1, (OLDZ9.count(OLDZ9a), OLDZ9.count(OLDZ9b))
NEWZ9 = OLDZ9.replace(OLDZ9a, NEWZ9a).replace(OLDZ9b, NEWZ9b)
i = z.index('**当前回执**是运行 [`')
OLDZR = z[i:z.index('\n', i)]
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SA})）。")
i = z.rindex('\n', 0, z.index('| 核心模块（含根 `Bec')) + 1
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
if not z[j + 1:].startswith('\n'):
    NEWZT += '\n'
edit(ZH, [(OLDZ24, NEWZ24), (OLDZROW, OLDZROW + NEWZROW), (OLDZ9, NEWZ9), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The evolution chapter.
OLD_S = ('the mean never falls back, so whether selection among groups accumulates is fixed by how the next groups are '
         f'formed ({GFDREC}).')
NEW_S = (OLD_S + ' Within one whole the two levels meet: a lineage marked by an amount that selection within the whole '
         'goes for, drawing on the whole\'s conditions while their uptake exceeds their renewal and confined to them, has '
         'no member once they end, however far selection within had raised it, and only lineages with a member '
         'independent of those conditions go past their end; a whole founded by one part has nothing selected within it '
         'until variation arises in it; and where every next founder carries its founder\'s value, the mean founding value '
         f'rises exactly where selection among wholes goes for it ({REC}). Read (the AI\'s reading) as cancer and as a germ '
         'line, these are known results (Buss 1987; Michod 1999; Aktipis et al. 2015) restated with the flow.')
OLD_T4 = ('Groups whose conditions are coupled into one family end together, so ending selects among groups only between '
          'families ([groups-whose-conditions-are-coupled](../results/records/groups-whose-conditions-are-coupled.md)). |')
NEW_T4 = ('Groups whose conditions are coupled into one family end together, so ending selects among groups only between '
          'families ([groups-whose-conditions-are-coupled](../results/records/groups-whose-conditions-are-coupled.md)). '
          'Within a whole, a lineage confined to its conditions has no member once they end, whatever selection within '
          'raised, and where every next founder carries its founder\'s value the mean founding value rises exactly where '
          f'selection among wholes goes for it ({REC}); how parts first come to live as one is not stated. |')
OLD_C1 = 'Open are how assortment changes over generations, returns with synergy, how couplings form,'
NEW_C1 = ('Within a whole founded by one part, a lineage confined to the whole\'s conditions in excess has no member once '
          'they end, selection within needs variation arisen in the whole, and where every next founder carries its '
          'founder\'s value the mean founding value rises exactly where selection among wholes goes for it '
          f'({REC}). Open are how assortment changes over generations, returns with synergy, wholes founded by several '
          'parts, removal of parts by the whole\'s rule, how couplings form,')
edit(EVO, [(OLD_S, NEW_S), (OLD_T4, NEW_T4), (OLD_C1, NEW_C1)])

# OPENING's [^transitions] note (AI-written; the body in Ren's voice is unchanged).
op = (ROOT / OPENING).read_text(encoding='utf-8')
i = op.index('[^transitions]: ')
OLD_N = op[i:op.index('\n', i)]
NEW_N = ('[^transitions]: **Proved under conditions: what turning back loses, and two ways that keep a part from it. '
         'Not stated: removal of parts by the whole, and how parts first came to live as one; the history is empirical.** '
         'On the major transitions, see John Maynard Smith and Eörs Szathmáry, *The Major Transitions in Evolution* '
         '(1995); on cancer as cheating within multicellular cooperation, Athena Aktipis and colleagues, "Cancer across '
         'the tree of life" (*Philosophical Transactions of the Royal Society B*, 2015). Cancer is read (the AI\'s '
         'reading) as a confined rise: a lineage of a body\'s parts marked by an amount that selection within the body goes '
         'for, drawing on the body\'s conditions while their uptake exceeds their renewal, its descent confined to them '
         '(`Flow.ConfinedRise`, `Becoming.Founding`). Such a lineage has no member once those conditions end, however '
         'far selection within had raised it (`Flow.confined_ends`), and what outlasts their end descends only from parts '
         'that did not depend on them (`Flow.survivors_independent`). A transmissible cancer is read as a rise whose '
         'confinement fails: in a constructed body two lineages both meet every clause of a rise and, among what the base '
         'leaves free, differ only in where one descendant\'s need lies; the confined one ends, the other still has a '
         'member after every part depending on the body has ended (`Founding.Body`). Two ways that keep a part from '
         'turning back are stated. A whole founded by one part has nothing selected within it until variation arises in '
         'it (`Founding.varied_before`), and groups formed by descent from uniform founders, with exact transmission, keep '
         'their differences, selection then running among them alone (`SelectionLevels.rises_iff_lineages`). And where '
         'every next founder carries its founder\'s value (read as a germ line set apart, where it does not vary), the '
         'mean founding value rises exactly where selection among wholes goes for it, whatever happened within each '
         '(`Nested.raises_iff_among`), while without it the change within enters as transmission and can outweigh '
         'selection among wholes (`Founding.Germline`). These are known results (Leo Buss, *The Evolution of '
         'Individuality*, 1987; Richard Michod, *Darwinian Dynamics*, 1999; on the single-cell bottleneck, Richard '
         'Grosberg and Richard Strathmann, 1998) restated with the flow, agreement rather than independent evidence. Once '
         'formed, a whole of parts whose activity each ends goes on only as new parts keep arising '
         '(`Web.Whole.needs_arising`, `Becoming.Wholes`). That a given tumour meets the clauses is empirical; that the '
         'Earth is in such a transition now is a judgment.')
edit(OPENING, [(OLD_N, NEW_N)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_thm': n_thm})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
