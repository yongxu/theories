#!/usr/bin/env python3
"""RM6 landing text: the study section, the significance review's coupled check, the chapter (EN: section 2.3's coupled
regimes, theses T1's and T2's standing, the record table and section 9's receipt, counts and audit sentence; ZH: T1's and
T2's standing, the record table and section 9), the margin-measured README's note and the board row moved to the history
file with the queue and receipt sentences. Every edit must match exactly once.

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
MODS = ['Becoming.RegimeMargin']
RID = 'coupled-regimes'
RM5 = 'regime-in-any-amounts'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
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
rm = counts['Becoming.RegimeMargin']
study = (HERE / 'study_rm6.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{DECLS_RM}': rm[0], '{THEOREMS_RM}': rm[1], '{OLD_RM}': rm[2],
             '{TOTAL_RM}': rm[3], '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-coupled-regimes-a-margin-that-is-not-its-own-rm6', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[coupled regimes](../results/records/{RID}.md)'

# Significance review: the coupled check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="coupled-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_rm6.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD23 = f'[the regime in any amounts](../results/records/{RM5}.md)).'
NEW23 = (OLD23 + ' A condition\'s point of no return is not its own where its giving reads what is left of another. Under '
         'draws taken first, two conditions each giving from what is left of both, with each giving rising with what is '
         'left of each, keep the order of states, so a condition ending from a state ends from every state below it '
         '(`RegimeMargin.Coupled.ends_of_below`). Within a band in whole numbers a run comes to rest within `2 hi + 1` '
         'steps, and for each level of its partner the first condition ends exactly below a least level, found by a finite '
         'search, which does not rise as the partner\'s level rises (`RegimeMargin.Coupled.ends_iff_below`, '
         '`RegimeMargin.Coupled.threshold_falls`). A condition giving nothing where nothing is left of its partner falls by '
         'its draw once the partner stays within its draw, and ends within as many steps as its level '
         '(`RegimeMargin.Coupled.ends_after`); under dependence both ways the two end together. Support can carry a '
         'condition across its own point (`RegimeMargin.Coupled.MutualActivation.saves`); under inhibition more of the '
         'other can end a condition that holds alone, and the order of fates breaks '
         '(`RegimeMargin.Coupled.MutualInhibition.breaks_order`); beyond a band mutual support can hold a pair neither of '
         'which holds alone in a cycle that never rests (`RegimeMargin.Coupled.Relay.cycles`). A condition whose giving '
         'reads only what is left of itself runs as the regime (`RegimeMargin.Coupled.first_regime`) '
         f'(RM6, [study §{N}]({SA}), {REC}).')
OLDT1 = '`RegimeMargin.beyond_draw_iff`). That actual conditions with a need meet these premises'
NEWT1 = ('`RegimeMargin.beyond_draw_iff`); where two conditions give from what is left of both, a condition\'s point of no '
         'return is not its own: under mutual support within a band it is a least level that does not rise as its '
         'partner\'s level rises, a condition depending on another ends after it, and inhibition breaks the order of fates '
         '(`RegimeMargin.Coupled.ends_iff_below`, `RegimeMargin.Coupled.threshold_falls`, `RegimeMargin.Coupled.ends_after`, '
         f'RM6, [study §{N}]({SA})). That actual conditions with a need meet these premises')
OLDT2 = '`Drawn.converges` in the periphery, RM5, [study §302]'
i2 = ch0.index(OLDT2)
OLDT2 = ch0[i2:ch0.index('. Known neighbour', i2) + len('. Known neighbour')]
NEWT2 = (OLDT2[:-len(' Known neighbour')] + ' The three numbers are a single condition\'s: where a condition gives from what '
         'is left of a partner, the partner\'s level enters its giving (`RegimeMargin.Coupled.step`, RM6, '
         f'[study §{N}]({SA})), so the claim that no fourth variable matters in the median condition says that such '
         'coupling is weak there, which is untested. Known neighbour')
OLD_ROW = line_from(ch0, f'| [The regime in any amounts](../results/records/{RM5}.md) |') + '\n'
NEW_ROW = (f'| [Coupled regimes](../results/records/{RID}.md) | theorem under stated premises | two conditions; draws taken '
           'first; each giving a law of what is left of both; mutual support for the order and the threshold; a band and '
           'whole numbers for rest and the threshold; for draining, the dependent giving nothing where nothing is left of '
           'its partner | §2.3, T1, T2 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with RM6 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD23, NEW23), (OLDT1, NEWT1), (OLDT2, NEWT2), (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT),
         (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))
edit(CH, pairs)

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZT1 = '`RegimeMargin.beyond_draw_iff`。实际有需要的条件满足这些前提'
NEWZT1 = ('`RegimeMargin.beyond_draw_iff`。两个条件各从两者所余中给出时，一个条件的不归点不属于它自己：相互支持下在带内，它是一个不随伙伴水平上升而升的'
          '最小水平；依赖他者的条件在其后终结；抑制打破命运之序（`RegimeMargin.Coupled.ends_iff_below`、`RegimeMargin.Coupled.threshold_falls`、'
          f'`RegimeMargin.Coupled.ends_after`，RM6，[研究第 {N} 节]({SA})）。实际有需要的条件满足这些前提')
OLDZT2 = '）。本论题超出'
iz = z.index('外围中的 `Drawn.converges`，RM5')
jz = z.index(OLDZT2, iz)
assert z.count(z[iz:jz + len(OLDZT2)]) == 1
OLDZT2 = z[iz:jz + len(OLDZT2)]
NEWZT2 = (OLDZT2[:-len('本论题超出')] + '三个数是单个条件的：一个条件从伙伴所余中给出时，伙伴的水平进入其所给（`RegimeMargin.Coupled.step`，RM6，'
          f'[研究第 {N} 节]({SA})），故“中位条件中没有第四个变量重要”之断言即说那里此种耦合很弱，这未经检验。本论题超出')
OLDZROW = line_from(z, f'| [任何量中的体制](../results/records/{RM5}.md) |') + '\n'
NEWZROW = (f'| [耦合的体制](../results/records/{RID}.md) | 有所述前提的定理 | 两个条件；汲取先取；各所给是两者所余之律；序与阈值需相互支持；'
           '静止与阈值需带与整数；流尽需依赖者在伙伴一无所余处给无 | §2.3、T1、T2 |\n')
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
edit(ZH, [(OLDZT1, NEWZT1), (OLDZT2, NEWZT2), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The margin-measured README: a coupled condition's margin.
edit(README, [("fewer as the recent giving rises (`RegimeReals`, study section 302).",
               "fewer as the recent giving rises (`RegimeReals`, study section 302). RM6 shows that a margin measured on "
               "one condition alone is not its own where the condition gives from what is left of another: under mutual "
               "support the point of no return falls as the partner's level rises, and a dependent ends after its partner "
               f"(`RegimeMargin.Coupled.threshold_falls`, `RegimeMargin.Coupled.ends_after`, study section {N}); none of "
               "the stocks tested here was read with a partner.")])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new, 'd_new': d_new})
print('new declarations', d_new, 'new theorems', n_new, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
