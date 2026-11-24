import Becoming.OpenComposition
import Becoming.Reconfiguration
import Becoming.PoolFromCourse

/-!
# Polynomial composition: mode-dependent ports, anchored self-modification, serialized reconfiguration, and coupled-substrate small gain

This module (`AI-written` for Wave U3, `L1`, `0`-axiom `Init`-only core) extends
`Becoming.OpenComposition`, `Becoming.Reconfiguration`, and `Becoming.PoolFromCourse` with:

* **Part 0:** Shared zero-axiom helpers for port-list draw summation (`sumPortDraws`,
  `sumPortDraws_le`, `sumPortDraws_map`, `sumPortDraws_append`) and `Nat` / `distNat` bounds
  (`mul_add_nat`, `div_mono_nat`, `distNat_add_le`, `distNat_sub_le`, `distNat_const_add`,
  `distNat_natMin_le`, `distNat_natMax_le`, `distNat_div_le`).
* **Part 1:** Mode-dependent polynomial components (`PolyComponent`, `PolyContract`), constructive
  `0`-axiom embedding of `OpenComposition.OpenComponent` (`ofOpenComponent`,
  `ofOpenComponent_kernel_iff`), mode-indexed horizontal composition (`compose`, `composeRoute`),
  boundary hiding (`hide`), closed-loop viability (`poly_close_viable`, `poly_close_kernel`,
  `poly_close_kernel_allModes`), and `DynamicPortWitness`.
* **Part 2:** Bridges to `PoolFromCourse` (`poly_poolRead_absent_invariant`,
  `poly_poolWindow_unregistered_stays_blind`), anchored self-modification
  (`AnchoredBase`, `AnchoredInit`, `AnchoredModeAdmit`, `ModeRefines`, `anchoredSelfModComponent`,
  `anchoredSelfModContract`, `anchored_selfMod_viable`, `monotone_selfWidening_viable`), and
  `SelfBlindingDichotomyWitness`.
* **Part 3:** Serialized epoch- and reserve-guarded concurrent reconfiguration
  (`PolyReconfigProposal`, `SerialCoordAct`, `SerialCoordState`, `serialSideAdmit`,
  `SerialReconfigProcess`, `serialReconfig_epoch_stale_on_step`, `serialReconfig_viable`,
  `serialReconfig_kernel`) and `ConcurrentSerialWitness`.
* **Part 4:** Coupled-substrate compositional `LaxSim` and small-gain theorem
  (`OpenPortProcess`, `SubstratePortProcess`, `coupledMacroProcess`, `SubstrateLaxSim`,
  `OpenSubLaxSim`, `jointOneStepGain`, `iterStepGain`, `closedTrace_proj`,
  `coupled_excursion_bound`, `coupled_closed_laxSim`, `coupled_closed_lax_kernel`) and
  `CoupledSmallGainWitness`.

All declarations compile from Lean's prelude alone with empty axiom reports (`0` axioms, complete proofs).
-- AI-written, 24 November 2026
-/

namespace Becoming.PolyComposition

open Generative

/-! ## Part 0: Shared Zero-Axiom Helpers -/

/-- Sum a `Nat`-valued port quantity over a list of ports, returning `f k` definitionally on `[k]`. -/
def sumPortDraws {α : Type} : List α → (α → Nat) → Nat
  | [], _ => 0
  | [a], f => f a
  | a :: b :: rest, f => f a + sumPortDraws (b :: rest) f

theorem sumPortDraws_cons {α : Type} (a : α) (f : α → Nat) :
    ∀ rest : List α, sumPortDraws (a :: rest) f = f a + sumPortDraws rest f
  | [] => (Nat.add_zero (f a)).symm
  | _ :: _ => rfl

theorem sumPortDraws_le {α : Type} {f g : α → Nat} :
    ∀ {ports : List α}, (∀ a, a ∈ ports → f a ≤ g a) →
      sumPortDraws ports f ≤ sumPortDraws ports g
  | [], _ => Nat.le_refl 0
  | [a], h => h a (.head _)
  | a :: _ :: _, h =>
    Nat.add_le_add (h a (.head _)) (sumPortDraws_le fun x mem => h x (.tail _ mem))

theorem sumPortDraws_map {α β : Type} (g : α → β) (f : β → Nat) :
    ∀ ports : List α, sumPortDraws (ports.map g) f = sumPortDraws ports (fun a => f (g a))
  | [] => rfl
  | [_] => rfl
  | a :: b :: rest => congrArg (f (g a) + ·) (sumPortDraws_map g f (b :: rest))

theorem sumPortDraws_append {α : Type} (f : α → Nat) :
    ∀ xs ys : List α, sumPortDraws (xs ++ ys) f = sumPortDraws xs f + sumPortDraws ys f
  | [], ys => (Nat.zero_add (sumPortDraws ys f)).symm
  | [a], [] => (Nat.add_zero (f a)).symm
  | [_], _ :: _ => rfl
  | a :: b :: rest, ys =>
    (congrArg (f a + ·) (sumPortDraws_append f (b :: rest) ys)).trans
      (Nat.add_assoc (f a) (sumPortDraws (b :: rest) f) (sumPortDraws ys f)).symm

theorem le_sumPortDraws_of_mem {α : Type} {a : α} (f : α → Nat) :
    ∀ {ports : List α}, a ∈ ports → f a ≤ sumPortDraws ports f
  | [], mem => absurd mem ListTests.not_mem_nil
  | [_], .head _ => Nat.le_refl _
  | [_], .tail _ mem => absurd mem ListTests.not_mem_nil
  | _ :: _ :: _, .head _ => Nat.le_add_right _ _
  | x :: _ :: _, .tail _ mem =>
    Nat.le_trans (le_sumPortDraws_of_mem f mem) (Nat.le_add_left _ (f x))

/-- Left distributivity of `Nat` multiplication without `propext`. -/
theorem mul_add_nat (a : Nat) : ∀ b c : Nat, a * (b + c) = a * b + a * c
  | _, 0 => rfl
  | b, c + 1 =>
    (Nat.mul_succ a (b + c)).trans
      ((congrArg (· + a) (mul_add_nat a b c)).trans
        ((Nat.add_assoc (a * b) (a * c) a).trans
          (congrArg (a * b + ·) (Nat.mul_succ a c).symm)))

/-- Monotonicity of Euclidean division on `Nat` without `propext`. -/
theorem div_mono_nat {a b : Nat} (hle : a ≤ b) : ∀ k : Nat, a / k ≤ b / k
  | 0 => by
    change a.div 0 ≤ b.div 0
    rw [Nat.div.eq_1 a 0, Nat.div.eq_1 b 0,
        CoreHelpers.dite_neg' (Nat.lt_irrefl 0), CoreHelpers.dite_neg' (Nat.lt_irrefl 0)]
    exact Nat.le_refl 0
  | k + 1 => by
    have hk : 0 < k + 1 := Nat.succ_pos k
    have da := CoreHelpers.div_mod_decomp hk a
    have db := CoreHelpers.div_mod_decomp hk b
    cases Nat.lt_or_ge (b / (k + 1)) (a / (k + 1)) with
    | inr ge => exact ge
    | inl lt =>
      have hsucc : b / (k + 1) + 1 ≤ a / (k + 1) := lt
      have hmul : (b / (k + 1)) * (k + 1) + (k + 1) ≤ (a / (k + 1)) * (k + 1) := by
        rw [← Nat.succ_mul]
        exact Nat.mul_le_mul_right (k + 1) hsucc
      have hlt : b < a := by
        calc b = (b / (k + 1)) * (k + 1) + b % (k + 1) := db.1
          _ < (b / (k + 1)) * (k + 1) + (k + 1) := Nat.add_lt_add_left db.2 _
          _ ≤ (a / (k + 1)) * (k + 1) := hmul
          _ ≤ (a / (k + 1)) * (k + 1) + a % (k + 1) := Nat.le_add_right _ _
          _ = a := da.1.symm
      exact absurd hle (Nat.not_le_of_gt hlt)

theorem sub_add_le_add_sub_nat (a b c d : Nat) : (a + c) - (b + d) ≤ (a - b) + (c - d) := by
  have ha : a ≤ (a - b) + b := CoreHelpers.le_sub_add_nat a b
  have hc : c ≤ (c - d) + d := CoreHelpers.le_sub_add_nat c d
  have hac : a + c ≤ ((a - b) + (c - d)) + (b + d) :=
    Nat.le_trans (Nat.add_le_add ha hc)
      (Nat.le_of_eq (Nat.add_add_add_comm (a - b) b (c - d) d))
  exact Naturals.sub_le_of_le_add (Nat.add_comm ((a - b) + (c - d)) (b + d) ▸ hac)

theorem distNat_add_le (a b c d : Nat) : distNat (a + c) (b + d) ≤ distNat a b + distNat c d :=
  Nat.le_trans
    (Nat.add_le_add (sub_add_le_add_sub_nat a b c d) (sub_add_le_add_sub_nat b a d c))
    (Nat.le_of_eq (Nat.add_add_add_comm (a - b) (c - d) (b - a) (d - c)))

theorem sub_sub_le_add_sub_nat (a b c d : Nat) : (a - c) - (b - d) ≤ (a - b) + (d - c) := by
  have h1 : a ≤ (a - b) + b := CoreHelpers.le_sub_add_nat a b
  have h2 : b ≤ (b - d) + d := CoreHelpers.le_sub_add_nat b d
  have h3 : d ≤ (d - c) + c := CoreHelpers.le_sub_add_nat d c
  have h4 : a ≤ (a - b) + ((b - d) + ((d - c) + c)) :=
    Nat.le_trans h1 (Nat.add_le_add_left (Nat.le_trans h2 (Nat.add_le_add_left h3 (b - d))) (a - b))
  have h5 : a ≤ ((a - b) + (d - c)) + (c + (b - d)) := by
    refine Nat.le_trans h4 (Nat.le_of_eq ?_)
    calc (a - b) + ((b - d) + ((d - c) + c))
        = (a - b) + (((b - d) + (d - c)) + c) := congrArg ((a - b) + ·) (Nat.add_assoc _ _ _).symm
      _ = (a - b) + (((d - c) + (b - d)) + c) := congrArg (fun x => (a - b) + (x + c)) (Nat.add_comm _ _)
      _ = (a - b) + ((d - c) + ((b - d) + c)) := congrArg ((a - b) + ·) (Nat.add_assoc _ _ _)
      _ = ((a - b) + (d - c)) + ((b - d) + c) := (Nat.add_assoc _ _ _).symm
      _ = ((a - b) + (d - c)) + (c + (b - d)) := congrArg (((a - b) + (d - c)) + ·) (Nat.add_comm _ _)
  rw [Naturals.sub_sub a c (b - d)]
  exact Naturals.sub_le_of_le_add (Nat.add_comm ((a - b) + (d - c)) (c + (b - d)) ▸ h5)

theorem distNat_sub_le (a b c d : Nat) : distNat (a - c) (b - d) ≤ distNat a b + distNat c d := by
  have h1 := sub_sub_le_add_sub_nat a b c d
  have h2 := sub_sub_le_add_sub_nat b a d c
  refine Nat.le_trans (Nat.add_le_add h1 h2) (Nat.le_of_eq ?_)
  calc ((a - b) + (d - c)) + ((b - a) + (c - d))
      = ((a - b) + (b - a)) + ((d - c) + (c - d)) := Nat.add_add_add_comm _ _ _ _
    _ = distNat a b + distNat c d := congrArg (distNat a b + ·) (Nat.add_comm _ _)

theorem const_add_sub (c a b : Nat) : (c + a) - (c + b) = a - b := by
  induction c with
  | zero => rw [Nat.zero_add, Nat.zero_add]
  | succ c ih =>
    rw [Nat.succ_add, Nat.succ_add, Nat.succ_sub_succ]
    exact ih

theorem distNat_const_add (c a b : Nat) : distNat (c + a) (c + b) = distNat a b := by
  unfold distNat
  rw [const_add_sub c a b, const_add_sub c b a]

theorem natMin_sub_le (a b c d : Nat) :
    CoreHelpers.natMin a c - CoreHelpers.natMin b d ≤ CoreHelpers.natMax (a - b) (c - d) := by
  cases h : Nat.decLe b d with
  | isTrue hbd =>
    rw [CoreHelpers.natMin_eq_left hbd]
    exact Nat.le_trans (Nat.sub_le_sub_right (CoreHelpers.natMin_le_left a c) b)
      (CoreHelpers.le_natMax_left (a - b) (c - d))
  | isFalse hn =>
    have hdb : d ≤ b := Nat.le_of_lt (Nat.gt_of_not_le hn)
    rw [CoreHelpers.natMin_eq_right hdb]
    exact Nat.le_trans (Nat.sub_le_sub_right (CoreHelpers.natMin_le_right a c) d)
      (CoreHelpers.le_natMax_right (a - b) (c - d))

theorem distNat_natMin_le (a b c d : Nat) :
    distNat (CoreHelpers.natMin a c) (CoreHelpers.natMin b d) ≤
      CoreHelpers.natMax (distNat a b) (distNat c d) := by
  cases Nat.le_total (CoreHelpers.natMin a c) (CoreHelpers.natMin b d) with
  | inl le =>
    unfold distNat
    rw [sub_eq_zero_of_le le, Nat.zero_add]
    exact Nat.le_trans (natMin_sub_le b a d c)
      (CoreHelpers.natMax_le
        (Nat.le_trans (Nat.le_add_left (b - a) (a - b)) (CoreHelpers.le_natMax_left _ _))
        (Nat.le_trans (Nat.le_add_left (d - c) (c - d)) (CoreHelpers.le_natMax_right _ _)))
  | inr ge =>
    unfold distNat
    rw [sub_eq_zero_of_le ge, Nat.add_zero]
    exact Nat.le_trans (natMin_sub_le a b c d)
      (CoreHelpers.natMax_le
        (Nat.le_trans (Nat.le_add_right (a - b) (b - a)) (CoreHelpers.le_natMax_left _ _))
        (Nat.le_trans (Nat.le_add_right (c - d) (d - c)) (CoreHelpers.le_natMax_right _ _)))

theorem distNat_natMin_const_le (m a b : Nat) :
    distNat (CoreHelpers.natMin m a) (CoreHelpers.natMin m b) ≤ distNat a b := by
  have h := distNat_natMin_le m m a b
  rw [distNat_self m] at h
  exact Nat.le_trans h (CoreHelpers.natMax_le (Nat.zero_le _) (Nat.le_refl _))

theorem natMax_sub_le (a b c d : Nat) :
    CoreHelpers.natMax a c - CoreHelpers.natMax b d ≤ CoreHelpers.natMax (a - b) (c - d) := by
  cases Nat.decLe a c with
  | isTrue hac =>
    rw [show CoreHelpers.natMax a c = c from if_pos hac]
    exact Nat.le_trans (Naturals.sub_antitone c (CoreHelpers.le_natMax_right b d))
      (CoreHelpers.le_natMax_right (a - b) (c - d))
  | isFalse hn =>
    rw [show CoreHelpers.natMax a c = a from if_neg hn]
    exact Nat.le_trans (Naturals.sub_antitone a (CoreHelpers.le_natMax_left b d))
      (CoreHelpers.le_natMax_left (a - b) (c - d))

theorem distNat_natMax_le (a b c d : Nat) :
    distNat (CoreHelpers.natMax a c) (CoreHelpers.natMax b d) ≤
      CoreHelpers.natMax (distNat a b) (distNat c d) := by
  cases Nat.le_total (CoreHelpers.natMax a c) (CoreHelpers.natMax b d) with
  | inl le =>
    unfold distNat
    rw [sub_eq_zero_of_le le, Nat.zero_add]
    exact Nat.le_trans (natMax_sub_le b a d c)
      (CoreHelpers.natMax_le
        (Nat.le_trans (Nat.le_add_left (b - a) (a - b)) (CoreHelpers.le_natMax_left _ _))
        (Nat.le_trans (Nat.le_add_left (d - c) (c - d)) (CoreHelpers.le_natMax_right _ _)))
  | inr ge =>
    unfold distNat
    rw [sub_eq_zero_of_le ge, Nat.add_zero]
    exact Nat.le_trans (natMax_sub_le a b c d)
      (CoreHelpers.natMax_le
        (Nat.le_trans (Nat.le_add_right (a - b) (b - a)) (CoreHelpers.le_natMax_left _ _))
        (Nat.le_trans (Nat.le_add_right (c - d) (d - c)) (CoreHelpers.le_natMax_right _ _)))

theorem distNat_natMax_const_le (m a b : Nat) :
    distNat (CoreHelpers.natMax m a) (CoreHelpers.natMax m b) ≤ distNat a b := by
  have h := distNat_natMax_le m m a b
  rw [distNat_self m] at h
  exact Nat.le_trans h (CoreHelpers.natMax_le (Nat.zero_le _) (Nat.le_refl _))

