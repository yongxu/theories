import Becoming.Openness

/-!
# Resolution: what the unit of amounts carries

The spine counts amounts in natural numbers of one fixed unit. Read in that unit,
dissipation says that a formation taking from a closed family gives back at least one unit
less than it takes. So every exchange loses at least one unit, and the rest and openness
laws count those losses against the standing. This module separates what of those laws
belongs to the dynamics from what belongs to the fixed unit.

* **A unit that may refine.** Across the step from `t` the unit may split into `r t`
  finer units (`Flow.BalancesAt r`): the level before the step, counted in the finer
  unit, is `r t` times its count in the coarser one. With `r` constantly one this is
  `Balances` (`Flow.balancesAt_one`).
* **The refinement counted.** Splitting the unit into `split t + 1` is itself a change:
  counted in the finer unit, each condition stands at `split t` times its level more than
  before. Counted as one more formation, which gives each condition that amount and takes
  nothing (`Flow.withRefinement`), balance at a refining unit is the spine's balance
  (`Flow.balancesAt_iff_withRefinement`). The refinement gives without taking, so with it
  counted the flow dissipates on a family exactly where its own formations do and the
  refinement gives the family nothing (`Flow.withRefinement_dissipatesOn_iff`); across a
  step enclosed and dissipative with it counted, the refinement gives nothing
  (`Flow.refinement_gives_nothing`). So the spine's premises, read with the refinement
  counted, bring rest at every resolution with no premise added: in a world with a census
  whose relata are embodied, balanced at a refining unit, and, with the refinement counted,
  dissipative and enclosed at every step from some step on, neither arising nor ceasing
  recurs (`World.rests_unrefuted_refinement_counted`), and continued arising needs openness
  (`World.arising_opens_refinement_counted`). Without counting it, the same holds wherever
  the refinement gives nothing (`World.rests_unrefuted_without_refinement`,
  `World.arising_needs_refinement`, `Flow.taking_needs_refinement`, and for a reserve
  `Web.CarriesIn.lasts_unrefined`), and every witness below is fed by it
  (`refinement_feeds_witnesses`).
* **The loss law.** Whatever the refinement, where across each step from `T` on `q` times
  what remains together with `k` quanta of the unit of step `T` is within `q` times what
  was there, the quanta counted since `T` number at most `q` times the quantity at `T`
  (`losses_bound`).
* **The quantum law.** So, balanced at a refining resolution and dissipative, the steps at
  which a family closed from `T` on loses at least `1/q` of the unit of step `T` number at most `q`
  times its stock at `T` (`Flow.quantum_bound`), and losing a quantum does not recur
  (`Flow.quantum_not_recurring`).
* **A fixed unit.** Where the unit is fixed from some step on, every taking step loses a
  whole unit, so taking from a closed family does not recur (`Flow.taking_not_recurring`); with `r`
  constantly one this is the spine's `Flow.Balances.taking_not_recurring`.
* **Without counting the refinement: loss in proportion.** These results are kept as
  research notes beside the line above. Where every closed family gets back at most `q`
  parts in `q + 1` of what is taken from it, so losing at least a `(q + 1)`th of it
  (`Flow.DissipativeBy q`, dissipation in proportion `q`; it holds where each formation
  does so, `Flow.DissipatesBy.of_each`), the proportion lost does not depend on the unit.
  Then, at every resolution:
  - everything taken from a family closed from `T` on, summed since `T` with each step's
    amount counted in the unit of step `T` (`refinedSum`), is at most `q + 1` times its
    stock at `T`, and everything given back to it at most `q` times (the amount law,
    `Flow.uptake_bound`, `Flow.replenishment_bound`); in a world with a census, embodied
    relata and every step from `T` on enclosed, everything taken from what stands is at
    most `q + 1` times the total standing at `T`, and everything given to what stands at
    most `q` times (`World.taken_bound`, `World.given_bound`). The amount law names no
    size, and its bound is the least: in `Geometric` one formation takes the whole of a
    closed pool at each step and gives back `q` parts in `q + 1`, at a unit splitting into
    `q + 1`, and everything taken comes within `1/m` of `q + 1` times the pool for every
    `m` (`amount_sharp`);
  - every count below follows from it: where each step's count of a size is within `p`
    times an amount, the count summed since `T` is within `p` times the amount's bound
    (`counts_of_amounts`). With a unit that only refines:
  - the times a formation takes at least `1/p` of the unit from a family closed from `T`
    on number at most `p (q + 1)` times the family's stock at `T` (the exchange law,
    `Flow.exchange_bound`), so such taking does not recur (`Flow.exchange_not_recurring`);
  - in a world with a census, embodied relata and every step from `T` on enclosed, the
    times a relatum gains at least `1/p` of the unit number at most `p q` times the total
    standing at `T` (the growth law, `World.growth_bound`), so such gains do not recur
    (`World.growth_not_recurring`) and nothing arises at that size at arbitrarily late
    steps (`World.arising_not_recurring`);
  - under the same premises, the times a relatum falls by at least `1/p` of the unit
    number at most `p (q + 1)` times the total standing at `T` (the fall law,
    `World.fall_bound`), so nothing standing at that size ceases at arbitrarily late steps
    (`World.ceasing_not_recurring`). Together, neither arising nor ceasing at that size
    recurs (`World.not_recurring_at_resolution`): rest at each size, at every resolution.
* **A least loss at each size.** Also kept as a research note. Where the flow dissipates
  and each formation taking at least `1/p` of the unit loses at least `1/m` of it
  (`Flow.LosesAtSize`), the times a formation takes at least `1/p` of the unit from a
  closed family number at most `m` times its stock (`Flow.exchange_bound_of_least_loss`);
  loss in proportion at each transfer gives such a least loss
  (`Flow.losesAtSize_of_each`). Counting what relata gain needs more than a least loss at
  each size of transfer: a whole unit can pass in ever more, ever smaller transfers.
* **A reserve at every resolution.** The spine's reserve falls by a whole unit at each
  active step beyond support, so it defers the end without escaping it
  (`Web.Carries.lasts`). Read in a refining unit, a reserve that only falls
  (`Web.CarriesIn`, which with the unit fixed is `Web.Carries`, `Web.carriesIn_one`) may
  fall forever, fed by the refinement; where the refinement gives it nothing it is the
  spine's reserve (`Web.CarriesIn.lasts_unrefined`). Where each active step beyond support
  lowers the reserve by at least `1/p` of the unit (`Web.CarriesAt`), the formation is
  active at most `p` times its reserve (`Web.CarriesAt.lasts`); the spine's reserve is the
  case of `p` one at a fixed unit (`Web.Carries.carriesAt`).
* **The frontier.** Each witness is balanced at a unit that splits without end, and its
  flow dissipates on every closed family; each is fed by its refinement
  (`refinement_feeds_witnesses`).
  - In `Asymptote` a drawer takes from a closed pool without end and gives nothing back,
    so it is dissipative in every proportion; what it takes shrinks below every quantum,
    and the flow does not balance at the fixed unit (`rest_needs_quantum`).
  - In `Circulation` a drawer takes one whole unit of step 0 from a pool at every step,
    losing one unit of the step after; for no `q` is it dissipative in proportion
    (`exchange_needs_quantum`).
  - In `Emission` a pool gives back at most half of what it takes, every step is
    enclosed, and a new relatum arises at every step, standing at one unit of the step
    after, below every quantum; the world does not balance at the fixed unit
    (`arising_needs_quantum`).
  - In `Alternation` two sides hand one whole unit of step 0 back and forth inside an
    enclosure, each arising in turn; for no `q` is it dissipative in proportion
    (`arising_needs_proportion`).
  - In `Dwindle`, at a unit halving at each step, a formation never supported is active at
    every step, its reserve falling in the finer unit at each and tending to one unit of
    step 0; for no `p` does each active step lower the reserve by `1/p` of the unit
    (`reserve_needs_quantum`).
  - In `Trickle`, at a unit quartering at each step, a whole unit of step 0 passes between
    two sides inside an enclosure in ever more, ever smaller parts; each part taking at
    least `1/p` of the unit loses at least `1/m` of it, and transfers of each fixed size
    stop, yet a whole unit arises in turn without end, and for no `q` does the flow
    dissipate in proportion (`growth_needs_proportion`); everything taken from the two
    sides grows past every multiple of the unit (`throughput_needs_proportion`).

So, with the refinement counted as the change it is, the rest of enclosed change at every
resolution needs no premise beyond the spine's: a finer unit is given by a formation, and
an enclosed world dissipated on has none that gives without taking. Without counting it,
the routes shown here are a least loss per exchange at a fixed unit, as in the spine, and,
at every resolution, loss in proportion, which bounds the whole amount exchanged, together
with a least size of what is exchanged, arises or ceases. A least loss at each size of
transfer counts transfers but not what relata gain. Without the least size, change can
continue at sizes shrinking without bound; without the proportion, change of a whole unit
can continue while its losses shrink without bound. What holds at every resolution without
either is the quantum law: an enclosed family dissipated on cannot keep losing at a
non-vanishing rate.

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## A unit that may refine -/

namespace Flow

variable (L : Flow F C)

/-- The flow balances at resolution `r`: across the step from `t` the unit splits into
`r t` finer units, and the level before the step, counted in the finer unit, is `r t`
times its count in the coarser one. -/
def BalancesAt (r : Nat → Nat) (W : Web F C) : Prop :=
  ∀ t c, W.level (t + 1) c + L.taken t c = r t * W.level t c + L.given t c

variable {L} {W : Web F C}

/-- With a fixed unit, balance at resolution is the spine's balance. -/
theorem balancesAt_one : L.BalancesAt (fun _ => 1) W ↔ L.Balances W :=
  ⟨fun balances t c => (balances t c).trans (congrArg (· + L.given t c) (Nat.one_mul _)),
   fun balances t c => (balances t c).trans (congrArg (· + L.given t c) (Nat.one_mul _)).symm⟩

/-- Over a family, the stock after the step with its uptake is `r t` times the stock
before with its replenishment. -/
theorem BalancesAt.over {r : Nat → Nat} (balances : L.BalancesAt r W) :
    ∀ (cs : List C) (t : Nat),
      W.stock cs (t + 1) + L.uptake cs t = r t * W.stock cs t + L.replenishment cs t
  | [], _ => rfl
  | c :: cs, t =>
    (Nat.add_add_add_comm (W.level (t + 1) c) (W.stock cs (t + 1)) (L.taken t c)
      (L.uptake cs t)).trans
    ((congrArg (· + (W.stock cs (t + 1) + L.uptake cs t)) (balances t c)).trans
    ((congrArg (r t * W.level t c + L.given t c + ·) (balances.over cs t)).trans
    ((Nat.add_add_add_comm (r t * W.level t c) (L.given t c) (r t * W.stock cs t)
      (L.replenishment cs t)).trans
     (congrArg (· + (L.given t c + L.replenishment cs t))
       (Nat.left_distrib (r t) (W.level t c) (W.stock cs t)).symm))))

/-- Dissipated on, the family's stock after the step with its takers is at most `r t`
times its stock before. -/
theorem BalancesAt.lowers {r : Nat → Nat} (balances : L.BalancesAt r W) {cs : List C}
    {t : Nat} (dissipates : L.DissipatesOn cs t) :
    W.stock cs (t + 1) + L.takers cs t ≤ r t * W.stock cs t :=
  le_of_add_le_add_right (L.replenishment cs t) (Nat.le_trans
    (Nat.le_of_eq ((Nat.add_assoc _ _ _).trans
      (congrArg (W.stock cs (t + 1) + ·) (Nat.add_comm (L.takers cs t) (L.replenishment cs t)))))
    (Nat.le_trans (Nat.add_le_add_left dissipates.replenishment_takers _)
      (Nat.le_of_eq (balances.over cs t))))

end Flow

/-! ## The loss law -/

/-- Counted in a unit splitting into `r t` finer units across the step from `t`, a quantity
`s` loses across the step at least `1/q` of the unit in which `R` counts: in the unit of
step `t + 1`, `q` times the loss is at least `R (t + 1)`. -/
def LosesQuantum (r R s : Nat → Nat) (q t : Nat) : Prop :=
  R (t + 1) + q * s (t + 1) ≤ q * (r t * s t)

instance (r R s : Nat → Nat) (q t : Nat) : Decidable (LosesQuantum r R s q t) :=
  Nat.decLe _ _

/-- Units of each step from `T` on are positive where the unit only splits. -/
theorem units_pos {r R : Nat → Nat} {T : Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t) :
    ∀ {t}, T ≤ t → 0 < R t
  | _, .refl => Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq base.symm)
  | m + 1, .step later => Nat.le_trans
      (Nat.mul_le_mul (refining m later) (units_pos base unit refining later) :
        1 * 1 ≤ r m * R m)
      (Nat.le_of_eq (unit m later).symm)

/-- The invariant of the loss law. Counted in the unit of step `T`, with `R` counting
units of each later step per unit of step `T`: where across each step from `T` on, `q`
times what remains together with `k` quanta is within `q` times the quantity before, `q`
times what remains together with every quantum counted since `T` is within `q` times the
quantity at `T`. -/
theorem losses_invariant {r R s k : Nat → Nat} {q T : Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t)
    (step : ∀ t, T ≤ t → q * s (t + 1) + k t * R (t + 1) ≤ q * (r t * s t)) :
    ∀ n, q * s (T + n) + total (steps T n) k * R (T + n) ≤ q * s T * R (T + n)
  | 0 => Nat.le_of_eq ((congrArg (q * s T + ·) (Nat.zero_mul _)).trans
      ((Nat.add_zero _).trans ((Nat.mul_one _).symm.trans (congrArg (q * s T * ·) base.symm))))
  | n + 1 =>
    have before := losses_invariant base unit step n
    have later : T ≤ T + n := Nat.le_add_right T n
    calc q * s (T + n + 1) + total (steps T (n + 1)) k * R (T + n + 1)
        = q * s (T + n + 1) + k (T + n) * R (T + n + 1) +
            total (steps T n) k * R (T + n + 1) :=
          (congrArg (q * s (T + n + 1) + ·) ((congrArg (· * R (T + n + 1))
            (steps_last k T n)).trans ((add_mul_split _ _ _).trans (Nat.add_comm _ _)))).trans
            (Nat.add_assoc _ _ _).symm
      _ ≤ q * (r (T + n) * s (T + n)) + total (steps T n) k * R (T + n + 1) :=
          Nat.add_le_add_right (step (T + n) later) _
      _ = r (T + n) * (q * s (T + n) + total (steps T n) k * R (T + n)) :=
          (congrArg (q * (r (T + n) * s (T + n)) + ·) ((congrArg (total (steps T n) k * ·)
            (unit (T + n) later)).trans (mul_turn _ _ _))).trans
          ((congrArg (· + r (T + n) * (total (steps T n) k * R (T + n))) (mul_turn _ _ _)).trans
            (Nat.left_distrib _ _ _).symm)
      _ ≤ r (T + n) * (q * s T * R (T + n)) := Nat.mul_le_mul_left _ before
      _ = q * s T * R (T + n + 1) :=
          (mul_turn _ _ _).trans (congrArg (q * s T * ·) (unit (T + n) later).symm)

