#!/usr/bin/env python3
"""UE24 record: write identical-cells-under-noise (the periphery module CellsUnderNoise, homed in 05 §9 after the
identical-cells law), each declaration of the module cited once, with a formal-reuse dependency on
identical-cells-under-a-descent-treating-them-alike and related entries; that record's second and third does-not-show
items, its next step and a related entry name the new one, with a history note; neither its statement nor its
declarations change. Asserts the periphery receipt's status, the module's hash and that every declaration depends on
Lean's three standard axioms at most, and the style caps and lint (tools/research/style.py) on every field written.
The core module it reads, FreeEnergyGuarantees, is bound to the latest passed core receipt holding its current bytes.
Mirrors UE17's make_records_ue17.py.
usage (from the checkout root, after texts_ue24.py): python3 -B make_records_ue24.py RECEIPT N
       python3 -B make_records_ue24.py --caps RECEIPT  (the caps, lint and the declaration cover; writes nothing;
                                                         RECEIPT `source` reads the declarations from the source)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID = sys.argv[2] if CAPS_ONLY else sys.argv[1]
N = 465 if CAPS_ONLY else int(sys.argv[2])
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
FE = f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue24-cells-under-noise/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE24.md', KITD + 'RECHECK-UE24.md'
CH5 = 'theories/becoming/chapters/05-COLLECTIVES.md'
MODULE = f'{FE}/CellsUnderNoise.lean'
CHECKER = f'{FE}/check_cells_under_noise.py'
FEG = f'{PKG}/Becoming/FreeEnergyGuarantees.lean'
RECEIPT = f'{FE}/cells-under-noise-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'identical-cells-under-noise'
RIDI = 'identical-cells-under-a-descent-treating-them-alike'
RIDS = 'selection-through-a-model-of-the-options'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 76
STANDARD = {'propext', 'Classical.choice', 'Quot.sound'}
HAS_RECHECK = (ROOT / RECHECK).exists()
assert 'PARAGRAPH' not in (ROOT / NOTE).read_text(encoding='utf-8'), 'a placeholder left in NOTE'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


def source_names():
    """The module's declarations read from its source (for --caps before a receipt holds its bytes)."""
    found, spaces = set(), []
    for line in (ROOT / MODULE).read_text(encoding='utf-8').split('\n'):
        m = re.match(r'(namespace|end) (\S+)$', line)
        if m and m.group(1) == 'namespace':
            spaces.append(m.group(2))
        elif m and spaces and spaces[-1] == m.group(2):
            spaces.pop()
        m = re.match(r'(?:theorem|noncomputable def|def|abbrev) (\S+)', line)
        if m:
            found.add('.'.join(spaces + [m.group(1)]))
    return found


if CAPS_ONLY and RECEIPT_ID == 'source':
    names = source_names()
else:
    receipt = json.loads((ROOT / RECEIPT).read_text())
    assert receipt['status'] == 'passed' and receipt['bridge_module'] == 'CellsUnderNoise'
    assert receipt['source_sha256']['CellsUnderNoise'] == sha(MODULE), 'the module changed since the receipt'
    assert receipt['source_sha256']['Becoming.FreeEnergyGuarantees'] == sha(FEG)
    mod = next(x for x in receipt['modules'] if x['module'] == 'CellsUnderNoise')
    names = {d['name'] for d in mod['declarations']}
    deps = mod['axiom_dependencies']
    assert set(deps) == names, sorted(names ^ set(deps))
    for name, axioms in deps.items():
        assert set(axioms) <= STANDARD, (name, axioms)
assert len(names) == COUNT, (len(names), sorted(names))
M = 'Becoming.CellsUnderNoise.'


