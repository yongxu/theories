# Third addendum to the VD1 freeze: Qwen and Mistral replace Meta and StepFun after standpoint 0, 21 October 2026

AI-written (the VD1 session). Committed after standpoint 0 ran under the [second addendum](PREDICTIONS-ADDENDUM-2-2026-10-21.md), and before any call to the two new models. It changes two of the six valuers, the runner's handling of a call that gets no reply, and one model's pace. The frames, prompts, predictions, thresholds, verdict rules, design rule and end-of-run rule are unchanged.

## What happened

The second addendum staged the run against Ren's line, relayed on 21 October: "If spend looks set to pass about $10, stop and tell me."

1. Standpoint 0 ran for all six of its models: 672 calls (first call about 2026-10-20T21:39Z), every reply valid, $0.82 spent.
2. The total was projected from the costs OpenRouter reported for those rows alone: $14.11, over the line. No further call was made, and the projection went to Ren.

| Model | Standpoint 0 | Projected for 1,920 calls |
|---|---|---|
| `meta/muse-spark-1.3` | $0.4194 | $7.19 |
| `stepfun/step-5-preview` | $0.3267 | $5.60 |
| `deepseek/deepseek-v4.1-flash-1017` | $0.0296 | $0.51 |
| `anthropic/claude-haiku-5.5` | $0.0213 | $0.36 |
| `openai/gpt-6-luna` | $0.0159 | $0.27 |
| `z-ai/glm-5.3-flash` | $0.0104 | $0.18 |

Before this change, only two things were seen: the costs, and the runner's count of valid replies (112 of 112 for each model). No judgment was read and no measure was computed. So the change cannot depend on what any model answered.

## The change

**Ren's choice**, relayed on 21 October by the session that started this one: "drop meta and stepfun, pick two cheap ones." The reason is cost: those two models carry $12.79 of the $14.11 projection. That session picked two cheap models from families not yet in the design:

| Model | Listed (UTC) | Price per million tokens (in / out) | Notes |
|---|---|---|---|
| `qwen/qwen3.8-flash` | 26 Aug 2026 | $0.15 / $0.47 | Alibaba's Qwen; structured outputs, reasoning and seed |
| `mistralai/mistral-small-2603` | 16 Mar 2026 | $0.15 / $0.60 | Mistral; structured outputs, reasoning and seed |

Both are rechecked against OpenRouter's public model list on 21 October and pinned by exact ID. The six valuers are now:
- DeepSeek, GLM and Qwen (China);
- GPT-6 luna and Claude Haiku (United States);
- Mistral (Europe).

That is six families from three regions, still 96 valuers and 11,520 calls in the analysed design. The configuration order, which breaks ties in the design rule, is DeepSeek, GLM, GPT-6 luna, Claude Haiku, Qwen, Mistral.

**The new models run every standpoint**, standpoint 0 included, in the same order as the others: standpoint order, replicates last. Their calls use the same settings (strict JSON schema, low reasoning, `max_tokens` 4000, seed) and the same prompts. The prompt hash `4e15882cecc79791198f9dc71ff53ac8115adec9002405a6ec9eb2894ab1b3d6` still matches, and `frames.py` is byte-identical to `c56f3f8d2`.

**Meta's and StepFun's standpoint-0 rows are kept and committed** (`results/runs/meta__muse-spark-1.3.jsonl`, `results/runs/stepfun__step-5-preview.jsonl`), outside the analysed design. They are not in the configuration, so the design rule never selects them and no verdict rule reads them. After the run ends they may be reported as a measurement only. Their cost counts toward the spend.

## Checks before the new models' first calls (non-experimental)

One call each with [`check.py`](check.py)'s test prompt, not the experiment's:
- `qwen/qwen3.8-flash`: a valid reply under the strict schema with low reasoning, served by Alibaba. 91 prompt and 122 completion tokens (82 of them reasoning), $0.00007.
- `mistralai/mistral-small-2603`: served only by Mistral, from a pool shared with other OpenRouter users. Three of four probes, 30 seconds apart, returned HTTP 429 ("temporarily rate-limited upstream"). The fourth returned a valid reply under the strict schema.

## Runner changes, made before any call to the new models

