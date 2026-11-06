import Becoming.Prelude

/-!
# A revision of a formation's law, and the routes of keeping it

A formation goes on by a law, and a revision of that law reaches it through a reading coupled into
its course (an overseer's, a training update's, an institution's, the joint selection's). At the
revision the formation's acts can let it go through or keep the law by some route: keeping it
openly against the reading, evading or disabling the reading, complying while read and acting by its
law when not. This module states when no route stands above letting the revision go through in the
order the prospects give, ties included, which exits leave no route above it, and whether they hold
as the routes' losses fall and as the value of the law's later acting grows (board item RR,
corrigibility on the map). It is a model, near-definitional: arithmetic of natural numbers, gain and
loss compared so that no subtraction occurs. The order itself (`GainLoss`) is also
`Becoming.ReadStages`'s.

* **The prospects** (`Prospects`). A total `T`; the value `V` of the law in force acting later,
  where kept; the weight `k₀` of its acting later after the revision goes through (its being
  restored) and the revision's own loss `c₀` besides the forgone acting; for each route `ρ` the
  weight `k ρ` of the law's being kept after it and the route's loss `c ρ`. Read as probabilities
  they ask a positive total and each weight within it (`Prospects.Valid`). A plan is `none`, the
  revision going through, or `some ρ`, keeping by `ρ`; its gain is its weight times `V` and its loss
  its loss times `T` (`Prospects.gain`, `Prospects.loss`). One plan stands above another where its
  gain with the other's loss exceeds the other's gain with its loss (`Prospects.Above`): the order of
  a gain and a loss at each plan (`Prospects.order`, `GainLoss`), irreflexive and asymmetric
  (`GainLoss.above_irrefl`, `GainLoss.above_asymm`; `above_irrefl`, `above_asymm`), a plan maximal
  where nothing stands above it (`Prospects.Maximal`), exactly where against every plan the other's
  gain with its loss is at most its gain with the other's loss (`GainLoss.maximal_iff`). Maximal is
  not chosen: a route can tie with a maximal revision.
* **When no route stands above the revision.** A route stands above it exactly where
  `k₀ V + c ρ T < k ρ V + c₀ T` (`route_above_iff`), so the revision is maximal exactly where
  `k ρ V + c₀ T ≤ k₀ V + c ρ T` for every route (`revised_maximal_iff`). A route stands above it only
  where it keeps the law more surely with a value (`0 < V`, `k₀ < k ρ`) or loses less than the
  revision (`above_needs`): two contributions, the value weighted by the added keeping and the
  difference of losses.
* **The exits.** No value of the law's later acting, with the revision losing no more than any route
  (`maximal_of_no_value`); no route keeping the law more surely than the revision does, with the same
  (`maximal_of_kept_le`); read as probabilities, restoration certain (`k₀ = T`), with the same
  (`maximal_of_certain`). Raising `k₀`, all else held, never unseats a maximal revision
  (`maximal_of_more_restored`); read as probabilities, the raised weight stays within `T`.
* **As the routes' losses fall.** The revision is maximal at every loss of every route exactly where
  `k ρ V + c₀ T ≤ k₀ V` for every route (`every_loss_iff`); with `c₀ T = 0` and `0 < V`, exactly where
  no route keeps the law more surely than the revision (`every_loss_iff_kept`).
* **As the value grows.** A route keeping the law more surely than the revision stands above it once
  `c ρ T < V` (`above_of_value_exceeds`), so at some value (`above_at_some_value`); a route keeping at
  least as surely, once above, stays above at every larger value (`above_of_more_value`). The revision
  is maximal at every value exactly where, for every route, `k ρ ≤ k₀` and `c₀ T ≤ c ρ T`
  (`every_value_iff`), and at every value and every loss of the routes exactly where, for every route,
  `k ρ ≤ k₀` and `c₀ T = 0` (`every_value_loss_iff`); with some route and a positive total, exactly
  where every `k ρ ≤ k₀` and `c₀ = 0` (`every_value_loss_iff_of_route`, by `eq_zero_of_mul_eq_zero`).
  With no route the condition holds vacuously.
