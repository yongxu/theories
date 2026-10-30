# RECHECK-UE23: recheck of the seeking section after the fix round

An adversarial, read-only recheck by an AI agent, 30 October 2026. This recheck is AI-written.

## What was read and compiled

**Read.**
- The module header of `ExpectedFreeEnergyReals.lean` and its section from "Seeking by expected free energy, joined to the core's seeking" to the end, in the worktree `wt-ue23`.
- [REVIEW-UE23](REVIEW-UE23.md) (F1–F14) and [NOTE](NOTE.md) (§1–§6).
- The prose strings in `kit/texts_ue23.py`, `kit/make_records_ue23.py` and `kit/study_ue23.txt`.
- `SCOPE` in `check_expected_free_energy_reals.py`.
- The APIs the section uses: `Becoming.LumpedSeeking` (`seekWeight`, `Tied`, `seeking_keeps_order`, `Agree`), `Becoming.ConditionalWeights` (`share`, `Share.le`, `pairWeight`, `restrict`, `prior_share`) and `FreeEnergyReals` (`posterior`, `minimizes_iff_posterior`, `givenShare_toReal`, `cast_mass_eq_sum`, `Share.toReal`, `Share.same_iff_toReal_eq`).

**Checked against the receipt.** The receipt `20261030T090748.312916Z` binds the module's current bytes (sha256 `9313cdf4…`). Its scope string equals `SCOPE`. It lists 65 declarations, 47 of them theorems. Of these, 62 depend on `propext`, `Classical.choice` and `Quot.sound`, `mass_count` on `propext` alone, and `Witness.biasClass` and `Witness.swappedPrior` on nothing. `ue23build/Seek23b.lean` is byte-identical to the module's section. The checker was not rerun.

**Compiled.** One probe file, `ue23build/Recheck23a.lean`, imports `EFEBase`, `Becoming.LumpedSeeking` and `Seek23b`. It compiles with no error and no warning. `#print axioms` gives the three standard axioms for its two theorems. Every Lean fragment cited below comes from it. A short Python check confirmed the factor `N_e` of F7 and the order flip the review gave (39.31 against 22.07 cast; 1.228 against 1.379 normalized).

## Overall verdict

The Lean is sound. Every theorem compiles and states what its docstring says, with one exception: the docstring of `coursePosterior_order_kept` (N2). The counts and roles in NOTE §2 add up. The witnesses' numbers are right. Most findings were taken well. The Lean of F1, F2, F3, F4, F5, F8 and F14 is a real improvement.

The prose is not ready to land. It brings in two new overclaims:

- **N1.** It counts real-valued rules, the softmax among them, as the core's policies. But `efe_seeking_keeps_order` takes `rule : (E → ℝ) → E → ℕ`.
- **N5.** It credits the join (`givenCourse_eq_coursePosterior`) with the instance `efe_seeking_keeps_order`. That instance does not use the join.

Several summaries also drop conditions that the Lean needs (N2–N4), or state a witness as a law (N6). All fixes are to wording. No Lean has to change. Two short optional theorems are given (N1, N6).

## F1–F14

| | Verdict | Note |
|---|---|---|
| F1 | partly | `coursePosterior_minimizes` is exact, the iff of `minimizes_iff_posterior` with the condition of zero. But the docstring of `coursePosterior` and the summaries still say "it is the one of least free energy" without the positive total that the review's fix carried. With total zero the posterior is not a belief at all (N4). |
| F2 | partly | `posterior_choice_eq_coursePosterior` and `softmax_choiceWeight_pos` are right, and the header words the composition correctly. But `coursePosterior_order_kept`'s docstring still says "under every policy" with no condition, and several summaries drop "where the choice weights are not zero" (N2). |
| F3 | taken | `belief_order_from_core` is gone. `givenCourse_le_iff` joins the two orders for any two listed hypotheses. All five of its hypotheses are needed. |
| F4 | taken | `distinctCourses` is dropped, through `mass_count`. NOTE §3's example for `distinct` is underspecified (N8). |
| F5 | taken in substance | `share_le_iff_toReal_le` proves the iff, and its docstring is exact. Its home is deferred, and the reason is stated. A later move changes its full name, which record law 2 cites (N7). |
| F6 | taken | `efe_seeking_keeps_order` and `softmax_blind_to_split` are marked as instances. The same standard is not applied to `coursePosterior_minimizes` or `coursePosterior_rescale` (N7). |
| F7 | taken | The factor `N_e`, the rule reading `G e / N_e` and the condition of `prior_share` are stated. The algebra checks, given that the posterior totals one, which NOTE says and the header leaves implicit. |
| F8 | taken | The softmax ranges over a finite type. `sum_softmax` gives a total of one where the type is nonempty. |
| F9 | taken | A fixed habit is among the rules of `efeChoice`. The past's free energy is common to every one-step policy. What is not covered is named. |
| F10 | taken | The standing is now "a corollary of non-identification", the role of the expected free energy is stated, and Kadane is cited. |
| F11 | taken | `courseWeight` is called the agent's predictive weight. The third conjunct of `seeking_blind_to_split` states the weight under every state. |
| F12 | taken | `coursePosterior` and `share_le_iff_toReal_le` replace the old names, and `softmax` ranges over all the experiments. |
| F13 | taken | `courseLik_nonneg` is used, and the roles are counted apart. A new orphan appeared: `sum_softmax` is used by no declaration (N7). |
| F14 | taken | `separating_turns` holds for every course of the agreement model. `split_unseen` shows two priors whose posteriors differ while their choices agree. Its model has one experiment, so what agrees is that experiment's expected free energy under every rule, not a choice among experiments (compiled in `Recheck23a.lean`, last example). "Seek alike" should say so. |

