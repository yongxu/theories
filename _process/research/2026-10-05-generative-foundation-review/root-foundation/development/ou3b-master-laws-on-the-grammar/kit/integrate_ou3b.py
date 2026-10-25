#!/usr/bin/env python3
"""OU3b: join Becoming.GrammarLaws to the core and apply board rule 9 in the fourteen modules whose laws are now
proved from it (or represented on it). Copies the new module; applies the fourteen patches of kit/patches/ with
`git apply --3way` (each written against the file's base, so changes landed on main meanwhile survive; a conflict
stops the run); adds the module to the checker's core list (after Becoming.Prelude, which it imports, and before
Becoming.World and Becoming.Frame, which import it) and its scope text; imports it in the root module with a doc
bullet, and revises the root bullets the change makes untrue (Grammar no longer a leaf, GrammarMap's importers,
Frame's closure, Amounts' imports); adds the package README rows (EN, ZH) and revises the Frame and Amounts rows.
Mirrors UE4's integrate_ue4.py and GS6's integrate_gs6.py; each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_ou3b.py"""
import shutil
import subprocess
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
PKG_REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PKG = ROOT / PKG_REL
CHANGED = ('Frame', 'Recurrence', 'Attraction', 'Laws', 'Mechanism', 'IdentificationRuns', 'GrammarRegularity',
           'GrammarScope', 'Regions', 'Admission', 'Flow', 'Amounts', 'InAmounts', 'Weightings')


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# the new module
target = PKG / 'Becoming/GrammarLaws.lean'
assert not target.exists(), target
shutil.copyfile(TREE / 'GrammarLaws.lean', target)

# the fourteen changed modules, as patches merged three ways onto the current files
paths = [f'{PKG_REL}/Becoming/{m}.lean' for m in CHANGED]
dirty = subprocess.run(['git', 'status', '--porcelain', '--', *paths], cwd=ROOT, capture_output=True, text=True).stdout
assert not dirty, ('changed modules not clean before the patches', dirty)
for name in CHANGED:
    r = subprocess.run(['git', 'apply', '--3way', '--whitespace=nowarn', str(HERE / f'patches/{name}.patch')],
                       cwd=ROOT, capture_output=True, text=True)
    assert r.returncode == 0, (name, r.stdout, r.stderr)
    merged = (ROOT / f'{PKG_REL}/Becoming/{name}.lean').read_text(encoding='utf-8')
    assert '<<<<<<<' not in merged and '>>>>>>>' not in merged, name
    same = merged == (TREE / f'{name}.lean').read_text(encoding='utf-8')
    print(f'{name}: applied ({"identical to the kit tree" if same else "merged with changes landed since its base"})')
# --3way stages what it applies; leave the index as it was, so the landing commits by paths as usual
subprocess.run(['git', 'reset', '-q', '--', *paths], cwd=ROOT, check=True)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Prelude", "Becoming.World", ', '"Becoming.Prelude", "Becoming.GrammarLaws", "Becoming.World", ')
edit(checker, """SCOPE = (
    "GrammarPath: """, """SCOPE = (
    "GrammarLaws: the five master laws on the grammar, for every carrier and relation: closure is being the "
    "occurrence itself or reached; perfect pairings of finite lists under a relation conserve count, are exactly "
    "equal count under the one, compose, join, gather over a family and carry over a stretch under the closure, so "
    "the count law at a step and over a stretch is exactly a pairing of units, near-definitional; an occurrence is "
    "drawn exactly where it reaches something that does not reach back, with the successor fixed at what it reaches "
    "one reaching itself is not drawn, along a line a list holds merging nothing at its places brings it back to its "
    "start, and within finitely many occurrences with successors merging nothing is every occurrence reaching itself "
    "under a fixed successor; where every course of no rise then a least fall ends, the falls along a line that does "
    "not rise do not recur, rest being no case of being drawn either way; going alike is constancy where the "
    "successor is fixed and a successor available, and a map's image has a fixed successor exactly where sameness "
    "under the map goes alike; widening of relations is a strict order excluding keeping and being mixed. Frame's "
    "closure is the grammar's, and the models' laws of closure, finite runs, lumping and order are proved from these; "
    "balance is represented both ways in Flow and not derived. "
    "GrammarPath: """)

