#!/usr/bin/env python3
"""CA1: join Becoming.Founding to the core package: copy it in, import it after Becoming.GroupEnding, add its root doc
bullet before Drift's, its CORE entry and scope text in check_becoming.py, and its README rows after GroupEnding's.
usage: python3 -B integrate.py   (CA1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['CA1_ROOT']).resolve() if os.environ.get('CA1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Founding.lean', PKG / 'Becoming' / 'Founding.lean')

DOC = (
    '* `Becoming.Founding` (L1): selection within a whole, a lineage confined to it, and what a\n'
    '  founding carries. Where a family of conditions ran into excess under the coupled gate, every\n'
    '  member of a later generation of descent is the offspring of a member that did not depend on\n'
    '  the family, and a lineage every later member of which depends on the family has no member\n'
    '  after its end, whatever selection within had raised it to: a rise confined to the family ends\n'
    '  with it. In generations founded uniform, selection within at a step\n'
    '  needs transmission that raised or lowered the amount at some step before it. Read over\n'
    '  wholes each founded by one part, what transmission raised and lowered across a generation of\n'
    '  wholes is how far the next founders moved from their founder within the whole; where the\n'
    '  next founders carry their founder\'s value (sequestered), the mean founding value rises exactly\n'
    '  where selection among wholes goes for it. Witnesses: two rises on one body, the confined one\n'
    '  ending and the other still having a member after the body\'s parts end; foundings with and\n'
    '  without a line carrying the founder\'s value.\n'
)
SCOPE = (
    '    "Founding: where a family of conditions ran into excess under the coupled gate every member of a "\n'
    '    "later generation of descent is the offspring of a member not depending on the family, and a "\n'
    '    "lineage confined to the family has no member after its end, whatever selection within had "\n'
    '    "raised it to; in generations founded uniform, selection within at a step needs transmission that "\n'
    '    "raised or lowered the amount before it; over wholes each founded by one part, transmission across "\n'
    '    "a generation of wholes is how far the next founders moved within the whole, and where the "\n'
    '    "next founders carry their founder\'s value the mean founding value rises exactly where selection among "\n'
    '    "wholes goes for it. "\n')
README_ROW = (
    '| L1 | [`Becoming.Founding`](Becoming/Founding.lean) | selection within a whole, a lineage confined to it, and what '
    'a founding carries: where a family of conditions ran into excess under the coupled gate, every member of a later '
    'generation of descent is the offspring of a member that did not depend on the family '
    '(`Founding.Flow.survivors_independent`), and a lineage confined to the family has no member after its end '
    '(`Founding.Flow.confined_ends`), so a rise within a whole confined to the family ends with it '
    '(`Founding.Flow.Rise`, `Founding.Flow.ConfinedRise`, `Founding.Flow.ConfinedRise.ends`); in generations founded uniform, selection within '
    'at a step needs transmission that raised or lowered the amount before it (`Founding.varied_before`); over wholes '
    'each founded by one part (`Founding.Nested.Founded`), transmission across a generation of wholes is how far the '
    'next founders moved within the whole (`Founding.Nested.raises_iff_carried`), and where the next founders carry '
    'their founder\'s value (`Founding.Nested.Sequestered`) the mean founding value rises exactly where selection among wholes '
    'goes for it (`Founding.Nested.raises_iff_among`); witnesses `Founding.Body.confined_ended`, '
    '`Founding.Body.spread_rise`, `Founding.Body.spread_unconfined`, `Founding.Body.spread_outlasts`, `Founding.Germline.sequestered_rises` and '
    '`Founding.Germline.unsequestered_falls` |')
README_ZH_ROW = (
    '| L1 | [`Becoming.Founding`](Becoming/Founding.lean) | 整体内的选择、局限于整体的世系与一次奠基所携带者：一族条件在耦合门控下遭遇过度后，'
    '此后各代的每个成员都是某个不依存于该族之成员的后代（`Founding.Flow.survivors_independent`），局限于该族的世系在其终结后不再有成员'
    '（`Founding.Flow.confined_ends`），故整体内局限于该族的上升随之终结（`Founding.Flow.Rise`、`Founding.Flow.ConfinedRise`、'
    '`Founding.Flow.ConfinedRise.ends`）；由均匀者奠基的世代中，某步的组内选择需要此前某步的传递升高或降低了该量'
    '（`Founding.varied_before`）；在每个整体由一个部分奠基的读法中（`Founding.Nested.Founded`），跨整体世代的传递即下一批奠基者在整体内'
    '离开其奠基者的距离（`Founding.Nested.raises_iff_carried`），下一批奠基者携带原奠基者之值时（`Founding.Nested.Sequestered`），平均奠基值恰在整体间选择'
    '为它时上升（`Founding.Nested.raises_iff_among`）；见证 `Founding.Body.confined_ended`、`Founding.Body.spread_unconfined`、'
    '`Founding.Body.spread_rise`、`Founding.Body.spread_outlasts`、`Founding.Germline.sequestered_rises`、`Founding.Germline.unsequestered_falls` |')

root = (PKG / 'Becoming.lean').read_text()
assert 'import Becoming.Founding' not in root, 'already integrated'
root = once(root, 'import Becoming.GroupEnding\n', 'import Becoming.GroupEnding\nimport Becoming.Founding\n')
root = once(root, '* `Becoming.Drift` (L1): offspring sampled rather than listed.',
            DOC + '* `Becoming.Drift` (L1): offspring sampled rather than listed.')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '"Becoming.GroupEnding",', '"Becoming.GroupEnding", "Becoming.Founding",')
chk = once(chk, '    "Drift: a next generation of two kinds', SCOPE + '    "Drift: a next generation of two kinds')
(PKG / 'check_becoming.py').write_text(chk)

for name, row in (('README.md', README_ROW), ('README.zh.md', README_ZH_ROW)):
    rd = (PKG / name).read_text()
    lines = rd.split('\n')
    prev = [i for i, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.GroupEnding`](Becoming/GroupEnding.lean) |')]
    assert len(prev) == 1, (name, prev)
    lines[prev[0] + 1:prev[0] + 1] = [row]
    (PKG / name).write_text('\n'.join(lines))
print('integrated')
