# UE21: the free-energy bound in counting form, in the pure core

30 October 2026. AI-written note for board item UE21, item 6 of the plan for the free-energy principle as an integral part of the theory ([FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md)), with a pure-core module `Becoming.FreeEnergyCounting` ([tree](tree/Becoming/FreeEnergyCounting.lean)). Revised after an independent review and a re-check (§6).

## 1. Summary

UE17 stated variational free energy and its bound in the periphery, over Mathlib's reals: for a belief zero where the joint weight is, the free energy is at least the record's surprisal, with equality exactly at the posterior, and in a core generative model the minimizer is the core's share given the record ([record](../../../../../../theories/becoming/results/records/free-energy-bounds-surprisal.md)). Its record named a core form of the bound as the next step, and the principle's page listed it among what the theory cannot yet state. This item states it.

For a belief whose shares are natural counts `n` over listed hypotheses, total `N`, and natural joint weights `a`, total `A`, the bound exponentiated reads

  `N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n`.

With `N` positive and on the support, taking logarithms and dividing by `N` gives `Σ (n/N) log((n/N)/a) ≥ −log A`: the free energy of the belief `n/N` against the joint weights is at least the surprisal of their total. The module proves the counting form with no axiom, with its case of equality:
- **The bound** (`bound`), over any listed hypotheses, with no support condition: where a count sits on a hypothesis of joint weight nothing, the left side is nothing, as the free energy is infinite there as usually defined (`Witness.off_support`). UE17's real form needs the support condition, since with Mathlib's `log 0 = 0` its bound fails off the support, so off the support the two modules' laws are not one law.
- **Equality exactly in proportion** (`bound_eq_iff`): equality exactly where `n h * A = a h * N` at every listed hypothesis, and strict away from it (`bound_lt_of_not_proportional`). The degenerate cases agree trivially: every weight nothing, or every count nothing (`zero_weights_reach`, `no_counts_reach`). At one total the bound may be reached by no count belief (`Witness.total_two_unreached`: against weights 1 and 2, no belief of total 2).
- **Joined to the core's generative model** (`bound_given_record`, `given_record_eq_iff`, `posterior_counts_reach`): with the joint weight of a hypothesis its prior weight times the record's weight under it, the total is the record's weight (`record_total`), and the count beliefs at the bound are exactly those in proportion to the joint weights. With the hypotheses listed once, these are exactly the beliefs whose every count over the total is the same ratio as the hypothesis's share given the record (`given_record_eq_iff_share`, through `ConditionalWeights.posterior_single`); a hypothesis listed twice breaks this join (`Witness.duplicate_share`). Where the record weighs nothing, every count belief is at the bound (`nothing_record_reach_all`).

**[AI reading, D45]** So the principle's central bound, and its case of equality, hold in the pure core for every belief in counts, with no axiom and no logarithm. Read through the logarithm, for a belief with a positive total, on the support, where the record weighs something, with the hypotheses listed once, the least free energy over count beliefs of every total is the record's surprisal, reached exactly at the beliefs in proportion to the shares given the record: minimizing free energy over such beliefs is conditioning. At one fixed total it may not be reached.

## 2. The laws

### Pure core: `Becoming.FreeEnergyCounting` (55 theorems in 65 declarations, every axiom report empty; [scratch-3.log](scratch-3.log), on the closure after HE)

