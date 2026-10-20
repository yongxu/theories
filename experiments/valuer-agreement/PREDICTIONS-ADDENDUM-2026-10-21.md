# Addendum to the VD1 freeze: Claude models through headless Claude Code, 21 October 2026

**Superseded before any call** by the [second addendum](PREDICTIONS-ADDENDUM-2-2026-10-21.md): no Claude run was made (every Claude model was at the plan's weekly limit), and Ren replaced "Claude only" with models through OpenRouter. Kept as written.

AI-written (the VD1 session). Committed before any experimental model call, after the freeze `c56f3f8d2` ([PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md)). It changes the valuers and how they are called, and adds a stopping rule. The predictions, thresholds, items, prompts and the other verdict rules are unchanged.

## Why

The freeze's API parameter check found the OpenAI account without credit: HTTP 429, `insufficient_quota`. No model output was received. Asked how to proceed, Ren answered "Claude only" (relayed on 21 October by the session that started this one, as its answer to the question this session sent). So the valuers are Claude models, called through headless Claude Code on Ren's plan.

## What changes

- **Valuers.** Three models replace the four OpenAI models: `claude-haiku-5-5`, `claude-sonnet-5-5`, `claude-opus-5-5` ([`run.py`](run.py), `CONFIG`). The sixteen standpoints are unchanged, so there are 48 valuers instead of 64. That makes 5,376 main calls and 384 replicate calls, 5,760 in all.
- **Calls** ([`client.ClaudeCLIClient`](client.py)). Each judgment is one stateless call:

  `claude -p --model M --system-prompt <standpoint> --safe-mode --tools "" --strict-mcp-config --no-session-persistence --effort low --json-schema <the item's schema> --output-format json`

  The item's text goes on standard input. The call runs from an empty temporary directory, without the variables that tie a child process to the desktop host's session messaging. The standpoint is the whole system prompt.
  - `--safe-mode` drops CLAUDE.md, skills, plugins, hooks and MCP servers.
  - The CLI takes no seed, so sampling is at its default.
  - The executable is the desktop app's bundled Claude Code (2.1.299 today, `CLAUDE_CODE_EXECPATH`, or `VD1_CLAUDE` if set). The installed CLI (2.1.220) does not support `claude-opus-5-5`.
  - Each row records the model the CLI reports, its usage and its cost estimate.
- **Order and stopping** ([`run.py`](run.py)). Calls go in standpoint order: standpoint 0's 112 pairs for every model, then standpoint 1's, and so on, the replicates last. If the plan's usage limit stops a call, no further call is made.
- **Reduced design** ([`analyze.py`](analyze.py)). This is added to the verdict rules before any call.
  - A standpoint is complete when every model has a valid main-design judgment of each of its 112 pairs.
  - The analysis uses the complete standpoints, cut to a multiple of four by dropping the highest-numbered; order and framing are balanced within each block of four.
  - With at least eight standpoints, every rule applies with its thresholds unchanged. With fewer, every prediction is untested.
  - A run stopped by the limit leaves a prefix of complete standpoints. It may be resumed after the next reset; resumed calls fill the remaining standpoints in the same order, and nothing already judged is repeated.

## What does not change

- The frames, standpoints, pairs, counterbalancing and prompts: [`frames.py`](frames.py) is byte-identical to the freeze. The SHA-256 of every system prompt, user prompt and schema of the 1,920 presentations, in order, is `4e15882cecc79791198f9dc71ff53ac8115adec9002405a6ec9eb2894ab1b3d6`.
- The predictions A1, A2, R1, L1–L4 and K1, their thresholds, D, the read relation, the validity rule, and the measurements without prediction.
- A1, A2 and R1 are judged for each of the three models and pass only if they pass for all three.

## State of the plan at the addendum

A one-word, non-experimental test call to each of `claude-opus-5-5`, `claude-sonnet-5-5`, `claude-haiku-5-5` and `claude-fable-5-1` returned the weekly limit: "You've hit your weekly limit · resets Oct 24 at 6am (Asia/Bangkok)". No output was received, so the runs wait for the reset.

Before the first experimental call, two non-experimental checks per model:
1. The parameter check: the schema output is returned and parsed, and `--effort low` is accepted.
2. A context check: the model, under a neutral system prompt, lists any instructions or context it has besides the message. This confirms that a valuer sees only its standpoint and the item.

If a model rejects `--effort low`, it runs at its default effort. That change is recorded in a dated note here before its first experimental call.

## Power

- With 48 valuers, a pair's D rests on 48 judgments instead of 64. At D = 0.2 its standard error rises from 0.050 to 0.058.
- The reduced design's floor, eight standpoints, gives 24 judgments per pair, a standard error of 0.082.
- A1 has 512 W1 and W2 judgments per model with sixteen standpoints, and 256 with eight. At 0.03 that allows 15 and 7 violations.
- L1 and L2 count frames where the mixed pair's D exceeds the widening's. With fewer judgments per pair, noise moves those counts more, so a true locus effect is more likely to be missed. A pass loses nothing.

## Boundary: one model family

- All valuers are one model family, the same family that built the theory. This session, which wrote the frames and computed their structure, is `claude-opus-5-5`, one of the three valuers.
- Agreement among them shows what this family's models share under sixteen standpoints. It does not show what valuers in general share. Their agreement on widening and disagreement on mixed pairs could come from shared training as much as from shared positive weights.
- So a pass is weaker evidence than the freeze's design (four models from another developer, two generations) would have given. A failure is not weakened.
- The valuers see no hypothesis, class or label; only the standpoint and the item.
- Human valuers, or models from other developers, remain the test that would separate the account from the family's shared training.
