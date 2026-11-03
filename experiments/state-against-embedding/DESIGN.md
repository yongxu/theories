# UE32: T2's named state against the field's fitted embedding, in the fish stocks (design)

Board item UE32, 3 November 2026. AI-written (a Claude Code session). The rules ([`embed_rules.py`](embed_rules.py)), the dry runs ([`dry_runs_embed.py`](dry_runs_embed.py), [`results/dry-runs-embed.json`](results/dry-runs-embed.json), [`results/dry-embed.out`](results/dry-embed.out)), the probes of the design's choices ([`probe_design.py`](probe_design.py), [`results/probe-design.out`](results/probe-design.out)), the run's script ([`run_embed.py`](run_embed.py)) and this file are committed together, before any series is read by this test. The workbook the run reads, RAM Legacy v4.66, is not on this machine. The download and the run wait on Ren (§11).

*About 35 minutes to read; §1 and §8 in seven.*

## 1. What is tested, and the answer expected

Thesis T2 names in advance the state of a renewable condition under a draw: its level, its recent giving and one lag; "with the draw they fix the next giving as far as anything measured does" ([02 §5](../../theories/becoming/chapters/02-MAP.md#t2)). Its first forbidden item is "a fourth variable removing a tenth of the residual variance in the median series".

MQ5 read that state on 69 assessed fish stocks no analysis had read ([MQ's README](../margin-measured/README.md)). Among its verdicts:
- the lag is detected beyond chance (14 of 69, S2);
- with it, adding γ_{t−2}, E_{t−2} and E_{t−2}² removes in sample a further 0.059 of the residual variance beyond what chance adds, in the median stock, below the tenth (S3, passed); 39% of the stocks were above the tenth;
- the lag improves the five-year forecast (50 of 69, S4).

Every rival MQ3 to MQ5 read was of T2's own family: regressions linear in chosen columns, fitted in sample, or a frozen law's forecasts. The field that reads a state from a series without naming it in advance, empirical dynamic modelling ([FIELD-READING.md](FIELD-READING.md)), asks a different question of the same series. Does a delay embedding, its dimension chosen by cross-validation and read by a map free to bend, forecast better out of sample?

UE32 asks that question on MQ5's stocks, with MQ5's reading of the level, its split into training and held-out years and its balance:
- **T2's side:** only the coordinates, its three numbers, as T2 and MQ5 write them: the escapement E_t, the escapement a year back E_{t−1} and the recent giving γ_{t−1} (§4).
- **The rival:** the field's delay embedding F of the same two series, its dimension chosen by the forecasting map's own cross-validation on the training years (§4).
- **No law of T2's is fitted:** not the level law g, nor the rates φ and λ.
- **How both are read:** by the same machinery, the S-map, and scored on the same held-out years by the field's criterion, out-of-sample skill.

So the test is of the state, not of T2's law.

The answer on the primary group is one of three (§6):
- **T2 fails on the field's criterion:** the field's embedding removes a tenth of T2's held-out squared error in the median stock, and is better in significantly more stocks. Its reading is frozen (§6): T2's first forbidden item met out of sample where the stocks whose F chose a longer history carry the loss, and otherwise the lag not paying its way.
- **T2 better than the field's fitted embedding:** the converse.
- **Not separated on the field's criterion.**

**The answer expected.** This is an expectation from a model fitted to MQ5's readings, not a result. MQ5's readings of these same stocks place them between its synthetic worlds rather than in any one of them ([`VERDICTS-mq5.json`](../margin-measured/results/mq5/VERDICTS-mq5.json), [`dry-runs.json`](../margin-measured/results/mq5/dry-runs.json)):
- **At one year, UE32's horizon,** MQ5's forecast with the lag had the larger pooled error: 0.040 against 0.030 without it, better in 39 of the 69 stocks (p = 0.34).
  - In MQ5's dry runs, the lag's forecast was better in 126 of 145 stocks where T2's law holds (0.013 against 0.017).
  - It was better in 21 of 144 where an age structure holds (0.036 against 0.027), and in 132 of 142 under a second lag.
- **S3's share of stocks above the tenth** was 39%. It was 12% where T2's law holds, 99% under an age structure and 100% under a second lag.
- **One model consistent with both readings** is a share p of age-structured stocks among T2's: 12% + 87% p = 39% at p ≈ 0.31, and 87% (1 − p) + 15% p = 57% at p ≈ 0.42. MQ5's dry-run shares come from its own series' lengths. At UE32's lengths S3 flags about a sixth of T2's stocks (§7), which gives p ≈ 0.28. The readings do not identify the mixture: a weak memory shared by every stock could also give them.

On neither reading are the stocks near the second lag's world. So §7 adds a mixed world: each stock is age-structured with probability 1/3, and follows T2's law otherwise. In it the test said "not separated" in 94% of 200 archives and "T2 better" in 6%, and never "T2 fails".

**The answer expected is "not separated".**
- **It cannot tell T2's world from the mixed one.** "Not separated" is the usual verdict under T2's law too (67% of archives, against 94% in the mixed world). That is what T2's first forbidden item asks, since it reads the median series, but it means the expected outcome supports no more than that.
- **"T2 fails"** would point to nearly every stock carrying a memory like the age worlds', or to memory stronger than §7's age model. Even with every stock age-structured, the test fails T2 in only 47.5% to 78% of archives (§7). The share at which fails begin was not measured.
- **"T2 better"** would place the stocks nearer a world whose state N holds than MQ5's readings do. Under T2's law the test says it in 33% of archives.

## 2. What is MQ5's and what is new

**MQ5's, imported unchanged and read by its own code** ([`mq5.py`](../margin-measured/mq5.py)):
- the stocks: RAM's most recent assessment of each stock no earlier test read, with spawning biomass and catch;
- the groups, by RAM's assessment method ([`mq3.py`](../margin-measured/mq3.py)):
  - *primary:* statistical catch at age or at length, integrated analysis, VPA, 69 stocks;
  - *control:* biomass dynamics models, 5 stocks;
  - *other:* the rest, 24 stocks;
- the reading: the level x_t is the spawning biomass and the draw on it H_t = κ C_t, a share κ of the catch fitted per stock on its training years;
- the balance: what the draw leaves is E_t = x_t − H_t, and the giving γ_t = x_{t+1} − x_t + H_t;
- the split: the first 60% of a stock's giving years for training, less any year whose escapement is not positive, and the rest held out; the level's scale is its largest training value.

Before any rule is computed, the run checks each group's stocks against MQ5's committed fits ([`VERDICTS-mq5.json`](../margin-measured/results/mq5/VERDICTS-mq5.json)). Stock, assessment, years, last training year, κ and scale must match exactly. The level law's two coefficients, which depend on the series' values, must match within a relative 10⁻⁹. If any differs, the run stops with an error.

**New:**
- the states as coordinates (§4);
- the machinery, the field's own (§5);
- the per-stock ratio, the verdict and its reading (§6);
- the dry runs, with three worlds added to MQ5's generators (§7).

**Not read:** MQ5's fitted law. The S-map learns each stock's map from its training rows alone.

## 3. The rows

Every state is read on the same rows of a stock. A row is a giving year t whose escapements E_t to E_{t−3} are positive and whose givings γ_{t−1} to γ_{t−4} exist. Those are the values the largest state reads, so the first four years of each run are never rows.
- *Training rows* are those in MQ5's training years, and *held-out rows* those in its held-out years.
- A stock is testable with at least 12 training and 8 held-out rows.
- A group is testable with at least 10 testable stocks.

By the committed fits' lengths alone:
- 66 of the 69 primary stocks are long enough, with medians of 20 training rows and 17 held-out;
- 21 of the 24 other stocks are long enough;
- all 5 control stocks are long enough, but the group is below 10, so its verdict is "not testable".

Years with a non-positive escapement can lower these counts.

Each held-out row is forecast with the stock's training rows as the library: the map is fitted once, on the training years, and not refitted as the held-out years pass. A held-out row's coordinates read the observed series up to its year t, as a one-step forecast does. The escapement E_t is known at t: it is the level less the year's catch.

## 4. The states

**N, T2's named state.** Its three numbers are the escapement, the escapement a year back and the recent giving. This is MQ5's state with the lag, its place named before the data (one year back, MQ5's). By the balance the draw H_t = E_{t−1} − E_t + γ_{t−1}, and the level before it x_t = E_{t−1} + γ_{t−1}, are functions of the three. So the same three numbers can be written two ways:
- **as T2 names them,** (E_t, E_{t−1}, γ_{t−1});
- **with the draw in place of the lag,** (E_t, H_t, γ_{t−1}).

The S-map is not indifferent to how a state is written: where it bends, distances depend on the coordinates. N is read in T2's written form, as MQ5 wrote it. The verdicts with N in the draw's form, and with N's form chosen per stock by the less leave-one-out error on the training rows, are reported.

A probe measured how much the form matters ([`probe_design.py`](probe_design.py) `form`, [`results/probe-design.out`](results/probe-design.out)). It used two archives of 66 testable stocks for each of three worlds, T2's own, the age-structured one and MQ4's, and compared the two forms' held-out errors stock by stock:
- **Where both forms chose θ = 0**, the S-map is the same linear map on the same space, and the two forms agreed to within a log ratio of 0.0008. Both forms chose θ = 0 in 53, 29 and 54 of the 132 stocks in the three worlds.
- **Where either form bent,** the draw's form was better in 48 of 79, 55 of 103 and 46 of 78 stocks. The middle half of the log ratios ran from −0.09 to 0.11, −0.23 to 0.19 and −0.20 to 0.09.

So the form moves single stocks by as much as the margin, while neither form is better by much in the median stock. An earlier version of these rules chose the form per stock. The dry runs report that choice's verdict, and they show it costs N. It lowers N's median r in nine worlds of ten, by 0.003 to 0.027, and raises it by 0.001 in the tenth; under the age world it raises "T2 fails" from 49% to 55.5% (§7). The draw's form, fixed for every stock, would instead raise N's median r in nine worlds of ten. Choosing the lower of two noisy errors, between forms about equally good held out, adds overfitting, not skill. So the verdict reads the form T2 named, which is neither the best of the three readings for N nor the worst.

**F, the field's delay embedding of the two series T2's state reads:** (E_t, …, E_{t−D+1}; γ_{t−1}, …, γ_{t−D}).
- **D = 1** is MQ4's state (E_t, γ_{t−1}), one number fewer than N.
- **D = 2** is N with γ_{t−2} added.
- **D = 3** adds E_{t−2} and γ_{t−3}, near MQ5's S3 additions (γ_{t−2}, E_{t−2} and E_{t−2}², the square being what the S-map can bend to).
- **D = 4** adds one more delay of each.

D runs from 1 to 4. Each D is read by the S-map at its own θ, and the D with the least leave-one-out squared error on the training rows is chosen, the smaller on a tie. That is the criterion by which every state's θ is chosen and the one the held-out years score, so the field's embedding is chosen by the same measure it is judged by. The field's usual choice of D, by simplex projection's leave-one-out error, is reported with its verdict.

In the dry runs the two choices of D differ most where T2's law holds (§7):
- **Under T2's own law,** the S-map's choice brings F within a median r of 0.09 of N and gives "T2 better" in 33% of archives. Simplex's choice gives 91.5%.
- **Under a second lag,** the S-map's choice gives "T2 fails" in 44.5% of archives and simplex's in 1.5%.
- **In the age worlds,** simplex's choice gives the field more: "T2 fails" in 48.5% to 85% of archives, against 47.5% to 78%.

Neither choice favours the field in every world. The S-map's own is kept because it is the criterion that chooses θ and the one the held-out years score.

**Reported only:**
- **L,** the escapement alone (E_t), the regime's step's state;
- **U,** the field's embedding of the giving with the draw (γ_{t−1}, …, γ_{t−D}; H_t), its D chosen by simplex projection;
- two baselines: persistence (next giving as the last one) and the training mean.

**Why this embedding.** The field embeds the series it reads with a delay of each (Deyle and Sugihara 2011's multivariate embeddings, FIELD-READING Part 1 §3). T2's state reads two series, the escapement and the giving, and the giving last known at t is γ_{t−1}. The field's univariate embedding of the spawning stock alone, the one Pierre et al. (2018) tabulate, omits the catch. So it cannot forecast a giving the catch helps set ([STOCKS.md](STOCKS.md)). F reads the catch through the escapement, as N does.

**The draw's share.** κ is MQ5's, fitted on the training years by T2's own state with the lag ([`mq5.py`](../margin-measured/mq5.py), `fit_kappa`), and both N and F read the escapement and the giving it defines. That share withholds little of the recorded series from the field. By the balance x_s = E_{s−1} + γ_{s−1}, so F at dimension D holds the recorded spawning stock and draw at t and D − 2 years back, D − 1 values of each, whatever κ is; at D = 1 it holds neither. An embedding of the recorded series alone would need no κ. It is not read here.

**Why D ≤ 4.** F has 2D coordinates, up to 8. That is past the field's bound of about √N coordinates (FIELD-READING Part 3 §2), about 4.5 at the primary group's median 20 training rows, and past Munch et al. (2018)'s effective dimension of at most 4 in 96% of stocks. D = 3 and D = 4 are offered so that the field is not denied the longer history. They pay their estimation cost in the leave-one-out error that chooses D.

**What F's dimension says.** At D ≥ 2, F contains N's information and more: a win there is the longer history carrying what T2's three numbers do not. At D = 1, F is a subset of N: a win there is MQ4's smaller state forecasting better than T2's, which bears on the lag (MQ5's S4 question), not on a fourth variable. §6 freezes how a "T2 fails" is read from this.

## 5. The machinery

The field's own, as FIELD-READING Part 3 states it, for every state alike:
- **Standardizing:** each coordinate is centred and scaled by its training rows' mean and standard deviation; held-out rows use the training values.
- **The map, for every state:** the S-map (Sugihara 1994).
  - It is a locally weighted linear regression on a constant and the coordinates over the library, with weights exp(−θ d / d̄), d̄ the mean distance from the target to the library rows.
  - θ is chosen from 0, 0.5, 1, 2, 4 and 8 by leave-one-out squared error on the training rows, the smaller on a tie. θ = 0 is the global linear map, the field's linear (AR) baseline, and the grid runs as far as the field's usually do.
  - A ridge of 10⁻⁸ on the normal equations' diagonal is there for numerical stability only.
- **F's dimension:** the S-map's leave-one-out squared error at each D's own θ (§4).
- **N's form, for the reported verdict with the form chosen per stock:** the same error, between its two forms, T2's written form on a tie and wherever both chose θ = 0 (§4).
- **Simplex projection, for the reported choice of D and for U:**
  - each training row is forecast from its p + 1 nearest other training rows, p being the number of coordinates, with weights exp(−d/d₁), d₁ the nearest distance;
  - the D with the least leave-one-out mean absolute error is chosen, the smaller on a tie.
- **The held-out forecast:** each held-out row is forecast by the S-map at the chosen θ from the training rows.

## 6. The verdict

**Per stock:** r = ln(MSE_F / MSE_N), from the held-out mean squared errors of the next giving. r < 0 means the field's embedding forecast better.

**Over a group:**
- **T2 fails on the field's criterion:** the median r is at or below ln 0.9 (−0.105), F is better in more stocks than N, and a two-sided sign test gives p < 0.05, stocks with r = 0 dropped.
- **T2 better than the field's fitted embedding:** the median r is at or above −ln 0.9 (+0.105), N is better in more stocks, and p < 0.05.
- **Not separated on the field's criterion:** otherwise. Either the median lies within a tenth either way, or the sign test falls short of 0.05.
- **Not testable:** fewer than 10 testable stocks.

The primary group's verdict is the test's. The other and control groups are reported.

**The reading of a "T2 fails", frozen now.** The run prints it beside the verdict:
- **"The longer history carries more (T2's first forbidden item, out of sample)"** where the median r over the stocks whose F chose D ≥ 2 is also at or below ln 0.9;
- **"the lag does not pay its way out of sample (MQ4's state forecasts better)"** otherwise.

**Why a tenth.** It is T2's first forbidden item read out of sample: the field's embedding removing a tenth of T2's held-out squared error in the median stock.

**Why the sign test.** The margin is on the median stock, and the sign test tests the median: whether more stocks go one way than the other. The Wilcoxon signed-rank test tests symmetry about zero, which these distributions of r lack (under T2's law, the stocks whose F chose D = 3 or 4 lose by a median of 0.45 and 0.75, against 0.03 and 0.05 at D = 1 and 2, §7). A probe compared the two tests and the margin alone, each with the same margin, on 12 archives for each of six worlds ([`probe_design.py`](probe_design.py) `test`, [`results/probe-design.out`](results/probe-design.out)):

| World | Counted | Sign test | Signed-rank test | Margin alone |
|---|---|---|---|---|
| age | T2 fails | 4 | 5 | 10 |
| age-early | T2 fails | 7 | 7 | 11 |
| two-lags | T2 fails | 5 | 5 | 8 |
| t2 | T2 better | 1 | 2 | 2 |
| t2-noisy | T2 better | 4 | 5 | 5 |
| mq4 | not separated | 12 | 12 | 12 |

- **Against the signed-rank test,** the signed-rank test decided somewhat more often on both sides. It gave 17 "T2 fails" against the sign test's 16 in the three worlds where T2 is false, and 7 "T2 better" against 5 under T2's law. So the sign test's cost falls on both sides, slightly more on T2's, and keeping it does not favour T2. Twelve archives a world cannot rank the two tests' power.
- **Against the margin alone,** the sign test's cost falls mostly on the fail side: 13 fewer "T2 fails" (16 against 29) and 2 fewer "T2 better" (5 against 7). That is the price of asking that the field's embedding be better in significantly more stocks, not only in the median one.

**Reported beside the verdict:**
- the verdict with F's dimension chosen by simplex; the verdict with N in the draw's form; and the verdict with N's form chosen per stock;
- r by the dimension F chose, and the median r over the stocks whose F chose D ≥ 2;
- the median log ratios of L's and U's held-out errors to N's;
- the median ln(MAE_F / MAE_N), the field's other common score;
- N's and F's skill against persistence, N's against the training mean, and the share of stocks where each does worse than persistence;
- how many stocks the per-stock choice reads in the draw's form, and the θ each state chose;
- each stock's r beside its in-sample S3 excess as MQ5's code computes it, and the median r over the stocks at or above MQ5's bound of a tenth and over those below it. If the stocks where F wins are those where MQ5 found more needed in sample, the two readings agree stock by stock. §7 gives what the pairing shows in three worlds.

## 7. Dry runs

The rules were run on 200 synthetic archives for each of ten worlds ([`dry_runs_embed.py`](dry_runs_embed.py), [`results/dry-runs-embed.json`](results/dry-runs-embed.json), [`results/dry-embed.out`](results/dry-embed.out)). Each archive holds up to 69 stocks, with the lengths of MQ5's 69 primary stocks. Each stock is built, split and given its draw's share by MQ5's own code. Each world's random stream is seeded by its name, so a world gives the same archives whether it runs alone or with others.

**The worlds:**
- **t2:** T2's law, MQ5's hypothesis. The giving relaxes toward the level's law and reads the lag, and the catch follows the level.
- **t2-noisy:** the same, with the spawning biomass read with noise.
- **mq4:** MQ4's state, no lag.
- **two-lags:** T2's law with a second lag.
- **level:** the giving read off the level, the regime's step (MQ3's).
- **drifting:** a giving that wanders on its own (MQ4's).
- **age:** MQ5's age-structured stock, maturity at 4.
- **age-early** and **age-late** (added): the same with maturity at 2 and at 7, the late one's recruitment more variable.
- **mixed** (added): each stock age-structured, maturity at 4, with probability 1/3, and T2's otherwise (§1).

**The verdicts,** as shares of the 200 archives. The median r is the median over archives of each archive's median stock.

| World | T2 fails | Not separated | T2 better | Median r | With simplex's D: fails / better | N in the draw's form: fails / better | N's form chosen per stock: fails / better |
|---|---|---|---|---|---|---|---|
| t2 | 0% | 67% | 33% | 0.089 | 0% / 91.5% | 0% / 37% | 0% / 28.5% |
| t2-noisy | 0% | 78% | 22% | 0.072 | 0% / 67.5% | 0% / 29% | 0% / 19% |
| mq4 | 0.5% | 96% | 3.5% | 0.015 | 0.5% / 8.5% | 0% / 6% | 0% / 3% |
| two-lags | 44.5% | 55.5% | 0% | −0.174 | 1.5% / 3% | 42.5% / 0% | 48.5% / 0% |
| level | 0% | 75.5% | 24.5% | 0.076 | 0% / 80.5% | 0% / 15.5% | 0% / 23.5% |
| drifting | 0% | 88% | 12% | 0.052 | 0% / 57.5% | 0% / 17% | 0% / 9.5% |
| age | 49% | 51% | 0% | −0.314 | 60% / 0% | 42% / 0% | 55.5% / 0% |
| age-early | 47.5% | 52.5% | 0% | −0.275 | 48.5% / 0% | 37.5% / 0% | 52.5% / 0% |
| age-late | 78% | 22% | 0% | −0.346 | 85% / 0% | 65% / 0% | 74.5% / 0% |
| mixed | 0% | 94% | 6% | 0.028 | 0% / 28.5% | 0% / 5% | 0% / 4% |

Every "T2 fails" in every world reads "the longer history carries more". "The lag does not pay its way" occurs in none.

**r by the dimension F chose,** and the reported states. Each figure is the median over archives of the archive's median; the skill is 1 − MSE / MSE of persistence.

| World | r at D = 1 | D = 2 | D = 3 | D = 4 | N's skill | F's skill | N worse than persistence | ln(MSE_U / MSE_N) | ln(MSE_L / MSE_N) |
|---|---|---|---|---|---|---|---|---|---|
| t2 | 0.03 | 0.05 | 0.45 | 0.75 | −0.01 | −0.22 | 50% | −0.14 | 0.98 |
| t2-noisy | 0.00 | 0.06 | 0.42 | 0.61 | 0.29 | 0.20 | 37.9% | −0.10 | 0.15 |
| mq4 | −0.07 | 0.05 | 0.38 | 0.79 | −1.21 | −1.36 | 78.8% | −0.07 | 1.47 |
| two-lags | 0.00 | −0.24 | −0.29 | −0.21 | −0.02 | 0.14 | 50% | −0.62 | 0.85 |
| level | −0.03 | 0.09 | 0.52 | 0.99 | 0.19 | 0.07 | 42.5% | 0.15 | 0.06 |
| drifting | −0.03 | 0.07 | 0.47 | 1.07 | −0.90 | −1.13 | 78.9% | −0.05 | 1.12 |
| age | −0.02 | −0.29 | −0.40 | −0.36 | −1.49 | −0.91 | 86.4% | −0.74 | 0.90 |
| age-early | −0.08 | −0.31 | −0.37 | −0.36 | −1.86 | −1.20 | 89.4% | −0.62 | 1.08 |
| age-late | −0.10 | −0.45 | −0.32 | −0.38 | −1.17 | −0.58 | 81.8% | −0.82 | 0.59 |
| mixed | 0.02 | 0.03 | 0.16 | 0.01 | −0.40 | −0.38 | 62.1% | −0.31 | 0.93 |

**What the dry runs show:**
1. **Where an age structure carries every stock's series, the test fails T2 in about half to three-quarters of the archives:** 49% with maturity at 4, 47.5% at 2 and 78% at 7.
   - The median r is −0.28 to −0.35, at or past the margin in 92.5% to 97% of archives. The sign test holds back the rest: 43.5, 45.5 and 19 points.
   - Each fail reads "the longer history carries more". The median r over the stocks whose F chose D ≥ 2 is −0.34 to −0.40.
2. **Against a second lag, the test fails T2 in 44.5% of archives,** each fail read as the longer history. The median r is at or past the margin in 76.5% of archives. With simplex's choice of D the share of fails was 1.5%. Choosing D by the scored criterion is what gives the test this power.
3. **Where T2's law holds, the test says "T2 better" in 33% of archives,** 22% with noise, and "not separated" otherwise. It never says "T2 fails".
   - The median r is 0.09 and 0.07: at its chosen D, F comes close to N.
   - With simplex's D the shares would be 91.5% and 67.5%. Simplex chooses D = 3 or 4 in 47% and 52% of these stocks, and the S-map's own choice in 18%. Where the S-map chose those dimensions, F lost by a median of 0.42 to 0.75.
4. **Where the giving reads less than T2's state, the test said "T2 fails" in one archive of 600,** an mq4 archive. "T2 better" comes in 3.5% of the no-lag archives (mq4), 24.5% of the regime's step (level) and 12% of the drifting giving. N holds each of these worlds' state with coordinates to spare.
5. **In the mixed world, the test says "not separated" in 94% of archives and "T2 better" in 6%, and never "T2 fails".** The verdict reads the median stock, and with a third of the stocks age-structured, the median stock is T2's. The run's pairing with MQ5's S3 (§6) is the reading that could show such a minority. In ten archives of each of three worlds ([`probe_design.py`](probe_design.py) `s3`, [`results/probe-design.out`](results/probe-design.out)), it gave these results:
   - **In the mixed world,** the stocks at or above MQ5's bound had a median r of −0.175 and those below it 0.082, over archives. The first was lower in 9 of the 10 archives. The gap, below less above, ran from −0.135 to 0.705 archive by archive.
   - **Under T2's law alone,** the medians were −0.03 against 0.09, the first lower in 8 of 10, and the gap ran from −0.95 to 0.29. S3 flags about a sixth of T2's stocks by chance, and they lean the same way.
   - **Where every stock is age-structured,** S3 flags 62 to 66 of the 66, so the pairing has almost nothing to compare.
   - **So the run is one archive,** and its gap suggests a minority carrying memory only beyond about 0.3, where five of the ten mixed archives lay and none of T2's. That bound was read off these same archives: T2's largest gap was 0.29, and the mixed world's fifth largest 0.30. Under the earlier per-stock choice of N's form, the same seeds gave a T2 archive at 0.49. So the bound is loose, and it depends on how N is read.
6. **The form N is read in moves the verdict by up to 13 points** (the last two columns of the first table).
   - The draw's form raises N's median r in nine worlds of ten, and the per-stock choice lowers it in nine of ten (§4).
   - The largest moves are under age-late: "T2 fails" in 65% of archives with the draw's form and 78% with the written form, and in 74.5% with the per-stock choice.
   - The verdict reads the written form, the one T2 named before any of these were seen.
7. **Both states trail persistence in most worlds.**
   - N's median skill against persistence is −0.01 under T2's law and −1.2 to −1.9 in the age worlds. F's is −0.22 and −0.58 to −1.20.
   - N does better than the training mean in every world: its skill against it is 0.12 to 0.78.
   - So a verdict says which state's information carries more through the field's machinery at these lengths, not which forecasts well.
8. **U, the giving's own embedding with the draw, forecasts better than N in nine worlds of ten,** T2's own among them (−0.14). So a U win in the run is no evidence against T2 by itself. U does not contain N; F at D ≥ 2 does, which is why F is the rival.
   - L, the escapement alone, is worse than N in every world. It nearly ties only in the regime's step (0.06), where the giving reads off the level.

**Power, in short:**
- **Against an age structure in every stock:** "T2 fails" in 47.5% to 78% of archives.
- **Against a second lag:** in 44.5%.
- **For T2 where its law holds:** "T2 better" in 22% to 33%, never "T2 fails".
- **Without an age structure or a second lag in every stock:** one "T2 fails" in the 1,200 archives of the other six worlds, the mixed one among them.

The dry runs took 13,657 seconds of CPU: about 1,500 for each world of 69-stock archives, and about 800 for level and drifting, whose stocks are fewer.

## 8. What each outcome means

**T2 fails on the field's criterion.** In the median stock, a delay embedding of the same two series, fitted by the forecasting map's own cross-validation, carries out of sample what T2's three numbers do not. MQ5's S3 found the opposite in sample for the median stock, with 39% of the stocks above the tenth. How it is read was frozen in §6:
- **The longer history carries more.** This is T2's first forbidden item met in its out-of-sample form. F holds only the escapement's and the giving's own history. So it counts against "as far as anything measured does", and also against "as far as the level's own history does", which 02 §5 names as what would remain and [T2-PROPOSALS.md](T2-PROPOSALS.md) §3 keeps in reserve. The age worlds of §7 show it: what an age structure leaves in the series.
- **The lag does not pay its way.** MQ4's smaller state forecasts better out of sample. That bears on T2's "one lag", not on a fourth variable. It would stand beside MQ5's one-year reading, where the forecast with the lag had the larger pooled error (§1), and against MQ5's S4 at five years.

**Recorded now, so that this outcome cannot be reread afterwards:**
- **It counts against the evidence T2 cites.** MQ5's pass on these same stocks would not stand as support for the claim "as far as anything measured does" in assessed fish stocks.
- **It does not meet T2's *Refuted by* as worded,** which names survey series. RAM's spawning biomass is the output of the assessments, statistical catch at age and the like, and the field warns that such outputs carry the assessment model's own structure (Storch et al. 2017; Ward et al. 2014; FIELD-READING Part 3 §5). MQ5's note that the lag "may be the assessment's own" applies equally to what F finds. The claim would then need survey series to stand, and this test would be the reason.

**T2 better than the field's fitted embedding.** The three numbers named in advance forecast the next giving better than the field's fitted embedding, on the field's own criterion. That is a prediction that could fail, and did not: in the age-structured worlds of §7, and under a second lag, T2 fails in 44.5% to 78% of the archives.
- It also comes where the giving reads only the level or only itself (in 24.5% and 12% of archives, against 33% under T2's law, §7). So it supports the three numbers' sufficiency against the series' longer history at these lengths. It does not support the lag's place in the state, which MQ5's S2 and S4 read.
- It does not show T2's law, which is not fitted here.
- It does not show that N forecasts well. In T2's own world N only ties persistence (§7), so "T2 better" can mean that F did worse, not that N did well.

**Not separated.** Neither state is better by a tenth with the sign test's confidence.
- Where the median r lies past ln 0.9 but the sign test falls short, the reported numbers say so. That is not read as a pass for T2.
- Where the median lies within a tenth, F's held-out error in the median stock was less than a tenth below N's. That is a point estimate, not a showing that the further history carries nothing. Under a second lag, where it does carry something, the median lay within a tenth in about a quarter of the archives (§7).
- Where a minority of the stocks carry such memory, as in the mixed world, "not separated" is the usual verdict, because the verdict reads the median stock. The pairing with MQ5's S3 (§6) can suggest such a minority only where its gap is large (§7).

**Recorded now, for every outcome:**
- **The test fails T2 in 47.5% to 78% of the archives where every stock carries an age structure's memory, and in 44.5% under a second lag** (§7). Where a third of the stocks carry it, the test never fails T2. So neither "T2 better" nor "not separated" shows that no such memory is present. MQ5's S3 reads that in sample, stock by stock.
- **Both states may trail persistence.** The run reports each state's skill against persistence. A "T2 fails" between two states that both trail it says which state's information carries more through the field's machinery, not that either forecasts well.
- **The other and control groups are reported.** The control group's biomass dynamics models produce series that follow a production law, as T2's state does, and its five stocks are too few for a verdict.

## 9. Data, what has been seen, and the run's order

**The workbook:** the RAM Legacy Stock Assessment Database v4.66, Zenodo record 14043031, the one MQ3 to MQ5 read. The archive is about 112 MB, md5 `ed6d7cd3f7da1fdcbc60015c3d65014b`. It is not on this machine: the earlier tests read it from an extraction outside the repository, since removed. The run needs it downloaded again, and the download is Ren's (§11).

**What has been seen:**
- MQ3 to MQ5's committed results:
  - their verdicts and forecasts, quoted in §1;
  - their fits: stock and assessment ids, years, last training year, κ, the level law's two coefficients and the scale, but no series value;
  - their dry runs.
- Pierre et al. (2018)'s published embedding dimensions for 28 of the stocks T2's tests read, two of them MQ5's ([STOCKS.md](STOCKS.md)).
- The field's papers, as [FIELD-READING.md](FIELD-READING.md) records how each was read.
- No series value has been read by UE32's code. This session has not opened the workbook, nor seen a series of these stocks.
- The model that wrote this design may have met published series of some of these stocks in its training.

**The test is not blind to MQ5's results.** §1's expectation and the mixed world of §7 use them. It is blind to the series, which no rule here has read.

**The run's order:**
1. The download, its md5 checked against Zenodo's.
2. `python3 -I -B run_embed.py XLSX results/run-embed.json`, under Python 3.11. That is this machine's python3 (3.11.2), which MQ5's run presumably used; MQ5's version was not recorded. Python 3.12 changed how a sum of floats rounds, which could move a near-tie in κ and stop the run at the check, so the script stops under any other version. The script:
   - writes the workbook's sha-256, the Python version and the sha-256 of the code it ran;
   - reads MQ5's stocks with MQ5's code;
   - checks them against MQ5's committed fits, and stops if they differ (§2);
   - checks that the primary and other groups' median S3 excess, recomputed from the series by MQ5's code, equals MQ5's committed values within a relative 10⁻⁹, and stops if not;
   - runs the rules on each group;
   - writes the output, whatever it is.
3. The result goes into this folder's README, with the verdict and its reading as the run printed them.

## 10. Limits

- **Assessment outputs, not survey series.** T2's *Refuted by* names survey series. The primary group's levels are the outputs of age-structured assessments, which carry the model's structure into the series (§8).
- **Short series.** The median stock has 20 training rows, against the 20 to 40 points the field's studies take as a minimum (Munch et al. 2018 used 20; FIELD-READING Part 3 §3). This is the field's criterion at T2's tests' lengths, which is what is asked. "T2 better" would not show that the field's embedding loses on longer series.
- **One step ahead only.** The decay of skill with horizon, the field's diagnostic, is not read. MQ5's S4 read five years.
- **One library, fixed at the training years.** The field's leave-one-out and rolling schemes are not used for the held-out score, so that both states are scored as MQ5's split scores them.
- **The choices are made on few rows.** F's 4 dimensions are each read at 6 values of θ, and N at 6, all chosen by leave-one-out error on about 20 training rows; N's two forms are compared only for a reported verdict. The minimum of those errors is optimistic, and more so for F, which chooses among more. Only the held-out years score.
- **No exclusion radius.** The leave-one-out choices keep a row's neighbours in time in the library; the field's tools allow such neighbours to be excluded, and none are here. Each held-out score is on held-out givings that no choice read. The last training giving does read the first held-out year's level.
- **The squared error is primary.** The absolute error is reported, and the correlation ρ is not.
- **No surrogate test of nonlinearity.** The θ each state chose is reported, nothing more.
- **Power:** 47.5% to 78% against an age structure in every stock, 44.5% against a second lag, and none against a third of the stocks age-structured (§7, §8).
- **Stocks are treated as independent.** The sign test does so, as MQ5's binomials did, although stocks share regions, species and assessment practice.
- **The S-map's size.** It reads 3 to 8 coordinates on 12 to 64 training rows. The ridge is for stability only, so a state with more coordinates pays its estimation cost in full, as the field's method makes it pay.

## 11. What waits on Ren

- **The download:** RAM Legacy v4.66 from Zenodo record 14043031, about 112 MB, md5 `ed6d7cd3f7da1fdcbc60015c3d65014b`, into a new folder outside the repository.
- **The run:** on that workbook, the rules take seconds of CPU (about 7.5 seconds for an archive of 69 stocks in the dry runs). MQ5's reader takes the rest; its time on the workbook was not recorded. Nothing else is downloaded.

Freezing is done by this commit and waits on no one: designs are prepared fully, freezing included, and only their release waits for him (AGENTS.md).

## 12. Review

Two readers read the work before the freeze. Each was a separate Claude Code agent that had not written what it read, and neither opened any data folder.

**The documents' reader** read README.md, STOCKS.md and T2-PROPOSALS.md against their sources. It fetched Pierre et al. (2018)'s appendix and recomputed every count. It made 16 findings, all taken. Its second reading of the revision found three slips and two new imprecisions, all fixed. The findings that changed what a reader is told:
- STOCKS.md missed one matched stock, the widow rockfish. It also did not say that MQ4 read total biomass, not spawning biomass.
- T2-PROPOSALS.md said the second forbidden item had not been read in the fish stocks. MQ4 and MQ5 read it at five years.
- The regime's-step proposal treated a failure to detect the recent giving as being near the regime's-step end. It now needs a positive showing, an upper bound.
- MQ5's one-year place for the lag was not named from each stock's renewal, so the proposed rule is now "named before the data".
- README.md called the embedding "T2's nearest rival". UE31 names the age-structured states as the field's strongest, so it is now "one rival".

**The design's reader** read DESIGN.md, the rules, the dry runs, the run's script and MQ5's code. It ran small checks, under 10 seconds of CPU in all. It made 15 findings: four errors, one fairness problem in the code, and imprecisions. All were taken:
1. **§1's expectation** rested on MQ5's S2, which does not place the stocks among the worlds. It now rests on MQ5's one-year forecast, S3's share above the bound and the mixed world (§1, §7).
2. **A "T2 fails" counted stocks where F chose D = 1** as T2's first forbidden item. How a fail is read is now frozen by the median over the stocks with D ≥ 2 (§6).
3. **"T2 better"** did not say that it is also the usual verdict where T2's law is false (§8).
4. **F's dimension** was chosen by simplex projection's absolute error and scored by the S-map's squared error. It is now chosen by the S-map's own leave-one-out squared error, and the simplex choice is reported (§4, §5). The reader's 40-stock check also showed that the S-map is not indifferent to how N is written where it bends. It proposed keeping MQ5's form and stating the tilt, or measuring more. This session chose the form per stock instead. The reader's second reading showed that the choice cost N, so N is read as written, and both other forms' verdicts are reported (§4; second reading, item 1).
5. **"Why D ≤ 4"** confused delays with coordinates, and "D − 1 delays" was off by one (§4).
6. **The sign test's argument** left out its best evidence and claimed a ranking of power that twelve archives cannot make. It now says where the cost falls (§6). A scratch run cited for that ranking was not kept, so the sentence resting on it is gone.
7. **"Not separated"** was read as a showing rather than a point estimate (§8). §7 had six numerical slips, and its account of why the S-map trails persistence rested on a check that was not kept. That account is gone, and both states' skill against persistence is now reported.
8. **The run's script:**
   - Python is pinned to 3.11, and the version is written with the output. Which version MQ5 ran under was not recorded (second reading, item 5).
   - The level law's two coefficients are checked within a relative 10⁻⁹.
   - The checks raise an explicit error, which `python -O` cannot strip.
   - Each stock's r is reported beside its MQ5 S3 excess (§6).
9. **Small points:** the field's minimum lengths and the held-out givings (§10); the rows' needless E_{t−4} (§3); 02 §5's own phrase "as far as the level's own history does" (§8); MQ5's S3 described exactly (§1).

The revision changed the rules, so the dry runs and both probes were rerun under them, and every number in §1, §4, §6 and §7 comes from those reruns.

**The design's reader read the revision.** It read DESIGN.md, the rules, the run's script, the dry runs' JSON and the probe outputs, and ran one archive of each of two worlds (11.5 seconds of CPU). Every number it recomputed was right, and its 15 findings were taken, with these exceptions, all now fixed:
1. **Choosing N's form per stock cost N.** It lowered N's median r in nine worlds of ten. The tie rule also split stocks where both forms gave one linear map. N is now read as written, and the chosen form's verdict is reported, with both forms at θ = 0 counted as a tie (§4, §7).
2. **The S3 pairing's power was stated from medians over archives.** A single run is one archive. Under the frozen rules only a gap beyond about 0.3 tells the mixed world from T2's, and ten archives a world fix that bound loosely (§7, §8).
3. **§1's expectation was stated more strongly than its evidence allows.**
   - The mixture is one model consistent with MQ5's readings, not identified by them.
   - A fail needs nearly every stock age-like, not most.
   - The expected outcome cannot tell T2's world from the mixed one.

   §1 now says each of these.
4. **"Keeping the sign test does not favour T2"** rested on the comparison with the margin alone, whose cost falls mostly on the fail side. It now rests on the comparison with the signed-rank test (§6).
5. **Smaller points:**
   - §8's "about as often".
   - Python 3.11 was not MQ5's recorded version, since none was recorded. Other versions now stop the run.
   - The S3 medians are now checked against MQ5's committed values.
   - The outputs now carry the sha-256 of the code that wrote them.
   - README's description of how D is chosen.

The change to N's form changed the rules again. So the dry runs and all three probes were rerun under the frozen rules; `form`, which compares the two forms directly, reproduced its earlier numbers exactly.

**The design's reader read the third revision** and recomputed every number in §1, §4, §6, §7 and §8 against the JSON and the probe output: all matched, the code did what §4 says, and the second reading's findings were taken. It found one error, a sentence saying the `form` probe was not rerun, and two stale sentences, in §10 and in the first reading's item 8. All three are fixed. It also suggested showing how loose the S3 pairing's bound is, which §7 now does.
