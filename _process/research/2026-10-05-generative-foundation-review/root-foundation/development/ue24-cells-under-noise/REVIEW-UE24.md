# REVIEW-UE24: independent review of CellsUnderNoise

An adversarial, read-only review by an AI agent, 30 October 2026. This review is AI-written.

**What was reviewed.** The draft module `ue24build/CellsUnderNoise.lean` (532 lines, header included); the core law it extends, namespace `Becoming.FreeEnergyGuarantees.IdenticalCells` (lines 200–514 of `FreeEnergyGuarantees.lean`, sha256 `6a4890e5…`, the hash in the record, and byte-identical to the copy in `ue24build/core`); `Law.Commutes` and its laws in `Commuting.lean`, and `Law.run` and `Law.orbit` in `Recurrence.lean`; the record `identical-cells-under-a-descent-treating-them-alike` (its `does_not_show`, `next_delta` and `correspondence`); the planned board row `ue24kit/claim_row.txt`; `FREE-ENERGY-PRINCIPLE.md` (§3 item 1, §5); and `GLOSSARY.md` for names. The claims were checked against the "Proof and naming" rules of AGENTS.md. The 2015 paper was read in its PMC full text, and SPM's `DEM_morphogenesis.m` was read in its 2019 revision (see "The 2015 scheme, checked").

**What was compiled.** `./build.sh -o CellsUnderNoise.olean CellsUnderNoise.lean` (Lean 4.30.0-rc2, pinned Mathlib). It took 90 s and printed nothing: **no errors and no warnings**. Four probe files compile cleanly, with no warnings, in `ue24build`:

- `Probe24a.lean` prints the axioms of all 54 declarations.
- `Probe24b.lean` holds counterexamples and routes: B1 to B3.
- `Probe24c.lean` holds the missing statements C1 to C7.
- `Probe24d.lean` holds C8 to C10.

The module has 54 declarations: 38 theorems and 16 definitions. Every axiom report is within `[propext, Classical.choice, Quot.sound]`. Some are smaller:

- `cellwise` and `Witness.Two` have no axioms.
- `rearrange` and `alike_fixed` have only `Quot.sound`.
- `ofFn_cellwise` and `ofFn_iterate_cellwise` have `propext` and `Quot.sound`.

So the header's "depend on Lean's standard axioms, through Mathlib" is accurate. The repository's checker was not run.

**Overall verdict.** The Lean is sound. No theorem is false, every proof checks, and the joins to the core are real:

- `ofFn_swap` is the core's `exchangeAt` as a transposition.
- `ofFn_rearranged` gets every permutation through Mathlib's `Perm.mclosure_swap_castSucc_succ`.
- `ofFn_cellwise` is the core's `descent`.
- `ofFn_iterate_cellwise` is the core's `Law.run`.

The content is known. An equivariant Markov kernel keeps an invariant law invariant. A unique invariant law of an equivariant kernel is invariant. An exchangeable law has equal marginals, and the bound 1/m! is the orbit count. This is Curie's principle in its distributional reading, and the header says so. The module is a restatement of known results in the core's terms, with a real join to the core's descent. **It forbids no statement of the free-energy literature that the core did not already forbid** (see "The 2015 scheme, checked"), and the claim row should not suggest otherwise.

Five things should be fixed before landing:

- **F1. "The deterministic law is the case without noise" overclaims.** `exact_keeps_fixed` is the core's `Law.Commutes.keeps_fixed`, recovered by a detour. It needs the rule to commute at every configuration, which for the descent means an exchangeable field. The core's never-parting law, `two_alike_stay_alike`, needs no such field.
- **F2. The two-cell witness is not noise of one law at every cell.** `part` is a draw shared by the two cells. It is provably not `noisy f q` for any `f` and `q`. Under the module's own noise, from alike cells, the alike configurations keep weight at every step, so "parting is certain" cannot happen there.
- **F3. `drawn` proves the exchangeability of the law at every step and then drops it.** It states only two consequences. The claim row asserts the exchangeability itself.
- **F5. The exchangeable field is needed, and nothing shows it.** A field that reads no cell's own number, but reads the first cell's state, fixes the places with weight one from an exchangeable start.
- **F13. The name `drawn` breaks the one-sense rule.** It uses a glossary and core word in a third sense: `Law.Drawn` means in an attractor's basin, and "draw" means what is taken. Its statement does not mean "drawn" either.

Counts: **0 errors, 5 overclaims, 5 gaps, 7 minor.**

---

## The 2015 scheme, checked

The brief asks what the simulation of Friston, Levin, Sengupta and Pezzulo (2015, *J. R. Soc. Interface* 12: 20141383) actually does, and so what this module's law forbids of it.

**The paper's text** ([PMC4387527](https://pmc.ncbi.nlm.nih.gov/articles/PMC4387527/)):

- **Cells and start.** There are eight cells. All start at one location with undifferentiated expectations, the only asymmetry being "small random expectations with a log precision of minus four".
- **One model, indexed by place.** Every cell has the same generative model, whose terms are indexed by target place, not by cell.
- **Little noise.** Receptor noise is set very low, at log precision 16.
- **Continuous states.** States are continuous, integrated by local linearization over 32 time steps.
- **Which cell took which place is not reported.** The confusion matrix's columns are reordered for display so that each row's maximum lies on the diagonal.
- **The uniqueness claim.** The paper argues that free energy is least when, and only when, each cell takes a unique target location, and calls this guaranteed.

