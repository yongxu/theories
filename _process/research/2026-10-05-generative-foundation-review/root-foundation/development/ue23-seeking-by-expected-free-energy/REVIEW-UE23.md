# REVIEW-UE23: independent review of the seeking section of ExpectedFreeEnergyReals

An adversarial, read-only review by an AI agent, 30 October 2026. This review is AI-written.

**What was reviewed.** The section "Seeking by expected free energy, joined to the core's seeking" of `ExpectedFreeEnergyReals.lean` and its module header, read in the worktree `wt-ue23`; the study note `NOTE.md` (§1–§5); the records `what-seeking-cannot-separate` and `expected-free-energy-and-its-terms`; the APIs it uses: `Becoming.LumpedSeeking`, `Becoming.ConditionalWeights` (`posterior_single`, `mass_single`, `prior_share`) and `FreeEnergyReals` (`posterior`, `freeEnergy`, `freeEnergy_eq_surprisal_iff`, `minimizes_iff_posterior`, `givenShare_toReal`, `cast_mass_eq_sum`, `Share.toReal`). The claims were checked against the "Proof and naming" rules of AGENTS.md.

**What was compiled.** The module was compiled to an olean in `ue23build` (Lean 4.30.0-rc2, pinned Mathlib). It compiled with no errors or warnings. Three probe files, `Probe23a.lean`, `Probe23b.lean` and `Probe23c.lean`, compiled cleanly. Every Lean fragment quoted below comes from them. `#print axioms` on nine new declarations gives `[propext, Classical.choice, Quot.sound]`, as NOTE §3 says. The repository's checker was not run.

**Overall verdict.** The Lean is sound. No theorem is false. The arithmetic of the join is right: the choice weights cancel exactly where the docstring says, and conditioning commutes with the lumping with no hypothesis. There are two things to fix before landing:

- **A prose claim with a counterexample (F1).** The prose calls `belief` "the one belief of least free energy". By Mathlib's `log 0 = 0` that is false without a support condition, and the lemma cited for it does not state minimality.
- **A gap (F2).** "Over the reals, whatever chooses, the softmax included" has no Lean statement that joins real-valued choice weights to the belief. One line closes it.

Several statements carry hypotheses that are not needed, or whose conclusion does not mention the policy at all (F3, F4). Some declarations are instances counted as results (F6, F13). The other findings are wording, naming or correspondence points. Counts: 0 errors, 4 overclaims, 2 gaps, 8 minor.

---

## Findings

### F1. overclaim: "the one belief of least free energy" is false as stated, and the lemma cited does not say it

**Location.**
- The docstring of `belief` ("the one belief of least free energy against those joint weights (`freeEnergy_eq_surprisal_iff`)").
- The module header, lines 39–40 ("where the weights are nonnegative and total something the one belief of least free energy against them").
- NOTE §2, Definitions ("Where the weights are nonnegative and total something, it is the one belief of least free energy against them (UE17's `freeEnergy_eq_surprisal_iff`)").

**What is wrong.**

1. `freeEnergy_eq_surprisal_iff` says that the free energy equals the surprisal exactly at the posterior. It does not say that the free energy is least there. Minimality is `minimizes_iff_posterior`, or `freeEnergy_posterior` combined with `surprisal_le_freeEnergy`.
2. Both of those lemmas range only over beliefs that are **zero wherever the joint weights are zero**. Without that restriction the claim fails, by Mathlib's `log 0 = 0`. A belief that puts weight on a state of joint weight 0 contributes `q log q < 0` there, and can have less free energy than the posterior. UE17's own `Witness.bound_fails_off_support` is this phenomenon.

The condition "nonnegative and total something" does not exclude this case. A joint weight `Q s * courseLik L s c` is zero wherever the prior is zero or some outcome of the course is impossible under `s`. Both are common: a deterministic cue in the T-maze is one.

**Evidence** (`Probe23a.lean`, compiles). One experiment and one outcome. State 0 has likelihood 1 and state 1 has likelihood 0, with a flat prior. The belief is (1, 0) with free energy 0. The flat belief (1/2, 1/2) is nonnegative with total one, and its free energy is `log (1/2) < 0`:

