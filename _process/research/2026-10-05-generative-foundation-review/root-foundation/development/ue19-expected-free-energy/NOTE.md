# UE19: expected free energy within a lumping

29 October 2026. AI-written note for board item UE19, item 4 of the plan for the free-energy principle as an integral part of the theory ([FEP-INTEGRATION](../ue-unified-explanation/FEP-INTEGRATION.md)), with a pure-core module `Becoming.LumpedSeeking` ([tree](tree/Becoming/LumpedSeeking.lean)) and a periphery module `ExpectedFreeEnergyReals` ([draft](periphery/ExpectedFreeEnergyReals.lean)), to sit in `lean/free-energy/` beside UE17's. Revised after an independent review and a re-check (§6).

## 1. Summary

Active inference scores a policy by its expected free energy: risk, the divergence of the outcomes the policy predicts from the preferred ones, plus ambiguity, the expected entropy of the likelihood; equivalently, the negative of its epistemic value, the information its outcomes carry about hidden states, less its pragmatic value, the expected log preference (Parr and Friston 2019, whose definitions these are; Friston, Rigoli, Ognibene, Mathys, FitzGerald and Pezzulo 2015). In the principle's T-maze the likelihood at the centre ties the two contexts and the likelihood at the cue separates them, so the epistemic term takes the agent to the cue: seeking corrects. One proposal reads the term as inherent self-verification and self-correction (Wen 2025; UE1's candidate 7, graded (b), weak). This item states the quantity and its forms in the theory, and what seeking cannot correct:
- **The forms** (periphery). Risk plus ambiguity is the negative of epistemic value less pragmatic value, with no hypothesis; the epistemic value is a divergence, hence nonnegative, and the expected information gain, the predicted outcomes' average of the divergence of UE17's posterior from the states' weights, the quantity Wen's proposal names.
- **Expected free energy reads the states only through the lumping its likelihood makes** (periphery). Where the likelihood reads a state only through its class, the epistemic value and the expected free energy are the classes', so two beliefs alike on the classes score every such policy alike: no choice by expected free energy turns on how weight is split within a class. Two states of one likelihood keep their prior ratio in UE17's posterior under every outcome.
- **What no seeking separates** (pure core, counting form). Hypotheses every experiment ties keep their prior order under every course of seeking, however each experiment is chosen from the course so far, since the choice weights read only the course; so seeking does not correct an error every experiment ties, whatever the policy of choice. In a witness a model reading only whether two tosses agree turns the wrong order it separates and keeps the wrong order it ties, under one record; and seeking draws the same line: with only that experiment a course of two heads keeps the wrong order, while with an experiment reading both tosses chosen the same outcome turns it.

**[AI reading, D45]** Seeking information within a model separates only what some experiment it can choose separates: the epistemic drive corrects within its hypothesis space, under the policies it has, not beyond. What changes a lumping is what couples in from beyond the model, a new likelihood or a new hypothesis, as the theory's laws of registration revision state ([03 §8](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-selection-under-registration-revision)); the principle's own literature adds novelty and structure learning for this reason (Da Costa and others 2020; Friston, Lin, Frith, Pezzulo, Hobson and Ondobaka 2017), both conditioning in a larger model, whose ties the law covers too. So the third part forbids the unqualified wording of inherent self-correction, not active inference's account.

## 2. The laws

### Pure core: `Becoming.LumpedSeeking` (14 theorems in 27 declarations, every axiom report empty; [scratch-7.log](scratch-7.log))

