# Edits to Becoming.Wholes's module text for WH1 (run by build_tree.py on `wh`).
wh = once(wh, '# Wholes: a persisting whole of brief parts, or of ending listed parts, needs their generation\n',
          '# Wholes: a persisting whole of brief parts, or of ending listed parts, needs their generation;\n'
          'a whole of every part ends with any part\n')
wh = once(wh, '''members. This module states one part–whole relation, coincidence of activity, and proves
what it carries, and, with `Becoming.Continuation`, what a draw on the conditions its parts
arise through does to a whole.''', '''members. This module states part–whole relations as coincidences of activity, a whole active
while some part is, while every part is, or while at least a number of listed parts are, and
proves what they carry, and, with `Becoming.Continuation`, what a draw on the conditions its
parts arise through does to a whole.''')
wh = once(wh, '''  each needed; that the gate on renewal and the finite listing are needed for this law is not
  shown here.
''', '''  each needed; that the gate on renewal and the finite listing are needed for this law is not
  shown here.
* **A whole of every part, and a graded whole.** A formation is the *whole of every part* when it
  is active exactly while every part is (`Web.AllWhole`); every formation is that of itself as
  well (`Web.allWhole_self`). Such a whole is inactive wherever one part is
  (`AllWhole.inactive_of_part`), so it ends as soon as one part ends, with no listing and nothing
  of arising (`AllWhole.ends_of_part`), and persists exactly while every part does
  (`AllWhole.persists_iff`); a whole of some part ends only where every part ends and none arises.
  Dually to `Whole.arises_part`, a whole of some part ceases only as some part ceases
  (`Whole.ceases_part`). With some part, the two wholes of the same parts are active at the same
  steps exactly where the parts are in step, all active or none at each step
  (`Whole.same_iff_inStep`); with no part they part entirely (`AllWhole.active_of_none`). The
  *grade* of listed parts at a step is how many of them are active (`Web.Grade`), a count of
  `Becoming.Decidedness`, which exists exactly where their activity is decided. Its account across
  a step is the census, what arises less what ceases (`Grade.across_step`), so it rises only as a
  listed part arises and falls only as one ceases (`Grade.arises_of_lt`, `Grade.ceases_of_lt`). A
  formation active exactly where the grade is at least `j` (`Web.AtLeastWhole`) therefore arises
  and ceases only through a listed part (`AtLeastWhole.arises_part`, `AtLeastWhole.ceases_part`).
  At `j` one it is the whole of some listed part, at `j` the number listed the whole of every one
  (`AtLeastWhole.whole`, `AtLeastWhole.allWhole`; conversely where their activity is decided,
  `Whole.atLeastWhole`, `AllWhole.atLeastWhole`), so a whole of every listed part arises and
  ceases only through a listed part (`AllWhole.arises_part`, `AllWhole.ceases_part`). The grade
  falls short wherever a listed part is inactive (`Grade.lt_length_of_inactive`), and the whole is
  *diminished*, some parts active and not all (`Web.Diminished`), exactly where the whole of some
  is active and the whole of every one is not (`Grade.diminished_iff`, `diminished_iff`).
  Witnesses: the members of `Generations` make a lineage active at every step, while a whole of
  every member is active at none (`Generations.allWhole_never`); a house of three rafters, the
  first taken after the first step, ceases with it, and from then on two of the three are active,
  the whole diminished, what is left standing and the house not (`Rafters.taken`).
''')
wh = once(wh, '''Which formations are parts of which, and whether a lineage is read as the whole of its
members, are representational choices.''', '''Which formations are parts of which, whether a lineage is read as the whole of its
members, and which of the wholes a whole is read as, are representational choices.''')