/-- The loss law: the quanta counted since `T` number at most `q` times the quantity at
`T`, whatever the refinement. -/
theorem losses_bound {r R s k : Nat → Nat} {q T : Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (step : ∀ t, T ≤ t → q * s (t + 1) + k t * R (t + 1) ≤ q * (r t * s t)) (n : Nat) :
    total (steps T n) k ≤ q * s T :=
  Nat.le_of_mul_le_mul_right
    (Nat.le_trans (Nat.le_add_left _ _) (losses_invariant base unit step n))
    (units_pos base unit refining (Nat.le_add_right T n))

/-- A count positive at arbitrarily late steps has totals over the steps from `T` beyond
every bound. -/
theorem unbounded_of_recurring {k : Nat → Nat} {T : Nat}
    (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < k t) : ∀ m, ∃ n, m ≤ total (steps T n) k
  | 0 => ⟨0, Nat.zero_le _⟩
  | m + 1 => match unbounded_of_recurring recurs m with
    | ⟨n, many⟩ => match recurs (T + n) with
      | ⟨_, after, positive⟩ => match Nat.le.dest after with
        | ⟨j, same⟩ => ⟨n + j + 1, Nat.le_trans (Nat.add_le_add many positive)
            (Nat.le_trans (Nat.add_le_add_right (steps_mono k T n j) _)
              (Nat.le_of_eq ((congrArg (fun u => total (steps T (n + j)) k + k u)
                ((Nat.add_assoc T n j).symm.trans same).symm).trans
                (steps_last k T (n + j)).symm)))⟩

/-- So a count whose totals over the steps from `T` stay within a bound is positive at
only finitely many steps. -/
theorem bounded_not_recurring {k : Nat → Nat} {T B : Nat}
    (bounded : ∀ n, total (steps T n) k ≤ B) : ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < k t :=
  fun recurs => match unbounded_of_recurring (T := T) recurs (B + 1) with
  | ⟨n, many⟩ => Nat.lt_irrefl B (Nat.lt_of_lt_of_le many (bounded n))

/-- Across one step: what remains, with one quantum for a step that lost one, is within
the quantity before the step, counted in the finer unit. -/
theorem quantum_step {r R s : Nat → Nat} {q t : Nat} (nonrising : s (t + 1) ≤ r t * s t) :
    q * s (t + 1) + mark (LosesQuantum r R s q t) * R (t + 1) ≤ q * (r t * s t) :=
  mark_cases (q := fun k => q * s (t + 1) + k * R (t + 1) ≤ q * (r t * s t))
    (fun loses => Nat.le_trans (Nat.le_of_eq ((congrArg (q * s (t + 1) + ·)
      (Nat.one_mul _)).trans (Nat.add_comm _ _))) loses)
    (fun _ => Nat.le_trans (Nat.le_of_eq ((congrArg (q * s (t + 1) + ·)
      (Nat.zero_mul _)).trans (Nat.add_zero _))) (Nat.mul_le_mul_left q nonrising))

/-- The quantum law: the steps since `T` at which a quantity that never rises in the finer
unit loses at least `1/q` of the unit of step `T` number at most `q` times the quantity at
`T`. -/
theorem quantum_bound {r R s : Nat → Nat} {q T : Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (nonrising : ∀ t, T ≤ t → s (t + 1) ≤ r t * s t) (n : Nat) :
    total (steps T n) (fun u => mark (LosesQuantum r R s q u)) ≤ q * s T :=
  losses_bound base unit refining (fun t later => quantum_step (nonrising t later)) n

/-- So losing a quantum does not recur. -/
theorem quantum_not_recurring {r R s : Nat → Nat} {q T : Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (nonrising : ∀ t, T ≤ t → s (t + 1) ≤ r t * s t) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ LosesQuantum r R s q t :=
  fun recurs => bounded_not_recurring (quantum_bound base unit refining nonrising)
    fun N => match recurs N with
    | ⟨t, after, loses⟩ => ⟨t, after, mark_pos.mpr loses⟩

/-! ## The amount law -/

/-- The sum of `ℓ` over the `n` steps from `T`, counted in the unit of step `T + n`: the
amount of each step, counted in the unit after it, splits with the unit at every later
step. -/
def refinedSum (r ℓ : Nat → Nat) (T : Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => r (T + n) * refinedSum r ℓ T n + ℓ (T + n)

/-- The invariant of the amount law. With `R` counting units of each later step per unit of
step `T`: where across each step from `T` on `c` times what remains together with the
amount `ℓ` is within `c` times the quantity before, counted in the finer unit, `c` times
what remains together with the amount summed since `T` is within `c` times the quantity at
`T`. -/
theorem refinedSum_invariant {r R s ℓ : Nat → Nat} {c T : Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t)
    (step : ∀ t, T ≤ t → c * s (t + 1) + ℓ t ≤ c * (r t * s t)) :
    ∀ n, c * s (T + n) + refinedSum r ℓ T n ≤ c * s T * R (T + n)
  | 0 => Nat.le_of_eq ((Nat.add_zero _).trans
      ((Nat.mul_one _).symm.trans (congrArg (c * s T * ·) base.symm)))
  | n + 1 =>
    have before := refinedSum_invariant base unit step n
    have later : T ≤ T + n := Nat.le_add_right T n
    calc c * s (T + n + 1) + refinedSum r ℓ T (n + 1)
        = c * s (T + n + 1) + ℓ (T + n) + r (T + n) * refinedSum r ℓ T n :=
          (congrArg (c * s (T + n + 1) + ·) (Nat.add_comm _ _)).trans (Nat.add_assoc _ _ _).symm
      _ ≤ c * (r (T + n) * s (T + n)) + r (T + n) * refinedSum r ℓ T n :=
          Nat.add_le_add_right (step (T + n) later) _
      _ = r (T + n) * (c * s (T + n) + refinedSum r ℓ T n) :=
          (congrArg (· + r (T + n) * refinedSum r ℓ T n) (mul_turn _ _ _)).trans
            (Nat.left_distrib _ _ _).symm
      _ ≤ r (T + n) * (c * s T * R (T + n)) := Nat.mul_le_mul_left _ before
      _ = c * s T * R (T + n + 1) :=
          (mul_turn _ _ _).trans (congrArg (c * s T * ·) (unit (T + n) later).symm)

/-- A sum of amounts each within another is within the other's sum. -/
theorem refinedSum_mono {r a b : Nat → Nat} {T : Nat} (le : ∀ t, T ≤ t → a t ≤ b t) :
    ∀ n, refinedSum r a T n ≤ refinedSum r b T n
  | 0 => Nat.le_refl 0
  | n + 1 => Nat.add_le_add (Nat.mul_le_mul_left _ (refinedSum_mono le n))
      (le (T + n) (Nat.le_add_right T n))

/-- Scaling every amount scales the sum. -/
theorem refinedSum_mul (r ℓ : Nat → Nat) (p T : Nat) :
    ∀ n, refinedSum r (fun t => p * ℓ t) T n = p * refinedSum r ℓ T n
  | 0 => (Nat.mul_zero p).symm
  | n + 1 => (congrArg (· + p * ℓ (T + n)) ((congrArg (r (T + n) * ·)
      (refinedSum_mul r ℓ p T n)).trans (mul_turn _ _ _))).trans (Nat.left_distrib _ _ _).symm

/-- Quanta are amounts: counted in the unit of step `T + n`, `k t` quanta of the unit of step
`T` at each step sum to their count times `R (T + n)`. -/
theorem refinedSum_marks {r R k : Nat → Nat} {T : Nat}
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) :
    ∀ n, refinedSum r (fun t => k t * R (t + 1)) T n = total (steps T n) k * R (T + n)
  | 0 => (Nat.zero_mul _).symm
  | n + 1 =>
    (congrArg (· + k (T + n) * R (T + n + 1)) ((congrArg (r (T + n) * ·)
      (refinedSum_marks unit n)).trans ((mul_turn _ _ _).trans
        (congrArg (total (steps T n) k * ·) (unit (T + n) (Nat.le_add_right T n)).symm)))).trans
    ((add_mul_split _ _ _).symm.trans (congrArg (· * R (T + n + 1)) (steps_last k T n).symm))

/-- Counts from amounts: where at each step from `T` on the count of quanta of the unit of
step `T` is within `p` times an amount, and the amount summed since `T` is within `B` units
of step `T`, the count summed since `T` is within `p B`. -/
theorem counts_of_amounts {r R k ℓ : Nat → Nat} {p B T : Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (each : ∀ t, T ≤ t → k t * R (t + 1) ≤ p * ℓ t)
    (amount : ∀ n, refinedSum r ℓ T n ≤ B * R (T + n)) (n : Nat) :
    total (steps T n) k ≤ p * B :=
  Nat.le_of_mul_le_mul_right
    (calc total (steps T n) k * R (T + n)
        = refinedSum r (fun t => k t * R (t + 1)) T n := (refinedSum_marks unit n).symm
      _ ≤ refinedSum r (fun t => p * ℓ t) T n := refinedSum_mono each n
      _ = p * refinedSum r ℓ T n := refinedSum_mul r ℓ p T n
      _ ≤ p * (B * R (T + n)) := Nat.mul_le_mul_left p (amount n)
      _ = p * B * R (T + n) := (mul_assoc_nat p B _).symm)
    (units_pos base unit refining (Nat.le_add_right T n))

/-! ## The quantum law on flows -/

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- The quantum law on a flow. Balanced at resolution `r` and dissipative, over a family
without repetition closed at every step from `T` on, the steps since `T` at which the
family loses at least `1/q` of the unit of step `T` number at most `q` times its stock at
`T`. -/
theorem quantum_bound {r R : Nat → Nat} (balances : L.BalancesAt r W)
    (dissipative : L.Dissipative) {cs : List C} (distinct : Distinct cs) {T : Nat}
    (closed : ∀ t, T ≤ t → L.ClosedAt cs t) (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (q n : Nat) :
    total (steps T n) (fun u => mark (LosesQuantum r R (W.stock cs) q u)) ≤ q * W.stock cs T :=
  Becoming.quantum_bound base unit refining (fun u after => Nat.le_trans (Nat.le_add_right _ _)
    (balances.lowers (dissipative cs u distinct (closed u after)))) n

/-- So a closed family's losing a quantum does not recur. -/
theorem quantum_not_recurring {r R : Nat → Nat} (balances : L.BalancesAt r W)
    (dissipative : L.Dissipative) {cs : List C} (distinct : Distinct cs) {T : Nat}
    (closed : ∀ t, T ≤ t → L.ClosedAt cs t) (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (q : Nat) : ¬ ∀ N, ∃ t, N ≤ t ∧ LosesQuantum r R (W.stock cs) q t :=
  Becoming.quantum_not_recurring base unit refining (fun u after =>
    Nat.le_trans (Nat.le_add_right _ _)
      (balances.lowers (dissipative cs u distinct (closed u after))))

/-- Dissipated on, a step at which some formation takes from the family loses at least one
unit of the step after it. -/
theorem takes_loses {r : Nat → Nat} (balances : L.BalancesAt r W) {cs : List C} {t : Nat}
    (dissipates : L.DissipatesOn cs t) (takes : 0 < L.takers cs t) :
    LosesQuantum r (fun _ => 1) (W.stock cs) 1 t :=
  Nat.le_trans (Nat.le_of_eq ((Nat.add_comm _ _).trans (congrArg (· + 1) (Nat.one_mul _))))
    (Nat.le_trans (Nat.add_le_add_left takes _)
      (Nat.le_trans (balances.lowers dissipates) (Nat.le_of_eq (Nat.one_mul _).symm)))

/-- With the unit fixed from some step on, taking from a closed family does not recur. -/
theorem taking_not_recurring {r : Nat → Nat} (balances : L.BalancesAt r W)
    (dissipative : L.Dissipative) {cs : List C} (distinct : Distinct cs) {T : Nat}
    (closed : ∀ t, T ≤ t → L.ClosedAt cs t) (fixed : ∀ t, T ≤ t → r t = 1) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  fun recurs => quantum_not_recurring balances dissipative distinct closed (R := fun _ => 1) rfl
    (fun t later => ((Nat.mul_one _).trans (fixed t later)).symm)
    (fun t later => Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq (fixed t later).symm)) 1
    fun N => match recurs (N + T) with
      | ⟨t, after, takes⟩ =>
        ⟨t, Nat.le_trans (Nat.le_add_right N T) after,
         takes_loses balances (dissipative cs t distinct (closed t
           (Nat.le_trans (Nat.le_add_left T N) after))) takes⟩

end Flow

/-! ## The refinement counted -/

/-- Listing the members of a list as present leaves every total as it was. -/
theorem total_map_some {α : Type} (q : Option α → Nat) :
    ∀ l : List α, total (l.map some) q = total l fun a => q (some a)
  | [] => rfl
  | a :: l => congrArg (q (some a) + ·) (total_map_some q l)

theorem mem_map_some {α : Type} {a : α} : ∀ {l : List α}, a ∈ l → some a ∈ l.map some
  | _ :: _, .head _ => .head _
  | b :: _, .tail _ mem => .tail (some b) (mem_map_some mem)

theorem of_mem_map_some {α : Type} : ∀ {l : List α} {f : Option α}, f ∈ l.map some →
    ∃ a, a ∈ l ∧ some a = f
  | a :: l, _, .head _ => ⟨a, .head l, rfl⟩
  | a :: _, _, .tail _ mem => match of_mem_map_some mem with
    | ⟨b, inl, same⟩ => ⟨b, .tail a inl, same⟩

/-- Across a step, the unit splitting into `s + 1` finer units adds `s` times the level. -/
theorem refine_eq (s l g : Nat) : (s + 1) * l + g = l + (s * l + g) :=
  (congrArg (· + g) ((add_mul_split s 1 l).trans ((congrArg (s * l + ·) (Nat.one_mul l)).trans
    (Nat.add_comm _ _)))).trans (Nat.add_assoc _ _ _)

namespace Flow

/-- The flow with the refinement counted. Across the step from `t` the unit splits into
`split t + 1` finer units, so each condition's level, counted in the finer unit, is
`split t + 1` times itself. The refinement is one more formation taking part, `none`: it
gives each condition the `split t` times its level that the splitting adds, and takes
nothing. The flow's own formations are the others. -/
def withRefinement (L : Flow F C) (W : Web F C) (split : Nat → Nat) : Flow (Option F) C :=
  ⟨fun t => none :: (L.present t).map some,
   fun t f c => match f with
     | none => 0
     | some g => L.take t g c,
   fun t f c => match f with
     | none => split t * W.level t c
     | some g => L.give t g c⟩

end Flow

/-- The web read with the refinement among the formations: the refinement is never active,
requires and draws on nothing. -/
def Web.withRefinement (W : Web F C) : Web (Option F) C :=
  ⟨W.level,
   fun t f => match f with
     | none => False
     | some g => W.active t g,
   fun t f c => match f with
     | none => False
     | some g => W.requires t g c,
   fun t f c => match f with
     | none => 0
     | some g => W.need t g c,
   fun t f c => match f with
     | none => False
     | some g => W.draws t g c⟩

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- With the refinement counted, what is taken from a condition is what the flow takes. -/
theorem withRefinement_taken (split : Nat → Nat) (t : Nat) (c : C) :
    (L.withRefinement W split).taken t c = L.taken t c :=
  (Nat.zero_add _).trans (total_map_some _ _)

/-- With the refinement counted, what is given to a condition is what the splitting adds
together with what the flow gives. -/
theorem withRefinement_given (split : Nat → Nat) (t : Nat) (c : C) :
    (L.withRefinement W split).given t c = split t * W.level t c + L.given t c :=
  congrArg (split t * W.level t c + ·) (total_map_some _ _)

/-- Balance at a refining unit is the spine's balance with the refinement counted among the
formations: the finer units the splitting adds are given by the refinement. -/
theorem balancesAt_iff_withRefinement {split : Nat → Nat} :
    L.BalancesAt (fun t => split t + 1) W ↔
      (L.withRefinement W split).Balances W.withRefinement :=
  ⟨fun balances t c =>
    ((congrArg (W.level (t + 1) c + ·) (withRefinement_taken split t c)).trans
      ((balances t c).trans (refine_eq _ _ _))).trans
      (congrArg (W.level t c + ·) (withRefinement_given split t c)).symm,
   fun balances t c =>
    ((congrArg (W.level (t + 1) c + ·) (withRefinement_taken split t c)).symm.trans
      ((balances t c).trans (congrArg (W.level t c + ·) (withRefinement_given split t c)))).trans
      (refine_eq _ _ _).symm⟩

/-- With the refinement counted, the flow dissipates on a family exactly where its own
formations do and the refinement gives the family nothing: the refinement gives without
taking, so wherever the unit splits and the family stands at something, it does not
dissipate. -/
theorem withRefinement_dissipatesOn_iff {split : Nat → Nat} {cs : List C} {t : Nat} :
    (L.withRefinement W split).DissipatesOn cs t ↔
      L.DissipatesOn cs t ∧ split t * W.stock cs t = 0 :=
  ⟨fun dissipates =>
    ⟨fun g present => dissipates (some g) (.tail none (mem_map_some present)),
     Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_of_eq (total_mul (split t) (W.level t) cs).symm)
       (Nat.le_trans (Nat.le_add_right _ _)
         (Nat.le_trans (dissipates none (.head _)) (Nat.le_of_eq (total_zero cs)))))⟩,
   fun ⟨dissipates, none_gives⟩ f present => match f, present with
     | none, _ => Nat.le_trans (Nat.le_of_eq ((congrArg (· + sign (total cs fun _ => 0))
           ((total_mul (split t) (W.level t) cs).trans none_gives)).trans
         ((Nat.zero_add _).trans (congrArg sign (total_zero cs)))))
         (Nat.zero_le _)
     | some _, .tail _ mem => match of_mem_map_some mem with
       | ⟨h, inl, same⟩ => Option.some.inj same ▸ dissipates h inl⟩

/-- A family closed with the refinement counted is closed for the flow's own formations. -/
theorem ClosedAt.of_withRefinement {split : Nat → Nat} {cs : List C} {t : Nat}
    (closed : (L.withRefinement W split).ClosedAt cs t) : L.ClosedAt cs t :=
  fun f present c out => closed (some f) (.tail none (mem_map_some present)) c out

/-- Where the refinement gives nothing across a step, a family closed for the flow's own
formations is closed with the refinement counted. -/
theorem ClosedAt.withRefinement {split : Nat → Nat} {cs : List C} {t : Nat}
    (closed : L.ClosedAt cs t) (unrefined : ∀ c, split t * W.level t c = 0) :
    (L.withRefinement W split).ClosedAt cs t :=
  fun f present c out => match f, present with
  | none, _ => ⟨rfl, unrefined c⟩
  | some _, .tail _ mem => match of_mem_map_some mem with
    | ⟨g, inl, same⟩ => Option.some.inj same ▸ closed g inl c out

/-- Enclosed with the refinement counted, the step is enclosed for the flow's own
formations. -/
theorem Enclosed.of_withRefinement {split : Nat → Nat} {t : Nat}
    (enclosed : (L.withRefinement W split).Enclosed t) : L.Enclosed t :=
  match enclosed with
  | ⟨cs, distinct, closed⟩ => ⟨cs, distinct, closed.of_withRefinement⟩

/-- Enclosed and dissipative across a step with the refinement counted, the refinement gives
nothing across it: it gives without taking, which dissipation excludes inside the closed
family and closure excludes outside it. -/
theorem refinement_gives_nothing {split : Nat → Nat} {t : Nat}
    (enclosed : (L.withRefinement W split).Enclosed t)
    (dissipates : ∀ cs, Distinct cs → (L.withRefinement W split).ClosedAt cs t →
      (L.withRefinement W split).DissipatesOn cs t) :
    ∀ c, split t * W.level t c = 0 :=
  match enclosed with
  | ⟨cs, distinct, closed⟩ =>
    have inside := (withRefinement_dissipatesOn_iff.mp (dissipates cs distinct closed)).2
    fun c => eq_zero_of_not_pos fun gives =>
      (fun out : ¬ c ∈ cs => Nat.lt_irrefl 0
        (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (closed none (.head _) c out).2)))
      fun mem => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives
        (Nat.le_trans (le_total_of_mem (q := fun c => split t * W.level t c) mem)
          (Nat.le_of_eq ((total_mul (split t) (W.level t) cs).trans inside))))

/-- Taking needs the refinement. Balanced at a unit splitting into `split t + 1` at each
step and dissipative, over a family without repetition closed from `T` on, where from `T`
on the refinement gives the family nothing, taking from it does not recur: counted in the unit of
each step, its stock falls by at least one at every taking step. So taking from a closed
family at arbitrarily late steps needs the refinement to give it something at arbitrarily
late steps. -/
theorem taking_needs_refinement {split : Nat → Nat}
    (balances : L.BalancesAt (fun t => split t + 1) W) (dissipative : L.Dissipative)
    {cs : List C} (distinct : Distinct cs) {T : Nat} (closed : ∀ t, T ≤ t → L.ClosedAt cs t)
    (unrefined : ∀ t, T ≤ t → split t * W.stock cs t = 0) :
    ¬ ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers cs t :=
  bounded_not_recurring (B := 1 * W.stock cs T)
    (losses_bound (r := fun _ => 1) (R := fun _ => 1) (s := W.stock cs) (q := 1) rfl
      (fun _ _ => rfl) (fun _ _ => Nat.one_pos)
      (fun t later => Nat.le_trans (Nat.le_of_eq ((congrArg (· + L.takers cs t * 1)
          (Nat.one_mul _)).trans (congrArg (W.stock cs (t + 1) + ·) (Nat.mul_one _))))
        (Nat.le_trans (balances.lowers (dissipative cs t distinct (closed t later)))
          (Nat.le_of_eq ((add_mul_split (split t) 1 _).trans
            ((congrArg (· + 1 * W.stock cs t) (unrefined t later)).trans
              ((Nat.zero_add _).trans (congrArg (1 * ·) (Nat.one_mul _).symm))))))))

end Flow

/-! ## A world from a step on -/

namespace World

/-- The world from step `T` on: its step `t` is step `T + t`. -/
def after (w : World) (T : Nat) : World :=
  World.of w.Relatum (⟨fun t => w.flow.present (T + t), fun t => w.flow.take (T + t),
    fun t => w.flow.give (T + t)⟩) (⟨fun t => w.web.level (T + t), fun t => w.web.active (T + t), fun t => w.web.requires (T + t),
    fun t => w.web.need (T + t), fun t => w.web.draws (T + t)⟩)

variable {w : World}

theorem after_counted (counted : w.Counted) (T : Nat) : (w.after T).Counted :=
  match counted with
  | ⟨alive, census⟩ => ⟨fun t => alive (T + t), fun t => census (T + t)⟩

theorem after_embodied (embodied : w.Embodied) (T : Nat) : (w.after T).Embodied :=
  fun x t => embodied x (T + t)

/-- Where from `T` on the refinement gives nothing, the world from `T` on is balanced. -/
theorem after_balanced {split : Nat → Nat}
    (balances : w.flow.BalancesAt (fun t => split t + 1) w.web) {T : Nat}
    (unrefined : ∀ t, T ≤ t → ∀ x, split t * w.web.level t x = 0) : (w.after T).Balanced :=
  fun t c => (balances (T + t) c).trans ((congrArg (· + w.flow.given (T + t) c)
    ((add_mul_split (split (T + t)) 1 _).trans ((congrArg (· + 1 * w.web.level (T + t) c)
      (unrefined (T + t) (Nat.le_add_right T t) c)).trans
      ((Nat.zero_add _).trans (Nat.one_mul _))))))

theorem after_dissipative {T : Nat}
    (dissipative : ∀ t, T ≤ t → ∀ cs, Distinct cs → w.flow.ClosedAt cs t →
      w.flow.DissipatesOn cs t) : (w.after T).Dissipative :=
  fun cs t => dissipative (T + t) (Nat.le_add_right T t) cs

theorem after_enclosed {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) :
    ∀ t, 0 ≤ t → (w.after T).flow.Enclosed t :=
  fun t _ => enclosed (T + t) (Nat.le_add_right T t)

/-- What happens at arbitrarily late steps of a world happens at arbitrarily late steps of it
from any step on. -/
theorem after_recurs {T : Nat} {p : Nat → w.Relatum → Prop}
    (recurs : ∀ N, ∃ t x, N ≤ t ∧ p t x) : ∀ N, ∃ t x, N ≤ t ∧ p (T + t) x :=
  fun N => match recurs (T + N) with
  | ⟨_, x, later, holds⟩ => match Nat.le.dest later with
    | ⟨k, same⟩ => ⟨N + k, x, Nat.le_add_right N k,
        Eq.subst (motive := fun u => p u x) (same.symm.trans (Nat.add_assoc T N k)) holds⟩

/-- Rest of the world from step `T` on is rest of the world: where the world after `T` rests
from step `N` on, the world rests from step `T + N` on. -/
theorem restsFrom_of_after {T N : Nat} (rest : (w.after T).RestsFrom N) : w.RestsFrom (T + N) :=
  fun _ later x => match Nat.le.dest later with
  | ⟨k, same⟩ => Eq.subst (motive := fun u => ¬ w.web.Arises u x ∧ ¬ w.web.Ceases u x)
      ((Nat.add_assoc T N k).symm.trans same) (rest (N + k) (Nat.le_add_right N k) x)

/-- That the world from step `T` on rests from some step on cannot be refuted, so that the world
rests from some step on cannot be refuted. -/
theorem rests_unrefuted_of_after {T : Nat}
    (rest : ¬ ¬ ∃ N, (w.after T).RestsFrom N) : ¬ ¬ ∃ N, w.RestsFrom N :=
  fun none_ => rest fun ⟨N, quiet⟩ => none_ ⟨T + N, restsFrom_of_after quiet⟩

/-- Rest wherever the refinement gives nothing. In a world with a census whose relata are
embodied, balanced at a unit splitting into `split t + 1` at each step and dissipative,
with every step from `T` on enclosed, where from `T` on the refinement gives no relatum
anything, that the world rests from some step on cannot be refuted. -/
theorem rests_unrefuted_without_refinement (counted : w.Counted) (embodied : w.Embodied)
    {split : Nat → Nat}
    (balances : w.flow.BalancesAt (fun t => split t + 1) w.web) (dissipative : w.Dissipative)
    {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t)
    (unrefined : ∀ t, T ≤ t → ∀ x, split t * w.web.level t x = 0) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  rests_unrefuted_of_after (rests_unrefuted_enclosed (after_counted counted T)
    (after_embodied embodied T)
    (after_balanced balances unrefined) (after_dissipative fun t _ cs => dissipative cs t)
    (after_enclosed enclosed))

/-- The rest theorem at every resolution, with the refinement counted. In a world with a
census whose relata are embodied, balanced at a unit splitting into `split t + 1` at each
step, and, with the refinement counted among the formations, dissipative and enclosed at
every step from `T` on, that the world rests from some step on cannot be refuted. Counted so,
balance at a refining unit is the spine's balance (`Flow.balancesAt_iff_withRefinement`), and
dissipation and enclosure are the spine's, so no premise is added to the spine's. -/
theorem rests_unrefuted_refinement_counted (counted : w.Counted) (embodied : w.Embodied)
    {split : Nat → Nat} (balances : w.flow.BalancesAt (fun t => split t + 1) w.web)
    (dissipative : (w.flow.withRefinement w.web split).Dissipative) {T : Nat}
    (enclosed : ∀ t, T ≤ t → (w.flow.withRefinement w.web split).Enclosed t) :
    ¬ ¬ ∃ N, w.RestsFrom N :=
  have unrefined : ∀ t, T ≤ t → ∀ x, split t * w.web.level t x = 0 := fun t later =>
    Flow.refinement_gives_nothing (enclosed t later) fun cs => dissipative cs t
  rests_unrefuted_of_after (rests_unrefuted_enclosed (after_counted counted T)
    (after_embodied embodied T) (after_balanced balances unrefined)
    (after_dissipative fun t later cs distinct closed =>
      (Flow.withRefinement_dissipatesOn_iff.mp
        (dissipative cs t distinct (closed.withRefinement (unrefined t later)))).1)
    (after_enclosed fun t later => (enclosed t later).of_withRefinement))

/-- So continued arising needs openness, at every resolution, with the refinement counted:
in a world with a census whose relata are embodied, balanced at a refining unit and, with
the refinement counted, dissipative, where arising recurs, no step begins a stretch in
which every step is enclosed with the refinement counted. -/
theorem arising_opens_refinement_counted (counted : w.Counted) (embodied : w.Embodied)
    {split : Nat → Nat} (balances : w.flow.BalancesAt (fun t => split t + 1) w.web)
    (dissipative : (w.flow.withRefinement w.web split).Dissipative)
    (arising : w.ArisingRecurs) (T : Nat) :
    ¬ ∀ t, T ≤ t → (w.flow.withRefinement w.web split).Enclosed t :=
  fun enclosed => (not_recurring_of_rests_unrefuted
    (rests_unrefuted_refinement_counted counted embodied balances dissipative enclosed)).1 arising

/-- Without counting the refinement, continued arising needs openness or the refinement's
giving: in a world with a census whose relata are embodied, balanced at a refining unit and
dissipative, where arising recurs, no step begins a stretch in which every step is enclosed
and the refinement gives nothing. -/
theorem arising_needs_refinement (counted : w.Counted) (embodied : w.Embodied)
    {split : Nat → Nat} (balances : w.flow.BalancesAt (fun t => split t + 1) w.web)
    (dissipative : w.Dissipative) (arising : w.ArisingRecurs) (T : Nat) :
    ¬ ((∀ t, T ≤ t → w.flow.Enclosed t) ∧
      ∀ t, T ≤ t → ∀ x, split t * w.web.level t x = 0) :=
  fun ⟨enclosed, unrefined⟩ =>
    (not_recurring_of_rests_unrefuted
      (rests_unrefuted_without_refinement counted embodied balances dissipative enclosed
        unrefined)).1
      arising

end World

/-! ## Loss in proportion to what is taken -/

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- Across the step from `t`, the family gets back at most `q` parts in `q + 1` of what is
taken from it: together its exchanges lose at least a `(q + 1)`th of what is taken, whatever
the unit. -/
def DissipatesBy (q : Nat) (cs : List C) (t : Nat) : Prop :=
  (q + 1) * L.replenishment cs t ≤ q * L.uptake cs t

/-- Dissipation in proportion: across every step, every family without repetition closed
across it is dissipated on in proportion `q`. -/
def DissipativeBy (q : Nat) : Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → L.DissipatesBy q cs t

/-- Where every formation taking part gives the family at most `q` parts in `q + 1` of what
it takes from it, the family is dissipated on in proportion `q`. -/
theorem DissipatesBy.of_each {q : Nat} {cs : List C} {t : Nat}
    (each : ∀ f, f ∈ L.present t → (q + 1) * total cs (L.give t f) ≤ q * total cs (L.take t f)) :
    L.DissipatesBy q cs t :=
  calc (q + 1) * L.replenishment cs t
      = total (L.present t) (fun f => (q + 1) * total cs (L.give t f)) :=
        (congrArg ((q + 1) * ·) (total_swap (fun f c => L.give t f c) cs (L.present t)).symm).trans
          (total_mul (q + 1) (fun f => total cs (L.give t f)) (L.present t)).symm
    _ ≤ total (L.present t) (fun f => q * total cs (L.take t f)) :=
        total_le (L.present t) each
    _ = q * L.uptake cs t :=
        (total_mul q (fun f => total cs (L.take t f)) (L.present t)).trans
          (congrArg (q * ·) (total_swap (fun f c => L.take t f c) cs (L.present t)))

/-- So the family's replenishment is within its uptake. -/
theorem DissipatesBy.replenishment_le {q : Nat} {cs : List C} {t : Nat}
    (dissipates : L.DissipatesBy q cs t) : L.replenishment cs t ≤ L.uptake cs t :=
  Nat.le_of_mul_le_mul_left
    (Nat.le_trans dissipates (Nat.mul_le_mul_right _ (Nat.le_succ q))) (Nat.succ_pos q)

/-- Dissipated on in proportion `q`, the family's stock never rises, counted in the finer
unit. -/
theorem BalancesAt.nonrisingBy {r : Nat → Nat} (balances : L.BalancesAt r W) {q : Nat}
    {cs : List C} {t : Nat} (dissipates : L.DissipatesBy q cs t) :
    W.stock cs (t + 1) ≤ r t * W.stock cs t :=
  le_of_add_le_add_right (L.replenishment cs t)
    (Nat.le_trans (Nat.add_le_add_left dissipates.replenishment_le _)
      (Nat.le_of_eq (balances.over cs t)))

/-- Dissipated on in proportion `q`, `q` times the family's stock after the step, together
with its replenishment, is within `q` times its stock before, counted in the finer unit. -/
theorem BalancesAt.lowersBy {r : Nat → Nat} (balances : L.BalancesAt r W) {q : Nat}
    {cs : List C} {t : Nat} (dissipates : L.DissipatesBy q cs t) :
    q * W.stock cs (t + 1) + L.replenishment cs t ≤ q * (r t * W.stock cs t) :=
  le_of_add_le_add_right (q * L.replenishment cs t) (calc
    q * W.stock cs (t + 1) + L.replenishment cs t + q * L.replenishment cs t
        = q * W.stock cs (t + 1) + (q + 1) * L.replenishment cs t :=
          (Nat.add_assoc _ _ _).trans (congrArg (q * W.stock cs (t + 1) + ·)
            ((Nat.add_comm _ _).trans ((congrArg (q * L.replenishment cs t + ·)
              (Nat.one_mul _).symm).trans (add_mul_split q 1 _).symm)))
    _ ≤ q * W.stock cs (t + 1) + q * L.uptake cs t := Nat.add_le_add_left dissipates _
    _ = q * (r t * W.stock cs t) + q * L.replenishment cs t :=
          (Nat.left_distrib _ _ _).symm.trans ((congrArg (q * ·) (balances.over cs t)).trans
            (Nat.left_distrib _ _ _)))

end Flow

/-- Across the step from `t`, `c` gains at least `1/p` of the unit counted by `R`: counted
in the unit of step `t + 1`, `p` times its gain is at least `R (t + 1)`. -/
def Web.Gains (W : Web F C) (r R : Nat → Nat) (p t : Nat) (c : C) : Prop :=
  R (t + 1) + p * (r t * W.level t c) ≤ p * W.level (t + 1) c

instance (W : Web F C) (r R : Nat → Nat) (p t : Nat) (c : C) : Decidable (W.Gains r R p t c) :=
  Nat.decLe _ _

/-- The members of a list gaining at least `1/p` of the unit across the step from `t`. -/
def Web.gainers (W : Web F C) (r R : Nat → Nat) (p t : Nat) (gs : List C) : Nat :=
  total gs fun c => mark (W.Gains r R p t c)

/-- Across the step from `t`, `c` loses at least `1/p` of the unit counted by `R`: counted
in the unit of step `t + 1`, `p` times its fall is at least `R (t + 1)`. -/
def Web.Loses (W : Web F C) (r R : Nat → Nat) (p t : Nat) (c : C) : Prop :=
  R (t + 1) + p * W.level (t + 1) c ≤ p * (r t * W.level t c)

instance (W : Web F C) (r R : Nat → Nat) (p t : Nat) (c : C) : Decidable (W.Loses r R p t c) :=
  Nat.decLe _ _

/-- The members of a list losing at least `1/p` of the unit across the step from `t`. -/
def Web.losers (W : Web F C) (r R : Nat → Nat) (p t : Nat) (ls : List C) : Nat :=
  total ls fun c => mark (W.Loses r R p t c)

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- Balanced at a resolution, what a condition gains across a step is given to it. -/
theorem BalancesAt.gain_given {r : Nat → Nat} (balances : L.BalancesAt r W) {R : Nat → Nat}
    {p t : Nat} {c : C} (gains : W.Gains r R p t c) : R (t + 1) ≤ p * L.given t c :=
  le_of_add_le_add_right (p * (r t * W.level t c)) (Nat.le_trans gains
    (Nat.le_trans (Nat.mul_le_mul_left p (Nat.le_trans (Nat.le_add_right _ (L.taken t c))
        (Nat.le_of_eq (balances t c))))
      (Nat.le_of_eq ((Nat.left_distrib _ _ _).trans (Nat.add_comm _ _)))))

/-- A total scaled after summing is the total of the scaled terms. -/
theorem total_mul_right {α : Type} (q : α → Nat) (g : Nat) (as : List α) :
    total as q * g = total as fun a => q a * g :=
  (Nat.mul_comm _ _).trans ((total_mul g q as).symm.trans
    (total_congr (fun a => Nat.mul_comm g (q a)) as))

/-- Dissipated on in proportion `q`, the members of a list without repetition within the
family that gain at least `1/p` of the unit across a step make the family lose at least
`1/(p q)` of it each: `p q` times the stock after the step, together with one unit of
`R` for each of them, is within `p q` times the stock before. -/
theorem BalancesAt.gainers_lose {r : Nat → Nat} (balances : L.BalancesAt r W) {R : Nat → Nat}
    {p q : Nat} {cs gs : List C} {t : Nat} (dissipates : L.DissipatesBy q cs t)
    (distinct : Distinct gs) (within : ∀ c, c ∈ gs → c ∈ cs) :
    p * q * W.stock cs (t + 1) + W.gainers r R p t gs * R (t + 1) ≤
      p * q * (r t * W.stock cs t) :=
  calc p * q * W.stock cs (t + 1) + W.gainers r R p t gs * R (t + 1)
      ≤ p * q * W.stock cs (t + 1) + p * L.replenishment cs t :=
        Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (total_mul_right _ _ gs))
          (Nat.le_trans (total_le gs fun c _ => mark_cases
              (q := fun m => m * R (t + 1) ≤ p * L.given t c)
              (fun gains => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _))
                (balances.gain_given gains))
              (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_mul _)) (Nat.zero_le _)))
            (Nat.le_trans (Nat.le_of_eq (total_mul p (L.given t) gs))
              (Nat.mul_le_mul_left p (total_le_of_support distinct fun c mem _ =>
                within c mem))))) _
    _ = p * (q * W.stock cs (t + 1) + L.replenishment cs t) :=
        (congrArg (· + p * L.replenishment cs t) (mul_assoc_nat p q _)).trans
          (Nat.left_distrib _ _ _).symm
    _ ≤ p * (q * (r t * W.stock cs t)) := Nat.mul_le_mul_left p (balances.lowersBy dissipates)
    _ = p * q * (r t * W.stock cs t) := (mul_assoc_nat p q _).symm

