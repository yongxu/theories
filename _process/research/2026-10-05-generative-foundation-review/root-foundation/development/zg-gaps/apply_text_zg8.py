#!/usr/bin/env python3
"""ZG8 landing text: three study sections, the significance review's gaps check, the chapter (EN: a paragraph in §1.5,
the record table and section 9; ZH: the record table and section 9), the ZH map chapter's §八, and the board (the ZG row
stays open; its state, the queue and the receipt sentence name the landing). Every edit must match exactly once.

usage (from the checkout root): python3 -B apply_text_zg8.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT
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
 ('forming-anew-necessary-and-sufficient', 'Forming anew, necessary and sufficient', '新结之依存，充要', 'theorem under stated premises', 'depending and drawing coinciding at the givers (for the full equivalence)', '有所述前提的定理', '给予者处依存与汲取相合（全等价）', '§8.1'),
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
for k, name in enumerate(('study_zg8.txt',)):
    s = (HERE / name).read_text(encoding='utf-8')
    for a, b in {'{N}': N + k, '{RECEIPT}': receipt_id, '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
        s = s.replace(a, str(b))
    assert not re.search(r'\{[A-Z_]+\}', s) and s.count('```') % 2 == 0
    slugs.append(github_slug(s.split('\n', 1)[0].lstrip('# ').strip()))
    sections.append(s)
SA = [f'{LINK}#{x}' for x in slugs]
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="gaps-check-4"' not in rtext

ch0 = (ROOT / CH).read_text(encoding='utf-8')
anchor = '<a id="2-组织更新与演化--organization-renewal-and-evolution"></a>'
links = ', '.join(f'[{r[0]}](../results/records/{r[0]}.md)' for r in RECS)
para = ('The last note, 唯识「無因」, asked for the law of forming that is necessary as well as sufficient (§8.1, item 9). In '
        'the vocabulary of drawing and depending it is a law: a dependence forms anew at a descent exactly where the '
        'descendant depends on what its giver did not draw on, depending and drawing coinciding at the giver, and the '
        'reading of drawing is inheritance with the givers drawing what they pass on, the necessary half of '
        f'`inherits_of_drawn` (ZG8, [study §{N}]({SA[0]})). No gap note of the map is open [AI reading, D45].\n\n'
        f'Records: {links}.\n\n')
OLD_ROW = line_from(ch0, '| [A source must arrive before the juncture](../results/records/') + '\n'
NEW_ROWS = ''.join(f'| [{r[1]}](../results/records/{r[0]}.md) | {r[3]} | {r[4]} | {r[7]} |\n' for r in RECS)
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with ZG8 in the working tree ([study §{N}]({SA[0]})). It passed, the source unchanged during "
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
         (OLD_STEPS, NEW_STEPS),
         ('*Open:* a law of forming that is necessary as well as sufficient; dependences newly formed by descent;',
          '*Open:* how dependences form at coming to stand where depending and drawing part at the givers (the law of forming, necessary and sufficient in drawing and depending, is stated: a dependence forms anew exactly where the descendant depends on what its giver did not draw on, and the reading of drawing is inheritance with the givers drawing what they pass on, `Web.formsAnew_iff_undrawn`, `Flow.dependsOnDrawn_iff`, ZG8, [forming-anew-necessary-and-sufficient](../results/records/forming-anew-necessary-and-sufficient.md));')]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ = line_from(z, '| [来源须在机前到达](../results/records/') + '\n'
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
zpairs = [(OLDZ, OLDZ + NEWZ), (OLDZR, NEWZR), (OLDZT, NEWZT),
          ('*开放：*既必要又充分的形成之律；', '*开放：*给予者处依存与汲取相分时依存如何在首立时结成（以汲取与依存陈述之充要之形成之律已证：一依存新结恰在后代依于给予者所未汲者之处，汲取之读法恰是因加上给予者汲取其所传，`Becoming.Web.formsAnew_iff_undrawn`、`Becoming.Flow.dependsOnDrawn_iff`，ZG8）；')]

ML = f'../../../{STUDY}'
import json as _json
_m = _json.loads((ROOT / f'{RF}/development/zhonghua/passages.json').read_text(encoding='utf-8'))
_st = {}
for _c in _m['clusters'].values():
    for _e in _c['entries']:
        if _e.get('gap'):
            _st.setdefault(_e['id'], set()).add('done' if _e['gap'].startswith('已补') else 'scope' if _e['gap'].startswith('范围之注') else 'open')
n_all = len(_st)
n_done = sum(1 for v in _st.values() if v == {'done'})
n_scope = sum(1 for v in _st.values() if v == {'scope'})
n_open = sum(1 for v in _st.values() if 'open' in v)
assert n_done + n_scope + n_open == n_all, (n_all, n_done, n_scope, n_open)
ML = f'../../../{STUDY}'
REC = lambda r: f'[{r}](../results/records/{r}.md)'
i8 = (ROOT / MAPCH).read_text(encoding='utf-8')
_k = i8.index(' 个条目写出了一个缺口')
_k0 = i8.rindex('\n', 0, _k) + 1
old_intro = i8[_k0:i8.index('\n', _k)]
new_intro = re.sub(r'^\d+ 个条目', f'{n_all} 个条目', old_intro)
new_intro = new_intro.replace('（WH1、SAT1、ZG1 至 ZG7）', '（WH1、SAT1、ZG1 至 ZG8）')
new_intro = re.sub(r'共 \d+ 个条目改读新律', f'共 {n_done} 个条目改读新律', new_intro)
new_intro = new_intro.replace('）。', f'；[第 {N} 节]({ML}#{slugs[0]})）。', 1)
new_intro = re.sub(r'\d+ 条 gap 注不求律', f'{n_scope} 条 gap 注不求律', new_intro)
assert n_open == 0, n_open
new_intro = re.sub(r'其余 \d+ 条仍开，见第 10 类：', '无一仍开（第 10 类）：', new_intro)
assert new_intro.count('ZG1 至 ZG8') == 1 and f'第 {N} 节' in new_intro and '无一仍开' in new_intro, new_intro[:300]
OLD10 = '仍开者 1 条：依存之结之必要一半（唯识「無因」），即主章 §8.1 第 9 项之开放问题，其 gap 注写明缘故。'
NEW10 = ('依存之结之必要一半（唯识「無因」，主章 §8.1 第 9 项）亦已证（ZG8）：给予者处依存与汲取相合时，一依存在一降中新结，恰在后代依于给予者所未汲者之处'
         '（`Becoming.Web.formsAnew_iff_undrawn`），汲取之读法恰是因加上给予者汲取其所传（`Becoming.Flow.dependsOnDrawn_iff`，'
         + REC('forming-anew-necessary-and-sufficient') + '）。')
mpairs = [(old_intro, new_intro), (OLD10, NEW10)]
ZHMAIN = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH), ((ROOT / MAPCH).read_text(encoding='utf-8'), mpairs, MAPCH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + '\n\n'.join(s.rstrip('\n') for s in sections) + '\n', encoding='utf-8')
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_zg8.txt').read_text(encoding='utf-8').rstrip('\n') + '\n',
                           encoding='utf-8')
edit(CH, pairs)
exec((ROOT / f'{RF}/development/rm10-recent/section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)
edit(MAPCH, mpairs)

board = (ROOT / BOARD).read_text(encoding='utf-8')
lines = board.split('\n')
k = [i for i, l in enumerate(lines) if l.startswith('| **ZG8: ')]
assert len(k) == 1
cells = lines[k[0]].split(' | ')
cells[2] = (f'claimed 2026-10-22 on `da4b79235`; landed, core receipt `{receipt_id}`, record forming-anew-necessary-and-sufficient, '
            f'study §{N}; no gap note of the ZH map is open')
row = ' | '.join(cells)
del lines[k[0]]
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is ZG8's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
q = m.group(1)
old = re.search(r'ZG landed \([^()]*\)(; )?', q)
assert old
q = q.replace(old.group(0), '')
landed = (f'ZG and ZG8 landed (the ZH gaps, in four runs, thirty-six records; core receipts `20261022T054058.112616Z`, '
          f'`20261022T060905.150236Z`, `20261022T064310.304329Z` and `{receipt_id}`, study §338-§{N}; no gap note open; rows in '
          'the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed, q]))
(ROOT / BOARD).write_text(board, encoding='utf-8')
HIST = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
h = (ROOT / HIST).read_text(encoding='utf-8')
anchor = '\n## Lapsed claims (18 October 2026)'
assert h.count(anchor) == 1
i = h.index(anchor)
h = h[:i].rstrip('\n') + '\n' + row + '\n' + h[i:]
(ROOT / HIST).write_text(h, encoding='utf-8')
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
