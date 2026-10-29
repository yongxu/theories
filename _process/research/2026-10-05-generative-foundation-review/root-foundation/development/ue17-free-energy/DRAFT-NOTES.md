# UE17 draft: variational free energy and its bound (periphery)

29 October 2026. AI-written notes on a draft of board item UE17, item 2 of the plan [FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md). **The drafting record**, kept as it was before the review: the module as landed, its counts and its names are [NOTE.md](NOTE.md)'s, after the review ([REVIEW-UE17](REVIEW-UE17.md)).

## What the Lean proves

[`FreeEnergyReals`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/FreeEnergyReals.lean) is a periphery module. It imports [`Becoming.ConditionalWeights`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ConditionalWeights.lean) and Mathlib, and its namespace is `Becoming.FreeEnergy`. The one exception is `Becoming.ConditionalWeights.Share.toReal` (part over whole), placed in the core's namespace for dot notation, as `RegimeReals` does; no core file changes.

- **Quantities** over `s : Finset ι`: `freeEnergy s q p = Σ q i (log q i − log p i)`; `divergence s q r` (the same sum, read against a distribution); `surprisal P = −log P`; `posterior s p i = p i / Σ p`.
- **Bound** (`surprisal_le_freeEnergy`): for `q ≥ 0` with `Σ q = 1`, `p ≥ 0`, and `q` zero wherever `p` is, `−log Σ p ≤ freeEnergy s q p`. That `Σ p > 0` follows (`total_pos`).
- **Equality** (`freeEnergy_eq_surprisal_iff`): under the same hypotheses, the two sides are equal exactly where `q i = posterior s p i` for every `i`.
  - The plan's form with `p` positive is `freeEnergy_eq_surprisal_iff_of_pos`.
  - The value at the posterior is `freeEnergy_posterior`. `minimizes_iff`: among such beliefs, the posterior alone has the least free energy.
  - `Witness.bound_fails_off_support`: off the support, with Mathlib's `log 0 = 0`, the bound fails.
- **Divergence plus surprisal** (`freeEnergy_eq_divergence_add_surprisal`): needs `Σ q = 1`, support and `Σ p ≠ 0`, and no sign hypothesis.
  - From the posterior, the divergence is nonnegative and zero exactly at equality (`divergence_posterior_nonneg`, `divergence_posterior_eq_zero_iff`).
  - Between any two distributions: `divergence_nonneg`, `divergence_eq_zero_iff`.
- **Complexity less accuracy** (`freeEnergy_eq_complexity_sub_accuracy`): `freeEnergy s q (prior·lik) = divergence s q prior − Σ q i log (lik i)`. It needs only that `q` is zero wherever `prior i · lik i` is.
- **Join to the core.** The causes are the listed hypotheses (`Distinct hs`, summed over `hs.toFinset`). The joint weight of `h` is the share of the courses with hypothesis `h` whose record agrees, cast to a real.
  - `jointShare_part`, `jointShare_toReal`, `recordShare_toReal` (through `evidence`), `sum_jointShare`: the joint shares sum to the record's share.
  - `givenShare_toReal` (through `posterior_single`) and `givenShare_eq_posterior`: the core's share given the record (`ConditionalWeights.restrict`) is the posterior of the joint shares. No positivity is needed.
  - `record_surprisal_le_freeEnergy` and `freeEnergy_eq_record_surprisal_iff`: the bound, and equality exactly at that share, for beliefs zero wherever `prior h * mass os (lik h) rec = 0`.
  - Where the record's mass is positive:
    - `freeEnergy_givenShare`: the free energy there is the surprisal of the record's share.
    - `minimizes_iff_givenShare`: that share is the one belief with the least free energy.
- **Optional item, done** (`surprisal_product`, from `share_product`): surprisal adds over independent parts when both events weigh something. Also `surprisal_eq_log_reciprocal`, the logarithm of `Share.reciprocal`.
- **Helpers:** `term_le`, `term_eq_iff_of_pos`, `term_eq_iff`, `freeEnergy_congr`, `sum_terms`, `sum_normalized_sub`, `posterior_nonneg`, `posterior_eq_zero`, `sum_posterior`, `toReal_nonneg`, `share_toReal_pos`, `toReal_mul`, `cast_mass_eq_sum`, `weight_zero_of_jointShare_zero`.

## Against the plan's item 2

Everything item 2 asks of the Lean and the checker is done. Still left for landing:
- the record, saying the law stays in the periphery until a core form lands;
- the board claim;
- an independent review;
- registration wherever periphery modules are listed.

## Deviations

- **Weaker hypotheses.** Neither the bound nor the equality assumes `Σ p > 0`. Equality holds for `p ≥ 0` with support, and the positive case is a corollary. The decompositions need no positivity.
- **Normalized joint weights.** The joint weights are the core's shares, not raw natural weights, so the minimum is the surprisal of the record's share. The posterior is the same either way.
- **Where positivity enters.** The record's mass is assumed positive only where the minimizer must have total one.
- **Support of the minimization.** It ranges over beliefs that are zero wherever the joint weight is. Elsewhere the free energy is infinite as usually defined; the witness shows Mathlib's convention breaks the bound there.
- **Naming.** The core's `restrict` must be written `ConditionalWeights.restrict`. Otherwise `Becoming.restrict` (from `Context`) wins inside `Becoming.FreeEnergy`.

## Left out

- **Complexity and accuracy from the core's own prior and likelihood shares.** This needs `prior_share`'s common likelihood total, and item 2's join concerns the posterior. It is for UE19 or a follow-up.
- **A real form of `Share.le_iff_reciprocal`.** Short, but not asked.
- **UE2's [`log_reciprocal_share_le`](../../../history/root-foundation/development/ue2-conditional-weights/periphery/ConditionalWeightsReals.lean).** The join supersedes it; UE2's other proofs are reused here under new names.

## Checker and receipt

[`check_free_energy_reals.py`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/check_free_energy_reals.py) is the regime checker with a new target, receipt, run folder, scope, docstring and temporary folder's prefix; everything else is identical.

- **Receipt `20261029T134610.999747Z`, passed.** [Receipt](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/free-energy-reals-verification.json); [run folder](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/free-energy-reals-checks/20261029T134610.999747Z/).
- **Axioms.** 44 declarations audited: 39 theorems and 5 definitions. Of these, 43 depend on exactly `propext`, `Classical.choice` and `Quot.sound`; `jointShare_part` depends on none. There is no `sorryAx`.
- **Closure.** All 56 modules match passed receipts.
- **Lean steps.** 4 ran: version, the module, the axiom audit and the signatures. 56 were reused:
  - 51 from a scratch warm-up, [`warm_closure.py`](warm_closure.py), stamp `20261029T132756.348413Z`. It used the checker's own context, keys, command and environment, and every log was empty; the receipt's `retained` path for these points to a scratch folder.
  - 5 from earlier runs.
- **Set aside.** An earlier passing run, `20261029T134319.790152Z`, predates two docstring edits. It was moved to the scratchpad, out of the repository.
- **`main` moved.** The receipt names `main` at `f1a4f6b81`; the worktree branched at `0227f5c7e`. Here `Becoming.Reserve`, `Becoming.Retaining` and `check_becoming.py` differ from `main`, so the run folder holds copies. Re-run the checker on the merged head at landing.
