#!/usr/bin/env python3
"""RM4 landing text: the study section, the significance review's threshold check, the chapter (EN: section 2.3's threshold,
thesis T2's standing, the record table and section 9's receipt, counts and audit sentence; ZH: T2's standing, the record
table and section 9), the margin-measured README's MQ5 note and the board row moved to the history file with the queue
and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT FIRST_RECEIPT
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
MODS = ['Becoming.LastChange', 'Becoming.RegimeMargin']
RID = 'threshold-in-the-state-plane'
RM3 = 'where-a-run-of-a-regime-comes-to-rest'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
receipt_id, conn_log, base, previous, first_id = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]


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
assert (ROOT / PKG / 'becoming-checks' / first_id / 'verification.json').exists()
P = json.loads(Path(previous).read_text())
counts = {}
for mod in MODS:
    om = next(m for m in R['modules'] if m['module'] == mod)
    pm = next(m for m in P['modules'] if m['module'] == mod)
    old_names = {d['name'] for d in pm['declarations']}
    assert old_names <= {d['name'] for d in om['declarations']}, 'a declaration was removed'
    new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
    counts[mod] = (len(new_decls), sum(d['kind'] == 'theorem' for d in new_decls), len(pm['declarations']),
                   len(om['declarations']))
d_new = sum(c[0] for c in counts.values())
n_new = sum(c[1] for c in counts.values())
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on a run or read '
              'by one that is, the witnesses on the run; register check passes')
lc, rm = counts['Becoming.LastChange'], counts['Becoming.RegimeMargin']
assert lc[0] == lc[1], 'LastChange gained only theorems'
study = (HERE / 'study_rm4.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{FIRST}': first_id, '{DECLS_LC}': lc[0], '{OLD_LC}': lc[2],
             '{TOTAL_LC}': lc[3], '{DECLS_RM}': rm[0], '{THEOREMS_RM}': rm[1], '{OLD_RM}': rm[2], '{TOTAL_RM}': rm[3],
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-the-threshold-in-the-plane-of-level-and-recent-giving-rm4', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[the threshold in the plane of level and recent giving](../results/records/{RID}.md)'

# Significance review: the threshold check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="threshold-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_rm4.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD23 = f'[where a run of a regime comes to rest](../results/records/{RM3}.md)).'
NEW23 = (OLD23 + ' Where the adjustment rises with what is left and with the recent giving, the point of no return is a '
         'curve in the plane of level and recent giving. A run has at most one rest (`LastChange.still_same`), and a state '
         'at or below one whose run rests below the draw rests below it too, so within a band up to `hi`, for each recent '
         'giving, the runs resting below the draw are exactly those from levels below a least level, found by a finite '
         'search with no omniscience (`RegimeMargin.Adjusted.falls_iff_below`); it does not rise as the recent giving '
         'rises (`RegimeMargin.Adjusted.threshold_falls`), and under the regime\'s step it is the point `H + y` at every '
         'recent giving (`RegimeMargin.threshold_regime`). Without giving rising with what is left, a run from a level can '
         'come to rest below the draw while one from a lower level holds, and no such level exists '
         f'(`RegimeMargin.Notch.no_threshold`) (RM4, [study §{N}]({SA}), {REC}).')
OLDT2 = 'which is not checked on the data. Known neighbour: delay-difference'
NEWT2 = ('which is not checked on the data; under such an adjustment the point of no return is a curve in the plane of '
         'level and recent giving, not a level: for each recent giving the runs resting below the draw are exactly those '
         'from levels below a least level, decided, which does not rise as the recent giving rises '
         '(`RegimeMargin.Adjusted.falls_iff_below`, `RegimeMargin.Adjusted.threshold_falls`, RM4, '
         f'[study §{N}]({SA})), the point `H + y` under the regime\'s step; how often below-point episodes with recent '
         'giving short of the catch fall in the field is untested. Known neighbour: delay-difference')
OLD_ROW = line_from(ch0, f'| [Where a run of a regime comes to rest](../results/records/{RM3}.md) |') + '\n'
NEW_ROW = (f'| [The threshold in the plane of level and recent giving](../results/records/{RID}.md) | theorem under stated '
           'premises | whole-number amounts; the state the level and one recent giving; the adjustment rising with what is '
           'left and with the recent giving; a band the step keeps; for the regime\'s case, giving short of the draw below '
           '`y`, meeting it from `y`, nothing from nothing and the band reaching the point | §2.3, T2 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with RM4 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD23, NEW23), (OLDT2, NEWT2), (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE),
         (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))
edit(CH, pairs)

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZT2 = '这未在数据上检查。本论题超出'
NEWZT2 = ('这未在数据上检查；此种调整下不归点是水平与近来所给之平面上的一条曲线而非一个水平：对每个近来所给，静于汲取之下的运行恰是自低于一个最小水平出发者，'
          '可判定，该水平不随近来所给上升而升（`RegimeMargin.Adjusted.falls_iff_below`、`RegimeMargin.Adjusted.threshold_falls`，RM4，'
          f'[研究第 {N} 节]({SA})），在体制之步下即点 `H + y`；野外点下片段中近来所给不足捕捞者多常下降未经检验。本论题超出')
OLDZROW = line_from(z, f'| [一个体制的运行静于何处](../results/records/{RM3}.md) |') + '\n'
NEWZROW = (f'| [水平与近来所给之平面上的阈值](../results/records/{RID}.md) | 有所述前提的定理 | 整数量；状态为水平与一个近来所给；调整随所剩与近来所给而升；'
           '步所保持的带；体制情形需所给在 `y` 之下不及汲取、自 `y` 满足汲取、自无给无且带达到此点 | §2.3、T2 |\n')
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
edit(ZH, [(OLDZT2, NEWZT2), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The margin-measured README's note on MQ5's lag.
edit(README, [("rises in both exactly where the regime's giving rises with what is left, which is not checked on the data.",
               "rises in both exactly where the regime's giving rises with what is left, which is not checked on the data. "
               "RM4 proves that under such an adjustment the point of no return is a curve in the plane of level and recent "
               "giving: for each recent giving the runs resting below the draw are exactly those from levels below a least "
               "level, which does not rise as the recent giving rises (`RegimeMargin.Adjusted.falls_iff_below`, "
               f"`RegimeMargin.Adjusted.threshold_falls`, study section {N}). At a fixed level, less recent giving never "
               "turns a fall into a hold: the direction an AI reading of F3's failure predicted, here deterministic and "
               "within a band; how often it separates fates in the field is untested.")])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'first_id': first_id, 'N': N, 'n_new': n_new,
                                           'd_new': d_new})
print('new declarations', d_new, 'new theorems', n_new, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