```lean
noncomputable def L0 : Unit → Fin 2 → Unit → ℝ := fun _ s _ => if s = 0 then 1 else 0
example : freeEnergy Finset.univ (fun _ => (1 / 2 : ℝ))
      (fun s => (fun _ => (1 : ℝ)) s * courseLik L0 s [((), ())]) <
    freeEnergy Finset.univ (belief Finset.univ (fun _ => (1 : ℝ)) L0 [((), ())])
      (fun s => (fun _ => (1 : ℝ)) s * courseLik L0 s [((), ())]) := by
  simp [freeEnergy, belief, posterior, courseLik, L0, Fin.sum_univ_two]
  have : Real.log 2 > 0 := Real.log_pos (by norm_num)
  linarith
```

**Proposed fix.** In all three places, write: "among beliefs over `S` that are nonnegative, total one and are zero wherever the joint weights are, the one of least free energy against them, where these are nonnegative and total something (`minimizes_iff_posterior`); unique on `S`." Better, state it in the Lean. The corollary below compiles (`Probe23b.lean`). It also gives the otherwise unused `courseLik_nonneg` its use (F13):

```lean
theorem belief_minimizes (S : Finset σ) (Q : σ → ℝ) (L : ε → σ → ω → ℝ) (c : List (ε × ω))
    (hQ : ∀ s ∈ S, 0 ≤ Q s) (hL : ∀ e s o, 0 ≤ L e s o)
    (total : 0 < ∑ s ∈ S, Q s * courseLik L s c) (q : σ → ℝ) (hq : ∀ s ∈ S, 0 ≤ q s)
    (hq1 : ∑ s ∈ S, q s = 1) (support : ∀ s ∈ S, Q s * courseLik L s c = 0 → q s = 0) :
    freeEnergy S (belief S Q L c) (fun s => Q s * courseLik L s c) ≤
      freeEnergy S q (fun s => Q s * courseLik L s c) := by
  have nonneg : ∀ s ∈ S, 0 ≤ Q s * courseLik L s c :=
    fun s hs => mul_nonneg (hQ s hs) (courseLik_nonneg hL s c)
  rw [show belief S Q L c = posterior S (fun s => Q s * courseLik L s c) from rfl,
    freeEnergy_posterior S _ nonneg total]
  exact surprisal_le_freeEnergy S q _ hq hq1 nonneg support
```

An iff form is equally short through `minimizes_iff_posterior`.

### F2. gap: "over the reals the belief keeps it whatever chooses, the softmax included" is joined to no real-valued choice

**Location.**
- The module header, lines 47–49.
- NOTE §2 (3): "Both hold for any policy, real-valued ones such as the softmax included, since the belief does not involve the choice weights".
- The docstrings of `belief_ratio_kept` and `belief_order_kept`: "whatever chose the experiments, a softmax over expected free energy among the policies".
- The checker's scope string.

**What is wrong.** `belief_ratio_kept` and `belief_order_kept` contain no choice at all. `belief` is defined without choice weights, so "whatever chose" holds vacuously. The step the prose needs is that `belief` is the posterior of the joint model **with** the policy's choice weights. The Lean proves that only for natural weights, in `givenCourse_eq_belief` through the core. For real-valued policies such as the softmax there is no statement that the posterior of `Q s · choiceWeight pick c · courseLik L s c` is `belief`. The prose leans on a definitional choice rather than a theorem.

**Evidence** (`Probe23b.lean`, compiles). The missing statement is one line, and the softmax never weighs a course nothing:

