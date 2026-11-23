import Becoming.ProjectedLaws
import Becoming.Viability
import Becoming.Tower

/-!
# Multi-scale viability: lax `(π, σ)` simulations and tower composition

In `Becoming.ProjectedLaws`, `ProjectedLaws.reduced_law_exists_iff` proves that a commuting
reduced law exists for a projection `p : S → Q` exactly when the projection is `FibreConsistent`
on every step. Hidden micro-phase or inter-sample oscillation breaks `FibreConsistent` while
bounded coarse-grained dynamics can still preserve a viability kernel.

This module supplies:
* `SlackDist` and `LaxSim`: lax `(π, σ)`-viability simulation with boundary slack `(α, ε)` and
  inter-sample excursion slack `(β, η)`, tracked against epochs `Epoch` and `EpochQ`.
* `lax_kernel_of_certificate`, `lax_kernel_of_kernel`, and `lax_keptFor_linear`: infinite-horizon
  and finite-horizon viability transfer for arbitrary `Becoming.Strict σ` (including `σ 0 > 0`).
* `LaxSim.comp` and `LaxSim.compAdditive`: vertical composition along multi-scale towers in both
  contractive and bounded-stride additive scale-1 modes, preserving `epoch_compat`, `μ₂`, and `β`,
  plus a recursive `Tower` adapter (`towerSim`).
* `WitnessTwoScale`: a concrete two-scale countermodel (`S = Nat × Nat`, `Q₁ = Nat × Bool`,
  `Q₂ = Nat`) proving non-exact-lumping at both projections via `ProjectedLaws.reduced_law_exists_iff`,
  constructing `sim₁` and `sim₂`, composing them, and certifying `Viability.Kernel`.

AI-written, 23 November 2026. Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v w z

/-! ## Natural-number slack distances -/

/-- Absolute difference on `Nat`. -/
def distNat (x y : Nat) : Nat := (x - y) + (y - x)

theorem sub_self_nat : ∀ x : Nat, x - x = 0
  | 0 => rfl
  | x + 1 => (Nat.succ_sub_succ x x).trans (sub_self_nat x)

theorem distNat_self (x : Nat) : distNat x x = 0 := by
  unfold distNat
  rw [sub_self_nat]

theorem distNat_symm (x y : Nat) : distNat x y = distNat y x :=
  Nat.add_comm (x - y) (y - x)

theorem le_sub_add_nat (a b : Nat) : a ≤ (a - b) + b :=
  match Nat.le_total a b with
  | .inl le => Nat.le_trans le (Nat.le_add_left b (a - b))
  | .inr ge => Nat.le_of_eq (Naturals.sub_add_cancel ge).symm

theorem sub_le_add_sub_nat (a b c : Nat) : a - c ≤ (a - b) + (b - c) :=
  Naturals.sub_le_of_le_add
    (Nat.le_trans (le_sub_add_nat a b)
      (Nat.le_trans (Nat.add_le_add_left (le_sub_add_nat b c) (a - b))
        (Nat.le_of_eq ((Nat.add_assoc (a - b) (b - c) c).symm.trans
          (Nat.add_comm ((a - b) + (b - c)) c)))))

theorem distNat_tri (x y z : Nat) : distNat x z ≤ distNat x y + distNat y z :=
  Nat.le_trans
    (Nat.add_le_add (sub_le_add_sub_nat x y z) (sub_le_add_sub_nat z y x))
    (Nat.le_of_eq (Naturals.add_regroup (x - y) (y - z) (z - y) (y - x)))

theorem distNat_add_one (x y : Nat) : distNat (x + 1) y ≤ distNat x y + 1 :=
  Nat.le_trans (distNat_tri (x + 1) x y) (by
    have step : distNat (x + 1) x = 1 := by
      unfold distNat
      rw [succ_sub_self, sub_eq_zero_of_le (Nat.le_succ x)]
    rw [step, Nat.add_comm 1 (distNat x y)]
    exact Nat.le_refl _)

theorem distNat_sub_one : ∀ x y : Nat, distNat (x - 1) y ≤ distNat x y + 1
  | 0, y => Nat.le_trans (Nat.le_refl (distNat 0 y)) (Nat.le_add_right _ 1)
  | x + 1, y => Nat.le_trans (distNat_tri x (x + 1) y) (by
      have step : distNat x (x + 1) = 1 := by
        rw [distNat_symm]
        unfold distNat
        rw [succ_sub_self, sub_eq_zero_of_le (Nat.le_succ x)]
      rw [step, Nat.add_comm 1 (distNat (x + 1) y)]
      exact Nat.le_refl _)

/-- Discrete slack pseudo-metric on a state summary space `Q`. -/
structure SlackDist (Q : Type u) where
  d : Q → Q → Nat
  refl : ∀ q, d q q = 0
  tri : ∀ q₁ q₂ q₃, d q₁ q₃ ≤ d q₁ q₂ + d q₂ q₃

/-- Canonical slack distance on `Nat`. -/
def SlackDist.nat : SlackDist Nat where
  d := distNat
  refl := distNat_self
  tri := distNat_tri

/-- Pullback of a slack distance along a projection. -/
def SlackDist.pullback {Q : Type u} {R : Type v} (f : Q → R) (M : SlackDist R) : SlackDist Q where
  d x y := M.d (f x) (f y)
  refl x := M.refl (f x)
  tri x y z := M.tri (f x) (f y) (f z)

/-! ## Strict-sampling and trace-splitting helpers -/

section Helpers

theorem strict_mono_le {σ : Nat → Nat} (strict : Strict σ) : ∀ {a b : Nat}, a ≤ b → σ a ≤ σ b
  | _, _, le => match Nat.eq_or_lt_of_le le with
    | .inl same => Nat.le_of_eq (congrArg σ same)
    | .inr lt => Nat.le_of_lt (strict.lt lt)

theorem strict_lt_of_lt {σ : Nat → Nat} (strict : Strict σ) {a b : Nat} (lt : σ a < σ b) : a < b :=
  match Nat.lt_or_ge a b with
  | .inl below => below
  | .inr above => absurd lt (Nat.not_lt_of_le (strict_mono_le strict above))

theorem strict_unbounded {σ : Nat → Nat} (strict : Strict σ) (t : Nat) : ∃ k, t < σ k :=
  ⟨t + 1, Nat.lt_of_le_of_lt (strict.le_self t) (strict t)⟩

private theorem block_below {σ : Nat → Nat} (strict : Strict σ) (t : Nat) :
    ∀ k, t < σ k → σ 0 ≤ t → ∃ j, σ j ≤ t ∧ t < σ (j + 1)
  | 0, lt, ge => absurd (Nat.lt_of_le_of_lt ge lt) (Nat.lt_irrefl _)
  | k + 1, lt, ge => match Nat.lt_or_ge t (σ k) with
    | .inl lt' => block_below strict t k lt' ge
    | .inr ge' => ⟨k, ge', lt⟩

theorem block_of_strict {σ : Nat → Nat} (strict : Strict σ) {t : Nat} (ge : σ 0 ≤ t) :
    ∃ k, σ k ≤ t ∧ t < σ (k + 1) :=
  match strict_unbounded strict t with
  | ⟨k, lt⟩ => block_below strict t k lt ge

theorem trace_split {S : Type u} {A : Type v} {P : Process S A} :
    ∀ (m : Nat) {s t : S} {w : List A}, m ≤ w.length → Trace P s w t →
      ∃ w₁ w₂ u, w₁.length = m ∧ w₁.length + w₂.length = w.length ∧
        Trace P s w₁ u ∧ Trace P u w₂ t
  | 0, s, _, w, _, tr => ⟨[], w, s, rfl, Nat.zero_add w.length, .nil s, tr⟩
  | m + 1, _, _, [], le, _ => absurd le (Nat.not_succ_le_zero m)
  | m + 1, _, _, a :: _, le, .cons step tr =>
    match trace_split m (Nat.le_of_succ_le_succ le) tr with
    | ⟨w₁, w₂, u, len₁, sum_len, tr₁, tr₂⟩ =>
      ⟨a :: w₁, w₂, u, congrArg Nat.succ len₁,
        (Nat.succ_add w₁.length w₂.length).trans (congrArg Nat.succ sum_len),
        .cons step tr₁, tr₂⟩

end Helpers

/-! ## Lax multi-scale simulation -/

/-- Lax `(π, σ)`-viability simulation from fine `(P, Epoch)` to coarse `(R, EpochQ)`
    with boundary gain/slack `(α, ε)` and inter-sample excursion gain/slack `(β, η)`. -/
structure LaxSim {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    (P : Process S A) (R : Process Q B)
    (π : S → Q) (σ : Nat → Nat) (M : SlackDist Q) where
  strict : Strict σ
  Epoch : Nat → S → Prop
  EpochQ : Nat → Q → Prop
  epoch_step : ∀ t s a s', Epoch t s → P.step s a s' → Epoch (t + 1) s'
  epoch_proj : ∀ k s, Epoch (σ k) s → EpochQ k (π s)
  α : Nat → Nat
  β : Nat → Nat
  α_mono : ∀ {r₁ r₂}, r₁ ≤ r₂ → α r₁ ≤ α r₂
  β_mono : ∀ {r₁ r₂}, r₁ ≤ r₂ → β r₁ ≤ β r₂
  β_ge_id : ∀ r, r ≤ β r
  ε : Nat
  η : Nat
  sim_block : ∀ k s q r w s',
    Epoch (σ k) s → EpochQ k q → M.d (π s) q ≤ r →
    w.length = σ (k + 1) - σ k → Trace P s w s' →
    ∃ b q', R.step q b q' ∧ EpochQ (k + 1) q' ∧ M.d (π s') q' ≤ α r + ε
  excursion : ∀ k s q r w₁ u,
    Epoch (σ k) s → EpochQ k q → M.d (π s) q ≤ r →
    w₁.length < σ (k + 1) - σ k → Trace P s w₁ u →
    M.d (π u) q ≤ β r + η

namespace LaxSim

/-- Iterated boundary slack over `m` blocks starting from initial slack `r`. -/
def slack (α : Nat → Nat) (ε : Nat) : Nat → Nat → Nat
  | 0, r => r
  | m + 1, r => slack α ε m (α r + ε)

theorem slack_le_of_absorb {α : Nat → Nat} (α_mono : ∀ {r₁ r₂}, r₁ ≤ r₂ → α r₁ ≤ α r₂)
    {ε Δ : Nat} (absorb : α Δ + ε ≤ Δ) :
    ∀ m r, r ≤ Δ → slack α ε m r ≤ Δ
  | 0, _, le => le
  | m + 1, r, le =>
    slack_le_of_absorb α_mono absorb m (α r + ε)
      (Nat.le_trans (Nat.add_le_add_right (α_mono le) ε) absorb)

theorem slack_id (ε : Nat) : ∀ m r, slack id ε m r = r + m * ε
  | 0, r => (Nat.add_zero r).symm.trans (congrArg (r + ·) (Nat.zero_mul ε).symm)
  | m + 1, r =>
    (slack_id ε m (r + ε)).trans
      ((Nat.add_assoc r ε (m * ε)).trans
        (congrArg (r + ·) ((Nat.add_comm ε (m * ε)).trans (Nat.succ_mul m ε).symm)))

