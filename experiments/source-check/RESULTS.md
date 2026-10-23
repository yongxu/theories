# Source check (SC1): coders on their own and the other's texts

Run 23 October 2026, board item SC1. Design and analysis plan: [DESIGN.md](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sc1-source-check/DESIGN.md), committed (`e9052d667`) before any statement was written or coded; texts and blind packets committed (`23c68a6eb`) before any coding. Kit, data and the analysis output ([`results.json`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sc1-source-check/results.json)) in [`development/sc1-source-check/`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sc1-source-check/). LLM-written and LLM-coded; no human audit.

## Question

In the fidelity count's calibration ([FIDELITY-RESULTS](../wenli-reading-transfer/FIDELITY-RESULTS.md#an-open-observation-the-author-coding-its-own-text)) the Claude coder, the AI that wrote the 中华本, found no excess referent in any of 26 經 segments, while the GPT coder found some in 10. Two readings were open: a **blind spot** (a model under-detects what its own text introduces) and **over-reading** (the GPT coder counts what is not there). A blind spot is author-specific: an interaction of author and coder. Over-reading, and its mirror, general under-detection by the Claude coder, are coder-general: main effects of the coder.

## Design

- **Texts.** 60 laws, a seeded sample of FC1's Lean table (theorems of 經-aligned units, not examples or readings, Lean form ≤ 3000 characters). For each, Claude (Opus, a subagent) and GPT (gpt-6-astra, high effort, `cx --fresh --clean`) wrote, from the same Lean statement and brief, a **faithful** plain-English statement and a **planted** version: the same statement with one referent the Lean lacks, of an assigned class (agent A, relatum R or entity E, 20 laws each), added to read naturally, with its span recorded. 240 texts; every plant passed the validity check (span in the text, head word in the span; no changes outside the span beyond two tokens).
- **Coding.** Both models coded all 240 texts by FC1's codebook v1.1, table pass, no key and no candidate spans, blind to author, version and plant (opaque ids, shuffled packets of 20, no packet set holding two texts of one law). GPT: 12 runs, one per packet. Claude: 6 subagents, two packets each.
- **Measures.** X, the excess referents a coder lists; *hit*, whether an excess referent's span carries the plant's new words.
- **Analysis.** Cell means by author × coder; the interaction I = s_Claude + s_GPT, where s_c is coder *c*'s own-text mean minus its other-text mean; coder and author effects; cluster bootstrap over laws, B = 10,000, 95% percentile intervals. Decision rule in DESIGN §6.

## Results

Detection of planted referents (60 per cell):

| | Claude coder | GPT coder |
|---|---|---|
| Claude-written | 0.967 (58/60) | 0.917 (55/60) |
| GPT-written | 1.000 (60/60) | 0.967 (58/60) |

Excess referents per faithful text (60 per cell; in brackets, texts with any):

| | Claude coder | GPT coder |
|---|---|---|
| Claude-written | 0.000 (0) | 0.183 (9) |
| GPT-written | 0.000 (0) | 0.133 (8) |

Contrasts (95% cluster-bootstrap intervals):

| Contrast | Detection of plants | X, faithful texts | X outside the plant, planted texts |
|---|---|---|---|
| Interaction I (self effect, summed) | +0.017 [−0.050, +0.083] | −0.050 [−0.200, +0.083] | +0.100 [−0.067, +0.267] |
| s_Claude (own − other, Claude coder) | −0.033 [−0.083, 0.000] | 0.000 [0, 0] | +0.017 [0.000, +0.050] |
| s_GPT (own − other, GPT coder) | +0.050 [−0.033, +0.133] | −0.050 [−0.200, +0.083] | +0.083 [−0.083, +0.250] |
| Coder (GPT − Claude) | −0.042 [−0.075, −0.008] | +0.158 [+0.083, +0.242] | +0.217 [+0.125, +0.325] |
| Author (Claude − GPT) | −0.042 [−0.100, +0.008] | +0.025 [−0.042, +0.100] | −0.033 [−0.117, +0.058] |