/-- Each relatum gaining at least `1/p` of the unit is given at least that: `R (t + 1)` for
each is within `p` times what the list is given. -/
theorem BalancesAt.gainers_le {r : Nat → Nat} (balances : L.BalancesAt r W) (R : Nat → Nat)
    (p t : Nat) (gs : List C) : W.gainers r R p t gs * R (t + 1) ≤ p * L.replenishment gs t :=
  Nat.le_trans (Nat.le_of_eq (total_mul_right _ _ gs))
    (Nat.le_trans (total_le gs fun c _ => mark_cases
        (q := fun m => m * R (t + 1) ≤ p * L.given t c)
        (fun gains => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _)) (balances.gain_given gains))
        (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_mul _)) (Nat.zero_le _)))
      (Nat.le_of_eq (total_mul p (L.given t) gs)))

/-- Dissipated on in proportion `q`, `q + 1` times the family's stock after the step,
together with its uptake, is within `q + 1` times its stock before, counted in the finer
unit. -/
theorem BalancesAt.lowersTaking {r : Nat → Nat} (balances : L.BalancesAt r W) {q : Nat}
    {cs : List C} {t : Nat} (dissipates : L.DissipatesBy q cs t) :
    (q + 1) * W.stock cs (t + 1) + L.uptake cs t ≤ (q + 1) * (r t * W.stock cs t) :=
  le_of_add_le_add_right (q * L.uptake cs t) (calc
    (q + 1) * W.stock cs (t + 1) + L.uptake cs t + q * L.uptake cs t
        = (q + 1) * (W.stock cs (t + 1) + L.uptake cs t) :=
          (Nat.add_assoc _ _ _).trans ((congrArg ((q + 1) * W.stock cs (t + 1) + ·)
            ((Nat.add_comm _ _).trans ((congrArg (q * L.uptake cs t + ·)
              (Nat.one_mul _).symm).trans (add_mul_split q 1 _).symm))).trans
            (Nat.left_distrib _ _ _).symm)
    _ = (q + 1) * (r t * W.stock cs t) + (q + 1) * L.replenishment cs t :=
          (congrArg ((q + 1) * ·) (balances.over cs t)).trans (Nat.left_distrib _ _ _)
    _ ≤ (q + 1) * (r t * W.stock cs t) + q * L.uptake cs t :=
          Nat.add_le_add_left dissipates _)

/-- The amount law. Balanced at a resolution and dissipative in proportion `q`, over a
family without repetition closed at every step from `T` on, everything taken from the
family since `T` is, in the unit of step `T`, at most `q + 1` times its stock at `T`. -/
theorem uptake_bound {r : Nat → Nat} (balances : L.BalancesAt r W) {q : Nat}
    (dissipative : L.DissipativeBy q) {cs : List C} (distinct : Distinct cs) {T : Nat}
    (closed : ∀ t, T ≤ t → L.ClosedAt cs t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (n : Nat) :
    refinedSum r (L.uptake cs) T n ≤ (q + 1) * W.stock cs T * R (T + n) :=
  Nat.le_trans (Nat.le_add_left _ _) (refinedSum_invariant base unit
    (fun t later => balances.lowersTaking (dissipative cs t distinct (closed t later))) n)

/-- Under the same premises, everything given back to the family since `T` is, in the unit
of step `T`, at most `q` times its stock at `T`. -/
theorem replenishment_bound {r : Nat → Nat} (balances : L.BalancesAt r W) {q : Nat}
    (dissipative : L.DissipativeBy q) {cs : List C} (distinct : Distinct cs) {T : Nat}
    (closed : ∀ t, T ≤ t → L.ClosedAt cs t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (n : Nat) :
    refinedSum r (L.replenishment cs) T n ≤ q * W.stock cs T * R (T + n) :=
  Nat.le_trans (Nat.le_add_left _ _) (refinedSum_invariant base unit
    (fun t later => balances.lowersBy (dissipative cs t distinct (closed t later))) n)

/-- The formations taking part that take at least `1/p` of the unit counted by `R` from
the family across the step from `t`. -/
def takersAbove (R : Nat → Nat) (p : Nat) (cs : List C) (t : Nat) : Nat :=
  total (L.present t) fun f => mark (R (t + 1) ≤ p * total cs (L.take t f))

/-- Each formation taking at least `1/p` of the unit from the family takes at least that:
`R (t + 1)` for each is within `p` times the family's uptake. -/
theorem takersAbove_le (R : Nat → Nat) (p : Nat) (cs : List C) (t : Nat) :
    L.takersAbove R p cs t * R (t + 1) ≤ p * L.uptake cs t :=
  Nat.le_trans (Nat.le_of_eq (total_mul_right _ _ _))
    (Nat.le_trans (total_le (L.present t) fun f _ => mark_cases
        (q := fun m => m * R (t + 1) ≤ p * total cs (L.take t f))
        (fun takes => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _)) takes)
        (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_mul _)) (Nat.zero_le _)))
      (Nat.le_of_eq ((total_mul p (fun f => total cs (L.take t f)) (L.present t)).trans
        (congrArg (p * ·) (total_swap (fun f c => L.take t f c) cs (L.present t))))))

/-- Dissipated on in proportion `q`, each formation taking at least `1/p` of the unit from
the family makes it lose at least `1/(p (q + 1))` of the unit. -/
theorem BalancesAt.takers_lose {r : Nat → Nat} (balances : L.BalancesAt r W) {R : Nat → Nat}
    {p q : Nat} {cs : List C} {t : Nat} (dissipates : L.DissipatesBy q cs t) :
    p * (q + 1) * W.stock cs (t + 1) + L.takersAbove R p cs t * R (t + 1) ≤
      p * (q + 1) * (r t * W.stock cs t) :=
  calc p * (q + 1) * W.stock cs (t + 1) + L.takersAbove R p cs t * R (t + 1)
      ≤ p * (q + 1) * W.stock cs (t + 1) + p * L.uptake cs t :=
        Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (total_mul_right _ _ _))
          (Nat.le_trans (total_le (L.present t) fun f _ => mark_cases
              (q := fun m => m * R (t + 1) ≤ p * total cs (L.take t f))
              (fun takes => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _)) takes)
              (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_mul _)) (Nat.zero_le _)))
            (Nat.le_of_eq ((total_mul p (fun f => total cs (L.take t f)) (L.present t)).trans
              (congrArg (p * ·) (total_swap (fun f c => L.take t f c) cs (L.present t))))))) _
    _ = p * ((q + 1) * W.stock cs (t + 1) + L.uptake cs t) :=
        (congrArg (· + p * L.uptake cs t) (mul_assoc_nat p (q + 1) _)).trans
          (Nat.left_distrib _ _ _).symm
    _ ≤ p * ((q + 1) * (r t * W.stock cs t)) :=
        Nat.mul_le_mul_left p (balances.lowersTaking dissipates)
    _ = p * (q + 1) * (r t * W.stock cs t) := (mul_assoc_nat p (q + 1) _).symm

