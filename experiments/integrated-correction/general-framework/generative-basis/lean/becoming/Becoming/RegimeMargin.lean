import Becoming.Recurrence
import Becoming.Lasting
import Becoming.LastChange
import Becoming.Optimum

/-!
# The margin of a regime: giving read off the level, under a standing draw

`Becoming.Retaining`'s margin law compares the levels with a part and the levels without it while
the rest's exchanges are held as they were (`Flow.WithheldLevels`). On measured data that comparison
holds as an identity; what a measurement can test is the margin with the rest responding. This
module states that margin. Under a standing draw `H`, a condition gives by a law of its level, `g`:
what it gives back from what is left, its equation of state in that regime. The draw takes first at
every step, as much as there is: `step g H x = (x - H) + g (x - H)`. Every law below is stated on
a run of the spine: `Law.run (step g H) x`, or the run of the adjusted step on the level and the
recent giving. Where laws compare regimes, each draw has its own giving law: on real yeast, giving
at the same level falls as the standing draw rises (study section 266, MQ2), so the giving law is
the regime's and not the level's alone.

* **Below the point of no return the condition is gone.** Where giving falls short of the draw at
  every level below `y` (`Short g H y`) and nothing gives from nothing (`FromNothing g`), a positive
  level below `H + y` falls at every step (`Adjusted.step_below`), is nothing after as many steps
  as it stood (`ends_below`) and stays nothing (`stays_ended`).
* **At or above it, the condition holds.** Where giving meets the draw from `y` up to a top `hi`
  (`Meets g H y hi`) and the step keeps every level up to `hi` within it (`Keeps g H hi`), a level
  from `H + y` up to `hi` never falls below where it started (`holds`). The point is exact: from a
  level up to `hi`, the condition ends exactly where the level starts below `H + y`
  (`ends_iff_below`).
* **Giving that adjusts.** A condition can carry what it gave before: its state is its level and its
  recent giving, and the giving at a step is any law `A` of what is left and of the recent giving
  (`Adjusted.step`). The regime's step is the case where `A` reads what is left alone, and the laws
  above on ending and holding are stated from their general forms (`Adjusted.orbit_regime`); the
  frozen rest, which holds the giving as it was, is the case where `A` reads the recent giving
  alone. Where the adjusted giving rests at the draw exactly where the regime gives the draw
  (`Adjusted.RestsAtDraw`, which every giving between the recent and the regime's has where it moves
  wherever it differs from the regime's, `Adjusted.Between.restsAtDraw`), a level at or above the
  draw with a recent giving is left as it is exactly where the recent giving is the draw and the
  regime's step leaves the level as it is (`Adjusted.rest_iff`), and its run stays where it started
  exactly where the regime's run from the level stays at the level (`Adjusted.rests_iff`,
  `Adjusted.Between.rests_iff`): wherever a run rests at or above the draw, at any rate of
  adjustment, it rests at a level the regime's step leaves as it is. That premise cannot be dropped:
  the frozen rest lies between the recent giving and the regime's, and from four with a recent
  giving at a draw of three its run stays at four, where the regime's step ends the condition
  (`Adjusted.frozen_rests`, `Crossing.frozen_stays`). Where the adjusted giving stays on the draw's
  side where the recent and the regime's giving both are (`Adjusted.StaysShort`,
  `Adjusted.StaysMet`, which every giving between them has), below the point of no return with the
  recent giving short of the draw the condition is gone (`Adjusted.ends_below`; where `y` is
  positive, whatever is given from nothing, the draw takes all there is, `Adjusted.taken_whole`), at
  or above it with the recent giving meeting the draw it holds (`Adjusted.holds`,
  `Adjusted.holds_from`), and the point is exact on the state (`Adjusted.ends_iff_below`,
  `Adjusted.Between.ends_iff_below`). The recent giving's side cannot be dropped: under giving gated
  at two and a draw of three the point is five; the regime's step ends the condition from four and
  holds it from five, while giving moving one unit a step toward the regime's holds it from four
  with a recent giving of six and ends it from five with a recent giving of nothing
  (`Crossing.crosses`).
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
* **One law of exact thresholds.** Every point of no return below is one law, stated once on the
  leading run of `true` among a check's first values (`leading`): where a reading of levels is closed
  downward up to `hi` and a check is exact for it there, the reading holds exactly below the check's
  leading run (`leading_exact`); a reading implied by another has a threshold no lower
  (`leading_falls`); and a check exact for the levels below `t` has threshold `t` (`leading_eq`).
  Checks that agree have the same threshold (`leading_congr`).
* **The threshold in the plane.** Where the adjustment rises with what is left and with the recent
  giving and keeps a band up to `hi`, a state at or below one whose run comes to rest below the draw
  comes to rest below it too (`Adjusted.falls_of_below`), and whether it does is decided at step
  `3 hi + 3` (`Adjusted.falls_iff`). So for each recent giving up to `hi` there is a least level,
  `Adjusted.threshold`, below which exactly the runs come to rest below the draw
  (`Adjusted.falls_iff_below`), and it does not rise as the recent giving rises
  (`Adjusted.threshold_falls`). Below it a run rests below the draw with level and recent giving
  equal, at nothing where nothing gives from nothing; from it on, a run rests at the draw with a
  level the regime's step leaves as it is (`Adjusted.fates`). The point of no return is a falling
  curve in the plane of level and recent giving, and under the regime's step it is `H + y` at every
  recent giving (`threshold_regime`). Rising giving cannot be dropped: giving that is two from one
  and nothing from any other level keeps a band up to four under a draw of two, yet the run from
  four comes to rest at nothing and the run from three rests at three, so no least level separates
  the runs that rest below the draw (`Notch.no_threshold`).
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
* **Coupled conditions: a margin that is not its own.** Two conditions can give from what is left of
  both: under draws `H₁` and `H₂`, each taken first, as much as there is, each condition's next level
  is what is left of it with `g₁` or `g₂` of what is left of each (`Coupled.step`, in any amounts with
  a draw). Where each one's giving rises with what is left of each, mutual support, the coupled step
  keeps the order of states (`Coupled.step_mono`), so a condition that ends, nothing from some step
  on, from a state ends from every state at or below it in both levels (`Coupled.ends_of_below`).
  Within a band, mutual support gives within each draw (`Coupled.Indexed.within_draw`), so what the
  draws leave of each never rises along a run (`Coupled.Indexed.left_falls`), and the run is still once
  that repeats (`Coupled.Indexed.still_of_left`); in whole numbers it is still from some step at most
  `2 hi + 1` (`Coupled.comes_to_rest`), the web's law read for the pair (`Coupled.rests_by`). So for each level of its partner up to `hi` the first condition has a
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
* **A web of coupled conditions.** The laws of order, ending and dependence hold of any number of
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
  holds at two for ever (`Coupled.Indexed.Chain.stopped`). Stated condition by condition, rest needs no
  equality of functions: where each condition's giving reads what is left condition by condition
  (`Coupled.Indexed.Pointwise`), as mutual support does (`Coupled.Indexed.respects`,
  `Coupled.Indexed.pointwise_of_rises`), states alike at every condition step and run alike
  (`Coupled.Indexed.step_alike`, `Coupled.Indexed.run_alike`).
  So for finitely many conditions, listed by a list covering them, within a band up to `hi`
  (`Coupled.Indexed.Band`) each condition gives within its draw (`Coupled.Indexed.within_draw`), what
  the draws leave of each never rises (`Coupled.Indexed.left_falls`), the run is still once that
  repeats (`Coupled.Indexed.still_of_left`), and it is still from some step at most the conditions'
  count times `hi` with one (`Coupled.Indexed.rests_by`, `Coupled.Indexed.comes_to_rest`). Whether a
  condition ends is decided there (`Coupled.Indexed.ends_iff`). Each condition has, given the other
  levels, a least level below which exactly it ends (`Coupled.Indexed.threshold`,
  `Coupled.Indexed.ends_iff_below`), every state has its fate by it (`Coupled.Indexed.fates`), and the
  threshold does not rise as any other level rises (`Coupled.Indexed.threshold_falls`): a condition's
  point of no return is a falling function of everything that stands with it. The pair's rest and
  points of no return are these laws read for the two conditions (`Coupled.band_web`,
  `Coupled.pair_still`, `Coupled.threshold_pair`). Beyond a band, a bound on the run takes its place.
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
  other level rises (`Coupled.Indexed.threshold_falls_within`). `Relay` keeps no band from three
  up, yet from two with its partner at three its run stays within three: its first condition's
  threshold is three with the partner at two and two with the partner at three
  (`Coupled.Relay.threshold_beyond_band`). A web with a recent giving (`Coupled.Indexed.Recent.step`)
  holds each condition's level and what it gave last, its giving a law of what is left of all and what
  each gave; under mutual support (`Coupled.Indexed.Recent.Rises`) it keeps the order of states
  (`Coupled.Indexed.Recent.keepsBelow`), so these laws hold of it with every recent giving among the
  others; the plain web is its case where giving reads nothing of what was given
  (`Coupled.Indexed.Recent.plain`), and one condition is the adjusted regime
  (`Coupled.Indexed.Recent.adjusted`). What a condition gave last can lower its point of no return:
  a giving ramping with what was given has its threshold fall from four to three as its last giving
  rises from nothing to one (`Coupled.Indexed.Recent.Momentum.threshold_falls_with_recent`).
* **The need is the regime's.** Where giving stops below a need `m` (`Gated g m`), every level at
  which giving meets a positive draw lies at or above the need (`root_above_need`), so the point of
  no return lies at least the draw above the need, and more than the draw above it exactly where
  giving at the need falls short of the draw (`beyond_draw_iff`). A larger draw under which giving is
  no greater has a point of no return higher by at least the difference of the draws
  (`rises_by_draw`). Giving lowered by the regime raises the need beyond what the removal alone
  gives: the least level meeting a draw is no lower under the lowered giving, and higher exactly
  where the lowered giving falls short of the draw at the old least level (`lowered_raises`,
  `lowered_raises_strictly`). A margin, a level's distance above this point, is a quantity of the
  level under the standing draws, not of the level alone.
* **Draws add; harms do not.** Where giving under the joint draw is subadditive above the need
  (`SubadditiveAbove`) and no greater than under either draw alone, the rise of the point of no
  return under two draws together is at least the sum of the rises under each, less one whole unit
  (`harms_superadditive`). `Concave` is a giving law under which it is
  strictly more (`Concave.roots`). `Peaked` has two draws each of which the condition holds alone
  from a band of levels (`Peaked.each_holds`) and which together end it from every level
  (`Peaked.together_ends`), by the law that a draw beyond all giving ends the condition from every
  level (`ends_beyond_giving`).
* **The time to break lies in a band.** The level stays at or above `b` for every `n` with
  `b + H n ≤ x` (`not_before`). Where giving is at most `Y` at every level and `Y ≤ H ≤ b`, the level
  falls below `b` within any `n` with `x < b + (H - Y) n` (`falls_within`).

Two statements carry the whole numbers: `harms_superadditive` loses one unit to rounding, and the
band's ends are whole steps. Harvesting theory states the same structure over the reals
(depensation, the fold of the harvested equilibrium, the cost of joint harvest from a concave
renewal; Clark 1976, May 1977); this module states it on the spine, with an empty axiom report, so
that the margin the theory names is the one a measurement can test. The adjusted step's order, the
shape of its runs and its rests hold in any linearly ordered amounts with a draw (`Drawn`); that
its runs within a band converge over the non-negative reals, to a rest where the adjustment is
continuous, is stated in the periphery module `RegimeReals`, which uses Mathlib. Coupled conditions,
two or a web of any number, keep the order of states under mutual support in any such amounts
(`Coupled`, `Coupled.Indexed`); the pair's thresholds are stated in whole numbers, within a band, and
the cascade of ends along chains of dependence in whole numbers.
-/

namespace Becoming

namespace RegimeMargin

/-! ## The step under a standing draw -/

/-- One step of a condition at level `x` under a standing draw `H`: the draw takes first, as much
as there is, and the condition gives `g` of what is left. -/
def step (g : Nat → Nat) (H x : Nat) : Nat := (x - H) + g (x - H)

/-- Nothing gives from nothing. -/
def FromNothing (g : Nat → Nat) : Prop := g 0 = 0

/-- Giving falls short of the draw `H` at every level below `y`. -/
def Short (g : Nat → Nat) (H y : Nat) : Prop := ∀ z, z < y → g z < H

/-- `y` is the least level at which giving meets the draw `H`. -/
def Root (g : Nat → Nat) (H y : Nat) : Prop := H ≤ g y ∧ Short g H y

/-- Giving meets the draw `H` at every level from `y` that, with the draw added back, is within
`hi`. -/
def Meets (g : Nat → Nat) (H y hi : Nat) : Prop := ∀ z, y ≤ z → z + H ≤ hi → H ≤ g z

/-- The step keeps every level up to `hi` within `hi`. -/
def Keeps (g : Nat → Nat) (H hi : Nat) : Prop := ∀ x, x ≤ hi → step g H x ≤ hi

/-- Giving stops below the need `m`. -/
def Gated (g : Nat → Nat) (m : Nat) : Prop := ∀ z, z < m → g z = 0

/-- Giving above the need `m` is subadditive. -/
def SubadditiveAbove (g : Nat → Nat) (m : Nat) : Prop :=
  ∀ p q, g (m + (p + q)) ≤ g (m + p) + g (m + q)

/-- Giving is at most `Y` at every level. -/
def AtMost (g : Nat → Nat) (Y : Nat) : Prop := ∀ z, g z ≤ Y

/-- The draw added back to the step is at least the level. -/
theorem step_ge (g : Nat → Nat) (H x : Nat) : x ≤ step g H x + H :=
  (Nat.lt_or_ge x H).elim
    (fun lt => Nat.le_trans (Nat.le_of_lt lt) (Nat.le_add_left H _))
    (fun ge => calc x = x - H + H := (Naturals.sub_add_cancel ge).symm
      _ ≤ x - H + g (x - H) + H := Nat.add_le_add_right (Nat.le_add_right _ _) H)

/-! ## Giving that adjusts

The step above reads giving off what the draw leaves, alone. A condition can carry what it gave
before: its state is its level and its recent giving, and the giving at a step is a law `A` of what
is left and of the recent giving, which is the next step's recent giving. The regime's step is the
case where `A` reads what is left alone (`orbit_regime`); the frozen rest, which holds the giving
as it was, the case where it reads the recent giving alone. Every law of this section holds over
every such `A` with the properties it names, and the laws of the regime's step below are their
case. -/

namespace Adjusted

/-- One step of a condition whose giving adjusts. At level `p.1` with recent giving `p.2`, the draw
`H` takes first, as much as there is; the giving is `A` of what is left and of the recent giving;
the next level is what is left with that giving, which is the next step's recent giving. -/
def step (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : Nat × Nat :=
  (p.1 - H + A (p.1 - H) p.2, A (p.1 - H) p.2)

/-- Where the recent giving and the regime's giving both fall short of the draw, so does the
adjusted giving. -/
def StaysShort (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=
  ∀ e r, r < H → g e < H → A e r < H

/-- Where the recent giving and the regime's giving both meet the draw, so does the adjusted
giving. -/
def StaysMet (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=
  ∀ e r, H ≤ r → H ≤ g e → H ≤ A e r

/-- The adjusted giving rests at the draw exactly where the regime gives the draw. -/
def RestsAtDraw (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) : Prop :=
  ∀ e, A e H = H ↔ g e = H

/-- From nothing left the adjusted giving is nothing, whatever was given before. -/
def FromNothing (A : Nat → Nat → Nat) : Prop := ∀ r, A 0 r = 0

/-- The adjusted step keeps every level up to `hi` within `hi` where the recent giving meets the
draw. -/
def Keeps (A : Nat → Nat → Nat) (H hi : Nat) : Prop :=
  ∀ x r, x ≤ hi → H ≤ r → (step A H (x, r)).1 ≤ hi

/-- The adjusted giving lies between the recent giving and the regime's giving. -/
def Between (A : Nat → Nat → Nat) (g : Nat → Nat) : Prop :=
  ∀ e r, (r ≤ A e r ∧ A e r ≤ g e) ∨ (g e ≤ A e r ∧ A e r ≤ r)

/-- The adjusted giving moves wherever it differs from the regime's: it rests only there. -/
def Settles (A : Nat → Nat → Nat) (g : Nat → Nat) : Prop :=
  ∀ e r, A e r = r → r = g e

/-! ### The regime's step and the frozen rest as cases -/

/-- **The regime's step is the case reading what is left alone**: along every run, the level of
the adjusted state whose giving is the regime's is the run of the regime's step. -/
theorem orbit_regime (g : Nat → Nat) (H : Nat) (p : Nat × Nat) :
    ∀ n, (Law.orbit (step (fun e _ => g e) H) p n).1 = Law.orbit (RegimeMargin.step g H) p.1 n
  | 0 => rfl
  | n + 1 => congrArg (RegimeMargin.step g H) (orbit_regime g H p n)

theorem regime_staysShort (g : Nat → Nat) (H : Nat) : StaysShort (fun e _ => g e) g H :=
  fun _ _ _ short => short

theorem regime_staysMet (g : Nat → Nat) (H : Nat) : StaysMet (fun e _ => g e) g H :=
  fun _ _ _ met => met

theorem regime_fromNothing {g : Nat → Nat} (nothing : RegimeMargin.FromNothing g) :
    FromNothing (fun e _ => g e) :=
  fun _ => nothing

theorem regime_keeps {g : Nat → Nat} {H hi : Nat} (keeps : RegimeMargin.Keeps g H hi) :
    Keeps (fun e _ => g e) H hi :=
  fun x _ high _ => keeps x high

/-- Giving between the recent giving and the regime's stays short of the draw where both are. -/
theorem Between.staysShort {A : Nat → Nat → Nat} {g : Nat → Nat} (between : Between A g)
    (H : Nat) : StaysShort A g H :=
  fun e r rshort gshort => (between e r).elim
    (fun ⟨_, le⟩ => Nat.lt_of_le_of_lt le gshort)
    (fun ⟨_, le⟩ => Nat.lt_of_le_of_lt le rshort)

/-- Giving between the recent giving and the regime's meets the draw where both do. -/
theorem Between.staysMet {A : Nat → Nat → Nat} {g : Nat → Nat} (between : Between A g)
    (H : Nat) : StaysMet A g H :=
  fun e r rmet gmet => (between e r).elim
    (fun ⟨ge, _⟩ => Nat.le_trans rmet ge)
    (fun ⟨ge, _⟩ => Nat.le_trans gmet ge)

/-- Giving between the recent giving and the regime's, moving wherever it differs from the
regime's, rests at the draw exactly where the regime gives the draw. -/
theorem Between.restsAtDraw {A : Nat → Nat → Nat} {g : Nat → Nat} (between : Between A g)
    (settles : Settles A g) (H : Nat) : RestsAtDraw A g H :=
  fun e => ⟨fun rest => (settles e H rest).symm,
    fun gives => (between e H).elim
      (fun ⟨ge, le⟩ => Nat.le_antisymm (Nat.le_trans le (Nat.le_of_eq gives)) ge)
      (fun ⟨ge, le⟩ => Nat.le_antisymm le (Nat.le_trans (Nat.le_of_eq gives.symm) ge))⟩

/-- The frozen rest, which holds the giving as it was, lies between the recent giving and the
regime's. -/
theorem frozen_between (g : Nat → Nat) : Between (fun _ r => r) g :=
  fun e r => (Nat.le_total r (g e)).elim
    (fun le => Or.inl ⟨Nat.le_refl r, le⟩)
    (fun ge => Or.inr ⟨ge, Nat.le_refl r⟩)

/-- **The frozen rest rests everywhere at the draw.** Holding the giving at the draw, every level at
or above the draw is left as it is, whatever the regime gives there. -/
theorem frozen_rests {H x : Nat} (atLeast : H ≤ x) : step (fun _ r => r) H (x, H) = (x, H) :=
  congrArg (fun a => (a, H)) (Naturals.sub_add_cancel atLeast)

/-! ### Where the state rests -/

/-- **At or above the draw, every rest point is the regime's.** Where the adjusted giving rests at
the draw exactly where the regime gives the draw, a level at or above the draw with a recent giving
is left as it is by the step exactly where the recent giving is the draw and the regime's step
leaves the level as it is: wherever a run of such an adjustment comes to rest at or above the draw,
whatever its rate, its memory or its pull toward the draw, it rests at a point the regime's step
leaves as it is. -/
theorem rest_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H x r : Nat} (rests : RestsAtDraw A g H)
    (atLeast : H ≤ x) : step A H (x, r) = (x, r) ↔ r = H ∧ RegimeMargin.step g H x = x := by
  have back : x - H + H = x := Naturals.sub_add_cancel atLeast
  constructor
  · intro fixed
    have level : x - H + A (x - H) r = x := congrArg Prod.fst fixed
    have giving : A (x - H) r = r := congrArg Prod.snd fixed
    have draw : A (x - H) r = H := Naturals.add_left_cancel (level.trans back.symm)
    have rH : r = H := giving.symm.trans draw
    have atDraw : A (x - H) H = H := Eq.subst (motive := fun v => A (x - H) v = v) rH giving
    refine ⟨rH, ?_⟩
    show x - H + g (x - H) = x
    rw [(rests (x - H)).1 atDraw]
    exact back
  · intro ⟨rH, fixed⟩
    have gives : g (x - H) = H :=
      Naturals.add_left_cancel ((show x - H + g (x - H) = x from fixed).trans back.symm)
    have atDraw : A (x - H) H = H := (rests (x - H)).2 gives
    have ar : A (x - H) r = r := (congrArg (A (x - H)) rH).trans (atDraw.trans rH.symm)
    show (x - H + A (x - H) r, A (x - H) r) = (x, r)
    rw [ar, rH, back]

/-- **On the run, every rest at or above the draw is the regime's.** Where the adjusted giving rests
at the draw exactly where the regime gives the draw, the run from a level at or above the draw with
a recent giving stays where it started exactly where the recent giving is the draw and the regime's
run from the level stays at the level. -/
theorem rests_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H x r : Nat} (rests : RestsAtDraw A g H)
    (atLeast : H ≤ x) :
    (∀ n, (Law.run (step A H) (x, r)).state n = (x, r)) ↔
      r = H ∧ ∀ n, (Law.run (RegimeMargin.step g H) x).state n = x :=
  ⟨fun stays =>
    have ⟨rH, fixed⟩ := (rest_iff rests atLeast).1 (stays 1)
    ⟨rH, fun n => (congrArg (Law.orbit (RegimeMargin.step g H) x) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := RegimeMargin.step g H) (s := x) (p := 1) fixed n)⟩,
   fun ⟨rH, stays⟩ =>
    have fixed := (rest_iff rests atLeast).2 ⟨rH, stays 1⟩
    fun n => (congrArg (Law.orbit (step A H) (x, r)) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := step A H) (s := (x, r)) (p := 1) fixed n)⟩

/-- **Every giving between the recent and the regime's that moves wherever it differs from the
regime's rests on the run only at the regime's point**: at or above the draw, its run stays where it
started exactly where the recent giving is the draw and the regime's run stays at the level. -/
theorem Between.rests_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H x r : Nat}
    (between : Between A g) (settles : Settles A g) (atLeast : H ≤ x) :
    (∀ n, (Law.run (step A H) (x, r)).state n = (x, r)) ↔
      r = H ∧ ∀ n, (Law.run (RegimeMargin.step g H) x).state n = x :=
  Adjusted.rests_iff (between.restsAtDraw settles H) atLeast

/-! ### Below the point of no return -/

/-- The draw is positive where giving falls short of it below `y` and a level lies below `H + y`. -/
theorem draw_pos {g : Nat → Nat} {H y x : Nat} (short : Short g H y) (below : x < H + y) :
    0 < H :=
  (Nat.eq_zero_or_pos H).elim
    (fun zero => by
      subst zero
      have ypos : 0 < y := Nat.lt_of_le_of_lt (Nat.zero_le x)
        (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.zero_add y)))
      exact absurd (short 0 ypos) (Nat.not_lt_zero (g 0)))
    id

/-- What the draw leaves falls by at least one at a step whose giving falls short of the draw,
unless nothing is left. -/
theorem left_falls {d a H : Nat} (gives : a < H) : d + a - H ≤ d - 1 :=
  (Nat.lt_or_ge (d + a) H).elim
    (fun small => by rw [sub_eq_zero_of_le (Nat.le_of_lt small)]; exact Nat.zero_le _)
    (fun big => by
      have sum : d + a - H + H = d + a := Naturals.sub_add_cancel big
      have lt : d + a - H + 1 + H ≤ d + H := by
        rw [Nat.add_right_comm, sum]; exact Nat.add_lt_add_left gives d
      have one : 1 + (d + a - H) ≤ d := by
        rw [Nat.add_comm]; exact Naturals.le_of_add_le_add_right lt
      exact Naturals.le_sub_of_add_le one)

/-- Below the point of no return, what the draw leaves is below the point's distance above the
draw. -/
theorem left_below {H y x : Nat} (ypos : 0 < y) (below : x < H + y) : x - H < y :=
  (Nat.lt_or_ge x H).elim
    (fun lt => by rw [sub_eq_zero_of_le (Nat.le_of_lt lt)]; exact ypos)
    (fun ge => by
      have back : x - H + H = x := Naturals.sub_add_cancel ge
      have within : H + (x - H) + 1 ≤ H + y := by
        rw [Nat.add_comm H (x - H), back]; exact below
      exact Naturals.le_of_add_le_add_left within)

/-- Below the point of no return, with the recent giving short of the draw, the step keeps the
level below the point and the recent giving short of the draw, and lowers every positive level. -/
theorem step_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :
    (step A H (x, r)).1 < H + y ∧ (step A H (x, r)).2 < H ∧ (0 < x → (step A H (x, r)).1 < x) :=
  (Nat.lt_or_ge x H).elim
    (fun lt => by
      have gone : x - H = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
      show x - H + A (x - H) r < H + y ∧ A (x - H) r < H ∧ (0 < x → x - H + A (x - H) r < x)
      rw [gone, nothing r]
      exact ⟨Nat.lt_of_le_of_lt (Nat.zero_le x) below, Nat.lt_of_le_of_lt (Nat.zero_le x) lt, id⟩)
    (fun ge => by
      have back : x - H + H = x := Naturals.sub_add_cancel ge
      have within : H + (x - H) + 1 ≤ H + y := by
        rw [Nat.add_comm H (x - H), back]; exact below
      have left : x - H < y := Naturals.le_of_add_le_add_left within
      have gives : A (x - H) r < H := stays _ _ rshort (short _ left)
      have falls : x - H + A (x - H) r < x :=
        Nat.lt_of_lt_of_le (Nat.add_lt_add_left gives _) (Nat.le_of_eq back)
      show x - H + A (x - H) r < H + y ∧ A (x - H) r < H ∧ (0 < x → x - H + A (x - H) r < x)
      exact ⟨Nat.lt_trans falls below, gives, fun _ => falls⟩)

/-- From nothing, the level stays at nothing, whatever the recent giving, where nothing is given from
nothing. -/
theorem from_zero {A : Nat → Nat → Nat} (H : Nat) (nothing : FromNothing A) {p : Nat × Nat}
    (zero : p.1 = 0) : ∀ k, (Law.orbit (step A H) p k).1 = 0
  | 0 => zero
  | k + 1 => by
    show (Law.orbit (step A H) p k).1 - H +
      A ((Law.orbit (step A H) p k).1 - H) (Law.orbit (step A H) p k).2 = 0
    rw [from_zero H nothing zero k, Nat.zero_sub, nothing, Nat.zero_add]

/-- **The adjusted step balances.** The level after a step, with what the draw takes (all there is,
up to `H`), is the level before with what is given. -/
theorem step_balances (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) :
    (step A H p).1 + (p.1 - (p.1 - H)) = p.1 + A (p.1 - H) p.2 :=
  (Nat.add_right_comm (p.1 - H) (A (p.1 - H) p.2) (p.1 - (p.1 - H))).trans
    (congrArg (· + A (p.1 - H) p.2) (Naturals.add_sub_of_le (Nat.sub_le p.1 H)))

/-- Below the point of no return, with the recent giving short of the draw, the run stays below the
point with the recent giving short of the draw. -/
theorem orbit_inside {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :
    ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H
  | 0 => ⟨below, rshort⟩
  | n + 1 =>
    have ⟨inside, still⟩ := orbit_inside short stays nothing below rshort n
    have next := step_below (x := (Law.orbit (step A H) (x, r) n).1)
      (r := (Law.orbit (step A H) (x, r) n).2) short stays nothing inside still
    ⟨next.1, next.2.1⟩

/-- Below the point of no return, with the recent giving short of the draw, after `n` steps the
level is still below the point, the recent giving still short of the draw, and the level has
fallen by at least `n`. The fall is rest by balance (`Amounts.falls_by_stretch`): the run balances
across each step (`step_balances`), and at each step at which the level is positive the draw takes
at least one more than is given; where the level reaches nothing first, it stays there. -/
theorem orbit_bound {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :
    ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H ∧
      (Law.orbit (step A H) (x, r) n).1 ≤ x - n := fun n =>
  have inside := orbit_inside short stays nothing below rshort
  have fell : (Law.orbit (step A H) (x, r) n).1 ≤ x - n :=
    match Amounts.unmarked_or_marked (P := fun k => 0 < (Law.orbit (step A H) (x, r) k).1)
        (fun k => (Nat.lt_or_ge 0 (Law.orbit (step A H) (x, r) k).1).elim .inl
          fun none => .inr (Nat.not_lt_of_ge none)) 0 n with
    | .inl ⟨k, _, before, unmarked⟩ =>
      have zero : (Law.orbit (step A H) (x, r) k).1 = 0 :=
        Nat.eq_zero_of_le_zero (Nat.le_of_not_lt unmarked)
      have same : k + (n - k) = n :=
        Naturals.add_sub_of_le (Nat.le_of_lt (Nat.lt_of_lt_of_le before (Nat.le_of_eq (Nat.zero_add n))))
      Nat.le_trans (Nat.le_of_eq ((congrArg (fun m => (Law.orbit (step A H) (x, r) m).1) same).symm.trans
        ((congrArg Prod.fst (Law.orbit_add (step A H) (x, r) k (n - k))).trans
          (from_zero H nothing zero (n - k))))) (Nat.zero_le _)
    | .inr positive =>
      have fallen := Amounts.falls_by_stretch (q := fun k => (Law.orbit (step A H) (x, r) k).1)
        (x := fun k => (Law.orbit (step A H) (x, r) k).1 - ((Law.orbit (step A H) (x, r) k).1 - H))
        (y := fun k => A ((Law.orbit (step A H) (x, r) k).1 - H) (Law.orbit (step A H) (x, r) k).2)
        0 n (fun k _ _ => step_balances A H (Law.orbit (step A H) (x, r) k))
        fun k _ before => Naturals.le_sub_of_add_le
          ((step_below (x := (Law.orbit (step A H) (x, r) k).1) (r := (Law.orbit (step A H) (x, r) k).2)
            short stays nothing (inside k).1 (inside k).2).2.2 (positive k (Nat.zero_le k) before))
      Naturals.le_sub_of_add_le (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _))
        (Nat.le_trans (Nat.le_of_eq (congrArg (fun m => (Law.orbit (step A H) (x, r) m).1 + n)
          (Nat.zero_add n).symm)) fallen))
  ⟨(inside n).1, (inside n).2, fell⟩