- **Arithmetic in counts**: `mul_pow_eq`, `self_pow_pos`, `lt_cancel_mul_left`, `lt_cancel_mul_right`, `base_zero_of_pow_zero`, `pow_succ_lt_pow_succ`, proved here because the prelude's `Nat.mul_pow` and `Nat.pow_lt_pow_left` use `propext` and `Nat.lt_of_mul_lt_mul_left` also `Classical.choice` and `Quot.sound` in Lean 4.29.1. The rest uses axiom-free laws of the prelude (`Nat.eq_of_mul_eq_mul_left`, `Nat.eq_of_mul_eq_mul_right`, `Nat.mul_lt_mul_of_pos_left`, `Nat.mul_lt_mul_of_pos_right`, `Nat.lt_of_add_lt_add_left`, `Nat.mul_eq_zero`) and of the core (`Naturals.pow_add`, `Naturals.mul_right_comm`, the cancellations, `total_zero`).
- **Rearrangement and a Bernoulli-type inequality**: `rearrange`, `rearrange_strict`, `powers_rearrange`, `powers_rearrange_strict`; `bernoulli`: `(k + 1) * x * y ^ k ≤ x ^ (k + 1) + k * y ^ (k + 1)`, strict for `x ≠ y` and `k > 0` (`bernoulli_strict`), with `bernoulli_split`, `bernoulli_regroup`, `bernoulli_close`.
- **The arithmetic–geometric mean inequality in counts**: `mean_step`: `(k + 1) ^ (k + 1) * S ^ k * y ≤ k ^ k * (S + y) ^ (k + 1)`, strict where `k * y ≠ S` and `k > 0` (`mean_step_strict`), with `mean_step_identity`, `mean_step_lhs`, `mean_step_rhs`; `mean_two`: `(n + m) ^ (n + m) * (x ^ n * y ^ m) ≤ (n * x + m * y) ^ (n + m)`, strict for `n > 0`, `x ≠ y` and at least one `y` (`mean_two_strict`), with `mean_two_sum`, `mean_two_ident`.
- **Two parts**: `two_parts`: `(n + m) ^ (n + m) * (a ^ n * b ^ m) ≤ (a + b) ^ (n + m) * (n ^ n * m ^ m)`, strict for positive counts unless `a * m = b * n` (`two_parts_strict`), reached only where `n * b = a * m` (`proportional_of_two_parts_eq`), with `two_parts_lhs`, `two_parts_rhs`.
- **The bound over listed hypotheses**, over the core's `total` (Prelude): `powerProduct`, `powerProduct_self_pos`, `zero_of_total_zero`, `cons_left`, `cons_mid`, `cons_right`; `bound`; `powerProduct_scaled`, `bound_eq_of_proportional`, `proportional_cons`, `proportional_of_bound_eq`, `bound_eq_iff`, `bound_lt_of_not_proportional`; `zero_weights_reach`, `no_counts_reach`.
- **Joined to the generative model**: `joint`, `record_total`, `bound_given_record`, `given_record_eq_iff`, `nothing_record_reach_all`, `given_record_eq_iff_share`, `posterior_counts_reach`.
- **Witnesses**: `Witness.even`, `Witness.first`, `Witness.strict_off_proportion` (`1 < 2`), `Witness.twoEach`, `Witness.scaled_reach` (`4 ^ 4 * 1 = 2 ^ 4 * (2 ^ 2 * 2 ^ 2)`), `Witness.secondOnly`, `Witness.off_support`, `Witness.oneTwo`, `Witness.split2`, `Witness.total_two_unreached`, `Witness.unitPrior`, `Witness.unitLik`, `Witness.nothing_record_reach`, `Witness.duplicate_share`.

## 3. What it shows, and what it does not

Shows:
- the free-energy bound for every belief in counts over listed hypotheses, in the pure core, with no axiom, no logarithm and no support condition;
- its case of equality: exactly the counts proportional to the joint weights, strict elsewhere;
- in a core generative model, that the count beliefs at the bound are exactly those in proportion to the joint weights, and, with the hypotheses listed once, exactly those at the shares given the record.

Does not show:
- the real form: that the counting inequality, after logarithms, is UE17's bound for the belief `n / N` holds for a positive total and on the support, and is a correspondence by hand here, not a theorem joining the two modules (a periphery theorem importing both, at `FreeEnergyReals`' next change);
- a minimization at one fixed total: the bound may be unreached there (`Witness.total_two_unreached`);
- conditioning where the record weighs nothing: every count belief is then at the bound, for a degenerate reason;
- beliefs with irrational shares, or densities;
- complexity and accuracy read from the core's own shares;
- any process by which a system lowers its free energy.

## 4. Standing and refutation

- **The bound.** In counts it is Cauchy's arithmetic–geometric mean inequality (1821) for `N` terms, `a h / n h` taken `n h` times, a count being a repetition, so the weighted form is not needed; equivalently Gibbs' inequality (Gibbs 1902) and the nonnegativity of the divergence (Kullback and Leibler 1951) for rational distributions. Read with `a / A` as a model and `n` as observed counts it says `∏ (a/A) ^ n ≤ ∏ (n/N) ^ n`: the observed frequencies maximize the multinomial likelihood (maximum likelihood; the method of types, Cover and Thomas 2006, §11.1). Both readings are classical; the counting form is near-definitional once the inequality is.
- **Equality.** The equality case of the arithmetic–geometric mean inequality, all terms equal, here the counts in proportion to the weights. Classical.
- **New here.** That the principle's central bound and its case of equality hold in the pure core with an empty axiom report, joined to the core's generative model; the proof route (a Bernoulli-type inequality from rearrangement, the mean step, two values, two parts, the list) is standard in outline, written here without the prelude's propositional extensionality.
- **Refutation.** A proved law has no counter-model. What could fail is the free-energy reading, which needs a positive total, the support and a record that weighs something, and states which beliefs reach the bound, not a minimization at one total.

## 5. Placement