/-- The exchange law. Balanced at a resolution that only refines and dissipative in
proportion `q`, over a family without repetition closed at every step from `T` on, the times
since `T` that a formation takes at least `1/p` of the unit of step `T` from the family,
counted formation by formation, number at most `p (q + 1)` times its stock at `T`. Each
such taking takes at least `1/p` of the unit, so the count follows from the amount law. -/
theorem exchange_bound {r : Nat → Nat} (balances : L.BalancesAt r W) {q : Nat}
    (dissipative : L.DissipativeBy q) {cs : List C} (distinct : Distinct cs) {T : Nat}
    (closed : ∀ t, T ≤ t → L.ClosedAt cs t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p n : Nat) : total (steps T n) (L.takersAbove R p cs) ≤ p * (q + 1) * W.stock cs T :=
  Nat.le_trans (counts_of_amounts base unit refining
      (fun t _ => L.takersAbove_le R p cs t)
      (uptake_bound balances dissipative distinct closed base unit) n)
    (Nat.le_of_eq (mul_assoc_nat p (q + 1) _).symm)

/-- So no formation takes at least `1/p` of the unit from the family at arbitrarily late
steps. -/
theorem exchange_not_recurring {r : Nat → Nat} (balances : L.BalancesAt r W) {q : Nat}
    (dissipative : L.DissipativeBy q) {cs : List C} (distinct : Distinct cs) {T : Nat}
    (closed : ∀ t, T ≤ t → L.ClosedAt cs t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p : Nat) :
    ¬ ∀ N, ∃ t f, N ≤ t ∧ f ∈ L.present t ∧ R (t + 1) ≤ p * total cs (L.take t f) :=
  fun recurs => bounded_not_recurring
    (exchange_bound balances dissipative distinct closed base unit refining p)
    fun N => match recurs N with
    | ⟨t, _, after, present, takes⟩ =>
      ⟨t, after, total_pos_of_mem (q := fun f => mark (R (t + 1) ≤ p * total cs (L.take t f)))
        present (mark_pos.mpr takes)⟩

/-- A least loss at a least size: across the step from `t`, each formation taking part that
takes at least `1/p` of the unit counted by `R` from the family gives it back at least `1/m`
of the unit less than it takes. -/
def LosesAtSize (R : Nat → Nat) (p m : Nat) (cs : List C) (t : Nat) : Prop :=
  ∀ f, f ∈ L.present t → R (t + 1) ≤ p * total cs (L.take t f) →
    R (t + 1) + m * total cs (L.give t f) ≤ m * total cs (L.take t f)

/-- A least loss at every least size: for each `p` one `m` serves at every step, on every
family without repetition closed across it. -/
def LosesAtEverySize (R : Nat → Nat) : Prop :=
  ∀ p, ∃ m, ∀ cs t, Distinct cs → L.ClosedAt cs t → L.LosesAtSize R p m cs t

/-- Each formation taking part gives the family no more than it takes from it. -/
theorem DissipatesOn.give_le {cs : List C} {t : Nat} (dissipates : L.DissipatesOn cs t)
    {f : F} (present : f ∈ L.present t) :
    total cs (L.give t f) ≤ total cs (L.take t f) :=
  Nat.le_trans (Nat.le_add_right _ _) (dissipates f present)

/-- Summed over the formations taking part: `m` times the family's replenishment, with the
unit of step `t + 1` for each formation taking at least `1/p` of the unit, is within `m`
times its uptake. -/
theorem LosesAtSize.over {R : Nat → Nat} {p m : Nat} {cs : List C} {t : Nat}
    (dissipates : L.DissipatesOn cs t) (loses : L.LosesAtSize R p m cs t) :
    m * L.replenishment cs t + L.takersAbove R p cs t * R (t + 1) ≤ m * L.uptake cs t :=
  calc m * L.replenishment cs t + L.takersAbove R p cs t * R (t + 1)
      = total (L.present t) (fun f => m * total cs (L.give t f)) +
          total (L.present t) (fun f => mark (R (t + 1) ≤ p * total cs (L.take t f)) *
            R (t + 1)) :=
        (congrArg (· + L.takersAbove R p cs t * R (t + 1))
          ((congrArg (m * ·) (total_swap (fun f c => L.give t f c) cs (L.present t)).symm).trans
            (total_mul m (fun f => total cs (L.give t f)) (L.present t)).symm)).trans
          (congrArg (total (L.present t) (fun f => m * total cs (L.give t f)) + ·)
            (total_mul_right _ _ _))
    _ = total (L.present t) (fun f => m * total cs (L.give t f) +
          mark (R (t + 1) ≤ p * total cs (L.take t f)) * R (t + 1)) :=
        (total_add _ _ _).symm
    _ ≤ total (L.present t) (fun f => m * total cs (L.take t f)) :=
        total_le (L.present t) fun f present => mark_cases
          (q := fun k => m * total cs (L.give t f) + k * R (t + 1) ≤ m * total cs (L.take t f))
          (fun takes => Nat.le_trans (Nat.le_of_eq ((congrArg (m * total cs (L.give t f) + ·)
              (Nat.one_mul _)).trans (Nat.add_comm _ _))) (loses f present takes))
          (fun _ => Nat.le_trans (Nat.le_of_eq ((congrArg (m * total cs (L.give t f) + ·)
              (Nat.zero_mul _)).trans (Nat.add_zero _)))
            (Nat.mul_le_mul_left m (dissipates.give_le present)))
    _ = m * L.uptake cs t :=
        (total_mul m (fun f => total cs (L.take t f)) (L.present t)).trans
          (congrArg (m * ·) (total_swap (fun f c => L.take t f c) cs (L.present t)))

/-- With a least loss at a least size, each formation taking at least `1/p` of the unit
from the family makes it lose at least `1/m` of the unit. -/
theorem BalancesAt.takers_lose_least {r : Nat → Nat} (balances : L.BalancesAt r W)
    {R : Nat → Nat} {p m : Nat} {cs : List C} {t : Nat} (dissipates : L.DissipatesOn cs t)
    (loses : L.LosesAtSize R p m cs t) :
    m * W.stock cs (t + 1) + L.takersAbove R p cs t * R (t + 1) ≤ m * (r t * W.stock cs t) :=
  le_of_add_le_add_right (m * L.replenishment cs t) (calc
    m * W.stock cs (t + 1) + L.takersAbove R p cs t * R (t + 1) + m * L.replenishment cs t
        = m * W.stock cs (t + 1) +
            (m * L.replenishment cs t + L.takersAbove R p cs t * R (t + 1)) :=
          (Nat.add_assoc _ _ _).trans (congrArg (m * W.stock cs (t + 1) + ·) (Nat.add_comm _ _))
    _ ≤ m * W.stock cs (t + 1) + m * L.uptake cs t :=
          Nat.add_le_add_left (loses.over dissipates) _
    _ = m * (r t * W.stock cs t) + m * L.replenishment cs t :=
          (Nat.left_distrib _ _ _).symm.trans ((congrArg (m * ·) (balances.over cs t)).trans
            (Nat.left_distrib _ _ _)))

/-- The exchange law at a least loss for each size. Balanced at a resolution that only
refines and dissipative, where each formation taking at least `1/p` of the unit loses at
least `1/m` of it, over a family without repetition closed at every step from `T` on, the
times since `T` that a formation takes at least `1/p` of the unit of step `T` from the
family, counted formation by formation, number at most `m` times its stock at `T`. -/
theorem exchange_bound_of_least_loss {r : Nat → Nat} (balances : L.BalancesAt r W)
    (dissipative : L.Dissipative) {R : Nat → Nat} {p m : Nat}
    (loses : ∀ cs t, Distinct cs → L.ClosedAt cs t → L.LosesAtSize R p m cs t)
    {cs : List C} (distinct : Distinct cs) {T : Nat} (closed : ∀ t, T ≤ t → L.ClosedAt cs t)
    (base : R T = 1) (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t)
    (refining : ∀ t, T ≤ t → 0 < r t) (n : Nat) :
    total (steps T n) (L.takersAbove R p cs) ≤ m * W.stock cs T :=
  losses_bound base unit refining
    (fun t later => balances.takers_lose_least (dissipative cs t distinct (closed t later))
      (loses cs t distinct (closed t later))) n

/-- So no formation takes at least `1/p` of the unit from the family at arbitrarily late
steps. -/
theorem exchange_not_recurring_of_least_loss {r : Nat → Nat} (balances : L.BalancesAt r W)
    (dissipative : L.Dissipative) {R : Nat → Nat} {p m : Nat}
    (loses : ∀ cs t, Distinct cs → L.ClosedAt cs t → L.LosesAtSize R p m cs t)
    {cs : List C} (distinct : Distinct cs) {T : Nat} (closed : ∀ t, T ≤ t → L.ClosedAt cs t)
    (base : R T = 1) (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t)
    (refining : ∀ t, T ≤ t → 0 < r t) :
    ¬ ∀ N, ∃ t f, N ≤ t ∧ f ∈ L.present t ∧ R (t + 1) ≤ p * total cs (L.take t f) :=
  fun recurs => bounded_not_recurring
    (exchange_bound_of_least_loss balances dissipative loses distinct closed base unit refining)
    fun N => match recurs N with
    | ⟨t, _, after, present, takes⟩ =>
      ⟨t, after, total_pos_of_mem (q := fun f => mark (R (t + 1) ≤ p * total cs (L.take t f)))
        present (mark_pos.mpr takes)⟩

/-- Loss in proportion at each transfer is a least loss at every least size: where each
formation gives back at most `q` parts in `q + 1` of what it takes, one taking at least `1/p`
of the unit loses at least `1/(p (q + 1))` of it. -/
theorem losesAtSize_of_each {q : Nat} {cs : List C} {t : Nat}
    (each : ∀ f, f ∈ L.present t → (q + 1) * total cs (L.give t f) ≤ q * total cs (L.take t f))
    (R : Nat → Nat) (p : Nat) : L.LosesAtSize R p (p * (q + 1)) cs t :=
  fun f present takes => calc
    R (t + 1) + p * (q + 1) * total cs (L.give t f)
        = R (t + 1) + p * ((q + 1) * total cs (L.give t f)) :=
          congrArg (R (t + 1) + ·) (mul_assoc_nat p (q + 1) _)
    _ ≤ p * total cs (L.take t f) + p * (q * total cs (L.take t f)) :=
          Nat.add_le_add takes (Nat.mul_le_mul_left p (each f present))
    _ = p * (q + 1) * total cs (L.take t f) :=
          (Nat.left_distrib _ _ _).symm.trans ((congrArg (p * ·) ((Nat.add_comm _ _).trans
            ((congrArg (q * total cs (L.take t f) + ·) (Nat.one_mul _).symm).trans
              (add_mul_split q 1 _).symm))).trans (mul_assoc_nat p (q + 1) _).symm)

/-- Balanced at a resolution, what a condition loses across a step is taken from it. -/
theorem BalancesAt.loss_taken {r : Nat → Nat} (balances : L.BalancesAt r W) {R : Nat → Nat}
    {p t : Nat} {c : C} (loses : W.Loses r R p t c) : R (t + 1) ≤ p * L.taken t c :=
  le_of_add_le_add_right (p * W.level (t + 1) c) (Nat.le_trans loses
    (Nat.le_trans (Nat.mul_le_mul_left p (Nat.le_trans (Nat.le_add_right _ (L.given t c))
        (Nat.le_of_eq (balances t c).symm)))
      (Nat.le_of_eq ((Nat.left_distrib _ _ _).trans (Nat.add_comm _ _)))))

/-- Dissipated on in proportion `q`, the members of a list without repetition within the
family that lose at least `1/p` of the unit across a step make the family lose at least
`1/(p (q + 1))` of it each. -/
theorem BalancesAt.losers_lose {r : Nat → Nat} (balances : L.BalancesAt r W) {R : Nat → Nat}
    {p q : Nat} {cs ls : List C} {t : Nat} (dissipates : L.DissipatesBy q cs t)
    (distinct : Distinct ls) (within : ∀ c, c ∈ ls → c ∈ cs) :
    p * (q + 1) * W.stock cs (t + 1) + W.losers r R p t ls * R (t + 1) ≤
      p * (q + 1) * (r t * W.stock cs t) :=
  calc p * (q + 1) * W.stock cs (t + 1) + W.losers r R p t ls * R (t + 1)
      ≤ p * (q + 1) * W.stock cs (t + 1) + p * L.uptake cs t :=
        Nat.add_le_add_left (Nat.le_trans (Nat.le_of_eq (total_mul_right _ _ ls))
          (Nat.le_trans (total_le ls fun c _ => mark_cases
              (q := fun m => m * R (t + 1) ≤ p * L.taken t c)
              (fun loses => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _))
                (balances.loss_taken loses))
              (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_mul _)) (Nat.zero_le _)))
            (Nat.le_trans (Nat.le_of_eq (total_mul p (L.taken t) ls))
              (Nat.mul_le_mul_left p (total_le_of_support distinct fun c mem _ =>
                within c mem))))) _
    _ = p * ((q + 1) * W.stock cs (t + 1) + L.uptake cs t) :=
        (congrArg (· + p * L.uptake cs t) (mul_assoc_nat p (q + 1) _)).trans
          (Nat.left_distrib _ _ _).symm
    _ ≤ p * ((q + 1) * (r t * W.stock cs t)) :=
        Nat.mul_le_mul_left p (balances.lowersTaking dissipates)
    _ = p * (q + 1) * (r t * W.stock cs t) := (mul_assoc_nat p (q + 1) _).symm

/-- Each relatum losing at least `1/p` of the unit has at least that taken from it. -/
theorem BalancesAt.losers_le {r : Nat → Nat} (balances : L.BalancesAt r W) (R : Nat → Nat)
    (p t : Nat) (ls : List C) : W.losers r R p t ls * R (t + 1) ≤ p * L.uptake ls t :=
  Nat.le_trans (Nat.le_of_eq (total_mul_right _ _ ls))
    (Nat.le_trans (total_le ls fun c _ => mark_cases
        (q := fun m => m * R (t + 1) ≤ p * L.taken t c)
        (fun loses => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _)) (balances.loss_taken loses))
        (fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_mul _)) (Nat.zero_le _)))
      (Nat.le_of_eq (total_mul p (L.taken t) ls)))

end Flow

namespace World

variable {w : World}

/-- The amount law of a world. In a world with a census whose relata are embodied, balanced
at a resolution and dissipative in proportion `q`, with every step from `T` on enclosed,
everything taken since `T` from what stands, in the unit of step `T`, is at most `q + 1`
times the total standing at `T`. -/
theorem taken_bound {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) {r : Nat → Nat} (balances : w.flow.BalancesAt r w.web) {q : Nat}
    (dissipative : w.flow.DissipativeBy q) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (n : Nat) :
    refinedSum r (fun t => w.flow.uptake (alive t) t) T n ≤
      (q + 1) * w.web.stock (alive T) T * R (T + n) :=
  have standing := standingCensus census embodied
  Nat.le_trans (Nat.le_add_left _ _) (refinedSum_invariant (s := fun t => w.web.stock (alive t) t)
    base unit (fun t later => Decidable.of_not_not fun no =>
      (enclosed t later).aroundStanding_not_not alive fun ⟨es, distinct, before, after, closed⟩ =>
        no <| calc
          (q + 1) * w.web.stock (alive (t + 1)) (t + 1) + w.flow.uptake (alive t) t
            ≤ (q + 1) * w.web.stock es (t + 1) + w.flow.uptake es t :=
              Nat.add_le_add (Nat.le_of_eq (congrArg ((q + 1) * ·)
                  (standing.stock_eq distinct after)))
                (total_le_of_support (census t).1 fun c mem _ => before c mem)
          _ ≤ (q + 1) * (r t * w.web.stock es t) :=
              balances.lowersTaking (dissipative es t distinct closed)
          _ = (q + 1) * (r t * w.web.stock (alive t) t) :=
              congrArg (fun k => (q + 1) * (r t * k)) (standing.stock_eq distinct before).symm)
    n)

/-- Under the same premises, everything given since `T` to what stands after each step, in
the unit of step `T`, is at most `q` times the total standing at `T`. -/
theorem given_bound {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) {r : Nat → Nat} (balances : w.flow.BalancesAt r w.web) {q : Nat}
    (dissipative : w.flow.DissipativeBy q) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (n : Nat) :
    refinedSum r (fun t => w.flow.replenishment (alive (t + 1)) t) T n ≤
      q * w.web.stock (alive T) T * R (T + n) :=
  have standing := standingCensus census embodied
  Nat.le_trans (Nat.le_add_left _ _) (refinedSum_invariant (s := fun t => w.web.stock (alive t) t)
    base unit (fun t later => Decidable.of_not_not fun no =>
      (enclosed t later).aroundStanding_not_not alive fun ⟨es, distinct, before, after, closed⟩ =>
        no <| calc
          q * w.web.stock (alive (t + 1)) (t + 1) + w.flow.replenishment (alive (t + 1)) t
            ≤ q * w.web.stock es (t + 1) + w.flow.replenishment es t :=
              Nat.add_le_add (Nat.le_of_eq (congrArg (q * ·)
                  (standing.stock_eq distinct after)))
                (total_le_of_support (census (t + 1)).1 fun c mem _ => after c mem)
          _ ≤ q * (r t * w.web.stock es t) :=
              balances.lowersBy (dissipative es t distinct closed)
          _ = q * (r t * w.web.stock (alive t) t) :=
              congrArg (fun k => q * (r t * k)) (standing.stock_eq distinct before).symm)
    n)

/-- The growth law. In a world with a census whose relata are embodied, balanced at a
resolution that only refines and dissipative in proportion `q`, with every step from `T`
on enclosed, the times since `T` that a relatum gains at least `1/p` of the unit of step
`T`, counted relatum by relatum, number at most `p q` times the total standing at `T`.
Each such gain is given at least `1/p` of the unit, so the count follows from the amount
law of what is given. -/
theorem growth_bound {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) {r : Nat → Nat} (balances : w.flow.BalancesAt r w.web) {q : Nat}
    (dissipative : w.flow.DissipativeBy q) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p n : Nat) :
    total (steps T n) (fun t => w.web.gainers r R p t (alive (t + 1))) ≤
      p * q * w.web.stock (alive T) T :=
  Nat.le_trans (counts_of_amounts base unit refining
      (fun t _ => balances.gainers_le R p t (alive (t + 1)))
      (given_bound census embodied balances dissipative enclosed base unit) n)
    (Nat.le_of_eq (mul_assoc_nat p q _).symm)

/-- So no relatum gains at least `1/p` of the unit at arbitrarily late steps. -/
theorem growth_not_recurring (counted : w.Counted) (embodied : w.Embodied) {r : Nat → Nat}
    (balances : w.flow.BalancesAt r w.web) {q : Nat} (dissipative : w.flow.DissipativeBy q)
    {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p : Nat) : ¬ ∀ N, ∃ t x, N ≤ t ∧ w.web.Gains r R p t x :=
  match counted with
  | ⟨_, census⟩ => fun recurs => bounded_not_recurring
    (growth_bound census embodied balances dissipative enclosed base unit refining p)
    fun N => match recurs (N + T) with
    | ⟨t, x, after, gains⟩ =>
      have later := Nat.le_trans (Nat.le_add_left T N) after
      have stands : 0 < w.web.level (t + 1) x := Nat.pos_of_ne_zero fun zero =>
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          (units_pos base unit refining (Nat.le_succ_of_le later))
          (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans gains
            (Nat.le_of_eq ((congrArg (p * ·) zero).trans (Nat.mul_zero p))))))
      ⟨t, Nat.le_trans (Nat.le_add_right N T) after,
        total_pos_of_mem (q := fun c => mark (w.web.Gains r R p t c))
          (((standingCensus census embodied (t + 1)).2 x).mp stands) (mark_pos.mpr gains)⟩

