#!/usr/bin/env python3
"""UE26: join Becoming.BlanketWeights to the core as a leaf importing Becoming.Blanket and Becoming.Flow, and add the
periphery module LinearBlankets with its checker. Copies the new core module (no landed module changes); adds it to
the checker's core list after Becoming.Blanket, with its scope sentence after the blanket's; imports it in the root
module after Blanket, with an L1 bullet after Blanket's; adds the package README rows (EN and ZH, after Blanket's);
copies LinearBlankets.lean and check_linear_blankets.py into lean/free-energy/; adds the two records and the core
module to regions.json; copies UE26's study folder (the design, the review, the literature check, the recheck, the
probes, history/ and this kit, without the scratch build) and the two move receipts of its design into the landing
worktree. Every backticked BlanketWeights name the texts cite is checked against the kit's scratch-build axiom audit.
Mirrors UE25's integrate_ue25.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue26.py"""
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
AUDIT = HERE / 'tree/.build/BecomingBlanketWeightsAxiomAudit.lean'
LEANR = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = LEANR / 'becoming'
FE = LEANR / 'free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
WORK = ROOT / RF / 'development/ue26-blankets-at-a-steady-state'
MOVES = ('moves-2026-10-31-ue26-design.json', 'moves-2026-10-31-ue26-draft-modes.json')
CORE_ID, LINEAR_ID = 'the-blanket-at-a-steady-state', 'the-blanket-in-a-linear-steady-state'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
assert len(NAMES) == 90, len(NAMES)


def cited(text):
    """Every backticked BlanketWeights name in text is a declaration of the module."""
    names = set(re.findall(r'`(BlanketWeights\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# UE26's study folder, as it stands beside this kit (the landing commits it), and its move receipts
STUDY_SRC = HERE.parent
if WORK.resolve() != STUDY_SRC.resolve():
    WORK.mkdir(parents=True, exist_ok=True)
    for name in ('DESIGN.md', 'REVIEW-UE26-DESIGN.md', 'LITERATURE-CHECK.md', 'RECHECK-UE26.md',
                 'REVIEW-UE26-LANDING.md'):
        shutil.copyfile(STUDY_SRC / name, WORK / name)
    for folder in ('history', 'probes', 'review-probes', 'review-landing'):
        shutil.copytree(STUDY_SRC / folder, WORK / folder, dirs_exist_ok=True,
                        ignore=shutil.ignore_patterns('__pycache__'))
    shutil.copytree(HERE, WORK / 'kit', dirs_exist_ok=True,
                    ignore=shutil.ignore_patterns('.build', '__pycache__', '*.log'))
    moves_src = STUDY_SRC.parents[4] / 'architecture/moves'
    for name in MOVES:
        target = ROOT / '_process/architecture/moves' / name
        if not target.exists():
            shutil.copyfile(moves_src / name, target)

# the core module
target = PKG / 'Becoming/BlanketWeights.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/BlanketWeights.lean', target)

# the periphery module and its checker
for name in ('LinearBlankets.lean', 'check_linear_blankets.py'):
    assert not (FE / name).exists(), name
    shutil.copyfile(HERE / 'periphery' / name, FE / name)

# the checker: core list and scope
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Blanket", "Becoming.LumpedSeeking"',
     '"Becoming.Blanket", "Becoming.BlanketWeights", "Becoming.LumpedSeeking"')
edit(checker, '''under which it is of least surprisal, and a listed outcome is forbidden exactly where its weight is nothing. "
    "What seeking cannot separate:''', '''under which it is of least surprisal, and a listed outcome is forbidden exactly where its weight is nothing. "
    "The blanket at a steady state: on natural weights of internal, blanket and external states, conditional "
    "independence given the blanket, shares under restriction to an external record, follows on listed states from "
    "the joint weight factoring given the blanket, the cross form there, and gives both back on listings listing "
    "each state once, product weights at one blanket state its case; "
    "where the internal moves are in detailed balance with a positive weighting, within one closure of moves present "
    "at positive rate at every external state, each such move's rate ratio reading no external state, the weighting "
    "is in cross form, no steady state assumed, and a positive weighting in cross form in detailed balance has its "
    "ratios reading no external state; witnesses: a lag relay whose steady weights are not independent, a turning "
    "chain circulating with them independent, rates reading the external state with them independent, moves reading "
    "it without, a synchronous copy independent when exact and not with a miss, a blanketed run's occupation "
    "weighting not in cross form, and the cross form on listings not covering the types without it over the types. "
    "What seeking cannot separate:''')