theorem epoch_trace {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M) :
    ∀ {t₀ : Nat} {s : S} {w : List A} {u : S},
      sim.Epoch t₀ s → Trace P s w u → sim.Epoch (t₀ + w.length) u
  | _, _, [], _, ep, .nil _ => ep
  | t₀, s, _ :: rest, u, ep, .cons step tr =>
    have ep' := sim.epoch_step t₀ s _ _ ep step
    Eq.subst (motive := fun n => sim.Epoch n u) (Nat.add_right_comm t₀ 1 rest.length)
      (epoch_trace sim ep' tr)

/-- Advance `m` coarse blocks starting from block index `j₀`. -/
theorem advance_blocks {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M) :
    ∀ (m j₀ : Nat) {s : S} {q : Q} {r : Nat} {w : List A} {t : S},
      sim.Epoch (σ j₀) s → sim.EpochQ j₀ q → M.d (π s) q ≤ r →
      σ (j₀ + m) - σ j₀ ≤ w.length → Trace P s w t →
      ∃ u w_rem wR q_m,
        w_rem.length + (σ (j₀ + m) - σ j₀) = w.length ∧
        wR.length = m ∧
        Trace R q wR q_m ∧
        Trace P u w_rem t ∧
        sim.Epoch (σ (j₀ + m)) u ∧
        sim.EpochQ (j₀ + m) q_m ∧
        M.d (π u) q_m ≤ slack sim.α sim.ε m r
  | 0, j₀, s, q, _, w, t, epS, epQ, d_le, _, tr =>
    ⟨s, w, [], q, (congrArg (w.length + ·) (sub_self_nat (σ j₀))).trans (Nat.add_zero w.length),
      rfl, .nil q, tr, epS, epQ, d_le⟩
  | m + 1, j₀, s, q, r, w, t, epS, epQ, d_le, len_ge, tr =>
    have h_j0_le_j1 : σ j₀ ≤ σ (j₀ + 1) := Nat.le_of_lt (sim.strict j₀)
    have h_j1_le_jm : σ (j₀ + 1) ≤ σ (j₀ + (m + 1)) :=
      strict_mono_le sim.strict (Nat.succ_le_succ (Nat.le_add_right j₀ m))
    have h_j0_le_jm : σ j₀ ≤ σ (j₀ + (m + 1)) := Nat.le_trans h_j0_le_j1 h_j1_le_jm
    have step_le_block : σ (j₀ + 1) - σ j₀ ≤ σ (j₀ + (m + 1)) - σ j₀ :=
      le_of_add_le_add_right (σ j₀)
        (Nat.le_trans (Nat.le_of_eq ((Nat.add_comm _ (σ j₀)).trans (add_sub_of_le h_j0_le_j1)))
          (Nat.le_trans h_j1_le_jm (Nat.le_of_eq ((Nat.add_comm _ (σ j₀)).trans (add_sub_of_le h_j0_le_jm)).symm)))
    match trace_split (σ (j₀ + 1) - σ j₀) (Nat.le_trans step_le_block len_ge) tr with
    | ⟨w₁, w₂, s₁, len₁, sum_len, tr₁, tr₂⟩ =>
      match sim.sim_block j₀ s q r w₁ s₁ epS epQ d_le len₁ tr₁ with
      | ⟨b, q₁, stepQ, epQ₁, d_le₁⟩ =>
        have epS₁ : sim.Epoch (σ (j₀ + 1)) s₁ :=
          Eq.subst (motive := fun n => sim.Epoch n s₁)
            ((congrArg (σ j₀ + ·) len₁).trans (add_sub_of_le h_j0_le_j1))
            (epoch_trace sim epS tr₁)
        have block_split :
            (σ (j₀ + 1) - σ j₀) + (σ ((j₀ + 1) + m) - σ (j₀ + 1)) =
              σ (j₀ + (m + 1)) - σ j₀ := by
          have eq_idx : (j₀ + 1) + m = j₀ + (m + 1) := Nat.add_right_comm j₀ 1 m
          apply add_right_cancel (σ j₀)
          calc (σ (j₀ + 1) - σ j₀) + (σ ((j₀ + 1) + m) - σ (j₀ + 1)) + σ j₀
              = (σ (j₀ + 1) - σ j₀) + ((σ ((j₀ + 1) + m) - σ (j₀ + 1)) + σ j₀) := Nat.add_assoc _ _ _
            _ = (σ (j₀ + 1) - σ j₀) + (σ j₀ + (σ ((j₀ + 1) + m) - σ (j₀ + 1))) :=
                congrArg (_ + ·) (Nat.add_comm _ _)
            _ = ((σ (j₀ + 1) - σ j₀) + σ j₀) + (σ ((j₀ + 1) + m) - σ (j₀ + 1)) :=
                (Nat.add_assoc _ _ _).symm
            _ = σ (j₀ + 1) + (σ ((j₀ + 1) + m) - σ (j₀ + 1)) :=
                congrArg (· + _) (Naturals.sub_add_cancel h_j0_le_j1)
            _ = (σ ((j₀ + 1) + m) - σ (j₀ + 1)) + σ (j₀ + 1) := Nat.add_comm _ _
            _ = σ ((j₀ + 1) + m) := Naturals.sub_add_cancel (eq_idx ▸ h_j1_le_jm)
            _ = σ (j₀ + (m + 1)) := congrArg σ eq_idx
            _ = (σ (j₀ + (m + 1)) - σ j₀) + σ j₀ := (Naturals.sub_add_cancel h_j0_le_jm).symm
        have rem_ge : σ ((j₀ + 1) + m) - σ (j₀ + 1) ≤ w₂.length :=
          Naturals.le_of_add_le_add_left (k := σ (j₀ + 1) - σ j₀)
            (Nat.le_trans (Nat.le_of_eq block_split)
              (Nat.le_trans len_ge (Nat.le_of_eq (sum_len.symm.trans (congrArg (· + w₂.length) len₁)))))
        match advance_blocks sim m (j₀ + 1) epS₁ epQ₁ d_le₁ rem_ge tr₂ with
        | ⟨u, w_rem, wR, q_m, rem_eq, rlen, trR, tr_rem, epU, epQm, d_m⟩ =>
          have eq_idx : (j₀ + 1) + m = j₀ + (m + 1) := Nat.add_right_comm j₀ 1 m
          have total_rem : w_rem.length + (σ (j₀ + (m + 1)) - σ j₀) = w.length :=
            calc w_rem.length + (σ (j₀ + (m + 1)) - σ j₀)
                = w_rem.length + ((σ (j₀ + 1) - σ j₀) + (σ ((j₀ + 1) + m) - σ (j₀ + 1))) :=
                    congrArg (w_rem.length + ·) block_split.symm
              _ = w_rem.length + ((σ ((j₀ + 1) + m) - σ (j₀ + 1)) + (σ (j₀ + 1) - σ j₀)) :=
                    congrArg (w_rem.length + ·) (Nat.add_comm _ _)
              _ = (w_rem.length + (σ ((j₀ + 1) + m) - σ (j₀ + 1))) + (σ (j₀ + 1) - σ j₀) :=
                    (Nat.add_assoc _ _ _).symm
              _ = w₂.length + w₁.length := congr (congrArg (· + ·) rem_eq) len₁.symm
              _ = w₁.length + w₂.length := Nat.add_comm _ _
              _ = w.length := sum_len
          ⟨u, w_rem, b :: wR, q_m, total_rem, congrArg Nat.succ rlen, .cons stepQ trR, tr_rem,
            eq_idx ▸ epU, eq_idx ▸ epQm, d_m⟩

end LaxSim

/-! ## Viability kernel transfer theorems -/

/-- **Infinite-horizon certificate transfer**: a macro `Viability.Certificate` plus slack
    absorption `sim.α Δ + sim.ε ≤ Δ` and guard margin certifies a fine `Viability.Kernel`,
    for any `Becoming.Strict σ` (including `σ 0 > 0`). -/
theorem lax_kernel_of_certificate {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M)
    {guardQ : Q → Prop} {K : Q → Prop} {guardS : S → Prop}
    (cert : Viability.Certificate R guardQ K)
    (Δ : Nat) (absorb : sim.α Δ + sim.ε ≤ Δ)
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ sim.β Δ + sim.η → guardS u)
    {s₀ : S} (epoch₀ : sim.Epoch (σ 0) s₀) (init : K (π s₀)) :
    Viability.Kernel P guardS s₀ := by
  intro t ⟨w, tr⟩
  obtain ⟨k, hk_le, hk_lt⟩ := block_of_strict sim.strict (Nat.le_add_right (σ 0) w.length)
  have h0k : σ 0 ≤ σ k := strict_mono_le sim.strict (Nat.zero_le k)
  have hlen : σ (0 + k) - σ 0 ≤ w.length := by
    rw [Nat.zero_add]
    exact Naturals.sub_le_of_le_add hk_le
  have hd0 : M.d (π s₀) (π s₀) ≤ 0 := Nat.le_of_eq (M.refl (π s₀))
  obtain ⟨u, w_rem, _, q_k, rem_eq, _, trR, tr_rem, epU, epQk, d_k⟩ :=
    LaxSim.advance_blocks sim k 0 epoch₀ (sim.epoch_proj 0 s₀ epoch₀) hd0 hlen tr
  rw [Nat.zero_add] at rem_eq epU epQk
  have h_rem_lt : w_rem.length < σ (k + 1) - σ k := by
    apply Naturals.lt_of_add_lt_add_left (k := σ k)
    have eq1 : σ k + w_rem.length = σ 0 + w.length := by
      calc σ k + w_rem.length
          = (σ 0 + (σ k - σ 0)) + w_rem.length := congrArg (· + w_rem.length) (add_sub_of_le h0k).symm
        _ = σ 0 + (σ k - σ 0 + w_rem.length) := Nat.add_assoc _ _ _
        _ = σ 0 + (w_rem.length + (σ k - σ 0)) := congrArg (σ 0 + ·) (Nat.add_comm _ _)
        _ = σ 0 + w.length := congrArg (σ 0 + ·) rem_eq
    rw [eq1]
    exact Nat.lt_of_lt_of_le hk_lt (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (sim.strict k))).symm)
  have d_k_le : M.d (π u) q_k ≤ Δ :=
    Nat.le_trans d_k (LaxSim.slack_le_of_absorb sim.α_mono absorb k 0 (Nat.zero_le Δ))
  have d_ex := sim.excursion k u q_k Δ w_rem t epU epQk d_k_le h_rem_lt tr_rem
  have gQ : guardQ q_k := cert.within q_k (cert.closed.reach ⟨_, trR⟩ init)
  exact margin q_k t gQ d_ex

/-- **Infinite-horizon kernel transfer** directly from `Viability.Kernel R guardQ (π s₀)`. -/
theorem lax_kernel_of_kernel {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M)
    {guardQ : Q → Prop} {guardS : S → Prop}
    (Δ : Nat) (absorb : sim.α Δ + sim.ε ≤ Δ)
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ sim.β Δ + sim.η → guardS u)
    {s₀ : S} (epoch₀ : sim.Epoch (σ 0) s₀) (kernelQ : Viability.Kernel R guardQ (π s₀)) :
    Viability.Kernel P guardS s₀ :=
  match Viability.kernel_iff_certificate.mp kernelQ with
  | ⟨_, init, cert⟩ => lax_kernel_of_certificate sim cert Δ absorb margin epoch₀ init

/-- **Finite-horizon linear-drift transfer (`sim.α = id`, NO `absorb` hypothesis)**:
    protects `guardS` on all traces with `w.length < σ N - σ 0` when `0 < N`, using the
    exact tight margin `sim.β ((N - 1) * sim.ε) + sim.η`. -/
theorem lax_keptFor_linear {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M) (lin : sim.α = id)
    {guardQ : Q → Prop} {K : Q → Prop} {guardS : S → Prop}
    (cert : Viability.Certificate R guardQ K)
    (N : Nat) (hN : 0 < N)
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ sim.β ((N - 1) * sim.ε) + sim.η → guardS u)
    {s₀ : S} (epoch₀ : sim.Epoch (σ 0) s₀) (init : K (π s₀)) :
    ∀ w t, w.length < σ N - σ 0 → Trace P s₀ w t → guardS t := by
  intro w t w_lt tr
  obtain ⟨k, hk_le, hk_lt⟩ := block_of_strict sim.strict (Nat.le_add_right (σ 0) w.length)
  have h0k : σ 0 ≤ σ k := strict_mono_le sim.strict (Nat.zero_le k)
  have h0N : σ 0 ≤ σ N := strict_mono_le sim.strict (Nat.zero_le N)
  have h_len_lt_N : σ 0 + w.length < σ N := by
    have h1 := Nat.add_lt_add_left w_lt (σ 0)
    rw [add_sub_of_le h0N] at h1
    exact h1
  have hk_lt_N : k < N := strict_lt_of_lt sim.strict (Nat.lt_of_le_of_lt hk_le h_len_lt_N)
  have hk_le_N1 : k ≤ N - 1 := by
    match N, hN with
    | n + 1, _ => exact Nat.le_of_lt_succ hk_lt_N
  have hlen : σ (0 + k) - σ 0 ≤ w.length := by
    rw [Nat.zero_add]
    exact Naturals.sub_le_of_le_add hk_le
  have hd0 : M.d (π s₀) (π s₀) ≤ 0 := Nat.le_of_eq (M.refl (π s₀))
  obtain ⟨u, w_rem, _, q_k, rem_eq, _, trR, tr_rem, epU, epQk, d_k⟩ :=
    LaxSim.advance_blocks sim k 0 epoch₀ (sim.epoch_proj 0 s₀ epoch₀) hd0 hlen tr
  rw [Nat.zero_add] at rem_eq epU epQk
  have d_k_lin : M.d (π u) q_k ≤ k * sim.ε := by
    have h_sl : LaxSim.slack sim.α sim.ε k 0 = k * sim.ε := by
      rw [lin, LaxSim.slack_id, Nat.zero_add]
    exact h_sl ▸ d_k
  have h_rem_lt : w_rem.length < σ (k + 1) - σ k := by
    apply Naturals.lt_of_add_lt_add_left (k := σ k)
    have eq1 : σ k + w_rem.length = σ 0 + w.length := by
      calc σ k + w_rem.length
          = (σ 0 + (σ k - σ 0)) + w_rem.length := congrArg (· + w_rem.length) (add_sub_of_le h0k).symm
        _ = σ 0 + (σ k - σ 0 + w_rem.length) := Nat.add_assoc _ _ _
        _ = σ 0 + (w_rem.length + (σ k - σ 0)) := congrArg (σ 0 + ·) (Nat.add_comm _ _)
        _ = σ 0 + w.length := congrArg (σ 0 + ·) rem_eq
    rw [eq1]
    exact Nat.lt_of_lt_of_le hk_lt (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (sim.strict k))).symm)
  have d_ex := sim.excursion k u q_k (k * sim.ε) w_rem t epU epQk d_k_lin h_rem_lt tr_rem
  have d_bound : M.d (π t) q_k ≤ sim.β ((N - 1) * sim.ε) + sim.η :=
    Nat.le_trans d_ex (Nat.add_le_add_right (sim.β_mono (Nat.mul_le_mul_right sim.ε hk_le_N1)) sim.η)
  have gQ : guardQ q_k := cert.within q_k (cert.closed.reach ⟨_, trR⟩ init)
  exact margin q_k t gQ d_bound