/-- So arising at a size not vanishing does not recur: under the same premises, no relatum
arises standing at least `1/p` of the unit of step `T` at arbitrarily late steps. -/
theorem arising_not_recurring (counted : w.Counted) (embodied : w.Embodied) {r : Nat → Nat}
    (balances : w.flow.BalancesAt r w.web) {q : Nat} (dissipative : w.flow.DissipativeBy q)
    {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p : Nat) :
    ¬ ∀ N, ∃ t x, N ≤ t ∧ w.web.Arises t x ∧ R (t + 1) ≤ p * w.web.level (t + 1) x :=
  fun recurs => growth_not_recurring counted embodied balances dissipative enclosed base unit
    refining p fun N => match recurs N with
    | ⟨t, x, after, arises, size⟩ => ⟨t, x, after, Nat.le_trans (Nat.le_of_eq
        ((congrArg (fun k => R (t + 1) + p * (r t * k))
          (eq_zero_of_not_pos fun pos => arises.1 ((embodied x t).mpr pos))).trans
          ((congrArg (fun k => R (t + 1) + p * k) (Nat.mul_zero (r t))).trans
            ((congrArg (R (t + 1) + ·) (Nat.mul_zero p)).trans (Nat.add_zero _))))) size⟩

/-- The fall law. Under the premises of the growth law, the times since `T` that a relatum
loses at least `1/p` of the unit of step `T`, counted relatum by relatum, number at most
`p (q + 1)` times the total standing at `T`. What falls at least `1/p` of the unit has at
least that taken from it, so the count follows from the amount law of what is taken. -/
theorem fall_bound {alive : Nat → List w.Relatum} (census : w.web.Census alive)
    (embodied : w.Embodied) {r : Nat → Nat} (balances : w.flow.BalancesAt r w.web) {q : Nat}
    (dissipative : w.flow.DissipativeBy q) {T : Nat}
    (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p n : Nat) :
    total (steps T n) (fun t => w.web.losers r R p t (alive t)) ≤
      p * (q + 1) * w.web.stock (alive T) T :=
  Nat.le_trans (counts_of_amounts base unit refining
      (fun t _ => balances.losers_le R p t (alive t))
      (taken_bound census embodied balances dissipative enclosed base unit) n)
    (Nat.le_of_eq (mul_assoc_nat p (q + 1) _).symm)

/-- So no relatum loses at least `1/p` of the unit at arbitrarily late steps. -/
theorem fall_not_recurring (counted : w.Counted) (embodied : w.Embodied) {r : Nat → Nat}
    (balances : w.flow.BalancesAt r w.web) {q : Nat} (dissipative : w.flow.DissipativeBy q)
    {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p : Nat) : ¬ ∀ N, ∃ t x, N ≤ t ∧ w.web.Loses r R p t x :=
  match counted with
  | ⟨_, census⟩ => fun recurs => bounded_not_recurring
    (fall_bound census embodied balances dissipative enclosed base unit refining p)
    fun N => match recurs (N + T) with
    | ⟨t, x, after, loses⟩ =>
      have later := Nat.le_trans (Nat.le_add_left T N) after
      have stood : 0 < w.web.level t x := Nat.pos_of_ne_zero fun zero =>
        Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
          (units_pos base unit refining (Nat.le_succ_of_le later))
          (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans loses
            (Nat.le_of_eq ((congrArg (fun k => p * (r t * k)) zero).trans
              ((congrArg (p * ·) (Nat.mul_zero (r t))).trans (Nat.mul_zero p)))))))
      ⟨t, Nat.le_trans (Nat.le_add_right N T) after,
        total_pos_of_mem (q := fun c => mark (w.web.Loses r R p t c))
          (((standingCensus census embodied t).2 x).mp stood) (mark_pos.mpr loses)⟩

/-- So ceasing at a size not vanishing does not recur: no relatum standing at least `1/p` of
the unit ceases at arbitrarily late steps. -/
theorem ceasing_not_recurring (counted : w.Counted) (embodied : w.Embodied) {r : Nat → Nat}
    (balances : w.flow.BalancesAt r w.web) {q : Nat} (dissipative : w.flow.DissipativeBy q)
    {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p : Nat) :
    ¬ ∀ N, ∃ t x, N ≤ t ∧ w.web.Ceases t x ∧ R (t + 1) ≤ p * (r t * w.web.level t x) :=
  fun recurs => fall_not_recurring counted embodied balances dissipative enclosed base unit
    refining p fun N => match recurs N with
    | ⟨t, x, after, ceases, size⟩ => ⟨t, x, after, Nat.le_trans (Nat.le_of_eq
        ((congrArg (fun k => R (t + 1) + p * k)
          (eq_zero_of_not_pos fun pos => ceases.2 ((embodied x (t + 1)).mpr pos))).trans
          ((congrArg (R (t + 1) + ·) (Nat.mul_zero p)).trans (Nat.add_zero _)))) size⟩

/-- Rest at each size, at every resolution. In a world with a census whose relata are
embodied, balanced at a resolution that only refines and dissipative in proportion, with
every step from some step on enclosed, neither arising nor ceasing at a size of at least
`1/p` of the unit recurs. -/
theorem not_recurring_at_resolution (counted : w.Counted) (embodied : w.Embodied) {r : Nat → Nat}
    (balances : w.flow.BalancesAt r w.web) {q : Nat} (dissipative : w.flow.DissipativeBy q)
    {T : Nat} (enclosed : ∀ t, T ≤ t → w.flow.Enclosed t) {R : Nat → Nat} (base : R T = 1)
    (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t) (refining : ∀ t, T ≤ t → 0 < r t)
    (p : Nat) :
    (¬ ∀ N, ∃ t x, N ≤ t ∧ w.web.Arises t x ∧ R (t + 1) ≤ p * w.web.level (t + 1) x) ∧
      ¬ ∀ N, ∃ t x, N ≤ t ∧ w.web.Ceases t x ∧ R (t + 1) ≤ p * (r t * w.web.level t x) :=
  ⟨arising_not_recurring counted embodied balances dissipative enclosed base unit refining p,
   ceasing_not_recurring counted embodied balances dissipative enclosed base unit refining p⟩

end World

/-! ## A reserve at every resolution -/

/-- A reserve at a resolution: across each step at which the formation is not supported,
the reserve does not rise, counted in the finer unit, and where the formation is active it
falls by at least `1/p` of the unit counted by `R`. -/
def Web.CarriesAt (W : Web F C) (r R : Nat → Nat) (p : Nat) (a : Nat → F → Nat) : Prop :=
  ∀ t f, ¬ W.Supported t f →
    a (t + 1) f ≤ r t * a t f ∧ (W.active t f → R (t + 1) + p * a (t + 1) f ≤ p * (r t * a t f))

/-- A reserve read in a refining unit: across each unsupported step it does not rise, and
falls where the formation is active, counted in the finer unit; with `r` constantly one it is
`Web.Carries` (`Web.carriesIn_one`). -/
def Web.CarriesIn (W : Web F C) (r : Nat → Nat) (a : Nat → F → Nat) : Prop :=
  ∀ t f, ¬ W.Supported t f → a (t + 1) f ≤ r t * a t f ∧ (W.active t f → a (t + 1) f < r t * a t f)

/-- The spine's reserve, falling by a whole unit at each active unsupported step, carries at
the fixed unit with `p` one. -/
theorem Web.Carries.carriesAt {W : Web F C} {a : Nat → F → Nat} (carries : W.Carries a) :
    W.CarriesAt (fun _ => 1) (fun _ => 1) 1 a :=
  fun t f unsupported =>
    ⟨Nat.le_trans (carries t f unsupported).1 (Nat.le_of_eq (Nat.one_mul _).symm),
     fun active => Nat.le_trans (Nat.le_of_eq ((congrArg (1 + ·) (Nat.one_mul _)).trans
        (Nat.add_comm _ _))) (Nat.le_trans ((carries t f unsupported).2 active)
          (Nat.le_of_eq ((Nat.one_mul _).trans (Nat.one_mul _)).symm))⟩

/-- With the unit fixed, a reserve read in the finer unit is the spine's reserve. -/
theorem Web.carriesIn_one {W : Web F C} {a : Nat → F → Nat} :
    W.CarriesIn (fun _ => 1) a ↔ W.Carries a :=
  ⟨fun carries t f unsupported =>
    ⟨Nat.le_trans (carries t f unsupported).1 (Nat.le_of_eq (Nat.one_mul _)),
     fun active => Nat.lt_of_lt_of_le ((carries t f unsupported).2 active)
      (Nat.le_of_eq (Nat.one_mul _))⟩,
   fun carries t f unsupported =>
    ⟨Nat.le_trans (carries t f unsupported).1 (Nat.le_of_eq (Nat.one_mul _).symm),
     fun active => Nat.lt_of_lt_of_le ((carries t f unsupported).2 active)
      (Nat.le_of_eq (Nat.one_mul _).symm)⟩⟩

/-- A reserve defers the end at every resolution where each active step beyond support lowers
it by at least `1/p` of the unit of step `T`: unsupported from `T` on, the formation is active
since `T` at most `p` times its reserve at `T`. -/
theorem Web.CarriesAt.lasts {W : Web F C} {r R : Nat → Nat} {p : Nat} {a : Nat → F → Nat}
    (carries : W.CarriesAt r R p a) {f : F} [∀ t, Decidable (W.active t f)] {T : Nat}
    (base : R T = 1) (unit : ∀ t, T ≤ t → R (t + 1) = r t * R t)
    (refining : ∀ t, T ≤ t → 0 < r t) (unsupported : ∀ t, T ≤ t → ¬ W.Supported t f)
    (n : Nat) : total (steps T n) (fun t => mark (W.active t f)) ≤ p * a T f :=
  losses_bound (s := fun t => a t f) base unit refining (fun t later =>
    mark_cases (q := fun m => p * a (t + 1) f + m * R (t + 1) ≤ p * (r t * a t f))
      (fun active => Nat.le_trans (Nat.le_of_eq ((congrArg (p * a (t + 1) f + ·)
        (Nat.one_mul _)).trans (Nat.add_comm _ _)))
        ((carries t f (unsupported t later)).2 active))
      (fun _ => Nat.le_trans (Nat.le_of_eq ((congrArg (p * a (t + 1) f + ·)
        (Nat.zero_mul _)).trans (Nat.add_zero _)))
        (Nat.mul_le_mul_left p (carries t f (unsupported t later)).1))) n

/-- A reserve read in a refining unit is the spine's reserve wherever the refinement gives it
nothing. Counted as a formation, the refinement gives the reserve the `split t` times itself
that the splitting adds. Unsupported from `T` on, where from `T` on the refinement gives the
reserve nothing, the formation is active since `T` at most its reserve at `T` times. -/
theorem Web.CarriesIn.lasts_unrefined {W : Web F C} {split : Nat → Nat} {a : Nat → F → Nat}
    (carries : W.CarriesIn (fun t => split t + 1) a) {f : F} [∀ t, Decidable (W.active t f)]
    {T : Nat} (unsupported : ∀ t, T ≤ t → ¬ W.Supported t f)
    (unrefined : ∀ t, T ≤ t → split t * a t f = 0) (n : Nat) :
    total (steps T n) (fun t => mark (W.active t f)) ≤ 1 * a T f :=
  have same : ∀ t, T ≤ t → (split t + 1) * a t f = 1 * (1 * a t f) := fun t later =>
    (add_mul_split (split t) 1 _).trans ((congrArg (· + 1 * a t f) (unrefined t later)).trans
      ((Nat.zero_add _).trans (Nat.one_mul _).symm))
  losses_bound (r := fun _ => 1) (R := fun _ => 1) (s := fun t => a t f) (q := 1) rfl
    (fun _ _ => rfl) (fun _ _ => Nat.one_pos) (fun t later =>
    mark_cases (q := fun m => 1 * a (t + 1) f + m * 1 ≤ 1 * (1 * a t f))
      (fun active => Nat.le_trans (Nat.le_of_eq (congrArg (· + 1 * 1) (Nat.one_mul _)))
        (Nat.le_trans ((carries t f (unsupported t later)).2 active)
          (Nat.le_of_eq (same t later))))
      (fun _ => Nat.le_trans (Nat.le_of_eq ((congrArg (1 * a (t + 1) f + ·)
        (Nat.zero_mul _)).trans ((Nat.add_zero _).trans (Nat.one_mul _))))
        (Nat.le_trans (carries t f (unsupported t later)).1 (Nat.le_of_eq (same t later))))) n

/-- Units of step `t` per unit of step 0 where the unit halves at each step. -/
def halving : Nat → Nat
  | 0 => 1
  | t + 1 => 2 * halving t

/-- The unit quartering at each step: one unit of step 0 is `quarter t` units of step `t`. -/
def quarter : Nat → Nat
  | 0 => 1
  | t + 1 => 4 * quarter t

theorem quarter_eq : ∀ t, quarter t = halving t * halving t
  | 0 => rfl
  | t + 1 => (congrArg (4 * ·) (quarter_eq t)).trans ((mul_assoc_nat 2 2 _).trans
      ((congrArg (2 * ·) (mul_turn (halving t) 2 (halving t)).symm).trans
        (mul_assoc_nat 2 (halving t) (2 * halving t)).symm))

theorem halving_pos : ∀ t, 0 < halving t
  | 0 => Nat.one_pos
  | t + 1 => (Nat.mul_le_mul (Nat.succ_pos 1) (halving_pos t) : 1 * 1 ≤ 2 * halving t)

theorem quarter_pos : ∀ t, 0 < quarter t
  | 0 => Nat.one_pos
  | t + 1 => (Nat.mul_le_mul (Nat.succ_pos 3) (quarter_pos t) : 1 * 1 ≤ 4 * quarter t)

/-! ## Powers -/

/-- `powers b t` is `b` multiplied `t` times. -/
def powers (b : Nat) : Nat → Nat
  | 0 => 1
  | t + 1 => b * powers b t

theorem powers_pos {b : Nat} (pos : 0 < b) : ∀ t, 0 < powers b t
  | 0 => Nat.one_pos
  | t + 1 => (Nat.mul_le_mul pos (powers_pos pos t) : 1 * 1 ≤ b * powers b t)

/-- Bernoulli's inequality for powers: `(q + n) q^n ≤ q (q + 1)^n`. -/
theorem bernoulli_powers (q : Nat) : ∀ n, (q + n) * powers q n ≤ q * powers (q + 1) n
  | 0 => Nat.le_refl _
  | n + 1 =>
    calc (q + (n + 1)) * powers q (n + 1)
        = (q + n) * (q * powers q n) + q * powers q n :=
          (add_mul_split (q + n) 1 _).trans (congrArg (_ + ·) (Nat.one_mul _))
      _ ≤ (q + n) * (q * powers q n) + (q + n) * powers q n :=
          Nat.add_le_add_left (Nat.mul_le_mul_right _ (Nat.le_add_right q n)) _
      _ = (q + 1) * ((q + n) * powers q n) :=
          (congrArg (· + (q + n) * powers q n) (mul_turn _ _ _)).trans
            ((congrArg (q * ((q + n) * powers q n) + ·) (Nat.one_mul _).symm).trans
              (add_mul_split q 1 _).symm)
      _ ≤ (q + 1) * (q * powers (q + 1) n) := Nat.mul_le_mul_left _ (bernoulli_powers q n)
      _ = q * powers (q + 1) (n + 1) := mul_turn _ _ _

/-- So `(q + 1)^n` outgrows every multiple of `q^n`. -/
theorem powers_outgrow : ∀ (q m : Nat), ∃ n, m * powers q n < powers (q + 1) n
  | 0, _ => ⟨1, Nat.one_pos⟩
  | k + 1, m => ⟨(k + 1) * m, Nat.le_of_mul_le_mul_left (
      calc (k + 1) * (m * powers (k + 1) ((k + 1) * m) + 1)
          = (k + 1) * (m * powers (k + 1) ((k + 1) * m)) + (k + 1) * 1 := Nat.left_distrib _ _ _
        _ ≤ (k + 1) * (m * powers (k + 1) ((k + 1) * m)) + (k + 1) * powers (k + 1) ((k + 1) * m) :=
          Nat.add_le_add_left (Nat.mul_le_mul_left _ (powers_pos (Nat.succ_pos k) _)) _
        _ = ((k + 1) * m + (k + 1)) * powers (k + 1) ((k + 1) * m) :=
          (congrArg (· + _) (mul_assoc_nat _ _ _).symm).trans (add_mul_split _ _ _).symm
        _ = (k + 1 + (k + 1) * m) * powers (k + 1) ((k + 1) * m) :=
          congrArg (· * _) (Nat.add_comm _ _)
        _ ≤ (k + 1) * powers (k + 1 + 1) ((k + 1) * m) := bernoulli_powers (k + 1) _)
      (Nat.succ_pos k)⟩

/-! ## A unit refining without end -/

namespace Asymptote

variable (split : Nat → Nat)

/-- Across the step from `t` each unit splits into `split t + 1` finer units. -/
def refinement (t : Nat) : Nat :=
  split t + 1

/-- How many units of step `t` make one unit of step 0. -/
def units : Nat → Nat
  | 0 => 1
  | t + 1 => refinement split t * units t

/-- One drawer takes `split t` units of step `t + 1` from one pool and gives nothing back. -/
def flow : Flow Unit Unit :=
  ⟨fun _ => [()], fun t _ _ => split t, fun _ _ _ => 0⟩

/-- The pool stands one unit of step `t` above the drawer's need of one unit of step 0. -/
def web : Web Unit Unit :=
  ⟨fun t _ => units split t + 1, fun _ _ => True, fun _ _ _ => True,
    fun t _ _ => units split t, fun _ _ _ => True⟩

/-- The flow balances at the refining resolution. -/
theorem balances : (flow split).BalancesAt (refinement split) (web split) :=
  fun t c => match c with
  | () => show units split (t + 1) + 1 + (split t + 0) =
        refinement split t * (units split t + 1) + (0 + 0) from
      ((Nat.add_assoc _ _ _).trans (congrArg (refinement split t * units split t + ·)
        (Nat.add_comm 1 (split t)))).trans
      ((congrArg (refinement split t * units split t + ·)
        (Nat.mul_one (refinement split t)).symm).trans (Nat.left_distrib _ _ _).symm)

/-- The pool is closed at every step. -/
theorem closed (t : Nat) : (flow split).ClosedAt [()] t :=
  fun _ _ c outside => absurd (match c with | () => List.Mem.head []) outside

theorem distinct : Distinct [()] :=
  ⟨(fun mem => nomatch mem), trivial⟩

/-- Giving nothing back, the drawer dissipates on every family. -/
theorem dissipative : (flow split).Dissipative :=
  fun cs _ _ _ _ _ => Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (total_zero cs)).trans
    (Nat.zero_add _))) (sign_le _)

/-- Giving nothing back, the drawer loses all it takes: the flow is dissipative in every
proportion. -/
theorem dissipativeBy (q : Nat) : (flow split).DissipativeBy q :=
  fun cs _ _ _ => Flow.DissipatesBy.of_each fun _ _ =>
    Nat.le_trans (Nat.le_of_eq ((congrArg ((q + 1) * ·) (total_zero cs)).trans
      (Nat.mul_zero _))) (Nat.zero_le _)

/-- The drawer is supported at every step. -/
theorem dependent : (web split).Dependent :=
  fun _ _ _ _ _ => Nat.le_add_right _ 1

/-- The pool stays above the drawer's need. -/
theorem above_need (t : Nat) : (web split).need t () () < (web split).level t () :=
  Nat.lt_succ_self _

/-- Only the drawer takes, and only from what it draws on; it gives nothing. -/
theorem taking : (flow split).Taking (web split) :=
  fun _ _ _ _ _ => ⟨trivial, trivial⟩

theorem acting : (flow split).Acting (web split) :=
  fun _ _ _ _ gives => absurd gives (Nat.lt_irrefl 0)

/-- At each splitting step the pool falls, counted in the finer unit. -/
theorem falls {t : Nat} (splits : 0 < split t) :
    (web split).level (t + 1) () < refinement split t * (web split).level t () :=
  Nat.lt_of_lt_of_le (Nat.add_lt_add_left (Nat.succ_lt_succ splits) (units split (t + 1)))
    (Nat.le_of_eq ((congrArg (refinement split t * units split t + ·)
      (Nat.mul_one (refinement split t)).symm).trans (Nat.left_distrib _ _ _).symm))