# the root module: import, bullet, and the bullets the change makes untrue
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.MapInstances\n', 'import Becoming.MapInstances\nimport Becoming.GrammarLaws\n')
edit(root, """  excluded middle (`«四相之定当且仅当排中»`). A leaf until the continuation family is lifted
  onto it (board item OU3).""", """  excluded middle (`«四相之定当且仅当排中»`). Below every model since board item OU3b:
  `Becoming.GrammarLaws` imports it, and `Becoming.Frame` imports that.""")
edit(root, """  branch of renewing into (`«生生即延»`, `«息即尽»`). Imported by `Becoming.GrammarScope`,
  `Becoming.GrammarPath` and `Becoming.MapInstances`.""", """  branch of renewing into (`«生生即延»`, `«息即尽»`). Imported by `Becoming.GrammarLaws`,
  `Becoming.GrammarScope`, `Becoming.GrammarPath` and `Becoming.MapInstances`.""")
edit(root, """  layers (feeding, influence, reach, sharing, coupling, a presupposition's scope) are this
  closure under their relations.""", """  layers (feeding, influence, reach, sharing, coupling, a presupposition's scope) are this
  closure under their relations. The closure is the grammar's (`«闭»`, `«所闭»` of
  `Becoming.GrammarLaws`, by definition), and its laws here are proved from the grammar's.""")
edit(root, """* `Becoming.Amounts` (L1): rest over amounts that may be dense, below the rest family (it imports
  only `Becoming.Prelude`).""", """* `Becoming.Amounts` (L1): rest over amounts that may be dense, below the rest family (it imports
  only `Becoming.Prelude` and `Becoming.GrammarLaws`; its law of rest is the grammar's, `«尽则不或屡»`,
  the falls ending within finitely many least losses, `Amounts.falls_end`).""")
edit(root, """  from which the stretch balances of flows, amounts, courses and censuses are derived.
* `Becoming.Ideals` (L1):""", """  from which the stretch balances of flows, amounts, courses and censuses are derived.
* `Becoming.GrammarLaws` (L0): the five master laws of 08 §7 on the grammar, for every carrier and
  relation, with no premise. Closure: lying within a closure (`«所闭»`) is being the occurrence
  itself or reached (`«所闭当且仅当同一或及»`). Balance: a perfect pairing of finite lists under a
  relation (`«对»`) conserves count (`«对之长»`) and under the one is exactly equal count
  (`«一之对»`); pairings compose, join, gather over a family and carry over a stretch under the
  closure (`«对之接»`, `«对之并»`, `«对之族»`, `«对之程»`), and the count law at a step and over a
  stretch is exactly a pairing of units (`«守数当且仅当可对»`, `«程守数当且仅当可对»`): an exact
  cardinality representation, near-definitional, the pairing supplied. Finite runs: drawn in is
  reaching something that does not reach back (`«入当且仅当有不返»`); with the successor fixed at
  what it reaches, an occurrence reaching itself is not drawn (`«定后于则返者不入»`); along a line
  a list holds, merging nothing at its places, the start reaches itself (`«线有限不并则返»`, by
  pigeonhole with no decidability); where every course of no rise then a least fall ends, the
  falls along a line that does not rise do not recur (`«尽则不或屡»`), and rest is no case of being
  drawn either way (`«止而不入之例»`, `«入而屡之例»`). Lumping: with the successor fixed where `E`
  leads, constancy is going alike with a successor available (`«局定后则有常当且仅当同行可续»`), and a
  map's image has a fixed successor exactly where sameness under the map goes alike
  (`«像定后当且仅当同行»`). Order: widening of relations is irreflexive, one-way and transitive and
  excludes keeping and being mixed (`«广不可逆»`, `«广之传递»`). It imports the grammar, its map
  and the prelude only, and `Becoming.Frame` imports it, so every model lies above it: closure is
  proved from it in `Becoming.Frame` and `Becoming.GrammarScope`; finite runs in
  `Becoming.Recurrence`, `Becoming.Attraction` and `Becoming.Amounts`; lumping, bridged in
  `Becoming.Laws`, in `Becoming.Mechanism`, `Becoming.GrammarRegularity` and
  `Becoming.IdentificationRuns`; order in `Becoming.Admission`, `Becoming.Regions` and
  `Becoming.Weightings`. Balance is represented both ways in `Becoming.Flow`
  (`Flow.balances_iff_units`) and not derived: its consumers need only the count, so their proofs
  stay arithmetic (board item OU3b).
* `Becoming.Ideals` (L1):""")

