#!/usr/bin/env python3
"""RM2 landing text: the study section, the significance review's adjusted-giving check, the chapter (EN: section
2.3's margin of a regime, thesis T2's standing and evidence, the record table and section 9's receipt, counts and audit
sentence; ZH: T2's standing and evidence, the record table and section 9), the margin-measured README's MQ5 note and
the board row moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

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
README = 'experiments/margin-measured/README.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.RegimeMargin'
RID = 'regime-point-under-adjusting-giving'
RM1 = 'margin-of-a-regime'
GONE = ['step_zero', 'step_of_lt', 'step_falls', 'step_below', 'orbit_bound', 'orbit_from_zero', 'step_holds']
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA272 = f'{STUDY_LINK}#272-the-margin-of-a-regime-in-the-field-mq3'
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
removed = old_names - {d['name'] for d in om['declarations']}
assert removed == {f'{MOD}.{n}' for n in GONE}, removed ^ {f'{MOD}.{n}' for n in GONE}
n_new_thms = sum(d['kind'] == 'theorem' for d in new_decls)
removed_thms = sum(d['kind'] == 'theorem' for d in pm['declarations'] if d['name'] in removed)
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the run or '
              'used by one that is, the witnesses on the run, and the regime forms no law reads any more removed rather '
              'than registered; register check passes')
study = (HERE / 'study_rm2.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_new_thms, '{DECLS}': len(new_decls),
             '{OLD}': len(pm['declarations']), '{REMOVED}': len(removed), '{REMOVED_THMS}': removed_thms,
             '{TOTAL}': len(om['declarations']), '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-the-regimes-point-over-every-adjustment-of-giving-rm2', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[the regime\'s point under giving that adjusts](../results/records/{RID}.md)'

# Significance review: the adjusted-giving check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="adjusted-giving-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_rm2.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD23 = 'the module states it in whole numbers ([margin of a regime](../results/records/margin-of-a-regime.md)).'
NEW23 = (OLD23 + ' Where giving adjusts, reading what is left and the recent giving (`RegimeMargin.Adjusted.step`), the '
         'regime\'s step is the case reading what is left alone (`RegimeMargin.Adjusted.orbit_regime`). Every rest of '
         'the state at or above the draw is the regime\'s wherever the adjustment rests at the draw exactly where the '
         'regime gives the draw, on the run as on the step (`RegimeMargin.Adjusted.rests_iff`), so for every giving '
         'between the recent and the regime\'s that moves wherever it differs from the regime\'s '
         '(`RegimeMargin.Adjusted.Between.rests_iff`). The point decides the fate where the recent giving lies on the '
         'level\'s side of the draw (`RegimeMargin.Adjusted.ends_iff_below`); with it on the other side, what was given '
         'before carries a condition across the point both ways (`RegimeMargin.Crossing.crosses`; RM2, '
         f'[study §{N}]({SA}), {REC}).')
OLDT2 = 'that the regime\'s point stays the long-run point is elementary and has no Lean result.'
NEWT2 = ('every rest of the state at or above the draw is the regime\'s, proved in whole numbers for every adjustment of '
         'giving that rests at the draw exactly where the regime gives the draw (`RegimeMargin.Adjusted.rests_iff`, '
         f'RM2, [study §{N}]({SA})), which MQ5\'s law, reduced through the balance to an adjustment of recent giving, '
         'satisfies over the reals; that a run comes to rest is not proved.')
OLDT2E = ('which the thesis reads as the regime entering through recent giving [AI reading, D45]; that reading is '
          'untested.')
NEWT2E = (OLDT2E + ' MQ3\'s check F3 failed: under a held catch, a third of the episodes below the regime\'s point did not '
          f'fall ([study §272]({SA272})). Below the point, recent giving above the draw can carry a condition across it '
          '(`RegimeMargin.Crossing.crosses`), so the thesis reads the point as separating fates on the state, not on the '
          'level alone [AI reading, D45]; the prediction that below-point episodes whose recent giving falls short of '
          'the catch fall more often than those whose recent giving meets it is untested.')
OLD_ROW = line_from(ch0, f'| [The margin of a regime](../results/records/{RM1}.md) |') + '\n'
NEW_ROW = (f'| [The regime\'s point under giving that adjusts](../results/records/{RID}.md) | theorem under stated premises '
           '| whole-number amounts; the state the level and one recent giving; giving a law of what is left and of the '
           'recent giving; for the rest laws, the adjustment resting at the draw exactly where the regime gives it; for '
           'the fates, the recent giving on the level\'s side of the draw and the adjustment keeping giving on the side '
           'where the recent and the regime\'s giving lie; each law\'s own premises | §2.3, T2 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with RM2 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD23, NEW23), (OLDT2, NEWT2), (OLDT2E, NEWT2E), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZT2 = '已知的近邻：延迟差分模型带一个水平与一个补充滞后（Deriso 1980；Schnute 1985）。'
NEWZT2 = (OLDZT2 + '汲取及其上的每个静止状态都是体制的：这在整数中对在体制给出汲取处静于汲取的每个所给调整都已证明'
          f'（`RegimeMargin.Adjusted.rests_iff`，RM2，[研究第 {N} 节]({SA})），MQ5 之律经平衡化为近来所给的调整后在实数上满足此前提；'
          '运行会静止未被证明。')
OLDZT2E = '本论题把这读作体制经最近的给予进入〔AI 读法，D45〕，未检验。'
NEWZT2E = (OLDZT2E + f'MQ3 的检验 F3 未通过：在保持的捕捞下，体制之点以下的片段有三分之一没有下降（[研究第 272 节]({SA272})）。'
           '在此点之下，高于汲取的近来所给可把条件带过此点（`RegimeMargin.Crossing.crosses`），故本论题把此点读作按状态而非单按水平区分命运'
           '〔AI 读法，D45〕；近来所给不足捕捞的点下片段比满足者更常下降这一预测未经检验。')
OLDZROW = line_from(z, f'| [一个体制的余量](../results/records/{RM1}.md) |') + '\n'
NEWZROW = (f'| [所给调整下的体制之点](../results/records/{RID}.md) | 有所述前提的定理 | 整数量；状态为水平与一个近来所给；所给是所剩与近来所给之律；'
           '静止之律需调整恰在体制给出汲取处静于汲取；命运之律需近来所给在水平一侧、调整把所给保持在近来所给与体制所给所在的一侧；各律自身的前提 | §2.3、T2 |\n')
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
edit(ZH, [(OLDZT2, NEWZT2), (OLDZT2E, NEWZT2E), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The margin-measured README's note on MQ5's lag.
edit(README, [("  - At a fixed point the lag vanishes, so RM1's regime point stays the long-run point.\n",
               "  - At a fixed point the lag vanishes. Every rest of the state at or above the draw is then RM1's regime "
               "point: RM2 proves this in whole numbers for every adjustment of giving that rests at the draw where the "
               f"regime does (`RegimeMargin.Adjusted.rests_iff`, study section {N}). Whether a run comes to rest is not "
               "proved.\n")])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls), 'removed': len(removed),
                                           'removed_thms': removed_thms})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'removed', len(removed), 'apart', apart,
      'spine theorems', spine_thms)
print('STUDY_SECTION', N)
