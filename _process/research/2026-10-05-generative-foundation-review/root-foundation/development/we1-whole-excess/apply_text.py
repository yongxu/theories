#!/usr/bin/env python3
"""WE1 landing text: the study section; the chapter (EN: section 2.3's in-words, law and records, theses T1's standing
and forbids, the record table and section 9's receipt and counts; ZH: section 2.3's theorem line and records, T1, the
record table and section 9); OPENING's note `collective` (AI text; the body is Ren's and unchanged); the significance
review's revised proposal 8, its standing; the board row moved to the history file with the queue and receipt
sentences. Every edit must match exactly once (adapted from SG1's apply_text.py).

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
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = f'{RF}/BECOMING-RENEWAL-READING.md'
REVIEW = f'{RF}/BECOMING-SIGNIFICANCE-REVIEW.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
OPENING = 'theories/becoming/OPENING.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Wholes'
RID = 'whole-drawing-beyond-renewal-ends'
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
mod_apart = conn['apart_by_module'].get(MOD, [0])[0]

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart, {mod_apart} of them in Becoming.Wholes; no new apart root; the new '
              'laws are stated on webs and flows; register check passes')
study = (HERE / 'study_we1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': om['theorems'], '{DECLS}': len(om['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-a-whole-that-draws-its-parts-arising-beyond-its-renewal-ends-we1', SLUG
SA = f'../../../{STUDY}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD23W = 'ends them and everything depending on the condition at that need.'
NEW23W = (OLD23W + ' A whole of parts that each end, whose parts arise only where they depend on such a condition, '
          'ends with it, whoever draws.')
OLD23B = line_from(ch0, '- `Flow.excess_bounded`, `Flow.joint_excess_ends`:')
NEW23B = OLD23B + '\n' + (
    '- `Web.Whole.family_excess_ends`: a whole that draws its parts\' arising beyond its renewal ends. Read on one world '
    'with a flow, a whole (`Web.Whole`, active exactly while some part is, §2.2) of parts listed at each step and each '
    'ending, whose parts arise only where they then depend on some condition of a family at a need of at least `m`, the '
    'family\'s renewal gated on it, has no part arising after `n` steps of excess of the family\'s uptake over its '
    'replenishment from a stock below `n + m`, and ends; the family of one condition is `Web.Whole.joint_excess_ends`. '
    'Below it, listed parts each ending, none arising from some step on, end together with their whole '
    '(`Web.Listed.end_without_arising`, `Web.Whole.ends_without_arising`), of which `Whole.needs_arising` is the '
    'corollary. The uptake is the joint draw: the whole need not be a taker, and its own draw within what is renewed '
    'proves nothing. The parts need not depend on the family once arisen; the whole ends once those arisen have ended. '
    'Every premise holds with a whole active for three steps (`WholeExceeding.drawn`), and the excess, ending parts and '
    'the arising\'s dependence are each needed (`WholeWithin.kept`, `WholeUnending.persists`, `WholeUngated.persists`). '
    'Read with a collective as the whole of its lives and their renewal as the family, this is OPENING\'s "one that '
    'consumes them consumes what it goes on through" under named premises [AI reading; '
    f'[study §{N}]({SA})].')
OLD23R = ('[own-count-misses-joint-excess](../results/records/own-count-misses-joint-excess.md), '
          '[derived-extent-limits]')
NEW23R = ('[own-count-misses-joint-excess](../results/records/own-count-misses-joint-excess.md), '
          f'{REC}, [derived-extent-limits]')
OLDT1S = '(`Flow.joint_excess_ends`, under balance, only active giving and activity needing support);'
NEWT1S = (OLDT1S + ' a whole of parts that each end, whose parts arise only where they depend on the condition, ends '
          'with it, the draw counted jointly, the whole\'s with every other (`Web.Whole.family_excess_ends`, '
          f'[study §{N}]({SA}));')
OLDT1F = 'a dependent that stays active through steps at which its condition stood below its need;'
NEWT1F = (OLDT1F + ' a collective of finitely many members at a time, each ending, whose members arise only where the '
          'drawn condition stands at their need, outlasting a run of joint excess on it longer than its margin;')
OLD_ROW = line_from(ch0, '| [Counting one\'s own draw misses joint excess](../results/records/own-count-misses-joint-excess.md) |') + '\n'
NEW_ROW = (f'| [A whole that draws its parts\' arising beyond its renewal ends](../results/records/{RID}.md) | theorem '
           'under stated premises | balance, activity needing support | §2.3 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with WE1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD23W, NEW23W), (OLD23B, NEW23B), (OLD23R, NEW23R), (OLDT1S, NEWT1S), (OLDT1F, NEWT1F),
          (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ23 = '`Flow.excess_bounded`、`Flow.joint_excess_ends`、`Flow.continuing_excludes`'
NEWZ23 = ('`Flow.excess_bounded`、`Flow.joint_excess_ends`、`Web.Whole.family_excess_ends`（部分各自终结、只在依存于某条件族时生起的整体，'
          '在族的取用超过其补充长于余量之后再无部分生起并终结；取用是联合的，整体不必是取用者）、`Flow.continuing_excludes`')
OLDZ23R = ('[own-count-misses-joint-excess](../results/records/own-count-misses-joint-excess.md)、[derived-extent-limits]')
NEWZ23R = (f'[own-count-misses-joint-excess](../results/records/own-count-misses-joint-excess.md)、{REC}、'
           '[derived-extent-limits]')
OLDZT1S = '在模型中、在其前提下已证：`Flow.joint_excess_ends`、'
NEWZT1S = (OLDZT1S + '`Web.Whole.family_excess_ends`（部分各自终结、只在依存于该条件时生起的整体随之终结，'
           f'汲取按联合计，[研究第 {N} 节]({SA})）、')
OLDZT1F = '依存者在其条件低于需要的各步中仍然活动；'
NEWZT1F = OLDZT1F + '成员各自终结、同时有限、只在所汲取的条件处于其需要时生起的集体，经历长于余量的联合超出而延续；'
OLDZROW = line_from(z, '| [只计自身的取用漏掉联合超出](../results/records/own-count-misses-joint-excess.md) |') + '\n'
NEWZROW = (f'| [汲取其部分之生起超过更新的整体终结](../results/records/{RID}.md) | 在所述前提下的定理 | 平衡、活动需要支持 | §2.3 |\n')
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
edit(ZH, [(OLDZ23, NEWZ23), (OLDZ23R, NEWZ23R), (OLDZT1S, NEWZT1S), (OLDZT1F, NEWZT1F),
          (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# OPENING's note `collective`: AI text; the body sentence it annotates is Ren's and unchanged.
OLDO = ('[^collective]: **Proved in part, partly under the continuation condition; "consumes" is not proved.** With '
        'neither balance nor dissipation, a whole active exactly while some part is, persisting from some step on, made '
        'of parts whose activity each ends, with its active parts listed at each step, has new parts arising at '
        'arbitrarily late steps (`Web.Whole.needs_arising`): a collective made of lives that each end goes on only as '
        'new lives keep arising. `Whole` is coincidence of activity and has no draws, so that a collective consumes its '
        'lives is not stated; joining it to joint excess (`Flow.joint_excess_ends`) would state it.')
NEWO = ('[^collective]: **Proved, "consumes" under named premises and readings; partly under the continuation '
        'condition.** With neither balance nor dissipation, a whole active exactly while some part is, persisting from '
        'some step on, made of parts whose activity each ends, with its active parts listed at each step, has new parts '
        'arising at arbitrarily late steps (`Web.Whole.needs_arising`): a collective made of lives that each end goes on '
        'only as new lives keep arising. Where none arises from some step on, such parts end together, and their whole '
        'with them (`Web.Whole.ends_without_arising`). Read with a flow, under balance, only active formations giving and '
        'activity needing support: where new parts arise only where they depend on a condition (or a family of them) '
        'renewed only by what depends on it, and the joint draw on it exceeds what is renewed for more consecutive steps '
        'than its level stands above the need, no part arises from then on and the whole ends '
        f'(`Web.Whole.family_excess_ends`; [record](results/records/{RID}.md)). So a collective that draws on what its '
        'lives arise through beyond what they renew consumes what it goes on through. The draw is joint, the '
        'collective\'s with every other: the law does not single out the collective as the consumer, and its own draw '
        'within what is renewed proves nothing. That a collective is the whole of its lives, that what it draws on is '
        'what its lives arise through, and that this draw is its consuming them are readings, since a life is a '
        'formation, not an amount drawn.')
edit(OPENING, [(OLDO, NEWO)])

# The significance review's revised proposal 8: its standing.
OLDP = ('*Standing:* the first clause is proved (`Web.Whole.needs_arising`); the second is the joint-excess law '
        '(`Flow.joint_excess_ends`) read with the collective as the drawer and its lives as the renewing condition, a '
        'reading, since `Whole` has no draws (note `collective`); a short core statement joining the two would make it a '
        'theorem, and is a possible proof item, not claimed here.')
NEWP = ('*Standing:* the first clause is proved (`Web.Whole.needs_arising`); the second is proved under named premises '
        f'(WE1, [study §{N}](BECOMING-RENEWAL-READING.md#{SLUG})): where new lives arise only where they depend on a '
        'condition renewed only by what depends on it, and the joint draw on it, the collective\'s with every other, '
        'exceeds what is renewed for more consecutive steps than its level stands above the need, no life arises from '
        'then on and the collective ends (`Web.Whole.family_excess_ends`, under balance, only active formations giving '
        'and activity needing support); that the collective is the whole of its lives, and that "draws on them" is '
        'drawing on what they arise through, are the readings left (note `collective`, restated). *Was, before WE1 '
        '(21 October 2026):* the second clause read the joint-excess law with the collective as the drawer, a reading, '
        'since `Whole` had no draws.')
edit(REVIEW, [(OLDP, NEWP)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': om['theorems'],
                                           'd_new': len(om['declarations'])})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
