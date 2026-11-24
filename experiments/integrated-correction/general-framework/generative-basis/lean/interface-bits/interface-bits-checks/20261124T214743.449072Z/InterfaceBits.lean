import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic
import Becoming.RelSpan

/-!
# Interface Bits, Confusability Strong Powers, & `C₂` Fiber Clique (`InterfaceBits`)

AI-written (Wave 4 Track B4, 25 November 2026). Mathlib v4.30.0-rc2 periphery module importing
`Becoming.RelSpan`. Standard axioms `[propext, Classical.choice, Quot.sound]`, zero `sorryAx`,
zero `private`/`lemma`/`class`/unnamed `instance`, zero `native_decide`, zero `n = 3, 4` search.
-/

namespace Becoming.InterfaceBits

open scoped BigOperators
open Becoming.OplaxHistory Becoming.OplaxHistory.C2RelativeLossWitness

structure Conf (V : Type*) where
  R : V → V → Prop
  refl : ∀ x, R x x
  symm : ∀ {x y}, R x y → R y x

def confOfRaw {V : Type*} (raw : V → V → Prop) (hs : ∀ {x y}, raw x y → raw y x) : Conf V :=
  ⟨fun x y => x = y ∨ raw x y, fun _ => Or.inl rfl, fun h => h.elim (Or.inl ∘ Eq.symm) (Or.inr ∘ hs)⟩
def strongProd {U V : Type*} (G : Conf U) (H : Conf V) : Conf (U × V) :=
  ⟨fun p q => G.R p.1 q.1 ∧ H.R p.2 q.2, fun p => ⟨G.refl p.1, H.refl p.2⟩, fun h => ⟨G.symm h.1, H.symm h.2⟩⟩
def strongPow {V : Type*} (G : Conf V) (n : ℕ) : Conf (Fin n → V) :=
  ⟨fun x y => ∀ i, G.R (x i) (y i), fun x i => G.refl (x i), fun h i => G.symm (h i)⟩

def IsIndepSet {V : Type*} (G : Conf V) (A : Finset V) : Prop := ∀ x ∈ A, ∀ y ∈ A, G.R x y → x = y
def IsClique {V : Type*} (G : Conf V) (A : Finset V) : Prop := ∀ x ∈ A, ∀ y ∈ A, G.R x y
def IsColoring {V : Type*} (G : Conf V) {k : ℕ} (c : V → Fin k) : Prop := ∀ x y, c x = c y → G.R x y → x = y
def IsCC2Partition {V : Type*} (G : Conf V) {k : ℕ} (c : V → Fin k) : Prop :=
  ∀ x y z, c y = c x → c z = c x → y ≠ x → z ≠ x → G.R x y → G.R x z → y = z
def IsK3FreePartition {V : Type*} (G : Conf V) {k : ℕ} (c : V → Fin k) : Prop :=
  ∀ x y z, c y = c x → c z = c x → G.R x y → G.R x z → G.R y z → x = y ∨ x = z ∨ y = z

def K2 : Conf Bool := ⟨fun _ _ => True, fun _ => trivial, fun _ => trivial⟩
def c7Adj (x y : Fin 7) : Bool := x == y || x + 1 == y || y + 1 == x
def C7 : Conf (Fin 7) := ⟨fun x y => c7Adj x y = true, fun x => by simp [c7Adj], by decide⟩
instance instDecC7R : DecidableRel C7.R := fun x y => inferInstanceAs (Decidable (c7Adj x y = true))
instance instDecProdR {U V : Type*} (G : Conf U) (H : Conf V) [DecidableRel G.R] [DecidableRel H.R] :
    DecidableRel (strongProd G H).R := fun p q => inferInstanceAs (Decidable (G.R p.1 q.1 ∧ H.R p.2 q.2))

def c7Diffs : Fin 3 → Fin 7 := ![0, 1, 6]
def c7BitVal : Fin 2 → Fin 7 := fun b => if b = 0 then 0 else 1
def c7Indep : Finset (Fin 7) := {0, 2, 4}
def c7Color : Fin 7 → Fin 3 := ![0, 1, 0, 1, 0, 1, 2]
def c7CC2 : Fin 7 → Fin 2 := ![0, 0, 1, 0, 0, 1, 1]
def c7SqPts : List (Fin 7 × Fin 7) := [(0,0),(0,2),(1,4),(2,0),(2,2),(3,4),(4,1),(4,6),(5,3),(6,5)]
def c7SqColorVec : Fin 7 → Fin 7 → Fin 5 :=
  ![![0,1,0,1,2,3,4],![2,3,2,3,4,0,1],![4,0,1,0,1,2,3],![1,2,3,2,3,4,0],![3,4,0,4,0,1,2],![0,1,2,1,2,3,4],![2,3,4,3,4,0,1]]
def c7SqCC2Vec : Fin 7 → Fin 7 → Fin 4 :=
  ![![0,0,1,0,1,0,1],![1,2,2,0,2,0,2],![0,0,1,1,2,1,2],![1,2,2,0,0,1,3],![1,0,1,1,2,2,0],![3,0,2,0,0,1,0],![2,1,2,3,2,3,2]]

theorem c7_iff_diff (x y : Fin 7) : C7.R x y ↔ ∃ d : Fin 3, y = x + c7Diffs d := by decide +revert
theorem c7_step (v : Fin 7) : C7.R v (v + 1) := by decide +revert
theorem c7BitVal_inj : Function.Injective c7BitVal := by decide
theorem c7BitVal_adj (a : Fin 7) (x y : Fin 2) : C7.R (a + c7BitVal x) (a + c7BitVal y) := by decide +revert
theorem c7Indep_ok : IsIndepSet C7 c7Indep := by unfold IsIndepSet; decide
theorem c7Color_ok : IsColoring C7 c7Color := by unfold IsColoring; decide
theorem c7CC2_ok : IsCC2Partition C7 c7CC2 := by unfold IsCC2Partition; decide
theorem c7_triangleFree (x y z : Fin 7) : C7.R x y → C7.R x z → C7.R y z → x = y ∨ x = z ∨ y = z := by decide +revert
theorem c7SqPts_nodup : c7SqPts.Nodup := by decide
theorem c7SqPts_ok : ∀ p ∈ c7SqPts, ∀ q ∈ c7SqPts, (strongProd C7 C7).R p q → p = q := by decide
theorem c7SqColor_offsets : ∀ i j : Fin 7, ∀ d₁ d₂ : Fin 3, (d₁, d₂) ≠ (0, 0) →
    c7SqColorVec i j ≠ c7SqColorVec (i + c7Diffs d₁) (j + c7Diffs d₂) := by decide