/-- **Below the point of no return, with the recent giving short of the draw, the condition is
gone**, after as many steps as it stood, at every adjustment keeping giving short where the recent
and the regime's giving are and giving nothing from nothing. -/
theorem ends_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H) :
    ((Law.run (step A H) (x, r)).state x).1 = 0 := by
  have bound := (orbit_bound short stays nothing below rshort x).2.2
  rw [Nat.sub_self] at bound
  exact Nat.eq_zero_of_le_zero bound

/-- Once gone below the point of no return, the condition stays gone. -/
theorem stays_ended {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (nothing : FromNothing A) (below : x < H + y) (rshort : r < H)
    (k : Nat) : ((Law.run (step A H) (x, r)).state (x + k)).1 = 0 :=
  (congrArg Prod.fst (Law.orbit_add (step A H) (x, r) x k)).trans
    (from_zero H nothing (ends_below short stays nothing below rshort) k)

/-- Below the point of no return, with the recent giving short of the draw, at every adjustment
keeping giving short where the recent and the regime's giving are, whatever it gives from nothing:
after `n` steps the level is below the point, the recent giving short of the draw, and what the
draw leaves has fallen by at least `n`. -/
theorem left_bound {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (ypos : 0 < y) (below : x < H + y) (rshort : r < H) :
    ∀ n, (Law.orbit (step A H) (x, r) n).1 < H + y ∧ (Law.orbit (step A H) (x, r) n).2 < H ∧
      (Law.orbit (step A H) (x, r) n).1 - H ≤ x - H - n
  | 0 => ⟨below, rshort, Nat.le_refl _⟩
  | n + 1 => by
    have ⟨inside, still, le⟩ := left_bound short stays ypos below rshort n
    have left := left_below ypos inside
    have gives := stays _ _ still (short _ left)
    show (Law.orbit (step A H) (x, r) n).1 - H +
        A ((Law.orbit (step A H) (x, r) n).1 - H) (Law.orbit (step A H) (x, r) n).2 < H + y ∧
      A ((Law.orbit (step A H) (x, r) n).1 - H) (Law.orbit (step A H) (x, r) n).2 < H ∧
      (Law.orbit (step A H) (x, r) n).1 - H +
        A ((Law.orbit (step A H) (x, r) n).1 - H) (Law.orbit (step A H) (x, r) n).2 - H ≤
          x - H - (n + 1)
    refine ⟨?_, gives, ?_⟩
    · rw [Nat.add_comm H y]; exact Nat.add_lt_add left gives
    · rw [← Naturals.sub_sub (x - H) n 1]
      exact Nat.le_trans (left_falls gives) (Nat.pred_le_pred le)

/-- **Below the point of no return, with the recent giving short of the draw, the draw takes all
there is** from as many steps on as the level stood above the draw, at every adjustment keeping
giving short where the recent and the regime's giving are, whatever it gives from nothing: from
then on the level is at most the draw. -/
theorem taken_whole {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat} (short : Short g H y)
    (stays : StaysShort A g H) (ypos : 0 < y) (below : x < H + y) (rshort : r < H) (n : Nat)
    (late : x - H ≤ n) : ((Law.run (step A H) (x, r)).state n).1 ≤ H := by
  have left : (Law.orbit (step A H) (x, r) n).1 - H = 0 :=
    Nat.eq_zero_of_le_zero (Nat.le_trans (left_bound short stays ypos below rshort n).2.2
      (Nat.le_of_eq (sub_eq_zero_of_le late)))
  show (Law.orbit (step A H) (x, r) n).1 ≤ H
  exact (Nat.lt_or_ge (Law.orbit (step A H) (x, r) n).1 H).elim Nat.le_of_lt
    (fun ge => Nat.le_of_eq ((Naturals.sub_add_cancel ge).symm.trans
      ((congrArg (· + H) left).trans (Nat.zero_add H))))

/-! ### At or above the point of no return -/

/-- At or above the point of no return, with giving meeting the draw up to `hi` and the recent
giving meeting the draw, the step does not lower the level and keeps the recent giving at or above
the draw. -/
theorem step_holds {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat}
    (meets : Meets g H y hi) (stays : StaysMet A g H) (low : H + y ≤ x) (high : x ≤ hi)
    (met : H ≤ r) : x ≤ (step A H (x, r)).1 ∧ H ≤ (step A H (x, r)).2 := by
  have ge : H ≤ x := Nat.le_trans (Nat.le_add_right H y) low
  have back : x - H + H = x := Naturals.sub_add_cancel ge
  have ylow : y ≤ x - H := Naturals.le_sub_of_add_le low
  have top : x - H + H ≤ hi := by rw [back]; exact high
  have gives : H ≤ A (x - H) r := stays _ _ met (meets _ ylow top)
  show x ≤ x - H + A (x - H) r ∧ H ≤ A (x - H) r
  exact ⟨Nat.le_trans (Nat.le_of_eq back.symm) (Nat.add_le_add_left gives _), gives⟩

/-- **At or above the point of no return, with the recent giving meeting the draw, the condition
holds**: from a level between `H + y` and `hi`, the run never falls below the level it started
from and never exceeds `hi`, at every adjustment keeping giving at the draw where the recent and
the regime's giving are and keeping the band. -/
theorem holds {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat} (meets : Meets g H y hi)
    (stays : StaysMet A g H) (keeps : Keeps A H hi) (low : H + y ≤ x) (high : x ≤ hi)
    (met : H ≤ r) :
    ∀ n, x ≤ ((Law.run (step A H) (x, r)).state n).1 ∧ ((Law.run (step A H) (x, r)).state n).1 ≤ hi ∧
      H ≤ ((Law.run (step A H) (x, r)).state n).2
  | 0 => ⟨Nat.le_refl x, high, met⟩
  | n + 1 => by
    have ⟨up, top, still⟩ := holds meets stays keeps low high met n
    have next := step_holds (r := (Law.orbit (step A H) (x, r) n).2) meets stays
      (Nat.le_trans low up) top still
    show x ≤ (step A H (Law.orbit (step A H) (x, r) n)).1 ∧
      (step A H (Law.orbit (step A H) (x, r) n)).1 ≤ hi ∧ H ≤ (step A H (Law.orbit (step A H) (x, r) n)).2
    exact ⟨Nat.le_trans up next.1, keeps _ _ top still, next.2⟩

/-- Where giving meets the draw at every level from `y`, the condition holds from every level at
or above `H + y` with the recent giving meeting the draw, with no top. -/
theorem holds_from {A : Nat → Nat → Nat} {g : Nat → Nat} {H y x r : Nat}
    (meets : ∀ z, y ≤ z → H ≤ g z) (stays : StaysMet A g H) (low : H + y ≤ x) (met : H ≤ r) :
    ∀ n, x ≤ ((Law.run (step A H) (x, r)).state n).1 ∧ H ≤ ((Law.run (step A H) (x, r)).state n).2
  | 0 => ⟨Nat.le_refl x, met⟩
  | n + 1 => by
    have ⟨up, still⟩ := holds_from meets stays low met n
    have next := step_holds (hi := (Law.orbit (step A H) (x, r) n).1)
      (r := (Law.orbit (step A H) (x, r) n).2) (fun z ylow _ => meets z ylow) stays
      (Nat.le_trans low up) (Nat.le_refl _) still
    exact ⟨Nat.le_trans up next.1, next.2⟩

/-- **The point of no return is exact on the state.** From a level up to `hi` whose recent giving
falls short of the draw exactly where the level is below `H + y`, the condition ends exactly where
the level starts below `H + y`, at every adjustment keeping giving on the side of the draw where the
recent and the regime's giving are, giving nothing from nothing and keeping the band. -/
theorem ends_iff_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat} (pos : 0 < H + y)
    (short : Short g H y) (staysShort : StaysShort A g H) (nothing : FromNothing A)
    (meets : Meets g H y hi) (staysMet : StaysMet A g H) (keeps : Keeps A H hi) (high : x ≤ hi)
    (side : r < H ↔ x < H + y) :
    (∃ n, ((Law.run (step A H) (x, r)).state n).1 = 0) ↔ x < H + y :=
  ⟨fun ⟨n, zero⟩ => (Nat.lt_or_ge x (H + y)).elim id (fun ge => by
      have met : H ≤ r := (Nat.lt_or_ge r H).elim
        (fun lt => absurd (Nat.lt_of_lt_of_le (side.1 lt) ge) (Nat.lt_irrefl x)) id
      have at_least : H + y ≤ ((Law.run (step A H) (x, r)).state n).1 :=
        Nat.le_trans ge (holds meets staysMet keeps ge high met n).1
      rw [zero] at at_least
      exact absurd (Nat.lt_of_lt_of_le pos at_least) (Nat.lt_irrefl 0)),
   fun below => ⟨x, ends_below short staysShort nothing below (side.2 below)⟩⟩

/-- **For every giving between the recent and the regime's, the point of no return is exact on the
state**: from a level up to `hi` whose recent giving falls short of the draw exactly where the level
is below `H + y`, the condition ends exactly where the level starts below `H + y`, where nothing is
given from nothing and the step keeps the band. -/
theorem Between.ends_iff_below {A : Nat → Nat → Nat} {g : Nat → Nat} {H y hi x r : Nat}
    (between : Between A g) (pos : 0 < H + y) (short : Short g H y) (nothing : FromNothing A)
    (meets : Meets g H y hi) (keeps : Keeps A H hi) (high : x ≤ hi) (side : r < H ↔ x < H + y) :
    (∃ n, ((Law.run (step A H) (x, r)).state n).1 = 0) ↔ x < H + y :=
  Adjusted.ends_iff_below pos short (between.staysShort H) nothing meets (between.staysMet H) keeps high side

end Adjusted

/-! ## Below the point of no return -/

/-- **Below the point of no return the condition is gone**, after as many steps as it stood. -/
theorem ends_below {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) : (Law.run (step g H) x).state x = 0 :=
  (Adjusted.orbit_regime g H (x, 0) x).symm.trans
    (Adjusted.ends_below short (Adjusted.regime_staysShort g H) (Adjusted.regime_fromNothing nothing)
      below (Adjusted.draw_pos short below))

/-- Once gone below the point of no return, the condition stays gone. -/
theorem stays_ended {g : Nat → Nat} {H y x : Nat} (short : Short g H y)
    (nothing : FromNothing g) (below : x < H + y) (k : Nat) :
    (Law.run (step g H) x).state (x + k) = 0 :=
  (Adjusted.orbit_regime g H (x, 0) (x + k)).symm.trans
    (Adjusted.stays_ended short (Adjusted.regime_staysShort g H) (Adjusted.regime_fromNothing nothing)
      below (Adjusted.draw_pos short below) k)

/-- A draw beyond all giving ends the condition from every level, within as many steps as it
stood. -/
theorem ends_beyond_giving {g : Nat → Nat} {H : Nat} (beyond : ∀ z, g z < H)
    (nothing : FromNothing g) (x : Nat) : (Law.run (step g H) x).state x = 0 :=
  ends_below (y := x + 1) (fun z _ => beyond z) nothing
    (Nat.lt_of_lt_of_le (Nat.lt_succ_self x) (Nat.le_add_left (x + 1) H))

/-! ## At or above the point of no return -/

/-- **At or above the point of no return the condition holds**: from a level between `H + y` and
`hi`, the run never falls below the level it started from and never exceeds `hi`. -/
theorem holds {g : Nat → Nat} {H y hi x : Nat} (meets : Meets g H y hi) (keeps : Keeps g H hi)
    (low : H + y ≤ x) (high : x ≤ hi) :
    ∀ n, x ≤ (Law.run (step g H) x).state n ∧ (Law.run (step g H) x).state n ≤ hi :=
  fun n =>
    have h := Adjusted.holds (r := H) meets (Adjusted.regime_staysMet g H) (Adjusted.regime_keeps keeps)
      low high (Nat.le_refl H) n
    ⟨Nat.le_trans h.1 (Nat.le_of_eq (Adjusted.orbit_regime g H (x, H) n)),
     Nat.le_trans (Nat.le_of_eq (Adjusted.orbit_regime g H (x, H) n).symm) h.2.1⟩

/-- **The point of no return is exact.** From a level up to `hi`, the condition ends exactly where
the level starts below `H + y`. -/
theorem ends_iff_below {g : Nat → Nat} {H y hi x : Nat} (pos : 0 < H + y) (short : Short g H y)
    (nothing : FromNothing g) (meets : Meets g H y hi) (keeps : Keeps g H hi) (high : x ≤ hi) :
    (∃ n, (Law.run (step g H) x).state n = 0) ↔ x < H + y :=
  have transfer : ∀ r, (∃ n, ((Law.run (Adjusted.step (fun e _ => g e) H) (x, r)).state n).1 = 0) ↔
      ∃ n, (Law.run (step g H) x).state n = 0 := fun r =>
    ⟨fun ⟨n, zero⟩ => ⟨n, (Adjusted.orbit_regime g H (x, r) n).symm.trans zero⟩,
     fun ⟨n, zero⟩ => ⟨n, (Adjusted.orbit_regime g H (x, r) n).trans zero⟩⟩
  (Nat.lt_or_ge x (H + y)).elim
    (fun below => (transfer 0).symm.trans
      (Adjusted.ends_iff_below pos short (Adjusted.regime_staysShort g H)
        (Adjusted.regime_fromNothing nothing) meets (Adjusted.regime_staysMet g H)
        (Adjusted.regime_keeps keeps) high ⟨fun _ => below, fun _ => Adjusted.draw_pos short below⟩))
    (fun ge => (transfer H).symm.trans
      (Adjusted.ends_iff_below pos short (Adjusted.regime_staysShort g H)
        (Adjusted.regime_fromNothing nothing) meets (Adjusted.regime_staysMet g H)
        (Adjusted.regime_keeps keeps) high
        ⟨fun lt => absurd lt (Nat.lt_irrefl H),
         fun lt => absurd (Nat.lt_of_lt_of_le lt ge) (Nat.lt_irrefl x)⟩))

/-! ## The need is the regime's -/

/-- Where giving stops below the need, every level at which giving meets a positive draw lies at or
above the need. -/
theorem root_above_need {g : Nat → Nat} {m H y : Nat} (gated : Gated g m) (pos : 0 < H)
    (meets : H ≤ g y) : m ≤ y :=
  (Nat.lt_or_ge y m).elim
    (fun lt => absurd (Nat.lt_of_lt_of_le pos (Nat.le_trans meets (Nat.le_of_eq (gated y lt))))
      (Nat.lt_irrefl 0))
    id

/-- **The point of no return lies more than the draw above the need exactly where giving at the
need falls short of the draw.** -/
theorem beyond_draw_iff {g : Nat → Nat} {m H y : Nat} (gated : Gated g m) (pos : 0 < H)
    (root : Root g H y) : m < y ↔ g m < H :=
  ⟨fun lt => root.2 m lt,
   fun short_at => Nat.lt_of_le_of_ne (root_above_need gated pos root.1)
     (fun same => Nat.lt_irrefl H (Nat.lt_of_le_of_lt (same ▸ root.1) short_at))⟩

/-- Giving under one regime is nowhere greater than under another. -/
def Lowered (g' g : Nat → Nat) : Prop := ∀ z, g' z ≤ g z

/-- The least level meeting a draw does not fall as the draw grows and giving does not rise. -/
theorem root_mono {g g' : Nat → Nat} {H H' y y' : Nat} (root : Root g H y) (root' : Root g' H' y')
    (le : H ≤ H') (lowered : Lowered g' g) : y ≤ y' :=
  (Nat.lt_or_ge y' y).elim
    (fun lt => absurd (Nat.lt_of_lt_of_le
        (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (lowered y') (root.2 y' lt)) le) root'.1)
      (Nat.lt_irrefl _))
    id

/-- **A larger draw, giving no more, has a point of no return higher by at least the difference of
the draws.** -/
theorem rises_by_draw {g g' : Nat → Nat} {H H' y y' : Nat} (root : Root g H y)
    (root' : Root g' H' y') (le : H ≤ H') (lowered : Lowered g' g) : H + y + (H' - H) ≤ H' + y' :=
  calc H + y + (H' - H) = y + (H + (H' - H)) := by rw [Nat.add_comm H y, Nat.add_assoc]
    _ = y + H' := by rw [add_sub_of_le le]
    _ = H' + y := Nat.add_comm y H'
    _ ≤ H' + y' := Nat.add_le_add_left (root_mono root root' le lowered) H'

/-- **Giving lowered by the regime raises the need**: under the same draw, the least level meeting
it under lowered giving is no lower. -/
theorem lowered_raises {g g' : Nat → Nat} {H y y' : Nat} (root : Root g H y) (root' : Root g' H y')
    (lowered : Lowered g' g) : y ≤ y' :=
  root_mono root root' (Nat.le_refl H) lowered

/-- The need is raised strictly exactly where the lowered giving falls short of the draw at the old
least level. -/
theorem lowered_raises_strictly {g g' : Nat → Nat} {H y y' : Nat} (root : Root g H y)
    (root' : Root g' H y') (lowered : Lowered g' g) : y < y' ↔ g' y < H :=
  ⟨fun lt => root'.2 y lt,
   fun short_at => Nat.lt_of_le_of_ne (lowered_raises root root' lowered)
     (fun same => Nat.lt_irrefl H (Nat.lt_of_le_of_lt (same ▸ root'.1) short_at))⟩

/-! ## Draws add; harms do not -/

/-- **Harms are super-additive up to one unit.** Under the draws `H₁`, `H₂` and `H₁ + H₂` the
condition gives by `g₁`, `g₂` and `g`, with `g` subadditive above the need `m` and no greater than
`g₁` or `g₂`. Where the least levels meeting the three draws lie `a`, `b` and `c` above the need,
`a + b ≤ c + 1`: the point of no return under the joint draw rises above the need by at least the
sum of the rises under each, `(H₁ + a) + (H₂ + b)`, less one. With one giving law for all three,
`g₁ = g₂ = g`. -/
theorem harms_superadditive {g₁ g₂ g : Nat → Nat} {m H₁ H₂ a b c : Nat}
    (sub : SubadditiveAbove g m) (low₁ : Lowered g g₁) (low₂ : Lowered g g₂)
    (r₁ : Root g₁ H₁ (m + a)) (r₂ : Root g₂ H₂ (m + b))
    (r : Root g (H₁ + H₂) (m + c)) : a + b ≤ c + 1 := by
  cases a with
  | zero =>
    have hb : b ≤ c :=
      Naturals.le_of_add_le_add_left (root_mono r₂ r (Nat.le_add_left H₂ H₁) low₂)
    rw [Nat.zero_add]
    exact Nat.le_trans hb (Nat.le_succ c)
  | succ a' =>
    cases b with
    | zero =>
      exact Nat.le_trans
        (Naturals.le_of_add_le_add_left (root_mono r₁ r (Nat.le_add_right H₁ H₂) low₁))
        (Nat.le_succ c)
    | succ b' =>
      refine (Nat.lt_or_ge (c + 1) (a' + 1 + (b' + 1))).elim (fun lt => ?_) id
      exfalso
      have h1 : c + 1 ≤ a' + 1 + b' := Nat.le_of_succ_le_succ lt
      have h2 : c + 1 ≤ a' + b' + 1 := by rw [← Nat.add_right_comm a' 1 b']; exact h1
      have cle : c ≤ a' + b' := Nat.le_of_succ_le_succ h2
      refine (Nat.lt_or_ge a' c).elim (fun ac => ?_) (fun ca => ?_)
      · obtain ⟨d, hd⟩ := le_dest (Nat.le_of_lt ac)
        have dle : d ≤ b' := by
          apply Naturals.le_of_add_le_add_left (k := a')
          rw [← hd]; exact cle
        have g1 : g₁ (m + a') < H₁ := r₁.2 _ (Nat.add_lt_add_left (Nat.lt_succ_self a') m)
        have g2 : g₂ (m + d) < H₂ := r₂.2 _ (Nat.add_lt_add_left (Nat.lt_succ_of_le dle) m)
        have gc : g (m + c) ≤ g₁ (m + a') + g₂ (m + d) := by
          rw [hd]; exact Nat.le_trans (sub a' d) (Nat.add_le_add (low₁ _) (low₂ _))
        exact Nat.lt_irrefl _
          (Nat.lt_of_le_of_lt r.1 (Nat.lt_of_le_of_lt gc (Nat.add_lt_add g1 g2)))
      · have g1 : g₁ (m + c) < H₁ := r₁.2 _ (Nat.add_lt_add_left (Nat.lt_succ_of_le ca) m)
        exact Nat.lt_irrefl _ (Nat.lt_of_le_of_lt r.1
          (Nat.lt_of_le_of_lt (low₁ _) (Nat.lt_of_lt_of_le g1 (Nat.le_add_right H₁ H₂))))

/-! ## The time to break -/

/-- The run falls by at most the draw at each step: after `n` steps, the level with `H n` added
back is at least where it started. -/
theorem orbit_ge (g : Nat → Nat) (H x : Nat) : ∀ n, x ≤ (Law.run (step g H) x).state n + H * n
  | 0 => Nat.le_refl x
  | n + 1 => by
    show x ≤ step g H (Law.orbit (step g H) x n) + (H * n + H)
    have ih := orbit_ge g H x n
    calc x ≤ Law.orbit (step g H) x n + H * n := ih
      _ ≤ step g H (Law.orbit (step g H) x n) + H + H * n :=
          Nat.add_le_add_right (step_ge g H _) _
      _ = step g H (Law.orbit (step g H) x n) + (H * n + H) := by
          rw [Nat.add_assoc, Nat.add_comm H (H * n)]

/-- **Not before**: the level stays at or above `b` at every step `n` with `b + H n ≤ x`. -/
theorem not_before (g : Nat → Nat) {H x b n : Nat} (early : b + H * n ≤ x) :
    b ≤ (Law.run (step g H) x).state n :=
  le_of_add_le_add_right (H * n) (Nat.le_trans early (orbit_ge g H x n))

/-- Where giving is at most `Y ≤ H`, a level at or above the draw falls by at least `H - Y`. -/
theorem step_falls_by {g : Nat → Nat} {H Y x : Nat} (most : AtMost g Y) (yle : Y ≤ H)
    (ge : H ≤ x) : step g H x + (H - Y) ≤ x :=
  calc step g H x + (H - Y) ≤ x - H + Y + (H - Y) :=
        Nat.add_le_add_right (Nat.add_le_add_left (most _) _) _
    _ = x - H + (Y + (H - Y)) := Nat.add_assoc _ _ _
    _ = x - H + H := by rw [add_sub_of_le yle]
    _ = x := Naturals.sub_add_cancel ge

/-- Either the level has fallen below `b` by step `n`, or it has stayed at or above `b` and fallen
by at least `(H - Y) n`. -/
theorem falls_or_bound {g : Nat → Nat} {H Y b x : Nat} (most : AtMost g Y) (yle : Y ≤ H)
    (hb : H ≤ b) : ∀ n, (∃ k, k ≤ n ∧ (Law.run (step g H) x).state k < b) ∨
      ((Law.run (step g H) x).state n + (H - Y) * n ≤ x ∧ b ≤ (Law.run (step g H) x).state n)
  | 0 => (Nat.lt_or_ge x b).elim (fun lt => .inl ⟨0, Nat.le_refl 0, lt⟩)
      (fun ge => .inr ⟨Nat.le_refl x, ge⟩)
  | n + 1 => (falls_or_bound most yle hb n).elim
      (fun ⟨k, kle, lt⟩ => .inl ⟨k, Nat.le_succ_of_le kle, lt⟩)
      (fun ⟨bound, above⟩ => by
        have falls := step_falls_by most yle (Nat.le_trans hb above)
        refine (Nat.lt_or_ge (step g H (Law.orbit (step g H) x n)) b).elim
          (fun lt => .inl ⟨n + 1, Nat.le_refl _, lt⟩) (fun ge => .inr ⟨?_, ge⟩)
        show step g H (Law.orbit (step g H) x n) + ((H - Y) * n + (H - Y)) ≤ x
        calc step g H (Law.orbit (step g H) x n) + ((H - Y) * n + (H - Y))
            = step g H (Law.orbit (step g H) x n) + (H - Y) + (H - Y) * n := by
              rw [Nat.add_comm ((H - Y) * n) (H - Y), Nat.add_assoc]
          _ ≤ Law.orbit (step g H) x n + (H - Y) * n := Nat.add_le_add_right falls _
          _ ≤ x := bound)

/-- **Falls within**: where giving is at most `Y ≤ H ≤ b`, the level falls below `b` within any
`n` steps with `x < b + (H - Y) n`. -/
theorem falls_within {g : Nat → Nat} {H Y b x n : Nat} (most : AtMost g Y) (yle : Y ≤ H)
    (hb : H ≤ b) (late : x < b + (H - Y) * n) :
    ∃ k, k ≤ n ∧ (Law.run (step g H) x).state k < b :=
  (falls_or_bound most yle hb n).elim id (fun ⟨bound, above⟩ =>
    absurd (Nat.lt_of_le_of_lt (Nat.le_trans (Nat.add_le_add_right above _) bound) late)
      (Nat.lt_irrefl _))

/-! ## Witnesses -/

/-- The levels below `n` all pass the check `f`. -/
def below (f : Nat → Bool) : Nat → Bool
  | 0 => true
  | n + 1 => f n && below f n

theorem below_spec {f : Nat → Bool} : ∀ {n}, below f n = true → ∀ z, z < n → f z = true
  | 0, _, _, lt => absurd lt (Nat.not_lt_zero _)
  | n + 1, h, z, lt => (Nat.lt_or_ge z n).elim
      (fun zn => below_spec (ListTests.and_right h) z zn)
      (fun nz => (Nat.le_antisymm (Nat.le_of_lt_succ lt) nz) ▸ ListTests.and_left h)

theorem short_of_below {g : Nat → Nat} {H y : Nat}
    (check : below (fun z => decide (g z < H)) y = true) : Short g H y :=
  fun z lt => of_decide_eq_true (below_spec check z lt)

theorem meets_of_below {g : Nat → Nat} {H y hi : Nat}
    (check : below (fun z => !(decide (y ≤ z) && decide (z + H ≤ hi)) || decide (H ≤ g z))
      (hi + 1) = true) : Meets g H y hi := fun z yz top => by
  have pass := below_spec check z (Nat.lt_succ_of_le (Nat.le_trans (Nat.le_add_right z H) top))
  rw [decide_eq_true yz, decide_eq_true top] at pass
  exact of_decide_eq_true pass

theorem keeps_of_below {g : Nat → Nat} {H hi : Nat}
    (check : below (fun x => decide (step g H x ≤ hi)) (hi + 1) = true) : Keeps g H hi :=
  fun x le => of_decide_eq_true (below_spec check x (Nat.lt_succ_of_le le))

namespace Concave

/-- Giving that doubles the level up to two and then adds two: its increments are `2, 2, 1, 1, …`. -/
def giving (z : Nat) : Nat := min (2 * z) (z + 2)

/-- The least level meeting the draw `4` is `2`, and the least meeting the draw `8` is `6`: the
point of no return rises from the need `0` by `4 + 2` under either draw of `4` alone, and by
`8 + 6`, more than the sum `12`, under the two together. -/
theorem roots : Root giving 4 2 ∧ Root giving 8 6 :=
  ⟨⟨by decide, short_of_below rfl⟩, ⟨by decide, short_of_below rfl⟩⟩

end Concave

namespace Peaked

/-- Giving that rises with the level to a peak of `4` at level `4` and falls to nothing at `8`. -/
def giving (z : Nat) : Nat := min z (8 - z)

theorem fromNothing : FromNothing giving := rfl

/-- As `Nat.min_le_left`, with an empty axiom report. -/
theorem min_le_left' (a b : Nat) : min a b ≤ a := by
  show (if a ≤ b then a else b) ≤ a
  cases Nat.decLe a b with
  | isTrue _ => exact Nat.le_refl a
  | isFalse h => exact Nat.le_of_lt (Nat.gt_of_not_le h)

/-- As `Nat.min_le_right`, with an empty axiom report. -/
theorem min_le_right' (a b : Nat) : min a b ≤ b := by
  show (if a ≤ b then a else b) ≤ b
  cases Nat.decLe a b with
  | isTrue h => exact h
  | isFalse _ => exact Nat.le_refl b

/-- Giving never exceeds `4`. -/
theorem atMost : AtMost giving 4 := fun z =>
  (Nat.lt_or_ge z 5).elim
    (fun lt => Nat.le_trans (min_le_left' _ _) (Nat.le_of_lt_succ lt))
    (fun ge => by
      obtain ⟨k, hk⟩ := le_dest ge
      have fall : 8 - z ≤ 3 := by
        rw [hk, ← Naturals.sub_sub 8 5 k]; exact Nat.sub_le 3 k
      exact Nat.le_trans (min_le_right' _ _) (Nat.le_trans fall (Nat.le_succ 3)))

/-- **Each draw holds alone**: under a standing draw of `3`, every level from `6` to `8` holds. -/
theorem each_holds {x : Nat} (low : 6 ≤ x) (high : x ≤ 8) (n : Nat) :
    x ≤ (Law.run (step giving 3) x).state n :=
  (holds (y := 3) (meets_of_below rfl) (keeps_of_below rfl) low high n).1

/-- **Together they end it**: under the two draws together, `6`, beyond all giving, the condition
ends from every level. -/
theorem together_ends (x : Nat) : (Law.run (step giving (3 + 3)) x).state x = 0 :=
  ends_beyond_giving (fun z => Nat.lt_of_le_of_lt (atMost z) (by decide)) fromNothing x

end Peaked

namespace Crossing

/-- Giving gated at two: nothing below two, four from two on. Under a draw of three the least level
meeting the draw is two, so the point of no return is five. -/
def giving (z : Nat) : Nat := if z < 2 then 0 else 4

/-- Giving that moves one unit a step toward the regime's, and rests there. -/
def toward (e r : Nat) : Nat :=
  if r < giving e then r + 1 else if giving e < r then r - 1 else r

theorem fromNothing : FromNothing giving := rfl

theorem root : Root giving 3 2 :=
  ⟨Nat.le_succ 3, fun _ lt => Nat.lt_of_le_of_lt (Nat.le_of_eq (if_pos lt)) (Nat.zero_lt_succ 2)⟩

theorem meets_from : ∀ z, 2 ≤ z → 3 ≤ giving z :=
  fun z le => Nat.le_trans (Nat.le_succ 3)
    (Nat.le_of_eq (if_neg (fun lt : z < 2 => Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt le lt))).symm)

/-- Moving one unit toward the regime's giving lies between the recent giving and the regime's. -/
theorem toward_between : Adjusted.Between toward giving :=
  fun e r => (Nat.lt_or_ge r (giving e)).elim
    (fun lt => have up : toward e r = r + 1 := if_pos lt
      Or.inl ⟨Nat.le_trans (Nat.le_succ r) (Nat.le_of_eq up.symm),
        Nat.le_trans (Nat.le_of_eq up) lt⟩)
    (fun ge => (Nat.lt_or_ge (giving e) r).elim
      (fun lt =>
        have down : toward e r = r - 1 :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_pos lt)
        have one : 1 + giving e ≤ r := Nat.le_trans (Nat.le_of_eq (Nat.add_comm 1 (giving e))) lt
        Or.inr ⟨Nat.le_trans (Naturals.le_sub_of_add_le one) (Nat.le_of_eq down.symm),
          Nat.le_trans (Nat.le_of_eq down) (Nat.sub_le r 1)⟩)
      (fun le =>
        have same : toward e r = r :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_neg (fun l : giving e < r => Nat.lt_irrefl r (Nat.lt_of_le_of_lt le l)))
        Or.inl ⟨Nat.le_of_eq same.symm, Nat.le_trans (Nat.le_of_eq same) le⟩))

/-- Moving one unit toward the regime's giving rests only there: a positive rate. -/
theorem toward_settles : Adjusted.Settles toward giving :=
  fun e r rest => (Nat.lt_or_ge r (giving e)).elim
    (fun lt => absurd ((if_pos lt : toward e r = r + 1).symm.trans rest) (Naturals.succ_ne_self r))
    (fun ge => (Nat.lt_or_ge (giving e) r).elim
      (fun lt => by
        have down : toward e r = r - 1 :=
          (if_neg (fun l : r < giving e => Nat.lt_irrefl r (Nat.lt_of_lt_of_le l ge))).trans
            (if_pos lt)
        have pos : 1 ≤ r := Nat.lt_of_le_of_lt (Nat.zero_le _) lt
        have back : r - 1 + 1 = r := Naturals.sub_add_cancel pos
        have same : r - 1 = r := down.symm.trans rest
        exact absurd (back.symm.trans (congrArg (· + 1) same)) (Naturals.succ_ne_self r).symm)
      (fun le => Nat.le_antisymm le ge))

/-- **Recent giving on the other side of the draw crosses the point of no return, both ways.**
Under the gated giving and a draw of three the point of no return is five. The regime's step ends
the condition from four and holds it from five. Giving moving one unit a step toward the regime's
(between the recent giving and the regime's, and resting only there) holds it at or above seven
from the second step on where it starts at four with a recent giving of six, above the draw, and
has it at nothing from the second step on where it starts at five with a recent giving of
nothing. -/
theorem crosses :
    Root giving 3 2 ∧ Adjusted.Between toward giving ∧ Adjusted.Settles toward giving ∧
    (Law.run (step giving 3) 4).state 4 = 0 ∧ (∀ n, 5 ≤ (Law.run (step giving 3) 5).state n) ∧
    (∀ n, 7 ≤ ((Law.run (Adjusted.step toward 3) (4, 6)).state (n + 2)).1) ∧
    (∀ n, ((Law.run (Adjusted.step toward 3) (5, 0)).state (n + 2)).1 = 0) := by
  refine ⟨root, toward_between, toward_settles,
    ends_below root.2 fromNothing (Nat.lt_succ_self 4), fun n => ?_, fun n => ?_, fun n => ?_⟩
  · exact Nat.le_trans (Adjusted.holds_from (A := fun e _ => giving e) (r := 3) meets_from
      (Adjusted.regime_staysMet giving 3) (Nat.le_refl 5) (Nat.le_refl 3) n).1
      (Nat.le_of_eq (Adjusted.orbit_regime giving 3 (5, 3) n))
  · have two : Law.orbit (Adjusted.step toward 3) (4, 6) 2 = (7, 4) := rfl
    show 7 ≤ (Law.orbit (Adjusted.step toward 3) (4, 6) (n + 2)).1
    rw [Nat.add_comm n 2, Law.orbit_add, two]
    exact (Adjusted.holds_from (x := 7) (r := 4) meets_from (toward_between.staysMet 3)
      (Nat.le_succ_of_le (Nat.le_succ 5)) (Nat.le_succ 3) n).1
  · have two : Law.orbit (Adjusted.step toward 3) (5, 0) 2 = (0, 0) := rfl
    show (Law.orbit (Adjusted.step toward 3) (5, 0) (n + 2)).1 = 0
    rw [Nat.add_comm n 2, Law.orbit_add, two, ← Nat.one_mul n,
      Law.orbit_mul (next := Adjusted.step toward 3) (s := (0, 0)) (p := 1) rfl n]

/-- **Moving wherever it differs from the regime's cannot be dropped.** The frozen rest lies between
the recent giving and the regime's, yet from four with a recent giving at the draw of three its run
stays at four at every step, where the regime's step ends the condition from four. -/
theorem frozen_stays :
    Adjusted.Between (fun _ r => r) giving ∧
    (∀ n, (Law.run (Adjusted.step (fun _ r => r) 3) (4, 3)).state n = (4, 3)) ∧
    (Law.run (step giving 3) 4).state 4 = 0 :=
  ⟨Adjusted.frozen_between giving,
   fun n => (congrArg (Law.orbit (Adjusted.step (fun _ r => r) 3) (4, 3)) (Nat.one_mul n)).symm.trans
     (Law.orbit_mul (next := Adjusted.step (fun _ r => r) 3) (s := (4, 3)) (p := 1)
       (Adjusted.frozen_rests (Nat.le_succ 3)) n),
   ends_below root.2 fromNothing (Nat.lt_succ_self 4)⟩

end Crossing

/-! ## Where a run comes to rest

`Adjusted.rests_iff` says where a run of an adjusting giving can rest, not that it comes to rest; in
general, settling needs the limited principle of omniscience (`LastChange.lpo_iff_settles`). A run of
a law with a quantity that never falls along it, rises at every change and is bounded comes to rest
within the bound, decided at each step (`LastChange.still_within`). Where giving rises with what is
left, the regime's step moves a level one way only (`Lasting.orbit_mono`), so its level, or its
distance below the start, is such a quantity, and within a band the run comes to rest. Where the
adjustment rises with what is left and with the recent giving, a step that neither raises nor lowers
both the level and the recent giving moves the recent giving strictly toward the draw, so such steps
run out, and from the first step that raises or lowers both, the run moves one way only: every run
within a band comes to rest, at the regime's point or at a rest below the draw. -/

/-- The regime's step does not lower a higher level below a lower one's, where giving rises with
what is left. -/
theorem step_mono {g : Nat → Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b) (H : Nat) {a b : Nat}
    (le : a ≤ b) : step g H a ≤ step g H b :=
  Nat.add_le_add (Nat.sub_le_sub_right le H) (grows _ _ (Nat.sub_le_sub_right le H))

/-- **Every run of the regime's step comes to rest.** Where giving rises with what is left and the
step keeps every level up to `hi` within it, the run from a level up to `hi` is still from some step
at most `hi`, at a level the regime's step leaves as it is: within `hi - x` steps where its first
step raises the level, within `x` where it lowers it. -/
theorem rests_within {g : Nat → Nat} {H hi x : Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b)
    (keeps : Keeps g H hi) (high : x ≤ hi) :
    ∃ N, N ≤ hi ∧ LastChange.StillFrom (Law.run (step g H) x) N :=
  have mono : ∀ a b, a ≤ b → step g H a ≤ step g H b := fun _ _ le => step_mono grows H le
  (Nat.le_total x (step g H x)).elim
    (fun first =>
      have up : ∀ n, Law.orbit (step g H) x n ≤ Law.orbit (step g H) x (n + 1) := fun n =>
        Eq.subst (motive := fun v => Law.orbit (step g H) x n ≤ v)
          (Law.orbit_shift (step g H) x n).symm
          (Lasting.orbit_mono (rel := fun a b => a ≤ b) mono first n)
      have top : ∀ n, Law.orbit (step g H) x n ≤ hi := fun n => by
        induction n with
        | zero => exact high
        | succ n ih => exact keeps _ ih
      have ⟨N, le, still⟩ := LastChange.still_within (q := fun v => v) (B := hi) (hi - x) x
        (Nat.le_of_eq (Naturals.sub_add_cancel high).symm) (fun n => ⟨up n, fun apart => Nat.lt_of_le_of_ne (up n) fun same =>
          apart same.symm⟩) top
      ⟨N, Nat.le_trans le (Nat.sub_le hi x), still⟩)
    (fun first =>
      have down : ∀ n, Law.orbit (step g H) x (n + 1) ≤ Law.orbit (step g H) x n := fun n =>
        Eq.subst (motive := fun v => v ≤ Law.orbit (step g H) x n)
          (Law.orbit_shift (step g H) x n).symm
          (Lasting.orbit_mono (rel := fun a b => a ≤ b) mono first n)
      have below : ∀ n, Law.orbit (step g H) x n ≤ x := fun n => by
        induction n with
        | zero => exact Nat.le_refl x
        | succ n ih => exact Nat.le_trans (down n) ih
      have ⟨N, le, still⟩ := LastChange.still_within (q := fun v => x - v) (B := x) x x
        (Nat.le_add_right x _) (fun n => ⟨Optimum.sub_le_sub_left_of_le (down n) x, fun apart =>
          Requirement.Formation.sub_lt_sub_of_lt (Nat.lt_of_le_of_ne (down n) apart) (below n)⟩) (fun n => Nat.sub_le x _)
      ⟨N, Nat.le_trans le high, still⟩)

namespace Adjusted

/-- The adjusted giving rises with what is left and with the recent giving. -/
def Rises (A : Nat → Nat → Nat) : Prop := ∀ e e' r r', e ≤ e' → r ≤ r' → A e r ≤ A e' r'

/-- One state at or below another, in level and in recent giving. -/
def Below (p q : Nat × Nat) : Prop := p.1 ≤ q.1 ∧ p.2 ≤ q.2

/-- The adjusted step keeps every state whose level and recent giving are at most `hi` at a level at
most `hi`. -/
def Band (A : Nat → Nat → Nat) (H hi : Nat) : Prop :=
  ∀ x r, x ≤ hi → r ≤ hi → (step A H (x, r)).1 ≤ hi

/-- A state the adjusted step leaves as it is: at or above the draw, with the recent giving at the
draw and a level the regime's step leaves as it is; or below the draw, with the level and the recent
giving equal and the adjusted giving from nothing left giving it again. -/
def AtRest (A : Nat → Nat → Nat) (g : Nat → Nat) (H : Nat) (p : Nat × Nat) : Prop :=
  (p.2 = H ∧ H ≤ p.1 ∧ RegimeMargin.step g H p.1 = p.1) ∨ (p.1 < H ∧ p.1 = p.2 ∧ A 0 p.2 = p.2)

/-- A bound on how many more steps can leave the level and the recent giving neither both risen nor
both fallen: at or above the draw, two more than the recent giving's distance from the draw; below
it, one off the line where the level and the recent giving are equal, and none on it. -/
def unordered (H : Nat) (p : Nat × Nat) : Nat :=
  if H ≤ p.1 then p.2 - H + (H - p.2) + 2 else if p.1 = p.2 then 0 else 1

/-- The adjusted step keeps the order of states where the adjustment rises. -/
theorem step_mono {A : Nat → Nat → Nat} (rises : Rises A) (H : Nat) {p q : Nat × Nat}
    (below : Below p q) : Below (step A H p) (step A H q) :=
  have left : p.1 - H ≤ q.1 - H := Nat.sub_le_sub_right below.1 H
  have gives : A (p.1 - H) p.2 ≤ A (q.1 - H) q.2 := rises _ _ _ _ left below.2
  ⟨Nat.add_le_add left gives, gives⟩

/-- A state at or below another and apart from it has less level and recent giving together. -/
theorem sum_lt_of_below : ∀ {p q : Nat × Nat}, Below p q → q ≠ p → p.1 + p.2 < q.1 + q.2
  | (a, b), (c, d), below, apart => (Nat.lt_or_ge a c).elim
      (fun lt => Nat.add_lt_add_of_lt_of_le lt below.2)
      (fun ge => (Nat.lt_or_ge b d).elim (fun lt => Nat.add_lt_add_of_le_of_lt below.1 lt)
        (fun ge' => absurd (congr (congrArg Prod.mk (Nat.le_antisymm ge below.1))
          (Nat.le_antisymm ge' below.2)) apart))

/-- After a step the recent giving is at most the level. -/
theorem given_le_level (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) :
    (step A H p).2 ≤ (step A H p).1 :=
  Nat.le_add_left _ _

/-- A run from a state within a band stays within it. -/
theorem in_band {A : Nat → Nat → Nat} {H hi : Nat} (band : Band A H hi) {p : Nat × Nat}
    (high : p.1 ≤ hi) (given : p.2 ≤ hi) :
    ∀ n, (Law.orbit (step A H) p n).1 ≤ hi ∧ (Law.orbit (step A H) p n).2 ≤ hi
  | 0 => ⟨high, given⟩
  | n + 1 =>
    have top : (step A H (Law.orbit (step A H) p n)).1 ≤ hi :=
      band _ _ (in_band band high given n).1 (in_band band high given n).2
    ⟨top, Nat.le_trans (given_le_level A H _) top⟩

/-- A run whose first step lowers neither its level nor its recent giving never lowers either. -/
theorem run_rises {A : Nat → Nat → Nat} (rises : Rises A) {H : Nat} {p : Nat × Nat}
    (first : Below p (step A H p)) :
    ∀ n, Below (Law.orbit (step A H) p n) (Law.orbit (step A H) p (n + 1)) := fun n =>
  Eq.subst (motive := fun v => Below (Law.orbit (step A H) p n) v)
    (Law.orbit_shift (step A H) p n).symm
    (Lasting.orbit_mono (rel := Below) (fun _ _ below => step_mono rises H below) first n)

/-- A run whose first step raises neither its level nor its recent giving never raises either. -/
theorem run_falls {A : Nat → Nat → Nat} (rises : Rises A) {H : Nat} {p : Nat × Nat}
    (first : Below (step A H p) p) :
    ∀ n, Below (Law.orbit (step A H) p (n + 1)) (Law.orbit (step A H) p n) := fun n =>
  Eq.subst (motive := fun v => Below v (Law.orbit (step A H) p n))
    (Law.orbit_shift (step A H) p n).symm
    (Lasting.orbit_mono (rel := Below) (fun _ _ below => step_mono rises H below) first n)

/-- A run within a band whose first step lowers neither its level nor its recent giving is still
from some step at most `2 hi - (x + r)`. -/
theorem rests_rising {A : Nat → Nat → Nat} {H hi : Nat} {p : Nat × Nat} (rises : Rises A)
    (band : Band A H hi) (high : p.1 ≤ hi) (given : p.2 ≤ hi) (first : Below p (step A H p)) :
    ∃ N, N ≤ hi + hi - (p.1 + p.2) ∧ LastChange.StillFrom (Law.run (step A H) p) N :=
  have up := run_rises rises first
  have inside := in_band band high given
  LastChange.still_within (q := fun v : Nat × Nat => v.1 + v.2) (B := hi + hi) (hi + hi - (p.1 + p.2)) p
    (Nat.le_of_eq (Naturals.sub_add_cancel (Nat.add_le_add high given)).symm)
    (fun n => ⟨Nat.add_le_add (up n).1 (up n).2, sum_lt_of_below (up n)⟩)
    (fun n => Nat.add_le_add (inside n).1 (inside n).2)

/-- A run whose first step raises neither its level nor its recent giving is still from some step at
most `x + r`. -/
theorem rests_falling {A : Nat → Nat → Nat} {H : Nat} {p : Nat × Nat} (rises : Rises A)
    (first : Below (step A H p) p) :
    ∃ N, N ≤ p.1 + p.2 ∧ LastChange.StillFrom (Law.run (step A H) p) N := by
  have down := run_falls rises first
  have to_start : ∀ n, Below (Law.orbit (step A H) p n) p := fun n => by
    induction n with
    | zero => exact ⟨Nat.le_refl _, Nat.le_refl _⟩
    | succ n ih => exact ⟨Nat.le_trans (down n).1 ih.1, Nat.le_trans (down n).2 ih.2⟩
  exact LastChange.still_within (q := fun v : Nat × Nat => p.1 + p.2 - (v.1 + v.2)) (B := p.1 + p.2)
    (p.1 + p.2) p (Nat.le_add_right _ _)
    (fun n => ⟨Optimum.sub_le_sub_left_of_le (Nat.add_le_add (down n).1 (down n).2) _,
      fun apart => Requirement.Formation.sub_lt_sub_of_lt
        (sum_lt_of_below (down n) fun same => apart same.symm)
        (Nat.add_le_add (to_start n).1 (to_start n).2)⟩)
    (fun n => Nat.sub_le _ _)

/-- Below the draw, `unordered` is at most one. -/
theorem unordered_below {H : Nat} {p : Nat × Nat} (low : ¬ H ≤ p.1) : unordered H p ≤ 1 := by
  show (if H ≤ p.1 then p.2 - H + (H - p.2) + 2 else if p.1 = p.2 then 0 else 1) ≤ 1
  rw [if_neg low]
  exact if same : p.1 = p.2 then by rw [if_pos same]; exact Nat.zero_le 1
    else by rw [if_neg same]; exact Nat.le_refl 1

/-- `unordered` is at most two more than a bound on the level, where the recent giving is at most
the level. -/
theorem unordered_le {H hi : Nat} {p : Nat × Nat} (le : p.2 ≤ p.1) (high : p.1 ≤ hi) :
    unordered H p ≤ hi + 2 :=
  if at_least : H ≤ p.1 then by
    show (if H ≤ p.1 then p.2 - H + (H - p.2) + 2 else if p.1 = p.2 then 0 else 1) ≤ hi + 2
    rw [if_pos at_least]
    refine Nat.add_le_add_right ?_ 2
    exact (Nat.le_total p.2 H).elim
      (fun short => by
        rw [sub_eq_zero_of_le short, Nat.zero_add]
        exact Nat.le_trans (Nat.sub_le H p.2) (Nat.le_trans at_least high))
      (fun met => by
        rw [sub_eq_zero_of_le met, Nat.add_zero]
        exact Nat.le_trans (Nat.sub_le p.2 H) (Nat.le_trans le high))
  else Nat.le_trans (unordered_below at_least) (Nat.le_add_left 1 (hi + 1))

/-- **A step that neither raises nor lowers both moves toward the draw.** From a state whose recent
giving is at most its level, a step after which the level and the recent giving neither both rise
nor both fall lowers `unordered`: at or above the draw the new recent giving lies strictly between
the old and the draw; below it the new state lies on the line where level and recent giving are
equal. No property of the giving is needed. -/
theorem unordered_falls {H x r a : Nat} (le : r ≤ x) (notUp : ¬ (x ≤ x - H + a ∧ r ≤ a))
    (notDown : ¬ (x - H + a ≤ x ∧ a ≤ r)) : unordered H (x - H + a, a) < unordered H (x, r) := by
  show (if H ≤ x - H + a then a - H + (H - a) + 2 else if x - H + a = a then 0 else 1) <
    (if H ≤ x then r - H + (H - r) + 2 else if x = r then 0 else 1)
  exact if at_least : H ≤ x then by
    have back : x - H + H = x := Naturals.sub_add_cancel at_least
    rw [if_pos at_least]
    exact (Nat.lt_or_ge a H).elim
      (fun short => by
        have lowered : x - H + a ≤ x :=
          Nat.le_trans (Nat.add_le_add_left (Nat.le_of_lt short) _) (Nat.le_of_eq back)
        have rose : r < a := (Nat.lt_or_ge r a).elim id fun ge => absurd ⟨lowered, ge⟩ notDown
        have closer : H - a < H - r :=
          Requirement.Formation.sub_lt_sub_of_lt rose (Nat.le_of_lt short)
        exact if up : H ≤ x - H + a then by
          rw [if_pos up, sub_eq_zero_of_le (Nat.le_of_lt short),
            sub_eq_zero_of_le (Nat.le_of_lt (Nat.lt_trans rose short)), Nat.zero_add, Nat.zero_add]
          exact Nat.add_lt_add_right closer 2
        else Nat.lt_of_le_of_lt (unordered_below (p := (x - H + a, a)) up)
          (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) (Nat.le_add_left 2 _)))
      (fun met => by
        have raised : x ≤ x - H + a :=
          Nat.le_trans (Nat.le_of_eq back.symm) (Nat.add_le_add_left met _)
        have fell : a < r := (Nat.lt_or_ge a r).elim id fun ge => absurd ⟨raised, ge⟩ notUp
        have above : H < a := (Nat.lt_or_ge H a).elim id fun le' =>
          absurd ⟨Nat.le_trans (Nat.add_le_add_left le' _) (Nat.le_of_eq back), Nat.le_of_lt fell⟩
            notDown
        have closer : a - H < r - H := by
          have shifted : a - H + 1 + H ≤ r - H + H := by
            rw [Nat.add_right_comm, Naturals.sub_add_cancel met,
              Naturals.sub_add_cancel (Nat.le_trans met (Nat.le_of_lt fell))]
            exact fell
          exact Naturals.le_of_add_le_add_right shifted
        rw [if_pos (Nat.le_trans at_least raised), sub_eq_zero_of_le met,
          sub_eq_zero_of_le (Nat.le_trans met (Nat.le_of_lt fell)), Nat.add_zero, Nat.add_zero]
        exact Nat.add_lt_add_right closer 2)
  else by
    have gone : x - H = 0 := sub_eq_zero_of_le (Nat.le_of_lt (Nat.lt_of_not_le at_least))
    rw [if_neg at_least]
    rw [gone, Nat.zero_add] at notUp notDown ⊢
    have fell : a < x := (Nat.lt_or_ge a x).elim id fun ge => absurd ⟨ge, Nat.le_trans le ge⟩ notUp
    have rose : r < a := (Nat.lt_or_ge r a).elim id fun ge => absurd ⟨Nat.le_of_lt fell, ge⟩ notDown
    rw [if_neg (fun up : H ≤ a => at_least (Nat.le_trans up (Nat.le_of_lt fell))), if_pos rfl,
      if_neg (fun same : x = r => Nat.lt_irrefl r (Nat.lt_trans rose (same ▸ fell)))]
    exact Nat.lt_succ_self 0

/-- **Every rest of the state is the regime's or below the draw.** Where the adjusted giving rests at
the draw exactly where the regime gives the draw, the adjusted step leaves a state as it is exactly
where the state is at rest: at or above the draw with the recent giving at the draw and a level the
regime's step leaves as it is, or below the draw on the line where level and recent giving are equal,
the giving from nothing left giving it again. -/
theorem fixed_iff {A : Nat → Nat → Nat} {g : Nat → Nat} {H : Nat} {p : Nat × Nat}
    (restsAt : RestsAtDraw A g H) : step A H p = p ↔ AtRest A g H p :=
  if at_least : H ≤ p.1 then
    ⟨fun fixed => have ⟨rH, regime⟩ := (rest_iff (x := p.1) (r := p.2) restsAt at_least).1 fixed
      Or.inl ⟨rH, at_least, regime⟩,
     fun rest => rest.elim (fun ⟨rH, _, regime⟩ => (rest_iff (x := p.1) (r := p.2) restsAt at_least).2
        ⟨rH, regime⟩)
      (fun ⟨low, _, _⟩ => absurd at_least fun up => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le low up))⟩
  else
    have low : p.1 < H := Nat.lt_of_not_le at_least
    have gone : p.1 - H = 0 := sub_eq_zero_of_le (Nat.le_of_lt low)
    ⟨fun fixed => by
      have level : p.1 - H + A (p.1 - H) p.2 = p.1 := congrArg Prod.fst fixed
      have giving : A (p.1 - H) p.2 = p.2 := congrArg Prod.snd fixed
      rw [gone] at level giving
      rw [giving, Nat.zero_add] at level
      exact Or.inr ⟨low, level.symm, giving⟩,
     fun rest => rest.elim (fun ⟨_, up, _⟩ => absurd up at_least) fun ⟨_, same, again⟩ => by
      show (p.1 - H + A (p.1 - H) p.2, A (p.1 - H) p.2) = p
      rw [gone, again, Nat.zero_add]
      exact congrArg (fun v => (v, p.2)) same.symm⟩

/-- Within a band, a run from a state whose recent giving is at most its level, with `unordered` at
most `d`, is still from some step at most `d + 2 hi`. -/
theorem rests_from {A : Nat → Nat → Nat} {H hi : Nat} (rises : Rises A) (band : Band A H hi) :
    ∀ (d : Nat) (p : Nat × Nat), unordered H p ≤ d → p.2 ≤ p.1 → p.1 ≤ hi →
      ∃ N, N ≤ d + (hi + hi) ∧ LastChange.StillFrom (Law.run (step A H) p) N := by
  intro d
  induction d with
  | zero =>
    intro p bound le high
    exact if up : p.1 ≤ (step A H p).1 ∧ p.2 ≤ (step A H p).2 then
      have ⟨N, n_le, still⟩ := rests_rising rises band high (Nat.le_trans le high) up
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.sub_le _ _) (Nat.le_add_left _ 0)), still⟩
    else if down : (step A H p).1 ≤ p.1 ∧ (step A H p).2 ≤ p.2 then
      have ⟨N, n_le, still⟩ := rests_falling rises down
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.add_le_add high (Nat.le_trans le high))
        (Nat.le_add_left _ 0)), still⟩
    else absurd (Nat.lt_of_lt_of_le (unordered_falls (a := A (p.1 - H) p.2) le up down) bound)
      (Nat.not_lt_zero _)
  | succ d ih =>
    intro p bound le high
    exact if up : p.1 ≤ (step A H p).1 ∧ p.2 ≤ (step A H p).2 then
      have ⟨N, n_le, still⟩ := rests_rising rises band high (Nat.le_trans le high) up
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.sub_le _ _) (Nat.le_add_left _ (d + 1))), still⟩
    else if down : (step A H p).1 ≤ p.1 ∧ (step A H p).2 ≤ p.2 then
      have ⟨N, n_le, still⟩ := rests_falling rises down
      ⟨N, Nat.le_trans n_le (Nat.le_trans (Nat.add_le_add high (Nat.le_trans le high))
        (Nat.le_add_left _ (d + 1))), still⟩
    else
      have fewer : unordered H (step A H p) ≤ d := Nat.le_of_lt_succ
        (Nat.lt_of_lt_of_le (unordered_falls (a := A (p.1 - H) p.2) le up down) bound)
      have ⟨N, n_le, still⟩ :=
        ih (step A H p) fewer (given_le_level A H p) (band _ _ high (Nat.le_trans le high))
      ⟨N + 1, Nat.le_trans (Nat.succ_le_succ n_le) (Nat.le_of_eq (Nat.add_right_comm d (hi + hi) 1)),
        LastChange.still_succ still⟩

/-- **Every run of a rising adjustment within a band comes to rest.** Where the adjustment rises with
what is left and with the recent giving, rests at the draw exactly where the regime gives the draw,
and the step keeps every state with level and recent giving up to `hi` at a level up to `hi`, the
run from a level and a recent giving up to `hi` is still from some step at most `3 hi + 3`, at rest:
at the draw with a level the regime's step leaves as it is, or below the draw on the line where level
and recent giving are equal (at nothing, where nothing gives from nothing). Whether it changes again
is decided at each step; no omniscience is needed. -/
theorem comes_to_rest {A : Nat → Nat → Nat} {g : Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (restsAt : RestsAtDraw A g H) (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    ∃ N, N ≤ hi + hi + hi + 3 ∧ LastChange.StillFrom (Law.run (step A H) (x, r)) N ∧
      AtRest A g H ((Law.run (step A H) (x, r)).state N) := by
  have le := given_le_level A H (x, r)
  have top : (step A H (x, r)).1 ≤ hi := band x r high given
  have ⟨N, n_le, still⟩ := rests_from rises band (hi + 2) (step A H (x, r)) (unordered_le le top) le top
  have still' := LastChange.still_succ (next := step A H) (s := (x, r)) still
  have fixed : step A H ((Law.run (step A H) (x, r)).state (N + 1)) =
      (Law.run (step A H) (x, r)).state (N + 1) := still' 0
  refine ⟨N + 1, ?_, still', (fixed_iff restsAt).1 fixed⟩
  exact Nat.le_trans (Nat.succ_le_succ n_le) (Nat.le_of_eq (by
    show hi + 2 + (hi + hi) + 1 = hi + hi + hi + 3
    rw [Nat.add_comm hi 2, Nat.add_assoc 2 hi (hi + hi), Nat.add_comm 2 (hi + (hi + hi)),
      Nat.add_assoc (hi + (hi + hi)) 2 1, ← Nat.add_assoc hi hi hi]))

/-- **A rest below the draw.** Giving one whatever is left and whatever was given before rises, and
rests at a draw of two exactly where the regime's constant giving of one does (nowhere), and the step
keeps every state up to one at a level up to one; from a level of one with a recent giving of one the
run stays there at every step, below the draw, with its recent giving short of it. -/
theorem rests_short :
    Rises (fun _ _ => 1) ∧ RestsAtDraw (fun _ _ => 1) (fun _ => 1) 2 ∧ Band (fun _ _ => 1) 2 1 ∧
    ∀ n, (Law.run (step (fun _ _ => 1) 2) (1, 1)).state n = (1, 1) :=
  ⟨fun _ _ _ _ _ _ => Nat.le_refl 1, fun _ => Iff.rfl,
   fun x _ high _ => by
    show x - 2 + 1 ≤ 1
    rw [sub_eq_zero_of_le (Nat.le_trans high (Nat.le_succ 1)), Nat.zero_add]
    exact Nat.le_refl 1,
   fun n => (congrArg (Law.orbit (step (fun _ _ => 1) 2) (1, 1)) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := step (fun _ _ => 1) 2) (s := (1, 1)) (p := 1) rfl n)⟩

end Adjusted

namespace Crossing

/-- Giving gated at two rises with what is left. -/
theorem giving_rises : ∀ a b, a ≤ b → giving a ≤ giving b := fun a b le =>
  (Nat.lt_or_ge a 2).elim
    (fun lt => Nat.le_trans (Nat.le_of_eq (if_pos lt)) (Nat.zero_le _))
    (fun ge =>
      have atA : giving a = 4 := if_neg fun lt => Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt ge lt)
      have atB : giving b = 4 := if_neg fun lt =>
        Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt (Nat.le_trans ge le) lt)
      Nat.le_of_eq (atA.trans atB.symm))

/-- From five, the regime's step under the gated giving and a draw of three raises the level by one
at every step. -/
theorem climbs : ∀ n, Law.orbit (step giving 3) 5 n = n + 5
  | 0 => rfl
  | n + 1 => by
    show step giving 3 (Law.orbit (step giving 3) 5 n) = n + 1 + 5
    rw [climbs n]
    show n + 5 - 3 + giving (n + 5 - 3) = n + 1 + 5
    rw [show n + 5 - 3 = n + 2 from Naturals.add_sub_cancel (n + 2) 3,
      show giving (n + 2) = 4 from if_neg fun lt =>
        Nat.lt_irrefl 2 (Nat.lt_of_le_of_lt (Nat.le_add_left 2 n) lt)]

/-- **Without a band, a rising run need not rest.** Giving gated at two rises with what is left, so
the adjustment reading what is left alone rises, and it rests at a draw of three exactly where the
regime does; yet from five the regime's step raises the level by one at every step, so neither the
regime's run from five nor the adjusted run from five with a recent giving of three is ever still. -/
theorem rises_without_rest :
    Adjusted.Rises (fun e _ => giving e) ∧ Adjusted.RestsAtDraw (fun e _ => giving e) giving 3 ∧
    (∀ n, (Law.run (step giving 3) 5).state n = n + 5) ∧
    (∀ N, ¬ LastChange.StillFrom (Law.run (step giving 3) 5) N) ∧
    ∀ N, ¬ LastChange.StillFrom (Law.run (Adjusted.step (fun e _ => giving e) 3) (5, 3)) N :=
  have never : ∀ N, ¬ LastChange.StillFrom (Law.run (step giving 3) 5) N := fun N still =>
    Naturals.succ_ne_self (N + 5) ((climbs (N + 0 + 1)).symm.trans ((still 0).trans (climbs (N + 0))))
  ⟨fun e e' _ _ le _ => giving_rises e e' le, fun _ => Iff.rfl, climbs, never,
   fun N still => never N fun k =>
    (Adjusted.orbit_regime giving 3 (5, 3) (N + k + 1)).symm.trans
      ((congrArg Prod.fst (still k)).trans (Adjusted.orbit_regime giving 3 (5, 3) (N + k)))⟩

end Crossing

namespace Alternation

/-- Giving that falls as what is left rises: two from nothing, nothing from anything more. -/
def giving (z : Nat) : Nat := if z = 0 then 2 else 0

/-- The regime's step under a draw of one keeps every level up to two within two. -/
theorem keeps : Keeps giving 1 2
  | 0, _ => Nat.le_refl 2
  | 1, _ => Nat.le_refl 2
  | 2, _ => Nat.le_succ 1
  | n + 3, high =>
    absurd (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self 2) (Nat.le_add_left 3 n)) high)
      (Nat.lt_irrefl 2)

/-- From one, the regime's step under a draw of one returns to one every second step. -/
theorem returns : ∀ k, Law.orbit (step giving 1) 1 (k + k) = 1 := fun k =>
  (congrArg (Law.orbit (step giving 1) 1) (Naturals.two_mul k)).symm.trans
    (Law.orbit_mul (next := step giving 1) (s := 1) (p := 2) rfl k)

/-- **Without giving rising with what is left, a run within a band need not rest.** Giving that is
two from nothing and nothing from more does not rise with what is left. Under a draw of one the
regime's step keeps every level up to two within two, and the adjustment reading what is left alone
rests at the draw exactly where the regime does and keeps the band; from one with a recent giving of
two its first step raises both, so no ordering of the start is enough either. Yet the regime's run from one moves between one and two at every
step, and so does the level of the adjusted run, so neither is ever still. -/
theorem alternates :
    ¬ (∀ a b, a ≤ b → giving a ≤ giving b) ∧ Keeps giving 1 2 ∧
    Adjusted.RestsAtDraw (fun e _ => giving e) giving 1 ∧ Adjusted.Band (fun e _ => giving e) 1 2 ∧
    Adjusted.Below (1, 2) (Adjusted.step (fun e _ => giving e) 1 (1, 2)) ∧
    (∀ N, ¬ LastChange.StillFrom (Law.run (step giving 1) 1) N) ∧
    ∀ N, ¬ LastChange.StillFrom (Law.run (Adjusted.step (fun e _ => giving e) 1) (1, 2)) N :=
  have never : ∀ N, ¬ LastChange.StillFrom (Law.run (step giving 1) 1) N := fun N still =>
    absurd ((congrArg (step giving 1) (returns N)).symm.trans ((still N).trans (returns N)))
      (Naturals.succ_ne_self 1)
  ⟨fun grows => Nat.not_succ_le_zero 1 (grows 0 1 (Nat.zero_le 1)), keeps, fun _ => Iff.rfl,
   fun x _ high _ => keeps x high, ⟨Nat.le_succ 1, Nat.le_refl 2⟩, never,
   fun N still => never N fun k =>
    (Adjusted.orbit_regime giving 1 (1, 2) (N + k + 1)).symm.trans
      ((congrArg Prod.fst (still k)).trans (Adjusted.orbit_regime giving 1 (1, 2) (N + k)))⟩

end Alternation

/-! ## The threshold in the plane

RM2's point of no return is exact on the state where the recent giving lies on the level's side of
the draw (`Adjusted.ends_iff_below`), and left the threshold elsewhere in the plane of level and
recent giving open. Where the adjustment rises with what is left and with the recent giving, runs
keep the order of their starts (`Lasting.orbit_mono`), and within a band every run comes to rest
(`Adjusted.comes_to_rest`); so a state at or below one whose run rests below the draw rests below
it too, and whether it does is decided at step `3 hi + 3`. For each recent giving the levels whose
runs rest below the draw are then exactly those below a least level, and that level does not rise as
the recent giving rises: the point of no return is a falling curve in the plane. Under the regime's
step it is RM1's level `H + y` at every recent giving. -/

/-- The length of the run of `true` with which `b` starts, among its first `k` values. -/
def leading (b : Nat → Bool) : Nat → Nat
  | 0 => 0
  | k + 1 => if leading b k = k ∧ b k = true then k + 1 else leading b k

theorem leading_le (b : Nat → Bool) : ∀ k, leading b k ≤ k
  | 0 => Nat.le_refl 0
  | k + 1 => by
    show (if leading b k = k ∧ b k = true then k + 1 else leading b k) ≤ k + 1
    exact if h : leading b k = k ∧ b k = true then by rw [if_pos h]; exact Nat.le_refl _
      else by rw [if_neg h]; exact Nat.le_succ_of_le (leading_le b k)

/-- Every value before the leading run's end is `true`. -/
theorem leading_true (b : Nat → Bool) : ∀ k x, x < leading b k → b x = true
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | k + 1, x, lt => by
    have unfold : leading b (k + 1) = if leading b k = k ∧ b k = true then k + 1 else leading b k := rfl
    exact if h : leading b k = k ∧ b k = true then by
        rw [unfold, if_pos h] at lt
        exact (Nat.lt_or_ge x k).elim
          (fun below => leading_true b k x (Nat.lt_of_lt_of_le below (Nat.le_of_eq h.1.symm)))
          (fun ge => (congrArg b (Nat.le_antisymm (Nat.le_of_lt_succ lt) ge)).trans h.2)
      else by
        rw [unfold, if_neg h] at lt
        exact leading_true b k x lt

/-- Where the leading run ends before `k`, the value there is `false`. -/
theorem leading_false (b : Nat → Bool) : ∀ k, leading b k < k → b (leading b k) = false
  | 0, lt => absurd lt (Nat.lt_irrefl 0)
  | k + 1, lt => by
    have unfold : leading b (k + 1) = if leading b k = k ∧ b k = true then k + 1 else leading b k := rfl
    exact if h : leading b k = k ∧ b k = true then by
        rw [unfold, if_pos h] at lt
        exact absurd lt (Nat.lt_irrefl _)
      else by
        rw [unfold, if_neg h] at lt ⊢
        exact (Nat.lt_or_ge (leading b k) k).elim (leading_false b k) fun ge =>
          have same : leading b k = k := Nat.le_antisymm (leading_le b k) ge
          match hb : b k with
          | true => absurd ⟨same, hb⟩ h
          | false => (congrArg b same).trans hb

/-- Leading runs of `true` agree for checks that agree. -/
theorem leading_congr {b b' : Nat → Bool} (same : ∀ x, b x = b' x) : ∀ k, leading b k = leading b' k
  | 0 => rfl
  | k + 1 => by
    show (if leading b k = k ∧ b k = true then k + 1 else leading b k) =
      (if leading b' k = k ∧ b' k = true then k + 1 else leading b' k)
    rw [leading_congr same k, same k]

/-- **The law of exact thresholds.** Where a reading `P` of levels is closed downward up to `hi` and a
check `d` is exact for it there, the levels up to `hi` the reading holds of are exactly those below
the leading run of `true` among `d`'s first `hi + 1` values. Every point of no return in this module
is this law for its own reading and check. -/
theorem leading_exact {P : Nat → Prop} {d : Nat → Bool} {hi : Nat}
    (down : ∀ a b, b ≤ hi → P b → a ≤ b → P a) (exact : ∀ a, a ≤ hi → (P a ↔ d a = true)) :
    ∀ a, a ≤ hi → (P a ↔ a < leading d (hi + 1)) :=
  fun a high =>
    ⟨fun holds => (Nat.lt_or_ge a (leading d (hi + 1))).elim id fun ge =>
        have short : leading d (hi + 1) < hi + 1 := Nat.lt_of_le_of_lt ge (Nat.lt_succ_of_le high)
        False.elim (Bool.noConfusion ((leading_false d (hi + 1) short).symm.trans
          ((exact _ (Nat.le_of_lt_succ short)).1 (down _ a high holds ge)))),
     fun lt => (exact a high).2 (leading_true d (hi + 1) a lt)⟩

/-- **A threshold falls with its reading.** Where checks `d` and `e` are exact up to `hi` for readings
`P` and `Q`, and `Q` implies `P` there, `e`'s threshold is no higher than `d`'s. -/
theorem leading_falls {P Q : Nat → Prop} {d e : Nat → Bool} {hi : Nat}
    (exactP : ∀ a, a ≤ hi → (P a ↔ d a = true)) (exactQ : ∀ a, a ≤ hi → (Q a ↔ e a = true))
    (implies : ∀ a, a ≤ hi → Q a → P a) : leading e (hi + 1) ≤ leading d (hi + 1) :=
  (Nat.lt_or_ge (leading d (hi + 1)) (leading e (hi + 1))).elim
    (fun lt =>
      have high : leading d (hi + 1) ≤ hi :=
        Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (leading_le e (hi + 1)))
      False.elim (Bool.noConfusion ((leading_false d (hi + 1) (Nat.lt_succ_of_le high)).symm.trans
        ((exactP _ high).1 (implies _ high ((exactQ _ high).2 (leading_true e (hi + 1) _ lt)))))))
    id

/-- **A check exact for the levels below `t` has threshold `t`**, where `t` is at most `hi + 1`: the
law of exact thresholds for the reading "below `t`". -/
theorem leading_eq {d : Nat → Bool} {hi t : Nat} (exact : ∀ a, a ≤ hi → (a < t ↔ d a = true))
    (reach : t ≤ hi + 1) : leading d (hi + 1) = t :=
  have same := leading_exact (P := fun a => a < t) (fun _ _ _ lt le => Nat.lt_of_le_of_lt le lt) exact
  Nat.le_antisymm
    ((Nat.lt_or_ge t (leading d (hi + 1))).elim
      (fun lt => absurd ((same t (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (leading_le d (hi + 1))))).2
        lt) (Nat.lt_irrefl t))
      id)
    ((Nat.lt_or_ge (leading d (hi + 1)) t).elim
      (fun lt => absurd ((same _ (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt reach))).1 lt) (Nat.lt_irrefl _))
      id)

namespace Adjusted

/-- The run from a state comes to rest below the draw. -/
def RestsBelow (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) : Prop :=
  ∃ N, LastChange.StillFrom (Law.run (step A H) p) N ∧ ((Law.run (step A H) p).state N).1 < H

/-- Whether the run from level `x` with recent giving `r` is below the draw at step `3 hi + 3`. -/
def falling (A : Nat → Nat → Nat) (H hi r x : Nat) : Bool :=
  decide (((Law.run (step A H) (x, r)).state (hi + hi + hi + 3)).1 < H)

/-- **The threshold in the plane.** For a recent giving `r`, the least level up to `hi + 1` whose run,
within the band up to `hi`, is not below the draw at step `3 hi + 3`. -/
def threshold (A : Nat → Nat → Nat) (H hi r : Nat) : Nat := leading (falling A H hi r) (hi + 1)

/-- **Below a state whose run rests below the draw, every run does.** Where the adjustment rises with
what is left and with the recent giving and keeps a band, a state at or below one within the band
whose run comes to rest below the draw comes to rest below it too. -/
theorem falls_of_below {A : Nat → Nat → Nat} {H hi : Nat} {p q : Nat × Nat} (rises : Rises A)
    (band : Band A H hi) (below : Below p q) (high : q.1 ≤ hi) (given : q.2 ≤ hi)
    (falls : RestsBelow A H q) : RestsBelow A H p :=
  have ⟨N, still, low⟩ := falls
  have ⟨N', _, still', _⟩ := comes_to_rest (g := fun e => A e H) (x := p.1) (r := p.2) rises
    (fun _ => Iff.rfl) band (Nat.le_trans below.1 high) (Nat.le_trans below.2 given)
  have order := Lasting.orbit_mono (rel := Below) (fun _ _ b => step_mono rises H b) below (N' + N)
  ⟨N', still', Nat.lt_of_le_of_lt
    (Nat.le_trans (Nat.le_of_eq (congrArg Prod.fst (LastChange.still_stays still' N).symm))
      (Nat.le_trans order.1 (Nat.le_of_eq (congrArg Prod.fst
        ((congrArg (Law.orbit (step A H) q) (Nat.add_comm N' N)).trans
          (LastChange.still_stays still N'))))))
    low⟩

/-- Within a band, whether the run of a rising adjustment comes to rest below the draw is decided at
step `3 hi + 3`. -/
theorem falls_iff {A : Nat → Nat → Nat} {H hi x r : Nat} (rises : Rises A) (band : Band A H hi)
    (high : x ≤ hi) (given : r ≤ hi) :
    RestsBelow A H (x, r) ↔ ((Law.run (step A H) (x, r)).state (hi + hi + hi + 3)).1 < H :=
  have ⟨N0, le, still0, _⟩ := comes_to_rest (g := fun e => A e H) rises (fun _ => Iff.rfl) band high given
  have atM : (Law.run (step A H) (x, r)).state (hi + hi + hi + 3) =
      (Law.run (step A H) (x, r)).state N0 :=
    (congrArg (fun n => (Law.run (step A H) (x, r)).state n) (Naturals.add_sub_of_le le).symm).trans
      (LastChange.still_stays still0 _)
  ⟨fun ⟨_, still, low⟩ => Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst
      (atM.trans (LastChange.still_same still0 still)))) low,
   fun low => ⟨N0, still0, Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst atM.symm)) low⟩⟩

/-- Within a band, the check at step `3 hi + 3` is exact for a run of a rising adjustment coming to
rest below the draw. -/
theorem rests_iff_falling {A : Nat → Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    RestsBelow A H (x, r) ↔ falling A H hi r x = true :=
  (falls_iff rises band high given).trans ⟨decide_eq_true, of_decide_eq_true⟩

/-- **The threshold is exact.** Where the adjustment rises with what is left and with the recent
giving and keeps a band up to `hi`, the run from a level and a recent giving up to `hi` comes to rest
below the draw exactly where the level is below the threshold for that recent giving: the law of exact
thresholds (`leading_exact`) for coming to rest below the draw. -/
theorem falls_iff_below {A : Nat → Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    RestsBelow A H (x, r) ↔ x < threshold A H hi r :=
  leading_exact (P := fun x => RestsBelow A H (x, r)) (d := falling A H hi r)
    (fun a b high' falls le =>
      falls_of_below (p := (a, r)) (q := (b, r)) rises band ⟨le, Nat.le_refl r⟩ high' given falls)
    (fun _ high' => rests_iff_falling rises band high' given) x high

/-- **The threshold falls as the recent giving rises.** Where the adjustment rises with what is left
and with the recent giving and keeps a band up to `hi`, a larger recent giving up to `hi` has a
threshold no higher: the law of exact thresholds (`leading_falls`), a run resting below the draw with
the larger recent giving resting below it with the smaller. -/
theorem threshold_falls {A : Nat → Nat → Nat} {H hi r r' : Nat} (rises : Rises A)
    (band : Band A H hi) (le : r ≤ r') (given : r' ≤ hi) :
    threshold A H hi r' ≤ threshold A H hi r :=
  leading_falls (P := fun x => RestsBelow A H (x, r)) (Q := fun x => RestsBelow A H (x, r'))
    (fun _ high => rests_iff_falling rises band high (Nat.le_trans le given))
    (fun _ high => rests_iff_falling rises band high given)
    (fun a high falls =>
      falls_of_below (p := (a, r)) (q := (a, r')) rises band ⟨Nat.le_refl a, le⟩ high given falls)

/-- **Every state in the band has its fate by the threshold.** Where the adjustment rises with what
is left and with the recent giving, rests at the draw exactly where the regime gives the draw, and
keeps a band up to `hi`, the run from a level and a recent giving up to `hi` is still from some step
at most `3 hi + 3`: below the threshold, at a rest below the draw with level and recent giving equal
(nothing, where nothing gives from nothing); from the threshold on, at the draw with a level the
regime's step leaves as it is. -/
theorem fates {A : Nat → Nat → Nat} {g : Nat → Nat} {H hi x r : Nat} (rises : Rises A)
    (restsAt : RestsAtDraw A g H) (band : Band A H hi) (high : x ≤ hi) (given : r ≤ hi) :
    ∃ N, N ≤ hi + hi + hi + 3 ∧ LastChange.StillFrom (Law.run (step A H) (x, r)) N ∧
      (x < threshold A H hi r → ((Law.run (step A H) (x, r)).state N).1 < H ∧
        ((Law.run (step A H) (x, r)).state N).1 = ((Law.run (step A H) (x, r)).state N).2 ∧
        A 0 ((Law.run (step A H) (x, r)).state N).2 = ((Law.run (step A H) (x, r)).state N).2) ∧
      (threshold A H hi r ≤ x → ((Law.run (step A H) (x, r)).state N).2 = H ∧
        H ≤ ((Law.run (step A H) (x, r)).state N).1 ∧
        RegimeMargin.step g H ((Law.run (step A H) (x, r)).state N).1 =
          ((Law.run (step A H) (x, r)).state N).1) :=
  have ⟨N, le, still, rest⟩ := comes_to_rest rises restsAt band high given
  ⟨N, le, still,
   fun lt => rest.elim
    (fun ⟨_, up, _⟩ =>
      have ⟨_, still', low'⟩ := (falls_iff_below rises band high given).2 lt
      absurd (Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst (LastChange.still_same still still')))
        low') fun l => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le l up))
    id,
   fun ge => rest.elim id fun ⟨low, _, _⟩ =>
    absurd ((falls_iff_below rises band high given).1 ⟨N, still, low⟩)
      fun l => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le l ge)⟩

end Adjusted

/-- **Under the regime's step the threshold is the point of no return.** Where giving rises with what
is left, falls short of the draw below `y`, meets it from `y` up to the band's top, gives nothing from
nothing, and the step keeps the band up to `hi`, which reaches the point, the threshold is `H + y` at
every recent giving up to `hi`. -/
theorem threshold_regime {g : Nat → Nat} {H y hi r : Nat} (grows : ∀ a b, a ≤ b → g a ≤ g b)
    (short : Short g H y) (nothing : FromNothing g) (meets : Meets g H y hi)
    (keeps : Keeps g H hi) (given : r ≤ hi) (reach : H + y ≤ hi + 1) :
    Adjusted.threshold (fun e _ => g e) H hi r = H + y := by
  have rises : Adjusted.Rises (fun e _ => g e) := fun e e' _ _ le _ => grows e e' le
  have band : Adjusted.Band (fun e _ => g e) H hi := fun x _ high _ => keeps x high
  have regime : ∀ x, x ≤ hi → (Adjusted.RestsBelow (fun e _ => g e) H (x, r) ↔ x < H + y) :=
    fun x high => ⟨fun ⟨N, _, low⟩ => (Nat.lt_or_ge x (H + y)).elim id fun ge =>
        have up : x ≤ (Law.run (step g H) x).state N := (holds meets keeps ge high N).1
        absurd low fun l => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le l (Nat.le_trans
          (Nat.le_trans (Nat.le_add_right H y) ge)
          (Nat.le_trans up (Nat.le_of_eq (Adjusted.orbit_regime g H (x, r) N).symm)))),
      fun below =>
        have gone : (Law.orbit (Adjusted.step (fun e _ => g e) H) (x, r) x).1 = 0 :=
          (Adjusted.orbit_regime g H (x, r) x).trans (ends_below short nothing below)
        have next : Law.orbit (Adjusted.step (fun e _ => g e) H) (x, r) (x + 1) = (0, 0) := by
          show (_ - H + g (_ - H), g (_ - H)) = (0, 0)
          rw [gone, Nat.zero_sub, nothing]
        have stays : ∀ k, Law.orbit (Adjusted.step (fun e _ => g e) H) (x, r) (x + 1 + k) = (0, 0) :=
          fun k => (Law.orbit_add _ (x, r) (x + 1) k).trans (by
            rw [next, ← Nat.one_mul k]
            exact Law.orbit_mul (next := Adjusted.step (fun e _ => g e) H) (s := (0, 0)) (p := 1)
              (show (0 - H + g (0 - H), g (0 - H)) = (0, 0) by rw [Nat.zero_sub, nothing]) k)
        ⟨x + 1, fun k => (stays (k + 1)).trans (stays k).symm,
          Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg Prod.fst next)) (Adjusted.draw_pos short below)⟩⟩
  exact leading_eq (fun x high => (regime x high).symm.trans
    (Adjusted.rests_iff_falling rises band high given)) reach

namespace Notch

/-- Giving that is two from one and nothing from any other level. -/
def giving (z : Nat) : Nat := if z = 1 then 2 else 0

/-- Under a draw of two the regime's step keeps every level up to four within four. -/
theorem keeps : Keeps giving 2 4
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | 3, _ => by decide
  | 4, _ => by decide
  | n + 5, high =>
    absurd (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self 4) (Nat.le_add_left 5 n)) high)
      (Nat.lt_irrefl 4)

/-- From three with a recent giving of nothing, the run is at three with a recent giving of two from
the first step on. -/
theorem stays_three :
    ∀ n, Law.orbit (Adjusted.step (fun e _ => giving e) 2) (3, 0) (n + 1) = (3, 2) := fun n =>
  (Law.orbit_shift _ (3, 0) n).trans
    ((congrArg (Law.orbit (Adjusted.step (fun e _ => giving e) 2) (3, 2)) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := Adjusted.step (fun e _ => giving e) 2) (s := (3, 2)) (p := 1) rfl n))

/-- From four with a recent giving of nothing, the run is at nothing from the second step on. -/
theorem ends_four :
    ∀ k, Law.orbit (Adjusted.step (fun e _ => giving e) 2) (4, 0) (2 + k) = (0, 0) := fun k =>
  (Law.orbit_add _ (4, 0) 2 k).trans
    ((congrArg (Law.orbit (Adjusted.step (fun e _ => giving e) 2) (0, 0)) (Nat.one_mul k)).symm.trans
      (Law.orbit_mul (next := Adjusted.step (fun e _ => giving e) 2) (s := (0, 0)) (p := 1) rfl k))

/-- **Without giving rising with what is left, there is no threshold.** Giving that is two from one
and nothing from more does not rise with what is left; under a draw of two its step keeps every state
up to four at a level up to four. Yet from four the run comes to rest below the draw, at nothing, and
from three, below four, it rests at three: no least level separates the runs that rest below the
draw from the rest. -/
theorem no_threshold :
    ¬ (∀ a b, a ≤ b → giving a ≤ giving b) ∧ Adjusted.Band (fun e _ => giving e) 2 4 ∧
    Adjusted.RestsBelow (fun e _ => giving e) 2 (4, 0) ∧
    ¬ Adjusted.RestsBelow (fun e _ => giving e) 2 (3, 0) ∧
    ∀ t, ¬ ∀ x, x ≤ 4 → (Adjusted.RestsBelow (fun e _ => giving e) 2 (x, 0) ↔ x < t) :=
  have four : Adjusted.RestsBelow (fun e _ => giving e) 2 (4, 0) :=
    ⟨2, fun k => (ends_four (k + 1)).trans (ends_four k).symm, Nat.zero_lt_succ 1⟩
  have three : ¬ Adjusted.RestsBelow (fun e _ => giving e) 2 (3, 0) := fun ⟨N, _, low⟩ =>
    have big : 3 ≤ ((Law.run (Adjusted.step (fun e _ => giving e) 2) (3, 0)).state N).1 :=
      match N with
      | 0 => Nat.le_refl 3
      | n + 1 => Nat.le_of_eq (congrArg Prod.fst (stays_three n)).symm
    Nat.lt_irrefl 2 (Nat.lt_trans (Nat.lt_succ_self 2) (Nat.lt_of_le_of_lt big low))
  ⟨fun grows => absurd (grows 1 2 (Nat.le_succ 1)) (by decide), fun x _ high _ => keeps x high,
   four, three,
   fun t all => three ((all 3 (Nat.le_succ 3)).2
     (Nat.lt_trans (Nat.lt_succ_self 3) ((all 4 (Nat.le_refl 4)).1 four)))⟩

end Notch

/-! ## The regime in any amounts

The laws above read amounts in whole numbers, where every change moves an amount by at least one, so
a run within a band comes to rest. `Drawn` reads them in any amounts with a linear order and a draw
taken first, as much as there is: the non-negative rationals or reals as well as the whole numbers.
There a run need not come to rest, and what holds is the shape of its course: the adjusted step
keeps the order of states; from the first step on, a step that neither raises nor lowers both the
level and the recent giving moves the recent giving strictly toward the draw from the side it
stands on and the level the other way, and the next such step is of the same kind; a step that raises
or lowers both is followed by such steps for ever. So each of the two moves one way, turns at most
once, and then moves one way again. The rests are the regime's point and the states below the draw
with level and recent giving equal. In whole numbers the step is the adjusted step above. -/

/-- **Amounts with a draw.** Amounts linearly ordered, with `sub a b` what is left of `a` once `b`
is taken, as much as there is: all but `b` where `b` is within `a`, and nothing where it is not. -/
structure Drawn (V : Type) extends Amounts V where
  sub : V → V → V
  add_sub : ∀ {a b : V}, le b a → add b (sub a b) = a
  sub_zero : ∀ {a b : V}, le a b → sub a b = zero
  total : ∀ a b, le a b ∨ le b a
  antisymm : ∀ {a b : V}, le a b → le b a → a = b

namespace Drawn

variable {V : Type} (D : Drawn V)

/-- One step of a condition whose giving adjusts, in amounts with a draw: the draw `H` takes first,
as much as there is; the giving is `A` of what is left and of the recent giving; the next level is
what is left with that giving, which is the next step's recent giving. -/
def step (A : V → V → V) (H : V) (p : V × V) : V × V :=
  (D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2), A (D.sub p.1 H) p.2)

/-- The adjusted giving rises with what is left and with the recent giving. -/
def Rises (A : V → V → V) : Prop := ∀ e e' r r', D.le e e' → D.le r r' → D.le (A e r) (A e' r')

/-- One state at or below another, in level and in recent giving. -/
def Below (p q : V × V) : Prop := D.le p.1 q.1 ∧ D.le p.2 q.2

/-- **A climbing step**: the level rises strictly and the recent giving falls strictly, staying
strictly above the draw. -/
def Climbs (H : V) (p q : V × V) : Prop :=
  D.le p.1 q.1 ∧ ¬ D.le q.1 p.1 ∧ D.le q.2 p.2 ∧ ¬ D.le p.2 q.2 ∧ ¬ D.le q.2 H

/-- **A sinking step**: the level falls strictly and the recent giving rises strictly, staying
strictly below the draw. -/
def Sinks (H : V) (p q : V × V) : Prop :=
  D.le q.1 p.1 ∧ ¬ D.le p.1 q.1 ∧ D.le p.2 q.2 ∧ ¬ D.le q.2 p.2 ∧ ¬ D.le H q.2

/-- The adjusted step keeps every state whose level and recent giving are within `hi` at a level
within `hi`. -/
def Band (A : V → V → V) (H hi : V) : Prop :=
  ∀ x r, D.le x hi → D.le r hi → D.le (D.step A H (x, r)).1 hi

variable {D}

theorem add_cancel {a b c : V} (le : D.le (D.add a b) (D.add a c)) : D.le b c :=
  D.le_of_add_le_add_right a (by rw [D.add_comm b a, D.add_comm c a]; exact le)

/-- What is left after the draw rises with the level. -/
theorem sub_mono {x y : V} (H : V) (le : D.le x y) : D.le (D.sub x H) (D.sub y H) :=
  (D.total H x).elim
    (fun high => add_cancel (a := H) (by
      rw [D.add_sub high, D.add_sub (D.le_trans high le)]; exact le))
    (fun low => by rw [D.sub_zero low]; exact D.zero_le _)

/-- **The adjusted step keeps the order of states** where the adjustment rises. -/
theorem step_mono {A : V → V → V} (rises : D.Rises A) (H : V) {p q : V × V} (below : D.Below p q) :
    D.Below (D.step A H p) (D.step A H q) :=
  have left := sub_mono H below.1
  have given := rises _ _ _ _ left below.2
  ⟨D.le_trans (D.add_le_add_right _ left) (Amounts.add_le_add_left _ given), given⟩

/-- After a step the recent giving is within the level. -/
theorem given_le_level (A : V → V → V) (H : V) (p : V × V) :
    D.le (D.step A H p).2 (D.step A H p).1 :=
  Amounts.le_add_left _ _

/-- At or above the draw, the level rises over a step exactly where the new giving meets the draw. -/
theorem level_up_iff {A : V → V → V} {H : V} {p : V × V} (high : D.le H p.1) :
    D.le p.1 (D.step A H p).1 ↔ D.le H (D.step A H p).2 :=
  have split : p.1 = D.add (D.sub p.1 H) H := ((D.add_comm _ _).trans (D.add_sub high)).symm
  ⟨fun le => add_cancel (a := D.sub p.1 H) (c := A (D.sub p.1 H) p.2)
      (D.le_trans (Amounts.le_of_eq split.symm) le),
   fun le => D.le_trans (Amounts.le_of_eq split) (Amounts.add_le_add_left _ le)⟩

/-- At or above the draw, the level falls over a step exactly where the new giving is within the
draw. -/
theorem level_down_iff {A : V → V → V} {H : V} {p : V × V} (high : D.le H p.1) :
    D.le (D.step A H p).1 p.1 ↔ D.le (D.step A H p).2 H :=
  have split : p.1 = D.add (D.sub p.1 H) H := ((D.add_comm _ _).trans (D.add_sub high)).symm
  ⟨fun le => add_cancel (a := D.sub p.1 H) (b := A (D.sub p.1 H) p.2)
      (D.le_trans le (Amounts.le_of_eq split)),
   fun le => D.le_trans (Amounts.add_le_add_left _ le) (Amounts.le_of_eq split.symm)⟩

/-- At or below the draw, the draw takes everything and the level after a step is the new giving. -/
theorem level_of_low {A : V → V → V} {H : V} {p : V × V} (low : D.le p.1 H) :
    (D.step A H p).1 = (D.step A H p).2 := by
  show D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2) = A (D.sub p.1 H) p.2
  rw [D.sub_zero low]; exact D.zero_add _

/-- **A step that neither raises nor lowers both climbs or sinks.** From a state whose recent giving
is within its level, a step that leaves the level and the recent giving neither both risen nor both
fallen raises the level strictly while the recent giving falls strictly toward the draw from above,
or lowers it strictly while the recent giving rises strictly toward the draw from below. -/
theorem climbs_or_sinks {A : V → V → V} {H : V} {p : V × V} (within : D.le p.2 p.1)
    (notUp : ¬ D.Below p (D.step A H p)) (notDown : ¬ D.Below (D.step A H p) p) :
    D.Climbs H p (D.step A H p) ∨ D.Sinks H p (D.step A H p) :=
  (D.total H p.1).elim
    (fun high => (D.total p.2 (D.step A H p).2).elim
      (fun up =>
        have notRise : ¬ D.le H (D.step A H p).2 := fun h => notUp ⟨(level_up_iff high).2 h, up⟩
        have fall : D.le (D.step A H p).1 p.1 :=
          (level_down_iff high).2 ((D.total H (D.step A H p).2).elim (fun h => absurd h notRise) id)
        Or.inr ⟨fall, fun h => notRise ((level_up_iff high).1 h), up, fun h => notDown ⟨fall, h⟩,
          notRise⟩)
      (fun down =>
        have notFall : ¬ D.le (D.step A H p).2 H := fun h => notDown ⟨(level_down_iff high).2 h, down⟩
        have rise : D.le p.1 (D.step A H p).1 :=
          (level_up_iff high).2 ((D.total H (D.step A H p).2).elim id (fun h => absurd h notFall))
        Or.inl ⟨rise, fun h => notFall ((level_down_iff high).1 h), down, fun h => notUp ⟨rise, h⟩,
          notFall⟩))
    (fun low =>
      have same := level_of_low (A := A) low
      (D.total p.2 (D.step A H p).2).elim
        (fun up =>
          have notRise : ¬ D.le p.1 (D.step A H p).2 := fun h =>
            notUp ⟨D.le_trans h (Amounts.le_of_eq same.symm), up⟩
          have fall : D.le (D.step A H p).1 p.1 := D.le_trans (Amounts.le_of_eq same)
            ((D.total p.1 (D.step A H p).2).elim (fun h => absurd h notRise) id)
          Or.inr ⟨fall, fun h => notRise (D.le_trans h (Amounts.le_of_eq same)), up,
            fun h => notDown ⟨fall, h⟩, fun h => notRise (D.le_trans low h)⟩)
        (fun down => absurd ⟨D.le_trans (Amounts.le_of_eq same) (D.le_trans down within), down⟩
          notDown))

/-- **A climb is followed by a climb, or by a step raising or lowering both.** -/
theorem climbs_next {A : V → V → V} {H : V} {p : V × V} (climbs : D.Climbs H p (D.step A H p))
    (notUp : ¬ D.Below (D.step A H p) (D.step A H (D.step A H p)))
    (notDown : ¬ D.Below (D.step A H (D.step A H p)) (D.step A H p)) :
    D.Climbs H (D.step A H p) (D.step A H (D.step A H p)) :=
  (climbs_or_sinks (given_le_level A H p) notUp notDown).elim id fun sinks =>
    absurd (D.le_trans ((D.total (D.step A H p).2 H).elim (fun h => absurd h climbs.2.2.2.2) id)
      sinks.2.2.1) sinks.2.2.2.2

/-- **A sink is followed by a sink, or by a step raising or lowering both.** -/
theorem sinks_next {A : V → V → V} {H : V} {p : V × V} (sinks : D.Sinks H p (D.step A H p))
    (notUp : ¬ D.Below (D.step A H p) (D.step A H (D.step A H p)))
    (notDown : ¬ D.Below (D.step A H (D.step A H p)) (D.step A H p)) :
    D.Sinks H (D.step A H p) (D.step A H (D.step A H p)) :=
  (climbs_or_sinks (given_le_level A H p) notUp notDown).elim (fun climbs =>
    absurd (D.le_trans climbs.2.2.1
      ((D.total (D.step A H p).2 H).elim id (fun h => absurd h sinks.2.2.2.2))) climbs.2.2.2.2) id

/-- **The rests in any amounts.** A state the adjusted step leaves as it is lies at or above the draw
with the recent giving at the draw and the adjustment giving the draw from what is left, the regime's
point; or within the draw, with the level and the recent giving equal and the adjustment from nothing
left giving it again. -/
theorem rest_iff {A : V → V → V} {H : V} {p : V × V} :
    D.step A H p = p ↔ (p.2 = H ∧ D.le H p.1 ∧ A (D.sub p.1 H) H = H) ∨
      (D.le p.1 H ∧ p.1 = p.2 ∧ A D.zero p.2 = p.2) :=
  ⟨fun fixed =>
    have level : D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2) = p.1 := congrArg Prod.fst fixed
    have given : A (D.sub p.1 H) p.2 = p.2 := congrArg Prod.snd fixed
    (D.total H p.1).elim
      (fun high =>
        have split : D.add (D.sub p.1 H) H = D.add (D.sub p.1 H) p.2 := by
          rw [D.add_comm (D.sub p.1 H) H, D.add_sub high, ← given, level]
        have same : p.2 = H := D.antisymm (add_cancel (Amounts.le_of_eq split.symm))
          (add_cancel (Amounts.le_of_eq split))
        Or.inl ⟨same, high, by have g := given; rw [same] at g; exact g⟩)
      (fun low =>
        have gone : D.sub p.1 H = D.zero := D.sub_zero low
        Or.inr ⟨low, by rw [gone, D.zero_add] at level; rw [gone] at given; rw [← level, given],
          by rw [gone] at given; exact given⟩),
   fun rest => rest.elim
    (fun ⟨same, high, gives⟩ => by
      show (D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2), A (D.sub p.1 H) p.2) = p
      rw [same, gives, D.add_comm, D.add_sub high, ← same])
    (fun ⟨low, same, gives⟩ => by
      show (D.add (D.sub p.1 H) (A (D.sub p.1 H) p.2), A (D.sub p.1 H) p.2) = p
      rw [D.sub_zero low, gives, D.zero_add]
      exact Prod.ext same.symm rfl)⟩

/-! ### Along a run -/

/-- A run whose step at `n` raises both raises both at every later step. -/
theorem rising_on {A : V → V → V} (rises : D.Rises A) (H : V) (s : V × V) {n : Nat}
    (up : D.Below ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1))) :
    ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k))
      ((Law.run (D.step A H) s).state (n + k + 1)) := fun k => by
  show D.Below (Law.orbit (D.step A H) s (n + k)) (Law.orbit (D.step A H) s (n + k + 1))
  rw [Law.orbit_add _ s n k, Nat.add_right_comm, Law.orbit_add _ s (n + 1) k]
  exact Lasting.orbit_mono (rel := D.Below) (fun _ _ b => step_mono rises H b) up k

/-- A run whose step at `n` lowers both lowers both at every later step. -/
theorem falling_on {A : V → V → V} (rises : D.Rises A) (H : V) (s : V × V) {n : Nat}
    (down : D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state n)) :
    ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k + 1))
      ((Law.run (D.step A H) s).state (n + k)) := fun k => by
  show D.Below (Law.orbit (D.step A H) s (n + k + 1)) (Law.orbit (D.step A H) s (n + k))
  rw [Law.orbit_add _ s n k, Nat.add_right_comm, Law.orbit_add _ s (n + 1) k]
  exact Lasting.orbit_mono (rel := D.Below) (fun _ _ b => step_mono rises H b) down k

/-- A run from a state within a band stays within it, in level and in recent giving. -/
theorem run_within {A : V → V → V} {H hi : V} (band : D.Band A H hi) {s : V × V}
    (high : D.le s.1 hi) (given : D.le s.2 hi) :
    ∀ n, D.le ((Law.run (D.step A H) s).state n).1 hi ∧ D.le ((Law.run (D.step A H) s).state n).2 hi
  | 0 => ⟨high, given⟩
  | n + 1 =>
    have ih := run_within band high given n
    have top := band _ _ ih.1 ih.2
    ⟨top, D.le_trans (given_le_level A H _) top⟩

/-- **The shape of a run in any amounts.** From the first step on, a step of the run that neither
raises nor lowers both the level and the recent giving climbs or sinks, and the step after a climb
(a sink) that neither raises nor lowers both climbs (sinks) too; a step that raises (lowers) both is
followed by such steps for ever. -/
theorem run_shape {A : V → V → V} (rises : D.Rises A) (H : V) (s : V × V) (n : Nat) :
    (¬ D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 2)) ((Law.run (D.step A H) s).state (n + 1)) →
      D.Climbs H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) ∨
      D.Sinks H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2))) ∧
    (D.Climbs H ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 2)) ((Law.run (D.step A H) s).state (n + 1)) →
      D.Climbs H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2))) ∧
    (D.Sinks H ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2)) →
      ¬ D.Below ((Law.run (D.step A H) s).state (n + 2)) ((Law.run (D.step A H) s).state (n + 1)) →
      D.Sinks H ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state (n + 2))) ∧
    (D.Below ((Law.run (D.step A H) s).state n) ((Law.run (D.step A H) s).state (n + 1)) →
      ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k))
        ((Law.run (D.step A H) s).state (n + k + 1))) ∧
    (D.Below ((Law.run (D.step A H) s).state (n + 1)) ((Law.run (D.step A H) s).state n) →
      ∀ k, D.Below ((Law.run (D.step A H) s).state (n + k + 1))
        ((Law.run (D.step A H) s).state (n + k))) :=
  ⟨climbs_or_sinks (p := Law.orbit (D.step A H) s (n + 1)) (given_le_level A H (Law.orbit (D.step A H) s n)),
   climbs_next (p := Law.orbit (D.step A H) s n), sinks_next (p := Law.orbit (D.step A H) s n),
   rising_on rises H s, falling_on rises H s⟩

