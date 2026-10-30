# UE23: seeking by expected free energy, joined to the core's seeking law

Board item UE23, item 8 of the [plan for the principle as an integral part of the theory](../ue-unified-explanation/FEP-INTEGRATION.md). Claimed 30 October 2026. This note is AI-written.

## 1. What was missing

Two results stood side by side:

- **The core's seeking law** ([what-seeking-cannot-separate](../../../../../../theories/becoming/results/records/what-seeking-cannot-separate.md), `Becoming.LumpedSeeking`, pure core). A course of seeking is a list of experiments and outcomes, each experiment chosen with a natural weight read from the course so far (`seekWeight`). Where every experiment ties two hypotheses, their prior order survives every record of courses, whatever the policy of choice (`seeking_keeps_order`).
- **The periphery's expected free energy** ([expected-free-energy-and-its-terms](../../../../../../theories/becoming/results/records/expected-free-energy-and-its-terms.md), `ExpectedFreeEnergyReals`, Mathlib's reals). One step, one policy: risk plus ambiguity, the epistemic value an information gain. Where the likelihood reads states only through classes, the expected free energy is the classes' (`expectedFreeEnergy_same_of_coarse`).

Both records named the theorem joining them as missing: does_not_show "a theorem joining it to the periphery's expected free energy through the share given the record", and next_delta "the join … through givenShare_eq_posterior". The principle's page lists it in §5. Without it, the core's law is about an abstract policy of choice and the periphery's about a single step. The agent active inference describes (Bayesian belief, choice by expected free energy, over many steps) was in neither.

## 2. What is proved

There is a new section of `ExpectedFreeEnergyReals`, which now imports `Becoming.LumpedSeeking`. It has 47 new declarations: 37 theorems and 10 definitions. The module goes from 12 theorems in 21 declarations to 49 in 68. Counted by role, the 37 theorems are 11 results, 6 instances, 13 helpers, 1 fact about a definition and 6 witnesses (3 of them helpers to the other 3); the lists below mark each. A result whose proof is one application of another theorem at a particular argument counts as an instance.

**Definitions.**
- `courseLik`: a course's likelihood under a state, the product of the outcome likelihoods, latest step first as in `seekWeight`.
- `choiceWeight`: the product of the choice weights along a course.
- `coursePosterior`: the posterior after a course, UE17's `posterior` of the prior times the course's likelihood. The name keeps UE17's distinction: a belief is any candidate distribution, the posterior the one of least free energy.
- `courseWeight`: the predictive weight of a course, the agent's own: the choice weights along it times the prior's average of its likelihood. It is not the course's weight under the true state.
- `efeChoice`: a rule reading the experiments' expected free energies at the posterior after the course so far, giving each experiment a weight of any type. The rule may read the experiment too.
- `softmax`: the exponential of `-γ` times each experiment's value over the sum over all the experiments (a finite type). Its weights are positive (`softmax_pos`, a helper) and total one (`sum_softmax`, a fact about the definition, used by no proof).

**(1) The posterior after a course.**
- `coursePosterior_minimizes` (instance: UE17's `minimizes_iff_posterior` at the course's joint weights): with a nonnegative prior and likelihoods, among beliefs over the states that are nonnegative, total one and are zero wherever the joint weights are, a belief has the least free energy against the joint weights exactly where it is the posterior after the course on the states. Without the condition of zero the claim fails under Mathlib's `log 0 = 0` (the review's F1). Where the course weighs nothing under the prior, no belief zero wherever the joint weights are totals one, so the posterior is the one of least free energy only where the course weighs something.
- `posterior_choice_eq_coursePosterior` (result): for any real choice weights reading the course, the posterior of the prior times the choice weights along the course times its likelihood is the posterior after the course, where the choice weights along it are not zero. Where they are zero, the posterior of the joint weights is 0.
- `coursePosterior_rescale` (instance: the previous result at constant choice weights, through `courseLik_rescale` and `choiceWeight_ne_zero`, helpers): scaling each experiment's likelihood by a nonzero factor leaves the posterior after every course unchanged.

**(2) The join.**
- `givenCourse_eq_coursePosterior` (result): in the core's generative model of seeking, with the hypotheses listed once, the share of a listed hypothesis given the record that the course was `c`, a listed course, is, as a real number, the posterior after `c`. This holds where the choice weights along `c` are not zero; they are the same under every hypothesis and drop out, and so does the number of times `c` is listed (through `cast_seekWeight` and `mass_count`, helpers).
- `unchosen_share_zero` (helper): where the choice weights along a course are zero, the share of every listed hypothesis given it is 0.
- `Witness.unchosen_course` (witness): in the coin, the policy choosing the experiment reading both tosses never chooses two heads read by agreement; the share given that course is 0 while the posterior after it is not.
- `givenCourse_le_iff` (result): for two listed hypotheses, tied or not, the core's order of their shares given a chosen course, by cross-multiplication, is the order of the posterior after it (through `share_le_iff_toReal_le`, a helper: the core's order of two shares under one weighting is their order as real numbers). Where the agent's model is the core's, the two orders are one.

