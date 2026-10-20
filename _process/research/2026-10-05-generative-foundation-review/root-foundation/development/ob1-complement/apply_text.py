#!/usr/bin/env python3
"""OB1 landing text: the study section, the significance review's observation check, the chapter (EN, ZH: section 2.6's
coupling-by-level paragraph, what is not derived, the readings and the records; section 5's supplied relation; section
8.1 item 3; the record table and section 9's receipt and counts) and the board row moved to the history file with the
queue and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT
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
MOD = 'Becoming.LevelCoupling'
RID = 'what-dependence-alone-carries-of-a-level'
receipt_id, conn_log, base, previous = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]


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
P = json.loads(Path(previous).read_text())
om = next(m for m in R['modules'] if m['module'] == MOD)
pm = next(m for m in P['modules'] if m['module'] == MOD)
old_names = {d['name'] for d in pm['declarations']}
new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
assert old_names <= {d['name'] for d in om['declarations']}, 'a declaration was removed'
n_new_thms = om['theorems'] - pm['theorems']
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

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the exchange '
              'law and the web or used by one that is; register check passes')
study = (HERE / 'study_ob1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_new_thms, '{DECLS}': len(new_decls),
             '{OLD}': len(pm['declarations']), '{TOTAL}': len(om['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-what-dependence-alone-carries-of-a-level-ob1', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'

# Significance review: the observation check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="observation-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_ob1.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD26C = 'a crossing where admission is not decided is not shown. *A move formed'
NEW26C = ('a crossing where admission is not decided is not shown. *What dependence alone carries* (OB1, '
          f'[study §{N}]({SA})): through dependence alone, a formation exchanging only where supported exchanges no less '
          'where the levels at the step stand no lower (`ExchangeLaw.Through.rises_at_step`), so of one level at the step '
          'dependence alone carries exactly the responses rising with it, by units at thresholds (`carried_iff_rising`, '
          '`Layers.carry`), a fall only where some level falls (`ExchangeLaw.Through.carried_fall_needs_fall`), and '
          'supplying a deficit not at all (`supply_not_carried`); where the level and a complement stand at a fixed '
          'total, units depending on both carry every response (`Complement.carry`, `supply_carried_by_complement`). '
          '*A move formed')
OLD26N = ('that formations respond only through their couplings; and, beyond the coupling sense, that observation is no '
          'second relation (the conjecture of [observation-is-a-route](../results/records/observation-is-a-route.md), '
          '§8.1).')
NEW26N = ('that formations respond only through their couplings; which responses to levels at earlier steps dependence '
          'alone carries; and a complement where the total is not fixed. The conjecture of '
          '[observation-is-a-route](../results/records/observation-is-a-route.md), that observation is no second '
          f'relation, is settled at the step of the exchange ({REC}, §8.1).')
OLD26R = '`obs` is no second kind of relation beside the couplings: dependence couples by threshold, observation by level.'
NEW26R = (OLD26R + ' In the stronger sense, that `obs` derives from dependence, it is settled at the step of the exchange: '
          'observing a level is depending on it and on where its amount goes, wherever the level has a complement at a '
          'fixed total or the response rises with it, and only a response falling with a level nothing complements, '
          'supplying its deficit, needs coupling by level. The one relation at the root is dependence within a '
          'conserved whole, where what one part lacks another holds.')
OLD26L = line_from(ch0, 'Records: [comparison-where-the-rest-responds](../results/records/comparison-where-the-rest-responds.md)')
assert OLD26L.endswith('[two-act-worlds-carry-the-difference](../results/records/two-act-worlds-carry-the-difference.md).')
NEW26L = OLD26L[:-1] + f', {REC}.'
OLD5 = ('The coupling laws read one further supplied relation, `obs`, where a level couples into a formation by level, the '
        'second relation supplied beside the web\'s dependence (§2.6, §8.1).')
NEW5 = (OLD5 + ' It derives from dependence wherever the response rises with the level or the level has a complement at a '
        'fixed total, and is a second relation only for a response falling with a level nothing complements '
        '(`carried_iff_rising`, `Complement.carry`, OB1).')
OLD3 = line_from(ch0, '3. **How evaluation forms within the unfolding** (further proof).')
OLD3a = '`sig` is the only supplied evaluative parameter (§5). *Open:* how a center forms'
NEW3a = ('`sig` is the only supplied evaluative parameter (§5). Landed (OB1, '
         f'[study §{N}]({SA})): the conjecture that observation is no second relation beside dependence, in the sense '
         'that the supplied `obs` could be derived from dependence, is settled at the step of the exchange: dependence '
         'alone carries of a level exactly what rises with it and nothing that falls (`carried_iff_rising`, '
         '`supply_not_carried`), and with a complement at a fixed total every response (`Complement.carry`), so `obs` '
         'derives from dependence exactly where the response rises with the level or the level has such a complement; '
         'in every case both are coupling (where `obs` is empty the coupling closure is the influence closure, '
         '`Flow.withinCoupling_thresholdOnly`), and observing lies within the downstream (`apart_only_downstream`; D43, '
         'D45). *Open:* how a center forms')
OLD3b = ('; which relation a center\'s region is drawn along; and the conjecture that observation is no second relation '
         'beside dependence, in the sense that the supplied `obs` could be derived from dependence. What is adopted is the '
         'weaker sense: dependence couples by threshold and `obs` by level, so both are coupling (where `obs` is empty the '
         'coupling closure is the influence closure, `Flow.withinCoupling_thresholdOnly`), and `apart_only_downstream` '
         'shows only that observing lies within the downstream (D43, D45). *Settling it:*')
NEW3b = ('; which relation a center\'s region is drawn along; and which responses to levels at earlier steps, and to '
         'several levels at once, dependence alone carries. *Settling it:*')
OLD3c = '[where-a-level-couples](../results/records/where-a-level-couples.md).'
NEW3c = f'[where-a-level-couples](../results/records/where-a-level-couples.md), {REC}.'
for part in (OLD3a, OLD3b, OLD3c):
    assert OLD3.count(part) == 1, part
NEW3 = OLD3.replace(OLD3a, NEW3a).replace(OLD3b, NEW3b).replace(OLD3c, NEW3c)
OLD_ROW = '| [Where a level couples into a formation](../results/records/where-a-level-couples.md) | theorem without premise | — | §2.6 |\n'
NEW_ROW = (f'| [What dependence alone carries of a level](../results/records/{RID}.md) | theorem under stated premises | '
           'activity needing support at the step; a law reading through dependence alone; a bound on the level; for the '
           'complement, a fixed total at the step | §2.6, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with OB1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD26C, NEW26C), (OLD26N, NEW26N), (OLD26R, NEW26R), (OLD26L, NEW26L), (OLD5, NEW5), (OLD3, NEW3),
          (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ26 = '绕两个或更多条件的回路，一加强度之积只是一圈的下界，不是其倍率。'
NEWZ26 = (OLDZ26 + '单凭依存，在交换之步只承载随一个水平升高的回应，下降只在某个水平下降处被承载；一个水平有总量固定的补时，'
          '依存于它与其补的单元承载每个回应。')
OLDZ26T = '`Ring.bound_strict`；完整陈述见'
NEWZ26T = '`Ring.bound_strict`、`carried_iff_rising`、`Complement.carry`；完整陈述见'
OLDZ26L = line_from(z, '记录：[observation-is-a-route](../results/records/observation-is-a-route.md)、[comparison-where-the-rest-responds]')
assert OLDZ26L.endswith('[two-act-worlds-carry-the-difference](../results/records/two-act-worlds-carry-the-difference.md)。')
NEWZ26L = OLDZ26L[:-1] + f'、{REC}。'
OLDZ3 = '*开放：*中心怎样逐步形成、表示其区域、边界与依存，并认识它所及者；观察是否可由依存推出。'
NEWZ3 = (f'已落地（OB1，[研究第 {N} 节]({SA})）：观察是否可由依存推出，在交换之步已定：单凭依存承载一个水平，恰是随它升高的回应，'
         '不承载随它下降者（`carried_iff_rising`、`supply_not_carried`）；有总量固定的补时承载每个回应（`Complement.carry`）。'
         '*开放：*中心怎样逐步形成、表示其区域、边界与依存，并认识它所及者；对较早之步的水平、对几个水平同时的回应，单凭依存承载哪些。')
OLDZROW = '| [水平在何处耦合入形成](../results/records/where-a-level-couples.md) | 不加前提的定理 | — | §2.6 |\n'
NEWZROW = (f'| [单凭依存承载一个水平的什么](../results/records/{RID}.md) | 在所述前提下的定理 | 该步活动需要支持；单凭依存而读的律；'
           '水平有界；补需该步总量固定 | §2.6、§8.1 |\n')
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
edit(ZH, [(OLDZ26, NEWZ26), (OLDZ26T, NEWZ26T), (OLDZ26L, NEWZ26L), (OLDZ3, NEWZ3), (OLDZROW, OLDZROW + NEWZROW),
          (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls)})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