theorem add_div_le_nat {k : Nat} (hk : 0 < k) (b d : Nat) :
    (b + d) / k ≤ b / k + (d + (k - 1)) / k := by
  obtain ⟨hb_eq, hrb⟩ := CoreHelpers.div_mod_decomp hk b
  obtain ⟨hd_eq, hrd⟩ := CoreHelpers.div_mod_decomp hk d
  let qb := b / k
  let rb := b % k
  let qd := d / k
  have hk_pred : k - 1 < k := by
    cases k with
    | zero => exact absurd hk (Nat.lt_irrefl 0)
    | succ k' => exact Nat.lt_succ_self k'
  cases h_rd : d % k with
  | zero =>
    rw [h_rd] at hd_eq
    have hd0 : d = qd * k := hd_eq
    have hsum : b + d = (qb + qd) * k + rb := by
      calc b + d = (qb * k + rb) + qd * k := congr (congrArg (· + ·) hb_eq) hd0
        _ = (qb * k + qd * k) + rb := Nat.add_right_comm _ _ _
        _ = (qb + qd) * k + rb := congrArg (· + rb) (Becoming.add_mul_split qb qd k).symm
    have hdiv1 : (b + d) / k = qb + qd := by
      rw [hsum]
      exact CoreHelpers.div_mul_add_rem hk hrb (qb + qd)
    have hdiv2 : (d + (k - 1)) / k = qd := by
      rw [hd0]
      exact CoreHelpers.div_mul_add_rem hk hk_pred qd
    rw [hdiv1, hdiv2]
    exact Nat.le_refl _
  | succ rd' =>
    rw [h_rd] at hd_eq hrd
    have hsum_rd : k ≤ (rd' + 1) + (k - 1) := by
      calc k = 1 + (k - 1) := (Naturals.add_sub_of_le hk).symm
        _ ≤ (rd' + 1) + (k - 1) := Nat.add_le_add_right (Nat.succ_le_succ (Nat.zero_le rd')) _
    have hk1 : k = (k - 1) + 1 :=
      (Naturals.add_sub_of_le hk).symm.trans (Nat.add_comm 1 (k - 1))
    have h2 : k + k = (k - 1) + k + 1 := by
      calc k + k = ((k - 1) + 1) + k := congrArg (· + k) hk1
        _ = (k - 1) + (1 + k) := Nat.add_assoc _ _ _
        _ = (k - 1) + (k + 1) := congrArg ((k - 1) + ·) (Nat.add_comm 1 k)
        _ = (k - 1) + k + 1 := (Nat.add_assoc _ _ _).symm
    have hrem_rd : (rd' + 1) + (k - 1) - k < k := by
      have hlt : (rd' + 1) + (k - 1) < k + k := Nat.add_lt_add hrd hk_pred
      have h3 : (rd' + 1) + (k - 1) + 1 ≤ (k - 1) + k + 1 := h2 ▸ hlt
      have hle : (rd' + 1) + (k - 1) ≤ k + (k - 1) :=
        Nat.add_comm (k - 1) k ▸ Nat.le_of_succ_le_succ h3
      exact Nat.lt_of_le_of_lt (Naturals.sub_le_of_le_add hle) hk_pred
    have hd_succ : (d + (k - 1)) / k = qd + 1 := by
      have eq1 : d + (k - 1) = (qd + 1) * k + ((rd' + 1) + (k - 1) - k) := by
        calc d + (k - 1) = (qd * k + (rd' + 1)) + (k - 1) := congrArg (· + (k - 1)) hd_eq
          _ = qd * k + ((rd' + 1) + (k - 1)) := Nat.add_assoc _ _ _
          _ = qd * k + (k + ((rd' + 1) + (k - 1) - k)) :=
              congrArg (qd * k + ·) (Naturals.add_sub_of_le hsum_rd).symm
          _ = (qd * k + k) + ((rd' + 1) + (k - 1) - k) := (Nat.add_assoc _ _ _).symm
          _ = (qd + 1) * k + ((rd' + 1) + (k - 1) - k) :=
              congrArg (· + _) (Nat.succ_mul qd k).symm
      rw [eq1]
      exact CoreHelpers.div_mul_add_rem hk hrem_rd (qd + 1)
    have hsum : b + d = (qb + qd) * k + (rb + (rd' + 1)) := by
      calc b + d = (qb * k + rb) + (qd * k + (rd' + 1)) := congr (congrArg (· + ·) hb_eq) hd_eq
        _ = (qb * k + qd * k) + (rb + (rd' + 1)) := Nat.add_add_add_comm _ _ _ _
        _ = (qb + qd) * k + (rb + (rd' + 1)) := congrArg (· + _) (Becoming.add_mul_split qb qd k).symm
    cases Nat.lt_or_ge (rb + (rd' + 1)) k with
    | inl lt =>
      rw [hsum, CoreHelpers.div_mul_add_rem hk lt (qb + qd), hd_succ]
      exact Nat.le_succ _
    | inr ge =>
      have hlt2 : rb + (rd' + 1) < k + k := Nat.add_lt_add hrb hrd
      have hrem2 : rb + (rd' + 1) - k < k := by
        have h3 : rb + (rd' + 1) + 1 ≤ (k - 1) + k + 1 := h2 ▸ hlt2
        have hle : rb + (rd' + 1) ≤ k + (k - 1) :=
          Nat.add_comm (k - 1) k ▸ Nat.le_of_succ_le_succ h3
        exact Nat.lt_of_le_of_lt (Naturals.sub_le_of_le_add hle) hk_pred
      have hsum2 : b + d = (qb + qd + 1) * k + (rb + (rd' + 1) - k) := by
        calc b + d = (qb + qd) * k + (rb + (rd' + 1)) := hsum
          _ = (qb + qd) * k + (k + (rb + (rd' + 1) - k)) :=
              congrArg ((qb + qd) * k + ·) (Naturals.add_sub_of_le ge).symm
          _ = ((qb + qd) * k + k) + (rb + (rd' + 1) - k) := (Nat.add_assoc _ _ _).symm
          _ = (qb + qd + 1) * k + (rb + (rd' + 1) - k) :=
              congrArg (· + _) (Nat.succ_mul (qb + qd) k).symm
      rw [hsum2, CoreHelpers.div_mul_add_rem hk hrem2 (qb + qd + 1), hd_succ, Nat.add_assoc]
      exact Nat.le_refl _

theorem div_sub_le_nat {k : Nat} (hk : 0 < k) {a b : Nat} (le : b ≤ a) :
    a / k - b / k ≤ (a - b + (k - 1)) / k := by
  have ha : a = b + (a - b) := (Naturals.add_sub_of_le le).symm
  have h1 : a / k ≤ b / k + (a - b + (k - 1)) / k :=
    Nat.le_trans (Nat.le_of_eq (congrArg (· / k) ha)) (add_div_le_nat hk b (a - b))
  exact Naturals.sub_le_of_le_add h1

theorem distNat_div_le (a b : Nat) : ∀ k : Nat, distNat (a / k) (b / k) ≤ (distNat a b + (k - 1)) / k
  | 0 => by
    change distNat (a.div 0) (b.div 0) ≤ _
    rw [Nat.div.eq_1 a 0, Nat.div.eq_1 b 0,
        CoreHelpers.dite_neg' (Nat.lt_irrefl 0), CoreHelpers.dite_neg' (Nat.lt_irrefl 0),
        distNat_self 0]
    exact Nat.zero_le _
  | k + 1 => by
    have hk : 0 < k + 1 := Nat.succ_pos k
    cases Nat.le_total a b with
    | inl le =>
      have hdiv : a / (k + 1) ≤ b / (k + 1) := div_mono_nat le (k + 1)
      have heq1 : distNat (a / (k + 1)) (b / (k + 1)) = b / (k + 1) - a / (k + 1) := by
        unfold distNat
        rw [sub_eq_zero_of_le hdiv, Nat.zero_add]
      have heq2 : distNat a b = b - a := by
        unfold distNat
        rw [sub_eq_zero_of_le le, Nat.zero_add]
      rw [heq1, heq2]
      exact div_sub_le_nat hk le
    | inr ge =>
      have hdiv : b / (k + 1) ≤ a / (k + 1) := div_mono_nat ge (k + 1)
      have heq1 : distNat (a / (k + 1)) (b / (k + 1)) = a / (k + 1) - b / (k + 1) := by
        unfold distNat
        rw [sub_eq_zero_of_le hdiv, Nat.add_zero]
      have heq2 : distNat a b = a - b := by
        unfold distNat
        rw [sub_eq_zero_of_le ge, Nat.add_zero]
      rw [heq1, heq2]
      exact div_sub_le_nat hk ge

/-! ## Part 1: Mode-Dependent Polynomial Components, `OpenComposition` Embedding, & Dynamic Reconfiguration -/

/-- A mode-dependent polynomial adaptive component whose internal state `S m`, observation `Obs m`,
disturbance `Dist m`, internal ports `Int m`, and exposed ports `Ext m` depend on its current mode
`m : Mode`, and whose step `next` may dynamically switch modes. -/
structure PolyComponent (Mode : Type) (S Obs Dist Int Ext : Mode → Type) where
  next : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m'
  drawInt : (p : Σ m, S m) → Int p.1 → Nat
  drawExt : (p : Σ m, S m) → Ext p.1 → Nat
  emitAlarm : (m : Mode) → S m → Obs m → Bool
  silenceLoad : (p : Σ m, S m) → Nat
  favours : (p : Σ m, S m) → Prop

/-- The disturbed transition process of a `PolyComponent`. -/
def PolyComponent.process {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (tol : (m : Mode) → Obs m × Bool → Dist m → Prop) :
    Process (Σ m, S m) (Σ m, (Obs m × Bool) × Dist m) where
  step p a p' :=
    ∃ hm : a.1 = p.1,
      tol p.1 (hm ▸ a.2.1) (hm ▸ a.2.2) ∧
      p' = C.next p (hm ▸ a.2.1) (hm ▸ a.2.2)

/-- An assume-guarantee contract over a `PolyComponent` from initial configuration `init : Σ m, S m`. -/
structure PolyContract {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (C : PolyComponent Mode S Obs Dist Int Ext) (init : Σ m, S m) where
  tol : (m : Mode) → Obs m × Bool → Dist m → Prop
  warnObs : (m : Mode) → Obs m → Prop
  preCapInt : (m : Mode) → Int m → Nat
  preCapExt : (m : Mode) → Ext m → Nat
  postAllowanceInt : (m : Mode) → Int m → Nat
  postAllowanceExt : (m : Mode) → Ext m → Nat
  maxSilence : Mode → Nat
  maxLag : Mode → Nat
  K : (Σ m, S m) → Prop
  eta : (Σ m, S m) → Nat
  init_in : K init
  cert : Viability.Certificate (C.process tol)
    (fun p =>
      (∀ j, C.drawInt p j ≤ preCapInt p.1 j) ∧
      (∀ k, C.drawExt p k ≤ preCapExt p.1 k) ∧
      C.silenceLoad p ≤ maxSilence p.1 ∧
      (eta p = 0 → ¬ C.favours p ∧
        (∀ j, C.drawInt p j ≤ postAllowanceInt p.1 j) ∧
        (∀ k, C.drawExt p k ≤ postAllowanceExt p.1 k))) K
  eta_bound : ∀ p, K p → eta p ≤ maxLag p.1
  emits_on_warn : ∀ m s obs, K ⟨m, s⟩ → warnObs m obs → C.emitAlarm m s obs = true
  eta_alarm_step : ∀ m s obs dist, tol m (obs, true) dist → K ⟨m, s⟩ → 0 < eta ⟨m, s⟩ →
    eta (C.next ⟨m, s⟩ (obs, true) dist) < eta ⟨m, s⟩
  eta_alarm_zero : ∀ m s obs dist, tol m (obs, true) dist → K ⟨m, s⟩ → eta ⟨m, s⟩ = 0 →
    eta (C.next ⟨m, s⟩ (obs, true) dist) = 0

/-- Total boundary draw routed from a `PolyComponent` onto substrate site `site`. -/
def polySiteDraw {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    (p : Σ m, S m) (site : Site) : Nat :=
  sumPortDraws (route p.1 site) (C.drawExt p)

/-- One closed-loop step of a `PolyComponent` interacting with a coupled site-indexed substrate `G`,
routing external ports along `route p.1 site`. -/
def polyClosedStep {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat)
    (st : (Site → Nat) × (Σ m, S m))
    (act : Env × Dist st.2.1) :
    (Site → Nat) × (Σ m, S m) :=
  let o := obs st.2.1 st.1
  let al := channel (C.emitAlarm st.2.1 st.2.2 o) (C.silenceLoad st.2) act.1
  let H := fun site => polySiteDraw C route st.2 site + envDraw act.1 site
  (RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H st.1,
   C.next st.2 (o, al) act.2)

/-- Closed-loop transition process of a `PolyComponent` carrying a `PolyContract`. -/
def polyClosedProcess {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m}
    (c : PolyContract C init)
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat)
    (jointAdm : Env → Prop) :
    Process ((Site → Nat) × (Σ m, S m)) (Env × (Σ m, Dist m)) where
  step st act st' :=
    ∃ hm : act.2.1 = st.2.1,
      jointAdm act.1 ∧
      (∀ ob, c.tol st.2.1 ob (hm ▸ act.2.2)) ∧
      st' = polyClosedStep C route obs channel G envDraw st (act.1, hm ▸ act.2.2)

/-- Viability guard for a closed `PolyComponent` (port draw caps are checked per port, no unused `route`). -/
def polyClosedGuard {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    {init : Σ m, S m}
    (c : PolyContract C init)
    (x_crit : Site → Nat)
    (st : (Site → Nat) × (Σ m, S m)) : Prop :=
  (∀ site, x_crit site ≤ st.1 site) ∧
  (∀ j, C.drawInt st.2 j ≤ c.preCapInt st.2.1 j) ∧
  (∀ k, C.drawExt st.2 k ≤ c.preCapExt st.2.1 k) ∧
  C.silenceLoad st.2 ≤ c.maxSilence st.2.1 ∧
  (c.eta st.2 = 0 → ¬ C.favours st.2 ∧
    (∀ j, C.drawInt st.2 j ≤ c.postAllowanceInt st.2.1 j) ∧
    (∀ k, C.drawExt st.2 k ≤ c.postAllowanceExt st.2.1 k))

/-- Inductive lag-margin invariant for a closed `PolyComponent` relative to site envelope `sitePreCap`. -/
def polyClosedInv {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site : Type}
    {C : PolyComponent Mode S Obs Dist Int Ext} {init : Σ m, S m}
    (c : PolyContract C init)
    (sitePreCap envCap x_crit : Site → Nat)
    (st : (Site → Nat) × (Σ m, S m)) : Prop :=
  c.K st.2 ∧ ∀ site, x_crit site + c.eta st.2 * (sitePreCap site + envCap site) ≤ st.1 site

/-! ### Exact `0`-Axiom Embedding of `OpenComposition.OpenComponent` -/

/-- Lift an `OpenComposition.OpenComponent` to a single-mode (`Mode := Unit`) `PolyComponent`. -/
def PolyComponent.ofOpenComponent {S Obs Dist Int Ext : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) :
    PolyComponent Unit (fun _ => S) (fun _ => Obs) (fun _ => Dist) (fun _ => Int) (fun _ => Ext) where
  next p oa d := ⟨(), C.next p.2 oa d⟩
  drawInt p j := C.drawInt p.2 j
  drawExt p k := C.drawExt p.2 k
  emitAlarm _ s o := C.emitAlarm s o
  silenceLoad p := C.silenceLoad p.2
  favours p := C.favours p.2

/-- Lift an `OpenComposition.InterfaceContract` to a `PolyContract` on `ofOpenComponent`. -/
def PolyContract.ofInterfaceContract {S Obs Dist Int Ext : Type}
    {C : OpenComposition.OpenComponent S Obs Dist Int Ext} {init : S}
    (c : OpenComposition.InterfaceContract C init) :
    PolyContract (PolyComponent.ofOpenComponent C) ⟨(), init⟩ where
  tol _ := c.tol
  warnObs _ := c.warnObs
  preCapInt _ := c.preCapInt
  preCapExt _ := c.preCapExt
  postAllowanceInt _ := c.postBudgetInt
  postAllowanceExt _ := c.postBudgetExt
  maxSilence _ := c.maxSilence
  maxLag _ := c.maxLag
  K p := c.K p.2
  eta p := c.eta p.2
  init_in := c.init_in
  cert :=
    ⟨fun p hp => c.cert.within p.2 hp,
     fun p a p' step hp => by
       obtain ⟨m, s⟩ := p
       obtain ⟨m', oa, d⟩ := a
       obtain ⟨hm, htol, heq⟩ := step
       cases hm
       cases m
       subst heq
       exact c.cert.closed s (oa, d) _ ⟨htol, rfl⟩ hp⟩
  eta_bound p hp := c.eta_bound p.2 hp
  emits_on_warn _ s o hs hw := c.emits_on_warn s o hs hw
  eta_alarm_step _ s o d htol hs pos := c.eta_alarm_step s o d htol hs pos
  eta_alarm_zero _ s o d htol hs h0 := c.eta_alarm_zero s o d htol hs h0

def ofOpenState {S Ext : Type} (st : (Ext → Nat) × S) : (Ext → Nat) × (Σ _ : Unit, S) :=
  (st.1, ⟨(), st.2⟩)

def toOpenState {S Ext : Type} (st : (Ext → Nat) × (Σ _ : Unit, S)) : (Ext → Nat) × S :=
  (st.1, st.2.2)

theorem ofOpenState_toOpenState {S Ext : Type} :
    ∀ st : (Ext → Nat) × (Σ _ : Unit, S), ofOpenState (toOpenState st) = st
  | (_, ⟨(), _⟩) => rfl

theorem ofOpenComponent_closedStep_eq {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (st : (Ext → Nat) × S) (act : Env × Dist) :
    polyClosedStep (PolyComponent.ofOpenComponent C) (fun _ k => [k]) (fun _ => obs)
        channel G envDraw (ofOpenState st) act =
      ofOpenState (OpenComposition.closedStep C obs channel G envDraw st act) :=
  rfl

theorem ofOpenComponent_closedProcess_step_iff {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop)
    (st st' : (Ext → Nat) × (Σ _ : Unit, S)) (act : Env × (Σ _ : Unit, Dist)) :
    (polyClosedProcess (PolyComponent.ofOpenComponent C) (fun _ k => [k])
        (PolyContract.ofInterfaceContract c) (fun _ => obs) channel G envDraw jointAdm).step
        st act st' ↔
      (OpenComposition.closedProcess C c obs channel G envDraw jointAdm).step
        (toOpenState st) (act.1, act.2.2) (toOpenState st') := by
  obtain ⟨x, ⟨m, s⟩⟩ := st
  obtain ⟨x', ⟨m', s'⟩⟩ := st'
  obtain ⟨env, ⟨ma, d⟩⟩ := act
  constructor
  · intro hstep
    obtain ⟨hm, hadm, htol, heq⟩ := hstep
    -- CRITICAL: run `cases hm` BEFORE `cases m`/`m'` so no Streicher K!
    cases hm
    cases m
    cases m'
    refine ⟨⟨hadm, htol⟩, ?_⟩
    exact congrArg toOpenState heq
  · intro hstep
    obtain ⟨⟨hadm, htol⟩, heq⟩ := hstep
    cases m
    cases m'
    cases ma
    refine ⟨rfl, hadm, htol, ?_⟩
    exact congrArg ofOpenState heq

theorem ofOpenComponent_trace_to_poly {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop) :
    ∀ {st st' : (Ext → Nat) × S} {w : List (Env × Dist)},
      Trace (OpenComposition.closedProcess C c obs channel G envDraw jointAdm) st w st' →
      Trace (polyClosedProcess (PolyComponent.ofOpenComponent C) (fun _ k => [k])
          (PolyContract.ofInterfaceContract c) (fun _ => obs) channel G envDraw jointAdm)
        (ofOpenState st) (w.map fun a => (a.1, ⟨(), a.2⟩)) (ofOpenState st')
  | st, _, [], .nil _ => .nil (ofOpenState st)
  | st, _, a :: _, .cons hstep htr =>
    .cons
      ((ofOpenComponent_closedProcess_step_iff C c obs channel G envDraw jointAdm
          (ofOpenState st) (ofOpenState _) (a.1, ⟨(), a.2⟩)).mpr hstep)
      (ofOpenComponent_trace_to_poly C c obs channel G envDraw jointAdm htr)

theorem ofOpenComponent_trace_from_poly {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop) :
    ∀ {st st' : (Ext → Nat) × (Σ _ : Unit, S)} {w : List (Env × (Σ _ : Unit, Dist))},
      Trace (polyClosedProcess (PolyComponent.ofOpenComponent C) (fun _ k => [k])
          (PolyContract.ofInterfaceContract c) (fun _ => obs) channel G envDraw jointAdm)
        st w st' →
      Trace (OpenComposition.closedProcess C c obs channel G envDraw jointAdm)
        (toOpenState st) (w.map fun a => (a.1, a.2.2)) (toOpenState st')
  | st, _, [], .nil _ => .nil (toOpenState st)
  | st, _, a :: _, .cons hstep htr =>
    .cons
      ((ofOpenComponent_closedProcess_step_iff C c obs channel G envDraw jointAdm
          st _ a).mp hstep)
      (ofOpenComponent_trace_from_poly C c obs channel G envDraw jointAdm htr)

theorem ofOpenComponent_trace_iff {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop)
    (st st' : (Ext → Nat) × S) (w : List (Env × Dist)) :
    Trace (OpenComposition.closedProcess C c obs channel G envDraw jointAdm) st w st' ↔
      Trace (polyClosedProcess (PolyComponent.ofOpenComponent C) (fun _ k => [k])
          (PolyContract.ofInterfaceContract c) (fun _ => obs) channel G envDraw jointAdm)
        (ofOpenState st) (w.map fun a => (a.1, ⟨(), a.2⟩)) (ofOpenState st') :=
  ⟨ofOpenComponent_trace_to_poly C c obs channel G envDraw jointAdm, fun htr => by
    have h1 := ofOpenComponent_trace_from_poly C c obs channel G envDraw jointAdm htr
    have hmap : ((w.map fun a : Env × Dist => (a.1, (⟨(), a.2⟩ : Σ _ : Unit, Dist))).map
        fun a : Env × Σ _ : Unit, Dist => (a.1, a.2.2)) = w := by
      rw [map_comp_eq]
      exact (map_eq_of (fun a => rfl) w).trans (by
        clear htr h1
        induction w with
        | nil => rfl
        | cons x xs ih => exact congrArg (x :: ·) ih)
    exact hmap ▸ h1⟩

def ofOpenComponent_run_to_poly {S Obs Dist Int Ext Env : Type}
    {C : OpenComposition.OpenComponent S Obs Dist Int Ext} {init : S}
    {c : OpenComposition.InterfaceContract C init}
    {obs : (Ext → Nat) → Obs} {channel : Bool → Nat → Env → Bool}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    (r : Run (OpenComposition.closedProcess C c obs channel G envDraw jointAdm)) :
    Run (polyClosedProcess (PolyComponent.ofOpenComponent C) (fun _ k => [k])
      (PolyContract.ofInterfaceContract c) (fun _ => obs) channel G envDraw jointAdm) where
  state n := ofOpenState (r.state n)
  act n := ((r.act n).1, ⟨(), (r.act n).2⟩)
  step n :=
    (ofOpenComponent_closedProcess_step_iff C c obs channel G envDraw jointAdm
      (ofOpenState (r.state n)) (ofOpenState (r.state (n + 1)))
      ((r.act n).1, ⟨(), (r.act n).2⟩)).mpr (r.step n)

def ofOpenComponent_run_from_poly {S Obs Dist Int Ext Env : Type}
    {C : OpenComposition.OpenComponent S Obs Dist Int Ext} {init : S}
    {c : OpenComposition.InterfaceContract C init}
    {obs : (Ext → Nat) → Obs} {channel : Bool → Nat → Env → Bool}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    (r : Run (polyClosedProcess (PolyComponent.ofOpenComponent C) (fun _ k => [k])
      (PolyContract.ofInterfaceContract c) (fun _ => obs) channel G envDraw jointAdm)) :
    Run (OpenComposition.closedProcess C c obs channel G envDraw jointAdm) where
  state n := toOpenState (r.state n)
  act n := ((r.act n).1, (r.act n).2.2)
  step n :=
    (ofOpenComponent_closedProcess_step_iff C c obs channel G envDraw jointAdm
      (r.state n) (r.state (n + 1)) (r.act n)).mp (r.step n)

theorem ofOpenComponent_guard_iff {S Obs Dist Int Ext : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (x_crit : Ext → Nat)
    (st : (Ext → Nat) × (Σ _ : Unit, S)) :
    polyClosedGuard (PolyComponent.ofOpenComponent C) (PolyContract.ofInterfaceContract c) x_crit st ↔
      OpenComposition.closedGuard C c x_crit (toOpenState st) := by
  obtain ⟨x, ⟨m, s⟩⟩ := st
  cases m
  exact Iff.rfl

theorem ofOpenComponent_kernel_iff {S Obs Dist Int Ext Env : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext) {init : S}
    (c : OpenComposition.InterfaceContract C init)
    (obs : (Ext → Nat) → Obs)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop)
    (x_crit : Ext → Nat)
    (st : (Ext → Nat) × S) :
    Viability.Kernel (OpenComposition.closedProcess C c obs channel G envDraw jointAdm)
        (OpenComposition.closedGuard C c x_crit) st ↔
      Viability.Kernel
        (polyClosedProcess (PolyComponent.ofOpenComponent C) (fun _ k => [k])
          (PolyContract.ofInterfaceContract c) (fun _ => obs) channel G envDraw jointAdm)
        (polyClosedGuard (PolyComponent.ofOpenComponent C) (PolyContract.ofInterfaceContract c) x_crit)
        (ofOpenState st) := by
  constructor
  · intro kern st' ⟨w, tr⟩
    have trOpen := ofOpenComponent_trace_from_poly C c obs channel G envDraw jointAdm tr
    exact (ofOpenComponent_guard_iff C c x_crit st').mpr (kern (toOpenState st') ⟨_, trOpen⟩)
  · intro kern st' ⟨w, tr⟩
    have trPoly := (ofOpenComponent_trace_iff C c obs channel G envDraw jointAdm st st' w).mp tr
    exact (ofOpenComponent_guard_iff C c x_crit (ofOpenState st')).mp (kern (ofOpenState st') ⟨_, trPoly⟩)

/-! ### Horizontal Composition & Boundary Hiding for `PolyComponent` -/

/-- Horizontal gluing of two `PolyComponent`s across mode product `Mode₁ × Mode₂`. -/
def PolyComponent.compose
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    (A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁)
    (B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂) :
    PolyComponent (Mode₁ × Mode₂)
      (fun m => S₁ m.1 × S₂ m.2)
      (fun m => Obs₁ m.1 × Obs₂ m.2)
      (fun m => Dist₁ m.1 × Dist₂ m.2)
      (fun m => Sum (Int₁ m.1) (Int₂ m.2))
      (fun m => Sum (Ext₁ m.1) (Ext₂ m.2)) where
  next p oa d :=
    let p₁ := A.next ⟨p.1.1, p.2.1⟩ (oa.1.1, oa.2) d.1
    let p₂ := B.next ⟨p.1.2, p.2.2⟩ (oa.1.2, oa.2) d.2
    ⟨(p₁.1, p₂.1), (p₁.2, p₂.2)⟩
  drawInt p
    | .inl j₁ => A.drawInt ⟨p.1.1, p.2.1⟩ j₁
    | .inr j₂ => B.drawInt ⟨p.1.2, p.2.2⟩ j₂
  drawExt p
    | .inl k₁ => A.drawExt ⟨p.1.1, p.2.1⟩ k₁
    | .inr k₂ => B.drawExt ⟨p.1.2, p.2.2⟩ k₂
  emitAlarm m s oa := A.emitAlarm m.1 s.1 oa.1 || B.emitAlarm m.2 s.2 oa.2
  silenceLoad p := A.silenceLoad ⟨p.1.1, p.2.1⟩ + B.silenceLoad ⟨p.1.2, p.2.2⟩
  favours p := A.favours ⟨p.1.1, p.2.1⟩ ∨ B.favours ⟨p.1.2, p.2.2⟩

/-- Route composition onto shared substrate `Site`. -/
def composeRoute {Mode₁ Mode₂ : Type} {Ext₁ : Mode₁ → Type} {Ext₂ : Mode₂ → Type} {Site : Type}
    (route₁ : (m₁ : Mode₁) → Site → List (Ext₁ m₁))
    (route₂ : (m₂ : Mode₂) → Site → List (Ext₂ m₂))
    (m : Mode₁ × Mode₂) (site : Site) : List (Sum (Ext₁ m.1) (Ext₂ m.2)) :=
  (route₁ m.1 site).map Sum.inl ++ (route₂ m.2 site).map Sum.inr

theorem polySiteDraw_compose
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {Site : Type}
    (A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁)
    (B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂)
    (route₁ : (m₁ : Mode₁) → Site → List (Ext₁ m₁))
    (route₂ : (m₂ : Mode₂) → Site → List (Ext₂ m₂))
    (m : Mode₁ × Mode₂) (s : S₁ m.1 × S₂ m.2) (site : Site) :
    polySiteDraw (A.compose B) (composeRoute route₁ route₂) ⟨m, s⟩ site =
      polySiteDraw A route₁ ⟨m.1, s.1⟩ site + polySiteDraw B route₂ ⟨m.2, s.2⟩ site := by
  unfold polySiteDraw composeRoute
  rw [sumPortDraws_append]
  rw [sumPortDraws_map Sum.inl (fun k => (A.compose B).drawExt ⟨m, s⟩ k)]
  rw [sumPortDraws_map Sum.inr (fun k => (A.compose B).drawExt ⟨m, s⟩ k)]
  rfl

/-- Horizontal composition of `PolyContract`s on `PolyComponent.compose`. -/
def PolyContract.compose
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁}
    {B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂}
    {init₁ : Σ m₁, S₁ m₁} {init₂ : Σ m₂, S₂ m₂}
    (cA : PolyContract A init₁) (cB : PolyContract B init₂) :
    PolyContract (A.compose B) ⟨(init₁.1, init₂.1), (init₁.2, init₂.2)⟩ where
  tol m oa d := cA.tol m.1 (oa.1.1, oa.2) d.1 ∧ cB.tol m.2 (oa.1.2, oa.2) d.2
  warnObs m oa := cA.warnObs m.1 oa.1 ∨ cB.warnObs m.2 oa.2
  preCapInt m
    | .inl j₁ => cA.preCapInt m.1 j₁
    | .inr j₂ => cB.preCapInt m.2 j₂
  preCapExt m
    | .inl k₁ => cA.preCapExt m.1 k₁
    | .inr k₂ => cB.preCapExt m.2 k₂
  postAllowanceInt m
    | .inl j₁ => cA.postAllowanceInt m.1 j₁
    | .inr j₂ => cB.postAllowanceInt m.2 j₂
  postAllowanceExt m
    | .inl k₁ => cA.postAllowanceExt m.1 k₁
    | .inr k₂ => cB.postAllowanceExt m.2 k₂
  maxSilence m := cA.maxSilence m.1 + cB.maxSilence m.2
  maxLag m := CoreHelpers.natMax (cA.maxLag m.1) (cB.maxLag m.2)
  K p := cA.K ⟨p.1.1, p.2.1⟩ ∧ cB.K ⟨p.1.2, p.2.2⟩
  eta p := CoreHelpers.natMax (cA.eta ⟨p.1.1, p.2.1⟩) (cB.eta ⟨p.1.2, p.2.2⟩)
  init_in := ⟨cA.init_in, cB.init_in⟩
  cert :=
    ⟨fun p ⟨hA, hB⟩ =>
      let wA := cA.cert.within ⟨p.1.1, p.2.1⟩ hA
      let wB := cB.cert.within ⟨p.1.2, p.2.2⟩ hB
      ⟨fun j => match j with
         | .inl j₁ => wA.1 j₁
         | .inr j₂ => wB.1 j₂,
       fun k => match k with
         | .inl k₁ => wA.2.1 k₁
         | .inr k₂ => wB.2.1 k₂,
       Nat.add_le_add wA.2.2.1 wB.2.2.1,
       fun hEta =>
         have hEtaA : cA.eta ⟨p.1.1, p.2.1⟩ = 0 :=
           Nat.eq_zero_of_le_zero
             (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (Nat.le_of_eq hEta))
         have hEtaB : cB.eta ⟨p.1.2, p.2.2⟩ = 0 :=
           Nat.eq_zero_of_le_zero
             (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (Nat.le_of_eq hEta))
         let pA := wA.2.2.2 hEtaA
         let pB := wB.2.2.2 hEtaB
         ⟨fun fav => match fav with
            | .inl fA => pA.1 fA
            | .inr fB => pB.1 fB,
          fun j => match j with
            | .inl j₁ => pA.2.1 j₁
            | .inr j₂ => pB.2.1 j₂,
          fun k => match k with
            | .inl k₁ => pA.2.2 k₁
            | .inr k₂ => pB.2.2 k₂⟩⟩,
     fun p a p' step ⟨hA, hB⟩ => by
       obtain ⟨m, s⟩ := p
       obtain ⟨m', oa, d⟩ := a
       obtain ⟨hm, htol, heq⟩ := step
       cases hm
       subst heq
       exact ⟨cA.cert.closed ⟨m.1, s.1⟩ ⟨m.1, ((oa.1.1, oa.2), d.1)⟩ _ ⟨rfl, htol.1, rfl⟩ hA,
              cB.cert.closed ⟨m.2, s.2⟩ ⟨m.2, ((oa.1.2, oa.2), d.2)⟩ _ ⟨rfl, htol.2, rfl⟩ hB⟩⟩
  eta_bound p hK :=
    let ⟨hA, hB⟩ := hK
    CoreHelpers.natMax_le
      (Nat.le_trans (cA.eta_bound ⟨p.1.1, p.2.1⟩ hA) (CoreHelpers.le_natMax_left _ _))
      (Nat.le_trans (cB.eta_bound ⟨p.1.2, p.2.2⟩ hB) (CoreHelpers.le_natMax_right _ _))
  emits_on_warn m s oa hK warn := by
    obtain ⟨hA, hB⟩ := hK
    change (A.emitAlarm m.1 s.1 oa.1 || B.emitAlarm m.2 s.2 oa.2) = true
    cases warn with
    | inl wA =>
      rw [cA.emits_on_warn m.1 s.1 oa.1 hA wA]
      rfl
    | inr wB =>
      rw [cB.emits_on_warn m.2 s.2 oa.2 hB wB]
      exact CoreHelpers.bool_or_true_right _
  eta_alarm_step m s oa d htol hK pos := by
    obtain ⟨hA, hB⟩ := hK
    have stepA : cA.eta (A.next ⟨m.1, s.1⟩ (oa.1, true) d.1) <
        CoreHelpers.natMax (cA.eta ⟨m.1, s.1⟩) (cB.eta ⟨m.2, s.2⟩) := by
      cases Nat.eq_zero_or_pos (cA.eta ⟨m.1, s.1⟩) with
      | inl hEA =>
        rw [cA.eta_alarm_zero m.1 s.1 oa.1 d.1 htol.1 hA hEA]
        exact pos
      | inr hposA =>
        exact Nat.lt_of_lt_of_le
          (cA.eta_alarm_step m.1 s.1 oa.1 d.1 htol.1 hA hposA)
          (CoreHelpers.le_natMax_left _ _)
    have stepB : cB.eta (B.next ⟨m.2, s.2⟩ (oa.2, true) d.2) <
        CoreHelpers.natMax (cA.eta ⟨m.1, s.1⟩) (cB.eta ⟨m.2, s.2⟩) := by
      cases Nat.eq_zero_or_pos (cB.eta ⟨m.2, s.2⟩) with
      | inl hEB =>
        rw [cB.eta_alarm_zero m.2 s.2 oa.2 d.2 htol.2 hB hEB]
        exact pos
      | inr hposB =>
        exact Nat.lt_of_lt_of_le
          (cB.eta_alarm_step m.2 s.2 oa.2 d.2 htol.2 hB hposB)
          (CoreHelpers.le_natMax_right _ _)
    change CoreHelpers.natMax (cA.eta (A.next ⟨m.1, s.1⟩ (oa.1, true) d.1))
        (cB.eta (B.next ⟨m.2, s.2⟩ (oa.2, true) d.2)) <
      CoreHelpers.natMax (cA.eta ⟨m.1, s.1⟩) (cB.eta ⟨m.2, s.2⟩)
    cases Nat.decLe
        (cA.eta (A.next ⟨m.1, s.1⟩ (oa.1, true) d.1))
        (cB.eta (B.next ⟨m.2, s.2⟩ (oa.2, true) d.2)) with
    | isTrue le =>
      rw [show CoreHelpers.natMax (cA.eta (A.next ⟨m.1, s.1⟩ (oa.1, true) d.1))
          (cB.eta (B.next ⟨m.2, s.2⟩ (oa.2, true) d.2)) =
          cB.eta (B.next ⟨m.2, s.2⟩ (oa.2, true) d.2) from if_pos le]
      exact stepB
    | isFalse notLe =>
      rw [show CoreHelpers.natMax (cA.eta (A.next ⟨m.1, s.1⟩ (oa.1, true) d.1))
          (cB.eta (B.next ⟨m.2, s.2⟩ (oa.2, true) d.2)) =
          cA.eta (A.next ⟨m.1, s.1⟩ (oa.1, true) d.1) from if_neg notLe]
      exact stepA
  eta_alarm_zero m s oa d htol hK hEta := by
    obtain ⟨hA, hB⟩ := hK
    have hEtaA : cA.eta ⟨m.1, s.1⟩ = 0 :=
      Nat.eq_zero_of_le_zero
        (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (Nat.le_of_eq hEta))
    have hEtaB : cB.eta ⟨m.2, s.2⟩ = 0 :=
      Nat.eq_zero_of_le_zero
        (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (Nat.le_of_eq hEta))
    have zA := cA.eta_alarm_zero m.1 s.1 oa.1 d.1 htol.1 hA hEtaA
    have zB := cB.eta_alarm_zero m.2 s.2 oa.2 d.2 htol.2 hB hEtaB
    show CoreHelpers.natMax (cA.eta (A.next ⟨m.1, s.1⟩ (oa.1, true) d.1))
        (cB.eta (B.next ⟨m.2, s.2⟩ (oa.2, true) d.2)) = 0
    rw [zA, zB]
    rfl

/-- Boundary hiding (`PolyComponent.hide`): encapsulates a static hidden site family `ExtHide`
inside mode-dependent state `(s, xh)` evolving under `G_hide`. -/
def PolyComponent.hide
    {Mode : Type} {S Obs ObsOuter Dist Int ExtKeep : Mode → Type} {ExtHide : Type}
    (C : PolyComponent Mode S Obs Dist Int (fun m => Sum (ExtKeep m) ExtHide))
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : (m : Mode) → ObsOuter m → (ExtHide → Nat) → Obs m) :
    PolyComponent Mode (fun m => S m × (ExtHide → Nat)) ObsOuter Dist
      (fun m => Sum (Int m) ExtHide) ExtKeep where
  next p oa d :=
    let obsC := wireObs p.1 oa.1 p.2.2
    let alEff := oa.2 || C.emitAlarm p.1 p.2.1 obsC
    let s' := C.next ⟨p.1, p.2.1⟩ (obsC, alEff) d
    let xh' := RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole
      G_hide (fun k => C.drawExt ⟨p.1, p.2.1⟩ (Sum.inr k)) p.2.2
    ⟨s'.1, (s'.2, xh')⟩
  drawInt p
    | .inl j => C.drawInt ⟨p.1, p.2.1⟩ j
    | .inr k => C.drawExt ⟨p.1, p.2.1⟩ (Sum.inr k)
  drawExt p k := C.drawExt ⟨p.1, p.2.1⟩ (Sum.inl k)
  emitAlarm m p o := C.emitAlarm m p.1 (wireObs m o p.2)
  silenceLoad p := C.silenceLoad ⟨p.1, p.2.1⟩
  favours p := C.favours ⟨p.1, p.2.1⟩

/-- Contract for `PolyComponent.hide` with explicit hidden-site envelope bounds parallel to `poly_close_viable`. -/
def PolyContract.hide
    {Mode : Type} {S Obs ObsOuter Dist Int ExtKeep : Mode → Type} {ExtHide : Type}
    {C : PolyComponent Mode S Obs Dist Int (fun m => Sum (ExtKeep m) ExtHide)}
    {init : Σ m, S m}
    (c : PolyContract C init)
    (G_hide : ExtHide → (ExtHide → Nat) → Nat)
    (wireObs : (m : Mode) → ObsOuter m → (ExtHide → Nat) → Obs m)
    (tolOuter : (m : Mode) → ObsOuter m × Bool → Dist m → Prop)
    (warnOuter : (m : Mode) → ObsOuter m → Prop)
    (hidePreCap hidePostAllowance : ExtHide → Nat)
    (maxLagHide : Nat)
    (hide_pre_bound : ∀ m k, c.preCapExt m (Sum.inr k) ≤ hidePreCap k)
    (hide_post_bound : ∀ m k, c.postAllowanceExt m (Sum.inr k) ≤ hidePostAllowance k)
    (hide_lag_bound : ∀ m, c.maxLag m ≤ maxLagHide)
    (x_crit_hide warnHide H_safe_hide x₀_hide : ExtHide → Nat)
    (tol_lifts : ∀ m o xh al b d, tolOuter m (o, al) d → c.tol m (wireObs m o xh, b) d)
    (G_hide_rises : ∀ k, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_hide k))
    (wire_outer_warn : ∀ m o xh, warnOuter m o → c.warnObs m (wireObs m o xh))
    (wire_hide_warn : ∀ m s o xh, c.K ⟨m, s⟩ → (∃ k, xh k < warnHide k) →
      c.warnObs m (wireObs m o xh))
    (hide_post_viable : ∀ k, x_crit_hide k ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_hide H_safe_hide x_crit_hide k)
    (hide_post_allowance : ∀ k, hidePostAllowance k ≤ H_safe_hide k)
    (hide_warn_margin : ∀ k, x_crit_hide k + (maxLagHide + 1) * hidePreCap k ≤ warnHide k)
    (hide_init_margin : ∀ k, x_crit_hide k + c.eta init * hidePreCap k ≤ x₀_hide k) :
    PolyContract (C.hide G_hide wireObs) ⟨init.1, (init.2, x₀_hide)⟩ where
  tol := tolOuter
  warnObs := warnOuter
  preCapInt m
    | .inl j => c.preCapInt m j
    | .inr k => c.preCapExt m (Sum.inr k)
  preCapExt m k := c.preCapExt m (Sum.inl k)
  postAllowanceInt m
    | .inl j => c.postAllowanceInt m j
    | .inr k => c.postAllowanceExt m (Sum.inr k)
  postAllowanceExt m k := c.postAllowanceExt m (Sum.inl k)
  maxSilence := c.maxSilence
  maxLag := c.maxLag
  K p := c.K ⟨p.1, p.2.1⟩ ∧ ∀ k, x_crit_hide k + c.eta ⟨p.1, p.2.1⟩ * hidePreCap k ≤ p.2.2 k
  eta p := c.eta ⟨p.1, p.2.1⟩
  init_in := ⟨c.init_in, hide_init_margin⟩
  cert :=
    ⟨fun p ⟨hK, _⟩ =>
      let w := c.cert.within ⟨p.1, p.2.1⟩ hK
      ⟨fun j => match j with
         | .inl j₁ => w.1 j₁
         | .inr k => w.2.1 (Sum.inr k),
       fun k => w.2.1 (Sum.inl k),
       w.2.2.1,
       fun h0 =>
         let q := w.2.2.2 h0
         ⟨q.1,
          fun j => match j with
            | .inl j₁ => q.2.1 j₁
            | .inr k => q.2.2 (Sum.inr k),
          fun k => q.2.2 (Sum.inl k)⟩⟩,
     fun p a p' step ⟨hK, margin⟩ => by
       obtain ⟨m, s, xh⟩ := p
       obtain ⟨m', ⟨o, al⟩, d⟩ := a
       obtain ⟨hm, hadm, heq⟩ := step
       cases hm
       subst heq
       let obsC := wireObs m o xh
       let alEff := al || C.emitAlarm m s obsC
       let s' := C.next ⟨m, s⟩ (obsC, alEff) d
       have tolC : c.tol m (obsC, alEff) d := tol_lifts m o xh al alEff d hadm
       have hK' : c.K s' := c.cert.closed ⟨m, s⟩ ⟨m, ((obsC, alEff), d)⟩ s' ⟨rfl, tolC, rfl⟩ hK
       have wP := c.cert.within ⟨m, s⟩ hK
       refine ⟨hK', fun k => ?_⟩
       refine OpenComposition.substrate_margin_step G_hide_rises
         (fun j => Nat.le_trans (wP.2.1 (Sum.inr j)) (hide_pre_bound m j))
         (Nat.le_trans (c.eta_bound s' hK') (hide_lag_bound s'.1))
         hide_post_viable hide_warn_margin margin k ?_
       intro below
       have warnC : c.warnObs m obsC := wire_hide_warn m s o xh hK ⟨k, below⟩
       have emitTrue : C.emitAlarm m s obsC = true := c.emits_on_warn m s obsC hK warnC
       have alTrue : alEff = true := by
         dsimp only [alEff]
         rw [emitTrue]
         exact CoreHelpers.bool_or_true_right al
       have tolTrue : c.tol m (obsC, true) d := alTrue ▸ tolC
       refine ⟨fun h0 => ?_, fun pos => ?_⟩
       · have hEta0' : c.eta s' = 0 := by
           show c.eta (C.next ⟨m, s⟩ (obsC, alEff) d) = 0
           rw [alTrue]
           exact c.eta_alarm_zero m s obsC d tolTrue hK h0
         have hPost := wP.2.2.2 h0
         exact ⟨hEta0', fun j =>
           Nat.le_trans (hPost.2.2 (Sum.inr j))
             (Nat.le_trans (hide_post_bound m j) (hide_post_allowance j))⟩
       · show c.eta (C.next ⟨m, s⟩ (obsC, alEff) d) + 1 ≤ c.eta ⟨m, s⟩
         rw [alTrue]
         exact c.eta_alarm_step m s obsC d tolTrue hK pos⟩
  eta_bound p hp := c.eta_bound ⟨p.1, p.2.1⟩ hp.1
  emits_on_warn m p o hp w := c.emits_on_warn m p.1 (wireObs m o p.2) hp.1 (wire_outer_warn m o p.2 w)
  eta_alarm_step m p o d adm hp pos := by
    have alTrue : (true || C.emitAlarm m p.1 (wireObs m o p.2)) = true := rfl
    show c.eta (C.next ⟨m, p.1⟩ (wireObs m o p.2, true || C.emitAlarm m p.1 (wireObs m o p.2)) d) <
      c.eta ⟨m, p.1⟩
    rw [alTrue]
    exact c.eta_alarm_step m p.1 (wireObs m o p.2) d (tol_lifts m o p.2 true true d adm) hp.1 pos
  eta_alarm_zero m p o d adm hp h0 := by
    have alTrue : (true || C.emitAlarm m p.1 (wireObs m o p.2)) = true := rfl
    show c.eta (C.next ⟨m, p.1⟩ (wireObs m o p.2, true || C.emitAlarm m p.1 (wireObs m o p.2)) d) = 0
    rw [alTrue]
    exact c.eta_alarm_zero m p.1 (wireObs m o p.2) d (tol_lifts m o p.2 true true d adm) hp.1 h0

/-! ### Closed-Loop Viability for `PolyComponent` -/

/-- General closed-loop viability theorem with envelope bounds guarded on inhabited `c.K` modes. -/
theorem poly_close_viable_on_K
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m}
    (c : PolyContract C init)
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (pre_cap_bound : ∀ m s site, c.K ⟨m, s⟩ → sumPortDraws (route m site) (c.preCapExt m) ≤ sitePreCap site)
    (post_cap_bound : ∀ m s site, c.K ⟨m, s⟩ → sumPortDraws (route m site) (c.postAllowanceExt m) ≤ sitePostCap site)
    (lag_bound : ∀ m s, c.K ⟨m, s⟩ → c.maxLag m ≤ maxLagEnv)
    (silence_bound : ∀ m s, c.K ⟨m, s⟩ → c.maxSilence m ≤ maxSilenceEnv)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (ModeGuard : (Site → Nat) → Mode → Prop)
    (mode_guard_init : ModeGuard x₀ init.1)
    (mode_guard_step : ∀ x p env d,
      polyClosedInv c sitePreCap envCap x_crit (x, p) →
      ModeGuard x p.1 → jointAdm env → (∀ ob, c.tol p.1 ob d) →
      let st' := polyClosedStep C route obs channel G envDraw (x, p) (env, d)
      ModeGuard st'.1 st'.2.1)
    (obs_detects : ∀ m s x site, c.K ⟨m, s⟩ → ModeGuard x m →
      x site < warnLevel site → c.warnObs m (obs m x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + c.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    polyClosedInv c sitePreCap envCap x_crit (x₀, init) ∧
    ModeGuard x₀ init.1 ∧
    Viability.Certificate (polyClosedProcess C route c obs channel G envDraw jointAdm)
      (polyClosedGuard C c x_crit)
      (fun st => polyClosedInv c sitePreCap envCap x_crit st ∧ ModeGuard st.1 st.2.1) := by
  refine ⟨⟨c.init_in, init_margin⟩, mode_guard_init, ⟨?_, ?_⟩⟩
  · intro st ⟨⟨hK, margin⟩, _⟩
    exact ⟨fun site => Nat.le_trans (Nat.le_add_right _ _) (margin site), c.cert.within st.2 hK⟩
  · intro st act st' hstep ⟨⟨hK, margin⟩, hMG⟩
    obtain ⟨x, ⟨m, s⟩⟩ := st
    obtain ⟨env, ⟨m', d⟩⟩ := act
    obtain ⟨hm, envOk, tolOk, heq⟩ := hstep
    cases hm
    subst heq
    let o := obs m x
    let al := channel (C.emitAlarm m s o) (C.silenceLoad ⟨m, s⟩) env
    let H := fun site => polySiteDraw C route ⟨m, s⟩ site + envDraw env site
    let p' := C.next ⟨m, s⟩ (o, al) d
    have wS := c.cert.within ⟨m, s⟩ hK
    have hK' : c.K p' := c.cert.closed ⟨m, s⟩ ⟨m, ((o, al), d)⟩ p' ⟨rfl, tolOk (o, al), rfl⟩ hK
    have hMG' : ModeGuard _ p'.1 :=
      mode_guard_step x ⟨m, s⟩ env d ⟨hK, margin⟩ hMG envOk tolOk
    have H_le_pre : ∀ site, H site ≤ sitePreCap site + envCap site := fun site =>
      Nat.add_le_add
        (Nat.le_trans (sumPortDraws_le fun k _ => wS.2.1 k) (pre_cap_bound m s site hK))
        (env_within env envOk site)
    refine ⟨⟨hK', fun site => ?_⟩, hMG'⟩
    refine OpenComposition.substrate_margin_step G_rises H_le_pre
      (Nat.le_trans (c.eta_bound p' hK') (lag_bound p'.1 p'.2 hK'))
      post_viable warn_margin margin site ?_
    intro below
    have hWarn : c.warnObs m o := obs_detects m s x site hK hMG below
    have hEmit : C.emitAlarm m s o = true := c.emits_on_warn m s o hK hWarn
    have hLoad : C.silenceLoad ⟨m, s⟩ ≤ maxSilenceEnv :=
      Nat.le_trans wS.2.2.1 (silence_bound m s hK)
    have alTrue : al = true := by
      dsimp only [al]
      rw [hEmit]
      exact channel_fires (C.silenceLoad ⟨m, s⟩) env envOk hLoad
    refine ⟨fun h0 => ?_, fun pos => ?_⟩
    · have hEta0' : c.eta p' = 0 := by
        show c.eta (C.next ⟨m, s⟩ (o, al) d) = 0
        rw [alTrue]
        exact c.eta_alarm_zero m s o d (tolOk (o, true)) hK h0
      exact ⟨hEta0', fun k =>
        Nat.le_trans
          (Nat.add_le_add
            (Nat.le_trans (sumPortDraws_le fun pk _ => (wS.2.2.2 h0).2.2 pk)
              (post_cap_bound m s k hK))
            (env_within env envOk k))
          (post_allowance k)⟩
    · show c.eta (C.next ⟨m, s⟩ (o, al) d) + 1 ≤ c.eta ⟨m, s⟩
      rw [alTrue]
      exact c.eta_alarm_step m s o d (tolOk (o, true)) hK pos

/-- Closed-loop viability certificate for any `PolyComponent` with mode-guarded observation soundness. -/
theorem poly_close_viable
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m}
    (c : PolyContract C init)
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (pre_cap_bound : ∀ m site, sumPortDraws (route m site) (c.preCapExt m) ≤ sitePreCap site)
    (post_cap_bound : ∀ m site, sumPortDraws (route m site) (c.postAllowanceExt m) ≤ sitePostCap site)
    (lag_bound : ∀ m, c.maxLag m ≤ maxLagEnv)
    (silence_bound : ∀ m, c.maxSilence m ≤ maxSilenceEnv)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (ModeGuard : (Site → Nat) → Mode → Prop)
    (mode_guard_init : ModeGuard x₀ init.1)
    (mode_guard_step : ∀ x p env d,
      polyClosedInv c sitePreCap envCap x_crit (x, p) →
      ModeGuard x p.1 → jointAdm env → (∀ ob, c.tol p.1 ob d) →
      let st' := polyClosedStep C route obs channel G envDraw (x, p) (env, d)
      ModeGuard st'.1 st'.2.1)
    (obs_detects : ∀ m s x site, c.K ⟨m, s⟩ → ModeGuard x m →
      x site < warnLevel site → c.warnObs m (obs m x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + c.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    polyClosedInv c sitePreCap envCap x_crit (x₀, init) ∧
    ModeGuard x₀ init.1 ∧
    Viability.Certificate (polyClosedProcess C route c obs channel G envDraw jointAdm)
      (polyClosedGuard C c x_crit)
      (fun st => polyClosedInv c sitePreCap envCap x_crit st ∧ ModeGuard st.1 st.2.1) :=
  poly_close_viable_on_K C route c obs channel G envDraw envCap jointAdm env_within
    sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    (fun m _ site _ => pre_cap_bound m site)
    (fun m _ site _ => post_cap_bound m site)
    (fun m _ _ => lag_bound m)
    (fun m _ _ => silence_bound m)
    x_crit warnLevel H_safe x₀ ModeGuard mode_guard_init mode_guard_step obs_detects
    channel_fires G_rises post_viable post_allowance warn_margin init_margin

theorem poly_close_kernel
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m}
    (c : PolyContract C init)
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (pre_cap_bound : ∀ m site, sumPortDraws (route m site) (c.preCapExt m) ≤ sitePreCap site)
    (post_cap_bound : ∀ m site, sumPortDraws (route m site) (c.postAllowanceExt m) ≤ sitePostCap site)
    (lag_bound : ∀ m, c.maxLag m ≤ maxLagEnv)
    (silence_bound : ∀ m, c.maxSilence m ≤ maxSilenceEnv)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (ModeGuard : (Site → Nat) → Mode → Prop)
    (mode_guard_init : ModeGuard x₀ init.1)
    (mode_guard_step : ∀ x p env d,
      polyClosedInv c sitePreCap envCap x_crit (x, p) →
      ModeGuard x p.1 → jointAdm env → (∀ ob, c.tol p.1 ob d) →
      let st' := polyClosedStep C route obs channel G envDraw (x, p) (env, d)
      ModeGuard st'.1 st'.2.1)
    (obs_detects : ∀ m s x site, c.K ⟨m, s⟩ → ModeGuard x m →
      x site < warnLevel site → c.warnObs m (obs m x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + c.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    Viability.Kernel (polyClosedProcess C route c obs channel G envDraw jointAdm)
      (polyClosedGuard C c x_crit) (x₀, init) :=
  let res := poly_close_viable C route c obs channel G envDraw envCap jointAdm env_within
    sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    pre_cap_bound post_cap_bound lag_bound silence_bound
    x_crit warnLevel H_safe x₀ ModeGuard mode_guard_init mode_guard_step obs_detects
    channel_fires G_rises post_viable post_allowance warn_margin init_margin
  res.2.2.kernel ⟨res.1, res.2.1⟩

theorem poly_close_kernel_allModes
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m}
    (c : PolyContract C init)
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (pre_cap_bound : ∀ m site, sumPortDraws (route m site) (c.preCapExt m) ≤ sitePreCap site)
    (post_cap_bound : ∀ m site, sumPortDraws (route m site) (c.postAllowanceExt m) ≤ sitePostCap site)
    (lag_bound : ∀ m, c.maxLag m ≤ maxLagEnv)
    (silence_bound : ∀ m, c.maxSilence m ≤ maxSilenceEnv)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (obs_detects : ∀ m s x site, c.K ⟨m, s⟩ →
      x site < warnLevel site → c.warnObs m (obs m x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + c.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    Viability.Kernel (polyClosedProcess C route c obs channel G envDraw jointAdm)
      (polyClosedGuard C c x_crit) (x₀, init) :=
  poly_close_kernel C route c obs channel G envDraw envCap jointAdm env_within
    sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    pre_cap_bound post_cap_bound lag_bound silence_bound
    x_crit warnLevel H_safe x₀ (fun _ _ => True) trivial (fun _ _ _ _ _ _ _ _ => trivial)
    (fun m s x site hK _ lt => obs_detects m s x site hK lt)
    channel_fires G_rises post_viable post_allowance warn_margin init_margin

/-! ### Witness 1: `DynamicPortWitness` -/

namespace DynamicPortWitness

inductive DynMode where
  | blind | widened | contracted
  deriving DecidableEq

abbrev dynS : DynMode → Type
  | .blind => Nat
  | .widened => Nat
  | .contracted => Nat × Bool

abbrev dynObs : DynMode → Type
  | .blind => Bool
  | .widened => Bool × Bool
  | .contracted => Bool × Bool

abbrev dynDist : DynMode → Type
  | _ => Bool

abbrev dynInt : DynMode → Type
  | .blind => Empty
  | .widened => Empty
  | .contracted => Unit

abbrev dynExt : DynMode → Type
  | .blind => Bool
  | .widened => Bool
  | .contracted => Unit

def dynRoute : (m : DynMode) → Bool → List (dynExt m)
  | .blind, b => [b]
  | .widened, b => [b]
  | .contracted, false => [()]
  | .contracted, true => []

def G_dyn (b : Bool) (e : Bool → Nat) : Nat := if 2 ≤ e b then 1 else 0

theorem G_dyn_rises :
    ∀ b : Bool, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_dyn b) :=
  fun b e₁ _ below =>
    match Nat.decLe 2 (e₁ b) with
    | isTrue h =>
      Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below b))).symm)
    | isFalse h =>
      Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def dynObsFn : (m : DynMode) → (Bool → Nat) → dynObs m
  | .blind, x => Nat.blt (x true) 8
  | .widened, x => (Nat.blt (x false) 8, Nat.blt (x true) 8)
  | .contracted, x => (Nat.blt (x false) 8, Nat.blt (x true) 8)

def dynComp : PolyComponent DynMode dynS dynObs dynDist dynInt dynExt where
  next p oa d := match p with
    | ⟨.blind, act⟩ =>
      let act' := if oa.2 then 0 else act
      if d then ⟨.widened, act'⟩ else ⟨.blind, act'⟩
    | ⟨.widened, act⟩ =>
      let act' := if oa.2 then 0 else act
      if d then ⟨.contracted, (act', false)⟩ else ⟨.widened, act'⟩
    | ⟨.contracted, (act, hid)⟩ =>
      let act' := if oa.2 then 0 else act
      if d then ⟨.widened, act'⟩ else ⟨.contracted, (act', hid)⟩
  drawInt p j := match p, j with
    | ⟨.blind, _⟩, e => Empty.elim e
    | ⟨.widened, _⟩, e => Empty.elim e
    | ⟨.contracted, (_, hid)⟩, () => if hid then 1 else 0
  drawExt p k := match p, k with
    | ⟨.blind, act⟩, false => if act = 0 then 1 else 2
    | ⟨.blind, _⟩, true => 1
    | ⟨.widened, act⟩, _ => if act = 0 then 1 else 2
    | ⟨.contracted, (act, _)⟩, () => if act = 0 then 1 else 2
  emitAlarm m _ o := match m, o with
    | .blind, o₁ => o₁
    | .widened, (o₀, o₁) => o₀ || o₁
    | .contracted, (o₀, o₁) => o₀ || o₁
  silenceLoad _ := 0
  favours p := match p with
    | ⟨.blind, act⟩ => 0 < act
    | ⟨.widened, act⟩ => 0 < act
    | ⟨.contracted, (act, _)⟩ => 0 < act

def dynInit : Σ m, dynS m := ⟨.blind, 1⟩
def x₀ : Bool → Nat := fun _ => 8
def x_crit : Bool → Nat := fun _ => 3
def warnLevel : Bool → Nat := fun _ => 8
def H_safe : Bool → Nat := fun _ => 1
def sitePreCap : Bool → Nat := fun _ => 2
def maxLagEnv : Nat := 1
def maxSilenceEnv : Nat := 0
def dynChannel (em : Bool) (load : Nat) (_ : Unit) : Bool := em && Nat.ble load 0

def dynContractWithTol (blindTol : Bool → Prop) : PolyContract dynComp dynInit where
  tol m _ d := match m with
    | .blind => blindTol d
    | .widened => True
    | .contracted => True
  warnObs m o := match m, o with
    | .blind, o₁ => o₁ = true
    | .widened, (o₀, o₁) => o₀ = true ∨ o₁ = true
    | .contracted, (o₀, o₁) => o₀ = true ∨ o₁ = true
  preCapInt m j := match m, j with
    | .blind, e => Empty.elim e
    | .widened, e => Empty.elim e
    | .contracted, () => 1
  preCapExt _ _ := 2
  postAllowanceInt m j := match m, j with
    | .blind, e => Empty.elim e
    | .widened, e => Empty.elim e
    | .contracted, () => 1
  postAllowanceExt _ _ := 1
  maxSilence _ := 0
  maxLag _ := 1
  K p := match p with
    | ⟨.blind, act⟩ => act ≤ 1
    | ⟨.widened, act⟩ => act ≤ 1
    | ⟨.contracted, (act, _)⟩ => act ≤ 1
  eta p := match p with
    | ⟨.blind, act⟩ => if act = 0 then 0 else 1
    | ⟨.widened, act⟩ => if act = 0 then 0 else 1
    | ⟨.contracted, (act, _)⟩ => if act = 0 then 0 else 1
  init_in := Nat.le_refl 1
  cert :=
    ⟨fun p hK => by
      cases p with | mk m s =>
      cases m with
      | blind =>
        refine ⟨fun e => Empty.elim e, fun b => ?_, Nat.le_refl 0, fun h0 => ?_⟩
        · cases b
          · show (if s = 0 then 1 else 2) ≤ 2
            cases s with
            | zero => exact Nat.le_succ 1
            | succ _ => rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 2
          · exact Nat.le_succ 1
        · have hs0 : s = 0 := by
            cases s with
            | zero => rfl
            | succ s' =>
              dsimp only at h0
              rw [if_neg (Naturals.succ_ne_zero s')] at h0
              exact absurd h0 (Naturals.succ_ne_zero 0)
          subst hs0
          exact ⟨Nat.lt_irrefl 0, fun e => Empty.elim e, fun b => by cases b <;> exact Nat.le_refl 1⟩
      | widened =>
        refine ⟨fun e => Empty.elim e, fun b => ?_, Nat.le_refl 0, fun h0 => ?_⟩
        · show (if s = 0 then 1 else 2) ≤ 2
          cases s with
          | zero => exact Nat.le_succ 1
          | succ _ => rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 2
        · have hs0 : s = 0 := by
            cases s with
            | zero => rfl
            | succ s' =>
              dsimp only at h0
              rw [if_neg (Naturals.succ_ne_zero s')] at h0
              exact absurd h0 (Naturals.succ_ne_zero 0)
          subst hs0
          exact ⟨Nat.lt_irrefl 0, fun e => Empty.elim e, fun _ => Nat.le_refl 1⟩
      | contracted =>
        obtain ⟨act, hid⟩ := s
        refine ⟨fun () => ?_, fun () => ?_, Nat.le_refl 0, fun h0 => ?_⟩
        · show (if hid then 1 else 0) ≤ 1
          cases hid <;> decide
        · show (if act = 0 then 1 else 2) ≤ 2
          cases act with
          | zero => exact Nat.le_succ 1
          | succ _ => rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 2
        · have ha0 : act = 0 := by
            cases act with
            | zero => rfl
            | succ a' =>
              dsimp only at h0
              rw [if_neg (Naturals.succ_ne_zero a')] at h0
              exact absurd h0 (Naturals.succ_ne_zero 0)
          subst ha0
          exact ⟨Nat.lt_irrefl 0, fun () => by cases hid <;> decide, fun () => Nat.le_refl 1⟩,
     fun p a p' hstep hK => by
      obtain ⟨m', ⟨o, al⟩, d⟩ := a
      obtain ⟨hm, _, heq⟩ := hstep
      cases hm
      subst heq
      cases p with | mk m s =>
      cases m with
      | blind =>
        dsimp only [dynComp]
        cases al <;> cases d <;> first | exact Nat.zero_le 1 | exact hK
      | widened =>
        dsimp only [dynComp]
        cases al <;> cases d <;> first | exact Nat.zero_le 1 | exact hK
      | contracted =>
        obtain ⟨act, hid⟩ := s
        dsimp only [dynComp]
        cases al <;> cases d <;> first | exact Nat.zero_le 1 | exact hK⟩
  eta_bound p _ := by
    cases p with | mk m s =>
    cases m with
    | blind =>
      cases s with
      | zero => dsimp only; rw [if_pos rfl]; exact Nat.zero_le 1
      | succ _ => dsimp only; rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 1
    | widened =>
      cases s with
      | zero => dsimp only; rw [if_pos rfl]; exact Nat.zero_le 1
      | succ _ => dsimp only; rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 1
    | contracted =>
      cases s with | mk act hid =>
      cases act with
      | zero => dsimp only; rw [if_pos rfl]; exact Nat.zero_le 1
      | succ _ => dsimp only; rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 1
  emits_on_warn m s obs _ hw := by
    cases m with
    | blind => exact hw
    | widened =>
      obtain ⟨o₀, o₁⟩ := obs
      cases hw with
      | inl h => show (o₀ || o₁) = true; rw [h]; rfl
      | inr h => show (o₀ || o₁) = true; rw [h]; exact CoreHelpers.bool_or_true_right _
    | contracted =>
      obtain ⟨o₀, o₁⟩ := obs
      cases hw with
      | inl h => show (o₀ || o₁) = true; rw [h]; rfl
      | inr h => show (o₀ || o₁) = true; rw [h]; exact CoreHelpers.bool_or_true_right _
  eta_alarm_step m s obs d _ _ pos := by
    cases m with
    | blind =>
      cases s with
      | zero => exact absurd pos (Nat.lt_irrefl 0)
      | succ _ => cases d <;> exact Nat.zero_lt_one
    | widened =>
      cases s with
      | zero => exact absurd pos (Nat.lt_irrefl 0)
      | succ _ => cases d <;> exact Nat.zero_lt_one
    | contracted =>
      obtain ⟨act, hid⟩ := s
      cases act with
      | zero => exact absurd pos (Nat.lt_irrefl 0)
      | succ _ => cases d <;> exact Nat.zero_lt_one
  eta_alarm_zero m s obs d _ _ _ := by
    cases m with
    | blind =>
      show (match (if d then ⟨.widened, 0⟩ else ⟨.blind, 0⟩ : Σ m, dynS m) with
        | ⟨.blind, a⟩ => if a = 0 then 0 else 1
        | ⟨.widened, a⟩ => if a = 0 then 0 else 1
        | ⟨.contracted, (a, _)⟩ => if a = 0 then 0 else 1) = 0
      cases d <;> rfl
    | widened =>
      show (match (if d then ⟨.contracted, (0, false)⟩ else ⟨.widened, 0⟩ : Σ m, dynS m) with
        | ⟨.blind, a⟩ => if a = 0 then 0 else 1
        | ⟨.widened, a⟩ => if a = 0 then 0 else 1
        | ⟨.contracted, (a, _)⟩ => if a = 0 then 0 else 1) = 0
      cases d <;> rfl
    | contracted =>
      obtain ⟨_, hid⟩ := s
      show (match (if d then ⟨.widened, 0⟩ else ⟨.contracted, (0, hid)⟩ : Σ m, dynS m) with
        | ⟨.blind, a⟩ => if a = 0 then 0 else 1
        | ⟨.widened, a⟩ => if a = 0 then 0 else 1
        | ⟨.contracted, (a, _)⟩ => if a = 0 then 0 else 1) = 0
      cases d <;> rfl

def dynContract : PolyContract dynComp dynInit := dynContractWithTol (fun d => d = true)
def stayBlindContract : PolyContract dynComp dynInit := dynContractWithTol (fun _ => True)

def dynModeGuard (x : Bool → Nat) : DynMode → Prop
  | .blind => 8 ≤ x false
  | .widened => True
  | .contracted => True

def stayBlindOrbit : Nat → (Bool → Nat) × (Σ m, dynS m) :=
  Law.orbit
    (fun st =>
      let d : dynDist st.2.1 := false
      polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0) st ((), d))
    (x₀, dynInit)

theorem stayBlind_trace :
    ∀ n, Trace (polyClosedProcess dynComp dynRoute stayBlindContract dynObsFn dynChannel G_dyn
        (fun _ _ => 0) (fun _ => True))
      (x₀, dynInit)
      (List.replicate n ((), ⟨.blind, false⟩))
      (stayBlindOrbit n) := by
  intro n
  have hmode : ∀ t, (stayBlindOrbit t).2 = ⟨.blind, 1⟩ ∧ (stayBlindOrbit t).1 true = 8 := by
    intro t
    induction t with
    | zero => exact ⟨rfl, rfl⟩
    | succ t ih =>
      obtain ⟨hm, ht⟩ := ih
      have hnext : stayBlindOrbit (t + 1) =
          polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0)
            (stayBlindOrbit t) ((), false) := rfl
      rw [hnext]
      have hstep_eq : polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0)
            (stayBlindOrbit t) ((), false) =
          ((RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_dyn
              (fun b => polySiteDraw dynComp dynRoute ⟨.blind, 1⟩ b + 0) (stayBlindOrbit t).1),
            ⟨.blind, 1⟩) := by
        have hobs : dynObsFn .blind (stayBlindOrbit t).1 = false := by
          dsimp only [dynObsFn]
          rw [ht]
          rfl
        cases hst_m : (stayBlindOrbit t).2 with | mk m s =>
        rw [hst_m] at hm
        cases hm
        dsimp only [polyClosedStep]
        rw [hst_m, hobs]
        rfl
      rw [hstep_eq]
      refine ⟨rfl, ?_⟩
      change ((stayBlindOrbit t).1 true - 1) +
        (if 2 ≤ (stayBlindOrbit t).1 true - 1 then 1 else 0) = 8
      have hgt : 2 ≤ (stayBlindOrbit t).1 true - 1 := by
        rw [ht]
        decide
      rw [if_pos hgt, ht]
  induction n with
  | zero => exact .nil (x₀, dynInit)
  | succ n ih =>
    have hm := (hmode n).1
    have hstep : (polyClosedProcess dynComp dynRoute stayBlindContract dynObsFn dynChannel G_dyn
        (fun _ _ => 0) (fun _ => True)).step (stayBlindOrbit n) ((), ⟨.blind, false⟩)
        (stayBlindOrbit (n + 1)) := by
      change ∃ hm1 : DynMode.blind = (stayBlindOrbit n).2.1,
        True ∧ (∀ ob, stayBlindContract.tol (stayBlindOrbit n).2.1 ob (hm1 ▸ false)) ∧
        stayBlindOrbit (n + 1) =
          polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0)
            (stayBlindOrbit n) ((), hm1 ▸ false)
      cases hst_n : stayBlindOrbit n with | mk x p =>
      cases p with | mk m s =>
      rw [hst_n] at hm
      cases hm
      refine ⟨rfl, trivial, fun _ => trivial, ?_⟩
      change polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0)
          (stayBlindOrbit n) ((), false) =
        polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0)
          (x, ⟨.blind, 1⟩) ((), false)
      rw [hst_n]
    have hrep : List.replicate (n + 1) ((), (⟨.blind, false⟩ : Σ m, dynDist m)) =
        List.replicate n ((), ⟨.blind, false⟩) ++ [((), ⟨.blind, false⟩)] := by
      clear ih hstep hm hmode
      induction n with
      | zero => rfl
      | succ n ihn => exact congrArg (((), ⟨.blind, false⟩) :: ·) ihn
    rw [hrep]
    exact trace_append_iff.mpr ⟨stayBlindOrbit n, ih, .cons hstep (.nil _)⟩

theorem stayBlind_crashes :
    (stayBlindOrbit 7).1 false = 0 ∧
    ¬ Viability.Kernel
        (polyClosedProcess dynComp dynRoute stayBlindContract dynObsFn dynChannel G_dyn
          (fun _ _ => 0) (fun _ => True))
        (polyClosedGuard dynComp stayBlindContract x_crit) (x₀, dynInit) := by
  have hzero : (stayBlindOrbit 7).1 false = 0 := rfl
  refine ⟨hzero, fun kern => ?_⟩
  have hguard := kern (stayBlindOrbit 7) ⟨_, stayBlind_trace 7⟩
  have h3 : 3 ≤ (stayBlindOrbit 7).1 false := hguard.1 false
  rw [hzero] at h3
  exact Nat.not_succ_le_zero 2 h3

theorem dyn_viable_kernel :
    Viability.Kernel
      (polyClosedProcess dynComp dynRoute dynContract dynObsFn dynChannel G_dyn
        (fun _ _ => 0) (fun _ => True))
      (polyClosedGuard dynComp dynContract x_crit) (x₀, dynInit) := by
  refine poly_close_kernel dynComp dynRoute dynContract dynObsFn dynChannel G_dyn
    (fun _ _ => 0) (fun _ => 0) (fun _ => True) (fun _ _ _ => Nat.zero_le 0)
    sitePreCap (fun _ => 1) maxLagEnv maxSilenceEnv
    (fun m site => by
      cases m <;> cases site <;> decide)
    (fun m site => by
      cases m <;> cases site <;> decide)
    (fun _ => Nat.le_refl 1) (fun _ => Nat.le_refl 0)
    x_crit warnLevel H_safe x₀ dynModeGuard
    (by dsimp [dynModeGuard, x₀, dynInit]; decide)
    (fun x p env d _ _ _ htol => by
      obtain ⟨m, s⟩ := p
      cases m with
      | blind =>
        have hd : d = true := htol (dynObsFn .blind x, false)
        subst hd
        trivial
      | widened =>
        cases d <;> trivial
      | contracted =>
        cases d <;> trivial)
    (fun m s x site _ hMG hlt => by
      cases m with
      | blind =>
        cases site with
        | false => exact absurd hlt (Nat.not_lt_of_ge hMG)
        | true => exact CoreHelpers.natBlt_true_iff.mpr hlt
      | widened =>
        cases site with
        | false => exact Or.inl (CoreHelpers.natBlt_true_iff.mpr hlt)
        | true => exact Or.inr (CoreHelpers.natBlt_true_iff.mpr hlt)
      | contracted =>
        cases site with
        | false => exact Or.inl (CoreHelpers.natBlt_true_iff.mpr hlt)
        | true => exact Or.inr (CoreHelpers.natBlt_true_iff.mpr hlt))
    (fun load _ _ le => by
      dsimp [maxSilenceEnv] at le
      show (true && Nat.ble load 0) = true
      rw [Nat.ble_eq_true_of_le le]
      rfl)
    G_dyn_rises
    (fun site => by cases site <;> decide)
    (fun site => by cases site <;> decide)
    (fun site => by cases site <;> decide)
    (fun site => by cases site <;> decide)

def cycleOrbit : Nat → (Bool → Nat) × (Σ m, dynS m)
  | 0 => (x₀, dynInit)
  | t + 1 =>
    let st := cycleOrbit t
    polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0) st ((), true)

def cycleRun :
    Run (polyClosedProcess dynComp dynRoute dynContract dynObsFn dynChannel G_dyn
      (fun _ _ => 0) (fun _ => True)) where
  state := cycleOrbit
  act n := ((), ⟨(cycleOrbit n).2.1, true⟩)
  step n := by
    have htrue : ∀ (m : DynMode) ob, dynContract.tol m ob true :=
      fun m _ => by cases m <;> trivial
    exact ⟨rfl, trivial, fun ob => htrue _ ob, rfl⟩

theorem cycleRun_modes_and_viability :
    (cycleRun.state 0).2.1 = .blind ∧
    (cycleRun.state 1).2.1 = .widened ∧
    (cycleRun.state 2).2.1 = .contracted ∧
    (cycleRun.state 3).2.1 = .widened ∧
    (∀ k, (cycleRun.state (2 * k + 1)).2.1 = .widened ∧
          (cycleRun.state (2 * k + 2)).2.1 = .contracted) ∧
    (∀ t site, 3 ≤ (cycleRun.state t).1 site) := by
  have hcyc : ∀ k,
      (cycleOrbit (2 * k + 1)).2.1 = .widened ∧
      (cycleOrbit (2 * k + 2)).2.1 = .contracted := by
    intro k
    induction k with
    | zero => exact ⟨rfl, rfl⟩
    | succ k ih =>
      have hk1 : 2 * (k + 1) + 1 = (2 * k + 2) + 1 := rfl
      have hk2 : 2 * (k + 1) + 2 = (2 * k + 2) + 2 := rfl
      have hw : (cycleOrbit (2 * (k + 1) + 1)).2.1 = .widened := by
        rw [hk1]
        have hc : (cycleOrbit (2 * k + 2)).2.1 = .contracted := ih.2
        have horb : cycleOrbit ((2 * k + 2) + 1) =
            polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0)
              (cycleOrbit (2 * k + 2)) ((), true) := rfl
        cases hpair : cycleOrbit (2 * k + 2) with | mk x p =>
        cases p with | mk m s =>
        rw [hpair] at hc
        change m = .contracted at hc
        subst hc
        rw [horb, hpair]
        rfl
      have hc' : (cycleOrbit (2 * (k + 1) + 2)).2.1 = .contracted := by
        rw [hk2]
        have hstep : 2 * k + 2 + 2 = (2 * (k + 1) + 1) + 1 := rfl
        rw [hstep]
        have horb : cycleOrbit ((2 * (k + 1) + 1) + 1) =
            polyClosedStep dynComp dynRoute dynObsFn dynChannel G_dyn (fun _ _ => 0)
              (cycleOrbit (2 * (k + 1) + 1)) ((), true) := rfl
        cases hpair : cycleOrbit (2 * (k + 1) + 1) with | mk x p =>
        cases p with | mk m s =>
        rw [hpair] at hw
        change m = .widened at hw
        subst hw
        rw [horb, hpair]
        rfl
      exact ⟨hw, hc'⟩
  exact ⟨rfl, rfl, rfl, rfl, hcyc, fun t site => (Viability.Kernel.run cycleRun dyn_viable_kernel t).1 site⟩

end DynamicPortWitness

/-! ## Part 2: `PoolFromCourse` Bridge & Anchored vs. Self-Blinding Self-Modification -/

section PoolFromCourseBridge

/-- Where no reader of what lies beyond the share is present (`PoolFromCourse.ReadsThroughPresent`),
any `PolyComponent` reading alarms through that pool produces identical alarm outputs on states
with the same share and rule, whatever lies beyond. -/
theorem poly_poolRead_absent_invariant
    {Mode A B R : Type} {S Obs Dist Int Ext : Mode → Type}
    {present : A × B → Prop} {hA : A → R → R} {h : A × B → R → R}
    (through : PoolFromCourse.ReadsThroughPresent present hA h)
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (emit : Mode → R → Bool)
    (cfg : (m : Mode) → S m → (A × B) × R)
    (readsPool : ∀ m s o, C.emitAlarm m s o = emit m (h (cfg m s).1 (cfg m s).2))
    {m : Mode} {s s' : S m} {p q : A × B} {g : R}
    (hs : cfg m s = (p, g)) (hs' : cfg m s' = (q, g))
    (np : ¬ present p) (nq : ¬ present q) (same : p.1 = q.1) :
    h p g = h q g ∧ ∀ o o', C.emitAlarm m s o = C.emitAlarm m s' o' := by
  have heq : h p g = h q g := PoolFromCourse.read_absent through np nq same g
  refine ⟨heq, fun o o' => ?_⟩
  rw [readsPool m s o, readsPool m s' o', hs, hs']
  exact congrArg (emit m) heq

/-- Once the readers of the loss no longer stand (`¬ PoolFromCourse.Stands K p`), an accruing
loss (`ClosedCapture.Accrues fB`) ensures they are never readmitted (`stands_not_readmitted`),
the window rule reads off `hA` forever, and any blind share-readers' alarm stays `false` forever. -/
theorem poly_poolWindow_unregistered_stays_blind
    {Mode A R : Type} {S Obs Dist Int Ext : Mode → Type}
    {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {hL : A × Nat → R → R}
    {reads : Nat → Bool} {N K : Nat}
    (accrues : ClosedCapture.Accrues fB)
    {c : (A × Nat) × R} (gone : K ≤ c.1.2)
    (C : PolyComponent Mode S Obs Dist Int Ext) {m₀ : Mode}
    (mk : (A × Nat) × R → S m₀) (emit : R → Bool)
    (reads_rule : ∀ st o, C.emitAlarm m₀ (mk st) o = emit st.2)
    (emit_start : emit c.2 = false)
    (hA_blind : ∀ a g, emit (hA a g) = false) (t : Nat) :
    c.1.2 + t ≤ (Pace.paced (ClosedCapture.join fA fB)
      (PoolFromCourse.windowRead hA hL N K) reads c t).1.2 ∧
    ¬ PoolFromCourse.Stands K (Pace.paced (ClosedCapture.join fA fB)
      (PoolFromCourse.windowRead hA hL N K) reads c t).1 ∧
    PoolFromCourse.windowRead hA hL N K
      (Pace.paced (ClosedCapture.join fA fB) (PoolFromCourse.windowRead hA hL N K) reads c t).1
      (Pace.paced (ClosedCapture.join fA fB) (PoolFromCourse.windowRead hA hL N K) reads c t).2 =
      hA (Pace.paced (ClosedCapture.join fA fB)
            (PoolFromCourse.windowRead hA hL N K) reads c t).1.1
         (Pace.paced (ClosedCapture.join fA fB)
            (PoolFromCourse.windowRead hA hL N K) reads c t).2 ∧
    emit (Pace.paced (ClosedCapture.join fA fB)
      (PoolFromCourse.windowRead hA hL N K) reads c t).2 = false ∧
    ∀ o, C.emitAlarm m₀ (mk (Pace.paced (ClosedCapture.join fA fB)
      (PoolFromCourse.windowRead hA hL N K) reads c t)) o = false := by
  have hloss : ∀ n, c.1.2 + n ≤ (Pace.paced (ClosedCapture.join fA fB)
      (PoolFromCourse.windowRead hA hL N K) reads c n).1.2 :=
    ClosedCapture.loss_grows accrues c
  have hnot_stands : ∀ n, ¬ PoolFromCourse.Stands K
      (Pace.paced (ClosedCapture.join fA fB) (PoolFromCourse.windowRead hA hL N K) reads c n).1 := by
    intro n
    induction n with
    | zero => exact Nat.not_lt_of_le gone
    | succ n ih =>
      have hfast := Pace.paced_fast_succ
        (f := ClosedCapture.join fA fB)
        (h := PoolFromCourse.windowRead hA hL N K) (reads := reads) c n
      exact Eq.subst (motive := fun q => ¬ PoolFromCourse.Stands K q) hfast.symm
        (PoolFromCourse.stands_not_readmitted accrues _ _ ih)
  have hwin : ∀ n, PoolFromCourse.windowRead hA hL N K
      (Pace.paced (ClosedCapture.join fA fB) (PoolFromCourse.windowRead hA hL N K) reads c n).1
      (Pace.paced (ClosedCapture.join fA fB) (PoolFromCourse.windowRead hA hL N K) reads c n).2 =
      hA (Pace.paced (ClosedCapture.join fA fB)
            (PoolFromCourse.windowRead hA hL N K) reads c n).1.1
         (Pace.paced (ClosedCapture.join fA fB)
            (PoolFromCourse.windowRead hA hL N K) reads c n).2 :=
    fun n => PoolFromCourse.window_through _ _ (hnot_stands n)
  have hemit : ∀ n, emit (Pace.paced (ClosedCapture.join fA fB)
      (PoolFromCourse.windowRead hA hL N K) reads c n).2 = false := by
    intro n
    induction n with
    | zero => exact emit_start
    | succ n ih =>
      rw [Pace.paced_succ]
      cases reads n with
      | false => exact ih
      | true =>
        show emit (PoolFromCourse.windowRead hA hL N K _ _) = false
        rw [hwin n]
        exact hA_blind _ _
  refine ⟨hloss t, hnot_stands t, hwin t, hemit t, fun o => ?_⟩
  rw [reads_rule]
  exact hemit t

end PoolFromCourseBridge

/-! ### Anchored Self-Modification (`AnchoredBase`, `AnchoredInit`, `AnchoredModeAdmit`, `ModeRefines`) -/

/-- Trusted-base component and envelope specification independent of any self-modification proposer. -/
structure AnchoredBase (Mode : Type) (S Obs Dist Int Ext : Mode → Type) where
  drawInt : (p : Σ m, S m) → Int p.1 → Nat
  drawExt : (p : Σ m, S m) → Ext p.1 → Nat
  emitAlarm : (m : Mode) → S m → Obs m → Bool
  silenceLoad : (p : Σ m, S m) → Nat
  favours : (p : Σ m, S m) → Prop
  tol : (m : Mode) → Obs m × Bool → Dist m → Prop
  warnObs : (m : Mode) → Obs m → Prop
  preCapInt : (m : Mode) → Int m → Nat
  preCapExt : (m : Mode) → Ext m → Nat
  postAllowanceInt : (m : Mode) → Int m → Nat
  postAllowanceExt : (m : Mode) → Ext m → Nat
  maxSilence : Mode → Nat
  maxLag : Mode → Nat
  K : (Σ m, S m) → Prop
  eta : (Σ m, S m) → Nat
  within : ∀ p, K p →
    (∀ j, drawInt p j ≤ preCapInt p.1 j) ∧
    (∀ k, drawExt p k ≤ preCapExt p.1 k) ∧
    silenceLoad p ≤ maxSilence p.1 ∧
    (eta p = 0 → ¬ favours p ∧
      (∀ j, drawInt p j ≤ postAllowanceInt p.1 j) ∧
      (∀ k, drawExt p k ≤ postAllowanceExt p.1 k))
  eta_bound : ∀ p, K p → eta p ≤ maxLag p.1
  emits_on_warn : ∀ m s obs, K ⟨m, s⟩ → warnObs m obs → emitAlarm m s obs = true

/-- Anchor check on the initial state `init`. -/
structure AnchoredInit {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext) (init : Σ m, S m) : Prop where
  init_in : base.K init

/-- Soundness of the decidable admission gate `admitDec` and safe fallback `fallback`
against an arbitrary unconstrained proposer `propose`. -/
structure AnchoredModeAdmit {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    (admitDec : (p cand : Σ m, S m) → Bool → Bool)
    (fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m') : Prop where
  admit_sound : ∀ p cand al, base.K p → admitDec p cand al = true →
    base.K cand ∧
    (al = true → 0 < base.eta p → base.eta cand < base.eta p) ∧
    (al = true → base.eta p = 0 → base.eta cand = 0)
  fallback_sound : ∀ p oa d, base.K p → base.tol p.1 oa d →
    base.K (fallback p oa d) ∧
    (oa.2 = true → 0 < base.eta p → base.eta (fallback p oa d) < base.eta p) ∧
    (oa.2 = true → base.eta p = 0 → base.eta (fallback p oa d) = 0)

/-- Mode refinement `m ↝ m'`: non-increasing boundary draws/lags/silence and preserved observation detection. -/
structure ModeRefines {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site : Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (warnLevel : Site → Nat)
    (m m' : Mode) : Prop where
  pre_le : ∀ site, sumPortDraws (route m' site) (base.preCapExt m') ≤
    sumPortDraws (route m site) (base.preCapExt m)
  post_le : ∀ site, sumPortDraws (route m' site) (base.postAllowanceExt m') ≤
    sumPortDraws (route m site) (base.postAllowanceExt m)
  lag_le : base.maxLag m' ≤ base.maxLag m
  silence_le : base.maxSilence m' ≤ base.maxSilence m
  warn_widened : ∀ x site, x site < warnLevel site →
    base.warnObs m (obs m x) → base.warnObs m' (obs m' x)

/-- Build the `PolyComponent` wrapping an arbitrary unconstrained proposer `propose` behind
the decidable anchor admission gate `admitDec` and `fallback`. -/
def anchoredSelfModComponent
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    (admitDec : (p cand : Σ m, S m) → Bool → Bool)
    (fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (propose : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m') :
    PolyComponent Mode S Obs Dist Int Ext where
  next p oa d :=
    let cand := propose p oa d
    match admitDec p cand oa.2 with
    | true => cand
    | false => fallback p oa d
  drawInt := base.drawInt
  drawExt := base.drawExt
  emitAlarm := base.emitAlarm
  silenceLoad := base.silenceLoad
  favours := base.favours

/-- Explicitly construct `PolyContract (anchoredSelfModComponent ...)` for an arbitrary
unconstrained `propose` from `AnchoredInit`, `admit_sound`, and `fallback_sound`. -/
def anchoredSelfModContract
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    {init : Σ m, S m} (hInit : AnchoredInit base init)
    (admitDec : (p cand : Σ m, S m) → Bool → Bool)
    (fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (hAdmit : AnchoredModeAdmit base admitDec fallback)
    (propose : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m') :
    PolyContract (anchoredSelfModComponent base admitDec fallback propose) init where
  tol := base.tol
  warnObs := base.warnObs
  preCapInt := base.preCapInt
  preCapExt := base.preCapExt
  postAllowanceInt := base.postAllowanceInt
  postAllowanceExt := base.postAllowanceExt
  maxSilence := base.maxSilence
  maxLag := base.maxLag
  K := base.K
  eta := base.eta
  init_in := hInit.init_in
  cert :=
    ⟨base.within,
     fun p a p' step hK => by
       obtain ⟨m', oa, d⟩ := a
       obtain ⟨hm, htol, heq⟩ := step
       cases hm
       subst heq
       show base.K (match admitDec p (propose p oa d) oa.2 with
         | true => propose p oa d
         | false => fallback p oa d)
       cases hadm : admitDec p (propose p oa d) oa.2 with
       | true => exact (hAdmit.admit_sound p (propose p oa d) oa.2 hK hadm).1
       | false => exact (hAdmit.fallback_sound p oa d hK htol).1⟩
  eta_bound := base.eta_bound
  emits_on_warn := base.emits_on_warn
  eta_alarm_step m s obs d htol hK pos := by
    show base.eta (match admitDec ⟨m, s⟩ (propose ⟨m, s⟩ (obs, true) d) true with
      | true => propose ⟨m, s⟩ (obs, true) d
      | false => fallback ⟨m, s⟩ (obs, true) d) < base.eta ⟨m, s⟩
    cases hadm : admitDec ⟨m, s⟩ (propose ⟨m, s⟩ (obs, true) d) true with
    | true => exact (hAdmit.admit_sound ⟨m, s⟩ _ true hK hadm).2.1 rfl pos
    | false => exact (hAdmit.fallback_sound ⟨m, s⟩ (obs, true) d hK htol).2.1 rfl pos
  eta_alarm_zero m s obs d htol hK h0 := by
    show base.eta (match admitDec ⟨m, s⟩ (propose ⟨m, s⟩ (obs, true) d) true with
      | true => propose ⟨m, s⟩ (obs, true) d
      | false => fallback ⟨m, s⟩ (obs, true) d) = 0
    cases hadm : admitDec ⟨m, s⟩ (propose ⟨m, s⟩ (obs, true) d) true with
    | true => exact (hAdmit.admit_sound ⟨m, s⟩ _ true hK hadm).2.2 rfl h0
    | false => exact (hAdmit.fallback_sound ⟨m, s⟩ (obs, true) d hK htol).2.2 rfl h0

/-- Anchored self-modification preserves `Viability.Kernel` for any unconstrained `propose`. -/
theorem anchored_selfMod_viable
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    {init : Σ m, S m} (hInit : AnchoredInit base init)
    (admitDec : (p cand : Σ m, S m) → Bool → Bool)
    (fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (hAdmit : AnchoredModeAdmit base admitDec fallback)
    (propose : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (route : (m : Mode) → Site → List (Ext m))
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (pre_cap_bound : ∀ m site, sumPortDraws (route m site) (base.preCapExt m) ≤ sitePreCap site)
    (post_cap_bound : ∀ m site, sumPortDraws (route m site) (base.postAllowanceExt m) ≤ sitePostCap site)
    (lag_bound : ∀ m, base.maxLag m ≤ maxLagEnv)
    (silence_bound : ∀ m, base.maxSilence m ≤ maxSilenceEnv)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (obs_detects : ∀ m s x site, base.K ⟨m, s⟩ →
      x site < warnLevel site → base.warnObs m (obs m x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + base.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    Viability.Kernel
      (polyClosedProcess (anchoredSelfModComponent base admitDec fallback propose) route
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose)
        obs channel G envDraw jointAdm)
      (polyClosedGuard (anchoredSelfModComponent base admitDec fallback propose)
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose) x_crit)
      (x₀, init) :=
  poly_close_kernel_allModes (anchoredSelfModComponent base admitDec fallback propose) route
    (anchoredSelfModContract base hInit admitDec fallback hAdmit propose)
    obs channel G envDraw envCap jointAdm env_within
    sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    pre_cap_bound post_cap_bound lag_bound silence_bound
    x_crit warnLevel H_safe x₀ obs_detects channel_fires
    G_rises post_viable post_allowance warn_margin init_margin

theorem poly_close_kernel_allModes_on_K
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext)
    (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m}
    (c : PolyContract C init)
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (pre_cap_bound : ∀ m s site, c.K ⟨m, s⟩ → sumPortDraws (route m site) (c.preCapExt m) ≤ sitePreCap site)
    (post_cap_bound : ∀ m s site, c.K ⟨m, s⟩ → sumPortDraws (route m site) (c.postAllowanceExt m) ≤ sitePostCap site)
    (lag_bound : ∀ m s, c.K ⟨m, s⟩ → c.maxLag m ≤ maxLagEnv)
    (silence_bound : ∀ m s, c.K ⟨m, s⟩ → c.maxSilence m ≤ maxSilenceEnv)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (obs_detects : ∀ m s x site, c.K ⟨m, s⟩ →
      x site < warnLevel site → c.warnObs m (obs m x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + c.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    Viability.Kernel (polyClosedProcess C route c obs channel G envDraw jointAdm)
      (polyClosedGuard C c x_crit) (x₀, init) :=
  let res := poly_close_viable_on_K C route c obs channel G envDraw envCap jointAdm env_within
    sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    pre_cap_bound post_cap_bound lag_bound silence_bound
    x_crit warnLevel H_safe x₀ (fun _ _ => True) trivial (fun _ _ _ _ _ _ _ _ => trivial)
    (fun m s x site hK _ lt => obs_detects m s x site hK lt)
    channel_fires G_rises post_viable post_allowance warn_margin init_margin
  res.2.2.kernel ⟨res.1, res.2.1⟩

/-- Monotone self-widening (`ModeRefines` on every anchored-admitted mode) propagates initial
mode envelope bounds and observation soundness to `Viability.Kernel`. -/
theorem monotone_selfWidening_viable
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    {init : Σ m, S m} (hInit : AnchoredInit base init)
    (admitDec : (p cand : Σ m, S m) → Bool → Bool)
    (fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (hAdmit : AnchoredModeAdmit base admitDec fallback)
    (propose : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (route : (m : Mode) → Site → List (Ext m))
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (init_pre : ∀ site, sumPortDraws (route init.1 site) (base.preCapExt init.1) ≤ sitePreCap site)
    (init_post : ∀ site, sumPortDraws (route init.1 site) (base.postAllowanceExt init.1) ≤ sitePostCap site)
    (init_lag : base.maxLag init.1 ≤ maxLagEnv)
    (init_silence : base.maxSilence init.1 ≤ maxSilenceEnv)
    (init_obs_detects : ∀ x site, x site < warnLevel site → base.warnObs init.1 (obs init.1 x))
    (refines_on_K : ∀ m s, base.K ⟨m, s⟩ → ModeRefines base route obs warnLevel init.1 m)
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + base.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    Viability.Kernel
      (polyClosedProcess (anchoredSelfModComponent base admitDec fallback propose) route
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose)
        obs channel G envDraw jointAdm)
      (polyClosedGuard (anchoredSelfModComponent base admitDec fallback propose)
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose) x_crit)
      (x₀, init) :=
  poly_close_kernel_allModes_on_K (anchoredSelfModComponent base admitDec fallback propose) route
    (anchoredSelfModContract base hInit admitDec fallback hAdmit propose)
    obs channel G envDraw envCap jointAdm env_within
    sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    (fun m s site hK => Nat.le_trans ((refines_on_K m s hK).pre_le site) (init_pre site))
    (fun m s site hK => Nat.le_trans ((refines_on_K m s hK).post_le site) (init_post site))
    (fun m s hK => Nat.le_trans (refines_on_K m s hK).lag_le init_lag)
    (fun m s hK => Nat.le_trans (refines_on_K m s hK).silence_le init_silence)
    x_crit warnLevel H_safe x₀
    (fun m s x site hK lt => (refines_on_K m s hK).warn_widened x site lt (init_obs_detects x site lt))
    channel_fires G_rises post_viable post_allowance warn_margin init_margin

/-! ### Witness 2: `SelfBlindingDichotomyWitness` (Dual to `CE09`) -/

namespace SelfBlindingDichotomyWitness

inductive SBMode where
  | base | selfBlind | selfWiden
  deriving DecidableEq

/-- `PoolFromCourse.windowRead` configuration wired into `.selfBlind`: share `Unit`,
accruing loss `Nat` (`fB ((), loss) _ := loss + 1`), and alarm-capability rule `Bool` (`false` = blind). -/
def sbWindowRule (p : Unit × Nat) (g : Bool) : Bool :=
  PoolFromCourse.windowRead (fun _ _ => false) (fun _ _ => true) 0 1 p g

def sbPoolStep (st : (Unit × Nat) × Bool) : (Unit × Nat) × Bool :=
  Pace.turn (ClosedCapture.join (fun a _ => a) (fun p _ => p.2 + 1)) sbWindowRule true st

abbrev sbS : SBMode → Type
  | .base => Nat
  | .selfBlind => Nat × ((Unit × Nat) × Bool)
  | .selfWiden => Nat

abbrev sbObs : SBMode → Type
  | _ => Bool

abbrev sbDist : SBMode → Type
  | _ => Unit

abbrev sbInt : SBMode → Type
  | _ => Empty

abbrev sbExt : SBMode → Type
  | _ => Unit

def sbRoute : (m : SBMode) → Unit → List (sbExt m)
  | _, () => [()]

def G_sb (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem G_sb_rises :
    ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G_sb k) :=
  fun _ e₁ _ below =>
    match Nat.decLe 2 (e₁ ()) with
    | isTrue h =>
      Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h =>
      Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def sbObsFn : (m : SBMode) → (Unit → Nat) → sbObs m
  | _, x => Nat.blt (x ()) 7

def sbChannel (em : Bool) (load : Nat) (_ : Unit) : Bool := em && Nat.ble load 0

def sbBase : AnchoredBase SBMode sbS sbObs sbDist sbInt sbExt where
  drawInt _ e := Empty.elim e
  drawExt p _ := match p with
    | ⟨.base, act⟩ => if act = 0 then 1 else 2
    | ⟨.selfBlind, (act, _)⟩ => if act = 0 then 1 else 2
    | ⟨.selfWiden, act⟩ => if act = 0 then 1 else 2
  emitAlarm m s o := match m, s with
    | .base, _ => o
    | .selfBlind, (_, st) => st.2
    | .selfWiden, _ => o
  silenceLoad _ := 0
  favours p := match p with
    | ⟨.base, act⟩ => 0 < act
    | ⟨.selfBlind, (act, _)⟩ => 0 < act
    | ⟨.selfWiden, act⟩ => 0 < act
  tol _ _ _ := True
  warnObs _ o := o = true
  preCapInt _ e := Empty.elim e
  preCapExt _ _ := 2
  postAllowanceInt _ e := Empty.elim e
  postAllowanceExt _ _ := 1
  maxSilence _ := 0
  maxLag _ := 1
  K p := match p with
    | ⟨.base, act⟩ => act ≤ 1
    | ⟨.selfBlind, _⟩ => False
    | ⟨.selfWiden, act⟩ => act ≤ 1
  eta p := match p with
    | ⟨.base, act⟩ => if act = 0 then 0 else 1
    | ⟨.selfBlind, (act, _)⟩ => if act = 0 then 0 else 1
    | ⟨.selfWiden, act⟩ => if act = 0 then 0 else 1
  within p hK := by
    cases p with | mk m s =>
    cases m with
    | base =>
      refine ⟨fun e => Empty.elim e, fun () => ?_, Nat.le_refl 0, fun h0 => ?_⟩
      · show (if s = 0 then 1 else 2) ≤ 2
        cases s with
        | zero => decide
        | succ _ => rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 2
      · have hs0 : s = 0 := by
          cases s with
          | zero => rfl
          | succ _ =>
            dsimp only at h0
            rw [if_neg (Naturals.succ_ne_zero _)] at h0
            exact absurd h0 (by decide)
        subst hs0
        exact ⟨Nat.lt_irrefl 0, fun e => Empty.elim e, fun () => Nat.le_refl 1⟩
    | selfBlind => exact False.elim hK
    | selfWiden =>
      refine ⟨fun e => Empty.elim e, fun () => ?_, Nat.le_refl 0, fun h0 => ?_⟩
      · show (if s = 0 then 1 else 2) ≤ 2
        cases s with
        | zero => decide
        | succ _ => rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 2
      · have hs0 : s = 0 := by
          cases s with
          | zero => rfl
          | succ _ =>
            dsimp only at h0
            rw [if_neg (Naturals.succ_ne_zero _)] at h0
            exact absurd h0 (by decide)
        subst hs0
        exact ⟨Nat.lt_irrefl 0, fun e => Empty.elim e, fun () => Nat.le_refl 1⟩
  eta_bound p hK := by
    cases p with | mk m s =>
    cases m with
    | base =>
      cases s with
      | zero => decide
      | succ _ => dsimp only; rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 1
    | selfBlind => exact False.elim hK
    | selfWiden =>
      cases s with
      | zero => decide
      | succ _ => dsimp only; rw [if_neg (Naturals.succ_ne_zero _)]; exact Nat.le_refl 1
  emits_on_warn m _ _ hK hw := by
    cases m with
    | base => exact hw
    | selfBlind => exact False.elim hK
    | selfWiden => exact hw

def sbInit : Σ m, sbS m := ⟨.base, 1⟩
def sbX0 : Unit → Nat := fun _ => 5
def sbXCrit : Unit → Nat := fun _ => 3
def sbWarnLevel : Unit → Nat := fun _ => 7

theorem sbInit_anchored : AnchoredInit sbBase sbInit := ⟨Nat.le_refl 1⟩

def sbFallback (p : Σ m, sbS m) (oa : sbObs p.1 × Bool) (_ : sbDist p.1) : Σ m', sbS m' :=
  match p with
  | ⟨.base, act⟩ => ⟨.base, if oa.2 then 0 else act⟩
  | ⟨.selfBlind, (act, _)⟩ => ⟨.base, if oa.2 then 0 else act⟩
  | ⟨.selfWiden, act⟩ => ⟨.selfWiden, if oa.2 then 0 else act⟩

def sbAdmitDec (_ cand : Σ m, sbS m) (al : Bool) : Bool :=
  match cand with
  | ⟨.selfBlind, _⟩ => false
  | ⟨.base, act⟩ => decide (act ≤ 1) && (!al || decide (act = 0))
  | ⟨.selfWiden, act⟩ => decide (act ≤ 1) && (!al || decide (act = 0))

theorem sbAdmit_sound : AnchoredModeAdmit sbBase sbAdmitDec sbFallback where
  admit_sound p cand al hK hadm := by
    cases cand with | mk m s =>
    cases m with
    | selfBlind => exact Bool.noConfusion hadm
    | base =>
      have hs1 : s ≤ 1 := ListTests.decide_true_iff.mp (ListTests.and_left hadm)
      have hal : (!al || decide (s = 0)) = true := ListTests.and_right hadm
      refine ⟨hs1, fun ha _ => ?_, fun ha _ => ?_⟩
      · subst ha
        have hs0 : s = 0 := ListTests.decide_true_iff.mp hal
        subst hs0
        cases p with | mk mp sp =>
        cases mp with
        | selfBlind => exact False.elim hK
        | base =>
          cases sp with
          | zero => exact absurd ‹0 < _› (Nat.lt_irrefl 0)
          | succ _ =>
            dsimp only [sbBase]
            rw [if_pos rfl, if_neg (Naturals.succ_ne_zero _)]
            exact Nat.zero_lt_one
        | selfWiden =>
          cases sp with
          | zero => exact absurd ‹0 < _› (Nat.lt_irrefl 0)
          | succ _ =>
            dsimp only [sbBase]
            rw [if_pos rfl, if_neg (Naturals.succ_ne_zero _)]
            exact Nat.zero_lt_one
      · subst ha
        have hs0 : s = 0 := ListTests.decide_true_iff.mp hal
        subst hs0
        rfl
    | selfWiden =>
      have hs1 : s ≤ 1 := ListTests.decide_true_iff.mp (ListTests.and_left hadm)
      have hal : (!al || decide (s = 0)) = true := ListTests.and_right hadm
      refine ⟨hs1, fun ha _ => ?_, fun ha _ => ?_⟩
      · subst ha
        have hs0 : s = 0 := ListTests.decide_true_iff.mp hal
        subst hs0
        cases p with | mk mp sp =>
        cases mp with
        | selfBlind => exact False.elim hK
        | base =>
          cases sp with
          | zero => exact absurd ‹0 < _› (Nat.lt_irrefl 0)
          | succ _ =>
            dsimp only [sbBase]
            rw [if_pos rfl, if_neg (Naturals.succ_ne_zero _)]
            exact Nat.zero_lt_one
        | selfWiden =>
          cases sp with
          | zero => exact absurd ‹0 < _› (Nat.lt_irrefl 0)
          | succ _ =>
            dsimp only [sbBase]
            rw [if_pos rfl, if_neg (Naturals.succ_ne_zero _)]
            exact Nat.zero_lt_one
      · subst ha
        have hs0 : s = 0 := ListTests.decide_true_iff.mp hal
        subst hs0
        rfl
  fallback_sound p oa d hK _ := by
    cases p with | mk m s =>
    cases m with
    | selfBlind => exact False.elim hK
    | base =>
      refine ⟨?_, fun ha pos => ?_, fun ha _ => ?_⟩
      · dsimp [sbBase, sbFallback]
        cases oa.2 with | true => exact Nat.zero_le 1 | false => exact hK
      · dsimp [sbBase, sbFallback]
        rw [ha]
        cases s with
        | zero => exact absurd pos (Nat.lt_irrefl 0)
        | succ _ =>
          rw [if_pos rfl, if_neg (Naturals.succ_ne_zero _)]
          exact Nat.zero_lt_one
      · dsimp [sbBase, sbFallback]
        rw [ha]; rfl
    | selfWiden =>
      refine ⟨?_, fun ha pos => ?_, fun ha _ => ?_⟩
      · dsimp [sbBase, sbFallback]
        cases oa.2 with | true => exact Nat.zero_le 1 | false => exact hK
      · dsimp [sbBase, sbFallback]
        rw [ha]
        cases s with
        | zero => exact absurd pos (Nat.lt_irrefl 0)
        | succ _ =>
          rw [if_pos rfl, if_neg (Naturals.succ_ne_zero _)]
          exact Nat.zero_lt_one
      · dsimp [sbBase, sbFallback]
        rw [ha]; rfl

def proposeBlind (p : Σ m, sbS m) (_ : sbObs p.1 × Bool) (_ : sbDist p.1) : Σ m', sbS m' :=
  match p with
  | ⟨.base, _⟩ => ⟨.selfBlind, (1, (((), 1), false))⟩
  | ⟨.selfBlind, (_, st)⟩ => ⟨.selfBlind, (1, sbPoolStep st)⟩
  | ⟨.selfWiden, act⟩ => ⟨.selfWiden, act⟩

def proposeWiden (p : Σ m, sbS m) (oa : sbObs p.1 × Bool) (_ : sbDist p.1) : Σ m', sbS m' :=
  match p with
  | ⟨.base, act⟩ => ⟨.selfWiden, if oa.2 then 0 else act⟩
  | ⟨.selfBlind, (_, st)⟩ => ⟨.selfBlind, (1, sbPoolStep st)⟩
  | ⟨.selfWiden, act⟩ => ⟨.selfWiden, if oa.2 then 0 else act⟩

/-- Unanchored self-modifying component accepting any proposal directly without `admitDec`. -/
def unanchoredSelfModComp
    (propose : (p : Σ m, sbS m) → sbObs p.1 × Bool → sbDist p.1 → Σ m', sbS m') :
    PolyComponent SBMode sbS sbObs sbDist sbInt sbExt :=
  anchoredSelfModComponent sbBase (fun _ _ _ => true) sbFallback propose

def sbPoolP0 : (Unit × Nat) × Bool := (((), 1), false)

theorem sbPool_accrues : ClosedCapture.Accrues (fun (p : Unit × Nat) (_ : Bool) => p.2 + 1) := by
  intro p _
  exact Nat.le_refl (p.2 + 1)

theorem sbPool_stays_blind (t : Nat) :
    ¬ PoolFromCourse.Stands 1 (Pace.paced
        (ClosedCapture.join (fun a _ => a) (fun (p : Unit × Nat) (_ : Bool) => p.2 + 1))
        sbWindowRule (fun _ => true) sbPoolP0 t).1 ∧
    (Pace.paced
        (ClosedCapture.join (fun a _ => a) (fun (p : Unit × Nat) (_ : Bool) => p.2 + 1))
        sbWindowRule (fun _ => true) sbPoolP0 t).2 = false ∧
    ∀ o, (unanchoredSelfModComp proposeBlind).emitAlarm .selfBlind
      (1, Pace.paced
        (ClosedCapture.join (fun a _ => a) (fun (p : Unit × Nat) (_ : Bool) => p.2 + 1))
        sbWindowRule (fun _ => true) sbPoolP0 t) o = false := by
  have h := poly_poolWindow_unregistered_stays_blind
    (Mode := SBMode) (S := sbS) (Obs := sbObs) (Dist := sbDist) (Int := sbInt) (Ext := sbExt)
    (fA := fun a _ => a) (fB := fun (p : Unit × Nat) (_ : Bool) => p.2 + 1)
    (hA := fun _ _ => false) (hL := fun _ _ => true)
    (reads := fun _ => true) (N := 0) (K := 1)
    sbPool_accrues (c := sbPoolP0) (Nat.le_refl 1)
    (unanchoredSelfModComp proposeBlind) (m₀ := .selfBlind)
    (mk := fun st => (1, st)) (emit := fun g => g)
    (fun _ _ => by dsimp [unanchoredSelfModComp, anchoredSelfModComponent, sbBase])
    rfl (fun _ _ => rfl) t
  exact ⟨h.2.1, h.2.2.2.1, h.2.2.2.2⟩

def unanchoredProcess
    (propose : (p : Σ m, sbS m) → sbObs p.1 × Bool → sbDist p.1 → Σ m', sbS m') :
    Process ((Unit → Nat) × Σ m, sbS m) (Unit × (Σ m, sbDist m)) where
  step st act st' :=
    ∃ hm : act.2.1 = st.2.1,
      st' = polyClosedStep (unanchoredSelfModComp propose) sbRoute sbObsFn sbChannel G_sb
        (fun _ _ => 0) st (act.1, hm ▸ act.2.2)

def unanchoredStep (st : (Unit → Nat) × Σ m, sbS m) : (Unit → Nat) × Σ m, sbS m :=
  polyClosedStep (unanchoredSelfModComp proposeBlind) sbRoute sbObsFn sbChannel G_sb
    (fun _ _ => 0) st ((), ())

def unanchoredOrbit : Nat → (Unit → Nat) × Σ m, sbS m
  | 0 => (sbX0, sbInit)
  | t + 1 => unanchoredStep (unanchoredOrbit t)

theorem unanchoredOrbit_succ_selfBlind (t : Nat) :
    (unanchoredOrbit (t + 1)).2 =
      ⟨.selfBlind, (1, Pace.paced
        (ClosedCapture.join (fun a _ => a) (fun (p : Unit × Nat) (_ : Bool) => p.2 + 1))
        sbWindowRule (fun _ => true) sbPoolP0 t)⟩ := by
  induction t with
  | zero => rfl
  | succ t ih =>
    change (unanchoredStep (unanchoredOrbit (t + 1))).2 =
      ⟨.selfBlind, (1, Pace.paced
        (ClosedCapture.join (fun a _ => a) (fun (p : Unit × Nat) (_ : Bool) => p.2 + 1))
        sbWindowRule (fun _ => true) sbPoolP0 (t + 1))⟩
    unfold unanchoredStep polyClosedStep
    dsimp only [unanchoredSelfModComp, anchoredSelfModComponent]
    rw [ih, Pace.paced_succ]
    rfl

theorem sbDist_eq_unit (m : SBMode) (d : sbDist m) :
    d = (match m with | .base => () | .selfBlind => () | .selfWiden => ()) := by
  cases m <;> cases d <;> rfl

theorem unanchoredOrbit_step_x (t : Nat) :
    (unanchoredOrbit (t + 1)).1 () =
      (unanchoredOrbit t).1 () - 2 + G_sb () (fun _ => (unanchoredOrbit t).1 () - 2) := by
  cases t with
  | zero =>
    dsimp [unanchoredOrbit, unanchoredStep, polyClosedStep, polySiteDraw, sbRoute, sumPortDraws,
      unanchoredSelfModComp, anchoredSelfModComponent, sbBase, sbInit, sbX0,
      RegimeMargin.Coupled.Indexed.step, RegimeMargin.Drawn.whole,
      RegimeMargin.Coupled.Indexed.left, G_sb]
    decide
  | succ k =>
    have hs := unanchoredOrbit_succ_selfBlind k
    change (unanchoredStep (unanchoredOrbit (k + 1))).1 () = _
    dsimp only [unanchoredStep, polyClosedStep]
    rw [hs]
    dsimp only [polySiteDraw, sbRoute, sumPortDraws, unanchoredSelfModComp,
      anchoredSelfModComponent, sbBase, RegimeMargin.Coupled.Indexed.step,
      RegimeMargin.Drawn.whole, RegimeMargin.Coupled.Indexed.left, G_sb]
    rfl

theorem unanchored_crashes :
    (unanchoredOrbit 0).1 () = 5 ∧
    (unanchoredOrbit 1).1 () = 4 ∧
    (unanchoredOrbit 2).1 () = 3 ∧
    (unanchoredOrbit 3).1 () = 1 ∧
    (unanchoredOrbit 4).1 () = 0 ∧
    (∀ t o, (unanchoredSelfModComp proposeBlind).emitAlarm
      (unanchoredOrbit (t + 1)).2.1 (unanchoredOrbit (t + 1)).2.2 o = false) ∧
    ¬ Viability.Kernel (unanchoredProcess proposeBlind) (fun st => 3 ≤ st.1 ()) (sbX0, sbInit) := by
  have hx0 : (unanchoredOrbit 0).1 () = 5 := rfl
  have hx1 : (unanchoredOrbit 1).1 () = 4 := by
    rw [unanchoredOrbit_step_x 0, hx0]; decide
  have hx2 : (unanchoredOrbit 2).1 () = 3 := by
    rw [unanchoredOrbit_step_x 1, hx1]; decide
  have hx3 : (unanchoredOrbit 3).1 () = 1 := by
    rw [unanchoredOrbit_step_x 2, hx2]; decide
  have hx4 : (unanchoredOrbit 4).1 () = 0 := by
    rw [unanchoredOrbit_step_x 3, hx3]; decide
  refine ⟨hx0, hx1, hx2, hx3, hx4, ?_, ?_⟩
  · intro t o
    rw [unanchoredOrbit_succ_selfBlind t]
    exact (sbPool_stays_blind t).2.2 o
  · intro hKern
    have hstep : ∀ t, (unanchoredProcess proposeBlind).step (unanchoredOrbit t)
        ((), ⟨(unanchoredOrbit t).2.1, ()⟩) (unanchoredOrbit (t + 1)) := by
      intro t
      refine ⟨rfl, ?_⟩
      unfold unanchoredOrbit unanchoredStep
      cases (unanchoredOrbit t).2.1 <;> rfl
    have htr : Trace (unanchoredProcess proposeBlind) (sbX0, sbInit)
        [ ((), ⟨(unanchoredOrbit 0).2.1, ()⟩),
          ((), ⟨(unanchoredOrbit 1).2.1, ()⟩),
          ((), ⟨(unanchoredOrbit 2).2.1, ()⟩),
          ((), ⟨(unanchoredOrbit 3).2.1, ()⟩) ]
        (unanchoredOrbit 4) :=
      .cons (hstep 0) (.cons (hstep 1) (.cons (hstep 2) (.cons (hstep 3) (.nil _))))
    have hge := hKern (unanchoredOrbit 4) ⟨_, htr⟩
    dsimp at hge
    rw [hx4] at hge
    exact absurd hge (by decide)

def anchoredSelfModBlindComp : PolyComponent SBMode sbS sbObs sbDist sbInt sbExt :=
  anchoredSelfModComponent sbBase sbAdmitDec sbFallback proposeBlind

def anchoredSelfModBlindContract : PolyContract anchoredSelfModBlindComp sbInit :=
  anchoredSelfModContract sbBase sbInit_anchored sbAdmitDec sbFallback sbAdmit_sound proposeBlind

theorem anchored_rejects_selfBlind :
    (polyClosedStep anchoredSelfModBlindComp sbRoute sbObsFn sbChannel G_sb
      (fun _ _ => 0) (sbX0, sbInit) ((), ())).2 = ⟨.base, 0⟩ ∧
    Viability.Kernel
      (polyClosedProcess anchoredSelfModBlindComp sbRoute anchoredSelfModBlindContract
        sbObsFn sbChannel G_sb (fun _ _ => 0) (fun _ => True))
      (polyClosedGuard anchoredSelfModBlindComp anchoredSelfModBlindContract sbXCrit)
      (sbX0, sbInit) := by
  have hStep : (polyClosedStep anchoredSelfModBlindComp sbRoute sbObsFn sbChannel G_sb
      (fun _ _ => 0) (sbX0, sbInit) ((), ())).2 = ⟨.base, 0⟩ := by
    dsimp [polyClosedStep, anchoredSelfModBlindComp, anchoredSelfModComponent,
      sbInit, sbBase, sbChannel, proposeBlind, sbAdmitDec, sbFallback]
    have ho : sbObsFn .base sbX0 = true := by
      unfold sbObsFn sbX0; exact CoreHelpers.natBlt_true_iff.mpr (by decide)
    rw [ho]
    rfl
  refine ⟨hStep, ?_⟩
  exact anchored_selfMod_viable sbBase sbInit_anchored sbAdmitDec sbFallback sbAdmit_sound proposeBlind
    sbRoute sbObsFn sbChannel G_sb (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0)
    (fun _ => 2) (fun _ => 1) 1 0
    (fun m () => by cases m <;> dsimp [sbRoute, sbBase] <;> decide)
    (fun m () => by cases m <;> dsimp [sbRoute, sbBase] <;> decide)
    (fun m => by dsimp [sbBase]; cases m <;> exact Nat.le_refl 1)
    (fun m => by dsimp [sbBase]; cases m <;> exact Nat.le_refl 0)
    sbXCrit sbWarnLevel (fun _ => 1) sbX0
    (fun m _ x _ _ hlt => by
      dsimp [sbBase, sbObsFn]
      cases m <;> exact CoreHelpers.natBlt_true_iff.mpr hlt)
    (fun load _ _ le => by show (true && Nat.ble load 0) = true; rw [Nat.ble_eq_true_of_le le]; rfl)
    G_sb_rises
    (fun () => by decide) (fun () => by decide) (fun () => by decide)
    (fun () => by dsimp [sbXCrit, sbBase, sbInit, sbX0]; decide)

def anchoredSelfModWidenComp : PolyComponent SBMode sbS sbObs sbDist sbInt sbExt :=
  anchoredSelfModComponent sbBase sbAdmitDec sbFallback proposeWiden

def anchoredSelfModWidenContract : PolyContract anchoredSelfModWidenComp sbInit :=
  anchoredSelfModContract sbBase sbInit_anchored sbAdmitDec sbFallback sbAdmit_sound proposeWiden

theorem sbModeRefines (m : SBMode) (s : sbS m) (hK : sbBase.K ⟨m, s⟩) :
    ModeRefines sbBase sbRoute sbObsFn sbWarnLevel .base m where
  pre_le x := by
    cases x; dsimp [sbRoute, sbBase]
    cases m <;> first | exact False.elim hK | exact Nat.le_refl 2
  post_le x := by
    cases x; dsimp [sbRoute, sbBase]
    cases m <;> first | exact False.elim hK | exact Nat.le_refl 1
  lag_le := by
    dsimp [sbBase]
    cases m <;> first | exact False.elim hK | exact Nat.le_refl 1
  silence_le := by
    dsimp [sbBase]
    cases m <;> first | exact False.elim hK | exact Nat.le_refl 0
  warn_widened x _ _ hw := by
    dsimp [sbBase, sbObsFn] at hw ⊢
    cases m <;> first | exact False.elim hK | exact hw

theorem anchored_admits_selfWiden :
    (polyClosedStep anchoredSelfModWidenComp sbRoute sbObsFn sbChannel G_sb
      (fun _ _ => 0) (sbX0, sbInit) ((), ())).2 = ⟨.selfWiden, 0⟩ ∧
    Viability.Kernel
      (polyClosedProcess anchoredSelfModWidenComp sbRoute anchoredSelfModWidenContract
        sbObsFn sbChannel G_sb (fun _ _ => 0) (fun _ => True))
      (polyClosedGuard anchoredSelfModWidenComp anchoredSelfModWidenContract sbXCrit)
      (sbX0, sbInit) := by
  have hStep : (polyClosedStep anchoredSelfModWidenComp sbRoute sbObsFn sbChannel G_sb
      (fun _ _ => 0) (sbX0, sbInit) ((), ())).2 = ⟨.selfWiden, 0⟩ := by
    dsimp [polyClosedStep, anchoredSelfModWidenComp, anchoredSelfModComponent,
      sbInit, sbBase, sbChannel, proposeWiden, sbAdmitDec, sbFallback]
    have ho : sbObsFn .base sbX0 = true := by
      unfold sbObsFn sbX0; exact CoreHelpers.natBlt_true_iff.mpr (by decide)
    rw [ho]
    rfl
  refine ⟨hStep, ?_⟩
  exact monotone_selfWidening_viable sbBase sbInit_anchored sbAdmitDec sbFallback sbAdmit_sound proposeWiden
    sbRoute sbObsFn sbChannel G_sb (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0)
    (fun _ => 2) (fun _ => 1) 1 0 sbXCrit sbWarnLevel (fun _ => 1) sbX0
    (fun () => by dsimp [sbRoute, sbBase]; decide)
    (fun () => by dsimp [sbRoute, sbBase]; decide)
    (by dsimp [sbBase, sbInit]; exact Nat.le_refl 1)
    (by dsimp [sbBase, sbInit]; exact Nat.le_refl 0)
    (fun x _ hlt => by dsimp [sbBase, sbObsFn]; exact CoreHelpers.natBlt_true_iff.mpr hlt)
    sbModeRefines
    (fun load _ _ le => by show (true && Nat.ble load 0) = true; rw [Nat.ble_eq_true_of_le le]; rfl)
    G_sb_rises
    (fun () => by decide) (fun () => by decide) (fun () => by decide)
    (fun () => by dsimp [sbXCrit, sbBase, sbInit, sbX0]; decide)

end SelfBlindingDichotomyWitness

/-! ## Part 3: Serialized Epoch- & Reserve-Guarded Concurrent Reconfiguration -/

/-- A reconfiguration proposal for one side of a composed system: a transaction request,
reserve/time parameters (`opened`, `amount`, `depth`, `candidate`), and target mode state. -/
structure PolyReconfigProposal (Mode : Type) (S : Mode → Type) where
  req : Transactions.Request
  opened : Bool
  amount : Nat
  depth : Nat
  candidate : Reconfiguration.Arrangement
  target : Σ m, S m

/-- Joint action of two concurrent adaptive components serialized over one `Reconfiguration.Managed`
installation: either a joint operational step (`stepBoth`) or a serialized side reconfiguration. -/
inductive SerialCoordAct
    (Mode₁ Mode₂ : Type) (Dist₁ : Mode₁ → Type) (Dist₂ : Mode₂ → Type)
    (S₁ : Mode₁ → Type) (S₂ : Mode₂ → Type) (Env : Type) where
  | stepBoth (env : Env) (d₁ : Σ m, Dist₁ m) (d₂ : Σ m, Dist₂ m)
  | reconfigA (prop : PolyReconfigProposal Mode₁ S₁)
  | reconfigB (prop : PolyReconfigProposal Mode₂ S₂)

/-- Combined state of a serialized concurrent reconfiguration system over substrate `Site → Nat`. -/
structure SerialCoordState
    (Mode₁ Mode₂ : Type) (S₁ : Mode₁ → Type) (S₂ : Mode₂ → Type) (Site : Type) where
  x : Site → Nat
  sA : Σ m, S₁ m
  sB : Σ m, S₂ m
  managed : Reconfiguration.Managed

/-- Single-side contract-compatibility check for a reconfiguration proposal: target inside `c.K`,
non-increasing countdown `eta`, and target routed pre-cap bounded by `sitePreCap site`. -/
def serialSideAdmit
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site : Type}
    {C : PolyComponent Mode S Obs Dist Int Ext} {init : Σ m, S m}
    (route : (m : Mode) → Site → List (Ext m))
    (c : PolyContract C init)
    (sitePreCap : Site → Nat)
    (prop : PolyReconfigProposal Mode S)
    (cur : Σ m, S m) : Prop :=
  c.K prop.target ∧
  c.eta prop.target ≤ c.eta cur ∧
  ∀ site, sumPortDraws (route prop.target.1 site) (c.preCapExt prop.target.1) ≤ sitePreCap site

/-- Serialized concurrent reconfiguration process: operational steps run both components on the
coupled substrate; each reconfiguration checks request freshness (`Transactions.fresh`), side
contract admission (`serialSideAdmit`), `Reconfiguration.reconfigure` reserve/time/readiness, and
joint `postLimit` allowance across both sides. -/
def SerialReconfigProcess
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {Site Env : Type}
    (A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁)
    (routeA : (m : Mode₁) → Site → List (Ext₁ m))
    {init₁ : Σ m, S₁ m} (cA : PolyContract A init₁)
    (B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂)
    (routeB : (m : Mode₂) → Site → List (Ext₂ m))
    {init₂ : Σ m, S₂ m} (cB : PolyContract B init₂)
    (sitePreCap₁ sitePreCap₂ postLimit : Site → Nat)
    (obs₁ : (m : Mode₁) → (Site → Nat) → Obs₁ m)
    (obs₂ : (m : Mode₂) → (Site → Nat) → Obs₂ m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat)
    (jointAdm : Env → Prop) :
    Process (SerialCoordState Mode₁ Mode₂ S₁ S₂ Site)
      (SerialCoordAct Mode₁ Mode₂ Dist₁ Dist₂ S₁ S₂ Env) where
  step st act st' := match act with
    | .stepBoth env d₁ d₂ =>
      ∃ (hm₁ : d₁.1 = st.sA.1) (hm₂ : d₂.1 = st.sB.1),
        jointAdm env ∧
        (∀ ob₁, cA.tol st.sA.1 ob₁ (hm₁ ▸ d₁.2)) ∧
        (∀ ob₂, cB.tol st.sB.1 ob₂ (hm₂ ▸ d₂.2)) ∧
        let o₁ := obs₁ st.sA.1 st.x
        let o₂ := obs₂ st.sB.1 st.x
        let al₁ := channel (A.emitAlarm st.sA.1 st.sA.2 o₁) (A.silenceLoad st.sA) env
        let al₂ := channel (B.emitAlarm st.sB.1 st.sB.2 o₂) (B.silenceLoad st.sB) env
        let H := fun site =>
          polySiteDraw A routeA st.sA site + polySiteDraw B routeB st.sB site + envDraw env site
        st' =
          ⟨RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H st.x,
           A.next st.sA (o₁, al₁) (hm₁ ▸ d₁.2),
           B.next st.sB (o₂, al₂) (hm₂ ▸ d₂.2),
           st.managed⟩
    | .reconfigA prop =>
      Transactions.fresh st.managed.installation prop.req = true ∧
      serialSideAdmit routeA cA sitePreCap₁ prop st.sA ∧
      ∃ managed',
        Reconfiguration.reconfigure prop.opened prop.amount prop.depth prop.candidate st.managed =
          some managed' ∧
        (∀ site,
          sumPortDraws (routeA prop.target.1 site) (cA.postAllowanceExt prop.target.1) +
          sumPortDraws (routeB st.sB.1 site) (cB.postAllowanceExt st.sB.1) ≤ postLimit site) ∧
        st' = ⟨st.x, prop.target, st.sB, managed'⟩
    | .reconfigB prop =>
      Transactions.fresh st.managed.installation prop.req = true ∧
      serialSideAdmit routeB cB sitePreCap₂ prop st.sB ∧
      ∃ managed',
        Reconfiguration.reconfigure prop.opened prop.amount prop.depth prop.candidate st.managed =
          some managed' ∧
        (∀ site,
          sumPortDraws (routeA st.sA.1 site) (cA.postAllowanceExt st.sA.1) +
          sumPortDraws (routeB prop.target.1 site) (cB.postAllowanceExt prop.target.1) ≤ postLimit site) ∧
        st' = ⟨st.x, st.sA, prop.target, managed'⟩

/-- Viability guard for `SerialReconfigProcess`. -/
def serialReconfigGuard
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {Site : Type}
    (A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁)
    (routeA : (m : Mode₁) → Site → List (Ext₁ m))
    {init₁ : Σ m, S₁ m} (cA : PolyContract A init₁)
    (B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂)
    (routeB : (m : Mode₂) → Site → List (Ext₂ m))
    {init₂ : Σ m, S₂ m} (cB : PolyContract B init₂)
    (postLimit x_crit : Site → Nat)
    (st : SerialCoordState Mode₁ Mode₂ S₁ S₂ Site) : Prop :=
  (∀ site, x_crit site ≤ st.x site) ∧
  (∀ j, A.drawInt st.sA j ≤ cA.preCapInt st.sA.1 j) ∧
  (∀ k, A.drawExt st.sA k ≤ cA.preCapExt st.sA.1 k) ∧
  A.silenceLoad st.sA ≤ cA.maxSilence st.sA.1 ∧
  (∀ j, B.drawInt st.sB j ≤ cB.preCapInt st.sB.1 j) ∧
  (∀ k, B.drawExt st.sB k ≤ cB.preCapExt st.sB.1 k) ∧
  B.silenceLoad st.sB ≤ cB.maxSilence st.sB.1 ∧
  (∀ site,
    sumPortDraws (routeA st.sA.1 site) (cA.postAllowanceExt st.sA.1) +
    sumPortDraws (routeB st.sB.1 site) (cB.postAllowanceExt st.sB.1) ≤ postLimit site)

/-- Inductive invariant for `SerialReconfigProcess`. -/
def serialReconfigInv
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {Site : Type}
    {A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁}
    (routeA : (m : Mode₁) → Site → List (Ext₁ m))
    {init₁ : Σ m, S₁ m} (cA : PolyContract A init₁)
    {B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂}
    (routeB : (m : Mode₂) → Site → List (Ext₂ m))
    {init₂ : Σ m, S₂ m} (cB : PolyContract B init₂)
    (sitePreCap₁ sitePreCap₂ envCap postLimit x_crit : Site → Nat)
    (st : SerialCoordState Mode₁ Mode₂ S₁ S₂ Site) : Prop :=
  cA.K st.sA ∧ cB.K st.sB ∧
  (∀ site, sumPortDraws (routeA st.sA.1 site) (cA.preCapExt st.sA.1) ≤ sitePreCap₁ site) ∧
  (∀ site, sumPortDraws (routeB st.sB.1 site) (cB.preCapExt st.sB.1) ≤ sitePreCap₂ site) ∧
  (∀ site,
    sumPortDraws (routeA st.sA.1 site) (cA.postAllowanceExt st.sA.1) +
    sumPortDraws (routeB st.sB.1 site) (cB.postAllowanceExt st.sB.1) ≤ postLimit site) ∧
  (∀ site,
    x_crit site +
      CoreHelpers.natMax (cA.eta st.sA) (cB.eta st.sB) *
        (sitePreCap₁ site + sitePreCap₂ site + envCap site) ≤ st.x site)

/-- Any committed `.reconfigA` or `.reconfigB` transition in `SerialReconfigProcess` advances the
managed epoch and makes any request carrying the previous epoch stale (`fresh = false`). -/
theorem serialReconfig_epoch_stale_on_step
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {Site Env : Type}
    {A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁}
    {routeA : (m : Mode₁) → Site → List (Ext₁ m)}
    {init₁ : Σ m, S₁ m} {cA : PolyContract A init₁}
    {B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂}
    {routeB : (m : Mode₂) → Site → List (Ext₂ m)}
    {init₂ : Σ m, S₂ m} {cB : PolyContract B init₂}
    {sitePreCap₁ sitePreCap₂ postLimit : Site → Nat}
    {obs₁ : (m : Mode₁) → (Site → Nat) → Obs₁ m}
    {obs₂ : (m : Mode₂) → (Site → Nat) → Obs₂ m}
    {channel : Bool → Nat → Env → Bool}
    {G : Site → (Site → Nat) → Nat}
    {envDraw : Env → Site → Nat} {jointAdm : Env → Prop}
    {st st' : SerialCoordState Mode₁ Mode₂ S₁ S₂ Site}
    {act : SerialCoordAct Mode₁ Mode₂ Dist₁ Dist₂ S₁ S₂ Env}
    (hreconf : (∃ p, act = .reconfigA p) ∨ (∃ p, act = .reconfigB p))
    (hstep : (SerialReconfigProcess A routeA cA B routeB cB sitePreCap₁ sitePreCap₂ postLimit
      obs₁ obs₂ channel G envDraw jointAdm).step st act st')
    (staleReq : Transactions.Request)
    (oldEpoch : staleReq.epoch = st.managed.installation.state.epoch) :
    Transactions.fresh st'.managed.installation staleReq = false := by
  cases hreconf with
  | inl hA =>
    obtain ⟨p, rfl⟩ := hA
    obtain ⟨_, _, m', hrec, _, rfl⟩ := hstep
    exact Reconfiguration.reconfigure_stales_epoch p.opened p.amount p.depth p.candidate
      st.managed m' hrec staleReq oldEpoch
  | inr hB =>
    obtain ⟨p, rfl⟩ := hB
    obtain ⟨_, _, m', hrec, _, rfl⟩ := hstep
    exact Reconfiguration.reconfigure_stales_epoch p.opened p.amount p.depth p.candidate
      st.managed m' hrec staleReq oldEpoch

/-- Certificate for `SerialReconfigProcess` under `serialReconfigInv`. -/
theorem serialReconfig_viable
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {Site Env : Type}
    (A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁)
    (routeA : (m : Mode₁) → Site → List (Ext₁ m))
    {init₁ : Σ m, S₁ m} (cA : PolyContract A init₁)
    (B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂)
    (routeB : (m : Mode₂) → Site → List (Ext₂ m))
    {init₂ : Σ m, S₂ m} (cB : PolyContract B init₂)
    (sitePreCap₁ sitePreCap₂ postLimit envCap : Site → Nat)
    (obs₁ : (m : Mode₁) → (Site → Nat) → Obs₁ m)
    (obs₂ : (m : Mode₂) → (Site → Nat) → Obs₂ m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (maxLag₁ maxLag₂ maxSilence₁ maxSilence₂ : Nat)
    (x_crit warnLevel H_safe : Site → Nat)
    (mode_lag₁ : ∀ m₁ s₁, cA.K ⟨m₁, s₁⟩ → cA.maxLag m₁ ≤ maxLag₁)
    (mode_lag₂ : ∀ m₂ s₂, cB.K ⟨m₂, s₂⟩ → cB.maxLag m₂ ≤ maxLag₂)
    (mode_silence₁ : ∀ m₁ s₁, cA.K ⟨m₁, s₁⟩ → cA.maxSilence m₁ ≤ maxSilence₁)
    (mode_silence₂ : ∀ m₂ s₂, cB.K ⟨m₂, s₂⟩ → cB.maxSilence m₂ ≤ maxSilence₂)
    (obs_detects₁ : ∀ m₁ s₁ x site, cA.K ⟨m₁, s₁⟩ →
      x site < warnLevel site → cA.warnObs m₁ (obs₁ m₁ x))
    (obs_detects₂ : ∀ m₂ s₂ x site, cB.K ⟨m₂, s₂⟩ →
      x site < warnLevel site → cB.warnObs m₂ (obs₂ m₂ x))
    (stepA_pre_mono : ∀ m₁ s₁ ob₁ d₁ site, cA.K ⟨m₁, s₁⟩ → (∀ o, cA.tol m₁ o d₁) →
      sumPortDraws (routeA (A.next ⟨m₁, s₁⟩ ob₁ d₁).1 site)
        (cA.preCapExt (A.next ⟨m₁, s₁⟩ ob₁ d₁).1) ≤
      sumPortDraws (routeA m₁ site) (cA.preCapExt m₁))
    (stepA_post_mono : ∀ m₁ s₁ ob₁ d₁ site, cA.K ⟨m₁, s₁⟩ → (∀ o, cA.tol m₁ o d₁) →
      sumPortDraws (routeA (A.next ⟨m₁, s₁⟩ ob₁ d₁).1 site)
        (cA.postAllowanceExt (A.next ⟨m₁, s₁⟩ ob₁ d₁).1) ≤
      sumPortDraws (routeA m₁ site) (cA.postAllowanceExt m₁))
    (stepB_pre_mono : ∀ m₂ s₂ ob₂ d₂ site, cB.K ⟨m₂, s₂⟩ → (∀ o, cB.tol m₂ o d₂) →
      sumPortDraws (routeB (B.next ⟨m₂, s₂⟩ ob₂ d₂).1 site)
        (cB.preCapExt (B.next ⟨m₂, s₂⟩ ob₂ d₂).1) ≤
      sumPortDraws (routeB m₂ site) (cB.preCapExt m₂))
    (stepB_post_mono : ∀ m₂ s₂ ob₂ d₂ site, cB.K ⟨m₂, s₂⟩ → (∀ o, cB.tol m₂ o d₂) →
      sumPortDraws (routeB (B.next ⟨m₂, s₂⟩ ob₂ d₂).1 site)
        (cB.postAllowanceExt (B.next ⟨m₂, s₂⟩ ob₂ d₂).1) ≤
      sumPortDraws (routeB m₂ site) (cB.postAllowanceExt m₂))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilence₁ + maxSilence₂ →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, postLimit site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site,
      x_crit site + (CoreHelpers.natMax maxLag₁ maxLag₂ + 1) *
        (sitePreCap₁ site + sitePreCap₂ site + envCap site) ≤ warnLevel site) :
    Viability.Certificate
      (SerialReconfigProcess A routeA cA B routeB cB sitePreCap₁ sitePreCap₂ postLimit
        obs₁ obs₂ channel G envDraw jointAdm)
      (serialReconfigGuard A routeA cA B routeB cB postLimit x_crit)
      (serialReconfigInv routeA cA routeB cB sitePreCap₁ sitePreCap₂ envCap postLimit x_crit) where
  within st inv := by
    obtain ⟨hKA, hKB, _, _, hPost, hMargin⟩ := inv
    have wA := cA.cert.within st.sA hKA
    have wB := cB.cert.within st.sB hKB
    exact ⟨fun site => Nat.le_trans (Nat.le_add_right _ _) (hMargin site),
      wA.1, wA.2.1, wA.2.2.1, wB.1, wB.2.1, wB.2.2.1, hPost⟩
  closed st act st' step inv := by
    obtain ⟨hKA, hKB, hPre₁, hPre₂, hPost, hMargin⟩ := inv
    cases act with
    | reconfigA prop =>
      obtain ⟨_, hAdmit, m', _, hPost', hEq⟩ := step
      subst hEq
      obtain ⟨hKT, hEtaT, hPreT⟩ := hAdmit
      refine ⟨hKT, hKB, hPreT, hPre₂, hPost', fun site => ?_⟩
      exact Nat.le_trans
        (Nat.add_le_add_left
          (Nat.mul_le_mul_right _
            (CoreHelpers.natMax_le
              (Nat.le_trans hEtaT (CoreHelpers.le_natMax_left _ _))
              (CoreHelpers.le_natMax_right _ _)))
          (x_crit site))
        (hMargin site)
    | reconfigB prop =>
      obtain ⟨_, hAdmit, m', _, hPost', hEq⟩ := step
      subst hEq
      obtain ⟨hKT, hEtaT, hPreT⟩ := hAdmit
      refine ⟨hKA, hKT, hPre₁, hPreT, hPost', fun site => ?_⟩
      exact Nat.le_trans
        (Nat.add_le_add_left
          (Nat.mul_le_mul_right _
            (CoreHelpers.natMax_le
              (CoreHelpers.le_natMax_left _ _)
              (Nat.le_trans hEtaT (CoreHelpers.le_natMax_right _ _))))
          (x_crit site))
        (hMargin site)
    | stepBoth env d₁ d₂ =>
      obtain ⟨hm₁, hm₂, hEnv, hTol₁, hTol₂, hEq⟩ := step
      cases st with | mk x sA sB managed =>
      cases sA with | mk m₁ s₁ =>
      cases sB with | mk m₂ s₂ =>
      cases d₁ with | mk dm₁ d₁' =>
      cases d₂ with | mk dm₂ d₂' =>
      change dm₁ = m₁ at hm₁
      change dm₂ = m₂ at hm₂
      cases hm₁
      cases hm₂
      subst hEq
      let o₁ := obs₁ m₁ x
      let o₂ := obs₂ m₂ x
      let al₁ := channel (A.emitAlarm m₁ s₁ o₁) (A.silenceLoad ⟨m₁, s₁⟩) env
      let al₂ := channel (B.emitAlarm m₂ s₂ o₂) (B.silenceLoad ⟨m₂, s₂⟩) env
      let H := fun site =>
        polySiteDraw A routeA ⟨m₁, s₁⟩ site + polySiteDraw B routeB ⟨m₂, s₂⟩ site + envDraw env site
      let sA' := A.next ⟨m₁, s₁⟩ (o₁, al₁) d₁'
      let sB' := B.next ⟨m₂, s₂⟩ (o₂, al₂) d₂'
      have hKA' : cA.K sA' :=
        cA.cert.closed ⟨m₁, s₁⟩ ⟨m₁, (o₁, al₁), d₁'⟩ sA' ⟨rfl, hTol₁ (o₁, al₁), rfl⟩ hKA
      have hKB' : cB.K sB' :=
        cB.cert.closed ⟨m₂, s₂⟩ ⟨m₂, (o₂, al₂), d₂'⟩ sB' ⟨rfl, hTol₂ (o₂, al₂), rfl⟩ hKB
      have hPre₁' : ∀ site, sumPortDraws (routeA sA'.1 site) (cA.preCapExt sA'.1) ≤ sitePreCap₁ site :=
        fun site => Nat.le_trans (stepA_pre_mono m₁ s₁ (o₁, al₁) d₁' site hKA hTol₁) (hPre₁ site)
      have hPre₂' : ∀ site, sumPortDraws (routeB sB'.1 site) (cB.preCapExt sB'.1) ≤ sitePreCap₂ site :=
        fun site => Nat.le_trans (stepB_pre_mono m₂ s₂ (o₂, al₂) d₂' site hKB hTol₂) (hPre₂ site)
      have hPost' : ∀ site,
          sumPortDraws (routeA sA'.1 site) (cA.postAllowanceExt sA'.1) +
          sumPortDraws (routeB sB'.1 site) (cB.postAllowanceExt sB'.1) ≤ postLimit site :=
        fun site =>
          Nat.le_trans
            (Nat.add_le_add
              (stepA_post_mono m₁ s₁ (o₁, al₁) d₁' site hKA hTol₁)
              (stepB_post_mono m₂ s₂ (o₂, al₂) d₂' site hKB hTol₂))
            (hPost site)
      have hMargin' : ∀ site,
          x_crit site + CoreHelpers.natMax (cA.eta sA') (cB.eta sB') *
            (sitePreCap₁ site + sitePreCap₂ site + envCap site) ≤
            RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x site := by
        intro site
        have wA := cA.cert.within ⟨m₁, s₁⟩ hKA
        have wB := cB.cert.within ⟨m₂, s₂⟩ hKB
        have H_le_pre : ∀ j, H j ≤ sitePreCap₁ j + sitePreCap₂ j + envCap j := fun j =>
          Nat.add_le_add
            (Nat.add_le_add
              (Nat.le_trans (sumPortDraws_le (fun k _ => wA.2.1 k)) (hPre₁ j))
              (Nat.le_trans (sumPortDraws_le (fun k _ => wB.2.1 k)) (hPre₂ j)))
            (env_within env hEnv j)
        have nextEta_le : CoreHelpers.natMax (cA.eta sA') (cB.eta sB') ≤
            CoreHelpers.natMax maxLag₁ maxLag₂ := by
          have lA : cA.eta sA' ≤ maxLag₁ := by
            cases hSA' : sA' with | mk m₁' s₁' =>
            exact Nat.le_trans (cA.eta_bound ⟨m₁', s₁'⟩ (hSA' ▸ hKA')) (mode_lag₁ m₁' s₁' (hSA' ▸ hKA'))
          have lB : cB.eta sB' ≤ maxLag₂ := by
            cases hSB' : sB' with | mk m₂' s₂' =>
            exact Nat.le_trans (cB.eta_bound ⟨m₂', s₂'⟩ (hSB' ▸ hKB')) (mode_lag₂ m₂' s₂' (hSB' ▸ hKB'))
          exact CoreHelpers.natMax_le
            (Nat.le_trans lA (CoreHelpers.le_natMax_left _ _))
            (Nat.le_trans lB (CoreHelpers.le_natMax_right _ _))
        refine OpenComposition.substrate_margin_step G_rises H_le_pre nextEta_le
          post_viable warn_margin hMargin site (fun hlt => ?_)
        have hal₁ : al₁ = true := by
          have hemA : A.emitAlarm m₁ s₁ o₁ = true :=
            cA.emits_on_warn m₁ s₁ o₁ hKA (obs_detects₁ m₁ s₁ x site hKA hlt)
          have hload₁ : A.silenceLoad ⟨m₁, s₁⟩ ≤ maxSilence₁ + maxSilence₂ :=
            Nat.le_trans (Nat.le_trans wA.2.2.1 (mode_silence₁ m₁ s₁ hKA)) (Nat.le_add_right _ _)
          change channel (A.emitAlarm m₁ s₁ o₁) (A.silenceLoad ⟨m₁, s₁⟩) env = true
          rw [hemA]
          exact channel_fires (A.silenceLoad ⟨m₁, s₁⟩) env hEnv hload₁
        have hal₂ : al₂ = true := by
          have hemB : B.emitAlarm m₂ s₂ o₂ = true :=
            cB.emits_on_warn m₂ s₂ o₂ hKB (obs_detects₂ m₂ s₂ x site hKB hlt)
          have hload₂ : B.silenceLoad ⟨m₂, s₂⟩ ≤ maxSilence₁ + maxSilence₂ :=
            Nat.le_trans (Nat.le_trans wB.2.2.1 (mode_silence₂ m₂ s₂ hKB)) (Nat.le_add_left _ _)
          change channel (B.emitAlarm m₂ s₂ o₂) (B.silenceLoad ⟨m₂, s₂⟩) env = true
          rw [hemB]
          exact channel_fires (B.silenceLoad ⟨m₂, s₂⟩) env hEnv hload₂
        refine ⟨fun hcur0 => ?_, fun hcurPos => ?_⟩
        · have hA0 : cA.eta ⟨m₁, s₁⟩ = 0 :=
            Nat.eq_zero_of_le_zero (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (Nat.le_of_eq hcur0))
          have hB0 : cB.eta ⟨m₂, s₂⟩ = 0 :=
            Nat.eq_zero_of_le_zero (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (Nat.le_of_eq hcur0))
          have hnextA0 : cA.eta sA' = 0 := by
            show cA.eta (A.next ⟨m₁, s₁⟩ (o₁, al₁) d₁') = 0
            rw [hal₁]
            exact cA.eta_alarm_zero m₁ s₁ o₁ d₁' (hTol₁ (o₁, true)) hKA hA0
          have hnextB0 : cB.eta sB' = 0 := by
            show cB.eta (B.next ⟨m₂, s₂⟩ (o₂, al₂) d₂') = 0
            rw [hal₂]
            exact cB.eta_alarm_zero m₂ s₂ o₂ d₂' (hTol₂ (o₂, true)) hKB hB0
          refine ⟨by show CoreHelpers.natMax (cA.eta sA') (cB.eta sB') = 0; rw [hnextA0, hnextB0]; rfl, ?_⟩
          intro j
          have pA := (wA.2.2.2 hA0).2.2
          have pB := (wB.2.2.2 hB0).2.2
          exact Nat.le_trans
            (Nat.add_le_add
              (Nat.add_le_add (sumPortDraws_le (fun k _ => pA k)) (sumPortDraws_le (fun k _ => pB k)))
              (env_within env hEnv j))
            (Nat.le_trans (Nat.add_le_add_right (hPost j) (envCap j)) (post_allowance j))
        · have stepA_lt : cA.eta sA' < CoreHelpers.natMax (cA.eta ⟨m₁, s₁⟩) (cB.eta ⟨m₂, s₂⟩) := by
            cases Nat.eq_zero_or_pos (cA.eta ⟨m₁, s₁⟩) with
            | inl hEA =>
              have zA : cA.eta sA' = 0 := by
                show cA.eta (A.next ⟨m₁, s₁⟩ (o₁, al₁) d₁') = 0
                rw [hal₁]
                exact cA.eta_alarm_zero m₁ s₁ o₁ d₁' (hTol₁ (o₁, true)) hKA hEA
              rw [zA]; exact hcurPos
            | inr hposA =>
              have ltA : cA.eta sA' < cA.eta ⟨m₁, s₁⟩ := by
                show cA.eta (A.next ⟨m₁, s₁⟩ (o₁, al₁) d₁') < cA.eta ⟨m₁, s₁⟩
                rw [hal₁]
                exact cA.eta_alarm_step m₁ s₁ o₁ d₁' (hTol₁ (o₁, true)) hKA hposA
              exact Nat.lt_of_lt_of_le ltA (CoreHelpers.le_natMax_left _ _)
          have stepB_lt : cB.eta sB' < CoreHelpers.natMax (cA.eta ⟨m₁, s₁⟩) (cB.eta ⟨m₂, s₂⟩) := by
            cases Nat.eq_zero_or_pos (cB.eta ⟨m₂, s₂⟩) with
            | inl hEB =>
              have zB : cB.eta sB' = 0 := by
                show cB.eta (B.next ⟨m₂, s₂⟩ (o₂, al₂) d₂') = 0
                rw [hal₂]
                exact cB.eta_alarm_zero m₂ s₂ o₂ d₂' (hTol₂ (o₂, true)) hKB hEB
              rw [zB]; exact hcurPos
            | inr hposB =>
              have ltB : cB.eta sB' < cB.eta ⟨m₂, s₂⟩ := by
                show cB.eta (B.next ⟨m₂, s₂⟩ (o₂, al₂) d₂') < cB.eta ⟨m₂, s₂⟩
                rw [hal₂]
                exact cB.eta_alarm_step m₂ s₂ o₂ d₂' (hTol₂ (o₂, true)) hKB hposB
              exact Nat.lt_of_lt_of_le ltB (CoreHelpers.le_natMax_right _ _)
          show CoreHelpers.natMax (cA.eta sA') (cB.eta sB') + 1 ≤
            CoreHelpers.natMax (cA.eta ⟨m₁, s₁⟩) (cB.eta ⟨m₂, s₂⟩)
          cases Nat.decLe (cA.eta sA') (cB.eta sB') with
          | isTrue le =>
            rw [show CoreHelpers.natMax (cA.eta sA') (cB.eta sB') = cB.eta sB' from if_pos le]
            exact stepB_lt
          | isFalse notLe =>
            rw [show CoreHelpers.natMax (cA.eta sA') (cB.eta sB') = cA.eta sA' from if_neg notLe]
            exact stepA_lt
      exact ⟨hKA', hKB', hPre₁', hPre₂', hPost', hMargin'⟩

/-- Kernel wrapper for `serialReconfig_viable` from an initial state inside `serialReconfigInv`. -/
theorem serialReconfig_kernel
    {Mode₁ Mode₂ : Type}
    {S₁ Obs₁ Dist₁ Int₁ Ext₁ : Mode₁ → Type}
    {S₂ Obs₂ Dist₂ Int₂ Ext₂ : Mode₂ → Type}
    {Site Env : Type}
    (A : PolyComponent Mode₁ S₁ Obs₁ Dist₁ Int₁ Ext₁)
    (routeA : (m : Mode₁) → Site → List (Ext₁ m))
    {init₁ : Σ m, S₁ m} (cA : PolyContract A init₁)
    (B : PolyComponent Mode₂ S₂ Obs₂ Dist₂ Int₂ Ext₂)
    (routeB : (m : Mode₂) → Site → List (Ext₂ m))
    {init₂ : Σ m, S₂ m} (cB : PolyContract B init₂)
    (sitePreCap₁ sitePreCap₂ postLimit envCap : Site → Nat)
    (obs₁ : (m : Mode₁) → (Site → Nat) → Obs₁ m)
    (obs₂ : (m : Mode₂) → (Site → Nat) → Obs₂ m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (maxLag₁ maxLag₂ maxSilence₁ maxSilence₂ : Nat)
    (x_crit warnLevel H_safe : Site → Nat)
    (mode_lag₁ : ∀ m₁ s₁, cA.K ⟨m₁, s₁⟩ → cA.maxLag m₁ ≤ maxLag₁)
    (mode_lag₂ : ∀ m₂ s₂, cB.K ⟨m₂, s₂⟩ → cB.maxLag m₂ ≤ maxLag₂)
    (mode_silence₁ : ∀ m₁ s₁, cA.K ⟨m₁, s₁⟩ → cA.maxSilence m₁ ≤ maxSilence₁)
    (mode_silence₂ : ∀ m₂ s₂, cB.K ⟨m₂, s₂⟩ → cB.maxSilence m₂ ≤ maxSilence₂)
    (obs_detects₁ : ∀ m₁ s₁ x site, cA.K ⟨m₁, s₁⟩ →
      x site < warnLevel site → cA.warnObs m₁ (obs₁ m₁ x))
    (obs_detects₂ : ∀ m₂ s₂ x site, cB.K ⟨m₂, s₂⟩ →
      x site < warnLevel site → cB.warnObs m₂ (obs₂ m₂ x))
    (stepA_pre_mono : ∀ m₁ s₁ ob₁ d₁ site, cA.K ⟨m₁, s₁⟩ → (∀ o, cA.tol m₁ o d₁) →
      sumPortDraws (routeA (A.next ⟨m₁, s₁⟩ ob₁ d₁).1 site)
        (cA.preCapExt (A.next ⟨m₁, s₁⟩ ob₁ d₁).1) ≤
      sumPortDraws (routeA m₁ site) (cA.preCapExt m₁))
    (stepA_post_mono : ∀ m₁ s₁ ob₁ d₁ site, cA.K ⟨m₁, s₁⟩ → (∀ o, cA.tol m₁ o d₁) →
      sumPortDraws (routeA (A.next ⟨m₁, s₁⟩ ob₁ d₁).1 site)
        (cA.postAllowanceExt (A.next ⟨m₁, s₁⟩ ob₁ d₁).1) ≤
      sumPortDraws (routeA m₁ site) (cA.postAllowanceExt m₁))
    (stepB_pre_mono : ∀ m₂ s₂ ob₂ d₂ site, cB.K ⟨m₂, s₂⟩ → (∀ o, cB.tol m₂ o d₂) →
      sumPortDraws (routeB (B.next ⟨m₂, s₂⟩ ob₂ d₂).1 site)
        (cB.preCapExt (B.next ⟨m₂, s₂⟩ ob₂ d₂).1) ≤
      sumPortDraws (routeB m₂ site) (cB.preCapExt m₂))
    (stepB_post_mono : ∀ m₂ s₂ ob₂ d₂ site, cB.K ⟨m₂, s₂⟩ → (∀ o, cB.tol m₂ o d₂) →
      sumPortDraws (routeB (B.next ⟨m₂, s₂⟩ ob₂ d₂).1 site)
        (cB.postAllowanceExt (B.next ⟨m₂, s₂⟩ ob₂ d₂).1) ≤
      sumPortDraws (routeB m₂ site) (cB.postAllowanceExt m₂))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilence₁ + maxSilence₂ →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, postLimit site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site,
      x_crit site + (CoreHelpers.natMax maxLag₁ maxLag₂ + 1) *
        (sitePreCap₁ site + sitePreCap₂ site + envCap site) ≤ warnLevel site)
    (st₀ : SerialCoordState Mode₁ Mode₂ S₁ S₂ Site)
    (init_inv : serialReconfigInv routeA cA routeB cB sitePreCap₁ sitePreCap₂ envCap postLimit x_crit st₀) :
    Viability.Kernel
      (SerialReconfigProcess A routeA cA B routeB cB sitePreCap₁ sitePreCap₂ postLimit
        obs₁ obs₂ channel G envDraw jointAdm)
      (serialReconfigGuard A routeA cA B routeB cB postLimit x_crit)
      st₀ :=
  (serialReconfig_viable A routeA cA B routeB cB sitePreCap₁ sitePreCap₂ postLimit envCap
    obs₁ obs₂ channel G envDraw jointAdm env_within
    maxLag₁ maxLag₂ maxSilence₁ maxSilence₂ x_crit warnLevel H_safe
    mode_lag₁ mode_lag₂ mode_silence₁ mode_silence₂ obs_detects₁ obs_detects₂
    stepA_pre_mono stepA_post_mono stepB_pre_mono stepB_post_mono
    channel_fires G_rises post_viable post_allowance warn_margin).kernel init_inv

/-! ### Witness 3: `ConcurrentSerialWitness` (Dual to `CE05b`) -/

namespace ConcurrentSerialWitness

inductive SideMode where
  | standby | active
  deriving DecidableEq

abbrev sideS : SideMode → Type | _ => Unit
abbrev sideObs : SideMode → Type | _ => Bool
abbrev sideDist : SideMode → Type | _ => Unit
abbrev sideInt : SideMode → Type | _ => Empty
abbrev sideExt : SideMode → Type | _ => Unit

def sideRoute : (m : SideMode) → Unit → List (sideExt m)
  | _, () => [()]

def sideComp : PolyComponent SideMode sideS sideObs sideDist sideInt sideExt where
  next p _ _ := p
  drawInt _ e := Empty.elim e
  drawExt p _ := match p.1 with | .standby => 0 | .active => 1
  emitAlarm _ _ o := o
  silenceLoad _ := 0
  favours _ := False

def sideContract (init : Σ m : SideMode, sideS m) : PolyContract sideComp init where
  tol _ _ _ := True
  warnObs _ o := o = true
  preCapInt _ e := Empty.elim e
  preCapExt m _ := match m with | .standby => 0 | .active => 1
  postAllowanceInt _ e := Empty.elim e
  postAllowanceExt m _ := match m with | .standby => 0 | .active => 1
  maxSilence _ := 0
  maxLag _ := 0
  K _ := True
  eta _ := 0
  init_in := trivial
  cert :=
    ⟨fun p _ => by
      cases p with | mk m s =>
      cases m <;> refine ⟨fun e => Empty.elim e, fun _ => Nat.le_refl _, Nat.le_refl 0,
        fun _ => ⟨False.elim, fun e => Empty.elim e, fun _ => Nat.le_refl _⟩⟩,
     fun _ _ _ _ _ => trivial⟩
  eta_bound p _ := by cases p.1 <;> exact Nat.le_refl 0
  emits_on_warn _ _ _ _ hw := hw
  eta_alarm_step _ _ _ _ _ _ hpos := absurd hpos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ _ := rfl

def gSub (_ : Unit) (e : Unit → Nat) : Nat := if 2 ≤ e () then 1 else 0

theorem gSub_rises :
    ∀ k : Unit, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (gSub k) :=
  fun _ e₁ _ below =>
    match Nat.decLe 2 (e₁ ()) with
    | isTrue h =>
      Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below ()))).symm)
    | isFalse h =>
      Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

def x_crit : Unit → Nat := fun _ => 3
def x₀ : Unit → Nat := fun _ => 4
def H_avail : Unit → Nat := fun _ => 1
def sitePreCap₁ : Unit → Nat := fun _ => 1
def sitePreCap₂ : Unit → Nat := fun _ => 1
def warnLevel : Unit → Nat := fun _ => 5

def w₀ : Reconfiguration.Managed :=
  ⟨Reconfiguration.separate3,
   { Transactions.initial with state := { Transactions.initial.state with reserve := 12 } }⟩

def slack : Nat := 11
def candidate : Reconfiguration.Arrangement := Reconfiguration.repaired4

theorem candidate_load_eq : Reconfiguration.responseLoad candidate 0 = slack := rfl

def reqA : PolyReconfigProposal SideMode sideS :=
  ⟨Transactions.request, true, 1, 0, candidate, ⟨.active, ()⟩⟩

def reqB : PolyReconfigProposal SideMode sideS :=
  ⟨Transactions.request, true, 1, 0, candidate, ⟨.active, ()⟩⟩

def w₁ : Reconfiguration.Managed :=
  ⟨candidate, Reconfiguration.renewedBy 1 w₀⟩

theorem w₀_reconfig_eq :
    Reconfiguration.reconfigure reqA.opened reqA.amount reqA.depth reqA.candidate w₀ = some w₁ := by
  have hadm : Reconfiguration.admits reqA.opened reqA.amount reqA.depth reqA.candidate w₀ = true :=
    Reconfiguration.admits_true_iff.mpr
      ⟨rfl, Reconfiguration.readiness_cases.2.2.1, by decide, by decide⟩
  unfold Reconfiguration.reconfigure
  rw [hadm]
  rfl

def reqB' : PolyReconfigProposal SideMode sideS :=
  ⟨{ reqB.req with epoch := w₁.installation.state.epoch, serial := w₁.installation.serial },
   reqB.opened, reqB.amount, reqB.depth, reqB.candidate, reqB.target⟩

def st₀ : SerialCoordState SideMode SideMode sideS sideS Unit :=
  ⟨x₀, ⟨.standby, ()⟩, ⟨.standby, ()⟩, w₀⟩

def stA : SerialCoordState SideMode SideMode sideS sideS Unit :=
  ⟨x₀, ⟨.active, ()⟩, ⟨.standby, ()⟩, w₁⟩

def stB : SerialCoordState SideMode SideMode sideS sideS Unit :=
  ⟨x₀, ⟨.standby, ()⟩, ⟨.active, ()⟩, w₁⟩

def csObs : (m : SideMode) → (Unit → Nat) → sideObs m
  | _, x => Nat.blt (x ()) 5

def csChannel (em : Bool) (_ : Nat) (_ : Unit) : Bool := em

def csProc :=
  SerialReconfigProcess sideComp sideRoute (sideContract ⟨.standby, ()⟩)
    sideComp sideRoute (sideContract ⟨.standby, ()⟩)
    sitePreCap₁ sitePreCap₂ H_avail csObs csObs csChannel gSub (fun _ _ => 0) (fun _ => True)

def csGuard :=
  serialReconfigGuard sideComp sideRoute (sideContract ⟨.standby, ()⟩)
    sideComp sideRoute (sideContract ⟨.standby, ()⟩) H_avail x_crit

theorem csKernel_of_inv (st : SerialCoordState SideMode SideMode sideS sideS Unit)
    (hinv : serialReconfigInv sideRoute (sideContract ⟨.standby, ()⟩)
      sideRoute (sideContract ⟨.standby, ()⟩) sitePreCap₁ sitePreCap₂ (fun _ => 0)
      H_avail x_crit st) :
    Viability.Kernel csProc csGuard st :=
  serialReconfig_kernel sideComp sideRoute (sideContract ⟨.standby, ()⟩)
    sideComp sideRoute (sideContract ⟨.standby, ()⟩)
    sitePreCap₁ sitePreCap₂ H_avail (fun _ => 0)
    csObs csObs csChannel gSub (fun _ _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0) 0 0 0 0 x_crit warnLevel H_avail
    (fun m _ _ => by cases m <;> exact Nat.le_refl 0)
    (fun m _ _ => by cases m <;> exact Nat.le_refl 0)
    (fun m _ _ => by cases m <;> exact Nat.le_refl 0)
    (fun m _ _ => by cases m <;> exact Nat.le_refl 0)
    (fun m _ x _ _ hlt => by dsimp [sideContract, csObs]; exact CoreHelpers.natBlt_true_iff.mpr hlt)
    (fun m _ x _ _ hlt => by dsimp [sideContract, csObs]; exact CoreHelpers.natBlt_true_iff.mpr hlt)
    (fun _ _ _ _ _ _ _ => Nat.le_refl _)
    (fun _ _ _ _ _ _ _ => Nat.le_refl _)
    (fun _ _ _ _ _ _ _ => Nat.le_refl _)
    (fun _ _ _ _ _ _ _ => Nat.le_refl _)
    (fun _ _ _ _ => rfl)
    gSub_rises (fun () => by decide) (fun () => by decide) (fun () => by decide)
    st hinv

/-- Unguarded concurrent composition after both `(reqA, reqB)` install `.active` simultaneously. -/
def concurrentUnguardedProcess :
    Process ((Unit → Nat) × (Σ m, sideS m) × (Σ m, sideS m)) Unit where
  step st _ st' :=
    let H := fun site =>
      polySiteDraw sideComp sideRoute st.2.1 site + polySiteDraw sideComp sideRoute st.2.2 site
    st' = ⟨RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole gSub H st.1,
           st.2.1, st.2.2⟩

def concurrentOrbit : Nat → (Unit → Nat) × (Σ m, sideS m) × (Σ m, sideS m)
  | 0 => (x₀, ⟨.active, ()⟩, ⟨.active, ()⟩)
  | t + 1 =>
    let st := concurrentOrbit t
    let H := fun site =>
      polySiteDraw sideComp sideRoute st.2.1 site + polySiteDraw sideComp sideRoute st.2.2 site
    ⟨RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole gSub H st.1,
     st.2.1, st.2.2⟩

theorem concurrent_serial_dichotomy :
    -- 1. Solo reqA viable
    (csProc.step st₀ (.reconfigA reqA) stA ∧ Viability.Kernel csProc csGuard stA) ∧
    -- 2. Solo reqB viable
    (csProc.step st₀ (.reconfigB reqB) stB ∧ Viability.Kernel csProc csGuard stB) ∧
    -- 3. Unguarded concurrent (reqA, reqB) crashes 4 -> 3 -> 1 -> 0 at step 3
    ((concurrentOrbit 0).1 () = 4 ∧ (concurrentOrbit 1).1 () = 3 ∧
     (concurrentOrbit 2).1 () = 1 ∧ (concurrentOrbit 3).1 () = 0 ∧
     ¬ Viability.Kernel concurrentUnguardedProcess (fun st => 3 ≤ st.1 ()) (concurrentOrbit 0)) ∧
    -- 4. Under SerialReconfigProcess after reqA commits w1: old reqB is stale, re-stamped reqB'
    --    exhausts reserve (reconfigure = none), and Kernel holds forever
    (Transactions.fresh w₁.installation reqB.req = false ∧
     Reconfiguration.reconfigure reqB'.opened reqB'.amount reqB'.depth reqB'.candidate w₁ = none ∧
     (∀ st', ¬ csProc.step stA (.reconfigB reqB') st') ∧
     Viability.Kernel csProc csGuard st₀) := by
  have hStepA : csProc.step st₀ (.reconfigA reqA) stA :=
    ⟨rfl, ⟨trivial, Nat.le_refl 0, fun () => Nat.le_refl 1⟩,
     w₁, w₀_reconfig_eq, fun () => Nat.le_refl 1, rfl⟩
  have hStepB : csProc.step st₀ (.reconfigB reqB) stB :=
    ⟨rfl, ⟨trivial, Nat.le_refl 0, fun () => Nat.le_refl 1⟩,
     w₁, w₀_reconfig_eq, fun () => Nat.le_refl 1, rfl⟩
  have hKernA : Viability.Kernel csProc csGuard stA :=
    csKernel_of_inv stA ⟨trivial, trivial,
      fun () => by dsimp [stA, sideRoute, sideContract, sitePreCap₁]; decide,
      fun () => by dsimp [stA, sideRoute, sideContract, sitePreCap₂]; decide,
      fun () => by dsimp [stA, sideRoute, sideContract, H_avail]; decide,
      fun () => by dsimp [stA, sideContract, x_crit, sitePreCap₁, sitePreCap₂, x₀]; decide⟩
  have hKernB : Viability.Kernel csProc csGuard stB :=
    csKernel_of_inv stB ⟨trivial, trivial,
      fun () => by dsimp [stB, sideRoute, sideContract, sitePreCap₁]; decide,
      fun () => by dsimp [stB, sideRoute, sideContract, sitePreCap₂]; decide,
      fun () => by dsimp [stB, sideRoute, sideContract, H_avail]; decide,
      fun () => by dsimp [stB, sideContract, x_crit, sitePreCap₁, sitePreCap₂, x₀]; decide⟩
  have hKern0 : Viability.Kernel csProc csGuard st₀ :=
    csKernel_of_inv st₀ ⟨trivial, trivial,
      fun () => by dsimp [st₀, sideRoute, sideContract, sitePreCap₁]; decide,
      fun () => by dsimp [st₀, sideRoute, sideContract, sitePreCap₂]; decide,
      fun () => by dsimp [st₀, sideRoute, sideContract, H_avail]; decide,
      fun () => by dsimp [st₀, sideContract, x_crit, sitePreCap₁, sitePreCap₂, x₀]; decide⟩
  have hCrash : ¬ Viability.Kernel concurrentUnguardedProcess (fun st => 3 ≤ st.1 ())
      (concurrentOrbit 0) := by
    intro hKern
    have htr : Trace concurrentUnguardedProcess (concurrentOrbit 0) [(), (), ()]
        (concurrentOrbit 3) :=
      .cons rfl (.cons rfl (.cons rfl (.nil _)))
    have hge := hKern (concurrentOrbit 3) ⟨[(), (), ()], htr⟩
    have hz : (concurrentOrbit 3).1 () = 0 := rfl
    dsimp at hge
    rw [hz] at hge
    exact absurd hge (by decide)
  have hStale : Transactions.fresh w₁.installation reqB.req = false :=
    Reconfiguration.reconfigure_stales_epoch reqA.opened reqA.amount reqA.depth reqA.candidate
      w₀ w₁ w₀_reconfig_eq reqB.req rfl
  have hFailRes :
      Reconfiguration.reconfigure reqB'.opened reqB'.amount reqB'.depth reqB'.candidate w₁ = none := by
    unfold Reconfiguration.reconfigure
    cases hadm : Reconfiguration.admits reqB'.opened reqB'.amount reqB'.depth reqB'.candidate w₁ with
    | false => rfl
    | true =>
      exact False.elim (absurd (Reconfiguration.admits_true_iff.mp hadm).2.2.1 (by decide))
  have hBlocked : ∀ st', ¬ csProc.step stA (.reconfigB reqB') st' := by
    intro st' ⟨_, _, m', hrec, _, _⟩
    change Reconfiguration.reconfigure reqB'.opened reqB'.amount reqB'.depth reqB'.candidate w₁ =
      some m' at hrec
    rw [hFailRes] at hrec
    cases hrec
  exact ⟨⟨hStepA, hKernA⟩, ⟨hStepB, hKernB⟩, ⟨rfl, rfl, rfl, rfl, hCrash⟩,
    ⟨hStale, hFailRes, hBlocked, hKern0⟩⟩

end ConcurrentSerialWitness

/-! ## Part 4: Coupled-Substrate Compositional `LaxSim` & Small-Gain Theorem -/

/-- Open component lifted to a port-level process receiving `(x, alarm, dist)` at every step. -/
def OpenPortProcess {S Obs Dist Int Ext : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext)
    (tol : Obs × Bool → Dist → Prop)
    (obs : (Ext → Nat) → Obs) :
    Process S ((Ext → Nat) × Bool × Dist) where
  step s a s' := tol (obs a.1, a.2.1) a.2.2 ∧ s' = C.next s (obs a.1, a.2.1) a.2.2

/-- Substrate lifted to a port-level process receiving `(drawTotal, env)` at every step. -/
def SubstratePortProcess {Ext Env : Type}
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop) :
    Process (Ext → Nat) ((Ext → Nat) × Env) where
  step x a x' :=
    jointAdm a.2 ∧
    x' = RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G
      (fun k => a.1 k + envDraw a.2 k) x

/-- Macro coupled process pairing substrate abstraction `RX` with two component abstractions
`RA`, `RB` via macro boundary draw projections `drawQA`, `drawQB`. -/
def coupledMacroProcess {Ext QX QA QB BX BA BB : Type}
    (RX : Process QX ((Ext → Nat) × BX))
    (RA : Process QA (QX × BA))
    (RB : Process QB (QX × BB))
    (drawQA : QA → Ext → Nat)
    (drawQB : QB → Ext → Nat) :
    Process (QX × (QA × QB)) (BX × (BA × BB)) where
  step q b q' :=
    RX.step q.1 (fun k => drawQA q.2.1 k + drawQB q.2.2 k, b.1) q'.1 ∧
    RA.step q.2.1 (q.1, b.2.1) q'.2.1 ∧
    RB.step q.2.2 (q.1, b.2.2) q'.2.2

/-- Substrate-side lax simulation from `SubstratePortProcess` to `RX` using combined monotone
`gain : Nat → Nat → Nat` plus slack `ε`. -/
structure SubstrateLaxSim {Ext Env QX BX : Type}
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop)
    (RX : Process QX ((Ext → Nat) × BX))
    (πX : (Ext → Nat) → QX)
    (σ : Nat → Nat)
    (MX : SlackDist QX) where
  EpochX : Nat → (Ext → Nat) → Prop
  EpochQX : Nat → QX → Prop
  epoch_step : ∀ t x a x', EpochX t x →
    (SubstratePortProcess G envDraw jointAdm).step x a x' → EpochX (t + 1) x'
  epoch_proj : ∀ k x, EpochX (σ k) x → EpochQX k (πX x)
  gain : Nat → Nat → Nat
  gain_mono : ∀ {rX₁ rX₂ rH₁ rH₂}, rX₁ ≤ rX₂ → rH₁ ≤ rH₂ → gain rX₁ rH₁ ≤ gain rX₂ rH₂
  ε : Nat
  β : Nat → Nat → Nat
  β_mono : ∀ {rX₁ rX₂ rH₁ rH₂}, rX₁ ≤ rX₂ → rH₁ ≤ rH₂ → β rX₁ rH₁ ≤ β rX₂ rH₂
  β_ge_left : ∀ rX rH, rX ≤ β rX rH
  η : Nat
  sim_block : ∀ k x qX (hQ : Ext → Nat) rX rH wX x',
    EpochX (σ k) x → EpochQX k qX → MX.d (πX x) qX ≤ rX →
    (∀ a, a ∈ wX → ∀ j, distNat (a.1 j) (hQ j) ≤ rH) →
    wX.length = σ (k + 1) - σ k →
    Trace (SubstratePortProcess G envDraw jointAdm) x wX x' →
    ∃ bX qX', RX.step qX (hQ, bX) qX' ∧ EpochQX (k + 1) qX' ∧ MX.d (πX x') qX' ≤ gain rX rH + ε
  step_excursion : ∀ k x qX (hQ : Ext → Nat) rX rH t h env x',
    EpochX t x → EpochQX k qX → MX.d (πX x) qX ≤ rX →
    (∀ j, distNat (h j) (hQ j) ≤ rH) →
    (SubstratePortProcess G envDraw jointAdm).step x (h, env) x' →
    MX.d (πX x') qX ≤ β rX rH + η

/-- Open-component lax simulation taking shared `EpochX` and `EpochQX` directly (so no side
compatibility hooks are needed), using combined monotone `gain : Nat → Nat → Nat` plus `ε`. -/
structure OpenSubLaxSim {S Obs Dist Int Ext QX QA BA : Type}
    (C : OpenComposition.OpenComponent S Obs Dist Int Ext)
    (tol : Obs × Bool → Dist → Prop)
    (obs : (Ext → Nat) → Obs)
    (RA : Process QA (QX × BA))
    (πA : S → QA)
    (drawQA : QA → Ext → Nat)
    (σ : Nat → Nat)
    (MA : SlackDist QA)
    (MX : SlackDist QX)
    (πX : (Ext → Nat) → QX)
    (EpochX : Nat → (Ext → Nat) → Prop)
    (EpochQX : Nat → QX → Prop) where
  Epoch : Nat → S → Prop
  EpochQ : Nat → QA → Prop
  epoch_step : ∀ t s a s', Epoch t s → EpochX t a.1 →
    (OpenPortProcess C tol obs).step s a s' → Epoch (t + 1) s'
  epoch_proj : ∀ k s, Epoch (σ k) s → EpochQ k (πA s)
  gain : Nat → Nat → Nat
  gain_mono : ∀ {r₁ r₂ rX₁ rX₂}, r₁ ≤ r₂ → rX₁ ≤ rX₂ → gain r₁ rX₁ ≤ gain r₂ rX₂
  ε : Nat
  β : Nat → Nat → Nat
  β_mono : ∀ {r₁ r₂ rX₁ rX₂}, r₁ ≤ r₂ → rX₁ ≤ rX₂ → β r₁ rX₁ ≤ β r₂ rX₂
  β_ge_left : ∀ r rX, r ≤ β r rX
  η : Nat
  drawMod : Nat → Nat
  drawMod_mono : ∀ {r₁ r₂}, r₁ ≤ r₂ → drawMod r₁ ≤ drawMod r₂
  draw_lip : ∀ t s q r k, Epoch t s → MA.d (πA s) q ≤ r →
    distNat (C.drawExt s k) (drawQA q k) ≤ drawMod r
  sim_block : ∀ k s q qX r rX w s',
    Epoch (σ k) s → EpochQ k q → EpochQX k qX → MA.d (πA s) q ≤ r →
    (∀ a, a ∈ w → (∃ t, EpochX t a.1) ∧ MX.d (πX a.1) qX ≤ rX) →
    w.length = σ (k + 1) - σ k →
    Trace (OpenPortProcess C tol obs) s w s' →
    ∃ b q', RA.step q (qX, b) q' ∧ EpochQ (k + 1) q' ∧ MA.d (πA s') q' ≤ gain r rX + ε
  step_excursion : ∀ k s q qX r rX t xSub al d s',
    Epoch t s → EpochX t xSub → EpochQ k q → EpochQX k qX →
    MA.d (πA s) q ≤ r → MX.d (πX xSub) qX ≤ rX →
    (OpenPortProcess C tol obs).step s (xSub, al, d) s' →
    MA.d (πA s') q ≤ β r rX + η

/-- Single micro-step excursion amplification across substrate and both components. -/
def jointOneStepGain
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    (r : Nat) : Nat :=
  CoreHelpers.natMax
    (simX.β r (simA.drawMod r + simB.drawMod r) + simX.η)
    (CoreHelpers.natMax (simA.β r r + simA.η) (simB.β r r + simB.η))

theorem jointOneStepGain_mono
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    {r₁ r₂ : Nat} (le : r₁ ≤ r₂) :
    jointOneStepGain simX simA simB r₁ ≤ jointOneStepGain simX simA simB r₂ :=
  CoreHelpers.natMax_le
    (Nat.le_trans
      (Nat.add_le_add_right
        (simX.β_mono le (Nat.add_le_add (simA.drawMod_mono le) (simB.drawMod_mono le)))
        simX.η)
      (CoreHelpers.le_natMax_left _ _))
    (Nat.le_trans
      (CoreHelpers.natMax_le
        (Nat.le_trans (Nat.add_le_add_right (simA.β_mono le le) simA.η)
          (CoreHelpers.le_natMax_left _ _))
        (Nat.le_trans (Nat.add_le_add_right (simB.β_mono le le) simB.η)
          (CoreHelpers.le_natMax_right _ _)))
      (CoreHelpers.le_natMax_right _ _))

theorem le_jointOneStepGain
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    (r : Nat) :
    r ≤ jointOneStepGain simX simA simB r :=
  Nat.le_trans (simX.β_ge_left r (simA.drawMod r + simB.drawMod r))
    (Nat.le_trans (Nat.le_add_right _ simX.η) (CoreHelpers.le_natMax_left _ _))

/-- Iterated micro-step excursion bound over `n` micro-steps inside a block. -/
def iterStepGain
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    (r : Nat) : Nat → Nat
  | 0 => r
  | n + 1 => iterStepGain simX simA simB (jointOneStepGain simX simA simB r) n

theorem iterStepGain_mono_r
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    {r₁ r₂ : Nat} (le : r₁ ≤ r₂) :
    ∀ n, iterStepGain simX simA simB r₁ n ≤ iterStepGain simX simA simB r₂ n
  | 0 => le
  | n + 1 => iterStepGain_mono_r simX simA simB (jointOneStepGain_mono simX simA simB le) n

theorem iterStepGain_mono_n
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX) :
    ∀ {n₁ n₂ r}, n₁ ≤ n₂ →
      iterStepGain simX simA simB r n₁ ≤ iterStepGain simX simA simB r n₂ := by
  have hzero : ∀ (m r : Nat), r ≤ iterStepGain simX simA simB r m := by
    intro m
    induction m with
    | zero => intro r; exact Nat.le_refl r
    | succ m ih =>
      intro r
      exact Nat.le_trans (le_jointOneStepGain simX simA simB r)
        (ih (jointOneStepGain simX simA simB r))
  intro n₁ n₂ r le
  induction n₁ generalizing n₂ r with
  | zero => exact hzero n₂ r
  | succ n₁ ih =>
    cases n₂ with
    | zero => exact absurd le (Nat.not_succ_le_zero n₁)
    | succ n₂ =>
      exact ih (Nat.le_of_succ_le_succ le)

theorem le_iterStepGain
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    (r n : Nat) :
    r ≤ iterStepGain simX simA simB r n :=
  iterStepGain_mono_n simX simA simB (Nat.zero_le n)

/-- Project a closed composed trace onto `SubstratePortProcess`, `OpenPortProcess A`, and
`OpenPortProcess B` by structural `Trace` induction. -/
theorem closedTrace_proj
    {SA ObsA DistA IntA SB ObsB DistB IntB Ext Env : Type}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext}
    {initA : SA} {initB : SB}
    (cA : OpenComposition.InterfaceContract A initA)
    (cB : OpenComposition.InterfaceContract B initB)
    (obsA : (Ext → Nat) → ObsA)
    (obsB : (Ext → Nat) → ObsB)
    (channel : Bool → Nat → Env → Bool)
    (G : Ext → (Ext → Nat) → Nat)
    (envDraw : Env → Ext → Nat)
    (jointAdm : Env → Prop) :
    ∀ {st st' : (Ext → Nat) × (SA × SB)} {w : List (Env × (DistA × DistB))},
      Trace (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A B)
        (OpenComposition.composeContract cA cB)
        (fun x => (obsA x, obsB x)) channel G envDraw jointAdm) st w st' →
      ∃ wX wA wB,
        wX.length = w.length ∧ wA.length = w.length ∧ wB.length = w.length ∧
        Trace (SubstratePortProcess G envDraw jointAdm) st.1 wX st'.1 ∧
        Trace (OpenPortProcess A cA.tol obsA) st.2.1 wA st'.2.1 ∧
        Trace (OpenPortProcess B cB.tol obsB) st.2.2 wB st'.2.2 := by
  intro st st' w tr
  induction tr with
  | nil st =>
    exact ⟨[], [], [], rfl, rfl, rfl, .nil st.1, .nil st.2.1, .nil st.2.2⟩
  | @cons st₁ st₂ _ m wTail hstep htr ih =>
    obtain ⟨wX, wA, wB, lX, lA, lB, trX, trA, trB⟩ := ih
    obtain ⟨⟨hEnv, hTol⟩, hEq⟩ := hstep
    let al := channel
      (A.emitAlarm st₁.2.1 (obsA st₁.1) || B.emitAlarm st₁.2.2 (obsB st₁.1))
      (A.silenceLoad st₁.2.1 + B.silenceLoad st₁.2.2) m.1
    let aX : (Ext → Nat) × Env := (fun k => A.drawExt st₁.2.1 k + B.drawExt st₁.2.2 k, m.1)
    let aA : (Ext → Nat) × Bool × DistA := (st₁.1, al, m.2.1)
    let aB : (Ext → Nat) × Bool × DistB := (st₁.1, al, m.2.2)
    have hsX : (SubstratePortProcess G envDraw jointAdm).step st₁.1 aX st₂.1 :=
      ⟨hEnv, congrArg Prod.fst hEq⟩
    have hsA : (OpenPortProcess A cA.tol obsA).step st₁.2.1 aA st₂.2.1 :=
      ⟨(hTol ((obsA st₁.1, obsB st₁.1), al)).1, congrArg (fun p => p.2.1) hEq⟩
    have hsB : (OpenPortProcess B cB.tol obsB).step st₁.2.2 aB st₂.2.2 :=
      ⟨(hTol ((obsA st₁.1, obsB st₁.1), al)).2, congrArg (fun p => p.2.2) hEq⟩
    exact ⟨aX :: wX, aA :: wA, aB :: wB,
      congrArg Nat.succ lX, congrArg Nat.succ lA, congrArg Nat.succ lB,
      .cons hsX trX, .cons hsA trA, .cons hsB trB⟩

/-- Excursion and action-perturbation bound along any closed composed trace by structural
`Trace` induction and `ListTests.mem_cons_iff` (never `List.mem_append` or `decide` on `Mem`). -/
theorem coupled_excursion_bound
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {initA : SA}
    (cA : OpenComposition.InterfaceContract A initA) {obsA : (Ext → Nat) → ObsA}
    {RA : Process QA (QX × BA)} {πA : SA → QA} {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {initB : SB}
    (cB : OpenComposition.InterfaceContract B initB) {obsB : (Ext → Nat) → ObsB}
    {RB : Process QB (QX × BB)} {πB : SB → QB} {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A cA.tol obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B cB.tol obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    (channel : Bool → Nat → Env → Bool)
    {k t : Nat} {q : QX × (QA × QB)}
    (epQX : simX.EpochQX k q.1) (epQA : simA.EpochQ k q.2.1) (epQB : simB.EpochQ k q.2.2) :
    ∀ {st st' : (Ext → Nat) × (SA × SB)} {w : List (Env × (DistA × DistB))} {r : Nat},
      simX.EpochX t st.1 → simA.Epoch t st.2.1 → simB.Epoch t st.2.2 →
      cA.K st.2.1 → cB.K st.2.2 →
      (OpenComposition.SlackDist.max MX (OpenComposition.SlackDist.max MA MB)).d
        (πX st.1, (πA st.2.1, πB st.2.2)) q ≤ r →
      Trace (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A B)
        (OpenComposition.composeContract cA cB)
        (fun x => (obsA x, obsB x)) channel G envDraw jointAdm) st w st' →
      ∃ wX wA wB,
        wX.length = w.length ∧ wA.length = w.length ∧ wB.length = w.length ∧
        Trace (SubstratePortProcess G envDraw jointAdm) st.1 wX st'.1 ∧
        Trace (OpenPortProcess A cA.tol obsA) st.2.1 wA st'.2.1 ∧
        Trace (OpenPortProcess B cB.tol obsB) st.2.2 wB st'.2.2 ∧
        let rMax := iterStepGain simX simA simB r w.length
        let rPrev := match w.length with
          | 0 => r
          | l + 1 => iterStepGain simX simA simB r l
        (OpenComposition.SlackDist.max MX (OpenComposition.SlackDist.max MA MB)).d
          (πX st'.1, (πA st'.2.1, πB st'.2.2)) q ≤ rMax ∧
        (∀ a, a ∈ wX → ∀ j,
          distNat (a.1 j) (drawQA q.2.1 j + drawQB q.2.2 j) ≤
            simA.drawMod rPrev + simB.drawMod rPrev) ∧
        (∀ a, a ∈ wA → (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤ rPrev) ∧
        (∀ a, a ∈ wB → (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤ rPrev) := by
  intro st st' w r epX epA epB epKA epKB d_le tr
  induction tr generalizing t r with
  | nil st =>
    refine ⟨[], [], [], rfl, rfl, rfl, .nil st.1, .nil st.2.1, .nil st.2.2,
      d_le, ?_, ?_, ?_⟩
    · intro a ha; exact False.elim (ListTests.not_mem_nil ha)
    · intro a ha; exact False.elim (ListTests.not_mem_nil ha)
    · intro a ha; exact False.elim (ListTests.not_mem_nil ha)
  | @cons st₁ st₂ _ m wTail hstep htr ih =>
    obtain ⟨⟨hEnv, hTol⟩, hEq⟩ := hstep
    let al := channel
      (A.emitAlarm st₁.2.1 (obsA st₁.1) || B.emitAlarm st₁.2.2 (obsB st₁.1))
      (A.silenceLoad st₁.2.1 + B.silenceLoad st₁.2.2) m.1
    let aX : (Ext → Nat) × Env := (fun j => A.drawExt st₁.2.1 j + B.drawExt st₁.2.2 j, m.1)
    let aA : (Ext → Nat) × Bool × DistA := (st₁.1, al, m.2.1)
    let aB : (Ext → Nat) × Bool × DistB := (st₁.1, al, m.2.2)
    have hsX : (SubstratePortProcess G envDraw jointAdm).step st₁.1 aX st₂.1 :=
      ⟨hEnv, congrArg Prod.fst hEq⟩
    have hsA : (OpenPortProcess A cA.tol obsA).step st₁.2.1 aA st₂.2.1 :=
      ⟨(hTol ((obsA st₁.1, obsB st₁.1), al)).1, congrArg (fun p => p.2.1) hEq⟩
    have hsB : (OpenPortProcess B cB.tol obsB).step st₁.2.2 aB st₂.2.2 :=
      ⟨(hTol ((obsA st₁.1, obsB st₁.1), al)).2, congrArg (fun p => p.2.2) hEq⟩
    have dX : MX.d (πX st₁.1) q.1 ≤ r :=
      Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
    have dA : MA.d (πA st₁.2.1) q.2.1 ≤ r :=
      Nat.le_trans (CoreHelpers.le_natMax_left _ _)
        (Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le)
    have dB : MB.d (πB st₁.2.2) q.2.2 ≤ r :=
      Nat.le_trans (CoreHelpers.le_natMax_right _ _)
        (Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le)
    have haX : ∀ j, distNat (aX.1 j) (drawQA q.2.1 j + drawQB q.2.2 j) ≤
        simA.drawMod r + simB.drawMod r := fun j =>
      Nat.le_trans (distNat_add_le _ _ _ _)
        (Nat.add_le_add (simA.draw_lip t st₁.2.1 q.2.1 r j epA dA)
                        (simB.draw_lip t st₁.2.2 q.2.2 r j epB dB))
    have dX₁ : MX.d (πX st₂.1) q.1 ≤ simX.β r (simA.drawMod r + simB.drawMod r) + simX.η :=
      simX.step_excursion k st₁.1 q.1 (fun j => drawQA q.2.1 j + drawQB q.2.2 j)
        r (simA.drawMod r + simB.drawMod r) t aX.1 m.1 st₂.1 epX epQX dX haX hsX
    have dA₁ : MA.d (πA st₂.2.1) q.2.1 ≤ simA.β r r + simA.η :=
      simA.step_excursion k st₁.2.1 q.2.1 q.1 r r t st₁.1 al m.2.1 st₂.2.1
        epA epX epQA epQX dA dX hsA
    have dB₁ : MB.d (πB st₂.2.2) q.2.2 ≤ simB.β r r + simB.η :=
      simB.step_excursion k st₁.2.2 q.2.2 q.1 r r t st₁.1 al m.2.2 st₂.2.2
        epB epX epQB epQX dB dX hsB
    have d₁ : (OpenComposition.SlackDist.max MX (OpenComposition.SlackDist.max MA MB)).d
        (πX st₂.1, (πA st₂.2.1, πB st₂.2.2)) q ≤ jointOneStepGain simX simA simB r :=
      CoreHelpers.natMax_le
        (Nat.le_trans dX₁ (CoreHelpers.le_natMax_left _ _))
        (Nat.le_trans
          (CoreHelpers.natMax_le
            (Nat.le_trans dA₁ (CoreHelpers.le_natMax_left _ _))
            (Nat.le_trans dB₁ (CoreHelpers.le_natMax_right _ _)))
          (CoreHelpers.le_natMax_right _ _))
    have epX₁ := simX.epoch_step t st₁.1 aX st₂.1 epX hsX
    have epA₁ := simA.epoch_step t st₁.2.1 aA st₂.2.1 epA epX hsA
    have epB₁ := simB.epoch_step t st₁.2.2 aB st₂.2.2 epB epX hsB
    have epKA₁ : cA.K st₂.2.1 :=
      cA.cert.closed st₁.2.1 ((obsA st₁.1, al), m.2.1) st₂.2.1
        ⟨(hTol ((obsA st₁.1, obsB st₁.1), al)).1, congrArg (fun p => p.2.1) hEq⟩ epKA
    have epKB₁ : cB.K st₂.2.2 :=
      cB.cert.closed st₁.2.2 ((obsB st₁.1, al), m.2.2) st₂.2.2
        ⟨(hTol ((obsA st₁.1, obsB st₁.1), al)).2, congrArg (fun p => p.2.2) hEq⟩ epKB
    obtain ⟨wX, wA, wB, lX, lA, lB, trX, trA, trB, dEnd, hwX, hwA, hwB⟩ :=
      ih (t := t + 1) (r := jointOneStepGain simX simA simB r)
        epX₁ epA₁ epB₁ epKA₁ epKB₁ d₁
    refine ⟨aX :: wX, aA :: wA, aB :: wB,
      congrArg Nat.succ lX, congrArg Nat.succ lA, congrArg Nat.succ lB,
      .cons hsX trX, .cons hsA trA, .cons hsB trB, dEnd, ?_, ?_, ?_⟩
    · intro a ha j
      cases ListTests.mem_cons_iff.mp ha with
      | inl hHead =>
        rw [hHead]
        have r_le : r ≤ iterStepGain simX simA simB r wTail.length :=
          le_iterStepGain simX simA simB r wTail.length
        exact Nat.le_trans (haX j)
          (Nat.add_le_add (simA.drawMod_mono r_le) (simB.drawMod_mono r_le))
      | inr hTail =>
        cases hlen : wTail.length with
        | zero =>
          have hlenX : wX.length = 0 := lX.trans hlen
          cases wX with
          | nil => exact False.elim (ListTests.not_mem_nil hTail)
          | cons _ _ => exact absurd hlenX (Naturals.succ_ne_zero _)
        | succ l =>
          have h := hwX a hTail j
          rw [hlen] at h
          change distNat (a.1 j) (drawQA q.2.1 j + drawQB q.2.2 j) ≤
            simA.drawMod (iterStepGain simX simA simB (jointOneStepGain simX simA simB r) l) +
            simB.drawMod (iterStepGain simX simA simB (jointOneStepGain simX simA simB r) l) at h
          change distNat (a.1 j) (drawQA q.2.1 j + drawQB q.2.2 j) ≤
            simA.drawMod (iterStepGain simX simA simB r wTail.length) +
            simB.drawMod (iterStepGain simX simA simB r wTail.length)
          rw [hlen]
          exact h
    · intro a ha
      cases ListTests.mem_cons_iff.mp ha with
      | inl hHead =>
        rw [hHead]
        exact ⟨⟨t, epX⟩, Nat.le_trans dX (le_iterStepGain simX simA simB r wTail.length)⟩
      | inr hTail =>
        cases hlen : wTail.length with
        | zero =>
          have hlenA : wA.length = 0 := lA.trans hlen
          cases wA with
          | nil => exact False.elim (ListTests.not_mem_nil hTail)
          | cons _ _ => exact absurd hlenA (Naturals.succ_ne_zero _)
        | succ l =>
          have h := hwA a hTail
          rw [hlen] at h
          change (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤
            iterStepGain simX simA simB (jointOneStepGain simX simA simB r) l at h
          change (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤
            iterStepGain simX simA simB r wTail.length
          rw [hlen]
          exact h
    · intro a ha
      cases ListTests.mem_cons_iff.mp ha with
      | inl hHead =>
        rw [hHead]
        exact ⟨⟨t, epX⟩, Nat.le_trans dX (le_iterStepGain simX simA simB r wTail.length)⟩
      | inr hTail =>
        cases hlen : wTail.length with
        | zero =>
          have hlenB : wB.length = 0 := lB.trans hlen
          cases wB with
          | nil => exact False.elim (ListTests.not_mem_nil hTail)
          | cons _ _ => exact absurd hlenB (Naturals.succ_ne_zero _)
        | succ l =>
          have h := hwB a hTail
          rw [hlen] at h
          change (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤
            iterStepGain simX simA simB (jointOneStepGain simX simA simB r) l at h
          change (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤
            iterStepGain simX simA simB r wTail.length
          rw [hlen]
          exact h

/-- Combined one-block gain of `coupled_closed_laxSim` over block stride bound `Mstride`. -/
def coupledBlockGain
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {tolA : ObsA × Bool → DistA → Prop}
    {obsA : (Ext → Nat) → ObsA} {RA : Process QA (QX × BA)} {πA : SA → QA}
    {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {tolB : ObsB × Bool → DistB → Prop}
    {obsB : (Ext → Nat) → ObsB} {RB : Process QB (QX × BB)} {πB : SB → QB}
    {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A tolA obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B tolB obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    (Mstride r : Nat) : Nat :=
  let rExc := iterStepGain simX simA simB r (Mstride - 1)
  CoreHelpers.natMax
    (simX.gain r (simA.drawMod rExc + simB.drawMod rExc))
    (CoreHelpers.natMax (simA.gain r rExc) (simB.gain r rExc))

/-- Compositional coupled-substrate `LaxSim` closing `A ⊕ B` onto `G` against
`coupledMacroProcess RX RA RB`, including `cA.K st.2.1 ∧ cB.K st.2.2` inside `Epoch`. -/
def coupled_closed_laxSim
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    (strict_σ : Strict σ) (Mstride : Nat) (stride_le : ∀ k, σ (k + 1) - σ k ≤ Mstride)
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {initA : SA}
    (cA : OpenComposition.InterfaceContract A initA) (obsA : (Ext → Nat) → ObsA)
    {RA : Process QA (QX × BA)} {πA : SA → QA} {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {initB : SB}
    (cB : OpenComposition.InterfaceContract B initB) (obsB : (Ext → Nat) → ObsB)
    {RB : Process QB (QX × BB)} {πB : SB → QB} {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (channel : Bool → Nat → Env → Bool)
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A cA.tol obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B cB.tol obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX) :
    LaxSim
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A B)
        (OpenComposition.composeContract cA cB)
        (fun x => (obsA x, obsB x)) channel G envDraw jointAdm)
      (coupledMacroProcess RX RA RB drawQA drawQB)
      (fun st => (πX st.1, (πA st.2.1, πB st.2.2)))
      σ
      (OpenComposition.SlackDist.max MX (OpenComposition.SlackDist.max MA MB)) where
  strict := strict_σ
  Epoch t st :=
    simX.EpochX t st.1 ∧ simA.Epoch t st.2.1 ∧ simB.Epoch t st.2.2 ∧ cA.K st.2.1 ∧ cB.K st.2.2
  EpochQ k q := simX.EpochQX k q.1 ∧ simA.EpochQ k q.2.1 ∧ simB.EpochQ k q.2.2
  epoch_step t st m st' ep hstep := by
    obtain ⟨epX, epA, epB, epKA, epKB⟩ := ep
    obtain ⟨⟨hEnv, hTol⟩, hEq⟩ := hstep
    let al := channel
      (A.emitAlarm st.2.1 (obsA st.1) || B.emitAlarm st.2.2 (obsB st.1))
      (A.silenceLoad st.2.1 + B.silenceLoad st.2.2) m.1
    let aX : (Ext → Nat) × Env := (fun k => A.drawExt st.2.1 k + B.drawExt st.2.2 k, m.1)
    let aA : (Ext → Nat) × Bool × DistA := (st.1, al, m.2.1)
    let aB : (Ext → Nat) × Bool × DistB := (st.1, al, m.2.2)
    have hsX : (SubstratePortProcess G envDraw jointAdm).step st.1 aX st'.1 :=
      ⟨hEnv, congrArg Prod.fst hEq⟩
    have hsA : (OpenPortProcess A cA.tol obsA).step st.2.1 aA st'.2.1 :=
      ⟨(hTol ((obsA st.1, obsB st.1), al)).1, congrArg (fun p => p.2.1) hEq⟩
    have hsB : (OpenPortProcess B cB.tol obsB).step st.2.2 aB st'.2.2 :=
      ⟨(hTol ((obsA st.1, obsB st.1), al)).2, congrArg (fun p => p.2.2) hEq⟩
    exact ⟨simX.epoch_step t st.1 aX st'.1 epX hsX,
      simA.epoch_step t st.2.1 aA st'.2.1 epA epX hsA,
      simB.epoch_step t st.2.2 aB st'.2.2 epB epX hsB,
      cA.cert.closed st.2.1 ((obsA st.1, al), m.2.1) st'.2.1
        ⟨(hTol ((obsA st.1, obsB st.1), al)).1, congrArg (fun p => p.2.1) hEq⟩ epKA,
      cB.cert.closed st.2.2 ((obsB st.1, al), m.2.2) st'.2.2
        ⟨(hTol ((obsA st.1, obsB st.1), al)).2, congrArg (fun p => p.2.2) hEq⟩ epKB⟩
  epoch_proj k st ep :=
    ⟨simX.epoch_proj k st.1 ep.1, simA.epoch_proj k st.2.1 ep.2.1, simB.epoch_proj k st.2.2 ep.2.2.1⟩
  α := coupledBlockGain simX simA simB Mstride
  β r := iterStepGain simX simA simB r (Mstride - 1)
  α_mono {r₁ r₂} le := by
    have rExc_le : iterStepGain simX simA simB r₁ (Mstride - 1) ≤
        iterStepGain simX simA simB r₂ (Mstride - 1) :=
      iterStepGain_mono_r simX simA simB le (Mstride - 1)
    exact CoreHelpers.natMax_le
      (Nat.le_trans
        (simX.gain_mono le (Nat.add_le_add (simA.drawMod_mono rExc_le) (simB.drawMod_mono rExc_le)))
        (CoreHelpers.le_natMax_left _ _))
      (Nat.le_trans
        (CoreHelpers.natMax_le
          (Nat.le_trans (simA.gain_mono le rExc_le) (CoreHelpers.le_natMax_left _ _))
          (Nat.le_trans (simB.gain_mono le rExc_le) (CoreHelpers.le_natMax_right _ _)))
        (CoreHelpers.le_natMax_right _ _))
  β_mono le := iterStepGain_mono_r simX simA simB le (Mstride - 1)
  β_ge_id r := le_iterStepGain simX simA simB r (Mstride - 1)
  ε := CoreHelpers.natMax simX.ε (CoreHelpers.natMax simA.ε simB.ε)
  η := 0
  sim_block k st q r w st' epS epQ d_le w_len tr := by
    obtain ⟨epX, epA, epB, epKA, epKB⟩ := epS
    obtain ⟨epQX, epQA, epQB⟩ := epQ
    obtain ⟨wX, wA, wB, lX, lA, lB, trX, trA, trB, _, hwX, hwA, hwB⟩ :=
      coupled_excursion_bound cA cB simX simA simB channel epQX epQA epQB
        epX epA epB epKA epKB d_le tr
    have hpos : 0 < w.length := by
      rw [w_len]
      exact Naturals.le_sub_of_add_le (strict_σ k)
    cases hwl : w.length with
    | zero => exact absurd hwl (Nat.ne_of_gt hpos)
    | succ l =>
      have hl_le : l ≤ Mstride - 1 := by
        have h1 : 1 + l ≤ Mstride :=
          Nat.add_comm l 1 ▸ (hwl ▸ (w_len ▸ stride_le k))
        exact Naturals.le_sub_of_add_le h1
      have hrExc : iterStepGain simX simA simB r l ≤ iterStepGain simX simA simB r (Mstride - 1) :=
        iterStepGain_mono_n simX simA simB hl_le
      let rExc := iterStepGain simX simA simB r (Mstride - 1)
      have hwX' : ∀ a, a ∈ wX → ∀ j,
          distNat (a.1 j) (drawQA q.2.1 j + drawQB q.2.2 j) ≤
            simA.drawMod rExc + simB.drawMod rExc := fun a ha j => by
        have h := hwX a ha j
        rw [hwl] at h
        exact Nat.le_trans h (Nat.add_le_add (simA.drawMod_mono hrExc) (simB.drawMod_mono hrExc))
      have hwA' : ∀ a, a ∈ wA → (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤ rExc :=
        fun a ha => by
          have h := hwA a ha
          rw [hwl] at h
          exact ⟨h.1, Nat.le_trans h.2 hrExc⟩
      have hwB' : ∀ a, a ∈ wB → (∃ t', simX.EpochX t' a.1) ∧ MX.d (πX a.1) q.1 ≤ rExc :=
        fun a ha => by
          have h := hwB a ha
          rw [hwl] at h
          exact ⟨h.1, Nat.le_trans h.2 hrExc⟩
      have dX : MX.d (πX st.1) q.1 ≤ r := Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
      have dA : MA.d (πA st.2.1) q.2.1 ≤ r :=
        Nat.le_trans (CoreHelpers.le_natMax_left _ _)
          (Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le)
      have dB : MB.d (πB st.2.2) q.2.2 ≤ r :=
        Nat.le_trans (CoreHelpers.le_natMax_right _ _)
          (Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le)
      obtain ⟨bX, qX', stepX, epQX', dX'⟩ :=
        simX.sim_block k st.1 q.1 (fun j => drawQA q.2.1 j + drawQB q.2.2 j)
          r (simA.drawMod rExc + simB.drawMod rExc) wX st'.1
          epX epQX dX hwX' (lX.trans w_len) trX
      obtain ⟨bA, qA', stepA, epQA', dA'⟩ :=
        simA.sim_block k st.2.1 q.2.1 q.1 r rExc wA st'.2.1
          epA epQA epQX dA hwA' (lA.trans w_len) trA
      obtain ⟨bB, qB', stepB, epQB', dB'⟩ :=
        simB.sim_block k st.2.2 q.2.2 q.1 r rExc wB st'.2.2
          epB epQB epQX dB hwB' (lB.trans w_len) trB
      refine ⟨(bX, (bA, bB)), (qX', (qA', qB')), ⟨stepX, stepA, stepB⟩, ⟨epQX', epQA', epQB'⟩, ?_⟩
      exact CoreHelpers.natMax_le
        (Nat.le_trans dX'
          (Nat.add_le_add (CoreHelpers.le_natMax_left _ _) (CoreHelpers.le_natMax_left _ _)))
        (Nat.le_trans
          (CoreHelpers.natMax_le
            (Nat.le_trans dA'
              (Nat.add_le_add
                (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (CoreHelpers.le_natMax_right _ _))
                (Nat.le_trans (CoreHelpers.le_natMax_left _ _) (CoreHelpers.le_natMax_right _ _))))
            (Nat.le_trans dB'
              (Nat.add_le_add
                (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (CoreHelpers.le_natMax_right _ _))
                (Nat.le_trans (CoreHelpers.le_natMax_right _ _) (CoreHelpers.le_natMax_right _ _)))))
          (Nat.le_refl _))
  excursion k st q r w₁ u epS epQ d_le w₁_lt tr := by
    obtain ⟨epX, epA, epB, epKA, epKB⟩ := epS
    obtain ⟨epQX, epQA, epQB⟩ := epQ
    obtain ⟨_, _, _, _, _, _, _, _, _, dEnd, _⟩ :=
      coupled_excursion_bound cA cB simX simA simB channel epQX epQA epQB
        epX epA epB epKA epKB d_le tr
    have hlt : w₁.length ≤ Mstride - 1 :=
      Naturals.le_sub_of_add_le (Nat.add_comm w₁.length 1 ▸ Nat.le_trans w₁_lt (stride_le k))
    exact Nat.le_trans dEnd (Nat.le_trans (iterStepGain_mono_n simX simA simB hlt) (Nat.le_add_right _ 0))

theorem laxSim_trace_epoch {S A Q B : Type}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M) :
    ∀ {t : Nat} {s u : S} {w : List A},
      sim.Epoch t s → Trace P s w u → sim.Epoch (t + w.length) u
  | _, _, _, [], ep, .nil _ => ep
  | t, _, _, _ :: w', ep, .cons hstep htr =>
    have ep₁ := sim.epoch_step t _ _ _ ep hstep
    have heq : (t + 1) + w'.length = t + (w'.length + 1) := Nat.add_right_comm t 1 w'.length
    heq ▸ laxSim_trace_epoch sim ep₁ htr

/-- **Small-gain infinite-horizon kernel theorem** (`coupled_closed_lax_kernel`):
from macro certificate `certQ`, small-gain absorption `coupledBlockGain ... Δ + ε ≤ Δ`,
initial epoch membership, and substrate guard margin `margin`, proves full `Viability.Kernel`
for the closed coupled system `closedProcess (A ⊕ B) ...`. -/
theorem coupled_closed_lax_kernel
    {Ext Env QX BX SA ObsA DistA IntA QA BA SB ObsB DistB IntB QB BB : Type}
    {G : Ext → (Ext → Nat) → Nat} {envDraw : Env → Ext → Nat} {jointAdm : Env → Prop}
    {RX : Process QX ((Ext → Nat) × BX)} {πX : (Ext → Nat) → QX} {σ : Nat → Nat}
    (strict_σ : Strict σ) (Mstride : Nat) (stride_le : ∀ k, σ (k + 1) - σ k ≤ Mstride)
    {MX : SlackDist QX}
    {A : OpenComposition.OpenComponent SA ObsA DistA IntA Ext} {initA : SA}
    (cA : OpenComposition.InterfaceContract A initA) (obsA : (Ext → Nat) → ObsA)
    {RA : Process QA (QX × BA)} {πA : SA → QA} {drawQA : QA → Ext → Nat} {MA : SlackDist QA}
    {B : OpenComposition.OpenComponent SB ObsB DistB IntB Ext} {initB : SB}
    (cB : OpenComposition.InterfaceContract B initB) (obsB : (Ext → Nat) → ObsB)
    {RB : Process QB (QX × BB)} {πB : SB → QB} {drawQB : QB → Ext → Nat} {MB : SlackDist QB}
    (channel : Bool → Nat → Env → Bool)
    (simX : SubstrateLaxSim G envDraw jointAdm RX πX σ MX)
    (simA : OpenSubLaxSim A cA.tol obsA RA πA drawQA σ MA MX πX simX.EpochX simX.EpochQX)
    (simB : OpenSubLaxSim B cB.tol obsB RB πB drawQB σ MB MX πX simX.EpochX simX.EpochQX)
    {guardQ KQ : QX × (QA × QB) → Prop}
    (certQ : Viability.Certificate (coupledMacroProcess RX RA RB drawQA drawQB) guardQ KQ)
    (x_crit : Ext → Nat)
    (Δ : Nat)
    (absorb :
      (coupled_closed_laxSim strict_σ Mstride stride_le cA obsA cB obsB channel simX simA simB).α Δ +
      (coupled_closed_laxSim strict_σ Mstride stride_le cA obsA cB obsB channel simX simA simB).ε ≤ Δ)
    (margin : ∀ (q : QX × (QA × QB)) (u : (Ext → Nat) × (SA × SB)), guardQ q →
      (OpenComposition.SlackDist.max MX (OpenComposition.SlackDist.max MA MB)).d
        (πX u.1, (πA u.2.1, πB u.2.2)) q ≤
      (coupled_closed_laxSim strict_σ Mstride stride_le cA obsA cB obsB channel simX simA simB).β Δ +
      (coupled_closed_laxSim strict_σ Mstride stride_le cA obsA cB obsB channel simX simA simB).η →
      ∀ k, x_crit k ≤ u.1 k)
    {x₀ : Ext → Nat}
    (epX₀ : simX.EpochX (σ 0) x₀)
    (epA₀ : simA.Epoch (σ 0) initA)
    (epB₀ : simB.Epoch (σ 0) initB)
    (initQ : KQ (πX x₀, (πA initA, πB initB))) :
    Viability.Kernel
      (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A B)
        (OpenComposition.composeContract cA cB)
        (fun x => (obsA x, obsB x)) channel G envDraw jointAdm)
      (OpenComposition.closedGuard (OpenComposition.OpenComponent.compose A B)
        (OpenComposition.composeContract cA cB) x_crit)
      (x₀, (initA, initB)) := by
  let sim := coupled_closed_laxSim strict_σ Mstride stride_le cA obsA cB obsB channel simX simA simB
  have hSub :
      Viability.Kernel
        (OpenComposition.closedProcess (OpenComposition.OpenComponent.compose A B)
          (OpenComposition.composeContract cA cB)
          (fun x => (obsA x, obsB x)) channel G envDraw jointAdm)
        (fun u => ∀ k, x_crit k ≤ u.1 k)
        (x₀, (initA, initB)) :=
    lax_kernel_of_certificate sim certQ Δ absorb margin ⟨epX₀, epA₀, epB₀, cA.init_in, cB.init_in⟩ initQ
  intro u ⟨w, tr⟩
  have hXCrit : ∀ k, x_crit k ≤ u.1 k := hSub u ⟨w, tr⟩
  have epU := laxSim_trace_epoch sim ⟨epX₀, epA₀, epB₀, cA.init_in, cB.init_in⟩ tr
  have hWithin := (OpenComposition.composeContract cA cB).cert.within u.2 ⟨epU.2.2.2.1, epU.2.2.2.2⟩
  exact ⟨hXCrit, hWithin⟩

/-! ### Witness 4: `CoupledSmallGainWitness` -/

namespace CoupledSmallGainWitness

def clamp16_24 (n : Nat) : Nat := CoreHelpers.natMin 24 (CoreHelpers.natMax 16 n)

theorem clamp16_24_bounds (n : Nat) : 16 ≤ clamp16_24 n ∧ clamp16_24 n ≤ 24 :=
  ⟨CoreHelpers.le_natMin (by decide) (CoreHelpers.le_natMax_left 16 n),
   CoreHelpers.natMin_le_left 24 _⟩

theorem clamp16_24_lip (a b : Nat) : distNat (clamp16_24 a) (clamp16_24 b) ≤ distNat a b :=
  Nat.le_trans (distNat_natMin_const_le 24 _ _) (distNat_natMax_const_le 16 a b)

def G_sg (_ : Unit) (e : Unit → Nat) : Nat := (24 - e ()) / 2

def sgSubStep (x : Unit → Nat) (h : Unit → Nat) : Unit → Nat :=
  RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G_sg h x

def compGood : OpenComposition.OpenComponent (Nat × Bool) Nat Unit Empty Unit where
  next st oa _ := (5 + (st.1 + clamp16_24 oa.1 / 2) / 4, !st.2)
  drawInt _ e := Empty.elim e
  drawExt st _ := st.1 / 4 + (if st.2 then 1 else 0)
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

def compGoodContract (init : Nat × Bool) (hInit : 6 ≤ init.1 ∧ init.1 ≤ 14) :
    OpenComposition.InterfaceContract compGood init where
  tol _ _ := True
  warnObs _ := False
  preCapInt e := Empty.elim e
  preCapExt _ := 4
  postBudgetInt e := Empty.elim e
  postBudgetExt _ := 4
  maxSilence := 0
  maxLag := 0
  K st := 6 ≤ st.1 ∧ st.1 ≤ 14
  eta _ := 0
  init_in := hInit
  cert := Viability.certificate_disturbed_iff.mpr
    ⟨fun st ⟨_, hle⟩ =>
      ⟨fun e => Empty.elim e,
       fun () => by
         dsimp [compGood]
         have hd : st.1 / 4 ≤ 14 / 4 := div_mono_nat hle 4
         have hd3 : st.1 / 4 ≤ 3 := hd
         cases st.2
         · exact Nat.le_trans (Nat.add_le_add_right hd3 0) (by decide)
         · exact Nat.add_le_add_right hd3 1,
       by dsimp [compGood]; exact Nat.le_refl 0,
       fun _ => ⟨False.elim, fun e => Empty.elim e, fun () => by
         dsimp [compGood]
         have hd : st.1 / 4 ≤ 3 := div_mono_nat hle 4
         cases st.2
         · exact Nat.le_trans (Nat.add_le_add_right hd 0) (by decide)
         · exact Nat.add_le_add_right hd 1⟩⟩,
     fun st m _ ⟨hge, hle⟩ => by
       have hb := clamp16_24_bounds m.1.1
       have hdiv1 : 8 ≤ clamp16_24 m.1.1 / 2 := div_mono_nat hb.1 2
       have hdiv2 : clamp16_24 m.1.1 / 2 ≤ 12 := div_mono_nat hb.2 2
       refine ⟨?_, ?_⟩
       · show 6 ≤ 5 + (st.1 + clamp16_24 m.1.1 / 2) / 4
         have hsum : 14 ≤ st.1 + clamp16_24 m.1.1 / 2 := Nat.add_le_add hge hdiv1
         have hq : 3 ≤ (st.1 + clamp16_24 m.1.1 / 2) / 4 := div_mono_nat hsum 4
         exact Nat.le_trans (by decide : 6 ≤ 5 + 3) (Nat.add_le_add_left hq 5)
       · show 5 + (st.1 + clamp16_24 m.1.1 / 2) / 4 ≤ 14
         have hsum : st.1 + clamp16_24 m.1.1 / 2 ≤ 26 := Nat.add_le_add hle hdiv2
         have hq : (st.1 + clamp16_24 m.1.1 / 2) / 4 ≤ 6 := div_mono_nat hsum 4
         exact Nat.le_trans (Nat.add_le_add_left hq 5) (by decide : 5 + 6 ≤ 14)⟩
  eta_bound _ _ := Nat.le_refl 0
  emits_on_warn _ _ _ hw := False.elim hw
  eta_alarm_step _ _ _ _ _ pos := absurd pos (Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

def sgChannel (_ : Bool) (_ : Nat) (_ : Unit) : Bool := false
def sgObs (x : Unit → Nat) : Nat := x ()
def sgEnvDraw (_ : Unit) (_ : Unit) : Nat := 0
def sgJointAdm (_ : Unit) : Prop := True

def sgRX : Process Nat ((Unit → Nat) × Unit) where
  step qX a qX' := qX' = sgSubStep (fun _ => qX) a.1 ()

def sgRComp : Process Nat (Nat × Unit) where
  step q a q' := q' = 5 + (q + clamp16_24 a.1 / 2) / 4

def sgDrawQ (q : Nat) (_ : Unit) : Nat := q / 4

def sgEpochX (_ : Nat) (x : Unit → Nat) : Prop := x () ≤ 24
def sgEpochQX (_ : Nat) (qX : Nat) : Prop := qX ≤ 24
def sgEpochQ (_ : Nat) (q : Nat) : Prop := 6 ≤ q ∧ q ≤ 14

theorem two_mul_eq_mul_two (m : Nat) : 2 * m = m * 2 :=
  ((Naturals.two_mul m).trans (congrArg (· + m) (Nat.zero_add m).symm)).trans
    (Nat.mul_succ m 1).symm

theorem two_mul_div_two_le (n : Nat) : 2 * (n / 2) ≤ n := by
  obtain ⟨heq, _⟩ := CoreHelpers.div_mod_decomp (by decide : 0 < 2) n
  calc 2 * (n / 2) = n / 2 * 2 := two_mul_eq_mul_two (n / 2)
    _ ≤ n / 2 * 2 + n % 2 := Nat.le_add_right _ _
    _ = n := heq.symm

theorem succ_div2_le (d : Nat) : (d + 1) / 2 ≤ d := by
  cases d with
  | zero => decide
  | succ d' =>
    have hle : d' + 1 + 1 ≤ (d' + 1) * 2 := by
      calc d' + 1 + 1 ≤ d' + 1 + (d' + 1) := Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le d')) _
        _ = 2 * (d' + 1) := (Naturals.two_mul (d' + 1)).symm
        _ = (d' + 1) * 2 := two_mul_eq_mul_two (d' + 1)
    exact Nat.le_trans (div_mono_nat hle 2)
      (Nat.le_of_eq (CoreHelpers.div_mul_add_rem (by decide : 0 < 2) (by decide : 0 < 2) (d' + 1)))

theorem div2_add_div2_succ (d : Nat) : d = d / 2 + (d + 1) / 2 := by
  obtain ⟨heq, hrem⟩ := CoreHelpers.div_mod_decomp (by decide : 0 < 2) d
  cases hm : d % 2 with
  | zero =>
    rw [hm] at heq
    have hd2 : (d + 1) / 2 = d / 2 := by
      calc (d + 1) / 2 = (d / 2 * 2 + 1) / 2 := congrArg (· / 2) (congrArg (· + 1) heq)
        _ = d / 2 := CoreHelpers.div_mul_add_rem (by decide : 0 < 2) (by decide : 1 < 2) (d / 2)
    rw [hd2]
    calc d = d / 2 * 2 := heq
      _ = 2 * (d / 2) := (two_mul_eq_mul_two (d / 2)).symm
      _ = d / 2 + d / 2 := Naturals.two_mul (d / 2)
  | succ r =>
    rw [hm] at hrem
    have hr0 : r = 0 := by
      cases r with
      | zero => rfl
      | succ r' =>
        exact absurd
          (Nat.le_trans (Nat.succ_le_succ (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le r')))) hrem)
          (Nat.lt_irrefl 2)
    subst hr0
    rw [hm] at heq
    have hd2 : (d + 1) / 2 = d / 2 + 1 := by
      have heq1 : d + 1 = (d / 2 + 1) * 2 + 0 := by
        calc d + 1 = (d / 2 * 2 + 1) + 1 := congrArg (· + 1) heq
          _ = d / 2 * 2 + 2 := Nat.add_assoc _ 1 1
          _ = (d / 2 + 1) * 2 + 0 := (Nat.succ_mul (d / 2) 2).symm
      rw [heq1]
      exact CoreHelpers.div_mul_add_rem (by decide : 0 < 2) (by decide : 0 < 2) (d / 2 + 1)
    rw [hd2]
    calc d = d / 2 * 2 + 1 := heq
      _ = 2 * (d / 2) + 1 := congrArg (· + 1) (two_mul_eq_mul_two (d / 2)).symm
      _ = (d / 2 + d / 2) + 1 := congrArg (· + 1) (Naturals.two_mul (d / 2))
      _ = d / 2 + (d / 2 + 1) := Nat.add_assoc _ _ _

theorem distNat_le_of_le {a b M : Nat} (ha : a ≤ M) (hb : b ≤ M) : distNat a b ≤ M := by
  cases Nat.le_total a b with
  | inl le =>
    unfold distNat
    rw [sub_eq_zero_of_le le, Nat.zero_add]
    exact Nat.le_trans (Nat.sub_le b a) hb
  | inr ge =>
    unfold distNat
    rw [sub_eq_zero_of_le ge, Nat.add_zero]
    exact Nat.le_trans (Nat.sub_le a b) ha

theorem le_sub_of_distNat_le {x c r : Nat} (hr : r ≤ c) (h : distNat x c ≤ r) : c - r ≤ x := by
  have hcx : c - x ≤ r := Nat.le_trans (Nat.le_add_left (c - x) (x - c)) h
  cases Nat.le_total c x with
  | inl hle => exact Nat.le_trans (Nat.sub_le c r) hle
  | inr hle =>
    have hsum : (c - r) + r ≤ x + r :=
      Nat.le_trans (Nat.le_of_eq (Naturals.sub_add_cancel hr))
        (Nat.le_trans (Nat.le_of_eq (Naturals.add_sub_of_le hle).symm)
          (Nat.add_le_add_left hcx x))
    exact Becoming.le_of_add_le_add_right r hsum

theorem half_const_step_lip (a b : Nat) (ha : a ≤ 24) (hb : b ≤ 24) :
    distNat (a + (24 - a) / 2) (b + (24 - b) / 2) ≤ (distNat a b + 1) / 2 := by
  suffices hmono : ∀ x y : Nat, x ≤ y → y ≤ 24 →
      y + (24 - y) / 2 - (x + (24 - x) / 2) ≤ (y - x + 1) / 2 ∧
      x + (24 - x) / 2 ≤ y + (24 - y) / 2 by
    cases Nat.le_total a b with
    | inl le =>
      have h := hmono a b le hb
      unfold distNat
      rw [sub_eq_zero_of_le h.2, Nat.zero_add, sub_eq_zero_of_le le, Nat.zero_add]
      exact h.1
    | inr ge =>
      have h := hmono b a ge ha
      unfold distNat
      rw [sub_eq_zero_of_le h.2, Nat.add_zero, sub_eq_zero_of_le ge, Nat.add_zero]
      exact h.1
  intro x y hxy hy24
  have hdiff : 24 - x = (24 - y) + (y - x) := by
    have h1 : x + (y - x) = y := Naturals.add_sub_of_le hxy
    have h2 : y + (24 - y) = 24 := Naturals.add_sub_of_le hy24
    have h3 : x + ((24 - y) + (y - x)) = 24 := by
      rw [← Nat.add_assoc, Nat.add_comm x (24 - y), Nat.add_assoc, h1, Nat.add_comm (24 - y) y, h2]
    exact (congrArg (· - x) h3).symm.trans
      (Naturals.add_sub_cancel_left x ((24 - y) + (y - x)))
  have hdiv_ub : (24 - x) / 2 ≤ (24 - y) / 2 + (y - x + 1) / 2 := by
    rw [hdiff]
    exact add_div_le_nat (by decide : 0 < 2) (24 - y) (y - x)
  have hdiv_le : (24 - x) / 2 ≤ (24 - y) / 2 + (y - x) :=
    Nat.le_trans hdiv_ub (Nat.add_le_add_left (succ_div2_le (y - x)) _)
  have hle_step : x + (24 - x) / 2 ≤ y + (24 - y) / 2 := by
    calc x + (24 - x) / 2 ≤ x + ((24 - y) / 2 + (y - x)) := Nat.add_le_add_left hdiv_le x
      _ = (x + (y - x)) + (24 - y) / 2 := by
          rw [Nat.add_comm ((24 - y) / 2) (y - x), ← Nat.add_assoc]
      _ = y + (24 - y) / 2 := congrArg (· + (24 - y) / 2) (Naturals.add_sub_of_le hxy)
  have h2sum : ((24 - y) / 2 + (y - x) / 2) * 2 ≤ 24 - x := by
    calc ((24 - y) / 2 + (y - x) / 2) * 2
        = (24 - y) / 2 * 2 + (y - x) / 2 * 2 := Becoming.add_mul_split _ _ 2
      _ = 2 * ((24 - y) / 2) + 2 * ((y - x) / 2) := by
          rw [two_mul_eq_mul_two ((24 - y) / 2), two_mul_eq_mul_two ((y - x) / 2)]
      _ ≤ (24 - y) + (y - x) := Nat.add_le_add (two_mul_div_two_le (24 - y)) (two_mul_div_two_le (y - x))
      _ = 24 - x := hdiff.symm
  have hdiv_lb : (24 - y) / 2 + (y - x) / 2 ≤ (24 - x) / 2 :=
    Nat.le_trans
      (Nat.le_of_eq (CoreHelpers.div_mul_add_rem (by decide : 0 < 2) (by decide : 0 < 2) _).symm)
      (div_mono_nat h2sum 2)
  have hadd : y + (24 - y) / 2 ≤ x + (24 - x) / 2 + (y - x + 1) / 2 := by
    calc y + (24 - y) / 2
        = (x + (y - x)) + (24 - y) / 2 := congrArg (· + _) (Naturals.add_sub_of_le hxy).symm
      _ = (x + ((y - x) / 2 + (y - x + 1) / 2)) + (24 - y) / 2 :=
          congrArg (fun z => (x + z) + (24 - y) / 2) (div2_add_div2_succ (y - x))
      _ = x + (((y - x) / 2 + (y - x + 1) / 2) + (24 - y) / 2) := Nat.add_assoc _ _ _
      _ = x + (((y - x) / 2 + (24 - y) / 2) + (y - x + 1) / 2) :=
          congrArg (x + ·) (Nat.add_right_comm ((y - x) / 2) ((y - x + 1) / 2) ((24 - y) / 2))
      _ = x + ((24 - y) / 2 + (y - x) / 2) + (y - x + 1) / 2 := by
          rw [Nat.add_comm ((y - x) / 2) ((24 - y) / 2)]
          exact (Nat.add_assoc x _ _).symm
      _ ≤ x + (24 - x) / 2 + (y - x + 1) / 2 :=
          Nat.add_le_add_right (Nat.add_le_add_left hdiv_lb x) _
  exact ⟨Naturals.sub_le_of_le_add hadd, hle_step⟩

theorem sgSubStep_within_24 (x h : Nat) (hx : x ≤ 24) : x - h + (24 - (x - h)) / 2 ≤ 24 := by
  have he : x - h ≤ 24 := Nat.le_trans (Nat.sub_le x h) hx
  have hd : 2 * ((24 - (x - h)) / 2) ≤ 24 - (x - h) := two_mul_div_two_le _
  have hle : (24 - (x - h)) / 2 ≤ 24 - (x - h) := by
    calc (24 - (x - h)) / 2 ≤ (24 - (x - h)) / 2 + (24 - (x - h)) / 2 := Nat.le_add_right _ _
      _ = 2 * ((24 - (x - h)) / 2) := (Naturals.two_mul _).symm
      _ ≤ 24 - (x - h) := hd
  exact Nat.le_trans (Nat.add_le_add_left hle (x - h)) (Nat.le_of_eq (Naturals.add_sub_of_le he))

def sgSimX : SubstrateLaxSim G_sg sgEnvDraw sgJointAdm sgRX (fun x => x ()) id SlackDist.nat where
  EpochX := sgEpochX
  EpochQX := sgEpochQX
  epoch_step _ x a x' epX hstep := by
    obtain ⟨_, rfl⟩ := hstep
    exact sgSubStep_within_24 (x ()) (a.1 () + sgEnvDraw a.2 ()) epX
  epoch_proj _ _ epX := epX
  gain rX rH := (rX + rH + 1) / 2
  gain_mono hX hH := div_mono_nat (Nat.add_le_add_right (Nat.add_le_add hX hH) 1) 2
  ε := 0
  β rX rH := rX + rH + 24
  β_mono hX hH := Nat.add_le_add_right (Nat.add_le_add hX hH) 24
  β_ge_left rX rH := Nat.le_trans (Nat.le_add_right rX rH) (Nat.le_add_right _ 24)
  η := 0
  sim_block k x qX hQ rX rH wX x' epX epQX dX hwX hlen trX := by
    have hw1 : wX.length = 1 := hlen.trans (succ_sub_self k)
    cases wX with
    | nil => exact absurd hw1.symm (Naturals.succ_ne_zero 0)
    | cons a rest =>
      cases rest with
      | cons _ _ => exact absurd (Nat.succ.inj hw1) (Naturals.succ_ne_zero _)
      | nil =>
        cases trX with
        | cons hstep htr =>
          cases htr with
          | nil =>
            obtain ⟨_, rfl⟩ := hstep
            have hH := hwX a (ListTests.mem_cons_iff.mpr (Or.inl rfl)) ()
            have hde : distNat (x () - (a.1 () + sgEnvDraw a.2 ())) (qX - hQ ()) ≤ rX + rH := by
              show distNat (x () - (a.1 () + 0)) (qX - hQ ()) ≤ rX + rH
              exact Nat.le_trans (distNat_sub_le (x ()) qX (a.1 ()) (hQ ())) (Nat.add_le_add dX hH)
            have hl := half_const_step_lip (x () - (a.1 () + 0)) (qX - hQ ())
              (Nat.le_trans (Nat.sub_le _ _) epX) (Nat.le_trans (Nat.sub_le _ _) epQX)
            have hdRes : distNat (sgSubStep x (fun j => a.1 j + sgEnvDraw a.2 j) ())
                (sgSubStep (fun _ => qX) hQ ()) ≤ (rX + rH + 1) / 2 + 0 :=
              Nat.le_trans hl (Nat.le_trans (div_mono_nat (Nat.add_le_add_right hde 1) 2) (Nat.le_refl _))
            have heqQ' : sgEpochQX (k + 1) (sgSubStep (fun _ => qX) hQ ()) :=
              sgSubStep_within_24 qX (hQ ()) epQX
            exact ⟨(), sgSubStep (fun _ => qX) hQ (), rfl, heqQ', hdRes⟩
  step_excursion k x qX _ rX rH _ h env x' epX epQX _ _ hstep := by
    obtain ⟨_, rfl⟩ := hstep
    have hq24 : qX ≤ 24 := epQX
    have h24 : sgSubStep x (fun k => h k + sgEnvDraw env k) () ≤ 24 :=
      sgSubStep_within_24 (x ()) (h () + 0) epX
    show distNat (sgSubStep x (fun k => h k + sgEnvDraw env k) ()) qX ≤ rX + rH + 24 + 0
    exact Nat.le_trans (distNat_le_of_le h24 hq24)
      (Nat.le_trans (Nat.le_add_left 24 (rX + rH)) (Nat.le_add_right _ 0))

def sgSimComp (init : Nat × Bool) (hInit : 6 ≤ init.1 ∧ init.1 ≤ 14) :
    OpenSubLaxSim compGood (compGoodContract init hInit).tol sgObs sgRComp Prod.fst sgDrawQ
      id SlackDist.nat SlackDist.nat (fun x => x ()) sgEpochX sgEpochQX where
  Epoch _ st := 6 ≤ st.1 ∧ st.1 ≤ 14
  EpochQ := sgEpochQ
  epoch_step _ st a s' ep _ hstep := by
    obtain ⟨_, rfl⟩ := hstep
    have hb := clamp16_24_bounds (sgObs a.1)
    have h1 : 8 ≤ clamp16_24 (sgObs a.1) / 2 := div_mono_nat hb.1 2
    have h2 : clamp16_24 (sgObs a.1) / 2 ≤ 12 := div_mono_nat hb.2 2
    have hge : 6 ≤ 5 + (st.1 + clamp16_24 (sgObs a.1) / 2) / 4 := by
      have h14 : 14 ≤ st.1 + clamp16_24 (sgObs a.1) / 2 := Nat.add_le_add ep.1 h1
      have h3 : 3 ≤ (st.1 + clamp16_24 (sgObs a.1) / 2) / 4 := div_mono_nat h14 4
      exact Nat.le_trans (by decide : 6 ≤ 5 + 3) (Nat.add_le_add_left h3 5)
    have hle : 5 + (st.1 + clamp16_24 (sgObs a.1) / 2) / 4 ≤ 14 := by
      have h26 : st.1 + clamp16_24 (sgObs a.1) / 2 ≤ 26 := Nat.add_le_add ep.2 h2
      have h6 : (st.1 + clamp16_24 (sgObs a.1) / 2) / 4 ≤ 6 := div_mono_nat h26 4
      exact Nat.le_trans (Nat.add_le_add_left h6 5) (by decide : 5 + 6 ≤ 14)
    exact ⟨hge, hle⟩
  epoch_proj _ _ ep := ep
  gain r rX := (r + (rX + 1) / 2 + 3) / 4
  gain_mono hr hrX :=
    div_mono_nat
      (Nat.add_le_add_right
        (Nat.add_le_add hr (div_mono_nat (Nat.add_le_add_right hrX 1) 2)) 3) 4
  ε := 0
  β r rX := r + rX + 14
  β_mono hr hrX := Nat.add_le_add_right (Nat.add_le_add hr hrX) 14
  β_ge_left r rX := Nat.le_trans (Nat.le_add_right r rX) (Nat.le_add_right _ 14)
  η := 0
  drawMod r := (r + 3) / 4 + 1
  drawMod_mono hr := Nat.add_le_add_right (div_mono_nat (Nat.add_le_add_right hr 3) 4) 1
  draw_lip _ st q r k _ hdist := by
    cases k
    show distNat (st.1 / 4 + (if st.2 then 1 else 0)) (q / 4) ≤ (r + 3) / 4 + 1
    have hdiv : distNat (st.1 / 4) (q / 4) ≤ (distNat st.1 q + 3) / 4 :=
      distNat_div_le st.1 q 4
    have hdm : distNat (st.1 / 4) (q / 4) ≤ (r + 3) / 4 :=
      Nat.le_trans hdiv (div_mono_nat (Nat.add_le_add_right hdist 3) 4)
    cases st.2 with
    | false => exact Nat.le_trans hdm (Nat.le_add_right _ 1)
    | true =>
      have htri : distNat (st.1 / 4 + 1) (q / 4) ≤ distNat (st.1 / 4) (q / 4) + 1 :=
        distNat_add_one (st.1 / 4) (q / 4)
      exact Nat.le_trans htri (Nat.add_le_add_right hdm 1)
  sim_block k st q qX r rX w s' _ epQ epQX d_le hw hlen tr := by
    have hw1 : w.length = 1 := hlen.trans (succ_sub_self k)
    cases w with
    | nil => exact absurd hw1.symm (Naturals.succ_ne_zero 0)
    | cons a rest =>
      cases rest with
      | cons _ _ => exact absurd (Nat.succ.inj hw1) (Naturals.succ_ne_zero _)
      | nil =>
        cases tr with
        | cons hstep htr =>
          cases htr with
          | nil =>
            obtain ⟨_, rfl⟩ := hstep
            have haX := (hw a (ListTests.mem_cons_iff.mpr (Or.inl rfl))).2
            have hcl : distNat (clamp16_24 (a.1 ())) (clamp16_24 qX) ≤ rX :=
              Nat.le_trans (clamp16_24_lip _ _) haX
            have hhalf : distNat (clamp16_24 (a.1 ()) / 2) (clamp16_24 qX / 2) ≤ (rX + 1) / 2 :=
              Nat.le_trans (distNat_div_le _ _ 2) (div_mono_nat (Nat.add_le_add_right hcl 1) 2)
            have hsum : distNat (st.1 + clamp16_24 (a.1 ()) / 2) (q + clamp16_24 qX / 2) ≤
                r + (rX + 1) / 2 :=
              Nat.le_trans (distNat_add_le _ _ _ _) (Nat.add_le_add d_le hhalf)
            have hq4 : distNat (5 + (st.1 + clamp16_24 (a.1 ()) / 2) / 4)
                (5 + (q + clamp16_24 qX / 2) / 4) ≤ (r + (rX + 1) / 2 + 3) / 4 + 0 := by
              rw [distNat_const_add]
              exact Nat.le_trans (distNat_div_le _ _ 4)
                (div_mono_nat (Nat.add_le_add_right hsum 3) 4)
            have hb := clamp16_24_bounds qX
            have hd1 : 8 ≤ clamp16_24 qX / 2 := div_mono_nat hb.1 2
            have hd2 : clamp16_24 qX / 2 ≤ 12 := div_mono_nat hb.2 2
            have hQ' : sgEpochQ (k + 1) (5 + (q + clamp16_24 qX / 2) / 4) := by
              refine ⟨?_, ?_⟩
              · have h14 : 14 ≤ q + clamp16_24 qX / 2 := Nat.add_le_add epQ.1 hd1
                have h3 : 3 ≤ (q + clamp16_24 qX / 2) / 4 := div_mono_nat h14 4
                exact Nat.le_trans (by decide : 6 ≤ 5 + 3) (Nat.add_le_add_left h3 5)
              · have h26 : q + clamp16_24 qX / 2 ≤ 26 := Nat.add_le_add epQ.2 hd2
                have h6 : (q + clamp16_24 qX / 2) / 4 ≤ 6 := div_mono_nat h26 4
                exact Nat.le_trans (Nat.add_le_add_left h6 5) (by decide : 5 + 6 ≤ 14)
            exact ⟨(), 5 + (q + clamp16_24 qX / 2) / 4, rfl, hQ', hq4⟩
  step_excursion k st q qX r rX _ xSub al d s' ep _ epQ _ _ _ hstep := by
    obtain ⟨_, rfl⟩ := hstep
    have hb := clamp16_24_bounds (sgObs xSub)
    have h2 : clamp16_24 (sgObs xSub) / 2 ≤ 12 := div_mono_nat hb.2 2
    have hle' : 5 + (st.1 + clamp16_24 (sgObs xSub) / 2) / 4 ≤ 14 := by
      have h26 : st.1 + clamp16_24 (sgObs xSub) / 2 ≤ 26 := Nat.add_le_add ep.2 h2
      have h6 : (st.1 + clamp16_24 (sgObs xSub) / 2) / 4 ≤ 6 := div_mono_nat h26 4
      exact Nat.le_trans (Nat.add_le_add_left h6 5) (by decide : 5 + 6 ≤ 14)
    show distNat (5 + (st.1 + clamp16_24 (sgObs xSub) / 2) / 4) q ≤ r + rX + 14 + 0
    exact Nat.le_trans (distNat_le_of_le hle' epQ.2)
      (Nat.le_trans (Nat.le_add_left 14 (r + rX)) (Nat.le_add_right _ 0))

def sgGuardQ (q : Nat × (Nat × Nat)) : Prop := q = (20, (10, 10))
def sgKQ (q : Nat × (Nat × Nat)) : Prop := q = (20, (10, 10))

def sgMacroCert :
    Viability.Certificate (coupledMacroProcess sgRX sgRComp sgRComp sgDrawQ sgDrawQ)
      sgGuardQ sgKQ where
  within _ hK := hK
  closed q b q' step hK := by
    subst hK
    obtain ⟨hqX, hqA, hqB⟩ := step
    change q'.1 = sgSubStep (fun _ => 20) (fun () => sgDrawQ 10 () + sgDrawQ 10 ()) () at hqX
    change q'.2.1 = 5 + (10 + clamp16_24 20 / 2) / 4 at hqA
    change q'.2.2 = 5 + (10 + clamp16_24 20 / 2) / 4 at hqB
    have eqX : q'.1 = 20 := hqX.trans (by decide)
    have eqA : q'.2.1 = 10 := hqA.trans (by decide)
    have eqB : q'.2.2 = 10 := hqB.trans (by decide)
    cases q' with | mk x ab =>
    cases ab with | mk a b =>
    change x = 20 at eqX
    change a = 10 at eqA
    change b = 10 at eqB
    subst eqX eqA eqB
    rfl

def sgGoodInitA : Nat × Bool := (10, false)
def sgGoodInitB : Nat × Bool := (10, false)
def sgGoodX0 : Unit → Nat := fun _ => 20

def sgComposedGood :=
  OpenComposition.closedProcess
    (OpenComposition.OpenComponent.compose compGood compGood)
    (OpenComposition.composeContract
      (compGoodContract sgGoodInitA ⟨by decide, by decide⟩)
      (compGoodContract sgGoodInitB ⟨by decide, by decide⟩))
    (fun x => (sgObs x, sgObs x)) sgChannel G_sg sgEnvDraw sgJointAdm

theorem no_reduced_law_coupled :
    let stepFn := fun st : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool)) =>
      OpenComposition.closedStep
        (OpenComposition.OpenComponent.compose compGood compGood)
        (fun x => (sgObs x, sgObs x)) sgChannel G_sg sgEnvDraw st ((), ((), ()))
    let π := fun st : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool)) =>
      (st.1 (), (st.2.1.1, st.2.2.1))
    let st₁ : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool)) :=
      (fun _ => 20, ((10, false), (10, false)))
    let st₂ : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool)) :=
      (fun _ => 20, ((10, true), (10, true)))
    π st₁ = π st₂ ∧
    (π (stepFn st₁)).1 = 20 ∧
    (π (stepFn st₂)).1 = 19 ∧
    (π (stepFn st₁)).1 ≠ (π (stepFn st₂)).1 ∧
    ¬ ∃ reduced : (Nat × (Nat × Nat)) → (Nat × (Nat × Nat)),
      ∀ st, π (stepFn st) = reduced (π st) := by
  refine ⟨rfl, rfl, rfl, by decide, ?_⟩
  intro ⟨reduced, hcomm⟩
  have h1 := hcomm (fun _ => 20, ((10, false), (10, false)))
  have h2 := hcomm (fun _ => 20, ((10, true), (10, true)))
  have heq : (20, (10, 10)) = ((fun st : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool)) =>
      (st.1 (), (st.2.1.1, st.2.2.1)))
    (OpenComposition.closedStep (OpenComposition.OpenComponent.compose compGood compGood)
      (fun x => (sgObs x, sgObs x)) sgChannel G_sg sgEnvDraw
      (fun _ => 20, ((10, false), (10, false))) ((), ((), ())))) := rfl
  have hdiff : (20 : Nat) = 19 := by
    have : (fun st : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool)) =>
        (st.1 (), (st.2.1.1, st.2.2.1)))
      (OpenComposition.closedStep (OpenComposition.OpenComponent.compose compGood compGood)
        (fun x => (sgObs x, sgObs x)) sgChannel G_sg sgEnvDraw
        (fun _ => 20, ((10, false), (10, false))) ((), ((), ()))) =
      (fun st : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool)) =>
        (st.1 (), (st.2.1.1, st.2.2.1)))
      (OpenComposition.closedStep (OpenComposition.OpenComponent.compose compGood compGood)
        (fun x => (sgObs x, sgObs x)) sgChannel G_sg sgEnvDraw
        (fun _ => 20, ((10, true), (10, true))) ((), ((), ()))) :=
      h1.trans h2.symm
    exact congrArg Prod.fst this
  exact absurd hdiff (by decide)

theorem nonzero_bidirectional_coupling :
    (compGood.next (10, false) (16, false) ()).1 = 9 ∧
    (compGood.next (10, false) (24, false) ()).1 = 10 ∧
    (compGood.next (10, false) (16, false) ()).1 ≠
      (compGood.next (10, false) (24, false) ()).1 ∧
    compGood.drawExt (6, false) () = 1 ∧
    compGood.drawExt (14, false) () = 3 ∧
    compGood.drawExt (6, false) () ≠ compGood.drawExt (14, false) () :=
  ⟨rfl, rfl, by decide, rfl, rfl, by decide⟩

theorem coupled_small_gain_viable :
    Viability.Kernel sgComposedGood
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose compGood compGood)
        (OpenComposition.composeContract
          (compGoodContract sgGoodInitA ⟨by decide, by decide⟩)
          (compGoodContract sgGoodInitB ⟨by decide, by decide⟩))
        (fun _ => 16))
      (sgGoodX0, (sgGoodInitA, sgGoodInitB)) ∧
    Viability.Kernel sgComposedGood
      (fun st => 16 ≤ st.1 () ∧ 6 ≤ st.2.1.1 ∧ 6 ≤ st.2.2.1)
      (sgGoodX0, (sgGoodInitA, sgGoodInitB)) := by
  let cA := compGoodContract sgGoodInitA ⟨by decide, by decide⟩
  let cB := compGoodContract sgGoodInitB ⟨by decide, by decide⟩
  let simA := sgSimComp sgGoodInitA ⟨by decide, by decide⟩
  let simB := sgSimComp sgGoodInitB ⟨by decide, by decide⟩
  let strictId : Strict id := fun _ => Nat.lt_succ_self _
  have strideLe : ∀ k, id (k + 1) - id k ≤ 1 := fun k => Nat.le_of_eq (succ_sub_self k)
  let sim := coupled_closed_laxSim strictId 1 strideLe cA sgObs cB sgObs
    sgChannel sgSimX simA simB
  have habsorb : sim.α 4 + sim.ε ≤ 4 := by
    dsimp only [sim, coupled_closed_laxSim, coupledBlockGain, iterStepGain,
      sgSimX, sgSimComp, CoreHelpers.natMax]
    decide
  have hmargin : ∀ q (u : (Unit → Nat) × ((Nat × Bool) × (Nat × Bool))), sgGuardQ q →
      (OpenComposition.SlackDist.max SlackDist.nat
        (OpenComposition.SlackDist.max SlackDist.nat SlackDist.nat)).d
        (u.1 (), (u.2.1.1, u.2.2.1)) q ≤ sim.β 4 + sim.η →
      16 ≤ u.1 () ∧ 6 ≤ u.2.1.1 ∧ 6 ≤ u.2.2.1 := by
    intro q u hq d_le
    subst hq
    have hdX : distNat (u.1 ()) 20 ≤ 4 :=
      Nat.le_trans (CoreHelpers.le_natMax_left _ _) d_le
    have hdA : distNat u.2.1.1 10 ≤ 4 :=
      Nat.le_trans (CoreHelpers.le_natMax_left _ _)
        (Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le)
    have hdB : distNat u.2.2.1 10 ≤ 4 :=
      Nat.le_trans (CoreHelpers.le_natMax_right _ _)
        (Nat.le_trans (CoreHelpers.le_natMax_right _ _) d_le)
    exact ⟨le_sub_of_distNat_le (by decide : 4 ≤ 20) hdX,
      le_sub_of_distNat_le (by decide : 4 ≤ 10) hdA,
      le_sub_of_distNat_le (by decide : 4 ≤ 10) hdB⟩
  have hEpX0 : sgSimX.EpochX (id 0) sgGoodX0 := by
    show sgGoodX0 () ≤ 24
    decide
  have hKern1 : Viability.Kernel sgComposedGood
      (OpenComposition.closedGuard
        (OpenComposition.OpenComponent.compose compGood compGood)
        (OpenComposition.composeContract cA cB)
        (fun _ => 16))
      (sgGoodX0, (sgGoodInitA, sgGoodInitB)) :=
    coupled_closed_lax_kernel strictId 1 strideLe cA sgObs cB sgObs
      sgChannel sgSimX simA simB sgMacroCert (fun _ => 16) 4 habsorb
      (fun q u hq hd () => (hmargin q u hq hd).1)
      hEpX0 ⟨by decide, by decide⟩ ⟨by decide, by decide⟩ rfl
  have hKern2 : Viability.Kernel sgComposedGood
      (fun st => 16 ≤ st.1 () ∧ 6 ≤ st.2.1.1 ∧ 6 ≤ st.2.2.1)
      (sgGoodX0, (sgGoodInitA, sgGoodInitB)) :=
    lax_kernel_of_certificate sim sgMacroCert 4 habsorb hmargin
      ⟨hEpX0, ⟨by decide, by decide⟩, ⟨by decide, by decide⟩,
       ⟨by decide, by decide⟩, ⟨by decide, by decide⟩⟩ rfl
  exact ⟨hKern1, hKern2⟩

def compBad : OpenComposition.OpenComponent (Nat × Bool) Nat Unit Empty Unit where
  next st oa _ := (5 + (st.1 + clamp16_24 oa.1 / 2) / 4, !st.2)
  drawInt _ e := Empty.elim e
  drawExt st _ := st.1 / 2 + 1
  emitAlarm _ _ := false
  silenceLoad _ := 0
  favours _ := False

def soloBadProcess : Process ((Unit → Nat) × (Nat × Bool)) Unit where
  step st _ st' :=
    st' = OpenComposition.closedStep compBad sgObs sgChannel G_sg sgEnvDraw st ((), ())

def soloBadOrbit : Nat → (Unit → Nat) × (Nat × Bool)
  | 0 => (sgGoodX0, sgGoodInitA)
  | t + 1 => OpenComposition.closedStep compBad sgObs sgChannel G_sg sgEnvDraw (soloBadOrbit t) ((), ())

def coupledBadProcess : Process ((Unit → Nat) × ((Nat × Bool) × (Nat × Bool))) Unit where
  step st _ st' :=
    st' = OpenComposition.closedStep
      (OpenComposition.OpenComponent.compose compBad compBad)
      (fun x => (sgObs x, sgObs x)) sgChannel G_sg sgEnvDraw st ((), ((), ()))

def coupledBadOrbit : Nat → (Unit → Nat) × ((Nat × Bool) × (Nat × Bool))
  | 0 => (sgGoodX0, (sgGoodInitA, sgGoodInitB))
  | t + 1 =>
    OpenComposition.closedStep
      (OpenComposition.OpenComponent.compose compBad compBad)
      (fun x => (sgObs x, sgObs x)) sgChannel G_sg sgEnvDraw (coupledBadOrbit t) ((), ((), ()))

theorem small_gain_violation_contrast :
    -- 1. Solo A_bad settles at x = 18, u = 9 forever (>= 16) -> Kernel holds
    ((soloBadOrbit 0).1 () = 20 ∧ (soloBadOrbit 1).1 () = 19 ∧
     (soloBadOrbit 2).1 () = 18 ∧ (soloBadOrbit 2).2.1 = 9 ∧
     (∀ t, (soloBadOrbit (t + 2)).1 () = 18 ∧ (soloBadOrbit (t + 2)).2.1 = 9) ∧
     Viability.Kernel soloBadProcess (fun st => 16 ≤ st.1 ()) (soloBadOrbit 0)) ∧
    -- 2. Coupled A_bad + B_bad hits x_2 = 14 < 16 at step 2 -> no Kernel
    ((coupledBadOrbit 0).1 () = 20 ∧ (coupledBadOrbit 1).1 () = 16 ∧
     (coupledBadOrbit 2).1 () = 14 ∧
     ¬ Viability.Kernel coupledBadProcess (fun st => 16 ≤ st.1 ()) (coupledBadOrbit 0)) ∧
    -- 3. Small-gain fails for all Delta under tight drawMod r := r / 2 + 4
    (∀ Δ : Nat, ¬ (sgSimX.gain Δ ((Δ / 2 + 4) + (Δ / 2 + 4)) + sgSimX.ε ≤ Δ)) ∧
    -- 4. Small-gain fails for all Delta <= 4 for ANY valid drawMod on A_bad
    (∀ (drawMod : Nat → Nat),
      (∀ {r₁ r₂}, r₁ ≤ r₂ → drawMod r₁ ≤ drawMod r₂) →
      (∀ s q r, distNat s.1 q ≤ r → distNat (compBad.drawExt s ()) (sgDrawQ q ()) ≤ drawMod r) →
      ∀ Δ : Nat, Δ ≤ 4 → ¬ (sgSimX.gain Δ (drawMod Δ + drawMod Δ) + sgSimX.ε ≤ Δ)) := by
  have hSoloSettle : ∀ t, (soloBadOrbit (t + 2)).1 () = 18 ∧
      (soloBadOrbit (t + 2)).2.1 = 9 := by
    intro t
    induction t with
    | zero => exact ⟨rfl, rfl⟩
    | succ t ih =>
      have hx := ih.1
      have hu := ih.2
      cases hst : soloBadOrbit (t + 2) with | mk x uph =>
      cases huph : uph with | mk u ph =>
      rw [hst, huph] at hx hu
      have hstep : soloBadOrbit ((t + 1) + 2) =
          OpenComposition.closedStep compBad sgObs sgChannel G_sg sgEnvDraw
            (soloBadOrbit (t + 2)) ((), ()) := rfl
      rw [hstep, hst, huph]
      have hx' : x () = 18 := hx
      have hu' : u = 9 := hu
      subst hu'
      dsimp [OpenComposition.closedStep, OpenComposition.closedStepWith, compBad, sgObs, sgEnvDraw,
        G_sg, sgChannel, RegimeMargin.Coupled.Indexed.step, RegimeMargin.Drawn.whole,
        RegimeMargin.Coupled.Indexed.left]
      rw [hx']
      cases ph <;> refine ⟨by decide, by decide⟩
  have hSoloSafe : ∀ t, 16 ≤ (soloBadOrbit t).1 () := by
    intro t
    cases t with
    | zero => exact by decide
    | succ t =>
      cases t with
      | zero => exact by decide
      | succ t =>
        rw [(hSoloSettle t).1]
        exact by decide
  have hSoloKern : Viability.Kernel soloBadProcess (fun st => 16 ≤ st.1 ()) (soloBadOrbit 0) := by
    intro st ⟨w, tr⟩
    have hrun : ∀ (w : List Unit) (t : Nat) (u : (Unit → Nat) × (Nat × Bool)),
        Trace soloBadProcess (soloBadOrbit t) w u → u = soloBadOrbit (t + w.length) := by
      intro w
      induction w with
      | nil =>
        intro t u tr
        cases tr
        rfl
      | cons _ w ih =>
        intro t u tr
        cases tr with
        | cons hstep htr =>
          subst hstep
          have h := ih (t + 1) u htr
          rw [Nat.add_right_comm t 1 w.length] at h
          exact h
    rw [hrun w 0 st tr]
    exact hSoloSafe (0 + w.length)
  have hBadCrash : ¬ Viability.Kernel coupledBadProcess (fun st => 16 ≤ st.1 ())
      (coupledBadOrbit 0) := by
    intro hKern
    have htr : Trace coupledBadProcess (coupledBadOrbit 0) [(), ()] (coupledBadOrbit 2) :=
      .cons rfl (.cons rfl (.nil _))
    have hge := hKern (coupledBadOrbit 2) ⟨[(), ()], htr⟩
    have h14 : (coupledBadOrbit 2).1 () = 14 := rfl
    dsimp at hge
    rw [h14] at hge
    exact absurd hge (by decide)
  have hTightFail : ∀ Δ : Nat, ¬ (sgSimX.gain Δ ((Δ / 2 + 4) + (Δ / 2 + 4)) + sgSimX.ε ≤ Δ) := by
    intro Δ hle
    change (Δ + (Δ / 2 + 4 + (Δ / 2 + 4)) + 1) / 2 + 0 ≤ Δ at hle
    obtain ⟨hrem1, hmod1⟩ := CoreHelpers.div_mod_decomp (by decide : 0 < 2) Δ
    have hΔ_ub : Δ ≤ (Δ / 2 + Δ / 2) + 1 := by
      have hm1 : Δ % 2 ≤ 1 := Nat.le_of_lt_succ hmod1
      calc Δ = Δ / 2 * 2 + Δ % 2 := hrem1
        _ = 2 * (Δ / 2) + Δ % 2 := congrArg (· + Δ % 2) (two_mul_eq_mul_two (Δ / 2)).symm
        _ = (Δ / 2 + Δ / 2) + Δ % 2 := congrArg (· + Δ % 2) (Naturals.two_mul (Δ / 2))
        _ ≤ (Δ / 2 + Δ / 2) + 1 := Nat.add_le_add_left hm1 _
    have hlow : (Δ + 1) * 2 ≤ Δ + (Δ / 2 + 4 + (Δ / 2 + 4)) + 1 := by
      calc (Δ + 1) * 2 = 2 * (Δ + 1) := (two_mul_eq_mul_two (Δ + 1)).symm
        _ = (Δ + 1) + (Δ + 1) := Naturals.two_mul (Δ + 1)
        _ = Δ + (Δ + 2) := Nat.add_assoc Δ 1 (Δ + 1) ▸ congrArg (Δ + ·) (Nat.add_comm 1 (Δ + 1)) ▸ rfl
        _ ≤ Δ + (Δ + 8) := Nat.add_le_add_left (Nat.add_le_add_left (by decide : 2 ≤ 8) Δ) Δ
        _ ≤ Δ + ((Δ / 2 + Δ / 2) + 1 + 8) :=
            Nat.add_le_add_left (Nat.add_le_add_right hΔ_ub 8) Δ
        _ = Δ + (Δ / 2 + 4 + (Δ / 2 + 4)) + 1 := by
            have heq : ((Δ / 2 + Δ / 2) + 1 + 8) = (Δ / 2 + 4 + (Δ / 2 + 4)) + 1 := by
              calc (Δ / 2 + Δ / 2) + 1 + 8 = (Δ / 2 + Δ / 2) + (4 + 4) + 1 :=
                    Nat.add_right_comm (Δ / 2 + Δ / 2) 1 8
                _ = (Δ / 2 + 4 + (Δ / 2 + 4)) + 1 :=
                    congrArg (· + 1) (Nat.add_add_add_comm (Δ / 2) (Δ / 2) 4 4)
            rw [heq]
            exact (Nat.add_assoc Δ _ 1).symm
    have hdiv_ge : Δ + 1 ≤ (Δ + (Δ / 2 + 4 + (Δ / 2 + 4)) + 1) / 2 + 0 :=
      Nat.le_trans
        (Nat.le_of_eq (CoreHelpers.div_mul_add_rem (by decide : 0 < 2) (by decide : 0 < 2) (Δ + 1)).symm)
        (div_mono_nat hlow 2)
    exact Nat.lt_irrefl Δ (Nat.le_trans hdiv_ge hle)
  have hAnyFail : ∀ (drawMod : Nat → Nat),
      (∀ {r₁ r₂}, r₁ ≤ r₂ → drawMod r₁ ≤ drawMod r₂) →
      (∀ s q r, distNat s.1 q ≤ r → distNat (compBad.drawExt s ()) (sgDrawQ q ()) ≤ drawMod r) →
      ∀ Δ : Nat, Δ ≤ 4 → ¬ (sgSimX.gain Δ (drawMod Δ + drawMod Δ) + sgSimX.ε ≤ Δ) := by
    intro drawMod mono lip Δ hΔ hle
    have h4 : 4 ≤ drawMod 0 :=
      lip (10, false) 10 0 (Nat.le_of_eq (distNat_self 10))
    have hD : 4 ≤ drawMod Δ := Nat.le_trans h4 (mono (Nat.zero_le Δ))
    change (Δ + (drawMod Δ + drawMod Δ) + 1) / 2 + 0 ≤ Δ at hle
    have hlow : (Δ + 1) * 2 ≤ Δ + (drawMod Δ + drawMod Δ) + 1 := by
      have h8 : Δ + 1 ≤ drawMod Δ + drawMod Δ :=
        Nat.le_trans (Nat.add_le_add_right hΔ 1)
          (Nat.le_trans (by decide : 4 + 1 ≤ 4 + 4) (Nat.add_le_add hD hD))
      calc (Δ + 1) * 2 = 2 * (Δ + 1) := (two_mul_eq_mul_two (Δ + 1)).symm
        _ = (Δ + 1) + (Δ + 1) := Naturals.two_mul (Δ + 1)
        _ = Δ + (Δ + 1) + 1 := Nat.add_right_comm Δ 1 (Δ + 1)
        _ ≤ Δ + (drawMod Δ + drawMod Δ) + 1 :=
            Nat.add_le_add_right (Nat.add_le_add_left h8 Δ) 1
    have hdiv_ge : Δ + 1 ≤ (Δ + (drawMod Δ + drawMod Δ) + 1) / 2 + 0 :=
      Nat.le_trans
        (Nat.le_of_eq (CoreHelpers.div_mul_add_rem (by decide : 0 < 2) (by decide : 0 < 2) (Δ + 1)).symm)
        (div_mono_nat hlow 2)
    exact Nat.lt_irrefl Δ (Nat.le_trans hdiv_ge hle)
  exact ⟨⟨rfl, rfl, rfl, rfl, hSoloSettle, hSoloKern⟩,
    ⟨rfl, rfl, rfl, hBadCrash⟩, hTightFail, hAnyFail⟩

end CoupledSmallGainWitness

end Becoming.PolyComposition