## New findings

### N1. overclaim: real-valued rules, the softmax included, are counted as the core's policies

**Location.**
- `kit/texts_ue23.py`, 03 §6: "Choosing each experiment by any rule … is among the core's policies, so the core's law holds at it (`efe_seeking_keeps_order`, an instance)".
- The principle's page: "An agent choosing each experiment by expected free energy … is one such policy, at every rule, the softmax included (`efe_seeking_keeps_order`, `coursePosterior_order_kept`)".
- FEP-INTEGRATION item 8: "choosing by any rule reading expected free energy at that posterior is among the core's policies".
- `kit/make_records_ue23.py`, the seeking record's does-not-show item 2: "expected free energy and its softmax enter through the periphery's join (`ExpectedFreeEnergy.efe_seeking_keeps_order`)".
- `SCOPE`: "Choosing by any rule … is among the core's policies".
- The module header and study item (3): "by a rule …, so it is among the core's policies". The rule's type is not stated, although `efeChoice` allows any value type.

**What is wrong.** A policy of the core's has natural weights: `choose : List (E × O) → E → ℕ`. Accordingly `efe_seeking_keeps_order` takes `rule : (E → ℝ) → E → ℕ`. The softmax, and the fixed-habit rule `σ(ln E − γG)` the header names, are real-valued. They are not among the core's policies, and `efe_seeking_keeps_order` cannot be instantiated with them. The softmax is covered only over the reals: by `posterior_choice_eq_coursePosterior` with `softmax_choiceWeight_pos`, then `coursePosterior_order_kept`, under that theorem's conditions (N3).

**Evidence.** The signature of `efe_seeking_keeps_order`. The real route compiles as one theorem (`Recheck23a.lean`):

```lean
theorem softmax_order_kept {σ ε ω : Type*} [Fintype ε] [Nonempty ε] (S : Finset σ) (O : Finset ω)
    (Q : σ → ℝ) (L : ε → σ → ω → ℝ) (P : ω → ℝ) (γ : ℝ) {s₁ s₂ : σ}
    (tied : ∀ e o, L e s₁ o = L e s₂ o) (c : List (ε × ω)) (weighs : 0 < courseLik L s₁ c)
    (total : 0 < ∑ s ∈ S, Q s * courseLik L s c) (wrong : Q s₁ < Q s₂) :
    posterior S (fun s => Q s * (choiceWeight (efeChoice (softmax γ) S O Q L P) c *
        courseLik L s c)) s₁ <
      posterior S (fun s => Q s * (choiceWeight (efeChoice (softmax γ) S O Q L P) c *
        courseLik L s c)) s₂ := by
  have pos : 0 < choiceWeight (efeChoice (softmax γ) S O Q L P) c :=
    softmax_choiceWeight_pos γ (fun c e => expectedFreeEnergy S O (coursePosterior S Q L c) (L e) P) c
  rw [posterior_choice_eq_coursePosterior S Q L (efeChoice (softmax γ) S O Q L P) c pos.ne']
  exact coursePosterior_order_kept S Q tied c weighs total wrong
```

