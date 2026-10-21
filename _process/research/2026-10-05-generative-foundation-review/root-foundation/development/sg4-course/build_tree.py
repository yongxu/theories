#!/usr/bin/env python3
"""Build SG4's tree: the package's Becoming.Optimum with the docstring repair ("best best response",
left by SG3's binder rename, back to "mutual best response") and the section of sg4_section.lean
appended before the module's end.
usage: python3 -B build_tree.py   (SG4_ROOT names the checkout to read; default this repository)"""
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG4_ROOT']).resolve() if os.environ.get('SG4_ROOT') else HERE.parents[5]
SRC = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean'
s = SRC.read_text(encoding='utf-8')
assert 'Reoptimizes' not in s, 'already integrated'
for a, b in [('a best best response', 'a mutual best response'), ('A best best response', 'A mutual best response'),
             ('no best best response', 'no mutual best response')]:
    s = s.replace(a, b)
assert 'best best' not in s


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


BULLET_OLD = """  `TwoTakers.within_slack_jointly_below`), and the step where one restrains is no mutual best
  response (`TwoTakers.restrained_not_mutual`).
"""
BULLET_NEW = BULLET_OLD + """* **A course of steps.** Where a part chooses again at every step, the levels after each an
  optimum among the outcomes open to it from the levels before (`Optimum.Reoptimizes`), a
  condition beyond stands after each step at the level before with what the rest gives, less what
  the rest takes and the part's capacity, or at nothing (`Optimum.course_beyond`); for several
  optimizers at a mutual best response at every step, less their joint capacity
  (`Optimum.mutual_course_beyond`). Where the rest renews the condition by exactly `r` a step
  while it stands at a positive need `m`, by at most `r` below, and the draw there is `k`, a
  dependence at that need is lost exactly where `r < k` (`Web.course_lost_iff`): above the renewal
  the level never rises, falls by at least one at every step while something stands, and stands
  below the need once the steps exceed its starting excess over it, for good
  (`Optimum.never_rises`, `Optimum.ends_within`, `Optimum.level_stays_below`); within it the level
  never falls (`Optimum.kept_at_need`). Several optimizers each within the renewal lose it where
  their joint capacity exceeds it (`Web.mutual_course_lost`). No course draws more than the
  starting level with `r` for each step (`Optimum.drawn_within`); within the renewal it draws `k`
  at every step (`Optimum.kept_drawn`). What the renewal does below the need decides only what is
  drawn: where it stops there (a gate), as where whatever renews the condition depends on it
  (`Flow.restGiven_unsupported`), a course above the renewal draws at most the starting level with
  `r` for each of its units, however long (`Optimum.ended_drawn_le`, `Web.course_ended_drawn`), so
  a positive draw is bounded exactly where `r < k` (`Optimum.drawn_bounded_iff`) and over a long
  enough course keeping draws more (`Optimum.keeping_draws_more`); where at least one is given at
  every step, the dependence is lost all the same and the draw has no bound
  (`Optimum.drawn_unbounded`, `Web.course_drawn_unbounded`). `Renewing` is the instance: a taker
  choosing the store's optimum at every step against a dweller renewing the source loses the
  dweller exactly where `r < k` (`Renewing.lost_iff`), its store bounded exactly then
  (`Renewing.store_bounded_iff`) and below a taker of capacity `r` after long enough
  (`Renewing.keeping_holds_more`); two takers of
  capacity one at a mutual best response at every step lose a source renewed by one, which either
  alone keeps (`Renewing.joint_course_lost`, `Renewing.alone_kept`), and hold less than the course
  in which one restrains, no step of which is a mutual best response
  (`Renewing.restrained_course_not_best`, `Renewing.restraint_holds_more`).
"""
READING_OLD = """optimize, and whether they act together or each alone, does not change where the condition stands
(the tragedy of the commons, Hardin 1968, and open access, Gordon 1954, in the spine's form).
"""
READING_NEW = """optimize, and whether they act together or each alone, does not change where the condition stands
(the tragedy of the commons, Hardin 1968, and open access, Gordon 1954, in the spine's form). Over
a course against a renewal this is the open-access depletion of a renewable resource (Gordon 1954;
Clark, *Mathematical Bioeconomics*, 1976) and, with several optimizers, the dynamic commons
(Levhari and Mirman 1980): what the form adds is that the threshold is exact over any orders
rising with any families, the dependence lost exactly above it whatever the renewal does below the
need, and that the gate decides the optimizer's own draw, the measure its order rises with: where
the renewal stops below the need that draw is bounded, and after long enough below what a capacity
at the renewal draws; where it does not, the draw goes on without bound after the dependence is
lost.
"""
NOTDERIVED_OLD = """covered); a course of steps under an optimizer choosing again at each; for several optimizers,"""
NOTDERIVED_NEW = """covered); over a course, a renewal varying with the level at or above the need (one growing with
the level, as in logistic growth, is not stated), an optimizer ranking courses rather than steps,
and how optimizers come to a mutual best response; for several optimizers,"""
s = once(s, BULLET_OLD, BULLET_NEW)
s = once(s, READING_OLD, READING_NEW)
s = once(s, NOTDERIVED_OLD, NOTDERIVED_NEW)
sec = (HERE / 'sg4_section.lean').read_text(encoding='utf-8')
i = s.rstrip().rindex('end Becoming')
s = s[:i] + sec.lstrip('\n') + '\n' + s[i:]
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('tree built', len(s.splitlines()), 'lines')
