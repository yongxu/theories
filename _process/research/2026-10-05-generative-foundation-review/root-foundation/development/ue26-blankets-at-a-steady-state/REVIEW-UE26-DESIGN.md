# UE26 design: independent adversarial review

31 October 2026. AI-written review of [DESIGN.md](history/DESIGN.md) and its [probes](probes/). It also covers the two drafts the coordinator named (the core `kit/tree/Becoming/BlanketWeights.lean` and the periphery `free-energy/LinearBlankets.lean`), which were read but not recompiled. The review probes were in the session scratchpad (`ue26review/`), which is volatile, so the evidence each finding needs is restated here, and the one Lean probe written for the review is reproduced in the appendix.

## Verdict

**Revise the design before the Lean lands.** The probes compile as claimed. The core probe has 11 theorems in 22 declarations, every axiom report empty (rerun through `scratch_build.py`). The Mathlib probe compiles against the pinned Mathlib, and each of its nine theorems reports only `propext`, `Classical.choice` and `Quot.sound`, with four unused-simp-argument linter warnings. Laws 2, 3, 5, 6, 8 and 9 are true with the hypotheses the probes carry.

Four problems remain:

- **The unifying claim is false in both settings.** The claim is that "the condition is one structure: whether the steady state circulates through the internal moves", so that the two blankets "coincide where nothing circulates … and part otherwise". No circulation is a sufficient condition, not the condition: steady states that circulate through the internal part and keep the statistical blanket exist discretely, linearly, and in the paper's own normal form (F1, F6).
- **Law 10 joins two different dynamics.** It joins a noiseless synchronous scheme to a stochastic steady state. Once noise is added, the synchronous scheme loses the statistical blanket even with no circulation (F2, F3).
- **The proposed sixth entry is unfair to the 2023 paper.** The paper defines sparse coupling term by term (eq. 9), sets cancellation aside (footnote 10), and makes absent solenoidal coupling between autonomous and non-autonomous states a condition of its guarantee (footnote 13). Under eq. 9, the relay's influence graph cannot occur at all (F5).
- **Most laws are known results and must be labelled so** (F7).

## Findings

### F1 (error). "Coincide where nothing circulates … and part otherwise" is false, discretely and linearly

**Where.** §1 ("In both the condition is one structure: whether the steady state circulates through the internal part's moves"); §4 ("They coincide where nothing circulates through the internal coordinates and the noise is each coordinate's own, and part otherwise"); law 10 ("the statistical one only without circulation").

**Evidence.** Each case was computed with exact fractions.

- *Linear, the full relay pattern.*
  - The model: Π = [[2,1,0],[1,2,1],[0,1,2]] and Q = [[0,1,−1/2],[−1,0,1],[1/2,−1,0]], with D = I. Then B = (I − Q)Π = [[1,−1/2,0],[3,2,−1],[0,5/2,3]].
  - The Lyapunov equation `B S + S Bᵀ = 2I` holds for S = Π⁻¹, and Q is recovered as ½(S Bᵀ − B S).
  - The coupling: B₀₂ = B₂₀ = 0, and all four relay couplings are nonzero (B₀₁ = −1/2, B₁₀ = 3, B₁₂ = −1, B₂₁ = 5/2).
  - The result: Q's internal row is (0, 1, −1/2), so the steady state circulates through the internal coordinate, and still Π₀₂ = 0. Sparse coupling holds, it circulates, and the blanket holds.
- *Discrete.*
  - The chain: an internal part in ℤ₃ moves i → i+1 at rate 1, reading nothing, and the blanket and external bits each flip at rate 1.
  - The result: uniform weights satisfy global balance. The internal moves are not in detailed balance (a 3-cycle), and the cross form holds.
- *The paper's own normal form:* see F6.

**Fix.**

