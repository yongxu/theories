#!/usr/bin/env python3
"""EV12 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt, counts and audit sentence), the evolution chapter (its summary, the recovery table row and next
connection 1), the board row moved to the history file and the queue and receipt sentences. Every edit must match once.

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
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
RID = 'selection-with-returns-to-groupmates'
DESC = 'groups-formed-by-descent'
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
    assert text.count(start) == 1, start
    i = text.index(start)
    return text[i:text.index('\n', i)]


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
P = json.loads(Path(previous).read_text())
sm = next(m for m in R['modules'] if m['module'] == 'Becoming.SelectionLevels')
pm = next(m for m in P['modules'] if m['module'] == 'Becoming.SelectionLevels')
old_names = {d['name'] for d in pm['declarations']}
added = [d for d in sm['declarations'] if d['name'] not in old_names]
removed = old_names - {d['name'] for d in sm['declarations']}
assert not removed, removed
SL_LINE = (f'{sm["theorems"]} theorems ({pm["theorems"]} before), {len(added)} declarations added '
           f'({sum(d["kind"] == "theorem" for d in added)} theorems), none removed')
print(SL_LINE)
n_thm = sum(d['kind'] == 'theorem' for d in added)
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
assert not [r for r in conn['apart_roots_unclassified'] if r.startswith('Becoming.SelectionLevels.')], conn['apart_roots_unclassified']

stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = f'{apart} of {fmt(spine_thms)} apart; the new apart roots registered; register check passes'
study = (HERE / 'study_ev12.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{SL_LINE}': SL_LINE, '{APART}': apart_text,
             '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG.startswith(f'{N}-groups-founded-mixed'), SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
DREC = f'[{DESC}](../results/records/{DESC}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD24 = 'Whether selection among groups accumulates or falls back is fixed by how the next groups are formed.\n'
NEW24 = ('Whether selection among groups accumulates or falls back is fixed by how the next groups are formed. Between the '
         'two ends, groups founded mixed: where each unit a member keeps gives `b` to every member of its group and takes '
         '`c` from the keeper, selection within goes against keeping by `b + c` times the groups\' own spreads '
         '(`SelectionLevels.within_returns`), selection among them goes for it exactly where `b + c` falls short of `m` '
         'times `b` (`SelectionLevels.among_for_iff`), and the whole selects for it exactly where `b + c` times the '
         'whole\'s spread falls short of `m b` times the spread among groups (`SelectionLevels.rises_iff_returns`, from '
         '`SelectionLevels.returns_balance`): with the assortment the share of the spread among groups, Hamilton\'s rule '
         '(Hamilton 1964, 1975), stated in counts with nothing subtracted. The same returns give either verdict by how the '
         'groups are founded (`SelectionLevels.Founding.either_verdict`), and assortment below one can lose where '
         'assortment one would win (`SelectionLevels.Partly.below_one`).\n')
OLD_RECS = f'{DREC}, [transmission'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
OLD_ROW = line_from(ch0, f'| [Groups formed by descent](../results/records/{DESC}.md) |') + '\n'
NEW_ROW = (f'| [Selection with returns to groupmates](../results/records/{RID}.md) | theorem under stated premises '
           '| offspring numbers depending on own and groupmates\' amounts additively, groups of equal size; exact '
           'transmission for the step | §2.4 |\n')
OLD9 = line_from(ch0, "9. **Evolution's selection term** (further proof).")
OLD9a = ('selection then among the lineages alone and, where the lower lineages end, the mean never falling below where it '
         'started, `Becoming.SelectionLevels` and `Becoming.GroupEnding`;')
NEW9a = (OLD9a + ' groups founded mixed, with returns to groupmates: selection within against keeping, among groups for '
         'it exactly where `b + c` falls short of `m b`, and the whole for it exactly where `b + c` times the spread falls '
         'short of `m b` times the spread among groups (Hamilton\'s rule with the assortment the share of the spread '
         'among groups), `Becoming.SelectionLevels`;')
OLD9b = 'groups founded mixed (assortment below one, where selection within re-enters at each step), and how couplings form;'
NEW9b = ('how assortment changes over generations (selection within re-entering at each step), returns with synergy and '
         'groups of unequal size, and how couplings form;')
assert OLD9.count(OLD9a) == 1 and OLD9.count(OLD9b) == 1, (OLD9.count(OLD9a), OLD9.count(OLD9b))
NEW9 = OLD9.replace(OLD9a, NEW9a).replace(OLD9b, NEW9b).replace(OLD_RECS, f'{DREC}, {REC}, [transmission')
OLD_RECLINE = line_from(ch0, 'Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, f'{DREC}, {REC}, [transmission')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV12 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD24, NEW24), (OLD9, NEW9), (OLD_RECLINE, NEW_RECLINE), (OLD_ROW, OLD_ROW + NEW_ROW),
         (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ24 = '（`GroupEnding.Assorted.kept`）：组间选择是积累还是回落，由下一代的组如何形成决定）、'
NEWZ24 = (OLDZ24 + '`SelectionLevels.rises_iff_returns`（两端之间，混合建立的组：成员每保留一单位给其组每个成员 b、从保留者取走 c 时，'
          '组内选择以 b + c 乘各组自身离散不利于保留（`SelectionLevels.within_returns`），组间选择恰在 b + c 小于 m 乘 b 时有利于它'
          '（`SelectionLevels.among_for_iff`），整体恰在 b + c 乘整体离散小于 m b 乘组间离散时选择它（由 `SelectionLevels.returns_balance`）：'
          '以组间离散所占份额为同类聚合，即 Hamilton 规则（Hamilton 1964、1975），以计数陈述、不作减法；同样的回报按组如何建立而得出两种判定'
          '（`SelectionLevels.Founding.either_verdict`），聚合低于一时可在聚合为一会胜出之处落败（`SelectionLevels.Partly.below_one`））、')
OLDZROW = line_from(z, f'| [由世系形成的组](../results/records/{DESC}.md) |') + '\n'
NEWZROW = (f'| [组员间回报下的选择](../results/records/{RID}.md) | 在所述前提下的定理 | 后代数可加地依赖自身与组员之量，各组大小相等；'
           '该步需传递精确 | §2.4 |\n')
OLDZ9 = line_from(z, '9. **演化的选择项**（进一步的证明）。')
OLDZ9a = '较低世系终止时均值从不低于起点，`Becoming.SelectionLevels` 与 `Becoming.GroupEnding`；'
NEWZ9a = (OLDZ9a + '混合建立的组在组员间回报下：组内选择不利于保留，组间恰在 b + c 小于 m b 时有利于它，整体恰在 b + c 乘离散小于 m b 乘组间离散时'
          '选择它（以组间离散所占份额为同类聚合的 Hamilton 规则），`Becoming.SelectionLevels`；')
OLDZ9b = '混合建立的组（聚合低于一，组内选择每一步重新进入），以及耦合如何形成；'
NEWZ9b = '聚合在世代中如何变化（组内选择每一步重新进入）、有协同的回报与大小不等的组，以及耦合如何形成；'
assert OLDZ9.count(OLDZ9a) == 1 and OLDZ9.count(OLDZ9b) == 1, (OLDZ9.count(OLDZ9a), OLDZ9.count(OLDZ9b))
NEWZ9 = OLDZ9.replace(OLDZ9a, NEWZ9a).replace(OLDZ9b, NEWZ9b)
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
zpairs = [(OLDZ24, NEWZ24), (OLDZROW, OLDZROW + NEWZROW), (OLDZ9, NEWZ9), (OLDZR, NEWZR), (OLDZT, NEWZT)]

# The evolution chapter.
OLD_S = f'fixed by how the next groups are formed ({DREC}).'
NEW_S = (OLD_S + ' Between the two ends, where each unit a member keeps gives to every member of its group and takes from '
         'the keeper, selection within goes against keeping and selection among groups for it, and the whole selects for '
         'it exactly where the share of the spread among groups, times the group size and the return, exceeds the return '
         'with what keeping takes: Hamilton\'s rule with the assortment that share, so the same returns give either '
         f'verdict by how the groups are founded ({REC}).')
OLD_TAB = f'and its complete-assortment end, groups formed by descent selected among alone ({DREC});'
NEW_TAB = (f'its complete-assortment end, groups formed by descent selected among alone ({DREC}), and every assortment '
           f'between, Hamilton\'s rule for returns to groupmates read off how the spread divides ({REC});')
OLD_C1 = ('Open are groups founded mixed (assortment below one), how couplings form, transmission that is not exact across '
          'groups, and families read partly: when does selection within groups against keeping a condition lose to '
          'selection among groups for it, once the families themselves change?')
NEW_C1 = ('Groups founded mixed answer the question for additive returns: where each unit kept gives `b` to every member of '
          'its group and takes `c` from the keeper, selection within groups against keeping loses to selection among '
          'groups for it exactly where `b + c` times the whole\'s spread falls short of `m b` times the spread among groups, '
          f'Hamilton\'s rule with the assortment the share of the spread among groups ({REC}). Open are how assortment '
          'changes over generations, returns with synergy, how couplings form, transmission that is not exact across '
          'groups, and families read partly: when does selection within groups against keeping a condition lose to '
          'selection among groups for it, once the families themselves change?')
epairs = [(OLD_S, NEW_S), (OLD_TAB, NEW_TAB), (OLD_C1, NEW_C1)]

evo = (ROOT / EVO).read_text(encoding='utf-8')
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH), (evo, epairs, EVO)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
edit(CH, pairs)
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)
edit(EVO, epairs)
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_thm': n_thm})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