**(3) Choice by expected free energy with natural weights is among the core's policies (an instance).** `efeChoice` reads only the course, the prior and the model being fixed, so with natural weights it is a function from courses to weights of experiments, which is what a policy of the core's is. `efe_seeking_keeps_order` is `LumpedSeeking.seeking_keeps_order` at that policy, for any rule with natural weights, any preferences and any real model the expected free energies are computed in. Nothing about expected free energy is used, the agent's model need not be the core's, and the proof uses no join. A real-valued rule, the softmax or a habit rule `σ(ln E − γG)`, is not one of the core's policies; (4) covers it over the reals.

**(4) Over the reals.**
- `coursePosterior_ratio_kept` (result): two states every experiment ties keep their prior ratio in the posterior after every course.
- `coursePosterior_order_kept` (result): they keep their strict order where the course is possible under them (its likelihood under them positive) and its total weight under the prior is positive. Where the course is impossible under the pair, both posteriors are 0.
- Through `posterior_choice_eq_coursePosterior`, both hold of the posterior of the joint weights under every policy whose choices along the course weigh something. The softmax weighs every course something (`softmax_choiceWeight_pos`, a helper), and `softmax_order_kept` (instance) states the strict order under it.

**(5) Through the lumping.** Suppose every experiment's likelihood reads a state only through its class (`L e s = B e (π s)`).
- `coarse_coursePosterior` (result): conditioning commutes with the lumping. The posterior after every course, summed over a class, is the classes' posterior after the course from the classes' prior weights.
- `efe_through_course`, `epistemic_through_course` (results): so at every step every experiment's expected free energy and epistemic value are the classes'.
- `courseWeight_through` (result): every course's predictive weight is the classes', under any policy.
- `efeChoice_same_of_coarse` (result): two priors alike on the classes choose alike at every course, under every rule of any value type.
- `seeking_blind_to_split` (result): for real-valued rules, they also give every course one predictive weight and one weight under every state (the choice weights along the course times its likelihood there).
- `softmax_blind_to_split` (instance): the softmax case.

**(6) For any likelihoods.** `seeking_reads_profiles` (instance: `seeking_blind_to_split` at the lumping every set of likelihoods makes) takes as a state's class its likelihood profile `fun e => L e s` (classical decidable equality on profiles). Seeking by expected free energy then reads the prior only through the weight it gives each profile. What no experiment tells apart, no course of seeking by expected free energy tells apart, in its choices or in its predictive weights. No lumping hypothesis is needed.

**(7) Witnesses**, in the coin of `Becoming.LumpedSeeking` over the reals.
- `Witness.separating_turns`: after two heads read by the experiment reading both tosses, the posterior puts the true heads-biased coin above the tails-biased one; in the model whose only experiment reads whether the tosses agree, the tails-biased coin stays above after every course (through `agreeing_pos`, a helper). An outcome of a separating experiment can turn the posterior; not every outcome does (after two tails the tails-biased coin stays above, 63 against 5).
- `Witness.split_unseen`: the blindness bites. With two experiments, one reading agreement and one telling nothing (`agreeOrNothing`), the coin's prior (5, 6, 7) and the prior with the two biases' weights exchanged (7, 6, 5) are alike on the classes the experiments make (the fair coin; the two biases). After two heads read by agreement their posteriors weigh the heads-biased coin differently (25 and 35 in 84), while for every rule reading the two experiments' expected free energies, every set of outcomes and every preference, they give both experiments the same weights at every course and give every course one predictive weight (through `agreeOrNothing_through` and `priors_alike`, helpers).

**Helpers** (13): `courseLik_nonneg`, `courseLik_pos`, `choiceWeight_ne_zero`, `courseLik_rescale`, `softmax_pos`, `softmax_choiceWeight_pos`, `cast_seekWeight`, `mass_count`, `unchosen_share_zero`, `share_le_iff_toReal_le`, `courseLik_tied`, `courseLik_through`, `coarse_div`.

## 3. Hypotheses and modelling choices