```lean
theorem posterior_choice_eq_belief (S : Finset σ) (Q : σ → ℝ) (L : ε → σ → ω → ℝ)
    (pick : List (ε × ω) → ε → ℝ) (c : List (ε × ω)) (chosen : choiceWeight pick c ≠ 0) :
    posterior S (fun s => Q s * (choiceWeight pick c * courseLik L s c)) = belief S Q L c := by
  funext s
  simp only [posterior, belief]
  have factor : ∀ s, Q s * (choiceWeight pick c * courseLik L s c) =
      choiceWeight pick c * (Q s * courseLik L s c) := fun s => by ring
  rw [Finset.sum_congr rfl fun s _ => factor s, ← Finset.mul_sum, factor s,
    mul_div_mul_left _ _ chosen]

theorem softmax_choiceWeight_pos (Es : Finset ε) (ne : Es.Nonempty) (γ : ℝ)
    (G : List (ε × ω) → ε → ℝ) : ∀ c, 0 < choiceWeight (fun c => softmax Es γ (G c)) c
  | [] => by simp [choiceWeight]
  | (e, o) :: rest => by
    simp only [choiceWeight]
    refine mul_pos ?_ (softmax_choiceWeight_pos Es ne γ G rest)
    exact div_pos (Real.exp_pos _) (Finset.sum_pos (fun _ _ => Real.exp_pos _) ne)
```

**Proposed fix.** Add both theorems. Then reword: "over the reals, for any choice weights reading the course, the posterior of the joint weights is the belief wherever the choices weigh something (`posterior_choice_eq_belief`). The softmax over a nonempty set weighs every course something (`softmax_choiceWeight_pos`), so the belief keeps every tied order under it (`belief_order_kept`)."

### F3. overclaim: `belief_order_from_core` has idle and derivable hypotheses, and its conclusion involves no policy

**Location.** `belief_order_from_core`, its docstring ("whatever the policy of choice"), the module header line 47 and NOTE §2 (2).

**What is wrong.**

1. `chosen` follows from `weighs`. Since `seekWeight = choiceWeight × courseLik` (`cast_seekWeight`), `0 < seekWeight choose lik h₁ c` forces `choiceWeight ≠ 0`.
2. The conclusion mentions neither `choose` nor `courses`. It is a strict order of two `belief` values, and `belief` reads neither. So the hypotheses `courses`, `distinctCourses` and `mem` can always be met with `courses = [c]`, and `choose` can be taken constant. "Whatever the policy of choice" quantifies over something the conclusion does not contain.
3. Neither `distinct` nor `mem₁` is needed for the conclusion. The theorem is a special case of `belief_order_kept` at natural weights, with more hypotheses. That it is proved through the core is a fact about the proof route, not the content. By AGENTS.md's record rule, a recheck of an existing result by another route is not another result.

**Evidence** (`Probe23a.lean`, compiles).

```lean
theorem chosen_of_weighs (choose : List (E × O) → E → ℕ) (lik : E → α → O → ℕ) (h : α)
    (c : List (E × O)) (weighs : 0 < LumpedSeeking.seekWeight choose lik h c) :
    choiceWeight (fun c e => (choose c e : ℝ)) c ≠ 0 := by
  intro zero; have cast := cast_seekWeight choose lik h c
  rw [zero, zero_mul] at cast
  have : (LumpedSeeking.seekWeight choose lik h c : ℝ) > 0 := by exact_mod_cast weighs
  linarith
```

`belief_order_direct` proves the same conclusion directly from `belief_order_kept` and `courseLik_nonneg`. It takes only `mem₂`, `tied`, `0 < courseLik … h₁ c` and `wrong`: no `choose`, no `courses`, no `distinct`, no `mem₁` (see `Probe23a.lean`).

**Proposed fix.** One of these:

- Drop `belief_order_from_core` and say in prose that the core's law and `belief_order_kept` agree through `givenCourse_eq_belief`.
- Better, replace it with a statement that really joins the two orders: for a chosen course and any listed `h₁ h₂`, tied or not, `(share … h₁).le (share … h₂) ↔ belief … c h₁ ≤ belief … c h₂`. This follows from `givenCourse_eq_belief` and the two directions of F5.

In any case, remove `chosen` (or derive it inside) and the phrase "whatever the policy of choice".

### F4. minor: `givenCourse_eq_belief` does not need the courses listed once

**Location.** `givenCourse_eq_belief` (`distinctCourses`); NOTE §2 (1) and §3 ("with hypotheses and courses listed once").

**What is wrong.** A course listed `k ≥ 1` times multiplies every hypothesis's weight given the record by `k`, and `k` cancels in the share. `distinct` (hypotheses listed once), `mem`, `chosen` and `mem₀` are all needed.

