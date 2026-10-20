#!/usr/bin/env python3
"""SG3 landing text: the study section, the significance review's commons check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's optimum against the prior result, T3's standing, section 8.1 item 10, the
relation-to-known-results row 6, the record table and section 9's receipt, counts and audit sentence) and the board row
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
RID = 'several-optimizers-drain-by-their-joint-capacity'
SG2 = 'room-read-off-the-exchange'
SA288 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#288-room-read-off-the-exchange-sg2')
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
              'the web or used by one that is, the witness through the general laws; register check passes')
study = (HERE / 'study_sg3.txt').read_text(encoding='utf-8')
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
assert SLUG == f'{N}-several-optimizers-at-a-mutual-best-response-sg3', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG2}](../results/records/{SG2}.md)'

# Significance review: the commons check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="commons-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg3.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = '`Optimum.Drain.drawing_broken_iff`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('`Optimum.Drain.drawing_broken_iff`). Several optimizers at a mutual best response, each alone by its own order '
         'rising with its own family, leave a condition beyond every family at what the formations outside them leave '
         'less their joint capacity, or at nothing, each taking its whole capacity wherever something stands, as one part '
         'made of all of them would (`Optimum.mutual_beyond`, `Optimum.MutualBest.full`, `Optimum.mutual_as_one`, '
         '`Web.mutual_broken_iff_capacity`; two takers each within the slack of a need of one leave nothing, '
         '`Optimum.TwoTakers.joint_drains`). Where the eligible outcomes are supplied otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'SG2, [study §288]({SA288}));'
NEW71 = (f'SG2, [study §288]({SA288})); with several optimizers at a mutual best response, each blind to the same '
         'condition, the drain there is their joint capacity, the same as under one optimizer of that capacity, so '
         'coordinating optimizers none of whom couples into a condition keeps nothing there (`Optimum.mutual_beyond`, '
         f'`Optimum.mutual_as_one`, SG3, [study §{N}]({SA}));')
OLDT3S = 'hold for optima at one step with the rest exchanging as it does;'
NEWT3S = ('hold for optima at one step with the rest exchanging as it does, and for several optimizers at a mutual best '
          'response, the drain beyond every one\'s family being their joint capacity (`Optimum.mutual_beyond`, '
          '`Optimum.MutualBest.full`);')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = '*Open:* an optimizer choosing again at each step of a course, with the rest responding;'
NEW10a = (f'Landed (SG3, [study §{N}]({SA})): how much each formation takes when several draw, for optimizers at a '
          'mutual best response: at a condition beyond every optimizer\'s family each takes its whole capacity wherever '
          'something stands, the condition falls by their joint capacity as under one optimizer of that capacity, and '
          'restraint is no mutual best response (`Optimum.mutual_beyond`, `Optimum.MutualBest.full`, '
          '`Optimum.mutual_as_one`). *Open:* an optimizer choosing again at each step of a course, with the rest '
          'responding;')
OLD10b = 'how much each formation takes when several draw, as a law of the formations rather than a supplied flow;'
NEW10b = ('how much each formation takes when several draw outside a mutual best response, or at a condition within some '
          'drawer\'s family;')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10b, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10b, NEW10b).replace(OLD10c, NEW10c)
OLD6K = 'to their lower bounds (Zhuang and Hadfield-Menell 2020) (§7.1) |'
NEW6K = ('to their lower bounds (Zhuang and Hadfield-Menell 2020) (§7.1); the tragedy of the commons and open access '
         '(Hardin 1968; Gordon 1954) |')
OLD6 = 'with room read off conservation with capacity (`Optimum.Above.room`, `Optimum.optimum_beyond`) |'
NEW6 = ('with room read off conservation with capacity (`Optimum.Above.room`, `Optimum.optimum_beyond`), and several '
        'optimizers at a mutual best response draining a condition none registers by their joint capacity, as one '
        '(`Optimum.mutual_beyond`, `Optimum.mutual_as_one`) |')
OLD_ROW = line_from(ch0, f'| [Room read off the exchange](../results/records/{SG2}.md) |') + '\n'
NEW_ROW = (f'| [Several optimizers drain by their joint capacity](../results/records/{RID}.md) | theorem under stated '
           'premises | one step; a mutual best response; each optimizer\'s family, order and capacity; the condition beyond '
           'every family; for breaks, a dependence met at the step | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG3 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD34, NEW34), (OLD34R, NEW34R), (OLD71, NEW71), (OLDT3S, NEWT3S), (OLD10, NEW10), (OLD6K, NEW6K),
          (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '`Web.optimum_broken_iff_capacity`）、'
NEWZ34 = (OLDZ34 + '`Optimum.mutual_beyond`（多个优化者处于相互最优回应、各自按随其族升高的序独自优化时，每个族之外的条件立于'
          '其外的构成所留减去它们的合计容量处，有所存处各取其全部容量，`Optimum.MutualBest.full`；与由它们全体组成的一个部分相同，'
          '`Optimum.mutual_as_one`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'SG2，[研究第 288 节]({SA288})）；'
NEWZ71 = (OLDZ71 + '多个优化者处于相互最优回应、都不见同一条件时，那里的抽干是它们的合计容量，与一个具有该容量的优化者相同，'
          '故协调不耦合入该条件的优化者在那里什么也保不住（`Optimum.mutual_beyond`、`Optimum.mutual_as_one`，'
          f'SG3，[研究第 {N} 节]({SA})）；')
OLDZT3 = '对其余者照常交换的一步的最优成立；'
NEWZT3 = ('对其余者照常交换的一步的最优成立，对处于相互最优回应的多个优化者也成立：每个族之外的抽干是它们的合计容量'
          '（`Optimum.mutual_beyond`、`Optimum.MutualBest.full`）；')
OLDZ10a = '*开放：*优化者在一个过程的每一步重新选择、其余者回应；'
NEWZ10a = (f'已落地（SG3，[研究第 {N} 节]({SA})）：多个构成汲取时各取多少，对处于相互最优回应的优化者：在每个优化者的族之外的条件上，'
           '有所存处各取其全部容量，该条件降低它们的合计容量，与一个具有该容量的优化者相同，节制不是相互最优回应'
           '（`Optimum.mutual_beyond`、`Optimum.MutualBest.full`、`Optimum.mutual_as_one`）。' + OLDZ10a)
OLDZ10b = '多个构成汲取时各取多少，作为构成之律而非给定的流；'
NEWZ10b = '在相互最优回应之外、或在某个汲取者的族内的条件上，多个构成汲取时各取多少；'
OLDZ6K = '未涉及属性被压到下界（Zhuang and Hadfield-Menell 2020）（§7.1） |'
NEWZ6K = '未涉及属性被压到下界（Zhuang and Hadfield-Menell 2020）（§7.1）；公地悲剧与开放进入（Hardin 1968；Gordon 1954） |'
OLDZ6 = '余地从带容量的守恒读出（`Optimum.Above.room`、`Optimum.optimum_beyond`） |'
NEWZ6 = ('余地从带容量的守恒读出（`Optimum.Above.room`、`Optimum.optimum_beyond`），处于相互最优回应的多个优化者以合计容量'
         '抽干无人记录的条件，与一个相同（`Optimum.mutual_beyond`、`Optimum.mutual_as_one`） |')
OLDZROW = line_from(z, f'| [从交换读出的余地](../results/records/{SG2}.md) |') + '\n'
NEWZROW = (f'| [多个优化者以合计容量抽干](../results/records/{RID}.md) | 在所述前提下的定理 | 一步；相互最优回应；每个优化者的族、'
           '序与容量；条件在每个族之外；打断需该步被满足的依存 | §3.4、§7.1、§8.1 |\n')
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
edit(ZH, [(OLDZ34, NEWZ34), (OLDZ34R, NEWZ34R), (OLDZ71, NEWZ71), (OLDZT3, NEWZT3), (OLDZ10a, NEWZ10a),
          (OLDZ10b, NEWZ10b), (OLDZ6K, NEWZ6K), (OLDZ6, NEWZ6), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR),
          (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls)})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
