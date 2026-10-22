#!/usr/bin/env python3
"""UM3 landing text (from UM2's): the study section, the significance review's unified check, the chapter (EN and ZH: the passages
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
    assert not removed, removed
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
study = (HERE / 'study_um3.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{OPT_LINE}': lines['Becoming.Optimum'],
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-drawing-at-once-the-same-law-um3', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="at-once-check"' not in rtext


ch0 = (ROOT / CH).read_text(encoding='utf-8')
SA335 = f'{STUDY_LINK}#335-one-model-of-drawers-in-turn-and-one-law-of-exact-thresholds-um'
SA336 = f'{STUDY_LINK}#336-where-floors-bind-two-drawers-with-no-floor-drain-um2'
OLD34 = f'`doubling_capacity` (UM, [study §335]({SA335}), [drawers-in-turn](../results/records/drawers-in-turn.md)).'
NEW34 = (OLD34 + ' Drawing at once is the same law at a second arrangement: where the level is divided into portions and all '
         'draw at once, what a drawer leaves comes back to it only through its portion of what stands next, and where that '
         'return is less than one for one, by the law\'s strict form, every perfect profile draws everything, drawing '
         'everything is perfect, and revision reaches it within one round a step back (`Optimum.InTurn.floor_of_less`, '
         f'`Optimum.AtOnce.drains`, `Optimum.AtOnce.revisions_drain`, `Web.at_once_broken`; UM3, [study §{N}]({SA})).')
OLD71 = f'this holds whatever limits the others have (UM2, [study §336]({SA336}))'
NEW71 = (OLD71 + '; drawing at once from portions, every perfect profile draws everything where each portion returns less than '
         f'one for one (`Optimum.AtOnce.drains`; UM3, [study §{N}]({SA}))')
OLD10 = f'`Optimum.Holding.doubling_capacity`; UM2, [study §336]({SA336})). '
NEW10 = (OLD10 + 'Drawing at once from portions is the same law: where each portion returns less than one for one, every '
         f'perfect profile and every revision draws everything (`Optimum.AtOnce.drains`; UM3, [study §{N}]({SA})). ')
OLD10b = 'drawers ranking courses and drawing at once, and how they come to one other than by revision;'
NEW10b = ('drawers ranking courses, and how they come to one other than by revision; drawing at once where a portion '
          'returns at least one for one;')
OLDROW = 'for the drain and the revision two drawers with no floor |'
NEWROW = ('for the drain and the revision two drawers with no floor; drawing at once, each portion returning less than one '
          'for one |')
z = (ROOT / ZH).read_text(encoding='utf-8')
ZA335 = SA335
ZA336 = SA336
OLDZ34 = f'居者得以保持，`doubling_capacity`；UM，[研究第 335 节]({ZA335})）、'
NEWZ34 = (OLDZ34 + '`Optimum.AtOnce.drains`（同时抽取是同一条律的第二种安排：水平分为份额、众者同时抽取时，抽取者所留只经其下一步的份额回到自身；'
          '此回报少于一对一时，依此律的严格形式，每个完美组合全部抽取，全部抽取是完美的，修订在逆推每步一轮之内达到它，'
          '`Optimum.InTurn.floor_of_less`、`Optimum.AtOnce.revisions_drain`、`Web.at_once_broken`；'
          f'UM3，[研究第 {N} 节]({SA})）、')
OLDZ71 = f'两个抽取者无下限时，不论其他限制皆然（UM2，[研究第 336 节]({ZA336})）'
NEWZ71 = (OLDZ71 + f'；自份额同时抽取时，每份所回少于一对一，则每个完美组合都全部抽取（`Optimum.AtOnce.drains`；UM3，[研究第 {N} 节]({SA})）')
OLDZ10 = f'`Optimum.Holding.doubling_capacity`；UM2，[研究第 336 节]({ZA336})）。'
NEWZ10 = (OLDZ10 + '自份额同时抽取是同一条律：每份所回少于一对一时，每个完美组合与每次修订都全部抽取'
          f'（`Optimum.AtOnce.drains`；UM3，[研究第 {N} 节]({SA})）。')
OLDZ10b = '同时抽取的各自对过程排序的抽取者，以及它们在修订之外如何达到相互最优回应'
NEWZ10b = '各自对过程排序的抽取者在修订之外如何达到相互最优回应；份额所回至少一对一时的同时抽取'
OLDZROW = '抽干与修订两个抽取者无下限 |'
NEWZROW = '抽干与修订两个抽取者无下限；同时抽取时每份所回少于一对一 |'
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD10, NEW10), (OLD10b, NEW10b), (OLDROW, NEWROW),
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
zpairs = [(OLDZ34, NEWZ34), (OLDZ71, NEWZ71), (OLDZ10, NEWZ10), (OLDZ10b, NEWZ10b), (OLDZROW, NEWZROW),
          (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_um3.txt').read_text(encoding='utf-8').rstrip('\n')
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
    for bad in ('drawing at once with a rule of sharing',):
        assert bad not in text, (path, bad)
print('STUDY_SECTION', N)
