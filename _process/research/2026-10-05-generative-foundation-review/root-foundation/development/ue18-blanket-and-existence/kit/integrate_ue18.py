#!/usr/bin/env python3
"""UE18: join Becoming.Blanket to the core as a leaf, after UE16. Copies the new module (no landed module changes);
adds it to the checker's core list (after Becoming.FreeEnergyGuarantees, UE16's module) and its scope text (after the
free-energy guarantees'); imports it in the root module with an L1 doc bullet after FreeEnergyGuarantees' (its import,
ConditionalWeights, is L1, and it names no ethical predicate); adds the package README rows (EN, ZH) after
FreeEnergyGuarantees'. Every name the texts cite is checked against the scratch build's axiom audit. Mirrors UE16's
integrate_ue16.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean, with UE16 landed): python3 -B <kit>/integrate_ue18.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDIT = HERE.parent / 'tree/.build/BecomingBlanketAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked Blanket name in text is a declaration of the module."""
    names = set(re.findall(r'`(Blanket\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


target = PKG / 'Becoming/Blanket.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'Blanket.lean', target)

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.FreeEnergyGuarantees", ', '"Becoming.FreeEnergyGuarantees", "Becoming.Blanket", ')
edit(checker, """three regulators of the shared level end it at once. "
    "Standpoints: """, """three regulators of the shared level end it at once. "
    "The blanket: on a determined law of internal, sensory, active and external parts, the internal and active "
    "parts reading the internal, sensory and active, the sensory and external parts the sensory, active and "
    "external, the agent's course is fixed by its start and its sensory course, so a determined policy is a "
    "selection through the sensory course, bounded by what the sensory part reads of the world; with any model "
    "and policy, a supply read by threshold only is unseen before the break registers, the witness's blanket "
    "being the World's coupling by threshold; the point weighting on a listed outcome is conditioning on it, "
    "under which it is of least surprisal, and a listed outcome is forbidden exactly where its weight is nothing. "
    "Standpoints: """)

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.FreeEnergyGuarantees\n', 'import Becoming.FreeEnergyGuarantees\nimport Becoming.Blanket\n')
edit(root, """  and `Becoming.SetPointOptimum` (board item UE16).
* `Becoming.Growth` (L1):""", """  and `Becoming.SetPointOptimum` (board item UE16).
* `Becoming.Blanket` (L1): the free-energy principle's Markov blanket as a coupling structure, and
  what its existence claim forbids. On a determined law of four parts, told apart only by which part
  reads which, the agent's course is fixed by its start and its sensory course
  (`Blanket.Blanketed.agent_through_sensory`), the world's by the active course, and each side's by
  its start and the blanket's (`Blanket.Blanketed.internal_through_blanket`); where the sensory part
  reads the world only through a map, courses alike through it are alike for the agent
  (`Blanket.Blanketed.through_reading`, 03 §6's lumping). With any model and policy, a supply read
  by threshold only is unseen before the break registers (`Blanket.ThresholdDrain.any_model`), the
  witness's blanket being the World's coupling by threshold
  (`Blanket.ThresholdDrain.blanket_iff_through`). The point weighting on a listed outcome is
  conditioning on it (`Blanket.point_is_restrict`), under which it is of least surprisal
  (`Blanket.least_surprisal`); a listed outcome is forbidden exactly where its weight is nothing
  (`Blanket.forbids_iff`). A leaf importing `Becoming.ConditionalWeights` (board item UE18).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.FreeEnergyGuarantees`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.Blanket`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.Blanket`](Becoming/Blanket.lean) | the Markov blanket as a coupling structure (no ethical predicate): '
    'the agent driven by its sensory course (`Blanket.Blanketed.agent_through_sensory`); with any model and policy a supply '
    'read by threshold unseen before the break (`Blanket.ThresholdDrain.any_model`); a listed outcome forbidden exactly '
    'where its weight is nothing (`Blanket.forbids_iff`) |')
readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.Blanket`](Becoming/Blanket.lean) | 马尔可夫毯作为耦合结构（无伦理谓词）：主体由其感官历程所驱动'
    '（`Blanket.Blanketed.agent_through_sensory`）；无论模型与策略，唯以阈读之供给于断裂前不可见（`Blanket.ThresholdDrain.any_model`）；'
    '列出之结果唯其权重为零时被禁（`Blanket.forbids_iff`） |')
print('integrated: Becoming.Blanket joined (root import and L1 bullet, checker core list and scope, README rows EN and '
      'ZH); no landed module changed')