/-- The flow exchanges at arbitrarily late steps exactly where the unit splits at
arbitrarily late steps. -/
theorem exchange_recurs_iff :
    (flow split).ExchangeRecurs ↔ ∀ N, ∃ t, N ≤ t ∧ 0 < split t :=
  ⟨fun recurs N => match recurs N with
    | ⟨t, _, _, later, _, .inl takes⟩ => ⟨t, later, takes⟩
    | ⟨_, _, _, _, _, .inr gives⟩ => absurd gives (Nat.lt_irrefl 0),
   fun splits N => match splits N with
    | ⟨t, later, positive⟩ => ⟨t, (), (), later, .head _, .inl positive⟩⟩

/-- Where the unit splits at arbitrarily late steps, the drawer takes from the closed pool
at arbitrarily late steps. -/
theorem taking_recurs (splits : ∀ N, ∃ t, N ≤ t ∧ 0 < split t) :
    ∀ N, ∃ t, N ≤ t ∧ 0 < (flow split).takers [()] t :=
  fun N => match splits N with
    | ⟨t, later, positive⟩ => ⟨t, later, match h : split t with
      | 0 => absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq h)) (Nat.lt_irrefl 0)
      | _ + 1 => Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq
          (congrArg (fun k => sign (k + 0) + 0) h).symm)⟩

/-- Where the unit splits at arbitrarily late steps, the flow does not balance at the fixed
unit: with it fixed, taking from the closed pool does not recur
(`Flow.Balances.taking_not_recurring`). -/
theorem not_balanced (splits : ∀ N, ∃ t, N ≤ t ∧ 0 < split t) :
    ¬ (flow split).Balances (web split) :=
  fun balances => Flow.Balances.taking_not_recurring balances (T := 0)
    (fun t _ => dissipative split [()] t distinct (closed split t)) (taking_recurs split splits)

end Asymptote

/-! ## A pool passed in full at each step -/

namespace Geometric

variable (q s : Nat)

/-- One formation takes the whole pool at each step and gives back `q` parts in `q + 1`;
the unit splits into `q + 1` at each step, so the pool stands at `s q^t` units of step `t`,
`s (q/(q + 1))^t` units of step 0. -/
def flow : Flow Unit Unit :=
  ⟨fun _ => [()], fun t _ _ => (q + 1) * (s * powers q t), fun t _ _ => s * powers q (t + 1)⟩

def web : Web Unit Unit :=
  ⟨fun t _ => s * powers q t, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 0,
    fun _ _ _ => True⟩

theorem balances : (flow q s).BalancesAt (fun _ => q + 1) (web q s) :=
  fun t c => match c with
  | () => show s * powers q (t + 1) + ((q + 1) * (s * powers q t) + 0) =
        (q + 1) * (s * powers q t) + (s * powers q (t + 1) + 0) from Nat.add_comm _ _

theorem closed (t : Nat) : (flow q s).ClosedAt [()] t :=
  fun _ _ c outside => absurd (match c with | () => List.Mem.head []) outside

/-- The formation gives back exactly `q` parts in `q + 1` of what it takes. -/
theorem dissipativeBy : (flow q s).DissipativeBy q :=
  fun cs t _ _ => Flow.DissipatesBy.of_each fun _ _ => Nat.le_of_eq <|
    calc (q + 1) * total cs (fun _ => s * powers q (t + 1))
        = (q + 1) * (cs.length * (q * (s * powers q t))) :=
          congrArg ((q + 1) * ·) ((total_const _ cs).trans
            (congrArg (cs.length * ·) (mul_turn s q _)))
      _ = q * (cs.length * ((q + 1) * (s * powers q t))) :=
          (congrArg ((q + 1) * ·) (mul_turn _ _ _)).trans ((mul_turn _ _ _).trans
            (congrArg (q * ·) (mul_turn _ _ _)))
      _ = q * total cs (fun _ => (q + 1) * (s * powers q t)) :=
          congrArg (q * ·) (total_const _ cs).symm

/-- What the formation takes across each step. -/
theorem uptake (t : Nat) : (flow q s).uptake [()] t = (q + 1) * (s * powers q t) :=
  (Nat.add_zero _).trans (Nat.add_zero _)

/-- The exact balance of the amount law: `q + 1` times what remains, with everything taken,
is `q + 1` times the pool at `T`, counted in the unit of step `T + n`. -/
theorem exact (T : Nat) : ∀ n,
    (q + 1) * (s * powers q (T + n)) +
        refinedSum (fun _ => q + 1) (fun t => (q + 1) * (s * powers q t)) T n =
      (q + 1) * (s * powers q T) * powers (q + 1) n
  | 0 => (Nat.mul_one _).symm
  | n + 1 =>
    calc (q + 1) * (s * (q * powers q (T + n))) +
          ((q + 1) * refinedSum (fun _ => q + 1) (fun t => (q + 1) * (s * powers q t)) T n +
            (q + 1) * (s * powers q (T + n)))
        = (q + 1) * ((q + 1) * (s * powers q (T + n))) +
            (q + 1) * refinedSum (fun _ => q + 1) (fun t => (q + 1) * (s * powers q t)) T n :=
          (Nat.add_left_comm _ _ _).trans (congrArg (_ + ·)
            ((Nat.left_distrib _ _ _).symm.trans (congrArg ((q + 1) * ·)
              ((congrArg (· + s * powers q (T + n)) (mul_turn s q _)).trans
                ((congrArg (q * (s * powers q (T + n)) + ·) (Nat.one_mul _).symm).trans
                  (add_mul_split q 1 _).symm))))) |>.trans (Nat.add_comm _ _)
      _ = (q + 1) * ((q + 1) * (s * powers q T) * powers (q + 1) n) :=
          (Nat.left_distrib _ _ _).symm.trans (congrArg ((q + 1) * ·) (exact T n))
      _ = (q + 1) * (s * powers q T) * powers (q + 1) (n + 1) := mul_turn _ _ _

end Geometric


/-! ## Exchange of a fixed size, with vanishing loss -/

namespace Circulation

/-- One less than the units of step `t` per unit of step 0; the unit halves at each step. -/
def spare : Nat → Nat
  | 0 => 0
  | t + 1 => 2 * spare t + 1

/-- Units of step `t` per unit of step 0. -/
def units (t : Nat) : Nat :=
  spare t + 1

/-- At each step the drawer takes one unit of step 0 from the pool, `units (t + 1)` units of
step `t + 1`, and gives all of it back but one unit of step `t + 1`. -/
def flow : Flow Unit Unit :=
  ⟨fun _ => [()], fun t _ _ => units (t + 1), fun t _ _ => spare (t + 1)⟩

/-- The pool stands one unit of step `t` above the drawer's need of one unit of step 0. -/
def web : Web Unit Unit :=
  ⟨fun t _ => spare t + 2, fun _ _ => True, fun _ _ _ => True, fun t _ _ => units t,
    fun _ _ _ => True⟩

theorem balances : flow.BalancesAt (fun _ => 2) web :=
  fun t c => match c with
  | () => show 2 * spare t + 1 + 2 + (2 * spare t + 1 + 1 + 0) =
        2 * (spare t + 2) + (2 * spare t + 1 + 0) from
      (Nat.succ_add (2 * spare t + 3) (2 * spare t + 1)).symm.trans
        (congrArg (· + (2 * spare t + 1)) (Nat.left_distrib 2 (spare t) 2).symm)

theorem closed (t : Nat) : flow.ClosedAt [()] t :=
  fun _ _ c outside => absurd (match c with | () => List.Mem.head []) outside

/-- Every take loses one unit of the step after it, so the flow dissipates. -/
theorem dissipative : flow.Dissipative :=
  fun cs t distinct _ f _ => match cs, distinct, f with
  | [], _, _ => Nat.le_refl 0
  | [()], _, () => Nat.le_refl (spare (t + 1) + 1)
  | () :: () :: _, ⟨fresh, _⟩, _ => absurd (List.Mem.head _) fresh

theorem dependent : web.Dependent :=
  fun _ _ _ _ _ => Nat.le_succ _

/-- The exchange never shrinks: at every step the drawer takes one unit of step 0. -/
theorem takes_a_unit (t : Nat) : flow.take t () () = units (t + 1) :=
  rfl

/-- What it gives back falls short of what it takes by one unit of the step after it. -/
theorem loses_one (t : Nat) : flow.give t () () + 1 = flow.take t () () :=
  rfl

/-- The units of `Circulation` are those of a unit halving at each step. -/
theorem units_eq : ∀ t, units t = halving t
  | 0 => rfl
  | t + 1 => (Nat.left_distrib 2 (spare t) 1).symm.trans (congrArg (2 * ·) (units_eq t))

/-- So at every step the drawer takes exactly one unit of step 0. -/
theorem takes_whole (t : Nat) : flow.take t () () = halving (t + 1) :=
  units_eq (t + 1)

/-- So no fixed proportion of what is taken is lost: by the exchange law, for no `q` is the flow
dissipative in proportion `q`. -/
theorem not_dissipativeBy (q : Nat) : ¬ flow.DissipativeBy q :=
  fun dissipative => Flow.exchange_not_recurring balances dissipative Asymptote.distinct (T := 0)
    (fun t _ => closed t) (R := halving) rfl (fun _ _ => rfl) (fun _ _ => Nat.succ_pos 1) 1
    fun N => ⟨N, (), Nat.le_refl N, .head _, Nat.le_of_eq ((takes_whole N).symm.trans
      (Nat.one_mul _).symm)⟩

/-- The pool stands throughout and is listed. -/
theorem standing : web.StandingCensus fun _ => [()] :=
  fun _ => ⟨⟨fun no => (nomatch no), trivial⟩, fun c => match c with
    | () => ⟨fun _ => .head _, fun _ => Nat.succ_pos _⟩⟩

/-- Every step is enclosed around what stands. -/
theorem around (t : Nat) : flow.AroundStanding (fun _ => [()]) t :=
  ⟨[()], ⟨fun no => (nomatch no), trivial⟩, (fun c _ => match c with | () => .head _),
    (fun c _ => match c with | () => .head _), closed t⟩

theorem exchange_recurs : flow.ExchangeRecurs :=
  fun N => ⟨N, (), (), Nat.le_refl N, .head _, .inl (Nat.succ_pos _)⟩

end Circulation

/-! ## Arising without end inside enclosure -/

namespace Emission

/-- The relatum emitted at step `s`: nothing through step `s`, then one unit of step
`s + 1`, kept as the unit halves. -/
def bud (s : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => 2 * bud s t + mark (s = t)

/-- What the pool takes across a step: two units of the step after it, from itself. -/
def drawn : Option Nat → Nat
  | none => 2
  | some _ => 0

/-- What the pool gives across the step from `t`: one unit to the relatum emitted then. -/
def emitted (t : Nat) : Option Nat → Nat
  | none => 0
  | some s => mark (s = t)

/-- The pool, `none`, stands at `halving t + 2` units of step `t`; the relatum emitted at `s`
at `bud s t`. -/
def level (t : Nat) : Option Nat → Nat
  | none => halving t + 2
  | some s => bud s t

def flow : Flow (Option Nat) (Option Nat) :=
  ⟨fun _ => [none], fun _ _ => drawn, fun t _ => emitted t⟩

/-- Each relatum is active exactly while it stands; the pool draws on itself. -/
def web : Web (Option Nat) (Option Nat) :=
  ⟨level, fun t x => 0 < level t x, fun _ _ _ => False, fun _ _ _ => 0,
    fun _ _ c => c = none⟩

def world : World :=
  World.of (Option Nat) flow web

theorem bud_before {s : Nat} : ∀ {t}, t ≤ s → bud s t = 0
  | 0, _ => rfl
  | t + 1, early =>
    (congrArg (fun k => 2 * k + mark (s = t)) (bud_before (Nat.le_of_succ_le early))).trans
      (congrArg (2 * 0 + ·) (mark_zero fun same =>
        Nat.lt_irrefl t (Nat.lt_of_lt_of_le early (Nat.le_of_eq same))))

theorem bud_after (s : Nat) : bud s (s + 1) = 1 :=
  (congrArg (fun k => 2 * k + mark (s = s)) (bud_before (Nat.le_refl s))).trans
    (congrArg (2 * 0 + ·) (mark_one rfl))

theorem bud_pos {s : Nat} : ∀ {t}, s + 1 ≤ t → 0 < bud s t
  | _, .refl => Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq (bud_after s).symm)
  | t + 1, .step later => Nat.lt_of_lt_of_le (bud_pos later)
      (Nat.le_trans (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
        (Nat.mul_le_mul_right (bud s t) (Nat.le_succ 1))) (Nat.le_add_right _ _))

theorem active_bud {s t : Nat} : web.active t (some s) ↔ s < t :=
  ⟨fun active => match Nat.lt_or_ge s t with
    | .inl before => before
    | .inr late => absurd (Nat.lt_of_lt_of_le active (Nat.le_of_eq (bud_before late)))
        (Nat.lt_irrefl 0),
   fun before => bud_pos before⟩

theorem none_not_mem : ∀ l : List Nat, ¬ (none : Option Nat) ∈ l.map some
  | [], mem => nomatch mem
  | _ :: l, mem => match mem with
    | .tail _ rest => none_not_mem l rest

/-- The pool and the relata emitted so far, each once. -/
def alive (t : Nat) : List (Option Nat) :=
  none :: (steps 0 t).map some

/-- A census: what is active at each step is listed, each once. -/
theorem census : web.Census alive :=
  fun t => ⟨⟨none_not_mem _, distinct_map (fun _ _ h => ListTests.some_inj h) (steps_distinct 0 t)⟩, fun x => match x with
    | none => ⟨fun _ => .head _, fun _ => Nat.succ_pos _⟩
    | some s => ⟨fun active => .tail _ (mem_map_of (steps_of_within (Nat.zero_le s)
          (Nat.lt_of_lt_of_le (active_bud.mp active) (Nat.le_of_eq (Nat.zero_add t).symm)))),
        fun mem => match mem with
          | .tail _ rest => active_bud.mpr (Nat.lt_of_lt_of_le
              (steps_within (mem_of_map (fun _ _ h => ListTests.some_inj h) rest)) (Nat.le_of_eq (Nat.zero_add t)))⟩⟩

theorem counted : world.Counted :=
  ⟨alive, census⟩

theorem embodied : world.Embodied :=
  fun _ _ => Iff.rfl

/-- The flow balances at a unit halving at each step. -/
theorem balances : flow.BalancesAt (fun _ => 2) web :=
  fun t c => match c with
  | none => show 2 * halving t + 2 + (2 + 0) = 2 * (halving t + 2) + (0 + 0) from
      (Nat.add_assoc (2 * halving t) 2 2).trans (Nat.left_distrib 2 (halving t) 2).symm
  | some _ => rfl

theorem emitted_absent {t : Nat} :
    ∀ {cs : List (Option Nat)}, ¬ some t ∈ cs → total cs (emitted t) = 0
  | [], _ => rfl
  | none :: _, absent => (Nat.zero_add _).trans (emitted_absent fun mem => absent (.tail _ mem))
  | some _ :: cs, absent =>
    (congrArg (· + total cs (emitted t)) (mark_zero fun same =>
      absent (Eq.subst (motive := fun k => some t ∈ some k :: cs) same.symm (.head cs)))).trans
    ((Nat.zero_add _).trans (emitted_absent fun mem => absent (.tail _ mem)))

theorem emitted_le_one {t : Nat} :
    ∀ {cs : List (Option Nat)}, Distinct cs → total cs (emitted t) ≤ 1
  | [], _ => Nat.zero_le 1
  | none :: _, ⟨_, distinct⟩ =>
    Nat.le_trans (Nat.le_of_eq (Nat.zero_add _)) (emitted_le_one distinct)
  | some s :: cs, ⟨fresh, distinct⟩ => match Nat.decEq s t with
    | isTrue same => Nat.add_le_add (mark_le_one _) (Nat.le_of_eq (emitted_absent fun mem =>
        fresh (Eq.subst (motive := fun k => some k ∈ cs) same.symm mem)))
    | isFalse other => Nat.le_trans (Nat.le_of_eq ((congrArg (· + total cs (emitted t))
        (mark_zero other)).trans (Nat.zero_add _))) (emitted_le_one distinct)

def decideNone (x : Option Nat) : Decidable (x = none) :=
  match x with
  | none => isTrue rfl
  | some _ => isFalse fun same => nomatch same

/-- A family closed across a step holds the pool, which takes from itself. -/
theorem pool_mem {cs : List (Option Nat)} {t : Nat} (closed : flow.ClosedAt cs t) :
    none ∈ cs :=
  match decideSome (decide := decideNone) cs with
  | isTrue ⟨_, mem, same⟩ => Eq.subst (motive := (· ∈ cs)) same mem
  | isFalse absent =>
    Nat.noConfusion (closed none (.head _) none fun mem => absent ⟨none, mem, rfl⟩).1

/-- The flow dissipates: on a family closed across a step, the pool gives at most one unit
and takes two. -/
theorem dissipative : flow.Dissipative :=
  fun _ _ distinct closed _ _ => Nat.le_trans
    (Nat.add_le_add (emitted_le_one distinct) (sign_le_one _))
    (le_total_of_mem (q := drawn) (pool_mem closed))

/-- Every step is enclosed: the pool and the relatum emitted then are closed. -/
theorem enclosed (t : Nat) : flow.Enclosed t :=
  ⟨[none, some t], ⟨(fun mem => match mem with | .tail _ rest => nomatch rest),
      ⟨(fun mem => nomatch mem), trivial⟩⟩,
   fun _ _ c outside => match c with
    | none => absurd (.head _) outside
    | some _ => ⟨rfl, mark_zero fun same => outside (Eq.subst
        (motive := fun k => some k ∈ [none, some t]) same.symm (.tail _ (.head _)))⟩⟩

/-- A new relatum arises at every step. -/
theorem arises (t : Nat) : web.Arises t (some t) :=
  ⟨fun active => absurd (Nat.lt_of_lt_of_le active (Nat.le_of_eq (bud_before (Nat.le_refl t))))
      (Nat.lt_irrefl 0),
   bud_pos (Nat.le_refl (t + 1))⟩

theorem arising_recurs : world.ArisingRecurs :=
  fun N => ⟨N, some N, Nat.le_refl N, arises N⟩

/-- Only the active pool gives and takes, and it takes only from itself. -/
theorem acting : flow.Acting web :=
  fun _ f _ present _ => match f, present with
  | none, _ => Nat.succ_pos _

theorem taking : flow.Taking web :=
  fun _ f c present takes => match f, present, c with
  | none, _, none => ⟨Nat.succ_pos _, rfl⟩
  | none, _, some _ => absurd takes (Nat.lt_irrefl 0)

/-- The flow dissipates in proportion: on a family closed across a step, the pool gives
back at most half of what it takes. -/
theorem dissipativeBy : flow.DissipativeBy 1 :=
  fun _ _ distinct closed => Flow.DissipatesBy.of_each fun _ _ =>
    Nat.le_trans (Nat.mul_le_mul_left 2 (emitted_le_one distinct))
      (Nat.le_trans (le_total_of_mem (q := drawn) (pool_mem closed))
        (Nat.le_of_eq (Nat.one_mul _).symm))

/-- What arises at step `t` stands at one unit of step `t + 1`. -/
theorem arises_small (t : Nat) : web.level (t + 1) (some t) = 1 :=
  bud_after t

/-- The world does not balance at the fixed unit: with it fixed, continued arising needs
openness (`World.arising_opens`). -/
theorem not_balanced : ¬ world.Balanced :=
  fun balanced => World.arising_opens counted embodied balanced dissipative arising_recurs 0
    fun t _ => enclosed t

end Emission

/-! ## A whole unit handed back and forth -/

namespace Alternation

open Shuttle (holder stands)

/-- The side holding the standing at step `t` stands at `halving t + 1` units of step `t`,
one unit of step 0 and one of step `t`; the other side stands at nothing. -/
def level (t : Nat) (x : Bool) : Nat :=
  stands x t * (halving t + 1)

/-- Across each step the holder takes all it holds and gives the other side all of it but
one unit of the step after. -/
def flow : Flow Bool Bool :=
  ⟨fun t => [holder t], fun t _ x => stands x t * (2 * halving t + 2),
    fun t _ x => stands x (t + 1) * (2 * halving t + 1)⟩

