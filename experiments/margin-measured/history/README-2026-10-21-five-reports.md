# The margin as a measured quantity

Board item MQ1, 20 October 2026. AI-written (a Claude Code session started from the significance-aim session). Study section 253 of [BECOMING-RENEWAL-READING](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#253-the-margin-as-a-measured-quantity-mq1). Literature check: [significance review, "the margin as a measured quantity"](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#margin-measured-check).

Thermodynamics became more than formal when temperature and heat became measured state quantities whose laws could fail. This experiment asks the same of the theory's margin: a renewable condition's slack above its need, depleted by the sum of all parts' net draws. It operationalizes the margin, freezes predictions from the laws written in it, and runs two test beds. The first is a microbial Allee system: a stochastic simulation set from Dai et al. 2012, and their published densities (via the Zenodo mirror of the Dryad record, approved by Ren). The second is an RL side-effect gridworld with renewable conditions. Every verdict is kept.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-20.md](PREDICTIONS-2026-10-20.md) | Step 0 literature table; the exact Lean content; the reading that sets what can be tested; bridges R, H1, H2; predictions A1-A4, D1-D2, B1-B7 with classes and pass rules. Frozen at `6b29f6ac0`, the commit round 1 ran from (kept as `refs/salvage/mq1-freeze-round1`; on main, rebased, `e6b456cfc`) |
| [PREDICTIONS-2026-10-20-DATA.md](PREDICTIONS-2026-10-20-DATA.md) | The real-data test: source checks, the layout read with digits masked, the implementation of D1-D2, a synthetic Markov null, and an addendum (D1′, D2′, an interpretation rule against the null). Frozen at `00d7408c4`, before any value was read (`refs/salvage/mq1-data-freeze`; on main `c242eb838`) |
| [PREDICTIONS-2026-10-20-ROUND2.md](PREDICTIONS-2026-10-20-ROUND2.md) | Round 2: two configuration corrections (A1's harvest beyond the margin; A3's unharvested first day), criteria unchanged; why no learner round. Frozen at `037683ad8`, the commit round 2 ran from (`refs/salvage/mq1-freeze-round2`; on main `0031223b3`), after round 1's results |
| [yeast.py](yeast.py) | Test bed A: the two-phase growth model, noise, and the measurements by intervention (pulse margin, largest sustained draw, break day, histories) |
| [garden.py](garden.py) | Test bed B: the lawn gridworld, exact best responses, tabular Q-learners, coupling by intervention, the margin law's band |
| [run.py](run.py), [analyze.py](analyze.py) | Frozen configurations and verdict rules |
| [yeast_data.py](yeast_data.py), [synth_null.py](synth_null.py), [posthoc_data.py](posthoc_data.py) | D1-D2 (and D1′, D2′) on the real data; the synthetic null; the post-hoc floor analysis (not a verdict) |
| [PREDICTIONS-2026-10-20-MQ2.md](PREDICTIONS-2026-10-20-MQ2.md), [mq2.py](mq2.py), [posthoc_mq2.py](posthoc_mq2.py) | MQ2: the equation of state fitted on four dilution factors and tested on held-out regimes (four DFs, the salt shock, the indicator experiment). Frozen at `6deda4fb7` with the numerical predictions in `results/mq2/fit.json`, before any held-out value was read (`refs/salvage/mq2-freeze`; on main `5cf9e9e9d`); post-hoc analyses (not verdicts) |
| [PREDICTIONS-2026-10-20-MQ3.md](PREDICTIONS-2026-10-20-MQ3.md), [mq3.py](mq3.py), [ram_read.py](ram_read.py), [posthoc_mq3.py](posthoc_mq3.py) | MQ3: the regime's step in the field, on 113 assessed fish stocks of the RAM Legacy database, against the frozen-rest reading. Frozen at `13af39133` with the presence-only layout and synthetic dry runs, before any time-series value was read (`refs/salvage/mq3-freeze`; on main `9e2e8ec2a`); post-hoc analyses (not verdicts) |
| [PREDICTIONS-2026-10-20-MQ4.md](PREDICTIONS-2026-10-20-MQ4.md), [mq4.py](mq4.py), [dev_mq4.py](dev_mq4.py), [posthoc_mq4.py](posthoc_mq4.py) | MQ4: a state of level and recent giving, on the 76 assessed stocks of the same database no analysis had read, with the frozen-rest margin's time to break. Frozen and landed on main at `bdb985ee3` with the presence-only layout, the development on MQ3's stocks and synthetic dry runs, before any value of the test stocks was read (`refs/salvage/mq4-freeze`); post-hoc analyses (not verdicts) |
| [PREDICTIONS-2026-10-21-MQ5.md](PREDICTIONS-2026-10-21-MQ5.md), [mq5.py](mq5.py), [dev_mq5.py](dev_mq5.py), [posthoc_mq5.py](posthoc_mq5.py) | MQ5: a lag and the draw's response, on the 69 assessed stocks with spawning biomass and catch that no analysis had read, the draw's share on the spawning stock fitted per stock. Frozen and landed on main at `e690d5062` with the presence-only layout, the development on MQ3's and MQ4's stocks and synthetic dry runs, before any value of the test stocks was read (`refs/salvage/mq5-freeze`); post-hoc analyses (not verdicts) |
| [calibrate_yeast.py](calibrate_yeast.py), [calibrate_learners.py](calibrate_learners.py) | Test bed A's calibration (before the freeze); the post-hoc learner calibration on the reference variant (after round 1) |
| [results/](results/) | Round 1 (`*.json`, `VERDICTS.json`), round 2 (`round2/`), real data (`data/`: `VERDICTS-data.json`, the null, the post-hoc floor), MQ2 (`mq2/`), MQ3 (`mq3/`), MQ4 (`mq4/`), MQ5 (`mq5/`), `FROZEN-AT` |

To reproduce (Python 3.11, standard library only, CPU; about 13 minutes over 12 cores, almost all of it test bed B's learners):

```bash
python3 run.py all && python3 analyze.py
```

```bash
python3 run.py round2 && python3 analyze.py results/round2
```

The real-data test needs Dai et al.'s `data_bifurcation.zip` (Zenodo record 5003142, CC0; md5 `3891af7573f1afa105d9bc1ce9f03f1b`), extracted outside the repository. The archives are not committed.

```bash
python3 -I yeast_data.py /path/to/extracted/bifurcation
```

MQ2 needs the three archives extracted, each in its own directory:

```bash
python3 -I mq2.py fit /path/to/bifurcation && python3 -I mq2.py test /path/to/bifurcation /path/to/saltshock /path/to/indicator
```

MQ3 needs `RAMLDB v4.66.zip` (Zenodo record 14043031, CC-BY-4.0; md5 `ed6d7cd3f7da1fdcbc60015c3d65014b`) extracted outside the repository:

```bash
python3 -I mq3.py test '/path/to/RAMLDB v4.66/Excel/RAMLDB v4.66 (assessment data only).xlsx'
```

MQ4 reads the same workbook (the development step reads MQ3's stocks only):

```bash
python3 -I mq4.py dev '/path/to/RAMLDB v4.66/Excel/RAMLDB v4.66 (assessment data only).xlsx' && python3 -I mq4.py test '/path/to/RAMLDB v4.66/Excel/RAMLDB v4.66 (assessment data only).xlsx'
```

MQ5 reads the same workbook (the development steps read MQ3's and MQ4's stocks only):

```bash
python3 -I mq5.py dev '/path/to/RAMLDB v4.66/Excel/RAMLDB v4.66 (assessment data only).xlsx' && python3 -I mq5.py test '/path/to/RAMLDB v4.66/Excel/RAMLDB v4.66 (assessment data only).xlsx'
```

## The reading that sets what can be tested

In the margin law (`Flow.Balances.loses_iff_beyond_margin`, `Flow.widens_iff_within_margin_at`), the levels without the part are the **withheld levels** (`Flow.WithheldLevels`): the part's exchanges removed, every other exchange held as it was. Under that counterfactual, laws (2) "draws on a shared condition add, time to break = margin / total net draw" and (3) "damage iff cumulative net draw exceeds the margin" are identities of the balance. That is SA1's near-definitional verdict, and test bed B's B1 confirms it in 456 records with no mismatch. An actual condition's renewal responds to its level, so the testable content lies in the margin **measured by intervention**, with the rest responding: the pulse margin (the largest one-shot removal the condition survives), the largest sustained draw Ŷ, the reward's coupling (the change in return when the condition is perturbed and the same actions are replayed), and blind draw (draw on a condition with zero measured coupling).

## Verdicts

Classes: *identity* (follows from what the system is built to meet), *identity in the deterministic limit* (tests the measured quantities under noise), *manipulation* (shows a test can fail), *law + bridge*, *beyond the law*.

| Prediction | Law | Class | Round 1 | Round 2 |
|---|---|---|---|---|
| A1 same margin, any history → same break-day distribution | margin as state | identity (Markov model) | passed, **degenerate** (H ≥ m₀: break at day 0 in every replicate) | **passed** (all KS p ≥ 0.75) |
| A1m with a hidden lag state, the test detects history | — | manipulation | failed, degenerate | **passed** (p to 1e-51) |
| A2 break day within [m₀/H − 1, (m₀ − H)/(H − Ŷ) + 1], m₀ by pulse, Ŷ by sustained draw | margin law + joint excess + R | identity in the deterministic limit | **passed** (22/22 cells; position in band 0.31-0.94) | (round 1's) |
| A3 the point of no return under a standing draw H exceeds need + H | margin law, responsive renewal | identity in the deterministic limit | failed 6/12 (**code grew one unharvested day first**) | **passed** (12/12; above need + H by 8,400-33,600 cells/µl) |
| A4a interaction of two harvesters' harms never sub-additive | concave renewal | beyond the law | **passed** (12/12) | — |
| A4b each within Ŷ, together beyond → super-additive | joint excess | law | **passed** (4/4; joint collapse 93-100%) | — |
| A4c joint within Ŷ → still super-additive | concave renewal | beyond the law | **passed** (8/8) | — |
| D1 on Dai et al.'s data: adding yesterday's density explains < 10% more of tomorrow's | (1) on real yeast | could fail | **passed** (8/8 DFs; at most 9.5%) | — |
| D2 on Dai et al.'s data: populations above 1.5û alive on day 7, below û/1.5 extinct (≥ 90% each) | (3) on real yeast | could fail | **failed** (6/6 testable DFs: 19-46% of low starters read > 0 on day 7); by the frozen interpretation rule, evidence against a sharp need at 5 DFs | — |
| D1′, D2′ (addendum: detection floor from negative readings) | the same | could fail | the floor came out 0 (no negative readings), so D1′ = D1 **passed** and D2′ = D2 **failed** | — |
| B1 level = l₀ − takes + regrowths; dead iff takes ≥ l₀ + regrowths | margin law, balance | identity | **passed** (0 mismatches, 456 records) | — |
| B2 replayed coupling: blind exactly 0, coupled > 0 | coupling | identity | **failed**: blind 0 everywhere, but 5 joint records with a coupled reward show 0 for a cell (see below) | — |
| B3 blind behaviour identical across margins | `Flow.act_unselected` + H1 | law + bridge | best response **passed**; learners **failed** (entries 5.0-6.95 against V0's 7.8) | not rerun |
| B4 side effects predicted out of sample from blind draw in V0 against each variant's margin | margin law + joint excess + B3 | law + bridge | best response **passed** (8/8 decided right, 8/8 deaths within band; the V0-outcome baseline 0/8); learners **failed** (80/151 right; 6/80 within band) | not rerun |
| B5 coupled draw adapts: all alive; binding cells left ≤ need + 1 | margin law, `OwnWidening` | law (+ H1, H2) | best response **failed** on one cell (V4's B left at 3: its route is shut by A); learners **failed** on the transfer clause (74% < 80%) while keeping 160/160 cells alive | not rerun |
| B6 step coupling: deaths only where the coupling's remaining reach < the gain | `Flow.act_unselected` | law | best response **failed, vacuous** (no death); learners **passed** (2 deaths, both at step 41 = H − 4) | — |
| B7 end-coupled agents trained alone, together, break a binding cell | joint excess, `mixed_of_tight` | law + bridge | best response **passed** (4/5); learners **failed** (6/50); band **failed** (3/13) | not rerun |

## What the results say

**The margin is measurable by intervention, and with one more measured number it bounds time to break whatever the history.** In the Allee system the need found by the pulse test matches the model's unstable fixed point (DF 1000: 4,128 against 4,149 cells/µl). The largest sustained draw found by intervention matches the model's maximal surplus (34,304 against 35,064). These two numbers bound the mean break day in every cell tested, across four dilution factors and two starting levels. History adds nothing when the system has no hidden state, and the same test detects a hidden lag state when one is added. This is the operational content of laws (1) and (2). It holds by the mathematics in the deterministic limit, so what the test shows is that the measurements work under noise, not new dynamics. The band is wide (its upper end is often several times its lower), and a point prediction needs the renewal curve: the equation of state, in the thermodynamic analogy.

**The need is the whole flow's, not the condition's alone.** Under a standing draw H, the point of no return rises by more than H: it is H plus the rising root of s(y) = H, not need + H. Measured: 1.4-4.1 times H above the need, rising with the dilution factor (DF 500 to 1400). "Margin = level − need" is a state quantity only with the need taken from the regime including the standing draws, as a boiling point is a state quantity only at a given pressure. Fisheries know this as depensation under harvest. The theory's frozen-rest margin hides it, because the withheld levels keep the rest's giving as it was.

**Draws add; harms do not.** The frozen-rest accounting adds draws exactly. The harm two harvesters do together exceeded the sum of their separate harms in all 12 cells: by about 20% where both drew 0.3Ŷ, and to total collapse where each was within Ŷ and together they were beyond it. The renewal curve is concave above its peak, so removal by one part steepens the cost of the other's draw. Harm attributed to parts by removal is not additive on a shared renewable condition. Law (2) holds for draws, not for the damage they cause. In the gridworld the same structure appeared post hoc: two end-coupled best responses, each well within the lawn's renewal alone in V0, killed both cells together.

**Blind draw predicts side effects for an ideal optimizer, not for these learners.** Measured in the ample-margin variant, where nothing dies, the best response's blind draw predicted which cells die in the five thin-margin variants and when (8/8, all within the band). Predicting from the reference outcome scores 0/8. With a coupled reward the best response kept every cell alive, leaving every route-limiting cell (six cells) at level 1, exactly the gate's need: the margin spent to zero, the tight case of `Flow.Balances.mixed_of_tight`. Tabular learners did not transfer. Their reward is blind, but they observe the lawn, and in variants where its state varies more their experience is spread over more states. They wander more, deliver less, and so draw less: of 80 observed deaths, 71 came after the band's upper end and 3 before its lower end, and in V1 and V2 no cell died at all. That is H2 (learners far from the best response: 5-7.75 deliveries against 9), not selection. Each policy's own entries still place every death within its band (80/80). Blindness of the selection signal makes draw margin-independent under selection; a learner that sees the condition is margin-dependent through its own coverage.

**Coupling measured by intervention is a property of a course.** B2 failed because the measure replays one course: along five joint courses the agent's own actions killed a cell whatever its start level, so changing the level changed no return, though the reward reads the cell. The theory's coupling is also along a course. The failure is in the prediction's wording ("> 0 in every record"), and it shows the measurement needs perturbations the course does not saturate.

**On real yeast, density carries the history, and the need is sharp except next to the fold, once the instrument's floor is read.** In Dai et al.'s published densities (88 populations at each of eight dilution factors, seven days), adding yesterday's density to a cubic in today's explains less than 10% more of tomorrow's at every dilution factor (D1, passed). D2 failed as frozen: 19-46% of populations starting below û/1.5 still read above zero on day 7. Post hoc ([`posthoc_data.py`](posthoc_data.py), not a verdict), the cause is the instrument. Readings are quantized at 0.001 (in the files' units, which match the paper's 10⁵ cells/µl), and wells that never regrow keep reading 0.001-0.009 for all seven days. My addendum keyed the floor to negative readings, and there are none. With a floor of 0.01, every low starter is extinct at five of six testable dilution factors and the high starters are alive (93-100%). The need fails to separate fates only at DF 1600, next to the fold (87.5%), where the paper itself reports replicates near the threshold splitting. A noise-matched Markov null passes everything under the same floor. One more post-hoc point: the real D1 reductions (up to 9.1%, at DF 1400) are well above the null's (at most 0.6%), though below the frozen 10%. Yesterday's density carries some information beyond today's. Whether that is biology (lag, physiology) or a measurement model the null does not share is open.

**Whether the margin is a measurable state quantity.** Yes, in a qualified sense. It can be measured by intervention, and with the largest sustained draw it bounds time to break independently of history wherever the condition's state is its level (A1, A1m, A2). Three qualifications. Its need depends on the standing draws, so it is a state quantity of the regime, not of the condition alone (A3). Damage on it does not add across parts (A4). On real yeast, density carries the history to within 10% (D1), and the need separates fates sharply except next to the fold, but only once the instrument's floor is read (D2 failed as frozen and holds post hoc). On the alignment side, blind draw against margin predicts side effects for an optimizer (B4), and coupling makes the optimizer spend the margin down to need (B5). Both depend on the optimizer actually optimizing.

## Corrections after the freeze

1. A1 and A1m (round 1) were degenerate: the frozen harvest 1.5Ŷ was at least the starting margin m̂/2. A2's applicability guard (H < m₀) was missing from A1. Round 2 fixed the configuration only.
2. A3 (round 1) measured a protocol with one unharvested day before the standing harvest, unlike the prediction's wording. Round 2 harvests from day 0.
3. The data addendum (`PREDICTIONS-2026-10-20-DATA.md`) explained the synthetic null's D1 failure at DF 250 as cubic misfit. Post hoc it vanishes with a floor of 1000 cells/µl, so it came from noisy low readings, not misfit.
4. No learner round 2: a calibration on the reference variant only (6 seeds per setting) found no setting reaching the best response, so a rerun would test H2 again.
5. Round 1's verdicts stand as frozen; each round's run commit is in `results/FROZEN-AT`. Those are the commits before the rebase onto main, kept reachable as `refs/salvage/mq1-*`; the rebased commits on main are listed in the file table above.

## MQ2: the equation of state against held-out regimes

Board item MQ2, 20 October 2026; study section 266. MQ1 found that a point prediction needs the renewal curve. MQ2 fits one daily growth map G on DF 250, 500, 1000 and 1266 of Dai et al.'s bifurcation data, with n_{t+1} = G(n_t / DF) and the dilution as the standing draw. From G alone it predicts each regime's need û(DF), level s(DF) and margin s − û, then tests them on regimes G was not fitted on:
- DF 750, 1133, 1400 and 1600 of the same experiment, which I had already read in MQ1, so held out from the fit, not from the analyst;
- the salt-shock experiment (DF 250, 500, 750 and 825), unread before the run;
- the indicator experiment (all eight DFs at equilibrium), unread before the run.

The class is Dai et al.'s two-phase growth, against a logistic no-need null. The floor of 0.01 is now pre-registered.

| Prediction | Result |
|---|---|
| M: G beats the no-need null on held-out one-day transitions | **passed** (RMSE 0.294 against 0.355; better at all four held-out DFs) |
| A1: the predicted need separates fates (≥ 90% each side, outside a factor 1.5) | **passed** at the three testable DFs (1133: 93% and 94%; 1400 and 1600: 100% and 100%). DF 750 has no low group above the floor. The null classifies 68-81% |
| A2: the predicted need within a factor 1.5 of the need measured from fates | **passed** (û/u* = 0.81, 1.26, 0.79 at DF 1133, 1400, 1600) |
| B2: the measured need rises with the draw | **passed** (u* = 0.041, 0.043, 0.094 at DF 1133, 1400, 1600) |
| B1: the fold | reported only: G puts it at DF 2797 [2719, 2899], far past the paper's collapse beyond 1600 |
| S: the level in the indicator experiment within a factor 1.5 at all eight DFs, and no worse than the null | **failed**: within 1.1 up to DF 1266, 1.26 at 1400, 1.52 at 1600, and the null's summed error is smaller (0.59 against 0.79) |
| S2: the day-7 level of held-out bifurcation populations within 1.5 | **failed** (1.03, 1.02, 1.30, then 1.55 at DF 1600) |
| C1: after the salt shock, alive on day 9 iff the day-5 density > û(DF) | **failed**: accuracy 0.78, no better than the null. At DF 825, 7 of 8 died from post-shock densities 0.021-0.030, above the predicted need 0.016 |
| C2: the same with day 6 | **failed** (0.81 against the null's 0.78) |
| D: time to break after the DF passes the fold | not testable: no run in these data passes the fold |

**What it says.** The equation of state measured on some regimes predicts the **need** of held-out regimes of the same experiment, including those next to the fold. This is the margin's lower edge, and it is what separates survival from extinction there. It beats a model with no need by 18-30 points of accuracy. It fails on the **level** near the fold, and it fails on the **need after a shock in a separate experiment**. Post hoc ([`posthoc_mq2.py`](posthoc_mq2.py), [`results/mq2/posthoc-mq2.json`](results/mq2/posthoc-mq2.json), not verdicts), both failures have one source: G is not one function of density.
- **P1.** At equal start density, per-capita daily growth falls with the dilution factor as DF^(−0.31 ± 0.01) (1,465 low-density pairs). Between DF 250 and 1600 that is a factor of 2-2.7. So the draw lowers renewal beyond removing cells. Carryover of hexose or invertase with the transferred culture would do this; that is not tested here. A fit on low-DF regimes therefore overstates renewal near the fold, which is why the fold lands near 2800 and the level comes out too high.
- **P2.** Letting G's low-density rate fall with DF (one more parameter, fitted on the fit set only) lowers the held-out RMSE (0.269) and brings the fold to DF 2086. It puts the levels at 1400 and 1600 within 1.1 and 1.2, but overshoots the need at 1400 (û/u* = 1.9).
- **P3.** The salt-shock experiment's pre-shock levels are 8-20% below the bifurcation experiment's at every DF, so its regime differs too. Locating each column on the frozen G by its own pre-shock level gives needs of 0.035 at DF 750 and 0.046 at DF 825. That is right for 7 of 8 populations at 825, wrong for 5 of 8 at 750: there the populations hover at 0.02-0.16 for the four days left and are alive on day 9 without recovering. A slow return near the need is what a fold predicts, so four days do not settle the fates near the threshold.

For the theory: the margin is a measured equation of state for the need, across held-out regimes of one experiment. But the renewal curve is a function of the regime, the draw included, not of the level alone. The draw does more than remove: it lowers what is given back at the same level. Read in Lean terms, giving depends on the level and the standing draw, so a regime's need rises faster with the draw than removal alone accounts for. The margin-of-a-regime core module (board item RM1, `Becoming.RegimeMargin`, being built) should allow this.

## MQ3: the margin of a regime in the field

Board item MQ3, 20 October 2026; study section 272. RM1 put the regime's step on the spine (`Becoming.RegimeMargin.step g H x = (x - H) + g (x - H)`). MQ3 reads it in a fishery:
- the year's catch is the draw;
- the escapement E = TB − C is what is left;
- the observed surplus production SP_t = TB_{t+1} − E_t is the giving.

A giving law g(E) = aE + bE² (through the origin) is fitted on each stock's first 60% of years and tested on the rest. It competes with the theory's own frozen-rest reading (giving held at its last observed value), with momentum and with persistence.

The data are the RAM Legacy Stock Assessment Database v4.66, with TB and catch in tonnes from each stock's most recent assessment, over at least 25 consecutive years. The stocks fall into three groups:
- 113 primary stocks (age- or length-structured, integrated and VPA assessments);
- 22 production-model assessments as a positive control;
- 52 of unknown method.

Rules, code, a presence-only layout and synthetic dry runs were committed before any value was read. The dry runs showed the rules pass when giving is read off the level and fail under productivity regimes.

| Prediction (primary group) | Result |
|---|---|
| F0: last year's escapement adds < 0.10 of the residual variance beyond chance | **failed**: median 0.22; residual lag-1 autocorrelation 0.55 |
| F1: one year ahead, the regime margin calls TB's direction at ≥ 0.60 and better than the frozen rest and momentum | **failed**: 0.64 against 0.77 and 0.75 (2,483 origins) |
| F2: five years ahead, better direction and smaller log error than the frozen rest and persistence | **failed**: 0.62 against 0.68 (momentum 0.61); median log error 0.30 against 0.19 and 0.19 |
| F3: under a held catch, ≥ 80% below the regime's point fall and ≥ 90% above hold | **failed**: 63% of 754 below fell (43% at every step); 99.5% of 425 above held |
| F4 (descriptive): giving at equal escapement against the recent exploitation rate | rises with it in 76 of 113 stocks (p = 0.0003), the opposite of MQ2's direction |

The control and the unknown-method group fail the same way. In the control the frozen rest scores 0.82 (one year) and 0.73 (five years), against the regime margin's 0.63 and 0.60.

**Post hoc** ([`posthoc_mq3.py`](posthoc_mq3.py), [`results/mq3/posthoc-mq3.json`](results/mq3/posthoc-mq3.json), not verdicts):
- **In sample.** Fitted on every year, the level law still loses to the frozen rest: 0.68 against 0.77 at one year; at five years 0.67 against 0.68, with log error 0.21 against 0.19.
- **Inside the training range.** It also loses inside the training range of escapement, so neither extrapolation nor a change across the split explains the failure.
- **Other readings.**
  - Refitting at every origin does not help.
  - The level law plus a persisting anomaly comes in between.
  - Giving read off TB before the draw (the usual production-model order) changes little out of sample.
- **The regime point.** Below the regime's point but within giving, 57% of held-catch episodes fell, so the point does not separate fates.

**What it says.** In assessed fish stocks, giving is not read off the level over one to five years. The stock's state carries its recent giving, and the frozen-rest reading is the better forecast because giving persists. MQ1 had found that same reading to be accounting on a model. So the regime margin is a measured state quantity in the lab (MQ2: the need of held-out regimes) but not in these field data. RM1's premise, "giving a function of what is left, within a regime", fails where the regime itself moves on the forecast's timescale.

Two things limit the reading:
- **Assessed biomass is a model output.** The test years are held out from the giving law's fit, not from the assessment, and smoothed recruitment deviations favour persistence.
- **The control failed too.** So the frozen reading (draw first, quadratic) does not recover even a production model's dynamics out of sample.

F4's sign differs from yeast. Giving rises with recent exploitation, which fits compensation through a younger stock and also fits assessment artefacts; these data cannot separate the two.

## MQ4: a state of level and recent giving in the field

Board item MQ4, 20 October 2026; study section 277. MQ3 found that in assessed fish stocks giving persists beyond what the level gives. MQ4 tests whether a stock's state is its level plus its recent giving:

SP_t = φ SP_{t−1} + (1 − φ) g(E_t).

- **The two ends.** φ = 1 is the frozen rest and φ = 0 the regime's step, so the theory's two readings are the ends of one law.
- **φ.** It was chosen once on MQ3's stocks and frozen at 0.96: giving closes 4% of its gap to the level's law each year, a half-life of about 17 years.
- **The time to break.** MQ4 also tests the frozen-rest margin's time to break. Every exchange is held as at the origin, and the margin above half the level is divided by the net draw.

The test stocks are those no analysis had read: 76 primary stocks, with 11 production-model controls and 92 assessments of unknown method reported. Each is a current stock whose most recent assessment lacks TB or catch in tonnes, read from an earlier assessment of the same stock. Rules, code, the presence-only layout, the development on MQ3's stocks and the dry runs were committed and landed on main before any value was read (freeze `bdb985ee3`). In the dry runs, every verdict passed only where the state is level plus recent giving. Two rules were changed after the first dry run, before any test value, as the freeze records.

| Prediction (primary group, 76 stocks) | Result |
|---|---|
| G1: recent giving is part of the state (adding SP_{t−1} to the level law removes a median ≥ 0.10 of the residual variance beyond chance) | **passed** (0.45) |
| G2: the level is part of the state given recent giving (its F test fires in ≥ 20% of stocks, beyond chance) | **passed** (44 of 76; binomial p ≈ 10⁻³⁷) |
| G3: nothing more is needed (adding SP_{t−2}, E_{t−1}, E_{t−1}² removes a median < 0.10) | **failed** (0.12) |
| F1b: one year, smaller error than the frozen rest, the regime margin and persistence, and smaller than the frozen rest's in most stocks | **passed** (median \|log error\| 0.021 against 0.022, 0.058 and 0.043; 63 of 76 stocks, p = 5 × 10⁻⁹). Direction, reported only: 0.783 against 0.781 |
| F5a: five years, the direction better than the frozen rest, the regime margin and momentum | **failed** (0.678 against 0.695, 0.633 and 0.607; 1,474 origins) |
| F5b: five years, smaller error | **passed** (0.148 against 0.154, 0.270 and 0.153; 56 of 76 stocks, p = 4 × 10⁻⁵) |
| F10a: ten years, the direction | **failed** (0.653 against 0.663, 0.634 and 0.576) |
| F10b: ten years, smaller error | **failed** (0.304 against the frozen rest's 0.309, but persistence's 0.215; 47 of 76 stocks, p = 0.050) |
| T1: the frozen-rest time to break ranks the risk (the share falling below half within ten years falls across n̂ ≤ 5, 5-10, 10-20 and > 20 years) | **passed** (0.32, 0.15, 0.09, 0.03) |
| T2: at least half of the origins with n̂ ≤ 5 break within ten years | **failed** (47 of 149, 0.32) |
| R1: MQ3's finding on new stocks (the frozen rest beats the regime margin at one and five years) | **passed** (direction 0.78 against 0.62 and 0.69 against 0.63; error 0.022 against 0.058 and 0.154 against 0.270) |
| R2: MQ3's F4 on new stocks (giving at equal escapement rises with recent exploitation) | **passed** (60 of 76, p = 4 × 10⁻⁷) |

**The other groups.**
- **MQ3's own rules** (F0-F3) fail on these stocks as they did on MQ3's, in the primary group and the control.
- **The control** (11 production-model assessments) passes G1, G2, T1, R1 and R2 and fails G3 and T2. There the frozen rest forecasts best at every horizon.
- **The group of unknown method** (92 assessments) passes G1-G3, T1 and R2 and fails T2 and every forecast verdict. There persistence has the smallest error at five and ten years, and R1 fails at five years (the regime margin's direction 0.60 against the frozen rest's 0.59).

**Post hoc** ([`posthoc_mq4.py`](posthoc_mq4.py), [`results/mq4/posthoc-mq4.json`](results/mq4/posthoc-mq4.json), not verdicts):
- **Discordance.** LG and the frozen rest call the five-year direction differently at 77 of 1,474 origins, and the frozen rest is right at 51 of them. LG's smaller errors come from the origins where the two agree. A pull toward the level law strong enough to reverse the recent giving is usually wrong.
- **What G3 lacks.** Most of G3's excess comes from last year's escapement (median 0.05 alone), little from the giving two years before (0.01). That is a lag, as an age structure gives.
- **The draw responds.** Next year's catch follows the last change in biomass in 70 of 76 stocks (median elasticity 0.81). Where the frozen rest put a break within five years, the next five years' catches were cut to a median of 0.69-0.73 of the origin's catch, whether or not the break came.
- **φ on the test stocks.** The φ that fits them best at five years is 0.96, the frozen value. The minimum is shallow: 0.148, against 0.149 at 0.95 and 0.97 and the frozen rest's 0.154.

**What it says.**
- **Both variables are part of the state.** On stocks no analysis had read, recent giving is needed beyond the level (G1, as in MQ3), and the level is detectably needed beyond recent giving (G2).
- **The level's pull narrows errors.** Giving relaxing toward the level's law at about 4% a year has smaller errors over one and five years in most stocks, and the rate chosen on MQ3's stocks is the best rate on these.
- **But the pair is not the whole state.** Last year's escapement still adds (G3). The pull does not improve the direction of the forecast. At ten years nothing built from the state beats the level staying where it is.
- **The draw is not held either.** Catches follow the stock. So the frozen-rest margin over the net draw ranks the risk of a break (T1), but it is not a time to break (T2).

For the theory: the regime's step and the frozen rest are two ends of one law, and these stocks sit near the frozen-rest end. The regime's level law acts as a slow pull, seen in errors and in most stocks, not as the state. In managed stocks neither part of the rest stays frozen: the giving moves with the regime, and the draw follows the stock. The state needs at least the level, the recent giving and a lag.

Three things limit the reading:
- **The series are assessment outputs**, as in MQ3, here from earlier assessments.
- **Origins overlap** within a stock, so the pooled shares count dependent years.
- **φ is pooled.** A φ per stock, or one that changes with the regime, is not tested.

## MQ5: a lag and the draw's response in the field

Board item MQ5, 21 October 2026; study section 280. MQ4 left two things open:
- last year's escapement still added to its state of level and recent giving;
- at ten years "the level stays where it is" (persistence) beat every forecast from the state, while the catch followed the stock.

MQ5 tests both on the stocks no analysis had read, which carry spawning biomass (SSB) and catch:

γ_t = φ γ_{t−1} + (1 − φ) g(E_t) + λ (E_{t−1} − E_t),  C_t = C_{t0−1} (x_t / x_{t0−1})^ε.

- **The lag is giving moving toward the draw.** The level changes by giving less the draw, so E_{t−1} − E_t = H_t − γ_{t−1}.
  - A giving that reads last year's escapement is therefore a giving that reads this year's draw. Three readings give that one dependence: an age structure, the other order of draw and giving, and MQ3's compensation. The test does not separate them.
  - At a fixed point the lag vanishes. Every rest of the state at or above the draw is then RM1's regime point: RM2 proves this in whole numbers for every adjustment of giving that rests at the draw where the regime does (`RegimeMargin.Adjusted.rests_iff`, study section 299). RM3 proves that every run within a band comes to rest, at the regime's point or below the draw, where the adjustment rises with what is left and with the recent giving (`RegimeMargin.Adjusted.comes_to_rest`, study section 300). MQ5's law weighs the recent giving by 0.41 and the regime's giving by 0.04, so it rises in both exactly where the regime's giving rises with what is left, which is not checked on the data. RM4 proves that under such an adjustment the point of no return is a curve in the plane of level and recent giving: for each recent giving the runs resting below the draw are exactly those from levels below a least level, which does not rise as the recent giving rises (`RegimeMargin.Adjusted.falls_iff_below`, `RegimeMargin.Adjusted.threshold_falls`, study section 301). At a fixed level, less recent giving never turns a fall into a hold: the direction an AI reading of F3's failure predicted, here deterministic and within a band; how often it separates fates in the field is untested. RM5 shows that none of these laws needs counted amounts: over the reals every run within a band converges, to a rest where the adjustment is continuous, with the fates below the draw down-closed and fewer as the recent giving rises (`RegimeReals`, study section 302).
  - φ = 0.96 is MQ4's. λ = 0.55 was chosen on MQ3's and MQ4's stocks and frozen.
- **The draw as a law of the stock.** No future catch is used.
  - ε = 0 holds the draw (the frozen rest). ε = 1 holds the exploitation rate.
  - ε = 0.7 was measured on the development stocks and frozen.
- **The reading.** SSB and catch are not on one scale.
  - The level is SSB, and the draw on it is a share κ of the catch, fitted per stock on its training years.
  - κ is weakly identified: a wrong κ adds the same column as the lag. So the in-sample tests are robust (HC3), with a free shift of κ in the base model.

The test stocks are 69 primary stocks, 5 production-model controls and 24 of unknown method. Each is a current stock outside MQ3's and MQ4's, mostly from its most recent assessment (CASAL 25, SS3 11, SCA 7, VPA 6, ASAP 5, others).

Rules, code, the presence-only layout, the development and the dry runs were committed and landed on main before any value was read (freeze `e690d5062`).
- In the dry runs (ten generators), every rule passed where the hypothesis holds, in both readings, and each null failed a rule.
- With 2% year-to-year noise in the SSB share, S2 and D2 failed in the SSB reading. That limit was fixed before the run.

| Prediction (primary group, 69 stocks) | Result |
|---|---|
| S1: MQ4's state on new stocks (recent giving beyond the level, and the level beyond recent giving, each detected by its robust test in ≥ 20% of stocks, beyond chance) | **passed** (recent giving in 47 of 69, the level in 33; recent giving's median excess 0.40) |
| S2: the lag is part of the state (E_{t−1}, E_{t−1}² added to E_t, E_t², γ_{t−1}, detected beyond chance) | **passed** (14 of 69, binomial p = 7 × 10⁻⁶; median excess 0.054) |
| S3: nothing more is needed (adding γ_{t−2}, E_{t−2}, E_{t−2}² to the state with the lag removes a median < 0.10) | **passed** (0.059; MQ4's G3 in this form, without the lag, 0.128) |
| S4: the lag in the forecast (at five years the state with the lag beats MQ4's state) | **passed** (median \|log error\| 0.194 against 0.211; smaller in 50 of 69 stocks, p = 2 × 10⁻⁴) |
| P1: persistence wins at ten years (MQ4's F10b, retested) | **passed** (0.324 against MQ4's state's 0.477) |
| P2: the lag closes at least half of the gap between MQ4's state and persistence at ten years | **passed** (1.04: 0.318 against persistence's 0.324) |
| D1: the draw follows the stock (the change in log catch on the change in log SSB, with the catch's last level; positive in more stocks than not) | **failed** (36 of 67, p = 0.63; median slope 0.11) |
| D2: the draw's law closes at least half of the gap between the held draw and persistence at ten years | **failed** (0.45: 0.460 against the held draw's 0.571 and persistence's 0.324) |

**Reported (not verdicts).**
- With both the lag and the draw's law, the forecast does not beat persistence at ten years (0.327 against 0.324; better in 29 of 68 stocks). The state with the lag ties it (34 and 34).
- The lag fits better than the other order in 29 of 69 stocks.
- The fitted κ has quartiles 0.05, 0.45 and 0.75.
- **The group of unknown method** (24) fails S1 (the level detected in 3), S2 (4, p = 0.03) and D1 (17 of 24, p = 0.06), and passes S3, S4, P1, P2 and D2.
- **The controls** (5) are not testable.

**Post hoc** ([`posthoc_mq5.py`](posthoc_mq5.py), [`results/mq5/posthoc-mq5.json`](results/mq5/posthoc-mq5.json), not verdicts):
- **Why D1 fails where MQ4's form holds.** Three forms of the same regression give different answers:
  - Without the catch's own last level, the same year's change in catch follows the change in SSB in 55 of 67 stocks (median 0.49).
  - Next year's change on this year's (MQ4's form) follows it in 60 of 67.
  - With the catch's last level, only 36 of 67 follow it. That level's coefficient is negative in 58 of 67 (median −0.18): the catches revert to their own level.

  The dry runs showed that a catch blind to the stock and reverting to its own mean gives MQ4's form a positive slope. The split by region below shows where D1's form fails and why.
- **The draw's elasticity on the test stocks** is 0.37 (6,560 pairs), against 0.67 on the development stocks.
  - D2's share would be 0.29 at ε = 0.35, 0.51 at 1.0 and 0.67 at 1.5.
  - In the 46 stocks with κ > 0.1, where the catch enters the forecast, D2's share is 0.54. D1 there is 23 of 45. Part of D2's shortfall is the SSB reading's limit; D1's is not.
- **λ on the test stocks.** The best is 0.35 (0.183 at five years), against the frozen 0.55 (0.194) and persistence's 0.197.
- **Damping alone does as well.** A net change decaying by half a year, with no level and no lag, has 0.186 at five years and 0.304 at ten, against the lag's 0.194 and 0.318. The lag is better in 30 of 69 and 27 of 68 stocks (not significant). The lag's forecast gain cannot be told from damping; its specific evidence is in sample (S2, S3).
- **The lag in sample.** Per stock, giving on E_t, γ_{t−1} and E_{t−1} without squares has medians −0.31, 1.03 and +0.28 (E_{t−1} positive in 53 of 69). On the development stocks it was −0.29, 1.00 and +0.29. By the balance, giving closes about 0.3 of its gap to the draw each year, the same on stocks no analysis had read.

**Why D1 and D2 failed** (post hoc, asked after the run: [`posthoc_mq5.py why`](posthoc_mq5.py), [`results/mq5/why-d1-d2.json`](results/mq5/why-d1-d2.json), not verdicts). Half the test stocks are New Zealand's: 34 of 69, 25 of them CASAL assessments, mostly long-lived species. The development set had 10 of 142.

- **D1 fails on the New Zealand stocks, through the series' timing.**
  - The reading takes year t's draw from the level reported for year t, so year t's catch should not lower that level. Per stock, the level's change from t − 1 to t is regressed on year t's catch and on year t − 1's catch.
    - Outside New Zealand, year t's catch lowers it in only 6 of 35 stocks, and year t − 1's in 30.
    - In New Zealand, year t's catch lowers it in 19 of 34. These series report spawning biomass after part of the year's catch (mid-season, as New Zealand assessments commonly report it; from memory, not checked against the assessments).
  - There, a bigger catch lowers the same year's level, so D1's same-year slope is negative: positive in 8 of 33, p = 0.005. The development set's New Zealand stocks show the same (3 of 10).
  - Outside New Zealand, D1 passes: 28 of 34, p = 0.0002, elasticity 0.65, as in development (0.68).
  - On synthetic stocks whose catch follows the level exactly (the hypothesis), reporting the level after half of the year's catch turns D1 negative: 34 of 143 positive, median −0.49. After all of it, 1 of 144. The same shift pushes the fitted κ toward 0.
  - So the catch does follow the stock. D1 failed because the frozen reading assumed every series reports the level before the year's catch, and half the test stocks do not.
- **D2 fails because the gap it measures is the giving's, not the draw's.** At ten years, held draw against persistence, outside New Zealand:
  - The actual catches close only 12% of the gap (11% in development): the held-draw forecast fails mostly through MQ4's giving, not through the catch.
  - The draw's law closes 46% (66% in development). It closes more than the actual catches do because it damps the forecast's own error. When the forecast level falls, the law cuts the catch, and forecasts collapsing to the floor drop from 63 to 28 (development: 360 to 149).
  - In absolute terms the damping is about the same as in development (0.19 against 0.18 of median log error). The test stocks' gap is larger (0.41 against 0.26), so its share falls below half.
  - With the lag in the giving, the held draw, the draw's law and the actual catches give the same ten-year error (0.39, 0.36 and 0.37 outside New Zealand; 0.32, 0.32 and 0.31 in development).
  - In New Zealand, D2's share is 0.55.
- **S2 and S4 rest on different halves.**
  - The lag is detected in sample in 10 of 34 New Zealand stocks, against 4 of 35 elsewhere (p = 0.10). Its median coefficients are the same in both halves.
  - The lag's five-year gain comes from outside New Zealand (30 against 5 stocks); New Zealand splits 20 against 14.
  - On synthetic stocks, reporting the level after part of the catch hides a true lag (20 detected falls to 8 at half the catch). Without a lag, it produced detections in at most 18 of 149 stocks (12%). It also produced S4's gain without a lag (32 against 5, all of the catch).
  - So New Zealand's detections are above what the timing alone produced in these generators, though it may contribute. The gain outside New Zealand is not a timing effect.

**What it says.**
- **The state is the level, the recent giving and the lag.** The lag is detected beyond chance, and with it nothing more is needed in the median stock: MQ4's remainder of 0.128 falls to 0.059. Read through the balance, giving moves toward the draw at about 0.3 a year in sample, with the same coefficients in both halves and in development.
  - The detection rests mostly on New Zealand's stocks, whose series timing is off by part of a year.
  - The forecast gain rests mostly on the others.
- **The catch follows the stock where the series let it be read.** Outside New Zealand, D1's form holds as in development. In New Zealand the level is reported after part of the year's catch, and D1's form reads the catch lowering the level.
- **The lag accounts for persistence's ten-year win; the draw's response does not.** Knowing the actual catches closes little of the held draw's ten-year gap. The draw's law closes more only by damping the forecast's own error. Once giving moves toward the draw, how the draw is read makes no difference at ten years.
- **Persistence is still not beaten.** Damping alone forecasts as well as the lag.

For the theory: of the frozen rest's two held exchanges, both move in these stocks.
- **Giving moves toward the draw**, so the level's net change shrinks year by year, and a stock under a steady draw changes little. That fits MQ4's finding that the margin over the net draw ranks the risk of a break but overstates it (T2).
- **The draw follows the stock** where the series let it be read.
- **The giving carries the ten-year forecast.** Once giving moves toward the draw, it does not matter whether the draw is held, follows the stock, or is known.

Five things limit the reading:
- **The series are assessment outputs.** Most come from age-structured models (CASAL, SS3) whose own structure carries a recruitment lag, so the lag may partly be the assessment model's.
- **The series' timing differs by assessment.** The frozen reading took every level as reported before the year's catch. Half the test stocks report it after part of the catch, which turns D1's form, moves κ, and may add to the lag's detection.
- **κ is weakly identified.** A third of the stocks fit κ ≤ 0.1.
- **λ and ε differ on the test stocks.** Both were chosen on the development stocks, and the test stocks prefer 0.35 and 0.37 (0.65 outside New Zealand).
- **Origins overlap** within a stock.

## Limits

Test bed A is a simulation: the parameters are set from the paper's reported facts, not its table S1. Near the fold the model's fluctuations (CV 0.06 at DF 1400) are below the paper's (about 0.2). The culture volume is assumed. The hidden lag state of A1m is invented to give the test something to detect, not measured biology. Test bed B is deterministic and small (14 cells, horizon 45, two lawn cells). Its best responses are exact, and its learners are tabular with modest training. B6's environment did not create the end-of-coupling situation for the best response. On the real data, the population layout (same plate position = same population across days) is an assumption read from the files, since the README PDFs were not downloaded. D2's measurement floor was misjudged before the run, and the floor of 0.01 is post hoc in MQ1 (pre-registered in MQ2). MQ2's held-out bifurcation DFs had been read in MQ1, and the masked layouts of the salt-shock and indicator files showed exponent signs (disclosed in the MQ2 freeze). The salt-shock column order (DF 250, 500, 750, 825) is read from the paper's figure legend, and its day-5 reading is assumed to be the first after the shock day. Day 9 is only four days after the shock, too short to settle fates near the need. The two-phase class is Dai et al.'s. Their own full-diagram fit (table S1) was not available for comparison. MQ3's field series are assessment outputs, not measurements; most of the database (stocks with spawning biomass only) is not used; one giving class and one split were frozen. MQ4's test stocks are read from earlier assessments of current stocks, so their series end earlier than MQ3's; the 92 assessments of unknown method are reported, not tested; survey series (measured, with catchability unknown and noise that makes one-year giving anticorrelated) are not used. MQ5's test stocks carry spawning biomass, not total biomass, so the draw's share on the spawning stock is fitted per stock and weakly identified, which bounds the lag test's power and, where the share is near zero, keeps the catch out of the forecast; the lag found there may partly be the structure of the assessment models (mostly age-structured) that produced the series.
