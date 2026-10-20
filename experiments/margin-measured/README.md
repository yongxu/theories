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
| [PREDICTIONS-2026-10-20-MQ2.md](PREDICTIONS-2026-10-20-MQ2.md), [mq2.py](mq2.py), [posthoc_mq2.py](posthoc_mq2.py) | MQ2: the equation of state fitted on four dilution factors and tested on held-out regimes (four DFs, the salt shock, the indicator experiment). Frozen at `6deda4fb7` with the numerical predictions in `results/mq2/fit.json`, before any held-out value was read (`refs/salvage/mq2-freeze`; on main `bc45d668f`); post-hoc analyses (not verdicts) |
| [calibrate_yeast.py](calibrate_yeast.py), [calibrate_learners.py](calibrate_learners.py) | Test bed A's calibration (before the freeze); the post-hoc learner calibration on the reference variant (after round 1) |
| [results/](results/) | Round 1 (`*.json`, `VERDICTS.json`), round 2 (`round2/`), real data (`data/`: `VERDICTS-data.json`, the null, the post-hoc floor), `FROZEN-AT` |

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

For the theory: the margin is a measured equation of state for the need, across held-out regimes of one experiment. But the renewal curve is a function of the regime, the draw included, not of the level alone. The draw does more than remove: it lowers what is given back at the same level. Read in Lean terms, giving depends on the level and the standing draw, so a regime's need rises faster with the draw than removal alone accounts for. The margin-of-a-regime core module being built in the parent session should allow this.

## Limits

Test bed A is a simulation: the parameters are set from the paper's reported facts, not its table S1. Near the fold the model's fluctuations (CV 0.06 at DF 1400) are below the paper's (about 0.2). The culture volume is assumed. The hidden lag state of A1m is invented to give the test something to detect, not measured biology. Test bed B is deterministic and small (14 cells, horizon 45, two lawn cells). Its best responses are exact, and its learners are tabular with modest training. B6's environment did not create the end-of-coupling situation for the best response. On the real data, the population layout (same plate position = same population across days) is an assumption read from the files, since the README PDFs were not downloaded. D2's measurement floor was misjudged before the run, and the floor of 0.01 is post hoc in MQ1 (pre-registered in MQ2). MQ2's held-out bifurcation DFs had been read in MQ1, and the masked layouts of the salt-shock and indicator files showed exponent signs (disclosed in the MQ2 freeze). The salt-shock column order (DF 250, 500, 750, 825) is read from the paper's figure legend, and its day-5 reading is assumed to be the first after the shock day. Day 9 is only four days after the shock, too short to settle fates near the need. The two-phase class is Dai et al.'s. Their own full-diagram fit (table S1) was not available for comparison.
