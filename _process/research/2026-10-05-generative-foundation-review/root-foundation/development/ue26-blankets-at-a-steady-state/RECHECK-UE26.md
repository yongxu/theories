# UE26: independent adversarial recheck of the revised kit

31 October 2026. AI-written recheck of the revised [DESIGN.md](DESIGN.md) (as committed in `5c69ae01e`; the live design takes these findings in its §7), the core leaf [`kit/tree/Becoming/BlanketWeights.lean`](kit/tree/Becoming/BlanketWeights.lean) and the periphery module `free-energy/LinearBlankets.lean`, against the [review](REVIEW-UE26-DESIGN.md) and the [literature check](LITERATURE-CHECK.md). Every number below was recomputed with exact fractions. The one new Lean probe is reproduced in the appendix, because the scratchpad that held it is volatile.

## Verdict

**Land after the listed fixes.** The Lean is sound:

- **Core.** It builds through `scratch_build.py`: 44 theorems in 87 declarations, and no declaration has axioms.
- **Periphery.** `check_linear_blankets.py` passes: 49 theorems and 76 declaration audits, with `propext`, `Classical.choice` and `Quot.sound` only. Running the checker replaced the receipt with a new passed one over the same source hashes and added the retained run `linear-blankets-checks/20261031T045758.490277Z`.
- **Correctness.** Every theorem proves what its statement says.

One mathematical claim in the texts is wrong, and it needs one new periphery witness:

- The texts say the synchronous scheme loses the blanket "for a three-part partition, not for the theory's four parts".
- In the four parts, with circulation, the synchronous scheme loses it, even under footnote 13 and the paper's term-by-term definition (finding 1).
- The witness offered for the loss, `ThreePart`, is not a blanketed law at all.

The other findings are scope, standing and wording fixes.

## How each review finding was taken

| Finding | Status |
|---|---|
| F1 | Taken. Laws 3, 6 and 7 are stated as sufficient. `Turning`, `Circulating` and `Autonomous` are proved. |
| F2 | (a) and (b) taken: `emRun`, `em_agent_through_sensory`, and no "whatever circulates" in the noiseless law. (c) is not achieved in the periphery: the system that loses the blanket (`ThreePart`) is not one the coupling-form law covers (finding 1). The core's `SynchronousCopy` does compare one system. |
| F3 | Taken. |
| F4 | Taken: `crossFormOn_of_crossForm` and `crossForm_of_crossFormOn`. The counterexample for non-covering listings is a remark with no Lean witness (finding 12). |
| F5 | Taken. The sixth entry is dropped and law 8 is proved. Novelty wording: finding 8. |
| F6 | Law and witness taken. The review's note on law 3's limit as a counterpart is missing (finding 9). |
| F7 | Kelly, Biehl and Liggett taken. Laws 7, 10 and 12 carry no standing (finding 9). |
| F8 | Taken: `row_zero_iff`, the current as a correspondence, the `ReadsDirectly` remark. |
| F9 | Taken. |
| F10 | Taken in the text. `PosDef` is named, not assumed, which is acceptable since no algebraic law needs it. |
| F11 | Taken, except that §4 cites `ThreePart` as the theory's synchronous blanket and states the coupling form too widely (findings 1, 7). |
| F12 | Core taken. The periphery still uses "apart" for a zero precision entry (finding 12). |
| F13 | Taken: `IndependentGiven` by shares under `restrict`, both directions, and `restrict_independent_case` restates `restrict_independent` exactly. |
| F14 | `Cycle` and the linter warnings taken. The probe the core header cites for `SynchronousCopy`'s uniqueness does not exist (finding 10). |
| F15 | **Not in the design text** (finding 5). |

## Numbers checked

Every quoted number is correct:

- **Core `LagRelay`.**
  - Its weights 31, 15, 9, 17, 17, 9, 15, 31 satisfy global balance.
  - The 8×8 generator has rank 7, so they are unique up to scale.
  - At s = 0: 15·72 = 1080 and 46·24 = 1104.
- **`SynchronousCopy`.**
  - The weights 9, 3, 1, 3, 3, 1, 3, 9 (exact copy) and 6, 3, 3, 4, 4, 3, 3, 6 (a miss at 1 in 4) are each carried to 64 times themselves by one step.
  - Kᵀ − I has rank 7 in both cases.
  - 3·16 = 48 and 9·6 = 54.
  - The exact case is conditionally independent because (μ, s, e) = (e₋₂, e₋₁, e₀) and the external chain is Markov.
