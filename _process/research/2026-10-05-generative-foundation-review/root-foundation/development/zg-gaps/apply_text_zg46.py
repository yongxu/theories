#!/usr/bin/env python3
"""ZG4-ZG6 landing text: three study sections, the significance review's gaps check, the chapter (EN: a paragraph in §1.5,
the record table and section 9; ZH: the record table and section 9), the ZH map chapter's §八, and the board (the ZG row
stays open; its state, the queue and the receipt sentence name the landing). Every edit must match exactly once.

usage (from the checkout root): python3 -B apply_text_zg46.py RECEIPT CONNECTIVITY_LOG BASE PREVIOUS_RECEIPT
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
 ('copied-witnesses-change-nothing', 'Copied witnesses change nothing', '抄录之见证不改任何检查', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('synonyms-and-coined-forms', 'Synonyms and coined forms', '同义之名与造出之形', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('taking-what-most-hold', 'Taking what most hold', '从众', 'theorem without premise and witnesses', '—', '不加前提的定理与见证', '—', '§1.5'),
 ('imposing-a-code-breaks-the-symmetry', 'Imposing a code breaks the symmetry of forms', '施加之码打破形式之对称', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('the-move-alone-underdetermines', 'The move alone does not fix the outcome', '动作本身不定结果', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('reaching-before-and-after-a-juncture', 'Reaching before and after a juncture', '机前与机后之可得', 'theorem without premise', '— (every configuration listed for the bound)', '不加前提的定理', '—（界须构形列尽）', '§1.5'),
 ('reading-through-a-pool', 'Reading through a pool', '经池读取', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('division-by-exclusive-footprints', 'Division by exclusive footprints', '以互斥之足迹分', 'theorem under stated premises', 'a realized joint plan; balance for the level', '有所述前提的定理', '实现之联合计划；水平之律须衡', '§1.5'),
 ('support-passed-on', 'Support passed on by later gainers', '支持由后得者传下', 'theorem under stated premises', 'balance, dependence, bounded support spells', '有所述前提的定理', '衡、依存、受支持之步数有界', '§1.5'),
 ('censuses-of-the-xiang-and-tuan', 'Censuses of the 象 and 彖 against the places', '象、彖之句对位之普查', 'census', 'the sentence lists from the texts', '普查', '取自文本之句表', '§1.5'),
 ('bands-of-the-three-powers', 'Bands of the three powers and heights', '三才之带与高度', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
 ('one-search-one-line', 'One search, one line', '一索一线', 'theorem without premise', '—', '不加前提的定理', '—', '§1.5'),
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
for k, name in enumerate(('study_zg4.txt', 'study_zg5.txt', 'study_zg6.txt')):
    s = (HERE / name).read_text(encoding='utf-8')
    for a, b in {'{N}': N + k, '{RECEIPT}': receipt_id, '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
        s = s.replace(a, str(b))
    assert not re.search(r'\{[A-Z_]+\}', s) and s.count('```') % 2 == 0
    slugs.append(github_slug(s.split('\n', 1)[0].lstrip('# ').strip()))
    sections.append(s)
SA = [f'{LINK}#{x}' for x in slugs]
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="gaps-check-2"' not in rtext

ch0 = (ROOT / CH).read_text(encoding='utf-8')
anchor = '<a id="2-组织更新与演化--organization-renewal-and-evolution"></a>'
links = ', '.join(f'[{r[0]}](../results/records/{r[0]}.md)' for r in RECS)
para = ('A second set of the structures the 脉络 asked for are now laws: copied witnesses change nothing, synonyms and '
        'coined forms, taking what most hold and imposing a code, and the move alone not fixing the outcome (ZG4); reaching '
        'before and after a juncture, reading through a pool, division by exclusive footprints and support passed on by '
        f'later gainers (ZG5); the censuses of the 象 and 彖, the bands of the three powers and one search one line (ZG6) '
        f'([study §{N}]({SA[0]}), [§{N + 1}]({SA[1]}), [§{N + 2}]({SA[2]})). Gap notes that ask for no law are marked as '
        'scope remarks in the map [AI reading, D45].\n\n'
        f'Records: {links}.\n\n')
OLD_ROW = line_from(ch0, '| [Basins of a determined law](../results/records/') + '\n'
NEW_ROWS = ''.join(f'| [{r[1]}](../results/records/{r[0]}.md) | {r[3]} | {r[4]} | {r[7]} |\n' for r in RECS)
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with ZG4-ZG6 in the working tree ([study §{N}]({SA[0]})). It passed, the source unchanged during "
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
OLDZ = line_from(z, '| [确定之律之势](../results/records/') + '\n'
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
old_intro = i8[i8.index('61 个条目写出了一个缺口'):i8.index('\n', i8.index('61 个条目写出了一个缺口'))]
new_intro = (f'{n_all} 个条目写出了一个缺口：原文说了一种结构，脊柱还没有它的律。去掉重复，主要有以下几类。第 1 至 9 类已证（WH1、SAT1、ZG1 至 ZG6）；'
             f'连同其余有精确陈述者，共 {n_done} 个条目改读新律，其 `gap` 注以「已补」起首、指向新律'
             + old_intro[old_intro.index('（[研究第 338 节]'):old_intro.rindex('）')]
             + f'；[第 {N} 节]({ML}#{slugs[0]})、[第 {N + 1} 节]({ML}#{slugs[1]})、[第 {N + 2} 节]({ML}#{slugs[2]})）。'
             f'{n_scope} 条 gap 注不求律（读法、范围或比较之承诺），标为「范围之注」，原注保留；其余 {n_open} 条仍开，列为第 10 类：')
mpairs = [
 (old_intro, new_intro),
 ('一个见证者的报告若是另一个的函数，且与之在同样的情形下出错，加入它不改变任何检查。',
  '一个见证者的报告若是另一个的函数，且与之在同样的情形下出错，加入它不改变任何检查。已证（`Becoming.WitnessRefinementRuns.copied_witnesses_same`、'
  '`Becoming.FaultEnvelopes.copied_roster_same`；ZG4，' + REC('copied-witnesses-change-nothing') + '）。'),
 ('入势之深、从机到所至的步数，以及机前保住所需之较少。',
  '入势之深、从机到所至的步数，以及机前保住所需之较少。已证：入复返之域在构形数之内（`Becoming.Law.enters_returning_within`），可得者在构形数之内得之，'
  '机前无须择步（`Becoming.Branching.reach_within_listed`、`Becoming.Branching.keeps_before_juncture`；ZG5，' + REC('reaching-before-and-after-a-juncture')
  + '）；机可延之步数一般无界，因回环可无尽地保住可得。'),
 ('以及读取与兼感合一之律（荀子“兼听而时稽之”）。',
  '以及读取与兼感合一之律（荀子“兼听而时稽之”）。后者已证（`Becoming.Pace.rule_through_pool`；ZG5，' + REC('reading-through-a-pool') + '）；'
  '读多于两码之从众已证（`Becoming.SharedCodes.majority_held`、`Becoming.SharedCodes.Majority.odd_agrees`；ZG4，' + REC('taking-what-most-hold') + '）；'
  '按份额加权之池之选择仍开（第 10 类）。'),
 ('小象言“中”、言“穷”、言“承”之句，三才之带与高度之别。',
  '小象言“中”、言“穷”、言“承”之句，三才之带与高度之别。已证（`Becoming.Hexagram.xiaoxiangMiddle_census`、`Becoming.Hexagram.exhausted_census`、'
  '`Becoming.Hexagram.riseStatements_agree`、`Becoming.Hexagram.bands_and_heights`、`Becoming.Hexagram.Trigram.sole_iff_searched`；ZG6，'
  + REC('censuses-of-the-xiang-and-tuan') + '、' + REC('bands-of-the-three-powers') + '、' + REC('one-search-one-line') + '）。\n'
  '10. **仍开者。** 按份额加权之池（吴子「群臣莫及」、韩非三守）；池作读取而规则不锁定之条件（韩非二柄）；两条规则之积之锁定（庄子胠箧）；'
  '介入与截断所失（老子七十九章）；目标沿世系之递下（中庸）；依存之结之必要一半（唯识，主章 §8.1 第 9 项）；按闭包层级分级之序（孟子「亲亲而仁民」）；'
  '按步之资域（经说「爱民」）；施加之损与自承之损（墨经大取）；至期所及与机（老子「为之于未有」两条）。'),
]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH), ((ROOT / MAPCH).read_text(encoding='utf-8'), mpairs, MAPCH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + '\n\n'.join(s.rstrip('\n') for s in sections) + '\n', encoding='utf-8')
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_zg46.txt').read_text(encoding='utf-8').rstrip('\n') + '\n',
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
cells[2] = (f'claimed 2026-10-22 on `6eab1e8d6`; ZG1-ZG3 landed, core receipt `20261022T054058.112616Z`, sixteen records new, '
            f'25 ZH map entries read the new laws, study §338-§340; ZG4-ZG6 landed, core receipt `{receipt_id}`, twelve records new, '
            f'21 entries read the new laws and 13 gap notes are marked as scope remarks, study §{N}-§{N + 2}; {n_open} entries open (ZG7)')
lines[k[0]] = ' | '.join(cells)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is ZG4-ZG6's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
q = m.group(1)
old13 = re.search(r'ZG1-ZG3 landed \([^()]*\)(; )?', q)
assert old13, 'ZG1-ZG3 queue entry'
parts = [q.replace(old13.group(0), '')]
landed = (f'ZG4-ZG6 landed (the ZH gaps: copied witnesses, synonyms, coined forms, majority and imposing, the move alone, '
          f'junctures within the count, reading through a pool, division by exclusive footprints, support passed on, the '
          f'censuses of the Changes; twelve records; 13 gap notes marked as scope remarks; core receipt `{receipt_id}`, '
          f'study §{N}-§{N + 2}; ZG row open for ZG7, {n_open} entries); ZG1-ZG3 landed (sixteen records; core receipt '
          f'`20261022T054058.112616Z`, study §338-§340)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