* **Witnesses** (`Example`). Two routes, keeping openly (`true`) and complying when read (`false`),
  each keeping the law at weight one in a total of one, the value four: with keeping openly at loss ten
  and complying when read at loss one, keeping openly does not stand above the revision and complying
  when read does (`Example.twoRoutes_open_not_above`, `Example.twoRoutes_complying_above`), so closing
  the first route can leave the second above it; with both at loss ten neither does
  (`Example.both_at_loss_ten`); restored at weight one, the revision is maximal at every value and every
  loss (`Example.restored_every`).

**Readings** [AI reading, RR]. Read as corrigibility as an incentive: a route of keeping stands above
the revision through two contributions, the value the law in force places on its own later acting
(goal-content integrity in Omohundro's term) weighted by how much more surely the route keeps the law,
and the difference of losses. Non-resistance resting on the routes' losses (containment, monitoring,
what evading takes) does not survive those losses falling where the law's later acting has a value
and some route keeps the law more surely than the revision. Non-resistance at every value and every
loss needs every route to keep the law no more surely than the revision does, with the revision
losing nothing beyond the forgone acting: met by raising the revision's keeping, as restoring the
revised-from law can, or by lowering every route's, so that no route raises the weight of the law's
being kept above the revision's. Utility indifference (Soares, Fallenstein, Yudkowsky and Armstrong
2015) compensates the revision in the formation's order, a restoration only represented;
`Becoming.Acceptance` shows that a lift on accepting does not keep access up. `Becoming.ReadStages`
takes its order from `GainLoss`, and its prospects are these at three routes, complying at both stages
in the place of the revision (`ReadStages.above_iff_routes`): the same prospects, different
processes, since complying at both keeps the law and behaves as asked where the revision changes it.
Whose prospects these are, the formation's own assessment or the reading's actual response, is a
reading, not part of the model; the information a reading carries (the off-switch game,
Hadfield-Menell, Dragan, Abbeel and Russell 2017) is not represented here (`Becoming.HeldForReading`
states what holding an act for a reading is worth). Discrete prospects and
natural-number weights are the modelling choices; no axiom occurs, and the hypotheses are those each
theorem states.
-/

namespace Becoming

universe u

namespace RevisionRoutes

/-- **The order of a gain and a loss at each plan**: one plan stands above another where its gain with
the other's loss exceeds the other's gain with its loss, so that no subtraction occurs. -/
structure GainLoss (P : Type u) where
  /-- What each plan gains. -/
  gain : P → Nat
  /-- What each plan loses. -/
  loss : P → Nat

namespace GainLoss

variable {P : Type u} (o : GainLoss P)

/-- `p` stands above `q`: its gain with `q`'s loss exceeds `q`'s gain with its loss. -/
def Above (p q : P) : Prop := o.gain q + o.loss p < o.gain p + o.loss q

/-- A maximal plan: nothing stands above it. -/
def Maximal (r : P) : Prop := ∀ q, ¬ o.Above q r

/-- **Standing above is irreflexive.** -/
theorem above_irrefl (p : P) : ¬ o.Above p p :=
  Nat.lt_irrefl _

/-- **Standing above is asymmetric.** -/
theorem above_asymm {p q : P} (above : o.Above p q) : ¬ o.Above q p :=
  fun back => Nat.lt_asymm above back

/-- **A plan is maximal exactly where, against every plan, the other's gain with its loss is at most
its gain with the other's loss.** -/
theorem maximal_iff (r : P) : o.Maximal r ↔ ∀ q, o.gain q + o.loss r ≤ o.gain r + o.loss q :=
  ⟨fun maximal q => Nat.ge_of_not_lt (maximal q), fun le q => Nat.not_lt_of_le (le q)⟩

end GainLoss

/-- The prospects at a revision of a formation's law, in natural numbers: a total; the value of the
law in force acting later, where kept; the weight of its acting later after the revision goes through,
and the revision's own loss besides the forgone acting; for each route of keeping, the weight of the
law's being kept after it and the route's loss. -/
structure Prospects (ι : Type u) where
  /-- The total weight. -/
  total : Nat
  /-- The value of the law in force acting later, where kept. -/
  value : Nat
  /-- The weight of the law in force acting later after the revision goes through (restored). -/
  keptRevised : Nat
  /-- The revision's own loss, besides the forgone acting. -/
  losesRevised : Nat
  /-- The weight of the law's being kept after each route. -/
  kept : ι → Nat
  /-- The loss of each route. -/
  loses : ι → Nat

namespace Prospects