# the root module: import and L1 bullet
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Blanket\n', 'import Becoming.Blanket\nimport Becoming.BlanketWeights\n')
BULLET = """* `Becoming.BlanketWeights` (L1): the free-energy principle's statistical blanket, conditional
  independence given the blanket at a steady state, and what holds it. On natural weights of internal,
  blanket and external states, independence given the blanket on the theory's conditioning
  (`BlanketWeights.IndependentGiven`) is the cross form on the listed states, the converse on listings
  listing each state once (`BlanketWeights.independentGiven_of_crossFormOn`,
  `BlanketWeights.crossFormOn_of_independentGiven`),
  `ConditionalWeights.restrict_independent` its case at one blanket state
  (`BlanketWeights.restrict_independent_case`). Where the internal moves are in detailed balance with a
  positive weighting, within one closure (`«所闭»`) of moves present at every external state, each such
  move's rate ratio reading no external state, the weighting is in cross form
  (`BlanketWeights.crossForm_of_detailedBalance`), Kelly's proof at the internal site, no steady state
  assumed. Witnesses: a lag relay whose steady weights are not independent given the blanket
  (`BlanketWeights.LagRelay.not_independentGiven`), a turning chain circulating with them independent
  (`BlanketWeights.Turning.independentGiven`), moves reading the external state
  (`BlanketWeights.MovesReadExternal.not_crossForm`), a synchronous kernel whose factors read, by its
  construction, what the blanketed law lets them read, independent when exact and not with a miss (`BlanketWeights.SynchronousCopy.exact_independentGiven`,
  `BlanketWeights.SynchronousCopy.noisy_not_independentGiven`), and a blanketed run's occupation
  weighting (`BlanketWeights.Cycle.not_crossForm`). A leaf importing `Becoming.Blanket` and
  `Becoming.Flow` (board item UE26); the linear case is the periphery's `LinearBlankets`.
"""
lines = root.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines)
      if line.startswith('* `Becoming.LumpedSeeking` (L') and 'board item UE18' in lines[i - 1]]
assert len(at) == 1, at
lines[at[0]:at[0]] = cited(BULLET).rstrip('\n').split('\n')
root.write_text('\n'.join(lines), encoding='utf-8')


def readme_row(path, after, row):
    rows = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(rows) if line.startswith(f'| L1 | [`{after}`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.BlanketWeights`]' in line for line in rows)
    rows[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme_row(PKG / 'README.md', 'Becoming.Blanket',
           '| L1 | [`Becoming.BlanketWeights`](Becoming/BlanketWeights.lean) | the blanket at a steady state (no ethical '
           'predicate): conditional independence given the blanket, on the theory\'s conditioning, is the cross form '
           'on the listed states, the converse on listings listing each state once '
           '(`BlanketWeights.independentGiven_of_crossFormOn`, `BlanketWeights.crossFormOn_of_independentGiven`); with '
           'a positive weighting, detailed balance of the internal moves within one closure of moves present at every '
           'external state, each move\'s rate ratio reading no external state, gives it '
           '(`BlanketWeights.crossForm_of_detailedBalance`), sufficient, not necessary: a lag relay loses it '
           '(`BlanketWeights.LagRelay.not_independentGiven`), a turning chain circulates and keeps it '
           '(`BlanketWeights.Turning.independentGiven`), and a synchronous copy keeps it when exact and loses '
           'it with a miss (`BlanketWeights.SynchronousCopy.noisy_not_independentGiven`) |')
readme_row(PKG / 'README.zh.md', 'Becoming.Blanket',
           '| L1 | [`Becoming.BlanketWeights`](Becoming/BlanketWeights.lean) | 稳态之毯（无伦理谓词）：依理论之条件化，予毯之条件独立即所列诸态上之交叉形式，逆向于每态列一次之列'
           '（`BlanketWeights.independentGiven_of_crossFormOn`、`BlanketWeights.crossFormOn_of_independentGiven`）；权皆正，内部诸移于每一外部态皆在之移之'
           '一闭包内细致平衡、每移之率比不读外部态，则予之（`BlanketWeights.crossForm_of_detailedBalance`），为充分而非必要：滞后之传递失之'
           '（`BlanketWeights.LagRelay.not_independentGiven`），转动之链环流而保之（`BlanketWeights.Turning.independentGiven`），同步复制'
           '精确时保之、有失时失之（`BlanketWeights.SynchronousCopy.noisy_not_independentGiven`） |')

# regions: the records and the core module
regions = ROOT / 'theories/becoming/results/data/regions.json'
data = json.loads(regions.read_text(encoding='utf-8'))
assert CORE_ID not in data['records'] and LINEAR_ID not in data['records']
assert 'Becoming.BlanketWeights' not in data['modules']
data['records'][CORE_ID] = {'region': 'knowing', 'base': 'general', 'note': (
    'BlanketWeights UE26: conditional independence given the blanket is the cross form on states each listed once; '
    'with positive weights, detailed balance of the internal moves within one closure of moves present at every '
    'external state, rate ratios reading none, gives it, sufficient, not necessary; witnesses on either side, the '
    'synchronous copy among them')}
data['records'][LINEAR_ID] = {'region': 'knowing', 'base': 'periphery', 'note': (
    'LinearBlankets UE26: the linear steady state, Helmholtz as Lyapunov; footnote 13 as a law; the term-by-term '
    'corollaries; sparsely coupled Euler-Maruyama runs keep the coupling form, while the synchronous steady law can '
    'lose the zero with circulation, a witness (periphery)')}
data['modules']['Becoming.BlanketWeights'] = {'region': 'knowing', 'base': 'general',
                                              'note': 'UE26 the blanket at a steady state (03 §1)'}
data['records'] = dict(sorted(data['records'].items()))
data['modules'] = dict(sorted(data['modules'].items()))
text = regions.read_text(encoding='utf-8')
regions.write_text(json.dumps(data, ensure_ascii=False, indent=1) + ('\n' if text.endswith('\n') else ''),
                   encoding='utf-8')
print('integrated: Becoming.BlanketWeights joined (root import and L1 bullet, checker core list and scope, README rows '
      'EN and ZH); LinearBlankets and its checker in free-energy/; regions; UE26\'s folder and move receipts copied; '
      'no landed module changed')
