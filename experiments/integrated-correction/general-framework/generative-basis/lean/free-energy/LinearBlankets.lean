import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic
import Becoming.Blanket

/-!
# The blanket in a linear steady state: the coupling form and the statistical form

A linear drift `−B x` with noise `D`, its steady covariance `S` and precision `Π = S⁻¹` (board item
UE26). Everything is stated algebraically for the linear case, under stated correspondences:
the steady state of `dx = −B x dt + √(2D) dW`, for `B` stable (every eigenvalue of positive real
part), is the Lyapunov equation `B S + S Bᵀ = 2 D`; for a Gaussian, a zero precision entry is
conditional independence given the other coordinates (Lauritzen 1996); the Gaussian steady current
is `Q Π x` times the density; the steady covariance of the synchronous recursion `x' = A x + ξ`, its
noise `ξ` of covariance `2 h D` each step, is the solution of `S = A S Aᵀ + 2 h D`, unique where `A`
has spectral radius below 1. The pinned Mathlib has no stochastic integral, so Langevin flows and
densities stay outside the module. Reading `S` as a covariance needs it positive definite
(`Matrix.PosDef`), which holds for `B` stable; the algebraic laws do not need it. "The 2023 paper"
is Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr 2023 (Physics Reports).

* **The Helmholtz form is the Lyapunov equation** (`helmholtz_of_lyapunov`,
  `lyapunov_of_helmholtz`, `helmholtz_unique`): `B = (D − Q) Π` with `Q` antisymmetric, `Q` and `D`
  unique; no circulation is `Q = 0`. The standard identity for Ornstein–Uhlenbeck processes.
* **No circulation through a coordinate.** Row `i` of `Q Π` vanishes exactly where row `i` of `Q`
  does (`row_zero_iff`): no steady current along coordinate `i`, the counterpart of detailed balance
  of the internal moves in `Becoming.BlanketWeights`. With noise each coordinate's own and positive,
  the drift at such a coordinate reads `j` exactly where their precision entry is nonzero
  (`drift_zero_iff`). In general, where the drift at `i` does not read `j`, their precision entry
  is nonzero exactly where `(Q Π) i j` does not vanish (`zero_iff_solenoidal`; Heins and Da Costa 2022,
  eq. 13, its scalar case with constant diagonal noise). A remark, not proved here: constant noise
  has no counterpart of rates reading the external state symmetrically
  (`BlanketWeights.ReadsDirectly`).
* **No solenoidal coupling between autonomous and other coordinates gives a zero precision entry**
  (`precision_zero_of_autonomous`): with diagonal positive noise, `Q` vanishing between a set of
  coordinates and the rest, and no coordinate of the set reading `j`, every precision entry between
  the set and `j` is zero, since `D − Q` is positive on the set. In the 2023 paper the
  autonomous states are the internal and active ones, those no external state influences; this module
  uses the word for footnote 13's condition on a set of coordinates, that no solenoidal flow joins it
  to the rest (`noQ`; `Autonomous.autonomous`), and states apart that no coordinate of the set reads
  `j` (`absent`). In the principle's four parts, with the internal
  and active coordinates autonomous (the 2023 paper's footnote 13; its normal form is Heins and Da
  Costa 2022, eq. 14, with the condition under it, eq. 15), sparse coupling gives a zero precision
  entry between internal and external coordinates while circulation between internal and active
  coordinates is allowed
  (`precision_zero_of_footnote13`, witness `Autonomous`). The proof for any set of coordinates, by
  the quadratic form of `D − Q`, is this module's. With the internal coordinates as the set, the law
  allows circulation among them (`BlanketWeights.Turning` is that case's discrete counterpart);
  detailed balance of the internal moves is the narrower `row_zero_iff` case, and the core has no
  discrete law for footnote 13's set of internal and active coordinates.
* **The conditions are sufficient, not necessary; with sparse coupling read as a zero drift entry,
  circulation can lose the zero and need not.** A linear lag relay, sparsely coupled both ways, has
  a nonzero precision entry between its internal and external coordinates and circulation through
  the internal one (`LagRelay`, a witness of sparse coupling without the statistical blanket, which
  is known: Biehl, Pollock and Kanai 2021, Observation 1; Aguilera, Millidge, Tschantz and Buckley
  2022). A steady state circulating
  through the internal coordinate, with solenoidal coupling to both other coordinates, keeps the zero
  entry (`Circulating`). A zero entry can come with the internal drift reading the external
  coordinate (`Unsparse`; Da Costa, Friston, Heins and Pavliotis 2021, Remark 3.1). `LagRelay` and
  `Circulating` meet sparse coupling as a zero drift entry only, by cancellation, which the 2023
  paper's footnote 10 excludes (`LagRelay.not_termwise`, `Circulating.not_termwise`); `Autonomous`
  meets it term by term (`Autonomous.termwise`).
* **Term by term, in the linear case.** Under the 2023 paper's term-by-term sparse coupling (its
  eq. 9, with constant solenoidal part, noise and Hessian, the noise and the Hessian with positive
  diagonals), an absent influence has no Hessian and no
  solenoidal entry (`unread_zero`, the paper's eqs. 9–10), so the zero precision entry is one of the
  definition's own terms; the influence the other way runs only through the solenoidal flow to third
  states (`reverse_through_third`); and a state no other state reads reads no other state
  (`reads_nothing_of_unread`). The last two are near-definitional corollaries of eqs. 9–10; their
  general forms were not found in the sources checked. Cases of the second appear in Friston, Da
  Costa and Parr 2021 (eqs. 1.6–1.7), Heins and Da Costa 2022 (eqs. 17–18) and, with no third block,
  Biehl, Pollock and Kanai 2021 (Observation 3).
* **The internal mode** (`mode_unread_iff`) reads no external state exactly at the zero block; a
  mode, the conditional density's maximum, where the internal block is positive definite. Elementary
  Gaussian conditioning.
* **The join to the core.** The Euler step of a drift with the principle's sparse coupling is a
  blanketed law (`split_euler`), so the agent's course is fixed by its start and the sensory course
  (`euler_agent_through_sensory`). With additive noise as each coordinate's own input, the agent's
  course is fixed by its start, its own noise course and the sensory course
  (`em_agent_through_sensory`): pathwise, for every linear drift with the sparse coupling,
  circulating or not. With the agent's noise independent of the rest's and of the start, and the
  agent's start held fixed or independent of the world's, this is the stochastic time-unrolled
  blanket (Virgo, Rosas and Biehl 2022), a correspondence; a steady start does not give the second
  condition, since there the internal and external coordinates can be dependent (`LagRelay`).
* **The synchronous scheme's statistical form.** Without circulation (`B = D Π`, `D` symmetric),
  the synchronous recursion's steady precision is `Π − (h/2) Π D Π` (`em_steady`; the known
  order-`h` bias of the Euler–Maruyama steady law of an Ornstein–Uhlenbeck process). With `D`
  diagonal and positive and the four-part sparse coupling, its internal–external entries stay zero
  (`em_keeps_four_part`); there the internal coordinates read no sensory coordinate, and an
  active–external entry is `−h/2` times a sum through the sensory coordinates
  (`em_active_external`), nonzero in a witness (`Autonomous.em_loses_active_external`). With
  circulation the internal–external zero can be lost: in a witness whose drift meets footnote 13 and
  eq. 9, and whose agent's course is fixed by its sensory course, the entry at `h = 1/10` is
  `−27800/984581` (`Autonomous.em_loses_internal_external`, `Autonomous.em_coupling_form`), while
  the drift's continuous-time zero stands (`Autonomous.precision_zero`). A three-coordinate chain,
  the principle's three-part partition, sparsely coupled under no assignment to the four parts with
  its ends internal and external (`ThreePart.no_four_part`), loses the zero without circulation
  (`ThreePart.em_loses_zero`). Where a loss is proved for every `h` it is `h` times a fixed entry. A remark: the asynchronous chain of
  `Becoming.BlanketWeights`, one coordinate moving at a time, is the discrete counterpart of
  continuous time with independent noise at each coordinate, so these losses belong to the
  synchronous scheme's steps.

