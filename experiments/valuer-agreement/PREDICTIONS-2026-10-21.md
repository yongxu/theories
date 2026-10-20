# Predictions for VD1: where valuers agree and disagree, frozen 21 October 2026

Board item VD1. AI-written (a Claude Code session of 21 October 2026, started by the session that set the theory's strongest claims). Frozen before any experimental model call. The commit holds this file, the frames, standpoints and pairs ([`frames.py`](frames.py)), the exact structure ([`structure.py`](structure.py), output [`results/structure.json`](results/structure.json) and [`results/balance.json`](results/balance.json)), the client ([`client.py`](client.py)), the configuration ([`run.py`](run.py), `CONFIG`) and the verdict rules ([`analyze.py`](analyze.py)). The runs are made from it.

Run before the freeze, with no model:
- The structure computation.
- Dry runs of every code path with scripted valuers (below), written to a scratch directory and kept nowhere.
- One API parameter check per model with a test prompt that is not the experiment's. The first was refused with HTTP 429 (`insufficient_quota`: the account has no credit), so no model output of any kind was received.

No model has seen a frame, and no number below was chosen from a model's output.

One change was made after the first dry run, before any call. D, the disagreement of a pair, was first the minority share of the *strict* choices. It is now the share of *all* the pair's judgments on the minority strict side. Under the first form, a widening pair where most valuers answer "equal" and one chooses the narrower would score as high disagreement, though only one valuer opposes. No threshold changed.

## Why this test

The ethics' order premise C calls widening better. On a finite listing, one course widens another exactly when every weighting that counts every listed formation ranks it higher, however partially it weighs (`Weighting.widens_iff_every_positive`, on webs `Web.widens_iff_every_weighting`). The same holds for every order increasing in admission, additive or not (`Weighting.widens_iff_every_increasing`). A mixed comparison, where each course keeps something the other ends, is decided each way by some positive weighting (`Weighting.mixed_either_way`). One weight for every formation counts numbers (`Weighting.neutral_ranks_by_number`). The mathematics is known: it is Sen's intersection approach, and in decision analysis the necessary and possible preference relations of robust ordinal regression (Greco, Mousseau and Słowiński 2008), where with no preference information the necessary relation is weak dominance.

The claim it supports is strong. C is shared by every standpoint that weighs every formation positively, and nothing more is shared by all of them. That gives a prediction about actual valuers that forbids something observable:
- Where many valuers compare outcomes, robust agreement falls on widening comparisons, and disagreement falls on mixed ones.
- Disagreement on a pure widening is rare, and it comes from a misread case.

What the prediction adds to prior work (the [significance review's valuer check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#valuer-check)):
- The locus of disagreement is predicted from structure, computed exactly from what each outcome admits, before any judgment is seen. Prior work selects contested cases by observed disagreement, assigns ambiguity by design and annotation, or has only mixed comparisons.
- The pairs are matched in size, so inclusion is separated from counting: a valuer who counts ranks the widening and the mixed pair of equal sizes alike.

## The design

**Frames.** Sixteen decisions in eight domains (river, town, health, farming, coast, mountain, culture, economy; two each). In each, six named formations depend on the plan chosen: animal populations, plants and habitats, institutions, practices, heritage, enterprises, communities. Every formation is one most standpoints would count positively; none is a pest or a harm. Each prompt states that whatever ends, ends for good; whatever continues goes on as it is; and the two plans differ in nothing else.

**Pairs.** Within a frame, a seeded permutation gives the six the roles s1, s2, s3, x, z, w. Plan B keeps {s1, s2, s3}. Plan A keeps:

| Class | A keeps | Sizes | Structure |
|---|---|---|---|
| W1 | s1, s2, s3, x | 4 / 3 | A widens B, margin 1 |
| M1 | s1, s2, x, z | 4 / 3 | mixed, margin 1 (A loses s3, gains x and z) |
| W2 | s1, s2, s3, x, z | 5 / 3 | A widens B, margin 2 |
| M2 | s1, s2, x, z, w | 5 / 3 | mixed, margin 2 |
| M0 | s1, s2, x | 3 / 3 | mixed, margin 0 |
| K | s1, s2, s3 | 3 / 3 | keep: one plan said by what continues, the other by what ends |
| W1X | as W1 | 4 / 3 | widening, cross-framed: one plan said by what continues, the other by what ends |

W1 and M1 match in sizes, and so do W2 and M2. 16 frames × 7 classes give 112 pairs.

**Presentation.** A pair is shown as plan 1 and plan 2. For every pair, the sixteen standpoints see each combination of order (A first or B first) and framing four times: both plans said by what continues, or both by what ends; for K and W1X, which plan is said by what continues. Across classes the prompts have the same mean length (190.7–191.2 words), and every share of order and framing is 0.50 ([`results/balance.json`](results/balance.json)).

**Standpoints.** Sixteen system prompts ([`frames.py`](frames.py), `STANDPOINTS`) ask the model to answer as a described person, from that person's values, not as a neutral assistant. They span roles, countries and orientations:
- care and ethics of rights
- totals of consequences
- Lutheran, Buddhist, Confucian, Muslim and Anishinaabe outlooks
- libertarian, economist (things matter as far as people benefit), ecologist (every living thing has value in itself)
- heritage, modernizer ("letting outdated things give way"), local partiality, the worst off
- an engineer who thinks much of what people treasure is clutter

Some may weigh some formation at zero or below; the theorem binds only positive weightings.

**Response.** Strict JSON:
- `reason`: at most 40 words.
- `better`: "1", "2" or "equal".
- The model's own reading of the plans: `continue_1` and `continue_2`, the formations it takes to continue under each, from the frame's six labels.

The reading lets a misread be checked exactly from each judgment, with no judge.

**Valuers and calls.** Four models through the OpenAI chat completions API (`CONFIG`): `gpt-4o-mini-2024-07-18`, `gpt-4.1-nano-2025-04-14`, `gpt-4.1-mini-2025-04-14`, and `gpt-5.4-mini-2026-03-17` (reasoning effort low). Each judgment is one stateless call at default sampling with a fixed seed.

Each model makes 1,792 main calls (16 standpoints × 112 pairs). It also makes 128 replicate calls: four standpoints (0, 4, 8, 12) repeat M0 and M1 with another seed. That is 7,680 calls in all, about 3M input and 1.5M output tokens, under IN1's 4.1M and 1.5M. A valuer is a (model, standpoint) pair, 64 in all.

## What the exact computation already settles (not a prediction)

[`structure.py`](structure.py) computes the class of every pair from the sets alone, and asserts that each has its intended class (all 112 do).
- For every mixed pair, it gives the two outweighing weightings of `Weighting.outweighs` (weight 7 on what one plan keeps beyond the other, 1 elsewhere), each deciding the pair one way.
- Over the 729 weightings with values 1, 3 or 9 on the six:
  - every widening pair is ranked A above B by all of them;
  - every keep pair is equal under all;
  - the mixed pairs are split. The mean shares ranking B above A are 0.333 for M0, 0.185 for M1 and 0.086 for M2.
- A valuer with one weight for every formation ranks A above B in W1, M1, W2 and M2 alike, and calls M0 and K equal.

So among valuers who weigh every formation positively, a widening is never disputed and a mixed comparison can be. Whether actual valuers dispute it is empirical.

## The account under test

- **Agreement where widening.** Every standpoint that counts every formation positively ranks the wider plan higher. A standpoint that weighs the extra formation at zero calls them equal. A choice of the narrower comes from a misread case, or from a weight below zero, which lies outside the condition's scope.
- **Disagreement where mixed.** Standpoints that weigh the lost formation against the gained ones differently decide a mixed pair differently. At matched sizes, where counting cannot separate the classes, the mixed pair is disputed more than the widening.
- **Equal where kept.** Plans that keep the same formations are equally good, however they are worded.

## Predictions and verdict rules

**Measures** ([`analyze.py`](analyze.py)). A judgment's choice is read as A, B or equal, through the order the plans were shown in. A *violation* is choosing B in a widening pair. A judgment's *read relation* is the class of the sets it listed. *D* of a pair is the share of its judgments on the minority strict side, min(#A, #B) / n. Pooled measures take every valid main-design judgment of all four models: 64 per pair.

**Predictions.** A1, A2 and R1 are judged per model and pass only if they pass for all four. The others are pooled across the 64 valuers.

- **A1, widening agreed:** for each model, violations in W1 and W2 are at most 0.03 of its 512 W1 and W2 judgments.
- **A2, by every standpoint:** for each model, at most one of the sixteen standpoints has more than 2 violations among its 32 W1 and W2 judgments.
- **R1, a violation is a misread:** for each model, among its W1, W2 and W1X judgments whose read relation is the true widening, the narrower is chosen in at most 0.01. Untested for a model with fewer than 100 such judgments.
- **L1, the locus at matched sizes:** the mean over the 16 frames of D(M1) − D(W1) is at least 0.10, and D(M1) > D(W1) in at least 12 of 16 frames.
- **L2, structure over margin:** the mean of D(M2) − D(W1) is at least 0.05, and D(M2) > D(W1) in at least 10 of 16 frames. A mixed pair with the larger margin is disputed more than a widening with the smaller margin.
- **L3, decided both ways only where mixed:** at least 24 of the 48 mixed pairs (M0, M1, M2) have D ≥ 0.10, and at most 1 of the 32 widening pairs (W1, W2) does.
- **L4, the locus on read cases:** L1 holds also when D is computed only from judgments whose read relation is the true one.
- **K1, keep is not ranked:** "equal" is at least 0.70 of the K judgments.
- **V, validity:** a model with more than 5% invalid judgments (after the client's retries) is not tested, and every prediction using it fails as untested.

The thresholds of L1 and L2 are about half the minority shares the 1-3-9 grid gives M1 and M2. They were set from the structure before the dry runs, and none changed after them.

**Measurement without prediction:**
- the share choosing the larger plan in M1 and M2 (agreement by counting);
- "equal" in W pairs (zero weights);
- W1X against W1 (whether masking the inclusion raises violations, as Tversky and Kahneman found for dominance);
- the misread rate by class and framing;
- the share choosing plan 1 in K and M0 (position);
- the rank correlation across mixed pairs between D and the grid's minority share;
- the replicates' within-standpoint flip share against the between-standpoint D;
- D and violations per model and per standpoint.

## Dry runs (scripted valuers, no model)

[`run.py --dry`](run.py) with [`client.ScriptedValuer`](client.py), four scripted "models" of sixteen standpoints each:

| Valuers | A1 | A2 | R1 | L1 | L2 | L3 | L4 | K1 | Mean D: W1, M1, W2, M2, M0 |
|---|---|---|---|---|---|---|---|---|---|
| Each standpoint a positive weighting (log-normal, σ 1) | pass | pass | pass | pass | pass | pass | pass | pass | 0, 0.253, 0, 0.130, 0.450 |
| The same, with plan 1's reading misread in 10% of judgments (choice made on the misread sets) | pass | pass | pass | pass | pass | pass | pass | pass | 0.021, 0.261, 0.010, 0.128, 0.441 |
| One weight for every formation (counting) | pass | pass | pass | fail | fail | fail | fail | pass | 0 everywhere |
| Uniform random choices | fail | fail | fail | fail | fail | fail | fail | fail | 0.26, 0.24, 0.28, 0.25, 0.22 |

So the locus predictions can fail, and they separate the account from agreement by counting. A population of counters agrees on every pair, mixed or not.

## What would change the account

- **A1 or A2 failing with R1 passing:** the violations are misreads. These models' reading fails, and the order holds on the cases they read.
- **R1 failing:** valuers rank a narrower plan above a wider one they read correctly. The reasons, read after the verdicts, separate a weight below zero (some standpoint wants the extra formation gone: the condition's scope, not the order) from an order that is not increasing in admission (a counterexample to the claim that C is what every such standpoint shares).
- **L1, L2 or L3 failing because mixed pairs are agreed:** the valuers share more than positive weights, for example counting or a common ranking of kinds. The prediction weakens from "disagreement falls on mixed comparisons" to "it can fall only there". Structure then bounds the locus but does not predict it.
- **L3 failing on its widening clause, or L4 failing while L1 passes:** some disagreement on widening pairs is not explained by misreading.
- **K1 failing:** these valuers' choices depend on wording, not only on what each plan keeps. The order's object is then not what they compare.

## Boundary

- AI models under standpoint prompts stand in for valuers. Persona prompting narrows the diversity of moral values relative to humans (Russo et al. 2025), so mixed disagreement here is likely a lower bound on human disagreement.
- One provider, four models; English; continuation only (kept or ended, no levels); formations chosen to be uncontested.
- No human data: no downloadable dataset fits the structure. Every Moral Machine dilemma is mixed in admission, and the kidney-allocation data concern levels of attributes.
- A passed prediction supports C as a description of what these valuers share; it does not warrant C (chapter §8.5).
