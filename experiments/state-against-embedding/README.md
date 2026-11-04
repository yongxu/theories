# UE32: T2 against empirical dynamic modelling

Board item UE32, 3 November 2026; run 4 November 2026. AI-written (a Claude Code session; no person has checked it). About eighteen to twenty-three minutes to read, [the result](#the-result) twelve to sixteen of them; its parts are listed with their own times.

**Why.** Thesis T2 names in advance the state of a renewable condition under a draw: its level, its recent giving and one lag ([02 §5](../../theories/becoming/chapters/02-MAP.md#t2)).
- Where a stage before recruitment is counted, the field's state is that stage. UE31 and UE31b test T2 against it in the flour beetle ([UE31](../state-named-in-advance/README.md), [UE31b](../state-named-in-advance/cells/DESIGN.md)).
- T2's fish-stock tests read no such stage. RAM's recruitment series, which are assessment output, were not read. There the field's strongest states are age-structured and delay-difference ones (Deriso 1980; Schnute 1985; [UE31 §2](../state-named-in-advance/DESIGN.md)), of the kind of model that produced the series.
- One rival reads a state from a series without naming it in advance: delay embedding (Takens 1981). Its field has forecast skill against nonlinearity (Sugihara and May 1990; Sugihara 1994), causal inference from it (Sugihara et al. 2012), and its use on fish stocks (Glaser et al. 2014). Its criterion is out-of-sample prediction skill.

A state named in advance that forecasts as well as the field's fitted embedding, on the field's own criterion, would be a prediction that could fail and did not. A delay embedding of the escapement and the giving is more of the level's own history, with the draw. So one that forecasts better would count against T2's count of three and against "as far as anything measured does". It would also count against the narrower "as far as the level's own history does" that 02 names as what would remain.

**The parts.**
- [DESIGN.md](DESIGN.md): the test, frozen before any series is read by it, with its dry runs. About 35 minutes; §1 and §8 in seven.
  - T2's three numbers, the escapement, the escapement a year back and the recent giving, are the state named in advance.
  - The rival is the field's delay embedding of the same two series, its dimension chosen inside the training years by the S-map's own leave-one-out error, with the field's usual simplex choice reported.
  - Both are read by the same S-map and scored by out-of-sample error on MQ5's stocks and MQ5's held-out years.
  - The answer expected, stated before the run from MQ5's readings of these stocks and from the dry runs, is "not separated" (§1). In the dry runs the test fails T2 in 44.5% to 78% of the archives where an age structure or a second lag holds in every stock, and in one of the 1,200 archives of the other worlds (§7).
- [FIELD-READING.md](FIELD-READING.md): the field, read source by source, each with how it was read, and what it would count as a fair test of a named state (Part 3). About 45 to 55 minutes; Part 3 in ten.
- [STOCKS.md](STOCKS.md): the field's published per-stock estimates for the 277 stocks T2's tests read. About ten minutes.
  - One per-stock table was seen (Pierre et al. 2018). 28 of the 277 stocks have an embedding dimension in it, two of them MQ5's, and three more have one for a stock defined differently.
  - It names no failure of T2. That dimension is chosen for the spawning stock alone, without the catch T2's state reads, and for MQ4's stocks it describes another series than the total biomass MQ4 read.
- [T2-PROPOSALS.md](T2-PROPOSALS.md): four proposals for T2's owner, documents only. About fifteen minutes. Proposals 1, 2 and 4 were taken into T2's statement on 4 November 2026 ([study §505](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#505-t2s-statement-the-level-alone-at-the-regimes-step-end-the-horizons-grain-and-the-lags-place-t2s)); proposal 3 waits on a frozen run that fails it.
  1. **The second forbidden item.** The level alone forecasting as well at five years is met by T2's own law at the regime's-step end T2 names. It should not apply in a series shown to sit there, with the showing by an upper bound, not by a failure to detect.
  2. **The horizon.** "Five years" should read five steps of the grain at which the three numbers are read, fixed before the data.
  3. **"As far as anything measured does."** It should be kept until a frozen run fails it, and then narrowed in 02's words, with the failure kept.
  4. **The lag's place.** It should be named before the data.

**Standing.** Designed and frozen on 3 November 2026, before any series was read by it; run on 4 November 2026 on Ren's yes ([his words](../../sources/15-codex-theory-conversations/2026-11-04-ue32-download-and-run.md)), its result below. No Lean and no record. The archive was downloaded into a folder outside the repository and is not copied into it.

## The result

*About twelve to sixteen minutes to read.* Run on 4 November 2026 ([what it printed](results/run-embed.out), [every figure](results/run-embed.json)). r = ln(MSE_F / MSE_N) is the log ratio of the two states' held-out squared errors on the next giving, the field's embedding F's over T2's three numbers N's (DESIGN §6); r > 0 means the three numbers forecast better.

**On the primary group, the frozen verdict is "T2 better than the field's fitted embedding".** Of MQ5's 69 primary stocks, 65 have enough rows to test.
- The median r is +0.163, past the frozen margin of +0.105.
- The three numbers forecast better in 42 stocks, the embedding in 23.
- The two-sided sign test gives p = 0.025.

The verdict is the same in each reading reported beside it: with the embedding's dimension chosen by simplex projection (median r +0.133, 41 to 24, p = 0.046), with the three numbers in the draw's form (+0.183, 43 to 22, p = 0.013), and with their form chosen per stock (+0.177, 43 to 22, p = 0.013). By absolute error the embedding was also worse, by less (median log ratio +0.069).

**Both states forecast worse than persistence.** Persistence forecasts the next giving as the last one. Each state's held-out error is larger than persistence's in 53 of the 65 stocks, and both are larger in 46. In the median stock the three numbers' skill against persistence is −0.85, their error 1.85 times persistence's, and the embedding's is −1.21. Against the training mean the three numbers' skill is +0.23. Persistence reads only γ_{t−1}, one of the three numbers, and fits nothing, so their loss to it is the cost of a map fitted on about 20 training rows, not information they lack. So the verdict says which state's information carries further through the field's machinery at these lengths, not that T2's state forecasts well (DESIGN §8).

**The embedding lost more the longer the history it chose.** By the dimension D it chose on the training years:

| D chosen | What F holds | Stocks | Median r | F better in |
|---|---|---|---|---|
| 1 | MQ4's state (E_t, γ_{t−1}): N less one number | 26 | +0.004 | 13 |
| 2 | N plus one number (γ_{t−2}) | 22 | +0.158 | 6 |
| 3 | N plus three numbers | 9 | +0.340 | 1 |
| 4 | N plus five numbers | 8 | +1.186 | 3 |

Where F chose D ≥ 2, holding all of N's information and more, the median r is +0.200 (in the dry runs +0.11 under T2's law, +0.03 in the mixed world and −0.34 to −0.40 in the age worlds). Where it chose MQ4's smaller state, the two tie. The dry runs show the same growth wherever no age structure or second lag held (under T2's law, +0.45 and +0.75 at D = 3 and 4), so it shows what the longer history costs at these lengths, not that it carries nothing.

**What it means, as the design froze it (DESIGN §8).**
- The three numbers named in advance forecast the next giving better than the field's fitted embedding of the same two series, on the field's own criterion. That is a prediction that could fail and did not, in the design's sense: in its dry runs the test failed T2 in 44.5% to 78% of the archives where every stock carried an age structure or a second lag.
- It supports the three numbers' sufficiency against the series' longer history at these lengths. It does not support the lag's place in the state: in the dry runs "T2 better" also came where the giving reads only the level (24.5% of archives) or only itself (12%). Nor does it show T2's law, which is not fitted here.
- It does not change [08's verdict](../../theories/becoming/chapters/08-METHOD.md#known-results) that what survives of the account is no discovery, though 08 names a prediction that could fail and does not among what would. What it bears out, three numbers holding their own against a longer embedding on about 20 training rows, is in large part what the field's own bound of about √N coordinates foresees (DESIGN §4; F at D ≥ 3 held 6 or 8 coordinates and lost most). In the dry runs it came also where the giving reads less than T2's state (24.5% of the regime's step's archives, against 33% under T2's law), and both states trailed persistence. Its sharpest part is F at D = 2, four coordinates, within that bound, losing in 16 of 22 stocks: one test, on assessment outputs.

**The answer expected was "not separated", and it was not borne out.** The design expected it from one model of MQ5's readings, the mixed world: a third of the stocks carrying an age structure's memory and the rest following T2's law. There the test said "not separated" in 94% of archives and "T2 better" in 6% (§1, §7). In the design's own terms, "T2 better" places the stocks "nearer a world whose state N holds than MQ5's readings do" (§1); under T2's law the test said it in 33% of archives.

The output does not show why the expectation missed. Read after the run, not frozen:
- **The pairing with MQ5's S3**, reported as frozen, gives a gap, the median r below MQ5's bound less that at or above it, of −0.039: +0.134 over the 39 stocks below, +0.173 over the 26 at or above. That lies within the range of archives in both T2's world (−0.95 to 0.29) and the mixed world (−0.135 to 0.705), below the 0.3 beyond which §7 says the pairing would suggest a minority carrying memory. So it suggests no such minority, and cannot show one absent (§8).
- **S3 flagged 26 of the 65 stocks** in sample, within the mixed world's 22 to 39 of 66 and above every archive of T2's world (6 to 14). So the in-sample excess stays unexplained by T2's world alone.

The run is consistent with a minority of stocks whose memory does not pay its way out of sample at these lengths, an outcome the mixed world gave in 6% of its archives, and with an in-sample excess that does not carry out of sample. It does not tell them apart.

**Beside the dry runs** (read after the run, not frozen). No one world of §7 reproduces the run's reported figures.
- **On persistence** the run lies with the worlds where the giving reads less than T2's state, or carries an age structure. There the three numbers did worse than persistence in 81.5% of the stocks, their skill against it −0.85. In the MQ4, drifting and age worlds the figures were 78.8% to 89.4% and −0.90 to −1.86, against 50% and −0.01 in T2's own world and 62% and −0.40 in the mixed one.
- **On the escapement alone** (median log ratio to the three numbers' error +0.71) and **the three numbers' skill against the training mean** (+0.23), it lies inside the ten worlds' spread (0.06 to 1.47, and 0.12 to 0.78) without pointing to any one of them.
- **The run's median r of +0.163** lies within the range of the archives' medians in T2's world, the mixed one, MQ4's and the drifting one: up to +0.30, +0.31, +0.44 and +0.35.

**Also reported.** The escapement alone, the regime's step's state, had a held-out error about twice the three numbers' in the median stock (median log ratio +0.71). That is one year ahead, not the five steps T2's second forbidden item reads. The three numbers were read linearly (θ = 0) in 26 of the 65 stocks.

**The other and control groups, reported only.** The other group, 21 of its 24 stocks testable, is not separated: median r +0.003, the embedding better in 10 stocks and the three numbers in 11, p = 1. There the three numbers did worse than persistence in 11 of the 21 stocks and the embedding in 12. The control group's 5 stocks, from biomass dynamics models, are too few for a verdict.

**The checks and the data.** Before any rule was computed, two checks passed.
- The run's stocks equalled MQ5's committed fits: stock, assessment, years, last training year, the draw's share and the level's scale exactly, and the level law's two coefficients within a relative 10⁻⁹.
- The primary and other groups' median S3 excess, recomputed from the series by MQ5's code, equalled MQ5's committed values within 10⁻⁹.

It ran under Python 3.11.2 in 80 seconds of CPU. The workbook is the RAM Legacy Stock Assessment Database v4.66, assessment data only (Zenodo record 14043031, CC-BY-4.0). The archive's size, 111,883,889 bytes, and its md5 equal those the design and Zenodo give, and the workbook's sha-256 is written with the output. It was downloaded on Ren's yes into a folder outside the repository and is not copied into it. The output holds each stock's identifier, its states' errors, chosen dimensions and θ, and no series value.

**What follows.** The run's limits are the design's (§10): assessment outputs, not the survey series T2's *Refuted by* names; about 20 training rows in the median stock; one step ahead only. T2-PROPOSALS' proposal 3 still waits on a frozen run that fails "as far as anything measured does"; this one did not fail it.