- **`distinct`.** Listing the true coin twice gives the share 50/85, while the belief over `{heads, tails}` is 25/60 (`Probe23b.lean`, by `decide` and `norm_num`).
- **`chosen`.** `Witness.unchosen_course` shows it is needed.
- **`mem₀`.** The belief is not zero off `S`, while the share of an unlisted hypothesis is 0 (`Probe23a.lean`, last example).

**Evidence** (`Probe23b.lean`, compiles). `givenCourse_eq_belief_dup` is the theorem without `distinctCourses`. It uses `mass_count : mass l f (fun x => decide (x = c)) = cnt c l * f c` and `cnt_pos`, then cancels `cnt c courses * choiceWeight … c` by `mul_div_mul_left`.

**Proposed fix.** Drop `distinctCourses`, which needs a counting lemma in the place of `mass_single`. Otherwise keep it, but say in NOTE §2 (1) and §3 that it is a convenience rather than a need.

### F5. minor: `toReal_lt_of_not_le` proves one direction, while its docstring says "is their order"

**Location.** The docstring of `toReal_lt_of_not_le` ("The core's order of two shares under one weighting is their order as real numbers"); NOTE §2 (2).

**What is wrong.** Only `¬ a.le b → b.toReal < a.toReal` is proved. The converse holds as well; it is what makes "is their order" true.

**Evidence** (`Probe23c.lean`, compiles): `not_le_of_toReal_lt` proves `(share l w e₂).toReal < (share l w e₁).toReal → ¬ (share l w e₁).le (share l w e₂)`.

**Proposed fix.**
- Prove the iff, or reword the docstring to "where one is not at most the other …, it exceeds it as a real number".
- The lemma is about `Share` alone and has nothing to do with seeking. It belongs beside `Share.toReal` and `Share.same_iff_toReal_eq` in `FreeEnergyReals`, as `Share.toReal_lt_of_not_le`. A bare `toReal_lt_of_not_le` in `Becoming.ExpectedFreeEnergy` is a generic name that can collide later.

### F6. overclaim (mild): `efe_seeking_keeps_order` is the core theorem at one policy, and "choice by expected free energy is a policy of the core's" is a typing fact

**Location.** NOTE §2 (2), headed "Choice by expected free energy is a policy of the core's"; the docstring of `efe_seeking_keeps_order`; the module header lines 43–46.

**What is wrong.** The proof is `LumpedSeeking.seeking_keeps_order prior _ lik …` with `choose := efeChoice …`. Nothing about expected free energy is used. Any function `List (E × O) → E → ℕ` is a policy of the core's, so the statement holds for every rule because it holds for every policy. The prose is honest that it is an instance ("is `LumpedSeeking.seeking_keeps_order` at that policy"). But listing it as item (2) of "what is proved", and counting it among 20 theorems, presents an instance as a result. AGENTS.md says a wrapper is not another result.

**Proposed fix.** In NOTE §2, mark `efe_seeking_keeps_order` (and `softmax_blind_to_split`, F13) as instances. Reword the heading to "Choice by expected free energy is among the core's policies (an instance)".

### F7. minor: with natural weights, "expected free energy" is computed on weights that are not probabilities

**Location.** `efe_seeking_keeps_order` and its docstring ("choosing each experiment by any rule with natural weights reading the experiments' expected free energies at the belief"); NOTE §3, "The join theorems"; the correspondence of `givenCourse_eq_belief`.

**What is wrong.**