/-- Finite-horizon linear-drift transfer from `Viability.Kernel R guardQ (π s₀)`. -/
theorem lax_keptFor_linear_of_kernel {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M) (lin : sim.α = id)
    {guardQ : Q → Prop} {guardS : S → Prop}
    (N : Nat) (hN : 0 < N)
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ sim.β ((N - 1) * sim.ε) + sim.η → guardS u)
    {s₀ : S} (epoch₀ : sim.Epoch (σ 0) s₀) (kernelQ : Viability.Kernel R guardQ (π s₀)) :
    ∀ w t, w.length < σ N - σ 0 → Trace P s₀ w t → guardS t :=
  match Viability.kernel_iff_certificate.mp kernelQ with
  | ⟨_, init, cert⟩ => lax_keptFor_linear sim lin cert N hN margin epoch₀ init

/-! ## Vertical composition along multi-scale towers -/

namespace LaxSim

private theorem run_window_length {S : Type u} {A : Type v} {P : Process S A} (r : Run P) :
    ∀ n k, (r.window n k).length = k
  | _, 0 => rfl
  | n, k + 1 => congrArg Nat.succ (run_window_length r (n + 1) k)

/-- Finite-horizon linear-drift transfer stated directly along a `Run P`. -/
theorem keptFor_linear_run {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Process S A} {R : Process Q B} {π : S → Q} {σ : Nat → Nat} {M : SlackDist Q}
    (sim : LaxSim P R π σ M) (lin : sim.α = id)
    {guardQ : Q → Prop} {K : Q → Prop} {guardS : S → Prop}
    (cert : Viability.Certificate R guardQ K)
    (N : Nat) (hN : 0 < N)
    (margin : ∀ q u, guardQ q → M.d (π u) q ≤ sim.β ((N - 1) * sim.ε) + sim.η → guardS u)
    (r : Run P) (epoch₀ : sim.Epoch (σ 0) (r.state 0)) (init : K (π (r.state 0))) :
    ∀ n, n < σ N - σ 0 → guardS (r.state n) := fun n lt =>
  lax_keptFor_linear sim lin cert N hN margin epoch₀ init (r.window 0 n) (r.state n)
    ((run_window_length r 0 n).symm ▸ lt)
    (Eq.subst (motive := fun k => Trace P (r.state 0) (r.window 0 n) (r.state k))
      (Nat.zero_add n) (r.window_trace n 0))

