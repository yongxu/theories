# RM9: the module header's web paragraph (run inside build_tree.py with `rm` and `once` in scope).
rm = once(rm, """Stated condition by condition, rest needs no
  equality of functions: mutual support makes each condition's giving respect what is left condition
  by condition (`Coupled.Indexed.respects`, `Coupled.Indexed.step_alike`, `Coupled.Indexed.run_alike`).""",
"""Stated condition by condition, rest needs no
  equality of functions: where each condition's giving reads what is left condition by condition
  (`Coupled.Indexed.Pointwise`), as mutual support does (`Coupled.Indexed.respects`,
  `Coupled.Indexed.pointwise_of_rises`), states alike at every condition step and run alike
  (`Coupled.Indexed.step_alike`, `Coupled.Indexed.run_alike`).""")
rm = once(rm, """  `Coupled.pair_still`, `Coupled.threshold_pair`).
""", """  `Coupled.pair_still`, `Coupled.threshold_pair`). Beyond a band, a bound on the run takes its place.
  A run that stays within `B` (`Coupled.Indexed.StaysWithin`) has its levels among the `(B + 1)` to the
  conditions' count lists of levels within `B` (`Coupled.Indexed.levelLists`,
  `Coupled.Indexed.levelLists_length`), so within that many steps it comes back to a state it was in
  (`Coupled.Indexed.returns_within`) and repeats from there (`Coupled.Indexed.repeats`). Whether a
  condition ends is then decided by a finite check, with no band and no order of states: it ends
  exactly where it is nothing at every step from that count `L` to `2 L`, and where it ends it is
  nothing from step `L` on (`Coupled.Indexed.ends_iff_within`). Under mutual support, wherever the run
  from a condition's top level considered stays within `B`, its point of no return given the others is
  exact (`Coupled.Indexed.thresholdWithin`, `Coupled.Indexed.ends_iff_below_within`) and does not rise
  as any other level rises (`Coupled.Indexed.threshold_falls_within`). `Relay` keeps no band from three
  up, yet from two with its partner at three its run stays within three: its first condition's
  threshold is three with the partner at two and two with the partner at three
  (`Coupled.Relay.threshold_beyond_band`).
""")
