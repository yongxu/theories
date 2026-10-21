#!/usr/bin/env python3
"""RM10 landing text: the study section, the significance review's recent check, the chapter (EN: the coupled-web
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
RID = 'webs-with-a-recent-giving'
RM9 = 'thresholds-beyond-a-band'
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SA327 = f'{STUDY_LINK}#327-thresholds-beyond-a-band-a-bound-on-the-run-in-its-place-rm9'
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
removed = old_names - new_names
assert not removed, removed
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart, unchanged; no new apart root, every new law stated on a run of the web or '
              'read by a law that is, the witness on the run; register check passes')
study = (HERE / 'study_rm10.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{DECLS}': d_new, '{REMOVED}': len(removed), '{REMOVED_THMS}': removed_thms, '{THEOREMS}': n_new,
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
assert study.count('```') % 2 == 0
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-webs-with-a-recent-giving-rm10', SLUG
SA = f'{STUDY_LINK}#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
rtext = (ROOT / REVIEW).read_text(encoding='utf-8')
assert 'id="recent-check"' not in rtext

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD23 = f'(RM9, [study §327]({SA327}), [{RM9}](../results/records/{RM9}.md)).'
NEW23 = (OLD23 + ' These laws hold for any law of states read condition by condition, a law keeping the order of states '
         'so reading them, and so for a web with a recent giving, each condition holding its level and what it gave last, '
         'its giving a law of what is left of all and what each gave: under mutual support it keeps the order, so its '
         'bounded runs have ending decided and each threshold, given the other levels and every recent giving, exact and '
         'not rising as any of them rises; the plain web and the adjusted regime are its cases, and a giving ramping with '
         'what was given has its threshold fall from four to three as its last giving rises '
         '(`RegimeMargin.Coupled.Indexed.Recent.keepsBelow`, `RegimeMargin.Coupled.Indexed.Recent.plain`, '
         '`RegimeMargin.Coupled.Indexed.Recent.adjusted`, `RegimeMargin.Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent`) '
         f'(RM10, [study §{N}]({SA}), {REC}).')
OLDT1 = (f'`RegimeMargin.Coupled.Indexed.threshold_falls_within`, RM9, [study §327]({SA327})). That actual conditions '
         'with a need meet these premises')
NEWT1 = (f'`RegimeMargin.Coupled.Indexed.threshold_falls_within`, RM9, [study §327]({SA327})), and where each condition\'s '
         'giving reads what it gave last, what it gave is part of its state and can lower its threshold '
         f'(`RegimeMargin.Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent`, RM10, [study §{N}]({SA})). That '
         'actual conditions with a need meet these premises')
OLD_ROW = line_from(ch0, f'| [Thresholds beyond a band](../results/records/{RM9}.md) |') + '\n'
NEW_ROW = (f'| [Webs with a recent giving](../results/records/{RID}.md) | theorem under stated premises | whole numbers; '
           'finitely many conditions listed by a covering list; draws taken first; each giving a law of what is left of all '
           'and what each gave last, rising with each; a bound on the run from the top level | §2.3, T1 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with RM10 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLDZT1 = f'RM9，[研究第 327 节]({SA327})）。实际有需要的条件满足这些前提'
NEWZT1 = (f'RM9，[研究第 327 节]({SA327})）。各条件的所给读取其上次所给时，所给成为其状态的一部分，并可降低其阈值'
          f'（`RegimeMargin.Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent`，RM10，[研究第 {N} 节]({SA})）。实际有需要的条件满足这些前提')
OLDZROW = line_from(z, f'| [带外的阈值](../results/records/{RM9}.md) |') + '\n'
NEWZROW = (f'| [带近来所给的网](../results/records/{RID}.md) | 有所述前提的定理 | 整数；由覆盖列表列出的有限多个条件；汲取先取；各所给是所有所余与各自上次所给之律，'
           '随每个上升；自顶水平的运行之界 | §2.3、T1 |\n')
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
(ROOT / REVIEW).write_text(rtext.rstrip('\n') + '\n\n' + (HERE / 'check_rm10.txt').read_text(encoding='utf-8').rstrip('\n')
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
