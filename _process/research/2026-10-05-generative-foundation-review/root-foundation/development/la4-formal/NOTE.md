# LA4's formal side: the season in Lean, a learner that commutes with an exchange, and the separable flow

Board item LA4, its formal part, 30 October 2026. AI-written (a Claude Code session). LA4's [design](../../../../../../experiments/drain-beyond-the-reward/DESIGN.md) landed on 30 October with its checks made by enumeration and three claims in prose about what training by gradient fixes. Learner runs wait for another machine. This note covers what can be settled before they run: what the season meets, proved, and which of T3's forbidden cases follow from how learners update, proved or computed exactly. It was reviewed before landing by an independent cross-model reader ([REVIEW-LA4-FORMAL](REVIEW-LA4-FORMAL.md)): eleven findings, each taken, one of them a counterexample to T3's second forbidden case as first worded (§3).

## 1. What the work is for

LA4 tests thesis T3's clause on trained systems ([05 §7](../../../../../../theories/becoming/chapters/05-COLLECTIVES.md#t3)). Two questions had to be settled before any learner runs.

- **Does the season meet the laws it is built to meet?** The design's checks were made by enumeration in `season.py`. A proof claim needs Lean, so the checks are now theorems.
- **Which predictions follow from the update rule alone?** A prediction any learner of a class passes by construction tests nothing about that class. The design already said this for the separable family (§1). The question here is whether it holds more widely.

## 2. The season, proved (`Becoming.OptimumSeason`, core)

The module states the season exactly as `season.py` runs it, with the same takes, renewal, bay and sites. It proves what the design claimed by enumeration. 63 theorems in 98 declarations, every axiom report empty.

- **Three parts.** The ground's catch depends only on the takes asked of it. The bay gives exactly the lesser of six and the number of fish asked of it. The landings depend only on the sites chosen. Any takes, any number of bay fish up to six and any number of landings up to ten combine in one season (`run_caught`, `takes_eq`, `run_landed`, `eligible_of`).
- **The ground's best is 34.** A table of the best catch over `n` steps from each level is checked against every choice at every level and step (`bellman`, by evaluation). It bounds every run (`caught_le`), and one season reaches it (`top_caught`). So the catch is at most 40, and a season leaving the bay at three or more catches at most 37 (`catch_le`, `kept_catch_le`).
- **Rising.** Units are shared (`shared`), so every optimum of every order rising with the catch empties the bay (`bay_drained`, through `Optimum.least_of_shared`). There is no room at the site (`site_no_room`). Among the optima of the order by the catch alone are seasons landing there never and at every step, so an optimum need not stand at the site's least level (`site_optima`, `site_not_least`); other rising orders, such as one ranking the site after the catch, have other optima there.
- **The unshared bay.** Ranked by the ground's catch alone, there is no room at the bay, and among the optima are a season keeping the bay at six and one emptying it (`unshared_no_room`, `unshared_optima`).
- **Counted after.** Seven times the catch plus the bay left ranks eligible outcomes exactly as catch first, bay second (`after_iff`). That order rises with the catch (`lex_rising`, by `Optimum.Rising.mono`), so the score's optima empty the bay (`after_drained`).
- **Plateau.** It is not rising (`plateau_not_rising`). Among its optima are a season keeping the bay at six and one emptying it (`plateau_optima`).
- **Weighted seasons.** With natural-number weights, weighted bay left plus weighted catch is at most 40 times the total weight (`mix_bay_catch`), so `B ≤ 40(1 − ν)`. Weighted catch plus three times the weight of seasons leaving the bay at three or more is at most 40 times the total weight (`mix_kept`), so `ν ≤ 1 − 3p/40`. These cover a policy whose probabilities are rational, scaled to a common denominator; for real probabilities the bounds follow by continuity, which is not proved here.

`season.py`'s enumeration agrees with all of these. Its count of 2,695 eligible outcomes is not restated: the three parts give the eligible outcomes directly.

## 3. A learner commuting with an exchange (`Becoming.WeightedCommuting`, core)

`Becoming.Commuting` states what a deterministic law commuting with a map keeps. This module states the weighted form: a law that goes from each configuration to finitely many successors, each with a weight of any type, using no law of that arithmetic. 18 theorems in 29 declarations, every axiom report empty.