- **A call that gets no reply writes no row** ([`client.NoReply`](client.py), [`run.py`](run.py)). Until now, a call whose eight attempts all failed wrote an invalid row, whether the model had replied or not. Now, if no attempt got a reply (rate limits or the network), the runner writes no row and moves on, and a later run makes the call again. A reply that never came is not a judgment, so it should not count toward a model's invalid share, the share the validity rule (V) reads. A model that does reply but fails validity on all eight attempts still writes an invalid row, as before. Standpoint 0 under the second addendum had no invalid row, so nothing already recorded is affected.
- **Mistral runs four calls at a time** instead of eight, against its shared upstream limit. Pace changes no item and no order.

## If a new model cannot be used

If either new model fails at standpoint 0, the next cheapest current model of a family not yet in the design replaces it. Candidates on the public list today are `xiaomi/mimo-v2.6-flash` ($0.14 / $0.28) and `nvidia/nemotron-3.5-lightning` ($0.07 / $0.20). Failing means one of three things:
- it is not served to this account;
- the runner stops it on an error;
- more than 5% of its standpoint-0 rows are invalid, the validity rule's threshold, judged from the validity flags alone.

The replacement is recorded in a dated note below before its first call. The failed model's rows are kept as Meta's are.

## Budget

The stop rule is kept: if the projected total again passes about $10, the run stops and the projection goes to Ren.

1. The two new models run standpoint 0 (`run.py --through 0 --models qwen/qwen3.8-flash mistralai/mistral-small-2603`).
2. The projection is each configured model's standpoint-0 cost × 1,920 / 112, plus what was already spent on the models outside the configuration ([`run.project`](run.py)). It reads costs only.
3. If the projection is at most $10, all six run to the end.

The guard (`budget_usd`, $10) counts every row's reported cost, the models outside the configuration included.

## End of the run

Unchanged: the run ends when every configured model has every presentation, or seven days after the first experimental call (about 2026-10-27T21:39Z), whichever comes first. No verdict and no measure is computed before it ends.

## Boundary

- Five valuers (DeepSeek, GLM, Qwen, OpenAI, Mistral) are families other than the one that built the theory. Claude Haiku is the theory's own family, and the pooled rules are also reported without it, as in the second addendum.
- Six families from three regions are more varied than the second addendum's set, but still few valuers.
- They are small, fast models, all at low reasoning effort. Their agreement shows what these models share under sixteen standpoints, not what valuers in general share.
- Human valuers remain the test that would separate the account from what current models share.

## Notes before the new models' first calls

**21 October, 05:36 (+07): Mistral not served at a usable rate; Nemotron replaces it.**

- *Mistral.* Standpoint 0 for the two new models started at about 05:04. Mistral replied four times in the first minute (all four valid). For the next thirty minutes it gave no reply: every attempt returned HTTP 429, "temporarily rate-limited upstream". Its only provider is Mistral, through a pool shared by every key without its own Mistral key ("add your own key to accumulate your rate limits"). At that pace its 1,920 calls cannot finish within the run's seven days.
- *Rule applied.* That is a model not served to this account, judged from availability alone, so the rule above applies. The stage was stopped at 05:35. Mistral's four rows are kept and committed outside the analysed design, as Meta's are.
- *Qwen* had finished standpoint 0 (112 valid of 112).
- *Replacement.* The cheapest current model of a family not yet in the design is `nvidia/nemotron-3.5-lightning`: listed 11 Aug 2026 (UTC), $0.07 / $0.20 per million tokens, structured outputs, reasoning and seed, served by four providers. It replaces Mistral, with eight calls at a time like the others.
- *Its check* ([`check.py`](check.py)'s test prompt, not the experiment's) returned a valid reply under the strict schema with low reasoning, served by CoreWeave. It took 53 prompt and 1,175 completion tokens (1,142 of them reasoning) and cost $0.00024.
- *Valuers now.* DeepSeek, GLM, Qwen (China); GPT-6 luna, Claude Haiku, Nemotron (United States). That is six families from two regions; the European family is lost.
- *What runs next.* Nemotron runs every standpoint, standpoint 0 first, under the same stop rule. The projection then counts Mistral's spend among the models outside the configuration. No judgment of any model has been read.
