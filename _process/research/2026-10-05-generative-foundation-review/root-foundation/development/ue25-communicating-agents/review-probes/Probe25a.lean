import Becoming.CountedCodes

/-! Review probes for UE25 (`Becoming.CountedCodes`), part a: duplicates, hypotheses, witnesses.
Scratch only; not for the repository. -/

namespace Becoming

namespace Probe25a

open CountedCodes FreeEnergyCounting

/-! ### P1. `CountedCodes.total_map` is an instance of the existing `Becoming.total_map` (Flow). -/

theorem p1_total_map_dup {α : Type} (σ : α → α) (a : α → Nat) (hs : List α) :
    total (hs.map σ) a = total hs (fun h => a (σ h)) :=
  Becoming.total_map σ a hs

/-! ### P2. `bound_eq_map` holds for every map, a constant one included: it is a reindexing of
the listing, not an invariance of the bound under renaming. -/

example (n a : Bool → Nat) (hs : List Bool) :=
  bound_eq_map (fun _ => false) n a hs

/-! ### P3. The invariance the docstring names: over a listing that the renaming permutes, a count
belief is at the bound for `a` exactly where its renaming is at the bound for the renamed weights,
over the same listing. -/

theorem p3_total_perm {α : Type} (f : α → Nat) {l l' : List α} (p : l.Perm l') :
    total l f = total l' f := by
  induction p with
  | nil => rfl
  | cons x _ ih => exact congrArg (f x + ·) ih
  | swap x y l =>
    show f y + (f x + total l f) = f x + (f y + total l f)
    exact Nat.add_left_comm _ _ _
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem p3_powerProduct_perm {α : Type} (a n : α → Nat) {l l' : List α} (p : l.Perm l') :
    powerProduct a n l = powerProduct a n l' := by
  induction p with
  | nil => rfl
  | cons x _ ih => exact congrArg (a x ^ n x * ·) ih
  | swap x y l =>
    show a y ^ n y * (a x ^ n x * powerProduct a n l) = a x ^ n x * (a y ^ n y * powerProduct a n l)
    exact mul_turn _ _ _
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

theorem p3_bound_invariant {α : Type} (σ : α → α) (n a : α → Nat) (hs : List α)
    (permutes : (hs.map σ).Perm hs) :
    (total hs n ^ total hs n * powerProduct a n hs =
        total hs a ^ total hs n * powerProduct n n hs) ↔
      (total hs (fun h => n (σ h)) ^ total hs (fun h => n (σ h)) *
          powerProduct (fun h => a (σ h)) (fun h => n (σ h)) hs =
        total hs (fun h => a (σ h)) ^ total hs (fun h => n (σ h)) *
          powerProduct (fun h => n (σ h)) (fun h => n (σ h)) hs) := by
  rw [← total_map σ n hs, ← total_map σ a hs, ← powerProduct_map σ a n hs,
    ← powerProduct_map σ n n hs, p3_total_perm n permutes, p3_total_perm a permutes,
    p3_powerProduct_perm a n permutes, p3_powerProduct_perm n n permutes]

/-! ### P4. `onto` is not needed in `never_shared_greatest` where the exchange is an involution. -/