- **Periphery.** Mathlib's reals; each declaration on Lean's three standard axioms at most, as the checker reports. `seeking_reads_profiles` uses classical decidable equality on likelihood profiles.
- **Finite sets.** States, outcomes and (for the softmax) experiments are finite.
- **Fixed state and preferences.** The hidden state stays fixed over a course: no transitions. The preferences are the same for every experiment.
- **What a policy is.** A policy is one experiment. A rule reads the experiments' expected free energies and may read the experiment itself, so a fixed habit is among the rules (in active inference the policy prior is `σ(-γG)`, or with habits `σ(ln E − γG)`). With one-step policies and a fixed state the free energy of the past is the same under every policy, so it drops out of the policy posterior `σ(ln E − F − γG)`. Not covered: habits learned from the course, precision inferred as a belief, policies of many steps.
- **The join theorems.** These take natural prior, likelihood and choice weights, as in the core. `givenCourse_eq_coursePosterior` needs the hypotheses listed once, the hypothesis and the course listed, and the course's choice weights not zero; the courses may be listed any number of times. Listing a hypothesis twice breaks it: with the hypotheses `[heads, heads, tails]` under the agreement experiment, after two heads, the share of the heads-biased coin is 50/85 against a posterior of 25/60.
- **Natural weights and probabilities.** With natural weights the expected free energy is computed on the cast weights. Where every state's weights under an experiment total `N_e` and the belief totals one, the logarithms of `N_e` cancel between risk and ambiguity and the value is `N_e` times the principle's expected free energy of the normalized likelihood, so an argmin over cast values can order experiments of different totals otherwise than the principle does (the review's F7 gives a case). The principle's choice is the rule reading `G e / N_e`, and `efe_seeking_keeps_order` takes any real model the expected free energies are computed in. The posterior does not read each experiment's scale (`coursePosterior_rescale`). The prior weights read as prior probabilities only where the likelihood totals agree (the core's `prior_share`).
- **Homes.** `mass_count` and `share_le_iff_toReal_le` are about the core's `mass` and `Share`; their home is beside `Share.toReal` in `FreeEnergyReals`, unchanged here so that its receipt stands. Moving them there changes their full names, which the second law of the record of expected free energy cites, so that move repoints the law.
- **Conventions.** Mathlib's `x / 0 = 0` and `log 0 = 0`.

## 4. Boundary: what this does not show

- **Whether, or how often, an agent choosing by expected free energy chooses a separating experiment.** It turns on the preferences, the posterior and the experiments' information. Under the softmax every experiment has some weight, so a separating experiment is chosen with some weight whatever the preferences, and only how often turns on them. Under an argmin rule with flat preferences the expected free energy is the negative epistemic value plus `log |O|`, and an experiment that separates nothing that matters can carry more information than one that does. No witness computes a choice by expected free energy.
- **Policies of many steps with transitions,** precision as a belief, habits learned from the course, or learning of the likelihood, novelty and structure learning. In the principle's literature, these change which states are tied; in this account that is conditioning in a larger model, with its own ties.
- **The data-processing bound for the epistemic value.** A separate open item.
- **That any actual agent's likelihoods tie what matters.**

## 5. Standing

The identities are near-definitional.

- **The known result.** Data leave a prior's split within a class of observationally equivalent parameters unchanged: Bayesian non-identification (Rothenberg 1971 for identification; Kadane 1974, Dawid 1979 and Poirier 1998 for the Bayesian form, where the conditional prior of the non-identified given the identified is never revised). Conditioning commuting with a lumping that every likelihood respects is the same fact. That the predictive law of the data reads the prior only through its image under the likelihood map is standard.
- **The principle's standard choice rule.** The softmax over expected free energy (Friston and others 2015; Da Costa and others 2020); with habits, `σ(ln E − γG)` (Friston and others 2016; Parr, Pezzulo and Friston 2022).
- **What the expected free energy does in the blindness.** It enters only through `expectedFreeEnergy_through`. Any criterion computed from the posterior and a likelihood that reads through the classes would do as well: the predicted outcomes, the epistemic value alone, any information criterion of Bayesian adaptive design. The blindness is a corollary of non-identification for adaptive designs whose criterion reads the posterior only through the classes.
- **What is new, in the principle's terms.**
  - The join of the core's counting form of seeking (an abstract policy of choice, natural weights) to the periphery's agent, which holds the posterior by free-energy minimization and chooses by expected free energy over courses: where the agent's model is the core's, the share given a chosen course is its posterior, and the core's order given the course and the posterior's order are one.
  - The restatement, for that agent, that its whole course of seeking, its choices and the predictive weight of every course, reads the prior only through the weight it gives each likelihood profile.
  - None of it is a new inequality.

What it forbids: the reading of the epistemic drive as self-correction in general (Wen 2025, §2). This was already forbidden unqualified by the core's law. Now it is forbidden for an agent choosing by expected free energy: by the core's law at every rule with natural weights (an instance), and over the reals in the posterior under every policy whose choices weigh something, the softmax included.

## 6. Review

An independent adversarial review by an AI agent ([REVIEW-UE23](REVIEW-UE23.md)) compiled the round-one section and three probe files. It found no Lean error, and 4 overclaims, 2 gaps and 8 minor points. Every point was taken:

