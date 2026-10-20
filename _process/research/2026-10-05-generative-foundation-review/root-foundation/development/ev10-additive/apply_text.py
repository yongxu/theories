#!/usr/bin/env python3
"""EV10 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt and counts), the evolution chapter (its summary, the recovery table row and next connection 2), the board row moved to the history file and the queue and receipt sentences. Every edit must match exactly once.

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
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.Reproduction'
RID = 'additive-part-of-offspring-variance'
EV9RID = 'fixation-by-drift'
WBRID = 'what-bounds-offspring-numbers'
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


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
core = [m for m in R['modules'] if m['layer'] == 'core']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
mod = next(m for m in core if m['module'] == MOD)
n_thm, n_decl = mod['theorems'], len(mod['declarations'])
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

# Study section: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = f'{apart} of {fmt(spine_thms)} apart; the new apart roots registered; register check passes'
study = (HERE / 'study_ev10.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_thm, '{DECLS}': n_decl, '{APART}': apart_text,
             '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert '{' not in study.split('```')[1], 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-the-additive-part-of-fishers-theorem-ev10'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
EV9REC = f'[{EV9RID}](../results/records/{EV9RID}.md)'
WBREC = f'[{WBRID}](../results/records/{WBRID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD_B = 'without dissipation a lossless relay keeps a lineage going (`Reproduction.Relay.relay`).\n'
NEW_B = ('without dissipation a lossless relay keeps a lineage going (`Reproduction.Relay.relay`). The additive part: counted, '
         'Cauchy–Schwarz holds over any finite list (`Reproduction.bound_sq`), so the concordance with the discordance of '
         'offspring number with any carried amount, squared, is at most the squared differences of offspring numbers over '
         'pairs times those of the amount (`Reproduction.additive_le`, `Reproduction.covariance_sq_le`): the additive part '
         'of the variance in offspring number through the amount is at most the whole, all of it where the amount is '
         'offspring number itself (`Reproduction.additive_self`), and with exact transmission the rise of the amount\'s '
         'mean is bounded so (`Reproduction.Generations.response_sq_le`); an amount can vary beside varying offspring '
         'numbers with no covariance (`Reproduction.Unrelated.unrelated`).\n')
OLD_RECS = f'{EV9REC}, [transmission'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
i = ch0.index(f'| [Fixation by drift](../results/records/{EV9RID}.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROW = (f'| [The additive part of the variance in offspring number](../results/records/{RID}.md) | theorem with no premise '
           '| none for the bounds; exact transmission of the amount for the course over generations | §2.4 |\n')
i = ch0.index("9. **Evolution's selection term** (further proof).")
OLD9 = ch0[i:ch0.index('\n', i)]
OLD9a = 'its transmission lowering offspring number by more than selection raises it, `Becoming.Reproduction`;'
NEW9a = ('its transmission lowering offspring number by more than selection raises it, and the additive part of the '
         'variance in offspring number through any carried amount at most the whole (counted Cauchy–Schwarz), '
         '`Becoming.Reproduction`;')
OLD9b = ('rational amounts beyond a common denominator, and the additive part of Fisher\'s theorem (a regression of '
         'offspring number on what is carried).')
NEW9b = ('rational amounts beyond a common denominator; the additive part through several carried amounts at once (the '
         'breeding value), and Fisher\'s identity itself, which needs the regression coefficient.')
assert OLD9.count(OLD9a) == 1 and OLD9.count(OLD9b) == 1, (OLD9.count(OLD9a), OLD9.count(OLD9b))
NEW9 = OLD9.replace(OLD9a, NEW9a).replace(OLD9b, NEW9b).replace(OLD_RECS, f'{EV9REC}, {REC}, [transmission')
i = ch0.index('Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
OLD_RECLINE = ch0[i:ch0.index('\n', i)]
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, f'{EV9REC}, {REC}, [transmission')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV9 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD_B, NEW_B), (OLD9, NEW9), (OLD_RECLINE, NEW_RECLINE), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
i = z.index('`Reproduction.Flow.closed_lineage_lowered`（')
j = z.index('）、', i) + 2
OLDZ24 = z[i:j]
NEWZ24 = (OLDZ24 + '`Reproduction.additive_le`（加性部分：计数形式的 Cauchy–Schwarz 对任一有限列表成立（`Reproduction.bound_sq`），'
          '故后代数与任一所载之量的一致度加不一致度的平方，至多为后代数各对差的平方之和乘该量各对差的平方之和：后代数方差中经由该量的加性部分'
          '至多为全部，该量即后代数本身时为全部（`Reproduction.additive_self`），传递精确时该量均值的升降亦受此界'
          '（`Reproduction.Generations.response_sq_le`）；一个量可以在后代数变化时变化而毫无协方差（`Reproduction.Unrelated.unrelated`））、')
i = z.index(f'| [漂变导致的固定](../results/records/{EV9RID}.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROW = (f'| [后代数方差的加性部分](../results/records/{RID}.md) | 无前提的定理 | 界不加前提；世代进程需该量传递精确 | §2.4 |\n')
i = z.index('9. **演化的选择项**（进一步的证明）。')
OLDZ9 = z[i:z.index('\n', i)]
OLDZ9a = '在被耗散之族内终止、其传递对后代数的降低超过选择之升高的世系，`Becoming.Reproduction`；'
NEWZ9a = ('在被耗散之族内终止、其传递对后代数的降低超过选择之升高的世系，以及后代数方差中经由任一所载之量的加性部分至多为全部（计数形式的 '
          'Cauchy–Schwarz），`Becoming.Reproduction`；')
OLDZ9b = '公分母之外的有理数的量，以及 Fisher 定理的加性部分（后代数对所载之物的回归）。'
NEWZ9b = '公分母之外的有理数的量；同时经由多个所载之量的加性部分（育种值），以及需要回归系数的 Fisher 恒等式本身。'
assert OLDZ9.count(OLDZ9a) == 1 and OLDZ9.count(OLDZ9b) == 1, (OLDZ9.count(OLDZ9a), OLDZ9.count(OLDZ9b))
NEWZ9 = OLDZ9.replace(OLDZ9a, NEWZ9a).replace(OLDZ9b, NEWZ9b)
i = z.index('**当前回执**是运行 [`')
OLDZR = z[i:z.index('\n', i)]
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
edit(ZH, [(OLDZ24, NEWZ24), (OLDZROW, OLDZROW + NEWZROW), (OLDZ9, NEWZ9), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The evolution chapter.
OLD_S = f'a lossless relay escapes, so dissipation is needed ({WBREC}).'
NEW_S = (f'a lossless relay escapes, so dissipation is needed ({WBREC}). Any carried amount moves with offspring number at '
         'most as far as their spreads allow: the squared covariance is at most the product of the variances, so the part '
         'of the variance in offspring number an amount carries, Fisher\'s additive part, is at most the whole, and all of '
         f'it where the amount is offspring number itself ({REC}).')
OLD_TAB = f'Fisher\'s fundamental theorem in its exact-transmission case, as selection on offspring number itself ({WBREC});'
NEW_TAB = (f'Fisher\'s fundamental theorem in its exact-transmission case, as selection on offspring number itself ({WBREC}), '
           f'and its additive part through one carried amount bounded by the whole variance ({REC});')
OLD_TAB2 = 'drift with selection in one draw, the additive part of Fisher\'s theorem and rational amounts.'
NEW_TAB2 = 'drift with selection in one draw, the additive part through several amounts and rational amounts.'
OLD_C2 = ('2. **The additive part of Fisher\'s theorem.** A regression of offspring number on what is carried, in counting '
          f'form, so that the exact-transmission case of {WBREC} becomes the general one.')
NEW_C2 = ('2. **The additive part of Fisher\'s theorem.** Through one carried amount it is on the spine: counted '
          'Cauchy–Schwarz bounds the squared covariance of offspring number with the amount by the product of the '
          f'spreads, so the additive part is at most the whole, and the exact-transmission case of {WBREC} is the amount '
          f'that attains it ({REC}). Open are several carried amounts at once (the breeding value) and Fisher\'s identity '
          'itself, which needs the regression coefficient.')
edit(EVO, [(OLD_S, NEW_S), (OLD_TAB, NEW_TAB), (OLD_TAB2, NEW_TAB2), (OLD_C2, NEW_C2)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_thm': n_thm})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
