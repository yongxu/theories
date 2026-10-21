# RM10: the module header's web paragraph (run inside build_tree.py with `rm` and `once` in scope).
rm = once(rm, """ Beyond a band, a bound on the run takes its place.
  A run that stays within `B` (`Coupled.Indexed.StaysWithin`) has its levels among the `(B + 1)` to the
  conditions' count lists of levels within `B` (`Coupled.Indexed.levelLists`,
  `Coupled.Indexed.levelLists_length`), so within that many steps it comes back to a state it was in
  (`Coupled.Indexed.returns_within`) and repeats from there (`Coupled.Indexed.repeats`). Whether a
  condition ends is then decided by a finite check, with no band and no order of states: it ends
  exactly where it is nothing at every step from that count `L` to `2 L`, and where it ends it is
  nothing from step `L` on (`Coupled.Indexed.ends_iff_within`). Under mutual support, wherever the run
  from a condition's top level considered stays within `B`, its point of no return given the others is
  exact (`Coupled.Indexed.thresholdWithin`, `Coupled.Indexed.ends_iff_below_within`) and does not rise
  as any other level rises (`Coupled.Indexed.threshold_falls_within`).""", """ Beyond a band, a bound on the run takes its place.
  These laws hold for any law of states read condition by condition (`Coupled.Indexed.ReadsPointwise`,
  `Coupled.Indexed.run_alike_of`), the web's step one (`Coupled.Indexed.pointwise_step`). A run that
  stays within `B` (`Coupled.Indexed.StaysWithin`) has its levels among the `(B + 1)` to the
  conditions' count lists of levels within `B` (`Coupled.Indexed.levelLists`,
  `Coupled.Indexed.levelLists_length`), so within that many steps it comes back to a state it was in
  (`Coupled.Indexed.returns_within`) and repeats from there (`Coupled.Indexed.repeats`). Whether a
  condition ends (`Coupled.Indexed.EndsUnder`) is then decided by a finite check, with no band and no
  order of states: it ends exactly where it is nothing at every step from that count `L` to `2 L`, and
  where it ends it is nothing from step `L` on (`Coupled.Indexed.ends_iff_within`). Under a law keeping
  the order of states (`Coupled.Indexed.KeepsBelow`), as the web's step does under mutual support
  (`Coupled.Indexed.step_keepsBelow`), which reads states condition by condition
  (`Coupled.Indexed.reads_of_keepsBelow`), wherever the run from a condition's top level considered
  stays within `B`, its point of no return given the others is exact
  (`Coupled.Indexed.thresholdWithin`, `Coupled.Indexed.ends_iff_below_within`) and does not rise as any
  other level rises (`Coupled.Indexed.threshold_falls_within`).""")
rm = once(rm, """  (`Coupled.Relay.threshold_beyond_band`).
""", """  (`Coupled.Relay.threshold_beyond_band`). A web with a recent giving (`Coupled.Indexed.Recent.step`)
  holds each condition's level and what it gave last, its giving a law of what is left of all and what
  each gave; under mutual support (`Coupled.Indexed.Recent.Rises`) it keeps the order of states
  (`Coupled.Indexed.Recent.keepsBelow`), so these laws hold of it with every recent giving among the
  others; the plain web is its case where giving reads nothing of what was given
  (`Coupled.Indexed.Recent.plain`), and one condition is the adjusted regime
  (`Coupled.Indexed.Recent.adjusted`). What a condition gave last can lower its point of no return:
  a giving ramping with what was given has its threshold fall from four to three as its last giving
  rises from nothing to one (`Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent`).
""")