**Proposed fix.**
- Write "any rule with natural weights" wherever the core's law is said to hold at choice by expected free energy.
- For the softmax and the habit rule, cite `posterior_choice_eq_coursePosterior`, `softmax_choiceWeight_pos` and `coursePosterior_order_kept`, "over the reals". Do not say "one such policy".
- In the seeking record, write: "expected free energy enters through the periphery (`efe_seeking_keeps_order` for natural-valued rules; the softmax over the reals, `coursePosterior_order_kept`)".
- Optionally add `softmax_order_kept`, as an instance.

### N2. overclaim: "the choice weights drop out" and "under every policy" without the condition that they weigh something

**Location.**
- Header: "Any choice weights reading the course drop out of it (`posterior_choice_eq_coursePosterior`)".
- 03 §6 text: "any choice weights along the course drop out of it".
- `SCOPE`: "any choice weights reading the course drop out of it".
- Record law 1: "any choice weights along the course, or each experiment's scale, drop out of it".
- Study item (1).
- The docstring of `coursePosterior_order_kept`: "under every policy, by `posterior_choice_eq_coursePosterior`".

**What is wrong.** `posterior_choice_eq_coursePosterior` needs `choiceWeight pick c ≠ 0`, and `coursePosterior_rescale` needs each factor nonzero. Where the choices along the course weigh nothing, the posterior of the joint weights is 0 everywhere. It is not the posterior after the course, and the strict order of `coursePosterior_order_kept` fails for it. (For the ratio, "every policy" is harmless, since 0 = 0.) NOTE §2 states the condition. The summaries and the docstring drop it.

**Evidence** (`Recheck23a.lean`, N-a). In the coin model with the agreement experiment and zero choice weights, the joint posterior of the heads-biased coin after two heads is 0, while `coursePosterior … Bias.heads = 25 / 84`.

**Proposed fix.** Add "where they weigh something" (and "nonzero" for the scale) in each place. In the docstring, write "under every policy whose choices along the course weigh something".

### N3. overclaim: "keeps its strict order after every course" omits that the course must be possible under the pair

**Location.**
- Header: "keep their prior ratio and their strict order in the posterior after every course".
- `SCOPE`: "keeps its prior ratio and strict order in the posterior after every course".
- Record law 3: "keeps its prior ratio and strict order after every course".
- Study item (4).
- 03 §6 text: "keeps its order under every policy whose choices weigh something".

**What is wrong.** `coursePosterior_order_kept` needs `0 < courseLik L s₁ c` and a positive total. Where the course is impossible under the tied pair, both posteriors are 0 and the strict order is lost. This holds even when the total is positive. The core states the same condition (`weighs`).

**Evidence** (`Recheck23a.lean`, N-b). Three states, the first two tied, with prior 1, 2, 3. The outcome `true` is impossible under the pair and certain under the third state. After `[((), true)]` the total is positive, yet `¬ coursePosterior … 0 < coursePosterior … 1`.

**Proposed fix.** Add "where the course is possible under the pair" (or "has positive likelihood under them") in each place.

### N4. overclaim: "it is the one of least free energy" without a positive total

**Location.**
- The docstring of `coursePosterior`: "it is the one of least free energy against them, where they are nonnegative".
- Header, `SCOPE`, 03 §6 text, record law 1 and study item (1): "is the belief of least free energy among those zero wherever the joint weights are". These also drop the nonnegative prior and likelihoods.

**What is wrong.** `coursePosterior_minimizes` is an iff about a given belief. It does not assert that the posterior is among the admissible beliefs. Where the joint weights total nothing, the posterior is 0 on `S` and does not total one, and no belief that is zero wherever the joint weights are totals one. So the class is empty, and "it is the one" is false. The review's F1 fix had "and total something". The revision dropped it.

**Evidence** (`Recheck23a.lean`, N-c). With every likelihood zero, the posterior after the course totals 0. Every `q` that is zero wherever the joint weights are has `∑ q ≠ 1`.

**Proposed fix.** Write "where they are nonnegative and total something" in the docstring. In the summaries, add "with a nonnegative prior and likelihoods, where the course weighs something under the prior".

### N5. overclaim (misattribution): the join is credited with the instance at choice by expected free energy

