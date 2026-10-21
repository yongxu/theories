# Executed by build_tree.py with `rm` the module text and `once` in scope: RM7's module doc.
RM7_OLD = "  and the run is never still (`Coupled.Relay.cycles`).\n"
RM7_NEW = RM7_OLD + '''* **A web of coupled conditions.** The laws of order, ending and dependence hold of any number of
  conditions, indexed by any type, each under its draw and giving from what is left of all
  (`Coupled.Indexed.step`); the pair is the web indexed by `Bool` (`Coupled.pair_run`,
  `Coupled.ends_pair`), and its laws above are read off the web's. Under mutual support the web's step
  keeps the order of states condition by condition (`Coupled.Indexed.step_mono`), so raising any
  condition's level never ends one that held (`Coupled.Indexed.ends_of_below`). Where a condition gives
  nothing wherever nothing is left of another (`Coupled.Indexed.DependsOn`), it drains once the other
  stays within its draw (`Coupled.Indexed.drains`, `Coupled.Indexed.ends_after`), and the end of the
  other ends it (`Coupled.Indexed.ends_of_partner`). Along every chain of dependence
  (`Coupled.Indexed.Downstream`), where every dependent's draw is positive, the end of one ends
  everything downstream of it (`Coupled.Indexed.ends_downstream`), and conditions each downstream of
  the other end together or not at all (`Coupled.Indexed.ends_together`). The cascade reaches a
  condition that does not depend directly on the first: of three conditions in a chain under draws of
  one, the third depends on the second and the second on the first, the third not on the first, and
  the first's end ends the third (`Coupled.Indexed.Chain.cascades`). The positive draws cannot be
  dropped: with no draw on the second, the first still ends, yet the second never drains and the third
  holds at two for ever (`Coupled.Indexed.Chain.stopped`).
'''
rm = once(rm, RM7_OLD, RM7_NEW)
RM7_CLOSE_OLD = '''Coupled conditions
keep the order of states under mutual support in any such amounts (`Coupled`); their thresholds are
stated in whole numbers, within a band.'''
RM7_CLOSE_NEW = '''Coupled conditions,
two or a web of any number, keep the order of states under mutual support in any such amounts
(`Coupled`, `Coupled.Indexed`); the pair's thresholds are stated in whole numbers, within a band, and
the cascade of ends along chains of dependence in whole numbers.'''
rm = once(rm, RM7_CLOSE_OLD, RM7_CLOSE_NEW)
