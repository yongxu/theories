# UE26: the blanket at a steady state, conditional independence and what holds it (design, revised)

31 October 2026. AI-written design for board item UE26 (claimed `c3a2f0fc4`), revised twice: after the [independent review](REVIEW-UE26-DESIGN.md) (fifteen findings) and the [literature check](LITERATURE-CHECK.md), then after the [recheck](RECHECK-UE26.md) (twelve findings). Every finding is taken (§7). The version the review read is [history/DESIGN.md](history/DESIGN.md); the version the recheck read is this file as committed in `5c69ae01e`.

The kit:

- **Core leaf** [`kit/tree/Becoming/BlanketWeights.lean`](kit/tree/Becoming/BlanketWeights.lean): 46 theorems in 90 declarations, every axiom report empty in a scratch build.
- **Periphery module** `free-energy/LinearBlankets.lean` (namespace `Becoming.LinearBlankets`), with its checker `check_linear_blankets.py`: passed, 62 theorems and 92 declaration audits, the three standard axioms only.
- **Probes** [`probes/`](probes/): exact solves of the core witnesses' steady weights (`relay_weights.py`, `synchronous_copy.py`) and the linear witnesses (`linear_witnesses.py`).

## 1. The gap

The principle's page lists in §5, among what the principle states and the theory cannot yet: densities, the Helmholtz decomposition of a steady-state flow, nonequilibrium steady-state densities, and whether statistical and dynamical blankets coincide.

**The theory's blanket.** [03 §1](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure) states it as a coupling structure on a determined law (`Blanket.Blanketed`), so the agent's course is fixed by its start and the sensory course. This is the deterministic case of the time-unrolled blanket of Virgo, Rosas and Biehl (2022), and it needs no steady state. Its stochastic form, the internal and external paths independent given the blanket's path, needs conditions on the noise and the start (law 11).

**The principle's blanket is statistical.** At the steady-state density, internal and external states are conditionally independent given the present blanket state. The principle reads internal states as encoding beliefs about external ones from that independence (Da Costa, Friston, Heins and Pavliotis 2021).

**The 2023 paper's own conditions.** Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis and Parr 2023 (Physics Reports), §4:

- It defines sparse coupling term by term (its eq. 9): every term of the Jacobian entry vanishes. It then glosses this as a zero Jacobian entry.
- Its footnote 10 sets aside cancellation.
- Its footnote 13 conditions the blanket's guarantee on there being no solenoidal coupling between autonomous and non-autonomous states.

**The gap in the literature.**

- **Biehl, Pollock and Kanai (2021)** showed sparse coupling without conditional independence (Observation 1; their example, Appendix A, is not a relay, and the lag relay here is a witness of the same phenomenon). Their Observation 3 shows that, with no solenoidal coupling between blocks, a one-way absence forces a two-way absence.
- **Aguilera, Millidge, Tschantz and Buckley (2022).** The principle's average-flow step requires block-diagonal solenoidal flow (their Assumption 1). They find that it holds only with symmetric couplings between blocks (their eq. 33, Fig. 4C).
- **Heins and Da Costa (2022).** In the linear case, a zero drift entry gives a zero precision entry exactly where a solenoidal sum vanishes (their eq. 13, in block form; the kit states its scalar case with constant diagonal noise). The nonlinear version assumes the canonical form and holds "barring edge cases".

**What UE26 states:**

- the statistical form on the theory's conditioning;
- sufficient conditions for it in two models: an asynchronous chain in the core, and the linear Ornstein–Uhlenbeck case in the periphery;
- witnesses on either side of each condition;
- how a synchronous blanket relates to the statistical form, in the core and in the linear Euler–Maruyama scheme;
- what the term-by-term definition implies for one-way influence, in the linear case.

## 2. The models

**Core (natural numbers; empty axiom reports).**