def C(*short):
    out = [M + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("Over finitely many cells and states, weights on configurations move in discrete steps by kernels, one per "
     "step. A kernel commuting with a rearrangement of the cells keeps weights it leaves unchanged unchanged, so under "
     "kernels commuting with every rearrangement an exchangeable start stays exchangeable at every step; nonnegative "
     "kernels with rows of total one keep a law a law (weightsAt_exchangeable and eleven more).",
     "有限多细胞、每一细胞有限多状态之构型上之权重，于离散之步中由核（每步一核）移动：与细胞之一重排可交换之核，保其所不变之权重不变，故于与每一重排可交换之诸核下，"
     "可交换之起点于每一步给出可交换之律；非负且每行总和为一之核保律为律（weightsAt_exchangeable 等十二项）。",
     C('rearrange', 'Invariant', 'Exchangeable', 'KernelCommutes', 'step', 'weightsAt', 'step_invariant',
       'weightsAt_invariant', 'weightsAt_exchangeable', 'step_nonneg', 'step_total', 'weightsAt_law')),
    ("Identical cells at the start: the law of all cells in one state, and the law of the cells independent, each "
     "of one law, are exchangeable laws; the law of one configuration is unchanged by a rearrangement exactly where "
     "the configuration is, so it is exchangeable only with all its cells alike (pointMass_exchangeable_alike and "
     "seven more).",
     "起点之同一细胞：诸细胞同处一状态之律，与诸细胞独立、各依同一律之律，皆为可交换之律；一构型之律恰于该构型为一重排所不变处为其所不变，"
     "故唯其细胞皆相同时可交换（pointMass_exchangeable_alike 等八项）。",
     C('pointMass', 'pointMass_invariant_iff', 'pointMass_exchangeable_alike', 'alike_fixed', 'alike_exchangeable',
       'independent_exchangeable', 'independent_law', 'pointMass_law')),
    ("What an exchangeable law leaves undecided: every cell has the law of every other, and where the law is "
     "nonnegative with total one, each assignment of distinct states to the cells has weight at most one over the "
     "number of orderings of the cells (marginal_eq, distinct_le).",
     "可交换之律所未定者：每一细胞之律即其余每一细胞之律；律非负且总和为一时，诸细胞之每一相异状态之指派其权重至多为细胞诸排序之数之倒数（marginal_eq、distinct_le）。",
     C('marginal', 'marginal_eq', 'distinct_le')),
    ("Stationary laws come in rearranged sets under a kernel commuting with every rearrangement, so a unique "
     "stationary law is exchangeable; the Gibbs weights exp(-κF) normalized, for any real κ, of a free energy no "
     "rearrangement changes are exchangeable, no kernel being shown to keep them (unique_stationary_exchangeable and "
     "three more).",
     "于与每一重排可交换之核下，平稳之律成重排之集，故唯一之平稳律可交换；无重排能改之自由能之 Gibbs 权重 exp(-κF) 归一（κ 为任一实数）可交换，"
     "然未示何核保之（unique_stationary_exchangeable 等四项）。",
     C('Stationary', 'stationary_rearranged', 'unique_stationary_exchangeable', 'gibbs_exchangeable')),
    ("A rule with noise of one law at every cell, each cell going independently from the state the rule gives it: "
     "where the rule commutes with a rearrangement so does the rule with noise; with no noise the law of one "
     "configuration follows the rule's run (noisy_commutes, weightsAt_noiseless and three more).",
     "规则加每一细胞同一律之噪声，每一细胞自规则所予之状态独立而行：规则与一重排可交换处，加噪声之规则亦然；无噪声时一构型之律随规则之运行（noisy_commutes、"
     "weightsAt_noiseless 等五项）。",
     C('noisy', 'noisy_commutes', 'noiseless', 'step_noiseless', 'weightsAt_noiseless')),
    ("The join to the core: the core's descent, read cell by cell on a configuration read as a list, has the core's "
     "run as its run, so with no noise the law weighs one exactly the configuration the core's run reaches; two "
     "cells alike at the start stay alike whatever the field (noiseless_run, cellwise_alike and three more).",
     "与核心相接：核心之下降于读作列之构型上逐细胞而读，其运行即核心之运行，故无噪声时律恰予核心之运行所达之构型以权重一；起点相同之二细胞无论场如何皆保持相同"
     "（noiseless_run、cellwise_alike 等五项）。",
     C('cellwise', 'ofFn_cellwise', 'ofFn_iterate_cellwise', 'cellwise_alike', 'noiseless_run')),
    ("Exchanging neighbouring cells is rearranging by a transposition, and these generate every rearrangement; so "
     "with an exchangeable field the core's descent commutes with every rearrangement and its run from a rearranged "
     "start is the rearranged run, and a free energy symmetric in the core's sense and its Gibbs weights are "
     "unchanged by every rearrangement (ofFn_rearranged, run_rearranged and four more).",
     "交换相邻细胞即依一对换重排，而诸对换生成每一重排；故场可交换时核心之下降与每一重排可交换，其自重排之起点之运行即重排之运行；依核心之义对称之自由能及其 Gibbs "
     "权重为每一重排所不变（ofFn_rearranged、run_rearranged 等六项）。",
     C('ofFn_swap', 'ofFn_rearranged', 'cellwise_commutes', 'run_rearranged', 'symmetric_rearranged',
       'gibbs_symmetric_exchangeable')),
    ("The core's descent with noise of one law at every cell, each cell going independently from its own state and "
     "the field it senses, commutes with every rearrangement where the field is exchangeable: from an exchangeable "
     "start the weights are exchangeable at every step, and where noise and start are laws each assignment of distinct "
     "states to the m cells has weight at most 1/m! "
     "(noisyDescent_distinct_le and eight more).",
     "核心之下降加每一细胞同一律之噪声，每一细胞依其自身状态与其所感之场独立而行：场可交换时与每一重排可交换，故自可交换之起点，权重于每一步皆可交换；"
     "噪声与起点皆为律时，m 个细胞之每一相异状态之指派权重至多 1/m!（noisyDescent_distinct_le 等九项）。",
     C('noisyDescent', 'noisy_eq_noisyDescent', 'noisyDescent_commutes', 'noisyDescent_nonneg', 'noisyDescent_rows',
       'noisyDescent_exchangeable', 'noisyDescent_distinct_le', 'noisyDescent_from_alike',
       'noisyDescent_from_independent')),
    ("In finitely many states independent noise can part identical cells but never with certainty: from all cells in "
     "one state, under the descent with noise that is a law, some configuration of all cells alike has positive "
     "weight at every step; with a fair coin of its own for each of two cells, they part after one step with weight "
     "one quarter (alike_positive, Witness.independentNoise_parts).",
     "于有限多状态，独立之噪声能分开同一细胞，然从不必然：自诸细胞同处一状态，于噪声为律之下降，每一步皆有某一诸细胞相同之构型具正权重；二细胞各有其公平之硬币时，"
     "一步之后以四分之一之权重分开（alike_positive、Witness.independentNoise_parts）。",
     C('alike_positive', 'Witness.independentNoise_parts')),
    ("A kernel taking every configuration of two cells to either parted one at one half commutes with the exchange "
     "and parts alike cells with certainty; it is the fair mixture of two rules assigning the places by the cells' "
     "numbers, neither commuting with the exchange, and no noise of one law at every cell; its only stationary law "
     "is that half and half "
     "(Witness.toParted_eq_mixture and seventeen more).",
     "令二细胞之每一构型以各一半之权重至二分开构型之一之核，与交换二细胞可交换，且必然分开相同之细胞；其为二规则之公平混合，每一规则依细胞之编号指派位置，皆不与交换可交换；"
     "且非每一细胞同一律之噪声；其唯一平稳律即此各半（Witness.toParted_eq_mixture 等十八项）。",
     C('Witness.Two', 'Witness.sum_two', 'Witness.partedUniform', 'Witness.partedUniform_law',
       'Witness.partedUniform_not_product', 'Witness.parted_rearranged', 'Witness.toParted',
       'Witness.toParted_commutes', 'Witness.toParted_not_noisy', 'Witness.toParted_not_noisyDescent',
       'Witness.toParted_once', 'Witness.alike_none', 'Witness.each_half', 'Witness.toParted_stationary_iff',
       'Witness.partedUniform_exchangeable', 'Witness.assign', 'Witness.assign_not_commutes',
       'Witness.toParted_eq_mixture')),
    ("A field reading the state of the first cell reads no cell's number, yet reads the places through the list's "
     "order and is not exchangeable; with each cell "
     "flipping by it and no noise, from the parted half and half it gives cell 0 off and cell 1 on weight one and the "
     "two cells different laws (Witness.firstCell_assigns and three more).",
     "读第一细胞之状态之场不读细胞之编号，然经列之次序读位置，且不可交换；每一细胞依之翻转、无噪声，自分开之各半起，予细胞 0 关、细胞 1 开以权重一，二细胞之律相异（Witness.firstCell_assigns 等四项）。",
     C('Witness.firstCell', 'Witness.flipBy', 'Witness.firstCell_not_exchangeable', 'Witness.firstCell_assigns')),
]
cited = [d for _, _, ds in groups for d in ds]
assert len(cited) == len(set(cited)) == COUNT, (len(cited), len(set(cited)))
assert set(cited) == names, sorted(names - set(cited))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

