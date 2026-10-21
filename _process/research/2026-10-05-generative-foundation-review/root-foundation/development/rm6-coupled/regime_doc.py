# Executed by build_tree.py with `rm` the module text and `once` in scope: RM6's module doc.
RM6_BULLET_ANCHOR = '''  `Drawn.still_iff`).
* **The need is the regime's.**'''
RM6_BULLET = '''  `Drawn.still_iff`).
* **Coupled conditions: a margin that is not its own.** Two conditions can give from what is left of
  both: under draws `H₁` and `H₂`, each taken first, as much as there is, each condition's next level
  is what is left of it with `g₁` or `g₂` of what is left of each (`Coupled.step`, in any amounts with
  a draw). Where each one's giving rises with what is left of each, mutual support, the coupled step
  keeps the order of states (`Coupled.step_mono`), so a condition that ends, nothing from some step
  on, from a state ends from every state at or below it in both levels (`Coupled.ends_of_below`).
  Within a band, mutual support gives within each draw (`Coupled.within_draw`), so what the draws
  leave of each never rises along a run (`Coupled.left_falls`), and the run is still once that
  repeats (`Coupled.still_of_left`); in whole numbers it is still from some step at most `2 hi + 1`
  (`Coupled.comes_to_rest`). So for each level of its partner up to `hi` the first condition has a
  least level, `Coupled.threshold`, below which exactly it ends (`Coupled.ends_iff_below`): nothing at
  the rest below it, something from it on (`Coupled.fates`). The threshold does not rise as the
  partner's level rises (`Coupled.threshold_falls`): a condition's point of no return is a falling
  function of what stands with it. Where the second gives nothing wherever nothing is left of the
  first, while the first stays within its draw the second's next level is what its draw leaves of it
  (`Coupled.drains`), so in whole numbers it falls by its draw at every step and, its draw positive,
  is nothing within as many steps as its level (`Coupled.ends_after`): the end of the one ends the
  other (`Coupled.ends_of_partner`), and under dependence both ways the two end together or not at
  all (`Coupled.ends_together`). Exchanging the two exchanges the levels along the run
  (`Coupled.run_swap`, `Coupled.ends_swap`), and a condition whose giving reads only what is left of
  itself runs as the regime, whatever its partner does (`Coupled.first_regime`). Support can save a
  condition: under giving of one where at least one is left of each, draws of one and a band up to
  two, the first ends from two with its partner at nothing and holds from two with its partner at
  two, its threshold falling from three, beyond the band, to two (`Coupled.MutualActivation.saves`).
  Neither mutual support nor the band can be dropped. Where each gives one only where nothing is left
  of the other, within a band up to two each holds at two alone and from two and two both end, so the
  first ends from a state above one from which it holds, and its threshold rises from two to three,
  beyond the band, as its partner rises from nothing to two (`Coupled.MutualInhibition.breaks_order`); `Alternation`'s
  giving read as the first's keeps a band, and the run never rests
  (`Coupled.alternation_never_rests`). Outside a band, where each gives two only where enough is left
  of the other, each condition alone ends from every level, while from two and three the run moves
  between two and three and three and two for ever: it stays within three, neither condition ends,
  and the run is never still (`Coupled.Relay.cycles`).
* **The need is the regime's.**'''
rm = once(rm, RM6_BULLET_ANCHOR, RM6_BULLET)
RM6_CLOSE_OLD = '''continuous, is stated in the periphery module `RegimeReals`, which uses Mathlib.
-/'''
RM6_CLOSE_NEW = '''continuous, is stated in the periphery module `RegimeReals`, which uses Mathlib. Coupled conditions
keep the order of states under mutual support in any such amounts (`Coupled`); their thresholds are
stated in whole numbers, within a band.
-/'''
rm = once(rm, RM6_CLOSE_OLD, RM6_CLOSE_NEW)
