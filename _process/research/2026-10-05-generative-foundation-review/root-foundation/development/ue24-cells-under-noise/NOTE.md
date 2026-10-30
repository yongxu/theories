# UE24: identical cells under noise, an exchangeable law stays exchangeable

Board item UE24, item 9 of the [plan for the principle as an integral part of the theory](../ue-unified-explanation/FEP-INTEGRATION.md). Claimed 30 October 2026. This note is AI-written.

## 1. What was missing

The core's law on identical cells ([identical-cells-under-a-descent-treating-them-alike](../../../../../../theories/becoming/results/records/identical-cells-under-a-descent-treating-them-alike.md), `Becoming.FreeEnergyGuarantees.IdenticalCells`, UE16) is a law of a deterministic descent. Every cell moves by one rule from its own state and a field read off the configuration, never off a cell's number. Cells alike at the start then stay alike, and with an exchangeable field the minima of a symmetric free energy come in exchanged pairs, a unique one with its cells alike. Its record says what it leaves out:

- noise: "independent fluctuations break the symmetry almost surely, and the law then does not apply";
- exchanges of other than neighbouring cells;
- as the next step, exchanges of any two cells.

The principle's page lists noise and random dynamical systems in §5, "under which the law on identical cells does not apply". The 2015 simulation the record reads against breaks the symmetry by random initial expectations. Without a law under noise the theory could say only that the deterministic law does not reach that simulation, not what holds of it. The principle's own stochastic ground, densities, Langevin flows and random dynamical systems, stays out of reach here; what UE24 states is the law for finite Markov chains on configurations.

## 2. What is proved

A new periphery module, `CellsUnderNoise`, on Mathlib's reals. It imports the core's `Becoming.FreeEnergyGuarantees` and changes no core file. There are finitely many cells `ι`, each with a state in a finite set `S`. Weights are a real number on each configuration `ι → S`; a law is weights that are nonnegative, of total one. A kernel `K c c'` is the weight of going from `c` to `c'`. One step takes `p` to `c' ↦ Σ_c p c · K c c'`, and `weightsAt K p n` is the weights after `n` steps under the kernel `K k` at step `k`. A rearrangement `σ`, a permutation of the cells, takes `c` to `c ∘ σ`.

**Exchangeable weights stay exchangeable.** A kernel commutes with `σ` (`KernelCommutes`) where rearranging both configurations by `σ` changes no weight. Such a kernel keeps all weights that `σ` leaves unchanged unchanged (`step_invariant`, `weightsAt_invariant`). So, under kernels each commuting with every rearrangement, an exchangeable start, weights no rearrangement changes, gives exchangeable weights at every step (`weightsAt_exchangeable`). Nonnegative kernels whose weights from each configuration total one keep a law a law (`step_nonneg`, `step_total`, `weightsAt_law`). Identical cells are exchangeable starts in two forms: all cells in one state (`alike_exchangeable`), and the cells independent and of one law (`independent_exchangeable`, `independent_law`).

**What exchangeable weights leave undecided.** Every cell has the weights of every other (`marginal_eq`). Where the weights are a law, each assignment of distinct states to the cells has weight at most one over the number of orderings of the cells (`distinct_le`), since its `(card ι)!` rearrangements are distinct configurations of one weight. The law of one configuration is unchanged by `σ` exactly where the configuration is (`pointMass_invariant_iff`), so it is exchangeable only with all its cells alike (`pointMass_exchangeable_alike`).

**Stationary weights.** Under a kernel commuting with `σ`, the rearrangement of stationary weights is stationary (`stationary_rearranged`). So, under a kernel commuting with every rearrangement, a stationary law that is the only one is exchangeable (`unique_stationary_exchangeable`). Gibbs weights `exp (-κ F)` normalized, for any real `κ`, of a free energy no rearrangement changes, are exchangeable (`gibbs_exchangeable`); no kernel is shown to keep them, and the statement is a fact of the definition.