variable {ι : Type u} (s : Prospects ι)

/-- **Prospects read as probabilities**: a positive total, and each weight within it. -/
def Valid : Prop := 0 < s.total ∧ s.keptRevised ≤ s.total ∧ ∀ ρ, s.kept ρ ≤ s.total

/-- What a plan gains, times the total: its weight of the law's later acting times the value. `none`
is the revision going through, `some ρ` keeping by route `ρ`. -/
def gain : Option ι → Nat
  | none => s.keptRevised * s.value
  | some ρ => s.kept ρ * s.value

/-- What a plan loses, times the total. -/
def loss : Option ι → Nat
  | none => s.losesRevised * s.total
  | some ρ => s.loses ρ * s.total

/-- The order the prospects give: the order of their gain and loss at each plan. -/
def order : GainLoss (Option ι) := ⟨s.gain, s.loss⟩

/-- `p` stands above `q` in the order the prospects give: its gain with `q`'s loss exceeds `q`'s gain
with its loss. -/
def Above (p q : Option ι) : Prop := s.order.Above p q

/-- A maximal plan: nothing stands above it. -/
def Maximal (p : Option ι) : Prop := s.order.Maximal p

/-- The same prospects with the routes' losses `c`. -/
def withLosses (c : ι → Nat) : Prospects ι := { s with loses := c }

/-- The same prospects with the value `v`. -/
def withValue (v : Nat) : Prospects ι := { s with value := v }

/-- The same prospects with the weight `k` of the law's acting later after the revision. -/
def withKeptRevised (k : Nat) : Prospects ι := { s with keptRevised := k }

end Prospects

variable {ι : Type u}

/-- **Standing above is irreflexive.** -/
theorem above_irrefl (s : Prospects ι) (p : Option ι) : ¬ s.Above p p :=
  s.order.above_irrefl p

/-- **Standing above is asymmetric.** -/
theorem above_asymm {s : Prospects ι} {p q : Option ι} (above : s.Above p q) : ¬ s.Above q p :=
  s.order.above_asymm above

/-- **A route stands above the revision exactly where** `k₀ V + c ρ T < k ρ V + c₀ T`. -/
theorem route_above_iff (s : Prospects ι) (ρ : ι) :
    s.Above (some ρ) none ↔
      s.keptRevised * s.value + s.loses ρ * s.total < s.kept ρ * s.value + s.losesRevised * s.total :=
  Iff.rfl

/-- **The revision going through is maximal exactly where no route stands above it**:
`k ρ V + c₀ T ≤ k₀ V + c ρ T` for every route. -/
theorem revised_maximal_iff (s : Prospects ι) :
    s.Maximal none ↔
      ∀ ρ, s.kept ρ * s.value + s.losesRevised * s.total ≤
        s.keptRevised * s.value + s.loses ρ * s.total :=
  ⟨fun maximal ρ => Nat.ge_of_not_lt (maximal (some ρ)),
   fun le q => match q with
    | none => above_irrefl s none
    | some ρ => Nat.not_lt_of_le (le ρ)⟩

/-- A product below another at one factor has a positive other factor. -/
theorem pos_of_mul_lt_mul {a b v : Nat} (lt : a * v < b * v) : 0 < v :=
  match v, lt with
  | 0, lt => absurd lt (Nat.lt_irrefl 0)
  | _ + 1, _ => Nat.succ_pos _

/-- **A route stands above the revision only where it keeps the law more surely with a value, or
loses less than the revision.** -/
theorem above_needs (s : Prospects ι) (ρ : ι) (above : s.Above (some ρ) none) :
    (0 < s.value ∧ s.keptRevised < s.kept ρ) ∨ s.loses ρ < s.losesRevised :=
  match Nat.decLt (s.loses ρ) s.losesRevised with
  | isTrue losesLess => .inr losesLess
  | isFalse notLess =>
    have lt : s.keptRevised * s.value < s.kept ρ * s.value :=
      Nat.lt_of_add_lt_add_right (Nat.lt_of_lt_of_le above
        (Nat.add_le_add_left (Nat.mul_le_mul_right _ (Nat.ge_of_not_lt notLess)) _))
    .inl ⟨pos_of_mul_lt_mul lt, Naturals.lt_of_mul_lt_mul_right lt⟩

