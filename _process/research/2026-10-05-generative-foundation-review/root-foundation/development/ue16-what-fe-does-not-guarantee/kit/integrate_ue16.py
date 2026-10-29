#!/usr/bin/env python3
"""UE16: join Becoming.FreeEnergyGuarantees to the core as a leaf. Copies the new module (no landed module changes);
adds it to the checker's core list (after Becoming.ReorderingGrowth, UE15's module) and its scope text (after
reordering growth's); imports it in the root module with an L1 doc bullet after ReorderingGrowth's (its imports,
Commuting, Exclusion and SetPointOptimum, are L1, and it names no ethical predicate); adds the package README rows (EN, ZH) after
ReorderingGrowth's. Every name the texts cite is checked against the scratch build's axiom audit. Mirrors UE15's
integrate_ue15.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue16.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDIT = HERE.parent / 'tree/.build/BecomingFreeEnergyGuaranteesAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked FreeEnergyGuarantees name in text is a declaration of the module."""
    names = set(re.findall(r'`(FreeEnergyGuarantees\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


target = PKG / 'Becoming/FreeEnergyGuarantees.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'FreeEnergyGuarantees.lean', target)

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ReorderingGrowth", ', '"Becoming.ReorderingGrowth", "Becoming.FreeEnergyGuarantees", ')
edit(checker, """    "through a dependence and by moving a relatum and moving it back. "
    "Standpoints: """, """    "through a dependence and by moving a relatum and moving it back. "
    "Free-energy guarantees: under a descent moving every cell by one rule from its own state and a field that "
    "reads no cell's number, cells alike at the start stay alike, and with the field exchangeable the descent "
    "commutes with exchanging neighbouring cells and the minima of a free energy symmetric in the cells, among "
    "configurations of one number of cells, come in exchanged pairs; a member outside the rest, choosing the "
    "amount whose predicted level lies nearest its preferred level, has its need end whatever its model where the "
    "rest outruns a gated renewal; holders of one model, each taking its choice of least risk at its own store, each "
    "store at its set point, end the shared renewal, and three regulators of the shared level end it at once. "
    "Standpoints: """)

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.ReorderingGrowth\n', 'import Becoming.ReorderingGrowth\nimport Becoming.FreeEnergyGuarantees\n')
edit(root, """  lemma or a witness. A leaf (board item UE15).
* `Becoming.Growth` (L1):""", """  lemma or a witness. A leaf (board item UE15).
* `Becoming.FreeEnergyGuarantees` (L1): what free-energy minimization does not guarantee, the
  free-energy principle's third parts on explicit models in its terms. Under a descent moving every
  cell by one rule from its own state and a field reading no cell's number, two cells alike at the
  start stay alike (`FreeEnergyGuarantees.IdenticalCells.two_alike_stay_alike`); with the field
  exchangeable the descent commutes with exchanging neighbouring cells
  (`FreeEnergyGuarantees.IdenticalCells.descent_commutes`), the exchanged run is the run of the
  exchanged start, and among configurations of one number of cells a unique minimum of a free energy
  symmetric in the cells has its cells alike
  (`FreeEnergyGuarantees.IdenticalCells.unique_minimum_alike`). A member outside the rest choosing,
  under its model, the amount whose predicted level lies nearest its preferred level has its need
  end whatever its model where the rest outruns a gated renewal
  (`FreeEnergyGuarantees.RiskAndNeeds.need_ends`, by the outrun law). Holders of one model, each
  taking, at the two steps they take part, its choice of least risk at its own store, a condition,
  each store at its set point at every step, end the shared renewal
  (`FreeEnergyGuarantees.SharedModels.held_not_one`, by
  `Optimum.HeldPair.held_end`), and three regulators of the shared level end it at the first step
  (`FreeEnergyGuarantees.SharedModels.OneGoal.three_end`). Each law applies a landed law in the
  principle's terms or is a witness. A leaf importing `Becoming.Commuting`, `Becoming.Exclusion`
  and `Becoming.SetPointOptimum` (board item UE16).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.ReorderingGrowth`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.FreeEnergyGuarantees`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.FreeEnergyGuarantees`](Becoming/FreeEnergyGuarantees.lean) | what free-energy minimization does not '
    'guarantee (no ethical predicate): alike cells stay alike under a descent reading no cell\'s number '
    '(`FreeEnergyGuarantees.IdenticalCells.two_alike_stay_alike`); a risk-minimizing member\'s need ends where the rest '
    'outruns a gated renewal (`FreeEnergyGuarantees.RiskAndNeeds.need_ends`); holders of one model meeting their set '
    'points end the shared renewal (`FreeEnergyGuarantees.SharedModels.held_not_one`); applications of landed laws and '
    'witnesses |')
readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.FreeEnergyGuarantees`](Becoming/FreeEnergyGuarantees.lean) | 自由能最小化所不保证者（无伦理谓词）：'
    '于不读细胞编号之下降，相同之细胞保持相同（`FreeEnergyGuarantees.IdenticalCells.two_alike_stay_alike`）；'
    '他者超出门控之更新时，最小化风险之成员之需求终结（`FreeEnergyGuarantees.RiskAndNeeds.need_ends`）；'
    '一模型之持守者各达其设定点而共同终结共享之更新（`FreeEnergyGuarantees.SharedModels.held_not_one`）；已落地之律之应用与例 |')
print('integrated: Becoming.FreeEnergyGuarantees joined (root import and L1 bullet, checker core list and scope, README '
      'rows EN and ZH); no landed module changed')