**Noise after a rule.** Given a rule `f` on configurations and a law of noise `q s s'`, each cell goes, independently, from the state `f c i` the rule gives it to `s'` with weight `q (f c i) s'` (`noisy`). Where the rule commutes with `σ`, so does the rule with noise (`noisy_commutes`). With no noise (`noiseless`), the law of one configuration follows the rule's run (`step_noiseless`, `weightsAt_noiseless`).

**Joined to the core's descent.** A configuration of `m` cells is read as a list by `List.ofFn`.

- Exchanging neighbouring cells `k` and `k + 1`, the core's `exchangeAt`, is rearranging by the transposition of `k` and `k + 1` (`ofFn_swap`). These transpositions generate every rearrangement (Mathlib's `Perm.mclosure_swap_castSucc_succ`), so what no neighbouring exchange changes, no rearrangement changes (`ofFn_rearranged`). This closes the record's next step, exchanges of any two cells, in the periphery.
- The core's descent read cell by cell (`cellwise`) is the core's descent on the list (`ofFn_cellwise`), and its run read as a list is the core's run `Law.run` (`ofFn_iterate_cellwise`). So with no noise the law, from the law of one configuration, weighs one exactly the configuration the core's run reaches (`noiseless_run`). Read cell by cell, two cells alike at the start are alike at every step whatever the field (`cellwise_alike`), the core's never-parting law restated and proved directly.
- With an exchangeable field in the core's sense, the descent commutes with every rearrangement (`cellwise_commutes`), and the core's run from a rearranged start is the rearranged run (`run_rearranged`). A free energy symmetric in the core's sense, as the core's `freeEnergy` is at an exchangeable field, is unchanged by every rearrangement (`symmetric_rearranged`), and so are its Gibbs weights (`gibbs_symmetric_exchangeable`).

**The headline: the core's descent with noise.** Each cell, in state `x` and sensing the field `z` read from the configuration, goes to `s'` with weight `r x z s'`, the cells independently and the law `r` one for every cell (`noisyDescent`); noise in what the cell senses, independent across cells, is a case, and noise after the core's update is another (`noisy_eq_noisyDescent`). With an exchangeable field it commutes with every rearrangement (`noisyDescent_commutes`). So, under noise `r k` at step `k`, from an exchangeable start the weights are exchangeable at every step (`noisyDescent_exchangeable`), and every cell has the weights of every other (`marginal_eq`). Where the noise and the start are laws, each assignment of distinct states to the `m` cells has weight at most `1 / m!` at every step (`noisyDescent_distinct_le`), from all cells in one state and from the cells independent and of one law among others (`noisyDescent_from_alike`, `noisyDescent_from_independent`). From all cells in one state, some configuration of all cells alike has positive weight at every step (`alike_positive`), for any field and any noise changing in time: in finitely many states independent noise never parts identical cells with certainty. It can part them: with a fair coin of its own for each of two cells, they part after one step with weight one quarter (`Witness.independentNoise_parts`).

**Two cells** (`Witness`).

- A kernel taking every configuration to one of the two parted ones, each with weight one half (`toParted`), commutes with exchanging the cells (`toParted_commutes`). From either alike start it parts the cells with certainty, each parted configuration with weight one half (`alike_none`, `each_half`). It is the fair mixture of two rules, the one assigning cell `0` on and cell `1` off by the cells' numbers and its exchange, each with no noise (`toParted_eq_mixture`); neither rule commutes with the exchange (`assign_not_commutes`). Two alike cells reading one coin by one rule from one state stay alike, so a kernel that parts them with certainty must read their numbers somewhere. It is no noise of one law at every cell: the parted half and half is no product of one weighting per cell (`partedUniform_not_product`), so the kernel is neither a rule with such noise (`toParted_not_noisy`) nor the core's descent with it (`toParted_not_noisyDescent`). A law of total one is stationary under it exactly where it is the parted half and half (`toParted_stationary_iff`), exchangeable, here through the law on unique stationary laws (`partedUniform_exchangeable`; `parted_rearranged` gives it directly). Uniqueness of a law gives exchangeability, not alike cells, where the core's unique minimum has its cells alike.
- A field reading the state of the first cell (`firstCell`) reads no cell's number, yet reads the places through the order of the list, and is not exchangeable (`firstCell_not_exchangeable`). With each cell flipping by it and no noise, from the parted half and half, an exchangeable start, it gives cell `0` off and cell `1` on weight one, above one half, and the two cells different laws (`firstCell_assigns`). So a field reading no cell's number is not enough for the law under noise, which is proved for an exchangeable field; that exchangeability is necessary is not shown, and some fields that are not exchangeable still give a commuting descent (any field, where the update ignores it).

