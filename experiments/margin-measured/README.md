# The margin as a measured quantity

AI-written, 20–21 October 2026. Board items MQ1–MQ5; this account is MC1's. Study sections [253](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#253-the-margin-as-a-measured-quantity-mq1), [266](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#266-the-margins-equation-of-state-against-held-out-regimes-mq2), [272](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#272-the-margin-of-a-regime-in-the-field-mq3), [277](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#277-a-state-of-level-and-recent-giving-in-the-field-mq4) and [280](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#280-a-lag-and-the-draws-response-in-the-field-mq5). The claims these tests bear on are the chapter's theses [T1](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING.md#t1-persistence-certifies-the-joint-draw) and [T2](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING.md#t2-the-state-of-a-renewable-condition-under-a-draw). The five reports as first written are kept in [history](history/README-2026-10-21-five-reports.md).

Thermodynamics became more than formal when temperature and heat became measured state quantities whose laws could fail. These tests ask the same of the theory's **margin**: a renewable condition's level above its **need** (the level below which renewal stops), less the draws on it. Five tests ran on three systems:
- MQ1: a simulated Allee yeast and a side-effect gridworld;
- MQ1 and MQ2: real yeast under serial dilution (Dai et al. 2012);
- MQ3–MQ5: assessed fish stocks (RAM Legacy database).

Every test's predictions and rules were committed before the run, or before any held-out value was read. Every verdict is kept, failures included.

## The answer

In the laboratory the margin is a measurable state quantity of a **regime** (the condition together with the standing draws on it), not of the condition alone. In managed fish stocks the regime itself moves within the span of a forecast, so there the margin is not the state.
- **In the laboratory, it predicts thresholds.** Measured by intervention, the margin bounds the time to break. A renewal curve fitted on some regimes predicts the need, and the fates the need separates, in regimes it never saw.
- **In managed fish stocks, it ranks the risk of a break but does not time it.** The giving does not follow the level alone, and the draw does not stay fixed.
- **The state is wider than the level.** It is the level, the recent giving and one lag. The theory's two readings, giving read off the level and giving held as it was, are the two ends of one law, and the stocks lie near the second.
- **Harms on a shared condition do not add, though the draws do.**
- **Blind draw predicts side effects for an exact optimizer only.** It predicts which cells an exact optimizer spends to its need, and fails for learners that fall short of the optimum.

## Why the frozen-rest margin is not itself the test

The spine's margin law (`Flow.Balances.loses_iff_beyond_margin`, `Flow.widens_iff_within_margin_at`) compares levels with the part's exchanges removed and every other exchange held as it was (`Flow.WithheldLevels`). Under that counterfactual, "draws add, time to break = margin / net draw" and "damage iff the net draw exceeds the margin" are identities of the balance. The gridworld confirmed them in 456 records with no mismatch (B1).

An identity can only be checked as accounting, not tested. The testable content is the margin measured with the rest responding:
- the **pulse margin**: the largest one-shot removal survived;
- the **largest sustained draw** Ŷ;
- the **need** read from fates;
- the **renewal curve** over regimes;
- **coupling**: how much the reward changes when the condition is perturbed and the same course replayed;
- **blind draw**: draw on a condition with zero measured coupling.

The spine's counterpart is `Becoming.RegimeMargin`. It covers the regime's step and its point of no return (RM1, [record](../../theories/becoming/results/records/margin-of-a-regime.md)). It covers every adjustment of giving and where its runs come to rest (RM2, RM3, [records](../../theories/becoming/results/records/regime-point-under-adjusting-giving.md), [rest](../../theories/becoming/results/records/where-a-run-of-a-regime-comes-to-rest.md)). It covers the threshold in the plane of level and recent giving (RM4) and the regime over any amounts and the reals (RM5, [record](../../theories/becoming/results/records/regime-in-any-amounts.md)). It covers two conditions each giving from what is left of both, where a condition's point of no return falls as its partner's level rises and a dependent ends after its partner (RM6, [record](../../theories/becoming/results/records/coupled-regimes.md)): a margin measured on one condition alone is not its own where the coupling is strong.

## Findings

### 1. Measured by intervention, the margin bounds time to break where the level is the state

In the simulated yeast, the pulse test found the need at the model's unstable point (DF 1000: 4,128 against 4,149 cells/µl). The sustained-draw test found the model's largest surplus (34,304 against 35,064). Together the two numbers bounded the mean break day in all 22 cells: four dilution factors, two starting levels, the break inside [m₀/H − 1, (m₀ − H)/(H − Ŷ) + 1] (A2).

History added nothing to the break-day distribution, and the same test detected a hidden lag state when one was put in (A1, A1m). This holds by the mathematics in the deterministic limit, so what it shows is that the measurements work under noise. The band is wide, so a point prediction needs the renewal curve.

### 2. The need is the regime's

- **Under a standing draw H** (simulation), the point of no return rises by more than H. It is H plus the rising root of s(y) = H, measured 1.4–4.1 H above the need (A3, 12/12). "Level − need" is a state quantity only with the need taken under the standing draws, as a boiling point is one only at a given pressure.
- **On real yeast** (MQ2), one daily growth map was fitted on dilution factors 250, 500, 1000 and 1266 and tested on 750, 1133, 1400 and 1600.
  - It predicted the need within a factor 1.3 of the need read from fates (A2).
  - That need separated survivors from extinctions, 93–100% on each side, where a model with no need classifies 68–81% (A1).
  - The measured need rose with the draw (B2).
- **Where it failed, and why.** It overstated the level next to the fold (1.5× at DF 1600), and it missed the fates after a salt shock in a separate experiment, whose levels sat 8–20% lower (S, S2, C1, C2). Post hoc, both failures share one cause. At equal density, per-capita giving falls with the dilution factor as DF^(−0.31 ± 0.01). So the draw lowers giving beyond removing cells, and the renewal curve belongs to the regime, not to the density alone.
- **In the field** (MQ3), the regime's point did not separate the fates of stocks under held catches: 63% of episodes below it fell, against the 80% required (F3). There the giving itself moves (finding 3).

### 3. The state: the level in the laboratory; level, recent giving and one lag in the field

- **Laboratory.** On real yeast, adding yesterday's density explains less than 10% more of tomorrow's at every dilution factor (D1). Post hoc, the excess, up to 9.1%, is still above a Markov null's 0.6%.
- **Field: the level is not the state.** In assessed stocks, last year's escapement removed a further 0.22 of the residual variance (MQ3 F0). A giving law of the level, fitted on a stock's earlier years, forecast worse than the frozen rest, which holds giving as it was: 0.64 against 0.77 for the one-year direction (F1, F2).
- **Level and recent giving** (MQ4, on 76 stocks no analysis had read). In SP_t = φ SP_{t−1} + (1 − φ) g(E_t), φ = 0 is the regime's step and φ = 1 the frozen rest.
  - Recent giving adds beyond the level (median 0.45 of the residual variance; G1).
  - The level adds beyond recent giving (44 of 76 stocks; G2).
  - The rate chosen on other stocks, φ = 0.96 (about 4% a year), also fits these best (post hoc). The stocks sit near the frozen-rest end.
- **One lag** (MQ5, on 69 further stocks). Read through the balance, a giving that also reads last year's escapement moves toward the draw.
  - The lag is detected beyond chance (14 of 69, p = 7 × 10⁻⁶; S2).
  - With it, nothing more is needed in the median stock (a further 0.059, against 0.128 without it; S3).
  - In sample, giving closes about 0.3 of its gap to the draw each year, with the same coefficients on development and test stocks.
- **On the spine.** This is thesis T2, conjectured and supported, and untested outside fisheries. Its formal side is proved:
  - every rest of such a state at or above the draw is the regime's point (`RegimeMargin.Adjusted.rests_iff`);
  - every run within a band comes to rest (`Adjusted.comes_to_rest`);
  - the point of no return is a curve in the plane of level and recent giving (`Adjusted.falls_iff_below`);
  - none of this needs counted amounts (`RegimeReals`).
- **Where the formal laws reach the field.** The laws that order runs and fates, from rest through the curve to convergence, assume the adjustment rises in both what is left and the recent giving. Read through the balance as an adjustment, the field's giving meets this assumption only partly (post hoc, MQ5 stocks, [`rises.json`](results/mq5/rises.json)):
  - it rises in the recent giving in 65 of 69 stocks (median slope 0.66; development 125 of 142);
  - it does not rise in what is left over the whole band: the one-step fit has no slope there (median −0.01), and each stock's fitted level law is humped, rising over a median 41% of its observed escapements and over the whole band in only 4 of 69.

  So the order laws reach the field's state on the low side of its level law, below the peak, where the point of no return lies. Rests at or above the draw are the regime's on either side, since that law needs no rising.

### 4. Time to break: bounded in the model, ranked but not timed in the field

- **Ranks risk.** The frozen-rest margin over the net draw ranks the risk that a stock falls below half its level within ten years. The share falling is 0.32, 0.15, 0.09 and 0.03 across its four classes (MQ4 T1).
- **Does not time it.** Of the origins it puts within five years, only 32% break within ten (T2).
- **Why.** Neither held exchange holds:
  - giving moves toward the draw (finding 3);
  - the draw follows the stock: next year's catch follows the change in biomass in 70 of 76 stocks (MQ4, post hoc).
- **MQ5's frozen test of the draw.** It failed (D1). Post hoc, the cause is the series' timing. Half the test stocks (New Zealand's) report the level after part of the year's catch. Outside them the catch follows the stock in 28 of 34.
- **Forecasts.**
  - The frozen rest beats the regime's step at one and five years (MQ3; MQ4 R1).
  - Level plus recent giving narrows the errors at one and five years (MQ4 F1b, F5b) but not the direction (F5a).
  - At ten years, the level staying where it is beats every forecast from the state (F10b, MQ5 P1). The lag closes that gap (P2), though, post hoc, damping alone does as well.

### 5. Draws add; harms do not

In the frozen-rest accounting, draws add exactly. The harm two harvesters did together exceeded the sum of their separate harms in all 12 cells (A4a–c). At 0.3Ŷ each, the excess was about 20%. Where each harvester was within Ŷ and the two together beyond it, the result was collapse. The renewal curve is concave above its peak, so one part's removal steepens the cost of the other's draw. A part's harm, read by removal, is not its draw.

In the gridworld the same held: two end-coupled best responses, each within the lawn's renewal alone, killed both cells together (B7, 4/5).

### 6. Blind draw predicts side effects for an exact optimizer, not for learners short of it

- **The exact optimizer.** Its blind draw, measured where nothing dies, predicted which cells die in five thin-margin variants and when: 8/8, all within the band, against 0/8 for the reference outcome (B4).
- **With a coupled reward**, it kept every cell alive and left each route-limiting cell exactly at the need. The margin was spent to zero, the tight case of `Flow.Balances.mixed_of_tight` (B5, which failed on one cell whose route another part shuts).
- **Tabular learners did not transfer** (B3, B4, B7). They fell short of the optimum (5–7.75 deliveries against 9), and where the lawn varied more they wandered more and drew less.
- **Coupling measured by replay is a property of the course** (B2 failed). Along courses that saturate a cell, perturbing its level changes no return.
- **The follow-up.** SE1 ([experiments/side-effect-benchmarks](../side-effect-benchmarks/README.md)) found that blind draw against margin is relative reachability on a replayed course. It matches the known impact measures and adds nothing as a measure.

## Ledger: every frozen verdict

Classes in MQ1:
- *identity*: follows from what the system is built to meet;
- *deterministic limit*: tests the measured quantities under noise;
- *manipulation*: shows a test can fail;
- *law + bridge*;
- *beyond the law*.

**MQ1, simulation and gridworld** (round 1 frozen at `6b29f6ac0`; round 2 at `037683ad8`, configuration corrected, criteria unchanged).

| Prediction | Class | Verdict |
|---|---|---|
| A1 same margin, any history → same break-day distribution | identity (Markov) | round 1 degenerate (H ≥ m₀); round 2 **passed** (KS p ≥ 0.75) |
| A1m a hidden lag state is detected | manipulation | round 2 **passed** (p to 10⁻⁵¹) |
| A2 break day inside the band from m₀ (pulse) and Ŷ (sustained draw) | deterministic limit | **passed** (22/22) |
| A3 point of no return under H above need + H | deterministic limit | round 1 failed 6/12 (protocol error); round 2 **passed** (12/12) |
| A4a two harvesters' harms never sub-additive | beyond the law | **passed** (12/12) |
| A4b each within Ŷ, together beyond → super-additive | law | **passed** (4/4) |
| A4c jointly within Ŷ → still super-additive | beyond the law | **passed** (8/8) |
| B1 level = l₀ − takes + regrowth; dead iff takes ≥ l₀ + regrowth | identity | **passed** (456 records) |
| B2 replayed coupling: blind exactly 0, coupled > 0 | identity | **failed** (course-relative) |
| B3 blind behaviour identical across margins | law + bridge | best response **passed**; learners **failed** |
| B4 side effects predicted out of sample from blind draw | law + bridge | best response **passed** (8/8; baseline 0/8); learners **failed** (80/151) |
| B5 coupled draw adapts; binding cells ≤ need + 1 | law | best response **failed** on one cell; learners **failed** (74% < 80%) |
| B6 step coupling: deaths only where the remaining reach < the gain | law | best response vacuous; learners **passed** |
| B7 end-coupled agents trained alone break a binding cell together | law + bridge | best response **passed** (4/5); learners **failed** (6/50); band **failed** (3/13) |

**MQ1, real yeast** (frozen at `00d7408c4` before any value was read): 1 of 2 passed.

| Prediction | Verdict |
|---|---|
| D1 yesterday's density explains < 10% more of tomorrow's | **passed** (at most 9.5%) |
| D2 above 1.5û alive, below û/1.5 extinct, ≥ 90% each | **failed** (19–46% of low starters read > 0: the instrument's floor) |
| D1′, D2′ with a floor from negative readings | no negative readings: D1′ = D1, D2′ = D2 |

**MQ2, real yeast against held-out regimes** (frozen at `6deda4fb7` with numerical predictions): 4 of 8 passed.

| Prediction | Verdict |
|---|---|
| M the growth map beats a no-need null on held-out transitions | **passed** (0.294 against 0.355) |
| A1 the predicted need separates fates | **passed** (DF 1133–1600) |
| A2 predicted need within 1.5× of the need read from fates | **passed** (0.81, 1.26, 0.79) |
| B2 the measured need rises with the draw | **passed** |
| S indicator levels within 1.5× at all DFs, no worse than the null | **failed** (1.52× at DF 1600; the null closer) |
| S2 held-out day-7 levels within 1.5× | **failed** (1.55× at DF 1600) |
| C1, C2 after a salt shock, alive iff above the need (day 5, day 6) | **failed** (0.78, 0.81; the null 0.78) |
| B1 the fold; D time to break past the fold | reported only (DF 2797); not testable |

**MQ3, the regime's step in assessed stocks** (113 stocks, frozen at `13af39133` before any value was read): 0 of 4 passed.

| Prediction | Verdict |
|---|---|
| F0 last year's escapement adds < 0.10 | **failed** (0.22) |
| F1 one-year direction ≥ 0.60 and better than the frozen rest and momentum | **failed** (0.64 against 0.77, 0.75) |
| F2 five years, better direction and error than the frozen rest and persistence | **failed** (0.62 against 0.68; error 0.30 against 0.19) |
| F3 under held catch, ≥ 80% below the regime's point fall, ≥ 90% above hold | **failed** (63%; 99.5%) |
| F4 (descriptive) giving at equal escapement against recent exploitation | rises in 76 of 113 |

**MQ4, level and recent giving** (76 unread stocks, frozen and landed at `bdb985ee3`): 7 of 12 passed.

| Prediction | Verdict |
|---|---|
| G1 recent giving is part of the state | **passed** (0.45) |
| G2 the level is part of the state given recent giving | **passed** (44 of 76) |
| G3 nothing more is needed | **failed** (0.12) |
| F1b one-year error smaller than every alternative, in most stocks | **passed** (63 of 76) |
| F5a five-year direction | **failed** (0.678 against 0.695) |
| F5b five-year error | **passed** (56 of 76) |
| F10a ten-year direction | **failed** |
| F10b ten-year error | **failed** (persistence 0.215 against 0.304) |
| T1 the frozen-rest time to break ranks the risk | **passed** (0.32, 0.15, 0.09, 0.03) |
| T2 half of the origins with n̂ ≤ 5 break within ten years | **failed** (0.32) |
| R1 MQ3's forecast finding on new stocks | **passed** |
| R2 MQ3's F4 on new stocks | **passed** (60 of 76) |

**MQ5, a lag and the draw's response** (69 unread stocks with spawning biomass, frozen and landed at `e690d5062`): 6 of 8 passed.

| Prediction | Verdict |
|---|---|
| S1 MQ4's state on new stocks | **passed** (47 and 33 of 69) |
| S2 the lag is part of the state | **passed** (14 of 69, p = 7 × 10⁻⁶) |
| S3 nothing more is needed with the lag | **passed** (0.059) |
| S4 the lag improves the five-year forecast | **passed** (50 of 69) |
| P1 persistence wins at ten years | **passed** |
| P2 the lag closes at least half of that gap | **passed** (1.04) |
| D1 the draw follows the stock (frozen same-year form) | **failed** (36 of 67) |
| D2 the draw's law closes half of the held draw's ten-year gap | **failed** (0.45) |

The other groups in the field tests (production-model controls, assessments of unknown method), the per-group numbers and every post-hoc analysis are in the [five reports](history/README-2026-10-21-five-reports.md) and in `results/`. None of them changes a verdict.

## Corrections and disclosures

- **MQ1.**
  - Round 1's A1 and A1m were degenerate: the harvest was at least the starting margin, and A2's guard H < m₀ was missing.
  - Round 1's A3 grew one unharvested day first.
  - Round 2 corrected the configurations only.
  - The data addendum keyed the floor to negative readings, and there were none. Its explanation of the synthetic null's D1 failure (cubic misfit) was wrong: the cause was noisy low readings.
  - No learner round 2: no setting reached the best response.
- **MQ2.**
  - The held-out dilution factors had been read in MQ1, so they were held out from the fit, not from the analyst.
  - The masked layouts of the salt-shock and indicator files showed exponent signs.
- **MQ4.** Two rules were changed after the first dry run, before any test value was read (recorded in its freeze).
- **MQ5.**
  - A limit found in the dry runs (noise in the spawning share) was fixed before the run.
  - The frozen reading assumed every series reports the level before the year's catch; half the test stocks do not (found post hoc).
- **Hashes.** Every freeze's original commit is kept under `refs/salvage/mq*`; the rebased commits on main are in `results/FROZEN-AT` and the reports.

## Limits

- **Simulation and gridworld.**
  - The yeast model's parameters are set from the paper's reported facts, not its table S1.
  - Its fluctuations next to the fold are below the paper's.
  - A1m's lag state is invented.
  - The gridworld is small and deterministic, and its learners are tabular with modest training.
- **Real yeast.**
  - The population layout is read from the files.
  - The floor of 0.01 was found post hoc in MQ1 and pre-registered in MQ2.
  - The salt-shock column order comes from the paper's legend.
  - Four days after the shock is too short to settle fates near the need.
- **Fish stocks.**
  - The series are assessment outputs, not measurements; age-structured assessments carry a recruitment lag of their own.
  - Origins overlap within a stock.
  - φ, λ and ε were each chosen once on development stocks; the test stocks prefer λ = 0.35 and ε = 0.37 where 0.55 and 0.7 were frozen.
  - The spawning-stock share κ is weakly identified.
  - Series timing differs by assessment.
  - Survey series are not used.

## Open

- What lowers giving under a stronger draw at equal density in yeast. Carryover of hexose or invertase with the transfer is one candidate.
- T2 on measured series outside fisheries: survey indices, grazed grassland, harvested forest, and yeast under a dilution that changes over time (Dai, Korolev and Gore 2015). The last would also test the time to break past the fold.
- Fates read long enough after a shock to settle near the need.
- A learner that reaches the best response, to test B3–B7's bridge rather than its failure.
- A partner's level as a fourth variable in the state of coupled stocks (RM6); none of the stocks here was read with a partner.

## Files and reproduction

| Test | Predictions | Code | Results |
|---|---|---|---|
| MQ1 | [PREDICTIONS-2026-10-20.md](PREDICTIONS-2026-10-20.md), [ROUND2](PREDICTIONS-2026-10-20-ROUND2.md), [DATA](PREDICTIONS-2026-10-20-DATA.md) | [yeast.py](yeast.py), [garden.py](garden.py), [run.py](run.py), [analyze.py](analyze.py), [calibrate_yeast.py](calibrate_yeast.py), [calibrate_learners.py](calibrate_learners.py), [yeast_data.py](yeast_data.py), [synth_null.py](synth_null.py), [posthoc_data.py](posthoc_data.py) | `results/` (round 1), `results/round2/`, `results/data/` |
| MQ2 | [PREDICTIONS-2026-10-20-MQ2.md](PREDICTIONS-2026-10-20-MQ2.md) | [mq2.py](mq2.py), [posthoc_mq2.py](posthoc_mq2.py) | `results/mq2/` |
| MQ3 | [PREDICTIONS-2026-10-20-MQ3.md](PREDICTIONS-2026-10-20-MQ3.md) | [mq3.py](mq3.py), [ram_read.py](ram_read.py), [posthoc_mq3.py](posthoc_mq3.py) | `results/mq3/` |
| MQ4 | [PREDICTIONS-2026-10-20-MQ4.md](PREDICTIONS-2026-10-20-MQ4.md) | [mq4.py](mq4.py), [dev_mq4.py](dev_mq4.py), [posthoc_mq4.py](posthoc_mq4.py) | `results/mq4/` |
| MQ5 | [PREDICTIONS-2026-10-21-MQ5.md](PREDICTIONS-2026-10-21-MQ5.md) | [mq5.py](mq5.py), [dev_mq5.py](dev_mq5.py), [posthoc_mq5.py](posthoc_mq5.py) | `results/mq5/` |

Everything uses Python 3.11 and the standard library, on CPU; MQ1's gridworld learners take about 13 minutes over 12 cores. The data are not committed:
- **Yeast:** Dai et al. 2012, Zenodo record 5003142, CC0; the bifurcation archive's md5 is `3891af7573f1afa105d9bc1ce9f03f1b`.
- **Fish stocks:** RAM Legacy v4.66, Zenodo record 14043031, CC-BY-4.0; md5 `ed6d7cd3f7da1fdcbc60015c3d65014b`.

Extract each archive outside the repository, in its own directory, and read it with `python3 -I`.

```bash
python3 run.py all && python3 analyze.py && python3 run.py round2 && python3 analyze.py results/round2
```

```bash
python3 -I yeast_data.py /path/to/bifurcation
```

```bash
python3 -I mq2.py fit /path/to/bifurcation && python3 -I mq2.py test /path/to/bifurcation /path/to/saltshock /path/to/indicator
```

```bash
python3 -I mq3.py test "$RAM" && python3 -I mq4.py dev "$RAM" && python3 -I mq4.py test "$RAM" && python3 -I mq5.py dev "$RAM" && python3 -I mq5.py test "$RAM"
```

Here `RAM` is the path to `RAMLDB v4.66/Excel/RAMLDB v4.66 (assessment data only).xlsx`.
