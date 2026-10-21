#!/usr/bin/env python3
"""SG5 landing text: the study section, the significance review's horizon check, the chapter (EN, ZH: section 3.4's
statement and records, section 7.1's far-sight against the prior result, T3's standing, section 8.1 item 10, the
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
RID = 'horizon-optima-hold-the-greatest-renewal'
SG4 = 're-optimizing-above-a-renewal-ends-it'
SA291 = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
         '#291-a-course-of-re-optimizing-steps-against-a-renewal-sg4')
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
              'the web or used by one that is, the witnesses through the general laws; register check passes')
study = (HERE / 'study_sg5.txt').read_text(encoding='utf-8')
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
assert SLUG == f'{N}-courses-ranked-over-a-horizon-sg5', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
SREC = f'[{SG4}](../results/records/{SG4}.md)'

# Significance review: the horizon check, at the end.
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="horizon-check"' not in rtext
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_sg5.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34 = '`restraint_holds_more`). Where the eligible outcomes are supplied otherwise,'
NEW34 = ('`restraint_holds_more`). Where an order ranks whole courses over a horizon, what a course draws from a condition '
         'beyond, what it leaves there and everything the renewal falls short of its greatest `r` add to the start with '
         '`r` a step (`Optimum.drawn_add_shortfall`, `Flow.Balances.taken_add_shortfall`), so what is drawn registers a '
         'level only through what is renewed there, and two courses given alike and ending alike '
         'take the same (`Flow.Balances.taken_eq_of_alike`). Against a renewal given by a law of the level, the courses '
         'drawing the most are exactly those holding a level of greatest renewal through the horizon and leaving nothing '
         'at its end (`Optimum.most_iff`); where such a level lies within the start with what is given there and the '
         'capacity covers the first step\'s draw down to it and it with `r`, over at least two steps, every optimum of '
         'every order rising with the draw is one of them (`Optimum.frontier_holds`): a dependence whose need lies above '
         'every level of greatest renewal is broken at the first step and unmet through the horizon, and one that every '
         'such level meets is kept to the horizon\'s last step and broken at its end (`Web.frontier_broken`, '
         '`Web.frontier_kept`; in `Optimum.Holding`, under the logistic law the optimum draws a source from a dweller\'s '
         'need down to where it renews most, `logistic_broken`, and under a gate holding at the need and below it are '
         'both optima, taking the same, `gated_alike`). Where the eligible outcomes are supplied otherwise,')
OLD34R = f'{SREC}, [selection-under-registration-revision]'
NEW34R = f'{SREC}, {REC}, [selection-under-registration-revision]'
OLD71 = f'`Web.course_drawn_unbounded`, SG4, [study §291]({SA291}));'
NEW71 = (OLD71 + ' an optimizer ranking whole courses over a horizon instead, the far-sighted objection\'s sole owner, '
         'changes when a dependence ends, not whether a dependence its draw does not renew is kept: every optimum of every order '
         'rising with what is drawn holds the condition at a level of greatest renewal, keeping to the horizon a '
         'dependence those levels meet and breaking at the first step one needing more, and draws everything at its '
         'horizon, so lengthening the horizon keeps the resource base of the optimizer\'s own draw, and the order by '
         'the draw alone registers nothing else that depends on the condition (`Optimum.frontier_holds`, `Web.frontier_broken`, '
         f'`Optimum.Holding.gated_alike`, SG5, [study §{N}]({SA}));')
OLDT3S = '(`Optimum.course_beyond`, `Web.course_lost_iff`, `Web.mutual_course_lost`);'
NEWT3S = ('(`Optimum.course_beyond`, `Web.course_lost_iff`, `Web.mutual_course_lost`), and for an optimizer ranking whole '
          'courses over a horizon, a dependence above every level of greatest renewal broken at the first step '
          '(`Optimum.frontier_holds`, `Web.frontier_broken`);')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = ('*Open:* a renewal growing with the level, an optimizer ranking courses rather than steps, and how optimizers '
          'come to a mutual best response;')
NEW10a = (f'Landed (SG5, [study §{N}]({SA})): an optimizer ranking whole courses over a horizon, against a renewal given '
          'by a law of the level, growing with it as in logistic growth: what a course draws, leaves and forgoes adds to '
          'the start with the greatest renewal a step, so the courses drawing the most hold a level of greatest renewal '
          'and leave nothing at the horizon, every optimum of every order rising with the draw is one of them where such '
          'a level is within reach and the capacity, and a dependence above every such level is broken at the first '
          'step (`Optimum.most_iff`, `Optimum.frontier_holds`, `Web.frontier_broken`, `Web.frontier_kept`). *Open:* an '
          'order valuing what is left at the horizon or discounting later draws, the optimum where no level of greatest '
          'renewal is within reach, several optimizers ranking courses, and how optimizers come to a mutual best '
          'response;')
OLD10c = f'{SREC}.'
NEW10c = f'{SREC}, {REC}.'
for part in (OLD10a, OLD10c):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10c, NEW10c)
OLD6K = 'Levhari and Mirman 1980) |'
NEW6K = ('Levhari and Mirman 1980); the sole owner holding a stock at the maximum sustainable yield\'s level and the '
         'finite-horizon harvest (Schaefer 1954; Scott 1955; Clark 1976) |')
OLD6 = '`Web.mutual_course_lost`) |'
NEW6 = ('`Web.mutual_course_lost`), and over a horizon every optimum of every order rising with the draw holding a level '
        'of greatest renewal, breaking at the first step a dependence above every such level (`Optimum.frontier_holds`, '
        '`Web.frontier_broken`) |')
OLD_ROW = line_from(ch0, f'| [Re-optimizing above a renewal ends it](../results/records/{SG4}.md) |') + '\n'
NEW_ROW = (f'| [Over a horizon, optima hold the greatest renewal](../results/records/{RID}.md) | theorem under stated '
           'premises | courses open from a start, ranked by an order rising with what is drawn over a horizon of at '
           'least two steps; a renewal given by a law of the level, at most `r`, and `r` at a level within reach; a '
           'capacity covering the first step\'s draw down to it and it with `r`; for the web laws, a dependence whose '
           'need lies above every level of greatest renewal or is met by every one | §3.4, §7.1, §8.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG5 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD34, NEW34), (OLD34R, NEW34R), (OLD71, NEW71), (OLDT3S, NEWT3S), (OLD10, NEW10),
          (OLD6K, NEW6K), (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = '合计超出更新的多个优化者一起使其丧失，`Web.mutual_course_lost`）、'
NEWZ34 = (OLDZ34 + '`Optimum.frontier_holds`（在一个视野上对整个过程排序时，过程所汲取、所留与更新不足其最大 `r` 的全部之和是起始加每步 '
          '`r`，`Optimum.drawn_add_shortfall`、`Flow.Balances.taken_add_shortfall`，故所汲取只通过在某水平被更新者记录该水平；'
          '更新是水平之律时，汲取最多的过程恰是在视野内保持在最大更新的水平、终了不留的过程，`Optimum.most_iff`；这样的水平在起始加所给之内、'
          '容量足以在第一步降到它并承担它加 `r`、视野至少两步时，随汲取升高之序的每个最优都如此：需要高于所有这些水平的依存在第一步被打破，'
          '并在视野内不被满足，`Web.frontier_broken`，被它们都满足的依存保持到视野最后一步并在其末被打破，`Web.frontier_kept`）、')
OLDZ34R = f'{SREC}、'
NEWZ34R = f'{SREC}、{REC}、'
OLDZ71 = f'SG4，[研究第 291 节]({SA291})）；在脊柱上读'
NEWZ71 = (f'SG4，[研究第 291 节]({SA291})）；改为在一个视野上对整个过程排序的优化者，即远见异议中的唯一所有者，改变的是依存何时终结，'
          '而不是其汲取不更新的依存是否被保持：随所汲取升高之序的每个最优都把条件保持在最大更新的水平，把这些水平满足的依存保持到视野之末，'
          '在第一步打破需要更多者，并在视野之末汲取全部；故延长视野保住的是优化者自身汲取的资源基础，只按汲取排序之序对依存于该条件的其他者毫无记录'
          f'（`Optimum.frontier_holds`、`Web.frontier_broken`、`Optimum.Holding.gated_alike`，SG5，[研究第 {N} 节]({SA})）；在脊柱上读')
OLDZT3 = '（`Optimum.course_beyond`、`Web.course_lost_iff`、`Web.mutual_course_lost`）；'
NEWZT3 = ('（`Optimum.course_beyond`、`Web.course_lost_iff`、`Web.mutual_course_lost`），对在一个视野上对整个过程排序的优化者也成立：'
          '高于每个最大更新水平的依存在第一步被打破（`Optimum.frontier_holds`、`Web.frontier_broken`）；')
OLDZ10a = '*开放：*随水平增长的更新、对过程而非对步排序的优化者、优化者如何达到相互最优回应；'
NEWZ10a = (f'已落地（SG5，[研究第 {N} 节]({SA})）：在一个视野上对整个过程排序的优化者，面对由水平之律给出、如逻辑斯谛增长那样随水平增长的更新：'
           '过程所汲取、所留与所放弃之和是起始加每步最大更新，故汲取最多的过程保持在最大更新的水平并在视野之末不留；这样的水平可及、容量足够时，'
           '随汲取升高之序的每个最优都是其中之一，高于每个这样水平的依存在第一步被打破（`Optimum.most_iff`、`Optimum.frontier_holds`、'
           '`Web.frontier_broken`、`Web.frontier_kept`）。*开放：*对视野末所留赋值或对后来汲取折现之序、没有可及的最大更新水平时的最优、'
           '多个对过程排序的优化者、优化者如何达到相互最优回应；')
OLDZ6K = 'Levhari and Mirman 1980） |'
NEWZ6K = 'Levhari and Mirman 1980）；把存量保持在最大可持续产量水平的唯一所有者与有限视野的收获（Schaefer 1954；Scott 1955；Clark 1976） |'
OLDZ6 = '`Web.course_drawn_unbounded`、`Web.mutual_course_lost`） |'
NEWZ6 = ('`Web.course_drawn_unbounded`、`Web.mutual_course_lost`），在一个视野上，随汲取升高之序的每个最优都保持在最大更新的水平，'
         '在第一步打破高于每个这样水平的依存（`Optimum.frontier_holds`、`Web.frontier_broken`） |')
OLDZROW = line_from(z, f'| [在更新之上重新优化将其终结](../results/records/{SG4}.md) |') + '\n'
NEWZROW = (f'| [在视野上，最优保持在最大更新处](../results/records/{RID}.md) | 在所述前提下的定理 | 自起点开放的过程，按随至少两步视野内所汲取'
           '升高之序排序；由水平之律给出的更新，至多 `r`，在可及的水平处为 `r`；容量足以在第一步降到它并承担它加 `r`；对网之律，需要高于每个'
           '最大更新水平、或被每个这样的水平满足的依存 | §3.4、§7.1、§8.1 |\n')
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
          (OLDZ6K, NEWZ6K), (OLDZ6, NEWZ6), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new_thms,
                                           'd_new': len(new_decls)})
print('new declarations', len(new_decls), 'new theorems', n_new_thms, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