This module belongs to the periphery: it uses Mathlib's reals and matrices, and its axiom reports
are those of the Mathlib lemmas it uses. The core does not import it.
-/

namespace Becoming.LinearBlankets

open Matrix

section Helmholtz

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **The Lyapunov equation gives the Helmholtz form.** With `S` symmetric and invertible,
`B S + S Bᵀ = 2 D` gives `B = (D − Q) S⁻¹` with `Q = ½ (S Bᵀ − B S)` antisymmetric. -/
theorem helmholtz_of_lyapunov (B S D : Matrix n n ℝ) (symm : Sᵀ = S) (hS : IsUnit S.det)
    (lyap : B * S + S * Bᵀ = (2 : ℝ) • D) :
    ((1 / 2 : ℝ) • (S * Bᵀ - B * S))ᵀ = -((1 / 2 : ℝ) • (S * Bᵀ - B * S)) ∧
      B = (D - (1 / 2 : ℝ) • (S * Bᵀ - B * S)) * S⁻¹ := by
  have hD : D = (1 / 2 : ℝ) • (B * S + S * Bᵀ) := by
    rw [lyap, smul_smul]; norm_num
  refine ⟨?_, ?_⟩
  · rw [transpose_smul, transpose_sub, transpose_mul, transpose_mul, transpose_transpose, symm,
      ← smul_neg, neg_sub]
  · have : D - (1 / 2 : ℝ) • (S * Bᵀ - B * S) = B * S := by
      rw [hD, ← smul_sub]
      have : B * S + S * Bᵀ - (S * Bᵀ - B * S) = (2 : ℝ) • (B * S) := by
        rw [two_smul]; abel
      rw [this, smul_smul]; norm_num
    rw [this, Matrix.mul_assoc, mul_nonsing_inv _ hS, Matrix.mul_one]

/-- **The Helmholtz form gives the Lyapunov equation.** With `Q` antisymmetric, `D` symmetric and
`Π` symmetric and invertible, `B = (D − Q) Π` gives `B Π⁻¹ + Π⁻¹ Bᵀ = 2 D`. -/
theorem lyapunov_of_helmholtz (B D Q P : Matrix n n ℝ) (hP : IsUnit P.det) (symmP : Pᵀ = P)
    (symmD : Dᵀ = D) (anti : Qᵀ = -Q) (helm : B = (D - Q) * P) :
    B * P⁻¹ + P⁻¹ * Bᵀ = (2 : ℝ) • D := by
  have h1 : B * P⁻¹ = D - Q := by rw [helm, Matrix.mul_assoc, mul_nonsing_inv _ hP, Matrix.mul_one]
  have hPi : (P⁻¹)ᵀ = P⁻¹ := by rw [transpose_nonsing_inv, symmP]
  have h2 : P⁻¹ * Bᵀ = D + Q := by
    have : (B * P⁻¹)ᵀ = P⁻¹ * Bᵀ := by rw [transpose_mul, hPi]
    rw [← this, h1, transpose_sub, symmD, anti, sub_neg_eq_add]
  rw [h1, h2, two_smul]; abel

