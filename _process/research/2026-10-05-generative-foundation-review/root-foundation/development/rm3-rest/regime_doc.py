# Executed by build_tree.py with `rm` (RegimeMargin's text) and `once` in scope.
rm = once(rm, '''  (`Crossing.crosses`).
* **The need is the regime's.**''', '''  (`Crossing.crosses`).
* **Where a run comes to rest.** A law's run with a quantity that never falls along it, rises at
  every change and is bounded comes to rest within the bound, decided at each step
  (`LastChange.still_within`). Where giving rises with what is left, the regime's step keeps the
  order of levels (`step_mono`), so a run moves one way only, and within a band up to `hi` it is
  still from some step at most `hi` (`rests_within`). Where the adjustment rises with what is left
  and with the recent giving (`Adjusted.Rises`), a run whose first step lowers neither its level nor
  its recent giving never lowers either, and one whose first step raises neither never raises either
  (`Adjusted.run_rises`, `Adjusted.run_falls`); a step that does neither, from a state whose recent
  giving is at most its level, lowers a count that is two more than the recent giving's distance
  from the draw at or above the draw and at most one below it (`Adjusted.unordered`,
  `Adjusted.unordered_falls`), so such steps run out. So, where the step keeps every state
  with level and recent giving up to `hi` at a level up to `hi` (`Adjusted.Band`), every run from
  such a state is still from some step at most `3 hi + 3` (`Adjusted.comes_to_rest`), at rest: at
  the draw with a level the regime's step leaves as it is, or below the draw on that line, the giving
  from nothing left giving it again (`Adjusted.AtRest`, `Adjusted.fixed_iff`). Where nothing gives
  from nothing, that rest below the draw is nothing; otherwise it can be something
  (`Adjusted.rests_short`). Every adjustment rests at the draw exactly where `fun e => A e H` gives
  the draw, so the law holds of every rising adjustment within a band, and the regime only names the
  point. Neither rising giving nor the band can be dropped: giving that is two from nothing and
  nothing from more keeps every state up to two within two under a draw of one, yet the run from one
  moves between one and two at every step (`Alternation.alternates`); under the gated giving, with no
  band, the run from five rises by one at every step (`Crossing.rises_without_rest`).
* **The need is the regime's.**''')
