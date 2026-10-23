# The controlled English control (ZE): results

23 October 2026. AI-written. This is the control that the [fidelity count](FIDELITY-RESULTS.md) (FC1) lacked. FC1 found that the 中华本's 經 introduce fewer referents the Lean lacks than the canonical English chapter's clauses. But the 經 were written under the discipline of a name table (each name states the sense it takes and the senses it does not carry, and is anchored on Lean declarations), and they are full statements where the English clauses summarize. Language was therefore confounded with discipline and with register.

The control puts English under the same discipline and in the same register, and measures it by the same procedure. The analysis plan was fixed, and committed in `9811339e2`, before any coding of the controlled English was read. It is in the kit [`development/ze-controlled-english/`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ze-controlled-english/ANALYSIS-PLAN.md), with the scripts, the coders' answers and `data/results.json`.

## What was built

- **An English name table** (`names-en.tsv`, 449 rows). It covers every name of the 中华本's table, and for each gives:
  - an English name;
  - the sense taken;
  - what the name does not carry, in two parts: the Chinese note's exclusions, translated, and the English word's own agentive and substantival senses (for example, "In English, not: an observer's opinion or viewpoint" for *standpoint*);
  - the same anchors.

  157 of the names are the canonical glossary's terms. Where the Chinese table avoids a social or financial word, so does the English: *total level*, not stock; *ratio*, not share; *maximal alternative*, not optimum. The checker (`check_names.py`) passes on the newest core receipt (`20261023T055339.893510Z`): 449 distinct names, 881 anchors resolved, and a not-carried field on every row.
- **The controlled English edition** ([CONTROLLED-ENGLISH.md](CONTROLLED-ENGLISH.md)). It renders the 經 of all 394 條, clause by clause (1,698 clauses), using only the table's names for theory terms, in statement form. One source, `controlled-english.jsonl`, holds both editions, keyed by 條 id and clause number, with the declarations each clause states. The renderers had the Lean of each clause as a key to its reading, and were told not to add or drop content from it.
- **The segments.** Each of FC1's 644 經 segments has a controlled English (CE) segment: the English of the same clauses, against the same declarations. The 經 and CE are thus paired on identical content and identical Lean statements. They differ in language, and in that CE is a translation.

## Results

**Primary comparison.** The Claude coder (Opus 5.5) coded both sides; the 經 codings are FC1's. The set is the main set: 672 pairs in 270 條. Means are per 條; differences are 經 − CE; CIs are cluster bootstraps over 條 (10,000 resamples).

| | 經 | CE | 經 − CE | 95% CI | E1 (FC1) | CE − E1 | 95% CI |
|---|---:|---:|---:|---|---:|---:|---|
| X (excess referents) | 0.095 | 0.071 | +0.023 | [−0.010, +0.055] | 0.808 | −0.736 | [−0.942, −0.566] |
| X_A (agents) | 0 | 0 | 0 | [0, 0] | 0.026 | −0.026 | [−0.042, −0.013] |
| X_R (relata) | 0.012 | 0.003 | +0.009 | [+0.002, +0.020] | 0.068 | −0.065 | [−0.098, −0.037] |
| X_E (entities) | 0.083 | 0.069 | +0.014 | [−0.019, +0.044] | 0.713 | −0.645 | [−0.846, −0.485] |
| O-rate (binders left out) | 0.183 | 0.177 | +0.006 | [−0.003, +0.017] | 0.423 | −0.246 | [−0.282, −0.211] |
| S (connective mismatches) | 0.064 | 0.051 | +0.013 | [−0.009, +0.034] | 0.245 | −0.194 | [−0.249, −0.139] |
| P (predicate excess) | 0.029 | 0.004 | +0.025 | [+0.010, +0.042] | 0.051 | −0.048 | [−0.075, −0.025] |
| X_U0 (unfolding matches counted as excess) | 1.21 | 0.95 | +0.26 | [+0.17, +0.36] | 1.61 | −0.66 | [−0.91, −0.43] |

**Decision (registered rule).** The 經's advantage over the controlled English **does not survive** under the Claude coder. The CI of 經 − CE includes 0, and its point estimate is on the 經's side of zero (Wilcoxon on the 34 條 with a nonzero difference: p 0.04, toward more excess in the 經). The controlled English is far below the English chapter (CE − E1 −0.74), and that discipline in English recovers **1.03** of FC1's advantage (95% CI [0.98, 1.09]). Other views of the primary comparison:

- **Without the 條 flagged as readings:** +0.014, CI [−0.048, +0.068].
- **By 篇:** the difference is positive in 7, zero in 7 and negative in 4.
- **McNemar on X ≥ 1:** 31 pairs have excess only in the 經 and 18 only in CE (p 0.09).
- **Rate ratio, 經 over CE:** 1.25 [0.80, 1.94].
- **Calibration set (13 條):** 經 0.00, CE 0.08, E1 1.47.

