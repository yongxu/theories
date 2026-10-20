#!/usr/bin/env python3
"""Join WE1 to the core package: copy the edited Becoming.Wholes in (no new module: the law below
`Covered.needs_arising` generalizes it, and the join extends the module that holds `Whole.needs_arising`, board rule 9;
Wholes now imports Becoming.Continuation, both L1, no cycle), and extend its root doc bullet, its README rows (EN, ZH)
and its scope text in check_becoming.py.
usage: python3 -B integrate.py   (WE1_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['WE1_ROOT']).resolve() if os.environ.get('WE1_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


shutil.copyfile(HERE / 'tree' / 'Becoming' / 'Wholes.lean', PKG / 'Becoming' / 'Wholes.lean')

root = (PKG / 'Becoming.lean').read_text()
assert 'family_excess_ends`' not in root.split('* `Becoming.Wholes` (L1)')[1].split('* `Becoming.Dissipation`')[0]
root = once(root, '''  parts again, and parts whose activity ends arise at arbitrarily late steps when the
  active ones are listed, ever new ones.
''', '''  parts again, and parts whose activity ends arise at arbitrarily late steps when the
  active ones are listed, ever new ones: where none arises from some step on, such parts end
  together, and their whole with them. Read with a flow, a whole whose parts arise only where
  they depend on a family of conditions, the family's renewal gated on it, ends after the
  family's uptake exceeds its replenishment for more consecutive steps than its stock stands
  above the need: no part arises from then on. The uptake is the joint draw, the whole's with
  whatever else takes.
''')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '''    "covered by its parts; "
    "with a part that never ends, or infinitely many parts active at once, it persists while "
    "nothing arises, and parts arising without end may leave the whole inactive between them. "
''', '''    "covered by its parts; "
    "with a part that never ends, or infinitely many parts active at once, it persists while "
    "nothing arises, and parts arising without end may leave the whole inactive between them; "
    "parts each of whose activity ends, with the active ones listed, none arising from some step "
    "on, are all inactive from a later step, so their whole ends; a whole of such parts, its parts "
    "arising only where they then depend on some condition of a family at a need of at least m, "
    "the family's renewal gated on it, with balance, only active formations giving and activity "
    "needing support, after n steps of excess of the family's uptake over its replenishment from a "
    "stock below n + m has no part arising from then on and ends, the one-condition form its "
    "family of one; a lineage of members each arising where the condition stands at its need, "
    "drawing two where its members give one, meets every premise and ends, and taking within what "
    "they give it is active at every step, as it is with a part that never ends or with members "
    "arising without depending on the drawn condition. "
''')
(PKG / 'check_becoming.py').write_text(chk)

ROWS = {
    'README.md': (
        '| L1 | [`Becoming.Wholes`](Becoming/Wholes.lean) |',
        '; a persisting whole is covered by its parts, so it persists only through their unceasing generation |',
        '; a persisting whole is covered by its parts, so it persists only through their unceasing generation, and '
        'parts each ending, with the active ones listed, none arising from some step on, end together with their whole '
        '(`Listed.end_without_arising`, `Whole.ends_without_arising`; `Covered.needs_arising` is its corollary); read '
        'with a flow, a whole whose parts arise only where they then depend on a family of conditions at a need of at '
        'least m, the family\'s renewal gated on it, has no part arising after n steps of joint excess of the family\'s '
        'uptake over its replenishment from a stock below n + m, and ends (`Whole.family_excess_ends`, '
        '`Whole.joint_excess_ends`); witnesses `WholeExceeding.drawn`, and for the excess, ending parts and the '
        'arising\'s dependence each needed `WholeWithin.kept`, `WholeUnending.persists`, `WholeUngated.persists` |'),
    'README.zh.md': (
        '| L1 | [`Becoming.Wholes`](Becoming/Wholes.lean) |',
        '；持续的整体被部分覆盖，所以整体经由部分的不息生成而持续 |',
        '；持续的整体被部分覆盖，所以整体经由部分的不息生成而持续；各自终结、活跃者可列出的部分，从某步起无一生起时，从更晚的某步起一同终结，'
        '其整体亦然（`Listed.end_without_arising`、`Whole.ends_without_arising`；`Covered.needs_arising` 是其推论）；与流一同读，'
        '部分只在以至少 m 的需要依存于某条件族时生起、族的更新以族为门控的整体，在族的取用超过补充 n 步、起始存量低于 n + m 之后，'
        '再无部分生起并终结（`Whole.family_excess_ends`、`Whole.joint_excess_ends`）；见证 `WholeExceeding.drawn`，'
        '超出、部分终结与生起的依存各自必要见 `WholeWithin.kept`、`WholeUnending.persists`、`WholeUngated.persists` |'),
}
for name, (start, old, new) in ROWS.items():
    rd = (PKG / name).read_text()
    lines = rd.split('\n')
    hit = [i for i, l in enumerate(lines) if l.startswith(start)]
    assert len(hit) == 1, (name, start, hit)
    lines[hit[0]] = once(lines[hit[0]], old, new)
    (PKG / name).write_text('\n'.join(lines))
print('integrated')
