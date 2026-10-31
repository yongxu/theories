# UE26 literature checks (31 October 2026)

AI-written by a literature-check agent for UE26's design revision. How the sources were read: Kelly's chapter 9 was read by local OCR of a scanned copy, and the free-energy papers from their arXiv texts; neither the scans nor the extracted texts are kept in the repository. Equation numbers are those of the arXiv versions named below; journal versions may number differently. Quoting: this file carries one verbatim quote (Kelly's Theorem 9.3); every other source gets its exact location and a restatement in the agent's own notation. The two-state check of Check 2 is [`review-probes/two_state_cancellation.py`](review-probes/two_state_cancellation.py).

---

## Check 1. The classical source: reversible local dynamics give a Markov field

### The source: Kelly 1979, Theorem 9.3 (confirmed from the book's text)

Kelly, F. P. (1979). *Reversibility and Stochastic Networks*. Wiley, Chichester (reissued by Cambridge University Press, 2011). Chapter 9, "Spatial Processes", pp. 184–211.

- **§9.1 Markov fields, Theorem 9.2 (p. 186, eq. 9.5).** This is the Hammersley–Clifford theorem for positive fields on a finite graph. A random field π (positive on every state) is a Markov field if and only if π(n) = B ∏_{C∈𝒞} φ_C(n_C), with 𝒞 the simplices (cliques). The Markov field is defined at (9.2): P(n_j | n_{G−j}) = P(n_j | n_{∂j}).
- **Exercise 9.1.5 (p. 189).** Global Markov property: if G is split into disjoint H1, H2, H3 with no edge from H1 to H3, then n_{H1} and n_{H3} are independent given n_{H2}.
- **§9.2 Reversible spatial processes, definition (p. 189).** n(t) is a *spatial process* if (i) only one component changes at a time; (ii) the rate q(n, T_j^m n) does not depend on n_{G−j−∂j}; (iii) T_j^m n can be reached from n by transitions that leave n_{G−j} unchanged. Kelly calls (iii) a strengthened irreducibility.
- **Theorem 9.3 (stated p. 189, proved p. 190):** "The equilibrium distribution of a reversible spatial process is a Markov field." The proof: detailed balance makes π(n)/π(T_j^m n) independent of n_{G−j−∂j} whenever q > 0. Condition (iii) carries this to states more than one transition apart. These ratios fix P(n_j | n_{G−j}), which therefore equals P(n_j | n_{∂j}).
- **Exercise 9.2.2 (p. 192, Fig. 9.1).** A three-site path 1–2–3 with a reversible process satisfying (i) and (ii) but not (iii), whose equilibrium is not a Markov field. So (iii) cannot be dropped.
- **Corollary 9.7 (p. 202).** The partial-balance strengthening: if the equilibrium distribution of a spatial process satisfies the partial balance equations (9.26) at every site, it is a Markov field.
- **The converse direction (p. 193, opening of §9.3).** Kelly notes that reversible spatial processes with any given Markov field as equilibrium are easy to build from detailed balance. This is a remark, not a numbered theorem. Theorem 9.4 (p. 193, eq. 9.17) covers a non-reversible (partial-balance) construction.

### How the UE26 fact maps onto it

Take three composite sites on the path graph i — b — e. The simplices are {i}, {b}, {e}, {i,b} and {b,e}. Theorem 9.2 then gives π = B φ_i φ_b φ_e φ_ib φ_be = g(i,b) h(b,e), and Exercise 9.1.5 gives i ⊥ e | b. The UE26 fact differs from Theorem 9.3 in ways that matter for the record:

1. **Only the internal moves need detailed balance.** Kelly assumes the whole process is reversible and π is its equilibrium. His proof, however, uses detailed balance site by site. On the path i–b–e, the local Markov property at i alone, P(i | b,e) = P(i | b), already *is* i ⊥ e | b. So the UE26 version (only internal moves in detailed balance with w, and w not required to be stationary for the whole chain) is Kelly's proof applied to one site. Cite it as "the argument of Kelly 1979, Theorem 9.3, at the internal site", not as Theorem 9.3 verbatim.
2. **Ratios instead of rates.** Condition (ii) restricts the rates, but the proof uses only the ratio q(n,T n)/q(T n,n) = π(T n)/π(n). The ratio form is covered by the same argument.
3. **Connectivity must hold at every value of everything else.** Kelly's (iii) requires connectivity at every value of n_{G−j}, here every (b,e). When the internal rates do not depend on e, "connected at each b" is enough, because the move graph is the same for every e. **In the ratio-only generalisation it is not enough if the set of available moves depends on e.** Counterexample (three internal states, one b, external states e1 and e2):
   - At e1 the moves are 1↔2 (rates 2 and 1) and 2↔3 (1 and 1). At e2 they are 1↔3 (1 and 1) and 2↔3 (1 and 1).
   - Every move's ratio is the same wherever the move exists, and the internal moves connect all three states at every (b,e).
   - Detailed balance still forces w(·|b,e1) ∝ (1,2,2) but w(·|b,e2) ∝ (1,1,1), so i is not independent of e given b.
   - The hypothesis needs, for each b, a connecting set of internal moves present at every e (for example, positivity of rates independent of e). This is exactly what Kelly's (ii) supplies.
4. Kelly takes finite attribute sets and a field positive everywhere. This matches a positive w on a finite space.

### Liggett 1985 (not confirmed from the book)

Liggett, T. M. (1985). *Interacting Particle Systems*. Springer (Grundlehren 276; Classics reprint 2005). Chapter IV, "Stochastic Ising Models", §2, "Reversibility of stochastic Ising models".

I could not open the book. Google Books returned a CAPTCHA (not bypassed), the archive.org search-inside endpoint returned 403, and Springer requires a login. Secondary citations only:

- **Theorem IV.2.14.** Cited as "theorem (4.2.14) in [Liggett 1985]" in arXiv:2312.14816, which attributes to it the equivalence of reversible measures and Gibbs measures for stochastic Ising models. I confirmed this from that paper's text.
- **Proposition IV.2.7.** Cited in Löcherbach, arXiv:0911.4572v1 (that preprint was later withdrawn for an error in its own Proposition 2): heat-bath flip rates, built from the measure's single-site conditionals, are reversible for that measure. I confirmed this from that paper's text.

Recommendation: cite Kelly's Theorem 9.3 (with Theorem 9.2 and Exercise 9.2.2) as the primary source. Cite Liggett only by section (IV.2), or check IV.2.7 and IV.2.14 in a copy before giving numbers.

### Not verified

Theorem numbers in these sources for the static Markov-field/Gibbs equivalence and the infinite-volume dynamics were not checked:
- Spitzer 1971, "Markov random fields and Gibbs ensembles", *Amer. Math. Monthly* 78:142–154.
- Preston 1974, *Gibbs States on Countable Sets* (Cambridge Tracts 68). Chapter 1 is "Gibbs states and Markov random fields" and chapter 2 is "Interacting particle systems", per catalogue listings.
- Kindermann & Snell 1980, *Markov Random Fields and Their Applications* (AMS Contemporary Mathematics 1). Chapter IV is "Dynamic models"; the AMS page returned 403.

---

## Check 2. Novelty of the linear law under the term-by-term definition

### The law, with indices fixed

Write J_uv = ∂f_u/∂x_v (the influence of v on u), J = (Q − Γ)H in the linear case, Q antisymmetric, Γ diagonal positive, H symmetric with H_uu > 0. Term-by-term absence at (u,v) means Q_ui H_iv = 0 for every i, and Γ_u H_uv = 0.

- **(a)** The i = v term gives Q_uv H_vv = 0, so Q_uv = 0 = −Q_vu. And Γ_u H_uv = 0 gives H_uv = H_vu = 0.
- **(b)** The reverse entry is then J_vu = Σ_i Q_vi H_iu − Γ_v H_vu = Σ_{i∉{u,v}} Q_vi H_iu. Any influence of u on v runs only through third states, by solenoidal flow.
- **(c)** Suppose no state reads u (term-by-term absence at every (v,u), v ≠ u). The i = u terms Q_vu H_uu = 0 give Q_vu = 0, and H_vu = 0 as well. So the off-diagonal entries of row u of Q and of H vanish, and J_uv = 0 for every v ≠ u: u reads no state.

*Index note on the wording given.* "If v does not influence u … Q_vu = 0 (from Q_vu H_uu = 0 …)" and "any influence of v on u that remains, J_uv" mix the two directions. If v does not influence u, J_uv itself is zero. What remains is the reverse entry J_vu. And the term that kills Q is Q_uv H_vv, the i = v term of J_uv, which is how the 2023 paper writes it (eq. 10). Q_vu H_uu is the i = u term of J_vu; it is the right term for (c). The conclusions stand because Q is antisymmetric and H symmetric, but the derivation and the "remaining" entry should be re-indexed.

### Where it is already stated

**(a) is stated explicitly, so it is not new.**
- **Friston, Da Costa, Sajid, Heins, Ueltzhöffer, Pavliotis, Parr 2023**, *Physics Reports* 1024 (arXiv:2201.06387v3), §4 "Particles, partitions and things".
  - Eq. (8) is the Jacobian expansion.
  - Eq. (9) defines sparse coupling as every term vanishing.
  - Footnote 10: this excludes edge cases where nonzero terms cancel.
  - Eq. (10): Q_uv H_vv = 0 ⇒ Q_uv = −Q_vu = 0, and Γ_u H_uv = 0 ⇒ H_uv = H_vu = 0 ⇔ (x_u ⊥ x_v) | b.
- **Earlier, Friston, Heins, Ueltzhöffer, Da Costa, Parr 2021**, "Stochastic chaos and Markov blankets", *Entropy* 23(9):1220, §4.2 (PMC HTML): eqs. (21)–(23) give the same derivation. The text after (22) names the two ways J_uv = 0 can hold, all terms zero or two or more terms cancelling. Eq. (23) is the "all terms zero" case.

**(b) is not stated as a general entrywise law in any source checked.** Instances and special cases:
- **Friston, Da Costa, Parr 2021**, "Some interesting observations on the free energy principle", *Entropy* 23(8):1076 (arXiv:2002.04501), "Observation one", eqs. (1.6)–(1.7) (read from the rendered page).
  - In their canonical form, Q has no autonomous/non-autonomous block, and H_ηa = H_ηµ = H_sµ = 0 is *imposed*, not derived.
  - Multiplying out (1.6) gives J_ηa = Q_ηs H_sa and J_µs = Q_µa H_as. The directed influences a→η and s→µ exist only through solenoidal coupling to the third block.
  - The paragraph after (1.7) says that suppressing Q_ηs and Q_aµ gives the "simple case", where active states are shielded from external states by sensory states. The general law is not stated.
- **Heins & Da Costa 2022**, "Sparse coupling and Markov blankets", *Physics of Life Reviews* 42 (arXiv:2205.10190v2).
  - They use the whole-entry definition (J_uv = 0, edge cases set aside). Eqs. (11)–(13) characterise H_ηµ = 0 by a vanishing sum Σ_{i≠η} Q_ηi H_iµ (or its mirror), which holds automatically under the term-by-term reading.
  - Eq. (15) gives the normal-form version.
  - Eq. (17): under the normal form and H_ηµ = 0, J_ηa = (Q_ηη − Γ_η)H_ηa + Q_ηs H_sa. They then show H_ηa = 0, so in their eq. (18) J_ηa = Q_ηs H_sa. This is shown in matrix form only, not stated as a law.
- **Heins 2022**, "Particular flows and attracting sets" (comment on Aguilera et al.; arXiv:2205.09595), eqs. (7)–(9). A three-state linear example with Q_ηµ = 0 and Π_ηµ = 0: any solenoidal coupling with the blanket gives at least unidirectional coupling between internal and external states. This is a concrete instance of (b): J_ηµ = Q_ηb H_bµ.
- **Biehl, Pollock, Kanai 2021**, "A technical critique of some parts of the free energy principle", *Entropy* 23(3):293 (arXiv:2001.06408v3), §2, Observation 3, eqs. (24)–(26). This is the closest prior general statement.
  - For OU processes, M = (Γ+R) Mᵀ (Γ−R)⁻¹. If Γ and R are block-diagonal, M_αβ = (Γ_αα+R_αα) Mᵀ_βα (Γ_ββ−R_ββ)⁻¹, so M_βα = 0 ⇒ M_αβ = 0.
  - Hence under their Conditions 1 and 3, sensory states cannot directly influence internal states, nor active states external ones, and the four sets interact in a chain.
  - This is the special case of (b) with no solenoidal coupling to any third block. It takes block-diagonal R as a premise instead of deriving the zeros from a term-by-term definition.
- **Aguilera, Millidge, Tschantz, Buckley 2022**, *Physics of Life Reviews* (arXiv:2105.11203v3), §3.1 "Assumption 1: solenoidal coupling".
  - Assumption 1 (eq. 16) is block-diagonal Q.
  - Under weak coupling J = −I + C and Γ = ς²I, eq. (31) gives Q = ½(CΓ − ΓCᵀ) + O(C²), that is Q ≈ (ς²/2)(C − Cᵀ) to first order. Eqs. (32)–(33) and Fig. 4C show that removing between-block Q forces symmetric between-block couplings, so detailed balance is broken only within blocks.
  - This is not the law, but it agrees with it (see below).
- **Sakthivadivel 2022**, "Weak Markov blankets in high-dimensional, sparsely-coupled random dynamical systems" (arXiv:2207.07620v2). Uses the whole-entry definition: Theorem 1, a rephrasing of Heins–Da Costa, and Definition 2, the blanket index Σ Q_ηt H_tµ. Nothing like (b) or (c). Sakthivadivel 2022, "Regarding flows under the FEP" (arXiv:2205.07793): nothing relevant.

**(c) was not found anywhere.**

### Consistency with those papers

The law is consistent with all of them: (a) is their own eq. (10)/(23), and (b) and (c) follow by multiplying out their expansion. Specifically:

- **FDP 2021 (1.6), Heins–Da Costa (18) and the 2023 normal form (12).** Their directed influences have exactly the form (b) predicts: J_µs = Σ_a Q_µa H_as and J_ηa = Σ_s Q_ηs H_sa.
- **Biehl Observation 3** is the special case where no third-block solenoidal path exists.
- **Aguilera.**
  - To first order, Q_uv ≈ (ς²/2)(C_uv − C_vu). A first-order one-way coupling therefore has Q_uv ≠ 0 and fails the term-by-term definition. Under (b), any one-way coupling is a product of two off-diagonal entries, so it is second order in C. This matches their first-order finding.
  - With Assumption 1, (b) becomes J_vu = Σ_{i∈B(v), i≠v} Q_vi H_iu. A one-way between-block influence can only be carried by solenoidal coupling *within the receiving block*. With singleton blocks, Q = 0 and J = −ΓH (equilibrium), so between-block couplings are symmetric up to Γ. This matches their Fig. 4C remark.

Tensions (sharpenings, not contradictions):

1. **2023, §4, just after eq. (10).** The claim that any influence graph with absent or directed edges admits a Markov blanket is wider than the term-by-term definition allows.
   - Under (b), a one-way edge v→u needs a third state i with Q_ui ≠ 0 and H_iv ≠ 0. A one-way coupling between just two states is impossible, and by (c) so is a state that reads others but is read by none.
   - Exact example: the 2-state OU process with J = [[−1,0],[c,−1]] and Γ = I. Then Σ12 = c/2, Q12 = −c/2 and H12 = −(c/2)/(1+c²/4). J_12 = 0 holds only through the cancellation Q12 H22 = Γ1 H12 ≠ 0. Checked with exact fractions for c = 1/2 and c = 1 (`review-probes/two_state_cancellation.py`).
   - So the "edge cases" of footnote 10 include *every* unmediated one-way coupling. For such influence graphs they are not a negligible set.
2. **2021 "Stochastic chaos", §4.2.** The conjecture that directed couplings between two states generally imply conditional independence holds under the term-by-term reading. The law adds that such couplings must be mediated (by third states, through solenoidal flow). In the 2-state example above, the directed coupling comes with dependence (H12 ≠ 0); it is the cancellation case.
3. **2023, §4: external states influence internal states "via sensory states (directly or through active states)".** Under (b) and the normal form, the "direct" s→µ entry equals Σ_a Q_µa H_as. It exists only through solenoidal coupling between internal and active states, and it vanishes in FDP 2021's "simple case" (Q_aµ = 0).

### Bottom line for the record

- Attribute (a) to Friston et al. 2023, eq. (10), and Friston et al. 2021 (Entropy 23:1220), eq. (23).
- Cite as prior instances and special cases of (b): FDP 2021 eqs. (1.6)–(1.7), Heins & Da Costa 2022 eqs. (17)–(18), Heins 2022 eqs. (7)–(9), and Biehl et al. 2021 Observation 3, eqs. (24)–(26).
- Claim novelty only for the general entrywise form of (b) and for corollary (c), and only as "not found in the sources checked".

Not checked: Friston 2019, "A free energy principle for a particular physics" (arXiv:1906.10184); Millidge, Seth, Buckley 2021 (arXiv:2108.13343); Bruineberg et al. 2022 (BBS); Da Costa et al. 2021, "Bayesian mechanics for stationary processes", beyond a keyword search (no hit).
