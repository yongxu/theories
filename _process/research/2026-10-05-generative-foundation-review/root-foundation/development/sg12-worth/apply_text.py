#!/usr/bin/env python3
"""SG12 landing text: the study section, the significance review's worth check, the chapter (EN: section 3.4's horizon
paragraph, section 7.1's far-sighted objection, the relation-to-known-results row 6, the standing clause, section 8.1's
item 10, the record table and section 9's receipt, counts and audit sentence; ZH: the same places) and the board row
moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

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
MOD = 'Becoming.Optimum'
RID = 'valuing-what-is-left-at-any-worth'
SG11 = 'valuing-what-is-left-at-the-horizon'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA321 = f'{STUDY_LINK}#321-valuing-what-is-left-at-the-horizon-sg11'
receipt_id, conn_log, base, previous = sys.argv[1:5]


def edit(path, pairs):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    for old, new in pairs:
        k = text.count(old)
        if k != 1:
            sys.exit(f'{path}: expected one match, found {k}: {old[:100]!r}')
    for old, new in pairs:
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
assert old_names <= {d['name'] for d in om['declarations']}, 'a declaration was removed'
new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
d_new = len(new_decls)
n_new = sum(d['kind'] == 'theorem' for d in new_decls)
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the web or read '
              'by a law that is, the witnesses on the flow; register check passes')
study = (HERE / 'study_sg12.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{DECLS}': d_new, '{THEOREMS}': n_new,
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
assert study.count('```') % 2 == 0
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-valuing-what-is-left-at-any-worth-sg12', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="worth-check"' not in rtext

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = f'`logistic_left`; SG11, [study §321]({SA321})). Kept at a need `m`'
NEW34 = (f'`logistic_left`; SG11, [study §321]({SA321})). At a worth `v` for each unit left, `v` at least one '
         '(`Optimum.byDrawnLeftAt`), where no course leaves more than one step\'s regrowth `y + r` from a level `y` of '
         'greatest renewal, what a course draws with `v` times what it leaves is at most the start with what is given '
         'there, `r` a step after and `v - 1` times `y + r`, reached by the course holding `y` and regrowing at the last '
         'step, which is an optimum (`Optimum.open_valued_le_most`, `Optimum.regrowing_frontier`); where `v` exceeds one, '
         'exactly by the courses holding a level of greatest renewal through the horizon and leaving `y + r`, so every '
         'optimum of every order rising with that worth does so (`Optimum.valued_most_iff`, '
         '`Optimum.frontier_holds_valued`, `Optimum.frontier_valued_iff`), breaking at the first step a dependence above '
         'every such level and restoring it only at the end (`Web.frontier_rebuilt_valued`); at every such worth, a '
         'coupling `w` of keeping a need at or above which at most `q` is given leaves only optima breaking it within the '
         'horizon where `w + q n < r n`, keeping forgoing `(r - q) n` against the course regrowing at the end '
         '(`Optimum.frontier_breaks_valued`, `Web.frontier_breaks_valued`; in `Optimum.Holding`, under the logistic law '
         'the source is drawn to one and regrown to the dweller\'s need at the last step, `logistic_valued`; SG12, '
         f'[study §{N}]({SA})). Kept at a need `m`')
OLD71 = (f'(`Optimum.frontier_holds_left`, `Web.frontier_broken_left`, `Optimum.Holding.gated_left`, SG11, '
         f'[study §321]({SA321}));')
NEW71 = (OLD71 + ' a value on what is left above the worth of the draw only moves the end: every optimum then draws a '
         'dependence above those levels down at the first step and regrows the condition for the horizon, so a dependence '
         'measured only at the end is restored for the measurement, and what keeping it forgoes against that course is '
         '`(r - q) n` whatever the value, outweighing every coupling fixed in total over a long enough horizon '
         '(`Optimum.frontier_holds_valued`, `Web.frontier_rebuilt_valued`, `Web.frontier_breaks_valued`, '
         f'`Optimum.Holding.logistic_valued`, SG12, [study §{N}]({SA}));')
OLD_ROW6 = '(`Optimum.frontier_holds_left`, `Web.frontier_broken_left`), and a coupling'
NEW_ROW6 = ('(`Optimum.frontier_holds_left`, `Web.frontier_broken_left`), at a worth above one regrowing at the end, the '
            'dependence restored only there (`Optimum.frontier_holds_valued`, `Web.frontier_rebuilt_valued`), and a coupling')
OLD_STAND = '(`Web.frontier_broken_left`), and with a coupling'
NEW_STAND = ('(`Web.frontier_broken_left`), or at any worth above it, restored only at the end '
             '(`Web.frontier_rebuilt_valued`), and with a coupling')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = '*Open:* an order valuing what is left at the horizon at another worth than what is drawn, the optimum where'
NEW10a = (f'Landed (SG12, [study §{N}]({SA})): at any worth `v` above one for each unit left, where no course leaves more '
          'than one step\'s regrowth from a level of greatest renewal, every optimum holds such a level through the horizon '
          'and regrows at the last step, a dependence above those levels broken at the first step and restored only at the '
          'end; at every worth of at least one a coupling of keeping is outweighed where `w + q n < r n` '
          '(`Optimum.frontier_holds_valued`, `Web.frontier_rebuilt_valued`, `Optimum.frontier_breaks_valued`). *Open:* a '
          'worth on what is left where the most a course can leave is not regrown in one step, the optimum where')
OLD10c = f'[{SG11}](../results/records/{SG11}.md).'
assert OLD10.count(OLD10a) == 1 and OLD10.endswith(OLD10c)
NEW10 = OLD10.replace(OLD10a, NEW10a)[:-1] + f', {REC}.'
OLD_ROW = line_from(ch0, f'| [Valuing what is left at the horizon](../results/records/{SG11}.md) |') + '\n'
NEW_ROW = (f'| [Valuing what is left at any worth](../results/records/{RID}.md) | theorem under stated premises | a renewal '
           'law of the level, at most `r` at every level and `r` at some `y` within the start with what is given there; '
           'courses open from a start, ranked over a horizon by an order rising with what is drawn and `v` of at least one '
           'for each unit left; no open course leaving more than `y` with `r`; a capacity covering what the first step draws '
           'down to `y` and `r`, over at least two steps; for the coupling law, at most `q` given at or above the need | '
           '§3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG12 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD_ROW6, NEW_ROW6), (OLD_STAND, NEW_STAND), (OLD10, NEW10),
         (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = f'`logistic_left`；SG11，[研究第 321 节]({SA321})）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_holds_valued`（以至少为一的价值 `v` 对每单位所留计值、且没有进程留下多于从最大更新水平 `y` 一步再生的 `y + r` 时，'
          '进程所抽取加 `v` 倍所留至多是起始加所给、此后每步 `r` 再加 `v - 1` 倍 `y + r`，保持在 `y` 并在最后一步再生的进程达到此值且是最优，'
          '`Optimum.open_valued_le_most`、`Optimum.regrowing_frontier`；`v` 大于一时，恰由在视野内保持在最大更新水平并留下 `y + r` 的进程达到，'
          '故随此价值升高之序的每个最优都如此，`Optimum.valued_most_iff`、`Optimum.frontier_valued_iff`；高于这些水平的依存在第一步被打破，'
          '只在终了恢复，`Web.frontier_rebuilt_valued`；在每个这样的价值下，对保持所需的耦合 `w` 在 `w + q n < r n` 时被胜过，'
          '相对于终了再生的进程保持放弃 `(r - q) n`，`Optimum.frontier_breaks_valued`、`Web.frontier_breaks_valued`；在 `Optimum.Holding` 中，'
          f'逻辑斯谛律下源被抽到一并在最后一步再生到居者所需，`logistic_valued`；SG12，[研究第 {N} 节]({SA})）、')
OLDZ71 = f'（`Optimum.frontier_holds_left`、`Web.frontier_broken_left`、`Optimum.Holding.gated_left`，SG11，[研究第 321 节]({SA321})）；'
NEWZ71 = (OLDZ71 + '对所留以高于汲取的价值计值只移动终了：每个最优于是在第一步把高于这些水平的依存抽下，并为视野之末再生条件，故只在终了被度量的依存'
          '为度量而恢复，而相对于该进程保持它所放弃者无论此值如何都是 `(r - q) n`，足够长的视野胜过每个总量固定的耦合'
          '（`Optimum.frontier_holds_valued`、`Web.frontier_rebuilt_valued`、`Web.frontier_breaks_valued`、`Optimum.Holding.logistic_valued`，'
          f'SG12，[研究第 {N} 节]({SA})）；')
OLDZ6 = '对视野末所留的计值只去掉终了的抽干（`Optimum.frontier_holds_left`、`Web.frontier_broken_left`），'
NEWZ6 = (OLDZ6 + '以高于一的价值计值时在终了再生、依存只在那里恢复（`Optimum.frontier_holds_valued`、`Web.frontier_rebuilt_valued`），')
OLDZS = '视野末所留与所抽取同等计值时亦然（`Web.frontier_broken_left`），'
NEWZS = (OLDZS + '以更高的价值计值时亦然、只在终了恢复（`Web.frontier_rebuilt_valued`），')
OLDZ10 = '*开放：*以不同于所汲取之价值对视野末所留赋值之序、'
NEWZ10 = (f'已落地（SG12，[研究第 {N} 节]({SA})）：以大于一的价值 `v` 对每单位所留计值、且没有进程留下多于从最大更新水平一步再生者时，'
          '每个最优都在视野内保持在最大更新的水平并在最后一步再生，高于这些水平的依存在第一步被打破、只在终了恢复；在每个至少为一的价值下，'
          '对保持的耦合在 `w + q n < r n` 时被胜过（`Optimum.frontier_holds_valued`、`Web.frontier_rebuilt_valued`、'
          '`Optimum.frontier_breaks_valued`）。*开放：*最多所留不能在一步内从最大更新水平再生时对所留计值之序、')
OLDZROW = line_from(z, f'| [对视野末所留的计值](../results/records/{SG11}.md) |') + '\n'
NEWZROW = (f'| [以任一价值对所留计值](../results/records/{RID}.md) | 在所述前提下的定理 | 水平的更新之律，各水平至多 `r`，在起始加所给之内的某 `y` 处为 `r`；'
           '自起点开放的过程，在视野上按随所抽取与每单位所留至少为一的价值 `v` 升高之序排序；没有开放进程留下多于 `y` 加 `r`；容量足以承担第一步降到 `y` '
           '的抽取与 `r`，视野至少两步；对耦合之律，所需及以上至多给出 `q` | §3.4、§7.1、§8.1 |\n')
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
zpairs = [(OLDZ34, NEWZ34), (OLDZ71, NEWZ71), (OLDZ6, NEWZ6), (OLDZS, NEWZS), (OLDZ10, NEWZ10),
          (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg12.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)
edit(CH, pairs)
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new, 'd_new': d_new})
print('new declarations', d_new, 'new theorems', n_new, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