/-- **A run rests exactly at a rest.** The run is still from step `T` exactly where its state there
is the regime's point or a state within the draw with level and recent giving equal that the
adjustment from nothing left gives again. -/
theorem still_iff {A : V → V → V} {H : V} {s : V × V} {T : Nat} :
    LastChange.StillFrom (Law.run (D.step A H) s) T ↔
      (((Law.run (D.step A H) s).state T).2 = H ∧ D.le H ((Law.run (D.step A H) s).state T).1 ∧
        A (D.sub ((Law.run (D.step A H) s).state T).1 H) H = H) ∨
      (D.le ((Law.run (D.step A H) s).state T).1 H ∧
        ((Law.run (D.step A H) s).state T).1 = ((Law.run (D.step A H) s).state T).2 ∧
        A D.zero ((Law.run (D.step A H) s).state T).2 = ((Law.run (D.step A H) s).state T).2) :=
  ⟨fun still => rest_iff.1 (still 0 : D.step A H (Law.orbit (D.step A H) s T) = _),
   fun rest k => by
    have fixed : D.step A H (Law.orbit (D.step A H) s T) = Law.orbit (D.step A H) s T := rest_iff.2 rest
    have stays : Law.orbit (D.step A H) (Law.orbit (D.step A H) s T) k = Law.orbit (D.step A H) s T :=
      (congrArg (Law.orbit (D.step A H) (Law.orbit (D.step A H) s T)) (Nat.one_mul k)).symm.trans
        (Law.orbit_mul (next := D.step A H) (s := Law.orbit (D.step A H) s T) (p := 1) fixed k)
    show D.step A H (Law.orbit (D.step A H) s (T + k)) = Law.orbit (D.step A H) s (T + k)
    rw [Law.orbit_add _ s T k, stays]
    exact fixed⟩