1. `efeChoice … (fun e h o => (lik e h o : ℝ))` evaluates `expectedFreeEnergy` on the cast natural weights, for instance the coin's sixteenths: 9, 3, 3, 1. Suppose every hypothesis's weights under experiment `e` total `N_e` and the belief totals one. Then the logarithms of `N_e` cancel between risk and ambiguity, and the value is `N_e` times the principle's expected free energy of the normalized likelihood. So a rule such as argmin on these values can order experiments of different totals otherwise than the principle does. A numeric check on the coin model (Python) confirms the factor: the cast value is 19.6557 for the experiment reading both tosses, and 16 times the normalized value is 19.6557. With one experiment in sixteenths and another in thirty-secondths, the order flips. Take the experiment reading both tosses doubled to a total of 32 (18, 6, 6, 2) and the agreement experiment at 16, with the coin's prior and flat preferences. The normalized expected free energies are 1.228 and 1.379, so the first is preferred; the cast values are 39.31 and 22.07, so the second is. The theorem is unaffected, since every rule is allowed, and the principle's choice is the rule `G ↦ f (fun e => G e / N_e)`. The prose should say this.
2. The belief from natural weights is Bayes' posterior from prior **probabilities** proportional to the prior weights only where every hypothesis's likelihood weights have one total under each experiment. This is the core's `prior_share` caveat, inherited here. The checker's scope string flags the correspondence generally; NOTE §3 does not.

**Proposed fix.** Add one sentence to NOTE §3: "With natural weights the expected free energy is that of the cast weights: where every hypothesis's weights under an experiment total `N_e`, it is `N_e` times the principle's, so the principle's rule is the rule reading `G e / N_e`. The prior weights read as prior probabilities only where the likelihood totals agree (`prior_share`)."

### F8. minor: `softmax Es` weighs experiments outside `Es`

**Location.** `softmax` and its docstring.

**What is wrong.** For `e ∉ Es`, `softmax Es γ G e = exp (-γ G e) / Σ_{Es} …`, which is positive. So the choice weights are a distribution over `ε` only where `Es` is all of `ε`. `choiceWeight` multiplies the weight of the experiment actually in the course, which may lie outside `Es`.

**Evidence** (`Probe23a.lean`, compiles): `softmax ({true} : Finset Bool) 1 (fun _ => 0) false = 1`, and the weights over `Bool` total 2.

**Proposed fix.** Define it as `if e ∈ Es then … else 0`, or take `[Fintype ε]` with `Es = univ`. Otherwise state the restriction in the docstring: "read for experiments in `Es`".

### F9. minor: "no habit term, no free energy of the past" understates what the rules cover

**Location.** NOTE §3, "What a policy is"; the module header, Modelling choices ("a rule reads the expected free energies alone (no habit, no free energy of the past)").

**What is wrong.** `rule : (ε → ℝ) → ε → τ` may depend on `e` itself, so a **fixed** habit prior is a rule: `G ↦ σ(ln E − γ G)`. The free energy of the past is the same under every one-step policy here, because the hidden state is fixed and the past is common to every choice of next experiment, so it drops out of the policy posterior `σ(ln E − F − γ G)`. What the rules actually exclude is habits learned from the course, precision inferred as a belief, and policies of many steps. AGENTS.md asks that claims say exactly what the Lean proves, and this one says less.

**Proposed fix.** Reword: "a rule reads the experiments' expected free energies, and may weigh experiments by a fixed habit prior (`σ(ln E − γG)` is among the rules). With one-step policies and a fixed state, the free energy of the past is the same under every policy. Not covered: habits learned from the course, precision as a belief, policies of many steps."

### F10. overclaim (mild): what is "new", and what the profile statement owes to the expected free energy

**Location.** NOTE §5, "What is new … the statement that such an agent's whole course of seeking … reads the prior only through the weight it gives each likelihood profile"; the module header, "Standing"; the docstring of `seeking_reads_profiles`.

**What is wrong.** The profile statement follows from two facts. The first is non-identification: conditioning commutes with the lumping, so the class marginal of the posterior depends on the prior only through its class marginal. The second is that the rule reads the belief only through a functional of that class marginal. The expected free energy enters only through `expectedFreeEnergy_through`. Any criterion computed from the belief and a likelihood that reads through the classes would do: predicted outcomes, the epistemic value alone, or any information criterion of Bayesian adaptive design. That the predictive law of the data reads the prior only through its image under the likelihood map is standard. So "new" holds only for the restatement in the principle's terms, and the prose should say that the expected free energy is not doing the work.