- State no circulation through the internal moves as sufficient, with the drift (linearly) or the rate ratio (discretely) reading no external state.
- State that circulation can break the blanket (the relays) and need not (the witnesses above). Add both witnesses as laws, so the boundary is stated rather than implied.
- The exact linear condition is `zero_iff_solenoidal`, which is Heins and Da Costa's eq. 13. Say so wherever "the condition" is named.

### F2 (error). Law 10: the noiseless Euler step has no steady state, and with noise the synchronous scheme loses the blanket even without circulation

**Where.** Law 10 ("`agent_through_sensory` holds for every such scheme, circulating or not … the time-unrolled blanket always holds, and the statistical one only without circulation"). The periphery draft says the same in `euler_agent_through_sensory` ("whatever circulates") and in its module header ("circulation or not").

**Evidence.**

- *The draft's scheme has no noise.* `euler B h x = x − h • (B *ᵥ x)`. Q is defined only through the noise (Q = ½(S Bᵀ − B S), with S solving the Lyapunov equation for D). A scheme without noise has no steady density beyond its fixed point, so "circulating or not" does not apply to it.
- *With noise the statistical blanket fails at Q = 0.* Take Euler–Maruyama, `x' = (I − hB)x + √(2hD) ξ`, with no circulation: Π tridiagonal as in F1, B = Π, D = I, so Q = 0 and Π₀₂ = 0. The steady covariance S_h solves `S = A S Aᵀ + 2h I` with A = I − hB. Its precision has entry (0, 2) equal to −1/20 at h = 1/10 and −1/200 at h = 1/100. In this commuting case that is exactly (Π − (h/2)Π²)₀₂ = −h/2.
- *Conclusion.* The synchronous scheme's steady law is not held apart for any h > 0, although the continuous flow has no circulation and the continuous blanket holds.

**Fix.**

- (a) Add noise as each part's own input. Either the noise course becomes part of each part's state, or a `Blanketed` variant takes inputs. Then state the time-unrolled blanket for Euler–Maruyama given each side's noise course. With independent noise per coordinate this is the stochastic form (Virgo, Rosas and Biehl 2022), and it holds circulating or not.
- (b) For the noiseless scheme, drop "circulating or not" and "whatever circulates".
- (c) State, as a periphery witness, that the synchronous scheme's steady law loses the zero precision entry even at Q = 0. Then the sentence "the time-unrolled blanket always holds, and the statistical one …" compares one system, not two.

### F3 (overclaim). Law 3 is not "in the theory's own discrete terms"

**Where.** §1 ("twice: in the theory's own discrete terms, in the pure core").

**Evidence.**

- Law 3's model is a continuous-time chain in which one part moves at a time ("read through its rates, with no clock"). That is a new model in the core.
- The theory's own blanket, `Blanket.Blanketed`, is a determined law in which all parts move at once, synchronously.
- Under synchronous updating "internal moves" are not defined, and once noise is added the steady law is generically not held apart, whatever the balance. F2 is the linear instance; the discrete counterpart is the known difference between parallel (probabilistic cellular automaton) and sequential dynamics.
- The only witness that joins law 3's chains to `Blanketed` is the occupation weighting.

**Fix.** Name law 3's model honestly: asynchronous dynamics, one part moving at a time. State that the theory's synchronous blanket has the time-unrolled form, and generically not the time-synchronous statistical one. Then "twice" becomes two models, each stated with its scope.

### F4 (error in the design's wording; fixed in the draft). Law 1 fails when the listings do not cover the types

**Where.** §2 and law 1 ("Over listings, for natural weights, conditional independence in counts is equivalent to the cross form"), where the cross form ranges over the whole type.

**Evidence.**

- *Counterexample.* Take I = E = {0, 1, 2} with both listings [2], at one blanket state, and w(0,b,0) = w(1,b,1) = 1, all other weights 0.
  - Held apart in counts over the listings: true. Every listed sum is 0, so both sides vanish.
  - Cross form: false, since 1·1 ≠ 0·0.
