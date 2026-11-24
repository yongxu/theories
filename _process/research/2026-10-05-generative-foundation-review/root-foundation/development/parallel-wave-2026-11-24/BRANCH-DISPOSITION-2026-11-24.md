# Branch and worktree disposition, 24 November 2026

*AI-written (wave3-integrator, 24 November 2026). Local Mac only; nothing pushed. It records what `git` showed on this date against `main` at `c2151efa8`. It is a status note, not a result.*

| Branch (worktree) | Tip | Against `main` | Disposition |
|---|---|---|---|
| `wave3-spec-duality-finish` | `44fb1a7f9` (commits `854957659`, `44fb1a7f9`; first built as `49910e7a1`, `6f0a2bc84` on the older base `c35573bd0`) | 2 ahead, 0 behind, merge base is `main` | **Integrated.** Taken by fast-forward onto `main`'s tip, then joined by `TrackBKrylovBridge` on `swarm-wave3-integrator-9bffd053`. |
| `landing1-cleanup-a1` | `53f9cf598` | 0 ahead (28 behind); ancestor of `main` | **Already landed.** Nothing to take. |
| `landing2-track-b` | `3469a61e5` | 0 ahead (2 behind); ancestor of `main` | **Already landed.** Nothing to take. |
| `inquiry-before-commitment` | `d749af845` | 5 ahead, merge base `adae7bd3f` | **Parked; do not merge onto `main`.** Ren questioned the study's value for the full map; the study and its draft catalogue entry stay on this branch ([workboard history, November](../../../../../history/workboard/2026-11.md)). |
| `hard-unknowns-pillar-a` (`/Users/ren/theories/.claude/worktrees/integrator-main`) | `0397c5edd` | 0 ahead; ancestor of `main` | **Active sibling worktree, left alone.** It holds uncommitted work (`experiments/hard-unknowns/` and a `hard-unknowns-2026-11-24/` development folder). Not read, edited or built from here; Frontier 2 runs on its own branch, `swarm-f2-lean-builder-df516102`. |

## What the integration checked

- The two `wave3-spec-duality-finish` commits have the same patch as `49910e7a1` and `6f0a2bc84` (compared by added and removed lines), now on `main`'s current tip.
- `TrackBKrylovBridge.lean` (in `lean/consequence-duality/`) is new and edits neither `DualityBridges.lean` nor `SurvivalDistinguishability.lean`. It proves `DualityBridges.survVec = SurvivalDistinguishability.survVec` word by word, states `finite_krylov_zero_minimax_radius` on Track B's `survVec`, lifts short-word agreement of the duality-side vectors to all words through Track B's headline (#14), and instantiates the zero-gap pair on `countdownK n`.
- Its checker is `check_trackb_krylov_bridge.py`; the receipt is `trackb-krylov-bridge-verification.json`. Results are in the commit message and the coordinator report.

## What this does not show

- That the bridge adds any claim beyond the two modules it joins: it says their two definitions of one vector agree, and what follows.
- That a real system's survival queries are finite-state Markov operators (a recognition, Rule 2, not a proof).
- Anything about `hard-unknowns-pillar-a` beyond its tip and the fact that it holds uncommitted files.