/-- Shared vertical-composition constructor parameterized by scale-1 block and excursion bounds. -/
private def compOf {S : Type u} {A : Type v} {Q₁ : Type w} {B₁ : Type z}
    {Q₂ : Type u₂} {B₂ : Type v₂}
    {P : Process S A} {R₁ : Process Q₁ B₁} {R₂ : Process Q₂ B₂}
    {π₁ : S → Q₁} {π₂ : Q₁ → Q₂} {σ₁ σ₂ : Nat → Nat}
    {M₁ : SlackDist Q₁} {M₂ : SlackDist Q₂}
    (sim₁ : LaxSim P R₁ π₁ σ₁ M₁) (sim₂ : LaxSim R₁ R₂ π₂ σ₂ M₂)
    (epoch_compat : ∀ j q₁, sim₁.EpochQ j q₁ → sim₂.Epoch j q₁)
    (μ₂ : Nat → Nat) (μ₂_mono : ∀ {a b}, a ≤ b → μ₂ a ≤ μ₂ b)
    (lip₂ : ∀ x y, M₂.d (π₂ x) (π₂ y) ≤ μ₂ (M₁.d x y))
    (Δblock Δex : Nat)
    (bound_block : ∀ k s s' w,
      sim₁.Epoch (σ₁ (σ₂ k)) s → w.length = σ₁ (σ₂ (k + 1)) - σ₁ (σ₂ k) → Trace P s w s' →
      ∃ w₁ q₁', w₁.length = σ₂ (k + 1) - σ₂ k ∧ Trace R₁ (π₁ s) w₁ q₁' ∧ M₁.d (π₁ s') q₁' ≤ Δblock)
    (bound_ex : ∀ k s u w₁,
      sim₁.Epoch (σ₁ (σ₂ k)) s → w₁.length < σ₁ (σ₂ (k + 1)) - σ₁ (σ₂ k) → Trace P s w₁ u →
      ∃ w₁' q₁', w₁'.length < σ₂ (k + 1) - σ₂ k ∧ Trace R₁ (π₁ s) w₁' q₁' ∧ M₁.d (π₁ u) q₁' ≤ Δex) :
    LaxSim P R₂ (fun s => π₂ (π₁ s)) (fun k => σ₁ (σ₂ k)) M₂ where
  strict := sim₁.strict.comp sim₂.strict
  Epoch := sim₁.Epoch
  EpochQ := sim₂.EpochQ
  epoch_step := sim₁.epoch_step
  epoch_proj k s ep :=
    sim₂.epoch_proj k (π₁ s) (epoch_compat (σ₂ k) (π₁ s) (sim₁.epoch_proj (σ₂ k) s ep))
  α := sim₂.α
  β := sim₂.β
  α_mono := sim₂.α_mono
  β_mono := sim₂.β_mono
  β_ge_id := sim₂.β_ge_id
  ε := sim₂.ε + μ₂ Δblock
  η := sim₂.η + μ₂ Δex
  sim_block k s q₂ r w s' epS epQ₂ d_le w_len tr :=
    match bound_block k s s' w epS w_len tr with
    | ⟨w₁, q₁', w₁_len, tr₁, d₁_le⟩ =>
      have epS₂ : sim₂.Epoch (σ₂ k) (π₁ s) :=
        epoch_compat (σ₂ k) (π₁ s) (sim₁.epoch_proj (σ₂ k) s epS)
      match sim₂.sim_block k (π₁ s) q₂ r w₁ q₁' epS₂ epQ₂ d_le w₁_len tr₁ with
      | ⟨b₂, q₂', step₂, epQ₂', d₂_le⟩ =>
        ⟨b₂, q₂', step₂, epQ₂',
          Nat.le_trans (M₂.tri (π₂ (π₁ s')) (π₂ q₁') q₂')
            (Nat.le_trans
              (Nat.add_le_add (Nat.le_trans (lip₂ (π₁ s') q₁') (μ₂_mono d₁_le)) d₂_le)
              (Nat.le_of_eq ((Nat.add_comm (μ₂ Δblock) (sim₂.α r + sim₂.ε)).trans
                (Nat.add_assoc (sim₂.α r) sim₂.ε (μ₂ Δblock)))))⟩
  excursion k s q₂ r w₁ u epS epQ₂ d_le w₁_lt tr :=
    match bound_ex k s u w₁ epS w₁_lt tr with
    | ⟨w₁', q₁', w₁'_lt, tr₁, d₁_le⟩ =>
      have epS₂ : sim₂.Epoch (σ₂ k) (π₁ s) :=
        epoch_compat (σ₂ k) (π₁ s) (sim₁.epoch_proj (σ₂ k) s epS)
      have d₂_ex := sim₂.excursion k (π₁ s) q₂ r w₁' q₁' epS₂ epQ₂ d_le w₁'_lt tr₁
      Nat.le_trans (M₂.tri (π₂ (π₁ u)) (π₂ q₁') q₂)
        (Nat.le_trans
          (Nat.add_le_add (Nat.le_trans (lip₂ (π₁ u) q₁') (μ₂_mono d₁_le)) d₂_ex)
          (Nat.le_of_eq ((Nat.add_comm (μ₂ Δex) (sim₂.β r + sim₂.η)).trans
            (Nat.add_assoc (sim₂.β r) sim₂.η (μ₂ Δex)))))

/-- Helper: decomposing a fine trace inside one macro block `[σ₁ (σ₂ k), σ₁ (σ₂ (k + 1)))`
    into `i < σ₂ (k + 1) - σ₂ k` scale-1 blocks plus a sub-block remainder. -/
private theorem macro_excursion_split {S : Type u} {A : Type v} {Q₁ : Type w} {B₁ : Type z}
    {P : Process S A} {R₁ : Process Q₁ B₁}
    {π₁ : S → Q₁} {σ₁ σ₂ : Nat → Nat} {M₁ : SlackDist Q₁}
    (sim₁ : LaxSim P R₁ π₁ σ₁ M₁) (strict₂ : Strict σ₂)
    {k : Nat} {s u : S} {w₁ : List A}
    (epS : sim₁.Epoch (σ₁ (σ₂ k)) s)
    (w₁_lt : w₁.length < σ₁ (σ₂ (k + 1)) - σ₁ (σ₂ k))
    (tr : Trace P s w₁ u) :
    ∃ (i : Nat) (s_i : S) (w_rem : List A) (w₁' : List B₁) (q₁' : Q₁),
      i < σ₂ (k + 1) - σ₂ k ∧
      w₁'.length = i ∧
      Trace R₁ (π₁ s) w₁' q₁' ∧
      w_rem.length < σ₁ (σ₂ k + i + 1) - σ₁ (σ₂ k + i) ∧
      Trace P s_i w_rem u ∧
      sim₁.Epoch (σ₁ (σ₂ k + i)) s_i ∧
      sim₁.EpochQ (σ₂ k + i) q₁' ∧
      M₁.d (π₁ s_i) q₁' ≤ slack sim₁.α sim₁.ε i 0 := by
  have hk_lt_k1 : σ₂ k < σ₂ (k + 1) := strict₂ k
  have hσ_le : σ₁ (σ₂ k) ≤ σ₁ (σ₂ (k + 1)) := strict_mono_le sim₁.strict (Nat.le_of_lt hk_lt_k1)
  have h_pos_le : σ₁ 0 ≤ σ₁ (σ₂ k) + w₁.length :=
    Nat.le_trans (strict_mono_le sim₁.strict (Nat.zero_le (σ₂ k))) (Nat.le_add_right _ _)
  obtain ⟨j, hj_le, hj_lt⟩ := block_of_strict sim₁.strict h_pos_le
  have h_tot_lt : σ₁ (σ₂ k) + w₁.length < σ₁ (σ₂ (k + 1)) :=
    Nat.lt_of_lt_of_le (Nat.add_lt_add_left w₁_lt (σ₁ (σ₂ k))) (Nat.le_of_eq (add_sub_of_le hσ_le))
  have h_σk_le_j : σ₂ k ≤ j :=
    Nat.le_of_lt_succ (strict_lt_of_lt sim₁.strict (Nat.lt_of_le_of_lt (Nat.le_add_right _ _) hj_lt))
  have h_j_lt_σk1 : j < σ₂ (k + 1) :=
    strict_lt_of_lt sim₁.strict (Nat.lt_of_le_of_lt hj_le h_tot_lt)
  obtain ⟨i, hi_eq⟩ := le_dest h_σk_le_j
  have hi_lt : i < σ₂ (k + 1) - σ₂ k :=
    Naturals.lt_of_add_lt_add_left (k := σ₂ k)
      (Nat.lt_of_lt_of_le (hi_eq ▸ h_j_lt_σk1)
        (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt hk_lt_k1)).symm))
  have h_base_le : σ₁ (σ₂ k) ≤ σ₁ (σ₂ k + i) :=
    strict_mono_le sim₁.strict (Nat.le_add_right _ _)
  have h_len_ge : σ₁ (σ₂ k + i) - σ₁ (σ₂ k) ≤ w₁.length :=
    Naturals.sub_le_of_le_add (hi_eq ▸ hj_le)
  have hd0 : M₁.d (π₁ s) (π₁ s) ≤ 0 := Nat.le_of_eq (M₁.refl (π₁ s))
  obtain ⟨s_i, w_rem, w₁', q₁', rem_eq, w₁'_len, tr₁, tr_rem, epSi, epQ₁, d_i⟩ :=
    advance_blocks sim₁ i (σ₂ k) epS (sim₁.epoch_proj (σ₂ k) s epS) hd0 h_len_ge tr
  have h_rem_lt : w_rem.length < σ₁ (σ₂ k + i + 1) - σ₁ (σ₂ k + i) := by
    apply Naturals.lt_of_add_lt_add_left (k := σ₁ (σ₂ k + i))
    have eq1 : σ₁ (σ₂ k + i) + w_rem.length = σ₁ (σ₂ k) + w₁.length := by
      calc σ₁ (σ₂ k + i) + w_rem.length
          = (σ₁ (σ₂ k) + (σ₁ (σ₂ k + i) - σ₁ (σ₂ k))) + w_rem.length :=
              congrArg (· + w_rem.length) (add_sub_of_le h_base_le).symm
        _ = σ₁ (σ₂ k) + ((σ₁ (σ₂ k + i) - σ₁ (σ₂ k)) + w_rem.length) := Nat.add_assoc _ _ _
        _ = σ₁ (σ₂ k) + (w_rem.length + (σ₁ (σ₂ k + i) - σ₁ (σ₂ k))) :=
              congrArg (σ₁ (σ₂ k) + ·) (Nat.add_comm _ _)
        _ = σ₁ (σ₂ k) + w₁.length := congrArg (σ₁ (σ₂ k) + ·) rem_eq
    rw [eq1]
    have hj_lt' : σ₁ (σ₂ k) + w₁.length < σ₁ (σ₂ k + i + 1) := hi_eq ▸ hj_lt
    exact Nat.lt_of_lt_of_le hj_lt'
      (Nat.le_of_eq (add_sub_of_le (Nat.le_of_lt (sim₁.strict (σ₂ k + i)))).symm)
  exact ⟨i, s_i, w_rem, w₁', q₁', hi_lt, w₁'_len, tr₁, h_rem_lt, tr_rem, epSi, epQ₁, d_i⟩

/-- **Vertical composition — general contractive scale-1 mode**:
    requires `epoch_compat`, Lipschitz modulus `μ₂` with `μ₂_mono`, and `sim₁.α Δ₁ + sim₁.ε ≤ Δ₁`. -/
def comp {S : Type u} {A : Type v} {Q₁ : Type w} {B₁ : Type z}
    {Q₂ : Type u₂} {B₂ : Type v₂}
    {P : Process S A} {R₁ : Process Q₁ B₁} {R₂ : Process Q₂ B₂}
    {π₁ : S → Q₁} {π₂ : Q₁ → Q₂} {σ₁ σ₂ : Nat → Nat}
    {M₁ : SlackDist Q₁} {M₂ : SlackDist Q₂}
    (sim₁ : LaxSim P R₁ π₁ σ₁ M₁) (sim₂ : LaxSim R₁ R₂ π₂ σ₂ M₂)
    (epoch_compat : ∀ j q₁, sim₁.EpochQ j q₁ → sim₂.Epoch j q₁)
    (μ₂ : Nat → Nat) (μ₂_mono : ∀ {a b}, a ≤ b → μ₂ a ≤ μ₂ b)
    (lip₂ : ∀ x y, M₂.d (π₂ x) (π₂ y) ≤ μ₂ (M₁.d x y))
    (Δ₁ : Nat) (absorb₁ : sim₁.α Δ₁ + sim₁.ε ≤ Δ₁) :
    LaxSim P R₂ (fun s => π₂ (π₁ s)) (fun k => σ₁ (σ₂ k)) M₂ :=
  compOf sim₁ sim₂ epoch_compat μ₂ μ₂_mono lip₂ Δ₁ (sim₁.β Δ₁ + sim₁.η)
    (fun k s s' w epS w_len tr =>
      let m := σ₂ (k + 1) - σ₂ k
      have hm_eq : σ₂ k + m = σ₂ (k + 1) := add_sub_of_le (Nat.le_of_lt (sim₂.strict k))
      have h_len_ge : σ₁ (σ₂ k + m) - σ₁ (σ₂ k) ≤ w.length :=
        Nat.le_of_eq ((congrArg (fun x => σ₁ x - σ₁ (σ₂ k)) hm_eq).trans w_len.symm)
      have hd0 : M₁.d (π₁ s) (π₁ s) ≤ 0 := Nat.le_of_eq (M₁.refl (π₁ s))
      match advance_blocks sim₁ m (σ₂ k) epS (sim₁.epoch_proj (σ₂ k) s epS) hd0 h_len_ge tr with
      | ⟨u, w_rem, w₁, q₁', rem_eq, w₁_len, tr₁, tr_rem, _, _, d_m⟩ =>
        have h_rem_zero : w_rem.length = 0 := by
          apply add_right_cancel (σ₁ (σ₂ (k + 1)) - σ₁ (σ₂ k))
          have h1 : w_rem.length + (σ₁ (σ₂ (k + 1)) - σ₁ (σ₂ k)) = w.length := by
            rw [← hm_eq]
            exact rem_eq
          rw [h1, w_len, Nat.zero_add]
        match w_rem, h_rem_zero, tr_rem with
        | [], _, .nil _ =>
          ⟨w₁, q₁', w₁_len, tr₁,
            Nat.le_trans d_m (slack_le_of_absorb sim₁.α_mono absorb₁ m 0 (Nat.zero_le Δ₁))⟩)
    (fun k s u w₁ epS w₁_lt tr =>
      match macro_excursion_split sim₁ sim₂.strict epS w₁_lt tr with
      | ⟨i, s_i, w_rem, w₁', q₁', hi_lt, w₁'_len, tr₁, h_rem_lt, tr_rem, epSi, epQ₁, d_i⟩ =>
        have d_i_le : M₁.d (π₁ s_i) q₁' ≤ Δ₁ :=
          Nat.le_trans d_i (slack_le_of_absorb sim₁.α_mono absorb₁ i 0 (Nat.zero_le Δ₁))
        ⟨w₁', q₁', w₁'_len ▸ hi_lt, tr₁,
          sim₁.excursion (σ₂ k + i) s_i q₁' Δ₁ w_rem u epSi epQ₁ d_i_le h_rem_lt tr_rem⟩)

/-- **Vertical composition — bounded-stride additive scale-1 mode**:
    when `sim₁.α = id` and `∀ k, σ₂ (k + 1) - σ₂ k ≤ Mstride`, gives
    `ε := sim₂.ε + μ₂ (Mstride * sim₁.ε)` and the tight excursion bound
    `η := sim₂.η + μ₂ (sim₁.β ((Mstride - 1) * sim₁.ε) + sim₁.η)`. -/
def compAdditive {S : Type u} {A : Type v} {Q₁ : Type w} {B₁ : Type z}
    {Q₂ : Type u₂} {B₂ : Type v₂}
    {P : Process S A} {R₁ : Process Q₁ B₁} {R₂ : Process Q₂ B₂}
    {π₁ : S → Q₁} {π₂ : Q₁ → Q₂} {σ₁ σ₂ : Nat → Nat}
    {M₁ : SlackDist Q₁} {M₂ : SlackDist Q₂}
    (sim₁ : LaxSim P R₁ π₁ σ₁ M₁) (sim₂ : LaxSim R₁ R₂ π₂ σ₂ M₂)
    (epoch_compat : ∀ j q₁, sim₁.EpochQ j q₁ → sim₂.Epoch j q₁)
    (μ₂ : Nat → Nat) (μ₂_mono : ∀ {a b}, a ≤ b → μ₂ a ≤ μ₂ b)
    (lip₂ : ∀ x y, M₂.d (π₂ x) (π₂ y) ≤ μ₂ (M₁.d x y))
    (lin₁ : sim₁.α = id) (Mstride : Nat)
    (stride_bound : ∀ k, σ₂ (k + 1) - σ₂ k ≤ Mstride) :
    LaxSim P R₂ (fun s => π₂ (π₁ s)) (fun k => σ₁ (σ₂ k)) M₂ :=
  have hM_pos : 0 < Mstride :=
    Nat.lt_of_lt_of_le (SupportGated.sub_pos_of_lt (sim₂.strict 0)) (stride_bound 0)
  compOf sim₁ sim₂ epoch_compat μ₂ μ₂_mono lip₂
    (Mstride * sim₁.ε) (sim₁.β ((Mstride - 1) * sim₁.ε) + sim₁.η)
    (fun k s s' w epS w_len tr =>
      let m := σ₂ (k + 1) - σ₂ k
      have hm_eq : σ₂ k + m = σ₂ (k + 1) := add_sub_of_le (Nat.le_of_lt (sim₂.strict k))
      have h_len_ge : σ₁ (σ₂ k + m) - σ₁ (σ₂ k) ≤ w.length :=
        Nat.le_of_eq ((congrArg (fun x => σ₁ x - σ₁ (σ₂ k)) hm_eq).trans w_len.symm)
      have hd0 : M₁.d (π₁ s) (π₁ s) ≤ 0 := Nat.le_of_eq (M₁.refl (π₁ s))
      match advance_blocks sim₁ m (σ₂ k) epS (sim₁.epoch_proj (σ₂ k) s epS) hd0 h_len_ge tr with
      | ⟨u, w_rem, w₁, q₁', rem_eq, w₁_len, tr₁, tr_rem, _, _, d_m⟩ =>
        have h_rem_zero : w_rem.length = 0 := by
          apply add_right_cancel (σ₁ (σ₂ (k + 1)) - σ₁ (σ₂ k))
          have h1 : w_rem.length + (σ₁ (σ₂ (k + 1)) - σ₁ (σ₂ k)) = w.length := by
            rw [← hm_eq]
            exact rem_eq
          rw [h1, w_len, Nat.zero_add]
        match w_rem, h_rem_zero, tr_rem with
        | [], _, .nil _ =>
          have h_sl : slack sim₁.α sim₁.ε m 0 = m * sim₁.ε := by
            rw [lin₁, slack_id, Nat.zero_add]
          ⟨w₁, q₁', w₁_len, tr₁,
            Nat.le_trans d_m (Nat.le_trans (Nat.le_of_eq h_sl)
              (Nat.mul_le_mul_right sim₁.ε (stride_bound k)))⟩)
    (fun k s u w₁ epS w₁_lt tr =>
      match macro_excursion_split sim₁ sim₂.strict epS w₁_lt tr with
      | ⟨i, s_i, w_rem, w₁', q₁', hi_lt, w₁'_len, tr₁, h_rem_lt, tr_rem, epSi, epQ₁, d_i⟩ =>
        have hi_lt_M : i < Mstride := Nat.lt_of_lt_of_le hi_lt (stride_bound k)
        have hi_le_M1 : i ≤ Mstride - 1 := by
          match Mstride, hM_pos, hi_lt_M with
          | m + 1, _, hlt => exact Nat.le_of_lt_succ hlt
        have d_i_lin : M₁.d (π₁ s_i) q₁' ≤ i * sim₁.ε := by
          have h_sl : slack sim₁.α sim₁.ε i 0 = i * sim₁.ε := by
            rw [lin₁, slack_id, Nat.zero_add]
          exact h_sl ▸ d_i
        have d_ex := sim₁.excursion (σ₂ k + i) s_i q₁' (i * sim₁.ε) w_rem u epSi epQ₁
          d_i_lin h_rem_lt tr_rem
        ⟨w₁', q₁', w₁'_len ▸ hi_lt, tr₁,
          Nat.le_trans d_ex
            (Nat.add_le_add_right (sim₁.β_mono (Nat.mul_le_mul_right sim₁.ε hi_le_M1)) sim₁.η)⟩)

/-! ## Tower adapter -/

private theorem comp_epoch {S : Type u} {A : Type v} {Q₁ : Type w} {B₁ : Type z}
    {Q₂ : Type u₂} {B₂ : Type v₂}
    {P : Process S A} {R₁ : Process Q₁ B₁} {R₂ : Process Q₂ B₂}
    {π₁ : S → Q₁} {π₂ : Q₁ → Q₂} {σ₁ σ₂ : Nat → Nat}
    {M₁ : SlackDist Q₁} {M₂ : SlackDist Q₂}
    (sim₁ : LaxSim P R₁ π₁ σ₁ M₁) (sim₂ : LaxSim R₁ R₂ π₂ σ₂ M₂)
    (epoch_compat : ∀ j q₁, sim₁.EpochQ j q₁ → sim₂.Epoch j q₁)
    (μ₂ : Nat → Nat) (μ₂_mono : ∀ {a b}, a ≤ b → μ₂ a ≤ μ₂ b)
    (lip₂ : ∀ x y, M₂.d (π₂ x) (π₂ y) ≤ μ₂ (M₁.d x y))
    (Δ₁ : Nat) (absorb₁ : sim₁.α Δ₁ + sim₁.ε ≤ Δ₁) :
    (comp sim₁ sim₂ epoch_compat μ₂ μ₂_mono lip₂ Δ₁ absorb₁).Epoch = sim₁.Epoch :=
  rfl

/-- Bundled result of composing `n + 1` tower levels down to level `0`. -/
structure TowerSimPack {F C : Type} [DecidableEq F] (T : Tower F C)
    (S_at : Nat → Type) (A_at : Nat → Type)
    (P_at : ∀ n, Process (S_at n) (A_at n))
    (M_at : ∀ n, SlackDist (S_at n))
    (epoch_at : ∀ n, Nat → S_at (n + 1) → Prop)
    (n : Nat) where
  π : S_at (n + 1) → S_at 0
  sim : LaxSim (P_at (n + 1)) (P_at 0) π (T.reads (n + 1)) (M_at 0)
  ep_eq : sim.Epoch = epoch_at n
  μ : Nat → Nat
  μ_mono : ∀ {a b}, a ≤ b → μ a ≤ μ b
  lip : ∀ x y, (M_at 0).d (π x) (π y) ≤ μ ((M_at (n + 1)).d x y)

/-- Recursive composition of contractive simulations along a `Becoming.Tower`, producing a
    simulation from level `n + 1` to level `0` along `T.reads (n + 1)`. -/
def towerSim {F C : Type} [DecidableEq F] (T : Tower F C)
    (S_at : Nat → Type) (A_at : Nat → Type)
    (P_at : ∀ n, Process (S_at n) (A_at n))
    (π_step : ∀ n, S_at (n + 1) → S_at n)
    (M_at : ∀ n, SlackDist (S_at n))
    (sim_step : ∀ n, LaxSim (P_at (n + 1)) (P_at n) (π_step n) (T.refine n) (M_at n))
    (compat : ∀ n j q, (sim_step (n + 1)).EpochQ j q → (sim_step n).Epoch j q)
    (μ_step : Nat → Nat → Nat)
    (μ_mono : ∀ n {a b}, a ≤ b → μ_step n a ≤ μ_step n b)
    (lip : ∀ n x y, (M_at n).d (π_step n x) (π_step n y) ≤ μ_step n ((M_at (n + 1)).d x y))
    (Δ_step : Nat → Nat)
    (absorb : ∀ n, (sim_step (n + 1)).α (Δ_step n) + (sim_step (n + 1)).ε ≤ Δ_step n) :
    ∀ n, TowerSimPack T S_at A_at P_at M_at (fun k => (sim_step k).Epoch) n
  | 0 =>
    { π := π_step 0
      sim := sim_step 0
      ep_eq := rfl
      μ := μ_step 0
      μ_mono := fun le => μ_mono 0 le
      lip := lip 0 }
  | n + 1 =>
    let pack := towerSim T S_at A_at P_at π_step M_at sim_step compat μ_step μ_mono lip Δ_step absorb n
    let compat' : ∀ j q, (sim_step (n + 1)).EpochQ j q → pack.sim.Epoch j q :=
      fun j q hq => Eq.mpr (congrFun (congrFun pack.ep_eq j) q) (compat n j q hq)
    let sim' := comp (sim_step (n + 1)) pack.sim compat'
      pack.μ (fun le => pack.μ_mono le) pack.lip (Δ_step n) (absorb n)
    { π := fun s => pack.π (π_step (n + 1) s)
      sim := sim'
      ep_eq := comp_epoch (sim_step (n + 1)) pack.sim compat'
        pack.μ (fun le => pack.μ_mono le) pack.lip (Δ_step n) (absorb n)
      μ := fun d => pack.μ (μ_step (n + 1) d)
      μ_mono := fun le => pack.μ_mono (μ_mono (n + 1) le)
      lip := fun x y =>
        Nat.le_trans (pack.lip (π_step (n + 1) x) (π_step (n + 1) y))
          (pack.μ_mono (lip (n + 1) x y)) }

end LaxSim

/-! ## Concrete two-scale witness (`WitnessTwoScale`) -/

namespace WitnessTwoScale

/-! ### Arithmetic helpers for `div 2`, `mod 2`, `mod 4`, and `damp` -/

private theorem div_go_irrel (y : Nat) (hy : 0 < y) :
    ∀ (f₁ : Nat) {f₂ x : Nat} (h₁ : x < f₁) (h₂ : x < f₂),
      Nat.div.go y hy f₁ x h₁ = Nat.div.go y hy f₂ x h₂
  | 0, _, _, h₁, _ => absurd h₁ (Nat.not_lt_zero _)
  | f₁ + 1, 0, _, _, h₂ => absurd h₂ (Nat.not_lt_zero _)
  | f₁ + 1, f₂ + 1, x, h₁, h₂ => by
    rw [Nat.div.go.eq_1, Nat.div.go.eq_1]
    split
    · exact congrArg (· + 1) (div_go_irrel y hy f₁ _ _)
    · rfl

private theorem mod_go_irrel (y : Nat) (hy : 0 < y) :
    ∀ (f₁ : Nat) {f₂ x : Nat} (h₁ : x < f₁) (h₂ : x < f₂),
      Nat.modCore.go y hy f₁ x h₁ = Nat.modCore.go y hy f₂ x h₂
  | 0, _, _, h₁, _ => absurd h₁ (Nat.not_lt_zero _)
  | f₁ + 1, 0, _, _, h₂ => absurd h₂ (Nat.not_lt_zero _)
  | f₁ + 1, f₂ + 1, x, h₁, h₂ => by
    rw [Nat.modCore.go.eq_1, Nat.modCore.go.eq_1]
    split
    · exact mod_go_irrel y hy f₁ _ _
    · rfl

private theorem div_add_self (y : Nat) (hy : 0 < y) (x : Nat) : (x + y) / y = x / y + 1 := by
  change (x + y).div y = x.div y + 1
  rw [Nat.div.eq_1 (x + y) y, Nat.div.eq_1 x y]
  split
  · rw [Nat.div.go.eq_1]
    have hle : y ≤ x + y := Nat.le_add_left y x
    split
    · have aux : ∀ {z} (eq : z = x) (hz : z < x + y),
          Nat.div.go y hy (x + y) z hz = Nat.div.go y hy x.succ x (Nat.lt_succ_self x) := by
        intro z eq hz; cases eq; exact div_go_irrel y hy (x + y) hz (Nat.lt_succ_self x)
      exact congrArg (· + 1) (aux (Naturals.add_sub_cancel x y) _)
    · exact absurd hle ‹_›
  · exact absurd hy ‹_›

private theorem ite_pos' {c : Prop} [h : Decidable c] (hc : c) {α : Sort u} {t e : α} :
    (if c then t else e) = t :=
  match h with
  | isTrue _ => rfl
  | isFalse hn => absurd hc hn

private theorem ite_neg' {c : Prop} [h : Decidable c] (hc : ¬ c) {α : Sort u} {t e : α} :
    (if c then t else e) = e :=
  match h with
  | isTrue ht => absurd ht hc
  | isFalse _ => rfl

private theorem dite_pos' {c : Prop} [h : Decidable c] (hc : c) {α : Sort u} {t : c → α} {e : ¬ c → α} :
    (if hc' : c then t hc' else e hc') = t hc :=
  match h with
  | isTrue _ => rfl
  | isFalse hn => absurd hc hn

private theorem dite_neg' {c : Prop} [h : Decidable c] (hc : ¬ c) {α : Sort u} {t : c → α} {e : ¬ c → α} :
    (if hc' : c then t hc' else e hc') = e hc :=
  match h with
  | isTrue ht => absurd ht hc
  | isFalse _ => rfl

private theorem mod_add_self (y : Nat) (hy : 0 < y) (x : Nat) : (x + y) % y = x % y := by
  change (x + y).mod y = x.mod y
  cases y with
  | zero => exact absurd hy (Nat.lt_irrefl 0)
  | succ y' =>
    have hxy : x + y'.succ = (x + y').succ := rfl
    rw [hxy, Nat.mod.eq_2]
    have hle : y'.succ ≤ (x + y').succ := Nat.le_add_left y'.succ x
    rw [ite_pos' hle, Nat.modCore.eq_1, dite_pos' hy, Nat.modCore.go.eq_1, dite_pos' hle]
    have aux : ∀ {z} (eq : z = x) (hz : z < (x + y').succ),
        Nat.modCore.go y'.succ hy (x + y').succ z hz =
          Nat.modCore.go y'.succ hy x.succ x (Nat.lt_succ_self x) := by
      intro z eq hz; cases eq; exact mod_go_irrel y'.succ hy (x + y').succ hz (Nat.lt_succ_self x)
    have hsub : (x + y').succ - y'.succ = x := Naturals.add_sub_cancel x y'.succ
    rw [aux hsub _]
    cases x with
    | zero =>
      rw [Nat.mod.eq_1, Nat.modCore.go.eq_1]
      exact dite_neg' (Nat.not_le_of_gt hy)
    | succ x' =>
      rw [Nat.mod.eq_2]
      split
      · rw [Nat.modCore.eq_1, dite_pos' hy]
      · rw [Nat.modCore.go.eq_1]; exact dite_neg' ‹_›

private theorem div2_add2 (n : Nat) : (n + 2) / 2 = n / 2 + 1 := div_add_self 2 (Nat.succ_pos 1) n

private theorem mod2_add2 (n : Nat) : (n + 2) % 2 = n % 2 := mod_add_self 2 (Nat.succ_pos 1) n

private theorem mod4_add4 (n : Nat) : (n + 4) % 4 = n % 4 := mod_add_self 4 (Nat.succ_pos 3) n

private theorem div2_rem : ∀ n : Nat, ∃ q r, n = 2 * q + r ∧ r < 2
  | 0 => ⟨0, 0, rfl, Nat.succ_pos 1⟩
  | 1 => ⟨0, 1, rfl, Nat.lt_succ_self 1⟩
  | n + 2 =>
    match div2_rem n with
    | ⟨q, r, eq, lt⟩ =>
      ⟨q + 1, r, by
        rw [Nat.mul_succ, Nat.add_right_comm (2 * q) 2 r, ← eq], lt⟩

private theorem div4_rem : ∀ n : Nat, ∃ q r, n = 4 * q + r ∧ r < 4
  | 0 => ⟨0, 0, rfl, by decide⟩
  | 1 => ⟨0, 1, rfl, by decide⟩
  | 2 => ⟨0, 2, rfl, by decide⟩
  | 3 => ⟨0, 3, rfl, by decide⟩
  | n + 4 =>
    match div4_rem n with
    | ⟨q, r, eq, lt⟩ =>
      ⟨q + 1, r, by
        rw [Nat.mul_succ, Nat.add_right_comm (4 * q) 4 r, ← eq], lt⟩

private theorem div2_of_two_mul_add {r : Nat} (hr : r < 2) : ∀ q, (2 * q + r) / 2 = q
  | 0 =>
    match r, hr with
    | 0, _ => rfl
    | 1, _ => rfl
    | _ + 2, hr => absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))
  | q + 1 => by
    rw [Nat.mul_succ, Nat.add_right_comm (2 * q) 2 r, div2_add2, div2_of_two_mul_add hr q]

private theorem mod2_of_two_mul_add {r : Nat} (hr : r < 2) : ∀ q, (2 * q + r) % 2 = r
  | 0 =>
    match r, hr with
    | 0, _ => rfl
    | 1, _ => rfl
    | _ + 2, hr => absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))
  | q + 1 => by
    rw [Nat.mul_succ, Nat.add_right_comm (2 * q) 2 r, mod2_add2, mod2_of_two_mul_add hr q]

private theorem mod4_of_four_mul_add {r : Nat} (hr : r < 4) : ∀ q, (4 * q + r) % 4 = r
  | 0 =>
    match r, hr with
    | 0, _ => rfl
    | 1, _ => rfl
    | 2, _ => rfl
    | 3, _ => rfl
    | _ + 4, hr => absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 4 _))
  | q + 1 => by
    rw [Nat.mul_succ, Nat.add_right_comm (4 * q) 4 r, mod4_add4, mod4_of_four_mul_add hr q]

private theorem div2_of_four_mul_add (r : Nat) : ∀ q, (4 * q + r) / 2 = 2 * q + r / 2
  | 0 => (Nat.zero_add r).symm ▸ (Nat.zero_add (r / 2)).symm
  | q + 1 => by
    rw [Nat.mul_succ, Nat.add_right_comm (4 * q) 4 r]
    show (4 * q + r + 2 + 2) / 2 = 2 * (q + 1) + r / 2
    rw [div2_add2, div2_add2, div2_of_four_mul_add r q, Nat.mul_succ, Nat.add_right_comm (2 * q) (r / 2) 2]

private theorem div2_mono {a b : Nat} (le : a ≤ b) : a / 2 ≤ b / 2 := by
  obtain ⟨qa, ra, ha, hra⟩ := div2_rem a
  obtain ⟨qb, rb, hb, hrb⟩ := div2_rem b
  rw [ha, hb, div2_of_two_mul_add hra qa, div2_of_two_mul_add hrb qb]
  match Nat.lt_or_ge qb qa with
  | .inr ge => exact ge
  | .inl lt =>
    have h1 : 2 * qb + rb < 2 * qa + ra := by
      have hqb1 : qb + 1 ≤ qa := lt
      have hrb1 : rb ≤ 1 := Nat.le_of_lt_succ hrb
      have hmul : 2 * qb + 2 ≤ 2 * qa := by
        rw [← Nat.mul_succ]
        exact Nat.mul_le_mul_left 2 hqb1
      exact Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt (Nat.add_le_add_left hrb1 (2 * qb))
        (Nat.add_lt_add_left (by decide : 1 < 2) (2 * qb)))
        (Nat.le_trans hmul (Nat.le_add_right _ _))
    exact absurd (ha ▸ hb ▸ le) (Nat.not_le_of_gt h1)

private theorem div2_add_le (u d : Nat) : (u + d) / 2 ≤ u / 2 + (d + 1) / 2 := by
  obtain ⟨qu, ru, hu, hru⟩ := div2_rem u
  obtain ⟨qd, rd, hd, hrd⟩ := div2_rem d
  rw [hu, hd, div2_of_two_mul_add hru qu]
  have sum_eq : 2 * qu + ru + (2 * qd + rd) = 2 * (qu + qd) + (ru + rd) := by
    rw [Nat.left_distrib 2 qu qd, Nat.add_assoc (2 * qu) ru _,
      Nat.add_left_comm ru (2 * qd) rd, ← Nat.add_assoc]
  rw [sum_eq]
  match ru, hru, rd, hrd with
  | 0, _, 0, _ =>
    rw [div2_of_two_mul_add (by decide : 0 < 2) (qu + qd),
      div2_of_two_mul_add (by decide : 1 < 2) qd]
    exact Nat.le_refl _
  | 0, _, 1, _ =>
    rw [div2_of_two_mul_add (by decide : 1 < 2) (qu + qd)]
    have h2 : (2 * qd + 1 + 1) / 2 = qd + 1 := by
      rw [Nat.add_assoc, ← Nat.mul_succ]
      exact div2_of_two_mul_add (by decide : 0 < 2) (qd + 1)
    rw [h2]
    exact Nat.le_succ _
  | 1, _, 0, _ =>
    rw [div2_of_two_mul_add (by decide : 1 < 2) (qu + qd),
      div2_of_two_mul_add (by decide : 1 < 2) qd]
    exact Nat.le_refl _
  | 1, _, 1, _ =>
    have h1 : (2 * (qu + qd) + (1 + 1)) / 2 = qu + qd + 1 := by
      rw [← Nat.mul_succ]
      exact div2_of_two_mul_add (by decide : 0 < 2) (qu + qd + 1)
    have h2 : (2 * qd + 1 + 1) / 2 = qd + 1 := by
      rw [Nat.add_assoc, ← Nat.mul_succ]
      exact div2_of_two_mul_add (by decide : 0 < 2) (qd + 1)
    rw [h1, h2, Nat.add_assoc]
    exact Nat.le_refl _
  | _ + 2, h, _, _ => exact absurd h (Nat.not_lt_of_ge (Nat.le_add_left 2 _))
  | _, _, _ + 2, h => exact absurd h (Nat.not_lt_of_ge (Nat.le_add_left 2 _))

private theorem add_div2_le (a b : Nat) : a / 2 + b / 2 ≤ (a + b) / 2 := by
  obtain ⟨qa, ra, ha, hra⟩ := div2_rem a
  obtain ⟨qb, rb, hb, hrb⟩ := div2_rem b
  rw [ha, hb, div2_of_two_mul_add hra qa, div2_of_two_mul_add hrb qb]
  have le_sum : 2 * (qa + qb) ≤ 2 * qa + ra + (2 * qb + rb) := by
    rw [Nat.left_distrib 2 qa qb]
    exact Nat.add_le_add (Nat.le_add_right _ _) (Nat.le_add_right _ _)
  have hq : qa + qb = (2 * (qa + qb)) / 2 :=
    (div2_of_two_mul_add (by decide : 0 < 2) (qa + qb)).symm
  exact hq ▸ div2_mono le_sum

private theorem sub_div2_le_half {a b : Nat} (le : b ≤ a) : a / 2 - b / 2 ≤ (a - b + 1) / 2 := by
  have ha : a = b + (a - b) := (add_sub_of_le le).symm
  have h1 : a / 2 ≤ b / 2 + (a - b + 1) / 2 :=
    Nat.le_trans (Nat.le_of_eq (congrArg (· / 2) ha)) (div2_add_le b (a - b))
  exact Naturals.sub_le_of_le_add h1

private theorem succ_div2_le_self : ∀ d : Nat, 0 < d → (d + 1) / 2 ≤ d
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | d, pos => by
    obtain ⟨q, r, eq, hr⟩ := div2_rem d
    match r, hr with
    | 0, _ =>
      match q with
      | 0 => exact absurd (eq ▸ pos : 0 < 2 * 0 + 0) (Nat.lt_irrefl 0)
      | q' + 1 =>
        rw [eq, Nat.add_zero]
        rw [div2_of_two_mul_add (by decide : 1 < 2) (q' + 1)]
        rw [Nat.two_mul (q' + 1)]
        exact Nat.le_add_left (q' + 1) (q' + 1)
    | 1, _ =>
      rw [eq, Nat.add_assoc, show (1 : Nat) + 1 = 2 from rfl, ← Nat.mul_succ]
      have h0 : (2 * (q + 1)) / 2 = q + 1 := by
        rw [← Nat.add_zero (2 * (q + 1))]
        exact div2_of_two_mul_add (by decide : 0 < 2) (q + 1)
      rw [h0, Nat.two_mul q, Nat.add_assoc]
      exact Nat.le_add_left (q + 1) q
    | _ + 2, hr => exact absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))

private theorem div2_le_self : ∀ n : Nat, n / 2 ≤ n
  | 0 => Nat.le_refl 0
  | n + 1 => Nat.le_trans (div2_mono (Nat.le_succ (n + 1))) (succ_div2_le_self (n + 1) (Nat.succ_pos n))

theorem distNat_div2 (a b : Nat) : distNat (a / 2) (b / 2) ≤ distNat a b := by
  have sub_le : ∀ x y : Nat, x / 2 - y / 2 ≤ x - y := fun x y =>
    match Nat.le_total x y with
    | .inl le =>
      Nat.le_trans (Nat.le_of_eq (sub_eq_zero_of_le (div2_mono le))) (Nat.zero_le _)
    | .inr ge =>
      match Nat.eq_or_lt_of_le ge with
      | .inl same => Nat.le_trans (Nat.le_of_eq (same ▸ sub_self_nat (x / 2))) (Nat.zero_le _)
      | .inr lt =>
        Nat.le_trans (sub_div2_le_half ge) (succ_div2_le_self (x - y) (SupportGated.sub_pos_of_lt lt))
  exact Nat.add_le_add (sub_le a b) (sub_le b a)

private theorem sub_sub_mid {m u v : Nat} (hv : v ≤ m) (le : u ≤ v) : (m - u) - (m - v) = v - u := by
  apply add_right_cancel (m - v)
  rw [Naturals.sub_add_cancel (Naturals.sub_antitone m le)]
  apply add_right_cancel u
  calc m - u + u
      = m := Naturals.sub_add_cancel (Nat.le_trans le hv)
    _ = m - v + v := (Naturals.sub_add_cancel hv).symm
    _ = m - v + (v - u + u) := congrArg (m - v + ·) (Naturals.sub_add_cancel le).symm
    _ = m - v + (v - u) + u := (Nat.add_assoc _ _ _).symm
    _ = (v - u + (m - v)) + u := congrArg (· + u) (Nat.add_comm _ _)

private theorem add_sub_mid {m x y : Nat} (hx : x ≤ m) : (m + y) - (m - x) = x + y := by
  rw [show m + y = (m - x) + (x + y) by
    rw [← Nat.add_assoc, Naturals.sub_add_cancel hx]]
  exact Naturals.add_sub_cancel_left (m - x) (x + y)

private theorem le_of_ble_true : ∀ {a b : Nat}, Nat.ble a b = true → a ≤ b
  | 0, _, _ => Nat.zero_le _
  | _ + 1, 0, h => Bool.noConfusion h
  | _ + 1, _ + 1, h => Nat.succ_le_succ (le_of_ble_true h)

private theorem mod4_succ {a b : Nat} (same : a % 4 = b % 4) : (a + 1) % 4 = (b + 1) % 4 := by
  obtain ⟨qa, ra, ha, hra⟩ := div4_rem a
  obtain ⟨qb, rb, hb, hrb⟩ := div4_rem b
  have hmod : ra = rb := by
    rw [ha, mod4_of_four_mul_add hra qa, hb, mod4_of_four_mul_add hrb qb] at same
    exact same
  subst hmod
  rw [ha, hb, Nat.add_assoc (4 * qa) ra 1, Nat.add_assoc (4 * qb) ra 1]
  match ra, hra with
  | 0, _ => rw [mod4_of_four_mul_add (by decide : 1 < 4) qa, mod4_of_four_mul_add (by decide : 1 < 4) qb]
  | 1, _ => rw [mod4_of_four_mul_add (by decide : 2 < 4) qa, mod4_of_four_mul_add (by decide : 2 < 4) qb]
  | 2, _ => rw [mod4_of_four_mul_add (by decide : 3 < 4) qa, mod4_of_four_mul_add (by decide : 3 < 4) qb]
  | 3, _ =>
    rw [← Nat.mul_succ 4 qa, ← Nat.mul_succ 4 qb]
    have h0a : (4 * (qa + 1)) % 4 = 0 := mod4_of_four_mul_add (by decide : 0 < 4) (qa + 1)
    have h0b : (4 * (qb + 1)) % 4 = 0 := mod4_of_four_mul_add (by decide : 0 < 4) (qb + 1)
    exact h0a.trans h0b.symm
  | _ + 4, hr => exact absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 4 _))

private theorem succ_mod2_beq (j : Nat) : (! (j % 2 == 1)) = ((j + 1) % 2 == 1) := by
  obtain ⟨q, r, eq, hr⟩ := div2_rem j
  rw [eq]
  match r, hr with
  | 0, _ =>
    rw [mod2_of_two_mul_add (by decide : 0 < 2) q, Nat.add_zero,
      mod2_of_two_mul_add (by decide : 1 < 2) q]
    rfl
  | 1, _ =>
    rw [mod2_of_two_mul_add (by decide : 1 < 2) q, Nat.add_assoc, ← Nat.mul_succ,
      ← Nat.add_zero (2 * (q + 1)), mod2_of_two_mul_add (by decide : 0 < 2) (q + 1)]
    rfl
  | _ + 2, hr => exact absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))

/-! ### Fine, mid, and macro dynamics -/

/-- Piecewise linear contraction toward `mid`. -/
def damp (mid z : Nat) : Nat :=
  if z < mid then mid - (mid - z) / 2 else mid + (z - mid) / 2

def damp40 : Nat → Nat := damp 40
def damp20 : Nat → Nat := damp 20

private theorem damp_le_of_le (mid : Nat) {z : Nat} (le : z ≤ mid) :
    damp mid z = mid - (mid - z) / 2 := by
  unfold damp
  match Nat.eq_or_lt_of_le le with
  | .inl same =>
    subst same
    rw [ite_neg' (Nat.lt_irrefl _), sub_self_nat]
    rfl
  | .inr lt => rw [ite_pos' lt]

private theorem damp_ge_of_ge (mid : Nat) {z : Nat} (ge : mid ≤ z) :
    damp mid z = mid + (z - mid) / 2 := by
  unfold damp
  rw [ite_neg' (Nat.not_lt_of_ge ge)]

private theorem damp_lip_ordered (mid : Nat) {a b : Nat} (le : a ≤ b) :
    distNat (damp mid a) (damp mid b) ≤ (b - a + 1) / 2 := by
  match Nat.le_total b mid, Nat.le_total a mid with
  | .inl hbm, _ =>
    have ham : a ≤ mid := Nat.le_trans le hbm
    rw [damp_le_of_le mid ham, damp_le_of_le mid hbm]
    have hsub : mid - b ≤ mid - a := Naturals.sub_antitone mid le
    have hdiv : (mid - b) / 2 ≤ (mid - a) / 2 := div2_mono hsub
    have hdivm : (mid - a) / 2 ≤ mid := Nat.le_trans (div2_le_self _) (Nat.sub_le mid a)
    have hda_le_db : mid - (mid - a) / 2 ≤ mid - (mid - b) / 2 := Naturals.sub_antitone mid hdiv
    unfold distNat
    rw [sub_eq_zero_of_le hda_le_db, Nat.zero_add, sub_sub_mid hdivm hdiv]
    exact Nat.le_trans (sub_div2_le_half hsub)
      (Nat.le_of_eq (congrArg (fun k => (k + 1) / 2) (sub_sub_mid hbm le)))
  | .inr hmb, .inr hma =>
    rw [damp_ge_of_ge mid hma, damp_ge_of_ge mid hmb]
    have hsub : a - mid ≤ b - mid := by
      obtain ⟨d, hd⟩ := le_dest hma
      rw [hd, Naturals.add_sub_cancel_left]
      exact Naturals.le_sub_of_add_le (Nat.add_comm mid d ▸ (hd ▸ le : mid + d ≤ b))
    have hdiv : (a - mid) / 2 ≤ (b - mid) / 2 := div2_mono hsub
    have hda_le_db : mid + (a - mid) / 2 ≤ mid + (b - mid) / 2 := Nat.add_le_add_left hdiv mid
    unfold distNat
    rw [sub_eq_zero_of_le hda_le_db, Nat.zero_add]
    have hsub_eq : (mid + (b - mid) / 2) - (mid + (a - mid) / 2) = (b - mid) / 2 - (a - mid) / 2 := by
      apply add_right_cancel (mid + (a - mid) / 2)
      rw [Naturals.sub_add_cancel hda_le_db]
      calc mid + (b - mid) / 2
          = mid + ((b - mid) / 2 - (a - mid) / 2 + (a - mid) / 2) :=
              congrArg (mid + ·) (Naturals.sub_add_cancel hdiv).symm
        _ = (mid + ((b - mid) / 2 - (a - mid) / 2)) + (a - mid) / 2 := (Nat.add_assoc _ _ _).symm
        _ = (((b - mid) / 2 - (a - mid) / 2) + mid) + (a - mid) / 2 :=
              congrArg (· + (a - mid) / 2) (Nat.add_comm _ _)
        _ = ((b - mid) / 2 - (a - mid) / 2) + (mid + (a - mid) / 2) := Nat.add_assoc _ _ _
    rw [hsub_eq]
    have diff_eq : (b - mid) - (a - mid) = b - a := by
      apply add_right_cancel (a - mid)
      rw [Naturals.sub_add_cancel hsub]
      apply add_right_cancel mid
      rw [Nat.add_assoc (b - a) (a - mid) mid, Naturals.sub_add_cancel hma,
        Naturals.sub_add_cancel le, Naturals.sub_add_cancel (Nat.le_trans hma le)]
    exact Nat.le_trans (sub_div2_le_half hsub) (Nat.le_of_eq (congrArg (fun k => (k + 1) / 2) diff_eq))
  | .inr hmb, .inl ham =>
    rw [damp_le_of_le mid ham, damp_ge_of_ge mid hmb]
    have hdm : (mid - a) / 2 ≤ mid := Nat.le_trans (div2_le_self _) (Nat.sub_le mid a)
    have hda_le_db : mid - (mid - a) / 2 ≤ mid + (b - mid) / 2 :=
      Nat.le_trans (Nat.sub_le mid _) (Nat.le_add_right mid _)
    unfold distNat
    rw [sub_eq_zero_of_le hda_le_db, Nat.zero_add, add_sub_mid hdm]
    have diff_eq : (mid - a) + (b - mid) = b - a := by
      apply add_right_cancel a
      rw [Nat.add_comm (mid - a) (b - mid), Nat.add_assoc (b - mid) (mid - a) a,
        Naturals.sub_add_cancel ham, Naturals.sub_add_cancel hmb, Naturals.sub_add_cancel le]
    exact Nat.le_trans (add_div2_le (mid - a) (b - mid))
      (Nat.le_trans (div2_mono (Nat.le_succ _))
        (Nat.le_of_eq (congrArg (fun k => (k + 1) / 2) diff_eq)))

theorem damp_lip (mid a b : Nat) : distNat (damp mid a) (damp mid b) ≤ (distNat a b + 1) / 2 :=
  match Nat.le_total a b with
  | .inl le =>
    have h_eq : distNat a b = b - a := by unfold distNat; rw [sub_eq_zero_of_le le, Nat.zero_add]
    h_eq ▸ damp_lip_ordered mid le
  | .inr ge =>
    have h_eq : distNat a b = a - b := by unfold distNat; rw [sub_eq_zero_of_le ge, Nat.add_zero]
    h_eq ▸ (distNat_symm (damp mid a) (damp mid b)).symm ▸ damp_lip_ordered mid ge

private theorem damp40_half_dist : ∀ q : Nat, distNat (damp40 q / 2) (damp20 (q / 2)) ≤ 1 := by
  intro q
  match Nat.lt_or_ge q 40 with
  | .inl lt =>
    have hle : q ≤ 39 := Nat.le_of_lt_succ lt
    have all_ok : (downFrom 39).all (fun k => Nat.ble (distNat (damp40 k / 2) (damp20 (k / 2))) 1) = true := rfl
    exact le_of_ble_true (ListTests.all_mem all_ok (mem_downFrom hle))
  | .inr ge =>
    obtain ⟨d, hd⟩ := le_dest ge
    subst hd
    have h40 : damp40 (40 + d) = 40 + d / 2 := by
      unfold damp40
      rw [damp_ge_of_ge 40 (Nat.le_add_right 40 d), Naturals.add_sub_cancel_left 40 d]
    have h20 : damp20 ((40 + d) / 2) = 20 + (d / 2) / 2 := by
      unfold damp20
      have hq2 : (40 + d) / 2 = 20 + d / 2 := by
        have h40_eq : 40 + d = 4 * 10 + d := rfl
        rw [h40_eq, div2_of_four_mul_add d 10]
      rw [hq2, damp_ge_of_ge 20 (Nat.le_add_right 20 (d / 2)), Naturals.add_sub_cancel_left 20 (d / 2)]
    have h40_div : (40 + d / 2) / 2 = 20 + (d / 2) / 2 := by
      have h40_eq : 40 + d / 2 = 4 * 10 + d / 2 := rfl
      rw [h40_eq, div2_of_four_mul_add (d / 2) 10]
    rw [h40, h40_div, h20, distNat_self]
    exact Nat.zero_le 1

/-- Fine step with 4-phase micro-oscillation and damping at phase 3. -/
def next (s : Nat × Nat) (_ : Unit) : Nat × Nat :=
  (match s.2 % 4 with
   | 0 => s.1 - 1
   | 1 => s.1
   | 2 => s.1 + 1
   | _ => damp40 s.1,
   s.2 + 1)

def P : Process (Nat × Nat) Unit := Viability.disturbed next (fun _ => True)
def guardS (s : Nat × Nat) : Prop := 22 ≤ s.1
def s₀ : Nat × Nat := (40, 0)

def π₁ (s : Nat × Nat) : Nat × Bool := (s.1, (s.2 / 2) % 2 == 1)
def σ₁ (j : Nat) : Nat := 2 * j
def M₁ : SlackDist (Nat × Bool) := SlackDist.pullback Prod.fst SlackDist.nat

def next₁ (q : Nat × Bool) (_ : Unit) : Nat × Bool :=
  if q.2 then (damp40 q.1, false) else (q.1, true)

def R₁ : Process (Nat × Bool) Unit := Viability.disturbed next₁ (fun _ => True)

def π₂ (q : Nat × Bool) : Nat := q.1 / 2
def σ₂ (k : Nat) : Nat := 2 * k
def M₂ : SlackDist Nat := SlackDist.nat
def R₂ : Process Nat Unit := Viability.disturbed (fun c _ => damp20 c) (fun _ => True)

def guardQ₂ (c : Nat) : Prop := c = 20
def K (c : Nat) : Prop := c = 20

def Epoch₀ (t : Nat) (s : Nat × Nat) : Prop := s.2 % 4 = t % 4
def Epoch₁ (j : Nat) (q : Nat × Bool) : Prop := q.2 = (j % 2 == 1)
def Epoch₂ (_ : Nat) (_ : Nat) : Prop := True

/-! ### Explicit non-exact-lumping via `ProjectedLaws.reduced_law_exists_iff` -/

def sectionMap₁ (q : Nat × Bool) : Nat × Nat := (q.1, if q.2 then 2 else 0)
def sectionMap₂ (c : Nat) : Nat × Bool := (2 * c, false)
def sectionMap₁₂ (c : Nat) : Nat × Nat := (2 * c, 0)

theorem back₁ : ∀ q, π₁ (sectionMap₁ q) = q
  | (x, true) => congrArg (x, ·) (by decide : ((2 / 2) % 2 == 1) = true)
  | (x, false) => congrArg (x, ·) (by decide : ((0 / 2) % 2 == 1) = false)

theorem back₂ : ∀ c, π₂ (sectionMap₂ c) = c := fun c => by
  unfold π₂ sectionMap₂
  exact div2_of_two_mul_add (by decide : 0 < 2) c

theorem back₁₂ : ∀ c, π₂ (π₁ (sectionMap₁₂ c)) = c := fun c => by
  unfold π₂ π₁ sectionMap₁₂
  exact div2_of_two_mul_add (by decide : 0 < 2) c

theorem not_fibreConsistent₁ : ¬ ProjectedLaws.FibreConsistent next π₁ := fun fc =>
  absurd (congrArg Prod.snd (fc (40, 0) (40, 1) rfl ())) (by decide)

theorem no_reduced_law₁ : ¬ ∃ reduced, ProjectedLaws.Commuting next reduced π₁ := fun found =>
  not_fibreConsistent₁ ((ProjectedLaws.reduced_law_exists_iff next π₁ sectionMap₁ back₁).mp found)

theorem not_fibreConsistent₂ : ¬ ProjectedLaws.FibreConsistent next₁ π₂ := fun fc =>
  absurd (fc (39, true) (38, true) rfl ()) (by decide)

theorem no_reduced_law₂ : ¬ ∃ reduced, ProjectedLaws.Commuting next₁ reduced π₂ := fun found =>
  not_fibreConsistent₂ ((ProjectedLaws.reduced_law_exists_iff next₁ π₂ sectionMap₂ back₂).mp found)

theorem not_fibreConsistent₁₂ : ¬ ProjectedLaws.FibreConsistent next (fun s => π₂ (π₁ s)) := fun fc =>
  absurd (fc (40, 0) (40, 1) rfl ()) (by decide)

theorem no_reduced_law₁₂ :
    ¬ ∃ reduced, ProjectedLaws.Commuting next reduced (fun s => π₂ (π₁ s)) := fun found =>
  not_fibreConsistent₁₂
    ((ProjectedLaws.reduced_law_exists_iff next (fun s => π₂ (π₁ s)) sectionMap₁₂ back₁₂).mp found)

/-! ### Construction of `sim₁`, `sim₂`, and composed `sim₁₂` -/

private theorem list_len2_cases (w : List Unit) (hw : w.length = 2) : w = [(), ()] := by
  cases w with
  | nil => exact absurd hw (Nat.ne_of_lt (Nat.succ_pos 1))
  | cons a w1 => cases w1 with
    | nil => exact absurd hw (Nat.ne_of_lt (Nat.lt_succ_self 1))
    | cons b w2 => cases w2 with
      | nil => cases a; cases b; rfl
      | cons _ _ =>
        exact absurd hw (Nat.ne_of_gt (Nat.succ_le_succ (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le _)))))

private theorem list_lt2_cases (w : List Unit) (hw : w.length < 2) : w = [] ∨ w = [()] := by
  cases w with
  | nil => exact Or.inl rfl
  | cons a w1 => cases w1 with
    | nil => cases a; exact Or.inr rfl
    | cons _ _ => exact absurd hw (Nat.not_lt_of_ge (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le _))))

private theorem epoch_proj₁_aux (j p : Nat) (hp : p % 4 = (2 * j) % 4) :
    ((p / 2) % 2 == 1) = (j % 2 == 1) := by
  obtain ⟨qp, rp, hp_eq, hrp⟩ := div4_rem p
  obtain ⟨qj, rj, hj_eq, hrj⟩ := div2_rem j
  have h2j : 2 * j = 4 * qj + 2 * rj := by
    rw [hj_eq, Nat.left_distrib 2 (2 * qj) rj, ← mul_assoc_nat 2 2 qj]
  have h2rj_lt : 2 * rj < 4 :=
    match rj, hrj with
    | 0, _ => by decide
    | 1, _ => by decide
    | _ + 2, hr => absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))
  rw [hp_eq, h2j, mod4_of_four_mul_add hrp qp, mod4_of_four_mul_add h2rj_lt qj] at hp
  rw [hp_eq, hp, div2_of_four_mul_add (2 * rj) qp]
  have hr2 : (2 * rj) / 2 = rj :=
    match rj, hrj with
    | 0, _ => rfl
    | 1, _ => rfl
    | _ + 2, hr => absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))
  rw [hr2, hj_eq, mod2_of_two_mul_add hrj qp, mod2_of_two_mul_add hrj qj]