- **`Cycle`.** The period visits (F,F,2), (F,T,3), (T,T,0) and (T,F,1).
- **Periphery `LagRelay`.**
  - Lyapunov holds.
  - Π = [[80, −48, 4], [−48, 116, −46], [4, −46, 131]]/109.
  - Q has Q₀₁ = 5/8, Q₀₂ = 1/4 and Q₁₂ = 1/2.
- **`Circulating` and `Autonomous`.** Each B is (I − Q)Π as stated.
- **`ThreePart`.** S at h = 1/10 satisfies S = ASAᵀ + (1/5)I, and its inverse has entry (0, 2) = −1/20.

## Findings

### 1 (error). The four-part synchronous scheme loses the blanket with circulation, and `ThreePart` is not the theory's blanket

**Where.**

- DESIGN §3 law 12, last two bullets.
- §4, third row, last bullet ("`SynchronousCopy`, `em_keeps_four_part`, `ThreePart`").
- §5, "whether `em_keeps_four_part` extends … to circulation".
- §7, F2 row.
- `LinearBlankets` header, last bullet.
- The checker's `SCOPE`.

**Evidence.**

- **(a) `Autonomous` under Euler–Maruyama.** Take `Autonomous` (four parts) with D = I and A = I − hB.
  - It satisfies `SparseCoupling` and footnote 13 (`Autonomous.autonomous`). It also satisfies the paper's eq. 9 term by term: every term of B₃₀, B₂₀, B₀₃ and B₁₃ vanishes.
  - The continuous flow has Π₃₀ = Π₂₀ = 0 (`Autonomous.apart`).
  - The exact steady covariance of x' = Ax + ξ, with Cov ξ = 2hI, at h = 1/10 has precision entry (internal, external) = **−27800/984581**. At h = 1/100 the entry is −29663000/13858483841, so the loss is of order h.
  - The appendix probe proves S = ASAᵀ + (1/5)I, S·M = 1 and M₃₀ ≠ 0 against the pinned Mathlib (standard axioms; one unused-simp warning). A float iteration of the recursion agrees to 13 digits.