**Proposed fix.** Write: "a corollary of Bayesian non-identification for adaptive designs whose criterion reads the belief only through the classes; stated here for the agent the principle describes". Consider citing Kadane (1974, *The role of identification in Bayesian theory*) beside Poirier (1998) and Dawid (1979). Keep "none of it is a new inequality".

### F11. minor: `courseWeight` is the agent's own predictive weight, and "its outcomes" should say so

**Location.** The docstrings of `courseWeight` and `seeking_blind_to_split` ("every course has one weight … its choices or its outcomes"); NOTE §2 (4)–(5).

**What is wrong.** `courseWeight S Q L pick c = choiceWeight pick c · Σ_s Q s · courseLik L s c` is the course's predictive (marginal) weight under the agent's own prior. That is correct, and it is a probability where `Q`, each `pick c` and each `L e s` are distributions; see F8 for the softmax. It is not the course's weight under the true state. That weight, `choiceWeight · courseLik s* c`, is also the same for the two priors, but that follows from the first conjunct and is not stated. "Its outcomes" is ambiguous between the two.

**Proposed fix.** Say "the agent's predictive weight of every course" in both docstrings. Add that, since the choices agree, the course's weight under any fixed state agrees as well. A one-line corollary would make that exact.

### F12. minor (names): `belief`, `toReal_lt_of_not_le`, `softmax`

**Location.** Declaration names.

**What is wrong.**
- **`belief`.** In UE17's vocabulary, which this module reuses, a *belief* `q` is any candidate distribution, and `posterior` is the one of least free energy. Naming the exact posterior after a course `belief` blurs that distinction, and F1 is the result. `belief` is also nonzero off `S`, unlike a belief over `S`. `coursePosterior` or `posteriorAfter` would be exact. If `belief` is kept, its docstring should open with "the posterior after a course".
- **`toReal_lt_of_not_le`** is a `Share` lemma placed and named as if it were general (F5).
- **`softmax`** is not a softmax over `ε` (F8).
- `courseLik`, `choiceWeight`, `efeChoice`, `seeking_reads_profiles` and `seeking_blind_to_split` are structural and fit their statements. `courseWeight` is acceptable with the docstring fix of F11.

**Proposed fix.** As above. Under AGENTS.md's rule of naming at claim time, renaming before landing costs nothing.

### F13. minor: an orphan lemma, and instances counted as theorems

**Location.** `courseLik_nonneg`; NOTE §2 ("26 new declarations: 20 theorems and 6 definitions").

**What is wrong.**
- `courseLik_nonneg` is declared, listed in the checker's audit and used nowhere. NOTE does not mention it.
- The 20 theorems include instances and re-derivations: `efe_seeking_keeps_order` (F6), `softmax_blind_to_split` (`(seeking_blind_to_split …).2`), `seeking_reads_profiles` (an instance of `seeking_blind_to_split`, though a meaningful one) and `belief_order_from_core` (F3). They also include helpers: `courseLik_tied`, `courseLik_through`, `coarse_div`, `cast_seekWeight` and `toReal_lt_of_not_le`.

**Proposed fix.** Use `courseLik_nonneg` in `belief_minimizes` (F1), or remove it. In NOTE §2, separate results from instances and helpers when counting.

### F14. gap (minor): the witnesses show the belief turning, not seeking by expected free energy, and the second part is about one course

**Location.** `Witness.separating_turns` and its docstring; NOTE §2 (6).

**What is wrong.**
- Both conjuncts are belief computations for one fixed course each. No expected free energy and no choice occurs; NOTE §4 says so.
- The second conjunct is set in a model whose only experiment is the agreement one (`Unit`). That is what "only the experiment reading agreement" means, and it is accurate. But what "only" buys is that **every** course keeps the order, and the witness states it for one course.
- Nothing shows that `seeking_blind_to_split` is informative, that is, two priors with different beliefs but identical choices.

**Proposed fix.** Optional:
- State the second part for every course of the agreement model with positive likelihood (`belief_order_kept` gives it at once).
- Add a witness in the coin model with the heads- and tails-biased coins lumped. Two priors alike on the classes would split the class differently, so their beliefs after `[((), (true, true))]` differ while `efeChoice` agrees at every course.
- A witness that a rule reading expected free energy chooses the separating experiment in the coin model under flat preferences would make NOTE §4's boundary concrete. It is costly in logarithms, and not required.