/-- **Whole numbers are an instance**, with the draw taking all but what it takes where it is within
the level, and everything where it is not. -/
def whole : Drawn Nat where
  toAmounts := Amounts.whole
  sub := (· - ·)
  add_sub := fun le => Becoming.add_sub_of_le le
  sub_zero := fun le => sub_eq_zero_of_le le
  total := Nat.le_total
  antisymm := Nat.le_antisymm

/-- In whole numbers the run of the adjusted step in amounts with a draw is the run of the adjusted
step, and its order and its rising adjustments are theirs. -/
theorem whole_run (A : Nat → Nat → Nat) (H : Nat) (s : Nat × Nat) :
    Law.run (whole.step A H) s = Law.run (Adjusted.step A H) s ∧
      (whole.Rises A ↔ Adjusted.Rises A) ∧ (∀ p q, whole.Below p q ↔ Adjusted.Below p q) :=
  ⟨rfl, Iff.rfl, fun _ _ => Iff.rfl⟩

end Drawn

/-! ## Coupled conditions: a margin that is not its own

The laws above give one condition its own giving law under its own draw. Two conditions can give
from what is left of both: each stands under its draw, taken first, as much as there is, and what each
gives back is a law of what the draws leave of the one and of the other (`Coupled.step`, in any
amounts with a draw). Where each one's giving rises with what is left of each, mutual support, the
coupled step keeps the order of states, so a condition ending from a state ends from every state
below it, and in whole numbers within a band its point of no return is a least level that falls as
its partner's level rises. A condition that gives nothing where its partner leaves nothing drains by
its draw once its partner has nothing left. -/