## 3. Hypotheses and modelling choices

The module states its laws under these choices:

- Finitely many cells and finitely many states per cell.
- Weights are real numbers, and a kernel is a function of two configurations, with no measurability.
- Steps are discrete and synchronous; the kernel may change from step to step.
- The noise is independent across cells and of one law, reading a cell's own state and the field it senses.
- The rearrangements are all permutations of the cells.

The headline needs a field exchangeable in the core's sense and an exchangeable start; the bound `1 / m!` needs in addition noise that is nonnegative with weights from each state and field totalling one, and a start that is a law. Each declaration depends on Lean's standard axioms at most, through Mathlib, and the checker reports each one's. Some depend on fewer: `cellwise`, `Witness.Two`, `Witness.firstCell` and `Witness.flipBy` on none; `rearrange` and `alike_fixed` on `Quot.sound`; `Witness.assign` and `Witness.firstCell_not_exchangeable` on `propext`; `ofFn_cellwise`, `ofFn_iterate_cellwise` and `cellwise_alike` on `propext` and `Quot.sound`. A core version of the last three would need proofs with an empty report (not attempted).

## 4. Boundary: what this does not show

- Densities, continuous states or time, or Langevin flows. In continuous states with a density, exact alikeness has probability zero after one step; here alike configurations keep positive weight (`alike_positive`).
- Whether a realization parts, or which place a given cell reaches. The law gives every rearrangement of an assignment one weight; it says nothing of a run.
- Which asymmetry actually differentiates cells: a gradient, a boundary, a cell's history.
- That a given kernel has a stationary law, a unique one, or one approached at any rate; or that any kernel keeps the Gibbs weights.
- That exchangeability of the field is necessary for the law under noise; it is proved sufficient.
- That the 2015 paper's simulation fails or is modelled here. Its scheme has the law's form (§5), and no theorem here models it.
- Which configuration, differentiated or not, is better.

## 5. Standing

That a symmetric cause gives a symmetric effect is Curie's principle (Curie 1894; Chalmers 1970, British Journal for the Philosophy of Science 21(2): 133–148). Its form for indeterministic laws, a symmetric cause giving a symmetric distribution of effects, is in Ismael 1997 (Synthese 110(2): 167–190) and Castellani and Ismael 2016 (Philosophy of Science 83(5): 1002–1013). That a symmetry the law keeps is broken only in realizations is spontaneous symmetry breaking (Earman 2004, International Studies in the Philosophy of Science 18(2–3): 173–198). That no deterministic rule treating anonymous processors alike singles one out is Angluin's (1980); that independent coins, one for each processor, break the symmetry with probability one, never with certainty within a bounded number of steps, is the randomized answer (Itai and Rodeh, FOCS 1981; Information and Computation 88(1): 60–87, 1990), of which `alike_positive` is the part on certainty.

