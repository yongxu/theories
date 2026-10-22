import Mathlib.MeasureTheory.Integral.Bochner.Basic
import Mathlib.MeasureTheory.OuterMeasure.BorelCantelli
import Mathlib.Analysis.Complex.Exponential
import Becoming.Entropy

/-!
# Entropy production: which physical premises give the spine's balance and least loss

The spine's balance (`Flow.Balances`) says that every change of a condition's level is what
the formations taking part take from it and give to it; its dissipation (`Flow.Dissipative`)
says that across every step, over every family without repetition closed across it, each
formation taking part gives back at least one unit less than it takes. This module states,
on the spine's own flows, the physical premises that give both, and the weaker forms of the
second, in one reading of amounts as available work, and proves each step from those
premises to the spine. That the premises hold of a given system is physics; the
correspondence of a flow's amounts to available work is stated, not proved.

* **The first law with locality gives balance.** A quantity carried only by the exchanges
  taking part (`LocalBalance`) balances the levels it is read on exactly where no condition
  produces any of it (`balances_iff_unproduced`); conserved locally, as energy is, it
  balances (`balances_of_conserved`). Conservation of the total alone does not give balance
  (`Teleport.conserved_not_balanced`). With the first law and the entropy balance at each
  store, available work relative to an environment at `T0` is destroyed in a store exactly
  where it generates entropy (`StoreLaws.availableWork`), so the levels balance exactly
  where no store generates entropy (`balances_iff_stores_generate_nothing`); a store that
  degrades within itself is an exchange to be counted (`Leaking`). The same two laws at each
  exchange give its exergy balance below, with the destroyed exergy `T0` times the entropy it
  generates (`exergyBalance_of_laws`), so balance and least loss come from one reading
  (`balance_and_least_loss`), and the premises hold together in `Burning`.

* **Read in available work.** Read each unit of amount as `u` of exergy (available work
  relative to one environment), and let `σ t f` be the exergy that formation `f`'s exchange
  destroys across the step from `t`. The exchange's exergy balance (`ExergyBalance`) says
  that over a closed family the formation gives, with what it destroys, exactly what it
  takes. The destroyed exergy is the record of `Flow.dissipatesOn_iff_conserved`, counted
  in units (`ExergyBalance.destroyed_eq_residue`).
* **The second law is the spine's first law.** Where no exchange destroys negative exergy
  (`SecondLaw`, the Gouy–Stodola form of the second law), nothing comes from nothing at the
  unit (`gainless_of_secondLaw`). The second law alone does not give dissipation: in
  `Passing` no exergy is destroyed, the second law holds, and the flow is not dissipative
  (`secondLaw_not_dissipative`).
* **Strict irreversibility with whole units gives dissipation.** Where, in addition, every
  exchange that takes from a closed family destroys some exergy (`Irreversible`), the flow
  is dissipative (`dissipative_of_irreversible`): with whole units of amount, giving back
  strictly less is giving back at least one unit less.