# the package README rows (EN, ZH)
ROW_EN = ('| L0 | [`Becoming.GrammarLaws`](Becoming/GrammarLaws.lean) | the five master laws on the grammar, for every carrier '
          'and relation (no premise): closure is being the occurrence itself or reached (`«所闭当且仅当同一或及»`); '
          'perfect pairings of lists (`«对»`) conserve count, are equal count under the one (`«一之对»`), compose, join, '
          'gather over a family and carry over a stretch (`«对之接»`, `«对之族»`, `«对之程»`), so the count law is '
          'exactly a pairing of units (`«守数当且仅当可对»`, `«程守数当且仅当可对»`), near-definitional; drawn in is '
          'reaching what does not reach back (`«入当且仅当有不返»`), and with the successor fixed at what it reaches '
          'an occurrence reaching itself is not drawn (`«定后于则返者不入»`); a listed line merging nothing returns to '
          'its start (`«线有限不并则返»`); falls whose courses end do not recur (`«尽则不或屡»`), rest no case of being '
          'drawn (`«止而不入之例»`, `«入而屡之例»`); going alike and constancy (`«局定后则有常当且仅当同行可续»`), a '
          "map's image with a fixed successor exactly where sameness under it goes alike (`«像定后当且仅当同行»`); "
          'widening a strict order of relations (`«广不可逆»`, `«广之传递»`). Frame imports it; the models\' laws of '
          'closure, finite runs, lumping and order are proved from it, and balance is represented in Flow, not derived |')
ROW_ZH = ('| L0 | [`Becoming.GrammarLaws`](Becoming/GrammarLaws.lean) | 文法上的五条主律，对每个载体与关系成立（不加前提）：'
          '在闭包之内即是此事本身或为其所及（`«所闭当且仅当同一或及»`）；列表之完全配对（`«对»`）守其数，在「一」之下恰是等长'
          '（`«一之对»`），可复合、可并、可聚于一族、可延于一段（`«对之接»`、`«对之族»`、`«对之程»`），故守数之律恰是单位之配对'
          '（`«守数当且仅当可对»`、`«程守数当且仅当可对»`），近乎定义；入即及于不返者（`«入当且仅当有不返»`），于其所及处定后，'
          '自返者不入（`«定后于则返者不入»`）；有列表所持、于其诸位不并之线回到其始（`«线有限不并则返»`）；诸程皆尽之降不复屡'
          '（`«尽则不或屡»`），止非入之一例（`«止而不入之例»`、`«入而屡之例»`）；同行与有常（`«局定后则有常当且仅当同行可续»`），'
          '映射之像定后恰在其下之同同行（`«像定后当且仅当同行»`）；扩大为关系之严格序（`«广不可逆»`、`«广之传递»`）。'
          'Frame 导入之；诸模型之闭包、有限运行、归并与序之律由之证出，平衡于 Flow 中表示而不推出 |')
for name, row, old, new in (
        ('README.md', ROW_EN, 'runs, the one closure of a relation (`WithinClosure`), reach',
         'runs, the one closure of a relation (`WithinClosure`, the grammar\'s `«所闭»`), reach'),
        ('README.zh.md', ROW_ZH, '关系的唯一闭包（`WithinClosure`）', '关系的唯一闭包（`WithinClosure`，即文法之 `«所闭»`）')):
    path = PKG / name
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith('| L0 | [`Becoming.Prelude`]')]
    assert len(at) == 1, (name, at)
    assert not any(line.startswith('| L0 | [`Becoming.GrammarLaws`]') for line in lines), name
    lines[at[0] + 1:at[0] + 1] = [row]
    path.write_text('\n'.join(lines), encoding='utf-8')
    edit(path, old, new)
# the Amounts row's import note (already stale: it imported Becoming.Prelude) made true
edit(PKG / 'README.md', 'World.rests_unrefuted_enclosed follows) (imports only Naturals) |',
     'World.rests_unrefuted_enclosed follows); its law of rest is the grammar\'s («尽则不或屡»), the falls ending within '
     'fewer than m least losses (Amounts.falls_end) (imports only Becoming.Prelude and Becoming.GrammarLaws) |')
print('integrated: Becoming.GrammarLaws joined (core list and scope, root import and bullets, README rows); '
      'fourteen modules patched')