private theorem epoch0_2j_cases (j _ p : Nat) (hp : p % 4 = (2 * j) % 4) :
    ((j % 2 == 1) = false ∧ p % 4 = 0 ∧ (p + 1) % 4 = 1) ∨
    ((j % 2 == 1) = true ∧ p % 4 = 2 ∧ (p + 1) % 4 = 3) := by
  obtain ⟨qp, rp, hp_eq, hrp⟩ := div4_rem p
  obtain ⟨qj, rj, hj_eq, hrj⟩ := div2_rem j
  have h2j : 2 * j = 4 * qj + 2 * rj := by
    rw [hj_eq, Nat.left_distrib 2 (2 * qj) rj, ← mul_assoc_nat 2 2 qj]
  have h2rj_lt : 2 * rj < 4 :=
    match rj, hrj with
    | 0, _ => by decide
    | 1, _ => by decide
    | _ + 2, hr => absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))
  rw [hp_eq, h2j, mod4_of_four_mul_add hrp qp, mod4_of_four_mul_add h2rj_lt qj] at hp
  match rj, hrj with
  | 0, _ =>
    left
    have hjp : p = 4 * qp := by rw [hp_eq, hp]; rfl
    refine ⟨by rw [hj_eq, mod2_of_two_mul_add (by decide : 0 < 2) qj]; rfl, ?_, ?_⟩
    · rw [hjp]; exact mod4_of_four_mul_add (by decide : 0 < 4) qp
    · rw [hjp]; exact mod4_of_four_mul_add (by decide : 1 < 4) qp
  | 1, _ =>
    right
    have hjp : p = 4 * qp + 2 := by rw [hp_eq, hp]
    refine ⟨by rw [hj_eq, mod2_of_two_mul_add (by decide : 1 < 2) qj]; rfl, ?_, ?_⟩
    · rw [hjp]; exact mod4_of_four_mul_add (by decide : 2 < 4) qp
    · rw [hjp, Nat.add_assoc]; exact mod4_of_four_mul_add (by decide : 3 < 4) qp
  | _ + 2, hr => exact absurd hr (Nat.not_lt_of_ge (Nat.le_add_left 2 _))