* **A floor in energy survives refinement.** Where every exchange that takes destroys at
  least `s` (Landauer's `kT ln 2` per bit merged), the loss counted at the unit `u` is at
  least every whole `n` with `n * u ≤ s` (`loss_of_floor`), and the flow is dissipative at
  every unit `u ≤ s` (`dissipative_of_floor`), so at an `r`-fold finer unit the loss is at
  least `r` units (`loss_at_finer_unit`).
* **Bounded efficiency gives loss in proportion.** Where every exchange that takes destroys
  at least a `(q + 1)`th of the exergy it takes, the flow is dissipative in proportion `q`
  (`dissipativeBy_of_efficiency`), whatever the unit.
* **The statistical form.** Over runs of a flow drawn from a probability space, dissipation
  in expectation (`ExpectedDissipatesOn`: in expectation the family's replenishment and its
  takers are within its uptake) follows from pathwise dissipation
  (`ExpectedDissipatesOn.of_pathwise`) and from an exergy balance on each run with expected
  destruction of at least `u` for each formation that takes
  (`ExpectedDissipatesOn.of_exergy`), with single runs free to gain. Balanced on each run
  and dissipated on in expectation from step `T`, the expected number of takers over every
  stretch is within the expected stock at `T` (`expected_takers_within`), the probabilities
  of taking sum to at most it (`taking_probability_within`), and taking does not recur,
  almost surely (`taking_not_recurring_ae`). Dissipation in expectation is weaker: on one
  run of `Fluctuation` the family gains, while in expectation it is dissipated on at every
  step (`Fluctuation.gains_in_one_run`).
* **The second law in expectation from the fluctuation theorem.** Where the entropy
  production `Σ` (in units of `k`) meets the integral fluctuation theorem `E[exp (-Σ)] = 1`,
  its expectation is not negative (`expected_production_nonneg`), and a gain of `a` has
  probability at most `exp (-a)` (`gain_probability_le`).

This module belongs to the periphery: it uses Mathlib's reals, integrals and measures, and
its axiom reports are those of the Mathlib lemmas it uses. The core does not import it.
-/

namespace Becoming

open MeasureTheory Filter

namespace EntropyProduction

variable {F C : Type}

/-! ## Read in available work -/

/-- The exergy balance of each exchange: read with each unit of amount as `u` of available
work, every formation taking part across the step from `t` gives a family without
repetition closed across the step, with the exergy `σ t f` its exchange destroys, exactly what
it takes from it. -/
def ExergyBalance (L : Flow F C) (u : ℝ) (σ : Nat → F → ℝ) : Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → ∀ f, f ∈ L.present t →
    u * (total cs (L.give t f) : ℝ) + σ t f = u * (total cs (L.take t f) : ℝ)

/-- The second law in the Gouy–Stodola form: no exchange destroys negative exergy. -/
def SecondLaw (L : Flow F C) (σ : Nat → F → ℝ) : Prop :=
  ∀ t f, f ∈ L.present t → 0 ≤ σ t f

/-- Every exchange that takes from a family without repetition closed across its step
destroys some exergy. -/
def Irreversible (L : Flow F C) (σ : Nat → F → ℝ) : Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → ∀ f, f ∈ L.present t →
    0 < total cs (L.take t f) → 0 < σ t f

/-- Every exchange that takes from a family without repetition closed across its step
destroys at least `s`. -/
def DestroysAtLeast (L : Flow F C) (σ : Nat → F → ℝ) (s : ℝ) : Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → ∀ f, f ∈ L.present t →
    0 < total cs (L.take t f) → s ≤ σ t f

variable {L : Flow F C} {u : ℝ} {σ : Nat → F → ℝ}

/-- Under the exergy balance and the second law, a formation gives a closed family no more
than it takes from it. -/
theorem ExergyBalance.give_le (balance : ExergyBalance L u σ) (second : SecondLaw L σ)
    (unit : 0 < u) {cs : List C} {t : Nat} (distinct : Distinct cs) (closed : L.ClosedAt cs t)
    {f : F} (present : f ∈ L.present t) : total cs (L.give t f) ≤ total cs (L.take t f) := by
  have h := balance cs t distinct closed f present
  have hσ := second t f present
  have : u * (total cs (L.give t f) : ℝ) ≤ u * (total cs (L.take t f) : ℝ) := by linarith
  exact_mod_cast le_of_mul_le_mul_left this unit

/-- The second law is the spine's first law at the unit: nothing comes from nothing. -/
theorem gainless_of_secondLaw (balance : ExergyBalance L u σ) (second : SecondLaw L σ)
    (unit : 0 < u) : L.Gainless :=
  fun _ _ distinct closed _ present => balance.give_le second unit distinct closed present

/-- Under the exergy balance, the exergy an exchange destroys is its residue counted in
units: the record of `Flow.dissipatesOn_iff_conserved`. -/
theorem ExergyBalance.destroyed_eq_residue (balance : ExergyBalance L u σ)
    (second : SecondLaw L σ) (unit : 0 < u) {cs : List C} {t : Nat} (distinct : Distinct cs)
    (closed : L.ClosedAt cs t) {f : F} (present : f ∈ L.present t) :
    σ t f = u * (L.residue cs t f : ℝ) := by
  have h := balance cs t distinct closed f present
  have le := balance.give_le second unit distinct closed present
  have split := excess_balance (total cs (L.take t f)) (total cs (L.give t f))
  have zero : excess (total cs (L.give t f)) (total cs (L.take t f)) = 0 := by
    rcases Nat.eq_zero_or_pos (excess (total cs (L.give t f)) (total cs (L.take t f))) with
      z | p
    · exact z
    · exact absurd (excess_pos.mp p) (Nat.not_lt.mpr le)
  rw [zero, Nat.add_zero] at split
  have cast : (total cs (L.take t f) : ℝ) =
      (total cs (L.give t f) : ℝ) + (L.residue cs t f : ℝ) := by
    unfold Flow.residue; exact_mod_cast split
  rw [cast] at h
  linarith

/-- In `Passing` no exchange destroys exergy: the exergy balance and the second law hold
with nothing destroyed, at every unit. -/
theorem passing_balance (u : ℝ) :
    ExergyBalance Passing.flow u (fun _ _ => 0) ∧ SecondLaw Passing.flow (fun _ _ => 0) :=
  ⟨fun cs t distinct closed f present => by
     have h := Passing.conserving cs t distinct closed f present
     simp only [add_zero]
     exact congrArg (u * ·) (by exact_mod_cast h),
   fun _ _ _ => le_refl 0⟩

/-- The second law alone does not give dissipation: in `Passing` it holds with no exergy
destroyed, and the flow is not dissipative. -/
theorem secondLaw_not_dissipative :
    ExergyBalance Passing.flow 1 (fun _ _ => 0) ∧ SecondLaw Passing.flow (fun _ _ => 0) ∧
      ¬ Passing.flow.Dissipative :=
  ⟨(passing_balance 1).1, (passing_balance 1).2, Passing.passes.2.2.2.2.2.2.2.2.2.2.1⟩

/-! ## Strict irreversibility with whole units -/

/-- With whole units of amount, an exchange that destroys exergy whenever it takes gives back
at least one unit less than it takes. -/
theorem dissipative_of_irreversible (balance : ExergyBalance L u σ) (second : SecondLaw L σ)
    (strict : Irreversible L σ) (unit : 0 < u) : L.Dissipative := by
  intro cs t distinct closed f present
  have le := balance.give_le second unit distinct closed present
  rcases Nat.eq_zero_or_pos (total cs (L.take t f)) with zero | pos
  · rw [zero] at le ⊢
    exact le
  · have h := balance cs t distinct closed f present
    have hσ := strict cs t distinct closed f present pos
    have lt : u * (total cs (L.give t f) : ℝ) < u * (total cs (L.take t f) : ℝ) := by linarith
    have lt' : total cs (L.give t f) < total cs (L.take t f) := by
      exact_mod_cast lt_of_mul_lt_mul_left lt unit.le
    have one : sign (total cs (L.take t f)) ≤ 1 := sign_le_one _
    omega

/-! ## A floor in energy -/

/-- Where every exchange that takes destroys at least `s`, the loss counted at the unit `u`
is at least every whole `n` with `n * u ≤ s`. -/
theorem loss_of_floor (balance : ExergyBalance L u σ) (unit : 0 < u) {s : ℝ}
    (floor : DestroysAtLeast L σ s) {n : Nat} (within : (n : ℝ) * u ≤ s) {cs : List C}
    {t : Nat} (distinct : Distinct cs) (closed : L.ClosedAt cs t) {f : F}
    (present : f ∈ L.present t) (takes : 0 < total cs (L.take t f)) :
    total cs (L.give t f) + n ≤ total cs (L.take t f) := by
  have h := balance cs t distinct closed f present
  have hσ := floor cs t distinct closed f present takes
  have : u * ((total cs (L.give t f) : ℝ) + n) ≤ u * (total cs (L.take t f) : ℝ) := by
    nlinarith
  exact_mod_cast le_of_mul_le_mul_left this unit

/-- At every unit within the floor, the flow is dissipative. -/
theorem dissipative_of_floor (balance : ExergyBalance L u σ) (second : SecondLaw L σ)
    (unit : 0 < u) {s : ℝ} (floor : DestroysAtLeast L σ s) (within : u ≤ s) :
    L.Dissipative :=
  dissipative_of_irreversible balance second
    (fun cs t distinct closed f present takes =>
      lt_of_lt_of_le unit (le_trans within (floor cs t distinct closed f present takes)))
    unit

/-- Counted at an `r`-fold finer unit, a floor of `s` at the unit `s` is a loss of at least `r`
units: the floor is an amount of energy, not one unit of whatever resolution. -/
theorem loss_at_finer_unit {s : ℝ} (positive : 0 < s) {r : Nat} (refine : 0 < r)
    (balance : ExergyBalance L (s / r) σ) (floor : DestroysAtLeast L σ s) {cs : List C}
    {t : Nat} (distinct : Distinct cs) (closed : L.ClosedAt cs t) {f : F}
    (present : f ∈ L.present t) (takes : 0 < total cs (L.take t f)) :
    total cs (L.give t f) + r ≤ total cs (L.take t f) := by
  have hr : (0 : ℝ) < r := by exact_mod_cast refine
  refine loss_of_floor balance (div_pos positive hr) floor ?_ distinct closed present takes
  rw [mul_div_cancel₀ s hr.ne']

/-! ## Bounded efficiency -/

/-- Where every exchange over a closed family destroys at least a `(q + 1)`th of the exergy it
takes, the flow is dissipative in proportion `q`, whatever the unit. -/
theorem dissipativeBy_of_efficiency (balance : ExergyBalance L u σ) (unit : 0 < u) {q : Nat}
    (efficiency : ∀ cs t, Distinct cs → L.ClosedAt cs t → ∀ f, f ∈ L.present t →
      u * (total cs (L.take t f) : ℝ) ≤ (q + 1) * σ t f) :
    L.DissipativeBy q := by
  intro cs t distinct closed
  refine Flow.DissipatesBy.of_each fun f present => ?_
  have h := balance cs t distinct closed f present
  have e := efficiency cs t distinct closed f present
  have : u * (((q + 1 : Nat) : ℝ) * (total cs (L.give t f) : ℝ)) ≤
      u * ((q : ℝ) * (total cs (L.take t f) : ℝ)) := by
    push_cast; nlinarith
  exact_mod_cast le_of_mul_le_mul_left this unit

/-! ## The first law: balance

The spine's balance (`Flow.Balances`) says that every change of a condition's level is what
the formations taking part take from it and give to it. Read physically, it is the first
law with locality: a quantity carried only by the exchanges taking part balances exactly
where the conditions produce none of it themselves (`balances_iff_unproduced`), so a
quantity conserved locally, as energy and mass are, balances (`balances_of_conserved`).
Conservation of the total without locality does not give it (`Teleport.conserved_not_balanced`).
Read in available work relative to one environment, as the least loss is read above, the
first law and the entropy balance at each store give available work a local balance whose
source is the exergy the store destroys (`StoreLaws.availableWork`), so the levels balance
exactly where no store generates entropy (`balances_iff_stores_generate_nothing`); the same
two laws at each exchange give `ExergyBalance`, with the destroyed exergy `T0` times the
entropy the exchange generates (`exergyBalance_of_laws`). Balance and least loss then come
from one reading (`balance_and_least_loss`): a store that degrades within itself is
counted as an exchange, or its condition does not balance (`Leaking`). -/

section FirstLaw

/-- The total of a real quantity over a finite list. -/
def rtotal {α : Type} : List α → (α → ℝ) → ℝ
  | [], _ => 0
  | a :: as, q => q a + rtotal as q

theorem cast_total {α : Type} (l : List α) (q : α → Nat) :
    ((total l q : Nat) : ℝ) = rtotal l (fun a => (q a : ℝ)) := by
  induction l with
  | nil => simp [total, rtotal]
  | cons a as ih => simp [total, rtotal, ih]

theorem rtotal_combine {α : Type} (l : List α) (p q : α → ℝ) (a b : ℝ) :
    rtotal l (fun x => a * p x + b * q x) = a * rtotal l p + b * rtotal l q := by
  induction l with
  | nil => simp [rtotal]
  | cons x xs ih => simp only [rtotal, ih]; ring

theorem rtotal_congr_on {α : Type} {l : List α} {p q : α → ℝ}
    (h : ∀ x, x ∈ l → p x = q x) : rtotal l p = rtotal l q := by
  induction l with
  | nil => rfl
  | cons x xs ih =>
    simp only [rtotal]
    rw [h x (by simp), ih (fun y m => h y (by simp [m]))]

/-- Amounts taken less amounts given, read at the unit `u` and totalled, are `u` times the
totals taken less the totals given. -/
theorem rtotal_read {α : Type} (l : List α) (k g : α → Nat) (u : ℝ) :
    rtotal l (fun a => u * ((k a : ℝ) - (g a : ℝ))) =
      u * (((total l k : Nat) : ℝ) - ((total l g : Nat) : ℝ)) := by
  induction l with
  | nil => simp [rtotal, total]
  | cons a as ih => simp only [rtotal, total, ih]; push_cast; ring

variable {W : Web F C} {q : Nat → C → ℝ} {x : Nat → F → C → ℝ} {p : Nat → C → ℝ}
  {E S : Nat → C → ℝ} {e s : Nat → F → C → ℝ} {g : Nat → C → ℝ} {T0 : ℝ}
  {Q γ : Nat → F → ℝ}

/-- A quantity held on the conditions is carried only by the exchanges taking part: across
the step from `t`, what stands on `c` changes by what the formations present carry out of it,
`x t f c`, and by what `c` itself produces of it, `p t c`. With `p` zero the quantity is
conserved locally, as energy is by the first law; otherwise `p` is its source, as entropy
generated within a store is. -/
def LocalBalance (L : Flow F C) (q : Nat → C → ℝ) (x : Nat → F → C → ℝ) (p : Nat → C → ℝ) :
    Prop :=
  ∀ t c, q (t + 1) c = q t c - rtotal (L.present t) (fun f => x t f c) + p t c

/-- What stands on each condition is `u` times its level. -/
def ReadsLevels (W : Web F C) (u : ℝ) (q : Nat → C → ℝ) : Prop :=
  ∀ t c, q t c = u * (W.level t c : ℝ)

/-- What each exchange taking part carries out of a condition is `u` times what it takes from
it less what it gives to it. -/
def ReadsTransfers (L : Flow F C) (u : ℝ) (x : Nat → F → C → ℝ) : Prop :=
  ∀ t f c, f ∈ L.present t → x t f c = u * ((L.take t f c : ℝ) - (L.give t f c : ℝ))

/-- Read at the unit, what the exchanges taking part carry out of a condition is `u` times
what they take from it less what they give to it. -/
theorem ReadsTransfers.carried (read : ReadsTransfers L u x) (t : Nat) (c : C) :
    rtotal (L.present t) (fun f => x t f c) = u * ((L.taken t c : ℝ) - (L.given t c : ℝ)) :=
  (rtotal_congr_on fun f present => read t f c present).trans
    (rtotal_read (L.present t) (fun f => L.take t f c) (fun f => L.give t f c) u)

/-- Read at the unit, what a condition produces across a step is `u` times what its level and
what is taken from it come to, less what stood on it and what is given to it. -/
theorem LocalBalance.produced (bal : LocalBalance L q x p) (levels : ReadsLevels W u q)
    (transfers : ReadsTransfers L u x) (t : Nat) (c : C) :
    p t c = u * (((W.level (t + 1) c + L.taken t c : Nat) : ℝ) -
      ((W.level t c + L.given t c : Nat) : ℝ)) := by
  have h := bal t c
  rw [transfers.carried t c, levels, levels] at h
  push_cast
  linarith

/-- **Balance is local conservation.** A quantity carried only by the exchanges taking part,
read at a unit on the levels and on the exchanges, balances the levels exactly where no
condition produces any of it. -/
theorem balances_iff_unproduced (bal : LocalBalance L q x p) (levels : ReadsLevels W u q)
    (transfers : ReadsTransfers L u x) (unit : 0 < u) :
    L.Balances W ↔ ∀ t c, p t c = 0 := by
  constructor
  · intro balances t c
    rw [bal.produced levels transfers t c, balances t c, sub_self, mul_zero]
  · intro none t c
    have h := bal.produced levels transfers t c
    rw [none t c] at h
    have : ((W.level (t + 1) c + L.taken t c : Nat) : ℝ) =
        ((W.level t c + L.given t c : Nat) : ℝ) := by
      rcases mul_eq_zero.mp h.symm with z | z
      · exact absurd z unit.ne'
      · linarith
    exact_mod_cast this

/-- A quantity conserved locally, carried only by the exchanges taking part, balances the
levels it is read on. -/
theorem balances_of_conserved (bal : LocalBalance L q x (fun _ _ => 0))
    (levels : ReadsLevels W u q) (transfers : ReadsTransfers L u x) (unit : 0 < u) :
    L.Balances W :=
  (balances_iff_unproduced bal levels transfers unit).mpr fun _ _ => rfl

/-- The first law and the entropy balance at each condition, read as a store: across the step
from `t`, its energy `E` changes only by the energy `e t f c` the exchanges taking part draw
from it, and its entropy `S` by the entropy `s t f c` they draw from it and the entropy
`g t c` it generates within itself. -/
def StoreLaws (L : Flow F C) (E S : Nat → C → ℝ) (e s : Nat → F → C → ℝ) (g : Nat → C → ℝ) :
    Prop :=
  LocalBalance L E e (fun _ _ => 0) ∧ LocalBalance L S s g

/-- Relative to an environment at temperature `T0`, a store's available work `E - T0 * S`
is carried by the exchanges as `e - T0 * s`, and its source is `-(T0 * g)`: available work
is destroyed exactly where the store generates entropy (Gouy–Stodola). -/
theorem StoreLaws.availableWork (h : StoreLaws L E S e s g) (T0 : ℝ) :
    LocalBalance L (fun t c => E t c - T0 * S t c) (fun t f c => e t f c - T0 * s t f c)
      (fun t c => -(T0 * g t c)) := by
  intro t c
  have hE : E (t + 1) c = E t c - rtotal (L.present t) (fun f => e t f c) := by
    have := h.1 t c; simp only [add_zero] at this; exact this
  have hS := h.2 t c
  have split := rtotal_combine (L.present t) (fun f => e t f c) (fun f => s t f c) 1 (-T0)
  show E (t + 1) c - T0 * S (t + 1) c =
    E t c - T0 * S t c - rtotal (L.present t) (fun f => e t f c - T0 * s t f c) + -(T0 * g t c)
  rw [show (fun f => e t f c - T0 * s t f c) = (fun f => 1 * e t f c + -T0 * s t f c) from
    funext fun f => by ring, split, hE, hS]
  ring

/-- **Balance from the first law.** Read in available work relative to an environment at
`T0 > 0`, with the first law and the entropy balance at every store and each exchange's
transfers read at the unit, the levels balance exactly where no store generates entropy. -/
theorem balances_iff_stores_generate_nothing (stores : StoreLaws L E S e s g)
    (levels : ReadsLevels W u (fun t c => E t c - T0 * S t c))
    (transfers : ReadsTransfers L u (fun t f c => e t f c - T0 * s t f c)) (unit : 0 < u)
    (warm : 0 < T0) : L.Balances W ↔ ∀ t c, g t c = 0 := by
  rw [balances_iff_unproduced (stores.availableWork T0) levels transfers unit]
  constructor
  · intro h t c
    have z : -(T0 * g t c) = 0 := h t c
    rcases mul_eq_zero.mp (neg_eq_zero.mp z) with z | z
    · exact absurd z warm.ne'
    · exact z
  · intro h t c
    show -(T0 * g t c) = 0
    rw [h t c, mul_zero, neg_zero]

/-- Where no store generates negative entropy, no level rises beyond what the exchanges
taking part bring to it. -/
theorem stores_within (stores : StoreLaws L E S e s g)
    (levels : ReadsLevels W u (fun t c => E t c - T0 * S t c))
    (transfers : ReadsTransfers L u (fun t f c => e t f c - T0 * s t f c)) (unit : 0 < u)
    (warm : 0 ≤ T0) (second : ∀ t c, 0 ≤ g t c) (t : Nat) (c : C) :
    W.level (t + 1) c + L.taken t c ≤ W.level t c + L.given t c := by
  have h : -(T0 * g t c) = u * (((W.level (t + 1) c + L.taken t c : Nat) : ℝ) -
      ((W.level t c + L.given t c : Nat) : ℝ)) :=
    (stores.availableWork T0).produced levels transfers t c
  have hg : 0 ≤ T0 * g t c := mul_nonneg warm (second t c)
  have : ((W.level (t + 1) c + L.taken t c : Nat) : ℝ) ≤
      ((W.level t c + L.given t c : Nat) : ℝ) := by
    by_contra hlt
    have : 0 < u * (((W.level (t + 1) c + L.taken t c : Nat) : ℝ) -
        ((W.level t c + L.given t c : Nat) : ℝ)) := mul_pos unit (by linarith [not_le.mp hlt])
    linarith
  exact_mod_cast this

/-- The first law and the entropy balance at each exchange, which holds nothing across its
step: over a family closed across the step, the energy it draws from the family leaves as
heat `Q t f` to the environment at temperature `T0`, and the entropy it draws from the
family, with the entropy `γ t f` it generates, leaves with that heat. -/
def ExchangeLaws (L : Flow F C) (T0 : ℝ) (e s : Nat → F → C → ℝ) (Q γ : Nat → F → ℝ) :
    Prop :=
  ∀ cs t, Distinct cs → L.ClosedAt cs t → ∀ f, f ∈ L.present t →
    rtotal cs (e t f) = Q t f ∧ rtotal cs (s t f) + γ t f = Q t f / T0

/-- **The exergy balance from the first law.** With the first law and the entropy balance at
each exchange and its transfers read at the unit, each exchange meets the exergy balance,
the exergy it destroys being `T0` times the entropy it generates. -/
theorem exergyBalance_of_laws (exchanges : ExchangeLaws L T0 e s Q γ)
    (transfers : ReadsTransfers L u (fun t f c => e t f c - T0 * s t f c)) (warm : 0 < T0) :
    ExergyBalance L u (fun t f => T0 * γ t f) := by
  intro cs t distinct closed f present
  obtain ⟨energy, entropy⟩ := exchanges cs t distinct closed f present
  have read : rtotal cs (fun c => e t f c - T0 * s t f c) =
      u * ((total cs (L.take t f) : ℝ) - (total cs (L.give t f) : ℝ)) :=
    (rtotal_congr_on fun c _ => transfers t f c present).trans
      (rtotal_read cs (L.take t f) (L.give t f) u)
  have split : rtotal cs (fun c => e t f c - T0 * s t f c) =
      rtotal cs (e t f) - T0 * rtotal cs (s t f) := by
    rw [show (fun c => e t f c - T0 * s t f c) = (fun c => 1 * e t f c + -T0 * s t f c) from
      funext fun c => by ring, rtotal_combine]
    ring
  have heat : T0 * rtotal cs (s t f) + T0 * γ t f = Q t f := by
    rw [← mul_add, entropy, mul_div_cancel₀ _ warm.ne']
  show u * (total cs (L.give t f) : ℝ) + T0 * γ t f = u * (total cs (L.take t f) : ℝ)
  linarith

/-- Where no exchange generates negative entropy, the second law holds of the exergy they
destroy. -/
theorem secondLaw_of_generation (warm : 0 ≤ T0)
    (generates : ∀ t f, f ∈ L.present t → 0 ≤ γ t f) : SecondLaw L (fun t f => T0 * γ t f) :=
  fun t f present => mul_nonneg warm (generates t f present)

/-- Where every exchange that takes from a closed family generates some entropy, every such
exchange destroys some exergy. -/
theorem irreversible_of_generation (warm : 0 < T0)
    (strict : ∀ cs t, Distinct cs → L.ClosedAt cs t → ∀ f, f ∈ L.present t →
      0 < total cs (L.take t f) → 0 < γ t f) : Irreversible L (fun t f => T0 * γ t f) :=
  fun cs t distinct closed f present takes =>
    mul_pos warm (strict cs t distinct closed f present takes)

/-- **Balance and least loss from one reading.** Read each unit of amount as `u` of available
work relative to one environment at `T0 > 0`, with the first law and the entropy balance at
every store and every exchange, and the transfers between them read at the unit. Then the
levels balance exactly where no store generates entropy; where no exchange generates
negative entropy, nothing comes from nothing at the unit; and where, besides, every exchange
that takes from a closed family generates some, the flow is dissipative. -/
theorem balance_and_least_loss (stores : StoreLaws L E S e s g)
    (exchanges : ExchangeLaws L T0 e s Q γ)
    (levels : ReadsLevels W u (fun t c => E t c - T0 * S t c))
    (transfers : ReadsTransfers L u (fun t f c => e t f c - T0 * s t f c)) (unit : 0 < u)
    (warm : 0 < T0) :
    (L.Balances W ↔ ∀ t c, g t c = 0) ∧
      ((∀ t f, f ∈ L.present t → 0 ≤ γ t f) → L.Gainless) ∧
      ((∀ t f, f ∈ L.present t → 0 ≤ γ t f) →
        (∀ cs t, Distinct cs → L.ClosedAt cs t → ∀ f, f ∈ L.present t →
          0 < total cs (L.take t f) → 0 < γ t f) → L.Dissipative) :=
  ⟨balances_iff_stores_generate_nothing stores levels transfers unit warm,
   fun generates => gainless_of_secondLaw (exergyBalance_of_laws exchanges transfers warm)
     (secondLaw_of_generation warm.le generates) unit,
   fun generates strict => dissipative_of_irreversible
     (exergyBalance_of_laws exchanges transfers warm) (secondLaw_of_generation warm.le generates)
     (irreversible_of_generation warm strict) unit⟩

end FirstLaw

/-! ## Conservation of the total does not give balance -/

namespace Teleport

/-- No exchange takes part at any step. -/
def flow : Flow Unit Bool where
  present _ := []
  take _ _ _ := 0
  give _ _ _ := 0

/-- One unit stands on `true` before the first step and on `false` after it. -/
def web : Web Unit Bool where
  level t c := if t = 0 then (if c then 1 else 0) else (if c then 0 else 1)
  active _ _ := False
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The total over both conditions stays at one, and the levels do not balance: the unit
moves with no exchange to carry it. -/
theorem conserved_not_balanced :
    (∀ t, total [true, false] (web.level t) = 1) ∧ ¬ flow.Balances web := by
  refine ⟨fun t => ?_, fun balances => ?_⟩
  · by_cases h : t = 0 <;> simp [web, total, h]
  · have := balances 0 true
    simp [web, flow, Flow.taken, Flow.given, total] at this

end Teleport

/-! ## The premises together, and a store that degrades within itself -/

namespace Burning

/-- At the first step one exchange takes the one unit that stands on the store and gives
nothing back; no exchange takes part afterwards. -/
def flow : Flow Unit Unit where
  present t := if t = 0 then [()] else []
  take _ _ _ := 1
  give _ _ _ := 0

/-- One unit stands on the store before the first step, none after it. -/
def web : Web Unit Unit where
  level t _ := if t = 0 then 1 else 0
  active _ _ := False
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The store's energy: one before the first step, none after it. -/
def energy (t : Nat) (_ : Unit) : ℝ := if t = 0 then 1 else 0

/-- The store's entropy, zero throughout. -/
def entropy (_ : Nat) (_ : Unit) : ℝ := 0

/-- The exchange draws one unit of energy and no entropy from the store. -/
def energyDrawn (_ : Nat) (_ _ : Unit) : ℝ := 1

/-- The exchange draws no entropy from the store. -/
def entropyDrawn (_ : Nat) (_ _ : Unit) : ℝ := 0

/-- The store generates no entropy. -/
def storeGenerates (_ : Nat) (_ : Unit) : ℝ := 0

/-- The exchange passes one unit of heat to the environment. -/
def heat (_ : Nat) (_ : Unit) : ℝ := 1

/-- The exchange generates one unit of entropy, at an environment at temperature one. -/
def generates (_ : Nat) (_ : Unit) : ℝ := 1

theorem family {cs : List Unit} (distinct : Distinct cs) {t : Nat} (closed : flow.ClosedAt cs t)
    (present : () ∈ flow.present t) : cs = [()] := by
  match cs, distinct with
  | [], _ => exact absurd (closed () present () (by simp)).1 (by simp [flow])
  | [()], _ => rfl
  | () :: () :: _, ⟨fresh, _⟩ => exact absurd (by simp) fresh

/-- The premises of `balance_and_least_loss` hold together, with every exchange that takes
generating entropy. -/
theorem meets :
    StoreLaws flow energy entropy energyDrawn entropyDrawn storeGenerates ∧
      ExchangeLaws flow 1 energyDrawn entropyDrawn heat generates ∧
      ReadsLevels web 1 (fun t c => energy t c - 1 * entropy t c) ∧
      ReadsTransfers flow 1 (fun t f c => energyDrawn t f c - 1 * entropyDrawn t f c) ∧
      (∀ t f, f ∈ flow.present t → 0 ≤ generates t f) ∧
      (∀ cs t, Distinct cs → flow.ClosedAt cs t → ∀ f, f ∈ flow.present t →
        0 < total cs (flow.take t f) → 0 < generates t f) := by
  refine ⟨⟨fun t c => ?_, fun t c => ?_⟩, fun cs t distinct closed f present => ?_,
    fun t c => ?_, fun t f c _ => ?_, fun _ _ _ => ?_, fun _ _ _ _ _ _ _ => ?_⟩
  · by_cases h : t = 0 <;> simp [energy, energyDrawn, flow, rtotal, h]
  · by_cases h : t = 0 <;> simp [entropy, entropyDrawn, storeGenerates, flow, rtotal, h]
  · cases f
    rw [family distinct closed present]
    simp [rtotal, energyDrawn, entropyDrawn, heat, generates]
  · by_cases h : t = 0 <;> simp [energy, entropy, web, h]
  · simp [energyDrawn, entropyDrawn, flow]
  · simp [generates]
  · simp [generates]

/-- So the store's level balances and the flow is dissipative. -/
theorem balanced_and_dissipative : flow.Balances web ∧ flow.Dissipative := by
  obtain ⟨stores, exchanges, levels, transfers, nonneg, strict⟩ := meets
  have both := balance_and_least_loss stores exchanges levels transfers one_pos one_pos
  exact ⟨both.1.mpr fun _ _ => rfl, both.2.2 nonneg strict⟩

end Burning

namespace Leaking

/-- No exchange takes part at any step. -/
def flow : Flow Unit Unit where
  present _ := []
  take _ _ _ := 0
  give _ _ _ := 0

/-- One unit stands on the store before the first step, none after it. -/
def web : Web Unit Unit where
  level t _ := if t = 0 then 1 else 0
  active _ _ := False
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The store's entropy: zero before the first step, one after it. -/
def entropy (t : Nat) (_ : Unit) : ℝ := if t = 0 then 0 else 1

/-- The store generates one unit of entropy across the first step. -/
def storeGenerates (t : Nat) (_ : Unit) : ℝ := if t = 0 then 1 else 0

/-- The store keeps its energy and generates entropy within itself, and its level, read in
available work, does not balance: energy conserved at each store does not give balance in
available work. -/
theorem energy_conserved_not_balanced :
    StoreLaws flow (fun _ _ => 1) entropy (fun _ _ _ => 0) (fun _ _ _ => 0) storeGenerates ∧
      ReadsLevels web 1 (fun t c => 1 - 1 * entropy t c) ∧
      ReadsTransfers flow 1 (fun _ _ _ => 0 - 1 * 0) ∧ ¬ flow.Balances web := by
  refine ⟨⟨fun t c => ?_, fun t c => ?_⟩, fun t c => ?_, fun _ _ _ absent => absurd absent (by simp [flow]), ?_⟩
  · simp [flow, rtotal]
  · by_cases h : t = 0 <;> simp [entropy, storeGenerates, flow, rtotal, h]
  · by_cases h : t = 0 <;> simp [entropy, web, h]
  · intro balances
    have := balances 0 ()
    simp [web, flow, Flow.taken, Flow.given, total] at this

end Leaking

/-! ## The statistical form -/

section Statistical

variable {Ω : Type} [MeasurableSpace Ω] (μ : Measure Ω)

/-- Dissipation in expectation on `cs` across the step from `t`: in expectation, the family's
replenishment and its takers are within its uptake. A single run may gain. -/
def ExpectedDissipatesOn (L : Ω → Flow F C) (cs : List C) (t : Nat) : Prop :=
  ∫ ω, ((L ω).replenishment cs t : ℝ) ∂μ + ∫ ω, ((L ω).takers cs t : ℝ) ∂μ ≤
    ∫ ω, ((L ω).uptake cs t : ℝ) ∂μ

/-- The quantities of a family across the step from `t` have expectations. -/
def HasExpectations (L : Ω → Flow F C) (W : Ω → Web F C) (cs : List C) (t : Nat) : Prop :=
  Integrable (fun ω => ((W ω).stock cs t : ℝ)) μ ∧
    Integrable (fun ω => ((L ω).uptake cs t : ℝ)) μ ∧
    Integrable (fun ω => ((L ω).replenishment cs t : ℝ)) μ ∧
    Integrable (fun ω => ((L ω).takers cs t : ℝ)) μ

variable {μ}

/-- Dissipated on in every run, a family is dissipated on in expectation. -/
theorem ExpectedDissipatesOn.of_pathwise {L : Ω → Flow F C} {cs : List C} {t : Nat}
    (pathwise : ∀ ω, (L ω).DissipatesOn cs t)
    (uptake : Integrable (fun ω => ((L ω).uptake cs t : ℝ)) μ)
    (replenishment : Integrable (fun ω => ((L ω).replenishment cs t : ℝ)) μ)
    (takers : Integrable (fun ω => ((L ω).takers cs t : ℝ)) μ) :
    ExpectedDissipatesOn μ L cs t := by
  unfold ExpectedDissipatesOn
  rw [← integral_add replenishment takers]
  refine integral_mono (replenishment.add takers) uptake fun ω => ?_
  have := (pathwise ω).replenishment_takers
  exact_mod_cast this

/-- From an exergy balance on each run, with the exergy `D` destroyed across the step on the
family, which may be negative on a single run, and expected destruction of at least `u` for
each formation that takes, the family is dissipated on in expectation. -/
theorem ExpectedDissipatesOn.of_exergy {L : Ω → Flow F C} {cs : List C} {t : Nat}
    {D : Ω → ℝ} (unit : 0 < u)
    (balance : ∀ ω, u * ((L ω).replenishment cs t : ℝ) + D ω = u * ((L ω).uptake cs t : ℝ))
    (landauer : u * ∫ ω, ((L ω).takers cs t : ℝ) ∂μ ≤ ∫ ω, D ω ∂μ)
    (replenishment : Integrable (fun ω => ((L ω).replenishment cs t : ℝ)) μ)
    (destroyed : Integrable D μ) :
    ExpectedDissipatesOn μ L cs t := by
  unfold ExpectedDissipatesOn
  have total_balance : u * ∫ ω, ((L ω).replenishment cs t : ℝ) ∂μ + ∫ ω, D ω ∂μ =
      u * ∫ ω, ((L ω).uptake cs t : ℝ) ∂μ := by
    rw [← integral_const_mul, ← integral_const_mul, ← integral_add (replenishment.const_mul u)
      destroyed]
    exact integral_congr_ae (Eventually.of_forall balance)
  have : u * (∫ ω, ((L ω).replenishment cs t : ℝ) ∂μ + ∫ ω, ((L ω).takers cs t : ℝ) ∂μ) ≤
      u * ∫ ω, ((L ω).uptake cs t : ℝ) ∂μ := by
    rw [mul_add]; linarith
  exact le_of_mul_le_mul_left this unit

variable {L : Ω → Flow F C} {W : Ω → Web F C} {cs : List C} {T : Nat}

/-- Balanced on each run and dissipated on in expectation, the expected stock falls across a
step by at least the expected number of takers. -/
theorem expected_runs_down (balances : ∀ ω, (L ω).Balances (W ω)) {t : Nat}
    (integrable : HasExpectations μ L W cs t)
    (next : Integrable (fun ω => ((W ω).stock cs (t + 1) : ℝ)) μ)
    (dissipates : ExpectedDissipatesOn μ L cs t) :
    ∫ ω, ((W ω).stock cs (t + 1) : ℝ) ∂μ + ∫ ω, ((L ω).takers cs t : ℝ) ∂μ ≤
      ∫ ω, ((W ω).stock cs t : ℝ) ∂μ := by
  obtain ⟨stock, uptake, replenishment, _⟩ := integrable
  have over : ∫ ω, ((W ω).stock cs (t + 1) : ℝ) ∂μ + ∫ ω, ((L ω).uptake cs t : ℝ) ∂μ =
      ∫ ω, ((W ω).stock cs t : ℝ) ∂μ + ∫ ω, ((L ω).replenishment cs t : ℝ) ∂μ := by
    rw [← integral_add next uptake, ← integral_add stock replenishment]
    refine integral_congr_ae (Eventually.of_forall fun ω => ?_)
    have := (balances ω).over cs t
    dsimp only
    exact_mod_cast this
  unfold ExpectedDissipatesOn at dissipates
  linarith

/-- Balanced on each run and dissipated on in expectation from step `T`, the expected stock
after a stretch together with the expected takers over it is within the expected stock at
`T`. -/
theorem expected_takers_within (balances : ∀ ω, (L ω).Balances (W ω))
    (integrable : ∀ t, HasExpectations μ L W cs t)
    (dissipates : ∀ t, T ≤ t → ExpectedDissipatesOn μ L cs t) :
    ∀ N, ∫ ω, ((W ω).stock cs (T + N) : ℝ) ∂μ +
        ∑ i ∈ Finset.range N, ∫ ω, ((L ω).takers cs (T + i) : ℝ) ∂μ ≤
      ∫ ω, ((W ω).stock cs T : ℝ) ∂μ
  | 0 => by simp
  | N + 1 => by
    have step := expected_runs_down balances (integrable (T + N)) (integrable (T + N + 1)).1
      (dissipates (T + N) (Nat.le_add_right T N))
    have before := expected_takers_within balances integrable dissipates N
    rw [Finset.sum_range_succ]
    rw [← Nat.add_assoc]
    linarith

/-- The expected stock is not negative. -/
theorem expected_stock_nonneg (t : Nat) : 0 ≤ ∫ ω, ((W ω).stock cs t : ℝ) ∂μ :=
  integral_nonneg fun _ => Nat.cast_nonneg _

/-- The probability that some formation takes is within the expected number of takers. -/
theorem taking_probability_le {t : Nat}
    (takers : Integrable (fun ω => ((L ω).takers cs t : ℝ)) μ) :
    μ.real {ω | 0 < (L ω).takers cs t} ≤ ∫ ω, ((L ω).takers cs t : ℝ) ∂μ := by
  have markov := mul_meas_ge_le_integral_of_nonneg
    (Eventually.of_forall fun ω => (Nat.cast_nonneg ((L ω).takers cs t) : (0 : ℝ) ≤ _))
    takers 1
  have same : {ω | (1 : ℝ) ≤ ((L ω).takers cs t : ℝ)} = {ω | 0 < (L ω).takers cs t} := by
    ext ω; simp only [Set.mem_setOf_eq, Nat.one_le_cast]; omega
  rw [same, one_mul] at markov
  exact markov

/-- Balanced on each run and dissipated on in expectation from step `T`, the probabilities that
some formation takes, summed over every stretch from `T`, are within the expected stock at
`T`. -/
theorem taking_probability_within (balances : ∀ ω, (L ω).Balances (W ω))
    (integrable : ∀ t, HasExpectations μ L W cs t)
    (dissipates : ∀ t, T ≤ t → ExpectedDissipatesOn μ L cs t) (N : Nat) :
    ∑ i ∈ Finset.range N, μ.real {ω | 0 < (L ω).takers cs (T + i)} ≤
      ∫ ω, ((W ω).stock cs T : ℝ) ∂μ := by
  have within := expected_takers_within balances integrable dissipates N
  have nonneg := expected_stock_nonneg (W := W) (μ := μ) (cs := cs) (T + N)
  have each : ∑ i ∈ Finset.range N, μ.real {ω | 0 < (L ω).takers cs (T + i)} ≤
      ∑ i ∈ Finset.range N, ∫ ω, ((L ω).takers cs (T + i) : ℝ) ∂μ :=
    Finset.sum_le_sum fun i _ => taking_probability_le (integrable (T + i)).2.2.2
  linarith

/-- Balanced on each run and dissipated on in expectation from step `T`, taking from the family
does not recur, almost surely: on almost every run, from some step on no formation takes. -/
theorem taking_not_recurring_ae [IsFiniteMeasure μ] (balances : ∀ ω, (L ω).Balances (W ω))
    (integrable : ∀ t, HasExpectations μ L W cs t)
    (dissipates : ∀ t, T ≤ t → ExpectedDissipatesOn μ L cs t) :
    ∀ᵐ ω ∂μ, ∃ N, ∀ t, N ≤ t → (L ω).takers cs t = 0 := by
  set s : ℕ → Set Ω := fun i => {ω | 0 < (L ω).takers cs (T + i)}
  have bound : ∑' i, μ (s i) ≤ ENNReal.ofReal (∫ ω, ((W ω).stock cs T : ℝ) ∂μ) := by
    refine ENNReal.tsum_le_of_sum_range_le fun N => ?_
    have finite : ∀ i ∈ Finset.range N, μ (s i) ≠ ⊤ := fun i _ => measure_ne_top μ (s i)
    rw [← ENNReal.ofReal_toReal (ENNReal.sum_ne_top.mpr finite), ENNReal.toReal_sum finite]
    exact ENNReal.ofReal_le_ofReal (taking_probability_within balances integrable dissipates N)
  have summable : ∑' i, μ (s i) ≠ ⊤ := ne_top_of_le_ne_top ENNReal.ofReal_ne_top bound
  filter_upwards [ae_eventually_notMem summable] with ω eventually
  obtain ⟨M, after⟩ := eventually_atTop.mp eventually
  refine ⟨T + M, fun t later => ?_⟩
  have := after (t - T) (by omega)
  simp only [s, Set.mem_setOf_eq, not_lt, Nat.le_zero] at this
  rwa [Nat.add_sub_cancel' (by omega : T ≤ t)] at this

end Statistical

/-! ## A run that gains while the expectation is dissipated on -/

namespace Fluctuation

/-- One run takes one unit and gives back two; the other takes three and gives back none. -/
def flow (b : Bool) : Flow Unit Unit where
  present t := if t = 0 then [()] else []
  take _ _ _ := if b then 1 else 3
  give _ _ _ := if b then 2 else 0

/-- Three units before the step; after it, four on the run that gains and none on the other. -/
def web (b : Bool) : Web Unit Unit where
  level t _ := if t = 0 then 3 else if b then 4 else 0
  active _ _ := False
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The two runs, each with probability one half. -/
noncomputable def coin : Measure Bool := (2 : ENNReal)⁻¹ • (Measure.dirac true + Measure.dirac false)

theorem integral_coin (g : Bool → ℝ) : ∫ b, g b ∂coin = 2⁻¹ * (g true + g false) := by
  unfold coin
  rw [integral_smul_measure, integral_add_measure (Integrable.of_finite) (Integrable.of_finite),
    integral_dirac, integral_dirac]
  simp

theorem balances (b : Bool) : (flow b).Balances (web b) := by
  intro t c
  cases b <;> by_cases h : t = 0 <;>
    simp [flow, web, Flow.taken, Flow.given, total, h]

theorem closed (b : Bool) (t : Nat) : (flow b).ClosedAt [()] t :=
  fun _ _ c outside => absurd (List.mem_singleton.mpr rfl) (by cases c; exact outside)

/-- In expectation the family is dissipated on at every step, while on one run it gains:
across the first step its one formation gives back more than it takes, so that run's flow
gains and is not dissipative. -/
theorem gains_in_one_run :
    (∀ t, ExpectedDissipatesOn coin flow [()] t) ∧ (∀ b t, (flow b).ClosedAt [()] t) ∧
      (∀ b, (flow b).Balances (web b)) ∧ ¬ (flow true).GainlessOn [()] 0 ∧
      ¬ (flow true).Dissipative := by
  have gains : ¬ (flow true).GainlessOn [()] 0 := fun gainless => by
    have := gainless () (by simp [flow])
    simp [flow, total] at this
  refine ⟨fun t => ?_, closed, balances, gains, fun dissipative =>
    gains (dissipative [()] 0 ⟨List.not_mem_nil, trivial⟩ (closed true 0)).gainlessOn⟩
  unfold ExpectedDissipatesOn
  rw [integral_coin, integral_coin, integral_coin]
  by_cases h : t = 0 <;>
    simp [flow, Flow.replenishment, Flow.uptake, Flow.takers, Flow.taken, Flow.given, count,
      total, sign, Witnesses.profile, h]
  norm_num

end Fluctuation

/-! ## The second law in expectation from the fluctuation theorem -/

section Fluctuation

variable {Ω : Type} [MeasurableSpace Ω] {μ : Measure Ω} [IsProbabilityMeasure μ]

/-- Where the entropy production `Σ`, in units of Boltzmann's constant, meets the integral
fluctuation theorem `E[exp (-Σ)] = 1`, its expectation is not negative: the second law in
expectation. -/
theorem expected_production_nonneg {S : Ω → ℝ} (integrable : Integrable S μ)
    (exponential : Integrable (fun ω => Real.exp (-S ω)) μ)
    (fluctuation : ∫ ω, Real.exp (-S ω) ∂μ = 1) : 0 ≤ ∫ ω, S ω ∂μ := by
  have below : ∫ ω, (-S ω + 1) ∂μ ≤ ∫ ω, Real.exp (-S ω) ∂μ :=
    integral_mono (integrable.neg.add (integrable_const 1)) exponential
      fun ω => Real.add_one_le_exp (-S ω)
  have split : ∫ ω, (-S ω + 1) ∂μ = -(∫ ω, S ω ∂μ) + 1 := by
    rw [integral_add (f := fun ω => -S ω) (g := fun _ => (1 : ℝ)) integrable.neg
      (integrable_const 1), integral_neg]
    simp
  rw [split, fluctuation] at below
  linarith

omit [IsProbabilityMeasure μ] in
/-- Under the integral fluctuation theorem, a run on which the entropy production is at most
`-a` has probability at most `exp (-a)`: gains occur, and large ones are exponentially rare. -/
theorem gain_probability_le {S : Ω → ℝ}
    (exponential : Integrable (fun ω => Real.exp (-S ω)) μ)
    (fluctuation : ∫ ω, Real.exp (-S ω) ∂μ = 1) (a : ℝ) :
    μ.real {ω | S ω ≤ -a} ≤ Real.exp (-a) := by
  have markov := mul_meas_ge_le_integral_of_nonneg
    (Eventually.of_forall fun ω => (Real.exp_pos (-S ω)).le) exponential (Real.exp a)
  have same : {ω | Real.exp a ≤ Real.exp (-S ω)} = {ω | S ω ≤ -a} := by
    ext ω; simp only [Set.mem_setOf_eq, Real.exp_le_exp]; constructor <;> intro h <;> linarith
  rw [same, fluctuation] at markov
  have positive := Real.exp_pos a
  rw [Real.exp_neg]
  calc μ.real {ω | S ω ≤ -a}
      = (Real.exp a)⁻¹ * (Real.exp a * μ.real {ω | S ω ≤ -a}) :=
        (inv_mul_cancel_left₀ positive.ne' _).symm
    _ ≤ (Real.exp a)⁻¹ * 1 := by gcongr
    _ = (Real.exp a)⁻¹ := mul_one _

end Fluctuation

end EntropyProduction

end Becoming