namespace Coupled

variable {V : Type} (D : Drawn V)

/-- What the draws `H₁` and `H₂` leave of each level. -/
def left (H₁ H₂ : V) (p : V × V) : V × V := (D.sub p.1 H₁, D.sub p.2 H₂)

/-- **One step of two coupled conditions.** The draws `H₁` and `H₂` take first, as much as there is;
each condition's next level is what is left of it with what it gives, `g₁` and `g₂` of what is left of
the first and of the second. -/
def step (g₁ g₂ : V → V → V) (H₁ H₂ : V) (p : V × V) : V × V :=
  (D.add (D.sub p.1 H₁) (g₁ (D.sub p.1 H₁) (D.sub p.2 H₂)),
   D.add (D.sub p.2 H₂) (g₂ (D.sub p.1 H₁) (D.sub p.2 H₂)))

/-- **A condition ends**: from some step on, the level `part` reads off the state is nothing. -/
def Ends (g₁ g₂ : V → V → V) (H₁ H₂ : V) (part : V × V → V) (s : V × V) : Prop :=
  ∃ N, ∀ k, part ((Law.run (step D g₁ g₂ H₁ H₂) s).state (N + k)) = D.zero

/-- The coupled step keeps every state with both levels within `hi` within `hi`. -/
def Band (g₁ g₂ : V → V → V) (H₁ H₂ hi : V) : Prop :=
  ∀ x y, D.le x hi → D.le y hi →
    D.le (step D g₁ g₂ H₁ H₂ (x, y)).1 hi ∧ D.le (step D g₁ g₂ H₁ H₂ (x, y)).2 hi

variable {D}

/-! ### A web of coupled conditions

Any number of conditions, indexed by any type `ι`: condition `i` stands under its draw `H i`, taken
first, as much as there is, and gives `G i` of what the draws leave of every condition. The laws of
order, ending and dependence are stated here once; the pair is the web indexed by `Bool`
(`Coupled.pair_run`), and its laws below are read off these. -/

namespace Indexed

variable {ι : Type}
variable (D)

/-- What the draws `H` leave of each level. -/
def left (H : ι → V) (x : ι → V) : ι → V := fun i => D.sub (x i) (H i)

/-- **One step of a web of coupled conditions.** Each draw takes first, as much as there is; each
condition's next level is what is left of it with what it gives, `G i` of what is left of all. -/
def step (G : ι → (ι → V) → V) (H : ι → V) (x : ι → V) : ι → V :=
  fun i => D.add (D.sub (x i) (H i)) (G i (left D H x))

/-- One state at or below another, condition by condition. -/
def Below (x y : ι → V) : Prop := ∀ i, D.le (x i) (y i)

/-- A condition's giving rises with what is left of each condition. -/
def Rises (g : (ι → V) → V) : Prop := ∀ e e', Below D e e' → D.le (g e) (g e')

/-- **A level ends**: from some step on, the level `part` reads off the state is nothing. -/
def Ends (G : ι → (ι → V) → V) (H : ι → V) (part : (ι → V) → V) (s : ι → V) : Prop :=
  ∃ N, ∀ k, part ((Law.run (step D G H) s).state (N + k)) = D.zero

/-- **Dependence**: condition `i` gives nothing wherever nothing is left of condition `j`. -/
def DependsOn (G : ι → (ι → V) → V) (i j : ι) : Prop := ∀ e : ι → V, e j = D.zero → G i e = D.zero

/-- **A chain of dependence**: `i` is `k`, or depends on a condition that is downstream of `k`. -/
inductive Downstream (G : ι → (ι → V) → V) : ι → ι → Prop
  | refl (i : ι) : Downstream G i i
  | dep {i j k : ι} : DependsOn D G i j → Downstream G j k → Downstream G i k

variable {D}

/-- **Under mutual support the step of a web keeps the order of states.** Where every condition's
giving rises with what is left of each, a state at or below another, condition by condition, stays so
after a step. -/
theorem step_mono {G : ι → (ι → V) → V} (rises : ∀ i, Rises D (G i)) (H : ι → V) {x y : ι → V}
    (below : Below D x y) : Below D (step D G H x) (step D G H y) := fun i =>
  have lefts : Below D (left D H x) (left D H y) := fun j => Drawn.sub_mono (H j) (below j)
  D.le_trans (D.add_le_add_right _ (lefts i)) (Amounts.add_le_add_left _ (rises i _ _ lefts))

/-- Under mutual support, runs of a web from ordered states stay ordered at every step. -/
theorem run_below {G : ι → (ι → V) → V} (rises : ∀ i, Rises D (G i)) (H : ι → V) {x y : ι → V}
    (below : Below D x y) :
    ∀ n, Below D ((Law.run (step D G H) x).state n) ((Law.run (step D G H) y).state n) :=
  Lasting.orbit_mono (rel := Below D) (fun _ _ b => step_mono rises H b) below

/-- **Raising any level never ends what held.** Under mutual support, where a level read off the
state by a part that keeps the order ends from a state, it ends from every state at or below it,
condition by condition. -/
theorem ends_of_below {G : ι → (ι → V) → V} {H : ι → V} {part : (ι → V) → V}
    (rises : ∀ i, Rises D (G i)) (reads : ∀ x y, Below D x y → D.le (part x) (part y)) {x y : ι → V}
    (below : Below D x y) (ends : Ends D G H part y) : Ends D G H part x :=
  have ⟨N, gone⟩ := ends
  ⟨N, fun k => D.antisymm (D.le_trans (reads _ _ (run_below rises H below (N + k)))
    (Amounts.le_of_eq (gone k))) (D.zero_le _)⟩

/-- **A dependent condition drains once its partner has nothing left.** Where `i` gives nothing
wherever nothing is left of `j`, from a state whose level of `j` is within its draw, `i`'s next level
is what its draw leaves of it. -/
theorem drains {G : ι → (ι → V) → V} {H : ι → V} {i j : ι} (depends : DependsOn D G i j) {x : ι → V}
    (within : D.le (x j) (H j)) : step D G H x i = D.sub (x i) (H i) := by
  show D.add (D.sub (x i) (H i)) (G i (left D H x)) = D.sub (x i) (H i)
  rw [depends (left D H x) (D.sub_zero within : D.sub (x j) (H j) = D.zero)]
  exact Amounts.add_zero _

/-- **A dependent condition ends after its partner.** In whole numbers, where `i` gives nothing
wherever nothing is left of `j` and `j` stays within its draw from step `N` on, `i` falls by its draw
at every step from `N`; where that draw is positive it is nothing from step `N + y` on, `y` its level
at `N`. -/
theorem ends_after {G : ι → (ι → Nat) → Nat} {H : ι → Nat} {i j : ι} (depends : DependsOn Drawn.whole G i j)
    {s : ι → Nat} {N : Nat} (within : ∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) j ≤ H j) :
    (∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) i =
      (Law.run (step Drawn.whole G H) s).state N i - H i * k) ∧
    (0 < H i → ∀ k, (Law.run (step Drawn.whole G H) s).state
      (N + (Law.run (step Drawn.whole G H) s).state N i + k) i = 0) :=
  have falls : ∀ k, (Law.run (step Drawn.whole G H) s).state (N + k) i =
      (Law.run (step Drawn.whole G H) s).state N i - H i * k := fun k => by
    induction k with
    | zero => exact (congrArg ((Law.run (step Drawn.whole G H) s).state N i - ·) (Nat.mul_zero (H i))).symm
    | succ k ih =>
      exact (drains (D := Drawn.whole) (H := H) depends (within k)).trans
        ((congrArg (· - H i) ih).trans (Naturals.sub_sub _ _ _))
  ⟨falls, fun pos k =>
    (congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i) (Nat.add_assoc N _ k)).trans
    ((falls _).trans (Becoming.sub_eq_zero_of_le (Nat.le_trans (Nat.le_add_right _ k)
      (Nat.le_mul_of_pos_left _ pos))))⟩

/-- **The end of one ends what depends on it.** In whole numbers, where `i` gives nothing wherever
nothing is left of `j` and `i`'s draw is positive, wherever `j` ends `i` ends. -/
theorem ends_of_partner {G : ι → (ι → Nat) → Nat} {H : ι → Nat} {i j : ι}
    (depends : DependsOn Drawn.whole G i j) (pos : 0 < H i) {s : ι → Nat}
    (ends : Ends Drawn.whole G H (fun w => w j) s) : Ends Drawn.whole G H (fun w => w i) s :=
  have ⟨N, gone⟩ := ends
  ⟨_, (ends_after depends (N := N) fun k => Nat.le_trans (Nat.le_of_eq (gone k)) (Nat.zero_le (H j))).2 pos⟩

/-- **The cascade of ends.** In whole numbers, where every condition that depends on another has a
positive draw, wherever a condition ends every condition downstream of it, through any chain of
dependence, ends. -/
theorem ends_downstream {G : ι → (ι → Nat) → Nat} {H : ι → Nat}
    (pos : ∀ i j, DependsOn Drawn.whole G i j → 0 < H i) {s : ι → Nat} :
    ∀ {i k : ι}, Downstream Drawn.whole G i k → Ends Drawn.whole G H (fun w => w k) s →
      Ends Drawn.whole G H (fun w => w i) s
  | _, _, .refl _, ends => ends
  | _, _, .dep d chain, ends => ends_of_partner d (pos _ _ d) (ends_downstream pos chain ends)

/-- **A dependence cycle ends together.** In whole numbers, where every condition that depends on
another has a positive draw, two conditions each downstream of the other end together or not at all. -/
theorem ends_together {G : ι → (ι → Nat) → Nat} {H : ι → Nat}
    (pos : ∀ i j, DependsOn Drawn.whole G i j → 0 < H i) {s : ι → Nat} {i k : ι}
    (there : Downstream Drawn.whole G i k) (back : Downstream Drawn.whole G k i) :
    Ends Drawn.whole G H (fun w => w i) s ↔ Ends Drawn.whole G H (fun w => w k) s :=
  ⟨ends_downstream pos back, ends_downstream pos there⟩

namespace Chain

/-- Three conditions in a chain: the first gives nothing; the second gives one where at least one is
left of the first; the third gives one where at least one is left of the second; every other index
gives nothing. -/
def giving : Nat → (Nat → Nat) → Nat
  | 1, e => if 1 ≤ e 0 then 1 else 0
  | 2, e => if 1 ≤ e 1 then 1 else 0
  | _, _ => 0

/-- Each of the three starts at two, every other index at nothing. -/
def start (i : Nat) : Nat := if i ≤ 2 then 2 else 0

/-- Under any draws taking one from the first, the first falls by one at every step. -/
theorem first_falls (H : Nat → Nat) (one : H 0 = 1) :
    ∀ n, (Law.run (step Drawn.whole giving H) start).state n 0 = 2 - n
  | 0 => rfl
  | n + 1 => by
    show (Law.run (step Drawn.whole giving H) start).state n 0 - H 0 + 0 = 2 - (n + 1)
    rw [first_falls H one n, one]
    rfl

/-- **The cascade reaches past direct dependence.** Under draws of one, the third condition depends on
the second and the second on the first, but the third does not depend on the first; the first ends,
and so does the third. -/
theorem cascades :
    DependsOn Drawn.whole giving 2 1 ∧ DependsOn Drawn.whole giving 1 0 ∧
    ¬ DependsOn Drawn.whole giving 2 0 ∧
    Ends Drawn.whole giving (fun _ => 1) (fun w => w 0) start ∧
    Ends Drawn.whole giving (fun _ => 1) (fun w => w 2) start :=
  have d21 : DependsOn Drawn.whole giving 2 1 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have d10 : DependsOn Drawn.whole giving 1 0 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have first : Ends Drawn.whole giving (fun _ => 1) (fun w => w 0) start :=
    ⟨2, fun k => (first_falls _ rfl (2 + k)).trans (Becoming.sub_eq_zero_of_le (Nat.le_add_right 2 k))⟩
  ⟨d21, d10, fun d => absurd (d (fun i => if i = 1 then 1 else 0) rfl) (by decide), first,
   ends_downstream (fun _ _ _ => Nat.zero_lt_one) (.dep d21 (.dep d10 (.refl 0))) first⟩

/-- **A draw of nothing on the chain stops the cascade.** With no draw on the second condition, the
first still ends, and the third depends on the second and the second on the first, yet the third holds
at two at every step: the second never drains. -/
theorem stopped :
    Ends Drawn.whole giving (fun i => if i = 1 then 0 else 1) (fun w => w 0) start ∧
    Downstream Drawn.whole giving 2 0 ∧
    ∀ n, (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 2 = 2 := by
  have d21 : DependsOn Drawn.whole giving 2 1 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have d10 : DependsOn Drawn.whole giving 1 0 := fun e zero =>
    if_neg fun h => absurd (Nat.le_trans h (Nat.le_of_eq zero)) (by decide)
  have holds : ∀ n, 2 ≤ (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 1 ∧
      (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 2 = 2 := by
    intro n
    induction n with
    | zero => exact ⟨Nat.le_refl 2, rfl⟩
    | succ n ih =>
      have up : 1 ≤ (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 1 - 0 :=
        Nat.le_trans (Nat.le_succ 1) ih.1
      refine ⟨Nat.le_trans ih.1 (Nat.le_add_right _ _), ?_⟩
      show (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 2 - 1 +
          (if 1 ≤ (Law.run (step Drawn.whole giving fun i => if i = 1 then 0 else 1) start).state n 1 - 0
            then 1 else 0) = 2
      rw [ih.2, if_pos up]
  exact ⟨⟨2, fun k => (first_falls _ rfl (2 + k)).trans (Becoming.sub_eq_zero_of_le (Nat.le_add_right 2 k))⟩,
    .dep d21 (.dep d10 (.refl 0)), fun n => (holds n).2⟩

end Chain

end Indexed

/-- The pair as a web indexed by `Bool`: `true` the first condition, `false` the second. -/
def pairGiving (g₁ g₂ : V → V → V) : Bool → (Bool → V) → V :=
  fun b e => cond b (g₁ (e true) (e false)) (g₂ (e true) (e false))

/-- The pair's draws as a web's. -/
def pairDraw (H₁ H₂ : V) : Bool → V := fun b => cond b H₁ H₂

/-- A pair of levels as a web's state. -/
def ofPair (p : V × V) : Bool → V := fun b => cond b p.1 p.2

/-- **The pair is the web indexed by `Bool`.** At every step the web's run from a pair of levels has
the pair's run's levels. -/
theorem pair_run (g₁ g₂ : V → V → V) (H₁ H₂ : V) (s : V × V) :
    ∀ n, (Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true =
        ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).1 ∧
      (Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false =
        ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).2
  | 0 => ⟨rfl, rfl⟩
  | n + 1 =>
    have ih := pair_run g₁ g₂ H₁ H₂ s n
    ⟨by
      show D.add (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true) H₁)
          (g₁ (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true) H₁)
            (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) H₂)) = _
      rw [ih.1, ih.2]; rfl,
     by
      show D.add (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) H₂)
          (g₂ (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true) H₁)
            (D.sub ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) H₂)) = _
      rw [ih.1, ih.2]; rfl⟩