private theorem damp40_add1_dist (x q : Nat) : distNat (damp40 (x + 1)) (damp40 q) ≤ distNat x q + 1 := by
  have h1 : distNat (damp40 (x + 1)) (damp40 q) ≤ (distNat (x + 1) q + 1) / 2 := damp_lip 40 (x + 1) q
  have h2 : (distNat (x + 1) q + 1) / 2 ≤ (distNat x q + 1 + 1) / 2 :=
    div2_mono (Nat.add_le_add_right (distNat_add_one x q) 1)
  have h3 : (distNat x q + 1 + 1) / 2 = distNat x q / 2 + 1 := by
    rw [Nat.add_assoc]
    exact div2_add2 (distNat x q)
  exact Nat.le_trans h1 (Nat.le_trans h2 (Nat.le_trans (Nat.le_of_eq h3)
    (Nat.add_le_add_right (div2_le_self (distNat x q)) 1)))

def sim₁ : LaxSim P R₁ π₁ σ₁ M₁ where
  strict _ := Nat.lt_add_of_pos_right (by decide : 0 < 2)
  Epoch := Epoch₀
  EpochQ := Epoch₁
  epoch_step t s a s' ep step := by
    obtain ⟨_, moved⟩ := step
    subst moved
    exact mod4_succ ep
  epoch_proj j s ep := epoch_proj₁_aux j s.2 ep
  α := id
  β := id
  α_mono le := le
  β_mono le := le
  β_ge_id _ := Nat.le_refl _
  ε := 1
  η := 1
  sim_block j s q₁ r w s' epS epQ d_le w_len tr := by
    have w_len2 : w.length = 2 := by
      have h2 : σ₁ (j + 1) - σ₁ j = 2 := by
        unfold σ₁
        rw [Nat.mul_succ]
        exact Naturals.add_sub_cancel_left (2 * j) 2
      exact w_len.trans h2
    have hw_eq : w = [(), ()] := list_len2_cases w w_len2
    subst hw_eq
    have hs' : s' = next (next s ()) () := ((Viability.trace_disturbed_iff.mp tr).2).symm
    subst hs'
    obtain ⟨x, p⟩ := s
    obtain ⟨q, b⟩ := q₁
    have hb : b = (j % 2 == 1) := epQ
    refine ⟨(), next₁ (q, b) (), ⟨trivial, rfl⟩, ?_, ?_⟩
    · unfold Epoch₁ next₁
      rw [hb]
      cases hpar : (j % 2 == 1) with
      | false => exact (succ_mod2_beq j ▸ hpar ▸ rfl : true = ((j + 1) % 2 == 1))
      | true => exact (succ_mod2_beq j ▸ hpar ▸ rfl : false = ((j + 1) % 2 == 1))
    · match epoch0_2j_cases j x p epS with
      | Or.inl ⟨hj, hp0, hp1⟩ =>
        have hstep1 : next (x, p) () = (x - 1, p + 1) := by unfold next; rw [hp0]
        have hstep2 : next (x - 1, p + 1) () = (x - 1, p + 2) := by unfold next; rw [hp1]
        have hqstep : next₁ (q, b) () = (q, true) := by unfold next₁; rw [hb, hj]; rfl
        rw [hstep1, hstep2, hqstep]
        exact Nat.le_trans (distNat_sub_one x q) (Nat.add_le_add_right d_le 1)
      | Or.inr ⟨hj, hp2, hp3⟩ =>
        have hstep1 : next (x, p) () = (x + 1, p + 1) := by unfold next; rw [hp2]
        have hstep2 : next (x + 1, p + 1) () = (damp40 (x + 1), p + 2) := by unfold next; rw [hp3]
        have hqstep : next₁ (q, b) () = (damp40 q, false) := by unfold next₁; rw [hb, hj]; rfl
        rw [hstep1, hstep2, hqstep]
        exact Nat.le_trans (damp40_add1_dist x q) (Nat.add_le_add_right d_le 1)
  excursion j s q₁ r w₁ u epS epQ d_le w₁_lt tr := by
    have w_lt2 : w₁.length < 2 := by
      have h2 : σ₁ (j + 1) - σ₁ j = 2 := by
        unfold σ₁
        rw [Nat.mul_succ]
        exact Naturals.add_sub_cancel_left (2 * j) 2
      exact Nat.lt_of_lt_of_le w₁_lt (Nat.le_of_eq h2)
    cases list_lt2_cases w₁ w_lt2 with
    | inl hw0 =>
      subst hw0
      have hu : u = s := ((Viability.trace_disturbed_iff.mp tr).2).symm
      subst hu
      exact Nat.le_trans d_le (Nat.le_add_right r 1)
    | inr hw1 =>
      subst hw1
      have hu : u = next s () := ((Viability.trace_disturbed_iff.mp tr).2).symm
      subst hu
      obtain ⟨x, p⟩ := s
      match epoch0_2j_cases j x p epS with
      | Or.inl ⟨_, hp0, _⟩ =>
        have hstep1 : next (x, p) () = (x - 1, p + 1) := by unfold next; rw [hp0]
        rw [hstep1]
        exact Nat.le_trans (distNat_sub_one x q₁.1) (Nat.add_le_add_right d_le 1)
      | Or.inr ⟨_, hp2, _⟩ =>
        have hstep1 : next (x, p) () = (x + 1, p + 1) := by unfold next; rw [hp2]
        rw [hstep1]
        exact Nat.le_trans (distNat_add_one x q₁.1) (Nat.add_le_add_right d_le 1)

