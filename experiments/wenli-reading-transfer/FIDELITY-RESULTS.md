# The fidelity count, run (FC1): results

22 October 2026. AI-written. This is the run of [FIDELITY.md](FIDELITY.md), the design frozen in `dcf2e5175`. The analysis plan, its two amendments and the codebook revisions were fixed before any main result was read. They are in the kit [`development/zhonghua/fidelity/`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/fidelity/), with the scripts, the coders' answers and the full tables ([RESULTS.md](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/fidelity/RESULTS.md)).

## What was measured

For each pair (條, declaration), the measure compares two wordings of one checked law:

- the 中华本's 經 clauses that state the declaration;
- the canonical chapter's English clause that cites it.

For each wording, two coders counted the referents it introduces that the Lean statement lacks (X), split into:

- agents (X_A);
- relata (X_R);
- entities (X_E).

They also counted:

- the binders of the statement the wording leaves out (O, and O-rate = O / binders);
- connective mismatches (S);
- predicate excess (P).

The Lean statements are the declarations' elaborated types, dumped from the core build of receipt `20261022T110022.458880Z`, with one level of unfolding.

- **Units.** 672 scored pairs in 270 條. A further 29 pairs in 13 條 form the calibration set. The 經 clauses were assigned to declarations by both coders, who agreed exactly on 1,303 of 1,399 clauses (κ 0.952). An adjudicator settled the other 96.
- **Coders.**
  - Claude (Opus 5.5) coded every segment.
  - GPT (`gpt-6-astra`, effort high, through `cx` with no configuration and no repository) coded the calibration set, and 320 English segments of the main set.
  - Chinese and English were coded in separate shuffled packets; no coder saw both wordings of one law.
- **Scope.**
  - By direction, the naive pass and the genre-matched segments were stopped, so **F3 and F4 are not measured**.
  - The GPT coder was then stopped after 16 of its remaining 59 packets. Its finished packets happened to be English only, so in the main set it coded no 經.

## Results

The like-for-like main comparison has one coder (Claude) on both sides. Means are per 條; differences are 經 − English; CIs are cluster bootstraps over 條 (10,000 resamples).

| | 經 | English | difference | 95% CI | Wilcoxon p |
|---|---:|---:|---:|---|---:|
| X (excess referents) | 0.09 | 0.81 | −0.71 | [−0.92, −0.54] | < 10⁻⁶ |
| X_A (agents) | 0.00 | 0.026 | −0.026 | [−0.042, −0.013] | 0.0004 |
| X_R (relata) | 0.012 | 0.068 | −0.056 | [−0.090, −0.025] | 0.0004 |
| X_E (entities) | 0.083 | 0.71 | −0.63 | [−0.83, −0.47] | < 10⁻⁶ |
| O-rate (binders left out) | 0.18 | 0.42 | −0.24 | [−0.28, −0.20] | < 10⁻⁶ |
| S (connective mismatches) | 0.064 | 0.25 | −0.18 | [−0.24, −0.13] | < 10⁻⁶ |
| P (predicate excess) | 0.029 | 0.051 | −0.023 | [−0.053, 0.005] | 0.14 |

The cross-family check is the calibration set, which both coders coded in full (13 條):

| coder | 經 X | English X | difference | 95% CI |
|---|---:|---:|---:|---|
| Claude | 0.00 | 1.47 | −1.47 | [−2.63, −0.54] |
| GPT | 0.58 | 1.61 | −1.03 | [−1.98, −0.22] |

**Registered predictions** (decision rules of the plan):

- **F1** (the 經 introduce fewer agents): supported in the main set, CI below 0. It is undecided on the GPT calibration coding (0 against 0.10, CI [−0.28, 0]).
- **F2** (the 經 introduce no more excess referents): supported, on both coders.
- **F3, F4**: not measured.

**Sensitivities, Claude coder:**

- Counting matches made only through unfolding (U0) as excess, the difference shrinks to −0.40, CI [−0.67, −0.14]. The 經's names lean on defined constants.
- Without negated referents: −0.68.
- On the 133 條 without readings: −0.79.
- By 篇: the difference is negative in 17 of 18 篇. The exception is 篇十 (名), at +0.25 over 6 條.

## What limits the result

- **The coder who wrote the 經 coded them.** Claude wrote the 中华本 and coded every main-set 經. In calibration it found no excess referent in any 經, where the GPT coder found a mean of 0.58. The main-set 經 figure (0.09) is therefore best read as a lower bound. Both coders agree on the direction, but the cross-family evidence on the 經 rests on 13 條 only.
- **Reliability is low on the Chinese side.** Krippendorff's α on per-segment X is:
  - English: 0.69 (main, 320 segments) and 0.78 (calibration);
  - Chinese: 0.53 (calibration, after one revision of the codebook), below the design's 0.8.