/-- A pair's level ends exactly where, the pair read as a web, it does. -/
theorem ends_pair {g₁ g₂ : V → V → V} {H₁ H₂ : V} {part : V × V → V} {s : V × V} :
    Ends D g₁ g₂ H₁ H₂ part s ↔
      Indexed.Ends D (pairGiving g₁ g₂) (pairDraw H₁ H₂) (fun w => part (w true, w false)) (ofPair s) :=
  have same : ∀ n, part ((Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n true,
      (Law.run (Indexed.step D (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state n false) =
      part ((Law.run (step D g₁ g₂ H₁ H₂) s).state n) := fun n =>
    congrArg part (congr (congrArg Prod.mk (pair_run g₁ g₂ H₁ H₂ s n).1) (pair_run g₁ g₂ H₁ H₂ s n).2)
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (same (N + k)).trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (same (N + k)).symm.trans (gone k)⟩⟩

/-- Under mutual support of the pair, the giving of the pair read as a web rises. -/
theorem pair_rises {g₁ g₂ : V → V → V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) :
    ∀ b, Indexed.Rises D (pairGiving g₁ g₂ b)
  | true => fun _ _ le => rises₁ _ _ _ _ (le true) (le false)
  | false => fun _ _ le => rises₂ _ _ _ _ (le true) (le false)

/-- **Under mutual support the coupled step keeps the order of states.** Where each condition's
giving rises with what is left of each, a state at or below another in both levels stays so after a
step: the web's law for the pair. -/
theorem step_mono {g₁ g₂ : V → V → V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (H₁ H₂ : V)
    {p q : V × V} (below : D.Below p q) : D.Below (step D g₁ g₂ H₁ H₂ p) (step D g₁ g₂ H₁ H₂ q) :=
  have web := Indexed.step_mono (pair_rises rises₁ rises₂) (pairDraw H₁ H₂) (x := ofPair p) (y := ofPair q)
    fun b => match b with
      | true => below.1
      | false => below.2
  ⟨web true, web false⟩

/-- Under mutual support, runs from ordered states stay ordered at every step. -/
theorem run_below {g₁ g₂ : V → V → V} (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (H₁ H₂ : V)
    {p q : V × V} (below : D.Below p q) :
    ∀ n, D.Below ((Law.run (step D g₁ g₂ H₁ H₂) p).state n) ((Law.run (step D g₁ g₂ H₁ H₂) q).state n) :=
  Lasting.orbit_mono (rel := D.Below) (fun _ _ b => step_mono rises₁ rises₂ H₁ H₂ b) below

/-- **Below a state from which a condition ends, it ends.** Under mutual support, where a condition
read off the state by a part that keeps the order of states ends from a state, it ends from every
state at or below it in both levels: the web's law for the pair. -/
theorem ends_of_below {g₁ g₂ : V → V → V} {H₁ H₂ : V} {part : V × V → V}
    (rises₁ : D.Rises g₁) (rises₂ : D.Rises g₂) (reads : ∀ p q, D.Below p q → D.le (part p) (part q))
    {p q : V × V} (below : D.Below p q) (ends : Ends D g₁ g₂ H₁ H₂ part q) :
    Ends D g₁ g₂ H₁ H₂ part p :=
  ends_pair.2 (Indexed.ends_of_below (pair_rises rises₁ rises₂)
    (fun _ _ b => reads _ _ ⟨b true, b false⟩) (x := ofPair p) (y := ofPair q)
    (fun b => match b with
      | true => below.1
      | false => below.2)
    (ends_pair.1 ends))

/-- **The roles exchanged.** Exchanging the two conditions, their draws and the arguments of their
giving exchanges the levels at every step of the run. -/
theorem run_swap (g₁ g₂ : V → V → V) (H₁ H₂ : V) (s : V × V) :
    ∀ n, (Law.run (step D (fun a b => g₂ b a) (fun a b => g₁ b a) H₂ H₁) s.swap).state n =
      ((Law.run (step D g₁ g₂ H₁ H₂) s).state n).swap
  | 0 => rfl
  | n + 1 => congrArg (step D (fun a b => g₂ b a) (fun a b => g₁ b a) H₂ H₁) (run_swap g₁ g₂ H₁ H₂ s n)

/-- The second condition ends exactly where, the roles exchanged, the first does. -/
theorem ends_swap {g₁ g₂ : V → V → V} {H₁ H₂ : V} {s : V × V} :
    Ends D g₁ g₂ H₁ H₂ Prod.snd s ↔
      Ends D (fun a b => g₂ b a) (fun a b => g₁ b a) H₂ H₁ Prod.fst s.swap :=
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (congrArg Prod.fst (run_swap g₁ g₂ H₁ H₂ s (N + k))).trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (congrArg Prod.fst (run_swap g₁ g₂ H₁ H₂ s (N + k))).symm.trans (gone k)⟩⟩

/-- **A dependent condition drains once its partner has nothing left.** Where the second condition
gives nothing wherever nothing is left of the first, from a state whose first level is within its
draw the second's next level is what its draw leaves of it: the web's law for the pair. -/
theorem drains {g₁ g₂ : V → V → V} {H₁ H₂ : V} (depends : ∀ b, g₂ D.zero b = D.zero) {p : V × V}
    (within : D.le p.1 H₁) : (step D g₁ g₂ H₁ H₂ p).2 = D.sub p.2 H₂ :=
  Indexed.drains (G := pairGiving g₁ g₂) (H := pairDraw H₁ H₂) (i := false) (j := true)
    (fun e zero => (congrArg (fun z => g₂ z (e false)) zero).trans (depends _)) (x := ofPair p) within

/-- Giving that keeps the top of a band within it is within the draw. -/
theorem given_within {H hi a : V} (top : D.le (D.add (D.sub hi H) a) hi) : D.le a H :=
  (D.total H hi).elim
    (fun high => Drawn.add_cancel (a := D.sub hi H) (D.le_trans top
      (Amounts.le_of_eq ((D.add_comm (D.sub hi H) H).trans (D.add_sub high)).symm)))
    (fun low => D.le_trans (by rw [D.sub_zero low, D.zero_add] at top; exact top) low)

/-- Where a condition gives within its draw, what the draw leaves of it does not rise over a step. -/
theorem left_le {H e a : V} (within : D.le a H) : D.le (D.sub (D.add e a) H) e :=
  (D.total H (D.add e a)).elim
    (fun high => Drawn.add_cancel (a := H) (D.le_trans (Amounts.le_of_eq (D.add_sub high))
      (D.le_trans (Amounts.add_le_add_left e within) (Amounts.le_of_eq (D.add_comm e H)))))
    (fun low => by rw [D.sub_zero low]; exact D.zero_le e)


/-! ### Coupled webs in whole numbers: rest and points of no return

Stated condition by condition, a web's rest needs no equality of functions: under mutual support each
condition's giving respects what is left condition by condition, so states alike at every condition
step alike. For finitely many conditions, listed by a list covering them, a run within a band comes
to rest, each condition's ending is decided at one step, and each condition's point of no return,
given the other levels, is a least level that does not rise as any other rises. -/

namespace Indexed

variable {ι : Type} {G : ι → (ι → Nat) → Nat} {H : ι → Nat}

/-- The coupled step of a web keeps every state with every level within `hi` within `hi`. -/
def Band (G : ι → (ι → Nat) → Nat) (H : ι → Nat) (hi : Nat) : Prop :=
  ∀ x : ι → Nat, (∀ i, x i ≤ hi) → ∀ i, step Drawn.whole G H x i ≤ hi

/-- **Mutual support respects what is left condition by condition.** A giving that rises with what is
left of each condition gives alike from what is left alike at every condition. -/
theorem respects {g : (ι → Nat) → Nat} (rises : Rises Drawn.whole g) {e e' : ι → Nat}
    (same : ∀ j, e j = e' j) : g e = g e' :=
  Nat.le_antisymm (rises e e' fun j => Nat.le_of_eq (same j))
    (rises e' e fun j => Nat.le_of_eq (same j).symm)

/-- **Each giving reads what is left condition by condition**: what is left alike at every condition
gives alike. -/
def Pointwise (G : ι → (ι → Nat) → Nat) : Prop := ∀ i e e', (∀ j, e j = e' j) → G i e = G i e'

/-- Mutual support reads what is left condition by condition. -/
theorem pointwise_of_rises (rises : ∀ i, Rises Drawn.whole (G i)) : Pointwise G :=
  fun i _ _ same => respects (rises i) same

/-- Where each giving reads what is left condition by condition, states whose draws leave alike at
every condition step alike. -/
theorem step_alike (pointwise : Pointwise G) {x y : ι → Nat}
    (same : ∀ j, x j - H j = y j - H j) (i : ι) :
    step Drawn.whole G H x i = step Drawn.whole G H y i :=
  show x i - H i + G i (left Drawn.whole H x) = y i - H i + G i (left Drawn.whole H y) from
    congr (congrArg (· + ·) (same i)) (pointwise i _ _ same)

/-- **A law of states reads them condition by condition**: states alike at every condition go to states
alike at every condition. -/
def ReadsPointwise (f : (ι → Nat) → (ι → Nat)) : Prop :=
  ∀ x y, (∀ j, x j = y j) → ∀ i, f x i = f y i

/-- Under a law reading states condition by condition, runs from states alike at every condition stay
alike at every condition. -/
theorem run_alike_of {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {x y : ι → Nat}
    (same : ∀ j, x j = y j) : ∀ n i, (Law.run f x).state n i = (Law.run f y).state n i
  | 0 => same
  | n + 1 => reads _ _ (run_alike_of reads same n)

/-- Where each giving reads what is left condition by condition, the web's step reads states so. -/
theorem pointwise_step (pointwise : Pointwise G) : ReadsPointwise (step Drawn.whole G H) :=
  fun _ _ same => step_alike pointwise fun j => congrArg (· - H j) (same j)

/-- Where each giving reads what is left condition by condition, runs from states alike at every
condition stay alike at every condition. -/
theorem run_alike (pointwise : Pointwise G) {x y : ι → Nat} (same : ∀ j, x j = y j) :
    ∀ n i, (Law.run (step Drawn.whole G H) x).state n i = (Law.run (step Drawn.whole G H) y).state n i :=
  run_alike_of (pointwise_step pointwise) same

/-- Where each giving reads what is left condition by condition, a condition ends from one of two
states alike at every condition exactly where it ends from the other. -/
theorem ends_alike (pointwise : Pointwise G) {x y : ι → Nat} (same : ∀ j, x j = y j)
    (i : ι) : Ends Drawn.whole G H (fun w => w i) x ↔ Ends Drawn.whole G H (fun w => w i) y :=
  ⟨fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike pointwise same (N + k) i).symm.trans (gone k)⟩,
   fun ⟨N, gone⟩ => ⟨N, fun k => (run_alike pointwise same (N + k) i).trans (gone k)⟩⟩

/-- The run from the state after one step is the run, one step on. -/
theorem run_shift (f : (ι → Nat) → (ι → Nat)) (s : ι → Nat) :
    ∀ m, (Law.run f (f s)).state m = (Law.run f s).state (m + 1)
  | 0 => rfl
  | m + 1 => congrArg f (run_shift f s m)

/-- **In a band, mutual support gives within each draw.** Where each condition's giving rises with
what is left of each and the step keeps a band up to `hi`, at every state in the band each condition
gives at most its draw. -/
theorem within_draw (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {x : ι → Nat} (high : ∀ i, x i ≤ hi) (i : ι) : G i (left Drawn.whole H x) ≤ H i :=
  Nat.le_trans (rises i _ _ fun j => Nat.sub_le_sub_right (high j) (H j))
    (given_within (D := Drawn.whole) (band (fun _ => hi) (fun _ => Nat.le_refl hi) i))

/-- A run from a state within a band stays within it. -/
theorem run_within {hi : Nat} (band : Band G H hi) {s : ι → Nat} (high : ∀ i, s i ≤ hi) :
    ∀ n i, (Law.run (step Drawn.whole G H) s).state n i ≤ hi
  | 0 => high
  | n + 1 => band _ (run_within band high n)

/-- **In a band under mutual support, what is left of each condition never rises along a run.** -/
theorem left_falls (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {s : ι → Nat} (high : ∀ i, s i ≤ hi) (n : Nat) (i : ι) :
    (Law.run (step Drawn.whole G H) s).state (n + 1) i - H i ≤
      (Law.run (step Drawn.whole G H) s).state n i - H i :=
  left_le (D := Drawn.whole) (within_draw rises band (run_within band high n) i)

/-- **A run is still once what is left of every condition repeats.** Under mutual support, where a
step of the run leaves what the draws leave of each condition as it was, the run is still, condition
by condition, from the next step on. -/
theorem still_of_left (rises : ∀ i, Rises Drawn.whole (G i)) {s : ι → Nat} {n : Nat}
    (same : ∀ j, (Law.run (step Drawn.whole G H) s).state (n + 1) j - H j =
      (Law.run (step Drawn.whole G H) s).state n j - H j) :
    ∀ k i, (Law.run (step Drawn.whole G H) s).state (n + 1 + k) i =
      (Law.run (step Drawn.whole G H) s).state (n + 1) i
  | 0, _ => rfl
  | k + 1, i => step_alike (pointwise_of_rises rises)
      (fun j => (congrArg (· - H j) (still_of_left rises same k j)).trans (same j)) i

/-- What the draws leave of the listed conditions, added. -/
def leftOver (H : ι → Nat) (x : ι → Nat) : List ι → Nat
  | [] => 0
  | i :: cs => (x i - H i) + leftOver H x cs

/-- What is left of every listed condition at most another's adds to at most the other's. -/
theorem leftOver_le {x y : ι → Nat} (below : ∀ i, x i - H i ≤ y i - H i) :
    ∀ cs, leftOver H x cs ≤ leftOver H y cs
  | [] => Nat.le_refl 0
  | i :: cs => Nat.add_le_add (below i) (leftOver_le below cs)

/-- At most, and short at a listed condition, adds to less. -/
theorem leftOver_lt {x y : ι → Nat} (below : ∀ i, x i - H i ≤ y i - H i) {j : ι}
    (apart : x j - H j ≠ y j - H j) : ∀ cs, j ∈ cs → leftOver H x cs < leftOver H y cs
  | _ :: cs, .head _ => Nat.add_lt_add_of_lt_of_le
      (match Nat.lt_or_ge (x j - H j) (y j - H j) with
        | .inl lt => lt
        | .inr ge => absurd (Nat.le_antisymm (below j) ge) apart) (leftOver_le below cs)
  | i :: cs, .tail _ mem => Nat.add_lt_add_of_le_of_lt (below i) (leftOver_lt below apart cs mem)

/-- Within a band, what is left of the listed conditions adds to at most their count times `hi`. -/
theorem leftOver_bound {x : ι → Nat} {hi : Nat} (high : ∀ i, x i ≤ hi) :
    ∀ cs : List ι, leftOver H x cs ≤ cs.length * hi
  | [] => Nat.zero_le _
  | i :: cs => Nat.le_trans
      (Nat.add_le_add (Nat.le_trans (Nat.sub_le (x i) (H i)) (high i)) (leftOver_bound high cs))
      (Nat.le_of_eq ((Nat.add_comm _ _).trans (Nat.succ_mul cs.length hi).symm))

/-- Whether what the draws leave of every listed condition is alike in two states. -/
def alikeOn (H : ι → Nat) (x y : ι → Nat) : List ι → Bool
  | [] => true
  | i :: cs => if x i - H i = y i - H i then alikeOn H x y cs else false

theorem alikeOn_true {x y : ι → Nat} :
    ∀ {cs : List ι}, alikeOn H x y cs = true → ∀ i, i ∈ cs → x i - H i = y i - H i
  | [], _, _, mem => nomatch mem
  | j :: cs, all, i, mem =>
    if h : x j - H j = y j - H j then
      have rest : alikeOn H x y cs = true := (if_pos h).symm.trans all
      match i, mem with
      | _, .head _ => h
      | i, .tail _ m => alikeOn_true rest i m
    else Bool.noConfusion ((if_neg h).symm.trans all)

theorem alikeOn_false {x y : ι → Nat} :
    ∀ {cs : List ι}, alikeOn H x y cs = false → ∃ i, i ∈ cs ∧ x i - H i ≠ y i - H i
  | [], differs => Bool.noConfusion differs
  | j :: _, differs =>
    if h : x j - H j = y j - H j then
      match alikeOn_false ((if_pos h).symm.trans differs) with
      | ⟨i, mem, apart⟩ => ⟨i, .tail _ mem, apart⟩
    else ⟨j, .head _, h⟩

/-- Within a band under mutual support, the run of a web of the listed conditions is still, condition
by condition, from some step at most one more than what the draws leave of them, added. The case of
rest by balance, decided (`Amounts.unmarked_within`): what the draws leave, added, never rises along
the run (`left_falls`), so with its fall recorded as what is taken it balances, and it falls by at
least one at each step that does not leave it alike at every listed condition (`leftOver_lt`). -/
theorem rests_by (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) :
    ∀ (d : Nat) (s : ι → Nat), (∀ i, s i ≤ hi) → leftOver H s cs ≤ d →
      ∃ N, N ≤ d + 1 ∧ ∀ k i, (Law.run (step Drawn.whole G H) s).state (N + k) i =
        (Law.run (step Drawn.whole G H) s).state N i :=
  fun _ s high fuel =>
    have falls : ∀ n, leftOver H ((Law.run (step Drawn.whole G H) s).state (n + 1)) cs ≤
        leftOver H ((Law.run (step Drawn.whole G H) s).state n) cs :=
      fun n => leftOver_le (fun i => left_falls rises band high n i) cs
    match Amounts.unmarked_within (q := fun n => leftOver H ((Law.run (step Drawn.whole G H) s).state n) cs)
        (x := fun n => leftOver H ((Law.run (step Drawn.whole G H) s).state n) cs -
          leftOver H ((Law.run (step Drawn.whole G H) s).state (n + 1)) cs) (y := fun _ => 0)
        (P := fun n => alikeOn H ((Law.run (step Drawn.whole G H) s).state (n + 1))
          ((Law.run (step Drawn.whole G H) s).state n) cs = false)
        (fun n => match Bool.eq_false_or_eq_true (alikeOn H ((Law.run (step Drawn.whole G H) s).state (n + 1))
            ((Law.run (step Drawn.whole G H) s).state n) cs) with
          | .inl alike => .inr fun differs => Bool.noConfusion (alike.symm.trans differs)
          | .inr differs => .inl differs)
        0 (fun n _ => (Naturals.add_sub_of_le (falls n)).trans (Nat.add_zero _).symm)
        (fun n _ differs => match alikeOn_false differs with
          | ⟨_, mem, apart⟩ => Nat.le_trans (Nat.le_of_eq (Nat.zero_add 1))
              (Naturals.le_sub_of_add_le (leftOver_lt (left_falls rises band high n) apart cs mem))) with
    | ⟨N, _, within, unmoved⟩ =>
      have alike : alikeOn H ((Law.run (step Drawn.whole G H) s).state (N + 1))
          ((Law.run (step Drawn.whole G H) s).state N) cs = true :=
        (Bool.eq_false_or_eq_true _).elim id fun differs => absurd differs unmoved
      ⟨N + 1, Nat.succ_le_succ (Nat.le_trans within (Nat.le_trans (Nat.le_of_eq (Nat.zero_add _)) fuel)),
        still_of_left (n := N) rises fun j => alikeOn_true alike j (covers j)⟩

/-- **Under mutual support within a band, a web's run comes to rest.** In whole numbers, where each
condition's giving rises with what is left of each and the step keeps a band up to `hi`, the run from
a state in the band is still, condition by condition, from some step at most the listed conditions'
count times `hi` with one. -/
theorem comes_to_rest (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {s : ι → Nat} (high : ∀ i, s i ≤ hi) :
    ∃ N, N ≤ cs.length * hi + 1 ∧ ∀ k i, (Law.run (step Drawn.whole G H) s).state (N + k) i =
      (Law.run (step Drawn.whole G H) s).state N i :=
  rests_by rises band covers (cs.length * hi) s high (leftOver_bound high cs)

/-- Within a band under mutual support, whether a condition ends is decided at step
`cs.length * hi + 1`. -/
theorem ends_iff (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {s : ι → Nat} (high : ∀ i, s i ≤ hi) (i : ι) :
    Ends Drawn.whole G H (fun x => x i) s ↔
      (Law.run (step Drawn.whole G H) s).state (cs.length * hi + 1) i = 0 :=
  match comes_to_rest rises band covers high with
  | ⟨N, le, still⟩ =>
    have atK : (Law.run (step Drawn.whole G H) s).state (cs.length * hi + 1) i =
        (Law.run (step Drawn.whole G H) s).state N i :=
      (congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i)
        (Becoming.add_sub_of_le le).symm).trans (still _ i)
    ⟨fun ⟨M, gone⟩ => atK.trans ((still M i).symm.trans
        ((congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i) (Nat.add_comm N M)).trans
          (gone N))),
     fun zero => ⟨cs.length * hi + 1, fun k =>
       ((congrArg (fun n => (Law.run (step Drawn.whole G H) s).state n i)
         ((congrArg (· + k) (Becoming.add_sub_of_le le).symm).trans
           (Nat.add_assoc N (cs.length * hi + 1 - N) k))).trans
         ((still _ i).trans atK.symm)).trans zero⟩⟩

/-- A state with condition `i`'s level set to `a`, every other as in `y`. -/
def setAt [DecidableEq ι] (y : ι → Nat) (i : ι) (a : Nat) : ι → Nat :=
  fun j => if j = i then a else y j

/-- Setting one level lower, the others alike, is at or below. -/
theorem setAt_below [DecidableEq ι] {y y' : ι → Nat} {i : ι} {a b : Nat} (le : a ≤ b)
    (others : ∀ j, y j ≤ y' j) : Below Drawn.whole (setAt y i a) (setAt y' i b) := fun j =>
  if h : j = i then by
    show (if j = i then a else y j) ≤ (if j = i then b else y' j)
    rw [if_pos h, if_pos h]
    exact le
  else by
    show (if j = i then a else y j) ≤ (if j = i then b else y' j)
    rw [if_neg h, if_neg h]
    exact others j

/-- Within a band, setting a level within it keeps the state within it. -/
theorem setAt_within [DecidableEq ι] {y : ι → Nat} {i : ι} {a hi : Nat} (high : a ≤ hi)
    (highs : ∀ j, y j ≤ hi) (j : ι) : setAt y i a j ≤ hi :=
  if h : j = i then by
    show (if j = i then a else y j) ≤ hi
    rw [if_pos h]
    exact high
  else by
    show (if j = i then a else y j) ≤ hi
    rw [if_neg h]
    exact highs j

/-- Whether condition `i`, from level `a` with the others as in `y`, is nothing at step `K`. -/
def ending [DecidableEq ι] (G : ι → (ι → Nat) → Nat) (H : ι → Nat) (K : Nat) (y : ι → Nat)
    (i : ι) (a : Nat) : Bool :=
  decide ((Law.run (step Drawn.whole G H) (setAt y i a)).state K i = 0)

/-- **Condition `i`'s point of no return, the others as in `y`.** The least level up to `hi + 1`
from which condition `i` is not nothing at step `cs.length * hi + 1`. -/
def threshold [DecidableEq ι] (G : ι → (ι → Nat) → Nat) (H : ι → Nat) (cs : List ι) (hi : Nat)
    (y : ι → Nat) (i : ι) : Nat :=
  leading (ending G H (cs.length * hi + 1) y i) (hi + 1)

/-- Within a band under mutual support, the check at step `cs.length * hi + 1` is exact for condition
`i` ending from a level up to `hi`, the others as in `y` within the band. -/
theorem ends_iff_ending [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y : ι → Nat} {i : ι} {a : Nat}
    (high : a ≤ hi) (highs : ∀ j, y j ≤ hi) :
    Ends Drawn.whole G H (fun x => x i) (setAt y i a) ↔ ending G H (cs.length * hi + 1) y i a = true :=
  (ends_iff rises band covers (setAt_within high highs) i).trans ⟨decide_eq_true, of_decide_eq_true⟩

/-- **The point of no return is exact.** Within a band under mutual support, condition `i` ends from
a level up to `hi`, the others as in `y` within the band, exactly where its level is below its
threshold: the law of exact thresholds (`leading_exact`) for ending. -/
theorem ends_iff_below [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y : ι → Nat} {i : ι} {a : Nat}
    (high : a ≤ hi) (highs : ∀ j, y j ≤ hi) :
    Ends Drawn.whole G H (fun x => x i) (setAt y i a) ↔ a < threshold G H cs hi y i :=
  leading_exact (P := fun a => Ends Drawn.whole G H (fun x => x i) (setAt y i a))
    (d := ending G H (cs.length * hi + 1) y i)
    (fun _ _ _ ends le =>
      ends_of_below rises (fun _ _ b => b i) (setAt_below le fun j => Nat.le_refl (y j)) ends)
    (fun _ high' => ends_iff_ending rises band covers high' highs) a high

/-- **The point of no return does not rise as any other level rises.** Within a band under mutual
support, others' levels at or above `y`'s, within the band, give condition `i` a threshold no
higher: the law of exact thresholds (`leading_falls`), ending with the others higher ending with them
lower. -/
theorem threshold_falls [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat}
    (band : Band G H hi) {cs : List ι} (covers : ∀ i, i ∈ cs) {y y' : ι → Nat} {i : ι}
    (le : ∀ j, y j ≤ y' j) (highs' : ∀ j, y' j ≤ hi) :
    threshold G H cs hi y' i ≤ threshold G H cs hi y i :=
  have highs : ∀ j, y j ≤ hi := fun j => Nat.le_trans (le j) (highs' j)
  leading_falls (P := fun a => Ends Drawn.whole G H (fun x => x i) (setAt y i a))
    (Q := fun a => Ends Drawn.whole G H (fun x => x i) (setAt y' i a))
    (fun _ high => ends_iff_ending rises band covers high highs)
    (fun _ high => ends_iff_ending rises band covers high highs')
    (fun a _ ends => ends_of_below rises (fun _ _ b => b i) (setAt_below (Nat.le_refl a) le) ends)

/-- **Every state in the band has its fate by the threshold.** Within a band under mutual support,
the run from condition `i` at a level up to `hi`, the others as in `y` within the band, is still from
some step at most `cs.length * hi + 1`, where condition `i` is nothing if its level is below its
threshold and something if not. -/
theorem fates [DecidableEq ι] (rises : ∀ i, Rises Drawn.whole (G i)) {hi : Nat} (band : Band G H hi)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {y : ι → Nat} {i : ι} {a : Nat} (high : a ≤ hi)
    (highs : ∀ j, y j ≤ hi) :
    ∃ N, N ≤ cs.length * hi + 1 ∧
      (∀ k j, (Law.run (step Drawn.whole G H) (setAt y i a)).state (N + k) j =
        (Law.run (step Drawn.whole G H) (setAt y i a)).state N j) ∧
      (a < threshold G H cs hi y i → (Law.run (step Drawn.whole G H) (setAt y i a)).state N i = 0) ∧
      (threshold G H cs hi y i ≤ a → 0 < (Law.run (step Drawn.whole G H) (setAt y i a)).state N i) :=
  match comes_to_rest rises band covers (setAt_within high highs) with
  | ⟨N, le, still⟩ =>
    have gone_iff : Ends Drawn.whole G H (fun x => x i) (setAt y i a) ↔
        (Law.run (step Drawn.whole G H) (setAt y i a)).state N i = 0 :=
      ⟨fun ⟨M, gone⟩ => (still M i).symm.trans
          ((congrArg (fun n => (Law.run (step Drawn.whole G H) (setAt y i a)).state n i)
            (Nat.add_comm N M)).trans (gone N)),
       fun zero => ⟨N, fun k => (still k i).trans zero⟩⟩
    ⟨N, le, still, fun lt => gone_iff.1 ((ends_iff_below rises band covers high highs).2 lt),
     fun ge => Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl _
       (Nat.lt_of_lt_of_le ((ends_iff_below rises band covers high highs).1 (gone_iff.2 zero)) ge)⟩

/-! #### Beyond a band: a bound on the run

Without a band, a web's run under mutual support need not rest (`Relay.cycles`). Where a run stays
within a bound, its states are among finitely many lists of levels, so by pigeonhole it comes back to
a state it was in, and from there it repeats. These laws are stated once for any law `f` of states
that reads them condition by condition (`ReadsPointwise`): the web's step is one
(`pointwise_step`), and a web with a recent giving another (`Recent.step`). Whether a condition ends
is then decided by a finite check, with no band and no order of states. Where the law keeps the order
of states (`KeepsBelow`), as the web's step does under mutual support (`step_keepsBelow`), it reads
condition by condition (`reads_of_keepsBelow`), and each condition's point of no return, given the
others, is exact wherever the run from the top of the levels considered stays within the bound, and
does not rise as any other level rises. -/

/-- The levels of the listed conditions, in order. -/
def levels (x : ι → Nat) : List ι → List Nat
  | [] => []
  | c :: cs => x c :: levels x cs

/-- Two states with the same listed levels are alike at every listed condition. -/
theorem levels_alike {x y : ι → Nat} :
    ∀ {cs : List ι}, levels x cs = levels y cs → ∀ i, i ∈ cs → x i = y i
  | [], _, _, mem => nomatch mem
  | _ :: _, same, _, .head _ => (List.cons.inj same).1
  | _ :: _, same, i, .tail _ mem => levels_alike (List.cons.inj same).2 i mem

/-- Each listed list with `a` put first. -/
def withFirst (a : Nat) : List (List Nat) → List (List Nat)
  | [] => []
  | l :: ls => (a :: l) :: withFirst a ls

/-- Each listed list with each of `0, …, b` put first. -/
def withFirstUpTo (ls : List (List Nat)) : Nat → List (List Nat)
  | 0 => withFirst 0 ls
  | b + 1 => withFirst (b + 1) ls ++ withFirstUpTo ls b

/-- **Every list of `k` levels, each at most `B`.** -/
def levelLists (B : Nat) : Nat → List (List Nat)
  | 0 => [[]]
  | k + 1 => withFirstUpTo (levelLists B k) B

theorem withFirst_length (a : Nat) : ∀ ls : List (List Nat), (withFirst a ls).length = ls.length
  | [] => rfl
  | _ :: ls => congrArg (· + 1) (withFirst_length a ls)

theorem withFirstUpTo_length (ls : List (List Nat)) :
    ∀ b, (withFirstUpTo ls b).length = (b + 1) * ls.length
  | 0 => (withFirst_length 0 ls).trans (Nat.one_mul _).symm
  | b + 1 => (ListTests.length_append _ _).trans
      ((congr (congrArg (· + ·) (withFirst_length (b + 1) ls)) (withFirstUpTo_length ls b)).trans
        ((Nat.add_comm _ _).trans (Nat.succ_mul (b + 1) ls.length).symm))

/-- There are `(B + 1) ^ k` lists of `k` levels each at most `B`. -/
theorem levelLists_length (B : Nat) : ∀ k, (levelLists B k).length = (B + 1) ^ k
  | 0 => rfl
  | k + 1 => (withFirstUpTo_length (levelLists B k) B).trans
      ((congrArg ((B + 1) * ·) (levelLists_length B k)).trans (Nat.mul_comm _ _))

theorem mem_withFirst {a : Nat} {l : List Nat} : ∀ {ls : List (List Nat)}, l ∈ ls → a :: l ∈ withFirst a ls
  | _ :: _, .head _ => .head _
  | _ :: _, .tail _ mem => .tail _ (mem_withFirst mem)

theorem mem_withFirstUpTo {l : List Nat} {ls : List (List Nat)} (mem : l ∈ ls) :
    ∀ {a : Nat} (b : Nat), a ≤ b → a :: l ∈ withFirstUpTo ls b
  | _, 0, le => Eq.subst (motive := fun v => v :: l ∈ withFirst 0 ls) (Nat.eq_zero_of_le_zero le).symm
      (mem_withFirst mem)
  | a, b + 1, le => (Nat.lt_or_ge a (b + 1)).elim
      (fun lt => List.mem_append_right _ (mem_withFirstUpTo mem b (Nat.le_of_lt_succ lt)))
      (fun ge => Eq.subst (motive := fun v => v :: l ∈ withFirstUpTo ls (b + 1))
        (Nat.le_antisymm ge le) (List.mem_append_left _ (mem_withFirst mem)))

/-- The levels of a state with every level at most `B` are among the lists of levels at most `B`. -/
theorem levels_mem {B : Nat} {x : ι → Nat} (high : ∀ i, x i ≤ B) :
    ∀ cs : List ι, levels x cs ∈ levelLists B cs.length
  | [] => .head _
  | c :: cs => mem_withFirstUpTo (levels_mem high cs) B (high c)

/-- **A condition ends under a law**: from some step on, its level is nothing. A web's `Ends` at a
condition is this for the web's step. -/
def EndsUnder (f : (ι → Nat) → (ι → Nat)) (c : ι) (s : ι → Nat) : Prop :=
  ∃ N, ∀ k, (Law.run f s).state (N + k) c = 0

/-- **A law keeps the order of states**, condition by condition. -/
def KeepsBelow (f : (ι → Nat) → (ι → Nat)) : Prop :=
  ∀ x y, Below Drawn.whole x y → Below Drawn.whole (f x) (f y)

/-- Under mutual support the web's step keeps the order of states. -/
theorem step_keepsBelow (rises : ∀ i, Rises Drawn.whole (G i)) : KeepsBelow (step Drawn.whole G H) :=
  fun _ _ below => step_mono rises H below

/-- **A law keeping the order of states reads them condition by condition**, by antisymmetry. -/
theorem reads_of_keepsBelow {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) : ReadsPointwise f :=
  fun _ _ same i => Nat.le_antisymm (keeps _ _ (fun j => Nat.le_of_eq (same j)) i)
    (keeps _ _ (fun j => Nat.le_of_eq (same j).symm) i)

/-- Runs of a law keeping the order keep it at every step. -/
theorem run_below_of {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) {x y : ι → Nat}
    (below : Below Drawn.whole x y) :
    ∀ n, Below Drawn.whole ((Law.run f x).state n) ((Law.run f y).state n) :=
  Lasting.orbit_mono (rel := Below Drawn.whole) keeps below

/-- Under a law keeping the order, a condition ending from a state ends from every state below it. -/
theorem endsUnder_of_below {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) {c : ι} {x y : ι → Nat}
    (below : Below Drawn.whole x y) (ends : EndsUnder f c y) : EndsUnder f c x :=
  match ends with
  | ⟨N, gone⟩ => ⟨N, fun k => Nat.le_antisymm (Nat.le_trans (run_below_of keeps below (N + k) c)
      (Nat.le_of_eq (gone k))) (Nat.zero_le _)⟩

/-- **A run that reaches a state its law leaves as it is stays there**, condition by condition. -/
theorem stays_at {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {s p : ι → Nat} {m : Nat}
    (at_ : ∀ c, (Law.run f s).state m c = p c) (fixed : ∀ c, f p c = p c) :
    ∀ k c, (Law.run f s).state (m + k) c = p c
  | 0, c => at_ c
  | k + 1, c => (reads _ _ (stays_at reads at_ fixed k) c).trans (fixed c)

/-- **The run from `s` stays within `B`**: every level at every step is at most `B`. -/
def StaysWithin (f : (ι → Nat) → (ι → Nat)) (B : Nat) (s : ι → Nat) : Prop :=
  ∀ n i, (Law.run f s).state n i ≤ B

/-- Under a law keeping the order, below a run that stays within `B`, every run stays within it. -/
theorem within_below {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f) {B : Nat} {x y : ι → Nat}
    (below : Below Drawn.whole x y) (within : StaysWithin f B y) : StaysWithin f B x :=
  fun n i => Nat.le_trans (run_below_of keeps below n i) (within n i)

/-- **A run within a bound comes back.** For finitely many conditions, listed by `cs`, a run that stays
within `B` is, at some step `j` at most `(B + 1) ^ cs.length`, at every condition as it was at an
earlier step `i`. -/
theorem returns_within {f : (ι → Nat) → (ι → Nat)} {cs : List ι} (covers : ∀ i, i ∈ cs) {B : Nat}
    {s : ι → Nat} (within : StaysWithin f B s) :
    ∃ i j, i < j ∧ j ≤ (B + 1) ^ cs.length ∧ ∀ c,
      (Law.run f s).state i c = (Law.run f s).state j c :=
  match revisits_within (levelLists B cs.length)
      (fun n => levels ((Law.run f s).state n) cs)
      (fun n _ => levels_mem (within n) cs) with
  | ⟨i, j, lt, le, same⟩ => ⟨i, j, lt, Nat.le_trans le (Nat.le_of_eq (levelLists_length B cs.length)),
      fun c => levels_alike same c (covers c)⟩

/-- **A run that comes back repeats.** Where the law reads states condition by condition and the run is
at step `j` as it was at step `i`, condition by condition, it is at step `i + m` as at step `j + m`, for
every `m`. -/
theorem repeats {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {s : ι → Nat} {i j : Nat}
    (same : ∀ c, (Law.run f s).state i c = (Law.run f s).state j c) :
    ∀ m c, (Law.run f s).state (i + m) c =
      (Law.run f s).state (j + m) c := fun m c =>
  (congrArg (· c) (Law.orbit_add f s i m)).trans
    ((run_alike_of reads same m c).trans (congrArg (· c) (Law.orbit_add f s j m)).symm)

/-- A sequence repeating with period `p` from step `i` repeats with every multiple of `p`. -/
theorem repeats_mul {f : Nat → Nat} {i p : Nat} (period : ∀ t, i ≤ t → f t = f (t + p)) :
    ∀ q t, i ≤ t → f t = f (t + p * q)
  | 0, _, _ => rfl
  | q + 1, t, le => (repeats_mul period q t le).trans
      ((period (t + p * q) (Nat.le_trans le (Nat.le_add_right t _))).trans
        (congrArg f (Nat.add_assoc t (p * q) p)))

/-- A sequence repeating with a positive period `p` from step `i`, at most `L` with `p` at most `L + 1`,
is nothing from step `L` on wherever it is nothing at every step from `L` to `2 L`. -/
theorem zero_from_window {f : Nat → Nat} {i p L : Nat} (period : ∀ t, i ≤ t → f t = f (t + p))
    (pos : 0 < p) (start : i ≤ L) (short : p ≤ L + 1) (window : ∀ m, m ≤ L → f (L + m) = 0) :
    ∀ fuel m, m ≤ fuel → f (L + m) = 0
  | 0, m, le => window m (Nat.le_trans le (Nat.zero_le L))
  | fuel + 1, m, le => (Nat.lt_or_ge L m).elim
      (fun big =>
        have pm : p ≤ m := Nat.le_trans short big
        have back : L + (m - p) + p = L + m :=
          (Nat.add_assoc L (m - p) p).trans (congrArg (L + ·) (Naturals.sub_add_cancel pm))
        have fewer : m - p ≤ fuel :=
          Nat.le_trans (Optimum.sub_le_sub_left_of_le pos m) (Nat.sub_le_sub_right le 1)
        (congrArg f back).symm.trans
          ((period (L + (m - p)) (Nat.le_trans start (Nat.le_add_right L _))).symm.trans
            (zero_from_window period pos start short window fuel (m - p) fewer)))
      (fun small => window m small)

/-- **Whether a condition ends is decided within the count of states.** For finitely many conditions,
listed by `cs`, where the law reads states condition by condition and the run stays within `B`,
condition `c` ends exactly where it is nothing at every step from `L` to `2 L`, `L` being
`(B + 1) ^ cs.length`, the number of lists of levels within `B`; and where it ends it is nothing from
step `L` on. No band, no order of states and no omniscience is needed. -/
theorem ends_iff_within {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f) {cs : List ι}
    (covers : ∀ i, i ∈ cs) {B : Nat} {s : ι → Nat} (within : StaysWithin f B s) (c : ι) :
    (EndsUnder f c s ↔ ∀ m, m ≤ (B + 1) ^ cs.length →
      (Law.run f s).state ((B + 1) ^ cs.length + m) c = 0) ∧
    (EndsUnder f c s → ∀ k,
      (Law.run f s).state ((B + 1) ^ cs.length + k) c = 0) :=
  match returns_within covers within with
  | ⟨i, j, lt, le, same⟩ =>
    have jpi : i + (j - i) = j := Becoming.add_sub_of_le (Nat.le_of_lt lt)
    have period : ∀ t, i ≤ t → (Law.run f s).state t c =
        (Law.run f s).state (t + (j - i)) c := fun t le =>
      have tt : i + (t - i) = t := Becoming.add_sub_of_le le
      (congrArg (fun n => (Law.run f s).state n c) tt).symm.trans
        ((repeats reads same (t - i) c).trans
          (congrArg (fun n => (Law.run f s).state n c)
            (((congrArg (· + (t - i)) jpi).symm.trans (Nat.add_right_comm i (j - i) (t - i))).trans
              (congrArg (· + (j - i)) tt))))
    have pos : 0 < j - i := SupportGated.sub_pos_of_lt lt
    have start : i ≤ (B + 1) ^ cs.length := Nat.le_trans (Nat.le_of_lt lt) le
    have short : j - i ≤ (B + 1) ^ cs.length + 1 :=
      Nat.le_trans (Nat.sub_le j i) (Nat.le_trans le (Nat.le_succ _))
    have toWindow : EndsUnder f c s → ∀ m, m ≤ (B + 1) ^ cs.length →
        (Law.run f s).state ((B + 1) ^ cs.length + m) c = 0 :=
      fun ⟨N, gone⟩ m _ =>
        have far : N ≤ (B + 1) ^ cs.length + m + (j - i) * N :=
          Nat.le_trans (Nat.le_of_eq (Nat.one_mul N).symm)
            (Nat.le_trans (Nat.mul_le_mul_right N pos) (Nat.le_add_left _ _))
        (repeats_mul period N _ (Nat.le_trans start (Nat.le_add_right _ m))).trans
          ((congrArg (fun n => (Law.run f s).state n c)
            (Becoming.add_sub_of_le far).symm).trans (gone _))
    have fromWindow : (∀ m, m ≤ (B + 1) ^ cs.length →
        (Law.run f s).state ((B + 1) ^ cs.length + m) c = 0) → ∀ k,
        (Law.run f s).state ((B + 1) ^ cs.length + k) c = 0 :=
      fun window k => zero_from_window period pos start short window k k (Nat.le_refl k)
    ⟨⟨toWindow, fun window => ⟨(B + 1) ^ cs.length, fromWindow window⟩⟩,
     fun ends => fromWindow (toWindow ends)⟩

/-- The levels below `n` all pass the check `f`, where each does. -/
theorem below_of {f : Nat → Bool} : ∀ {n}, (∀ z, z < n → f z = true) → below f n = true
  | 0, _ => rfl
  | n + 1, all => by
    show (f n && below f n) = true
    rw [all n (Nat.lt_succ_self n)]
    exact below_of fun z lt => all z (Nat.lt_succ_of_lt lt)

/-- Whether condition `i`, from level `a` with the others as in `y`, is nothing at every step from `L`
to `2 L`. -/
def endingWithin [DecidableEq ι] (f : (ι → Nat) → (ι → Nat)) (L : Nat) (y : ι → Nat) (i : ι)
    (a : Nat) : Bool :=
  below (fun m => decide ((Law.run f (setAt y i a)).state (L + m) i = 0)) (L + 1)

/-- **Condition `i`'s point of no return beyond a band, the others as in `y`.** The least level up to
`hi + 1` from which condition `i` is not nothing at every step from `L` to `2 L`, `L` the number of
lists of levels within `B`. -/
def thresholdWithin [DecidableEq ι] (f : (ι → Nat) → (ι → Nat)) (cs : List ι) (B hi : Nat)
    (y : ι → Nat) (i : ι) : Nat :=
  leading (endingWithin f ((B + 1) ^ cs.length) y i) (hi + 1)

/-- Within a bound, the finite check says whether a condition ends. -/
theorem ending_iff [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (reads : ReadsPointwise f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B : Nat} {y : ι → Nat} {i : ι} {a : Nat}
    (within : StaysWithin f B (setAt y i a)) :
    EndsUnder f i (setAt y i a) ↔ endingWithin f ((B + 1) ^ cs.length) y i a = true :=
  (ends_iff_within reads covers within i).1.trans
    ⟨fun zero => below_of fun m lt => decide_eq_true (zero m (Nat.le_of_lt_succ lt)),
     fun check m le => of_decide_eq_true (below_spec check m (Nat.lt_succ_of_le le))⟩

/-- **The point of no return is exact beyond a band.** Under a law keeping the order of states, for
finitely many conditions, where the run from condition `i` at `hi`, the others as in `y`, stays within
`B`, condition `i` ends from a level up to `hi` exactly where its level is below `thresholdWithin`:
the law of exact thresholds (`leading_exact`) for the finite check. -/
theorem ends_iff_below_within [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B hi : Nat} {y : ι → Nat} {i : ι} {a : Nat}
    (within : StaysWithin f B (setAt y i hi)) (high : a ≤ hi) :
    EndsUnder f i (setAt y i a) ↔ a < thresholdWithin f cs B hi y i :=
  leading_exact (P := fun a => EndsUnder f i (setAt y i a)) (d := endingWithin f ((B + 1) ^ cs.length) y i)
    (fun _ _ _ ends le => endsUnder_of_below keeps (setAt_below le fun j => Nat.le_refl (y j)) ends)
    (fun _ high' => ending_iff (reads_of_keepsBelow keeps) covers
      (within_below keeps (setAt_below high' fun j => Nat.le_refl (y j)) within)) a high

/-- **Beyond a band, the point of no return does not rise as any other level rises.** Under a law
keeping the order of states, where the run from condition `i` at `hi`, the others as in `y'`, stays
within `B`, others' levels at or below `y'` give condition `i` a threshold no lower than `y'` gives:
the law of exact thresholds (`leading_falls`) for the finite check. -/
theorem threshold_falls_within [DecidableEq ι] {f : (ι → Nat) → (ι → Nat)} (keeps : KeepsBelow f)
    {cs : List ι} (covers : ∀ i, i ∈ cs) {B hi : Nat} {y y' : ι → Nat} {i : ι} (le : ∀ j, y j ≤ y' j)
    (within' : StaysWithin f B (setAt y' i hi)) :
    thresholdWithin f cs B hi y' i ≤ thresholdWithin f cs B hi y i :=
  leading_falls (P := fun a => EndsUnder f i (setAt y i a)) (Q := fun a => EndsUnder f i (setAt y' i a))
    (fun _ high => ending_iff (reads_of_keepsBelow keeps) covers
      (within_below keeps (setAt_below high le) within'))
    (fun _ high => ending_iff (reads_of_keepsBelow keeps) covers
      (within_below keeps (setAt_below high fun j => Nat.le_refl (y' j)) within'))
    (fun a _ ends => endsUnder_of_below keeps (setAt_below (Nat.le_refl a) le) ends)

/-! #### Webs with a recent giving

Each condition's state is its level and what it gave last; what it gives is a law of what is left of
every condition and of what each gave last. The step reads states condition by condition, and where
each giving rises with what is left and with what was given it keeps the order of states, so the
bounded laws above hold: ending decided by a finite check, and each condition's point of no return,
given the other levels and every recent giving, exact and not rising as any of them rises. The web
whose giving reads nothing of what was given runs as the plain web (`Recent.plain`), and one
condition is the adjusted regime (`Recent.adjusted`). -/

namespace Recent

/-- **One step of a web with a recent giving.** The state holds each condition's level at `(i, true)`
and what it gave last at `(i, false)`. Each draw takes first, as much as there is; condition `i` gives
`G i` of what is left of every condition and of what each gave last; its next level is what is left
of it with what it gives, and what it gives is its next recent giving. -/
def step (G : ι → (ι → Nat) → (ι → Nat) → Nat) (H : ι → Nat) (x : ι × Bool → Nat) : ι × Bool → Nat
  | (i, true) => (x (i, true) - H i) + G i (fun j => x (j, true) - H j) (fun j => x (j, false))
  | (i, false) => G i (fun j => x (j, true) - H j) (fun j => x (j, false))

/-- Each giving rises with what is left of each condition and with what each gave last. -/
def Rises (G : ι → (ι → Nat) → (ι → Nat) → Nat) : Prop :=
  ∀ i e e' r r', (∀ j, e j ≤ e' j) → (∀ j, r j ≤ r' j) → G i e r ≤ G i e' r'

/-- **Under mutual support a web with a recent giving keeps the order of states.** -/
theorem keepsBelow {G : ι → (ι → Nat) → (ι → Nat) → Nat} {H : ι → Nat} (rises : Rises G) :
    KeepsBelow (step G H) := fun _ _ below p =>
  match p with
  | (i, true) => Nat.add_le_add (Nat.sub_le_sub_right (below (i, true)) (H i))
      (rises i _ _ _ _ (fun j => Nat.sub_le_sub_right (below (j, true)) (H j)) (fun j => below (j, false)))
  | (i, false) => rises i _ _ _ _ (fun j => Nat.sub_le_sub_right (below (j, true)) (H j))
      (fun j => below (j, false))

/-- Both parts of every listed condition. -/
def both : List ι → List (ι × Bool)
  | [] => []
  | i :: cs => (i, true) :: (i, false) :: both cs

/-- Both parts of a listed condition are listed. -/
theorem mem_both {i : ι} : ∀ {cs : List ι}, i ∈ cs → ∀ b, (i, b) ∈ both cs
  | _ :: _, .head _, true => .head _
  | _ :: _, .head _, false => .tail _ (.head _)
  | _ :: _, .tail _ mem, b => .tail _ (.tail _ (mem_both mem b))

/-- Where a list covers the conditions, `both` of it covers their parts. -/
theorem covers_both {cs : List ι} (covers : ∀ i, i ∈ cs) : ∀ p : ι × Bool, p ∈ both cs
  | (i, b) => mem_both (covers i) b

/-- **Where giving reads nothing of what was given, the levels run as the plain web's.** Each level of a
web with a recent giving whose giving is `G'` of what is left alone is, at every step, the level of
the plain web's run from the same levels. -/
theorem plain {G' : ι → (ι → Nat) → Nat} {H : ι → Nat} (pointwise : Indexed.Pointwise G')
    (x : ι × Bool → Nat) : ∀ n i, (Law.run (step (fun i e _ => G' i e) H) x).state n (i, true) =
      (Law.run (Indexed.step Drawn.whole G' H) (fun j => x (j, true))).state n i
  | 0, _ => rfl
  | n + 1, i => congr (congrArg (· + ·) (congrArg (· - H i) (plain pointwise x n i)))
      (pointwise i _ _ fun j => congrArg (· - H j) (plain pointwise x n j))

/-- A state of the adjusted regime, its level and recent giving, read as one condition's. -/
def ofAdjusted (p : Nat × Nat) : Unit × Bool → Nat
  | (_, true) => p.1
  | (_, false) => p.2

/-- **One condition with a recent giving is the adjusted regime.** -/
theorem adjusted (A : Nat → Nat → Nat) (H : Nat) (p : Nat × Nat) :
    ∀ n, (Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) =
        ((Law.run (Adjusted.step A H) p).state n).1 ∧
      (Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), false) =
        ((Law.run (Adjusted.step A H) p).state n).2
  | 0 => ⟨rfl, rfl⟩
  | n + 1 =>
    have ih := adjusted A H p n
    ⟨by
      show (Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) - H +
          A ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) - H)
            ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), false)) = _
      rw [ih.1, ih.2]; try rfl,
     by
      show A ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), true) - H)
            ((Law.run (step (fun _ e r => A (e ()) (r ())) (fun _ => H)) (ofAdjusted p)).state n ((), false)) = _
      rw [ih.1, ih.2]; try rfl⟩

/-! ##### A giving that ramps with what was given -/

namespace Momentum

/-- Nothing where nothing is left; where something is, one where nothing was given last and two where
something was. -/
def gives (e r : Nat) : Nat := if 1 ≤ e then (if 1 ≤ r then 2 else 1) else 0

/-- The ramping giving of one condition. -/
def giving : Unit → (Unit → Nat) → (Unit → Nat) → Nat := fun _ e r => gives (e ()) (r ())

theorem gives_rises {e e' r r' : Nat} (le : e ≤ e') (le' : r ≤ r') : gives e r ≤ gives e' r' :=
  if h : 1 ≤ e then
    have h' : 1 ≤ e' := Nat.le_trans h le
    if g : 1 ≤ r then Nat.le_of_eq ((if_pos h).trans ((if_pos g).trans
        ((if_pos (Nat.le_trans g le')).symm.trans (if_pos h').symm)))
    else
      Nat.le_trans (Nat.le_of_eq ((if_pos h).trans (if_neg g)))
        (if g' : 1 ≤ r' then Nat.le_trans (Nat.le_succ 1) (Nat.le_of_eq ((if_pos g').symm.trans (if_pos h').symm))
         else Nat.le_of_eq ((if_neg g').symm.trans (if_pos h').symm))
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem rises : Rises giving := fun _ _ _ _ _ le le' => gives_rises (le ()) (le' ())

/-- The state of one condition at level `a` having given `r` last. -/
def at_ (a r : Nat) : Unit × Bool → Nat
  | (_, true) => a
  | (_, false) => r

/-- The ramping step under a draw of two. -/
def ramp : (Unit × Bool → Nat) → (Unit × Bool → Nat) := step giving (fun _ => 2)

theorem set_at (a r : Nat) : ∀ p, Indexed.setAt (at_ 0 r) ((), true) a p = at_ a r p
  | ((), true) => rfl
  | ((), false) => rfl

theorem ends_from {a r : Nat} {m : Nat} (at_m : ∀ p, (Law.run ramp (at_ a r)).state m p = at_ 0 0 p) :
    EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 r) ((), true) a) :=
  ⟨m, fun k => (run_alike_of (reads_of_keepsBelow (keepsBelow rises)) (set_at a r) (m + k) ((), true)).trans
    (stays_at (reads_of_keepsBelow (keepsBelow rises)) at_m
      (fun p => match p with
        | ((), true) => rfl
        | ((), false) => rfl) k ((), true))⟩

theorem holds_from {a r b c : Nat} {m : Nat} (pos : 0 < b)
    (at_m : ∀ p, (Law.run ramp (at_ a r)).state m p = at_ b c p) (fixed : ∀ p, ramp (at_ b c) p = at_ b c p) :
    ¬ EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 r) ((), true) a) := fun ⟨N, gone⟩ =>
  have reads := reads_of_keepsBelow (keepsBelow rises)
  Nat.ne_of_gt pos ((((gone m).symm.trans (run_alike_of reads (set_at a r) (N + m) ((), true))).trans
    ((congrArg (fun n => (Law.run ramp (at_ a r)).state n ((), true)) (Nat.add_comm N m)).trans
      (stays_at reads at_m fixed N ((), true)))).symm)

/-- **What a condition gave last lowers its point of no return.** One condition, drawn by two, gives
one where something is left and nothing was given last, and two where something was. From four having
given one, its run stays within four. Having given nothing, it ends from three and holds from four, so
its threshold, levels up to four, is four; having given one, it ends from two and holds from three, so
its threshold is three. -/
theorem threshold_falls_with_recent :
    StaysWithin ramp 4 (Indexed.setAt (at_ 0 1) ((), true) 4) ∧
    thresholdWithin ramp (both [()]) 4 4 (at_ 0 0) ((), true) = 4 ∧
    thresholdWithin ramp (both [()]) 4 4 (at_ 0 1) ((), true) = 3 :=
  have keeps : KeepsBelow ramp := keepsBelow rises
  have reads := reads_of_keepsBelow keeps
  have covers : ∀ p : Unit × Bool, p ∈ both [()] := covers_both fun _ => .head _
  have fixed₄ : ∀ p, ramp (at_ 4 2) p = at_ 4 2 p := fun p => match p with
    | ((), true) => rfl
    | ((), false) => rfl
  have within₁ : StaysWithin ramp 4 (Indexed.setAt (at_ 0 1) ((), true) 4) := fun n p =>
    have at1 : ∀ p, (Law.run ramp (at_ 4 1)).state 1 p = at_ 4 2 p := fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl
    Nat.le_trans (Nat.le_of_eq (run_alike_of reads (set_at 4 1) n p)) (match n, p with
      | 0, ((), true) => Nat.le_refl 4
      | 0, ((), false) => Nat.le_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 1))
      | k + 1, ((), true) => Nat.le_of_eq ((congrArg (fun m => (Law.run ramp (at_ 4 1)).state m ((), true))
          (Nat.add_comm k 1)).trans (stays_at reads at1 fixed₄ k ((), true)))
      | k + 1, ((), false) => Nat.le_trans (Nat.le_of_eq ((congrArg (fun m => (Law.run ramp (at_ 4 1)).state m ((), false))
          (Nat.add_comm k 1)).trans (stays_at reads at1 fixed₄ k ((), false)))) (Nat.le_succ_of_le (Nat.le_succ 2)))
  have within₀ : StaysWithin ramp 4 (Indexed.setAt (at_ 0 0) ((), true) 4) :=
    within_below keeps (Indexed.setAt_below (Nat.le_refl 4) fun p => match p with
      | ((), true) => Nat.le_refl 0
      | ((), false) => Nat.zero_le 1) within₁
  have fixed₃ : ∀ p, ramp (at_ 3 2) p = at_ 3 2 p := fun p => match p with
    | ((), true) => rfl
    | ((), false) => rfl
  have ends₃ : EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 0) ((), true) 3) :=
    ends_from (m := 2) fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl
  have holds₄ : ¬ EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 0) ((), true) 4) :=
    holds_from (m := 2) (Nat.succ_pos 2) (fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl) fixed₃
  have ends₂ : EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 1) ((), true) 2) :=
    ends_from (m := 1) fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl
  have holds₃ : ¬ EndsUnder ramp ((), true) (Indexed.setAt (at_ 0 1) ((), true) 3) :=
    holds_from (m := 1) (Nat.succ_pos 2) (fun p => match p with
      | ((), true) => rfl
      | ((), false) => rfl) fixed₃
  ⟨within₁,
   Nat.le_antisymm
    ((Nat.lt_or_ge 4 (thresholdWithin ramp (both [()]) 4 4 (at_ 0 0) ((), true))).elim
      (fun lt => absurd ((ends_iff_below_within keeps covers within₀ (Nat.le_refl 4)).2 lt) holds₄) id)
    ((ends_iff_below_within keeps covers within₀ (Nat.le_succ 3)).1 ends₃),
   Nat.le_antisymm
    ((Nat.lt_or_ge 3 (thresholdWithin ramp (both [()]) 4 4 (at_ 0 1) ((), true))).elim
      (fun lt => absurd ((ends_iff_below_within keeps covers within₁ (Nat.le_succ 3)).2 lt) holds₃) id)
    ((ends_iff_below_within keeps covers within₁ (Nat.le_succ_of_le (Nat.le_succ 2))).1 ends₂)⟩

end Momentum

end Recent

end Indexed

/-! ### Coupled conditions in whole numbers -/

/-- Each of the two conditions is listed. -/
theorem covers_pair : ∀ b : Bool, b ∈ [true, false]
  | true => .head _
  | false => .tail _ (.head _)

/-- The two conditions counted, times `hi`, are `hi` twice. -/
theorem pair_count (hi : Nat) : [true, false].length * hi = hi + hi :=
  (Nat.succ_mul 1 hi).trans (congrArg (· + hi) (Nat.one_mul hi))

/-- The pair's band is the band of the pair read as a web. -/
theorem band_web {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) :
    Indexed.Band (pairGiving g₁ g₂) (pairDraw H₁ H₂) hi := fun w high b =>
  match b with
  | true => (band (w true) (w false) (high true) (high false)).1
  | false => (band (w true) (w false) (high true) (high false)).2

/-- Both levels of a pair within a band, read as a web's. -/
theorem pair_within {s : Nat × Nat} {hi : Nat} (high : s.1 ≤ hi) (high' : s.2 ≤ hi) :
    ∀ b, ofPair s b ≤ hi
  | true => high
  | false => high'

/-- **A pair is still where its web is.** Where the run of the pair read as a web is still at both
conditions from step `N`, the pair's run is still from `N`. -/
theorem pair_still {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} {s : Nat × Nat} {N : Nat}
    (still : ∀ k b, (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂))
        (ofPair s)).state (N + k) b =
      (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state N b) :
    LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s) N := fun k =>
  Prod.ext
    ((pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k + 1)).1.symm.trans ((still (k + 1) true).trans
      ((still k true).symm.trans (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k)).1)))
    ((pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k + 1)).2.symm.trans ((still (k + 1) false).trans
      ((still k false).symm.trans (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (N + k)).2)))

/-- Within a band under mutual support, the run from a state is still from some step at most one more
than what the draws leave of both, added: the web's law for the pair. -/
theorem rests_by {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) :
    ∀ (d : Nat) (s : Nat × Nat), s.1 ≤ hi → s.2 ≤ hi → (s.1 - H₁) + (s.2 - H₂) ≤ d →
      ∃ N, N ≤ d + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s) N :=
  fun d s high high' fuel =>
    match Indexed.rests_by (pair_rises rises₁ rises₂) (band_web band) covers_pair d (ofPair s)
        (pair_within high high') fuel with
    | ⟨N, le, still⟩ => ⟨N, le, pair_still still⟩

/-- **Under mutual support within a band, a run comes to rest.** In whole numbers, where each
condition's giving rises with what is left of each and the coupled step keeps a band up to `hi`, the run
from a state in the band is still from some step at most `2 hi + 1`. -/
theorem comes_to_rest {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) {x y : Nat}
    (high : x ≤ hi) (high' : y ≤ hi) :
    ∃ N, N ≤ hi + hi + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)) N :=
  rests_by rises₁ rises₂ band (hi + hi) (x, y) high high'
    (Nat.add_le_add (Nat.le_trans (Nat.sub_le x H₁) high) (Nat.le_trans (Nat.sub_le y H₂) high'))

/-- The first condition of the web read off a pair at step `2 hi + 1` is the pair's. -/
theorem pair_at {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi : Nat} (s : Nat × Nat) :
    (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state
        ([true, false].length * hi + 1) true =
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (hi + hi + 1)).1 :=
  (congrArg (fun n => (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂))
      (ofPair s)).state (n + 1) true) (pair_count hi)).trans
    (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s (hi + hi + 1)).1

/-- Within a band under mutual support, whether the first condition ends is decided at step
`2 hi + 1`: the web's law for the pair. -/
theorem ends_iff {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (x, y) ↔
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state (hi + hi + 1)).1 = 0 :=
  (ends_pair (D := Drawn.whole)).trans ((Indexed.ends_iff (pair_rises rises₁ rises₂) (band_web band)
    covers_pair (pair_within (s := (x, y)) high high') true).trans
    ⟨fun zero => (pair_at (x, y)).symm.trans zero, fun zero => (pair_at (x, y)).trans zero⟩)

/-- Whether the first condition, from level `x` with its partner at `y`, is nothing at step `2 hi + 1`. -/
def ending (g₁ g₂ : Nat → Nat → Nat) (H₁ H₂ hi y x : Nat) : Bool :=
  decide (((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state (hi + hi + 1)).1 = 0)

/-- **The first condition's point of no return, with its partner at `y`.** The least level up to
`hi + 1` from which the first condition is not nothing at step `2 hi + 1`. -/
def threshold (g₁ g₂ : Nat → Nat → Nat) (H₁ H₂ hi y : Nat) : Nat :=
  leading (ending g₁ g₂ H₁ H₂ hi y) (hi + 1)

/-- The pair from `x` with its partner at `y` is the web's state with the first level set to `x`. -/
theorem setAt_pair (x y : Nat) : ∀ j, Indexed.setAt (ofPair (0, y)) true x j = ofPair (x, y) j
  | true => if_pos rfl
  | false => if_neg Bool.noConfusion

/-- **The pair's point of no return is the web's**, the second condition at `y`. -/
theorem threshold_pair {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) :
    threshold g₁ g₂ H₁ H₂ hi y =
      Indexed.threshold (pairGiving g₁ g₂) (pairDraw H₁ H₂) [true, false] hi (ofPair (0, y)) true :=
  leading_congr (fun x => congrArg (fun z => decide (z = 0))
    ((pair_at (x, y)).symm.trans (Indexed.run_alike (Indexed.pointwise_of_rises (pair_rises rises₁ rises₂)) (setAt_pair x y)
      ([true, false].length * hi + 1) true).symm)) (hi + 1)

/-- **The point of no return is exact.** Within a band under mutual support, the first condition ends
from a level and a partner's level up to `hi` exactly where its level is below the threshold for its
partner's level: the web's law for the pair. -/
theorem ends_iff_below {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst (x, y) ↔ x < threshold g₁ g₂ H₁ H₂ hi y := by
  rw [threshold_pair rises₁ rises₂]
  exact (ends_pair (D := Drawn.whole)).trans
    ((Indexed.ends_alike (Indexed.pointwise_of_rises (pair_rises rises₁ rises₂)) (setAt_pair x y) true).symm.trans
      (Indexed.ends_iff_below (pair_rises rises₁ rises₂) (band_web band) covers_pair high
        (pair_within (s := (0, y)) (Nat.zero_le hi) high')))

/-- **The point of no return falls as the partner rises.** Within a band under mutual support, a
larger partner's level up to `hi` gives the first condition a threshold no higher: the web's law for
the pair. -/
theorem threshold_falls {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi y y' : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (le : y ≤ y')
    (high' : y' ≤ hi) : threshold g₁ g₂ H₁ H₂ hi y' ≤ threshold g₁ g₂ H₁ H₂ hi y := by
  rw [threshold_pair rises₁ rises₂, threshold_pair rises₁ rises₂]
  exact Indexed.threshold_falls (pair_rises rises₁ rises₂) (band_web band) covers_pair
    (fun b => match b with
      | true => Nat.le_refl 0
      | false => le)
    (pair_within (s := (0, y')) (Nat.zero_le hi) high')

/-- **Every state in the band has its fate by the threshold.** Within a band under mutual support, the
run from a level and a partner's level up to `hi` is still from some step at most `2 hi + 1`, where
the first condition is nothing if its level is below the threshold and something if not: the web's
law for the pair. -/
theorem fates {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ hi x y : Nat} (rises₁ : Drawn.whole.Rises g₁)
    (rises₂ : Drawn.whole.Rises g₂) (band : Band Drawn.whole g₁ g₂ H₁ H₂ hi) (high : x ≤ hi)
    (high' : y ≤ hi) :
    ∃ N, N ≤ hi + hi + 1 ∧ LastChange.StillFrom (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)) N ∧
      (x < threshold g₁ g₂ H₁ H₂ hi y →
        ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1 = 0) ∧
      (threshold g₁ g₂ H₁ H₂ hi y ≤ x →
        0 < ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1) :=
  have rises := pair_rises (D := Drawn.whole) rises₁ rises₂
  have alike := Indexed.run_alike (H := pairDraw H₁ H₂) (Indexed.pointwise_of_rises rises) (setAt_pair x y)
  match Indexed.fates rises (band_web band) covers_pair high
      (pair_within (s := (0, y)) (Nat.zero_le hi) high') with
  | ⟨N, le, still, below, above⟩ =>
    have toPair : (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂))
        (Indexed.setAt (ofPair (0, y)) true x)).state N true =
        ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) (x, y)).state N).1 :=
      (alike N true).trans (pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ (x, y) N).1
    ⟨N, Nat.le_trans le (Nat.le_of_eq (congrArg (· + 1) (pair_count hi))),
     pair_still fun k b => (alike (N + k) b).symm.trans ((still k b).trans (alike N b)),
     fun lt => toPair.symm.trans (below (Eq.subst (motive := fun z => x < z) (threshold_pair rises₁ rises₂) lt)),
     fun ge => Nat.lt_of_lt_of_le (above (Eq.subst (motive := fun z => z ≤ x) (threshold_pair rises₁ rises₂) ge))
       (Nat.le_of_eq toPair)⟩

/-- **A dependent condition ends after its partner.** In whole numbers, where the second condition
gives nothing wherever nothing is left of the first and the first stays within its draw from step `N`
on, the second falls by its draw at every step from `N`; where that draw is positive it is nothing from
step `N + y` on, `y` its level at `N`: the web's law for the pair. -/
theorem ends_after {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends : ∀ b, g₂ 0 b = 0)
    {s : Nat × Nat} {N : Nat}
    (within : ∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (N + k)).1 ≤ H₁) :
    (∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (N + k)).2 =
      ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 - H₂ * k) ∧
    (0 < H₂ → ∀ k, ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state
      (N + ((Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state N).2 + k)).2 = 0) :=
  have run := pair_run (D := Drawn.whole) g₁ g₂ H₁ H₂ s
  have web := Indexed.ends_after (G := pairGiving g₁ g₂) (H := pairDraw H₁ H₂) (i := false) (j := true)
    (fun e zero => (congrArg (fun z => g₂ z (e false)) zero).trans (depends _)) (s := ofPair s) (N := N)
    fun k => Nat.le_trans (Nat.le_of_eq (run (N + k)).1) (within k)
  ⟨fun k => (run (N + k)).2.symm.trans ((web.1 k).trans (congrArg (· - H₂ * k) (run N).2)),
   fun pos k => (run _).2.symm.trans ((congrArg
      (fun m => (Law.run (Indexed.step Drawn.whole (pairGiving g₁ g₂) (pairDraw H₁ H₂)) (ofPair s)).state m false)
      (congrArg (fun y => N + y + k) (run N).2).symm).trans (web.2 pos k))⟩

/-- **The end of one ends what depends on it.** In whole numbers, where the second condition gives
nothing wherever nothing is left of the first and its draw is positive, wherever the first ends the
second ends: the web's law for the pair. -/
theorem ends_of_partner {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends : ∀ b, g₂ 0 b = 0)
    (pos : 0 < H₂) {s : Nat × Nat} (ends : Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst s) :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.snd s :=
  ends_pair.2 (Indexed.ends_of_partner (G := pairGiving g₁ g₂) (H := pairDraw H₁ H₂) (i := false)
    (j := true) (fun e zero => (congrArg (fun z => g₂ z (e false)) zero).trans (depends _)) pos
    (ends_pair.1 ends))

/-- **Under dependence both ways the two end together or not at all.** In whole numbers, where each
condition gives nothing wherever nothing is left of the other and both draws are positive, the first
ends exactly where the second does: the web's dependence cycle for the pair. -/
theorem ends_together {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} (depends₁ : ∀ a, g₁ a 0 = 0)
    (depends₂ : ∀ b, g₂ 0 b = 0) (pos₁ : 0 < H₁) (pos₂ : 0 < H₂) {s : Nat × Nat} :
    Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.fst s ↔ Ends Drawn.whole g₁ g₂ H₁ H₂ Prod.snd s :=
  have d₁ : Indexed.DependsOn Drawn.whole (pairGiving g₁ g₂) true false := fun e zero =>
    (congrArg (g₁ (e true)) zero).trans (depends₁ _)
  have d₂ : Indexed.DependsOn Drawn.whole (pairGiving g₁ g₂) false true := fun e zero =>
    (congrArg (fun z => g₂ z (e false)) zero).trans (depends₂ _)
  have web := Indexed.ends_together (H := pairDraw H₁ H₂) (s := ofPair s)
    (fun i _ _ => match i with
      | true => pos₁
      | false => pos₂)
    (.dep d₁ (.refl false)) (.dep d₂ (.refl true))
  ⟨fun e => ends_pair.2 (web.1 (ends_pair.1 e)), fun e => ends_pair.2 (web.2 (ends_pair.1 e))⟩

/-- **A condition whose giving reads only what is left of itself runs as the regime.** In whole numbers,
where the first condition's giving is `g` of what is left of it alone, its level along the coupled run
is the regime's run under its draw, whatever its partner does. -/
theorem first_regime (g : Nat → Nat) (g₂ : Nat → Nat → Nat) (H₁ H₂ : Nat) (s : Nat × Nat) :
    ∀ n, ((Law.run (step Drawn.whole (fun a _ => g a) g₂ H₁ H₂) s).state n).1 =
      (Law.run (RegimeMargin.step g H₁) s.1).state n
  | 0 => rfl
  | n + 1 => congrArg (RegimeMargin.step g H₁) (first_regime g g₂ H₁ H₂ s n)

/-- A state the coupled step leaves as it is stays at every step of its run. -/
theorem stays {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} {s : Nat × Nat}
    (fixed : step Drawn.whole g₁ g₂ H₁ H₂ s = s) :
    ∀ n, (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state n = s := fun n =>
  (congrArg (Law.orbit (step Drawn.whole g₁ g₂ H₁ H₂) s) (Nat.one_mul n)).symm.trans
    (Law.orbit_mul (next := step Drawn.whole g₁ g₂ H₁ H₂) (s := s) (p := 1) fixed n)

/-- A run that reaches a state the coupled step leaves as it is stays there. -/
theorem stays_from {g₁ g₂ : Nat → Nat → Nat} {H₁ H₂ : Nat} {s t : Nat × Nat} {T : Nat}
    (at_ : (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state T = t)
    (fixed : step Drawn.whole g₁ g₂ H₁ H₂ t = t) :
    ∀ k, (Law.run (step Drawn.whole g₁ g₂ H₁ H₂) s).state (T + k) = t := fun k =>
  (Law.orbit_add _ s T k).trans ((congrArg (fun p => Law.orbit (step Drawn.whole g₁ g₂ H₁ H₂) p k) at_).trans
    (stays fixed k))

/-- **Without mutual support a run within a band need not rest.** Giving that is two from nothing and
nothing from more, read as the first condition's, with the second giving nothing, does not rise with
what is left, and under draws of one the coupled step keeps a band up to two; yet the coupled run from
one and nothing is never still, the first's level being the regime's, which moves between one and two. -/
theorem alternation_never_rests :
    ¬ Drawn.whole.Rises (fun a (_ : Nat) => Alternation.giving a) ∧
    Band Drawn.whole (fun a _ => Alternation.giving a) (fun _ _ => 0) 1 1 2 ∧
    ∀ N, ¬ LastChange.StillFrom
      (Law.run (step Drawn.whole (fun a _ => Alternation.giving a) (fun _ _ => 0) 1 1) (1, 0)) N :=
  ⟨fun rises => absurd (rises 0 1 0 0 (Nat.zero_le 1) (Nat.le_refl 0))
      (by decide : ¬ Alternation.giving 0 ≤ Alternation.giving 1),
   fun x y hx hy => ⟨Alternation.keeps x hx, Nat.le_trans (Nat.sub_le y 1) hy⟩,
   fun N still => Alternation.alternates.2.2.2.2.2.1 N fun k =>
    (first_regime Alternation.giving (fun _ _ => 0) 1 1 (1, 0) (N + k + 1)).symm.trans
      ((congrArg Prod.fst (still k)).trans (first_regime Alternation.giving (fun _ _ => 0) 1 1 (1, 0) (N + k)))⟩

namespace MutualActivation

/-- Each gives one where at least one is left of each. -/
def giving (a b : Nat) : Nat := if 1 ≤ a ∧ 1 ≤ b then 1 else 0

theorem giving_rises : Drawn.whole.Rises giving := fun e _ r _ le le' =>
  if h : 1 ≤ e ∧ 1 ≤ r then
    Nat.le_of_eq ((if_pos h).trans (if_pos ⟨Nat.le_trans h.1 le, Nat.le_trans h.2 le'⟩).symm)
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem giving_le (a b : Nat) : giving a b ≤ 1 :=
  if h : 1 ≤ a ∧ 1 ≤ b then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le 1)

/-- Under draws of one the coupled step keeps every state up to two within two. -/
theorem band : Band Drawn.whole giving giving 1 1 2 := fun _ _ hx hy =>
  ⟨Nat.le_trans (Nat.add_le_add_left (giving_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hx)),
   Nat.le_trans (Nat.add_le_add_left (giving_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hy))⟩

/-- **Support can save a condition.** Under giving of one where at least one is left of each, draws of
one and a band up to two, the giving rises with what is left of each; from two, the first condition
ends with its partner at nothing and holds with its partner at two. Its point of no return falls from
beyond the band, every level up to two ending, to two. -/
theorem saves :
    Drawn.whole.Rises giving ∧ Band Drawn.whole giving giving 1 1 2 ∧
    Ends Drawn.whole giving giving 1 1 Prod.fst (2, 0) ∧
    ¬ Ends Drawn.whole giving giving 1 1 Prod.fst (2, 2) ∧
    threshold giving giving 1 1 2 0 = 3 ∧ threshold giving giving 1 1 2 2 = 2 :=
  ⟨giving_rises, band,
   ⟨2, fun k => congrArg Prod.fst (stays_from (T := 2) (t := (0, 0)) rfl rfl k)⟩,
   fun ⟨N, gone⟩ => absurd ((congrArg Prod.fst (stays (s := (2, 2)) rfl (N + 0)).symm).trans (gone 0))
     (Naturals.succ_ne_zero 1),
   rfl, rfl⟩

end MutualActivation

namespace MutualInhibition

/-- The first gives one where at least one is left of it and nothing of the second. -/
def first (a b : Nat) : Nat := if 1 ≤ a ∧ b = 0 then 1 else 0

/-- The second gives one where nothing is left of the first and at least one of it. -/
def second (a b : Nat) : Nat := if a = 0 ∧ 1 ≤ b then 1 else 0

theorem first_le (a b : Nat) : first a b ≤ 1 :=
  if h : 1 ≤ a ∧ b = 0 then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le 1)

theorem second_le (a b : Nat) : second a b ≤ 1 :=
  if h : a = 0 ∧ 1 ≤ b then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le 1)

/-- Under draws of one the coupled step keeps every state up to two within two. -/
theorem band : Band Drawn.whole first second 1 1 2 := fun _ _ hx hy =>
  ⟨Nat.le_trans (Nat.add_le_add_left (first_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hx)),
   Nat.le_trans (Nat.add_le_add_left (second_le _ _) _) (Nat.succ_le_succ (Nat.pred_le_pred hy))⟩

/-- **Without mutual support the order of fates breaks.** Where each gives one only where nothing is
left of the other, the giving falls as what is left of the other rises, and under draws of one the
coupled step keeps a band up to two. Each holds at two alone, and from two and two both end; so the
first ends from a state above one from which it holds, and its point of no return rises from two to
beyond the band as its partner rises from nothing to two. -/
theorem breaks_order :
    ¬ Drawn.whole.Rises first ∧ Band Drawn.whole first second 1 1 2 ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.fst (2, 0) ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.snd (0, 2) ∧
    Ends Drawn.whole first second 1 1 Prod.fst (2, 2) ∧ Ends Drawn.whole first second 1 1 Prod.snd (2, 2) ∧
    Drawn.whole.Below (2, 0) (2, 2) ∧
    threshold first second 1 1 2 0 = 2 ∧ threshold first second 1 1 2 2 = 3 :=
  ⟨fun rises => absurd (rises 1 1 0 1 (Nat.le_refl 1) (Nat.zero_le 1)) (by decide : ¬ first 1 0 ≤ first 1 1),
   band,
   fun ⟨N, gone⟩ => absurd ((congrArg Prod.fst (stays (s := (2, 0)) rfl (N + 0)).symm).trans (gone 0))
     (Naturals.succ_ne_zero 1),
   fun ⟨N, gone⟩ => absurd ((congrArg Prod.snd (stays (s := (0, 2)) rfl (N + 0)).symm).trans (gone 0))
     (Naturals.succ_ne_zero 1),
   ⟨2, fun k => congrArg Prod.fst (stays_from (T := 2) (t := (0, 0)) rfl rfl k)⟩,
   ⟨2, fun k => congrArg Prod.snd (stays_from (T := 2) (t := (0, 0)) rfl rfl k)⟩,
   ⟨Nat.le_refl 2, Nat.zero_le 2⟩, rfl, rfl⟩

end MutualInhibition

namespace Relay

/-- The first gives two where at least one is left of it and at least two of the second. -/
def first (a b : Nat) : Nat := if 1 ≤ a ∧ 2 ≤ b then 2 else 0

/-- The second gives two where at least two are left of the first and at least one of it. -/
def second (a b : Nat) : Nat := if 2 ≤ a ∧ 1 ≤ b then 2 else 0

theorem first_rises : Drawn.whole.Rises first := fun e _ r _ le le' =>
  if h : 1 ≤ e ∧ 2 ≤ r then
    Nat.le_of_eq ((if_pos h).trans (if_pos ⟨Nat.le_trans h.1 le, Nat.le_trans h.2 le'⟩).symm)
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem second_rises : Drawn.whole.Rises second := fun e _ r _ le le' =>
  if h : 2 ≤ e ∧ 1 ≤ r then
    Nat.le_of_eq ((if_pos h).trans (if_pos ⟨Nat.le_trans h.1 le, Nat.le_trans h.2 le'⟩).symm)
  else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

theorem first_zero (a : Nat) : first a 0 = 0 := if_neg fun h => absurd h.2 (by decide)

theorem first_of_zero (b : Nat) : first 0 b = 0 := if_neg fun h => absurd h.1 (by decide)

theorem second_zero (a : Nat) : second a 0 = 0 := if_neg fun h => absurd h.2 (by decide)

theorem second_of_zero (b : Nat) : second 0 b = 0 := if_neg fun h => absurd h.1 (by decide)

/-- With the second at nothing, the first falls by one at every step and the second stays nothing. -/
theorem first_alone (x : Nat) :
    ∀ n, (Law.run (step Drawn.whole first second 1 1) (x, 0)).state n = (x - n, 0)
  | 0 => rfl
  | n + 1 => (congrArg (step Drawn.whole first second 1 1) (first_alone x n)).trans
    (congr (congrArg Prod.mk (congrArg (x - n - 1 + ·) (first_zero (x - n - 1))))
      (congrArg (0 + ·) (second_zero (x - n - 1))))

/-- With the first at nothing, the second drains by one at every step, by the pair's law of draining,
and the first stays nothing. -/
theorem second_alone (y : Nat) :
    ∀ n, (Law.run (step Drawn.whole first second 1 1) (0, y)).state n = (0, y - n)
  | 0 => rfl
  | n + 1 => (congrArg (step Drawn.whole first second 1 1) (second_alone y n)).trans
    (congr (congrArg Prod.mk (congrArg (0 + ·) (first_of_zero (y - n - 1))))
      (drains (D := Drawn.whole) (g₁ := first) (H₁ := 1) (H₂ := 1) second_of_zero (p := (0, y - n))
        (Nat.zero_le 1)))

/-- From two and three, the run is at two and three or at three and two at every step, and the next is
the other. -/
theorem between :
    ∀ n, ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n = (2, 3) ∧
        (Law.run (step Drawn.whole first second 1 1) (2, 3)).state (n + 1) = (3, 2)) ∨
      ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n = (3, 2) ∧
        (Law.run (step Drawn.whole first second 1 1) (2, 3)).state (n + 1) = (2, 3))
  | 0 => Or.inl ⟨rfl, rfl⟩
  | n + 1 => (between n).elim
    (fun ⟨_, next⟩ => Or.inr ⟨next, (congrArg (step Drawn.whole first second 1 1) next).trans rfl⟩)
    (fun ⟨_, next⟩ => Or.inl ⟨next, (congrArg (step Drawn.whole first second 1 1) next).trans rfl⟩)

/-- **Mutual support can hold a pair neither of which holds alone, and need not rest.** Where each gives
two only where enough is left of the other, the giving rises with what is left of each and each gives
nothing wherever nothing is left of the other. Under draws of one each condition alone ends, from
every level. Yet from two and three the run moves between two and three and three and two at every
step: it stays within three, neither condition ever ends, and the run is never still. -/
theorem cycles :
    Drawn.whole.Rises first ∧ Drawn.whole.Rises second ∧ (∀ a, first a 0 = 0) ∧ (∀ b, second 0 b = 0) ∧
    (∀ x, Ends Drawn.whole first second 1 1 Prod.fst (x, 0)) ∧
    (∀ y, Ends Drawn.whole first second 1 1 Prod.snd (0, y)) ∧
    (∀ n, ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).1 ≤ 3 ∧
      ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).2 ≤ 3) ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.fst (2, 3) ∧
    ¬ Ends Drawn.whole first second 1 1 Prod.snd (2, 3) ∧
    ∀ N, ¬ LastChange.StillFrom (Law.run (step Drawn.whole first second 1 1) (2, 3)) N :=
  ⟨first_rises, second_rises,
   first_zero, second_of_zero,
   fun x => ⟨x, fun k => (congrArg Prod.fst (first_alone x (x + k))).trans
     (Becoming.sub_eq_zero_of_le (Nat.le_add_right x k))⟩,
   fun y => ⟨y, fun k => (congrArg Prod.snd (second_alone y (y + k))).trans
     (Becoming.sub_eq_zero_of_le (Nat.le_add_right y k))⟩,
   fun n => (between n).elim
     (fun ⟨at_, _⟩ => by rw [at_]; exact ⟨Nat.le_succ 2, Nat.le_refl 3⟩)
     (fun ⟨at_, _⟩ => by rw [at_]; exact ⟨Nat.le_refl 3, Nat.le_succ 2⟩),
   fun ⟨N, gone⟩ => (between (N + 0)).elim
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 1 ((congrArg Prod.fst at_).symm.trans (gone 0)))
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 2 ((congrArg Prod.fst at_).symm.trans (gone 0))),
   fun ⟨N, gone⟩ => (between (N + 0)).elim
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 2 ((congrArg Prod.snd at_).symm.trans (gone 0)))
     (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 1 ((congrArg Prod.snd at_).symm.trans (gone 0))),
   fun N still => (between (N + 0)).elim
     (fun ⟨at_, next⟩ => absurd ((next.symm.trans (still 0)).trans at_) (by decide))
     (fun ⟨at_, next⟩ => absurd ((next.symm.trans (still 0)).trans at_) (by decide))⟩

/-- The pair from a level, its partner at `y`, ends exactly where the web's state with the first level
set does. -/
theorem ends_set {x y : Nat} :
    Ends Drawn.whole first second 1 1 Prod.fst (x, y) ↔
      Indexed.Ends Drawn.whole (pairGiving first second) (pairDraw 1 1) (fun w => w true)
        (Indexed.setAt (ofPair (0, y)) true x) :=
  (ends_pair (D := Drawn.whole)).trans ((Indexed.ends_alike
    (Indexed.pointwise_of_rises (pair_rises first_rises second_rises)) (setAt_pair x y) true).symm)

/-- **Beyond every band, the point of no return is still exact.** `Relay` keeps no band from three
up: from every level `hi` at least three at both, the first rises above `hi`. Yet the run from two
with the partner at three stays within three, so for the first condition's levels up to two its point
of no return is decided within the bound: three with its partner at two, from every level of which it
ends, and two with its partner at three, from nothing and one it ends and from two it holds. The
threshold falls as the partner rises, beyond any band. -/
theorem threshold_beyond_band :
    (∀ hi, 3 ≤ hi → ¬ Indexed.Band (pairGiving first second) (pairDraw 1 1) hi) ∧
    Indexed.StaysWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) 3 (Indexed.setAt (ofPair (0, 3)) true 2) ∧
    Indexed.thresholdWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) [true, false] 3 2 (ofPair (0, 2)) true = 3 ∧
    Indexed.thresholdWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) [true, false] 3 2 (ofPair (0, 3)) true = 2 :=
  have rises := pair_rises (D := Drawn.whole) first_rises second_rises
  have within : Indexed.StaysWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) 3
      (Indexed.setAt (ofPair (0, 3)) true 2) := fun n j =>
    have pairs := pair_run (D := Drawn.whole) first second 1 1 (2, 3) n
    have small : ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).1 ≤ 3 ∧
        ((Law.run (step Drawn.whole first second 1 1) (2, 3)).state n).2 ≤ 3 :=
      (between n).elim
        (fun ⟨at_, _⟩ => Eq.subst (motive := fun p : Nat × Nat => p.1 ≤ 3 ∧ p.2 ≤ 3) at_.symm
          ⟨Nat.le_succ 2, Nat.le_refl 3⟩)
        (fun ⟨at_, _⟩ => Eq.subst (motive := fun p : Nat × Nat => p.1 ≤ 3 ∧ p.2 ≤ 3) at_.symm
          ⟨Nat.le_refl 3, Nat.le_succ 2⟩)
    Nat.le_trans (Nat.le_of_eq (Indexed.run_alike (Indexed.pointwise_of_rises rises) (setAt_pair 2 3) n j))
      (match j with
        | true => Nat.le_trans (Nat.le_of_eq pairs.1) small.1
        | false => Nat.le_trans (Nat.le_of_eq pairs.2) small.2)
  have within₂ : Indexed.StaysWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) 3
      (Indexed.setAt (ofPair (0, 2)) true 2) :=
    Indexed.within_below (Indexed.step_keepsBelow rises) (Indexed.setAt_below (Nat.le_refl 2) fun j =>
      match j with
      | true => Nat.le_refl 0
      | false => Nat.le_succ 2) within
  have endsTwo : Ends Drawn.whole first second 1 1 Prod.fst (2, 2) :=
    ⟨2, fun k => (congrArg Prod.fst ((Law.orbit_add (step Drawn.whole first second 1 1) (2, 2) 2 k).trans
      (first_alone 0 k))).trans (Nat.zero_sub k)⟩
  have endsOne : Ends Drawn.whole first second 1 1 Prod.fst (1, 3) :=
    ⟨1, fun k => congrArg Prod.fst ((Law.orbit_add (step Drawn.whole first second 1 1) (1, 3) 1 k).trans
      (second_alone 2 k))⟩
  have holds : ¬ Ends Drawn.whole first second 1 1 Prod.fst (2, 3) := fun ⟨N, gone⟩ =>
    (between (N + 0)).elim
      (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 1 ((congrArg Prod.fst at_).symm.trans (gone 0)))
      (fun ⟨at_, _⟩ => Naturals.succ_ne_zero 2 ((congrArg Prod.fst at_).symm.trans (gone 0)))
  ⟨fun hi three band =>
    have one : 1 ≤ hi := Nat.le_trans (Nat.le_add_left 1 2) three
    have gives : first (hi - 1) (hi - 1) = 2 :=
      if_pos ⟨Naturals.le_sub_of_add_le (Nat.le_trans (Nat.le_succ 2) three),
        Naturals.le_sub_of_add_le three⟩
    have up : hi - 1 + first (hi - 1) (hi - 1) ≤ hi :=
      band (fun _ => hi) (fun _ => Nat.le_refl hi) true
    Nat.not_succ_le_self hi (Nat.le_trans (Nat.le_of_eq
      (((congrArg (· + 1) (Naturals.sub_add_cancel one)).symm.trans
        (Nat.add_assoc (hi - 1) 1 1)).trans (congrArg (hi - 1 + ·) gives.symm))) up),
   within,
   Nat.le_antisymm (leading_le _ _)
    ((Indexed.ends_iff_below_within (Indexed.step_keepsBelow rises) covers_pair within₂ (Nat.le_refl 2)).1 (ends_set.1 endsTwo)),
   Nat.le_antisymm
    ((Nat.lt_or_ge 2 (Indexed.thresholdWithin (Indexed.step Drawn.whole (pairGiving first second) (pairDraw 1 1)) [true, false] 3 2
        (ofPair (0, 3)) true)).elim
      (fun lt => absurd (ends_set.2 ((Indexed.ends_iff_below_within (Indexed.step_keepsBelow rises) covers_pair within
        (Nat.le_refl 2)).2 lt)) holds) id)
    ((Indexed.ends_iff_below_within (Indexed.step_keepsBelow rises) covers_pair within (Nat.le_succ 1)).1 (ends_set.1 endsOne))⟩

end Relay

end Coupled

end RegimeMargin

end Becoming