theorem p4_never_shared_involution {I M F : Type} {π : I → I} {σ : M → F → F}
    {T : (I → M → F → Nat) → I → M → F → Nat}
    (keeps : Law.KeepsRelation T (Renamed π σ)) {X : I → M → F → Nat}
    (symmetric : Renamed π σ X X) (involution : ∀ i, π (π i) = i) {m : M}
    (moves : ∀ x, σ m x ≠ x) (n : Nat) (i : I) {v : F}
    (g : Greatest ((Law.run T X).state n i m) v)
    (g' : Greatest ((Law.run T X).state n (π i) m) v) : False :=
  have rel := Law.KeepsRelation.run keeps symmetric n
  -- state i v = state (π i) (σ v) < state (π i) v = state (π π i) (σ v) = state i (σ v) < state i v
  have a : (Law.run T X).state n i m v < (Law.run T X).state n (π i) m v :=
    Nat.lt_of_le_of_lt (Nat.le_of_eq (rel i m v)) (g' (σ m v) (moves v))
  have b : (Law.run T X).state n (π i) m v < (Law.run T X).state n i m v :=
    Nat.lt_of_le_of_lt
      (Nat.le_of_eq ((rel (π i) m v).trans (congrArg (fun j => (Law.run T X).state n j m (σ m v))
        (involution i))))
      (g (σ m v) (moves v))
  Nat.lt_irrefl _ (Nat.lt_trans a b)

/-! ### P5. `Witness.lead`'s docstring says "a start no exchange relates to itself"; the identity
exchange with the identity renaming relates it (as it does every state). The intended statement,
that the exchange of agents together with the renaming of words does not relate it, holds. -/

theorem p5_lead_identity : Renamed (fun i => i) (fun (_ : Unit) x => x) Witness.lead Witness.lead :=
  fun _ _ _ => rfl

theorem p5_lead_not_symmetric :
    ¬ Renamed (fun i => !i) (fun (_ : Unit) x => !x) Witness.lead Witness.lead :=
  fun h => absurd (h false () false) (by decide)

/-! ### P6. `pool` adds the partner's whole counts at every step, so after the partners share one
model it doubles with no new count heard: from `opposite`, `3, 3` then `6, 6`. The exchange of
sufficient statistics in the Bayesian sense adds each datum once. -/

theorem p6_pool_doubles (i w : Bool) :
    (Law.run (pool fun i => !i) Witness.opposite).state 2 i () w = 6 :=
  match i, w with
  | false, false => rfl
  | false, true => rfl
  | true, false => rfl
  | true, true => rfl

/-! ### P7. A law keeping both symmetries that is not `learn`: any rule giving each count from the
agent's and its partner's counts at the same word (averaging, forgetting, a weighted update)
keeps the relation. -/

def pointwise {I M F : Type} (p : I → I) (g : Nat → Nat → Nat) (X : I → M → F → Nat) :
    I → M → F → Nat :=
  fun i m w => g (X i m w) (X (p i) m w)

theorem p7_pointwise_keeps {I M F : Type} {π p : I → I} {σ : M → F → F} (g : Nat → Nat → Nat)
    (commutes : ∀ i, p (π i) = π (p i)) :
    Law.KeepsRelation (pointwise (M := M) (F := F) p g) (Renamed π σ) :=
  fun X Y related i m w =>
    show g (Y i m w) (Y (p i) m w) = g (X (π i) m (σ m w)) (X (p (π i)) m (σ m w)) from
      (congrArg (g · (Y (p i) m w)) (related i m w)).trans
        (congrArg (g (X (π i) m (σ m w))) ((related (p i) m w).trans
          (congrArg (fun j => X j m (σ m w)) (commutes i).symm)))

/-- Averaging with the partner, halving the sum (a forgetting update in natural counts). -/
theorem p7_average_keeps {I M F : Type} {π : I → I} {σ : M → F → F} :
    Law.KeepsRelation (pointwise (M := M) (F := F) π (fun a b => (a + b) / 2)) (Renamed π σ) :=
  p7_pointwise_keeps _ fun _ => rfl

/-! ### P8. The precision part needs only an irreflexive, transitive order: stated for any
`V` with `<`, so the periphery could read real Dirichlet parameters. -/

section General

variable {V : Type} [LT V] (irrefl : ∀ x : V, ¬ x < x) (trans : ∀ x y z : V, x < y → y < z → x < z)

def GreatestV {F : Type} (c : F → V) (w : F) : Prop := ∀ w', w' ≠ w → c w' < c w

include irrefl in
theorem p8_fixed_no_greatest {F : Type} {σ : F → F} (moves : ∀ x, σ x ≠ x) {c : F → V}
    (fixed : ∀ x, c (σ x) = c x) (w : F) : ¬ GreatestV c w :=
  fun g => irrefl _ ((fixed w) ▸ g (σ w) (moves w))

include irrefl trans in
theorem p8_not_two {F : Type} {c : F → V} {w w' : F} (g : GreatestV c w) (g' : GreatestV c w') :
    ¬ w ≠ w' :=
  fun ne => irrefl _ (trans _ _ _ (g' w ne) (g w' fun e => ne e.symm))

end General

end Probe25a

end Becoming