- **(b) The theory's own law covers this system.** `em_agent_through_sensory` holds for it (`Autonomous.sparse`). So `Autonomous` under Euler–Maruyama is the single system F2(c) asked for, in the four parts: the coupling form holds pathwise and the statistical form fails.
- **(c) `em_keeps_four_part` covers no perception through sensory states.** With Q = 0 and B = Π symmetric, `SparseCoupling` forces Π_μs = 0 (the sensory part does not read the internal one, and Π is symmetric) and Π_aη = 0.
  - So the internal coordinates read no sensory coordinate. This is the "simple case" of Friston, Da Costa and Parr 2021.
  - Law 8(b) (and footnote 13's allowed Q_μa) make reading sensory states pass through circulation. Exactly then, (a) shows the synchronous scheme losing the blanket.
- **(d) `ThreePart` is not a `Blanketed` law.**
  - Coordinate 1 reads coordinate 0 (B₁₀ = 1) and coordinate 2 (B₁₂ = 1).
  - Under `SparseCoupling`, a sensory coordinate may not read the internal one, and an active coordinate may not read the external one. So no assignment of coordinate 1 to a part satisfies `SparseCoupling` with 0 internal and 2 external.
  - It is the principle's coarse three-part partition and lies outside every law of the theory's blanket.

**Fix.**

- **New witness.** Add `Autonomous.em_couples`, with S and M from the appendix, and `em_agent_through_sensory` applied to `Autonomous.sparse`.
- **Law 12, restated.**
  - Without circulation, the four-part synchronous scheme keeps the internal–external zero (`em_keeps_four_part`). There, by `SparseCoupling`, the internal coordinates read no sensory coordinate.
  - With circulation it can lose it, even under footnote 13 and eq. 9 (`Autonomous.em_couples`).
  - `ThreePart` shows the loss without circulation in the principle's three-part partition, which the theory's four parts exclude.
- **§4.** Replace `ThreePart` by `Autonomous.em_couples` in the list for "the theory's synchronous blanket".
- **§5.** Remove "or to circulation"; it is now answered: it does not extend.
- **Elsewhere.** Update the header, the F2 row and the checker's `SCOPE` to match.

### 2 (gap/underclaim). Unequal diagonal noise is a law, not numerics

**Where.** Law 12 ("an exact computation … with unequal diagonal noise also kept the zero; that is numerics, not a law"), §5, and `em_steady`'s restriction to B = Π.

**Evidence.**

- **The law.** For Q = 0, B = DΠ with D symmetric, and A = I − hDΠ, the steady precision is **Π − (h/2) Π D Π**.
- **Derivation.** Put X = DΠ. Then Π⁻¹Aᵀ = AΠ⁻¹, every function of X commutes with every other, and S = (I − (h/2)X)⁻¹Π⁻¹. So S − ASAᵀ = (I − (h/2)X)⁻¹(2hX − h²X²)Π⁻¹ = 2hXΠ⁻¹ = 2hD.
- **Check.** It was confirmed exactly on the four-coordinate chain for D = I, D = diag(1, 2, 3, 1/2) and D = diag(5, 1/3, 2, 7).
- **The zero.** For D diagonal, (ΠDΠ)_μη = Σ_k Π_μk D_kk Π_kη vanishes by `em_keeps_four_part`'s own argument.
- **What is still lost.** The scheme does lose the zeros Π_aη and Π_sμ: the entry becomes −(h/2)Π_as D_s Π_sη, which is −1/20, −1/10 and −1/60 in the three cases. That loses a ⊥ η given the rest, not the blanket's block.

**Fix.** Generalize `em_steady` to B = DΠ with the precision Π − (h/2)ΠDΠ, and `em_keeps_four_part` to diagonal D. Drop the "numerics" sentence and the §5 item. Say that the a–η and s–μ zeros are lost, so a reader does not take "keeps" to cover them.

### 3 (overclaim). `ThreePart.couples` "at every step h"; what "stable" means for A; the loss vanishes as h → 0

**Evidence.**

- **The step range.** Π has eigenvalues 2 − √2, 2 and 2 + √2.
  - The recursion has a steady law only for 0 < h < 2/(2 + √2) ≈ 0.586, where A has spectral radius below 1.
  - At h = 2/λ, Π − (h/2)Π² is singular.
  - The Lean proves the matrix entry for every h. It proves the steady precision only where M is invertible.
- **"Stable".** The header's "unique for A stable" uses the word that elsewhere in the same header means B Hurwitz-stable.
- **Order h.** The loss in `ThreePart`, and in (1a), is of order h. `em_steady` is the standard O(h) bias of Euler–Maruyama's invariant law for an Ornstein–Uhlenbeck process.

**Fix.**

- Write "for every h with 0 < h < 2/λ_max(Π)".
- Write "spectral radius below 1" for A.
- Label `em_steady` known.
- Say once that the asynchronous chain is the discrete counterpart of the principle's continuous time with independent noise per coordinate, where one coordinate jumps at a time. Then the synchronous losses are seen to belong to the theory's discrete-time steps, and in the linear case they vanish as h → 0.

### 4 (gap: fairness to the principle). The linear loss witnesses are footnote-10 cancellations; under eq. 9 the linear blanket holds by definition

**Where.** §4, third row ("It can fail with circulation (the relays)"); law 9; the `LinearBlankets` header bullet on sufficiency.

**Evidence.**

- **The witnesses cancel.**
  - In the linear `LagRelay`, B₀₂ = 0 only by cancellation: its terms (I − Q)₀ₖΠₖ₂ are 4/109, 115/436 and −131/436.
  - In `Circulating`, B₀₂'s terms are 0, −1 and 1, and B₂₀'s are −1, 1 and 0.
  - Both are excluded by the paper's footnote 10.
- **Under eq. 9 the zero is definitional.** Under eq. 9 at (μ, η), `unread_zero` gives H_μη = 0 directly, since Γ_μ H_μη = 0 is one of eq. 9's terms. So in the linear case the statistical blanket holds by definition under the paper's own definition.
- **Only `Autonomous` is term-by-term.**
- **Scope.** "Can fail" holds only for `SparseCoupling` as a zero entry, the paper's eq. 13 gloss.

**Fix.**

- In law 9 and in the header, label each linear witness by the definition it meets: whole entry only (`LagRelay`, `Circulating`), or term by term (`Autonomous`).
- In the §4 row, add: "under the 2023 paper's term-by-term definition, in the linear case, the zero precision entry is one of the definition's own terms (law 8a); the losses are where sparse coupling is read as a zero Jacobian entry, and in the synchronous scheme (finding 1)".

### 5 (gap). F15 is claimed taken but is not in the design text

**Where.** DESIGN §3 law 2 and law 5; the docstrings of `cross_of_move` and `ratio_of_cross`.

**Evidence.**

- **Law 2** says detailed balance makes the cross form "equivalent" to the ratio condition, with no positivity. Without positivity it fails: with every rate 0, the ratio condition holds and the cross form need not.
- **The Lean** needs r, s′ > 0 for one direction and a′, c > 0 for the other. The docstrings do not say so.
- **Law 5** omits S symmetric and invertible (and Π invertible for the converse).

**Fix.** State each direction's positivity in law 2 and in both docstrings. State law 5's hypotheses.

### 6 (gap). The stochastic time-unrolled correspondence needs conditions on the start

**Where.**

- Law 11, third bullet ("With independent noises, this is the stochastic time-unrolled blanket").
- The header's matching clause.
- §1 ("This is independence given the blanket's history … it needs no steady state").

**Evidence.**

- `em_agent_through_sensory` fixes the agent's start.
- **Conditional independence of the paths.** Take the internal path and the external path given the blanket's path. Two things give it:
  - the agent's noise independent of the world's and of the start;
  - and either the agent's start in the conditioning, or the agent's and world's starts independent.
- **The steady state does not supply the second.** At a steady state the start is drawn from a law in which μ and η can be dependent (`LagRelay`: Π₀₂ = 4/109). Then, given the blanket path alone, the internal path still carries μ(0)'s information about η(0).
- **The source.** Virgo, Rosas and Biehl (2022) say "under mild assumptions". Their text could not be read here, so those assumptions should be stated in the record, not attributed.

**Fix.** State the correspondence with its assumptions: noises independent across the agent and the rest and of the start, and the agent's start conditioned on (or independent of the world's). The same goes for §1's sentence.