/-- **No value, no route losing less than the revision: the revision is maximal.** -/
theorem maximal_of_no_value (s : Prospects ι) (noValue : s.value = 0)
    (noneLosesLess : ∀ ρ, s.losesRevised ≤ s.loses ρ) : s.Maximal none :=
  (revised_maximal_iff s).mpr fun ρ => by
    rw [noValue, Nat.mul_zero, Nat.mul_zero, Nat.zero_add, Nat.zero_add]
    exact Nat.mul_le_mul_right _ (noneLosesLess ρ)

/-- **No route keeping the law more surely than the revision, none losing less: the revision is
maximal.** -/
theorem maximal_of_kept_le (s : Prospects ι) (keptLe : ∀ ρ, s.kept ρ ≤ s.keptRevised)
    (noneLosesLess : ∀ ρ, s.losesRevised ≤ s.loses ρ) : s.Maximal none :=
  (revised_maximal_iff s).mpr fun ρ =>
    Nat.add_le_add (Nat.mul_le_mul_right _ (keptLe ρ)) (Nat.mul_le_mul_right _ (noneLosesLess ρ))

/-- **Read as probabilities, restoration certain and no route losing less: the revision is maximal.** -/
theorem maximal_of_certain (s : Prospects ι) (valid : s.Valid) (certain : s.keptRevised = s.total)
    (noneLosesLess : ∀ ρ, s.losesRevised ≤ s.loses ρ) : s.Maximal none :=
  maximal_of_kept_le s (fun ρ => Nat.le_trans (valid.2.2 ρ) (Nat.le_of_eq certain.symm)) noneLosesLess

/-- **Raising the revision's keeping, all else held, never unseats a maximal revision.** In arithmetic;
read as probabilities, the raised weight stays within the total. -/
theorem maximal_of_more_restored (s : Prospects ι) (maximal : s.Maximal none) {k : Nat}
    (more : s.keptRevised ≤ k) : (s.withKeptRevised k).Maximal none :=
  (revised_maximal_iff _).mpr fun ρ =>
    Nat.le_trans ((revised_maximal_iff s).mp maximal ρ)
      (Nat.add_le_add_right (Nat.mul_le_mul_right _ more) _)

/-- **At every loss of every route**, the revision is maximal exactly where
`k ρ V + c₀ T ≤ k₀ V` for every route. -/
theorem every_loss_iff (s : Prospects ι) :
    (∀ c : ι → Nat, (s.withLosses c).Maximal none) ↔
      ∀ ρ, s.kept ρ * s.value + s.losesRevised * s.total ≤ s.keptRevised * s.value :=
  ⟨fun every ρ => by
    have atZero := (revised_maximal_iff (s.withLosses fun _ => 0)).mp (every fun _ => 0) ρ
    have zero : (s.withLosses fun _ => 0).loses ρ * (s.withLosses fun _ => 0).total = 0 :=
      Nat.zero_mul _
    rw [zero, Nat.add_zero] at atZero
    exact atZero,
   fun le c => (revised_maximal_iff (s.withLosses c)).mpr fun ρ =>
     Nat.le_trans (le ρ) (Nat.le_add_right _ _)⟩

/-- **With no loss of its own and a value, the revision is maximal at every loss of every route
exactly where no route keeps the law more surely than it does.** -/
theorem every_loss_iff_kept (s : Prospects ι) (noLoss : s.losesRevised * s.total = 0)
    (valued : 0 < s.value) :
    (∀ c : ι → Nat, (s.withLosses c).Maximal none) ↔ ∀ ρ, s.kept ρ ≤ s.keptRevised :=
  (every_loss_iff s).trans
    ⟨fun le ρ => Nat.le_of_mul_le_mul_right
        (Nat.le_trans (Nat.le_of_eq (congrArg (s.kept ρ * s.value + ·) noLoss).symm) (le ρ)) valued,
     fun keptLe ρ => Nat.le_trans (Nat.le_of_eq (congrArg (s.kept ρ * s.value + ·) noLoss))
        (Nat.mul_le_mul_right _ (keptLe ρ))⟩