/-- **The Helmholtz parts are unique**: any symmetric `D'` and antisymmetric `Q'` with
`B = (D' − Q') S⁻¹` are `½ (B S + S Bᵀ)` and `½ (S Bᵀ − B S)`. -/
theorem helmholtz_unique (B S D' Q' : Matrix n n ℝ) (symmS : Sᵀ = S) (hS : IsUnit S.det)
    (symmD : D'ᵀ = D') (anti : Q'ᵀ = -Q') (helm : B = (D' - Q') * S⁻¹) :
    D' = (1 / 2 : ℝ) • (B * S + S * Bᵀ) ∧ Q' = (1 / 2 : ℝ) • (S * Bᵀ - B * S) := by
  have h1 : B * S = D' - Q' := by rw [helm, Matrix.mul_assoc, nonsing_inv_mul _ hS, Matrix.mul_one]
  have h2 : S * Bᵀ = D' + Q' := by
    have : (B * S)ᵀ = S * Bᵀ := by rw [transpose_mul, symmS]
    rw [← this, h1, transpose_sub, symmD, anti, sub_neg_eq_add]
  rw [h1, h2]
  constructor
  · rw [show D' - Q' + (D' + Q') = (2 : ℝ) • D' by rw [two_smul]; abel, smul_smul]; norm_num
  · rw [show D' + Q' - (D' - Q') = (2 : ℝ) • Q' by rw [two_smul]; abel, smul_smul]; norm_num

end Helmholtz

section Entries

variable {n : Type*}

/-- A symmetric matrix's entries read either way. -/
theorem entry_symm {P : Matrix n n ℝ} (symm : Pᵀ = P) (i k : n) : P i k = P k i := by
  have := congrFun (congrFun symm k) i
  rwa [transpose_apply] at this

/-- An antisymmetric matrix's entries change sign when read the other way. -/
theorem entry_anti {Q : Matrix n n ℝ} (anti : Qᵀ = -Q) (i k : n) : Q i k = -Q k i := by
  have := congrFun (congrFun anti k) i
  rwa [transpose_apply, neg_apply] at this

end Entries

section Drift

variable {n : Type*} [Fintype n]

/-- **No steady current along a coordinate is no circulation through it**: with `Π` invertible,
row `i` of `Q Π` vanishes exactly where row `i` of `Q` does. -/
theorem row_zero_iff [DecidableEq n] (Q P S : Matrix n n ℝ) (inv : P * S = 1) (i : n) :
    (∀ j, (Q * P) i j = 0) ↔ ∀ j, Q i j = 0 := by
  constructor
  · intro h j
    have : Q = Q * P * S := by rw [Matrix.mul_assoc, inv, Matrix.mul_one]
    rw [this, mul_apply]
    exact Finset.sum_eq_zero fun k _ => by rw [h k, zero_mul]
  · intro h j
    rw [mul_apply]
    exact Finset.sum_eq_zero fun k _ => by rw [h k, zero_mul]

/-- **No circulation through an internal coordinate.** With the Helmholtz form, noise each
coordinate's own and positive, and no solenoidal flow through coordinate `i`, the drift at `i`
reads coordinate `j` exactly where their precision entry is nonzero. -/
theorem drift_zero_iff (B D Q P : Matrix n n ℝ) (helm : B = (D - Q) * P)
    (diag : ∀ i k, i ≠ k → D i k = 0) (noisePos : ∀ i, 0 < D i i)
    (i : n) (noCirc : ∀ k, Q i k = 0) (j : n) : B i j = 0 ↔ P i j = 0 := by
  have : B i j = D i i * P i j := by
    rw [helm, mul_apply, Finset.sum_eq_single i]
    · simp [noCirc]
    · intro k _ hk; simp [diag i k (Ne.symm hk), noCirc]
    · intro h; exact absurd (Finset.mem_univ i) h
  rw [this, mul_eq_zero]; exact ⟨fun h => h.resolve_left (noisePos i).ne', Or.inr⟩

/-- **In general**: where the drift at `i` does not read `j`, their precision entry is nonzero
exactly where `(Q Π) i j` does not vanish (Heins and Da Costa 2022, eq. 13, its scalar case with constant
diagonal noise). -/
theorem zero_iff_solenoidal (B D Q P : Matrix n n ℝ) (helm : B = (D - Q) * P)
    (diag : ∀ i k, i ≠ k → D i k = 0) (noisePos : ∀ i, 0 < D i i)
    {i j : n} (absent : B i j = 0) : P i j = 0 ↔ (Q * P) i j = 0 := by
  have hB : B i j = D i i * P i j - (Q * P) i j := by
    rw [helm, Matrix.sub_mul, sub_apply, mul_apply, Finset.sum_eq_single i]
    · intro k _ hk; simp [diag i k (Ne.symm hk)]
    · intro h; exact absurd (Finset.mem_univ i) h
  rw [absent] at hB
  constructor
  · intro h; rw [h, mul_zero, zero_sub] at hB; linarith
  · intro h; rw [h, sub_zero] at hB
    exact (mul_eq_zero.mp hB.symm).resolve_left (noisePos i).ne'

/-- An antisymmetric matrix's quadratic form vanishes. -/
theorem quad_antisymm (Q : Matrix n n ℝ) (anti : Qᵀ = -Q) (v : n → ℝ) : v ⬝ᵥ (Q *ᵥ v) = 0 := by
  have h : v ⬝ᵥ (Q *ᵥ v) = -(v ⬝ᵥ (Q *ᵥ v)) := by
    calc v ⬝ᵥ (Q *ᵥ v) = (v ᵥ* Q) ⬝ᵥ v := dotProduct_mulVec v Q v
      _ = (Qᵀ *ᵥ v) ⬝ᵥ v := by rw [mulVec_transpose]
      _ = -(v ⬝ᵥ (Q *ᵥ v)) := by rw [anti, neg_mulVec, neg_dotProduct, dotProduct_comm]
  linarith

variable [DecidableEq n]

/-- **No solenoidal coupling between autonomous and other coordinates gives a zero precision
entry.** With diagonal positive noise, `Q` antisymmetric and vanishing from a set of coordinates to the rest, and
no coordinate of the set reading `j`, every precision entry between the set and `j` is zero: the
column of `Π` at `j`, restricted to the set, is in the kernel of `D − Q` there, whose quadratic form
is `D`'s. -/
theorem precision_zero_of_autonomous (B Q P : Matrix n n ℝ) (d : n → ℝ) (dpos : ∀ i, 0 < d i)
    (anti : Qᵀ = -Q) (helm : B = (diagonal d - Q) * P) (auto : n → Prop) [DecidablePred auto]
    (noQ : ∀ i k, auto i → ¬ auto k → Q i k = 0) (j : n) (absent : ∀ i, auto i → B i j = 0) :
    ∀ i, auto i → P i j = 0 := by
  set v : n → ℝ := fun k => if auto k then P k j else 0 with hv
  have row : ∀ i, auto i → ((diagonal d - Q) *ᵥ v) i = B i j := by
    intro i hi
    rw [helm, mul_apply, mulVec, dotProduct]
    apply Finset.sum_congr rfl
    intro k _
    by_cases hk : auto k
    · simp [hv, hk]
    · have hik : i ≠ k := fun e => hk (e ▸ hi)
      simp [hv, hk, diagonal_apply_ne _ hik, noQ i k hi hk]
  have zero : v ⬝ᵥ ((diagonal d - Q) *ᵥ v) = 0 := by
    rw [dotProduct]
    apply Finset.sum_eq_zero
    intro i _
    by_cases hi : auto i
    · rw [row i hi, absent i hi, mul_zero]
    · simp [hv, hi]
  rw [sub_mulVec, dotProduct_sub, quad_antisymm Q anti v, sub_zero, dotProduct] at zero
  have each : ∀ i ∈ Finset.univ, v i * (diagonal d *ᵥ v) i = 0 := by
    have nonneg : ∀ i ∈ Finset.univ, 0 ≤ v i * (diagonal d *ᵥ v) i := by
      intro i _; rw [mulVec_diagonal]; nlinarith [dpos i, sq_nonneg (v i)]
    exact (Finset.sum_eq_zero_iff_of_nonneg nonneg).mp zero
  intro i hi
  have := each i (Finset.mem_univ i)
  rw [mulVec_diagonal] at this
  have hvi : v i = 0 := by
    have : d i * (v i * v i) = 0 := by linarith [this]
    rcases mul_eq_zero.mp this with h | h
    · exact absurd h (dpos i).ne'
    · exact mul_self_eq_zero.mp h
  simpa [hv, hi] using hvi

end Drift

section TermByTerm

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **Sparse coupling term by term** (the 2023 paper's eq. 9, in the linear case): the flow
at `u`, `J u v = Σ i, (Q u i − Γ u i) * H i v` with `Γ` the noise and `H` the surprisal's Hessian,
reads `v` in no term. -/
def TermwiseUnread (Q Γ H : Matrix n n ℝ) (u v : n) : Prop :=
  ∀ i, Q u i * H i v = 0 ∧ Γ u i * H i v = 0

omit [Fintype n] [DecidableEq n] in
/-- **An influence absent term by term has no Hessian entry and no solenoidal entry** (the 2023
paper's eqs. 9–10): with positive noise and a positive Hessian diagonal, `H u v = 0` and
`Q u v = 0`. -/
theorem unread_zero {Q Γ H : Matrix n n ℝ} (gpos : ∀ i, 0 < Γ i i) (hpos : ∀ i, 0 < H i i)
    {u v : n} (un : TermwiseUnread Q Γ H u v) : H u v = 0 ∧ Q u v = 0 :=
  ⟨(mul_eq_zero.mp (un u).2).resolve_left (gpos u).ne',
    (mul_eq_zero.mp (un v).1).resolve_right (hpos v).ne'⟩

/-- **The reverse influence runs only through third states.** With noise each coordinate's own and
positive, `Q` antisymmetric and `H` symmetric with a positive diagonal, where the flow at `u` reads
`v` in no term, the flow at `v` reads `u` only through the solenoidal flow from `v` to third states
whose Hessian entries with `u` are nonzero. -/
theorem reverse_through_third {Q Γ H : Matrix n n ℝ} (anti : Qᵀ = -Q)
    (diag : ∀ i k, i ≠ k → Γ i k = 0) (symm : Hᵀ = H) (gpos : ∀ i, 0 < Γ i i)
    (hpos : ∀ i, 0 < H i i) {u v : n} (ne : u ≠ v) (un : TermwiseUnread Q Γ H u v) :
    ((Q - Γ) * H) v u = ∑ i ∈ Finset.univ.filter (fun i => i ≠ u ∧ i ≠ v), Q v i * H i u := by
  obtain ⟨Huv, Quv⟩ := unread_zero gpos hpos un
  have Qvu : Q v u = 0 := by rw [entry_anti anti v u, Quv, neg_zero]
  have Hvu : H v u = 0 := by rw [entry_symm symm v u, Huv]
  rw [mul_apply, Finset.sum_filter]
  refine Finset.sum_congr rfl fun i _ => ?_
  by_cases hu : i = u
  · subst hu; simp [Qvu, diag v i (Ne.symm ne)]
  · by_cases hv : i = v
    · subst hv; simp [Hvu]
    · simp [hu, hv, diag v i (Ne.symm hv)]

/-- **A state no other state reads reads no other state.** Where no other state's flow reads `u` in
any term, the flow at `u` reads no other state. -/
theorem reads_nothing_of_unread {Q Γ H : Matrix n n ℝ} (anti : Qᵀ = -Q)
    (diag : ∀ i k, i ≠ k → Γ i k = 0) (symm : Hᵀ = H) (gpos : ∀ i, 0 < Γ i i)
    (hpos : ∀ i, 0 < H i i) {u : n} (unread : ∀ v, v ≠ u → TermwiseUnread Q Γ H v u)
    {v : n} (ne : v ≠ u) : ((Q - Γ) * H) u v = 0 := by
  rw [mul_apply]
  refine Finset.sum_eq_zero fun i _ => ?_
  by_cases hi : i = u
  · subst hi
    have Hiv : H i v = 0 := by rw [entry_symm symm i v]; exact (unread_zero gpos hpos (unread v ne)).1
    simp [Hiv]
  · have Qui : Q u i = 0 := by
      rw [entry_anti anti u i, (unread_zero gpos hpos (unread i hi)).2, neg_zero]
    simp [Qui, diag u i (Ne.symm hi)]

end TermByTerm

namespace LagRelay

/-- The lag relay: internal coordinate 0 reads blanket coordinate 1, which reads external
coordinate 2, with noise one at each. -/
noncomputable def B : Matrix (Fin 3) (Fin 3) ℝ := !![1, -1, 0; 0, 1, -1; 0, 0, 1]
noncomputable def BT : Matrix (Fin 3) (Fin 3) ℝ := !![1, 0, 0; -1, 1, 0; 0, -1, 1]
/-- Its steady covariance. -/
noncomputable def S : Matrix (Fin 3) (Fin 3) ℝ := !![15/8, 7/8, 1/4; 7/8, 3/2, 1/2; 1/4, 1/2, 1]
/-- Its precision. -/
noncomputable def P : Matrix (Fin 3) (Fin 3) ℝ :=
  !![80/109, -48/109, 4/109; -48/109, 116/109, -46/109; 4/109, -46/109, 131/109]
/-- Its solenoidal part. -/
noncomputable def Q : Matrix (Fin 3) (Fin 3) ℝ := !![0, 5/8, 1/4; -5/8, 0, 1/2; -1/4, -1/2, 0]

theorem transpose_B : Bᵀ = BT := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl

theorem lyapunov : B * S + S * Bᵀ = (2 : ℝ) • (1 : Matrix (Fin 3) (Fin 3) ℝ) := by
  rw [transpose_B]
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [B, BT, S] <;> norm_num

theorem inverse : S * P = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [S, P, Matrix.mul_apply, Fin.sum_univ_three] <;> norm_num

theorem helmholtz : B = (1 - Q) * P := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [B, Q, P, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply] <;> norm_num

/-- Sparse both ways: the internal drift reads no external coordinate, nor the external drift
any internal one. -/
theorem sparse : B 0 2 = 0 ∧ B 2 0 = 0 := by simp [B]

/-- The precision entry between the internal and external coordinates is nonzero. -/
theorem precision_nonzero : P 0 2 ≠ 0 := by simp [P]

/-- Circulation through the internal coordinate. -/
theorem circulates : Q 0 1 ≠ 0 := by simp [Q]

/-- The internal drift's zero entry at the external coordinate is a cancellation: the term through
the internal coordinate itself does not vanish, so the relay is not sparsely coupled term by term. -/
theorem not_termwise : ¬ TermwiseUnread Q 1 P 0 2 := fun un => by
  have := (un 0).2
  simp [P] at this

end LagRelay

namespace Circulating

/-- A precision with a zero entry between internal coordinate 0 and external coordinate 2. -/
noncomputable def P : Matrix (Fin 3) (Fin 3) ℝ := !![2, 1, 0; 1, 2, 1; 0, 1, 2]
/-- Circulation through the internal coordinate, coupling it to both others. -/
noncomputable def Q : Matrix (Fin 3) (Fin 3) ℝ := !![0, 1, -1/2; -1, 0, 1; 1/2, -1, 0]
/-- The drift of the Helmholtz form with noise one at each coordinate. -/
noncomputable def B : Matrix (Fin 3) (Fin 3) ℝ := !![1, -1/2, 0; 3, 2, -1; 0, 5/2, 3]

theorem helmholtz : B = (1 - Q) * P := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [B, Q, P, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply] <;> norm_num

theorem antisymmetric : Qᵀ = -Q := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Q] <;> norm_num

/-- **Sparse both ways, circulating through the internal coordinate, and the precision zero
between internal and external coordinates.** -/
theorem circulates_and_precision_zero :
    B 0 2 = 0 ∧ B 2 0 = 0 ∧ Q 0 1 ≠ 0 ∧ Q 0 2 ≠ 0 ∧ P 0 2 = 0 := by
  simp [B, Q, P]

/-- The internal drift's zero entry at the external coordinate is a cancellation: the solenoidal
term through the blanket coordinate does not vanish. -/
theorem not_termwise : ¬ TermwiseUnread Q 1 P 0 2 := fun un => by
  have := (un 1).1
  simp [Q, P] at this

end Circulating

namespace Unsparse

/-- A precision with a zero entry between internal coordinate 0 and external coordinate 2. -/
noncomputable def P : Matrix (Fin 3) (Fin 3) ℝ := !![2, 1, 0; 1, 2, 1; 0, 1, 2]
/-- Circulation between the internal and blanket coordinates. -/
noncomputable def Q : Matrix (Fin 3) (Fin 3) ℝ := !![0, 1, 0; -1, 0, 0; 0, 0, 0]
/-- The drift of the Helmholtz form with noise one at each coordinate. -/
noncomputable def B : Matrix (Fin 3) (Fin 3) ℝ := !![1, -1, -1; 3, 3, 1; 0, 1, 2]

theorem helmholtz : B = (1 - Q) * P := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [B, Q, P, Matrix.mul_apply, Fin.sum_univ_three, Matrix.one_apply] <;> norm_num

theorem antisymmetric : Qᵀ = -Q := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Q]

/-- A zero precision entry, while the internal drift reads the external coordinate. -/
theorem precision_zero_and_read : P 0 2 = 0 ∧ B 0 2 ≠ 0 := by simp [P, B]

end Unsparse

section Modes

variable {m k l : Type*} [Fintype m] [Fintype k] [Fintype l] [DecidableEq m]

/-- The internal mode given blanket and external states: the stationary point of the quadratic
form in the internal coordinates, its maximum where the internal block is positive definite. -/
noncomputable def mode (Pmm : Matrix m m ℝ) (Pmk : Matrix m k ℝ) (Pml : Matrix m l ℝ)
    (b : k → ℝ) (η : l → ℝ) : m → ℝ :=
  -(Pmm⁻¹ *ᵥ (Pmk *ᵥ b + Pml *ᵥ η))

theorem mode_stationary (Pmm : Matrix m m ℝ) (Pmk : Matrix m k ℝ) (Pml : Matrix m l ℝ)
    (hP : IsUnit Pmm.det) (b : k → ℝ) (η : l → ℝ) :
    Pmm *ᵥ mode Pmm Pmk Pml b η + Pmk *ᵥ b + Pml *ᵥ η = 0 := by
  rw [mode, mulVec_neg, mulVec_mulVec, mul_nonsing_inv _ hP, one_mulVec]; abel

/-- **The internal mode reads no external state exactly at the zero block.** -/
theorem mode_unread_iff [DecidableEq l] (Pmm : Matrix m m ℝ) (Pmk : Matrix m k ℝ)
    (Pml : Matrix m l ℝ) (hP : IsUnit Pmm.det) :
    (∀ b η η', mode Pmm Pmk Pml b η = mode Pmm Pmk Pml b η') ↔ Pml = 0 := by
  constructor
  · intro same
    have key : ∀ η, Pml *ᵥ η = 0 := by
      intro η
      have h := same 0 η 0
      have s1 := mode_stationary Pmm Pmk Pml hP 0 η
      have s0 := mode_stationary Pmm Pmk Pml hP 0 0
      rw [h] at s1
      simpa using (sub_eq_zero.mpr (s1.trans s0.symm))
    ext i j
    have := congrFun (key (Pi.single j 1)) i
    simpa [mulVec_single] using this
  · rintro rfl b η η'; simp [mode]

end Modes

section Euler

/-- The four parts of the principle's partition. -/
inductive Part | internal | sensory | active | external
  deriving DecidableEq

variable {n : Type} [Fintype n] (part : n → Part)

/-- **The principle's sparse coupling** of a linear drift: the internal and active coordinates'
drift reads no external coordinate, and the sensory and external coordinates' drift reads no
internal coordinate. -/
def SparseCoupling (B : Matrix n n ℝ) : Prop :=
  ∀ i j, ((part i = .internal ∨ part i = .active) → part j = .external → B i j = 0) ∧
    ((part i = .sensory ∨ part i = .external) → part j = .internal → B i j = 0)

/-- The Euler step of the drift `−B x` with step `h`. -/
def euler (B : Matrix n n ℝ) (h : ℝ) (x : n → ℝ) : n → ℝ := x - h • (B *ᵥ x)

variable {part}

theorem euler_congr (B : Matrix n n ℝ) (h : ℝ) {x y : n → ℝ} {i : n} (same : x i = y i)
    (reads : ∀ j, B i j ≠ 0 → x j = y j) : euler B h x i = euler B h y i := by
  simp only [euler, Pi.sub_apply, Pi.smul_apply, smul_eq_mul, mulVec, dotProduct]
  rw [same]; congr 2
  apply Finset.sum_congr rfl; intro j _
  by_cases hj : B i j = 0
  · rw [hj, zero_mul, zero_mul]
  · rw [reads j hj]

/-- A coordinate's states, for each part. -/
abbrev Coords (p : Part) : Type := {j : n // part j = p} → ℝ

/-- The whole state from its four parts. -/
def glue (xi : Coords (part := part) .internal) (xs : Coords (part := part) .sensory)
    (xa : Coords (part := part) .active) (xe : Coords (part := part) .external) : n → ℝ :=
  fun j => match hp : part j with
    | .internal => xi ⟨j, hp⟩
    | .sensory => xs ⟨j, hp⟩
    | .active => xa ⟨j, hp⟩
    | .external => xe ⟨j, hp⟩

/-- The four parts of a whole state. -/
def split (x : n → ℝ) :
    Becoming.Blanket.Parts (Coords (part := part) .internal) (Coords (part := part) .sensory)
      (Coords (part := part) .active) (Coords (part := part) .external) :=
  ⟨fun j => x j.1, fun j => x j.1, fun j => x j.1, fun j => x j.1⟩

variable (part)

/-- **The Euler step as a blanketed law**: each part's next state is read off the Euler step with
the part it does not read set to nothing. -/
def eulerLaw (B : Matrix n n ℝ) (h : ℝ) :
    Becoming.Blanket.Blanketed (Coords (part := part) .internal) (Coords (part := part) .sensory)
      (Coords (part := part) .active) (Coords (part := part) .external) where
  nextInternal xi xs xa := fun j => euler B h (glue xi xs xa 0) j.1
  nextSensory xs xa xe := fun j => euler B h (glue 0 xs xa xe) j.1
  nextActive xi xs xa := fun j => euler B h (glue xi xs xa 0) j.1
  nextExternal xs xa xe := fun j => euler B h (glue 0 xs xa xe) j.1

variable {part}

omit [Fintype n] in
theorem glue_split_of_ne_external (x : n → ℝ) {j : n} (hj : part j ≠ .external) :
    glue (split (part := part) x).internal (split x).sensory (split x).active 0 j = x j := by
  unfold glue split
  split <;> simp_all

omit [Fintype n] in
theorem glue_split_of_ne_internal (x : n → ℝ) {j : n} (hj : part j ≠ .internal) :
    glue 0 (split (part := part) x).sensory (split x).active (split x).external j = x j := by
  unfold glue split
  split <;> simp_all

/-- **The Euler step of a sparsely coupled drift is the blanketed law's step**, part by part. -/
theorem split_euler {B : Matrix n n ℝ} (sparse : SparseCoupling part B) (h : ℝ) (x : n → ℝ) :
    split (part := part) (euler B h x) = (eulerLaw part B h).step (split x) := by
  have agent : ∀ i, (part i = .internal ∨ part i = .active) →
      euler B h x i = euler B h (glue (split (part := part) x).internal (split x).sensory
        (split x).active 0) i := fun i hi =>
    euler_congr B h (glue_split_of_ne_external x (by rcases hi with hi | hi <;> rw [hi] <;> decide)).symm
      fun j hB => (glue_split_of_ne_external x fun hj => hB ((sparse i j).1 hi hj)).symm
  have world : ∀ i, (part i = .sensory ∨ part i = .external) →
      euler B h x i = euler B h (glue 0 (split (part := part) x).sensory (split x).active
        (split x).external) i := fun i hi =>
    euler_congr B h (glue_split_of_ne_internal x (by rcases hi with hi | hi <;> rw [hi] <;> decide)).symm
      fun j hB => (glue_split_of_ne_internal x fun hj => hB ((sparse i j).2 hi hj)).symm
  simp only [split, Becoming.Blanket.Blanketed.step, eulerLaw, Becoming.Blanket.Parts.mk.injEq]
  exact ⟨funext fun j => agent j.1 (.inl j.2), funext fun j => world j.1 (.inl j.2),
    funext fun j => agent j.1 (.inr j.2), funext fun j => world j.1 (.inr j.2)⟩

/-- The Euler scheme's run, split into parts, is the blanketed law's course. -/
theorem split_euler_iterate {B : Matrix n n ℝ} (sparse : SparseCoupling part B) (h : ℝ)
    (x : n → ℝ) : ∀ t, split (part := part) ((euler B h)^[t] x) = (eulerLaw part B h).course (split x) t
  | 0 => rfl
  | t + 1 => by
    rw [Function.iterate_succ_apply', split_euler sparse h, split_euler_iterate sparse h x t]
    rfl

/-- **Under the principle's sparse coupling the agent is driven by its sensory course**: two Euler
runs from one internal and one active state, alike on the sensory coordinates before `t`, are alike
on the internal and active coordinates at `t` (`Becoming.Blanket.Blanketed.agent_through_sensory`). -/
theorem euler_agent_through_sensory {B : Matrix n n ℝ} (sparse : SparseCoupling part B) (h : ℝ)
    {x y : n → ℝ} (internal : ∀ j, part j = .internal → x j = y j)
    (active : ∀ j, part j = .active → x j = y j) (t : ℕ)
    (alike : ∀ s, s < t → ∀ j, part j = .sensory → (euler B h)^[s] x j = (euler B h)^[s] y j) :
    ∀ j, (part j = .internal ∨ part j = .active) → (euler B h)^[t] x j = (euler B h)^[t] y j := by
  have through := (eulerLaw part B h).agent_through_sensory (x := split x) (y := split y)
    (funext fun j => internal j.1 j.2) (funext fun j => active j.1 j.2) t
    (fun s lt => by
      rw [← split_euler_iterate sparse h x s, ← split_euler_iterate sparse h y s]
      exact funext fun j => alike s lt j.1 j.2)
  rw [← split_euler_iterate sparse h x t, ← split_euler_iterate sparse h y t] at through
  rintro j (hj | hj)
  · exact congrFun through.1 ⟨j, hj⟩
  · exact congrFun through.2 ⟨j, hj⟩

/-- The Euler–Maruyama run: each step the Euler step plus that step's noise, each coordinate's
noise its own input. -/
def emRun (B : Matrix n n ℝ) (h : ℝ) (ξ : ℕ → n → ℝ) (x : n → ℝ) : ℕ → n → ℝ
  | 0 => x
  | t + 1 => euler B h (emRun B h ξ x t) + ξ t

/-- **With noise, the agent is driven by its own noise and its sensory course.** Under the
principle's sparse coupling, two Euler–Maruyama runs from one internal and active state, with one
noise course at the internal and active coordinates before `t` and alike on the sensory coordinates
before `t`, are alike on the internal and active coordinates at `t`, whatever the drift circulates
and whatever noise the sensory and external coordinates receive. -/
theorem em_agent_through_sensory {B : Matrix n n ℝ} (sparse : SparseCoupling part B) (h : ℝ)
    {ξ ξ' : ℕ → n → ℝ} {x y : n → ℝ}
    (start : ∀ j, (part j = .internal ∨ part j = .active) → x j = y j) (t : ℕ)
    (noise : ∀ s, s < t → ∀ j, (part j = .internal ∨ part j = .active) → ξ s j = ξ' s j)
    (alike : ∀ s, s < t → ∀ j, part j = .sensory → emRun B h ξ x s j = emRun B h ξ' y s j) :
    ∀ j, (part j = .internal ∨ part j = .active) → emRun B h ξ x t j = emRun B h ξ' y t j := by
  induction t with
  | zero => exact start
  | succ t ih =>
    have prev := ih (fun s lt => noise s (Nat.lt_succ_of_lt lt))
      (fun s lt => alike s (Nat.lt_succ_of_lt lt))
    intro i hi
    simp only [emRun, Pi.add_apply]
    rw [noise t (Nat.lt_succ_self t) i hi]
    congr 1
    apply euler_congr B h (prev i hi)
    intro j hB
    rcases hpart : part j with _ | _ | _ | _
    · exact prev j (.inl hpart)
    · exact alike t (Nat.lt_succ_self t) j hpart
    · exact prev j (.inr hpart)
    · exact absurd ((sparse i j).1 hi hpart) hB

variable [DecidableEq n]

/-- **In the four parts**: with the internal and active coordinates autonomous, no solenoidal
coupling between them and the sensory and external coordinates (the 2023 paper's footnote 13), diagonal positive noise and the principle's sparse coupling, the precision entry between each
internal or active coordinate and each external one is zero. -/
theorem precision_zero_of_footnote13 {B Q P : Matrix n n ℝ} (d : n → ℝ) (dpos : ∀ i, 0 < d i)
    (anti : Qᵀ = -Q) (helm : B = (diagonal d - Q) * P) (sparse : SparseCoupling part B)
    (noQ : ∀ i k, (part i = .internal ∨ part i = .active) →
      ¬ (part k = .internal ∨ part k = .active) → Q i k = 0)
    {i j : n} (hi : part i = .internal ∨ part i = .active) (hj : part j = .external) :
    P i j = 0 :=
  precision_zero_of_autonomous B Q P d dpos anti helm (fun k => part k = .internal ∨ part k = .active) noQ j
    (fun i' hi' => (sparse i' j).1 hi' hj) i hi

/-- **The synchronous scheme's steady precision, without circulation.** With the drift `−D Π x`
(`Q = 0`), `Π` and `D` symmetric, a matrix inverse to `Π − (h/2) Π D Π` is carried to itself by one
step of `x' = (1 − h D Π) x + ξ`, `ξ` of covariance `2 h D`: it is the steady covariance (where
`1 − h D Π` has spectral radius below 1, the only one). The known order-`h` bias of the
Euler–Maruyama steady law of an Ornstein–Uhlenbeck process. -/
theorem em_steady (P D S : Matrix n n ℝ) (h : ℝ) (symmP : Pᵀ = P) (symmD : Dᵀ = D)
    (inv : (P - (h / 2) • (P * D * P)) * S = 1) (inv' : S * (P - (h / 2) • (P * D * P)) = 1) :
    S = (1 - h • (D * P)) * S * (1 - h • (D * P))ᵀ + (2 * h) • D := by
  set M := P - (h / 2) • (P * D * P) with hM
  have hAT : (1 - h • (D * P))ᵀ = 1 - h • (P * D) := by
    rw [transpose_sub, transpose_one, transpose_smul, transpose_mul, symmP, symmD]
  have i1 : M * (1 - h • (D * P)) = (1 - h • (P * D)) * M := by
    rw [hM]
    simp only [Matrix.sub_mul, Matrix.mul_sub, Matrix.one_mul, Matrix.mul_one, Matrix.smul_mul,
      Matrix.mul_smul, smul_sub, smul_smul, Matrix.mul_assoc]
    module
  have i2 : (1 - h • (P * D)) * M * (1 - h • (D * P)) = M - (2 * h) • (M * D * M) := by
    rw [hM]
    simp only [Matrix.sub_mul, Matrix.mul_sub, Matrix.one_mul, Matrix.mul_one, Matrix.smul_mul,
      Matrix.mul_smul, smul_sub, smul_smul, Matrix.mul_assoc]
    module
  rw [hAT]
  set A := 1 - h • (D * P) with hA
  set AT := 1 - h • (P * D) with hATdef
  have sms : S * M * S = S := by rw [inv', Matrix.one_mul]
  have smdms : S * (M * D * M) * S = D := by
    calc S * (M * D * M) * S = (S * M) * D * (M * S) := by simp only [Matrix.mul_assoc]
      _ = D := by rw [inv', inv, Matrix.one_mul, Matrix.mul_one]
  have e1 : A * S * AT = S * (M * A) * S * (AT * M) * S := by
    calc A * S * AT = (S * M) * A * S * AT * (M * S) := by
          rw [inv', inv, Matrix.one_mul, Matrix.mul_one]
      _ = S * (M * A) * S * (AT * M) * S := by simp only [Matrix.mul_assoc]
  have e2 : S * (M * A) * S * (AT * M) * S = S * (AT * M * A) * S := by
    rw [i1]
    nth_rw 2 [← i1]
    calc S * (AT * M) * S * (M * A) * S = S * AT * (M * S) * M * A * S := by
          simp only [Matrix.mul_assoc]
      _ = S * (AT * M * A) * S := by rw [inv, Matrix.mul_one]; simp only [Matrix.mul_assoc]
  have key : A * S * AT = S - (2 * h) • D := by
    rw [e1, e2, i2, Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul, Matrix.smul_mul, sms, smdms]
  rw [key]; abel

/-- Under sparse coupling of the drift `−D Π x`, `D` diagonal and positive, the precision has
the drift's zeros. -/
theorem precision_zero_of_drift {P : Matrix n n ℝ} {d : n → ℝ} (dpos : ∀ i, 0 < d i) {a b : n}
    (zero : (diagonal d * P) a b = 0) : P a b = 0 := by
  rw [diagonal_mul] at zero
  exact (mul_eq_zero.mp zero).resolve_left (dpos a).ne'

/-- **The four-part blanket survives the synchronous scheme without circulation**: under the
principle's sparse coupling of the drift `−D Π x`, `D` diagonal and positive and `Π` symmetric, the
steady precision `Π − (h/2) Π D Π` has a zero entry between each internal and each external
coordinate. Each term of
`Π D Π` between them passes through a coordinate that one of the two does not read. With `Q = 0`,
sparse coupling leaves the internal coordinates reading no sensory coordinate, since the sensory
coordinates read no internal one and `Π` is symmetric. -/
theorem em_keeps_four_part {P : Matrix n n ℝ} {d : n → ℝ} (dpos : ∀ i, 0 < d i) (symm : Pᵀ = P)
    (sparse : SparseCoupling part (diagonal d * P)) (h : ℝ) {i j : n} (hi : part i = .internal)
    (hj : part j = .external) : (P - (h / 2) • (P * diagonal d * P)) i j = 0 := by
  have square : (P * diagonal d * P) i j = 0 := by
    rw [mul_apply]
    refine Finset.sum_eq_zero fun k _ => ?_
    rw [mul_diagonal]
    rcases hk : part k with _ | _ | _ | _
    · rw [precision_zero_of_drift dpos ((sparse k j).1 (.inl hk) hj), mul_zero]
    · rw [entry_symm symm i k, precision_zero_of_drift dpos ((sparse k i).2 (.inl hk) hi), zero_mul,
        zero_mul]
    · rw [precision_zero_of_drift dpos ((sparse k j).1 (.inr hk) hj), mul_zero]
    · rw [entry_symm symm i k, precision_zero_of_drift dpos ((sparse k i).2 (.inr hk) hi), zero_mul,
        zero_mul]
  rw [sub_apply, smul_apply, square, precision_zero_of_drift dpos ((sparse i j).1 (.inl hi) hj),
    smul_zero, sub_zero]

/-- **The active–external entries need not stay zero**: under the same coupling, the steady
precision's entry between an active and an external coordinate is `−h/2` times the sum, over the
sensory coordinates `s`, of `Π a s · d s · Π s j`, which vanishes where `Π a s = 0` at every sensory
`s` and not in general (`Autonomous.em_loses_active_external`). -/
theorem em_active_external {P : Matrix n n ℝ} {d : n → ℝ} (dpos : ∀ i, 0 < d i)
    (sparse : SparseCoupling part (diagonal d * P)) (h : ℝ) {a j : n} (ha : part a = .active)
    (hj : part j = .external) :
    (P - (h / 2) • (P * diagonal d * P)) a j =
      -(h / 2) * ∑ k ∈ Finset.univ.filter (fun k => part k = .sensory), P a k * d k * P k j := by
  have square : (P * diagonal d * P) a j =
      ∑ k ∈ Finset.univ.filter (fun k => part k = .sensory), P a k * d k * P k j := by
    rw [mul_apply, Finset.sum_filter]
    refine Finset.sum_congr rfl fun k _ => ?_
    rw [mul_diagonal]
    rcases hk : part k with _ | _ | _ | _
    · simp [precision_zero_of_drift dpos ((sparse k j).1 (.inl hk) hj)]
    · simp
    · simp [precision_zero_of_drift dpos ((sparse k j).1 (.inr hk) hj)]
    · simp [precision_zero_of_drift dpos ((sparse a k).1 (.inr ha) hk)]
  rw [sub_apply, smul_apply, square, precision_zero_of_drift dpos ((sparse a j).1 (.inr ha) hj),
    smul_eq_mul, zero_sub, neg_mul]

end Euler

namespace Autonomous

/-- The four parts in the order external, sensory, active, internal. -/
def part : Fin 4 → Part := ![.external, .sensory, .active, .internal]

/-- A precision on the four coordinates. -/
noncomputable def P : Matrix (Fin 4) (Fin 4) ℝ :=
  !![2, 1, 0, 0; 1, 3, 1, 0; 0, 1, 3, 1; 0, 0, 1, 2]
/-- Circulation between the internal and active coordinates, and between the external and sensory
ones. -/
noncomputable def Q : Matrix (Fin 4) (Fin 4) ℝ :=
  !![0, 1, 0, 0; -1, 0, 0, 0; 0, 0, 0, -1; 0, 0, 1, 0]
/-- The drift of the Helmholtz form with noise one at each coordinate. -/
noncomputable def B : Matrix (Fin 4) (Fin 4) ℝ :=
  !![1, -2, -1, 0; 3, 4, 1, 0; 0, 1, 4, 3; 0, -1, -2, 1]

theorem helmholtz : B = (diagonal (fun _ : Fin 4 => (1 : ℝ)) - Q) * P := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [B, Q, P, Matrix.mul_apply, Fin.sum_univ_four] <;> norm_num

theorem antisymmetric : Qᵀ = -Q := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [Q]

theorem sparse : SparseCoupling part B := by
  intro i j; fin_cases i <;> fin_cases j <;> simp [part, B]

theorem autonomous : ∀ i k, (part i = .internal ∨ part i = .active) →
    ¬ (part k = .internal ∨ part k = .active) → Q i k = 0 := by
  intro i k; fin_cases i <;> fin_cases k <;> simp [part, Q]

/-- **Footnote 13's law applies**: the precision entries between the external coordinate and the
internal and active ones are zero. -/
theorem precision_zero : P 3 0 = 0 ∧ P 2 0 = 0 :=
  ⟨precision_zero_of_footnote13 (fun _ => 1) (fun _ => one_pos) antisymmetric helmholtz sparse autonomous
      (by simp [part]) (by simp [part]),
    precision_zero_of_footnote13 (fun _ => 1) (fun _ => one_pos) antisymmetric helmholtz sparse autonomous
      (by simp [part]) (by simp [part])⟩

/-- **While the steady state circulates through the internal coordinate**, which reads the sensory
coordinate only through the circulation: its drift reads it, their precision entry is zero. -/
theorem circulates : Q 3 2 ≠ 0 ∧ B 3 1 ≠ 0 ∧ P 3 1 = 0 := by simp [Q, B, P]

/-- **Sparse coupling term by term** (the 2023 paper's eq. 9): with noise one, no term of the drift
at an internal or active coordinate reads the external one, and no term of the drift at the sensory
or external coordinate reads the internal one. -/
theorem termwise : TermwiseUnread Q 1 P 3 0 ∧ TermwiseUnread Q 1 P 2 0 ∧
    TermwiseUnread Q 1 P 1 3 ∧ TermwiseUnread Q 1 P 0 3 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> intro i <;> fin_cases i <;> simp [Q, P]

/-- **The coupling form under the synchronous scheme**: two Euler–Maruyama runs of this drift from
one internal and active state, with one noise course at the internal and active coordinates and
alike on the sensory coordinate before `t`, are alike on the internal and active coordinates at
`t` (`em_agent_through_sensory`). -/
theorem em_coupling_form (h : ℝ) {ξ ξ' : ℕ → Fin 4 → ℝ} {x y : Fin 4 → ℝ}
    (start : ∀ j, (part j = .internal ∨ part j = .active) → x j = y j) (t : ℕ)
    (noise : ∀ s, s < t → ∀ j, (part j = .internal ∨ part j = .active) → ξ s j = ξ' s j)
    (alike : ∀ s, s < t → ∀ j, part j = .sensory → emRun B h ξ x s j = emRun B h ξ' y s j) :
    ∀ j, (part j = .internal ∨ part j = .active) → emRun B h ξ x t j = emRun B h ξ' y t j :=
  em_agent_through_sensory sparse h start t noise alike

/-- The synchronous scheme's step at `h = 1/10`, noise one at each coordinate. -/
noncomputable def emA : Matrix (Fin 4) (Fin 4) ℝ := 1 - (1 / 10 : ℝ) • B
/-- Its steady covariance. -/
noncomputable def emS : Matrix (Fin 4) (Fin 4) ℝ :=
  !![6805510/9368751, -2616200/9368751, 787340/9368751, -238240/9368751;
     -2616200/9368751, 5868950/9368751, -617000/3122917, 787340/9368751;
     787340/9368751, -617000/3122917, 5868950/9368751, -2616200/9368751;
     -238240/9368751, 787340/9368751, -2616200/9368751, 6805510/9368751]
/-- Its steady precision. -/
noncomputable def emM : Matrix (Fin 4) (Fin 4) ℝ :=
  !![3272541/1969162, 732890/984581, -3793/4922905, -27800/984581;
     732890/984581, 20736649/9845810, 2776762/4922905, -3793/4922905;
     -3793/4922905, 2776762/4922905, 20736649/9845810, 732890/984581;
     -27800/984581, -3793/4922905, 732890/984581, 3272541/1969162]

/-- `emS` is carried to itself by one step of `x' = emA x + ξ`, `ξ` of covariance `2/10`. -/
theorem emS_steady : emS = emA * emS * emAᵀ + (2 * (1 / 10 : ℝ)) • (1 : Matrix (Fin 4) (Fin 4) ℝ) := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [emA, B, emS, Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply] <;> norm_num

theorem emS_inverse : emS * emM = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [emS, emM, Matrix.mul_apply, Fin.sum_univ_four] <;> norm_num

/-- **With circulation the synchronous scheme can lose the blanket**: in this witness the steady
precision at `h = 1/10` has a nonzero entry between the internal and external coordinates, where the
flow's precision has none (`precision_zero`), though the drift meets footnote 13 and eq. 9 and the
agent's course is fixed by its sensory course (`em_coupling_form`). -/
theorem em_loses_internal_external : emM 3 0 = -27800 / 984581 ∧ P 3 0 = 0 := by simp [emM, P]

/-- Without circulation, the drift `−Π x` on the same precision is sparsely coupled. -/
theorem still_sparse : SparseCoupling part (diagonal (fun _ : Fin 4 => (1 : ℝ)) * P) := by
  intro i j; fin_cases i <;> fin_cases j <;> simp [part, P]

/-- **Without circulation the internal–external zero stays** (`em_keeps_four_part`). -/
theorem em_keeps (h : ℝ) : (P - (h / 2) • (P * diagonal (fun _ : Fin 4 => (1 : ℝ)) * P)) 3 0 = 0 :=
  em_keeps_four_part (fun _ => one_pos) (by ext i j; fin_cases i <;> fin_cases j <;> simp [P])
    still_sparse h (by simp [part]) (by simp [part])

/-- **And the active–external zero is lost**: the entry is `−h/2`, through the sensory coordinate. -/
theorem em_loses_active_external (h : ℝ) :
    (P - (h / 2) • (P * diagonal (fun _ : Fin 4 => (1 : ℝ)) * P)) 2 0 = -(h / 2) ∧ P 2 0 = 0 := by
  simp [P]

end Autonomous

namespace ThreePart

/-- A precision with nonzero entries between coordinate 1 and each other coordinate and a zero
entry between coordinates 0 and 2: with drift `−Π x`
and noise one at each coordinate, the continuous flow does not circulate and its steady precision is
zero between 0 and 2. Coordinate 1 reads and is read by both others: the principle's three-part
partition, not the theory's four parts (`no_four_part`). -/
noncomputable def P : Matrix (Fin 3) (Fin 3) ℝ := !![2, 1, 0; 1, 2, 1; 0, 1, 2]
/-- The synchronous scheme's steady covariance at step `1/10`. -/
noncomputable def S : Matrix (Fin 3) (Fin 3) ℝ :=
  !![2335/2898, -80/161, 725/2898; -80/161, 170/161, -80/161; 725/2898, -80/161, 2335/2898]

theorem symm : Pᵀ = P := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [P]

theorem inverse : (P - ((1 / 10 : ℝ) / 2) • (P * P)) * S = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [P, S, Matrix.mul_apply, Fin.sum_univ_three] <;> norm_num

theorem inverse' : S * (P - ((1 / 10 : ℝ) / 2) • (P * P)) = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [P, S, Matrix.mul_apply, Fin.sum_univ_three] <;> norm_num

/-- `S` is the synchronous scheme's steady covariance at step `1/10` (`em_steady`). -/
theorem steady :
    S = (1 - (1 / 10 : ℝ) • P) * S * (1 - (1 / 10 : ℝ) • P)ᵀ + (2 * (1 / 10 : ℝ)) • 1 := by
  have := em_steady P 1 S (1 / 10) symm transpose_one (by rw [Matrix.mul_one]; exact inverse)
    (by rw [Matrix.mul_one]; exact inverse')
  rwa [Matrix.one_mul] at this

/-- **No assignment to the four parts makes the chain sparsely coupled** with coordinate 0 internal
and coordinate 2 external: coordinate 1 reads both, and each part forbids reading one of them. -/
theorem no_four_part (part : Fin 3 → Part) (h0 : part 0 = .internal) (h2 : part 2 = .external) :
    ¬ SparseCoupling part P := by
  intro sparse
  rcases h1 : part 1 with _ | _ | _ | _
  · exact absurd ((sparse 1 2).1 (.inl h1) h2) (by simp [P])
  · exact absurd ((sparse 1 0).2 (.inl h1) h0) (by simp [P])
  · exact absurd ((sparse 1 2).1 (.inr h1) h2) (by simp [P])
  · exact absurd ((sparse 1 0).2 (.inr h1) h0) (by simp [P])

/-- **The synchronous scheme loses a zero the flow keeps**: at every step `h` the entry of
`Π − (h/2) Π²` between coordinates 0 and 2 is `−h/2`, while `Π`'s is zero. It is the steady
precision for `0 < h < 2/(2 + √2)`, where `1 − h Π` has spectral radius below 1 (`Π`'s eigenvalues
are `2 − √2`, `2` and `2 + √2`). -/
theorem em_loses_zero (h : ℝ) : (P - (h / 2) • (P * P)) 0 2 = -(h / 2) ∧ P 0 2 = 0 := by
  simp [P]

end ThreePart

end Becoming.LinearBlankets
