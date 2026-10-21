#!/usr/bin/env python3
"""RM8 landing text: the study section, the significance review's web-rest check, the chapter (EN: the coupled-web
paragraph, thesis T1's sentence, the record table and section 9's receipt, counts and audit sentence; ZH: T1's sentence,
the record table and section 9) and the board row
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
MOD = 'Becoming.RegimeMargin'
RID = 'rest-on-coupled-webs'
RM7 = 'coupled-webs'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA311 = f'{STUDY_LINK}#311-coupled-webs-support-across-a-web-and-the-cascade-of-ends-rm7'
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
om = next(m for m in R['modules'] if m['module'] == MOD)
pm = next(m for m in P['modules'] if m['module'] == MOD)
old_names = {d['name'] for d in pm['declarations']}
new_names = {d['name'] for d in om['declarations']}
GONE = {f'Becoming.RegimeMargin.Coupled.{n}' for n in ['within_draw', 'run_within', 'left_falls', 'still_of_left', 'step_of_left']}
removed = old_names - new_names
assert removed == GONE, removed ^ GONE
new_decls = [d for d in om['declarations'] if d['name'] not in old_names]
d_new = len(new_decls)
n_new = sum(d['kind'] == 'theorem' for d in new_decls)
removed_thms = sum(d['kind'] == 'theorem' for d in pm['declarations'] if d['name'] in removed)
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on the web or read '
              'by a law that is, the pair\'s laws derived from the web\'s and the pair-only helpers no law reads removed; '
              'register check passes')
study = (HERE / 'study_rm8.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{DECLS}': d_new, '{REMOVED}': len(removed), '{REMOVED_THMS}': removed_thms, '{THEOREMS}': n_new,
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
assert study.count('```') % 2 == 0
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-rest-and-points-of-no-return-on-coupled-webs-rm8', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="web-rest-check"' not in rtext

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD23 = f'(RM7, [study §311]({SA311}), [coupled webs](../results/records/{RM7}.md)).'
NEW23 = (OLD23 + ' For finitely many conditions within a band, stated condition by condition, which needs no equality of '
         'functions since monotone giving respects what is left condition by condition, every run comes to rest within '
         'the conditions\' count times the band with one step, whether a condition ends is decided there, and each '
         'condition\'s point of no return, given the other levels, is a least level, exact, that does not rise as any other '
         'level rises (`RegimeMargin.Coupled.Indexed.comes_to_rest`, `RegimeMargin.Coupled.Indexed.ends_iff_below`, '
         '`RegimeMargin.Coupled.Indexed.threshold_falls`); the pair\'s rest and thresholds are these laws read for two '
         f'(`RegimeMargin.Coupled.threshold_pair`) (RM8, [study §{N}]({SA}), {REC}).')
OLDT1 = (f'`RegimeMargin.Coupled.Indexed.ends_downstream`, RM7, [study §311]({SA311})). That actual conditions with a '
         'need meet these premises')
NEWT1 = (f'`RegimeMargin.Coupled.Indexed.ends_downstream`, RM7, [study §311]({SA311})). In a finite web within a band, each '
         'condition\'s point of no return does not rise as any other level rises (`RegimeMargin.Coupled.Indexed.threshold_falls`, '
         f'RM8, [study §{N}]({SA})). That actual conditions with a need meet these premises')
OLD_ROW = line_from(ch0, f'| [Coupled webs](../results/records/{RM7}.md) |') + '\n'
NEW_ROW = (f'| [Rest on coupled webs](../results/records/{RID}.md) | theorem under stated premises | whole numbers; finitely '
           'many conditions listed by a covering list; draws taken first; each giving a law of what is left of all, rising with '
           'each; a band the step keeps | §2.3, T1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with RM8 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD23, NEW23), (OLDT1, NEWT1),
         (OLD_ROW, OLD_ROW + NEW_ROW), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZT1 = f'（`RegimeMargin.Coupled.Indexed.ends_downstream`，RM7，[研究第 311 节]({SA311})）。实际有需要的条件满足这些前提'
NEWZT1 = (f'（`RegimeMargin.Coupled.Indexed.ends_downstream`，RM7，[研究第 311 节]({SA311})）。在带内的有限之网中，每个条件的不可回返点不随任何其他水平上升而上升'
          f'（`RegimeMargin.Coupled.Indexed.threshold_falls`，RM8，[研究第 {N} 节]({SA})）。实际有需要的条件满足这些前提')
OLDZROW = line_from(z, f'| [耦合之网](../results/records/{RM7}.md) |') + '\n'
NEWZROW = (f'| [耦合之网的静止](../results/records/{RID}.md) | 有所述前提的定理 | 整数；由覆盖列表列出的有限多个条件；汲取先取；各所给是所有所余之律且随每个上升；'
           '步保持的带 | §2.3、T1 |\n')
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
zpairs = [(OLDZT1, NEWZT1),
          (OLDZROW, OLDZROW + NEWZROW), (OLDZR, NEWZR), (OLDZT, NEWZT)]
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_rm8.txt').read_text(encoding='utf-8').rstrip('\n')
                           + '\n', encoding='utf-8')
print('appended', REVIEW)
edit(CH, pairs)
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': n_new, 'd_new': d_new})
print('new declarations', d_new, 'new theorems', n_new, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
