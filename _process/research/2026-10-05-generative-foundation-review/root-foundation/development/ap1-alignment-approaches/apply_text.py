#!/usr/bin/env python3
"""AP1 landing text: the study section, the chapter (EN, ZH: section 7.3's route through others, section 7.4's known
approaches, section 7.7, section 8.1 item 7, the record table and section 9's receipt and counts) and the board row moved
to the history file with the queue and receipt sentences. Every edit must match exactly once.

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
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MOD = 'Becoming.SelectionPool'
RID = 'reading-anothers-couplings-is-pooling'
AID = 'alignment-approaches-under-the-selection-laws'
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
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
core = [m for m in R['modules'] if m['layer'] == 'core']
sp = next(m for m in core if m['module'] == MOD)
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
apart_text = (f'{apart} of {fmt(spine_thms)} apart; four new apart roots in Becoming.Weightings registered as general '
              'structure (Weighting.mixed_either_way and prior_lt_of_widens, registered before, now lie under them), none '
              'in Becoming.SelectionPool; register check passes')
study = (HERE / 'study_ap1.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{THEOREMS}': sp['theorems'], '{DECLS}': len(sp['declarations']),
             '{WTHEOREMS}': wt['theorems'], '{WDECLS}': len(wt['declarations']),
             '{APART}': apart_text, '{CORE_LINE}': core_line}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_]+\}', study), 'placeholder left'
(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG == f'{N}-alignment-approaches-under-the-selection-laws-ap1', SLUG
SA = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
REC = f'[{RID}](../results/records/{RID}.md)'
AREC = f'[{AID}](../results/records/{AID}.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD73 = ('everything beyond it is selected alike by every group within it (`Flow.unselected_beyond_pool`); lying within '
         'the closure does not make a difference separated (`Clearing.within_closure_unseparated`).\n')
NEW73 = ('everything beyond it is selected alike by every group within it (`Flow.unselected_beyond_pool`); lying within '
         'the closure does not make a difference separated (`Clearing.within_closure_unseparated`). Reading another\'s '
         'couplings is pooling with it: a formation coupled by level into everything another couples into selects '
         'through at least their pooled coupling (`Web.SelectsThroughAll.reads`), and its coupling closure is the '
         'pool\'s where the other exchanges with a condition coupled into it (`Flow.withinCoupling_reads_iff`), so it '
         'is blind beyond the union of the two closures (`Flow.unselected_beyond_reads`, `Flow.act_unselected_reads`). '
         'In `Clearing`, reading the clearer\'s couplings leaves the cleared and the spared world alike, and reading the '
         'dweller\'s separates them (`Clearing.reading_clearer_unselected`, `Clearing.reading_dweller_selects`).\n')
OLD73R = ('Records: [what-pooled-coupling-reaches](../results/records/what-pooled-coupling-reaches.md), '
          '[observation-is-a-route](../results/records/observation-is-a-route.md).\n')
NEW73R = OLD73R[:-2] + f', {REC}.\n'
OLD74 = ('`universal_reason` addresses reasons to every intelligence, AI included, under its premises (§6.2); '
         'understanding a reason is not complying with it.\n')
NEW74 = OLD74 + (
    '\n**Known approaches as instances** [AI reading]. Six approaches were stated as selections through what they '
    f'couple into, each with the premise that makes it one ([study §{N}]({SA}), {AREC}): RLHF and reward modelling '
    'through raters\' judgments of outputs and a reward model fitted to them; constitutional AI through a model\'s '
    'reading of a written rule set; debate and scalable oversight through judges\' pooled reading of transcripts; '
    'interpretability-based oversight through the system\'s internal states, not the world consequences of its acts; '
    'guaranteed-safe AI through a world model and a specification; impact measures through the agent\'s own model '
    'against an inaction baseline. With no ethical premise each selects alike everything beyond the union of its '
    'deciders\' closures (§7.3), whatever they value, and within it separates only what some member couples apart, '
    'along routes of reading. Raters or judges reading one channel add agreement, not reach (`Web.pooled_iff_member`), '
    'and reading the system adds nothing beyond pooling with it (`Flow.withinCoupling_reads_iff`). The continuation '
    'condition adds the scope: a loss beyond every rater\'s closure counts, so for that scope a preference-coupled '
    'approach is incomplete whatever the raters value, while for the raters\' own scope it is not '
    '(`Clearing.centers_retain_yet_loses`). Only coupling into such losses, by measurement, by models or through the '
    'formations an act reaches, brings them within reach, which is necessary and not sufficient (§7.5). The order asks '
    'no more than unanimity: widening is what every order increasing in admission shares, additive or not '
    '(`Weighting.widens_iff_every_of_class`, §6.5). What each approach adds lies mostly where the laws are silent, in '
    'installation and compliance (§7.7). These are constraints every strategy deciding through couplings is subject '
    'to, not a strategy and not a ranking.\n')
OLD74R = ('Records: [what-pooled-coupling-reaches](../results/records/what-pooled-coupling-reaches.md), '
          '[what-a-pools-acts-respond-to](../results/records/what-a-pools-acts-respond-to.md), '
          '[the-gap-for-ones-own-act](../results/records/the-gap-for-ones-own-act.md).\n')
NEW74R = OLD74R[:-2] + f', {AREC}.\n'
OLD77 = ('How a member\'s law comes to be, differences at many conditions at once, and members reading one another\'s '
         'coupling directly are open (§8.1).')
NEW77 = ('How a member\'s law comes to be, differences at many conditions at once, and members reading one another\'s '
         'law are open (§8.1); a member reading the levels of what another couples into is pooled with it '
         '(`Flow.withinCoupling_reads_iff`, §7.3).')
i = ch0.index('7. **Which law holds, and how a member\'s law comes about** (further proof).')
OLD7 = ch0[i:ch0.index('\n', i)]
OLD7a = 'one turn around a cycle of exact links is stated exactly (`LoopReturn.carried_around_exact`).'
NEW7a = (OLD7a[:-1] + f'; and (AP1, [study §{N}]({SA})) a member reading another\'s couplings, coupled by level into '
         'everything the other couples into, is pooled with it: its coupling closure is the pool\'s where the other '
         'exchanges with a condition coupled into it, and it is blind beyond the union of the two closures '
         '(`Flow.withinCoupling_reads_iff`, `Flow.unselected_beyond_reads`).')
OLD7b = 'members reading one another\'s coupling;'
NEW7b = 'members reading one another\'s law, beyond the levels of what the other couples into;'
OLD7c = '[learnable-through-a-map](../results/records/learnable-through-a-map.md).'
NEW7c = f'[learnable-through-a-map](../results/records/learnable-through-a-map.md), {REC}.'
for part in (OLD7a, OLD7b, OLD7c):
    assert OLD7.count(part) == 1, part
NEW7 = OLD7.replace(OLD7a, NEW7a).replace(OLD7b, NEW7b).replace(OLD7c, NEW7c)
i = ch0.index('| [What a pool\'s acts respond to](../results/records/what-a-pools-acts-respond-to.md) |')
OLD_ROW = ch0[i:ch0.index('\n', i) + 1]
NEW_ROWS = (f'| [Reading another\'s couplings is pooling with it](../results/records/{RID}.md) | theorem under stated '
            'premises | balance; for the act, a law of exchange reading through the reader\'s coupling | §7.3 |\n'
            f'| [Alignment approaches under the selection laws](../results/records/{AID}.md) | assessment | in the record '
            '| §7.4 |\n')
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
i = ch0.index('**The current receipt** is run [`')
OLD_RECEIPT = ch0[i:ch0.index('\n', i)]
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with AP1 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
OLD65 = ('ranks it higher, however partially it weighs (`Weighting.widens_iff_every_positive`, on webs '
         '`Web.widens_iff_every_weighting`), so partiality')
NEW65 = ('ranks it higher, however partially it weighs (`Weighting.widens_iff_every_positive`, on webs '
         '`Web.widens_iff_every_weighting`), and the same holds for every order that ranks each widening higher, '
         'additive or not, priority to the worse off included (`Weighting.widens_iff_every_of_class`, '
         '`Weighting.widens_iff_every_score`, `Weighting.increasing_prior`), so partiality')
OLD12 = ('and C to monotonicity at each standpoint, with the impartial order exactly what every weighting counting '
         'everything shares (')
NEW12 = ('and C to monotonicity at each standpoint, with the impartial order exactly what every order counting everything '
         f'shares, additive or not (`Weighting.widens_iff_every_of_class`, AP1, [study §{N}]({SA}); ')
edit(CH, [(OLD65, NEW65), (OLD12, NEW12), (OLD73, NEW73), (OLD73R, NEW73R), (OLD74, NEW74), (OLD74R, NEW74R), (OLD77, NEW77), (OLD7, NEW7),
          (OLD_ROW, OLD_ROW + NEW_ROWS),
          (OLD_CORE, f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."),
          (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)])

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZ73 = ('**要点。** 损失只经寻求者耦合入者到达它，所以锁定的寻求在此之外造成的损失，只经测量、模型或他者到达它。'
          '每条路线有其律与其限，每条都给一个选择接上一个耦合，及于选择者自身的耦合所不及之处。\n')
NEWZ73 = (OLDZ73[:-1] + '读取他者的耦合即与之合起来：以水平耦合入另一形成所耦合入的一切者，其耦合闭包在后者与其所耦合入的条件交换时'
          '恰为二者之池的闭包，即二者闭包之并，在此之外是盲的（`Flow.withinCoupling_reads_iff`、`Flow.unselected_beyond_reads`）。\n')
OLDZ73R = ('记录：[what-pooled-coupling-reaches](../results/records/what-pooled-coupling-reaches.md)、'
           '[observation-is-a-route](../results/records/observation-is-a-route.md)。\n')
NEWZ73R = OLDZ73R[:-2] + f'、{REC}。\n'
OLDZ74 = '耦合界定池的动作所响应者，而不固定它：在界之内，每个成员所遵循的律决定。差别是池所加的。\n'
NEWZ74 = (OLDZ74[:-1] + '已知的对齐路径（RLHF 与奖励建模、宪法式 AI、辩论与可扩展监督、基于可解释性的监督、有保证的安全 AI、影响度量）'
          '都读作经耦合的选择，各有使之成为选择的前提、由这些律得出的差距，以及这些律所不给的（安装与服从）；接上系统闭包之内的耦合'
          '（同类输入的反馈、读取系统本身）只加规模或安装的证据，不加所及。这些是约束，不是策略，也不是排序 [AI 读法]'
          f'（[研究第 {N} 节]({SA})）。\n')
OLDZ74R = ('记录：[what-pooled-coupling-reaches](../results/records/what-pooled-coupling-reaches.md)、'
           '[what-a-pools-acts-respond-to](../results/records/what-a-pools-acts-respond-to.md)、'
           '[the-gap-for-ones-own-act](../results/records/the-gap-for-ones-own-act.md)。\n')
NEWZ74R = OLDZ74R[:-2] + f'、{AREC}。\n'
i = z.index('7. **哪个律成立，成员的律怎样形成**（进一步的证明）。')
OLDZ7 = z[i:z.index('\n', i)]
OLDZ7a = '精确环节之回路的一圈精确陈述（`LoopReturn.carried_around_exact`）。'
NEWZ7a = (OLDZ7a[:-1] + f'；以及（AP1，[研究第 {N} 节]({SA})）成员读取另一形成的耦合，即以水平耦合入后者所耦合入的一切，'
          '就与之合起来：其耦合闭包在后者与其所耦合入的条件交换时为二者之池的闭包，在二者闭包之并以外是盲的'
          '（`Flow.withinCoupling_reads_iff`、`Flow.unselected_beyond_reads`）。')
OLDZ7b = '概率学习与隐含偏置。'
NEWZ7b = '成员读取彼此的律（不止后者所耦合入者的水平）；概率学习与隐含偏置。'
for part in (OLDZ7a, OLDZ7b):
    assert OLDZ7.count(part) == 1, part
NEWZ7 = OLDZ7.replace(OLDZ7a, NEWZ7a).replace(OLDZ7b, NEWZ7b)
i = z.index('| [一组的动作回应什么](../results/records/what-a-pools-acts-respond-to.md) |')
OLDZROW = z[i:z.index('\n', i) + 1]
NEWZROWS = (f'| [读取他者的耦合即与之合起来](../results/records/{RID}.md) | 在所述前提下的定理 | 平衡；就动作而言，经读取者耦合而读的交换之律 | §7.3 |\n'
            f'| [选择之律下的对齐路径](../results/records/{AID}.md) | 评估 | 见记录 | §7.4 |\n')
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
OLDZ12 = '没有形式工作能解决它；理论定位每一步（§6.5），并列出尚未回答的反驳（§8.9）。'
NEWZ12 = (OLDZ12 + 'C 归为每个立场处的单调性：不偏的序恰为每个在接纳上递增的序所共有者，可加与否皆然'
          f'（`Weighting.widens_iff_every_of_class`，AP1，[研究第 {N} 节]({SA})）。')
edit(ZH, [(OLDZ12, NEWZ12), (OLDZ73, NEWZ73), (OLDZ73R, NEWZ73R), (OLDZ74, NEWZ74), (OLDZ74R, NEWZ74R), (OLDZ7, NEWZ7),
          (OLDZROW, OLDZROW + NEWZROWS), (OLDZR, NEWZR), (OLDZT, NEWZT)])

# The step-of-invariance chapter: section 5, the lexical bullet and its summary, section 7 item 4, section 8.
INV = 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
SAI = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{SLUG}'
OLDI1 = ('- **Partiality decides exactly the mixed comparisons, either way.**')
NEWI1 = ('- **The representation is not a premise.** An order need not be additive. Call it increasing in admission when '
         'it ranks every widening above what it widens (`Weighting.Increasing`); priority to the worse off is one '
         '(`Weighting.increasing_prior`). For any class of orders from the positive weightings up to all orders '
         'increasing in admission, one course widens another exactly when every order of the class ranks it higher '
         '(`Weighting.widens_iff_every_of_class`; every complete order, given as a score, '
         '`Weighting.widens_iff_every_score`), and within each class a mixed comparison is decided both ways '
         f'(`Weighting.mixed_either_way_of_class`; [study §{N}]({SAI})).\n' + OLDI1)
OLDI2 = 'The mathematics is known. It is Sen\'s intersection approach and Pareto dominance as the unanimity of positive weightings, in the 0/1 case.'
NEWI2 = (OLDI2[:-1] + '; without additivity it is the intersection of linear extensions (Szpilrajn 1930; Dushnik and '
         'Miller 1941) for the inclusion order on finite sets.')
OLDI3 = 'If each standpoint\'s order is a positive weighting (C at the standpoint, partiality allowed), then'
NEWI3 = ('If each standpoint\'s order is increasing in admission (C at the standpoint, partiality allowed, additive or '
         'not), then')
OLDI4 = ('It lies outside the order every positive weighting shares and decides comparisons that order leaves mixed.')
NEWI4 = ('It lies outside the order every positive weighting shares and decides comparisons that order leaves mixed. '
         'Where it ranks each widening higher it is increasing in admission, so it is within the classes over which the '
         'shared order is still exactly widening (`Weighting.widens_iff_every_of_class`), and it decides only what that '
         'order leaves mixed.')
OLDI5 = 'So §6.2\'s framing is exact for every additive rival, and for transforms of levels.'
NEWI5 = ('So §6.2\'s framing is exact for every rival that ranks each widening higher, additive or not, transforms of '
         'levels among them.')
OLDI6 = 'This is C\'s premise, relocated by section 5.'
NEWI6 = OLDI6 + ' Additivity is not part of it (`Weighting.widens_iff_every_of_class`).'
OLDI7 = ('| Mixed comparisons are decided both ways | `Weighting.mixed_either_way`, `Weighting.outweighs` | '
         '`Becoming.Weightings` | landed |\n')
NEWI7 = ('| C is what every order increasing in admission shares, additive or not | `Weighting.widens_iff_every_of_class`, '
         '`Weighting.widens_iff_every_increasing`, `Weighting.widens_iff_every_score`, `Web.widens_iff_every_of_class`, '
         '`Weighting.increasing_prior` | `Becoming.Weightings` | landed |\n' + OLDI7)
edit(INV, [(OLDI1, NEWI1), (OLDI2, NEWI2), (OLDI3, NEWI3), (OLDI4, NEWI4), (OLDI5, NEWI5), (OLDI6, NEWI6),
           (OLDI7, NEWI7)])

# Board: the row moves to the history file; the queue and receipt sentences name the landing.
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID': RID, 'AID': AID,
                                           'receipt_id': receipt_id, 'N': N, 'n_new': 12, 'w_new': 7})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
