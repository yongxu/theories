# UE26: blankets at a steady state, the coupling form and the statistical form (design)

31 October 2026. AI-written design for board item UE26 (claimed `c3a2f0fc4`). Probes in [`probes/`](probes/): the core law and its witness, compiled with every axiom report empty, and the periphery's linear laws, compiled against the pinned Mathlib with the three standard axioms.

## 1. The gap

The principle's page lists in §5, among what the principle states and the theory cannot yet: densities, the Helmholtz decomposition of a steady-state flow, nonequilibrium steady-state densities, and whether statistical and dynamical blankets coincide.

The theory's blanket ([03 §1](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure)) is a coupling structure on a determined law. Four parts are told apart by which part's next state reads which, and the agent's course is fixed by its start and the sensory course (`Blanket.Blanketed.agent_through_sensory`). That is independence given the blanket's *history*, the time-unrolled blanket of Virgo, Rosas and Biehl (2022). It needs no steady state.

The principle's blanket is statistical. At the steady-state density, internal and external states are conditionally independent given the *present* blanket state. From that independence the principle reads internal states as encoding beliefs about external ones (Da Costa, Friston, Heins and Pavliotis 2021). The principle joins the two forms by a claim about sparse coupling:

> "sparse coupling implies a NESS density with conditional independencies. In turn, this means any dynamical influence graph with absent or directed edges admits a Markov blanket" (Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr 2023, §4).

The paper glosses sparse coupling as an absent influence: "the Jacobian coupling states u and v is zero". It then defines it term by term (its eq. 9), so that the solenoidal and the dissipative terms of the Jacobian vanish separately. Its footnote 10 sets aside, as edge cases, influences that vanish by cancellation.

The literature has already found the gap:

- **Aguilera, Millidge, Tschantz and Buckley (2022).** In weakly coupled linear systems, the perception–action interface (sparse coupling) and the blanket (a zero precision block) are independent conditions. The blanket fails generically at second order in the coupling, and the solenoidal flow must be block-diagonal, which excludes the asymmetric couplings of agent and environment.
- **Heins and Da Costa (2022, a comment by two of the 2023 paper's authors).** In the linear case, given that the drift's block between two states is zero, their precision block is zero exactly where a sum of solenoidal and precision terms vanishes (their eq. 13). With no solenoidal flow, sparse coupling gives the blanket. In the nonlinear case it does so where the solenoidal flow is local.

UE26 states where the two forms coincide and where they part, twice:

- in the theory's own discrete terms, in the pure core;
- in the principle's continuous linear terms, in the periphery.

In both the condition is one structure: whether the steady state circulates through the internal part's moves.

## 2. The model

**Core (any type; natural numbers).**

- *Weights.* A weighting `w : I → B → E → Nat` on internal, blanket and external states. The blanket is the sensory and active parts together.
- *Held apart.* The weighting holds internal and external apart given the blanket where, in counts, `w i b e · W b = W(i, b) · W(b, e)`, with the sums taken over listings of internal and external states. This is conditional independence in counts. Law 1 makes it equivalent to the cross form `w i b e · w i' b e' = w i b e' · w i' b e`.
- *Internal moves.* A rate `rate b e i i'` of moving the internal part alone from `i` to `i'` at blanket `b` and external `e`. The rate may read the external state; whether it does is what the laws turn on.
- *Detailed balance.* The internal moves are in detailed balance with the weighting where `w i b e · rate b e i i' = w i' b e · rate b e i' i`. Equivalently, no net flow runs through any internal move.
- *Joining.* A joining relation `Joined (adj b)` connects the internal states at each blanket state.
- *Steady.* For a whole chain, "steady" is global balance at every state: inflow equals outflow.

**Periphery (Mathlib's reals and matrices; three standard axioms).**

- *Coordinates.* Finitely many coordinates, each internal, blanket or external.
- *The flow.* A linear drift `−B x`, noise `D` (diagonal and positive: each coordinate's noise is its own), steady covariance `S` symmetric and invertible, precision `Π = S⁻¹`.
- *Steady.* The steady-state condition is the Lyapunov equation `B S + S Bᵀ = 2 D`.

**Modelling choices, stated where each law depends on them.** No stochastic integral is used; the pinned Mathlib has no Brownian motion or Itô calculus. Two facts are known and stated as correspondences, not proved:

- the Lyapunov equation is the stationarity condition of `dx = −B x dt + √(2D) dW`, with `B` stable;
- for a Gaussian, a zero precision block is conditional independence (Lauritzen 1996).

The core's chain is read through its rates, with no clock. Its steady weights are a solution of global balance, not a limit.

## 3. The laws (planned)

### Core leaf

1. **Held apart, two forms.**
   - Over listings, for natural weights, conditional independence in counts is equivalent to the cross form.
   - Factorized weights `g(i, b) · h(b, e)` are held apart.
2. **One move.**
   - Detailed balance at two external states makes the cross form at a move's two internal states equivalent to the *ratio condition*: the ratio of the move's rate to its reverse reads no external state (`cross_of_move`, `ratio_of_cross`).
   - The cross form passes along joined states with positive weights (`cross_trans`).
   - Probe ✓.
3. **Balanced internal moves hold the blanket** (the headline). Take a positive weighting and internal moves that are in detailed balance with it, join the internal states at each blanket state and have positive rates. Then the weighting holds internal and external apart exactly where the ratio condition holds on every move (`crossForm_of_balanced`, `ratio_of_crossForm`).
   - In particular, internal moves whose rates read no external state hold the blanket (`crossForm_of_balanced_unread`).
   - Probe ✓: 11 theorems in 22 declarations, every axiom report empty.
4. **Witnesses.**
   - **The circulating relay.**
     - *The chain.* Three bits, internal `μ`, blanket `s` and external `e`, each flipping alone. `e` flips at rate 1. `s` flips towards `e` at 3 and away at 1. `μ` flips towards `s` at 3 and away at 1, reading no external state.
     - *Its steady weights.* They are 31, 15, 9, 17, 17, 9, 15 and 31 (global balance at every state, `steady`).
     - *Not held apart.* The weights fail the blanket: 31·9 = 279 against 15·17 = 255 (`not_cross`).
     - *It circulates.* By law 3, its internal moves are not in detailed balance (`circulates`).
     - Probe ✓.
   - **The occupation weighting of a blanketed law.**
     - *The law.* A `Blanketed` law whose external part is a four-cycle, whose sensory part reads the external part's bit, and whose internal part copies the sensory part.
     - *Not held apart.* Over the run's period the visits are not held apart: given `s = 0`, `μ = 0` comes with `e = 2` and `μ = 1` with `e = 1`.
     - *Still time-unrolled.* The internal course is still fixed by the start and the sensory course.
     - So the time-unrolled blanket holds and the time-synchronous one fails, for the weighting the existence claim reads ([03 §6](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-what-the-existence-claim-forbids)).
   - **Held apart, reading the external directly.**
     - *The chain.* The internal part flips at rate `1 + e` and the other parts at 1. The rates are symmetric and the weights uniform.
     - *Held apart anyway.* Detailed balance and the cross form hold while the internal rate reads the external state. The statistical form does not give the coupling form.

### Periphery module

5. **The Helmholtz form is the Lyapunov equation.**
   - With `S` symmetric and invertible, `B S + S Bᵀ = 2 D` gives `B = (D − Q) Π` with `Q = ½(S Bᵀ − B S)` antisymmetric.
   - Conversely, the Helmholtz form with `Q` antisymmetric and `D`, `Π` symmetric gives the Lyapunov equation for `Π⁻¹`.
   - `Q` and `D` are unique.
   - *Detailed balance* in the linear case is `Q = 0`, that is, `B S` symmetric.
   - Probe ✓ for both directions; uniqueness to add.
6. **No circulation through the internal coordinates.**
   - Take the Helmholtz form, noise each coordinate's own and positive, and no solenoidal flow through an internal coordinate `i` (`Q i k = 0` for every `k`). Then the drift at `i` reads coordinate `j` exactly where the precision couples them. So an absent influence of the external part on the internal part is the zero precision block (`drift_zero_iff`). This is law 3's counterpart in the principle's terms: with `Q i k = 0` the steady current has no component along `i`, as detailed balance leaves no net flow through an internal move.
   - In general, where the drift at `i` does not read `j`, the precision block is zero exactly where `(Q Π) i j` vanishes (`zero_iff_solenoidal`), Heins and Da Costa's eq. 13 for diagonal noise.
   - Probe ✓.
7. **Witnesses.**
   - **The canonical relay.**
     - *The drift.* `B = [[1, −1, 0], [0, 1, −1], [0, 0, 1]]` on (internal, blanket, external) with `D = 1`. The internal part reads the blanket and the blanket reads the external part.
     - *Sparse both ways.* `B₀₂ = B₂₀ = 0`.
     - *Its steady state.* `S = [[15/8, 7/8, 1/4], [7/8, 3/2, 1/2], [1/4, 1/2, 1]]`, with `Π₀₂ = 4/109 ≠ 0`.
     - *It circulates.* `Q₀₁ = 5/8` and `Q₀₂ = 1/4`: circulation through the internal coordinate.
     - Probe ✓.
   - **A blanket without sparse coupling.** `Π = [[2, 1, 0], [1, 2, 1], [0, 1, 2]]` with `Q₀₁ = 1`. Then `B = (1 − Q) Π` has `B₀₂ = −1` while `Π₀₂ = 0`.
8. **The internal mode.** With `Π_μμ` invertible, the internal mode given blanket and external states, `−Π_μμ⁻¹ (Π_μb b + Π_μη η)`, reads no external state exactly at the zero block. Here the mode is the stationary point of the quadratic form, and the steady density's surprisal is that form.
9. **The map from internal to external modes.**
   - Under the blanket, a linear `σ` with `η*(b) = σ(μ*(b))` for every `b` exists exactly where `ker Π_μb ≤ ker Π_ηb` (Da Costa and others 2021, Lemma 2.1, restated). The general factoring lemma `exists_factor_iff` is probed ✓.
   - Witness: a blanket with `Π_μb = 0` and `Π_ηb ≠ 0`. It has a statistical blanket, and its internal modes encode nothing.
10. **The join to the core.**
    - The Euler step of a drift with the principle's sparse coupling is `Blanketed.step` on the four coordinate blocks. Under that coupling the internal and active parts read the internal, sensory and active parts, and the sensory and external parts read the sensory, active and external parts.
    - So `agent_through_sensory` holds for every such scheme, circulating or not. Under the principle's own sparse coupling the time-unrolled blanket always holds, and the statistical one only without circulation.

## 4. What the page gains

**§5.** Three rows of §5 become stated, all for the linear case: the Helmholtz decomposition, the steady-state density (Gaussian), and whether the two blankets coincide. They coincide where nothing circulates through the internal coordinates and the noise is each coordinate's own, and part otherwise.

**A sixth entry, if the reading holds at writing.** The 2023 sentence above, read with sparse coupling as an absent influence (the paper's own gloss), is forbidden discretely by the circulating relay and linearly by the canonical relay. Under the paper's term-by-term definition it holds, and law 6 states exactly that case.

The entry is weak, like entries 3 and 4: the paper's footnote sets cancellation aside, and its authors' comment and Aguilera and others state the general failure. The decision is made at writing, after the review.

**Reading** [AI reading, D45].

- The principle's reading of internal states as beliefs about external ones needs two things: the statistical form, and law 9's kernel condition.
- Both can fail in a circulating steady state. Living things hold such states, far from equilibrium and producing entropy, and Aguilera and others note that the needed symmetry excludes their asymmetric couplings.
- The theory's coupling form needs no steady state and holds for every sparsely coupled scheme (law 10). So what the theory states of agents through the blanket holds whether or not a statistical blanket exists: a determined policy is a selection through the sensory course, a reading through the blanket lumps, and the unseen break goes unseen.
- That is where the theory explains more. It places the principle's inference reading as the non-circulating case of a coupling law, and states the condition exactly in the core.

## 5. Boundary

UE26 does not state:

- nonlinear Langevin flows and non-Gaussian densities, or the Fokker–Planck current;
  - *Optional law:* the Gaussian's current `J = Q Π x · p(x)`, divergence-free, by coordinate derivatives. Attempted only if the calculus stays small; otherwise it is named as reading;
- the exact time-`h` map of the linear flow, which fills in couplings the drift leaves out;
- continuous-time uniqueness for the time-unrolled blanket (Mathlib's Picard–Lindelöf could give it later);
- how often cancellation occurs in high-dimensional random systems (Heins and Da Costa 2022; Sakthivadivel 2022);
- Aguilera and others' finding that the rate of change of the conditional mode is not the average flow (their §3.2);
- entropy production of the relay (Schnakenberg 1976), which would join law 4 to `EntropyProduction`. That is a next step;
- generalized coordinates, precision, the softmax and deeper models: other items.

## 6. Names and placement

- **Core leaf `Becoming.BlanketWeights`**, importing `Becoming.Blanket`.
  - *Why a leaf.* No core module needs the weighting laws. Its witnesses are instances of `Blanketed` and of chains with rates.
  - *Names.* `HeldApart` (the counts form), `CrossForm`, `Balanced`, `Joined`, and the witnesses `Relay`, `Cycle` and `ReadsDirectly`.
- **Periphery module `LinearBlankets`** in `free-energy/`, importing `Becoming.Blanket` and Mathlib's matrices. It has its checker `check_linear_blankets.py`, in the pattern of `check_cells_under_noise.py`.
- **Records**, both homed at 03 §1 beside the blanket:
  - `balanced-moves-hold-the-blanket` (core);
  - `the-blanket-in-a-linear-steady-state` (periphery).
  - Their titles are checked against the naming study at claim time.
- **Words.** "Statistical" and "dynamical" stay the literature's words, quoted. Live names use "held apart", "weights", "moves", "balance" and "circulation".

## 7. Order

1. An independent review of this design, then Lean.
2. Then an independent review of the Lean and the texts, and a re-check.
3. The core leaf needs one core slot, given by the coordinator. The periphery module needs only its own checker, and it lands in the same slot, so the records and the page change once.
