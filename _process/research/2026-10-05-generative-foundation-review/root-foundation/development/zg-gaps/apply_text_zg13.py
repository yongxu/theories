#!/usr/bin/env python3
"""ZG1-ZG3 landing text: three study sections, the significance review's gaps check, the chapter (EN: a paragraph in §1.5,
the record table and section 9; ZH: the record table and section 9), the ZH map chapter's §八, and the board (the ZG row
stays open; its state, the queue and the receipt sentence name the landing). Every edit must match exactly once.

usage (from the checkout root): python3 -B apply_text_zg13.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT
Prints the first study section number."""
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
MAPCH = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
LINK = f'../../../{STUDY}'
receipt_id, conn_log, base, previous = sys.argv[1:5]
RECS = [  # id, EN title, ZH title, kind EN, premises EN, kind ZH, premises ZH, section
 ('negation-change-and-stable-cases', 'A negation\'s change, and cases into a stable conclusion', '否定之变与归于稳定结论之分情形', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('least-parts-and-equal-shares', 'Least parts and equal shares', '最小之处与均分', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('copying-b-fold', 'Copying b-fold', 'b 倍抄录', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('far-conveying-runs-the-family-down', 'Far conveying runs the family down', '远输使族耗减', 'theorem under stated premises', 'balance and dissipation on the family', '有所述前提的定理', '族上衡且耗', '§1.5'),
 ('a-need-with-a-cap', 'A need with a cap', '带上限之需', 'theorem under stated premises', 'balance at the conditions required', '有所述前提的定理', '所需条件上衡', '§1.5'),
 ('tolerance-monotone-across-laws', 'Tolerance monotone across laws', '容忍之跨律单调', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('rivals-bounded-in-time', 'Rivals bounded in time', '以时为界之对手', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('order-of-exchanges-sharing-a-relatum', 'Exchanges sharing a relatum need not commute', '共享关系项之交换不必可交换', 'witness', '—', '见证', '—', '§1.5'),
 ('selection-right-exactly-where-read', 'Selection right exactly where what matters is read', '择恰在要紧者由象读出处为对', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('regulation-from-one-side-and-locally', 'Regulation from one side, beyond the gap, and locally', '单侧、越界与局部之调节', 'theorem under stated premises', 'balance; per-formation opposing and shares', '有所述前提的定理', '衡；各形成之相反与份额', '§1.5'),
 ('repeated-disturbance', 'Repeated disturbance', '反复扰动', 'theorem under stated premises', 'strengths and disturbances bounded on given schedules', '有所述前提的定理', '强度与扰动在给定时程上有界', '§1.5'),
 ('a-whole-carried-by-lasting-parts', 'A whole carried by lasting parts', '持续之部分承整体', 'theorem under stated premises', 'parts arising within every d steps, each lasting d steps', '有所述前提的定理', '每 d 步内有部分生起，各持续 d 步', '§1.5'),
 ('dormancy-over-a-stretch', 'Dormancy over a stretch, and final ending', '一段上之休眠与终局之终结', 'theorem under stated premises', 'reserve carried and decaying over the stretch; final ending', '有所述前提的定理', '储备在段上承载衰减；终局之终结', '§1.5'),
 ('arising-needs-change', 'Arising needs change', '生起需变', 'theorem under stated premises', 'activity exactly where supported', '有所述前提的定理', '恰在受支持时活跃', '§1.5'),
 ('need-drift-along-a-lineage', 'Need drift along a lineage', '世系上之需要漂移', 'theorem under stated premises', 'transmission within δ; needs not rising between descents', '有所述前提的定理', 'δ 内之传；两代间所需不升', '§1.5'),
 ('basins-of-a-determined-law', 'Basins of a determined law', '确定之律之势', 'theorem without premise', '— (finitely many configurations for the cycle)', '不加前提的定理', '—（回环须构形有限）', '§1.5'),
]


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
apart_text = (f'{apart} of {fmt(spine_thms)} apart; every new apart root registered (support, general structure, model '
              'witness) or joined through an instance on a web; register check passes')
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug  # noqa: E402
sections, slugs = [], []
for k, name in enumerate(('study_zg1.txt', 'study_zg2.txt', 'study_zg3.txt')):
    s = (HERE / name).read_text(encoding='utf-8')
    for a, b in {'{N}': N + k, '{RECEIPT}': receipt_id, '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
        s = s.replace(a, str(b))
    assert not re.search(r'\{[A-Z_]+\}', s) and s.count('```') % 2 == 0
    slugs.append(github_slug(s.split('\n', 1)[0].lstrip('# ').strip()))
    sections.append(s)
SA = [f'{LINK}#{x}' for x in slugs]
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="gaps-check"' not in rtext

ch0 = (ROOT / CH).read_text(encoding='utf-8')
anchor = '<a id="2-组织更新与演化--organization-renewal-and-evolution"></a>'
links = ', '.join(f'[{r[0]}](../results/records/{r[0]}.md)' for r in RECS)
para = ('The reading of the 脉络 found structures the spine had no law for, and those with precise statements are now '
        'laws on it: a negation\'s change and cases into a stable conclusion, least parts and equal shares, copying b-fold, '
        'far conveying, a need with a cap, tolerance monotone across laws, rivals bounded in time, order where a relatum '
        'is shared and selection read off a map (ZG1), regulation from one side and locally and repeated disturbance '
        '(ZG2), a whole carried by lasting parts, dormancy over a stretch, arising needing change, drift along a lineage '
        f'and the basins of a determined law (ZG3) ([study §{N}]({SA[0]}), [§{N + 1}]({SA[1]}), [§{N + 2}]({SA[2]})). '
        'Each answers an entry of the 脉络 map, whose gap note now names the law [AI reading, D45].\n\n'
        f'Records: {links}.\n\n')
OLD_ROW = line_from(ch0, '| [A coupling saturated by what it has carried](../results/records/') + '\n'
NEW_ROWS = ''.join(f'| [{r[1]}](../results/records/{r[0]}.md) | {r[3]} | {r[4]} | {r[7]} |\n' for r in RECS)
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with ZG1-ZG3 in the working tree ([study §{N}]({SA[0]})). It passed, the source unchanged during "
               "the check and the core with the ring compiled from the prelude.")
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
pairs = [(anchor, para + anchor), (OLD_ROW, OLD_ROW + NEW_ROWS), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE),
         (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ = line_from(z, '| [为所传之量所饱和的耦合](../results/records/') + '\n'
NEWZ = ''.join(f'| [{r[2]}](../results/records/{r[0]}.md) | {r[5]} | {r[6]} | {r[7]} |\n' for r in RECS)
OLDZR = line_from(z, '**当前回执**是运行 [`')
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SA[0]})）。")
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
zpairs = [(OLDZ, OLDZ + NEWZ), (OLDZR, NEWZR), (OLDZT, NEWZT)]

ML = f'../../../{STUDY}'
mpairs = [
 ('前两类已证（WH1、SAT1），述及它们的 5 个条目改读新律，其 `gap` 注指向新律：',
  f'第 1 至 5 类已证（WH1、SAT1、ZG1、ZG2）；连同其余有精确陈述者，共 30 个条目改读新律，其 `gap` 注以「已补」起首、指向新律'
  f'（[研究第 {N} 节]({ML}#{slugs[0]})、[第 {N + 1} 节]({ML}#{slugs[1]})、[第 {N + 2} 节]({ML}#{slugs[2]})）：'),
 ('每个形成只读其邻近条件的水平时，整体水平在什么条件下定于一处。',
  '每个形成只读其邻近条件的水平时，整体水平在什么条件下定于一处。已证：各形成在其条件上相反即调节之，如此调节之族其总量定，无一形成读总量；'
  '只镇一侧者只从该侧定之（`Becoming.Flow.stock_settles`、`Becoming.Flow.never_returns_below`；ZG2，'
  '[regulation-from-one-side-and-locally](../results/records/regulation-from-one-side-and-locally.md)）。'),
 ('由此，需要不等之处，总给足够而均分仍可使人不被支持。',
  '由此，需要不等之处，总给足够而均分仍可使人不被支持。已证（`Becoming.RelativePosition.equal_share_iff`、'
  '`Becoming.RelativePosition.equal_share_exceeds`，见证 `Becoming.RelativePosition.uneven_short`；ZG1，'
  '[least-parts-and-equal-shares](../results/records/least-parts-and-equal-shares.md)）。'),
 ('n 轮之后有几个单元，以及存量在什么条件下够用。',
  'n 轮之后有几个单元，以及存量在什么条件下够用。已证（`Becoming.Copying.copying_iff`，见证 `Becoming.Copying.tenfold`；ZG1，'
  '[copying-b-fold](../results/records/copying-b-fold.md)）。'),
]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH), ((ROOT / MAPCH).read_text(encoding='utf-8'), mpairs, MAPCH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + '\n\n'.join(s.rstrip('\n') for s in sections) + '\n', encoding='utf-8')
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_zg13.txt').read_text(encoding='utf-8').rstrip('\n') + '\n',
                           encoding='utf-8')
edit(CH, pairs)
exec((ROOT / f'{RF}/development/rm10-recent/section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)
edit(MAPCH, mpairs)

board = (ROOT / BOARD).read_text(encoding='utf-8')
lines = board.split('\n')
k = [i for i, l in enumerate(lines) if l.startswith('| **ZG: ')]
assert len(k) == 1
cells = lines[k[0]].split(' | ')
cells[2] = (f'claimed 2026-10-22 on `6eab1e8d6`; ZG1-ZG3 landed, core receipt `{receipt_id}`, sixteen records new, '
            f'25 ZH map entries read the new laws, study §{N}-§{N + 2}; ZG4-ZG6 in progress')
lines[k[0]] = ' | '.join(cells)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is ZG1-ZG3's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
parts = [p for p in m.group(1).split('; ') if not p.startswith('ZG1-ZG3 ')]
landed = (f'ZG1-ZG3 landed (the ZH gaps with precise statements: short laws, regulation from one side and locally, '
          f'repeated disturbance, wholes through lasting parts, dormancy, change, lineages and basins; sixteen records; '
          f'core receipt `{receipt_id}`, study §{N}-§{N + 2}; ZG row open for ZG4-ZG6)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