theorem c7SqCC2_offsets : ∀ i j : Fin 7, ∀ a₁ a₂ b₁ b₂ : Fin 3,
    (a₁, a₂) ≠ (0, 0) → (b₁, b₂) ≠ (0, 0) → (a₁, a₂) ≠ (b₁, b₂) →
    c7SqCC2Vec (i + c7Diffs a₁) (j + c7Diffs a₂) = c7SqCC2Vec i j →
    c7SqCC2Vec (i + c7Diffs b₁) (j + c7Diffs b₂) = c7SqCC2Vec i j → False := by decide

section GeneralAndCounts
open Classical

noncomputable def indepNum {V : Type*} [Fintype V] (G : Conf V) : ℕ :=
  ((Finset.univ : Finset V).powerset.filter (IsIndepSet G)).sup Finset.card
noncomputable def minColors {V : Type*} (P : ∀ k : ℕ, (V → Fin k) → Prop) : ℕ := sInf {k : ℕ | ∃ c : V → Fin k, P k c}
noncomputable abbrev chi {V : Type*} (G : Conf V) : ℕ := minColors (fun _ c => IsColoring G c)
noncomputable abbrev chiCC2 {V : Type*} (G : Conf V) : ℕ := minColors (fun _ c => IsCC2Partition G c)
noncomputable abbrev chiK3Free {V : Type*} (G : Conf V) : ℕ := minColors (fun _ c => IsK3FreePartition G c)

theorem le_indepNum {V : Type*} [Fintype V] {G : Conf V} {A : Finset V} (h : IsIndepSet G A) : A.card ≤ indepNum G :=
  Finset.le_sup (f := Finset.card) (Finset.mem_filter.mpr ⟨Finset.mem_powerset.mpr (Finset.subset_univ A), h⟩)
theorem indepNum_le {V : Type*} [Fintype V] {G : Conf V} {m : ℕ} (hm : ∀ A : Finset V, IsIndepSet G A → A.card ≤ m) :
    indepNum G ≤ m := Finset.sup_le fun A hA => hm A (Finset.mem_filter.mp hA).2
theorem exists_maxIndep {V : Type*} [Fintype V] (G : Conf V) : ∃ A : Finset V, IsIndepSet G A ∧ A.card = indepNum G := by
  have hne : ((Finset.univ : Finset V).powerset.filter (IsIndepSet G)).Nonempty :=
    ⟨∅, Finset.mem_filter.mpr ⟨Finset.mem_powerset.mpr (Finset.empty_subset _), fun _ hx => by simp at hx⟩⟩
  obtain ⟨A, hA, hmax⟩ := Finset.exists_mem_eq_sup _ hne Finset.card; exact ⟨A, (Finset.mem_filter.mp hA).2, hmax.symm⟩

theorem equivFin_isColoring {V : Type*} [Fintype V] (G : Conf V) : IsColoring G (Fintype.equivFin V) :=
  fun _ _ h _ => (Fintype.equivFin V).injective h
theorem coloring_isCC2 {V : Type*} {G : Conf V} {k : ℕ} {c : V → Fin k} (hc : IsColoring G c) : IsCC2Partition G c :=
  fun x y _ hy _ hyn _ hxy _ => False.elim (hyn (hc x y hy.symm hxy).symm)
theorem coloring_isK3Free {V : Type*} {G : Conf V} {k : ℕ} {c : V → Fin k} (hc : IsColoring G c) : IsK3FreePartition G c :=
  fun x y _ hy _ hxy _ _ => Or.inl (hc x y hy.symm hxy)

theorem chi_spec {V : Type*} [Fintype V] (G : Conf V) : ∃ c : V → Fin (chi G), IsColoring G c :=
  Nat.sInf_mem (s := {k | ∃ c : V → Fin k, IsColoring G c}) ⟨Fintype.card V, Fintype.equivFin V, equivFin_isColoring G⟩
theorem chiCC2_spec {V : Type*} [Fintype V] (G : Conf V) : ∃ c : V → Fin (chiCC2 G), IsCC2Partition G c :=
  Nat.sInf_mem (s := {k | ∃ c : V → Fin k, IsCC2Partition G c}) ⟨Fintype.card V, Fintype.equivFin V, coloring_isCC2 (equivFin_isColoring G)⟩
theorem chiK3Free_spec {V : Type*} [Fintype V] (G : Conf V) : ∃ c : V → Fin (chiK3Free G), IsK3FreePartition G c :=
  Nat.sInf_mem (s := {k | ∃ c : V → Fin k, IsK3FreePartition G c}) ⟨Fintype.card V, Fintype.equivFin V, coloring_isK3Free (equivFin_isColoring G)⟩

theorem card_le_mul_of_fiber {V : Type*} [Fintype V] {k : ℕ} (m : ℕ) (c : V → Fin k)
    (hm : ∀ i : Fin k, (Finset.univ.filter fun v => c v = i).card ≤ m) : Fintype.card V ≤ k * m := by
  calc Fintype.card V = ∑ i : Fin k, (Finset.univ.filter fun v => c v = i).card := by
        simpa using Finset.card_eq_sum_card_fiberwise (f := c) (s := Finset.univ) (t := (Finset.univ : Finset (Fin k))) (fun _ _ => Finset.mem_univ _)
    _ ≤ ∑ _i : Fin k, m := Finset.sum_le_sum fun i _ => hm i
    _ = k * m := by simp

