# MQ2: the margin's equation of state on real yeast, against held-out regimes. Frozen 20 October 2026

Board item MQ2. AI-written. This file, [`mq2.py`](mq2.py) and the fit with its numerical predictions ([`results/mq2/fit.json`](results/mq2/fit.json)) are committed before the test step reads any held-out value. The verdicts are kept whatever they are.

## The question

MQ1 measured the margin by intervention in simulation and found that a point prediction needs the renewal curve (the equation of state) and that the need belongs to the regime (condition plus standing draw), not to the condition alone. MQ2 asks whether one renewal curve, measured on some regimes of real yeast, predicts the need, the level, and the fate after a shock in regimes it was not fitted on.

In Dai et al.'s serial-dilution system the draw is the daily dilution: n_{t+1} = G(n_t / DF), where n_t is the density at the end of day t's growth and G is the daily growth map. One G, fitted once, gives every regime's state:
- the need û(DF), the lowest unstable fixed point of n ↦ G(n/DF);
- the stable level s(DF);
- the margin s − û;
- the fold DF* = max_x G(x)/x, past which there is no positive state.

## Data and what has already been seen

- **Source.** Zenodo record 5003142, Dai, Vorselen, Korolev and Gore (2012), already downloaded and checked for MQ1 under Ren's approval of that mirror. Nothing new was downloaded. The files are read with `python3 -I` from outside their directories.
- **Bifurcation files** (eight DFs, 88 populations each, days 1–7). These are **not blind**. MQ1 read them through D1, D2 and the post hoc floor analysis. That analysis gave the per-DF cubic needs, and the fact that at a floor of 0.01 low starters are extinct at five of six testable DFs and fail only at DF 1600 (87.5%). So the held-out DFs here are held out from the fit, not from the analyst.
- **Salt-shock and indicator files.** These are unread except for their masked layout:
  - salt shock: `saltshock_day{1..9}.txt`, 8 lines × 4 numbers;
  - indicator: `all_dilution{DF}.txt`, 80 lines × 5 at DF 250 and 48 lines × 5 at DF 1600; `subset_*` files have fewer lines at some DFs.
  - **Disclosure.** The mask replaced digits but kept the signs of the exponents, so I saw the decade class of the readings. Salt shock day 9 shows negative exponents in columns 3–4, and the indicator file at DF 1600 shows negative exponents. Without units these do not fix any fate, but they were seen.
- **Layout readings** (from the paper and the masked files):
  - Salt-shock columns are DF 250, 500, 750, 825, in the order of the paper's Fig. 2 legend. Rows are 8 replicates, readings are end-of-day densities, and the shock (NaCl, 30 g/l) is applied during day 5.
  - Indicator rows are populations and the 5 columns are days at equilibrium ("an ensemble of at least 46 replicate populations over a span of 5 days").
  - The `all_*` files are used, not the `subset_*` files, because the subset's selection rule is not documented here.

## Fixed choices

- **Floor** f = 0.01 in the bifurcation files' units (10⁵ cells/µl, so 1000 cells/µl), now pre-registered. A reading ≤ f is extinct, > f alive. MQ1 found it post hoc: readings are quantized at 0.001, and wells that never regrow read 0.001–0.009.
- **Split.** Fit set: DF 250, 500, 1000, 1266. Held-out set: DF 750, 1133 (interpolation), 1400, 1600 (next to the fold). The salt-shock DFs 825 and the indicator experiment as a whole are further held-out regimes. DF 825 is in no bifurcation file.
- **Model class** for G: Dai et al.'s two-phase growth:
  - exponential growth at rate γ_l below a density N_c, then logistic growth at rate γ_h towards K, for 23.5 h;
  - free parameters (γ_l T, γ_h/γ_l, N_c, K);
  - it has a need only where γ_h > γ_l, so the class itself can say "no need".
- **No-need null**: logistic growth G(x) = K x e^R / (K + x(e^R − 1)). Its per-capita growth falls with density, so no dilution gives it a positive unstable point.
- **Fit.** Least squares of the censored log residual log max(G(x), f) − log max(y, f), over every pair of consecutive days (t = 1..6) at the fit-set DFs with n_t > f (1,736 pairs). Nelder–Mead from fixed starts. A bootstrap over the fit set's populations (60 resamples) is reported, not used in any rule.
- **Units rule** for the salt-shock and indicator files: if the median reading is more than 1000 × the predicted stable level at DF 250, the file is in cells/µl and is divided by 10⁵. The rule is decided on DF 250's readings: salt-shock column 1, days 2–4; indicator DF 250.
- **Fit-set checks before the freeze** (fit set only):
  - the two-phase model's mean residual stays within ±0.07 in every half-decade bin of start density;
  - the null's residuals reach +1.04 at the lowest densities;
  - fit-set RMSE is 0.137 for the two-phase model and 0.223 for the null;
  - fit-set day-7 medians of live populations against the predicted s: 1.78/1.75, 1.62/1.61, 1.27/1.33, 1.05/1.18.
- **Dry runs** of the test step on files generated from the fitted two-phase map: every rule passed. On files generated from the fitted null, every rule failed or was not testable. So the rules can prefer the null.

## Frozen numerical predictions (two-phase fit; bootstrap 5–95% in brackets)

