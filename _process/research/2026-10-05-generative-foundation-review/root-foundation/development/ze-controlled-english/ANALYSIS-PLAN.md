# ZE: the controlled English control, analysis plan (fixed before any coding of the controlled English is read)

23 October 2026. AI-written (board item ZE). The fidelity count FC1 ([FIDELITY.md](../../../../../../experiments/wenli-reading-transfer/FIDELITY.md), run in [FIDELITY-RESULTS.md](../../../../../../experiments/wenli-reading-transfer/FIDELITY-RESULTS.md), kit [`../zhonghua/fidelity/`](../zhonghua/fidelity/)) found the 中华本's 經 introduce fewer referents the Lean lacks than the canonical English chapter's clauses (Claude coder, 0.09 against 0.81 per pair, difference −0.71, CI [−0.92, −0.54]). Language was confounded with the discipline of the name table (each name states its sense and what it does not carry, and is anchored), and with register (the 經 are full statements; the English clauses summarize). This plan fixes how the control is read. Nothing below was changed after any coding of the controlled English was opened.

## The control

- **English name table** (`names-en.tsv`): for each of the 449 names of `../zhonghua/work/names-decisions.tsv`, an English name, the sense taken, what it does not carry (the Chinese note's exclusions translated, and the English word's agentive and substantival hazards), the same anchors. `check_names.py` passes: 449 distinct names, 881 anchors resolved in the newest core receipt (`20261023T035943.256483Z`), every row with a not-carried field; 157 names are the canonical glossary's terms.
- **Controlled English (CE)**: the 經 of all 394 條, rendered clause by clause (1,698 clauses) into English in that table only, statement-form, by three Claude (Opus 5.5) agents with `briefs/render.md`; the Lean of each clause was given as a key to the reading, not as a source of content. One source holds both editions: `controlled-english.jsonl`. `check_render.py` passes.
- **What the control matches and what it does not.** CE matches the 經 in content (it renders the same clauses), register (full statements with their conditions), discipline (a name table with senses, exclusions and anchors) and author (Claude wrote both). It differs in language, and in being a translation of the 經 rather than written from the Lean. So a remaining difference is language plus translation; a vanished one is discipline plus register (the two are not separated by this control).

## Units and segments

- The pairs are FC1's units (條, d): 672 main pairs in 270 條, 29 calibration pairs in 13 條. For each 經 segment (the 經 clauses FC1's final alignment assigns to d), the CE segment is the English of the same clauses, against the same declarations D (`segments_ce.py build`; 644 CE segments, 618 in the main set). So 經 and CE are paired on identical clauses and identical Lean statements.
- The CE key (table pass): each name of the English name table found in the segment (longest first, whole words, an inflection allowed), with its sense and anchors, in the fields FC1 gives an English key (`term`, `meaning`, `anchors`). Like the Chinese key, it gives sense and anchors, not the not-carried field.

## Coding

- **Coder A, Claude (Opus 5.5)**, as for the 經 in FC1, so that authorship is symmetric: Claude wrote both texts and Claude codes both. The 經 codings are FC1's (`../zhonghua/fidelity/data/coded/claude/core_claude`, `table_calib`), not recoded. The CE segments are coded now: table pass, FC1's brief `../zhonghua/fidelity/briefs/code.md` (codebook v1.1) and schema unchanged, packets of 20, shuffled (`segments_ce.py packets 20`: 31 main packets, 2 calibration packets). Coders see only English packets; no coder sees the 經 or this plan.
- **Deviation from FC1.** FC1's Claude coder was one workflow agent per packet. Here, to keep the number of agents near twelve, each coding agent codes four or five packets in sequence (seven agents), so its context carries across packets. This is a difference in procedure between the two sides; it is reported, not corrected.
- **Coder B, GPT (`gpt-6-astra`, effort high)**, through FC1's `run_codex_inline.sh` (`cx --fresh --clean`, scratch directory, no configuration, no repository), at most four runs in parallel, on a stratified sample: 60 main-set pairs, one per 經 segment, allocated across 篇 by largest remainder, drawn with seed `ZE-20261023` (`data/gpt_sample.json`; 55 條). Both sides: 60 經 segments (3 packets) and 60 CE segments (3 packets), each language in its own packets.

## Scores and statistics

Counts are recomputed from the coders' lists with FC1's `score.counts` (X, X_A, X_R, X_E, X_U0, X_noneg, O, O-rate, S, P). Per-條 means over the 條's pairs; differences 經 − CE; 95% CIs by FC1's cluster bootstrap over 條 (10,000 resamples, seed 20261022); Wilcoxon signed-rank on per-條 means; McNemar on X ≥ 1 over pairs; the Poisson rate ratio with cluster-robust errors. Script: `ze_score.py` (written and dry-run before coding; on FC1's codings alone it reproduces FC1's 經 − E1 difference, −0.713).

## Decision rules

- **Primary** (Claude coder, main set, X): the 經's advantage over the controlled English **survives** if the CI of the mean per-條 difference 經 − CE lies below 0; it is **reversed** if the CI lies above 0; otherwise it **does not survive** (no difference detected). The same rule is reported for X_A.
- **Cross-family** (GPT coder, the 60-pair sample, X): the same rule, reported beside the Claude coder on the same 60 pairs and the mean of the two. With 60 pairs this check is for direction and for the authoring-coder concern of FC1 (the Claude coder found no excess in its own 經 where the GPT coder found some), not a second primary test.
- **Reading.**
  - If the primary survives: language (with translation) carries part of the advantage beyond discipline and register. The share of FC1's advantage that the discipline in English recovers, mean(E1 − CE) / mean(E1 − 經) over 條, is reported with its bootstrap CI.
  - If it does not survive and CE is below E1 (CI of CE − E1 below 0): discipline and register account for the advantage on this core; nothing in the data binds it to classical Chinese.
  - If it is reversed: the controlled English introduces fewer referents than the 經 under the same discipline.
- **Reported beside:** CE − E1 for every count; 經 − CE for X_R, X_E, O-rate, S, P, X_U0, X_noneg; without 條 flagged as readings; by 篇; the calibration set (Claude only); α (interval) on X and O for each language on the GPT sample.

## What the result can and cannot say

It scores referents, not truth or readability: a wording that says nothing scores X = 0, so O-rate and S are reported. Every text and every Claude coding was made by one AI family; the GPT sample is the only cross-family evidence, and FC1's calibration showed the two families disagree most on the 經 (α 0.53 on Chinese). There is no human audit. The control does not separate discipline from register, and it adds translation as a difference. A result speaks to these codes on this core, not to classical Chinese or English in general.
