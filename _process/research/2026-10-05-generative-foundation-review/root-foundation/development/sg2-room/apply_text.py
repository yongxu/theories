#!/usr/bin/env python3
"""SG2 landing text: the study section, the significance review's room check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's optimum against the prior result, T3's standing, section 8.1 item 10, the
relation-to-known-results row 6, the record table and section 9's receipt and counts) and the board row moved to the
history file with the queue and receipt sentences. Every edit must match exactly once.

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
RID = 'room-read-off-the-exchange'
SG1 = 'what-an-optimum-does-beyond-what-couples-in'
SA283 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#283-what-optimizing-through-couplings-does-beyond-them-sg1')
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
assert old_names <= {d['name'] for d in om['declarations']}, 'a declaration was removed'
n_new_thms = om['theorems'] - pm['theorems']
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the flow and '
              'the web or used by one that is, the witness through the general law; register check passes')
study = (HERE / 'study_sg2.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_new_thms, '{DECLS}': len(new_decls),
             '{OLD}': len(pm['declarations']), '{TOTAL}': len(om['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-room-read-off-the-exchange-sg2', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG1}](../results/records/{SG1}.md)'

# Significance review: the room check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="room-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg2.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = ('Without room an optimum need not lower anything (`Optimum.Drain.room_needed`), and an order rising only to a '
         'target')
NEW34 = ('Room is read off one step of exchange: among the outcomes open to a part whose members take at most their '
         'capacity and give no more than they take, the rest exchanging as it does, there is room above any floors '
         '(`Optimum.Above.room`), and every optimum stands at each condition beyond at what the rest leaves less the '
         'part\'s capacity, or at nothing (`Optimum.optimum_beyond`), untouched where the part may take nothing '
         '(`Optimum.optimum_untouched`), lowered exactly where it has capacity and something stands '
         '(`Optimum.optimum_lowers_iff`); a dependence beyond breaks exactly where its need exceeds that level '
         '(`Web.optimum_broken_iff_capacity`; in `Diversion`, exactly where the taker\'s capacity is positive, '
         '`Optimum.Drain.drawing_broken_iff`). Where the eligible outcomes are supplied otherwise, without room an '
         'optimum need not lower anything (`Optimum.Drain.room_needed`), and an order rising only to a target')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'(`Optimum.least_iff`, SG1, [study §283]({SA283}));'
NEW71 = (f'(`Optimum.least_iff`, SG1, [study §283]({SA283})); room itself is read off one step of exchange, where the '
         'part\'s members take at most their capacity and give no more than they take, and every optimum then stands '
         'beyond at what the rest leaves less the capacity, so their resource constraint is conservation with capacity '
         'and the drain lies exactly where the part shares units with what lies beyond (`Optimum.Above.room`, '
         f'`Optimum.optimum_beyond`, `Optimum.optimum_lowers_iff`, SG2, [study §{N}]({SA}));')
OLDT3C = 'keeping each dependence first spends exactly the slack'
NEWT3C = 'keeping each dependence first takes exactly the slack'
OLDT3S = ('room is a supplied premise, and without it an optimum need not lower anything '
          '(`Optimum.Drain.room_needed`).')
NEWT3S = ('room is read off one step of exchange, every optimum standing at each condition beyond at what the rest '
          'leaves less the part\'s capacity, untouched where the part may take nothing and lowered exactly where it has '
          'capacity there (`Optimum.Above.room`, `Optimum.optimum_beyond`, `Optimum.optimum_untouched`, '
          '`Optimum.optimum_lowers_iff`, `Web.optimum_broken_iff_capacity`), so the clause that the drain lies where '
          'units are shared, and the second forbidden drive below, hold for optima at one step with the rest exchanging '
          'as it does; where the eligible outcomes are supplied otherwise room is a premise, and without it an optimum '
          'need not lower anything (`Optimum.Drain.room_needed`).')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = '*Open:* room derived from a law of exchange rather than supplied; offspring numbers'
NEW10a = (f'Landed (SG2, [study §{N}]({SA})): room read off one step of exchange, where a part\'s members take at most '
          'their capacity and give no more than they take, the rest exchanging as it does; every optimum stands at each '
          'condition beyond at what the rest leaves less the part\'s capacity, untouched where the part may take '
          'nothing, and a dependence there breaks exactly where its need exceeds that level (`Optimum.Above.room`, '
          '`Optimum.optimum_beyond`, `Web.optimum_broken_iff_capacity`). *Open:* an optimizer choosing again at each '
          'step of a course, with the rest responding; offspring numbers')
OLD10b = f'{SREC}.'
NEW10b = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10b):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10b, NEW10b)
OLD6 = 'read as the dependences broken (`Optimum.least_iff`, `Web.optimum_broken_iff`) |'
NEW6 = ('read as the dependences broken (`Optimum.least_iff`, `Web.optimum_broken_iff`), with room read off conservation '
        'with capacity (`Optimum.Above.room`, `Optimum.optimum_beyond`) |')
OLD_ROW = line_from(ch0, f'| [What an optimum does beyond what couples in](../results/records/{SG1}.md) |') + '\n'
NEW_ROW = (f'| [Room read off the exchange](../results/records/{RID}.md) | theorem under stated premises | one step, the '
           'rest exchanging as it does; the part\'s capacities; listings without repetition, what couples in holding a '
           'condition; for breaks, dependences met beyond | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG2 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD34, NEW34), (OLD34R, NEW34R), (OLD71, NEW71), (OLDT3C, NEWT3C), (OLDT3S, NEWT3S), (OLD10, NEW10),
          (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '`Flow.keeping_optimum_takes_slack`）、'
NEWZ34 = (OLDZ34 + '`Optimum.optimum_beyond`（余地从一步交换读出：部分的成员至多取其容量、所给不多于所取、其余者照常交换时，'
          '在任何底线之上都有余地，`Optimum.Above.room`；每个最优在之外每个条件上立于其余者所留减去部分的容量处，'
          '部分无可取处不动，`Optimum.optimum_untouched`；之外的依存恰在其需要超过此处时被打断，'
          '`Web.optimum_broken_iff_capacity`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'（`Optimum.least_iff`，SG1，[研究第 283 节]({SA283})）；'
NEWZ71 = (OLDZ71 + '余地本身从一步交换读出：部分的成员至多取其容量、所给不多于所取时，每个最优在之外立于其余者所留减去容量处，'
          '故他们的资源约束即带容量的守恒，抽干恰在部分与之外共享单位之处（`Optimum.Above.room`、`Optimum.optimum_lowers_iff`，'
          f'SG2，[研究第 {N} 节]({SA})）；')
OLDZT3 = '余地是给定的前提，没有它最优者不必降低任何东西（`Optimum.Drain.room_needed`）。'
NEWZT3 = ('余地从一步交换读出：每个最优在之外每个条件上立于其余者所留减去部分的容量处，部分无可取处不动，恰在有容量处降低'
          '（`Optimum.Above.room`、`Optimum.optimum_beyond`、`Optimum.optimum_untouched`、`Optimum.optimum_lowers_iff`、'
          '`Web.optimum_broken_iff_capacity`），故“抽干落在共享单位之处”一句与下面第二项禁止，对其余者照常交换的一步的最优成立；'
          '可选结果另行给定时余地是前提，没有它最优者不必降低任何东西（`Optimum.Drain.room_needed`）。')
OLDZ10 = '*开放：*余地由交换之律导出而非给定；'
NEWZ10 = (f'已落地（SG2，[研究第 {N} 节]({SA})）：余地从一步交换读出（部分的成员至多取其容量、所给不多于所取，其余者照常交换）；'
          '每个最优在之外每个条件上立于其余者所留减去部分的容量处，部分无可取处不动，那里的依存恰在其需要超过此处时被打断'
          '（`Optimum.Above.room`、`Optimum.optimum_beyond`、`Web.optimum_broken_iff_capacity`）。'
          '*开放：*优化者在一个过程的每一步重新选择、其余者回应；')
OLDZ6 = '读作被打断的依存（`Optimum.least_iff`、`Web.optimum_broken_iff`） |'
NEWZ6 = ('读作被打断的依存（`Optimum.least_iff`、`Web.optimum_broken_iff`），余地从带容量的守恒读出'
         '（`Optimum.Above.room`、`Optimum.optimum_beyond`） |')
OLDZROW = line_from(z, f'| [最优对耦合入者之外做什么](../results/records/{SG1}.md) |') + '\n'
NEWZROW = (f'| [从交换读出的余地](../results/records/{RID}.md) | 在所述前提下的定理 | 一步，其余者照常交换；部分的容量；'
           '列表无重复，耦合入者含一个条件；打断需之外的依存被满足 | §3.4、§7.1、§8.1 |\n')
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
edit(ZH, [(OLDZ34, NEWZ34), (OLDZ34R, NEWZ34R), (OLDZ71, NEWZ71), (OLDZT3, NEWZT3), (OLDZ10, NEWZ10), (OLDZ6, NEWZ6),
          (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls)})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