theorem indep_strongProd {U V : Type*} {G : Conf U} {H : Conf V} {A : Finset U} {B : Finset V}
    (hA : IsIndepSet G A) (hB : IsIndepSet H B) : IsIndepSet (strongProd G H) (A ×ˢ B) :=
  fun _ hp _ hq hR => Prod.ext (hA _ (Finset.mem_product.mp hp).1 _ (Finset.mem_product.mp hq).1 hR.1)
    (hB _ (Finset.mem_product.mp hp).2 _ (Finset.mem_product.mp hq).2 hR.2)
theorem clique_strongProd {U V : Type*} {G : Conf U} {H : Conf V} {A : Finset U} {B : Finset V}
    (hA : IsClique G A) (hB : IsClique H B) : IsClique (strongProd G H) (A ×ˢ B) :=
  fun _ hp _ hq => ⟨hA _ (Finset.mem_product.mp hp).1 _ (Finset.mem_product.mp hq).1, hB _ (Finset.mem_product.mp hp).2 _ (Finset.mem_product.mp hq).2⟩
theorem coloring_strongProd {U V : Type*} {G : Conf U} {H : Conf V} {k m : ℕ} {c : U → Fin k} {e : V → Fin m}
    (hc : IsColoring G c) (he : IsColoring H e) : IsColoring (strongProd G H) (fun p => finProdFinEquiv (c p.1, e p.2)) := fun _ _ hpq hR =>
  have h := Prod.ext_iff.mp (finProdFinEquiv.injective hpq); Prod.ext (hc _ _ h.1 hR.1) (he _ _ h.2 hR.2)
theorem chi_strongProd_le {U V : Type*} [Fintype U] [Fintype V] (G : Conf U) (H : Conf V) : chi (strongProd G H) ≤ chi G * chi H := by
  obtain ⟨c, hc⟩ := chi_spec G; obtain ⟨e, he⟩ := chi_spec H; exact Nat.sInf_le ⟨_, coloring_strongProd hc he⟩

theorem indep_times_triangleFree {U V : Type*} {G : Conf U} {H : Conf V} {A : Finset U} (hA : IsIndepSet G A)
    (hH : ∀ x y z : V, H.R x y → H.R x z → H.R y z → x = y ∨ x = z ∨ y = z) {p q r : U × V} (hp : p.1 ∈ A)
    (hq : q.1 ∈ A) (hr : r.1 ∈ A) (hpq : (strongProd G H).R p q) (hpr : (strongProd G H).R p r) (hqr : (strongProd G H).R q r) :
    p = q ∨ p = r ∨ q = r := by
  rcases hH p.2 q.2 r.2 hpq.2 hpr.2 hqr.2 with h2 | h2 | h2
  · exact Or.inl (Prod.ext (hA _ hp _ hq hpq.1) h2)
  · exact Or.inr (Or.inl (Prod.ext (hA _ hp _ hr hpr.1) h2))
  · exact Or.inr (Or.inr (Prod.ext (hA _ hq _ hr hqr.1) h2))

