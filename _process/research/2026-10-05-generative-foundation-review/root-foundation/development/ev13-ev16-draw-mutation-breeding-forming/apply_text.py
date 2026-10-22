#!/usr/bin/env python3
"""EV13-EV16 landing text: the study section, the chapter (EN, ZH: section 2.4's Drift and Reproduction passages,
the record table, section 8.1 item 9 and section 9's receipt, counts and audit sentence), the evolution chapter (its
summary, the recovery table row and next connection 3), the board rows moved to the history file and the queue and
receipt sentences. Every edit must match once.

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
STUDY_LINK = '../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
RID13 = 'fixation-with-selection'
RID14 = 'mutation-and-the-balance-it-sets'
RID15 = 'the-breeding-value'
RID16 = 'dependence-formed-from-drawing'
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
    assert text.count(start) == 1, start
    i = text.index(start)
    return text[i:text.index('\n', i)]


R = json.loads((ROOT / PKG / 'becoming-checks' / receipt_id / 'verification.json').read_text())
assert R['status'] == 'passed' and R['core_compiles_from_prelude'] and R['source_unchanged_during_check']
assert not any(v for m in R['modules'] for v in m['axiom_dependencies'].values())
P = json.loads(Path(previous).read_text())
lines, n_thm = {}, {}
for mod in ('Becoming.Drift', 'Becoming.Reproduction', 'Becoming.Transmission'):
    om = next(m for m in R['modules'] if m['module'] == mod)
    pm = next(m for m in P['modules'] if m['module'] == mod)
    old_names = {d['name'] for d in pm['declarations']}
    added = [d for d in om['declarations'] if d['name'] not in old_names]
    removed = old_names - {d['name'] for d in om['declarations']}
    assert not removed, removed
    n_thm[mod] = sum(d['kind'] == 'theorem' for d in added)
    lines[mod] = (f'{om["theorems"]} theorems ({pm["theorems"]} before), {len(added)} declarations added '
                  f'({n_thm[mod]} theorems), none removed')
    print(mod, lines[mod])
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
mine = [r for r in conn['apart_roots_unclassified'] if r.startswith(('Becoming.Drift.', 'Becoming.Reproduction.', 'Becoming.Transmission.', 'Becoming.Web.', 'Becoming.Flow.', 'Becoming.World.', 'Becoming.TwoGivers.'))]
assert not mine, mine

stext = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(x) for x in re.findall(r'^## (\d+)\. ', stext, re.M)) + 1
core_line = (f'core {mods["core"]} modules and {fmt(thms["core"])} theorems, instances {mods["instance"]} and '
             f'{thms["instance"]}, applications {mods["application"]} and {thms["application"]}; {ran} Lean steps ran, '
             f'{fmt(reused)} reused')
apart_text = f'{apart} of {fmt(spine_thms)} apart; the new apart roots registered; register check passes'
study = (HERE / 'study_ev13_16.txt').read_text(encoding='utf-8')
for k, v in {'{N}': N, '{RECEIPT}': receipt_id, '{DRIFT_LINE}': lines['Becoming.Drift'],
             '{REPRO_LINE}': lines['Becoming.Reproduction'], '{TRANS_LINE}': lines['Becoming.Transmission'], '{APART}': apart_text, '{CORE_LINE}': core_line,
             '{RID13}': RID13, '{RID14}': RID14, '{RID15}': RID15, '{RID16}': RID16}.items():
    study = study.replace(k, str(v))
assert not re.search(r'\{[A-Z_0-9]+\}', study), 'placeholder left'
sys.path.insert(0, str(ROOT))
from tools.research.moves import github_slug
SLUG = github_slug(study.split('\n', 1)[0].lstrip('# ').strip())
assert SLUG.startswith(f'{N}-selection-in-the-draw-mutation'), SLUG
SA = f'{STUDY_LINK}#{SLUG}'
R13 = f'[{RID13}](../results/records/{RID13}.md)'
R14 = f'[{RID14}](../results/records/{RID14}.md)'
R15 = f'[{RID15}](../results/records/{RID15}.md)'
R16 = f'[{RID16}](../results/records/{RID16}.md)'
ZG8 = '[forming-anew-necessary-and-sufficient](../results/records/forming-anew-necessary-and-sufficient.md)'
FBD = '[fixation-by-drift](../results/records/fixation-by-drift.md)'

# Chapter, English.
ch0 = (ROOT / CH).read_text(encoding='utf-8')
OLD_D = '(`Drift.fixation`): drift alone ends variation and fixes each kind with its starting share h/N.'
NEW_D = (OLD_D + ' With selection in the draw, replacement one at a time among M + 1 (up with weight a, down with b, only the '
         'steps that change the count read; `Drift.Replacement.value`), the potential with steps b^j·a^(M−j) keeps its '
         'weighted value over any number of steps (`Drift.Replacement.value_potential`), so the fixation share tends to '
         'its value at the start over its value at the top (`Drift.Replacement.fixation`), the Moran fixation '
         'probability in counts: the starting share where a = b (`Drift.Replacement.neutral_share`), at least it where '
         'b ≤ a and strictly above it from every mixed start where b < a (`Drift.Replacement.favoured_share`, '
         '`Drift.Replacement.favoured_share_above`), and the favoured kind lost with weight at least b^i '
         '(`Drift.Replacement.lost_ge`).')
OLD_R = 'an amount can vary beside varying offspring numbers with no covariance (`Reproduction.Unrelated.unrelated`).'
NEW_R = (OLD_R + ' Mutation, transmission that is not exact: carriers leaving k offspring that carry an amount and m that do '
         'not, the others w, the carriers\' share rises exactly where d·k exceeds c·m + d·w (`Reproduction.Mutation.rises_iff`), '
         'never where k ≤ w and with any loss falls at every step (`Reproduction.Mutation.never_rises`, '
         '`Reproduction.Mutation.falls_of_outrun`: the error threshold), is kept at s/(s+m) where k = w + s '
         '(`Reproduction.Mutation.kept_share`) and approached from below without overshoot (`Reproduction.Mutation.below_always`); '
         'read as generations of descent, transmission lowers the amount by c·m and the step is balanced exactly there '
         '(`Reproduction.Mutation.balanced_iff`): mutation–selection balance is Price\'s balance of selection against '
         'transmission. Several carried amounts at once: an amount combining them that reproduces, `d` times, offspring '
         'number\'s covariation with each (the normal equations with denominators cleared) has `d` times its covariation '
         'with offspring number equal to its own spread (`Reproduction.Breeding.breeding_balance`), at most `d²` times '
         'offspring number\'s (`Reproduction.Breeding.additive_part_le`), and with exact transmission `d` times the '
         'cross-multiplied rise of its mean is that spread (`Reproduction.Breeding.response`): Fisher\'s fundamental '
         'theorem with breeding values, one carried amount its case (`Reproduction.Breeding.one_amount`); an offspring '
         'number that is the product of two amounts leaves a part no combination carries '
         '(`Reproduction.Interaction.interaction`).')
OLD_RECS = f'{FBD}, [additive'
assert ch0.count(OLD_RECS) == 2, ch0.count(OLD_RECS)
NEW_RECS = f'{FBD}, {R13}, {R14}, {R15}, [additive'
OLD_ROW13 = line_from(ch0, '| [Fixation by drift](../results/records/fixation-by-drift.md) |') + '\n'
NEW_ROW13 = (f'| [Fixation with selection in the draw](../results/records/{RID13}.md) | theorem under stated premises '
             '| two kinds; replacement one at a time with constant weights, only the steps that change the count read | §2.4 |\n')
OLD_ROW14 = line_from(ch0, '| [The additive part of the variance in offspring number](../results/records/additive-part-of-offspring-variance.md) |') + '\n'
NEW_ROW14 = (f'| [Mutation and the balance it sets](../results/records/{RID14}.md) | theorem under stated premises '
             '| two kinds; loss in one direction only; constant offspring numbers | §2.4 |\n'
             f'| [The breeding value](../results/records/{RID15}.md) | theorem under stated premises '
             '| an amount combining the carried amounts that satisfies the normal equations (cleared of denominators); '
             'exact transmission for the response | §2.4 |\n')
OLD_ROW16 = line_from(ch0, f'| [Forming anew, necessary and sufficient]({ZG8[ZG8.index("(") + 1:-1]}) |') + '\n'
NEW_ROW16 = (f'| [A dependence formed from drawing](../results/records/{RID16}.md) | theorem under stated premises '
             '| the reading of drawing at the descent; balance for the flow laws | §8.1 |\n')
OLD9 = line_from(ch0, "9. **Evolution's selection term** (further proof).")
OLD9a = 'over many sampled generations the count kept on average, variation ending and each kind fixed with its starting share, `Becoming.Drift`.)'
NEW9a = ('over many sampled generations the count kept on average, variation ending and each kind fixed with its starting share, '
         'and with selection in the draw (replacement one at a time) the fixation share the potential\'s ratio, above the '
         'starting share for the favoured kind and never certain, `Becoming.Drift`; mutation, transmission that is not '
         'exact, its balance Price\'s balance of selection against transmission and its threshold where the carriers\' '
         'advantage does not outrun the loss, and the breeding value, `d` times its covariation with offspring number its own '
         'spread and its mean rising by that spread with exact transmission (Fisher\'s fundamental theorem with breeding '
         'values), `Becoming.Reproduction`; where depending and drawing part at the giver, a dependence forming anew '
         'exactly where the giver drew on what it did not depend on, `Becoming.Transmission`.)')
OLD9b = 'drift with selection in one draw, and mutation (transmission not exact);'
NEW9b = ('drift with selection in sampled generations (Wright–Fisher with selection), mutation both ways and with drift;')
OLD9c = ('how dependences form at coming to stand where depending and drawing part at the givers (the law of forming, '
         'necessary and sufficient in drawing and depending, is stated: a dependence forms anew exactly where the '
         'descendant depends on what its giver did not draw on, and the reading of drawing is inheritance with the givers '
         f'drawing what they pass on, `Web.formsAnew_iff_undrawn`, `Flow.dependsOnDrawn_iff`, ZG8, {ZG8});')
NEW9c = ('why a descendant comes to depend on what its giver drew on (where it comes from is stated: a dependence forms '
         'anew exactly where the descendant depends on what its giver did not draw on where depending and drawing '
         f'coincide, `Web.formsAnew_iff_undrawn`, ZG8, {ZG8}, and where they part, exactly where the giver drew on what it '
         f'did not depend on, under the reading of drawing, `Web.formsAnew_iff_drawn_unheld`, {R16});')
OLD9d = ('the additive part through several carried amounts at once (the breeding value), and Fisher\'s identity itself, '
         'which needs the regression coefficient.')
NEW9d = 'whether the normal equations have a solution with natural coefficients after clearing denominators.'
assert all(OLD9.count(o) == 1 for o in (OLD9a, OLD9b, OLD9c, OLD9d)), [OLD9.count(o) for o in (OLD9a, OLD9b, OLD9c, OLD9d)]
NEW9 = (OLD9.replace(OLD9a, NEW9a).replace(OLD9b, NEW9b).replace(OLD9c, NEW9c).replace(OLD9d, NEW9d)
        .replace(OLD_RECS, NEW_RECS))
OLD_RECLINE = line_from(ch0, 'Records: [evolution-on-descent](../results/records/evolution-on-descent.md), ')
assert OLD_RECLINE.count(OLD_RECS) == 1
NEW_RECLINE = OLD_RECLINE.replace(OLD_RECS, NEW_RECS)
OLD_CORE = re.search(r'with the base and its layers: (\d+) modules counting the root `Becoming`\.', ch0).group(0)
OLD_RECEIPT = line_from(ch0, '**The current receipt** is run [`')
NEW_RECEIPT = (f"**The current receipt** is run [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json) "
               f"(the [current pointer](../../../{PKG}/becoming-verification.json)), checked with Lean 4.29.1 on main "
               f"{base[:9]} with EV13-EV16 in the working tree ([study §{N}]({SA})). It passed, the source unchanged during the "
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
pairs = [(OLD_D, NEW_D), (OLD_R, NEW_R), (OLD9, NEW9), (OLD_RECLINE, NEW_RECLINE), (OLD_ROW13, OLD_ROW13 + NEW_ROW13),
         (OLD_ROW14, OLD_ROW14 + NEW_ROW14),
         (OLD_ROW16, OLD_ROW16 + NEW_ROW16), (OLD_RECEIPT, NEW_RECEIPT), (OLD_TABLE, NEW_TABLE), (OLD_STEPS, NEW_STEPS)]
new_core = f"with the base and its layers: {mods['core']} modules counting the root `Becoming`."
if OLD_CORE != new_core:
    pairs.append((OLD_CORE, new_core))

# Chapter, Chinese.
z = (ROOT / ZH).read_text(encoding='utf-8')
OLDZD = '`Drift.fixation`）：单凭漂变即终结差异，并以起始份额 h/N 固定各类）、'
NEWZD = (OLDZD + '`Drift.Replacement.fixation`（抽取中有选择：M + 1 个成员中一次替换一个，上升权重 a、下降 b，只读改变计数的步'
         '（`Drift.Replacement.value`）；步长为 b^j·a^(M−j) 的势在任意步数中保持其加权值（`Drift.Replacement.value_potential`），故固定份额'
         '趋于起点之势比顶端之势，即计数形式的 Moran 固定概率：a = b 时为起始份额（`Drift.Replacement.neutral_share`），b ≤ a 时至少为它、'
         'b < a 时自每个混合起点严格高于它（`Drift.Replacement.favoured_share`、`Drift.Replacement.favoured_share_above`），受青睐的一类以至少 '
         'b^i 的权重失去（`Drift.Replacement.lost_ge`））、')
OLDZR = '（`Reproduction.Unrelated.unrelated`））、'
NEWZR = (OLDZR + '`Reproduction.Mutation.balanced_iff`（突变，不精确的传递：携带者各留 k 个携带该量的后代与 m 个不携带的，其余成员各留 w 个，'
         '携带者份额恰在 d·k 超过 c·m + d·w 时上升（`Reproduction.Mutation.rises_iff`），k ≤ w 时从不上升、有任何损失即每步下降'
         '（`Reproduction.Mutation.never_rises`、`Reproduction.Mutation.falls_of_outrun`：误差阈值），k = w + s 时保持于 s/(s+m)'
         '（`Reproduction.Mutation.kept_share`）并自下方无超越地趋近（`Reproduction.Mutation.below_always`）；按世代读，传递使该量降低 c·m，'
         '该步恰在此处平衡：突变与选择的平衡即 Price 方程中选择与传递的平衡）、'
         '`Reproduction.Breeding.response`（同时经由多个所载之量：组合这些量、其与每一量的协变为后代数之 `d` 倍（消去分母的正规方程）的量，'
         '`d` 乘其与后代数的协变等于其自身离散（`Reproduction.Breeding.breeding_balance`），至多为后代数离散的 `d²` 倍'
         '（`Reproduction.Breeding.additive_part_le`），传递精确时 `d` 乘其均值交叉相乘的上升即该离散：以育种值陈述的 Fisher 基本定理，'
         '单一所载之量为其情形（`Reproduction.Breeding.one_amount`）；后代数为两量之积时，留下任何组合都不携带的部分'
         '（`Reproduction.Interaction.interaction`））、')
OLDZ13 = line_from(z, '| [漂变导致的固定](../results/records/fixation-by-drift.md) |') + '\n'
NEWZ13 = f'| [抽取中有选择时的固定](../results/records/{RID13}.md) | 在所述前提下的定理 | 两类；以恒定权重一次替换一个，只读改变计数的步 | §2.4 |\n'
OLDZ14 = line_from(z, '| [后代数方差的加性部分](../results/records/additive-part-of-offspring-variance.md) |') + '\n'
NEWZ14 = (f'| [突变及其设定的平衡](../results/records/{RID14}.md) | 在所述前提下的定理 | 两类；只单向损失；后代数恒定 | §2.4 |\n'
          f'| [育种值](../results/records/{RID15}.md) | 在所述前提下的定理 | 组合所载之量、满足（消去分母的）正规方程的量；响应需传递精确 | §2.4 |\n')
OLDZ16 = line_from(z, '| [新结之依存，充要](../results/records/forming-anew-necessary-and-sufficient.md) |') + '\n'
NEWZ16 = f'| [来自汲取的依存](../results/records/{RID16}.md) | 有所述前提的定理 | 该次世系处的汲取之读法；流的定律需平衡 | §8.1 |\n'
OLDZ9 = line_from(z, '9. **演化的选择项**（进一步的证明）。')
OLDZ9a = '多代抽样中平均保持计数、终结差异并以起始份额固定各类，`Becoming.Drift`。）'
NEWZ9a = ('多代抽样中平均保持计数、终结差异并以起始份额固定各类，抽取中有选择时（一次替换一个）固定份额为势之比、受青睐的一类高于起始份额且从不确定，'
          '`Becoming.Drift`；突变即不精确的传递，其平衡即选择与传递的 Price 平衡，携带者的优势不超过损失时有阈值，以及育种值：`d` 乘其与后代数的协变即其自身离散，'
          '传递精确时其均值以该离散上升（以育种值陈述的 Fisher 基本定理），`Becoming.Reproduction`；给予者处依存与汲取相分时，依存恰在给予者汲取其所不依存者之处新结，'
          '`Becoming.Transmission`。）')
OLDZ9b = '同一次抽取中的漂变与选择，以及突变（不精确的传递）；'
NEWZ9b = '多代抽样中的漂变与选择（有选择的 Wright–Fisher），双向的突变与伴随漂变的突变；'
OLDZ9c = ('给予者处依存与汲取相分时依存如何在首立时结成（以汲取与依存陈述之充要之形成之律已证：一依存新结恰在后代依于给予者所未汲者之处，'
          '汲取之读法恰是因加上给予者汲取其所传，`Becoming.Web.formsAnew_iff_undrawn`、`Becoming.Flow.dependsOnDrawn_iff`，ZG8）；世系新形成的依存；')
NEWZ9c = ('后代为何依于其给予者所汲者（其来处已证：依存与汲取相合时，一依存新结恰在后代依于给予者所未汲者之处，`Becoming.Web.formsAnew_iff_undrawn`，ZG8；'
          '相分时，在汲取之读法下，恰在给予者汲取其所不依存者之处，`Becoming.Web.formsAnew_iff_drawn_unheld`）；')
OLDZ9d = '同时经由多个所载之量的加性部分（育种值），以及需要回归系数的 Fisher 恒等式本身。'
NEWZ9d = '消去分母后正规方程是否有自然数系数之解。'
assert all(OLDZ9.count(o) == 1 for o in (OLDZ9a, OLDZ9b, OLDZ9c, OLDZ9d)), [OLDZ9.count(o) for o in (OLDZ9a, OLDZ9b, OLDZ9c, OLDZ9d)]
NEWZ9 = OLDZ9.replace(OLDZ9a, NEWZ9a).replace(OLDZ9b, NEWZ9b).replace(OLDZ9c, NEWZ9c).replace(OLDZ9d, NEWZ9d)
OLDZRC = line_from(z, '**当前回执**是运行 [`')
NEWZRC = (f"**当前回执**是运行 [`{receipt_id}`](../../../{PKG}/becoming-checks/{receipt_id}/verification.json)"
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
zpairs = [(OLDZD, NEWZD), (OLDZR, NEWZR), (OLDZ13, OLDZ13 + NEWZ13), (OLDZ14, OLDZ14 + NEWZ14), (OLDZ16, OLDZ16 + NEWZ16), (OLDZ9, NEWZ9),
          (OLDZRC, NEWZRC), (OLDZT, NEWZT)]

# The evolution chapter.
OLD_S = f'the neutral fixation probability ({FBD}).'
NEW_S = (OLD_S + ' With selection in the draw, replacement one at a time, the fixation share leaves the starting share: '
         'a potential the weighted histories keep fixes it, above the starting share for the favoured kind and never '
         f'certain ({R13}). Mutation is transmission that is not exact: the carriers\' share is kept where their advantage '
         'balances what mutation takes from them, approached from below without overshoot, and where the advantage does not outrun '
         f'the loss they decline whatever their share, the error threshold; the balance is Price\'s balance of selection '
         f'against transmission ({R14}).')
OLD_ADD = ('and all of it where the amount is offspring number itself '
           '([additive-part-of-offspring-variance](../results/records/additive-part-of-offspring-variance.md)).')
NEW_ADD = (OLD_ADD + ' Through several carried amounts at once, the breeding value, an amount combining them that reproduces '
           'offspring number\'s covariation with each, has its covariation with offspring number equal to its own spread, '
           'at most offspring number\'s, and with exact transmission its mean rises by that spread over the mean offspring '
           f'number: Fisher\'s fundamental theorem with breeding values, read in counts ({R15}).')
OLD_C2 = 'Open are several carried amounts at once (the breeding value) and Fisher\'s identity itself, which needs the regression coefficient.'
NEW_C2 = ('Several carried amounts at once are on the spine: the breeding value, any combination reproducing offspring '
          'number\'s covariation with each carried amount, has its covariation with offspring number equal to its own '
          'spread, at most the whole, and Fisher\'s fundamental theorem holds for it with exact transmission, one amount '
          f'its case; an interacting offspring number leaves a part no combination carries ({R15}). Open is whether the '
          'normal equations have a solution with natural coefficients after clearing denominators.')
OLD_TAB = ('the neutral fixation probability ([drift-offspring-sampled](../results/records/drift-offspring-sampled.md), '
           f'{FBD}). Each is a known result restated;')
NEW_TAB = ('the neutral fixation probability ([drift-offspring-sampled](../results/records/drift-offspring-sampled.md), '
           f'{FBD}), with selection in the draw the Moran fixation probability ({R13}), and mutation–selection balance '
           f'with the error threshold ({R14}). Each is a known result restated;')
OLD_C3 = ('Open are drift and selection in one draw (where the fixation share is no longer the starting share), and '
          'mutation: transmission that is not exact, read through the transmission term of the selection term\'s course '
          'over generations.')
NEW_C3 = ('Drift and selection in one draw are on the spine for replacement one at a time: the fixation share is a '
          'potential\'s ratio, above the starting share for the favoured kind and never certain '
          f'({R13}). Mutation, read through the transmission term, sets a balance that is Price\'s balance of selection '
          f'against transmission, and a threshold below which the carriers decline ({R14}). Open are selection in '
          'sampled generations (Wright–Fisher with selection), mutation both ways, and mutation with drift.')
epairs = [(OLD_S, NEW_S), (OLD_TAB, NEW_TAB), (OLD_C3, NEW_C3), (OLD_ADD, NEW_ADD), (OLD_C2, NEW_C2)]

evo = (ROOT / EVO).read_text(encoding='utf-8')
for text, ps, name in ((ch0, pairs, CH), (z, zpairs, ZH), (evo, epairs, EVO)):
    for old, _ in ps:
        assert text.count(old) == 1, (name, old[:100], text.count(old))

(ROOT / STUDY).write_text(stext.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')
print('appended', STUDY, 'section', N)
edit(CH, pairs)
exec((HERE / 'section9_audit.py').read_text(), {'ROOT': ROOT, 'CH': CH, 'R': R})
edit(ZH, zpairs)
edit(EVO, epairs)
exec((HERE / 'board_part.py').read_text(), {'ROOT': ROOT, 'BOARD': BOARD, 'HISTORY': HISTORY, 'RID13': RID13,
                                           'RID14': RID14, 'RID15': RID15, 'RID16': RID16, 'receipt_id': receipt_id,
                                           'N': N, 'n_thm': n_thm})
print('apart', apart, 'spine theorems', spine_thms)
print('STUDY_SECTION', N)