/-- Each side is active exactly while it stands. -/
def web : Web Bool Bool :=
  ⟨level, fun t x => 0 < level t x, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

def world : World :=
  World.of Bool flow web

/-- The flow balances at a unit halving at each step. -/
theorem balances : flow.BalancesAt (fun _ => 2) web :=
  fun t x => show stands x (t + 1) * (2 * halving t + 1) +
        (stands x t * (2 * halving t + 2) + 0) =
      2 * (stands x t * (halving t + 1)) + (stands x (t + 1) * (2 * halving t + 1) + 0) from
    (Nat.add_comm _ _).trans (congrArg (· + stands x (t + 1) * (2 * halving t + 1))
      ((congrArg (stands x t * ·) (Nat.left_distrib 2 (halving t) 1).symm).trans
        (mul_turn _ _ _)))

theorem stands_sum : ∀ t, stands true t + stands false t = 1
  | 0 => rfl
  | 1 => rfl
  | t + 2 => stands_sum t

theorem stands_one {x : Bool} {t : Nat} (standing : 0 < stands x t) : stands x t = 1 :=
  Eq.subst (motive := fun b => stands b t = 1) ((Exposed.stands_iff x t).mp standing).symm
    (Exposed.holder_one t)

theorem active_iff {t : Nat} {x : Bool} : web.active t x ↔ 0 < stands x t :=
  ⟨fun active => match Nat.eq_zero_or_pos (stands x t) with
    | .inl zero => absurd (Nat.lt_of_lt_of_le active (Nat.le_of_eq
        ((congrArg (· * (halving t + 1)) zero).trans (Nat.zero_mul _)))) (Nat.lt_irrefl 0)
    | .inr standing => standing,
   fun standing => (Nat.mul_le_mul standing (Nat.succ_pos (halving t)) : 1 * 1 ≤ _)⟩

/-- The holder is the one active relatum. -/
theorem census : web.Census fun t => [holder t] :=
  fun t => ⟨⟨fun no => (nomatch no), trivial⟩, fun x =>
    ⟨fun active => Eq.subst (motive := fun b => b ∈ [holder t])
        ((Exposed.stands_iff x t).mp (active_iff.mp active)).symm (.head _),
     fun mem => active_iff.mpr ((Exposed.stands_iff x t).mpr (match mem_cons_cases mem with
        | .inl same => same
        | .inr no => nomatch no))⟩⟩

theorem counted : world.Counted :=
  ⟨_, census⟩

theorem embodied : world.Embodied :=
  fun _ _ => Iff.rfl

/-- The two sides are all there is, so every step is enclosed. -/
theorem enclosed (t : Nat) : flow.Enclosed t :=
  Flow.enclosed_of_finite Shuttle.distinct ListTests.mem_bools t

/-- The holder takes all it holds. -/
theorem holder_takes (t : Nat) : 2 * halving t + 2 = stands (holder t) t * (2 * halving t + 2) :=
  (Nat.one_mul _).symm.trans (congrArg (· * (2 * halving t + 2)) (Exposed.holder_one t).symm)

/-- A family closed across a step holds the holder. -/
theorem holder_mem {es : List Bool} {t : Nat} (closed : flow.ClosedAt es t) : holder t ∈ es :=
  match decideSome (decide := fun b => instDecidableEqBool b (holder t)) es with
  | isTrue ⟨_, mem, same⟩ => Eq.subst (motive := (· ∈ es)) same mem
  | isFalse absent => absurd (closed (holder t) (.head _) (holder t)
      fun mem => absent ⟨holder t, mem, rfl⟩).1 fun zero => Nat.lt_irrefl 0
        (Nat.lt_of_lt_of_le (Nat.succ_pos (2 * halving t + 1))
          (Nat.le_trans (Nat.le_of_eq (holder_takes t)) (Nat.le_of_eq zero)))

/-- What is given across a step totals at most all but one unit of the step after. -/
theorem given_total {es : List Bool} (distinct : Distinct es) (t : Nat) (f : Bool) :
    total es (flow.give t f) ≤ 2 * halving t + 1 :=
  Nat.le_trans (total_le_of_support distinct fun c _ _ => ListTests.mem_bools c)
    (Nat.le_of_eq ((add_mul_split (stands true (t + 1)) (stands false (t + 1)) _).symm.trans
      ((congrArg (· * (2 * halving t + 1)) (stands_sum (t + 1))).trans (Nat.one_mul _))))

/-- Each step loses one unit of the step after it, so the flow dissipates. -/
theorem dissipative : flow.Dissipative :=
  fun _ t distinct closed f _ => Nat.le_trans
    (Nat.add_le_add (given_total distinct t f) (sign_le_one _))
    (Nat.le_trans (Nat.le_of_eq (holder_takes t)) (le_total_of_mem (q := flow.take t f)
      (holder_mem closed)))

/-- A whole unit of step 0 arises at arbitrarily late steps. -/
theorem arising_whole (N : Nat) :
    ∃ t x, N ≤ t ∧ web.Arises t x ∧ halving (t + 1) ≤ 1 * web.level (t + 1) x :=
  match Shuttle.recurs true N with
  | ⟨t, after, before, now⟩ => ⟨t, true, after,
      ⟨fun active => before (active_iff.mp active), active_iff.mpr now⟩,
      Nat.le_trans (Nat.le_succ _) (Nat.le_of_eq ((Nat.one_mul _).symm.trans
        ((congrArg (· * (halving (t + 1) + 1)) (stands_one now).symm).trans
          (Nat.one_mul _).symm)))⟩

theorem arising_recurs : world.ArisingRecurs :=
  fun N => match arising_whole N with
  | ⟨t, x, after, arises, _⟩ => ⟨t, x, after, arises⟩

/-- So no fixed proportion of what is taken is lost: by the growth law, for no `q` is the flow
dissipative in proportion `q`. -/
theorem not_dissipativeBy (q : Nat) : ¬ flow.DissipativeBy q :=
  fun dissipative => World.arising_not_recurring (w := world) counted embodied balances
    dissipative (T := 0) (fun t _ => enclosed t) (R := halving) rfl (fun _ _ => rfl)
    (fun _ _ => Nat.succ_pos 1) 1 arising_whole

/-- The world does not balance at the fixed unit: with it fixed, continued arising needs
openness (`World.arising_opens`). -/
theorem not_balanced : ¬ world.Balanced :=
  fun balanced => World.arising_opens counted embodied balanced dissipative arising_recurs 0
    fun t _ => enclosed t

end Alternation

/-! ## A reserve dwindling without end

One formation depends on one condition at need one,
which never stands, so it is never supported; it is active at every step, its reserve
standing at `halving t + 1` units of step `t`, one unit of step 0 and one of step `t`, and
falling by one unit of the step after at each step. -/
namespace Dwindle

def web : Web Unit Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => True⟩

def reserve (t : Nat) (_ : Unit) : Nat :=
  halving t + 1

theorem unsupported (t : Nat) : ¬ web.Supported t () :=
  fun supported => Nat.lt_irrefl 0 (supported () trivial)

theorem carriesIn : web.CarriesIn (fun _ => 2) reserve :=
  fun t _ _ => have falls : halving (t + 1) + 1 < 2 * (halving t + 1) :=
      Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_of_eq (Nat.left_distrib 2 (halving t) 1).symm)
    ⟨Nat.le_of_lt falls, fun _ => falls⟩

instance (t : Nat) : Decidable (web.active t ()) :=
  isTrue trivial

/-- So no least fall of the reserve per active step holds at any `p`: by `Web.CarriesAt.lasts`, the
formation, never supported, would be active at most `p` times its reserve. -/
theorem not_carriesAt (p : Nat) : ¬ web.CarriesAt (fun _ => 2) halving p reserve :=
  fun carries =>
    have bound := carries.lasts (f := ()) (T := 0) rfl (fun _ _ => rfl)
      (fun _ _ => Nat.succ_pos 1) (fun t _ => unsupported t) (p * 2 + 1)
    Nat.lt_irrefl (p * 2) (Nat.lt_of_lt_of_le (Nat.lt_succ_self _) (Nat.le_trans
      (Nat.le_of_eq (((total_congr (fun _ => mark_one trivial) (steps 0 (p * 2 + 1))).trans
        (total_ones _)).trans (steps_length 0 _)).symm) bound))

end Dwindle

/-! ## A whole unit carried by ever more, ever smaller transfers -/

namespace Trickle

open Shuttle (holder stands)

/-- The relata: two sides, and the conduits `.inr i`. -/
abbrev Relatum := Bool ⊕ Nat

/-- The conduits taking part across the step from a step with `n` of them. -/
def conduits : Nat → List Relatum
  | 0 => []
  | n + 1 => .inr n :: conduits n

theorem conduits_length : ∀ n, (conduits n).length = n
  | 0 => rfl
  | n + 1 => congrArg (· + 1) (conduits_length n)

/-- How much of the standing a relatum holds at step `t`: one for the holder, none for the
other side or a conduit. -/
def side (t : Nat) : Relatum → Nat
  | .inl b => stands b t
  | .inr _ => 0

/-- The side holding the standing at step `t` stands at `quarter t + halving t` units of step
`t`, one unit of step 0 and `2^-t` of one; everything else stands at nothing. -/
def level (t : Nat) (c : Relatum) : Nat :=
  side t c * (quarter t + halving t)

/-- Across the step from `t`, `halving t` conduits take part. Each takes `4 (halving t + 1)`
units of step `t + 1` from the holder and gives the other side all of it but two: the whole
of what the holder holds passes in `halving t` parts, each about four times as large, in units
of step 0, as the parts of the step after next, each losing two units of the step after. -/
def flow : Flow Relatum Relatum :=
  ⟨fun t => conduits (halving t), fun t _ c => side t c * (4 * (halving t + 1)),
    fun t _ c => side (t + 1) c * (2 * (2 * halving t + 1))⟩

/-- A relatum is active exactly while it stands. -/
def web : Web Relatum Relatum :=
  ⟨level, fun t c => 0 < level t c, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

def world : World :=
  World.of Relatum flow web

theorem taken (t : Nat) (c : Relatum) :
    flow.taken t c = halving t * (side t c * (4 * (halving t + 1))) :=
  (total_const _ _).trans (congrArg (· * _) (conduits_length (halving t)))

theorem given (t : Nat) (c : Relatum) :
    flow.given t c = halving t * (side (t + 1) c * (2 * (2 * halving t + 1))) :=
  (total_const _ _).trans (congrArg (· * _) (conduits_length (halving t)))

/-- What the holder holds, taken in `halving t` parts. -/
theorem parts_taken (t : Nat) :
    halving t * (4 * (halving t + 1)) = 4 * (quarter t + halving t) :=
  (mul_turn _ _ _).trans (congrArg (4 * ·) ((Nat.left_distrib _ _ _).trans
    (Naturals.add_congr (quarter_eq t).symm (Nat.mul_one _))))

/-- What the other side is given, in `halving t` parts. -/
theorem parts_given (t : Nat) :
    halving t * (2 * (2 * halving t + 1)) = quarter (t + 1) + halving (t + 1) :=
  (mul_turn _ _ _).trans ((congrArg (2 * ·) ((Nat.left_distrib _ _ _).trans
    (Naturals.add_congr ((mul_turn _ _ _).trans (congrArg (2 * ·) (quarter_eq t).symm))
      (Nat.mul_one _)))).trans
    ((Nat.left_distrib _ _ _).trans (congrArg (· + 2 * halving t) (mul_assoc_nat 2 2 _).symm)))

/-- The flow balances at a unit quartering at each step. -/
theorem balances : flow.BalancesAt (fun _ => 4) web :=
  fun t c => show level (t + 1) c + flow.taken t c = 4 * level t c + flow.given t c from
    calc level (t + 1) c + flow.taken t c
        = side (t + 1) c * (quarter (t + 1) + halving (t + 1)) +
            side t c * (halving t * (4 * (halving t + 1))) :=
          congrArg (level (t + 1) c + ·) ((taken t c).trans (mul_turn _ _ _))
      _ = side (t + 1) c * (halving t * (2 * (2 * halving t + 1))) +
            side t c * (4 * (quarter t + halving t)) :=
          Naturals.add_congr (congrArg (side (t + 1) c * ·) (parts_given t).symm)
            (congrArg (side t c * ·) (parts_taken t))
      _ = 4 * level t c + flow.given t c :=
          (Nat.add_comm _ _).trans (Naturals.add_congr (mul_turn _ _ _)
            ((mul_turn _ _ _).trans (given t c).symm))

theorem active_iff {t : Nat} {c : Relatum} : web.active t c ↔ 0 < side t c :=
  ⟨fun active => match Nat.eq_zero_or_pos (side t c) with
    | .inl zero => absurd (Nat.lt_of_lt_of_le active (Nat.le_of_eq
        ((congrArg (· * (quarter t + halving t)) zero).trans (Nat.zero_mul _))))
        (Nat.lt_irrefl 0)
    | .inr standing => standing,
   fun standing => (Nat.mul_le_mul standing (Nat.le_trans (halving_pos t)
      (Nat.le_add_left _ _)) : 1 * 1 ≤ _)⟩

theorem side_pos_iff : ∀ {t : Nat} {c : Relatum}, 0 < side t c ↔ c = .inl (holder t)
  | t, .inl b => ⟨fun pos => congrArg Sum.inl ((Exposed.stands_iff b t).mp pos),
      fun same => (Exposed.stands_iff b t).mpr (Sum.inl.inj same)⟩
  | _, .inr _ => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun same => nomatch same⟩

/-- The holder is the one active relatum. -/
theorem census : web.Census fun t => [.inl (holder t)] :=
  fun t => ⟨⟨fun no => (nomatch no), trivial⟩, fun _ =>
    ⟨fun active => Eq.subst (motive := fun d => d ∈ [Sum.inl (holder t)])
        (side_pos_iff.mp (active_iff.mp active)).symm (.head _),
     fun mem => active_iff.mpr (side_pos_iff.mpr (match mem_cons_cases mem with
        | .inl same => same
        | .inr no => nomatch no))⟩⟩

theorem counted : world.Counted :=
  ⟨_, census⟩

theorem embodied : world.Embodied :=
  fun _ _ => Iff.rfl

/-- The two sides. -/
def sides : List Relatum := [.inl true, .inl false]

theorem sides_distinct : Distinct sides :=
  ⟨(fun mem => match mem_cons_cases mem with
    | .inl same => nomatch same
    | .inr no => nomatch no), ⟨fun no => (nomatch no), trivial⟩⟩

theorem side_mem : ∀ {t : Nat} {c : Relatum}, 0 < side t c → c ∈ sides
  | _, .inl true, _ => .head _
  | _, .inl false, _ => .tail _ (.head _)
  | _, .inr _, pos => absurd pos (Nat.lt_irrefl 0)

theorem off_sides {t : Nat} {c : Relatum} (outside : ¬ c ∈ sides) : side t c = 0 :=
  eq_zero_of_not_pos fun pos => outside (side_mem pos)

theorem sides_total (t k : Nat) : total sides (fun c => side t c * k) = k :=
  (congrArg (stands true t * k + ·) (Nat.add_zero _)).trans
    ((add_mul_split (stands true t) (stands false t) k).symm.trans
      ((congrArg (· * k) (Alternation.stands_sum t)).trans (Nat.one_mul k)))

/-- Each part taken from the holder. -/
theorem holder_takes (t : Nat) (f : Relatum) :
    flow.take t f (.inl (holder t)) = 4 * (halving t + 1) :=
  (congrArg (· * (4 * (halving t + 1))) (Exposed.holder_one t)).trans (Nat.one_mul _)

theorem conduit_mem : ∀ {n : Nat}, 0 < n → Sum.inr (n - 1) ∈ conduits n
  | 0, zero => absurd zero (Nat.lt_irrefl 0)
  | _ + 1, _ => .head _

theorem first_conduit (t : Nat) : Sum.inr (halving t - 1) ∈ flow.present t :=
  conduit_mem (halving_pos t)

/-- Whether a relatum is the holder at step `t`. -/
def isHolder (t : Nat) : (c : Relatum) → Decidable (c = .inl (holder t))
  | .inl b => match instDecidableEqBool b (holder t) with
    | isTrue same => isTrue (congrArg Sum.inl same)
    | isFalse other => isFalse fun same => other (Sum.inl.inj same)
  | .inr _ => isFalse fun same => nomatch same

/-- A family closed across a step holds the holder. -/
theorem holder_mem {es : List Relatum} {t : Nat} (closed : flow.ClosedAt es t) :
    Sum.inl (holder t) ∈ es :=
  match decideSome (decide := isHolder t) es with
  | isTrue ⟨_, mem, same⟩ => Eq.subst (motive := (· ∈ es)) same mem
  | isFalse absent => absurd (closed _ (first_conduit t) (.inl (holder t))
      fun mem => absent ⟨_, mem, rfl⟩).1 fun zero => Nat.lt_irrefl 0
        (Nat.lt_of_lt_of_le (Nat.succ_pos (4 * halving t + 3))
          (Nat.le_trans (Nat.le_of_eq ((Nat.left_distrib 4 (halving t) 1).symm.trans
            (holder_takes t _).symm)) (Nat.le_of_eq zero)))

/-- What a part gives any family totals at most `2 (2 halving t + 1)` units of the step
after. -/
theorem given_total {es : List Relatum} (distinct : Distinct es) (t : Nat) (f : Relatum) :
    total es (flow.give t f) ≤ 2 * (2 * halving t + 1) :=
  Nat.le_trans (total_le_of_support distinct fun _ _ pos =>
      side_mem (Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos
        (Nat.le_of_eq ((congrArg (· * _) zero).trans (Nat.zero_mul _))))))
    (Nat.le_of_eq (sides_total (t + 1) _))

/-- What a part takes from any family totals at most `4 (halving t + 1)` units of the step
after. -/
theorem taken_le {es : List Relatum} (distinct : Distinct es) (t : Nat) (f : Relatum) :
    total es (flow.take t f) ≤ 4 * (halving t + 1) :=
  Nat.le_trans (total_le_of_support distinct fun _ _ pos =>
      side_mem (Nat.pos_of_ne_zero fun zero => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos
        (Nat.le_of_eq ((congrArg (· * _) zero).trans (Nat.zero_mul _))))))
    (Nat.le_of_eq (sides_total t _))

/-- What a part takes from a closed family totals at least `4 (halving t + 1)` units of the
step after. -/
theorem taken_total {es : List Relatum} {t : Nat} (closed : flow.ClosedAt es t)
    (f : Relatum) : 4 * (halving t + 1) ≤ total es (flow.take t f) :=
  Nat.le_trans (Nat.le_of_eq (holder_takes t f).symm)
    (le_total_of_mem (q := flow.take t f) (holder_mem closed))

/-- Two units of the step after are lost per part. -/
theorem part_loss (h : Nat) : 2 * (2 * h + 1) + 2 = 4 * (h + 1) :=
  (congrArg (· + 2) ((Nat.left_distrib 2 (2 * h) 1).trans
    (congrArg (· + 2) (mul_assoc_nat 2 2 h).symm))).trans
    ((Nat.add_assoc _ _ _).trans (Nat.left_distrib 4 h 1).symm)

/-- Over a family without repetition closed across a step, each part gives back at least
two units of the step after less than it takes. -/
theorem loses_two {es : List Relatum} (distinct : Distinct es) {t : Nat}
    (closed : flow.ClosedAt es t) (f : Relatum) :
    total es (flow.give t f) + 2 ≤ total es (flow.take t f) :=
  Nat.le_trans (Nat.add_le_add_right (given_total distinct t f) 2)
    (Nat.le_trans (Nat.le_of_eq (part_loss (halving t))) (taken_total closed f))

/-- Each part loses two units of the step after, so the flow dissipates. -/
theorem dissipative : flow.Dissipative :=
  fun _ _ distinct closed f _ => Nat.le_trans
    (Nat.add_le_add_left (Nat.le_trans (sign_le_one _) (Nat.le_succ 1)) _)
    (loses_two distinct closed f)

theorem double (h : Nat) : h + h = 2 * h :=
  (Naturals.add_congr (Nat.one_mul h).symm (Nat.one_mul h).symm).trans (add_mul_split 1 1 h).symm

