#!/usr/bin/env python3
"""UE1b: join Becoming.SetPointOptimum to the core and land the rule 9 refactor of Becoming.Optimum.

Copies the module into the package; replaces Becoming/Optimum.lean with the kit's copy, only after asserting that the
landed file is still the one LANDING.md records; imports the module in the root module after Becoming.Optimum, with an
L1 bullet after Optimum's, and extends Optimum's bullet with the one law of the exchange; adds the module to the
checker's core list after Becoming.RegimeMargin, its SCOPE sentence before SelectionPool's, and a clause to Optimum's; adds
its rows to the package README (EN, ZH) after Optimum's, and a clause to Optimum's rows. Every edit asserts that it
applies exactly once. Mirrors UE1's integrate_ue1.py.

usage (from the checkout root of the landing worktree, after UE4's and UE2's landings):
  python3 -B <kit>/integrate_ue1b.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
LANDED_OPTIMUM = '3da737a69545d00146977487c4e287526233d6db927f5606fe0ae94031621d3f'
KIT_OPTIMUM = '6b8c4e2024cf6f5d8b1ffc1dd5cf8849f032e2bc118c23ed76c4f20f9eaeb6dc'
KIT_MODULE = '22b6140d3a4cc2631a1f125b3a39395f8140d264431ed0ef3d145864a204253a'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


def insert_row(path, after_prefix, row, new_prefix):
    text = path.read_text(encoding='utf-8')
    lines = text.split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(after_prefix)]
    assert len(at) == 1, (path.name, at)
    assert not any(line.startswith(new_prefix) for line in lines), (path.name, 'row present')
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')


# The module, as reviewed and re-checked.
module = HERE / 'tree/Becoming/SetPointOptimum.lean'
target = PKG / 'Becoming/SetPointOptimum.lean'
assert not target.exists()
assert sha(module) == KIT_MODULE, ('the kit module is not the re-checked one', sha(module))
shutil.copyfile(module, target)

# The rule 9 refactor of Optimum, only over the landed file LANDING records (the lander's decision, Optimum's owner
# being inactive): three general laws added, the three rising laws made their corollaries, statements unchanged.
optimum = PKG / 'Becoming/Optimum.lean'
assert sha(optimum) == LANDED_OPTIMUM, ('Becoming/Optimum.lean changed since LANDING.md; redo the refactor on it',
                                        sha(optimum))
assert sha(HERE / 'tree/Becoming/Optimum.lean') == KIT_OPTIMUM
shutil.copyfile(HERE / 'tree/Becoming/Optimum.lean', optimum)

# The root module: the import, Optimum's bullet extended, and the module's bullet after Optimum's.
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Optimum\n', 'import Becoming.Optimum\nimport Becoming.SetPointOptimum\n')
edit(root, """  need exceeds what the rest leaves less the capacity.
  Several optimizers at a mutual best response,""", """  need exceeds what the rest leaves less the capacity.
  One law carries the drain read off the exchange: an optimum takes the whole capacity at a
  condition beyond wherever its order ranks above it the outcome with one unit moved from there
  into the family (`Above.full_of_ranked`, `Above.floor_or_full_of_ranked`, `beyond_of_ranked`),
  as every rising order does.
  Several optimizers at a mutual best response,""")
edit(root, """  returns more than one for one.
* `Becoming.SelectionPool` (L1):""", """  returns more than one for one.
* `Becoming.SetPointOptimum` (L1): what an order with a set point does beyond what couples in. An
  order nearing a set point of the family ranks above every outcome lying, at each condition,
  between the set point and the other and nearer at one (`Nearing`, by `Regulation.Between`):
  strictly single-peaked at the set point condition by condition. Where the family holds a
  condition, no asymmetric nearing order is rising (`Nearing.not_rising`). Where an eligible
  outcome reaches the set point every optimum stands at it (`atSetPoint_of_reach`), and nearing
  alone asks nothing more of what lies beyond (`optima_iff`, `least_at_iff`; near-definitional);
  below the set point the order rises and the drain of `Optimum` returns (`least_below_iff`; in an
  exchange `nearing_beyond`, from `Optimum.beyond_of_ranked`). In a balanced step in which the
  whole gains nothing the beyond falls by the family's shortfall from its set point with the loss
  (`Flow.Balances.atSetPoint_draws`), a dependence on one condition beyond breaking exactly where
  that exceeds its slack (`Flow.Balances.atSetPoint_broken_iff`), for several optimizers as for
  one with their joint set point (`Flow.Balances.mutual_atSetPoint_breaks`). A term counted after
  the set point leaves the most beyond, in total, that any way of reaching it leaves
  (`counted_after_most`, near-definitional); counting less, it drains
  (`Topped.counted_less_drains`); after an aspiration level it keeps too
  (`Drain.satisficingThen_keeps`): the plateau decides, not the set point. Formations holding their
  families' stocks take at least their loss and end a gated condition jointly, no order or choice
  entering (`Flow.held_draws`, `Flow.held_excess_ends`, from `Flow.joint_excess_ends`). A leaf: its
  laws are cases of `Optimum`'s, `DrawnBeyond`'s and `Continuation`'s on one class of orders, read
  on active inference (board item UE1b).
