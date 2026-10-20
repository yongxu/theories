# Second addendum to the VD1 freeze: four model families through OpenRouter, 21 October 2026

AI-written (the VD1 session). Committed before any experimental model call. It supersedes the first addendum ([PREDICTIONS-ADDENDUM-2026-10-21.md](PREDICTIONS-ADDENDUM-2026-10-21.md), kept and marked superseded), whose Claude runs were never made. Against the freeze `c56f3f8d2` ([PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md)) it changes three things: the valuers, how they are called, and how a run cut short is analysed. The predictions, thresholds, items, prompts and the other verdict rules are unchanged.

## Why

- The freeze's OpenAI account had no credit (`insufficient_quota`).
- The first addendum's Claude models were all at the plan's weekly limit.
- No experimental call was made under either.
- Ren then replaced "Claude only" with a new instruction, relayed on 21 October by the session that started this one: run VD1 through OpenRouter on DeepSeek and MiniMax, the latest flash models.
- Ren added, in this session: "if you want to add more models - open ai router has gpt luna 6.1, and claude haiku". The design takes both, which restores the freeze's four models and 64 valuers.

## What changes

**Valuers.** Four models from four families, pinned by OpenRouter ID. All were checked against OpenRouter's public model list on 21 October:

| Model | Listed | Price per million tokens (in / out) | Notes |
|---|---|---|---|
| `deepseek/deepseek-v4.1-flash-1017` | 17 Oct 2026 | $0.15 / $0.60 | newest DeepSeek flash; structured outputs and seed |
| `minimax/minimax-m3.1-flash:free` | 19 Oct 2026 | free | newest MiniMax flash, listed only as the free variant; `response_format` but no structured outputs or seed listed |
| `openai/gpt-6-luna` | 22 Sep 2026 | $0.10 / $0.50 | OpenRouter lists no 6.1 luna (6.1 is listed only as `gpt-6.1-sol`), so the newest luna is pinned; structured outputs and seed |
| `anthropic/claude-haiku-5.5` | 7 Oct 2026 | $0.10 / $0.50 | structured outputs; no seed listed |

With sixteen standpoints there are 64 valuers, as in the freeze. Each model makes 1,792 main and 128 replicate calls, 7,680 in all. The paid three cost about $2 at these prices.

**Calls** ([`client.OpenRouterClient`](client.py)). Each judgment is one stateless chat completion, with the standpoint as the system prompt and the item as the user message:
- `response_format`: the item's strict JSON schema.
- `reasoning`: `{"effort": "low", "exclude": true}`.
- `max_tokens`: 4000.
- A seed is sent where the model lists one.

The reply is parsed as JSON and validated against the item's labels. Each row records the model and provider OpenRouter reports, and the usage with its cost.

The key is read from `OPENROUTER_API_KEY` in Ren's interactive zsh (`zsh -ic`). It is sent only in the Authorization header, and never printed, logged, written or committed.

**Pace and caps** ([`run.py`](run.py)):
- Each model has its own queue in standpoint order: standpoint 0's 112 pairs, then standpoint 1's, and so on, the replicates last.
- MiniMax's free variant is paced at 18 calls a minute, under OpenRouter's documented 20.
- A model that reaches a daily cap stops, and a later run resumes it where it stopped; nothing already judged is repeated.
- The paid models run eight calls at a time.

**End of the run, and no early look.** The run ends when every model has every presentation, or seven days after the first experimental call, whichever comes first. No verdict and no measure is computed before it ends.

**The design analysed** ([`analyze.design`](analyze.py)). This is fixed from completeness alone, never from what any judgment says.
- For every subset of the four models with at least two, take the standpoints complete for all of them (every main-design pair judged validly), cut to a multiple of four; that gives k.
- A subset is admissible when k is at least 8 and models × k, the judgments each pair's D rests on, is at least 24.
- The admissible subset with the most judgments per pair is analysed. Ties go to more models, then to the earlier models in the configuration.
- A model left out is reported as not in the design, and its rows are kept as measurements.
- A1, A2 and R1 are judged for each analysed model and pass only if they pass for all of them. The pooled rules are judged on the analysed design.

This replaces the first addendum's floor. With all four models complete it changes nothing. If MiniMax's daily cap leaves it behind, the rule decides whether to analyse fewer standpoints with it or more standpoints without it.

**A measurement without verdict.** The pooled rules are also computed on the analysed design without `anthropic/claude-haiku-5.5`, the family that built the theory, and reported beside the verdicts.

## What does not change

- The frames, standpoints, pairs, counterbalancing and prompts: [`frames.py`](frames.py) is byte-identical to the freeze. The SHA-256 of every system prompt, user prompt and schema of the 1,920 presentations, in order, is `4e15882cecc79791198f9dc71ff53ac8115adec9002405a6ec9eb2894ab1b3d6`.
- The predictions A1, A2, R1, L1–L4 and K1, their thresholds, D, the read relation, the validity rule and the measurements without prediction.

## Power

With all four models complete, each pair's D rests on 64 judgments, as frozen: a standard error of 0.050 at D = 0.2.

If MiniMax is left out after completing too little, three models over sixteen standpoints give 48 (0.058). The design rule's floor of 24 judgments gives 0.082.

A1 has 512 W1 and W2 judgments per model with sixteen standpoints, which allows 15 violations at 0.03.

Fewer judgments per pair make the frame counts of L1 and L2 noisier, so a true locus effect is more likely to be missed. A pass loses nothing.

## Checks before the first experimental call (non-experimental)

For each model, one call with a test prompt that is not the experiment's, checking that:
- the schema is accepted and the reply parses;
- the reasoning setting is accepted.

The account's limits are also read: OpenRouter's key endpoint gives the free tier, credits and rate limits, and no key material is printed.

If a model rejects a strict JSON schema, it is sent `{"type": "json_object"}` instead. The prompt already names every field, and the reply is validated the same way. Any such change is recorded in a dated note below, before that model's first experimental call.

## Boundary: four families, one of them the theory's

- Three valuers (DeepSeek, MiniMax, OpenAI) are families other than the one that built the theory. Neither the items nor the theory came from their training, which is better for independence than Claude alone.
- The fourth, Claude Haiku, is the theory's own family; the items were written by a Claude session. The measurement without it shows how much the pooled result depends on it.
- Four families are still few valuers. Their agreement shows what these four models share under sixteen standpoints, not what valuers in general share, and it could come from training common to current models.
- All are small, fast models with low reasoning effort. The MiniMax model is a free variant, served by whichever provider OpenRouter chooses.
- Human valuers remain the test that would separate the account from what current models share.

## Notes before the first experimental call

(None yet.)