**Cross-family check.** The GPT coder (`gpt-6-astra`, effort high) coded 60 main-set pairs in 55 條, stratified by 篇, blind and in separate language packets.

| coder | 經 X | CE X | 經 − CE | 95% CI |
|---|---:|---:|---:|---|
| GPT | 0.61 | 0.88 | −0.27 | [−0.50, −0.06] |
| Claude, same pairs | 0.055 | 0.073 | −0.018 | [−0.055, 0] |
| mean of the two | 0.33 | 0.48 | −0.15 | [−0.26, −0.04] |

**Decision (registered rule).** Under the GPT coder, the 經's advantage **survives**, at about a third of a referent per pair. Most of it lies in entities: X_E −0.25, CI [−0.44, −0.06]. X_A is 0 against 0.055, CI [−0.145, 0]. O-rate does not differ (−0.007). On these 60 pairs the two coders do not agree on X at all: Krippendorff's α is 0.03 on the 經 and −0.01 on CE. Their omission counts agree better: α 0.64 and 0.73. The Claude coder finds almost nothing on either side (means 0.05 and 0.07 per segment). The GPT coder finds much more (0.62 and 0.92).

- **What the GPT coder's CE excess consists of** (described after reading, not registered). The four agent referents are *a self* and *the center*, in statements about a standpoint's own continuation. Their English words carry the agentive sense that the table's not-carried field excludes, but the key shown to coders gives the sense only, as it does for the Chinese. Numerals are coded as excess on both sides: 4 in the 經 and 5 in CE.
- **Exploratory, after reading.** On 36 of the 60 pairs (35 條), FC1's GPT coder had also coded the E1 clause, so the GPT coder's share can be formed there:
  - 經 0.36, CE 0.80, E1 1.64;
  - discipline in English recovers **0.66** of the advantage, CI [0.11, 0.88].

## Reading

[AI reading, D63] **Under the pre-registered primary comparison, the whole of FC1's advantage is discipline and register, not language.** English written in a name table with stated exclusions and anchors, as full statements, introduces no more excess referents than the classical 經, and no more agents (none on either side). It also leaves out no more binders and mismatches no more connectives. The few places where the 經 still score worse under this coder (relata, predicate excess, and the larger share of matches made only through unfolding) point the same way. The 經's names lean on defined constants, which the English spells out.

**The cross-family coder sees a residual on the 經's side, mainly in entities.** It is about −0.27 per pair; by the exploratory share, about a third of the advantage over the English chapter. The two coders' X counts are uncorrelated on these pairs, and SC1 ([results](../source-check/RESULTS.md)) found that they differ by threshold: the Claude coder lists no unplanted excess in faithful English texts, while GPT lists more, in part numerals the codebook matches. So the residual is the GPT coder's reading, and it cannot be assigned to language rather than to that coder's threshold on English names such as *self*.

What can be said is narrower than either "the language does it" or "the discipline does it all":

- the discipline (name table and register) accounts for most or all of the measured advantage, on both coders where it can be measured;
- whether classical Chinese adds anything beyond it depends on the coder, and here the coders disagree.

`Becoming.SharedCodes.renamed_carries_iff` (a one-to-one renaming carries the same law) already made it likely that nothing in the measure binds the gain to the script; the control confirms that for the Claude coder.

This bears on the WL chapter's claim ([WENLI-AND-BECOMING](../../theories/becoming/chapters/WENLI-AND-BECOMING.md)). The fitting reading layer is the disciplined code: a name table with stated exclusions and anchors, used in full statements. On this evidence the classical code is one fitting instance of it, and a controlled English code is another of about equal measured fidelity.

## What limits the result

- **One AI family wrote everything,** and the primary coder is the same family as the authors of both texts. The cross-family check is 60 pairs, and on it the coders' X counts are unrelated (α ≈ 0). There is no human audit, so neither coder's threshold is shown right.
- **CE is a translation of the 經,** written with the Lean as a key. It inherits the 經's content. Its renderers could resolve ambiguity from the Lean where the 經 leave it to the reader: one renderer reports rendering 九·二十八's third clause by the Lean's reading. A CE written directly from the Lean in the English table would be a cleaner twin; it was not built.
- **Discipline and register are not separated.** CE matches the 經 in both. The genre-matched comparison of FC1's design (F3) would separate them on the English side.
- **The procedure differs on the two sides.** Each CE coding agent coded four or five packets in sequence (seven agents), while FC1's 經 were coded one packet per agent. One coding agent, after finishing its own packets, saw the excess totals of another agent's finished files; it had not opened them. The name table was written by one agent in one pass and reviewed only by its checker.
- **One core, two codes.** The result speaks to these texts on this core, not to classical Chinese or English in general.

## Cost

11 Claude agents, besides the session that ran the item:

- 1 wrote the name table;
- 3 rendered the 經;
- 7 coded the CE segments.

The agents used about 3.23 million tokens: 0.30 M for the table, 0.86 M for rendering and 2.08 M for coding. The GPT coder made 6 runs, about 0.43 M tokens.
