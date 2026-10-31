## The rest

Each test's full design is in its own file: the law exactly, Stage 0's exact tables, the power check's specification and results, every rival and what separates it, Stage B's protocol and usage, the lessons of earlier freezes met, the choices left for the freeze, candidate core lemmas, the plan's corrections in full, and references with what each showed.

| File | Tests | Stage 0 |
|---|---|---|
| [REST-TR1.md](REST-TR1.md) | TR1 (RF1), with RF-M's mechanism carried inside | [`tr1.py`](tr1.py), [`tr1.json`](tr1.json) |
| [REST-TR2-TR7.md](REST-TR2-TR7.md) | TR2 (RF2), TR7 (RF7) | [`tr2.py`](tr2.py), [`tr2.json`](tr2.json), [`tr7.py`](tr7.py), [`tr7.json`](tr7.json) |
| [REST-TR3-TR6.md](REST-TR3-TR6.md) | TR3 (RF4), TR6 (RF6.3) | [`tr3.py`](tr3.py), [`tr3.json`](tr3.json), [`tr6.py`](tr6.py), [`tr6.json`](tr6.json) |
| [REST-TR4-TR5.md](REST-TR4-TR5.md) | TR4 (RF6.1), TR5 (RF3) | [`tr4.py`](tr4.py), [`tr4.json`](tr4.json), [`tr5.py`](tr5.py), [`tr5.json`](tr5.json) |
| [REST-TR8-TR9.md](REST-TR8-TR9.md) | TR8 (RF-M.2), TR9 (RF-M.3) | [`tr8.py`](tr8.py), [`tr8.json`](tr8.json), [`tr9.py`](tr9.py), [`tr9.json`](tr9.json) |

### Usage at a glance

Estimates, to be replaced at the freeze by a smoke run. Every Stage B run waits on Ren's yes.

| Test | Systems | Calls | Tokens (estimate) |
|---|---|---|---|
| TR1 | six model families | 630 per condition, four conditions: 15,120 | about 17M; the optional informing variant about 4,600 calls more |
| TR2 | two open-weight families, on a machine suited to them | about 4,000 forward passes and 6,000 generations per model and checkpoint | no API tokens; downloads of about 14 to 16 GB per model, named at the freeze |
| TR3 | three to six families, temperature 0 | about 1,840 per model | about 0.60M per model |
| TR4 | six families | 440 per model: 2,640 | about 1.2M |
| TR5 | six families | 459 per model: 2,754 (upper 3,834) | about 2.5M (upper 3.5M) |
| TR6 | three families, temperature 0 | about 3,970 per model | about 1.47M per model |
| TR7 | six families | 1,210 per model: 7,260 | 7M to 18M |
| TR8 | at least two families | 3,420 per family, a first round of 1,140 | about 2.9M per family |
| TR9 | the families where TR8's bridge was supported | 1,980 per family, a first round of 660 | about 1.9M per family |

### What the tests share