title = capped('title', {'en': 'Identical cells under noise', 'zh': '噪声下之同一细胞'})
statement = capped('statement', {
    'en': "Under the core's descent with an exchangeable field and noise of one law at every cell, over finite "
          "states, an exchangeable start stays exchangeable at every step: every cell has the law of every "
          "other, and where noise and start are laws each assignment of distinct states has weight at most 1/m!.",
    'zh': '于场可交换、每一细胞噪声同律之核心下降，状态有限，可交换之起点于每一步给出可交换之律：每一细胞之律即其余每一细胞之律，噪声与起点皆为律时，每一相异状态之指派权重至多 1/m!。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "In the periphery, on Mathlib's reals: each declaration depends on Lean's three standard axioms at most, "
           "reported by the module's checker; the core laws it reads have empty axiom reports, and cellwise, "
           "ofFn_cellwise, ofFn_iterate_cellwise and cellwise_alike use no Classical.choice.",
     'zh': '于外围，基于 Mathlib 之实数：每一声明至多依赖 Lean 之三条标准公理，由本模块之检查器报告；其所读之核心之律公理报告皆空，cellwise、ofFn_cellwise、'
           'ofFn_iterate_cellwise 与 cellwise_alike 不用 Classical.choice。'},
    {'en': "Modelling choices: finitely many cells and states; real weights on configurations; a kernel a function of "
           "two configurations, with no measurability; discrete synchronous steps, the kernel allowed to change from "
           "step to step; the noise independent across cells and of one law, reading a cell's own state and the field "
           "it senses; the rearrangements all permutations of the cells.",
     'zh': '建模之选：有限多细胞与状态；构型上之实数权重；核为二构型之函数，无可测性；离散同步之步，核可逐步而变；噪声于诸细胞间独立且同律，读细胞自身状态与其所感之场；'
           '重排为细胞之全部置换。'},
    {'en': "Exchangeability at every step needs a field exchangeable in the core's sense and an exchangeable start; "
           "the bound 1/m! needs in addition noise that is nonnegative with weights from each state and field "
           "totalling one, and a start that is a law.",
     'zh': '每一步之可交换需场依核心之义可交换及可交换之起点；1/m! 之界另需噪声非负且自每一状态与场之权重总和为一，及起点为律。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "Densities, continuous states or time, or Langevin flows: with a density exact alikeness has probability "
           "zero after one step, while here alike configurations keep weight.",
     'zh': '密度、连续之状态或时间，或 Langevin 流：有密度时一步之后恰相同之概率为零，而此处相同之构型保有权重。', 'kind': 'scope'},
    {'en': "Whether a realization parts, or which place a given cell reaches.",
     'zh': '一实现是否分开，或某一细胞达于何位。', 'kind': 'scope'},
    {'en': "Which asymmetry actually differentiates cells.",
     'zh': '何种不对称实际分化细胞。', 'kind': 'scope'},
    {'en': "That a given kernel has a stationary law, a unique one, or one approached at any rate, or that any kernel "
           "keeps the Gibbs weights.",
     'zh': '某一核有平稳律、唯一之平稳律或以某速率趋近之平稳律，或任一核保 Gibbs 权重。', 'kind': 'scope'},
    {'en': "That the 2015 paper's simulation fails: its scheme has the law's form, and no theorem here models it.",
     'zh': '2015 年论文之模拟失败：其方案合此律之形式，而此处无定理为之建模。', 'kind': 'non-implication'},
    {'en': "Which configuration, differentiated or not, is better.",
     'zh': '何构型（分化与否）更好。', 'kind': 'non-implication'})]
