#!/usr/bin/env python3
"""EV6 landing text: the study section, the chapter (EN, ZH: section 2.4, the record table, section 8.1 item 9 and
section 9's receipt, counts and layers), the evolution chapter (its summary, rows 4 and 5, next connection 1), the
coverage file's evolution row, the board row moved to the history file and the queue and receipt sentences. Every edit
must match exactly once.

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
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD, CONT = 'Becoming.GroupEnding', 'Becoming.Continuation'
RID = 'groups-whose-conditions-are-coupled'
EV5RID = 'selection-among-groups-by-ending'
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
cont = next(m for m in core if m['module'] == CONT)
n_mod_thm, n_mod_decl = mod['theorems'], len(mod['declarations'])
n_cont_thm, n_cont_decl = cont['theorems'], len(cont['declarations'])
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
apart_text = f'{apart} of {fmt(spine_thms)} apart, no new apart root; register check passes'
study = (HERE / 'study_ev6.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': n_mod_thm, '{DECLS}': n_mod_decl,
             '{CONT_THEOREMS}': n_cont_thm, '{CONT_DECLS}': n_cont_decl, '{APART}': apart_text,
             '{CORE_LINE}': core_line, '{RID}': RID}.items():
    study = study.replace(k, str(v))
assert '{' not in study.split('```')[1].replace('{N}', ''), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
SLUG = f'{N}-groups-whose-conditions-are-coupled-ev6'
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
EV5REC = f'[{EV5RID}](../results/records/{EV5RID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
i = ch0.index('- `GroupEnding.rises_iff_ended`: selection among groups by ending:')
OLD_AFTER = ch0[i:ch0.index('\n', i) + 1]
NEW_BULLET = (
    "- `Flow.family_excess_ends`, `GroupEnding.Flow.coupled_end_together`: groups whose conditions are coupled. The joint "
    "count and the gated ending hold of a family of conditions read as one: a step at which the family's uptake exceeds its "
    "replenishment lowers its stock by at least one (`Flow.family_excess_bounded`), and where whatever gives to a member "
    "depends on some member at a need of at least m (the coupled gate), n such steps from a stock below n + m end every "
    "formation depending on any member at such a need; the laws of one condition (`Flow.joint_excess_ends` and those it "
    "rests on) are this law for the family of that condition alone. A patch renewed by a neighbour shows no joint excess "
    "read alone and its renewal is not gated on it, while read as one with the neighbour it is gated, in excess, and both "
    "formations end (`Coupled.alone_within`, `Coupled.alone_ungated`, `Coupled.all_end`): the commons test's scope "
    "prediction on the spine. Groups whose members depend on conditions of one such family end together, each leaving no "
    "offspring and nothing selected among them; where the groups with less of an amount depend on such a family they "
    "leave nothing (`GroupEnding.Flow.ended_of_family`). So ending selects among groups only between families.\n")
OLD_RECS = f'{EV5REC}, [transmission'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)  # the section 2.4 list and item 9
i = ch0.index(f'| [Selection among groups by ending](../results/records/{EV5RID}.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROW = (f'| [Groups whose conditions are coupled](../results/records/{RID}.md) | theorem under stated premises | '
           'balance on the family, the coupled gate, family excess from a stock below n + m; only active formations '
           'giving and activity needing support for the global forms; descent for the groups | §2.4 |\n')
i = ch0.index("9. **Evolution's selection term** (further proof).")
OLD9 = ch0[i:ch0.index('\n', i)]
NEW9 = OLD9.replace('where a group\'s own condition ran into joint excess, `Becoming.GroupEnding`.)',
                    'where a group\'s own condition ran into joint excess, `Becoming.GroupEnding`; groups whose conditions are '
                    'coupled ending together, on the family laws of `Becoming.Continuation`.)')
NEW9 = NEW9.replace('groups of unequal size, and groups whose conditions are coupled;',
                    'groups of unequal size, mixing between groups, and how groups and their couplings form;')
NEW9 = NEW9.replace(f'{EV5REC}, [transmission', f'{EV5REC}, {REC}, [transmission')
assert NEW9.count(REC) == 1 and 'coupled ending together' in NEW9 and 'mixing between groups' in NEW9, NEW9[-400:]
ch1 = ch0.replace(OLD9, NEW9)
i = ch1.index('Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
OLD_RECLINE = ch1[i:ch1.index('\n', i)]
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, f'{EV5REC}, {REC}, [transmission')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV6 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
edit(CH, [(OLD_AFTER, OLD_AFTER + NEW_BULLET), (OLD9, NEW9), (OLD_RECLINE, NEW_RECLINE), (OLD_ROW, OLD_ROW + NEW_ROW),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ24 = '`GroupEnding.Flow.all_end`（每个组共享的一个条件终止它们之后，下一代为空，故不提供组间选择）、'
NEWZ24 = (OLDZ24 + '`Flow.family_excess_ends`（读作一体的条件族：族的取用超过其补充的每一步至少使其存量下降一；给予某成员的都以至少 m '
          '的需要依存于某个成员时，自低于 n + m 的存量起 n 步这样的过度，终结以这样的需要依存于任一成员的每个形成；单个条件的定律即只含该条件之族的情形）、'
          '`Coupled.all_end`（由邻居补充的地块单独读出时无联合超出、其更新不以它为门控，与邻居读作一体时两者都终结）、'
          '`GroupEnding.Flow.coupled_end_together`（成员依存于同一个这样的族的各组一同终结，组间无选择；故终止只在族与族之间选择组）、')
i = z.index(f'| [经由终止的组间选择](../results/records/{EV5RID}.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROW = (f'| [条件相互耦合的组](../results/records/{RID}.md) | 在所述前提下的定理 | 族上的平衡、耦合门控、自低于 n + m 的存量起的族过度；'
           '全局形式需只有活跃的形成给予、活动需要支持；组需世系 | §2.4 |\n')
i = z.index('9. **演化的选择项**（进一步的证明）。')
OLDZ9 = z[i:z.index('\n', i)]
NEWZ9 = OLDZ9.replace('由各组自身条件遭遇共同过度的终止所定的组间部分，`Becoming.GroupEnding`。）',
                      '由各组自身条件遭遇共同过度的终止所定的组间部分，`Becoming.GroupEnding`；条件相互耦合的组一同终结，基于 '
                      '`Becoming.Continuation` 的条件族定律。）')
NEWZ9 = NEWZ9.replace('大小不等的组，以及条件相互耦合的组；', '大小不等的组、组间混合，以及组与其耦合如何形成；')
assert '条件相互耦合的组一同终结' in NEWZ9 and '组间混合' in NEWZ9, NEWZ9[:300]
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
OLD_SUM = ('one condition shared by every group ends every group and supplies no selection among them '
           f'({EV5REC}).')
NEW_SUM = (OLD_SUM + ' Groups whose conditions are coupled, renewed across one family of conditions read as one, end '
           'together after the family\'s excess and are not selected among; the excess can show only on the family, a '
           f'patch renewed by its neighbour showing none read alone ({REC}).')
OLD_R4 = f'Groups whose own conditions run into joint excess end, which fixes the among-group part ({EV5REC}).'
NEW_R4 = (OLD_R4 + ' Groups whose conditions are coupled into one family end together, so ending selects among groups only '
          f'between families ({REC}).')
OLD_R5 = ('including joint excess read on one patch failing where a neighbour reseeds and holding for the two read as '
          'one;')
NEW_R5 = ('including joint excess read on one patch failing where a neighbour reseeds and holding for the two read as '
          f'one, now a law and a witness on the spine ({REC});')
evo = (ROOT / EVO).read_text(encoding='utf-8')
i = evo.index('1. **Groups with coupled conditions.**')
OLD_C1 = evo[i:evo.index('\n', i)]
NEW_C1 = ('1. **Mixing between groups, and how groups and their couplings form.** Groups on conditions of their own are on '
          f'the base, ending fixing the among-group part ({EV5REC}), and so are groups whose conditions are coupled: '
          'renewal gated on a family of conditions read as one ends every group depending on the family after its '
          'excess, together, with no selection among them, so ending selects among groups only between families; a '
          'patch reseeded by a neighbour shows no joint excess read alone, as the commons test found '
          f'({REC}). Open are mixing between groups (transmission that is not exact across groups), how groups and their '
          'couplings form, and families read partly: when does selection within groups against keeping a condition lose '
          'to selection among groups for it, once the families themselves change? This is the collective concern of '
          '[§7](THE-THEORY-OF-BECOMING.md#7-ai-对齐--ai-alignment) stated with descent; the commons test\'s negative '
          'verdict (coupling each learner into the stock did not keep it) reads on the spine as groups on one family '
          'ending together.')
edit(EVO, [(OLD_SUM, NEW_SUM), (OLD_R4, NEW_R4), (OLD_R5, NEW_R5), (OLD_C1, NEW_C1)])

# Coverage: the evolution row reads the new record; the general law replaces its one-condition instance.
cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index(EV5RID) + 1, RID)
k = row['declarations'].index('Becoming.GroupEnding.Flow.excess_childless')
row['declarations'][k] = 'Becoming.GroupEnding.Flow.family_childless'
row['declarations'].insert(k + 1, 'Becoming.GroupEnding.Flow.coupled_end_together')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **EV6: groups whose conditions are coupled')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-20, core receipt `{receipt_id}`; {n_cont_thm} theorems in Becoming.Continuation and '
            f'{n_mod_thm} in Becoming.GroupEnding (no new module, rule 9), empty axiom reports; record {RID}; study §{N}')
cells[0] = cells[0].replace('New core module `Becoming.CoupledEnding` on `Becoming.GroupEnding` and `Becoming.Continuation`:',
                            'Claimed as a new module `Becoming.CoupledEnding`; landed with no new module, under rule 9: the '
                            'family laws in `Becoming.Continuation`, its one-condition laws derived from them, and the groups '
                            'in `Becoming.GroupEnding`:')
assert 'landed with no new module' in cells[0], cells[0][:200]
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(20 October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is EV6's `{receipt_id}` (20 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('EV6 ')]
landed = (f'EV6 landed (groups whose conditions are coupled: the family laws in `Becoming.Continuation`, the groups in '
          f'`Becoming.GroupEnding`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