**SPM's code.** This is [`toolbox/DEM/DEM_morphogenesis.m`](https://raw.githubusercontent.com/spm/spm12/main/toolbox/DEM/DEM_morphogenesis.m), revision 7679 of 2019, which may differ in detail from the 2015 code, with `morphogenesis.m`:

- **Initial expectations.** They are one matrix of independent standard normal draws divided by eight, one column per cell. So the start is **each cell drawn independently by one law**, which is `independent_exchangeable`'s kind of start, not `alike_exchangeable`'s.
- **Signals.** The signal a cell senses is a sum over all cells with distance decay, symmetric in the cells. In the core's terms that is an exchangeable field.
- **Process noise.** The generative process has noise precisions of `exp(16)`, which give tiny fluctuations, independent and of one law across cells.
- **Time-dependent scaling.** The process and model functions carry a global time-dependent scaling.
- **A fixed seed.** The seed is fixed (`rng('default')`), so the figures show one realization.

**So the scheme is exchangeable.** It has one model, a symmetric signal, independent and identically distributed starts, and fluctuations of one law. Nothing in it is indexed by cell number except which draw each cell receives.

**Does the module's law apply?** Not literally. The scheme has continuous states, densities, generalized filtering and a time-varying process, and the header rightly lists these as not derived. Its continuous analogue does apply, and that analogue is the standard distributional form of Curie's principle. Across seeds, each cell is equally likely to take each place. Where the cells end at distinct places, each of the 8! assignments has one probability, 1/40320.

**What it forbids.** Nothing the paper states. The paper claims the pattern: each place taken by one cell. It does not claim which cell takes which place, and by reordering the columns it treats that assignment as arbitrary.

**What it leaves standing.**

- **The core's forbidding is unchanged.** It still forbids "guaranteed" as a guarantee for a deterministic descent from a symmetric start. The principle's page, §3, should stay at four forbidden statements.
- **The simulation stands**, as does the claim that, under random starts and noise, realizations reach unique places. The module says nothing about whether a realization parts, only that the law is symmetric.
- **The finite model even differs from the continuous ground on parting.** With per-cell noise, alike configurations keep weight at every finite step (C1 below), whereas in continuous states independent fluctuations part alike cells almost surely. Neither fact bears on the paper.

**Is it farther than the principle?** The module states a law the literature does not state, but which follows by symmetry for any exchangeable scheme. It forbids no claim of the literature, so by the board's own test (farther means forbidding more of what is claimed) it is not farther. It extends the theory's scope to noise and joins a known principle to the core. The strongest honest reading, [AI reading, D45], is this: under the core's descent with noise of one law at every cell, no part of the rule, the field or the model fixes which place a given cell occupies; only the draws do. So "knowing one's place", read as the scheme determining a given cell's place, is forbidden. Read as inferring which place of the pattern one has reached, it stands. The literature makes the second claim, not the first.

**What should change on the principle's page.** After landing, §5's "noise … under which the law on identical cells does not apply" could add: "for finite Markov chains with noise of one law at every cell, the law stays exchangeable, so which cell takes which place is drawn with equal weight (UE24)". The table row and §3 item 1 do not change.

---

## Findings

### F1. overclaim: "the deterministic law is the case without noise" recovers the core's commuting law, not its identical-cells law, and by a detour

**Location.**
- Header lines 34–37 ("the deterministic law is that case: a rule commuting with `σ` keeps every configuration of its run unchanged by `σ` … (`exact_keeps_fixed`)").
- The docstring of `exact_keeps_fixed` ("**The deterministic law is the case without noise**").
- The docstring of `ofFn_iterate_cellwise` ("With no noise, …").
- The claim row ("the deterministic law is the case with no noise").

**What is wrong.**

1. The core's law on identical cells is `two_alike_stay_alike`. It needs **no** hypothesis on the field beyond its reading no cell's number. `exact_keeps_fixed` needs `commutes : ∀ c, f (c ∘ σ) = f c ∘ σ`, the rule commuting at **every** configuration. For the core's descent, that is `cellwise_commutes`, which needs `IdenticalCells.Exchangeable field`. So the noise-free case of this module recovers `keeps_exchange_fixed`, generalized to every `σ`. It does not recover the never-parting law. The read-cell-by-cell version of the core's law holds without the exchangeable field (C5 below), and the module does not state it.
2. `exact_keeps_fixed` is the core's `Law.Commutes.keeps_fixed` at the law `f` and the map `(· ∘ σ)`. It is proved by a detour through `lawAt_invariant`, `lawAt_exact` and `pointMass_invariant_iff`. Proving an existing result by another route is a recheck, not another result. B3 derives it directly:

```lean
theorem orbit_iterate {X : Type} (f : X → X) (x : X) :
    ∀ n, Becoming.Law.orbit f x n = f^[n] x
  | 0 => rfl
  | n + 1 => by rw [Function.iterate_succ_apply', ← orbit_iterate f x n]; rfl

example {ι S : Type} {σ : Perm ι} {f : (ι → S) → ι → S}
    (commutes : ∀ c, f (c ∘ σ) = f c ∘ σ) {c₀ : ι → S} (fixed : c₀ ∘ σ = c₀) (n : ℕ) :
    f^[n] c₀ ∘ σ = f^[n] c₀ := by
  have := Becoming.Law.Commutes.keeps_fixed (T := f) (σ := (· ∘ σ)) commutes fixed n
  simpa [Becoming.Law.run_state, orbit_iterate] using this
```