| DF | need û (10⁵ cells/µl) | stable s | margin s − û |
|---|---|---|---|
| 750 | 0.0132 [0.0120, 0.0144] | 1.468 [1.460, 1.474] | 1.455 |
| 825 | 0.0164 [0.0149, 0.0177] | 1.426 [1.416, 1.432] | 1.409 |
| 1133 | 0.0337 [0.0302, 0.0358] | 1.252 [1.235, 1.264] | 1.218 |
| 1400 | 0.0548 [0.0487, 0.0585] | 1.101 [1.078, 1.116] | 1.046 |
| 1600 | 0.0749 [0.0660, 0.0811] | 0.987 [0.958, 1.005] | 0.913 |
| 250 | 0.0011 (below the floor) | 1.751 | 1.750 |
| 500 | 0.0053 (below the floor) | 1.610 | 1.604 |

- Fold DF* = 2797 [2719, 2899]. This is well above the paper's statement that populations collapse past DF 1600 and above the range of its Fig. 1E. Low-density daily growth factor e^{γ_l T} = 88.7.
- Null: no need at any DF ≤ 1600; stable levels 1.436, 1.366, 1.080, 0.832, 0.647 at DF 750, 825, 1133, 1400, 1600.
- At every DF here the margin is dominated by the level (û ≪ s). So a margin measured as level minus need tests mainly the level, and the need is tested by fates (A) and by the shock (C).

## Rules (all in `mq2.py test`)

- **M (the curve against the null, held out).** RMSE of the censored log residual on the held-out DFs' pairs. Passed if the two-phase RMSE is below the null's.
- **A1 (the need separates fates, held out).** At each held-out DF:
  - the groups are populations with day-1 reading > 1.5û (and > f), and those < û/1.5;
  - a reading ≤ f counts as below a threshold only when that threshold is ≥ f;
  - testable where both groups have ≥ 5 populations;
  - passed if, at every testable DF, ≥ 90% of the high group are alive and ≥ 90% of the low group extinct on day 7.
- **A2 (the predicted need against the measured need).** At each held-out DF where û ≥ 1.5f and the fates split:
  - the empirical need u* is the geometric midpoint of the best interval of thresholds classifying fates by "alive iff day-1 reading > u";
  - passed if |log(û/u*)| ≤ log 1.5 at every such DF.
- **B1.** The fold, reported only: no data lie past DF 1600, so the fit's fold at 2797 cannot be tested here.
- **B2 (the measured need rises with the draw).** The empirical needs u* at the held-out DFs where A2 applies rise strictly with DF. Testable with ≥ 3 such DFs.
- **S (the level in a separate experiment).**
  - For each of the eight indicator files (all DFs), the median of the live readings is compared with s(DF).
  - Passed if every ratio is within a factor 1.5, and the two-phase model's summed |log error| is at most the null's.
- **S2 (the level of the held-out bifurcation populations).** The day-7 median of live populations is within a factor 1.5 of s(DF) at every held-out DF.
- **C1 (the pulse margin: survival after a shock iff the post-shock density stays above the need).**
  - Mapping check: column 1's pre-shock median (days 2–4) exceeds column 4's; otherwise C is not testable.
  - Each population is predicted alive on day 9 iff its day-5 reading n₅ > û(DF).
  - A population is excluded as unresolvable when n₅ ≤ f and û < f (DF 250 and 500 below the floor).
  - Testable with ≥ 16 resolvable populations; passed if accuracy ≥ 0.9 and above the null's (which predicts survival for every live reading).
  - Day 5 is the first reading after the shock day.
- **C2.** The same with the day-6 reading. Day 6 is reported because a day-5 reading taken by optical density may count cells the salt has killed. C2's verdict is kept too.
- **D (time to break after the DF passes the fold).** Not testable. The indicator files hold fixed DFs at equilibrium, none past the fold, so no run in these data passes the fold.

## What Dai et al. (2012) already showed, and what this claims beyond it

They:
- mapped the bifurcation diagram by measuring both fixed points at each DF from the crossing of n_{t+1}/n_t = 1;
- fitted the two-phase model to the whole diagram with parameters matching independent measurements (their table S1, not available here);
- showed qualitatively that the salt shock is survived at low DFs and not at high ones;
- showed that variance and autocorrelation rise towards the fold.

MQ2 claims only what is new:
- one growth map fitted on half the regimes predicts the need and the level of the others;
- it predicts per population whether a shock is survived, in a separate experiment, including DF 825, which lies in no bifurcation file;
- it is compared against a no-need null.

That is the theory's regime margin used as a measured equation of state for held-out regimes. The two-phase model class is theirs; its parameters here are fitted independently, on the fit set only.

## Closest prior results (literature)

- **Depensation and harvest thresholds:**
  - Clark, *Mathematical Bioeconomics* (1976): critical depensation, a stock below which growth is negative, so a harvest that drives it there causes extinction.
  - May (1977), "Thresholds and breakpoints in ecosystems with a multiplicity of stable states", *Nature* 269:471–477: breakpoints between alternative states, where a slowly changing exploitation rate gives sudden collapse and hysteresis. The harvest examples are given from memory, not checked against the full text.
- **Allee effects with harvest or dilution as a standing draw:** Courchamp, Berec and Gascoigne, *Allee Effects in Ecology and Conservation* (2008).
- **The same yeast system:**
  - Dai et al. (2012), *Science* 336:1175, the data used here;
  - Dai, Korolev and Gore (2015), *PNAS* 112:10056, deteriorating environments (rising dilution, falling nutrients) and early-warning signals. This is the experiment that would test D; its data are not used here (not approved).
- In the theory's terms, the need under a standing draw is the regime's (MQ1 A3). The margin-of-a-regime core module being built in the parent session is cited once it lands.
