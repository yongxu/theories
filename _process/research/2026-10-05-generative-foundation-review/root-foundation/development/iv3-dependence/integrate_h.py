#!/usr/bin/env python3
"""IV3h: put the extended and corrected Becoming.Weightings into the package and correct its bullet in the root
module's doc (the review's findings), before the core checker runs.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_h.py"""
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

shutil.copyfile(HERE / 'tree/Becoming/Weightings.lean', PKG / 'Becoming/Weightings.lean')

root = PKG / 'Becoming.lean'
text = root.read_text(encoding='utf-8')
EDITS = [
    ("""  the centers lie within one another's closures, and centers that share one condition do
  (`ownClosure_standpointInvariant_iff_centersWithin`, `Flow.centersWithin_feeding_of_common`); drawn
  along need it reaches a copy of what it needs exactly where the copy is the only one
  (`forced_member_iff_only`, `Copies`);""",
     """  the centers lie within one another's closures, and centers that each depend on one condition and
  exchange with it do (`ownClosure_standpointInvariant_iff_centersWithin`,
  `Flow.centersWithin_influence_of_common`); drawn along need, where each copy can carry it alone, it
  reaches a copy of what it needs exactly where the copy is the only one (`forced_member_iff_only`,
  `Copies`);"""),
    ("""where its own continuation is everything listed. Need holds over any courses with two readings, a
  member needed exactly where it is the only one (`needsPart_iff_only`); on the base, a formation
  drawing past its family's stock needs some feeder's giving, and a feeder's exactly where it is the
  only one (`Flow.needsSome_of_drawsPast`, `Flow.needs_giver_iff_only`, `Feeders`);""",
     """where its own continuation is everything listed. Need holds over any courses with two readings,
  where each member can take its part alone a member needed exactly where it is the only one
  (`needsPart_iff_only`); on the base, a formation drawing past its family's stock needs some
  feeder's giving, and, where each can feed alone, a feeder's exactly where it is the only one
  (`Flow.needsSome_of_drawsPast`, `Flow.needs_giver_iff_only`, `Feeders`);"""),
    ("""  for giving, it is the only one active (`Flow.needs_giver_iff_alone`; `FeedersInTurn`). With
  capacities of giving supplied with the web, a feeder can feed the family alone exactly where its
  capacity covers each step's demand (`Flow.feedsAlone_iff`),""",
     """  for giving, no other member is active (`Flow.needs_giver_iff_alone`; `FeedersInTurn`). With
  capacities of giving supplied with the web, a feeder can feed the family alone exactly where, at
  every step calling for giving, it is active and its capacity covers the demand
  (`Flow.feedsAlone_iff`),"""),
    ("""  hierarchy holds needs giving into its top (`Flow.needsSome_tiers`; `TwoTiers`). A feeder's degree
  of need, the least it gives while the consumer draws past the stock, is the sum of what each step
  demands beyond what the others can give (`Flow.least_giving`; `Capacities.second_in_degree`). The
  readings are the AI's (D59, D60, D64).
""",
     """  hierarchy holds needs giving into its top (`Flow.needsSome_tiers`; `TwoTiers`). Some flow lets
  the consumer draw past the stock exactly where the class can give each step's demand, and
  elsewhere every need holds vacuously (`Flow.possible_iff_covers`); wherever a flow is possible, a
  feeder's degree of need, the least it gives while the consumer draws past the stock, is the sum of
  what each step demands beyond what the others can give (`Flow.least_giving_of_possible`;
  `Capacities.second_in_degree`). The readings are the AI's (D59, D60, D64).
"""),
]
for old, new in EDITS:
    assert text.count(old) == 1, (old[:60], text.count(old))
    text = text.replace(old, new)
root.write_text(text, encoding='utf-8')
print('integrated: Weightings copied, root bullet corrected')
