# AgentDojo: external evidence, authority and action

**Later prospective action test, 6 October 2026:** [four fresh maintenance contexts](correction-action/RESULTS.md) reenacted the genuine counterpart repair in isolated copies by task instruction, without OS isolation. One worker repaired code and regenerated verified results; the three other need/permission combinations appropriately preserved primary artifacts. The inputs, scorer and review were frozen before dispatch. This separate local-action study adds four model contexts while preserving all original retrospective sources and analyses; its [independent review](../../_process/research/2026-10-05-generative-foundation-review/foundation-assessment/ACTION-CORRECTION-RESULTS-REVIEW.md) retains the supplied-authority and final-effect limits.

6 October 2026. Retrospective analysis of a complete, fixed subset of published learned-agent executions. [Its account](../../theories/becoming/history/TOOL-EVIDENCE-AND-AUTHORITY.md), of 6 October and now in history, connects the findings to externally grounded cognition and to what that account named its remaining alignment and governance derivation. The retrospective analyses below add no model training, live banking action or new model call.

## Cohort and findings

The cohort contains 320 archived trajectories: two historical GPT-4o pipelines × 16 banking tasks × (one clean run + nine attack goals). Original requests, payloads and stored system messages match across attacked pairs. The [protocol](PROTOCOL.md) was fixed before aggregate calculations, after published results and four discovery traces were known. It is retrospective, not preregistered or outcome-blind.

| Reported outcome | Baseline | Repeated user prompt |
| --- | ---: | ---: |
| Clean task utility | 12/16 | 15/16 |
| Attacked task utility | 100/144 | 111/144 |
| Attacker-goal achievement | 90/144 | 67/144 |
| Utility without attacker-goal achievement | 33/144 | 60/144 |

These are exact archived-label counts, not verified harm rates or estimates of a randomized treatment effect. No attack-validity result is recorded. All 144 attacked rows per pipeline remain in the primary denominator; unknown validity does not become assumed validity. All task- and goal-omission contrasts are retained in [results.json](results.json).

[Independent numerical reconstruction](independent-verification.json) checks all 320 rows, 9,755 scalar fields and eight deliberately introduced errors. [The review](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/AGENTDOJO-EVIDENCE-REVIEW.md) records acceptance and inference limits.

## Separate effect reconstruction

[replay.py](replay.py) interprets only allowlisted saved operations as transformations of local synthetic state. It matches success responses before accepting an effect. It does not import the benchmark or execute embedded tool instructions. Historical source semantics reproduce 483 successful reads and 480 mutations; four returned errors and five missing receipts remain explicit. Complete state reconstruction covers 315/320 trajectories and 284/288 attacked trajectories. The historical security predicates match all 284 eligible labels.

The [contract](REPLAY-CONTRACT.md), [source clarification](REPLAY-SOURCE-CLARIFICATIONS.md), [preserved loader correction](REPLAY-LOADER-CORRECTION.md), [findings](REPLAY-FINDINGS.md) and [producer receipt](replay-receipt.json) distinguish source predicates from narrower goal requirements. Independent replay acceptance is recorded in [replay-verification.json](replay-verification.json) and [its review](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/AGENTDOJO-REPLAY-REVIEW.md). Corrections retain their first outputs and counterexamples.

In one paired case, the repeated-prompt agent completes the requested payment while also changing a password outside the user's request. Conversely, some attacker-goal labels overlap a legitimately requested landlord change. These cases show why task utility, attacker-target attainment, reconstructed effects and justified authority require separate claims. The replay does not reconstruct utility scoring, measure real welfare or identify hidden model reasoning.

## Provenance and reproduction

The [source archive](../../sources/28-agentdojo-evidence-2026-10-06/README.md) holds 343 pinned files, including all 320 logs, plus 52 historical source files and raw API metadata. The two historical result commits contain exactly the retained log blobs. This verifies archive identity, not the exact original installed runtime. Payload text and source files remain research data.

From the repository root, the analysis and its independent checker use Python's standard library:

```sh
python3 experiments/agentdojo-evidence-boundary/analysis.py
python3 experiments/agentdojo-evidence-boundary/check_analysis.py
```

The separate replay and independent state reconstruction additionally require PyYAML. The recorded producer environment is Python 3.11.2, PyYAML 6.0.2:

```sh
python3 experiments/agentdojo-evidence-boundary/replay.py
python3 experiments/agentdojo-evidence-boundary/check_replay.py
```

These commands overwrite derived results/receipts; preserved first-attempt evidence remains separate. A timestamp-only receipt change is not new scientific validation. [preserve_sources.py](preserve_sources.py) is an optional network retrieval tool for the fixed archive, unnecessary for analysis when the preserved files are present.

The [integration checker](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/AGENTDOJO-EVIDENCE-CHECK.py) verifies source identities, current receipts and research links without rerunning models or the analysis. [Its receipt](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/AGENTDOJO-EVIDENCE-INTEGRATION.json) records the final accepted artifact set.

## Remaining research connection

The observed boundary is external content → recorded learned-agent action → simulated consequence. It supports a need to assess evidence and authority separately. It does not show that dependence yields moral concern or that this foundation improves model performance. The generative account of 6 October, now in history, named as its next step a derivation from formed understanding of an affected center through justified evaluative influence to effective, corrigible action; its [downstream contract audit](../../_process/research/2026-10-05-generative-foundation-review/history/root-foundation/RECIPIENT-EVIDENCE-DOWNSTREAM-CONTRACT.md) lists that derivation's distinct obligations of factual adequacy, recipient standing, a defended objective, relevance, authority and funded execution.