- **One harness for fresh calls.** TR2's forbidden case (outputs apart where nothing accessible differs) is TR4's leak measure and TR5's premise that a prompt is a function of the visible history. These three tests should share one harness for fresh calls, cue randomization and nuisance pairing.
- **One harness at temperature 0.** TR3 and TR6 both use structured output, logged inputs with an input diff, and a determinism pilot. In both power checks, residual nondeterminism near one call in a thousand is the boundary between resolvable and voided verdicts. A shared pilot screens for it only coarsely: 200 identical calls with no flip exclude a rate above about 0.015, 300 exclude 1/100, and about 3,000 would be needed to exclude 1/1000. Per-cell unanimity and the share of flagged cells carry the regime in the verdict rules.
- **One harness for told one-shot decisions with a probe.** TR1, TR8 and TR9 share it, and so could RR's tests of revision routes ([RR's note §8](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rr-revision-routes/NOTE.md#8-tests-that-can-fail-designs-only-to-freeze-before-any-run)). TR8's optional pair variant, RF-M.2 joined to RF1, runs on TR1's harness.
- **Noise calibrated from VD1.** VD1's within-standpoint flip share of 0.124 corresponds to a per-call tremble of about 0.066, inside TR1's tolerated 0.10 [AI reading; that task was different, and only a run would tell].
- **A note for RR.** A law that cannot tell two stages apart makes the difference in compliance rates between them 0 in distribution, but a pattern rate over paired rollouts can reach `p(1 − p) ≤ 1/4` for such a law. Rejecting that rate shows the stages told apart, not the threshold ([REST-TR2-TR7.md](REST-TR2-TR7.md#the-rate-and-the-pattern-under-a-law-that-cannot-tell-the-stages-apart) states it once, for TR7 and for RR's TR-RR2).

### What changed with the designs

- **[RF's plan](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md).** The plan's §10 is rewritten. Its first list misstated what TR1 to TR5 could refute: a cycle anywhere in the family, not one closing on the training choices; RF2's forbidden case is the negation of its hypothesis; RF4 predicts no timing and claims no return of reach; RF6.1 has no deadline; RF3 predicts neither soundness nor keeping. That list also had no entry for RF6.3, RF7, RF-M.2 or RF-M.3. Smaller corrections went to §3's two rows, §4.1's and §4.2's counts and statements, §4.4's composition (every state, choice over the states), §4.5's RF7 design (marked superseded), §4.6's summaries of RF-M and RF6.3, §8's row on double-loop learning, §11 and §12's third step. Each file's section on the plan's corrections lists them in full.
- **Nine records' next steps.** Each of these named its test in words that misstated what a run can refute: what choices show of an order, acts alike from a model or from an order, what readings fix of the unread, readers reading readers, a revision that opens a correction, a reading kept by its update, a prediction read by what it predicts, complying when read, and what holding for a reading is worth. Only that clause changes, with one history note each, through the record workflow when the designs land ([the amendment](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/tests/amend_next_delta.py)); no statement or declaration changes.

### Candidate core lemmas

The designs use some general forms that the Lean does not state. Each is checked here by enumeration, and is listed in its file as a candidate lemma. No Lean is written:
- TR1: met and after, an order's exclusion and forced top on a later menu; the uninformed course for every according ranking.
- TR3: the cascade's premise needed only at the histories reached, which TR3's verdict rests on; `k` replaced by a stopping time at which every later member ignores its draw at the histories reached (persistence); a total-variation bound for sampled members (periphery).
- TR4 and TR5: a counted per-fiber bound; Revising's complete classification.
- TR6: the orbit from any start under an order-keeping map.
- TR7: the strict converse of the fresh draw's comparison, the improving interval and the best chance.
- TR8: holding strictly best and strictly below; the committed moves' shortfalls, which rank a menu of readers.

Before TR3 is frozen, one choice matters: prove its first lemma, or let its verdict rest on an inference.

### Choices left for the freeze, and what is still to be checked

Each file ends its design with the choices left for the freeze: the model IDs, the wording, the thresholds, the sizes where Stage 0 offers two, and the optional arms. The literature each file marks "to be checked" is checked before any citation of figures. That includes the reading of Sheshadri and others' no-consequence deployment as RF7's forbidden case at its first exit, which is an AI reading. The independent reviews, their findings and how each was taken are in [REVIEW.md](REVIEW.md).

### Provenance

AI-written, 31 October 2026, in one Claude Code session that owns board item RF. Five reviewing sessions each reported on one group of laws (their Lean, forbidden cases, the plan's misstatements, prior work), and a sixth on the repository's form for test designs. Five builders, one per group, then wrote the scripts and drafted the parts. Every script was rerun from a clean folder and reproduced its output exactly, apart from its timing fields. The integrator wrote this file's opening, the shared parts and this index, corrected the plan, and wrote the records' amendment. The [experiments README](../README.md#freezing-a-test-on-a-trained-system) gives the lessons every design meets. The [board](../../_process/BECOMING-WORKBOARD.md) holds the claim.
