# UE17: variational free energy and its bound, joined to the core's conditioning

29 October 2026. AI-written note for board item UE17, item 2 of the plan for the free-energy principle as an integral part of the theory ([FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md)), with the periphery module `FreeEnergyReals` ([module](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/free-energy/FreeEnergyReals.lean)) and its checker. It states what the Lean proves, what it shows and does not, and the standing of each law. The module was drafted to the plan ([DRAFT-NOTES.md](DRAFT-NOTES.md), the drafting record) and revised after an independent review (§7).

## 1. Summary

The free-energy principle's central quantity is variational free energy: the average, under a belief about hidden causes, of the logarithm of the belief less the logarithm of the joint probability of cause and record. It bounds the surprisal of the record, and the bound is met exactly where the belief is the posterior, so minimizing free energy over the beliefs where it is finite is exact Bayesian inference. Until now the theory stated belief as conditioning by restriction and surprisal only as the reciprocal of a share, in counting form ([03](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-conditioning-by-restriction)); the core takes no logarithm and states no average of logarithms. This module states free energy over the reals, its bound and the bound's equality, its decompositions, and the join: in a generative model of the core, minimizing free energy over beliefs with no weight where the joint weight is zero gives the core's share given the record, and such a belief exists only where the record weighs something.

**[AI reading, D45]** With this, perception in the principle's sense, the posterior reached by minimizing free energy, is the theory's conditioning by restriction: the core states the posterior by counting, the periphery characterizes it as the one minimizer of free energy among the beliefs where it is finite, and a theorem whose statement names the core's definitions joins them. What the principle adds to Bayes is the reading of a system's dynamics as descent on this quantity, which this module does not state.

## 2. The laws

The landing receipt is the checker's run on the merged head (§6); the drafting receipt `20261029T134610.999747Z` held the module before the review. After the review the module has 47 declarations, 42 theorems and 5 definitions, each depending only on Lean's standard axioms through Mathlib (`jointShare_part` on none). Names are in `Becoming.FreeEnergy`, except `Share.toReal` and its lemmas `Share.toReal_nonneg` and `Share.toReal_mul`, periphery declarations placed in the core's `ConditionalWeights.Share` namespace for dot notation; no core file changes.