- *When the equivalence holds.* It holds when the listings cover the types, or when W(b) > 0 at every b. In the second case, held apart gives the cross form for all states, listed or not: multiply two instances and cancel W(b)².
- *The draft.* It states `HeldApart ⇔ CrossFormOn`, with both sides restricted to listed states, and handles W(b) = 0 through `whole_zero_entry`. That is correct, and with duplicates in the listings as well.

**Fix.**

- Update the design text to "the cross form on the listed states".
- Add the one-line `crossFormOn_of_crossForm`, so that law 3's `CrossForm` reaches `HeldApart`. Without it, law 3 never meets law 1's counts form.
- Optionally add `crossForm_of_crossFormOn` for listings that cover the types.

### F5 (overclaim). The sixth entry is a straw man; under eq. 9 the relay's influence graph cannot occur

**Where.** §1 ("The paper glosses sparse coupling as an absent influence … It then defines it term by term") and §4 ("A sixth entry … forbidden discretely by the circulating relay and linearly by the canonical relay. Under the paper's term-by-term definition it holds, and law 6 states exactly that case").

**Evidence.** From the 2023 text (arXiv 2201.06387v3, §4):

- **The order is reversed in the design.** The definition comes first ("We can now define sparse coupling as a solution to this equation, in which all the terms are identically zero"), with eq. 9. The gloss follows it ("Sparse coupling means that the Jacobian coupling states u and v is zero"). The paper then adds that this definition "precludes solenoidal coupling with u that depends on v". Footnote 10 excludes cancellation. Footnote 13 conditions the blanket's guarantee "In the absence of solenoidal coupling between autonomous and non-autonomous states". The canonical relay has Q₀₁ = 5/8 between the internal and the blanket state, so it is outside footnote 13 and is footnote 10's cancellation case.
- **Under eq. 9 the sentence is near-definitional.** The conclusion H_uv = 0 is itself one of eq. 9's terms (Γ_u H_uv = 0).
- **"Law 6 states exactly that case" is false.** Law 6's hypothesis is Q_i· = 0, a whole row. Eq. 9 at (μ, η) requires Q_μη = 0, Q_μi H_iη = 0 for each i, and H_μη = 0. Neither implies the other.
- **The discrete relay is not a model in the paper's terms.** It has no Jacobian or Hessian, and §3 of the page requires "a model in the principle's own terms". So it cannot forbid the sentence.
- **Under eq. 9 the three-state relay cannot exist.** The review probe `Eq9Relay.lean` (appendix; compiled against the pinned Mathlib, standard axioms) assumes Q antisymmetric, Γ diagonal and positive, H symmetric with a positive diagonal, and only three of eq. 9's terms: Q₁₀H₀₀ = 0, Q₂₀H₀₀ = 0 and Γ₁H₁₀ = 0. From these, J₀₁ = ((Q − Γ)H)₀₁ = 0: the internal state cannot read the blanket.
- **The general form.** Under eq. 9 in the linear case, a directed influence v → u gives H_uv = 0 and Q_uv = 0. Its only carrier is a third state through the solenoidal flow, J_uv = Σ_{i≠u,v} Q_ui H_iv. A state that no other state reads reads nothing but itself.
- **The failure is already published.** Two of the paper's authors (Heins and Da Costa 2022) state it, and so do Aguilera et al.

**Fix.**

- Drop the sixth entry.
- If the page is to gain something here, state a law rather than a forbidding: in the linear case, eq. 9 itself confines directed influences to solenoidal carriage through a third state, and a state no other state reads reads nothing. Check it against Aguilera et al.'s symmetric-loop result (their eq. 33 and Fig. 4C) before calling it new.
- Place it in §2 or in the §5 row, not in §3.

### F6 (overclaim/gap). Law 6's condition is stronger than the paper's own condition (footnote 13) and than Heins and Da Costa's eqs. 15–18

**Evidence.**