def sim₂ : LaxSim R₁ R₂ π₂ σ₂ M₂ where
  strict _ := Nat.lt_add_of_pos_right (by decide : 0 < 2)
  Epoch := Epoch₁
  EpochQ := Epoch₂
  epoch_step j q₁ a q₁' ep step := by
    obtain ⟨_, moved⟩ := step
    subst moved
    unfold Epoch₁ next₁
    rw [ep]
    cases hpar : (j % 2 == 1) with
    | false => exact (succ_mod2_beq j ▸ hpar ▸ rfl : true = ((j + 1) % 2 == 1))
    | true => exact (succ_mod2_beq j ▸ hpar ▸ rfl : false = ((j + 1) % 2 == 1))
  epoch_proj _ _ _ := trivial
  α r := (r + 1) / 2
  β := id
  α_mono le := div2_mono (Nat.add_le_add_right le 1)
  β_mono le := le
  β_ge_id _ := Nat.le_refl _
  ε := 1
  η := 0
  sim_block k q₁ c r w q₁' epS _ d_le w_len tr := by
    have w_len2 : w.length = 2 := by
      have h2 : σ₂ (k + 1) - σ₂ k = 2 := by
        unfold σ₂
        rw [Nat.mul_succ]
        exact Naturals.add_sub_cancel_left (2 * k) 2
      exact w_len.trans h2
    have hw_eq : w = [(), ()] := list_len2_cases w w_len2
    subst hw_eq
    have hq' : q₁' = next₁ (next₁ q₁ ()) () := ((Viability.trace_disturbed_iff.mp tr).2).symm
    subst hq'
    obtain ⟨q, b⟩ := q₁
    have hb : b = false := by
      have h2k : (2 * k) % 2 = 0 := mod2_of_two_mul_add (by decide : 0 < 2) k
      have hep : b = ((2 * k) % 2 == 1) := epS
      rw [h2k] at hep
      exact hep
    subst hb
    have hsteps : next₁ (next₁ (q, false) ()) () = (damp40 q, false) := rfl
    rw [hsteps]
    refine ⟨(), damp20 c, ⟨trivial, rfl⟩, trivial, ?_⟩
    have htri := distNat_tri (damp40 q / 2) (damp20 (q / 2)) (damp20 c)
    have hhalf := damp40_half_dist q
    have hlip : distNat (damp20 (q / 2)) (damp20 c) ≤ (r + 1) / 2 :=
      Nat.le_trans (damp_lip 20 (q / 2) c) (div2_mono (Nat.add_le_add_right d_le 1))
    exact Nat.le_trans htri (Nat.le_trans (Nat.add_le_add hhalf hlip)
      (Nat.le_of_eq (Nat.add_comm 1 ((r + 1) / 2))))
  excursion k q₁ c r w₁ u epS _ d_le w₁_lt tr := by
    have w_lt2 : w₁.length < 2 := by
      have h2 : σ₂ (k + 1) - σ₂ k = 2 := by
        unfold σ₂
        rw [Nat.mul_succ]
        exact Naturals.add_sub_cancel_left (2 * k) 2
      exact Nat.lt_of_lt_of_le w₁_lt (Nat.le_of_eq h2)
    cases list_lt2_cases w₁ w_lt2 with
    | inl hw0 =>
      subst hw0
      have hu : u = q₁ := ((Viability.trace_disturbed_iff.mp tr).2).symm
      subst hu
      exact d_le
    | inr hw1 =>
      subst hw1
      have hu : u = next₁ q₁ () := ((Viability.trace_disturbed_iff.mp tr).2).symm
      subst hu
      obtain ⟨q, b⟩ := q₁
      have hb : b = false := by
        have h2k : (2 * k) % 2 = 0 := mod2_of_two_mul_add (by decide : 0 < 2) k
        have hep : b = ((2 * k) % 2 == 1) := epS
        rw [h2k] at hep
        exact hep
      subst hb
      exact d_le