1. **The quantities** over a finite set of causes `s`: `freeEnergy s q p = Σ q i · (log q i − log p i)`, `divergence s q r`, `surprisal P = −log P` and `posterior s p i = p i / Σ p` (Mathlib's `log 0 = 0` and `x / 0 = 0`; `surprisal 0 = 0`, where surprisal is usually infinite). The free energy is the divergence from the joint weights, whose total need not be one (`freeEnergy_eq_divergence`), and the `q`-average of `−log p` less the entropy of `q`, the energy less the entropy that gives it its name (`freeEnergy_eq_energy_sub_entropy`); it reads a belief only at the causes (`freeEnergy_congr`).
2. **The bound, Gibbs' inequality** (`surprisal_le_freeEnergy`): for `q` nonnegative with total one, `p` nonnegative and `q` zero wherever `p` is, `−log Σ p ≤ freeEnergy s q p`, the total of `p` then positive (`total_pos`); term by term from `log x ≤ x − 1` (`term_le`).
3. **Equality exactly at the posterior** (`freeEnergy_eq_surprisal_iff`, with `p` positive `freeEnergy_eq_surprisal_iff_of_pos`); at the posterior the free energy is the surprisal (`freeEnergy_posterior`), and among beliefs zero wherever `p` is the posterior alone has the least free energy (`minimizes_iff_posterior`). Off the support the bound fails under Mathlib's convention (`Witness.bound_fails_off_support`), where the free energy as usually defined is infinite: the minimization is over the beliefs where it is finite.
4. **Divergence from the posterior plus surprisal** (`freeEnergy_eq_divergence_add_surprisal`), with no sign hypothesis; the divergence is nonnegative and zero exactly at the posterior (`divergence_posterior_nonneg`, `divergence_posterior_eq_zero_iff`), and between any two distributions likewise (`divergence_nonneg`, `divergence_eq_zero_iff`).
5. **Complexity less accuracy** (`freeEnergy_eq_complexity_sub_accuracy`): where `p i = prior i · lik i` and `q` is zero wherever `p` is, the free energy is the divergence from the prior (the complexity, nonnegative where `q` and the prior are distributions) less the expected log-likelihood (the accuracy).
6. **The join to the core.** A share is read as part over whole (`Share.toReal`). In a core generative model (`pairWeight prior lik`, hypotheses listed without repetition, a record), the joint weight of a hypothesis is the share of the courses with that hypothesis whose record agrees (`jointShare_part`, `jointShare_toReal`); the joint weights sum to the record's share (`sum_jointShare`, through `evidence`); their posterior at each hypothesis is the core's share given the record (`givenShare_eq_posterior`, through `posterior_single`). So, for beliefs zero where a hypothesis's prior weight times the record's weight under it is zero, which exist only where the record weighs something (`record_pos_of_belief`), the bound and its equality hold in the core's terms (`record_surprisal_le_freeEnergy`, `freeEnergy_eq_record_surprisal_iff`), the free energy of the core's share given the record is the surprisal of the record's share (`freeEnergy_givenShare`, which keeps the record weighing something as a hypothesis: where it weighs nothing both sides are 0 by Mathlib's conventions), and that share alone has the least free energy among them (`minimizes_iff_givenShare`).
7. **Surprisal adds over independent parts** whose events each weigh something (`surprisal_product`, from the core's `share_product`), and the surprisal of a share is the logarithm of its reciprocal (`surprisal_eq_log_reciprocal`), as the core's `Share.reciprocal` orders.

## 3. What it shows, and what it does not

Shows:
- the principle's variational free energy, its bound on surprisal and the bound's equality at the posterior, as theorems of the theory, in the periphery;
- that exact minimization of free energy, over beliefs with no weight where the joint weight is zero, is the theory's conditioning by restriction, the core's share given a record, by a theorem whose statement names the core's definitions;
- the decompositions: divergence from the posterior plus surprisal, complexity less accuracy, energy less entropy.

Does not show:
- densities, continuous causes or continuous time;
- expected free energy (UE19);
- any process by which a system lowers its free energy (a gradient descent, message passing, the Laplace approximation): only what the least free energy is and where it is reached;
- beliefs confined to a family (mean-field, the Laplace approximation's Gaussian), whose least free energy exceeds the surprisal by the family's divergence from the posterior, a reading of `freeEnergy_eq_divergence_add_surprisal`, not a theorem here;
- free energy as a bound on the long-run average of surprisal, the entropy of sensory states, which carries the principle's reading of persisting;
- free energy over parameters and models, as in learning and model comparison;
- complexity and accuracy read from the core's own prior and likelihood shares;
- the bound's counting form: for beliefs with natural counts `n` (total `N`) against natural joint weights `a` (total `A`), `N^N·∏ a^n ≤ A^N·∏ n^n`, equal, where the record weighs something, exactly at the share given the record, needing no support condition (checked by the review on 15,968 small cases, not proved; a proof is the weighted inequality of arithmetic and geometric means on naturals);
- that any system minimizes free energy: the principle's existence claim is UE18's.

## 4. Readings

**[AI reading, D45] Perception as conditioning.** The principle reads perception as the minimization of variational free energy over beliefs, and the bound's equality says that the minimizer is the posterior. In the theory the posterior is conditioning by restriction: the weighting kept on the courses agreeing with a record. So the principle's perception, read exactly, adds no law to the theory's conditioning; it gives conditioning a variational form. What a variational form adds is approximation: a belief restricted to a family can reach only the least free energy within it, and the bound then measures how far it stops from the posterior. The module states the exact case; approximation within a family is a reading of `freeEnergy_eq_divergence_add_surprisal`, not a further theorem here.

**[AI reading, D45] Where the principle's weight lies.** The bound is mathematics, true of any belief and any joint. Its use in the principle rests on reading a system's internal states as parameterizing a belief and its dynamics as descent on free energy; that reading is the principle's, not this module's, and the theory's laws on what a selector can read (selection through couplings) and on what it reaches (the levels of closure) bear on it, as the plan's later items state.

## 5. Standing

Gibbs' inequality and its equality case are classical (Gibbs 1902), the divergence is Kullback and Leibler's (1951), and the variational bound is the evidence bound of variational Bayes: free energy as a bound on the log evidence appears in Hinton and van Camp (1993), Neal and Hinton (1998) and the Helmholtz machine (Dayan, Hinton, Neal and Zemel 1995), and as the principle's quantity in Friston (2005, 2010). The decompositions and the join are near-definitional. New is the join: the core states the posterior by counting, and the periphery characterizes it as the one minimizer of free energy among the beliefs where it is finite, from natural weights.

## 6. Counts, placement and checking

- **Counts.** 42 theorems in 47 declarations after the review (39 in 44 at the drafting receipt).
- **Placement.** In the periphery beside `regime/RegimeReals`: the real form needs Mathlib's logarithm, which the pure core does not have; for beliefs with natural counts the bound has a counting form, not stated here (§3). The module imports the core's `Becoming.ConditionalWeights`; the core does not import it. `jointShare_part`, about naturals only and with an empty axiom report, can move beside `posterior_single` at the next change of ConditionalWeights.
- **Name.** Board rule 8 names a correspondence module after its core law; the module is named for its laws of free energy instead, as `EntropyProduction` is, since what it states is free energy and its bound, not a correspondence of `ConditionalWeights` alone.
- **Checking.** `check_free_energy_reals.py` is `regime/check_regime_reals.py` with its target, receipt, run folder, scope, docstring and temporary folder's prefix changed: it compiles the core closure with the periphery's toolchain (Lean 4.30.0-rc2, the pinned Mathlib), requires every other module of the closure to match a passed core receipt, and reports each declaration's axioms, failing on any but Lean's three standard ones. The landing reruns it fresh on the merged head (`BECOMING_FRESH=1`); the drafting run reused 51 steps from a warm-up ([warm_closure.py](warm_closure.py), kept as the drafting record). The checker matches the closure to receipts by text search, as the regime checker does; binding name, path and digest as the core checker does is a change of its own for both periphery checkers.
- **Pending.** `ConditionalWeights`'s docstring still says that averages of logarithms have no reciprocal-share form and that free energy is drafted for the periphery with no receipt; it is brought to UE17 at that module's next change, with no core run for a docstring alone.
- **Record.** One record, homed in 03 after conditioning by restriction, saying the law is in the periphery until a core form lands.
- **Modelling.** A finite set of causes; real beliefs and joint weights; Boolean records and natural weights in the core; Mathlib's conventions for logarithm and division at zero.

## 7. Review

An independent read-only review by another AI agent ([REVIEW-UE17](REVIEW-UE17.md)) built the module and a probe of four theorems against the warmed core and the pinned Mathlib, with no error or warning, each on the three standard axioms, and checked the counting form of the bound on 15,968 small cases. It found the Lean sound, each docstring saying what its theorem proves, and the join real: the printed statements name the core's `share`, `restrict`, `pairWeight`, `openSteps`, `mass` and `Distinct`. Its twelve findings, every one taken except F12, which is a change of its own:
- **F1** the support condition, dropped from summaries, is restored in the module's docstring, the checker's scope, this note, the record and the texts;
- **F2** "no counting form" is withdrawn: the core states no average of logarithms, and the bound's counting form for beliefs with natural counts is named as not stated and as the record's next step;
- **F3** "one law in two forms" is withdrawn: the periphery characterizes the core's posterior as the minimizer; Gibbs' inequality is classical, the decompositions and the join near-definitional;
- **F4** the kit's axiom check now reads the receipt's `axiom_dependencies`;
- **F5** the landing reruns the checker fresh on the merged head, after UE16;
- **F6** `record_pos_of_belief` is added and `minimizes_iff_givenShare` no longer takes the record weighing something as a hypothesis;
- **F7** conditioning-by-restriction's next step, correspondence and third item of what it does not show are brought to UE17 with a history line saying so; ConditionalWeights's docstring is pending (§6); UE2's superseded periphery draft moves to history; FEP-INTEGRATION §2 is updated; DRAFT-NOTES is headed as the drafting record;
- **F8** restricted families, the long-run average of surprisal and free energy over parameters and models are named as not shown, and `freeEnergy_eq_energy_sub_entropy` is added;
- **F9** `Share.toReal_nonneg` and `Share.toReal_mul` sit beside `Share.toReal`, `freeEnergy_eq_divergence` states the one body, `minimizes_iff` is `minimizes_iff_posterior`, and the module's name is justified (§6);
- **F10** the conventions at zero are stated in the docstrings of `surprisal` and of complexity less accuracy;
- **F11** `warm_closure.py` is kept as the drafting record with a docstring saying how to run it, and the changed temporary folder's prefix is named;
- **F12** the periphery checkers' matching of the closure by text is left for a change of its own, the claim holding for this run.

The reviewer then re-checked the fold ([RECHECK-UE17](RECHECK-UE17.md)), building the folded module and a probe of all 47 declarations: the fold is sound and the Lean says what the folded texts claim. Its eight findings, every one taken: the record's statement now leads with the support condition (R1); the study section no longer says averages of logarithms need the reals (R2); the counting form's equality needs the record to weigh something and is named as the weighted inequality of means, unproved (R3); the complexity is nonnegative where `q` and the prior are distributions (R4); `record_pos_of_belief`'s title names the hypotheses ruled out (R5); the kit's docstring and the history say what changes and that there are three decompositions (R6); FEP-INTEGRATION's UE2 bullet is brought to UE17, UE2's draft moves to history at landing and the date is taken at run time (R7); long lines are wrapped, "gives" agrees, and the one minimizer is qualified as among the beliefs where the free energy is finite (R8).

## References

- Dayan, P., Hinton, G. E., Neal, R. M., and Zemel, R. S. (1995). The Helmholtz machine. Neural Computation 7, 889–904.
- Friston, K. (2005). A theory of cortical responses. Philosophical Transactions of the Royal Society B 360, 815–836.
- Friston, K. (2010). The free-energy principle: a unified brain theory? Nature Reviews Neuroscience 11, 127–138.
- Gibbs, J. W. (1902). Elementary Principles in Statistical Mechanics. Scribner.
- Hinton, G. E., and van Camp, D. (1993). Keeping the neural networks simple by minimizing the description length of the weights. Proceedings of COLT, 5–13.
- Kullback, S., and Leibler, R. A. (1951). On information and sufficiency. Annals of Mathematical Statistics 22, 79–86.
- Neal, R. M., and Hinton, G. E. (1998). A view of the EM algorithm that justifies incremental, sparse, and other variants. In Learning in Graphical Models, 355–368.
