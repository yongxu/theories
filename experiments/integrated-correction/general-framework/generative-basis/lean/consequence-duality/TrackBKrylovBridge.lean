import DualityBridges
import SurvivalDistinguishability

/-!
# `TrackBKrylovBridge`: Track B (#14) joined to the consequence-duality Krylov bridge

AI-written (Wave 3 follow-up, 24 November 2026). Strictly additive: neither `DualityBridges.lean`
nor `SurvivalDistinguishability.lean` is changed.

`DualityBridges.survVec` (a `wordVec` from the all-ones vector) and
`SurvivalDistinguishability.survVec` (Track B, periphery #14) are two definitions of one
finite-horizon survival vector. `survVec_eq` says they agree on every mode word. With it,
`DualityBridges.finite_krylov_zero_minimax_radius` is stated on Track B's `survVec`, and Track B's
headline `survival_indistinguishable_iff_le_card_pred` lifts a short-word agreement of the
duality-side vectors to all words. Uses only the three standard axioms.
-/

namespace TrackBKrylovBridge

/-- The two one-step operators are the same function. -/
theorem stepOp_eq {S : Type*} [Fintype S] (M : S → S → ℝ) (v : S → ℝ) :
    DualityBridges.stepOp M v = SurvivalDistinguishability.stepOp M v := rfl

/-- The duality-side and Track B survival vectors agree on every mode word. -/
theorem survVec_eq {S Mode : Type*} [Fintype S] (K : Mode → S → S → ℝ) (w : List Mode) :
    DualityBridges.survVec K w = SurvivalDistinguishability.survVec K w := by
  induction w with
  | nil => rfl
  | cons a w ih =>
    funext s
    show (∑ s', K a s s' * DualityBridges.survVec K w s') =
      ∑ s', K a s s' * SurvivalDistinguishability.survVec K w s'
    rw [ih]

/-- `DualityBridges.finite_krylov_zero_minimax_radius` on Track B's `survVec`: for every finite
state space and mode word `w₀`, the survival query `SurvivalDistinguishability.survVec K w₀` has a
zero-gap minimax pair when conditioned on mode words of length at most `Fintype.card S - 1`. -/
theorem trackB_finite_krylov_zero_minimax_radius {S Mode : Type*} [Fintype S] [Nonempty S]
    [Fintype Mode] (K : Mode → S → S → ℝ) (w₀ : List Mode) :
    let F_short : DualityBridges.ShortWord S Mode → S → ℝ :=
      DualityBridges.shortWordQuery K (fun _ => 1)
    let h : S → ℝ := SurvivalDistinguishability.survVec K w₀
    (∃ (b : ℝ) (c : DualityBridges.ShortWord S Mode → ℝ),
        ConsequenceDuality.dualBound F_short h 0 b c = 0) ∧
    (∃ (μ ν : ConsequenceDuality.FinDist S) (b : ℝ) (c : DualityBridges.ShortWord S Mode → ℝ),
      ConsequenceDuality.PrimalFeasible F_short 0 μ ν ∧
      (∀ μ' ν' : ConsequenceDuality.FinDist S, ConsequenceDuality.PrimalFeasible F_short 0 μ' ν' →
        ConsequenceDuality.primalGap h μ' ν' ≤ ConsequenceDuality.primalGap h μ ν) ∧
      (∀ (b' : ℝ) (c' : DualityBridges.ShortWord S Mode → ℝ),
        ConsequenceDuality.dualBound F_short h 0 b c ≤
          ConsequenceDuality.dualBound F_short h 0 b' c') ∧
      ConsequenceDuality.primalGap h μ ν = 0 ∧ ConsequenceDuality.dualBound F_short h 0 b c = 0) := by
  dsimp only
  rw [← survVec_eq K w₀]
  exact DualityBridges.finite_krylov_zero_minimax_radius K w₀

/-- Track B's headline (#14) read on the duality-side vectors: two states that agree on every
mode word of length at most `Fintype.card S - 1` agree on every mode word. -/
theorem short_word_agreement_lifts {S Mode : Type*} [Fintype S] [Nonempty S]
    (K : Mode → S → S → ℝ) (x y : S)
    (hshort : ∀ w : List Mode, w.length ≤ Fintype.card S - 1 →
      DualityBridges.survVec K w x = DualityBridges.survVec K w y) :
    ∀ w : List Mode, DualityBridges.survVec K w x = DualityBridges.survVec K w y := by
  have h := (SurvivalDistinguishability.survival_indistinguishable_iff_le_card_pred K x y).mpr
    (fun w hw => by simpa only [survVec_eq] using hshort w hw)
  intro w
  simpa only [survVec_eq] using h w

/-- Track B's one-mode sharpness witness `countdownK n` on `Fin (n + 1)`: zero-gap minimax pair for
every survival query, with the mode word `w₀` free. -/
theorem countdown_zero_minimax_radius (n : ℕ) (w₀ : List Unit) :
    (∃ (b : ℝ) (c : DualityBridges.ShortWord (Fin (n + 1)) Unit → ℝ),
      ConsequenceDuality.dualBound
        (DualityBridges.shortWordQuery (SurvivalDistinguishability.countdownK n) (fun _ => 1))
        (SurvivalDistinguishability.survVec (SurvivalDistinguishability.countdownK n) w₀)
        0 b c = 0) :=
  (trackB_finite_krylov_zero_minimax_radius (SurvivalDistinguishability.countdownK n) w₀).1

end TrackBKrylovBridge