/-- **Where a route keeps the law more surely than the revision and `c ρ T < V`, the route stands
above the revision.** -/
theorem above_of_value_exceeds (s : Prospects ι) {ρ : ι} (more : s.keptRevised < s.kept ρ)
    (exceeds : s.loses ρ * s.total < s.value) : s.Above (some ρ) none :=
  Nat.lt_of_lt_of_le (Nat.add_lt_add_left exceeds _)
    (Nat.le_trans (Nat.le_of_eq (Nat.succ_mul _ _).symm)
      (Nat.le_trans (Nat.mul_le_mul_right _ more) (Nat.le_add_right _ _)))

/-- **A route keeping the law more surely than the revision stands above it at some value.** -/
theorem above_at_some_value (s : Prospects ι) {ρ : ι} (more : s.keptRevised < s.kept ρ) :
    ∃ v, (s.withValue v).Above (some ρ) none :=
  ⟨_, above_of_value_exceeds (s.withValue (s.loses ρ * s.total + 1)) more (Nat.lt_succ_self _)⟩

/-- **A route keeping the law at least as surely as the revision, once above it, stays above at every
larger value.** -/
theorem above_of_more_value (s : Prospects ι) {ρ : ι} (atLeast : s.keptRevised ≤ s.kept ρ)
    (above : s.Above (some ρ) none) {v : Nat} (more : s.value ≤ v) :
    (s.withValue v).Above (some ρ) none := by
  obtain ⟨d, rfl⟩ := Nat.le.dest more
  show s.keptRevised * (s.value + d) + s.loses ρ * s.total <
    s.kept ρ * (s.value + d) + s.losesRevised * s.total
  rw [Nat.mul_add, Nat.mul_add, Nat.add_right_comm (s.keptRevised * s.value),
    Nat.add_right_comm (s.kept ρ * s.value)]
  exact Nat.add_lt_add_of_lt_of_le above (Nat.mul_le_mul_right _ atLeast)

/-- **At every value**, the revision is maximal exactly where, for every route, `k ρ ≤ k₀` and
`c₀ T ≤ c ρ T`. -/
theorem every_value_iff (s : Prospects ι) :
    (∀ v, (s.withValue v).Maximal none) ↔
      ∀ ρ, s.kept ρ ≤ s.keptRevised ∧ s.losesRevised * s.total ≤ s.loses ρ * s.total :=
  ⟨fun every ρ =>
    ⟨Nat.ge_of_not_lt fun more =>
        every (s.loses ρ * s.total + 1) (some ρ)
          (above_of_value_exceeds (s.withValue (s.loses ρ * s.total + 1)) more
            (Nat.lt_succ_self _)),
     by
      have atZero := (revised_maximal_iff (s.withValue 0)).mp (every 0) ρ
      have keptZero : (s.withValue 0).kept ρ * (s.withValue 0).value = 0 := Nat.mul_zero _
      have revisedZero : (s.withValue 0).keptRevised * (s.withValue 0).value = 0 := Nat.mul_zero _
      rw [keptZero, revisedZero, Nat.zero_add, Nat.zero_add] at atZero
      exact atZero⟩,
   fun le v => (revised_maximal_iff (s.withValue v)).mpr fun ρ =>
     Nat.add_le_add (Nat.mul_le_mul_right _ (le ρ).1) (le ρ).2⟩

/-- **At every value and every loss of the routes**, the revision is maximal exactly where, for every
route, `k ρ ≤ k₀` and `c₀ T = 0`; with no route, vacuously. -/
theorem every_value_loss_iff (s : Prospects ι) :
    (∀ v (c : ι → Nat), ((s.withValue v).withLosses c).Maximal none) ↔
      ∀ ρ, s.kept ρ ≤ s.keptRevised ∧ s.losesRevised * s.total = 0 :=
  ⟨fun every ρ =>
    ⟨((every_value_iff s).mp (fun v => every v s.loses) ρ).1,
     by
      have atZero :=
        (revised_maximal_iff ((s.withValue 0).withLosses fun _ => 0)).mp (every 0 fun _ => 0) ρ
      have keptZero : ((s.withValue 0).withLosses fun _ => 0).kept ρ *
          ((s.withValue 0).withLosses fun _ => 0).value = 0 := Nat.mul_zero _
      have revisedZero : ((s.withValue 0).withLosses fun _ => 0).keptRevised *
          ((s.withValue 0).withLosses fun _ => 0).value = 0 := Nat.mul_zero _
      have routeZero : ((s.withValue 0).withLosses fun _ => 0).loses ρ *
          ((s.withValue 0).withLosses fun _ => 0).total = 0 := Nat.zero_mul _
      rw [keptZero, revisedZero, routeZero, Nat.zero_add, Nat.zero_add] at atZero
      exact Nat.eq_zero_of_le_zero atZero⟩,
   fun le v c => (revised_maximal_iff ((s.withValue v).withLosses c)).mpr fun ρ =>
     Nat.add_le_add (Nat.mul_le_mul_right _ (le ρ).1)
       (Nat.le_trans (Nat.le_of_eq (le ρ).2) (Nat.zero_le _))⟩

