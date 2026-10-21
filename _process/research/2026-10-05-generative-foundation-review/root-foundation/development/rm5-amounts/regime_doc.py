# Executed by build_tree.py with `rm` (RegimeMargin's text) and `once` in scope.
rm = once(rm, '''  the runs that rest below the draw (`Notch.no_threshold`).
* **The need is the regime's.**''', '''  the runs that rest below the draw (`Notch.no_threshold`).
* **The regime in any amounts.** `Drawn` reads the adjusted step in any linearly ordered amounts
  with a draw taken first, as much as there is (`Drawn.step`); whole numbers are an instance, with
  the adjusted step's run (`Drawn.whole_run`). There a run need not come to rest; its course has a
  shape. Where the adjustment rises, the step keeps the order of states (`Drawn.step_mono`), so a
  run that raises (lowers) both the level and the recent giving at one step does so at every later
  step (`Drawn.rising_on`, `Drawn.falling_on`). From the first step on, a step that neither raises
  nor lowers both climbs (the level rises strictly and the recent giving falls strictly toward the
  draw from above) or sinks (the level falls strictly and the recent giving rises strictly toward
  the draw from below), whatever the adjustment (`Drawn.climbs_or_sinks`), and the next such step is
  of the same kind (`Drawn.climbs_next`, `Drawn.sinks_next`); `Drawn.run_shape` gathers these on the
  run. So the level and the recent giving each move one way, turn at most once, and move one way
  again. A run within a band stays within it (`Drawn.run_within`), and it rests exactly at the
  regime's point or below the draw with level and recent giving equal (`Drawn.rest_iff`,
  `Drawn.still_iff`).
* **The need is the regime's.**''')
rm = once(rm, '''renewal; Clark 1976, May 1977); this module states it on the spine, with an empty axiom report, so
that the margin the theory names is the one a measurement can test.''', '''renewal; Clark 1976, May 1977); this module states it on the spine, with an empty axiom report, so
that the margin the theory names is the one a measurement can test. The adjusted step's order, the
shape of its runs and its rests hold in any linearly ordered amounts with a draw (`Drawn`); that
its runs within a band converge over the non-negative reals, to a rest where the adjustment is
continuous, is stated in the periphery module `RegimeReals`, which uses Mathlib.''')