* `Becoming.SelectionPool` (L1):""")

# The checker: the core list, the module's SCOPE sentence after Optimum's, and a clause in Optimum's.
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ReadingSchedule", "Becoming.RegimeMargin", ',
     '"Becoming.ReadingSchedule", "Becoming.RegimeMargin", "Becoming.SetPointOptimum", ')
edit(checker, 'with no floor, at that or at nothing; ',
     'with no floor, at that or at nothing; "\n'
     '    "each of these holds wherever the order ranks above the optimum the outcome with one unit "\n'
     '    "moved from that condition into the family, as every rising order does; ')
edit(checker, """    "SelectionPool: a pool's coupling closure is the union of its members'; with the rest fixed, \"""",
     """    "SetPointOptimum: an order nearing a set point of the family ranks above every outcome lying, at "
    "each condition, between the set point and the other and nearer at one; where the family holds a "
    "condition no asymmetric such order is rising; where an eligible outcome reaches the set point "
    "every optimum stands at it, and the optima of the class are exactly the eligible outcomes at the "
    "set point; below the set point the order rises and the drain of Optimum returns, in an exchange "
    "by the whole capacity; in a balanced step in which the whole gains nothing the beyond falls by the "
    "family's shortfall from its set point with the loss, a dependence on one condition beyond breaking "
    "exactly where that exceeds its slack; a term counted after the set point leaves the most beyond in "
    "total that any way of reaching it leaves, and counting less drains; formations holding their "
    "families' stocks take at least their loss and end a gated condition jointly, no order or choice "
    "entering. "
    "SelectionPool: a pool's coupling closure is the union of its members'; with the rest fixed, \"""")

# The package README, EN and ZH: the module's row after Optimum's, and a clause in Optimum's row.
readme = PKG / 'README.md'
edit(readme, 'every optimum stands beyond at what the rest leaves less the capacity (`Optimum.optimum_beyond`)',
     'every optimum stands beyond at what the rest leaves less the capacity (`Optimum.optimum_beyond`), the three '
     'by one law, wherever the order ranks above the optimum the outcome with one unit moved into the family '
     '(`Optimum.Above.full_of_ranked`, `Optimum.Above.floor_or_full_of_ranked`, `Optimum.beyond_of_ranked`)')
insert_row(readme, '| L1 | [`Becoming.Optimum`]',
           '| L1 | [`Becoming.SetPointOptimum`](Becoming/SetPointOptimum.lean) | what an order with a set point does '
           'beyond what couples in (no premise beyond the hypotheses named): an order nearing a set point '
           '(`Optimum.Nearing`, by `Regulation.Between`) is, where the family holds a condition and the order is '
           'asymmetric, not rising (`Optimum.Nearing.not_rising`); where the set point can be reached every optimum '
           'stands at it (`Optimum.atSetPoint_of_reach`) and the class asks nothing more of what lies beyond '
           '(`Optimum.optima_iff`, `Optimum.least_at_iff`); below it the drain returns (`Optimum.least_below_iff`, '
           '`Optimum.nearing_beyond`); the draw at the set point is the shortfall with the loss '
           '(`Flow.Balances.atSetPoint_draws`, `Flow.Balances.atSetPoint_broken_iff`), jointly as one '
           '(`Flow.Balances.mutual_atSetPoint_breaks`); counted after the set point, the most beyond in total '
           '(`Optimum.counted_after_most`, `Optimum.counted_after_keeps_iff`); holding a level takes at least the '
           'loss and ends a gated condition jointly (`Flow.held_draws`, `Flow.held_excess_ends`) |',
           '| L1 | [`Becoming.SetPointOptimum`]')

readme_zh = PKG / 'README.zh.md'
edit(readme_zh, '每个最优在之外处立于其余者所留减去容量（`Optimum.optimum_beyond`）',
     '每个最优在之外处立于其余者所留减去容量（`Optimum.optimum_beyond`），三者同出一律：凡其序将移一单位入族之结果排于该最优之上者皆然'
     '（`Optimum.Above.full_of_ranked`、`Optimum.Above.floor_or_full_of_ranked`、`Optimum.beyond_of_ranked`）')
insert_row(readme_zh, '| L1 | [`Becoming.Optimum`]',
           '| L1 | [`Becoming.SetPointOptimum`](Becoming/SetPointOptimum.lean) | 有设定点之序在所耦合者之外所为（除所列假设外'
           '不加前提）：趋近设定点之序（`Optimum.Nearing`，以 `Regulation.Between` 定），族含一个条件且序不对称时，皆非升高的序'
           '（`Optimum.Nearing.not_rising`）；设定点可及处，每个最优皆立于其上（`Optimum.atSetPoint_of_reach`），此类序于其外'
           '别无所求（`Optimum.optima_iff`、`Optimum.least_at_iff`）；设定点之下，抽取复现（`Optimum.least_below_iff`、'
           '`Optimum.nearing_beyond`）；在设定点所抽为其缺额连同损耗（`Flow.Balances.atSetPoint_draws`、'
           '`Flow.Balances.atSetPoint_broken_iff`），众者合抽如一（`Flow.Balances.mutual_atSetPoint_breaks`）；计于设定点之后者，'
           '留其外之总量最多（`Optimum.counted_after_most`、`Optimum.counted_after_keeps_iff`）；持其水平者至少取其损耗，合而终结'
           '受闸之条件（`Flow.held_draws`、`Flow.held_excess_ends`） |',
           '| L1 | [`Becoming.SetPointOptimum`]')

print('integrated: Becoming.SetPointOptimum joined (root import and bullet, checker core list and scope, README rows);'
      ' Becoming.Optimum refactored (rule 9: three general laws, the rising laws their corollaries)')