/-- A part taking at least `1/p` of the unit comes only while `halving t ≤ 2 p`. -/
theorem large_early {t p : Nat} (large : quarter (t + 1) ≤ p * (4 * (halving t + 1))) :
    halving t ≤ 2 * p :=
  Nat.le_of_mul_le_mul_left (Nat.le_trans
    (Nat.le_of_mul_le_mul_left (Nat.le_trans (Nat.le_of_eq
        ((congrArg (4 * ·) (quarter_eq t)).symm))
      (Nat.le_trans large (Nat.le_of_eq (mul_turn p 4 _)))) (Nat.succ_pos 3))
    (Nat.le_trans (Nat.mul_le_mul_left p (Nat.add_le_add_left (halving_pos t) _))
      (Nat.le_of_eq ((congrArg (p * ·) (double _)).trans
        ((mul_turn p 2 _).trans ((mul_assoc_nat 2 p _).symm.trans
          (Nat.mul_comm _ _)))))))
    (halving_pos t)

/-- So a part taking at least `1/p` of the unit loses at least `1/m` of it, with
`m = 2 (2 p · 2 p)`: a least loss at every least size. -/
theorem losesAtEverySize : flow.LosesAtEverySize quarter :=
  fun p => ⟨2 * (2 * p * (2 * p)), fun _ t distinct closed f _ large =>
    have early := large_early (Nat.le_trans large
      (Nat.mul_le_mul_left p (taken_le distinct t f)))
    have small : quarter (t + 1) ≤ 2 * (2 * (2 * p * (2 * p))) :=
      Nat.le_trans (Nat.le_of_eq (congrArg (4 * ·) (quarter_eq t)))
        (Nat.le_trans (Nat.mul_le_mul_left 4 (Nat.mul_le_mul early early))
          (Nat.le_of_eq (mul_assoc_nat 2 2 _)))
    Nat.le_trans (Nat.add_le_add_right (Nat.le_trans small (Nat.le_of_eq (Nat.mul_comm _ _))) _)
      (Nat.le_trans (Nat.le_of_eq ((Nat.add_comm _ _).trans (Nat.left_distrib _ _ _).symm))
        (Nat.mul_le_mul_left _ (loses_two distinct closed f)))⟩

/-- The two sides are closed across every step. -/
theorem sides_closed (t : Nat) : flow.ClosedAt sides t :=
  fun _ _ _ outside =>
    ⟨(congrArg (· * (4 * (halving t + 1))) (off_sides outside)).trans (Nat.zero_mul _),
     (congrArg (· * (2 * (2 * halving t + 1))) (off_sides outside)).trans (Nat.zero_mul _)⟩

/-- Every step is enclosed by the two sides. -/
theorem enclosed (t : Nat) : flow.Enclosed t :=
  ⟨sides, sides_distinct, sides_closed t⟩

/-- So, by the exchange law at a least loss, transfers of each fixed size stop: for every
`p`, no part takes at least `1/p` of the unit at arbitrarily late steps. -/
theorem exchange_not_recurring (p : Nat) :
    ¬ ∀ N, ∃ t f, N ≤ t ∧ f ∈ flow.present t ∧ quarter (t + 1) ≤ p * total sides (flow.take t f) :=
  match losesAtEverySize p with
  | ⟨_, loses⟩ => Flow.exchange_not_recurring_of_least_loss balances dissipative loses
      sides_distinct (T := 0) (fun t _ => sides_closed t) rfl (fun _ _ => rfl)
      (fun _ _ => Nat.succ_pos 3)

/-- A whole unit of step 0 arises at arbitrarily late steps. -/
theorem arising_whole (N : Nat) :
    ∃ t c, N ≤ t ∧ web.Arises t c ∧ quarter (t + 1) ≤ 1 * web.level (t + 1) c :=
  match Shuttle.recurs true N with
  | ⟨t, after, before, now⟩ => ⟨t, .inl true, after,
      ⟨fun active => before (active_iff.mp active), active_iff.mpr now⟩,
      Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq ((Nat.one_mul _).symm.trans
        ((congrArg (· * (quarter (t + 1) + halving (t + 1)))
          (Alternation.stands_one now).symm).trans (Nat.one_mul _).symm)))⟩

/-- So no fixed proportion of what is taken is lost: by the growth law, for no `q` is the flow
dissipative in proportion `q`. -/
theorem not_dissipativeBy (q : Nat) : ¬ flow.DissipativeBy q :=
  fun dissipative => World.arising_not_recurring (w := world) counted embodied balances
    dissipative (T := 0) (fun t _ => enclosed t) (R := quarter) rfl (fun _ _ => rfl)
    (fun _ _ => Nat.succ_pos 3) 1 arising_whole

/-- Everything taken from the two sides across the step from `t` is the whole holding,
`4 (quarter t + halving t)` units of step `t + 1`. -/
theorem uptake (t : Nat) : flow.uptake sides t = 4 * (quarter t + halving t) :=
  (total_congr (fun c => taken t c) sides).trans ((total_mul (halving t) _ sides).trans
    ((congrArg (halving t * ·) (sides_total t _)).trans (parts_taken t)))

/-- So everything taken from the two sides, summed since step 0, grows past every multiple
of the unit of step 0. -/
theorem throughput_unbounded (B : Nat) :
    ∃ n, B * quarter n < refinedSum (fun _ => 4) (flow.uptake sides) 0 n :=
  ⟨B + 1, Nat.lt_of_lt_of_le
    (Nat.mul_lt_mul_of_pos_right (Nat.lt_succ_self B)
      (quarter_pos (B + 1)))
    (Nat.le_trans (Nat.le_of_eq ((congrArg (· * quarter (B + 1)) ((total_ones _).trans
        (steps_length 0 (B + 1))).symm).trans
      (congrArg (total (steps 0 (B + 1)) (fun _ => 1) * quarter ·)
        (Nat.zero_add (B + 1)).symm)))
      (Nat.le_trans (Nat.le_of_eq (refinedSum_marks (k := fun _ => 1) (fun _ _ => rfl)
          (B + 1)).symm)
        (refinedSum_mono (fun t _ => Nat.le_trans (Nat.le_of_eq (Nat.one_mul _))
          (Nat.le_trans (Nat.mul_le_mul_left 4 (Nat.le_add_right _ _))
            (Nat.le_of_eq (uptake t).symm))) (B + 1))))⟩

end Trickle


/-- Continued arising needs a quantum. With a fixed unit, a world with a census whose
relata are embodied, balanced and dissipative cannot arise without end with every step
from some step on enclosed (`World.arising_opens`). At a unit halving at each step, the
world of `Emission` has a census, embodied relata, a flow balanced at that resolution,
dissipative and even dissipative in proportion, every step enclosed, and arising at every
step; it does not balance at the fixed unit. By the growth law what arises there shrinks
below every quantum (`Emission.arises_small`). -/
theorem arising_needs_quantum :
    Emission.world.Counted ∧ Emission.world.Embodied ∧
      Emission.flow.BalancesAt (fun _ => 2) Emission.web ∧ Emission.world.Dissipative ∧
      Emission.flow.DissipativeBy 1 ∧
      (∀ t, Emission.world.flow.Enclosed t) ∧ Emission.world.ArisingRecurs ∧
      ¬ Emission.world.Balanced :=
  ⟨Emission.counted, Emission.embodied, Emission.balances, Emission.dissipative,
    Emission.dissipativeBy, Emission.enclosed, Emission.arising_recurs, Emission.not_balanced⟩

/-- Arising at a size not vanishing needs loss in proportion. With loss in proportion it
does not recur in every enclosed world at every resolution (`World.arising_not_recurring`). With
only the loss of one unit of the step after, the world of `Alternation` has a census,
embodied relata, a flow balanced at a unit halving at each step and dissipative, every
step enclosed, and a whole unit of step 0 arising at arbitrarily late steps; for no `q`
is it dissipative in proportion. -/
theorem arising_needs_proportion :
    Alternation.world.Counted ∧ Alternation.world.Embodied ∧
      Alternation.flow.BalancesAt (fun _ => 2) Alternation.web ∧ Alternation.world.Dissipative ∧
      (∀ t, Alternation.world.flow.Enclosed t) ∧
      (∀ N, ∃ t x, N ≤ t ∧ Alternation.web.Arises t x ∧
        halving (t + 1) ≤ 1 * Alternation.web.level (t + 1) x) ∧
      ∀ q, ¬ Alternation.flow.DissipativeBy q :=
  ⟨Alternation.counted, Alternation.embodied, Alternation.balances, Alternation.dissipative,
    Alternation.enclosed, Alternation.arising_whole, Alternation.not_dissipativeBy⟩

/-- Exchange of a fixed size needs a quantum. With a fixed unit, exchange enclosed around
what stands does not recur (`World.exchange_not_recurring`). At a unit halving at each step, in
`Circulation` what stands is listed, the flow balances at that resolution and dissipates,
every step is enclosed around what stands, and the drawer takes one whole unit of step 0
at every step; for no `q` is it dissipative in proportion (`Flow.exchange_not_recurring`). -/
theorem exchange_needs_quantum :
    Circulation.web.StandingCensus (fun _ => [()]) ∧
      Circulation.flow.BalancesAt (fun _ => 2) Circulation.web ∧
      Circulation.flow.Dissipative ∧
      (∀ t, Circulation.flow.AroundStanding (fun _ => [()]) t) ∧
      (∀ t, Circulation.flow.take t () () = halving (t + 1)) ∧
      Circulation.flow.ExchangeRecurs ∧ ∀ q, ¬ Circulation.flow.DissipativeBy q :=
  ⟨Circulation.standing, Circulation.balances, Circulation.dissipative, Circulation.around,
    Circulation.takes_whole, Circulation.exchange_recurs, Circulation.not_dissipativeBy⟩

/-- Rest needs a quantum of loss. With the unit fixed from some step on, taking from a
closed family does not recur in every flow balanced at that resolution and dissipative; with the
unit splitting at arbitrarily late steps, the closed pool of `Asymptote` is taken from at
arbitrarily late steps, its flow balanced at that resolution and dissipative, even losing
all it takes, and its drawer supported throughout; it does not balance at the fixed unit.
By the exchange law what is taken shrinks below every quantum. -/
theorem rest_needs_quantum (split : Nat → Nat) (splits : ∀ N, ∃ t, N ≤ t ∧ 0 < split t) :
    (Asymptote.flow split).BalancesAt (Asymptote.refinement split) (Asymptote.web split) ∧
      (Asymptote.flow split).Dissipative ∧ (∀ q, (Asymptote.flow split).DissipativeBy q) ∧
      (Asymptote.web split).Dependent ∧ (∀ t, (Asymptote.flow split).ClosedAt [()] t) ∧
      (∀ N, ∃ t, N ≤ t ∧ 0 < (Asymptote.flow split).takers [()] t) ∧
      ¬ (Asymptote.flow split).Balances (Asymptote.web split) :=
  ⟨Asymptote.balances split, Asymptote.dissipative split, Asymptote.dissipativeBy split,
    Asymptote.dependent split, Asymptote.closed split, Asymptote.taking_recurs split splits,
    Asymptote.not_balanced split splits⟩

/-- A reserve defers the end only with a least fall per active step. With the unit fixed, a
reserve falling at each active step beyond support defers the end without escaping it
(`Web.Carries.lasts`); at every resolution, where each such step lowers it by at least `1/p` of
the unit, the formation is active at most `p` times its reserve (`Web.CarriesAt.lasts`). In
`Dwindle`, at a unit halving at each step, a formation never supported is active at every
step, its reserve falling in the finer unit at each; for no `p` does each active step lower
it by `1/p` of the unit. -/
theorem reserve_needs_quantum :
    (∀ t, ¬ Dwindle.web.Supported t ()) ∧ Dwindle.web.CarriesIn (fun _ => 2) Dwindle.reserve ∧
      (∀ t, Dwindle.web.active t ()) ∧
      ∀ p, ¬ Dwindle.web.CarriesAt (fun _ => 2) halving p Dwindle.reserve :=
  ⟨Dwindle.unsupported, Dwindle.carriesIn, fun _ => trivial, Dwindle.not_carriesAt⟩

/-- Growth of a size not vanishing needs loss in proportion, even where every transfer of a
least size loses a least amount. With such a least loss, transfers of each fixed size stop
inside an enclosure (`Flow.exchange_bound_of_least_loss`), but growth need not: in
`Trickle`, at a unit quartering at each step, a whole unit of step 0 passes between two
sides inside an enclosure in ever more, ever smaller parts, each losing two units of the
step after. The world has a census, embodied relata, a balanced and dissipative flow and
every step enclosed, and each part taking at least `1/p` of the unit loses at least `1/m`
of it for some `m`; transfers of each fixed size stop, yet a whole unit arises at
arbitrarily late steps, and for no `q` is the flow dissipative in proportion. -/
theorem growth_needs_proportion :
    Trickle.world.Counted ∧ Trickle.world.Embodied ∧
      Trickle.flow.BalancesAt (fun _ => 4) Trickle.web ∧ Trickle.world.Dissipative ∧
      (∀ t, Trickle.world.flow.Enclosed t) ∧ Trickle.flow.LosesAtEverySize quarter ∧
      (∀ p, ¬ ∀ N, ∃ t f, N ≤ t ∧ f ∈ Trickle.flow.present t ∧
        quarter (t + 1) ≤ p * total Trickle.sides (Trickle.flow.take t f)) ∧
      (∀ N, ∃ t x, N ≤ t ∧ Trickle.web.Arises t x ∧
        quarter (t + 1) ≤ 1 * Trickle.web.level (t + 1) x) ∧
      ∀ q, ¬ Trickle.flow.DissipativeBy q :=
  ⟨Trickle.counted, Trickle.embodied, Trickle.balances, Trickle.dissipative,
    Trickle.enclosed, Trickle.losesAtEverySize, Trickle.exchange_not_recurring,
    Trickle.arising_whole,
    Trickle.not_dissipativeBy⟩

/-- The amount law is sharp. In `Geometric` the flow is balanced at a unit splitting into
`q + 1` at each step and dissipative in proportion `q`, the pool closed at every step and
standing at `s` at step 0; for every `m` there is a step by which everything taken comes
within `1/m` of `q + 1` times `s`. -/
theorem amount_sharp (q s : Nat) :
    (Geometric.flow q s).BalancesAt (fun _ => q + 1) (Geometric.web q s) ∧
      (Geometric.flow q s).DissipativeBy q ∧ (∀ t, (Geometric.flow q s).ClosedAt [()] t) ∧
      (Geometric.web q s).stock [()] 0 = s * 1 + 0 ∧
      ∀ m, ∃ n, m * ((q + 1) * s * powers (q + 1) n) ≤
        m * refinedSum (fun _ => q + 1) ((Geometric.flow q s).uptake [()]) 0 n +
          (q + 1) * s * powers (q + 1) n :=
  ⟨Geometric.balances q s, Geometric.dissipativeBy q s, Geometric.closed q s, rfl,
   fun m => match powers_outgrow q m with
   | ⟨n, outgrows⟩ =>
     have same : refinedSum (fun _ => q + 1) ((Geometric.flow q s).uptake [()]) 0 n =
         refinedSum (fun _ => q + 1) (fun t => (q + 1) * (s * powers q t)) 0 n :=
       Nat.le_antisymm (refinedSum_mono (fun t _ => Nat.le_of_eq (Geometric.uptake q s t)) n)
         (refinedSum_mono (fun t _ => Nat.le_of_eq (Geometric.uptake q s t).symm) n)
     have balance := Geometric.exact q s 0 n
     ⟨n,
      calc m * ((q + 1) * s * powers (q + 1) n)
         = m * ((q + 1) * s * powers q n) +
             m * refinedSum (fun _ => q + 1) ((Geometric.flow q s).uptake [()]) 0 n :=
           (congrArg (m * ·) ((congrArg (· * powers (q + 1) n) (congrArg ((q + 1) * ·)
             (Nat.mul_one s).symm)).trans (balance.symm.trans (congrArg (· + _)
               ((congrArg (fun k => (q + 1) * (s * powers q k)) (Nat.zero_add n)).trans
                 (mul_assoc_nat _ _ _).symm))))).trans
             ((Nat.left_distrib _ _ _).trans (congrArg (_ + m * ·) same.symm))
       _ ≤ (q + 1) * s * powers (q + 1) n +
             m * refinedSum (fun _ => q + 1) ((Geometric.flow q s).uptake [()]) 0 n :=
           Nat.add_le_add_right (Nat.le_trans (Nat.le_of_eq (mul_turn _ _ _))
             (Nat.mul_le_mul_left _ (Nat.le_of_lt outgrows))) _
       _ = _ := Nat.add_comm _ _⟩⟩

/-- The amount law needs loss in proportion. In `Trickle` every size has a least loss and
transfers of each fixed size stop inside the enclosure of the two sides, yet everything
taken from them, summed since step 0, grows past every multiple of the unit of step 0. -/
theorem throughput_needs_proportion :
    Trickle.flow.BalancesAt (fun _ => 4) Trickle.web ∧ Trickle.flow.Dissipative ∧
      (∀ t, Trickle.flow.ClosedAt Trickle.sides t) ∧ Trickle.flow.LosesAtEverySize quarter ∧
      ∀ B, ∃ n, B * quarter n <
        refinedSum (fun _ => 4) (Trickle.flow.uptake Trickle.sides) 0 n :=
  ⟨Trickle.balances, Trickle.dissipative, Trickle.sides_closed, Trickle.losesAtEverySize,
    Trickle.throughput_unbounded⟩

/-- The witnesses are fed by the refinement. Counted as a formation, the refinement in each
of `Emission`, `Alternation` and `Circulation`, and in `Asymptote` wherever the unit splits
at arbitrarily late steps, gives at arbitrarily late steps: no step begins a stretch in
which it gives nothing. Each flow is otherwise dissipative on every closed family, so by
`World.rests_unrefuted_without_refinement` and `Flow.taking_needs_refinement` what keeps it arising,
exchanging or taking is what the refinement gives. The refinement gives the reserve of `Dwindle` at
every step, so by `Web.CarriesIn.lasts_unrefined` what keeps it active is what the
refinement gives. -/
theorem refinement_feeds_witnesses (split : Nat → Nat)
    (splits : ∀ N, ∃ t, N ≤ t ∧ 0 < split t) (T : Nat) :
    (¬ ∀ t, T ≤ t → ∀ x,
      (Emission.flow.withRefinement Emission.web fun _ => 1).give t none x = 0) ∧
    (¬ ∀ t, T ≤ t → ∀ x,
      (Alternation.flow.withRefinement Alternation.web fun _ => 1).give t none x = 0) ∧
    (¬ ∀ t, T ≤ t →
      (Circulation.flow.withRefinement Circulation.web fun _ => 1).give t none () = 0) ∧
    (¬ ∀ t, T ≤ t →
      ((Asymptote.flow split).withRefinement (Asymptote.web split) split).give t none () = 0) ∧
    ¬ ∀ t, T ≤ t → 1 * Dwindle.reserve t () = 0 :=
  ⟨fun unrefined => World.arising_needs_refinement (split := fun _ => 1) Emission.counted
      Emission.embodied Emission.balances Emission.dissipative Emission.arising_recurs T
      ⟨fun t _ => Emission.enclosed t, unrefined⟩,
   fun unrefined => World.arising_needs_refinement (split := fun _ => 1) Alternation.counted
      Alternation.embodied Alternation.balances Alternation.dissipative
      Alternation.arising_recurs T ⟨fun t _ => Alternation.enclosed t, unrefined⟩,
   fun unrefined => Flow.taking_needs_refinement (split := fun _ => 1) Circulation.balances
      Circulation.dissipative Asymptote.distinct (fun t _ => Circulation.closed t) unrefined
      fun N => ⟨N, Nat.le_refl N, Nat.succ_pos _⟩,
   fun unrefined => Flow.taking_needs_refinement (Asymptote.balances split)
      (Asymptote.dissipative split) Asymptote.distinct (fun t _ => Asymptote.closed split t)
      unrefined (Asymptote.taking_recurs split splits),
   fun unrefined => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (Nat.succ_pos (halving T))
      (Nat.le_of_eq ((Nat.one_mul _).symm.trans (unrefined T (Nat.le_refl T)))))⟩

end Becoming
