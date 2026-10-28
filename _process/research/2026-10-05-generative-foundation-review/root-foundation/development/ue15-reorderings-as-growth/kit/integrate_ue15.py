#!/usr/bin/env python3
"""UE15: join Becoming.ReorderingGrowth to the core as a leaf. Copies the new module (no landed module changes); adds
it to the checker's core list (after Becoming.Presence, UE14's module) and its scope text (after presence's); imports
it in the root module with an L1 doc bullet after Presence's (its import closure holds no L2 module, and it names no
ethical predicate); adds the package README rows (EN, ZH) after Presence's. Every name the texts cite is checked
against the scratch build's axiom audit, so a renamed declaration fails here and not at render. Mirrors UE14's
integrate_ue14.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ue15.py"""
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
AUDIT = HERE.parent / 'tree/.build/BecomingReorderingGrowthAxiomAudit.lean'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked ReorderingGrowth name in text is a declaration of the module."""
    names = set(re.findall(r'`(ReorderingGrowth\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the new module
target = PKG / 'Becoming/ReorderingGrowth.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'ReorderingGrowth.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Presence", ', '"Becoming.Presence", "Becoming.ReorderingGrowth", ')
edit(checker, """    "transitive. Each main law is also stated on the courses of the growth themselves. "
    "Standpoints: """, """    "transitive. Each main law is also stated on the courses of the growth themselves. "
    "Reordering growth: the exchanges of a world's stretch from its first step, ordered by the order of "
    "joined exchanges, form a causal set whose natural labellings are the renumberings keeping that order, "
    "so where the footprint contains the exchanges the numberings a world's reorderings give the stretch "
    "are exactly the orders of birth of the courses of causal-set growth of its order of exchanges, and the "
    "laws of presence on that growth hold on the World's reorderings by instance, each with its decision; "
    "joining decided on the stretch decides the order of exchanges. On the world as it is an exchange is "
    "present when another is taken exactly where it precedes it and no exchange between is joined to it, "
    "and then, where the footprint contains the exchanges, it leaves every relatum it touched as it left "
    "it, on the world and on every reordering on which it is present; two worlds show the converse fails, "
    "through a dependence and by moving a relatum and moving it back. "
    "Standpoints: """)

# the root module: import, and the new bullet after Presence's
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Presence\n', 'import Becoming.Presence\nimport Becoming.ReorderingGrowth\n')
edit(root, """  near-definitional, a lemma, a witness or a calibration. A leaf (board item UE14).
* `Becoming.Growth` (L1):""", """  near-definitional, a lemma, a witness or a calibration. A leaf (board item UE14).
* `Becoming.ReorderingGrowth` (L1): a world's reorderings as the growth of its order of exchanges.
  The exchanges of the first `m` steps, ordered by the order of joined exchanges, form a causal set
  (`ReorderingGrowth.exchanges`, `ReorderingGrowth.exchanges_ordered`) whose natural labellings are the
  renumberings keeping the order of joined exchanges (`ReorderingGrowth.natural_iff`); so, where the
  footprint contains the exchanges, a renumbering of the stretch is the numbering of some reordering
  exactly where it numbers them by a course of causal-set growth from the empty set
  (`ReorderingGrowth.reordering_iff_course`; one course carries several numberings where the order has
  automorphisms, `ReorderingGrowth.VeeWorld.one_course_two_numberings`), and what holds on every or some
  natural labelling holds on every or some reordering (`ReorderingGrowth.every_reordering_iff`,
  `ReorderingGrowth.some_reordering_iff`). Joining decided on the stretch decides the order of exchanges
  (`ReorderingGrowth.precedes_decided`). The laws of presence of `Becoming.Presence` hold on the World's
  reorderings by instance, each with its decision (`ReorderingGrowth.precedes_iff_every_reordering`,
  `ReorderingGrowth.before_some_reordering`, `ReorderingGrowth.antichain_present_reordering`,
  `ReorderingGrowth.present_some_reordering`, `ReorderingGrowth.present_every_reordering`). On the world
  as it is, an exchange is present when another is taken exactly where it precedes it and no exchange
  between is joined to it (`ReorderingGrowth.present_identity_iff`), and then, where the footprint
  contains the exchanges, it leaves every relatum it touched as it left it, on the world and on every
  reordering on which it is present (`ReorderingGrowth.persists_of_present`,
  `ReorderingGrowth.persists_of_present_reordering`); not conversely, through a dependence or by moving a
  relatum and moving it back (`ReorderingGrowth.ByDependence.persists_not_present`,
  `ReorderingGrowth.MovedBack.persists_not_present`); the vee as a world
  (`ReorderingGrowth.VeeWorld.presence_varies`). Each law is near-definitional, a composition, a
  lemma or a witness. A leaf (board item UE15).
* `Becoming.Growth` (L1):""")


def readme_row(path, row):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.Presence`]')]
    assert len(at) == 1, at
    assert not any('[`Becoming.ReorderingGrowth`]' in line for line in lines)
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


# the package README rows (EN, ZH), after Presence's
readme_row(PKG / 'README.md',
    '| L1 | [`Becoming.ReorderingGrowth`](Becoming/ReorderingGrowth.lean) | a world\'s reorderings as the growth of its '
    'order of exchanges (no ethical predicate): the exchanges of a stretch form a causal set whose natural labellings '
    'are the renumberings keeping the order of joined exchanges (`ReorderingGrowth.natural_iff`), so with the footprint '
    'containing the exchanges the reorderings\' numberings are the orders of birth of causal-set growth '
    '(`ReorderingGrowth.reordering_iff_course`); '
    'the laws of presence hold on the reorderings by instance, each with its decision (`ReorderingGrowth.present_some_reordering`, '
    '`ReorderingGrowth.present_every_reordering`); presence on the world as it is gives persistence of what an exchange '
    'touched, not conversely (`ReorderingGrowth.persists_of_present`, `ReorderingGrowth.MovedBack.persists_not_present`); '
    'near-definitional |')

readme_row(PKG / 'README.zh.md',
    '| L1 | [`Becoming.ReorderingGrowth`](Becoming/ReorderingGrowth.lean) | 世界之重排作为其交换之序之生长（无伦理谓词）：一段之交换成因果集，其自然编号即守相接交换之序之重编号'
    '（`ReorderingGrowth.natural_iff`），故足迹含诸交换时，诸重排之编号即因果集生长之生序（`ReorderingGrowth.reordering_iff_course`）；'
    '在之诸律依实例成立于诸重排，各带其判定（`ReorderingGrowth.present_some_reordering`、`ReorderingGrowth.present_every_reordering`）；'
    '世界本身之在给出一交换所触者之持存，反之不然（`ReorderingGrowth.persists_of_present`、`ReorderingGrowth.MovedBack.persists_not_present`）；近乎定义 |')
print('integrated: Becoming.ReorderingGrowth joined (root import and L1 bullet, checker core list and scope, README rows '
      'EN and ZH); no landed module changed')
