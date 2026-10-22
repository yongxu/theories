# Edits to Becoming.Frequency's module text for SAT1 (run by build_tree.py on `fr`).
fr = once(fr, '''  so its doubling after `T` is the rate (`Closing.Onset.amount_after`).
''', '''  so its doubling after `T` is the rate (`Closing.Onset.amount_after`).
* **A coupling saturated by what it has carried.** Strengths may be read off the amount already
  passed through each coupling. `Saturation.passed` is what has passed from `d` into `c` before a
  step, and `Saturation.strengths` gives each reading of `d` into `c` the strength `sat a`, `a` that
  amount. They read the levels before (`Saturation.readsBefore`), so the carrying law with them
  generates a course, and what passes is what the course carries through the coupling
  (`Saturation.course_succ`). Where the strengths are zero once `A` has passed, and `A` has passed
  by step `N`, the coupling stops by `N` (`Saturation.stops`): it does not recur
  (`Saturation.not_recurs`) and nothing more passes (`Saturation.passed_from`), and where every
  coupling has saturated a finite order is exact (`Saturation.exact`). What passes in all is below
  `A + m`, `m` the most one step passes (`Saturation.passed_lt`). A coupling that acts at each step until
  it saturates, from a level that stands, has passed `A` by step `A` and stops there
  (`Saturation.stops_by`; in the formed course, from a level standing at the start,
  `Saturation.course_stops_by`). With strengths `f a` times a
  coupling acting at each step, `f` not rising, the coupling stops by step `A` where `f` is zero at
  `A` (`Saturation.stops_by_zero`), and stops by some step exactly where `f` reaches zero at some
  amount (`Saturation.stops_iff`; in the formed course `Saturation.course_stops_iff`); with `f` at least one it recurs and at least one more passes at
  every step, however far it has weakened (`Saturation.floored`), and coupled into itself it is a
  loop that leaves every finite order inexact (`Saturation.floored_inexact`). In the formed course a
  response `A - a` stops it by step `A` (`Saturation.wearing_stops`).
''')