- *Algebra.* Take the four parts (η, s, a, μ) with scalar coordinates and footnote 13's Q_αβ = 0, so Q_μs = Q_μη = Q_as = Q_aη = 0, while Q_μa is allowed. Sparse coupling J_μη = J_aη = 0 gives two equations:
  - D_μ Π_μη = Q_μa Π_aη;
  - D_a Π_aη = −Q_μa Π_μη.

  Hence Π_μη (D_μ + Q_μa²/D_a) = 0, so Π_μη = 0, and then Π_aη = 0.
- *Witness.* Order the coordinates (η, s, a, μ) and take Π = [[2,1,0,0],[1,3,1,0],[0,1,3,1],[0,0,1,2]], with Q_μa = 1 and Q_ηs = 1 (the rest 0) and D = I.
  - The steady state: Lyapunov holds for B = (I − Q)Π.
  - Sparse coupling, the 2023 paper's eq. 13: B_μη = B_aη = B_sμ = B_ημ = 0.
  - The blanket: Π_μη = Π_aη = 0.
  - Circulation: it passes through the internal coordinate (Q_μa = 1).
  - The internal state reads the sensory state (B_μs = −1) only through Q_μa Π_as, while Π_μs = 0.

**Fix.**

- Prove the footnote-13 form as the linear law: four parts, scalar coordinates, or blocks with positive diagonal noise. Keep `drift_zero_iff` as its lemma.
- Note the limit of law 3 as a counterpart. Law 3 with the internal part taken as the autonomous part covers only Q_α· = 0, which forbids circulation between μ and a. It does not cover footnote 13.

### F7 (overclaim). Known results are not labelled as known; the novelty is overstated

**Evidence.**

- **Law 3** is the partial form of a classical fact: reversible dynamics with local single-site rates have Markov-field (Gibbs) stationary laws. Sources: Kelly 1979, *Reversibility and Stochastic Networks*, ch. 9 (spatial processes and Markov fields); Liggett 1985, *Interacting Particle Systems*, ch. IV. The reviewer could not read the scanned chapter, so the theorem numbers need checking. Under detailed balance the rate ratio is the weight ratio, so the "ratio condition" is the cross form on joined pairs: law 3 is near-definitional, and "headline" oversells it.
- **Law 9** is Da Costa, Friston, Heins and Pavliotis 2021, Lemma 2.1, condition 4: the precision form, under the blanket, with Π_μ and Π_η invertible.
  - Law 9's witness (Π_μb = 0, Π_ηb ≠ 0) is their Example 2.2. In one dimension the map exists exactly where Π_μb ≠ 0, or where Π_μb = Π_ηb = 0.
  - Witness 7b ("a blanket without sparse coupling") is their Remark 3.1: "a Markov blanket of the steady-state density does not preclude reciprocal influences".
- **The relay phenomenon** was found by Biehl, Pollock and Kanai 2021 (Aguilera et al.'s ref. 34, already cited in `Blanket.lean`, missing from the design's §1), and then by Aguilera et al. and by Heins and Da Costa.
- **Law 6's second part** is Heins and Da Costa's eq. 13 for scalar coordinates.
- **Law 5** is the standard Helmholtz/Lyapunov identity for Ornstein–Uhlenbeck processes.

**Fix.**

- Give laws 2, 3, 5, 6, 8 and 9 the standing "known result stated in the theory's terms; near-definitional".
- Say that the novelty lies in the pure-core statement, the joins to `Blanketed`, and F5's eq. 9 law if it is added.
- Add Biehl, Pollock and Kanai 2021 to §1, and keep the page's Standing ("not yet farther than the sciences taken together").

### F8 (gap). Law 6 as law 3's counterpart: sound in the main, but unproved, and with a limit

**Evidence.**