next_delta = capped('next_delta', {
    'en': "Densities and continuous time, a Langevin form of the law; a kernel keeping the Gibbs weights, as under "
          "detailed balance; a frozen run of the 2015 scheme recording the weight of each assignment of places; the "
          "law in the pure core; review by a person.",
    'zh': '密度与连续时间，此律之 Langevin 形式；保 Gibbs 权重之核，如于细致平衡之下；2015 年方案之冻结运行，记录每一位置指派之权重；纯核心中之此律；人之审查。'})
correspondence = capped('correspondence', {
    'en': "Curie's principle (Curie 1894; Chalmers 1970, British Journal for the Philosophy of Science 21) in its form "
          "for indeterministic laws, a symmetric cause giving a symmetric distribution of effects (Ismael 1997, "
          "Synthese 110; Castellani and Ismael 2016, Philosophy of Science 83); spontaneous symmetry breaking, a "
          "symmetry the law keeps broken only in realizations (Earman 2004); no deterministic rule treating anonymous "
          "processors alike singles one out (Angluin 1980), while independent coins, one for each, break the symmetry "
          "with probability one, never with certainty within bounded steps (Itai and Rodeh 1990). Against Friston, "
          "Levin, Sengupta and Pezzulo "
          "(2015): their scheme, initial expectations independent and of one law, a signal symmetric in the cells "
          "and small independent noise, has the law's form, and the paper never claims which cell takes which place, "
          "so the law forbids nothing of it. Exchangeable laws staying exchangeable is classical; new are the join to "
          "the core's descent, its field, update and run, and the reading. Graded in UE24's NOTE.",
    'zh': 'Curie 原理（Curie 1894；Chalmers 1970，British Journal for the Philosophy of Science 21）之非决定论形式：对称之因给出效应之对称分布'
          '（Ismael 1997，Synthese 110；Castellani、Ismael 2016，Philosophy of Science 83）；自发对称破缺：律所保之对称只于实现中破（Earman 2004）；'
          '无确定之规则能于同等相待之匿名处理器中择出其一（Angluin 1980），而各有一独立之硬币则以概率一破对称，然于有界之步内从不必然（Itai、Rodeh 1990）。针对 Friston、Levin、Sengupta、Pezzulo（2015）：其方案（初始期望独立同律、信号于诸细胞对称、'
          '小而独立之噪声）合此律之形式，且论文从未称何细胞得何位，故此律不禁其任何陈述。可交换之律保持可交换为经典；新者为与核心之下降（其场、更新与运行）相接及其读法。分级见 UE24 之 NOTE。'})