- *The weighting.* A weighting `w : I → B → E → Nat` on internal, blanket and external states.
- *Conditional independence given the blanket* (`IndependentGiven`) is stated on `ConditionalWeights` (board rule 9). At each blanket state, an internal event's share under the weighting restricted to an external record is its share, as ratios, over the listed pairs (`openSteps`).
- *The chain.* A chain in which one part moves at a time (asynchronous), read through its rates with no clock. This is a model beside `Blanketed`, whose parts all move at once. It is the discrete counterpart of continuous time with independent noise at each part, where one part jumps at a time.
- *Detailed balance of the internal moves* (`DetailedBalance`) holds at each blanket and external state.
- *The moves present.* At each blanket state, a relation of moves present, at positive rate, at every external state, whose closure (the grammar's `«所闭»`) holds the internal states. Other moves may come and go with the external state.
- *Steady weights.* They satisfy global balance, inflow equal to outflow, at each state. Law 3 does not assume them.
- *The synchronous law.* A kernel moving all parts at once, each factor reading only what `Blanketed` lets it read, by the kernel's construction; its steady weights are carried to themselves by one step.

**Periphery (Mathlib's reals and matrices; three standard axioms).** The drift is `−B x`, with noise `D` (diagonal and positive where a law needs it), steady covariance `S` and precision `Π = S⁻¹`. The laws are algebraic. Four correspondences are stated in the module header and not proved, since the pinned Mathlib has no stochastic integral:

- the Lyapunov equation is stationarity, for `B` stable (every eigenvalue of positive real part);
- a zero precision entry is conditional independence, for a Gaussian;
- the steady current is `Q Π x` times the density;
- the synchronous recursion `x' = A x + ξ` has its steady covariance solving `S = A S Aᵀ + 2 h D`, uniquely where `A` has spectral radius below 1.

Reading `S` as a covariance needs `S` positive definite, which holds for `B` stable. The algebraic laws do not need it.

## 3. The laws (in the kit)

### Core leaf `Becoming.BlanketWeights`

1. **Conditional independence, three ways.**
   - `IndependentGiven` follows from `FactorsGiven` on any listings: the joint weight times the blanket state's weight is the internal weight times the external weight. It gives `FactorsGiven` back on listings that list each state once (`mass_single`).
   - `FactorsGiven` is the cross form on the listed states (`CrossFormOn`), with repeated states and blanket states of weight nothing included.
   - The cross form on the whole types gives it on any listings (`crossFormOn_of_crossForm`). The cross form on listings that cover the types gives it on the whole types (`crossForm_of_crossFormOn`). On listings that do not cover the types, the converse fails (`Uncovered`, the review's F4 counterexample).
   - `ConditionalWeights.restrict_independent` is the case of product weights at one blanket state (`restrict_independent_case`).
2. **One move.** Take detailed balance at two external states. If the move's rate at the first and the reverse move's rate at the second are positive, the move's rate ratio being the same at both gives the cross form at its ends (`cross_of_move`). If the first end's weight at the second external state and the second end's at the first are positive, the cross form gives the equal ratios (`ratio_of_cross`). Without positivity neither holds: with every rate zero the ratio condition holds and the cross form need not. The cross form passes through a state of positive weight (`cross_trans`).
3. **Detailed balance of the internal moves gives the statistical blanket** (sufficient).
   - *The hypotheses:* positive weights, internal moves in detailed balance, a relation of moves present at positive rate at every external state whose closure holds the internal states, and each such move's rate ratio reading no external state. No steady state is assumed; the law holds for any positive weighting in detailed balance with the internal moves, which is why it is local.
   - *The conclusion:* the cross form (`crossForm_of_detailedBalance`), so conditional independence on any listings (`independentGiven_of_detailedBalance`). Rates reading no external state satisfy the ratio condition. Conversely, cross form with detailed balance and positive weights gives the ratio condition (`ratio_of_crossForm`).
   - *Standing:* known and near-definitional. It is Kelly's proof (1979, Theorem 9.3, p. 189) at the internal site, with rate ratios. The moves joining the internal states are his condition (iii), which his Exercise 9.2.2 shows cannot be dropped. That they are present at every external state is what remains of his condition (ii) once only ratios are restricted, and `MovesReadExternal` shows it cannot be dropped either.
4. **Witnesses.**
   - `LagRelay`: steady weights 31, 15, 9, 17, 17, 9, 15, 31. They are not conditionally independent (15·72 ≠ 46·24), so the internal moves circulate.
   - `Turning`: the internal part turns through three states one way. The uniform weights are steady and conditionally independent, and the internal moves are not in detailed balance (review F1).
   - `ReadsDirectly`: symmetric rates reading the external bit, with uniform weights in cross form.
   - `MovesReadExternal`: a positive weighting, internal moves in detailed balance and joined at each external state by other moves, each move present at both external states with one ratio. It is not in cross form (the literature check's counterexample).
   - `SynchronousCopy`: the synchronous law in which the external bit stays at 3 and flips at 1, the sensory bit copies it and the internal bit copies the sensory bit. Its factors read what `Blanketed` allows by the kernel's construction; no theorem joins the kernel to `Blanketed`. With an exact sensory copy, the steady weights 9, 3, 1, 3, 3, 1, 3, 9 are conditionally independent. With a miss at 1 in 4, the weights 6, 3, 3, 4, 4, 3, 3, 6 are not (3·16 ≠ 9·6) (review F3).
   - `Cycle`: the occupation weighting of a determined blanketed run, in which the sensory part reads the upper bit of a four-state counter (review F14). It is not in cross form.
   - `Uncovered`: a weighting in cross form on listings of one state, not in cross form on the whole types (law 1).
   - The steady weights of `LagRelay` and `SynchronousCopy` are proved steady. Their uniqueness up to scale is a correspondence, checked by exact solves (`probes/relay_weights.py`; `probes/synchronous_copy.py`, rank 7 for both kernels).

### Periphery module `LinearBlankets`

5. **Helmholtz is Lyapunov**, and its parts are unique: the standard identity for Ornstein–Uhlenbeck processes. With `S` symmetric and invertible, `B S + S Bᵀ = 2 D` gives `B = (D − Q) S⁻¹` with `Q` antisymmetric (`helmholtz_of_lyapunov`). With `Q` antisymmetric, `D` symmetric and `Π` symmetric and invertible, the Helmholtz form gives the Lyapunov equation for `Π⁻¹` (`lyapunov_of_helmholtz`). With `S` symmetric and invertible, any symmetric `D′` and antisymmetric `Q′` with `B = (D′ − Q′) S⁻¹` are `½ (B S + S Bᵀ)` and `½ (S Bᵀ − B S)` (`helmholtz_unique`).
6. **No circulation through a coordinate.**
   - Row `i` of `Q Π` vanishes exactly where row `i` of `Q` does (`row_zero_iff`, review F8). This is no steady current along `i`, the counterpart of law 3.
   - With such a row, the drift at `i` reads `j` exactly where their precision entry is nonzero (`drift_zero_iff`).
   - In general, `zero_iff_solenoidal` holds: the scalar case of Heins and Da Costa's eq. 13, with constant diagonal noise.
   - A remark, not proved: constant noise has no counterpart of `ReadsDirectly`.
7. **Footnote 13 as a law** (review F6).
   - *The general law.* Take diagonal positive noise, and `Q` vanishing between a set of coordinates and the rest. If no coordinate of the set reads `j`, every precision entry between the set and `j` is zero (`precision_zero_of_autonomous`). The reason: `D − Q` is positive on the set.
   - *The four-part form* (`precision_zero_of_footnote13`). With the internal and active coordinates autonomous, sparse coupling gives the zero between internal and external coordinates, and circulation between internal and active coordinates is allowed.
   - *Witness* `Autonomous`: the zero is kept while the steady state circulates through the internal coordinate. The internal drift reads the sensory coordinate only through that circulation. The drift is sparsely coupled term by term (`Autonomous.termwise`).
   - *Standing.* Footnote 13 is the 2023 paper's own condition, and the review's F6 gave its scalar algebra; the normal form is Heins and Da Costa 2022, eq. 14, with the condition under it, eq. 15. The kit's own is the proof for any set of coordinates with diagonal positive noise, by the quadratic form of `D − Q`.
   - *Counterparts in the core.* Law 3, detailed balance of the internal moves, corresponds to `row_zero_iff` with `Q_μ· = 0`. `precision_zero_of_autonomous` with the internal coordinates as the set is weaker: it allows circulation among internal coordinates, and `Turning` is that case's discrete counterpart. Footnote 13's set of internal and active coordinates has no discrete law in the core.
8. **Term by term, in the linear case, a one-way influence runs through a third state** (review F5, in place of the sixth entry).
   - Under eq. 9 with constant solenoidal part, noise and Hessian (`TermwiseUnread`; eq. 8's terms in the derivative of `Q` and a state-dependent Hessian are absent):
     - **(a)** an absent influence has no Hessian and no solenoidal entry (`unread_zero`), so the zero precision entry is one of the definition's own terms;
     - **(b)** the influence the other way runs only through solenoidal flow to third states (`reverse_through_third`);
     - **(c)** a state no other state reads reads no other state (`reads_nothing_of_unread`). The review's eq. 9 probe is a case of (c).
   - *Standing.* (a) is the 2023 paper's eqs. 9–10 (and Friston and others 2021, eq. 23). (b) and (c) are near-definitional corollaries of eqs. 9–10. (b) has published special cases: Friston, Da Costa and Parr 2021, eqs. 1.6–1.7; Heins and Da Costa 2022, eqs. 17–18; Heins 2022, eqs. 7–9; Biehl, Pollock and Kanai 2021, Observation 3, with no third block. The general linear form of (b), and (c), were not found in the sources checked; Friston 2019 (arXiv 1906.10184), the fullest treatment of sparse coupling, was not checked.
   - *Consequence.* By (b) with no third state, every unmediated one-way coupling between two states is one of footnote 10's cancellation cases (the two-state check in the literature check).
9. **Witnesses, labelled by the definition of sparse coupling they meet.**
   - `LagRelay`: sparse both ways as zero drift entries, with `Π₀₂ = 4/109` and circulation through the internal coordinate. The internal drift's zero entry at the external coordinate is a cancellation, so the relay is not sparsely coupled term by term (`LagRelay.not_termwise`).
   - `Circulating`: circulates through the internal coordinate, with solenoidal coupling to both other coordinates, and keeps `Π₀₂ = 0`. It lies outside both sufficient conditions (review F1). Its zero drift entries are cancellations too (`Circulating.not_termwise`).
   - `Unsparse`: a zero entry with the internal drift reading the external coordinate (Da Costa and others 2021, Remark 3.1).
   - `Autonomous` (law 7) is sparsely coupled term by term.
10. **The internal mode** reads no external state exactly at the zero block. It is a mode where the internal block is positive definite (review F10). Standing: elementary Gaussian conditioning.
11. **The join to the core.**
    - The noiseless Euler step of a sparsely coupled drift is `Blanketed.step` (`split_euler`, `euler_agent_through_sensory`).
    - With additive noise as each coordinate's own input, the agent's course is fixed by its start, its own noise course and the sensory course (`em_agent_through_sensory`). This holds pathwise, for every linear drift with the sparse coupling, circulating or not.
    - The stochastic time-unrolled blanket, the internal and external paths independent given the blanket's path, follows under two further assumptions: the agent's noise independent of the rest's and of the start, and the agent's start held fixed (conditioned on) or independent of the world's. A correspondence (review F2a). A steady start does not give the second assumption: there the internal and external coordinates can be dependent (`LagRelay`, `Π₀₂ = 4/109`). Virgo, Rosas and Biehl (2022) say "under mild assumptions"; their text was not read here, so the assumptions are stated, not attributed.
12. **The synchronous scheme's statistical form** (review F2c; recheck findings 1–3).
    - *The law.* With no circulation (`Q = 0`, `B = D Π`, `D` and `Π` symmetric), the synchronous recursion's steady precision is `Π − (h/2) Π D Π` (`em_steady`). Standing: known, the order-`h` bias of the Euler–Maruyama steady law of an Ornstein–Uhlenbeck process.
    - *Without circulation, in the four parts.* With `D` diagonal and positive, the internal–external entries stay zero (`em_keeps_four_part`). There, sparse coupling leaves the internal coordinates reading no sensory coordinate, the "simple case" of Friston, Da Costa and Parr 2021. The active–external entries need not stay zero: the active–external entry is `−h/2` times the sum over sensory coordinates `s` of `Π_as d_s Π_sη` (`em_active_external`), `−h/2` for `Autonomous`'s precision with noise one (`Autonomous.em_loses_active_external`).
    - *With circulation, in the four parts.* The internal–external zero can be lost: `Autonomous` under Euler–Maruyama at `h = 1/10` has steady precision entry `−27800/984581` between the internal and external coordinates (`Autonomous.em_loses_internal_external`), though the drift meets footnote 13 and eq. 9 and the coupling form holds pathwise (`Autonomous.em_coupling_form`). It is one witness, a loss of the discrete step: the drift's continuous-time zero stands (`Autonomous.precision_zero`), and the landing review's probes found circulating drifts meeting footnote 13 that keep the zero, a loss shrinking with `h`, and a loss also with circulation only between the external and sensory coordinates, where the internal coordinate reads no sensory one (`review-landing/probes/em_circulation.py`, `em_scan.py`). An earlier draft placed the loss exactly where the internal coordinate reads the sensory one through circulation; that probe refutes it.
    - *Three parts.* A three-coordinate chain whose middle coordinate reads and is read by both ends loses the zero without circulation: the entry of `Π − (h/2) Π²` is `−h/2` at every `h` (`ThreePart.em_loses_zero`), the steady precision for `0 < h < 2/(2 + √2)`. It is the principle's coarse three-part partition: no assignment to the theory's four parts with its ends internal and external makes it sparsely coupled (`ThreePart.no_four_part`).
    - *Order `h`.* Where a loss is proved for every `h`, it is `h` times a fixed entry. A remark: the asynchronous chain of the core is the discrete counterpart of continuous time with independent noise at each coordinate, so the synchronous losses belong to the theory's discrete steps.

**Dropped.**

- Law 9 of the reviewed design (the map between modes) restated Da Costa and others 2021, Lemma 2.1, and its witness was a disconnected coordinate (review F7, F11a).
- The sixth entry (review F5).

## 4. What the page gains

**§5.** Three rows become "stated algebraically for the linear case, under stated correspondences; Langevin flows and densities stay here":

- the Helmholtz decomposition;
- the Gaussian steady state;
- whether the two blankets coincide.

The third row says what holds:

- The coupling form holds for every determined blanketed law and every sparsely coupled linear Euler–Maruyama scheme with additive noise (pathwise).
- The statistical form holds under the sufficient conditions of law 3 (positive weights, moves present at every external state, rate ratios reading none) and law 7 (diagonal positive noise, footnote 13's condition, no coordinate of the set reading `j`).
- Under the 2023 paper's term-by-term definition, in the linear case, the zero precision entry is one of the definition's own terms (law 8a). The losses are where sparse coupling is read as a zero drift entry (the relays, by cancellation) and in the synchronous scheme. The statistical form need not fail with circulation (`Turning`, `Circulating`, `Autonomous`).
- A synchronous blanket keeps it in some cases and loses it in others (`SynchronousCopy`; `em_keeps_four_part` without circulation; `Autonomous.em_loses_internal_external` with circulation, in a witness in the four parts).

**The blanket row of §2** (or the §5 row, at writing). It gains law 8, in the linear case: under the paper's own definition, a one-way influence runs through a third state, and a state no other state reads reads nothing. There is no sixth entry in §3.

**Reading** [AI reading, D45].

- *The coupling form suffices for the theory.* What the theory states of agents through the blanket needs only the coupling form, so it holds whether or not a statistical blanket exists. These are: a determined policy is a selection through the sensory course, a reading through the blanket lumps, and the unseen break goes unseen (03 §1, §6).
- *The principle needs more.* Its inference reading needs the statistical form, which holds under conditions each of which is known.
- *Where the novelty lies.* What UE26 adds is the pure-core statement on the theory's own conditioning, the joins to `Blanketed`, the witnesses on either side, and the synchronous cases, with the four-part loss under circulation. Law 8's (b) and (c) are near-definitional; their general linear form was not found in the sources checked.
- *Standing.* The page's Standing stays: not yet farther than the sciences taken together.

## 5. Boundary

UE26 does not state:

- nonlinear Langevin flows, non-Gaussian densities or the Fokker–Planck current; law 8 beyond the linear case;
- the exact time-`h` map of the linear flow;
- the steady weights' uniqueness. The weights of `LagRelay` and `SynchronousCopy` are proved steady; their uniqueness up to scale is a correspondence, checked by the probes' exact solves (review F14);
- the stochastic time-unrolled blanket as a theorem about path measures (law 11 states its assumptions);
- a discrete law for footnote 13's set of internal and active states;
- how often cancellation occurs in high-dimensional random systems (Heins and Da Costa 2022; Sakthivadivel 2022);
- entropy production of the relay (Schnakenberg 1976), a next step joining `EntropyProduction`;
- generalized coordinates, precision, the softmax and deeper models.

## 6. Names and placement

- **Core leaf `Becoming.BlanketWeights`**, importing `Becoming.Blanket` and `Becoming.Flow`.
  - *Names:* `IndependentGiven`, `FactorsGiven`, `CrossForm`, `CrossFormOn`, `DetailedBalance`.
  - *Witnesses:* `LagRelay`, `Turning`, `ReadsDirectly`, `MovesReadExternal`, `SynchronousCopy`, `Cycle`, `Uncovered`.
  - *Changes after the review (F12).* `Balanced` clashed with the conservation sense (`World.Balanced`, `Flow.Balances`). "Held apart" clashed with `Blanket`'s "tells apart". `Joined` duplicated `«所闭»`.
- **Periphery module `Becoming.LinearBlankets`** in `free-energy/`, with its checker. *Changes after the recheck (finding 12):* "apart" for a zero precision entry is retired here too: `precision_zero_of_autonomous`, `precision_zero_of_footnote13`, `Autonomous.precision_zero`, `Circulating.circulates_and_precision_zero`, `Unsparse.precision_zero_and_read`. *Changes after the landing review (finding 14):* "couples" for a nonzero precision entry is retired, since the glossary's coupling is dynamical: `LagRelay.coupled` → `LagRelay.precision_nonzero`, `Autonomous.em_couples` → `Autonomous.em_loses_internal_external`, `ThreePart.couples` → `ThreePart.em_loses_zero`. "Autonomous" is said once in the header: the module uses it for footnote 13's condition on a set of coordinates, that no solenoidal flow joins it to the rest (`noQ`), and states apart that no coordinate of the set reads `j` (`absent`); in the 2023 paper the autonomous states are the internal and active ones (recheck N1).
- **Records** at 03 §1, beside the blanket; ids to be checked against the naming study at claim time:
  - `the-blanket-at-a-steady-state` (core);
  - `the-blanket-in-a-linear-steady-state` (periphery).
- **Words.** "Statistical" and "dynamical" stay the literature's words, quoted. Live names are exact scientific ones (conditional independence, detailed balance, circulation), as the naming rule admits.

## 7. The findings, taken

**The review's.**

| Finding | Where taken |
|---|---|
| F1: no circulation is sufficient, not the condition | Laws 3, 6 and 7 stated as sufficient; `Turning`, `Circulating` and `Autonomous` witness circulation with the blanket kept; §4 says so |
| F2: the noiseless Euler step; noise; the synchronous loss | `emRun` and `em_agent_through_sensory` (noise as each coordinate's input). "Whatever circulates" removed from the noiseless law. The synchronous loss: law 12, as corrected by the recheck's finding 1 |
| F3: law 3 is an asynchronous model | Named so in the core header and §2. `SynchronousCopy` states the synchronous law's two cases |
| F4: law 1 on listed states | `CrossFormOn`, `crossFormOn_of_crossForm`, `crossForm_of_crossFormOn`, `Uncovered` |
| F5: the sixth entry | Dropped; law 8 in its place, checked against the literature |
| F6: footnote 13 | `precision_zero_of_autonomous`, `precision_zero_of_footnote13`, witness `Autonomous`; its standing and the counterpart note in law 7 |
| F7: known results labelled | Standings in both headers and §3: Kelly 1979, Theorem 9.3; Biehl, Pollock and Kanai 2021 added; Liggett cited by section IV.2 only |
| F8: (QΠ)ᵢ = 0 ⇔ Qᵢ = 0 | `row_zero_iff`; the current is a stated correspondence; constant noise without `ReadsDirectly` is a remark |
| F9: attributions | Aguilera and others: Assumption 1 belongs to the average-flow step. Heins and Da Costa: the scalar case of eq. 13 with constant diagonal noise, "barring edge cases" |
| F10: "stated"; positive definiteness | "Stated algebraically under stated correspondences"; positive definiteness named for the covariance and the mode |
| F11: the Reading | Rewritten (§4): no "explains more", no "exactly", law 9 out |
| F12: names | §6 |
| F13: conditional independence on `ConditionalWeights` | `IndependentGiven` by shares under restriction; `restrict_independent_case` |
| F14: witnesses and probes | `Cycle` uses the upper bit; uniqueness of steady weights is a correspondence with its probes; checker warnings cleared; the core header is no longer a probe's |
| F15: hypotheses in the text | Law 2's positivity for each direction, in the text and both docstrings; law 5's hypotheses; law 3's moves present at every external state |

**The recheck's.**

| Finding | Where taken |
|---|---|
| 1: the four-part synchronous scheme can lose the blanket with circulation; `ThreePart` is not sparsely coupled with its ends internal and external | `Autonomous.em_loses_internal_external` (the recheck's exact S and M; named `em_couples` until the landing review), `Autonomous.em_coupling_form`, `ThreePart.no_four_part`; law 12 restated; §4, §5 and both headers; the checker's scope |
| 2: unequal noise is a law | `em_steady` for `B = D Π`; `em_keeps_four_part` for diagonal positive `D`; the lost active–external entries as a law (`em_active_external`) and a witness (`Autonomous.em_loses_active_external`); the "numerics" sentence and the §5 item dropped |
| 3: "every `h`"; "stable" for `A`; order `h` | `0 < h < 2/(2 + √2)` in `ThreePart`; "spectral radius below 1" in §2 and the header; `em_steady` labelled known; the remark on the asynchronous chain in law 12, §2 and the core's modelling choices |
| 4: the linear witnesses cancel; the eq. 9 zero is definitional | Law 9 labels each witness, proved in Lean (`LagRelay.not_termwise`, `Circulating.not_termwise`, `Autonomous.termwise`); law 8(a) and the §4 row |
| 5: F15 not in the text | Law 2, law 5, the docstrings of `cross_of_move` and `ratio_of_cross` |
| 6: the stochastic correspondence's assumptions | Law 11, §1, the periphery header |
| 7: the coupling form's scope; `SynchronousCopy` not joined | §4 first bullet; the core header and law 4 say its factor structure is by construction |
| 8: law 8 "in the linear case" and its standing | Law 8, §4, the Reading, the periphery header; Friston 2019 named as not checked |
| 9: missing standings and the counterpart note | Law 7 (standing and counterparts), law 10, law 12 |
| 10: missing probes | `probes/synchronous_copy.py` (rank 7 for both kernels); the unequal-noise case is now law 12 |
| 11: law 3's wording | §2, law 3, the core header and the docstrings of `cross_of_closure` and `crossForm_of_detailedBalance`; steadiness not assumed |
| 12: names, citations, unproved remarks | Renames (§6); the core header cites the Physics Reports paper in full; `Uncovered` proves law 1's remark; law 6's remark marked; "its scalar case" for Heins and Da Costa's eq. 13 |

**The landing review's** ([REVIEW-UE26-LANDING](REVIEW-UE26-LANDING.md), which read the Lean and the texts and records as they were to land; the Lean was sound, every point in the texts).

| Finding | Where taken |
|---|---|
| 1: detailed balance stated without its conditions | Every summary keeps positivity, the moves present at every external state and the rate ratios reading none: the page (In brief, the claim table, §1, §2), both statements, laws 1 and 3, the histories, the amended record, regions, FEP-INTEGRATION, the README rows and the board |
| 2: one witness stated as a law | "Can lose", "in a witness" in 03 §1, its Reading, 08 §8, the page, the linear record, the study, the board, FEP-INTEGRATION, regions, the periphery header and `em_loses_internal_external`'s docstring; this design's §3 |
| 3: the active–external formula stated as a loss | 03 §1 and the study give the formula and the witness; the header and the docstring say "need not stay zero"; the sensory–internal clause dropped |
| 4: the board put the no-circulation precision on the circulating case | The board's landed text |
| 5: Langevin flows and densities read as stated | The page's In brief, claim table and §5, FEP-INTEGRATION and the study: "beyond the linear case's algebra" |
| 6: the three-part chain's hypothesis on its ends | The header, the checker's scope, law 13, the counterexample, the study and §3 |
| 7: footnote 13 without its noise and sparse coupling | The page's §1, §2 and In brief |
| 8: the converse on listings listing each state once | The root bullet, the README rows, the checker's scope, the page, FEP-INTEGRATION, regions, the core statement and the board |
| 9: positivity dropped | The README rows, the board and law 1's converse |
| 10: S symmetric and invertible; positive diagonals | 03 §1, law 3, the header, the checker's scope and the study |
| 11: the relay's rates; the synchronous kernel's construction | 03 §1, the root bullet, the README rows and the study |
| 12: Heins and Da Costa's normal form is their eq. 14 | The header, 03 §1, the linear record's correspondence and the study |
| 13: the relay's loss attributed to sources whose examples are not relays | 03 §1, 08 §8, both correspondences, the header and the study: sparse coupling without the statistical blanket is known, the relay a witness of it |
| 14: "couples" for a nonzero precision entry | Three renames (§6), the docstrings, laws 1, 2, 4, 11 and 12, 03 §1 and the study |
| 15: the loss is the discrete step's | "A loss of the discrete step, the drift's continuous-time zero standing" on the page, in 03 §1 and the study |
| 16: the study's added law differed from the page's | The study's decisions now name the page's fourth further law |
| 17: the lists of what is new | One list (the statement in the pure core, footnote 13's law for any set, the joins, the circulating witness) in 03 §1, 08 §8, the Standing and the study |
| 18: a mechanism refuted by a probe | §3's synchronous item rewritten |
| 19: minor | "率比相同"; "the precision of beliefs" on the page; `discrete-steps` in the linear record; "autonomous" said once in the header, in footnote 13's sense after the recheck (N1) |

**The recheck of the fixes** (the same reviewer, appended to [REVIEW-UE26-LANDING](REVIEW-UE26-LANDING.md); all nineteen resolved, six new points).

| Finding | Where taken |
|---|---|
| N1: "autonomous" in two senses | The periphery header and §6 use it for footnote 13's condition (`noQ`, `Autonomous.autonomous`) and state apart that no coordinate of the set reads `j` (`absent`); the periphery checker rerun |
| N2: "the theory's synchronous blanket" | "A synchronous blanket" in the counts record's witness law, the core header, §1, §4 and the study |
| N3: "unread" in the counts record's second law | "Rates reading none", "ratios reading none" |
| N4: the converse in two more places | The counts record's history and the landing commit message |
| N5: footnote 13's condition alone in the linear statement | "Footnote 13's law", which carries its hypotheses |
| N6: §4 dropped the sufficient conditions' hypotheses | §4 names them, by law 3 and law 7 |

## 8. Order

1. The recheck (done; its findings taken above).
2. Records, the study's notes and the page's rows, then a landing kit (done), and a review of the Lean and the landing texts (done; its findings taken above).
3. The core leaf needs one core slot from the coordinator, after RV21c. The periphery module needs only its own checker and lands in the same slot, so the records and the page change once.
