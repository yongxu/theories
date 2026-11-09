# Empirical dynamic modelling, read for UE32

UE32, 3 November 2026. AI-written (a Claude Code session, through a subagent it sent to read; no person's review of it is recorded). It is the reading behind [UE32](README.md): the field that reads a state from a series without naming it in advance, and what it would count as a fair test of a state named in advance. Each source says how it was read; "read" means its text was read, and a source read only through a summary or an abstract says so. About 45 to 55 minutes to read (5,700 words); Part 3, what the field would count as a fair test, in ten.

How things were read. "PDF text" means I pulled the PDF with the fetch tool, turned it into text with pypdf, and read that text myself. "Fetch summary" means a fetch tool read the page and summarised it for me, so I didn't see the raw text. Numbers I never saw in any text are marked **not seen**. Anything from my own memory is marked **from memory**. No data files were downloaded. No CAPTCHA or bot check was bypassed. The report quotes directly only once (Ward 2014, on RAM Legacy SSB). Everything else is paraphrased, with numbers located by table, figure or page.

Sites that refused: nature.com (redirect to an idp.nature.com cookie/authorisation endpoint, not followed), royalsocietypublishing.org (403), onlinelibrary.wiley.com (403), science.org (403), biorxiv.org (403), link.springer.com (cookie redirect, not followed), int-res.com (429, rate limit), library.ucsd.edu (Anubis bot wall, not bypassed), marineinfo.org (406).

---

## Part 1. Sources, in the order asked

### 1. Sugihara G. & May R.M. (1990) Nature 344:734–741
- URL tried: https://www.nature.com/articles/344734a0. Redirects to an authorisation endpoint, so **not reachable**. No open copy found.
- Read in its place: May R.M. (1995), "Necessity and chance: deterministic chaos in ecology and evolution", Bull. AMS 32:291–308, arXiv math/9507222 (https://arxiv.org/pdf/math/9507222). I read the passage on the method as PDF text (pp. 4–6). May is a co-author of the 1990 paper, but this is still a secondary account.
- The method as May states it:
  - Build a library of lagged vectors {x_t, x_{t−τ}, …, x_{t−(E−1)τ}}.
  - For each predictee, take the E+1 nearest library points (the simplex) and project them p steps ahead, weighting exponentially by distance.
  - Score skill as Pearson ρ between predicted and observed values, plotted against prediction time Tp.
  - E and τ are free parameters, set to whatever gives the highest ρ.
  - Out of sample: the first half of the series builds the library and the second half is predicted (or the reverse). The alternative is the whole series with a 5-year window around each predictee removed.
- How chaos is told from noise: under low-dimensional chaos, ρ falls as Tp grows, at a rate that estimates the Lyapunov exponent. For uncorrelated noise, May says, forecast accuracy stays about the same at every prediction interval. He adds that for short series, chaos and coloured (autocorrelated) noise are hard to tell apart.
- Numbers (May 1995 Figs 1–2): England & Wales measles 1948–66 used E = 8, τ = 2, and ρ vs Tp was flat (periodicity plus noise). Birmingham measles used E = 7, τ = 2, and ρ declined with Tp (chaos).
- **Not seen**: the 1990 paper's own chickenpox and diatom E values and series lengths.

### 2. Sugihara G. (1994) Phil. Trans. R. Soc. A 348:477–495 (S-map)
- URL tried: https://royalsocietypublishing.org/doi/10.1098/rsta.1994.0106 (403). **Not reachable**. Only the abstract was seen in a search snippet.
- The S-map and θ as later practitioners state them (all read as PDF text):
  - Deyle et al. 2018, Fish Fish 19:769, §2.5: weights are w(d) = exp(−θ d / d̄). At θ = 0 the S-map is a global linear map (a VAR/AR model). Nonlinearity is read as forecast skill improving for θ > 0: Δρ = ρ − ρ(θ=0). θ was varied from 0 to 5, and significance came from 500 phase-randomised (Ebisuzaki) surrogates.
  - Clark & Luis 2020 Methods: θ was varied 0–8 at the simplex-chosen E. A series counted as nonlinear if ΔMAE = MAE(θ=0) − MAE_min was positive and significant (P ≤ 0.05) against 1,000 phase-randomised surrogates.
  - Pierre et al. 2018: θ was searched from 0 to 1 in steps of 0.01. θ = 0 equals AR(E), i.e. red noise.

### 3. Takens F. (1981), as the EDM literature cites it, and Deyle E.R. & Sugihara G. (2011) PLoS ONE 6:e18295
- How the EDM literature states Takens:
  - Munch et al. 2020 FAQ (PDF text, Background and Q5): the number of delay coordinates must exceed 2d, where d is the attractor dimension, not the system dimension. Fewer often suffice in practice (the chaotic Ricker map needs 2, not 3).
  - Munch et al. 2018 (PDF text, §2.2) writes "E > 2M" in a passage that defines both M and d, so the condition is stated loosely there.
  - Munch, Rogers & Sugihara 2023, MEE 14:732 (PDF text, §2): "E ≥ 2d is sufficient", attributed to Whitney.
- Deyle & Sugihara 2011: I read the full-text XML from Europe PMC (PMC3069082) myself. The formulas are images, so I fetched and viewed the key ones (e089, e247).
  - Theorem 1: on a compact m-dimensional manifold, a map built from 2m+1 distinct observation functions (different measured variables, no lags) is generically an embedding.
  - Theorem 2: 2m+1 observation functions restricted to stated lag relationships, i.e. a mix of several variables and their lags, is generically an embedding. This needs finitely many periodic points of each period and distinct Jacobian eigenvalues ≠ 1 at them.
  - Theorem 7 extends Sauer et al. (1991) Remark 2.9 to non-consecutive lags, under prevalence.
  - Discussion: the results support building a state from multiple time series. They are offered as a way to extract more from short series with many simultaneous observations and to reduce correlated noise between coordinates. The results are generic, so exceptions exist (e.g. the Lorenz symmetry, Fig. 1C).
  - **Answer to the question asked: yes.** A state may be built from several different observed variables and their lags, with 2m+1 coordinates in total, as a generic (not universal) property.

### 4. Sugihara G. et al. (2012) Science 338:496–500 (CCM)
- URL used: https://www.science.ntu.edu.tw/wp-content/uploads/2012/10/causalityCCM.pdf (author-institution copy). I read the main text in full as PDF text. The supplement was **not read**.
- The criterion: X causes Y if the historical record of Y can estimate the states of X (cross-mapping from M_Y to X). Convergence is required: cross-mapped estimates must get better as the library length L grows.
  - With noisy field data, CCM is shown by predictability increasing with L.
  - Under strong unidirectional forcing (synchrony), cross-mapping can converge in both directions, so synchrony must be ruled out.
- Fish data: California landings of Pacific sardine and northern anchovy, plus SST at Scripps and Newport Piers. Library lengths ran about 20–60 (Fig. 5D–F).
  - No significant sardine–anchovy cross-map.
  - Asymmetric convergent cross-map sardine→SST and anchovy→SST, read as temperature forcing both.
  - E values: **not seen**.

### 5. Glaser S.M. et al. (2014) Fish and Fisheries 15:616–633
- URL tried: https://onlinelibrary.wiley.com/doi/full/10.1111/faf.12037 (403). No repository copy found: NTU Scholars lists metadata only. Seen: the abstract (via scholars.lib.ntu.edu.tw) and statements in papers that cite it.
- From the abstract:
  - Over 200 time series of survey abundance and landings from two ecosystems.
  - Landings had the highest estimated dimensionality and were significantly less predictable than abundance indices.
  - Unfished species had higher dimensionality than fished species, and fished species were more likely to be nonlinear.
  - About 70% of series were predictable at a 1-year horizon, and predictability declined exponentially over 5 years.
- From citing papers (PDF text):
  - Munch et al. 2020 FAQ, Q5: the estimated E was < 7 in more than 90% of the 135 series Glaser et al. analysed.
  - Giron-Nava et al. 2017 says it follows Glaser et al. in using leave-one-out cross-validation with E = 1–10, choosing the E with the highest ρ. This is a statement of Giron-Nava's own method, attributed to Glaser.
- Which two ecosystems: **from memory**, the California Current and the Northeast US shelf. Not confirmed in any text I read.
- **Per-stock E, θ and ρ: not seen.** The per-series table or supplement could not be reached.

### 6. Ye H. et al. (2015) PNAS 112:E1569–E1576 (Fraser River sockeye)
- URL used: https://pmc.ncbi.nlm.nih.gov/articles/PMC4386326/. Read as a fetch summary of the full text, asked twice with targeted questions. The SI was **not read**.
- Data: 9 stocks (Birkenhead, Chilko, Early Stuart, Late Shuswap, Late Stuart, Quesnel, Seymour, Stellako, Weaver), brood years 1948–2005. Late Stuart starts in 1949 and Weaver in 1966.
  - S_t = effective female spawners. R_t = R4 + R5 by brood year.
  - Environment: PDO, SST at Entrance Island and Pine Island, and Fraser discharge, lagged 2 years.
- What the state is:
  - The "simple EDM" state is one coordinate, the transformed spawner abundance ⟨S′_t⟩, forecast by simplex with 2 neighbours. It uses the same information as the Ricker model.
  - The multivariate EDM adds 1–2 environmental coordinates (3–4 neighbours), chosen greedily by ρ.
  - Ages 4 and 5 are forecast separately and summed. The S-map is used only for the nonlinearity test.
- The rival models: standard Ricker, and extended Ricker with one environmental covariate, fitted with JAGS (posterior medians).
- How they were compared:
  - Fourfold cross-validation: fit on three quarters, predict the held-out quarter, repeat for each quarter.
  - Metrics: ρ and MAE.
  - One-sided t-tests (HC4 standard errors) and paired t-tests on MAE, with stocks pooled after standardisation.
- Results (Fig. 4 caption):
  - Simple EDM vs Ricker: t(492) = 1.77, P = 0.039. Simple EDM was more accurate in 8 of 9 stocks.
  - Multivariate EDM vs extended Ricker: t = 2.20, P = 0.014.
  - Adding environment improved EDM (P = 0.0024) but not Ricker (P = 0.10).
- Nonlinearity: an S-map test on Fraser returns gave P = 0.002. Per-stock θ: **not seen**.
- Per-stock ρ and MAE for the multivariate models (Table 1) are in the table below. Per-stock values for the simple models: **not seen** (Fig. 4 and SI Fig. S3 not read).
- Per the fetch summary of the Discussion, about 35–40 points is a rough minimum for EDM.

### 7. Storch L.S., Glaser S.M., Ye H., Rosenberg A.A. (2017)
- Citation correction: the paper is PLoS ONE 12(2):e0171644, not e0180521.
- URL used: https://pmc.ncbi.nlm.nih.gov/articles/PMC5310756/ and the PLoS page. Read as fetch summaries of the main text. S1 and S2 Tables are DOCX files and were **not read**.
- Data:
  - 49 California commercial landings series.
  - 23 CalCOFI ichthyoplankton series.
  - 36 stock-assessment outputs (nearly all Stock Synthesis; age-aggregated biomass, otherwise SSB).
  - 59 Atlantis (CCAM) outputs.
  - All series were first-differenced and standardised.
- Methods: E by simplex (following Hsieh et al. 2008), leave-one-out. Skill measured by ρ (Fisher z test, series with p ≥ 0.05 dropped), MAE and RMSE. Nonlinearity meant a significantly lower MAE for θ > 0 than θ = 0, by a randomisation test.
- Mean S-map ρ (Table 2):
  - Landings 0.259 ± 0.212
  - CalCOFI 0.559 ± 0.151
  - Stock assessment 0.667 ± 0.263
  - Stock assessment + noise (SD 0.3) 0.447
  - Atlantis 0.862
  - Atlantis + noise 0.579
- Share nonlinear (Table 3):
  - Landings 59% (of 27)
  - CalCOFI 43% (of 21)
  - Stock assessment 18% (of 33)
  - Stock assessment + noise 18%
  - Atlantis 15%
- Conclusion: model outputs are more predictable and less nonlinear than the data behind them. Adding noise lowered their predictability but did not restore nonlinearity, so the models change the dynamics rather than merely filter noise.
- E by data type: **not seen** (it is in S2 Table only; the main text makes no E comparison).

### 8. Munch S.B., Brias A., Sugihara G., Rogers T.L. (2020) ICES JMS 77:1463–1479 (FAQ)
- URL used: https://par.nsf.gov/servlets/purl/10230196. I read the full text as PDF text.
- How E is chosen (Background): minimise prediction error, use cross-validation, or use mutual information. τ is usually 1 for annual data.
- How long a series must be (Q4):
  - Several multiples of the system's return time.
  - Significant error reductions are often seen with more than 30 years of data, especially for short-lived species.
  - Munch et al. 2018 found more than 50% of recruitment variance explained when the series length was about ten times the age at maturation.
  - The largest usable embedding dimension grows roughly as the square root of the series length (Cheng & Tong), so a 50-year series should give E < 7.
- E is not the number of species (Q5). Goodness-of-fit methods often return E below 2d+1.
- Performance metric (Q6): R²_pred = 1 − V_pred/V_0, i.e. one minus the scaled mean square error, where using the mean as the prediction scores 0.
- When EDM fails (Q10):
  - Monotonic trends, strong nonstationarity and large observation error.
  - Species whose lifespan exceeds the series length (rockfishes).
  - Linear time-series models and dynamic linear models are likely to win under strong nonstationarity or large observation noise.
  - A mechanistic model is expected to win when its structure is a good approximation of the true dynamics.
- Checking mechanistic models (Q9 and Conclusions): fit the mechanistic model, then test whether its residuals are predictable by EDM (residual delay maps). Predictable residuals mean wrong shape or missing state variables.

### 9. Rogers T.L., Johnson B.J., Munch S.B. (2022) Nat. Ecol. Evol. 6:1105–1111
- URL used: https://repository.library.noaa.gov/view/noaa/59599/noaa_59599_DS1.pdf. I read the main text, Methods and Extended Data captions as PDF text. The Supplementary Information and code repository were **not read**.
- Data: GPDD field-survey series only (harvest and lab data excluded), with at least 30 points. 172 series in total, of which 17 were bony fishes. 15 of the 17 fish series came from one location.
- Methods: Jacobian Lyapunov exponent from a local-linear delay-embedding model.
- Results:
  - 34% of all series were chaotic (30% after reclassifying 6).
  - Bony fishes: 29% chaotic (Fig. 2).
  - Restricting to E = 1 cut overall chaos to 9.9%, i.e. one-dimensional models find under a tenth of series chaotic.
  - Chaos was 42% in series with at least 50 points and 58% in series with at least 70 points.
  - E fell with generation time (r = −0.30).
- Per-series E and LE: **not seen** in the text (code repository, Zenodo 10.5281/zenodo.6499470).

### 10. Other studies found
Each is listed with what was read.

**Munch, Giron-Nava & Sugihara (2018) Fish Fish 19:964–973**
- URL: https://par.nsf.gov/servlets/purl/10093771. Read in full as PDF text; supplement not read.
- Data: 185 stocks with at least 20 years of both SSB and recruitment, from the Myers "RAM" stock–recruitment database (not RAM Legacy). Estimation methods: BDM 62, SCA 4, SPA 101, SUR 18.
- Method:
  - GP-EDM with automatic relevance determination. The input set is x_t = {S_t, …, S_{t−E}, y_{t−1}, …, y_{t−E}} with y = ln(R/S), up to 5 lags each (E_max = 11).
  - Leave-one-out cross-validation.
- Results:
  - Effective E ≤ 4 in 177 of 185 stocks, and E > 1 in 140 of 185.
  - Where E > 1, past recruitment, not stock size, was most relevant in 84% of cases.
  - π_EDM = 1 − V_EDM/V_Y: mean 0.39, IQR 0.20–0.54 (Table 1, by order).
  - Rivals (Table 2, mean variance explained): Beverton–Holt 0.11, Ricker 0.04, Schnute 0.12, GP-SR 0.08, AR on the same inputs −1.70, regularised AR −0.07.
  - EDM beat the single-input stock–recruitment models in at least 83% of stocks and the AR in 96%.
  - Recruitment from surveys and SPA was more predictable than from BDM or SCA (Fig. 2d). The authors conclude that recruitment's predictability is not an artefact of fitting to assessment output.

**Pierre, Rouyer, Bonhommeau & Fromentin (2018) ICES JMS 75:903–911**
- URLs: main text https://archimer.ifremer.fr/doc/00408/51930/52555.pdf, Appendices 1–3 52557, 52558, 52559.pdf. All read as PDF text. I also rendered Appendix 1 p. 1 as an image to check the columns.
- Data: RAM Legacy (295 stocks with SSB and R) plus an ICES/NAFO compilation (25 stocks with SST). Kept: series of at least 40 consecutive years, excluding series from models that integrate a stock–recruitment relationship. That left 53 stocks, mean length about 50 years.
- Methods:
  - τ = 1. Simplex E tested from 2 up to a quarter of the series length.
  - Cross-validation: the first half of the embedded vectors forms the library (the attractor estimate) and the second half is the test set.
  - S-map θ from 0 to 1. Skill measured as MASE against the naive last-value forecast.
- Results:
  - Most stocks had θ > 0 (Fig. 4a).
  - 30 of 53 had MASE < 1.
  - The univariate R attractor was mostly best. Adding SSB gave no significant improvement (Wilcoxon W = 530, p = 0.10).
- Per-stock E for R and SSB are in Appendix 1, copied in the table below. Summary across the 53:
  - E_SSB median 3, with 26 of 53 at E = 2, the bottom of the tested range.
  - E_R median 6, range 2–24.
  - The median naive-forecast error was 0.23 for SSB against 0.74 for R, in standardised units.
- Per-stock θ and MASE: **not seen**. The 9-page "Supplementary Data" PDF holds only CCM plots.

**Deyle et al. (2013) PNAS 110:6430 (Pacific sardine)**
- URL: PMC3631642. Read as a fetch summary.
- Data: CalCOFI sardine larvae 1950–2007, as an index of spawning biomass, first-differenced. Simplex E range 1–8 gave E = 3. θ was fitted over 0 < θ < 10 (value **not seen**).
- Out of sample: 22 target points. For each, E and θ were chosen by cross-validation on the other 21, so effectively leave-one-out.
- Results (Table 1): univariate ρ = 0.3213. With SIO Pier SST, ρ = 0.4085 (P = 0.04). With PDO, ρ = 0.3968 (P = 0.04). Surrogates: 500 Ebisuzaki.

**Deyle et al. (2018) Fish Fish 19:769–781 (menhaden)**
- URL: https://repository.library.noaa.gov/view/noaa/51798/noaa_51798_DS1.pdf. Read as PDF text (methods and results).
- Data: deliberately uses empirical indices (juvenile abundance index, LPUE) rather than assessment output, citing Brooks & Deroba 2015 and Storch 2017.
- Methods: simplex and S-map with leave-one-out cross-validation. ΔLPUE (first differences) is used to avoid the trivial prediction that autocorrelation gives.
- Results:
  - Next year's JAI from lags of LPUE needs multiple lags (5 in the Atlantic) to forecast best. The authors conclude that recruitment does not depend on stock size alone.
  - Skill is compared against a constant-predictor baseline.
  - Per-series E: **not seen** as numbers (Fig. 4).

**Ward, Holmes, Thorson & Collen (2014) Oikos 123:652–661**
- URL: https://eeholmes.github.io/publications/Wardetal2014.pdf. Pages 1–7 read as PDF text; Appendix not read.
- Data: 2,379 series, including 214 RAM Legacy productivity series, ln(R/S). They left out RAM Legacy SSB because its "adult spawning biomass time series are smoothed output from stock assessment models".
- Design: 49 models. The last 5 points were held out, forecasts were 1–5 steps ahead, and skill was MASE against a random walk.
- Results: S-MAP was among the worst models. Simplex only matched the best for cyclic pink and sockeye salmon. A random walk without drift was near-best for marine fish productivity.

**Giron-Nava et al. (2017) MEPS 572:269–274**
- URL: https://par.nsf.gov/servlets/purl/10063945. Read in full as PDF text.
- Data: plankton (CPR), not fish stocks.
- Methods: leave-one-out cross-validation, E = 1–10, Δρ against 100 surrogates.
- Results:
  - Nonlinearity detection rose with data availability: 11% for ≤ 37 non-zero points, 57% for 38–460, 82% for ≥ 461.
  - Forecast skill rose with segment length (25, 50, 100, 200, 400).
  - 2-fold and leave-one-out cross-validation gave similar skill.

**Klein et al. (2016) MEPS 557:237–246 (Bay of Fundy catch)**
- URL: https://repository.library.noaa.gov/view/noaa/65288/noaa_65288_DS1.pdf. Read as PDF text (pp. 1–6).
- Data: landings, 47-year windows. Table 1 gives species-level predictable %, nonlinear % and mean ρ. Per-series E: **not seen**.
- They chose catch over assessment output, citing Storch (then unpublished): assessment estimation can fail to keep nonlinear signals.

**Anderson et al. (2008) Nature 452:835**
- URL: https://www.science.ntu.edu.tw/wp-content/uploads/2008/04/WhyFishingVar.pdf. Results read as PDF text.
- Data: CalCOFI larval fish, composited end to end.
- Results: θ = 0.3 for both groups. Δρ was 0.083 for fished species (P < 0.01) and 0.037 for unfished (P = 0.25). The linear ρ was 0.514 vs 0.504. No per-stock values.

**Clark & Luis (2020) Nat Ecol Evol 4:75–81**
- URL: https://www.umt.edu/disease-ecology-lab/files/clark2020nee.pdf. Read as PDF text (abstract, results, methods).
- Data: 747 series, 54 bony-fish species, at least 30 points each.
- Methods: E = 1–10, θ = 0–8, 1,000 surrogates, leave-one-out.
- Results: 49% of fish nonlinear, 78% predictable. Per-series values in the SI: **not seen**.

**Perretti, Munch, Fogarty & Sugihara (2015) arXiv:1509.01434**
- Read as a fetch summary of the HTML.
- Data: 569 recruitment series from the Myers database, at least 10 years each (mean 20.7).
- Method: simplex with E = 1–4, leave-one-out, tested against AR(0)/AR(1) surrogates.
- Results: the distribution of the probability of randomness is skewed toward low values. Per-stock values: **not seen**.

**Perretti, Munch & Sugihara (2013) PNAS 110:5253 (PMC3612644); Hartig & Dormann reply (arXiv:1305.3544)**
- Perretti 2013: read as a fetch summary. Simulations used 50 training and 50 test years. Skill was standardised RMSE on the test set. The correctly specified model fitted by MCMC was usually beaten by state-space reconstruction (S-map with E and θ from cross-validation) at short horizons.
- Hartig & Dormann: abstract only. They argue the gap came from the fitting method, and that a modified fit removes the bias and reverses the result.

**Hechler & Krkosek (2025)**
- bioRxiv 10.1101/2025.07.13.664566 (biorxiv 403). Abstract read via the Europe PMC record PPR1050769. Probably the same work as Nat Ecol Evol s41559-025-02968-1 (not reached).
- Data: 243 recruitment and 267 spawner series from 143 species. RAM Legacy as the source is **not confirmed**.
- Results: 81% nonlinear, low-dimensional, temperature-forced in 60%. A search snippet gives 201/243 recruit and 214/267 spawner series nonlinear, by S-map θ maximising leave-one-out ρ. That snippet is **not seen in the text**.
- Per-stock values: **not seen**.

**Abstract only**
- Liu et al. (2012) MEPS 464:195 (int-res 429): 26 Georges Bank species from the NEFSC survey, 1963–2008. About 1 in 5 showed complex dynamics, and many had low dimensionality. Per-species values **not seen**.
- Hsieh et al. (2005) Nature 435:336 (PMID 15902256): North Pacific biological series were low-dimensional nonlinear; physical series were linear stochastic.
- Hsieh, Anderson & Sugihara (2008) Am Nat 171:71 (PMID 18171152): pooling similar species lets series as short as 20 points be analysed.
- Glaser et al. (2011) CJFAS 68:400: North Pacific albacore CPUE in 1°×1° cells, 40 years, low-dimensional nonlinear.

**Read in part**
- Tsai et al. (2024) ICES JMS fsae080: brown shrimp. Guideline that feasible E ≤ √N.
- Munch, Rogers & Sugihara (2023) MEE: choose E and τ by forecast accuracy, preferring the smaller value when results are indistinguishable. Uneven lags are justified by Deyle & Sugihara.

**New Zealand**
- No EDM paper giving E or θ for a New Zealand stock was found. Of the per-stock tables I read, Pierre et al.'s 53 stocks contain no NZ stock. The nearest is jackass morwong, SE Australia.
- Munch et al. 2018 and Hechler & Krkosek 2025 may include NZ stocks. Their stock lists were **not seen**.

---

## Part 2. Table of per-series estimates

Reading the columns:
- E_R and E_SSB come from simplex projection.
- "nonlin." gives θ or the nonlinearity test.
- Skill is ρ unless stated.

### Pierre et al. (2018), ICES JMS 75:903, Supplementary Appendix 1

How these were produced:
- E chosen by simplex over 2 … N/4, with a first-half/second-half split.
- Data type: assessment-model outputs, recruitment (R) and SSB, from RAM Legacy or ICES/NAFO.
- Per-stock θ and skill (MASE): **not seen**. Fig. 4a says most stocks had θ > 0.
- Length is in years. "naive err R / SSB" is the denominator of MASE, not EDM skill.

The rows for the stocks T2's tests read are in [STOCKS.md](STOCKS.md), with how each was matched. The other rows are not copied here; across all 53 stocks E_SSB has median 3, with 26 at the floor of 2, and E_R median 6, range 2 to 24 (§10 above).

### Other per-series or per-group estimates

| stock or series | region | data type | E | θ / nonlinearity | skill | source |
|---|---|---|---|---|---|---|
| Birkenhead sockeye | Fraser R., BC | spawners→recruits (returns) | multivariate EDM state ⟨S⟩ | S-map test on Fraser returns, P = 0.002 (aggregate) | multivariate EDM ρ 0.156, MAE 0.259; extended Ricker ρ −0.111, MAE 0.251 | Ye 2015 Table 1 |
| Chilko | same | same | ⟨S⟩ | same | 0.264 / 0.839; Ricker 0.268 / 0.825 | same |
| Early Stuart | same | same | ⟨S, D_apr, D_jun⟩ | same | 0.878 / 0.140; Ricker 0.737 / 0.172 | same |
| Late Shuswap | same | same | ⟨S, D_may, PT_jul⟩ | same | 0.923 / 0.821; Ricker 0.875 / 0.842 | same |
| Late Stuart | same | same | ⟨S, D_jun, ET_apr⟩ | same | 0.783 / 0.250; Ricker 0.552 / 0.423 | same |
| Quesnel | same | same | ⟨S, PT_may, PDO⟩ | same | 0.861 / 0.729; Ricker 0.387 / 2.057 | same |
| Seymour | same | same | ⟨S, PT_jul⟩ | same | 0.734 / 0.065; Ricker 0.571 / 0.076 | same |
| Stellako | same | same | ⟨S, PT_apr, PDO⟩ | same | 0.531 / 0.217; Ricker 0.191 / 0.250 | same |
| Weaver | same | same | ⟨S, D_apr, D_may⟩ | same | 0.573 / 0.176; Ricker −0.094 / 0.215 | same |
| Pacific sardine | California Current | CalCOFI larvae (SSB index), first-differenced | 3 | θ fitted 0–10, value **not seen** | ρ 0.321 univariate; 0.409 with SIO SST | Deyle 2013 Methods, Table 1 |
| 36 assessed stocks (group) | California Current | assessment biomass/SSB | **not seen** (S2 Table) | 18% nonlinear (of 33) | mean ρ 0.667 | Storch 2017 Tables 2–3 |
| 49 landings series (group) | California | landings | **not seen** | 59% (of 27) | 0.259 | same |
| 23 CalCOFI series (group) | California Current | larval survey | **not seen** | 43% (of 21) | 0.559 | same |
| 185 stocks (group) | global, Myers database | recruitment (with SSB inputs) | GP-EDM effective E ≤ 4 in 177; > 1 in 140 | (GP; not θ) | mean variance explained 0.39 | Munch 2018 §3, Tables 1–2 |
| 135 series (group) | two ecosystems | survey + landings | < 7 in > 90% | fished species more often nonlinear | ~70% predictable at 1 yr | Glaser 2014 via Munch 2020 Q5 and abstract; per-stock **not seen** |
| Cod / haddock / pollock / herring, contemporary 1967–2014 | Bay of Fundy | landings | **not seen** | 80 / 60 / 20 / 71% of predictable series | mean ρ 0.24 / 0.46 / 0.35 / 0.36 | Klein 2016 Table 1 |
| Same, historical 1873–1920 | same | landings | **not seen** | 40 / 83 / 50 / 50% | 0.40 / 0.52 / 0.37 / 0.37 | same |
| CalCOFI fished vs unfished (group) | S. California | larvae | **not seen** | θ = 0.3 both; Δρ 0.083 vs 0.037 | linear ρ 0.514 vs 0.504 | Anderson 2008 text |
| Atlantic menhaden | US Atlantic | JAI survey; LPUE | 5 lags of LPUE best for JAI(t+1); univariate E **not seen** (Fig. 4) | θ 0–5; JAI nonlinear p < 0.05; LPUE p < 0.2 | **not seen** as numbers | Deyle 2018 §3 |
| 17 bony-fish series (group) | GPDD, mostly one site | field survey | per-series **not seen** | 29% chaotic (Jacobian LE) | **not seen** | Rogers 2022 Fig. 2 |
| 54 bony-fish species (group) | GPDD and others | survey | **not seen** | 49% nonlinear | 78% predictable | Clark & Luis 2020 |
| 243 R + 267 SSB series (group) | global | assessment R / SSB (source **not seen**) | "low-dimensional" | 81% nonlinear | **not seen** | Hechler & Krkosek 2025, abstract |
| 26 Georges Bank species | NE US | NEFSC trawl survey | "low" | ~1 in 5 complex | **not seen** | Liu 2012, abstract |

---

## Part 3. What the field would count as a fair test of a named three-variable state against its fitted embedding

This section is my synthesis of the practices cited. It is not a criterion any one paper states.

### 1. Skill is out of sample, scored the same way on the same points
- The core measures are Pearson ρ and MAE, often with RMSE alongside. Sugihara & May 1990 via May 1995, Storch 2017, Klein 2016, Deyle 2018.
- Scale-free versions are also used:
  - MASE against the naive last value: Pierre 2018, Ward 2014.
  - R²_pred = 1 − MSE/Var, or standardised MSE/RMSE where the mean scores 0 (or 1): Munch 2018, Munch 2020, Perretti 2013.
- Significance:
  - ρ > 0 tested by Fisher z (Storch 2017).
  - Nonlinearity (Δρ or ΔMAE for θ > 0) tested against 100–1,000 shuffled or phase-randomised surrogates: Giron-Nava 2017, Deyle 2013 and 2018, Clark & Luis 2020.

### 2. How E is chosen
- By simplex forecast skill over a grid, usually E = 1–10. Take the maximum ρ or minimum MAE, or the smaller E when results tie (Munch 2023).
- The out-of-sample scheme is one of:
  - leave-one-out: Glaser 2014 as reported by Giron-Nava; Storch; Clark & Luis; Deyle 2018; Munch 2018
  - first half vs second half: Sugihara & May via May 1995; Pierre 2018
  - fourfold blocks: Ye 2015
  - last-5-points holdout: Ward 2014
  - nested cross-validation on all other points: Deyle 2013
- Annual data use τ = 1. The feasible E is bounded by about √N (Munch 2020 Q4–5; Tsai 2024).
- In a stochastic, short-series setting, E is an index of what forecasts best, not a count of variables (Munch 2020 Q5; Giron-Nava 2017).

### 3. Minimum lengths actually used
- 20 years of both S and R: Munch 2018.
- ≥ 25 continuous points: Ward 2014.
- ≥ 30 points: Clark & Luis 2020; Rogers 2022. Munch 2020 says gains appear beyond about 30 years.
- About 35–40 points as a rough minimum: Ye 2015, per the fetch summary.
- ≥ 40 consecutive years: Pierre 2018.
- 47-year windows: Klein 2016.
- Detection power keeps rising up to 50–70 points and beyond: Rogers 2022; Giron-Nava 2017.
- Series should cover several return times, or about 10 generations for more than 50% variance explained: Munch 2020 Q4.

### 4. Published comparisons of a named or mechanistic state against EDM
- **Ye 2015.**
  - Ricker vs simple EDM with the same single coordinate S_t.
  - Extended Ricker vs multivariate EDM.
  - Same fourfold held-out quarters, ρ and MAE, one-sided t-tests.
  - EDM won in 8 of 9 stocks.
- **Munch 2018.**
  - GP-EDM vs Beverton–Holt, Ricker, Schnute, GP-SR, and AR with the same inputs (raw and regularised).
  - Leave-one-out, variance explained.
  - EDM won in at least 83% of stocks against the stock–recruitment models and 96% against AR. The regularised AR came closer.
- **Perretti 2013.** The correctly specified mechanistic model fitted by MCMC vs S-map state-space reconstruction, on 50/50 train/test splits with standardised RMSE. Hartig & Dormann (2013) argue the loss came from the fitting method.
- **Ward 2014.** On RAM productivity, simple AR and random-walk forecasts beat S-map. This is a published counter-result.
- **Rogers 2022.** Constraining to E = 1 or to 1-D parametric forms cuts chaos detection from 34% to below 10%.
- **Deyle 2018 and Pierre 2018.** Tests whether one lag of stock suffices for recruitment. In Deyle, multiple lags were needed. In Pierre, adding SSB to R lags did not help.

### 5. What this implies for T2's test
These are implications drawn from the papers above, not rules any paper states.

**Use the same machinery, inputs and splits for both states.** A fair test gives T2's named state the same forecasting machinery as the fitted embedding:
- Use (E_t, recent net production, E_{t−1}) as the coordinates of a simplex/S-map or GP map. Deyle & Sugihara's Theorem 2 licenses such a mixed state in principle.
- Compare it with the delay embedding whose E is chosen by the same cross-validation, nested inside the training data.
- Score both on the same held-out points with ρ, MAE and MASE or R²_pred.
- Report against persistence or naive and AR(E) baselines (θ = 0), with surrogate tests. Include multi-step horizons Tp, since decay with Tp is the field's diagnostic.

**The closest published design is Munch 2018.** Its input set {S_t…S_{t−5}, ln(R/S)_{t−1}…} contains T2's three numbers as a subset. ARD lag selection there found effective E ≤ 4 in 96% of stocks, and production history mattered more than stock in 84% of E > 1 cases. Munch's target is recruitment, not escapement, so the match is in inputs, not target.

**Assessment-output data need care.** Three of the papers read point the same way:
- Storch 2017: assessment outputs are more predictable and less nonlinear than the data behind them.
- Ward 2014: RAM Legacy SSB is smoothed model output.
- Pierre 2018: the SSB naive error was about a third of recruitment's, and half the SSB E values sat at the floor of the tested range.

So a low-dimensional state fitting RAM SSB well may partly reflect the assessment model's own structure. The field's remedies are:
- forecast first differences, not levels (Storch; Deyle 2018)
- check on survey or catch indices where they exist (Deyle 2018; Klein 2016)
- or stratify by estimation method (Munch 2018 found survey and SPA recruitment more, not less, predictable)