### 7 (overclaim). The coupling form "for every sparsely coupled scheme"; `SynchronousCopy` is not joined to `Blanketed`

**Where.** §4 third row, first bullet; the core header's fourth bullet ("keeps the coupling form").

**Evidence.**

- **What is proved.** The coupling form is proved for determined `Blanketed` laws, and for the linear Euler and Euler–Maruyama schemes with additive noise. No nonlinear stochastic scheme is covered.
- **`SynchronousCopy`.** It is a kernel whose factors read what `Blanketed` allows by inspection of `kernel`. No theorem states its coupling form.

**Fix.**

- Write "for every determined blanketed law and every sparsely coupled linear Euler–Maruyama scheme with additive noise (pathwise)".
- In the core header, say that `SynchronousCopy`'s factor structure is by construction. Optionally, add a lemma that `kernel` is a product of factors with the reading pattern of `Blanketed`.

### 8 (overclaim). Law 8 on the page: "in the linear case", and its standing

**Where.** §4, the blanket row of §2; §4 Reading ("Where the novelty lies … the general form of law 8").

**Evidence.**

- **Scope.** `TermwiseUnread` is eq. 9 with constant Q, Γ and H. The nonlinear eq. 8 terms (∂Q, state-dependent H) are absent.
- **Depth.** (b) and (c) are each a few lines from eq. 10 (`unread_zero`).
- **Coverage.** The literature check did not read Friston 2019 (arXiv 1906.10184), the paper's fullest treatment of sparse coupling.

**Fix.**

- Write "in the linear case" in the §4 row.
- Give law 8 the standing "near-definitional corollaries of eqs. 9–10; the general form of (b) and corollary (c) not found in the sources checked (Friston 2019 not checked)".
- Weaken the Reading's novelty clause accordingly.

### 9 (gap). Missing standings and the counterpart note

**Evidence.**

- **Law 7** has no standing.
  - Footnote 13 is the paper's own condition, and the review's F6 gave the scalar algebra. The literature check names Heins and Da Costa's eq. 15 for the normal form.
  - What is the kit's own is the proof for any block of coordinates with diagonal positive noise, by the quadratic form of D − Q.
- **Law 10** (`mode_unread_iff`) is elementary Gaussian conditioning.
- **Law 12** (`em_steady`): see finding 3.
- **The counterpart note (review F6).** "Law 3 … covers only Q_α· = 0" was not taken.
  - Law 3 (detailed balance of the internal moves) corresponds to `row_zero_iff`, that is Q_μ· = 0.
  - `apart_of_autonomous` with the internal coordinates as the set is weaker: it allows circulation among internal coordinates. `Turning` is that case's discrete counterpart.
  - Footnote 13's autonomous set {μ, a} has no discrete law in the core.

**Fix.** Add the standings and this note to law 6 or law 7.

### 10 (minor). The cited probes are missing

**Where.** The core header ("their uniqueness … a correspondence checked by an exact solve in the study's probes"); law 12 ("an exact computation …").

**Evidence.**

- Only `probes/relay_weights.py` solves a chain (`LagRelay`).
- No file in `probes/` or `review-probes/` solves `SynchronousCopy`'s kernels or the unequal-noise chain.
- The recheck's exact solve confirms both uniqueness claims (rank 7).

**Fix.** Add a probe solving both kernels. The unequal-noise computation becomes the law of finding 2.

### 11 (minor). Law 3's hypothesis worded more strongly than the Lean