The laws over kernels are classical: an equivariant Markov kernel keeps an invariant law invariant; a unique invariant law of an equivariant kernel is invariant; an exchangeable law has equal marginals; and the bound `1 / m!` is one over the size of an orbit. New, in the principle's terms, are the join to the core's descent (its exchange of neighbouring cells, which generates every rearrangement; its run, which is the noiseless law's; its field, whose exchangeability the law under noise is proved for) and the reading against the principle's identical cells.

**Against the 2015 paper.** The review read the published scheme (Friston, Levin, Sengupta and Pezzulo 2015, Journal of the Royal Society Interface 12: 20141383) and its SPM implementation (`DEM_morphogenesis.m`). Each cell's initial expectations are independent and of one law, the signal is symmetric in the cells, the noise is small and independent across cells, and the seed is fixed. The scheme has the law's form. The paper never claims which cell takes which place: its confusion matrix reorders the cells' columns. So the law forbids nothing of the paper, and the principle's page stays at four forbidden statements.

**Reading** [AI reading, D45]. "Knowing one's place", read as the scheme deciding which place a given cell takes, fails for every exchangeable scheme: the law gives each rearrangement of the outcome one weight, and chance decides, the start's and the noise's. Read as each cell inferring which place it has reached, it stands, as the 2015 simulation shows. The field reading the first cell also shows that the core's wording "never a cell's number" is loose: a field reading the configuration as a list can read the cells' places through its order, and the core's exchangeable field is what rules that out.

**Classification** (REVIEW-UE24 F15, RECHECK-UE24 §4; 76 declarations, 57 theorems and 19 definitions).

- Results, all known in substance: `step_invariant` with `weightsAt_invariant` (one law), `marginal_eq`, `distinct_le`, `stationary_rearranged`, `unique_stationary_exchangeable`, `noisy_commutes`, `weightsAt_noiseless`, and `alike_positive`, new as stated.
- Joins: `ofFn_swap`, `ofFn_rearranged`, `ofFn_cellwise`, `ofFn_iterate_cellwise`, `noiseless_run`, `cellwise_commutes`, `run_rearranged`, `cellwise_alike`, and `noisyDescent_commutes` with the headline `noisyDescent_exchangeable` (one join law).
- Instances: `weightsAt_exchangeable`, `alike_exchangeable`, `pointMass_exchangeable_alike`, `symmetric_rearranged`, `gibbs_symmetric_exchangeable`, `noisyDescent_distinct_le`, `noisyDescent_from_alike`, `noisyDescent_from_independent`.
- Facts of a definition: `gibbs_exchangeable`, `independent_exchangeable`, `independent_law`, `alike_fixed`, `pointMass_invariant_iff`, `pointMass_law`, `noisy_eq_noisyDescent`.
- Helpers: `step_nonneg`, `step_total`, `weightsAt_law`, `noisyDescent_nonneg`, `noisyDescent_rows`, `step_noiseless`, `Witness.sum_two`, `Witness.parted_rearranged`, `Witness.partedUniform_law`.
- Witnesses: `Witness.independentNoise_parts`; `Witness.partedUniform_not_product`, `Witness.toParted_commutes`, `Witness.toParted_not_noisy`, `Witness.toParted_not_noisyDescent`, `Witness.toParted_once`, `Witness.alike_none`, `Witness.each_half`, `Witness.toParted_stationary_iff`, `Witness.toParted_eq_mixture`, `Witness.assign_not_commutes`, `Witness.partedUniform_exchangeable` (a model of `unique_stationary_exchangeable`); `Witness.firstCell_not_exchangeable`, `Witness.firstCell_assigns`.
- Definitions: `rearrange`, `Invariant`, `Exchangeable`, `KernelCommutes`, `step`, `weightsAt`, `pointMass`, `marginal`, `Stationary`, `noisy`, `noiseless`, `cellwise`, `noisyDescent`, `Witness.Two`, `Witness.partedUniform`, `Witness.toParted`, `Witness.assign`, `Witness.firstCell`, `Witness.flipBy`.

## 6. Review

An independent adversarial review by an AI agent ([REVIEW-UE24](REVIEW-UE24.md)) compiled the first draft (54 declarations) with four probe files and found no Lean error, and five overclaims, five gaps and seven minor points. Every one was taken in round 2:

- F1: the deterministic law had been called the case with no noise, while the draft recovered only the core's commuting law, by a detour. That theorem is dropped; the core's run is the noiseless law's (`noiseless_run`), and the never-parting law holds cell by cell (`cellwise_alike`).
- F2: the two-cell witness was no noise of one law at every cell, and under that noise parting is never certain. Both are now theorems (`toParted_not_noisy`, `toParted_not_noisyDescent`, `alike_positive`), and the header says independent fluctuations can part alike cells.
- F3: the headline dropped the exchangeability it proved; `noisyDescent_exchangeable` is now the headline, and the bound is stated apart with its hypotheses.
- F4: the independent start of the 2015 simulation has its corollary (`independent_law`, `noisyDescent_from_independent`).
- F5: a field reading the first cell assigns the places from an exchangeable start (`firstCell_assigns`), and the header says the hypothesis on the field changed.
- F6: the Gibbs weights are no longer called the steady-state form; no kernel is shown to keep them.
- F7: the citations for the probabilistic form are Ismael's and Earman's.
- F8: the claim row is reworded at landing.
- F9: the run from a rearranged start is the rearranged run (`run_rearranged`).
- F10: the noise reads the cell's own state and the field it senses (`noisyDescent`), and the kernel may change from step to step.
- F11: the law of one configuration is exchangeable only with its cells alike (`pointMass_exchangeable_alike`).
- F12: the law on unique stationary laws has a model (`partedUniform_exchangeable`).
- F13 and F14: the names `drawn`, `exact`, `part`, `halves` and `cue` are gone.
- F15 to F17: the classification (§5) and the record's contents follow the review.

## 7. Recheck

A second AI agent rechecked round 2 against the review ([RECHECK-UE24](RECHECK-UE24.md)): every finding answered in the module, the Lean sound, and a dozen points in the wording. Every one was taken in round 3:

1. The two-cell kernel had been called a common coin both cells read. Two alike cells reading one coin by one rule from one state stay alike, so the kernel parts them only by reading their numbers: it is the fair mixture of the rule assigning the places by the cells' numbers and its exchange, now proved (`toParted_eq_mixture`, `assign_not_commutes`), and renamed `toParted`. The randomized answer to symmetric choice had been credited to Angluin, whose result is the deterministic impossibility; it is Itai and Rodeh's, with each processor's own coin, and `alike_positive` is its part on certainty.
2. Exchangeability of the field had been called necessary; only its sufficiency is proved, with one counterexample field. The header and the docstring say so, and the witness is renamed `firstCell_assigns`.
3. The sentence on axioms is exact (§3).
4. "Drawn" in the sense of sampling is gone: the cells are independent and of one law.
5. The bound's docstring states its hypotheses and no longer says "left to the fluctuations", which stays a labelled reading.
6. `gibbs_symmetric_exchangeable` reads any free energy symmetric in the core's sense, not the core's `freeEnergy` only.
7. The witness section's title says independent noise does not part with certainty.
8. `alike_keeps_weight` is `alike_positive`: the alike configuration with positive weight changes with the step.
9. Noise in what the cell senses is a case where it is independent across cells.
10. Weights and laws are told apart: `lawAt` is `weightsAt`, and "law" means nonnegative of total one where it is assumed.
11. `noisy_eq_noisyDescent` drops an unused hypothesis; `cellwise_alike` is introduced as read cell by cell; a witness shows independent noise parting alike cells (`independentNoise_parts`); the commuting hypothesis is in the header's bullet on stationary weights; the citation of Ismael is exact.
12. Nothing needed was weakened; `partedUniform_exchangeable` says it is a model of the law on unique stationary laws by its proof.

Round 3 has 76 declarations, compiles with no error or warning, and each declaration depends on Lean's standard axioms at most.