- **Register is not separated from language.** The 經 are full statements; the English clauses summarize within a long chapter. The genre-matched comparison (F3) that would separate the two was not run. The lower O-rate of the 經 shows they render more of each statement, not less, so omission is not what lowers their X. But the register difference stays.
- **Language is not separated from the discipline of the vocabulary.** The 經 were written in the 中华本's name table, whose every name states the sense it takes and the senses it does not carry (所不带): grounds, wills, centres and inherited doctrines are stripped name by name, and each name is anchored on a Lean declaration. The English chapter's clauses were not written under a rule of that kind. Fewer excess referents may therefore come mostly from that discipline and the anchoring, not from classical Chinese as such. Two signs point that way. Counting as excess the matches made only through unfolding narrows the difference from −0.71 to −0.40: the 經's names work as pointers to defined constants. And a one-to-one renaming carries the same law (`Becoming.SharedCodes.renamed_carries_iff`), so nothing in the measure binds the gain to the script. The control that would separate the two is a controlled English edition written under the same discipline (an English name table with what each name does not carry, anchored the same way), measured by the same procedure. It was built and run afterwards as board item ZE ([CONTROLLED-ENGLISH-RESULTS.md](CONTROLLED-ENGLISH-RESULTS.md)). Under the Claude coder, the 經's advantage over the controlled English does not survive (經 − CE +0.02, 95% CI [−0.01, +0.06]), and discipline in English recovers all of the advantage over the English chapter (share 1.03, [0.98, 1.09]). Under the GPT coder, on 60 pairs, a residual remains (−0.27, [−0.50, −0.06]), mostly in entities; the two coders' counts do not agree on those pairs (α ≈ 0).
- **No human audit.** The design makes a bilingual coder who reads Lean the deciding audit. None was available, so the result is provisional, as §8 of the design says.
- **One pair of texts.** Both were written by the same AI for the same core. The result speaks to these two codes, not to classical Chinese or English in general.

## An open observation: the author coding its own text

[AI reading, D63] In calibration the Claude coder, the AI that wrote the 中华本, found no excess referent in any of the 26 經 segments, in either pass; the GPT coder, from another model family, found some in 10 of them in the table pass and 12 in the naive pass (means per segment 0.62 and 1.04). On the English clauses, which the same AI also wrote but under no name table, the two coders agreed closely (α 0.91, table pass). One reading is a blind spot: a model under-detects what its own controlled text smuggles in, while another model sees it. The other is that the GPT coder over-reads classical Chinese. The data cannot tell them apart, and 26 segments are few. It is recorded as an open observation, not a result. It bears on the theory's own lines: a selection goes only through what its selector couples to (`Becoming.Web.SelectsThrough`), and what a judge's coupling does not reach it cannot mark, which is the case for checks by a different source (chapter §7, 明). A test would code the same texts with the authoring model and with models of other families, on texts each of them wrote.

**Tested in English (SC1, 23 October 2026; [results](../source-check/RESULTS.md)).** In a pre-registered crossed test, Claude and GPT each wrote plain-English statements of 60 laws, with and without a planted excess referent, and both coded all 240 texts blind to authorship. There was no author-specific deficit. Each coder caught its own plants at about the rate it caught the other's (interaction +0.02, 95% interval [−0.05, +0.08]). The coders differed as coders:

- The Claude coder listed no unplanted excess in any faithful text, GPT's included, and caught more plants (0.98 against 0.94).
- The GPT coder listed more excess everywhere (+0.16 per faithful text, [+0.08, +0.24]). About half of it was bare numerals that the codebook matches to binders.

[AI reading] This favours a difference of coding threshold over a blind spot as the account of the 經 discrepancy. It does not settle it: the test is in English, under no name table, and gives no ground truth for unplanted excess.

## Next

- ~~The controlled English edition under the same discipline, measured by the same procedure~~: done as ZE ([results](CONTROLLED-ENGLISH-RESULTS.md)). Still open there: a controlled English written from the Lean rather than translated from the 經, and the separation of discipline from register.
- The second coder on the main-set 經, and a human audit.
- The genre-matched comparison (F3), the naive pass (F4), and the reading test (DESIGN-H2).

## Reading

[AI reading, D63] On this core, the classical statements of the 中华本 introduce fewer referents the Lean lacks than the English chapter's clauses, and fewer agents. They also leave out fewer of each statement's binders and mismatch fewer connectives. The direction is the same for both coders where both coded.

This supports the narrower claim the WL chapter makes: that the classical code, as disciplined by its name table, is a fitting reading layer for the core. It does not show that classical Chinese is the best expression, nor that the gain belongs to the language rather than to the discipline. The control run afterwards (ZE, [results](CONTROLLED-ENGLISH-RESULTS.md)) points to the discipline: under the Claude coder a controlled English in the same discipline and register does as well as the 經; the GPT coder leaves a smaller residual for the 經. The comparison is with one English text, in another register, with the 經 coded mostly by the AI that wrote them.

The other half of the design, the H2 reading test, is not run.
