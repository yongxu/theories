# Recipient harm and learned action

6 October 2026. Retrospective reanalysis of original public data from Hernandez-Lallement et al. (2020), *Harm to Others Acts as a Negative Reinforcer in Rats*. [Its account](../../theories/becoming/history/RECIPIENT-HARM-AND-ACTION.md), of 6 October and now in history, connects the result to the generative account of that time. No new animal experiment, stimulus delivery or model training was performed.

## Accepted descriptive result

The primary comparison retains all 12 released male contingent-harm actors and all 14 male no-harm actors. Each contributes 20 baseline and 60 subsequent offered free-choice opportunities. The original code distinguishes preferred-lever responses, alternative responses and nonperformance. One truly absent value in a secondary group remains unknown.

| Preferred responses per offered opportunity | Male contingent harm | Male no harm |
| --- | ---: | ---: |
| Baseline | 72.92% | 81.07% |
| Subsequent sessions | 51.11% | 75.95% |
| Mean within-actor change | −21.81 pp | −5.12 pp |

The difference in changes is **−16.69 percentage points** (`−841/5040`). Its decomposition is preferred responses −16.69 pp, alternatives +16.41 pp and nonperformance +0.28 pp. The conditional completed-choice contrast is a separate −16.50 pp. Each single-actor and each recorded-SBL-label omission preserves the negative primary contrast. These are descriptive influence analyses; SBL labels have no verified batch meaning and do not overlap between the primary groups. Group assignment randomization and cage identity are not established, so no randomization p-value or population confidence interval is claimed.

All 78 trial-file actors remain in [results.json](results.json), including female harm, random harm, no prior experience and unequal-food groups. The original summary contains 142 actors; this is not a full-paper raw-data audit or a complete assignment/exclusion ledger.

## Verification and source distinctions

[Independent reconstruction](independent-verification.json) passes **21,581 exact scalar comparisons**, covering every actor, all 6,240 trial slots, seven groups, six contrasts, all primary omissions, the three hypothetical completions of one blank, and 780 source-summary audit entries. Twelve deliberately corrupted output variants are rejected. [The independent review](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RECIPIENT-VALUATION-REVIEW.md) records the methods, contract and numerical acceptance. This is separate implementation by a collaborating AI, not independent collection or human peer review.

The 39 source audit flags comprise 32 missing precomputed total fields, one average over an undefined session, and six flags associated with different response denominators in three secondary actors. All primary-group per-session summary percentages agree with the trial interpretation. [The source audit](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RECIPIENT-VALUATION-EVIDENCE.md) identifies exact original cells and formulas; no original was repaired.

The [source collection](../../sources/30-recipient-harm-valuation-2026-10-06/README.md) preserves all input bytes, public OSF metadata and distinct licenses. The [protocol](PROTOCOL.md), [clarification](SCHEMA-CLARIFICATION.md) and their freeze receipts precede new aggregates, with earlier discovery and published-result knowledge disclosed. The [implementation repair](ANALYSIS-REPAIRS.md) preserves the initial parser failure on a literal `NaN`. It changed no selection, estimator or trial outcome.

## Reproduction

From the repository root, use Python 3.11 or a compatible Python 3 interpreter. The producer and independent checker use the standard library; they do not execute the original experimental apparatus or require new data collection.

```sh
python3 experiments/recipient-harm-valuation/analysis.py
python3 experiments/recipient-harm-valuation/check_analysis.py
```

These commands regenerate derived results and receipts. The source workbook/CSV preservation comparison is separate from the choice analysis. [The integration checker](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RECIPIENT-VALUATION-CHECK.py) checks saved identities, accepted receipts and links without rerunning scientific calculations; [its receipt](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RECIPIENT-VALUATION-INTEGRATION.json) binds the accepted artifact set.

## Contribution and limits

Offered food stays equal in the main manipulation, but realized food, effort and subjective aversive experience are not fixed. Mandatory lever samples precede each recorded free-choice session, and the free-choice log does not identify total shocks or separately verify recipient experience. An observed change can reflect contingency learning applied to an existing aversion; it does not identify the origin of that aversion, separate learned value from correspondence, or establish moral standing.

The [identification argument](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RECIPIENT-VALUATION-IDENTIFICATION.md) relates this result to the theory's separate value, belief and efficacy variables. Actual recipient relief versus mere cue relief remains a useful missing discriminator. The study supplies empirical contact with recipient-linked action; how that action forms and whether it continues are not measured here.