def sim₁₂ : LaxSim P R₂ (fun s => π₂ (π₁ s)) (fun k => σ₁ (σ₂ k)) M₂ :=
  LaxSim.compAdditive sim₁ sim₂ (fun _ _ ep => ep) id (fun le => le)
    (fun x y => distNat_div2 x.1 y.1) rfl 2 (fun k => by
      unfold σ₂
      rw [Nat.mul_succ, Naturals.add_sub_cancel_left]
      exact Nat.le_refl 2)

theorem sim₁₂_params : sim₁₂.ε = 3 ∧ sim₁₂.η = 2 := ⟨rfl, rfl⟩

theorem kernel_cert : Viability.Certificate R₂ guardQ₂ K where
  within _ h := h
  closed _ _ _ step h := by
    obtain ⟨_, moved⟩ := step
    subst moved
    subst h
    rfl

private theorem margin_two_scale (q : Nat) (u : Nat × Nat) (gq : guardQ₂ q)
    (hd : M₂.d (π₂ (π₁ u)) q ≤ sim₁₂.β 6 + sim₁₂.η) : guardS u := by
  have hq : q = 20 := gq
  subst hq
  have hd8 : distNat (u.1 / 2) 20 ≤ 8 := hd
  have hsub : 20 - u.1 / 2 ≤ 8 := Nat.le_trans (Nat.le_add_left _ _) hd8
  have h12 : 12 ≤ u.1 / 2 :=
    le_of_add_le_add_right 8
      (Nat.le_trans (Nat.le_of_eq (by decide : 12 + 8 = 20))
        (Nat.le_trans (le_sub_add_nat 20 (u.1 / 2))
          (Nat.le_trans (Nat.add_le_add_right hsub (u.1 / 2))
            (Nat.le_of_eq (Nat.add_comm 8 (u.1 / 2))))))
  obtain ⟨qu, ru, hu, hru⟩ := div2_rem u.1
  rw [hu, div2_of_two_mul_add hru qu] at h12
  have h24 : 24 ≤ 2 * qu := Nat.mul_le_mul_left 2 h12
  exact Nat.le_trans (by decide : 22 ≤ 24)
    (Nat.le_trans h24 (Nat.le_trans (Nat.le_add_right (2 * qu) ru) (Nat.le_of_eq hu.symm)))

/-- Certified fine-scale viability kernel for `(40, 0)` via composed 2-scale lax simulation. -/
theorem viability_kernel : Viability.Kernel P guardS s₀ :=
  lax_kernel_of_certificate sim₁₂ kernel_cert 6 (by decide : sim₁₂.α 6 + sim₁₂.ε ≤ 6)
    margin_two_scale rfl rfl

end WitnessTwoScale

end Becoming
