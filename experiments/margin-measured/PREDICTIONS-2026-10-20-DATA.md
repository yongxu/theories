# D1-D2 on Dai et al.'s data: the analysis and an addendum, frozen 20 October 2026 before any value was read

Board item MQ1. AI-written. D1 and D2 are frozen in [PREDICTIONS-2026-10-20.md](PREDICTIONS-2026-10-20.md) ("Test bed A, data"). This file records how the data were obtained, how the frozen rules were implemented, a synthetic null calibration, and an addendum (D1′, D2′ and an interpretation rule). All were committed before any real data value was read. The original D1 and D2 run exactly as frozen, and their verdicts are kept whatever the addendum says.

## Data

Ren approved downloading the three Dryad archives ("please"). Dryad's file links sit behind a bot check that may not be completed, and its API needs a token. Ren then approved the Zenodo mirror ("approve the Zenodo mirror"). Zenodo record 5003142 carries DOI 10.5061/dryad.p2481134, the four authors, CC0, and the same file names and byte sizes as Dryad's listing (29,564 / 19,426 / 2,772). The md5 checksums of the downloaded archives match Zenodo's (bifurcation `3891af7573f1afa105d9bc1ce9f03f1b`). The archives were extracted outside the repository, each in its own directory, and are not committed. The README PDFs were not downloaded, because the approval covered the data archives only.

**Layout**, read from the files with every digit masked, before any value was seen. `dilution{DF}_day{d}.txt` for DF ∈ {250, 500, 750, 1000, 1133, 1266, 1400, 1600}, d = 1–7: 8 lines × 11 numbers, one plate snapshot. Assumption: the same (line, column) position is the same population on each day of one DF. One masked entry showed a minus sign, so some readings are negative: instrument noise around zero.

## Implementation of the frozen rules ([`yeast_data.py`](yeast_data.py))

- "Nonzero" and "alive" are read literally as > 0, "extinct" as ≤ 0.
- D1 uses triples of one population on consecutive days, all > 0, over days 1–7.
- D2's "lower crossing" is the lowest *upward* crossing of the fitted log ratio within the data's range (the unstable point). The start is the day-1 reading and the outcome is day 7.

## Synthetic null (before the real run)

[`synth_null.py`](synth_null.py) writes files in the same layout from the Markov two-phase model of [`yeast.py`](yeast.py), where density is the state, with additive measurement noise N(0, 50) cells/µl (assumed). Result ([`results/data/null/VERDICTS-data.json`](results/data/null/VERDICTS-data.json)): **D1 failed and D2 failed on data where density is the state.**

- D2 fails because extinct wells read slightly above 0.
- D1 fails at DF 250 (a 15% reduction). A cubic in log n_t does not fit the two-phase map, and in a nearly deterministic system the previous density is a function of the current one, so adding it absorbs the misfit.

So D1 and D2 as frozen can fail without any hidden state. Their verdicts on the real data are still reported as frozen, but on this calibration a failure is not evidence against the density as state.

## Addendum (frozen now, before the real run)

- **Detection floor L** = 3 × the root mean square of all negative readings in the bifurcation files, pooled over dilution factors and days.
- **D1′** = D1 restricted to triples with all three readings > L. **D2′** = D2 with "alive" meaning > L, "extinct" meaning ≤ L, and pairs > L.
- Synthetic null under the addendum: D1′ fails only at DF 250 (13.9%); D2′ fails only at DF 1400 (83% of low starters extinct, against 90%).
- **Interpretation rule.** A DF where the real data fail D1′ (or D2′) and the synthetic null passes it counts as evidence against "density is the state" (or against a sharp need). A DF where both fail is uninformative. A DF where the real data pass is consistent with the account.

D1′ and D2′ have the same pass rules as D1 and D2.