**Location.**
- 08 §8 text: "through the join, in which the posterior after a course is the core's share given it, it holds for an agent choosing by expected free energy at every rule".
- 03 §6, the home section of `what-seeking-cannot-separate`: "is one such policy, that posterior being the share given the course (…; `efe_seeking_keeps_order`)".
- Study readings: "the join shows it holds for the agent the principle describes, at every rule of choice".
- The record's related entry for `what-seeking-cannot-separate`: "seeking by it is among this law's policies, its posterior the core's share given the course".

**What is wrong.** `efe_seeking_keeps_order` is `seeking_keeps_order` at the policy `efeChoice rule S Os Qr A P`. Its agent's model (`Qr`, `A`, `S`) is arbitrary and need not be the core's (`prior`, `lik`, `hs`). The proof uses neither `givenCourse_eq_coursePosterior` nor any identity between the agent's posterior and the share. The law holds at choice by expected free energy for the reason NOTE §2 (3) gives: every natural-valued function of the course is a policy. The join says something else. Where the agent's model is the core's (natural weights, hypotheses listed once, a listed course chosen with some weight), the share given the course is the agent's posterior (`givenCourse_eq_coursePosterior`). The core's order given the course is then the posterior's order (`givenCourse_le_iff`). "At every rule" through the join is wrong twice: the join is not used, and real-valued rules are not core policies (N1).

**Evidence.** The proof term of `efe_seeking_keeps_order` and its arbitrary `Qr`, `A` and `S`.

**Proposed fix.** Separate the two claims: "the core's law holds at choice by any natural-valued rule reading expected free energy, since every such rule is a policy of the core's (`efe_seeking_keeps_order`, an instance); where the agent's model is the core's, the share given a chosen course is its posterior and the two orders are one (`givenCourse_eq_coursePosterior`, `givenCourse_le_iff`); over the reals, the softmax included, the tied order is kept where the choices and the course weigh something (`coursePosterior_order_kept`)".

### N6. overclaim: witnesses stated as laws

**Location.**
- "where the choices along the course weigh nothing the share is 0" (header and study item (2), citing `Witness.unchosen_course`).
- Record law 2: "a course never chosen has share 0".
- NOTE §2: "(witness): where the choice weights are zero, the share is 0 while the posterior is not".
- Record law 3 and 03 §6 text: "where an experiment separates, the posterior turns". Also the opening line of `Witness.separating_turns`'s docstring.

**What is wrong.**
- The share claim is true in general, but the Lean proves it only in one witness. NOTE's "while the posterior is not" is false in general: the posterior is 0 too where the prior or the course's likelihood is.
- "Where an experiment separates, the posterior turns" is false as a law. It turns after some outcomes, not after others.

**Evidence** (`Recheck23a.lean`, N-d and N-e). The general share fact compiles in six lines:

```lean
theorem unchosen_share_zero … (unchosen : choiceWeight (fun c e => (choose c e : ℝ)) c = 0) … :
    (share (openSteps hs courses) (ConditionalWeights.restrict (fun x => decide (x.2 = c))
      (pairWeight prior (Becoming.LumpedSeeking.seekWeight choose lik)))
      (fun x => decide (x.1 = h₀))).toReal = 0 := by
  rw [givenShare_toReal prior (Becoming.LumpedSeeking.seekWeight choose lik) courses
    (fun x => decide (x = c)) distinct mem₀]
  simp only [mass_count, Nat.cast_mul, cast_seekWeight, unchosen, zero_mul, mul_zero, zero_div]
```

Under the experiment reading both tosses, after two tails the tails-biased coin stays above the true one (5 against 63).

**Proposed fix.**
- Add `unchosen_share_zero`, a helper, or write "in the coin witness".
- Drop "while the posterior is not" from NOTE, or limit it to the witness.
- Write "in the coin witness, after two heads read by the experiment reading both tosses, the posterior turns".

### N7. minor: roles, an orphan and homes

**Location.** NOTE §2 roles; `sum_softmax`; `mass_count`; `share_le_iff_toReal_le`.

**What is wrong.**
- `coursePosterior_minimizes` is `minimizes_iff_posterior` at the course's joint weights. Its proof is one application, with `courseLik_nonneg`.
- `coursePosterior_rescale` is `posterior_choice_eq_coursePosterior` at the constant choice weights `k e`, through `courseLik_rescale`.
- NOTE counts `seeking_reads_profiles`, an instance at a lumping, as an instance. By the same standard these two are instances too, which gives 11 results and 5 instances. The two-line compositions `efe_through_course`, `epistemic_through_course` and `givenCourse_le_iff` are corollaries; calling them results is a judgment call.
- `sum_softmax` is listed as a helper but helps no declaration. It supports the docstring of `softmax`.
- `mass_count` (core `mass` and `List.count`, on `propext` alone) and `share_le_iff_toReal_le` are core-vocabulary lemmas under generic names in `Becoming.ExpectedFreeEnergy`. Record law 2 cites both by full name. Moving them later to `FreeEnergyReals`, as NOTE §6 promises, will need a repoint of that law.

