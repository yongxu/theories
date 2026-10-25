#!/usr/bin/env python3
"""UE5: join Becoming.SelectionPace to the core: copy the module into the package, import it in the root module after
Becoming.Entropy with a doc bullet after Entropy's, add it to the checker's core list after Becoming.Entropy and to its
scope text after Reproduction's entry, and add its rows to the package README (EN, ZH) after Entropy's. Mirrors UE1's
integrate_ue1.py; every edit asserts that it applies exactly once, and the copy asserts the kit's bytes.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ue5.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
KIT_SHA256 = 'abf440add3b6dd9c9a94ce3f0efe7b4fb9f23f9607fd296a8a9268a96a1a72b3'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


def insert_row(path, prefix, row):
    text = path.read_text(encoding='utf-8')
    assert '[`Becoming.SelectionPace`]' not in text, path.name
    lines = text.split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(prefix)]
    assert len(at) == 1, (path.name, at)
    lines.insert(at[0] + 1, row)
    path.write_text('\n'.join(lines), encoding='utf-8')


source = HERE / 'tree/Becoming/SelectionPace.lean'
assert hashlib.sha256(source.read_bytes()).hexdigest() == KIT_SHA256, 'the kit module is not the reviewed bytes'
target = PKG / 'Becoming/SelectionPace.lean'
assert not target.exists()
shutil.copyfile(source, target)

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Entropy\n', 'import Becoming.Entropy\nimport Becoming.SelectionPace\n')
edit(root, """  exactly what is dissipated is the case of no inflow.
* `Becoming.Units` (L1): the laws of one step at a finer unit, the test of the commitment""",
     """  exactly what is dissipated is the case of no inflow.
* `Becoming.SelectionPace` (L1): the pace of selection, within what flows in (no premise beyond
  the hypotheses named). Across a step at which the flow balances on the family a lineage
  occupies, each offspring coming to stand at `m` or more: offspring listed after some relata,
  `m` for each, are within what those relata stood at and the list's inflow
  (`born_within_inflow`). With exact transmission and each parent standing at no more than `m`,
  the total of an amount rises by at most what flows into each carrying lineage over `m`
  (`total_within_carried`), counted lineage by lineage so that what passes between carrying
  lineages counts; the mean of a population not shrinking rises accordingly
  (`response_within_carried`), and a rise nothing feeds shrinks the population
  (`unfed_rise_shrinks`). For an amount of zero or one, the carriers' rise is within what the
  rest of a whole falls by and what flows into the whole (`share_within_rest`), the law that a
  rise past the inflow is drawn from beyond read on offspring. A cap on what flows into each
  parent's lineage caps the total's growth at `k ^ T` over `T` steps (`total_within_power`,
  `whole_within_power`). Read by offspring number, `m` times its squared differences over pairs
  is at most the size times the next generation's inflow (`number_spread_within_inflow`). The
  natural statement, a pace bounded by what flows into the whole, fails
  (`Displacement.natural_fails`). A leaf: it joins `Becoming.Reproduction` and `Becoming.Entropy`,
  neither of which imports the other, and nothing below needs it (board item UE5).
* `Becoming.Units` (L1): the laws of one step at a finer unit, the test of the commitment""")

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Entropy", ', '"Becoming.Entropy", "Becoming.SelectionPace", ')
edit(checker, """    "SelectionLevels: over a family listed as k groups of equal size, the whole's concordance with k \"""",
     """    "SelectionPace: across a step at which the flow balances on the family a lineage occupies, "
    "offspring each coming to stand at m or more number, m for each, at most what stood and what "
    "flowed in; with exact transmission and each parent standing at no more than m, m times the next "
    "total of an amount is at most m times this one with what flows into each carrying lineage, "
    "counted lineage by lineage, the mean of a population not shrinking rises within it, and a rise "
    "nothing feeds shrinks the population; for an amount of zero or one the carriers' rise is within "
    "what the rest of a whole falls by and what flows into the whole, and within the inflow into "
    "their joint lineage; with what flows into each parent's lineage, with m, at most k m, a parent "
    "leaves at most k offspring and the total grows by at most k^T over T steps; read by offspring "
    "number, m times the squared differences of offspring numbers over pairs is at most the size "
    "times the next generation's inflow, and with offspring number inherited the response of any "
    "amount, squared, is bounded by the next step's inflow; with the inflow into the whole or into "
    "the population's own lineage in place of the carried inflow the response law fails. "
    "SelectionLevels: over a family listed as k groups of equal size, the whole's concordance with k \"""")

insert_row(PKG / 'README.md', '| L1 | [`Becoming.Entropy`]',
           '| L1 | [`Becoming.SelectionPace`](Becoming/SelectionPace.lean) | the pace of selection, within what '
           'flows in (no premise beyond the hypotheses named): offspring, `m` for each, within what stood and what '
           'flowed in (`SelectionPace.born_within_inflow`); with exact transmission and parents standing at no more '
           'than `m`, the total of an amount rises by at most what flows into each carrying lineage over `m`, counted '
           'lineage by lineage (`SelectionPace.total_within_carried`), the mean of a population not shrinking '
           'accordingly (`SelectionPace.response_within_carried`), and a rise nothing feeds shrinks the population '
           '(`SelectionPace.unfed_rise_shrinks`); for an amount of zero or one, the carriers\' rise within what the '
           'rest of a whole falls by and what flows into the whole (`SelectionPace.share_within_rest`); a cap on what '
           'flows into each parent\'s lineage caps the total\'s growth at `k ^ T` (`SelectionPace.total_within_power`); '
           'read by offspring number, its variance within the inflow per member over `m` '
           '(`SelectionPace.number_spread_within_inflow`); with the inflow into the whole in place of the carried '
           'inflow the response law fails (`SelectionPace.Displacement.natural_fails`) |')
insert_row(PKG / 'README.zh.md', '| L1 | [`Becoming.Entropy`]',
           '| L1 | [`Becoming.SelectionPace`](Becoming/SelectionPace.lean) | 选择之速，限于所流入者（除所列假设外不加前提）：'
           '后代各计 `m`，不过所立者与所流入者（`SelectionPace.born_within_inflow`）；传递确切、每亲所立不过 `m` 时，一量之总'
           '所升不过流入各携带者谱系者（逐谱系相加）除以 `m`（`SelectionPace.total_within_carried`），不缩之群其均值亦然'
           '（`SelectionPace.response_within_carried`），无所供之升使群缩（`SelectionPace.unfed_rise_shrinks`）；零一之量，'
           '携带者之升不过整体其余之降与流入整体者（`SelectionPace.share_within_rest`）；流入每亲谱系者有上限，则总之增长不过 '
           '`k ^ T`（`SelectionPace.total_within_power`）；以后代数读之，其方差不过每成员之流入除以 `m`'
           '（`SelectionPace.number_spread_within_inflow`）；以流入整体者代所携流入，则响应之律不成立'
           '（`SelectionPace.Displacement.natural_fails`） |')
print('integrated: Becoming.SelectionPace joined (root import and bullet, checker core list and scope, README rows)')