theorem k3free_strongProd {U V : Type*} {G : Conf U} {H : Conf V} {k m : ℕ} {c : U → Fin k} {h : V → Fin m}
    (hc : IsColoring G c) (hh : IsK3FreePartition H h) :
    IsK3FreePartition (strongProd G H) (fun p => finProdFinEquiv (c p.1, h p.2)) := by
  intro p q r hpq hpr hpq' hpr' hqr'
  have h1 := Prod.ext_iff.mp (finProdFinEquiv.injective hpq); have h2 := Prod.ext_iff.mp (finProdFinEquiv.injective hpr)
  have hpq1 := hc _ _ h1.1.symm hpq'.1; have hpr1 := hc _ _ h2.1.symm hpr'.1
  rcases hh p.2 q.2 r.2 h1.2 h2.2 hpq'.2 hpr'.2 hqr'.2 with h2' | h2' | h2'
  · exact Or.inl (Prod.ext hpq1 h2')
  · exact Or.inr (Or.inl (Prod.ext hpr1 h2'))
  · exact Or.inr (Or.inr (Prod.ext (hpq1.symm.trans hpr1) h2'))

theorem cc2_is_two_colorable {V : Type*} [Fintype V] {G : Conf V} {k : ℕ} {c : V → Fin k}
    (hc : IsCC2Partition G c) : ∃ b : V → Fin 2, IsColoring G (fun v => finProdFinEquiv (c v, b v)) := by
  let e := Fintype.equivFin V; let b : V → Fin 2 := fun v => if ∃ u, c u = c v ∧ G.R u v ∧ e u < e v then 1 else 0
  have step : ∀ ⦃x y⦄, c x = c y → b x = b y → G.R x y → e x < e y → False := by
    intro x y hcx hbx hR hlt; have hbx1 : b x = 1 := hbx.trans (if_pos ⟨x, hcx, hR, hlt⟩)
    dsimp only [b] at hbx1; split_ifs at hbx1 with hu
    · obtain ⟨u, hcu, hux, hult⟩ := hu
      have huy := hc x u y hcu hcx.symm (fun h => absurd (congrArg e h) hult.ne) (fun h => absurd (congrArg e h).symm hlt.ne) (G.symm hux) hR
      exact absurd (congrArg e huy) (hult.trans hlt).ne
    · simp at hbx1
  refine ⟨b, fun x y hxy hR => ?_⟩; have heq := Prod.ext_iff.mp (finProdFinEquiv.injective hxy)
  rcases lt_trichotomy (e x) (e y) with hlt | he | hgt
  · exact (step heq.1 heq.2 hR hlt).elim
  · exact e.injective he
  · exact (step heq.1.symm heq.2.symm (G.symm hR) hgt).elim

noncomputable def log2 (x : ℝ) : ℝ := Real.log x / Real.log 2

theorem cc_sandwich {V : Type*} [Fintype V] (G : Conf V) : chiCC2 G ≤ chi G ∧ chi G ≤ 2 * chiCC2 G := by
  obtain ⟨c, hc⟩ := chi_spec G; obtain ⟨_, hk⟩ := chiCC2_spec G; obtain ⟨b, hb⟩ := cc2_is_two_colorable hk
  exact ⟨Nat.sInf_le ⟨c, coloring_isCC2 hc⟩, by simpa [Nat.mul_comm] using Nat.sInf_le (s := {k | ∃ f : V → Fin k, IsColoring G f}) ⟨_, hb⟩⟩

theorem cc_pow_log_gap {V : Type*} [Fintype V] [Nonempty V] (G : Conf V) {n : ℕ} (hn : 0 < n) :
    0 ≤ log2 (chi (strongPow G n)) / n - log2 (chiCC2 (strongPow G n)) / n ∧
    log2 (chi (strongPow G n)) / n - log2 (chiCC2 (strongPow G n)) / n ≤ 1 / (n : ℝ) := by
  obtain ⟨c0, _⟩ := chiCC2_spec (strongPow G n); have hposCC : 0 < chiCC2 (strongPow G n) := Fin.pos (c0 (Classical.arbitrary _))
  have hS := cc_sandwich (strongPow G n); have hposChi : 0 < chi (strongPow G n) := lt_of_lt_of_le hposCC hS.1
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num); have hCC_r : (0 : ℝ) < chiCC2 (strongPow G n) := Nat.cast_pos.mpr hposCC
  have hChi_r : (0 : ℝ) < chi (strongPow G n) := Nat.cast_pos.mpr hposChi; have hn_r : (0 : ℝ) < n := Nat.cast_pos.mpr hn
  have h1 : log2 (chiCC2 (strongPow G n)) ≤ log2 (chi (strongPow G n)) := div_le_div_of_nonneg_right (Real.log_le_log hCC_r (Nat.cast_le.mpr hS.1)) hl2.le
  have h2 : log2 (chi (strongPow G n)) ≤ log2 2 + log2 (chiCC2 (strongPow G n)) := by
    simpa [log2, Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) hCC_r.ne', add_div] using
      div_le_div_of_nonneg_right (Real.log_le_log hChi_r (by exact_mod_cast hS.2 : (chi (strongPow G n) : ℝ) ≤ 2 * (chiCC2 (strongPow G n) : ℝ))) hl2.le
  have h2id : log2 2 = 1 := div_self hl2.ne'
  constructor <;> rw [← sub_div] <;> [exact div_nonneg (sub_nonneg.mpr h1) hn_r.le; exact div_le_div_of_nonneg_right (by linarith) hn_r.le]

theorem indep_strongProd_K2 {V : Type*} [Fintype V] (G : Conf V) : indepNum (strongProd G K2) = indepNum G := by
  refine le_antisymm (indepNum_le fun A hA => ?_) ?_
  · have hinj : Set.InjOn Prod.fst ↑A := fun x hx y hy hxy => hA x hx y hy ⟨by simpa [hxy] using G.refl y.1, trivial⟩
    rw [← Finset.card_image_of_injOn hinj]; exact le_indepNum fun _ hx _ hy hR => by
      rcases Finset.mem_image.mp hx with ⟨a, ha, rfl⟩; rcases Finset.mem_image.mp hy with ⟨b, hb, rfl⟩
      exact congrArg Prod.fst (hA a ha b hb ⟨hR, trivial⟩)
  · obtain ⟨A, hA, hcard⟩ := exists_maxIndep G; calc indepNum G = (A ×ˢ ({false} : Finset Bool)).card := by simp [hcard]
      _ ≤ indepNum (strongProd G K2) := le_indepNum (indep_strongProd hA fun _ hx _ hy _ => by simp_all)

theorem chi_le_of_equiv {U V : Type*} [Fintype V] (G : Conf U) (H : Conf V) (e : U ≃ V) (he : ∀ x y, G.R x y ↔ H.R (e x) (e y)) :
    chi G ≤ chi H := by obtain ⟨c, hc⟩ := chi_spec H; exact Nat.sInf_le ⟨fun u => c (e u), fun _ _ hxy hR => e.injective (hc _ _ hxy ((he _ _).mp hR))⟩

theorem chiK3Free_le_of_equiv {U V : Type*} [Fintype V] (G : Conf U) (H : Conf V) (e : U ≃ V) (he : ∀ x y, G.R x y ↔ H.R (e x) (e y)) :
    chiK3Free G ≤ chiK3Free H := by
  obtain ⟨c, hc⟩ := chiK3Free_spec H; refine Nat.sInf_le ⟨fun u => c (e u), fun x y z hy hz hxy hxz hyz => ?_⟩
  rcases hc _ _ _ hy hz ((he x y).mp hxy) ((he x z).mp hxz) ((he y z).mp hyz) with h | h | h
  · exact Or.inl (e.injective h)
  · exact Or.inr (Or.inl (e.injective h))
  · exact Or.inr (Or.inr (e.injective h))

def finAddEquiv (m k : ℕ) (V : Type*) : (Fin (m + k) → V) ≃ ((Fin m → V) × (Fin k → V)) :=
  ⟨fun f => (fun i => f (Fin.castAdd k i), fun j => f (Fin.natAdd m j)), fun p => Fin.append p.1 p.2,
   fun _ => funext fun i => Fin.addCases (fun _ => by simp) (fun _ => by simp) i,
   fun _ => Prod.ext (funext fun _ => by simp) (funext fun _ => by simp)⟩
def finOneEquiv (V : Type*) : (Fin 1 → V) ≃ V := ⟨fun f => f 0, fun v _ => v, fun _ => funext fun i => by fin_cases i; rfl, fun _ => rfl⟩
def finTwoEquiv (V : Type*) : (Fin 2 → V) ≃ (V × V) := ⟨fun f => (f 0, f 1), fun p => ![p.1, p.2], fun _ => funext fun i => by fin_cases i <;> rfl, fun _ => rfl⟩

theorem cyclic_translate_bound {V : Type*} [Fintype V] [DecidableEq V] [AddCommGroup V]
    (A B : Finset V) (m : ℕ) (hm : ∀ v : V, (B.filter fun b => v + b ∈ A).card ≤ m) : B.card * A.card ≤ Fintype.card V * m := by
  have hsum : ∑ v : V, (B.filter fun b => v + b ∈ A).card = B.card * A.card := by
    simp only [Finset.card_filter]; rw [Finset.sum_comm]
    have hsh : ∀ b : V, (∑ v : V, if v + b ∈ A then 1 else 0) = A.card := fun b => by
      calc (∑ v : V, if v + b ∈ A then 1 else 0)
          = ∑ v : V, if v ∈ A then 1 else 0 := Fintype.sum_equiv (Equiv.addRight b) _ _ fun _ => rfl
        _ = A.card := by simp
    simp [hsh]
  calc B.card * A.card = ∑ v : V, (B.filter fun b => v + b ∈ A).card := hsum.symm
    _ ≤ ∑ _v : V, m := Finset.sum_le_sum fun v _ => hm v
    _ = Fintype.card V * m := by simp

theorem c7_indep_adjacent_bound {W : Type*} [Fintype W] (H : Conf W) (I : Finset (Fin 7 × W))
    (hI : IsIndepSet (strongProd C7 H) I) : 2 * I.card ≤ 7 * indepNum H := by
  have hadj : ∀ v x y : Fin 7, (x = v ∨ x = v + 1) → (y = v ∨ y = v + 1) → C7.R x y := by
    intro v x y hx hy; rcases hx with rfl | rfl <;> rcases hy with rfl | rfl <;> decide +revert
  have step : ∀ v : Fin 7, (I.filter fun p => p.1 = v ∨ p.1 = v + 1).card ≤ indepNum H := fun v => by
    let S : Finset (Fin 7 × W) := I.filter fun p => p.1 = v ∨ p.1 = v + 1
    have hinj : Set.InjOn Prod.snd (S : Set (Fin 7 × W)) := fun x hx y hy hxy => by
      have hx' := Finset.mem_filter.mp (Finset.mem_coe.mp hx); have hy' := Finset.mem_filter.mp (Finset.mem_coe.mp hy)
      exact hI x hx'.1 y hy'.1 ⟨hadj v x.1 y.1 hx'.2 hy'.2, by simpa [hxy] using H.refl y.2⟩
    rw [← Finset.card_image_of_injOn hinj]; exact le_indepNum fun _ hx _ hy hR => by
      rcases Finset.mem_image.mp hx with ⟨a, ha, rfl⟩; rcases Finset.mem_image.mp hy with ⟨b, hb, rfl⟩
      exact congrArg Prod.snd (hI a (Finset.mem_filter.mp ha).1 b (Finset.mem_filter.mp hb).1
        ⟨hadj v a.1 b.1 (Finset.mem_filter.mp ha).2 (Finset.mem_filter.mp hb).2, hR⟩)
  have hsum : ∑ v : Fin 7, (I.filter fun p => p.1 = v ∨ p.1 = v + 1).card = 2 * I.card := by
    have hdisj : ∀ v : Fin 7, (I.filter fun p => p.1 = v ∨ p.1 = v + 1).card =
        (I.filter fun p => p.1 = v).card + (I.filter fun p => p.1 = v + 1).card := fun v => by
      simpa [Finset.filter_or] using Finset.card_union_of_disjoint (Finset.disjoint_left.mpr fun p h1 h2 =>
        (by decide : ∀ u : Fin 7, u ≠ u + 1) v ((Finset.mem_filter.mp h1).2.symm.trans (Finset.mem_filter.mp h2).2))
    simp_rw [hdisj, Finset.sum_add_distrib]
    have h0 : ∑ v : Fin 7, (I.filter fun p => p.1 = v).card = I.card := by
      simpa using (Finset.card_eq_sum_card_fiberwise (f := Prod.fst) (s := I) (t := Finset.univ) fun _ _ => Finset.mem_univ _).symm
    have h1 : ∑ v : Fin 7, (I.filter fun p => p.1 = v + 1).card = I.card := by rw [← h0]; exact Fintype.sum_equiv (Equiv.addRight 1) _ _ fun _ => rfl
    omega
  calc 2 * I.card = ∑ v : Fin 7, (I.filter fun p => p.1 = v ∨ p.1 = v + 1).card := hsum.symm
    _ ≤ ∑ _v : Fin 7, indepNum H := Finset.sum_le_sum fun v _ => step v
    _ = 7 * indepNum H := by simp

theorem c7Pow_k3free_card_bound (n : ℕ) {A : Finset (Fin n → Fin 7)}
    (hA : ∀ x ∈ A, ∀ y ∈ A, ∀ z ∈ A, (strongPow C7 n).R x y → (strongPow C7 n).R x z →
      (strongPow C7 n).R y z → x = y ∨ x = z ∨ y = z) : 2 ^ n * A.card ≤ 7 ^ n * 2 := by
  let emb : (Fin n → Fin 2) ↪ (Fin n → Fin 7) := ⟨fun ε i => c7BitVal (ε i), fun _ _ h => funext fun i => c7BitVal_inj (congrFun h i)⟩
  let B : Finset (Fin n → Fin 7) := Finset.univ.map emb
  have hcyc := cyclic_translate_bound A B 2 fun v => by
    by_contra hlt; obtain ⟨b₁, hb₁, b₂, hb₂, b₃, hb₃, h12, h13, h23⟩ := Finset.two_lt_card.mp (Nat.lt_of_not_le hlt)
    have hR : ∀ x ∈ B, ∀ y ∈ B, (strongPow C7 n).R (v + x) (v + y) := fun x hx y hy i => by
      rcases Finset.mem_map.mp hx with ⟨ε₁, _, rfl⟩; rcases Finset.mem_map.mp hy with ⟨ε₂, _, rfl⟩; exact c7BitVal_adj (v i) (ε₁ i) (ε₂ i)
    have hx₁ := Finset.mem_filter.mp hb₁; have hx₂ := Finset.mem_filter.mp hb₂; have hx₃ := Finset.mem_filter.mp hb₃
    rcases hA (v + b₁) hx₁.2 (v + b₂) hx₂.2 (v + b₃) hx₃.2
      (hR _ hx₁.1 _ hx₂.1) (hR _ hx₁.1 _ hx₃.1) (hR _ hx₂.1 _ hx₃.1) with h | h | h <;>
      [exact h12 (add_left_cancel h); exact h13 (add_left_cancel h); exact h23 (add_left_cancel h)]
  simpa [B, Fintype.card_pi, Fintype.card_fin] using hcyc

theorem c7_indepNum_eq : indepNum C7 = 3 := by
  refine le_antisymm (indepNum_le fun A hA => ?_) (by simpa [show c7Indep.card = 3 by decide] using le_indepNum c7Indep_ok)
  have h := cyclic_translate_bound A ({0, 1} : Finset (Fin 7)) 1 fun v => Finset.card_le_one.mpr fun a ha b hb => by
    rcases Finset.mem_filter.mp ha with ⟨haB, haA⟩; rcases Finset.mem_filter.mp hb with ⟨hbB, hbA⟩
    rcases (by simpa using haB : a = 0 ∨ a = 1) with rfl | rfl <;> rcases (by simpa using hbB : b = 0 ∨ b = 1) with rfl | rfl
    · rfl
    · exact False.elim (Fin.zero_ne_one (add_left_cancel (hA _ haA _ hbA (by simpa using c7_step v))))
    · exact False.elim (Fin.zero_ne_one (add_left_cancel (hA _ haA _ hbA (by simpa using C7.symm (c7_step v)))).symm)
    · rfl
  rw [show ({0, 1} : Finset (Fin 7)).card = 2 by decide, Fintype.card_fin] at h; omega

theorem c7_chi_eq : chi C7 = 3 := by
  refine le_antisymm (Nat.sInf_le ⟨c7Color, c7Color_ok⟩) ?_; obtain ⟨c, hc⟩ := chi_spec C7
  have h := card_le_mul_of_fiber 3 c fun i => by simpa [c7_indepNum_eq] using le_indepNum fun _ hx _ hy => hc _ _ ((Finset.mem_filter.mp hx).2.trans (Finset.mem_filter.mp hy).2.symm)
  rw [Fintype.card_fin] at h; omega

theorem c7_chiCC2_le : chiCC2 C7 ≤ 2 := Nat.sInf_le ⟨c7CC2, c7CC2_ok⟩
theorem c7_chiK3Free_eq : chiK3Free C7 = 1 :=
  le_antisymm (Nat.sInf_le ⟨fun _ => (0 : Fin 1), fun x y z _ _ => c7_triangleFree x y z⟩) (let ⟨c, _⟩ := chiK3Free_spec C7; Fin.pos (c 0))

theorem c7Sq_indepNum_eq : indepNum (strongPow C7 2) = 10 := by
  let pts : Finset (Fin 2 → Fin 7) := c7SqPts.toFinset.image fun p => ![p.1, p.2]
  have hpts_ind : IsIndepSet (strongPow C7 2) pts := fun _ hx _ hy hR => by
    rcases Finset.mem_image.mp hx with ⟨p, hp, rfl⟩; rcases Finset.mem_image.mp hy with ⟨q, hq, rfl⟩
    simp [c7SqPts_ok p (List.mem_toFinset.mp hp) q (List.mem_toFinset.mp hq) ⟨by simpa using hR 0, by simpa using hR 1⟩]
  have hpts_card : pts.card = 10 := by rw [Finset.card_image_of_injOn fun _ _ _ _ h => Prod.ext (congrFun h 0) (congrFun h 1), List.toFinset_card_of_nodup c7SqPts_nodup]; decide
  refine le_antisymm (indepNum_le fun A hA => ?_) (hpts_card ▸ le_indepNum hpts_ind)
  have hI : IsIndepSet (strongProd C7 C7) (A.image (finTwoEquiv (Fin 7))) := fun _ hx _ hy hR => by
    rcases Finset.mem_image.mp hx with ⟨a, ha, rfl⟩; rcases Finset.mem_image.mp hy with ⟨b, hb, rfl⟩
    exact congrArg (finTwoEquiv _) (hA a ha b hb fun i => by fin_cases i <;> [exact hR.1; exact hR.2])
  have h2 := c7_indep_adjacent_bound C7 _ hI; rw [c7_indepNum_eq, Finset.card_image_of_injective A (finTwoEquiv (Fin 7)).injective] at h2; omega

theorem c7Sq_chi_eq : chi (strongPow C7 2) = 5 := by
  let c : (Fin 2 → Fin 7) → Fin 5 := fun p => c7SqColorVec (p 0) (p 1)
  have hc : IsColoring (strongPow C7 2) c := fun x y hxy hR => by
    obtain ⟨d₁, hd₁⟩ := (c7_iff_diff (x 0) (y 0)).mp (hR 0); obtain ⟨d₂, hd₂⟩ := (c7_iff_diff (x 1) (y 1)).mp (hR 1)
    by_cases h0 : (d₁, d₂) = (0, 0)
    · cases h0; funext i; fin_cases i <;> simp [hd₁, hd₂, c7Diffs]
    · exact absurd (by simpa [c, hd₁, hd₂] using hxy) (c7SqColor_offsets (x 0) (x 1) d₁ d₂ h0)
  refine le_antisymm (Nat.sInf_le ⟨c, hc⟩) ?_; obtain ⟨k, hk⟩ := chi_spec (strongPow C7 2)
  have h := card_le_mul_of_fiber 10 k fun i => by simpa [c7Sq_indepNum_eq] using le_indepNum fun _ hx _ hy => hk _ _ ((Finset.mem_filter.mp hx).2.trans (Finset.mem_filter.mp hy).2.symm)
  rw [show Fintype.card (Fin 2 → Fin 7) = 49 by simp] at h; omega

theorem c7Sq_chiCC2_le : chiCC2 (strongPow C7 2) ≤ 4 := by
  refine Nat.sInf_le ⟨fun p => c7SqCC2Vec (p 0) (p 1), fun x y z hy hz hyn hzn hxy hxz => ?_⟩
  obtain ⟨a₁, ha₁⟩ := (c7_iff_diff (x 0) (y 0)).mp (hxy 0); obtain ⟨a₂, ha₂⟩ := (c7_iff_diff (x 1) (y 1)).mp (hxy 1)
  obtain ⟨b₁, hb₁⟩ := (c7_iff_diff (x 0) (z 0)).mp (hxz 0); obtain ⟨b₂, hb₂⟩ := (c7_iff_diff (x 1) (z 1)).mp (hxz 1)
  have ha0 : (a₁, a₂) ≠ (0, 0) := fun h => hyn (funext fun i => by cases h; fin_cases i <;> simp [ha₁, ha₂, c7Diffs])
  have hb0 : (b₁, b₂) ≠ (0, 0) := fun h => hzn (funext fun i => by cases h; fin_cases i <;> simp [hb₁, hb₂, c7Diffs])
  by_cases hab : (a₁, a₂) = (b₁, b₂)
  · cases hab; funext i; fin_cases i <;> simp [ha₁, ha₂, hb₁, hb₂]
  · exact (c7SqCC2_offsets (x 0) (x 1) a₁ a₂ b₁ b₂ ha0 hb0 hab (by simpa [ha₁, ha₂] using hy) (by simpa [hb₁, hb₂] using hz)).elim

theorem c7Sq_chiK3Free_eq : chiK3Free (strongPow C7 2) = 3 := by
  have hub : chiK3Free (strongPow C7 2) ≤ 3 := (chiK3Free_le_of_equiv (strongPow C7 2) (strongProd C7 C7) (finTwoEquiv (Fin 7))
      fun _ _ => ⟨fun h => ⟨h 0, h 1⟩, fun h i => by fin_cases i <;> [exact h.1; exact h.2]⟩).trans
      (Nat.sInf_le (s := {k | ∃ f : (Fin 7 × Fin 7) → Fin k, IsK3FreePartition (strongProd C7 C7) f})
        ⟨_, k3free_strongProd c7Color_ok (fun x y z _ _ => c7_triangleFree x y z : IsK3FreePartition C7 fun _ => (0 : Fin 1))⟩)
  refine le_antisymm hub ?_; obtain ⟨c, hc⟩ := chiK3Free_spec (strongPow C7 2)
  have h := card_le_mul_of_fiber 24 c fun i => by
    have h2 := c7Pow_k3free_card_bound 2 (A := Finset.univ.filter fun v => c v = i) fun x hx y hy z hz =>
      hc x y z ((Finset.mem_filter.mp hy).2.trans (Finset.mem_filter.mp hx).2.symm) ((Finset.mem_filter.mp hz).2.trans (Finset.mem_filter.mp hx).2.symm)
    omega
  rw [show Fintype.card (Fin 2 → Fin 7) = 49 by simp] at h; omega

theorem c7Cube_indepNum_bounds : 30 ≤ indepNum (strongPow C7 3) ∧ indepNum (strongPow C7 3) ≤ 35 := by
  constructor
  · obtain ⟨A, hA, hAcard⟩ := exists_maxIndep (strongPow C7 2)
    let he : ((Fin 2 → Fin 7) × Fin 7) ≃ (Fin 3 → Fin 7) := ((finAddEquiv 2 1 (Fin 7)).trans (Equiv.prodCongr (Equiv.refl _) (finOneEquiv (Fin 7)))).symm
    have hmap : IsIndepSet (strongPow C7 3) ((A ×ˢ c7Indep).map he.toEmbedding) := fun _ hx _ hy hR => by
      rcases Finset.mem_map.mp hx with ⟨p, hp, rfl⟩; rcases Finset.mem_map.mp hy with ⟨q, hq, rfl⟩
      have h0 : ∀ i : Fin 2, C7.R (p.1 i) (q.1 i) := fun i => by
        simpa [he, finAddEquiv, finOneEquiv, Fin.append_left] using hR (Fin.castAdd 1 i)
      have h1 : C7.R p.2 q.2 := by
        simpa [he, finAddEquiv, finOneEquiv, Fin.append_right] using hR (Fin.natAdd 2 (0 : Fin 1))
      rw [indep_strongProd hA c7Indep_ok p hp q hq ⟨h0, h1⟩]
    calc 30 = ((A ×ˢ c7Indep).map he.toEmbedding).card := by simp [hAcard, c7Sq_indepNum_eq, show c7Indep.card = 3 by decide]
      _ ≤ indepNum (strongPow C7 3) := le_indepNum hmap
  · refine indepNum_le fun A hA => ?_
    let he : (Fin 3 → Fin 7) ≃ (Fin 7 × (Fin 2 → Fin 7)) := (finAddEquiv 1 2 (Fin 7)).trans (Equiv.prodCongr (finOneEquiv (Fin 7)) (Equiv.refl _))
    have hI : IsIndepSet (strongProd C7 (strongPow C7 2)) (A.image he) := fun _ hx _ hy hR => by
      rcases Finset.mem_image.mp hx with ⟨a, ha, rfl⟩; rcases Finset.mem_image.mp hy with ⟨b, hb, rfl⟩
      exact congrArg he (hA a ha b hb fun i => by fin_cases i <;> [exact hR.1; exact hR.2 0; exact hR.2 1])
    have h2 := c7_indep_adjacent_bound (strongPow C7 2) _ hI; rw [c7Sq_indepNum_eq, Finset.card_image_of_injective A he.injective] at h2; omega

theorem c7Cube_chiK3Free_eq : chiK3Free (strongPow C7 3) = 5 := by
  obtain ⟨c2, hc2⟩ := chi_spec (strongPow C7 2)
  let he : (Fin 3 → Fin 7) ≃ ((Fin 2 → Fin 7) × Fin 7) := (finAddEquiv 2 1 (Fin 7)).trans (Equiv.prodCongr (Equiv.refl _) (finOneEquiv (Fin 7)))
  have hub : chiK3Free (strongPow C7 3) ≤ 5 := by
    have hle := chiK3Free_le_of_equiv (strongPow C7 3) (strongProd (strongPow C7 2) C7) he
      fun _ _ => ⟨fun h => ⟨fun i => h i.castSucc, h 2⟩, fun h i => by fin_cases i <;> [exact h.1 0; exact h.1 1; exact h.2]⟩
    have h5 := Nat.sInf_le (s := {k | ∃ f : ((Fin 2 → Fin 7) × Fin 7) → Fin k, IsK3FreePartition (strongProd (strongPow C7 2) C7) f})
      ⟨_, k3free_strongProd hc2 (fun x y z _ _ => c7_triangleFree x y z : IsK3FreePartition C7 fun _ => (0 : Fin 1))⟩
    simpa [c7Sq_chi_eq] using hle.trans h5
  refine le_antisymm hub ?_; obtain ⟨c, hc⟩ := chiK3Free_spec (strongPow C7 3)
  have h := card_le_mul_of_fiber 85 c fun i => by
    have h3 := c7Pow_k3free_card_bound 3 (A := Finset.univ.filter fun v => c v = i) fun x hx y hy z hz =>
      hc x y z ((Finset.mem_filter.mp hy).2.trans (Finset.mem_filter.mp hx).2.symm) ((Finset.mem_filter.mp hz).2.trans (Finset.mem_filter.mp hx).2.symm)
    omega
  rw [show Fintype.card (Fin 3 → Fin 7) = 343 by simp] at h; omega

theorem c7Pow_chi_le : ∀ n : ℕ, chi (strongPow C7 n) ≤ 5 ^ (n / 2) * 3 ^ (n % 2)
  | 0 => by refine Nat.sInf_le (s := {k | ∃ f : (Fin 0 → Fin 7) → Fin k, IsColoring (strongPow C7 0) f}) ⟨fun _ => (0 : Fin 1), fun _ _ _ _ => funext fun i => Fin.elim0 i⟩
  | 1 => by simpa [c7_chi_eq] using chi_le_of_equiv (strongPow C7 1) C7 (finOneEquiv (Fin 7)) fun _ _ => ⟨fun h => h 0, fun h i => by fin_cases i; exact h⟩
  | m + 2 => by
      have hm := c7Pow_chi_le m
      let he := (finAddEquiv m 2 (Fin 7)).trans (Equiv.prodComm _ _)
      have he_le := chi_le_of_equiv (strongPow C7 (m + 2)) (strongProd (strongPow C7 2) (strongPow C7 m)) he
        fun _ _ => ⟨fun h => ⟨fun _ => h _, fun _ => h _⟩, fun h i => Fin.addCases h.2 h.1 i⟩
      have hprod := he_le.trans (chi_strongProd_le (strongPow C7 2) (strongPow C7 m)); rw [c7Sq_chi_eq] at hprod
      calc chi (strongPow C7 (m + 2)) ≤ 5 * (5 ^ (m / 2) * 3 ^ (m % 2)) := hprod.trans (Nat.mul_le_mul_left 5 hm)
        _ = 5 ^ ((m + 2) / 2) * 3 ^ ((m + 2) % 2) := by rw [show (m + 2) / 2 = m / 2 + 1 by omega, show (m + 2) % 2 = m % 2 by omega, pow_succ']; ring

theorem c7Pow_log_rate_le {n : ℕ} (hn : 0 < n) : log2 (chi (strongPow C7 n)) / n ≤ (1 / 2 : ℝ) * log2 5 + log2 3 / n := by
  obtain ⟨c, _⟩ := chi_spec (strongPow C7 n); have hchi_pos : 0 < chi (strongPow C7 n) := Fin.pos (c fun _ => 0)
  have hl2 : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hlog : log2 (chi (strongPow C7 n)) ≤ ((n / 2 : ℕ) : ℝ) * log2 5 + ((n % 2 : ℕ) : ℝ) * log2 3 := by
    have h1 := div_le_div_of_nonneg_right (Real.log_le_log (Nat.cast_pos.mpr hchi_pos)
      (by exact_mod_cast c7Pow_chi_le n : (chi (strongPow C7 n) : ℝ) ≤ (5 : ℝ) ^ (n / 2) * (3 : ℝ) ^ (n % 2))) hl2.le
    rw [Real.log_mul (by positivity) (by positivity), Real.log_pow, Real.log_pow, add_div, mul_div_assoc, mul_div_assoc] at h1; exact h1
  have hn_r : (0 : ℝ) < n := Nat.cast_pos.mpr hn
  have hdiv2 : ((n / 2 : ℕ) : ℝ) ≤ (n : ℝ) / 2 := by linarith [show (2 : ℝ) * ((n / 2 : ℕ) : ℝ) ≤ n by exact_mod_cast Nat.mul_div_le n 2]
  have hmod1 : ((n % 2 : ℕ) : ℝ) ≤ 1 := by exact_mod_cast Nat.lt_succ_iff.mp (Nat.mod_lt n (by norm_num))
  have hl5 : 0 ≤ log2 5 := div_nonneg (Real.log_nonneg (by norm_num)) hl2.le; have hl3 : 0 ≤ log2 3 := div_nonneg (Real.log_nonneg (by norm_num)) hl2.le
  calc log2 (chi (strongPow C7 n)) / n ≤ ((n : ℝ) / 2 * log2 5 + 1 * log2 3) / n := div_le_div_of_nonneg_right
        (hlog.trans (add_le_add (mul_le_mul_of_nonneg_right hdiv2 hl5) (mul_le_mul_of_nonneg_right hmod1 hl3))) hn_r.le
    _ = (1 / 2 : ℝ) * log2 5 + log2 3 / n := by field_simp

end GeneralAndCounts

def rep (n : ℕ) (i : Fin (powTwo n)) : Fin n → Bool := fun t => nthBits n i.val t.val
theorem powTwo_eq (n : ℕ) : powTwo n = 2 ^ n := by induction n with | zero => rfl | succ k ih => simp [powTwo, ih, pow_succ, mul_two]
theorem c2_collapse_clique (n : ℕ) :
    Function.Injective (rep n) ∧ IsClique (strongPow K2 n) (Finset.univ.image (rep n)) ∧
    (Finset.univ.image (rep n)).card = 2 ^ n ∧ ∀ i j : Fin (powTwo n), c2ChainChi n (nthBits n i.val) = c2ChainChi n (nthBits n j.val) := by
  have hinj : Function.Injective (rep n) := fun i j h => Fin.ext ((c2_n_step_collapse n i.val j.val i.isLt j.isLt).2 fun k hk => congrFun h ⟨k, hk⟩)
  refine ⟨hinj, fun _ _ _ _ _ => trivial, ?_, fun i j => (c2_n_step_collapse n i.val j.val i.isLt j.isLt).1⟩
  rw [Finset.card_image_of_injective _ hinj, Finset.card_fin, powTwo_eq]

end Becoming.InterfaceBits
