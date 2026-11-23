# Phase 0: Lossless Context Compaction and Single-Telling Workflow (23 November 2026)

*AI-written study record (23 November 2026). Executed on Ren's `"let's start"` ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-23-start-three-layer-roadmap.md)), implementing Row DJ's context-size diagnosis ([the note](../dj-a-line-on-a-stock/the-size-of-the-context-2026-11-23/NOTE.md)) under the tooling constraints verified against `tools/research/`.*

## What changed

1. **Archived verbatim from `main` at `e2dcc5ce5`:**
   - `_process/DIRECTION.md` (135,775 bytes) → `_process/history/direction/2026-11-15_to_2026-11-23.md` (136,153 bytes, under `history/` so `paths.py` marks it historical).
   - `_process/BECOMING-WORKBOARD.md` (281,021 bytes) → `_process/history/workboard/2026-11.md` (282,990 bytes, strictly `< 1 MiB` so live links to it never trigger `oversized_links['new']` against the 1.70 MB October archive).
2. **Replaced with compact live fronts:**
   - `_process/DIRECTION.md` reduced to a ~5 KB live front reflecting the Three-Layer Direction (Alignment Theory of Coupled Adaptive Systems, 0-axiom premise ledger + open periphery where needed, Wisdom/生生 beside dynamics) and Phase 0–3 roadmap, preserving `## What we are trying next` for `_process/goals/theory-of-becoming.json`.
   - `_process/BECOMING-WORKBOARD.md` compacted while preserving all five gate-checked headings (`## Rules`, `## Now`, `## Open claims`, `## Landing queue`, `## Decisions pending Ren`), required anchors (`#decisions-pending-ren`, `#落地队列--landing-queue`, `#batched-precision-pass-next-edition`), and the single `- **Queue:**` line, and adding claims **P1A** and **P1B**.
3. **Single-telling landing policy adopted:**
   - `theories/becoming/results/records/<id>.json` is the sole prose statement of premises and boundaries for new landings; `Becoming.lean` uses 1-line bullets preserving `(L\d)` layer tags (`theory_graph.py:117-119`); `becoming/README.md` and `regions.json` notes shrink to 1-line pointers; `check_becoming.py` `SCOPE` is no longer extended; `theories/becoming/results/map/` is frozen against manual edits.

## Verification

- `verify_lossless.py.txt` checks that every non-empty line/paragraph of `e2dcc5ce5:_process/DIRECTION.md` and `e2dcc5ce5:_process/BECOMING-WORKBOARD.md` appears verbatim in its respective archive file, and that both archive files sit under `history/` and below `1,048,576` bytes.
- Gate run on this landing uses `GATE_BOARD_REWRITE` for the intentional `> 20%` board compaction (`tools/research/gate.py:681-714`).
