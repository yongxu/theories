#!/usr/bin/env python3
"""AL1 landing text (from UM3's): the study section, the significance review's aligned check, the chapter (EN and ZH:
section 3.4, section 7.1, section 7.5 (EN), item 10 and its open list, the record row, and section 9's receipt, counts
and audit sentence), OPENING's [^aligned] and [^race], and the board row moved to the history file. Every edit must
match once.

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
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA337 = f'{STUDY_LINK}#337-drawing-at-once-the-same-law-um3'
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
mine = [n for n in conn.get('apart_roots_unclassified', []) if '.AtOnce.' in n or 'halves' in n or 'half' in n]
assert not mine, mine

stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart; no new apart root from AL1, every new law stated on the web or read '
              'by a law that is')
study = (HERE / 'study_al1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{OPT_LINE}': lines['Becoming.Optimum'],
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-when-drawing-at-once-drains-and-whom-restraint-pays-al1', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="aligned-check"' not in rtext

ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = f'`Web.at_once_broken`; UM3, [study §337]({SA337})).'
NEW34 = (OLD34 + ' Its converse is exact: drawing everything is perfect exactly where no drawer\'s portion of what stands '
         'next returns more than one for one on what it alone leaves while the others draw everything, and a perfect '
         'profile draws everything at the last step (`Optimum.AtOnce.drain_perfect_iff`, `Optimum.AtOnce.last_draws`, '
         '`Web.drain_perfect_broken`). In whole amounts the strict premise says that a unit left returns nothing, so a '
         'portion never rises with what is left and along no profile does any drawer draw more than where all draw '
         'everything: restraint then pays no drawer, and what the drain breaks lies beyond them '
         '(`Optimum.AtOnce.portion_falls`, `Optimum.AtOnce.drain_most`, `Web.at_once_beyond`). Where the drain is perfect '
         'and a profile holding the level draws a drawer at every later step more than its portion of what stands at '
         'nothing, over a horizon at least two steps longer than its first portion it draws that drawer more '
         '(`Optimum.AtOnce.holding_draws_more`). For a drawer whose portion is all that stands, drawing everything is not '
         'perfect wherever the whole returns more than one for one; one drawer given the whole drains exactly where the '
         'whole never does, and then the drain still breaks what depends on the base (`Optimum.AtOnce.whole_not_drained`, '
         '`Optimum.AtOnce.whole_perfect_iff`, `Web.whole_drain_broken`; in `Optimum.Holding`, two drawers share a level '
         'by halves and what both leave stands next with half of it again: drawing everything is perfect for the two and '
         'breaks the dweller, holding the source at six keeps it and draws each more, and for one drawer given the whole '
         f'drawing everything is not perfect, `halves_race`; AL1, [study §{N}]({SA})).')
OLD71 = f'(`Optimum.AtOnce.drains`; UM3, [study §337]({SA337})); a floor o'
NEW71 = (f'(`Optimum.AtOnce.drains`; UM3, [study §337]({SA337})), and drawing everything is perfect exactly where no '
         'portion returns more than one for one on what its drawer alone leaves: where each returns less it costs no '
         'drawer anything, the loss lying beyond them, while where some return comes back, as with two drawers sharing by '
         'halves, the drain is perfect, holding the level draws each more, and for one drawer given the whole drawing '
         'everything is not perfect (`Optimum.AtOnce.drain_perfect_iff`, `Optimum.AtOnce.drain_most`, '
         '`Optimum.AtOnce.holding_draws_more`, `Optimum.AtOnce.whole_not_drained`, `Optimum.Holding.halves_race`; AL1, '
         f'[study §{N}]({SA})); a floor o')
OLD75 = '`Web.mutual_course_lost`, §8.1 item 10).'
NEW75 = (OLD75 + ' Drawing at once from portions of one condition, what decides is where what each leaves comes back: '
         'drawing everything is perfect exactly where no portion returns more than one for one on what its drawer alone '
         'leaves, and for a drawer given the whole it is not perfect wherever the whole returns more than one for one, so '
         'draining a condition can be each one\'s best response for two drawers sharing it by halves and no best response '
         'for one drawer given all of it (`Optimum.AtOnce.drain_perfect_iff`, `Optimum.AtOnce.whole_not_drained`, '
         '`Optimum.Holding.halves_race`). Counting the whole of what is drawn is not counting what depends on what is '
         'left: where the whole never returns more than one for one, the drawer given it drains and the dependence '
         f'breaks (`Web.whole_drain_broken`; AL1, [study §{N}]({SA})).')
OLD10 = f'(`Optimum.AtOnce.drains`; UM3, [study §337]({SA337})). *Open:*'
NEW10 = (f'(`Optimum.AtOnce.drains`; UM3, [study §337]({SA337})). Its converse is exact, and in whole amounts its strict '
         'premise leaves restraint paying no drawer; where some return comes back, holding can pay every drawer more '
         'while drawing everything stays perfect, and for a drawer given the whole drawing everything is not perfect '
         'where the whole returns more than one for one (`Optimum.AtOnce.drain_perfect_iff`, `Optimum.AtOnce.drain_most`, '
         f'`Optimum.AtOnce.holding_draws_more`, `Optimum.AtOnce.whole_not_drained`; AL1, [study §{N}]({SA})). *Open:*')
OLD10b = 'drawing at once where a portion returns at least one for one;'
NEW10b = ('drawing at once, which profiles are perfect where some portion returns more than one for one, and whether every '
          'perfect profile of the halves draws each drawer less than holding;')
OLDROW = 'drawing at once, each portion returning less than one for one |'
NEWROW = ('drawing at once, each portion returning less than one for one, or for the converse at most one for one on what '
          'its drawer alone leaves |')
z = (ROOT / ZH).read_text(encoding='utf-8')
ZS337 = f'UM3，[研究第 337 节]({SA337})'
OLDZ34 = f'`Web.at_once_broken`；{ZS337}）、'
NEWZ34 = (OLDZ34 + '`Optimum.AtOnce.drain_perfect_iff`（其逆命题确切成立：他者全部抽取时，恰在无一抽取者的下一步份额对其独留之量所回多于一对一处，'
          '全部抽取是完美的，完美组合在最后一步全部抽取，`Optimum.AtOnce.last_draws`、`Web.drain_perfect_broken`；以整数量计，严格前提意味着留下一单位毫无所回，'
          '故份额从不随所留而升，沿任何组合都没有抽取者比众者全部抽取时多得，克制不使任何抽取者得益，抽干所破者在其外，'
          '`Optimum.AtOnce.portion_falls`、`Optimum.AtOnce.drain_most`、`Web.at_once_beyond`；全部抽取完美、某组合保持水平并在此后每步给某抽取者多于其零处份额时，'
          '在比其首份长至少两步的视野上它使该抽取者多得，`Optimum.AtOnce.holding_draws_more`；对份额为全部所立者的抽取者，全体所回多于一对一处全部抽取并不完美，'
          '得全体的单一抽取者恰在全体从不多回之处抽干，此时抽干仍打破依存于基础者，`Optimum.AtOnce.whole_not_drained`、`Optimum.AtOnce.whole_perfect_iff`、'
          '`Web.whole_drain_broken`；在 `Optimum.Holding` 中，两者对分、所留于下一步再加其半而立：全部抽取对二者完美并打破居者，把源保持在六则保持居者并使每者多得，'
          f'对得全体者全部抽取并不完美，`halves_race`；AL1，[研究第 {N} 节]({SA})）、')
OLDZ71 = f'（`Optimum.AtOnce.drains`；{ZS337}）；'
NEWZ71 = (OLDZ71 + '恰在无一份额对其抽取者独留之量所回多于一对一处全部抽取是完美的：每份所回少于一对一时，抽干不使任何抽取者有所失，其损失在他们之外；'
          '有所回时，如两者对分，抽干完美而保持水平使每者多得，对得全体的单一抽取者全部抽取则不完美（`Optimum.AtOnce.drain_perfect_iff`、'
          '`Optimum.AtOnce.drain_most`、`Optimum.AtOnce.holding_draws_more`、`Optimum.AtOnce.whole_not_drained`、`Optimum.Holding.halves_race`；'
          f'AL1，[研究第 {N} 节]({SA})）；')
OLDZ10 = f'（`Optimum.AtOnce.drains`；{ZS337}）。'
NEWZ10 = (OLDZ10 + '其逆命题确切成立；以整数量计，其严格前提使克制不使任何抽取者得益；有所回时，全部抽取仍完美而保持可使每个抽取者多得，'
          '对得全体者全部抽取在全体所回多于一对一处并不完美（`Optimum.AtOnce.drain_perfect_iff`、`Optimum.AtOnce.drain_most`、'
          f'`Optimum.AtOnce.holding_draws_more`、`Optimum.AtOnce.whole_not_drained`；AL1，[研究第 {N} 节]({SA})）。')
OLDZ10b = '份额所回至少一对一时的同时抽取'
NEWZ10b = '同时抽取时某份所回多于一对一处何种组合完美，以及对分中每个完美组合是否都使每者少于保持所得'
OLDZROW = '同时抽取时每份所回少于一对一 |'
NEWZROW = '同时抽取时每份所回少于一对一，逆命题则为对独留之量所回至多一对一 |'
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with AL1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD34, NEW34), (OLD71, NEW71), (OLD75, NEW75), (OLD10, NEW10), (OLD10b, NEW10b), (OLDROW, NEWROW),
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
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_al1.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)
edit(CH, pairs)
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)
exec((HERE / 'opening.py').read_text(), {'ROOT': ROOT})
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'lines': lines})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