No coding is missing (480 of 480). Detection by plant class is between 0.90 and 1.00 in every cell; the ceiling condition (every cell ≥ 0.95) is not met, so R1 is read.

**Decisions (DESIGN §6).**

- **R1 (primary):** the interval for I on detection includes 0. No author-specific detection deficit is found. The data allow a summed self deficit of at most 5 points.
- **R2:** the interval for I on faithful X includes 0. The Claude coder's own-text difference is exactly 0, because it lists no excess in any faithful text, whoever wrote it.
- **R3:** the GPT coder detects fewer plants than the Claude coder (−0.042, interval below 0), and it lists more excess in faithful texts (+0.158, interval above 0). By the rule, this is consistent with over-reading or a laxer threshold. The faithful texts carry no ground truth, so these two are not told apart.

**Described, not pre-registered.**

- *What the GPT coder counts in faithful texts.* It lists 19 excess referents in 17 faithful texts. 9 of them are bare numerals that count binders ("two histories", "six lines", "three level histories"), coded as an excess amount. Clarification 1 of codebook v1.1 matches these to the binders they count. The rest are terms the statement constructs ("the number of falses" in a sum, "net change", "its successor", "a step u") and two regions coded as a sort mismatch. Over all 240 texts, 22 of the GPT coder's 46 excess referents outside a plant are bare numerals.
- *Misses.* The Claude coder missed 2 plants. Both were Claude-written, and the GPT coder missed them too: "the claim", which both coders matched to the statement's proposition, and "sender", which both matched to the existential binder it names. These two are arguably not excess. The GPT coder missed 5 more, each coded as matched to a binder or to the quantified claim: "a wider pool", "as a general truth" and "in the population" in Claude's texts, and "a surrounding collection" and "governed by a recurrence law" in its own.

## Reading

[AI reading] On plain-English statements of these laws, neither model under-detects what its own text introduces. Each catches the referents it planted itself at about the rate it catches the other's: Claude 0.97 own against 1.00 other, GPT 0.97 own against 0.92 other. The difference between the coders belongs to the coder, not to the authorship of the text.

- The Claude coder lists nothing unplanted in anyone's text, GPT's included, and catches nearly every planted referent.
- The GPT coder lists more everywhere and catches fewer plants. About half of what it lists outside the plants is numerals that the codebook matches to binders.

For the calibration observation, this supports a difference of coding threshold over a blind spot. The GPT coder counts more as excess, part of it against the codebook. The Claude coder's zero on the 經 fits its zero on GPT's English. It is a property of the coder, not of the coder reading its own text.

Two things are not excluded:

- The Claude coder may under-detect *unplanted* excess of kinds the plants did not sample. Nothing here gives ground truth on the faithful texts.
- The 經 case differs in language and discipline: classical Chinese under the name table. A blind spot for the author's own controlled code, or GPT over-reading specific to classical Chinese, is not tested in English.

The observation was offered as a case of a judge not marking what its coupling does not reach (`Becoming.Web.SelectsThrough`; chapter §7, 明). This run does not support it as an author effect. The law stands on its own proof and is not tested here.

## Boundary

- English only; plain statements with no glossary. The calibration's discrepancy was on classical Chinese under a name table.
- Plants were made knowingly by their authors. Deliberate insertion is not the unnoticed smuggling the blind-spot reading names, though each plant is in its author's own words.
- Two model families identify only the summed self effect δ_Claude + δ_GPT. A Claude-only deficit would be masked by an equal GPT self advantage; s_GPT's point estimate is positive.
- Detection is near ceiling (0.92–1.00), so the test resolves only deficits of more than a few points.
- Context differs between coders: the Claude coder saw 40 texts in one context, the GPT coder 20.
- No adjudication of unplanted excess; no human audit.

## Scale

- Claude: 8 Opus subagents (2 authors, 6 coders), 1,282,615 subagent tokens (authors 292,478; coders 990,137).
- GPT: 14 cx runs (2 authors, 12 coders), no retries, 704.6k tokens (authors 102.6k; coders 602.0k).
