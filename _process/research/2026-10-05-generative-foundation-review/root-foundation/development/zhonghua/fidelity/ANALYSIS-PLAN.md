# FC1: the fidelity count, analysis plan (fixed before any coded result is read)

Design: [FIDELITY.md](../../../../../../../experiments/wenli-reading-transfer/FIDELITY.md), frozen in `dcf2e5175`. Its registered predictions F1–F4 are unchanged. This file states how each is decided where the design leaves room, and every deviation from the design, before any coding output is opened. AI-written.

## Inputs (frozen by the commit that adds this file)

- 中华本 `theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md` and the canonical chapter `theories/becoming/chapters/THE-THEORY-OF-BECOMING.md` at `333c34065`, extracted by `extract_zh.py` and `extract_en.py`.
- The Lean statements of 4,674 declarations, dumped by `lean_dump.py` from the core build restored from the shared cache (receipt `20261022T110022.458880Z`; 302 steps reused, none rebuilt).
- The name table (449 names, 37 not adopted) and the glossary §10 (a), (b) as the keys.
- Sorts from the registered table in `sorts.py`, which adds one sort the design's list lacks (`move`).

## Coders

- Coder A: Claude (Opus 5.5) workflow agents. Coder B: GPT (`gpt-6-astra`, effort high) through `cx --fresh --clean` in a scratch directory, with no user configuration and no repository. B is from another model family, as §4 requires.
- Chinese and English segments go in separate packets, shuffled; no packet holds both languages. A coder answers one packet at a time with no memory of others.
- Alignment of 經 clauses to declarations: both coders, then a Claude adjudicator only for the clauses where they differ (§2).

## Deviations from the design, fixed now

1. **No human audit (F3 of §4).** No bilingual Lean-reading coder is available in this run. The result is reported as LLM-coded and provisional (§8), and the sensitivity "LLM-only against human-audited" cannot be run.
2. **Consensus.** Without the human audit, no adjudicator settles coding disagreements. A segment's score is the mean of the two coders' counts. Each coder alone is reported as a sensitivity.
3. **Poisson model.** No statistics library is installed (none is imported for this run). The Poisson mixed model `X ~ language + (1|條) + (1|d)` is replaced by a Poisson regression of X on language with cluster-robust (sandwich) errors over 條, written in pure Python. The cluster bootstrap and the Wilcoxon test, which the design names first, are unaffected.
4. **Unfolding depth.** Coders see U1. U0 is computed by counting as excess every referent matched only by rule M5 (unfolding). U2 is not run.
5. **E2.** Pairs with no E1 clause are not coded; "E1 only against E1 + E2" is not run. The 885 E2-only pairs are reported as a count.
6. **Calibration.** Forty-one pairs in sixteen whole 條, stratified by 篇, are coded first and excluded from scoring. If Krippendorff's α on per-segment X is below 0.8 for either language, the codebook is revised on these pairs only, each revision logged, and they are recoded once. The main run then uses the revised codebook, whatever α the recode reaches; both values are reported.

## Decision rules

Units are pairs (條, d) with both a 經 segment (from the final alignment) and an E1 segment. Per-條 scores are means over the 條's pairs. All differences are zh − en.

- **F1** (X_A): refuted if the 95% cluster-bootstrap CI (10,000 resamples over 條) of the mean per-條 difference in X_A lies above 0; supported if it lies below 0; otherwise undecided.
- **F2** (X): refuted if the CI of the mean per-條 difference in X lies above 0; supported otherwise (the prediction is "no more").
- **F3** (omissions do not buy the lower X). Read only if F2 holds with a CI below 0. Supported if, in the genre-matched cell 經 against EN-rec (both full statements), the 經 also have lower X (CI below 0) and their O-rate is not higher (CI of the O-rate difference not above 0). Refuted if the lower X of the primary comparison vanishes there (CI includes or exceeds 0) while the 經's O-rate is higher (CI above 0). Otherwise undecided. The other three cells are reported.
- **F4** (inherited-sense load X_naive − X_table larger for the 經): supported if the CI of the mean per-條 difference in load lies above 0; refuted if below 0; otherwise undecided.

Reported beside the predictions: Wilcoxon signed-rank on per-條 means, McNemar on X ≥ 1 over pairs, the Poisson rate ratio, all by class (A, R, E) and by 篇; O, O-rate, S and P; α (interval) on X and on O per language, and nominal α on referent classes over spans matched with at least 50% overlap; the sensitivities: each coder alone, U0, without referents tagged *neg*, without 條 flagged as readings; the correlation of X_anchor with coded X.

## What the result can and cannot say

It scores referents, not truth: a wording that says nothing scores X = 0, which is why O and S are reported. It compares two codes written by the same AI, coded by two AIs; a human audit would decide. A result in either direction speaks to these two texts, not to classical Chinese or English in general.

## Amendment, 22 October 2026: scope reduced by direction, before any main result was read

During the main run, the person who asked for the measure directed it be cut to the main comparison: "停掉 naive 一遍和体裁对照段，只编主比较所需的經和英文句，F3、F4 记为未测" (stop the naive pass and the genre-matched segments; code only the 經 and English clauses the main comparison needs; record F3 and F4 as not measured). Only the table pass of the 經 (jing) and E1 (en) segments is coded and scored. **F3 and F4 are not measured.** The genre-matched cells, the naive X and the inherited-sense load are not reported. Codings already made of those segments (the GPT coder's first 20 naive packets, and the record-law segments in the Claude coder's English packets) are kept in `data/coded/` and not analysed. No main result had been scored when the run stopped; the calibration results were already known and are reported as they stand.