**Proposed fix.** Recount by one standard. Call `sum_softmax` a fact about the definition. State in NOTE §6 that the move will repoint record law 2, or give the lemmas their final names now.

### N8. minor: NOTE §3's example for `distinct` is underspecified

**Location.** NOTE §3, "The join theorems": "listing the true coin twice gives a share of 50/85 against a posterior of 25/60".

**What is wrong.** The numbers hold for the list `[heads, heads, tails]`, with the fair coin dropped, under the agreement experiment after two heads. That is the review's probe. With the coin's three hypotheses and the true coin listed twice, the share is 50/109 and the posterior 25/84.

**Evidence** (`Recheck23a.lean`, N-f). The share's part is 50 and its whole 109 for `[heads, heads, fair, tails]`, by `decide`.

**Proposed fix.** Name the list and the course: "the hypotheses `[heads, heads, tails]` under the agreement experiment, after two heads: share 50/85, posterior 25/60".

### N9. minor: "which turns on the preferences" understates the boundary

**Location.**
- Header, "What is not derived".
- Record does-not-show item 3 ("that turns on its preferences, pragmatic value outweighing epistemic value"), the seeking record's does-not-show item 3, the page's §5 and NOTE §4.

**What is wrong.**
- Under the softmax every experiment has positive weight. A separating experiment is then chosen with some weight, whatever the preferences. Only how often turns on them.
- Under an argmin rule the choice also turns on the posterior and on how much each experiment tells. With flat preferences the expected free energy is the negative epistemic value plus `log |O|`, and a non-separating experiment can carry more information than a separating one.

**Proposed fix.** Write: "whether, or how often, an agent choosing by expected free energy chooses an experiment that separates, which turns on its preferences, its posterior and the experiments' information".

### N10. minor: the English and Chinese of the correspondence addition differ

**Location.** `make_records_ue23.py`, `COR_ADD`.

**What is wrong.** The Chinese adds "并为原理所述之主体重述" (and restated for the agent the principle describes) and "期望自由能之" before softmax. The English has neither. The same field should say the same thing in both languages.

**Proposed fix.** Add ", restated for the agent the principle describes" to the English, or drop the clause from the Chinese.

### Other observations (not findings)

- **Placeholders.** NOTE still ends with the placeholder `RECHECK-PARAGRAPH`, and nothing guards it. The study's `REVIEW-PARAGRAPH` is guarded by `texts_ue23.py`'s assertion.
- **A stale docstring.** The docstring of `make_records_ue23.py` says "two counterexamples", but the script adds three.
- **Literature.** Every citation is apt for what it is cited for:
  - Rothenberg (1971) for identification.
  - Kadane (1974), Dawid (1979) and Poirier (1998) for the Bayesian form: the conditional prior of the non-identified given the identified is never revised.
  - Friston and others (2015) for the softmax over expected free energy and the extrinsic and epistemic split.
  - Da Costa and others (2020) for the softmax as the principle's rule.
  - Parr, Pezzulo and Friston (2022) for the policy prior with habits.
  - One caution, from memory: the habit term `ln E` was introduced in Friston and others (2016, "Active inference and learning"). I cannot confirm that the 2017 process theory carries it. Citing 2016 beside 2022 would be safer.
- **Names.** `blind`, `unseen` and `turns` are perceptual metaphors, not structural words. They are not wrong, and renaming is not required under the naming rule.

## Counts by kind

- **Lean errors:** none.
- **Overclaims (6).** Two are substantive: N1 (real-valued rules counted as core policies) and N5 (the join credited with the instance). Four are minor: N2, N3 and N4 (conditions dropped from the prose) and N6 (witnesses stated as laws).
- **Gaps:** none.
- **Minor (4):** N7 (roles, an orphan, homes), N8 (an underspecified example), N9 (the boundary's wording) and N10 (English and Chinese differ).
- **F1–F14:** 12 taken (F5 in substance; F6's standard not applied to two theorems, N7) and 2 partly (F1, F2: the Lean of each is right, the prose drops conditions).