- `Tied lik h₁ h₂`: one likelihood's weights agree on two hypotheses at every record value; every record weighs alike under them (`tied_mass`), the pointwise form of `Relabel.EquivariantValue.tied`.
- `single_le_evidence`, `posterior_le_iff_prior`, `posterior_ratio_kept`: given a record weighing something under a tied pair, the pair compares, and stands, as its prior weights do (from `posterior_le_iff` and `posterior_single`; where the record weighs nothing in the whole, the first hypothesis's prior weight is nothing and both sides hold).
- `order_kept`: where the prior weighs the false hypothesis of a tied pair above the true one, every record weighing something under them leaves it above.
- `seekWeight`, `seek_tied`, `seeking_keeps_order`: a course of seeking weighs, at each step, the weight of choosing the experiment, read from the course so far, times the outcome's weight under it; a pair tied under every experiment is tied over every course, and seeking keeps its wrong order whatever the policy of choice.
- `Agree`: three hypotheses (biased toward heads, true; fair; biased toward tails), prior weights 5, 6 and 7; the model reading only whether two tosses agree ties the biases (`ties`), its weights totalling sixteen under each (`totals`); given two heads the true coin comes above the fair one (`turns_fair`) and the tails-biased one stays above it (`keeps_tails`).
- `agreeCourse`, `seeking_keeps_tails`; `readBoth`, `experiment`, `pickReading`, `readCourse`, `seeking_turns_tails`: with only the experiment reading agreement, a course of two heads keeps the tails-biased coin above the true one (`seeking_keeps_order` in the witness); with two experiments, reading both tosses or only their agreement, and a policy choosing the first, the same outcome turns that order.

### Periphery: `ExpectedFreeEnergyReals` (on Mathlib's reals, importing `FreeEnergyReals`; 21 declarations, each on Lean's three standard axioms, [probe-3.log](periphery/probe-3.log))

- `predicted`, `risk` (by UE17's `divergence`), `ambiguity`, `expectedFreeEnergy`, `pragmatic`, `epistemic`; `expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic`, with no hypothesis.
- `joint`, `product`, `epistemic_eq_divergence`, `epistemic_nonneg`: the epistemic value is the divergence of the joint from the product of the states' weights and the predicted outcomes, a product of the joint's marginals where each likelihood totals one, nonnegative where they are distributions.
- `gain_term`, `epistemic_eq_expected_gain`: the expected information gain, through UE17's `posterior`.
- `coarse`, `sum_through`, `predicted_through`, `epistemic_through`, `expectedFreeEnergy_through`, `expectedFreeEnergy_same_of_coarse`: through the lumping the likelihood makes.
- `epistemic_eq_zero_of_lumped`, `posterior_ratio_of_lumped`: one likelihood for every state reached gives nothing to learn; two states of one likelihood keep their prior ratio in UE17's `posterior`.

## 3. What it shows, and what it does not

Shows:
- the principle's expected free energy, both its decompositions and the information-gain form as theorems of the theory, in the periphery, beside UE17's free energy;
- that expected free energy, and so any choice by it, reads beliefs only through the classes its likelihood ties;
- in counting form in the pure core, with the choice of experiment read from the course, that no seeking separates a pair every experiment ties, and, in the witness, that seeking separates the same pair once an experiment separating it is chosen.

Does not show:
- the softmax over policies, precision, multi-step policies with transitions (a many-step form with lumpable transitions, Kemeny and Snell 1960, is not stated), learning of the likelihood, novelty terms, or any process by which an agent reaches its choice;
- that seeking never corrects: within what some experiment separates it can (`Agree.turns_fair`; the T-maze);
- the core and periphery halves joined by a theorem (through UE17's `givenShare_eq_posterior`): the periphery's ratio law is stated on UE17's posterior, the core's on the core's share given the record;
- the data-processing bound, that a policy's epistemic value is at least its classes', the excess being what it tells about the split within a class;
- that actual agents' likelihoods tie what matters, or that Wen's proposal fails as a design.

## 4. Standing and refutation

- **Decompositions and the gain form.** Known identities (Parr and Friston 2019); near-definitional. With Mathlib's `log 0 = 0`, risk and pragmatic value are finite where the predicted outcomes weigh an outcome of preference nothing, though infinite as usually defined; the identity holds between these values.
- **Through the lumping.** Near-definitional; new here in the principle's terms.
- **Tied pairs and seeking.** Identification (Rothenberg 1971) in its Bayesian form (Poirier 1998); the posterior laws are corollaries of `posterior_single` and `posterior_le_iff`; new is the seeking form, the choice of experiment read from the course. Refuted by a pair every experiment ties that some course of seeking separates, which would mean a likelihood differing somewhere.
- **The third part.** Against candidate 7, graded (b), weak: it forbids the unqualified wording of inherent self-correction (Wen 2025, §2), whose own text concedes that its predictions remain hypothetical (§4), not active inference's account, which adds novelty and structure learning.

## 5. Placement

- **Core.** `Becoming.LumpedSeeking`, a leaf importing `Becoming.ConditionalWeights` (L1). One record, *what seeking cannot separate*, homed in 03 §6.
- **Periphery.** `lean/free-energy/ExpectedFreeEnergyReals.lean` with its checker in the pattern of `check_free_energy_reals.py`, after UE17 lands. One record, *expected free energy and its terms*, homed in 03 §6 after free-energy-bounds-surprisal.
- **Modelling.** Natural weights, listed hypotheses and records, exact posteriors and a fixed pointwise tie in the core; finite states and outcomes, real distributions, risk over outcomes and Mathlib's conventions at zero in the periphery; one step, one policy, its predicted state distribution given; no transitions.

## 6. Review

An independent read-only review by another AI agent ([REVIEW-UE19](REVIEW-UE19.md)) rebuilt both modules with probes (core 9 theorems in 14 declarations, empty; periphery 10 declarations on the standard axioms) and checked the citations at their sources. It found the Lean sound and the identities as stated, and the text saying more than the Lean in four places. Its eleven findings, every one taken:
- **F1** the reading "no outcome sought separates" was false of the T-maze; the law is now that what every experiment ties no seeking separates, with seeking formalized, the experiment chosen from the course so far (`seekWeight`, `seek_tied`, `seeking_keeps_order`), and the T-maze cited as the case where seeking corrects;
- **F2** "nothing to learn on what the likelihood lumps" now has its general form: expected free energy reads beliefs only through the classes (`epistemic_through`, `expectedFreeEnergy_through`, `expectedFreeEnergy_same_of_coarse`);
- **F3** the core's posterior laws are graded as corollaries of landed laws, the new part being the seeking form; the readings are labelled; the parent law is selection through a model of the options, generalization through a lumping only an analogy;
- **F4** each source is cited for what it states (Parr and Friston 2019 for the definitions; Da Costa and others 2020 take risk over states), Wen's name and version corrected, "structure learning" dropped for Wen;
- **F5** the information-gain form is added (`epistemic_eq_expected_gain`);
- **F6** the conventions at zero and the product's marginals are stated;
- **F7** the witness is the review's three-coin model (`Agree`), turning one wrong order and keeping another under one record;
- **F8** `order_kept` no longer takes the record's whole weight as a hypothesis (`single_le_evidence`);
- **F9** `Lumped` is `Tied` (it clashed with `Learning.Lumped` in the record's home), `error_kept` is `order_kept`, `efe` is `expectedFreeEnergy`;
- **F10** the third part is placed honestly: it forbids the unqualified wording, not active inference's account;
- **F11** the join through UE17's posterior, the many-step form and the data-processing bound are named as not stated (§3), the periphery's ratio law stated on UE17's `posterior`.

The reviewer then re-checked the fold ([RECHECK-UE19](RECHECK-UE19.md)), rebuilding both modules (core 12 theorems in 20 declarations, empty; periphery 21 declarations on the standard axioms) with a probe of 3 theorems in 8 declarations, every report empty. Every finding was folded soundly. Its five findings, every one taken:
- **R1** the data-processing bound was said to be named in §3 and was not; it is now;
- **R2** the periphery's header no longer reads as joining the halves: the counting form is stated in `Becoming.LumpedSeeking`, and no theorem there joins the two;
- **R3** the docstrings of `risk` and `pragmatic` carry the conventions at zero;
- **R4** `posterior_le_iff_prior` no longer takes the record's whole weight as positive: where it weighs nothing, `single_le_evidence` makes the first prior weight nothing and both sides hold (the probe's proof);
- **R5** the contrast is stated in the seeking form, in the witness: with only the experiment reading agreement, seeking keeps the wrong order (`seeking_keeps_tails`, the probe's instance), and with an experiment reading both tosses chosen, the same outcome turns it (`seeking_turns_tails`, the probe's `seeking_corrects`).

The module went from 12 theorems in 20 declarations to 14 in 27 ([scratch-7.log](scratch-7.log)); the periphery changed in docstrings only ([probe-3.log](periphery/probe-3.log)).

## References

- Da Costa, L., Parr, T., Sajid, N., Veselic, S., Neacsu, V., and Friston, K. (2020). Active inference on discrete state-spaces: a synthesis. Journal of Mathematical Psychology 99, 102447.
- Friston, K., Lin, M., Frith, C. D., Pezzulo, G., Hobson, J. A., and Ondobaka, S. (2017). Active inference, curiosity and insight. Neural Computation 29, 2633–2683.
- Friston, K., Rigoli, F., Ognibene, D., Mathys, C., FitzGerald, T., and Pezzulo, G. (2015). Active inference and epistemic value. Cognitive Neuroscience 6, 187–214.
- Kemeny, J. G., and Snell, J. L. (1960). Finite Markov Chains. Van Nostrand.
- Parr, T., and Friston, K. J. (2019). Generalised free energy and active inference. Biological Cybernetics 113, 495–513.
- Poirier, D. J. (1998). Revising beliefs in nonidentified models. Econometric Theory 14, 483–509.
- Rothenberg, T. J. (1971). Identification in parametric models. Econometrica 39, 577–591.
- Wen, B. (2025). A framework for inherently safer AGI through language-mediated active inference. arXiv:2508.05766, v1.