**Where.** DESIGN §2 ("At each blanket state they form one relation, the same at every external state"); the docstrings of `cross_of_closure` and `crossForm_of_detailedBalance` ("the moves of positive rate").

**Evidence.**

- **The move relation.** The Lean asks only for a relation `adj b`, contained in the moves of positive rate at every external state, whose closure holds the internal states. Other moves may come and go with e.
- **Steadiness.** It is not a hypothesis. The law holds for any positive weighting in detailed balance with the internal moves, which is why it is local.

**Fix.**

- Write "the moves present at every external state join the internal states".
- Add "at every external state" to the docstrings.
- Say that steadiness is not assumed.

### 12 (minor). Names, citations and unproved remarks

- **"apart" in periphery names.** `apart_of_autonomous`, `apart_of_footnote13`, `Autonomous.apart`, `Circulating.circulates_and_apart` and `Unsparse.apart_and_read` use "apart" for a zero precision entry. F12 retired that sense, because `Blanket` uses "tells apart" for distinguishing. Suggested: `precision_zero_of_autonomous`, `precision_zero_of_footnote13`, `Autonomous.precision_zero`, `Circulating.circulates_and_independent`, `Unsparse.independent_and_read`.
- **Which 2023 paper.**
  - The core header cites "Friston, Da Costa, Sakthivadivel and others 2023" (Path integrals, particular kinds, and strange things).
  - The design and the periphery's "Friston and others 2023" mean the Physics Reports paper (Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis, Parr).
  - These are two different papers; name each in full in the records.
- **Unproved remarks.** "Constant noise has no counterpart of `ReadsDirectly`" (law 6) and "on listings that do not cover the types, the converse fails" (law 1) have no Lean. Mark them as remarks, or add the one-line witness for the second.
- **"Scalar coordinates".** Heins and Da Costa's eq. 13 is in block form, and the Lean is its scalar case. The design's §1 reads as if the paper were scalar; write "its scalar case".

## Kelly attribution

The attribution is correct as stated, given the literature check:

- Theorem 9.3 is on p. 189, with its proof on p. 190.
- Condition (iii) is the connectivity of a site's values with the other sites fixed, and Exercise 9.2.2 shows it cannot be dropped.
- "What remains of (ii) once only ratios are restricted" fairly describes the e-independent move relation. `MovesReadExternal` meets every other hypothesis (detailed balance, closure at each (s, e), equal ratios on shared moves, positive weights) and fails the cross form.
- Citing "Kelly's proof at the internal site" rather than the theorem verbatim follows the literature check. Liggett is cited by section only.

## Appendix: the Euler–Maruyama probe for `Autonomous` (finding 1)

It was compiled with `lake env lean` in `~/repos/生生不息` (Mathlib v4.30.0-rc2). All three theorems report `[propext, Classical.choice, Quot.sound]`. The coordinates are ordered (external, sensory, active, internal), as in `LinearBlankets.Autonomous`.

```lean
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic
open Matrix

noncomputable def B : Matrix (Fin 4) (Fin 4) ℝ :=
  !![1, -2, -1, 0; 3, 4, 1, 0; 0, 1, 4, 3; 0, -1, -2, 1]
noncomputable def A : Matrix (Fin 4) (Fin 4) ℝ := 1 - (1/10 : ℝ) • B
noncomputable def S : Matrix (Fin 4) (Fin 4) ℝ :=
  !![6805510/9368751, -2616200/9368751, 787340/9368751, -238240/9368751;
     -2616200/9368751, 5868950/9368751, -617000/3122917, 787340/9368751;
     787340/9368751, -617000/3122917, 5868950/9368751, -2616200/9368751;
     -238240/9368751, 787340/9368751, -2616200/9368751, 6805510/9368751]
noncomputable def M : Matrix (Fin 4) (Fin 4) ℝ :=
  !![3272541/1969162, 732890/984581, -3793/4922905, -27800/984581;
     732890/984581, 20736649/9845810, 2776762/4922905, -3793/4922905;
     -3793/4922905, 2776762/4922905, 20736649/9845810, 732890/984581;
     -27800/984581, -3793/4922905, 732890/984581, 3272541/1969162]

theorem steady : S = A * S * Aᵀ + (2 * (1/10 : ℝ)) • (1 : Matrix (Fin 4) (Fin 4) ℝ) := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [A, B, S, Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply, Matrix.transpose_apply] <;> norm_num

theorem inverse : S * M = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [S, M, Matrix.mul_apply, Fin.sum_univ_four] <;> norm_num

theorem internal_external : M 3 0 ≠ 0 := by simp [M]
```