- **Core.** `Becoming.FreeEnergyCounting`, a leaf importing `Becoming.ConditionalWeights` (L1). One record, *the free-energy bound in counts*, homed in 03 §6 after free-energy-bounds-surprisal.
- **Texts.** 03's thesis; 03 §6's reading on conditioning ("averages of logarithms … have no counting form here") and the free-energy paragraph ("until a core form lands"); 08 §8's bullet ("not yet stated"); the principle's page (In brief, the table row, §1, §5 and Standing); FEP-INTEGRATION's item 6; the UE plan; the board row's purpose, which said free energy itself would live in the core.
- **Records.** free-energy-bounds-surprisal: its next step and its fourth does-not-show item brought to UE21, and the new record related; conditioning-by-restriction: its correspondence names the bound in counts in the core, and the new record related.
- **Pending at those modules' next change.** `FreeEnergyReals`' docstring says the bound's counting form is "checked on small cases in REVIEW-UE17, not proved here", and `ConditionalWeights`' docstring is already pending (UE17's NOTE §6); both are to point to this module, with no core or periphery run for a docstring alone.
- **Modelling.** Natural counts and weights; listed hypotheses; `0 ^ 0 = 1`; the belief read as the shares `n / N`; the record's weight as the total, where UE17 reads the joint weights as shares of the whole weight, both bounds shifting by its logarithm.

## 6. Review

An independent read-only review by another AI agent ([REVIEW-UE21](REVIEW-UE21.md)) rebuilt the module against main and a probe of 32 theorems, and checked the counting law against UE17's real form on 4,368 small cases. It found the Lean sound and `bound_eq_iff` exact, and the free-energy reading saying more than the Lean. Its eight findings, every one taken:
- **F1** the reading's three conditions are stated (a positive total, a record that weighs something, the bound possibly unreached at one total), with `zero_weights_reach`, `no_counts_reach`, `Witness.total_two_unreached` and `Witness.nothing_record_reach`, and the refutation sentence corrected;
- **F2** the join to the shares given the record is a theorem with the hypotheses listed once (`given_record_eq_iff_share`, the review's), with `Witness.duplicate_share` showing why;
- **F3** strictness is a theorem (`bound_lt_of_not_proportional`, the review's), and `two_parts_eq` is `proportional_of_two_parts_eq`, reached "only" in proportion;
- **F4** ten helpers that re-proved axiom-free laws of the prelude and of `Becoming.Naturals` are dropped (the review named nine; `Nat.eq_of_mul_eq_mul_right` is the tenth), and the kept ones are named exactly (`lt_cancel_mul_left`, `pow_succ_lt_pow_succ`);
- **F5** the bound is stated over the core's `total` (`record_total` bridges `ConditionalWeights.evidence` to it), and `powers` is `powerProduct`;
- **F6** off the support the two modules' laws are not one law, and the normalization (the record's weight here, the record's share in UE17) is stated;
- **F7** the live texts the result makes out of date are listed in §5, the two module docstrings as pending;
- **F8** the standing names Cauchy's unweighted inequality and the multinomial likelihood reading.

The module went from 58 theorems in 65 declarations to 56 in 66.

The reviewer then re-checked the fold ([RECHECK-UE21](RECHECK-UE21.md)): sound, no sentence contradicting the Lean, F1–F3, F6 and F7 taken fully and F4, F5 and F8 in part. Its six findings, every one taken:
- **R1** "where the record weighs nothing, every count belief is at the bound" is a general theorem (`nothing_record_reach_all`, the re-check's), cited wherever it is said;
- **R2** the readings carry "with the hypotheses listed once";
- **R3** "the same law" is gone: the real form agrees with this bound on the support, for a positive total, by hand;
- **R4** two more duplicates are dropped, `total_zero` for the core's and `zero_of_mul_eq_zero` for `Nat.mul_eq_zero`, so no core name is shadowed, and `Nat.succ_ne_zero` is no longer listed as re-proved;
- **R5** 08 §8 cites Cauchy's inequality in counts, a count being a repetition;
- **R6** the wording of the degenerate cases, two witnesses' docstrings and the record's alias.

The module is now 55 theorems in 65 declarations ([scratch-3.log](scratch-3.log)).

## References

- Cauchy, A.-L. (1821). *Cours d'analyse de l'École royale polytechnique*, note II.
- Cover, T. M., and Thomas, J. A. (2006). *Elements of Information Theory*, 2nd ed., Wiley, §11.1.
- Gibbs, J. W. (1902). *Elementary Principles in Statistical Mechanics*. Scribner.
- Hardy, G. H., Littlewood, J. E., and Pólya, G. (1934). *Inequalities*. Cambridge University Press.
- Kullback, S., and Leibler, R. A. (1951). On information and sufficiency. *Annals of Mathematical Statistics* 22, 79–86.
