#!/usr/bin/env python3
"""WH1 and SAT1 landing text: the two study sections, the significance review's two checks, the chapter (EN: a
paragraph on the wholes in §2.2 and a law of the line in §2.6 with their records, the record table and section 9's
receipt, counts and audit sentence; ZH: the record table and section 9), the ZH map chapter's §八, and the board rows
moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT
Prints the two study section numbers."""
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
MAPCH = 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
RID_W = 'a-whole-of-every-part'
RID_S = 'a-coupling-saturated-by-what-it-has-carried'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
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
counts = {}
for mod in ('Becoming.Wholes', 'Becoming.Frequency'):
    om = next(m for m in R['modules'] if m['module'] == mod)
    pm = next(m for m in P['modules'] if m['module'] == mod)
    old_names = {d['name'] for d in pm['declarations']}
    new_names = {d['name'] for d in om['declarations']}
    assert not (old_names - new_names), old_names - new_names
    new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
    counts[mod] = (len(new_decls), sum(d['kind'] == 'theorem' for d in new_decls))
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

# Study sections: after the last.
stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'Core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = (f'{apart} of {fmt(spine_thms)} apart; no new apart root, every new law stated on a web or a carrying law '
              'read on one, the witnesses on webs; register check passes')
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug  # noqa: E402
sections, slugs = [], {}
for n, name, mod, expect in ((N, 'study_wh1.txt', 'Becoming.Wholes', 'a-whole-of-every-part-and-a-graded-whole-wh1'),
                             (N + 1, 'study_sat1.txt', 'Becoming.Frequency',
                              'a-coupling-saturated-by-what-it-has-carried-sat1')):
    s = (HERE / name).read_text(encoding='utf-8')
    for k, v in {'{N}': n, '{RECEIPT}': receipt_id, '{DECLS}': counts[mod][0], '{THEOREMS}': counts[mod][1],
                 '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
        s = s.replace(k, str(v))
    assert not re.search(r'\{[A-Z_]+\}', s), 'placeholder left'
    assert s.count('```') % 2 == 0
    slug = github_slug(s.split('\n', 1)[0].lstrip('# ').strip())
    assert slug == f'{n}-{expect}', slug
    slugs[mod] = f'{STUDY_LINK}#{slug}'
    sections.append(s)
SW, SS = slugs['Becoming.Wholes'], slugs['Becoming.Frequency']
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="wholes-check"' not in rtext and 'id="saturation-check"' not in rtext
RW = f'[{RID_W}](../results/records/{RID_W}.md)'
RS = f'[{RID_S}](../results/records/{RID_S}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD22 = '*Readings* [AI reading, D3, D4, D6].'
NEW22 = ('*Wholes of some part and of every part* (`Becoming.Wholes`). The whole of §2.3 is active while some part is '
         '(`Web.Whole`). A whole active while every part is (`Web.AllWhole`) ends as soon as one part ends, with no '
         'listing and nothing of arising (`Web.AllWhole.ends_of_part`), and persists exactly while every part does '
         '(`Web.AllWhole.persists_iff`); the two wholes of the same parts coincide exactly where the parts are in step '
         '(`Web.Whole.same_iff_inStep`). Between them lies the grade, how many listed parts are active, a count that exists '
         'exactly where their activity is decided (`Web.Grade`): across a step it gains what arises and loses what ceases '
         '(`Web.Grade.across_step`), so a whole active while at least `j` parts are arises and ceases only through a part '
         '(`Web.AtLeastWhole.arises_part`, `Web.AtLeastWhole.ceases_part`), and where some parts are active and not all '
         'the whole is diminished (`Web.diminished_iff`). 华严\'s 「去却椽即無舍」 is read as the whole of every rafter, and '
         '「破舍」 with 墨经\'s 「謂其存者損」 as the diminished whole [AI reading, D45; WH1, '
         f'[study §{N}]({SW}), {RW}].\n\n' + OLD22)
OLD26 = line_from(ch0, '- `runaway_of_roundTrip` with `Frequency.Sparse.polynomial`:') + '\n'
NEW26 = OLD26 + ('- `Saturation.stops` with `Saturation.stops_iff`: strengths read off what has passed through each coupling '
                 'read the levels before (`Saturation.readsBefore`), and what passes is what the formed course carries through '
                 'the coupling (`Saturation.course_succ`). Where the strengths are zero once `A` has passed and `A` has '
                 'passed by step `N`, the coupling stops by `N`, nothing more passes and, every coupling so saturated, a '
                 'finite order is exact (`Saturation.passed_from`, `Saturation.exact`); a coupling acting at each step until '
                 'saturated, from a level that stands, stops by step `A` (`Saturation.stops_by`). With a response not '
                 'rising as more passes, it stops exactly where the response reaches zero; floored at one it recurs and, '
                 'coupled into itself, leaves every finite order inexact (`Saturation.floored`, '
                 '`Saturation.floored_inexact`). 老子\'s 「民不畏威」 and 韩非\'s 「視強，則目不明」 are read as such a coupling '
                 f'worn to zero [AI reading, D45; SAT1, [study §{N + 1}]({SS}), {RS}].\n')
OLDR22 = '[whole-persists-through-generation](../results/records/whole-persists-through-generation.md)'
NEWR22 = OLDR22 + f', {RW}'
OLDR26 = '[how-often-couplings-act](../results/records/how-often-couplings-act.md)'
NEWR26 = OLDR26 + f', {RS}'
OLD_ROW_W = line_from(ch0, '| [A whole persists through the generation of its parts](../results/records/'
                           'whole-persists-through-generation.md) |') + '\n'
NEW_ROW_W = (f'| [A whole of every part, and a graded whole](../results/records/{RID_W}.md) | theorem without premise | '
             '— | §2.2 |\n')
OLD_ROW_S = line_from(ch0, '| [How often couplings act: settling, runaway and its rate](../results/records/'
                           'how-often-couplings-act.md) |') + '\n'
NEW_ROW_S = (f'| [A coupling saturated by what it has carried](../results/records/{RID_S}.md) | theorem under stated '
             'premises | strengths read off what has passed, the response given; for stopping by the threshold, a coupling '
             'acting at each step until saturated and a level that stands | §2.6 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with WH1 and SAT1 in the working tree ([study §{N}]({SW}), [§{N + 1}]({SS})). It passed, the "
               "source unchanged during the check and the core with the ring compiled from the prelude.")
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
pairs = [(OLD22, NEW22), (OLD26, NEW26), (OLDR22, NEWR22), (OLDR26, NEWR26),
         (OLD_ROW_W, OLD_ROW_W + NEW_ROW_W), (OLD_ROW_S, OLD_ROW_S + NEW_ROW_S),
         (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZW = line_from(z, '| [整体经由部分的生成而持续](../results/records/whole-persists-through-generation.md) |') + '\n'
NEWZW = f'| [每个部分之整体与分级之整体](../results/records/{RID_W}.md) | 不加前提的定理 | — | §2.2 |\n'
OLDZS = line_from(z, '| [耦合多常作用：安定、失控与其速度](../results/records/how-often-couplings-act.md) |') + '\n'
NEWZS = (f'| [为所传之量所饱和的耦合](../results/records/{RID_S}.md) | 有所述前提的定理 | 强度读自已传之量，响应给定；'
         '至阈值之步停止，须未饱和时每步作用、源之水平常在 | §2.6 |\n')
OLDZR = line_from(z, '**当前回执**是运行 [`')
NEWZR = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
         f"（[当前指针](../../../{PKG}/becoming-verification.json)），以 Lean 4.29.1 检查（[研究第 {N} 节]({SW})、"
         f"[第 {N + 1} 节]({SS})）。")
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
zpairs = [(OLDZW, OLDZW + NEWZW), (OLDZS, OLDZS + NEWZS), (OLDZR, NEWZR), (OLDZT, NEWZT)]

# The ZH map chapter, §八.
MSL = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
mpairs = [
    ('61 个条目写出了一个缺口：原文说了一种结构，脊柱还没有它的律。去掉重复，主要有以下几类：',
     '61 个条目写出了一个缺口：原文说了一种结构，脊柱还没有它的律。去掉重复，主要有以下几类。前两类已证（WH1、SAT1），'
     '述及它们的 5 个条目改读新律，其 `gap` 注指向新律：'),
    ('都说缺一部分时整体不成，或成为减损的整体。脊柱的整体（`Becoming.Web.Whole`）是析取的：某部分活跃，整体就活跃。',
     '都说缺一部分时整体不成，或成为减损的整体。脊柱原有的整体（`Becoming.Web.Whole`）是析取的：某部分活跃，整体就活跃。'
     '已证：每个部分之整体（`Becoming.Web.AllWhole`）一个部分终结即终结，所列部分之等级（`Becoming.Web.Grade`）跨一步增其生起者、减其止息者，'
     '减损之整体恰是某部分之整体活跃而每个部分之整体不活跃（`Becoming.Web.diminished_iff`）'
     f'（WH1，[研究第 {N} 节]({MSL}#{slugs["Becoming.Wholes"].split("#")[1]})，'
     f'[{RID_W}](../results/records/{RID_W}.md)）。'),
    ('2. **饱和之律。** 老子七十二章“民不畏威”：耦合的强度随已经传过的量而降。',
     '2. **饱和之律。** 老子七十二章“民不畏威”：耦合的强度随已经传过的量而降。已证：强度读自经耦合已传之量时，强度归零则耦合停止'
     '（`Becoming.Saturation.stops`），恰在响应归零处停止，以一为下限则复现（`Becoming.Saturation.stops_iff`、`Becoming.Saturation.floored`）'
     f'（SAT1，[研究第 {N + 1} 节]({MSL}#{slugs["Becoming.Frequency"].split("#")[1]})，'
     f'[{RID_S}](../results/records/{RID_S}.md)）。'),
]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH), ((ROOT / MAPCH).read_text(encoding='utf-8'), mpairs, MAPCH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + '\n\n'.join(s.rstrip('\n') for s in sections) + '\n',
                          encoding='utf-8')
print('appended', STUDY, 'sections', N, N + 1)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_wh1_sat1.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)
edit(CH, pairs)
exec((ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rm10-recent/'
      'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)
edit(MAPCH, mpairs)

# Board: the rows move to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
for item, rid, mod, n in (('WH1', RID_W, 'Becoming.Wholes', N), ('SAT1', RID_S, 'Becoming.Frequency', N + 1)):
    rows = [i for i, line in enumerate(lines) if line.startswith(f'| **{item}: ')]
    assert len(rows) == 1, rows
    row = lines.pop(rows[0])
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    d_new, n_new = counts[mod]
    cells[2] = (f'landed 2026-10-22, core receipt `{receipt_id}`; as claimed; new laws of {mod}, {d_new} declarations '
                f'added, {n_new} of them theorems, none removed, empty axiom reports; record {rid} new; ZH map entries read '
                f'the new laws; study §{n}')
    row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
    lastrow += 1
    hist.insert(lastrow, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is WH1 and SAT1's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith(('WH1 ', 'SAT1 '))]
landed = (f'WH1 and SAT1 landed (ZH gaps: a whole of every part, the grade of listed parts and the diminished whole, new '
          f'laws of `Becoming.Wholes`; a coupling saturated by what it has carried, stopping where its strength reaches '
          f'zero, new laws of `Becoming.Frequency`; the five ZH map entries read the new laws; core receipt `{receipt_id}`, '
          f'study §{N} and §{N + 1}, rows in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board rows moved; receipt', receipt_id)
for mod, (d_new, n_new) in counts.items():
    print(mod, 'new declarations', d_new, 'new theorems', n_new)
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTIONS', N, N + 1)
