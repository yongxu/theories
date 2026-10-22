#!/usr/bin/env python3
"""WL2 landing text: the study section; the chapter (EN: §3.3 and §3.4, the record table and section 9; ZH: the same);
the chapter WENLI-AND-BECOMING through its fragments (head, centre), rebuilt by make_chapter.py and build_tables.py; the
中华本 through a round of exact edits (work/round8-edits.json, written here and named in finish.py's ROUNDS), rebuilt by
finish.py; and the board (the WL2 row moves to the history file; the queue and the receipt sentence name the landing).
Every edit must match exactly once.

usage (from the checkout root): python3 -B apply_text_wl2.py RECEIPT CONNECTIVITY_LOG BASE
Prints the study section number."""
import json
import re
import subprocess
import sys
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = f'{RF}/BECOMING-RENEWAL-READING.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
WL = 'theories/becoming/chapters/WENLI-AND-BECOMING.md'
ZK = f'{RF}/development/zhonghua'
BOARD = '_process/BECOMING-WORKBOARD.md'
HIST = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
receipt_id, conn_log, base = sys.argv[1:4]
sys.path.insert(0, str(HERE))
from texts_wl2 import centre_pairs, head_pairs, round8  # noqa: E402


def edit(path, pairs):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    for old, _ in pairs:
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
t = (ROOT / conn_log).read_text()
conn = json.loads(t[t.index('{'):t.rindex('}') + 1])
apart = sum(v for k, v in conn['classes'].items() if k.startswith('apart'))
assert conn['spine_theorems'] == spine_thms, (conn['spine_theorems'], spine_thms)
mine = [n for n in conn['apart_roots_unclassified']
        if n.startswith(('Becoming.Law.', 'Becoming.Web.', 'Becoming.SharedCodes.', 'Becoming.IdentificationRuns.'))]
assert not mine, mine

stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
others = [n for n in conn['apart_roots_unclassified']]
apart_text = (f'{apart} of {fmt(spine_thms)} apart; the one new apart root of WL2, SharedCodes.code_read_every, registered '
              '(general structure); the Law and Web laws reach the base'
              + (f'; unregistered roots of other landings, not WL2\'s: {", ".join(others)}' if others else ''))
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug  # noqa: E402
s = (HERE / 'study_wl2.txt').read_text(encoding='utf-8')
for a, b in {'{N}': N, '{RECEIPT}': receipt_id, '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    s = s.replace(a, str(b))
assert not re.search(r'\{[A-Z_]+\}', s) and s.count('```') % 2 == 0
slug = github_slug(s.split('\n', 1)[0].lstrip('# ').strip())
SL = f'../../../{STUDY}#{slug}'

# --- the chapter, EN
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD33 = ('*The split that makes sense*: the coarsest split keeping the map\'s value and carrying a law makes sense '
         '(`Law.identifiesAlike_of_law`),')
NEW33 = ('*The split that makes sense*: the coarsest class keeping the map\'s value and carrying a law merges exactly the '
         'configurations with the same future through the map and makes sense, one law (`Law.coarsest_iff`); the same '
         'future is the coarsest such relation with no premise, and as a class it is named where a list holds every '
         'configuration (`Law.sameFuture_coarsest`, `Law.coarsest_class`; WL2, [study §' + str(N) + '](' + SL + ')),')
OLD34 = ('The gap is the reach closure less the coupling closure (`Clearing.unselected`). Used in §7.1–§7.4, where the pool '
         'laws are stated.')
NEW34 = (OLD34 + ' Where what couples in is read as values (decided admission and listed couplings give a reading, '
         '`Web.listed_values`), being alike through a formation\'s couplings up to a step is one prefix of its own course, '
         'the value at each step of what couples in (`Web.alikeThroughUpTo_iff_prefix`); a selection is through them '
         'exactly where it selects by that prefix (`Web.selectsThrough_iff_prefix`); and where its own courses have at '
         'most N and N′ states, what it ever tells apart it tells apart within N + N′ − 1 steps (`Web.alike_of_bounded`, '
         'exact by `Web.bounded_exact`; WL2).')
REC34_OLD = '[selection-through-couplings](../results/records/selection-through-couplings.md), [selection-through-a-model-of-the-options]'
REC34_NEW = ('[selection-through-couplings](../results/records/selection-through-couplings.md), '
             '[a-formations-own-course](../results/records/a-formations-own-course.md), [selection-through-a-model-of-the-options]')
ROW_OLD = line_from(ch0, '| [Selection through the couplings](../results/records/selection-through-couplings.md) |') + '\n'
ROW_NEW = ROW_OLD + ("| [A formation's own course](../results/records/a-formations-own-course.md) | theorem under stated premises | "
                     "what couples in read as values | §3.4 |\n")
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with WL2 in the working tree ([study §{N}]({SL})). It passed, the source unchanged during "
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
pairs = [(OLD33, NEW33), (OLD34, NEW34), (REC34_OLD, REC34_NEW), (ROW_OLD, ROW_NEW), (OLD_RECEIPT, NEW_RECEIPT),
         (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# --- the chapter, ZH
z = (ROOT / ZH).read_text(encoding='utf-8')
Z33_OLD = '`Identification.leastBound_exact`、`learnable_iff`、`Parting.world_right_iff`；完整陈述见[英文版 §3.3]'
Z33_NEW = ('`Identification.leastBound_exact`、`learnable_iff`、`Parting.world_right_iff`，以及 `Law.coarsest_iff`（守映射之值而载法之类中，'
           '最粗者所并恰是经映射未来相同之配置，一条律；WL2）；完整陈述见[英文版 §3.3]')
Z34_OLD = '`Web.break_not_bounded`、`Web.selects_alike_iff`、'
Z34_NEW = ('`Web.break_not_bounded`、`Web.selects_alike_iff`、`Web.alike_of_bounded`（耦合入者读作值时，经一形成之耦合至某步无别，'
           '恰是其自身历程之前段相同；自身历程至多 N 与 N′ 个状态者，所分者于 N + N′ − 1 步内分尽，此界确切；WL2）、')
ZREC_OLD = '[selection-through-couplings](../results/records/selection-through-couplings.md)、'
ZROW_OLD = line_from(z, '| [经耦合的选择](../results/records/selection-through-couplings.md) |') + '\n'
ZROW_NEW = ZROW_OLD + '| [一形成自身之历程](../results/records/a-formations-own-course.md) | 在所述前提下的定理 | 耦合入者读作值 | §3.4 |\n'
OLDZR = line_from(z, '**当前回执**是运行 [`')
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SL})）。")
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
zi = z.index('### 3.4')
assert z.count(ZREC_OLD, zi, z.index('\n### 3.5', zi)) == 1
zpairs = [(Z33_OLD, Z33_NEW), (Z34_OLD, Z34_NEW), (ZROW_OLD, ZROW_NEW), (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

# --- write: study, chapter EN and ZH
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + s.rstrip('\n') + '\n', encoding='utf-8')
edit(CH, pairs)
exec((ROOT / f'{RF}/development/rm10-recent/section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
z = (ROOT / ZH).read_text(encoding='utf-8')
zi = z.index('### 3.4')
k = z.index(ZREC_OLD, zi)
z = z[:k] + ZREC_OLD + '[a-formations-own-course](../results/records/a-formations-own-course.md)、' + z[k + len(ZREC_OLD):]
(ROOT / ZH).write_text(z, encoding='utf-8')
edit(ZH, zpairs)
z = (ROOT / ZH).read_text(encoding='utf-8')
BROKEN = '| 核心模块（含根 `Bec| 核心模块（含根 `Becoming`） |'  # an earlier landing's cut left this first cell broken
if BROKEN in z:
    (ROOT / ZH).write_text(z.replace(BROKEN, '| 核心模块（含根 `Becoming`） |'), encoding='utf-8')

# --- the chapter WENLI-AND-BECOMING, through its fragments
W = ZK + '/wenli'
edit(f'{W}/head.fragment', head_pairs(N, SL))
edit(f'{W}/centre.fragment', centre_pairs(N, SL))
subprocess.run([sys.executable, '-I', f'{W}/make_chapter.py'], check=True)
subprocess.run([sys.executable, '-I', f'{ZK}/build_tables.py'], check=True)

# --- the 中华本: a round of exact edits; finish.py (which renders, fills the tables and runs verify_zh.py) runs after the
# records are written, since the edits link the new record
(ROOT / ZK / 'work/round8-edits.json').write_text(json.dumps(round8(N), ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
fin = (ROOT / ZK / 'finish.py').read_text(encoding='utf-8')
if "'work/round8-edits.json'" not in fin:
    old = "'work/round7-edits.json']"
    assert fin.count(old) == 1
    (ROOT / ZK / 'finish.py').write_text(fin.replace(old, "'work/round7-edits.json', 'work/round8-edits.json']"),
                                         encoding='utf-8')

# --- the board
board = (ROOT / BOARD).read_text(encoding='utf-8')
lines = board.split('\n')
k = [i for i, l in enumerate(lines) if l.startswith('| **WL2: ')]
assert len(k) == 1
cells = lines[k[0]].split(' | ')
cells[2] = (f'claimed 2026-10-22 on `dcf2e5175`; landed, core receipt `{receipt_id}`, records the-split-that-makes-sense '
            f'(extended), a-formations-own-course (new), a-code-formed-between-formations (extended), study §{N}')
row = ' | '.join(cells)
del lines[k[0]]
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is WL2's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
landed = (f'WL2 landed (the laws of 文 as theorems: the coarsest value-keeping class as one law, a formation\'s own course, '
          f'the course of forms; core receipt `{receipt_id}`, study §{N}; records the-split-that-makes-sense and '
          'a-code-formed-between-formations extended, a-formations-own-course new; row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + landed + '; ' + m.group(1))
(ROOT / BOARD).write_text(board, encoding='utf-8')
h = (ROOT / HIST).read_text(encoding='utf-8')
anchor = '\n## Lapsed claims (18 October 2026)'
assert h.count(anchor) == 1
i = h.index(anchor)
h = h[:i].rstrip('\n') + '\n' + row + '\n' + h[i:]
(ROOT / HIST).write_text(h, encoding='utf-8')
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
print('STUDY_SLUG', slug)
