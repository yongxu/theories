#!/usr/bin/env python3
"""SG14 landing text: the study section, the significance review's in-turn check, the chapter (EN: section 3.4's horizon
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
RID = 'drawers-in-turn-draw-everything'
SG13 = 'steps-met-again-after-a-fall'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA298 = f'{STUDY_LINK}#298-over-every-law-of-what-stands-sg10'
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
              'by a law that is, the witness on the flow; register check passes')
study = (HERE / 'study_sg14.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{DECLS}': d_new, '{THEOREMS}': n_new,
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
assert study.count('```') % 2 == 0
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-drawers-in-turn-each-ranking-courses-sg14', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="in-turn-check"' not in rtext

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = '`doubling_drawn_first`, `doubling_drawn_first_linear`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('`doubling_drawn_first`, `doubling_drawn_first_linear`). With two drawers in turn, each ranking what it draws over '
         'the steps that remain, the others\' rule is derived: every profile at a mutual best response at every step '
         'from every level has both leave nothing at every step, whatever stands at nothing, so the base stands from the '
         'first step at what stands at nothing, and drawing everything is such a profile (`Optimum.InTurn.perfect_ends`, '
         '`Optimum.InTurn.perfect_levels`, `Optimum.InTurn.perfect_of_zero`); a dependence on the base above what stands '
         'at nothing is broken at the first step (`Web.perfect_broken`; in `Optimum.Holding`, under a gate, alone an '
         'optimum keeps the dweller through the horizon, in turn every perfect profile breaks it at once, '
         f'`gated_in_turn`; SG14, [study §{N}]({SA})). Where the eligible outcomes are supplied otherwise,')
OLD71 = f'`Web.Next.frontier_ends_drawn_first`, SG10, [study §298]({SA298}));'
NEW71 = (OLD71 + ' and where the others too rank courses, drawing in turn, the open-access outcome is the only perfect one: '
         'every profile at a mutual best response at every step draws everything, ending a base that either alone, '
         'far-sighted, may keep (`Optimum.InTurn.perfect_ends`, `Web.perfect_broken`, `Optimum.Holding.gated_in_turn`, '
         f'SG14, [study §{N}]({SA}));')
OLD_ROW6 = '(`Optimum.Next.frontier_ends_drawn_first`, `Web.Next.frontier_ends_drawn_first`) |'
NEW_ROW6 = ('(`Optimum.Next.frontier_ends_drawn_first`, `Web.Next.frontier_ends_drawn_first`), and with two drawers in turn '
            'each ranking courses every perfect profile drawing everything (`Optimum.InTurn.perfect_ends`, '
            '`Web.perfect_broken`) |')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = '*Open:* a worth on what is left where the most a course can leave is not regrown in one step,'
NEW10a = (f'Landed (SG14, [study §{N}]({SA})): with two drawers in turn, each ranking what it draws over the steps that '
          'remain, every profile at a mutual best response at every step from every level has both leave nothing at '
          'every step, so the base stands from the first step at what stands at nothing; the others\' rule SG10 '
          'supplied is derived for this case (`Optimum.InTurn.perfect_ends`, `Optimum.InTurn.perfect_of_zero`, '
          '`Web.perfect_broken`). ' + OLD10a)
OLD10b = ("whether others' draws, supplied as a rule reading the level, are themselves a best response, so several "
          "optimizers each ranking courses at a mutual best response, and how optimizers come to one;")
NEW10b = ('drawers ranking courses whose capacities limit a draw, more than two or drawing at once, and how optimizers '
          'come to a mutual best response;')
OLD10c = f'[{SG13}](../results/records/{SG13}.md).'
assert OLD10.count(OLD10a) == 1 and OLD10.count(OLD10b) == 1 and OLD10.endswith(OLD10c)
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10b, NEW10b)[:-1] + f', {REC}.'
OLD_ROW = line_from(ch0, f'| [Steps met again after a fall](../results/records/{SG13}.md) |') + '\n'
NEW_ROW = (f'| [Drawers in turn draw everything](../results/records/{RID}.md) | theorem under stated premises | any law of '
           'what stands; two drawers in turn at each step, no capacity limiting a draw, each ranking the sum of its draws '
           'over the steps that remain by a rule reading the step and the level; for the web law, a dependence whose need, '
           'met at the start, is above what stands at nothing | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG14 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD_ROW6, NEW_ROW6), (OLD10, NEW10),
         (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '`doubling_drawn_first`、`doubling_drawn_first_linear`）、'
NEWZ34 = (OLDZ34 + '`Optimum.InTurn.perfect_ends`（两个抽取者每步轮流、各自按其后各步所抽取排序时，他者之规则可导出：每步、从每个水平都处于相互最优回应的'
          '每个组合中，两者每步不留，不论零处所立为何，故自第一步起基础立于零处所立者，全部抽取即是这样的组合，`Optimum.InTurn.perfect_levels`、'
          '`Optimum.InTurn.perfect_of_zero`；对基础的依存若高于零处所立者则在第一步被打破，`Web.perfect_broken`；在 `Optimum.Holding` 中，'
          f'门控下单独的最优可在视野内保持居者，轮流时每个完美组合在第一步打破它，`gated_in_turn`；SG14，[研究第 {N} 节]({SA})）、')
OLDZ71 = f'`Web.Next.frontier_ends_drawn_first`，SG10，[研究第 298 节]({SA298})）；'
NEWZ71 = (OLDZ71 + '而他者也对过程排序、轮流抽取时，开放进入的结果是唯一完美的结果：每步处于相互最优回应的每个组合都全部抽取，终结了任一方单独、'
          '有远见时可保持的基础（`Optimum.InTurn.perfect_ends`、`Web.perfect_broken`、`Optimum.Holding.gated_in_turn`，'
          f'SG14，[研究第 {N} 节]({SA})）；')
OLDZ6 = '（`Optimum.Next.frontier_ends_drawn_first`、`Web.Next.frontier_ends_drawn_first`） |'
NEWZ6 = ('（`Optimum.Next.frontier_ends_drawn_first`、`Web.Next.frontier_ends_drawn_first`），两个各自对过程排序的抽取者轮流时每个完美组合都全部抽取'
         '（`Optimum.InTurn.perfect_ends`、`Web.perfect_broken`） |')
OLDZ10 = '*开放：*最多所留不能在一步内从最大更新水平再生时对所留计值之序、'
NEWZ10 = (f'已落地（SG14，[研究第 {N} 节]({SA})）：两个抽取者轮流、各自按其后各步所抽取排序时，每步、从每个水平都处于相互最优回应的每个组合都使两者每步不留，'
          '故自第一步起基础立于零处所立者；SG10 给出的他者规则在此情形可导出（`Optimum.InTurn.perfect_ends`、`Optimum.InTurn.perfect_of_zero`、'
          '`Web.perfect_broken`）。' + OLDZ10)
OLDZ10b = '作为读取水平的规则给出的他者抽取本身是否是最优回应，从而多个各自对过程排序的优化者的相互最优回应、优化者如何达到它'
NEWZ10b = '抽取受容量限制、多于两个或同时抽取的各自对过程排序的抽取者，以及优化者如何达到相互最优回应'
OLDZROW = line_from(z, f'| [跌落后再被满足的步](../results/records/{SG13}.md) |') + '\n'
NEWZROW = (f'| [轮流的抽取者全部抽取](../results/records/{RID}.md) | 在所述前提下的定理 | 任一所立之律；两个抽取者每步轮流，无容量限制，各自按其后各步所抽取之和、'
           '以读取步与水平的规则排序；对网之律，起始时被满足、所需高于零处所立者的依存 | §3.4、§7.1、§8.1 |\n')
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
zpairs = [(OLDZ34, NEWZ34), (OLDZ71, NEWZ71), (OLDZ6, NEWZ6), (OLDZ10, NEWZ10), (OLDZ10b, NEWZ10b),
          (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg14.txt').read_text(encoding='utf-8').rstrip('\n')
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
