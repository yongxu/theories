#!/usr/bin/env python3
"""SG1 landing text: the study section, the chapter (EN, ZH: section 3.4's statement, section 7.1's in-words and prior
statements of the proxy problem, section 7.2 law 3, section 8.1 item 10, the relation-to-known-results row 6, the record
table and section 9's receipt and counts) and the board row moved to the history file with the queue and receipt
sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE
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
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Optimum'
RID = 'what-an-optimum-does-beyond-what-couples-in'
receipt_id, conn_log, base = sys.argv[1], sys.argv[2], sys.argv[3]


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
core = [m for m in R['modules'] if m['layer'] == 'core']
om = next(m for m in core if m['module'] == MOD)
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart; one new apart root in Becoming.Optimum, the witness that room binds '
              '(Optimum.Drain.room_needed), registered as a model witness; the general laws are used by the laws on webs '
              'and flows; register check passes')
study = (HERE / 'study_sg1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': om['theorems'], '{DECLS}': len(om['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-what-optimizing-through-couplings-does-beyond-them-sg1', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD34W = ('raising what couples in draws from beyond and, past the slack there, breaks what depends on it, and, where the '
          'stock drawn on couples in by threshold only, how far off a break is does not couple in.')
NEW34W = ('raising what couples in draws from beyond and, past the slack there, breaks what depends on it, an optimum of '
          'any order rising with what couples in lowers what lies beyond as far as any outcome does wherever that leaves '
          'what couples in room to rise, and, where the stock drawn on couples in by threshold only, how far off a break '
          'is does not couple in.')
OLD34B = line_from(ch0, '- `Flow.Balances.breaks_beyond`: where the whole gains nothing, the beyond falls by the rise')
NEW34B = OLD34B + '\n' + (
    '- `Optimum.least_iff`: over any set of outcomes (the levels after a step), every order rising with the levels of '
    'what couples in, ranking above every outcome that exceeds another there whatever either holds beyond, has its '
    'optima at the least level beyond, condition by condition, exactly where every outcome standing above another beyond '
    'is beaten on what couples in; shared units, a unit beyond movable into what couples in, give that room '
    '(`Optimum.least_of_shared`), and counting the beyond only after what couples in changes nothing '
    '(`Optimum.Rising.mono`, `Optimum.Drain.counted_after_drains`). An optimum breaks exactly the dependences beyond that '
    'some outcome breaks (`Web.optimum_broken_iff`), and where activity needs support their formations end, no member of '
    'a group coupled only into what couples in and coupled into by none (`Web.optimum_ends_beyond`; in `Diversion` the '
    'store\'s optimum drains the source and the dweller ends, `Optimum.Drain.drained_ends`). Of balanced steps from '
    'equal totals gaining nothing on the whole, one leaves the family at most where another does exactly where it leaves '
    'the beyond with the loss at least where the other does (`Flow.Balances.family_le_iff`, `Flow.top_iff_least`), and '
    'restricted to outcomes keeping each dependence beyond, the optimum takes exactly the slack '
    '(`Flow.keeping_optimum_takes_slack`; `Optimum.Drain.kept_takes_slack`). Without room an optimum need not lower '
    'anything (`Optimum.Drain.room_needed`), and an order rising only to a target has the keeping and the ending outcome '
    'both among its optima (`Optimum.Drain.satisficing_either`). The drive is Zhuang and Hadfield-Menell\'s (2020) '
    'Theorem 1 in discrete, conserved form (§7.1). Used in §7.1 and §7.2 (law 3).')
OLD34R = '[what-a-rise-draws-from-beyond](../results/records/what-a-rise-draws-from-beyond.md), [selection-under-registration-revision]'
NEW34R = (f'[what-a-rise-draws-from-beyond](../results/records/what-a-rise-draws-from-beyond.md), {REC}, '
          '[selection-under-registration-revision]')
OLD71W = ('It then reaches exactly what couples into the selector, and optimizing harder through the same couplings reaches '
          'no further; what a selection can separate grows only with what couples in.')
NEW71W = ('It then reaches exactly what couples into the selector, and optimizing harder through the same couplings reaches '
          'no further, while it lowers what lies beyond as far as any outcome does wherever that leaves what couples in '
          'room to rise; what a selection can separate grows only with what couples in.')
OLD71A = ('and Zhuang and Hadfield-Menell ("Consequences of Misaligned AI", NeurIPS 2020), who prove a stronger result: '
          'under shared resource constraints, optimizing a proxy that references only some attributes of a utility can '
          'drive the utility arbitrarily low, with conditions for when it does. The laws here add two things.')
NEW71A = ('and Zhuang and Hadfield-Menell ("Consequences of Misaligned AI", NeurIPS 2020), who prove that under shared '
          'resource constraints optimizing a proxy that references only some attributes of a utility drives the others '
          'to their lower bounds, and, the bounds low enough, must drive the utility arbitrarily low exactly where the '
          'feasible set of high utility is compact. The laws here add three things.')
OLD71B = ('and its gap lies at the union of their closures (`Web.pool_adds`, `Flow.unselected_beyond_pool`). They do not '
          'add a bound on how far optimizing degrades what lies beyond (Zhuang and Hadfield-Menell\'s theorem is stronger '
          'there), anything about which law training installs (§7.7), or a mechanism of alignment;')
NEW71B = ('and its gap lies at the union of their closures (`Web.pool_adds`, `Flow.unselected_beyond_pool`). *The '
          'optimum*: their drive holds for every order rising with what couples in, a lexicographic order counting the '
          'beyond after the proxy included, and on any set of outcomes exactly where lowering the beyond leaves room '
          f'(`Optimum.least_iff`, SG1, [study §{N}]({SA})); read on the spine, with no utility over the beyond, an optimum '
          'breaks exactly the dependences beyond that some outcome breaks (`Web.optimum_broken_iff`), the beyond with the '
          'loss falls by exactly what the family rises (`Flow.Balances.family_le_iff`), and keeping each dependence takes '
          'exactly the slack (`Flow.keeping_optimum_takes_slack`), less than holding the beyond where it was, as their '
          'Proposition 2 does. They do not reach Zhuang and Hadfield-Menell\'s continuous setting, their compactness '
          'characterization or their improvement by a proxy updated over time, and they add nothing about which law '
          'training installs (§7.7) or a mechanism of alignment;')
OLD72 = ('3. **Raising what couples in** (`Flow.favours_reaching_beyond`, §3.4). A rise of what a group couples into is paid '
         'from beyond it; whether what is taken is depended on is open (§8.1).')
NEW72 = ('3. **Raising what couples in** (`Flow.favours_reaching_beyond`, §3.4). A rise of what a group couples into is paid '
         'from beyond it, and past the slack of the dependences there it breaks one (`Flow.favours_breaking_beyond`); an '
         'optimum of any order rising with what couples in lowers what lies beyond as far as any outcome does wherever '
         'that leaves room, breaking exactly the dependences there that some outcome breaks (`Optimum.least_iff`, '
         '`Web.optimum_broken_iff`).')
OLD10 = line_from(ch0, '10. **What a rise draws from beyond** (further proof).')
OLD10a = 'restraint by the excess, by any drawers, keeps it (`Becoming.JointDraw`). *Open:*'
NEW10a = ('restraint by the excess, by any drawers, keeps it (`Becoming.JointDraw`). Landed (SG1, '
          f'[study §{N}]({SA})): an optimum of any order rising with what couples in stands at the least level beyond '
          'exactly where lowering it leaves room, and breaks exactly the dependences there that some outcome breaks; in '
          'balanced steps the beyond with the loss falls by exactly the family\'s rise, and keeping each dependence takes '
          'exactly the slack (`Becoming.Optimum`). *Open:* room derived from a law of exchange rather than supplied;')
OLD10b = '[what-a-rise-draws-from-beyond](../results/records/what-a-rise-draws-from-beyond.md).'
NEW10b = f'[what-a-rise-draws-from-beyond](../results/records/what-a-rise-draws-from-beyond.md), {REC}.'
for part in (OLD10a, OLD10b):
    assert OLD10.count(part) == 1, part
NEW10 = OLD10.replace(OLD10a, NEW10a).replace(OLD10b, NEW10b)
OLD6 = ('(Fagin, Halpern, Moses and Vardi 1995); for alignment, the proxy problem (§7.1) | The responsive closure (the rest '
        'following a law that reads through coupling, over time) and the pool form |')
NEW6 = ('(Fagin, Halpern, Moses and Vardi 1995); for alignment, the proxy problem and the drive of unreferenced attributes '
        'to their lower bounds (Zhuang and Hadfield-Menell 2020) (§7.1) | The responsive closure (the rest following a law '
        'that reads through coupling, over time) and the pool form; the drive for every order rising with what couples '
        'in, exact on any set of outcomes, read as the dependences broken (`Optimum.least_iff`, `Web.optimum_broken_iff`) |')
OLD_ROW = line_from(ch0, '| [What a rise draws from beyond](../results/records/what-a-rise-draws-from-beyond.md) |') + '\n'
NEW_ROW = (f'| [What an optimum does beyond what couples in](../results/records/{RID}.md) | theorem under stated premises | '
           'room among the eligible outcomes; for breaks, dependences met beyond; for endings, activity needing support; '
           'for the identity and the slack, balance and the whole gaining nothing | §3.4, §7.1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with SG1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD34W, NEW34W), (OLD34B, NEW34B), (OLD34R, NEW34R), (OLD71W, NEW71W), (OLD71A, NEW71A), (OLD71B, NEW71B),
          (OLD72, NEW72), (OLD10, NEW10), (OLD6, NEW6), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ34 = ('`Flow.Balances.broken_iff`（多个构成同时汲取时，打断依存的是共同的汲取，所需最高者先被打断，不论谁在汲取）、')
NEWZ34 = (OLDZ34 + '`Optimum.least_iff`（任何随耦合入者升高的序，其最优恰在之外最低的水平，当且仅当降低之外给耦合入者留出升高的余地；'
          '最优恰好打断某个结果所打断的之外的依存，`Web.optimum_broken_iff`；保持每个依存时最优恰取余量，'
          '`Flow.keeping_optimum_takes_slack`）、')
OLDZ34R = ('[what-a-rise-draws-from-beyond](../results/records/what-a-rise-draws-from-beyond.md)、')
NEWZ34R = OLDZ34R + f'{REC}、'
OLDZ71W = '经同样的耦合更用力地优化不会及于更远；选择能分开者只随耦合入者增长。'
NEWZ71W = '经同样的耦合更用力地优化不会及于更远，却把之外者降到任何结果所降到的最低处，只要这给耦合入者留出升高的余地；选择能分开者只随耦合入者增长。'
OLDZ71A = ('Zhuang and Hadfield-Menell（"Consequences of Misaligned AI", NeurIPS 2020）证明了更强的结果：在共享资源约束下，'
           '优化只涉及效用部分属性的代理，可以使效用任意低，并给出何时如此的条件。这里的规律加了两点。')
NEWZ71A = ('Zhuang and Hadfield-Menell（"Consequences of Misaligned AI", NeurIPS 2020）证明：在共享资源约束下，优化只涉及效用部分属性的代理，'
           '把其余属性压到其下界；下界足够低时，恰当高效用的可行集是紧的，效用必被压到任意低。这里的规律加了三点。')
OLDZ71B = ('（`Web.pool_adds`、`Flow.unselected_beyond_pool`）。它们没有加上：优化使其外者降低多少的界（那里 Zhuang 与 Hadfield-Menell '
           '的定理更强）、训练装入哪个律（§7.7），或对齐的机制；')
NEWZ71B = ('（`Web.pool_adds`、`Flow.unselected_beyond_pool`）。*最优*：他们的压低对每个随耦合入者升高的序成立（先代理、后计之外的词典序在内），'
           f'在任何结果集上恰当降低之外留有余地时成立（`Optimum.least_iff`，SG1，[研究第 {N} 节]({SA})）；在脊柱上读，不设之外的效用：'
           '最优恰好打断某个结果所打断的之外的依存（`Web.optimum_broken_iff`），之外加损失恰降低族所升之量（`Flow.Balances.family_le_iff`），'
           '保持每个依存则恰取余量（`Flow.keeping_optimum_takes_slack`），少于他们命题 2 那样把之外固定在原处。它们没有达到 Zhuang 与 '
           'Hadfield-Menell 的连续情形、紧性刻画或随时间更新代理的改进，也没有加上训练装入哪个律（§7.7）或对齐的机制；')
OLDZ10 = line_from(z, '10. **上升从其外汲取什么**（进一步的证明）。')
OLDZ10a = '任意汲取者按超出之量节制即保持依存（`Becoming.JointDraw`）。*开放：*'
NEWZ10a = ('任意汲取者按超出之量节制即保持依存（`Becoming.JointDraw`）。已落地（SG1，'
           f'[研究第 {N} 节]({SA})）：任何随耦合入者升高的序，其最优恰在降低之外留有余地时处于之外最低的水平，恰好打断某个结果所打断的'
           '那里的依存；平衡的步中，之外加损失恰降低族所升之量，保持每个依存则恰取余量（`Becoming.Optimum`）。*开放：*余地由交换之律导出而非给定；')
assert OLDZ10.count(OLDZ10a) == 1, OLDZ10a
NEWZ10 = OLDZ10.replace(OLDZ10a, NEWZ10a)
OLDZ6 = ('对齐方面是代理问题（§7.1） | 回应的闭包（其余者遵循经耦合读取的律，跨时间）与池的形式 |')
NEWZ6 = ('对齐方面是代理问题，以及未涉及属性被压到下界（Zhuang and Hadfield-Menell 2020）（§7.1） | 回应的闭包（其余者遵循经耦合读取的律，跨时间）'
         '与池的形式；对每个随耦合入者升高的序的压低，在任何结果集上恰当成立，读作被打断的依存（`Optimum.least_iff`、`Web.optimum_broken_iff`） |')
OLDZROW = line_from(z, '| [上升从其外汲取什么](../results/records/what-a-rise-draws-from-beyond.md) |') + '\n'
NEWZROW = (f'| [最优对耦合入者之外做什么](../results/records/{RID}.md) | 在所述前提下的定理 | 可选结果之间的余地；打断需之外的依存被满足；'
           '终止需活动需要支持；等式与余量需平衡、整体无所增益 | §3.4、§7.1 |\n')
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
edit(ZH, [(OLDZ34, NEWZ34), (OLDZ34R, NEWZ34R), (OLDZ71W, NEWZ71W), (OLDZ71A, NEWZ71A), (OLDZ71B, NEWZ71B),
          (OLDZ10, NEWZ10), (OLDZ6, NEWZ6), (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': om['theorems'],
                                           'd_new': len(om['declarations'])})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
