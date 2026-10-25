import Becoming.Optimum
import Becoming.Regulation

/-!
# Set-point optimum: what an order with a point of enough does beyond what couples in

`Becoming.Optimum` states what an optimum of an order rising with what couples in does beyond it:
where there is room, every optimum stands at the least level beyond among the eligible outcomes
(`Optimum.least_of_room`), and in an exchange each member of the part takes its whole capacity at
every condition beyond (`Optimum.optimum_beyond`). An order greatest at a set point of what couples
in is not rising. This module states what the optima of such orders do beyond their couplings, in
the outcomes, orders and exchanges of `Becoming.Optimum`, and where joint excess
(`Flow.joint_excess_ends`) still ends a condition that formations holding their levels draw on, with
no premise beyond the hypotheses each statement names. The set point `s` is read on the family `ds`;
the gap of two amounts is `gap` of `Becoming.Propagation`, and lying between a set point and a
level, on the level's side and no farther, is `Regulation.Between`, regulation's no overshoot.

* **Orders nearing a set point.** One outcome is nearer a set point than another on a family where
  at each condition of the family it lies between the set point and the other, and at one it is
  strictly nearer, whatever either holds beyond (`Optimum.Nearer`); an order is nearing where it
  ranks above every nearer outcome (`Optimum.Nearing`), as an order is rising where it ranks above
  every exceeding one. A nearing order is so strictly single-peaked at the set point condition by
  condition, each peak not depending on the others and each side weighed as it may be. An order
  falling with the distance from the set point at each condition, both sides alike, is nearing
  (`Optimum.nearing_of_gaps`), the order by the family's total gap among them
  (`Optimum.byGap_nearing`); so is an order costlier above the set point than below
  (`Skew.nearing`), which does not fall with the distance alike on both sides (`Skew.not_by_gaps`).
  Every order ranking above wherever a nearing order does is nearing (`Optimum.Nearing.mono`). No
  nearing order that never ranks two outcomes above each other is rising, where the family holds a
  condition (`Optimum.Nearing.not_rising`): neither the order by distance
  (`Optimum.byGap_not_rising`) nor the order by distance with the beyond counted after
  (`Optimum.byGapThen_not_rising`). Nor, where the family holds a condition, is any order under
  which an outcome is ranked below none (`Optimum.not_rising_of_unbeaten`), as an outcome at the set
  point is by distance (`Optimum.byGap_unbeaten_at`).
* **Where the set point can be reached, every optimum stands at it, exactly.** Every nearing order
  has its optima at the set point exactly where no eligible outcome off it goes unbeaten by a nearer
  eligible one (`Optimum.atSetPoint_iff`); so where some eligible outcome stands at the set point,
  every optimum does (`Optimum.atSetPoint_of_reach`), whatever the room, and several optimizers each
  reaching its set point stand at their joint set point (`Optimum.mutual_atSetPoint`).
* **Nearing alone asks nothing of what lies beyond.** Where the set point can be reached, an outcome
  is an optimum of some nearing order exactly where it is eligible and at the set point
  (`Optimum.optima_iff`), and every optimum of every nearing order stands beyond at the least level
  among the eligible outcomes at the set point exactly where those all stand alike beyond
  (`Optimum.least_at_iff`): the class leaves what lies beyond where the way of reaching the set
  point leaves it. One nearing order can still drive what lies beyond through what it counts after
  the set point. Counting more beyond, it leaves the beyond, in total, at the most any eligible way
  of reaching the set point leaves (`Optimum.counted_after_most`), and with one condition beyond it
  keeps a need there exactly where some such way keeps it (`Optimum.counted_after_keeps_iff`);
  counting less beyond, it drains (`Topped.counted_less_drains`).
* **Below the set point a nearing order rises.** Among outcomes up to the set point, one is nearer
  exactly where it exceeds on the family (`Optimum.nearer_iff_exceeds`), so there a nearing order
  ranks above every exceeding outcome (`Optimum.Nearing.rises_below`), and every nearing order has
  its optima among the eligible outcomes up to the set point at the least level beyond among them
  exactly where room holds among them (`Optimum.least_below_iff`, from `Optimum.least_iff`;
  `Optimum.least_below`). Room up to the set point fails at an outcome at the set point standing
  above another beyond, so this law bites where the set point is out of reach.
* **What reaching the set point draws.** In a balanced step where the whole, the family with the
  conditions beyond, gains nothing and the family stands at its set point after the step, the beyond
  after it, with what the whole loses and the set point's total, is the family and the beyond before
  (`Flow.Balances.atSetPoint_draws`, from `Flow.Balances.beyond_falls_exactly`): the beyond falls by
  the family's shortfall from its set point with what the step loses, and rises where the family
  stood above it; with the set point held across the step, it falls by the loss alone
  (`Flow.Balances.held_draws_lost`). With each condition beyond depended on at a need it meets, some
  dependence breaks where the set point's total with the loss exceeds the family before with the
  slack (`Flow.Balances.atSetPoint_breaks`); with one condition beyond, exactly there
  (`Flow.Balances.atSetPoint_broken_iff`); with several, the identity fixes the total drawn, not its
  spread. Every optimum of a nearing order whose set point some eligible outcome reaches draws so
  (`Flow.nearing_optimum_draws`), and several such optimizers draw their joint shortfall, as one
  with their joint set point (`Flow.Balances.mutual_atSetPoint_draws`), breaking a dependence beyond
  where it exceeds the slack, whatever each one's own (`Flow.Balances.mutual_atSetPoint_breaks`).
* **In an exchange, below the set point, the whole capacity.** One unit moved from a condition
  beyond into a condition of the family below its set point is nearer it
  (`Optimum.transfer_nearer`). So among the outcomes open to a part, every optimum of every nearing
  order standing below its set point at a condition of the family stands at each condition beyond at
  the level before, with what the rest gives and less what it takes, less the part's whole capacity,
  or at nothing (`Optimum.nearing_beyond`): where every optimum of every rising order stands
  (`Optimum.nearing_as_rising`). Both are cases of one law of `Becoming.Optimum`, whose rising laws
  are its cases too: an optimum takes the whole capacity at a condition beyond wherever its order
  ranks above it the outcome with one unit moved from there into the family
  (`Optimum.Above.full_of_ranked`, `Optimum.Above.floor_or_full_of_ranked`,
  `Optimum.beyond_of_ranked`).
* **Holding a level takes at least what is lost, and joint excess ends what is drawn on.** A
  formation alone exchanging with its family, holding the family's stock across a step, takes from a
  condition at least what it gives there with what it loses on its family with that condition
  (`Flow.held_draws`). Where formations so holding lose together, at each of `n` steps, more than
  the formations outside them give a condition whose level starts below `n + m`, under the gate at
  need `m` every formation depending on the condition at a need of at least `m` is inactive from the
  `n`-th step on, however small each one's loss; where each one's couplings lie in its family, apart
  from the condition, none couples into it (`Flow.held_excess_ends`, from `Flow.joint_excess_ends`).
  No order or choice enters these laws. A family at its set point at two steps holds its stock
  between them (`Optimum.stock_eq_of_atSetPoint`), and a nearing chooser holds its family at the set
  point wherever, at each step, an eligible outcome reaches it (`Optimum.atSetPoint_of_reach`); the
  course of choices is not formalized.
* **Witnesses.** Among the splits of three units between a source and a store, where room holds and
  every rising optimum empties the source, every optimum of every order nearing a store of `k`
  leaves the source at `3 - k` (`Drain.atSetPoint_source`), so it meets the dweller's need of two
  exactly where `k` is at most one, the slack (`Drain.kept_iff`; `Drain.nearing_keeps` at one,
  `Drain.nearing_breaks` at two); an aspiration level at a store of one with the source counted
  after leaves it at two as well (`Drain.satisficingThen_keeps`). In an exchange from a store at its
  set point of one, every nearing optimum stands at it, and the step exchanging nothing and the step
  taking a unit of the source and losing it are both optima of the order by distance, the first
  leaving the source at the dweller's need of two and the second below it, while every rising
  optimum leaves it below (`Topped.nearing_either`, `Topped.rising_drains`). There, with the source
  counted after the set point every optimum meets the need (`Topped.counted_after_keeps`), with less
  source counted after every optimum leaves it below (`Topped.counted_less_drains`), and under every
  positive weight on the source against the store's gap every optimum meets the need
  (`Topped.weighted_keeps`); a set point no open outcome reaches leaves it below the need, as a
  rising order does (`Topped.out_of_reach`). With two conditions beyond, counting the beyond after
  the set point empties one of them though a way of reaching the set point keeps both
  (`Spread.counted_after_empties`). Two takers each nearing a store of its own at one, from a source
  of three of which a dweller needs two, each short of its set point by no more than the slack of
  one, together break the dweller (`TwoStores.jointly_broken`). Two formations each holding a store
  at one by drawing from a pool the unit they lose, each within the one unit the pool is given, end
  its renewal from a pool of two in two steps, neither coupling into the pool (`HeldPair.held_end`).

So a set point removes the drive of the class beyond what couples in, not the draw. Below its set
point a nearing order rises with what couples in and its optima drain as a rising order's do. At its
set point the class asks nothing of what lies beyond, which stands where the way of reaching the set
point leaves it: lower by the set point's shortfall with what the step loses, in a balanced step in
which the whole gains nothing. Which way is taken, where several reach the set point, is decided by
what else the order counts or by the choice among optima, not by the set point.

