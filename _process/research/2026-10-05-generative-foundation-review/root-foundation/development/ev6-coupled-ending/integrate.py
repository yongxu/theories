#!/usr/bin/env python3
"""Join EV6 to the core package: copy the edited Becoming.Continuation and Becoming.GroupEnding in (no new module: the
family laws generalize the one-condition laws below them, board rule 9), and extend their root doc bullets, their
README rows (EN, ZH) and their scope text in check_becoming.py.
usage: python3 -B integrate.py   (EV6_ROOT names the checkout to edit; each edit must match exactly once)"""
import os
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['EV6_ROOT']).resolve() if os.environ.get('EV6_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


for name in ('Continuation', 'GroupEnding'):
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{name}.lean', PKG / 'Becoming' / f'{name}.lean')

root = (PKG / 'Becoming.lean').read_text()
assert 'coupled gate' not in root, 'already integrated'
root = once(root, '  want that outlasts what the condition holds. The extent so derived runs one way, to what\n',
            '  want that outlasts what the condition holds. The same count and ending hold of a family of\n'
            '  conditions read as one, where whatever gives to a member depends on some member (the coupled\n'
            '  gate), the laws of one condition being its family of one; a patch renewed by a neighbour shows\n'
            '  no joint excess read alone, while read as one with the neighbour it does, and both end. The\n'
            '  extent so derived runs one way, to what\n')
root = once(root, '  by every group), the next generation is empty. Witnesses: selection within the keeping group\n',
            '  by every group), the next generation is empty. Groups whose members depend on conditions of\n'
            '  one family, its renewal gated on the family read as one, end together after the family\'s\n'
            '  excess, with nothing selected among them, so ending selects among groups only between such\n'
            '  families. Witnesses: selection within the keeping group\n')
(PKG / 'Becoming.lean').write_text(root)

chk = (PKG / 'check_becoming.py').read_text()
chk = once(chk, '    "more leaves offspring; one condition shared by every group, once it ends them, leaves the next "\n'
                '    "generation empty. "\n',
           '    "more leaves offspring; one condition shared by every group, once it ends them, leaves the next "\n'
           '    "generation empty; a member depending on any condition of a family whose renewal is gated on the "\n'
           '    "family read as one leaves no descendant after the family\'s excess, groups whose members depend "\n'
           '    "on one such family end together with nothing selected among them, and where the groups with less "\n'
           '    "of an amount depend on such a family they leave nothing. "\n')
chk = once(chk, '    "depends, as a renewer and two takers "\n',
           '    "depends; the same holds of a family of conditions read as one, where each step at which the "\n'
           '    "family\'s uptake exceeds its replenishment lowers its stock by at least one and whatever gives to a "\n'
           '    "member depends on some member at a need of at least m, the laws of one condition being its "\n'
           '    "family of one, and a patch renewed by a neighbour within what is taken from it, its renewal not "\n'
           '    "gated on it, ends with the neighbour read as one with it; as a renewer and two takers "\n')
(PKG / 'check_becoming.py').write_text(chk)

ROWS = {
    'README.md': (
        ('| L1 | [`Becoming.Continuation`](Becoming/Continuation.lean) |',
         ', so the joint count binds a want that outlasts what the condition holds;',
         ', so the joint count binds a want that outlasts what the condition holds; the same count and ending hold of a '
         'family of conditions read as one, where each step at which its uptake exceeds its replenishment lowers its '
         'stock by at least one (`Flow.family_excess_bounded`) and whatever gives to a member depends on some member at '
         'such a need (`Flow.family_stays_below_at`, `Flow.family_excess_ends`), the laws of one condition being its '
         'family of one; a patch renewed by a neighbour shows no joint excess read alone and its renewal is not gated on '
         'it, while read as one with the neighbour both end (`Coupled`);'),
        ('| L1 | [`Becoming.GroupEnding`](Becoming/GroupEnding.lean) |',
         '; witnesses `GroupEnding.Outweighed.outweighed`',
         '; a member depending on any condition of a family whose renewal is gated on the family read as one leaves no '
         'descendant after the family\'s excess (`GroupEnding.Flow.family_childless`), groups whose members depend on one '
         'such family end together with nothing selected among them (`GroupEnding.Flow.coupled_end_together`), and '
         'where the groups with less of an amount depend on such a family they leave nothing '
         '(`GroupEnding.Flow.ended_of_family`); witnesses `GroupEnding.Outweighed.outweighed`')),
    'README.zh.md': (
        ('| L1 | [`Becoming.Continuation`](Becoming/Continuation.lean) |',
         '，联合计入约束的是比条件所存更长远的想要；',
         '，联合计入约束的是比条件所存更长远的想要；同样的计入与终结对读作一体的条件族成立：族的取用超过其补充的每一步至少使其存量下降一'
         '（`Flow.family_excess_bounded`），给予某成员的都以这样的需要依存于某个成员时（`Flow.family_stays_below_at`、'
         '`Flow.family_excess_ends`），单个条件的定律即只含该条件之族的情形；由邻居补充的地块单独读出时无联合超出、其更新不以它为门控，'
         '与邻居读作一体时两者都终结（`Coupled`）；'),
        ('| L1 | [`Becoming.GroupEnding`](Becoming/GroupEnding.lean) |',
         '；见证 `GroupEnding.Outweighed.outweighed`',
         '；依存于某条件族任一条件、其更新以读作一体之族为门控的成员，在族的过度之后不留后代（`GroupEnding.Flow.family_childless`），'
         '成员依存于同一个这样的族的各组一同终结，组间无选择（`GroupEnding.Flow.coupled_end_together`），某量较少的组依存于这样的族时它们不留任何后代'
         '（`GroupEnding.Flow.ended_of_family`）；见证 `GroupEnding.Outweighed.outweighed`')),
}
for name, edits in ROWS.items():
    rd = (PKG / name).read_text()
    lines = rd.split('\n')
    for start, old, new in edits:
        hit = [i for i, l in enumerate(lines) if l.startswith(start)]
        assert len(hit) == 1, (name, start, hit)
        lines[hit[0]] = once(lines[hit[0]], old, new)
    (PKG / name).write_text('\n'.join(lines))
print('integrated')