- **F1** (the posterior's minimality stated without the support condition, and cited to a lemma that does not state it). `coursePosterior_minimizes` states it in the Lean, the iff form of UE17's `minimizes_iff_posterior` with the condition of zero wherever the joint weights are; the prose says the same, where the course weighs something.
- **F2** (no statement joining real choice weights to the posterior). `posterior_choice_eq_coursePosterior`, `softmax_choiceWeight_pos` and `softmax_order_kept`.
- **F3** (`belief_order_from_core`'s idle hypotheses and a conclusion reading no policy). Removed; `givenCourse_le_iff` joins the two orders, for any two listed hypotheses, tied or not.
- **F4** (courses listed once not needed). Dropped, through `mass_count`.
- **F5** (one direction proved, "is their order" claimed). `share_le_iff_toReal_le` proves the iff. Its home is beside `Share.toReal` in `FreeEnergyReals` (§3, Homes).
- **F6** (an instance presented as a result). Instances are marked as instances in the docstrings, the header and §2, by one standard.
- **F7** (expected free energy on natural weights). §3 and the header state the factor `N_e` and the principle's rule; `efe_seeking_keeps_order` takes any real model, and `coursePosterior_rescale` shows the posterior does not read each experiment's scale.
- **F8** (the softmax weighing experiments outside its set). The softmax is over all the experiments, a finite type; `sum_softmax` shows its weights total one.
- **F9** (the rules' coverage understated). §3 and the header: a fixed habit is among the rules, the free energy of the past is the same under every one-step policy, and what is not covered is named.
- **F10** (what is new, and what the expected free energy does). §5 and the header: a corollary of non-identification for adaptive designs whose criterion reads the posterior only through the classes, the expected free energy entering only through `expectedFreeEnergy_through`; Kadane (1974) cited.
- **F11** (`courseWeight` is the agent's predictive weight). Said in its docstring and in `seeking_blind_to_split`'s, whose third part states the weight under every state.
- **F12** (names). `belief` became `coursePosterior`, the share lemma `share_le_iff_toReal_le`; `softmax` now ranges over all the experiments.
- **F13** (an orphan lemma; instances counted as theorems). `courseLik_nonneg` is used by `coursePosterior_minimizes`; §2 counts results, instances, helpers and witnesses apart.
- **F14** (witnesses showing no blindness, and one course). `Witness.separating_turns` states the kept order for every course; `Witness.split_unseen` shows two priors whose posteriors differ and whose seeking, over two experiments, does not. A witness of a choice by expected free energy picking the separating experiment is left, as the review allowed: it turns on logarithms and preferences and is the boundary of §4.

## 7. Recheck

A second independent AI agent rechecked the fix round ([RECHECK-UE23](RECHECK-UE23.md)) and compiled a probe file. It found the Lean sound and the counts right; F1 and F2 partly taken, the rest taken; and ten new points, two of them overclaims of attribution, the rest conditions dropped from summaries or minor. Every point was taken:

- **N1** (real-valued rules counted as the core's policies). The core's law is said to hold at rules with natural weights only; the softmax and the habit rule are covered over the reals, and `softmax_order_kept` states it.
- **N2** (choice weights dropping out, and "under every policy", without the condition that they weigh something). The condition is stated wherever the claim is, `coursePosterior_order_kept`'s docstring included.
- **N3** (the strict order without the course possible under the pair). Stated wherever the order is.
- **N4** (least free energy without a positive total). Stated in `coursePosterior`'s docstring and the summaries, with the nonnegative prior and likelihoods.
- **N5** (the join credited with the instance). The texts separate the two: the core's law holds at choice by expected free energy because every rule with natural weights is a policy (no join used, any agent's model); the join says that where the agent's model is the core's, the share given a chosen course is its posterior and the two orders are one.
- **N6** (witnesses stated as laws). `unchosen_share_zero` states the share of a course never chosen in general; the turning of the posterior is stated for the coin's outcome, with the outcome that does not turn it.
- **N7** (roles, an orphan, homes). Recounted by one standard: `coursePosterior_minimizes` and `coursePosterior_rescale` are instances (11 results, 6 instances); `sum_softmax` is a fact about the definition; §3 says the lemmas' move repoints the record's second law.
- **N8** (the example for listing hypotheses once). The list and the course are named.
- **N9** (the boundary on choosing a separating experiment). "Whether, or how often", turning on the preferences, the posterior and the experiments' information, with the softmax's and argmin's cases (§4).
- **N10** (the record's correspondence differing between its languages). Made the same.

The recheck also noted that `Witness.split_unseen` had one experiment, so what agreed was that experiment's expected free energy, not a choice among experiments; the witness now has two. It cautioned that the habit term is from Friston and others (2016); §5 cites that paper.
