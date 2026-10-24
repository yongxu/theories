# AL1: OPENING's [^aligned] and [^race] rewritten to cite the laws of best response (used by apply_text.py with ROOT).
from pathlib import Path

OP = ROOT / 'theories/becoming/OPENING.md'
text = OP.read_text(encoding='utf-8')
lines = text.split('\n')
ia = [i for i, l in enumerate(lines) if l.startswith('[^aligned]: ')]
ir = [i for i, l in enumerate(lines) if l.startswith('[^race]: ')]
assert len(ia) == 1 and len(ir) == 1
old_a, old_r = lines[ia[0]], lines[ir[0]]
keep_from = 'They need not align where a part\'s continuation does not depend on what it closes:'
assert old_a.count(keep_from) == 1
rest = old_a[old_a.index(keep_from):]
old_bounded = ('That a self\'s significance is bounded so is a supplied reading, not derived, and these theorems concern '
               'dependence and significance, not incentive or motivation.')
assert rest.count(old_bounded) == 1
rest = rest.replace(old_bounded, 'That a self\'s significance is bounded so is a supplied reading, not derived. The '
                    'drawers\' laws concern best responses in a model of whole amounts and discrete steps, not motivation or '
                    'what actual agents do; the others concern dependence and significance.')
old_ends = 'the race ends them with the condition, whatever their position (`Flow.race_ends_greatest`).'
assert rest.count(old_ends) == 1
rest = rest.replace(old_ends, 'the race ends them with the condition, whatever their position (`Flow.race_ends_greatest`); '
                    'a joint draw breaks the highest needs first, whoever takes (`Web.Broken.of_need_le`).')
rest = rest.replace('They need not align where', 'Incentives need not align where', 1)
new_a = ('[^aligned]: **Proved under conditions; not universal.** Incentives align where continuations share the conditions a '
         'race draws down: where renewers depend on what they renew, joint excess ends the renewal and every formation '
         'depending on the condition at such a need, the takers among them where they so depend (`Flow.joint_excess_ends`). '
         'Read as best responses, each drawer ranking only what it draws, the view from inside the race and the view from '
         'the whole part where what one leaves comes back to its share at most one for one and to the whole more. Where drawers '
         'take shares of one condition at once, drawing everything is each one\'s best response, at every step, to the '
         'others\' doing so exactly where no share returns more than one for one on what its drawer alone leaves '
         '(`Optimum.AtOnce.drain_perfect_iff`), while a drawer whose share is all that stands has a better move than '
         'draining wherever the whole returns more than one for one (`Optimum.AtOnce.whole_not_drained`). In a constructed example two drawers '
         'share by halves: drawing everything is a best response for both and ends a dweller, while holding the level keeps '
         'the dweller and draws each drawer more over a long enough horizon, and the one counting the whole has a better move than draining '
         '(`Optimum.Holding.halves_race`, `Optimum.AtOnce.holding_draws_more`, [record](results/records/drawers-in-turn.md)). '
         'Not every race is such a trap for its drawers: where each share returns less than one for one, in whole amounts '
         'nothing a drawer leaves comes back to its share, no course draws any drawer more than draining, and what draining '
         'ends lies beyond them all (`Optimum.AtOnce.drain_most`, `Web.at_once_beyond`). ' + rest)
lines[ia[0]] = new_a
keep_r = 'In a balanced flow, let a family list every condition'
assert old_r.count(keep_r) == 1
new_r = ('[^race]: **Proved under conditions; that it describes the present race is a judgment.** That each is rewarded for '
         'the race is a law of best response where drawers take shares of one condition: restraint is no mutual best '
         'response wherever something stands (`Optimum.MutualBest.full`); drawing at once, drawing everything is each one\'s '
         'best response exactly where no share returns more than one for one on what its drawer alone leaves, and where '
         'each returns less every perfect profile draws everything (`Optimum.AtOnce.drain_perfect_iff`, '
         '`Optimum.AtOnce.drains`); drawing in turn, unlimited, two or more drawers draw everything at every perfect '
         'profile, and revising toward best responses from any profile, restraint included, comes to it '
         '(`Optimum.InTurn.perfect_at_floors`, `Optimum.InTurn.revised_at_floors`). That none is better for it is shown where '
         'some return comes back: with two drawers sharing by halves, holding the level draws each more than the drain that '
         'is each one\'s best response (`Optimum.Holding.halves_race`). ' + old_r[old_r.index(keep_r):])
lines[ir[0]] = new_r
OP.write_text('\n'.join(lines), encoding='utf-8')
print('OPENING [^aligned] and [^race] rewritten')