3. `ofFn_iterate_cellwise` mentions no noise. It is about `(cellwise update field)^[n]`. The join that the header and the claim row mean, "the law without noise is the core's run", spans two theorems (`lawAt_exact`, `ofFn_iterate_cellwise`) and no theorem combines them.

**Evidence.** `Probe24b.lean` (B3) and `Probe24c.lean` (C4, C5) compile:

```lean
-- C4: the law without noise weighs a configuration one exactly where, read as a list, it is
-- the core's run.
theorem lawAt_exact_run [Fintype S] [DecidableEq S] {m : ℕ} (update : S → γ → S)
    (field : S → List S → γ) (c₀ c : Fin m → S) (n : ℕ) :
    lawAt (noisy (cellwise update field) exact) (pointMass c₀) n c = 1 ↔
      List.ofFn c = (Becoming.Law.run (descent update field) (List.ofFn c₀)).state n := by
  rw [lawAt_exact, ← ofFn_iterate_cellwise, List.ofFn_inj]
  simp only [pointMass]; split <;> simp_all

-- C5: the core's never-parting law, read cell by cell, for any two cells, with no exchangeable
-- field.
theorem cellwise_alike {m : ℕ} (update : S → γ → S) (field : S → List S → γ) {c₀ : Fin m → S}
    {i j : Fin m} (alike : c₀ i = c₀ j) :
    ∀ n, (cellwise update field)^[n] c₀ i = (cellwise update field)^[n] c₀ j
  | 0 => alike
  | n + 1 => by
    simp only [Function.iterate_succ_apply', cellwise, cellwise_alike update field alike n]
```

**Why it matters.** The phrase tells a reader that the core's law is the noise-free limit of this one. It is not. The law at the level of distributions needs a stronger hypothesis (F5) than the core's law on configurations. Saying the opposite hides exactly what changes when noise enters.

**Fix.** Reword the header and the claim row: "with no noise the law of one configuration follows the rule's run, which, read as a list, is the core's run (`lawAt_exact_run`); a rule commuting with `σ` keeps a start `σ` fixes fixed, the core's `Law.Commutes.keeps_fixed` (`exact_keeps_fixed`, an instance); the core's never-parting law needs no exchangeable field (`cellwise_alike`)". Add C4 and C5, or drop `exact_keeps_fixed` and cite `Law.Commutes.keeps_fixed`. Count `exact_keeps_fixed` as an instance.

### F2. overclaim: the two-cell witness is a shared draw, not noise of one law at every cell, and under that noise parting is never certain

**Location.**
- Header lines 50–56 ("**Two cells** (`Witness`). A kernel taking every configuration to one of the two parted ones …").
- The docstring of `Witness.part` ("**Parting with noise**").
- Header lines 11–12 ("independent fluctuations part alike cells").
- The claim row ("Witnesses on two cells: a kernel parting them with certainty, which cell is which a fair draw").

**What is wrong.**

