#!/usr/bin/env python3
"""UM2 landing text (from UM's): the study section, the significance review's unified check, the chapter (EN and ZH: the passages
of SG14-SG17 in section 3.4, section 7.1, the relation table's row 6 and section 8.1's item 10 each made one passage
of the one model, the four record rows one row, a sentence on the one law of thresholds in section 2.3, and section
9's receipt, counts and audit sentence) and the board row moved to the history file. Every edit must match once.

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
RID = 'drawers-in-turn'
SA335 = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#335-one-model-of-drawers-in-turn-and-one-law-of-exact-thresholds-um'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
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




def span(text, start, end):
    """The text from `start` (once) through the first `end` after it."""
    assert text.count(start) == 1, ('span start not once', start[:80], text.count(start))
    i = text.index(start)
    j = text.index(end, i) + len(end)
    return text[i:j]


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
P = json.loads(Path(previous).read_text())
lines = {}
for mod in ('Becoming.Optimum',):
    om = next(m for m in R['modules'] if m['module'] == mod)
    pm = next(m for m in P['modules'] if m['module'] == mod)
    old_names = {d['name'] for d in pm['declarations']}
    new_names = {d['name'] for d in om['declarations']}
    added = [d for d in om['declarations'] if d['name'] not in old_names]
    removed = old_names - new_names
    assert removed == {f'Becoming.Optimum.InTurn.{n}' for n in ['pass_of_first', 'others_draw_nothing', 'revisions_end',
        'perfect_ends', 'levels_of_first', 'perfect_of_zero', 'revised_draw_all']}, removed
    lines[mod] = (f'{om["theorems"]} theorems ({pm["theorems"]} before), {len(added)} declarations added '
                  f'({sum(d["kind"] == "theorem" for d in added)} theorems), {len(removed)} removed')
    print(mod, lines[mod])
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

stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every law stated on the web or read by a '
              'law that is; register check passes')
study = (HERE / 'study_um2.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{OPT_LINE}': lines['Becoming.Optimum'],
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-where-floors-bind-two-drawers-with-no-floor-drain-um2', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="floors-check"' not in rtext


ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = span(ch0, 'With no floor and two or more drawers, every drawer after the first draws nothing later', '`Web.drained_broken`).')
NEW34 = ('Where two drawers have no floor, whatever floors the others have, nothing any drawer keeps comes back to it: what '
         'one of the two leaves passes through the other, and what any other drawer leaves passes through one of them. So '
         'revising toward best responses from any profile comes to every drawer leaving its floor, three rounds a step back '
         'and two where the first drawer has no floor, the backward induction run as a process, and every perfect profile, '
         'its own sequence of revisions, is the floor profile, which is perfect; with no floor anywhere that is drawing '
         'everything, and where a drawer leaves nothing the base stands from the first step at what stands at nothing and a '
         'dependence above it is broken there (`Optimum.InTurn.revisions_reach_floors`, `Optimum.InTurn.revised_at_floors`, '
         f'`Optimum.InTurn.perfect_at_floors`, `Optimum.InTurn.floors_perfect`, `Web.drained_broken`; UM2, [study §{N}]({SA})).')
OLD71 = '(`Optimum.InTurn.kept_returns`, `Optimum.InTurn.perfect_ends`, `Optimum.InTurn.revised_draw_all`, `Optimum.Holding.gated_in_turn`)'
NEW71 = ('(`Optimum.InTurn.kept_returns`, `Optimum.InTurn.perfect_at_floors`, `Optimum.InTurn.revised_at_floors`, '
         '`Optimum.Holding.gated_in_turn`), and where two drawers have no floor this holds whatever limits the others have '
         f'(UM2, [study §{N}]({SA}))')
OLD6 = '(`Optimum.InTurn.perfect_ends`, `Web.drained_broken`)'
NEW6 = '(`Optimum.InTurn.perfect_at_floors`, `Web.drained_broken`)'
OLD10 = ("with no floor and two or more drawers every perfect profile and every revision from round `2 N` on draws everything, "
         "and a floor on the other's draw can keep the base (`Optimum.InTurn.kept_returns`, `Optimum.InTurn.perfect_ends`, "
         "`Optimum.InTurn.revised_draw_all`, `Optimum.Holding.doubling_capacity`). ")
NEW10 = ("where two drawers have no floor, whatever the others' floors, every perfect profile is the floor profile and every "
         "revision reaches it, and with only one a floor on the other's draw can keep the base (`Optimum.InTurn.kept_returns`, "
         "`Optimum.InTurn.perfect_at_floors`, `Optimum.InTurn.revised_at_floors`, `Optimum.Holding.doubling_capacity`; UM2, "
         f"[study §{N}]({SA})). ")
OLD10b = 'for drawers whose capacities limit a draw, which profiles are perfect away from the last step;'
NEW10b = 'for drawers whose capacities limit a draw, all but one of them, which profiles are perfect away from the last step;'
OLDROW = 'for the drain and the revision no floor and `k ≥ 2` |'
NEWROW = 'for the drain and the revision two drawers with no floor |'
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = span(z, '无下限且两个及以上抽取者时，第一者之后的每者此后不抽，第一者所留归第二者：', '`Web.drained_broken`；')
NEWZ34 = ('两个抽取者无下限时，不论其他下限，任一抽取者所留都不回到自身：两者之一所留经过另一者，其他抽取者所留经过两者之一；故自任一组合向最优回应修订都达到每者留其下限，'
          '逆推一步需三轮，第一者无下限时两轮，每个完美组合作为其自身的修订序列即下限组合，且下限组合完美；处处无下限即全部抽取，某抽取者不留之处基础自第一步立于零处所立者，'
          '高于它的依存在那里被打破，`Optimum.InTurn.revisions_reach_floors`、`Optimum.InTurn.revised_at_floors`、`Optimum.InTurn.perfect_at_floors`、'
          f'`Optimum.InTurn.floors_perfect`、`Web.drained_broken`（UM2，[研究第 {N} 节]({SA})）；')
OLDZ71 = '（`Optimum.InTurn.kept_returns`、`Optimum.InTurn.perfect_ends`、`Optimum.InTurn.revised_draw_all`、`Optimum.Holding.gated_in_turn`）'
NEWZ71 = ('（`Optimum.InTurn.kept_returns`、`Optimum.InTurn.perfect_at_floors`、`Optimum.InTurn.revised_at_floors`、'
          f'`Optimum.Holding.gated_in_turn`），两个抽取者无下限时，不论其他限制皆然（UM2，[研究第 {N} 节]({SA})）')
OLDZ6 = '（`Optimum.InTurn.perfect_ends`、`Web.drained_broken`）'
NEWZ6 = '（`Optimum.InTurn.perfect_at_floors`、`Web.drained_broken`）'
OLDZ10 = ('无下限且两个及以上抽取者时，每个完美组合与自第 `2 N` 轮起的每次修订都全部抽取，对方抽取的下限可保持基础（`Optimum.InTurn.kept_returns`、'
          '`Optimum.InTurn.perfect_ends`、`Optimum.InTurn.revised_draw_all`、`Optimum.Holding.doubling_capacity`）。')
NEWZ10 = ('两个抽取者无下限时，不论其他下限，每个完美组合即下限组合，每次修订都达到它，只有一个时对方抽取的下限可保持基础（`Optimum.InTurn.kept_returns`、'
          '`Optimum.InTurn.perfect_at_floors`、`Optimum.InTurn.revised_at_floors`、`Optimum.Holding.doubling_capacity`；'
          f'UM2，[研究第 {N} 节]({SA})）。')
OLDZROW = '抽干与修订无下限且 `k ≥ 2` |'
NEWZROW = '抽干与修订两个抽取者无下限 |'
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with UM2 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD6, NEW6), (OLD10, NEW10), (OLD10b, NEW10b), (OLDROW, NEWROW),
         (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))
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
zpairs = [(OLDZ34, NEWZ34), (OLDZ71, NEWZ71), (OLDZ6, NEWZ6), (OLDZ10, NEWZ10), (OLDZROW, NEWZROW),
          (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_um2.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)
edit(CH, pairs)
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'lines': lines})
print('apart', apart, 'spine theorems', spine_thms)
for path in (CH, ZH):
    text = (ROOT / path).read_text(encoding='utf-8')
    for bad in ('InTurn.perfect_ends', 'InTurn.revisions_end', 'InTurn.revised_draw_all', 'InTurn.perfect_of_zero',
                'InTurn.levels_of_first', 'InTurn.others_draw_nothing'):
        assert bad not in text, (path, bad)
print('STUDY_SECTION', N)