---

## Checked and found sound

- **`cast_seekWeight`.** The cast of the core's `seekWeight` is `choiceWeight × courseLik`, latest step first, matching the core's order.
- **`givenCourse_eq_belief`.** The statement is correct. The cancellation is `mul_div_mul_left` on the common choice weight. Where the course weighs nothing in the whole, both sides are 0 by `x / 0 = 0`. `distinct`, `chosen` and `mem₀` are needed (F4); `mem` is needed (a course not listed gives share 0).
- **`Witness.unchosen_course`.** It shows what it claims: under `pickReading` the course read by the agreement experiment has whole 0, so its share is 0, while the belief is positive.
- **`efeChoice`.** At course `c` it reads the expected free energies at the belief after `c`. Through `choiceWeight`, the weight of the step `(e, o) :: rest` is `pick rest e`, the belief before that step, as in the core.
- **`belief_ratio_kept`.** It holds with no hypothesis.
- **`belief_order_kept`.** `weighs` is needed (zero likelihood makes both beliefs 0), and `total` is needed as stated, since there is no nonnegativity hypothesis. Membership in `S` is not needed.
- **`coarse_belief`.** It holds unconditionally, including for classes outside `S.image π`, where both sides are 0.
- **The lumping results.** `efe_through_course`, `epistemic_through_course`, `courseWeight_through` and `seeking_blind_to_split` are exact as stated. The first conjunct of `seeking_blind_to_split` holds for rules of any value type, not only `ℝ` (`Probe23c.lean`, `choices_blind_any`); generalizing is optional. "Alike on the classes" needs no hypothesis that the priors are distributions.
- **`seeking_reads_profiles`.** The instance is correct: `B e (π s) = L e s` holds definitionally with `π s = fun e => L e s`, and classical decidable equality on profiles is disclosed. The profile includes outcomes outside `O`. That is needed, because `courseLik` reads every outcome of the course.
- **`Witness.separating_turns`.** The first conjunct uses the experiment reading both tosses: 5·9 = 45 for heads against 7·1 = 7 for tails, so the order turns. The second uses only the agreement experiment: 5·5 against 7·5, so tails stays above, through `belief_order_kept` with the tie. The docstring matches.
- **Duplicates.** No new declaration duplicates one in `FreeEnergyReals`, `ExpectedFreeEnergyReals` or `LumpedSeeking`. `belief_ratio_kept` generalizes `posterior_ratio_of_lumped` from one outcome to a course, and `courseLik_tied` is the real analogue of the core's `seek_tied`.
- **Axioms.** Every new declaration probed depends on `[propext, Classical.choice, Quot.sound]`, which is within the periphery's rule. `efe_seeking_keeps_order` picks them up through the reals in `efeChoice`, although the core theorem it instantiates has an empty report.
- **Declaration count.** 6 definitions and 20 theorems, as NOTE says: 47 declarations in the module, 32 of them theorems.
- **Literature.**
  - Rothenberg (1971, *Econometrica* 39) for identification, and Poirier (1998, *Econometric Theory* 14) for the Bayesian form, are apt. Poirier's point that the conditional prior of the non-identified given the identified is never revised is exactly `belief_ratio_kept` within a class. Dawid (1979, *JRSS B* 41) is the conditional-independence statement Poirier relies on. Poirier also stresses that the marginal of a non-identified parameter can move through prior dependence. That does not conflict with any claim here, since the claims concern within-class ratios and class-level choices.
  - Friston and others (2015) and Da Costa and others (2020) are apt for the softmax over expected free energy. The policy prior `σ(−γG)`, with habits `σ(ln E − γG)`, is the process-theory form (Friston and others 2017; Parr, Pezzulo and Friston 2022). The NOTE's statement of it is accurate. Its exclusions are understated (F9), not overstated.
  - Nothing claims that active inference's agent fails to correct. NOTE §4 and §5 bound the claim to what every experiment ties, and correctly leave open whether an agent choosing by expected free energy picks a separating experiment.