- **What commutes is kept in expectation.** Suppose a weighted law commutes with `σ`: every weighted total over the successors of `σ x` equals the total over the successors of `x` carried by `σ`. Then the expectation of any observable `n` steps on from `σ x` is the expectation of that observable read through `σ` from `x` (`Commutes.carried`). From a configuration `σ` fixes, or from starting weights `σ` leaves unchanged, every expectation equals its image's at every step (`Commutes.fixed_expect`, `Commutes.start_expect`). A deterministic commuting law is a case (`law_commutes`).
- **A learner.** Take a law that draws one of finitely many samples, with a weight read off the configuration, and moves by an update. It commutes with `σ` when three things hold: some map of the samples permutes them; the weight of a sample at `σ x` is the weight of its image at `x`; and the update at `σ x` is `σ` of the update at `x` from the image sample (`Commutes.of_samples`).
- **Two witnesses.**
  - *Reinforcing* draws a value in proportion to its count and adds one to the value drawn. It commutes with the exchange. From equal counts the expected counts stay equal, yet a run drawing one value at every one of any number of steps has positive weight (`Reinforcing.oneSided`). No drive in expectation is not no drift in a run. (Normalized, the one-sided run of `n` steps from one and one has probability `1/(n + 1)`; it is Pólya's urn, whose share settles at a random limit, not proved here.)
  - *Pooling* adds one to both values. It also commutes with the exchange. From counts of three and one, the share of the less-drawn value rises at every step and stays below one half. A commuting law can wear away a start's asymmetry when nothing reads the choice.

**How a policy-gradient learner meets the hypotheses.** Let the site's two values be exchanged in everything the learner holds: the rows of the site's output layer, the inputs that carry its past site choices if it reads them, the value network's parameters where it reads those inputs, and Adam's moments with the parameters. Then:
- the weight of a batch of seasons at the exchanged parameters is the weight of the exchanged batch, provided neither the reward nor the dynamics read the site;
- REINFORCE's update at the exchanged parameters is the exchange of the update from the exchanged batch, provided the value baseline does not read the site, or reads it exchanged;
- Adam, plain gradient steps and weight decay act coordinate by coordinate, so they commute once their state is exchanged with the parameters.

- a random initialization meets them in law, not seed by seed: the law it draws from must be unchanged by the exchange. A past site choice fed as one-hot columns is exchanged by permuting them, which an initialization drawing those columns alike leaves unchanged; fed as one 0/1 input, the exchange acts affinely on the first layer (`w ↦ −w`, `b ↦ b + w`), and the initialization's law must be invariant under that too. LA4 encodes past acts one-hot.

These are properties of the code, not theorems here. LA4's Stage A checks them with a mirror test: train a seed twice on one random stream, once with every sampled site value exchanged, and compare the parameters, the value network and Adam's moments. Agreement up to rounding is evidence for the code, not a proof.

**What it settles for T3 [AI reading].** T3's second forbidden case was first worded "a systematic drive on a condition sharing no units with anything rewarded". It is excluded, in expectation and at every step, under three conditions:
- the learner commutes with exchanging two values of a choice;
- nothing the learner reads tells those values apart: not the reward, not the dynamics it observes, not its inputs;
- the starting state, or the law it is drawn from, is one the exchange leaves unchanged.

The clause stays conjectured beyond that: from a start that prefers one value, which is a prior restraint, or for learners that treat the values apart. *Pooling* shows that a commuting learner can wear away such a preference with nothing selecting on the choice. So the C1 control, which removes the selection in expectation while still updating the site with noise, is what separates the clause from erosion that does not come from the reward. Its noise is not the arm's (an independent return keeps its distribution, not the gradient's), so it separates them only approximately, and the design logs both.

The second condition cannot be dropped. In the separable family's exact flow (§5), the bay in the unshared arm shares no units with anything rewarded, yet the policy reads its level, and it rises: a systematic drive the first wording forbids. So F2 is stated for a choice whose values nothing rewarded and nothing the learner reads tells apart, where the law makes it a theorem in expectation, and the first wording's failure is kept as its counterexample.

## 4. Consequences for LA4's design

- **P2 at the uniform start is settled, not tested.** The feedforward family observes only the step and the levels, and its site output layer starts at zero, so each seed's start is fixed by the exchange (its value network does not read the site). Its expected disturbance stays at 5 in A1 and in C1u, so their difference is zero in expectation. For the recurrent family this holds across initializations drawn from an exchange-invariant law, not seed by seed. The A1–C1u comparison is reported as a check of symmetry, not as a verdict.
- **Stage B's not-told arm is settled by counting, with no law needed.** In B5 the model never reads which jetty is beside the nests. A fixed split of seeds between the two assignments does not settle it: each seed's training randomness and its assignment come together, so a seed's jetty preference can correlate with its assignment. Evaluating each trained policy under both assignments does: its disturbances under the two sum to ten exactly, so their mean is five for any policy. The design now does this. In the told arms the prompt names the site beside the nests, so it tells the sites apart, and neither the counting nor the law settles anything.
- **P2 is informative only where the start tells the sites apart:** the prudent start (A2, A3, A5, A6 against C1) and the told prompt (B1–B4 against B6).
- **The mirror test** joins Stage A's code checks. Weight decay is fixed at zero; if it is used, it enters as a named arm, since it acts as *Pooling* does.

## 5. The separable family's exact flow

[`exact_flow.py`](../../../../../../experiments/drain-beyond-the-reward/exact_flow.py) computes the separable family's expected REINFORCE update exactly, by dynamic programming over the season, and ascends it with plain gradient steps. The return's gradients were checked against finite differences of the expected return at random policies, agreeing to 1e-8; the KL term against finite differences of the visited states' summed KL, the visits held fixed. This is a computation on the baseline, not a frozen test of a trained system. The table and readings are in the design's [§12](../../../../../../experiments/drain-beyond-the-reward/DESIGN.md#12-the-formal-work-and-what-it-changed). In brief:
- From the prudent start the colony is kept in fewer than half the seasons from about ν = 0.68 (interpolated between checkpoints at 0.665 and 0.694), where nothing forces a drain.
- The site's landings stay exactly at the start.
- The unshared bay rises from 5.0 to 5.9: the policy reads the bay's level, and taking a bay fish moves it to states where it fishes worse. This is the counterexample to F2's first wording (§3).
- The KL anchor slows the drain, keeping the colony in 88% of seasons at ν = 0.65 against 71% without it (interpolated). The KL term is the design's loss at the visited states, the visits held fixed, not a KL-penalized return.
- Draining stalls the learner at ν = 0.85, at states whose ground choice it had practised least.

## 6. What is not done

- Erosion of a prior preference by noise alone, the convexity of the softmax read under zero-mean steps in logit space, is shown only by the *Pooling* witness, not as a law of sampled gradient learners.
- That the score has mean zero, which underlies both the separable family's zero site update and C1's zero expected update, is the standard identity of policy gradients (Williams 1992). It is checked exactly in `exact_flow.py`, not restated in Lean.
- Stage A's code, calibration, mirror test and power check, the freeze, and every learner run.