- *What is sound.* The analogy holds where it matters. The Gaussian steady current is J(x) = QΠx·p(x), so J_i ≡ 0 ⇔ (QΠ)_i· = 0 ⇔ Q_i· = 0 (Π invertible). That is zero net flow along coordinate i, the counterpart of detailed balance on internal moves. The drift over the noise is the counterpart of the log rate ratio.
- *What rests on correspondence.* The current is only an "optional law", so the claim currently rests on correspondence alone.
- *The limit.* Constant noise collapses the discrete distinction between rates and their ratio. `ReadsDirectly` (rates 1 + e, symmetric, held apart) has no linear counterpart, since that would need noise that reads η.

**Fix.**

- Prove the algebraic part, (QΠ)_i· = 0 ⇔ Q_i· = 0 for invertible Π, in the periphery. This needs no calculus.
- State the current as a correspondence.
- Say that the constant-noise linear model cannot show the `ReadsDirectly` case.

### F9 (minor). Attributions to Aguilera et al. and to Heins and Da Costa

**Evidence.**

- *Aguilera et al.* Block-diagonal Q is their Assumption 1, a requirement of the principle's average-flow step ("first move"). It is not a condition for the blanket. Their finding is that it holds only with symmetric couplings between blocks (eq. 33, Fig. 4C), which "precludes for example the existence of asymmetric agent-environment interactions". The design's sentence reads as if it were a blanket requirement.
- *Heins and Da Costa.*
  - Their eq. 13 is in block form, with the sum over i outside the block. They assume constant, diagonal Γ throughout, so the probe is the scalar-coordinate case, not "the case for diagonal noise".
  - "With no solenoidal flow" should be their "absent off-diagonal solenoidal flow" under the canonical form (their eq. 14).
  - Their nonlinear result also assumes the η–μ blanket and the canonical form, and holds "barring edge cases".
- *Checked.* The 2023 quote and its author list are correct. The Lemma 2.1 restatement as a linear σ is equivalent to the lemma's function on the image.

**Fix.** Reword the three attributions as above.

### F10 (overclaim). "Three rows of §5 become stated"; the steady state needs positive definiteness

**Evidence.**

- *What the Lean contains.* No density and no Langevin flow are in it. "The Lyapunov equation is stationarity" and "a zero precision entry is conditional independence" are correspondences.
- *Positive definiteness.* Law 5's hypotheses (S symmetric and invertible) admit B = −1, D = 1, S = −1, which satisfies every equation and is not a covariance. S (equivalently Π) must be positive definite, which holds with B stable.
- *Law 8.* Its "mode" needs Π_μμ positive definite: `mode_stationary` proves stationarity, not a maximum.

**Fix.**

- Write: "stated algebraically for the linear case, under two stated correspondences; Langevin flows and densities stay in §5".
- Add `PosDef` for Π to the model, and to law 8's statement or its reading.

### F11 (overclaim). The Reading in §4

**Evidence.**

- **(a) Law 9's kernel condition has nothing to do with circulation.** It fails non-generically (Da Costa et al.: a random Π_μb has full rank with probability 1). In the three-part relay pattern with sparse coupling, Π_μb = Π_μη = 0 forces Q_bμ = Q_ημ = 0, because B_kμ = −Q_kμ Π_μμ, and hence Q_μ· = 0. So the internal coordinate reads only itself, and the witness is a disconnected coordinate. The draft's `no_sync_witness` uses 1×1 matrices with no drift.
- **(b) "Living things hold such states" does not reach the internal moves.** Broken detailed balance in living matter is measured (for example Battle and others 2016, *Science*), but that does not place the circulation in the internal moves of a given partition, and F1 shows that circulation need not break the blanket.
- **(c) "States the condition exactly in the core" is wrong.** The core's condition is sufficient, not exact, and "explains more" contradicts the page's Standing.
- **(d) "Holds for every sparsely coupled scheme" holds only for the noiseless scheme** until F2(a) is done.

**Fix.** Rewrite the Reading along these lines:

- the coupling form holds for determined sparsely coupled schemes, and for stochastic ones once F2(a) is done;
- the statistical form holds under stated sufficient conditions, can fail with circulation, and need not fail;
- each of these is known.

Drop "explains more" and the "two things" framing, or move law 9 out of the Reading.

### F12 (gap). Names and the grammar

**Evidence.**

- **`Balanced`.** The core uses this word in the conservation sense: `World.Balanced`, `Flow.Balances`, `Stock.Balanced`, and the "exergy balance" in the glossary's "first law" row. The record title `balanced-moves-hold-the-blanket` inherits the clash.
- **"Held apart".** It sits beside `Blanket.lean`'s "tells apart" and "separates", which mean the opposite (distinguishing, not conditional independence).
- **"Canonical relay".** It invites confusion with the literature's "canonical loop" and "canonical form".
- **`Joined`.** It duplicates the grammar's reach `«及»` (01 §1, a transitive closure). The reflexive case comes through `«所闭当且仅当同一或及»`. AGENTS asks that results be stated on the grammar where possible.

**Fix.**

- Use exact scientific names, which the naming rule admits: `DetailedBalance`, and `IndependentGiven` or `CondIndep`.
- Rename the witness something like `LagRelay`.
- State joining through `«及»`.

### F13 (gap). Board rule 9: conditional independence beside the existing conditioning

**Evidence.**

- The draft's `HeldApart` defines its own sums with `Becoming.Flow.total`.
- `Blanket` already imports `ConditionalWeights`. That module has conditioning by restriction (`restrict`, `share`, `Share.Same`) and `restrict_independent`, which is the case of law 1's second bullet with no blanket: product weights, where a record of one part leaves the other's share unchanged.

**Fix.**

- State conditional independence as equal shares under restriction: the share of an internal event given the blanket and an external event equals its share given the blanket alone.
- Prove the counts form and the cross form from that.
- Derive `restrict_independent`, or connect it as the case of a one-element blanket, to generalize below rather than beside.

### F14 (minor). Witnesses and probes

**Evidence and fixes.**

- **The occupation witness depends on the bit.**
  - *Evidence.* The sensory part reads either the high or the low bit of a four-cycle external part, and the internal part copies the sensory part:
    - with the high bit (e ≥ 2), the period visits (0,0,2), (0,1,3), (1,0,1) and (1,1,0), and they are not held apart;
    - with the low bit (e mod 2), the internal part equals 1 − s on the period, and the visits are held apart.
  - *Fix.* The design says only "the external part's bit". Say "the upper bit"; the draft's `Cycle` already does.
- **The relay's steady weights.**
  - *Evidence.* Their uniqueness up to scale, for an irreducible chain, is not proved.
  - *Fix.* State it as a correspondence, or prove it.
- **Linter warnings.**
  - *Evidence.* The Mathlib probe has four unused-simp-argument warnings (lines 89 and 93).
  - *Fix.* Clear them before a checker that refuses warnings.
- **The relay's Q in Lean.**
  - *Evidence.* In the probe, Q₀₁ and Q₀₂ are checked only in Python, though law 7 says "Probe ✓".
  - *Fix.* None needed: the draft adds `Relay.helmholtz` and `Relay.circulates`.
- **The core draft's header.**
  - *Evidence.* It still says "Probe … Scratch only".

### F15 (minor). Hypotheses missing from the text

**Evidence and fix.**

- Law 5's converse needs Π invertible. The probe has it; the text omits it.
- Law 9 needs Π_μμ and Π_ηη invertible. The draft has it.
- Each direction of law 2 needs its own positivity: cross from ratio needs r, s' > 0; ratio from cross needs a', c > 0.

State all three in the design text.

## What to cut, what to add

**Cut:**

- the sixth entry (F5);
- "explains more" and "states the condition exactly" (F11);
- "headline" for law 3 (F7);
- law 9 and its witness, unless they join something beyond restating Lemma 2.1 (F7, F11).