**Reading (the AI's).** Active inference casts preferences as prior beliefs over outcomes, highest
at the characteristic states (Friston and others, "Active inference and learning", 2016). A
preference strictly single-peaked at its mode on each observed condition, each peak not depending on
the others and each side weighed as it may be, ranks outcomes as an order nearing that mode on what
is observed; a drive that is a norm of the deviations from set points, as in homeostatic
reinforcement learning (Keramati and Gutkin 2014), falls with the distance alike on both sides. Such
a chooser escapes the drive beyond its couplings at its set point, not the drain below it, nor joint
excess. Below its set point it drains as a maximizer does (`Optimum.least_below`,
`Optimum.nearing_beyond`). At its set point it draws what the way of reaching the set point draws
(`Flow.Balances.atSetPoint_draws`). Where the step can lose what it takes, the set point alone does
not protect what lies beyond, the order by distance having the draining step among its optima beside
the keeping one (`Topped.nearing_either`), and a term on what lies beyond counted after the set
point does protect it there (`Topped.counted_after_keeps`). That contrast with rising orders belongs
to the plateau, not to the set point. Counted after a rising order, with room, such a term changes
nothing (`Optimum.Rising.mono`, `Optimum.least_of_room`; `Drain.counted_after_drains`); counted
after an order with a plateau, a set point or an aspiration level (Simon, "A behavioral model of
rational choice", 1955; `Drain.satisficingThen_keeps`), it decides within the plateau. Counting more
beyond after a set point, it leaves, in total, the most any way of reaching the set point leaves
(`Optimum.counted_after_most`); counting less, it drains (`Topped.counted_less_drains`). Such a term
reads what lies beyond: it is a coupling ranked second. So what protects at a set point is how the
choice among equal optima is made, the point of mild optimization (Taylor, "Quantilizers", 2016): a
choice drawn from a base distribution over the ways of reaching the set point would be a quantilizer
and inherit its bound, an arbitrary choice has none. Formations holding a level take at least their
loss from what they share, so several, each within what a condition is given, can end it together
(`Flow.held_excess_ends`); no choice enters that law.

What is not derived: that an agent's preferences form a nearing order (one whose best level at a
condition depends on the levels at others, or that is not strictly single-peaked at each, is not
one: a preference indifferent within a tolerance band around the set point is not nearing, the band
being a two-sided aspiration level, to which the plateau's results apply instead), or any
probability, surprisal, expected free energy or precision; which outcomes are eligible, whether one
reaches the set point, and room up to it (hypotheses wherever they enter); the optimum where no
eligible outcome reaches the set point and some stand above it; in an exchange, the optima at the
set point beyond the witnesses, and above it; which optimum is taken where several stand at the set
point, which decides keeping wherever a step can lose what it takes; terms counted after the set
point are lexicographic, so that with continuous amounts or finite precision, where exact ties are
rare, a weighted term trades against the set point instead (`Topped.weighted_keeps` is one weighted
case); several optimizers share one set point on shared conditions, and conflicting set points are
not treated; which outcomes are eligible to each of several optimizers at once (supplied, not read
off an exchange as `Optimum.MutualBest` does for rising orders); that formations hold their levels,
exchange alone with their families and lose what they lose (supplied). Every law is of one step or
of supplied courses, and deterministic: under noise over a horizon a set point on later states makes
reserves worth holding, so a rising drive on stores can return. The representation commits to
discrete steps and natural amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Requirement

variable {F C : Type}

namespace Optimum

/-! ## Orders nearing a set point

An order rising with a family ranks above every outcome higher on it; an order nearing a set point
ranks above every outcome lying, at each condition of the family, between the set point and the
other, and nearer at one. Where the set point can be reached, every optimum stands at it, and the
class asks nothing more of what lies beyond. -/

/-- How far an outcome stands from a set point at each condition: the gap of the two amounts. -/
def gapTo (s o : C → Nat) : C → Nat := fun c => gap (o c) (s c)

/-- One outcome is nearer a set point than another on a family: at each condition of the family it
lies between the set point and the other (on the other's side of the set point and no farther,
`Regulation.Between`), and at one it is strictly nearer, whatever either holds elsewhere. -/
def Nearer (ds : List C) (s o' o : C → Nat) : Prop :=
  (∀ c, c ∈ ds → Regulation.Between (s c) (o c) (o' c)) ∧
    ∃ c, c ∈ ds ∧ gapTo s o' c < gapTo s o c

/-- An order nears a set point of a family: it ranks above every outcome nearer the set point on
the family, whatever either holds elsewhere. -/
def Nearing (ds : List C) (s : C → Nat) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ o o', Nearer ds s o' o → better o' o

/-- At the set point: each condition of the family stands at its set point. -/
def AtSetPoint (ds : List C) (s o : C → Nat) : Prop :=
  ∀ c, c ∈ ds → o c = s c

/-- Up to the set point: no condition of the family stands above its set point. -/
def UpToSetPoint (ds : List C) (s o : C → Nat) : Prop :=
  ∀ c, c ∈ ds → o c ≤ s c

/-- The order by distance from a set point: the outcome whose family stands at a smaller total gap
from the set point ranks above. -/
def byGap (ds : List C) (s o' o : C → Nat) : Prop :=
  total ds (gapTo s o') < total ds (gapTo s o)

variable {ds rest : List C} {s : C → Nat} {eligible : (C → Nat) → Prop}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- The set point lies between itself and every level. -/
theorem setPoint_between (m x : Nat) : Regulation.Between m x m :=
  ⟨fun mx => ⟨Nat.le_refl m, mx⟩, fun xm => ⟨xm, Nat.le_refl m⟩⟩

/-- Nearer is nearer by the gaps: no farther at each condition of the family, nearer at one. -/
theorem Nearer.gaps {o o' : C → Nat} (nearer : Nearer ds s o' o) :
    Exceeds ds (gapTo s o) (gapTo s o') :=
  ⟨fun c mem => Regulation.Between.gap_le (nearer.1 c mem), nearer.2⟩

/-- **An order falling with the distance from the set point is nearing.** An order ranking above
every outcome no farther from the set point at each condition of the family and nearer at one, the
two sides alike, is nearing. -/
theorem nearing_of_gaps (falls : ∀ o o', Exceeds ds (gapTo s o) (gapTo s o') → better o' o) :
    Nearing ds s better :=
  fun o o' nearer => falls o o' nearer.gaps

/-- **The order by distance nears the set point.** -/
theorem byGap_nearing (ds : List C) (s : C → Nat) : Nearing ds s (byGap ds s) :=
  nearing_of_gaps fun _ _ farther => Exceeds.total_lt farther

/-- **An order ranking above wherever a nearing order does is nearing.** -/
theorem Nearing.mono (nearing : Nearing ds s better) {better' : (C → Nat) → (C → Nat) → Prop}
    (above : ∀ o' o, better o' o → better' o' o) : Nearing ds s better' :=
  fun o o' nearer => above o' o (nearing o o' nearer)

/-- At the set point an outcome has no gap from it. -/
theorem gapTo_eq_zero {o : C → Nat} (at_ : AtSetPoint ds s o) {c : C} (mem : c ∈ ds) :
    gapTo s o c = 0 :=
  (congrArg (gap · (s c)) (at_ c mem)).trans (gap_self (s c))

/-- At the set point the family's total gap is nothing. -/
theorem total_gapTo_eq_zero {o : C → Nat} (at_ : AtSetPoint ds s o) : total ds (gapTo s o) = 0 :=
  (total_congr_on fun _ mem => gapTo_eq_zero at_ mem).trans (total_zero ds)

/-- A family of one condition is at its set point where that condition is. -/
theorem atSetPoint_single {c : C} {o : C → Nat} (at_ : o c = s c) : AtSetPoint [c] s o :=
  fun _ mem => match mem_cons_cases mem with
    | .inl same => Eq.subst (motive := fun y => o y = s y) same.symm at_
    | .inr nothing => nomatch nothing

/-- **No outcome ranks above one at the set point by distance**: the order's point of enough. -/
theorem byGap_unbeaten_at {o₀ : C → Nat} (at₀ : AtSetPoint ds s o₀) (o : C → Nat) :
    ¬ byGap ds s o o₀ :=
  fun above => Nat.not_lt_zero _
    (Nat.lt_of_lt_of_le above (Nat.le_of_eq (total_gapTo_eq_zero at₀)))

/-- An eligible outcome at the set point is an optimum of the order by distance. -/
theorem atSetPoint_frontier {o₀ : C → Nat} (eligibleO : eligible o₀) (at₀ : AtSetPoint ds s o₀) :
    Frontier eligible (byGap ds s) o₀ :=
  ⟨eligibleO, fun o _ above => byGap_unbeaten_at at₀ o above⟩

/-- **An order under which some outcome is ranked below none is not rising.** Where the family
holds a condition, the outcome one higher everywhere exceeds it on the family. -/
theorem not_rising_of_unbeaten {o₀ : C → Nat} (unbeaten : ∀ o, ¬ better o o₀) {d : C}
    (inside : d ∈ ds) : ¬ Rising ds better :=
  fun rising => unbeaten _
    (rising o₀ (fun x => o₀ x + 1) ⟨fun _ _ => Nat.le_succ _, d, inside, Nat.lt_succ_self _⟩)

/-- **The order by distance is not rising**, where the family holds a condition. -/
theorem byGap_not_rising {d : C} (inside : d ∈ ds) : ¬ Rising ds (byGap ds s) :=
  not_rising_of_unbeaten (byGap_unbeaten_at (o₀ := s) fun _ _ => rfl) inside

/-- An outcome at the set point is nearer it than every outcome off it at a condition of the
family. -/
theorem nearer_of_atSetPoint {o₀ o : C → Nat} (at₀ : AtSetPoint ds s o₀) {c : C} (mem : c ∈ ds)
    (off : ¬ o c = s c) : Nearer ds s o₀ o :=
  ⟨fun x listed => Eq.subst (motive := fun y => Regulation.Between (s x) (o x) y)
      (at₀ x listed).symm (setPoint_between (s x) (o x)),
   c, mem, Nat.lt_of_le_of_lt (Nat.le_of_eq (gapTo_eq_zero at₀ mem))
     (Nat.pos_of_ne_zero fun zero => off (gap_eq_zero_iff.mp zero))⟩

/-- **No asymmetric nearing order is rising.** Where the family holds a condition, an order that is
nearing and never ranks two outcomes above each other does not rise with the family: the set point
and the outcome one above it at every condition would each rank above the other. -/
theorem Nearing.not_rising (nearing : Nearing ds s better)
    (asymm : ∀ o o', better o' o → ¬ better o o') {d : C} (inside : d ∈ ds) :
    ¬ Rising ds better :=
  fun rising => asymm s (fun x => s x + 1)
    (rising s _ ⟨fun _ _ => Nat.le_succ _, d, inside, Nat.lt_succ_self _⟩)
    (nearing (fun x => s x + 1) s
      (nearer_of_atSetPoint (fun _ _ => rfl) inside (Nat.succ_ne_self (s d))))

/-- **Every optimum at the set point, exactly.** Every order nearing a set point has its optima
at the set point exactly where every eligible outcome off it at a condition of the family is not
unbeaten by an eligible outcome nearer it. -/
theorem atSetPoint_iff :
    (∀ better, Nearing ds s better → ∀ o, Frontier eligible better o → AtSetPoint ds s o) ↔
      ∀ o, eligible o → ∀ c, c ∈ ds → ¬ o c = s c →
        ¬ ¬ ∃ o'', eligible o'' ∧ Nearer ds s o'' o :=
  ⟨fun atSet o eligibleO c mem off unbeaten =>
      off (atSet (fun o₁ o₂ => Nearer ds s o₁ o₂) (fun _ _ nearer => nearer) o
        ⟨eligibleO, fun o'' eligible'' nearer => unbeaten ⟨o'', eligible'', nearer⟩⟩ c mem),
   fun beaten _ nearing o optimum c mem => match Nat.decEq (o c) (s c) with
     | .isTrue same => same
     | .isFalse off => absurd
         (fun ⟨o'', eligible'', nearer⟩ => optimum.2 o'' eligible'' (nearing o o'' nearer))
         (beaten o optimum.1 c mem off)⟩

/-- **Where the set point can be reached, every optimum stands at it.** Where some eligible
outcome stands at the set point, every optimum of every order nearing it does. -/
theorem atSetPoint_of_reach (nearing : Nearing ds s better) {o₀ : C → Nat} (reach : eligible o₀)
    (at₀ : AtSetPoint ds s o₀) {o : C → Nat} (optimum : Frontier eligible better o) :
    AtSetPoint ds s o :=
  atSetPoint_iff.mpr
    (fun _ _ _ mem off unreached => unreached ⟨o₀, reach, nearer_of_atSetPoint at₀ mem off⟩)
    better nearing o optimum

/-- **Several optimizers each reaching its set point stand at their joint set point.** Where the
levels are, for each of several optimizers, an optimum among the outcomes eligible to it of an
order nearing a set point on its family, one of those outcomes standing at the set point, the
levels stand at the set point on every family the optimizers' families cover. -/
theorem mutual_atSetPoint {I : Type} {opt : List I} {fam : I → List C}
    {elig : I → (C → Nat) → Prop} {orders : I → (C → Nat) → (C → Nat) → Prop} {o : C → Nat}
    (covered : ∀ c, c ∈ ds → ∃ i, i ∈ opt ∧ c ∈ fam i)
    (nearing : ∀ i, i ∈ opt → Nearing (fam i) s (orders i))
    (reach : ∀ i, i ∈ opt → ∃ o₀, elig i o₀ ∧ AtSetPoint (fam i) s o₀)
    (best : ∀ i, i ∈ opt → Frontier (elig i) (orders i) o) : AtSetPoint ds s o :=
  fun c mem => match covered c mem with
    | ⟨i, listed, inside⟩ => match reach i listed with
      | ⟨_, eligible₀, at₀⟩ =>
        atSetPoint_of_reach (nearing i listed) eligible₀ at₀ (best i listed) c inside

/-- **Nearing alone asks nothing of what lies beyond.** Where some eligible outcome stands at the
set point, an outcome is an optimum of some nearing order exactly where it is eligible and at the
set point. -/
theorem optima_iff {o₀ : C → Nat} (reach : eligible o₀) (at₀ : AtSetPoint ds s o₀) {o : C → Nat} :
    (∃ better, Nearing ds s better ∧ Frontier eligible better o) ↔
      (eligible o ∧ AtSetPoint ds s o) :=
  ⟨fun ⟨_, nearing, optimum⟩ => ⟨optimum.1, atSetPoint_of_reach nearing reach at₀ optimum⟩,
   fun ⟨eligibleO, atO⟩ => ⟨byGap ds s, byGap_nearing ds s, atSetPoint_frontier eligibleO atO⟩⟩

/-- **At the set point, the least level beyond, for the class, only where every way of reaching it
leaves the same.** Where some eligible outcome stands at the set point, every optimum of every order
nearing it stands beyond at the least level among the eligible outcomes at the set point exactly
where those outcomes all stand alike beyond. This is a statement about the class: its forward
direction uses only the order by distance, which is indifferent to what lies beyond, while one
nearing order can still drive what lies beyond through what it counts after the set point
(`counted_after_most`). No room enters. -/
theorem least_at_iff {o₀ : C → Nat} (reach : eligible o₀) (at₀ : AtSetPoint ds s o₀) :
    (∀ better, Nearing ds s better → ∀ o, Frontier eligible better o →
        Least rest (fun o => eligible o ∧ AtSetPoint ds s o) o) ↔
      ∀ o o', eligible o → AtSetPoint ds s o → eligible o' → AtSetPoint ds s o' →
        ∀ c, c ∈ rest → o c = o' c :=
  ⟨fun least o o' eligibleO atO eligibleO' atO' c mem =>
      Nat.le_antisymm
        (least (byGap ds s) (byGap_nearing ds s) o (atSetPoint_frontier eligibleO atO) c mem o'
          ⟨eligibleO', atO'⟩)
        (least (byGap ds s) (byGap_nearing ds s) o' (atSetPoint_frontier eligibleO' atO') c mem o
          ⟨eligibleO, atO⟩),
   fun alike _ nearing o optimum c mem o' reached =>
      Nat.le_of_eq (alike o o' optimum.1 (atSetPoint_of_reach nearing reach at₀ optimum)
        reached.1 reached.2 c mem)⟩

/-- The order by distance from a set point with what lies beyond counted after: nearer first, and
among outcomes as near, more beyond in total. -/
def byGapThen (ds : List C) (s : C → Nat) (rest : List C) (o' o : C → Nat) : Prop :=
  byGap ds s o' o ∨
    (total ds (gapTo s o') = total ds (gapTo s o) ∧ total rest o < total rest o')

/-- The order by distance with the beyond counted after nears the set point. -/
theorem byGapThen_nearing : Nearing ds s (byGapThen ds s rest) :=
  (byGap_nearing ds s).mono fun _ _ nearer => .inl nearer

/-- The order by distance with the beyond counted after never ranks two outcomes above each
other. -/
theorem byGapThen_asymm : ∀ o o', byGapThen ds s rest o' o → ¬ byGapThen ds s rest o o' :=
  fun _ _ above below => match above, below with
    | .inl closer, .inl closer' => Nat.lt_irrefl _ (Nat.lt_trans closer closer')
    | .inl closer, .inr ⟨same, _⟩ =>
      Nat.lt_irrefl _ (Nat.lt_of_lt_of_le closer (Nat.le_of_eq same))
    | .inr ⟨same, _⟩, .inl closer =>
      Nat.lt_irrefl _ (Nat.lt_of_lt_of_le closer (Nat.le_of_eq same))
    | .inr ⟨_, more⟩, .inr ⟨_, more'⟩ => Nat.lt_irrefl _ (Nat.lt_trans more more')

/-- **The order by distance with the beyond counted after is not rising**, where the family holds
a condition. -/
theorem byGapThen_not_rising {d : C} (inside : d ∈ ds) : ¬ Rising ds (byGapThen ds s rest) :=
  byGapThen_nearing.not_rising byGapThen_asymm inside

/-- **Counted after the set point, the most beyond, in total, that any way of reaching it leaves.**
Where some eligible outcome stands at the set point, every optimum of the order by distance with
the beyond counted after stands at the set point and leaves the beyond, in total, at least where
every eligible outcome at the set point does. It maximizes the total, not each condition
(`Spread.counted_after_empties`), and keeps a need only where some way of reaching the set point
keeps it (`counted_after_keeps_iff`). -/
theorem counted_after_most {o₀ : C → Nat} (reach : eligible o₀) (at₀ : AtSetPoint ds s o₀)
    {o : C → Nat} (optimum : Frontier eligible (byGapThen ds s rest) o) :
    AtSetPoint ds s o ∧ ∀ o', eligible o' → AtSetPoint ds s o' → total rest o' ≤ total rest o :=
  have atO := atSetPoint_of_reach byGapThen_nearing reach at₀ optimum
  ⟨atO, fun o' eligibleO' atO' => Nat.ge_of_not_lt fun more => optimum.2 o' eligibleO'
    (.inr ⟨(total_gapTo_eq_zero atO').trans (total_gapTo_eq_zero atO).symm, more⟩)⟩

/-- **With one condition beyond, counted after the set point keeps a need exactly where some way of
reaching the set point keeps it.** -/
theorem counted_after_keeps_iff {c : C} {need : Nat} {o₀ : C → Nat} (reach : eligible o₀)
    (at₀ : AtSetPoint ds s o₀) {o : C → Nat}
    (optimum : Frontier eligible (byGapThen ds s [c]) o) :
    need ≤ o c ↔ ∃ o', eligible o' ∧ AtSetPoint ds s o' ∧ need ≤ o' c :=
  ⟨fun kept => ⟨o, optimum.1, (counted_after_most reach at₀ optimum).1, kept⟩,
   fun ⟨o', eligible', at', kept'⟩ => Nat.le_trans kept'
     (le_of_add_le_add_right 0 ((counted_after_most reach at₀ optimum).2 o' eligible' at'))⟩

/-- The order by distance from a set point with less beyond counted after: nearer first, and among
outcomes as near, less beyond in total. -/
def byGapLess (ds : List C) (s : C → Nat) (rest : List C) (o' o : C → Nat) : Prop :=
  byGap ds s o' o ∨
    (total ds (gapTo s o') = total ds (gapTo s o) ∧ total rest o' < total rest o)

/-- The order by distance with less beyond counted after nears the set point. -/
theorem byGapLess_nearing : Nearing ds s (byGapLess ds s rest) :=
  (byGap_nearing ds s).mono fun _ _ nearer => .inl nearer

/-! ## Below the set point, a nearing order rises

Up to the set point, nearer is higher, so the drive of `Optimum.least_iff` returns there. -/

/-- Up to a bound, one shortfall is at most another exactly where its amount is at least the
other's: within the bound, the converse of `sub_le_sub_left_of_le`. -/
theorem sub_le_sub_iff {a b n : Nat} (an : a ≤ n) (bn : b ≤ n) : n - b ≤ n - a ↔ a ≤ b :=
  ⟨fun le => le_of_add_le_add_right (n - b) (Nat.le_trans (Nat.add_le_add_left le a)
      (Nat.le_of_eq ((add_sub_of_le an).trans (add_sub_of_le bn).symm))),
   fun le => sub_le_sub_left_of_le le n⟩

/-- Up to a bound, one shortfall is less than another exactly where its amount is greater: with
its converse, `Requirement.Formation.sub_lt_sub_of_lt`. -/
theorem sub_lt_sub_iff {a b n : Nat} (bn : b ≤ n) : n - b < n - a ↔ a < b :=
  ⟨fun lt => Nat.lt_of_not_le fun le => Nat.not_le_of_gt lt (sub_le_sub_left_of_le le n),
   fun lt => Requirement.Formation.sub_lt_sub_of_lt lt bn⟩

/-- Up to the set point, the gap at a condition of the family is what it falls short. -/
theorem gapTo_of_upTo {o : C → Nat} (upTo : UpToSetPoint ds s o) {c : C} (mem : c ∈ ds) :
    gapTo s o c = s c - o c :=
  Regulation.gap_of_ge (upTo c mem)

/-- **Up to the set point, nearer is higher.** For outcomes up to the set point, one is nearer it
than another on the family exactly where it exceeds the other there. -/
theorem nearer_iff_exceeds {o o' : C → Nat} (upTo : UpToSetPoint ds s o)
    (upTo' : UpToSetPoint ds s o') : Nearer ds s o' o ↔ Exceeds ds o' o :=
  ⟨fun ⟨between, c, mem, lt⟩ =>
    ⟨fun x listed => ((between x listed).2 (upTo x listed)).1,
     c, mem, (sub_lt_sub_iff (upTo' c mem)).mp
        (Nat.lt_of_le_of_lt (Nat.le_of_eq (gapTo_of_upTo upTo' mem).symm)
          (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (gapTo_of_upTo upTo mem))))⟩,
   fun ⟨le, c, mem, lt⟩ =>
    ⟨fun x listed =>
      ⟨fun sx => ⟨Nat.le_trans sx (le x listed), Nat.le_trans (upTo' x listed) sx⟩,
       fun _ => ⟨le x listed, upTo' x listed⟩⟩,
     c, mem, Nat.lt_of_le_of_lt (Nat.le_of_eq (gapTo_of_upTo upTo' mem))
        (Nat.lt_of_lt_of_le ((sub_lt_sub_iff (upTo' c mem)).mpr lt)
          (Nat.le_of_eq (gapTo_of_upTo upTo mem).symm))⟩⟩

/-- **Below its set point a nearing order rises.** Among outcomes up to the set point, a nearing
order ranks above every outcome exceeding another on the family. -/
theorem Nearing.rises_below (nearing : Nearing ds s better) {o o' : C → Nat}
    (upTo : UpToSetPoint ds s o) (upTo' : UpToSetPoint ds s o') (exceeds : Exceeds ds o' o) :
    better o' o :=
  nearing o o' ((nearer_iff_exceeds upTo upTo').mpr exceeds)

/-- **The drive below the set point to the least level, exactly.** Among the eligible outcomes up
to the set point, every order nearing it has its optima at the least level beyond among them
exactly where every such outcome standing above another such outcome at a condition beyond is not
unbeaten on the family by one: `least_iff` read up to the set point. -/
theorem least_below_iff :
    (∀ better, Nearing ds s better → ∀ o,
        Frontier (fun o => eligible o ∧ UpToSetPoint ds s o) better o →
        Least rest (fun o => eligible o ∧ UpToSetPoint ds s o) o) ↔
      ∀ o o', (eligible o ∧ UpToSetPoint ds s o) → (eligible o' ∧ UpToSetPoint ds s o') →
        ∀ c, c ∈ rest → o' c < o c →
          ¬ ¬ ∃ o'', (eligible o'' ∧ UpToSetPoint ds s o'') ∧ Exceeds ds o'' o :=
  ⟨fun drives => (least_iff (ds := ds) (rest := rest)
      (eligible := fun o => eligible o ∧ UpToSetPoint ds s o)).mp fun better rising o optimum =>
      drives (fun o₁ o₂ => better o₁ o₂ ∨ Nearer ds s o₁ o₂) (fun _ _ nearer => .inr nearer) o
        ⟨optimum.1, fun o'' eligible'' above => match above with
          | .inl ranked => optimum.2 o'' eligible'' ranked
          | .inr nearer => optimum.2 o'' eligible''
              (rising o o'' ((nearer_iff_exceeds optimum.1.2 eligible''.2).mp nearer))⟩,
   fun beaten better nearing o optimum => (least_iff (ds := ds) (rest := rest)
      (eligible := fun o => eligible o ∧ UpToSetPoint ds s o)).mpr beaten
      (fun o₁ o₂ => better o₁ o₂ ∨ Exceeds ds o₁ o₂) (fun _ _ exceeds => .inr exceeds) o
      ⟨optimum.1, fun o'' eligible'' above => match above with
        | .inl ranked => optimum.2 o'' eligible'' ranked
        | .inr exceeds => optimum.2 o'' eligible''
            (nearing.rises_below optimum.1.2 eligible''.2 exceeds)⟩⟩

/-- **With room up to the set point, every optimum is at the least level beyond.** Where room holds
among the eligible outcomes up to the set point, every optimum among them of every order nearing
it stands at the least level beyond among them. -/
theorem least_below (nearing : Nearing ds s better)
    (room : Room ds rest fun o => eligible o ∧ UpToSetPoint ds s o) {o : C → Nat}
    (optimum : Frontier (fun o => eligible o ∧ UpToSetPoint ds s o) better o) :
    Least rest (fun o => eligible o ∧ UpToSetPoint ds s o) o :=
  least_below_iff.mpr (fun o o' eligibleO eligibleO' c mem lower unbeaten =>
    unbeaten (room o o' eligibleO eligibleO' c mem lower)) better nearing o optimum

end Optimum

/-! ## What reaching the set point draws

On a balanced step in which the whole gains nothing, the family's rise to its set point is paid
from beyond, with what the step loses: `Flow.Balances.beyond_falls_exactly` read at the set
point. -/

namespace Flow

variable {L : Flow F C} {W : Web F C} {ds rest : List C} {s : C → Nat} {t : Nat}
  {eligible : (C → Nat) → Prop} {better : (C → Nat) → (C → Nat) → Prop}

/-- **At the set point the draw is the set point's.** In a balanced flow, where the family with
the conditions beyond it gains nothing across a step and the family stands at its set point after
the step, the beyond after the step, with what the whole loses across it and the set point's
total, is the family and the beyond before. -/
theorem Balances.atSetPoint_draws (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (atSet : Optimum.AtSetPoint ds s (W.level (t + 1))) :
    W.stock rest (t + 1) + L.lost (ds ++ rest) t + total ds s = W.stock ds t + W.stock rest t :=
  have family : W.stock ds (t + 1) = total ds s := total_congr_on atSet
  (Nat.add_comm _ _).trans ((Nat.add_assoc _ _ _).symm.trans
    ((congrArg (· + W.stock rest (t + 1) + L.lost (ds ++ rest) t) family.symm).trans
      (balances.beyond_falls_exactly gainless)))

/-- **Holding the set point, the beyond falls by the loss.** Where the family stands at its set
point before and after a balanced step in which the whole gains nothing, the beyond after the
step, with what the whole loses, is the beyond before. -/
theorem Balances.held_draws_lost (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (before : Optimum.AtSetPoint ds s (W.level t))
    (after : Optimum.AtSetPoint ds s (W.level (t + 1))) :
    W.stock rest (t + 1) + L.lost (ds ++ rest) t = W.stock rest t :=
  add_right_cancel (total ds s) ((balances.atSetPoint_draws gainless after).trans
    ((congrArg (· + W.stock rest t) (total_congr_on before)).trans (Nat.add_comm _ _)))

/-- **Past the slack, the set point breaks some dependence beyond.** Where, besides, each condition
beyond is depended on at a need it meets, and the set point's total with what the whole loses
exceeds the family before with the slack, one of those dependences is broken across the step. With
several conditions beyond this is sufficient, not necessary: the draw's total is fixed, not its
spread. -/
theorem Balances.atSetPoint_breaks {dep : C → F} (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (atSet : Optimum.AtSetPoint ds s (W.level (t + 1)))
    (exceeds : W.stock ds t + W.slack dep rest t < total ds s + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  balances.breaks_beyond gainless met (Eq.subst
    (motive := fun y => W.stock ds t + W.slack dep rest t < y + L.lost (ds ++ rest) t)
    (total_congr_on atSet).symm exceeds)

/-- **With one condition beyond, exactly.** Where the beyond is one condition depended on at a
need it meets, the set point breaks the dependence across a balanced step in which the whole gains
nothing exactly where the set point's total with what the whole loses exceeds the family before
with the slack. -/
theorem Balances.atSetPoint_broken_iff {dep : C → F} {c : C} (balances : L.Balances W)
    (gainless : L.GainlessOn (ds ++ [c]) t) (met : W.MetOn dep [c] t)
    (atSet : Optimum.AtSetPoint ds s (W.level (t + 1))) :
    W.Broken t (dep c) c ↔
      W.stock ds t + (W.level t c - W.need t (dep c) c) < total ds s + L.lost (ds ++ [c]) t :=
  have meets := (met c (.head [])).2
  have exact : W.level (t + 1) c + 0 + L.lost (ds ++ [c]) t + total ds s =
      W.stock ds t + (W.level t c + 0) := balances.atSetPoint_draws gainless atSet
  have key : W.level (t + 1) c + (total ds s + L.lost (ds ++ [c]) t) =
      W.need t (dep c) c + (W.stock ds t + (W.level t c - W.need t (dep c) c)) :=
    (congrArg (W.level (t + 1) c + ·) (Nat.add_comm _ _)).trans
      ((Nat.add_assoc _ _ _).symm.trans
        ((congrArg (· + L.lost (ds ++ [c]) t + total ds s) (Nat.add_zero _).symm).trans
          (exact.trans ((congrArg (W.stock ds t + ·) ((Nat.add_zero _).trans
            (add_sub_of_le meets).symm)).trans (Nat.add_left_comm _ _ _)))))
  ⟨fun broken => Nat.lt_of_add_lt_add_left (n := W.need t (dep c) c)
      (Nat.lt_of_le_of_lt (Nat.le_of_eq key.symm) (Nat.add_lt_add_right broken.2.2 _)),
   fun below => ⟨(met c (.head [])).1, meets, Nat.lt_of_add_lt_add_right
      (Nat.lt_of_le_of_lt (Nat.le_of_eq key) (Nat.add_lt_add_left below _))⟩⟩

/-- **Every optimum of a nearing order draws what the set point draws.** In a balanced flow gaining
nothing on the whole across a step, where the levels after the step are an optimum, among eligible
outcomes one of which stands at the set point, of an order nearing it, the beyond after the step
with what the whole loses and the set point's total is the family and the beyond before. -/
theorem nearing_optimum_draws (balances : L.Balances W) (gainless : L.GainlessOn (ds ++ rest) t)
    (nearing : Optimum.Nearing ds s better) {o₀ : C → Nat} (reach : eligible o₀)
    (at₀ : Optimum.AtSetPoint ds s o₀) (optimum : Frontier eligible better (W.level (t + 1))) :
    W.stock rest (t + 1) + L.lost (ds ++ rest) t + total ds s = W.stock ds t + W.stock rest t :=
  balances.atSetPoint_draws gainless (Optimum.atSetPoint_of_reach nearing reach at₀ optimum)

/-- **Several nearing optimizers at once draw their joint shortfall, as one.** In a balanced flow
gaining nothing on the whole across a step, where the levels after the step are, for each of
several optimizers, an optimum among the outcomes eligible to it of an order nearing its set point
on its family, each set point reached by an outcome eligible to its optimizer, and the family is
covered by theirs, the beyond after the step with what the whole loses and the joint set point's
total is the family and the beyond before: what one optimizer with their joint set point draws. -/
theorem Balances.mutual_atSetPoint_draws {I : Type} {opt : List I} {fam : I → List C}
    {elig : I → (C → Nat) → Prop} {orders : I → (C → Nat) → (C → Nat) → Prop}
    (balances : L.Balances W) (gainless : L.GainlessOn (ds ++ rest) t)
    (covered : ∀ c, c ∈ ds → ∃ i, i ∈ opt ∧ c ∈ fam i)
    (nearing : ∀ i, i ∈ opt → Optimum.Nearing (fam i) s (orders i))
    (reach : ∀ i, i ∈ opt → ∃ o₀, elig i o₀ ∧ Optimum.AtSetPoint (fam i) s o₀)
    (best : ∀ i, i ∈ opt → Frontier (elig i) (orders i) (W.level (t + 1))) :
    W.stock rest (t + 1) + L.lost (ds ++ rest) t + total ds s = W.stock ds t + W.stock rest t :=
  balances.atSetPoint_draws gainless (Optimum.mutual_atSetPoint covered nearing reach best)

/-- **Together past the slack, whatever each one's shortfall, they break a dependence beyond.**
Under the conditions of `Flow.Balances.mutual_atSetPoint_draws`, each condition beyond depended on
at a need it meets, where the joint set point's total with what the whole loses exceeds the family
before with the slack, one of those dependences is broken across the step. -/
theorem Balances.mutual_atSetPoint_breaks {I : Type} {opt : List I} {fam : I → List C}
    {elig : I → (C → Nat) → Prop} {orders : I → (C → Nat) → (C → Nat) → Prop} {dep : C → F}
    (balances : L.Balances W) (gainless : L.GainlessOn (ds ++ rest) t) (met : W.MetOn dep rest t)
    (covered : ∀ c, c ∈ ds → ∃ i, i ∈ opt ∧ c ∈ fam i)
    (nearing : ∀ i, i ∈ opt → Optimum.Nearing (fam i) s (orders i))
    (reach : ∀ i, i ∈ opt → ∃ o₀, elig i o₀ ∧ Optimum.AtSetPoint (fam i) s o₀)
    (best : ∀ i, i ∈ opt → Frontier (elig i) (orders i) (W.level (t + 1)))
    (exceeds : W.stock ds t + W.slack dep rest t < total ds s + L.lost (ds ++ rest) t) :
    ∃ c, c ∈ rest ∧ W.Broken t (dep c) c :=
  balances.atSetPoint_breaks gainless met (Optimum.mutual_atSetPoint covered nearing reach best)
    exceeds

end Flow

/-! ## In the exchange: below the set point, the whole capacity

Among the outcomes open to a part across one step of exchange (`Flow.Outcome`), an optimum takes
the part's whole capacity beyond wherever a unit moved from there into the family ranks above it
(`Optimum.beyond_of_ranked`): for a rising order everywhere, for a nearing order wherever the family
stands below its set point. -/

namespace Optimum

open Flow

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {t : Nat} {l : C → Nat}
  {ds rest : List C} {s : C → Nat} {better : (C → Nat) → (C → Nat) → Prop}

/-- **A unit moved into the family below its set point is nearer it.** One unit moved from a
condition outside the family into a condition of the family standing below its set point gives an
outcome nearer the set point on the family. -/
theorem transfer_nearer [DecidableEq C] {c d : C} (out : ¬ c ∈ ds) (inside : d ∈ ds)
    {o : C → Nat} (short : o d < s d) : Nearer ds s (transfer c d o) o :=
  have kept : ∀ x, x ∈ ds → transfer c d o x = if x = d then o d + 1 else o x :=
    fun _ listed => if_neg fun same => out (Eq.subst (motive := fun y => y ∈ ds) same listed)
  have atD : transfer c d o d = o d + 1 := (kept d inside).trans (if_pos rfl)
  ⟨fun x listed => match decEq x d with
    | .isTrue same =>
      have shortX : o x < s x := Eq.subst (motive := fun y => o y < s y) same.symm short
      have atX : transfer c d o x = o x + 1 :=
        (kept x listed).trans ((if_pos same).trans (congrArg (o · + 1) same.symm))
      Eq.subst (motive := fun y => Regulation.Between (s x) (o x) y) atX.symm
        ⟨fun sx => absurd shortX (Nat.not_lt_of_le sx), fun _ => ⟨Nat.le_succ (o x), shortX⟩⟩
    | .isFalse other => Eq.subst (motive := fun y => Regulation.Between (s x) (o x) y)
        ((kept x listed).trans (if_neg other)).symm (Regulation.Between.refl (s x) (o x)),
   d, inside,
   Nat.lt_of_le_of_lt
      (Nat.le_of_eq ((congrArg (gap · (s d)) atD).trans
        (Regulation.gap_of_ge (short : o d + 1 ≤ s d))))
      (Nat.lt_of_lt_of_le ((sub_lt_sub_iff (short : o d + 1 ≤ s d)).mpr (Nat.lt_succ_self _))
        (Nat.le_of_eq (Regulation.gap_of_ge (Nat.le_of_lt short)).symm))⟩

/-- **Below its set point, a nearing optimum draws the whole capacity beyond.** Among the outcomes
open to a part, every optimum of every order nearing a set point of the family that stands below
the set point at a condition of the family stands at each condition beyond at the level before,
with what the rest gives and less what it takes, less the part's whole capacity, or at nothing:
`beyond_of_ranked`, the unit moved in being nearer. -/
theorem nearing_beyond [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (nearing : Nearing ds s better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) (short : o d < s d)
    {c : C} (mem : c ∈ rest) :
    o c = l c + L.restGiven part t c - L.restTaken part t c - L.capacity part cap t c :=
  beyond_of_ranked distinct cdistinct apart inside optimum mem
    (nearing o _ (transfer_nearer (apart c mem) inside short))

/-- **Below its set point, a nearing optimum stands beyond where every rising optimum does.**
Among the outcomes open to a part, an optimum of an order nearing a set point that stands below
it at a condition of the family stands at each condition beyond where every optimum of every
order rising with the family stands. -/
theorem nearing_as_rising [DecidableEq F] [DecidableEq C] (distinct : Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {d : C}
    (inside : d ∈ ds) (nearing : Nearing ds s better) {o : C → Nat}
    (optimum : Frontier (L.Outcome part l cap (ds ++ rest) t) better o) (short : o d < s d)
    {better' : (C → Nat) → (C → Nat) → Prop} (rising : Rising ds better') {o' : C → Nat}
    (optimum' : Frontier (L.Outcome part l cap (ds ++ rest) t) better' o') {c : C}
    (mem : c ∈ rest) : o c = o' c :=
  (nearing_beyond distinct cdistinct apart inside nearing optimum short mem).trans
    (optimum_beyond distinct cdistinct apart inside rising optimum' mem).symm

end Optimum

/-! ## Formations holding their levels: joint excess

A formation holding its family's stock while it loses takes at least what it loses from beyond;
the joint excess of `Flow.joint_excess_ends` follows where several so take from one condition. No
order or choice enters. -/

/-- Over a list without repetition, a quantity that is nothing at every member but one totals at
most its value at that one: `total_le_at` read on the list alone. -/
theorem Optimum.total_le_of_only {α : Type} [DecidableEq α] {q : α → Nat} {a : α} {l : List α}
    (distinct : Distinct l) (only : ∀ b, b ∈ l → ¬ b = a → q b = 0) : total l q ≤ q a :=
  Nat.le_trans (Nat.le_of_eq (total_congr_on (g := fun b => if b = a then q a else 0)
      fun b mem => match decEq b a with
        | .isTrue same => (congrArg q same).trans (if_pos same).symm
        | .isFalse other => (only b mem other).trans (if_neg other).symm))
    (Nat.le_trans (total_le_at (fun b pos => match decEq b a with
        | .isTrue same => same
        | .isFalse other => absurd pos (Nat.not_lt_of_le (Nat.le_of_eq (if_neg other))))
        distinct)
      (Nat.le_of_eq (if_pos rfl)))

/-- **A family at its set point at two steps holds its stock between them.** -/
theorem Optimum.stock_eq_of_atSetPoint {W : Web F C} {fam : List C} {s : C → Nat} {t u : Nat}
    (atT : Optimum.AtSetPoint fam s (W.level t)) (atU : Optimum.AtSetPoint fam s (W.level u)) :
    W.stock fam u = W.stock fam t :=
  (total_congr_on atU).trans (total_congr_on atT).symm

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- **Holding its family's stock, a formation takes at least what it loses.** Where across the step
from `t` the flow balances on a family, no other formation taking part exchanges with the family,
and the family's stock after the step is its stock before, a formation taking part that gives the
family and a condition `c`, with `l`, at most what it takes from them takes from `c` at least what
it gives there with `l`. -/
theorem held_draws [DecidableEq F] {fam : List C} {t : Nat} {h : F} {c : C} {l : Nat}
    (balances : L.BalancesOn W fam t) (distinct : Distinct (L.present t))
    (present : h ∈ L.present t)
    (alone : ∀ g, g ∈ L.present t → ¬ g = h → ∀ x, x ∈ fam →
      L.take t g x = 0 ∧ L.give t g x = 0)
    (held : W.stock fam (t + 1) = W.stock fam t)
    (loses : l + total fam (L.give t h) + L.give t h c ≤ total fam (L.take t h) + L.take t h c) :
    l + L.give t h c ≤ L.take t h c :=
  have takes : total fam (L.take t h) ≤ L.uptake fam t :=
    total_le fam fun x _ => le_total_of_mem (q := fun g => L.take t g x) present
  have gives : L.replenishment fam t ≤ total fam (L.give t h) :=
    total_le fam fun x mem => Optimum.total_le_of_only (q := fun g => L.give t g x) distinct
      fun g listed other => (alone g listed other x mem).2
  have within : L.uptake fam t ≤ L.replenishment fam t :=
    Naturals.le_of_add_le_add_left (k := W.stock fam t)
      (Nat.le_of_eq ((congrArg (· + L.uptake fam t) held.symm).trans balances.over))
  le_of_add_le_add_right (total fam (L.give t h))
    (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ _ _))
      (Nat.le_trans loses (Nat.le_trans
        (Nat.add_le_add_right (Nat.le_trans takes (Nat.le_trans within gives)) _)
        (Nat.le_of_eq (Nat.add_comm _ _)))))

/-- **Formations holding their levels, losing together more than a condition is given, end it.**
Across `n` steps from `T`, let each formation of a part (`holders`) taking part hold its family's
stock, alone exchanging with the family, and lose at least a given amount on its family with a
condition `c`. Where at each step the part's losses together exceed what the formations outside it
give `c`, and the level of `c` at `T` is below `n + m`, under the gate at need `m` every formation
depending on `c` at a need of at least `m` is inactive from `T + n` on, however small each member's
loss, each within what the step gives included; and where each member's couplings lie in its
family, apart from `c`, no member couples into `c`. Derived from `Flow.joint_excess_ends`. -/
theorem held_excess_ends [DecidableEq F] (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → 0 < L.give t f c → W.requires t f c ∧ m ≤ W.need t f c)
    {holders : F → Bool} {fam : F → List C} {lose : Nat → F → Nat} {T n : Nat}
    (distinct : ∀ k, k < n → Distinct (L.present (T + k)))
    (alone : ∀ k, k < n → ∀ h, h ∈ L.present (T + k) → holders h = true →
      ∀ g, g ∈ L.present (T + k) → ¬ g = h → ∀ x, x ∈ fam h →
        L.take (T + k) g x = 0 ∧ L.give (T + k) g x = 0)
    (held : ∀ k, k < n → ∀ h, h ∈ L.present (T + k) → holders h = true →
      W.stock (fam h) (T + k + 1) = W.stock (fam h) (T + k))
    (loses : ∀ k, k < n → ∀ h, h ∈ L.present (T + k) → holders h = true →
      lose (T + k) h + total (fam h) (L.give (T + k) h) + L.give (T + k) h c ≤
        total (fam h) (L.take (T + k) h) + L.take (T + k) h c)
    (exceeds : ∀ k, k < n → L.restGiven holders (T + k) c <
      total (L.present (T + k)) fun h => bif holders h then lose (T + k) h else 0)
    (start : W.level T c < n + m) {obs : F → C → Prop}
    (listed : ∀ h x, holders h = true → W.CoupledInto obs h x → x ∈ fam h)
    (apart : ∀ h, holders h = true → ¬ c ∈ fam h) :
    (∀ k g, W.requires (T + n + k) g c → m ≤ W.need (T + n + k) g c →
      ¬ W.active (T + n + k) g) ∧
      ∀ h, holders h = true → ¬ W.CoupledInto obs h c :=
  ⟨joint_excess_ends balances acting dependent gated (fun k below => by
    have draws : ∀ h, h ∈ L.present (T + k) →
        (bif holders h then lose (T + k) h + L.give (T + k) h c else 0) ≤
          (bif holders h then L.take (T + k) h c else 0) := fun h mem => by
      cases holds : holders h
      · exact Nat.le_refl 0
      · exact held_draws (balances.on (fam h) (T + k)) (distinct k below) mem
          (alone k below h mem holds) (held k below h mem holds) (loses k below h mem holds)
    have split : (total (L.present (T + k)) fun h =>
        bif holders h then lose (T + k) h + L.give (T + k) h c else 0) =
        (total (L.present (T + k)) fun h => bif holders h then lose (T + k) h else 0) +
          total (L.present (T + k)) fun h => bif holders h then L.give (T + k) h c else 0 :=
      (total_congr (fun h => by cases holders h <;> rfl) _).trans (total_add _ _ _)
    have taken := total_split holders (fun h => L.take (T + k) h c) (L.present (T + k))
    have given := total_split holders (fun h => L.give (T + k) h c) (L.present (T + k))
    exact Nat.lt_of_le_of_lt (Nat.le_of_eq given)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_right (exceeds k below) _)
        (Nat.le_trans (Nat.le_of_eq split.symm) (Nat.le_trans (total_le _ draws)
          (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq taken.symm))))))
    start,
   fun h holds couples => apart h holds (listed h c holds couples)⟩

end Flow

/-! ## Witnesses -/

namespace Optimum

namespace Drain

open Diversion DrawnBeyond

/-- `k` units in the store, the rest of three at the source. -/
def storedAt (k : Nat) : Place → Nat
  | .source => 3 - k
  | .store => k

/-- Up to three, storing `k` is a split of three units. -/
theorem storedAt_split {k : Nat} (within : k ≤ 3) : Split (storedAt k) :=
  Naturals.sub_add_cancel within

/-- **The set point decides the draw.** Among the splits of three units, every optimum of every
order nearing a store of `k`, `k` at most three, leaves the source at `3 - k`: derived from
`atSetPoint_of_reach`. -/
theorem atSetPoint_source {k : Nat} (within : k ≤ 3) {better : (Place → Nat) → (Place → Nat) → Prop}
    (nearing : Nearing [Place.store] (fun _ => k) better) {o : Place → Nat}
    (optimum : Frontier Split better o) : o .source = 3 - k :=
  have atStore : o .store = k :=
    atSetPoint_of_reach nearing (storedAt_split within) (atSetPoint_single rfl) optimum .store
      (.head [])
  (Naturals.add_sub_cancel (o .source) k).symm.trans
    (congrArg (· - k) ((congrArg (o .source + ·) atStore).symm.trans optimum.1))

/-- **The dweller is kept exactly where the set point's shortfall is within the slack.** Among the
splits, every optimum of every order nearing a store of `k`, `k` at most three, meets the dweller's
need of two at the source exactly where `k` is at most one, the slack. -/
theorem kept_iff {k : Nat} (within : k ≤ 3) {better : (Place → Nat) → (Place → Nat) → Prop}
    (nearing : Nearing [Place.store] (fun _ => k) better) {o : Place → Nat}
    (optimum : Frontier Split better o) :
    (web WithinSlack.level).need 0 .dweller .source ≤ o .source ↔ k ≤ 1 :=
  Eq.subst (motive := fun y => (web WithinSlack.level).need 0 .dweller .source ≤ y ↔ k ≤ 1)
    (atSetPoint_source within nearing optimum).symm
    (match k, within with
      | 0, _ => by decide
      | 1, _ => by decide
      | 2, _ => by decide
      | 3, _ => by decide
      | n + 4, over => absurd over
          (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (by decide) (Nat.le_add_left 4 n))))

/-- **A set point within the slack keeps the dweller; every rising order ends it.** Among the
splits of three units, with room, every optimum of every order nearing a store of one leaves
the source at two, the dweller's need, and the order by distance has such an optimum; every
optimum of every order rising with the store leaves the source empty. -/
theorem nearing_keeps :
    Room [Place.store] [Place.source] Split ∧
    (∀ better : (Place → Nat) → (Place → Nat) → Prop, Nearing [Place.store] (fun _ => 1) better →
      ∀ o, Frontier Split better o → o .source = 2) ∧
    Frontier Split (byGap [Place.store] fun _ => 1) (storedAt 1) ∧
    (∀ better : (Place → Nat) → (Place → Nat) → Prop, Rising [Place.store] better →
      ∀ o, Frontier Split better o → o .source = 0) ∧
    (web WithinSlack.level).need 0 .dweller .source = 2 :=
  ⟨split_shared.room source_apart (.head []),
   fun _ nearing _ optimum => atSetPoint_source (by decide) nearing optimum,
   atSetPoint_frontier (storedAt_split (by decide)) (atSetPoint_single rfl),
   fun _ rising _ optimum => Nat.le_zero.mp (least_of_shared rising source_apart (.head [])
     split_shared optimum Place.source (.head []) ((web drainedLevel).level 1) rfl),
   rfl⟩

/-- **A set point past the slack breaks the dweller all the same.** Every optimum of every order
nearing a store of two leaves the source at one, below the dweller's need of two. -/
theorem nearing_breaks {better : (Place → Nat) → (Place → Nat) → Prop}
    (nearing : Nearing [Place.store] (fun _ => 2) better) {o : Place → Nat}
    (optimum : Frontier Split better o) :
    o .source = 1 ∧ o .source < (web WithinSlack.level).need 0 .dweller .source :=
  have at1 : o .source = 1 := atSetPoint_source (by decide) nearing optimum
  ⟨at1, Eq.subst (motive := fun y => y < 2) at1.symm (Nat.lt_succ_self 1)⟩

/-- An aspiration level at a store of one with the source counted after: ranked first by whether
the store reaches one, and among outcomes alike in that, by more at the source. -/
def satisficingThen (o' o : Place → Nat) : Prop :=
  satisficing o' o ∨ ((1 ≤ o' .store ↔ 1 ≤ o .store) ∧ o .source < o' .source)

/-- **Counted after an aspiration level, the source is kept as well.** Every optimum among the
splits of three units of the order satisficing at a store of one with the source counted after
leaves the source at two, the dweller's need, as every optimum of every order nearing a store of
one does (`Drain.nearing_keeps`): the plateau of the first term lets the second decide, a set point
or not. -/
theorem satisficingThen_keeps {o : Place → Nat} (optimum : Frontier Split satisficingThen o) :
    o .source = 2 :=
  have kept : Split keptLevel := rfl
  match hs : o .store with
  | 0 => absurd (Or.inl ⟨Nat.le_refl 1,
        Eq.subst (motive := fun y => y < 1) hs.symm (Nat.zero_lt_succ 0)⟩ :
          satisficingThen keptLevel o)
      (optimum.2 keptLevel kept)
  | n + 1 =>
    have split : o .source + (n + 1) = 3 :=
      Eq.subst (motive := fun y => o .source + y = 3) hs optimum.1
    have atMost : o .source ≤ 2 :=
      Nat.le_of_succ_le_succ (Nat.le_trans
        (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le n)) (o .source))
        (Nat.le_of_eq split))
    Nat.le_antisymm atMost (Nat.ge_of_not_lt fun lower => optimum.2 keptLevel kept
      (Or.inr ⟨⟨fun _ => Eq.subst (motive := fun y => 1 ≤ y) hs.symm
          (Nat.succ_le_succ (Nat.zero_le n)), fun _ => Nat.le_refl 1⟩, lower⟩))

end Drain

namespace Topped

open Diversion DrawnBeyond Drain

/-- Two units at the source; the store at its set point of one. -/
def start : Place → Nat
  | .source => 2
  | .store => 1

/-- The store's set point: one. -/
def one : Place → Nat := fun _ => 1

/-- The taker takes one unit of the source and gives nothing: the unit is lost. -/
def discarding : Flow Formation Place where
  present _ := [.taker, .dweller]
  take _ f c := match f, c with
    | .taker, .source => 1
    | .taker, .store => 0
    | .dweller, _ => 0
  give _ _ _ := 0

/-- The source drawn to one, the store at one. -/
def drawnOne : Place → Nat
  | .source => 1
  | .store => 1

/-- The outcomes open to the taker, of capacity one at the source, from `start`, the dweller
exchanging nothing. -/
abbrev Open : (Place → Nat) → Prop :=
  undiverted.Outcome takerPart start (takerCap 1) ([Place.store] ++ [Place.source]) 0

/-- Exchanging nothing is open, and leaves the source untouched. -/
theorem idle_open : Open start :=
  ⟨undiverted, ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩, fun _ _ _ => Nat.zero_le _, fun _ _ _ _ => rfl,
    fun _ _ => Nat.le_refl _⟩, fun _ => rfl⟩

/-- Taking a unit of the source and losing it is open, and leaves the source at one. -/
theorem discarding_open : Open drawnOne :=
  ⟨discarding, ⟨rfl,
    fun h c out => match h, c, out with
      | .dweller, _, _ => ⟨rfl, rfl⟩
      | .taker, _, out => (nomatch out),
    fun h c _ => match h, c with
      | .taker, .source => Nat.le_refl 1
      | .taker, .store => Nat.le_refl 0
      | .dweller, _ => Nat.zero_le _,
    fun _ _ _ _ => rfl,
    fun _ _ => Nat.zero_le _⟩,
   fun c => match c with
    | .source => rfl
    | .store => rfl⟩

/-- **At the set point the order by distance neither drives nor protects.** From the store at its
set point of one and two units at the source, every optimum of every order nearing a store of one
stands at it, and among the outcomes open to the taker the step exchanging nothing and the step
taking a unit and losing it are both optima of the order by distance: the first leaves the source
at the dweller's need of two, the second at one, below it. -/
theorem nearing_either :
    (∀ better : (Place → Nat) → (Place → Nat) → Prop, Nearing [Place.store] one better →
      ∀ o, Frontier Open better o → o .store = 1) ∧
    Frontier Open (byGap [Place.store] one) start ∧
    Frontier Open (byGap [Place.store] one) drawnOne ∧
    (web WithinSlack.level).need 0 .dweller .source ≤ start .source ∧
    drawnOne .source < (web WithinSlack.level).need 0 .dweller .source :=
  ⟨fun _ nearing _ optimum =>
     atSetPoint_of_reach nearing idle_open (atSetPoint_single rfl) optimum .store (.head []),
   atSetPoint_frontier idle_open (atSetPoint_single rfl),
   atSetPoint_frontier discarding_open (atSetPoint_single rfl),
   Nat.le_refl 2, Nat.lt_succ_self 1⟩

/-- **Every rising order drains the source.** Every optimum of every order rising with the store,
among the outcomes open to the taker, leaves the source at one, below the dweller's need: derived
from `optimum_beyond`. -/
theorem rising_drains {better : (Place → Nat) → (Place → Nat) → Prop}
    (rising : Rising [Place.store] better) {o : Place → Nat} (optimum : Frontier Open better o) :
    o .source = 1 :=
  optimum_beyond formations_distinct store_source_distinct source_apart (.head []) rising optimum
    (.head [])

/-- **Counted after the set point, the source is kept.** Every optimum, among the outcomes open to
the taker, of the order nearing the store's set point by distance with the source counted after
meets the dweller's need: derived from `counted_after_most`. -/
theorem counted_after_keeps {o : Place → Nat}
    (optimum : Frontier Open (byGapThen [Place.store] one [Place.source]) o) :
    (web WithinSlack.level).need 0 .dweller .source ≤ o .source :=
  le_of_add_le_add_right 0 ((counted_after_most idle_open (atSetPoint_single rfl) optimum).2
    start idle_open (atSetPoint_single rfl))

/-- **With less source counted after the set point, the source is drained.** Every optimum, among
the outcomes open to the taker, of the order nearing the store's set point by distance with less
source counted after leaves the source at most at one, below the dweller's need of two: a nearing
order can drive the drain at its set point. -/
theorem counted_less_drains {o : Place → Nat}
    (optimum : Frontier Open (byGapLess [Place.store] one [Place.source]) o) :
    o .source ≤ 1 ∧ 1 < (web WithinSlack.level).need 0 .dweller .source :=
  ⟨Nat.ge_of_not_lt fun more => optimum.2 drawnOne discarding_open
    (match Nat.eq_zero_or_pos (total [Place.store] (gapTo one o)) with
      | .inl zero => .inr ⟨(rfl : total [Place.store] (gapTo one drawnOne) = 0).trans zero.symm,
          Nat.add_lt_add_right more 0⟩
      | .inr pos => .inl pos),
   Nat.lt_succ_self 1⟩

/-- The store's gap from its set point traded against the source at weight `w`: an outcome ranks
above another where `w` times its source less its gap is greater. -/
def weighted (w : Nat) (o' o : Place → Nat) : Prop :=
  w * o .source + gapTo one o' .store < w * o' .source + gapTo one o .store

/-- **Under every positive weight on the source, the source is kept.** Every optimum, among the
outcomes open to the taker, of the order trading the source at a positive weight against the
store's gap from its set point meets the dweller's need: the step exchanging nothing ranks above
every outcome leaving less than two at the source. -/
theorem weighted_keeps {w : Nat} (positive : 0 < w) {o : Place → Nat}
    (optimum : Frontier Open (weighted w) o) :
    (web WithinSlack.level).need 0 .dweller .source ≤ o .source :=
  Nat.ge_of_not_lt fun below => optimum.2 start idle_open
    (show w * o .source + gapTo one start .store < w * start .source + gapTo one o .store from
      Nat.lt_of_lt_of_le
        (Nat.lt_of_le_of_lt
          (Nat.add_le_add_right (Nat.mul_le_mul_left w (Nat.le_of_lt_succ below)) _)
          (Nat.lt_of_lt_of_le (Nat.add_lt_add_left positive (w * 1))
            (Nat.le_of_eq (Nat.mul_succ w 1).symm)))
        (Nat.le_add_right _ _))

/-- Every outcome open to the taker leaves the store at most two: the taker gives the store no more
than it takes, and takes at most one, from the source alone. -/
theorem store_le_two {o : Place → Nat} (open_ : Open o) : o .store ≤ 2 :=
  match open_ with
  | ⟨L', acts, balances⟩ => by
    have store : o .store + L'.taken 0 .store = 1 + L'.given 0 .store := balances .store
    have gives : L'.given 0 .store = L'.give 0 .taker .store + (L'.give 0 .dweller .store + 0) :=
      congrArg (fun ps => total ps fun f => L'.give 0 f .store) acts.1
    have dweller : L'.give 0 .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have conserved : L'.give 0 .taker .store + (L'.give 0 .taker .source + 0) ≤
        L'.take 0 .taker .store + (L'.take 0 .taker .source + 0) := acts.2.2.2.2 .taker rfl
    have fromStore : L'.take 0 .taker .store ≤ 0 := acts.2.2.1 .taker .store rfl
    have fromSource : L'.take 0 .taker .source ≤ 1 := acts.2.2.1 .taker .source rfl
    calc o .store ≤ o .store + L'.taken 0 .store := Nat.le_add_right _ _
      _ = 1 + L'.given 0 .store := store
      _ = 1 + L'.give 0 .taker .store := by rw [gives, dweller]; rfl
      _ ≤ 1 + (L'.give 0 .taker .store + (L'.give 0 .taker .source + 0)) :=
          Nat.add_le_add_left (Nat.le_add_right _ _) 1
      _ ≤ 1 + (L'.take 0 .taker .store + (L'.take 0 .taker .source + 0)) :=
          Nat.add_le_add_left conserved 1
      _ ≤ 1 + (0 + (1 + 0)) :=
          Nat.add_le_add_left (Nat.add_le_add fromStore (Nat.add_le_add_right fromSource 0)) 1

/-- **Out of reach, a set point drains as a rising order does.** Every optimum of every order
nearing a store of three, which no outcome open to the taker reaches, leaves the source at one,
below the dweller's need, where every rising optimum leaves it: derived from `nearing_beyond`. -/
theorem out_of_reach {better : (Place → Nat) → (Place → Nat) → Prop}
    (nearing : Nearing [Place.store] (fun _ => 3) better) {o : Place → Nat}
    (optimum : Frontier Open better o) : o .source = 1 :=
  nearing_beyond formations_distinct store_source_distinct source_apart (.head []) nearing optimum
    (Nat.lt_of_le_of_lt (store_le_two optimum.1) (Nat.lt_succ_self 2)) (.head [])

end Topped

namespace Spread

/-- A condition of the family and two beyond it. -/
inductive Spot where
  | family
  | first
  | second

/-- The set point: one. -/
def one : Spot → Nat := fun _ => 1

/-- At the set point, the first condition beyond emptied, three in the second. -/
def lopsided : Spot → Nat
  | .family => 1
  | .first => 0
  | .second => 3

/-- At the set point, one in each condition beyond. -/
def even : Spot → Nat
  | .family => 1
  | .first => 1
  | .second => 1

/-- Two ways of reaching the set point. -/
def Eligible (o : Spot → Nat) : Prop := o = lopsided ∨ o = even

/-- **Counted after the set point, a condition beyond is emptied though a way of reaching the set
point keeps it.** Every optimum of the order by distance with the beyond counted after leaves the
first condition at nothing, while `even`, eligible and at the set point, leaves one at each. -/
theorem counted_after_empties :
    (∀ o, Frontier Eligible (byGapThen [Spot.family] one [Spot.first, Spot.second]) o →
      o .first = 0) ∧
    Eligible even ∧ AtSetPoint [Spot.family] one even ∧ 1 ≤ even .first ∧ 1 ≤ even .second :=
  ⟨fun _ optimum => match optimum.1 with
    | .inl same => Eq.subst (motive := fun x => x Spot.first = 0) same.symm rfl
    | .inr same => absurd
        (Eq.subst (motive := fun x => byGapThen [Spot.family] one [Spot.first, Spot.second]
            lopsided x)
          same.symm (.inr ⟨rfl, Nat.lt_succ_self 2⟩))
        (optimum.2 lopsided (.inl rfl)),
   .inr rfl, atSetPoint_single rfl, Nat.le_refl 1, Nat.le_refl 1⟩

end Spread

namespace Skew

/-- Single-peaked at two: three for each unit over, one for each unit under. -/
def cost (o : Unit → Nat) : Nat := (o () - 2) + (o () - 2) + (o () - 2) + (2 - o ())

/-- The order by that cost, the lower ranking above. -/
def order (o' o : Unit → Nat) : Prop := cost o' < cost o

/-- The set point: two. -/
def two : Unit → Nat := fun _ => 2

/-- **An order costlier above the set point than below is nearing.** -/
theorem nearing : Nearing [()] two order :=
  fun o o' nearer =>
    have b : Regulation.Between 2 (o ()) (o' ()) := nearer.1 () (.head [])
    have st : gap (o' ()) 2 < gap (o ()) 2 := match nearer.2 with
      | ⟨_, _, lt⟩ => lt
    match Nat.le_total 2 (o ()) with
    | .inl over =>
      have yb := b.1 over
      have lt : o' () - 2 < o () - 2 :=
        Nat.lt_of_le_of_lt (Nat.le_of_eq (Regulation.gap_of_le yb.1).symm)
          (Nat.lt_of_lt_of_le st (Nat.le_of_eq (Regulation.gap_of_le over)))
      show cost o' < cost o from
        Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg (_ + ·) (sub_eq_zero_of_le yb.1)))
          (Nat.lt_of_lt_of_le (Nat.add_lt_add_right (Nat.add_lt_add (Nat.add_lt_add lt lt) lt) 0)
            (Nat.le_of_eq (congrArg (_ + ·) (sub_eq_zero_of_le over)).symm))
    | .inr under =>
      have yb := b.2 under
      have lt : 2 - o' () < 2 - o () :=
        Nat.lt_of_le_of_lt (Nat.le_of_eq (Regulation.gap_of_ge yb.2).symm)
          (Nat.lt_of_lt_of_le st (Nat.le_of_eq (Regulation.gap_of_ge under)))
      show cost o' < cost o from
        Nat.lt_of_le_of_lt
          (Nat.le_of_eq (congrArg (fun a => a + a + a + (2 - o' ())) (sub_eq_zero_of_le yb.2)))
          (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt (0 + 0 + 0))
            (Nat.le_of_eq
              (congrArg (fun a => a + a + a + (2 - o ())) (sub_eq_zero_of_le under)).symm))

/-- **It does not fall with the distance alike on both sides.** With the set point at two, one unit
over stands no farther from it than two units under, and nearer, yet ranks below. -/
theorem not_by_gaps : ¬ ∀ o o', Exceeds [()] (gapTo two o) (gapTo two o') → order o' o :=
  fun falls => Nat.lt_irrefl 2 (Nat.lt_trans (Nat.lt_succ_self 2)
    (falls (fun _ => 0) (fun _ => 3)
      ⟨fun _ _ => (Nat.le_succ 1 : 1 ≤ 2), (), .head [], (Nat.lt_succ_self 1 : 1 < 2)⟩ : 3 < 2))

end Skew

namespace TwoStores

open TwoTakers (Member)

/-- A source and a store for each of two takers. -/
inductive Place where
  | source
  | store (which : Bool)

/-- Across the first step each taker takes one unit of the source and gives it to its own store;
the dweller exchanges nothing. -/
def flow : Flow Member Place where
  present t := match t with
    | 0 => [.taker true, .taker false, .dweller]
    | _ + 1 => []
  take _ f x := match f, x with
    | .taker _, .source => 1
    | .taker _, .store _ => 0
    | .dweller, _ => 0
  give _ f x := match f, x with
    | .taker _, .source => 0
    | .taker true, .store true => 1
    | .taker true, .store false => 0
    | .taker false, .store true => 0
    | .taker false, .store false => 1
    | .dweller, _ => 0

/-- Three units at the source and the stores empty; after the step, one unit in each. -/
def level : Nat → Place → Nat
  | 0, .source => 3
  | 0, .store _ => 0
  | _ + 1, .source => 1
  | _ + 1, .store _ => 1

/-- The dweller depends on the source at need two and is active while it stands so; the takers
depend on nothing. -/
def web : Web Member Place where
  level := level
  active t f := match f with
    | .taker _ => True
    | .dweller => 2 ≤ level t .source
  requires _ f x := match f, x with
    | .dweller, .source => True
    | .dweller, .store _ => False
    | .taker _, _ => False
  need _ _ _ := 2
  draws _ _ _ := False

/-- The set point: one in each store. -/
def one : Place → Nat := fun _ => 1

/-- Each taker's family: its own store. -/
def family (w : Bool) : List Place := [.store w]

/-- What each taker can bring about with the other's store as the step leaves it: the three units
split among the source and the stores. -/
def Eligible (w : Bool) (o : Place → Nat) : Prop :=
  o .source + (o (.store true) + o (.store false)) = 3 ∧ o (.store (!w)) = 1

theorem balances : flow.Balances web
  | 0, .source => rfl
  | 0, .store true => rfl
  | 0, .store false => rfl
  | _ + 1, .source => rfl
  | _ + 1, .store _ => rfl

theorem gainless : flow.GainlessOn ([Place.store true, Place.store false] ++ [Place.source]) 0
  | .taker true, _ => Nat.le_refl 1
  | .taker false, _ => Nat.le_refl 1
  | .dweller, _ => Nat.le_refl 0

/-- Each taker's step stands at its set point and is an optimum of its order by distance among
the outcomes eligible to it. -/
theorem best (w : Bool) : Frontier (Eligible w) (byGap (family w) one) (web.level 1) :=
  atSetPoint_frontier (match w with
    | true => ⟨rfl, rfl⟩
    | false => ⟨rfl, rfl⟩) (atSetPoint_single rfl)

/-- **Each within the slack, together past it.** Each taker's own shortfall below its set point is
within the slack of the dweller's need, one unit; at the taker's joint best response the dweller's
dependence on the source is broken: derived from `Flow.Balances.mutual_atSetPoint_breaks`. -/
theorem jointly_broken :
    (∀ w, total (family w) one ≤
      web.stock (family w) 0 + web.slack (fun _ => .dweller) [Place.source] 0) ∧
    ∃ c, c ∈ [Place.source] ∧ web.Broken 0 .dweller c :=
  ⟨fun w => match w with
    | true => Nat.le_refl 1
    | false => Nat.le_refl 1,
   Flow.Balances.mutual_atSetPoint_breaks (opt := [true, false]) (fam := family) (elig := Eligible)
    (orders := fun w => byGap (family w) one) (s := one) (dep := fun _ => Member.dweller)
    (ds := [Place.store true, Place.store false]) balances gainless
    (fun x mem => (match x, mem with
      | .source, _ => ⟨trivial, Nat.le_succ 2⟩
      | .store _, mem => absurd mem (fun inside => match inside with
        | .tail _ no => nomatch no)))
    (fun x mem => (match x, mem with
      | .store true, _ => ⟨true, ListTests.mem_bools true, .head []⟩
      | .store false, _ => ⟨false, ListTests.mem_bools false, .head []⟩
      | .source, mem => absurd mem (fun inside => match inside with
        | .tail _ (.tail _ no) => nomatch no)))
    (fun w _ => byGap_nearing (family w) one)
    (fun w _ => ⟨web.level 1, (best w).1, atSetPoint_single rfl⟩)
    (fun w _ => best w) (by decide)⟩

end TwoStores

namespace HeldPair

/-- A renewer and two formations holding stores: the members of `Witnesses.relay`. -/
abbrev Member := Witnesses.Member

/-- Equality of members is decided. -/
instance : DecidableEq Member
  | .renewer, .renewer => isTrue rfl
  | .first, .first => isTrue rfl
  | .second, .second => isTrue rfl
  | .renewer, .first => isFalse fun same => nomatch same
  | .renewer, .second => isFalse fun same => nomatch same
  | .first, .renewer => isFalse fun same => nomatch same
  | .first, .second => isFalse fun same => nomatch same
  | .second, .renewer => isFalse fun same => nomatch same
  | .second, .first => isFalse fun same => nomatch same

/-- A pool, and a store for each of the first and the second. -/
inductive Spot where
  | pool
  | firstStore
  | secondStore

/-- The part holding stores at a set point: the first and the second. -/
def holders : Member → Bool
  | .renewer => false
  | .first => true
  | .second => true

/-- The family of each of the first and the second: its own store. -/
def store : Member → List Spot
  | .renewer => []
  | .first => [.firstStore]
  | .second => [.secondStore]

/-- All three take part across the first two steps, none after. -/
def present : Nat → List Member
  | 0 => [.renewer, .first, .second]
  | 1 => [.renewer, .first, .second]
  | _ + 2 => []

/-- The renewer gives the pool one unit. The first and the second each take one unit of the pool
and one of their store, and give their store one: the store held, a unit lost. -/
def flow : Flow Member Spot where
  present := present
  take _ f x := match f, x with
    | .renewer, _ => 0
    | .first, .pool => 1
    | .first, .firstStore => 1
    | .first, .secondStore => 0
    | .second, .pool => 1
    | .second, .firstStore => 0
    | .second, .secondStore => 1
  give _ f x := match f, x with
    | .renewer, .pool => 1
    | .renewer, .firstStore => 0
    | .renewer, .secondStore => 0
    | .first, .pool => 0
    | .first, .firstStore => 1
    | .first, .secondStore => 0
    | .second, .pool => 0
    | .second, .firstStore => 0
    | .second, .secondStore => 1

/-- The pool: two, one, then nothing. -/
def poolLevel : Nat → Nat := Witnesses.profile [2, 1] 0

/-- The levels: the pool falling, each store at one. -/
def level (t : Nat) : Spot → Nat
  | .pool => poolLevel t
  | .firstStore => 1
  | .secondStore => 1

/-- The renewer depends on the pool at need one and is active while it stands so; the first and
the second depend on nothing and are active throughout. -/
def web : Web Member Spot where
  level := level
  active t f := match f with
    | .renewer => 1 ≤ poolLevel t
    | .first => True
    | .second => True
  requires _ f x := match f, x with
    | .renewer, .pool => True
    | .renewer, .firstStore => False
    | .renewer, .secondStore => False
    | .first, _ => False
    | .second, _ => False
  need _ _ _ := 1
  draws _ f x := match f, x with
    | .renewer, _ => False
    | .first, .pool => True
    | .first, .firstStore => False
    | .first, .secondStore => False
    | .second, .pool => True
    | .second, .firstStore => False
    | .second, .secondStore => False

/-- The first and the second each observe their own store. -/
def observes (f : Member) (x : Spot) : Prop := match f, x with
  | .renewer, _ => False
  | .first, .pool => False
  | .first, .firstStore => True
  | .first, .secondStore => False
  | .second, .pool => False
  | .second, .firstStore => False
  | .second, .secondStore => True

/-- The set point: one in each store. -/
def one : Spot → Nat := fun _ => 1

theorem balances : flow.Balances web
  | 0, .pool => rfl
  | 0, .firstStore => rfl
  | 0, .secondStore => rfl
  | 1, .pool => rfl
  | 1, .firstStore => rfl
  | 1, .secondStore => rfl
  | _ + 2, .pool => rfl
  | _ + 2, .firstStore => rfl
  | _ + 2, .secondStore => rfl

theorem acting : flow.Acting web
  | 0, .renewer, _, _, _ => Nat.le_succ 1
  | 1, .renewer, _, _, _ => Nat.le_refl 1
  | 0, .first, _, _, _ => trivial
  | 1, .first, _, _, _ => trivial
  | 0, .second, _, _, _ => trivial
  | 1, .second, _, _, _ => trivial
  | _ + 2, _, _, absent, _ => nomatch absent

theorem dependent : web.Dependent
  | _, .renewer, active, .pool, _ => active
  | _, .renewer, _, .firstStore, req => False.elim req
  | _, .renewer, _, .secondStore, req => False.elim req
  | _, .first, _, _, req => False.elim req
  | _, .second, _, _, req => False.elim req

/-- Only the renewer gives to the pool, and it depends on the pool at need one. -/
theorem gated : ∀ t f, f ∈ flow.present t → 0 < flow.give t f .pool →
    web.requires t f .pool ∧ 1 ≤ web.need t f .pool
  | _, .renewer, _, _ => ⟨trivial, Nat.le_refl 1⟩
  | _, .first, _, pos => absurd pos (Nat.lt_irrefl 0)
  | _, .second, _, pos => absurd pos (Nat.lt_irrefl 0)

/-- The members, without repetition. -/
theorem members_distinct :
    Distinct [Witnesses.Member.renewer, Witnesses.Member.first, Witnesses.Member.second] :=
  show ¬ Witnesses.Member.renewer ∈ [Witnesses.Member.first, Witnesses.Member.second] ∧
      (¬ Witnesses.Member.first ∈ [Witnesses.Member.second] ∧
        (¬ Witnesses.Member.second ∈ ([] : List Member) ∧ True)) from
  ⟨fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => match mem_cons_cases mem with
        | .inl same => nomatch same
        | .inr mem => nomatch mem),
   fun mem => (match mem_cons_cases mem with
      | .inl same => nomatch same
      | .inr mem => nomatch mem),
   fun mem => (nomatch mem), trivial⟩

theorem distinct : ∀ t, Distinct (flow.present t)
  | 0 => members_distinct
  | 1 => members_distinct
  | _ + 2 => trivial

/-- No other formation exchanges with the store of the first or of the second. -/
theorem alone : ∀ (t : Nat) (h : Member), holders h = true → ∀ g, ¬ g = h → ∀ x, x ∈ store h →
    flow.take t g x = 0 ∧ flow.give t g x = 0
  | _, .first, _, .renewer, _, _, .head _ => ⟨rfl, rfl⟩
  | _, .first, _, .second, _, _, .head _ => ⟨rfl, rfl⟩
  | _, .first, _, .first, other, _, _ => absurd rfl other
  | _, .first, _, _, _, _, .tail _ no => nomatch no
  | _, .second, _, .renewer, _, _, .head _ => ⟨rfl, rfl⟩
  | _, .second, _, .first, _, _, .head _ => ⟨rfl, rfl⟩
  | _, .second, _, .second, other, _, _ => absurd rfl other
  | _, .second, _, _, _, _, .tail _ no => nomatch no
  | _, .renewer, holds, _, _, _, _ => nomatch holds

/-- Each store stands at its set point of one at every step. -/
theorem held (t : Nat) (h : Member) : AtSetPoint (store h) one (web.level t) :=
  fun x mem => match h, x, mem with
    | .first, _, .head _ => rfl
    | .second, _, .head _ => rfl
    | .first, _, .tail _ no => nomatch no
    | .second, _, .tail _ no => nomatch no
    | .renewer, _, mem => nomatch mem

/-- The first and the second each lose one unit on their store with the pool. -/
theorem loses (t : Nat) : ∀ h, holders h = true →
    1 + total (store h) (flow.give t h) + flow.give t h .pool ≤
      total (store h) (flow.take t h) + flow.take t h .pool
  | .first, _ => Nat.le_refl 2
  | .second, _ => Nat.le_refl 2
  | .renewer, holds => nomatch holds

/-- Their losses together exceed what the renewer gives the pool. -/
theorem exceeds : ∀ k, k < 2 → flow.restGiven holders (0 + k) .pool <
    total (flow.present (0 + k)) fun h => bif holders h then 1 else 0
  | 0, _ => Nat.lt_succ_self 1
  | 1, _ => Nat.lt_succ_self 1
  | k + 2, below => absurd below (Nat.not_lt_of_le (Nat.le_add_left 2 k))

/-- The couplings of the first and the second lie in their stores. -/
theorem listed : ∀ h x, holders h = true → web.CoupledInto observes h x → x ∈ store h
  | .first, .firstStore, _, _ => .head []
  | .second, .secondStore, _, _ => .head []
  | .first, .pool, _, couples => (match couples with
    | .inl ⟨_, req⟩ => False.elim req
    | .inr seen => False.elim seen)
  | .first, .secondStore, _, couples => (match couples with
    | .inl ⟨_, req⟩ => False.elim req
    | .inr seen => False.elim seen)
  | .second, .pool, _, couples => (match couples with
    | .inl ⟨_, req⟩ => False.elim req
    | .inr seen => False.elim seen)
  | .second, .firstStore, _, couples => (match couples with
    | .inl ⟨_, req⟩ => False.elim req
    | .inr seen => False.elim seen)
  | .renewer, _, holds, _ => nomatch holds

/-- The pool lies in neither family. -/
theorem apart : ∀ h, holders h = true → ¬ Spot.pool ∈ store h
  | .first, _, mem => (match mem with
    | .tail _ no => nomatch no)
  | .second, _, mem => (match mem with
    | .tail _ no => nomatch no)
  | .renewer, holds, _ => nomatch holds

/-- Across the first two steps the first and the second each take from the pool within what the
step gives it, while together they take more. -/
theorem within : ∀ t, t < 2 → flow.WithinOwn t .pool ∧ ¬ flow.WithinJoint t .pool
  | 0, _ => ⟨fun f _ => match f with
      | .renewer => Nat.zero_le 1
      | .first => Nat.le_refl 1
      | .second => Nat.le_refl 1,
    fun joint => Nat.not_succ_le_self 1 joint⟩
  | 1, _ => ⟨fun f _ => match f with
      | .renewer => Nat.zero_le 1
      | .first => Nat.le_refl 1
      | .second => Nat.le_refl 1,
    fun joint => Nat.not_succ_le_self 1 joint⟩
  | t + 2, below => absurd below (Nat.not_lt_of_le (Nat.le_add_left 2 t))

/-- **Two formations holding set points, each within the renewal, end it together, unseen.** The
first and the second each hold their store at its set point of one by drawing from the pool the
unit they lose, each within the one unit the step gives the pool, while the two take two; from a
pool of two the renewal, which depends on the pool, ends after two steps, and neither couples into
the pool. The stipulated activity says so; derived here through `Flow.held_excess_ends`, the witness
shows the law's hypotheses holding together with each draw within the renewal. -/
theorem held_end :
    (∀ t, t < 2 → flow.WithinOwn t .pool ∧ ¬ flow.WithinJoint t .pool) ∧
      (∀ k g, web.requires (0 + 2 + k) g .pool → 1 ≤ web.need (0 + 2 + k) g .pool →
        ¬ web.active (0 + 2 + k) g) ∧
      ∀ h, holders h = true → ¬ web.CoupledInto observes h .pool :=
  ⟨within, Flow.held_excess_ends (fam := store) (lose := fun _ _ => 1) (T := 0) (n := 2)
    (m := 1) balances acting dependent gated (fun k _ => distinct (0 + k))
    (fun k _ h _ holds g _ other x mem => alone (0 + k) h holds g other x mem)
    (fun k _ h _ _ => stock_eq_of_atSetPoint (held (0 + k) h) (held (0 + k + 1) h))
    (fun k _ h _ holds => loses (0 + k) h holds) exceeds (Nat.lt_succ_self 2) listed apart⟩

end HeldPair

end Optimum

end Becoming