1. `part c c' = halves c'` puts weight 1/2 on each of (on, off) and (off, on) and nothing on the two alike configurations. Any kernel of the form `noisy f q` gives configuration `c'` weight `q a (c' 0) * q b (c' 1)`. Then the product of the two alike weights equals the product of the two parted weights, so 0 · 0 = 1/2 · 1/2, which is false. So `part` is **not** noise of one law at every cell, for any rule. It is one fair coin seen by both cells: a draw the cells share. FreeEnergyGuarantees' own header names the absence of a shared draw as what the papers' systems had.
2. Under the module's own noise (`noisy (cellwise update field) q`), from all cells alike, some configuration of all cells alike has positive weight **at every step**. The rule gives alike cells one target `t`. Independent noise returns them all to one state `b'` with weight `(q t b') ^ m`, which is positive for some `b'`. So under the noise the module studies, "parting is certain" is impossible at every finite step, and "independent fluctuations part alike cells" holds only with some weight, not with certainty, in this finite model. It holds almost surely only in continuous states, which the module does not treat.
3. `part_once`, `alike_none` and `each_half` are stated from both cells off only. The header says "from two alike cells". That holds, since the kernel ignores its start, but it is not stated.
4. The contrast "where the core's unique minimum has its cells alike" compares a configuration that minimizes a free energy with a law that is stationary under a kernel that is no descent of any free energy. The point is real: a unique stationary law is exchangeable, yet it puts all its weight on parted configurations. But the prose should say so, rather than set the two side by side.

**Evidence.** `Probe24b.lean` (B2) and `Probe24c.lean` (C1) compile:

```lean
theorem part_not_noisy : ¬ ∃ (f : (Fin 2 → Bool) → Fin 2 → Bool) (q : Bool → Bool → ℝ),
    Witness.part = noisy f q := by
  rintro ⟨f, q, h⟩
  have v : ∀ c', Witness.halves c' = q (f ![false,false] 0) (c' 0) * q (f ![false,false] 1) (c' 1) :=
    fun c' => by
      have := congrFun (congrFun h ![false, false]) c'
      simpa [Witness.part, noisy, Fin.prod_univ_two] using this
  have tt := v ![true, true]; have ff := v ![false, false]
  have tf := v ![true, false]; have ft := v ![false, true]
  simp [Witness.halves] at tt tf ft
  rcases tt with h | h
  · rw [h] at tf; norm_num at tf
  · rw [h] at ft; norm_num at ft

theorem alike_keeps_weight [Fintype S] [DecidableEq S] {m : ℕ} {update : S → γ → S}
    {field : S → List S → γ} {q : S → S → ℝ} (nonneg : ∀ s s', 0 ≤ q s s')
    (rows : ∀ s, ∑ s', q s s' = 1) (a : S) :
    ∀ n, ∃ b, 0 < lawAt (noisy (cellwise update field) q) (pointMass fun _ : Fin m => a) n
      (fun _ => b)
-- proof in Probe24c.lean: the alike target t of an alike configuration, some b' with
-- 0 < q t b', and the single term (q t b') ^ m of the step's sum.
```

**Why it matters.** The witness is read as an instance of the core's descent with noise, the very thing the module is about. It is the opposite case: certain parting with a fair assignment needs a draw shared across cells, which the module's noise never supplies. The two facts together make a sharper and truer statement than the witness alone. Independent noise of one law keeps the law symmetric and never parts identical cells with certainty at a finite step (in finite states). A shared draw can part them with certainty and still leave which cell is which fair.

**Fix.**
- Rename `part` to something like `sharedDraw`, and redescribe it as "one fair draw both cells read, not noise of one law at every cell (`part_not_noisy`)".
- Add `part_not_noisy`. Optionally add `alike_keeps_weight`, with its record stating the finite-state scope: in continuous states with a density, exact alikeness has probability zero after one step.
- Change header line 12 to "independent fluctuations can part alike cells".
- State the witness laws from either alike start.
- Say what the contrast with `unique_minimum_alike` shows: uniqueness of a law gives exchangeability, not alike cells.

### F3. gap: `drawn` drops the exchangeability it proves, and asks for hypotheses its first part does not need

**Location.**
- `drawn` and its docstring.
- Header lines 46–49.
- The claim row ("with noise of one law at every cell the law stays exchangeable").

**What is wrong.**
- The first line of `drawn`'s proof is `have ex : Exchangeable (lawAt (noisy (cellwise update field) q) p n)`. The conclusion then keeps only two consequences of it: equal one-cell marginals, and the bound on assignments of distinct states. Exchangeability is strictly stronger. For example, it gives every pair of cells one joint law, which the marginals do not.
- The claim row asserts the exchangeability, and no theorem states it for the descent with noise.
- The marginal half of `drawn` needs none of `nonneg`, `rows`, `start_nonneg` or `start_total`. They are needed only for the bound.
- `drawn` also does not say that the law at step `n` is a law (`lawAt_law`).

**Evidence.** `Probe24c.lean` (C6) compiles. It is three lines and needs only the exchangeable field and start:

```lean
theorem drawn_exchangeable [Fintype S] {m : ℕ} {update : S → γ → S} {field : S → List S → γ}
    (exchangeable : Becoming.FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    (q : S → S → ℝ) {p : (Fin m → S) → ℝ} (start : Exchangeable p) (n : ℕ) :
    Exchangeable (lawAt (noisy (cellwise update field) q) p n) :=
  lawAt_exchangeable (fun σ => noisy_commutes q (cellwise_commutes exchangeable σ)) start n
```

**Fix.** Make this the headline theorem: the core's descent with noise of one law at every cell keeps an exchangeable law exchangeable. Give the marginals (no further hypotheses) and the bound (noise and start a law) as corollaries, or as a conjunction that includes exchangeability and `lawAt_law`. Name it per F13.

### F4. gap: the start of the 2015 simulation, each cell drawn independently by one law, has no corollary

**Location.**
- The claim row ("so from identical cells (all in one state, or each drawn independently by one law) every cell has the law of every other at every step and each assignment of distinct states has weight at most one over the number of orderings").
- Header line 22.

**What is wrong.** `drawn_from_alike` covers the alike start. For the independent start, `independent_exchangeable` gives exchangeability, but `drawn` also needs the start to be a law. That is `∑ c, ∏ i, q₀ (c i) = 1`, which no declaration states. As the scheme check above shows, the independent start is the one the 2015 simulation uses (independent normal draws per cell, one law). So it is the relevant start for the module's reading, and it is the one left uncombined.

**Evidence.** `Probe24c.lean` (C3) compiles:

```lean
theorem independent_law [Fintype S] {ι : Type} [Fintype ι] [DecidableEq ι] {q₀ : S → ℝ}
    (nonneg : ∀ s, 0 ≤ q₀ s) (total : ∑ s, q₀ s = 1) :
    (∀ c : ι → S, 0 ≤ ∏ i, q₀ (c i)) ∧ ∑ c : ι → S, ∏ i, q₀ (c i) = 1 :=
  ⟨fun c => Finset.prod_nonneg fun i _ => nonneg _,
   by rw [← Fintype.prod_sum]; exact Finset.prod_eq_one fun _ _ => total⟩
```

**Fix.** Add `independent_law` and a `drawn_from_independent` beside `drawn_from_alike`.

### F5. gap: the exchangeable field is needed, nothing shows it, and the header's opening does not say the hypothesis changed

**Location.**
- Header lines 9–13: the core's law is described with "a field read off the configuration, never off a cell's number", followed by "This module states what holds instead".
- `drawn`'s hypothesis `exchangeable`.
- The planned record's counterexamples.

**What is wrong.** The core's never-parting law needs only a field reading no cell's own number. The law-level statement needs the field to be exchangeable, and the header's first paragraph lets a reader assume that "what holds instead" holds under the same hypothesis. The two hypotheses differ in a way that matters.

A field can read no cell's own number and still read cells by their numbers. Take the field that reads the list in order, `l.headD false`, the first cell's state. Every cell senses it alike, so the core's `two_alike_stay_alike` applies. With update `xor`, from the exchangeable start `Witness.halves`, and **with no noise**, one step gives cell 0 off and cell 1 on with weight one. That is above 1/2!, and the marginals differ (cell 0 off with weight 1, cell 1 with weight 0). So both conclusions of `drawn` fail without `exchangeable`. A field can fix the places from an exchangeable start without reading the updating cell's own number.

**Evidence.** `Probe24b.lean` (B1) compiles:

```lean
def headField (_ : Bool) (l : List Bool) : Bool := l.headD false
def xorUpdate (x z : Bool) : Bool := xor x z

theorem head_fixes :
    lawAt (noisy (cellwise xorUpdate headField) exact) Witness.halves 1 ![false, true] = 1 ∧
    marginal (lawAt (noisy (cellwise xorUpdate headField) exact) Witness.halves 1) 0 false = 1 ∧
    marginal (lawAt (noisy (cellwise xorUpdate headField) exact) Witness.halves 1) 1 false = 0

theorem head_not_exchangeable :
    ¬ Becoming.FreeEnergyGuarantees.IdenticalCells.Exchangeable headField
```

The probe also proves `halves_exchangeable` and `halves_law` (nonnegative, total one), so the start meets every other hypothesis of `drawn`.

**Why it matters.** This is the counterexample that marks the module's real step. Under random starts or noise, what keeps identical cells interchangeable is a field that reads the configuration as a population, not merely the absence of a cell's own number. It belongs in the record. It also shows that the core's wording "never a cell's number" is loose: a field may read the state of the cell numbered 0.

**Fix.**
- Add B1 as a witness (`Witness.head_fixes`).
- Say in the header's first paragraph that the law under noise needs the exchangeable field, which the never-parting law does not.
- Put the counterexample in the record.

### F6. overclaim: "the steady-state form" for the Gibbs weights; no stationarity is shown, and κ and exp play no part

**Location.**
- Header lines 28–30 and 45–46 ("a density of the steady-state form, weights `exp (-κ F)` normalized").
- The docstrings of `gibbs_exchangeable` and `gibbs_symmetric_exchangeable`.
- The claim row ("the steady-state form of a free energy symmetric in the cells").

**What is wrong.**
- No kernel in the module is shown to have `exp (-κ F) / Z` as a stationary law. "Steady-state" asserts what is not proved.
- In the principle, the steady-state density is `exp (−surprisal)`, not `exp (−κ F)` of the core's free energy of a configuration (each cell's energy at its sensed field, summed). The phrase ties the theorem to the principle's nonequilibrium steady state without a law behind the tie.
- "Density" is wrong for weights on finitely many configurations.
- The theorem holds for any κ, negative included, and for any function of `F`: the proof `simp only [symmetric σ c]` uses neither `exp` nor the normalizer beyond its being a constant.

**Fix.** Write "Gibbs weights `exp (−κ F)` normalized, for any real κ, of a free energy no rearrangement changes, are exchangeable; no kernel is shown here to keep them". Count `gibbs_exchangeable` as a fact about a definition and `gibbs_symmetric_exchangeable` as an instance. If a stationarity link is wanted, it needs a kernel (Metropolis or heat-bath at `F`) and a proof.

### F7. minor: the citations for the probabilistic form, with better ones available

**Location.** Header lines 64–67 ("Curie's principle in its probabilistic form (Curie 1894; Chalmers 1970; Ismael 1997)").

**What is wrong.** The three citations are real and correctly dated:
- Curie 1894, *Journal de Physique Théorique et Appliquée* 3: 393–415.
- Chalmers 1970, *British Journal for the Philosophy of Science* 21(2): 133–148.
- Ismael 1997, *Synthese* 110(2): 167–190.

Curie and Chalmers state the principle for causes and effects. Chalmers is the received deterministic formulation, in terms of the symmetries of earlier and later states. The reading that a symmetric cause gives a symmetric distribution of effects under indeterministic laws is Ismael's, in answer to van Fraassen's objection that indeterminism falsifies the principle. Citing all three for "the probabilistic form" credits Curie and Chalmers with a reading they did not give.

**Fix.** Write "Curie's principle (Curie 1894; Chalmers 1970), in its distributional form for indeterministic laws (Ismael 1997; Castellani and Ismael 2016)". Consider also:
- Castellani and Ismael 2016, "Which Curie's Principle?", *Philosophy of Science* 83(5): 1002–1013.
- Earman 2004, "Curie's Principle and spontaneous symmetry breaking", *International Studies in the Philosophy of Science* 18(2–3): 173–198, for the spontaneous-symmetry-breaking clause.
- Norton 2016, "Curie's Truism", *Philosophy of Science* 83(5): 1014–1026, which argues that the principle is a truism whose force lies in how cause and effect are mapped. That fits the header's "known" standing.
- For `exact_keeps_fixed`: an equivariant map leaves its fixed-point subspaces invariant (Golubitsky, Stewart and Schaeffer 1988, *Singularities and Groups in Bifurcation Theory* II; Golubitsky and Stewart 2002, *The Symmetry Perspective*).
- Turing 1952, which the core already cites, is the morphogenetic precedent for noise breaking a symmetric state.

### F8. overclaim: the claim row's "the theory's first statement on the principle's stochastic ground"

**Location.** The claim row, "Purpose: …".

**What is wrong.**
- The principle's stochastic ground is densities, Langevin flows and random dynamical systems: §5 of the principle's page, and the header's own "What is not derived". The module states finite Markov chains on finitely many configurations in discrete, time-homogeneous steps. That is a stochastic ground, not the principle's.
- The purpose clause, together with the board item's place under "farther than FEP", suggests a new forbidding. As the scheme check shows, the module forbids no statement of the 2015 paper or of the wider literature.
- The row's "a unique stationary law … [is] exchangeable" also drops two qualifiers: "under a kernel commuting with every rearrangement", and "unique among nonnegative laws of total one".

**Fix.** Write "Purpose: the theory's first law under noise, for finite Markov chains on configurations: it extends the identical-cells record past its scope on noise; it forbids no statement of the 2015 paper, whose simulation is exchangeable and claims no assignment of cells to places." Restore the qualifiers.

### F9. gap: the record's next step, "exchanges of any two cells", is not stated in the core's terms

**Location.** The claim row ("the identical-cells record's … next step, exchanges of any two cells"); `ofFn_rearranged`; `cellwise_commutes`.

**What is wrong.** The record's `does_not_show` and `next_delta` concern the core's statements (`exchanged_run`, `keeps_exchange_fixed`, `two_alike_stay_alike`) for cells other than neighbours, read on `Law.run (descent …)`. The module proves that every rearrangement commutes with `cellwise`, on `Fin m → S`. The core-terms statement, that the run of the core's descent from a rearranged start is the rearranged run, is a few lines away and not stated. So the claim row's "next step" is met only in the module's own representation.

**Evidence.** `Probe24d.lean` (C8) compiles:

```lean
theorem run_rearranged {m : ℕ} {update : S → γ → S} {field : S → List S → γ}
    (exchangeable : Becoming.FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    (σ : Perm (Fin m)) (c : Fin m → S) (n : ℕ) :
    (Becoming.Law.run (descent update field) (List.ofFn (c ∘ σ))).state n =
      List.ofFn ((cellwise update field)^[n] c ∘ σ) := by
  rw [← ofFn_iterate_cellwise]
  congr 1
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih, cellwise_commutes exchangeable,
      Function.iterate_succ_apply']
```

Together with C5 (`cellwise_alike`, any two cells, no exchangeable field), this meets that part of the next step.

**Fix.** Add C8 and C5. Otherwise, drop "and its next step, exchanges of any two cells" from the claim row.

### F10. minor: noise reading only the state the rule gives leaves out sensory noise; and the kernel is fixed in time

**Location.** `noisy`; `drawn`; `lawAt`. The header's modelling choices declare the first restriction ("read from the state the rule gives") and do not declare the second.

**What is wrong.** Both restrictions are stronger than the laws need, and both exclude features of the 2015 scheme.

1. `noisy f q` lets the noise read only the target state `f c i`. Noise in what a cell senses, the principle's sensory noise and the 2015 receptor noise, makes the transition of cell `i` read its own state and the sensed field jointly. Such a kernel is not of the form `noisy (cellwise update field) q` in general. It still commutes with every rearrangement by the same proof (C2), and `noisy (cellwise …)` is a special case of it, by `rfl`.
2. `lawAt` uses one kernel at every step. The 2015 process and model carry a time-dependent scaling. The preservation law holds unchanged for kernels varying in time, each commuting with `σ` (C9).

**Evidence.** `Probe24c.lean` (C2) and `Probe24d.lean` (C9) compile:

```lean
def cellKernel {m : ℕ} (r : S → γ → S → ℝ) (field : S → List S → γ) (c c' : Fin m → S) : ℝ :=
  ∏ i, r (c i) (field (c i) (List.ofFn c)) (c' i)

theorem cellKernel_commutes {m : ℕ} {field : S → List S → γ}
    (exchangeable : Becoming.FreeEnergyGuarantees.IdenticalCells.Exchangeable field)
    (r : S → γ → S → ℝ) (σ : Perm (Fin m)) : KernelCommutes σ (cellKernel r field)

theorem noisy_eq_cellKernel {m : ℕ} (update : S → γ → S) (field : S → List S → γ)
    (q : S → S → ℝ) :
    noisy (cellwise update field) q = cellKernel (m := m) (fun x z s' => q (update x z) s') field :=
  rfl

theorem lawAlong_invariant [Fintype S] {ι : Type} [Fintype ι] [DecidableEq ι] {σ : Perm ι}
    {K : ℕ → (ι → S) → (ι → S) → ℝ} {p : (ι → S) → ℝ}
    (commutes : ∀ n, KernelCommutes σ (K n)) (invariant : Invariant σ p) :
    ∀ n, Invariant σ (lawAlong K p n)
```

**Fix.** State `drawn` on `cellKernel`, the cell's own state and sensed field read by noise of one law, with `noisy` as the case `rfl` gives. Either generalize `lawAt` to a kernel per step, or add "one kernel at every step" to the modelling choices.

### F11. gap: `pointMass_invariant_iff`'s docstring claims what the Lean does not state

**Location.** The docstring of `pointMass_invariant_iff` ("a law of one configuration is exchangeable only with all its cells alike").

**What is wrong.** The theorem is about one `σ`: `Invariant σ (pointMass c₀) ↔ c₀ ∘ σ = c₀`. "Exchangeable only with all cells alike" needs a further step, through `swap i j`, and no declaration states it. Header line 26 states only what the theorem states, so the gap is in the docstring alone.

**Evidence.** `Probe24d.lean` (C10) compiles:

```lean
theorem pointMass_exchangeable_alike {ι : Type} [Fintype ι] [DecidableEq ι] [DecidableEq S]
    {c₀ : ι → S} (exchangeable : Exchangeable (pointMass c₀)) (i j : ι) : c₀ i = c₀ j := by
  have := congrFun ((pointMass_invariant_iff (swap i j) c₀).mp (exchangeable (swap i j))) i
  simpa [eq_comm] using this
```

**Fix.** Add C10, or cut the clause from the docstring.

### F12. minor: `unique_stationary_exchangeable` is applied nowhere

**Location.** `unique_stationary_exchangeable`; `Witness.part_stationary_iff`.

**What is wrong.** The theorem takes uniqueness as a hypothesis, and no kernel in the module is shown to meet it, apart from the witness. The witness meets it (`part_commutes`, `part_stationary_iff`), but the module does not apply the theorem there. For `noisy` kernels with noise positive everywhere, uniqueness holds by Perron–Frobenius, which is not stated. The header correctly lists existence and uniqueness of a stationary law as not derived.

**Evidence.** `Probe24c.lean` (C7) compiles: `example : Exchangeable Witness.halves := … unique_stationary_exchangeable Witness.part_commutes … (Witness.part_stationary_iff _ total).mpr rfl …`.

**Fix.** Add C7 as the witness's instance of the law, so that the law has one model in the module.

### F13. overclaim (naming): `drawn` uses a glossary and core word in a third sense, for a statement that does not mean it

**Location.** `drawn`, `drawn_from_alike`; the title "which cell takes which place is drawn"; the claim row's title.

**What is wrong.** The repository adopts a name only where the statement means exactly that. AGENTS.md asks live text to use each term "in the one sense the glossary gives". `drawn` breaks both rules.

1. **The core already uses the word.**
   - `Becoming.Attraction` defines `Law.Drawn next s`: `s` lies in the basin of an attractor (`Attraction.lean:120`).
   - `Law.Commutes.not_drawn_to_one` in `Commuting.lean`, a module the core's identical-cells law itself uses, reads "drawn" as attraction.
   - GLOSSARY.md row 34 gives "draw" as "what is taken".
   - In a module about identical cells under a descent, "drawn" will be read as drawn into an attractor.
2. **The statement does not mean "drawn".** `drawn` states equal marginals and a bound on assignments. It says nothing about a random draw of a realization. The law-level fact behind the reading "drawn" is exchangeability (F3).

**Fix.** Use a structural name for what is stated, for example `descent_noise_exchangeable` for C6. Use `marginal_eq` and `distinct_le` at the corollaries, and something like `descent_noise_from_alike` for the alike start. In prose, write "which cell takes which place is left to the fluctuations, each assignment of distinct places with equal weight", not "drawn".

### F14. minor (naming): `exact`, `part`, `halves`, `cue`, and the double use of `Exchangeable`

- **`exact`** names the identity kernel, the Kronecker delta. It reads as "exactness" and shares its spelling with the tactic: `exact_keeps_fixed` has the term `noisy_commutes exact commutes` and, three lines later, the tactic `exact (pointMass_invariant_iff σ _).mp h`. It compiles, since tactic keywords are not reserved in term position, but it misleads readers. Prefer `delta` or `noNoise`.
- **`part`** is a noun or a verb, and it is a shared draw, not noise (F2). Prefer `sharedDraw`.
- **`halves`** would be more exact as `partedUniform`.
- **`cue`** "reads a cell's number" only in the sense that its target is asymmetric. It is `noisy (fun _ => ![true, false]) exact`, a constant rule with no noise, and it reads nothing. Say "a rule sending every configuration to cell 0 on and cell 1 off, as a positional cue would".
- **`Exchangeable`** is exact in both its uses. Here it is exchangeability of a law over every permutation, the standard probability term. In the core it is invariance of a field under neighbouring exchanges of its list argument. Inside the module the double use is unambiguous, because the core's is always written with its full path. But `drawn`'s signature carries both, one for a field and one for a law, and one sentence in `Exchangeable`'s docstring should say how they relate: through `ofFn_rearranged`, the core's neighbouring invariance gives invariance under every rearrangement.
- **`KernelCommutes`** parallels `Law.Commutes` and is exact. **`gibbs_exchangeable`** is an exact scientific name, but its docstring has the problem in F6.

### F15. minor: classification; what counts as a result

By AGENTS.md, a wrapper, recheck, rename or repeated acceptance is not another result. The proposed classification of the 54 declarations:

- **Results (11 laws in 14 declarations, `drawn` included):**
  - `step_invariant` with `lawAt_invariant`, counted as one law.
  - `marginal_eq`, `distinct_le`, `stationary_rearranged`, `unique_stationary_exchangeable`, `noisy_commutes`.
  - `lawAt_exact`, with `step_exact` as its step.
  - The joins `ofFn_swap`, `ofFn_rearranged`, `cellwise_commutes`, `ofFn_iterate_cellwise`.
  - `drawn` is a composite of these, a corollary. It counts as the join's headline only once restated as exchangeability (F3).
- **Instances (6):**
  - `lawAt_exchangeable`, of `lawAt_invariant`.
  - `alike_exchangeable`, of `pointMass_invariant_iff`.
  - `symmetric_rearranged`, of `ofFn_rearranged`.
  - `gibbs_symmetric_exchangeable`, of `gibbs_exchangeable` with `symmetric_rearranged`.
  - `drawn_from_alike`, of `drawn`.
  - `exact_keeps_fixed`, of the core's `Law.Commutes.keeps_fixed`: a recheck by another route (F1).
- **Facts about a definition (4):** `gibbs_exchangeable` (any function of an invariant function is invariant), `independent_exchangeable`, `alike_fixed` (`rfl`), `pointMass_invariant_iff`.
- **Helpers (8):** `step_nonneg`, `step_total`, `lawAt_law`, `noisy_rows`, `noisy_nonneg`, `ofFn_cellwise`, `pointMass_law`, `Witness.parted_rearranged`.
- **Witnesses (6):** `Witness.part_commutes`, `part_once`, `alike_none`, `each_half`, `part_stationary_iff`, `cue_fixes`.
- **Definitions (16):** `rearrange`, `Invariant`, `Exchangeable`, `KernelCommutes`, `step`, `lawAt`, `pointMass`, `marginal`, `Stationary`, `noisy`, `exact`, `cellwise`, `Witness.Two`, `Witness.halves`, `Witness.part`, `Witness.cue`.

Of the 11 results, every one outside the four joins is a known result, so "new" applies to the joins and the reading only. The header says this, and the record should too.

### F16. minor: small Lean points

- `distinct_le` takes `[DecidableEq S]` and does not use it. No warning is raised, since it is an explicit binder, but Mathlib's linter would flag it.
- `ofFn_cellwise`, `ofFn_iterate_cellwise` and `cellwise` use no `Classical.choice`. `cellwise` has no axioms at all, and `List.ofFn` and `Fin` are in `Init`. So the join to the core's descent and run might be provable in the pure core with an empty report. By the pure-core rule, the record should say that these are in the periphery only because the module imports Mathlib. Otherwise, move `cellwise` and its two laws to the core.
- `drawn`'s docstring omits that the noise and start must be laws for the bound (F3), and the header (lines 46–49) omits it too.

### F17. minor: the record's `does_not_show` and the principle's page after landing

The new record should carry the following:

- **Does not show:**
  - Anything of continuous states, densities or Langevin flows.
  - Whether a realization parts. In this finite model alike configurations keep weight at every step (C1); in continuous states they part almost surely.
  - Which place a given cell reaches.
  - Any rate, existence or uniqueness of a stationary law.
- **Counterexamples:** `part_not_noisy` (B2) and the head-reading field (B1).
- **Correspondence:** the 2015 simulation is exchangeable (independent draws per cell, a symmetric signal, one model) and claims no assignment, so the law forbids nothing of it.
- The identical-cells record's `does_not_show` on noise should then point to the new record rather than be removed, since the never-parting law still does not apply under noise.

---

**Counts: 0 errors, 5 overclaims (F1, F2, F6, F8, F13), 5 gaps (F3, F4, F5, F9, F11), 7 minor (F7, F10, F12, F14, F15, F16, F17).**

Probe files, all compiling without errors or warnings, in the session's scratch folder `ue24build/` (not kept; round 2 states them as theorems):

- `Probe24a.lean`: axioms of all 54 declarations.
- `Probe24b.lean`: B1 `head_fixes` and `head_not_exchangeable`, with `halves_exchangeable`, `halves_law` and `sum_two`; B2 `part_not_noisy`; B3 the direct route to `exact_keeps_fixed`.
- `Probe24c.lean`: C1 `alike_keeps_weight`, C2 `cellKernel_commutes` and `noisy_eq_cellKernel`, C3 `independent_law`, C4 `lawAt_exact_run`, C5 `cellwise_alike`, C6 `drawn_exchangeable`, C7 the witness's unique stationary law.
- `Probe24d.lean`: C8 `run_rearranged`, C9 `lawAlong_invariant`, C10 `pointMass_exchangeable_alike`.

Sources consulted: [Friston, Levin, Sengupta and Pezzulo 2015, PMC4387527](https://pmc.ncbi.nlm.nih.gov/articles/PMC4387527/); [SPM12 `DEM_morphogenesis.m`](https://raw.githubusercontent.com/spm/spm12/main/toolbox/DEM/DEM_morphogenesis.m); [Ismael 1997 on PhilPapers](https://philpapers.org/rec/ISMCP); [Chalmers 1970 on PhilPapers](https://philpapers.org/rec/CHACP); [Castellani and Ismael 2016](https://experts.arizona.edu/en/publications/which-curies-principle/); [Norton 2016 on PhilPapers](https://philpapers.org/rec/NORCT); [Norton, Curie's Truism (PDF)](https://sites.pitt.edu/~jdnorton/papers/Curie_truism_final.pdf).
