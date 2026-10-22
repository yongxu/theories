#!/usr/bin/env python3
"""UM landing text: the study section, the significance review's unified check, the chapter (EN and ZH: the passages
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
OLD_IDS = ['drawers-in-turn-draw-everything', 'revision-comes-to-drawing-everything',
           'drawers-in-turn-within-capacities', 'any-number-of-drawers-in-turn']
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
for mod in ('Becoming.Optimum', 'Becoming.RegimeMargin'):
    om = next(m for m in R['modules'] if m['module'] == mod)
    pm = next(m for m in P['modules'] if m['module'] == mod)
    old_names = {d['name'] for d in pm['declarations']}
    new_names = {d['name'] for d in om['declarations']}
    added = [d for d in om['declarations'] if d['name'] not in old_names]
    removed = old_names - new_names
    if mod == 'Becoming.RegimeMargin':
        assert removed == {'Becoming.RegimeMargin.Coupled.leading_congr', 'Becoming.RegimeMargin.Adjusted.threshold_le'}, removed
    else:
        assert all(n.startswith(('Becoming.Optimum.InTurn.', 'Becoming.Web.', 'Becoming.Optimum.Holding.')) for n in removed), removed
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
study = (HERE / 'study_um.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{OPT_LINE}': lines['Becoming.Optimum'],
             '{RM_LINE}': lines['Becoming.RegimeMargin'], '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-one-model-of-drawers-in-turn-and-one-law-of-exact-thresholds-um', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="unified-check"' not in rtext

ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = span(ch0, "With two drawers in turn, each ranking what it draws over the steps that remain, the others' rule is derived:",
             '#332-any-number-of-drawers-in-turn-sg17)).')
NEW34 = ("Drawers in turn, each ranking courses, are one model, and the others' rule is derived: at each step `k` drawers "
         'draw in turn, each leaving of what it is given at least its floor, what a capacity leaves it. A profile is perfect '
         'where it revises itself, every drawer at a best response at every step from every level, and one law carries every '
         'result: what a best response keeps above its floor returns to it at least one for one, so a drawer leaves its floor '
         'wherever what it draws later does not depend on what it leaves (`Optimum.InTurn.kept_returns`, '
         '`Optimum.InTurn.at_floor`). With no floor and two or more drawers, every drawer after the first draws nothing later '
         'and what the first leaves goes to the second: revising toward best responses from any profile comes to drawing '
         'everything within twice the horizon, the backward induction run as a process, and every perfect profile, its own '
         'sequence of revisions, draws everything, so the base stands from the first step at what stands at nothing and a '
         'dependence above it is broken there (`Optimum.InTurn.revisions_end`, `Optimum.InTurn.revised_draw_all`, '
         '`Optimum.InTurn.perfect_ends`, `Web.drained_broken`). In `Optimum.Holding`, under a gate, alone an optimum keeps the '
         'dweller, restraint keeps it, and every perfect profile and every revision from restraint breaks it, `gated_in_turn`; '
         'under doubling, where the second can take one unit a step, what the first leaves returns to it twice, less one, so '
         f'leaving everything is its only best response and the dweller is kept, `doubling_capacity` (UM, [study §{N}]({SA}), {REC}).')
OLD71 = span(ch0, 'and where the others too rank courses, drawing in turn, the open-access outcome is the only perfect one:',
             '#332-any-number-of-drawers-in-turn-sg17));')
NEW71 = ('and where the others too rank courses, drawing in turn, any number from two, the open-access outcome is the only '
         'perfect one, and revision comes to it from any profile, restraint included: a drawer keeps only what returns to it at '
         'least one for one, and what one drawer leaves goes to the next (`Optimum.InTurn.kept_returns`, '
         '`Optimum.InTurn.perfect_ends`, `Optimum.InTurn.revised_draw_all`, `Optimum.Holding.gated_in_turn`); a floor on the '
         "other's draw can keep the base, what the first leaves then returning to it (`Optimum.Holding.doubling_capacity`; UM, "
         f'[study §{N}]({SA}));')
OLD6 = ('and with two drawers in turn each ranking courses every perfect profile drawing everything '
        '(`Optimum.InTurn.Many.perfect_ends`, `Web.perfect_broken`)')
NEW6 = ('and with two or more drawers in turn each ranking courses every perfect profile drawing everything '
        '(`Optimum.InTurn.perfect_ends`, `Web.drained_broken`)')
OLD10 = span(ch0, 'Landed (SG14, [study §324]', '`Optimum.InTurn.Many.perfect_pair`). ')
NEW10 = (f'Landed (UM, [study §{N}]({SA})): drawers in turn are one model, `k` drawers each with a floor, on one law of best '
         'response, what a drawer keeps above its floor returning to it at least one for one; with no floor and two or more '
         'drawers every perfect profile and every revision from round `2 N` on draws everything, and a floor on the '
         "other's draw can keep the base (`Optimum.InTurn.kept_returns`, `Optimum.InTurn.perfect_ends`, "
         '`Optimum.InTurn.revised_draw_all`, `Optimum.Holding.doubling_capacity`). ')
OLDREC = ''.join(f', [{i}](../results/records/{i}.md)' for i in OLD_IDS) + '.'
NEWREC = f', {REC}.'
OLD_ROWS = span(ch0, '| [Drawers in turn draw everything](../results/records/drawers-in-turn-draw-everything.md) |',
                '| [Any number of drawers in turn](../results/records/any-number-of-drawers-in-turn.md) |')
OLD_ROWS = OLD_ROWS + ch0[ch0.index(OLD_ROWS) + len(OLD_ROWS):].split('\n', 1)[0] + '\n'
NEW_ROWS = (f'| [Drawers in turn](../results/records/{RID}.md) | theorem under stated premises | any law `G` of what stands; `k` '
            'drawers in turn, each leaving at least a floor and at most what it is given; plain sums over the steps that remain; '
            'for the drain and the revision no floor and `k ≥ 2` | §3.4, §7.1, §8.1 |\n')
OLD23 = '(RM10, [study §331]({}), [webs-with-a-recent-giving](../results/records/webs-with-a-recent-giving.md)).'.format(
    f'{STUDY_LINK}#331-webs-with-a-recent-giving-rm10')
NEW23 = (OLD23 + ' Every threshold here is exact by one law: where a fate is down-closed in the level and read off an exact '
         'check, the least level from which the check fails is its point of no return, and where one fate implies another '
         'its point is no lower (`RegimeMargin.leading_exact`, `RegimeMargin.leading_falls`; UM, '
         f'[study §{N}]({SA})).')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with UM in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD6, NEW6), (OLD10, NEW10), (OLDREC, NEWREC), (OLD_ROWS, NEW_ROWS),
         (OLD23, NEW23), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = span(z, '`Optimum.InTurn.Many.perfect_ends`（两个抽取者每步轮流、各自按其后各步所抽取排序时，',
              '#332-any-number-of-drawers-in-turn-sg17)）、')
NEWZ34 = ('`Optimum.InTurn.kept_returns`（轮流的抽取者是一个模型，他者之规则可导出：每步 `k` 个抽取者轮流，各自对所给至少留其下限（容量所留）；'
          '组合修订自身即完美，每者每步、从每个水平都处于最优回应；一条律带出每个结果：最优回应在下限之上所留至少一对一地回到自身，故此后所抽不依赖所留之处，抽取者留其下限，'
          '`Optimum.InTurn.at_floor`；无下限且两个及以上抽取者时，第一者之后的每者此后不抽，第一者所留归第二者：自任一组合向最优回应修订在视野的两倍之内达到全部抽取，'
          '每个完美组合作为其自身的修订序列全部抽取，基础自第一步立于零处所立者，高于它的依存在那里被打破，`Optimum.InTurn.revisions_end`、'
          '`Optimum.InTurn.revised_draw_all`、`Optimum.InTurn.perfect_ends`、`Web.drained_broken`；在 `Optimum.Holding` 中，门控下单独的最优保持居者，'
          '克制保持它，每个完美组合与自克制出发的每次修订打破它，`gated_in_turn`；倍增之下第二者每步只能取一单位时，第一者所留以二倍减一回到自身，全留是其唯一最优回应，'
          f'居者得以保持，`doubling_capacity`；UM，[研究第 {N} 节]({SA})）、')
OLDZ71 = span(z, '而他者也对过程排序、轮流抽取时，开放进入的结果是唯一完美的结果：', '#332-any-number-of-drawers-in-turn-sg17)）；')
NEWZ71 = ('而他者也对过程排序、两个及以上轮流抽取时，开放进入的结果是唯一完美的结果，自任一组合（克制亦然）修订都达到它：抽取者只保留至少一对一回到自身者，'
          '而一者所留归于下一者（`Optimum.InTurn.kept_returns`、`Optimum.InTurn.perfect_ends`、`Optimum.InTurn.revised_draw_all`、'
          '`Optimum.Holding.gated_in_turn`）；对方抽取的下限可保持基础，此时第一者所留回到自身（`Optimum.Holding.doubling_capacity`；UM，'
          f'[研究第 {N} 节]({SA})）；')
OLDZ6 = '两个各自对过程排序的抽取者轮流时每个完美组合都全部抽取（`Optimum.InTurn.Many.perfect_ends`、`Web.perfect_broken`）'
NEWZ6 = '两个及以上各自对过程排序的抽取者轮流时每个完美组合都全部抽取（`Optimum.InTurn.perfect_ends`、`Web.drained_broken`）'
OLDZ10 = span(z, '已落地（SG14，[研究第 324 节]', '`Optimum.InTurn.Many.perfect_pair`）。')
NEWZ10 = (f'已落地（UM，[研究第 {N} 节]({SA})）：轮流的抽取者是一个模型，`k` 个抽取者各有下限，依一条最优回应之律，抽取者在下限之上所留至少一对一地回到自身；'
          '无下限且两个及以上抽取者时，每个完美组合与自第 `2 N` 轮起的每次修订都全部抽取，对方抽取的下限可保持基础（`Optimum.InTurn.kept_returns`、'
          '`Optimum.InTurn.perfect_ends`、`Optimum.InTurn.revised_draw_all`、`Optimum.Holding.doubling_capacity`）。')
OLDZREC = ''.join(f'、[{i}](../results/records/{i}.md)' for i in OLD_IDS)
OLDZROWS = span(z, '| [轮流的抽取者全部抽取](../results/records/drawers-in-turn-draw-everything.md) |',
                '| [任意多个轮流的抽取者](../results/records/any-number-of-drawers-in-turn.md) |')
OLDZROWS = OLDZROWS + z[z.index(OLDZROWS) + len(OLDZROWS):].split('\n', 1)[0] + '\n'
NEWZROWS = (f'| [轮流的抽取者](../results/records/{RID}.md) | 在所述前提下的定理 | 任一所立之律 `G`；每步 `k` 个轮流的抽取者，各自至少留其下限、至多留所给；'
            '其后各步之和；抽干与修订无下限且 `k ≥ 2` | §3.4、§7.1、§8.1 |\n')
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
zpairs = [(OLDZ34, NEWZ34), (OLDZ71, NEWZ71), (OLDZ6, NEWZ6), (OLDZ10, NEWZ10), (OLDZROWS, NEWZROWS),
          (OLDZR, NEWZR), (OLDZT, NEWZT)]
if z.count(OLDZREC) == 1:
    zpairs.append((OLDZREC, '、' + REC))
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_um.txt').read_text(encoding='utf-8').rstrip('\n')
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
    for bad in ('InTurn.Many', 'Web.perfect_broken', 'Web.turns_broken', 'Web.revised_broken', 'gated_turns', 'gated_revised',
                'InTurn.within_zero_iff', 'InTurn.last_at_floor`, `Optimum.InTurn.within', 'InTurn.PerfectWithin'):
        assert bad not in text, (path, bad)
print('STUDY_SECTION', N)