validation = capped('validation_scope', {
    'en': f'Machine-checked by the periphery checker check_cells_under_noise.py with Lean 4.30.0-rc2 and the pinned '
          f'Mathlib (receipt {RECEIPT_ID}): all {COUNT} declarations of CellsUnderNoise, each on Lean\'s standard '
          f'axioms only, every core module of its closure, Becoming.FreeEnergyGuarantees among them, matching a passed '
          f'core receipt. An independent review by another AI agent (REVIEW-UE24)'
          f'{" and its recheck (RECHECK-UE24)" if HAS_RECHECK else ""}, study section {N}; not reviewed by a person.',
    'zh': f'外围检查器 check_cells_under_noise.py 以 Lean 4.30.0-rc2 与固定之 Mathlib 实查（回执 {RECEIPT_ID}）：CellsUnderNoise 之全部 {COUNT} '
          f'项声明，皆只依 Lean 之标准公理，其闭包之每一核心模块（含 FreeEnergyGuarantees）皆合于已通过之核心回执。另一 AI 代理作独立审查（REVIEW-UE24）'
          f'{"及复查（RECHECK-UE24）" if HAS_RECHECK else ""}，见研究第 {N} 节；未经人审。'})
counterexamples = [
    {'en': "A field reading the state of the first cell reads no cell's number, yet, not being exchangeable, from the "
           "parted half and half, an exchangeable start, with no noise it gives one assignment weight one and the two "
           "cells different laws (Witness.firstCell_assigns).",
     'zh': '读第一细胞之状态之场不读细胞之编号，然以其不可交换，自可交换之起点分开之各半，无噪声，予一指派以权重一，二细胞之律相异（Witness.firstCell_assigns）。'},
    {'en': "A kernel commuting with exchanging two cells parts two alike cells with certainty: it is the fair mixture "
           "of two rules assigning the places by the cells' numbers, and no noise of one law at every cell "
           "(Witness.alike_none, Witness.toParted_eq_mixture, Witness.toParted_not_noisyDescent).",
     'zh': '与交换二细胞可交换之核必然分开二相同之细胞：其为依细胞之编号指派位置之二规则之公平混合，且非每一细胞同一律之噪声（Witness.alike_none、'
           'Witness.toParted_eq_mixture、Witness.toParted_not_noisyDescent）。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


# the identical-cells record's fields, before anything is written
i = load(RIDI)
assert i['does_not_show'][1]['en'].startswith('Anything of densities, variational free energy, noise')
assert i['does_not_show'][2]['en'].startswith('Exchanges of other than neighbouring cells')
i_dns1 = capped('does_not_show', {
    'en': "Densities, variational free energy or continuous time. With noise the law does not apply, as independent "
          "fluctuations can part alike cells; what holds instead for finite Markov chains, an exchangeable law, is "
          "stated in the periphery.",
    'zh': '密度、变分自由能或连续时间。有噪声时此律不适用，独立之涨落能分开相同之细胞；有限马尔可夫链于此所成立者（律保持可交换）述于外围。',
    'kind': 'scope'}, item=True)
i_dns2 = capped('does_not_show', {
    'en': "Exchanges of any two cells in the pure core, shown in the periphery for every rearrangement "
          "(ofFn_rearranged), or which asymmetry differentiates actual cells.",
    'zh': '纯核心中任二细胞之交换（外围已示于每一重排，ofFn_rearranged），或何种不对称分化实际之细胞。', 'kind': 'scope'}, item=True)
OLD_NEXT = {'en': 'exchanges of any two cells; ', 'zh': '任二细胞之交换；'}
NEW_NEXT = {'en': 'exchanges of any two cells in the pure core; ', 'zh': '纯核心中任二细胞之交换；'}
for lang in ('en', 'zh'):
    assert i['next_delta'][lang].count(OLD_NEXT[lang]) == 1, ('next', lang)
i_next = capped('next_delta', {k: i['next_delta'][k].replace(OLD_NEXT[k], NEW_NEXT[k]) for k in ('en', 'zh')})
i_dns = i['does_not_show'][:1] + [i_dns1, i_dns2] + i['does_not_show'][3:]
assert not lint_errors({'schema_version': 2, 'id': RID, 'title': title, 'statement': statement, 'laws': laws,
                        'hypotheses': hypotheses, 'does_not_show': does_not_show,
                        'counterexamples': [{'detail': x} for x in counterexamples],
                        'validation_scope': validation, 'next_delta': next_delta,
                        'correspondence': correspondence})
assert not lint_errors({'schema_version': 2, 'id': RIDI, 'title': i['title'], 'statement': i['statement'],
                        'laws': i['laws'], 'hypotheses': i['hypotheses'], 'does_not_show': i_dns,
                        'counterexamples': i['counterexamples'], 'validation_scope': i['validation_scope'],
                        'next_delta': i_next, 'correspondence': i['correspondence']})
if CAPS_ONLY:
    print(f'caps: ok; {len(cited)} declarations in {len(laws)} laws; statement', len(statement['en']),
          len(statement['zh']), '; correspondence', len(correspondence['en']), len(correspondence['zh']),
          '; laws max', max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws),
          '; validation', len(validation['en']), len(validation['zh']))
    raise SystemExit(0)


def core_receipt_for(module, path):
    """The latest passed core receipt holding the module's current bytes."""
    digest = sha(path)
    runs = sorted((ROOT / PKG / 'becoming-checks').glob('2*/verification.json'), reverse=True)
    for run in runs:
        data = json.loads(run.read_text())
        if data.get('status') == 'passed' and data.get('source_sha256', {}).get(module) == digest:
            return str(run.relative_to(ROOT))
    raise SystemExit(f'no passed core receipt holds {module} as it is')


core_receipt = core_receipt_for('Becoming.FreeEnergyGuarantees', FEG)
record = {
    'schema_version': 2,
    'id': RID,
    'title': title,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': statement,
    'laws': laws,
    'hypotheses': hypotheses,
    'does_not_show': does_not_show,
    'counterexamples': [{'path': MODULE, 'detail': x} for x in counterexamples],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': MODULE,
    'aliases': ['Identical cells under noise', '噪声下之同一细胞', 'exchangeable law', 'Curie\'s principle with noise',
                'symmetric distribution of effects', 'Becoming.CellsUnderNoise.noisyDescent_exchangeable',
                'Becoming.CellsUnderNoise.noisyDescent_distinct_le'],
    'dependencies': [
        {'id': RIDI, 'relation': 'formal-reuse',
         'detail': {'en': 'exchangeAt, descent, Exchangeable, Symmetric and Law.run: the core\'s descent on identical '
                          'cells, its exchange of neighbouring cells and its run, read with noise over the reals.',
                    'zh': 'exchangeAt、descent、Exchangeable、Symmetric 与 Law.run：核心之同一细胞之下降、其相邻细胞之交换及其运行，于实数上加噪声而读。'}}],
    'related': [
        {'id': RIDS, 'detail': {
            'en': "Selection through a model of the options: a choice reading the options only through a full tie "
                  "singles out none; independent noise at each cell parts identical cells with positive weight, "
                  "never with certainty (alike_positive, Witness.independentNoise_parts).",
            'zh': '经选项之模型之选择：唯经全并读选项之选择不择出任一；每一细胞独立之噪声以正权重分开同一细胞，然从不必然（alike_positive、Witness.independentNoise_parts）。'}}],
    'references': [{'path': MODULE, 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(MODULE)},
                   {'path': FEG, 'role': 'proof', 'sha256': sha(FEG)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': core_receipt, 'role': 'receipt', 'sha256': sha(core_receipt)},
                   {'path': CHECKER, 'role': 'integration', 'sha256': sha(CHECKER)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)}]
                  + ([{'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)}] if HAS_RECHECK else [])
                  + [{'path': CH5, 'role': 'statement', 'sha256': sha(CH5)}],
    'proof_bindings': [
        {'source': FEG, 'receipt': core_receipt, 'sha256_pointer': '/source_sha256/Becoming.FreeEnergyGuarantees',
         'success_pointer': '/status', 'success_value': 'passed'},
        {'source': MODULE, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/CellsUnderNoise',
         'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'{DATE_EN}: added (UE24), identical cells under noise in the periphery: kernels commuting with every '
              f'rearrangement keep an exchangeable law exchangeable, deciding nothing of which cell takes which place; '
              f'the join to the core\'s descent, its every rearrangement and its run; witnesses on two cells, independent '
              f'noise parting them with positive weight, a kernel parting them with certainty that reads the cells\' '
              f'numbers, and a field reading the first cell; after a review'
              f'{" and its recheck" if HAS_RECHECK else ""}; study section {N}.',
        'zh': f'{DATE_ZH}：新增（UE24），外围之噪声下之同一细胞：与每一重排可交换之核保可交换之律可交换，于何细胞得何位一无所定；与核心之下降、其每一重排及其运行相接；'
              f'二细胞之见证：独立之噪声以正权重分开之，依细胞编号之核必然分开之，及读第一细胞之场；经审查{"及复查" if HAS_RECHECK else ""}；研究第 {N} 节。'}],
}
for rid in [x['id'] for x in record['dependencies'] + record['related']]:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists(), path
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(groups), 'laws; core receipt', core_receipt)

# identical-cells-under-a-descent-treating-them-alike
i['does_not_show'] = i_dns
i['next_delta'] = i_next
assert RID not in [x['id'] for x in i['related']]
i['related'].append({'id': RID, 'detail': {
    'en': "Identical cells under noise: over the reals, in the periphery, under the descent with an exchangeable field "
          "and noise of one law at every cell, the law stays exchangeable, deciding nothing of which cell takes which "
          "place; the exchanges of neighbouring cells generate every rearrangement.",
    'zh': '噪声下之同一细胞：于外围之实数上，于场可交换、每一细胞噪声同律之下降，律保持可交换，于何细胞得何位一无所定；相邻细胞之交换生成每一重排。'}})
for r in i['references']:
    if r['path'] in (CH5, STUDY):
        r['sha256'] = sha(r['path'])
i['history'].append({
    'en': f'{DATE_EN}, board item UE24 (study section {N}): related to {RID}; the second and third does-not-show items '
          f'say that with noise the law does not apply and what holds instead is stated in the periphery, and that '
          f'every rearrangement is shown there, and the next step asks for exchanges of any two cells in the pure core. '
          f'No statement, law or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE24（研究第 {N} 节）：与 {RID} 相关联；所不示之第二与第三项改称有噪声时此律不适用、所成立者述于外围，及每一重排已示于彼处；'
          f'下一步改为纯核心中任二细胞之交换。无一陈述、律或声明改变。'})
save(RIDI, i)
print('records related here:', RIDI)
