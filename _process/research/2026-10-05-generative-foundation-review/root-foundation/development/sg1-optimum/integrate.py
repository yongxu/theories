#!/usr/bin/env python3
"""Join SG1's module Becoming.Optimum to the core package: copy it in, import it after Becoming.JointDraw, add its root
doc bullet after JointDraw's, its CORE entry and scope text in check_becoming.py, and its README rows (EN and ZH, after
DrawnBeyond's).
usage: python3 -B integrate.py   (SG1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG1_ROOT']).resolve() if os.environ.get('SG1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Optimum.lean', PKG / 'Becoming' / 'Optimum.lean')

DOC = (
    '* `Becoming.Optimum` (L1): what optimizing through couplings does beyond them. Over any set of\n'
    '  outcomes, every order rising with the levels of what couples in, whatever it does beyond, has\n'
    '  its optima at the least level beyond, condition by condition, exactly where every outcome\n'
    '  standing above another beyond is not unbeaten on what couples in; shared units, a unit beyond\n'
    '  movable into the family, are one case, and counting the beyond after the family changes\n'
    '  nothing. On a web an optimum breaks exactly the dependences beyond that some outcome breaks,\n'
    '  and with the dependence as it was the formation ends, unseen by every member coupled only into\n'
    '  the family. In balanced steps raising the family is lowering the beyond with the loss, unit for\n'
    '  unit; restricted to outcomes keeping each dependence, the optimum takes exactly the slack.\n'
    '  Witnesses on `Diversion`: the drive, no room, a satisficing order, keeping.\n'
)
SCOPE = (
    '    "Optimum: over any set of outcomes every order rising with the levels of a family, ranking above "\n'
    '    "every outcome that exceeds another on the family whatever either holds beyond, has its optima at "\n'
    '    "the least level beyond, condition by condition, exactly where every eligible outcome standing "\n'
    '    "above another at a condition beyond is not unbeaten on the family; with room, or with shared "\n'
    '    "units moving a unit beyond into the family, every optimum is there, and an order ranking above "\n'
    '    "wherever a rising order does is rising; where the levels after a step are such an optimum and "\n'
    '    "each condition beyond is depended on at a need it meets, a dependence beyond is broken exactly "\n'
    '    "where some eligible outcome leaves its condition below the need, and where activity needs "\n'
    '    "support with the dependence as it was its formation is not active after the step, no member of "\n'
    '    "a group coupled only into the family and coupled into by none; of two balanced steps from equal "\n'
    '    "totals gaining nothing on the whole one leaves the family at most where the other does exactly "\n'
    '    "where it leaves the beyond with the loss at least where the other does; restricted to outcomes "\n'
    '    "keeping each dependence beyond, with room among them and each need attained, the optimum breaks "\n'
    '    "nothing and the family rises with the loss by exactly the slack; Drain: the store\'s optimum "\n'
    '    "drains the source and the dweller ends, counting the source after the store drains it, without "\n'
    '    "room keeping is an optimum, a satisficing order has both the keeping and the draining outcome "\n'
    '    "among its optima, and the keeping optimum takes the slack. "\n')
README_ROW = (
    '| L1 | [`Becoming.Optimum`](Becoming/Optimum.lean) | what optimizing through couplings does beyond them (no premise '
    'beyond what each theorem names; the eligible outcomes, room and the dependences named beyond are hypotheses where '
    'they enter): every order rising with what couples in (`Optimum.Rising`; the family\'s stock is one, '
    '`Optimum.rising_total`, and an order ranking above wherever one does is one, `Optimum.Rising.mono`) has its optima '
    'at the least level beyond exactly where every outcome standing above another beyond is not unbeaten on the family '
    '(`Optimum.least_iff`, `Optimum.least_of_room`), shared units giving room (`Optimum.Shared.room`, '
    '`Optimum.least_of_shared`); an optimum breaks exactly the dependences beyond some outcome breaks '
    '(`Web.optimum_broken_iff`), its formations ending unseen where activity needs support '
    '(`Web.optimum_ends_beyond`); raising the family is lowering the beyond with the loss, unit for unit '
    '(`Flow.Balances.family_le_iff`, `Flow.top_iff_least`); keeping each dependence, the optimum takes exactly the slack '
    '(`Flow.keeping_optimum_takes_slack`); witnesses `Optimum.Drain.drained_ends`, `Optimum.Drain.counted_after_drains`, '
    '`Optimum.Drain.room_needed`, `Optimum.Drain.satisficing_either`, `Optimum.Drain.kept_takes_slack` |')
README_ZH_ROW = (
    '| L1 | [`Becoming.Optimum`](Becoming/Optimum.lean) | 经耦合的最优化对耦合之外做什么（除各定理所列外不加前提；可选的结果、'
    '余地与之外所指名的依存，均为写在定理中的条件）：每个随耦合入者升高的序（`Optimum.Rising`；族的存量是一个，'
    '`Optimum.rising_total`；凡在一个升高的序排得更高处都排得更高的序也是，`Optimum.Rising.mono`），其最优恰在之外最低的水平，'
    '当且仅当每个在之外某条件上高于另一结果的结果都在族上被胜过（`Optimum.least_iff`、`Optimum.least_of_room`），'
    '共享的单位给出余地（`Optimum.Shared.room`、`Optimum.least_of_shared`）；最优恰好打断某个结果所打断的之外的依存'
    '（`Web.optimum_broken_iff`），活动需要支持时其构成在未被看见处结束（`Web.optimum_ends_beyond`）；'
    '升高族即以同等单位降低之外加损失（`Flow.Balances.family_le_iff`、`Flow.top_iff_least`）；保持每个依存时，最优恰取余量'
    '（`Flow.keeping_optimum_takes_slack`） |')

root = (PKG / 'Becoming.lean').read_text()
assert 'import Becoming.Optimum' not in root, 'already integrated'
root = once(root, 'import Becoming.JointDraw\n', 'import Becoming.JointDraw\nimport Becoming.Optimum\n')
root = once(root, '* `Becoming.SelectionPool` (L1): what selection through pooled coupling reaches.',
            DOC + '* `Becoming.SelectionPool` (L1): what selection through pooled coupling reaches.')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '"Becoming.DrawnBeyond", "Becoming.JointDraw",',
           '"Becoming.DrawnBeyond", "Becoming.JointDraw", "Becoming.Optimum",')
chk = once(chk, '    "LawAlongRun: under an equivalence, some process going alike under it admits',
           SCOPE + '    "LawAlongRun: under an equivalence, some process going alike under it admits')
(PKG / 'check_becoming.py').write_text(chk)

for name, row in (('README.md', README_ROW), ('README.zh.md', README_ZH_ROW)):
    rd = (PKG / name).read_text()
    lines = rd.split('\n')
    idx = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.DrawnBeyond`](Becoming/DrawnBeyond.lean) |')]
    assert len(idx) == 1, (name, idx)
    lines[idx[0] + 1:idx[0] + 1] = [row]
    (PKG / name).write_text('\n'.join(lines))
print('integrated')