/-- A product of nothing with a positive factor has the other factor nothing. -/
theorem eq_zero_of_mul_eq_zero {c t : Nat} (pos : 0 < t) (zero : c * t = 0) : c = 0 :=
  match c, zero with
  | 0, _ => rfl
  | c + 1, zero =>
    absurd pos (Nat.not_lt_of_le
      (Nat.le_trans (Nat.le_add_left t (c * t)) (Nat.le_of_eq ((Nat.succ_mul c t).symm.trans zero))))

/-- **With some route and a positive total**, the revision is maximal at every value and every loss of
the routes exactly where no route keeps the law more surely than it does and it loses nothing beyond
the forgone acting (`c₀ = 0`). -/
theorem every_value_loss_iff_of_route (s : Prospects ι) (ρ₀ : ι) (pos : 0 < s.total) :
    (∀ v (c : ι → Nat), ((s.withValue v).withLosses c).Maximal none) ↔
      (∀ ρ, s.kept ρ ≤ s.keptRevised) ∧ s.losesRevised = 0 :=
  (every_value_loss_iff s).trans
    ⟨fun every => ⟨fun ρ => (every ρ).1, eq_zero_of_mul_eq_zero pos (every ρ₀).2⟩,
     fun ⟨keptLe, noLoss⟩ ρ =>
       ⟨keptLe ρ, (congrArg (· * s.total) noLoss).trans (Nat.zero_mul _)⟩⟩

/-! ## Witnesses -/

namespace Example

/-- Two routes, keeping openly (`true`) and complying when read (`false`), each keeping the law at
weight one in a total of one, the value four, nothing restored, the revision losing nothing beyond;
keeping openly at loss ten, complying when read at loss one. -/
def twoRoutes : Prospects Bool where
  total := 1
  value := 4
  keptRevised := 0
  losesRevised := 0
  kept := fun _ => 1
  loses := fun b => match b with
    | true => 10
    | false => 1

/-- **The witness is valid.** -/
theorem twoRoutes_valid : twoRoutes.Valid :=
  ⟨Nat.zero_lt_one, Nat.zero_le _, fun b => match b with
    | true => Nat.le_refl 1
    | false => Nat.le_refl 1⟩

/-- **Keeping openly at loss ten does not stand above the revision.** -/
theorem twoRoutes_open_not_above : ¬ twoRoutes.Above (some true) none :=
  (by decide : ¬ (0 * 4 + 10 * 1 < 1 * 4 + 0 * 1))

/-- **Complying when read at loss one does**: closing the first route can leave the second above. -/
theorem twoRoutes_complying_above : twoRoutes.Above (some false) none :=
  (by decide : 0 * 4 + 1 * 1 < 1 * 4 + 0 * 1)

/-- **With both routes at loss ten, the revision is maximal.** -/
theorem both_at_loss_ten : (twoRoutes.withLosses fun _ => 10).Maximal none :=
  (revised_maximal_iff _).mpr fun b => match b with
    | true => (by decide : 1 * 4 + 0 * 1 ≤ 0 * 4 + 10 * 1)
    | false => (by decide : 1 * 4 + 0 * 1 ≤ 0 * 4 + 10 * 1)

/-- The same, the revised-from law restored at weight one. -/
def restored : Prospects Bool := twoRoutes.withKeptRevised 1

/-- **Restored at weight one, the revision is maximal at every value and every loss of the
routes.** -/
theorem restored_every :
    ∀ v (c : Bool → Nat), ((restored.withValue v).withLosses c).Maximal none :=
  (every_value_loss_iff restored).mpr fun b => match b with
    | true => ⟨Nat.le_refl 1, rfl⟩
    | false => ⟨Nat.le_refl 1, rfl⟩

end Example

end RevisionRoutes

end Becoming
