#!/usr/bin/env python3
"""AP2 landing text: the study section, the chapter (EN, ZH: section 6.5's order, section 7.3's route through others,
section 7.7, section 8.1 item 7 and section 9's receipt and counts), THE-STEP-OF-INVARIANCE (sections 5, 6.5 and 8) and
the board row moved to the history file with the queue and receipt sentences. Every edit must match exactly once.

usage (from the checkout root to edit): python3 -B apply_text.py RECEIPT CONNECTIVITY_LOG BASE APART_TEXT
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
INV = 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
receipt_id, conn_log, base, apart_note = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]


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
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
core = [m for m in R['modules'] if m['layer'] == 'core']
sp = next(m for m in core if m['module'] == 'Becoming.SelectionPool')
wt = next(m for m in core if m['module'] == 'Becoming.Weightings')
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
apart_text = f'{apart} of {fmt(spine_thms)} apart; {apart_note}; register check passes'
study = (HERE / 'study_ap2.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': sp['theorems'], '{DECLS}': len(sp['declarations']),
             '{WTHEOREMS}': wt['theorems'], '{WDECLS}': len(wt['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-reading-anothers-law-and-lexical-priority-within-the-class-ap2', SLUG
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD73 = ('and reading the dweller\'s separates them (`Clearing.reading_clearer_unselected`, '
         '`Clearing.reading_dweller_selects`).')
NEW73 = (OLD73 + ' Knowing another\'s law is no coupling: every selection through another\'s couplings is one through a '
         'formation\'s own exactly when whatever it couples alike the other does (`Web.anticipates_iff`; where not, some '
         'is not, `Web.anticipation_misses`), and then, under a law reading through the other\'s coupling, the other\'s '
         'acts are fixed by what the formation couples into (`ExchangeLaw.Through.anticipated`); reading its couplings is '
         'that fine (`Web.SelectsThrough.read`).')
OLD77 = ('How a member\'s law comes to be, differences at many conditions at once, and members reading one another\'s '
         'law are open (§8.1); a member reading the levels of what another couples into is pooled with it '
         '(`Flow.withinCoupling_reads_iff`, §7.3).')
NEW77 = ('How a member\'s law comes to be and differences at many conditions at once are open (§8.1). A member reading '
         'the levels of what another couples into is pooled with it (`Flow.withinCoupling_reads_iff`, §7.3), and knowing '
         'the other\'s law adds anticipation exactly where the member couples as finely as the other, never reach '
         '(`Web.anticipates_iff`).')
OLD7a = '(`Flow.withinCoupling_reads_iff`, `Flow.unselected_beyond_reads`). *Open:*'
NEW7a = ('(`Flow.withinCoupling_reads_iff`, `Flow.unselected_beyond_reads`); and (AP2, '
         f'[study §{N}]({SA})) knowing another\'s law adds anticipation exactly where a member couples as finely as the '
         'other, never reach (`Web.anticipates_iff`, `Web.anticipation_misses`, `ExchangeLaw.Through.anticipated`). *Open:*')
OLD7b = 'members reading one another\'s law, beyond the levels of what the other couples into; '
OLD65 = ('additive or not, priority to the worse off included (`Weighting.widens_iff_every_of_class`, '
         '`Weighting.widens_iff_every_score`, `Weighting.increasing_prior`)')
NEW65 = ('additive or not, priority to the worse off and lexical priority included '
         '(`Weighting.widens_iff_every_of_class`, `Weighting.widens_iff_every_score`, `Weighting.increasing_prior`, '
         '`Weighting.increasing_lexical`)')
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with AP2 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_STEPS = re.search(r'The run reused [\d,]+ cached Lean steps from `~/.cache/becoming-lean` and ran \d+;', ch0).group(0)
NEW_STEPS = f'The run reused {fmt(reused)} cached Lean steps from `~/.cache/becoming-lean` and ran {ran};'
edit(CH, [(OLD73, NEW73), (OLD77, NEW77), (OLD7a, NEW7a), (OLD7b, ''), (OLD65, NEW65),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ73 = '即二者闭包之并，在此之外是盲的（`Flow.withinCoupling_reads_iff`、`Flow.unselected_beyond_reads`）。'
NEWZ73 = (OLDZ73 + '知道他者的律不是耦合：经他者耦合的每个选择都经一形成自身的耦合，恰当凡它耦合相同者他者都耦合相同；此时在经他者耦合'
          '读取的律下，他者的动作由该形成所耦合入者决定（`Web.anticipates_iff`、`ExchangeLaw.Through.anticipated`）。')
OLDZ7a = '在二者闭包之并以外是盲的（`Flow.withinCoupling_reads_iff`、`Flow.unselected_beyond_reads`）。'
NEWZ7a = (OLDZ7a[:-1] + f'；以及（AP2，[研究第 {N} 节]({SA})）知道他者的律只在成员耦合得与他者同样细之处加上预见，'
          '从不加上所及（`Web.anticipates_iff`、`ExchangeLaw.Through.anticipated`）。')
OLDZ7b = '成员读取彼此的律（不止后者所耦合入者的水平）；'
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
edit(ZH, [(OLDZ73, NEWZ73), (OLDZ7a, NEWZ7a), (OLDZ7b, ''), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The step-of-invariance chapter.
SAI = SA
edit(INV, [
    ('Where it ranks each widening higher it is increasing in admission, so it is within',
     f'It ranks every widening higher (`Weighting.increasing_lexical`, [study §{N}]({SAI})), so it is within'),
    ('priority to the worse off is one (`Weighting.increasing_prior`).',
     'priority to the worse off is one (`Weighting.increasing_prior`), and so is lexical priority, the basic items first '
     '(`Weighting.increasing_lexical`).'),
    ('`Web.widens_iff_every_of_class`, `Weighting.increasing_prior` | `Becoming.Weightings` | landed |',
     '`Web.widens_iff_every_of_class`, `Weighting.increasing_prior`, `Weighting.increasing_lexical` | '
     '`Becoming.Weightings` | landed |'),
])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY,
                                           'receipt_id': receipt_id, 'N': N})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