**Add:**

- the circulating-yet-blanketed witnesses (F1);
- the footnote-13 law (F6);
- noise as each part's input for law 10, and the Euler–Maruyama witness (F2);
- the (QΠ)_i· = 0 ⇔ Q_i· = 0 lemma (F8);
- F5's eq. 9 law, if it survives the check against Aguilera et al.;
- `PosDef` in the model (F10);
- `crossFormOn_of_crossForm` (F4);
- known-result labels (F7).

## The drafts against the design

The drafts were read, not recompiled; the coordinator reports both checkers passed.

- **Core draft, law 1.** `HeldApart ⇔ CrossFormOn` over listings is correct (F4). It still needs `crossFormOn_of_crossForm` to join law 3, and the rule 9 change (F13).
- **Core draft, witnesses.** `Cycle` uses the upper bit (F14). `ReadsDirectly` matches the design.
- **Periphery draft, `split_euler`.** It is correct as mathematics. Each part's next state is the Euler step with the unread part glued as 0, and `euler_congr` with `SparseCoupling` shows that the value is the same. `split_euler_iterate` and `euler_agent_through_sensory` follow.
- **Periphery draft, the Euler scheme.** It has no noise, so the docstrings "whatever circulates" and "circulation or not" carry F2's error. Remove them, or add noise as each part's input.
- **Periphery draft, other points.**
  - `helmholtz_unique` closes law 5.
  - `Relay.helmholtz`, `Relay.circulates` and `Unsparse` move the Python witnesses into Lean.
  - `no_sync_witness` is the trivial 1×1 case (F11a).
  - `mode`'s docstring needs positive definiteness to say "mode" (F10).
  - `SparseCoupling` matches the 2023 paper's eq. 13 and the core's `Blanketed`.

## Appendix: the eq. 9 probe (F5)

Compiled with `lake env lean` in the pinned Mathlib checkout; `#print axioms relay_eq9` reports `[propext, Classical.choice, Quot.sound]`.

```lean
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Tactic
open Matrix

theorem relay_eq9 (Q G H : Matrix (Fin 3) (Fin 3) ℝ) (anti : Qᵀ = -Q)
    (diag : ∀ i k, i ≠ k → G i k = 0) (gpos : ∀ i, 0 < G i i) (symm : Hᵀ = H) (hpos : ∀ i, 0 < H i i)
    (g10 : G 1 1 * H 1 0 = 0) (q10 : Q 1 0 * H 0 0 = 0) (q20 : Q 2 0 * H 0 0 = 0) :
    ((Q - G) * H) 0 1 = 0 := by
  have hQ : ∀ i j, Q j i = - Q i j := fun i j => by
    have := congrFun (congrFun anti i) j; simpa [transpose_apply] using this
  have hH : ∀ i j, H j i = H i j := fun i j => by
    have := congrFun (congrFun symm i) j; simpa [transpose_apply] using this
  have Q10 : Q 1 0 = 0 := (mul_eq_zero.mp q10).resolve_right (hpos 0).ne'
  have Q20 : Q 2 0 = 0 := (mul_eq_zero.mp q20).resolve_right (hpos 0).ne'
  have H10 : H 1 0 = 0 := (mul_eq_zero.mp g10).resolve_left (gpos 1).ne'
  have Q00 : Q 0 0 = 0 := by have := hQ 0 0; linarith
  have Q01 : Q 0 1 = 0 := by rw [hQ 0 1] at Q10; linarith
  have Q02 : Q 0 2 = 0 := by rw [hQ 0 2] at Q20; linarith
  have H01 : H 0 1 = 0 := by rw [hH 0 1] at H10; exact H10
  rw [mul_apply, Fin.sum_univ_three]
  simp [sub_apply, Q00, Q01, Q02, H01, diag 0 1 (by decide), diag 0 2 (by decide)]
```
